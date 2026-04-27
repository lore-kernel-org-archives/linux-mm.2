Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C7BFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01D806B0092; Mon, 27 Apr 2026 11:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36596B0093; Mon, 27 Apr 2026 11:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73CD6B0095; Mon, 27 Apr 2026 11:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2BE96B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:53:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FEF712205B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:52 +0000 (UTC)
X-FDA: 84704736144.17.70EA3A9
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 40156C000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LgbF+Y7i;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3VILvaQgKCG0LcOM+RTeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VILvaQgKCG0LcOM+RTeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHBfAOq62ddYo5eYH63kmRGKW2W5oXHrS23q0wSzvjk=;
	b=NLv+sZRwEGXIVIBRckNAO1XXi5Dfht4/gJsL6ABzyVelle7K9/qHK6uJ2wAV+Q9q878SPC
	jHneOGpqdn1MURRZ0R467hCBcsJ6ZDM+SZA0odjSqzaUhwOCJZAwUmfLS+WsreXfMpqIYn
	6tKJ0H9f7rR0s94OhTUWXqaEm8+BY2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304150; a=rsa-sha256;
	cv=none;
	b=hULIN2nNNY9ATgFMzUmYkzArXrYERjb5UJDEc5y/aq9Z85yAWmlVGMJXlrlXx6X4cTTmtU
	wNT+76KsVUtPMPdY+XkrQYFPoErUYTpPZE96cJwVKtHDmbFZpQCSiAQEEGZYg3tB2y1ZhG
	PO9yEOUWD1XPyVYgxjstA6uTN2qGRi0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LgbF+Y7i;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3VILvaQgKCG0LcOM+RTeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VILvaQgKCG0LcOM+RTeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ardb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a5952c635so59720005e9.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304149; x=1777908949; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LHBfAOq62ddYo5eYH63kmRGKW2W5oXHrS23q0wSzvjk=;
        b=LgbF+Y7iQKyx5ZpgM1qQ4DNAwjLr8j0376ntEXgIHEru9yjqR6nueRRjjgEyCgKno3
         o9w8vwqLUM728usEmsgR6+WudN3BRiD8GY8vR6A0hJzyij8WVBOhng63O1P0FJtelFUK
         tOodrB2+N+RX70r8Rw8KwL2qbiIzpApCDzYxqwCwkz5eTaJcn1h5lT2a7p5uZ0sZJuWF
         l6zr+lsvH4McRCt7he5cNda4H5L21eCuwcG76K2lPKovipuSH1O+sqW+1ccqcntueYfI
         PQ8Evz1hncrJ/VxW2qnPz8WgZMo3ZGbTZOAv8qrdYNZGloSBrj5/Tl3eh2jDjbjSo+Gf
         D6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304149; x=1777908949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LHBfAOq62ddYo5eYH63kmRGKW2W5oXHrS23q0wSzvjk=;
        b=B2TYkL7V9mwifxuffZbO6N6uFZd7bC2KbhcP7TB/MQbRtGTF61R+ABecQwXAo0UkFG
         4hA81tz9JVqGsTu8tARUYbiDZo6xNTu1315pHHTDVy/skFpErCrOJQr0M0Qcomwep+4m
         8oBM/svKhgbXP/AK3XF1UIaEzXzdfiqZu7xt4mSMr5Khr6Ef5F1mNItVemrpHUt6EVHZ
         66RyE9RhjgoMUjj9nOpqeJHf1gYtumIuZqrLcMka+KxKk4RcYXO98g4esn7ouUpsJwJG
         6IObvd2l7vtfiH0kKk3/8uyuyVAI8sj04M3SZWlvQ3inI0o1+MvWTNIC9By2ypLdBv5W
         qeVQ==
X-Forwarded-Encrypted: i=1; AFNElJ+kpZkoLBf7imaV/UQOB5YZ6aS7Sm1gYEJu1YxatZafCX0dvMkU5ZZU5hjiUjEgfgZZRf2/ORTirA==@kvack.org
X-Gm-Message-State: AOJu0Yx66rQ5G7nT3zB8MVlah1AT7gxnWTUcAerLE5cgq7z/L5v1DLmo
	SJZ02AI+p29kbzZHXKES5Uonxfi9LB8viRZS9sPNIyer8rzhan3tZ61/vgr+mw9MBCTWSZJkKA=
	=
X-Received: from wmim14.prod.google.com ([2002:a7b:cb8e:0:b0:485:4f4a:bd84])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:628c:b0:48a:52d4:888c
 with SMTP id 5b1f17b1804b1-48a52d48985mr436500725e9.3.1777304148352; Mon, 27
 Apr 2026 08:35:48 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:30 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3345; i=ardb@kernel.org;
 h=from:subject; bh=wQjR+F+1V7sUzLN4TnEphIKngbWEIlFdlV4UM9366h0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E8/zzp9rzJvuTrrssME56tgdeZGiCxu1/hnmHFEw2
 Kx3/PTcjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARdX2Gf7qTeGeyv/WQ3m+5
 YJN2SVKJmjhP0Cq12slhs9JOff29JYeR4fLhIoXXDu2TA92k7l89733+pdS0gHk/wh3rGVYs+M3 wjgkA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-30-ardb+git@google.com>
Subject: [PATCH v4 13/15] arm64: mm: Unmap kernel data/bss entirely from the
 linear map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 40156C000D
X-Stat-Signature: ypdux5jwt7stn5b9dnk3qaqyu8xbd348
X-Rspam-User: 
X-HE-Tag: 1777304149-117262
X-HE-Meta: U2FsdGVkX1+ATRDdgGfQvsm/Na0zt7q/WozAKmMBcZhw6d1itvR4gTsMrmQj5bc0hmnOd2AmkKbgg0lygim4y0DlTukImxQtmKUVHs+jzSdJUU1RmSZXlTJk9j/A9mmDQkBsBgAaa7lCS+hHflxDhEAl0s1xRdvsdaBkGW0iTCi+jK5C3ogKuL1PhYajgJRXLlQypgjR48u6waljrI0VRLKdeYjEqpc7ZH1RbKmBx3Kid4wL2JLdWGnK0pQy2oCnyebGXRO6AMm/BckH7kFFPBL80sTMWumfulXdltSN8xQ/ptb4L4248WxGxD7UduHTMYdXMwmXX9X7pzig+XzN7HUl/UhtwHCbPAil4K/IFS1yoYWWIiqSUxAav7jtIxAiX763XZxVRtr4INyIoYxhMiYRyj1HVOkmL1nbEcIPrp2xndzjjX67tR25AF/bj4aOc95xyorjVOpAjdrK8cDoUXAb/uqoUzXgk5+kSv86GUUmF2dU7Msu9C7mpReZlWVhl/27g9iR0rRgk5+Qv095l3ZaRAaG/TcbMDw4jQxHr/oUgRQ4gdAR3p2v7BUmbIYnAMbFaHXoZHlX18sTkWmtN+41AvPrnbT0HV/HiL4s0+fZPIZIOU4MtOZnVZaUINi2li9eDsfIzZ9dlPMY5BXVnciVzIMT3w2v9Tgg38ocbbaFIiNctvwzc/o1Z6VpBfbTbwx5pVLZnWmNinvp5ftOCpzq99iaMmJOvASrG5B/B2lv0G6jVgwxjr4GoHulyg+nTEUNXxhFZwliWsGCqwbnyQg5q57DyBlrsDqInf0lWbZCgs3atXq8aQf7AXCbQC8Lcjh22ibyrAIsWBfzowIi68PU83TEHnwqAoyhH40eyXEE8CfcGIxyg4UE9ceqOISUwPxEAow2Uy+5Qn/UPuqHOTrkU4DsGlc9BNMCxt66kyyYRxyu603zbmYvsqQnh323NrXdvM/qVJkAwVV18RU
 +NFdagcK
 Zd25zlFTuNuB+XDUi1258xKeuMTB6PeF2KiHQKjr4fGme0i6Mn2amQVnEkSmt1ZC6hTFfeUywJ/CZZN5tAEF9KL0bDJlqGXDUwHSFoQryPZrtcgq4cVGYJoU/V5IeYGs9DOL51+tTw0GMQeDDFemJuYsuaDoGaHmAm+Cmgs1j9TDROG+qGm6Nmy3ug5lEj+PlUwfZDWsnXpn2zbQhT9virVTzeD1dYQrFn4zM0t3aH8Sy9PcHzRYz2KURklioYYNfG+gsAyx3H799kr6oVRIurIiNdnF5xuA22SRwzteF5ke0Ah6RpNWFeP6vYGrdRvlC6LWWbmK0FJV8kB7wfLxnp0P5AiyLIEy/Uup7VENQf3lOA+hIkw7c16w4dgh0XFfPkSfqaBaUrPt6fvpPsXVu7VHvIC2VyuoLj96ruxT1qHS8hQtY6ryBsTd4b+GdSZMC7xh8WL6cOd6j/vEYFuPZjGEFysgtOoSRoM3XZW0VeKuqlI3S4jBJgkmY77+4wVOVAa8+xnOfvcZL8mc1rZYWW7LQNdcBhEGX+HjWH2B1niC2T84o88vi6HrXZBpLjIzJ0MHxRhbCuSyT1JOHJeX5KtP5G/NgD9P1FMlbSI28nDt4AnoWUAcjwJMxBrZzVI+eKMU9LqjFms1IuV3EHAaaRkHwANqYd45nK6PCeEV7jb2wbaJ8LPz5ybMvIFnwemCnQ638
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The linear aliases of the kernel text and rodata are mapped read-only in
the linear map as well. Given that the contents of these regions are
mostly identical to the version in the loadable image, mapping them
read-only and leaving their contents visible is a reasonable hardening
measure.

Data and bss, however, are now also mapped read-only but the contents of
these regions are more likely to contain data that we'd rather not leak.
So let's unmap these entirely in the linear map when the kernel is
running normally.

When going into hibernation or waking up from it, these regions need to
be mapped, so map the region initially, and toggle the valid bit so
map/unmap the region as needed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 44 ++++++++++++++++----
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 9361b7efb848..a464f3d2d2df 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/set_memory.h>
+#include <linux/suspend.h>
 #include <linux/kfence.h>
 #include <linux/pkeys.h>
 #include <linux/mm_inline.h>
@@ -1040,6 +1041,31 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
 				 end - start, prot, early_pgtable_alloc, flags);
 }
 
+static void remap_linear_data_alias(bool unmap)
+{
+	set_memory_valid((unsigned long)lm_alias(__init_end),
+			 (unsigned long)(__fixmap_pgdir_start - __init_end) / PAGE_SIZE,
+			 !unmap);
+}
+
+static int arm64_hibernate_pm_notify(struct notifier_block *nb,
+				     unsigned long mode, void *unused)
+{
+	switch (mode) {
+	default:
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
+		remap_linear_data_alias(true);
+		break;
+	case PM_HIBERNATION_PREPARE:
+	case PM_RESTORE_PREPARE:
+		remap_linear_data_alias(false);
+		break;
+	}
+	return 0;
+}
+
 void __init mark_linear_text_alias_ro(void)
 {
 	/*
@@ -1048,6 +1074,16 @@ void __init mark_linear_text_alias_ro(void)
 	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
 			    (unsigned long)__init_begin - (unsigned long)_text,
 			    pgprot_tagged(PAGE_KERNEL_RO));
+
+	remap_linear_data_alias(true);
+
+	if (IS_ENABLED(CONFIG_HIBERNATION)) {
+		static struct notifier_block nb = {
+			.notifier_call = arm64_hibernate_pm_notify
+		};
+
+		register_pm_notifier(&nb);
+	}
 }
 
 #ifdef CONFIG_KFENCE
@@ -1162,7 +1198,7 @@ static void __init map_mem(void)
 
 	/* Map the kernel data/bss so it can be remapped later */
 	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
-		       flags);
+		       flags | NO_BLOCK_MAPPINGS);
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
@@ -1174,12 +1210,6 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
-
-	/* Map the kernel data/bss read-only in the linear map */
-	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL_RO),
-		       flags);
-	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
-			       (unsigned long)lm_alias(__fixmap_pgdir_start));
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


