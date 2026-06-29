Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075F2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF20B6B0129; Mon, 29 Jun 2026 11:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2AC6B012A; Mon, 29 Jun 2026 11:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C917E6B012B; Mon, 29 Jun 2026 11:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 976086B0129
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F348C02B7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:12 +0000 (UTC)
X-FDA: 84933270744.22.FF8DF5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A2351C0014
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B7soDseR;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745450;
	b=ayPJ3lVbm+SvRr07fczQ8+JANZ1g139MWp2T4QvsxOIk963OifHsgEPIschMHfdl7EnqNp
	RwP+d14NNamNSg2uarbJVtk1Z8RArCU8bi5V3hDHRMcBluPMA3Oq6Id4XVQERtYgTKKlRy
	Uq+5bgcfvbOlcIXU+C5XbtQ35ExW3CY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bT1K9xIQtKkJ4es0A0jqBMylDdy8ZjgVwBCbSp5G+tc=;
	b=O0PUWI8UTgcMxlR3agXYJ96Xk3HSrONDfX4fX991qEfjdkPQD6POWFMxI4Yj7XvXmm+aGz
	58UQ5Ok/SPzcIprgIi/UOMv/vurHppN2qt8CDw31g3VDtSAC1G1+UnDOT8P6OQRwAdFhfL
	UuEClyyJOE6WHKMvNhh5n2VBbCZJAew=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B7soDseR;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A322343F15;
	Mon, 29 Jun 2026 15:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50BA1F00A3A;
	Mon, 29 Jun 2026 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745449;
	bh=bT1K9xIQtKkJ4es0A0jqBMylDdy8ZjgVwBCbSp5G+tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B7soDseRBlOlLhv/73D+XSAbW6CNvYcLDEKO866eqfcBNRSfKHRrO0CqH7e+fuNPI
	 w1lGtxyEA7msrq+arH2v5I1HA8ekB7PpyyGOeYOQBtlZ2eFQTdwIk/8eOHIeNU3qar
	 tl8svHFmugSTog67erD9mgAeCM5iVyrlItnneYlQJd4HRCgOT39r5u6zs6q1Zdfgu3
	 zOV2hA9u0e/bug1GpNjUNeXDBM69FervhCRXhdizkW7GsY/Nw8Wp8jPm2E2Q3tXXf2
	 /5aoEhik2enCaqHbqpJBA1jinZE9MmasGoC2VJOAIfwLqDwcFNs+yYs3Irb5h1oIyc
	 fNPi83Hxlj/bA==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 03/10] mm: abstract vma_address() and introduce vma_anon_address()
Date: Mon, 29 Jun 2026 16:03:43 +0100
Message-ID: <49b4a22767552ff1aa814a200a1752d0cdcec598.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A2351C0014
X-Stat-Signature: 76porzn31sz6smdyu1zz7c1pj6uhmaka
X-HE-Tag: 1782745450-424059
X-HE-Meta: U2FsdGVkX1/OaMIWgW7vx5vYPoP7gFkof2kQ5dTEmyeFz+GA3wb+sjbn5HH7AK2Fscpv0zbhchd1Ywrmdoibvj/EDRHYF0u07CQyzaawPr3yQXyC6kqlc+wgjFMWk0h0ktKxgq/MR7IaAfxACrBWNU5Uy2sMmj8JCkH1NgpapHH98jtzx0YDz8g3kjZIlroghjZmzW96v9L+db62oeyyUir/tfzzb3Bia2NMjruiM/HRLZ37e69s3iJNZ0h4OSmcbuFWivaswIsXymEUkCteOO/rjb7LGbcPdvA1lq18Kj0IqNBiszaN21Xg1xoqaIF958WNq5EeMDC2nf1EqMIQUoVxbr9IebsSgEccrERO5tf1O8A7rsRJlFfvCOlJsmRDM5dUwzqFB5J2Jf/K58AOsTgHjgwtbfJHLTIl4NKXxHpLPJ7BamqcYXvJAoY9L/n9ppgrLiGo9PV+cU6OsIlQWPTD/Rap0+qVcOjanSteBbTzrRjwW2aCZyc68WoOaswu/WQ8KKXSlALx0e0a6rLgPzOg3EQNhb2CLaaf9BGhaFRWd0/OiQ0ZDSavFpyxWU21r9A02usYUonXGYm63j4r3PV+rukBe30yfxBdeULZP/xt0DsdrTvLHFO32LJ6v8+vMC9DM5Jkv6UIKeq6etcczXxuPyyfWT2kWSt8ajZgxu4jDXhNXzDCEecv5QGDaYZ4QMXc5CePwM72kgWepByi1pqT9n26Ws8RzILhW2Kv0A6PcnN0CJ50SIRfY4c5twQ07gltHXmZi7pT7/H8YOUEOjJaK48TdYf1feQ1ntBC1fdnVQALgVGRNI8c1b1dg7NOwDU5lpg9EFSf2Ln5qM97h03cPvDyDcjsX5cpsVAUV0FjZrUR21sCR5szOBktk2Z1ExkuW7EkP5WohrmqmW+C/sL+MellFngACdFGAF2B0XuM9WyehSkt15Q1zHemxE7C0QCOLjdgIrmLjGu9Rp5
 A2Y9HPKs
 kwJOoVwzu1EfJXSItXsdK8xY5wM/pZCJqpvQ0vzyK9qzUlAm5w6McwYz8W6s8RXfp/e7NDYwkeby7MVEqjbX641hE7J1tJMJUG40fjnfXabblH6BioZUgFvRwKQCyKMJBr8Rl2g3kzgS7sC9tOL4hRDt/r0RSBy44Jhu//iw6tLXX6APGQ4WIAWXOAaMPEFTYNPRavJj7JysvCzOJDMHlkncv79QZbxIQcONH6a5xghuJWYqGKMAcFRu+La6joGdEY0rjeQY2OqaNjHwoA7tC+hMdCTi3oWx7smA+GJ5f0FrM9Ojd8nGVi2G9Mg1bwHyn8onF14bV7xb5qyGkEzXzy8R4myqfnexji+M/2J1buLoruFg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce __vma_address() which abstracts the VMA start page offset field
as pgoff_start, then update vma_address() to use it.

Then introduce vma_anon_address() which does the equivalent of
vma_address(), only using the virtual page offset of the VMA rather than
the file-backed one.

Also add an assert to ensure that the function is not called for mappings
which are file-backed but not MAP_PRIVATE to ensure it is only used in the
correct places.

This will be necessary for determining the address of a folio's index
within a VMA when the folio belongs to a MAP_PRIVATE file-backed VMA but
has been CoW'd, and thus is anonymous, once the anonymous VMA page offset
field is used for the reverse mapping.

No callers are updated, so no functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/internal.h | 49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e127dfea9c0f..8689f560854f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1224,19 +1224,9 @@ void mlock_drain_remote(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
-/**
- * vma_address - Find the virtual address a page range is mapped at
- * @vma: The vma which maps this object.
- * @pgoff: The page offset within its object.
- * @nr_pages: The number of pages to consider.
- *
- * If any page in this range is mapped by this VMA, return the first address
- * where any of these pages appear.  Otherwise, return -EFAULT.
- */
-static inline unsigned long vma_address(const struct vm_area_struct *vma,
-		pgoff_t pgoff, unsigned long nr_pages)
+static inline unsigned long __vma_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, pgoff_t pgoff_start, unsigned long nr_pages)
 {
-	const pgoff_t pgoff_start = vma_start_pgoff(vma);
 	unsigned long address;
 
 	if (pgoff >= pgoff_start) {
@@ -1254,6 +1244,41 @@ static inline unsigned long vma_address(const struct vm_area_struct *vma,
 	return address;
 }
 
+/**
+ * vma_address - Find the virtual address a page range is mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff: The page offset within its object.
+ * @nr_pages: The number of pages to consider.
+ *
+ * If any page in this range is mapped by this VMA, return the first address
+ * where any of these pages appear.  Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, unsigned long nr_pages)
+{
+	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
+}
+
+/**
+ * vma_anon_address - Find the address an anonymous folio with index @pgoff_virt
+ * is mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff_virt: The virtual page index belonging to the folio.
+ * @nr_pages: The number of pages to consider.
+ *
+ * This is only valid for anonymous or MAP_PRIVATE-mapped file-backed VMAs.
+ *
+ * Returns: If any page in this range is mapped by this VMA, return the first address
+ * where any of these pages appear. Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff_virt, unsigned long nr_pages)
+{
+	VM_WARN_ON_ONCE(!vma_is_anonymous(vma) && vma_test(vma, VMA_SHARED_BIT));
+
+	return __vma_address(vma, pgoff_virt, vma_start_virt_pgoff(vma), nr_pages);
+}
+
 /*
  * Then at what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
-- 
2.54.0


