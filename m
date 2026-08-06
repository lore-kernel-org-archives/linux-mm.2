Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FC9C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD156B009F; Thu,  6 Aug 2026 16:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E186B00A6; Thu,  6 Aug 2026 16:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734C06B00A7; Thu,  6 Aug 2026 16:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE926B009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:22:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9616E120203
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:22:34 +0000 (UTC)
X-FDA: 85071967428.05.3ED45AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A244EA0014
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:22:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TMzl/XFi";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786047752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbE5DHkTNtU6STxh6PeRdePiOC2bhJBQkXlvls/SNVM=;
	b=xLaYZYaSBlBgr/Q+L68G/pudFkeeq6KO/EiklzPFzTw/hBgK8UcJGob8DxfCMx6QeteS4e
	BSTQDHJE81fiJAPDH+eo3V8MEE8E1AUe38Z2/EGlsIn9qP8vW4CNDjv/GQU3ut6ujahzRu
	UhYzPsx28EJqXdo5uH6l5+iw5S12n0A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TMzl/XFi";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786047752;
	b=SwKpeNSEDlfl1VS6ZtdAe84vQKlFD2K2Dv9PpZx/MyhOVg3UeqPIbZMxk6UTzUTlZPa0aN
	OyAC1Dt1o2JA5YNaQ7DJ/n1efhvIqo353TS+Z9z2iuvMS6BmRVG2/rkpmQXeBVdT0aIz0m
	UyJ0CUXOFJUMDS8xbCqx48CV7+gRKhA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B61A600C8;
	Thu,  6 Aug 2026 20:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1CE1F00A3A;
	Thu,  6 Aug 2026 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786047751;
	bh=DbE5DHkTNtU6STxh6PeRdePiOC2bhJBQkXlvls/SNVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TMzl/XFi21X4tsBCnRCR9TNBNox7KbNEllmPiQhMneHl56UnH3IY2WyFV5kgsGON1
	 gCCsHf8Qbq7ywDSVCxRdWE1a2j+d0br2parJnmtlU6vwRzmiWL9qZ/a6zIhFZAJ1+y
	 964a/C63WGUIYlX4GGopipjuIfvtdgWCsQwsoy+NUtBafM4jlcdlX3CkSYFHjIVswx
	 SuDCMVlEEhgHgrBoFCR4FsFp5s87C4eThJTtUMjThiuA4cJwDtQpzjx8r96pMGkHs+
	 XGVPGbJ8R8g0o89ySggGdO9FRJu5nHne+zS/cBubMzrWbvB4RmF7JCT7YZ4vwIMKBh
	 JqxZRwE2/Gnbg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:26 +0100
Subject: [PATCH v4 01/20] mm/vma: introduce VMA anon page offset field and
 add helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-1-ab318a350404@kernel.org>
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
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8006; i=ljs@kernel.org;
 h=from:subject:message-id; bh=k4nsxhVksl7Id9wH8PF9j9dwGi3ny6iiiLSmQsKoHuc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3pxfUcnML3kp/giHiryrULlr4rfA9lf1b49o1HfOv
 Syr0pDeUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgInsPsLwP7XYNkPmQXnFwwhT
 zyIHQ7EJ9tMuzfx49SbnkRDTPIdbSxj+59puyvhklba2LXxiss6JVo93jOvUrFOWbFkvlTqlmfU
 3HwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A244EA0014
X-Stat-Signature: iwdokw6tz3ecee9xec1pm1q6z33ur93w
X-HE-Tag: 1786047752-619506
X-HE-Meta: U2FsdGVkX18JuD8XXanj5cizL4vOzJcCPwITVsKRDJpRyl+jEXLPTHTy/qu7wZunO/yGdxX1LNCXh6qCkToGTHQf+OothTqEVJMSdey5SgY5yDqzsBIAYJySZSb8bu8JbR3Fq9U29bdvaqUrqfTZmwZSJ8IWm4897s5hZ6GzIIf8M6xsK5lA4fYq5AsHedHnDzF4noV1eHA3ATsLfajU81UxryujvHiVYBZmr+Mf2ECMTunH6tlNDRxZ+k0UNRCYnJ2JBllF7ILO3YvP4gHN6rYVSl+Yh/gViazC6q/bmS7OfrPBBjUl50njTZKbr2IzkoLL7MZahsGD2fHqkZS/o0EMThyyrDrQcxEPecaFcf+ZW4IxK84vUPzjMEcQvT3wT6g0AURQ10oTUDKnoHHBpE89BVphzOxe+wpsXJdGRZtbavVm/YNPOUo7i5RCDv5MLKbcKKCcGWbpifNx7Y81V4CwfKGoPm1dFi4G/y2g/neMQ34pEBmllfxbYv1MKJgW39LuaBLypElhV3cKs0IbFMrZBFhZVgLLa14s7mW+4FtZSEiwF9GgkApzNTmdqJf0TsZZgIK+5huEVG7Ugzc+T7sEi74WemJapeLqnd8zQaRsmBAVfz2sOOjvglSXwRuVCj43K3zk92SjHLYnDSOXDhcybuvE4qtvHoEpcbeq7dvPnH1PZzQ3fTZobFrS2+EHN4kvQugldpcC5mnTmzQZuIDC31Fb8PL0D1VT4Z0BTuITqZGlsN3C8NM1mB1SzCaQpMaYzwMo+A667Zt4tQkcvXgcfDDWGcPGIrliiiL3pwUbtkd0jGJS21Fjy6hS+Ga7yOwQ8rpH/KYl2eNywcoDCBMNMYOUscRiwuFk/LNwcL7uVo8tdYr0/faNr+FQq8wFFrUPBJqovnHBJQqFpCkBlcBc3c9XYoKP7G9nOYoh89iMiROpLqEEGsIHEgxY5J02N/Ob90Bk7dDr+C3Ey2l
 7F9Pq8Zl
 /yQ9aNiE7zDykKo+11ZUpXGwwx42QxeTssCi88YH390yO4mocVVG/EVmXlwrWH6GUVFuFOCxqLHhWgQpiL7zWyRtWXAYDy/YTe85NtwUVsX4D/jGB4wwUun09MZ8OgP37SJcKV4V1ghwj5woa0jnDaWOAFtbKNvtRdt5myxbxPixKwcksCo1idJpYVma5FTMA8XDMMVTDbmDj0SMY2PtJl/evMmdj+fYRdqbYaIE924PUAMW0y+XwcxaggnDd35AtLL6GGbmLZ1uuUeRZIVwwtjSbG8NcP6nYsrr+FccgreS/XDzjuyme4CnEjq1WffCgDp2TcDs+8HFZOR8JOxvbidkLnyCkdmVzmdbNLyvvr6yC9ZEeCnImgY0JWVAY9TXxA7TU7FnENUEPxbU3hwfzLYdHxIo2xIuuKQC0oOZLg/VAvC24CGMuy6shgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Establish fields in vm_area_struct to store the anonymous page offset of
VMAs.

Initially, the anonymous page offset of a VMA is vma->vm_start >>
PAGE_SHIFT.

When a VMA is remapped to new_address its anonymous page offset is either
updated to new_address >> PAGE_SHIFT if unfaulted or, if faulted, remains
equal to the anonymous page offset it had when first faulted.

Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
file-backed VMAs are tracked by their file offsets. By adding anonymous
offset as a property of VMAs, we can now track them by their anonymous page
offset instead.

By tracking this, we provide the means by which to eliminate this
inconsistency, and more importantly lay the foundations for future work for
the scalable CoW anonymous rmap rework.

This patch simply adds the fields and some simple helpers. Subsequent
patches will update mm code to make use of these fields correctly.

The fields chosen are packed in the VMA such that, for 64-bit kernel
builds, no additional space is taken up.

The first field is present on cacheline 0 containing key VMA fields, and
the second on cacheline 3, which contains file-backed reverse mapping
fields.

Given the relative time spent accessing reverse mapping fields as well as
updating them, there shouldn't be any performance impact here from false
sharing.

Update the VMA userland tests to account for this change.

No callsites are updated yet, so no functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 59 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h        | 12 +++++++++
 mm/vma.h                        | 14 ++++++++++
 mm/vma_init.c                   |  1 +
 tools/testing/vma/include/dup.h | 26 ++++++++++++++++++
 5 files changed, 112 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 87feaa5a2b78..df78847f5f07 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 	return vma_end_pgoff(vma) - 1;
 }
 
+/**
+ * vma_start_anon_pgoff() - Get the anonymous page offset of the start of @vma
+ * @vma: The VMA whose anonymous page offset is required.
+ *
+ * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * anonymous page offset at the time of first fault.
+ *
+ * If the VMA is anonymous, this returns the same value as vma_start_pgoff().
+ *
+ * This value is used for tracking MAP_PRIVATE file-backed mappings by their
+ * anonymous page offset.
+ *
+ * Returns: The anonymous page offset of the start of @vma.
+ */
+static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_anon_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_anon_pgoff_lo;
+	return pgoff;
+}
+
+/**
+ * vma_end_anon_pgoff() - Get the anonymous page offset of the exclusive end of
+ * @vma.
+ * @vma: The VMA whose end anonymous page offset is required.
+ *
+ * This returns the anonymous exclusive end page offset of @vma, which is useful
+ * for expressing page offset ranges.
+ *
+ * See the description of vma_start_anon_pgoff() for a description of VMA
+ * anonymous page offsets.
+ *
+ * Returns: The exclusive end anonymous page offset of @vma.
+ */
+static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_anon_pgoff(vma) + vma_pages(vma);
+}
+
+/**
+ * vma_last_anon_pgoff() - Get the anonymous page offset of the last page in
+ * @vma.
+ * @vma: The VMA whose last anonymous page offset is required.
+ *
+ * See the description of vma_start_anon_pgoff() for a description of VMA
+ * anonymous page offsets.
+ *
+ * Returns: The last anonymous page offset of @vma.
+ */
+static inline pgoff_t vma_last_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_anon_pgoff(vma) - 1;
+}
+
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
 {
 	return desc->end - desc->start;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 939b5ea8c9e0..ebf0d912be7d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -967,6 +967,11 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	/*
+	 * Low 32-bits of anonymous page offset.
+	 * See vma_start_anon_pgoff() comment for details.
+	 */
+	unsigned int __vm_anon_pgoff_lo;
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
 	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
@@ -1041,6 +1046,13 @@ struct vm_area_struct {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
 #endif
+#endif
+#ifdef CONFIG_64BIT
+	/*
+	 * High 32-bits of anonymous page offset.
+	 * See vma_start_anon_pgoff() comment for details.
+	 */
+	unsigned int __vm_anon_pgoff_hi;
 #endif
 	/*
 	 * For areas with an address space and backing store,
diff --git a/mm/vma.h b/mm/vma.h
index 0bc7d521e976..54ed7c744e3b 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -283,6 +283,20 @@ static inline void vma_set_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	vma->vm_pgoff = pgoff;
 }
 
+static inline void __vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+#ifdef CONFIG_64BIT
+	vma->__vm_anon_pgoff_hi = pgoff >> 32;
+#endif
+	vma->__vm_anon_pgoff_lo = pgoff & GENMASK(31, 0);
+}
+
+static inline void vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+	vma_assert_can_modify(vma);
+	__vma_set_anon_pgoff(vma, pgoff);
+}
+
 static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
diff --git a/mm/vma_init.c b/mm/vma_init.c
index 715feee283f0..baa7e82f47e3 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -51,6 +51,7 @@ static void vm_area_init_from(const struct vm_area_struct *src,
 	dest->vm_end = src->vm_end;
 	dest->anon_vma = src->anon_vma;
 	dest->vm_pgoff = vma_start_pgoff(src);
+	__vma_set_anon_pgoff(dest, vma_start_anon_pgoff(src));
 	dest->vm_file = src->vm_file;
 	dest->vm_private_data = src->vm_private_data;
 	vm_flags_init(dest, src->vm_flags);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index c52b23773cd2..26d9210b1e8b 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -577,6 +577,7 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	unsigned int __vm_anon_pgoff_lo;
 
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
@@ -612,6 +613,9 @@ struct vm_area_struct {
 #ifdef CONFIG_PER_VMA_LOCK
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt;
+#endif
+#ifdef CONFIG_64BIT
+	unsigned int __vm_anon_pgoff_hi;
 #endif
 	/*
 	 * For areas with an address space and backing store,
@@ -1320,6 +1324,28 @@ static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
 	return vma_start_pgoff(vma) + vma_pages(vma);
 }
 
+static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_anon_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_anon_pgoff_lo;
+	return pgoff;
+}
+
+static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_anon_pgoff(vma) + vma_pages(vma);
+}
+
+static inline pgoff_t vma_last_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_anon_pgoff(vma) - 1;
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);

-- 
2.55.0


