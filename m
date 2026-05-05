Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A3FCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FE76B00C1; Tue,  5 May 2026 12:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8009E6B00C2; Tue,  5 May 2026 12:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF636B00C3; Tue,  5 May 2026 12:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57B486B00C1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19B194051D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:48 +0000 (UTC)
X-FDA: 84733847016.23.A5B5FD0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE78A140003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vnMHG6Py;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNpBzRSFlHSBCIkStgnPyxxPonuN6xED9SLfXErUVos=;
	b=XX4Q+vtk2STzwjUgFubb7pPagqauiTypwB3k3bNnbY+WdzBXYZEqPCWRhbKM9YcqY9Qh0y
	OJ4sEnfZGUqcyPymCGduWaveaRMi3OLB2lpkGQgYwPCcudxYhpIYMxKg9GJtuPVUnrwYij
	9FmCEYLqxndhA3D4+ksq1ghXg/SbU/4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vnMHG6Py;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997266; a=rsa-sha256;
	cv=none;
	b=sFIGLPqkTp1C1NrKvbmPUImSkSRA5C7EGWzOgLwAroLEPaOKfs3BMOPqgTCHoE5doc5e+v
	+liqg1E2kADfMa3crlz4mnCxd+OIukzgu7744ATW+HrfQXb21nUHAUB8kCbtwc2N8v+AIt
	R1eGN6aFG92wkNAcUEjlwXGgS9pZ3dA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A95A414BF;
	Tue,  5 May 2026 09:07:39 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E30D33F763;
	Tue,  5 May 2026 09:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997265; bh=RQ1NlL4ErKEM1olJpMC90dO11W+OKbU2xg5T/p3fkts=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vnMHG6Py7xB+Ho6tj/NB58Zs9avDU9tYneIab9lbKcKBp/P1mjXr1SVjLaGu8qITZ
	 12D2wQpl3NUvFUzsoSDXEeZu9yKFbpwWdD0E7oUZMoFFwLF4S5FKmhwR/X4wVbIzOq
	 Mu7+tLThErKBv9YsXkGX/OvIlHizLDXi+zBv5C+o=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:58 +0100
Subject: [PATCH RFC v7 09/24] arm64: Enable kpkeys
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-9-20c0bdd97197@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1824;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=RQ1NlL4ErKEM1olJpMC90dO11W+OKbU2xg5T/p3fkts=;
 b=mANpr2rJlPgxrxGIv4yorvnjURFLTrqouoIxd1Ns63x3UVDAdyZB7Y/1S+4mCFbwHUB6EIf4C
 WJWbIne57rADDQcp504w7pPD89wjw+pANi4MUSWw5sMIByR+bFjqQ6s
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: EE78A140003
X-Rspamd-Server: rspam06
X-Stat-Signature: cyfwhk7um668s516is46tgepbrq3pzp1
X-HE-Tag: 1777997265-703138
X-HE-Meta: U2FsdGVkX1+jNch9slnb/T+aPVhH5pe264gJ8Qa7O5IzDFApvqWdF7RakoNNZ9wUBXjmddzHSCzxHHcsoAQ5MwSjNWTIiVkKGtsqXXI47ArC0251rf4t0NcM9ew0KkzciPQjwhJWXam78CEN9gGrruZNML39oa9Hcc503COlZ8iMAJEIc4keLYvtOyzvGqSRgyaerQUicpQQK6eJyuhUutdgkBj+fUjavUcN0Wt2ATtj7lSz+NPoiIK+T84SmTKQNYgYBID4R54hV4oX+bshPQw+GoovXSwbEuLSz7KQlArISTx82bdr0NUP0JeEb20SOtfhhBIhVeFYA0yEmzDQbm9Yai917x2iODJEUoD7slhh5tsubtmos1u4Or1CzG4NBBjLPLKl93D/iN9hgcmF6xBy6MA9mSLMIHI/uEl1/NCpGSvidZX+tKaGXwogZaKxL9opcSsb2bRGFRYwsAoQvEGrSrGVCiaWGE7rweTUZnWkTvqExpaDcbRJeQdeAmJHTTeRowIW3GIzcm7/pVQpjxP5Qx/sHGSaJhxfsFhgRcdgTUaGgF/21uVxGthEUBNTRz9OhFwn+jB4aPURrxTD3TgMyjWuUX+ofur6/fgw9lJWf8aoG0NpS+c4ZFcnKD9s2dIxKY8X2pdpvzfn40fdd+4nUbynDg/GaHtEVz+nWOeg7FeK4aruvxK72rl6PqhfDul4BsM4+YPHbI7A6ozYpDApe/gOSiiNh1zCDt6jncryYIxL/+sN2uag8rVvUjyMwWFP8R0S7qAuBryP+sgoAegOI6aMtNj4FKFCoAvNIqkw+0INxGJCGekZlc2ZpmPpLzcQIEHevYPMjMQhqjnzBU0rkdwTVfsXycq3+RwNzpeJZ0S2jXFEkkko9bj1s6mWp2FH+xL8kJYNXIqfegGPK+71hK35YyauTE7u/RZLevOHpG82q6fe5eDVth1lK7FpUbNs6XGOdvMIwWgv6z1
 bPDnz/I1
 IlEQBCQCPFbOzwfTfuHuytzQji4B73xAec2YqSIiDFHtTkRQsgvfpb/26heRhWThPjbjMyq7INOIRVEs67FcaUCx3unkAeOPmmc+cxvQum+Rgv9ol193Z0I/f6ADF9nQ3cNq8bB0dJ+3dJqUYpWpjdd+WeZQUGJQCRi0hQzV0Hvq1JN+OzGJlq5mIfNDFi9fHWKOlMWK5xWSbfYTajWEySJdvrQtckiijgqqvr2Y6xqQAITUYLo6A2PnWBdNAp7dDc3InrJSrwkxoi5ZfxQ1zYMXBsdr5dxK3qcyz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the final step to enable kpkeys on arm64. We enable
POE at EL1 by setting TCR2_EL1.POE, and initialise POR_EL1 to the
default value, enabling access to the default pkey/POIndex (0).
An ISB is added so that POE restrictions are enforced immediately.

Having done this, we can now select ARCH_HAS_KPKEYS if ARM64_POE is
enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig             | 1 +
 arch/arm64/kernel/cpufeature.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..ab06324a50ae 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2145,6 +2145,7 @@ config ARM64_POE
 	def_bool y
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
+	select ARCH_HAS_KPKEYS
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6d53bb15cf7b..e032322c0c36 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/kpkeys.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cpu.h>
@@ -2451,8 +2452,10 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
 #ifdef CONFIG_ARM64_POE
 static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
 {
-	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE);
+	write_sysreg_s(POR_EL1_INIT, SYS_POR_EL1);
+	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE | TCR2_EL1_POE);
 	sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_E0POE);
+	isb();
 }
 #endif
 

-- 
2.51.2


