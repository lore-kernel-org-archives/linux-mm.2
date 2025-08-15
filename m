Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B43FCA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F109900225; Fri, 15 Aug 2025 05:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2778E0002; Fri, 15 Aug 2025 05:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA3E900225; Fri, 15 Aug 2025 05:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 088078E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:00:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC4FF83A12
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:14 +0000 (UTC)
X-FDA: 83778395148.14.ADD406D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1B25040005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XU5bu+lKKeDLR9H4YP964In4FuB9GNE60ZYvTs3tXww=;
	b=hqyFkj8n/v/l/+Y6nb4epVeIGAY8j94qXs9ujOvg+5WffGRzS10icWDQvv6W8ThXUd1TX3
	FhWb6o0rM0PE295tFToCpLIVcTTq9CfsaUDKBSR4XVFhG1jz4LGrwp61IXw6TV9007DgzL
	9GK9wYW1AdTSsDgdOT+m0SLO4l8NfWA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248413; a=rsa-sha256;
	cv=none;
	b=TqJO0+eQRzrlP78HE3QdkmcIk5wAkGCz3pydfYHL3zx3otyotgjAfv4kg8kBhUuBYPrbSZ
	1BilSMSGJH5vMAZb+8OJDXoXLFh3in1eKiH01ikuQCUcK7gLqVw7sgtfdrI422zFtAz1rU
	kIBLyexu1+S+lVCBvMankNELmRvHjw0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18FDD1E32;
	Fri, 15 Aug 2025 02:00:04 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D38593F63F;
	Fri, 15 Aug 2025 02:00:07 -0700 (PDT)
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
Subject: [RFC PATCH v2 1/8] arm64: kpkeys: Avoid unnecessary writes to POR_EL1
Date: Fri, 15 Aug 2025 09:59:53 +0100
Message-ID: <20250815090000.2182450-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815090000.2182450-1-kevin.brodsky@arm.com>
References: <20250815090000.2182450-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B25040005
X-Stat-Signature: 818ci65zbxqn18gnahizm73pt96gr8pj
X-Rspam-User: 
X-HE-Tag: 1755248412-54517
X-HE-Meta: U2FsdGVkX185ZrU8srreOXXI/olDfeHwGReJJGZDAtxkfnXA+sXyXl5bftdkEBd6WIcF+3A+SR5gBff54K3A/AUgxNaydHTvRiNkaeRAaHPF0AthcvIYmc4jz+GC+Zy8kVITSJZiufDecA3Zal8a/j/fiMMe0jCOKfEZqMQ2KSJWV3w4LQ/YQUYWSQ/KA/WZ6HmksMiXTSuKTJ2/8pdAZGedIzXbzjBtf1RI/uo3c3zAgRdw4TSpioIARni5YsT82WaJAR+cWLXa9DXVvmi8CCbjczWdu3RoRvJ7WZ4b9xg1AI3z+4P3GIpMx9VbPxa2bwfKGbiOe3BQPYFPT008gBlC1BrsjpUYrPcjN3DJUirX1+eJF2p5P0PViQcCQZPKWbHdKmL67n09Mg7afaXRar7ujWxr8HtLtBVkw1i5i/ONlxKiaG5LazqbFUI9lv52SaU6K4cBe2HrAUiIKJlxE4ku5J+Ar35aYlB1bbXNhdZDg8fg2alXTukj0gDz63TMu5vEDWtEuX2Nbk2eTRbGESWGqwPWUaVOcPaQu4tF1A+iQok18I5uPdyn/0ZLpdsHkRL9/4jFbo3OqVgqVIF2slk3BziVAC5vfpywr9FW03bM2IzbzsCFgFisT845jnCy+cJoGjn5FjvHjwHnU4kIH2G1urubqv+Dk7ecTzt/JUvj5XVFB1v2DsrSsQSpHwlWqQqEEPyEXigPR2djHgoczlwg1kWozHzB+zF2bL4Ki47O9q8PVlFfutJpAQTwRpFiuEKNf2pLAWo+EwmNt1ZP4TirTOlvo8EtkNJyxV9Lc+1cP07Vmc2Tsn4A6luOL9A2XgmUBB2sUzE5xrYbYhudomSdRjtEoBFSEo+LLcSpQNosynZwZigHrSx6+vTVHjKW/m8oMn0jH2+qLr67MCTlzdZatfLS7OaVsrSUATV2q9aLcKG60fd1TW7D7YfM7BuzNaCijQiIr34UjBLOQOa
 gwSblAr4
 IdhdalKkLYceCyfq6puKO/+E+v0sdlopPy8qOudDo0d4IXfFP+gdmZpldGsIea0EccfzwlrikhqHYQoRjYp5gcUqhPuJYJhY8zRAzFIOq/FvE35OKChYVU5B37DsXiPrFbpEeatcULVmFPbbdRT0Kx3KSVZKnvrlO6KU6W7ExSVhDuQpF7riN2pGZNJMyUWEj2PLpJABNxiHPlXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nested uses of kpkeys guards are about to be introduced, which means
that kpkeys_set_level() may not actually need to change the value of
POR_EL1. Since updating POR_EL1 requires an expensive ISB, let's
skip the write if the value is unchanged, by returning
KPKEYS_PKEY_REG_INVAL. This will cause the matching
kpkeys_restore_pkey_reg() call to bail out without calling
arch_kpkeys_restore_pkey_reg().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 64d6e22740ec..70e21df84252 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -43,6 +43,9 @@ static __always_inline int arch_kpkeys_set_level(int level)
 	u64 prev_por = read_sysreg_s(SYS_POR_EL1);
 	u64 new_por = por_set_kpkeys_level(prev_por, level);
 
+	if (new_por == prev_por)
+		return KPKEYS_PKEY_REG_INVAL;
+
 	__kpkeys_set_pkey_reg_nosync(new_por);
 	isb();
 
-- 
2.47.0


