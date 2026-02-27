Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06EFFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6766B008C; Fri, 27 Feb 2026 12:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A5D6B0092; Fri, 27 Feb 2026 12:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4870A6B0093; Fri, 27 Feb 2026 12:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34AB76B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7FFC140734
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:04 +0000 (UTC)
X-FDA: 84490990248.16.58A6C5E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23CE0140013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5KNauu9vFOYUBZC6C926XbyDcTB/1Jhr3Sj9uP+OnWw=;
	b=eXUs0rC3PWj9YCk9k8ogmh8HYA5i0Xr5DFOx5B9AW+h+L7FKjovok2oLf+FAjuXStIaB9p
	ImWgAWEYeMw/rljiNllSQLSu0Xvnz/93HptaZz69dka+BzypruuNBaaz+eVJjkIsMR7fV0
	ksstFPjJ1VWWVW9v3TYmiu0LM3lPOig=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214963; a=rsa-sha256;
	cv=none;
	b=OcPJOOwT+6y73+Tu+SCZsYasMV7dU0EHpk6RBLCKq/asWA6jDA8xZg5rXxDDvKkdRO6rod
	zJh8joZD2NuMjRyJEYQd/jWGZaSnLNNvr4JOfSnLB8IXZULKxHimlkIsh/CCVLw0IA5+dC
	8QwpqEuNBBj5WMcBEkoXDHzauz6d968=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 017AB1516;
	Fri, 27 Feb 2026 09:55:56 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DEC843F73B;
	Fri, 27 Feb 2026 09:55:57 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 04/30] arm64: Introduce por_elx_set_pkey_perms() helper
Date: Fri, 27 Feb 2026 17:54:52 +0000
Message-ID: <20260227175518.3728055-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23CE0140013
X-Stat-Signature: uwmksx9g6fyjjhb1h8r8emdbn13an4zo
X-Rspam-User: 
X-HE-Tag: 1772214962-571959
X-HE-Meta: U2FsdGVkX19qMiyWKUfxAjwath2UFTYzawjKajAmoyF2lACDaJDbR0mHz0a75nj6GdfUPNHY9HB1lOiM4d+Nqxn3IHiOdC1Ire+QCm7Hjas7jxRKDvI5mqkpZwGf8OmX4LTp5uIo+7EtP0PAypTeVCvnE2DLCi16RZeCJvdPs6HKJM70h7GwmvPDRhn4Q2JTaPdr7bVPnUKILf9NtCI3aNrADbuFeFuKYOE8EDHpC2k0r5Y5wGTnyNSumw8GmRGPTvLLY5MQXpl/Iak50bd+v98/knE3uezTHGLgsCSuNgBfN+NoMNXXCBa+b2FpFcAk18jR+OfZLR+VHy+obslGQ4VC5VrGjGqUq+2WMPwDiSbUYrOFsI84eExi/JNZVoBuwtrZMsIhp0LYaVAtMbUIZQzCxZoAPVm4W/wgANO7H+YeKH7H3mLZH+j9qKifNgbjiQ5OKvdaeRF4cvRHfFw/gVX/2s5m6+JtAVLZzPLKB3QHW6EwaFvd/cejrDk5eViixTQKuPuzwRYUEEkuxMzNfmPh3L7VpEOkGXMWakZUq06fX6pkT+5LSWmiFdML9+lJs5gByljd1cshc/1C5mfAvgOUDAl481u8bOMLGmJ77cJp8+pzjkC5+LTv09dIzLjGfcX/erA3yCFzWt/N0NyRTzOOrLh+9qUammqN2orQ6WANoMa8nfwv7+aJvFQmGBdk/x3Pnt2hg6Lm2b3aPixj1u1fHsopZ5SUgeGeP+dpFbeSaNrY2e5x+YKSnP4JgAeu79A6mAZZ3PRpTPArNQ9CeuzR8/DsLftHWGoRFnpyOK1zzOXQEwbwJ4wUbIgvz33kckBhZKzmMllQoLb90hIAbddvLzh9PL1OY7cxX8CulHWyNcGVkMsRPIR75F2MMstp3Qrs7xC/y2tn+/n/lETppwUtyHymInhG0HYQFsLW4MtLSVdi5oXbbdLYoMPzYCJVOyiK7t6d38BaM6BTod3
 T5YKyL4R
 YJpFw3HxgyyRP/Vi9oA5RqCeIbwNQ4qg46DxyIYd78FbQD3di7O95Cc2hplLZhcqkm+GR0Ke8ENV2SK+ycu4MeJRnz+JY0tY3lcNjMlqCzO1tY3XC7aDPZuevnzTgA0QPA5LtUx+3xL4uO+FxzRu1yltKeVNYDGNgpoVVQY7aVm8tBEAtbvs5Lk6vbirtVFvflO+/aJCkzLFYkcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a helper that sets the permissions of a given pkey
(POIndex) in the POR_ELx format, and make use of it in
arch_set_user_pkey_access().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/por.h |  7 +++++++
 arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
index d913d5b529e4..bffb4d2b1246 100644
--- a/arch/arm64/include/asm/por.h
+++ b/arch/arm64/include/asm/por.h
@@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
 	return perm & POE_X;
 }
 
+static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u64 perms)
+{
+	u64 shift = POR_ELx_PERM_SHIFT(pkey);
+
+	return (por & ~(POE_MASK << shift)) | (perms << shift);
+}
+
 #endif /* _ASM_ARM64_POR_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a6a00accf4f9..09ca62f77a84 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2208,8 +2208,8 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 #ifdef CONFIG_ARCH_HAS_PKEYS
 int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long init_val)
 {
-	u64 new_por;
-	u64 old_por;
+	u64 new_perms;
+	u64 por;
 
 	if (!system_supports_poe())
 		return -ENOSPC;
@@ -2223,25 +2223,19 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long i
 		return -EINVAL;
 
 	/* Set the bits we need in POR:  */
-	new_por = POE_RWX;
+	new_perms = POE_RWX;
 	if (init_val & PKEY_DISABLE_WRITE)
-		new_por &= ~POE_W;
+		new_perms &= ~POE_W;
 	if (init_val & PKEY_DISABLE_ACCESS)
-		new_por &= ~POE_RW;
+		new_perms &= ~POE_RW;
 	if (init_val & PKEY_DISABLE_READ)
-		new_por &= ~POE_R;
+		new_perms &= ~POE_R;
 	if (init_val & PKEY_DISABLE_EXECUTE)
-		new_por &= ~POE_X;
+		new_perms &= ~POE_X;
 
-	/* Shift the bits in to the correct place in POR for pkey: */
-	new_por = POR_ELx_PERM_PREP(pkey, new_por);
-
-	/* Get old POR and mask off any old bits in place: */
-	old_por = read_sysreg_s(SYS_POR_EL0);
-	old_por &= ~(POE_MASK << POR_ELx_PERM_SHIFT(pkey));
-
-	/* Write old part along with new part: */
-	write_sysreg_s(old_por | new_por, SYS_POR_EL0);
+	por = read_sysreg_s(SYS_POR_EL0);
+	por = por_elx_set_pkey_perms(por, pkey, new_perms);
+	write_sysreg_s(por, SYS_POR_EL0);
 
 	return 0;
 }
-- 
2.51.2


