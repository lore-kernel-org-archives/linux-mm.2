Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D63DCE7AB9
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13128E0012; Fri, 14 Nov 2025 06:13:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3928E0002; Fri, 14 Nov 2025 06:13:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB22C8E0012; Fri, 14 Nov 2025 06:13:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C5C068E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:13:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C12316032C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:57 +0000 (UTC)
X-FDA: 84108952914.10.66474BE
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id C4F0D14000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="iw/rnvl+";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118836; a=rsa-sha256;
	cv=none;
	b=gdV4xDv8OERfJRg5a3oFelJ2xjarlKYySoYhPn8ulpsSn+T3fZMCRkR2MQQxDdkczru7mY
	/pb+kn3qb1Qzc+n9ywYZbrvbyJMvlaT3867NEbL27IxwRWWCKI+JddBIjnHyr6hr2m/j+I
	tOrVaAMm/Nj9AekVnOpbSHnLpS4KYS4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="iw/rnvl+";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xE2z7TAxeJ/1HQSzhHJnzUcYxbE0hsI+5X32zwVc0VI=;
	b=VXwMeJPiIFWbh0Bw1fpcI2aAg4iyFEqWEogN5/rYYt52bAwI4MvZC45rda1oPJhBo8cW0A
	Iwbzje/wdWwgBOOP9aYK15TyKoUsVnlA17DU3eVQPjqcfqbU2tKGKGXPxYs5Ct1x5WBbO/
	QGt+NKU2TJaryTgNMrrIQKqbxsVElAQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763118834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xE2z7TAxeJ/1HQSzhHJnzUcYxbE0hsI+5X32zwVc0VI=;
	b=iw/rnvl+mSTQwZ1VtfwsUIUgZEgEWYMoBXUqNckA12rFzs5wwBw1DfEnB9VXrBAiN5lBA2
	+WL6SCJD5yzsK1tlWnajFGyhDa2TXm27uAcag6i4H/j/tdwWGVq+UdZZjcaWuNr4dD50wD
	yUns3WW5Fq1s6Y/AV0bEqLTbFKSi9Ds=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4/7] mips: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Fri, 14 Nov 2025 19:11:18 +0800
Message-ID: <d69204bb10f4d08eb5d5ae673d2329e7df44af72.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763117269.git.zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C4F0D14000E
X-Stat-Signature: b1ccudrrjprsfcw1m5e1mgmczmmyrzgn
X-Rspam-User: 
X-HE-Tag: 1763118835-711916
X-HE-Meta: U2FsdGVkX19eqkg+oJWSz1OAFzet8ovj8LoNJLKRIKtdxUiJ/zR6OCGAhc9Url3HfkPi9Ov/JkRl3T1RMCAbuyil5YWLBJFyxSNKJRj+mJ5xAWW4v5MrnqzCVY6SClcZY0lM1f7qO7frpXQO1flwYQlkVXBVNAfQ6tN7eVwVkEQXx9N793YWdr9mTClGQopmt38ZEufp1zYZFlUFv1ZkTJCxG2VRvJi07KEj2v6xrnzFfjucuRy32baBz+WFQdpMC8aP9k5OZoSaT+8oEGHG5+0savlswKhIcvQBu9E796Qb6aFMnaynI6osJMgAADTgiOqclAQQzbz19QPhHHBMU6iIXJOdoigPXjBFUkGzXsrCn7gEAE3SFHdqnH3CEySBzY+OEDBiewenNYgnBQCECUIjIDYTge+X+MNbPqN1fZ4zKkaSjTmXypoEzlvuLlTj4lwvMIJu2YczucwHmJrALz/an2IRF9TE5flbl67bL0ZLJSeUToC1DJIcCccYJ4naCS1EYKrgVzYy3AWAKqg44tPvLZUoPytw6gwsLYvelM/Bh7tTX3+wDzpDZZgYTO4JAPkipiW9Pw5WU6aziwWhNKK7F4y9dlv23I+5np+ApK2BHEF9XUNnMgOPILsTCNYSeaY2sgERUPzLpU+S2UP7IoKoXwaW0M7HI/qXU/7qpbwd/fDAx6CtnVibk0NQ5MENPL0FLC7l9HiO1Os2dbWIevFPVRe5sBnAWtEYl+4peUD7m6MuSabf77m0WHEmRBMdP9hjzPEI8wmu1A2NrPYU++XnvzrvQnPHBMsRnyubpzOJYdNvyvHDBpG0fpCtGsx4Sqp4egoyzIK5bgjf/GjUvxYuJnvJrGefyxOSsoRdcn6gJ9jxPWBIhegCLYxiA5hfcBr7U+geBVcc7ohaIbKb13EKkOCgDiqJKYd0FBQtquNoQ9NwXiKaW7jx1EyKeFXVdGeaLZmIprqT6n/9CZO
 wDx7M1IX
 K9EphatF7i1Ht/X2lxJ2ptu66NOh1+44O65fTf+64qWYWGmmtoFXwtzF8k9Lca8uJ6jAz/6/ijFlXiU8pGPLQM/1MZ8/4Tx5muRL+8FZCRO9aLurp/rCD07rq3C4yUrWC79qZnCdJ8DkTAECn02EdI2sLgGtOljHI4EOwIwdE/KlToL0G5btYnfCIQmWMqK5DfWIoXxYZRjpWe9npBoEnyvZETzjh7uSw7qVegAWzkI5GYaia73uQM1SwCrdOV5KWa090/mtIk7vg02o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 arch/mips/Kconfig               | 1 +
 arch/mips/include/asm/pgalloc.h | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index e8683f58fd3e2..0ee8820a354c4 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -108,6 +108,7 @@ config MIPS
 	select TRACE_IRQFLAGS_SUPPORT
 	select ARCH_HAS_ELFCORE_COMPAT
 	select HAVE_ARCH_KCSAN if 64BIT
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config MIPS_FIXUP_BIGPHYS_ADDR
 	bool
diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 942af87f1cddb..c00f445045f43 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -72,7 +72,8 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pmd;
 }
 
-#define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
+#define __pmd_free_tlb(tlb, x, addr)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
 
@@ -98,7 +99,8 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4d, pud_t *pud)
 	set_p4d(p4d, __p4d((unsigned long)pud));
 }
 
-#define __pud_free_tlb(tlb, x, addr)	pud_free((tlb)->mm, x)
+#define __pud_free_tlb(tlb, x, addr)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
 
-- 
2.20.1


