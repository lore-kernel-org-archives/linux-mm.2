Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811E610A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF5C6B00B1; Thu, 26 Mar 2026 22:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7556B00B3; Thu, 26 Mar 2026 22:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4E46B00B4; Thu, 26 Mar 2026 22:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCDBA6B00B1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DB638D1F3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:26 +0000 (UTC)
X-FDA: 84590226252.24.4F40B47
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id B8E6980004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZIxjF05t;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnIHRq/fqfQAry7CsjH3C0Gk1Kzxzc2ZoqIQPSTrMd8=;
	b=7l43qoclKbXUgbGsXQWIln9kMrE+VL6rW0Exal2aZci90vVEPeHv8diw6x+guf9NdiYLc5
	op6EEqZzRZDolnjYWUf7BXJwul4L7H8IxVOvdkqYeYDPDSdC0KGsfSl0n6myYE0g7RmpYf
	x70LdZTtwM9uLdcLq2TFs1iWh00ETdY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZIxjF05t;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577724; a=rsa-sha256;
	cv=none;
	b=vrnu7UWQNd53raToYLQPUaY0yHP+/3xUtlnr3XIdPdUXvNew4qcMnHamT5y8DdAkSwBGhA
	dgsPvBx/NaiabIDg+9pxDVdwQBaiTr4yRpRf08ObR9VKcwuQEC6rBL7KeaZsMdujKUTxJq
	lglSGCysRt3Yu3/wmFTl2FzcZFVL7WQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MnIHRq/fqfQAry7CsjH3C0Gk1Kzxzc2ZoqIQPSTrMd8=;
	b=ZIxjF05tNow9dzUHFs4hqWlnAIWjdc/ZiKkgAVcRdwnfvfmpyyBGO5uiLBm/6z5QMsmkqr
	ztEHZPBtu0iiXBGTFC271TxvM49AQMco70eXk+ARnt2wNg+T9bIFsUICK9N4z8qczvq+p2
	or1an7NL4GSoQ5bKiLd41MfIKi+EWcU=
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
Subject: [v3 11/24] mm: thp: handle split failure in userfaultfd move_pages()
Date: Thu, 26 Mar 2026 19:08:53 -0700
Message-ID: <20260327021403.214713-12-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B8E6980004
X-Stat-Signature: nzoib3z1x5fu474threitx733sffetyi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774577724-296237
X-HE-Meta: U2FsdGVkX1/q8S6rubCh8zN6cUUToW81kp57IRqGwxGeWNRMdOo8NF5eziTd9CrEUW++9iFg4dFAmVsGsC2ii9e0ZtqdwTOQDEJGfKSvu9ERTjvMSR0RtnKkrDCcBCEaG0UeoUXHsTXseGBUIaFAMU8iKKK77WqPT1Ln7ZFwneS91dRvGbsCAzEt5be17nQwam3/0fKzfUO7vF6ZoQYiAFSN+/hSbZuA+pgto+U0BQUAbPKKL+CE4JPhC6Mr9CHEVFKMZemcv737QI5p3Dhzp1ygVl1nhqdZ6aPGGmQah7VuEYNkVy3CmncF5E4gw4sBs51zgcU1tVFZeG+n1Zl1sIGHViMUbBp1Abr8pdssOIKBhCo5O9rR6ykM+S6b0b92EAQ2iP1pFM2kdmRo6s+fJ/B2noDXZ83lNLKb6jxVXKsXC/mDcuJrVitOjK0FeaSjTmHGKHjGd55RiQ5NhKAPxiwqFybe3niPkFx3kVenV7HDLdTxYW9qQHA63kv6d8vtPaxIznkpaUoL3MP+YxdOpH1uIlKInjnKf0KueN/jam67ICa/8+e/6Ndn7uFVxiCkcgMlwSUUITAXiwSkGsKIQNopGeVY8YetQUSmLbKQa3CBE+f8VM0XAHHmNgJqwrqLUXhTGcQSQPXiGuSG6lGZ5ZENX2+TOk9GYO3W4GzMLl+8PCRFD0KLe4ZfVpqLDM1qlQ8wDkDOhZdvDR1bOv5gv3tEgPLc/Fn/dmUSGZBarNyukX3OPg7cfN1sOP82Z1/KQ+1zqtYqyHchwoqhoxYndIiUk2lrF4Kh0O2ocWVXfrnIJsJnXyvRKm8KTm8U2DHB2l6iWQ0EndwnTtw5+AL5JiFb+c8xErp/uDor8j5xRgGRgB1SlHGrRJ84MQAzrilk3VhiPtbI+R1jlByyiPbWwqnpJpPbK5FU08Ey/eFmPvMCdod/sxuqr9Y8ZJTc8ReGyEn9k1G/tDYVbK3TR7z
 LePmA4or
 5JuReMjo/LYGLCNFfvr6c2aZnSCLdH1sA7CXRGYyy++NgFQySr+Cl0OeelbTG21g08lNWkofbssAJW8IQ5hRw7b/AXZ6VbSid/9oPGUl5ZGAbQNHCTZnSIDgnt7hVu6HhlTsfqK3oLsosMn8eNotvmvpCLSAkLmkHf0X7lTTejdgrU3YBOgTnOskIerOiFAqjD/t7558MXJYxQSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The UFFDIO_MOVE ioctl's move_pages() loop splits a huge PMD when the
folio is pinned and can't be moved at PMD granularity.

If the split fails, the PMD stays huge and move_pages_pte() can't
process individual pages. Break out of the loop on split failure
and return -ENOMEM to the caller. This is similar to how other
allocation failures (__pte_alloc, mm_alloc_pmd) are handled in
move_pages().

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/userfaultfd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 481ec7eb44420..a04d62dd1e065 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1946,7 +1946,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 				}
 
 				spin_unlock(ptl);
-				split_huge_pmd(src_vma, src_pmd, src_addr);
+				/*
+				 * If split fails, the PMD stays huge and
+				 * move_pages_pte can't process it.
+				 */
+				err = split_huge_pmd(src_vma, src_pmd, src_addr);
+				if (err)
+					break;
 				/* The folio will be split by move_pages_pte() */
 				continue;
 			}
-- 
2.52.0


