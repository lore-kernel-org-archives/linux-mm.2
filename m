Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048CDC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42FBD6B00A2; Thu, 24 Sep 2026 02:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407DE6B00A4; Thu, 24 Sep 2026 02:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6D66B00A5; Thu, 24 Sep 2026 02:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0032E6B00A2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:54:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 853448028C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:07 +0000 (UTC)
X-FDA: 85247741334.01.4A2A8B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 42F5940005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZyM8UXdv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpTd5JgQBNZxOTQ5E1xh4waIRSPVZay1TNJaxL2j0i8=;
	b=mtuVBXXmLhR2Kz8Pz5eT1dlpMUomhLu7BhGZ52bIv8iuZSAka7WnyQ5I67bzDUpJZTNM08
	TCUv/g7+MMuF5ds13x5VNxCkodqxXMqqL1jszB/nSxZt3GB1/+VFiOpeFFQW1sP7L4jE/H
	rchdSKZdwNIh7lpvHudLya2ABeV6Fpc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZyM8UXdv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232845;
	b=BE38N1Lf0j/WC0LbDYxfyW7szYLBVCSyChul7Zob5JKtOZgxn2jYcKTeYxZixbevmb+q5B
	cxung2H9cwJ6/Mpxif+keFtD8ZMFxozIYMI3SfzNtZkqOj2WqclIR37lRcoZReOAplKinm
	bLtwgWfSPN6gNrcEcjacwhEnWx+OncU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FpTd5JgQBNZxOTQ5E1xh4waIRSPVZay1TNJaxL2j0i8=;
	b=ZyM8UXdvudQv9+90uLGeYtxa4ggdw0U1rTWJWuh8H8I1uQaOraO9K2SrLbgk+zWHeNMH9O
	moLYf9RmtoG4dlI6uaN6alv5Zd35NmpaEo9bylySLDghJ3ZtEB2ZwN2VAtIROwd1vM9TZu
	2Q3N7CoN2lModO2VpCF/xvTgMAl9/EY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-p4aAGyvQPdWE6oBa9KgsdA-1; Thu, 24 Sep 2026 02:54:03 -0400
X-MC-Unique: p4aAGyvQPdWE6oBa9KgsdA-1
X-Mimecast-MFC-AGG-ID: p4aAGyvQPdWE6oBa9KgsdA_1790232842
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a2005c865aso6919261fa.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232842; x=1790837642;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FpTd5JgQBNZxOTQ5E1xh4waIRSPVZay1TNJaxL2j0i8=;
        b=y1kaawJMIpDiQGKtoWJIRn9nhtgB/sTs3I/OB4UZaeasG1GTqD6SrnIPB+m+HPq29I
         bczwtk56f/QHW2mT0gd4esnKxdKs6YHkbcfzH6alfGclfSq1b3jv6QtyNh7KiqMVEwq2
         wFluKBpqisUGPfxCGBT6LRUAvSA5rEaL2cpWooX9eV6HDp+b1tyGcdwBRmC2F/mGoizm
         DjVdzdnaBDn2s/M7w9RTE1BVOb/dfUrgzFFFn2OQoR1wNWyWwD7UU5Yta837IAYJMKJj
         eB5Ba++Rialf7gIEZeLxlXI5cdk//BDKDUgGcaKuD6gqkpDjfJ0x3AlvkLJaVpCKDBIz
         lVQA==
X-Gm-Message-State: AFuF++mBWN2KxlehV8J8EActf78bHdTncg+e+J3OumPBAUCMLkYeJFXW
	X97nZCC/KUm1D8G6raeYgPXsZDx8eGngE6y8EMZEIVTN2JFjr6jR0ebX4AfvU0svoTamRs9rv74
	zX9fGia7dTYojmNk4vlcbxZLdlOpQWcgh3e61hEk2ulva1G2z68K7AIO23wzAo+y7UAHhgSASen
	WILhUoRdMi0P7ytU8tr6b/M7IAADr8kRB3dUy97g==
X-Gm-Gg: AYBFou1WbGMZ72fdJ9a/ttmYoFTZG1eBm2YKfpRNwHhqGwo7VgHvj5GWNl6uK/hWEiJ
	9x2kc60qQt3w+PqtMLVNHbSwsFRz/h4E+XOKhgNwWtA++0vsYVk9a/ZY7mUh2jFp48fqgU67XgX
	ECrw8V6qsPguKsqhfUASr3KA4qx6diioSHQxaaUIqD61EXig6JvYTssdFde/5q7WwfyZh2Ahv0m
	dENcf/vLzmkY4k2LV9T950ZFFj5vzhRqoTvJ9aGYf+PZZ7tP4voWVb8f92k6+tsTB0kO8S5OdIl
	PWoOKaj3qAuyzEOX5i4p06Ud2eqbMULXnOdSRWAuGm0+VvlFVySRrda9QajDY5Tf4o1EknqMHza
	kU8we0COMXrA1YaJyDwsD
X-Received: by 2002:a05:651c:211b:b0:3a3:74b7:fc0c with SMTP id 38308e7fff4ca-3a63c4090b9mr3873721fa.24.1790232841742;
        Wed, 23 Sep 2026 23:54:01 -0700 (PDT)
X-Received: by 2002:a05:651c:211b:b0:3a3:74b7:fc0c with SMTP id 38308e7fff4ca-3a63c4090b9mr3873461fa.24.1790232841170;
        Wed, 23 Sep 2026 23:54:01 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:54:00 -0700 (PDT)
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
Subject: [PATCH v15 08/11] mm/hmm: implement rollback for device page migration in HMM pagewalk
Date: Thu, 24 Sep 2026 09:53:10 +0300
Message-ID: <20260924065313.899730-9-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CquMfUvfCBluPRdtXazOONj8JUlct1V1sRMUadFMfeg_1790232842
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tc87349mae4p158i3ggpfjj99exzrtam
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 42F5940005
X-HE-Tag: 1790232845-626569
X-HE-Meta: U2FsdGVkX19wvKQ0+gSboWHCXHktyO1RMvUkXNUPKaW1ECyZM9jgINORlLZtnwDYPT46WWNM2pL0rmW5aSoEKJAzGn2yGzB8r2kjag9nHi1YGUh40TM01ibXYUh21MP7JfT08MLRFqMPtD3ZCvLA9DXlTRfV5QwFrlH3LNkrJ4DblTcTtVnSmPJOahbfJ7eN7l6cy6ffBsGpPCJSSyNfILGlipJ9Xq+T2YduQHu1MwkP5mwK+G9uhniXWUWdl/zyh2KkhF8WWofIWY23JCEe84aPbSDVDUzl0fwzgpw2mvBplhQT1aabqyAW3CnPUer622rflfC31vC+boDhu+KmC2nbHCCMBB+dAlSnGisGViu/f1vUwMB4CKrOnTJLNKplnziiRJZjxcDgLpbHhjE4KQjbdTo6RxTrUBsFBF5v1MxYkILBT47lks98j/XZqqxeKjG8wJGi8u/zRTMLlm5hEv2uUFjbh2FUT8xYiztfukOmLVKH/63ShgyDa1SiW5PZUOTnyqDftdb7sJsgXc3tH42H8tqWzc3tEen2O+/tMtAPkH8ZFsT8bAgOksHXak8e17NIsKkjizIF5GWLZSlFK3iFsIlz7wzOJaIug1LN+Ra+cDRCvANQ7b7qnR7jxkE8lOzPF0r7qRzcKpTzK1/ZrHVn1d7tQSDOuKwesrtuU5JqVUzlsTKs0IOF4WmkXYyLaRM8WEPqk/cEhgszabnqjrc9skIrpxyd+vZGQTckbGg0GLUudferAECCxtJ0plcJBf2RtJhsKy7k8skpv/JP18R6V7tNhbHQ5zjbobxJ2yb95ZiYfgM6PSWS4BIlfZ+/UKP0vlsCJBf7HDddc2XEKOyc+aDxL9huiYO2baMF47YwggEsjY4nnxHorPta6Ai9Mq3MS9L9guZdZ/O9bsCF/Qs33u3jwL7AkihpTEJON9fKChkeJ3hU14zWxKV27HVUTdoa1viso6BUjV2zkQX
 riR2w96q
 Bc3TUvx3PX3n5xIXokz4CzTsl0XLFKuwtjWy+TVyJTamLm2hDP114XzdqKOvLQClXWfjWNosWA9Ue72mMZfRSZyRQ7u5Z50zGv5ZKFeUK2UJJbtmupGa8SGI9Z1eWurTIgmmYh7Lo4nsljPkwcmF5zPPMrLSn/Ms85lv/3JzWqpHi5gnohvG4+Stv6d7mSfXhRTZxYfff55iCME9F9p3O8P3QrQ8glwGj4BZGb+CR+i04Vai9kdTq6LC4ekIuwMHWmuno0ntZx5H0hkXhb/JyaxsuHJCVvizWawUCUZ6tnMBqYf6hMPdsaMAGs+U8U+Gn+JPyOnOxqWp39MlKHjWOXUKk+XcAdHEBA80g8n1EtDPtW6DVSCnXoKDlUddGV73St9uKkqOiBBEMWtf394DnOa7lrqxS2pq6kXan5sPeU0t5558gQ8rt+4pTkIfjYOP41+iUSqdGQi7UBN0YXbUllaTG9gouI58p39RxlqaLS4DZml8Bi19NRFa2/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

During the migration pagewalk, the PTE table could be cleared
and/or changed into PMD leaf or even another PTE table while
dropped locks.

In these cases the possibly inserted migration ptes are gone.
We have to however undo the collecting done so far, so unlock
the folios and drop reference taken.

During the pagewalk we notice such scenarios if going to
recollect a pfn but have already committed to migrate the entry
with HMM_PFN_MIGRATE, in which case rollback.
If we encounter migration ptes they are just skipped to
allow for restart own walks.

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
 include/linux/hmm.h | 22 +++++++++++++
 mm/hmm.c            | 76 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 4f56f3419cb4..b08ebc1343dd 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -111,6 +111,28 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
 	return (hmm_pfn >> HMM_PFN_ORDER_SHIFT) & 0x1F;
 }
 
+/*
+ * hmm_pfn_collected() - is this pfn entry prepared for migration ?
+ * If collected the folio's refcount is increased and the folio
+ * is locked.
+ */
+static inline bool hmm_pfn_collected(unsigned long hmm_pfn)
+{
+	return (hmm_pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) ==
+		(HMM_PFN_VALID | HMM_PFN_MIGRATE);
+}
+
+/*
+ * hmm_pfn_rollback_collected() - undoes the collection of hmm_pfn
+ *
+ * Note for total rollback the folio's refcount has to be put
+ * and folio has to be unlocked.
+ */
+static inline unsigned long hmm_pfn_rollback_collected(unsigned long hmm_pfn)
+{
+	return hmm_pfn & ~(HMM_PFN_VALID | HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
+}
+
 /*
  * struct hmm_range - track invalidation lock on virtual address range
  *
diff --git a/mm/hmm.c b/mm/hmm.c
index 9fdd945cc026..daf83f809151 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -95,6 +95,11 @@ enum {
 			      HMM_PFN_P2PDMA_BUS,
 };
 
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn);
+
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
 {
@@ -111,6 +116,8 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 		}
 	}
 
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr, end, &range->hmm_pfns[i]);
+
 	if (migrate && thp_migration_supported() &&
 	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
 	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
@@ -282,6 +289,8 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		return hmm_record_fault(addr, end, required_fault, walk);
 	}
 
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						end, hmm_pfns);
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
 		hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
@@ -412,6 +421,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 	new_pfn_flags = pte_pfn(pte) | cpu_flags;
 out:
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						addr + PAGE_SIZE,
+						hmm_pfn);
 	*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
 	return 0;
 
@@ -450,6 +462,9 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 		if (softleaf_is_device_private_write(entry))
 			cpu_flags |= HMM_PFN_WRITE;
 
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+							start, end,
+							hmm_pfns);
 		/*
 		 * Fully populate the PFN list though subsequent PFNs could be
 		 * inferred, because drivers which are not yet aware of large
@@ -568,6 +583,48 @@ static int migrate_vma_split_folio(struct folio *folio,
 	return __migrate_vma_split_folio(folio, fault_page);
 }
 
+/*
+ * Due to dropping ptl locks for splitting for instance, would we
+ * overwrite already collected pfns? This could happen when pmd
+ * pointing to a page table has vanished and been replaced
+ * with a leaf pmd, or another page table.
+ * In that case unref and unlock the folios,
+ * the pfns of which were collected from the disappeared
+ * page tables.
+ */
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn)
+{
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct folio *folio;
+	unsigned long i;
+
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return;
+
+	WARN_ON_ONCE(!migrate);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	for (i = 0; start < end; start += PAGE_SIZE, i++) {
+		if (hmm_pfn_collected(hmm_pfn[i])) {
+			folio = page_folio(hmm_pfn_to_page(hmm_pfn[i]));
+			if (folio != fault_folio)
+				folio_unlock(folio);
+			folio_put(folio);
+			hmm_pfn[i] = hmm_pfn_rollback_collected(hmm_pfn[i]);
+
+		}
+	}
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
@@ -722,6 +779,11 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 	pte = ptep_get(ptep);
 
 	if (pte_none(pte)) {
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+							addr,
+							addr + PAGE_SIZE,
+							hmm_pfn);
+
 		if (vma_is_anonymous(walk->vma)) {
 			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
 			*hmm_pfn |= HMM_PFN_MIGRATE;
@@ -769,6 +831,10 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 		pfn = pte_pfn(pte);
 		if (is_zero_pfn(pfn) &&
 		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+								addr,
+								addr + PAGE_SIZE,
+								hmm_pfn);
 			*hmm_pfn = HMM_PFN_MIGRATE;
 			goto out;
 		}
@@ -897,6 +963,13 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 }
 
 #else
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn)
+{
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
@@ -1117,6 +1190,9 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		if (ptep) {
 			lazy_mmu_mode_enable();
 			hmm_vma_walk->ptelocked = true;
+		} else {
+			/* The pte table is gone */
+			hmm_vma_handle_migrate_prepare_rollback(walk->private, addr, end, hmm_pfns);
 		}
 	} else {
 		ptep = pte_offset_map(pmdp, addr);
-- 
2.55.0


