Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C6FC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D236B0098; Mon, 27 Jul 2026 12:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E6A6B0099; Mon, 27 Jul 2026 12:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009C16B009B; Mon, 27 Jul 2026 12:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C86906B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:48:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E18A16012D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:05 +0000 (UTC)
X-FDA: 85035138930.22.DEAF84B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7C6AD1C0007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VrTwGW4m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKDq2jMIr/uc5Ei9JUAnG3wzd6f9OkmvklYqS/aAb7M=;
	b=orwQooOGADpxjxfO/ZPFIjIge7XID5mSTb5GLYe0gfQLIP/WfaSSloKRIEFxgLxY2uGaqQ
	RZRn2hxu4Zuz6vAJKhtWXOjkff5C0B9vvKmOx6Y2lwce3gBIdOzyEXqNQsteS/nfQaY0nD
	v565n/hP920VIdb/LQdp0msiIqn7LQs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VrTwGW4m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170883;
	b=Zvs3UIkIY3NIq6TLAvGg2UWHrVqO9jBMqzbY3wgdu+0Dp/1T0BZCdLVUUaxgdruL5OmjS7
	muwLOjkaejkDpvk0g18E0cLKEHeu0lut3sK53TEtccysS+EK2H+r5Q67BUTGAZLncqmEpG
	Nb1l7BLOTPCHVNbkn4M1WUTTUUM2VHQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F7E01713;
	Mon, 27 Jul 2026 09:47:58 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C99943F86F;
	Mon, 27 Jul 2026 09:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170882; bh=1nPdXqpMGrD8xhrtZLy0UKY4t0IJBjPnmmBVyVTpx2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrTwGW4mYDqQ+Z27OKZvmrSWlMxIF9vB8wItFBCFzOD96K2SMpyMovHX9gdNiY0K6
	 KTkZ43BeXBYATryo387K8Y/zE/PbD147zbQij+iKgrmmKw6au5gN84pjtEpgkqn/nN
	 weSnIFswO51i+rS/asQ1MifW24hm3Y/lBeLNUCWM=
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
Subject: [PATCH RFC 03/11] mm: name pointers to copied PTE values ptentp
Date: Mon, 27 Jul 2026 17:46:54 +0100
Message-ID: <20260727164715.2866609-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C6AD1C0007
X-Rspam-User: 
X-Stat-Signature: 5odjgfib7tkhsyb8aowj8f7f4w34a8z4
X-HE-Tag: 1785170883-28260
X-HE-Meta: U2FsdGVkX1/qDgfPGg2WGXqrTa+aP4PoGR2FFtU7og+lotkqK9HtJLyXuByyRshQPzM37wVesjbJovkhdsRPEyQVqhP7wgzfBzBwZ68iMS1eU4zMm+Iss4pBGtXlPoOOYjqnAPvujAMM6z7xqmMdDak3ABkzvxmwfUl1zDSTuCwf+6uM0pzF10vWaKaL0hPiLrV+k6/ua2i8T0QE1Lw5zw+1mQQHbEx9AatRjQjNk4LNQeGanzbajDonECrnFAAF5RYxoqDHFMvxsIRvDpQLu2k95lb/BVJXQBvPE+BrYo0sqcy9hPU1aHYyiYIb4s2QBwIoWOuFelJGRNoOd4pFedqJ4Ifn7DqUtWU3y33Av7TMrWtNbxQgUuhPpZ8IUHNfsuz+cxqRFCCdVMzZf9rirOOM5ShVbBhO5/gSczIXx82GX7CrYagdIoWm6yCys/kDRxcxNEyc0seKqw1DVIoUmiE6cc+RE/4biALkYDg2x0RcNk+cDsB7XdR/ACoAuL/jOrtIQsygulGy67Wv6H8d74vh9Ag4LjEVWyIYji4r1Ncqzl5NVB76WTFds+mCkXmUioDVb6fAiw06Xys/a7vu2lHqggxejvi+jNt/GvaKK+mXFaNolfKbXho/m+aJjughEd3E/3UdMspBrtP7fEiEf1xma7M6+eymhunMqy6XvWaBXKARhPVWej+kJDsLJ0/ZPMbPC6keY3QQ+Vr/iLL2xZFacaivUhV58LBuaHIvfyCwlD493cNpM9db7Alv5ZPqAn8P2JlHsJhjI9F5VZZ4TQXz2K2xL6Ti3Ysy8xLbeNVApJE2nxR5JI8z6i36KTZKl7xuQRO3SZJt5szEdPRl8cYJw4kKsk3OTRykvtASV0v85zGJK0UiFKMumIYPVNjHGLF1UGchlOX+5InOuokS+/KJDjKV51X1Lt6Stsj7yD1rT+ic38HNy7rANAu5Fav7VJyxQGRlKAzMY2xW/vG
 c3rIP0Bu
 ZTMMC2hGDcFLqrFKp8nT4fC46FrFtsjO8UpIQlH4+ASoxkWcLcEBR8unJ4hR94yUdYBnZwQYoGriunI6k0N7lwEAqdqB8LgrX3GWsfEjTAshNv+RlUTEc5qQWAkzzp8Q1B9F2weYd9BRxAwmPtrtSCCXIe2f68TAu/ttI1c3vPMKkWNzhsP7I0eNm/uMeBSQQjP2TJNeffU2CHIcU5AcrvD2k+pFKS55d1lXGHWHKjxSYU4IZe+omUyyrO1T8wdfj+qpAW30VwoC+J5RNDjMFXjIsf92qP31d7Spsc/cm//ER6VaYXJDfvu2WLbJSEDx3uaex
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
index b9b32f7bfb691..c41b2c241bb09 100644
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


