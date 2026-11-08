Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54743606A335
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4DzYOfY
Received: by kanga.kvack.org (Postfix)
	id CB43A6B05C1; Sun,  8 Nov 2026 04:04:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF626B05C2; Sun,  8 Nov 2026 04:04:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43BA6B05C3; Sun,  8 Nov 2026 04:04:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFBE6B05C1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAB6FC033A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:49 +0000 (UTC)
X-FDA: 85411366698.17.EF43CCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 34850140009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4DzYOfY;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVjgamAGA0x/mZWw8oJ1JRlsWUIipJQvor5krq7d3j0=;
	b=JMMO2ZW9bigyOpmoKwUluObR62aVHKgKYDrfTm9gXY1qbWOV7CaHn9N9ARzQ6AXbPU9oNu
	v/LdKjGu5G/g14JsUXf5GoZDKhaSo3pfF4lAXVvwO5lGINTc7U8P3Qmj5XzMqu2xZaxis/
	LGQA0dDU4F9mINttA+I8jZpFvp7YlT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128688;
	b=tOICKUHUt0zdvZrllEq2MiwUkknYaq6lNmeTp/I5/aHRxfxfuXNeYrpWomLggXBOJRtots
	qFxeGLBYJyA0/nCfjqLRs13kIRfys0nrZfjnUY1gjuGUWwChZVt3iRp4e3Wy/Mlb4YDm1o
	1FJafiuBS8iVao7OcgzFiqdoZCsCSk8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4DzYOfY;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89282417C8;
	Sun,  8 Nov 2026 09:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56F21F0089F;
	Sun,  8 Nov 2026 09:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128687;
	bh=eVjgamAGA0x/mZWw8oJ1JRlsWUIipJQvor5krq7d3j0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P4DzYOfYNpRbO6T8CYFXNnq1IhQp48EHXievjIGpiy3BACYQFcvjL3KyJRZwqh+uA
	 qhfQDqBKIIXyC1gG1kE++/BvsT76oNepBCCOx5K794qDV7i5N0VYf3ERP5ke20A5DO
	 DpyGnDNQFh0imMrn5G1IglH7GaWZDQ4Yequm1tZnpheTKhvAMqSHFFNeoEPgnc47Hv
	 WXudf89FviD0dDWOrBCJZITICnzXB2LC0Y+2l4Y9Ae/56mYkr6AzyoLgi5/lFeISGP
	 92Ac7foROfQ68mlMcVcaCblVODN4QtF65d88cAwOcGqKeZAEZI86FunMvQ++t72NtU
	 anWRlK+FfxxQQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:39 +0200
Subject: [PATCH 08/14] s390/sclp_sdias: Replace __get_free_page() with
 kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-8-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 34850140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 45rahxop3iz9nb3h9q9stum44pe3fdik
X-Rspam-User: 
X-HE-Tag: 1794128688-572680
X-HE-Meta: U2FsdGVkX19/BMQC5vCjRYRl1bBID6Nh+H6cuYq79DULfvSWFb5rrlc7vdzhPSeKcWLzLZ4UZCeHlFNprcWy6RkxhQGj1SXZlEHQ8VfdizeEMkgTz7gt1RY6zIDIw9bzhQSK4SrCEAX8+LMH7tA6VSyT60t8RLE9hdjmoy2GoMTG89CN5BsT6VZuJ+XkypUY09QiREHESF7EnaOtpflDm+Le6TNaYVIMmrq3lt5LYTtzbjMuIv9OnJsAdm3/m6GpdtJgDRUyv1vROlAIRj80Bw/YX54kgwwznL9XWg9h6KV1Xg2ASLEbwvvgjEqfdLcrSNdKwUcoXgfSPNFvQlHauhFjru+zHW5UCXOUzBhNYl1KB9AQeooGU72zPGiT3NojyO25BfFhaZmJRn8tHg/2edDVzbiaN7qobOnsOE2y+2VFMuknKZInDS2swq61QAZeIRUqgnYBn5xFBWXUTqc8AVfhQXMdyNkAEWhKaiAP1WeivyUUYpLAXK4Dj5jXy9s2fdQlB/7Cg9Q/YnlLT96LIqJmD3Ql1oPYdXvh5ff8FZ1DyR8XS3eJa6JB2jRhSvqYj0nPspeZyH/IAkVLCBBYvPJ3dYotYg1xxLzDWJ2E5UQiCbTR4r/3KeC36pSFAuNpKrezOwQJqfKZO9lUlL/jEVg5zU5Py/+KteDiehXOOjzInw5Heb1ERGuuW45EsXajwDyooTteOK0tmS+YPEDBDRdQOyEHi2LSTfJY+MthQCpGgc5PxdXfBk58fBSSmi8HuAimfgnXROo4hJCPkABjX1WHcPDyVR87/OLKEW0+AwprHcuuWX/bITqGDTz9E4FfNwbLuQoaN8TyQNURENgKZNRqhV9d1xiGUkPirPA26gg2SD/hLyshwXI/99Vi0qhOjWDg7OjO69ITbtAX0yu4dBk9mOh6SdO1dr+ZWdL/HRFIywpSk7FV9UMJRB+8VhEmp34dpKCH8bWzEzBwD10
 AhijpanY
 ofpDrAregvebZ2CY5/3MMmvwqxafsJsPJekL5X5YkCjQ0ZgLTS8ejZU+ynzvamLsnpURwbjV/4CnaleUaJg1FR4KhLE+GowzpL3hjI/m3H5ZwMX+3876iD5RvC8Skc2ZJi/5jRFk4CK/rKuCph9LldvWRuEtOHsF5yq+fFqjA9KgeFoO2R2KMqQLz47WgmnMWvxFQ6wdfBU3TQhy4W5702rGcazB3ABiIEBvYzw9Alw8Pp03DeuNBAzm/TqnINwsyla6IdZapESeSwjCzprDAtIANr905nKSu9x2gIwAGGtWSbM8rl2J5NZwNIw==
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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_sdias.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_sdias.c b/drivers/s390/char/sclp_sdias.c
index ab8f1b758a1a8..a1a17a9e4a910 100644
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


