Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50EAACA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4E48E0003; Mon,  1 Sep 2025 02:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6102E8E0001; Mon,  1 Sep 2025 02:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C108E0003; Mon,  1 Sep 2025 02:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1618E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D11365A822
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:37 +0000 (UTC)
X-FDA: 83839662354.15.D817596
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id DECA71C0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Co66pfUF;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbOxTOmsEJ7WcickPs/Dyo+zW1ULm2UsA/dTtkyEV5o=;
	b=6zanH8So4CNsylDchSaPwoHh4Rt7HDALv9OeqKSUfSNjkCFNTJ2EQzqlBzEcXtoTeOAEtg
	4dec4B0agtWD41hNp78ONV6Kq8a/Y6LjSzzDK05b2FlQvCq+MF2Av+jMa8UV1upHYDuFGn
	XUDOMgP4Myl33/OlTOqYGPE0XydnZxQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Co66pfUF;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707156; a=rsa-sha256;
	cv=none;
	b=KOVySDUHabByBIqXHWer2IkGwmf2ySTutVyr1ySUr8UI6ZJTDACdZGliDZLJcIWwSsWvh3
	OEq90yCuzp0GVYncHDwFzg8vkMKjuukc+PqH6hRGzAYJWTnvakG9VrEZIiCjsG7yJ83h0T
	1ZPq9/OkK7pEeFVQcEtyjgRRXqE32o0=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad681so4886899a12.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707154; x=1757311954; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QbOxTOmsEJ7WcickPs/Dyo+zW1ULm2UsA/dTtkyEV5o=;
        b=Co66pfUFn+RABNUTmyvQwZYPt2rpzb3DFIv9qNSaBbMKcdVwokCvAJleaQxS2Ub3C8
         VPCUb5u4AFnn9PD2PKg1ADb8hKHTJTby49vIHKYJx4u6pVl2ObMySQbivbRGetrkmOWR
         kU8e882FlXV4kmdsysRXAcG7Nhgz+fuurlLLY1nQj5hDg9EGCUgMIe9HZGX8Rnb3FYz4
         c/VStYfktAZK5fmVSPMFNskB3JGd4ydlo+IfL4zOuzDcH1ymMavAyGJ82VFLsLIkSGVe
         eVbh8QVxVthix6kpiRYT71/cUVPttzSOM3PH6s25uSlIg65W6n+oCvjdHRm+nXYJ/oWw
         BD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707154; x=1757311954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QbOxTOmsEJ7WcickPs/Dyo+zW1ULm2UsA/dTtkyEV5o=;
        b=NtgNyO6DEdEyrtCWy+mgc3hJC34IxWMTVaRUSHTVoyvr4h/jLOUI2dMUprAu/cq8SV
         iswge0VLbvVxIWMFEbKu8rvaSm4U1pOm4RMPs3/54zHzbxkybhFVVLESgTI3Wrm1wLfD
         nwzPzWnOV1EbAy8m6r8K3OKhEF6UtsYDpycuDneoykoGIUOynSVuzSbfOgGH4romb7sY
         lK/YdhHQIDtTBsnxHz+Bapv2UsVKjRY1+5+2KOo8ISK9fG4XEU8B+T5zOibTc58cujUb
         1TlNHhGZbjWKMwV8rjuKS4fcqsJR9oeMFnI9XBSkYFNtjYSnjw6mBkiBN3oIfkImeUhw
         kbtA==
X-Forwarded-Encrypted: i=1; AJvYcCWN1nHXi75b5htEuS4FiN1HNqpAeNK7cHBthlGPQ2bLiVbsxvtt92ohXK2QhdJpjzAXXzsCLK5MFg==@kvack.org
X-Gm-Message-State: AOJu0YyJpRzP5tlBCf40n8pAmqgsO/h3vnP7GeM+RlfrdCLn4NTr+3wN
	kdds29u126/Nlbp9G+Zm2WtFEXgTjYJlTU3Msv2JaSUuitOKZC2Id16JWnndzhYrgsw=
X-Gm-Gg: ASbGncvN99f5doQj7HnrnoqdAtw0izxzhhWbeFi1ZzPMKGYxVz7AyBPjoARfdlCK0Uf
	3dXETu91UNFSbGdK8DCAbfi8xUS5iQl7HPZYZiZnPAnpHuzoos3Z8GlYfGgGrVYbw3Sm7GaYNT4
	C2G4T2hwhRMmUKKTcRK4nqhJuzPgfQBe2GgnLmMIC7B+inUbED60A7rC9T2hos5yWiaW+8as6SU
	M/++pHTqLjF3adGs0gFDyu2YTSvPEaolATqjMkk+XxfoTMKMme/HEbSsWMKbIkSNWUPbpEFo9mU
	r9ZyghJk0XNM+9x35tSKEe8CDuK9pD1oCzNVu6iqN7qAXBju7Y8aNA5sPKRHGg0qru41VmX9TIf
	jmX34Q+EkbwXI8bITZYMliE95J3dlw3wGRyJPadg0LRLYGCnhAoSoVJe/PbFR1SBmVa8XKPpIGr
	020ejFhOA/HnPGfGmoZDqjeg==
X-Google-Smtp-Source: AGHT+IGunCnqYebXshKmhp69hbzsKN6RWeNNdfy7R5uCmjqSaO23xnCPBnHHUeEvtpUMwNy7FNQfdQ==
X-Received: by 2002:a05:6402:13d1:b0:61a:9385:c785 with SMTP id 4fb4d7f45d1cf-61d26eb5db1mr6033186a12.36.1756707154327;
        Sun, 31 Aug 2025 23:12:34 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:33 -0700 (PDT)
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
Subject: [PATCH v3 02/12] mm/pagemap: add `const` to lots of pointer parameters
Date: Mon,  1 Sep 2025 08:12:13 +0200
Message-ID: <20250901061223.2939097-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DECA71C0003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6qfrhoq9s83wyssr4gzosm7x1rju6d1k
X-HE-Tag: 1756707155-901304
X-HE-Meta: U2FsdGVkX19lVNgeFA5Zaq2ShDKUfdcugnDqw0oWETXSP7TLm4tik+yQKBHQS1lT/qWHPj9sqHyr/0SiWuKi4TAxOlOc56ee1X2mBulE3N0gEuKSR066hXFaUFDfnCpw+zzY2/14zXHP5m/aAJcKQwxtCAJRW9wz/s4zCJ/9+qN0EUfsc8y5tvI7X8V2/hoobwA4Ekb7CO2eo1GnU7Ktv6N+gNRxO5+/xfMyZIRRmJb3TTau39bSTeW7bUDufX3bbnk8ziYfVLJfr9oaeZYSnpAqbeV8oNnWwXMz93B64AKQLHKS5+34ocJHxVvO6MhAvU/5bhNvUDaBghaJfkr4jTePjW1Kp6b98CDCfczuF84/Kvud7bfqQ+LzqbKK/gXpW+BbyY19pbUUO2ruzmpNRxZAZ4FGOMIuoQ+wZY5c16wMX4yPHUgugEJPoTPQilws2JRwbOKcG9aa4wejxOSSV3ynZQMTVSYtKpsD9T0/OZ4Thz3mQCdUQF5voWdYD3gk4tzi8hmKD65Bpq6zDzrUKM82Wr3b6k0XY37wNEM0eKlcFNUb0/rtBVWiSnWmACNyuJrCiEVb/feJRglWhkoP0rTsKoI867vh+cBhiQ+spqFwHNg7CgO0TTqqbuOA8T9ODbI3Fq6CFnvwTW70J6pwmTdZRxncJZMp7/7s59Pd1hSPl2L3egDvE9hcxJnikyd+YHGkrEgmIbi+isEidleBUCZC/WfRIBrWQha5OYjLf9KFLXNZTVapnRz2AVYs9AgSU70ZxocEVXlK+w59Rv9nTtrDfewgbRlveBZBTSe5HJY6SdXqP4VEX3YKvQUuoOieXqpmGrLCMVnVUbdGWjdiPqnExgTAD9g76Aqh7glXWPBck6Cklxg93Gmm6z3TDjpRI9l2xGAYv+v+5LWn0/GkzWSRwMgIFJ4kcokE0jhwEtjzjtGDdpwCEKKpVhBW2FlNrCL6gya24Nsh4etqwwB
 XdfCGM9Q
 7DFdLYIFlF4PlCxtWLXR3IzBdqquxCxbXiXvhprGsiWA0ThHoX9WOrf3pmnU6KmoWlIdirW6Eli3oSaArxMIRJQ+lCtIaGeELO5l3i9h20clU3iaZd/Oa1qCCePfpTS0RtgKTjAHX8N3pCd+mqbRsuU1jiJk7vfi3FydvYvZ6axEba66lt3c9acx4b9sPQMwQueE3eKxxD2B/q3f4lwVdiIdvyVu+Q2pQoeoygkLhUOyLz+IXOydI1DnDUeV2hUivO7aoVzFb9lIx17X0aqKcBzMwJBdRnyd4VAkn8PBhHJcAYbniRHzQFmFNDKYsQyMQXOcCCC7JROh5ri44jillTvTtLbR28KZTp5aIZyF6kGKj2AQXw2uT66JpFWo9DSCYYdriYkLyClJxnh2S34MnQ0zSegW1tYcm0589WZJ/7r3N4mK58N4mL0IxSulGB3fmHOVBAaYkadRxNFw=
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


