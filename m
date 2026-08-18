Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DE6C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE436B08B7; Tue, 18 Aug 2026 00:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B82E6B08C1; Tue, 18 Aug 2026 00:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2586B08B7; Tue, 18 Aug 2026 00:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD976B08B7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:01:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C0D3120A40
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:00:59 +0000 (UTC)
X-FDA: 85113039438.04.353AA20
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7D3AA1C000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:00:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y9O89JQy;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025657;
	b=RJC6qjMxVtIlXdOVI+TgUgVswffbDU+Hw8kUByu+MFpx65yTkFYIjNJ00+W03/16/Ai8VR
	1aS1qVNoYmmp/cy9/8GkdBrXgRLTm7EnY/8ZviG9m6b0dvCjGS4KbhpOA+DPlmZA+7w2FD
	HQFP2VJdFekyi9m6BtJSPre2Q3D/GdM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y9O89JQy;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1goycZjc9fa7vdpkGr1s93sKilynT51Ho35yadE4IE=;
	b=cpmR4v4AUHjtfnlLjDoMecn2n6dD17sGVXESyH3hAjf8/BNa45kaUa2STtVaGUusYuAE/5
	p43h4mHf1/yf6mSt/LeIktEmodG4SoZmAVMk+bSrcdBKD1hgTYckQEdemsPRtPAvHuJscq
	NAt8ZqRGLMebQe/Di1tbb0wqw2uaQfY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F21B19F0;
	Mon, 17 Aug 2026 21:00:52 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CE443F66F;
	Mon, 17 Aug 2026 21:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787025656; bh=gvoumZ1mqXkMoeZql0lSWe/WgOn7RJynulYHo9T6RIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9O89JQyRqQ99Ip6I5SMUpHO4W28lwAqA2qQ+OKQSGxWJr89SaoR/wtggTE6HGy2w
	 HqMNRSDsvGkmDDhGrL3ogwDzNoudsgFh4VO3YmzItUimTXFbhBkwBOd2VWMP9W94UP
	 6KX+q/3TgiOZkxYB/5NzoHl/Y9RFVVAOm6h/P+14=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC V3 3/8] loongarch/mm: Stop using pte_ERROR()
Date: Tue, 18 Aug 2026 09:30:36 +0530
Message-ID: <20260818040041.1891769-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818040041.1891769-1-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D3AA1C000D
X-Rspam-User: 
X-Stat-Signature: t9wqp9sq843qdwsr1wqd3j9836x7893g
X-Rspamd-Server: rspam06
X-HE-Tag: 1787025657-618677
X-HE-Meta: U2FsdGVkX1///fBquKKe+SvYTFtw/fYp2IGWQV5ybrit1kQSOXgWEebz8V9HClY/HMkFjOR3skyGCsn8Z7YkPx7vDRjkBoG0jUK6CykUMkvF/4Elrse0JwaMDNsTDVdqP/+wQSQtqov6NbvKiP7DtlfOgVMTSDyvhil+jqNUMjq2IYpt3mrSmTyXsn4qxDKS4YuCaU5YAEZxAL2cvmk/dJAsjNmQbx8T/UnB6KnszTnQeMm+L183EzgMMFaCoTXntWAb9PHTCn9IdwyfeFluscmlisvG3YveKSS7tJ3k9P/jhevzF02LHKUkMK4zaPl5n3g9MKJubQ+UgDCKJQfWczFDXryVS9ljZZ+3jiZ0BadC2GOrJ+uH2gNkbbuTYYnQjWKdcbTOctCFHFNXBmJQCWjygKA+iwzfSrtbBhdhxhYSbwP9msnx8xqnh93cJ+50DkZg1E23Cpe+7V20rkP6+gu1WRL0yIjG+bmNM8S8fVKNOjdO+L5BZinZAmikCE6gfSPw/vJvUOB/mO+AlksqH1p3LQ/+1vOQ6B9SuTkfxvYEu1vNhl/N9DiTzCyEPZU0dbZ4g6qn2Y9pDYwMc8xUD1bg6d5ilTPBxO0JFXUBx8pnRuS1jEwhlgw9aq8Rj2aiVX06ANGPOendk/R7uLePz3oZVjyUyNxGzHrRw4+FqEt5sRQJiRdKPDS+XREjMagMew75QlWSJu2MEsfea+vOWYp5ruWaFOqlUHb97KO8IFwtXTzM5fZiD14nyEA49Qr0VbWihCMx9QNr7pw+kqng9CuQJ941d5R0H5sUzk+zfKZ5AJYRkwcxZUqJllddY6fYjJBSZCxLsDxbMdRBW4PyctbRMOA4S+vFnz9ej274XTPuSomlJxaxCoPN1hSHkGo7P4tD0Df13qjWVSug1zgzilVFtCW+Y8KXk25Hc9hXlMIcxIRSscDtA+4vBRVfCCBAcztu8rQ9i8zjLJvs24i
 DYzbeueN
 DJfrkZNOOPsMdsrg4aMJefjfhgkYkRjJ+0+hSDhfKW+jy8r0WarFbtdDU+TH/N0K50b7N3IBumUDU7wNXp3DCbhdIlxh1z5jyippIcDjMxskEmbBSJWKuIFaqBdvmS+qCh/XlUbYGT7olfpSV3xny89OsCd3FkKK6lxZhuX80r5VdjL8WfOXaJf25iRceGSs8JX0AEoeoYXJ3gNsKJliuyQ2fiEFafRtx38rXgxKB/NXMgprtUx5i3ZE1eO+6mE/IsvW9chn5fmt75QnnrxwmN1b0pdkpktJyGE0y6yXSPM029/XsA3I5XPmpN4yVePdxmdDskmDQ/yv4uB6tOUI30LqzOiRZ/R7VxFJDfng7azLnfR8a+LtwNovpDYrIRt6NN0kKMl8wvFHsC84YSNpFoEOVFxKsGALHm0i4hGcfF3Xvd4IWwrUZHhKlHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Directly use pr_err() in __set_fixmap() and drop pte_ERROR() which helps in
eventually dropping pte_ERROR() macro across the tree. In this new printing
__FILE__ and __LINE__ has been dropped because they are always the same and
don't really add any value. The new ptval_to_str() helper is being used for
converting pgtable entry value into a string. The error message itself has
been cleaned up as well.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in RFC V3

- Cleaned up the error message and used ptrval_to_str()

 arch/loongarch/include/asm/pgtable.h | 2 --
 arch/loongarch/mm/init.c             | 4 +++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d73..a32a8fff70c1 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -128,8 +128,6 @@ struct vm_area_struct;
 #define ptep_get(ptep) READ_ONCE(*(ptep))
 #define pmdp_get(pmdp) READ_ONCE(*(pmdp))
 
-#define pte_ERROR(e) \
-	pr_err("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
 #ifndef __PAGETABLE_PMD_FOLDED
 #define pmd_ERROR(e) \
 	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 3407030f3e7a..b8d6c3cb4565 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -197,13 +197,15 @@ void __init __set_fixmap(enum fixed_addresses idx,
 			       phys_addr_t phys, pgprot_t flags)
 {
 	unsigned long addr = __fix_to_virt(idx);
+	char str[PTVAL_STR_MAX];
 	pte_t *ptep;
 
 	BUG_ON(idx <= FIX_HOLE || idx >= __end_of_fixed_addresses);
 
 	ptep = populate_kernel_pte(addr);
 	if (!pte_none(ptep_get(ptep))) {
-		pte_ERROR(*ptep);
+		ptval_to_str(str, pte_val(*ptep));
+		pr_err("unexpected set PTE at %lx in %s: %s\n", addr, __func__, str);
 		return;
 	}
 
-- 
2.43.0


