Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B92AC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC696B0095; Mon,  3 Aug 2026 14:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C716B0096; Mon,  3 Aug 2026 14:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DCA6B0098; Mon,  3 Aug 2026 14:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4088F6B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:43:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE5D8407D5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:43:38 +0000 (UTC)
X-FDA: 85060831716.28.D022DAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E38F61A000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:43:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tlu3I/E6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785782616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=u67MFJ5FLnRVSbiIEDmYJf9NPMdfoQaVK0z5ljtrlrY=;
	b=ki4L/WSh1/CBeV5jNex4rVUmN5mjw0HBVR7N0aN0C00teeHZ8Yy73MU5HY/eh/iDLYRyot
	MkK/m1OFhJZfFYVC8tJ64Jq3vItxce5b8dDAKYsvqqbWTtgtM807LNhbOljbNvhlbuO3Lv
	xDwrxdSqtS2Zay8Ep8g1aGqz6LJ+r9c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tlu3I/E6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785782616;
	b=W86bAGRFC2cPQbc4fRBN0SaXXpmKYp0nQc3VG8YMnb9WunTtyiMXtsKELEAkj3OcyYLh8P
	OYhicHUn7FtlPcmJ+MsQ0OCQchmuxx+O1sZuTVZAfaKHEveCuLT/xTzpzY6XPVRsc+Egox
	66ldxLoriZykP3KacxtWsyWZrGhundc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BCF260AB3;
	Mon,  3 Aug 2026 18:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE031F00A3A;
	Mon,  3 Aug 2026 18:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785782616;
	bh=u67MFJ5FLnRVSbiIEDmYJf9NPMdfoQaVK0z5ljtrlrY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Tlu3I/E6kpYl9xxxdR3zBQLqkPRzmDrg3ChuEKQgxSz8Z5CHOtYyBAkAJIGCulCp3
	 0MoxysjXfsa80+1fiKJsULDcfF+56yeFsfC7cCTo41imQUi+st30JHfcBzQGDVjQH3
	 I+xUdWd5aVE663OtdlEIDb07PpfNLNJYp7rsd1jwk8I5wvkvSsiGMA+cmvWlvscTMm
	 V/Odg8zARCU8SjBYhXLX/2fOq6XS1x3kWgBkXjgduAhTgS9+BCufqhFK0ly0FzZAJd
	 6EoB1xfeWtahdxWU/JtD5QFU4c8zkReQCbWG3g9aQ30c8yiup7qGg9bjKKfuapZRnM
	 ZejPJsyfooGQg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569993924441;
	Mon,  3 Aug 2026 18:42:58 +0000 (UTC)
Subject: Re: [GIT PULL] liveupdate: a fix for v7.2-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260803112452.1793120-1-rppt@kernel.org>
References: <20260803112452.1793120-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260803112452.1793120-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-fixes-2026-08-03
X-PR-Tracked-Commit-Id: 797fe91e50d6927f90f0c3b4444277c2c7c8b42b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c8e0d43058e6aaaf198e418a1d28a8da6e2dda69
Message-Id: <178578257691.2780879.12109163148620218018.pr-tracker-bot@kernel.org>
Date: Mon, 03 Aug 2026 18:42:56 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, Michal Clapinski <mclapinski@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E38F61A000E
X-Rspam-User: 
X-Stat-Signature: zwnad77hooyk9ucqzttn8dmowxrhmuy6
X-HE-Tag: 1785782616-569956
X-HE-Meta: U2FsdGVkX18Z1ZJRD5XOi8AV1p8wZ5rxN3cI9IJsgMcsdMIDA9RToiEqiyb4DBLhd+SdpkozY1dQuDQLexOc5hO8DE2KAkUtsfhOBd6ozFVooDsP6Rmr8hXE3DMd6bcltxLbPRMh2KpnTo8zgMtiABTCSXyD8Dp/6V5kn/50/2imLgWggoYKBRfMhnKSYySz3ldcI12pC94tfZ0CVd98WqalNPN5BWD2Fz04Y+MPNnCePi65KtnUWbuNC8z7Nc0peibeHcpKWHFCgxfYJI0e43f7qP40P6BhfGhifMoR6ee6Rf3IexhaEIGj+vGqpDyJnuC/yvIRuSEqLdyXTz96PChMe8Qo4l6V+Zvz4PN3uKnaV+LL+cwwVbKkkp4KVz8FyooB9o4PwnvSuIQMCFah1VXuPzB+KeEPIA/6oIcuuhJIapRh7uNdYcodvMeZH9PDRhDbwwTGAi10QKHMiPHOKSzmrUTefR9GWZRi/mrlZK782ImJthqqnP5vIISLyf/Kx81K5LC9UeADHdfjlK7gxG7kx/ecURR/cgQUDu6vboAw9qXve2jpY7ZDp676Gt0ErSrTPKAw64eLbqbi3Yg8y0wx2sFplhsluQ1BQbvOFWp7oNibPmmyLPTDQORdjfDob6gxnRoalK9jWI09s88qRqZYhwjr5+R2T0AHX11PP+IezKs5RWrO77Sk/sh0XRq0lbbFxHECVHRSnF3mSLqMtW062OYv3LL8edx6o5knuraPjBOEWCHzzKxp/niFdyPPRjSmhXYfuTFDdBodekzxqdTS17q38DGZFqHA2RWgF+0m9RSF7VBlpjIjctJjDnRjHdIpGT1qTxT/25g9cM6ugsMTLF6QzoZlNNM62mV8FkOpGUpSA1R8IakejftclZ+3gg+u5b/tZxCMZr/1hwSLxrUxkxn2Bj/eRNneZ1RHXPFZUacSCyop0n0dxvUJdATNY1jIbt+nzgbUdmd3FpN
 lJIOjNyT
 GRejXagGPAMTO5vtQif1Pse2kzyocmVGH9G/B249ecWevbgQ8JUzBb+RDS43ynRADDLplqsBRGcg0mShuLMpKBdyNS+GT2qv8qgeFeZNJGy1Wn8VWvrz4kKlxYNrAkbYPQQ5pjC2nbiRcDV80XOl/aVibA2LtiLnf6lvaIyq1WfjwJyTOo+l7lJLz1ftkXwZSJcFutQpWUv4SE9n2EkboSVCwFXvY/FV3aDlmHPSuChHhBk99+so5dxTEcaaVkdCrs+ZkioxVfCPQYa5hDE5+A76CF6XDvXkJFJR06m69AFmf3cFd1VYyrkTe3/Yraua5KQqqWzyRVpWQ2NOS3ZAHGLhSGLek1SAdtPsVkE107kXjaa+MLWagY58eYtzQXWj9H4ljM5LF1O+ItSzW1rDCzVHEy/TmAGMlD3yzzdtOU9MyJrnIHwVtUbapDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon,  3 Aug 2026 14:24:51 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-fixes-2026-08-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c8e0d43058e6aaaf198e418a1d28a8da6e2dda69

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

