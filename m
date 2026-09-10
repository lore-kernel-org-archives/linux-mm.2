Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB572C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF736B0099; Thu, 10 Sep 2026 10:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6DA6B009D; Thu, 10 Sep 2026 10:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC916B009E; Thu, 10 Sep 2026 10:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 804CE6B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:33:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A41FA40389
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:33:09 +0000 (UTC)
X-FDA: 85198094898.07.8F39110
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id F3FFD8000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:33:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GEBarzsa;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzNbcMB0p1eY0jFGMUsfswHJRjfiaKQRPsj4bDo0LJw=;
	b=nnUrOeD1YsxmiZE3BTuK89p5sPRzs3/mYRPW5D0SoQn5h5vKfJHMZ/gO9R2DomTz4Y+POf
	geNPA1W4RrHPxbLBlaJj6VfJgtGQZNobnAk3+zl2ALbl5zMf5p5KPqHwrR8CK+Y+pirpnN
	ZSlhbcgRKdmIZq+MpH2JEtlyf8pow5A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GEBarzsa;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050788;
	b=xermfq/7dyT4RcDSRcUPggxaTxO3iTj0c6YSfobIIALZ02C5YDsrBL3ZmCJSf1dKTEJWRA
	qXCr2Nhxp4TgOAGm6WzYWmm/DVsAlAhnL1ifo9rEKV5xf1peaIQoZKfbfFUE2JXyoOot3H
	lXyY1YlkSKs14B4LbkmLl/e5KhnF5f0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2641E418F6;
	Thu, 10 Sep 2026 14:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5656C1F000FF;
	Thu, 10 Sep 2026 14:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050787;
	bh=mzNbcMB0p1eY0jFGMUsfswHJRjfiaKQRPsj4bDo0LJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GEBarzsaT/GfzNrEw1IDRcdc2Qi0z6RKPkaAX+irMV1fAySbMqtNp/r7WYAtWlxfa
	 l3imiHeM/NxsuPRGU8OkkBuYY1c5w+2J0g4wjwX2QsglvTKjc+S3jJvaZd7CQv8++S
	 3E5z/N6S904KA/e+KOP67vV4XKI/FSODkKMiVx4S5PYKHysvIm6DbONe6+TXkarxZz
	 LTaMtBZ79JK5EJJ4BnVoV3Y1SwXRjtvoyhTrLg3sImW9ITHVpwqjLjHTOj+QuweXrH
	 lgOauZIYiV5A4zwAtlEZEa61OpwegJ6FPItysFxgJXrzzLRYiYqGkSYj/sMlNflbt1
	 Ni9OnEb92Lu1w==
Date: Thu, 10 Sep 2026 15:32:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/12] mm/sparse: remove SECTION_MARKED_PRESENT
Message-ID: <aqK9S1hBpPnujgz9@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-9-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-9-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Stat-Signature: y91iqciefjn9emxubgy1t5khwtfwcdwi
X-Rspamd-Queue-Id: F3FFD8000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789050787-683946
X-HE-Meta: U2FsdGVkX1+CwoTC4rWCHsBwsEGWhT+UxcP3K35vT2uNrgSsRHfaZHpfD64Xougphtma8VsmjEhzcqXHDA/JHyqiyfcxb1x8rA9RnlQyCwomRp8qufcrLAiScK9ZBTr5UHBK+AU5lVwMYNYcJCVZcFGJ+yxZL0HNzlzzWylkxtuwTtBMalogNew/AtcFLnOY7NJbny6QVPCh5H2mUWCrESGZkD8g02JwFJhnIteB1uv5CuCeAiqv/uJ5De+/mocRYunCvAAnOQMUjOQv3yEOM74Gx/ZslAD6b6MKmCoywtXP81eyBU5NRmk5mHQ6QUnYVdMsYSaAaBanCJJBuMaBWjvaaodolotLZIBvx8Uk3bkBRwqkHPcWc1RrSGyeiEip2Q+RtjxhLuOyvQaNn0tBVlOCHAScpeXwmynMPUO6Dnfjz+ILWhKTevxn1jyDG60h5inBWYmlKX1Y36oBbH4Cv3wPHGPF4Tobkn8chuOnSKIUrGTDI3FD7S8XQLJ7L5d4Jmr4h6X+xwNc9dD5IV/NIAIg3dfY/iuiFrs49yjSCjllbg2V3KisAYE8jDm3qbXTbOWyRQyAIneuMwOSK6N9lk7aek1UtGoyN/LySAPjkcl5UnmwvrEE6CEQoA6DB5w6eRLyzcSy2wfYMfSeIoi2AkD+Ec8HGeOXyqAdttjiXo5dv4ogEGno5tyMoSfJZe1/XYiiWrXFDusMohuaWrJXidCQILnDt/rJgGlayU1r0JZAwdvcxtxIjWM9ZzFPl1UM2ATibghpFNEuAma+Lpfte8G8tZVTMsdg1umUedToudrvkhMEEI2fgi2TWnAGEDvVWKTwVQj3oGZhFzopZs+Vm4kO3B1CO72bHH90xEEHIqpi6kibb4+rhgNXM7TZKQvxa5B0YFGNhVg21WpzjRZZkJv/6tLEqq0Ta6QN8dBKiudy5nYzxg5bxHjduMy95OlijuNKUbOQd7rjhdsi3nh
 SeIiNQnE
 FKaxJ9iBqxu/JVx4a59ca9iOA3ckHHlDlMkUb1qn5ArCDFIlsSYq28LDXXNOHC2MWbD1KyDzbTzreqe52O556ahMs4xNJM71jmOfsNCM0DVBaICbKtnhEiMi7ra/1wdCrM6Vs/0vZ4VMWZsBpnbB5EOiy5bHlmN7uzgCzWEOrQFQdwYr24v2+G3BJ+yohg9zHrgbp4Y226aSjWW8opJ89hxZSvxzNFwXpQv+hSywWCm6xmkNdYjH7/BVkScKIdwNACrGk6RSWXEIVgWvaBAove8z4XCQqrCy0xP1SQUvkgz88trHXIOK4lK9eJtXMDKlocJvGCEQPrpqiqqJCc31t5boeOP3EIxqE6EqI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:02PM +0200, David Hildenbrand (Arm) wrote:
> All present section iterators run before memory hotplug added any
> further memory sections, Therefore, we can simply use the SECTION_IS_EARLY
> flag by setting that flag earlier in sparse_prepare_early_sections().

Hmm? sparse_prepare_early_sections() doesn't seem to be a function that exists?

Do you mean sparse_sections_init()?

>
> Get rid of SECTION_MARKED_PRESENT entirely and rename
> for_each_present_section_nr() to for_each_early_section_nr().
>
> Also update the gdb script to use the updated value for
> SECTION_IS_EARLY.

The change seems fine.

>
> No functional change intended.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

With commit msg updated:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

One small question type comment below.

> ---
>  drivers/base/memory.c   |  2 +-
>  include/linux/mmzone.h  | 27 ++++++++++-----------------
>  mm/sparse-vmemmap.c     |  1 -
>  mm/sparse.c             | 17 ++++++++---------
>  mm/sparse.h             |  6 ------
>  scripts/gdb/linux/mm.py |  2 +-
>  6 files changed, 20 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 5eead3346f1e3..b0338de2f1d82 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -972,7 +972,7 @@ void __init memory_dev_init(void)
>  	 * block so that it can be covered.
>  	 */
>  	block_id = ULONG_MAX;
> -	for_each_present_section_nr(0, nr) {
> +	for_each_early_section_nr(0, nr) {
>  		if (block_id != ULONG_MAX && memory_block_id(nr) == block_id)
>  			continue;
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index e0fac344f6ac2..62cff59dd80c4 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2084,7 +2084,6 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
>   * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
>   */
>  enum {
> -	SECTION_MARKED_PRESENT_BIT,
>  	SECTION_HAS_MEM_MAP_BIT,
>  	SECTION_IS_ONLINE_BIT,
>  	SECTION_IS_EARLY_BIT,
> @@ -2094,7 +2093,6 @@ enum {
>  	SECTION_MAP_LAST_BIT,
>  };
>
> -#define SECTION_MARKED_PRESENT		BIT(SECTION_MARKED_PRESENT_BIT)
>  #define SECTION_HAS_MEM_MAP		BIT(SECTION_HAS_MEM_MAP_BIT)
>  #define SECTION_IS_ONLINE		BIT(SECTION_IS_ONLINE_BIT)
>  #define SECTION_IS_EARLY		BIT(SECTION_IS_EARLY_BIT)
> @@ -2111,16 +2109,6 @@ static inline struct page *__section_mem_map_addr(struct mem_section *section)
>  	return (struct page *)map;
>  }
>
> -static inline int present_section(const struct mem_section *section)
> -{
> -	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
> -}
> -
> -static inline int present_section_nr(unsigned long nr)
> -{
> -	return present_section(__nr_to_section(nr));
> -}
> -
>  static inline int valid_section(const struct mem_section *section)
>  {
>  	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
> @@ -2136,6 +2124,11 @@ static inline int valid_section_nr(unsigned long nr)
>  	return valid_section(__nr_to_section(nr));
>  }
>
> +static inline int early_section_nr(unsigned long nr)
> +{
> +	return early_section(__nr_to_section(nr));
> +}
> +
>  static inline int online_section(const struct mem_section *section)
>  {
>  	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
> @@ -2315,20 +2308,20 @@ static inline unsigned long next_valid_pfn(unsigned long pfn, unsigned long end_
>
>  #endif
>
> -static inline unsigned long next_present_section_nr(unsigned long section_nr)
> +static inline unsigned long next_early_section_nr(unsigned long section_nr)
>  {
>  	while (++section_nr <= __highest_used_section_nr) {
> -		if (present_section_nr(section_nr))
> +		if (early_section_nr(section_nr))
>  			return section_nr;
>  	}
>
>  	return -1;
>  }
>
> -#define for_each_present_section_nr(start, section_nr)		\
> -	for (section_nr = next_present_section_nr(start - 1);	\
> +#define for_each_early_section_nr(start, section_nr)		\
> +	for (section_nr = next_early_section_nr(start - 1);	\
>  	     section_nr != -1;					\
> -	     section_nr = next_present_section_nr(section_nr))
> +	     section_nr = next_early_section_nr(section_nr))
>
>  /*
>   * These are _only_ used during initialisation, therefore they
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index e62e6aa07f126..5aba058df6b67 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -890,7 +890,6 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>  	page_init_poison(memmap, sizeof(struct page) * nr_pages);
>
>  	ms = __nr_to_section(section_nr);
> -	__section_mark_present(ms, section_nr);
>
>  	/* Align memmap to section boundary in the subsection case */
>  	if (section_nr_to_pfn(section_nr) != start_pfn)
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 2d0f2db34f4cf..344acaaed94db 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -170,13 +170,14 @@ static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
>   */
>  unsigned long __highest_used_section_nr;
>
> -static inline unsigned long first_present_section_nr(void)
> +static inline unsigned long first_early_section_nr(void)
>  {
> -	return next_present_section_nr(-1);
> +	return next_early_section_nr(-1);
>  }
>
>  void __init sparse_sections_init(void)
>  {
> +	const unsigned long flags = SECTION_IS_EARLY | SECTION_IS_ONLINE;
>  	unsigned long pfn, start_pfn, end_pfn, section_nr;
>  	int i, nid;
>
> @@ -196,9 +197,7 @@ void __init sparse_sections_init(void)
>  				continue;
>
>  			set_section_nid(section_nr, nid);
> -			ms->section_mem_map = sparse_encode_early_nid(nid) |
> -							SECTION_IS_ONLINE;
> -			__section_mark_present(ms, section_nr);
> +			ms->section_mem_map = sparse_encode_early_nid(nid) | flags;
>  		}
>  	}
>  	__highest_used_section_nr = section_nr;
> @@ -231,7 +230,7 @@ static void __init sparse_metadata_init_nid(int nid,
>  	if (!usage)
>  		panic("Failed to allocate usemap for node %d\n", nid);
>
> -	for_each_present_section_nr(start_section_nr, section_nr) {
> +	for_each_early_section_nr(start_section_nr, section_nr) {
>  		unsigned long pfn = section_nr_to_pfn(section_nr);
>  		struct page *mem_map;
>
> @@ -246,18 +245,18 @@ static void __init sparse_metadata_init_nid(int nid,
>  		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
>  							       NULL, NULL));
>  		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
> -					mem_map, usage, SECTION_IS_EARLY);
> +					mem_map, usage, 0);
>  		usage = (void *)usage + mem_section_usage_size();
>  	}
>  }
>
>  static void __init sparse_metadata_init(void)
>  {
> -	unsigned long start_section_nr = first_present_section_nr();
> +	unsigned long start_section_nr = first_early_section_nr();
>  	int nid_begin = sparse_early_nid(__nr_to_section(start_section_nr));
>  	unsigned long section_nr, nr_sections = 1;
>
> -	for_each_present_section_nr(start_section_nr + 1, section_nr) {
> +	for_each_early_section_nr(start_section_nr + 1, section_nr) {
>  		const int nid = sparse_early_nid(__nr_to_section(section_nr));
>
>  		if (nid == nid_begin) {
> diff --git a/mm/sparse.h b/mm/sparse.h
> index a3af4967fd5c5..03351f2467e34 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -114,12 +114,6 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  	ms->usage = usage;
>  }
>
> -static inline void __section_mark_present(struct mem_section *ms,
> -		unsigned long section_nr)
> -{
> -	ms->section_mem_map |= SECTION_MARKED_PRESENT;
> -}
> -
>  static inline size_t mem_section_usage_size(void)
>  {
>  	return struct_size_t(struct mem_section_usage, pageblock_flags,
> diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
> index 193a88d763abf..73d637d28c8e6 100644
> --- a/scripts/gdb/linux/mm.py
> +++ b/scripts/gdb/linux/mm.py
> @@ -76,7 +76,7 @@ class x86_page_ops():
>              self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
>          except:
>              self.SECTION_HAS_MEM_MAP = 1 << 0
> -            self.SECTION_IS_EARLY = 1 << 3
> +            self.SECTION_IS_EARLY = 1 << 2

Seems a bit strage given the code is:

        try:
            self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
            self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
        except:
            self.SECTION_HAS_MEM_MAP = 1 << 0
            self.SECTION_IS_EARLY = 1 << 2

Whereas other variables must be available with no try, e.g.:

        self.PAGE_OFFSET = int(gdb.parse_and_eval("page_offset_base"))
        self.VMEMMAP_START = int(gdb.parse_and_eval("vmemmap_base"))
        self.PHYS_BASE = int(gdb.parse_and_eval("(unsigned long) phys_base"))

etc.

Is there some weirdness with gdb? Or is it maybe because there are some configs
without these symbols maybe?

>
>          self.SUBSECTION_SHIFT = 21
>          self.PAGES_PER_SUBSECTION = 1 << (self.SUBSECTION_SHIFT - self.PAGE_SHIFT)
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

