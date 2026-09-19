Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617BCC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E196B0096; Sat, 19 Sep 2026 06:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545696B0098; Sat, 19 Sep 2026 06:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B8E6B0099; Sat, 19 Sep 2026 06:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26AE86B0096
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:14:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 485BA160240
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:02 +0000 (UTC)
X-FDA: 85230101124.06.B697896
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 910CA18000B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qb07kYdo;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789812840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5qNiAXI1D4zp+UdMrJRqHPxfRH4HsdlYqcEtLOWJqM=;
	b=by6dj9KI7tFJa5lHUJLYWWkxoG10MdWnqGxARFb79SDA1qIndsPhYyz5km1wqIAJfXUSFj
	mpjtJm7ahjI5y7XbUpMimYCQFVbYzItE4NK3qm3cgWK0i42pFBhxppxL3XsBKBLO+kAc6m
	lcdGjorqV6i3tLdrI4LiHAn0eSKt8DY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789812840;
	b=FEqge01IuqU6BxpXMLpgrRezjIubi6JhfrmMx5pHd6yWsOvq5QvRtIhZACDBUfGWBpbPN4
	pRc+LBRR2+0nDKRL9ity9JAY78JSPqzm3BJ4NRgV/rjxHhQMIo3OjrwUxZrfWB+SKjd9CI
	G2wRmBQIxHYrgf4B1+fKCxoWEi9ZPRg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qb07kYdo;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC93E1C01;
	Sat, 19 Sep 2026 03:13:55 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83EB63F86F;
	Sat, 19 Sep 2026 03:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789812839; bh=PTZcXaFsAbyGmhHrgLdNOiGQw+Rh/lxM4LRL9V2hYS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qb07kYdouvddikX3vG/MtEKM4u0Sc3ipdedYhR2lw4ZqG8C16xOauqn/V/0XOrCHm
	 0bYELUvcb38DSoXytnbo9ZGg6g3qr+ZQ2azNfErg1g6mooyywqO1V03Kerwcq/fXzd
	 VbEGFGrBmUeUm1W1PcAOv1gtVceC5a9e7D4F7pTU=
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
Date: Sat, 19 Sep 2026 15:43:39 +0530
Message-ID: <20260919101343.1959572-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260919101343.1959572-1-anshuman.khandual@arm.com>
References: <20260919101343.1959572-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ca5oeykpyjk1uhs7i8xm7a3bqmu49mi7
X-Rspamd-Queue-Id: 910CA18000B
X-HE-Tag: 1789812840-134430
X-HE-Meta: U2FsdGVkX1/RkeummnJmYFDOpOx4CDBmxocgxxVHXQEgSs1LtZs7fzThgbhTl3J5ajN1z1VNxKHFQpqqnxJ+viiAv7OKpSBpRZEb022zSLR0wmEnShOW2+aJ9hrJtuwM7RQqLr3j/p2Zq0f7HNULoNTl5TKHn/l6Z3zNpo0EJfyQ+cRryoHNKzEBIFG8BM6ufJZxHGkuYgiY9sQdYzOHSSYJcaWL0IaO1dCx+V/VTKUaoGGxfmZJz/keWAKWROo2FJJrj2mdLiWKy7iuh1Erhkqjy+mNzKTP6VjyCNBdOCHtZgrxBFI4bciuIJm2jaE7ZC7q/Zq2Gkxh9xx94Q1VMJ/STb0qw4DodmWU/Zvm20tc3juRSaRYZ8W06WAc7NXy6zmwMZtZ8X9B8Y8vXac1OXvE0EDjntQOasXEKyBXZ8ecbVEWYCibFg7H6KBVobGjwDoqr9EFj03CJt+9+Q6rWG3o/CH8D9QZO+Vtk1Vr9c+bqIgXJT5yCVJPTjhX1ZuFCoAT4M4c7r0a1sP+CARgrHbSXX94vOjiKREKIwdXXNeqbNsyQqpgM0pIxbti8osIr87ecvhJOCFCnet9rmxzRMk4nXeBIDDsxcDCkFfEjipWFJjou9f1pRjWUJSleb9YCaUUpo8GuIUJ9HTEFbUcTiPWfg7YWmU5hf1wMYS6SaXyXieZDmFl0LsefGt6jWeMfNG/ToXyqylY4K4BMHeNRnlZkMM5Sg0Hg44nyteg9LFBv8psp6MTkm0basBRxnOGnqgxXdXKgop1nh3k1DfByggvdtbTxAmPAUo/bOldhFhJwjiBDHnRmjZMoy00o8Np31JxcAlbMslsjUy3F7xENAg9K+DWJbZlkTeBpUxRo98u+oSyzUeWfqhS79r30hR5BdCe84QbihtKBmGUurNWN9GnGfc3mncJeDPq+lt962luT+Xf0xdmj9GkXAsr/PWIxw27jkIBN0EjhQmoobK
 UE19sumy
 7eu23KQstzcyY2lvcDIDOoH43F0PVeB9xXYX41EI9D1S71guHA2QbQRZZ6cTg/cMMZYNhZvDopWuQ0gDAXz1/zxXfAKJFROJjNIHrRregua/4P1xWjVeUWBb6QnwVvwvafVajwBd+HIjRJCaH3OaU/YnvRRvFrkF3al+x+TjKFbaQl3HD/v4k5/SU6binrTidbbw9hVr7XIHoCRdXYlu1R3nmm+shH1jygdMb1I6CBX0LbniTqOZOtoFjtcZ2zR/8Pr+Ad83LKcN3UOXswhidi7UjLEsp4W4G7mQIJO9KwiwyDd5CznoF69G0xy43WtfUBScJCFE5KoHjj1YH+rXOf0/VPMSvZoV/NQh06kLZte+zITm2C/6BC8qkEV/lTaWpbC9ifsF+sbX//YpXhyGCAhlkDi9zPJM1gP+sXc3b+yo58mOL4vXDnQzYJ+CIGYSI5XOj
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
index 859ce7c7d4544..6aaa7f7ae5a0f 100644
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


