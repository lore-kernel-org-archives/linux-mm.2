Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98427CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9716B00D1; Fri, 29 May 2026 11:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1516B00D3; Fri, 29 May 2026 11:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F856B00D4; Fri, 29 May 2026 11:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 313136B00D1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2B211A01CD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:38 +0000 (UTC)
X-FDA: 84820773996.02.1F6E895
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD93214000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YGnwFhn7;
	spf=pass (imf09.hostedemail.com: domain of 3i6oZaggKCJ48PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3i6oZaggKCJ48PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066957; a=rsa-sha256;
	cv=none;
	b=VSuCE3TYnWG7gPm4BVCLeDtpgyrW9i1CX+kq68iXU2+9+QyJAzcG1ZbMYZkPzNU5lN+DMp
	ZJJgmGhuW9nVQ3mhfdaWntEtQlZ6AzPmCzYvx96aF9zEUgxfxwtlVE9HFbMNXN0q8oSle6
	q+MffMITQXAxCe+fwTLg+tQf6SU6OJ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YGnwFhn7;
	spf=pass (imf09.hostedemail.com: domain of 3i6oZaggKCJ48PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3i6oZaggKCJ48PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUlY0Cb5F8XLpE5JfjwZ+7xlX215FRQLeW3ZifZ4LCc=;
	b=yXyWrjoVuMrYcqa4XaLItkceBljVMNTHupaZFjk0vNtD952n7+B8Scfc0Cm8tpxDIVVhRD
	VqM+WUo6XiBOTVNc4IzHQ02xrayY/AQjenQv990SWtdtE1OsO34nyWGJ64FTDBzPJBsPDJ
	l0RNw/czW2WCAu60hZjur5sATDEgY2E=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fd33b4921so91254095e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066955; x=1780671755; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RUlY0Cb5F8XLpE5JfjwZ+7xlX215FRQLeW3ZifZ4LCc=;
        b=YGnwFhn7fhbcEn8tMMU01L8k5m2hRZueCmCyW0m3L7gAMwFUZbJ0B+PCYYNGYsCRZq
         jKjOrtgNvO+Ye+gwtgdo5fYQLFZ4zXtNka90godeqcrynJfBkzgRke2JxHKmu4x+Cbv9
         FoUhJVSKnnnYxIhDBBGxVU3qGULomTBb/sJT7Tc6wfZMJiqB5OufKWLNNG6iYIbYQ73M
         W8r3cJr3wwaRNUwuwrj018wz/VfsNw2PR9AStHSj3G2tjptxo7hhRtJeHA8usLM6xCXZ
         nyy4gNDoUg5/EvZCmFqtC12ef5iBLH/9X4LaBrSMmY3uCv9toH8sg8KmgWfS/MNDYObG
         /OoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066955; x=1780671755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RUlY0Cb5F8XLpE5JfjwZ+7xlX215FRQLeW3ZifZ4LCc=;
        b=nVR10tAFaS6cNYB+oyvmqnyIT1c7f8nLbtf+SdzM/LNdl8iDUCaN8KSGUl/XPWWDIE
         Pb+ww9vvfsjglpKpbl+BgdN10bohAmakS4M9eUkYjakBUjK62wUUPetqvLVelpg5RiFn
         Qjmde4YzCGEM0C6ap6St8ywhZ0rK9BniIR2/Rbadl/zUnl+5/BLdthnS3+5s8X1Z6V8U
         iQ/H/uCTFn9c+U2oB/UE9C2EVLhLxkZf8yTx1z6LkE5WUFJzysL1h2cX0XDeIATm6gXB
         ebNTI5IatoiBUGq7JD4Y2K1mBE1HonfwHAuTdY+4TBtvW349KfqNhBlU9bRx55jaUWpT
         Ew8w==
X-Forwarded-Encrypted: i=1; AFNElJ8iDmiCRNyhKomlMGCe8/V7RaAbKCZIixh6MleYLM9nRZtfnUV5uTI16dyym/KRYMAvYxPAZIXAvA==@kvack.org
X-Gm-Message-State: AOJu0YzmNIdOwzS9xgFPQniyNSExxMOP4UhlaJYwptEFOk9X/1Sycb9y
	NJ1XIPIW6hXwxokOvaxzKA2KZwLLPKvOoAA5uPklXk7g1MrMgnJW7Wpsh8YhIyqOHSirdbWS8A=
	=
X-Received: from wmte9.prod.google.com ([2002:a05:600c:8b29:b0:48f:de4f:a90])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b13:b0:490:44eb:c1d7
 with SMTP id 5b1f17b1804b1-4909c0f30c7mr58093455e9.30.1780066955148; Fri, 29
 May 2026 08:02:35 -0700 (PDT)
Date: Fri, 29 May 2026 17:02:05 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2481; i=ardb@kernel.org;
 h=from:subject; bh=hrcFvMrty6wWPLsRojP9eqDUmoO4ZLfdaegUjBt5TKE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVT7LQrk5StrVnhW9eSm1/NNic7seSLefqruzq2ZDx
 bLLO9w6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwEQWTmP4Z9y4/eO0WW8mJKrq
 1MW9sj4c8WmpWkn/Y9030oYr+jdxWTH8DxJlLpd0i0/zDFP5wK+8gt14wjNV0eevVH96qbb/sHn BAwA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-31-ardb+git@google.com>
Subject: [PATCH v7 14/15] arm64: mm: Map the kernel data/bss read-only in the
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
X-Rspam-User: 
X-Rspamd-Queue-Id: DD93214000F
X-Rspamd-Server: rspam03
X-Stat-Signature: frdzt8bpf7nqgnjaucxwmmr4qzstqofu
X-HE-Tag: 1780066956-316201
X-HE-Meta: U2FsdGVkX1/d6LySEjR6XHczod5pcljcqNCwHA+pI3Uq6M8QjcjzhWWqltlzFiyePaI0pf40/UY9eJe8U34PZrxHgya6tK7EJYQrmKkM1xjR++cz/WJQk7pKJZzRX0Unbsezyc6jH/VIZyxbeA4HIRtXRculFSBqaBImsSoHqlwUsfouxziY8rmvplS33giVnC+KKAbJh+2CTzbUr9QUE/tmf4edTmQ29fUH1Q6i1EY3LSVVI8PrK1xPI8C8G9YeJSfRjG8YxrCvnPqt/IiQfNY31oL6794TZh+/RfqG9VBkA2EVdFiCBcVWuTwDZRuMdVsPoG9+7EjSAamj8ZMknTuZTCJVB3OLw3mqT47uyIA/SJLtoID3l1o/3eSBotBXI6+sMqvyEnR+wIi5wAvjP9hLvqr2vNv7P5y2DpqDdH8jMC5vCmT/h3tYAB4rTbT4HV30j0VpG8gcajxBBA0YwfFWeKVcfZHY0itV5KjGFtLJMsayRO0215cgOEszNT5OSkJgjIwLjKEsergX8MLeaSauh6Te67tFWMdAVCSsG8sV6NP5tP59XmLbSZ2cv/5LW7/nyFY/8Za7cImM/DDTMUOVzDTMKnM3S8qfN4SfEiFLSIi3swUjoJej/CsQlQhhSLaLu62rA2vrOGprajcY13kkjxvlUC+uIlt7zx4ZuUBYfv/FqVANv6kV6mX7c29zf78Bed/bsPVm7DhXdmCQ1oDHrHYTVtW/yb5LJCJZ8ggbnkJZSSBTkFUY/wgZCbfFqMh/FqvwfBlbnreGNqJYXXjRSJtkeJquB2AvUxJUEoDh5Rm7IsYkrwwZvjCH2zSqvJfLMAFCYk/9nWH8IYKHzIO3WM2G1oo1K0f7qZ6pVBuJvb3TyfPNq3ktgzoXgR4BsWcukF2dUT177IPKXkQ3Q8AwHdwOSgVtrk+OfIs4C9Y7q/G2ySioNt9nHLJ1xyvZMS6Jf4mCxlpIzJarXaS
 /+iS+w7s
 wtiW336LohXHMINVBiynCjP8QfoTgZkzHMsYlxkh0huoJ3IAseb9DaGG/4aJeofuYIj+vKryaFEd1fmfEje9I1CZE1o60RjGGtIg3z7vpHa5R3r3r7uy7H6zShsl3vF/oIoJvWjiFtf3FAbSK095lTizXYXdvYh6UujJ+KepcrvM8cmE2w2eFXAsXdt8OqN1NE2PGrW01NBeicBlGdmkRYFfaatiXfMqhgxNLhHjdsR2KsOa5H9/g11bpLI59j6InkVqDaK/LXT3Ys7fNEeCJ1n6RnGbiYNhaiDQ7c/Qdtd7HLw65HUZ5eFrcqVxvFWpNRl7TqmOhEdB/lB6uiP+22uKaIBPR6r/gzj00wgyetWMw2tmhQuw2D667emZlmKE1sM0OsxgATPdUnOdECogaq1CZh88Jy6AC+sPHl/RM3F49YiySYbcXkAnPQi3szB124Bn9L9IqrEPxFZi1/VKnDx0X4Lic37i6+4vFVHz4i6TBcYgAZ0OAxZXdl/hj/TQBZ94a6+e69lX8DjwaNpOIDZ5x/vtF/w822NEf/GuEGNuQk6CuXq+T6jcuOwhJ+2GE0c3k9lQztE5OZkRsJWu7DCNswZkdJEViX8yImO5ykHZPLvU/V4tGSx6NmsybXx9chAkE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

On systems where the bootloader adheres to the original arm64 boot
protocol, the placement of the kernel in the physical address space is
highly predictable, and this makes the placement of its linear alias in
the kernel virtual address space equally predictable, given the lack of
randomization of the linear map.

The linear aliases of the kernel text and rodata regions are already
mapped read-only, but the kernel data and bss are mapped read-write in
this region. This is not needed, so map them read-only as well.

Note that the statically allocated kernel page tables do need to be
modifiable via the linear map, so leave these mapped read-write.

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dcfca5667e5c..7b18dc2f1721 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1138,7 +1138,9 @@ static void __init map_mem(void)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
 	phys_addr_t kernel_start = __pa_symbol(_text);
-	phys_addr_t kernel_end = __pa_symbol(__init_begin);
+	phys_addr_t init_begin = __pa_symbol(__init_begin);
+	phys_addr_t init_end = __pa_symbol(__init_end);
+	phys_addr_t kernel_end = __pa_symbol(__bss_stop);
 	phys_addr_t start, end;
 	int flags = NO_EXEC_MAPPINGS;
 	u64 i;
@@ -1173,7 +1175,11 @@ static void __init map_mem(void)
 	 * contents of the region accessible to subsystems such as hibernate,
 	 * but protects it from inadvertent modification or execution.
 	 */
-	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
+	__map_memblock(kernel_start, init_begin, pgprot_tagged(PAGE_KERNEL),
+		       flags);
+
+	/* Map the kernel data/bss so it can be remapped later */
+	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
 		       flags);
 
 	/* map all the memory banks */
@@ -1186,6 +1192,11 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
+
+	/* Map the kernel data/bss read-only in the linear map */
+	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
+	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
+			       (unsigned long)lm_alias(__bss_stop));
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.823.g6e5bcc1fc9-goog


