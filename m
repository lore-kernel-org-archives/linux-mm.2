Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D60760A260F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JyzyRvRJ
Received: by kanga.kvack.org (Postfix)
	id 797526B05D5; Tue, 17 Nov 2026 08:07:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76EB16B05D6; Tue, 17 Nov 2026 08:07:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65DAC6B05D7; Tue, 17 Nov 2026 08:07:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4342E6B05D5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D431340431
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:40 +0000 (UTC)
X-FDA: 85444637880.21.D5617A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0265018000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyzyRvRJ;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okQA4ysbt0GoyeeAquPH2+CuQPaFH4ebJwUmvndIC94=;
	b=HYqbwVBoaeKNOtw8tzGVRPH1YeKbIaJc0+HAV0p6HfffW1m/6L9XjUgZI4YqZVEMnvvoYB
	rz7qcO2EFP4fgyLPqJxf7Z5pQ7mrlfRjPenmBVwvVlnCkAQKOhDog5priSIlbdrpaFd3/m
	4OXXD/WD44IoAndLq6IwM/GOTwLxxfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920859;
	b=1HfCnoKs3plk7i/k+gQ1wlhmL0MjSkLML77YPbHU3fbNY97JF5p1BUfk5hZa7x3dF+qrVC
	csviJGpW18v5UNXCvHkpXIbg01xC/bnVjOufutRoxLaHrUdCtJLwGLpiHzntmB4PxuOZlk
	80DZIVLDQDISL5KDjB5QUbGNpezl/XY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyzyRvRJ;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9814F634B4;
	Tue, 17 Nov 2026 13:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26FF1F000C6;
	Tue, 17 Nov 2026 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920858;
	bh=okQA4ysbt0GoyeeAquPH2+CuQPaFH4ebJwUmvndIC94=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JyzyRvRJpRWi+1vaFp6LViQmrRrGAKf/rrz6mXqm7Gb4bk0Gp202abACa7fJDKtLl
	 Y3vrr1uQK1uQm3/k+C1Lj0YaUW7JysXzLMtMpCLl6J9QFXQm3WqGr/5Prc7OtX9gwK
	 r8i/PXDJNhaivdhNHBUr2aHkdu8GwssfXRee3wC2knWvK5CM/IPYUYEm8kpANmBhss
	 ALaxHCs6aRSVUOguz01laJBttmBjJ+k4wupN+fvIUFyXoG6+zPgfu6mGz5mbmqXdI6
	 uTrPDeKsknTYfDmxPSjrBNv6Ls5x0bXxaxWJ3tkcqI2sbql3035nGsPlBN/e68O9xm
	 G/JCIeEnSi0rA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:07:05 +0200
Subject: [PATCH v2 13/14] s390/sclp_mem: Replace page allocator calls with
 k[mz]alloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-13-e518c99622c6@kernel.org>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
In-Reply-To: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0265018000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 98gaksh8of47ibrrnp9bxoke46wnm1md
X-HE-Tag: 1794920858-602975
X-HE-Meta: U2FsdGVkX19emt+P7WUavr3AqtnY4wAHFyB+TKX9IWlegXWBf/xKDRzH163Yc9GEWBRW92gpp69r92n4mNAcDEuEKIuz3YKPGCTIGSik3yn9YUni/67pOkXNSIUWs21pB4GloCH+sY6zYukSV4FicXvBAf8aFDVPRqoXqbbzBRzovvhp1pMay6EL8t3LJLMtzFoR0X1yhBrkLkID7Gesq3IseEgRDLBO58OfbaKIYaximRb/3N0Np+7pZyVcdDipBgBXI5wOaCQ1FYod4rPmb/Io82FfW8vXY/FjwL8QJ3lNsdNuD2MSa33meCmMTVYVQfNg7f4zJb5CyoWtb2xTADsxXrX+kT50gbxsFFx7pxKcmXrwpg2QHdvLK35ATpzpDUTCwg8VbbD+NgjR/zayJ7qGtBoTFYzgGyKzxX1zJ/SdIXTqYbjCouLpVhsC0yUu/aKuJlMP5TCiEN3/+mOpYuOGdaoeYVFAwovFZFGqZQAeSDVmkTt2jVunC+nwPjtsLJxKStXPk2FoamHBaiTdbzQ1NL+okUTEqge29DI9fBytol2OKgCw+5SkTq9H3ow97tPSHjqX5p84zZhj1uu4FAVg3AjL00zDcD7JuqSJl9TOPKfgDxQb8RaN5q1gkg9Vb3/FAz49osQpZsg1dcMcuk40n1y3ZHzF8ZVKF3ketywg7jAB+ab1htOq/IM8QFCoS9F5MglrJxFhWNWx8rJYL0DYZIWRpUf5OhZc19vOr97V3SvfiBku7bstZ+HO6JqXTd6JsPElFWW8IyU3fFADr6ywFFuPAwZioOMJtAtKa7FJxA1lGroXacKo303ONrIM+X0NDdygt/8BAdUQV+TDFn1QjOFHtzDcW1tU/XW/hVA+QbxdIUkUkIp3CoaFSq5+n/7Gy+Bmk6D1gk1EMA7JyhkzUr4jeocfUVEOnxpOI554gnbxfD5VItNwJ7zZDfsuQeaOi7DCHTIGj9KkdoN
 29+pSNz0
 ghYAn1V6U30UiTBy1DvvxtGRVBQG/q8dwxDEv2P2/Q/jWKrLn728veO/3yuaYuqGXphbHElcG7SDuEfc/Iprf204boT5vaoNID/feRc4epWMJhmUmraAT3oJl++VHbpUbDq7jNl+h/qc1r6DO09PMLp5lclAqFSPhWtjz21Uaamq/pWUqKFFAXx8gGKlZGtt7Em8IZol5FBD0t7Y46QsZEFq2ps2OP583I7Zt9F45/j4hlwPWGFZ+WW3O3RzNNDwHFvIkPKazPA8uaQOS2Nmhyr9KURio92NdC06Ey8pJZcDryApMT33doFjnuVx9JodUaY/L2MSxS7uMGlPFAOTe39Z+vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_assign_storage(), sclp_attach_storage() and sclp_setup_memory()
allocate the SCCBs used to assign, attach and query standby memory.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc(), __get_free_page() with
kmalloc() and free_page() with kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_mem.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
index 6df1926d4c62..c28460598d38 100644
--- a/drivers/s390/char/sclp_mem.c
+++ b/drivers/s390/char/sclp_mem.c
@@ -84,7 +84,7 @@ static int do_assign_storage(sclp_cmdw_t cmd, u16 rn)
 	struct assign_storage_sccb *sccb;
 	int rc;
 
-	sccb = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = PAGE_SIZE;
@@ -103,7 +103,7 @@ static int do_assign_storage(sclp_cmdw_t cmd, u16 rn)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 
@@ -130,7 +130,7 @@ static int sclp_attach_storage(u8 id)
 	struct attach_storage_sccb *sccb;
 	int rc, i;
 
-	sccb = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = PAGE_SIZE;
@@ -152,7 +152,7 @@ static int sclp_attach_storage(u8 id)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 
@@ -487,7 +487,7 @@ static int __init sclp_setup_memory(void)
 	if ((sclp.facilities & 0xe00000000000UL) != 0xe00000000000UL)
 		return 0;
 	rc = -ENOMEM;
-	sccb = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	sccb = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		goto out;
 	assigned = 0;
@@ -530,7 +530,7 @@ static int __init sclp_setup_memory(void)
 		insert_increment(0, 1, 0);
 	rc = sclp_init_mem();
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 __initcall(sclp_setup_memory);

-- 
2.53.0


