Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37192C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F8F6B009E; Wed,  9 Sep 2026 06:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED766B00A6; Wed,  9 Sep 2026 06:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105E26B00A7; Wed,  9 Sep 2026 06:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0DC06B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:02:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F9128016D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:02:55 +0000 (UTC)
X-FDA: 85193785110.30.31F58BA
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	by imf30.hostedemail.com (Postfix) with ESMTP id 606918000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:02:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xNyQ0Onr;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948173;
	b=YmfFEyTRiEtoRE9tLs4hmCwxiZDqyDV3QNZdLnpaWUaZN2n6RkiESJ9XBiRC10jO8QE/R9
	ibMbJVfcKZU/ML2uZh92Se6NYPL82/VNpCFc7HzZKR7IQ4Xhw9LVA8Z+2Kg6QAM/f3JVK+
	dscJqWeLqb5phBKewkJjL7JxrwPjklE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xNyQ0Onr;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ijiq4aJVSIDKCvkBX4nS7TWTqCkpgJu3VkBpUHxNV5o=;
	b=7n9pxrUmPLbSg/CA6BKR7QFNOBMFB4qFxPgkA14OxEF05wePkwdkVGnIyKojA+vTI++ei9
	MCLMNuHPaaH8ITKUjcuZ4Wy58qs5+Z0KntAWDA/wGf8ZTcSH+GkEMxv6d9aCTiHsoF9ioO
	UFhrXbrplP9NX0ofuEzLz7qhjsERK90=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m//qkx0KbTFibXUztG1vNBFPNzkzWbof/D1O8o9BQjE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788948168; v=1; x=1789552968;
 b=xNyQ0OnrVl8pSF9kW9jF1oWGPMWCYbXb53HXpU5ULX52CXjVXjkqiXOGKQntbE2I8B/JkqcQ
 fCFot3UKe75GHc0UQ/Klt/kSjNrJQ3Hi84bYkwtBYMKviuWMkbOXSIfPpuPs+MBUeoeAkd06wHC
 hcBacTEeuUpSoLUz0UNRqoys=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c6ae4e2d42fbd256;
	Wed, 09 Sep 2026 10:02:47 +0000
X-Mizu-Trace-ID: c6ae4e2d42fbd256
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap writes
Date: Wed,  9 Sep 2026 03:02:39 -0700
Message-ID: <20260909100240.635595-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 606918000C
X-Stat-Signature: kponuauiyqe1binat5e1ep78u91iidbk
X-Rspam-User: 
X-HE-Tag: 1788948171-655944
X-HE-Meta: U2FsdGVkX19WRGYEsSE7MIGU83FG1DIvYgfBy90bWxI7R8eGftwiYB8rVcDtCB0+594X3w5Qvw4sLWJCA+KEHIIk0LCUiqHC3gTtoBsZV9XbszFekqxmwPUoOcB/NFNBaHbQBTRpWsHBva1VCZeo+VcV1WXE2HCJRVnAyVaXwDzWmW4XQ7W83oZep5NeGUgiD15R7hZwAbF7vwVnaFFtBQ4hGKFhMLDPNF9okax1Eo4TMBoSkdD12WSaYZr1lOfaP3+HmGNRs4EA7pbThgDO1pBSZia1z4Ebzl5e+GTzl/TwK60Q0hiKyN9ue7c6ZYCkNvK7hGbWtZWwk39olGKqyj/vvVmpWkww05wsrbFXiuVxR7ClrpboLJr6s+3h95ZjMpLQd//qZAx8Sx6AiEjoF2zwEaNSvKfXCfWvO4iK3+SvVQFxb76AonYMx0xydm+3xpSiHNzvT0JoXeQRpUGzOxT3JeJ33bE6+xsA7mwfklDc8FW9Kukc/07EK/kQUh5nB0AbGzVIaBCc/u/cjJdaurcnXQmwH1iohUmSmD0s60XqtVqd5s4a7Ia4iF/3SYma8siOBVF8FmidIu4kF+ZfoEg1qvYbYQXso1DHPT+bDcGNtcYHXLKYgQDfHcjrdsXx/y18jTBU2bh3ZXw3sEOQcudXTHoQXyPz2T23CUB0dcy95sTdUBbMnpnuiUAw8j0cd0ocMYxc5qTIpY7gZe+X2P++ZOVbFZ4NiHHpeBSllTLqnBZhtuveQcAjWzngrEaruENQuHTrtcOTOypIkD7AqOZfvs7UjUBzflIGS6g05LS5nj92byb9hOlBi0ZdUlXhjfCTamsIAWmI/suWKg0QZ5DglIoc4EOTWbdw8HBckt5/bCtVen8ApUUt/fUFMgjdNbex1OCW04M2XpbGq6X5Ue3WvAcsRl3pzfWKdUBDYwysT9FBLoub4YevRS73VECbmcOy/+9x3nQXLJvcqXZ
 9NmBvGIw
 xMMwuyPhRwmVKC024e3zYHSLYdtTtZ0gcpUcfmoICJwLzT9d9RMy/BKAqSlVWnHcfqEU9eiYWgZuWtDGVRFM0amSaYCYgf0hkxpGagdewTOelhk6uY7JAHjCrsvPAtGSsiBB2mYYuO7DrXyb1jhHGLuL0SnKjMDG8gggBwhqdZ2DJfSM/ykINT+Zr92aQZRxiJDRLFcNfD9MvuYYyDYIIoF7HhETHZfEMcfYg4vuvB4NzyKfwWs6XMjcRZKdm0bld7/Ew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 19:29:38 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A store through a shared file mapping dirties the whole folio. With large
> page cache folios that turns a 4K store into 2M of writeback: one dirty
> bit per folio, and writeback has no way to know which part changed.
> 
> XFS already knows better. iomap tracks dirty state per block and
> iomap_writeback_folio() submits only the dirty ranges, and the buffered
> write path sets just the range it copied. Only the mmap path throws that
> away, because iomap_dirty_folio() covers the whole folio.
> 
> Narrowing the dirtying at page_mkwrite() time does not work on its own:
> set_pte_range() batch-maps a whole folio writable on the first shared
> write fault, so the stores that follow never fault and never reach the
> filesystem.
> 
> So harvest the hardware instead. folio_clear_dirty_for_io() already calls
> folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
> folio and throws it away. Those bits are the only record of which parts
> of a large folio were written through a mapping. Collect them there and
> hand the filesystem the runs that were dirty, through a new
> a_ops->dirty_folio_range().
> 
> All of this is about PTE-mapped folios. A PMD-mapped folio has a single
> dirty bit for the 2M it maps, so there is nothing finer to harvest, and
> it keeps writing back whole. Keeping shared write faults off PMDs is a
> separate patch and not part of this posting.
> 
> On a 512M file in 2M folios on XFS, storing one byte per folio and
> calling msync() wrote 512M before and writes 1M after, with identical
> minor fault counts.

Hi Kiryl,

The motivation makes sense to me. I will look into the patches.

Just wanted to check, the above xfs example, is that on an ARM host?

Thanks,
Usama

> 
> Not addressed here:
> 
>  - Dirty accounting stays folio-granular. A 4K store still counts as 2M
>    against dirty_ratio and balance_dirty_pages().
>  - iomap_page_mkwrite() still allocates blocks for the whole folio.
>  - Filesystems without per-block dirty state see no change.
> 
> Kiryl Shutsemau (Meta) (5):
>   mm: let folio_mkclean() report which pages had dirty PTEs
>   mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
>   mm: keep the mmap dirty range down to the faulting page
>   iomap: narrow page_mkwrite() dirtying to the faulting page
>   xfs: track mmap dirty state per block
> 
>  fs/iomap/buffered-io.c | 37 +++++++++++++-----
>  fs/xfs/xfs_aops.c      |  2 +-
>  include/linux/fs.h     |  3 ++
>  include/linux/iomap.h  |  2 +
>  include/linux/mm.h     |  1 +
>  include/linux/rmap.h   |  7 ++++
>  mm/memory.c            | 58 ++++++++++++++++++++++++++--
>  mm/page-writeback.c    | 87 +++++++++++++++++++++++++++++++++++++++---
>  mm/rmap.c              | 56 +++++++++++++++++++++------
>  9 files changed, 222 insertions(+), 31 deletions(-)
> 
> 
> base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
> -- 
> 2.54.0
> 
> 

