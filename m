Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CBBCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D369C6B01A0; Mon, 19 Oct 2026 07:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E9B6B01A2; Mon, 19 Oct 2026 07:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFCB16B01A3; Mon, 19 Oct 2026 07:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 946216B01A0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:09:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FB96A06AE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:09:28 +0000 (UTC)
X-FDA: 85339104816.21.243766F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDE9280006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:09:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jUyi8xt+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="r/cWkKox";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="vP2iU/KQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1INO4fZ5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792408166;
	b=QI6vAO2Jn2HC8GvGTeikAEp9X6jijXZ5eeX6+tLX3znibK0oa0j7wsxzhf6YRzchSvIiD+
	XoQ2NLRmruq1+Kh+usEVz+lzYMiCJ2DDUi6T2s0ImTQ5ON8cPSQYihDNPE/MTdYRcRKa/m
	YWc3ekCGGfX9MDGW7THwVWc+lAjzlYk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jUyi8xt+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="r/cWkKox";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="vP2iU/KQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1INO4fZ5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792408166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gq7BTi28X0MDGY4Wer0uB8vTxYb2jvKYiZ45BtxKJ2c=;
	b=UA2C+DRKrqIqjtN/OFX0h1pvqtQg5q8FzqoW5AfnxJudT91hxMZnUyK5PxDDjBqTPJHUjg
	75XsF1Dqk+Ujzq0TrQ74cVB3lX42G8mdFaXLeoV/bPKEkQR5IdtbqIYwtAgc6a4iWRvgLM
	5SqpFFJ349wyUFfRPpni6InMsoOXz/4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E147D21C92;
	Mon, 19 Oct 2026 11:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792408164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gq7BTi28X0MDGY4Wer0uB8vTxYb2jvKYiZ45BtxKJ2c=;
	b=jUyi8xt+S1Aavm/AvcBEdsWotNWUNRCyeyDCrXdU6jscgEK+jhWWm4MSGE8gN2qU+wMuoI
	O8qsHpFbe9A0rzAcrCdKXT/sQbv7qYdk/IjxnAsxCRG2AaO2hhdS+Mrx1/xDBYdZEH702C
	wRrMFW+0B17f3D20vcnIs0e7D9248HQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792408164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gq7BTi28X0MDGY4Wer0uB8vTxYb2jvKYiZ45BtxKJ2c=;
	b=r/cWkKoxHCL0f7nv31VCAu4YipelFd+NUgoy8yLpQhKJXjlNcO1yX5jZMxkeYTwbQnZV2D
	WsVqR7wMk1sbk1Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792408163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gq7BTi28X0MDGY4Wer0uB8vTxYb2jvKYiZ45BtxKJ2c=;
	b=vP2iU/KQw9mgY9Pds2zMIXIqieXqRj8/SNztwYRkP7K2UApCAkckxI2q19zIu9qz3I+9RW
	zJ0d5UTSurL0XDoqiYK8oQOOnazj92VDIebphoJCRDQEZDwhW7SnNhk06bkb78lK3kUvf5
	RKKfINX9C/cF17qvSbPcl+0BgzuR5tg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792408163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gq7BTi28X0MDGY4Wer0uB8vTxYb2jvKYiZ45BtxKJ2c=;
	b=1INO4fZ5EzLW4J1DUFGNaJjM8kxd+KXi4JplrfLlymUJY78mzuDN3ed+cugs+e6ub/Hbd2
	Q9V0kwQqL/CEI3BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 333E6134B3;
	Mon, 19 Oct 2026 11:09:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jSX7AGL61WrzFAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 19 Oct 2026 11:09:22 +0000
Date: Mon, 19 Oct 2026 12:09:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Borislav Petkov <bp@alien8.de>, 
	Ankur Arora <ankur.a.arora@oracle.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Bharata B Rao <bharata@amd.com>, 
	Hrushikesh Salunke <hsalunke@amd.com>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, David Laight <david.laight.linux@gmail.com>, 
	David Rientjes <rientjes@google.com>, Linus Torvalds <torvalds@linuxfoundation.org>, 
	Teja Vojjala <tejavojjala@google.com>, Huan Nguyen <nhuhuan@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Message-ID: <atX3lpXQBHH1JPhW@pedro-suse.tail5790ac.ts.net>
References: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: DDE9280006
X-Stat-Signature: 1ond4tnmtk8wzusqwohymmzdbcse99qp
X-HE-Tag: 1792408165-802598
X-HE-Meta: U2FsdGVkX18SBgWLsiQ0r/L1NzUFvxK9ICIO7uQQzNRjHvv6mqjPIAN9AiaCba6e5W8BsWC5tNcXJo26vDSty/iKrsl3J/WCoKQXFTeFF0JIxPTiIZ+6fYTAUH54TYCSzjXvqbQLLbAYCdnujZANPO0oP/1KTKdlFgADl2Z43sx1Y4OMaWD7Xu+lU5CsXEAU0lJIOB2NXE+caxjZYpuhpQP/PjWfOStgR/4pknIOwB/pMM8YxrmowCf1kVp1rVwHMci/nCk8HgFqSYVdkwuFRzcTKXYgJtrAxZ5H0ckLbw23Q+4Jm7kXvOYszimKk8dj/grTWFJoABf3Rnu6JA4l4wGH2XiXUKMRrYxIpRN1PgRS5cMa689vzUZKzMzViiEJX6agAaVF8qnzJEkAvVWlhoNg/hx0i70G3qnMVqDkvkmDz2MvbQWHNpBbpOxmf7FZ2cHvwIR+IMY/5qTTmDvVGzUmAS7TAZazeVqDimMR4AeOG2S2RWIS94bRLwos9rP1WeRAVN3bhL03/lxQDrTChUQSop1xskx4IZ1X80FdLHuiajRqehLu6nGjIsI25JosIfyMzcxHIam6/6jaZd3yuhgtIigxlbODIgbqMI9Nh/E6p9keqrbzgiNLovB38OePDU7xYlAxQeNnbk0xH9qmuPHiY1b9Vto9oNyzQjFUgqU/BezffJIH7h9ywD0U0nDaVQ0xQutHkb68jo5icWPJxAalPm+2lWFO6CLRucO7498oKwRT/iW/eRE/GkWLhp3mbxiU6FzRaJ1kDXjUqeYmvwaBdmKF30fWy4x/dSu8BDiVnUUTBWA+bijzoV462kg+c30OtE2cP7uU/aWB1hx/lMZUTNVSKeNCnGVj+XDB96hP+Rxl3PZQtiR1e7SYI9gbb2eS7hiRCU2u7s5uej3HJuZ6HDONohrRPVlUYcFIy0xKjfD1pf28NG7yhelDed5IUmm/b8aA392KA6KLsr4
 26WoTCAL
 Ga3HzXAXhtjcRymXcNjptn7+bLT8AtOrp9V16D9EviptUpvqgKAhJc+Ay/cwFn9PIotb2hx4WR18eSx9uz/zqPvWVnjlhUk279fapE3sexxY238Qnl+sD1bL6KWc9vBiMXCk3fZOKLy2jA2UoNttAu4s+SUIX+hazD2RuU06CXQi/zrDo9cShg1W8zEUiNT0DQGB7qRkbN9MxHsDyy/Z5ycqNXOGB6//I7muwgyiX1j9nvH/8RdhyNhKr/c/b0STyd6aoTjEBEMl+Srl/DWymEYKIrlc/92IXInk3GrFy7JOsM38QJGOyJMKULt6O2eVwtdJXrWeU0T8cifTRC3tgxF59rxArMH67wNBg56rktzvuHFWDvByE1dx3pvd8UMVhNvlfiPBVXvCwz/C2kdpoRqojqH1ArMaJRDq66GsHYxcgaSi4UL+sszjbkmjftUGTCEaNv5gVyRnOagY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 10:06:49AM +0000, Shivank Garg wrote:
> folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
> so a 2MB folio makes 512 separate copy_mc_to_kernel() calls. Each page
> pays the startup cost of the string instruction ("REP; MOVSB" on x86
> CPUs with ERMS) plus a cond_resched().
> 
> Introduce copy_mc_highpages(), the page range variant of
> copy_mc_highpage(). When copy_mc_to_kernel() is available and the pages
> are in the linear map, copy the whole range with a single
> copy_mc_to_kernel() call, so the CPU can optimize for the larger extent.
> Otherwise, fall back to copy_mc_highpage() one page at a time.
> 
> On a machine check, queue the poisoned source page for memory_failure()
> and return -EHWPOISON, as copy_mc_highpage() does.
> 
> copy_mc_to_kernel() cannot reschedule, so copying a large folio with one
> call can run for a long time under cooperative preemption models. Add

Do we care, though? I think most architectures are full preempt/preempt lazy
at this point? Is PREEMPT_DYNAMIC the only showstopper?

> COPY_MC_PAGES_NON_PREEMPT_BATCH to bound how much is copied in one go:
> 32MB, the same bound clear_pages() gets from
> PROCESS_PAGES_NON_PREEMPT_BATCH, or one page on the fallback path.
> 
> Switch folio_mc_copy() to copy_mc_highpages(): the whole folio at once
> under preemptible models, COPY_MC_PAGES_NON_PREEMPT_BATCH pages at a time
> otherwise.
> 
> Assisted-by: LLM
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> On a Zen 6 system with CXL memory, move_pages() gets ~1.4x faster for
> 2MB THPs and up to ~2.8x faster for 1GB hugetlb pages (numbers below).
> When demoting to CXL, kswapd uses ~31% less CPU per GB demoted.
> 
> Changes in v2:
> - Drop the folio_copy() changes as there is little to gain here.
>   On architectures without copy_mc_to_kernel(), copy_mc_highpages()
>   falls back to the per-page copy_mc_highpage(), which ends up in
>   copy_highpage(). A batched copy_highpages() could help there too,
>   but I haven't tested it on those architectures, so that is left for
>   a follow-up.
> - Add COPY_MC_PAGES_NON_PREEMPT_BATCH to limit how much is copied
>   between cond_resched() calls on non-preemptible kernels.
> - Rebase onto mm-new (2887e63d2e8e).
> - v1: https://lore.kernel.org/all/20260427142036.111940-2-shivankg@amd.com
> 
> Test setup: AMD EPYC Zen 6, single socket, NPS2 (nodes 0 and 1 are
> DRAM, node 2 is CXL), with and without this patch.
> 
> move_pages() throughput
> -----------------------
> A single move_pages() call migrates 1GB of anonymous memory, as 512
> 2MB THPs or as four 1GB hugetlb pages. Mean ± stddev (10 runs each),
> in GiB/s:
> 
> 2MB THP:
>   direction         base            patched         speedup
>   DRAM0 -> DRAM1    19.57 ± 0.17    27.51 ± 0.78    1.41x
>   DRAM1 -> DRAM0    19.44 ± 0.12    27.33 ± 0.27    1.41x
>   DRAM0 -> CXL      18.66 ± 0.18    26.90 ± 0.51    1.44x
>   CXL   -> DRAM0    15.38 ± 0.59    16.60 ± 0.24    1.08x
> 
> 1GB hugetlb:
>   direction         base            patched         speedup
>   DRAM0 -> DRAM1    20.34 ± 0.13    53.88 ± 1.48    2.65x
>   DRAM1 -> DRAM0    19.10 ± 2.65    53.78 ± 0.55    2.82x
>   DRAM0 -> CXL      19.53 ± 0.08    44.10 ± 0.19    2.26x
>   CXL   -> DRAM0    16.41 ± 0.07    20.89 ± 0.06    1.27x
> 
> kswapd demotion
> ---------------
> Node 0 is limited to 16GB of free memory and demotion is enabled. A
> single thread bound to node 0 writes 96GB of anonymous THP memory, so
> ~80GB has to be demoted to CXL. Median of 10 runs:
> 
>                                base        patched
>   kswapd CPU time              4.25 s      3.44 s     (-19%)
>   kswapd CPU per GB demoted    63.6 ms     44.1 ms    (-31%)
>   demoted by direct reclaim    14.1 GB     0.46 GB
>   allocstall                   7427        370
> 
> With the patch, kswapd keeps up with the writer, so the writer rarely
> falls back to direct reclaim.
> 
> Other workloads
> ---------------
> - Memory tiering (numa_balancing=2) with Redis, GAPBS PR/BC, a B-tree
>   benchmark and Graph500: copying 2MB folios during demotion is
>   1.18-1.49x faster.
> - A userspace daemon moving 1GB hugetlb pages between DRAM and CXL
>   with move_pages() while GUPS runs on them: demotion is 1.43x faster
>   and promotion 1.28x faster.
> ---
>  include/linux/highmem.h | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/util.c               | 18 +++++++++++----
>  2 files changed, 73 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a..e43459dc58b0 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -484,6 +484,65 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
>  }
>  #endif
>  
> +#if defined(copy_mc_to_kernel) && !defined(CONFIG_HIGHMEM) && \
> +	!defined(__HAVE_ARCH_COPY_HIGHPAGE)
> +/*
> + * copy_mc_highpages() copies the whole range with a single
> + * copy_mc_to_kernel() call, which cannot reschedule. That is fine under
> + * preemptible models, but under cooperatively scheduled models callers
> + * should copy at most COPY_MC_PAGES_NON_PREEMPT_BATCH pages at a time.
> + *
> + * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this
> + * should result in a worst case preemption latency of around 3ms when
> + * copying pages.
> + */

This worst-case is absolutely terrible :)

> +#define COPY_MC_PAGES_NON_PREEMPT_BATCH		(SZ_32M >> PAGE_SHIFT)
> +
> +/**
> + * copy_mc_highpages() - copy a page range with machine check handling
> + * @to: first destination page
> + * @from: first source page
> + * @nr_pages: number of pages
> + *
> + * Range variant of copy_mc_highpage(). On a machine check, the poisoned
> + * source page is queued for memory_failure().
> + *
> + * Does not call cond_resched(). Under cooperatively scheduled models the
> + * caller is expected to limit @nr_pages to COPY_MC_PAGES_NON_PREEMPT_BATCH.

This is very backwards, callers shouldn't need to check this.

> + *
> + * Return: 0 on success, -EHWPOISON if a machine check was handled.
> + */
> +static inline int copy_mc_highpages(struct page *to, struct page *from,
> +		unsigned long nr_pages)
> +{
> +	unsigned long len = nr_pages << PAGE_SHIFT;
> +	unsigned long ret, i;
> +
> +	ret = copy_mc_to_kernel(page_address(to), page_address(from), len);
> +	if (!ret) {
> +		for (i = 0; i < nr_pages; i++)
> +			kmsan_copy_page_meta(to + i, from + i);
> +		return 0;
> +	}
> +	memory_failure_queue(page_to_pfn(from) + ((len - ret) >> PAGE_SHIFT), 0);
> +	return -EHWPOISON;

These codepaths look strangely inverted, it would be more natural if you did:

	if (ret) {
		memory_failure_queue(page_to_pfn(from) + ((len - ret) >> PAGE_SHIFT), 0);
		return -EWPOISON;
	}
	for (i = 0; i < nr_pages; i++)
 		kmsan_copy_page_meta(to + i, from + i);
	/* Or, ideally, kmsan_copy_pages_meta(to, from, nr_pages); */
	return 0;
}

in my opinion.

> +}
> +#else
> +
> +#define COPY_MC_PAGES_NON_PREEMPT_BATCH		1

I would suggest that perhaps this should be the fallback for non-preemptible
models. But it gets a little weird with PREEMPT_DYNAMIC I think?

> +
> +static inline int copy_mc_highpages(struct page *to, struct page *from,
> +		unsigned long nr_pages)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < nr_pages; i++)
> +		if (copy_mc_highpage(to + i, from + i))
> +			return -EHWPOISON;
> +	return 0;
> +}
> +#endif
> +
>  static inline void memcpy_page(struct page *dst_page, size_t dst_off,
>  			       struct page *src_page, size_t src_off,
>  			       size_t len)
> diff --git a/mm/util.c b/mm/util.c
> index 7f374bb8bf36..5015cfdfeaa5 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -763,13 +763,23 @@ EXPORT_SYMBOL(folio_copy);
>  
>  int folio_mc_copy(struct folio *dst, struct folio *src)
>  {
> -	long nr = folio_nr_pages(src);
> -	long i = 0;
> +	const unsigned long nr_pages = folio_nr_pages(src);
> +	/*
> +	 * Copy the largest extent possible to allow for architecture specific
> +	 * extent based optimizations. copy_mc_highpages() does not call
> +	 * cond_resched(), so limit the unit size when running under
> +	 * non-preemptible scheduling models.
> +	 */
> +	const unsigned long unit = preempt_model_preemptible() ?
> +				   nr_pages : COPY_MC_PAGES_NON_PREEMPT_BATCH;

See? now mm is aware of preemption models! eww!

-- 
Pedro

