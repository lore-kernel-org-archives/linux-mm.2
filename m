Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7F9CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D866B0005; Mon, 25 May 2026 06:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDEA86B0095; Mon, 25 May 2026 06:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5F56B0096; Mon, 25 May 2026 06:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA42B6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:29:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7172C12021C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:29:23 +0000 (UTC)
X-FDA: 84805570206.10.6F70002
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5EFC14000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:29:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JC6D2Bgi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=V8pO8y7y;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tIr/gFHi";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u0pKEILD;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779704961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CycC2ZMawe+cWFXV2MnLD5iCp+usEHsS0lt4PGUIcow=;
	b=Do4Vdmvk6yu9nXHCyEarv3DzS2KLD7SqLxdGawe00gwhTuaxRO2SC/XVYNZ1cbVJzvKcwS
	Ga5dbCtfirxRvc+nMXhBuRfiaYohx5uzhfx3eXyEY8Un1Oz+zNnjidD+UpK5muRAKy3XPU
	yYBFhW68vXLY2YZSjF2HFrinGt+C4G0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JC6D2Bgi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=V8pO8y7y;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tIr/gFHi";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u0pKEILD;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779704961; a=rsa-sha256;
	cv=none;
	b=5GPEF1r8vw4T+A7R5QjSoFHFVuEvAqT4GkZTr59H7YL4XygBVlFPETlArhTh5MerY9+1a4
	jq/DMuxtTmM2KyH2d5tiU8UDesoUjWaIZKUUe4EooMubIkxHmz5rv3TG4ahLFk2en3rHCE
	eioQznyZ+eF7FJOw+Mh+3Xvkwp0MzU8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E907D6712F;
	Mon, 25 May 2026 10:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779704960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CycC2ZMawe+cWFXV2MnLD5iCp+usEHsS0lt4PGUIcow=;
	b=JC6D2BgiXUbyJqfXHX3RNI8GRs8YEakziKzUofDhJZVuS68uX0Q+tCDD8o7g6i40xIK5zM
	RdIt2Jal0MRNkR61SPZh7HB5rz90J1sH798019RyRcFAW7Trtu7PsA601eyclMvQ7eVaW+
	Pz9kUi5LQ0A9PCxtPsi7jt/Gvimx11c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779704960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CycC2ZMawe+cWFXV2MnLD5iCp+usEHsS0lt4PGUIcow=;
	b=V8pO8y7y5KuM+PyWwu5eQIxIEToTkNitaofWoWpee8ooWNiGqni6lbh5spIgVSxf5tSFwk
	uYy9xBm29y1kGDBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779704959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CycC2ZMawe+cWFXV2MnLD5iCp+usEHsS0lt4PGUIcow=;
	b=tIr/gFHi9jYWVNG0daj1gTLufvBVem/idYtb/H3qo+ufEqEHabbDK8n6DNpG/HhQ5G65ei
	oHqQpgjxIGEFtUHAdlsjkUH6IWGQ0YxW2aXhQKmI/pRDVwgyfMW5/9h9PfDQmktbRtaa/4
	1deGSRpXlzoLVROBRDDoyLOR19FeE8M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779704959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CycC2ZMawe+cWFXV2MnLD5iCp+usEHsS0lt4PGUIcow=;
	b=u0pKEILDQ/Gq6We4ziTcV1jDtougCufoctiG8ZS+qm7NbZWpavmIucsPCuFNlL0z/IuwtZ
	OGD1fLs+4D522aCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4F6059BC8;
	Mon, 25 May 2026 10:29:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xm2QMH4kFGpRRgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 25 May 2026 10:29:18 +0000
Date: Mon, 25 May 2026 11:29:17 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Chengfeng Lin <23020251154299@stu.xmu.edu.cn>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, ljs@kernel.org
Subject: Re: [REGRESSION] mm/mprotect: shared dirty PTE toggle takes ~1.6x
 longer on v6.19 than v6.12
Message-ID: <ahQjTqw_m8lXFvsP@pedro-suse.lan>
References: <662955ba.f499.19e3b2cf478.Coremail.23020251154299@stu.xmu.edu.cn>
 <dfdef925-4127-4e7c-bbe1-e7b2542355da@kernel.org>
 <7bab1d67.f5c0.19e3c0979ea.Coremail.23020251154299@stu.xmu.edu.cn>
 <4fbfa9d.10a05.19e4eed247a.Coremail.23020251154299@stu.xmu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fbfa9d.10a05.19e4eed247a.Coremail.23020251154299@stu.xmu.edu.cn>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5EFC14000D
X-Stat-Signature: 86btnx5u1risjs7ghswsgc54ciuq9spx
X-HE-Tag: 1779704961-358270
X-HE-Meta: U2FsdGVkX19W615eOHnnRP6M1AgzUw/yovAuv6qiLo0URBpDtdLGgoOzkVysYfp1/6i6Qshhb/UQhkIePk+LkvODdL1S+yAAcERuJMWwSOcxXNHVrOr/pv2fNlMoOzGhHV6CcEz7qsB0GsD9T3BiWr0XTfzWShwHpotzD/D3D5tKGsmDsk4T+3qWYXn5NeEOti8IySy/SHeqF1UH+V4p28j6y4c+arNLGtA7Do0SCuBiwu19dPJFPUaAQKqwn4Pjyb4P2gKYsCRLGvUHRzhgBgovDhoPcadKSCUwe7+1T1F4/tnWWyDhNo4FtzJRUA+f4jO0XXGVGoNj1vUmP0G04BjpZd613v+JeE7LkjwzAB4jC0NKIrrnnKUvoFv0CEKMnf5TX5SVEef8qHJZYj/+VbpESp47BueZowgWnjPLwn4v4vEEbVhyZ1FNMv+18Oh+ZFryXL1MfJ0wzKZdjRvwAp/KeGxgl8D1zcoNmVgIZBgskez9J+Rs1OSEFMYxibfRu+4q6Lq8gNJTHM61YxQrPHCCjAnGyax9D7ySTJ61xhP0xKIWZMBknownvmRXeLUs13ksT7NSTDMvmQ/qWvxhAjt69tby8FzqEsxBi7aP9pt+mMj8mZZ1qXbUkVH6seVgM6oRl9YOW+DjEqIprQwohJltD+iR6TEol6SrQi1GH7vi7ppDbrwXcg2PVrCEZEFWpkqdKls20LMwohiPXorMU/yidwYw4AtdZxmyVggz1w//s6QbY+GIXYKckI1cvVWzpYI9K/AxACGx3yqaUc6JNbFu1D6+hd1gX1rGqJNzApRI2mEn28qtVX0jzA0rUGukMs4gmEYlvynf1OxP45W1fUeLASxo1x9kF71FT+kFFzBQ1kbvvj88dj3WYx1prgWtpCp+P4tDbn92Zzwb0lgwnjm3Pi5wIRKKMD6PXLzcf+XCfWK3v95pYYrKd1c8fC77KH0GfbEAhh9BVJXC9c+
 8GLePGv/
 V4x7VYGinR4j/+ssg/T14xYD3xw5OWFpVcvtWiBLcgXeV/H9IPAEPdhGcXxXVomepxosH3mlwLsl5advV/AGYXTUHPOmvyIV6pY5J6Rd8ihqR3q1MFAiy603oK6APsF8dJ0sM2k2u+UC87nceN2mWJixOxZc4P/W6y3jMWy+bbzXezlw/bHRM1w2A2436shkO6hoTWghRLU1LTun5S+EmZ1VINJGvcnwDxBe1a2bieNEUZOz3oC0+5P7D4WHzsaY723syNm9sgjGMdWP4RbXI/2lFIfUCcEZL7GFY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 05:03:44PM +0800, Chengfeng Lin wrote:
> Hi David,
> 
> Thanks for the pointer. I tested the current akpm/mm mm-unstable branch at
> 444fc9435e57, which contains Pedro's v3 two-patch mprotect series: the
> softleaf refactor and the relevant small-folio / nr_ptes == 1 changes.
> 
> I first ran a local sanity check, and then reran the same shared-dirty
> full-range toggle workload on the lab machine:
> 
>   kernels: v6.12.77, v6.19.9, akpm/mm mm-unstable 444fc9435e57
>   QEMU: direct boot
>   lab guest CPUs: QEMU_SMP=1/2/4/8/16
>   lab guest memory: 14336 MiB for 1/2/4 CPU, 16384 MiB for 8 CPU,
>                     32768 MiB for 16 CPU
>   repetitions: 9
>   order: interleaved
>   coverage: disabled
> 
> The primary metric is cycle_ns_per_page, lower is better. Here "cycle" means
> one workload iteration, not CPU cycles:
> 
>   CPU   v6.12.77   v6.19.9   mm-unstable   mm-unstable vs v6.19   gap closed
>     1      336.1     532.0       497.0          6.6% faster          17.9%
>     2      369.2     581.9       503.3         13.5% faster          36.9%
>     4      355.7     587.2       524.2         10.7% faster          27.2%
>     8      369.7     583.6       534.2          8.5% faster          23.1%
>    16      374.8     607.1       547.8          9.8% faster          25.5%
> 
> The 1/2/4/8 CPU rows completed 9/9 runs for all three kernels. In the
> 16 CPU row, v6.12.77 had one QEMU failure, so I would treat that row only
> as a supporting trend.
> 
> So yes, Pedro's small-folio work does reduce this synthetic shared-dirty
> signal in my setup. It does not seem to remove most of the gap to v6.12.77:
> looking at cycle_ns_per_page, it closes roughly 18-37% of the v6.12 ->
> v6.19 gap in the clean 1/2/4/8 CPU lab rows.
> 
> I also ran a separate state-shape audit, because the MADV_PAGEOUT follow-up
> showed that a timing delta can be misleading if the compared kernels are not
> actually operating on the same page state. For this mprotect workload, the
> successful runs across v6.12.77, v6.19.9, and mm-unstable all used the same
> 4 KiB shared-dirty PTE mapping shape:
> 
>   expected_match_ratio = 100
>   unexpected_results = 0
>   final_vmas_avg = 1
>   present pages before/after protect = 16384 / 16384
>   AnonHugePages = 0
>   KernelPageSize/MMUPageSize = 4 KiB / 4 KiB
>   THPeligible = 0
> 
> The state audit used the same 1/2/4/8/16 CPU and memory matrix, with 5 runs
> per kernel. The 1/2/4/8 CPU rows completed 5/5 for all three kernels; the
> 16 CPU row had one v6.19.9 QEMU failure, but the successful v6.19.9 runs had
> the same state-shape values.
> 
> I put the follow-up summaries here:
> 
>   https://github.com/lcf0399/linux-mm-regression-evidence-2026-05/tree/0c0e2d9/mprotect-shared-dirty-toggle/mm-unstable-lab-sanity
> 
>   https://github.com/lcf0399/linux-mm-regression-evidence-2026-05/tree/0c0e2d9/mprotect-shared-dirty-toggle/state-audit-lab
> 
> Given Lorenzo's question and the synthetic nature of this workload, I will
> avoid treating this as a strong regression claim unless I can provide a
> standalone reproducer and/or a narrower bisect. If this remaining signal is
> still useful to characterize, I can prepare a smaller standalone reproducer
> or try to bisect the remaining gap.

Yes, if you could give me more pointers (and a simpler repro) I would be happy
to take a quick look. Otherwise there's not much I can do here :)

-- 
Pedro

