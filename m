Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2550C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2946B0098; Mon, 31 Aug 2026 01:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1092D6B0099; Mon, 31 Aug 2026 01:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12F96B009B; Mon, 31 Aug 2026 01:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE4B76B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:43:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 470AF40371
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:52 +0000 (UTC)
X-FDA: 85160473104.23.C7961F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9C00B1C0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=clNBxERM;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788155030;
	b=Br/vBwxkKC0TWtgHXDITygYoZs5Z/C0WLty4t1tQXvMwE2G5uGGupNrOXBhekfblFWRk+f
	qpkkleuOpzVdzxN+OXbaZHcrOMhot+a/3pCnQii59hCNMWnQQxPUjMn3gZEIsoio9dU+Xq
	Vw9mWMfoXaUFdiSj1Il3zOVKetvCrHY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=clNBxERM;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788155030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyZOSHbWdCLgVvtWvoTlV1hTMLOgk7p4ZvuZfdT15BQ=;
	b=f05T+fzcXh87e3xdu7bzaJNKIdGKQdXdmLzVv8whVLedPbpqXO64sBq3Uodgai51WrTeuZ
	D1q8vmBEOwAzw7zHkwPzikFgSXLX0vMof1TsPdsd08aEsiSEi7CsBxaCTxsDLDNSuoeZQu
	BTqY9gMIOcIqkgx1cMEVVbxNhumq+2U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A634419F6;
	Sun, 30 Aug 2026 22:43:45 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB2A63F85F;
	Sun, 30 Aug 2026 22:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788155029; bh=bHIKcGFMXnlsQJKrJxXnpqBn4JSSxbIBTdF+CIJ8MW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clNBxERMYdRAakaKKIeVq+fddLwKzW5bcKoOh3VIgFbow5RV1gsMlDc9WSqbXb3In
	 gA4QFgJuxjGVFz7Nge+XaSm3JSHwl5mmk9xVBh4EipWfCTJt1zUhGrlxZzYC3eH25s
	 bGFJxNhoF2TETCqvHlEfMMHmYKgnZUJbqwS8L0U8=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: samuel.holland@sifive.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH 4/8] parisc/mm: Directly use generic [pmd|pgd]_clear_bad()
Date: Mon, 31 Aug 2026 11:13:26 +0530
Message-ID: <20260831054331.625505-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9C00B1C0002
X-Stat-Signature: fd1usrqmfz74sn7e4cf9ig14t5b11kzy
X-Rspam-User: 
X-HE-Tag: 1788155030-182491
X-HE-Meta: U2FsdGVkX18e1xb7worqME3bIJ4KIYN5SS1Ys8HwmqdaQDfaeVyLCi5gFeUq1LYoz7C1fXPBU29yByuR8zgvYHypS6a+sNU01z6fCdELGgDySskH+VSVBf/JtL/FGKw/1dW18siQ2ujHO0gEAymwvoeKwBUaIIeW2iVIo4e9YRg/bc9QGdaGJYkxbtDi1q0mSVRxd3I3wc51YFEZrfImeEwyi9ZAORKIXoPINXo7tTCE36MxBJvY+Fvr3q2TVILmbLGPhWrMXKhVzQBnRIa04Hs1gJOIDT2IyAbwcV7xVheNSWmP+vMrCDroEBgakd+gN3fG1XHYlprBgwAmXUnbKw6AtbBzU6RU0HZuBkCbQltZQj3GnUSazB3e7Fm1Kbv1tAXCosD/y/5qp6zeSpvpaNb4un517TvkFqdlfmVBj6gyKS6NEd2ca+m9w85aGwltadDo2lOELqNsG85vmYAHavOZTZ2+JVUgJleM+rcdUK1VCYIm01Au3p6m5XfVbO5BFQetAst/DulKM7thR4FWb1UCY6D8DSbB0iZtbNWxgPl6PhpPhdtG8XQHIqie/xn1Rwnws7JOgg0Lfn3UiuVxE2U3CrYVoD1BcfNS87Un8bWb2e/zvcT5L3KpI4wGc4nR6aPgI5rV5s4EOaxBq/RrWA7bjOMVfVab30bmTwN5qT4hJCqLFDPDF0dNQHB3qbqovvEnR13kutmFsD6EItPl9EYpfsek7uMgISS3gmsjEJUe+SzK3cOlmvaDB2mUgluPQuNFgrc11pV4GPWA0w+fd3skfQ7RuUtMcoJODAR9DJKo2ZO/Vf32EZvzsSXHuW6IEk+TLyObLcUGyXism4CKuPxcf8HxMXD6cw71uqeT8ty0PdlZzkzhuF5ETn2QBmYegzdUJKnbDzqyHeYeSkoSE2115G/rBRMwvqCFMu2+ECs9YNi9go2lLbhg7wQBsp2GsP7PC6mT96l2ZNjF7FO
 tk74ybCG
 shOmMUfcPc2TG8II9cXAMTAzjOURCwdw6C/OzErMH1mZudjac4AZB3+tGBmIdkzWPBJDEAENNumCdhmfvXooHJEa1gDG0Zm+vR4xkg2MgSUBlp2wBom7K644O4FDS+FC9Mtkcbo7kcK4hP4Tfqs+KYWTs/EQaaA2y+P/Kbwx+MCsXloG0xEspG/l9aricABKs1KZAcr7Asosqe97zuiWIUi/ymHA7sE9uTJEySa9YDtDSLXOgmBaW95JTaQtE+VN9V8jdUnwGBMTA7qXsZQMJ5az3DClqpM1d8afXKbDZz/zUiHyRbdHwg7vr8+/0/T3RTUH91ht0BR9+LbHlihNk8D1E468T2LzH/nOOXrchgBeTE+9GlBsnzQKhrpzx7r2dTGbg9Zc5wMSauNMgv9jple84W3glTgyc+WWEzM+aPxdZMUF6Op2i0p3oCT3DpVnM0/gzY0Vv4adpYDpaNpQfZPuxWpXXwt1IQyWBzdNqEF0uGW4wXC5q++2zGR3YuB60AmEm+bkjWn7hySXCTDN5jw8iKNtZu0DhyWat3hKUwexbAGKcCShmw7VDoamGnlYqVlUJCSpm0/YLUZztrqciiT/JCQ1Aq5D7ZMF2
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

Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


