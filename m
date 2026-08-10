Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF89C5B569
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 22:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC046B007B; Mon, 10 Aug 2026 18:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C866B008A; Mon, 10 Aug 2026 18:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B24C6B008C; Mon, 10 Aug 2026 18:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16D916B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:10:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9240614024F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:10:14 +0000 (UTC)
X-FDA: 85086753948.18.5269206
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1D3D71C0003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:10:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="UwX/Ilov";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786399812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hUK9nmdYQUfhG6ut1/QpR/T7D3LLI4jSc7+bBZ5Ofc=;
	b=IiJnIbj5uHsHpNGqSB1LXgR6q8pU9lyqyjEz3F8X5RAOEW6rzu4e7ScUhvs/agi7VwTvl6
	wewjKoRksUDArD6w4iIRzAVVBWMBkLVda468zLtLczOnHN6GkOLJGVGQBy0kC7SZlZMBK9
	TiztFdkV7xcb/DIBidLxwjnM4iDuz38=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="UwX/Ilov";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786399812;
	b=X6mpCEx1fGPEOJNwc5J+pbDceL6dMhjXzCGUN/+HCE6oz6yfkSUI8U1ikW90HOgU7WcUX+
	N/Lm1tVETRM+ywIN6PbZAx3oMsBjsD0764Spgqt7i4lEPa4v9R98WQ/J5kfs9SFlsm/igz
	F3kA44T6coHuydM0o7D9tZ8plMXffU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9648A6001D;
	Mon, 10 Aug 2026 22:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB66F1F000E9;
	Mon, 10 Aug 2026 22:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786399810;
	bh=/hUK9nmdYQUfhG6ut1/QpR/T7D3LLI4jSc7+bBZ5Ofc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UwX/Ilov0bIFii9m3iwtL8q7dWNlzT+Wx3UroPo9PylX7if0NcfH9JAavRDAn86dw
	 JNwDAbfcVY3VRo/UBsUbAdQe6WqOiVdxquE1mb7LVSCrY0NRcx31i22SVoR5H3wZ9K
	 Nroa/JyRqqFqLrw3hFrR5C55A7jEiwD4QPiMGP18=
Date: Mon, 10 Aug 2026 15:10:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, Kees Cook
 <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Arnd
 Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Alex
 Deucher <alexander.deucher@amd.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, John
 Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Youngjun Park
 <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/20] mm: provide vma_[flags_]is_cow_mapping() and
 remove is_cow_mapping()
Message-Id: <20260810151007.c1cfbcf46d498d2f8ce566f9@linux-foundation.org>
In-Reply-To: <ann-vS6MYT9kuXqu@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
	<20260806-b4-scalable-cow-virt-pgoff-v4-2-ab318a350404@kernel.org>
	<ann-vS6MYT9kuXqu@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1D3D71C0003
X-Stat-Signature: 6wapmibastqtqeegnbh1jh1pitdp75we
X-Rspam-User: 
X-HE-Tag: 1786399811-822051
X-HE-Meta: U2FsdGVkX18yB2wDyq1rW8XJRsCYgCac1N4GtfnO0r2fFCQ/BgnAEWDjvBfWr3H0VIow6zBlYSwx4GBOcjk8F7BPQ5jKksHHqxwOKrdwXI6ANaqfu7Z++LcVYLL3gxFGIral+7ggEoFlKdm9v9Uhmy29gEAAqdShkLuFf9EG4zWZogrVrb7sY8ERwKlSh1V2wd1x4yyBIvIZs2Ro/qwFgukYmZmiuCaFGQdkvfXa3l5DfC+jD1/9zt815/XgjuyZ+3+4b7TIaCL7wxp6nLs56m5CVipfhHVe3D4n9vK2RSQwuvfho5Qv71LZNS2/S4vKOya2/piucU+l6FWBfz9MHw+XmW0WXhdImfJkgYIfnzM6WI5xDmCDPthngdKlPbNFQ1QUN4w95imcuzvho3BV6NFRl5/D6fgH/2i8FYCUbCtKafrO1G48DeaKL/NzsheJIuYYsTrTGPcwbMx7Sxc4F3E3h1MRBJ0g0kKnaj+6W0tPYP7o7Dp0tfEaki/b5NkEHfY61hZROKCCivc99fO8vsQUsCPwoYWUap5N5yXoUgMTTzOJCFJbkHLlkDDD6L4hDlNu5GWGBhNsoxAJrNolO0w6mwavq2Cxu7oV6K4Shnd66sh1XsTOLYySlkugZWIEPjejZ5kXJWut/NKlYqz4NPQ7lWfG02FY9LuZShMlgCglZZIVmJ+T16mmk4GQ21qBVnC2AgV2KoPLuUQO8aKeHbkJrPopR6FtXg1b7HZ7VU+ZRjyXvz0CFPMXv0E7NqvHWm1nYgQMocnXXx3N3wB0uDPTXFvX9tvVxuwuqplLZSveSwrBbT1BJxAoH11uPd/LrWVR3CBbxqCQ3Dxcr3Tnzf9WKsKkx8YuebY3qDgTzODDe3e4StvQcI3Ebjh33zU16SelRufGDP0u+3Kr7xKcS4UmGZf3p4KqKtw9xB7CaeguXecn8pHw7YFVO2JeHK/N2WK/3eabSvja0VMa+In
 FAJZbP78
 67Ca4LOkmym32BDWq7nXHG0/Qc2kXB4Rmu2OWqBwKvBvvKNVi9/0u2We12kgR6ME9lPZ5IWnZmcVzlRDG5JubSUwF4RAPjhqDfc2GMl5IDtIinUvFh0nH3k82MKDL/DXozX8OEBbRA/4smxAor3OUqADOh9ylaBr/gIBrilXXiigotaceStLkMzyfLw8imAg5IBibwWH44K4zU4CpVvgKkRScwLEAkHJa0RMHvxyGgzwxHbrFaQuoClCSXnb0wbk/OjrHQQXqP00m6YZYGx/QdCQV2gyMG6cdzavXnfREzyCXzDVT0l1bkua14O0cBwiqKdHmcM0ZO2rlxA0RqyVI93wh0UILgV77oG9WzEd75YMdMFqX3JOW9wJkmY+TCJsmZIgvBTaDAf1vXbfY7unrBiRU+akxbzqMtdzYoi+IAy+zPepxkXSIc4Z4RGqtZvZ2pKv6LPTXOGy/oBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 18:59:34 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Hi Andrew - would it be possible to insert the comments added below? Trying
> to avoid a respin if possible :)

np, like this?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
Date: Mon Aug 10 03:07:02 PM PDT 2026

add comments, per Lorenzo

Link: https://lore.kernel.org/ann-vS6MYT9kuXqu@lucifer
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   57 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
+++ a/include/linux/mm.h
@@ -2271,17 +2271,74 @@ void unpin_user_pages(struct page **page
 void unpin_user_folio(struct folio *folio, unsigned long npages);
 void unpin_folios(struct folio **folios, unsigned long nfolios);
 
+/**
+ * vma_flags_is_cow_mapping() - Do these VMA flags imply a CoW mapping?
+ * @flags: The VMA flags to check.
+ *
+ * Mappings which could be CoW'd (subject to Copy-On-Write faults) are
+ * described as CoW mappings.
+ *
+ * All mappings backed by anonymous folios (all anonymous mappings and most
+ * MAP_PRIVATE-file backed ranges) are CoW mappings.
+ *
+ * All other mappings (including all writable MAP_SHARED mappings) are
+ * non-CoW.
+ *
+ * The criteria are !VMA_SHARED_BIT, VMA_MAYWRITE_BIT.
+ *
+ * VMA_MAYWRITE_BIT is checked instead of VMA_WRITE_BIT to account for both
+ * future mprotect() calls which can render a read-only mapping writable, and
+ * GUP with FOLL_FORCE (e.g. ptrace) which can CoW a read-only mapping.
+ *
+ * - No anonymous mapping can ever clear VMA_MAYWRITE_BIT.
+ *
+ * - Writes to anonymous mappings do not immediately result in CoW faults but
+ *   may do so after the process is forked or if a read is followed by a
+ *   write.
+ *
+ * - Writes to MAP_PRIVATE file-backed mappings result in CoW faults and may
+ *   do so again after fork.
+ *
+ * - MAP_SHARED mappings of a file opened read-only are transformed into
+ *   VMA_MAYSHARE_BIT, !VMA_SHARED_BIT, !VMA_MAYWRITE_BIT mappings, so remain
+ *   non-CoW.
+ *
+ * - Drivers may clear VMA_MAYWRITE_BIT but do so at mmap() time and cannot
+ *   mark themselves anonymous. Having cleared this flag it is not valid for
+ *   them to leave the VMA_WRITE_BIT flag set.
+ *
+ * As a consequence, the anonymous reverse mapping only tracks CoW mappings.
+ *
+ * Returns: true if the flags indicate a CoW mapping, otherwise false.
+ */
 static inline bool vma_flags_is_cow_mapping(const vma_flags_t *flags)
 {
 	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
 		!vma_flags_test(flags, VMA_SHARED_BIT);
 }
 
+/**
+ * vma_is_cow_mapping() - Is this VMA a CoW mapping?
+ * @desc: The VMA to check.
+ *
+ * See vma_flags_is_cow_mapping() for details.
+ *
+ * Returns: true if the VMA is a CoW mapping, otherwise false.
+ */
 static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
 {
 	return vma_flags_is_cow_mapping(&vma->flags);
 }
 
+/**
+ * vma_desc_is_cow_mapping() - Is this VMA descriptor a CoW mapping?
+ * @desc: The VMA descriptor to check.
+ *
+ * See vma_flags_is_cow_mapping() for details.
+ *
+ * Returns: true if the VMA descriptor describes a CoW mapping, otherwise
+ * false.
+ */
 static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
 {
 	return vma_flags_is_cow_mapping(&desc->vma_flags);
_


