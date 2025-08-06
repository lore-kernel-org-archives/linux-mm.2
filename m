Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB07FC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB566B0092; Wed,  6 Aug 2025 12:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3CD6B0095; Wed,  6 Aug 2025 12:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0BB6B0096; Wed,  6 Aug 2025 12:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 516DC6B0092
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:32:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 297B91A067D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:32:30 +0000 (UTC)
X-FDA: 83746875660.09.1C549D6
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id F2167A0004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:32:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=diDmTLlj;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754497948; a=rsa-sha256;
	cv=none;
	b=lc6iMc+p8lG4XpZ5XefiUPxMoKfgRrRkYmhIRJrDvENA2TfRWpEc4Na+MBQckGZ4/o1yaN
	86/moqPBgsjyWrCWmxIDthLE4XfImEOFdEV1CIpCSXI4fTkuusgHxsq0CQXNKoqbMEyl9G
	Rdfnzexr9zpkWDwbpZHn26nrvr6e8+Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=diDmTLlj;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754497948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DczkdOzRVH8sA2mnIf+wryGp+DfW+r4oiu5gHq5d+os=;
	b=czMyl9LHIaEBENdcjqoYwHGS05lcj5xxyHDYjoxzoWULvUJH6sEgz4GrA8m6wcdIujoszx
	meaj2Sckrbgwl2sVwRFKOscEZ/CgRI4gNe7+gDvoMXW3hZgfqYiq6l2iBJtTD9qBcmzOEF
	YVlbKx7qgbvzuEwoa4g9YshvJ3eC5eI=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b064e94400so1315891cf.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1754497947; x=1755102747; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DczkdOzRVH8sA2mnIf+wryGp+DfW+r4oiu5gHq5d+os=;
        b=diDmTLljNAVPdOwQd6bT4+tg+WB4lnQ83Drgnxrr769+MmrnBzjW6yiYmW8/XFPTeS
         sWg8W3MJE44r9UOoxqIuk9lFjjZ9jRlq6YXRfg5zRrxAZHnmL/CUtHIRhGSPJcj2NjSf
         XLZmC+YT5Gg9iT5fOILCZioPOjgtivE2BeFJ3/IdbLMkCfVSi6tCW7vDDWpiSoutZAGl
         1bCLLSVanJRlT051/vPKIuqTF+rh2gYeJIP8I0SM0EhzHfnRnTI+Hv0nUXHMzMzaZERc
         jNaIWnSSMlKKTdSQ87TmSbzWv8r06VcKjj5i+95EKuJ77aJrd6XOq953a1XRlJv/FiCq
         OmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754497947; x=1755102747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DczkdOzRVH8sA2mnIf+wryGp+DfW+r4oiu5gHq5d+os=;
        b=p+UtoG7keuE5IVW8RuH8Dr9o95STBZIzQcaxwjKPJcN86PlpRi3/ICetpzVeL+mTB3
         olwk4tOxly+pyV972F8ARuQDINkjRgj3B44vob2NiyLWB0GFGF0OcBcF+LDwiZHEEyCt
         eesO2/ZLQO/GPtPW1OU0ahDVUaIrBxDaVGEBItv36lXUz1zort2YFDh2iHU+YwcSPKgq
         BZ95cZmbSD/xZVjBBNxtZ/wlahupPUY02KVV9s3VuJlQZacu+N+KZoQ1FSfI24ZLN5Zd
         zX6qZtWR/DyrU7RM4E5gQL0wUOXUgleoJ4T5tmSLdlZUQEJfJ8yUg2279XY24Ur0t1Js
         Hn/w==
X-Forwarded-Encrypted: i=1; AJvYcCVs3K3tKuNZBru6eemnoMODX1+kgJQn5lI1ae1/nuYjVLftIqgVuL62AIro13i2yFy9VCfOoR35kw==@kvack.org
X-Gm-Message-State: AOJu0Yzq2bvFSn1LdzMGHLax6bk8IJUqQGYmco/i2+vdOFL9nfdcDQ2B
	kavjtAXrLvzgFWJR5p5jJYBP/CZ2bvWfqMLMKC8So//kd6ux1wguFwmJEMqvFqbRWSo=
X-Gm-Gg: ASbGncsXWFqFxq9SerlLmcDfPP/I6GvVP4US3ZKOmojS5GCyw2KbR8CoBx0tAs+BKOi
	kzhRurJTSytczIwuGPlqxun2YjY6gYGbpJOXntMlp96bkKch7BAoi6d+HDuwIZD93Qe5L3YONb/
	OTw0h/XqHhIkTHsYamkm7SFrOsHpi7AUSG7DdtkYxfUp/YjJbcVylO/hXsIcunxshxbSiBR95Sh
	6C31B9W1ux6I+p7XmORKWOoXxzsxNt/oLmP7vyhZZhVsxElLz01QdnbJ4ezoPClmf6zC46qYOw7
	uvqGIyMr4kefKkqZJ7FaAQFUrMEcYodTQS5ZGPUjqnMhcDRMFWIEm8gnglntm5aY8ZdtmQUR3ed
	lgJ+ghI34wvZJfiLGFpSTB/RhGVFD4St3
X-Google-Smtp-Source: AGHT+IHC3hrESSBrcMoIOYxPNKtmK7006X0ZFbjOG06E52Szyt/nP4BqvqO0+YzYU4f3W7ZcXwwE4A==
X-Received: by 2002:a05:622a:1cca:b0:4af:1fb2:339c with SMTP id d75a77b69052e-4b091534932mr66831011cf.29.1754497945572;
        Wed, 06 Aug 2025 09:32:25 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4b09a2e6095sm5411891cf.33.2025.08.06.09.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 09:32:24 -0700 (PDT)
Date: Wed, 6 Aug 2025 12:32:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed
 page as-is
Message-ID: <20250806163221.GA1795303@cmpxchg.org>
References: <20250805002954.1496-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805002954.1496-1-sj@kernel.org>
X-Stat-Signature: aq71pf4sbaoebi4e119btceee8qc9ce8
X-Rspam-User: 
X-Rspamd-Queue-Id: F2167A0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754497947-934163
X-HE-Meta: U2FsdGVkX19jGjD9pfiR2sMhoC5FcMMn99as3DBJn3OSwg5LJU6+NMxqhcpb3yxAZrNa3zViV3qt//567+UEjaJCQW4ORR3nQgnT5ZRsZpYrLW/4OQq/eGQr0tm2ZYfA+8wJQClVAi7TgooiCy4ufaMsEbOZ6rhhNqMqmDwXfGgUx+1iY1BMRDjQgLfUNvUKPtD5n0j6z7ZD7tjnFwJHD3Il3Dubj8SnGlO6GxtlyHuWT5Y/mOzS95YQ8KZwJdr82o7I7gPY2s2/vUBdLpjynBTE5wfq4QX91Cv0KI8wG4pPqGQ+NCRMZiC6q8YMDp/b6snRhYTH81/c0CfRDBTQ9jRuw7dC04R0CzbBSRB6aLuNXfn3WVO16PFLI8e1hpJ8acdWuS9+vo8ZEq469qbNH1b6uymMEDV9+jILzvfAM01aQNy903P7K00cvN7J1gA73c0Bakd1YdW0cAy+YwFwr1sAnP7J3rvor0nfreJg5UVedr/Va5+qJiibZC4XEAlCKa2zabic0eubzcOJUnOtqbvuPNtV7QShcOaxe5m1zT5hICQU/EI7OwH85Q0WcSNNxdb/F+VY+dDYUF9q/2Htut40z8bflU8/5l5kpLyTSGQQxg5BsqFSlzrlKCHsAFU28PZ29bYAOm9IKABVMekFJszihynJxNLCOwC4eBTUoUO5t6nafvliUEiu/Vuo7NrlJbI822H3Y7W8KOG/PdVAinQbi3hs62qnZsdpBjd0xpNOl/VG1n9iPjZeLkDnKpZEkBKM+yFWQ5Sunupit1I/X4IF0EXOB3qNP8CFlW1tc6YQ8esawJ69LtAYgqXyYcj63MuEbsOw92OfnjlCdEhuO+UnJi6tMFLcsMOmDm/NJRX9sGZFOGB8trD01XrkknmQJuCLKXyA1d9Xg0aIQ/nCS4b9bRU75jtaIzoAH6phJ/T40npoGXI8u4QhbEv4G50jB7yV9owba4+hhKNJ9HM
 ScY0F6NC
 2CygoBHV5/8r//T8ONcEdekAeWgTedMEJNARQkXxi/TlhilkFhbDrA3FAPbOxeA9uoSdSJ8omhwDPi8OpApHK1QYVuKGUMNpK7EwPUIdmBQnJ6Q3YlBxmA26s/5KI/BOj5UsvQHfMJDPnIrYqV4gteaqSaUFebn39wqA/oBIcngXCxraZVuhBDXjLb30xpqUFzr9gtMstLSP43O4tiJOp3ego9GkC4eCJUupqIYeB/B1gDEx5v0F+gtfuiUTgVHSRuypspFqPlU15grVpaFsI5+oPcEt/BF+m8m/zdsvj9WaM2Y8xImN/Hm+kM4ho7e8mVGQ8np3NLxawKr5hfvGsZAEzrsRDJsC8KCo2mzXL9PczCpQiT8T5T5HnROnGGDyunIiC2Hp3OXiD2m2Eq4NP0Clz44AB69CbSg6PiXgoYxUfhKYHhXjqcClWrgYwSXjvSwEm/sQtmssqyeqq0V5dpTy49s6ijtgXKDuaVdYhoTGyptAWOacLF1/ozdUwdhSkpOSChmwvR2A7Ls49tSY0lFuGrPpT7VABV5ZcjT+rUgk7QfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Overall this looks good to me. On top of the feedback provided by
others, I have a few comments below.

On Mon, Aug 04, 2025 at 05:29:54PM -0700, SeongJae Park wrote:
> @@ -142,6 +142,15 @@ User can enable it as follows::
>  This can be enabled at the boot time if ``CONFIG_ZSWAP_SHRINKER_DEFAULT_ON`` is
>  selected.
>  
> +If a page cannot be compressed into a size smaller than PAGE_SIZE, it can be
> +beneficial to save the content as is without compression, to keep the LRU
> +order.  Users can enable this behavior, as follows::
> +
> +  echo Y > /sys/module/zswap/parameters/save_incompressible_pages
> +
> +This is disabled by default, and doesn't change behavior of zswap writeback
> +disabled case.
> +
>  A debugfs interface is provided for various statistic about pool size, number
>  of pages stored, same-value filled pages and various counters for the reasons
>  pages are rejected.
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 7e02c760955f..6e196c9a4dba 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -129,6 +129,11 @@ static bool zswap_shrinker_enabled = IS_ENABLED(
>  		CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
>  module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644);
>  
> +/* Enable/disable incompressible pages storing */
> +static bool zswap_save_incompressible_pages;
> +module_param_named(save_incompressible_pages, zswap_save_incompressible_pages,
> +		bool, 0644);

Please remove the knob and just make it the default behavior.

With writeback enabled, the current behavior is quite weird:
compressible pages to into zswap, then get written to swap in LRU
order. Incompressible pages get sent to swap directly. This is an
obvious age inversion, and the performance problems this has caused
was a motivating factor for the ability to disable writeback.

I don't think there is much point in keeping that as an officially
supported mode.

> @@ -937,6 +942,29 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
>  	mutex_unlock(&acomp_ctx->mutex);
>  }
>  
> +/*
> + * Determine whether to save given page as-is.
> + *
> + * If a page cannot be compressed into a size smaller than PAGE_SIZE, it can be
> + * beneficial to saving the content as is without compression, to keep the LRU
> + * order.  This can increase memory overhead from metadata, but in common zswap
> + * use cases where there are sufficient amount of compressible pages, the
> + * overhead should be not critical, and can be mitigated by the writeback.
> + * Also, the decompression overhead is optimized.
> + *
> + * When the writeback is disabled, however, the additional overhead could be
> + * problematic.  For the case, just return the failure.  swap_writeout() will
> + * put the page back to the active LRU list in the case.
> + */
> +static bool zswap_save_as_is(int comp_ret, unsigned int dlen,
> +		struct page *page)
> +{
> +	return zswap_save_incompressible_pages &&
> +			(comp_ret || dlen == PAGE_SIZE) &&
> +			mem_cgroup_zswap_writeback_enabled(
> +					folio_memcg(page_folio(page)));
> +}
> +
>  static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  			   struct zswap_pool *pool)
>  {

> @@ -1001,6 +1034,17 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	return comp_ret == 0 && alloc_ret == 0;
>  }
>  
> +/*
> + * If save_incompressible_pages is set and writeback is enabled, incompressible
> + * pages are saved as is without compression.  For more details, refer to the
> + * comments of zswap_save_as_is().
> + */
> +static bool zswap_saved_as_is(struct zswap_entry *entry, struct folio *folio)
> +{
> +	return entry->length == PAGE_SIZE && zswap_save_incompressible_pages &&
> +		mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
> +}

I don't think there will be much left of these helpers once you
incorporate Nhat's feedback, but please open-code these in either
case. They're single user, hide what's going on, and the similar names
doesn't do them any favors.

