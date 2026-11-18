Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90142606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QZeNJ9ic
Received: by kanga.kvack.org (Postfix)
	id 8F9816B05EE; Wed, 18 Nov 2026 16:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB8D6B05EF; Wed, 18 Nov 2026 16:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798EF6B05F0; Wed, 18 Nov 2026 16:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 470706B05EE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:37:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEA421608D2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:37:00 +0000 (UTC)
X-FDA: 85449550200.25.2185D98
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id EC22D160007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:36:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QZeNJ9ic;
	spf=pass (imf08.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795037818;
	b=Xe6N6KmIeCDXdJ0Ayo30BoMjiTjb4e8Ikk3gozoZwJG/Va2da08TqvhJmKyIoyhe5LWmQt
	iYnvwYSYctlaqm+/0LtNMJEcg+JdGCi4jVEGFMQbfgz/HgEOfyL2cFeYiLUL3dz4K9knER
	0fm2KV4LAZ9FoDJYCFc44+Hkobr78dc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jueD/zAqTRryGAU3lxXfF2kbgJjijJ/SU4DUI0J/kBI=;
	b=Pbj7CyoK4lQlP8McT6Zth3MP7r0a3Ex1aB3/Wp7E5peeWmlfoc6rK0vm9wSAfgrmjWN8b2
	Czy3HCzKXr1EX9duVWJbaTCDTJxWyAMdej/3vZmZO6XfdqS2h6JbJ1l2lAYsfDownnirWo
	CqEFJofKyAZvLyIF3/dsohW2r9wkdSY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QZeNJ9ic;
	spf=pass (imf08.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b4dd5cb4f6so10897487b3.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795037818; x=1795642618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jueD/zAqTRryGAU3lxXfF2kbgJjijJ/SU4DUI0J/kBI=;
        b=QZeNJ9icXCvGHjLmM2qbzPPkBwzWD/Ltm3LCQfCU18sZXV/dYxCb5x4WX/PhQBz64P
         tel6gnZrUJKEUoF89GKx0axpD7Jr6msmL/kmVNOmgrCCudQZ075E5bPzJ60zVip138ls
         QZK6w8J0EYlRRTdXXfoySj7WMnya48VvDZXxxzjENo47xkKDYHdGwB0fcaJwesRLdCi2
         qKV3Z7B11uufalLG0ZGYixv6kJWwH8q6MeToCUv7nysVILD2kvkF1fx+nW8XnGze91HX
         8xXgV903ZNbnMpO6jvhCBTCSCuKz1H1j5H/RGCvjc5/HI0LMCtB2O0ZGjcFk5u8Ofxcq
         OFig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037818; x=1795642618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jueD/zAqTRryGAU3lxXfF2kbgJjijJ/SU4DUI0J/kBI=;
        b=DBXcqIqhsWa3rvJ6sEuC5dCCmys/jQxKL+YZXSf/EqbqgjwkOexVvWrXaQu/UUcnNf
         m4ZyI9SpnuuPzXtW8AWmp5Up3lBaYVVrPFeos56jt9rLjka3v/Ca/HZAOLIOw8pgM8ZF
         YJm3M15ZZc6ZgByVWXQMCuUBlk5Z6Ro2YWbuZe47P66EHD+6i8MuZ7yX3zqmKazxONfn
         tIBqWe8MQoGNWv8yoHvOEQZTUV1RoSH81gWiXtrwQOBrJ/t1BtSjLMAsUttfkPrRYAeC
         ej16tq8E+Ij+LiZBW2S6kf5sbzkD2qvL0laE0QYJIgd9oqJ9zVNIsCILUdYsGYBowGcR
         Anzw==
X-Gm-Message-State: APuU4Z+D2R8H4vTsDRi02ubUwAWWDykrK+F1cVbZAIQrgWZlGcBL8Zj5
	TlMSRvHpUidJn+cmtnVgkiwn7QV/yHMhj1hP3HcD3fisdxL2iTVJtVyT
X-Gm-Gg: AZFdTZfFFVd9qz7xUC82Q0s5Nq+T7O2bpSU8zVMCqXcwwwJ0LLDbyS8sIJG5TqxcppT
	aY7gTtnLwc8r/h70fEBQDBHdhNVYJao2r2p7x0f9X68N7G69kNcAcneWSQqLjYCUa9y9xaN8DPq
	LWGa1ZFHcp53eVOXKyN48DWfNXOOh8vztqe1MJifax1Th2xCRtfTaBavCwpSnRU7A97twJHOat2
	v9xaq8msDRv3SZxx3VMC1JyyufbVvLHD05M371gkH/XXQHf9O2drHZEG3Bg8hg9t9J61EnAkoOK
	cVeGQEA8UT2OdwkQqK91fN8OLBAFEfRBzjP/jfshFJwTzr/cuFSWh8uuEyUDrXyU1oPGo5H01K8
	agnx5g/s1qIhjDdgnLRUNsJDyPSrJcPvJTG1FpqL/NYouvQDlOnpXjFQT1il6DWfoBDhNuWfjFS
	ZOnWjGPS9lFkHMwi+QBMQ2FF4kl8/+WU2tsCMkFu1BiZj7a/QrTVJupf6UB6zFIwvtnvaTowtEJ
	Z3d6148StpQXeg/5TAtSydlOzFlQWeWAa0wgtyoKVRK3pElqqDRf2cjgnp24TjVhy09LIXXrv2i
	OHecmY1t+drANXdOkqpp2gYefwMG/FDljmfBc11TwfP0jqOqy2N940RqIs+SOUdbIbWUkIYW+c2
	RkA==
X-Received: by 2002:a05:690c:498a:b0:8b3:22c:b40c with SMTP id 00721157ae682-8b4febcd465mr17414927b3.7.1795037817800;
        Wed, 18 Nov 2026 13:36:57 -0800 (PST)
Received: from 5163NRD-SPrabh2.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4fe030be2sm24565697b3.10.2026.11.18.13.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:36:57 -0800 (PST)
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	viro@zeniv.linux.org.uk
Cc: linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dave@stgolabs.net,
	riel@surriel.com,
	yeoreum.yun@arm.com,
	hch@lst.de,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [PATCH 2/5] mm/gup: make the slow path walkers record into struct gup_out
Date: Wed, 18 Nov 2026 13:34:55 -0800
Message-ID: <20261118213458.377258-3-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118213458.377258-1-sw.prabhu6@gmail.com>
References: <20261118213458.377258-1-sw.prabhu6@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: e91yzrs4j16wfhjtctchm5pnybnh6rb4
X-Rspamd-Queue-Id: EC22D160007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795037818-874955
X-HE-Meta: U2FsdGVkX1+EwXP8asuz9fwSLsXIbNGN27GMoTx4t1/UF5WQOuYkhBih6/O6ssRByyiwjlGvVLEXBFO+x4iksd9ruHu/Eu2xtG0vf4f3UuC99EU1EtDeX6znytZ1AxZj3GWR2Wh2+nCmHe+qSVpMdhGgPPuutqbBQzYpzgACehcFGJ/OgO1b/aED/XBVtl6dDtuv0qNSVrOz9l7dqKtJojSqfIbt3XmqGm2Z09rIcxx7ByoDJQdQRhVuu5AOMJbm/fh5qNVixDT1K84KFPordQf6iPux9yyOJ+5UOjojtV0xBTWVpTeN6TJaxIY6idD5NqtC3+L2zXQtpkL1Qw0ZaWbw7LRYBAIXAvGmb0Dr9SNqjy1HZJhVZOfLM2Urn6feFpCopbHW1j1DSXyPIlFCPCTydCr54U/vUsH/zfcnAUR2q1vps6K0eCqRKc33kmGkr6a5oRLXce83PgcwMNJq3waskGJNig4jr/SRALijJe3vcsiB39OuJbBDWB52Y/oAnttnPXSIhV6ALEFANLfHH+3bklREcRnVVFBvg4I5SkHE6D8jMG1lfVNXRAJLgmpAd57vjClxPuA7w5+1I+pK3VlAxieAS0vfi0t7tK72jbxm0fkDk6jX4A+KDkr6Pgq8HGzlKTHEsAnQdz0ybaLdoSmyolmgGM3Ir4R/11LWm1gtBcKkRaKhik7Nz3PBK6tmhJok3vK9T5t3wKmsQZYPJ4avlc/PurDxGrlTR+d6kiPGzmUshvjAUL+guiDR4VTVvSV9AA+IaCz8SbjSDMbgGEG1lDBSQTouXSWHV9xhcDXir2AJX2WSrMDu8MOiH5uNIi3bRbjtwVlfpf49uxv2q7Rg2xS5cO6LhvhOcZNPT0SodGW8306hLX6SdJfyKj6I4xTXU8qL0wd5+/cD6zmn/DsvoiJh/l7r3jNSbLcu0B0oRb0zlH2FloKgYRTn4boMFHk24ym1lHnBfV34lJH
 3JFDLAOL
 5xmUrtOnrsbYDaOb84Eresv9Qd3KVDqsf/VzmipL3bG2ubnKiylCmtsDtzQZnGNs+1LLNUZQAXJqvwtN673JmXYSyMjtbOKGfaSXswEvC2F/cD4chOMGNyC5GRVCR+8mPdslRT++qpvfUf/M/shUU/SVXuytjMF0vQ6dOnLnFtuGyARy5phFZAVbcoNRe2dWg7dHfnyDhS8/JKmPLQm0hB7v+54DP7AoxpxV6MLiFG4XlRE8Gyh21WMjjyUA9MPyTv2F2B7AQ5ea8FL8zXQYy3YdnXvgd2M+ZELp3WEf3lnlOa1Rn2nLHG9pLyp71ihdst2/xdFxkRGUd1Ng3fXi4FrRExMnvemjIw4yD+gjzTgw/NUKcAf7a/sDlAbaQaxnRcPmfJgjM2XsMDELHPcJgXUr8hpk3awlkqrZ64OLiADNPIIutJR/TNJ2xKNH9BcVSUpklAlGdY5cvLEJXGEhf7A85DNrG2Bo8ffbjoP8IVTz4rquHYQNzs92AWAVqmn++g+kVxGsEFC83fyY+Q4jLIvHnIEufEjwUGS9cFJXdl7oq7XwURxZXuMOjqNd+EkZMss5JIpZC1eS191DZVG0XM0uMWR46HOFwdrKrGoOOrDYUvhJaJMIQLY984dM//TYsX3hl6/DJ8uqjAHpGNd7Yr7T2cUy1kGVKdWmt55J6tOFjjTTCpTejQtugbSTTaypRPx3l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Swarna Prabhu <s.prabhu@samsung.com>

Pass 'struct gup_out' down the slow path in place of the pages array.

For PMD/PUD leaves, receive the first page in a local variable and
append the run through 'gup_fill_pages' after unlocking.
'gup_grab_folio_pages()' appends PTE runs under the page table lock
and 'gup_flush_pages()' flushes the newly recorded pages once
the lock has been dropped.

Descriptor based appending removes the pages[] pointer bumping in
'__get_user_pages_locked()'. !CONFIG_MMU walker records through the
descriptor as well.

Retain the existing array-based interface as wrappers around the new
*_out variants. With FOLL_LONGTERM a retry restores the descriptor
to where it was before, discarding what the failed attempt recorded.

No functional change.

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Assisted-by: LLM
---
 mm/gup.c | 214 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 131 insertions(+), 83 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0433579ed618..0b8dd3fde06b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -749,36 +749,40 @@ static inline bool gup_must_unshare(struct vm_area_struct *vma,
 	return gup_pages_not_requiring_unshare(vma, flags, folio, page, 1) != 1;
 }
 
+/* Record @nr pages starting at @page in @out, and flush their caches. */
 static void gup_fill_pages(struct vm_area_struct *vma, unsigned long address,
-		struct page *page, unsigned long nr, struct page **pages)
+		struct page *page, unsigned long nr, struct gup_out *out)
 {
 	unsigned long i;
 
-	if (!pages)
+	if (!out)
 		return;
 
+	gup_out_add_range(out, page_folio(page), page, nr);
+
 	for (i = 0; i < nr; i++) {
 		struct page *subpage = page + i;
 
-		pages[i] = subpage;
 		flush_anon_page(vma, subpage, address + i * PAGE_SIZE);
 		flush_dcache_page(subpage);
 	}
 }
 
 /*
- * Flush the caches for @nr pages stored in @pages. The caller already
- * holds folio references, so the pages cannot go away; this runs
- * without any page table lock held.
+ * Flush the caches for the @nr pages most recently recorded in @out, the first
+ * of which is mapped at @address. The caller already holds folio references,
+ * so the pages cannot go away; this runs without any page table lock held.
  */
 static void gup_flush_pages(struct vm_area_struct *vma, unsigned long address,
-		struct page **pages, unsigned long nr)
+		struct gup_out *out, unsigned long nr)
 {
+	struct page **pages;
 	unsigned long i;
 
-	if (!pages)
+	if (!out)
 		return;
 
+	pages = out->pages + out->nr_pages - nr;
 	for (i = 0; i < nr; i++) {
 		flush_anon_page(vma, pages[i], address + i * PAGE_SIZE);
 		flush_dcache_page(pages[i]);
@@ -972,9 +976,8 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
  */
 static long gup_grab_folio_pages(struct folio *folio,
 		struct page *page, unsigned long nr, bool dirty,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
-	unsigned long i;
 	long ret;
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
@@ -1005,10 +1008,8 @@ static long gup_grab_folio_pages(struct folio *folio,
 		folio_mark_accessed(folio);
 	}
 
-	if (pages) {
-		for (i = 0; i < nr; i++)
-			pages[i] = page + i;
-	}
+	if (out)
+		gup_out_add_range(out, folio, page, nr);
 
 	return 0;
 }
@@ -1100,7 +1101,7 @@ static unsigned long gup_pte_batch_len(struct vm_area_struct *vma,
  */
 static long follow_page_pte(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pmd_t *pmd,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	bool need_no_page_table = false;
@@ -1143,8 +1144,7 @@ static long follow_page_pte(struct vm_area_struct *vma,
 		batch = gup_pte_batch_len(vma, address, walk_end, folio,
 					 ptep, &batch_pte, flags);
 		ret = gup_grab_folio_pages(folio, page, batch,
-						     pte_dirty(batch_pte), flags,
-						     pages ? pages + nr : NULL);
+						     pte_dirty(batch_pte), flags, out);
 		if (ret)
 			break;
 		nr += batch;
@@ -1158,7 +1158,7 @@ static long follow_page_pte(struct vm_area_struct *vma,
 	pte_unmap_unlock(orig_ptep, ptl);
 
 	if (nr) {
-		gup_flush_pages(vma, base, pages, nr);
+		gup_flush_pages(vma, base, out, nr);
 		return nr;
 	}
 	if (need_no_page_table)
@@ -1168,9 +1168,10 @@ static long follow_page_pte(struct vm_area_struct *vma,
 
 static long follow_pmd_mask(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pud_t *pudp,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	pmd_t *pmd, pmdval;
+	struct page *page;
 	spinlock_t *ptl;
 	long ret;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1182,7 +1183,7 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, end, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, out);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -1195,33 +1196,34 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, end, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, out);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? -ENOMEM :
-			follow_page_pte(vma, address, end, pmd, flags, pages);
+			follow_page_pte(vma, address, end, pmd, flags, out);
 	}
-	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
+	ret = follow_huge_pmd(vma, address, end, pmd, flags, &page);
 	spin_unlock(ptl);
 
 	/*
-	 * The ref is already held, so the page cannot go away: fill the
-	 * array and flush caches without the pmd lock.
+	 * The ref is already held, so the page cannot go away: record the
+	 * pages and flush caches without the pmd lock.
 	 */
-	if (ret > 0 && pages)
-		gup_fill_pages(vma, address, pages[0], ret, pages);
+	if (ret > 0)
+		gup_fill_pages(vma, address, page, ret, out);
 
 	return ret;
 }
 
 static long follow_pud_mask(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, p4d_t *p4dp,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	pud_t *pudp, pud;
+	struct page *page;
 	spinlock_t *ptl;
 	long ret;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1232,16 +1234,16 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		ret = follow_huge_pud(vma, address, end, pudp, flags, pages);
+		ret = follow_huge_pud(vma, address, end, pudp, flags, &page);
 		spin_unlock(ptl);
 		/*
-		 * The ref is already held, so the page cannot go away: fill
-		 * the array and flush caches without the lock. A 1 GB folio
+		 * The ref is already held, so the page cannot go away: record
+		 * the pages and flush caches without the lock. A 1 GB folio
 		 * can be up to HPAGE_PUD_NR pages, too long to flush under a
 		 * spinlock.
 		 */
-		if (ret > 0 && pages)
-			gup_fill_pages(vma, address, pages[0], ret, pages);
+		if (ret > 0)
+			gup_fill_pages(vma, address, page, ret, out);
 		if (ret)
 			return ret;
 		return no_page_table(vma, flags, address);
@@ -1249,12 +1251,12 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 	if (unlikely(pud_bad(pud)))
 		return no_page_table(vma, flags, address);
 
-	return follow_pmd_mask(vma, address, end, pudp, flags, pages);
+	return follow_pmd_mask(vma, address, end, pudp, flags, out);
 }
 
 static long follow_p4d_mask(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgd_t *pgdp,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	p4d_t *p4dp, p4d;
 
@@ -1265,7 +1267,7 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, end, p4dp, flags, pages);
+	return follow_pud_mask(vma, address, end, p4dp, flags, out);
 }
 
 /**
@@ -1274,9 +1276,9 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
  * @address: virtual address to look up
  * @end: virtual address at which to stop batching contiguous pages
  * @flags: flags modifying lookup behaviour
- * @pages: array to receive the pages, refcounted per @flags, or NULL to
- *         walk the page tables (e.g. to fault pages in) without collecting
- *         or refcounting them
+ * @out: output descriptor to receive the pages, refcounted per @flags, or
+ *       NULL to walk the page tables (e.g. to fault pages in) without
+ *       collecting or refcounting them
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -1286,14 +1288,14 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
  * relevant with FOLL_PIN and !FOLL_WRITE.
  *
  * Return: the number of contiguous pages starting at @address that were
- * placed into @pages (if non-NULL), which may be fewer than the pages
+ * recorded in @out (if non-NULL), which may be fewer than the pages
  * requested via @end; 0 if no mapping exists at @address; or a negative
  * errno for a mapping to something not represented by a page descriptor
  * (see also vm_normal_page()).
  */
 static long follow_page_mask(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1306,7 +1308,7 @@ static long follow_page_mask(struct vm_area_struct *vma,
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		ret = no_page_table(vma, flags, address);
 	else
-		ret = follow_p4d_mask(vma, address, end, pgd, flags, pages);
+		ret = follow_p4d_mask(vma, address, end, pgd, flags, out);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1589,9 +1591,8 @@ static struct vm_area_struct *gup_vma_lookup(struct mm_struct *mm,
  * @start:	starting user address
  * @nr_pages:	number of pages from start to pin
  * @gup_flags:	flags modifying pin behaviour
- * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_pages long. Or NULL, if caller
- *		only intends to ensure the pages are faulted in.
+ * @out:	output descriptor receiving the pinned pages, or NULL if the
+ *		caller only intends to ensure the pages are faulted in.
  * @locked:     whether we're still with the mmap_lock held
  *
  * Returns either number of pages pinned (which may be less than the
@@ -1639,7 +1640,7 @@ static struct vm_area_struct *gup_vma_lookup(struct mm_struct *mm,
  */
 static long __get_user_pages(struct mm_struct *mm,
 		unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
+		unsigned int gup_flags, struct gup_out *out,
 		int *locked)
 {
 	long ret = 0, i = 0;
@@ -1650,7 +1651,7 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	start = untagged_addr_remote(mm, start);
 
-	VM_WARN_ON_ONCE(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
+	VM_WARN_ON_ONCE(!!out != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
 
 	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
 	VM_WARN_ON_ONCE((gup_flags & (FOLL_PIN | FOLL_GET)) ==
@@ -1682,11 +1683,10 @@ static long __get_user_pages(struct mm_struct *mm,
 			if (!vma && in_gate_area(mm, start)) {
 				ret = get_gate_page(mm, start & PAGE_MASK,
 						gup_flags, &vma,
-						pages ? &page : NULL);
+						out ? &page : NULL);
 				if (ret)
 					goto out;
-				gup_fill_pages(vma, start, page, 1,
-					       pages ? pages + i : NULL);
+				gup_fill_pages(vma, start, page, 1, out);
 				i++;
 				start += PAGE_SIZE;
 				nr_pages--;
@@ -1713,7 +1713,7 @@ static long __get_user_pages(struct mm_struct *mm,
 		cond_resched();
 
 		nr = follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
-				      gup_flags, pages ? &pages[i] : NULL);
+				      gup_flags, out);
 		if (!nr || nr == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   nr == -EMLINK, locked);
@@ -1733,12 +1733,12 @@ static long __get_user_pages(struct mm_struct *mm,
 		} else if (nr == -EEXIST) {
 			/*
 			 * Proper page table entry exists, but no corresponding
-			 * struct page. If the caller expects **pages to be
-			 * filled in, bail out now, because that can't be done
+			 * struct page. If the caller expects the pages to be
+			 * reported, bail out now, because that can't be done
 			 * for this page. Otherwise advance by the one page
 			 * follow_page_mask() looked at.
 			 */
-			if (pages) {
+			if (out) {
 				ret = nr;
 				goto out;
 			}
@@ -1896,10 +1896,10 @@ static bool gup_signal_pending(unsigned int flags)
  * Please note that this function, unlike __get_user_pages(), will not return 0
  * for nr_pages > 0, unless FOLL_NOWAIT is used.
  */
-static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
+static __always_inline long __get_user_pages_locked_out(struct mm_struct *mm,
 						unsigned long start,
 						unsigned long nr_pages,
-						struct page **pages,
+						struct gup_out *out,
 						int *locked,
 						unsigned int flags)
 {
@@ -1934,12 +1934,12 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 	 * FOLL_PIN always expects pages to be non-null, but no need to assert
 	 * that here, as any failures will be obvious enough.
 	 */
-	if (pages && !(flags & FOLL_PIN))
+	if (out && !(flags & FOLL_PIN))
 		flags |= FOLL_GET;
 
 	pages_done = 0;
 	for (;;) {
-		ret = __get_user_pages(mm, start, nr_pages, flags, pages,
+		ret = __get_user_pages(mm, start, nr_pages, flags, out,
 				       locked);
 		if (!(flags & FOLL_UNLOCKABLE)) {
 			/* VM_FAULT_RETRY couldn't trigger, bypass */
@@ -1965,12 +1965,7 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 				pages_done = ret;
 			break;
 		}
-		/*
-		 * VM_FAULT_RETRY triggered, so seek to the faulting offset.
-		 * For the prefault case (!pages) we only update counts.
-		 */
-		if (likely(pages))
-			pages += ret;
+		/* VM_FAULT_RETRY triggered, so seek to the faulting offset. */
 		start += ret << PAGE_SHIFT;
 
 		/* The lock was temporarily dropped, so we must unlock later */
@@ -2000,7 +1995,7 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 
 		*locked = 1;
 		ret = __get_user_pages(mm, start, 1, flags | FOLL_TRIED,
-				       pages, locked);
+				       out, locked);
 		if (!*locked) {
 			/* Continue to retry until we succeeded */
 			VM_WARN_ON_ONCE(ret != 0);
@@ -2016,8 +2011,6 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 		pages_done++;
 		if (!nr_pages)
 			break;
-		if (likely(pages))
-			pages++;
 		start += PAGE_SIZE;
 	}
 	if (must_unlock && *locked) {
@@ -2040,6 +2033,19 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 	return pages_done;
 }
 
+static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
+						unsigned long start,
+						unsigned long nr_pages,
+						struct page **pages,
+						int *locked,
+						unsigned int flags)
+{
+	struct gup_out out = GUP_OUT_PAGES(pages);
+
+	return __get_user_pages_locked_out(mm, start, nr_pages,
+					   pages ? &out : NULL, locked, flags);
+}
+
 /**
  * populate_vma_page_range() -  populate a range of pages in the vma.
  * @vma:   target vma
@@ -2230,8 +2236,8 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 	return ret;	/* 0 or negative error code */
 }
 #else /* CONFIG_MMU */
-static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
-		unsigned long nr_pages, struct page **pages,
+static long __get_user_pages_locked_out(struct mm_struct *mm, unsigned long start,
+		unsigned long nr_pages, struct gup_out *out,
 		int *locked, unsigned int foll_flags)
 {
 	struct vm_area_struct *vma;
@@ -2255,7 +2261,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	}
 
 	/* See the MMU variant: support the traditional behavior. */
-	if (pages && !(foll_flags & FOLL_PIN))
+	if (out && !(foll_flags & FOLL_PIN))
 		foll_flags |= FOLL_GET;
 
 	/* calculate required read or write permissions.
@@ -2276,16 +2282,19 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		    !(vm_flags & vma->vm_flags))
 			break;
 
-		if (pages) {
-			pages[i] = virt_to_page((void *)start);
-			if (!pages[i])
+		if (out) {
+			struct page *page = virt_to_page((void *)start);
+			struct folio *folio;
+
+			if (!page)
 				break;
-			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+			folio = page_folio(page);
+			ret = try_grab_folio(folio, 1, foll_flags);
 			if (unlikely(ret)) {
-				pages[i] = NULL;
 				err = ret;
 				break;
 			}
+			gup_out_add_range(out, folio, page, 1);
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2298,6 +2307,17 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
 	return i ? : err;
 }
+
+static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
+		unsigned long nr_pages, struct page **pages,
+		int *locked, unsigned int foll_flags)
+{
+	struct gup_out out = GUP_OUT_PAGES(pages);
+
+	return __get_user_pages_locked_out(mm, start, nr_pages,
+					   pages ? &out : NULL, locked,
+					   foll_flags);
+}
 #endif /* !CONFIG_MMU */
 
 /**
@@ -2722,37 +2742,65 @@ static long check_and_migrate_movable_folios(unsigned long nr_folios,
  * __gup_longterm_locked() is a wrapper for __get_user_pages_locked which
  * allows us to process the FOLL_LONGTERM flag.
  */
-static long __gup_longterm_locked(struct mm_struct *mm,
+static long __gup_longterm_locked_out(struct mm_struct *mm,
 				  unsigned long start,
 				  unsigned long nr_pages,
-				  struct page **pages,
+				  struct gup_out *out,
 				  int *locked,
 				  unsigned int gup_flags)
 {
+	unsigned long nr_pages_done;
 	unsigned int flags;
 	long rc, nr_pinned_pages;
 
 	if (!(gup_flags & FOLL_LONGTERM))
-		return __get_user_pages_locked(mm, start, nr_pages, pages,
-					       locked, gup_flags);
+		return __get_user_pages_locked_out(mm, start, nr_pages, out,
+						   locked, gup_flags);
+
+	if (WARN_ON_ONCE(!out))
+		return -EINVAL;
+
+	/*
+	 * We might have to start over, in which case everything recorded by
+	 * this call has to be discarded again.
+	 */
+	nr_pages_done = out->nr_pages;
 
 	flags = memalloc_pin_save();
 	do {
-		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
-							  pages, locked,
-							  gup_flags);
+		out->nr_pages = nr_pages_done;
+
+		nr_pinned_pages = __get_user_pages_locked_out(mm, start,
+							      nr_pages, out,
+							      locked,
+							      gup_flags);
 		if (nr_pinned_pages <= 0) {
 			rc = nr_pinned_pages;
 			break;
 		}
 
 		/* FOLL_LONGTERM implies FOLL_PIN */
-		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages);
+		rc = check_and_migrate_movable_pages(nr_pinned_pages,
+						     out->pages + nr_pages_done);
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 	return rc ? rc : nr_pinned_pages;
 }
 
+static long __gup_longterm_locked(struct mm_struct *mm,
+				  unsigned long start,
+				  unsigned long nr_pages,
+				  struct page **pages,
+				  int *locked,
+				  unsigned int gup_flags)
+{
+	struct gup_out out = GUP_OUT_PAGES(pages);
+
+	return __gup_longterm_locked_out(mm, start, nr_pages,
+					 pages ? &out : NULL, locked,
+					 gup_flags);
+}
+
 #define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
 			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE | \
 			    FOLL_MADV_POPULATE)
-- 
2.53.0


