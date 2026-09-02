Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83837C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0AB6B00ED; Wed,  2 Sep 2026 13:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8705A6B00EF; Wed,  2 Sep 2026 13:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760206B00F0; Wed,  2 Sep 2026 13:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA6936B00ED
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:09:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39E4712032F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:09:41 +0000 (UTC)
X-FDA: 85169458962.05.8D7A183
Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	by imf20.hostedemail.com (Postfix) with ESMTP id E92381C0009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:09:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DBKs3ZGx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788368979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=520V5YZKa4W4p+rS1XuM5gpyArdQHv9WMOMWdi+ZzB4=;
	b=6tm8yEuHhSArn03QbVNjeFyupK76PqZfW5O7VA4SDkjD9gf8Yq7Bc0Zg693dTExa3Z4Adr
	DjARTruTFve+HJn9FpBnUwRxtQwVDn0F3d8HR26Oyo99/d8X45RbZ4bu3QUGwCDiplE8AD
	y9HXAXuIeF9UhqgeYSlcd1qvNclO/7I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DBKs3ZGx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788368979;
	b=XU+sXh05XYbiYwa/J26rFvB7x8BuASQiUurjpG6bvLCteUhE24Zk0mhyT9wldlJvKjn4I8
	kVRfUzpQ+c6OO+uUcmSeNxstVKnlJGuDXhgeCeDwnBbOPSUY+ntdLA3p0tmg7YfdbQznGI
	SCG/KEOva4tFPxEUmczi+J5QT71X814=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZFXv+XpeuJG4l4p41D/Mf1mufjNw3LILnzU9t7FD6bk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788368976; v=1; x=1788973776;
 b=DBKs3ZGxMBqZGCGiWFmqE9V/6QHGQ8HF2QIDG7PB32zdiZX/GhH5bO1f4gTKnRFwXnq1b6Mv
 nnwZt2NOftB4AX5OKSGG2ogRABIw4ttJg3gT30Xrmi/2cfuuF09vMfDlFRwzPF0dmOGIt8wlSfw
 qHApdOToZWnvwfU2hb9LJNUs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c8ccc08d494f655b;
	Wed, 02 Sep 2026 17:09:35 +0000
X-Mizu-Trace-ID: c8ccc08d494f655b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	bhe@redhat.com,
	vgoyal@redhat.com,
	dyoung@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/14] mm/page-flags: remove PG_private
Date: Wed,  2 Sep 2026 10:09:27 -0700
Message-ID: <20260902170928.2227054-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831-remove-pg_private-v2-14-3668159cd9e8@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E92381C0009
X-Stat-Signature: 89z7pkpzzf6dm4t8xyohhbcghyhibpjg
X-Rspam-User: 
X-HE-Tag: 1788368978-669385
X-HE-Meta: U2FsdGVkX18BERFBZcUSOmuMkdsShskrsqMMvr8RpLqdDEQvphocxjQO4PtXfKm/LLqMUC4eHK7zvAzrkdGdvb73cdbEZZeZZzRFIvIVW3erqKHSq7uQukkgM6IuMnxDtOqJnChhxD/MXQuiw6SA9e0zB6T4PECgrrViiwi4weBsFGJIZQogTAIt0BAGvcK5nhjKEPffrgDRxh5oG7A3MK8aBkqcvRoxZSmshuNCZxjRidu2zgbfCOq3FXJlwFpPedHqQ6IlKp1Cq/ve7v8nVw4c1dvauT/Vx/YHVCuBU0j9kMppJhPxPg83MgZ+N0Rxy/j5DgtaFwQx/sKYE9KnPrzc7ca3uDm9WdKvMSAFgjsNulSHjucIB9Nm+W7X/Tyx3rldiagKMdGesdO7/NZ5Ht0XhAupBLxFUpiUhmJtTFn2wqZCD8ObeqmyBDS+vUXzUOLjccZ5OJSmkCg1B1e60tZj9LD7GD1Sn4K3dSIYc9FSGgwPYtfB6D5va86MzuWdA23RYptDgu9L0T/k+hHZRb2iyJQdXCmL+YFPgHFtDpIKKE4PI+IUiFh/mvSm5hKDq3Ewx7Gznas2YKvTgRTRzF4d246SI5vmD/3h4XoGbSSbmYr2CBPQFRFZV6GEPHiuHjmMXp64mkHmZJNuSqhCZx2foTHFNJtzxQnKQBSV/1sViYhyKPI2w/+8v+5UfchvjKP+wTgBW+dglAAN8TNlTxN0Tge0cz0+z716B+ZoKz6wOmgPtABdM/IxLUBrOwMp0MTZcXpbOyiwEdsH9BT+e9WzPBATNeR5zrvQvqdyDaXG0cYtV9B3GuUGt1ukbQZSD2HpuDeXL3/Z7cKTMVaDXomUGNlqaVCSSe8Tfb4TrDBK48+BvI4mQDqgZURnr/wr+DHH78bdkYRfA6P4zvaB1iQeOpRnCd/RDEV8FYIlyjGIKWjCQ2MNPv2TYdLwfkJ0t+/0FNeVXSVPWcYq8/0
 l2y9aLK7
 m2zqu/XZjmdUbfrjnVmNHXqj/TCWAfo8QCzJtVIchY7SIhx0xU2uJOW5B0zPwFk5vmI90kFOiCClvc6lZdS1UuBUunKf2DO60eFrAbuots6tRQG+pPOY0ybDGJw3D0RCUMmX4acvB2ETK05e9FXYI7SzgYPhhVPxJk145e4XgEZlp2/pQR5CgyUp/r9gxD7ZEWAoJsTQH+qrouLIW24FQQ3a/JJahYPv8fhau5sagC5zu15fMFK/hAQeuZ4P4pIrizfxeIsp36JjCvuv1n4pEAlHweM8HkV+q+EqpsX9ASQ0VWmSWyzp0PqOO/pbvgrrjntfQKJag7i/871cQi04hPth0dCvZ8aeN3R71hdBA0/7bqIQfQE5ON9FH46HkWX/V+DcTBD2ZtlxxTOUOlYeoLTk6Xa7Kfss49fT30dsF+wr54l83DjlqZSBTisUIbWkTj24fCAaBDHde+Yi/dU3BJrKZPgfwEgW13IYM+pSXqK09F8wXoUEtqh6cU9j2hcuMN0E4dmRy98ErotV/dcqUlZ/SZqrwdX5sKawE7sZESIO/tBOBAfFtDKVwlQva0ODvXapIfA3hJx7Fy2kGJ/EfscGse+/75nYHIYaVB06t0lalPxemKafWORtQ/kgTqJp+qbs2xnLymw317fDA2whuJknKXDyorKUVm776A1H5tVcFGdbNdP4Tpk6+uVLLdwPeAJ6aPjkZRmMOiEzrYDve1d1pW3u7VLp96kAQmFHWdMUsPafLPOYLTa2ic2vLTHYQ4LlyV+lL0L5gSswsfGk30JaZQUdmhoxQb3P6IDcZ0sotlD45zc6ojtBuZPSYJi5gPmmlno5Ai+k7dMhbJhTbzqBb/3Ee5cKG/7T9EQxj/DblHgjtUAMn5QYi6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 15:25:37 -0400 Zi Yan <ziy@nvidia.com> wrote:

> folio->private != NULL indicates a folio carries private data, replacing
> PG_private. All PG_private users are converted. Remove PG_private and
> reserve the space as __PG_folio for future use.
> 
> Also update files in Documentation. hugetlbfs_reserv.rst is outdated and
> left unchanged. It should be rewritten.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Baoquan He <baoquan.he@linux.dev>
> To: Mike Rapoport <rppt@kernel.org>
> To: Pasha Tatashin <pasha.tatashin@soleen.com>
> To: Pratyush Yadav <pratyush@kernel.org>
> To: Jonathan Corbet <corbet@lwn.net>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> To: David Hildenbrand <david@kernel.org>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: kexec@lists.infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-trace-kernel@vger.kernel.org
> ---
>  Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
>  Documentation/filesystems/vfs.rst              |  6 +++---
>  include/linux/page-flags.h                     | 19 ++-----------------
>  include/trace/events/mmflags.h                 |  2 +-
>  kernel/vmcore_info.c                           |  1 -
>  5 files changed, 7 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> index 7663c610fe901..5f1df6d080508 100644
> --- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
> +++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> @@ -325,7 +325,7 @@ NR_FREE_PAGES
>  On linux-2.6.21 or later, the number of free pages is in
>  vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
>  
> -PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
> +PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
>  --------------------------------------------------------------------------
>  
>  Page attributes. These flags are used to filter various unnecessary for
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index d3a93eec3945f..dec7816303c6a 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -649,8 +649,8 @@ Writeback.
>  
>  The first can be used independently to the others.  The VM can try to
>  release clean pages in order to reuse them.  To do this it can call
> -->release_folio on clean folios with the private
> -flag set.  Clean pages without PagePrivate and with no external references
> +->release_folio on clean folios with folio->private set. Clean pages
> +without folio->private set and with no external references
>  will be released without notice being given to the address_space.
>  
>  To achieve this functionality, pages need to be placed on an LRU with
> @@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all writeback to complete.
>  
>  An address_space handler may attach extra information to a page,
>  typically using the 'private' field in the 'struct page'.  If such
> -information is attached, the PG_Private flag should be set.  This will
> +information is attached, non-NULL 'private' field will
>  cause various VM routines to make extra calls into the address_space
>  handler to deal with that data.
>  
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 9b585e68127a2..eb2961ed61018 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -44,10 +44,6 @@
>   * Consequently, PG_reserved for a page mapped into user space can indicate
>   * the zero page, the vDSO, MMIO pages or device memory.
>   *
> - * The PG_private bitflag is set on pagecache pages if they contain filesystem
> - * specific data (which is normally at page->private). It can be used by
> - * private allocations for its own usage.
> - *
>   * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
>   * and cleared when writeback _starts_ or when read _completes_. PG_writeback
>   * is set before writeback starts and cleared when it finishes.
> @@ -105,7 +101,7 @@ enum pageflags {
>  	PG_owner_2,		/* Owner use. If pagecache, fs may use */
>  	PG_arch_1,
>  	PG_reserved,
> -	PG_private,		/* If pagecache, has fs-private data */
> +	__PG_folio,		/* Do not use: reserved for folio identification */
>  	PG_private_2,		/* If pagecache, has fs aux data */
>  	PG_reclaim,		/* To be reclaimed asap */
>  	PG_swapbacked,		/* Page is backed by RAM/swap */
> @@ -576,7 +572,7 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
>  /*
>   * Private page markings that may be used by the filesystem that owns the page
>   * for its own purposes.
> - * - PG_private and PG_private_2 cause release_folio() and co to be invoked
> + * - folio->private and PG_private_2 cause release_folio() and co to be invoked
>   */
>  
>  static __always_inline bool folio_test_private(const struct folio *folio)
> @@ -584,17 +580,6 @@ static __always_inline bool folio_test_private(const struct folio *folio)
>  	return folio->private;
>  }
>  
> -static __always_inline int PagePrivate(const struct page *page)
> -{
> -	return !!page->private;
> -}
> -
> -/* no-ops during transition */
> -static __always_inline void folio_set_private(struct folio *folio) { }
> -static __always_inline void folio_clear_private(struct folio *folio) { }
> -static __always_inline void SetPagePrivate(struct page *page) { }
> -static __always_inline void ClearPagePrivate(struct page *page) { }
> -
>  FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
>  
>  /* owner_2 can be set on tail pages for anon memory */
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index 935893e5ea53b..caf090cd6f85e 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -144,7 +144,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
>  	DEF_PAGEFLAG_NAME(owner_2),					\
>  	DEF_PAGEFLAG_NAME(arch_1),					\
>  	DEF_PAGEFLAG_NAME(reserved),					\
> -	DEF_PAGEFLAG_NAME(private),					\
> +	{ 1UL << __PG_folio, "folio" },					\
>  	DEF_PAGEFLAG_NAME(private_2),					\
>  	DEF_PAGEFLAG_NAME(writeback),					\
>  	DEF_PAGEFLAG_NAME(head),					\
> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
> index 8614430ca212a..5a417f8a922ab 100644
> --- a/kernel/vmcore_info.c
> +++ b/kernel/vmcore_info.c
> @@ -216,7 +216,6 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
>  	VMCOREINFO_NUMBER(NR_FREE_PAGES);
>  	VMCOREINFO_NUMBER(PG_lru);
> -	VMCOREINFO_NUMBER(PG_private);
>  	VMCOREINFO_NUMBER(PG_swapcache);
>  	VMCOREINFO_NUMBER(PG_swapbacked);
>  #define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)

+ kdump maintainers and reviewers.

I believe makedumpfile reads VMCOREINFO. Removing it here, might cause issues
for older makedumpfile versions at crashdump?

Hopefully kdump folks will be able to comment better.

> 
> -- 
> 2.53.0
> 
> 

