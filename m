Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7992FCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E186B0095; Wed, 20 May 2026 06:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26A56B0096; Wed, 20 May 2026 06:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851FA6B0098; Wed, 20 May 2026 06:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72CD46B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:19:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42E83A0285
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:17 +0000 (UTC)
X-FDA: 84787400754.17.14A66D4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9ED2AC000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="V/5qubSD";
	spf=pass (imf10.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779272355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hK/M4mH8Af7RP/R8Z/X9FqFJJChjz35upJb+IeYgpMA=;
	b=uGgOaZ3mIFQbD5U4fRkZ6XhEnVvLrLIJRxydOvYbnJdMuHH+ZN631UN8s8U5PV8RNAQRLc
	2izUkLwBoOqxCeG3tFAMFWRjUrytCOwIZxF66egSvMoczO5EtJHjj+yh/ACty5Etn56uIO
	AWLVDpnODeU5AzyOQ+OcGePojyi5Sb4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="V/5qubSD";
	spf=pass (imf10.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779272355; a=rsa-sha256;
	cv=none;
	b=Wj5BGc4LpucizmYFIASRP/2IkksnuV0ts0ko2V2vq3jScy+aGGdTsXwugp6NOyvA2cTS7e
	m2AMRAka91oag6nxADlJDH6OMd3BhgYhutaScj0jUKbJCDi36CpR1e+ej+yDcA6MwTu3V/
	nzSh5i/rISXiROLdp57Dsc8k5YAxNXo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=hK
	/M4mH8Af7RP/R8Z/X9FqFJJChjz35upJb+IeYgpMA=; b=V/5qubSDLft5TwdJtV
	ji/UPnm6o8HUMhqxwbmT67iJuxFHpfcZP5qyyF6H40TTnmtfUxWlLAwYaMvVlUYX
	KvCkiSUNznp6I8G0qB2lrlumzeg7mkGMy90uKxfybGcrJEagKkxViXGlyj9EuiEK
	qE5pyR6+iAk31H6TCbfM6L3bM=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXbbprig1qQK31EQ--.641S5;
	Wed, 20 May 2026 18:18:25 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v1 3/5] mm/shmem: make SGP_NOALLOC succeed on hole like SGP_READ
Date: Wed, 20 May 2026 18:15:36 +0800
Message-ID: <20260520101538.58745-4-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260520101538.58745-1-chizhiling@163.com>
References: <20260520101538.58745-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXbbprig1qQK31EQ--.641S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxXFW5Xr1rAry5Kr1UGry8Zrb_yoW5CrW3pr
	9rG3s7GrWYg348Cr1DZws7Zr1UXan3tryUKryIg34qvF98AF10k347Aw1j9F18ArW8Ca1F
	qFWjkws8uF1UX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpApnUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC2xKcOmoNinJltQAA3g
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9ED2AC000D
X-Rspam-User: 
X-Stat-Signature: btrpxq3s9t114gamo6k9myxykjdscif4
X-HE-Tag: 1779272354-805807
X-HE-Meta: U2FsdGVkX1+/kzff3g/YFgSSFWC6+M8FLDUYQM7VMiQ928cu/wIJDil0B04LO3+0Ez3JcE5y1P7Yir4+vrVx9xdZsF4iRoh5VyVV72/lXmt7QsRF6oYAWozJrJWbXeT1ym6Wn9m6OzU0b52ZQL0ZuvxpKLwSsdj3OjaI6qzwUzm8/6eXIGLLVsGQ26rzonW4TPETh/oJTzbiaEeUv/FNSqcW2wllTZ3hgXm7DY6vOeVVAjqzoTSONW2+Pwf/pB0UeEv7HJ+FsFt2cjmdzfHO7GVjP2znGrsbFUudPfj+AwF8RR7f2zpVfwdmxVmEnox+LoVT2T6zx2lCKp4X3GcYZF2kCMdL9GxneNEGXiOFdjcY69j7rr4wCMpGe/yFxpeRoNh3f0Qxy5f5BKhM5O7o/VQVnQ2A5k5iefihoBbNkdROmtM6/3nIL0NBefCpR7L0pvCF+GvS358wFZwElz79q2VrIz6OTT8CSUBBYmbGa/H5JdFc1SmOHicsLkrT7TBmg5LMIymTX+SrEoNqdzvRDF0zm0Wg4A3mzu5YRJchOa0jrXBgT1dh4iexjog3r2eJLAS0eaG0QVjdAkNKkA6lN2v98kBy/3alsbeBTcVUg6/sqAQ0mm68B03QBVQ6sn6FLV2zTR3wemwPzzuMd8wtcjM8oxSDRDuzVFua+H0ChgR9U+rA0Cf/bua3lboXZwp6+3rHr9NlbrPLnucHonaP9WcJKogsOQWdan4CJ2KLSBVryVc7YzfOj6zVTeTp6E0SuG5rik+eU5hQgj0y1UugS4aKYrkyrvlx539l/cqKmMvTivNMnle57zE3kOZHTlfgLbsddG6dW1QyKwt7QoQTCY76fujEhLBPtYaqqo/LivpWVgjUOQcGZ6XKWFe0C31cWDvO2HvzFNmQIeagVtkDAvOVyI5f1ZoygS9EWD/69ze3Z2Z6pq6Fgtn1KfRxZjZyJ88fTPVsuWqxSjmBQyN
 dFBcj+Tz
 C50WoPQ4SEURLKJ3hKwUxDk/nG9VHgwWhDa/DDup1BJ+e9x5LRg1+0whmehwY3k0meyNQdsEOGTm5wshdgRW4r7HKGpgqINtPYBgMuLu2p4aPITEJHFCeJQpAUkNLdTito6yYy4h3L+lmfUItz6Gj28bUnTmjm32Ul14/13w6cx2gYup1RvXkHu8/i9x34gtGpCeZFaWk0SmrAwoShrp8pXY2VKZlFVPCmhCCv3gWRT2dFAnUGSJn+ZnPmqQIDkWysK+hX3yzk7jNH2EVM7zVLOfHRRiwSI96wg6OY2eFIyQUkHHFDOy/1Z84jQzQrZ6iDTtYQFuUrmv12ymDy5XwypoZbF4xzfwhpfJkG7/NlpKEaBCnnC+9zDC5sOwg2pJgbCleDHGb2GR5IAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Change SGP_NOALLOC to return 0 with NULL folio on hole, matching
SGP_READ behavior. This simplifies the sgp_type handling by unifying
hole semantics across these types.

Previously, SGP_NOALLOC returned -ENOENT on hole, while SGP_READ
returned 0. This inconsistency required special handling in callers
like khugepaged and userfaultfd.

After this change:
- khugepaged: behavior unchanged (checks both error and NULL folio)
- userfaultfd: behavior unchanged (both -ENOENT and NULL are converted
  to -EFAULT before returning to userspace)

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 include/linux/shmem_fs.h | 2 +-
 mm/khugepaged.c          | 2 +-
 mm/shmem.c               | 9 +++------
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 93a0ba872ebe..d461713c095b 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -165,7 +165,7 @@ extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 /* Flag allocation requirements to shmem_get_folio */
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
-	SGP_NOALLOC,	/* similar, but fail on hole or use fallocated page */
+	SGP_NOALLOC,	/* like SGP_READ, but accept fallocated page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
 	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
 	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..3309d1c094df 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1950,7 +1950,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
 				if (shmem_get_folio(mapping->host, index, 0,
-						&folio, SGP_NOALLOC)) {
+						&folio, SGP_NOALLOC) || !folio) {
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..458853c506ea 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2524,14 +2524,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	/*
-	 * SGP_READ: succeed on hole, with NULL folio, letting caller zero.
-	 * SGP_NOALLOC: fail on hole, with NULL folio, letting caller fail.
+	 * SGP_READ/SGP_NOALLOC: succeed on hole, with NULL folio.
 	 */
 	*foliop = NULL;
-	if (sgp == SGP_READ)
+	if (sgp <= SGP_NOALLOC)
 		return 0;
-	if (sgp == SGP_NOALLOC)
-		return -ENOENT;
 
 	/*
 	 * Fast cache lookup and swap lookup did not find it: allocate.
@@ -2657,7 +2654,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
  *
  * When no folio is found, the behavior depends on @sgp:
  *  - for SGP_READ, *@foliop is %NULL and 0 is returned
- *  - for SGP_NOALLOC, *@foliop is %NULL and -ENOENT is returned
+ *  - for SGP_NOALLOC, *@foliop is %NULL and 0 is returned
  *  - for all other flags a new folio is allocated, inserted into the
  *    page cache and returned locked in @foliop.
  *
-- 
2.43.0


