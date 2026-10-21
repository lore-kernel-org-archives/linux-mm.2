Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA05760A2601
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UwSQFpV0
Received: by kanga.kvack.org (Postfix)
	id EB00C6B0615; Wed, 21 Oct 2026 02:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67136B0616; Wed, 21 Oct 2026 02:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D270A6B0617; Wed, 21 Oct 2026 02:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A11766B0615
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1608E80453
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:34 +0000 (UTC)
X-FDA: 85345596588.26.653E7B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 92A3320005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UwSQFpV0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfJxNxkIc73uzTBEX6ZvvDehbex1Gl1LW4EuriUAtGk=;
	b=vpgHJFyJSIc02gvVa5m+dGREcs7Bv0YsqmrrJh0CIH/nqxHcYnMcziXUpiXFNaNwscaOct
	aGZUSAeUec+nCc+TTNv+g3OwBdtKVqkk1nGnKwil5eVKSPUlTSTeZ4htUGsK2h/DUpx0fl
	f3Vl8K5aNfmDTfHvchGEdGn72ShyFQ4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UwSQFpV0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562731;
	b=gUeo2J/fTT7y59bp6SEGqnfxb4dPyXXRwBVmlO4HCCvSECLsLz2TZ6GL1FfxPtHuEOYCJS
	htEYwiKNuTUKpVohgqSxBTkPwSt01P+JeI7jHuIu1VxNBpEqbbsNpKJfcY0ePMs394w8MK
	jgNbl/nPYYS7eGs0qar6NIWMmQJSPrE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SfJxNxkIc73uzTBEX6ZvvDehbex1Gl1LW4EuriUAtGk=;
	b=UwSQFpV0frp9VoCdRgm4j4xeRL7sAFhdncNOVORp7Tt1Ospa3iDuN1RSKYFNvMZjyq117U
	U8hSWEWz03/b5TwI8Z2369gf39uam1krx+OpVtQOmRtKlMK50U2WQW41foApKppaHrLkfF
	5wFl1bj2dyzxZ0cvhhXN3lwtZ8+94eY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-l-yACf24OPqw0lOdOydesA-1; Wed, 21 Oct 2026 06:05:29 +0000
X-MC-Unique: l-yACf24OPqw0lOdOydesA-1
X-Mimecast-MFC-AGG-ID: l-yACf24OPqw0lOdOydesA_1792562728
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48b0a199b20so293389f8f.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562728; x=1793167528;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SfJxNxkIc73uzTBEX6ZvvDehbex1Gl1LW4EuriUAtGk=;
        b=JjZ0t5vHAyzEs50MnF3BPg5dmY0yw1p/Bu0U2/pd2WkaqTHWrs7ZF+0PDwTn6XyxzW
         iKsfjJAZTNBY3TNW7uNXa5C757gHHR8kcrolPFQr6oEbCMQ2zjaJR47c5Iw6FyBbpBhI
         /UUl1cCyZEGwqTOCyDVzPhDY1notmsf2iGREfWrSQWwDSvYM/0gRHjv4Z3SzU1EcNlmt
         OGjsY18hUAmuYY+1KKnnRQXTPF1ncHWvIfCezMHfa4pKvMIsuuEbl8CPvEViJXs0BsWa
         hiS4nraptPyzcR8XEIZEOXLYekNlO7Qd+l6KWhiSkTll+jDbEKMvu395H3F1hKYdJ3TG
         aKzw==
X-Gm-Message-State: AFq9FYIgx6zKCmbmxzR90yeiocZmNEUK/4mHSj1dICOD/1JAGetu+d0y
	4ZqwxORCRBlzz61KL1SW3itm3pKI+PYmpIwy8dVtNNkHrjoIlxwDLkcvBTrUu7A/6y6AQZ2k2TW
	cBXwmOwLV/QkV652kRcJ25crOTyc8JArGYB5AF8osXtvtM4KoqCYZopt39AtF8lC6d0fQ4AVz1+
	NM6o9ONlN9Agvj+30ry7zZ3RpQrLYlNHLOc8QBqw==
X-Gm-Gg: AYBFou3+u4uFrLYzUs53T+pxgiUlAN5svBnsMpg5tb/Ths5/yuQ5Po3lQYSGx0NMYts
	NPNKyUxVfVoknDKI+4Fu4AQ4dOouSYtyHXjKbyBQaEEsLcp+h3DVezrr9xj+sTP0/r9YYDXTSzI
	6yEGe65gu1H2FEbLWdAqJqhyHgDrd/MiWsdTezMItqq/Mq0SWe4Xzxjr+Wc/lReOzn6mQ/cB5OH
	GaGob1cC09PykTRoVmSkDZ/3xDDtQLPDXAh/zuDoVT64f1KHK6j0o/XxoBzF5zI4UX2sChiA+K+
	h2Eq1GscdAEOtnLLbKfWImCIyd8jTJJ/w7LpKn98yuk6ckOhWV1zRLrS9WanWvIc8C/VEl/nIDx
	7FAGcZlYldMCCcpZ8R6Q3hG8pFFLqpevYTxaK
X-Received: by 2002:a05:6000:4a07:b0:48d:f14a:9183 with SMTP id ffacd0b85a97d-48e264a1d38mr1725924f8f.15.1792562728321;
        Tue, 20 Oct 2026 23:05:28 -0700 (PDT)
X-Received: by 2002:a05:6000:4a07:b0:48d:f14a:9183 with SMTP id ffacd0b85a97d-48e264a1d38mr1725844f8f.15.1792562727746;
        Tue, 20 Oct 2026 23:05:27 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:26 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v16 03/12] mm/hmm: preparations for HMM to participate in migration
Date: Wed, 21 Oct 2026 09:04:57 +0300
Message-ID: <20261021060506.2377545-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ji3zRKvivE4cQMTeMm2cC6LLxaXFn-NJMvHOJ2N7R7M_1792562728
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92A3320005
X-Rspam-User: 
X-Stat-Signature: 6ob8nowu71ifa14hdbeqds9tzds1wqza
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792562731-264575
X-HE-Meta: U2FsdGVkX18tyTSvla/hWtyB95idO2EfQKu6946oN2A5HLR5YyL8mp03+vAKm2o/aBccpMAr3+l446IM7voBgKTXIHPlEJ9lyp36G7Im3EcEg3ZgmgcnLh/OG2e4tq63zOEiOh7I4C29xTdUwEnE4fQq8UsZDNJjznMrCjIkyLswesxzlj6BvfXuFCsiNdYTcVnn07ZqadYneAun6zbx0PikfPnCzXygtU0q+vjRRCBDGonV5eDnUdFN2cm4WhYaXOnUKU3ERhQ9wfm+8vkJS9IzkLiuYPou88qCpMDIG9rIVNT50jSmIf2vCeo1QbZkUF5xMgBkAZkvjnvEUtvHizi1+aWsNkNSy3FX1mmmGU38vP/xY0DtCiswTu1+3jqL3cqV3GLb1gd1x3vjE0D2sWx2PEm5IHujDNOUWmM+0c8cJBAyVi/rGVAl+fqLvHs0MlBMJJUwdtETOZEipTKKbVhBJzccb4zKfhbYp09b9RqAnzJSL6M9XfU9xS1xTXu5utjySzWX8Tz4PEFVQ1ds9nXnzx/NN+bUTVz3ezrG4chzO9GDKBLje0zBM4ve5K1n4sRfSG36mLZenSEGAb9vALJ2dW7SAh8BT49BvQz8YBHtid/f/5rqjWaWL5nZ5yUd1JDrki2Daqv5rCESfdPDKKQfSoPL8uQzeecb/0+c3fh+7wztwfQ1z4xE8ht/NYoVoM2Yi8nOPKmCOLCC5YTSbi7McN8Sz5xyJ4XwU8JkXzRIMgjhhZpS1+IHTUe3d7SvyZE7y3NYGju3D5lqqrbdACOI0EKJAXbseRUM45Jv1YEojd+m4rWD3qDnLQnsWaoBYYdORpmjL+QZUhcfq5Ot627UjlAQkleoHa1ZXMSQlk4zaAfi61eLEhRZsTVumkKI+gQK1jub7KMkc610eHYoH76Iz+HpyjkZOfnUcqATgYDp3m4usTzWJsEmSTHSHqrVCMWuxykiEKnAZitcni0
 slF0iJ/q
 PJsRvpXt5q1URHmAC/bW+1RfQjOHIjaxjleX50bRDB7GbHv7cMXbMhFP3rwF8+W9myLZrzGNXLfvdb/NLaGCLukQGni4Kh1vh/OlOvRk0iWRZmzcgtlRysPKjZPGjXX0/KsVsOFex2sP7iiWD9l/V40xIkkDGy3exvaNuClAKpIXLymHVSEtQT38sxXKizC4npl64QkZg3OeAzr7iX01DmWkSvIrCki63dY0z7HZEHTpvY3hauS5HLvJ5nRLmMLHML91nmAT/Hw6xDsosLnMy2fPn1qmzG9SybYIvX4KOpSUq0zxTt4MYQ8GGlfG93aaj2I2oRykyv2jDE7XkL3qLCECxNJtJ0FeNIzljkjGMOYMPYqqzo4TQkyTK3eRoBvjzh7SIJEMd/Ji0BUwgnm0gGMu6Qm2KT2id1NNSke67WUNCvURMDRvOh5KzakXyig1qHAs+g0Kyffgyts/cQdXTD2lI/niWSdJTWCDOnAdxiYmjOlBpBb6kWOQEaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

For migration to happen after hmm_range_fault(), the vma has to
retrieved. Luckily, pagewalk already resolves that for us, so
just have to save it for further use. For migration, mmap_lock
has to be hold for the whole operation, so vma stays stable.
In case lock-drop behavior is requested, return an error while
migrating. Also, rename some struct hmm_vma_walk fields to solve
namespace collisions, and we are later introducing more
xxlocked fields so be unambiguous.

Take care also of firing the mmu_notifier when migrating.

Also, prepare for differencies of how mm_struct * is retrieved
in fault and migrate_vma paths.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 include/linux/migrate.h |  50 +++++++++++++++++-
 lib/test_hmm.c          |   2 +-
 mm/hmm.c                | 110 ++++++++++++++++++++++++++++++++++------
 3 files changed, 145 insertions(+), 17 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 280ec9a866c7..dd7dd7ec6995 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -5,6 +5,7 @@
 #include <linux/mm.h>
 #include <linux/hmm.h>
 #include <linux/mempolicy.h>
+#include <linux/mmu_notifier.h>
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
 
@@ -108,6 +109,29 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
 	spin_unlock(ptl);
 }
 
+enum migrate_vma_info {
+	MIGRATE_VMA_SELECT_NONE = 0,
+	MIGRATE_VMA_SELECT_COMPOUND = MIGRATE_VMA_SELECT_NONE,
+};
+
+static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
+{
+	return MIGRATE_VMA_SELECT_NONE;
+}
+
+static inline void hmm_fill_migrate_vma(struct hmm_range *range,
+					struct vm_area_struct *vma,
+					unsigned long start,
+					unsigned long end)
+{
+}
+
+#ifdef CONFIG_MMU_NOTIFIER
+static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
+{
+	return range->notifier->mm;
+}
+#endif
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -151,7 +175,8 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
-enum migrate_vma_direction {
+enum migrate_vma_info {
+	MIGRATE_VMA_SELECT_NONE = 0,
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
@@ -193,6 +218,29 @@ struct migrate_vma {
 	struct page		*fault_page;
 };
 
+// TODO: enable migration
+static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
+{
+	return 0;
+}
+
+#ifdef CONFIG_MMU_NOTIFIER
+static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
+{
+	return range->notifier ? range->notifier->mm : range->migrate->vma->vm_mm;
+}
+#endif
+
+static inline void hmm_fill_migrate_vma(struct hmm_range *range,
+					struct vm_area_struct *vma,
+					unsigned long start,
+					unsigned long end)
+{
+	range->migrate->vma   = vma;
+	range->migrate->start = start;
+	range->migrate->end   = end;
+}
+
 int migrate_vma_setup(struct migrate_vma *args);
 void migrate_vma_pages(struct migrate_vma *migrate);
 void migrate_vma_finalize(struct migrate_vma *migrate);
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 6911daa9f854..cd88e8177d0a 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -145,7 +145,7 @@ static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
 		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE);
 }
 
-static enum migrate_vma_direction
+static enum migrate_vma_info
 dmirror_select_device(struct dmirror *dmirror)
 {
 	return (dmirror->mdevice->zone_device_type ==
diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..4e9542aedc25 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -21,6 +21,7 @@
 #include <linux/pagemap.h>
 #include <linux/leafops.h>
 #include <linux/hugetlb.h>
+#include <linux/migrate.h>
 #include <linux/memremap.h>
 #include <linux/sched/mm.h>
 #include <linux/jump_label.h>
@@ -28,15 +29,23 @@
 #include <linux/pci-p2pdma.h>
 #include <linux/mmu_notifier.h>
 #include <linux/memory_hotplug.h>
+#include <asm/tlbflush.h>
 
 #include "internal.h"
 
 struct hmm_vma_walk {
-	struct hmm_range	*range;
-	bool			*locked;
-	unsigned long		last;
-	unsigned long		end;
-	unsigned int		required_fault;
+	struct mmu_notifier_range	mmu_range;
+	/* Set once mmu_range is armed with mmu_notifier_invalidate_range_start() */
+	bool				mmu_armed;
+	struct vm_area_struct		*vma;
+	struct hmm_range		*range;
+	unsigned long			start;
+	unsigned long			end;
+	unsigned long			last;
+	/* fault and lock drop related fields */
+	bool				*mmlocked;
+	unsigned long			fault_end;
+	unsigned int			required_fault;
 };
 
 /*
@@ -95,7 +104,7 @@ static int hmm_record_fault(unsigned long addr, unsigned long end,
 
 	WARN_ON_ONCE(!required_fault);
 	hmm_vma_walk->last = addr;
-	hmm_vma_walk->end = end;
+	hmm_vma_walk->fault_end = end;
 	hmm_vma_walk->required_fault = required_fault;
 	return HMM_FAULT_PENDING;
 }
@@ -400,6 +409,58 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 }
 #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
+static int hmm_vma_capture_migrate_range(unsigned long start,
+					 unsigned long end,
+					 struct mm_walk *walk)
+{
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+
+	if (!hmm_select_migrate(range))
+		return 0;
+
+	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
+		return -ERANGE;
+
+	hmm_vma_walk->vma = walk->vma;
+
+	if (end - start > range->end - range->start)
+		return -ERANGE;
+
+	if (!hmm_vma_walk->mmu_armed) {
+		hmm_vma_walk->start = start;
+		hmm_vma_walk->end = end;
+		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
+					      walk->vma->vm_mm, start, end,
+					      range->dev_private_owner);
+		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
+		hmm_vma_walk->mmu_armed = true;
+	}
+
+	return 0;
+}
+
+static void hmm_vma_post_range_fault(struct hmm_vma_walk *hmm_vma_walk)
+{
+
+	struct hmm_range *range = hmm_vma_walk->range;
+
+	if (hmm_select_migrate(range) &&
+	    hmm_vma_walk->mmu_armed) {
+		/*
+		 *  The migrate_vma path has the following initialized,
+		 *  so take care of fault path below.
+		 */
+		if (range->notifier) {
+			hmm_fill_migrate_vma(range,
+					     hmm_vma_walk->vma,
+					     hmm_vma_walk->start,
+					     hmm_vma_walk->end);
+		}
+		mmu_notifier_invalidate_range_end(&hmm_vma_walk->mmu_range);
+	}
+}
+
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
 			    unsigned long end,
@@ -594,6 +655,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
+	int r;
+
+	r = hmm_vma_capture_migrate_range(start, end, walk);
+	if (r)
+		return r;
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
 	    vma->vm_flags & VM_READ)
@@ -646,12 +712,12 @@ static int hmm_do_fault(struct mm_struct *mm,
 			struct hmm_vma_walk *hmm_vma_walk)
 {
 	unsigned long addr = hmm_vma_walk->last;
-	unsigned long end = hmm_vma_walk->end;
+	unsigned long end = hmm_vma_walk->fault_end;
 	unsigned int required_fault = hmm_vma_walk->required_fault;
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct vm_area_struct *vma;
 
-	if (hmm_vma_walk->locked)
+	if (hmm_vma_walk->mmlocked)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	vma = vma_lookup(mm, addr);
@@ -670,8 +736,8 @@ static int hmm_do_fault(struct mm_struct *mm,
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			if (hmm_vma_walk->locked)    /* needed by sparse */
-				*hmm_vma_walk->locked = false;
+			if (hmm_vma_walk->mmlocked)    /* needed by sparse */
+				*hmm_vma_walk->mmlocked = false;
 			else
 				WARN_ON_ONCE(1);    /* broken fault handler */
 			return HMM_FAULT_UNLOCKED;
@@ -694,19 +760,31 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
 {
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
-		.locked = locked,
+		.mmlocked = locked,
 		.last = range->start,
 	};
-	struct mm_struct *mm = range->notifier->mm;
+	/*
+	 *  Could be serving a device fault or come from migrate
+	 *  entry point. For the former we have not resolved the vma
+	 *  yet, and the latter we don't have a notifier (but have a vma).
+	 *
+	 */
+	struct mm_struct *mm = hmm_range_fault_mm(range);
 	int ret;
 
+	/* Migration is incompatible with mmap lock drop */
+	if (locked && hmm_select_migrate(range))
+		return -EINVAL;
+
 	mmap_assert_locked(mm);
 
 	do {
 		/* If range is no longer valid force retry. */
-		if (mmu_interval_check_retry(range->notifier,
-					     range->notifier_seq))
-			return -EBUSY;
+		if (range->notifier && mmu_interval_check_retry(range->notifier,
+								range->notifier_seq)) {
+			ret =  -EBUSY;
+			break;
+		}
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
 		/*
@@ -732,6 +810,8 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
 		 * output, and all >= are still at their input values.
 		 */
 	} while (ret == -EBUSY);
+
+	hmm_vma_post_range_fault(&hmm_vma_walk);
 	return ret;
 }
 
-- 
2.55.0


