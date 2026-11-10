Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9635560A260D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=H09R9nUh
Received: by kanga.kvack.org (Postfix)
	id B71116B05C2; Tue, 10 Nov 2026 16:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB376B05C7; Tue, 10 Nov 2026 16:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2A46B05C8; Tue, 10 Nov 2026 16:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0F56B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:09:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61A6CC0124
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:09:55 +0000 (UTC)
X-FDA: 85420451550.19.4AB00C8
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2285720008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:09:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H09R9nUh;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cECixYNr0OovLH4QYoKXkxOvB4WVLsH4r6Oh+9diE0=;
	b=utM3v4VQIsYYBAWwVFY73d/FlrTNQhpvwVj44ryV+Uw540GH/cV5PMvVUi8Xba2jTYJMsr
	CCR64m03GX66/Hg4+VDx+ew0+kpWJZV2vXjEHlZn8xxjgHWccg7JE25a8e9VmAg7BGzgyo
	vx+uoI7KQxBRtcd0AugSAQnv/gmy6AI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344993;
	b=7Fawif/Xx+ArScua8ujpaEKvb8Xe2+Qxr7MC6IDLo6hhiF8qoi4q/a4uG0hNljnPuowL7S
	IjYDEy5zjxfExCZMQMahotN3j35Y+zc7Ut27oW5Jw573tcRk1VQJxne4PxhCKav7PhCm57
	x6cVzVu17TpRMnXmGfHH0jnJIHRnmN0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H09R9nUh;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-49318428d98so1361995f8f.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794344991; x=1794949791; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7cECixYNr0OovLH4QYoKXkxOvB4WVLsH4r6Oh+9diE0=;
        b=H09R9nUhuXaNdXr9W90rKPu7P0rlDKBRNdoXFaFU4+O0flkZr7789Zz7UvHM0shhwA
         BoZYXcw/Rwq58WXkaDanMQnjkvMISPUzwXzMHubRykTHY7UCU6GNtRBgp9L8StblcUWL
         ua88rdMnuv2gPi1jAS5qcWNZtFs1hIXUzsIUnvQz5DTgGaNIjLacGYVJliGBU9HZzQ4s
         eXo8jtXFcNOovsQdB2WD6iUsc/+1e+ZDLKLSpm77mmINQgdeEuggLEvmhnA4wWl5gdqM
         oyS9lac8Pn3ubHP3Nqpx76taXPQHyeycfxelzMyWH1BrY7eDWiYzbJCAqa31CjtH973U
         D0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794344991; x=1794949791;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7cECixYNr0OovLH4QYoKXkxOvB4WVLsH4r6Oh+9diE0=;
        b=uNNzIR5233llfKWLmxbvRie2pbKCtScBmSX69a5aQIMfeQzRX60zu29WJd41IH45eS
         VqbDWN50gGgvy/JfcpO7Cn8qqnoO3HkRfcmFfaDETREO0xXayJJ5ADauY2wnYBArNKJx
         ZRaut+d39PvfjmanimexHFfYN8jLWNVuBAzrwKLqSiKu7WTHFr68tfVePUYBrcexVDA2
         h9OZ+H18vU+oNDEDKkLQ6TFd0qAcIJdht6QsQbMHKBSYBDS+El6bGZR6nbyjm9SNKudH
         Afx6dtf0cjKYZtZaZpy3C94sUczCvmh/JBjznpxNzvy+HdRGJZcao1ZoeBsFfq/WwD4h
         zaww==
X-Forwarded-Encrypted: i=1; AL+hErFhBc8OqLjWCK9npHrNbAzbLoGq8IQ0pxEYR3ssabQpmz3gVihBuXkiTxQSMpx2YKsGMZxxjm7yqQ==@kvack.org
X-Gm-Message-State: APuU4Z+XUsKzjwsaMbQh9CWRc25AlQyHapWny7hatNKGawc0FHgmCp1P
	ADxdPdzmN7ACdjwaqNZgTRerwIlz9yiseS+I2rMv37gBZL6+8sZGyBoUxTUPKwWhipA=
X-Gm-Gg: AYBFou3+OhOIWHzcq3UvMrnswik9LEl/auLDZdCFVYRPLoMHKMBVttYz5kQLSnyfqd6
	d+f6URb+xAHxs+6XlXHRlmcFjUkgBuxm2YrNKU5DPl4UCw4Qdq1NW6qPS4hk3K2cXWLuITyyez0
	PtAF6wbH25L8xdkxLXdrfHvsTaAdoHrNGJ1CC8zTL/598IgUKr8V4kPX6nPSmOOLUzaIQtSEEFa
	OHot+wLLuw6rNdwZ4oOmqBESIWjzNQV0cqj5sD3ZyMyMS77BuGbn/Ql2nTmbYi+W1M27MzFoHzs
	LmiXdv2TPhUevb6mpRkBtby586f9m75uv5YynZdGqOPx3HaRcLhWrgri3W8SwWL5QY4m1ZfzgH9
	JZHs0m788/RROwR7DZzn6ecEnOZ6MEATmlkRM5JyzB+Hi9i8eADYDFHREx6lrfX4kkg5XVQ5HKD
	m5tnC4CJn2MXZ1GpDPyxDbdoXR6fwQqSxvP68Vt22NfHMkOh8XvlMkFAUtbGKAXM2k6Pj552qMj
	lf7BuQrkwP9mxMHge8ar7MuRsWEBxf8kvQofUl05F6tMeKwVYWrVbnOUeIVEiytLlyCG6jh8rtR
	EGXHf8ToMfZ7xR1d7WjrtoG8p0gV7OMm4C9TRNIzqpk=
X-Received: by 2002:a05:6000:3103:b0:493:e0db:b520 with SMTP id ffacd0b85a97d-499c38baf87mr327184f8f.8.1794344991489;
        Tue, 10 Nov 2026 13:09:51 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4984e26f8e3sm6223895f8f.1.2026.11.10.13.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 13:09:51 -0800 (PST)
Date: Tue, 10 Nov 2026 22:09:49 +0100
From: Michal Hocko <mhocko@suse.com>
To: Fang Xieyan <fangxy@xiaopeng.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>, Carlos Maiolino <cem@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Liu Chao <liuc63@xiaopeng.com>
Subject: Re: [RFC PATCH 3/3] mm: enable filesystem page-cache large folios
 without THP
Message-ID: <avOIHeOpjryn5DVd@tiehlicka>
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
 <20261110035205.3036-4-fangxy@xiaopeng.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110035205.3036-4-fangxy@xiaopeng.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 5t1iekiwz3qjwwutjybhdtkp7fo4m1jx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2285720008
X-Rspam-User: 
X-HE-Tag: 1794344992-674066
X-HE-Meta: U2FsdGVkX1+EhRLqDRJlnHQ8cXc5UXKaUmBl+8iDiGrtQ90qHQYEmXYtrampfmBRQ0N+SRSD09cLFEiWnLbTkmyhbROrbGI71p+jfZUt7HTBFy8h8AK6VL3JAQbvJtwzBF4+TjNKEv+Gw/I1Gx2yDuW9Fi6XWUdud3ebFUNWvhQsHSS+5p1K7BgwkltOYVEUngYDJ9l3xg2EWQI7klQZg2D23xkDxpGfnZAIunq90fd80R/R40vL0RxRalSAdL57DTu9WG+eUWQ6KEJGHNtb0JLdIBeIfs+qrSsvhQnGIfkpRkLoLRyBwLWwiXj26dCP6iaEwdtPLi1wukFst8eL3rsVf4abctIgmUQJ8yiNH9Ul3qm49ZQBUA+vWFoyIiek3W6QKlBCJtL9qcBz8uUR1fd44RmYLrUF9sXAqP/hVL+FAlbulGq9BhudGAyO2Es/d5cufRQHFBA3sLq3+6f7iYpIpDl1jTv+6UbC+sk694uG5VEWZzrrmA0+hJwIrDW1RDK/81RSP9NHz8RsiyGEViANAwNqo8dcp62vgi7hXpY5Fa3+2Z8rFWrewTHGbAzLnUyQBkng8rPtGCxN8LOsPGpx7C4tl4z1bC5iuQRIKJCogrS+pnvMYmOZqOOSbqR9zBhq0VwPmh0XN4zC8IECN4ys+7nzPrYV78BEzxxs0X3NZ9LUmXuR8v5bKag8KTng24SmB1jwYklXRp4ktRmNXa14BL8JM0dMlrC9b/N9t1JEoSeYV//XNFvqqMjY+8aAokDC1DQepeENKiRt0uQEE5zFoj8VHWkbetItTBWC0Vjcu7OD4ipVn9YpTIErTZdssVtIV7X61GLXtqHkGZDC0c/RrB9YrIdYyCXYDPKg38KAbsVsNJw2BeOyqhKNWX2jGkOk95uO2A4V7evOd+/reMkJHlgOD51Jg8Vochu+AB+v8gTA6sPhOXSJG4V13wppyq1GefeUlG7J+BlTBVF
 m6Cgpm0h
 xQdXp6DCsPJTFf4nDNVZop4gFBsKkpp+JCZZdGRcTnqdRmxqGZ6xO421pHZWSHECxYvTqOpdSIXPp3yyq6tNLtQqv0sRkudrgdUVpL195eVYazWRXi4r5TMmEq8cjY7Nq41Hj3d2pEQgtFLlNWGHzdmXRV2p8g3O2xSNmw9BVZIiBllj9CmzCD7MIA20iYONV+hYLkb0DkkKBhGmq+2rMjOvkD+W8CUK7PQtYb12rSSmutj6n0NvJdGVK66Bksaf7Ylq7I6+fvSPoPP72ock/LA024ZbYiWQN4RDoxLbzSZ6/wdCQ5dSNricHDCZA3nvAVo3672DQqdsUWYz1W0M4hsbaIp3SFN2Xnwlnn1DPodxATtuj5RX42PvWVGVdtnoDWlhqYvETjGuDwUlbjxwzrkOV8sG3/TtWsIS2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 11:52:05, Fang Xieyan wrote:
> Ten filesystems already opt in to file-backed large folios by calling
> mapping_set_large_folios() or mapping_set_folio_order_range() from their
> inode setup, unconditionally.  Every accessor that reports those orders
> is nevertheless compiled out when CONFIG_TRANSPARENT_HUGEPAGE is
> disabled, so the opt-in silently has no effect today.

The reason for disabling THP on RT configs (as introduced by
554b0f3ca6f4) was:
:  There are potential non-deterministic delays to an RT thread if a
:  critical memory region is not THP-aligned and a non-RT buffer is
:  located in the same hugepage-aligned region. It's also possible for an
:  unrelated thread to migrate pages belonging to an RT task incurring
:  unexpected page faults due to memory defragmentation even if
:  khugepaged is disabled.

How is the same prevented for the page cache? If the reasoning above is
not generally applicable then would it make more sense to make the
conflict less strict?
 
> Gate the page cache order accessors on CONFIG_LARGE_FOLIO in addition to
> CONFIG_TRANSPARENT_HUGEPAGE.  Both conditions are still spelled out even
> though CONFIG_LARGE_FOLIO defaults to y when TRANSPARENT_HUGEPAGE is
> enabled, so that file-backed large folios do not silently disappear if
> that default is ever relaxed.
> 
> PREFERRED_MAX_PAGECACHE_ORDER is left as it is.  Deriving it from
> CONFIG_PGTABLE_HAS_HUGE_LEAVES would let HUGETLB_PAGE raise the ceiling
> on its own, to HPAGE_PMD_ORDER capped by MAX_XAS_ORDER.  On arm64 with
> 64K base pages that works out to order 11, a 128M folio, eight times
> what an LF-only build advertises today; the figure is arithmetic, not a
> measurement.  Without THP such folios cannot be PMD-mapped, so keeping
> the existing order-8 limit avoids substantially increasing the maximum
> page-cache allocation size without an established use case.
> 
> CONFIG_LARGE_FOLIO no longer only builds the split machinery, so its
> Kconfig help text is updated to match.  The default also carries a
> comment recording why THP must keep pulling this option in:
> mm/folio_split.o is built from CONFIG_LARGE_FOLIO, while huge_memory.o,
> built for THP, calls into it.  XFS also gates mounting
> block sizes larger than the page size on
> mapping_max_folio_size_supported(), which means large-block-size XFS
> cannot be mounted at all when CONFIG_LARGE_FOLIO is disabled; the
> rejection now points at the missing option instead of only reporting the
> block size as unsupported.
> 
> shmem keeps its THP dependency.  shmem_alloc_and_add_folio() forces
> orders to zero without THP, so the mapping is only opened large-folio
> capable when CONFIG_TRANSPARENT_HUGEPAGE is enabled.  Advertising the
> larger order while allocating order 0 would not be cosmetic:
> generic_perform_write() sizes its write chunk from
> mapping_max_folio_size() and passes that length to ->write_begin()
> before clamping it to folio_size(), while shmem_write_begin() rejects
> pos + len > i_size outright for F_SEAL_GROW.  A cross-EOF write would
> then fail as a whole instead of being partially satisfied up to i_size.
> THP=y kernels already behave that way; the point is not to spread that
> behaviour to a configuration which gains no large folios from it.
> Enabling shmem's large folios -- allocation, swap and split alike -- is
> left to a separate series.
> 
> The stale comment on mapping_large_folio_support() is updated to match:
> large folios are now gated on CONFIG_LARGE_FOLIO rather than on THP, and
> CONFIG_LARGE_FOLIO is a default rather than a select from THP.
> 
> With CONFIG_TRANSPARENT_HUGEPAGE enabled the generated code is unchanged.
> Without it, file-backed large folios become reachable for the first time.
> 
> Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
> Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
> ---
>  fs/xfs/xfs_super.c      |  2 ++
>  include/linux/pagemap.h | 17 +++++++++++------
>  mm/Kconfig              | 15 +++++++++++----
>  mm/shmem.c              | 11 ++++++++++-
>  4 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5a06132aa..29548faec 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1864,6 +1864,8 @@ xfs_fs_fill_super(
>  			xfs_warn(mp,
>  "block size (%u bytes) not supported; Only block size (%zu) or less is supported",
>  				mp->m_sb.sb_blocksize, max_folio_size);
> +			if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
> +				xfs_warn(mp, "CONFIG_LARGE_FOLIO is not set");
>  			error = -ENOSYS;
>  			goto out_free_sb;
>  		}
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 73af18a37..2102733c1 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -393,7 +393,8 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
>   */
>  static inline size_t mapping_max_folio_size_supported(void)
>  {
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
> +	    IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
>  	return PAGE_SIZE;
>  }
> @@ -418,7 +419,8 @@ static inline void mapping_set_folio_order_range(struct address_space *mapping,
>  						 unsigned int min,
>  						 unsigned int max)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return;
>  
>  	if (min > MAX_PAGECACHE_ORDER)
> @@ -459,7 +461,8 @@ static inline void mapping_set_large_folios(struct address_space *mapping)
>  static inline unsigned int
>  mapping_max_folio_order(const struct address_space *mapping)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 0;
>  	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
>  }
> @@ -467,7 +470,8 @@ mapping_max_folio_order(const struct address_space *mapping)
>  static inline unsigned int
>  mapping_min_folio_order(const struct address_space *mapping)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
>  		return 0;
>  	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
>  }
> @@ -500,8 +504,9 @@ static inline pgoff_t mapping_align_index(const struct address_space *mapping,
>  }
>  
>  /*
> - * Large folio support currently depends on THP.  These dependencies are
> - * being worked on but are not yet fixed.
> + * Large folio support is opt-in per mapping and requires CONFIG_LARGE_FOLIO.
> + * It does not depend on THP; CONFIG_LARGE_FOLIO defaults to y when
> + * CONFIG_TRANSPARENT_HUGEPAGE is enabled.
>   */
>  static inline bool mapping_large_folio_support(const struct address_space *mapping)
>  {
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9f97ad698..7bbed71af 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -831,13 +831,20 @@ config LARGE_FOLIO
>  	bool "Large folio support for the page cache (without THP)" if !TRANSPARENT_HUGEPAGE
>  	depends on MMU
>  	select XARRAY_MULTI
> +	# Keep LARGE_FOLIO enabled whenever THP is enabled:
> +	# huge_memory.o is built for TRANSPARENT_HUGEPAGE and calls into
> +	# folio_split.o, which is built for LARGE_FOLIO.
>  	default y if TRANSPARENT_HUGEPAGE
>  	default n
>  	help
> -	  Build the folio split implementation for page-cache large folios
> -	  even when transparent hugepages are disabled.  Transparent
> -	  hugepages imply this option; this option alone does not enable
> -	  large folio allocation, it only makes splitting them possible.
> +	  Enable page-cache large folios even when transparent hugepages
> +	  are disabled.  This option defaults to y when transparent
> +	  hugepages are enabled.
> +
> +	  With this option enabled, filesystems that opt in per mapping get
> +	  large folios in the page cache, and those folios can be split.
> +	  Without it, page-cache folios stay order-0 even when a filesystem
> +	  asks for a larger order.
>  
>  menuconfig TRANSPARENT_HUGEPAGE
>  	bool "Transparent Hugepage Support"
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4686875a3..399c8c9f1 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3327,7 +3327,16 @@ static struct inode *__shmem_get_inode(const struct mnt_idmap *idmap,
>  	cache_no_acl(inode);
>  	if (sbinfo->noswap)
>  		mapping_set_unevictable(inode->i_mapping);
> -	mapping_set_large_folios(inode->i_mapping);
> +	/*
> +	 * shmem large folios currently depend on THP:
> +	 * shmem_alloc_and_add_folio() forces order 0 without it, and
> +	 * advertising a larger mapping size makes
> +	 * generic_perform_write() pass a length that shmem_write_begin()
> +	 * rejects wholesale for F_SEAL_GROW before the folio size is
> +	 * known.
> +	 */
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		mapping_set_large_folios(inode->i_mapping);
>  
>  	switch (mode & S_IFMT) {
>  	default:
> -- 
> 2.50.1

-- 
Michal Hocko
SUSE Labs

