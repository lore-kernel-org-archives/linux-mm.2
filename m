Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D771BC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2374A6B009E; Wed, 23 Jul 2025 10:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C05B6B0132; Wed, 23 Jul 2025 10:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E766B0133; Wed, 23 Jul 2025 10:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E13636B0130
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF91B160699
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:52 +0000 (UTC)
X-FDA: 83695808784.25.03CE356
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id EDB01C0011
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=zjse1nGm;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282071; a=rsa-sha256;
	cv=none;
	b=GUZKKdt/XVI1yfXeB5kr8RO/qFB5TwO82tbdOmfS5duhLlmRURz/OL5yICzL4tWF5zmCmQ
	aLJ00UFqcOu/0x0CoVAcEvTjvWHcpP2aKhzd7RV6gCiC+BuCWMvjY/uAevhrhcAruqhZ4/
	bT4p59Y7Oo7OMF8GMRmk6rGHsTAHqZQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=zjse1nGm;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7cc+J8nsCZ/iRindbQQ/niSVeH9iE0nAvoyR2/FgGA=;
	b=uVtibOqBe9noY0N+rQk1kNRG50c53ITNuBz/OSNJzxmLIilo3375rgRxjAb2qq7iAhqoRi
	znTvlaJbpq/oBnL8E6KydA4HyWPInQeOGsTDaLYYpqxgJgbeg4/TQvHb3PJ6/v0aXp9CHB
	yI6bGnVPaGF3/ibKfJmIH9FdSngn4Yo=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-70e1d8c2dc2so65672177b3.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282070; x=1753886870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a7cc+J8nsCZ/iRindbQQ/niSVeH9iE0nAvoyR2/FgGA=;
        b=zjse1nGmBuDzBmRZI0WA0vP5vdN5q/EG4YqtjKLAhUV+A+AXlQJOvAjeFxm1yH4fMc
         Z845MNx2v76uzkSeVa5y7Q8gqVxVITDEd2Dzey+Lk1gFrDfOhqpPP1Qdvc9G7D9KoGqW
         AiZ8lcnSJCkfJwxASXkLtoBTyrBMaa9Ui/KmOiBq7vvW/toQBxfvv1eSqWCBEmnv57Nr
         Ax6hmIqjnQj0RLWnbZTNBjfJo3x0WW6O428HNWcKDkV5Nwt1sTa+HF8M8z6nheeUAFgI
         qEFUnJY5m1ByTsxArNReQZlqdUk8E8BbtuN2TWChJSazKnvM51LQ7JE6/LPNu1E6LOKu
         iWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282070; x=1753886870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a7cc+J8nsCZ/iRindbQQ/niSVeH9iE0nAvoyR2/FgGA=;
        b=eCpD3zC0ZTMsXq+OI/SJL1nvoXsRmnV03fuGTvvo/UbIrqEFQrg1wS6P4rkur7kG7E
         9LwqjvxQGA63KD1Pf91EEkk7O5PRVP3C56Hh2cAKrdDVRzqdaJkDp/h2vXk257ZS37EM
         lUHMJKGz+qpfdnvmRn9FnGFBgL5ozqkwiwR41YXGztSZ5mD0se6fo/UATloYKrVdAMu2
         0+MIB/vyyrOUof1v6Jkon6C6fyAyDUvaBqalmDTUf31ZNL/7uOavZVD4nplSiMMDKfF2
         8LDljzUmXRa6KTMYN3vCaQWqKCxT6w363hS46vtSK1d79lvxqKzH93teBZSVZ6DPNdpm
         6IeA==
X-Forwarded-Encrypted: i=1; AJvYcCXoqtlVaxh9ii5XfU8O9ujUn4RYSy7WNwBU/rCLlV/Ps9va3ygIaEoZgfti2pr+XMbFz7mhzLJ8yg==@kvack.org
X-Gm-Message-State: AOJu0Yx3XJSnMs0DPGzwdmqPeNVw/BDx84cG+gL9yOjjt7DXPuvC78/T
	V/bAycTdezru5cAtApNo0ZUXSNKDejcOZm+2kaufHhWZSeQyo2chMLAIryW/S1pQnUg=
X-Gm-Gg: ASbGnctpSike09fRRkkK73TXtrFtR1G1ykGvAI1GbD4QL9UIBeeK+Ct/SuJ7+mQjcT7
	ZqVWU7cechAgx+keqJaVrxc4fhx0JBHJtFgZm54FEN2d6yh/nD6FM6ycFLK0/sV+srP8XInEhSy
	jb67lfiVAYkMJWTl8kAtpVdqSeCNe324crbuBHaK6e4Zd+YwacDLamSuE1eU2Ev64v87Oxvi+hT
	HDbj8xRXSZKZyEwb/eAWawZjFx+6wpVAuDXu5ag/vGUFNDUdY/72xnff4NSE/cuW0xJhXXZsprV
	oXER/UVMhWyDYq2t6OYhMBMBpjb66WgHEZJes/8bK7OTNwmlXGv0mu9B+UzoZ17npSkKJsMayhu
	OjTaJudb71usIWPQIsNu+917UECNkWD5smPiStZmF+eOcY2cYF35LyxtzHdvfAWg8VBLvpa4jVI
	9/ZlX1oih1B3RQfQ==
X-Google-Smtp-Source: AGHT+IE5VwnfY3W/9KIKWadyQ8YmwEe7nfICAnpKXhV+FZKxq742FfGNPYd0VcNoWXlFXd9fHhIFIQ==
X-Received: by 2002:a05:690c:92:b0:719:57a5:fde3 with SMTP id 00721157ae682-719b4149efcmr44710187b3.3.1753282069966;
        Wed, 23 Jul 2025 07:47:49 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:49 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 27/32] mm: shmem: export some functions to internal.h
Date: Wed, 23 Jul 2025 14:46:40 +0000
Message-ID: <20250723144649.1696299-28-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDB01C0011
X-Stat-Signature: 78dw4fqkt9egw4fqkkoqt77cpm5ed8t7
X-HE-Tag: 1753282070-64850
X-HE-Meta: U2FsdGVkX1+vSFe6JV6vQPIM3lVrUjhxqaVPgZlKwP+2j1Md494cImzuRlr7DX4NQu1TK+pZUG/jLEDd5Ameh5zPxtMuZ2nforrReAFOa78M2VTpkh7q59kqpWLBlwXi9ivHtx1fPIaixAfrv1+ymbFcvKKO10nO0Z59kq0VBHZnggo4FjnMq3s83O4MF8YfW8wMHwmcEQ1yxfHf23oGtCuald74FJmSOueyMI7nmtIsrQoe82wfslaPJsNfRkxXdosh11UtJRtS9oBcCvkBNBBorGu0RrYPVM5jgroGZPsCrQX2VAnHXepMAqVeB+lwUOTme1Qp23F/QZQZUPsp0uiUdTndRq25z6APfv5pDZRYs6EPGybn+B3VFS0rs3ZrjBZDZ9tL0OwMkIeYhxA7UJBLxE8OBA/GC7S0ELXYoxzBo5V9exVjMQ6GzcUgTRF+LVPDpKl/0r/ngs2JcDvYYf7W1jsHQ+UDig5zIPjWpnfn8yFOukhwi/1ngG5zAyFc8BJMMC/Yl/Dpmo/sNLOIw/NZJzHjCdzO/mFrO6kQvi2R3Ia/T5MLaRUuh7bDGt7aCh5HQv3QyFN9UDredpdJgLwE7qo+PZ3ZzESfOxAt6Jn1sYEO4d6gd5efXk/YkqI28dMGsYoNfzPikzdemvkjLRklp57k3Dak0JNB58zOdT8PqMiGgOXIah5qlinEBuPtyg3kdV6WIaJO/vO8XwS9inaxwgAAVgS4+ulVc0SAOtnr7kS/rnGy+LErpgs+dzXRcYa3Xxdq40V283AmkEEGvWwdetwgMPXfHyQ3tAVr+e6tlUp69Euwe4NrahImPbSKLeOxxOowzvTd+OiXWgJQsB2T9S/XuaixYXtzyjr5mBqovy8XRZB9s+1X/xolr3R8Z778on/LVm9DHrcMCmUpfxa2RKnD6ecv5+DQsx/9Y8rLKfGYYW3uSw3+ctqSPj1RMpsUQ0t4htGx3RWK7LP
 dTMc2NOr
 Rw5gS6y6nDXzgl6MBbgWXHSn11MD/iyeTG7ugr4biU1W9ER78uUpvzlfBf01ulwlqXrMk62YGbV88RU7jHuxhnbR3ttgl/7eomtB8VSZXSlY5HD8x42lI0FFgVj5q9Y+yEzQCCk8pugnG32oWW5gAmVUHokuSTzDkOYUR/pvESXhTOm0VERjTdu0COnUJI/b/nFcjTjDQ2wH+/35ZynFg8z3YFlLtC1SUPDIEwvBdmAd6H8lHPKv6HyjdIo+0vWrn8dPD7ha6fPDte0s1GAzHo1DDp1Q/0Pru91v+mEUq5p6k2i1ey/nn+E8b+1Uv3VPpNZAFKuVSFkhD56p+TPFH0JEUKjr2qNErsGNP7QzGMxcch/6RJ2uHatv3wiGk7JUC2tss1UvItFFp+4Avw1cIO1fBWMF2KhUtkY5HelH3nKNCGnIhFEXhFiFXIwE0m6FD2QcJzMF6gfEIZvRtxO+3o3RB1FF6izYEJpmuBxtgMrMdtj9pwzP7roHIvmeNjpIqrdNRvPETHg2Nkmm42Xy/bBOS1v4fK489W4dl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

shmem_inode_acct_blocks(), shmem_recalc_inode(), and
shmem_add_to_page_cache() are used by shmem_alloc_and_add_folio(). This
functionality will also be used in the future by Live Update
Orchestrator (LUO) to recreate memfd files after a live update.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/internal.h |  6 ++++++
 mm/shmem.c    | 10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6b8ed2017743..991917a8ae23 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1535,6 +1535,12 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp);
+int shmem_inode_acct_blocks(struct inode *inode, long pages);
+void shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
diff --git a/mm/shmem.c b/mm/shmem.c
index d1e74f59cdba..4a616fe595e2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -219,7 +219,7 @@ static inline void shmem_unacct_blocks(unsigned long flags, long pages)
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
-static int shmem_inode_acct_blocks(struct inode *inode, long pages)
+int shmem_inode_acct_blocks(struct inode *inode, long pages)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -433,7 +433,7 @@ static void shmem_free_inode(struct super_block *sb, size_t freed_ispace)
  * But normally   info->alloced == inode->i_mapping->nrpages + info->swapped
  * So mm freed is info->alloced - (inode->i_mapping->nrpages + info->swapped)
  */
-static void shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
+void shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	long freed;
@@ -879,9 +879,9 @@ static void shmem_update_stats(struct folio *folio, int nr_pages)
 /*
  * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
-static int shmem_add_to_page_cache(struct folio *folio,
-				   struct address_space *mapping,
-				   pgoff_t index, void *expected, gfp_t gfp)
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	long nr = folio_nr_pages(folio);
-- 
2.50.0.727.gbf7dc18ff4-goog


