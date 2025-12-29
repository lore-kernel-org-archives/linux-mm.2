Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC6FE92FCB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 19:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC726B0088; Mon, 29 Dec 2025 14:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3FB56B0089; Mon, 29 Dec 2025 14:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94CE86B008A; Mon, 29 Dec 2025 14:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 807BE6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:35:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A677C26F9
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 19:35:29 +0000 (UTC)
X-FDA: 84273512778.16.25BC116
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4A36F1C000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 19:35:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6lFsNLy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767036927; a=rsa-sha256;
	cv=none;
	b=YYF1cIZ9QQsnadfJA28BcvJ7CGM3W6yfEphakwIYQ8LE0eh+tBcuuhDVCPfHiWge0eQJbd
	mzbdXzztwDPyyAV9W9hCIoKyVvj3F3zQnd9Am2EdqsyujVraH33efFwzgKKLGTU9ENZae4
	sV9mph2LOEHUWQoLwHIY6gUqZErgb4c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6lFsNLy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767036927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m4mcjw5aELeofpzfaZ1tNlEpkhnRHTfH1c7B+xDfuE=;
	b=xPSb79M7vuBu61WHv5GEF5I/f1V3Pwr2pYhQESgiYkMtvGW3INMlMZls5ZxCsLa1RabjZG
	xBWc+6sW8FHkAtDX1cYbjfoOMzHAEmfXVVy+CNjaKksjyMcDhhInaTOCFhzTnitID+M9k+
	OxXG3d+DMUg6t3lUX6QQldtwPShVL0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A5014378E;
	Mon, 29 Dec 2025 19:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0F3C4CEF7;
	Mon, 29 Dec 2025 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767036926;
	bh=ta+pVxuxmmi+pZHKzWk8vMI4jIbLF80FO28qLw2fLfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d6lFsNLyWQf0eqYfDJ43ouM6W5wTlFQhP7iRhbLrx+m8FnAWwUpcSBbVmrUatV8wN
	 4XmH698AYwaMguS721dOMST3Kq5aHAwS8QDVBZPdjB1G2mEm8mL2XCIvcgAQM+3u5T
	 kLyoa+kxXOw6JWa2odklGZC/jCz3jvDjQZCzWh/wz25C7FJgHqjvu79l0uskoi3hfe
	 JesbjpdOXM+Ifg4AQRyaHOdEIIHaOGjSNZ9B1jfucpOdDr0zcf99SXdQ7BWi6r/aQB
	 Arc0uT5sGjY4ZQtx4TjxsvWvdjuRalv/UAW65NQEkb8joAm+wLtP6RQuPij3vV+lgI
	 a6iuIH74HcQeA==
Date: Mon, 29 Dec 2025 21:35:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: markus.stockhausen@gmx.de
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-mips@vger.kernel.org,
	jelonek.jonas@gmail.com,
	'Chris Packham' <Chris.Packham@alliedtelesis.co.nz>,
	hauke@hauke-m.de
Subject: Re: HIGHMEM freeing patch breaks Realtek RTL930x builds
Message-ID: <aVLX9yLmIBPzI0MQ@kernel.org>
References: <007d01dc78f2$1ca4bf90$55ee3eb0$@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007d01dc78f2$1ca4bf90$55ee3eb0$@gmx.de>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A36F1C000B
X-Stat-Signature: zkdadc75fbhufpggfcyx8z4jqwwpi4ww
X-Rspam-User: 
X-HE-Tag: 1767036927-262142
X-HE-Meta: U2FsdGVkX19j7ORN5v+lN2qqinZ6Yfld1Kj6qXa4ckrD02WH9iiWuFO/fstwuEPJREkSCLNja3bS1qc4DEuVDu8DIFyCCqvVTCPJPyCf9Og6p4LQEHKog6/zlg7sG/rPzk7B8MK+ngv3txo4L3dhadOxETmX5MZm3SoIWJe++PFC7Xnll2wTVUDdzoflaQR4Pnn0cPJaS3spxJYywuZ3nDHr9rWiDDZFat32mCgioJQDbMncltin5tx6crnvMmMj1hZ3i2ZyrF2w85jKOY+djNQQBeUzeNcAfoFdz8Z5/p7B/oggREjFW4EPHS0qeIKS0p//vTiwUw+VsnnwwGjiSTSQxfJhJBCTyI2YvhbWqqad3GmUSIYzgY7GMJOT3qVUxEs9VoocuUw48Wh9rA0ej8c8LrpvWJx6GlKpXvB9qADD1/aUm/bc0ER5AgH2CCrsToL5vUBsO8zTMGo3UweBiELFLBu+os7WXhAjtVnxNM+wqIybCJ010ItwdbGCyXq6uANPHyZM7HR5immSn72e/RAy9WwE0neVM4kxOqotQ0mNbJNA7392JMQAsb5Mva6BBuM5+IRLaNXE8B4IWx5FxZjxCHib4j/yJOdw0QZ3MIVNgcNqoYu6EKc6fShq6bjsMLhE8Cv+xJIHrfkHZ6OtY8sa9suLiSDKDtXR5n7udfsEpaYeAOf8qlbAAj620Lf8NLGXVsZAZBqcMWegOLQecbPxp9dl2TzWLDIgSehizYWwa0dtVigIl2YsrffMidVnByTSSouANbLCGMdfW29/uUTBBs0MNQB2CNaE5hG9r7W/BcJIktzuSupEzsBf+rhmFLwOBxh0VGGFwMapvMohhH8D6SlV2jresR9vbNdJQ5Sa9irBVyPMaOq2qsQR05NV+OLiTXCY/0XrHXH4TrHf70xHGTdCIKP4ptX5W9Z8hqXtQmN7Kpzfh1qCxE8aK5Y5hRkYpcIqfO+dNXPFuPR
 q4kx8t9g
 pNFldwlD1KhNqSnuL61tMeHvrZLLlE9I0k7/bybVPdLd4F8Ky92/xi2VeXtpx7kwZYtFnnBv22yoQPBaIEnzulaaROZcFodZYULjqzjadY6rQ+15MJIXx+LpFSYK0ljvBKxPQuFXdKdCKwg7nVTJhfhOafcQu1+9yqpi7US85FzrCCfx8Aj753YbdctJq2zM5LvfBEFCvroFYB7lOi35IF5DGY4s5H316PLIeQnsCr9E7WZ+x3KfJMv12NRbTnmA5FzCtqWsoGhPIei6RWQS3MUhC95NjX4IwPX5DadoDfbUPqvmBI4MRP6EMF58W24WQMRdBX+GUOUifxKlB1SMuNMOhpwa9sciMBg4cvDiLLOuh7BTupPj8E2RgN53jjZJ6HDoR/nsWrp5c6kjyb1XfbzdWLgbdzjqXKVECFox8b9AioUYwadTxneuCjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 07:36:52PM +0100, markus.stockhausen@gmx.de wrote:
> Hi Mike, 
> 
> > Von: Mike Rapoport <rppt@kernel.org> 
> > Gesendet: Sonntag, 28. Dezember 2025 10:54
> > Betreff: Re: HIGHMEM freeing patch breaks Realtek RTL930x builds
> > 
> > Hi Markus,
> >
> > On Sat, Dec 20, 2025 at 09:57:40AM +0100, markus.stockhausen@gmx.de wrote:
> > > Hi,
> > > 
> > > sorry for being late on this topic but downstream OpenWrt just started
> > > kernel
> > > conversion from 6.12 to 6.18 these days. During preparation of the PR
> > > https://github.com/openwrt/openwrt/pull/21181 we noticed that Realtek 
> > > RTL930x soc based devices with more than 256MB (highmem) do not boot 
> > > any longer. 
> > > 
> > > These are MIPS 34k 32bit multithreaded SoC with layout 
> > > <0x00000000 0x10000000>, /* 256 MiB lowmem */
> > > <0x20000000 0x10000000>; /* 256 MiB highmem */
> > > 
> > > Bisecting the issue gave " arch, mm: streamline HIGHMEM freeing" 
> > >
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/
> > > ?h=v6.15-rc1&id=6faea3422e3b4e8de44a55aa3e6e843320da66d2
> > > as the first bad commit. This is back from the 6.15 times.
> > > 
> > > I have no real idea why removing mem_init_free_highmem() and letting
> > > __free_memory_core() work on the whole memory range gives issues.
> > > 
> > > We are aligning to upstream very slowly and are still in need of 
> > > downstream patches so here some additional info.
> > > 
> > > - Until now we never cared about FLATMEM/SPARSEMEM configs
> > > 
> > > - We are still using dedicated prom.c/setup.c for the devices
> > > https://git.openwrt.org/?p=openwrt/openwrt.git;a=tree;f=target/linux/
> > > realtek/files-6.12/arch/mips/rtl838x;hb=HEAD
> > > 
> > > Any idea or hint is appreciated.
> >
> > Can you please send logs from a working kernel and a failing kernel with
> > "memblock=debug" added to the kernel command line?
> 
> Good hint. I've done that and collected all information in
> https://github.com/openwrt/openwrt/issues/21323

The successful boot disables highmem:
[    0.332305] Memory: 495640K/524288K available (8188K kernel code, 647K rwdata, 1504K rodata, 9620K init, 244K bss, 27528K reserved, 0K cma-reserved, 0K highmem)

And the failing boot actually enables it:
[    0.332285] Memory: 495640K/524288K available (8188K kernel code, 647K rwdata, 1504K rodata, 9620K init, 244K bss, 27528K reserved, 0K cma-reserved, 262144K highmem)

so I believe that the partial revert should help.

Anther option is to simply disable CONFIG_HIGHMEM for that platform if it
anyway can't support highmem.
 
> > Another thing I think worth checking is will the system boot with a
> partial
> > revert of 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") for mips:
> 
> Will try this out next, update the issue and inform you here.
> 
> Thank you
> 
> Markus

-- 
Sincerely yours,
Mike.

