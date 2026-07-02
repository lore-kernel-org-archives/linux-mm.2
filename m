Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FCE0C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154466B00E8; Thu,  2 Jul 2026 21:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105A26B00EE; Thu,  2 Jul 2026 21:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0439D6B010B; Thu,  2 Jul 2026 21:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0BFE6B00E8
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:08:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6006DC174B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:18:41 +0000 (UTC)
X-FDA: 84944949642.21.213933E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B05EA20004
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:18:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZF2hnxBY;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783023519;
	b=ffd18Xfr/buzIXSc2HI/Nylnw86UhmtAAllsRhnETvt1CXCdnwPcVoCx0Hr9jg8XgtnOgN
	mRx7ENaw4B0m+mV9/pQ0bH1cHTW7LUp9xc2kHi32igc5+uTkM0L4pA0XaTs9HfEcQQTom9
	3ZZMNI6qgHDCDChwW2U0+ks9J1TaR70=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783023519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJVj3aZrzou3ulR6wLajsObd6FMKWMyiLZL8yCyBvek=;
	b=Y+deedioX27Bp1ahP1PxUYP6b9YLLyjoFRyk1hNmOedVddP1qO03jRlVnLMMGVi+YGQK7R
	XPJ+j+aWhZi4CuI/1lRvGB3SPPlEFCPlPg61F4x7IxGcaUSV9Yd6zwE4Q4tOGvzJoFmMif
	643dBaM9i4dL2d6c96MgLlEFV1pt1Gk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZF2hnxBY;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB9B4433F1;
	Thu,  2 Jul 2026 20:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170131F000E9;
	Thu,  2 Jul 2026 20:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783023516;
	bh=aJVj3aZrzou3ulR6wLajsObd6FMKWMyiLZL8yCyBvek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZF2hnxBYbHqnz/AtyCwcoywaVufriI/VFNc7GpUjb8cSGNRr+7TnrNNgOmfv+0MSr
	 WlkHLEAoHeBDF6pZniDqHPaYeXvJo+pKK5qshRdzuZl/bGGy/KhchjnGNThO7nQJJt
	 SuD5x+8HWNBm+te2Fj5zU+tQLfDITVCERgQn6ETA6WlyocN56nqcCMSBaOs4/nXICW
	 f3PKTSh2Nf/phfbvX9+VvpNciEBssNY3Tjaz0WBSUY9lludhJuA3TXKiUbhYqImvHx
	 ejahQFP0C/aGtXT+X7HHix1r9+Zj/62x4jxllEjRwW98krgE5Ijz1MWWTT9CGfQJZR
	 qrDgQNghczm8A==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com
Subject: Re: [RESEND RFC PATCH v2 5/5] mm/damon/vaddr: implement DAMOS_SPLIT handler
Date: Thu,  2 Jul 2026 13:18:14 -0700
Message-ID: <20260702201814.92375-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702094633.75658-6-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: isqjjs8fcmatwcnf645zmzkwejxzy4tt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B05EA20004
X-HE-Tag: 1783023519-235559
X-HE-Meta: U2FsdGVkX1/IGycqKpcAttW9vls11r2NNAGSl3JEHOoNjrkzuQmr5pqcpHtZULwmSj0Aqio6poQIYH+kRCpaIxR61eW3TzU3nNoViSapCCBEeDE4xZaAhLhZ305se7gQxRwbUMHumyqEvcV4b7Z0m0WEsR2mMAO3/w0FLhu2iiLBJLGNCegRmNSlDB1+R5EBYZdKCO9o/yXCAA4DDYIezk1Rxw3kjjMk7YNoxyjDh6E2pOg+NQgfPBOtqMjKEXT825yhKyR9vZYZuLMBfekgtQLJOAA6R876Ts7Hs5WYC9Dm4PLqftlYiXUP0t+IWTIwZvV5FC4nZpYZ5yfwlBuHvTVecbcnOKqL72qTHvhPEpjgwdw7RR8NSeElObN7t86HvjFpClfLtytVNZRjXZCFBPOEQ4IdXxF1USv80EAGJu2F3bdbuNt+Xzn4Dx8nuBY78V+OsyRrZMDF3arA7tUwXTTwmQF9d1A0cR+lDDOa0Fcu9sUs1Js7Z6lOgUCv7rvlYiVMYEcwsH5qTx0Fbl8rrcozkj9Pt7pq3gmWGkxRBIWSHL5Y2jhFWmQAy9YiynbKou3rDO4XJX9DsFHcYMSTPyl94WiPmbAKTjloSRTMOkhyABoB/MtBxqp7XglVLR2uIHYbeXulJLVUX3HH6Zj5nbor20caRUbeHKUaQ8d+JHsLCoyDH4Pm81DYMkGZWGcwJvH33tNjEDxFRSVVNqGJCw473usgBGqchxxkN20Ptqw8RTM9WJ1Ha8WAcH+NY/oOY7gS8oH3InLuFvOJf3x/Kt6VGyFLjVR5kdCtKIlVzCjsGEmrT2OKucKeOBVK/k5s6+n2/bs1Wj7aPKFd5oBfVh3v8RGRBG+vyPHP6wt60MkFKXLiovzYlRGxq2XrzioJmUVp7kaSRgLv+NVgRYIHfSqXXsYeeSp6HsdNNUdy8U1QcZP0gOpAeQWFmqCXs9j5vlNqcUu4nb4qFhg0JSy
 0l06GRsu
 AfQckCbFprg4sRWVTciL5ksFcVJa0M3YxoPYYW9VvQygmNOGsiXs9m9DXp2RvNNwcLA7Ssb5fM2XHnAC0J7RSwLyCt7lPQoWIOVevB1EAuJtZV94Vq7N8261hPIVE8bHyKl/2MaCNqUS4xHQkkuwsRzW83TGvapsjoqg54znxfO/PYHc4HL+SvTAJYu6YZnHOaIuPjUedsvPNqoNn+0QwND+D9r4WiMLabKTZUVd+hEvt3vjevpURgtDqXBS83zDtQ4k9AaGZ+0YYDNq1hzM7JswCZVE2MHYBmCqVYIMzz6tiXKj/8aWhCcbrtXkrSK2kykU+CBVMM1h3G9SJgOhISCEWYXbA5YgCFj//Dxc76YnCOPBTH+URXsNWJtltFQWPS9lF3CDk+LZcNgn5uSMYnBJokPMW/9m0qYZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 17:46:33 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Implement the vaddr operations layer handler for DAMOS_SPLIT.
> For each folio in the target region that is larger than the
> scheme's target_order, split it via split_folio_to_order().
> 
> This supports both anonymous and file-backed (e.g. tmpfs/shmem)
> folios, covering KVM guest memory backed by THP tmpfs.
> 
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.wang@processmission.com>

Let's use single S-o-b: if it works.

> ---
>  mm/damon/vaddr.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 98a87609376b..a177703f7e0a 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -944,6 +944,83 @@ static unsigned long damos_va_collapse(struct damon_target *target,
>  	return applied;
>  }
>  
> +static unsigned long damos_va_split(struct damon_target *target,
> +		struct damon_region *r, struct damos *s,
> +		unsigned long *sz_filter_passed)
> +{
> +	unsigned long addr, end, chunk_sz;
> +	unsigned int target_order = s->target_order;
> +	unsigned long applied = 0;
> +	struct mm_struct *mm;
> +	struct vm_area_struct *vma;
> +	struct folio *folio;
> +	struct folio_walk fw;
> +
> +	mm = damon_get_mm(target);
> +	if (!mm)
> +		return 0;
> +
> +	chunk_sz = PAGE_SIZE << HPAGE_PMD_ORDER;
> +	addr = ALIGN_DOWN(r->ar.start, chunk_sz);
> +	end = ALIGN(r->ar.end, chunk_sz);

Like I commented to collapse part, would it make more sense to ALIGN() addr and
ALIGN_DOWN() end?

> +	if (end < addr)
> +		goto out_mmput;
> +
> +	while (addr < end) {

Above 'if (end < addr)' seems unnecessary, as while() here is covering it?

> +		unsigned long folio_sz;
> +
> +		if (addr + chunk_sz < addr)
> +			break;

What's the purpose here?  Preventing overflow?  How the overflow can happen,
and what is the consequence?

> +
> +		mmap_read_lock(mm);
> +		vma = find_vma(mm, addr);
> +
> +		if (!vma || addr < vma->vm_start ||
> +		    vma->vm_flags & (VM_HUGETLB | VM_MIXEDMAP))
> +			goto unlock;
> +
> +		folio = folio_walk_start(&fw, vma, addr, 0);

Why we need this?  Can't we use the simpler pattern like that on
damos_va_stat_pmd_entry()?

> +		if (!folio)
> +			goto unlock;
> +
> +		folio_sz = PAGE_SIZE << folio_order(folio);

You can use folio_size().

> +
> +		if (folio_order(folio) > target_order) {
> +			if (!folio_trylock(folio)) {
> +				folio_walk_end(&fw, vma);
> +				goto unlock;
> +			}
> +			folio_get(folio);
> +			folio_walk_end(&fw, vma);
> +
> +			if (!split_folio_to_order(folio, target_order))
> +				applied += folio_sz;
> +
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			*sz_filter_passed += folio_sz;

Shoudn't this code calls damos_va_filter_out() before split_folio_to_order()?

> +			addr += folio_sz;
> +		} else {
> +			folio_walk_end(&fw, vma);
> +			*sz_filter_passed += chunk_sz;
> +			addr += chunk_sz;
> +		}
> +		mmap_read_unlock(mm);
> +		cond_resched();
> +		continue;
> +
> +unlock:
> +		*sz_filter_passed += chunk_sz;
> +		addr += chunk_sz;
> +		mmap_read_unlock(mm);
> +		cond_resched();
> +	}
> +
> +out_mmput:
> +	mmput(mm);
> +	return applied;
> +}
> +
>  static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  		struct damon_target *t, struct damon_region *r,
>  		struct damos *scheme, unsigned long *sz_filter_passed)
> @@ -977,6 +1054,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
>  	case DAMOS_STAT:
>  		return damos_va_stat(t, r, scheme, sz_filter_passed);
> +	case DAMOS_SPLIT:
> +		return damos_va_split(t, r, scheme,
> +					  sz_filter_passed);

Let's keep the order same to that of damos_action.

>  	default:
>  		/*
>  		 * DAMOS actions that are not yet supported by 'vaddr'.


Thanks,
SJ

