Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6179FFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEF36B00A5; Fri, 27 Feb 2026 12:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6546B00A6; Fri, 27 Feb 2026 12:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8B96B00A7; Fri, 27 Feb 2026 12:56:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 950EE6B00A5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 489EE160834
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:28 +0000 (UTC)
X-FDA: 84490991256.20.BC7F442
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id AB15840012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xZk4uFbR1NTKSt90CcjBXyNBU2NiCZmzMIIkXYZlYNg=;
	b=BLfe1y7tdG2rb+AuDNNxEPUKtjS9k5Iq4j1lFmxCG+CWZceJiWExXs9Z7CgCfF8ZgwcNuB
	BCU05lwcqdx+aJtqN43dMtxX0remODm3Ip+BVqtbdEF2ssn5yyhu65BOO8XyzEKS0ys3nm
	lC765BA+BKjddW3WQb2bdQLd0lWI3HA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214986; a=rsa-sha256;
	cv=none;
	b=2RnfRsROaZ2WHIRHI7Qp5I0+CK6LbWpxbH5EANu8KunfseUFcNnBVkytKwK69+1IA26u/u
	0vz9iosuRVROp2LievX2XqfwmhBB09L+yc776SXDRL6i84bSeswgbPGjimvHsNnoflmIkJ
	ZcN3rPd5T2F8ITbITk8/m0swCKmtaYQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 783D814BF;
	Fri, 27 Feb 2026 09:56:19 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F0893F73B;
	Fri, 27 Feb 2026 09:56:21 -0800 (PST)
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
Subject: [PATCH v6 09/30] arm64: Initialize POR_EL1 register on cpu_resume()
Date: Fri, 27 Feb 2026 17:54:57 +0000
Message-ID: <20260227175518.3728055-10-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tdxqjobxwwhrc5kszkwm9jwzc8qxaskn
X-Rspamd-Queue-Id: AB15840012
X-Rspamd-Server: rspam03
X-HE-Tag: 1772214986-951652
X-HE-Meta: U2FsdGVkX196uFofH939EsfPRrKaNuektbly+6HWYHBs51RH3p9bhv1SrWCrAMAOXAuKLUjn2veD8WbPEzJggy8YdylrjaM421EU0ZTLw5ih2nykrXNqDuCn88Zg0Ie5qcvMafpGhvfIF7wUwBlqn+4pRewoJ3q0nnPHHeUaeKAGcnVakv6Z4+Zfp8kAgojAhwPNbMnFu2XNiQMvA8Jw6f/fALLvqgkWlLjRADw/jIbmn5q3T1J0eHAVN9gBi7Jluk19nH8ZE/722yWQRTtRAxhFhAiFq9h22jfQLH9JnkQKxp0PeF3hcvodKq15P97p3+eo2lqBlUbGq7eUW6gTiN5nI42DEiT/4c/BwjP7+b/rPs79KZgD/OPq15hrnO1qWAI99EQVnZfTIHKn5R7VFKjWXy7HY9l08tvHreX+P2BmzkcREGeTMKO0Z1NY7s3heTHuwsxR+s0S32qwDspTm9nIOIBVkEX+iMNUEUXM11062ygK6RXTwLgmMT3kJDaSBaiO7eQ6dKdl5Yhd8+Ca6bJm0v4w2nMlE2U5eP1+HHTWC1/9+mPr1w8vOc8TRWI+jnwZVC9HqJt3C+LtB0TihuHYCiXelIYZGhuMGeMARKgr3V42RsoHbWzKPqHbU5OllK3niN8Ho847xcB+cCCeprfGIIRmO40K3NoLD7BZUtQqajC1ePI3F9F/qixi8JYarRlnUfwmUnsxiJ2Ax1AfP7sn4RaI25nv6yP5/q3eK46mhl9GQtBWtVg7po/MNnHmbpiWOsBTAyaDvtMeRUatE7OWYcchODoVtYEvue7TRSJu7+oWpYQiOHkDe0rSl7/0APWcR6lwamtv6qj+NEN6gK8W+YSWMms8zFdVcNn9DaQcFEZ/hBqD3BXy6a4rblPyUCXQQzXPz5GvSZ33tiBsbuL88UHOTkoEbAy5YaQiZIGHj8qIPmcpBlraPNPnrARU//8gqZPyTMQjYa01/wa
 aqPApoMg
 oHRanqBmD/AZNA/kgYOj0bZcKuOEO1nOm2HHsKFPsDt8qnBGuPS3igAde+Xop4prfkrCwKAa1aw0WZOMbQwpQiMVbrEBHJDWPqSTa0CbBFHHsV9Y/vReMSLhgQKoIADalD6F2Twu3Nj9v/zplS/0T2dA5TRybplxBs46FD/IKmpzYL5UmtKusd3T4QdKu1xR5nm5ADpgm4gP0RH7ZnZXHpGEnIKGaBlNAzeaET/NOSJpbxcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.51.2


