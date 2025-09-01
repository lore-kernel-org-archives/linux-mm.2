Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00D2CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E36C8E0032; Mon,  1 Sep 2025 08:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A268E0013; Mon,  1 Sep 2025 08:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3209F8E0032; Mon,  1 Sep 2025 08:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDB68E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 986BC14083E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:40 +0000 (UTC)
X-FDA: 83840615040.12.CF00FC7
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9EDF100006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=La0vwgov;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsZOhkPaRGuLceh4X0WyYGraOTpsD0tyj5yjo8FiiY0=;
	b=oPtMcVNU/cOiJbUcwjpS4qvKoWhyg4G69w6nTXjGvZ8jy09ukuplvKc/7EgbiBy+jGMoc1
	XmYS2tSULEAePEgX85ZwGbjrs/cjCb8OP/cszB0K8x2L7pqOkgJ3z880f6tNV1zsyyLqvN
	k68ZuXS3A53r/2lXgcHwzqfG4eQRD1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729838; a=rsa-sha256;
	cv=none;
	b=QJ2AQLzGFw7g4rO2ZbRAnhlcEsCFa39E92MHU84DfXpsgqaOnop8+3JgQ6Dx2CaBblbFSG
	RSptfFuMimh/45i+MbmEUUBt3v3/lP5HLsgRCExBOGNoiKz6pTeper7AR0VtYzRt1KCXou
	mCMIUxpMqkTX+zRi+e3XRk2eexdB2aA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=La0vwgov;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61cd6089262so6667345a12.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729837; x=1757334637; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zsZOhkPaRGuLceh4X0WyYGraOTpsD0tyj5yjo8FiiY0=;
        b=La0vwgovMCnZfLp+xu3fBI9WTw12wwFTLGrLjLH7GVZ9hMULXU8fuLOrpoh/Wk9SwE
         h6mfbP8DuqaVqcA4oxXUhAfmvwlwO4FF89hRKiJrWZIgKsPqdlnFSn/4R+JtKgkYm2+w
         fBFCD8ccB7VU7hVU3+ELEHRstpeTHxY5M4qejHdzOA1Kjlf2LaUzT8dhE8rC0DyR2KZd
         ogm9+KgoZofR/J8HNftsMBX974749rzCXGBXWYBhbKfKo8q7qDkPrZFmSnI6B5QmrSRX
         zEItinHdzTt3uFYnVhIntArU7UZMCtRrsEYxIrMlt2ZSmKkzL8oKujoHJAsyb6JG7cOO
         mOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729837; x=1757334637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zsZOhkPaRGuLceh4X0WyYGraOTpsD0tyj5yjo8FiiY0=;
        b=i4TJ+u7GDqw3hb8I0AhbSLihi7ZBJ0a2B/k7CYCVi6KOu0lkrr5AOBtt1ldoP/sfBv
         hNSX/3s4Q8/tlqBZXMXGiUws+I86RmQaZnV2ttqwkgyI0WLNc3E4V7wNng+q73gSlFDR
         WUc3r7qKPSd0qLkd6cPWnAPJJOXtNuqM/SOWVrXTncui6yQ5BU5yg3r/YG/F4aAj6d6A
         F/6ZplAdUT3yDyraxaXjvkb8jmxseRJosd/6hvnGH/t/KECfSgOe3D1a/yE6VdpDFGf9
         6FyJjGupoICE6RDYVmpEpbpw4RGQgVaQtFDADfPK6HlIuDKv4KpnV8FScM5Eqr1ZzStK
         sEAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqYq8fM1WuwtbD+1WTcsvbRTGoPyHhx3PhcQGg6o2SQurBm2iGHrbJlrtdKWmDmw0sqrh60F7KJg==@kvack.org
X-Gm-Message-State: AOJu0YwaK4Kf/sIA8tWlaSat/SBLWNmK6xCawTfE7B8944+TIlCeaNQn
	c1c9jlavwDavUMsi9LHC38xM6RdEYEEztJdkga2XKYZWBYXPpYINsYy8N0DCRtWFwHw=
X-Gm-Gg: ASbGncsqcaNdBbTKraAxfF/J037SB4uhi21LufVIQkYKjyL2T7H5sfiqk1kEjBGgKtX
	160dHPjBJ93JjSNF9FLkN1OEEHW5oC1hpKUV/9247Bg1NEFY42O1HkPubcjdoKeChfW6KR2lu2A
	iDH1n1UgnBQrUI7CVl4gSZJiiWiExLSNuqu6lkrrHkYf/h7Z/Ec8lnfWLysO0rSxnD8Xd4v3DRf
	c/jVk8xxc0q+R+kWmoP8Gw6GQXqtCiho6NITHOrt5rFZzEe3DO0h/Vcki44xRbVc/eHbD7OSqCg
	zldXilIsrPSrhXdvOZ6f/e3hyF61bTjbb30mc1sHn0yEvuvzP5ZJvLVjW2FO3BKLDofQecI7I89
	L9yqR8B1Bv2DJMeNXpvkzEgWgInr1EGHcg2EjmlSwJi2g0MhqaT61O+Ms8AvuY7w5NO3Jnp8lMN
	KnKlLwW1XjPVNoFgs5fiYLyUOyYaW1CVRU2JCWavcQUbo=
X-Google-Smtp-Source: AGHT+IFstp7E/MWWwOR+qTBJQyGJxGcYxozoNshVEznm012PDsrkf/9rgyBeaLmaNYqMwjSZul3Srg==
X-Received: by 2002:a05:6402:5108:b0:61a:843c:2dec with SMTP id 4fb4d7f45d1cf-61d26d79037mr6760187a12.30.1756729836992;
        Mon, 01 Sep 2025 05:30:36 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:36 -0700 (PDT)
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
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 02/12] mm: constify pagemap related test functions for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:18 +0200
Message-ID: <20250901123028.3383461-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B9EDF100006
X-Stat-Signature: e1sg557eznonydyezyxwea4j9y7qdoi4
X-Rspam-User: 
X-HE-Tag: 1756729838-442461
X-HE-Meta: U2FsdGVkX18hz7gTQaAzMCjJG0WEMZ8fHnQHNMPpfmfMEmxelT06d3Dniu9R+7n64HhPyfgJFl5UBVNKaeHyxSwrj0/uu1IfEHkpTufxdx+3I0RCfxRDsDc8qnOl/AqUhpItieAtBu7abzLr+KHir+RCnKjZ/3MUOtxYWPs1LvS/F+v2/qw2HDmFGVY5YWfaeBikWf/EyFRg/SQ8knud0jiU5Yj/CndqfP0+LSjcecd9oP/MHLoHWktzBnHiuMzFvEevTYM9fQA8N9HnlTWD+soeKqvj/WnrTH3rg4gl6yUjW2+iDY6tGdh8RWxdtZOgrWhQDf9RSbEw7I6gk8ZareUdOU3K93uZhZfqYMk24C/H2AfQPi2VtX+2aI/bBHKPyDqimVE6wyl4uYTy8O8zQ5G8BPkxPYNDd/IHrhvHREOjx5EIre5KXHd5Pt/tIxOd9Tvr49iC5FmME85cH+l93eBaUu76FKO6Ur3mFyuxB0T0exehBweUYLcsmJJehqdZeYxPkapXUiPjanvZRsjYB8KuMuZhKa+eMuIUithynde6U4dE+JoF/YvI8hOJlbtTGuLpn+GDiY4i/13J1U/XlV/91o06V2vf4gZ5mQ2kfm3oW/9ax5ubYOPUVRsu2y/KfF4e2eV8JQji6s6sexSEMfqvQCMBjerwFjoBAOXI/hNFXiDjv1RkyLW6cVlcRWwF1lbYGDpHUXdnZc1KrW41oqhroYi7qHuOh/u5VtgaSAeVUwIzO20lc/FNsy7+sJ/a7g34XnHodkwxyIiqcvkimtNZzOcmyCLOqSrqCbPrEUJohZzYXVjPX81XHsm+AClIPjcWQkMRRcveirwdFM6D72VAXDB3s9/9g7xPszCqRfZBQxkJfp9rR9C4sUtYgZvF93xa2SV2b+9xsjgIG2R6tGARqyIjplj3205pjk4RfoGwGtyzi3FvqcOeInb+l7kF+Ewht3OYr9xvwACrMcw
 xo1fKgT3
 F0/9yX+BKR55F/3L9839tfGkk58JFX5+bG/43MpXKPEBxe5UJMXkSUsedQkR555Bw2kJo2LDIBOEYQtLXScDuO5F7+k/E7O8hmBS40p7lUEK9psVC0L95Tg+gIiHDgJGy+bls1w1HWnyoRnvaOh3PFNisOduvy/mZamcwUG2ZFu8L71KuiFwly0n9gl+v/ATrqFL1k1oKogAVz9mxob8PhNBM4LP0hoNk+7mL/QEvpOZhh2+tLl8ekkMXWS9BEYnXm4IMZ02/3b+0mNQTc+91zz2jJWmXNS7rJX9puON+3rXtc48OwC+iarq9Z/V8IPvIEyNVE8GXuCQU/NDpp4cLTIETipP9u7olZBqkAI0OoSGMbfW+3vM0RUEdodDyO7nUOExM2M/JSaMolwVUYnSsJm4AHFLa0588HAW9vJj7UOWjQSbQhMfWEYxELkv44+F2jgAZLkB+/uS5zJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/pagemap.h | 57 +++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a3e16d74792f..1d35f9e1416e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -140,7 +140,7 @@ static inline int inode_drain_writes(struct inode *inode)
 	return filemap_write_and_wait(inode->i_mapping);
 }
 
-static inline bool mapping_empty(struct address_space *mapping)
+static inline bool mapping_empty(const struct address_space *const mapping)
 {
 	return xa_empty(&mapping->i_pages);
 }
@@ -166,7 +166,7 @@ static inline bool mapping_empty(struct address_space *mapping)
  * refcount and the referenced bit, which will be elevated or set in
  * the process of adding new cache pages to an inode.
  */
-static inline bool mapping_shrinkable(struct address_space *mapping)
+static inline bool mapping_shrinkable(const struct address_space *const mapping)
 {
 	void *head;
 
@@ -267,7 +267,7 @@ static inline void mapping_clear_unevictable(struct address_space *mapping)
 	clear_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
-static inline bool mapping_unevictable(struct address_space *mapping)
+static inline bool mapping_unevictable(const struct address_space *const mapping)
 {
 	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
 }
@@ -277,7 +277,7 @@ static inline void mapping_set_exiting(struct address_space *mapping)
 	set_bit(AS_EXITING, &mapping->flags);
 }
 
-static inline int mapping_exiting(struct address_space *mapping)
+static inline int mapping_exiting(const struct address_space *const mapping)
 {
 	return test_bit(AS_EXITING, &mapping->flags);
 }
@@ -287,7 +287,7 @@ static inline void mapping_set_no_writeback_tags(struct address_space *mapping)
 	set_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
 
-static inline int mapping_use_writeback_tags(struct address_space *mapping)
+static inline int mapping_use_writeback_tags(const struct address_space *const mapping)
 {
 	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
@@ -333,7 +333,7 @@ static inline void mapping_set_inaccessible(struct address_space *mapping)
 	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
-static inline bool mapping_inaccessible(struct address_space *mapping)
+static inline bool mapping_inaccessible(const struct address_space *const mapping)
 {
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
@@ -343,18 +343,18 @@ static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_
 	set_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
-static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_space *mapping)
+static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct address_space *const mapping)
 {
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
-static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
+static inline gfp_t mapping_gfp_mask(const struct address_space *const mapping)
 {
 	return mapping->gfp_mask;
 }
 
 /* Restricts the given gfp_mask to what the mapping allows. */
-static inline gfp_t mapping_gfp_constraint(struct address_space *mapping,
+static inline gfp_t mapping_gfp_constraint(const struct address_space *mapping,
 		gfp_t gfp_mask)
 {
 	return mapping_gfp_mask(mapping) & gfp_mask;
@@ -477,13 +477,13 @@ mapping_min_folio_order(const struct address_space *mapping)
 }
 
 static inline unsigned long
-mapping_min_folio_nrpages(struct address_space *mapping)
+mapping_min_folio_nrpages(const struct address_space *const mapping)
 {
 	return 1UL << mapping_min_folio_order(mapping);
 }
 
 static inline unsigned long
-mapping_min_folio_nrbytes(struct address_space *mapping)
+mapping_min_folio_nrbytes(const struct address_space *const mapping)
 {
 	return mapping_min_folio_nrpages(mapping) << PAGE_SHIFT;
 }
@@ -497,7 +497,7 @@ mapping_min_folio_nrbytes(struct address_space *mapping)
  * new folio to the page cache and need to know what index to give it,
  * call this function.
  */
-static inline pgoff_t mapping_align_index(struct address_space *mapping,
+static inline pgoff_t mapping_align_index(const struct address_space *const mapping,
 					  pgoff_t index)
 {
 	return round_down(index, mapping_min_folio_nrpages(mapping));
@@ -507,7 +507,7 @@ static inline pgoff_t mapping_align_index(struct address_space *mapping,
  * Large folio support currently depends on THP.  These dependencies are
  * being worked on but are not yet fixed.
  */
-static inline bool mapping_large_folio_support(struct address_space *mapping)
+static inline bool mapping_large_folio_support(const struct address_space *mapping)
 {
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
 	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
@@ -522,7 +522,7 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(struct address_space *mapping)
+static inline int filemap_nr_thps(const struct address_space *const mapping)
 {
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
 	return atomic_read(&mapping->nr_thps);
@@ -936,7 +936,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
  *
  * Return: The index of the folio which follows this folio in the file.
  */
-static inline pgoff_t folio_next_index(struct folio *folio)
+static inline pgoff_t folio_next_index(const struct folio *const folio)
 {
 	return folio->index + folio_nr_pages(folio);
 }
@@ -965,7 +965,7 @@ static inline struct page *folio_file_page(struct folio *folio, pgoff_t index)
  * e.g., shmem did not move this folio to the swap cache.
  * Return: true or false.
  */
-static inline bool folio_contains(struct folio *folio, pgoff_t index)
+static inline bool folio_contains(const struct folio *const folio, pgoff_t index)
 {
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	return index - folio->index < folio_nr_pages(folio);
@@ -1042,13 +1042,13 @@ static inline loff_t page_offset(struct page *page)
 /*
  * Get the offset in PAGE_SIZE (even for hugetlb folios).
  */
-static inline pgoff_t folio_pgoff(struct folio *folio)
+static inline pgoff_t folio_pgoff(const struct folio *const folio)
 {
 	return folio->index;
 }
 
-static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
-					unsigned long address)
+static inline pgoff_t linear_page_index(const struct vm_area_struct *const vma,
+					const unsigned long address)
 {
 	pgoff_t pgoff;
 	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
@@ -1468,7 +1468,7 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
  * readahead_pos - The byte offset into the file of this readahead request.
  * @rac: The readahead request.
  */
-static inline loff_t readahead_pos(struct readahead_control *rac)
+static inline loff_t readahead_pos(const struct readahead_control *const rac)
 {
 	return (loff_t)rac->_index * PAGE_SIZE;
 }
@@ -1477,7 +1477,7 @@ static inline loff_t readahead_pos(struct readahead_control *rac)
  * readahead_length - The number of bytes in this readahead request.
  * @rac: The readahead request.
  */
-static inline size_t readahead_length(struct readahead_control *rac)
+static inline size_t readahead_length(const struct readahead_control *const rac)
 {
 	return rac->_nr_pages * PAGE_SIZE;
 }
@@ -1486,7 +1486,7 @@ static inline size_t readahead_length(struct readahead_control *rac)
  * readahead_index - The index of the first page in this readahead request.
  * @rac: The readahead request.
  */
-static inline pgoff_t readahead_index(struct readahead_control *rac)
+static inline pgoff_t readahead_index(const struct readahead_control *const rac)
 {
 	return rac->_index;
 }
@@ -1495,7 +1495,7 @@ static inline pgoff_t readahead_index(struct readahead_control *rac)
  * readahead_count - The number of pages in this readahead request.
  * @rac: The readahead request.
  */
-static inline unsigned int readahead_count(struct readahead_control *rac)
+static inline unsigned int readahead_count(const struct readahead_control *const rac)
 {
 	return rac->_nr_pages;
 }
@@ -1504,12 +1504,12 @@ static inline unsigned int readahead_count(struct readahead_control *rac)
  * readahead_batch_length - The number of bytes in the current batch.
  * @rac: The readahead request.
  */
-static inline size_t readahead_batch_length(struct readahead_control *rac)
+static inline size_t readahead_batch_length(const struct readahead_control *const rac)
 {
 	return rac->_batch_count * PAGE_SIZE;
 }
 
-static inline unsigned long dir_pages(struct inode *inode)
+static inline unsigned long dir_pages(const struct inode *const inode)
 {
 	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
 			       PAGE_SHIFT;
@@ -1523,8 +1523,8 @@ static inline unsigned long dir_pages(struct inode *inode)
  * Return: the number of bytes in the folio up to EOF,
  * or -EFAULT if the folio was truncated.
  */
-static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
-					      struct inode *inode)
+static inline ssize_t folio_mkwrite_check_truncate(const struct folio *const folio,
+						   const struct inode *const inode)
 {
 	loff_t size = i_size_read(inode);
 	pgoff_t index = size >> PAGE_SHIFT;
@@ -1555,7 +1555,8 @@ static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
  * Return: The number of filesystem blocks covered by this folio.
  */
 static inline
-unsigned int i_blocks_per_folio(struct inode *inode, struct folio *folio)
+unsigned int i_blocks_per_folio(const struct inode *const inode,
+				const struct folio *const folio)
 {
 	return folio_size(folio) >> inode->i_blkbits;
 }
-- 
2.47.2


