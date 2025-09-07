Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF40CAC581
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 12:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595006B0007; Sun,  7 Sep 2025 08:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CDC6B0008; Sun,  7 Sep 2025 08:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B8F6B000C; Sun,  7 Sep 2025 08:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 22E986B0007
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 08:55:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B63BBA75D
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 12:55:48 +0000 (UTC)
X-FDA: 83862451176.23.713AE06
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7FD72140006
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 12:55:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="G/XtgCLo";
	spf=pass (imf09.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757249746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdAbborS8C2Ou/xydNKdRzdXdKALgrhR3nsSWFUy6jE=;
	b=B80xaeAA+wYhEqTgYE61B94BYPWVOpDBbNSB1lb6fdudJuanuS/0oKd63t09h+OEj+FdwR
	RdCPR+zjbzlX9HE+BSCJ3s2kbej+yHEbgl8wPXr457RRAmzXeg/l2VqFWVbBxVT2Bsynph
	jeBOkfIyTD183XNZVacM/GpiO9FqBZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757249746; a=rsa-sha256;
	cv=none;
	b=yZjz0smIxVeUVk9ZQQQ1LMTvtEkdFUXVEmyj1eyPb0ZuajiS8XY2AURccXVsN868a8b5ZU
	TQ18Yr5keK//OTzPLODbxHGQ51xdBl9FAYf1NlDqghgV1mJ3lwG3Av/ZiUawFt3Dfrnj1M
	+Y39egA5MKeAjsUH1xZh3rbp7eqs+/4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="G/XtgCLo";
	spf=pass (imf09.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-336af6356a5so28139991fa.3
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 05:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757249745; x=1757854545; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qdAbborS8C2Ou/xydNKdRzdXdKALgrhR3nsSWFUy6jE=;
        b=G/XtgCLoK83p1JH4zUHgEzaRy3y9fzdUUeIH/V3PwcJWAfQ8sSQHYW/sRlunOIxGT6
         0Pi7tI5d6AkrW70uirIRyxDax8w956APxrLp1WynbsDQD041A1IZGDKi3iHu+nJZealb
         X8b17VnPWA4ralQvbli3GjbmB6pcit8nQ5g8Ycgq/mWCEPd+mLEJ43lEQ/SxgertPoaP
         L4swYm074uu6o8sv0Lmed6gANrj7eNBv9quWNOu+5ccxRBGN2wradUWUaz9tdyEucSf+
         jX2RR6kqBYj9YleB6LBhaY2YAn9mjZlLK1TxmZTPZ5XvZOTsyi7GLe4ef+xPiqdN6xlc
         wA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757249745; x=1757854545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qdAbborS8C2Ou/xydNKdRzdXdKALgrhR3nsSWFUy6jE=;
        b=mOMFtJkdxXn8I6rxtipImzyv3CGp/PYK501335o/NA8Gk3UGy9yEv7cI97E/d9Jtvp
         437Ly5lQ4Ria5q1UVT9FAa8kqulIeoooPf1KMywr+GOhcrMBnfEhQDK5aNRl8Glv3OZu
         +T0iJfhNRSXb7eLoosRfSzJ72xSNfQs7hhJwocxTigzWKutAFfAUWvKxEnAB1rv97v+Q
         9xNyErykixyucE4TLiN0dbHHiNQnh5f0iCcwEne7d4sSpq8WZpZcJ6LSvs/qgrT6jwEI
         jW5OusymPkHkFczF+t/tqGPSmUfnMyc0WL4k3UEuN4C/Loj4B/OHz+kSndYX9rzJhcmv
         VaPA==
X-Gm-Message-State: AOJu0Yw5uFMd8zoFI/MUklkvmSnxDGwlY5uWkNW2XIoZRtkd/gkGZObP
	Tl/FVDVidV4fuKTC6mkUgVzWi9S5/67ymRqFfEsfdchNwZTwimuLYpjv
X-Gm-Gg: ASbGncsAQFQPsxEhIZp4BClNeRy7fBSc29o2Q6HFhkshwjHVb0JySAJy6tyGlZsSNYW
	j17AB0jDKVikK3VZcApI2A8/F/IbxO9eyfdxGQiquzxZFCWB1ixMV182eksl1nKBmxbGXzO0WN6
	JqlHnG6IJNnJjDtJOH4dUJ2EzB3KkWaqepW26HLSQyEHj65maq0JA9YmxOYluk1/MIZCvNeyco3
	KUaambEDjGEyVFlc8wzDPwS/wjzevzybqBnz5v6kTzMZCC0hHZvYV9sKQp0mufret3TVaFKtNwb
	uqBzZAu3A7b44vn6iCBmQit7uF3eOEIf7+VgQdr0YWl28abhqeXOSxgr/8EypBHHf7jOl71RIj/
	PFWUhMUVQs55dLa+io+OaFvIjM3dbC9WYuY2X0Hz36jvZ5XA=
X-Google-Smtp-Source: AGHT+IF36wKKwGkJ1cLAeJf4fLbOD7OzXHE1njTd3XXg8omeRunLVwqO6h+W/bsXU80Mdzc12gq4Aw==
X-Received: by 2002:a05:651c:b0e:b0:338:1daf:f162 with SMTP id 38308e7fff4ca-33b58408280mr10992991fa.42.1757249744197;
        Sun, 07 Sep 2025 05:55:44 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-337f4c91a6bsm27836881fa.21.2025.09.07.05.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 05:55:43 -0700 (PDT)
Date: Sun, 7 Sep 2025 14:55:43 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
Message-ID: <vj7utcgrseaot6ktpbwgshthmjza7w7vk2glede273tza7yfi6@cyxppxoney5u>
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-12-ryncsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905191357.78298-12-ryncsn@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7FD72140006
X-Stat-Signature: 4iwnbox6ejdtp53k4f5kc4fcas9iyzbn
X-Rspam-User: 
X-HE-Tag: 1757249746-88132
X-HE-Meta: U2FsdGVkX1/hJfO4C5av3w30T6Q60bXraHw6/fV64h2fCHYg+xu2PB/ZeDk/VP2k1VRXwQqovZ4VLYIP8qxwfnPm8eMcYPeqh0jmoCH+PCpbYyu0JZ40XlsRY/qiyUC71mekkshXywSj0K7mCyDpNSBb3bW8h2Gzao7wyTaOaLrwGG796EGIZ8QLGzyrAbx5r6HWThaEBHDYeSGKhiMGM9i1tn1vuIxhv6b9o9tm1XlUAzmBqANkCQC2FFsQcNEgv8/aa/9BNB8Tj2FT6IPH2FjwsQQz5CEDOPRoWtXoAZDHjGCp0BtOfV0fbnTEErWKienZcWMOdY1/M1xrKacPoUjce5yv3sXVTsuJB5OhLa5Fgn8GYEIdgd/Xu4uJv2L45/4Mr8ukW/BJjun8kHWYJhUUx1+BsAcwLqt7wi/pbOTbmv8qrdvQUJWWOPtrEiycqTF+Z1nkSEPhrx0YHzdpNs2BQRx+5A+buGOGdlrr/v4owkuj7fve/EPn7fth9B7WdVNmRcN2egPQowIWX32kPffSoWL50qJYqNlWfMKTgNZgiO5ccmVoJOFiWxidCN8uh/HbdiDU85oWb7SQM+SUN4LPI3FNLJ+ypPd0Si+ZPAyPsOC1nlXzjvUYvMYaqXVfMjt9avngEzMuU0CKTrZ0FkjJ8LGfqohLsw1E8RPjAgtLHHSiGHA6FYJZhl4IA/EJaxpwTQjsoHxXtnyTKBtIVT3/wjYKqY/TRRvIUzLWVgL99hCwtV3Mp7AeqrEZL5LMudsp/j4v8HbWrRi6Ak8bU9YU3lR1z5lOsnffabHhsQXgWWSDxxMPYI1//D90HOhTUdnVQdg94L5GA7rV+RhnYORRkap6PBG8vRumoy62NCOi7DALwgi1dHa6gqMqkR9/lOmsyktleBoQw4HLaSQ/VYMlHf5h9nZx0f0OLprhBHxHl6z1SNo2MYetgMTOt1x7vlaMHFP5fmK4RJRXAI1
 Qziltgs5
 TspKRdvpw+5/DWtjQj5v0NpsDahl/isUmxakqloNw9F7lQJicI22xrzqBamysdYHaolLFq/Lvtwu+2Nyu325AepXephs1jxO7695Ohne+Rl2iMN8oO6GGu43f0vih+GR/ahxm0/DYjTnR1A4STMKOp8JonzNfcM3uf7HBnQmOXNGtbrEUp7GvV6ESaiM4JTVFSSIAsYGaveTmziAz7z5u3IsbzVDZ8QNigDtKSoACeQgbRE+UYKkTV+a4hWH8XRJwVTb+/WaNOZyDr3pjpHZMaacwMoLs8pnMhKCPH3deBZq2VVgZ7PJmIucL04rtioh43Ihu73i9o8eF+ygArwLcHBCspXBVSX8CVs4D+6o0J+QjOVoH1f4tEni9CtYUqPs6EpZIiLWCVamiCseZsI148U/5GENYJy8vBrvdDG+mF8TBZ5z3Nn9j0YN9/26mU+EOI1vONTwLOyzZOCqUoNRHOP0Wu2r/mxvK5DcdBJqajKJUiDb8oRcjCJncFttMRqEhW+Ox3q4cJvCigW510XlPfClSJ5Z3hz74q7gcd4RGUiHfc9Fg2P9OUy2GPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-06 03:13:53 +0800, Kairui Song wrote:
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
>  MAINTAINERS          |   1 +
>  include/linux/swap.h |   2 -
>  mm/huge_memory.c     |  13 +-
>  mm/migrate.c         |  19 ++-
>  mm/shmem.c           |   8 +-
>  mm/swap.h            | 157 +++++++++++++++++------
>  mm/swap_state.c      | 289 +++++++++++++++++++------------------------
>  mm/swap_table.h      |  97 +++++++++++++++
>  mm/swapfile.c        | 100 +++++++++++----
>  mm/vmscan.c          |  20 ++-
>  10 files changed, 458 insertions(+), 248 deletions(-)
>  create mode 100644 mm/swap_table.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1c8292c0318d..de402ca91a80 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16226,6 +16226,7 @@ F:	include/linux/swapops.h
>  F:	mm/page_io.c
>  F:	mm/swap.c
>  F:	mm/swap.h
> +F:	mm/swap_table.h
>  F:	mm/swap_state.c
>  F:	mm/swapfile.c
>  

...

> diff --git a/mm/swap.h b/mm/swap.h
> index a139c9131244..bf4e54f1f6b6 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -2,6 +2,7 @@
>  #ifndef _MM_SWAP_H
>  #define _MM_SWAP_H
>  
> +#include <linux/atomic.h> /* for atomic_long_t */
>  struct mempolicy;
>  struct swap_iocb;
>  
> @@ -35,6 +36,7 @@ struct swap_cluster_info {
>  	u16 count;
>  	u8 flags;
>  	u8 order;
> +	atomic_long_t *table;	/* Swap table entries, see mm/swap_table.h */
>  	struct list_head list;
>  };
>  
> @@ -55,6 +57,11 @@ enum swap_cluster_flags {

>  #include <linux/swapops.h> /* for swp_offset */

Now that swp_offset() is used in folio_index(), should this perhaps also be
included for !CONFIG_SWAP?

>  #include <linux/blk_types.h> /* for bio_end_io_t */
>  
> +static inline unsigned int swp_cluster_offset(swp_entry_t entry)
> +{
> +	return swp_offset(entry) % SWAPFILE_CLUSTER;
> +}
> +
>  /*
>   * Callers of all helpers below must ensure the entry, type, or offset is
>   * valid, and protect the swap device with reference count or locks.
> @@ -81,6 +88,25 @@ static inline struct swap_cluster_info *__swap_offset_to_cluster(
>  	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
>  }
>  
> +static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_entry_t entry)
> +{
> +	return __swap_offset_to_cluster(__swap_entry_to_info(entry),
> +					swp_offset(entry));
> +}
> +
> +static __always_inline struct swap_cluster_info *__swap_cluster_lock(
> +		struct swap_info_struct *si, unsigned long offset, bool irq)
> +{
> +	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
> +
> +	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
> +	if (irq)
> +		spin_lock_irq(&ci->lock);
> +	else
> +		spin_lock(&ci->lock);
> +	return ci;
> +}
> +
>  /**
>   * swap_cluster_lock - Lock and return the swap cluster of given offset.
>   * @si: swap device the cluster belongs to.
> @@ -92,11 +118,48 @@ static inline struct swap_cluster_info *__swap_offset_to_cluster(
>  static inline struct swap_cluster_info *swap_cluster_lock(
>  		struct swap_info_struct *si, unsigned long offset)
>  {
> -	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
> +	return __swap_cluster_lock(si, offset, false);
> +}
>  
> -	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
> -	spin_lock(&ci->lock);
> -	return ci;
> +static inline struct swap_cluster_info *__swap_cluster_lock_by_folio(
> +		const struct folio *folio, bool irq)
> +{
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> +	return __swap_cluster_lock(__swap_entry_to_info(folio->swap),
> +				   swp_offset(folio->swap), irq);
> +}
> +
> +/*
> + * swap_cluster_lock_by_folio - Locks the cluster that holds a folio's entries.
> + * @folio: The folio.
> + *
> + * This locks the swap cluster that contains a folio's swap entries. The
> + * swap entries of a folio are always in one single cluster, and a locked
> + * swap cache folio is enough to stabilize the entries and the swap device.
> + *
> + * Context: Caller must ensure the folio is locked and in the swap cache.
> + * Return: Pointer to the swap cluster.
> + */
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio(
> +		const struct folio *folio)
> +{
> +	return __swap_cluster_lock_by_folio(folio, false);
> +}
> +
> +/*
> + * swap_cluster_lock_by_folio_irq - Locks the cluster that holds a folio's entries.
> + * @folio: The folio.
> + *
> + * Same as swap_cluster_lock_by_folio but also disable IRQ.
> + *
> + * Context: Caller must ensure the folio is locked and in the swap cache.
> + * Return: Pointer to the swap cluster.
> + */
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio_irq(
> +		const struct folio *folio)
> +{
> +	return __swap_cluster_lock_by_folio(folio, true);
>  }
>  
>  static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
> @@ -104,6 +167,11 @@ static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
>  	spin_unlock(&ci->lock);
>  }
>  
> +static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
> +{
> +	spin_unlock_irq(&ci->lock);
> +}
> +
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
> @@ -123,10 +191,11 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
>  #define SWAP_ADDRESS_SPACE_SHIFT	14
>  #define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
>  #define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
> -extern struct address_space *swapper_spaces[];
> -#define swap_address_space(entry)			    \
> -	(&swapper_spaces[swp_type(entry)][swp_offset(entry) \
> -		>> SWAP_ADDRESS_SPACE_SHIFT])
> +extern struct address_space swap_space;
> +static inline struct address_space *swap_address_space(swp_entry_t entry)
> +{
> +	return &swap_space;
> +}
>  
>  /*
>   * Return the swap device position of the swap entry.
> @@ -136,15 +205,6 @@ static inline loff_t swap_dev_pos(swp_entry_t entry)
>  	return ((loff_t)swp_offset(entry)) << PAGE_SHIFT;
>  }
>  
> -/*
> - * Return the swap cache index of the swap entry.
> - */
> -static inline pgoff_t swap_cache_index(swp_entry_t entry)
> -{
> -	BUILD_BUG_ON((SWP_OFFSET_MASK | SWAP_ADDRESS_SPACE_MASK) != SWP_OFFSET_MASK);
> -	return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
> -}
> -
>  /**
>   * folio_matches_swap_entry - Check if a folio matches a given swap entry.
>   * @folio: The folio.
> @@ -177,16 +237,15 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
> -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> -			 gfp_t gfp, void **shadow);
> +void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow);
>  void swap_cache_del_folio(struct folio *folio);
> -void __swap_cache_del_folio(struct folio *folio,
> -			    swp_entry_t entry, void *shadow);
> -void __swap_cache_replace_folio(struct address_space *address_space,
> -				swp_entry_t entry,
> -				struct folio *old, struct folio *new);
> -void swap_cache_clear_shadow(int type, unsigned long begin,
> -			     unsigned long end);
> +/* Below helpers require the caller to lock and pass in the swap cluster. */
> +void __swap_cache_del_folio(struct swap_cluster_info *ci,
> +			    struct folio *folio, swp_entry_t entry, void *shadow);
> +void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> +				swp_entry_t entry, struct folio *old,
> +				struct folio *new);
> +void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
>  
>  void show_swap_cache_info(void);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
> @@ -254,6 +313,32 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> +static inline struct swap_cluster_info *swap_cluster_lock(
> +	struct swap_info_struct *si, pgoff_t offset, bool irq)
> +{
> +	return NULL;
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio(
> +		struct folio *folio)
> +{
> +	return NULL;
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio_irq(
> +		struct folio *folio)
> +{
> +	return NULL;
> +}
> +
> +static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
> +{
> +}
> +
> +static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
> +{
> +}
> +
>  static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
>  {
>  	return NULL;
> @@ -271,11 +356,6 @@ static inline struct address_space *swap_address_space(swp_entry_t entry)
>  	return NULL;
>  }
>  
> -static inline pgoff_t swap_cache_index(swp_entry_t entry)
> -{
> -	return 0;
> -}
> -
>  static inline bool folio_matches_swap_entry(const struct folio *folio, swp_entry_t entry)
>  {
>  	return false;
> @@ -322,17 +402,22 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
>  	return NULL;
>  }
>  
> -static inline int swap_cache_add_folio(swp_entry_t entry, struct folio *folio,
> -				       gfp_t gfp, void **shadow)
> +static inline void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow)
>  {
> -	return -EINVAL;
>  }
>  
>  static inline void swap_cache_del_folio(struct folio *folio)
>  {
>  }
>  
> -static inline void __swap_cache_del_folio(swp_entry_t entry, struct folio *folio, void *shadow)
> +static inline void __swap_cache_del_folio(struct swap_cluster_info *ci,
> +			    struct folio *folio, swp_entry_t entry, void *shadow)
> +{
> +}
> +
> +static inline void __swap_cache_replace_folio(
> +		struct swap_cluster_info *ci, swp_entry_t entry,
> +		struct folio *old, struct folio *new)
>  {
>  }
>  
> @@ -367,7 +452,7 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  static inline pgoff_t folio_index(struct folio *folio)
>  {
>  	if (unlikely(folio_test_swapcache(folio)))

> -		return swap_cache_index(folio->swap);
> +		return swp_offset(folio->swap);

This is outside CONFIG_SWAP.

>  	return folio->index;
>  }

...

Regards,
Klara Modin

