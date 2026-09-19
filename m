Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD38C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C8A6B009D; Sat, 19 Sep 2026 06:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D586B009E; Sat, 19 Sep 2026 06:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC326B009F; Sat, 19 Sep 2026 06:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7B476B009D
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:14:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA17D1201F9
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:09 +0000 (UTC)
X-FDA: 85230101418.24.D4876BE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00886120006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="XX6/NDAw";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789812848;
	b=yZ22QFNgVmUW9TrnrRvfuyJDhBbQMHONuYwiwIiyBE3IqyDbzl0BKFm5PIbanPMKJ+ml4w
	INi9/ol6NnS/e2LJWO6Lgd0z6fFcwbGnwhEMDFuCq7XhO0Cubh4MCxeqwpMFnAPhmTMnY3
	0JBCAsFQ/JVditwOBZIdqpYTnRQ2t1w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="XX6/NDAw";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789812848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUiNd9OaEvGEJ+YgIs9Irokn+O0nU0DeOlxuZm4FoHo=;
	b=WGkXYHSSWgeGldug6VRMV5qgKUAf7Meh1dA6pVavBZDKofeMYVLOb2l7Jif0qOuOouxmGb
	qxTygvjpQjTPN0L/VKhijPcYGtmL0nXqZTmKc7GxtPG6AkFNAzJJhvHLGwlaCZnTfrpW0c
	ICVYIP8p2sfXT1Y0Zsumhz2IyLLjojk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C838B1C01;
	Sat, 19 Sep 2026 03:14:03 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92A993F86F;
	Sat, 19 Sep 2026 03:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789812847; bh=XcLwHk06QSGKe2Ods7V5zqX1zXNtJInI09P5mJmD2K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XX6/NDAwVyJ832z17R+nFbKhiduWP0ByxUEgdxTN+Vg/LKM1CIj8/4sjNw2TvoYKQ
	 zKWgo+2YIL739PlyJlnv2q2ljR6Q4fc30odhFfgmAH5Lblobsw5rzOzjE3C57ItZw/
	 iTEl6j5rsqVfCvX+KXlanFRj4eFY6FIR3fKz/VuU=
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
Subject: [PATCH 3/3] parisc/mm: Drop all pxdp_get()
Date: Sat, 19 Sep 2026 15:43:41 +0530
Message-ID: <20260919101343.1959572-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260919101343.1959572-1-anshuman.khandual@arm.com>
References: <20260919101343.1959572-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00886120006
X-Stat-Signature: 5e3g87grr589kkenwy9ktmh1pxt87pwc
X-HE-Tag: 1789812847-345575
X-HE-Meta: U2FsdGVkX1+Qa16ifdhucNyLO49K44h3eEjSXu35h/WtMinJTJT73T391KQ3h+IhLqJre9A4Y/rHCtixIplnTj6/owySNUKzDVFWb87r7uOokKE0C/MRsQFgyj70j1akHrVvoYYJdazHY7dmTiVqPDV+F0OWH+xtjGAOIv6IaO7csb8M3EAzgs+nMCRlT6YmxVXAhQFFsFX4TLEybzUn6E1q8Phr26mK51J2q/5NssUAQXpq2i2RmhUxYXRvrpyVh1Yw+EYvO1mru5vfFglrEUROeiREyr6NNq52weGYCfeXogKRlzGtr3xHq66azhmu/2PYtUZ//zwqtjwoNX6sQKC6PdHCPzZ56d/EGSPS0kVTgomhN91cy6OoE3yTJnJR7SQJ0t2XA9al6mq0B37nuDIky3SsKkB/yPtgh+5QsZS21JTbBoC/yB0liJCLiNRM5x7HtQs+cpuFrTmitA4LC4PU/weAaTMlRrUyI0LGlMsh/Mm9V0Zh1fgg65T8P9JEcpsNOh+kBioe5/M9Cf6zN+m+lpyQM9J1tWsq0WavO3cRs8NXc1TziBXqr4OoGVWyvnGxhqz2mpG36eaYRFS4MFjSS7c3A3lQ4N72ORXv+nQlTDBsOqThj8ogF7ZrU6ysplSAhVcGFk7COcAHJ6FuLba5tyHi5j4n5wN9CWM4ZYRfpcahh/azqN/Fmn9+uEE8KEPtf+2WZSQOS7pqKqVateDerZrwd5JetaJjfRwsMFDtfqDcCKrMBYYzKx3f1d2f6BBrrSwbQP5Q0/Omd0qplDS735KUn7p+uvexUu7T9l8qamz8cogo7RcZtffwS1bdjQz7oMfp1Ku3EIaX8Mzpm1AHd/eKKlxU/TOarLXBXjSey0nB2zCQokMAH7N+W3sKDMQ9Ir5U10noIisC9oDIFjxmXDfLZraC/L7uZ0q53pBdzPVddiPh6fSMPH5e4zHkArrJJVANDXY/+xMECFv
 rk2W2XMY
 OzdsfakEDLXRA0bbxq3kGJHDDDRq7J1I6lro/NaFwCwuJgOcfjMHjebhfn0Y2csQ0FMYTCQPsrqz/PdyYbiVFmUhspib3hXTdeVd3qHGmZOLxrLIjMQU5Be1hwRuPmoDlN15QhpBnw53Y70zOpO4YQuslaDeh/Sfycl2FapKe6RySansHPmON7Q+I8MozPlKq7T9O/lp/Nx/l1HkgWh9l5S+1OQPotLney/4iXNusLf/IVTMNqLAqmoPMTOeo2GkPCRfRfGKCBrpAL9nkowBx5sobouIRc8Z7ippBpkXgTCFoL65L8vD0FnsBaChpwgBOizW/jTUs8bN8Xf/EopOcB5tb44fvda6fu2Jkw1gPwaWMGox6vQJJBSazNHL35c2Bi2f/UwYeG7B7LVZXDuNAxL32amaf7l5tS4mF9oT1rofZIVwZhhrjGUuMxE8SMM6OTIUOd89DIHs9Wfdn/FOJoJEe4u11nhszzXN9tVM7kCH5sETJ4uEcQh9vMAU2ORAF3TOp21p1wWKnzA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current platform specific pxdp_get() helpers are exact same as the default
ones defined in the generic MM header (include/linux/pgtable.h) thus making
them redundant. Move functions that are now depending on generic helpers to
avoid build failure.

Cc: “James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/parisc/include/asm/pgtable.h | 20 +-------------------
 arch/parisc/mm/init.c             | 13 +++++++++++++
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 467b8547ac8bf..975aa283b4c13 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -432,25 +432,7 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
-static inline pte_t ptep_get(pte_t *ptep)
-{
-	return READ_ONCE(*ptep);
-}
-#define ptep_get ptep_get
-
-static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
-{
-	pte_t pte;
-
-	pte = ptep_get(ptep);
-	if (!pte_young(pte)) {
-		return false;
-	}
-	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
-	return true;
-}
-
+bool ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 bool ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index be3380c9bcdae..3da7d8def9435 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -992,3 +992,16 @@ struct execmem_info __init *execmem_arch_setup(void)
 	return &execmem_info;
 }
 #endif /* CONFIG_EXECMEM */
+
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+			       unsigned long addr, pte_t *ptep)
+{
+	pte_t pte;
+
+	pte = ptep_get(ptep);
+	if (!pte_young(pte))
+		return false;
+
+	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
+	return true;
+}
-- 
2.43.0


