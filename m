Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0F2CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A5A90021B; Fri, 15 Aug 2025 04:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFCD68E0002; Fri, 15 Aug 2025 04:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC11F90021B; Fri, 15 Aug 2025 04:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A65108E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D15316088D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:12 +0000 (UTC)
X-FDA: 83778384984.26.BECF696
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C56951C000A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KvHpn45FIN68DO6LGjenYJlmYYLVdMolSXpHYhWueTQ=;
	b=v0GDHALSUwcKsQmvl7vcCmH0spyIyNp9krwEH279B6O7nD6LoLDGP8wovoKcf48MkDug1B
	uLMdXcBmEEWx6aQA6Vsy/gzcMEHdflUcNTZ8kS/rK8CGZpfw4/ifyldEc3yz6EJh24UdxC
	dko4p82z7uJIi7MEj5TLqLBobfAg70A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248170; a=rsa-sha256;
	cv=none;
	b=BAyNSY/MJOdubsM4LFGZAm4YhRBaCPckWcopxQHacFehF4ndqAneAYLMo/p+UghOUZDOP7
	m3OSmD5YIxo1UZBYOgwljO5TAi4u5gcwMANLoB289/oXIm9yKAqkSJHxOJR7PuxAS6qb84
	z0yozL1NjGNZ5GSrwKQgoHra6Wxd5m4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECC4F1688;
	Fri, 15 Aug 2025 01:56:01 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 924E93F63F;
	Fri, 15 Aug 2025 01:56:05 -0700 (PDT)
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
Subject: [RFC PATCH v5 09/18] arm64: Enable kpkeys
Date: Fri, 15 Aug 2025 09:55:03 +0100
Message-ID: <20250815085512.2182322-10-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C56951C000A
X-Stat-Signature: t9ffto1szf66trs46qj1iqu3tkuffrjg
X-Rspam-User: 
X-HE-Tag: 1755248170-443449
X-HE-Meta: U2FsdGVkX18IM0u2OqWam6SPpVhRIVsGHx9LFJStV70pvD63AshZWKJur8Vv331NXFesNDeqtKlYkB7c3+BSObQf30UxEzyRzMuOse49VSlcy+5OszSYfaOZwHQx7BBuu6KqqGLawcUiyXmEkVEMBCc0DaiTr36A36uuSdEki1wwixTC2KEmRYEF/VytDJC/cqZbcLaAAo8suCUsKmdqeo0G9/BqVrjFdABH7YN2ympYBLUqwimOvZFBRMzxe6kEFG4CmsBfNuhWHSRSPn6uYAG+1a0U1uDVbARawmmMQgnsV6A+friWr52GClaTWQLDi9FKtLUkWOnwMlwAJxU7Odh+R0hbMXsMD4IFu+VQLX7qoPqJZX1QsiDwD/1Lu5dfsOva8/LJ47NNjUrKlNN0wppl4qdpiskLOPaZHZDwOIpI2TdrLF+Wh2qFxba3CMvZ/H2R5BpQOoH0cInC5QyaP9xIihKosPyarFVYRd64e0am4S38kMeFO12FHGntQiAeuMDhhsWoiT/UbTUHQxwmuIdb7E+XT6TJ44PigoWLxmU3PlWhgAXAgY88/frVTMHUK8AYcsHVepJq1fS8T311cG/x1vN9/73qyqtD+AeX8w5k8lz1HXTSX7LQ7tz/Uzv28JnoggSTVWLFk1du5Y9UNzytITORvF3a06XpXrIjYHhGYPLDXP+XG9JHbVyhTq1CGxlgAy+o/+Y6WEgJfLpyZ5VW4kfCVqIBl8yRDHR2BOoh/u0uAo9PzXnhfKnXtIaVxC3bLp8vGE+Ci8rqP3O3mBQLAkWBB3tvodFqYMhHrk93D3cW6lYtuDbMrbxt6ChIfPPY0/EFZd3ftXXqP3EJ3i0mwDc4nZpKkTNSqc6id1a4kOTiL6FUUlst3j6m0lqYLGk3UUYvqbnEoD5/FoJ2Jg5Xtd1mUAT5QLSrOv27u0DWlbCPXzxACpjD5DqTBnRX7xkS2JCFhAN001NTUjq
 OdKfaZ/M
 5y0oaIO+aDo75R/vYzZaLvZB+eoVGqpP1egyPw9xAqvZWXJYYBEHvguHDCIBRvciDG1g/+jDCr+kfmBcRMFypxD43+gGheiYj8OJtgYndoi9qNfj5S284PZZWAuhvhkcUk0JLFm+sjXV6Wj/OH9K5w/9xCbAMleDh+qYEDnk+ovc6TFEHSMA7CH2FYCFytjKpWJ5e5PKjDxHSliK70CS8gKiVmuswWt6Pz+FUTmDdLPqeNYg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index e9bbfacc35a6..88b544244829 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2187,6 +2187,7 @@ config ARM64_POE
 	def_bool y
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
+	select ARCH_HAS_KPKEYS
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9ad065f15f1d..4a631115341a 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/kpkeys.h>
 
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
@@ -2458,8 +2459,10 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
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
2.47.0


