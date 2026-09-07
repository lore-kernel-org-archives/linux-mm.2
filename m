Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15B66C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0806B00A0; Mon,  7 Sep 2026 06:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A186B00A1; Mon,  7 Sep 2026 06:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150F46B00A2; Mon,  7 Sep 2026 06:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFB736B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82130A06EB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:23:59 +0000 (UTC)
X-FDA: 85186580598.25.18EF2C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E18A6180004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:23:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oY1Jyyl7;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waNeuygMDtlm0C03ZytfUl73M0zkpwkt1aPQuPSWLWw=;
	b=f5I+zWDGn4gJXgWt7fdQr1K5mo10FSQTJ170/MsB8Xa3QmIlHBqR4Rhk2VruHYTIARBgXl
	GSXRcbUAKn3hgXIDn6c1dGnvuuac4aofn21MVymAJe8kVsIbL+kytfoPuxkLajG6VEmK1x
	LmhDBsf7/iJ2fo4HmAf1WjN443joE+o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oY1Jyyl7;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776637;
	b=gCPPKF0xMH5wrY9m0q9A9tDSAaGFjN8MlwvOmaUhqAYVMDBEnsBmvvXH0SdgKvxf+WctMn
	jV2I1nY0x6BinYy0eMBZeJoGpGJT4ZphadlIBA4vnm5DrLhL74pAFN/YN/dgEKkp1QxlZo
	CbfkpNfyIK4wwmLubtxwPuYAs9lWVY8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2864960D8B;
	Mon,  7 Sep 2026 10:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146981F00A3F;
	Mon,  7 Sep 2026 10:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776635;
	bh=waNeuygMDtlm0C03ZytfUl73M0zkpwkt1aPQuPSWLWw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oY1Jyyl734MLI1IlG6XCXb4v/DmmBySm/AC8pfkMYVcXmqGkF/hjyTQcDBZD80YpJ
	 7uwhf5PYBWI28sW1JGHFu1y5Wk7Z1m56DS9JvQL6uy5HMyozhGkHivDmKGyskrTefs
	 o8LOAeDkyU0s82i4urqcpPwBeo2KcxJ84nLsV5dTDXRA8+mK5tjZhjSCMKk9p9nbvE
	 6op/bj4RPPJ2wBogea0r4eyrZUG1sz5JKKHs9i2ULWFzRm3kAptGou79gjiq59UcGS
	 410iiaD2OL6Lk030dIYPUJ8kUb2n2z+J/7vL+mr/OEQYBIHp0VFAz4I8GIG5gkm2hi
	 j5O4R0aXsVYIQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:42 +0300
Subject: [PATCH 01/13] s390/chsc: Use kzalloc() for CUBs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-1-ca7f39806234@kernel.org>
References: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
In-Reply-To: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: 86tpbngomt9tm9s3oc1senss91gxk86g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E18A6180004
X-Rspam-User: 
X-HE-Tag: 1788776637-674813
X-HE-Meta: U2FsdGVkX19G2rEdVuXzFSlrlEMhJCsffcJt25jCCGyoV0BgewLs5HEIrcczDKeuLFGz2Ulst7k1+g/iz1yghiyTHOjlFr0IY9W9oxGJah3Ottipw+A5JcawLhRpg4vXFmbA8RngwHaex6Y2a1V5ZcuSkAOTgOIxKrxVlI7VlfAiT4xcn55+Yf3zP1+nAg0mdkjJLGl2WmtwqWLZFdGN33lUUSymZEsGRt+8oFlz7NcgWy3NCHt61/SXw7vWwNx3hUQOxiwgE3x41vxq54GlMzVFqx8CoDkIy8fLtYOaDJ8jG9/kc7K5jN/xDsy5HnAf8jdOCA/DGONOSfG06M9iFlLgccXVOzEnvUn2XyUhQww8qXvRUInJeZhAwjVwuqyh5Kks7XLQ0YaGX64IpiemY144MCVRqvNUQMvRlFi2XflgeS+evm7kkfgeT5dGsV09pmotYl38W6J7EQgJg+75UXh3gnixnJwxGoMzM9226JKycq88o23wmyR0N24/rwrPd5zJe528Fy2D6KzqpV4fcKfTs2S9N2FdbWNxddX5lYeNJJYSSPGUgXC2lNKYQfPXprM3Wos0aH7xM7g+KQ/zSfDEv7K3/lJKfkP4SyFVnHBmPy5DVoWGEw/7mEB2gueyGtr3NxjPmMWA88CjiJuRuLCg04NiB3ii9vdypH9uXLUAouR7pGv2aahR/ovfHB1oedj5kZFdMN+2VbzdZC8A/hxlwBrievt2ssjR8QVdM1CO4U8TEtIu7hi5he9+hgoKdiXM9FvadktjjEDUCA9An7FPUJCBu0bqfNKjMcO82cal+KQO7EhBWm+ECH7yfFU2ECvOLIKExSOPc+rztsjsNhNrchGnHTNqqStQFW1cGqPrhH52l2nPTm3Erkq9OyyuBWuhQYy3434OicUhM4su0L5aCRwGEH0eC+uPn2rMovmOAnCmXQjqRiAUgpjy4BdD0Gr4bCDFLq5YjCSXSkv
 6ydiNwsm
 qtbrB77hIGDHN6atvbD/gQSLzla/GzUlR08mat6jVK+XxQHBPjjdPSKqUXszZdvyrLM4GACc4IuX+mXPb6hzzgLbZH+ohgHsIlqbibWO999MRW57itpszsNiHYgnKXOzRw6PYmyrhuEM58MuIxQnOObgYMivcqkw8R6xCm6ZaU3dtKELwOr73KZz+h3X3LGX0tRP19ePb8twu8pmn010KvfliPyXJzAq1JtLW53nhs2swI6c0ByjTjYJGr1YZrD40kM2jcArDeRD8Vso=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cub_alloc() allocates the channel measurement unit blocks and their
extended counterparts.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

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
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 9689f722c863c..60a4a7e6086ce 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -931,12 +931,12 @@ static int cub_alloc(struct channel_subsystem *css)
 	int i;
 
 	for (i = 0; i < CSS_NUM_CUB_PAGES; i++) {
-		css->cub[i] = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		css->cub[i] = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!css->cub[i])
 			return -ENOMEM;
 	}
 	for (i = 0; i < CSS_NUM_ECUB_PAGES; i++) {
-		css->ecub[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		css->ecub[i] = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!css->ecub[i])
 			return -ENOMEM;
 	}
@@ -949,11 +949,11 @@ static void cub_free(struct channel_subsystem *css)
 	int i;
 
 	for (i = 0; i < CSS_NUM_CUB_PAGES; i++) {
-		free_page((unsigned long)css->cub[i]);
+		kfree(css->cub[i]);
 		css->cub[i] = NULL;
 	}
 	for (i = 0; i < CSS_NUM_ECUB_PAGES; i++) {
-		free_page((unsigned long)css->ecub[i]);
+		kfree(css->ecub[i]);
 		css->ecub[i] = NULL;
 	}
 }

-- 
2.53.0


