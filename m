Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13CBC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA726B00A0; Tue,  8 Sep 2026 05:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7B2A6B00A1; Tue,  8 Sep 2026 05:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C006B00A2; Tue,  8 Sep 2026 05:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89D586B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:58:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23868140494
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:58:59 +0000 (UTC)
X-FDA: 85190146398.24.28D1BA9
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5BBBA100009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:58:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cICBqfFE;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861537;
	b=x/zf9u0+1kR6swFhIN4SWF0wN9lKWJUTY7HD+UrDlimt2J4X+5Cff7pPSKC+6hiQRUn7wQ
	Siy84tNgxtfdATEEAVo/f6SR5Sf4ah7hUPFy8jh44yfHjwTFr9rhEnVcQ54szo/lSyRR06
	qxj2qjTv4MTalU0HLVLKQqg4Cql3scU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cICBqfFE;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQGSZC66g+9Yoa6kLt6wXStpLC35PhuHPWRZU7fWt5s=;
	b=mg7lcC+vVU4kTQcgZjmY+aYa0ueKQamYRvHfuotjFSvm39Woa5MINNh8NFfhnyehJaH/Vl
	GUjTiMQbIpIF0r8K+lH3/5s+/1xVW3n0f5qYtmL3wijEebcVea7tRP5Htsg+vIIPBgXruS
	ymj4R7Nc95OrKiLbQ6CQAPpvhMVoiDo=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-852c481415fso5331439b3a.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 02:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788861536; x=1789466336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cQGSZC66g+9Yoa6kLt6wXStpLC35PhuHPWRZU7fWt5s=;
        b=cICBqfFEupHv5DCDo2Ux0OFQ+nzUlSlXQgyf5w8QxU0gDVqvwBjldcRxhBA3G/zQIs
         /vyS2yMZNw4nGO8LuyCLTepf2Y0t6bPMGqLJ3pMdY26kZSLxTJjq7en2ykPdRrKekQgc
         xGpukmg8NWzagyBDalXkflIFCr22jNhi99SiRnLTW26wxqVT/zp4QiSNvYAVQ6z+WeDL
         cOiJ78XeKZQXLJlkjYkPygfnuBIPA6fIfJkLUJmBtRWT/W0xjFNkhAXiycYanhIv5iwf
         TsLfpIvwJnGsNJXYxH3RgXZRDAHKyU6sebDbU5oWTlQKZUM/aqNcNr4SuhmXOlaRaDcv
         ACeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788861536; x=1789466336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cQGSZC66g+9Yoa6kLt6wXStpLC35PhuHPWRZU7fWt5s=;
        b=dfjntBOvzL42Mgl8mQ/B0lO+Sdh0LCepFepVV7h13/MO1u8O+sJEAmPFNaCj1PZnIX
         avgw0FY10aLA+iYN9yj48L/JNtudHYug8PhdRolTrGdtfDOSYbscLGey1cBRfcnqz9lZ
         4wz7cdksIjHVeZF3D9mRkUjwe6/s1Q5LaIVTSezfOZ3Gmx8w+aNhcm5A0qJUlqYsY5GE
         9aaxO7xA0GsARtTgDvd3WRCA8l2NFXrPObrsCtc3O+pO3a6xdma1YqOS+XydoNcvpxPF
         Qidnw/Q6EzTwVcWjPw+57Da5lc5xf5Q4m/gHz/BL/9yLrXiHW8YttwLyCKeG3bL5VYd4
         bARQ==
X-Forwarded-Encrypted: i=1; AKwUvBzdPezWJS2NZjewwm5KyNFDuRYSoEd7eIeU1E9JZTfn0hUPMiQ6e9U9AX0DVsGnqOPDxkEYl9aTKw==@kvack.org
X-Gm-Message-State: AFuF++lMDcjUeQT+05KKEVtcTMx466cQh5OmO+M1VWKSv4Wh5L4VtmqC
	8MlI3Yp4ZmcjiLLIJMYtZJODnsGlKjo6J142euhTo+oKvM8MvCUEx0Lb
X-Gm-Gg: AYBFou3CX2RsLVjWLnDfUghbVKTmxDRe5AX8X1hGS+tPg8XECPAOWJKNWdBNkfXnF9X
	XXy1304M1aGqOHtCv4uO08xjLkan5bNeqLaVmrOCk3EgezJNn5iVU5gtA7xCx0OUNgBrRWXHOJG
	IHh5lY+g+Pcot/niJkfdKs+izw7Mk01zYtdnJeCQ0eKvXO2vBZVW3IC462l9rbq8d91uQyYM8/r
	k1JAZv1rHY/McBgjMEDTm0dDdKprvFpvMoXNy5DDSaVKWdlTu2e9hBeDRH9vAniaVyoRUzTr20W
	e7IiNleOBCKgZb1MbiU1GL6FEkGVKsqruUUqBORiMfSOo/WwH6BJyvVWlNIyy7xbGxGV2wjVKfs
	Ndnc0BdaK2sjpcBU7SbB5d29wtoJyn1Iz7SISBt78+Z2MHv6ii+FnXRp8N2Na5bNahdKCRvRfXD
	52pmb1VxZ+s0nuW2dba06quuNbxVNT+g6dhrbDLkYCtEhvtLEWJoXZDt/1DNQ=
X-Received: by 2002:aa7:88d5:0:b0:851:b007:2fe0 with SMTP id d2e1a72fcca58-861677b22b3mr39152287b3a.1.1788861535407;
        Tue, 08 Sep 2026 02:58:55 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152d2ff5bsm5204514b3a.35.2026.09.08.02.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 02:58:54 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mm: swap: drop dropbehind swap cache folios on writeback completion
Date: Tue,  8 Sep 2026 17:58:41 +0800
Message-ID: <20260908095843.2365834-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825135209.3135169-3-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BBBA100009
X-Stat-Signature: d1fiopaomq3huoba1d79ihcwexbcg6yz
X-HE-Tag: 1788861537-56182
X-HE-Meta: U2FsdGVkX1/Emz93Owv1kP0813JEToZNIhHmDvvj6Zwj4Cfd+qvQJkZm5Z8T5RDCic0bPBouZJGS+gICnn3bqGf7If5pgwn4uKvall4w5uJm4016f8in4C2AVNplt6cA8Zf0E92JGtkVqvbq8L7M2riK12TeNrkKfiBZw7fQ0AIU0Fq+00EKikmqaswheRNEx+OxH+CkCwthObVUfTcf8PJWEjru5+HUuGrWW47JVrVcyGdmH/w5utk/2SZApLW8ARY49hgR0OMIDQqk+pYQ1O3W1a/u+WWsrcTNFYHP9C7Qbkb31IN/d6Nr77l50ZnMr3QnKAPq0Pq4t8ONqu6D/yLKdJoQTIUtLVPGNi9GwPX7H2VWSlnBEJC0epib2gQn2jSVaHNosEWc073sNZk7rQM1K2lwtAax8SIwBU740oszpMPsWF3KVEb7qj5nl55AkvkoCGqsVjGrM6F93iB+KL3evTHsDmAoIs3r3qj7DZEV+URESHBbNA940zaT1HB59VZkivrGwCivRavOtUCKGRXqKWdfYpuZSD4/M4U/6ZO6aB4XhZ+NROJ6PHUFAFpG6DXjbV5RDrxEenDSGYQ7ns+m0Vbyf1nojiKpQfjAqCDR3WH2DCrcSwAwjdknxvzOiT5buHPpLsVAGSaIgFcYVj2pk/Qt9rF2yljuCkL22TJHFsO2c9guI3GwiV/7VVBDTUiLwJFLtpwEuh9cvBb1pDHsUUZFrigJKR4yJelCfoD+/P++xvAPBqDx7gweGse7ma5rNsIMPWJtZ5qKOjNzYeTEDTCmpyJbV2Bu6SByAlfi3EjY9xlCViaQ07IzGFmZPZajLrek2s0hJgI6yT/hr/aFnN2U1uav8dGSPJJd8lzJurPTrird8FIwLocO9kOzJc9EnQelE8LUmW7Fb+SaDOTrXZe0Q6CTNtwbtrZBgOwi1OEpQabMAm6cqWjDsLwKQ1SDXqoCct6ZXSk4MXL
 9vD8Etmt
 UoV52evw4jLoD2N+PlJRh+tQdUZGzxT2dfcEfCcTroWXLQbGwIoCm+R37H9JkoEFVgE6pSGB8KzO4pu9V7y5lFuIDe9PXq2x2sBOb8Vs8VMvzUMr1YoTvuWsIGtmxFUsZY/yORwgxOj8PgOIBZ4Y6tXT+bVGmNrpK9vm1FO8ZTyrcKrtHR0iuwNCCa8+tz8ITc+q+F12vie4aVJaaJLPIgZ6WuvP5JS3KlY5BTO8cfMfURxzx7SBpLB83gzxIex6r/N/DiazYXjfTrefmAuBmgtdH/nBRAwNEBDqta3mRXwYhQMVTl4Swoavtlb2DmFHMMqH98IDFn4QQMcVdOAoigL93dnz6pJzp55gxGtK9uPaM1WM5jcU1Uk1poKBCoNVUK6E+3l9CNNJjtQeQU7Cd3vBv2Ho19QVe36T5PY6mjJtNrEcZnzpJI7Kr5OJrpqflpNhKBHar8+HB7ji/GkI/oxfLZIJjj1d1zFx7caiMV2vroZ7WSB1KO/n9rwePoafxmKW6B3lEchf4FhO21ExWOsiSTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 15:52:06 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> A PG_dropbehind folio is dropped from its cache once writeback completes
> rather than left for reclaim to find later; this is implemented for file
> folios in folio_end_dropbehind(). Extend it to swap cache folios.
> 
> The drop takes the folio and swap cluster locks and may sleep, so it
> cannot run in interrupt context. Set BIO_COMPLETE_IN_TASK on the write,
> as the file dropbehind paths do, and drop the folio directly from
> folio_end_writeback().
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  include/linux/swap.h |  5 +++++
>  mm/filemap.c         | 19 ++++++++++++++++++
>  mm/page_io.c         |  7 +++++++
>  mm/swap_state.c      | 41 +++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c          | 48 +++++++++++++++++++++++++++++++++++---------
>  5 files changed, 110 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 8f0f68e245ba..29ec60dcae21 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -374,6 +374,8 @@ extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
>  extern int vm_swappiness;
>  long remove_mapping(struct address_space *mapping, struct folio *folio);
> +long remove_mapping_reclaim(struct address_space *mapping, struct folio *folio,
> +			    struct mem_cgroup *target_memcg);
>  
>  #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
>  extern int reclaim_register_node(struct node *node);
> @@ -465,6 +467,8 @@ void swap_put_entries_direct(swp_entry_t entry, int nr);
>   */
>  bool folio_free_swap(struct folio *folio);
>  
> +void swap_writeback_dropbehind_folio(struct folio *folio);
> +
>  /* Allocate / free (hibernation) exclusive entries */
>  swp_entry_t swap_alloc_hibernation_slot(int type);
>  void swap_free_hibernation_slot(swp_entry_t entry);
> @@ -475,6 +479,7 @@ static inline void put_swap_device(struct swap_info_struct *si)
>  }
>  
>  #else /* CONFIG_SWAP */
> +static inline void swap_writeback_dropbehind_folio(struct folio *folio) {}
>  static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
>  {
>  	return NULL;
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d721986d5f46..040c97a121de 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1686,6 +1686,8 @@ EXPORT_SYMBOL_GPL(folio_end_writeback_no_dropbehind);
>   */
>  void folio_end_writeback(struct folio *folio)
>  {
> +	bool swap_dropbehind;
> +
>  	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
>  
>  	/*
> @@ -1695,7 +1697,24 @@ void folio_end_writeback(struct folio *folio)
>  	 * reused before the folio_wake_bit().
>  	 */
>  	folio_get(folio);
> +
> +	/*
> +	 * Sample this before folio_end_writeback_no_dropbehind() clears
> +	 * PG_writeback: until then a racing swapin cannot remove the folio from
> +	 * the swap cache. Afterwards it can, and the drop below then finds a
> +	 * non-swapcache folio and puts it back on the LRU instead. The
> +	 * reference taken above keeps the folio alive across that window.
> +	 */
> +	swap_dropbehind = folio_test_swapcache(folio) &&
> +			  folio_test_dropbehind(folio);
> +
>  	folio_end_writeback_no_dropbehind(folio);
> +
> +	if (swap_dropbehind) {
> +		swap_writeback_dropbehind_folio(folio);
> +		return;

I checked the refcount handoff from folio_end_writeback() to
swap_writeback_dropbehind_folio(): the extra reference provides the
expected caller reference for remove_mapping_reclaim(), giving the
expected 1 + folio_nr_pages(folio) count for folio_ref_freeze().

The swapcache/dropbehind state is sampled before clearing PG_writeback,
and the extra reference keeps the folio alive across a racing swapin.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
KunWu

> +	}
> +
>  	folio_end_dropbehind(folio);
>  	folio_put(folio);
>  }
> diff --git a/mm/page_io.c b/mm/page_io.c
> index b23f494fcc83..586c79c3bb3d 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -456,6 +456,13 @@ static void swap_writepage_bdev_async(struct folio *folio,
>  	bio->bi_end_io = end_swap_bio_write;
>  	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
>  
> +	/*
> +	 * Dropping the folio from the swap cache takes sleeping locks, so the
> +	 * completion must not run in interrupt context.
> +	 */
> +	if (folio_test_dropbehind(folio))
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> +
>  	bio_associate_blkg_from_page(bio, folio);
>  	count_swpout_vm_event(folio);
>  	folio_start_writeback(folio);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 07418fc94f00..231fa87cbbe0 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -537,6 +537,47 @@ struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
>  	return ret;
>  }
>  
> +/**
> + * swap_writeback_dropbehind_folio - drop a dropbehind swap cache folio
> + * @folio: the off-LRU folio whose writeback has completed
> + *
> + * Context: task context, with the reference taken by folio_end_writeback()
> + * donated to us.
> + */
> +void swap_writeback_dropbehind_folio(struct folio *folio)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	folio_lock(folio);
> +
> +	/* The folio was allocated off the LRU and nothing re-adds it here. */
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> +
> +	rcu_read_lock();
> +	memcg = folio_memcg(folio);
> +	if (!mem_cgroup_tryget(memcg))
> +		memcg = NULL;
> +	rcu_read_unlock();
> +
> +	/*
> +	 * Gate remove_mapping_reclaim() on folio_test_swapcache(): a racing
> +	 * swapin may have freed the swap slot (folio_free_swap()) and dropped the
> +	 * folio from the cache, and it must not run on a non-swapcache folio (it
> +	 * would trip __remove_mapping()'s mapping == folio_mapping() check).
> +	 */
> +	if (!folio_test_swapcache(folio) || folio_test_writeback(folio) ||
> +	    !remove_mapping_reclaim(swap_address_space(folio->swap), folio, memcg)) {
> +		/* Raced: the folio is now owned by the swapin; put it back. */
> +		folio_clear_dropbehind(folio);
> +		folio_add_lru(folio);
> +	}
> +
> +	mem_cgroup_put(memcg);
> +
> +	folio_unlock(folio);
> +	folio_put(folio);
> +}
> +
>  /*
>   * If we are the only user, then try to free up the swap cache.
>   *
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 848bd3e5eee2..4cc3a3ed6db6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -780,6 +780,22 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
>  	return 0;
>  }
>  
> +static long __remove_mapping_unfreeze(struct address_space *mapping,
> +				      struct folio *folio, bool reclaimed,
> +				      struct mem_cgroup *target_memcg)
> +{
> +	if (__remove_mapping(mapping, folio, reclaimed, target_memcg)) {
> +		/*
> +		 * Unfreezing the refcount with 1 effectively
> +		 * drops the pagecache ref for us without requiring another
> +		 * atomic operation.
> +		 */
> +		folio_ref_unfreeze(folio, 1);
> +		return folio_nr_pages(folio);
> +	}
> +	return 0;
> +}
> +
>  /**
>   * remove_mapping() - Attempt to remove a folio from its mapping.
>   * @mapping: The address space.
> @@ -794,16 +810,28 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
>   */
>  long remove_mapping(struct address_space *mapping, struct folio *folio)
>  {
> -	if (__remove_mapping(mapping, folio, false, NULL)) {
> -		/*
> -		 * Unfreezing the refcount with 1 effectively
> -		 * drops the pagecache ref for us without requiring another
> -		 * atomic operation.
> -		 */
> -		folio_ref_unfreeze(folio, 1);
> -		return folio_nr_pages(folio);
> -	}
> -	return 0;
> +	return __remove_mapping_unfreeze(mapping, folio, false, NULL);
> +}
> +
> +/**
> + * remove_mapping_reclaim() - Remove a folio from its mapping, as reclaim does.
> + * @mapping: The address space.
> + * @folio: The folio to remove.
> + * @target_memcg: The memcg to charge the eviction shadow to; the caller must
> + *                keep it alive across the call.
> + *
> + * Like remove_mapping(), but stores a workingset eviction shadow the way page
> + * reclaim does, so that a later refault can be detected and the folio
> + * re-activated.
> + * Return: The number of pages removed from the mapping.  0 if the folio
> + * could not be removed.
> + * Context: The caller should have a single refcount on the folio and
> + * hold its lock.
> + */
> +long remove_mapping_reclaim(struct address_space *mapping, struct folio *folio,
> +			    struct mem_cgroup *target_memcg)
> +{
> +	return __remove_mapping_unfreeze(mapping, folio, true, target_memcg);
>  }
>  
>  /**
> -- 
> 2.53.0-Meta
> 
> 


