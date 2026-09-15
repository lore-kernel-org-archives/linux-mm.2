Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59590C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700206B00A5; Tue, 15 Sep 2026 08:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6216B00A6; Tue, 15 Sep 2026 08:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC996B00A7; Tue, 15 Sep 2026 08:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBFA6B00A5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:55:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5591C0130
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:55:13 +0000 (UTC)
X-FDA: 85215992106.16.9DC859A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC1A91A0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:55:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jjRG63PV;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/nkeRu2bKSmAi9Kfn/9bTVutjRevdYEH4ZRY/DxYx8=;
	b=jkCzlnyUr3jA/86n1/DRIQmAezWBHr8HIUYsb3N7ggHFLoqmNK9KVNun4dzFS6dI3u06wq
	Js01PS8kUc7JMVms+TjlEatDGv7hrPiELa0FaqvIwN+qGnC+86Aky94YVcDEbDmDa1GYpo
	uOowuAlTzsFKyW5wxd0Ems3TjiKgD4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476911;
	b=asl/kn0ToaZBTm32YB+j5Jq3TCi6W50vw879Q+pl3gqslUakw0rVlylWt6sSuDf7AQrqrm
	tIIMBywAU/NBDty0VT0vY6Yt7TO38pVdCRybP/oXEZsJmT3QxOKIEsITG3zMkPmsZHM2ve
	yXZv+5rnrNEEd7cdN5Fu7VKB/HeOQJM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jjRG63PV;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=m/nkeRu2bKSmAi9Kfn/9bTVutjRevdYEH4ZRY/DxYx8=; b=jjRG63PVcCTPlnZu0EydQH6jUd
	EYH8/bn9jdy5AWDlRoLf7iD89DjjfwIQAGfuojuTPEskJprAuvanYlTK5R95nqfME/mvW/9LpLmS8
	U4zPpj7h99Y+LbhtfppTBy6GTB9MGjlO2Y/FWqQeavpXMMZwRh1BnzrYDu7xzElaqH00l+Cb6+16W
	3y9zzFaFTJnmobPEY+7/kHb4qr7wXmLMDCPbjq2EXLHLEx6rtGjPJxT+d8gBUOFeL6TJ9SEh8td+5
	s8S2vc4183hCzl6wkeyCVGezw31O4/b29yfMLQQQomllGczRwoAI84j4GEGlbewvgYf3F/Tskkw7Y
	UImVzECg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sgk-004P9q-1G;
	Tue, 15 Sep 2026 12:55:06 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:43 -0700
Subject: [PATCH v5 9/9] mm/memory-failure: keep inherited poisoned frames
 out of the buddy allocator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-9-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=2342; i=leitao@debian.org;
 h=from:subject:message-id; bh=4RHv2TayObkVu1Jypz4zcft6A7ZuNLPLOYHN84tQgBw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/eICMsY4l6GHi03IIM8MfD8gNmgSWIlOY/K
 iWYaIFog0yJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 beArD/91EKxjfaH0PJcX5tV47c0OR63POIWuptnAdq2ZMAnwIyJuXdqccB0buApoQ+unH4Fz1yM
 DgN18xOTuIUyU4w2lOzhj9QGuc0jLQ/Y3aYjxgPqrpP/hZXsqpiLQl+8MrFbwZ5+5tUkPvjsqQU
 qXDCQi+HyxPG8h/97OAnvi4goH90bAGaxUY66I8c6RW/HUHAjvqdwARlIw97g1dDHkfg5mTBkXE
 8EJdEjolj8X+Ne2bnEi/Wq2ydA6G9AePNg9pQ77bCq/P7+FOHWb1V9MKG/QbKTxFTMeVTCNDDZM
 HAE4OH+PATf67ofo+M7M4prlAwL8mRo0yfy2b+Sr9vGnO8zQIP+uRFW16H2+gCG6YNG8p8hx0wT
 DwUkPP5ltN6k4hf+q3jtnfQkb6WZUz5hwMY2kO5rYUWawRGll8yckWmSJfXCpADIcJxmMyBrsf+
 6L/mnF8ZmuzDsXZzswJvd9p1wc6Xeoh28jDinPgcKPYZmJj+gDaQf5fFJtUR/cSec3NMHcXv7Ma
 bkIKRrFMIQUqgyGfcEHuEtaN9IN+j3B/ZgDwUi/VF8P01m41M34JETR0uq86SpTzoojGjWAOMO0
 9vHeBTxiNOHq3jfx0SPr6Hu1CPuws7AAunT4VHmB1D6vqXgFHCtZKtQSmiWpnNjVA8kaQo6+/7e
 3q2cuVbNVfB9iYw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC1A91A0006
X-Stat-Signature: onqzi4r6dxpubtnb16ioh5wnu4fo386c
X-HE-Tag: 1789476911-313094
X-HE-Meta: U2FsdGVkX19A+s8bLqjBBv0Ana3uvsG4mNyXQyNp4NtclRebB0lJe1FJnSHvYCZb5P/FqijxiFbtzQuRez3b0Va8l6LUQbhKpc5AdskBzhuMycoMtb/UfxGfHi3osURf/2nx5SZiFb+8Jkb6eyaq+JBZ24BcncO2F1Fpv1e0ldvxPxSRYLqXeqHlFYo8c5qqHjYzVdeMg4zzywojpAtQ3X0V9PwEb4PF+w58uxh54r5Xw3XishAtEqikQHOK/ON61c8znAaXWn2E3FDZX7gPSUAObZpJwDZPvcrhI7EG/gK7RKY5p9YDSkDNzi59zvzMA8BZ7jsTJeN1NnWQrB7BpHKMzQGmyRMRmryCywM6fp9vIy5fYMBFBFh1tG7FQbjPxyPffh/om4/OfHlpNkFbqYtlJHME72ptcgnlLaEegaP/aO8I7upemH5+892EDSnXkU310FFbogMh4Q/WpHdceleLr9uiEt0pvvMkAmU/LxmdFTw1HaR7qjEzC/b5g7JNj86Ra9xMsFEGg1ukDUCZt9xM1c21hB1uQq5LGrgmyyJbF2q8wEETOrl4ZaqJ1vEzJthXaiD6dqipF0LydqQnTPAsC8dcky7Pf1CfpE6AvGhThOajmJ8QiFsWLpRT6ciANBZLxQsMnS42I0yFZQiUy9oGP9VV2t1feYR+4Q885YjBcQjR+rDeAhuy0mi6eDWPuYYa4P+cudyXjBGP7fcuuqlgNDzORqYpyOhJlwV7Su+kjWsY58P0BHOYZqmdf0KMAoWaI0ev09z/MnPlwOtIC8VZgqvRRlX10cDOobaFQeRXBPBmRbDZPmz7xJQGIlVU372+uJnxGeGkZg5Hbpd5VktOnmtdFMsA9Jw1bNLuJKC1nC84ikORwtPmxepkAR83O3/tMp2hjDRxHRq/tlQRR4kDOjri3o+bqcsuhBWVtNvNuojI4xPjA9pxM9jLwzloLBP/+4HrLeOLWsVzgYE
 tQpkwhvt
 aD+mxk802bTivG2l7ZtNTAgoxg0szqoZ01p9qcUvzq0GCyCcWR7DsS3e4LdO2sR/wcOMQ6vTTdmvibxWaJw/RCX2O5k3SjOWQLn42tch+2mZFBETZckUpfXGGHJzDUvwJe0K5zKAixilqcpAz/trOiz6kTu9yMVvrdaSvTbZAFSM2wLnw3oubaHupmAGn6dHzNEvK3/Uzd/cYD+a621vDkuuahgZlMa3gQ9moLRdANRgyDYlSk8zu/sEE68HDqrjY0Uwwl9IEAXXJDjRi+g2Ms15PgCrac1cG54XE8iIBY0XrFpxr4vVYna5YjWcLLCtqGai7EHtDePT1A+8iskheVL9Jam+Q/xEkGCdN+lFs0tHqqCznMABL1W6FzlskRf2L+e/N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the pages are being given to the allocator, check if they are
poisoned, and mark them as such.

Similar to unaccepted memory, hook it in __free_pages_core(), and thus
the frames never enter the allocator, rather than being taken back out
of it.

A block runs up to MAX_PAGE_ORDER and a unit is 2MB, so hold back only
the frames the table covers and free the rest one at a time. The
allocator merges them back up, so a unit costs the frames it names, not
the whole block.

The frames that are freed go back through accept_and_free_block(), so a
clean frame in a block that is still unaccepted is accepted first.

A frame is flagged before its memory block exists, so the per block
counter is seeded from the page flag when the block is created rather
than incremented here.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/page_alloc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b07b5f4751cb95..cca67a2702a421 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1597,6 +1597,25 @@ static void __meminit accept_and_free_block(struct page *page,
 	__free_pages_ok(page, order, FPI_TO_TAIL);
 }
 
+static void __meminit free_poisoned_block(struct page *page, unsigned int order,
+					  enum meminit_context context)
+{
+	unsigned long i, nr_pages = 1UL << order;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *p = page + i;
+		phys_addr_t phys = page_to_phys(p);
+
+		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
+			hwpoison_boot_page(p, context);
+			continue;
+		}
+
+		/* this part of the block is not poisoned */
+		accept_and_free_block(p, 0);
+	}
+}
+
 void __meminit __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context)
 {
@@ -1631,6 +1650,13 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
+	/* First: a block parked by __free_unaccepted() never returns here. */
+	if (range_contains_poisoned_memory(page_to_phys(page),
+					   PAGE_SIZE << order)) {
+		free_poisoned_block(page, order, context);
+		return;
+	}
+
 	accept_and_free_block(page, order);
 }
 

-- 
2.53.0-Meta


