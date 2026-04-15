Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D98F7FA0C3D
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 07:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005746B0092; Wed, 15 Apr 2026 03:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8316B0093; Wed, 15 Apr 2026 03:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8A96B0095; Wed, 15 Apr 2026 03:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC94F6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:38:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66E7B1403A7
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:38:11 +0000 (UTC)
X-FDA: 84659986782.09.8E80EB7
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 593D580002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:38:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FuRNi9Ci;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776238689; a=rsa-sha256;
	cv=none;
	b=UObwQ5+cdnBwFGAKMoljFRdMMSlHNrnp5S1jiisMoW52gGmVS026cSyfiHEIQcgPsPV7bF
	0ml/fpgjBMlOj2WTelHf3KmV1mZL0ZwKtjw9CAtVd25Jh6wbt6JtIiC9J/GC5kVxtRGJY2
	OK+m59MnxMM34++56GE+24OEOaSY46o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776238689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8AC0yBpBWtYbBwil3XeUbd7KgN+8+gj84W8YqrBJck=;
	b=53yqt6zCVI1Itdg0XC028eWlMQ6BnbdFdEFqS14zA6MHFRUV4DYeXnD3IuWawvdV8BROkF
	/21pIs3xWttdheRF+h1H4UTgRUdF3qsaaZnQKEp7gtKfQHaoHFpEl6gCHI9engC0gAz/SI
	RVPxCvuBviUdIVoVS80RyT2Ae4K964E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FuRNi9Ci;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d6fbd0954so2644131f8f.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776238688; x=1776843488; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L8AC0yBpBWtYbBwil3XeUbd7KgN+8+gj84W8YqrBJck=;
        b=FuRNi9CiOelyjeInXRdL2aqG6cdjUkLdJZ5gU/9uNvpCokbEzb+hIfX2a5KTf47uDv
         MHjehHkqgV8ORXLXhSk0U7/aU/2W8YeTJDFykpBUFWAnH43hHGQXfmpuZx0KUtgkHeJr
         qfpcJ8n/NvUegr+VUA0YbjbKZTK2o8ZQ/Tdp/7evl4DVDx1aUqm2fyl63R4+AHMp/5gf
         OArOe4rYqJkfG2GIuziLQiDvr5R12ZnpcNCEQXAduGaVnv09ItDujL/M7PHzafXpYQ0F
         abHHyJZA1zZDB8Q5hW1/i/6UGxzcizrzc+Gm53nLO16d29qGN2jbIy0s5VVeYFb0iL81
         dmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776238688; x=1776843488;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L8AC0yBpBWtYbBwil3XeUbd7KgN+8+gj84W8YqrBJck=;
        b=XUXhfodAfPvrcSO9EhbhMXz3rNfMMmG0EUGr0Vx+hWOvsASPqZnoLsUNKX/XIaDvBs
         1acipp43rpjPtm6ylg7Id/wE1fYgY2yQvCvcAM+SdBmwCN3g9TVe4hG0Sqhg3d4Qwj3q
         5MAzzI+KEr1SuHvpP7FWouLiqQk63wF0LzHDQ8d0KZrI/rRv9aKRkFJXWngSowD3F8YQ
         NktkLaIiNVMf1Wb9dAq7IcNf0QKKuKZa+ee/oJafTJhnfjIaW6EimCGbPj5PJLX7ni3H
         bMUVJHtBIDvqmrrl5/nLZHbI8uilNqnRjWWgRC7BxIYTkjx2dMh8c/BFRC5SNm0kdb7q
         +XRA==
X-Forwarded-Encrypted: i=1; AFNElJ9zLv4bB18EYLCD92a0Iv05i7QwfCJqZogBZViX8TgyD+PL9LBLxuAFPNIiasUhmSP8WqrQRcF+Ag==@kvack.org
X-Gm-Message-State: AOJu0YxZzyeMTRmgOBff0xThBWnR8qHkqNMfgZx8d6yYkDTQNvVJh7YI
	JV9M+TxNGnOqtEqHYsc1Ph/8abk+fT8wa/dGKVO/ASbnadY/T3NK5dqanNa6O4Z0hAU=
X-Gm-Gg: AeBDiesf1ohCXo/Wi35V1O3vuBvlBcSOGW9Dc81VFaiLAzLLhVSYDoBgRENDg3bkvBP
	vmzSXYV4LOAdIRm74uYsfAze2Ek0c2r2QbF4lwnQNdWWsXZ1jy7xljYTURmE/RWetpF/wq/G4in
	UxDAQn+xoTkGGgU/QPuOX2RctfIlSC9g8j/Whe6ONqaECC3v8BVeJJFOaZL/0JGUNIy5aBeFFrP
	Z3UojPhoGhfJXwUNi2kF7oo9frMWdUjVCiMn8cS0KOvwh5TW+AIsDXoak+c38++s5lSP+upD2eU
	7m/0JePeoqDIrzNUfuCn0D46x43pFcTFQ+TTE+mTb+XtAd1G7MV3Hh3DMcFN32Bl+/Yw2L4xQlZ
	/hPOfgnOZcdqtxmzLGcMCnInT/ORpbELAsAF4lK3LQCPL6bsM0QYmO+UuwxWBmAk3UzpCcoPF4o
	7kCJzArqqu00N0N9k4JzP97a1KlKhK54+xf61tdPCzmq2o
X-Received: by 2002:a05:6000:1a8b:b0:43d:7e6f:37fa with SMTP id ffacd0b85a97d-43d7e6f38cemr11251115f8f.19.1776238687592;
        Wed, 15 Apr 2026 00:38:07 -0700 (PDT)
Received: from localhost (109-81-29-22.rct.o2.cz. [109.81.29.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead35c026sm2822191f8f.15.2026.04.15.00.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 00:38:07 -0700 (PDT)
Date: Wed, 15 Apr 2026 09:38:05 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <ad9AXVYxWCkHmh6J@tiehlicka>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad6c0DN7AGoOQ_Iq@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 593D580002
X-Stat-Signature: pw5tb7i31p9bwn4yrgexne48akt8b6j5
X-HE-Tag: 1776238689-480272
X-HE-Meta: U2FsdGVkX184FqY17FAjK5RX0AkJCQu86USA/Dq+Nfaue5DCEX+yIj7ToL5gDyZ2D/7/ncBR7wdvAmXP5sewRMEtwzwMLOcxV1uwmXSfrQO2Zm6C7tJ48OZg5OND0OYfbY+ZxFSHjXMMVRJAKpKeEbT79ZJXOJErl0vnOOSOM2K9N+K+PpnVrkWf3B8QqMKlm2e1LUeSWiVhOPmqIWtnQvYt1jGthxEcCdgpwT49cAPJ3JC+7U+pga5XlmhgIiRTkrdSG13TcKBlLHOKNgmtZRf7GxQjbd3FNNNRht6jLqZXz149K+Qdw/cjFesjYv26fQ+RrGpg/QSZvWAg/KgkQUTqjeyHZW/vdUACtbcTIoAY6C0GsUZHn6dlOpvgq2fsTQCP/4NVvvNTyTkXj75cr+Kxf6c2MnW+PAxEsXtTRgbauNkTLdI652d/cxgETbiRxpg0GfaOxAKmt6zIYh0+4ZvgMPt4ia5xXF61RBmzb3P7gx81Arj5Xabp9X92Go6fder+71twYBLxeMMJ+lHiqTDRpj6QAUguIyC/d1TwkJDFxre/8IOKWSfGHCSUOqkOy7G0Il57gLopD4c+5uizp/1Fg92hdptRdGBn5/qOqURu4opZx4O/fHLAZi/UOtFLUqBRR1y050QC83+KCzZxY45es8GD6VesKomc77P1jNrNq4uQn9Bz+mbANp7ZZOkj0bBfjZ2e5PTvO0RjLCC0MPc6tJUQl/UecEqqC7wzqcEeTr1SsXFyzFdo3XtsMKNS0IQvCR9cuNPw0003k0UM+stg7ia51GUPwug0fNrJAOjA1QxyRdeNehSlMKgreIqnH74SexPwCOZUN80VYzZBws/TM1J4qrWLkre012+X2y6qVQpsc4V3NzuzMe3Vn82VaZjpqPrqqpRjIjMd1J1Gu+LQPT07S+HkD0E8SrUI/wS9N3jCBXV882cki6mQUAIu25rAoP/NORylXrJM4R5
 Um+SGJBo
 A9ozNfyRITwIQnJZkSlkYzBjWsw7dM2lKqToPNB+g9BxEaK6gchda2db6XlIEG3b6RsI4o3ar3Yh1jGQTdnNNZuFt6qw9vJQydSlzC5UcLtVJ3hZ2nyFULo/VnprjS2dBCFc2bkbbbKMHZd15PIVEMFak3VY/A9ObqVWCVejKRW8qEbqiSEY7t/+KBq4UcSwkhoCDmBThnyp4/wFBJeaBwq4DQsIv5QH4Q4brd/PmvafIFuQLl+4QegHSibRTeGDNFXr6vmrSOPcUM89TB2cO1pMt/r66vr0lg8hWtpM4OYPK2rGvU0OoimruAGbut93g8M+ly0JMHZh2RX2Z7KKnAYxbWlVuWqjkdIsmEpYqLFTzkDCAyXQw4sUHYcfXIbA6D6WFFTqxWu91ayIARPZz/cpW5OVXXYvonhFuxWFCWp0+5sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-04-26 13:00:16, Minchan Kim wrote:
> On Tue, Apr 14, 2026 at 08:57:57AM +0200, Michal Hocko wrote:
> > On Mon 13-04-26 15:39:45, Minchan Kim wrote:
> > > This patch series introduces optimizations to expedite memory reclamation
> > > in process_mrelease() and provides a secure, race-free "auto-kill"
> > > mechanism for efficient container shutdown and OOM handling.
> > > 
> > > Currently, process_mrelease() unmaps pages but leaves clean file folios
> > > on the LRU list, relying on standard memory reclaim to eventually free
> > > them. Furthermore, requiring userspace to send a SIGKILL prior to
> > > invoking process_mrelease() introduces scheduling race conditions where
> > > the victim task may enter the exit path prematurely, bypassing expedited
> > > reclamation hooks.
> > > 
> > > This series addresses these limitations in three logical steps.
> > > 
> > > Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
> > > Integrates clean file folio eviction directly into the low-level TLB
> > > batching (mmu_gather) infrastructure. Symmetrically truncates clean file
> > > folios alongside anonymous pages during the unmap loop.
> > 
> > Why do we need to care about clean page cache? Is this a form of
> > drop_caches?
> 
> The goal is to ensure the memory is actually freed by the time
> process_mrelease returns. Currently, process_mrelease unmaps pages, but
> page caches remain on the LRU, leaving them to be reclaimed later
> by kswapd or direct reclaim.

Correct. This was the initial design decision because there is not much
you can assume about page cache pages which are very often shared. Even
if they are not mapped by all users.

> This delay defeats the purpose of
> "expedited" release. It’s not a global drop_caches, but rather a
> targeted eviction for the victim process to make its memory immediately
> available for other urgent allocations.

Clean page cache reclaim should be quite effective. Why doesn't kswapd
keep up in that regards? Or is this more a per-memcg problem where there
is no background reclaim and you are hitting direct reclaim to clean up
those pages?

> > > Patch #2: mm: process_mrelease: skip LRU movement for exclusive file folios
> > > Skips costly LRU marking (folio_mark_accessed) for exclusive file-backed
> > > folios undergoing process_mrelease reclaim. Perf profiling reveals that
> > > LRU movement accounts for ~55% of overhead during unmap.
> > 
> > OK, but why is this not desirable behavior fir mrelease?
> 
> In Android, lmkd kills background apps under memory pressure and then calls
> process_mrelease. If the memory release is slow due to LRU overhead (~55% as noted),
> it cannot keep up with the allocation speed of the foreground app.
> This delay often leads to "over-killing" - killing more background apps
> than necessary because the system hasn't yet "seen" the memory freed
> from the first kill.

OK, I see. More on that below.
 
> > > Patch #3: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> > > Adds an auto-kill flag supporting atomic teardown. Utilizes a dedicated
> > > signal code (KILL_MRELEASE) to guarantee MMF_UNSTABLE is marked in the
> > > signal delivery path, preventing scheduling races.
> > 
> > Could you explain why those races are a real problem?
> 
> The race occurs when the victim process starts its own exit path (after
> SIGKILL) before the caller can invoke process_mrelease. If the victim
> reaches the exit path first, the caller might lose the window to apply
> these expedited reclamation optimizations.

Isn't this the problem you are trying to solve then? You are special
casing process_mrelease while you really want to expedite the process
memory clean up. 

The same situation happens with the global OOM and your approach doesn't
really close the race anyway. You send SIGKILL first and the victim can
hit the exit path right after that before you start processing the rest.
That is not fundamentally different from doing that in two syscalls,
race window is just smaller.

All that being said, I do not think those special hacks for
process_mrelease is the right approach. I very much agree that the
address space tear down for a dying process could be improved and we
should be focusing on that part.
-- 
Michal Hocko
SUSE Labs

