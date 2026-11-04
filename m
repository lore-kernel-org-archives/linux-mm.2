Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D48606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NVo64i6H
Received: by kanga.kvack.org (Postfix)
	id 850DD6B00EF; Wed,  4 Nov 2026 02:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801D36B05B3; Wed,  4 Nov 2026 02:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1606B05B4; Wed,  4 Nov 2026 02:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 492BA6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:17:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61CC640330
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:17:29 +0000 (UTC)
X-FDA: 85396581018.12.E534DBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 81CE6160005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:17:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVo64i6H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793776647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ktg5izJKG60I2UPIEWlV3M+KtBzsylr/JSki197Myic=;
	b=bJsMDTPSY/QEv8CqHc5fURiBwSwAVwLCUE9L+ZnlasL4NLZJ5OqihHac+MDQqdnhSv9PUu
	H6kkRRQBz8XUsvTCf54YMP71XDxeMZ3Y+hZa1TNQQ2sVoBjffFc0YUa5dLruWO7d9SkgGI
	g6LeZqaK4hXpnbFF5/moZJQEMiNlKY0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVo64i6H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793776647;
	b=5WzUkHGbZcGirqqvzSNm3DcOFuFQ5987uTSn4lXFk7EOhPG83WGUnGoFgm+7MbWsl7pea6
	kL7IT9mwfWkEHwdqlAe3ucLOoAtGVBlS019kByKvCurP2kJs51/XhkfmMoBi+8L1NDlkGP
	mPgzWm8ySftAo70IAnb5F1u7/uPSNp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B37324391C;
	Wed,  4 Nov 2026 07:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41C11F00A02;
	Wed,  4 Nov 2026 07:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793776646;
	bh=Ktg5izJKG60I2UPIEWlV3M+KtBzsylr/JSki197Myic=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NVo64i6Hy2J2/JtCvmk7jr+3z3y7ow2D6wnKnOqR75VbQOb9ns/fhqmrpw5s7XOYO
	 ZTaun93U9u+EennRsz2Y8jXTpQwUVEFNJNitiu/lrdfG6oB5tUfN6azMEZqBASF3x4
	 mFQNzpy2iyhPQpr6xRHRcw+L7u4a2kqD6r7eiaH2wuwZgH8BUcSWx6Rw1T7cEwdzD6
	 3UZE4EBgQ30QNryMbH64W+sdA1VoFuQWVHvj6re8m/2E1Htsx3rujkqFkF5WI3Wgru
	 NjGR2wrqrbfeiV4B2GMLu/HCUi1LHyNM7CEsNxhhoX1rYOUsohwuY08qi+kjBHSPVq
	 ZX1CgzNdOPl3A==
Message-ID: <c714b285-4bd1-4475-880c-30aaed262fff@kernel.org>
Date: Wed, 4 Nov 2026 08:17:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] mm, page_alloc: several stable fixes
To: Johannes Weiner <hannes@cmpxchg.org>,
 "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
References: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 81CE6160005
X-Stat-Signature: h3ys8yr4asf69fp5m69h6mb33citnttb
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793776647-198254
X-HE-Meta: U2FsdGVkX181M+79uT4jXKX5Hyvp+/V7Xa7O+F8sMBXQQCZMtb3tPPNCp0boZUO3XfE0cuub1zh5U8hh26DV83y9e803hrRs3jgWeQcyxOUdJK9xz32VYlCb2D0hg2ahTxMS4eH/XaIqHubwxL0+pXCFU3ApLigCE8PXDHJ4fSm5WCED4fs/sKpCZFvKbSr2ZyztKfhmWwVyuyQWdyKZ1jyBWxQmnjcXl8OwJuLfdxJCApvO7fNnxvm5OT8biCf7rIAr+uP8+EaR9QIFYagnfBpw4o2tt6vdTHd4ttMFc1vtLPeUdm7n4kkwVBbb1/BYzKz/aRKCoqrHnUm4d3xFloqkl/FVSx39KiezuHGtejY2MwkXBUSJltL2m1kYTeQX8qhX85KW1d4hLJmOY7HMn1hURMDHHfffH9wykFuTV3ojHSZJTd97hJT80IhAvHT42ZZ9Hl86Od0KLKg4EqN+C8D2Jviiu+KQvP8Ism81NBlWK47NoK3r/WZjmkSpiozQdBXVBxX/OMce2ko4RcarAjQESebNFgp2wLMxUylWmxlFjuVv5vIp6etQXtRbwq8HPqtWBeSwfn1SsEtWf7XGuAQifp6z85pCClfEnShR82o3x1KZnMAtV5VKiksp+48zhJkR+QYu04iysXEi0kqsv7o7qlEfsvOJcVdKwgG9O9Ad/hMmoy84Zgyl/AwucvL5bmwSYD+DeC3hzZRNsmS1DjK1MFq8ZJ7Ce/Z8Pm2b2hVgCxbHOF7GmQD4FHs27SwtY+L2JsIkczFYkgrhMsNMkBTtceCKfMsKnhURUhsvF4smsOemLEQ7K89u4jiaK9aZ+qefcCsGUgrCv2WLkn6fRoA/lLBIRNQfaLDIsYjBiITWDa99jRSJ7dPAqFUNimFMYBmu91IRPVWWygMTgViVUZO4FHFU7k/S4zotuPiMldFprnMz92VRtyS0w+PO37GC6auCXZglI4pBWU0qtFR
 RKYqiH71
 WAI4Gr1LUC7jDApeyqLWpHVABdz9fTtBbF0sOX68yDr07ZzY5Jx8ahHd/mhZKQAD8F6BlQpmhAjS6a1e/bLhw4hGiIew4KWChePADd8KE4fdu73I6I6OqgIIAr78+ZnuSiQdebRTMcBj1mudLj065L7u1ikGcKWnRRzhw8pmFGHuhfTviKK6+YJiI8cfOhpG2CZJsDOdERqeGBuBrW7Xwgugw/cpeWsavOOLG3NLEOfU/IHrN4wk/A2GGUNaWROqNcnR5TPMulaSeUth0meOhCqlEMKoNjSgOgmtW4vqm7hCDX8D3wN7lp6UNj7GrJ0Pd0whIDMHL78XISRucC0ZobJWMB1MG2J7ejZXCf+FcLfbB1zMxXHUBkTr8hNUxtn/z3GdYN0fmUzCE4HjKyQ6R/PK4HJ97DZj84t0F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 17:16, Vlastimil Babka (SUSE) wrote:
> A bunch of fixes from Josef, filtered for page allocator by David.
> 
> I have tweaked some commit logs and a comment in one case.
> 
> In v2 some were dropped as they were merged already, the last one was
> changed to fix things differently. "mm/compaction: trust
> zone->contiguous only in the span" was dropped due to lots of sashiko
> feedback. compaction (as a pfn scanner) needs much more thought
> 
> Based on page_alloc/for-next-fixes, to be applied there as well.

Now done.

> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Changes in v2:
> - rebased on page_alloc/for-next-fixes
> - dropped 3 patches that were already merged from Gregory
> - dropped "mm/compaction: trust zone->contiguous only in the span" as it
>   needs more thougt
> - in the last patch, remove the VM_BUG_ON_PAGE completely
> - Link to v1: https://patch.msgid.link/20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org
> 
> ---
> Josef Bacik (4):
>       mm/page_alloc: clear ->private of deferred free pages
>       mm: page_frag: refill the cache for large fragments
>       mm: page_isolation: do not take slab pages for free
>       mm/memory_hotplug: resize zones under their seqlock
> 
> Vlastimil Babka (SUSE) (1):
>       mm/page_alloc: remove the zone_spans_pfn() check from get_pfnblock_bitmap_bitidx()
> 
>  mm/memory_hotplug.c  | 51 +++++++++++++++++++++++++++++++++++----------------
>  mm/page_alloc.c      |  3 ++-
>  mm/page_frag_cache.c | 21 +++++++++++++--------
>  mm/page_isolation.c  |  7 +++++++
>  4 files changed, 57 insertions(+), 25 deletions(-)
> ---
> base-commit: 743a99d7e339e81acaf76f3c902b23abb29abc15
> change-id: 20261027-pgalloc-ai-hotfixes-59bcd873a355
> 


