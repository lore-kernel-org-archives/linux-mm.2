Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE00CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A438E0003; Wed,  3 Sep 2025 07:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06168E0001; Wed,  3 Sep 2025 07:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA73B8E0003; Wed,  3 Sep 2025 07:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF8BD8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:42:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5737211A2B2
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:42:00 +0000 (UTC)
X-FDA: 83847750000.10.0AFA8C3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id E775B180018
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:41:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z4rp4fGi;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756899718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KMh+msjlWjAAiN7LUASBzCncpFiuu1P0ADJ3l6og1A=;
	b=Eo8a5W0YceGyPAIFJKnhw3RqutXngVLJtxUSWUtZiKrTLs+NwwYNvzgJRolLBvWe4blkwk
	gqDfOnwuRPAWBfrJPTbUYEBEOX836f8lvENOWhwxzfREd8LlQTP4F5Y8RPeTD5fFoaNWK/
	wtWPCNRaDIwYLlbGLtW6ZW9cxjwvgaQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z4rp4fGi;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756899718; a=rsa-sha256;
	cv=none;
	b=bsi24pJ0QTtODlw34TYGeWLVwPip9pxUQ/lZc02OBT1PeDO+nE6LM6bwy7+FUhSSkK3p8Z
	qU9duvS3WOoww7y+y5Qir77sbSQlQR2hJ1+mW61+5Sc6lZoEi0xsFJ25vCR9cX7+3c6UMi
	ZSrrU4KlAh1FiLdhWybaqi9eXMaJh1g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756899717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4KMh+msjlWjAAiN7LUASBzCncpFiuu1P0ADJ3l6og1A=;
	b=Z4rp4fGiZuA/oTfOfYoOqXgVeRrnwYYLnaSsUOVxQ+TVPN86bJV6nlqNwqeW7skWClZO/+
	vYtmdOOTarYQVibVqH17KOm3ZklOvlwj4h/KTuw5ZBJJ2aTnroSXOPDjQ8E9/GP19KkXsK
	DMoObhO6cSFKHDGofVXvrEpeHCtTNKE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219--L7irxo0O0u-FtWCHFHLLA-1; Wed, 03 Sep 2025 07:41:56 -0400
X-MC-Unique: -L7irxo0O0u-FtWCHFHLLA-1
X-Mimecast-MFC-AGG-ID: -L7irxo0O0u-FtWCHFHLLA_1756899715
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb612d362so3301655e9.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 04:41:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756899715; x=1757504515;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KMh+msjlWjAAiN7LUASBzCncpFiuu1P0ADJ3l6og1A=;
        b=kCSNXuPKUbFWYCquRPirL1H+z1MpDcINg3kcp7fIx/XmlaQ+1716th0IyF/Te9GfOl
         P7sRPFhWp5/fsWcPVAnSkLrBDzDr1lTZ1Quan195jBSFIC8KSRNyOuxhVxeojnh2vaeE
         a9e0SzXloqCSPVMnEe2xXhXo5023cQpb4uCDxhPnfCvYproK6fwWLF4JwEMOuaBPz03r
         DbRWL1ZXv1uloflee6VTwuwds1/z6vB6pZO3IiYIIKhy0Hk8/GkUaE6QguwxCEVr9gu8
         JA4XpGFu6nKR6sRJ8CXNJOa9pYk0XGrDH+gvWYQGXKV8MOWB9oiWpOOzR5Kb4OtFS1LT
         0E1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkzgG3G5fYHWXijQlNceNm6Ui1HltIsRZB44/L7PoTE9RzboaBjiv3PxuoKH099+ZBhXVBZ/+5Vg==@kvack.org
X-Gm-Message-State: AOJu0YzK/le/9EIv8xYk+iWo8EKzNfWmOm0CT4l6wqd03VOGM3KAlB51
	oNSA4bxNfdZ0Bt7oPt1UhXoNAK81oHAbHZGy9+Yg+hSPDA6064LsAByXHPWLv1Q3bHDmwBTI9Pu
	6zDNJ3Xc5pn3VMSSnbEcxaNegkVhhWmO0YNZvJNRoe6PXFsG341Du
X-Gm-Gg: ASbGncth+4KyIzaERSlXA8g6wZrArxWXnkc0h/HUvMfR0edl4wtqrPsvYZSzXgd2JXm
	k40bH8IhDLIxRH01E8Zhc7HOUnk1/zI9Gz3kK+CDf8A0sWyGVhP3QA6fNO3qBWOQIFqZUZPS6X/
	QJjDaqi+cmAPRBMI+EW1+qhXk4eFt4AomrEWB+d9M6/MeLBFmwoTY7IJ98j9qNdWuVhjS5RTkyN
	LNYAwrtqzcxPPNbmwHTNjbcITYTzJuIV0Ii1jJxncfC5VYTCGajP276JbucTp888Jje03LNQSNO
	KfDA0lX5Fbwx0BAjKiz656a60vZTqNZeXf4i1/EMis9kTzOhNUxcn+RLyov8e/PwLBLQ/AE97aM
	NZl9K/1UTwAo9YlkxWEq4Uu1ksrb18CXlLi+FZQT1qTZvy8Vn9+Cs1gMI9sfaGRB6rT0=
X-Received: by 2002:a05:600c:45c5:b0:45b:6743:2242 with SMTP id 5b1f17b1804b1-45b85589b3dmr118701015e9.22.1756899714895;
        Wed, 03 Sep 2025 04:41:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqUsv0e978RuPQhn9L5U2SWoNAaH42axVs7ma0k0ctki4Md+nreA0VWitzkHEepAHW3hF2Dg==
X-Received: by 2002:a05:600c:45c5:b0:45b:6743:2242 with SMTP id 5b1f17b1804b1-45b85589b3dmr118700785e9.22.1756899714411;
        Wed, 03 Sep 2025 04:41:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9bcda91dsm60339495e9.6.2025.09.03.04.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 04:41:53 -0700 (PDT)
Message-ID: <c492b99e-b6fb-4da8-8055-1e93c6141a12@redhat.com>
Date: Wed, 3 Sep 2025 13:41:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-7-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822192023.13477-7-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DsuswIC3E8erMAM0uQeRnmeLIPjduMXChfDi-wH9OAo_1756899715
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hbe66zm59tns98ychnp5dqt5g5mhs637
X-Rspam-User: 
X-Rspamd-Queue-Id: E775B180018
X-Rspamd-Server: rspam01
X-HE-Tag: 1756899717-492275
X-HE-Meta: U2FsdGVkX18InWXnNC17NhdT1j3jD2JtCtBKuTrgyWKVre79oX1QcXe4nJ/yqlWiPjjTNpFXAul4YqWUdN2+kSseDVUuX6ETKRErm1PUvRWjOixcv2p52yiwX0IBicmW2TX9zOUaurYLwxBCbLt40ti3ERifPQM6F51LnUgv9ksUZEwL1PncbklDyvJ0g5nEHo8ashDRAR8+/ayDpo6EE6x5/2uEMxZNhDHDUQPPq2gQzhMK0NCL5sLt2dqT/Ef9zd/M2+Rb1u3IH5hRsYpbZba9syOO6EJP9AGQ9oGqshQp8pVfVdTnTTG/j2TTLmwxI5y+TLNkTPHfSUtH6Rh3TZIR2YyFzMt6tr5yGHLND6aWJ1wqVi5oTApkbizyClelEWK/Ku6BpjHTSxm/wVHfKUvBnYKfU59hsECcfZa+EX69m+8wKtlTTUT23o2O3H2YfejoTP1rXsiNtP5Skq7P5vZZqwuVJXhYNw3NJUe8Ll4Fs12W/4sOkciIbgqtzXbMmxVWqwzgefgqEs27znn53b1Uhcy2rS2jG/NbjXMSyQZsD4LM4tZ/6d7JCN8B4XgQjydbjJOksr3rQQNCVeKMBc0bKLRR90Pzj8fSfjuCawsguIaP3N5hiLcsAqCK/P/mT6qAN47zPp4vh0FDCLuuJ5EvuKuMcN8LsNAl4yC35l4Nhej/zYUKy911kMW14s94aU9c8/iwBtxK8l8ldk87hysGfrTpsTcZznuc9ulBmsG83UtVsh6HyL0iSZb0H4u1aEryOWXbT4khfWCWUKzfzAI87d3J+5ZM6yr6TlJYgWxg2wq991PAUOoK/ApU1Jv3rOL1SMRGAFrfIDgSr4hg2zrHIz8SuCbjxe9p1+S4jCaQdnUGpwBPejyBl7QEovgStPdavh7vdjUtMCFlb60oNvC76LxBAFZY9mcTLwTr3T59i+iDzDRaLxWEJW5CoWUyCktP0Zqyj1zG2PVFi7r
 JIUfJJND
 3+YwXfhIVqfHGhoFEmdZcXlQIRIVgv9DmTu5De+AxZq/b4Rh11spl6Rujv8MRdXnuo5L05htY4arhqWJewo8uxIbQyMm+A4KyaM/p0YKCCvvMHdqu/uRTkNn79eYsOTIOz9CZ6f1dF8htHinPAqu5MokKnqevyezq524dwDYvkxLUCBqmw+WCU3Ws8idCg+aDzt+N+cVQ2N9Vjt15q6Q+p1j0f4yhTe4ykajgEZ95CbfsXYz0sRDxIish+qtN2nqO/e6PyF8L+PLGaYIwwDc7l/UAJ0iieVYXI1Ph0Seh4MvCi2GvPMm/ov5hC1oJyGWfxXNRVy/teGfIR/6+MLCDX7f+otPH/C0JPTrNCf2ED19vOKCTVpltuBW2FbiUpNU9mSodKhyP5CMvP7NySHWZAgL2qnHqLbQ8zbQd3NE8s2lCEHDdKCl3A3KtdxkuMgmTYuG8zkyN5wU32Ci8FW5HhOP7T5w/KN4p+w6zhom39Kr52vZvx36287Xs0muF1Gq+fVAl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 21:20, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Introduce basic swap table infrastructures, which are now just a
> fixed-sized flat array inside each swap cluster, with access wrappers.
> 
> Each cluster contains a swap table of 512 entries. Each table entry is
> an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE),
> a folio type (pointer), or NULL.
> 
> In this first step, it only supports storing a folio or shadow, and it
> is a drop-in replacement for the current swap cache. Convert all swap
> cache users to use the new sets of APIs. Chris Li has been suggesting
> using a new infrastructure for swap cache for better performance, and
> that idea combined well with the swap table as the new backing
> structure. Now the lock contention range is reduced to 2M clusters,
> which is much smaller than the 64M address_space. And we can also drop
> the multiple address_space design.
> 
> All the internal works are done with swap_cache_get_* helpers. Swap
> cache lookup is still lock-less like before, and the helper's contexts
> are same with original swap cache helpers. They still require a pin
> on the swap device to prevent the backing data from being freed.
> 
> Swap cache updates are now protected by the swap cluster lock
> instead of the Xarray lock. This is mostly handled internally, but new
> __swap_cache_* helpers require the caller to lock the cluster. So, a
> few new cluster access and locking helpers are also introduced.
> 
> A fully cluster-based unified swap table can be implemented on top
> of this to take care of all count tracking and synchronization work,
> with dynamic allocation. It should reduce the memory usage while
> making the performance even better.
> 
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

[...]

> @@ -4504,7 +4504,7 @@ static void filemap_cachestat(struct address_space *mapping,
>   				 * invalidation, so there might not be
>   				 * a shadow in the swapcache (yet).
>   				 */
> -				shadow = get_shadow_from_swap_cache(swp);
> +				shadow = swap_cache_get_shadow(swp);
>   				if (!shadow)
>   					goto resched;
>   			}

This looks like a cleanup that can be performed separately upfront to 
make this patch smaller.

Same applies to delete_from_swap_cache->swap_cache_del_folio

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2a47cd3bb649..209580d395a1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3721,7 +3721,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   	/* Prevent deferred_split_scan() touching ->_refcount */
>   	spin_lock(&ds_queue->split_queue_lock);
>   	if (folio_ref_freeze(folio, 1 + extra_pins)) {
> -		struct address_space *swap_cache = NULL;
> +		struct swap_cluster_info *swp_ci = NULL;

I'm wondering if we could also perform this change upfront, so we can ...


>   		struct lruvec *lruvec;
>   		int expected_refs;
>   
> @@ -3765,8 +3765,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   				goto fail;
>   			}
>   
> -			swap_cache = swap_address_space(folio->swap);
> -			xa_lock(&swap_cache->i_pages);
> +			swp_ci = swap_cluster_lock_by_folio(folio);

... perform these cleanups outside of the main patch. Just a thought.


Because this patch is rather big and touches quite some code (hard to 
review)

-- 
Cheers

David / dhildenb


