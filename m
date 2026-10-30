Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF91606A323
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WTHyEEbc
Received: by kanga.kvack.org (Postfix)
	id 85E776B05BB; Fri, 30 Oct 2026 17:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836596B05BC; Fri, 30 Oct 2026 17:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C356B05BD; Fri, 30 Oct 2026 17:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1016B05BB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:36:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2DAA120833
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:36:31 +0000 (UTC)
X-FDA: 85380601782.17.EAC5008
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E0CFC1A000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:36:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTHyEEbc;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5gGHYa8/3ZSDrDzjG47LXEHqwXjR4aNi9uDI+Wl1v4=;
	b=YFY2noeKpcp+vtsTJxvnRgW819QO+PJH/eE9S3+wRDI6bmjW6BHADV5yxAdZRZw7X4Hmwx
	5ZzsSqJK8P76rSAqdWQ7RIyTgWD/w20bto9mechwpsFnDSusIEPtpnzx6ZOXEICuxBE+Ts
	28brwOgYoGmuI6Bp96iWPDSfLiDq75g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396190;
	b=W3cVO1CnGWPSgvo01ffbh2F1SP/B3eVGjs23Npysa9vxf4LcQVDO+XSoe9K68pQ23A7vW1
	UhJAzWH+Mek71DKQwc3MUU4OuzafD11fI2fGOAOaVXCijN5erTx9Dy2jcgJ25ZtKf94+5Y
	+j2ybI3rePb9fbp9wT0iZd2Mud2LzEk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTHyEEbc;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FE7441FF7;
	Fri, 30 Oct 2026 21:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0750B1F000C1;
	Fri, 30 Oct 2026 21:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396189;
	bh=T5gGHYa8/3ZSDrDzjG47LXEHqwXjR4aNi9uDI+Wl1v4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WTHyEEbcbegkAzQNqS+qLh6emD95B9J9wVKGhDIwcgWf5F8lJWZdfyI0EIGx7t0PA
	 CLIrl2pGpUQymS/G96WQ3mOODZzMVRcCTiS5mFhNQmSyVWOqwN+OlY3Pkvjckp8bgD
	 WyjUfPjxuE1XOeckTK3s6l3nebvEDikF4qBk97iTUUJmy9fniGx5C4VZ3XmP8maIRU
	 /vUYJ9Z0i/IWL6pFcvmDFXr+B1vWrob7wjSHre7K/9bz2BEoOmyr7IJxS/55+NjcAk
	 9glhknNOZ13YewU89v0O7eRsFn6UVLINn1nxkzndIE8WRW+pfZqVuFiv3kuMiw0ArJ
	 +S6eAtGEi6Tkw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 30 Oct 2026 22:34:31 +0100
Subject: [PATCH 7/7] MAINTAINERS: route more MM changes through mm/core.git
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-maintainers-v1-7-97278f8a5f54@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7103; i=david@kernel.org;
 h=from:subject:message-id; bh=Dx5n2gC6vMVcK5ExSX/u5sA+ugWevXNulOkIL7Nyokg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKe8ubJuxixPY+ZK/eQ45wOxwLexuppvHkdVYb5TawGN
 ieNJed1lLIwiHEwyIopsgQF3zd4+XJdbbUbHzPMHFYmkCEMXJwCMJGlxYwMXc8Z34qu1/BuSZZ+
 vPlXdfaqZz/qpytv5OS1nlC5wuXQPkaGn/dDV8a8Sxae7/8xh+/LZ6YTF84FLQtXWy/M7qpzn0W
 bHQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0CFC1A000D
X-Stat-Signature: kwser3fisdz6isyr69esgia5nwjmeuyx
X-Rspam-User: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793396189-555930
X-HE-Meta: U2FsdGVkX1/Un9Xtsms8TqB5eQJVy+DUPOARVOJqFEwld4C507SeiYkdIML+c2YR6768vFD6n629p2pypscxoec4Lklgvv7f0NQG2xhd+zY4fJ0+kIPezV+oTT6BsqUb07KWa6+whtV2NZKJWG/nE8RNgfcNHdpJlYRzaeoDVr+k1RJiM8dFi+d59lCyJAj8HspzhT+Fx7q9C8yX4+Ru07nSeSrR1+02tffAuN+qxIgx2i1z8F3Aaq+lWdA0TxRpMwMx7xeANUFPLu+lHtAeJ2VEVC2mp7yCXKftaAQ28yAOEnX3P2tNM7SHMk5aGOJsosBfOZoVtkyJjjIIJ3siIoBMUWScJc6mYWLWz/cPg1FkcJ9LyK/uo2KM0mPrDRCTK47XzZp2Ax8py2F/F0eENCJ2Y5uebC/rSfFjtB0mFavknA5zplYV7G/56vBeK45t6LqazwScRj3XHSuvf7hv827HEhQKvr2ZmTXLqTRqHb/+bxd/yBhHEAb08MsU/uS7OmLobLfxV3ZKnuT2ELvBAybZFolfmygZaQAlsPFqvsC2R7jS6fQREZSN2D5PV4ZwfifQIomRHHiGaUapTtQMB8yKtv/0WwBJxArGTCX3B/SV7UvS/fiFO7L8Z0As528z2pJ8swLX7vmwV0Y4lc9EbwA1yPYiS+zpiDlfAplea9xI2clZ0PRK0+YWwTnzOPqHFkwJrWgQVZCsVXYswSZT07+7WYso+kaQzArKWUIqVlRXfinHpUSYiQdJ39XTd6xjYE3/YE5IEpbwmFZbg/xctfwOIpuISjS5VgWJHV/rttm+eWGASGMcYXeM8H6gQIWlJsqZqQ4KlcGqGw0UpqeRKrXk7Cr718t1S1Vp6WVeB+Dybwf0k+9pfG9r1xhRq8+PQgXj87oqXdpmGo8Q/iZ7UddsltiCizI9g/Th+s/3E+/M/q4ZQ1sYrLKbvNKiqGgmusuZPigYpRuWuXHlB7l
 U/8g+0PV
 +Mxz9aKkXKCkggA5ZOyxBJod9ePie5QwHdPDGMe+52WO8g8VudUNySD2Z4BpWpBBJafXcAjolRF7B1Xbo8Imic2XmM2HSyFPJBqfqtfAh1t+CjEnyIbjaW1tg9NLO16gDfY4hX2foeBXm7DOi6pTpiJ1aoNs/JyWxgMgBy+pRwYPJugiRxHYjt6rP0OhfDJdPrsPU4JxhhAihENiDhP6eEkNgPy+/BlHAW6Tr/ts/mJfz8cpDUCYwMRb96pylbbPjOVPi0rCmpEd9mO+RIke8FKiktRhnFE/lf16V/+Wn+NtyYBq4JXV+F+F5pKs7bu9QIC4VSQXPtdyC/qQBJkwu7ANEOzojRQ31ijRp6pin61RNM3Ju/mD66aFIzb2ekSBqq+SnppdtywKj7EQBjf69zFLgg915/NmeEkBEplhzmnhC8jMBiP6cPE4aFD4C9IVUQIz8F9fECnTD50Dy1Y5wp0fOQ9l74e3eXAkdNF1XzY4qSPnZO7euxq2a83Z4+QIC51/Glh26mwvGTFTsqOVYv2hkoDkqZ2KFlBABCTbFq4wlnIEYl4nNNqrzt6peSbpfz+fELe7gXHrKLjb8CmgdpSAmgGlf4BfXeEdHRjsFQYI9+9/zXTRJQp8Z1RAw3RN9rCrS++JYQgDvGnlZ3UVVa4dMHtkQE79qZOEToZm2eISVR8dIL6lrWm8moNu9150ozpp4rcjjuMN3jKRLn2DMKTm3VtzkHNNDTHgYDSj82NZ0uXcGY+wae8Dxx+tHrtpqtTXIicIYXXD5NDXRQoZ3jb4L/bBETQo1iazeg0wVMdKm1kilWDqqyyKK/BxxM1ehWrWRq7TkRymUXlFF02TGrZ1zx+9KYWRX07TGEQdFsAcr2/cppTG8x+qLOh7Yh7FQddsrMA2W2Jf2IplTODCPd1Kkaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Let's start routing more components I (co)maintain through mm/core.git.
Update the git trees by pointing them at the for-next branch:

 - MEMORY MANAGEMENT - BALLOON
 - MEMORY MANAGEMENT - CORE
 - MEMORY MANAGEMENT - GUP (GET USER PAGES)
 - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
 - MEMORY MANAGEMENT - MIGRATION
 - MEMORY MANAGEMENT - NUMA PLACEMENT
 - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)

Leave out MISC for now.

This change doesn't imply that all changes to these components will
immediately be routed through that tree; in particular changes that cover
other components, or severe conflicts will require coordination with
Andrew's tree.

So this marks merely the start of "mm/core.git will start picking
relevant material for these components".

Remove Andrew from these components to set the expectation that he won't be
the primary person picking stuff for these components; he is listed as
maintainer under the generic "MEMORY MANAGEMENT" and will get CCed on most
changes, and can keep an eye on stuff that falls through the cracks
(thanks!).

While at it, drop the link to http://www.linux-mm.org: it's not
particularly useful in 2026.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0adc674304987..b68bc36267091 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17446,18 +17446,15 @@ F:	mm/alloc_tag.c
 F:	tools/testing/selftests/alloc_tag/
 
 MEMORY MANAGEMENT - BALLOON
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 L:	virtualization@lists.linux.dev
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	include/linux/balloon.h
 F:	mm/balloon.c
 
 MEMORY MANAGEMENT - CORE
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
@@ -17467,8 +17464,7 @@ R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/admin-guide/sysctl/vm.rst
 F:	Documentation/core-api/gfp_mask-from-fs-io.rst
 F:	fs/proc/meminfo.c
@@ -17526,15 +17522,13 @@ F:	include/linux/execmem.h
 F:	mm/execmem.c
 
 MEMORY MANAGEMENT - GUP (GET USER PAGES)
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	John Hubbard <jhubbard@nvidia.com>
 R:	Peter Xu <peterx@redhat.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/core-api/pin_user_pages.rst
 F:	mm/gup.c
 F:	mm/gup_test.c
@@ -17544,14 +17538,12 @@ F:	tools/testing/selftests/mm/gup.c
 F:	tools/testing/selftests/mm/gup_longterm.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Xu Xin <xu.xin@linux.dev>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-ksm
 F:	Documentation/admin-guide/mm/ksm.rst
 F:	Documentation/mm/ksm.rst
@@ -17566,6 +17558,7 @@ M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 L:	linux-cxl@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-devices-memory
 F:	Documentation/admin-guide/mm/memory-hotplug.rst
 F:	Documentation/core-api/memory-hotplug.rst
@@ -17614,7 +17607,6 @@ F:	mm/vmscan.c
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MIGRATION
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Matthew Brost <matthew.brost@intel.com>
@@ -17625,8 +17617,7 @@ R:	Ying Huang <ying.huang@linux.alibaba.com>
 R:	Alistair Popple <apopple@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	include/linux/migrate.h
 F:	include/linux/migrate_mode.h
 F:	include/trace/events/migrate.h
@@ -17698,7 +17689,6 @@ F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
 MEMORY MANAGEMENT - NUMA PLACEMENT
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 M:	Gregory Price <gourry@gourry.net>
 R:	Zi Yan <ziy@nvidia.com>
@@ -17707,8 +17697,7 @@ R:	Rakie Kim <rakie.kim@sk.com>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
@@ -17782,7 +17771,6 @@ F:	mm/vmscan.c
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
@@ -17793,6 +17781,7 @@ R:	Jann Horn <jannh@google.com>
 R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	include/linux/rmap.h
 F:	mm/interval_tree.c
 F:	mm/page_vma_mapped.c
@@ -17850,7 +17839,6 @@ F:	mm/swap_table.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 M:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
@@ -17864,8 +17852,7 @@ R:	Usama Arif <usama.arif@linux.dev>
 R:	Kiryl Shutsemau <kas@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
 F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h

-- 
2.43.0


