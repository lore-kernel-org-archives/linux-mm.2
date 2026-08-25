Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA6CC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E14A6B00B0; Tue, 25 Aug 2026 04:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791B36B00B1; Tue, 25 Aug 2026 04:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632C96B00B2; Tue, 25 Aug 2026 04:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24EA86B00B0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:50:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0AFD1C171A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:50:01 +0000 (UTC)
X-FDA: 85139169402.24.7406939
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8F6BDC000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fgmOkr76;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647799;
	b=BIdk++YYq+2nD4/AVuDpGu+0Ub3uFm8tt7WUirrwL8fM6U7ISdl6ldi7fYmP9/ecZF1T8c
	e8Brl6x9T5S0CSxq0FrmDC64mxz6ZsbUCwAv1/nPm4iRbrqb/2dlYDpEG0UPTp2ephbdbe
	Cy/BMEfztcIEpt6+/cd2EIGtZJI8+vI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fgmOkr76;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wogH2M0/MVAbv/lLrCje4/37+/7jKlgSRWIrrsIx4/8=;
	b=KPlc7CeqBfZRIJPKZxUwFtV5iRAwFRzcGRYCcoe5PZ0jPjk+ym4Bj7Y/vLUKhZFKMkbl1z
	Xva0Kz7OVVgA2SHsYw1gOZpgtAKqCJHYVNqa3/neWJc5B+16dsU558uaW4AjZczpCQqXEk
	//O93bQe+4dkvSAP4VY9d0W40HBMZYc=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso606445a91.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647798; x=1788252598; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wogH2M0/MVAbv/lLrCje4/37+/7jKlgSRWIrrsIx4/8=;
        b=fgmOkr764bOCd8PCrOOW3xsplQmERPNfnvX09G48H9n9a7JIbxj5An0hd+jxpmXz/r
         wFDhvb0UD6wtnNCz4ifNXcFjdKo+re4oAtoZhFwDqs3Sxx4IBflQEr3EIM1gMDDqYTvI
         Ckq1PTinzXfCGLaaSxIKN22VQtZY9sYhcsE4e91xVpVbjuBcYAaDV0Qy2VuGfyG1Cke1
         4b7SianHysBlUBb+hT/5J3klPYDgdMFDpWsuaeG6r2/sJNOSyvPBs/22LWoq7iEpNPuR
         pf8o79D5QtkcC4KVdPgDz+y7Tbe9E3TY6+KbOOF3s+ZtTLBC7C7xZR2JiRARceVDCPxk
         WFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647798; x=1788252598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wogH2M0/MVAbv/lLrCje4/37+/7jKlgSRWIrrsIx4/8=;
        b=QOcuhE2DQGAPeu5nqthmgIITCNDEUwUD3qODEYcN+wKSuerq27Ynm0Birh3QouyezD
         7HH4Z4Yr64Qw3xIoJCjLx12Qcgvx7QRj3qCdFK4RdFSIpapvpFDOv6/RsNEOihxh+KP9
         4RG+dbwE6TPpxXOi6PCD6NzwX3Ej3F6qb1eU7IHnzHTUSXPiVIO37Y4W6exelx9KENB/
         PRfT6pfJHvHnIjcUF9FA/mVAvqwQzLllLLBaOAf09XMjtUZYUbhgFCf0p02s7MExXrgs
         e/Bt5U1VoIv3P7KPEfahtp0khvs97PqatOeV+0qbuVM871bPLti2tYlUfNmhlx0ekj1I
         5L0Q==
X-Forwarded-Encrypted: i=1; AHgh+RpuvUtNAR+kwgS1S2d04h5sxXf69hgW0DUiSg6vpf9A80smwG14m3O9ONNCVwuLFgKLtofq4VOCMA==@kvack.org
X-Gm-Message-State: AFuF++lvsLYPgoxxSvsSK3oBVSeQnhaxkfKaWEKJtvQtBksQtM7pIJaG
	ACXbJv3GljfhEyAfm6VHqH5Ge6NenPpSlxJeO0SAhFZf7Jjse3X0xatDKjiAP23+zZc=
X-Gm-Gg: AR+sD13+FPsQMIoAcRi2BDp2w+lhO1+NM7PfHU4sCHLn3Zgm1QI9ZYJFVKWsTZ9QSMn
	5PzAVdXDzk1PlxnEp9NrDfwXsLpye5qL+YzrzcQ26GRMsBnbFL9Qp/1e+tRy4dtMAQXIhWyQVmr
	bxXWauJa9Q+qVwXQ8Ki0N1LricAHZWZP4MREJfZAvXZx+wdG7IgSTFC1OHhamNfSI6ZnZgAqra9
	UtoJ9chffWKyimx8t3xwPJ6pyXa2o8ZHcXtcd7NRBZpBeAXShAqv4Lwk0CZlkOG/7Rcm7v2FbrL
	dh4bZkvX5X063av621QC49QYVTB1xEBUxCc9xRGf4tDW9nmmEMUd2r8IWCl+S25YF6t+StnpqpQ
	zJZN5p5aoqbJxX/ZrcRem97EkPkdow5SxQmApRc4RLrflEp91ySULrH5t/+IvgFclp2SmE9EaOZ
	K8Ah2Phpct76NJxHWAqTSqPLDm28wlo7+9s3FRB4+Vn63854moKL9OPeOSmZByxwO3mWtzlUaE6
	qRipwjXVicoxtHpZEfQpc203CNubBxKQFuu
X-Received: by 2002:a17:90b:538f:b0:38e:b400:a860 with SMTP id 98e67ed59e1d1-395df29e128mr48228598a91.13.1787647798322;
        Tue, 25 Aug 2026 01:49:58 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:56 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 14/17] mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Tue, 25 Aug 2026 16:46:05 +0800
Message-ID: <20260825084608.47437-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F6BDC000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8y11knysnjnc9ipu9imqtd3p6yyz3z6x
X-HE-Tag: 1787647799-778713
X-HE-Meta: U2FsdGVkX19bAyGQDoXcSjmsCRP8kMdNPSObof4XtW1QmCPsbtTe820IIOHnfS4um4diCxNeeHSbnJKfv1NDGAMFDrqUJs3kduJPtY+/vDwQNQvvIyaer/Yl85k/2Lwee1LYPGyXyVRS9C7RAKbWQV+NFvFJeO4hnsNdv/XIf5jWhmcP2Tk2h4V5kTt6zC7S7qZP2lVnfq7Hs2BiivZw3DCh1phlD6jesQM+L8/iVSPRDbH7+PJOr8OdHPg3xRd+eY43Jk3D8YePvicjqFlXqLmAUvRV+MLFV6rUMhE98lFGTDzmV3bERjOl+7q4MX1OPvFbJNsHsvloD+iYRwEr1830LHgWG6uc6eacXndtJHL/+BGRZJyVOb/oK0BQ23f0XHHm8VVrCXnJe/mdWsbt2bQoymJc0o9Bgs81d7dlwCGJkrISI9l1y77DXuz/Egxep7K7UgzofmUwVEU2nh3UNKNt5cTA4UkCvW2SFe03saH1QrppJ0k5FvSbpSZbBjxT1ygS8Qqqf1F2JTNW+czBUiqvTJtGTiAYHkADtvF5ERdAm8SNQLK/2Tu6GeEOHNqnrFQ3yMeaHCnGL2lRpwfFgllf3EKZv88TaXdt3GnkFbESEu5EKXEOmyWtzKiRdXMO0+QCS+t+OpSSTzdh5Ly3VLP3EOh6lj3SKp97GPfyuOq8FQorSQiikNyGewdXth1QFQ+EObtjRNQQXUY0N5apbZie5D6U7eqQhBtjJwczDT+mdszM/4DGiqdErt+DfsHpPoMI19XkoXrvmtZ2bxnIVcW6Q7Q0gwCV5UmDZHAkUPaMx3sGCs7GcsPg3TN2b/hKkUpMWa45t9AX8AtyIkfFmvKyP1uUyEqIkuPBsq0CiNAbxWiCxZCb6QhfvcJOhcsVCeLGFOsZoQgSE91rzlfHGubTZmfhm2C5a+tYPLn/c0ARnvfTrypCWH7ah6X/clJpPdDl0t7fV40/rVl8gD/
 GoUUPb/2
 9xufOoG2zCjUnJ18JPjrjpvCwZwz5Iv2WBG/Lst0tRANwlzkpoII95JFPD/NcJoygJS/w5gqAW0cyXy1eu4egmUWzgdsUrBKsvJoUalV39QLR24TYZYUT1Bn+e+hJGFP6dwJvexyV+qmEyFizmQeIpHIDDfWDnv2vs1GbbrbkaHhWpgnpucVlNEYGTh2HNTZMMLQqiWxPaZdBXhumbIjELF7kTyrTSY8V61JHVORIynJBy/Ix5ubrRNBQSCCz9bGo+Ab0dlklxHnYldfivgQZSCljXPil7ULfu4ac0UTgxYH6gI4kIm1eatWb37aehaReFPpVEVKQx094kUggZR1beuq0c1S4i11zeONygwV5AuPToXzEvQDn5UVTpGU3RF07LPwk3rim6KOuLrLJhqSBHx2eFDQ5fYZFnbcmTopiooQzWCJbce6vYSqvff39v7ZxCCdmMz1QeX/QbWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had
already gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the section order.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state
directly when deciding whether to mark a folio as vmemmap-optimized.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Use the order-based helper for the bootmem vmemmap-optimized check

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  5 ++---
 mm/hugetlb.c            | 12 +-----------
 mm/hugetlb_vmemmap.c    |  2 --
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fe28f98e1b22..3559041a5a57 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,9 +675,8 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fbb0c83bea79..4bb5a25849b1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3198,11 +3198,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
 {
 	return m->flags & HUGE_BOOTMEM_CMA;
@@ -3294,12 +3289,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (vmemmap_optimizable_order(pfn_to_section_order(folio_pfn(folio))))
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 7293706b532f..a25adc474351 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -714,8 +714,6 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 		return;
 
 	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
-	if (vmemmap_optimizable_order(pfn_to_section_order(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
-- 
2.54.0


