Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDBACD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F69E6B00A1; Wed, 27 May 2026 07:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE006B00A2; Wed, 27 May 2026 07:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A586B00A3; Wed, 27 May 2026 07:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 288FE6B00A1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4FF014055E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:11 +0000 (UTC)
X-FDA: 84812925582.14.8555C7D
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf15.hostedemail.com (Postfix) with ESMTP id B569AA0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880090; a=rsa-sha256;
	cv=none;
	b=d5oZZm902I8/N3OSL344/m5LPVC7Ud31AWmAQFqX5JMZKWxdhG7lGVNuhh06ASFl/xeUeY
	mAOltjW45VmM31d4sqMdIfrcpQsLbc5HtS9vhcDHUbe40j6lXEuLHO2yg6C2QT9D6xLERX
	TDe/sLF8s1Tz6xgP+SNAO+kzSeH8w+c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4FidKV2mEBYRhrqtbhmDqvZ3JqF8P6KS9ImBCznQC8=;
	b=djLn7Le2dLPm6A5EZ4kaplhCbwiIdseEY+ynrbGypJTGpolxpHnfrCqKXibKU6R1m7onI/
	LrYuLoahaTzTK6EDM4x6Yyr1Heeo0kutGBq66AcTq/QihoAR1w2fKk/cgnEaQE2j8VVOFt
	fD9SeN23+UoPhWfmWinrBJFvVCLiqNk=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gQRdH25mSzYlBHf;
	Wed, 27 May 2026 19:06:27 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:03 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:02 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 13/15] mm: support setup and upgrade of ANON_VMA_LAZY folios
Date: Wed, 27 May 2026 19:01:45 +0800
Message-ID: <20260527110147.17815-14-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Queue-Id: B569AA0005
X-Rspamd-Server: rspam03
X-Stat-Signature: j664xtzkfhjesyw4i6uh3mjzmq6h5816
X-HE-Tag: 1779880088-174292
X-HE-Meta: U2FsdGVkX1+SVWFCn3vaYMuW0+gP9Hyvt8KQW+ocWr112iQCRkvIK29UPagtOuWX42sL4Vuh1lsd+6z9acwLyFUI3Ju6x4oxCop4XcZHhr+z8x19FJkDzc9ewp7qdfXhkJ1nmt1I/GwbjtLINBmcnOIinTkrGioUz9l4OFQq27X4AuYjU4erS6tJHgf92fBZFUFHzeaVydTvBAFHIF+tO7oY/EFUPWq4YMhf5NUQnTppeepLwhmxa8ISU2dBYc0wxnZTufZ+wcj52Y/SXbjiTNL3Xs2+wTwiiifsMxd/6UzVBIIIFL4yFdhv5gbmhfMT8+tGwequb2mKaYbIsO6T2Fbs2jSJ3k2DXFQjVX96i3L7JA3aZ8Dsc3cX1cRuiRXqxP3Y2s1E4G65MtjgkwlEZBo2g691rfbhF8usMYmDP9l8Ij4lNBBEROnLW1Jn7RawP5tI4X1jcLN5Lrx0SryDw84HAX2P/ushw3cfGumoZg8jPJY+b9AS11kVO2RYibm+MX35+VrRVvQYypFKxqi8bxhhuMc3z0KZoSe+7AU9tpnPn6rpwNVeZeHN0rB5X0yxcKA71xRy+Ms+ofiZYs9/oJwHvkhBG2P3XHBOEPpUZRhynIG4sE3QCOsGCOswSRt6zIl6GWPHRhAYdeWoNzsl6Do7D2G8Ol1m+ejAsXHwl5qDw524/OFP9ePxsMyM48C+R343aVYagKXPZbfzRvZFiCmgWgySWgN4dD0o7cDxM1hkXvbsFroB6s+rAAH/OtdFVx3aBt7oUumYPKEydwMDhRFX8QNf/QjAj8QZYf4OkQD3cVDvxltQkQqirvkWoM7HntfJDTmvVVXOxK2EoOsvtFFenQD+mKHRqMpO652nn6EUmRplIZRyQNNdOlk3xruAm6YBjjI2EBnUtJukcNon8MKgHLviXt/duH3a8XxwtHouoZ8ZDwxJFmpa8fuBaDyVM+CfcYTigjabySG/t3M
 Fxdt6vUa
 8gppG4empy7hIhylx9Gdz96jJ83KXhKThUZ5QTkzMm7oIXObCZYKYWwYZTv++FxMZ6Pv/mqasPSBlVdBk5PQF+UYP6UfxHvQMCCrgrdR+eskSmdjYD8dw7Z7UuYgreL2CHLzIEFqxSRwQF9K2qQqVk1tICPQX578hwbsHHiVgwcBFd4WmmAiCxKNYArXUWyaUjxK8izu743kolU0HVKCJts1ZLvP0wJKKN6wisgJa8e+KnsSyAxMtYkfSHvLNdYfijIhotSL1p13N86RleOyX6Fo6kPWVGKhP6u77hq6wdKKuKRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

new_anon_rmap() and move_anon_rmap() decide whether to set
PAGE_MAPPING_ANON_VMA_LAZY.

try_dup_anon_rmap() upgrades the folio to PAGE_MAPPING_ANON
during fork() when required.

rmap_walk_anon() detects ANON_VMA_LAZY upgrades and retries
the walk to ensure the mapping is handled correctly.

remove_rmap() needs no special handling since folio_mapped()
is checked before use.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/rmap.h | 38 ++++++++++++++++++++++++++++++++++++++
 mm/rmap.c            | 21 ++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 59244481a8c1..9b1970698204 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -392,6 +392,14 @@ static __always_inline void __folio_rmap_sanity_checks(const struct folio *folio
 		unsigned long mapping = (unsigned long)folio->mapping;
 		struct anon_vma *anon_vma;
 
+		if (folio_test_anon_vma_lazy(folio)) {
+			struct vm_area_struct *root_vma =
+				(void *)(mapping - FOLIO_MAPPING_ANON_VMA_LAZY);
+
+			VM_WARN_ON_FOLIO(!rcuref_read(&root_vma->vm_rcuref), folio);
+			return;
+		}
+
 		anon_vma = (void *)(mapping - FOLIO_MAPPING_ANON);
 		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
 	}
@@ -431,6 +439,31 @@ void hugetlb_add_anon_rmap(struct folio *, struct vm_area_struct *,
 void hugetlb_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 
+/**
+ * folio_upgrade_anon_vma_lazy - upgrade folio->mapping from ANON_VMA_LAZY to
+ *                               an anon_vma
+ * @folio: The folio to upgrade
+ * @vma:   The VMA the folio currently belongs to
+ *
+ * Upgrade folio->mapping from ANON_VMA_LAZY to an anon_vma.
+ * This transition is strictly one-way and never reverts back to a lazy
+ * mapping.
+ *
+ * Called during fork() while holding the mmap lock and the VMA write lock,
+ * but without taking the folio lock. Concurrent readers may briefly observe
+ * the old lazy mapping. Migration relies on folio_trylock_get_anon_rmap()
+ * to ensure atomicity, while other rmap operations remain unaffected.
+ */
+static inline void folio_upgrade_anon_vma_lazy(struct folio *folio,
+					       struct vm_area_struct *vma)
+{
+	unsigned long anon_tree = (unsigned long)vma->anon_vma;
+
+	VM_BUG_ON_VMA(!anon_tree || !IS_ALIGNED(anon_tree, sizeof(long)), vma);
+	anon_tree = anon_tree + FOLIO_MAPPING_ANON;
+	WRITE_ONCE(folio->mapping, (struct address_space *)anon_tree);
+}
+
 /* See folio_try_dup_anon_rmap_*() */
 static inline int hugetlb_try_dup_anon_rmap(struct folio *folio,
 		struct vm_area_struct *vma)
@@ -438,6 +471,9 @@ static inline int hugetlb_try_dup_anon_rmap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
+	if (folio_test_anon_vma_lazy(folio))
+		folio_upgrade_anon_vma_lazy(folio, vma);
+
 	if (PageAnonExclusive(&folio->page)) {
 		if (unlikely(folio_needs_cow_for_dma(vma, folio)))
 			return -EBUSY;
@@ -573,6 +609,8 @@ static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 	int i;
 
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+	if (folio_test_anon_vma_lazy(folio))
+		folio_upgrade_anon_vma_lazy(folio, src_vma);
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
 	/*
diff --git a/mm/rmap.c b/mm/rmap.c
index 46876b3dbfbc..e14509b47412 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2002,6 +2002,16 @@ void folio_move_anon_rmap(struct folio *folio, struct vm_area_struct *vma)
 	void *anon_vma = vma_anon_vma(vma);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	if (!anon_vma) {
+		const struct vm_area_struct *root_vma = vma_anon_vma_lazy_root(vma);
+
+		VM_BUG_ON_VMA(!root_vma, vma);
+		root_vma = (void *)root_vma + FOLIO_MAPPING_ANON_VMA_LAZY;
+		WRITE_ONCE(folio->mapping, (struct address_space *)root_vma);
+		return;
+	}
+
 	VM_BUG_ON_VMA(!anon_vma, vma);
 
 	anon_vma += FOLIO_MAPPING_ANON;
@@ -2023,7 +2033,16 @@ void folio_move_anon_rmap(struct folio *folio, struct vm_area_struct *vma)
 static void __folio_set_anon(struct folio *folio, struct vm_area_struct *vma,
 			     unsigned long address, bool exclusive)
 {
-	struct anon_vma *anon_vma = vma_anon_vma(vma);
+	anon_vma_tree_t anon_tree = vma->anon_vma;
+	const struct vm_area_struct *root_vma = vma_anon_vma_lazy_root(vma);
+	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
+
+	if (root_vma && (anon_vma_tree_is_vma(anon_tree) || exclusive)) {
+		root_vma = (void *)root_vma + FOLIO_MAPPING_ANON_VMA_LAZY;
+		WRITE_ONCE(folio->mapping, (struct address_space *)root_vma);
+		folio->index = linear_page_index(vma, address);
+		return;
+	}
 
 	BUG_ON(!anon_vma);
 
-- 
2.17.1


