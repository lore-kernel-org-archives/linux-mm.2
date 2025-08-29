Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E4DCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1316B0012; Fri, 29 Aug 2025 14:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA92F6B0024; Fri, 29 Aug 2025 14:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D44A6B0025; Fri, 29 Aug 2025 14:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 871226B0012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 394BD1A08B5
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:12 +0000 (UTC)
X-FDA: 83830639704.11.7BDB325
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3AB0180005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=WV9WCIC+;
	spf=pass (imf02.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EDFLxjASQVlPYlwefEaYkxxqYLA/xYc3thBaHxBLgU=;
	b=lLaSVee1LzyQs5K8SgEdYLNbhLM8fOj+8yaBKD4gdaV97zkqMBYHSfh1FVpCEocNWBZ3K+
	YJ4Yng9Zg3IxeYqoU/BaiRyzI+SkE6kFeWnVBJQ7p3/NREsXPxD720bfK8rr8f8tT53C3E
	ugdfOZ/Nr53++UMzyx/E5ev6TaHA4A8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492330; a=rsa-sha256;
	cv=none;
	b=A66OZSiKAQ8t7PVOZ13Mtj9Z2NFj6FxYEDOvOOfDu0GVHfq5uJACfaDv7xkCN9XeU4e/gj
	5F0BF0GsG3ugqPqQtcvuchAo6Fn2fAniuS9ZlB3q8OfHRSw5rdai9nK/kf5H1/87RFE/bP
	PqezMdgXo9BN7JF7IomOUZpxW56pdzc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=WV9WCIC+;
	spf=pass (imf02.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb72d51dcso358061066b.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492329; x=1757097129; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EDFLxjASQVlPYlwefEaYkxxqYLA/xYc3thBaHxBLgU=;
        b=WV9WCIC+PR3VeRIE/jy2NJxLjO18Ow6g8Otl/6o+Q1F8CxV5VsQ+oYoGVxV/shCt6K
         WgoztzXhtdrlvZaU8l/DRMHMHrdujIEuXrn0LSO20TTn97ryQ8WHIuthMPrSXn6gRmXc
         wN6tCEdl6qrA+7EQOiMpjBApON2PdC2A7HO1U2V4KmhxRmp3BfUTARIxDhkjrK4S3zLJ
         sT5PU1acJFUR65nnLxz2Yy9WHyZgE8zqHLgf5gDN60JQA93YwzYu2VkNprXAACt1hRXE
         fKl9NXZqgo0MECWrUGXIX33edO6u3a2DTSbApCOdYppcQxcBT7qc+I76Zl3QpIY9NQLU
         IdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492329; x=1757097129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EDFLxjASQVlPYlwefEaYkxxqYLA/xYc3thBaHxBLgU=;
        b=bFU8k1kxt5oEpE6bLRNkX7EtRsqMtJATrgptLkLX0L+NmQcxpz72mWJTcDTOYn97AP
         g77L7EzQ2/KCIYIvHfGaT9CarM0ImLjkiJ5doju91PHgDO1x8VwwQeTJaTfdrODRKYuh
         dzO0Z+YfvzlweSa+EAchBQJlTJ+UrheGScpdGbfkPWplRzFu/TEmgFMsaNBq4Ndlt8gh
         OAKcndKmYMp06Habq5pw27puT0AI2GZLoa+rnNaAQtwY5VZBLF9rYsH1RZqZopXFsa0Q
         vsr/5iHlF2cwVw+P8YExCshJUQRA1Gqj9rirFlpOrcuSpe9neRmKVCO/HOwwZpnKz488
         N0Fw==
X-Forwarded-Encrypted: i=1; AJvYcCXU61wamvhuu/caNAg6r/rE0c4+s5/5/PBj956Tit8Qxq97yZRlP9m2Ie8nQCIlytiU13PC9aDyvQ==@kvack.org
X-Gm-Message-State: AOJu0YweypVVULFGqT088s2uvQN21QtbT7ClrxsSYFrsfiXQzkmbbx8h
	9RqaQqlPB/2rFF4gEATgyyS95z2SqxuCD4ic4G+KCAKK7oYlTI1aQmiEY3Z6zOKVGn1dlZVXtR4
	QAKJT
X-Gm-Gg: ASbGncscHITVwy03TZ/OGYSlRf48IZ1svJtdWHBaPE19BlGD34RO9BQLngK111L4ZX7
	u2BgBNEX3qM/hudc0e3tM3tb53/LYSqM7hf9rIfpWsFTvlyy/uU+2lMY1I9edZAOxMS4ZrekCYO
	DAdJQpLlfwA5TeYCdbhqivb4EUcMOtm/lSOQbrXpBT/5QzrerjUev7VWyOA5HXtPlq5PPDNqR7T
	waUtOgiDpoEytKtX1Tq+4ZAKGXhJ+X1IkwVQSjfJXo2QB8lKYzvjExkiecIgEyv/o+5KbyCNKlX
	jEdqNWenXLCaPXlDIT5hVQxignfEVtuGXtfthp3KSUUFfxiCf0ZW1cPdfJM1zGmL9yWeFOdaFt/
	oWv6/2RolgBZwII8JR1C+btm/wGeYSuLeEpDKqgw1UF+uyw2gmR/faVJmbMPL4zsjWYfP+TCcNs
	nk6vRzQCI0Foi+kLVTMrMAV/p3mT1VCW4f
X-Google-Smtp-Source: AGHT+IFaQVLopBnCCBBDM0Romedws7uBJkIEz8t6oa7iUZXqU9TSme0dCXrhxot8zn/IF0CKbdciOQ==
X-Received: by 2002:a17:907:7eaa:b0:afe:c795:9ad5 with SMTP id a640c23a62f3a-afec795cea3mr1008772366b.2.1756492328561;
        Fri, 29 Aug 2025 11:32:08 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:08 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 02/12] include/pagemap.h: add `const` to lots of pointer parameters
Date: Fri, 29 Aug 2025 20:31:49 +0200
Message-ID: <20250829183159.2223948-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3AB0180005
X-Stat-Signature: qb3xkuig8dg8i5euohcjhbjbf4eaar9o
X-HE-Tag: 1756492330-382283
X-HE-Meta: U2FsdGVkX1++oG1Aplck363AOss00FEnHJQagk3yskV+C30zy7TYGNXABb4eaFo72Ba6KyzX9vI3hmOHqu9GI1bDoKEfkvcIpreb/kLVHyxFO1GTnH8sjUgk+wkM2PsVg4rEcUSX7ztf6l5U4UEOWv7Mx9UnaaHDd402xnfNToa7Y8AEFHiolOiC5szzHwNeaII+IxaGtZjlYCsFzr7sDQLVrd37A/pw6mdlWOh8CavtAp81UsLo6jajID+e0klvX0GDPJbk10t2/VYNe2FUaiH7l6ALhd5qYDtLZzUrAJo+mtiancrzttHvX3QIHySsgSwuDMIrAh2PcvnGr0Vpe0N7zT53vGPH8YdD1TsDdguKlpz12imMpjGTlTNHwaH9Ms8ES3zty5TAHgyYAj0p81eRlBlWzeJ0bOon7HKWvIPZrUo6aA11cOyxIE6Ex62zvvTmB5M4WaKrM86u3kTsTeJXccTm0uxJPULirvHDyy214zzWodgPqNuDmodU31hSEDmEjWppcQhOWyi7lHYTV7u96IMe2rEsJg9hIh2aDtXtD/3BCsbTIejafv5iW+AUvm3WWNlNAUEWMnMM5Q6JOVRwP744HarHwNR4qUcl8zPQisadObjzqbmdrA0RE/gU6NqFBrbk0EEWv5Bx1dRsBNlJWi1+lN18uhExEn6b1h3jLOXGq6Bo3J+CjH63XV9DfEp2G0ME30ThtL7YbmKG83UTVUlTWnlcz2U0274/xMHpGPljrBofNvekbP9EWWQb8pwl+8gF3GLYYorFCTk53c949XCj17DyFiDWs41UO8kpvLMgjBlBr6mlUF8U3qVcRl83eGLCL6SXKxu+oL5EUNx1MEV/CTz2zOt1/6DUeQDoGltUHbZ7gcmkJwOoSzGiKiJ2a+gyxcdQxeYQovhKLFQvFwIihv1I8ho3JYn9dDlxUP2goywjf3JfzWLHlqM/2t/tLEmQ+n5Uj5HJXsN
 hsZ+cCMW
 bjwIpVXGI3TIdGVjBfPORA5labhsPJ2ZpaiUfG+gY5ttUyttcNwXlYPJTMiCdJ4eKNUzXUrB1mFjdxeW7Cq8jyUN/iDQJ7D5ve2BT3eIzOVn/dVUIVR6sTEYlh1DsScKCCmRqf6PSoAN3YnFrAr+h9qSIUfN+4mqW47rhf8/zttcUU7Z90rrnBli2ozn0FhmTx2vj3qKltHdM+Kgoe1K4GdOVOniXRAy0ibHJoE2rpTFSkVba2HVA8atcl+ojo3q7+WKq/plcdXOZVWjZXgJ3jBmpIuq8HWLULTFbBvxIMJRA2bLCYiw33mbCwvjuyVoM9VGpty9YFvNVsuh1uNBnMogAQwg/Q1Q18qiwFZieJsVONBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/pagemap.h | 52 ++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c9ba69e02e3e..87411e7f2dba 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -140,7 +140,7 @@ static inline int inode_drain_writes(struct inode *inode)
 	return filemap_write_and_wait(inode->i_mapping);
 }
 
-static inline bool mapping_empty(struct address_space *mapping)
+static inline bool mapping_empty(const struct address_space *mapping)
 {
 	return xa_empty(&mapping->i_pages);
 }
@@ -166,7 +166,7 @@ static inline bool mapping_empty(struct address_space *mapping)
  * refcount and the referenced bit, which will be elevated or set in
  * the process of adding new cache pages to an inode.
  */
-static inline bool mapping_shrinkable(struct address_space *mapping)
+static inline bool mapping_shrinkable(const struct address_space *mapping)
 {
 	void *head;
 
@@ -265,7 +265,7 @@ static inline void mapping_clear_unevictable(struct address_space *mapping)
 	clear_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
-static inline bool mapping_unevictable(struct address_space *mapping)
+static inline bool mapping_unevictable(const struct address_space *mapping)
 {
 	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
 }
@@ -275,7 +275,7 @@ static inline void mapping_set_exiting(struct address_space *mapping)
 	set_bit(AS_EXITING, &mapping->flags);
 }
 
-static inline int mapping_exiting(struct address_space *mapping)
+static inline int mapping_exiting(const struct address_space *mapping)
 {
 	return test_bit(AS_EXITING, &mapping->flags);
 }
@@ -285,7 +285,7 @@ static inline void mapping_set_no_writeback_tags(struct address_space *mapping)
 	set_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
 
-static inline int mapping_use_writeback_tags(struct address_space *mapping)
+static inline int mapping_use_writeback_tags(const struct address_space *mapping)
 {
 	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
@@ -331,7 +331,7 @@ static inline void mapping_set_inaccessible(struct address_space *mapping)
 	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
-static inline bool mapping_inaccessible(struct address_space *mapping)
+static inline bool mapping_inaccessible(const struct address_space *mapping)
 {
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
@@ -341,18 +341,18 @@ static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_
 	set_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
-static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_space *mapping)
+static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct address_space *mapping)
 {
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
-static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
+static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
 }
 
 /* Restricts the given gfp_mask to what the mapping allows. */
-static inline gfp_t mapping_gfp_constraint(struct address_space *mapping,
+static inline gfp_t mapping_gfp_constraint(const struct address_space *mapping,
 		gfp_t gfp_mask)
 {
 	return mapping_gfp_mask(mapping) & gfp_mask;
@@ -475,7 +475,7 @@ mapping_min_folio_order(const struct address_space *mapping)
 }
 
 static inline unsigned long
-mapping_min_folio_nrpages(struct address_space *mapping)
+mapping_min_folio_nrpages(const struct address_space *mapping)
 {
 	return 1UL << mapping_min_folio_order(mapping);
 }
@@ -495,7 +495,7 @@ mapping_min_folio_nrbytes(struct address_space *mapping)
  * new folio to the page cache and need to know what index to give it,
  * call this function.
  */
-static inline pgoff_t mapping_align_index(struct address_space *mapping,
+static inline pgoff_t mapping_align_index(const struct address_space *mapping,
 					  pgoff_t index)
 {
 	return round_down(index, mapping_min_folio_nrpages(mapping));
@@ -505,7 +505,7 @@ static inline pgoff_t mapping_align_index(struct address_space *mapping,
  * Large folio support currently depends on THP.  These dependencies are
  * being worked on but are not yet fixed.
  */
-static inline bool mapping_large_folio_support(struct address_space *mapping)
+static inline bool mapping_large_folio_support(const struct address_space *mapping)
 {
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
 	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
@@ -520,7 +520,7 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(struct address_space *mapping)
+static inline int filemap_nr_thps(const struct address_space *mapping)
 {
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
 	return atomic_read(&mapping->nr_thps);
@@ -934,7 +934,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
  *
  * Return: The index of the folio which follows this folio in the file.
  */
-static inline pgoff_t folio_next_index(struct folio *folio)
+static inline pgoff_t folio_next_index(const struct folio *folio)
 {
 	return folio->index + folio_nr_pages(folio);
 }
@@ -963,7 +963,7 @@ static inline struct page *folio_file_page(struct folio *folio, pgoff_t index)
  * e.g., shmem did not move this folio to the swap cache.
  * Return: true or false.
  */
-static inline bool folio_contains(struct folio *folio, pgoff_t index)
+static inline bool folio_contains(const struct folio *folio, pgoff_t index)
 {
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	return index - folio->index < folio_nr_pages(folio);
@@ -1040,12 +1040,12 @@ static inline loff_t page_offset(struct page *page)
 /*
  * Get the offset in PAGE_SIZE (even for hugetlb folios).
  */
-static inline pgoff_t folio_pgoff(struct folio *folio)
+static inline pgoff_t folio_pgoff(const struct folio *folio)
 {
 	return folio->index;
 }
 
-static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
+static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 					unsigned long address)
 {
 	pgoff_t pgoff;
@@ -1466,7 +1466,7 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
  * readahead_pos - The byte offset into the file of this readahead request.
  * @rac: The readahead request.
  */
-static inline loff_t readahead_pos(struct readahead_control *rac)
+static inline loff_t readahead_pos(const struct readahead_control *rac)
 {
 	return (loff_t)rac->_index * PAGE_SIZE;
 }
@@ -1475,7 +1475,7 @@ static inline loff_t readahead_pos(struct readahead_control *rac)
  * readahead_length - The number of bytes in this readahead request.
  * @rac: The readahead request.
  */
-static inline size_t readahead_length(struct readahead_control *rac)
+static inline size_t readahead_length(const struct readahead_control *rac)
 {
 	return rac->_nr_pages * PAGE_SIZE;
 }
@@ -1484,7 +1484,7 @@ static inline size_t readahead_length(struct readahead_control *rac)
  * readahead_index - The index of the first page in this readahead request.
  * @rac: The readahead request.
  */
-static inline pgoff_t readahead_index(struct readahead_control *rac)
+static inline pgoff_t readahead_index(const struct readahead_control *rac)
 {
 	return rac->_index;
 }
@@ -1493,7 +1493,7 @@ static inline pgoff_t readahead_index(struct readahead_control *rac)
  * readahead_count - The number of pages in this readahead request.
  * @rac: The readahead request.
  */
-static inline unsigned int readahead_count(struct readahead_control *rac)
+static inline unsigned int readahead_count(const struct readahead_control *rac)
 {
 	return rac->_nr_pages;
 }
@@ -1502,12 +1502,12 @@ static inline unsigned int readahead_count(struct readahead_control *rac)
  * readahead_batch_length - The number of bytes in the current batch.
  * @rac: The readahead request.
  */
-static inline size_t readahead_batch_length(struct readahead_control *rac)
+static inline size_t readahead_batch_length(const struct readahead_control *rac)
 {
 	return rac->_batch_count * PAGE_SIZE;
 }
 
-static inline unsigned long dir_pages(struct inode *inode)
+static inline unsigned long dir_pages(const struct inode *inode)
 {
 	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
 			       PAGE_SHIFT;
@@ -1521,8 +1521,8 @@ static inline unsigned long dir_pages(struct inode *inode)
  * Return: the number of bytes in the folio up to EOF,
  * or -EFAULT if the folio was truncated.
  */
-static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
-					      struct inode *inode)
+static inline ssize_t folio_mkwrite_check_truncate(const struct folio *folio,
+					      const struct inode *inode)
 {
 	loff_t size = i_size_read(inode);
 	pgoff_t index = size >> PAGE_SHIFT;
@@ -1553,7 +1553,7 @@ static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
  * Return: The number of filesystem blocks covered by this folio.
  */
 static inline
-unsigned int i_blocks_per_folio(struct inode *inode, struct folio *folio)
+unsigned int i_blocks_per_folio(const struct inode *inode, const struct folio *folio)
 {
 	return folio_size(folio) >> inode->i_blkbits;
 }
-- 
2.47.2


