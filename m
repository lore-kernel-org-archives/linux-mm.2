Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3941C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8426B00CE; Thu,  3 Sep 2026 05:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080406B00CF; Thu,  3 Sep 2026 05:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE796B00D0; Thu,  3 Sep 2026 05:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8D086B00CE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:29:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 459CCA01BB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:11 +0000 (UTC)
X-FDA: 85171927302.21.A1A8558
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2152A000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EmZYbLMt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4k8gpB3IOAIIjG8UTpBirOTQDvbIToA9Mf39j4z3bA=;
	b=ml++LUrXKtqxpe33xlAXWAY4vazcgbcGnY7+gtD+pe6SlvVhHsCnOvb9HDbzlD3GDxHd4d
	xbyRVWCoaXM5CTr13AiTKMr7+fxgoWhHnVJlfOuOErgAFhH0D2rNd2CR4Wo28HyVlHbxyk
	vmRXiHrMhK7AICm7kIlc1n6M9H6S4Yk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EmZYbLMt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427749;
	b=xm9/gffITeqJm8wTsuRDZPv7uGZcIfxtpin1wEKVtNXoG9GCA4p4jbdPFky5ubPMbYyEW2
	kvFsC/8h/HARoCKOcfecYPzpVc08cn8qmc9PVtDpMlJ95wqtA3pm+why2qyezoIgrL1RVv
	+ky9pjHpZHI6xVb/dwRM0Bg7EMKrlsc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F7F7600D1;
	Thu,  3 Sep 2026 09:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58871F000E9;
	Thu,  3 Sep 2026 09:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427748;
	bh=W4k8gpB3IOAIIjG8UTpBirOTQDvbIToA9Mf39j4z3bA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EmZYbLMtgCfKR5SC0SQMKuy6UTCmihOaKfsjvsBiuS/XG7+bmTa0BttU4UQ8j7cdf
	 vlK1dC3HchMglytuOJLBFLTyRcNQdP+8ieRosdoaP3VM+qhi/JXSJgB9O2up6Q1cc9
	 dRF/zDGzuuK1aNW6SVIpMm/UtcIHCyGVBYN7VibK+4507rTi1xQ91nix1xb5JkwGBu
	 eFN0D1Me4+48CIg7BPzVdmq60AYdlg16dPhyhgO/Z7ijOZIcJlmmMweRgb+nq5ucgP
	 FcEhOb+cZpfl0fq+hYVBaIWbbUbVucc5yFPSZCZwxRRJs6GayaVzjn467NYhrYwBXC
	 ooT5d1FoGG3bg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 12:28:29 +0300
Subject: [PATCH v3 3/6] mm/vmalloc: constify vm parameter of
 get_vm_area_page_order()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org>
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
X-Stat-Signature: ne7snwo8t93g7mgcin7ndfboju85uotm
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A2152A000B
X-Rspam-User: 
X-HE-Tag: 1788427749-571942
X-HE-Meta: U2FsdGVkX18dhfVjPmFtYv1HW0K+BhJVat9dw1LZc8N4juJT7ouddRViNEHKrBsLfngKx2u4hft2m/KZACv8v2izMwCdfbZlJ75O8PSHZv5r3sTVijZhacnR3H6J2eW6rogSPRfHJ0BueKLYJ5yJfjyt0r4ZGyxQURReUzrJi2t5WdnCF/Kp6vUeuYASUYYDhJPGeXm3l0qRiTIefS987Ku05EziUZWYt3hckTsDEK5M2ujxyuvD5ITQ1s+vcqpWb1p0JlOSNHBU+TCKTVxu9QWTIpGXRhdPZ24NlRm8Bcnw2IG1XAFZCg0dF6LGC03kwi9fmITGFjG/ukza8gYURItGDAlrI4pTtPZf5FgJjyeYce3St2IR9LOXhgPjA2c0DwCjoX4oFtx9eeEyKcegiNdFx3Z7/vlpCKjRUvtJwncAAHTp4vESr0qnAiJo8MFHC94tq5ITO60hIfuRAq7VJcAFCEHqb2pEeIy9tweJaMIIAJlz/Tu0Va4WYWEmn9XhbGsJDIgko4uwOn24AXsIhlFWeGzWmTdo2zaqrd3rcbLLlFqPs8nCO65yvIuXqib8p9kJ5mKGmk9/ZuEl2P/FtT26i1ERhIa3RIgmR+NhV3he1MB7GnHN9M6UAiHxReVtIrPZxCrl6VeYT2mSvKeC8GweN5gvuwxXg+ef0NT/gDSD39zBjcNSunGDwZRPmFyFuqWCh+t199t8duVfNsH2ecc8nm8TSA1lSPnam4Dzh7NzqI6gxw1VGmFAL+JGkSV04Ww/ARsltWMptjIx3CTcIehvzftTuVHP4S2YPIO661shn0uvHBKcQz20+6cImyZoYY9ZKKimnMBh9uKo/uDUm1zY9nWkOokt+XZZofQpOzqxRthysG3Gbb36KA1WlRn6i1QrZ/t2R/kL3wEx9MchVlg68nQcpy0wz52LqLUQRIeyl/+cUFTs3qCxy/LOD+/n6X3h02Jm6Js3OgtW4vf
 foyW7pq1
 cuHiFFI8PIl/aQQlUHve82x3nwsCvxAnzoEKROPeAQfB43/EaaNbD7onrM7ksRsAzaz01FzahEMrQD9/cRmwb2k6ty6H4AlIj4TkPCw2eUZzz6XJQiOcckLlWySMq5j5V4IpfGphd05ge7Q+FdvlcCqvV7y3JKeo/Z+Jj7Mg1V4SS43mydOITINYMlSP2/Jko8KSjKXc/Q+mSjFXOtKN2y7ylOGbDvntwTG3rkULNsxNOhLqMONpJ5h/21JWneKjpvbnHqD/TB4hkU1e8llYgFEEbHeeA3EI+g/r9/ZhC2BwFpzMeNWEpUcvXmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_vm_area_page_order() and vm_area_page_order() do not need to modify
struct vm_struct passed to them.

Constify the parameter.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/vmalloc.c | 4 ++--
 mm/vmalloc.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 22aa554d123f5..5506b180f5c27 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3130,7 +3130,7 @@ EXPORT_SYMBOL(vm_map_ram);
 
 static struct vm_struct *vmlist __initdata;
 
-static inline unsigned int vm_area_page_order(struct vm_struct *vm)
+static inline unsigned int vm_area_page_order(const struct vm_struct *vm)
 {
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 	return vm->page_order;
@@ -3139,7 +3139,7 @@ static inline unsigned int vm_area_page_order(struct vm_struct *vm)
 #endif
 }
 
-unsigned int get_vm_area_page_order(struct vm_struct *vm)
+unsigned int get_vm_area_page_order(const struct vm_struct *vm)
 {
 	return vm_area_page_order(vm);
 }
diff --git a/mm/vmalloc.h b/mm/vmalloc.h
index 8866ddcff6681..211869f365095 100644
--- a/mm/vmalloc.h
+++ b/mm/vmalloc.h
@@ -12,7 +12,7 @@ void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages,
 		unsigned int page_shift, gfp_t gfp_mask);
-unsigned int get_vm_area_page_order(struct vm_struct *vm);
+unsigned int get_vm_area_page_order(const struct vm_struct *vm);
 #else
 static inline void vmalloc_init(void) {}
 

-- 
2.53.0


