Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6CD2C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812AF6B00EA; Mon, 21 Sep 2026 06:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E99A6B00EB; Mon, 21 Sep 2026 06:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A706B00EC; Mon, 21 Sep 2026 06:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3036B00EA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:37:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39B5AA0120
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:37:04 +0000 (UTC)
X-FDA: 85237416768.07.1EC549C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D5B0C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:37:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Sm+COEAh;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789987022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naFDCf3GkD9lXGBthmsl9nxBW1AXYF+pDMjxfFEe1Bg=;
	b=cGSwq3xpGwN3d7PmVbOybCNscqO7TdZwt3egWoNqD2hQknWB/GN5vc08rIl2cKZpYsz5W4
	2OzQPHczRoZEgkqxrY7Smp2io5amix2eZdTXinxHQt6SSrYuS3zRkKdwpl6p3BJyl8k8Oq
	xNE70tMadCB/qGJsL/mYLQtSrEdc7M4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789987022;
	b=Nl8k29MSF6r3gazEBgcbNHsYt3k9xrND2SebJsrZpZodzZJ/Kqyn2E+lce7I9rAkg8iSDU
	TMAbSd2/V2xp9u9hggM7t2v3XmPiVebp3wpmB+sSg3o9U3zF2xABYpjkjim/Qy3gt/g0RA
	iRpb+Br0X5ui6TQAlc7WcVfpTKoha7U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Sm+COEAh;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2235D143D;
	Mon, 21 Sep 2026 03:36:58 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D96A3F86C;
	Mon, 21 Sep 2026 03:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789987021; bh=z6zKDPWdrXtG9iLWi9rtRD0L5GkOLNqFKE7DfB+aIRQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Sm+COEAhvJbXTSdK1abZne3xFxB6pXb9NGTM8dWI3ctOJqcjdGKW4iQgJS2OopPZ8
	 qBYUaMzOpghOMjBzAKhdtOMIMsfnFH31FMGPVCGhR+dlJ1AwUQg85wxnWzdrAzz9bi
	 o49yIVomAqB13hDOwWi5bsI05PROktlr9/a87Uo4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:36:40 +0100
Subject: [PATCH v4 3/3] kselftest: mm: introduce size_to_shift() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-fix_hpage_macro-v4-3-cdea4fc6ce3f@arm.com>
References: <20260921-fix_hpage_macro-v4-0-cdea4fc6ce3f@arm.com>
In-Reply-To: <20260921-fix_hpage_macro-v4-0-cdea4fc6ce3f@arm.com>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1684; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=z6zKDPWdrXtG9iLWi9rtRD0L5GkOLNqFKE7DfB+aIRQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQi9VlnrICVKSmEAUcfLz+X3SNTnPnmmVJx4T
 PUKUnuuRKmJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEIvQAKCRBt1cPRWsUx
 My8ZC/9Q9H8MVJ1jK7QQreGRH10Hzcsa3P2Hyz86kIi5/jIeguUvGUmUfWV7D+4Dq20FpNDL2z4
 ub+riKgocduYQDaixCZAwW06zIzSDCdAOoBp2H+2el3O+IAOA047HBlae/74X9sSKf8zUFNqrIo
 kBXhwpONsZWj9vdxpsh40ASMPdytSthFe9AAbYOmNc0Mh04BNg6jtifRdVQbSeHwz/+o3oBXiR0
 o0sKMi6IvpMZAU3zyUJF0Sq7ZqogFjEv8gHl554UPQG7YB8ZwhEojuHw8Oqz0Kc/NEJBiSVBwc4
 T3n7VbgQmCBXaXuoCampv/myhHndZvfcRQj0DzldVPtXtTdcKUhU8F6XwXdWrCQR3OTv7USxsk7
 KW9HvBmr73grKKE8CGQklYYQyuwvCbd6Mu54ezU6S71z+OJCDxXUVteRnVSXHTtkynKuqOuAxyV
 DowvbkpDAHxqDZmRXcMxQTM4YzxQUeqyGDy93DKvTRXV7hnInJGpBCGWpvXwxHJq1sLJk=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: gppeof7jhth6udk76h9tmt51dti4yq3f
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D5B0C0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789987022-930390
X-HE-Meta: U2FsdGVkX1/Fbr1soluG7Non+dyxDiTiKwpsAeHV2rAVDFv9yPSwep4FH/WhDVSldeBPZhY1c1d99HGuGJ/4k8mYv0g/U7E74FTx6V4om85W5AoVkcPH9xUCor0B/X7oHvpLK7TKKcLgE9Ziam8LwbakcRVK7gQpdAsk6tRABSQX9WWYLpLWyqj07SeaBKT5le8uKCpMvc3mlHy8TA6HXCxRMSyP3SU/aVr4nov6D362jhr1fA48ufNAb26u0MPXZQrhFk3VUFid4Ys2o7MpU7vFpNdU0OL2N5euKgRpfT+S9QRyylesbShFxfuJwOUHJQH5wD6F83dDFli+g2xcjGANTA4te32lvT2CXtPlobkeoEvBH0Ese9/73/XA/DEJTxbirkrjFx3MlxN/gTbO2evDvV4333NzmlOeXY8KaH/YHj3k7kf0ZUgALtNnRJ5oFegtndeltyDML4U5DgjPLcueelBg7NnajDonurTvFbsHlKfzcjyIRf2vhi7HCAxewIaaNmZ0jgA4jnm3PKOtef15gSz8px/2YaSyP0LiQVfzUr4IKgQSj24Yo+vRBn5zCDHveGlw9maCjex0TKdK1y/SyYieFcDxOK1Tak1i5en8qnYxfet1djGiBw7XLcDff/9i2a8zsptGBUFGtYzlA/KLUTXar8sshpG7H6aflhz6FBgGZxNtZVHSwnTaNTVbSCir+QXyzTlhzHduh3Ax0X3CTHoxpxZ4C/LAysKKiRSZNFWoUcV0lE1IUUyTH6qvj7824SeocTKAlzUbXgE669BiX0RypmSAxdh79aTVpUo2pMAxFxj5DH4M6qt/N7E2/Rf3V3w7e0uGmv6lcegLRdR+MiYucooPDMsua+Ok00y+38icqlRFJBBfP0HsScDn1ORUmrmLEXraUs+a6+KhPDAGyAIPboiA5Ec3icbf3c554KJIUsSGHnWnEm4hr4RcxAxeNQcXQxxNlbpG9Ry
 31QpPlYr
 2dWeW3pHa48S/qZOiHNiR7b8Ub0J8xoT+r0xakFtrXxImMI+a7qjXSupOlu2x4EoSaT8BEdLFpxOTTz8z99aoC/FqnzTQ17MMD7iuMHrGd+o6BexWk5JZSdGe2d9vt+balqaoofeoTPEW+LNnxqtl8ZgCj7hoMANog6no7B4kQ+yNrlmEeCyfC0k3mzGNSspohWhWghHcosOEqq0HrQikM8lkRlBFK5reOzXtjVGE4bN2R0B+Er10oql8NJ3ijN3kroEl/t+DKZKZi4j17USDpsozmqcmGAQXDPvYgmfKybhJAPaN+ttUw9EhdMZ90W8xPiKDx7FLQqP6r7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce size_to_shift() for future users that need to
obtain shift of a huge-page which is other than pmd_psize().

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c |  2 +-
 tools/testing/selftests/mm/vm_util.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 8f80e73dc22a5..970671058397d 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -194,7 +194,7 @@ uint64_t pmd_pshift(void)
 	if (__pmd_psize != -1ull)
 		__pmd_psize = pmd_psize();
 
-	__pmd_pshift = (__pmd_psize > 0) ? ffsl(__pmd_psize) - 1 : 0;
+	__pmd_pshift = size_to_shift(__pmd_psize);
 
 	return __pmd_pshift;
 }
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 71af4804f8f24..6e37c90f3c3a5 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -148,6 +148,18 @@ static inline int sz2ord(size_t size, size_t pagesize)
 	return __builtin_ctzll(size / pagesize);
 }
 
+static inline uint64_t size_to_shift(uint64_t size)
+{
+	/*
+	 * The function returns the corresponding shift only when the size
+	 * is a power of two; otherwise, it returns 0.
+	 */
+	if (!size || (size & (size - 1)))
+		return 0;
+
+	return ffsl(size) - 1;
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 

-- 
2.43.0


