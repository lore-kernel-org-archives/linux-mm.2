Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDEEDFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598316B00B9; Fri, 27 Feb 2026 12:57:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579F26B00BB; Fri, 27 Feb 2026 12:57:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482E66B00BC; Fri, 27 Feb 2026 12:57:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 333416B00B9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA776160759
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:19 +0000 (UTC)
X-FDA: 84490993398.02.ABF1CBC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DFB2C0010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjpZmbQUYehEAYzC+ZHnQe7qBfX79LJND2uqrlGvS7I=;
	b=zfL8zEQtvKfcboVqMpTfg1MRIyM9+yP2IwqZXy6dhxbpfDERP76bfUvqsq58QomSvWqLyE
	CCDo3dDlKNNgtuR+duG8GzgE4dP5TVPSHdslIw/O1f5euD7UER8i2xPqE5c7o57oERdaah
	xskdaxLrhIwYH1y++4wpNAQsRNaC658=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215038; a=rsa-sha256;
	cv=none;
	b=RUkukNh6BeyeBetQlzLZ41lmmFjjtf3kaeXst3BNPa78yPkhfxxORS6ZUAkIXzVhB5yl/b
	LxRtM2HNtrS46yAyYhWg9r7+rGfuSeI9Y1xXsTR/M3CO+2FSrk0TGyKaesfIY0kwT5/kwi
	0Pu8xQe8fxWUO6umQBj6v8kAi+T4d7Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14A131516;
	Fri, 27 Feb 2026 09:57:11 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F40283F73B;
	Fri, 27 Feb 2026 09:57:12 -0800 (PST)
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
Subject: [PATCH v6 20/30] arm64: cpufeature: Add helper to directly probe CPU for POE support
Date: Fri, 27 Feb 2026 17:55:08 +0000
Message-ID: <20260227175518.3728055-21-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DFB2C0010
X-Rspamd-Server: rspam08
X-Stat-Signature: 7unswk7333raqzoiw1q81gtnxmos46dp
X-HE-Tag: 1772215037-601844
X-HE-Meta: U2FsdGVkX19Djlj2p20ZBD3RnWRqmt0rPTY6+pLm6UJpc03Z6a02NREDNpcUA5zcbGddh1oGJioU1AWQJpvDJPC9Lw3/aPANKaOPAR+7I1WVHzpjZFfiT8PIDES9F5WAJ2yrnQhU81sd51bd5UYFl9IFCTwk1EuqrKH1iRtxig4+pj0e+S23EIjI4d0bRO2UsrveZhfoCJjK/aGyhdXzFBAJ2WOlRDW+JqaPvecTVyMtchzP8H3w4grSZGweEbwdZKeG5OWEF8B9LISB2q8vqhfHOqAIaXd8mooiD5H0fHHQGfWu2S5DzO9V6Dy910RU5ulaFrpo1I8s6ZeDwX/ja7NGKP3Mj0d4Sfq+Q2e/26Ofg5A9Ek/pgEtEH7m4QTfEznfght4vE3jSOH+++FBetBlbeyIgc9AgqoxYwUyNmKoy7gPRMMoKoZ+NI94TwapCPHes6834ouOI0Ll/4nvQI0tyZgODLkfvNfZ7++fL/wVFYo9JFhl+3P5Hqa0xlX0S0F6EZ+ccZ0b3aeh7R3RDSt5WqOmNrcZxAFzpW4J+3Iy2xdtgVNq2FpTqc7Z4xnapYy2EHoDkvUPpSBOnYd4l/0BwTl0xuXUhw4A8j6Migc1fS1eNJjjQ6nCropyyhmkWDFTnalu4X0b/W6mIXnOO1M348aZvoMISBQJqFfFy9qIDXtlv4WFokoaXjTL7l5IxPrVx1yqAJY8V61v/m+F8DUNyx8QWoYTXAyjDrV86PXgHRSrQgaIXmWtym1nM+waknMOegWNrJrKdaq8KesnygyyI7vCroUxfBwAZ8Msc+Ce7J6o5V+N0F8oH7DZcK9wZAZO0BxDSIGuBa4S6Fa191sekbjIEWNPKS/a7OzLGM92djGI5cD8JkBpJQw60xzgbox4bLraofKPGQAcq/1zMTS7kljQc6mme0TfX3BzigffZQH7DJsfmr9JxUclqy3Uqpqpgg6zGCh/n5WautCl
 8R/3987a
 USUbOstPZID7GQ97SUKG9rw54KdYqOKEzaRqCcKyksV864TDKO8F9SWFaqfZzoBej6QTT5wP5vqYU35cp450KaoHVaNGb4Q6dPNVY6Vl95AyPBbDcczYYkBHELL5MEXjB5/Bjn15JGBxsE8QQ9piuQUz1Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to support the kpkeys_hardened_pgtables feature, we will
need to decide how to allocate early page tables, before boot CPU
features have been detected. To that end, add a new helper to check
that the boot CPU supports POE (meaning POE will eventually be
enabled).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4de51f8d92cb..8722e9e62702 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -1078,6 +1078,18 @@ static inline bool cpu_has_lpa2(void)
 #endif
 }
 
+static inline bool cpu_has_poe(void)
+{
+	u64 mmfr3;
+
+	if (!IS_ENABLED(CONFIG_ARM64_POE))
+		return false;
+
+	mmfr3 = read_sysreg_s(SYS_ID_AA64MMFR3_EL1);
+	return cpuid_feature_extract_unsigned_field(mmfr3,
+						    ID_AA64MMFR3_EL1_S1POE_SHIFT);
+}
+
 #endif /* __ASSEMBLER__ */
 
 #endif
-- 
2.51.2


