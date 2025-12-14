Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C05D3E787
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 06:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58846B0007; Sun, 14 Dec 2025 01:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08076B0008; Sun, 14 Dec 2025 01:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8236B000A; Sun, 14 Dec 2025 01:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 882F46B0007
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 01:56:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1299C1A09C5
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 06:56:29 +0000 (UTC)
X-FDA: 84217168098.16.33EC20F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54064A0003
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 06:56:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c/af4ehC";
	spf=pass (imf15.hostedemail.com: domain of alexs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alexs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765695387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apGqneViZBsG0Sxhjrh0GEOqlCJn9cs/szQcSZ3tuEE=;
	b=mJuZ5Ojmbql+4lDHjYRZds3WjKUIfsI7W+N0lsrvsvw0iQQrtelIfeg6MH9Te22rIYcase
	xKRY7SzeLli7/Q57cfRlMgx/z85hVoRrHfi77kgBFe15+WeA/FOta5W3RCC/DBZFihwfZr
	VrSmow8j+nyzBwjUxVUX6tzF+S8zjMQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c/af4ehC";
	spf=pass (imf15.hostedemail.com: domain of alexs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alexs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765695387; a=rsa-sha256;
	cv=none;
	b=bN+0SsKMgrO1IStb11ZJObmU9vPcootxobWYWCxUzvOi5Ql2fussrAkVTHSzG9CYrD5Rar
	IKFd78YUMBlaY2sYoqfmDDLhkeqLDIRI6GyMSAWApLOXrWFwMmxXhx8N6J9YAA5FnkGNbr
	gDbV5eyFmtThJQ5+Vy5hcCQcYw+/jlU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF1C0401ED;
	Sun, 14 Dec 2025 06:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F724C4CEF1;
	Sun, 14 Dec 2025 06:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765695385;
	bh=rNokNUbqhtDAZzRvGy68XrNneuZAbKP4ZIJlFMKF+7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/af4ehCIryGWDPXN8wqNy/88J0nXqpVQGHfqT2+toiUwTP+C5J5RtU9Geyw2VF0p
	 QklRyp0qRhxs2uNnXKsuFbrGQWuVRKkwOznqKwNyMQ08nPkeKu8AT+vSKcJWGZRbJO
	 SWUiE+ata5yHDPcug0nZnZ9bCIjH71HjJJpZNSNn2ivRvv+Io94l2TRfBiZK2mBtHo
	 hkL5VrDGRW4/PzdFMq9L3tNB1EnsVC8laoIofiC/y2FO28Zz5QyMKGgbNBL7ThA2xf
	 2G5seFkvmZm6EfVw5Y8/g6FTtlsCMWO9JubLhTHribjDG3T2/qZGR26d+3tpea+B2I
	 7q/v9Rx2Ou0Fg==
From: alexs@kernel.org
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org
Cc: Alex Shi <alexs@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [RFC PATCH 2/2] mm/pgtable: convert pgtable_trans_huge_withdraw to ptdesc
Date: Sun, 14 Dec 2025 14:55:46 +0800
Message-ID: <20251214065546.156209-2-alexs@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251214065546.156209-1-alexs@kernel.org>
References: <20251214065546.156209-1-alexs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 54064A0003
X-Stat-Signature: qahx98xh9oczkej6c8b5g6fmzmkk3xbc
X-Rspam-User: 
X-HE-Tag: 1765695387-262751
X-HE-Meta: U2FsdGVkX184MqEg5s5UiPTJ3/OU/kJMHXVjEFl7KhvqWMaLE36/bjhKWgkPyjULeL6z2g3qpZ/gFkvqK2OgV25Pl/e9h+6SebuJVvW1cUuqUAGPC8nqv5jAm1d6aF/nvNU7v3z7miYPfgk22lDLO8z61Cdk6P8ts5sO5pAUADdo3mqNzZIqPu4l7ypuyLiZrsutJeYgU0+cMn1NuYEF8zBc1ybBxAbFfhBmjWfmFIpfYTvsDSjqfvx7FIAq3FHfQYrXGjZjzdoMVpce1PzWv6vwA5Holxg0OE63m3WgJmm1jjtub5aJo04NbGbNJZMBPXVJ6w9HxqxGOB8P0Jp9yOV0jHs+uEqEbkPJ6lqI1KHDhfXg64G86keauGuqWzkdTfAY+R/yrwyiYjX4mCLASI8f7/vwO7MT6+bboMwSDzsH11bXwEtk7RQssZvM6iYyHMWH4Zo+DchMJ2GCrTTGIin5z5MclKpFzV1kXOH8KI5i/8OOljklOgGNhAtk3NAzSxkCdoT1y8+5m5lf5KEIBLoPWj1sduz9qLbGw58zgb/0Jg7AbVYJ7pEPYMlax0sexdDPREnqzjX/LI0v20RJVdNgm9672q46qJNrFYPVwpqYm1aJqyPl8l3nPIeLOEc7NpASmxeipSW6rmtSEKZO/9Cirp216M9q+2LEooUJ42sToj/Aa2M/UI0jUcfMct6OzeLEqYqkEYut9ovElXFHN93SjjtaCg27rk2CBA6E+1zWBB4a9l6tvm32THevaqGYZec0GZaHZxp/x9GJiBznXp5gccUwwOJprffSnWUuvLFbnNQRp+V0Sy0XzgAjIJttxGP9Im1l3SRh2d9A2Ss5XjwWQ8X+HywrY0a4rMzG7MaVGu9IaMkZ7aoM23Bp3JcVUR5mhvEDiJyFQo1CnvNuha6Phvq2B8Qoc1L5g/aNquacduaOPnecGtssWRLxN6H/nKCVbq7K+55f0/f/+bX
 /ZcU246E
 QwZVbFaQvVuf6xffAvlsGQflpDrnHnHKslzpkw6H8rJLP4G0mXO4gh0HnAaAajPXaUqYbPVoOqLaSC5JtZSlEwO5Y9de7nGl1uMQhF43rN7Y8cziLPol756APKP0qM46laeghkkr0FcyfEqPG0oGGaSmGlO4xQOV5iiE2x7HR7ya/wvnaeYNK481SULRP40tEjHMFdk9HDkGi2OU7USC5kzggVEUYU8rt8Yac/vVeFl5zZBnkJBs8FbXBDeOlvxQ3kMNtSO28KIF82KkpwQ+ecriQMn7o4lgzgzEY4g4CtKRX3ennq+7xaHPV0DpCDybHbcXInNF254XnOuEPwrLIOkT0LPL1Py/jTvd0Ip7m+YtCzXTFEIIDeHQOm+IkMWigPzdBuup6Qz+oXfFLHcwO/jPEdELZF7kYPn2bBiFxRcgDZ1eqOru7FZiHJpL2wV65pTwEUe/BcySa3ff6Zi5CcyMaLOcCTH5NJkVUhRPOyrGXPyxWk+qvKNdPAT8iBuhhVMRekSt+GYe/rudqaplcgxpF7UR9LMQsX59hgFVGqzR3euZK8USYlVCsSyg0CH/CwvYYWhwEBb5w0PexG7bd09hZuzS/09qC4JIsRPQ6NtfzR7kMtvYksbpqDQbHaNY4fUZEflKLwqnJSJcKLnyu3qLO8LmIDgrjplhIhpg3QZG4txRr9/q6CoR3RvCdopAKjVxcLVl22aZaxw3dvjGNnXcoUMl1XbUXnBSdJJbuYsilUSfs81QOLZdNOT/of/iPUcIiS8IPqcViT+QYanFeYQustl2dIFoEo/2siS94OHcCoiy9y3L1bDqIv/4TrnLKQfBj7ZgOpZGBfC2QbdxXFIzwASVQDX36TErFrn8vmaDxVZDgPJvwIXeSCpnce/Mm9avpgDFMaurv//F5wU5LEggWAqqdvuAcUXn5gOy60iaPVrpTMQ69qM23dOgwCnXZBccPQz0dktHM0+49uQNfVWPzY2CN
 X7Jlzdnh
 s1I1tyX2Ir14aVjIepsX3UMxTuAbZVvsqaEFBPSkQ0uvijCcBBnwUba8KVNUI/PM2QPy2X5giyWg1dtIuuDYG90PXSIf5n9max6x9crFZz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alex Shi <alexs@kernel.org>

Following the last function change in pgtable_trans_huge_deposit().
this time we convert the return value for pgtable_trans_huge_withdraw()

In future, we could do further to convert more pgtable_t to ptdesc
struct and then replace the pgtable_t to ptdesc* except s390/powerpc/sparc
archs.

Signed-off-by: Alex Shi <alexs@kernel.org>
Cc: linux-mm@kvack.org
Cc: sparclinux@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Juergen Gross <jgross@suse.com>
Cc: Matthew Wilcox  <willy@infradead.org>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christophe Leroy  <chleroy@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h |  8 ++++----
 arch/s390/include/asm/pgtable.h              |  2 +-
 arch/s390/mm/pgtable.c                       |  4 ++--
 arch/sparc/include/asm/pgtable_64.h          |  2 +-
 arch/sparc/mm/tlb.c                          |  4 ++--
 include/linux/pgtable.h                      |  3 ++-
 mm/huge_memory.c                             | 15 +++++++--------
 mm/pgtable-generic.c                         |  4 ++--
 8 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index f10736af296d..3485de5178b5 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1328,12 +1328,12 @@ static inline void pgtable_trans_huge_deposit(struct mm_struct *mm,
 }
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
-static inline pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm,
-						    pmd_t *pmdp)
+static inline struct ptdesc *pgtable_trans_huge_withdraw(struct mm_struct *mm,
+							 pmd_t *pmdp)
 {
 	if (radix_enabled())
-		return radix__pgtable_trans_huge_withdraw(mm, pmdp);
-	return hash__pgtable_trans_huge_withdraw(mm, pmdp);
+		return page_ptdesc(radix__pgtable_trans_huge_withdraw(mm, pmdp));
+	return page_ptdesc(hash__pgtable_trans_huge_withdraw(mm, pmdp));
 }
 
 #define __HAVE_ARCH_PMDP_INVALIDATE
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index e45cb52a923a..5f7fab7b121b 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1754,7 +1754,7 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				struct ptdesc *pgtable);
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
-pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
+struct ptdesc *pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 
 #define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
 static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index c301af71b3ec..6e53a30dd3ae 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -534,7 +534,7 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 	pmd_huge_pte(mm, pmdp) = pgtable;
 }
 
-pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
+struct ptdesc *pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
 	struct list_head *lh;
 	pgtable_t pgtable;
@@ -555,7 +555,7 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 	set_pte(ptep, __pte(_PAGE_INVALID));
 	ptep++;
 	set_pte(ptep, __pte(_PAGE_INVALID));
-	return pgtable;
+	return page_ptdesc(pgtable);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 4b7f7113a1b3..29fc86175300 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -995,7 +995,7 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				struct ptdesc *pgtable);
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
-pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
+struct ptdesc *pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #endif
 
 /*
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 5dfee57d2440..8b00b62c06bd 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -284,7 +284,7 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 	pmd_huge_pte(mm, pmdp) = pgtable;
 }
 
-pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
+struct ptdesc *pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
 	struct list_head *lh;
 	pgtable_t pgtable;
@@ -303,6 +303,6 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 	pte_val(pgtable[0]) = 0;
 	pte_val(pgtable[1]) = 0;
 
-	return pgtable;
+	return page_ptdesc(pgtable);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index a5b1e3f7452a..4b20b3d7aaec 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1021,7 +1021,8 @@ extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 #endif
 
 #ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
-extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
+extern struct ptdesc *pgtable_trans_huge_withdraw(struct mm_struct *mm,
+						  pmd_t *pmdp);
 #endif
 
 #ifndef arch_needs_pgtable_deposit
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ff74bd70690d..6f6cdb3ae888 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2334,7 +2334,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 {
 	pgtable_t pgtable;
 
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pgtable = ptdesc_page(pgtable_trans_huge_withdraw(mm, pmd));
 	pte_free(mm, pgtable);
 	mm_dec_nr_ptes(mm);
 }
@@ -2492,10 +2492,9 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		VM_BUG_ON(!pmd_none(*new_pmd));
 
 		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
-			pgtable_t pgtable;
+			struct ptdesc *pgtable;
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
-			pgtable_trans_huge_deposit(mm, new_pmd,
-							page_ptdesc(pgtable));
+			pgtable_trans_huge_deposit(mm, new_pmd,	pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
 		if (vma_has_uffd_without_event_remap(vma))
@@ -2710,7 +2709,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	struct page *src_page;
 	struct folio *src_folio;
 	spinlock_t *src_ptl, *dst_ptl;
-	pgtable_t src_pgtable;
+	struct ptdesc *src_pgtable;
 	struct mmu_notifier_range range;
 	int err = 0;
 
@@ -2801,7 +2800,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
 	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
-	pgtable_trans_huge_deposit(mm, dst_pmd, page_ptdesc(src_pgtable));
+	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
 unlock_ptls:
 	double_pt_unlock(src_ptl, dst_ptl);
 	/* unblock rmap walks */
@@ -2962,7 +2961,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	 */
 	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
 
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pgtable = ptdesc_page(pgtable_trans_huge_withdraw(mm, pmd));
 	pmd_populate(mm, &_pmd, pgtable);
 
 	pte = pte_offset_map(&_pmd, haddr);
@@ -3169,7 +3168,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Withdraw the table only after we mark the pmd entry invalid.
 	 * This's critical for some architectures (Power).
 	 */
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pgtable = ptdesc_page(pgtable_trans_huge_withdraw(mm, pmd));
 	pmd_populate(mm, &_pmd, pgtable);
 
 	pte = pte_offset_map(&_pmd, haddr);
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 220844a81e38..a95d9309215e 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -179,7 +179,7 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 
 #ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
 /* no "address" argument so destroys page coloring of some arch */
-pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
+struct ptdesc *pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
 	struct ptdesc *pgtable;
 
@@ -191,7 +191,7 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 							  struct ptdesc, pt_list);
 	if (pmd_huge_pte(mm, pmdp))
 		list_del(&pgtable->pt_list);
-	return ptdesc_page(pgtable);
+	return pgtable;
 }
 #endif
 
-- 
2.43.0


