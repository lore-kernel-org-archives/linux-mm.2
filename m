Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3287FEFB72
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39346B0093; Fri, 27 Feb 2026 12:56:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E302D6B0095; Fri, 27 Feb 2026 12:56:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32866B0096; Fri, 27 Feb 2026 12:56:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1A606B0093
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82D11160761
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:09 +0000 (UTC)
X-FDA: 84490990458.11.612CC43
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id E4C3418000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mL83OocTG9Cyuzd142sKRZm7TE6sjCwW0IIkMXTuR6E=;
	b=OXWI7+CvPnVX403Q+mpME5fs36pE8Yx7h5VjJY7xcgbBuocWINb/aSgu+EEjASab9c/xXg
	vfkjd7sS+Xd/4WSflWiOlTOSDNzbcqUqvs73qR9BkqYnGGD0+rijCa3bQ09ojVaEA5Ixou
	FNWC/Ux07z7vQDlk9CMTyajBRDj2wAU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214968; a=rsa-sha256;
	cv=none;
	b=mViIsaKP+w5MaSroU6dQDnQlzNrCPDAMWBk/Rh+9se+RYnNCpYwC2gKzy4kdNpX8IO/+V4
	OShm6SOfsb/wftSkS2xYZz4cP77q0Mam6LQNULMhCwNo4N/EeICtA6wouXNrWolGb5PQHw
	epgBszODSN8ufYbNfXRRLPdb6qQ1mkw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE2D614BF;
	Fri, 27 Feb 2026 09:56:00 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 936263F73B;
	Fri, 27 Feb 2026 09:56:02 -0800 (PST)
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
Subject: [PATCH v6 05/30] arm64: Implement asm/kpkeys.h using POE
Date: Fri, 27 Feb 2026 17:54:53 +0000
Message-ID: <20260227175518.3728055-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4C3418000D
X-Stat-Signature: zo3wjoaz1i19nequsnkwohr4h9p3nsni
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772214967-13942
X-HE-Meta: U2FsdGVkX1+mCLL4aEQygIlCVoveepHCZ8BVUIQtD6z4ooU8zTwU+dSOsM9sXnu2c/sNxO/KIajmaNCP7/BPF2jBkmGqttZfyVAQp2Zxh6UzLbkpPpBLe3sU+PbJ7reEg1HpQJuE8jL8RhDm7XthQPjpqgIc8mqEh1TGhH/tXo+H3Vit8uhieuTai0tTsiG0QQ6+chbVYe+WJL+iACKDZ8aIlt1bDml77OygLekzy5maUBf3b+FfB2VpDykQLncU9D2QZ70/CV6+5ZqXqaFV6FhBBsfzVXoGgd7of3hxK58yJXsT9wAlZDLc2uAhDQy05x2u24O0zytJzJ4PrnJ++n5KcUbc1bYFb8qnO4nEDbcgP8fBg1o/tx6hUcwS4xclXqoQiFshSSNQKlHyuTu/7kq2lKY77fioSLtNHV0dELvf61Et+wx5OKj05KVRpqwzaKyJOq10Mt05e8WoEToq08zbs8uCApDMqjiFpQP0qxPdqkY/54zOpfm3rn8t/wmTrep9GoTZfIkfD2UNdyNHZzja0PjNG2a/gUonx5IbLjoWHACPsnXy49nok/K8RUpR0j1rQWpKBY9bCb5Ugpk7+yUpQimdzSJZ+PRl/ftWfnO4UDvrMMTaP0SM/kxrNM1DAtPMywZK5Exsjwksa6hyHZ2Grl5sCPtTWfgkNTK86fJrmUvN9KerT/Puesyn8bF1v2ObL9aOXXZf8SrPcndftWKpltXWmtlcHzrxFHwK11ltZYZoVKHrVak3GwJ8QTv/jxPMozaqQRBY/I6z1BggMFnAmM7uJWX/rqPEhbsNG6nfxSYaMNnW0aoCbm8KgQf+Hbdvxg8QD2em0NKWPVCDupZ3/Kqg9Tb/Basy5orRgqI3EEdbSplSvJpCRygDqK5dLMFN0+YfA2cQ3MQkt9NMVAkFHMdN7rt4daJa9TxlQ8Y9mnuMqmrhiNZYoES3OXtY5VBF4wO/JidNSzQtIJl
 qX7akOoh
 ksB+ZLS4n44T/Ydki1obfIG44JRbQX9LJt64kHVri9c4VlgmrgSgDJPpo4iUjPt0eIEHr9ipAhlobEvJH2VvcWjslFLYSRkHijopv7GkyIzQlJXnrwvbuYnZbB+kiz0R9O6Nb6aK9greqNhltkJ/ezKc3VLHkD2nu9ZsBBjqeqL1Kn0JMUH9DgrozykSeFXsxjNUr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the kpkeys interface if CONFIG_ARM64_POE is enabled.
The permissions for KPKEYS_PKEY_DEFAULT (pkey 0) are set to RWX as
this pkey is also used for code mappings.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 arch/arm64/include/asm/kpkeys.h

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
new file mode 100644
index 000000000000..3b0ab5e7dd22
--- /dev/null
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_KPKEYS_H
+#define __ASM_KPKEYS_H
+
+#include <asm/barrier.h>
+#include <asm/cpufeature.h>
+#include <asm/por.h>
+
+#include <asm-generic/kpkeys.h>
+
+static inline bool arch_kpkeys_enabled(void)
+{
+	return system_supports_poe();
+}
+
+#ifdef CONFIG_ARM64_POE
+
+static inline u64 por_set_kpkeys_level(u64 por, int level)
+{
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
+
+	return por;
+}
+
+static __always_inline void __kpkeys_set_pkey_reg_nosync(u64 pkey_reg)
+{
+	write_sysreg_s(pkey_reg, SYS_POR_EL1);
+}
+
+static __always_inline int arch_kpkeys_set_level(int level)
+{
+	u64 prev_por = read_sysreg_s(SYS_POR_EL1);
+	u64 new_por = por_set_kpkeys_level(prev_por, level);
+
+	__kpkeys_set_pkey_reg_nosync(new_por);
+	isb();
+
+	return prev_por;
+}
+
+static __always_inline void arch_kpkeys_restore_pkey_reg(u64 pkey_reg)
+{
+	__kpkeys_set_pkey_reg_nosync(pkey_reg);
+	isb();
+}
+
+#endif /* CONFIG_ARM64_POE */
+
+#endif	/* __ASM_KPKEYS_H */
-- 
2.51.2


