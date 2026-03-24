Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C3E3F54AD2
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 16:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062156B0088; Tue, 24 Mar 2026 12:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039A86B0089; Tue, 24 Mar 2026 12:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB89C6B008A; Tue, 24 Mar 2026 12:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D15306B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:18:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 199E0E04E6
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:18:20 +0000 (UTC)
X-FDA: 84581463960.13.B06AF82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B81A140008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:18:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7pe2oN5;
	spf=pass (imf23.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7pe2oN5;
	spf=pass (imf23.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774369098; a=rsa-sha256;
	cv=none;
	b=XZoPwHtL/3qbyh70gK6oTBf0lvk0e1IWjmGu76RXb9cOuQlZ5UCaLNBTbQNzObp1FvSRck
	E+01Vj2guXZlEQFyJ5lGkkgWvr5VnCKVs9pTi97yxxmi7U8YvnIogNMI7ayxKfZ4wPcboS
	CDm65nioKmUaKzR4n9UCaJHp76iKsTg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774369098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=5oyztmhKthfRsZiYvNFxTzAOZa3sBOv7owSR1z9x9mI=;
	b=Re7UsBq2lagcOwUgI30NdrZcqyw7h1H9tBJgrH370O97AmNbB7mmKUjZOoAYWkY5tYF7U7
	FNq0Z2AsbMQd41RTh470nKZWiLNUB/60K5NodLt+K6PfRtJDu0IllQzPoCheumhOeEbrCc
	QHQFqs/8fHYN9UNjzrlBkNisbBF0SPo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0527D417F4;
	Tue, 24 Mar 2026 16:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70BCC19424;
	Tue, 24 Mar 2026 16:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774369096;
	bh=/cUPzzLJI+cz39jGVtpY25JX5CIzYEoDyFD0cG64CVw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=K7pe2oN5E5M5+gzqcVwNneA6DyFGEImzKSkzdM4asceF1zi5G2PbeTPOmwGPcB68E
	 JXfw5YG7HP0Bb2RR2KnyArRTu4I+TbHGF3ypbJbBoH64tQtsRG7sc72z7R7tvD6rJu
	 shXjuuj3quuKq9lXQBno2tI5mapyA1Kx8X5kt3svrzXdePdd3mffS039wQj9en5tGb
	 rIoG0G9IqVOnt6/4vvpeCB6u/XmXfwre3Q7ysNsP+gxMqZRsb9InD+zmy19wwTLdky
	 NGA9Z+Nql2rVYRc3ALh4ypvT4I06q+P1I+foET2IT0EBBtr11gjNoDB2R4Le9suZxE
	 Qt9EcuZdx7GuA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02FFE3808203;
	Tue, 24 Mar 2026 16:18:06 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260323180007.d3f7db6a8b5dc59e72cb5f62@linux-foundation.org>
References: <20260323180007.d3f7db6a8b5dc59e72cb5f62@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260323180007.d3f7db6a8b5dc59e72cb5f62@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-23-17-56
X-PR-Tracked-Commit-Id: 84481e705ab07ed46e56587fe846af194acacafe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e3c33bc767b5512dbfec643a02abf58ce608f3b2
Message-Id: <177436908461.1187739.15267081620122808415.pr-tracker-bot@kernel.org>
Date: Tue, 24 Mar 2026 16:18:04 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1B81A140008
X-Stat-Signature: zfn964unuwtot77o41zu3wod8mxrkgsw
X-Rspam-User: 
X-HE-Tag: 1774369097-94310
X-HE-Meta: U2FsdGVkX18JimIUTCgFI0uILT8Eksn7DmieK7pfWmyVU8M2p2lOLJqqRIM3dz87xkMYPE55Ky9QmAkfLDXSRNCpN3VueUh7UapEPJOcmKIypIjlRSdcMxFzxOllD2T1r0QGq1Me0/61BUE5tvNloyY/fOHy/2V5qY0vxnE/ysg4w1bYhhknq+biXn+cIVpDB08K20TGktkWbuThL6s08PbFZJTdw+7ISjBDZ5SB3tM9o+bvIJiI6jEWmvGTCrYmK+/l9pC31uQvVeSZG2QvkM3u09leNe2KIsWRkvMInhC3YZ4VaEYAqSJzbuhzR8o8w0XYSkVmhgS94GUejxYzlUOEr3VTbie9rm/1iVdB9zG4N4D0Cotsn+/rS4zjnTRLGdCYmmw86RZwcAex/A3PIeIgNLOwjJPCJMEObz7h3vc6mgh7EvZ3600zkY8TkTyTtKFCfaMpbQToJYD2Dn5P7UQhq4ugS2o/RSoM0eaxBMT54ffOP/KHzbycETBgL0eNzUjbUa0VmIph6A4Hf/vQ6Ixo32aJ16kckzCBm8IZhxRClwEp1gIpEl44jrL3yklj7OnteY05+YbCJw7kGF56318GJh0LFxXQen1hmtbu/dY41XpCyfdh4MPaW4Z3cTXMNi/GJ6Em1o2vvkpnHUvm1H8Txh3BcvJgRjXkrseZmVTCu0A7nbfcVAhywe0NLXM85oMK7/oBDlu8tz7eWTH6ZtQIr8qGAo5reyPvFh8yisnqhWkCjmpGJUJMLv9Zgm+ViEtR70voLdlTi5Ne1BvN0ikYj1qYaSxayg5RkR0OdGaW8xMKwketGNvCGs8kl6CZU+AKVv+ma3Iyslady6OSXYHvkSy/vsFFIC5BIb+A/jNQCK356Euy09wTP/hUpr8GLMKtEV5B8pFnAIE7HRzRGVcq7Z7xdyldLXoATvEMQN/eM7fZPvUSgiZWnUUbHNiVsH121gUciD8mR7NmFiT
 jtbsDgXX
 eTzXvpF0QqVWAEVeibPRSHqZIxAAow8Eny2wqq0B0CUbwJ7HvZHm/IGJcboZ+OZzhvG2DCgKOR/VXXf990zb0cEGnajD5N6slom5mcE5BW1IAE3OirnIjdzquxCqqyGyZkFMR74ptOJb7AbmAmek8XKhHTiXbhcrQem+dy1z9DP3u/YAfVFfKHS/UKjpSnD1oAayAoAxDIGw7tRZ7kPwQXvtB6UnrfZJqFXX4lN/0MgDIOBQAekELkckrK7Wa9pSB3C/bzD3p6L3CxgOE+wWPbcvBLDZyE/1ToCfZeCcrdysjSSs0jZ88v0rxg2qkfSCUDpxEL7uO76Kq4zO42atYsscU1lH3mpTbsQOWq5r57K6yLfZOpu5hkzwTAmBHPx1ra8w1yH/WW/zYepk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 23 Mar 2026 18:00:07 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-23-17-56

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e3c33bc767b5512dbfec643a02abf58ce608f3b2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

