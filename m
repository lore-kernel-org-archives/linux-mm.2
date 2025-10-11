Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC5A1CCA476
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 18:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DD98E000D; Sat, 11 Oct 2025 14:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154288E0002; Sat, 11 Oct 2025 14:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091B68E000D; Sat, 11 Oct 2025 14:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7ECC8E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 14:39:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A772011ABA5
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:39:11 +0000 (UTC)
X-FDA: 83986695702.01.A73E3F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5818140002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:39:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pI6ooHSW;
	spf=pass (imf09.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760207949; a=rsa-sha256;
	cv=none;
	b=4LV+Ww4eXlkR6OqboNdwRZ3si4w+DEXo5XjX/rUVmoBlK4TB74SgTXQosdhR9Px+6KfOLm
	TAuf+fhgsfJ9/FCUsikgI228r5M0LT5OdRHj7ZAiwNr87Fp5SHIzDEP61XgmEoP3voY1mH
	+LxL4Z2RWoCZMuRhrcF0I5EUwmyAvBs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pI6ooHSW;
	spf=pass (imf09.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760207949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=WkkjFKUK1gUeTI1ZlEihuytMR+/VJ0H0WJuNTIulvv4=;
	b=4mlIwzq+U15lIQIk12/IHbGZqOLQpXa3RgWIvLU3lvht1jzQmWqORBdin9tJEU4Yg514cU
	hFdbYxfvo8/X1KcWgCmz4TvfnDQup95ArLW56a7oTBcyvMcKBRb8X/y/9HS5LaoPURttJ7
	7F83o6qpjFU8vCQ6aCzQgt6Dz2ps8Fc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3E29424C9;
	Sat, 11 Oct 2025 18:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEDAC4CEF4;
	Sat, 11 Oct 2025 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760207948;
	bh=KAgZNqLRf6v402fttGAcQQ8JplK5/o1bJIvo50jWFZw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pI6ooHSWAe61lHVuvpCcXL83TGGhCbbfwa81ake47VktMhrjPXtsQxzrdzjpN/io4
	 S8925DkgALTzkjQfxuSNYuyOod1Zzgkh8IuaXBsCRw1WKawzQ/CWuiTF/EjIl4KFau
	 bFVPaYLuutmE+pHvfCyvA8ZdSFSmUvkRCsDYcIB0y0kIx7OB6Z4m/H7kJZyf5tEnCb
	 lN62MH3wPikF66VaRESMX8WOdPdS2lpF/3CUGNNauPXxjWH9IZ7ME/ydLtVAqvas4R
	 beMEtkiEJ/gSmZFJTOrDqmqsw0Ce2ZKbBgfVF4rqahf6+7UII/6yNFkVnp1Y3zKoK9
	 zWySNWCdB+atA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 957993809A18;
	Sat, 11 Oct 2025 18:38:56 +0000 (UTC)
Subject: Re: [GIT PULL] slab hotfix for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <903ea271-9413-40ed-93cd-104062c18a84@suse.cz>
References: <903ea271-9413-40ed-93cd-104062c18a84@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <903ea271-9413-40ed-93cd-104062c18a84@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc1-hotfix
X-PR-Tracked-Commit-Id: fd6db58867924d2bfbc4ece4b0092f697f9fc31c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6bb71f0fe57bb77ca484352a66aeb02e3a8ce697
Message-Id: <176020793526.1422231.5596134982561087922.pr-tracker-bot@kernel.org>
Date: Sat, 11 Oct 2025 18:38:55 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Phil Auld <pauld@redhat.com>
X-Rspam-User: 
X-Stat-Signature: mzuhe3ae8m5rm5wzgp94a61hpzmdbc1q
X-Rspamd-Queue-Id: C5818140002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760207949-875807
X-HE-Meta: U2FsdGVkX1/d0Y9t/SXBkfHTwXEJHeEE/D1js6bmeill976HrScITsBwOUrM5CADmt6gFqYHU6gJthK9qUBXlP0ogP/hxQYZ+Lw+OSgd2orb391PnnZW4xc/H4WTidctXiRxpXNJYIj50WUailTRey0BFNYRO9KEko1yG5++hnuGwOmkBeP2C6z9y3oW0AG4aJHGD88fFsfwQ5nsPsqc7nuroL5CjgkKl/gBp3KYaactAQO8wNxR7TjO9tzWp8C0hjWtHnwjDmJFDA2HbQq+qzTq54A0MsZ9raQzp/YKBIfAjRWtjv8azR8QkVpSTLbIfxKxYSE6iCODUTJg38B92xPddU5YY9a5fRmcGKuHepX8KQBuV9sUt0qwk0uOYbnXA6tO1n3I6w3jMi33OJQ6FLQl61Jxcuorbg4fE2kE7ZGdkwJpb20rzrZHI8oeAb6V7sKVrcQAyq2oFr025fcc7On79otFdp41jlWEEnhgaR+MrpO5gSJV6aSqmkrRKxABwHCUs9lBvY3c8D5++anEeWvWoRZdauujueju1hG3cFL3LSo4Gq12uRWKOMKddoOiD4EQkOOEHxzamEzljDlXUg9WQMwBa4FGzLT1yBV9IQLUy/IWvwTfRyFSIWIh+ll5le3dXRVCLxKKwX8/HqmiN8Dg4GRyXnJ4/1TXmLEehgFjLzZYFZKX2tipp+PwRHmAXTF/Echl89JECnjhUWUQKmVQLUrDtIVXXVLsyvTAjVj72+WEzZhhVt08n3rU6CIFi9SBsiG2mg+t3tDKjt0Jz00e9EBmkZDFQtuQlronuqAL+GfSaebxPNwWUohTG8GyehcYbOg6VjgjkcWaJW3cevHWx7kOi6xbXBcBtvXYcAk06QEH5huURO4p89qMCKrkBwBL/e+mShi0nXlgmu8z0XPi+7kGx/n7vz3F3EV8cfByfNMfVDQDvLg3saE19Fx6hobyHr12hCRnRNIyGi5
 M83J7iCW
 itBQUc8Z7MKh1RA9MN3OLSpJGTYpUQ+QvUYDMxS3bshDfCPbeLuKvSXER7cSHgnWbAkzmuP5eQBf+El3vJ42gx4wJOMdzkobQmgR4HHCleKGg8CIZgKT6hjE0BZNWUpDoa6xK12sS36UGcA7iebCY6CJYc4YwDNpdnQ/c86t0svCzbpNNcYZGmXU5JgMsy/zPXNpGHtJauL28ZlqkCa0E7XU/FT6AXkPomXwmI2FTkm2Pe5MwykfJa0BIgJ44w7DPNbIxUrAndA1yxv6oEJLJPmQvyuVBoRCBn865fFR1eCO3ajI8cRbdHuRGfYEL/F+nu069
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 11 Oct 2025 11:01:40 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc1-hotfix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6bb71f0fe57bb77ca484352a66aeb02e3a8ce697

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

