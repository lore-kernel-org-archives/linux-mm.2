Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C19CD6E52
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B7C6B00C3; Fri, 29 May 2026 11:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCA06B00C5; Fri, 29 May 2026 11:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2126B00C6; Fri, 29 May 2026 11:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8D666B00C3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74BEB1A01DC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:29 +0000 (UTC)
X-FDA: 84820773618.24.7CACAFA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7CC04C0020
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C+RyvUKQ;
	spf=pass (imf22.hostedemail.com: domain of 3gaoZaggKCJQyF1z+46H4CC492.0CA96BIL-AA8Jy08.CF4@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3gaoZaggKCJQyF1z+46H4CC492.0CA96BIL-AA8Jy08.CF4@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCoU+OqdPKjZv36ACGpsB/y/JO/SUTxBEuaSym4ONwQ=;
	b=pQldQnaZuwXW8GQHVXByjcTpHOdShIfc7KXZj4xxJEdReIqqaTf+3vafDcwKhsMY0+iukE
	t3NKzAY6nXt2+qbdPJOajp5Lt+B0VyPIuTZb1GJDV24FEPXNTukxRZdBhWteYRrgGtOKRd
	SVX9jNejQr9X2A294omC9G2jmTphLkA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C+RyvUKQ;
	spf=pass (imf22.hostedemail.com: domain of 3gaoZaggKCJQyF1z+46H4CC492.0CA96BIL-AA8Jy08.CF4@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3gaoZaggKCJQyF1z+46H4CC492.0CA96BIL-AA8Jy08.CF4@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066947; a=rsa-sha256;
	cv=none;
	b=PKVNMbOauwPKA09kPd0Lka1cL5xWAitkJDk6GZ660En/OM9s50LtpIf203AyPuzJttG2ID
	auaqauaKyqJf9QauV7k8ZYbFlIkcu5XWptiW5yCSiYF49GJ5FZjObE2Xwe9f1EbQjAyW47
	N2Mcvx+LD/Vs9bJFMaHnOcVjNx9Iejs=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fe44ce385so105595215e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066946; x=1780671746; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uCoU+OqdPKjZv36ACGpsB/y/JO/SUTxBEuaSym4ONwQ=;
        b=C+RyvUKQzfkmXNif5dlLfZPcDIo8tIpWu/lv2HLpANP8eMOsdrKmSmLM73CHXj0FCX
         2vMSeeTIKivWt2K3nGL6Fc5+7S0ANP+oRg4f88j8+UXW19gNS0A7KV1WF90/m5igh1M2
         zRQHZ1xn1xRpLoHJeF4WZ4r2RGkyB69thJ/xMwCnoTDhhNww6xISYCO8LRkzliS4DvLo
         YIjOGAZoZRmmNySY2Kqxa1SGOJuGlJs6c7VyBVYwRLT2D9JT75sos/YC0FzvP2GyWizs
         7llCfkf+enOHbtD7/tWvHqA2qcFlVBUUzUsPU/Vu4cJy0CzWXSp1FwDVPFppp/eEnSzU
         bNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066946; x=1780671746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uCoU+OqdPKjZv36ACGpsB/y/JO/SUTxBEuaSym4ONwQ=;
        b=Zr9q9x56DJSduJIcjT18IEFdzWfuFve+/g4mjahL/9TuzzaPsD5lNU5vafejTNNUVA
         WxAkBQFWtnJov8uUh2AkG52D3cHDW5Iv6yR3LBFJAAslr+U1m6YU5nUqwOPqI2gdMe6a
         KKAjvZWXzHlSQGqcxkch0TKtU8jNoppKibPYKZguDQIhbQTALWQPlIGQQWYWvJAfi19q
         7nDKmXLdBSwgv7kHkqDTJoMYxZ0BiljfHUYao+SjY5BKZW5+2Gon59b0afi8OJL/ZkKX
         DcEBMV8iokD6hyxVZOyER3v9FypllkA7/bevb81mZZZiuGiBUyqfc6A/J7H9BYzwfGYg
         wLvw==
X-Forwarded-Encrypted: i=1; AFNElJ8oJrNwPmt/jm2AKDxH/EyvqHfpmUCxhewJGaJF7SUQc/R0UehM0fjWuTYuZPwvOR66xLKrJ7YIKQ==@kvack.org
X-Gm-Message-State: AOJu0YzlY2qGMKCUXNjUgZK3kdhRPi8zPADNejKlYr8v+SJBHjsorNFU
	3UPxKbt174Md+ymaA4ltSAX6zMFDj99Cjj/q0B/Ndogtba/9+5AVBXgFAomiUAT23qi4KsZCJw=
	=
X-Received: from wrmj18.prod.google.com ([2002:adf:e512:0:b0:45e:e492:5442])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c3cc:20b0:48f:d5b2:7c42
 with SMTP id 5b1f17b1804b1-4909c0b3407mr46324775e9.17.1780066945605; Fri, 29
 May 2026 08:02:25 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:58 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3345; i=ardb@kernel.org;
 h=from:subject; bh=rMwJ7nJEkWuFVb2g2PkvQNTUrTu6Td3Xh3QWQo7SqgA=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVXqXnoyd+bugGevMve7XfXSUYDy66PR9M/aLkzVbX
 p2pPhPVUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZyMoGR4ftyuXTZZXPnLH8h
 GixVcqWVUTT36gvPhyW+7FMbBCYlHmdkmHBv/+orSg1td3qYcmOUt24wv3i7fwlXUYFT1dq0heu t2AE=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-24-ardb+git@google.com>
Subject: [PATCH v7 07/15] arm64: kfence: Avoid NOMAP tricks when mapping the
 early pool
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7CC04C0020
X-Stat-Signature: ngjekm354xnn8ubkrd6wtxj8fnbd5bww
X-HE-Tag: 1780066947-718575
X-HE-Meta: U2FsdGVkX1/y+vAA+4YKmcmRBa0RW+LmzTDn+IXzgFTee5J6nxOX/Fp6N8GilBwFOXZ6rU85G6Cpx3AP1ZhVZPjKw4IhFIHIAX7YGzbxVXw/dcUq37pnE0ixVcQmH98PO6fJKtuFqvsSLX3Kx6/1ihiMzijjpNzpgdyvgh69YArWr30QjnmGCxf815lMCHdbiBQ+61lkzNUbO1GsryIaHUfWEGZXvwDdK68/3bxR2pWteEy0SzU7RBUue3HqWByeHUj1lPyoayIq9aHcnH+/g5PhQAmegRRMsVyLdr6bykAyB+Hz1z+XM4sdZiijEoK+91CITqKiiLiyomrChqCjCMP5sbR6GDKBXYLQqohJ8sc8sT6eGpIzOfp7d6Vi7Mjlmesoy5OW/pFyakoYx2V7c6z9k7512qw3wbhOIIoQQU+8giEP7/OVpLVMB1txbf4GJsDQFd5wk9NtEkQ3mgRhWf6Vg9HgJozooz0xQW76HLx5GVVgpj3xuwDbi6OwnwkIHHEfTUPjG3sw0il9AwU4H10Ul0yWGKAGlWH8Sk570u2N0H2qYkUwjcQV+w3gxuYE0rTtlM++Xr2cxhJwNcuvlI+w6Bt0PVfWWm0SCFd44Ay+BCiIobeUTvgHW8kavGFr1KvbCz+3vN16VlIViPd3Lc7b0T5hIWNFDorLuM8LLMWw1mBXuVingj+4Hb2g1V9nFyUyTZcmbjtRuNIuuyrHdW6LrECiLWrMHDKqvX4EG8g4nFHRXukvHJjsVcD/26IrScCwK+/8VrAwJ3MoMNLBsDb4EIrYbarQs/aucQBAUdAJcQE56W1xhe4tYsUfEfO402cHBQ1V1I7mA9AfNE2BqgKpz0bpz/xs2Cqxxtn3E/+AB1Cg+v6xc1YBuE+yv8ZWtWVafNTt8XlUE+qiK8akAfjmCL9HTrNbvv3h/P0HtoZj/tWXCLqMXQWMPtlUMWdXcUoP4POuR84xggTQtnl
 al97HXSk
 EZrGBuLuN6apD16/P7atvBj5JNtJmG02oGRjoGIV9DPmnjB4HvzITT1UP8VQpP+R4W6ear1yBZiIRHh4VPwMLiMk+aTnlb1qASbUT+R+IMaraaM6T86wkziq6HEAq2J9aFQqoPH5kcP9rKJKqvAGyiKHnPtyCC0pR3rB/YbtcRj5UEjaKd6rjr7q7lmK7dFJ10IaZNk0cW0WZfOKh/61AgYFPKwLl7gX4tepXLCODWzNxA5X1MOi4hDkDcUrYMZjkF8KT6/rkFV+00T643XCBVlx17ie7jViDX9FliMOJXb/8WOBTkLJvh3UhhCaj6aOV+fgHsuEkz9BIS0KZcME5S9nxd9DxrHZ7EqHujtCooYfeUy5dkl9TH8HfXzoD8YK0rRlatuIrazrraL0156M53AypJl/qQMaL75yURZZh+osayjJfATiLgB6YYC2xGEW0i3M9seLsKD8eMT9ST5lBVLtEi+QzhiX+2lRdwU/DO41fvPFwu1/1FftEcLaziDxYu3HA4EaIj/GMIBB9vXrJUcVI0EfVAAe8ULgJurpkbDam6+MCAkbG8ALbfq0XYsShsb+4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Now that the map_mem() routines respect existing page mappings and
contiguous granule sized blocks with the contiguous bit cleared, there
is no longer a reason to play tricks with the memblock NOMAP attribute.

Instead, the kfence pool can be allocated and mapped with page
granularity first, and this granularity will be respected when the rest
of DRAM is mapped later, even if block and contiguous mappings are
allowed for the remainder of those mappings.

Add the NO_EXEC_MAPPINGS flag to ensure that hierarchical XN attributes
are set on the intermediate page tables that are allocated when mapping
the pool.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 27 +++++---------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d7a6991e1844..cdf8b3510229 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1083,36 +1083,24 @@ static int __init parse_kfence_early_init(char *arg)
 }
 early_param("kfence.sample_interval", parse_kfence_early_init);
 
-static phys_addr_t __init arm64_kfence_alloc_pool(void)
+static void __init arm64_kfence_map_pool(void)
 {
 	phys_addr_t kfence_pool;
 
 	if (!kfence_early_init)
-		return 0;
+		return;
 
 	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
 	if (!kfence_pool) {
 		pr_err("failed to allocate kfence pool\n");
 		kfence_early_init = false;
-		return 0;
-	}
-
-	/* Temporarily mark as NOMAP. */
-	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
-
-	return kfence_pool;
-}
-
-static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
-{
-	if (!kfence_pool)
 		return;
+	}
 
 	/* KFENCE pool needs page-level mapping. */
 	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
 			pgprot_tagged(PAGE_KERNEL),
-			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
-	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
+			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS | NO_EXEC_MAPPINGS);
 	__kfence_pool = phys_to_virt(kfence_pool);
 }
 
@@ -1144,8 +1132,7 @@ bool arch_kfence_init_pool(void)
 }
 #else /* CONFIG_KFENCE */
 
-static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
-static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
+static inline void arm64_kfence_map_pool(void) { }
 
 #endif /* CONFIG_KFENCE */
 
@@ -1155,7 +1142,6 @@ static void __init map_mem(void)
 	phys_addr_t kernel_start = __pa_symbol(_text);
 	phys_addr_t kernel_end = __pa_symbol(__init_begin);
 	phys_addr_t start, end;
-	phys_addr_t early_kfence_pool;
 	int flags = NO_EXEC_MAPPINGS;
 	u64 i;
 
@@ -1172,7 +1158,7 @@ static void __init map_mem(void)
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end) &&
 		     pgd_index(_PAGE_OFFSET(VA_BITS_MIN)) != PTRS_PER_PGD - 1);
 
-	early_kfence_pool = arm64_kfence_alloc_pool();
+	arm64_kfence_map_pool();
 
 	linear_map_requires_bbml2 = !force_pte_mapping() && can_set_direct_map();
 
@@ -1210,7 +1196,6 @@ static void __init map_mem(void)
 	 */
 	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-	arm64_kfence_map_pool(early_kfence_pool);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.823.g6e5bcc1fc9-goog


