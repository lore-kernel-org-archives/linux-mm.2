Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4A0606D805
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmRapOy4
Received: by kanga.kvack.org (Postfix)
	id 4EBB76B05BD; Sun,  8 Nov 2026 04:04:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BE86B05BE; Sun,  8 Nov 2026 04:04:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A23B6B05BF; Sun,  8 Nov 2026 04:04:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F39366B05BD
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 972BAA8040
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:40 +0000 (UTC)
X-FDA: 85411366320.29.26895BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EF7E940007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmRapOy4;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128679;
	b=MMmUbLyQ0f3YlG4BQxVkdNNjgMQLY6dx1X8sXM4Nfm6nFlkEgKuvo8DUDWkLMDlj0425pk
	TIiW/ndl3xivL6ctH6J32F1MqDYcBaErRgvTDpDJZhiAiY+Nl+WOgMrZw0EVBA6LYQNjpw
	cGHWNfZbKIcbEV57b9eDesPT7RuRYdA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmRapOy4;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Fekj84/ogn/fq4bKg6J4Il6J5X5oZC9LiyDjaHRbcE=;
	b=CRWjgm6gLnz8bGlOuIg4iBquYyftsgXXPyTDrcFdoYw9LUl9l81dDO4k6jp7QfVaRUmB7k
	piTQxcZDMQwognYL4xXdw2dyPoTYaPc6WC3REC6XpHr50otNLQb+Lr5KJCNqAbplxpyTD4
	7OUf31+2AAuNC08XVFWmj/UaaXdRly4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41AA74470C;
	Sun,  8 Nov 2026 09:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAD01F008A4;
	Sun,  8 Nov 2026 09:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128678;
	bh=9Fekj84/ogn/fq4bKg6J4Il6J5X5oZC9LiyDjaHRbcE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lmRapOy4NqvhzXhzk7xPJQXImpvxDVibo0juEmmKPRV1XVxgLZY8T3VnhUYswyGbg
	 Oa67RyP3lSP8LT+koDXLye5576tGYWzDdfFdBTBh5x/DJ1S/JeHRmkyWiq5oEFdSB0
	 4Xlbt/BW7blWhz6RrewuCbCik8OKgsJrz4z2b5LnwMRjbim3miA/LOxTsm0yqVLaBy
	 mgLQWIsmAVkFXAj34xtzQzWfwwOCVfrLTn2MIzc4+q1sty415nctK1SmLgzsgAAfCs
	 wccjt+DMBSYV949bSTu6RJc65l5z3snium2a4QclzAApshdh2GVHl+k8KVGp4k5Tbp
	 lua/ZKTVx+rYw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:36 +0200
Subject: [PATCH 05/14] s390/sclp_con: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-5-3e7c90eb6676@kernel.org>
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
X-Stat-Signature: ud5kufiu43rtu4rym4km93du4p6yphmd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF7E940007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128678-900823
X-HE-Meta: U2FsdGVkX1+dfMU+Wr43Rf10u9fpgdGQ9JOg4VoKBl2X8H0PUzpUuS21WWMs/N07yUmiXBqoSS+klHd9UNkYoq5yz9fOz6413oqWTPBdGLg+E8XHasgwKyHHEEkri+GC9Q3RsDv5Nd5+mNkq/ioqxwmFmm3T+VV1e1dMteNzj0rxPSyx3EWs8fZzOi+F0YhJ/oZjfHseZ71//Ap2tE2Hg4/6KltmlImeftm/hRm0z7hCERet658KZMMnA6E8DtkRXpv3E62hXipwUWGnDNQaQIJE2fg5gxhino+Hobu2qAbCK8nVksGRTYE4UlYkxCYVm+svY0T0NIS5kd2d5YVYK3yTwEYxwx/1oRZTEdasvJGDGPoX191uW3vF5b3B5RKZSQ87hSlU1vH0jTnT6jpAyVeIi30RgJpGl8k5QqbBotSvMUvmzL1LQBthpOrUOsS2opeUGk+U5TQF9/QZHflrFk9MXNqlskNz9OhpzXYwn4XNhWEvEOZReAtOwPtjK8EiN1h+WXQYKCFN1uUAKZACY0fFz4/lkvX4m+lv/8SqQJMop3RlgDHsyjBL+TsH/A4wuq5k4OWY6eE5JU20SkDJL3ZP2EN7ouIf4aRl+JdVWG2RwDfSp4NHviNPQvZBOF1xOTUX84gBLio/3ZzbzT3Twb8L5BsYH85ZgK3fNAuso7E1NqoXBo+rra+vRxiCKcoKMD2MxL2hivXUYs/swfjbyyp/dhw+0ktK2mESzhTsB+Peeqd082hUoq4xh6YMLaIIkWfaVoeBn3VXQClH00rBWL6rVoq8mPenYkjS7nhWgW+o/b52Zv1apr3IXE1TFRwRyqzGvklBF33wJMUkAczWmjB081y5ZTfLkNc/qFv0dYxjV85W5omh160kMkmk4gDwF/kmqiNVyXfyR1R8SygKoiwIiR9RQm/8hQRKt6I8tD9/baFupAKqPa58ET3E1yxpcPrMlFVZDw8pDLzOQ1k
 UHsaemsV
 3dG8SqcEdI39njPzM8Eqzay52Ub3WiZQRFO3NM7Sa+2WtMhCPWk90Ec184Lkr0ndi8CJXdHYW2Tq8tF5mspU19lNsz9xNHQD4w1Kvsn64tspqLuIx1ah3XhHNrEEOpIvgipJw46hbqxQb4pNmSQyTyFwFmZXAikpwxhDhPvyqOzQeUasMiDTk+8Ah3/cTRAtUpxJKIZ3mfrCN9k3wrCyZWYMuwB2aVph0jYaKWD9KPBsbUoVnrJ+MsoMajQWmwKgXngdgo3LkLbhYns7NAoNqZgA8UJLwrHVDkGjuUcFKU7ZsQk9AnBl+LEGPWw==
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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_con.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index d8544c485808e..9d096d7b59687 100644
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


