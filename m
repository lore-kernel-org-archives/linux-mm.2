Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E78FC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E57E6B00B0; Thu,  6 Aug 2026 04:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC1B6B00B1; Thu,  6 Aug 2026 04:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABE26B00B2; Thu,  6 Aug 2026 04:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 374E86B00B0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:40:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A859340141
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:20 +0000 (UTC)
X-FDA: 85070197800.05.30072CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id D5C17100011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iRLwcLlH;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngeUB2KCjAQXxsxBx3g07fSkAsLkDkHnzZbTKWnZ+6Y=;
	b=VRD/qW+Q41MSMkVZI54xp9Rt9OJ4MW+qK4mIA9YYkW166vv52P47E6z0oGh+6dzERqHoyK
	u5RIvMGn3FFay02lU1I+G6qt6Yh+sbTZwlY8Fp9xeU/gR+q5qzs8z90m8MA41YI/rVS99k
	FLzmPGpUH4ojjG2tp2knANYlNniSXlM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005619;
	b=HkbLcuokblizXCbdaf8lSKI1sVCR2VKVgseIFKziPTm927DlRe7xmYnGqIl3MtFb3aq7Nw
	4xYETA19UOIOyD4VUGVp4i/t90LpxKrZrAhoeTmeGxZj5Fh9HOOVowLhdhw9SsbwJzPuSl
	pVdHu+2dtWA97T9fksjsbeneomp2PA0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iRLwcLlH;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8879176C;
	Thu,  6 Aug 2026 01:40:13 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EF03D3F632;
	Thu,  6 Aug 2026 01:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005617; bh=kDSHwmzLBaSmEkZSi49/oE6mr/pQwSNTv0JlBRbim1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRLwcLlHzWWbx5Qhr2Q5N2yfBSglhNBHPcd7h0s5kOdYERPY7KTBCkBr+hcYbbhK4
	 U8v8vfKwbyB14RWAIzfzO9dXyKyK4cPchCL93DUg0JYZDnVP/bmKmDJDFD/ZKVGJnS
	 ia0P1AlmZO2FcO7EoUGQ6dM9k9gIa9RXeahhrylM=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH 3/9] mm: name pointers to copied PTE values ptentp
Date: Thu,  6 Aug 2026 09:38:41 +0100
Message-ID: <20260806083926.1807279-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806083926.1807279-1-usama.anjum@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D5C17100011
X-Stat-Signature: ftmfokn5nsubmddt63wckrpg9w13ufkr
X-HE-Tag: 1786005618-373917
X-HE-Meta: U2FsdGVkX18qR8XuslpKUfDy898alf0Wjmx0yz8rojNo+wu2+ns9f6iUQbU0HNz7PJKr86NBcDZT6x6Uk/w1YprJ+qV8uUOa3T2Vd1q10ryyfwmArGbqYpI9F0ZYAevY5XRtJwlHbTJetJRnuMyEJNptH2QQKGgN1I3IrwdA4t7s3NM8ALF/XaknS6nzit085nXylHllMiWaWSL4MKnL7W6CtyEnOPATRmLPjbbf599tr1UpSpUxf64KMLAyFSJUG7Y52Exw7Ncb1AAHIfW1FG5giVtXyJKHXVCyrO/HQkNz79Jl3lKkbs9PieLYK3iWNpezeF9rbrl9uj/qvokWmiQNJFlipavSLdl/7VNSqPhwBMdVfq0ShxCAq+5oA0puRs/8giBG8erJOSgX7HMO0EVFA3ZLBH2suwQGLa4kS5JIsMmF6HbcyEqdt1La/6jJUz3gD3Ft75QtAEixxOboCo30ReTtsWLPCgdvgr0FPUQolGQQeQQPHhdQgGQmj7Tv6TMGvwoAdD3yPXVpwPmEVDO46PKwSqBcP5X9VCnXNHYIv2qu2olvvQipIz2Zv5XgeNpf5U1WLhvo25NDeX0fklEblb6R5AxSqPCGz1rN5fdIPXy+QQfuxSyxd161xb8X6WPCBzx1qNPo4e9cK3zrMCc2sCyLlX82MoETFA0OIR+IcVzb84fb+flZ13c6T/jpCRTug8hm5dW/oUJQc0Ksyn3T4N19vuIIwrUw51x+glQPv7mbl+eOPhXIVJ6bO5uaVhsIX3EjPsR2Lolbrjc0TWUuVhlDvUkiaDDpkYXWCiye4fletI87sZ9QW4N5nGGHoh3pUEDFHOvwVH3P1+/nOVaGxwRHEmmvwupKwl7S/no2zMjpHSvAa1NoEFs4OyJ1mBUwBYqUlOqlgTseXanW6emmW1s4RoElD02y/0ck9kSRQDAFNbzI4kB0L5zHLgra6wltl+aDcf/wm4zFbJV
 zviv/9lP
 dSj38T5IQmAre/o/aCzfL0pWPYCBSWyQVdpmp/YHNXnyyIsOHeHa9VRpqxMBOdRS2P71ceOSbU8Th8XjO4CjJ37+ZSub0u1o9mwDQy1k3hEN0VYvDz88pwcBQAJ877WCv/YshYzVYpdP5ojdeBhRtRb+aNToE3SNe2xDRjuC91YnOVNyp7qnonijTOwRe9XcK1OXM/TwKf7eYsFN3neZxEVRlchmKVcXkJ7uzF81s3/Joe7zsm4Qy/QBd2GaHcDRfvdX6ay2G/vB4uV70GlX7NG0Hxj4BK4+MEiwF3z/BWqXlkE50m7hSgc6+SRD7quvcNBRu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hw_pte_t conversion must retain pte_t * for pointers to standalone PTE
values. Name the value parameters ptentp in the install_pte callback,
write_protect_page(), and guard_install_set_pte() so the later mechanical
conversion can distinguish them from pointers to PTE table storage.

Some functions already use the ptentp name, including:
- madvise_folio_pte_batch()
- folio_pte_batch_flags()
No need to convert them.

This is a naming-only change.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since RFC v1:
- Update the description for the architecture opt-in conversion.
---
 include/linux/pagewalk.h | 2 +-
 mm/ksm.c                 | 4 ++--
 mm/madvise.c             | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01bc..c34d826c5e4a2 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -89,7 +89,7 @@ struct mm_walk_ops {
 		       struct mm_walk *walk);
 	void (*post_vma)(struct mm_walk *walk);
 	int (*install_pte)(unsigned long addr, unsigned long next,
-			   pte_t *ptep, struct mm_walk *walk);
+			   pte_t *ptentp, struct mm_walk *walk);
 	enum page_walk_lock walk_lock;
 };
 
diff --git a/mm/ksm.c b/mm/ksm.c
index ad05d7791307e..11d50518d02e9 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1292,7 +1292,7 @@ static u32 calc_checksum(struct page *page)
 }
 
 static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
-			      pte_t *orig_pte)
+			      pte_t *ptentp)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
@@ -1371,7 +1371,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 
 		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 	}
-	*orig_pte = entry;
+	*ptentp = entry;
 	err = 0;
 
 out_unlock:
diff --git a/mm/madvise.c b/mm/madvise.c
index 07a21ca31bad4..c324cc991f841 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1101,12 +1101,12 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
 }
 
 static int guard_install_set_pte(unsigned long addr, unsigned long next,
-				 pte_t *ptep, struct mm_walk *walk)
+				 pte_t *ptentp, struct mm_walk *walk)
 {
 	unsigned long *nr_pages = (unsigned long *)walk->private;
 
 	/* Simply install a PTE marker, this causes segfault on access. */
-	*ptep = make_pte_marker(PTE_MARKER_GUARD);
+	*ptentp = make_pte_marker(PTE_MARKER_GUARD);
 	(*nr_pages)++;
 
 	return 0;
-- 
2.47.3


