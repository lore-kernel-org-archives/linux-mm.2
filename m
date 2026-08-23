Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0101DC5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 11:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6676B00A0; Sun, 23 Aug 2026 07:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1810A6B00A1; Sun, 23 Aug 2026 07:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095E76B00A2; Sun, 23 Aug 2026 07:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5E236B00A0
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:46:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F4E4A02F6
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:46:49 +0000 (UTC)
X-FDA: 85132357338.05.C6A4D72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BECFB20003
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:46:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VyWudsJG;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787485607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YH6xHkx4+EyCoseoSiUf2zwvyC6OW03ddFXTuW/vMMg=;
	b=ni8qjMMtlYbjfXg+t00smd+E/OoFO01wrRFLAsrHRrz9TXHY3Vs7lavYEw7bXCibvlJhev
	kmtjuPqonwnzHpnJUiHUtzsHfZJ7OBgkLFwUlzN6iFMsEQjKSt5G7haQ1KXuhheLL18cm5
	lKXlxlCh0ACRnj6r70JmKAEma7XioCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787485607;
	b=N1C+A/8Q3C0OAoTf8m3+nvFSJBz2buyE/5pyjeQPonjmeJxM/BB4nldzKk8+PLki1bcKvk
	yptbGd8ZdfcXVBaz7slHVH4cPwcSnOXhAIKlZF1W3/xYBW/nKj7ancUSFjOGMudomjEtVj
	wjFZPOs3eoKVssNhrPR7YK8erZjVVxI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VyWudsJG;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4041840103;
	Sun, 23 Aug 2026 11:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B91F000E9;
	Sun, 23 Aug 2026 11:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787485606;
	bh=YH6xHkx4+EyCoseoSiUf2zwvyC6OW03ddFXTuW/vMMg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VyWudsJGZZyn98IpDn33fiJpcRQMtFjwf269UCpmwdtR/WVag6vsK83RuHax2TL3s
	 TTyVaOEq5dByB4DENbbp14bUpoLk16SOg+s5gq+Yo3DpAT9OVRlgf7oUH/IMx9Tl4B
	 gBh1M7+s2LbOLsQMlvBF49yV5I89L6IAiDhC9+MGX14RBk1HvhY4FgKXygUbjXtSV9
	 WgBhXsUFyhGVNDe1SfV1s1oULI1r/gwIibyPFizfUTqYWrr6IwUdQIps1dr/8NfM/O
	 QszJm+j6PVZH6tLf6zN/NcQGt0UL5noV+oU2bZ6dJA1SZEfZucZIu9HdqTF0dbp/8E
	 VshKjRX91/aIg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 14:46:13 +0300
Subject: [PATCH v2 2/6] mm/vmalloc: set area's page_order after allocation
 succeeds
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-execmem-set-vm-perms-v0-2-v2-2-b013a37d84b3@kernel.org>
References: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
In-Reply-To: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
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
X-Stat-Signature: 4b7u7pcgps8sr4qd57k3rasohput968z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BECFB20003
X-HE-Tag: 1787485607-693494
X-HE-Meta: U2FsdGVkX1/wEuEdZBMKrHjkQQyHS9nJ2jsd5m7jRtyDdTXlZNE5t8D005h1V73RkmRRlYxw0jjrxQddNx6lC9iHC0cbKwf7tia9QEYL6YQfuTRuCSop6uczYMZq1B6Djiooh02Pex/Gv5cwZHX4nSczl9mIpM5BKNVmX6gIxbY6R++ThWrTcKI7nshAaHgQ1IyPx41SfDh70GXgSb2kU8D40dej4AkCtmab701CXeFWBzHPXhnzcZ+R/3gFHFkzUL/ZdHM0Z2PjAQMfbmXyItRSM0FVIoodeEjmIwZYVuHYqkVk89EZtFYD/rLm9EMFqRR6r7z9g282Eb95bUP0Zm/00LGbVc2T4lP9hbSkzzvK6EtRUT+iQ13lnaPTvThH3rCAMP9U5ckQy/rW0MSHabmLbgNVdA0de9TaRJ9Oywy1Z9WEeyBpj42MMNuYCIn8q50VszxKF+/Ls/eknyyooedmJdR3dlVPgLGPCrUW2G7fq3mSnxIhcgHf1mfpNNaWxsxbtcfO84KoKJ+PvD1OxxbFXBLM4YCdq8mJ/Asc7nVDMgaYRf1Ym4th07CYB2HpMy8K8JILeGSqDyd6ccnQZgjX5RdzGAli0w4faJX7wqbc5NukP55EIopQNNo8kd2ylL7sDDZGS0NlhFutlUTru7ZyITwJn+Ok9vd+mt+NmbrfqDrTlRfrqFoGZLixIWkw75BSCQPJ7KQV0tqhqJZq5hUfg0lHfRB8G1ggsc8QejVyiHGCviw07eORLQH/KdC9rLMBInXV0ixurPfNdW69IcEu5j8lk8M8Z5THlnn2OdNtgvvY/ccC+ovhP4mQkACb8m1dtXCBO6R2u81Pk3Qp47HaM92Oxljg5ip+BUrj9Z3OMn+M4oTO5XXvWW5n8uvjoDK8HU1+k2I7VLGHVK6W/Mv88Q4WUO9CghgFu9Vb5VTRCOLlqjlwjv8eEMAH9bBljsc7zd7CfS9N5uOfJzl
 H4CO00TW
 QQFQ6p4Efw/jWrYeIso1Z4PFKIhUfyQ/27HaW9lT6jFJP3QVtyeZHzU7jed6ED4h4LMHxofkJnUNos6Ewg7H53KMDlJ53ZjwEddOBFqBVhhBV+dDhBPaHlpAnT9LzqL7QwMkE6G4Gd/M4DsaHtnzy1OuEwVBW5u/uoC+PlPo5Az45gvvDxMfFVKQ1foUGfPW3fIx6O0s/iuR48s67OTVSrg7iwTdbdQuiFsMFoMOnjmAF9dHubeuDHKUZwsfIuXpysKrO5lfC9wqxkxCMQrlPCUESMAyXNs+MObN8uvdbg4N8zevDU/v1/MRdiup0IFNr+jxd
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
index 22566e0b6e38..9bd94e2f2895 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3873,7 +3873,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
 	unsigned long nr_small_pages = size >> PAGE_SHIFT;
-	unsigned int page_order;
+	unsigned int page_order = page_shift - PAGE_SHIFT;
 	unsigned int flags;
 	int ret;
 
@@ -3901,9 +3901,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		goto fail;
 	}
 
-	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
-	page_order = vm_area_page_order(area);
-
 	/*
 	 * High-order nofail allocations are really expensive and
 	 * potentially dangerous (pre-mature OOM, disruptive reclaim
@@ -3958,6 +3955,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		goto fail;
 	}
 
+	set_vm_area_page_order(area, page_order);
 	return area->addr;
 
 fail:

-- 
2.53.0


