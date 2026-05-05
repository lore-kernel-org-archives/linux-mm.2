Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBDAAFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC666B00D9; Tue,  5 May 2026 12:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DB06B00DA; Tue,  5 May 2026 12:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6A86B00DB; Tue,  5 May 2026 12:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01FDB6B00D9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A87CB1C10E8
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:14 +0000 (UTC)
X-FDA: 84733848108.24.EF880A1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id BE2A080013
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Sz1by1e6;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3dq8O6d8NmXc5O/4sli56t/m7UACYHp8TI4lFc3/NA=;
	b=0/IYonXXMdX5C+2PNs+n/izdhGfeVE3ebS/EImuxwpNMJ9AjF47RAwjH4aGNhtv0OGbB/A
	GXHsSi3nhgScK1frkgrtgniQsH4V0cighEvf98PM6JoISB/KrZeJ3pkXcXDleKzcuNe0/n
	Mh/rkjehejCIqmBJ3NuzL3Xf9NGWkqI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Sz1by1e6;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997293; a=rsa-sha256;
	cv=none;
	b=r5mDLL9SagMz3x6S+2rdE4rZ+pfsgOUWiY6VZ94ROa3sUhxWl+xTjxGQF5258eGy/z7taW
	dpiol+2cSfvwKnexo5NKhPsY79oftxMQFYd4Z0Lx/Tzjf3eVwV24bG1UQssfzFXfvfERJD
	7QyQ+AZBs4uzsw2Cv9ZCJUyranglfIc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CA2414BF;
	Tue,  5 May 2026 09:08:06 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96D743F763;
	Tue,  5 May 2026 09:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997291; bh=vINnrx3zWSjR/6habDkgMgD8LqwrfTQUOR9ysKRLj5A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Sz1by1e6eRhCELKEY+Eyq+rsTuniaXf5+PqT1X0yQjZIReJ6Gn5u8T9Go+2W19DZ0
	 raHdjjPsdL4frdLCpTofS2QdrvQAAIRb1YoQDErymK5RqV/u7JS+71Nyan7jKhDCQ9
	 gLo7S1Or5aq6f9fM8+yiKuhAEZ2gcih3LDnAGiC4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:04 +0100
Subject: [PATCH RFC v7 15/24] mm: kpkeys: Introduce hook for protecting
 static page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-15-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1755;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=vINnrx3zWSjR/6habDkgMgD8LqwrfTQUOR9ysKRLj5A=;
 b=urhbr3eEotRkuf/VqGLzk0z6RAzpgYY8gl0kZHrHnrAINYjJtkYR1qbJSvZ0vXWCYj6mSlhWU
 aFlEW0GDkSuDNt6LxoaJCvAZ3wrc1GrmM9zW197X5jDBxuHt+bxXaM5
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE2A080013
X-Rspam-User: 
X-Stat-Signature: 66zs6xkubfk64n1szkgexw8xrtgd37sg
X-HE-Tag: 1777997292-559504
X-HE-Meta: U2FsdGVkX19koxKYUNJhvrt1GlcAUrtkJ3XHeDNmDCrNO1xkxCakhXQ0d1r67M3/HmLhP0rp5hqDSvFhiEV3uXWowUADZR7ufag8wvBKHfPzfDiUyALG0I2RsO7J4dn1jEQI31UtQzEGr+Cmlw8cpPR+tcU9ZLJIC9fwiJbcR6y0gGPX8BcGELOYZL5+E0EoszP1Rl3nQBQWKLqd7CxRSy+ioDHSYYFZeea+bmgbvbtuhl5v1aaKviVMYGY/rJbbCTgQ45gdumzXaj6FgvMnRbBFlpHoGE7U0ojwEjwJPAGo3m+Hq/EgLe+wuH2hllo7NC6Lg7gcf5lL8BVseq7U9glOR64l9vGRMIkELZZU6y80S1q2a3JCzpRI4pi5OAHFDslO9T3jzRY85A0yP7bFEVm3KqVpuwH2BbyZs+Xbb7nL2N0bX1/HVP9XOYfQbLK/KJe5BvmOu/ScgjTTWSuEItAW06jGxaM2s7JnSFGC2TuYVGCetSZokcgL0+dO/N6tedd7PcbF2hL6ufgIFdyOgR+usyZKOMeezxB6e+uVSl3ldL3xYaBh/CUMrGVMJZ8l5SQNCvidlx9y++VfIWFsjeoCDLrvRFtznBHA4I+ttJo6zr1C9gfp/42GFk9rTs6hMztqkdtWl8YdcJAcuEEjpP7uskhYjLCl1Yi7l6nBfsrf9lRvmD8y74VM8ZGPAVDIHugZ4tQ6W+Ttsv3thNhIMZXyBqemSqkXkonohbwPP4u5JS5MX85XwkJzAu1nb6m8kHviEp8DyVNaWDG6SPbFpdIT70akWDCToReckicCbAiVdk9I7ICEab4j0cPDBt/nXvwzMwi5XSio+0fqA5kiP2EkXhhu1z2kBdwfLywKKKdUh1lSmWAiZAfZT/Qy0MVWVbNLr7UsYz/5x//GjD6KPbWD6M14Y6Xx/mftD3PofPvoZyksnuFc2Gfod5dlFwU7hpBWumh/w5reL61PF0d
 0QDpmgLC
 mJ7AbmX0AEgtChajvcs0eipFAcs904oDuXy26142oftSk1Y5b7RHV6p6UZWppTumB5N8NYEsva8nVxq+jzdFAzYws4qwQbhDq44hlly+Oh98qHedUu8iUO+aTsjff7W5TO/0aWFimxg+JH+6gmRWf02mxdIgw8fwYsABima1ZKYnIYgoGPGWhnOn2VQhvYPL2pa42yCP5ZLzoh4jD8gyQJoAynlaX4OhtZY7zxj8LbfW6RfBcvcWdipFJh6lX86aTR3ySPgDVhH83yUgUAUP6A4bBALRFAEjVZY2Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables infrastructure introduced so far allows
compatible architectures to protect all page table pages (PTPs)
allocated at runtime (first via memblock, then the buddy allocator).
Some PTPs are however required even earlier, before any allocator is
available. This is typically needed for mapping the kernel image
itself.

These PTPs are at least as sensitive as those allocated later on,
and should be protected by mapping them with the privileged pkey.
Exactly how these pages are obtained is entirely arch-specific, so
we introduce a hook to let architectures that implement
kpkeys_hardened_pgtables do the right thing.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        | 4 ++++
 mm/kpkeys_hardened_pgtables.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 544a2d954bc1..3f7f980f3a7c 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -142,6 +142,10 @@ void kpkeys_hardened_pgtables_init(void);
 
 phys_addr_t kpkeys_physmem_pgtable_alloc(void);
 
+#ifndef arch_kpkeys_protect_static_pgtables
+static inline void arch_kpkeys_protect_static_pgtables(void) {}
+#endif
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool kpkeys_hardened_pgtables_enabled(void)
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index c7a8935571ac..9c6f32741009 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -66,6 +66,7 @@ void __init kpkeys_hardened_pgtables_init(void)
 	static_branch_enable(&kpkeys_hardened_pgtables_key);
 
 	ppa_finalize();
+	arch_kpkeys_protect_static_pgtables();
 }
 
 /*

-- 
2.51.2


