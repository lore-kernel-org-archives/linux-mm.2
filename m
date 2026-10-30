Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C32606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oYQQpvIB
Received: by kanga.kvack.org (Postfix)
	id 3C8F46B05B7; Fri, 30 Oct 2026 17:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0C46B05B8; Fri, 30 Oct 2026 17:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FD26B05B9; Fri, 30 Oct 2026 17:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE5EF6B05B7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:35:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CC7E807AB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:35:51 +0000 (UTC)
X-FDA: 85380600102.05.89F7520
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A1125180004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:35:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYQQpvIB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/LfQJ1TJsio8yhVdZU1peotIELVQPC1CM6M1FIq84k=;
	b=LMIJsgCKnLC0vDk31ceF5D2VD8JkxRvPeqOXsuowHVFG0pT5KAy01YBdnyGN2pudSdABRH
	0poX8zbLKyxmJEN1EwJxBx8q//SdzYOdi/4Lt9Jra8CzjfGft0MfcQ+z96F7Ri9HE0x7mi
	WC5XM26DZjnyFmhmv0GlZO3MVg0H3a0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYQQpvIB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396149;
	b=h3oN6WY5bl37fb8Essgz+ZxYw+Agi2gRB3SltvQloiZWzEACSEiyQftX1kokjWboe75eKB
	kctIZH3FcuSNPK4IiSnPMS1qY50khXBPGw7OhREaqdWeIxtBqMBtZVTkhwjGf0BBwqtjU4
	LfvI2Au/tgFQTjkROyyaGNwqDMnljHg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC35D41724;
	Fri, 30 Oct 2026 21:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C031F0093A;
	Fri, 30 Oct 2026 21:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396148;
	bh=6/LfQJ1TJsio8yhVdZU1peotIELVQPC1CM6M1FIq84k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oYQQpvIBGQvzkEBOrWpRz+XW6hHjJYe9aB4wSQJ1UGIRnk/mzJHaOOrLcwujR7dLh
	 qrz+Ca8ICmXyT9Ho7KWa2s9QIsnuwcbmq63DD+JCxPUni4xD6+MLu/XyVR1qJBW9VK
	 3zK1IB2p8txSC7Q0ZCbJCQyQ9xQJEkNtvXpb1DcSL8EZaTfsz0IS9muLO+Snm3I0kj
	 HSLxCoQlfK6FPOHyCOd0zzV5VOfZHXxnawej6+G1CDdFU9uiCETytCK0tsj89dpN7F
	 tBFFPhsZOMQpB2SZGQjnsFjodbr/HRYhoPlpFF4812O7jhZZhX7X2z/knFFLBzoSqZ
	 7OMK6CDho9c7Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 30 Oct 2026 22:34:28 +0100
Subject: [PATCH 4/7] MAINTAINERS: sort entries in MM sections
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-maintainers-v1-4-97278f8a5f54@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3448; i=david@kernel.org;
 h=from:subject:message-id; bh=XPzkNHx34lg5uSbAutRqCm9C+R2SNyW16o9VWM8IMHA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKe8ubt4mNzXnpcxdT+6Yqt7976+bjob108s6Tnvf/9j
 9Ze85zWdZSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARzvuMDBu0g5r93ps8yBSv
 ETmnuTJz27OEo5mJOx+vrGwutFLIkWZkONU3+912JWPO58mR89qmr0oxzzhwpLPmRkq3wusLPnJ
 vuQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: A1125180004
X-Rspam-User: 
X-Stat-Signature: awug4ao7o556g1675ki9ryuswuq31nwx
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793396149-713881
X-HE-Meta: U2FsdGVkX18Jun+rKUPyoxaTha02IOOm+u72tfiSHjUHA7MksgJHRrroHaNy5V0TR9UXRqZe8j+qK8vAGba2wcTSCOraLgoc9cicpCCgrBwzl3XnjvuNQ0XcJfk6MVEmgzFG96Olg5AaVw772UtCUGGTGOBb2SMdwan01jRGT6pyChMqFcm/nv/UonWqKSto2YetF2bYsD2wfPBheXpCszSxiPUAea0O+PseIpiKOdt/QHh7opVgqgj3R2N9+vCS1r5iFHPfCLJRcUFs7THSq3UX8spE0erF6N0iXm3ftDbwLlDugBAl3mPZ0j+U+ANdwYIrFYd6hUbueGkPt1OWyGywekdTACUW0b/ELvXw0d2d84Dzny1hKqygIEi0srI5MaZXnGtUBShxdS5xWKSb3lJezyGJqlV9nVBCfTHaHtkL3i8p+7edTUmF3SkmRDiHWye9Aa40utHE700zoxlgo1IdaJP1jhV3bmKm/Ps3wLhop50YEiXC83geYGlXJPnh8Kot6P1cVh53C/Xxiu8Dh1zUBVZfEeEoGNk84z+sThwGVG9WML03Ls5mj/XJkjZ8r7q9jMTMq//5sIjwhLx+3ejRPTu7rtt/f13psRNF+HFO/oaUzpCmzZRJBa5TR5khbAe4sNpYssc57YSGODu6LIkXQ3EJxx89W1Rf9I1D5MIilOo/msK+xqG+xzzEOthRty37p7yROMbi6eW8tib5+Oup+jCOcYoKWsvSuwBi4cdImV/Kt40TZsjQjUuJcN3MxBCleG0CbW8IYT475T01zV68X5ABMeJhzb3p1NYjYtRKdGAVxzs638A+5aCxVBeS0Q7q4jqXw/wl9V569vKQsnEZq7ukcHxP1d5fvKjRjf3kNjGRIYF7tJUIrFSot2Ekftihi6vksDprjSLgd84gJURFmk2wWyxMR26Bd6j+7rU7bZjuIsMjypzLXG/TvFEH2m9VsjCDqyH4AvzDFkL
 jNwBt2kG
 VXQMzP8zW208VkS4mekXovRd1erm2UdpDGcPg9Q0Yr+0srr2DRuVATuC4xqF3a2KaZ+zFiAfVsZrvEy32dDD/g6tv1EXc5YbtKqwHTY1JvZNrAkFTta19JCQPSRAXCiw6uhvFNT8mITn+ebtXuEmwQACDs6LqRGC5A9cQUWVdo+lI++M9wdWYUG7od75HrkoPpBVomO1PFgR1yZsJcAZ6gxKuQ2ogVg5VPbLVa6kuY7TqoJzh6T3U0MT1W7+6Igr+aQhwGFHC89+9xD+e3YXN1D4gh+jvHCnEEcht9q4u/YCQCACnVf9M+jrrlBR0TZ+85gWy0oz2tJWky/wN5/JtGzcSZMrI965xtO/SMsjC6IrH8XaimbrOfuwH844fQJrHXZBFf6DI2Q2T8hU+YYF2seY2PmmqyQdMkNK2mifs/cyMeRN7DT4FhqZKj9U5BbrLW3qwrum5HtsqJIMhjlS8GI10ZPR2smUhw7oe5/XTSh2CjXDUT7cT5HmcDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We try to keep these entries sorted; let's sort the MM related ones.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 02b5b542f81ee..bc82ef545e0aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6843,9 +6843,9 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/memcontrol.h
 F:	include/linux/page_counter.h
-F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
+F:	mm/memcontrol.c
 F:	mm/page_counter.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
@@ -17429,8 +17429,8 @@ F:	Documentation/core-api/memory-hotplug.rst
 F:	drivers/base/memory.c
 F:	include/linux/memory_hotplug.h
 F:	include/linux/memremap.h
-F:	mm/memremap.c
 F:	mm/memory_hotplug.c
+F:	mm/memremap.c
 F:	tools/testing/selftests/memory-hotplug/
 
 MEMORY MANAGEMENT
@@ -17480,6 +17480,7 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/admin-guide/sysctl/vm.rst
+F:	fs/proc/meminfo.c
 F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
@@ -17488,16 +17489,15 @@ F:	include/linux/leafops.h
 F:	include/linux/memory.h
 F:	include/linux/mm.h
 F:	include/linux/mm_*.h
-F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
+F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
-F:	fs/proc/meminfo.c
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -17636,14 +17636,12 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/core-api/memory-allocation.rst
 F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
-X:	Documentation/admin-guide/mm/damon/
-X:	Documentation/mm/damon/
-F:	mm/char-mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
 F:	include/linux/page_idle.h
 F:	mm/backing-dev.c
+F:	mm/char-mem.c
 F:	mm/cma.c
 F:	mm/cma_debug.c
 F:	mm/cma_sysfs.c
@@ -17658,6 +17656,8 @@ F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
 F:	tools/lib/mm/
 F:	tools/testing/selftests/mm/
+X:	Documentation/admin-guide/mm/damon/
+X:	Documentation/mm/damon/
 
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -17810,8 +17810,8 @@ F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
 F:	mm/swap.h
-F:	mm/swap_table.h
 F:	mm/swap_state.c
+F:	mm/swap_table.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
@@ -17883,10 +17883,10 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	mm/char-mem.c
-F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
+F:	include/trace/events/mmap.h
+F:	mm/char-mem.c
 F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
@@ -29842,9 +29842,9 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
+F:	lib/test_vmalloc.c
 F:	mm/vmalloc.c
 F:	mm/vmalloc.h
-F:	lib/test_vmalloc.c
 
 VME SUBSYSTEM
 L:	linux-kernel@vger.kernel.org

-- 
2.43.0


