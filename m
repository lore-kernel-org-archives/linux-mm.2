Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE07C44516
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5E26B0126; Thu, 16 Jul 2026 11:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840566B0128; Thu, 16 Jul 2026 11:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755D46B0129; Thu, 16 Jul 2026 11:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFB76B0126
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:04:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5D5540203
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:04:36 +0000 (UTC)
X-FDA: 84994961352.21.332EE93
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4C091A0004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:04:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KlPRBD5C;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784214274;
	b=xzHArVwpOrOgQIc3lOf5yWollG+Eedmwdt6NIHUWgvTGlIa1Wg97plGsPGaE3C7Uf6xszO
	TZoG4iylpGIgn0DVQfi1Ooq+WwY+NJRbvYyF2jKkwpu38pDqNRTXcv/2j+WZV29Ocw4dUV
	FMttiOeBjeIxfdSOoJszGppAJyauCgw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KlPRBD5C;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784214274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESEHmQjCMBnGaENVOX4xB1tescWaluk9TL1CPIBeov4=;
	b=shfU4ikAxob80VNVdzO+RogmSA3rMRnGcLEeYaBYULZdR4W0i5Y3TyAfc5YA/S6BL0vgv0
	Yhw5AE72PDRW/JFN59C8th6k4flfeLpwTZplcey0I/F6Oig8H9S36Q6RCZ0R+/DczNQhlX
	5dyRlCCa5wVlssrda9pnUslbo9N1RCc=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81ec29f1d07so34966547b3.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784214274; x=1784819074; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ESEHmQjCMBnGaENVOX4xB1tescWaluk9TL1CPIBeov4=;
        b=KlPRBD5CFc+U14Cq1AeOKm5yTMgh/cZT9sNS9OpBSpIod4+onZBQFTnFJlXTyZz1ZI
         NP+YP63f+mdLW3zU92WrmjfO7tQ+iXcJAgOxwC0DSnHEq1xum5/QbjKIQwm9jLO7nl4q
         3/87+tIQoeAu2azkn8cjtjuTp142BnlxWqVhUhEOgyzJ1PcV1uc7zeDfREvvXyX/UXPR
         zo6x6MemgdBwsv3Bgk6/oDbXXvwDkbRnkQ/SM8QMpESdcHkl2X/DT1RrgEr579VDpUJ9
         vpRtbwsNdxT8vS+YFlP+OO/w//17+yoKPVQ2ebuKEg447Bc9rzbI6UN4GNNj5K/E623F
         aHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784214274; x=1784819074;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ESEHmQjCMBnGaENVOX4xB1tescWaluk9TL1CPIBeov4=;
        b=KJjGufteciyCG3mECgXun4tVx7YR4pbMX42x7Z3uKaE61nmjj4ETakQsbSFAUGtHvh
         CDg2CuPG2/8S0rkNxSXLrYVJaTSjfOfHiyvPuc8vdnTmVwx9vSL9NOoTCFNkdTY/hvvN
         inxMBmH4g+aW895pytOIqFQePGjIPJ+9duvGNmURtUpQ012gShUs1RrSnTucgZzulBxN
         hDJHDqTXIgfo+oNKrYmovhEIs7Wj9VQlWYCjXgR+sRam/+C9xUX6UtGnYmo2P90nr5jP
         mJpubHtHSB00Bw6cYBQT46tUQe9Tsplfqm/CsM2qGq2AYB/k4072EIkqClei4WOIxNKU
         WNhw==
X-Forwarded-Encrypted: i=1; AHgh+RrYeahHE3pIO4zA4vNUd2/N5wwhjdztRvgv1zFlU3BO6PPzAxJLVfPl6iKiyWxctfs62Cu3n3eonQ==@kvack.org
X-Gm-Message-State: AOJu0YzAnch1JT9uCsymnsQyi02imujILkd4zjbBjTCEjrLuiY/srFZ3
	MQpycv3z8V/7aBmFNG0uUtY3vMHOew2VB9hCVYEVcZQCErW+P4x3ix9aJIsFpRVjQmg=
X-Gm-Gg: AfdE7cmowcyD576Ux3axNmiX5iqkGPshphC9gRff9lI/JGegankAKCfRlMnmcvCc9Xw
	DfyGMNhlkiM3XLKvhxfbLWccs5G2OFzR0G8WRv13m9VtmOImF9iGWLV8qqRHoWYHGAQCSqaJ2ah
	VChPgTBnHVA6Pg+yddqkYt5AxLOHKNyyLCDVv9fALbb652s4L3TYUAScC15Pmqp4jbs6n8oXgrf
	eoV+cG81Fa1b8NC99M/0nMMqYfH/LswJ/dReLpRD3V/L+oKADuSsd4uP65dF50PcmGtMjzL2qTT
	q3Ms8ww3iRuLmXJSt0U77GiPzV34YqsVZ263uyTcNV/2+FGcBIlazQ4WfEsiQsy1qGnVNXxcQiV
	1lLxa/aloqdI6pw2sfzceqShGi0fVjitoiN6mU3CxwVSU2hV4rEaVL/U9ZsD93s2PWQCaCpPgqJ
	DDUhRimFigIgiSsccpXIaAFgBe9PmikZEkPANNoo2H/enRXsemcoyfvb2apCeCDhcxvmtNnS1ki
	gQVTw6P+fxf
X-Received: by 2002:a05:690c:22c9:b0:7f8:7e50:6390 with SMTP id 00721157ae682-81ebb28d493mr96938907b3.50.1784214273078;
        Thu, 16 Jul 2026 08:04:33 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6c23d1afsm198963407b3.47.2026.07.16.08.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 08:04:32 -0700 (PDT)
Date: Thu, 16 Jul 2026 11:04:31 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Michal Clapinski <mclapinski@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
Message-ID: <aljy_-Y7OT6s0kj0@google.com>
References: <20260714205111.2497151-1-mclapinski@google.com>
 <178409777790.255896.16691338963510282908.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178409777790.255896.16691338963510282908.b4-review@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4C091A0004
X-Stat-Signature: qz5jzc4hz9bx8m65i7whph13cbeob8cn
X-HE-Tag: 1784214274-662739
X-HE-Meta: U2FsdGVkX1+tHNadEWLSk1Jyr/AvNV05HetywIVfH85IawkLlOdxH61BoeqIAd09OeUJaneGO6MH5usahLEPQNEcQRuh8dfzey/NvqpNWcWUXtSBHg50f7Jce6YRC4lKjdOdf7qd884WIOr2FJDqz8ypfx0BXBCWB6dafdElrjtMLqL/h9aXWc3zvx280IomBQICAevdhgJulZ+GQGC00UMjeeQ9UlO1cAinW+pF5ZEB1+kngyDhd4dvlL79BbGx5bb2hNxwj//Vrn04n4t5/S2R1czVP+FSZIxqHFC2hhS7L3CSB8z0+ZFomA/+HaNpPxycjfyvTsVAOq1ZXLyEi0MR0NiRwOa2MNzp/pDmo8A0nQQRpGhZFiEI5MIEgFnjpuleUcQRTGa9TLxy7/ZYzA8Y0iZFSUUdy4lJOJ8Oh9uk9mZxpqjfiXFNQnlr7kAHQdZZ9Uk/ywxdLPyfx4N0rzl7O29FFbksA+ENYppfieRiXx14NiCHT4B+DYjjJjMKBxs2zLsmRwssb85pQTm8rl7BhdVvkVzJocBhMwZm/DnEA34OU5PMrS75wxU4z1O1VII4JpetnvLHsCESs/ryvb8xxz8KS9pDxpLA8d/uthzBcHVJHvOJul9Lv0XVTR3v/74sCZR0kbF6MUptn089pDnBgPcnY5+dl70HPV83n/UHq7/koMSpKy2sunzfdte/30jeOKaZfsNVClSZCdprK/4G6YUqzsLUxIrPsKvP/4sDboxc+DoV1YK5qI81oJPJL7A/cR1WgOlXffqav7gMZb+K6uA3KV3VKCYQqU6F5zcXh74JStoDazq1pw393KAbUVlWm/LUneu4coaYstZEXmDzXuP5S4N1gZN/6G834K99ICMSRhH154TwvbKi9j3iXxixWcdjHKaOdEe/TSS2yCL/UMTr75wOthOZ8qES2dk0oomparn8shLTX1lrRr8VQahiRaHCNdsOex+sfoF
 MqGGv+2U
 LkxHSVP9dau7a0c+FmKp6+BjRaOLIJ9+Pq2BMYo+v0Lloq2WbD7J9+QHecbSfsaJP1BPuJs8UORBQ0JvVQS0KxfnCUo/tTvFIEdefSEtAKo+VBqz6KMirG6IQPnlqnAUvSLwcSAYy8e43bb9yXCRWGUo3rGk98XPNIaySVJetPfizzG8C5LqcRBrpiCZ0UQg4fBDX/b+69Pp1D+9nKr5wvuMKSjG2kMHYPB3NQTu1CglAFXVTtHZP2RRxBbgp7SZG6sHavL6rPZRysA6WyVgSnBxpE0DCKdMG43xq3ge1mhLs0hkqyg6O9FlioQ9ehcWhZxX/YNZd24IsFSXDxRHkIjuw3UyA2YCg4k4BopbbJy05CCxhY2T2N3k4SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-15 09:42, Mike Rapoport wrote:
> Hi Michal,
> 
> > I caught this crash:
> > BUG: unable to handle page fault for address: ff19164fffff8328
> > RIP: 0010:__free_one_page+0x1a1/0x6b0
> > Call Trace:
> >  <TASK>
> >  [<ffffffff913208bf>] free_one_page+0xaf/0x240
> >  [<ffffffff93973288>] deferred_free_pages+0xa8/0xd0
> >  [<ffffffff93971b4f>] deferred_init_memmap_chunk+0x10f/0x1b0
> >  [<ffffffff9396e265>] padata_mt_helper+0x65/0xa0
> >  [<ffffffff90fac402>] process_scheduled_works+0x202/0x410
> >  [<ffffffff90fae739>] worker_thread+0x1f9/0x2d0
> >  [<ffffffff90fb62fd>] kthread+0x27d/0x2f0
> >  [<ffffffff90fae540>] ? __pfx_worker_thread+0x10/0x10
> >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> >  [<ffffffff90efdc55>] ret_from_fork+0x145/0x280
> >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> >  [<ffffffff90e2e46a>] ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> > 
> > deferred_init_memmap_chunk() works fine without KHO because free
> > regions will never be neighbors. However, with KHO, free memory
> > will be split into (free && scratch) and (free && !scratch).
> > KHO scratch is aligned to CMA_MIN_ALIGNMENT_BYTES (which on my setup
> > is equal to 1 << 9 pages) but buddy can look at the neighborhood of
> > MAX_ORDER_NR_PAGES pages (which is equal to 1 << 10 pages).
> > This sometimes crashes when one half of the neighborhood is being
> > initialized but the other part is yet to be initialized.
> > 
> > To fix this, let's just align KHO scratch to MAX_ORDER_NR_PAGES pages.
> > 
> > Fixes: c6073743d0c7 ("kho: make preserved pages compatible with deferred struct page init")
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 4834a809985ab..50928aaa33710 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -38,6 +38,16 @@
> >  #include "../kexec_internal.h"
> >  #include "kexec_handover_internal.h"
> >  
> > +/*
> > + * This is the minimal alignment required by deferred struct page init.
> > + * deferred_init_memmap_chunk frees memory to the buddy allocator, which looks
> > + * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
> > + * If KHO scratch is not aligned to that value, buddy can access uninitialized
> > + * struct pages, which can cause a crash.
> > + */
> > +#define SCRATCH_ALIGNMENT_BYTES (1 << (PAGE_SHIFT + MAX_PAGE_ORDER))
> > +static_assert(SCRATCH_ALIGNMENT_BYTES >= CMA_MIN_ALIGNMENT_BYTES);
> 
> Maybe make it a variable and set it at runtime?
> We won't need to worry about different confugurations that override
> MAX_ORDER and potentail divergence of pageblock size from MAX_ORDER in

Do those architectures reduce MAX_ORDER when they override it? I would 
hope we could set the alignment once and make it large enough to work 
everywhere, rather than depending on dynamic changes even during boot...

> the future.
> 
> -- 
> Sincerely yours,
> Mike.
> 

