Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCF7CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3125D900221; Fri, 15 Aug 2025 04:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1C48E0002; Fri, 15 Aug 2025 04:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163D7900221; Fri, 15 Aug 2025 04:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 045868E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0CA85BB37
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:46 +0000 (UTC)
X-FDA: 83778386412.28.DACF0C3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3621B40008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypa2a0hPrgywV5/k/J8e9HM8L3HxgWsIGqTo/lY9e48=;
	b=g9ilMV+m7b8tllZ3qea/HGb27tO+UtX6HTCTzueyBTaIJI1ceOMoB4QhahTWjDRkFgkbg/
	ogq68tkWWnr6uukKkrIUlzI1/tLF9FzerZudf23kFQxip8ZHt29H3f4T3I3fM6n2qiL+jb
	P3t/YxXEPdXSH4wueRxOp59WPL5r/zU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248205; a=rsa-sha256;
	cv=none;
	b=KHTwwD1Q2bQAK6YfBZNs9V1xeJuKZOluBe1fuPOze6QYAH3sJnw7OtHI+mwibBRxmkgKcd
	wBYKiZ14L/bukC9W9zDjcReneXOMUKkDDhWzIdNy5uJfDBZs8Sh8xkNOQziYxgNSP76fQi
	SjWA8W+k8yYo37ptmdwwjSHWuiu7GZg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BD21497;
	Fri, 15 Aug 2025 01:56:36 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 900D83F63F;
	Fri, 15 Aug 2025 01:56:39 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 16/18] arm64: Enable kpkeys_hardened_pgtables support
Date: Fri, 15 Aug 2025 09:55:10 +0100
Message-ID: <20250815085512.2182322-17-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3621B40008
X-Stat-Signature: zb4e15kbijm7o7co8hhoxm1gqtn15jz5
X-Rspam-User: 
X-HE-Tag: 1755248204-208081
X-HE-Meta: U2FsdGVkX1/EfSL/2ir/8fPN0Y+9yQfgTeGUkI+bcFI4wAo7bPhapkLGMPNrZH5Z73ckKGwcwRZ1ey0Aq8AYZ5gU5+3vmuDmA3igDlgWO8kLD0D9WBdF5QW10QmFG9DlGBWlWkEFBXxc6sunBH2GUbaiaKAoZlAcPXr45sFRIcwYVbFzxaF0OAFckT+HAvd0ij5HqcvYTzYFx8at7HZKXVP2RA4NR3knxNwawOiYRIXvj8Hjo2PQVFuDGK6OkN8wH7/VnsiikpCcGh4WkQAZkIvp9+YOn+UeKzmBiPFYhE03ZDnGMfJtPCyOxfCkyrfdFWbShEhkPg6GLP5wFwcuqCDPPProeX+AamymeCOQuc3BhhcTdObhK4Ph44oW0bpKHM2k41wqo3AX/DHBwIELZN4GKd5xQ7ldzyJE4gyzbp1/jvJnGVZOmsTTcUnyDvRoh5v4OpywgqeXpoirXMvvhqb/nQ7GDvkV4ZuNFY4QYM7+0Gu4ILIBsihw9G2/T0JZ3m+8JtFRCIanc7C9K44oV4KS9fZEreo9R7Pq/Li1gcRCPoocavqA9ewGgxw7G4dAbi+1A8cCTw4R6mKwoyAIxtE4rWzANhknz94Us7qfBESFMj/L5PHcT8rTrOoaRHLicjqSbN2liQVMgiBaQpbKiszrkKGQEhXZFh3F7NL5mN+lmXepanSqFgA4tRyJOM45dCaVfsZsCgmwDMNlhcoESaF+OowpkJUya64+FItOCotUFv4O/P7MeGi31+ngzvYIsphqOSEuT0J6lVOuEMLycuNnt7H1Kgd2jMVqrvJo2LGjoA75vp9orfhbd7tZmPkP10SXhGHbbDu+ybh4nFGNxURUcnjccv6HJRDCEoRD6bIPRGKQHPCfZjUDVaxAbIZ8WAwemHJ1QkTHtTnhPZ5fQr+NRMw70HF3GGQJcoEblnr3EtCPLcNrAZz+g4TwGvMGL0SrD1GPOOPVG0exlXD
 uZ+546x3
 GAje2444me57P7bQ5TTRFsKZjp6xOV+F71U6goDtXn8I4WNiZuDIjGlCo/QY98jT7FRkVNKRvUzhqOvh/DsPZbHaua0FVBhJJqNQTZ+KrjETPJnDLjOvnFWtZqzQMEEl0omQIcUwi09sKgFyZe9DbYTQ+PZQBKYvIZk3GZCR9oe+NcGMR+7Uvezka7Q4mDQP2rfhIRwiKGe2VNlgpt3sknbuNB3iz/V1dW8WS+mUmabwVvfu/9lFIy+AAMWrE3XELAxVQCpufBdSuoffvpbPSsFzSGzmuYzyCm8u3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kpkeys_hardened_pgtables should be enabled as early as possible (if
selected). It does however require kpkeys being available, which
means on arm64 POE being detected and enabled. POE is a boot
feature, so calling kpkeys_hardened_pgtables_enable() just after
setup_boot_cpu_features() in smp_prepare_boot_cpu() is the best we
can do.

With that done, all the bits are in place and we can advertise
support for kpkeys_hardened_pgtables by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES if ARM64_POE is enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig      | 1 +
 arch/arm64/kernel/smp.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 88b544244829..6c77f446ab09 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2188,6 +2188,7 @@ config ARM64_POE
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
 	select ARCH_HAS_KPKEYS
+	select ARCH_HAS_KPKEYS_HARDENED_PGTABLES
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 68cea3a4a35c..04ce6b2fd884 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -35,6 +35,7 @@
 #include <linux/kgdb.h>
 #include <linux/kvm_host.h>
 #include <linux/nmi.h>
+#include <linux/kpkeys.h>
 
 #include <asm/alternative.h>
 #include <asm/atomic.h>
@@ -460,6 +461,7 @@ void __init smp_prepare_boot_cpu(void)
 	if (system_uses_irq_prio_masking())
 		init_gic_priority_masking();
 
+	kpkeys_hardened_pgtables_enable();
 	kasan_init_hw_tags();
 	/* Init percpu seeds for random tags after cpus are set up. */
 	kasan_init_sw_tags();
-- 
2.47.0


