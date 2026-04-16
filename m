Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9BAF88073
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859A76B008A; Thu, 16 Apr 2026 02:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A3B6B008C; Thu, 16 Apr 2026 02:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3296B0092; Thu, 16 Apr 2026 02:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57C0E6B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:54:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAE741606FE
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:54:58 +0000 (UTC)
X-FDA: 84663506676.03.174EE68
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id C33D140004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:54:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cCVUaFrc;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776322497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ipi0uIFSe7o2MABqVxFvIYk327aSoG15vNdex7MTd4w=;
	b=y3wzOplvE4CExjFq0UHCufBQ1FkvIAlkgUHiWs7yu6HPHwc76f3x3irXo4kQEgxulUZFUX
	4GFeKfpxIAPmMgq/mWfPoYPBE81+5YscxJyzvTX6rKhQgajkgPD8599SmkBbhZNa3wsHej
	kIXph70wHJPneKL1Vgu+s/g7m1tm90w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776322497; a=rsa-sha256;
	cv=none;
	b=O8GYVAd9lFOcz60j0q4Wio2H294GAnHl696vVtySDBOLzkwEWAZIgNdOfbL8vl1x7mII4O
	GPM9a6zPcrdXNrHyxwVQnWTcw6FIaXQTiQiDe+NT3EHeEZ0p6j115Tz0GkXOm9/iyhDltS
	n7MxLh/qNSrBFZ5p7ktmlXhAYA2w9GQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cCVUaFrc;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43d7213b6ebso2685659f8f.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776322495; x=1776927295; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ipi0uIFSe7o2MABqVxFvIYk327aSoG15vNdex7MTd4w=;
        b=cCVUaFrcoWLGJPuYGLHTkcGi6wMYbJYtN4zX1B8ZCjUXnq0l7HL4GcUCzJPjVW8cO3
         YkPInKWny1oghoBX87LT1ullUaLLt1fys3xyl6sDxFuRyIdSn/Z57IxkaaRUcPpuQ7H4
         KGh79ugUz3uqnefHQ1dZ3EosJZeTO6rornWPVqMbjBw4DIql5aWP4eaIyY4u8VV7qs50
         DucQmyqlv5/hmnu0u39NqKreCfGJwpga+41ILeCiO76k00Grhx/8H2dSRYGplRXsE2KE
         U9tPAYc5cCwr1znM6y4nId16hBhDM6vKJYWJj8AC/B08+ukxLuvtotel+Ic1f4GTDmo1
         Gkcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776322495; x=1776927295;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ipi0uIFSe7o2MABqVxFvIYk327aSoG15vNdex7MTd4w=;
        b=NpU6JLwhnRqwPFvV9FR/f9G50h5qwMA9/aL6YA+0kTY/b66vYGHJ6AITYVUKjYNcQR
         JoECd/IRIVc0kfoQG6beIqb3GspPSrxBbeotUjbylmGo3Unb3R5tF8ZuAqE1Hvz1n7WQ
         6OfsfJiJtgSQE1jYQ+7JbaKG//JCOD5qJ/zM4ObGOOYYmJkr7eW3fVsjZGumXa3uv3Vg
         tEIiDLj1fg8agqKh4roqC4Tk2Hze1B//qdeHXXLGlfRyctmfyuaDpT1O7T2geJ/mub98
         vYeTntyX4Q31WB/xTuh0fjd/Ey9XOv+smKI2zT/cFfxBrmB93O2Qk8bcFJcvbvtx3mzL
         uHFg==
X-Forwarded-Encrypted: i=1; AFNElJ+7Q0c5x7/j/lK/y7lqy4A8dzicPEZCMu3aXqSxtdNTZEtZijjxd17MmcAibXbtdajC+2OFQWhCZA==@kvack.org
X-Gm-Message-State: AOJu0Yxeg7mKV+eYpaDqA5AQFCzpUdONLL3yEez9SfmcerK/bZ3HsXoj
	ru4oGSbZqCfXSZELOCbYQrJHG9QYEY1eEXPyecX8JJAfmQZXVBGRqcyyC3AXS6hZTOs=
X-Gm-Gg: AeBDievZDls6cOgn/FqKNjxoWiPpXE8GcGzXXcGTSPBLpoxqQlg7y4cfE10Pk9cpr/9
	+JBkHb08xAdh18YAzxX+BVZt9e/JYq1cmT0VIsGS4PGksRPlr5iyKanOa1gZu9d+pYDJKUrB1Ev
	sAv2bf7S9lpuCFGUo+jH/tpk6d6QKLQ7gWFdDEMXto8DBJlnY1pxLWMQLFCMAAZz1b2ZDigByF2
	HIFpQhXFbaH4uULCcd6U+oqUZzU0w4Q4KomI2UIu9buaXxDTiFVFoG7gC8ImwG74WdQqNNIAwHP
	45wbIQtaWlePxZFVutgkllHWpLieaXvFmpVwbnKrXLB08jLeHXuIOa5fO6vgzozZNzKep8ppaj5
	ez+pMUIy8L8pegezrHw3VtN09vT5w/kdgefMbRzp8Gug6gQ0zNpPinSKAlaDaPnCZmd28m35WGL
	8EkL5vebQay3MyCpG+hkrO41EaGWVL+yMR/SPpGLxWxKvnCcI=
X-Received: by 2002:a05:6000:2085:b0:43e:a70d:763c with SMTP id ffacd0b85a97d-43ea70d79b3mr15352595f8f.42.1776322494947;
        Wed, 15 Apr 2026 23:54:54 -0700 (PDT)
Received: from localhost (109-81-20-115.rct.o2.cz. [109.81.20.115])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3e040fsm12798539f8f.28.2026.04.15.23.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 23:54:54 -0700 (PDT)
Date: Thu, 16 Apr 2026 08:54:53 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aeCHvYOKP1exBBns@tiehlicka>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeAeqoJ_acUAza8D@google.com>
X-Stat-Signature: 8mriyzsonmwhipkqfqkxquetpxifj7bj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C33D140004
X-Rspam-User: 
X-HE-Tag: 1776322496-605126
X-HE-Meta: U2FsdGVkX1+3gVbIoXRJaD3tBenPlJG2mWzSKjAnz9h1ipgjJRmKDhNpQzZV3KrSdMqEZJPD0UhE/obsGSvsrPDtXLiyoEsim6ddpH1gScIaGiRXHJ7wRZCIsdz8ShTRNjusU64PC3olw7JfZjhjQPwzgmzikvbQY03J6Bd84oJZxHsfqon28oz4s5vXmUj6Ur0bKuoOIIwbPAgb0mv9m82j/13CrAvvHl4ntLpKMs6OiD0NBmqrSAemOLCUdL5kj2QAEXiKdoo+yqbgPbV3f4iX6YitvUJ+ZYsy4nEfpCsAyFySIxYrD8FPUdIXsydmVqaHWJlsFx5F33TfCPPIjWfOCRCPlHO1pQJ7InAgbnDwmUofT5fW+TZCf0o4NG+6oprV2dleWvS64321zDD4km4kUeZrZjwIoHBONRHmPkT6dlnRYucepcQxttHie7Nv/E3b7N1Ly85iat12Kx76kLHCJWZ5hKt4+V9NsoO0R7p022QlnjNW0tFGtffOV4CxnkZG5h8GgDfLiIzx2vZC6IiyaYPL0PGeqjmA+OJwfA1B6I13ml+wRlp8jnrCOseW5ePpmN0HXyhB6J9wvpxobZGbAPXhFAar6BmDliJtS3CNGSDsOs3bNN/dQ3T0ThT/hvZ3dIrc7jGF4Bvm9MMXbuwdqR4CheLCmw+16dny9YCoDha/lCyAfP6ZpWEWqf6v44beSEcLTWcmeEuxsDVc/YUU9O/37oWO1NkkyDSQhXIVl+ghCs6bV5Uei7+a14xjGZYOxuTtP4pkKSLOT0U1gyc9c9QxS7JHEAYgJF+xOsQCHeJJUlYA7oRrSTiRsRW4ozqvWGc2H2JkzfiDBD6L5GpJ6JVjsPeXe0nPGpU72W/chktue7qFyMZLDBOGI4s7fyguBsb02DH1JA4B8GUnRTztY5B5X9KPmFRyViktUy6O0jVhRN9iu7yTgN4fbenBlGQq8ZnyM1jQrAvmqRo
 2vqkBXgG
 z9dyFFdpSMgDXVP/Mje/MAdB3KGodIEtsBLZToIjaWbD/Pd76hU7YWRTLwR3Hq93u5l98BFX+U6A0zLpsuT0zLxL88LMTUZxdWLce9sItYdBLDtKPsDGBWyU7ObBpVIw3/xMJ78yFX3K8mzGphKDNG+X6d3dlmc9hILzzjUOtSqB8fjY0bf8qO6E2fYhLLGNlPr3Ae/mtD7NoxdyUgyQMpM/A0sU91wEv2ndAHzfGi+ZnW54xuEGOaJl5Jr6WWzHpfJERulaq2FfvnoiPIGjyCfi/kL6ZNfRuSJb5vcg4V2j0lzkMxS+A7OXZrUlFAaaiJDJg3BI0OtdYJrPLCAyHxGaQSaaLeXA1njGQzIe8VA4AsuleL1k5eQLw5He8c1P8O/fv3o4PfWb8vKVXTavrB4N+fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 15-04-26 16:26:34, Minchan Kim wrote:
> On Wed, Apr 15, 2026 at 09:38:05AM +0200, Michal Hocko wrote:
> > On Tue 14-04-26 13:00:16, Minchan Kim wrote:
> > > On Tue, Apr 14, 2026 at 08:57:57AM +0200, Michal Hocko wrote:
> > > > On Mon 13-04-26 15:39:45, Minchan Kim wrote:
> > > > > This patch series introduces optimizations to expedite memory reclamation
> > > > > in process_mrelease() and provides a secure, race-free "auto-kill"
> > > > > mechanism for efficient container shutdown and OOM handling.
> > > > > 
> > > > > Currently, process_mrelease() unmaps pages but leaves clean file folios
> > > > > on the LRU list, relying on standard memory reclaim to eventually free
> > > > > them. Furthermore, requiring userspace to send a SIGKILL prior to
> > > > > invoking process_mrelease() introduces scheduling race conditions where
> > > > > the victim task may enter the exit path prematurely, bypassing expedited
> > > > > reclamation hooks.
> > > > > 
> > > > > This series addresses these limitations in three logical steps.
> > > > > 
> > > > > Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
> > > > > Integrates clean file folio eviction directly into the low-level TLB
> > > > > batching (mmu_gather) infrastructure. Symmetrically truncates clean file
> > > > > folios alongside anonymous pages during the unmap loop.
> > > > 
> > > > Why do we need to care about clean page cache? Is this a form of
> > > > drop_caches?
> > > 
> > > The goal is to ensure the memory is actually freed by the time
> > > process_mrelease returns. Currently, process_mrelease unmaps pages, but
> > > page caches remain on the LRU, leaving them to be reclaimed later
> > > by kswapd or direct reclaim.
> > 
> > Correct. This was the initial design decision because there is not much
> > you can assume about page cache pages which are very often shared. Even
> > if they are not mapped by all users.
> 
> Fair point. However, that's the trade-off:
> 
> Leaving unmapped caches to be reclaimed asynchronously keeps system memory
> pressure high for too long. In Android, this delay forces the LMKD to
> unnecessarily kill additional innocent background apps before the memory
> from the original victim is recovered.

OK, this is really not clear to me. How come you end up triggering LMKD
(or any OOM handling) when there is a considerable amount of clean page
cache?

[...]

> > > The race occurs when the victim process starts its own exit path (after
> > > SIGKILL) before the caller can invoke process_mrelease. If the victim
> > > reaches the exit path first, the caller might lose the window to apply
> > > these expedited reclamation optimizations.
> > 
> > Isn't this the problem you are trying to solve then? You are special
> > casing process_mrelease while you really want to expedite the process
> > memory clean up. 
> > 
> > The same situation happens with the global OOM and your approach doesn't
> > really close the race anyway. You send SIGKILL first and the victim can
> > hit the exit path right after that before you start processing the rest.
> > That is not fundamentally different from doing that in two syscalls,
> > race window is just smaller.
> 
> No, this approach completely close the race.
> 
> When it invokes do_send_sig_info(SIGKILL) with the KILL_MRELEASE code,
> the kernel sets the MMF_UNSTABLE flag on the victim's mm_struct in the signal
> delivery path (kernel/signal.c) *before* the task begins processing the signal.

OK, I have missed this part. I haven't really looked into specific
patches at this stage. I am still trying to understand the motivation
and your reasoning. So effectivelly you want to get SIGOOMKILL more or
less.

> When the victim gets scheduled and wakes up to process the fatal signal,
> the MMF_UNSTABLE flag is already set.
> 
> This guarantees that the victim's own exit path (do_exit -> exit_mmap) will
> utilize the expedited reclamation optimizations automatically, regardless of
> whether the reaper or the victim gets scheduled first.
> 
> For the OOM, we can use the same idea.
> 
> > 
> > All that being said, I do not think those special hacks for
> > process_mrelease is the right approach. I very much agree that the
> > address space tear down for a dying process could be improved and we
> > should be focusing on that part.
> 
> I think process_mrelease is crucial here because relying on the exit path is
> non-deterministic.

I suspect you are missing my point. I am arguing that those special
hacks in the address space release path shouldn't be process_mrelease
specific. I do recognize the value of the sync tear down need. I am also
in favor of something like SIGOOMKILL. process_mrelease might even be
the right syscall for that purpose.
-- 
Michal Hocko
SUSE Labs

