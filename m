Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A4F3CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841468E002B; Mon,  1 Sep 2025 05:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B36E8E0002; Mon,  1 Sep 2025 05:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A318E002B; Mon,  1 Sep 2025 05:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53BB18E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E4D916072D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:46 +0000 (UTC)
X-FDA: 83840133972.15.3EA1D60
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2431240008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=c7Ue1YeB;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g27oviGyH1E7poP48wwMPEGWPzCs6iGckjbF7ofuUGI=;
	b=pCOKLubZXdryyMS74eg9e78NWJS95ZaFPnb6I8TLIV3/51jL0c1vrX3ccU/PcinvByhRBR
	Q/32s4incHLJgLF9fYu7eYHTWEcH+PdRbDkRcKAMSTsV5bYUzWvayYqcYFly/8Al9UmYZ6
	4lUHZu3emBfKw3XrXCV9Ae1Vgz7fkik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718384; a=rsa-sha256;
	cv=none;
	b=tE4h0fC6YelbbsJDPJOE1vkez4FV34zITyWEcfcBj10K6xifvWycq0aIRCMlZz6t79iosB
	i9HmRN+IFVRtvg0aYfZEZxH5d2HKf4qwPgq0bT+G5EQGll8etq2Yc0r6HOTXZ+1VFZZv2L
	DRS7q+Xs3rNNEYNVypeZns95OCeY1qI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=c7Ue1YeB;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7ace3baso118927266b.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718382; x=1757323182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g27oviGyH1E7poP48wwMPEGWPzCs6iGckjbF7ofuUGI=;
        b=c7Ue1YeBBdmhhmOsVv/b3Fqbn9nMu8YpOPhp1/jv5gA2XvZqg7msANRPbJ3BIo/0Ni
         T2Mx+cto2VSvCovTE1NiXx0k9P+nuugKNwfIWV9YM8+hU+97J0grpQzJkry8KuzaTeiM
         D4OrhBSzAca7K1gxZ5PSt/35eq2OymC7uoPwy400qPBbaRbu1XF46J/W0SgzzAt2kSDf
         K+6kzONSoKLcJ166ud1PgoqJdWxLV/28ydPXvRPiSfXX6C9ByAjADE4jcQkaGJ6WRRyn
         +b/5YgbyILQZ09onY6QKHbIevUQkxqbDda2ZL9zsXfqPLcWr5zEl8TD9NMvteJTOfRev
         6MIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718383; x=1757323183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g27oviGyH1E7poP48wwMPEGWPzCs6iGckjbF7ofuUGI=;
        b=J7Y0ogMGu3YKaObwd0s8TE/0DZY2X5zV23OCwDusbLV1inXAdjGPqCisob8MqpmcyB
         DT6jJ50gl8Ir9K950/gEL5ZpS0SICCML92XVZAZyh4RDGE9Ioz5CLrKYwWHjTZtT/FTG
         aD6oiWXcD2BLXVGKNgGxagueuioGks7mrnE5tFFNil7DOm07+idvY95NNBJFYb7KwvzF
         jbzwrRzlWvomTmSIbwQSfYxrwZvmB/qK8bbDFGrj6f8tV0ljP1bkAr10/Vs9KkPzkxg+
         gVYqCsgCVrQiZJ/sqnkuDsMdyckFEGKJH0PDkuqkxf6Igb6NyAMzwNkSVPge7OElxgjI
         J9LQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnMWnMQy6TP2XauhKdCLBJ+a78w8msuelpU+5QgvieTu86JgpJMWpdyK7hm3ptNfwUtpS3hDH/AQ==@kvack.org
X-Gm-Message-State: AOJu0YzqrsmIFjqil7CVr0KQr/Ih87cRtQkujrpTMOXsFEm5sKn3ghHU
	oykBfFjBybbKZQ30zQ0fb1O4PrguEY1IilFhG2itle2MvhbX8az5hZgipKCvMzsmVvI=
X-Gm-Gg: ASbGncstS/ZQRKv2b4CsqZm5M6f8u3VZXgCw/peRFYM80Tz734NLejgtqWdmOyJKIEc
	sOesQ5ei4y9XC/Xj7BYXEwh2k355KzIuILzOOqfcCcye5XevX6bidfcA6wsKsiATL1EOlwKJmJq
	xwPhlIjO/aCjIWeqg1P5wkdcqxN+j5a1pu8wRTcDc3sVL7F3PN4HdmTb3qmw5EhA63ebMl20pIM
	UZCwgFEClZJaRGgxABgCpj1+f2ai1WeXxhsP/xPAqx9J+vhzA/CtMtt23PXKlyhByTgRb+7J+DD
	mDNupP3gusVsO18dTELS7aoEoc4bqZ6/s/NkzJ8Ujlvl0Igm6aQFq3Kd0SDTR8alsx6Ie7Keew7
	9pV/JgkZ/GOrU6HsMEnHMqRzrwr9kRH0B+ViJSAPsbP99oZXr0KAIVglNLdD42MWj+WhB91ybhI
	ZTZP2NcpK3mGWVdMnEz+z+3244bG36Lbybvw9EPBMcMok=
X-Google-Smtp-Source: AGHT+IE/NGoKVl7E/tUqxPYYVhGW9MLa5x5g5kYKEMsRq2hhu2ZhegH9KRzjvzCYerPMCTr/toceTQ==
X-Received: by 2002:a17:907:86a4:b0:b04:3888:5a5b with SMTP id a640c23a62f3a-b04388890admr126924566b.42.1756718382390;
        Mon, 01 Sep 2025 02:19:42 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:42 -0700 (PDT)
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
Subject: [PATCH v4 10/12] mm/mm_inline: add const to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:13 +0200
Message-ID: <20250901091916.3002082-11-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2431240008
X-Stat-Signature: 3tg5azr5qtaaye688ur5uz7qynfyhaw6
X-HE-Tag: 1756718383-911360
X-HE-Meta: U2FsdGVkX194VQnWesBlStDIg1krHvL8i3nEW10V/87VJPibAUDgn0g8OD35ELcG7N52wJBUhVRhsJgvLCdUmYSUDDxZAv9QLWCnxVSXiCHT/esIas06Qy+TAbC3AWtGr8KVhlbQcU6lACMutfEuvObdsAsTf+FbCi8Hiw3fP+cBgOK2yA9gC9TFD5fEdjZwGomEm4jieYQx8WbuJ2w3R+f4DOStOzu2waOmlBN9rkDvn+v3Pq/fPT46c1QzGO/gv0gfA72HyAM4/MCKvIVoFuUv+nYxENtZeOeqKeIGwV4tW9LG1ZztTWbiawN56gpDMJtURa/A0VN7hu0OZq6pV0uJAafeM5/E9aQPdbOuEnC7TECHklEOCcdHN3tw8DbuVww6o9Ay9PAcX+O6qnrLf560/yG9GtXYadkh0OjNoMCu7/VCeOdx3ivCJUCF7aY53x1sjT+D0KyjEscaA7Z7BD5YYVV0VLmdV2h329Oz76JaIfHemureYrpkvLekMSnDl2NdoCgDLoxyfUXOIeS2K/29+2JcOGfdSi1wTQpEtvhASzNrqbVCOp8vXK1CKIcUOkzQCnKfpDQ2H3Hgcwj/mRFxypfnJfMpH8tS0h7nJiVDqEE8tuAdNbAUkTgC9ZipPMZ2Nkod2HbLsjyASFU2+0wdywpiss09KjobYpoVGCekITNuVpip2yl1kIKPUqymENSITvU8NPeaZtYt2YwMeugxcuwXYdAw98oUpOlxFf0bxU0ns/4Az8vC6xrqDk0safkQ7K0ka4ex8RFBFirMGYSt3Bh5pPr66O5bnjdT6c+fkSl+S/sVCDZVmhppJ/abl4Itgmy3ecpvQhx3cxTb/iOi47mvABt1cvcH/f01eASokk/hsVkpesbSf4PptFMyNBWnNnReHUW9Ltkr1VpF7O0GjLyzGhoxl1VMBTkLkoxkvmlpxo5KgpWopQZtnd4NesxT2OK9hsDtzi4O2uN
 S5bdY0fI
 n3ztLhE64YEy/iYG9zxLa2BXzkpqhPmD+AyecroiwE0+1FuVA4Qvs9V+AR9lHx1nLOPlAxlCr/xWhXBm11G+Y0aIK5tA7+jD8Wz49BR5M1CKzWZX6BK1+rttNmSlUGzySxpwSUoJgOI7n9LKmsZk1v2XPiDomOYiwlX/kqN+YN3DflgUdT4e/7F41lhq3SAJ5JK1l/ago1sbqzINtTcDlbUJs9Ty/COs70Sko6u/xr5HKSsOVxcD8eIdmUSUmXS7EF1EuT3RPcCCP5AMNWZ/i9kvD+zRsRwrqNVEcydbwS1lWfHllFPOed/gIpg/nl/qNXEpyAMKomJblTOX64L5qHL28bP6Hgyj/PBqbtTV0D18PE6ejnwh/MHt/MRJeLTqXmO2/ZjZ2nvhHFtFagBEWTo0RLtDQjZrx55LQ3GbanafebHVEigigJlqt9zRzrgx1mYkG8+ob/cLvdcg8K4uH6CNoigwfReyGz4eDkEd3LGDb+RM6X43Mdlda5Q2ZIYLBc3I4
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

This patch adds const qualifiers to folio, lruvec, mm_struct, and
vm_area_struct pointer parameters in mm_inline.h functions that do not
modify the referenced memory, improving type safety and enabling compiler
optimizations.

Functions improved:
- folio_is_file_lru()
- folio_lru_list()
- folio_lru_refs()
- folio_lru_gen()
- lru_gen_is_active()
- lru_gen_folio_seq()
- folio_migrate_refs()
- mm_tlb_flush_pending()
- mm_tlb_flush_nested()
- vma_has_recency()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm_inline.h | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 150302b4a905..8c4f6f95ba9f 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -25,7 +25,7 @@
  * 0 if @folio is a normal anonymous folio, a tmpfs folio or otherwise
  * ram or swap backed folio.
  */
-static inline int folio_is_file_lru(struct folio *folio)
+static inline int folio_is_file_lru(const struct folio *const folio)
 {
 	return !folio_test_swapbacked(folio);
 }
@@ -84,7 +84,7 @@ static __always_inline void __folio_clear_lru_flags(struct folio *folio)
  * Return: The LRU list a folio should be on, as an index
  * into the array of LRU lists.
  */
-static __always_inline enum lru_list folio_lru_list(struct folio *folio)
+static __always_inline enum lru_list folio_lru_list(const struct folio *const folio)
 {
 	enum lru_list lru;
 
@@ -141,7 +141,7 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(struct folio *folio)
+static inline int folio_lru_refs(const struct folio *const folio)
 {
 	unsigned long flags = READ_ONCE(folio->flags.f);
 
@@ -154,14 +154,14 @@ static inline int folio_lru_refs(struct folio *folio)
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
 }
 
-static inline int folio_lru_gen(struct folio *folio)
+static inline int folio_lru_gen(const struct folio *folio)
 {
 	unsigned long flags = READ_ONCE(folio->flags.f);
 
 	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 }
 
-static inline bool lru_gen_is_active(struct lruvec *lruvec, int gen)
+static inline bool lru_gen_is_active(const struct lruvec *const lruvec, const int gen)
 {
 	unsigned long max_seq = lruvec->lrugen.max_seq;
 
@@ -217,12 +217,13 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_is_active(lruvec, new_gen));
 }
 
-static inline unsigned long lru_gen_folio_seq(struct lruvec *lruvec, struct folio *folio,
+static inline unsigned long lru_gen_folio_seq(const struct lruvec *const lruvec,
+					      const struct folio *const folio,
 					      bool reclaiming)
 {
 	int gen;
 	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	/*
 	 * +-----------------------------------+-----------------------------------+
@@ -302,7 +303,8 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *const new,
+				      const struct folio *const old)
 {
 	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
 
@@ -330,7 +332,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
 
 }
@@ -508,7 +510,7 @@ static inline void dec_tlb_flush_pending(struct mm_struct *mm)
 	atomic_dec(&mm->tlb_flush_pending);
 }
 
-static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+static inline bool mm_tlb_flush_pending(const struct mm_struct *const mm)
 {
 	/*
 	 * Must be called after having acquired the PTL; orders against that
@@ -521,7 +523,7 @@ static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 	return atomic_read(&mm->tlb_flush_pending);
 }
 
-static inline bool mm_tlb_flush_nested(struct mm_struct *mm)
+static inline bool mm_tlb_flush_nested(const struct mm_struct *const mm)
 {
 	/*
 	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
@@ -605,7 +607,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static inline bool vma_has_recency(struct vm_area_struct *vma)
+static inline bool vma_has_recency(const struct vm_area_struct *const vma)
 {
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
 		return false;
-- 
2.47.2


