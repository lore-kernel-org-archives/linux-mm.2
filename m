Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B354C5DF9C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 11:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097E66B00A2; Sun, 23 Aug 2026 07:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048776B00A3; Sun, 23 Aug 2026 07:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51CD6B00A4; Sun, 23 Aug 2026 07:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3C8C6B00A2
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:47:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 554AE1A02F3
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:47:06 +0000 (UTC)
X-FDA: 85132358052.28.7990996
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AE55AC0004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:47:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIM7FsVq;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787485624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JNbaKBJKZiPBWFXiQZSzBAcWECdyW1psqwwnhscXogA=;
	b=5TULGB/iy2bSj5ssm21c89ZP7at69U238O91Tv58SWeo7g26yjrgMkF/5YeRny/z8sk5eW
	QW149CgRjCkZ4PJOLgUEiVRYQLmDWSQopugug96w5yPn8x0mrO6JKgTrTZpFykwetVUxX9
	79jkGT9jms54vNvyyBeehppAadywIZ4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIM7FsVq;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787485624;
	b=OrlttNXYb2Sxcej8I2PtgKrCnH/jgvCkH6/2u5V1XgDc8u+PoREkK9bsfNlI3RUWOv45l6
	OuiYqijCusMbwRpjFMkw1O8RLYFgAuH4QnGc0OsYCu8cv13diQSPoe7yJLQ7wX+r+FZGXC
	5DVIRAWIj8gFfearYBeWskzmh8+0SZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D5F9600C8;
	Sun, 23 Aug 2026 11:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879281F000E9;
	Sun, 23 Aug 2026 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787485623;
	bh=JNbaKBJKZiPBWFXiQZSzBAcWECdyW1psqwwnhscXogA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MIM7FsVqFQDwxEVqELOzWyRouVAcV/zT99s47WF8sDGz0/F3hE64vb8Nc7ZGQ6TZQ
	 guKkDJgym0SQoUX7GbxQVEzrbPfAdBfUlyqfFTws30j9T4oZBaJ7m1FzhBRlM8Y541
	 hk6+RYrgiHCw7kuAJrpr8CJzF6KPkdCCz8i4QVZemN8l3ab46v110aaqS4AR28vYwb
	 XER8Eo2D0JhPLqBYOMP72mYryOFYB59Iciip8vmWeHAvcBSgfnOEyWj3W057KVdhr+
	 06QPG/smqTW3N4dHyZfBcpY04dITAwYDaqovV12DxZIUwhAjWFVLe3/5Bz9DqWxsND
	 NhbUa8zPT1Xug==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 14:46:15 +0300
Subject: [PATCH v2 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-execmem-set-vm-perms-v0-2-v2-4-b013a37d84b3@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE55AC0004
X-Stat-Signature: y9irm6bhq3ia4u8t5y516hwjjj793wtj
X-Rspam-User: 
X-HE-Tag: 1787485624-801229
X-HE-Meta: U2FsdGVkX19fV1sHLYZf3l0c1NJshShSbe2hcSHOysyyztVwEdVFa8MvaiGdG1CCM2mC0YdZbCj378bAnsc7PHSB3w9dYAzsZPvJ8PrQ7QlpZ/Ap9zmhXgc30/1XBjYhjh37191SV0FexvIoYC2N22aRJFIdAnAzJzXe6QUphKoxHrHQKswYycoXO3eZ3K5Aov4Hy3c5AWwzKJyQcUUmnHJORfQNM/P/LaWMkByKi8oDtivf6x27ihDZ9WujbWWBgsahr71Yym1bCjQIOq+k7FVbf8yK3Qdi3XkmS6k7Gd/QbZZ0vNIBrfCTUWXGPHnJLflkmSHCZxkfaWY7Gh+t39rErGiwRGunILrn8nQA6VQqytb3PWBIlwiT24naNq7uZCXQl1Z8G0gjXgS5IWMJf60Sxzpkp7z/ZnCm03nxt6/YBoQb0MkFtuWX1612aZmfUjkeHHchz25mdnF73AzhLc6h2L7oUA5s+RDRwQtEthHfsy1PKrjc9flTaSNSofHnektGsGGVyOzLxTJxebzcXsRtJ3xEcVPIoJ0y3PJ/iPl6VBZFJggZXvmlv5sqNaY5BK8LKyTq1QqU3Q5a59WbcOOUxmc6oQq1dCyJDeDLwUY8YknLwkbisILhVDaWAPS8X+nW/fWTYSgBzHUIqqXJpJovoRNaqtOyKNdivfWywtMi+5HAF6IbjWuOA/P+ON4/ZL9KVpXTglGIC1CctvEUSGRLSB+2Ndk+WDPXYwNrYpTo+8r/jujEO3I1Ol/jtgVEIGFa1RzUSeJf8+ox0dtUPozqHjuRSjfl4KewuuTNL6bsf2NsDku22Z9w7OwlxMG9R5zY4cJ1DSQDpVJjTYynMNujDOxjtAtgJKiJju+O2RREdRgmd+CVU6+tDAfejaqEbVY3Fp0Le1hfctkPe8FaQ93y5gBDnhw1dUPS4eoejBFNO/B7CUOORfohPmp3Ga7/AXNF2dQn/j0oaAI8gkr
 Rv1JNZQ7
 tk2sPPwU4jff3+oetDV6ro56GjD6/jRy0hESA7imDyikIgh/HLGy19I30gIwxJP8BJrx8uMMVrThF+9APgT1MLMeNViE0hKpdKPCZh7RTAkRvYMwqi+CWtgthQhfTmZf1gdRA9smYZ2ofqUvG+Qvun4JO/pKzoFVkbBfOcxVDOwYyC6GErONJ68Q3bl+4X8eMzepJJFuQfJBJtgxe1YDX7+sUiEd2ZtwfqvnhHEZ+/b+SFWh7LmsxFxTaUXatGFMudNoz3sPoXeirHKG6cAh0UZiwjJGgHFYnxuHM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

set_area_direct_map() always updates direct map alias permissions in
single page increments.

For HUGE_VMAP areas it's suboptimal. Not only the loop in
set_area_direct_map() needlessly has more iterations (e.g times 512 on
x86), but it also causes fragmentation of the direct map that could be
avoided for the HUGE_VMAP areas populated with large pages.

All pages in an area are always of the same order: either same-order
large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
cleared or when huge pages allocation fails and fallback path is taken.

Instead of updating the direct map permissions for every order-0 page in
an area, use the area's page_order as the loop increment and update the
large pages in one call to set_direct_map_{invalid,default}_noflush().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/vmalloc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a3e2e4244c0f..395358b363fc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3361,12 +3361,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
 				       int (*set_direct_map)(struct page *page,
 							     unsigned int nr))
 {
-	unsigned long i;
+	unsigned int nr = (1U << vm_area_page_order(area));
+
+	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
+		if (page_address(area->pages[i])) {
+			int err = set_direct_map(area->pages[i], nr);
 
-	/* HUGE_VMALLOC passes small pages to set_direct_map */
-	for (i = 0; i < area->nr_pages; i++)
-		if (page_address(area->pages[i]))
-			set_direct_map(area->pages[i], 1);
+			WARN_ON_ONCE(err);
+		}
+	}
 }
 
 /*

-- 
2.53.0


