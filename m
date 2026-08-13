Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7C6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A776B02AC; Thu, 13 Aug 2026 13:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBDA6B02B0; Thu, 13 Aug 2026 13:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF6C6B02AC; Thu, 13 Aug 2026 13:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4D16B02AC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:52:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0ED16A0245
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:35:08 +0000 (UTC)
X-FDA: 85096947096.12.F9A4463
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5115F140004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:35:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OtSqY/H9";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHeRoJJr2O8/TaKftY2r1DUlL3KME6EykG7g/IHvkjk=;
	b=KUQfMpO3lVY3bhuBl800EliSyc2hhl5P5mf+BmBeut/PM7df/bBld4aP8KveZtqkarZs3C
	iaRaJ2nWVQddoEHZ/rh/OboAejX9ocWfJavaRq4UPUMpmNyP5Lp2PItcLEV7aENPuf/EYI
	8lo4rb2ChPyLDAnr7gi0nTE2Wa+cx9k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642506;
	b=Vkt2k97FBKi4zYhJ3GMEg1W/EJHmutjjPgd1K8ZIbXTBRZXIyQcS4HR6xVCVuGldL4pzSx
	lm4gzfcmfdzLQtWOaStqUriUJ4tZb/ACz4H3wIvoA92UuVkyKECHwuYBqQnTJBWg7RWxS7
	M7wQDWGKO8Fi/t2uqWLgeeraf2PrRyY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OtSqY/H9";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9FB2600B0;
	Thu, 13 Aug 2026 17:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8889F1F000E9;
	Thu, 13 Aug 2026 17:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642505;
	bh=jHeRoJJr2O8/TaKftY2r1DUlL3KME6EykG7g/IHvkjk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OtSqY/H9sqJEAHUIMd6G0CbKd8RO2TgYWZL9dRMCbGMnxyxtrTZ04YIhDmmPnZyIL
	 dnCdS7meG7AfAt7cLXD3GxZEn2WAtW+YfBj+PQxek5U7GYVd1tFylkXiMKk9h41H7z
	 uCLFDAsS3nGgEjWs13IqMvGiqlx5syYnHtUwxZKa3t16U0wX6QtP4TfnBu/Y/6O7zy
	 HU4BlORDw5SdeJ67S+cNDuC9Ls6tRrs9gcd78uXLdG1DP83NeG02vLznkJkgdka12a
	 GMhsfDn3hS4W0UXSMb/G8QLz6iVo5jISGfrVbGsRKzp/Gc+W5CS/92+ObTJ1J2xv/d
	 SjUsZsi6nh6aQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:23 +0100
Subject: [PATCH v5 06/16] mm: introduce and use vma_filebacked_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-6-c21581c0c3c8@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
In-Reply-To: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/6/eIlF58FHJ3ilGt/2fyeoEGh1/4X/wOcPUA13zX
 982fyUr31HKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJmN5jZLgr3nP/0lvxFM1u
 Lk+hijXPjXq0/brua4Y/XOLMuiBKrpvhf1HgrzWhx+6Z7u+w6692iE7o/v/gyv0fBbm1TcJ9iis
 +MwAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: f8jarghykj73cafwh6b5see6qsi49g5x
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5115F140004
X-HE-Tag: 1786642506-27470
X-HE-Meta: U2FsdGVkX1/BR1etjGTiV/+rXBF5F6c8yNbsHaQY0AvBFT7AWwZOQqnz5H14Qlgu+hcREKkZcam3K/PvMGRXwwO7aQMvBkfgKx/Qmr6g2OE4JJF5yITglWL1LJLBUfznWaf3hNEX9RHrWSxpVzVcMQJlSQPzd388aSGnp0a3X5GCNOcoiYMzMyDaquCAXLCY0yGAQR9k9Azbg8uRFx1l1Das8k+wCmRtRgfy2CMfdsbvqfK2NAleaeGt4MEVeqvju4ivvEED81nbeCzvOqLqvILiJ9b5OqCZojh9B5wzeYY5rpUEJwLfVGE0DZWQSu97mX32Jufe5YCCEo2GDIA0Uk77C0nJbG0BoIjnd8cvep87Yueqd4tQ9CzRg+asDtXB9igSTIPfLD+bvm6fsuH2IATUXq0pFCgLKX4zvxEtWMbnOAhM3RJxlkv1o/kPJEohOZZ8IE7gC2m5M5LoHYV4VLsxsA13tVY2xP2QraIen4Iyw5pUGr+Pd/QDcVbZWst9SfpqhQPEwc1W6mE8CkQq8RamjMyjR0kR1Ov9ZzuhXy8lqUK9XfwcUo9QaRRd9JwQS02xX+Dx5JZWGeFCkJHGPVad+OUUAA1AVMvUfL3F6u4FmhJQPNByXrC9HWL2f6HWcUPz1y0dQL4J+a9gRgRQKSeTAmCi0aVhG9RCWWYD1VVbM5RskGJTNO7spNN/wqaAOLmxTkY207mM2155IsXSPkXWCkFgYL8ctovF7+ASlhjhUe4474WHNzmtxFcwjvLPcxvJylMm/15Fx8/4uzHjF7APiHfJZKeu7c2mC6Y+ApcmI9HPkNjJoHyajXYjM+XJjuS+7t8UvRraQCAta+9O3Cc0EwPy0CxD+aZsLzN19GkRrFG/oKv7YmEarCLie9slDgQ12pF63M4Wat907a463di4pl08OXBShn4mtfpjbz7SUR864oxfwkH552Btk6peJcsDVU5puUCRtGd6kb4
 RhUNoRxc
 nIbMlwzYhRkjZYIrw21smzydDDO7Pt4V9JeCAfbsmeYnZC0ONjIdeWGZyaqVaJH0nVHqn1I0OHlfknlcBTGBGKyEz3FR7RF1uQtjs6sAWBPaj6sWvHteAW8sqWQisTNTkjv0NOlB/DEwAAeg5lExazwKN6CqAEkazieX/3OMCpxHngpefxuS3/6x4zovTmhlpdxQKJ98KG2oohS2+958piE1LWovemaBwbuBtZGuniZvYRZcN1jT1M4iKix0kvCsESCunl59obcaiLESDHXHFzJAOjKuZaRAkPrk3dDLEf4XZAie+vuQ0wBOJieEioJJZKMLTL2YWgiR2KuUyzmxS8e3TcKBUQW2vn5ek3C4PIERt3LFa3nNl3MgYrT7Dk+J/0jWJATx0U3AVdBb1v9iEqiudo0fzZccbkxyUaGdSl0L0KiWoHx/290LDYaqojMEK3p9ALR0kLVGfNiyMj12KyIgdcsx+1JHmMlRAOpbxmn0ov31cJMiBMfG7AD1UyLEgAqc8xz5wo/Y1Aq7rTPQxUC0TEVZPF6oeOflR
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


