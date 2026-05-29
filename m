Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA09CD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D1C6B00D3; Fri, 29 May 2026 11:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86FFE6B00D5; Fri, 29 May 2026 11:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9D36B00D6; Fri, 29 May 2026 11:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB0D6B00D3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33157C0A89
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:40 +0000 (UTC)
X-FDA: 84820774080.09.EBD18B4
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1AFED1C0023
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ddRzspOa;
	spf=pass (imf20.hostedemail.com: domain of 3jKoZaggKCJ89QCA+FHSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3jKoZaggKCJ89QCA+FHSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQKx64xQcW6ZDY2ZWUkqEvIbYSGgY2Fsos5YN6YfoOU=;
	b=BwpGD5brorfSrqESY4tAlfEaVmGmjTAnH+YzvogG8CD9YZvsvEW8mEXQv3Y8caw43xUVge
	fS4zcwwTsdjQJvW6nFRHXUfGFloVGhgy0vp9iPMA0gMM1/5AtHIhLRBq2wMHC1RflycDdC
	7Vr8stRDnG9JKeEpP9QQJrn2HJzFcSc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ddRzspOa;
	spf=pass (imf20.hostedemail.com: domain of 3jKoZaggKCJ89QCA+FHSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3jKoZaggKCJ89QCA+FHSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066958; a=rsa-sha256;
	cv=none;
	b=Q2sc6C9i8xiOSw3e79jHHe/zJlqJdJ3Z29JQYcZfM6VpiS1H8SokyW5R0v7BOX8pXe+TFY
	y2eGly5XT0zPVq7D/kbvLBKL4LwMV83BVvzA0b3g/nSLqaAqzlvbyUWmX4ZnDx52Yry1iU
	PjWoSXk7y2x3GSCvlas9VHo/+wCv7gw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4904ee02e72so60809575e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066957; x=1780671757; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XQKx64xQcW6ZDY2ZWUkqEvIbYSGgY2Fsos5YN6YfoOU=;
        b=ddRzspOaVbxZg8iG4/Hl9TurKnG0CqZ6j6sqL8RxSDk25mxr48DTuRe4wt+jzXHysD
         +rG26SLpVbCABU3wx6gq9v3x7lM3m+4jgV34KsicTM+Mx3qBKZqDLhuMFXc8BsRQ2yL5
         G22tKORnehbcDzFs3kxykheLw0kb4swpvHggUpez9L50hi0Mxptl9vpjUCwkbY5q7SgI
         xJcrt1KvZWD24EpFIwGh/ZQi0ydBxe5wLPfH5bbjBAgoy0GVgc3Kugr8/OrjAny1j98n
         CZ+gUWWPgW4vF846g2sbfEBNIBv5jLWgTQgH3Eke78AYBGKBPpdiqCtqMn8Qr1egRCqZ
         l2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066957; x=1780671757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XQKx64xQcW6ZDY2ZWUkqEvIbYSGgY2Fsos5YN6YfoOU=;
        b=B1B6JT8WjG29HW+qwcdc8RdihAd6WQOedoQCCX0kx7d0WyA1GmpNX04KiX9tw8Sk3V
         SYfOtdF/dLDqrM2piRm+GFFJISQPX1FhJcIlsGmsDY8uVhV/HHZu6q9S5r2ZS+FcdaRH
         vJc0qFanwEnI2JLsCbVyhlPVqbG+f9PAk847p2zKWpGcI6qfMIxjHcwIu61zHPXnpwyZ
         6Eul8O7Qvq9n6rrE9vmBqliQmzQUqG7aCZFbdLNuyU3CahlahKvFxHdQ0+Y8sHjgoBCX
         ck1h+WnbZ9FRQtNYlMXp327YrTWP86zvXx432B/m5ECW/Ka9vBHEama7wl0MK41e+nS9
         KRhQ==
X-Forwarded-Encrypted: i=1; AFNElJ/d3xqmB/mqhU9269jakLm2gLlL7ZFN/C0VZhtexJhX7px6EFyFZ5zoLlGRkuoI3Tmyoq4p3AXNMw==@kvack.org
X-Gm-Message-State: AOJu0YxOeBp2Dub56eHxGyeGpbyUW/5shftM9ROfC5iWpCfO7Y43UhCK
	N2jMfzuXXopbMqnKdrAOuA31Fk4xD+7evp1SH/7hX4RVBAS+SklAdi5LGGd1yIwYnkDG7XSh/w=
	=
X-Received: from wmbez9.prod.google.com ([2002:a05:600c:83c9:b0:48f:e3fc:d858])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fd6:b0:490:5655:8d3f
 with SMTP id 5b1f17b1804b1-4909c0ed167mr56446625e9.28.1780066956218; Fri, 29
 May 2026 08:02:36 -0700 (PDT)
Date: Fri, 29 May 2026 17:02:06 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3406; i=ardb@kernel.org;
 h=from:subject; bh=XSavLFKj4RYiFTOsx9dpbIASgaMnJejevEPNl4lZqhM=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGoZqnCghcJA5fPW2Z72X9X37eu+fqYYMOTvKUc5VemCkE+q7
 oh1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmoZqnAACgkQMG4JVi59LVy8pQEA6HlB
 3WUW3N8HA9+DidOWBYQI1frKFGwVYEQ7O27c8DUBAJEH2JVQ9ldiz63/YvZsdSlPfdvNDLvL7Jf SNW10NGsD
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-32-ardb+git@google.com>
Subject: [PATCH v7 15/15] arm64: mm: Unmap kernel data/bss entirely from the
 linear map
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
X-Stat-Signature: ppbhaoew6e5i849nsjdy6bik56nqcqn1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1AFED1C0023
X-HE-Tag: 1780066957-518787
X-HE-Meta: U2FsdGVkX1+0RNBwgA00z1RXyW1WT0Mu/dYSFmU99NWgRsjDBeNHA/NB/yizEjuVeDeCZNQcL29w8js6EGQtgAhzPSJNCGC7T+jiRF4ve86BQBHtkjz/zifRUrCnpFzqzU1VSNx67MfsIp7LG1K0pqZ33gj1wBgkhfE9ZM3NPmThe5OlLfD5grRLh/QWYI5GRJ8CnX2ZZGENby1GFquekWByZ+y36GfE+s3LW7UjKLAyIZDzzp0nQztXTmGY5ulymrS3uMmXbxuOW4o7/Nrxm17ukiv8zNIdRevfKpMFQf+C4wVhQaNtX+rlxBH5Ii8lRUxC6oMS5G5Eqe+SrZrhD7MBwjN7KuEwAQQwyUFkZnle4vISXbW3MKkfiNLyopiOM656pjQ8RoGb7A7EEtF9uQbZaPDo+b70p/1+Oo/O9bl9M6yuHMoXnhAvwyrvnLwe26AG9zhXaK/HFxTlN9BJcLQgGj8+JvGzNAtDednYOQT/6cYPIbDgg/0cOdw1IzCnuk/e0hvaL0ZNfA4wp0/0uEJonDAg4acZKHNpfMsiyhf04DOdRruE6dRyxaB1cuoB6d7GJYVkP/vfOOknzww7O4IH1/r9Ce/Q7n+FqmW5gc5QoSVq2GTrjWhEhHlVZH8GSau3EVV/ztTDPefIwkLV8DFDcw0MijoQcWP/3KEkIKxhz8yBhe4kIVwZNVI+EF+qJaZQ/zaabrUmsGtMA8qAevOQWaAoymjmtBPW+IuJ/8CmAKEhiMlZ5DAW8Y7F/U5r3fDaIqB7T4fDaf08b18Npk35F61fAoTgiuhxGJZPk6kHzn0mQg+1izL9Rec9HN3A+u35BHs+4G24GbhKuS1JhrCQ66BcIjQlM+VQNu2BrIq6QWbDIOMDDjLyCxpAuhaWZcw7nTmqQvmXjtQ/iFneUWRjaEDVotxusUXRRLoiCIQ3cXmd4t0DRbzXwuf38C603QkMtwLLA+q259+M0+y
 h49yCyr1
 U7h5N63sFaBvcIn4LFn3lwLTVxQALNh59tC5TpjJFtJTGNgvc9idk3NA187uDPt5asXPWmC7r0deaMnLFFDHupl1P6vB4mYg46AO+hVICezKGwglBL1U0+fu8vr6UjCsoGpRKh1vaXNFybkRftxg/+zeLep44s99YbM08prmkG6PtKnCrTThSoNd22ovppri+4JmEWnQ9D4/f8QlkgHaT9g1ukRZZM8gDNQU5XmnMUCaA6vIQi/9OvQEHPov4YWEOpx375PurVCFDwTyShF8P98kR+kMk1U+G58Wd/WqJfgfW3JHd8tHDS3mwbG3pri+uAfB0Zy7IXBuSg4TjXsgvlZjVV+hrr3qXJn34s3F1QvwUJaJw+EfaFqAL9nYTL0iyy3aKZkDukMeU1OgUxbyazGxaTb9VistwS52vpHCBkoCtE3MfMQsaQjamfAuaWtFUA2a576hk/BY32B5Nrlhf7umT00cM6Kr49DJvQc9SWCOoSbRNhzluATI2Mkv/IJPVRMzmEmlYAL8GD76U1I/CII2C8v5KlPMJ2t3pmmrB7V/lG9EPMlhRx8Upd+35xPRvn6LT7yHIrF9nKYBaWEqHvEarKbDiNF091w4jJYzd44rKSwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The linear aliases of the kernel text and rodata are also mapped
read-only in the linear map. Given that the contents of these regions
are mostly identical to the version in the loadable image, mapping them
read-only and leaving their contents visible is a reasonable hardening
measure.

Data and bss, however, are now also mapped read-only but the contents of
these regions are more likely to contain data that we'd rather not leak.
So let's unmap these entirely in the linear map when the kernel is
running normally.

When going into hibernation or waking up from it, these regions need to
be mapped, so map the region initially, and toggle the valid bit so
map/unmap the region as needed.

Doing so is required because pages covering the kernel image are marked
as PageReserved, and therefore disregarded for snapshotting by the
hibernate logic unless they are mapped.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 45 ++++++++++++++++++--
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7b18dc2f1721..07a6fa210171 100644
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
@@ -1056,6 +1057,29 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
 				 end - start, prot, early_pgtable_alloc, flags);
 }
 
+static void mark_linear_data_alias_valid(bool valid)
+{
+	set_memory_valid((unsigned long)lm_alias(__init_end),
+			 (unsigned long)(__bss_stop - __init_end) / PAGE_SIZE,
+			 valid);
+}
+
+static int arm64_hibernate_pm_notify(struct notifier_block *nb,
+				     unsigned long mode, void *unused)
+{
+	switch (mode) {
+	default:
+		break;
+	case PM_POST_HIBERNATION:
+		mark_linear_data_alias_valid(false);
+		break;
+	case PM_HIBERNATION_PREPARE:
+		mark_linear_data_alias_valid(true);
+		break;
+	}
+	return 0;
+}
+
 void __init mark_linear_text_alias_ro(void)
 {
 	/*
@@ -1064,6 +1088,21 @@ void __init mark_linear_text_alias_ro(void)
 	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
 			    (unsigned long)__init_begin - (unsigned long)_text,
 			    PAGE_KERNEL_RO);
+
+	/*
+	 * Register a PM notifier to remap the linear alias of data/bss as
+	 * valid read-only before hibernation. This is needed because the
+	 * snapshot logic disregards PageReserved pages (such as the ones
+	 * covering the kernel image) unless they are mapped in the linear
+	 * map.
+	 */
+	if (IS_ENABLED(CONFIG_HIBERNATION)) {
+		static struct notifier_block nb = {
+			.notifier_call = arm64_hibernate_pm_notify
+		};
+
+		register_pm_notifier(&nb);
+	}
 }
 
 #ifdef CONFIG_KFENCE
@@ -1193,10 +1232,8 @@ static void __init map_mem(void)
 			       flags);
 	}
 
-	/* Map the kernel data/bss read-only in the linear map */
-	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
-	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
-			       (unsigned long)lm_alias(__bss_stop));
+	/* Map the kernel data/bss as invalid in the linear map */
+	mark_linear_data_alias_valid(false);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.823.g6e5bcc1fc9-goog


