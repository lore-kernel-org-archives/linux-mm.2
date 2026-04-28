Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCAAFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 16:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3BC46B0088; Tue, 28 Apr 2026 12:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB566B008A; Tue, 28 Apr 2026 12:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF766B008C; Tue, 28 Apr 2026 12:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86D6B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:34:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B72F1603B1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:34:41 +0000 (UTC)
X-FDA: 84708513162.09.EB60389
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C7B9140004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:34:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kkXNWJ7/";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777394079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcbBRyVqleAXVWqL9J9o2fKR7j527Ai/VehBITW3+po=;
	b=F1AU3pDlQNYwbR9w7y2pT7RHXrrlVJ3WHItfAFPlS1wj86hynIJkpMCtPDpu+0xP540pqC
	Fi6p/2U9cANK8D2N5EhYVZ+bNWeiNZwjHwoGMKdSa41hV8DONZ8ZqDNF2rnfg/6VCCVhN5
	9sRcH7klvfBgsCYZn3PzMuVp2rYy/jM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777394079; a=rsa-sha256;
	cv=none;
	b=5VgBgu5d7qOCBtwemCaD2xKA4R24WbJQRxYzFMyo4Vlwn6A/PahvXtlyPyFzCWpaN4CCkV
	zsQ0MOotAIs00CoMFOqkjT6PxU/D7g0E6pRAbJIGUQEst9pOXk3ydDT8mH6iTycqSERV8a
	oEJXTgGSreqVwqCTSAG4H+E/ZghOGlA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kkXNWJ7/";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1614D4183B;
	Tue, 28 Apr 2026 16:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DFBC2BCB5;
	Tue, 28 Apr 2026 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777394078;
	bh=SSGvX5eori06RTcAd+RFUFXSIFrU8pgQCr6sM0Zzku8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kkXNWJ7/M92XbIIqnCuSwyLr03O6/AkVzdoi51qjOyTquwaczjPVNNy12MGWk6Spy
	 u0ZCafMK5PDn2oPazYAk/LGZJybB3Bd/1QlSHWEnjdpDvRpFnj+Dlx6imHk6kmRj2W
	 GmtdGnpMa40At7JPZUfzH5PbQeT8wxc5sijxivhr9ls2A3CGyX862g2P9luWNVByyz
	 +vcqvRyI/R7zUU4xbykN0lMFXJwa/DBYQWMkhRzJ1Zz0ap1BJpPahRn8CylVj6ZKkJ
	 oN1OFD/eEvVZqaAJtm/5BUCTOuAsmVApZyoJO+2mkrEd0UcXOPjvWARBVm4r3r7+li
	 pSJVprhHvq2jw==
Date: Tue, 28 Apr 2026 18:34:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/10] sh: remove NUMA and SPARSEMEM support
Message-ID: <afDhluTA6ERvGugQ@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
 <42a4c6c1-762f-449f-9d14-3eb0fa02b94f@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42a4c6c1-762f-449f-9d14-3eb0fa02b94f@app.fastmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4C7B9140004
X-Rspam-User: 
X-Stat-Signature: 37r4qt96714f8xg7ow7eq7uf3d9wfhji
X-HE-Tag: 1777394079-306688
X-HE-Meta: U2FsdGVkX18/8br5iceFHglrbywwTDwrkBacED4Wro8L9WB4XwKO3PQ5FL0nzGxx9sFtkdf05tKKmcwIFJvgGK0AsYH1HI7EEFVlUdZp+Jx6BWxYnUfiYobYvwLHkl8BI1vy9H3KCjd36DAxTJ4kuOcmSEV0U8CuLqEkhlgRiy4WZK5sClfsVbmxuUHbh0e9UrlxJOu5lwchwWA3UgUWKc0n9CfyhYAh4qI0UkkPMjP1XWGQM7UxFdoAVDJ2gyITLODds0zGn+JBov0ztiL9eWDiVubwz+JHplSwVb3BrMhsfe9Sn2WtMst/jQmkAVFvsc1Lx6L7bYtLcwkd4IXmTh8qtWVUcCFtU9J0E1YVIqY9UX/Eq3RRFW2OHLcWnMBSaCe1DqjqEb4kiRo15VE+OqfqBNC1BRkhgdBgVxKcW8D3eI5C8uqk5KyHnO4Lr/KWpikz0vnf7QYXupcXOmGFGmLtCrRwqXmk2+uy0JkbG/s6t2ZQi79MRNVVKvR3nzHu/j5oqTotytsUYF4kjG+c8NvtIS2reApzLWYH57uL9sMCQ4kTeUHZzr7m199IU8s33PxB+MXsiORqJqI+Dq1ER+xxUNQ0Sq9PkhW3DASYWQHFst4cnyf14ISkSPOngS/qWlC/v3qYqLGJyRa4deruZ8gS0fNURRPw9qKA4i2vvhmbtaaQejT7uFKnMT7DCRrPCmoejqqqjO+fTLAz7iZ8ipmIW1sz/2n+eF9q+WvDicWEW2KpH8WYSOp9kUllieiIrH3Pp+/eEBpCByInodQ4OufZ00gZFR2E+UWndX0ip1SipOuCRjW9GaRKzPlGSPajm932Tlsb348kdj9WPSfyYPI+FgCJF19cnw0o+pEES6EYzyKxn0EIebIYTVsDbt67EY9aylF1vvNj1e1MppsPko615+ckNvP8rW4XGxiLiGKDkvG12X5fExan6FMAjTGAQlJz/a4So1Lu4mcJ6Id
 +jQMk7Sr
 w5HLQa+rqUfszGVnCNML8zVH1HnqdTy0pmFFId3ZtqX7azQdM82yWzlsrdbmK8aTMSj9mpV603gCCHSui2uWQ4RBHgITOW0hXkxH/yvoqRU8afn0EpHu5+ENmEM6OFCf62fvhOfVlsJNeTX7xKvTCNaQBxej573h+dYMmYVIZtyEByhoSzQnkzNjDNvOe/JoXN95x5SJneM8GfJnH1gIrJJJBu8vVDZoNmCEr2NtPg1q45UZvSuB8mFdiTTASDoD0ZB8R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(oops, missed that earlier)

On Mon, Apr 13, 2026 at 01:14:49PM +0200, Arnd Bergmann wrote:
> On Mon, Apr 13, 2026, at 12:46, Mike Rapoport wrote:
> >
> > NUMA support for SuperH was introduced a long time ago by commit
> > b241cb0c885e ("sh: Support for multiple nodes.")
> >
> > 	"... for boards with many different memory blocks that are
> > 	 otherwise unused (SH7722/SH7785 URAM and so forth)"
> >
> > In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
> > shx3 at the expense of all the NUMA related code in the kernel.
> >
> > For build of v7.0-rc7 with defconfig and the same configuration with
> > CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k. Disabling
> > CONFIG_SPARSMEM on top increases the difference to ~94k. And that's only
> > overhead in code and static data that does not take into the account data
> > structures allocated at run time.
> >
> > And all this overhead has been there for nothing for almost 8 years
> > because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM")
> > those additional "nodes" could not be used by the core MM because the
> > maximal pfn for ZONE_NORMAL was cut out at the end of the normal memory.
> 
> I had looked at it when you asked me about it last year, and I can
> confirm that agree with all your findings and the resulting patches.
> 
> Whole series
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Thanks!
 
> Two very minor points:
> 
> * It looks like you left the 'config SYS_SUPPORTS_NUMA' symbol
>   in Kconfig, which no longer does anything, so this should probably
>   be removed in patch 9 along with the lines that select it.

I think it better fits patch 1 that removes CONFIG_NUMA, patch 9 is about
SPARSEMEM.
 
> * It appears that after your series, RISC-V is the only remaining
>   architecture that supports NUMA in 32-bit mode, which I think
>   we should not allow as a configuration, given that this would
>   run into untested code and no hardware exists for it.
>   Apparently commit 4f0e8eef772e ("riscv: Add numa support for
>   riscv64 platform") intended this to only be for 64-bit targets
>   but did not add a Kconfig dependency for CONFIG_64BIT (or
>   CONFIG_SMP, which was added later).

I can send a patch to RISC-V for it.
 
>         Arnd

-- 
Sincerely yours,
Mike.

