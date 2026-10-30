Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB27C606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSiTggz2
Received: by kanga.kvack.org (Postfix)
	id 922596B05B8; Fri, 30 Oct 2026 17:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8BB6B05B9; Fri, 30 Oct 2026 17:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80DA76B05BA; Fri, 30 Oct 2026 17:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD996B05B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:36:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C08421607F1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:36:04 +0000 (UTC)
X-FDA: 85380600648.27.0E55EE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 129D120002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:36:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XSiTggz2;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1bSxUxjIuldipfMHFleRTGSs2OhlVbOb3KEpj5IUk4=;
	b=MFOkYtCcNzOq3rsN6B+vCg+Wb67IxvBo8neK8GsSMeL1/GVLRQ9j33ymdu3pJKPbd2Hz+f
	Sty9GOvW2+31IVhrCGbQteYr3NQLV3yF0visZwowX9yNIIQPAmhQc0NxYZnUsjmFHoZIeU
	gg5JkbmO2lOylT2u9rZ+rhHO9TDqCm8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XSiTggz2;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396163;
	b=N4iUgn+y4909RHVeUDxyhzk/l4uu2L3O2hGipaYmR7YECXbEErebEfEHqYB1FLyKgPaUgr
	rLDzMQeaO8Uhdv1B3xTWENQlpFt6yloDjQgsMXyUNSiFTbfEThj1XJHb09tcDndJ4YYLX0
	B1Yvg5lVhUdM1f1OHcc4dNvp7+TaPlI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D6F26061A;
	Fri, 30 Oct 2026 21:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A10C1F000C1;
	Fri, 30 Oct 2026 21:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396162;
	bh=Q1bSxUxjIuldipfMHFleRTGSs2OhlVbOb3KEpj5IUk4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XSiTggz2XgonprLFd75lEWlz6veEhBFh/SJ8cT1QPkNN9R0MEuyGkPRE6XzSHJWJm
	 nPHZG0AogWzpZ2TZsu6XPeTDFTcU7ZP1x45lRO5JlWObntM/25RW0JPtuqAPrX+ljQ
	 PDXIGTj2Qq4/XOQJhQs1AfW2EbiAu0fNaIwfRRY3c5UZlaBULa7v5vLS1jsQrig55V
	 Q8P7ugHjCERSqvBY3jq9HFE1GU7MAE7oef+WvNZPJb7tehIJcDRb69PRsrzc0dWbSV
	 A6xQM142Tv0ucHICtb6qe41g5BCplPXVAbu7tRFkXUb2Df1Qha5Ys/N5z0p97FWjTR
	 GAzDJlpeiSyMg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 30 Oct 2026 22:34:29 +0100
Subject: [PATCH 5/7] MAINTAINERS: add missing files to MM component
 sections
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-maintainers-v1-5-97278f8a5f54@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
To: Alistair Popple <apopple@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Byungchul Park <byungchul@sk.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9213; i=david@kernel.org;
 h=from:subject:message-id; bh=MiDg2sLpYMBxExc5N5/sYKkF7msOiq9t7x1deSR2pbw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKe8ubZC6jL3Xuxt/dQctBZ5+bUvx1zVv88vGqa44a9X
 0UcY14Gd5SyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRB60M/wssGlqX9P/4Xii5
 4/b9ac63JuwJmhc9bf/VCSsfHp5Z+/g6w3+nKynqLic1jrTwOvTtYD7O+GDb9MvuqZqN1mKcSz9
 cv8EJAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 129D120002
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 545px7ouqd1a5o8utn9yh1z799379j6u
X-HE-Tag: 1793396162-211778
X-HE-Meta: U2FsdGVkX1+c/HFOsWdHnURM3YDGiZSgmQn6u3MiwSO43D4DQVDEs5j8X0toY1i/boQtf/slSLD59ErnkZ5jGoAjJKcJkVsc5faA9hasgiBMkORDedVb30mlhN1c1cZ63N6rIErKZsFLHuokZfD9ecVLGK+nIjX0X0lgffr5tOcc1+W063s5Rpk6PF0MzizdRHZcyKnoryypgmUBSCuaLuR7rUpkekVpPyeWizp9j2pDNR70SmMU1lx9rfl9jV7Z12M5rJEVCI5QCZZnUuOXgqu0VPhLd30elbD5hdf9UoQ+MkA+6aRUd4buW/Qlf3uHg2UbBlGfcGAHY7gzN9Yi352Cmu4scoUpTjG/pOrlXFAORJU5UZEMmk5EKeULqocUfCepJPLH/MRGn2qa8ym+wX9ylxSQ0up8i0GbqanYhjZNfxreaJQ6zk+f10XLueccJGj36VIHU+9Iwk/gQW1eUU4+V+QkqsQmo/8z58nqhg+zijLnaHWcun7X2tgQzbZEzXw4/g2b9CNAludNazAITqzAwJm7nH54UXjlPkYH8MD8MCFLzNN4Mhv0w3QNhdnXXuQRaTHK/VY07lMhp/zFnYwq393zp1Lkr4DKXbnIn5msdgePLWBEj1FQZ9S8mCdQ/BDub4Wly2CQEKWtE7alTn4ppzESAUGqaqAPuCj7mY7D6/BBqMouHfL7GFB9CR/ZWalljIA14bceKNk8cseR0ge48OeyR5RJAmfQvZVwoSSNEH39C09UTSnBgig4vs+BNeal9UVSh7uDZNewvo1RECDMrwGfy00JsdnaMitTdsY5ACRagTlou3ZFg6VJW8uSGqk4+Xno1VJ7WMCD92rA2pkSdi32/gpkExfKm6VvYGkEK3fRyriNitPPNG/cirKws2dzUun2Pn0GyVN04UkGROhLvyUqfAX1WpFV4lQnZPZh9PtYR1paGswrLLhbVpNw/CU1Xcp14GKCGNpf/4b
 ri+mzOiJ
 Ru731NgR9HMegFL5y0ZlGEcyWzTy9zpJR8NqCWaKQvKzZcOhx06eLUPqqzZIW60wjIUL3A4QnpdlPP1IqdHqWPr8xSudd/PsGRHaX358qEXk0G4yUHw8eHr3Nhj0QpdzwaE4ZL5r18UwYf521EhIxqVQ7As+Fb+De6zPZJMFBcHMe0tgcOqG8l6WHilkTk/bHiCBjbC4O5R1MUg+XF5qEdFuqu7TijcLlwh8hwy+kobWXHiG8urY0cfs4lsMq1abgWZxKWVW9leEM+ZI7+D/LLxKW4dYVDJJ78VWKFbd3SUSRj0Y621OqynsBRBskcUkeAEaPsek9HwQaEKcuvMF1wY4/WYlu0JDPIX9qnQU1TDiEdGpkcvNjUS/feNZLZXfrkZuLX69v6I+r54NUOnyjS8HbkmAcY4Hb376+T1s/cbKfR+LmKus7r+NXIXRbeZbQuiFjcuBU+nH2G31rvmlXCYe8aoEWN2Rfc9ZlFjnKiuq9lf7E8S3ZakN65w9OYaun4ipYDznG8QBjCA4Awa2FstbLxSwA989cE8pbjvv9P64lp4RGSOKOUtyhn0ntijBK4Vz45ogxuaq0WjY8AOCn567zmDNGXvhdlflm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We want to make sure that MM components cover all relevant MM files. The
generic "MEMORY MANAGEMENT" sections will probably go away at some
point.

We have a bunch of files that are not explicitly tracked under MM
components. Let's add these missing files.

Split up tools/mm to the appropriate components, but still add it also
under MISC, similar to what we did with selftests.

Don't split up selftests for now. They are covered by MISC and some
sections name them separately.

Some files like

 - include/linux/numa.h
 - include/trace/events/kmem.h
 - Documentation/admin-guide/numastat.rst

are a bit fuzzy. Add them to the best fit for now.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bc82ef545e0aa..98948d159173b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6841,8 +6841,10 @@ R:	Muchun Song <muchun.song@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/admin-guide/cgroup-v1/memory.rst
 F:	include/linux/memcontrol.h
 F:	include/linux/page_counter.h
+F:	include/trace/events/memcg.h
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
 F:	mm/memcontrol.c
@@ -12349,6 +12351,7 @@ R:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
+F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
 F:	Documentation/admin-guide/mm/hugetlbpage.rst
 F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
@@ -12360,6 +12363,7 @@ F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
 F:	mm/hugetlb_cma.c
 F:	mm/hugetlb_cma.h
+F:	mm/hugetlb_internal.h
 F:	mm/hugetlb_sysctl.c
 F:	mm/hugetlb_sysfs.c
 F:	mm/hugetlb_vmemmap.c
@@ -12379,6 +12383,7 @@ M:	Miaohe Lin <linmiaohe@huawei.com>
 R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-memory-page-offline
 F:	include/linux/memory-failure.h
 F:	include/trace/events/memory-failure.h
 F:	mm/hwpoison-inject.c
@@ -17424,6 +17429,7 @@ M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 L:	linux-cxl@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-devices-memory
 F:	Documentation/admin-guide/mm/memory-hotplug.rst
 F:	Documentation/core-api/memory-hotplug.rst
 F:	drivers/base/memory.c
@@ -17480,10 +17486,13 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/admin-guide/sysctl/vm.rst
+F:	Documentation/core-api/gfp_mask-from-fs-io.rst
 F:	fs/proc/meminfo.c
+F:	include/linux/cacheflush.h
 F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
+F:	include/linux/highmem-internal.h
 F:	include/linux/highmem.h
 F:	include/linux/leafops.h
 F:	include/linux/memory.h
@@ -17493,11 +17502,16 @@ F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
+F:	include/linux/pfn.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
+F:	include/linux/sched/mm.h
+F:	include/linux/vm_event_item.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	include/trace/events/mmflags.h
+F:	include/trace/events/pagemap.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -17516,6 +17530,7 @@ F:	mm/ptdump.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
+F:	scripts/gdb/linux/mm.py
 N:	include\/linux\/page[-_][a-zA-Z]*
 
 MEMORY MANAGEMENT - EXECMEM
@@ -17536,6 +17551,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/core-api/pin_user_pages.rst
 F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
@@ -17613,6 +17629,7 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/migrate.h
 F:	include/linux/migrate_mode.h
+F:	include/trace/events/migrate.h
 F:	mm/migrate.c
 F:	mm/migrate_device.c
 
@@ -17636,13 +17653,20 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/core-api/memory-allocation.rst
 F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
+F:	fs/proc/page.c
+F:	include/linux/backing-dev-defs.h
+F:	include/linux/backing-dev.h
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
+F:	include/linux/kernel-page-flags.h
 F:	include/linux/page_idle.h
+F:	include/trace/events/cma.h
+F:	include/uapi/linux/kernel-page-flags.h
 F:	mm/backing-dev.c
 F:	mm/char-mem.c
 F:	mm/cma.c
+F:	mm/cma.h
 F:	mm/cma_debug.c
 F:	mm/cma_sysfs.c
 F:	mm/dmapool.c
@@ -17655,7 +17679,9 @@ F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
 F:	tools/lib/mm/
+F:	tools/mm/
 F:	tools/testing/selftests/mm/
+X:	Documentation/ABI/testing/sysfs-kernel-mm-damon
 X:	Documentation/admin-guide/mm/damon/
 X:	Documentation/mm/damon/
 
@@ -17665,6 +17691,7 @@ M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
+F:	include/linux/numa.h
 F:	include/linux/numa_memblks.h
 F:	mm/numa.c
 F:	mm/numa_emulation.c
@@ -17685,6 +17712,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	Documentation/admin-guide/numastat.rst
 F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
@@ -17716,6 +17744,9 @@ F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	include/linux/pageblock-flags.h
+F:	include/trace/events/compaction.h
+F:	include/trace/events/page_isolation.h
+F:	include/trace/events/page_ref.h
 F:	mm/compaction.c
 F:	mm/debug_page_alloc.c
 F:	mm/debug_page_ref.c
@@ -17732,6 +17763,9 @@ F:	mm/page_reporting.h
 F:	mm/show_mem.c
 F:	mm/shuffle.c
 F:	mm/shuffle.h
+F:	scripts/gdb/linux/page_owner.py
+F:	tools/mm/page_owner_filter.c
+F:	tools/mm/page_owner_sort.c
 
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -17743,6 +17777,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/trace/events/vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17836,10 +17871,12 @@ F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
+F:	include/trace/events/thp.h
 F:	mm/collapse.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/mm/thpmaps
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
@@ -17883,9 +17920,15 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/core-api/protection-keys.rst
+F:	Documentation/filesystems/mmap_prepare.rst
+F:	Documentation/userspace-api/mseal.rst
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
+F:	include/linux/mman.h
+F:	include/linux/pkeys.h
 F:	include/trace/events/mmap.h
+F:	include/uapi/linux/mman.h
 F:	mm/char-mem.c
 F:	mm/mincore.c
 F:	mm/mlock.c
@@ -18724,6 +18767,7 @@ M:	Peter Zijlstra <peterz@infradead.org>
 L:	linux-arch@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/core-api/cachetlb.rst
 F:	arch/*/include/asm/tlb.h
 F:	include/asm-generic/tlb.h
 F:	include/trace/events/tlb.h
@@ -21834,6 +21878,7 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dennis/percpu.git
 F:	arch/*/include/asm/percpu.h
 F:	include/linux/percpu*.h
+F:	include/trace/events/percpu.h
 F:	lib/percpu*.c
 F:	mm/percpu*.c
 F:	mm/percpu-internal.h
@@ -25555,6 +25600,7 @@ F:	include/linux/shrinker.h
 F:	mm/list_lru.c
 F:	mm/shrinker.c
 F:	mm/shrinker_debug.c
+F:	tools/cgroup/memcg_shrinker.py
 
 SH_VOU V4L2 OUTPUT DRIVER
 L:	linux-media@vger.kernel.org
@@ -25787,10 +25833,12 @@ R:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
+F:	Documentation/ABI/testing/sysfs-kernel-slab
 F:	Documentation/admin-guide/mm/slab.rst
 F:	Documentation/mm/slab.rst
 F:	include/linux/mempool.h
 F:	include/linux/slab.h
+F:	include/trace/events/kmem.h
 F:	lib/tests/slub_kunit.c
 F:	mm/failslab.c
 F:	mm/mempool.c
@@ -29842,9 +29890,11 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
+F:	include/trace/events/vmalloc.h
 F:	lib/test_vmalloc.c
 F:	mm/vmalloc.c
 F:	mm/vmalloc.h
+F:	scripts/gdb/linux/vmalloc.py
 
 VME SUBSYSTEM
 L:	linux-kernel@vger.kernel.org

-- 
2.43.0


