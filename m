Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407D1CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F5B6B00A7; Fri, 22 May 2026 10:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77BE6B00A9; Fri, 22 May 2026 10:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98EF96B00AA; Fri, 22 May 2026 10:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86B716B00A7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:25:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 203E8A0A06
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:25:58 +0000 (UTC)
X-FDA: 84795279996.24.2AE1626
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 491DF4000F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:25:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cOyCpNuL;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779459956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=QvWNlze5JRhQToA8x508WzkYt+D6zmbnqqTgSFAv4Gw=;
	b=R38ofYFQwpPAnOcPaqS4WHeYzoqqSe1Ug5Zdk83Ag11FtRynX0xe1SWLDGnwQBtiBmGa20
	4/cPYidDeBPstjLPDVTRVJ9I+xokd+elJuI0L1ZmYcar2kYBavF+I0wjo+lL9I+dXnROSb
	jGg6FVjXzzOhJdZW/d5W7l4aSJ4HUWg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cOyCpNuL;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779459956; a=rsa-sha256;
	cv=none;
	b=i3lGszFlmNvVsE3WIa05E17N56mBX7EDDJaVt8nB9ASfAOlhwJn4GCcfWiFXeplfKWyddk
	Fedvk5ba32Alc37qrcGFlm8wnf4scpqC1O9b+UxyP8QVTX7uin3gz8nMH613I0hjNcjCGu
	eZuTweEUPTvS03sf/NGT5mz+aJxIS/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B90D414FE;
	Fri, 22 May 2026 14:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5781F000E9;
	Fri, 22 May 2026 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779459955;
	bh=QvWNlze5JRhQToA8x508WzkYt+D6zmbnqqTgSFAv4Gw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=cOyCpNuLLg3+TXgWrYEfoKsxQ1X42tCQX7IgC6g+7kHOGEXlMQzY+ESLDdi4mNl2E
	 pQN6+wcCdJ5MFHr5YcPWUg05Iry2ayQ69BcTBJ6TXlj3vJFIOsQWCRWgdLwCZOPLcL
	 MfNdtLb11yOCEuj1a679sfXXcIiG9mR6x4HdQ1kiniOV9EZPJFITO57k9e8HQJLaTa
	 vzNpPMpsvpb+1ovSVERm9M5LSKxkaar4ggwY/ZxAkKIfY3rgGlKoORZnQ28SJauEve
	 HaY4v3vjIAVGwOc8Cg/bvwBZsCmgvdsC8rb5ZSfbUDJw3FJCQSguSoWSslamwwVkDp
	 4YJ6J7TXpVKhA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0B5A392E9B4;
	Fri, 22 May 2026 14:26:05 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 7.1-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <56e3c93e-2840-43d2-8f41-b2e435e0fc29@kernel.org>
References: <56e3c93e-2840-43d2-8f41-b2e435e0fc29@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <56e3c93e-2840-43d2-8f41-b2e435e0fc29@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-rc4
X-PR-Tracked-Commit-Id: 67ea9d353d0ba12bdbc9183ff568dead9e949b80
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 46de4087d38ece8477ab4b6b7630c13c82c27f1a
Message-Id: <177945996448.1238704.2349999669182869290.pr-tracker-bot@kernel.org>
Date: Fri, 22 May 2026 14:26:04 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Rspamd-Queue-Id: 491DF4000F
X-Stat-Signature: gtesumf76stirx4sd6b8417gauzigw97
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779459956-545510
X-HE-Meta: U2FsdGVkX18A4jICPNtD9fQoCxJ0+z3dPls/EB2r+VDXhpLGpzub6SKr5RxcLyWpjGnEqXyWODd1mB9Oh/6EXNd4xcM5xFRPvBwBO2wrpV2l83gnqNJsjQRP+JK7jNZMaCAM3rnKqtBUwvvgcOZkuLUFmPp5ZP/W+iZ0UWfA/7CEKxcuEsM0nccFEYf6bkFsckpfr5LeBsxUPX23DlCKTfO2rpMmogD4NC4r1dRHvBxdRmkNtIjdtrRkEdpx+ZXIl9/JHfM7/7vQXPQj0oidsLhfh+TUUhNLH1dhuP54T3d0FjFyxmz/l3kFGAzTrsm0WEptKndKcXbsUg+2pAR9NzXfIt254txGbnmQE9iBxJC1cxJ1yzATwDA5Oi7IAri/XuP1mGOs4QQqVEcFSOLfHID3mY5A9TXjb+52mVzgjiVeZhs9h3Fm2PfgAeRuyDxjHVTJULQCtRUU9UvUkD2sUo1GOMbUJr8jT6Eubk0ozyq5S3vNuLlD48wgJu+W0LSKS42m06Qsi7Ylc4PAyVpUnHQUHY3tsps8FVu0gMiaol6flGp8mBKAEAo7ksJFZjsUcItrrmDY2eMe8ePDSHmxiGoIqc+WGdVVR/+Gcw+U/4D75qavXKHmWZqv50Lxc5rph8y7U5VIyPDmBjCOjYz0kHUgAnWxqG8w3HTPwg/jhPP9gIlaGGOO741BXbSxfQ6gociuTVr22hNQxoxAmz4Vg6iNJzhyigsefyBz+RDxhJVh28NfoLXnJvnLvWHqvBDQfffuIWQnuGGnIkL6VW+5vqAYR4NPqc33BogsVSbMUcQqSwhchWirF7nxeHh8MJCrZ2h4JbLR0fD9bbloyRpmuEgVQEzI+uKvUds70Z83FnK+6kJSKCaEssL9caT1UGPrI0wJIMN62AmSQoPibOimwGiq3MGGuDlqeCTNsVuwtZRJ23eZ/BMVV5o4HQIK0PChxlyUCRRcNKQIIElo6ew
 LPy2fBb+
 HBoW+E//V7KRSka/D/tGcn8c72bNnrGMRSuOYMSp605TPzrdW2SPF8fapB9GDeRCkH9G3BtoJ3ZSgmSJwZfSv+vyXo9dgqyhZmGlaL5MXW8pxdDPQO4bKtI0Dtt95ui4wDb5R4vwas9VkX2aUpkF/bb7mfeJvYSFPoEr3JJy8Mnqr/iQfO6QXDwcbgviExGgJrlFN8GfUwYuVAk4tOTAJc+WrbW8tb+QjMmuK/+f4Z3EuPWVsdufcVQVY2PvFud4Yy/1opV4w7XFu+BaQgqxSo3NjJ7jW4gGcTgtnXpbM0dIPWl+HrQIN42LjDv+A0KNwwszmlnWHLOH7iwNQCeBYzCtcdBZHAIaFix+BBNxgG6plx0iGSnBU7V+rOfNF4gxQRGXpT27/H7PkfwZ8zymMv8+FXcX6imQM30mW8E5USOWP4XQAHuW95V9xlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 22 May 2026 11:53:39 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/46de4087d38ece8477ab4b6b7630c13c82c27f1a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

