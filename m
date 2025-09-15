Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6E2CA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 03:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591F38E0003; Sun, 14 Sep 2025 23:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F1E8E0001; Sun, 14 Sep 2025 23:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBFA8E0003; Sun, 14 Sep 2025 23:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 281918E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:30:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6DCA119F47
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:30:20 +0000 (UTC)
X-FDA: 83890056600.13.F62E3C5
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf19.hostedemail.com (Postfix) with ESMTP id D0A791A000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:30:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FVLTOjrJ;
	spf=pass (imf19.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757907019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EltDD6XaVHb4ywefi6tfTUXJyF6xjUHuaP+jJuKR6OU=;
	b=Uj7D/20DepsF/dZbvfp4ulHMUuS4+QltbrorB2caJ7amVgWPoCNzmuys47s6ASkKCMo3WS
	N2zrA+cXcdBYMi9fArjFOKtbYJq4FdiozLoBe5cMsUTq1ujdn19UcyAfcJd1ASc7MuWSqC
	ax8/065iuSwJjruMGpylUTqJFAfggs8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757907019; a=rsa-sha256;
	cv=none;
	b=Z/SL0mk7F1Q6zWOWxH/duSitDARzOzxGgchJsCaktCHnyVJ1dKLzY5xMu8CjhG4P9NSp8P
	ZFsy8JcJBKFqZj/Cf3le2zmZoR9FBfV5F8BcHzYw7MYadecyZC6bUYzvOw17IIvCzQLMS8
	EkH154wPL6vHQyVK4l9dAwEHu6qPjo8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FVLTOjrJ;
	spf=pass (imf19.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757907015; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=EltDD6XaVHb4ywefi6tfTUXJyF6xjUHuaP+jJuKR6OU=;
	b=FVLTOjrJFABFdizVlxbn8PKNiLtOx78GUqPS8BabpPDUARSC8qNyoBsmqCNJlcQqVBt6OdQsZK40FE0u/n/3DgREyoclwpmfNnom/lRiQ93+Tb3zzxCv4jDPaT+1a6UuhwuLYUtUlYiy8sj0WFoiq4X9XHGsSY2SDr9KxplEj2w=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wnx2CMR_1757907013 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Sep 2025 11:30:14 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm: add spurious fault fixing support for huge pmd
Date: Mon, 15 Sep 2025 11:29:45 +0800
Message-Id: <20250915032946.33203-2-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
References: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0A791A000A
X-Stat-Signature: maqwwx7hbo4ga8dwwgersi191gmd1abi
X-Rspam-User: 
X-HE-Tag: 1757907018-702999
X-HE-Meta: U2FsdGVkX1+GHo23whowGZ7EjARwHzFzGW/Ze8kCXLDNdNGLhfycw0SNwXDzajuc0DtjlpQ1b1QOqrC372MIxk0AY4XXh2FAQYcFhlWC9RYXUH6aJDeK3ScToCZicSMZP9hJyqGrzB+n7gLnmHvhoeiW4h6opyHWVPdw79JwS3X7ECjWJcooT1IrzRhdTy5vgFBRu8oOk33jMFpeorpRk/H5z5leMYZS3FHgGNgpMQFWqap66Kg2dkJ4PXbn9Miy2s4QelbyKVVldctEJi++bFczd+Fe1sah3aD57cWVJz5lxeUuTmWzFjZAHIFgLhpPXqp7Ldvs18wdjG9d7yQZ6tF1wNl7MEeMoK8Uu5gDPQva/RrqHOUF1Awz2SwLVdJ2TQ9SS/ho7e3dc61qWsz5VRLeX7//up0eZ2WbailbR0PrOrHzZmfPzrfPV8BwtFdcS/P8olgzUhrkGimmYbWQuGou75QGvPNft+GDGFYZ+tVGfh8Hn48ZNcsYCiQ7zJpnkDf/dSpVeYcx2Ib90sOiZoCYOYUi/k6l3ugMU6Valjj/XZojbbyJIl2CUT9OC5zWgt7JF/xw6VdJbn/acb/vOz2U5UySTtv7gZYrEklllvjdB0g/Nf3OIb124wOeiCl81LhQQdcUhhPLG1VkcFzFv4/TlMYaBOKnkQgcRdO81bGFDze+PTW9GkeyEaNqvWhJY8UCxTYE7h4jeJo1T+1FmgqyNcT08QDV+tmPICqj8bpB/tCCfwBX1Ihi8EJE5cFxH+6WpGjbfX8IjPRj1jW0Q7l04mJtqbExS9gMatpEcjRHY2NowBNSEIsUcZjeoViPV9EJBaVat6dsraOle3h6qr00zQnJitzolWtU2VhSOB0HZAGtfaUd8PEvthD2Nvqihc3QidE76aE2bl1Uv9jEuTTEE1SKi6Dq1vd2bgAkg7+JrvDRcXGw9SsuZeH/AZ/T+jbl5LswVej2WEPEmU0
 VvtsryRS
 a5NgdKi5sRfuFuowb3khWMFNLPb5XzfEC0GnvDA457UZGDgaPKGX0CWJ9lPzSETxiHlvvPN+YoZd54UV2MWbz18oQv/d+sZ8wqCl6y+f1NhA+FCiEncDEZrKAnnF4I8XZUVh71X4LdEHvN7HdV1jYjEYbmnOVvQ32BwpfHaBfyHhmx0eBU3+gDJ8XHcoHrbyf4YTH+G5wuSc3HCO5UKmR7N+97Kr2DObt4QBJk3e4LE2pqB558hZJFyTIj4ar3LAraJ5wTK+W4cnYVC8tIOj47JRpdGFTSImM7Dc/u5JQUoTaOxfidPsRl9mRdKjktqQjNJ0+rKz+Q9QFDYODjFm9tm8PQlWAghgAq9NOb0Yl0fAKg7VpKQq6mdLIMQZgmJCfoUI+2Jm/DWgv8TGLn2tmVOivqI6k3jH/aGd4sqsW7Y/2v1QBWpcbyxfaicdsVMjSSCdPsr1XS3GlLh+5Ifa5Sb2+NSpLwmee48Bnfw4GDrv+eeteGWqOBXejehF8RTZC1YCNVJHVpW+XedBYhItzW9Rlknpv2PIuesszOpow3blIUkpHO/LKxEdUccCdPgLEBwOaKMf8w8odwftSimsqTpGvD/od09+JksEOxc+lR496pVtjV0RAh97Vs9eKr6796RUj4WzWBmlqUq9+cuBud8iZ/edNBgOq/3gq3QHB9kCBXJoA9rw95MSLslrjsOUpuOCqNJpWGxpd83wzgcLhQz0H1xH2aE+h+dqdcC4Yj0S4BzQHuxfHpKRDaBLpnEiqQqTw2wkjleT2yelJSyqUvJj/cwoBQB79hQmh72U+bU+hIn55PBL8mkHD2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the current kernel, there is spurious fault fixing support for pte,
but not for huge pmd because no architectures need it. But in the
next patch in the series, we will change the write protection fault
handling logic on arm64, so that some stale huge pmd entries may
remain in the TLB. These entries need to be flushed via the huge pmd
spurious fault fixing mechanism.

Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/pgtable.h |  4 ++++
 mm/huge_memory.c        | 25 +++++++++++++++++++++----
 mm/internal.h           |  4 ++--
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2b80fd456c8b..d7604ad34d36 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
 #endif
 
+#ifndef flush_tlb_fix_spurious_fault_pmd
+#define flush_tlb_fix_spurious_fault_pmd(vma, address, ptep) do { } while (0)
+#endif
+
 /*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..0e2ef6b007c2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1650,8 +1650,8 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
-void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
-	       pmd_t *pmd, bool write)
+int touch_pmd(struct vm_area_struct *vma, unsigned long addr,
+	      pmd_t *pmd, bool write)
 {
 	pmd_t _pmd;
 
@@ -1659,8 +1659,12 @@ void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (write)
 		_pmd = pmd_mkdirty(_pmd);
 	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
-				  pmd, _pmd, write))
+				  pmd, _pmd, write)) {
 		update_mmu_cache_pmd(vma, addr, pmd);
+		return 1;
+	}
+
+	return 0;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -1857,7 +1861,20 @@ void huge_pmd_set_accessed(struct vm_fault *vmf)
 	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
 		goto unlock;
 
-	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
+	if (!touch_pmd(vmf->vma, vmf->address, vmf->pmd, write)) {
+		/* Skip spurious TLB flush for retried page fault */
+		if (vmf->flags & FAULT_FLAG_TRIED)
+			goto unlock;
+		/*
+		 * This is needed only for protection faults but the arch code
+		 * is not yet telling us if this is a protection fault or not.
+		 * This still avoids useless tlb flushes for .text page faults
+		 * with threads.
+		 */
+		if (vmf->flags & FAULT_FLAG_WRITE)
+			flush_tlb_fix_spurious_fault_pmd(vmf->vma, vmf->address,
+							 vmf->pmd);
+	}
 
 unlock:
 	spin_unlock(vmf->ptl);
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..743ce97c7248 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1406,8 +1406,8 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
  */
 void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 	       pud_t *pud, bool write);
-void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
-	       pmd_t *pmd, bool write);
+int touch_pmd(struct vm_area_struct *vma, unsigned long addr,
+	      pmd_t *pmd, bool write);
 
 /*
  * Parses a string with mem suffixes into its order. Useful to parse kernel
-- 
2.39.5


