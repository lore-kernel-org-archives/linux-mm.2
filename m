Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DFB1C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9136B0093; Tue, 11 Aug 2026 00:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC08F6B0095; Tue, 11 Aug 2026 00:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6496B0096; Tue, 11 Aug 2026 00:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7951A6B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:21:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 018FC1C0E66
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:34 +0000 (UTC)
X-FDA: 85087689750.28.423EA03
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3538B80005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rHvZEaZB;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqYTyuJigdGC6n50Tg7PHrR5p4btDFU9kp/x8tq4MZE=;
	b=SpO+kfoFADnyd4W20rin1VdIDCFRz7ouLrk5BIojQ36i6vwcBSTqtNDlhhiVMhg+J/tEOR
	M3WBVXx6IPWsxXmWdzVp65IsI7X9f+IJeB4ZW4CaMA6ZJcaUFjDdOUPv700GBV1aznnDX1
	bew9KcrU668ILQyfMDRQ3hMnMy4U2QY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422093;
	b=4twmsxhslTlbih+ugq4LcyIKC45l8gFtKV219MbnR+8BKNYl7ZCuCrqp53axQBLirX+KwM
	FOVyhD+or+x0CJGDwSfUjCXqMQEGSTG5n68iaux/4fkEqIj6h5z+QKih3Yjn+h2K48AsA4
	KwsiPBeQ7vQgs+WRRkjCcnHV0z37ZYw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rHvZEaZB;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68B031684;
	Mon, 10 Aug 2026 21:21:28 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E5FB3F673;
	Mon, 10 Aug 2026 21:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786422092; bh=BqsfSrzSwruH65sXJBGnXmlXFGRnhcX2ugUIjxcj/Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHvZEaZBVcSMFwn2Onro3gwOPS804AfXvPTDUi0l9z4MNgF38FHJ0V4gLq9fsXUSL
	 WfVE47DkPbbJE3P5/E+A+2R4PCyV3fLZiJAJK2b95urh3keCsYz/2cZq+G8o/mmaVN
	 /7RC88lRZ6+0rSSPRsdZY5lZqPbYLSHvlWv2aby0=
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
Subject: [RFC V2 2/6] parisc/mm: Directly use generic [pmd|pgd]_clear_bad()
Date: Tue, 11 Aug 2026 09:51:15 +0530
Message-ID: <20260811042119.3652929-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811042119.3652929-1-anshuman.khandual@arm.com>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3538B80005
X-Stat-Signature: 3b4sxy8zrzbx8pqcpjz6deuo5hm69q4y
X-HE-Tag: 1786422092-103331
X-HE-Meta: U2FsdGVkX19zv6wkCBieeOaKS7zO7JhxBhhFKu0zp2r0xPxNVrYvPXhFq8FZsREF5KXeRPV6XP54vm6bDvNUhakfuiTmnVGPJF8mlo5Fg0FNr3m7kD5eVERJzorqbv7SRFqpYxKpPQZ5EXcda6ElPJ/n4t4tQngBcvEpUbZbopVokpRk19EEyIFUJVYQI6bVEMpnwdCjVMc42Q1QxeFN/KMj5dgtUGRRlA5wzMaymu/36hTQ5uHukx1RUA2x6pJf1nOud7ylEfxzkEzXpUnZd0f0bnUDBlUmlSy5KOYMhadbo17xFVrfGF1WwUsQbNV//8XQ3dH3g3fJ6YsFZXfMi5c4Zbpo85tgGZcXS1nXpP4LSrctN8RVmR0eDzPmEr88FzQOhdAgp1dWf2s05+1mIJhG3e5Q4LX4O/FNEFitCHO+HqO4KaKNFnYcwaY9Wh63Hl/b5caQqxlyMv/pQ3/WPcGnhhCv8g4ECTgtOUuoa2Pkf83lKXcPfVd0bCQnKfoSi4t5ety33t+aNsjL/p3qpJ+bSZFg/RllYSvITKC+Z/exeQyBUTAASdf1ejrz+5Qsv9yIsGyqWjpWo89zt5CjmJqblz1Hz8FajJDPEf3Fv6lRPlURpeZP0pzjRx+Eb3fjmwGUnhX05MHpfRbJRGkKgQgt8FpI7KrSd6QzWvDQnEY/aGSzLvT5HBf8bUKOV3wZgoxD2NBO48RgnyUgnSSbnIY4VHvBIiLGdNtLIILlLah9xoxyTrCkFd/RqhlBU/cR/bZMmqAg9QMciSTnXEVj8XlsCHh51/btEUwt2kipeOwUPt97yXBcXTY3Q4BVgrEgBhyCYKTd59ZBnIcpBG6aX/kn/DDpek0B/xzljUQmDiyyROBByumvq6jfcPYRgYgXbW+TXwAGp0OBWwpjJydDhObqO2cLsivCxCqBnJ0TzoMNz9N9fMBFcwAo7ycXzLBVfqoqWRFbRWTVKMJ55af
 up2VlQ2O
 L+a2dIvu/VtlzGXDcyIZEA8MGZJTjIJXH4GewvieJ9JyPlN7bgScWKk0O9YhTrM/zoZfxj/vekn1S70y99B8bWbefCouP4SGoaCfDKDPsQ+kXyE2jz2gSvCDbPPhWCRPyBwDXoNqXDol0BWgtJ2CSmv5Yqm0ByQqWPwv5z4V4ijxSvwPAy+eo5I30nW4tePWMEgmoA1T0XKPlG1b9WVtCSgpOZtTcK4g0neCryXKkBUD4PBdw77Se8yHC31rG6IZbq+YxIZ9HNHiObFrC8MEI+rSf4nWKQ72ZJJLHRnCh5/eJEMk+Eyeh8kl1PTbjJ9D78AnpRI8nwcHPpaL99eV/0JVw84IX1NMEk0mCPA9TR+xG0pR8QmKZS4hYk2bDvDvyJ2swpdyWqWreQaqtYD32HsqXQ4BHGbxPHbgGUIJHnh5imvrAuKknQcWzXDHjLdSEzF1SjZ2HqtHIimyAxx7wSXqD7UyhTWnT4jZDyxJUMHDpHGqCzbLW5nAPYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drop [pmd|pgd]_ERROR() followed by [pmd|pgd]_clear() instances. But instead
directly use semantically equivalent generic helpers [pmd|pgd]_clear_bad()
in unmap_uncached_[pte|pmd]() which helps in dropping their corresponding
[pmd|pgd]_ERROR() macros across the tree.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/parisc/kernel/pci-dma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index bf9f192c826e..84e7309a8266 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -160,8 +160,7 @@ static inline void unmap_uncached_pte(pmd_t * pmd, unsigned long vaddr,
 	if (pmd_none(*pmd))
 		return;
 	if (pmd_bad(*pmd)) {
-		pmd_ERROR(*pmd);
-		pmd_clear(pmd);
+		pmd_clear_bad(pmd);
 		return;
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
@@ -196,8 +195,7 @@ static inline void unmap_uncached_pmd(pgd_t * dir, unsigned long vaddr,
 	if (pgd_none(*dir))
 		return;
 	if (pgd_bad(*dir)) {
-		pgd_ERROR(*dir);
-		pgd_clear(dir);
+		pgd_clear_bad(dir);
 		return;
 	}
 	pmd = pmd_offset(pud_offset(p4d_offset(dir, vaddr), vaddr), vaddr);
-- 
2.43.0


