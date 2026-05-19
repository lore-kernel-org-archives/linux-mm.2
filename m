Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8EA9CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73F96B00B0; Tue, 19 May 2026 11:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D296B00B2; Tue, 19 May 2026 11:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61E76B00B3; Tue, 19 May 2026 11:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C09C96B00B0
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B994A0596
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:44 +0000 (UTC)
X-FDA: 84784526568.26.6784B1B
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96341A000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RekEjtI1;
	spf=pass (imf25.hostedemail.com: domain of 3UH8MaggKCNc3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3UH8MaggKCNc3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qi1oGcfy2F/V9hqGyvfMuBPdpU5/rEAVHW7aQyISR+Q=;
	b=W1y7ZMcJl9talvc3EYQMoanRpKqoUnxNuPzGKpnFFjhm5+nJK8EaR+I/dajjTR4k588JD6
	tNjDSepOpfMHn8aUi7AhAjvy3z6ut3mkKxRrngg5px26ty6zjXUxmBfB82sxFLBn9tJdPU
	c8d9QLZkoK855fXUPmmRG6ZFdl08d0c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RekEjtI1;
	spf=pass (imf25.hostedemail.com: domain of 3UH8MaggKCNc3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3UH8MaggKCNc3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203922; a=rsa-sha256;
	cv=none;
	b=DqvMVNS5wWGt3isfyQX782cEAmzzMsqC2vTFqPPHCmIQGDxJkF987CtesjNu7416sg3tlP
	C6THa61TTVnImWQRONq8ZglOWBbcY/l160/KyokcQh5atyQt5GlzpbQ0anq3o6NWMSiZgH
	f80ENKEALAQ+TbtOvO2Lqzh5x+ZTV0Q=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d7730e9e3so2108354f8f.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203921; x=1779808721; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qi1oGcfy2F/V9hqGyvfMuBPdpU5/rEAVHW7aQyISR+Q=;
        b=RekEjtI1VCOWXoZkhs9EfED4KlLr0Eigk+bx2Y022pCLy1lh33ktMJN8p+F+hmJm+Z
         tLeB+Whmc64NK0arqfoHKC2OQGounQHEfPiT9RxnuHJxbl7TRxYaM52XbfGxlVDQdyTT
         hf4v+MWF4y+sFY2xw9jMK4OEhFz42U4NOT1PlFf+7V7mfcup5nkVx+dpRXPX9LWAsDbq
         b/phJ3KKZPK7mkK39TXcYmtJur+gyaDP90eQoNPFN4v0Xg041+9+kl92hg6BuMhewd7d
         KVQS0i/PZl1tA+IhSnfZdFriTLfIKBY0fxkcgH23/lCFZI05xV3TD8BRii0p5w+6pJlW
         JcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203921; x=1779808721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qi1oGcfy2F/V9hqGyvfMuBPdpU5/rEAVHW7aQyISR+Q=;
        b=AxVCcqN+IuAz8NL5FJ8ZMjp0kzv1WDTZMJ4tjpGXGoxTjW8jtmjmPRvBK8gaYVpW2a
         j46F+9nHb6Nd0d47Sayf1qbd6b7Abvpgb32JdzqHfz92ak6YvRj+cjNqAB8PG+p+E4S+
         fpOGnizHgmTMKtwvjJZ1s5v5h1TUT6dYLQHtU8NWrYj0zIjnlySO4C+qjaVch0LdMq5F
         6DRyDBixkiRcuX4mw9dc+Qb2Wvuu8q7axreHIPgvem7O/ZREfNsKy8zY3N4meZ/yGDLA
         gegFOHZF0P2O290K+kbF9XRQMCV8wkBC/CYdyDS94bT2Ba4epSg/4eZ8F48S0RQr1mX2
         jPOA==
X-Forwarded-Encrypted: i=1; AFNElJ8rubBpKkG6lqqE+Z2l4o4ZwPvnBNHkDfZK1vtzzlqNEeV5Gf3lzw3xyqrNgf6e+jf8hSm2mckneg==@kvack.org
X-Gm-Message-State: AOJu0YxpHcYeZHqI7SSgXfebCBUH9CMKSuWBqoch1qpKZUCZgJ7RAZMH
	OZnpv7QwVS2bXlDe1uAjUdUB0p6T1O1i7XcxOcviCH3KwvdXHIYlOWNyqemDmkZactJbp1HTgg=
	=
X-Received: from wrsy5.prod.google.com ([2002:a5d:4ac5:0:b0:439:dad6:4846])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4305:b0:43c:fe66:43ec
 with SMTP id ffacd0b85a97d-45e5c5af3e1mr33968405f8f.14.1779203920289; Tue, 19
 May 2026 08:18:40 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:30 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3044; i=ardb@kernel.org;
 h=from:subject; bh=osZl6uzkZYEkcghfaazSssjo1b/cuYAKEwUCEYJfinQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7uqNOWVWU5/UXRVfylrTJVR488jUvCfS7J8uTnXol
 rv8dKNpRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIPx+Gfxa3bjaemqQ2QX2i
 +ikrecMj36z+NBrzXBW6mWT11rhKfD4jw9WmHq2SKWv6PLaLbc0reKxz6lHq+tMT8qoXvdRc/Ph gHBcA
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-28-ardb+git@google.com>
Subject: [PATCH v5 13/13] arm64: mm: Unmap kernel data/bss entirely from the
 linear map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: j74hqbi8y7e1mfuk4ia9yrhy9mtzgucs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96341A000B
X-Rspam-User: 
X-HE-Tag: 1779203922-211959
X-HE-Meta: U2FsdGVkX1+1rH1agLNICkhXOr0CAx11s4V9FO1Vfjgst4wi2eHpOXTLtd2JYI4GRICVcVnA0HqFDye6d9BlWWKP5RIWgKCaScd/CMZpfWx/yCtG8k+Z8jEGHA+rRgcsHtVsM5z8GGxWs+FZg3lryYlePrV9Cw+oVF1+W8Ut7YanCp4BXaeWd3aPmsd/Xs38E9LbnIKVkS5bYnlsG/92Y2PpKU0q171NyMNf5T6PXweMBFh/s6oO7WxLMveyDHRtxFxALfojzn36keoFb4pgggxZKAz/JTOozDCJdWKXXA9U6ZulfaTwVsOzLiZxfx6MxU1cLy4/SzNKzBGXvha54JniRCQFGXv2ZH6HQEKdXBjHtjPse/qq/zVo1ZsMi4PmwVAL10eivh/h6qnZp9a+8wl0O5Qi+kpNbCYtEHGB8csCxeLZ8rPKoy9wFBluIF+xQImp4VTBUK7UjFAdmcoUxtLD+p7nGWspy3APYRQdHoOA3I2DNEBlMoM9w72iOGgiThnH6Sj/HS9/ZwIr3NxD0cqa/8L1qADQWZLPCiYRt2/i98KiU/3IEH2r82Q2nL4tGLSHkB1NQH3a+1y1zQyuJDYxktNPJpXUJqa5yD9Z05t2e1f68T7m0j3+xuqR2KBG+D8J8/nLtt4MekUksnfAdLKhxcbO7P9Hi6jmfEfw42DChE3tl+MzIB8hqwFRlJqZ+NDO2oRZuUb3JaHk5nZMtnHDkL+3qSIeqTYVv26hrT6//SY144rGkWMuVywjFaPWHh8oyz+nmFtAxbXbfaWnSWqR01iv2z8a3QUn5iPzmxM59AAb53qvYof3uvaiwH3WpwGoWp374kVkBwmE0CalbVbBF4Jqga/1AgT9JE5R201js61PEZwoLomCS/DW4o+Ngpwfc8XeztDeuLU5XRv5HUH8YWyagr5R/BenopHRCxkogWxH2PVXObgQ8Ap1Wj4RETeMzLrf2hucVD0I+WA
 ejtU9vav
 /eeQQ49wzfAf77RGYZEVtdgoyRckDcafRh839b5uA8fG0jFctOnTE5pagh1+tbWQ3gdPaRKnTmTopDec9ErfeLGDdh0gi3BqRyq7UzkwWKeZShu91dMJ60m+Y14wyeu2glqiAdORX03cNRt+B5NKaMczOPE63l+U5NP0xiBDGgSmS9ebxp8grIiK8fPRpuv08X7tJMWzMbLAKVBcp9E8qfX6Gc1pH+RS+OLY4jvD8l06CNDysZdfLLA+w7YfQRVMGpeOZAjFAbdKN9xhUHSNJe8nlK+SEONmDSmXonUQo6g3mk3RomS62Al+remZHvVI7etsb5pNjOjWf9UlH2cFcP2wYZ/MaiGmT7d7iW3rklVHL1ZfR7UVTErrvpNqRmRMC18Vlk7w3UT3svUewDRFL7BlOeJxB6voabTpg20A5g7V4NMcGnMyp8PvXJhacaNNUKXPrNeEr1ISF02evVrfa6OvThbyvfgRgMSCjMS6sqd3ZN7GvsGog6pKVpO7WZp8puN/fGpWj30ADF+IXw9ejrkUgNkpSReBIzSVdEkYzuR28yibeAgbeuxJ03rVUmWWyX06CzsFxX0Wv3SHgt18hGbiaQmvBRsft7NlY8cID8OHa4MU=
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
map/unmap the region as needed. (While the hibernation snapshot logic
seems able to map inaccessible pages as needed, it currently disregards
non-present pages entirely.)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 39 +++++++++++++++++---
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 136cfe0f7375..9b6d90deb6d5 100644
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
@@ -1040,6 +1041,29 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
 				 end - start, prot, early_pgtable_alloc, flags);
 }
 
+static void remap_linear_data_alias(bool unmap)
+{
+	set_memory_valid((unsigned long)lm_alias(__init_end),
+			 (unsigned long)(__bss_stop - __init_end) / PAGE_SIZE,
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
+		remap_linear_data_alias(true);
+		break;
+	case PM_HIBERNATION_PREPARE:
+		remap_linear_data_alias(false);
+		break;
+	}
+	return 0;
+}
+
 void __init mark_linear_text_alias_ro(void)
 {
 	/*
@@ -1048,6 +1072,16 @@ void __init mark_linear_text_alias_ro(void)
 	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
 			    (unsigned long)__init_begin - (unsigned long)_text,
 			    PAGE_KERNEL_RO);
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
@@ -1174,11 +1208,6 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
-
-	/* Map the kernel data/bss read-only in the linear map */
-	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
-	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
-			       (unsigned long)lm_alias(__bss_stop));
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.563.g4f69b47b94-goog


