Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19BEDFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD106B00CD; Fri, 27 Feb 2026 12:58:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5046B00CF; Fri, 27 Feb 2026 12:58:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8596B00D0; Fri, 27 Feb 2026 12:58:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57A016B00CD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:58:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 215725B0D0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:58:02 +0000 (UTC)
X-FDA: 84490995204.17.8B99CB5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5892140012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:58:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CnqmLN2SPl0YrUwNH/gaIMlfxd//iJ8TwYu8xAweKwI=;
	b=V86wtaHecoeH2wJ9KYOqugRgZgcDb/3X2Nm8Yh1oUWiWpxoTr08BTJerHV2dTFs0b2ayQ7
	YQBc0z3a6jDYDw0rboIhSe0Ve/zgyNSerWBn5kpt+bvhiGhVF5NWmBgwQ3FBUktzC8oklt
	zVjndqldJFQOkw9gdUU9BkWug70XSb4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215080; a=rsa-sha256;
	cv=none;
	b=SPQ4DYlgMf3bdOlOfU9sdGJT8omS3aYTYKyDDRx33jPqx3Yr8/zqNDWWnhZnj3qJcjbT3w
	OnyDJY9yvoi74nl62ZaZuU58Jn2wNFqqZNjTLKqZ0xruzmGVyS1ekajoHAQhoiOQTAG0tX
	Puw6MA2UG+aLsnMGD8EmM7Bb2igXzhk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4313619F6;
	Fri, 27 Feb 2026 09:57:53 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2DF7D3F73B;
	Fri, 27 Feb 2026 09:57:55 -0800 (PST)
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
Subject: [PATCH v6 29/30] arm64: kpkeys: Enable kpkeys_hardened_pgtables support
Date: Fri, 27 Feb 2026 17:55:17 +0000
Message-ID: <20260227175518.3728055-30-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5892140012
X-Stat-Signature: nxx9hhfmbnq1ey4h84jdgpt99pnri48w
X-Rspam-User: 
X-HE-Tag: 1772215080-286017
X-HE-Meta: U2FsdGVkX1/Z4f2GhK0MQMe6VsKjNQ6u4nIal9spoDF1RTMd+fuKKP3q5hYgdRxjZ8TXE4igKDYRLxCbkH4nR7Z4EyhUkBy4sfbpjMwPXxXTnBs2T+yMK4wrZulzp0dLcArulbRj2Js/McoNVnG85riCpOuAA0zyTnqJFBgc3DsCDGGEsI21RtrVl0POkWLHcDYzd+PUiNv8fylT4NKORJkZ05FiKoOYN93FC45qrqcASdKiY5eqvuwr+w/rT3NEOFZnpDAuxuGg4JX2eObHesx/N/E8AwTbTaixyMBuMgKClSi2c5wKToFgooygCW223ET/Ewd5jOUkbx1SG3k+8BIQ2yVfgmHU7R0D7FK33OlyxL8Zduz7b77pOrYy2gRE7WiyfitVfXdSpVsgryY3mF4rVOwUX6QxD9JQ03iXvatK8+2MnzUOMIUYohLOyQrw/dbcdqqgoAGMLKzb7gITZeb9Vl1H5K+lelXIZax6C8zph7EbFPbnKWx84/Ur/iBbnvaPsMK/a1PJ6Sj4y350SUjlh2iQ5YtFDHHx6J9Uz/a03M426WtDdlZ760cpZt6Rip8mh93b35iCvnl15nUWnzzKu0WF6NcwElpKnziwKo18gnLZAbRL3k/j3wnk1vYNRZdRJuIlrriRDtOnwyAgOa+55PYoZIxhj3UXkaMnfh7/hgC1EDXfKYeL4VCxZ6M8liboQHfyjMFavFnbFjyuvKWNSdjXNIBF29G4qt5pixGneeYQswxcFiPX7cykLUrUDrnZFyVFt3w8N2jPA+YHQHcbKNpSBo0PhV2rqY/DWW+UVtd4z7WMR9Nqvq7A7CpvqSFTiQuTiLwnIm3ZXTts6ZLDTC2VXyUZrr5QNfvxXT+KkkJv9Kd++g62PBj2inU8Zz97J0nHRzoYVzPXozhA4Xzh0q6SmpIe5Uz3jhue7kzLtZnSuVB+OwOqckuxEOFdtwSNliWv2HaP/qh9y3i
 vn9vQndJ
 rHigNfg9oZm6hmwgvQyXjc5Kim+exvkbvuV0w9HkijhtpxpadHHEPWWbdO1OjlJt0vzrqypChqIhQa1NBEb8DVMDLnavlHlEEmzLtcwTsPZH6zhiqxrXJ2jkOSxzk2H8vD+dLHjNgENkIXHdfbaLMgcCf32v7YA7SVv1lMeXwpPM2UChvJDRcbquim1mhKHGNwfE8t/FnpCOMdEmUH0W+DHDZvTMKCjjF0q5ntuROtwS/KfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature needs to be initialised in two
stages:

1. As soon as the buddy allocator becomes available. The canonical
   place to handle this is mem_init().

2. As soon as the linear map can be split. With BBML2-noabort, this
   requires CPU detection to be completed on all CPUs.
   The earliest point is therefore after setup_system_features() has
   been called.

With that done, all the bits are in place and we can advertise
support for kpkeys_hardened_pgtables by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES if ARM64_POE is enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig      | 1 +
 arch/arm64/kernel/smp.c | 2 ++
 arch/arm64/mm/mmu.c     | 5 +++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 732d4dbbab20..2faf082cc1d0 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2165,6 +2165,7 @@ config ARM64_POE
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
 	select ARCH_HAS_KPKEYS
+	select ARCH_HAS_KPKEYS_HARDENED_PGTABLES
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 1aa324104afb..b2efff7a82ef 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -35,6 +35,7 @@
 #include <linux/kgdb.h>
 #include <linux/kvm_host.h>
 #include <linux/nmi.h>
+#include <linux/kpkeys.h>
 
 #include <asm/alternative.h>
 #include <asm/atomic.h>
@@ -441,6 +442,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 	hyp_mode_check();
 	setup_system_features();
 	setup_user_features();
+	kpkeys_hardened_pgtables_init_late();
 	mark_linear_text_alias_ro();
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 1e2cf0166c1d..1a96c186c4a3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2273,3 +2273,8 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long i
 	return 0;
 }
 #endif
+
+void __init mem_init(void)
+{
+	kpkeys_hardened_pgtables_init();
+}
-- 
2.51.2


