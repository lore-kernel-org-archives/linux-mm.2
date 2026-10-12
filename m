Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67798CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8695C6B0095; Mon, 12 Oct 2026 06:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841236B0096; Mon, 12 Oct 2026 06:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757786B0098; Mon, 12 Oct 2026 06:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA1B6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:36:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9B19A8987
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:36:41 +0000 (UTC)
X-FDA: 85313620602.30.B39E885
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0183E14000B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:36:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBgMd6hF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791801400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0Ru+UULBjDJTakg+6YSc+KSC2SkZhPc3GekW03A8bg=;
	b=RXZKN/8YVZkCUM10GryBiez0UTPPreIkzjqkvbk3CpfdrjRYNRgmEYr+riJPQisBTUO2eB
	OhX5c0uwunJyilMduYI8Z8BOF8pzSVXaXrk64cdJ1fXc2UbpNNpcD7NTfqMt+cORtKikWB
	mA8x3CRn981JU12SnZI3qshUlyb/J8c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBgMd6hF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791801400;
	b=bGc+K0G4yiLhDyPUPU9wUYM+xn2+am2O+BqGGWOAe4pgDWDdsg/13xn/JqAQw8Zx05d1VY
	2PxoP5uZgsdOjYxl5FGuf3lEfcgWxrYMYWkZI4V/eYwa9J4Ikla6SlPcgIQoWSXq8AK9xE
	AJ/GQaUjen3fBbeQHTfMqN9Mbgcnhls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 149B343A9B;
	Mon, 12 Oct 2026 10:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1BD1F0089B;
	Mon, 12 Oct 2026 10:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801399;
	bh=d0Ru+UULBjDJTakg+6YSc+KSC2SkZhPc3GekW03A8bg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nBgMd6hFMwuCIMEM9dpBw5Ng/bXWnZQf8qC5gP/NgD3E+kjXB414nVqvhz58wZRxn
	 /XRcRinw9FqmQV2kYqX0W/Ac/4AuGlZbLpQvpWRPn0Jx85m8QyrziqQULFEGRSB7DD
	 oPteniB8ChUBmZFVRijAy4y9UMXV/UPnsW2GUn4o9K5uNuyg/sz6PohKdZzjTv3PJg
	 qQKZyBbuDuQNdkRUnsc6hrQ3glx9ALYzYMj+pM7p4A/aAGIPo2pqjXAxEE+j9+XUgw
	 e2lk3wGbqFGapkvO4e/efpchStfSbSxvWWApO6ut/64OwO/Wb/DSSUWTwIlYhfWQow
	 Din+DVEpP32BA==
Message-ID: <40fc5d04-2a20-42c4-9557-7277bc981172@kernel.org>
Date: Mon, 12 Oct 2026 12:36:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] mm: page_frag: account page_frag pages in vmstat
 and meminfo
To: Yifan Li <liyifan21@xiaomi.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>
References: <20261010025941.1253-1-liyifan21@xiaomi.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261010025941.1253-1-liyifan21@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5f45mhutbx1ims9hzge8sp6ix1e8mmwj
X-Rspam-User: 
X-Rspamd-Queue-Id: 0183E14000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1791801399-856945
X-HE-Meta: U2FsdGVkX1/7cs5vky+k+/bwxZmhblCj1w0TfWZpaeUshERdTNW4FgVJLnPuM2BtzUhm8XzDMSSEV541TuoEMpNHP9vWR2godFa23jzyCutzmRMWRdsPw8BqdJsqHMvTj5nUYy297AC6eXv40lLA9Dkf3gDcpvXPbwCy1xkU6egsD6aiD+QvTX4gzVzz+LsqC9y2+iso9DuSqOg0zYxuiI4tkK/nPLi15TLxlD72ty3km9+mTVPU6S3pPIFkUtADVyh0KEQsucBHfQvOjflKE1EmRKCUc9syPlrsi7NM7TXQJN/MJyuSmsRtSC8EKDLSQ3inKZhMF5tTc90KwTXhOI3Gb+R4sibJBOkU53updIIm0A2HxrLTb/Wpn+kJFPSBZz5Te4AaD4czdupWEacFR2eiohdv25ufcllmi53RNNzD/avcrSUM/T5TQCLUURFwWt8gjaKqwlf2nqvsvmxSamvYf3RiCuispkdl07L9OJdtnGTlqnCFF0qeJQGOF1jQyS2bp3Q6mORJJZUI2Z8JuA+13gqfBYnFYNrMjwlgcllLudxoVbL1ug6KsaypDlpNYP08m2GGcVxVBDBh191uP9wtBzBLh0uzGfNCTgm6p6/4bsVwB/QC5Mk4+CRJk36MwCi/So/WEFYTKB4sdfyVMWbYJz9ZMKMn7QKtcBGWU3MvDbXbQFHnUye3HUqjS/VTvCOQL575JBtmKcQj/qdtthJ0OHiPlc5MjYbs9clNrT+hsh82aACh2mjZVZ5BiM7wbfLt3FzT0WySqWr5S2ARHG5NcYOlINaZNOEbdDm5PNkqNup5RjwfpurfJhugpFFqgTK+fiO/cI8CS9dKNikPsuPP+PjkpI3hB4622ZbGcRrn6QerpNr5NsVoQxlicKLXA/OcMaD4/f4cRqz5aHWBR1u8WgQpNNb9w6h3f0IVvYJ3d3mX1ldDcZYtQaKPMPIdXmA+5kNDRiZ3G+AREe9
 C+eWkwZ1
 XMfQYCEAqEQcd2Mo6KNbzSMPf/7kEHdpoWjNJQqKdpMC3A1EAQ4Nqj7K8inN0YEHJoEVVbo2fhGuZttoAiQC2Gq4bMCtDreR6K0x1F3cBaaosLj/FPvCvLRIArSpGjmcLMu1yoFSEFbin2HrzJK0JpGYcwSFgb7Ja4NyOnDQgS2pzQnu7PH6k38nCv9kQhzavwlqy7cOWugp+NOee2aK09QDzWxOL5UFM707nB3n2fsdBff5wt/4xqWnojHZ/cfkO9zlx7EJSIs0OSjywZD11OLKx2utKo6ElvAdYR0CiUHkq1GJqWanZx/mScygIiKNzeqZL9nFVCEoeW8otWgH4/aHvmjvR6v6yz1fUH/V69pf4xhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 04:59, Yifan Li wrote:
> This is an RFC.
> 
> Pages held by the page_frag cache are not accounted by any memory
> statistics counter, so on systems that derive "LostRAM" as MemTotal
> minus the sum of accounted memory they inflate LostRAM and lead to

Sorry, what exactly is subtracted from MemTotal?

How would any other kernel allocations be treated?

> misleading "leak" conclusions, even though the memory is legitimately
> used by the network path.

Assuming "leak" in such scenarios is questionable, sorry.

Aren't most page_frag allocations short-lived? Or is this more about the
page_frag cache?

> 
> The page_frag allocator (page_frag_alloc / napi_alloc_frag /
> netdev_alloc_frag) backs sk_buff->head and the frags portion of
> skb_shared_info.  Unlike slab (NR_SLAB_*) or page_pool, page_frag
> pages have no counter.  A preliminary measurement on a 4K-page
> arm64 Android device shows 14432 kB (3608 pages) of page_frag
> pages already in use at boot, and the memory footprint grows
> larger under heavy load (e.g. sustained traffic through the
> virtio_net / tun receive paths).
> 
> Patch 1/1 adds an NR_PAGE_FRAG node counter and exposes it as
> nr_page_frag in /proc/vmstat and PageFrag in /proc/meminfo.  Pages
> enter the cache through a single entry point
> __page_frag_cache_refill(), so the increment side is complete; the
> decrements sit on the paths that free the cache page.
> 
> The remaining gap is on the release side, which is open: a cache page
> handed to an skb frags array (skb_add_rx_frag() /
> skb_fill_page_desc(), without an extra get_page) is freed via
> put_page() (kfree_skb -> __skb_frag_unref -> put_netmem -> put_page),
> bypassing page_frag_free(), so the counter can over-count under
> network load.
> 
> Closing that needs the page to carry a marker checked at the common
> free path, e.g. either
> 
>   1. a page flag: PAGEFLAG(PageFrag, page_frag, PF_HEAD), accounted
>      and cleared in __free_pages_prepare(); or
> 
>   2. a page type: PGTY_page_frag reusing _mapcount, accounted in
>      free_frozen_pages() (requires that page_frag pages are never
>      mapped into userspace; true for the current RX paths).
> 

Certainly no page flag.

A page type might be the right choice. I don't think Willy planned for that [1],
IIUC, the bump allocator was something different, but another page type
shouldn't hurt at this point.

[1] https://kernelnewbies.org/MatthewWilcox/Memdescs

-- 
Cheers,

David

