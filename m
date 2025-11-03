Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF826CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39318E0091; Mon,  3 Nov 2025 11:51:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE92D8E0057; Mon,  3 Nov 2025 11:51:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7A68E0091; Mon,  3 Nov 2025 11:51:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 978578E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:51:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 333D4139DB0
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:51:09 +0000 (UTC)
X-FDA: 84069885858.06.EDC6371
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 11174180002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:51:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LwXOJc1f;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762188667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K607a5Gs7qbahtSC1e+NSqHSnCO3TxUx9UKukeyvNPg=;
	b=c+sBoXHilWLQf/HujOt6kfq4T8JkFp4cfZFe3IYtyf9kOvItRxSZT0AAdmVklo61Fb4kuU
	z/6Rq34TJrRlEZRQcD8yMob/9GLTCZFSNsAUGtJBK5kiOPb0ucv291rLsOUBeUsV6+meEW
	Zsqa0qhMFMXwHtbDOwm48hCty+54f5c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LwXOJc1f;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762188667; a=rsa-sha256;
	cv=none;
	b=4OpySsMvU6UP7VLE/pnAwpIWsBhDBdTrI139VUl+i5Wss5Yzo9HgLUviuzMkfse5MyugyG
	pWafRXjx5q3ZDr/NhDCUY8p5ZYsxVu/Q6ug/Z2sCOqe/YtgG6UcGmYKg1i7uUrZBTqfRhS
	F5399QGak7eZZSqYnfHX48GyFIxY6jE=
Date: Mon, 3 Nov 2025 16:50:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762188664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K607a5Gs7qbahtSC1e+NSqHSnCO3TxUx9UKukeyvNPg=;
	b=LwXOJc1f/K6nb9wVO4GrLcftfn/ho3nwgJUxumOCpurUvQXx/93i+UNBV5Yq2bbZt7nvAw
	fMmzfMUc1I/3+ppcS733aXLz+px5KKfFl/WleoOFYiWgdyYLV+Z7APCP8bdRcshyLwBq9s
	F69Azfl+0DfAJts9qaYrtJW/yoECpf0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] mm/swap: rename __read_swap_cache_async to
 swap_cache_alloc_folio
Message-ID: <2gzofxcv3vbfd5l22drj6p67huf533nq6g2hnurr74ewbrp2gx@f7i6qabbuxng>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-1-3d43f3b6ec32@tencent.com>
 <ufy26fqfvaxqjywneec3hcuky7ozpa2fm63pxcuuberrvicffv@bkblomeix35w>
 <CAGsJ_4x1P0ypm70De7qDcDxqvY93GEPW6X2sBS_xfSUem5_S2w@mail.gmail.com>
 <CAMgjq7A+OBoH71qo=Vt65BeV7M9uOvkJ+9pQX2eq4-tqcKwVwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7A+OBoH71qo=Vt65BeV7M9uOvkJ+9pQX2eq4-tqcKwVwg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 11174180002
X-Stat-Signature: yf9kooyje5y8n3m7gtdebbo5mw96ibut
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762188666-161964
X-HE-Meta: U2FsdGVkX1+cPMCUxzwYLoEEUxLHBoDbi+3pvHHmjfbeCE/9ohvSXn/uqtKN23ABwJ2qUImK6dQYmE+Tlg8kfhq5mdsGLLwa+w5psWSbToDpWRQpHoOn63b3Dwldw1VKcd6V1aTSbSfGpyr9DYKkLXgGr/NNSxv8U79kwIDimZueQpNlG08vycyp20+D3NXrmTUn+69Z/MmUtHSN11QL/vwYLukG7polZWS3Q24Ge1SqB3iJD5W12E7T+Ehwu0FykUb/MhKe1j9AUp+JdTzvxBmcATsM8/yc3wAmpHxSKOpIYk90jdlQuB6z0IcM3/18HmW+1661bDZCq501YTHQnOOWBiTvDsKdrI7IyIUpntBbdWMVplLNrYeUP584hAsIdb1fzatoNC80LcLwwyawwHR5T1JGUnpduG+X4FwEabkaMqipp9fT0wBiPND56WIpV2/4EZmaKtWyNEcYmgJaFNCKzUUp1SmGf1/QYeujNMTK0iOEn1+wuNVvH26o/pEjkuXLUj2zlnvRgJPMWw0eFWtbEOMEG6rY/tXWg0IRfZotkNJ4gZdqfyypxBGdVsNwH7YNmeI7/JyUyvp+kzCxXui8q0pZGn5AZvRbMTVo0PgCXi5T7Qt9oKcYbCru1YJktG4h9+9HIIhbgYl2Yyx1IHEXhATHI37obaSyys1zu/Lqrw8oxCm/y57F6lKy+eE4YRLqajU+sBBRZ9cpigGO+OisDoaw3r+/ZSdrd0Z5y3QIKfmIuRgwsoaShfVb5KfIWfc/4Irn9ziZH51sQhnAdUL8S99B9Rszxqqx3OaQX5JHO05q05Ix/PlfwdJU3Ltza1o3fTkcReorzetRTPxM9//9KSMrwDyGCcCVhEbHN/xIJ60CNQ6bUb/QJQte4xksa00jJdd6wawGjgQ8JytRZFS1iPCkIRHHrGOFFqd6JImI0dJeRN2gpamyf0obaSQlQ0Fmapv5NaPWyFpL3uE
 5qSgI7k7
 AmaKJ5n9QUy+XakZNJ7F0IX2Qv4cJPwNOGchQzkcWDfiV9NntvE/SXOChUx45bREFgJgCgvH+YUznAqHgq0Wqal0vhbae1tcityYwEy8u2v9ozNGfW5Y1alRLPam+17ZkpIvPeZPYDtFn0E5HYPVj+shqWSPrJUxga2pSP3y6I18BUN/iIGL66IcEDbtXVrTfguGKVlZFebsM/OIsKmZBVtI2Y49plAV99KYsNQTC0OZE90ql0VeD3zWgWAHIprr3qlD5xZkAqy6JMXY/oEUEeYAYsbAmCAS27L4K237jK/NJKvQoEEbA3G3DTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 05:02:28PM +0800, Kairui Song wrote:
> On Mon, Nov 3, 2025 at 4:28 PM Barry Song <baohua@kernel.org> wrote:
> > > > +/**
> > > > + * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
> > > > + * @entry: the swapped out swap entry to be binded to the folio.
> > > > + * @gfp_mask: memory allocation flags
> > > > + * @mpol: NUMA memory allocation policy to be applied
> > > > + * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> > > > + * @new_page_allocated: sets true if allocation happened, false otherwise
> > > > + * @skip_if_exists: if the slot is a partially cached state, return NULL.
> > > > + *                  This is a workaround that would be removed shortly.
> > > > + *
> > > > + * Allocate a folio in the swap cache for one swap slot, typically before
> > > > + * doing IO (swap in or swap out). The swap slot indicated by @entry must
> > > > + * have a non-zero swap count (swapped out). Currently only supports order 0.
> 
> Hi Yosry and Barry, thanks for the review.
> 
> > >
> > > Is it used for swap in? That's confusing because the next sentence
> > > mention that it needs to be already swapped out.
> 
> Yes, swap in is the typical user, swap_vma_readahead calls this
> function directly, allocate a folio then initiate the swap in IO.
> 
> I'm not sure why it is confusing. A swapped out slot getting swapped
> in seems a very common thing?

I mixed up swapping in and swapping out :) I was complaining about
mentioning "swapping out", not vice versa. Sorry for the confusion.

> 
> > >
> > > I suspect you're referring to the zswap writeback use case, but in this
> > > case we're still "swapping-in" the folio from zswap to swap it out to
> > > disk. I'd avoid mentioning swap in here because it's confusing.
> 
> Oh, I thought the zswap writeback is considered a kind of swap out :),
> since it's technically writing data from ram to swap device.

We do swap the page out, but we use __read_swap_cache_async() to "swap
in" the page from zswap first.

> 
> >
> > I assume you mean avoiding any mention of swap-out? As for swap-out, we’re
> > swapping a folio out from the LRU — we’re not allocating a new folio.
> >
> > BTW, this sentence also feels a bit odd to me. I’d prefer removing
> > “swap out” from
> > “doing IO (swap in or swap out)”.
> 
> How about "doing IO (e.g. swap in or zswap writeback)"? Swap-in is a
> very common user, and zswap writeback can be mentioned explicitly.

Looks good to me. Thanks.

