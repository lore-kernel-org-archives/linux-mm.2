Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F12EE57CE
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 03:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9F876B0088; Tue, 30 Dec 2025 22:00:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F846B008A; Tue, 30 Dec 2025 22:00:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7336B008C; Tue, 30 Dec 2025 22:00:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B18FA6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:00:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C70D16047A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 03:00:43 +0000 (UTC)
X-FDA: 84278263566.16.03470E1
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D7A0180019
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 03:00:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PBUtussQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767150041; a=rsa-sha256;
	cv=none;
	b=j/cwsRfbi30kt2PBsyi8BxJpGeNWDMW3thxdJBBn5Si8gO5t1SRBCcUEQasQeOJhX2Pviu
	o7fLyGpclpAib9nmXJEDbV0fKDAHdLHO77N0CoJlgzUd/TDVuOCdwIPNUhyqGooZSuNJH/
	cPHY2Fwxw1e+/L32hVG6zR/gFzX92Pc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PBUtussQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767150041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=MMZvWbbIBBmy2hVTByTqVU/28wHL8fmh5GRIKAADEPk=;
	b=1tJOsBqGBbr/zdQMjYv3hyWzPMY/gQwoBPXgaVcKvjhUMgI0VTKhMP7WjQGbc3Y00zexVC
	bXQ46GEfSqaBhLBnP5FJWOYxdtg3bwFgEXRTLfmFo//BY3WKlFELNYpUfRuaE4hIdxrSae
	4g7tz8GG5vyZm+ev4QPMbDDf/1tr/1I=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b8018eba13cso1623288766b.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767150040; x=1767754840; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMZvWbbIBBmy2hVTByTqVU/28wHL8fmh5GRIKAADEPk=;
        b=PBUtussQzO3gylduDSCBCWWrOpBg53mun8CbHEZvnZ+LTxWRpH6U/2dT+ou5sUQ6vu
         mvEE5dZzsgWfZUb427QUUvxwwS8OsMJLZQjm8fhKv0rb9Xl3aCFwRleEmaRzkSxaX6Ma
         JizHawHAd4LhTV4wGEzAzdFygMvMdl82/qZlcik8cn/waQBmv6yk7fws1hBuDYOowIz3
         Y7aB2K/AeSDX9056yxLg+yxwDI8PX8jF5adifI53ZozHMPAh5slNH/IBygHGQhFHXSKU
         eE6VfBrlbOuBt5EWmv+4MxbFdV9eFvwIrxnY3R95SG46qpkKDb8jeKvxby1f9MMXhKBW
         8E7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767150040; x=1767754840;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MMZvWbbIBBmy2hVTByTqVU/28wHL8fmh5GRIKAADEPk=;
        b=QC0U0v/vEGhUVwWxIxtKRJpP9CPkautaZiQBPTQ+AdlYUn2T+V6Ya9TsrN8OPPMtcr
         NI6hUzLjulm8QU59Jg/y1HBbu97g3o60vIPkhprEF1pLmMBXIt8rP/rEvq6yK1e5mzMz
         zpEb4/XHYM1FBdUz1r1A7x6J6HP/bS2nQZ647HL+fD69giiKYgsW31jnW9Td1oPTpMew
         McibL6a3PCR+PDPEKDJhzBn8yUHZgp8gWPyS3cJWm5UrHaKwILDLbmT3EP2jVapxdhGW
         +fRPCJjuKk5p02BrT/0/aW6E1ksIHQbIO+wAYsg/65EwrkOU4aMPvPGG+LLaGSjYwlgc
         3twg==
X-Forwarded-Encrypted: i=1; AJvYcCWJwLZ4ZTArdaGjIi+ABG7yJfyl5D0jLpisMBDtZtPpgN/qgBqTPzbK7TeS2UyBJjgnRtjhecnYmQ==@kvack.org
X-Gm-Message-State: AOJu0YxA85FCNYswZxZlsz50ja+oaLK5zJzmHl4C5HKE1xx/gIxD3kNx
	TE1YLfqk9WiOnfIWgrXWl+5C1K86jzjr+y4ttGSLuok/ILU/cb7n+l/I
X-Gm-Gg: AY/fxX7Qhon14mgXOqgjkFElRYzJrncLdrxbzXKbXC8Wc1b9Emr49Yi8Easfs4pKhDD
	w8jZqHODW5nlXnS12h2QPzlvalJnnxtP7N1CnuKeb2SyZ7sf2u3/7gwdPsAlz2m+ji7eFUmfQSc
	LnDPPo7iX5Fkb8I8b+OhBliuykCdkquX+ZdcrJHfHsbm/TlwNR/17K44bzowVOiDeDp4o52OXtF
	mzy3C/0Ka9YQwWN9G9lWDUufTqGJuRHqHxFjke8CnaPTP7p0Mt+Aljc/OdjsO8m+kc9x2SCZFCI
	IAeC8kE/laf5IvNqiIqtxFWknWOZJchNcbJqJ3dRWrSRrr6x1RuSVEjb91q/CsdI2jQwT2Ti0xr
	SWmUXiq8g6W3EfZXPxx/a02W7oI/sYpsSi1PNUBC9brhO9pgxjC9ZwmVMcKtqsdUgfY9AzAWt6t
	ZPN7G4Uw7Hqw==
X-Google-Smtp-Source: AGHT+IF8S0Qg+GmPFjjVlu2NlHvua7TCiotJg06/+N0u+q+yODVpwkPNVE7It1PwxVV5gykBDT11FQ==
X-Received: by 2002:a17:907:78b:b0:b83:975:f8a5 with SMTP id a640c23a62f3a-b830976511cmr2325146266b.40.1767150039609;
        Tue, 30 Dec 2025 19:00:39 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037a6050dsm3865880566b.9.2025.12.30.19.00.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Dec 2025 19:00:39 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	akpm@linux-foundation.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	arnd@arndb.de
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH] mm/mmu_gather: remove @delay_remap of __tlb_remove_page_size()
Date: Wed, 31 Dec 2025 03:00:26 +0000
Message-Id: <20251231030026.15938-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D7A0180019
X-Rspamd-Server: rspam10
X-Stat-Signature: 74a48p969afcryh93qzxqfnjrkhrcuna
X-HE-Tag: 1767150041-587544
X-HE-Meta: U2FsdGVkX18aTklsFFbacaLfAj1/VKHPIG/VdcHNpfRuv6gKxkZ0Gs/C/JiOBDp9D6XYvt0kSicKNnRTnsXVfeNgudiyUIU8cGwTqY0hnDUbQJwSr5AF1QP1XXLDQjR5pKQUKStfjx2HmFGSNmlN5CkRjtjW0x0ieymk8PmnadWV4Hinjh9aTCRM1xGZFn0LS0poXPrOoS4UXyBFGmnAyCYDZJOHW6yUIyBuXzQqPGr8zkDiZrkJ06aShLP9aXqY0TUWRuzuuYa2tGPIJzQbOXulgo+2MsKezR3CZF2Iqa9iaogV7vD5yD71MZv23PiCJVXxXqSv73Fctvb/+s4x359vU5Tj0XPyzeukhw7fNxOnH07LL/+MwhMc5F+Ke20GOOuRH+EkpzDgALr9P2FC0Cy3kBsh0YjX1VagxRZI/U/rIvcu3DJ/IOc5wSyPtaaN16aaies3s3xGF0ZBwagVz8uousOjAIXJrjag7Zf86zGO4KeRrnakp6s6IxY4H8VWv+gzhclxISYxgVH5rPyT9aEuF+lW6dZFmg4zUAuRhbc8cBdEdtrfS6Hd9OIqjlpm6rwPZygtsrp3uOpeJElAnPYZFppJRRwiLemNCs/L0mT0HujTUcnWnbTlpSm/hu/RKZUQO0bbDx4I0454u71eKCflVQMyriDrKE+JZyNd1kIRKlUOAu9DlKVN7wCNlf8y+rpo7K98BPMnoN1TX4pqcR4uHfyMmp8lvROFbu+cyIfLTlYfI7vLAkhiGZdnZAafJI3yXFSYbkYeZNgSKWLjcqZ9EBOPBHdfT6kC2OqKXu5NfZ2s8/wqJplYCDb99iGIW+tI/NgTd815GnYUJ/2le9VzNiPc+iHhYjpDDUnshFyOjqBIvG/5qDnw4L6hDrvM5SuvaXKca1M8Fxy1JQoJqNXtEx7lCHhUDixNYbjRWOT43j+PqotTFewWM0Qb6h2tlKIdRTjl325PvsYbxqz
 1PLIOUPi
 7J7zdycgmHAU5EEHtfp2rPXqAhcuTTce5+igKMloSb/6/Kpm30RKt1t+OC8iC7lADf36XReZ1K1lVcIl6Xu6kBUXaToz0T1CLiBql7+Ci4vyAWJL5lHDfWlq5Q1MF+MDDK83Uy3F2WjnUjFnBcnK87OsZOIWKCt9kidU8/XJWTifZs2Osl8W/BiOof3VSDOstjX+eCUaJmpafb6WINohaQopRDHrIalTaVYkokZE2vJuc+GUb7kpvuoBpUVgBfDJnFxFe6PI3Xl/tFX77uFFrdxPDNGeHk8BLUyQZumISdB/z+C184DaXyiovrinftp5GkRNf7b8uXxshQkGpy0Gfce7u35Xq11YJg0uVUeWF+FJ9FxwV45rNv20nDsCXLy4x9rMml9/gT3JJQAbdjc6hY3TrSHPtEG0omL++im4YXxfz4GLtkAV2q7+f3CYnXLzrt37/u1dTqEAFK7Wa9YpI4Iyda/A327ZTWBEPh9YDAjQIeCqsEwszKMk8YOusSnaXaLSFWLghEcqYRPBrkrIkN4atz7lt7XG/JENcb+3xa6lo5qkNU86BuIZZ+4z2AQGLFv5CRY5AnRd9h0/aoTSZvEZiVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Functioin __tlb_remove_page_size() is only used in
tlb_remove_page_size() with @delay_remap set to false and it is passed
directly to __tlb_remove_folio_pages_size().

Remove @delay_remap of __tlb_remove_page_size() and call
__tlb_remove_folio_pages_size() with false @delay_remap.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
---
 arch/s390/include/asm/tlb.h | 6 ++----
 include/asm-generic/tlb.h   | 5 ++---
 mm/mmu_gather.c             | 5 ++---
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 1e50f6f1ad9d..0b7b4df94b24 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -24,7 +24,7 @@
 
 static inline void tlb_flush(struct mmu_gather *tlb);
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-		struct page *page, bool delay_rmap, int page_size);
+		struct page *page, int page_size);
 static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 		struct page *page, unsigned int nr_pages, bool delay_rmap);
 
@@ -46,10 +46,8 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
  * s390 doesn't delay rmap removal.
  */
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-		struct page *page, bool delay_rmap, int page_size)
+		struct page *page, int page_size)
 {
-	VM_WARN_ON_ONCE(delay_rmap);
-
 	free_folio_and_swap_cache(page_folio(page));
 	return false;
 }
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4d679d2a206b..3975f7d11553 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -287,8 +287,7 @@ struct mmu_gather_batch {
  */
 #define MAX_GATHER_BATCH_COUNT	(10000UL/MAX_GATHER_BATCH)
 
-extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
-		bool delay_rmap, int page_size);
+extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size);
 bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 		unsigned int nr_pages, bool delay_rmap);
 
@@ -510,7 +509,7 @@ static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
-	if (__tlb_remove_page_size(tlb, page, false, page_size))
+	if (__tlb_remove_page_size(tlb, page, page_size))
 		tlb_flush_mmu(tlb);
 }
 
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7468ec388455..2faa23d7f8d4 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -210,10 +210,9 @@ bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 					     PAGE_SIZE);
 }
 
-bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
-		bool delay_rmap, int page_size)
+bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size)
 {
-	return __tlb_remove_folio_pages_size(tlb, page, 1, delay_rmap, page_size);
+	return __tlb_remove_folio_pages_size(tlb, page, 1, false, page_size);
 }
 
 #endif /* MMU_GATHER_NO_GATHER */
-- 
2.34.1


