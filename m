Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECFEC87FD3
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 06:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C89F6B007B; Mon,  4 Aug 2025 02:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079736B0088; Mon,  4 Aug 2025 02:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0D96B0089; Mon,  4 Aug 2025 02:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD9A46B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:42:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2488E80E97
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:42:01 +0000 (UTC)
X-FDA: 83738130042.08.48B5A0D
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6183CC0002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:41:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XkNbRBkN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754289719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=blILZd0jaVD7kgPmyUMPG0nKzRyK2MAoftkqaSrZHBs=;
	b=dVEEpn/PLDOGQ/vszdIabCztCFc4LIKkShrDzhvmF82qDt1wOmEmQ/fh2UPxcYC5UFUA6u
	txrqtSbmGe8wS2nHxKALN7hc9ES5EkgDqt5j+iiQC7hUQ0ngPBOcRz9uEkFzN3b02EBNgg
	KBxn0J+0s2xvlpak2L6ZiYXEQtkIO60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754289719; a=rsa-sha256;
	cv=none;
	b=jKzBkIVRr/9THSexbXirADTBvuO44E8HJBqG1n00HWzcKDlzW7Udq5zdP2LtftJdKfBXG2
	rRVEvvSGzR0XEN2CtmybeAbL3B2xSE8GLjyiVU3vdwdG8j+n11vDUz0NSJhvyHz/uPyEgl
	gXIwxUrK/MvgQqVzos+fO/lf4GqKBo0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XkNbRBkN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6154d14d6b7so3401296a12.2
        for <linux-mm@kvack.org>; Sun, 03 Aug 2025 23:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754289717; x=1754894517; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=blILZd0jaVD7kgPmyUMPG0nKzRyK2MAoftkqaSrZHBs=;
        b=XkNbRBkNVTXxCzolG55XSW/dWQCYnpMU3U4rhM7lY83VEVQXdpvF5+QtuYJIaJUqUy
         n8xCPGernXJlsTkleHHX9YG4iY/d62M0GrDZVilcAeU8N26GbCtJcDFloGHA9Y/D+55r
         l4rmQDjEuLlxIMt0buX2xrKFHhTDQz3y0IBrZ60E/ayj3OsUSc+DC8XWdUWfNzRKuaIG
         TWLgwnS/M5ISvHncBkAaUR7OC9OSLWa/fEH7/L6RXeo6SqL1+G5G223xn4Q0KjekraV/
         t81IA2cd+7PlZqb4q6YlL/zSw4zozR8qqD6SU817BxBqsH8oupxATDnO0cy4KzHfM+Ia
         fxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754289717; x=1754894517;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=blILZd0jaVD7kgPmyUMPG0nKzRyK2MAoftkqaSrZHBs=;
        b=XsJi19/KArjIeSkgS05XyqV3E4Uo/1KnAqcILxc/Q4wwkLnM34jHJRL9xw4+7unyX4
         I2+cJuNhXgQCySDfZlR8mQ1pRYaJerDMPVmy/4hZci3Nx6EWeJ29U4K2Pk26ogL3tmeE
         JIpSJHsGEMucDtPGmQT+q4eNJFFYP4eqog5YYq3ApqXhJob5xy9pSgnmLsvvqcrirfqR
         XB/xOBpRNNtPxafX+rR2MWmxhQcIvfcfy3dFvF0RTfc/OrrvzjQIxgLWnigPT1QVC7QS
         hO9xE8u/Gr/Y55W+vwRGBrLeiZLmvOfGSn9FikFm7khO9M9t/Zvmb6ZXV4gVexyxqkqH
         g4SQ==
X-Gm-Message-State: AOJu0Yy1cPqlhf2Tl/KoTV4GYvQCg2sURbKH3eSRuRMdhyNDmjI8rRFu
	uT7a/yQi5xb3o7mE9SqpR0SzYw0W+eStvsB85hTRfokHWvQrIZMY04yC
X-Gm-Gg: ASbGncsQ532Mk8jzObyl7U8uguQkzMJ043lH1ug1HJvb5QsfUItMGzevN8lvqWTvEkT
	v8PGxfUd05xlO6kYpjxFMFwIhDqK43D+CD7QZtgtbVtsEhHiQhf2JJHX684zsvPCJCk5WYM+/Uc
	8NVz3//u2F2XUioq0yKpOXplAMWp2kvLAmI6Wt9exdELJLpAd+25ARJHHihdtA+N9lvNngpo9uc
	BhE/KxmH6yk9ROu3nIJXy8so0q93OjsKZ077niwpCC1jnes1AuzA+3Iwc4Yki0BdmVV3pLkuxux
	eFYq4U11VFZ1zgnn5bWxODgz4nqCgAIfiV0uEWhKXoW7yec8/q3dmq1SwddVN9Toor4Y9Ppok0c
	rmaLD/HJ/RDSEWvV2qCapQQ==
X-Google-Smtp-Source: AGHT+IGSjxjdEFnPNbutzE2xY3GfFH2YFX1IILFt1fMhXSFZTs4PwnEIQi3BaMZ8HQZsizHF/UBF8g==
X-Received: by 2002:a17:907:97c5:b0:ae3:63fd:c3af with SMTP id a640c23a62f3a-af94000dda6mr879994666b.16.1754289717349;
        Sun, 03 Aug 2025 23:41:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a240645sm684180266b.125.2025.08.03.23.41.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 03 Aug 2025 23:41:56 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH] mm/rmap: do __folio_mod_stat() in __folio_add_rmap()
Date: Mon,  4 Aug 2025 06:41:06 +0000
Message-Id: <20250804064106.21269-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: f1i3s59pygd9phc9n8mpfptzbp4uhajk
X-Rspamd-Queue-Id: 6183CC0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754289719-205422
X-HE-Meta: U2FsdGVkX189R6o4wTQexb+oxQk/32e9loYKPvQiR2+Pd3sXRBtfrYfQ45IaX9ZHwgGEYOiRUa/g0eWgwYGij8FLlrbtFS4OzlfBDks/SDgEuJPD8T0cAte55EVDIEougkJj7+TQ92x9VXSIlM+sp7ENIzI/8qN8oRfC/dbLW/pqLOfy1URqYlc2/oNq9BMyUgwyTYRodwmFvJEOXK68XBOPHJp+ys/WopHqvi3vcwFG+T/KWrlPt7RugJk4BZL13uMSHkSVUmPwPEllR7czR/ZCZB8oOa0RXgIC2SHdtIKouCqrKRm+pTuMYntCplLowSowpQTiRldBe0ZT+qT4QsW0b1DANC1XCYHSVtrjWZdtaIacnTKZUIaP9Lc3WfO+7pEsGHAhYRAeXPFJd8arqb0Fgi+nh+lhJNq2bkRQAnXsBZuEb11qkTpAaY9FtVgZw7tXkVp2dAAynzHVb6Dsy4YSio9O92q/49+c4y303xHXOdYIKG9p2dKFYFOuoBhj4yVFNdf60QuBS/0OIrSdLXmrcF4VhZzGH/hMgsP2cqkR9XFIG4lby7BzYt41iQMvjeTfZADOoNY1r0EzxvarSuquSS4iwtHgbeNfQ4iJmbSYWveyzJdaS4T3lM85c6h+//Zy/HL7LGFtmWdgNeY4XDmq7Nqk9uKNiXqDCqfGdmAidgp77HlWguVtgdZG6FqiXUAL0D4zijV9PhdqGGtp1QB0PsaUcZbi6kAddW7RW/51glaRfIbnVKrBC6Qs0kSWbp3DJWDjLCwhyDxJmVH27ekqVbCaFsydw2ChldcmFjqhgtBzcbqYFs3qwRFPI1tf0idf3N2+yMYhkblu1VMkYRTCxSI4xILr5RilIULgT/SKnIlkvesJnGZviuwoXn/VfmUnBpcwH3o0qg9yaIEfObzEix/z5IPuB/jTTfzoVY7LG38OD7TZ2QUrKqasbhRCSf+BJp4i7Rh+YWmNDRE
 qpgR/5IF
 U28NpTYrhV+ReplFOoy+oGCf25dIvVCQNIPOLo+314/PHsz5NGzt/Me5J9mLvc0mJx+wnxlM/1S024QbriyHvt4N2n0Re5Jm1P3/dTm7TFlxKjwyA/2Bgyutx4M5TUy3KicXXawPw2KIDqCXq3aaRZ26fJVxrgS8JgfpzahfAyf1CfaR7940xplY4Yn1jHu0JnLXBCp6fpzgVfVsTsFu2onqMgwL41dw9Wsjc8gb2PFh8ZSDUgs3viTq+767tMEGfqB3kpJpjU9y+HDCUNGKCkrzl+gVzk68KKiHp7HxWRsP48scaCA9Bt2GbiCChQAJ0W7aEQg/KrEK6/pagx6h/JZ0xUGw1NUGths2F7U/MQS69qPqpucH/jrjWi3MuLRp83MPbLPwP/srnt3q5O0KwcdkFtOMDsiiWJnJJheVs95BRpVBvY2yP2is/ZpOguzcAmFeATqCs9/pXXlPut5PP6ochRmfK79p1aAmkeZRcBct/DhIcylhXAJr53gXrk+wv06/33gpggaMalHxPk3kHvPfb0i6XFdwte3NV5os06HaU6vkr7JsNcZWoyy7R5kJkmhoyStQkb0jKoGlQu/pKcYwdgViAO//C6ZBR+VU+UTu8ZpFS6SAX8HM3j2UN47AFTL3ZhrK0+w9ZS0buCYwDpt+KY9u2SXphbSgbNozV9Osa4k8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is required to modify folio statistic after rmap changes, so it looks
reasonable to do it in __folio_add_rmap(), which is the current behavior
of __folio_remove_rmap() and folio_add_new_anon_rmap().

Call __folio_mod_stat() in __folio_add_rmap(), so that rmap adjustment
family shares the same pattern.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
---
 mm/rmap.c | 67 +++++++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..84a8d8b02ef7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1241,13 +1241,35 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 	return page_vma_mkclean_one(&pvmw);
 }
 
-static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
+static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
+{
+	int idx;
+
+	if (nr) {
+		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
+		__lruvec_stat_mod_folio(folio, idx, nr);
+	}
+	if (nr_pmdmapped) {
+		if (folio_test_anon(folio)) {
+			idx = NR_ANON_THPS;
+			__lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
+		} else {
+			/* NR_*_PMDMAPPED are not maintained per-memcg */
+			idx = folio_test_swapbacked(folio) ?
+				NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED;
+			__mod_node_page_state(folio_pgdat(folio), idx,
+					      nr_pmdmapped);
+		}
+	}
+}
+
+static __always_inline void __folio_add_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum rmap_level level, int *nr_pmdmapped)
+		enum rmap_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	const int orig_nr_pages = nr_pages;
-	int first = 0, nr = 0;
+	int first = 0, nr = 0, nr_pmdmapped = 0;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
@@ -1283,7 +1305,7 @@ static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
 		first = atomic_inc_and_test(&folio->_entire_mapcount);
 		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
 			if (level == RMAP_LEVEL_PMD && first)
-				*nr_pmdmapped = folio_large_nr_pages(folio);
+				nr_pmdmapped = folio_large_nr_pages(folio);
 			nr = folio_inc_return_large_mapcount(folio, vma);
 			if (nr == 1)
 				/* Was completely unmapped. */
@@ -1302,7 +1324,7 @@ static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
 				 * folios separately.
 				 */
 				if (level == RMAP_LEVEL_PMD)
-					*nr_pmdmapped = nr_pages;
+					nr_pmdmapped = nr_pages;
 				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
 				if (unlikely(nr < 0))
@@ -1315,7 +1337,7 @@ static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
 		folio_inc_large_mapcount(folio, vma);
 		break;
 	}
-	return nr;
+	__folio_mod_stat(folio, nr, nr_pmdmapped);
 }
 
 /**
@@ -1403,43 +1425,19 @@ static void __page_check_anon_rmap(const struct folio *folio,
 		       page);
 }
 
-static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
-{
-	int idx;
-
-	if (nr) {
-		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
-		__lruvec_stat_mod_folio(folio, idx, nr);
-	}
-	if (nr_pmdmapped) {
-		if (folio_test_anon(folio)) {
-			idx = NR_ANON_THPS;
-			__lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
-		} else {
-			/* NR_*_PMDMAPPED are not maintained per-memcg */
-			idx = folio_test_swapbacked(folio) ?
-				NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED;
-			__mod_node_page_state(folio_pgdat(folio), idx,
-					      nr_pmdmapped);
-		}
-	}
-}
-
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags, enum rmap_level level)
 {
-	int i, nr, nr_pmdmapped = 0;
+	int i;
 
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
-	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
+	__folio_add_rmap(folio, page, nr_pages, vma, level);
 
 	if (likely(!folio_test_ksm(folio)))
 		__page_check_anon_rmap(folio, page, vma, address);
 
-	__folio_mod_stat(folio, nr, nr_pmdmapped);
-
 	if (flags & RMAP_EXCLUSIVE) {
 		switch (level) {
 		case RMAP_LEVEL_PTE:
@@ -1613,12 +1611,9 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
 {
-	int nr, nr_pmdmapped = 0;
-
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
-	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
-	__folio_mod_stat(folio, nr, nr_pmdmapped);
+	__folio_add_rmap(folio, page, nr_pages, vma, level);
 
 	/* See comments in folio_add_anon_rmap_*() */
 	if (!folio_test_large(folio))
-- 
2.34.1


