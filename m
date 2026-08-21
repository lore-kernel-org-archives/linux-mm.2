Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE79C5DF88
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D626D6B00A5; Thu, 20 Aug 2026 23:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D121C6B00A6; Thu, 20 Aug 2026 23:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28DD6B00A7; Thu, 20 Aug 2026 23:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1DB86B00A5
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:11:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BB371A0344
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:11:14 +0000 (UTC)
X-FDA: 85123800468.13.94D8A59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E795C000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:11:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edLACQGy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787281872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=huI46asYGhW1cU6sHzdmW2xNyrPSFaE/MtnTwoNiwpU=;
	b=tc2PUs40dA82Pg4lIEDboRTYtGt7I6iOHoRQYspwq2W7PLUCRcfoop95S5xgz5ceAg8tyA
	c347LIO6HlhSWMhHOZ1giy7QXF1SWosmwh/6C2yI5u/2oZ93OsJJNXkO7Mz+34NTCRdiIx
	ME/A5gP3NlkqETHfXxvGyHsjz6uceJ8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edLACQGy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787281872;
	b=mcuyehcY27zwLdxPDZSBtjAkN2tENSSRfnTO4geFGMW/PhVMcLl3QDHeZ4Q/nOaIkspwXQ
	TO4zgUiwf93/UyRdEyfxOiRV09BmeoM+5GLsVgIjEltyKS1VE/mrp9xp3QPStvFIr5LYhS
	izxWq1DC2nnRE7ws2ktN213NDwra8eg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C580243D4B;
	Fri, 21 Aug 2026 03:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E6B1F00ACA;
	Fri, 21 Aug 2026 03:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787281870;
	bh=huI46asYGhW1cU6sHzdmW2xNyrPSFaE/MtnTwoNiwpU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=edLACQGyMXerZN29nMXS29tIJCXltY/wgT5xJgm+kgrPlrGWFhNE+VBTsPFJrOnCM
	 c2Xt2CnvEDMWV/RBpVkSMKGui2uHyNKYus8jltssk1LPaviiRM4lRLxlyZ5DBexOHM
	 dAphSD5Kv2dfBXIgTYoTeK9/BRL+Kdsh74beBKPNdZgwtDmTNVSCWwc9LZT956c0ie
	 DhFD1OvvfwYPA2AXcKhV3XBFb/qRiaX3liOOzm3KYqqfbySZXqYQp4KCpitAuNyP2G
	 o0EJMU8tDK0D2F7/E9dbLCSzOdb8vKOM5KfT7YhTxqDuNEujpaVUPwJpHHTgpWsL2A
	 G9cq/+n5qt+XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D4F2E3924A4D;
	Fri, 21 Aug 2026 03:10:21 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260819213548.4160b501de0b9ab41029cfcf@linux-foundation.org>
References: <20260819213548.4160b501de0b9ab41029cfcf@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260819213548.4160b501de0b9ab41029cfcf@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-19-21-33
X-PR-Tracked-Commit-Id: aedf2efd18977e0cef7eb963166e2b1fcc0aa321
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8dbbc7e188949b6e1f6be4e82a44dd1d8b1d6c8b
Message-Id: <178728182060.600189.10570474833709100570.pr-tracker-bot@kernel.org>
Date: Fri, 21 Aug 2026 03:10:20 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E795C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: uc89nczts65okfuxophtg9crhaip7doh
X-HE-Tag: 1787281872-164227
X-HE-Meta: U2FsdGVkX18mKSijLV+dwJRT407QNDF3cwqO7tq0AuEJ7j3+FS1/VXrQrKGUTP2rHuZWDwZH7pGbrMqG/Ov35GyMCiAqLN7MhBAW79+vMbUbp9MDeMlYdKzfoC6j8mTYnjcmXl6nVxYdWNKDggQlAoM4D7v6O5IsigGUfgtZVjsAjD0yWVxGHnrH1PseU/hHbo6oRPn3dwgZLTMogIAgou24RTmghnR0L3ts2W0pY0a5JmrZ+vCXx4WEAYUrmn3gR4pv2O+O0kFP5u9g7DdbwxrCCFTd3aScE1GXLG2SOTBwr2jhjb63t6Kp77XZLLb333EnAbdPkuhsApMUnNPSK7bao7PvSXklMetrIIF5ASQbxFDgpm/nGSMXomqZhwrnW92ESgGjnqmU0DCYEcTEOqFbnQLthg2MPiAlIArsr0zRPsvD+t+2JXCBVfzKpZskcdyBk/R0wcieB5Ai6SlFuVpTzrlIFismpEHKCsuXxkaC77e3/tzkSqDgac+dYwm+Cr0j52NZeTCrCQDwsp+vrjNZjEtuH//TH1TVHoHhkVhqSMnBXszF7QhpbWesZk4wWYDc4FxhYTcIqm8+IWgVeT5bbUypNuy+hVRzJ0ij64Ab0FDms6BraiRpypE6+BTvE0b1IDh+3Cptdg05l19o8+6adriZLMTGw0aYX9BgR1wDKDSJlADv4xkj+SOXbhJdSz9oxE/QZMNaRCOiF8hJ/hOLgEqGwin3YORNbVkAxxVQKN2MPBg8r3bpBglitcCWtAICCrHDmNW6O3ysefHH3xv76BAR8p6EGVZzL2GbQW9361Q6qXWC1N94VX3bShsVKCqHSPqYfLeRtubXT8hskCdt1v+bWOiGSterer59KN4VORm366tZBXe3n6KsvthBv+0VRYTgxjl7d/yTP4zhE+xxzsCYDwgrdfqjydql6ObTFCdkFZNJr1FYpFXUzfVVy2/eUxP8e+4+n8YXP1d
 Im6tBsqj
 o5aHQ7RiqWjkSJTQZ3Emk5Bfnicu02oeRfZjwqWYgiu4zZiqW9RFyfBxCpCpqcnDWqCavur7vp68WA8eRgX2C5Jpb7rERvQQkue88xlolyNpcQSmuzHhdni1iI6UB/9CekSrLSHhRD23PLPxdHcfsd+O7W3BOpQHshdOHjrpVAyemxM378yDPNuAVdZE7Keax1b0/N8ECn1Kcd/P6/SN3nDP/DxPsAC2SjkcOe5J2bFiNqHjLmcHZqtkN0Vaklcqt+12Ac1vVhENiC1ltEZqlitygJwXPobDrVpTTIbAM7vy5E1w1JBdatM9bZRTccomerHC2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 19 Aug 2026 21:35:48 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-19-21-33

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8dbbc7e188949b6e1f6be4e82a44dd1d8b1d6c8b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

