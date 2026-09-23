Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B95C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 04:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39B856B008A; Wed, 23 Sep 2026 00:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3733A6B008C; Wed, 23 Sep 2026 00:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289936B0092; Wed, 23 Sep 2026 00:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04CF56B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:32:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E91DFA6A6D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:41 +0000 (UTC)
X-FDA: 85243756122.03.D32F8A2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 203B5C0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ndI1uH6e;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790137960;
	b=g/h7Pr93qGjv8QukTQrBXbJKhLNliSicT4YDBamBavwmbUkpjtp5LgUJibovR8v+JpDqAA
	CYXpNllBJsRlD6nx1Mmo0OfYK1yx1/o9kdBXSG49RAyAy4qu7FQgs7SLGWGYE1KZudN6Cz
	ubBw/MluyM7i3iW7R5NT9B0+ZK+qZ/U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ndI1uH6e;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790137960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVtBSpG0AuE1TlmMVdK0+NYcIZhfhSY3hC2WGzRV44w=;
	b=mlyiPYP+OJ6jT6j+Yjtf3tLIdptYr2h4VbhCvAI+inx1eoVui0ZRsRBJ69SYzBGneDip9x
	nQeGGs9Y1EELWzmXS6dsd7+L7rJx9iwmJ9F2EqZbmeCwgYHJNO28lL8tDAhUa8fFhjnH1o
	/rJuVCOORQv22jlfsXU+9yTZhOA16RI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 966901A25;
	Tue, 22 Sep 2026 21:32:35 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 533DA3F86C;
	Tue, 22 Sep 2026 21:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790137959; bh=kwgxuuHKPugXD4uaHhdRyKDvpmpMLLZwxJxp7qromY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndI1uH6ezC/RE24KftyOi+TwxAWCteFIfAIE2ap3B/odxTDXRFbfnm27Hcp16vhSK
	 zm8CRYHRLsE/0Mex87/JrGOwfOSvKmiGKWGnGANtSggUbLXGnL3eVayi0moOi+YPSl
	 TI0n9+OMf+k5CQjCNZx8mHjCTCn7JeDMOcEHID/Q=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Helge Deller <deller@gmx.de>,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] s390/mm: Drop all pxdp_get()
Date: Wed, 23 Sep 2026 10:02:20 +0530
Message-ID: <20260923043226.331880-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260923043226.331880-1-anshuman.khandual@arm.com>
References: <20260923043226.331880-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: tm8ffywcqmf3fhqhm8y3gtcgd1oa8gww
X-Rspam-User: 
X-Rspamd-Queue-Id: 203B5C0003
X-HE-Tag: 1790137959-277144
X-HE-Meta: U2FsdGVkX1+5hFvdtJUVAuOD/x4cdlRQi/f6HP8ORqqI+ddJS/Fi+SIit4f8zTN+U6rMv5FH9Q0KFh17n1gg111lblnHgEAoCpo9Us4wnfvFC/nFUWGjqslSD++G9DsI8QR126zERI0hr3GfMz8/xgGoGNmF9ljTscSIuLT8BvSyxOh9bIGpfBOrmO56d/P2ztDVUSx/Z7RJs3+xd6+TspyrEMVErpv4YPkCSsOuAp/AOUNRtnHb8wo9M3UzFrtA1KRZXNj1843pdVytS3kwO9HnyFH8Gi60yjqVQHVEBoADNR0Ml+tNyMAM+z2qaNuPQjciRBKGjyy1+X4JSDMIn3fW3+URs3vHyOJ9Uli5Psl4oPxP8o/TmTd6A4wSmZBrZZ1uyq4qgp+CvQ3etlYjqyxeztVvFmDogL2ds/qagesEULffYN0vp21dw7ySONj287fdWgGVSKD3oMeZLVE1eaRSWtPpw/oairjE+2A7YizNTIivtXNfByiu5XEQ2FlOzWD8wMN3iomo42Doe1uNRqK08VuNQEj7Xsw1d4wARMiC9zyZGYuC/AU9ZhokAld65PubS+Qn+cIJ7P09vsz9OICCZV0XYPOL6dgNecy0322S1EHe7vYXDFozblaI0Lb+w1THhlVlBjI+70u9Oumr9XLa8PXWZG0pPhSbqHq0Ds/Opn932ViJ1TjHpHfq8gwi9WWndkkGCZDqNHJ6dfrERVcccixONVEilWHGLg8bX4CBPrznIEryTl1hBVrFEaAz72JvToxRsYZQUH0CYgV+Bx2efN3lwM8nVOEITZcBwheYtTe7M/2W56pt03JfZB8VTZC117X2+yOWrKWO7LasD3EVlvpFe0wTqQZqBe5oqVpcINMqG/RFA0bCHuzjidRxKjVWBEAiakzafD8Gt2Fmwux98Wj3h2VlV2CuQdwpdvrRd811fe5xBv0YpEQuL1Eeub28UsUP3mePqWIAs48
 faP59b+k
 pHH3XO9Jj1XfyTbkI1rshseO6FdI2Jaid2r8B3ozCHsGBiHR8y8BA7pQ3yKaQtibCYQSNZRickljovfq8bsAIWophz5oROLiQI+9qTd5Ry5gbiiXqGA2g4QPJFPy6xujZ6Itl/V75ftydhIvL7mn/OrzT8Xx11kKMc2+S/l0iaYL8neAtNi76LKP6VvDFdcz0YSec0iC6f1sL8f8J3HRmLgZqv3fCIloOS290FZOTikNPSTLdcxggG+1iugtWGsnuxeZNWolxDmf6gDNSks6EPNxfODxEsO1rJmZLTWelxX/os36Geq3wgMgVVzsZX2qReNX5EiLphjzx9M5BIpp0SRKzk7LPIADIoctZ2V/7acy8WTClBgIPd4kit4O3OySmLhzctwC3NeUCVsc7F2mMXJv0b6yLNNWVGJHItcHBOAJZQGlMGjuzztXuO7EuNLzUVpo9HtD12UioFaKEsZGiP805BG0D382xL34AZmNbrGz7m2/0fsy1SOPKZjCNeM4z4mCo8TD4XYNizWg3ncEinecBV9BhuxCEaM6eutJoRMaBDMCJORcq0LUe4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current platform specific pxdp_get() helpers are exact same as the default
ones defined in the generic MM header (include/linux/pgtable.h) thus making
them redundant. Just add required forward declarations.

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/s390/include/asm/pgtable.h | 35 +++++----------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index e882663a58e77..0a0b0ec42b624 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -25,6 +25,11 @@
 #include <asm/page.h>
 #include <asm/uv.h>
 
+static inline pte_t ptep_get(const pte_t *ptep);
+static inline pud_t pudp_get(const pud_t *pudp);
+static inline p4d_t p4dp_get(const p4d_t *p4dp);
+static inline pgd_t pgdp_get(const pgd_t *pgdp);
+
 extern pgd_t swapper_pg_dir[];
 extern pgd_t invalid_pg_dir[];
 extern void paging_init(void);
@@ -985,36 +990,6 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
 	WRITE_ONCE(*ptep, pte);
 }
 
-#define ptep_get ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
-{
-	return READ_ONCE(*ptep);
-}
-
-#define pmdp_get pmdp_get
-static inline pmd_t pmdp_get(pmd_t *pmdp)
-{
-	return READ_ONCE(*pmdp);
-}
-
-#define pudp_get pudp_get
-static inline pud_t pudp_get(pud_t *pudp)
-{
-	return READ_ONCE(*pudp);
-}
-
-#define p4dp_get p4dp_get
-static inline p4d_t p4dp_get(p4d_t *p4dp)
-{
-	return READ_ONCE(*p4dp);
-}
-
-#define pgdp_get pgdp_get
-static inline pgd_t pgdp_get(pgd_t *pgdp)
-{
-	return READ_ONCE(*pgdp);
-}
-
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	set_pte(ptep, __pte(_PAGE_INVALID));
-- 
2.43.0


