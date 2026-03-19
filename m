Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01551091924
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2725B6B050D; Thu, 19 Mar 2026 17:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249B86B0511; Thu, 19 Mar 2026 17:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186776B0515; Thu, 19 Mar 2026 17:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0699E6B050D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:06:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACD9713B1A5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:06:09 +0000 (UTC)
X-FDA: 84564045258.13.439D9FE
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2C4EC000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:06:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P4uLh5th;
	spf=pass (imf10.hostedemail.com: domain of 3PmW8aQUKCE8v2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PmW8aQUKCE8v2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773954368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=smcAMeBF3eFvC+OZUcjPasWlZlCzzD66XLXM7VGnv/E=;
	b=pPKeRciSbv8JDprkzehwtGKdm21ET5e4gbx3SJkKlJkzN1hmllrI59kGY0fwsijTepU8nt
	A49NKgSaTry1xr3+WctFNepUw6YEzWj5FwFWuVzeyFqOyKF3mdNDwz4eFLOxOp8QCklUrI
	nnDK8DFwu/gjkCVhQKGuxQfJLzzKtps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773954368; a=rsa-sha256;
	cv=none;
	b=tDrJVcx1dmjN419Gwk7onnguAudbnxJOCKwG09Tun+TrglA6ihc5JbyMdHTnJdhRRrWFx9
	8KHKW9uPn3m2gKKk1rWLK5eZoGcaBKeQ8tt4zf6Vpnno7zYguTAQ21O71Rfw6dThan/VKQ
	x6zu8Na+9pqM+0UAZvG2IE7c9p8mfgo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P4uLh5th;
	spf=pass (imf10.hostedemail.com: domain of 3PmW8aQUKCE8v2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PmW8aQUKCE8v2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-486fa9ea1ebso12132455e9.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773954366; x=1774559166; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=smcAMeBF3eFvC+OZUcjPasWlZlCzzD66XLXM7VGnv/E=;
        b=P4uLh5thX3pQxU9imL30NSVFH8+QAqk0IfuLh6RtrUjpWKs15ITpyJ6Jqhf5PwuONQ
         j7Y1/7AYZg+3lrFqibswY5pU225tdf732P5g1Fioac572kLCdS50sVRG7udwilsy83rP
         gSYsyTU+IJFzWXlCUNpubIXRSM1LgOnnWE3zaVm0Opddw/9wpMEDv8csYn+mjjXfUfLP
         pAiuuwwbi+muD/48A+jR46SmuR+tY2YKLazGsMSYyapkH6Vrd2wFHAx9GpjUEuIFlJN+
         IImTjApVo6J707qs86y1GSSN3uNpl308vF+IJEi8luGsmbwXtLRct8yfTo8wAveavFSL
         XYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773954366; x=1774559166;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smcAMeBF3eFvC+OZUcjPasWlZlCzzD66XLXM7VGnv/E=;
        b=pRsX8cLSXpGnky1qVV3ntN3GzIGLPBz3ir2CwoDrQyMkk4+0jmsXnpjKGhK1wnj5IV
         y1SuhRS03Oe7+MLJ3rNBX7NIj7BoDzx38FUS+hdUQ2e+DXC5sM1CU4VVhzHdSjfHz9OX
         qcuyex0pyUqBdjmkdSiAaPN4jvBO3xbZQZp1q3HXVQ/lGPG0F9dSSYnXHdF2sBNKC6oV
         MFV7+CUyigkq0FLLpEKiU03WKrdysfBmIKplsraFP0omRIo13XSrfZgZABTBbW6e/i+P
         eY8GPOgCaf42nqc/MhYW+mafjscD/F++n7VcLcdgXBqFDRkkokk5dht8MLfWIxfZw7dc
         m6kw==
X-Forwarded-Encrypted: i=1; AJvYcCWaF61iDNPxCBhKYe/HgTcUCitNRCK3PmIaJT2A0sRFUVPtlxAWIb+bmXYFzWd21rbi4Tq5hJoLmQ==@kvack.org
X-Gm-Message-State: AOJu0YzbVIHr/Cv/UWR4XVVQk03jNo61AOHUe1n+pEpNtg7gLlnr0DPI
	d82O9bvysB9XcU++MlcaeGikJWH3ra09iFJKC4DPFVhEiIPMvI4XCyOHmGbCu+ROurHfxrMF/WH
	h9Q==
X-Received: from wmjk5.prod.google.com ([2002:a7b:c305:0:b0:485:2e9a:31b4])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:468b:b0:477:54f9:6ac2
 with SMTP id 5b1f17b1804b1-486feb5f9c1mr10150515e9.0.1773954366292; Thu, 19
 Mar 2026 14:06:06 -0700 (PDT)
Date: Thu, 19 Mar 2026 22:03:53 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260319210528.1694513-2-elver@google.com>
Subject: [PATCH v2] kho: use checked arithmetic in deserialize_bitmap()
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2C4EC000F
X-Stat-Signature: wtr6iekrkcnth8comjijczdxd8g4wi9x
X-HE-Tag: 1773954367-268399
X-HE-Meta: U2FsdGVkX18un1uulArmUNT06FDF03TmI0Ttct2Qm4l1G/gw3vXzzjim5aiY9u9rtCUJM5UGCXWA6nLYDLZJ61FbVcnZ4vyxLld1iWptZNVkF/69ohOtHLTx4DoDgZx0CNPkqq+GJjTGasXrHiY622d8MHsn1L5nufNUv+fcwS0RfRsdyzoxHSVgziDKqUwOInOBww87dWf0D7Wyam1PdNPZ3PduIR9dwCsDFYkQUhQ5Iu/6MqmHMwfcAlgo9ViuAkBDSan0qQSq5Dz5q1+xDF3ZDdZo7oAGyg/BWHLJDTFfFfkLjn6asg4RAHTX5+3dlW0Ucynrvc3CctUw6QhB9bK3l2PyBJieTnqKThDaOUQ8b5YSbMXvJyzEPdMluD3VPPaDXYZCJB2eMY7UEuY2xdSmAn2WOebUL+tTQria2p7K/hz4Gr5KerdxbQ/IujiKnICHB7fxxlD3EhsrHXMlGSQ/ScDhkhsF2O2sJO87Y2fF4Phh+cOWOfijdJOW+moR/FYXAuVA3yD/dETUojQ53LABXvMCuKAjcksyL6uyHOL0EM4YdLTzIFoc17IindBxXugTCp25SayKvbmUH3cW0jTzYoVvfS9ucA5fN+Nbw38XCZ2e9DwW+4Pe3ZK00TJKzdunFQcXTWgmYyiv8id8Tz3VAtKqjqHsWdxEIWQcIQSh0E1dwFvl2tHEIzSRuiPKRzLgu3WIVpYSSYOLqzU9Om3xy6BJkYSCDvCdU1XVXLYOfO3nb8bJIkzWiK4q5GBr4nJhYeE8Un3CDydbjRURgi+69UqtS3qUHoaTbbQwsZvGe3VjfRvATlNMfruDfJHy+Ous3oYyVE4wV93KjSiNwAYJ+gH5Rpu4bPmG0oV+KjXeDzqITTTY+lLR486OaxFG/jvpKrZUAFG50AqznJRvUZbvTzf+kv4HPREer+Am7X3/aHlqgNHGsyXHXr47T/MUxO6+liBHo88UzbtnJ/x
 LWiSgmWj
 ej8NX8Ni86urgw8ux9BHkVD5SNOMqaJa6k+iqtWRBunObafjDgdaaf4hU3UKvlkcKX6Nlh6d12s77p5FLudL7ZYdXgJ+DNS3+n9sq+WjJdNY0tVdq8QObz1JGDLTm56gtius6u5OC8iaijrGGlXQ+A+vzTNzeBwX//AzQAxznfezCGRIL/axAwC1XC3YiTxb8m21aRg9yT9Gr88+OgvQeYvoT2PZA3OlLODtefBTBboSzpIVIGWLgmANxEYL+8MIugHSio5YOIpMCHO31vOxBfSWAZItEKU2lk2w+tbH5u6cW1dPP2FSOqzu0YjdHu+hHxo8tf7T0Z6fwA6Upy3oLolZE28/jFM96b8Y3cwMil2Z0CGlzA1ZvJkRGwskQqeu7aZ4YeZhSGyhvxBCnNh6Dbycnwx9ze4Ubf+83VGS6XGW7wcYaD3ECTGk/jOEejM8Zqy/M5zF3mB8MPJEwuOt4/IZHA+zCSoq9n2kHFnXahjodA+1xY6BiDBksb0qGt7CydsVFeLUf7Vgw9QKJ0ZRxYt9zUlT+WrUb9NSZv4o9NF7Pob6HvQey7W/LLg4Vyo58LbN4pk0+8BVSw1hDNUZbkXkMTqXnQTIWGsaH49BeXt83bCdRjTBIQV5BC8Ku4PSLtc4y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function deserialize_bitmap() calculates the reservation size using:

    int sz = 1 << (order + PAGE_SHIFT);

If a corrupted KHO image provides an order >= 20 (on systems with 4KB
pages), the shift amount becomes >= 32, which overflows the 32-bit
integer. This results in a zero-size memory reservation.

Furthermore, the physical address calculation:

    phys_addr_t phys = elm->phys_start + (bit << (order + PAGE_SHIFT));

can also overflow and wrap around if the order is large. This allows a
corrupt KHO image to cause out-of-bounds updates to page->private of
arbitrary physical pages during early boot.

Fix this by changing 'sz' to 'unsigned long' and using checked add and
shift to safely calculate the shift amount, size, and physical address,
skipping malformed chunks. This allows preserving memory with an order
larger than MAX_PAGE_ORDER.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Switch to unsigned long and use checked shift and add (Mike).

v1: https://lore.kernel.org/all/20260214010013.3027519-1-elver@google.com/
---
 kernel/liveupdate/kexec_handover.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cc68a3692905..0d8417dcd3ff 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -19,6 +19,7 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
+#include <linux/overflow.h>
 #include <linux/page-isolation.h>
 #include <linux/unaligned.h>
 #include <linux/vmalloc.h>
@@ -461,15 +462,29 @@ static void __init deserialize_bitmap(unsigned int order,
 				      struct khoser_mem_bitmap_ptr *elm)
 {
 	struct kho_mem_phys_bits *bitmap = KHOSER_LOAD_PTR(elm->bitmap);
+	unsigned int shift;
 	unsigned long bit;
+	unsigned long sz;
+
+	if (check_add_overflow(order, PAGE_SHIFT, &shift) ||
+	    check_shl_overflow(1UL, shift, &sz)) {
+		pr_warn("invalid order %u for preserved bitmap\n", order);
+		return;
+	}
 
 	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
-		int sz = 1 << (order + PAGE_SHIFT);
-		phys_addr_t phys =
-			elm->phys_start + (bit << (order + PAGE_SHIFT));
-		struct page *page = phys_to_page(phys);
+		phys_addr_t offset, phys;
+		struct page *page;
 		union kho_page_info info;
 
+		if (check_shl_overflow((phys_addr_t)bit, shift, &offset) ||
+		    check_add_overflow(elm->phys_start, offset, &phys)) {
+			pr_warn("invalid phys layout for preserved bitmap\n");
+			return;
+		}
+
+		page = phys_to_page(phys);
+
 		memblock_reserve(phys, sz);
 		memblock_reserved_mark_noinit(phys, sz);
 		info.magic = KHO_PAGE_MAGIC;
-- 
2.53.0.1018.g2bb0e51243-goog


