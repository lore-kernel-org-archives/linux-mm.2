Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00021C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143116B00CB; Thu,  3 Sep 2026 05:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11AC06B00CE; Thu,  3 Sep 2026 05:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036976B00CB; Thu,  3 Sep 2026 05:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96F356B00CB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:29:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26EAA8046F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:02 +0000 (UTC)
X-FDA: 85171926924.08.E569F5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 56243C0005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvGUm0Mi;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJhY/LLxze6/C4vFouS2rlXgLYWhmWyrhw9PO0Xdt/I=;
	b=lpM3OU2x95Kl1eOKdAAqjQHZ5eFWO/nP8XstGWnc6Hm8fptGfP1kWNm6fXydPNkwLbvUUc
	SdCRh/tnbrpcHOxHKaiqaHERU6Q1Ku7+89/64+HIrrlTs1U5HGGcd4xbuDkf1Tow+02bqA
	t/2HKtDFgAcnbUy3UYgqMJitKS2Y1Bw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427740;
	b=QMAsV0PDhVqBIH/W3pq9bUZhUlMqaF1v9jP7ymHvwdxk/WdW186nEPcg6eWDnwW02DSSAU
	d9u8a1EeiS1YfobQURY6f4cRrmHSzS3ETVKICZcSSEBl1OaBuwkRYDtfRX7rbAXMs3ZGsa
	m12WoaRxcPtqbrXedQjTh5ZxSxzdbCo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvGUm0Mi;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EF9141ACD;
	Thu,  3 Sep 2026 09:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C111F00A3D;
	Thu,  3 Sep 2026 09:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427739;
	bh=bJhY/LLxze6/C4vFouS2rlXgLYWhmWyrhw9PO0Xdt/I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kvGUm0MiVrWc44SB3atJmrKskdsgB+xhnX0hruGashawEDHD/QVsPbyy7KprG/8ZE
	 BS9PmQYMBNAQsLr55nz3Bzs68mggaKckz6sK4u2yAdNaApWoYDtLoqEJ10IRUHCNAG
	 8ygkoNniX3OSmRgfBOd0y5JjygJMJM45E76llZtQKymOV6OvJE6cw0M6M63buMOfnT
	 AWjDxnKzI3V4HFoUmMzR2sMo8Dvype3bEmrojXDAR1dQxqiScXqIR/5uufmylbqQWI
	 fnv4nfLZD/txHoHH8QtI5LaCYJ3L7ox1yqTEgPPIgEJMkDH9dso642uH5MlYasd2hi
	 hWVdUu0Wsm41g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 12:28:28 +0300
Subject: [PATCH v3 2/6] mm/vmalloc: set area's page_order after allocation
 succeeds
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-set-vm-perms-v0-2-v3-2-949b64a9f755@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 56243C0005
X-Stat-Signature: re6cxdgbfzdccw89ko5rrknq9iqd1j8b
X-HE-Tag: 1788427740-242348
X-HE-Meta: U2FsdGVkX1999I49Tb7t4NM1Tjt4woohlwkmgkMybCJIbFwcPr4idNw3RxWdgFa0WOosJfogO/oD4aVFHH32aYC34LmGypivbNhCM2hDRr4MZyIVArZNplu00clwYUpzx9tA06+UYMbgA1PS4FHMsvvOZLBWRGqdneaIXqoSaf4v7RpnJyKBfwteOHo+8XioVK3LBeAuZX4zVdJB9OYiuI+thA8E+cdoHu+G/3Q9bmXsbJ+BcKej1MsoNK6mZqHl7b1lxnBId1w93uWFfWkmZwHB54dTNwjYGFGCbM0OnQ5l4m54Eh9kCJPxIMfldjQqqlffPSC+C+myF25Fn3dtJ2j8MAX/xpQmAFicyPspRereRjxvWWAO+OnOnSR3f6wJFO/+ofltLg4J6rD5RvmG/vNOGq8QfefimObIpB1sL5gUYVDceupb8ie6gUArZiG/PNDjKgD2dLMwzpkEHNpOMJIf1mk2NqBlHaTsgA7oofQxkNiD9TTe7eKmothFUi0paThQPbHyGanirOWjT9Md39hFIc2fg3ruUbcX+kD7a/gGW4Pw6U35iqNiQDJDN6m999rxmjXezEd8IugRi2poiMh3K4QXNkpcGjFbl4lZapF+EU86lgtQeepnBDgWmE4tBBPn6JL5+AY2E5TB+S2VVp3u41R21lrIQCKTolKwUtwJF56lbrQkMuLshyyGMS6bhFg5QpbhjAdTMNBP5N2gxXEaDsH+XvvIId6s5UzidKztH0lsJuh6FwJnjTiw0BDLT2Sdry+EWVrEAgkPKVj6OxH2g5YmsI+QPcLZQc0TG3kceFMdomJ24D1NdqpDgnmxS1O/R+24C8YibNqGaKOv02etEyg7iwtd2ZhnuFaMgg1pANrEsc0gmrn5tdLaBgkuFKyjSmU3I74TdnfmvkPraL2B5YCcA8heHZzXaCijcrfRNqeIzpcQ3iPWwgvJRHMdzH3ZBmUApI368yaqv/5
 4tStyFEu
 lxgZT0Yz8DGBxKEnVmCImqQF+QKSwczI6HzJlT+Ne7UJrbgvccYCF83VdOuxAX7y61P1Pz8U4DJDQl6xFPZKRER+jDv3YGlqsmtLr9kiWKq4jUCS7g6qiBrcS7mMs3ducUkfbZ67fdD1yyz1RuWP7er9oEoDfeslKtjNCSFnwGVP5XWVcLy0aXlO9ad+RqMNJ/tK2MjXSaCVW5s3iwTTpGq7s6+lWGwRJaGd+YZOfFocnCZAfwVuN9JzOzxdIuFwJPlthiCCx3xpB4PQr2GlvqFKPkrMHehh0FZGgMrNzNrtGi8pmqcp7573zx5JJHSa7T+k7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmalloc_area_node() calls set_vm_area_page_order() to set area's
page_order before actually allocating pages to populate the area.

If allocation of large pages in HUGE_VMAP case fails midway, this leaves
the area with elevated page_order throughout the cleanup path.

There is no actual issue with this because the only place that currently
relies on area->page_order on the cleanup path is the loop calculating
the direct map alias range in vm_reset_perms() and it anyway skips
unpopulated pages.

But having set_vm_area_page_order() in the middle of __vmalloc_area_node()
makes things very obscure, hard to reason about and error prone against
future changes of the cleanup path.

Move the call to set_vm_area_page_order() just before the successful
return from __vmalloc_area_node() where page order is guaranteed.

While on it, initialize local page_order variable with its declaration.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/vmalloc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0380917392e68..22aa554d123f5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3879,7 +3879,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
 	unsigned long nr_small_pages = size >> PAGE_SHIFT;
-	unsigned int page_order;
+	unsigned int page_order = page_shift - PAGE_SHIFT;
 	unsigned int flags;
 	int ret;
 
@@ -3907,9 +3907,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		goto fail;
 	}
 
-	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
-	page_order = vm_area_page_order(area);
-
 	/*
 	 * High-order nofail allocations are really expensive and
 	 * potentially dangerous (pre-mature OOM, disruptive reclaim
@@ -3964,6 +3961,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		goto fail;
 	}
 
+	set_vm_area_page_order(area, page_order);
 	return area->addr;
 
 fail:

-- 
2.53.0


