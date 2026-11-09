Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE8D606EEA6
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QMPDGWx1
Received: by kanga.kvack.org (Postfix)
	id 2BF136B05B5; Mon,  9 Nov 2026 11:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F5C6B05B7; Mon,  9 Nov 2026 11:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1106D6B05B8; Mon,  9 Nov 2026 11:00:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE0406B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:00:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FAF2A0700
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:53 +0000 (UTC)
X-FDA: 85416043986.01.8583D85
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 79C3A16001B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QMPDGWx1;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240051;
	b=nV4fqkzYY+bvVw/N4MhZOrimcAIfghgVIHffLeKWhdA9EywMU0RaT6ByFze7B9MDvaSt7l
	d3OXLeOPn/lo+xkIFliBivvoJk8BfxPwpK6FTEYBu/tyaCTKaML+taf/6Z3fkuIXdtkv1G
	qcXc+CFlZ2sGIKrXGTC74ZfTJ9SQgTg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QMPDGWx1;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnRsN3UInd8vk5PQMkeB0kwLm5CfKQbQi8xN3upHdxI=;
	b=JkHZ0pNU1nMbZn5wU4jb9qd60t/RpaPbCiDwq0wIX6uqfNGyBo1DxI24in/x/nJXCbxXIG
	oijYmyoosgE+rcPSAw5bB+kgaCaJEujPgkZnddp2aVj8n36gBV7n2wJIFgKfzQpHMUxht7
	G885HhHMVRq+E+p6ZSvm2nwRzVBSSX0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 848A91516;
	Mon,  9 Nov 2026 08:00:47 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A74473F632;
	Mon,  9 Nov 2026 08:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240050; bh=yu0QibpeGnCkZqJmw/urIy0ljAA1TeHqyJFGcmLJNXM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QMPDGWx1tZHs3n/XgKWaaBFrrMKY/A63uGRHamj8PoWWPP+KJ0EThMIXjNQCaYx84
	 2Iwh9VkjamsvtEIYpenncdUwbaUqE1VgIROx/qAtqOaIci/I2xN2tx3zwa2VjNzQTR
	 jVZtia/5iorciBFQMOvItpdqalF6h9JQ4H2/fwmU=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:28 +0000
Subject: [PATCH RFC v10 03/22] arm64: Introduce por_elx_set_pkey_perms()
 helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-3-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
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
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=2726;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=yu0QibpeGnCkZqJmw/urIy0ljAA1TeHqyJFGcmLJNXM=;
 b=aKAWRrAYSHwHgbIVvJMgI7Rd+w4FuN/S6jHgMLHn8JPU2JUOellnb/4EKTjnO9xnQBIXtnWa/
 53OE2mItuJMDGFHWn7ehHKcQwtnlSNhWdwJzXSbq3HUq9MmYLuEbxGi
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: dpmzm13qjo9ceiyscpatg76wz5jymrid
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79C3A16001B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240051-31481
X-HE-Meta: U2FsdGVkX18J8O8Xy96wOrbUx3hW4PvYFehUwBJRirzR83DsDvbGIVsBjdcUVQkLEh4XAYrQ+Vf3l6ttxhPwUJcEkP7kY2945x0PqrYzqOvOi1//m2ElmH668cTpIcZEtwsXVfIh5zVrx6cDVfFV3iBwVYKi0qJp8PJO/s8UhlJndkpOUVrWP4hNlPZ3JLG+9EjfDwDbzA3gHN/ve+BrNM+gU5l2+NEJNniKPYTNPAWNufP9eZg+VgAMA10AFU7ZGd+/KdHPCdtLfKr1Gjm+ojeF1RFlFrxVCPJNace0kSLhfIv1vlNsOYSMb198gxmjr3dyZcZJafjtAvOiw8b9U87/DEZWoQv5Zg4t8SaFTK2aaa8F6FVGafbhsWEQu6JcChCsz4AoLRZh3yHXjAjjiTiYTUbFLuKae1FGotKS63Mrm0aNiG7nimNi7XDz6XSctJ//ZDclfun6iDAcX0OBorGpWzwc4IeodbEtLGY6BcVCUVNF+TTf9uSObsjUwuKkrtFcHuaXoFOjSRtGGL++cRQjgGlqUwHfBjN0r8hF0LeRa+E+dedKeZgtE8RszlCCFuyY97LrErPEad4dsXmrAdtzjtljtQWzPKWGYaYtgv6h8PKoWJYiTffqljHZlueUQfonBTaIB7Pvmyyk+RUVN5JSTbuPBBcKvTnvrAQFatfqt1Sht0sjOEt9BTRqkOevnjghAQwmxDExhewGtLMm6R/uSkYsdq8oCBuemqeAE+kh8NvGQdkDtJKZ3Qg8bKB76FOzm8g6yBPIjP7aI7cKozI8P01N3iaWNYcRY2lGmi11+BH9K2ravDjSK65zbCiQ5ifGxn085JxKT/BRP6LJ1/lC+h8gBoSY2loAvwmgsKscT+A0pVzwzAnFcyJs5jnYtL6bhY8eIpTU4EBSRi+bUw6VQGhBTBxFvQNPQ0RJ5jGNEQDhyifCc6I2m+LIu/C/PxR6Wtd++UWvyoQZbnt
 ZY3SvriD
 mhxXzZx8kdXsU1fwDfWDmK094d/jcFxu/ah2te8pUIPoLeiYb4H82SkkW7pVwM4PjFObvKL/1VPq0AGOUanC6LpVGDVsTkDWlOsmQgxRG/vzJDhok5pbe8/w9b7tO1dfnjdZOumw4SkUVR3c1IfI9QUczVlss4ptRxJlM93aPcUu7EKV1N06OqTAUkokP8k+73/FAto0ZZykS/pnXqm63LH5e5I7eLnd8JnH/uBq6gTSoQWSMwHbiFaUf3QJNIVqN5wJokEtn2w+70ifr577ApRnjBkHDeMao1XG8HB/MjQ+1YTempSb/u9uybaTp03hJ7rxjJa1VRERlXoZZgNwJ+U8tIjZls7JqzKyvX/j3Uj2gzTISNWVhHqb/vlO9I4ZLr6BDnfC3YKbTtAqiiC7HNyaoVpOjP5Rn+AgxhBwg11+AsYBmy3d9muD4Hr00rv8/b1PiUylUxDYbCsS4NZzYxYIBAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Introduce a helper that sets the permissions of a given pkey
(POIndex) in the POR_ELx format, and make use of it in
arch_set_user_pkey_access(). Use field_prep() to encode the new
permissions because the field mask depends on the pkey index.

new_por now represents the permissions of a single pkey, so rename
it to new_perms and change its type accordingly.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/por.h |  7 +++++++
 arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
index d913d5b529e4..66d8c9a73224 100644
--- a/arch/arm64/include/asm/por.h
+++ b/arch/arm64/include/asm/por.h
@@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
 	return perm & POE_X;
 }
 
+static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u8 perms)
+{
+	u64 mask = POE_MASK << POR_ELx_PERM_SHIFT(pkey);
+
+	return (por & ~mask) | field_prep(mask, perms);
+}
+
 #endif /* _ASM_ARM64_POR_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 140520b351e2..6a2155db3d05 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2355,8 +2355,8 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 #ifdef CONFIG_ARCH_HAS_PKEYS
 int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
-	u64 new_por;
-	u64 old_por;
+	u8 new_perms;
+	u64 por;
 
 	if (!system_supports_poe())
 		return -ENOSPC;
@@ -2370,25 +2370,19 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
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
2.56.0


