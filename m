Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63051CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059EB900229; Fri, 15 Aug 2025 05:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A048E0002; Fri, 15 Aug 2025 05:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B6C900229; Fri, 15 Aug 2025 05:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D15248E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:00:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7C7C1A0925
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:33 +0000 (UTC)
X-FDA: 83778395946.21.9323536
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E9B74C0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6dr8q0/1hMR1pb3wh+uXWlet+zkGdwpA6OKpP0yl/7E=;
	b=yqVfpMPNkgLr6t6cBQrU4w47ChJi3nPwJtfGf1recs3z3hOdX3dRudC9Iady1svcWdgbpj
	bWJThdfPsNDNt/F4URYGNwm2pPr8Ro3xzVZ6FwjFv/63SLT8A66z56r7YZPC6G7p1Shdjp
	DcwOjP54Ucp1FaF56evWm57E4JXsck4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248432; a=rsa-sha256;
	cv=none;
	b=OVQ4iMV5MliDWyYwytnSTm+DMai4UJzSwMKyNcAHdtbYHIrOfTgIK8BlNspOstvRjcpenP
	iN68INgKo7j3d0OtAzfQ8K3yKS0CVIh1P4c1xdvtaq96OVDHTUHIMkZQrTyXLFQfkZYghk
	BGO7aHIe98lSMtJbsnetCH+eLFQWKes=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A53D2C42;
	Fri, 15 Aug 2025 02:00:23 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D78FF3F63F;
	Fri, 15 Aug 2025 02:00:26 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
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
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v2 5/8] mm: kpkeys: Introduce cred pkey/level
Date: Fri, 15 Aug 2025 09:59:57 +0100
Message-ID: <20250815090000.2182450-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815090000.2182450-1-kevin.brodsky@arm.com>
References: <20250815090000.2182450-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9B74C0007
X-Stat-Signature: w119db8npuiztx89jxf4rjxo1ppmepbw
X-HE-Tag: 1755248431-228907
X-HE-Meta: U2FsdGVkX1+K7RZWfVi1Arqs/9IlSglEdDXGFoy8eNxaQwBqxzFqQSOc7Q6lNXHaP/AricirzhErAjgAP5kBSqeLGAgrnNEjZdrTvQclwQ9ljtGf0x7TVdtNew2QDV7Ufk2vzEgKFGslHenbCfbgQ/PrEprAfq5Eq/hPE7GWBuMeTdOSo0dU+BXZHBhqtKNGGp731+6c6CcfvOsukcNoT0CH5DI/TmaJaydDmUpLFuiLZze2IcC/v0xaG12v14HMtUEUgc6nIfCNTTiq0fwqrKNGB0pviggFdUlA6sWrTqv9sqdna5Oz16oAELRLoNIj1VzyuNHp+I24xaY9mu17/wPDpX9RUPA7uNNJSNckM/rHT1+XNfA47IawMc1Bl746wQ3WdOpEMuBV5JLt/mmDflErpc2XbdEGJwK37+5SribL9P7z+dlDcIsTwpOWcmwLwqiFwjAs0q/AhfoMxCMDIi6l3qGas0B1C7D0xg67EOw2/tiadS1a+Ai4pqHkPK21FSRs4qdQ9glkd1bnvwrIAy2ictqAaCVlJoEgun4IMP6W+/lnDe7iTvqFMwqLrtVEBQSwvtSWLVLttQGZyajXH4O7c/jUqEZnVIRVE66KqKLyMxs4VIiXQPTTHj1yJvJ4R1cGLV/Uh70LWJW+IvTCFJ282hz7pkEMcHZENvSZouUliWMiHN/Zu8KW7cH+V5N5M0UNmdypPwjZGXhaoP0pxrc89C9ZNPy2ivqaxJhiK+VYQWj1qPlBDKk5e1PzD2WyHscVod3j2R1GrBBIJowyWi6Qss5ZG968jInuHV7sextSbRNMJYFHgzFBqY83eigoZRfwUjskmtXnx+i+/AxCnc8HZiG7jSItZB0cb4Xf3TerTweK4BcYxOWByXXWEdiNUr95A3otabYnCj9J+3M4Kqrf75ShXjRSmoSu7fgknzY7Dbc9PTbAvsZkQk5hkhXLRkK7A2ceS7e15++GH80
 eyCdgI/i
 UelViLimuHwtXuY4Ld/Xwjx+gb4QBdX4nS5o1KGdTkgyiiSDF+5FTwjLHdlZxRBiv9amqVW3qF3kEd0iBnE7gQeYpIAuHFparNbvSa20sUw9qUtYTKDXfWajT/ymgCN6MtsPXh/DMs9vG2CSRFaY5z0npxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will need a separate pkey to protect struct cred. Allocate one as
well as a new kpkeys level that grants write access to that pkey.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 7 ++++++-
 include/asm-generic/kpkeys.h    | 4 ++++
 include/linux/kpkeys.h          | 3 ++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index ded5d6e988dc..ffb7622391c3 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -13,7 +13,8 @@
  * used in assembly.
  */
 #define POR_EL1_INIT	(POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX) | \
-			 POR_ELx_PERM_PREP(KPKEYS_PKEY_PGTABLES, POE_R))
+			 POR_ELx_PERM_PREP(KPKEYS_PKEY_PGTABLES, POE_R) | \
+			 POR_ELx_PERM_PREP(KPKEYS_PKEY_CRED, POE_R))
 
 #ifndef __ASSEMBLY__
 
@@ -31,6 +32,10 @@ static inline u64 por_set_kpkeys_level(u64 por, int level)
 				     level == KPKEYS_LVL_PGTABLES ||
 				     level == KPKEYS_LVL_UNRESTRICTED
 				     ? POE_RW : POE_R);
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_CRED,
+				     level == KPKEYS_LVL_CRED ||
+				     level == KPKEYS_LVL_UNRESTRICTED
+				     ? POE_RW : POE_R);
 
 	return por;
 }
diff --git a/include/asm-generic/kpkeys.h b/include/asm-generic/kpkeys.h
index cec92334a9f3..56a2fc9fe4a6 100644
--- a/include/asm-generic/kpkeys.h
+++ b/include/asm-generic/kpkeys.h
@@ -2,6 +2,10 @@
 #ifndef __ASM_GENERIC_KPKEYS_H
 #define __ASM_GENERIC_KPKEYS_H
 
+#ifndef KPKEYS_PKEY_CRED
+#define KPKEYS_PKEY_CRED	2
+#endif
+
 #ifndef KPKEYS_PKEY_PGTABLES
 #define KPKEYS_PKEY_PGTABLES	1
 #endif
diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 48f240bea8e1..0e555b505b33 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -10,7 +10,8 @@ struct folio;
 
 #define KPKEYS_LVL_DEFAULT	0
 #define KPKEYS_LVL_PGTABLES	1
-#define KPKEYS_LVL_UNRESTRICTED	2
+#define KPKEYS_LVL_CRED		2
+#define KPKEYS_LVL_UNRESTRICTED	3
 
 #define KPKEYS_LVL_MIN		KPKEYS_LVL_DEFAULT
 #define KPKEYS_LVL_MAX		KPKEYS_LVL_UNRESTRICTED
-- 
2.47.0


