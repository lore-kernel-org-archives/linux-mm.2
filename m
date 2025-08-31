Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E86CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC22B8E0007; Sun, 31 Aug 2025 05:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C270D8E0001; Sun, 31 Aug 2025 05:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA04D8E0007; Sun, 31 Aug 2025 05:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0C38E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49A961DDC12
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:41 +0000 (UTC)
X-FDA: 83836555362.10.B2A516A
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 39F101C0003
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RRlsiAW5;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fS4wJfZ2pDhZvPbiW+R+SY5FbZtgMq1SfXnP2mUytfo=;
	b=Myd3s+ZB4yLJyDO8CNN8DVR/QsbetZhcmY/UrSxr7nJ7XX23jc4wRWiU8OO8PhKXu7cVJT
	L0OsUBTgllzikibrQucbUKs9mz5Hq81AiwCNob6BRe+ul6umaO8hdCSwcDgnUIMNnxcKJw
	ODZDRKxbAGp8YVKNC7v3KB4Q0hDWtyk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RRlsiAW5;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633179; a=rsa-sha256;
	cv=none;
	b=IpkBBKKzPrxokbrQxSVvU/21zykMYNNCO5A/PyxlrJx8n852tilGUg/sxTlMEkYm1SY2rN
	S2Cmtj+ERAafjJO9p4ZWFcQjIFj7VK5jpKUE2CaK9cUGDfDJVtlrHvzOUgDjMzmRklKFJk
	2+n8A/mpzYE1MgBlK6tmR2EMmprnkeI=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b0418f6fc27so50054266b.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633178; x=1757237978; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fS4wJfZ2pDhZvPbiW+R+SY5FbZtgMq1SfXnP2mUytfo=;
        b=RRlsiAW5rcx6aIT4jXUCkLCHubahQrzED28lMkb52HjF2rlTOHlKCeK4AbNdNhQE7y
         rwM/9c9AGAlyQOF0g0y8vrdGGe7Z7IgFa/9yGVAqx1Crf2+jycU0AfJ2kjfms+3OrrZL
         jNCwT1DosCgE/IWoERaiRtljhmfPYhfFgjoKNpkL1wVZOYPDFxYRiQoU/2BHaBuWD2HR
         +H0H1mlqGNIyvV5t/EkH/z1pApyXdDTnKJ5o6vQpux2YM+AGLs7JQIgRtaNHw3fIgwgh
         GlR+NSd7L5PL/wwQk5MMiXLwzrK8Ad1UwGJcorBnC07LkrIuMNdSWSjGlZ1IWaT+HOiD
         WE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633178; x=1757237978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fS4wJfZ2pDhZvPbiW+R+SY5FbZtgMq1SfXnP2mUytfo=;
        b=bD4GGhAo8vE/cIliQX0rFHNxrmIL4J32pXMSBFIT7YeaMH+DUUEhwqtT2au+AODRGH
         kAxaACOMfFBJ1BKE3qNv6lZNRCSlyqrerTQpF7LOEBfcmfsT+1yYn66BvrDnXcajfHbA
         FJQdU3wvbs0b9FTEOyDYfVqZX4HHXwPslRRMPOpRu4ACGZ+si46jSnPqBOJrc4+yxxUv
         GjYSqHRvJEhtfavu9M0XpQ4yomkBRD8LKD8cyO1Swvd7LDQXkmeZp6EcOJfYIcqGi2Xh
         uecauf90r/I8mF9f7zTy+48WtQ5gcEKu+LRCS2UpTYJDtXhH8pM1zaxUiMhS8sshTzHy
         K8eA==
X-Forwarded-Encrypted: i=1; AJvYcCUJyyj/4zhL3+OsBJmzgFLXGDAiykSeofpJ07FnGTyS4wh9RXQhC+m+5tNye/3BS5R81HZ0cjI5qw==@kvack.org
X-Gm-Message-State: AOJu0YyWzk+bm+YSOVy973MfHT4SizFsEPuDFM46F0X4Yb0jY+3bHHaC
	T/fvkLx8Ym1Qp9gjD3BdTvlqV6aeFc4qk4evspHnSxREeoggFYTvnkCyYGshdZ4PFqk=
X-Gm-Gg: ASbGncubg3pnnB21+HVt/aCK42CAukby7TJZLVnwvk+DD0uKgYsDXrIFws/QKYcj5ZC
	dOQcsjAkwKdFHChAkY9G1HzgbaACoD4mjixzvD8I7sewPl68L8rvuu1RNxx6wB0NzT0Iaj8ld9V
	/M9zbUmXyzI+RqvYqo8ABz2vsKyk2Jr0B5tLDMT9N7SDmhhTHTWZUm8dwX1GcqQMjPG/kLeCj6Y
	vURcq2KKXcNPhcDqyo18n/s7TC9rmu8oqOLWAzI7rbKMIUuPORcpvK6BY+Nn0BtJeHmNVSHw/MK
	mSyYuc05YAPUdQD8L5rewX9XKWDwFrxCGLGgVfaa7Va9TNSRHqW3VNQzgQ2RzPAR3jySOP7z02z
	xtMMNE7bT+rEi/feo6DCrd6aCMCVARK1rVBKJeSDdspfoFoczdVCSIWl7Kylxm9hvH8bNOQG/gN
	SB/hOvdse6HBSfYfEUZe+Jmw==
X-Google-Smtp-Source: AGHT+IFl6wqzfG0vHDTUkL/FnbDFFEhWrqTy9LAAxJMUtnBrhQMoPbd3VxGPn58hYgmzlZMy0V4cTg==
X-Received: by 2002:a17:907:3f9e:b0:b04:299d:53ab with SMTP id a640c23a62f3a-b04299d590cmr3529566b.37.1756633177663;
        Sun, 31 Aug 2025 02:39:37 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:37 -0700 (PDT)
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
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 02/12] include/pagemap.h: add `const` to lots of pointer parameters
Date: Sun, 31 Aug 2025 11:39:08 +0200
Message-ID: <20250831093918.2815332-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 39F101C0003
X-Rspam-User: 
X-Stat-Signature: jt11bbb6yzzsc46cs4epkesxcmn758n7
X-Rspamd-Server: rspam09
X-HE-Tag: 1756633178-139013
X-HE-Meta: U2FsdGVkX19yV50i48//XW91BRxFh2eMzD0SaJVwKt64cRj/6KtyLDhEjnQ8J8l9uuyWmo4sZMtLNwbLbx/8gFXjT3LajglKbz8kadXLcNZBN7N7y0/b1kQblzo/PeztwU6yRA9cvOAAFZSSB8K/OxynCkwOzcrlyx+YRXIpboA/vjlzndNWmN7zierh85xGnLA4Cq1IMrFN4B8cXmwqssPOOc2hzfBogrebD++HoAhGn9bJOKo/ldERsn0iPHhRn4N9uk0/vyncNQWQL2fcfaOHPLoPsp6PtzUvw9lsX2r0JV6bjKVqOOYpBX9RubJLlBPeIRMWHy9Pe3dZarJZeVRae4lc/3OxkEY3GRsz6SmOI9h0E4YJDGAT/kOuAHTxyRhXlDbKbBX6qeVczBpzeVv1AGSPpduS5G8ZrH/azTGwM88Qa8DWiO6cSYjrPzuDkl6WjM+t1UbjJDs7GpZLFtt9FObGOSbL9emeI6I12PjgZdVPGCSdGkPzDayNYNR75RxDceKglY0itBif/P9nCswajzPgUcdjslSxJ+JJeuDsui/9CS0F/JkZ73cHMICdNo9BrmLRz0z5I/hHeG5N+ZaByuGNuoPV902C0xgLEzPfb4P9VBKLMLb4rFKzkg3ssgNFcGEmhs1JYjdEvRWMc29NKRiaY2tlqB7h60B+aev5DnIIRM9iWdK8UeSN03q9FVSCzck0+UvhkgyN1udqdEJsm174KzkUzwUZka3AimSEhkJhemHXjPsBUoxvX5FnbsUSpPy5IIHD7ilKwSZnp53lDCgX9ggGDuduNwC9lMEXJf+wN5hvkxewrI/ClQIOUIhst4PI7a/A+DK/G91ZOHk9JOicM32K1FgQv0p2NGBpOlpFyUWqoqvziRnc8F9gOyPN4CnME1OqcbS7Yv2a+BDpWqSdzRoCqSw/eSPtE4O3O3SxN7HzU+ZYL48JdfkkHMcMDAmjZHoeeOvZ+9w
 2txotw7c
 EXLSXj0v6xNKblwAeBSUQBjz8hWobYvxHepYzEy1bagaA2RtaEp7HP0GXVU1lxVksZRW288YyoBqcjlmvOvPIHIP8EUg7Jj6HTq5QiwNKzozqx1qo1XBD4a2aApXAAW1Nznwf1ulPsO9RT1KAJQqbooztpK6coSmJmR1mDImExRrM0YwsWjR9FMK8HfhqevvIsCwZ2EDtJJtz+vefpJB+yRpHExAmDUqzJbRKkL7QkzNh2cBKBKK8tx9v6WLcJm6Aafxsr/iMx6Ym8uvcG5u2KFThLBNh0b2A833Z85ty6oBA57XUnuq2GBDvn4Jwcyf8T+QGmaRbBkS90gMRsnognZRbeCEe9zqYTvvOQ2Dr0DzSgCS9dKMJT9z9G7k/51tu7x8xPl5b5wB+DAG7jM3Dz3bheFeGGT63+X7UWzUJwgH6PQryeyq3YvyJ2sW6jHuJlNFd+l/r7Vl+vOw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/pagemap.h | 57 +++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c9ba69e02e3e..d1244e7dcf0e 100644
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
 
@@ -265,7 +265,7 @@ static inline void mapping_clear_unevictable(struct address_space *mapping)
 	clear_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
-static inline bool mapping_unevictable(struct address_space *mapping)
+static inline bool mapping_unevictable(const struct address_space *const mapping)
 {
 	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
 }
@@ -275,7 +275,7 @@ static inline void mapping_set_exiting(struct address_space *mapping)
 	set_bit(AS_EXITING, &mapping->flags);
 }
 
-static inline int mapping_exiting(struct address_space *mapping)
+static inline int mapping_exiting(const struct address_space *const mapping)
 {
 	return test_bit(AS_EXITING, &mapping->flags);
 }
@@ -285,7 +285,7 @@ static inline void mapping_set_no_writeback_tags(struct address_space *mapping)
 	set_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
 
-static inline int mapping_use_writeback_tags(struct address_space *mapping)
+static inline int mapping_use_writeback_tags(const struct address_space *const mapping)
 {
 	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
@@ -331,7 +331,7 @@ static inline void mapping_set_inaccessible(struct address_space *mapping)
 	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
-static inline bool mapping_inaccessible(struct address_space *mapping)
+static inline bool mapping_inaccessible(const struct address_space *const mapping)
 {
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
@@ -341,18 +341,18 @@ static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_
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
@@ -475,13 +475,13 @@ mapping_min_folio_order(const struct address_space *mapping)
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
@@ -495,7 +495,7 @@ mapping_min_folio_nrbytes(struct address_space *mapping)
  * new folio to the page cache and need to know what index to give it,
  * call this function.
  */
-static inline pgoff_t mapping_align_index(struct address_space *mapping,
+static inline pgoff_t mapping_align_index(const struct address_space *const mapping,
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
+static inline int filemap_nr_thps(const struct address_space *const mapping)
 {
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
 	return atomic_read(&mapping->nr_thps);
@@ -934,7 +934,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
  *
  * Return: The index of the folio which follows this folio in the file.
  */
-static inline pgoff_t folio_next_index(struct folio *folio)
+static inline pgoff_t folio_next_index(const struct folio *const folio)
 {
 	return folio->index + folio_nr_pages(folio);
 }
@@ -963,7 +963,7 @@ static inline struct page *folio_file_page(struct folio *folio, pgoff_t index)
  * e.g., shmem did not move this folio to the swap cache.
  * Return: true or false.
  */
-static inline bool folio_contains(struct folio *folio, pgoff_t index)
+static inline bool folio_contains(const struct folio *const folio, pgoff_t index)
 {
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	return index - folio->index < folio_nr_pages(folio);
@@ -1040,13 +1040,13 @@ static inline loff_t page_offset(struct page *page)
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
@@ -1466,7 +1466,7 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
  * readahead_pos - The byte offset into the file of this readahead request.
  * @rac: The readahead request.
  */
-static inline loff_t readahead_pos(struct readahead_control *rac)
+static inline loff_t readahead_pos(const struct readahead_control *const rac)
 {
 	return (loff_t)rac->_index * PAGE_SIZE;
 }
@@ -1475,7 +1475,7 @@ static inline loff_t readahead_pos(struct readahead_control *rac)
  * readahead_length - The number of bytes in this readahead request.
  * @rac: The readahead request.
  */
-static inline size_t readahead_length(struct readahead_control *rac)
+static inline size_t readahead_length(const struct readahead_control *const rac)
 {
 	return rac->_nr_pages * PAGE_SIZE;
 }
@@ -1484,7 +1484,7 @@ static inline size_t readahead_length(struct readahead_control *rac)
  * readahead_index - The index of the first page in this readahead request.
  * @rac: The readahead request.
  */
-static inline pgoff_t readahead_index(struct readahead_control *rac)
+static inline pgoff_t readahead_index(const struct readahead_control *const rac)
 {
 	return rac->_index;
 }
@@ -1493,7 +1493,7 @@ static inline pgoff_t readahead_index(struct readahead_control *rac)
  * readahead_count - The number of pages in this readahead request.
  * @rac: The readahead request.
  */
-static inline unsigned int readahead_count(struct readahead_control *rac)
+static inline unsigned int readahead_count(const struct readahead_control *const rac)
 {
 	return rac->_nr_pages;
 }
@@ -1502,12 +1502,12 @@ static inline unsigned int readahead_count(struct readahead_control *rac)
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
@@ -1521,8 +1521,8 @@ static inline unsigned long dir_pages(struct inode *inode)
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
@@ -1553,7 +1553,8 @@ static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
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


