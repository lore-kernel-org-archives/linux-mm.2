Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E73C5AC9E
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27E946B00AF; Thu,  6 Aug 2026 16:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F7E6B00B0; Thu,  6 Aug 2026 16:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8C46B00B1; Thu,  6 Aug 2026 16:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC02B6B00AF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:24:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 821B11C0598
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:24:17 +0000 (UTC)
X-FDA: 85071971754.03.5BE80DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C94DB2000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:24:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3XXj1bR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786047855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHeRoJJr2O8/TaKftY2r1DUlL3KME6EykG7g/IHvkjk=;
	b=oHLhH6LNcVXxbgOQgeoKOwvdujCEHo2n3I5Gfw9MV1nDoXibc0zZqepOivIn/xG+dWFnzO
	z5ZJKTnbxofZbPYiolfvPOv0Gj+GjrFGZRuRcY/gyvh3Lb4UnEnagjhVX5cJ9VT6I8Zt7N
	JR0wgntoCuDo17u3yfkjIz1kxxAxO48=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3XXj1bR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786047855;
	b=pqZ/kYw1NIex1K+eyuy5UsW1v3aqkz2EtquhNJBjr1pavY6HkRvRPraTodvC5+LxITzCJ3
	R2KSpiORzwMWyGW9K4Jz3Rild7p5HM9qHGk/JJUuBvy5t4mVrGulAKRMGQndXzSh/93Jff
	kr+BkomfApae5PbsT+S72FhQHF8W9n4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51D43600AF;
	Thu,  6 Aug 2026 20:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968DC1F000E9;
	Thu,  6 Aug 2026 20:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786047855;
	bh=jHeRoJJr2O8/TaKftY2r1DUlL3KME6EykG7g/IHvkjk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c3XXj1bR+rEnT/BtWc8+4gCm67erHhtNx3GA6VFgwz7w6wd9mgBBiUlFHxXfVKFWT
	 dRICzU7QXVIfwJ0It16BrNMvwYmDcmcTPVxZd4SkL8I0srdUVisQY3iVzu9wvtjNpx
	 3nSou3Ft5lfOAKOrEZA1Kpf6oMwXxduF4t6pFIq36xignbklTqXkWzX3dfhIrw82eO
	 uTuNgn0IBkUtm/OhbB8lCWXCWfo7S88g/u2duMieT+zuKi+4pmAZVxWrxw31+h7V+W
	 3fAnT09aQlkK3luL0Xk1M16c0/D35GAxaOJ7psGpSAGE0jXpfsN2zLoCXNCr9tJnXU
	 MRs6a0OcMRtXg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:31 +0100
Subject: [PATCH v4 06/20] mm: introduce and use vma_filebacked_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-6-ab318a350404@kernel.org>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 syzbot@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4971; i=ljs@kernel.org;
 h=from:subject:message-id; bh=p77ev8vuIe2NzptTm2ieSg/F7FGTlLmZaKMePPxwgJc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lwQj8zp7dmw5uymU93/Iyymd3OyGpzNXZPPs+/zV
 7nXN6Yt7ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEzqkyMnzjO6+7V/Tgsf+a
 vVJHTzRwpWQ+a9RrcnmVY3thc7Xa/x8M/8uOFm1U1vtsb1ugcMNfVPMv1+eO5Li2H8f+vpzEwZV
 7jAMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: tc4tu7jbby4pchjuad8c3pfdfezbfygz
X-Rspamd-Queue-Id: C94DB2000C
X-HE-Tag: 1786047855-159436
X-HE-Meta: U2FsdGVkX1+tDvuzCuXtzaT7rYbmfljcaDxJofMvFLPTqE6JnHc4LlKoUUxicjwx1lQwPRryXRMosHEGNrYx0YwMyPE/sIps72tCKoxsXey2XeaIQfE5wH2iWhZG1HNNvcFZy7dxpG7NaH2C5rLGkVNYIRkJmyiIjDpiGlCDQkTFBpInLyRfioHi8q1P7M2U+9YF+k7T9rjsl6G3CFFK+yIYxDe5dODu4FSatxlkZ1vsbco8i7Evvwc2U6Y1ktD0lXFLDA0ble7EzZkPUGBcIgJgtVhN2ejdOIJ7/XFB3A7LuOkdAb0qqZ/gfQ6K+833wL5y0KTs9IwZQe5hY9d0sTfxeTnLft3j6Wm79dxJ7rfUCIvAke/B8Gdk/3reZTxd2jho9vRhTmeQlWKshpksWBn+S9EYJos0ti+MNKgvmi+K3vrb86VuxK1HmZZeoISYOLi7EnHrp+XUSSA84LhjFe5JPAxqRNb3Exd8UfJU8qZQYlc9mZAis4CkgSx9L4YELmK6EvlXRmboZD9p0T//ojDTkX2C6QjMTg0xWe+iIrfsDVvkTDXhIRwyDPlTPp+mDfkrZFvJ/yANoYqr2vKr5uha2UArsQl0JS51iTZ7YM404XlEg6kNp/FYdzk0MZqGFqGBZqAr9W0An+h+7280M4uSkdMuTCF6tThRrttvSByeSmWjgX3Vu4mIkY0WqgPxYGd+940ZQ8nmQDsmE1AUjyu+ae6J4E8GHjIWrnnKofzohmQl6NvmeTCLp6ruzwmHs+tCCnbH0cA3Q7UqYPL+IXN2sjXTj3YQMpX6JUf9kPjjQ/B7ry55H2ZPxT4HS5j/38PtUBFIkOXu5vhYF92+9Uzt+CnhrAwfrMKqpAGheFKgamD70JRgprwd7SEsVgcwq/jxpZtKYwb1UA9/ULLzgmsvOKfWNJrG+obKGH7v36UGPSnfGVvr7r56xDM/UCWyqqfZ6pIA/afuUXGyhzG
 3oqb1hrA
 b7rI0kkthFNOzUdG6n6RndH1IvYSspM8tZBJai8OABlFCMncUfY7/VWGPHev2CIHvTEs/1yrW7KvrJ1EA59NdcTkR8zFQ0HhTqYbHQfW03pDbuAY8HrPShcKjR6QqWBjSHXIYopYPZ4PrhbEAt/xJBdrVaubsp1SPy95+6RvIRQ1mGkRJ+As5izKC1JLz5iGF89WDxYS5AwPA4jO72+ToZJymczhjb2m2/UQ7lYEmuIrwlSOLtLVxxp5ZWRRYgT7wv7UvQ1OoY7hLut3fkqbCrGF/olufaNjCnjSq2jkRllYStbuYPSRQEfHZAw96pwpDRuLujj2jv3p0NdE1hn+lPe5WK/ghtH/QtQbCHGM5bynMuU+6ge/C4s3MqNwNv30ADh7+Ivq/K6n5EQ5fm1WxwybretSp/Km9BKF4jLVS/tvrq/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cases where we know that the VMA is file-backed, use
vma_filebacked_address() rather than vma_address().

This lays the foundation for using the anonymous page offset via
vma_anon_address().

Also add an assert to ensure that the VMA whose address is required is not
anonymous.

No functional change intended.

Tested-by: syzbot@syzkaller.appspotmail.com
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h        | 18 ++++++++++++++++++
 mm/memory-failure.c  |  4 ++--
 mm/page_vma_mapped.c |  6 +++++-
 mm/rmap.c            | 10 ++++++----
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 10b6662be8ed..03145b8d0d56 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1025,6 +1025,24 @@ static inline unsigned long __vma_address(const struct vm_area_struct *vma,
 	return address;
 }
 
+/**
+ * vma_filebacked_address - Find the virtual address a file-backed page range is
+ * mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff: The page offset within its object.
+ * @nr_pages: The number of pages to consider.
+ *
+ * Returns: If any page in this range is mapped by this VMA, return the first
+ * address where any of these pages appear.  Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_filebacked_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, unsigned long nr_pages)
+{
+	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
+
+	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
+}
+
 /**
  * vma_address - Find the virtual address a page range is mapped at.
  * @vma: The vma which maps this object.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aaf14608b30e..a8b03e2920ba 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -620,7 +620,7 @@ static void add_to_kill_fsdax(struct task_struct *tsk, const struct page *p,
 			      struct vm_area_struct *vma,
 			      struct list_head *to_kill, pgoff_t pgoff)
 {
-	unsigned long addr = vma_address(vma, pgoff, 1);
+	unsigned long addr = vma_filebacked_address(vma, pgoff, 1);
 	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
@@ -2265,7 +2265,7 @@ static void add_to_kill_pgoff(struct task_struct *tsk,
 	}
 
 	/* Check for pgoff not backed by struct page */
-	tk->addr = vma_address(vma, pgoff, 1);
+	tk->addr = vma_filebacked_address(vma, pgoff, 1);
 	tk->size_shift = PAGE_SHIFT;
 
 	if (tk->addr == -EFAULT)
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index d7670ba4147b..081e483cc7bf 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -356,6 +356,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
 		struct vm_area_struct *vma)
 {
 	const struct folio *folio = page_folio(page);
+	const pgoff_t pgoff = page_pgoff(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
 		.nr_pages = 1,
@@ -363,7 +364,10 @@ unsigned long page_mapped_in_vma(const struct page *page,
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
+	if (folio_test_anon(folio))
+		pvmw.address = vma_address(vma, pgoff, 1);
+	else
+		pvmw.address = vma_filebacked_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
 		goto out;
 	if (!page_vma_mapped_walk(&pvmw))
diff --git a/mm/rmap.c b/mm/rmap.c
index ad820fe86f7d..5798427d007f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -865,14 +865,15 @@ unsigned long page_address_in_vma(const struct folio *folio,
 		if (!vma->anon_vma || !anon_vma ||
 		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
+		/* KSM folios don't reach here because of the !anon_vma check */
+		return vma_address(vma, page_pgoff(folio, page), 1);
 	} else if (!vma->vm_file) {
 		return -EFAULT;
 	} else if (vma->vm_file->f_mapping != folio->mapping) {
 		return -EFAULT;
 	}
 
-	/* KSM folios don't reach here because of the !anon_vma check */
-	return vma_address(vma, page_pgoff(folio, page), 1);
+	return vma_filebacked_address(vma, page_pgoff(folio, page), 1);
 }
 
 /*
@@ -1321,7 +1322,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 	if (invalid_mkclean_vma(vma, NULL))
 		return 0;
 
-	pvmw.address = vma_address(vma, pgoff, nr_pages);
+	pvmw.address = vma_filebacked_address(vma, pgoff, nr_pages);
 	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
 
 	return page_vma_mkclean_one(&pvmw);
@@ -3100,7 +3101,8 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
 	}
 lookup:
 	mapping_rmap_tree_foreach(vma, mapping, pgoff_start, pgoff_end) {
-		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
+		unsigned long address = vma_filebacked_address(vma, pgoff_start,
+							       nr_pages);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();

-- 
2.55.0


