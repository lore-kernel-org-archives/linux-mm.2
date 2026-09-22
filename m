Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E68EC98304
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D516B00A6; Tue, 22 Sep 2026 01:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823C96B00A7; Tue, 22 Sep 2026 01:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4746B00A9; Tue, 22 Sep 2026 01:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 409156B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:34:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2774A03C6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:54 +0000 (UTC)
X-FDA: 85240284108.03.078E7A0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 82A34C000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ILU2wSbW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ILU2wSbW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055292;
	b=tICUWaq7xtogULloi1qacyeb4MGiRZyf6bgWYXNAiWmrw5eLyGUDqB4q3v12r0ar2G+UQt
	Hnq+vw/c1FxPcRdH+UXX5V3xVBoOLROAsFf8/2ydUv2AxCzGxhBFj3tmtLTnancKjTMfEV
	4n68HtIk83o2EZ38iIgYWCYnbXpbMpA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggFf9vsm/p6yby6h1KHVQFgSLVs+0wCPIsczXGIceWQ=;
	b=ZGBovy35cXaW/QMvZwadcyqVV5ev0IUiIFzqkx8AA/HmQnbOllfIUXXORzMAtqVOWwjrJg
	BCWfy97J+z0gymtD20DYP9FygbxSdtXGsK6dYhUflv2WjY/jTG+Uy2A163MYCarTKpTUJs
	5u7ecRtxhmSyAe8P5qeD8EBZ566mJTA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ggFf9vsm/p6yby6h1KHVQFgSLVs+0wCPIsczXGIceWQ=;
	b=ILU2wSbWJj1eHXpAwwPPPCqQ2IWM9mgiFC+aRBgmQZVr8OMjMlbRbfKn7ipRW+QB7VEfaA
	W9Kp5uzeXkQpqo9tQtRSfROuEWym976BkjHxTm+vUTDZbwfkC/xpi2Vm1RTZNOG7AGs92N
	Mrhhq5c078MhLX+i+P+l6FM0VmmMIgw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-0LmmrQzxO42aLtqnnewPkQ-1; Tue, 22 Sep 2026 01:34:50 -0400
X-MC-Unique: 0LmmrQzxO42aLtqnnewPkQ-1
X-Mimecast-MFC-AGG-ID: 0LmmrQzxO42aLtqnnewPkQ_1790055289
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b609be5e96so2237388e87.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:34:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055289; x=1790660089;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ggFf9vsm/p6yby6h1KHVQFgSLVs+0wCPIsczXGIceWQ=;
        b=rFj5PG8ccbOvya31qOBvUNfF+I89GszGXKHftaDtYJ1RNQqEFulhGyReFf8YarxhZd
         IooVscE1xaQUUn/YSSbMG+sEvrnZZ9e79KtScAdmLtu3E3LwdSyZ/NthuV7WRdnm06Yd
         kJKKNoenNZF20zOlHKiHJvbqlsz/foo9tTxzuwr/J38MdTw2xRQqtVokMf8LJXJE9ehY
         85NHjBRW0XxO4meFS0b3Fh3WvxM7d/KGPJmk8MZnSC+fY2PAwKaqjN8jIn5g5be4ua3H
         /Dw5tCF8vAchzxHhcuIQETXBW1YigEC4yYWA22nwTRyZHxP5qekrSP4LvIIAUxEnMKQi
         giYA==
X-Gm-Message-State: AFuF++n2b6ZJAZW2fB3XnZg05LNDAuSj66BODqeYRgzdJVLIrPHbrQ+c
	eQdbKL6ipcGozUIjhchgEOcDBSUe/wDl3fj2Cs6pZ9fMN3nKVKcRSkisdXXbUanEWG7K4wwmYk3
	xgjlKwgJeEQIUuRWq+evmD9qD4HO+wGzGcIfxUMQRSPBEhI6/WEzyazc5iFYcrErG/e3v1nNbfK
	wmZKezw5tMygLslCvrsesP6Cx4h4OahegHQH1Baw==
X-Gm-Gg: AYBFou0XLvEz34upvl3OcDo5spT+LjRKU3gZrjUIEgEIM1GbkUhaItyCvAUWT838Kkv
	jdZ31BHlVVS+rCbdDYizZPTUnnMIRUX7P3Dt2vI9WAYtbsaI3+5HGv8zXw/CojOuVH7av3sx09r
	3iJLcL5rB9KK7KgsCEP6PlOi0LJ8pEFGgB4o7d2ok8z1mH+9rFlQFdZr9pel16kjXl6hcDg5c1X
	abnlUmO2TRWburJMi09az41h7EootqpAZPWHAITjPsXFTsU3qj1vKmRaI4aPRNDiJM9e+EvMD9r
	huEc1HhhB1bUbWsXibuD3zzdDRFd9ZM7VDuceu3SXPdRYPC/28p7Q60VM9IdYe5qxqA6rOkvKj5
	92K4oYKuDkrRUzbwRy6Bx
X-Received: by 2002:ac2:51c3:0:b0:5b4:b03e:b17 with SMTP id 2adb3069b0e04-5b8c17f19eemr4703904e87.4.1790055288876;
        Mon, 21 Sep 2026 22:34:48 -0700 (PDT)
X-Received: by 2002:ac2:51c3:0:b0:5b4:b03e:b17 with SMTP id 2adb3069b0e04-5b8c17f19eemr4703877e87.4.1790055288311;
        Mon, 21 Sep 2026 22:34:48 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:34:47 -0700 (PDT)
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
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v14 03/12] mm/hmm: preparations for HMM to participate in migration
Date: Tue, 22 Sep 2026 08:34:12 +0300
Message-ID: <20260922053421.4092027-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xaUjeyhV0143BwsbpnAKru-N8NxzOThoOgd6FWha9jY_1790055289
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 82A34C000A
X-Stat-Signature: cbjg57e3srme4gtmfsje1xfwgdpkpi7c
X-Rspamd-Server: rspam01
X-HE-Tag: 1790055292-783489
X-HE-Meta: U2FsdGVkX19iD3ufg527I9ZOxAuN/M4yWuGVdYrNSxGKql9OUmnIL15X6UntlJLkqbMKUhhVOAA6SiugWfRpQvnwhV5XvTDTZmEhIh7VH9bsUoXYZmHQRRgyNfFDL+Siht87JGrIDhkmxwIYEuIRpSr7R6O24giyzggtGWrabeQ/4RxhmzRlU1Hn2x3tf3yRQdZ98Q/kogOIuMPd9BI9pGxkOGiaibC7rz8MDlLqZzy+vQNsBZU9G/yXP4guVpaTqoBM/7CzrMEnbYljiMKHd4bk8WCgeyK0+VtY78BKRXP9VvpeXg2PKZsVhmvHPxYiTTptqwzpMuKf+F8W8x5yUBgXj77erjIBEc0bXFLTod0/sRucCwdswYibeGg21YsbdPJYWOiZIM2J7i/lTHZBlOUhT1Hv5Bdqe12JaGhnKXdFHSoMQ9ssDpGOfNJjn41dYDPZhxztzzu3cpQfYHvJz9NszWNfsKeatktBQ5A3kn/rAEYtlgWbOHTHwa2mysNWVHgH+zIOrJhkkKjOjPtM4tCHdjv6Vyv22B6ku5T9OFb0V3w1Frn7emuzl5/CcnzJ2yNXqALxqx4Z9kY2jIKTCFJpMzsRtKlRsX0nnveP+mYCOPxOCzy8ATA1P886tsFNIIPaAHf8PMDHRZJMUWRt0nbUi/6LhGsTpz/w3XO5SeoOlyysxru6sz4kLKMNqP+vatD53uEPdpSc4hAhG0gHpyPUVF8h+qKptSh5kON473/KOr+QTDTsozWkTzASCzcB5f4RukuxwvItVVe+G0uLpSyfbHMu1/MuFc5qqJnSNv5qd/ceMdZAhXWbf/D+SaU5taqqVNd5OIBnCYa2415QGNMszydQiFfbLH4WVA5WGa5cx2S0Wg5qt6O543c17mqsCRb2tkGRhsMwJrlBLSb91IcQ5U1QvIFeS84axJ1b/Yp/nAEZwUmzri4YmaY8eL5ZSgDtsafnoK/kCYheXCP
 lQm4P3pf
 KxroqyGOxC5D97ocu9E+d+a0lk45fFm2sWFgVWPASEHARAEbF5L6OgiYKC44S8y/0A/InfwoNqcZlgvq/7cOFkf3iTyVa/vAuMiPI9yBEzh/gG7e9ExHm0Aaaj5wyVDrRY9F0nHos0Lo5P3IQua4HBdeb86QNVoNDzeoSWLkQCZ/zvepC7dQ8qKn4llO+6Appg1ojiCcYiXcGf35K9Mh1uVYMc+fbMiMoc5qQEguek6M/qtwp7FtyvGp8F+9r8gG02zc8MFtN+Sr9dZUru3mR9GWm+C5c4L3uXEWqnn8OOOR5M/dpLD6baFpwIq8qv+40S86fEnU80CFxYrndPDCApjFz8HOWba+tQR8KQHCI8AC1lNObEj0rty6C5rYatzFPMMWD5EO204pHmIt6UFnVC3uRgfW5w+kcB9UuHuBIrdf2Zi6tu+OMxuHKKLGHMQpKpVSxFW8vglPXuu+zMHgUPBvIHppjKrDr1cyFSwSkVqmnPRnCHSnCSzesrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 include/linux/migrate.h |  49 +++++++++++++++++-
 lib/test_hmm.c          |   2 +-
 mm/hmm.c                | 107 ++++++++++++++++++++++++++++++++++------
 3 files changed, 141 insertions(+), 17 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 280ec9a866c7..01c5f62a56e9 100644
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
@@ -151,7 +175,7 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
-enum migrate_vma_direction {
+enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
@@ -193,6 +217,29 @@ struct migrate_vma {
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
index 2f1e98c6b644..be39d2e5403a 100644
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
@@ -28,15 +29,21 @@
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
@@ -95,7 +102,7 @@ static int hmm_record_fault(unsigned long addr, unsigned long end,
 
 	WARN_ON_ONCE(!required_fault);
 	hmm_vma_walk->last = addr;
-	hmm_vma_walk->end = end;
+	hmm_vma_walk->fault_end = end;
 	hmm_vma_walk->required_fault = required_fault;
 	return HMM_FAULT_PENDING;
 }
@@ -400,6 +407,57 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
+	hmm_vma_walk->start = start;
+	hmm_vma_walk->end = end;
+
+	if (end - start > range->end - range->start)
+		return -ERANGE;
+
+	if (!hmm_vma_walk->mmu_range.owner) {
+		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
+					      walk->vma->vm_mm, start, end,
+					      range->dev_private_owner);
+		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
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
+	    hmm_vma_walk->mmu_range.owner) {
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
@@ -594,6 +652,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
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
@@ -646,12 +709,12 @@ static int hmm_do_fault(struct mm_struct *mm,
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
@@ -670,8 +733,8 @@ static int hmm_do_fault(struct mm_struct *mm,
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			if (hmm_vma_walk->locked)    /* needed by sparse */
-				*hmm_vma_walk->locked = false;
+			if (hmm_vma_walk->mmlocked)    /* needed by sparse */
+				*hmm_vma_walk->mmlocked = false;
 			else
 				WARN_ON_ONCE(1);    /* broken fault handler */
 			return HMM_FAULT_UNLOCKED;
@@ -694,19 +757,31 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
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
@@ -732,6 +807,8 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
 		 * output, and all >= are still at their input values.
 		 */
 	} while (ret == -EBUSY);
+
+	hmm_vma_post_range_fault(&hmm_vma_walk);
 	return ret;
 }
 
-- 
2.55.0


