Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94947C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7EF6B007B; Fri,  7 Aug 2026 11:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669506B0088; Fri,  7 Aug 2026 11:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5590E6B008A; Fri,  7 Aug 2026 11:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15E256B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:49:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97D2F120407
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:49:29 +0000 (UTC)
X-FDA: 85074908058.10.E76B6D9
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 81D4540007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:49:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="HRECn/Id";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786117767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEn2KGn5WZDKTdyZCzrkPMcKy/ABJR6AC0QsaSC3OWk=;
	b=lxqHnOq8J1qFmcGh8AEKQlhTe91BpD1wS7eGEjJUaV1IbPKUvelPgU4naW8fVgD4Mu5sPS
	/3wURWSNkqdhx3BIROeZ513ur82ONtPIfrDepIkyJ6l6EF2v7ket9IE1TAKFEGvW9duodb
	XTrC1KNA++J1gKKoJv3vU5oMykDNIuQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786117767;
	b=aT18oifEb10G6vHR6sKof8bwVUEgphlMCL5H3bde/2LYJeL42m3V0JniWGvFXUGfXT/nbJ
	oBKHeC4wU4PlC3D6+kxYa1r40X9kfRqC8nrMBmJW1QiwiS8BkdgQFhn4CQN2nbfvvBViSy
	bXgBLOGhzd+BmXuqNpm2iU0Jhh0Sjp4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="HRECn/Id";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso15526686d6.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 08:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786117766; x=1786722566; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CEn2KGn5WZDKTdyZCzrkPMcKy/ABJR6AC0QsaSC3OWk=;
        b=HRECn/IdR9Z2x6o3FSuMIliS2GpJU3M+bAan7sSg+AjR7maNJRaTNCeVBohlcAz2QV
         yvLzE1CDJCaGDeQGij8b/abhaUIOOARmrHjCv0PIY+APklCL3H8Tmiu9kSBLJTRMeMJh
         Zb4JBiCP2miH76ibA2+2pgQ+wBY15XlkkmsLYyY5W+TParPC+NZAkN9qbFhBeHZWVK3S
         mPj4awUPQKb/37oTHJ/osd6BWQ/dcNkmz6xqY8n/SfK3l/V8EJ5YaI5CkWKgGBHFXZ5o
         u465cj56Pe1BzZCm0ehZluyR6y614AKwwEfvpnXGo9iya/F+bHpk5k2Gsae+jSzq3g7m
         L/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786117766; x=1786722566;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CEn2KGn5WZDKTdyZCzrkPMcKy/ABJR6AC0QsaSC3OWk=;
        b=M7+gHcnIpTdcJerlJGpnecKxsRhxDe4+qMfKkdQaF9VV8YyGBO1y4v2tnyoOrVvm0N
         gzK6HtDbD6ys3U7vCGxBG1dRShtWhjj5DBjOSwIT4oezy2oTIrgki0WH6MNRJFqwfJMd
         DTmeBnpg4/+M4wPgbJjp/0kdk75raYUVeQMXoRf65Cz/6ICFb9Luoz02F/YDiIXXeyHJ
         hENjWAGXUIox5Fs9oIc4REIUkxKaVC64IgHpuVc4qaukLydmFt48bbWwJxjqh9aRmoAK
         H+r/JVIHZ3wy2mD7pD+0KYaQaqx/8yWyMiGAKKp6rb6a6csD6DDWLdWyBSq5MfyZS9OO
         mRgg==
X-Forwarded-Encrypted: i=1; AHgh+RrG7g2ep4eXIMdgRj3lwbJytT5uRtjjRkimBhaKVbmh/Gf1TLcMByxi1Oz972v3hk7RRH6gSpqVNw==@kvack.org
X-Gm-Message-State: AOJu0YzLpTan9dWh/WBBs7y8WMoT6esvl59TUx2I36nWcIi3UjPFO1gO
	UXd+/SpvqEs1ZxGrCdqL493gJ5jUO8moSd0N3nrvXN8zQbZPvy8gdN3G+VHFChdvEbo=
X-Gm-Gg: AR+sD12SZqqJE1wgWs04HUITw64gPdGpkw1DZDTyGp6Pt+NGI6ghsCbyCyEY+wTjT31
	hP0nwZdl1wFvpjczuvcRt3VkBtj+UPV4i+3pCoGD7UOaHl2jqkEUJFIgL1qcE8lZ5AD0FpZDzPL
	+qpFaV7D7siHh4gxZ3ECVszOivCsPPMATHEC0RNna/T9LiIHC2YDGTOyJZ3sC/++yNCwmB2cBX+
	FFemCRzZQ0r7vHc8nUuiAKY2BdRa+3nbqXD0rrflmvVsgAyWWqPiUR+X+Dhj0ubLRCWgKzecuE6
	VVR6ctLIIWAMNJTAY7+VscCyw2bzmaY+IF9GToGwGV6itslXHOR72ak9uDNYzTmmz3R85VzNa4G
	nd1rDIyDPcYMS7Of2N5SZaxYKyRN/zc9HiNCOp8Il4k116qqGq59aQpGLlRgiTr294Oh7uZLcGP
	TXSMTi4Wmy2N72OjUZ4u9JkHu3vJJ6C/otgLBXOKzrOiEquCR17plrpZwVpAA=
X-Received: by 2002:a05:6214:450e:b0:907:bf1e:f888 with SMTP id 6a1803df08f44-9088f9ec72amr206847166d6.17.1786117766300;
        Fri, 07 Aug 2026 08:49:26 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a92ff8c6sm11404806d6.28.2026.08.07.08.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 08:49:24 -0700 (PDT)
Date: Fri, 7 Aug 2026 11:49:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, riel@surriel.com,
	gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
Message-ID: <anX-ga41DMNWF6-2@cmpxchg.org>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
 <20260806184254.3790858-2-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806184254.3790858-2-nphamcs@gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 6zquk8gonnkwb8ehcpdhbwyhq3ftp54o
X-Rspamd-Queue-Id: 81D4540007
X-HE-Tag: 1786117767-422792
X-HE-Meta: U2FsdGVkX1+yQqzRdHG1CTMoiBTS46UpeLkfMwHvmfjDTiiFrWexYzh7d0uF215+SP+moh9klSb3gXfAPLdM4UB5Hro5RyhXVaEzATEJDnJKT8wloOIq0FlrrS0o668JZEaaWrvWMqNzdxiY440PlAJdA5x55ZnhgQJuNnD98trEVQg8PgR0xc0kdyJGFXoOVZS0c5hAmhz6oS4vCQgMKFiqAcKxdRpuJ/oiz9iohxu3ftteLMBGQ0npzpzf0JIsHLz+DJGT+BVbm9ncu9ORSDsAKC2i+ELefvHPiVgP7EC3uSJkqmy20wey7jQD4vAMqrPsUAb+M8nWyP5fvzkszWRebSpAXegn2H39p4cR/NzK819LId4Zb2MYfrYKX7eDkDWEvgYuKTA6uTPit/36xuzTF8tVwzMHuy9XiS2R9vpAVbD4MdOGDi45OfIqKsSYY6ohbbPUek+w3aedcJNPCpR/f0qrKbXxcvwcn8tx39yk6dkK3cXJbg/Qr27s6AXVgRGmkmVw03/kkmyo4gP5mHTStvXDAbb2scMLCukM+LQ3VyeX8T5hbadb4eW+xK6Pzmk3UFanrbzRa9fQ+KMz5d4+Kkf3Sj5PyBKVkHIW7hbbCEy3P/CuMwybDuCCQ3JN3m1S2HaeSEzCk7TmGWJ6ehE+Q4UdSNR74doyyWU3tSx/FxavwJ+qgRvJ8QZwQefabz0UZIZWY9xE7/uFLPbI0ucb0TWuA1sE9gRMOmYaMmKH29jANi7RaYiq/H51atxQM0m5EqBKoWm/T5/58KcyJxRiNZSruZmjzvb1H19GqdVIHlzGOQl6dE+sJpB6QR5teS279yBYoYonHyRwq0vWAfvyYLIcWONR90DSB/qjSAqfIM5Za7/+WfKyQn5R8Ipys/qXu88QBpvqm2PfWpw28OlcsJeVS2i/4uKwrxiiCbEryPr7cn5v5NIgWB6rmQM+1tWgXFqlSlqmCyV+RDG
 dSeJHIrw
 /Gd0mn8wvsFdE5fRsMce5X42N6LxQhAOPS+d/36gZd5GzV37w6oHVfColMczGoyD2fLRDMDLROxd8XwfIatiEn68AtJJ9X9n5FObUUpRKlsk1ZYnZ7qeowcHjcNrIS3jvtmBezpxlJ55beQ/v+YA/ZUOm4PtABDfw0ZOssgGVPcjtaj3YFGtvkLK0OmcdO1BdD2qIUCm6CuBe/SxuFabsp0TZp+tx8+tO8NEGQP4+7mLdKh+wH5QR56Y1oGTH1c9dvbuKMwIkygbzSNElKb1ED/g4brNlv0t0w4JAob60WCkx1/X6Vvd0hKUUz/YEf2Du/iMHfazIZoNtwx4Le9gZeK4H54V17Xl+cuDBXAMnjbYvla88jYpBaV1kGEr3ziT7KxYL2PEyXhwCbKA094F5tjbl4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Nhat,

This looks pretty clean to me overall. Nice. A few comments inline:

On Thu, Aug 06, 2026 at 11:42:44AM -0700, Nhat Pham wrote:
> @@ -276,8 +277,21 @@ struct swap_info_struct {
>  	struct list_head discard_clusters; /* discard clusters list */
>  	struct plist_node avail_list;   /* entry in swap_avail_head */
>  	const struct swap_ops *ops;
> +	struct xarray cluster_info_pool; /* Xarray for vswap dynamic cluster info */
>  };
>  
> +#ifdef CONFIG_VSWAP
> +static inline bool swap_is_vswap(struct swap_info_struct *si)
> +{
> +	return si->flags & SWP_VSWAP;
> +}
> +#else

I think what could make sense is have

- CONFIG_VSWAP
- CONFIG_VSWAP_DEFAULT_ENABLED
- a boot flag that's = CONFIG_VSWAP_DEFAULT_ENABLED

Then you can use jump labels to cut runtime overhead to 0 if it isn't
enabled at boot.

This way distributions can ship it with no overhead out of the box,
while allowing users to opt in for early testing.

IMO this is more valuable than a runtime toggle.

It should be part of this patch if you add it.

> +static inline bool swap_is_vswap(struct swap_info_struct *si)
> +{
> +	return false;
> +}
> +#endif
> +
>  static inline swp_entry_t page_swap_entry(struct page *page)
>  {
>  	struct folio *folio = page_folio(page);
> @@ -402,6 +416,8 @@ void swap_free_hibernation_slot(swp_entry_t entry);
>  
>  static inline void put_swap_device(struct swap_info_struct *si)
>  {
> +	if (swap_is_vswap(si))
> +		return;
>  	percpu_ref_put(&si->users);
>  }
>  
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 331daf7fcfab..32d38b552845 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -19,6 +19,16 @@ menuconfig SWAP
>  	  used to provide more virtual memory than the actual RAM present
>  	  in your computer.  If unsure say Y.
>  
> +config VSWAP
> +	bool "Virtual swap device"
> +	depends on SWAP && 64BIT
> +	help
> +	  Adds a virtual swap layer that decouples swap entries in page
> +	  tables from physical backing storage. Swap entries are allocated
> +	  from a virtual swap device and can be backed by zswap, a physical
> +	  swapfile, or kept in memory - with the backing changeable at
> +	  runtime without invalidating page table entries.

IMO this is difficult for a user to decide.

If we want to make this as a config, then IMO the help text should be
about not requiring a swapfile to use zswap, zerofill pages etc.

From where I'm standing, though, this code is no longer a separate
vswap.c feature like it used to be. It's pretty integrated into the
swapcode, and it looks like a good chunk of the core datastructures
aren't conditional either.

At that point, the usefulness of the config option is limited. If you
go with the jump label and there is no runtime overhead, it might make
sense to just keep the option on what the JL should default to.

> @@ -143,9 +150,19 @@ static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
>  static inline struct swap_cluster_info *__swap_offset_to_cluster(
>  		struct swap_info_struct *si, pgoff_t offset)
>  {
> +	unsigned int cluster_idx = offset / SWAPFILE_CLUSTER;
> +
>  	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
>  	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
> -	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> +
> +	if (swap_is_vswap(si)) {
> +		struct swap_cluster_info_dynamic *ci_dyn;
> +
> +		ci_dyn = xa_load(&si->cluster_info_pool, cluster_idx);
> +		return ci_dyn ? &ci_dyn->ci : NULL;
> +	}
> +
> +	return &si->cluster_info[cluster_idx];
>  }

This now requires rcu. IMO a kdoc explaining that would be good.

> @@ -733,6 +765,11 @@ static void free_cluster(struct swap_info_struct *si, struct swap_cluster_info *
>  		return;
>  	}
>  
> +	if (swap_is_vswap(si)) {
> +		vswap_free_cluster(si, ci);
> +		return;
> +	}
> +
>  	__free_cluster(si, ci);

Should this be part of __free_cluster() instead?

- swap_cluster_assert_empty() seems useful.
- move_cluster() handles the list linkage and could do the list_del().
- swap_cluster_free_table() is the same.

The other caller is the discard path. That one isn't relevant, but it
shouldn't hurt. The layering would still be a bit cleaner this way.

> @@ -835,14 +872,21 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
>   * stolen by a lower order). @usable will be set to false if that happens.
>   */
>  static bool cluster_reclaim_range(struct swap_info_struct *si,
> -				  struct swap_cluster_info *ci,
> +				  struct swap_cluster_info **pcip,
>  				  unsigned long start, unsigned int order,
>  				  bool *usable)
>  {
> +	struct swap_cluster_info *ci = *pcip;
>  	unsigned int nr_pages = 1 << order;
>  	unsigned long offset = start, end = start + nr_pages;
>  	unsigned long swp_tb;
>  
> +	/*
> +	 * Take RCU read lock before releasing the cluster lock to keep ci
> +	 * alive - for vswap dynamic clusters, ci is freed via kfree_rcu
> +	 * and the grace period could otherwise elapse in the window.
> +	 */
> +	rcu_read_lock();
>  	spin_unlock(&ci->lock);

Since you replace the naked spin_lock() below with
swap_cluster_lock(), change this to swap_cluster_unlock() as well?

>  	do {
>  		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
> @@ -852,7 +896,15 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
>  			if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY) < 0)
>  				break;
>  	} while (++offset < end);
> -	spin_lock(&ci->lock);
> +	rcu_read_unlock();
> +
> +	/* Re-lookup: dynamic cluster may have been freed while lock was dropped */
> +	ci = swap_cluster_lock(si, start);
> +	*pcip = ci;
> +	if (!ci) {
> +		*usable = false;
> +		return false;
> +	}
>  
>  	/*
>  	 * We just dropped ci->lock so cluster could be used by another

> @@ -1146,6 +1239,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
>  			goto done;
>  	}
>  
> +	if (swap_is_vswap(si)) {
> +		found = alloc_swap_scan_dynamic(si, folio);
> +		if (found)
> +			goto done;
> +	}

The name and the composability look off to me.

Can you make this a pure allocation function - vswap_alloc_cluster()
or something - that links it to &si->free_clusters, then jump back and
use the existing alloc_swap_scan_list() sites?

There is a new_cluster: label upstream you could use for the retry.

> +
>  	if (!(si->flags & SWP_PAGE_DISCARD)) {
>  		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
>  		if (found)
> @@ -1264,6 +1363,13 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
>  			goto skip;
>  	}
>  
> +	/*
> +	 * Keep vswap off the avail list - it is not allocated from by
> +	 * the physical swap allocator (swap_alloc_fast/slow).
> +	 */
> +	if (swap_is_vswap(si))
> +		goto skip;

This is describing what the code does, followed by a why not.

Describe the why: Vswap space is only allocated through [...], not [...]

> @@ -3528,10 +3668,43 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  				    unsigned long maxpages)
>  {
>  	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> -	struct swap_cluster_info *cluster_info;
> +	struct swap_cluster_info *cluster_info = NULL;
> +	struct swap_cluster_info_dynamic *ci_dyn;
>  	int err = -ENOMEM;
>  	unsigned long i;
>  
> +	/* For SWP_VSWAP files, initialize Xarray pool instead of static array */
> +	if (swap_is_vswap(si)) {
> +		/*
> +		 * Pre-allocate cluster 0 and mark slot 0 (header page)
> +		 * as bad so the allocator never hands out page offset 0.
> +		 */
> +		ci_dyn = kzalloc_obj(*ci_dyn, GFP_KERNEL);
> +		if (!ci_dyn)
> +			goto err;
> +		spin_lock_init(&ci_dyn->ci.lock);
> +		INIT_LIST_HEAD(&ci_dyn->ci.list);
> +
> +		nr_clusters = 0;

But it's one, not zero. And only the first slot is bad. Why is the
rest not usable and the cluster on the nonfull_clusters list?

I think you can make the integration a bit more organic in general:

Don't do the DIV_ROUND_UP per default only to overwrite it here again
e.g.

If you come out of this branch with cluster_info == &ci_dyn->ci, you
should be able to reuse the existing swap_cluster_setup_bad_slot(0).

swap_header && i < swap_header->info.nr_badpages should skip that loop
as well.

Your maxpages is SWAPFILE_CLUSTER aligned, so that

	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {

loop is skipped as well.

> +		xa_init_flags(&si->cluster_info_pool, XA_FLAGS_ALLOC);
> +		err = xa_insert(&si->cluster_info_pool, 0, ci_dyn, GFP_KERNEL);
> +		if (err) {
> +			kfree(ci_dyn);
> +			goto err;
> +		}
> +
> +		err = swap_cluster_setup_bad_slot(si, &ci_dyn->ci, 0, false);
> +		if (err) {
> +			xa_erase(&si->cluster_info_pool, 0);
> +			swap_cluster_free_table(&ci_dyn->ci);
> +			kfree(ci_dyn);

IMO it would be nicer to make this part of free_swap_cluster_info()
instead of duplicating it.

> +			xa_destroy(&si->cluster_info_pool);

That one probably doesn't matter. If these allocations fail at boot,
the system is in trouble.

> +			goto err;
> +		}
> +
> +		goto setup_cluster_info;
> +	}
> +
>  	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
>  	if (!cluster_info)
>  		goto err;
> @@ -3556,6 +3729,10 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
>  	if (err)
>  		goto err;
> +
> +	if (!swap_header)
> +		goto setup_cluster_info;

Is this reachable?

> @@ -3949,3 +4127,51 @@ static int __init swapfile_init(void)
>  	return 0;
>  }
>  subsys_initcall(swapfile_init);
> +
> +#ifdef CONFIG_VSWAP
> +struct swap_info_struct *vswap_si;
> +
> +/* vswap does no IO on its own. */
> +static const struct swap_ops vswap_ops = { };
> +
> +static int __init vswap_init(void)
> +{
> +	struct swap_info_struct *si;
> +	unsigned long maxpages;
> +	int err;
> +
> +	si = alloc_swap_info();
> +	if (IS_ERR(si))
> +		return PTR_ERR(si);
> +
> +	maxpages = min(swapfile_maximum_size,
> +		       ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUSTER));
> +	si->flags |= SWP_VSWAP | SWP_SOLIDSTATE | SWP_WRITEOK;

Please add a comment on the flag choices besides SWP_VSWAP.

