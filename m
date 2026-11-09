Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECEB66083610
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RjYaPgri
Received: by kanga.kvack.org (Postfix)
	id B244E6B05C1; Mon,  9 Nov 2026 11:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEBD6B05C2; Mon,  9 Nov 2026 11:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975C06B05C3; Mon,  9 Nov 2026 11:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2DB6B05C1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC30B120710
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:29 +0000 (UTC)
X-FDA: 85416045498.17.C83A7C2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id D37AC4000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RjYaPgri;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WkMFXub7Ch7CVzwVKxTvrbKX6YcHkbq74bbCbuB4s+0=;
	b=jiGB9z7ip4912Oai5iVPBdVM7reK0zN19ZatvcWa2FMaKBZQwZR2St1oJnWULBBe325b4o
	evLjnDQjDA5WBvhBe//mqyV/iGUWXPxcq/o0aqUZybiTcN4gjJ72A0hSdg85vW3XPnb2ZK
	tLnJtWRrBZXlNfUauy0kaOnXQbefTEg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240088;
	b=Xmy3DS60BQbg5Ty6w+YbQ2vRGuH+7K5nkLkw6+sJOm/fizgntA2L/wntQDXt2aVLxDS74T
	+a45+DBS48moNE8cyHO1gRSCtpqaojV815VCVUEtqfnF6Dc7KvupX3WMITesnvGxvUZNCC
	xA7lawZJ4Qw6TJdHFiRKhYdiH3eTpIo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RjYaPgri;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0539114BF;
	Mon,  9 Nov 2026 08:01:24 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A81F3F632;
	Mon,  9 Nov 2026 08:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240087; bh=NbWjAbD2XELTG7nVxGNaaZOvGvRplduuBCsN/xKix6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RjYaPgriXPka1kF/SrM93Il1dQjB895z2FYsGkCoMKyXHkliA2wiRqFdBo8+fqGy4
	 LwptKc1VrggLad0y21pR8zc4Gm6gAlGB7neghthhkDwNCds04HOGdikwc73BbmvHUc
	 0qPdpnZSIKGj0jJLJjANsNqxfGKqHm/qOEpomxE4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:35 +0000
Subject: [PATCH RFC v10 10/22] arm64: Enable kpkeys
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-10-aa6c4d9603bc@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=1872;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=NbWjAbD2XELTG7nVxGNaaZOvGvRplduuBCsN/xKix6E=;
 b=NKrgEp0VnQpNTn77iTeA0WwI1hEE5wq9WLRIXUoViJ1WrbgIMt4MAliOZ/y9PNzGt/lHPyE3c
 05Bq84q7cBVCs1qpbZsAecehL/hibYoaB/dVSgxiZbbmOB/mUzCgyIJ
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: eaf6uz7sbjq7u75dpp58kkd9hmmsiq55
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D37AC4000A
X-HE-Tag: 1794240087-868142
X-HE-Meta: U2FsdGVkX1+KzFCq9m9O3u2dnOgXiw+yiKpQAajx2uUa5jYergsbwttmYKi+JOjCVFB2oOkJvwa1YD/dD8xl8r9/Ybe9TS4+q7/FERXNBP8iVBxK1x/KDkUUftAai6VFxTfBBKux5NKwabfRv3QQ6xujpRw2Ny4NcH5boFr9XXvT/+ZfyH0w+atoRZ6BQHE2NS7iXn7LqGMGG/6MtG4rts/1wzO2H3QJ5gP4UQWLsCbHQG+QEYcA3oU6Q+/hfu/nQjlgaFw401Fb1fSF/n37HFbQ9wUXyrk2v0/nM20WDqBlKgiheztm+t5GodXHvPpliRmYtfl1O5ZmfP8ttlUGxkRjYUVKjpBywTWzsSbkPevRt6ElSDR7NhHH4MhxDnptcLXDwgG3XOQxfOiWmA7+1XiAnrfVkmdrDDczjTsgI7TobB2LAwN6WGLxcLMxb6nP6cXNGlqTwu5G92kPWJZKjO9VNS1Y+QYI1She7K/lta/O/qGCfF0c9bSpTeYYZkcidKXjW1jSRfXelXC3O0vhFNNfzmPohNyULhGvlOoIGy6SNQHNbkl8VOmOYtUHd7kZUR9cVcqd7VOrLAOpiIBLlk3KUXfxPHzN2Zm80fXsm+UaBA4re1VF3rAjQ/E9OiauQFab/Dh/anu4zha5B4dCBepvleMa/QBa/oZHEeQqfGOT8KPxOkC7FyYEyQK4Co17kBnGEeNxoxGBBFA6dqZ51OegyKmg5pCwB3uoq9GYKL0eyNDq/Y0Rti/4F0k1YxkIBk9U44HTq0VP02jLsc8JmMtS5ewosBiv0cvh92ICXPiq9dyTwa8Ce8hZrYI7w58rbgjiSB68X7b88Na4BAi2t0qJNBZcmtd8AaRHGJIOcvFRg2+z5njGbRKStTkySTQhsJw8PlEj1kF4qrzsBK73d/p2C2FgifaldXqGyI4KcxZ8UujvkCvcgGCxhU2IcFnrvyGNfDxUvCukgvVt4J5
 WSFkpYdW
 kx/qOjc1nGZC+NPZlv7GKsphrnt4KhMaotpZIsvFWoMq5CgTg0SlHfps2vK1vQWpuPl4L4FmeWWJfQEdhRuju3HBUanrBI2Hej/oo4m1e9ow8dEizaYGYvVGXYHlH1aX6DrcPu6LtPp+mX8m0I9Zu6RTYyp3XNFMYq1hxxk1DIPeqFEq/7jWAZ3ySMVLNT/Q908Q/lamvgHUE8J7de2xfpFzxuzeFCnUENjgIn+98zfZEE0LiAzE9e6iEy6t/9Nx29L/h3c/AKzEPrkMyLDeWimNDaoN074uuaBXFwLm8AoWyQQkm4jVOHH+Hyllk1b/c+HuqcMi0Pj9WAgdaI23jXAcrYiW2grCzAQ8Gp4vjaQmrYW9h05Hw3ySgD5EJpjXj08q/RNZpvkUrdbiMKVNiwYPv+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is the final step to enable kpkeys on arm64. We enable
POE at EL1 by setting TCR2_EL1.POE, and initialise POR_EL1 to the
default value, enabling access to the default pkey/POIndex (0).
An ISB is added so that POE restrictions are enforced immediately.

Having done this, we can now select ARCH_HAS_KPKEYS if ARM64_POE is
enabled.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig             | 1 +
 arch/arm64/kernel/cpufeature.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1075bc661833..f7e4ffbc07ac 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2300,6 +2300,7 @@ config ARM64_POE
 	def_bool y
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
+	select ARCH_HAS_KPKEYS
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 34c5c03c0c9b..42d693197739 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/kpkeys.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cpu.h>
@@ -2334,8 +2335,10 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
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
2.56.0


