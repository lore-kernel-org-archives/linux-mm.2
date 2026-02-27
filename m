Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 187E5FEFB72
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3696B00C1; Fri, 27 Feb 2026 12:57:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715F46B00C3; Fri, 27 Feb 2026 12:57:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C96C6B00C4; Fri, 27 Feb 2026 12:57:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45A526B00C1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07B4F5B660
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:34 +0000 (UTC)
X-FDA: 84490994028.14.83D1F9A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4051F4000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmAOheVzY4EJtPhDd1MwnpIiIYG+yRKhpRaW+JKu0CY=;
	b=CWPO2md0OxtJxXMk5jB8HzUjhfsHaNoPqM31RBHGmF93wZvV+EiVM2nhiTwX6GV+M86R14
	fkksMJRxcnud6FxmEQFBgZOKXse0ywXnkTld+J5OwiETZqu0cAHcQexefu995/bfCAAvut
	RPs0bQxIxLee7fwb42VyYzkpiTaUBd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215052; a=rsa-sha256;
	cv=none;
	b=eg+YkXZKotIhDdo1NzO+V7GsJatzfjYCUoL3M9y0BwsFYvXSKT1CsJOFMj94FrMdEYlS7b
	Ll/xnGkZu3S+6uy76MIr6aftSFXmkUHb3I+CBxorcMLGpDtVScYjRRlvs6O0eDLfD5Qq96
	T2nC0NRz0pbBfh6r85TtXzKTd/4+KD4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 239D714BF;
	Fri, 27 Feb 2026 09:57:25 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 112383F73B;
	Fri, 27 Feb 2026 09:57:26 -0800 (PST)
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
Subject: [PATCH v6 23/30] arm64: kpkeys: Ensure the linear map can be modified
Date: Fri, 27 Feb 2026 17:55:11 +0000
Message-ID: <20260227175518.3728055-24-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ukoq3mibaorc3pajegi4ijew8p76mkq1
X-Rspamd-Queue-Id: 4051F4000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1772215052-379879
X-HE-Meta: U2FsdGVkX1++VTJuIti0dqj7hPq34AHPOiwUVJTIhU22iQMouVmaKFBC1Fp2e257Ma5KVJZEZyMGwW/nYdYk3HsqoQkw67GgSL3wtvOwcF5vluz864e/kmtHwnrpj7yJggzAscPK9wtqiVmmzg2wPJ1BiTaM8Y8zUr3bG4r7jUHd8dJ7cisqiQZOz4AVtYItCTxSoXTlDGw9BJc8+/Tvth1WpFeqiaGSKoUWC3WV66F8Ae+xGzGHDzl32hUM8SwyXduoy5vYYUqcCqAGAqNuGRyC6o5YuZHMD8jTbzgX9gsU6Fm1DpbJQIL7tUBTXuHfUOjpQDClX2xvKPVHPyVxdu/9iW4q224Y2iHdQLyXsAMLLojen5/upogQ3Y7OJFVkSZ0tY+LkrwoAtZv4FKfoVXG2acwPJSU6KsMvXKhoLmSbNOp453Zs6q6qQRHlqNiTdhelmgiYWxsY5J0671VKofT6j7LK9OftEzNkzN0hVyEheusbjfno6yUtGmm0KYWO6VVCVqIWHRGQGXpbIMK+E8dsNgdjInXTAPiJQ+t3gacDaKDVuYYdxsTWBfDcVVW1OtvpR6J90fJOgLGlOE3iboGGlqwa0is0Wem5Qef13D4aiAbDWrN67sBQK3fwFzjdeIjMzP3f7RXT8QAqGjv+3Fvs6Wtg8ZnD2xJpGT9opku8cxZ2c6jMWmVZe2hBIHQjw8kzben4lfm2EOOVLQQJur/Fu4k80EOo4q6pAslUHLEDWEudmGpdoRLwUB662RXB5nOHAMI1vyJ/k4eJCewxXsUZzG7lEq7tsJZB1EKJYcr/4quGbk2M3lUavinVees+1mhPjJDNIbmo91PgVDQZkcFkJztUaUZuPQ55vQhOx1fMbwjJ/BqUDo/XjSTAvmYzCs800V35znmnkPuxQzaKTC7jZ0Anckzq5rF1IfDC2GwGaUEARsjHXgGB3QTNt9bGMGKPLNN71Gfh8LigJyS
 Dd8lcnM5
 HgSfY6s6JUDISWgimjCABbYDA8YB/nPU9pIkCxPCO9boYA/1G13PjpLGHSk3FKvhMrIbB8Y9rM+SS0+7jTeLLLrqw2U2A1px3awpl5cFTJLrb2ZRVqSf8NGyQE+1+caTc7H8GpXf+MJm5C0rdrBvsKdq7SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the kpkeys_hardened_pgtables feature is enabled, we need to be
able to modify attributes (specifically the pkey/POIndex) in the
linear map at page granularity.

Add the appropriate check to can_set_direct_map() and
force_pte_mapping(), on the same principle as rodata_full and other
features.

These functions can be called very early, before POE is actually
detected. Introduce a helper that returns whether the hardening
feature is/will be enabled, by checking whether POE is supported
by the CPU if it hasn't been detected yet.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 18 ++++++++++++++++++
 arch/arm64/mm/mmu.c             |  3 ++-
 arch/arm64/mm/pageattr.c        |  3 ++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 64d6e22740ec..eeebbdfe239a 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -57,6 +57,24 @@ static __always_inline void arch_kpkeys_restore_pkey_reg(u64 pkey_reg)
 
 #endif /* CONFIG_ARM64_POE */
 
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+
+static inline bool arm64_supports_kpkeys_hardened_pgtables(void)
+{
+	/* POE is a boot feature */
+	return boot_capabilities_finalized() ?
+		system_supports_poe() : cpu_has_poe();
+}
+
+#else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
+static inline bool arm64_supports_kpkeys_hardened_pgtables(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __ASM_KPKEYS_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a8e982ac5079..ea1cb1875257 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -764,7 +764,8 @@ static inline bool force_pte_mapping(void)
 		return true;
 	if (bbml2)
 		return false;
-	return rodata_full || arm64_kfence_can_set_direct_map() || is_realm_world();
+	return rodata_full || arm64_kfence_can_set_direct_map() || is_realm_world() ||
+		arm64_supports_kpkeys_hardened_pgtables();
 }
 
 static DEFINE_MUTEX(pgtable_split_lock);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index d2a7e104a5c2..05e57387c0b5 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -96,7 +96,8 @@ bool can_set_direct_map(void)
 	 * Realms need to make pages shared/protected at page granularity.
 	 */
 	return rodata_full || debug_pagealloc_enabled() ||
-		arm64_kfence_can_set_direct_map() || is_realm_world();
+		arm64_kfence_can_set_direct_map() || is_realm_world() ||
+		arm64_supports_kpkeys_hardened_pgtables();
 }
 
 static int update_range_prot(unsigned long start, unsigned long size,
-- 
2.51.2


