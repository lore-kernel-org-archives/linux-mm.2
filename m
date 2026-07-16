Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F1DC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DC96B00B7; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6DC6B00B9; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647A06B00BC; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20FD56B00B9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4E6114012B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:10:45 +0000 (UTC)
X-FDA: 84994372050.23.ED61A42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2CB7FC0011
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:10:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IME58BGp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784200244;
	b=kg2MLvX2dUge2kNKhUPxcPrBBlefm0jAvzHD3mkkD1URZWfnpW90PaDBMgGCZtfpwiZ5eH
	t9xU+6oVWRJjPFZ7cg1SvvJgVW1C3JsOyZ+fFxKbeqRJosw+Po2F0n/YytrkQcPywYB8Q0
	QL3VMbO8q+ZmbvZ1i1X3sW0+bG7Q5uw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IME58BGp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784200244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmPPDuiYXTng8WxmgDueZEPnjNUhF5XqoTiTiA+PltM=;
	b=ckB3EfGmFXJSOHxs0cjmPuzr0CsxIJD0o6nL/rVfVyJr+iu8CsR7YH+yOvBkaV0rONZ4a7
	+zKPDvLjod++Z+UpcKnE0IBDI51G+/7MTjMHowDf7b11c8Qpkl4pNSRHub94OJCfFI96W0
	h/371FtB9NOUlJqn3uzeyD7ulAzFR0c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1C4B6001A;
	Thu, 16 Jul 2026 11:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5D21F000E9;
	Thu, 16 Jul 2026 11:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784200243;
	bh=jmPPDuiYXTng8WxmgDueZEPnjNUhF5XqoTiTiA+PltM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IME58BGp+4VoXUsAiKFtPTar/BWz6xqDCOl6H1G++hdJbXGomex8JvqFdnl5AYWFh
	 IKpFdkzzBQx42d2q4Z+wbhDbCy79GFK99CluePEU7ywNJHcs3iah/x54b0GZzrFKA6
	 1LdhWEoh3Ik9uf0BpFV+iVoEQR9u0FE12zRLCZKj+pRFVmoofGNKe6zSdVNQsS4I0r
	 BrHvm1togaouelHFOds5Xi8U5JLcI2xfLBWOVRWk1RcIAQm9iXx8/sfXOZ61WojUcw
	 4HV1+wsEeRB3pKr1+0GYembo0QynfBRkXlOlMvYWCqr81dtu4ucVmIMz0yQoW0xQX/
	 BBlIH1IZu4sfg==
Message-ID: <a00664d4-01a0-413c-bc33-71c86cce7894@kernel.org>
Date: Thu, 16 Jul 2026 13:10:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: mglru: promote mapped executable folios after
 first usage
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 ljs@kernel.org, hannes@cmpxchg.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1784197559.git.baolin.wang@linux.alibaba.com>
 <7e3a5f6bdf70e0237027025f4593a3874d411f65.1784197559.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7e3a5f6bdf70e0237027025f4593a3874d411f65.1784197559.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2CB7FC0011
X-Stat-Signature: 1319pioa6s31gffrimcitsua1p4s6xdf
X-HE-Tag: 1784200244-5477
X-HE-Meta: U2FsdGVkX186OggmHfRNPvcIWkblW2dhskM/lmi4Bv0Xo2YFmCTge1ZQOKfk6tk4Jm/H+y9vgr2GUD/CbI9jYDeWaEq9IV7YJmmejsa7nt32crjqAw0qzHRjNjdmX3BKvHzCKeT1V4iDlKBwS/KXVTy+yOY9ilcd2hMAD1IYWKoXs2nXtEO7M4540XjnDaQEiU/78xfrM/2eLRg9MkkTkvSaqve7yvxJ1z+qLQBE9a+Gffi4smV+b/oNC5PT6yz9U0CrkNCGrJLTSC4tYzbomiViBpbcD514bYk6uFaIhiaODv9BZsYqHH841HdQElUPnfFh8rCLSKJYbHsFBMRxdUq3j0Q8mheEAaVwTeMTaFRo256ZzI+4MMZ9c4SMtztDPSq65mYxP1xmRms2YH/2hvbbaWgHC1goFDoITa1PKhFfZpl6RFW18HhNsj2H8QDA3xAFKlqgXDO72Luoz2QdNfw7FW+6ZrdxG+XesKSKygT38epcY68HNSLL44lpHpiqagkEZ8qxCmhCjPsd2f7eN8FcQxMuzooXfIEpqN+4g+2FqhtSepztNKINYhdpogLMc7my8g8X4cXJ4b6x0pOewESkyq5PKtsXios7EZkrtIXgT+OUplBfn/3kwflW+9USt0NOJlO7GjAi3cBR8WjWnbbzpd9jL43HQz7IrjtXwXfq9LiQkfylTatlbab3mWAOGMV6jtEWnEEl4mMCaRnXTwHR+VyNTsbP+MLMSr0etp674J/tJ2nUS3D3PYRGW0AIlGKN8A5Nfxjpc1VP/FbPFiRYedeuUiJuT07Qj1CpvIW+KK24n/QdFA0LNl93XeF4osTYvgt3XHfUdo1s3w1OdErpLM2NVQ/JtKRifbJYp43nAG5YOtZkRD1bnCFe5jGgpyUhuOC3u1tzREXqqiTQk3uAAvDIjy3opecwMEeoMRYVSo1BFOxmCM76DA8nsGFTi7wZ2Hv3FXISWta15dK
 KbK3r/z1
 qMS/2WwWmXkhAhrA7RlkPq97o1pgr0wg/d6pC9yw2j0769hBLhoO3EyrL6YW5FV9veUB6ATeamaQJ6ujMArrcvtbv6g66u4wszOtc6sHQUweZRxKT7kjHScCEyas5fW8xWYw93n+udIXkgP0i2oFakFWKrLJNaTL9M86J4wnorU6TUi/HelHGD06GZkywOPxzNPVs2IcBSGDujV5yGwN2UpcEebtgKRa0U0zd8+lVq4E9NTDmN44Nf6ey2gIljNrRzfDAch4j2Pf7X1zgqZPmqriE8T2YCQFncGys
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 12:46, Baolin Wang wrote:
> Classical LRU protects mapped executable file folios through commit
> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
> after first usage"), giving executable code a better chance to stay in
> memory, avoiding IO thrashing and improving workload performance.
> 
> However, MGLRU's protection of mapped executable file folios is less
> reliable. Although shrink_folio_list() checks references, the access flag
> of mapped executable file folios may have already been checked and
> cleared by lru_gen_look_around() or walk_mm(). Additionally,
> folio_update_gen() or lru_gen_set_refs() only sets the 'PG_referenced'
> flag for mapped executable file folios, which causes shrink_folio_list()
> to ignore the first usage of these mapped executable file folios and
> reclaim them easily.
> 
> Follow the classical LRU's logic, promoting mapped executable file folios
> after their first usage in folio_update_gen() and lru_gen_set_refs(),
> giving executable code a better chance to stay in memory.
> 
> On my 32-core Arm machine, with the memcg limit set to 2G, running
> 'make -j32' to build kernel showed some improvement in sys time.
> 
> base			patched
> 9248.543s		7861.579s
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/mm_inline.h |  6 ++++++
>  mm/vmscan.c               | 41 ++++++++++++++++++++++++---------------
>  2 files changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index b5c4dc0f3fe3..30fdf1056312 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -30,6 +30,12 @@ static inline int folio_is_file_lru(const struct folio *folio)
>  	return !folio_test_swapbacked(folio);
>  }
>  
> +static inline bool folio_is_exec_file(const struct folio *folio,
> +		const vma_flags_t *vma_flags)
> +{
> +	return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio);
> +}

I don't quite like a generic folio_is* helper to consume vma flags. Whether it
is executable depends on the VMA. When called from a non-exec VMA it would just
give a wrong answer.

Not sure if something like "is_executable_file_folio()"/"is_exec_file_folio"
would be better, to distinguish from the actualy folio_is* helpers that are
independent of context.

Also, can this helper just go to vmscan.c?

-- 
Cheers,

David

