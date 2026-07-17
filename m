Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8153C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4C76B00BE; Fri, 17 Jul 2026 14:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3957C6B00C1; Fri, 17 Jul 2026 14:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2848F6B00C3; Fri, 17 Jul 2026 14:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E93126B00BE
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:22:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84D1E1401F6
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:31 +0000 (UTC)
X-FDA: 84999088902.26.877DE69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6745A0008
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Iv0O7c/c";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312549;
	b=2yU/rIoI7mHKKBeyMnlz5N4f4k/PomSN1hla1tpFzAVZlC521K9zab7nROyVAc1ZEl/ylP
	TYBTF8RUTeU3GfXS1upS6gmIk6SK5/Ykw4MI6okmlFGVibhjkBO6e2yJQnAl6s8bsi139U
	fG/t2U2NdHkk3B7+jgunq5HeiYbgkH8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Iv0O7c/c";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7hUpZUpGSNT5pTheBg1aLusw4z3n2IV4NIpFOCmsM0=;
	b=WNIWMpeM4UzlahaVi1Igdr5UoPoQo5uYlCfo0+vJndRxxw5IXl4xE8rTjivUQZWZj9kg/R
	qwWSz5Ji642HPv5msAyt9G3xWVWrGYXLgIBsKdJ1sn3cNM4OQdGc1+RtHX0DD2/luxa2Uh
	BljTMIc/mDo5BnVek//xbJhHURregcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CC3443EEC;
	Fri, 17 Jul 2026 18:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1402D1F000E9;
	Fri, 17 Jul 2026 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312548;
	bh=z7hUpZUpGSNT5pTheBg1aLusw4z3n2IV4NIpFOCmsM0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Iv0O7c/cyThXK+BwGq+t0bqFQIEcSP9JnjGHjL88OjKYam1KO93erpmi6Qqv2i6wj
	 KLVl/KIvIIIXULRFqK6km63WOb1NSMAy19EAtsTqTqQrUOLO+xK1tS67UP5df987od
	 lnvHCnhS+Yd2CkvHYczJb/wUnu6KJN5K+3KY4+jBydAZI5rw8gGhV3u/A5win8Ci/c
	 yNfHr/Pt2aH9GyAchR6StrnHTINBJq534AmnPBZJWBrMMZEyU+oR4g/ORKm3Q2fONq
	 tVgAzQghEMFtZ9J7vKCT9wA3sIYhpRzZRxKFuniOEOb/FVH4yJUGlKtC8hBmwDuxDl
	 +nk6Wlknpcilw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:40 +0100
Subject: [PATCH 02/15] mm: introduce linear_virt_page_index()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-2-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4596; i=ljs@kernel.org;
 h=from:subject:message-id; bh=uH5Jc7cUxcyEjswUfjNSH8zXPOA1SoCYNdQzvopkVXQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivZ+PFhuNm29vdiBi4qBnraTuVSfLl5j+9X4S3Bpm
 nx5ce2DjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzk3zOGf1ZWJUt/GxTc3f00
 5+1L3apjr0y6BTiitCcslJgRJXbryhlGhnnSWxflRaelzcn/cNduHUe7yu2IhJOzJ+ZcfKjm8tp
 VnQsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6745A0008
X-Stat-Signature: a488zktnzsb1zbaoocf6hxykeay3z3am
X-HE-Tag: 1784312549-280314
X-HE-Meta: U2FsdGVkX186Wa15Rz0g/1i37f0OQFcGuVXw7VRDSotHbdJxElaJFZG/Lr4Id6oAy/7VqOxM6Ij6UBPOm2jO8bQ+8hSIBIqTiPr+0vmsx1CvqKev1OkuSJ7nPPbhbvjv9tIY/BTP6+N+I0fbrTiJM0vAfAaf1QOqEhdXua6q1QT63NBzzb/7KMfNjT5HrIjzuXhpJNiXW4105m8CBOh6WIEBbVy4jDZrFVzYYpgYHGNyDsZ+L/veSQ+2rnjRimfonQSwsINyweRHDHQY3xS5BJofpLH8+I8oqG4qCKNjhFSHT5xLy8cr0VIw10OmjFgxxeia4Jk1boQH7SNSnr68DeMsmVVII/3Pg+tAF1w3BAc9mIzz/a/mz894GXSzqx8bSlXZxidQ4h1icWDTJCaAkOouolutf4r1V1aUPtrwIkCqz1ThOnA8BH4JH7UAZp1SY9A1hr6V31GU7u2GgsP5dP+sUfOudU4ESob375FA7RI59hSV0GsLsHOFZ/2p1sgFUBISLaid5M4odhZb3hpFXxge5E4Z89FkAi6U8FxtCSp5rr2X3UiJUX8mI2lfK5trRnT8VwIgYbUjr23rSxS6bMjS/crsL445aBvcihVevsZbFFOPU4yLPe6ekUFVo/A0/6HuBQkxfC3fBPaHxQg5NKHmfZPihtq0xURyJ7c45HWdCE2d5blei1y6DqHYWDoFbRkMhARkbqrywIkbuzjvxIQhoQ8gYRhGbaCSpSbDv4h8gcf1YBOlAc156W2DfIaQPQm0BuO2ZRE+/1+IO2Ay2x94rENx+cEsKbaT/jRTiqrRdCEm0xToD/S6+hu0SGqkUEUAojDVjmXU54KC8j3ISAPXITMTI0z9K94cFy1hfAVxQSvpzwDcVjSB39UNtquN+nBqtmwKZGEEQng0Ju1BZJmwfCLPwQtoVs4IAiTX0nblC76j2mwXlXnSx9wIdG+wjQzF82fWN7imX3+4op7
 31AOSx9y
 Hv/YuGVRtGoZtj9QxIo+znlVosAvsGshrse+/BuqC8dYzm3lSY4sWYACNmKAhGtnbZNAXXbhKL8+pcGuQpS1VlgypKnDAwqCY3J4LIzkI9HQU4fHFlrpQI8NnjB26CJGgrofBejSMaCg/UHLEhgTAicORJGOtP46lH53MNYOPjAwei2pnKiL6YBh36bJs9HtfBXabDz1fVdx4mT7EihJF7r4L4wEFCG14Xtdr53g9RJv+Ojw9J2cLi5UK9fvDRaAs+JekInyo21SrHJ1i2fp1bxUyNWAKlALvjPB6wILL/CwPGclSIFD2F1W4QL+2bEd4sWN2MTTIt1AS7r/wBEwc0wY7WrK/KhXVkdkTzQofAByQIC055SVGbZIdbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function provides the virtual equivalent of linear_page_index(),
instead offsetting based on the virtual page offset of the VMA.

It is valid only for anonymous or MAP_PRIVATE file-backed mappings. It must
not be called for shared file-backed mappings.

For pure anon VMAs, this will be equal to linear_page_index().

We implement the algorithm in __linear_virt_page_index(), which is provided
for internal mm code that might be interacting with shared VMAs.

In linear_virt_page_index() we assert that both of these invariants are
true.

Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
but not fulfill this invariant, so when asserting this we check
vma->vm_file to account for this.

We do not update callsites yet, so no functional change intended.

Also const-ify vma_is_anonymous() to make it compatible with the
const-ified linear_virt_page_index().

VMA userland tests are updated accordingly.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  2 +-
 include/linux/pagemap.h         | 41 +++++++++++++++++++++++++++++++++++++++++
 tools/testing/vma/include/dup.h | 22 ++++++++++++++++++++++
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 59b98cc60402..b6503b5f0010 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1556,7 +1556,7 @@ static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
 	desc->vm_ops = NULL;
 }
 
-static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
 }
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c6fc783aaee5..81da91e103b3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1101,6 +1101,47 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 	return pgoff;
 }
 
+static inline pgoff_t __linear_virt_page_index(const struct vm_area_struct *vma,
+					       const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_virt_pgoff(vma);
+	return pgoff;
+}
+
+/**
+ * linear_virt_page_index() - Determine the absolute virtual page offset of
+ * @address within @vma.
+ * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * This returns the virtual page offset of @address, which is the page offset
+ * the address possessed at the time the VMA was first faulted.
+ *
+ * For anonymous mappings, this returns the same value as linear_page_index().
+ *
+ * For MAP_PRIVATE file-backed mappings, this returns the virtual page offset of
+ * @address, which is the page offset the address possessed at the time the VMA
+ * was first faulted.
+ *
+ * It is not valid to call this function for shared file-backed mappings.
+ *
+ * Returns: The absolute virtual page offset of @address within @vma.
+ */
+static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
+					     const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_virt_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
+	if (!vma->vm_file) /* Is anonymous except MAP_PRIVATE-/dev/zero */
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}
+
 struct wait_page_key {
 	struct folio *folio;
 	int bit_nr;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 00d416d79ec1..51605ade06fb 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1610,3 +1610,25 @@ static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
 {
 	return vma_flags_to_page_prot(vma->flags);
 }
+
+static inline pgoff_t __linear_virt_page_index(const struct vm_area_struct *vma,
+					       const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_virt_pgoff(vma);
+	return pgoff;
+}
+
+static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
+					     const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_virt_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
+	if (!vma->vm_file) /* Is anonymous except MAP_PRIVATE-/dev/zero */
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}

-- 
2.55.0


