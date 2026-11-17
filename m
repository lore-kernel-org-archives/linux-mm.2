Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECE260A6F7F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QmVRn26F
Received: by kanga.kvack.org (Postfix)
	id C79156B05CA; Tue, 17 Nov 2026 08:07:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50AB6B05CB; Tue, 17 Nov 2026 08:07:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F8A6B05CC; Tue, 17 Nov 2026 08:07:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96A0A6B05CA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31FCF40424
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:26 +0000 (UTC)
X-FDA: 85444637292.26.0CF2FFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8C326160013
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmVRn26F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTxINdq1VtsyQZerh4nRFT/F142s/ie+jkHVMDTGppw=;
	b=edp1oU6TV+CQLzBTNwpJxiaSFWA8sbB3WLKHLt8OSZrOZu01LrweVHGJo0QAoV3eQ7nCEv
	Pn+Tpw2EfQQjfugqPtz+m53+tL8OmPi4gmiMDBceUrH7r2U2WflOf+mdsjfn7JPOsvDt7w
	85tqLACDdQ72cC8uJiFlmrrVTPWpbkw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmVRn26F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920844;
	b=7lv19bPkturW+rjEGH125aCUzF4faOufg3ESQM7rVTcEOh3UPd0r1m5c41MqBFleR4a+Pi
	gs5uIHBdLZHLc6ihj+rBseaugxBeJu7s/a1ifni30pxg1d6uuUcDlO/V9ZA/2g0+mJwiUJ
	UPCHQqevsTeA0L2AsHxP8HZU4lp7yGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 249AB6347C;
	Tue, 17 Nov 2026 13:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709AA1F000C5;
	Tue, 17 Nov 2026 13:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920843;
	bh=rTxINdq1VtsyQZerh4nRFT/F142s/ie+jkHVMDTGppw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QmVRn26FANsNS9lNj43FkQ78+kse1D98GXuyaYK1IRQIqlvhskvpx3WlSrXW5H8ZV
	 whW5A0u5RxuCHDx6litDOkVDnXCqWTrLmL43UQYoEAiSa+yE0JT2nCUNQ8xDbWtYka
	 2YSHahOpnY25iDyIBECpBb5Qx93PbmKuLmGS8o2VjcD9nvihTAqGsk/BLecr3FU10P
	 IC+5vMAvqsVgAGi0os0s2b2KV2bdcfpdwUGXlTsLz0s921Seca3/dW4K9AoHXJ50PB
	 Jz+JVsCEGWBZRcdzLnS1f3foBgjLXmXJff2O66iamJAHHpagU/+Z6AUmjXF+G01foz
	 +/HsN9lBrV3vw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:07:00 +0200
Subject: [PATCH v2 08/14] s390/sclp_sdias: Replace __get_free_page() with
 kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-8-e518c99622c6@kernel.org>
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
X-Rspamd-Queue-Id: 8C326160013
X-Stat-Signature: 6s9eazxqhhhwp79hyaiwfm3oyx5iuei7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794920844-901855
X-HE-Meta: U2FsdGVkX18OVwa3rnyrxCw+/6BV8XNbo0dcMyENwYZkXGxiI4xXuO1FjOkw47WPtdjwLa+iNUVXPAla5byOoGIFoexY2yTGkmFyGxClarkWO697a24DfB66sv46emp+iwW0JXMa4AP3GnwnTWnyO1wqzQoB/zr/ghwBKFw5DIQ45vbBd5J66iqjBMVrRb3ephNZJcGuDPrUsu0VZagb4x8y7Ks3VSpdel6wq6fSFAn2XG0bficQLBFwyC5Rd4SkgY8fq6J/uA0MSa4jegK9hOg/vtaWLtIFjmacN8LgRlEuYek38sItsVH+33GVjF9kMR0koBcpOjnD75oYRFApWpTzdVxjLPdCHrGEmIXoiHYrymV6JWmCy+5lmEHIj0UA++nDy1UC9bbRfX6B0C4XClE/AS/uktN+qPNA1f0HrXyuwDg2dDfS5l6OQONdXbxEW8p0hkuqIh+3Onm3vPJHvWN9nMO8rp0O1XeBCcKJ2UIkS/B/+a/IfXsdKfIUVGUwboIq9bp2X1Og6fhsbrZvXnBWy6hha6JOX0pTlg/o7g0z5V4sUFDIZOBKmA46FeBBJYxVXCy4USQ2lSmX7TLyztxQMSf5VWjf9vSgL4HS4UGdx8csB7ZmT4J7EugrTpRPQXpiZryEjih1I5fJDIqE8NWgCBWp+Z0yVDMCjLVpI6453YpI38hTeb1PQx8LIZItkh7KTi4NTzwWpRsa39BqKbDLWrik2Djb5pw0l9TXmoV7YGdnTbWhLpSdAfLMxkW2O9Vn2jpIJcdROas5JukY64bOV6IJUP8W+kf8kTN7LNdAX/9MtWpb6dULCE2KF6yaAwC5c+pU1WG6iqU8ybmRpoRPgRo3+0t03SaEgjC6v42sB3J7VbqM7i0Xx5lslbTea5N6ABwxQOOdUi1bn7UrQx9nxZs5z9wJcfnszJKP67qeQE9FNdSoECoYgBVSr26N59bW1GV3S4wh+vLWwRZ
 1ZLWMRk3
 K3nZThBmta7mXYrRoEBS6M7l4Ob1xSGZLOG5uwF77TMfhil2REv3P4PAgWFHoSoXr5+TfEiS/Y3Vl4Sy6dxp0Co2is48eKgphm+9BifzkXTl2pDyWhv+cp4iMAr9fVJsg9QgXlJeV1ALPRTaJ7qC1ZGtU9jXV71KhaQa8V8RSlMl6hn9QngnsVJ+LdN+mQA/kZOlPXLHMKgovBu5cHijYOXkZXnUDZXiM/+W+v93f2k8P32GK3eqeeYxzvY8QTcqWCkebi96/TerWxzFjf1ymFFZ+C3eiqgbiw+PAH9C0FzRzvt4f3dZqKsXpNY6LlbXOgn2eZGt6v3Ws0aV6i4QfxhnjXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_sdias_init() allocates the SCCB used for the SCLP store dump
information requests.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_sdias.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_sdias.c b/drivers/s390/char/sclp_sdias.c
index ab8f1b758a1a..a1a17a9e4a91 100644
--- a/drivers/s390/char/sclp_sdias.c
+++ b/drivers/s390/char/sclp_sdias.c
@@ -10,6 +10,7 @@
 
 #include <linux/completion.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <asm/sclp.h>
 #include <asm/debug.h>
 #include <asm/ipl.h>
@@ -258,7 +259,7 @@ int __init sclp_sdias_init(void)
 {
 	if (!is_ipl_type_dump())
 		return 0;
-	sclp_sdias_sccb = (void *) __get_free_page(GFP_KERNEL | GFP_DMA);
+	sclp_sdias_sccb = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	BUG_ON(!sclp_sdias_sccb);
 	sdias_dbf = debug_register("dump_sdias", 4, 1, 4 * sizeof(long));
 	debug_register_view(sdias_dbf, &debug_sprintf_view);
@@ -268,7 +269,7 @@ int __init sclp_sdias_init(void)
 	if (sclp_sdias_init_async() == 0)
 		goto out;
 	TRACE("init failed\n");
-	free_page((unsigned long) sclp_sdias_sccb);
+	kfree(sclp_sdias_sccb);
 	return -ENODEV;
 out:
 	TRACE("init done\n");

-- 
2.53.0


