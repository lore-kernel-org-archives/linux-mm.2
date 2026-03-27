Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC4A10A62FF
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9806B00BD; Thu, 26 Mar 2026 22:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E43F6B00BF; Thu, 26 Mar 2026 22:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421766B00C0; Thu, 26 Mar 2026 22:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B10B6B00BD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4DA413BFE5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:51 +0000 (UTC)
X-FDA: 84590227302.09.DA94859
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 47F9C20002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PBqsuNks;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577750; a=rsa-sha256;
	cv=none;
	b=KIKI8ZWSju6bqGRYbOkaEhwK/d3fTenbJIr/+WcXQ3GpFFawyagBjSg5K1pU+FWhkevm06
	MayWBaPuoZwAltqt7KOG/RYWszlyFBI9PKCmy/lhCBG89uH1iFozg4Wbr+Dv+JAgreWxPG
	hEH+dkJTt7J7lefGxuahkVIw96E3mYo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5PgiQrcwbn9XAgL4cRYPHYRVIr8zaspEnc9S8fZNtw=;
	b=pE0tLfW8ocII8A5yAlwgA6OIdAnzt+y41Bl396kCiXMgsiablm248FUIie2N5R8YqHo4vR
	ZoZjJi2J05g6F04wJU1EPn37XVdJQYQHmfpsrFgs04+Ixh3HdtwtUbONBJ4XJj2JcX/CX9
	1e005Erav6mq32fjuv50edioN54F2uA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PBqsuNks;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y5PgiQrcwbn9XAgL4cRYPHYRVIr8zaspEnc9S8fZNtw=;
	b=PBqsuNksqiYxLcyifzHiiquL6Zzzi+Q6QhZKvMqsl6Ywk8e+CwDNj9TY+ZBrYzU5TX4YZX
	tN7zZsn84kggt2lWPGZqKW8iUu8t1aNBnigvnGagmSkB+xzT/lcMTAqVdArQiFTX42gjln
	p/GMbq4RVKzlqVsGNHcXNmutrl2WTFQ=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 16/24] mm: huge_mm: Make sure all split_huge_pmd calls are checked
Date: Thu, 26 Mar 2026 19:08:58 -0700
Message-ID: <20260327021403.214713-17-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47F9C20002
X-Stat-Signature: qz5z5ky4hq11hdurr5eok8xgmw6i4x33
X-HE-Tag: 1774577749-443068
X-HE-Meta: U2FsdGVkX19gLdEzg/QvIbYFIvmT2fwCRQ8WDbsniXP/06VQ+eNeGH7Uudvun3qcGryr/U99Pe+nrHgGyAktzgbEHqvZ3CfQl0P9hKRDWdPqp9lwVdiA0jOfOcWd3DUGrhFjpHQ8qNdKVGWqy3ZHemY1niP4uaklAWqq63s3cD8EDz0s/qYX2hxenpl8nUmwVZuS0X3vSpzpGHkYRHPX/EI8DyVUhzjyHHvLFwusCittsZcuufAUuQB62YhkIcSu5bmYbICdIopmyGT8D6tGVAleGj2bjJCGRa72068inreZU33ARbv34rytB++0xgin7Q7jzUeob0tye0TE4TJavT0JYc0CdPrulEFxO+LTxTGSyRVm6PC/t+gjk3l19Qf+NKIKG0Sb8+DkGjN9v4eYeDF+ylXpn4NHgPBhqedmmzZkAmdY+w1tZZADvIVJQ3dcVzRacPtVpMRHNZ+LtZEHWuSSvOpfnnA4YEOAfF2l/lF7UbkOxbGwyx7ab+AAFUh0ZL2xEnw5Cf5hZtQ0dsdEgtC9eSGtZnQoSLB0iYBJiODdI3rSEfMKvgSyzqS/9ivJVEw4EuwbqxnyZHBA5zQtFHfZB0m41pBhbmJA9RPHORm9Ur/r0Ze2scJE7CrK5CFdB98RzldD+TLiC78XNZvJbOeFkj1oWx/y9fh2b8i3vNK6g5pkZxyhfDWkWE7i9wQWKxLW+e+PYRUwWYyUd1hwMIKPJoQpoCsKW7U6WnORclJ1QHwlW3iLmZ4YB0K4pJQlMtI+cUbweTM7BYmPmHBCpOkQutFVRrIYy549IXoxIrD5nG4+G6KOwPKf6lA1II5IEZU2N1YsIM6XgwIxaeCF3bEIpiydt/dhhWr/sje6R30xV1gnMdYaI2SjGfIYjwvNIQWpIg8DWf8z8mWDvOdvdiBXzXAglUvvNDuWlf8FlzTnVRBmLPxvNh2BhzgaGpDcpFmCqQ80aWj1ySxgVGf
 ETIivA6N
 oZObRRRxMDRBoYOrSrbWjfH5aQV5+o5ifDpLSg/V3Ivbls0UGeVCvPMg6X5ZdFl1nl9FoQvTPb2H6DYGUGoaS0dmaftqyojE924S2PX6oxc++fGzbKgC6OY6FYT7F1ouCPbQTbLzAvL0K6LOykAcHrGr/2PLbwpOjCp3LIw20zvzA0fdfXAYB4Dye7bcfh+z6e2t9hwb9RPJo/7Pa71hXiygDtpHww9K1IqrrEx7TtYd9rIzMikyN1G5FTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark __split_huge_pmd(), split_huge_pmd() and split_huge_pmd_address()
with __must_check so the compiler warns if any caller ignores the return
value. Not checking return value and operating on the basis that the pmd
is split could result in a kernel bug. The possibility of an order-0
allocation failing for page table allocation is very low, but it should
be handled correctly.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 224965fce4e66..c4d0badc4ce27 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -418,7 +418,7 @@ static inline int split_huge_page(struct page *page)
 extern struct list_lru deferred_split_lru;
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
-int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+int __must_check __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
 
 /**
@@ -447,7 +447,7 @@ static inline bool pmd_is_huge(pmd_t pmd)
 	return false;
 }
 
-static inline int split_huge_pmd(struct vm_area_struct *vma,
+static inline int __must_check split_huge_pmd(struct vm_area_struct *vma,
 					     pmd_t *pmd, unsigned long address)
 {
 	if (pmd_is_huge(*pmd))
@@ -455,7 +455,7 @@ static inline int split_huge_pmd(struct vm_area_struct *vma,
 	return 0;
 }
 
-int split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
+int __must_check split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
 		bool freeze);
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
-- 
2.52.0


