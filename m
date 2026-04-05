Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C0EF3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276C26B00AE; Sun,  5 Apr 2026 08:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D836B00B0; Sun,  5 Apr 2026 08:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163A46B00B1; Sun,  5 Apr 2026 08:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 084086B00AE
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBEA0140A70
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:03 +0000 (UTC)
X-FDA: 84624497286.05.413EE28
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 22CC0140006
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JBSGpgjZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393702; a=rsa-sha256;
	cv=none;
	b=3YsN8B4quSfji381UqBBz0UapygG20IduqOFN8xiqRBLG2/h8RSg7E++3q7K0hOf96i87E
	DTqeN0nXCvlKxsmPGodRhCvaAjy9mK2TX1ZxmVvvJm9emj44yZHf38TorzxQMJ8jFc4Hni
	5zGZyXr0EqsSPWKNsk45nzqh6/1hwIk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JBSGpgjZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwFPS6YUW38IEMACgWNvn97a3hFqhS5O4/kjgd2aI1E=;
	b=yzevOftNxXYqMEH09S7jYBnFa8f9DBDDM5XiRPXWPht487lXwFb2JL0WnGdngwu2GXL8JW
	PB372SCOlfyFbfDtiUpYwqr3pXvWTtJXMUJX+nz6PgNkHxnAoVnBQ1y6iO8nTaduj/iXOX
	+CbJgRAExvwzml3Da4P0P2XMYTXPLz8=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35c2fe0d90fso1787957a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393701; x=1775998501; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwFPS6YUW38IEMACgWNvn97a3hFqhS5O4/kjgd2aI1E=;
        b=JBSGpgjZdiazzJ7uofLlgMjLbTa115VI8zxKPPXHcCwV0vapPTSyUAJu+886MQhVMQ
         gAT06hPscHd6Tqh92oLQYi1aF1ENsq+kKYEJLD2FaOxRdFMtmpbAfDtZRS5lRy4LdCWy
         XHy+PW6q7XRS3FJSXI2YaxVu777G+WoOeA52xTSwp7sG+IGx1pC5iNXHWbCr3MSLTfmq
         llW2gqyMUKfP1f2wGsz4s4ZfOlJ99aIjTG2IH7HZQsekhVSLvvy5DPUV9FBoVis88FmA
         GmQ/GAkU3R/MBfk34oMayvscdO48WpCmwT0Rnbn2Uj6WEWFKbkHkz7zu5VK3//kjQCCS
         00yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393701; x=1775998501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QwFPS6YUW38IEMACgWNvn97a3hFqhS5O4/kjgd2aI1E=;
        b=YlX4WwvwSisB+awjlJMHJYLsWhczcEcenwzH1NQuuzyLAPZGkkjzCJ0FsPGfmJQRZi
         emtb6kNSdyfOUSNc7wgwP/o4YVrQhm/MYBLbEiV+xXjBT3UMR99GUNzqYidaO99riTBy
         3SchKc10VhF7CA2+qPTFkQ2wM9EtQiuX0IkEZ4bDXQ8BvN3nunYGpe+X+8FDdJMrAMGb
         kRwb4HBOS3VRwlBgR4/KKiYnI2fFgrEv9HfFEZEabjFAig2z/4/pl7eIpiF1JxGm/XeP
         sTTEipvxrxYC3H17PFOQ95DjOw8Y2ZwsRxQN4gA1TohwmLf6fAug/6odEMIlvEyDr4Y/
         2uxA==
X-Forwarded-Encrypted: i=1; AJvYcCUpusDALmMy1VH+YCsn4uxbedJOMjz24FOMPSSFdOFemJcRZy0MOJHRBSI3h2VNlbYE0s4m9spF3w==@kvack.org
X-Gm-Message-State: AOJu0YzO4mEr0X+IRNcqmgWlQioEBZIKjjgwZB9hFL76bsReiNynTnmy
	HPJaFWroJN3dzwHStfzP4r/ky7XRB7guhWpPZQZb8EbtsMk1hAwdQa2UH3nFlegYffk=
X-Gm-Gg: AeBDiesSzGoPJMhlEXEHZzWjF/crkWSikAgZOj0LLR4vJqUyDq4RwLGNC9Gd5UHX5U4
	5yaAfjKiZsF02z8bCSMRQ53hNgJrUnj3i2FXlWeqWasC/xXNUAaVyyNAtHWvlABaEbo9bOuLvKW
	g1AZ0RqibaXsZpsT/3aQhXGNVIz6guYwmoPCDcgr8cG9aqU9PpMhWwsTweXClsjgnGGJwguFLZZ
	r0S2r5BwQOUxTywMx3Jt3rMvF7apRowqMciOp9l7PPF5qQLZsXDEsSuF7EwFrj0wEghBkFeW4LD
	yINd3pikbyyxhD1sTpunMs7eU7loiuB+0EKXjVkBoRIKceeRGPvvRyfVRVIz84lPc42Ggtkn1kI
	g7kVS9/bGpGM5tZt2/Wd0SVJUG5DLbKZTQzh8OzyFyiSK2FMoWABw4oJjPWiZSXsjh6geWdUoVW
	3CAYvdf4oGtFz7fprYVBmWoqwPzeh3akLM6QozMYFfjok=
X-Received: by 2002:a17:90a:d406:b0:35b:945d:752a with SMTP id 98e67ed59e1d1-35de68f82damr8709011a91.17.1775393700794;
        Sun, 05 Apr 2026 05:55:00 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 15/49] mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
Date: Sun,  5 Apr 2026 20:52:06 +0800
Message-Id: <20260405125240.2558577-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 49axteajcget39a1ezsxea7pkbetjeef
X-Rspamd-Queue-Id: 22CC0140006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775393701-401601
X-HE-Meta: U2FsdGVkX1+5olOF4HyjNminbZGMLfATRMUSE7oYgE3O5TAWQkxfoBOYVrrssxftHEXVmqpXb5XiJeQzw+7lJDHt49kAXLhk7hH8+lfB7G8/kyaJ0fJYQcExjnYQkRa3Ckr7WME3kNUTfCRss/v/DOvTau9B1KWkZ31DRs4tlW/81hHle1M2EOK089H3osAp7vCJZAORzvBI0DZbiKGCcEleDuXB9fu6p0SrjckxjKp2Z3UbVNqp6AXdCyRXfgcunTcauuyCE97vPL4b4y6NHJ+svYAPzLedng/6cJMEfyUO6tQFwdiA5xBWBCxZZShPgGmxgUAzMTOSP5i/sR9zrGq2WZTq0HzDSGmwbYmLUUhsL1+e5ZClTOtQ0jIV83qZMWCfdAejgctK4PcCVYwoY1Ri1aGpovJNO7PMeaf6DIgSSyIxUckiskViXOWBhR1VfyHWdt7ktHz+GvSb4XxnPZrgmSWNmGyBlaxIlPfbQv436CSDI+FyZd+qhJ7QQL6DJucG+ZTRpbpN1oMRTjXPTpd+nkkgq8B7MpJGW7KBYwoHb5jfudQ7Z3CCZjAumI0OvCsGqfdCFKPSiJrl6JNrboTteo4wY515t5bI+x+nWW4RMSal5wk3VYqZv0FLstYMpCIH17bHeSJard+rcYWzi6QW2qUKLbaSFnKDM9vhGB9wUyirQmfiyT7U5NUTS6gW94LUvAT26Hemim3WWoKMMKeunA2TbTHTox3nkmkcHkbtFtGxe8x6kQNCn7Ou2re24uZ58FPVMdIfC5srcAC3+KEjiNdDwwrqOo8YiodepJfMqAtAsEC7hxJ6wP8hB/fLylguMoRz4U90Y3BWYlulOmQ5eqA7jVfSx/1vjkM+j1nXx/gvJ6FXmamjycHDL0wQS5vSXK91siF+ETPcF2nLGv/Tr1HQYnVfGRlvnAfBmwJK5gvX9jMfh/WU3/ykAxVO/7tZ7Ef0TmCTNwCqyib
 oWvKX27s
 MwgBrhZ4xnCDXJIW7oPFFRZ3m06t7sjKq8+Wy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After moving hugetlb reservation after free_area_init(), zone information
becomes available during bootmem huge page allocation. This allows us to
identify and handle cross-zone gigantic pages more precisely.

During alloc_bootmem(), pages that intersect multiple zones are added to
the head of huge_boot_pages[nid] list (without ZONES_VALID flag), while
pages with valid zones are added to the tail (with ZONES_VALID flag).

After allocation completes, hugetlb_free_cross_zone_pages() iterates
through the list and frees those cross-zone pages (entries without
HUGE_BOOTMEM_ZONES_VALID flag). The count of freed pages is subtracted
from the allocated count to ensure the final number reflects only valid
huge pages.

This applies to both per-node allocation path and the global gigantic
allocation path, simplifying the code by avoiding cross-zone checks at
later stages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d6ea11113f1d..238495fd04e4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3049,6 +3049,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	return ERR_PTR(-ENOSPC);
 }
 
+static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
+{
+	return m->flags & HUGE_BOOTMEM_CMA;
+}
+
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
 	struct huge_bootmem_page *m;
@@ -3092,7 +3097,14 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 		 * is not up yet.
 		 */
 		INIT_LIST_HEAD(&m->list);
-		list_add(&m->list, &huge_boot_pages[listnode]);
+		if (pfn_range_intersects_zones(listnode, PHYS_PFN(virt_to_phys(m)),
+					       pages_per_huge_page(h))) {
+			VM_BUG_ON(hugetlb_bootmem_page_earlycma(m));
+			list_add(&m->list, &huge_boot_pages[listnode]);
+		} else {
+			list_add_tail(&m->list, &huge_boot_pages[listnode]);
+			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		}
 		m->hstate = h;
 	}
 
@@ -3186,11 +3198,6 @@ static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
 	return m->flags & HUGE_BOOTMEM_HVO;
 }
 
-static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_CMA;
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3393,6 +3400,34 @@ static void __init gather_bootmem_prealloc(void)
 	padata_do_multithreaded(&job);
 }
 
+static unsigned long __init hugetlb_free_cross_zone_pages(struct hstate *h, int nid)
+{
+	unsigned long freed = 0;
+	struct huge_bootmem_page *m, *tmp;
+
+	if (!hstate_is_gigantic(h))
+		return freed;
+
+	list_for_each_entry_safe(m, tmp, &huge_boot_pages[nid], list) {
+		if (m->flags & HUGE_BOOTMEM_ZONES_VALID)
+			break;
+
+		list_del(&m->list);
+		memblock_free(m, huge_page_size(h));
+		freed++;
+	}
+
+	if (freed) {
+		char buf[32];
+
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
+		pr_warn("HugeTLB: freeing %lu cross-zone hugepage of page size %s failed node%d.\n",
+			freed, buf, nid);
+	}
+
+	return freed;
+}
+
 static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 {
 	unsigned long i;
@@ -3423,6 +3458,8 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 		cond_resched();
 	}
 
+	i -= hugetlb_free_cross_zone_pages(h, nid);
+
 	if (!list_empty(&folio_list))
 		prep_and_add_allocated_folios(h, &folio_list);
 
@@ -3496,6 +3533,7 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
 
 static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 {
+	int nid;
 	unsigned long i;
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
@@ -3504,6 +3542,9 @@ static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 		cond_resched();
 	}
 
+	for_each_node(nid)
+		i -= hugetlb_free_cross_zone_pages(h, nid);
+
 	return i;
 }
 
-- 
2.20.1


