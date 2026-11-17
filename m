Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006A660A6F4A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+q6aiil
Received: by kanga.kvack.org (Postfix)
	id 091836B05C3; Tue, 17 Nov 2026 08:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069C26B05C4; Tue, 17 Nov 2026 08:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE86F6B05C5; Tue, 17 Nov 2026 08:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C92F86B05C3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A7371C36BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:17 +0000 (UTC)
X-FDA: 85444636914.02.D148BDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B6EF820010
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+q6aiil;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dN106rk8Vda8DnkqLVSw3/dUsMv4evAL87wVFveXVvU=;
	b=HVyms4nACoRuOQSVFh9oBWAGBZn7lYWNGHEliinBoEO0WvPkUxLDXSzQoq1cnhjwUyYQ0G
	D43EhbgNrGVvb1BtweB8trk17MEfT0vEwQ9fJj6kjJTIwnd5LChMnHZIgbrpOgTA06yuk5
	kUtcYdSWowfJhIR+fkJsJZuKVA7pZRc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+q6aiil;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920835;
	b=e8tRqsfp9dD/FNGl9RVzUahPXFQhjzLENrZ02mEgN2vjWKq49slqqdWBOH3AbYW0j31Zoy
	6iGNbGlJKkYX6mf+qjobJotqdKM/5rvlyJyFnVqyJaR246PKZO3JxbRJub5mQzpNpjUH3e
	i6adLeDR7RvN1+mKmaR7GMf/k9+EEcU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55DEC634C1;
	Tue, 17 Nov 2026 13:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE0D1F000D4;
	Tue, 17 Nov 2026 13:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920835;
	bh=dN106rk8Vda8DnkqLVSw3/dUsMv4evAL87wVFveXVvU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G+q6aiilbCrJFplxMnAJ4ox9tGFe2v6WCRwfe/GAzx9B/vXRwxgva9X41ZySvPIXL
	 spq8zdgFwNFFSC6ql8lExGA+vhl3r8cYdu7bwv80ZyQYjQdANfrJNT83gfAMYkZmYf
	 IhgJ1vjFd6XRsKs/+OVnrwUK21h42O+gTpHFHRyE1lc4bd++PuIH26QW/xhWG1U+50
	 rEMx++GA2wc5XTnItlcHUs/NJM01DmPVTrgKUbAWuT5ji8oV2W8MegdQ8maha1lVqk
	 /DXq0t062EFzcG7m7JCWIQLvXpIQC66dd/1bbIm3nn0GIxIHD+ha8F9Bwbs4oea5Ij
	 vL6ZgzGauQpJg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:06:57 +0200
Subject: [PATCH v2 05/14] s390/sclp_con: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-5-e518c99622c6@kernel.org>
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
X-Rspamd-Queue-Id: B6EF820010
X-Rspam-User: 
X-Stat-Signature: n1mxepoie716pnzjudz3mqh355fjq4tu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794920835-443197
X-HE-Meta: U2FsdGVkX1+sN3Drmr/L7aEThpE4TTpI7PPOq6KRMVK4V5xAvHwJJCvBintS/bsrrygXs4tBRlQ0IKchDJoS2IycD8D9JG6CZQmMDj09s7BNSXfPQCy5PSsQxjhI5iyWX3c1hPI9B6mEBvKBJ73eTuvua7PLbUULt3y4jDEx5OicCsncTqH32PDLsDr4uUA6PXnFPtPUvKp6CkinLqUJMw+kYCSVd8Z8l7cVanDd0NcO0l0UoasnKDROnWk51O+TT9+0agGrEctz1Si0EhJJLaExWpIHsdSdVk4bnpY8HsRMnXN7ouWavZERlPzYZSF2NoSBV8DaVubrxMhewaVgP+FksqsTypwOCETC4UjHY1svnuuZcazjn+f5XYGX4MLM1l5Zrredm6GLk4MdSlRC+YNdgyKZrAf2hB7XeIfKXrNOgGaC7t/La1wnCxrw4pI7UYp9t9J1Lgyt6jyZbVlR4+yKG2UCdlUHJpG4DOmim+dKuvs1XptE2dGRUU695ifleg62ZgDxXx39t0s2VdbDylRQBOyUb2uDfWKJefDpbm7SZb8Ph+rDqEiSATvXvhWE/JJlngVOLtohAeMXhN6jc/OXTOSNN35+eaee+KLMtHnSqDf//jSkJsMrzPBSzgYwxUeOTNPJcrvfwE4ZJO0OmnsrR1iHvF4oIKRi6TuL8cQsi9i9aVu6R6gBh0sFB6NsUPI4PYoMhfKg9AIo1NX1M4PtyJFC2Cczi1O8/2pcADR4B+yokS8gZcZIVCCWeLWlV0HXIusUhLZ277CsWBz9cu1nN0/GhQpctL8pJCrjAyYGyWBwZEVepuemkaxq2nS0COSpW9sbzRzJSLtrIEzvwKV+2bm12m7zVsO90lu0HABOYsfU/NUQQIwItJD6YfANmwtlHt6DVKxCSkSWOaQLX/1hKWFoeiaFGE0q5x3g2WTDtCah9ZwIJXDGCFAGsLtdIH0C3mx8YwX0MOHK3w6
 pPE/7guI
 0qI/dYoFnIaAMs5WZGF/SJnciFjdQxlioBCBRMrB3h/fJ/YzdgZPFywPk8N6VkCpdbLE9qUeZx6nxo47fea6gkXODSnetlLI1qcBWQXd5lg01xu9gV+ijkzxUKZ0fDmHY3yO1+m0X8ya7vDzqtuhh5kPq3MmF4gNQs8xDF3bKsHGk+o+kmsJFQ9bIcr9pA0ghujTN4zqJE3W2vWlDXbpBh1tmZaDKjFQV6hCfNXopWIvyFaAR0nGEUpePCqvNQwByztxoYurRC3OWQ+q9Xq+HyWIAwPQtToF45fO+X39Ezn865CzL1eYvC8gx+X3Rd7otu2KvmfjPG3gxEO8xVSuvfin2+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_console_init() allocates the SCCBs that are used as the output
buffers of the SCLP line mode console.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_con.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index d8544c485808..9d096d7b5968 100644
--- a/drivers/s390/char/sclp_con.c
+++ b/drivers/s390/char/sclp_con.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kmod.h>
+#include <linux/slab.h>
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/panic_notifier.h>
@@ -272,7 +273,7 @@ static void __init __sclp_console_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_con_pages) {
 		list_del(page);
-		free_page((unsigned long)page);
+		kfree(page);
 	}
 }
 
@@ -294,7 +295,7 @@ sclp_console_init(void)
 		return rc;
 	/* Allocate pages for output buffering */
 	for (i = 0; i < sclp_console_pages; i++) {
-		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!page) {
 			__sclp_console_free_pages();
 			return -ENOMEM;

-- 
2.53.0


