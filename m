Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0F2CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22308E001C; Mon,  1 Sep 2025 05:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0548E0002; Mon,  1 Sep 2025 05:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22EB8E001C; Mon,  1 Sep 2025 05:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 873F08E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51D1BC073E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:31 +0000 (UTC)
X-FDA: 83840133342.17.D5111B5
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 727FBC0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GXxC3NI1;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718369; a=rsa-sha256;
	cv=none;
	b=I2tAQxolCF+Q3rWhPArnI+RIUwQwL+/Kk0tDLIlri4D+fHOXEL5XmVvqEw8lKcq6aOohf/
	RGhiidCYw3na7nFvZbH4dTOWDkmqCd626wucGFi/zIS2I1LgHtvmSgqIiUwBcz7aCTbh+W
	NXoDoqf2SROpI7c/r6YPxAUbtebDgJU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GXxC3NI1;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7WepIwVsrDIqGjged5DTLMeHd34+rtR8uy9Koi3lTw=;
	b=wRJ8qTYITxP73KN8mVCv6NJKsbk+tLA5InX/Gd4raMJBiRU2h1LYTirmefoCHtWnFTOCQy
	AYGktf44GV9S5iCO74ughdzwA+HnloudxFcQLrcA6ThmQMfDAqN5PIajwugqH8jr1Q5spM
	eSD8lklKjvCYaPmfLGZzBiS6Af5P2fw=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aff0365277aso408756466b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718368; x=1757323168; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7WepIwVsrDIqGjged5DTLMeHd34+rtR8uy9Koi3lTw=;
        b=GXxC3NI12MCOrMlZbS6iEIZ2LlH+A6kIQ0VTYRcSng1/0TwGtxgjFcZf/V3VUNme23
         nEtn7RhguvJ0HCrvrKDGFci4wh3MMvbCIGrx8Vabh/8V/LhLNdvMGNbOfXqeE84f1QmQ
         hgaiNQbVI6BKD4zwstgXeoF+X576bnTji/x0PZA1Dmo1UrA41ih3TbdM76sJ568mMt6v
         beYUDjz5zU+k0+zR0WNF1Ree+cvROI0fg9pTxxRyjT7uWViK/A6DM/XcT5ILk1JCnFPn
         ImMHBBwT1JCUEo6seAyMrqRiD7hDBRHKYLlny8RIjrLiw/CoR4WmhT33T0UY00T1Dw3U
         0W5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718368; x=1757323168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7WepIwVsrDIqGjged5DTLMeHd34+rtR8uy9Koi3lTw=;
        b=CuXGjDEI5tNHd0yssf9GIhoNjSFjLmm5tXv5YD1qQmC+h2nRORculC1PQ+jEdmb7oO
         HH6+7xpBWP6S/rAD2REEJvhUo/nVMzhebELTp3KoYwx32U3Mp9g39SWjDZ173use+0OE
         OlOi7OchE62BNbjfLsJl7sV7pYxMZF1ZzVT7WG0IWzOyF6pzs7d47+0a1URn2VCvBs3e
         y28lwMOfsMqa1Am1HQ7810fKC26TCJkv1c6uBti0rucADLBzV7WJx25dyoKI8RmtqaMa
         oA13SACFqPjPPhVbsqABQ8eVcfArgIGnhGmLX/w/u/z/vlbByfGUXaBoXVyKU1Q54Vlp
         U09w==
X-Forwarded-Encrypted: i=1; AJvYcCXlgQ71o0tKcEyYbBFcEBAbu4tvqcJeo69msgScvKMlfvlQbTzCNeSATf5KFV4lC3xVYXN9WLQlMg==@kvack.org
X-Gm-Message-State: AOJu0YzzJ5LJll2QJkDz/HB3FFGvlaH5IvA37bRe0u6Ml4ZCop9IKW50
	xVTxE1WqizpTKMwp5cVsL/D3pFwMlSC+7G9tdy3lm6EL5XcWUubTP86TpMbJbCfEGGk=
X-Gm-Gg: ASbGncv63eC3H6kr/YQULq/wlTpQ+K3xJaadW3FEsrQvuCJPasZi9LXJFctPx5Vvnvm
	GNZLcxTpkjqna8DZF/onvhvN+pD6/HIHBZTdA5Pnw4L1PiUCEu6OynTBF/K2mkt7yxAqP2FLwse
	Z/DWcb5pN9nbjfpz/UPKwUWMeVnPMwc60EUaYez07K+QDRK8rxprRH676iS/pHSAjazh7ya0Zj1
	NyqDuz2L75kGNotkgakESyyAycXNBOISdOQAy3M1TYuZXzDnRn6OinmUUklHXxHgnpFw1+9e93w
	mN3OgcdSydPSxT4jwRFnwgBN8HVwoED/nErATiTDq9i67+1N2n3npODlOKMz3FrL6dPhHM89xMP
	xOsBA5O5QNSO5Kk8db81kS+DulgqkTREf3TOPdPm2Pa0XZCB1igZeBIvhOw+shYLdapY7kKbPNi
	tCAyv2ucLTsLUayu9oaVhaBgd+Bf1NHlgF
X-Google-Smtp-Source: AGHT+IHN/TqbysKK0s5Zu0KlpyXlJ7CQoaS7LuJ5q1gjVHxfVF3yXVZtull4SVbEI/dReygUbTQsRw==
X-Received: by 2002:a17:907:3d92:b0:afe:ee36:2eb8 with SMTP id a640c23a62f3a-b01081807a8mr707309966b.8.1756718367712;
        Mon, 01 Sep 2025 02:19:27 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:27 -0700 (PDT)
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
Subject: [PATCH v4 02/12] mm/pagemap: add `const` to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:05 +0200
Message-ID: <20250901091916.3002082-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 727FBC0004
X-Stat-Signature: 7gjruu5e8sqnqgpsdaoop8yiacyqi3rp
X-HE-Tag: 1756718369-384899
X-HE-Meta: U2FsdGVkX1+AjlssfRp7idK9KEXmaGfYYkKX4V2IfStFeha3pnxeb20ON7/A0Piu1soTHLIogt12iguxcPGkNKJngDgkOp27HR9155YzW2rBZHgaP8o2sFH7tXT7vSs4Fb0Qdxum4WBUCp6cpb/CGOwnM6V7X/KJDzKXQxX32NPMHD5L9ZTXabQiIPwHFJZnkmLMwIPpP0k9mhGBlpq4fT3dX1VQKdnc9dy8VL0tO8azx7fjRX/fxgHlydrIdoyIpqPuhfA+NbWv1Ix7u8z2QwfPcUomaNHnUmplEV5M4ST+umeh294s1WhDn1usp88vOyqYVaQEksYw5FlOFBy/upQshZoZC4jowx6rOs17EHyzloAHHE/BVmw2Yc1X9OpZN+Yl28vdQBYewi7faOV5RNOzxtfRRAIYqWyHFudmCOk8rft0wWLtLf2mJpGyCGkkUcGQaqCjNsC9OpnZxo1hp3STj+N54T7fyKDEEndE0zlL53igxpo+BOMWASqxYMwxR4FMUDF8xuH+7WjByFlSKfcaFc48IvpgNMm79DvNwDd0+MKs5oXmh+mTx3C97d7Xfa1hExrzsv1WYUG9xh5+iE8QnufYYlQDJb3y1G5RPQtfSsNYnLNWeRP4GoW53pMOf8nBDXO49AEzdO92lk8uRNRgkjtQB8rRnDCdo/hGFI6Ri4TEmucdcxIAcwRNSy/ltMfPIDPqa539NM1nEVxFSP1/1zMjKupv96rRmAslC1DWD44N3lzx6A3gZN4mlPVK/MM+K47b+BPGgz+N4fv8b1fxHqC2p70cGZyeeW6fI2R7TG1T6VPYDlRF5GFopJZAsUQnroaOIRqo41k5o0Q9WBE/xNy8/cKm6aF/ekU8nRuhGO/whg3ohUNy7geHn+yApWuVGYC5pzn165jdM0z1SiwLVt8U5a3l6IRmd0nr6q0CXGhEitGYOG8za3QwYo1jJtzVVhXGMRyb2DSuNHo
 +KPkoGFm
 N6I/0WBOUqcxA1k08t4D9F0W5J59nV9xZGTmgmjJ20NiIrjZSpFifrw9ur0sGQoGU9Ep2qPcQyZqRLW3Z55gGacuvTAt5wwFHGm0b0b7HOTO2NPdFNglr7KVeWK27nuPX1b4TCWXqJJjobyAlSDiVn8r8KNGPewW85SsMiCFfTwDPYtJdU05g4NcLzLUcNj35YDIezmLRlFMlXb8qQGeE192NrXgbliO73OzKU1Yut9YTqnu/chdDbzDcM+comuOvHoM8esw/8iWUtrvK6XtKD3a6YUr5DmmM7lcPNEpQTIgWjXicDxbr2Ccw6NoA0GcET31KeqaZ/Ti1cbvNDrAVyjnhIetVAID9o1Do5sGEVjELQjvQzURHTZRR88LIwepgKoxnNLTogyc3xPizUjiZz8Gi5i8F/U+bAtFCaY/JZqhykg7kayHYwVF+zZwq7CntvrEdyOOOAjtz44Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifiers to address_space, folio, vm_area_struct,
readahead_control, and inode pointer parameters in pagemap.h functions
that do not modify the referenced memory, improving type safety and
enabling compiler optimizations.

Functions improved:
- mapping_empty()
- mapping_shrinkable()
- mapping_unevictable()
- mapping_exiting()
- mapping_use_writeback_tags()
- mapping_inaccessible()
- mapping_writeback_may_deadlock_on_reclaim()
- mapping_gfp_mask()
- mapping_gfp_constraint()
- mapping_min_folio_nrpages()
- mapping_min_folio_nrbytes()
- mapping_align_index()
- mapping_large_folio_support()
- filemap_nr_thps()
- folio_next_index()
- folio_contains()
- folio_pgoff()
- linear_page_index()
- readahead_pos()
- readahead_length()
- readahead_index()
- readahead_count()
- readahead_batch_length()
- dir_pages()
- folio_mkwrite_check_truncate()

Constify pagemap related test functions for improved
const-correctness.

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


