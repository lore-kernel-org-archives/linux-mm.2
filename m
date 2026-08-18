Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86BEC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8D16B07E6; Tue, 18 Aug 2026 10:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5616B07E7; Tue, 18 Aug 2026 10:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DECFD6B07E9; Tue, 18 Aug 2026 10:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC8626B07E6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:13:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A7BE1C0157
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:04 +0000 (UTC)
X-FDA: 85114581888.25.EEF1FBA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7F12B1A000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QSP94uag;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jjw8ei6D5DHAoHfksoq5pXJRo86SyrfgeTRQoDQ1lPM=;
	b=gUa4CA/ZmarjgR0RWMe5gfNl0ENm3WU0Y/+As7l2L3jKBgBq3tnALB/aGV/jFSZFQvFdg3
	147lvlYpnRQsQwiL9yogTjrITKHGxHAvDFSbHdB6y5Z7CXSrv8QNOBsfyqACkB4lYQYY05
	2yz1ZXRgSKqy0ayE6S021YlFtFD6QMc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QSP94uag;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062382;
	b=1kEKdnuNWTCPdbmY5s7/a/l/vhF3LItn0EziuQ+2vm64KVDeLZJWAZHXXoRp9j5wE6Kvs7
	hdR+pp1b9oyTAkGGTjsadtHNiCqCgj6TK+aGaqvnA0b8BmzCxb33oCfznih/ABpiTOd1yg
	OG7yDvJdzp1dRyI/LJdgTl9zq5Rr2UI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1BA21A00;
	Tue, 18 Aug 2026 07:12:57 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A4713F85F;
	Tue, 18 Aug 2026 07:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062381; bh=AZS/qmiDqyYyalyFT0fayk+2twxYIjtBapS2JESmNTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QSP94uagRM5mQtJgReaoriW9rQvliNR8r1ZJ3oUzK9bkEZG4Z2oBnlR/jesx7nv5T
	 MUMNK3OmCMxrCDwSkWTs2eDllBWxK3og8BUlB2tk/ztR1f0mAPE226vlBjT7P7HhkV
	 WwaLpJHbyP1blczS0t4p8k3xA1/9LIOlOosZNJD4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:09:02 +0100
Subject: [PATCH RFC v9 20/25] arm64: mm: Map kernel image alias of
 init_pg_dir read-only
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-20-743ad31b2c8f@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062277; l=2968;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=AZS/qmiDqyYyalyFT0fayk+2twxYIjtBapS2JESmNTM=;
 b=zQo9evzSCEFr+xMZNuLdCY5hB7IzXLtzsT8DJWfg/QX4opN7VmkgL4CBcD8e6MJGjTCMykKIX
 PFdhqBrClYHDLLlqyMzlAXnMlgbwf7Qmjvvju+E6ewXcqE+Hcd1yys7
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F12B1A000D
X-Stat-Signature: 46pr5k5kmfx5zztbtmh6tqa3r3dixx1c
X-Rspam-User: 
X-HE-Tag: 1787062382-59391
X-HE-Meta: U2FsdGVkX1+WzmNp/mlIF7GJmtmsqBpoRPpVx3iw0YZXBSuXVtv5gtojo1gNWfqgs5OZENiJ0A2UX3bb83e4BZ//FlRh40yuIiIec5sPl+KxafIUISkPbORYKj7p/P8XXtKIlxaKzTy0LjsdPJhdRmZHxIDLaf4sCjr6MBBCsSasLyPobaXMhk5+b8ILrHkaBtxzW0JAILlG8O9yW4OuXn3eJVfBquk3jlpclxiRjFyeS1FPRFpGaGnQbDtYHeWCYRxA0+BnLDVNjBnCBtp87UI2UHdzvRnfRdVc8TgypkDvUHsz6pbar3hplhHGfki/EVoiW+bHavzB6f674lpzKp9+4aPyrf9G6WzokhT7FnWTF0lJmI6y1BHtqjNMatXQdYtNDpk3HTvBdHY/YXoLmlak7l0sOYNIGcNuSjyY/v3VKD5RSQGGw2JqGpY7qY65IogyYck4Izu2kwl7hs3J44+jh5IPLnadPOOV+cZTOuDjqpgCoHBzPP/GoUZZNqCiV1os2ttUJJREga0xyklNbetJUNmGK6T3jsQLW/wGvtgmI3RM1EAEA9T/InDs0qQcgU2oynE7yyMfQvOoMwNRrwtyzudnsbrlBjkomMC2ZbO4PF6X5pQOB632oxT9rkGmOH7EUrh32riVdC1QaVZ0a1//p47d7YVnBsboJscsUsMxOJoO0fDF9FxGhUiVEC4k4dSUAXfDZoZe4p4/amZxqHEV5khMlc7zcrsU2Rw6CvZ6uDvBHVz6RDNHdpB6k93mN7T5KBIF8c5FT3B+BqHfY2/y5mgzlGri9LXwZcqotP1m7HOOXDF4kVf6KWZ+oRFyb8Gf58KwyPjKLXU67+Eu725g5HIujmixCPAxXOSYI3C6mhdVZODDKDB2UfVkCPM4G2Ow91549GqGip/bSzbvJ2LXizSgJ9n2ItOmPvgRVAAst+ssrLdlN5tFnUO2cRKFieCrvKYZoOKly+P404s
 fL7g1mfP
 W/aJ8U2ltg2+FFIKa1VAUJJ6IsuRmN1uJu715RdMuBtIzgTJOCgDhE+8b/6UBaHyZSnfSHhQ+lPNq3RpzLP9DmomzH5HXIWci0bctO9Uxur3pD76p57i21oIJJrarnZ0I0lZ6vhiqx77LPCDY5x7foKLyhiuXldna/Q6qX8XmGSO/COcVQi54Zi7lm1EtvJmO0OjQh10Ch1FM1KllOnxfXvjOyOb+YsVZYv40xN5YehcVSzhDAd/y3rV3wuEVbYmRbUP4HLM5HGv5vF7YqGRMrmqZM7ZGF4ri02O5GTbXyCsHzl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Updates to page tables in init_pg_dir are expected to be done via
the linear map only. We are about to protect the linear mapping of
init_pg_dir using kpkeys; map its kernel image alias read-only to
ensure that the kpkeys protection cannot be bypassed.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/sections.h | 1 +
 arch/arm64/kernel/pi/map_kernel.c | 9 +++++++--
 arch/arm64/mm/mmu.c               | 8 ++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 51b0d594239e..dc961cf67168 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -23,6 +23,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
+extern char __pi_init_pg_dir[], __pi_init_pg_end[];
 
 static inline size_t entry_tramp_text_size(void)
 {
diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
index fb44cbdd2f29..81ca3e98f0f7 100644
--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -92,8 +92,13 @@ static void __init map_kernel(u64 kaslr_offset, u64 va_offset, int root_level)
 		    __inittext_end, prot, false, root_level);
 	map_segment(init_pg_dir, &pgdp, va_offset, __initdata_begin,
 		    __initdata_end, data_prot, false, root_level);
-	map_segment(init_pg_dir, &pgdp, va_offset, _data, _end, data_prot,
-		    true, root_level);
+	map_segment(init_pg_dir, &pgdp, va_offset, _data, init_pg_dir,
+		    data_prot, true, root_level);
+	/* Map init_pg_dir separately as we will remap it read-only later on */
+	map_segment(init_pg_dir, &pgdp, va_offset, init_pg_dir, init_pg_end,
+		    data_prot, true, root_level);
+	map_segment(init_pg_dir, &pgdp, va_offset, init_pg_end, _end,
+		    data_prot, true, root_level);
 	dsb(ishst);
 
 	idmap_cpu_replace_ttbr1((phys_addr_t)init_pg_dir);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a10e9f9876d0..ee972c78e45c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1217,6 +1217,14 @@ void mark_rodata_ro(void)
 	update_mapping_prot(__pa_symbol(_text), (unsigned long)_text,
 			    (unsigned long)_stext - (unsigned long)_text,
 			    PAGE_KERNEL_RO);
+	/*
+	 * Map the kernel image mapping of init_pg_dir read-only; it should
+	 * only be written via the linear map.
+	 */
+	section_size = (unsigned long)__pi_init_pg_end - (unsigned long)__pi_init_pg_dir;
+	update_mapping_prot(__pa_symbol(__pi_init_pg_dir),
+			    (unsigned long)__pi_init_pg_dir,
+			    section_size, PAGE_KERNEL_RO);
 
 	/* Map the kernel data/bss read-only in the linear map */
 	update_mapping_prot(__pa_symbol(__init_end),

-- 
2.51.2


