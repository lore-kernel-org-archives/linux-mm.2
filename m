Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE208CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2B56B008A; Tue, 19 May 2026 11:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3625C6B008C; Tue, 19 May 2026 11:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277E36B0092; Tue, 19 May 2026 11:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 185A06B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:05:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD146160557
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:05:18 +0000 (UTC)
X-FDA: 84784492716.12.6D90B47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CC07CA0016
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:05:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RTR49rQl;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=XQZatRt7WVg4omeUv9OgQqsB5YZIMefmXU6LM5GjhhU=;
	b=t81BoPs+KJSy00YrxRJLfrGYHxcppWBY6UfpsdVB8FOnr4glRgNSnL8IMwsY6ZQAdk3Mf/
	driwd9SyGv6sJUgQW6T+UOk69sMUzLVP4rWpfkRLKSY8HoFeQiGTiD1/DY9+vMZ/A3Lzq3
	JyvSLBkhfo9MODj/pAyl4roJvBQVakY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RTR49rQl;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203116; a=rsa-sha256;
	cv=none;
	b=NfYV780WibX1Ve+ieosKdtfBIDwuztAjTLGcbD3ls92lcS4tfgPQcUcFXwMWzCrINyWpsW
	mHesMByJ9KueZk7R8Gv2aDivZfC8BEVS4DuXCrv8uMi7o52XuXOvioc4PHv+uhdvWmNtbx
	jae0jpNJHMCUevXCm8YvcXYsCaoubRA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A8FE40949;
	Tue, 19 May 2026 15:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED0AC2BCB8;
	Tue, 19 May 2026 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779203115;
	bh=p4NLoLqVFXbCPzAsRAwiVxu8kNdq17Ny2ShSQHI/nuU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=RTR49rQlK/G1L4uGzSvuJM0EicTZawT8oxv3+LoUviGNbvAZ6CJpZem/25Nw6E/Ph
	 Tm3J33BNGqJDxkNr9EXM3tlsvXz29ApL3Zg3fHAphwXBmQvhYoLdTr51GDv9x8dqbJ
	 iirO6V9EL+BeYWo7oy3LdqI+5Cb6c6IXyW6Yr44Ps/MdXCKgFPFjDqQyc6hdVODW3N
	 NpIUF2crBrg85INUjHe3a26d1ZY17D3Tv0Oh8knWEFyooIaPCnf9NRt2jsLKLSWrR3
	 knw3C9AFmFN2a25E7vPAEBugvJL+rNTGRcK93r5qqSv8kvduvsUFB11W5qfVEOgYEg
	 pMgYmqs4BpUmA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199EC3930CAC;
	Tue, 19 May 2026 15:05:28 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260518211010.20af3906b324d3e674ed1e61@linux-foundation.org>
References: <20260518211010.20af3906b324d3e674ed1e61@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260518211010.20af3906b324d3e674ed1e61@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-18-21-07
X-PR-Tracked-Commit-Id: be3f38d05cc5a7c3f13e51994c5dd043ab604d28
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c6e99c10fd9855082568cbd71bb2cc5dc90eda53
Message-Id: <177920312675.2759014.16333196484481619763.pr-tracker-bot@kernel.org>
Date: Tue, 19 May 2026 15:05:26 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC07CA0016
X-Stat-Signature: dpm1nzwa87zw9mxc3ptdu7bfghho93qq
X-HE-Tag: 1779203116-167949
X-HE-Meta: U2FsdGVkX1+srQiu+6TA0cGxaKL2i0Au7VgaWIF+UxdCDVI+1TW+JaPOFi+u5nClNYVOz0Ut4+9Tok3BlVS68AzFTakz/j0AzaDg/z/jctscsaeMSXaAeh1dOKrROFWysfw+h3f7gZHKz8lKKEnZ6TlUU9DCfQRpJuKryXEtuy16AdNn2PlLl8zob9cCwd3YzGJBHi7RBrsAg4yFvBXGvHcGWpC13K84pzXfmq/2ubsN8CRW4x6IcSeVnU2gfhe5oGTx4lBZH5rGtnaOHesmZKnMGpsgaiYLnertICkAQ45Htch9hJBo4KHIDzV+k0AGTPGKK40PmBE+cYVnqdqOLOzdrI7S9XpsIt/qP9/6WPLgwZCbOXmhwDxOSRpvHOSz4e6QTJDMqQT2LlgffjgXQlhDDQ5alVkmJomhY+aajNQfIOznk4NhFD6j7x/bQd++aVHiHa5wQG7Bn1hqXoeIaRT3rneWAIsZBl8CUOj6ED4LEkshCugci0DjKWKeqPOhBH4vQyLW+smpkSMa0XekxzBiRmkxTQrjGYSfN6zl84n1h9pFstGKQ5xrJoD8D2qq1XIHMQhKZrluArOkskuoLdxSHElpQWFEckLCCVr1bQRaqRyCiPOZLqN2p85bkIvEMRmsjX9oYQA1rkNew6eoLv+Zn8REQSVH2pwn/8jj7pU7Cnl4I8IEy1/ZQ0tyX1SPpEMd0SU1MmD1luR8b07gqwPEcjPDOFW1kOGdH5qR39SPUECjICWd+hEkyNvfDV1t1S5viD9jG/82r3qOrE+lNx0gM0KYZIGjD2uooZBmhOg6QPr04woBAaS2qmOnebrLZkzparBACK8b2dP6VvsTlMTjU0i1o5ScgHAN8v4triamZTHxdehrrESy41KjfFDDt47Y0GbfM8Zp/2NCJduJguq8t87r3wjabQhOpClye2kQA3G1gg2R9KTVIFMYMEEbfk5Sw4tvMLSqi8/ZzCI
 Y2SOd+Sw
 R6VWdoDTy7i/mmfcjEgGEsL3+OpUg4TJeZ0CCvLPWeepGxINCfEyuT3YfdtaSpxbvXhmXqlgG3YsJkY2nx71go3Lzgn9cyc0clVOQI7loEi2qCzqcZKOLb/tjb8NnIbdujJni6Eb8UcIG0eJT800a+4Ezc1zILWot/avmgJcO4owMptthGh3Le1O9QkCI9f87E7rBpqJ29wAAkSu/B4ajeN8DSGOOy6P5B4rdVMrS6ES6Q/anCgr0BUBNErXBV1+735p6O++JFoRz7uxinYpN6dG9zNyFQn7WVkV7OzwrXFimhOnfl8ZiyKEEd6edag1KozOaLHGYGqWSqhR0ZTPN2pqfJYCDdg4CLX79CbH1SNKwvgDQHmUs3HHOyIeIW3mScKVdXtYXMx4KfbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 18 May 2026 21:10:10 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-18-21-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c6e99c10fd9855082568cbd71bb2cc5dc90eda53

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

