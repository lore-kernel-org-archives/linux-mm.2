Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 462F9C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 04:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34F86B0093; Wed, 23 Sep 2026 00:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDD86B0095; Wed, 23 Sep 2026 00:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF076B0096; Wed, 23 Sep 2026 00:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0F9C6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:32:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FEA51C3392
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:49 +0000 (UTC)
X-FDA: 85243756458.29.23A0E6A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE74F40006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TrnyWHp8;
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790137967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUiNd9OaEvGEJ+YgIs9Irokn+O0nU0DeOlxuZm4FoHo=;
	b=r4uw1lMCQem+vBCbdWDqkmyqry9f1YNiaGi0trctHqEXxUeYgO9jNO9wbODEh1Ku/MQJu+
	UAoO41HsWwfHYO3WJ3rVDIU5a/nMFFJe5JArwl5aNpBcA38iWbhjykIg6ZETQn5mpN3KYq
	xFlSsa2iuMyfc4v2Z0cVi91abnVqDw4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790137967;
	b=DzDaAqAX+ROVBhePDtpAFh0u7lN0WjGVpbkuxo6nkLAYyCUQnqSZ/0T6qjXrWUdk+5nZpC
	19vjH0c1jKktpbhZF1MDmSPR6RMS7NVe7nWIEe2iVw4IDPYWTPoNsM/YxfGYaBzgr0WPCh
	lxWkTa4kViAE+WRb1/e1nZjBp2M709A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TrnyWHp8;
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EB091A25;
	Tue, 22 Sep 2026 21:32:43 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 008213F86C;
	Tue, 22 Sep 2026 21:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790137966; bh=XcLwHk06QSGKe2Ods7V5zqX1zXNtJInI09P5mJmD2K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrnyWHp8RvqNfolAhCIU6/NudgDVmICu+gpFWOjR+r3KHpXHxMqW4Jj07bRhzLHZf
	 F4ZraoMVAyyaFdO3luR8ZZ31Sfq0zxo/4LQwmCjf29FdEBqwEM+W+ixM06swahUPU7
	 evVq2qWpOO0jeOHXXj26CgbU80Ek9KqU7Qp220HU=
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
Date: Wed, 23 Sep 2026 10:02:22 +0530
Message-ID: <20260923043226.331880-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260923043226.331880-1-anshuman.khandual@arm.com>
References: <20260923043226.331880-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE74F40006
X-Stat-Signature: xb6j4ry5i4uyqpai71x95fp16nyka3j8
X-Rspam-User: 
X-HE-Tag: 1790137967-164035
X-HE-Meta: U2FsdGVkX1/htK4PGLaBJ9Uws0a/1IpJbvC55B+0+dfSgAsKEUB7Asvdm2LjewdPTWyfsDxLxhK7alo+y01UTcH7WTO7RqCTubzcjlb91ppRgwEzkCSPhEEbhuVQ9lbJ5bQ9JncBj1uP9S4O63q0iETnb2YzbOJG8UqjX6TnL8f2D3N3ew1CAb1Z1wQuV2hs7/N2EeQkW9yF6tAxKePnoS8wlFRz5mEr80TBv+NV5oyf5s40RAV7k4xxsxh+31y8anVTzFvckcPoEh99XGB3JK3R65PDRRGOSbPY+zvaRmuotXg5316qn/CYOiHwcz2RTIxLRllPwjLW9qKGOQKuhkyqW18Kh+2LhTsBqJ0ekUmUA1+bBgvkts0/y5MNRLU9SwjhmLcvir5uxtlHwWSrvBsN2fmdEelG+OP9JMXXuV4UV3XmwrQ/KXXNiIDKatc69pcm0LwzSHZ4HSKEmnoz8YoCzF0zV0lYrTA7rBtW/+AhCfZdZPMBySVQS1suHE81mmYmtSH4Zgbn550Bpqo5thXxg+Mojz4JXG53nCQCHFCNNljSvGtHFu2y4htHOgIqjNA8gpZALLELHONFCwuRw0kI7o/LkP9xyzEASCTMCdhuTv0V2qhg/Qe05PDdtq/m9ZUPoM3rlRECXvFeH+0c3exE2UMH7D0lvMIHqooqXARJ92Z5xpVwzSrGnnHQFpnd77H4hTP7MgdiITYpF95r0fZfSNL1nD449wBbXcmm6rVHOdZig9ztqW/TAb67/IupUXU9ubdC2JsGyJCbkcFVFMPcDxa2XdshpP9ZufnINiyq1hNNGsan83JB19LoDFMmW+1rmoyrcRmoWzQJJFCpavEzLc7d2PEvJoN5iuyCu85q8iViNJ0pwoQxEa46DQDrKbA2k8ydv2dZVV11lheUfWNATtwMVVZWIRvNP1KsXg7zNn7IauLUliJBnYyGE6E0SNrdI+IIaOI3KCj7s8x
 GaOYhpot
 3nEOEn2LXRqOGPniOFa562nxIYqi0F5SrWiwAe9EcWzAgmWBRGc3Adn83QT0pBnxEIa8Q/6FlAuQNkrveLNmSrXESia+YXGPiG0Mqzj8o/H2PoxmhEncHsNTl37WYLygpgRmVxt1eFc1+e03WPPFeV8KYk7Rz2cmemk/djHJlJFVwIumu8gBV56YPlkIQ+feZy4lUqQAc39atEoUv2SDyFAcpV7PL1QID4m111DoXh9fITxpAW2Ml0QmtPdbdRCaF1WndAf+KHeLpY6IDH8RmGb3GngS3Oujj7aMSqcJAhmyXAhhVBeYIc+Puy1rTCWt63Ohn5fzGzlaVNfE53aBP50Alk+PIlM1AQMmEOmU8gxcSpiPWoU7ocgUvQyROIiPwEol8z1S4UGvZJPxGibNQDNdhh4e9P21r42VBz1uZdBWaGOfZaL80k+eVyS24stoAfoEa7biFQgIeDnkQkv7b20dmUt+96JlkpqZ9wegoE5P5C/iMPkE0SsSaKlgG50NnzMDnhn8pcKP6DuB6YVHL5QDneeMCdq+WCEpjp8tJQCtVIiEc9Vo4ZPY5qCYOqjTYUKK4Yu66p48njqOvnz8m1z8LR8SLTPsTzIW2eHAeD7Y2Dpzu6avAwbgQLiGMGPbevppJ
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


