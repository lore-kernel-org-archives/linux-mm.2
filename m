Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B211CCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 05:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515406B00EF; Fri, 26 Jun 2026 01:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6EA6B00F0; Fri, 26 Jun 2026 01:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4058E6B00F1; Fri, 26 Jun 2026 01:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1535D6B00EF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:05:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 77E558CDF9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:05:17 +0000 (UTC)
X-FDA: 84920875074.23.2C07084
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E48C40003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:05:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kL8d4v0a;
	spf=pass (imf07.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782450315;
	b=qsDOsB7OSX6k/IQPa2KkbGaz6hpkcYxqrdZszikdtVh6vtxztZdkofWOCbSo261qHPcIqa
	DNpAPX35XyLdCTu9qhZWZ9lFXMkgp+TpgGl9VSZbLlYEFoj67KXEdCBwUPY4SVJ3O/u4kQ
	cWvHOz1shGaB+g8x28WCdhNPJPcpV9g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782450315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7v0PPdOi6Pl4ejNu0hv7r7pLaNyzclPpil1+QtQ9Dg=;
	b=yhTxyHymQPJ0uX6Vn/+zlMF22Ktj11HD8ov3gZbgvYwQqgUJ40v0CGlP6vA3LSz5oXG/Bt
	DSnFF92Lkf0eo9oNcr8P+JNWCRvV+njmJ3TobpAmr9ZexcGywmKt6uAs37+m6BuT0McFs6
	etNRmIJs0qbtm8+Y1vNqfs6MqOU4TIw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kL8d4v0a;
	spf=pass (imf07.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <925c8686-9ff6-44c1-9780-63bd7cd8a1c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782450313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7v0PPdOi6Pl4ejNu0hv7r7pLaNyzclPpil1+QtQ9Dg=;
	b=kL8d4v0aV7DDMvUYsPHOBhZqJmyWCtgnEifP1xb8Lm81nORYLNFhU9MTI36LrxV6kcHrfM
	nyccMjaKwGfzz4YYmbZciuqA8+g4mk416iv0tH3va/dcRXXk+xaRdUVkex/7tHlwIkVPZ0
	nNRUVyjEldhtn1B30EduqeECwLlXuwc=
Date: Fri, 26 Jun 2026 13:04:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
Content-Language: en-US
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260626032012.1049667-1-hui.zhu@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <20260626032012.1049667-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xegmc9pbd6aezyxtk9ckuyqze3sxp94y
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E48C40003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782450315-698455
X-HE-Meta: U2FsdGVkX194E2xmh1ER4CRD56y6zGy0aZ1no/R55xm0cZUzkFsY0YsWrAbg1T33bUpL1KG5Ie7yT1MBHY4b12037rSg7Ig+H+AKF72JXk7PFRPTlOkrmZsRgWJLJCxzcoKPwSirevLEi5j9L4N9m4ePZQei1uxbiNeXBqKeXyVpfHzzJYPNI2Ef/+4Ehn8zFutpbttoU/JuVlR8haveWdCA7YOqdaOKNyr71aSXZMzcNO6BhVAp7e9zH6p6L6juH+9IFORDVPdZC22FwuGRzavvlXiC8XVJRw6kpLrrxJ8Oxu/ojo1AqPKPSMe6x00JUmgRI+CN7asAasMFgBTROY+XvZQ1Heg6SAKg06XbFjM2YTo88u5RP1IkfAKI/oew1JhBDntn6HHJDj7dXp40fRkW61CbtZyAhSfcVxMDhlaLTgS/bwfbCzsC1y0M/ZeRUtt27ZHXf/IUIcnWGEWDUez4eDBzD5Y8KCWHvMi3OJ2koFajyhscqHHqoruL6Pki7FUplFOJBlgyKIztyM9pX9z2rM4nMECj3sb5db2rmFgFnNqbHiLJp7SiHlamWUl3V6ETe5Hn9JwelmMGlLih2I/nY4FuJ0at5PMN7jkVjn+ToVgqKGJSRG6FP2hYXaATFMYeZuJFdpO9nUbDZ7LZL8WM96jUIYxpYwKzyrE4XrK/T6PBkUVPv8IKqh722H3k/+8Ea4CzPa+rz2Ax974vyy8CLU+Qsblqe1LCGF6xBOQwOOEXHL+9Qpx3P1MYd3prCXLPawQL1nTaH+quynEqfd1k5ZYvlmuWt054UIGoFbOufaDEghbd/Kip/nTwmcBkOKPER9RT0cKFnzbeOPzm/sKbVReoIbDzVfKBb101Kl3u/SOqSEqY1wHzZGS3REFye8Rea0A8t+6M3+Vu9GXcPgVsax9w1FiAVv+0HppRmqZLL0cj5voRM1Yl2edzbjMrDyE4SKvVtEAY0+qhE7m
 DAmkCSHl
 k9JpGNXLs6GvHptMshQVyrpGCfrplr90FF2kee8IfJYxXZRwffRUxpR6NYf5EG1hoR+lDLzohTgJuJYLrfjqbmmErrisrU/VNKrnIcW21RbLNkNWTOz10u6D28+pRvOUgcFCOIR2pfkQstaV6C6IxirwiGTNmArLhhxHkI8AnZJGxgG8vcPBh14fr6l26DE4ZhQrO4ix/+F0Y6M/SzDwi+OXNFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/6/26 11:20, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The node id and zone id occupy fixed bit-ranges of page->flags that
> are set once at page init and never modified afterwards, so they can
> never overlap with the low PG_locked/PG_waiters bits touched by the
> folio lock path.
> 
> ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
> used to check a by-value copy of the flags word, not the actual shared
> page->flags/folio->flags being modified concurrently, so it didn't
> reliably assert anything about the real race.
> 
> For zonenum, move the assertion out of memdesc_zonenum() into
> page_zonenum() and folio_zonenum(), where flags is dereferenced
> directly from the page/folio.
> 
> For nid, turn memdesc_nid() into a macro instead, so the mdf argument
> is expanded as the caller's own flags expression
> (PF_POISONED_CHECK(page)->flags or folio->flags) rather than copied
> into a function parameter, letting ASSERT_EXCLUSIVE_BITS() check the
> real page->flags/folio->flags directly.
> 
> On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
> folded to a constant, so page->flags/folio->flags was never actually
> read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
> folded away, so doing it unconditionally would add a pointless read
> of page->flags/folio->flags and a check that can never fire. Keep
> page_to_nid()/folio_nid() as plain "return 0" static inline stubs
> under CONFIG_NUMA=n instead.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v7:
> According to the comments of Sashiko, restrict the memdesc_nid() macro
> to CONFIG_NUMA, keeping a plain "return 0" static inline stub otherwise,
> and re-add a local page pointer in page_to_nid() to avoid evaluating
> PF_POISONED_CHECK(page) twice.
> v6:
> According to the comments of David, turn memdesc_nid() from a static
> inline function into a macro so ASSERT_EXCLUSIVE_BITS() can check the
> caller's page->flags/folio->flags directly.
> v5:
> According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
> calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
> ZONES_WIDTH != 0 (for zonenum).
> According to the comments of David, avoid calling
> PF_POISONED_CHECK(page) twice in page_to_nid().
> According to the warning of lkp, switch the CONFIG_NUMA=n
> page_to_nid()/folio_nid() stubs from macros to static inline functions.
> v4:
> According to the comments of Andrew and Sashiko, set
> page_to_nid()/folio_nid() as static inline stubs returning 0
> under CONFIG_NUMA=n.
> v3:
> According to the comments of Andrew and Sashiko, move
> ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
> into the page/folio call sites.
> v2:
> According to the comments of David, remove useless comments and use
> ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
> page_to_nid().
> 
>  include/linux/mm.h     | 25 +++++++++++++++++++++++--
>  include/linux/mmzone.h |  7 ++++++-
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..63fcf277b675 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2288,21 +2288,42 @@ static inline int page_zone_id(struct page *page)
>  #ifdef NODE_NOT_IN_PAGE_FLAGS
>  int memdesc_nid(memdesc_flags_t mdf);
>  #else
> +#ifdef CONFIG_NUMA
> +#define memdesc_nid(mdf)						\
> +({									\
> +	ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);	\
> +	(int)((mdf.f >> NODES_PGSHIFT) & NODES_MASK);			\
> +})
> +#else
>  static inline int memdesc_nid(memdesc_flags_t mdf)
>  {
> -	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
> +	return 0;
>  }
>  #endif
>  
> +#ifdef CONFIG_NUMA
>  static inline int page_to_nid(const struct page *page)
>  {
> -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> +	const struct page *p = PF_POISONED_CHECK(page);
> +
> +	return memdesc_nid(p->flags);
>  }
>  
>  static inline int folio_nid(const struct folio *folio)
>  {
>  	return memdesc_nid(folio->flags);
>  }
> +#else
> +static inline int page_to_nid(const struct page *page)
> +{
> +	return 0;
> +}
> +
> +static inline int folio_nid(const struct folio *folio)
> +{
> +	return 0;
> +}
> +#endif
>  
>  #ifdef CONFIG_NUMA_BALANCING
>  /* page access time bits needs to hold at least 4 seconds */
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ca2712187147..1b4336098113 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1274,17 +1274,22 @@ static inline bool zone_is_empty(const struct zone *zone)
>  
>  static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
>  {
> -	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
>  	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
>  }
>  
>  static inline enum zone_type page_zonenum(const struct page *page)
>  {
> +#if ZONES_WIDTH != 0
> +	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
> +#endif
>  	return memdesc_zonenum(page->flags);
>  }
>  
>  static inline enum zone_type folio_zonenum(const struct folio *folio)
>  {
> +#if ZONES_WIDTH != 0
> +	ASSERT_EXCLUSIVE_BITS(folio->flags, ZONES_MASK << ZONES_PGSHIFT);
> +#endif
>  	return memdesc_zonenum(folio->flags);
>  }
>  

Better to factor out a common macro alongside a comment for these two '#if'?

Thanks,
Leon


