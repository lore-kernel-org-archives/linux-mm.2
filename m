Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53C7C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCB66B07F0; Tue, 18 Aug 2026 10:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DA06B07F1; Tue, 18 Aug 2026 10:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3586B07F2; Tue, 18 Aug 2026 10:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7A46B07F0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:13:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 251481202AB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:24 +0000 (UTC)
X-FDA: 85114582728.29.2F54E11
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 591CA140006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Wakfnd/j";
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062402;
	b=VDSAs8VuZhUCaiOwnmUidvlE0SBprXI90OnqaDHZmxTtAav+9MMhWJEfLFU496WduNGTI0
	uvY5jKqe17urPTbXIOKO2M3WpIs0H6mO+3Vw83RFoIPVGLSryDkrrV7P5zeU5sWVTkKi7b
	jwaJ4gRiQq9LL9TBspIYZIBraugEMPY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Wakfnd/j";
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zPPQMLYbkiU4NDPeUT+SBUqfY1uJWSL11Latg9M1ZQ=;
	b=qQiuIWAPiwIxqCg+fRSr4bkTTII372qhU0qOTjuBZ490ocwlvhIxR8T3vFcW17Azn9Rf0l
	pwa7brzUCDI9NS++2hfLFNmxikF+BZFqBou556+gNktQ4wh43iu1eaAk27pO5NZvdcKNt8
	2Um2oFywv+PV/iibav9Vgab1bomUYDA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB94D1A00;
	Tue, 18 Aug 2026 07:13:17 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E704D3F85F;
	Tue, 18 Aug 2026 07:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062401; bh=deqcIO8WoW8ZUIxodPxPJxHyzGgyRHFEpIWwkIpsoHY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Wakfnd/jp0XFaEXDa8GOOOrShfuIESM4+0taZqqVMIl02MEpCgGw14EgqvvyL5yBG
	 o1+mk+qzVPuL8Rd9ieuL3fbg0f2zvcr1KENhYiYcPUpj9JoXCujFcnK0U/7B5OsrvO
	 mUs3g3DyPckWZwcg7iQ2BnXyxqiVKdropvzuz4AY=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:09:06 +0100
Subject: [PATCH RFC v9 24/25] arm64: kpkeys: Enable
 kpkeys_hardened_pgtables support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-24-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062277; l=1336;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=deqcIO8WoW8ZUIxodPxPJxHyzGgyRHFEpIWwkIpsoHY=;
 b=8Zvb9dgw8pGXz4V0LB4l31N6PHQBF1+79rdAlXKfUMt8pwgyVAcEZlljLDnHbeenNl7hIsZ2G
 qM+wAXlkOfZBjrezKjv9TZqt0L6GYTtrJd9TeNXf9l835YTjNO5ekJ9
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: 591CA140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: o7rkm85cykcgyeti3wezk3qoahezrns6
X-HE-Tag: 1787062402-708790
X-HE-Meta: U2FsdGVkX1/5noqokLKOg5TWmLHvGarOHxTE0EI+zVat8+WvrNYad8mUldedCIuPHGQIkjIJ573ajq35zQQ13lKboqyZ3JPizjc3w+lSj7yTOoDdiauO3HZIbRH55XrsJun/g5IKa796xmqWyS/JZb3q6n6p24XC5IxNlrVaWTFjNv9kaUPegv4LxmAy/8FP/AoUk/KVJ399v7/BWRwP+uIN1s9omkiZ2GMSQMMeN1Sbt3z955N5a7zIAIn559qmSudqYkI0Sk8IaMHMQfa2iS+Z+ZD3Wu8uAr5sZoJgm5lQ0WEpIXgfLjl+FfMwF3pZYOYNkSdv60NpFIz90NpIUtqab9TQe1J3UZMLURSjBj/nm9LQF62rF8O4ydE1gTButL9nErwy8Z1LyHUBhtLclKj5Zbd/kD0IFC2rKSjzMwbnS8jiG0hCrhFFKSbaTxuLY9ymV5lMebUk8Mutu8qbHp7QLbN+4UJiNxDSLR3mLm11wt/7tdXkX/2gpeyKHyXefiHA81OBVP5j5swkKcI8DKRcfXRDp1wEF9/b2+pEojmA/RrN/JGnBPBOVASx+6D3cIR8Tu1nDJmlydqkcl41WST8J6euza4ikQm4qTxFTlR8HqqmLkwQK0Hy1VA8yX+duhNDkMpPKdDTJnvXW0Axb6GGmAeSSBqMp06IOBVReGr+2wCqKkJ0PbwEituS7N433lX7wHvmZFucZBhIiwbiMMIZaXD1Pwxwb1MpWx6rBzYCVtHRUlTpTAxac90PXzN+7WGgqvQu1P83Fp1vXPlBjYt3wbTRBEkFF+jJJMkdzELa37L0cU9JhL9icVumJPdql4n3HbWxs3dt/zHYoCNgKosMGxgyAthBY6DLGp5bZKn7PEjKQXbi6IfB5kKxtjYWPamEVrXN3DcDJdPfbPMSfgX+HtMzIHvFi+LK8ox2hDmIV+nYx9lfGMjl3kAfJXkdET4KzPhP775jVKTVTUy
 t8Gn4ieV
 AyuJXp+eaF9XkweRqE9w8qPjW+sFNXXtJZ4noaG2kue1w5+w50OGCnXaPYErC/yIcjrdBqL5CPIXHa6K8rUmE4zHJMTvIPAhiL1QAV4ha7NiWXFCTKMfkqAFconBvB1JUVmqXIJBq1hZ3ThGlGghhJg7aL8ffRUkDKHo0pTXc12JhBCsefUoo19mEP3SkYtuPRiPLlaTqgRbZO4/8MOrm4I3O683mvz+AZj2A38lHYHA3Tg76zFC3iGCZiQZMfsUFW+RVxvRO/YUrbvu8GGL0IeNO165tvPUwS4B855KcWMMRFLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature needs to be initialised as soon
as the buddy allocator becomes available. The canonical place to
handle this is mem_init().

With that done, all the bits are in place and we can advertise
support for kpkeys_hardened_pgtables by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES if ARM64_POE is enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig   | 1 +
 arch/arm64/mm/init.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0afa085c66be..ac9faec1a018 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2203,6 +2203,7 @@ config ARM64_POE
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
 	select ARCH_HAS_KPKEYS
+	select ARCH_HAS_KPKEYS_HARDENED_PGTABLES
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 97987f850a33..7985045875cf 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -386,6 +386,7 @@ bool page_alloc_available __ro_after_init;
 void __init mem_init(void)
 {
 	page_alloc_available = true;
+	kpkeys_hardened_pgtables_init();
 	swiotlb_update_mem_attributes();
 }
 

-- 
2.51.2


