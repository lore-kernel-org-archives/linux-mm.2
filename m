Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FAE1CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73866B00B2; Tue, 26 May 2026 07:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4BDF6B00B4; Tue, 26 May 2026 07:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9610C6B00B5; Tue, 26 May 2026 07:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 838AA6B00B2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E6968DEAA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:18 +0000 (UTC)
X-FDA: 84809322276.09.7D330C1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E4501C0014
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WdoT247x;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2Od3Visigv+Mu5zzSkNojGtp9S2MPzs+b1nypHMhNE=;
	b=KxB2xXFGXUjeSulS39FDtdv3cCbmCtXpX5hv81B8Y610lIcyUEeNrfM7PxfvHG3owAw85V
	ZT7GtH8D2wkW70Nd/TVXRuKWZwiX9RHiaQzwGC3ZnSpsDxF7skkMF/spNNF/8i+YBexsTm
	on+Ix39YZEDqP/U6E7F5pDnJM+S8cbw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WdoT247x;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794296; a=rsa-sha256;
	cv=none;
	b=66Rel6HAlxiyGjkQC+3lfaELpgMKy+kfSSyPSkinlwwCpfS6o0K44y0ohPmDVltOhcGeQC
	lHMzLxa0C4d+Zn+Z8gkuKiHgr6MUqqkXrTcVh9VSRzjVG6wgFzOvde0UTCzNR3eAlae6oK
	emIquxpHn+j765DMoSnr0qd5W3hMHxU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86AA516F2;
	Tue, 26 May 2026 04:18:10 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAA1E3F7D8;
	Tue, 26 May 2026 04:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794295; bh=fwOalTBtBiQy7yflhfOV/Fg5vwBSEwk71GDTKgEw42M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WdoT247xqLwcDzKYB5w6TPdxIOv/0hLDrcKqU8ZAHJCGdXfBctoo3NhSKbRnpq0Ug
	 F/NUOOlXrOb+e0+ob5vMB94B1mOPwSc/16y1H8q+MXP4y8TxN2oiSEAr+nnmxJotaO
	 o3pLtWLCTfqcm12bllcOL3Qt37kL4HYv4xx4UVeo=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:04 +0100
Subject: [PATCH RFC v8 15/24] mm: kpkeys: Introduce hook for protecting
 static page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-15-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1755;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=fwOalTBtBiQy7yflhfOV/Fg5vwBSEwk71GDTKgEw42M=;
 b=MMyRKvdFbw5n0x3BHWmzUFGalBCYk15D1iFtFV5PFtnL2Q/OnmlCMdgahosi4QTWrGRCjLb0L
 zTuUX9EBU6gAFV3rMWNqK2an5ARmHiiZM6pxuyHLuVyTgRogpP4Z0AA
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: jfnfawah3ha5i3yza889t95ouimam8j6
X-Rspamd-Queue-Id: 5E4501C0014
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779794296-384795
X-HE-Meta: U2FsdGVkX19eThOMKpn2kjm4PDHDEYc9nkQVONwyeVwjk3CfcJCL5XPn3MG+HI1gp5AFPLYULLxrvdupbgH/d596wB6OsjJUjS257xaAbc3zpy4uEFTwKLrTpeN0fZ1jTOPPsfFwVckauzfmD9ectLy9lc5vlNCVkv0x02wp2r/ArIDZdGj+r7cvthQ9CgCIYfziz0UkKaHN1V3ShObGTlhyJl5grNIw1DHUbKgHxc8r794+meLOWFWpNxAlfQEzixzb9b+Z/ZV087uTgVzVBehgqj1pirSMhuwMFmuYwDKT/eltul3MW1igxGR4sOOzgwV21G5mrW8IfNeT+pCVn/GPc7HdkwKNEBfEgMcEQg8R71ESVpTvoECsXWy3Krf1g+fK1if/I1dL5GPyrDztq0SLIPSXkTRUQX9NOa/XkE8/DIxhDT5B1rhGTyBW3jehekuuT+bwNUjGhBIQ8kNdy8aFKZ2v4pEYXga5Y3r495D35pzZHpwaD4EYxUcx6VhK0K6Yoqz0YiwhpHYXjfoPCV51WhIKZPQK86IFO9HW3vVSgZik5BIzLcrGBtsLKqa795ICkIrFx7unUG6efad5dXB8NKMkgJwNzTur9OSDg+hdW34YSzOCtvjzuikiX+gu9saJYifwtWWMSh7qWbmxTJPkg0rz+t8O9KGmTjS8sPTDiAIMGFZjwRiq611pACYM05X9LsNHbBDYwIcKGOTCbrDMBZvLfxPk/PeO5HnZ0khXTuU+3VF64pmzQzoGhTuuVBKDFkq6VWvYu8j1hi2Y/5GI+NYyRAZOF15I4n0IF0vpaMrySlmOxFEhFIt0zlpVF2mJVj8pY5/dmHyMZroVqwApjbJBODqG5otTzkfhfJwMv45xF3Ak9ToWj6mnlAs1OBkyqrfty0C5eZ//TYFabmr7g8dsTP2V4on6XKQkxScmpEwFpAlFw/JDuDgWZ31BhNGU5G8spMJpJ3qThCv
 LlK7s3SS
 KVEv3ZcEIc/5M994ldB77zyWD4wFOMoL7oFfRaadiDWPKi3VCle1pefQpPI9OCZlgVkFhbFdiUc1RjC40dAIfU9W0tB9K8Iy4+uBlyUiezW6WdgPs4bZdrAT0R3scWuTwlG6PyuM5AhD6ZUg1uLfR8OgucisjDlnYmSKcUWs0qkNWGM5oLNuUOh9RMQuxxjlTtBACiV+U8zt/OdUv3Awp/G3yhwXaaH7fxQSSbTqiYd34FJSeheHp5ssAlE36+vWVGEpDGRBEtrshRVs573JxfgG8oLM1IiFcExRY
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
index 0e246354e95c..c0ae7e1fc382 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -146,6 +146,10 @@ void kpkeys_hardened_pgtables_init(void);
 
 phys_addr_t kpkeys_physmem_pgtable_alloc(void);
 
+#ifndef arch_kpkeys_protect_static_pgtables
+static inline void arch_kpkeys_protect_static_pgtables(void) {}
+#endif
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool kpkeys_hardened_pgtables_enabled(void)
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index 13af4930db3d..269de610d744 100644
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


