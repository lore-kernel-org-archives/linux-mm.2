Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF19CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 18:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026118E00A5; Thu,  9 Oct 2025 14:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F185B8E0002; Thu,  9 Oct 2025 14:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07CC8E00A5; Thu,  9 Oct 2025 14:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF3638E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:26:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 728401A09A7
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:26:41 +0000 (UTC)
X-FDA: 83979406602.04.A44839C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86137A0019
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:26:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JmnG3O0P;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760034399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=KU5HRNDADD3zDkj3y3YnT6WD6JKlJhchdgI40kAN9jo=;
	b=fthwiVL2+5YS2VdgbdtA9yFuFdZ+FSACHeGyGGvqtQgMRHqsRi9lAli4zzjV0qZCscZiRj
	C75r+x1sM5Wf5WlVSOlhOaLpPGw0DkiD/FxDeMXzL178nv6HJ4+WhiE7nLs5zolaTh0uaj
	gfr1D4J83yrPNEGxSom7iNNs1yJl/V8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JmnG3O0P;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760034399; a=rsa-sha256;
	cv=none;
	b=TpC8MlLg1JvK3aqQ8kMmj+p78OGKcm6SDjTWqecGTYbADa4rSKcvw8FJyekF3OilJaLjry
	n8o+gvjqt/HsVTXec3Tk57cXsuWd53t6HXljPVlyfSUaTuqG34j/iy/fwqK9Lk1vjyDlnO
	x+Y/rL/wCQJi2x5My5TG3SZOL2KwZ54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B7A844D71;
	Thu,  9 Oct 2025 18:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC03C4CEE7;
	Thu,  9 Oct 2025 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760034398;
	bh=UEF4z8j/7wl0UuOCFvHdjudwgZUMGq17X1/dL2f9aaM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JmnG3O0PSMA/yc2wa1hw5xjLnD0YrQHOE3cIGfdFc747xUTsB6Zue7up0bZYnLnxt
	 +14BriRPA29USuRw5ToavPMo7odL42Ui3F+HqRSODqWjSwVSiHmquG4XHLMzSsrwHn
	 ZRR7Whg5gVIHcdEWRTJre5GqE/I1UAT0gxoFpaEmrhOVGsa/TyyY9t/+h5CZaCVd5m
	 yLMXU7OY4kQ83m+4cUt1JYbSjx2MW7jlaCUrWYdnJC4fl1RLKMPQjcy+5zFcaYPofQ
	 ettgjJ1081xOBHOO7+dJNF7/9Rooc0LnNQdUxHTGTtAQJHuzLr8c631U90xQuXJp9P
	 63aDG2ABeyVeQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3409C3A55F9E;
	Thu,  9 Oct 2025 18:26:27 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <9ec4a43b-d016-40b2-996a-e8aa098c0001@suse.cz>
References: <9ec4a43b-d016-40b2-996a-e8aa098c0001@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <9ec4a43b-d016-40b2-996a-e8aa098c0001@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc1
X-PR-Tracked-Commit-Id: f7dfa0f31b13ee5f2ba598cdfcab9a831ed8a6b8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f6db358deaeafd9830c8bcba8f76f55f8a14b059
Message-Id: <176003438570.230640.3897824331505748265.pr-tracker-bot@kernel.org>
Date: Thu, 09 Oct 2025 18:26:25 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>
X-Rspamd-Queue-Id: 86137A0019
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: piyiqfoxtu9f7fdh33nxfmjnyasrcsaq
X-HE-Tag: 1760034399-318328
X-HE-Meta: U2FsdGVkX1/+qpPX/lYCDE1wwcmjFI86mYDm7dmJhUs/nJKtO//Jd5XH7ees1BnKc2LukJKgquZ/UkDWs6Ir9KJSWckKEUN0NvvDJ6NfGibZAIvW4uwCFwXXvsYWEHeyn/R1pW6jTvuJSgjzZBSAfMmpNRJHGlxxtPmh8BCLUGNf7XDcOrAmpYQXE9nNsXxekaqVVN7XSAw5XLUmiRbBQzv8FMydZcl0YJl57PsNo2Dy2cgBRPPzo9hXd5SoyQ4el3GBwWh1t0Ms9DLD6FPcW06YY+wIhKMjK35lU/WceC9J+X+fJU6HHzEtbPY+IgkY9jDVTdI9RT29ngG0eW4BXXdDSZOHibuTPxZksZ26/beEL5MNrZ2Lm52ekWsmjKR1E3vtXrryjV9NlCMKP2NpWhea9ZEaQVd7IdY6yQ+dwMIECXFGnTKVesl0yIVeWfDhudkXaHK5gMf/ctfSnW6ZWW22AYOz+8ATCyDLgfVPjJ31IAvw1ZsCr591++MA9ZLqrV4/o54Iby08R7kcy7q3tbLyc+H8hr41aG9GITkLU49ZgEVALxmKn6X35uKalyeOB25ftO+8JaEdsvidfLempBuyUnGzkHKa36FxLjXBiPrXgijQ28eThw1DK0hTZS++X/45redwu+XeUeDDLl66jQg9KsR3ggmEtDVvQtfwh/ldvMgnvE0kDOf/KQWpajy9ZQvsNA/Jqxxw+tdsTRVQY0CiFXgP4vra5dJhUUGRL7arrX6pkLGzbWmZGbEEfK4HyHLMk8Lxr8csTanuJUKwu+bF0ekTpjXL0LM5c/qMhsuB1ObMCrhwXUYLa4BBf9NHbagVAyIkSbqeg1gJd5a7g1+bHyc6WBtlyhVKsX45yF/1m/2zslAL8AB1to0hARCw8XawjCwJ3/t7jj5V3aM9wpMANBESgjP4Ov8oHQwe74SZNNwOxzB22Z33dICqcY1Jv83QEKsgzosmYKpUAJc
 a90Ejwlx
 bAJ4LnqvX9mGIK6DLL8yHUWG9hQsR2vX7zaa2rcq6rbH4V/nwPNpRAnA5CvzjLupqL7dsVwhM8IQQ3hcvgpl6peNwgY+zPoHR3JxtDpAOjbBU5cWw5KLNYvUY68DMkhk+tFj9yIzmg1VXw1ZeoxO+h0Wnx5U5HE3C/RPyVF1FWmn7JLog+prloPNZcejz3T5QSwzgWsTfwef/Jg34Vjz3X+fZgorh3yzMWDxrJ9jFnSgGwCRpI8671JJBcyfKvASQ47nKRZBLMYZJoPk9C5jSkKfNI4+ZWio2h2gPIt0qGOj88Hx7mMWeJQ478GfpGMSyA+8/4Ixbvn+RQCZ7kmelbuu3wRiMbrKOJ6pbeaNldC6dHdxc6ygqCljpUQ2MSzxF4mj6LBTayGEJZRBMQtda6AvM0WiLyQ1CZ+z8KLVAKdxkWrpf6qcCpW39DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 9 Oct 2025 11:36:21 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f6db358deaeafd9830c8bcba8f76f55f8a14b059

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

