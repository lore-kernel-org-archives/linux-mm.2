Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B608F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C148F6B00C7; Sun,  5 Apr 2026 08:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECF76B00C8; Sun,  5 Apr 2026 08:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29496B00C9; Sun,  5 Apr 2026 08:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A49536B00C7
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BD9A1609DA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:23 +0000 (UTC)
X-FDA: 84624500646.07.6BEE4E1
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA8F11C0002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=arH1HKh7;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+vulRN5m4Yydq260oUv4yelbrwHrOXM8b9fFHhOg90=;
	b=gXwx63dGLRPzC8uBUFX9rQoIYH6v6mEPK050c9k6ULaWZPhPNgzts31yvW3awFStYWLdnX
	29mFZNGHzkTJIzGEAhEUo0updm/pt+kVzhtIfdSqCt2d+wpxEzb0lJNrNlrCRRGFxMICDA
	4NscYXPD1BNB8xkbvo6+kgh4RM05m+8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=arH1HKh7;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393781; a=rsa-sha256;
	cv=none;
	b=m4/clCy/ROmIMdimB135qNwL2YguML+h5iLF23VqT1KdSTwCP/hK2kIZOzQ2a0r/yLfXiG
	sUkM6w+WDvZPjlDPPD23uSSIR217cQvFH33FpI2Rw7AGqxpv3zyoIFJCIbwixM8RbDNpDB
	hvJnbNisopt0bvh2ptOuFOisLZnotpE=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-358ed696623so1323427a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393781; x=1775998581; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+vulRN5m4Yydq260oUv4yelbrwHrOXM8b9fFHhOg90=;
        b=arH1HKh7sYT7s9q1siAVE30SD/xZCP8QFAiNTgZBMNrit0ZPUOfToSx4zrxJdUhTcP
         U6PJiBiYZ/4gEr/Zp4b2omHkUpaN95+sDLpvHcwpv0H1lxf2Y0e4rfH9KMiM6l20xQ1G
         XCK1lcuQVU1+j4ZtwOCGN//vqBoBhrv3UWFvg9a45XUYNu8Eh2B004ORJ1v1BVc6J7kN
         1av3vYNJimLmbRBx0mqrHY0b05L1WJPELE5j5UQmQ+t51vWJ3pdTxPa5KwnaqnkAnyT7
         qq/PaUmCzStlixQxHEupKU+lBmgrpn3ob1xLeluAr9vYxj98fSQ4X0wRK5NBdxOAn1Ps
         xIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393781; x=1775998581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i+vulRN5m4Yydq260oUv4yelbrwHrOXM8b9fFHhOg90=;
        b=WI/jjS/5Mf5ZbqwSIGARZ/5jPIOXrz7XoX2cL1rzpU1W64mrUX5jXGrThOZD+c3lUQ
         IOSgHpVM7U86ocUjieUXES+COJ4SfxIo2WcbdN6lQn39EO2oDt+Ud8D1i4HeivW1QD2x
         75ZY7nZxYgtdDQ3rM076tyw1yi+qPptZVLA/YFONYMKlqX9S9XPyDq359EXKFOL9F6ko
         TYhAMzg65QGo0SMR0GJJlt048hA9qh/BkdLEH5Q7Rz7oZuEq7cMleuM5ubWwEpg2LpuF
         EMLTyh5rnXwOOFB/YgYP3tvciTo05dy8Y38MeNETwoNAQ6O2sdnlOcVE/WcHW/3fqCwD
         UTtg==
X-Forwarded-Encrypted: i=1; AJvYcCWmUoZWQhXgdwunU0jPk13TqTn7SmZFiZ9rFiJSMd5+30gxv+owrKUbCxe2WEhwoCEtupTThUJM2Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2X7Y7RjD9Azf9cMwPcB+iZW4NtzXlgizQ6OUh+4g7C49p83He
	xiZ3o07A+7NXhhKB9Tw24N8ebSPvwCCklZmQ0QTtdKvbrCQlcnaOwyTB+04fyv29gYI=
X-Gm-Gg: AeBDieswHNtgamIv4I/fO1qRPrGqnmv4FkRhm5O/lzLCBoPAbQbHbuLlY7ToiJb/Jee
	2MOTU+C0jxkPfVZFm+I+ArDPwWeHJDnCMthVKWTLPDn0qmesT+sR01UC0++eB5c9UwJ4lS8PGp5
	uOBNbxpha11OvCxuL1vnWGFK1tjCGVUIIZJIyrfR9sa2z79+fd94E+AhiSZcVgF5wAtiLFces4z
	7Sjs/ydQywiCbVsonbhfnJ21x21r0mgzrT5t5hypIhg7Bvlud2Dm0rjEHXh5xwb9FOLmzKx1rhd
	Wgi3f4tnc8OlGF2j6hDtbfuFWcmERfNw4pkV6JJJB6V+CY9KcY8aIsquJfB3zeappmaJ12eGvyS
	OLirikVZheSUGwcsgUdTWRPDrFXJD0Erc1cReq2NHkIm4kRO0mkBkn5VBQxEogJMH1RMbMUerXm
	UwQigInID0yidTxq3E2xREZKf9wytP0HIgkTq5VjfvoX+chXcEscZQZQ==
X-Received: by 2002:a17:90b:1c10:b0:35d:9f7c:141c with SMTP id 98e67ed59e1d1-35de695a4c6mr8913118a91.27.1775393780469;
        Sun, 05 Apr 2026 05:56:20 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:20 -0700 (PDT)
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
Subject: [PATCH 27/49] mm: call memblocks_present() before HugeTLB initialization
Date: Sun,  5 Apr 2026 20:52:18 +0800
Message-Id: <20260405125240.2558577-28-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: aesdojso4onjod8n3oj6ogzzr6txojni
X-Rspamd-Queue-Id: BA8F11C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1775393781-50719
X-HE-Meta: U2FsdGVkX1/+7ZYQP7LlikHQWjR1S3We/Gy5U0BVF+JCsNY6jjKDOBMvTMJ12LtzoNFM6J3G8dh2iZDuWjz0dEvO/BoedbIA2sCPCNppyHt+NLsSoI2nEPEagUwXxXdRuyZSrQoFSpM90mQkhpt4BdtHwJdQJTk93QRNoy07KrShWp1ysBOlxl0h694F9XDY+2lS/7Lb/VvNwth/7PRxNteBq2gadZABqb1rkI+uXT5FHRH8nJIXMiPU9pD2bACilpNqC/wTnKG1wCxXTJeW3nPYdfGZeajx/+sywQ33DNzi/ZtuO1DRa44ENBWw/IkJ22a++yQ9TcFWgtacj+bR27aqNt5ZzeKXA3f6+MZ8HHL0Gs8oI9qqPB7tU6Y1MNH/k833tlHqdiohK0YYPdHXPu0X/gs3hsgn3/CRsw4QkQ6OrAVIHB7R6JKK0yLY0ZnEINYDDL58ZxstZMwODNhoilHXIxpJUP2oKUhau8f9WUJZ7q9Jer4NEI28TDRjOCcsHW8DSFh/BBD9fCUQ6Yon+P+YhcSGgGi1GdK7icoEgXSzBjVAUmWQexxC8U5R41Kf5IHcJzE5E5g15HRb6oQI6iBnlKcO8mlf6Ho998ddzxWGUo6Gr7x9Gg2vtoNji9RYA76Tii+Otg8VmB8AR7P1YJc6GaHmGCErzVzNAzr0xkrWL6e8nSi63wDxRMsu11OtJSwmoZWiTnIutKLis4ZdyfsjT9fywCh2YozP/uES/xIprcMLQ4xoIY3ARDdtJjyBGC/pvhh1ZJHxWkooAvRE9ogsQRi74Ih/3wOjyuHOb9LBF1IptEzlQVuxxZyuUznoPnMgiAvXBcTITHICyX5slgecXKdgHNIVBrgK1LGyaxiCTUUquW6mDYdHMUb9nLiPWc0VLAzhoauYBK3hFSuBdq9ZJwubWm6BZecXYtycD3wc8bDmtJKYiDlP3UM5Sf7TPAhFyLURyaB2Xa69XlJ
 HHdRb5fs
 rU5yaGKU7Ol9/aMKpK8NvJGyRXuwUlq0iE5QbJQnHr0JOyQOuihqAd6gzIjALsIdqP3PYNLl4uh1xr9xbHwa+JyaHCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract memblocks_present() from sparse_init() and call it earlier in
mm_core_init_early().

This ensures that the struct mem_section array is properly allocated
and marked as present before HugeTLB bootmem allocation. This is a
necessary preparation for the subsequent patches, which will need to
perform early setting of the section order for HugeTLB pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h | 2 ++
 mm/mm_init.c  | 1 +
 mm/sparse.c   | 4 +---
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index c0d0f546864c..27c06250d6b8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -963,6 +963,7 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
  * mm/sparse.c
  */
 #ifdef CONFIG_SPARSEMEM
+void memblocks_present(void);
 void sparse_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
@@ -1000,6 +1001,7 @@ static inline void __section_mark_present(struct mem_section *ms,
 int section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 			  struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #else
+static inline void memblocks_present(void) {}
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7f5b326e9298..b47f65425bc1 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2675,6 +2675,7 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	memblocks_present();
 	free_area_init();
 	/* Zone data structures are available from here. */
 	hugetlb_cma_reserve();
diff --git a/mm/sparse.c b/mm/sparse.c
index 62659752980e..7779554c5a0c 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -195,7 +195,7 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
  * This is a convenience function that is useful to mark all of the systems
  * memory as present during initialization.
  */
-static void __init memblocks_present(void)
+void __init memblocks_present(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -420,8 +420,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
-- 
2.20.1


