Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189E660A5BC5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TlZPPpIu
Received: by kanga.kvack.org (Postfix)
	id 04EEA6B05BC; Mon,  9 Nov 2026 11:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41496B05BD; Mon,  9 Nov 2026 11:01:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09176B05BE; Mon,  9 Nov 2026 11:01:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B23586B05BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27B2F1C3F26
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:14 +0000 (UTC)
X-FDA: 85416044868.21.9BEF005
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 34E9F40011
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TlZPPpIu;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btt91I3qkVKycKN2iTEdAlTvCKoqHGuYdHT3imsqzq4=;
	b=zO1/lzYXlAGMMp+wwkF5dCyLl7XUCY5ZtpZaulAmQ3Sp+2vaRP8R32lvDJJNLps5Jqzkmd
	H0GazpA9co9bKYwx6uJbbvLUDb9jwEsnAuSES4UQilD2Bb4ls0w/qog5NkU7TTjbuTSuPQ
	sgf1Sj8z5Ge2Sh8LTHZbE5Y2iJ1gu6Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240072;
	b=NqK82lquZ5rzI8lIYYSAD0STmqYMPl+mkN8u4OD22T8yYRpssvpp+7n0IxpzufLtVx9dXu
	nBRU+Ou/R2N02IkwHPv18P7sF8l/tfWM55FXzeG+3lJKE5e91QqSi29t4zWl70gl+xseTD
	7T157IKPzX9NcrgKSlw4MMvF6jbL4BU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TlZPPpIu;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6469014BF;
	Mon,  9 Nov 2026 08:01:08 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 834683F882;
	Mon,  9 Nov 2026 08:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240071; bh=mOcsxuhd+SBVwiebOzIYBEP81ioeefXUqmJIoRAwM7k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TlZPPpIuSAP4I+z+O/V0g8YhQgOIXJl6Swij87O2nM0jC0yFMqzP4RnfBDhA0K2Np
	 zmenIGRDNNxgb7EkMlF/p+DzoptibtBufaC0+Z5nwO7L9q+HCuGpXOjPZRSyhynVh1
	 hhvLy4QHJR7+kuEIs/mMW0IpVln0Rc0+cAtMCVYk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:32 +0000
Subject: [PATCH RFC v10 07/22] arm64: Initialize POR_EL1 register on
 cpu_resume()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=1238;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=4EcOfPYkS35WfcSTzCjV7Pft44Nt32DKIqSeTlSaAlM=;
 b=aF1hedIOdeeWnADYrxt7bKksACglTWRg1rdNE6Tt2euac3s0EchtRVpNYwIndfJ4IH5PknKuN
 icAYPbNLp7LAakUjUWc2ZYtxrMWslhblR5VgrliKrZYqBjuZmpAYHAn
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: ueq1t4ihm1s6jnj3ijyaq5gqx8n185i5
X-Rspamd-Queue-Id: 34E9F40011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240072-227996
X-HE-Meta: U2FsdGVkX19QHrd7RNPDdsXuWi+ZyaU1t8bW7rdrHNudF4IoSKPmA07qwXTeXPEGrTL0IzUqStVtl27k5zO3KNWmkNpXknwETGAT+m40o7kXANfc/YiRVp03x23/uErnRBNj9YXcmrUGGIbimOVQunmW7o61XBGT6T8B3F/JguCiP1ZjDfFvNIKeZ5Ifd1hUJ1ifvQqgtlsl9+XjpHFLUSCoNKNe2hevFFMBS1ABNV3MeUJhsykz8ULH2OdiBYhqQaFWS4jzE654UncdJd5bWPFMVFJugg5sOoysgyHnDqgqraNUqGPqyGA+EVq4ABPmpR3sQ7GnMM9jteAqJMUW4LjXOiHTU0tMznuaXqqB2Ljpi9kmMYURgB36VwpZLV9WN/xCRN8U6QQF5RvMb5DO2HND9D1EVhBgESlxYathYezwJ56B8zvUIhv1J7/EEQaEWDUu/ur/3rpV8zXMTskv0H6zgoeZB0fycZdAyaSkqeZOAr7CYWmXQh6bcSlvJipd3ws+ov7ewKg06gO8NnyurDiwFNlSE/Pk82nUConP9VApjdQtBO1ukiyGz7Qb0m/gveWCGpO6qGXAaQ2v/9UjnehYfxSe6BGKxo2IjkIWq16mdvD0dt6MZ3LqXGpYYFB/8KSPp/J9qz8ctFwDQ2UjGzv1m1UgZZ51ots1zEU/YdfAzf3QmtpQ9Tfg/RIgpJW4SlqiCx58vTaaj7oL6+H5YQ82p/gBY4iu9uoATe/3QeX5zm7TQvz2t82T339fQ+ha6q3fqJoZV0CdNttW47LGx7d3lNSEKuEzDLGh/WuuFgWkZLkePGUoiqtGvu4ICKoGscvBxNyQQKdHYimT2FCM6zh6xu9mhVFjCt4Pol/uDh8SEZk0LBlZuBDsvvwW+Hh28kxEO2SSXAqDV75zUEWHHH4DMf1cWHiGN0aRV5Yiabul4OY0pQfQrEGlWKN9h/Tc8jIqhCMCln4ScvmWxFT
 LiOmAy9V
 /uLhGHs5zZ0lVw/ua1hvqbzlT+qBDFcGKGeiD+JVlsS4o4Zr3TqotQyMmhaZwhvZ+bFmoYyrLP5XwLezKlfCSeA2HzT0Nhf+0DhQ/ZZb7WtkaAAz95BWro8zCvoln8XjaC2ALcGuHdWxhcNP/VH1dH/n2LfPulrLAaPK3uGFFOD4mWnioocNkj4pHmfP4JG8y0QQobE6Uc637pQeQVXjzgxLLPbJ/XkHZJkgfVfyuT39zEeIUltWG681pEnbw2iL1Fkk/lTmWfr0/Y7+Ehm2znKuUeA5wXh2nJHA12sO3zOdL54J0MzDt1gD43PXcsLAO1tYUjbvBs/6lygs9WOfWssXj1c9Ln0baeIyZXvT/Eo+wCdgYjdLanawtog09udTivUVe8YrovfeXQa1n4odjhtCCWj+/ZSN9Cead605C5wyAb0Np3yLwboCriYF+MPbvKPxg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Yeoreum Yun <yeoreum.yun@arm.com>

The POR_EL1 register is reset to an unknown value after cpu_suspend().
Since POR_EL1 always holds POR_EL1_INIT when entering cpu_suspend(),
initialize POR_EL1 with POR_EL1_INIT before cpu_do_resume().

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/kernel/sleep.S | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index f093cdf71be1..e0a6ad85cd24 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -3,6 +3,7 @@
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
+#include <asm/kpkeys.h>
 #include <asm/smp.h>
 
 	.text
@@ -134,6 +135,17 @@ SYM_FUNC_START(_cpu_resume)
 	/* load sp from context */
 	ldr	x2, [x0, #CPU_CTX_SP]
 	mov	sp, x2
+
+#ifdef CONFIG_ARM64_POE
+alternative_if_not ARM64_HAS_S1POE
+	b	.Lskip_por_set
+alternative_else_nop_endif
+	mov_q	x2, POR_EL1_INIT
+	msr_s	SYS_POR_EL1, x2
+	/* isb can be skipped since cpu_do_resume() will do it. */
+.Lskip_por_set:
+#endif /* CONFIG_ARM64_POE */
+
 	/*
 	 * cpu_do_resume expects x0 to contain context address pointer
 	 */

-- 
2.56.0


