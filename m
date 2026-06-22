Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96CEBCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833326B008A; Mon, 22 Jun 2026 04:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4696B008C; Mon, 22 Jun 2026 04:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ADFA6B0092; Mon, 22 Jun 2026 04:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 410FC6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:58:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC9D3166CCD
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:58:28 +0000 (UTC)
X-FDA: 84906947496.08.78F18A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E84C380009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:58:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qg7LegUu;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782118707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1axEUDSKUCZxXWYIuAFylYrZQLRQGoLVwSR5dVqSN1g=;
	b=S4i4QW5xmQ+7nKpU54lEROXAHnzMPYXBVhTsA0mBGRfp+95tHvkssrPscbqym/Zpjj1ub8
	IF9flqTsV4UWjGfNKKtsHSAwa3dPfiVAFhSO47hBPoNpircqykOXizK/rcpM/2Cs4ClfzV
	tDOpCVdRw9TJ3l47VYYhM/25iSUBCUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782118707;
	b=fsXBNGlsjZgfE8wtWmsQrw0axcsOtddM25wlPx98qyd1Q3QRTdMCtfb4emrbKTfeGT7HMK
	kEwD5Vfn8ggDCquq4sQhYLiVMHDQClmpQCrKUZH88MOEKI3qFnd39bzQxFQgIhZwWHaHjq
	JAjo9xtsJU0eims7mGoUFGLyeNAsswE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qg7LegUu;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F335A41A51;
	Mon, 22 Jun 2026 08:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7651F00A3D;
	Mon, 22 Jun 2026 08:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782118705;
	bh=1axEUDSKUCZxXWYIuAFylYrZQLRQGoLVwSR5dVqSN1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qg7LegUu+eE/t5ZVmf123u++iukFhC3v6Y0SR+Zf/z+Gf8dQvLeMP5Yl15J54JXtF
	 7CuCD7p5Ohy5AQkm9SZZ8ckeqHHMoV6i+3QD4yNCt+aUJMIdQNOfhNVvXITkMLOibq
	 gBkVFCqpLX9EY/Y1dEITKk299MSqD9fs7K8bC/NesR/jHSan4dlhCKvvjnEoffOLnY
	 SknsBq0f10PADghliYZdWWlMT0M3hANV3uILg3NpJ3g3uXimncVYJ1L+FR9DA5XAo7
	 1jqFRXVGUp04GilEjCFB4/2tJz1lpmlJ8+m/BS8yUmw+SCuMaKmC4yv7kMrQnkQlMp
	 GhGViHi6ddDmQ==
Message-ID: <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
Date: Mon, 22 Jun 2026 10:58:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, kasong@tencent.com,
 lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, npache@redhat.com, qi.zheng@linux.dev,
 ryan.roberts@arm.com, shakeel.butt@linux.dev, weixugc@google.com,
 yuanchu@google.com, zhaonanzhe@xiaomi.com, ziy@nvidia.com
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260620081017.89085-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: st641yoz4mjydbkg97xd8wymhtby5ur7
X-Rspamd-Queue-Id: E84C380009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782118706-836901
X-HE-Meta: U2FsdGVkX1+YyV384Be3ShQzkfaNoJXCKvk493Y/SJpupud8lQrzJgVjJ9KF87eH4nN3j90gDwkfOnNFDh/Ya1XOPprTOwam3gvfOJiADpsjwCEc8ifr6/tJAM0Htb3PmWeN7ysaR6zsIrrM/n6UTVMa/umv9LwAS/RD0WWVUtuOaBZeovuN4WEbBjjQF1O4m2WrHe7rUS16Zik+yO49vmbmFtFFNRDxAZ0TlTffMMeS/dJkLjasp0ldkw4yGnXJiK+8PolOfc8vXTxH5stBanYVw47ouLppYesr8Itz6kGHFFLU3wJeyR5HSPCykTsvGIipPUt+cEqwxKvw1IUybDYZLxAI/saMQ1wU4SGKYcKdMaKE97mHmQw4OYVYoNSQVcTf9x7KeH++mTmHRAJ1xqzIP6Wv/OZBW8lKzL+Qse8IZokAyrVTwXK0cP5pNRWuwJ3KZ4jHO4qAuAy3U1Dt9/eu3sehFeiL/4s1dunxnVpqXeRh7Wubp3Z/Clb2Yxz2mB8y/O8gm/vezPsfHnjjdrffW/u/Tx4tuMFs7JMvgQ4czGn49/N+aiFIr9mA4s3z+D4wrPYysUF44ll+gXDPbD5z7+c3S4EbqwsvuYfSM3t9wGpb/UoNY3XiP8GRDa+JKD+rf5FiryiGFvTBb7JnVKio1YAbz7LV2DwvXB481V3E+6WHSIRNWIOygIFCGFNLuN8zeR2+IH7LsTTtivJb9msrbNp5rhIt7NromLF3XsY2hbqcywaNXYP4JjOhEJ5fvel9H392kCuVE86MvNIgdPTYMDBNHiq2Js89WDy4UvOq38y+75ECQn+JstBBZ8qguIkwgYMiz7epg3ObyLGAO0+4r8wTlRDI8chLLE9TuFx2F8sc5tpd0V7CXAVJfdlMiUB5kYMJ5+G4Q/VtjNJH/R/SOaZhjmjpG+k8oNk5FHGvWqeuPzds6eqiC3YOjMWrxz+MD0SeV3qjEHaC37N
 /Lulc9D6
 IIuBgH6n3BNks38xyU2e0dKSmlagUE1eSCM4vht5VTcafOZcuSXY1JAqlmTfg6Hc13fLm2VWXxCiPYw7Gng5Yv2Q+rL4TGk7IVAkkZA6UrbZxlYD2gzQODel2hXg/2N37kGeWljl2wnR8BZ3CBoGWzcBSCggfjuv3pIbUaHQko1PNet8+vxF4GLxs2aGb7izd6uD/zFRUOagjF7bNdVLH4nF/bNWQmornZb9GEwHdX1ueZlPVL29IioAAchWF3B+lGK0Cd6gq+L0RFoj3nPMIzt5slHM5u5qpUZPnNaRddqtZ/U0f9VIqu9Sdag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/20/26 10:10, Barry Song (Xiaomi) wrote:
> On Fri, Jun 19, 2026 at 10:04 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
> [...]
>>>       /*
>>>        * The page can not be swapped.
>>>        *
>>> @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>>
>>>                               if (!folio_test_large(folio))
>>>                                       goto activate_locked_split;
>>> +                             if (!__can_reclaim_anon_pages(memcg, sc))
>>> +                                     goto activate_locked_split;
>>
>> Why are we even trying to allocate swap space if we cannot reclaim such pages?
>> Makes we wonder whether we would want to have that check earlier, before the
>> folio_alloc_swap().
>>
>> Any downsides?
> 
> I don't think there are any obvious downsides there. One issue is that
> the memcg may not be passed from reclaim_pages(), so memcg would
> always be NULL. However, the folio could still belong to a memcg
> whose swap quota has been exhausted. In that case, my
> __can_reclaim_anon_pages() will fail when checking whether we can
> swap out. But switching to folio_memcg() also seems awkward.
> 
> So I feel Kairui’s suggestion [1] might be the best approach. In
> folio_alloc_swap(), we return -EAGAIN to tell vmscan.c that
> we can split the folio and retry the swap-out.
> only when there are sufficient swap slots and sufficient memcg swap
> quota do we return -EAGAIN, allowing vmscan to perform a split.
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 78b49b0658ad..62e2c506ccae 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1755,6 +1755,9 @@ int folio_alloc_swap(struct folio *folio)
>  			VM_WARN_ON_ONCE(1);
>  			return -EINVAL;
>  		}
> +
> +		if (get_nr_swap_pages() < (1 << order))
> +			return -ENOMEM;

I guess we could be clearer with the return value:

-> !get_nr_swap_pages() -> -ENOSPC / -ENOMEM

(no space at all)

-> get_nr_swap_pages() < (1 << order) -> -E2BIG

(there is some space, but not for the full thing)

But now I wonder whether we would also want to check "is there any free swap
space", not just "is there any swap".


Essentially, try returning -E2BIG if there is the chance to swap out after
split, and  -ENOSPC / -ENOMEM if a split wouldn't help.

>  	}
>  
>  again:
> @@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
>  	}
>  
>  	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> -	if (unlikely(mem_cgroup_try_charge_swap(folio)))
> +	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
>  		swap_cache_del_folio(folio);
> +		return -ENOMEM;

Here we wouldn't have the information whether we could charge after a split.

So that would require a rework to signal this more cleanly to the caller.

> +	}
>  
>  	if (unlikely(!folio_test_swapcache(folio)))
> -		return -ENOMEM;
> +		return -EAGAIN;
>  
>  	return 0;
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 299b5d9e8836..63e8578454ea 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1257,6 +1257,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  		 */
>  		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>  				!folio_test_swapcache(folio)) {
> +			int ret;
> +
>  			if (!(sc->gfp_mask & __GFP_IO))
>  				goto keep_locked;
>  			if (folio_maybe_dma_pinned(folio))
> @@ -1275,10 +1277,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  				    split_folio_to_list(folio, folio_list))
>  					goto activate_locked;
>  			}
> -			if (folio_alloc_swap(folio)) {
> +			if ((ret = folio_alloc_swap(folio))) {

I prefer doing the assignment outside the conditional.

>  				int __maybe_unused order = folio_order(folio);
>  
> -				if (!folio_test_large(folio))
> +				if (!folio_test_large(folio) || ret != -EAGAIN)
>  					goto activate_locked_split;
>  				/* Fallback to swap normal pages */
>  				if (split_folio_to_list(folio, folio_list))
> 
> What’s your view on this, David?

I guess returning from folio_alloc_swap() whether a split could allow for
swapout (e.g., -E2BIG) would be reasonable.

To catch all the cases where it makes a difference:
* No free swap space (split won't work)
* Some free swap space (split would work)
* Sufficient free swap space, but fragmented (split would work)
* No memcg space (split won't work)
* Some memcg space (split would work)

-- 
Cheers,

David

