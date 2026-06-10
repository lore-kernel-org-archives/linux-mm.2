Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A8ECD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4E96B0005; Tue,  9 Jun 2026 20:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C356B0088; Tue,  9 Jun 2026 20:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D98B6B008A; Tue,  9 Jun 2026 20:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C67C6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:06:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE54E918E3
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:06:01 +0000 (UTC)
X-FDA: 84862060122.05.7522EEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D25A5C0009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:05:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDPD1E7X;
	spf=pass (imf28.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781049959;
	b=moGGwHubbS55qzcvPmoDWyv2/DGmrEYuS7kiSEzTaFSyE2ejQNkKbQsnJZh4lcGf7/v0C6
	9DfXAFsZ1siuCpamqU8gE48MpHCwlQqaPCx5vm2F2U1T4DVLViBYcWxmmWRHP8xRMYHHQK
	LETfwTGsmkNmk4WuWCc/Pv4eP6iw7G4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDPD1E7X;
	spf=pass (imf28.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781049959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=U2oWTyRfuyBQWmZNU0N5t+zo4Nu31fPKtsscZI06t58=;
	b=DEVyXdmDChHvQXi0gshnjoGEoAga91aQ9WL2P3tnIjj/Efx0sAstGu3vxPtWOWlu4Rfh/m
	1tovINeduE3J6rHBMUtko6m1MMRS4Plj3hGbLkStLX7UKn5TdmyZwbbDeZAiQEyJyVAC1R
	XqAXBUEWLUPNHa3jg3RSBgrs85Cr7IA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C83C3409B2;
	Wed, 10 Jun 2026 00:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83151F00893;
	Wed, 10 Jun 2026 00:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781049958;
	bh=U2oWTyRfuyBQWmZNU0N5t+zo4Nu31fPKtsscZI06t58=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=BDPD1E7X9MYJxio/V5ZunaDH7m7HpkFOzcciIEAxkWdCS53+d9M4nQ39f8V4qyqso
	 /Vqceq/FHZ8aP5rK9Z74Fam4PAZe8GCe84ibcchf0fYXoSOLgEQsimF1nwW0erd8N1
	 1jGRBtpNJMxv1lLvbheaOcUp2qJYsu1+y1M2YExrVmmGjhe6sWjr1Vztrl3oYzdSj/
	 Lc0T7Xg2DYRWON6BC5/J9n9wQAPmGER9RXZg/UwU7qWOk7O2xmKJN8+chmUNYP9FUh
	 nFfWBTgbHgxLLdd/yKDRKAT0d01mle4IwlbmNi/H0R8o3UY6/0djhU6eGwxvPArcZt
	 MfE29CULB7Zdg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198DE3930A0F;
	Wed, 10 Jun 2026 00:05:58 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 7.1-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260608205426.3319be94a327307e23b34f3b@linux-foundation.org>
References: <20260608205426.3319be94a327307e23b34f3b@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260608205426.3319be94a327307e23b34f3b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-08-20-51
X-PR-Tracked-Commit-Id: 0c25b8734367574e21aeb8468c2e522713134da7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 685441a6d3f17404b47087d051963bc7fb665ef0
Message-Id: <178104995669.2756347.12777254541134916583.pr-tracker-bot@kernel.org>
Date: Wed, 10 Jun 2026 00:05:56 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: D25A5C0009
X-Stat-Signature: 8d9hqf4yy5cqxt1e5ratdo6ftfyqkfau
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781049959-753534
X-HE-Meta: U2FsdGVkX18w90P4rHle16puqxrbK7rPvslm5J/TVCUgenZST/HfnXMuGGPhl6nK31wW5LDab+epjTtdQbIMRTjWbZDEfizBkgVUSGB/1yPYk85ao8f4y6htQsQANLhyyAJtDfoTRCTatwBrQ8VE5Jcl5wd2aKzlfyTgiWXeTm8f95yIXC6lHWnOhyHLmbCU6Tci10w+rR5dz0RJASNeWs+IlsH/2kWqHfshbRV1uDWegCga3FDY1QWEIatun0Dj+977uQIJcHNcCN0BnQ8crjRCdT/jVPRciH7OeO5DADBO1SUP9sPR62Py7IBhCzYxdTm7jD7Zx5NdX2yhscZ2XdjUQ75aYAeTavO0zPU8xlbfK8CSC24Mnc4UiHBUvAfXQru2ZI18cGEChTyIROD2dL5m6CmDe4Bv3QQJlv4uePnY/s89e8lkrFaXlY+LglZWm8buHELa61FJJY0lWZvPv+gUfBURDHe8DnGAwQuvQXN5s4Tlbu3vbtMMG/wQMsYTXpycLqLvU/dHd+6NYRL61MADr8jaKgE3Elwr8D+hHcWE6PeeECWJZ7cs6KT38EH+bJVkm6rc15fWOQpkc9zP4ix5q/3YpqzEaBzjKaFqqrcz9N8GLgXR9+aykmNUTqgNzaIV66rUtRnFldRztXXJD8PtjkvoVGTxA91saWo7litxx+xMX54pn5FpdXc37E24vlSfREjVCQ4P9wwQM8/BcpXd7B9UXGWBWkUuKksZCeF8lFY+hIkJ+Mmrc9yTamI6J3REMprG2Ny+UrwjzAfnyhmSuG2QAh3XMx+Q6PH9iSmr7gFPZy399cDnsoVOc8Uxm1Io7lCb7fLC3tsgBDapo2jvdszA9+wi21UW79KY5oh5z1CARxzdnzMLXLCHqPy1kJFaMJ3oNRplnkpUfrYq2ZObgtqHyBlC/GNWB0OZqhLL/e6lqvrzvVOcIB8W0mAAvgsTl/YJgbSfRVb/wlV
 rCniBYQY
 Q8ZRN89oRv10YTMlafWjSHyekrzFPem8LyowG6LLeKPiiu5rIbozZeWQ5ZuP3vKOuswYWSfai/KxcCD5+noTUjQvQDg83CPj+q+XlT9JMKfUF3J4lMdDKotfh1zoSkLIbefxWz9fHd3YRPSUviKQrfY3+HE01E4VIqrbYbY/FY4VC9weuAYBMf2o+XxGOMY37aQdymJzhY5h6I2Zbsf88OMbP8J94SQbNhH6UR7XruQUKId+xvzmylpyCSrfZ9791WbqsnPzRAiPWnR88sVimS7w4qUpviErjXV3ZOwazaM8AjXkEwOmzxbr7/31utKBh0r9/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 8 Jun 2026 20:54:26 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-08-20-51

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/685441a6d3f17404b47087d051963bc7fb665ef0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

