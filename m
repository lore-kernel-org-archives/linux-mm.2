Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0180CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF498E0008; Mon,  1 Sep 2025 16:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6DE8E0009; Mon,  1 Sep 2025 16:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696CE8E0008; Mon,  1 Sep 2025 16:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5832D8E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7C661DF1EE
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:34 +0000 (UTC)
X-FDA: 83841874788.18.AAC9A6C
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16084180006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RF0Lc1x0;
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1f6qJQlKU2vedlQkEZgjWqTzAp5uFD499wqNXxzlp0=;
	b=fh7R3aWzMM3ycZfXm+MFjzNx4I88bergsG6k2u+ysVbheBo4nXbazu4EwQS5RU3oCQvxpu
	smF7sXQ069I56zCDrp4ClJBMLv9F2FjlaOl+BQYqFm0GogLrRYBAl/sXYuVsoAJboxhjHv
	pLdqOvBlQqy1BcTNaAE+zU9AlXawaoU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RF0Lc1x0;
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759833; a=rsa-sha256;
	cv=none;
	b=bD8yrDxZweQTPfQq8RtOR+UggV/0Gl9KWF+pO/tjgb5WGZqOPjegl8Iy1YziB3kPtqh6PV
	lFlBwEled4f5nUrfz/nhIql563NpN1MrMZ3k2HbuRMyC8Jh+3v6dSg0IfkqkE0+hmOsnYS
	Rz7JFTffL8hnA0WsYz/1CJ1ylPqlPCE=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b0449b1b56eso41250666b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759831; x=1757364631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/1f6qJQlKU2vedlQkEZgjWqTzAp5uFD499wqNXxzlp0=;
        b=RF0Lc1x0ei8BGu7zS/j4HiD2R49g1oZiSM7zzhbzdotFV5k0/4R83LKN64Wm/m+aV9
         DMSgFr7+elusjGxGH4/48gjFagploTNrS7YyE7CYQ42ZCQHuvlP9a1S3aGYLz7SMaxWA
         d8VfN5WI+RMWjX/l20BPqdCjeRR7CZZQQ4j5AXIteIpBlxkkqId49+Syrsu2Rgwetp9z
         3zHF3wJ4afaDYeSm+Yk7iD1ve+x/ItKE9ww7hP3ZOZ3u+sai/w57xgVuazHNDulTzrBc
         KUgTipvyOg5qhEDnD+cK25W9wzgLiPDNMPPL1AunN7g03rUTwtpevvC10S3DCMSKNHWj
         dd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759831; x=1757364631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/1f6qJQlKU2vedlQkEZgjWqTzAp5uFD499wqNXxzlp0=;
        b=Cpo+wa3N8V/VBcXVKIcU/LoOSxUF6zjzQOL9njKNHLyLBgsZ2xC3mHbZjv+BxsSXmB
         ch2eLTmL3x+pc2N2/bX/Pd156ABXxlbB3VgAW8IYj7RXgaWe8bFrSrV+QFW8KQiCE54G
         GvbJKHb/jnhahU13UHvZOQom1A0HFoveMqJRKss+ezMmPlhp6kEF5Puavi4Mh7n+rfQw
         SJW7wGJmacaBNwzN95fMWgoNLptNL8NzNGMyM6d84y9Dw74z7ayQu9YVz+UCUDYLVkVI
         +SiVkn6B0CJqfgvJGtLCtxnqKBtm9k1q6cuPKxumj0mNK0ti01WrXFw7FoTRdhwIP6Ny
         IZ3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWB+XBLr1ydRDSDERdUV1Psc5k2k0qLBqtl/snQ8gd8RNj8U3QymbjrRdBpQi9rv62d0bLFnCxzeA==@kvack.org
X-Gm-Message-State: AOJu0YzRTpuS7DpHxXdOQHV3rnJ+fXihQDrsAqOOvcvRkCfC61OIfbgK
	D2f0lO171u8gTidCVrfL6aYT4p9LFEGgQLcJdP6OgUfEcvkttCp4fEHOHpTrN14wzvI=
X-Gm-Gg: ASbGncv7BA892NKJkh5gyXj8WSRYefrLXvA+X87qQ9LKpCRzrgAJXjHUumrSLQhWbnN
	ghvZY/MSscCXWxvMQCEegS1d+n7kE2g9R9hVQ7jM1PzRSP1r0PJPZB6oQ4MY5S5PF2qUZJuLylH
	ZasR43NPpIfVWy6eOGn/WDvK8Fv6pSTMDbFHBD1TQfRWd9EUpG184fuyY2fnpbwOrLZPAkzdbcj
	kgtthqw68mHfedWo4+rpEaSzrMVMbUqB6W1hsdu+JcZmMCShrZy7mVyMGf/R00zc9SIdhR1rbn3
	73SCMynDzSjEFI7IB/6iC1l6C5/PF5OHU+D4tfWGfCXlHICZuqfDuH5jAW7aupTon73hekYbEcG
	xsPCbYOlVro/u5qfkuAS5wdSpAaYu89sxbjTLRBvo18DpIJrWcgk0/O9Iq376P8BcAxfjQ042ff
	ToSvy2brD70xR1k9fLU/N1Kw==
X-Google-Smtp-Source: AGHT+IGLBX6wwzb3cKCBC/QZF935pSrteygp8WwfL9cJcqtVvsCINHnkd9V2DN5htvTXhoMdjdntAg==
X-Received: by 2002:a17:906:4fd5:b0:b04:2ee1:8cb with SMTP id a640c23a62f3a-b042ee110c4mr549232466b.63.1756759831287;
        Mon, 01 Sep 2025 13:50:31 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:31 -0700 (PDT)
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
Subject: [PATCH v6 02/12] mm: constify pagemap related test/getter functions
Date: Mon,  1 Sep 2025 22:50:11 +0200
Message-ID: <20250901205021.3573313-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 16084180006
X-Stat-Signature: 91pyxht3wbe7s1t14tu357xf4xhmr1mk
X-Rspam-User: 
X-HE-Tag: 1756759832-528027
X-HE-Meta: U2FsdGVkX186Y8T2COLn8NdIiiZejJUjC01uxEciXdxf21oYJJSzIwi/f+filZUndSQA6EQ+qp0bJWUnjHGzfgNT2uSbQxuwsuI6F8lQusRW31qe+B2TOjgH69udhwMFS7b1T2UpJ7v2F2h/l+qROLWqj1DPHmBhlM3Q85FerSNbXfESi5BsUKxivHvCQoDzwumPUoM8tbBrkJ5uF+3BqabaCOxLiLhR1qEM2yaS04EoJIfW2PIX0Vd/74pxKvRgv3QDC7IezAtaOeJ7wFvY+QrDqQ2IQXFlBHtMugHoCuCCl1fZogLuuc7SsAJTPDbCVIbM5C+rhiunv5Ai6Ywo7AXrv6yQXv2AACXHOZvkt+Dke0Ll5Fm3XF2wzRpIcLWPMZVpD2HHOiHVQIgsP1wR6f/hjncmliPoNUi2rBrTnNr8fa/tjPeOSYA92RV7goT0ft3ECB52tMfOHvGclmqp+yHI08KlkwMd2C+N7adPSt7HdQnqUZIjHCKOmD1tD5eq1yHmejx1wg5EiMQfzRJgbdS7cbHsFrimIAejmYTlup8FyzKuu6YGd7XWmz9kd9yOFuyM4fa7fm7lp2MMxy+esAd5cghqW08P0PHUqGczL8PJDnx5wDFaMxVqKPlUkxlPtZT/oiRprPsUuifpnl3OwSMpuVGSxnTit15cuB7XIlbNd2rnq1eeQgCSg5f/K12CL5tNVW1QainIqHynlHFGz7yrn4QYmcHfZQzdc2sNYuUcg5SXxasv+/GAkA/kIjmoObHI9uGmr8AkLuIDrQARIX1/n70xT27Tg2uBFyvsvTmjKLuFGmpGDHxBVHvazYDK7xm80CodpThRi3hcW/NVcJer5F5BwprSdygzjYJXi8GKIMoJp2p0j0Pubc3BREcARtZDo+fSPG40Q4vc70pmX2MPImvOzvC737TFm3LJZq1NQE7+DTxS/pAQ+lA2u24NcfLjsNadLRi4V10brrD
 waoqTiUe
 AaRIVa6Xf8xsYru8Q6Dssu4uC9M9rlqlemyBVyFSgTSqMwWEjBizbSiEk5UjjxwQgKXP8YCjL7wBtwY1lz8XodBHPmuS9mlTjAENFL1PrwyBCkBXCd9rnTMVRTAT1iFcMGf432gytqetECFIj21aFAX6jpJgC+v9UVyLK7hot6ehITXgI1pCw+VC4wAJwAVVIfXWq7dnDbxB/P4x3+J58FlZBQ2AJ+wFJn+RxPaMPQlRotcrfSxWXcUw0xf6slWS47LRhuPVyzl+Ehrbc11ZptuqG4ythYgI9bG5gBJxVeRijVglxPHLdt0VXYkI7xY6BYzET1wGEZxL82ZMQtENpfpiL5fwYlvNumPoX1O4d85oP9ZX0/WRoVjkmK0OlBFBtNAFTUkfumwuz6Ylv9mGeKGacrbp9ju2hz6QxQU1TC5/l7pQ5BRG1BrvCv7z8POr+MiMsub/+DWOjTItDH2q324oVqELJMyNz28IUMUulHYECAyHxyUbwJB01unFLh3HBvFXe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/pagemap.h | 57 +++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a3e16d74792f..1d3803c397e9 100644
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
 
@@ -267,7 +267,7 @@ static inline void mapping_clear_unevictable(struct address_space *mapping)
 	clear_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
-static inline bool mapping_unevictable(struct address_space *mapping)
+static inline bool mapping_unevictable(const struct address_space *mapping)
 {
 	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
 }
@@ -277,7 +277,7 @@ static inline void mapping_set_exiting(struct address_space *mapping)
 	set_bit(AS_EXITING, &mapping->flags);
 }
 
-static inline int mapping_exiting(struct address_space *mapping)
+static inline int mapping_exiting(const struct address_space *mapping)
 {
 	return test_bit(AS_EXITING, &mapping->flags);
 }
@@ -287,7 +287,7 @@ static inline void mapping_set_no_writeback_tags(struct address_space *mapping)
 	set_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
 
-static inline int mapping_use_writeback_tags(struct address_space *mapping)
+static inline int mapping_use_writeback_tags(const struct address_space *mapping)
 {
 	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
@@ -333,7 +333,7 @@ static inline void mapping_set_inaccessible(struct address_space *mapping)
 	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
-static inline bool mapping_inaccessible(struct address_space *mapping)
+static inline bool mapping_inaccessible(const struct address_space *mapping)
 {
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
@@ -343,18 +343,18 @@ static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_
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
@@ -477,13 +477,13 @@ mapping_min_folio_order(const struct address_space *mapping)
 }
 
 static inline unsigned long
-mapping_min_folio_nrpages(struct address_space *mapping)
+mapping_min_folio_nrpages(const struct address_space *mapping)
 {
 	return 1UL << mapping_min_folio_order(mapping);
 }
 
 static inline unsigned long
-mapping_min_folio_nrbytes(struct address_space *mapping)
+mapping_min_folio_nrbytes(const struct address_space *mapping)
 {
 	return mapping_min_folio_nrpages(mapping) << PAGE_SHIFT;
 }
@@ -497,7 +497,7 @@ mapping_min_folio_nrbytes(struct address_space *mapping)
  * new folio to the page cache and need to know what index to give it,
  * call this function.
  */
-static inline pgoff_t mapping_align_index(struct address_space *mapping,
+static inline pgoff_t mapping_align_index(const struct address_space *mapping,
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
+static inline int filemap_nr_thps(const struct address_space *mapping)
 {
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
 	return atomic_read(&mapping->nr_thps);
@@ -936,7 +936,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
  *
  * Return: The index of the folio which follows this folio in the file.
  */
-static inline pgoff_t folio_next_index(struct folio *folio)
+static inline pgoff_t folio_next_index(const struct folio *folio)
 {
 	return folio->index + folio_nr_pages(folio);
 }
@@ -965,7 +965,7 @@ static inline struct page *folio_file_page(struct folio *folio, pgoff_t index)
  * e.g., shmem did not move this folio to the swap cache.
  * Return: true or false.
  */
-static inline bool folio_contains(struct folio *folio, pgoff_t index)
+static inline bool folio_contains(const struct folio *folio, pgoff_t index)
 {
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	return index - folio->index < folio_nr_pages(folio);
@@ -1042,13 +1042,13 @@ static inline loff_t page_offset(struct page *page)
 /*
  * Get the offset in PAGE_SIZE (even for hugetlb folios).
  */
-static inline pgoff_t folio_pgoff(struct folio *folio)
+static inline pgoff_t folio_pgoff(const struct folio *folio)
 {
 	return folio->index;
 }
 
-static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
-					unsigned long address)
+static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
+					const unsigned long address)
 {
 	pgoff_t pgoff;
 	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
@@ -1468,7 +1468,7 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
  * readahead_pos - The byte offset into the file of this readahead request.
  * @rac: The readahead request.
  */
-static inline loff_t readahead_pos(struct readahead_control *rac)
+static inline loff_t readahead_pos(const struct readahead_control *rac)
 {
 	return (loff_t)rac->_index * PAGE_SIZE;
 }
@@ -1477,7 +1477,7 @@ static inline loff_t readahead_pos(struct readahead_control *rac)
  * readahead_length - The number of bytes in this readahead request.
  * @rac: The readahead request.
  */
-static inline size_t readahead_length(struct readahead_control *rac)
+static inline size_t readahead_length(const struct readahead_control *rac)
 {
 	return rac->_nr_pages * PAGE_SIZE;
 }
@@ -1486,7 +1486,7 @@ static inline size_t readahead_length(struct readahead_control *rac)
  * readahead_index - The index of the first page in this readahead request.
  * @rac: The readahead request.
  */
-static inline pgoff_t readahead_index(struct readahead_control *rac)
+static inline pgoff_t readahead_index(const struct readahead_control *rac)
 {
 	return rac->_index;
 }
@@ -1495,7 +1495,7 @@ static inline pgoff_t readahead_index(struct readahead_control *rac)
  * readahead_count - The number of pages in this readahead request.
  * @rac: The readahead request.
  */
-static inline unsigned int readahead_count(struct readahead_control *rac)
+static inline unsigned int readahead_count(const struct readahead_control *rac)
 {
 	return rac->_nr_pages;
 }
@@ -1504,12 +1504,12 @@ static inline unsigned int readahead_count(struct readahead_control *rac)
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
@@ -1523,8 +1523,8 @@ static inline unsigned long dir_pages(struct inode *inode)
  * Return: the number of bytes in the folio up to EOF,
  * or -EFAULT if the folio was truncated.
  */
-static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
-					      struct inode *inode)
+static inline ssize_t folio_mkwrite_check_truncate(const struct folio *folio,
+						   const struct inode *inode)
 {
 	loff_t size = i_size_read(inode);
 	pgoff_t index = size >> PAGE_SHIFT;
@@ -1555,7 +1555,8 @@ static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
  * Return: The number of filesystem blocks covered by this folio.
  */
 static inline
-unsigned int i_blocks_per_folio(struct inode *inode, struct folio *folio)
+unsigned int i_blocks_per_folio(const struct inode *inode,
+				const struct folio *folio)
 {
 	return folio_size(folio) >> inode->i_blkbits;
 }
-- 
2.47.2


