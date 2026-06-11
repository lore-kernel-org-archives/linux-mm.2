Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428FCCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563B06B0005; Thu, 11 Jun 2026 10:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514676B0088; Thu, 11 Jun 2026 10:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4027D6B008C; Thu, 11 Jun 2026 10:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B97C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:46:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B27C01A064C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:46:39 +0000 (UTC)
X-FDA: 84867908118.11.2E3B59B
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52B98A0010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:46:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ef4txsff;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781189198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0yiQSirVK4gO+uFpLKC5e3Ko/lqIewVS97P9f8jq9I=;
	b=6SDfpZvZldlaotqErL/GST4MwbwrRC0H4Ul5KhaDdBDo0DgVIIhom0kgd6DD7iNpDsKBHd
	Z7nIf+OuD4Ls4Oi3SlDmw3rUkhxbFvX66XLk/WeIl8rvdzdP4pH1RCTwT3ro+DGmAFP5Uq
	komCJZAVW66FO5Il22PlXfYkQzt+u40=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ef4txsff;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781189198;
	b=XFIie9rbyo859LmOtW1uSOuURl6Y1eMyw/639E+gS+GIndoHpaarWplkvjsKGc8gV/HIvV
	qsVcgfO/zmCEO1bp+SgnrSitMqalZZg42zRsPqBwTqlKkl4lnJzIsRGTI0oV3pzNtKOU0g
	qyY0VbZz3D0FX9L8VYvU9g/5TrLQ6HQ=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781189192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G0yiQSirVK4gO+uFpLKC5e3Ko/lqIewVS97P9f8jq9I=;
	b=Ef4txsffxUT11EdWmmTGYv/ixEh1Vpo7jhf9b5jdVjiEacVbJXULiYdGHk7dQ2RSazPMeu
	IGz7j9FetbVY9ASafCOgyaOAUs5qScnG9j6qjssZnEwIpygZ8jLFriBTLBLP0fsiISGNKz
	DsBHcVRax27hx8EINn2yWki5eCpQmrs=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Jun 2026 14:46:23 +0000
Message-Id: <DJ6AVARSAAQX.MK0WG9C2K84P@linux.dev>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 <rppt@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>,
 <derkling@google.com>, <reijiw@google.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Yosry Ahmed"
 <yosry@kernel.org>
Subject: Re: [PATCH v2 19/22] mm/page_alloc: implement __GFP_UNMAPPED
 allocations
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Brendan Jackman" <jackmanb@google.com>,
 "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com>
 <7bfda0d8-2a7a-4337-8b55-d0c158df7839@kernel.org>
 <DIJEIELZ5DJU.26LYHOT4WR7A2@google.com>
 <DIV92L7AZOHG.1FKDUXLPZEUK4@linux.dev>
 <adaca36e-5896-407b-9f46-601ed5686575@kernel.org>
In-Reply-To: <adaca36e-5896-407b-9f46-601ed5686575@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 52B98A0010
X-Rspam-User: 
X-Stat-Signature: uanx9f6zgbhjcb6txj4nhdruky7h9o9r
X-Rspamd-Server: rspam09
X-HE-Tag: 1781189196-125458
X-HE-Meta: U2FsdGVkX1+VpqZY98oov1tY5vCXdYHvANDnLQiZ32bclLP//LHh7IRnngfsT44bFa/sgHLrhzO4ctjvBGd+XqwpgkaQ9a3+dRiDwtI/m/Qu2Yc3tmLp3iXnlfxWevDCyoATbXhM0zbCfIJSY1Rj/cPkC/8dIbMVnEq4Dcyiez5dhJ2cp5K+OB3VyEu68Yjh/PmYdEtBEy9LR2KU2D6a3rcTKtmvle5EqhaxepzxT+ltJfRim0jEkOqJrNwOdUxfRiQsf45D8CMPWgN+J28ddG9CPevWqmkfCnO7HnL8EKziIiDT4GmCXeHS/oOHzPhv/5IoEms597uG27f1wRaIywjGFg0wzDf/c9CpO8Ecxtif5XIR/IH5zoBzI36Ev3LJ8Dsn8L/Bkq2Hd82z3h0GLwQx78kFSdVLsvxmAv3vwqUMvoRaMqqbBHPoMq8amK+ZpDfxseokbQyzRUq4Qd3RFZFSIxlIJL6yqqDlStitIMfZwTIVilcicXEw6ZsQqfGdF+f/P7K91L7WwyD64kWeyC6ykQWpR9BTei3+HQbUMLQOkjD3IE8IRdXlBdRu+4GjJ7WcG4ANIPU0A9fm1XTbXIwvYzwW9l+4qjG7/GmnJUffg1HNrWuq6NX64om7QS71jsjvrYAwMDGwXFAxZ0t04/NmNBP0+k1Aopg32PMrrR6hAlvZLlDZpvAtjONCH1sdfZ8d8TrHYbfsoRVz1M4Cs/EYc8qCP7I3inOvncjyrAEG5zREYBXpYVMiuMExxG+/SaSM4CenTUi5dXjnIhEwDzn5ecglU2H8Ip5nkEIQhqYFQuY4OrtL1qEp7VSiX9mC2CN/BruMSRcvMRK+3V6ROJgKcChZbjoZrOPZXrFyyii34h7VId5PZn/omxfFl6rQ1oixv1hIeyuPNvguYX+OjqjnjxF5Um+7jgitOA46q2GAaF1rwymmHSd8dpppPS2QzldhDS3kWiEt10nbuqN
 Md/ioxwU
 7kYyYS76mrkMazZRvNVLusfm2o/EJloTgPOxvtxIMkjx96PCuS3WqP+kvTYVxLUYXOKCIRFHjD3xsNOlAflnSmbPSlTmmDfXZIzKMJqMEm6uuVZTUNLzvrshMmmaLwdKTJvYQJatrb/8ILlm1S0kxbypDMK334UuGCBLoYbNxC91LifAbLCe2MfXef2dWJECKFYkR5nO8STbwMLQT3DYqxV5DMH0KCFZuuziq7A9t75F1dW0dQY7s9Nh2Cy3gJuIzQuQ2ZvXa6oEuoRL8YkkSP2yIYGK26c149NldsgC7AGksLamGitr5S6gwTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 1, 2026 at 8:50 AM UTC, Vlastimil Babka (SUSE) wrote:
> On 5/29/26 17:02, Brendan Jackman wrote:
>> On Fri May 15, 2026 at 4:46 PM UTC, Brendan Jackman wrote:
>>> On Wed May 13, 2026 at 3:43 PM UTC, Vlastimil Babka (SUSE) wrote:
>> [...]
>>>> Uhh, speaking of compaction and reclaim... we rely on finding a whole =
free
>>>> pageblock in order to flip it. If that doesn't exist, the whole
>>>> get_page_from_freelist() will fail, and we might enter the
>>>> reclaim/compaction cycle in __allow_pages_slowpath(). But since we mig=
ht
>>>> ultimately want an order-0 allocation, there won't be any compaction
>>>> attempted, because that code won't know we failed to flip a pageblock.=
 And
>>>> the watermarks might look good and prevent reclaim as well I think? We
>>>> should somehow indicate this, and handle accordingly. Might not be tri=
vial.
>>>> Or maybe reuse pageblock isolation code to do the migrations directly =
in
>>>> __rmqueue_direct_map?
>>>
>>> Ah, thanks, I suspect you are right.
>>>
>>> I did fear there would be some sort of case where this "not-quite
>>> reclaim" interacted badly with the actual reclaim, and I tried to test
>>> it by running some stuff in parallel with stress-ng (allocating
>>> __GFP_UNMAPPED via secretmem), and I didn't see a difference in the
>>> effective availability of memory. However, I suspect testing this is
>>> quite a deep art my "run these two commands that I copy pasted from an
>>> LLM suggestion" test was just crap.
>>>
>>> Do you have any workloads you can suggest for evaluating this kinda
>>> thing? We would definitely see it in Google prod (I think we see this
>>> kind of issue with our shrinker-based internal version of ASI distortin=
g
>>> reclaim behaviour in ways even more subtle than this) but that is not a
>>> very practical experimental cycle...
>>=20
>> I slop-coded a benchmark:
>>=20
>> https://github.com/bjackman/kernel-benchmarks-nix/tree/master/packages/b=
enchmarks/secretmem-vs-frag
>>=20
>> It does some mmap/munmap patterns to try and generate fragmentation,
>> then spams secretmem allocations until it gets OOM-killed.
>>=20
>> With this series, I see the OOM-kills happening noticeably sooner on a
>> 1GiB VM:
>>=20
>> metric: secretmem_allocated_bytes (B)   |  test: secretmem-vs-frag
>> +---------------------------------------------+---------+-------------+-=
------------+-----------------+-------------+-------+
>> | kernel_release                              | samples |        mean | =
        min | histogram       |         max | =CE=94=CE=BC    |
>> +---------------------------------------------+---------+-------------+-=
------------+-----------------+-------------+-------+
>> | 7.0.0-rc4-next-20260319                     |       4 | 683,147,264 | =
643,825,664 |               =E2=96=88 | 715,128,832 |       |
>> | 7.0.0-rc4-next-20260319-00028-gf00246eb72cd |       3 | 623,553,195 | =
551,550,976 |            =E2=96=88=E2=96=88=E2=96=88  | 692,060,160 | -8.7%=
 |
>> +---------------------------------------------+---------+-------------+-=
------------+-----------------+-------------+-------+
>>=20
>> So... I think maybe I've reproduced the issue you pointed out? I will
>> try and fix it and see if this degradation goes away.
>
> Since I assume the fragmentating allocations are movable allocations, it
> might be the case, yeah.

Alright, so I tried splitting NR_FREE_PAGES_BLOCKS into two counters to
track mapped vs unmapped blocks. Then I gave
compaction_suit_allocation_order() an 'unmapped' flag:


@@ -2510,19 +2510,39 @@ bool compaction_zonelist_suitable(struct alloc_cont=
ext *ac, int order,
 static enum compact_result
 compaction_suit_allocation_order(struct zone *zone, unsigned int order,
                                 int highest_zoneidx, unsigned int alloc_fl=
ags,
-                                bool async, bool kcompactd)
+                                bool unmapped, bool async, bool kcompactd)
 {
        unsigned long free_pages;
        unsigned long watermark;

-       if (kcompactd && defrag_mode)
+       /*
+        * Might need to generate a whole free block regardless of the actu=
al
+        * allocation order:
+        *
+        * - When allocating an unmapped page, because the allocator only u=
nmaps
+        *   whole blocks at a time.
+        *
+        *   Why doesn't this apply to the other way around too? (Mightn't =
we
+        *   need to _map_ a whole block?) This is a temporary simplificati=
on:
+        *   currently, unmapped blocks don't contain movable pages, so
+        *   compaction isn't going to free up one of those.
+        *
+        * - In defrag_mode, because the allocator is unwilling to "steal" =
pages
+        *   from the "wrong" block.
+        *
+        *   Why is this only under kcompactd?
+        *
+        * Temporary simplification: unmapped pageblocks are currently
+        * nonmovable. So if the compactor is trying to service a
+        */
+       if (unmapped)
+               free_pages =3D zone_page_state(zone, NR_FREE_PAGES_BLOCKS_M=
APPED);
+       else if (kcompactd && defrag_mode)
                free_pages =3D zone_free_pages_blocks(zone);
        else
                free_pages =3D zone_page_state(zone, NR_FREE_PAGES);


... Then, I changed __alloc_pages_direct_compact() to try to try to
compact for a whole block whenever we are trying to allocate an unmapped
page (note I think there's an orthogonal bug here where it leaks memory
when there's a "captured" compaction):


index 4f04e897c5374..7eed22f3b26eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -824,6 +824,9 @@ compaction_capture(struct capture_control *capc, struct=
 page *page,
            capc_mt !=3D MIGRATE_MOVABLE)
                return false;

+       if (freetype_flags(freetype) !=3D freetype_flags(capc->cc->freetype=
))
+               return false;
+
        if (migratetype !=3D capc_mt)
                trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
                                            capc_mt, migratetype);
@@ -4469,20 +4472,27 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsign=
ed int order,
        struct page *page =3D NULL;
        unsigned long pflags;
        unsigned int noreclaim_flag;
+       unsigned int compact_order =3D order;

-       if (!order)
+       // TODO: Is it OK to always run compaction like this?
+       /*
+        * Unmapped allocations benefit from compaction even at order 0, be=
cause the
+        * allocator will actually grab a whole block.
+        */
+       if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED)
+               compact_order =3D pageblock_order;
+
+       if (!compact_order)
                return NULL;

        psi_memstall_enter(&pflags);
        delayacct_compact_start();
        noreclaim_flag =3D memalloc_noreclaim_save();

-       *compact_result =3D try_to_compact_pages(gfp_mask, order, alloc_fla=
gs, ac,
-                                                               prio, &page=
);
+       // TODO: deal with captured page, if we changed the order it will h=
ave the
+       // wrong order. Also check it respects the freetype flags.
+       *compact_result =3D try_to_compact_pages(gfp_mask, compact_order,
+                                              alloc_flags, ac, prio, &page=
);

        memalloc_noreclaim_restore(noreclaim_flag);
        psi_memstall_leave(&pflags);

Full code:
https://github.com/bjackman/linux/tree/page_alloc-unmapped-2026-06-11

This makes the regression above (faster OOMs) go away, but it seems like
a pretty blunt approach. But then I'm realising I don't really know why it
matters? The main thing is presumably that we are more likely to
pointlessly attempt compaction or compact more than we need. But in that
case, aren't we already in a desperately slow path? Does a little bit of
extra work in __alloc_pages_direct_compact() really matter? I couldn't
measure it in a benchmark (kernel compilation alongside stress-ng
--secretmem).

