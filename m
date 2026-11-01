Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FCE606A333
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 20:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FNhsqH/I
Received: by kanga.kvack.org (Postfix)
	id 42B3F6B05B5; Sun,  1 Nov 2026 15:30:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402B46B05B6; Sun,  1 Nov 2026 15:30:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318586B05B7; Sun,  1 Nov 2026 15:30:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1456B05B5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:30:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83E47120ABA
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:30:31 +0000 (UTC)
X-FDA: 85387693062.27.9D0CE20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A9FB0140003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:30:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="FNhsqH/I";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793565029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PsO3+ixebAi2GeHvElphzKqyCrNVa40RrCbCBR6aoo=;
	b=xAxiUoqqI4syr2oaH/FwWD/RFnhPpiBFGqtiP3gO/FjAirT8ed3/K9alD9l9PkA0vpU1p5
	eHshUWxckBi0EntOwQRHf4Z4X0jOUCeM9rgFdQXATmOp8bcs20NPjzPG5kd+KPimMrbciM
	So+lk/gjIvx0wZo/P1fOPspIVPKqGZY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="FNhsqH/I";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793565029;
	b=XxPau5jn639D3M/xtJgCt+9RKVU/wotJXxLCphGkd3C/jS8k2M2OailxzNSwJR+z+zkDFu
	qG3X5jGyRyHJzoQqUTPv3dHJq7RBtyRLvHDFahBmUmQHkB04vunuvfboM1XhziuSAsBwZa
	PWYr1nEIO/I7w6tMsbzLfRmbFiutDC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E70740760;
	Sun,  1 Nov 2026 20:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072E81F000C1;
	Sun,  1 Nov 2026 20:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793565027;
	bh=0PsO3+ixebAi2GeHvElphzKqyCrNVa40RrCbCBR6aoo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FNhsqH/IpagTug6CeKHflu48Fz4ATDd8wChHmLe8njQ5/+03LK+0tBXDoXTa3Th2V
	 hIQBaVlVLG/Gz8HmFg1wV+7NB1ZXY309bBipBw2p+lGIo8IP6VBNnVVTudel8rHFiU
	 QvTJv97xdnj8Qc6yj2VnFTQFBzF35zYwOsQvWOxM=
Date: Sun, 1 Nov 2026 12:30:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Brendan
 Jackman <brendan.jackman@linux.dev>, Byungchul Park <byungchul@sk.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, Dev
 Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, Hao Li
 <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins
 <hughd@google.com>, Jann Horn <jannh@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin
 <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, Peter Xu
 <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Qi Zheng
 <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, Rik van Riel
 <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, Suren
 Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau
 Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, Vlastimil
 Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, Xu Xin
 <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, Youngjun
 Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
Message-Id: <20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
In-Reply-To: <1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
	<1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A9FB0140003
X-Rspam-User: 
X-Stat-Signature: 8ewqrs3wf9mfcoa4fo7xgnpm5ij7mnji
X-Spam-Status: No, score=-22.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793565029-258534
X-HE-Meta: U2FsdGVkX196ZH3Inh9r5kul1koD6wLV21+S4hCdDwPTWSHTYz/+6i4fDm/LRomzLqSyZIE5+AupTO9jMpEV8S0fII/nr5bw9Hwu4Aw6TKsFo8u4ULtUPccLNeQu0nRnVlkm+P22Anq8w9D81AwBpM/I0P4rT2FKaf24a3N7Rk/GaJzzLSt9X51dPN+fd9GVk/+0Urxqq1S5swggStUGzVDcUL1LBTOtQcrIOI30/bSphE5gn64GBd8kzQp624RgBgqELbFAc1q3RjYQh0hPVqUJ/q0breuLyGwgARLmijDcm8QVYPQFKM5I3NWAf0RkG8od0TVTKIA8cZpxB6aquhT0w/GqvJdaaKeRQYHuU4bRgIZ0qkdtuaWtyQOTjF9TcKDuqKoXiUkNRP/tf3WsBTFXFSd22pC8iKJXHFY5f+d0TtBOPPh/cJd7nuSGOa6x1F2iN9wT3neHSGcsZffp/rUm+TDRvHX1J6IepuIeeWi14Cin2nRa6DfSRBV0h+GSA183HQ2b7AcU5uffl+JpDauA9O/KxQ2piMr7t+U/QqMrEL5lmMCJe2h2uLexjpPZ4bjbPg3bRn43wRDpRRkRSksYIxFuzIpAPvZP1ZQJr7oLL+XH4jQ9BTYqdEZCWQW0oOGcnFjOvQLiC0HvI81FzYVyig4R+H5OFFj9C18d+TgwIdR7lH6nd3xSALnLlJ44c3HBkZ8WU6ENU+HASg0XK/56hyoXU/AHT2O+6Sa0U8INzoGyz9Yw/yaMaO865Oze1xwTNbJfCn1+bDNx3PATr/afFvXqx0p6bFbcycWJ2kMX1lYtH1UZld+aIfZt7uLwjM2pT7HDElrLmpUt8U/3JR2BWY3K6th1cSiKsDfyTDdsWqwWhxtZB0va14ZzCUp18ajQthPe8/+NrwAj5BaLKQg2hSjsZe5UtItCMGygVO9Xz1KcputNGsDJmZxuVkf78XWmXB68uXM29MW0JUy
 Mw9nwHyN
 07wP70HOI+0rOO7OGlivB8CC0ViB0G1TuSdqBk9n05NVYofhNxzKUMvdRVJLeFF+WYb3yXZcw3RAp5BoQIx6rfjwAebnRibz7G7NbQY7+a/mzDeOxoR7G4H/M9z2hK2bvqx/hqTj2Unv9HFeDYF27TM0izORYK4yGPdmdc755ib3SdNu+YaNaQjhu6uj2TPUisvoWQFXWVVMS8Q9/86gSWtditY+Vgjt3rYzZ15GIF6IF4uDrJsYmkgcW/2Jakgj7v6HIoQkL4IXKKlkKjh8VTMuePZKYsjgPjFuVKZnqsk9VSFsaN/xzXvp3BHbQefaMhqwwSSKzYzhF3SY1B9uULolX9HDDZbV2fijpVOMLCUUTTUA66F5i6a2pucR8d/Yzp+9zIeOIzsePPY3uIDaHt+8YuxfhonU9t+wFbQBKY1PCIdRv7zYnW4vPHxkuLM4bP/higN1duFR0T1SazYLJ7lFZjRuuMUcstkapZljbzT9QoRcEaAaSwYG56Y5iLu7k1yW5Pc+zRskLm94h4l/D05wyZLW8JdhGOoU2msKeKnde6ZNGpRJwaN+3V5u27Y2YqaJ3A011UEGp8ivPIqpf0LyL5VxY9kzxoUIUxj43J+CGYvIQq1eMYUQmzyJQyAJTjcD3UcZeM6S3C0aeEN3y/IRuj7oSe8C0T4sdSYqZ3iE4aw51TRsPWG/6i356UXlT/aCpejubpDuXIVdXGjXIXolkIC0eiZDiA081v8+X1VF64ok3Hn3L0Rq+d/qXj10ia6W3FNBOU621/3Y8xKWuKm4pbFFZFx0P2q6EUEjwYo+pMCbn2XBIZuvxV/HJEwVo8ZIScdSXhAJ/9NTyZQ9xWX7+3ILA85pdJFMnTK8R6rZScs0Rac+1cdQr+NvMOD/MOoMpQDscSNWdh4AtlvgjpbeSAtKEMvWGTDJ3/D9kvUceATLXMROyzEZTTJuDdUZgcjdSHcv33v8OctoT8y+6W/Lcqd4l
 V545vwEM
 lx/UmGzYUvntPBn2HhTKrKRqrriLfGQn8/tvpkpwagYbaCG6tDxKtS/GAEBu4yiU09KQ7PYx01Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 1 Nov 2026 14:33:57 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 10/30/26 22:34, David Hildenbrand (Arm) wrote:
> > Hi,
> > 
> > several MM updates:
> > 
> 
> @Andrew, should I pick these or do you want to route them through your tree?

I'll grab for now, thanks.  As a hotfix.

Because I'm whacking away at MAINTAINERS at present.  First step is to
consistently name the components, below.

This is a two-patch series.  The first renames components so everything
starts with "^MEMORY MANAGEMENT", leaving MAIINTAINERS incorrectly
sorted.  The second patch only moves things around, to restore the
alphasorting.

So people only need look at the first patch.  Please review that.

After this I'll have it identify the various files under include/linux,
mm/ and lib/ which can fairly be described as "mm".  That's looking
like about 50 files at this time.

mm stuff:

include/linux/gfp_api.h
include/linux/mmu_context.h
include/linux/node.h
include/linux/pgtable_api.h
include/linux/pti.h
include/linux/rodata_test.h

shared-with-other-subsystems stuff:

include/linux/buffer_head.h
include/linux/bvec.h
include/linux/crash_reserve.h
include/linux/dma-buf-io.h
include/linux/dma-buf-mapping.h
include/linux/dma-direction.h
include/linux/elf-randomize.h
include/linux/fault-inject-usercopy.h
include/linux/fault-inject.h
include/linux/firmware-map.h
include/linux/flex_proportions.h
include/linux/folio_queue.h
include/linux/fs_api.h
include/linux/genalloc.h
include/linux/interval_tree.h
include/linux/interval_tree_generic.h
include/linux/io-mapping.h
include/linux/io-pgtable.h
include/linux/io.h
include/linux/iommu-debug-pagealloc.h
include/linux/iommu-helper.h
include/linux/ioport.h
include/linux/iov_iter.h
include/linux/iova_bitmap.h
include/linux/kho_radix_tree.h
include/linux/mem_encrypt.h
include/linux/memregion.h
include/linux/mpage.h
include/linux/ndctl.h
include/linux/poison.h
include/linux/radix-tree.h
include/linux/ramfs.h
include/linux/rbtree.h
include/linux/rbtree_augmented.h
include/linux/rbtree_types.h
include/linux/scatterlist.h
include/linux/sched/numa_balancing.h
include/linux/set_memory.h
include/linux/shm.h
include/linux/stackdepot.h
include/linux/uaccess.h
include/linux/vmcore_info.h
lib/tests/kunit_iov_iter.c

Then I shall have it ensure that all these not-yet-covered files are
entered in the appropriate place under an MM component.  This may
require creation of new components for the purpose, tbd.

After that I needs to have it cover Documentation/

After that I need to have it whack away at selftests, shudder.



From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: use a common prefix for MM components
Date: Sun, 01 Nov 2026 12:13:07 -0800

Several MM component entries still use standalone headings, so searching
for headings beginning with "MEMORY MANAGEMENT" misses them.

Give these 18 entries the common "MEMORY MANAGEMENT - " prefix.  Leave
them in place for now so that the renames can be reviewed separately
from the subsequent alphabetical sorting.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


---

 MAINTAINERS |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/MAINTAINERS~maintainers-use-a-common-prefix-for-mm-components
+++ a/MAINTAINERS
@@ -6816,7 +6816,7 @@ T:	git https://gitlab.freedesktop.org/dr
 F:	include/linux/cgroup_dmem.h
 F:	kernel/cgroup/dmem.c
 
-CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
+MEMORY MANAGEMENT - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
 M:	Roman Gushchin <roman.gushchin@linux.dev>
@@ -7322,7 +7322,7 @@ S:	Maintained
 W:	https://docs.dasharo.com/
 F:	drivers/platform/x86/dasharo-acpi.c
 
-DAMON
+MEMORY MANAGEMENT - DAMON
 M:	SJ Park <sj@kernel.org>
 L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
@@ -12164,7 +12164,7 @@ S:	Maintained
 F:	Documentation/ABI/testing/debugfs-hisi-zip
 F:	drivers/crypto/hisilicon/zip/
 
-HMM - Heterogeneous Memory Management
+MEMORY MANAGEMENT - HMM (Heterogeneous Memory Management)
 M:	Jason Gunthorpe <jgg@nvidia.com>
 M:	Leon Romanovsky <leonro@nvidia.com>
 L:	linux-mm@kvack.org
@@ -12328,7 +12328,7 @@ F:	drivers/power/supply/huawei-gaokun-ba
 F:	drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
 F:	include/linux/platform_data/huawei-gaokun-ec.h
 
-HUGETLB SUBSYSTEM
+MEMORY MANAGEMENT - HUGETLB
 M:	Muchun Song <muchun.song@linux.dev>
 M:	Oscar Salvador <osalvador@suse.de>
 R:	David Hildenbrand <david@kernel.org>
@@ -12362,7 +12362,7 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media.git
 F:	drivers/media/platform/st/sti/hva
 
-HWPOISON MEMORY FAILURE HANDLING
+MEMORY MANAGEMENT - HWPOISON MEMORY FAILURE HANDLING
 M:	Miaohe Lin <linmiaohe@huawei.com>
 R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
@@ -17370,7 +17370,7 @@ F:	arch/*/include/asm/sync_core.h
 F:	include/uapi/linux/membarrier.h
 F:	kernel/sched/membarrier.c
 
-MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
+MEMORY MANAGEMENT - MEMBLOCK AND INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -17879,7 +17879,7 @@ F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
 F:	rust/kernel/page.rs
 
-MEMORY MAPPING
+MEMORY MANAGEMENT - MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
@@ -17916,7 +17916,7 @@ F:	mm/vma_internal.h
 F:	tools/testing/selftests/mm/merge.c
 F:	tools/testing/vma/
 
-MEMORY MAPPING - LOCKING
+MEMORY MANAGEMENT - MEMORY MAPPING - LOCKING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Liam R. Howlett <liam@infradead.org>
@@ -17932,7 +17932,7 @@ F:	include/linux/mmap_lock.h
 F:	include/trace/events/mmap_lock.h
 F:	mm/mmap_lock.c
 
-MEMORY MAPPING - MADVISE (MEMORY ADVICE)
+MEMORY MANAGEMENT - MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
@@ -18728,7 +18728,7 @@ S:	Maintained
 F:	drivers/phy/marvell/phy-mmp3-usb.c
 F:	drivers/phy/marvell/phy-pxa-usb.c
 
-MMU GATHER AND TLB INVALIDATION
+MEMORY MANAGEMENT - MMU GATHER AND TLB INVALIDATION
 M:	Will Deacon <will@kernel.org>
 M:	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -21113,7 +21113,7 @@ F:	Documentation/core-api/padata.rst
 F:	include/linux/padata.h
 F:	kernel/padata.c
 
-PAGE CACHE
+MEMORY MANAGEMENT - PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
 M:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
@@ -21142,7 +21142,7 @@ F:	include/net/page_pool/
 F:	include/trace/events/page_pool.h
 F:	net/core/page_pool.c
 
-PAGE TABLE CHECK
+MEMORY MANAGEMENT - PAGE TABLE CHECK
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-mm@kvack.org
@@ -21829,7 +21829,7 @@ S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
 F:	drivers/net/ethernet/pensando/
 
-PER-CPU MEMORY ALLOCATOR
+MEMORY MANAGEMENT - PER-CPU MEMORY ALLOCATOR
 M:	Dennis Zhou <dennis@kernel.org>
 M:	Tejun Heo <tj@kernel.org>
 M:	Christoph Lameter <cl@gentwo.org>
@@ -25539,7 +25539,7 @@ T:	git git://linuxtv.org/media.git
 F:	drivers/media/i2c/rj54n1cb0c.c
 F:	include/media/i2c/rj54n1cb0c.h
 
-SHRINKER
+MEMORY MANAGEMENT - SHRINKER
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Dave Chinner <david@fromorbit.com>
 R:	Qi Zheng <qi.zheng@linux.dev>
@@ -25775,7 +25775,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
 F:	drivers/nvmem/layouts/sl28vpd.c
 
-SLAB ALLOCATOR
+MEMORY MANAGEMENT - SLAB ALLOCATOR
 M:	Vlastimil Babka <vbabka@kernel.org>
 M:	Harry Yoo <harry@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -29831,7 +29831,7 @@ F:	net/vmw_vsock/
 F:	tools/testing/selftests/vsock/
 F:	tools/testing/vsock/
 
-VMALLOC
+MEMORY MANAGEMENT - VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Uladzislau Rezki <urezki@gmail.com>
 L:	linux-mm@kvack.org
@@ -30864,7 +30864,7 @@ M:	"Maciej W. Rozycki" <macro@orcam.me.u
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
-ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
+MEMORY MANAGEMENT - ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
 M:	Minchan Kim <minchan@kernel.org>
 M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-mm@kvack.org
@@ -30887,7 +30887,7 @@ F:	lib/zstd/
 N:	zstd
 K:	zstd
 
-ZSWAP COMPRESSED SWAP CACHING
+MEMORY MANAGEMENT - ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Yosry Ahmed <yosry@kernel.org>
 M:	Nhat Pham <nphamcs@gmail.com>
_



From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: sort component entries alphabetically
Date: Sun, 01 Nov 2026 12:13:07 -0800

Sort the component entries alphabetically, keeping the introductory
text at the start and THE REST at the end.  This groups the renamed MM
entries together and corrects existing ordering inconsistencies.

Move complete entries without changing their contents or the order of
lines within them.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


---

 MAINTAINERS | 3252 +++++++++++++++++++++++++-------------------------
 1 file changed, 1626 insertions(+), 1626 deletions(-)

[enormous and utterly boring patch elided]


