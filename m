Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E80CCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86F38E000B; Tue,  2 Sep 2025 06:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FD18E0001; Tue,  2 Sep 2025 06:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0E18E000B; Tue,  2 Sep 2025 06:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 906DF8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:07:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1925A5CE4C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:07:01 +0000 (UTC)
X-FDA: 83843881842.14.A7F285E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id DB94A1C000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:06:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LY83kQQv;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756807619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQBjL6Mz1yywDE3JBeNxw+HRiz9wSeKoX5ELaLVEmP0=;
	b=u/jkI3ZfhdfNtFFoXEASWMkA/H/v1zznT0qttHnE4vJbRhaFaQhuVK4jXn0pCV2x5IdBmW
	3L01P2LxvS3wiuQxh/OQ5TssSLHDxSH9T8uJ/zG3Eti9yPv5jXeSZ82+8GLVfWYtdmXgnj
	Yq/6oPUrHxTEtbXUc9dadmlTuJRkaxo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LY83kQQv;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756807619; a=rsa-sha256;
	cv=none;
	b=IfK8fF8+VMArhrKBKxkL8SqYWye5YP2Bj85oiAeqEn8lVYeakaO8po+6iIrLHqUxj2a1H2
	o7pKzOapY3KG3DpSePA9aDhA3yqLsOIuY49x8SL5X47EC0OcS+FvpeV48IkslcRW8bF7xr
	sKeGqbG7+7tBJEUVGQ+8lMPnhiabPuw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756807618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yQBjL6Mz1yywDE3JBeNxw+HRiz9wSeKoX5ELaLVEmP0=;
	b=LY83kQQvetausL4t2XKXQqjAgpUCWpVxI0PLM1Ehn2Hy2a5OII4lxhee042RGWcsPRdZHZ
	gdd1jueyIJpAe+MkL2RtLcN8Xs3rqrdv5rs8ytYbZ1YihJgdLWyQkUnWIe/D+Z63s7uYfm
	pmODCzQx15yLehy6a0KekFlS7FwAFrs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-voZYaiJZOqiSaNl3Re8cbQ-1; Tue, 02 Sep 2025 06:06:57 -0400
X-MC-Unique: voZYaiJZOqiSaNl3Re8cbQ-1
X-Mimecast-MFC-AGG-ID: voZYaiJZOqiSaNl3Re8cbQ_1756807616
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3d17731acb6so2762282f8f.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 03:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756807616; x=1757412416;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yQBjL6Mz1yywDE3JBeNxw+HRiz9wSeKoX5ELaLVEmP0=;
        b=dzrRprwN7fj13NmbWO9GWCxbkfmi/+Em6/rsaMULCOZ3uN9XqdSWDXDRG1e5JCBc4u
         nKzrC9VXhyz4HG7zbn+vdcdj63pUAO8I+kUz3nfFFGrJLVtjUj1oToewrle6aJ+/IvOe
         eza8vPZoVxBvwQ56vRs7TNJqXhG526cNVgoMsgKCB7J6uj1FPkeM9bu1GJEft26IUvik
         McA944l84HKpWyRYZ7C6vvHmYuvh8YyyDvb15b6oyNY5QgCz/3pxoJvHKtW4flAloJTz
         hQrFwNTU2QhCz/QH69XLQYWrTFtRrVjVUrT4SpDNabyknYfTupWH+7+pt2YcaR27gMQ5
         lGNg==
X-Forwarded-Encrypted: i=1; AJvYcCVqSFnQ1V/kIGptdiw3UAFS1xkN2iN9Ytxha/ZfbIyf6ytlwxnW17qjbv75oW4DpF3ZLFlsgY/g6Q==@kvack.org
X-Gm-Message-State: AOJu0YxF6dvCHLWtMT9r87agByoPIwZaUvotGE7vGFdsahQ7VHS4r43P
	bZHtyBZ4l0FzTgLU5hKFvmFEcURmZ4P8BKDHUODPNxZMKXiTDuuHB2J5Jw7RdtyroT5KY9OBW6I
	tgY0iQN3CadXMtrAL9FjDOFaS3nO1RyAapp2v5eWLq/uDPKapOug1
X-Gm-Gg: ASbGncutypGAZJ/K1owIz1Tl7eLkRMzXcZeddi6rgt62D/xLTTmqdIsoiZ10H/l5mz7
	ysnnnQe/X1JFPLquCdlV9a5klrQvhQ2t8Qj1HA+OYRg4d25ue9KwEw6YiJsKk6YHtmgnPFRfOUO
	SscirrE/NrnKInWwTRIRQHAc9/n2BokamfOGTm+CVr+bLIfpZJtHAXU8I1SnRP17t7PETc2CWZj
	nGLoGrTogMgUyEd+p0vehGG99+GCrarn9rqRwyVfz3M+WOjlBxdygGdSuzUdcV0BFXeW/xaszpp
	LcOb9FAr19zDmuoTyFdlQ+fs8Q8qXQBEJHY0v8Ty7Kfahhc5qicosK18YGarZRDol0qtcgBmrsG
	QsnYqDUSBj9foykSY4hL/DvcSz/acQX/yOvaCRs5C930u/c8vL3qnvyYHQfv8uzJz5oI=
X-Received: by 2002:a05:6000:2307:b0:3ce:f9b7:4db with SMTP id ffacd0b85a97d-3d1de6a8dc5mr9225610f8f.24.1756807615825;
        Tue, 02 Sep 2025 03:06:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFN/f0bU7xidso2QGDLy/JmGY1w4j+2LPFKqk9bXnHh6iqP3ESV1ILbYveFavO2boVsWDG8fQ==
X-Received: by 2002:a05:6000:2307:b0:3ce:f9b7:4db with SMTP id ffacd0b85a97d-3d1de6a8dc5mr9225572f8f.24.1756807615283;
        Tue, 02 Sep 2025 03:06:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b945332adsm36060615e9.4.2025.09.02.03.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 03:06:54 -0700 (PDT)
Message-ID: <c4a729b8-be9e-4005-aab6-91723fcf0080@redhat.com>
Date: Tue, 2 Sep 2025 12:06:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
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
 <20250822192023.13477-2-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822192023.13477-2-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XiDiTA43apKnk4nosShqY4Z1KGnPTNWL8Px99EoZNG8_1756807616
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB94A1C000B
X-Stat-Signature: stfc383rzn9pijdz67f5kpygk41bssqb
X-Rspam-User: 
X-HE-Tag: 1756807618-805372
X-HE-Meta: U2FsdGVkX1+AEOBzysDvGPYK5i17RCBs4GXnpFeU+b8abW+xztsbormYplnf/xf0Umhi6inIZr2Jp/tagz9VdG7B9HDKBxn9cvNmSinFviNiGCYYFYlguI3Z+ShuL5KLJW6UXZW+YcLwRPvtYJ7XI/Mn+UqPTvSmh4SFiIJoXffunBqwrp+HF6GVvZM+ABN9PP+RzhMW40tOTevgUpJnyffE0GNrYyxN9+ph7UtfhDZ3j6IQyZNm1GF5ZzkOlVZA9JUatLOi9n3PN6HWVX/THu4gWXPsoKVl6+bfkMXLejvbF2HXxq96kBMq6Ypns3DlmsYnQhMlvMwgkOPKmIHHduggE0Y/AaAhX+4A0UvHhw8DvSjseja6au1q3QQgJ7dgGfnHvnxSe7u9+gcLotBuJzfykr5LSUl/8Jm+osIvq+7lP7BWDPatgmVTgNn0BRtN9mlP7g39g7GetNevc9135LFR6cdItpjBXdUANuBYwuSHFzznskkpYvw/Pg4CoQN8EPF0YbWI+Fh1Q0n3qL4DZHRtG/Kd9dS4Xl5XL2hrAVzeGi4Aek85oVxzpjABuKNlRwAHpsVKS5Av58yeluaCFhWYQ6ZHjbDxUQhgqUGKtJK1lIpXlC+44HB+Lj/NZkvKxs2pHhFIyONbHrcph5ecs7bAxkmdfOBBQ5Pr3+92mRlGiu6DjSguERMGuv4Px49tFqnteeCbtsTV7Wg7cDZQcP66qGy8WOL0R1AJ4I1JdmGgSF/cw1UXSsqpCAuxCyTMhLJ8uJqKZmPQrmcQ+Ivk1aobm9TXu2qLPXgsNmunG5PeZ+/7I8skuUVSSdQmUohpSqY1Q3sQVPqi1+iU6Ut+bqpSzBWVvfz4t5MOKlUO21K/zParZ7PlYTGLzP3uVYsYMVrLf+QPmsj1/ToEqfRnqazS1DAeWfQCmGG7NiTMlggWhXIgu+TrpvHpu6UEwOLNc9+nNib9HI8KJQnUiYA
 qDv+lyIa
 Ij2W2VO9gxVE2j7sndyv17+NfZUl0bhqm1uV7V0QuY0rzqMQ=
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
> Always use swap_cache_get_folio for swap cache folio look up. The reason
> we are not using it in all places is that it also updates the readahead
> info, and some callsites want to avoid that.
> 
> So decouple readahead update with swap cache lookup into a standalone
> helper, let the caller call the readahead update helper if that's
> needed. And convert all swap cache lookups to use swap_cache_get_folio.
> 
> After this commit, there are only three special cases for accessing swap
> cache space now: huge memory splitting, migration and shmem replacing,
> because they need to lock the Xarray. Following commits will wrap their
> accesses to the swap cache too with special helpers.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/memory.c      |  6 ++-
>   mm/mincore.c     |  3 +-
>   mm/shmem.c       |  4 +-
>   mm/swap.h        | 13 +++++--
>   mm/swap_state.c  | 99 +++++++++++++++++++++++-------------------------
>   mm/swapfile.c    | 11 +++---
>   mm/userfaultfd.c |  5 +--
>   7 files changed, 72 insertions(+), 69 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index d9de6c056179..10ef528a5f44 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4660,9 +4660,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>   	if (unlikely(!si))
>   		goto out;
>   
> -	folio = swap_cache_get_folio(entry, vma, vmf->address);
> -	if (folio)
> +	folio = swap_cache_get_folio(entry);
> +	if (folio) {
> +		swap_update_readahead(folio, vma, vmf->address);
>   		page = folio_file_page(folio, swp_offset(entry));
> +	}
>   	swapcache = folio;
>   
>   	if (!folio) {
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 2f3e1816a30d..8ec4719370e1 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -76,8 +76,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
>   		if (!si)
>   			return 0;
>   	}
> -	folio = filemap_get_entry(swap_address_space(entry),
> -				  swap_cache_index(entry));
> +	folio = swap_cache_get_folio(entry);
>   	if (shmem)
>   		put_swap_device(si);
>   	/* The swap cache space contains either folio, shadow or NULL */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 13cc51df3893..e9d0d2784cd5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2354,7 +2354,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   	}
>   
>   	/* Look it up and read it in.. */
> -	folio = swap_cache_get_folio(swap, NULL, 0);
> +	folio = swap_cache_get_folio(swap);
>   	if (!folio) {
>   		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
>   			/* Direct swapin skipping swap cache & readahead */
> @@ -2379,6 +2379,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   			count_vm_event(PGMAJFAULT);
>   			count_memcg_event_mm(fault_mm, PGMAJFAULT);
>   		}
> +	} else {
> +		swap_update_readahead(folio, NULL, 0);
>   	}
>   
>   	if (order > folio_order(folio)) {
> diff --git a/mm/swap.h b/mm/swap.h
> index 1ae44d4193b1..efb6d7ff9f30 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -62,8 +62,7 @@ void delete_from_swap_cache(struct folio *folio);
>   void clear_shadow_from_swap_cache(int type, unsigned long begin,
>   				  unsigned long end);
>   void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
> -struct folio *swap_cache_get_folio(swp_entry_t entry,
> -		struct vm_area_struct *vma, unsigned long addr);
> +struct folio *swap_cache_get_folio(swp_entry_t entry);
>   struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>   		struct vm_area_struct *vma, unsigned long addr,
>   		struct swap_iocb **plug);
> @@ -74,6 +73,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
>   		struct mempolicy *mpol, pgoff_t ilx);
>   struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
>   		struct vm_fault *vmf);
> +void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
> +			   unsigned long addr);
>   
>   static inline unsigned int folio_swap_flags(struct folio *folio)
>   {
> @@ -159,6 +160,11 @@ static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
>   	return NULL;
>   }
>   
> +static inline void swap_update_readahead(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long addr)
> +{
> +}
> +
>   static inline int swap_writeout(struct folio *folio,
>   		struct swap_iocb **swap_plug)
>   {
> @@ -169,8 +175,7 @@ static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entr
>   {
>   }
>   
> -static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
> -		struct vm_area_struct *vma, unsigned long addr)
> +static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
>   {
>   	return NULL;
>   }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 99513b74b5d8..ff9eb761a103 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
>   	printk("Total swap = %lukB\n", K(total_swap_pages));
>   }
>   
> +/*

While at it, proper kerneldoc?

/**

etc.

Also documenting that it will only return a valid folio pointer or NULL

> + * Lookup a swap entry in the swap cache. A found folio will be returned
> + * unlocked and with its refcount incremented.
> + *
> + * Caller must lock the swap device or hold a reference to keep it valid.
> + */
> +struct folio *swap_cache_get_folio(swp_entry_t entry)
> +{
> +	struct folio *folio = filemap_get_folio(swap_address_space(entry),
> +						swap_cache_index(entry));
> +	if (!IS_ERR(folio))
> +		return folio;
> +	return NULL;

Maybe better as (avoid one !)

if (IS_ERR(folio))
	return NULL;
return folio;

or simply

return IS_ERR(folio) ? NULL : folio.

> +}
> +
>   void *get_shadow_from_swap_cache(swp_entry_t entry)
>   {
>   	struct address_space *address_space = swap_address_space(entry);
> @@ -273,54 +288,40 @@ static inline bool swap_use_vma_readahead(void)
>   }
>   
>   /*
> - * Lookup a swap entry in the swap cache. A found folio will be returned
> - * unlocked and with its refcount incremented - we rely on the kernel
> - * lock getting page table operations atomic even if we drop the folio
> - * lock before returning.
> - *
> - * Caller must lock the swap device or hold a reference to keep it valid.
> + * Update the readahead statistics of a vma or globally.
>    */
> -struct folio *swap_cache_get_folio(swp_entry_t entry,
> -		struct vm_area_struct *vma, unsigned long addr)

This also sounds like a good kerneldoc candidate :)

In particular, documenting that it is valid to pass in vma == NULL (in 
which case the addr is ignored).

> +void swap_update_readahead(struct folio *folio,
> +			   struct vm_area_struct *vma,
> +			   unsigned long addr)
>   {


Apart from that LGTM.

-- 
Cheers

David / dhildenb


