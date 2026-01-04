Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9193C2A069
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 05:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C26B6B0099; Sun,  4 Jan 2026 00:41:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16CB76B009B; Sun,  4 Jan 2026 00:41:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08FDE6B009D; Sun,  4 Jan 2026 00:41:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E75B56B0099
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 00:41:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8766D140327
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:41:51 +0000 (UTC)
X-FDA: 84293184822.11.35C4359
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 891D41C000B
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:41:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MKcL6WCR;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767505309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YE9pc/4tAvhZsZXrRzmjeNPdx2fm0i699jC8cyE+mak=;
	b=TIn3n2CuTe+A2uHK3fAPAmY8q7+maoivLJwMBF1LGat1bJwGKXdM3qxoYKDjl6woaho4a2
	2DaKVP/NAnRM6oNAuK8goKPPNexGBoRX7/PEF3QFyJlG1wW1niV6K6oQT7L+1hCxbmQhch
	e3PhM3InOBcw8rmw27HxoC6nVinAazc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MKcL6WCR;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767505309; a=rsa-sha256;
	cv=none;
	b=M8cyfZGUxj56Yivwhlkhs850ZrgqEoTLLrdqgQ8jDQdxEmZIPvd7oGxHN8ZnxVyB3cHHQs
	izY84+bG7oU8rMuWx0mIPstbxh0Oz1ZAleiMk05+RYtY80TU7IFcc8CGdFBZAIn6JCULIq
	s3m+4aObbADF04oSSY0IkJ41YBCjEnI=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b9387df58cso21116436b3a.3
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 21:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767505308; x=1768110108; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YE9pc/4tAvhZsZXrRzmjeNPdx2fm0i699jC8cyE+mak=;
        b=MKcL6WCRTIanb3oWjr7wNZitsRCBhWFU4FNQaHm/VNclSia7hdBqinDfsUBdmIt5Y8
         U87QWymNnK4mBgzJjwbki6mj7KVvVSQDm0yQnjfMQpDTzwYUXKcQ7kiDMyCpcUXqRMuy
         5Mzk343bqRIZreTqNzXXVWid4DvZz2g11/5u/xuzA4MIMjt5RXez5OeVy3+ErDCWzFeH
         LBKpSiu8qQsxZF7cQ1x8MVQo3NKN0AvYimUnhmeTOQ6O+0Lz297wR6nkP3oIXPJFHllL
         jZn5lZC4YKXaQCJ8NfFFZ/VvL3EIrE8iBlJyqS1Awyevt9+ZKlphIgCRWUu1YMgjfbmx
         QJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767505308; x=1768110108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YE9pc/4tAvhZsZXrRzmjeNPdx2fm0i699jC8cyE+mak=;
        b=tRb5+jAkJPYakKoJRyEjUXvbGIKXEDQZE442JbbDhUKX0JVE45pQrsJlQncUVpFGyP
         fI/GgDnaWsTXp+W+CSPi8Vf/DpZz6Fu/G/zF2yBtakTPUcZvn+5Rd92FrYvz66RSdNc9
         HBubD4liX0JGiQnygnMbn1MAIqMOY9naPLU1BXHmFoGIVai/hhsPwlx1oYZeeoftPyGq
         lxOgEBIfo2Em9xIo2JxPLaCbzy8cQuAOgTqOHKVKhDOWgDX3SubmleTAm+nL80puegDz
         XX7BOvcEdRiUThzaFNY7hiippIFGY3cRodC+Eb91Mqwgp/9Y56gXvBMC1J9d5LgselH0
         uZSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBO6GNHbxMA8bwb9f8pLySq0rdO49B0FravJhyqAk5pzjAJ7Z3cJhtnFS9ZsieyEN8vsdtPUtygg==@kvack.org
X-Gm-Message-State: AOJu0YwCnUWt+IyLdcSfkRqhBo+tzlP63zq6uVUYCEUOXkXPcqh9oUH3
	QNd2CSbb0LXAo6FIypuRRhuLh62MJlYsVLYUeGNx/82CLTynGb0KQj6Y
X-Gm-Gg: AY/fxX4ll8XdTKyF3CNn6SV7RzwJH4MVQCH8Ow4V4VmVbHoXRmEJ2U9weKhr//h+Ggk
	WB2XaZii/SDwxB9lODM5GL76TU5JqJmDEI/vDOyaBmqI9IMJoW0mYyX/ABM8yoBqxmponeGwfF9
	ihm9rkUD2FlsiOkVyWms5zgkdwfXPcnHtGBcfJY2GGLQsMUDJieFRQ+zklqZgu3nLrIU5sZ1rMX
	9UleWum/1nuHwApUkCz/dcVGfAXwJejyQdrimRQEptdlnsDSXcxj0W71qqJiB/4+Urx12hOZtIS
	TJS6c8h/1E59N79qgj+f9lwiH7zPoh0orvaS9bpVExJgGuBkTFfwosKv7Q3tO+LnPxCLk63/5Vf
	vNU0G2r4mLOOelWqBm9e32tboyIbJpeKL8bYxtyCx+Y6wJZlS7EXDwOYZhfgBhtFL8oWsZ2l4dm
	0wSC6A+gXGxyutfzv58XmGGT7L5mzi
X-Google-Smtp-Source: AGHT+IF7QgKeDTmtbweC8O75d3jf2oErQKa2BZ42N85Bzgsk9GFBi54QbRbc4L6KqI2F4q+/nYahLA==
X-Received: by 2002:aa7:9906:0:b0:7ff:da9b:bd82 with SMTP id d2e1a72fcca58-7ffda9bbf79mr28733868b3a.40.1767505308352;
        Sat, 03 Jan 2026 21:41:48 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b31c479sm44378305b3a.24.2026.01.03.21.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 21:41:48 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v3 2/6] mm: khugepaged: refine scan progress number
Date: Sun,  4 Jan 2026 13:41:08 +0800
Message-ID: <20260104054112.4541-3-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260104054112.4541-1-yanglincheng@kylinos.cn>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c11r7n6mpug4j97ym7nth1swf43ks5mm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 891D41C000B
X-HE-Tag: 1767505309-192225
X-HE-Meta: U2FsdGVkX18F1r9jSXY0Y6CFGiRPLR+RPDtHNtJKk+NZnSVf/xU+XEdV6UagFJVDka9lkBr/1nl1ZJET6T7QIY7osnaKUMWDHq8vn7BxofoLd76q1p8xIB3DS7fHpc50qoL/cyD7wyY1sJY1EMpvaKrWwJ1d2WIkmBu4q3f3MW8Y7GoTmPMvH2SZv8+QMRh71MgvszvqY+IY1UPtFtTe4soVt88vpq/TQ1f2eWW2BFG+aAw8RayXXw9+Mq9V9f5lgAJbiIvmWF6L69IN8lDgPxFKx8dXCATqK2iw4V80OxrvfMD2yRq3FcPxUChTBPTdGCQNUULAc9P18uvsU57RLjHugVpsygaIqx3SAw6bkif9usQLgrL6WVM1rQDN0I41BjtOvxWgdulSIe1memIaX0SAE6nTUFtYqfaSP2J36H49S8w7oIx2DMIOCIoHa+i0z6Cwj+ix/NgRiiabzQM5FNewaQ32jOIZjp2FY1ig6aFocwaNrPDpSb4qskxh7DRWwkg8advU1r9AS3FBGiMe3A0TTFaGxnPHKpsopf63vdHCAu00Kj9PuX/HHrxrq0Q28x57RAFo8TPYoVrL+9mik3TCWbBhufx9WCJwLv8rYG5F0T0Mq5FHj8UQ9678lGCy8Xqr2IKU7C9lRXUOCmmiLxPUJo2qvKojO3dynws8/q0ecBkm++2vBjgI523GYeEZoFRNJkf+YKsBhMCgPPPSyy/65UREvEGs8WFt/8J9u7twQV3LVYpPFFJ7R68S5a826Drrcq90lUikbkCyaBrh/Ijn0uUIKFJt9Hx2Ye0vlYxVf8B3zLOz0fxu85s/uMF5A4oCHldRmhyB/HGsu6kjcWkEzV50FWsnBrsuO17NLaKPTG/YNNA4F77TgKblQ31Msy17g+HT5S3TytHxov2XvNJnJ1Ef0k7PnXkPaeWov+1z2cQHmGu+lG8Q7G/NfejqchR0f/J4QhYy8uzqCX7
 HpYMdsox
 dH8VIKcL3oV/YuR2RweEJn1Ja9i5s+qlxId4bNx0qjgOkoujXbx58G8r0/NdJPUtX++6/H1b/Ey1wHUzXmnAM2aTV0BhkyGQ98IEoB/RbeqUf3MY/EvxCRE7xqqUajbA+5uXcfNLM7ovd54zO9fOvoRQevrKuJq5XV8aU3gWQuBP6o9PsAXG5oPEZ9XGiAElhqNaLXsfv5EkUf/p6nV7me9S/F3Y0QzvUIIs8x/s37kAZ48nrFxgaVtAS402Rov8rGZoxrZzeiRnFiLaKCQDacjKO3/Cxy8YZVL9agx494KJewkpfPAhpQ132j1Twz0Pzkct8VJt7S3I6NS5JKXg/K/1isM1dRWccziL9h+t3qUzW/47imcHj47gAa7Z6GkDQECrm0pRleCptkYTEPF9esTAKoKSAj5w0PqhtQoXbuFfcZVa1koWcsJqL15GE9i/BR7B2fj5cgExR+D1eoJZ/iKrmM8mbTiHazGfVOkUOCy61XXHcRrnxgIktaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, each PMD scan always increases `progress` by HPAGE_PMD_NR,
even if only scanning a single page. By counting the actual number of
pages scanned, the `progress` is tracked accurately.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f99f61689f8..4b124e854e2e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1247,7 +1247,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				   struct vm_area_struct *vma,
 				   unsigned long start_addr, bool *mmap_locked,
-				   struct collapse_control *cc)
+				   int *progress, struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1258,23 +1258,28 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
+	int _progress = 0;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED) {
+		_progress = HPAGE_PMD_NR;
 		goto out;
+	}
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
+		_progress = HPAGE_PMD_NR;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
+		_progress++;
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
@@ -1410,6 +1415,9 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		*mmap_locked = false;
 	}
 out:
+	if (progress)
+		*progress += _progress;
+
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
@@ -2287,7 +2295,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 
 static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 				    struct file *file, pgoff_t start,
-				    struct collapse_control *cc)
+				    int *progress, struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2295,6 +2303,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	int result = SCAN_SUCCEED;
+	int _progress = 0;
 
 	present = 0;
 	swap = 0;
@@ -2327,6 +2336,8 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 			continue;
 		}
 
+		_progress += folio_nr_pages(folio);
+
 		if (folio_order(folio) == HPAGE_PMD_ORDER &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
@@ -2388,6 +2399,9 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		}
 	}
 
+	if (progress)
+		*progress += _progress;
+
 	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
@@ -2470,7 +2484,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2484,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&progress, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2492,7 +2508,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2810,11 +2825,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+							 &mmap_locked, NULL, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
-- 
2.51.0


