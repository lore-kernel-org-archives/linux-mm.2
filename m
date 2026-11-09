Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCACF60A6F59
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=lTHZ+qb8
Received: by kanga.kvack.org (Postfix)
	id E0B1C6B05CA; Mon,  9 Nov 2026 11:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB9E6B05CB; Mon,  9 Nov 2026 11:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D3B6B05CC; Mon,  9 Nov 2026 11:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA256B05CA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E56EE40712
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:55 +0000 (UTC)
X-FDA: 85416046590.14.CB4AE3B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 043EDC000C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lTHZ+qb8;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240114;
	b=NGFTv+CImZTaLJkCRkflpd9pj2DzjjLbojcKWjK6XDvGbzkvPb41JDlJSD1D+xvN26r9fL
	WfRn+h99IAbndqf8UG7rylncAUp98+iZdCunUs6zyeXUSfRVav14rqZk2XyRoH26UeErwJ
	99sKtpwOKFZiNH7Fcu7gTEsWdnXcIGE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lTHZ+qb8;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I20sRd/PRulOIZRhd+UEj/sasH6pZnvh1x/HC0d3HPs=;
	b=v804zmkCCGdkh7f3DuTZGsLhE/aKut0x4dMbcCYwa0ngeaeDuDwhsPM9hglVgO8XoCXdYK
	VtkYL7MmGXp/GTPOM40iboUa/0UevUoLzE2omzNvEKw80O3kc6cdU0SBIGI07p6NocBlpT
	sKxlfDv8jDSrOw04SIny8vq12O1Yo0I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 160072F;
	Mon,  9 Nov 2026 08:01:50 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39EAA3F632;
	Mon,  9 Nov 2026 08:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240113; bh=x0fs4aL6amulindDHORyceQYe6RPCjEvCe7RN43wDF8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lTHZ+qb8Lpb5MdGoi5c6jMxnW2x0nCEFq0oX1jDx8IG7OVlTjwulAINb2xlF9ymah
	 cOQTnqS9PT61Dl+Oidh19ri+5GXv0wrMFklaMGMHgi2oS6TrL60lyr61AtTCJHAc81
	 G76uWFAfR8qpm0XbXv4dpBu0AcJao1wvunC2ofCU=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:40 +0000
Subject: [PATCH RFC v10 15/22] arm64: kpkeys: Implement
 arch_supports_kpkeys_early()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-15-aa6c4d9603bc@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=1943;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=x0fs4aL6amulindDHORyceQYe6RPCjEvCe7RN43wDF8=;
 b=GI39UyqJq4/O0CdszPupFvOqE4Y/AHbk7Ja0HguyPHLzW9XAa/I3Sv7T0zG456AtmVEcUY1Ez
 gJM++4wBYmHC2L1Cg92cXl5qVHAPKbZNyE9HaVOaJcos0Hph2srQROE
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: t6epmgnzxkob8m8tzxs4ffpq9mnf4g9h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 043EDC000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240113-578409
X-HE-Meta: U2FsdGVkX1/Z/KQNkIQud4tVsbMneQcvb51kYMD7i9kdT2MEKQUHsgBadFSuyuX2uQ3+yYxgLI2RDrO030+nDB3jqc7D2EnbAnSlpPzYTGFn+qpENIGxegOUZk7OZm3PPH2belaGp+7/kMMIoKGWhaA149S6pNXAIKiXG3tIO9jHPsdUW2go5OrapgUF7BTJSeHbiDMPcUwDZu2laGSkF7Tryr81PthrsTEflW9225p/FJuNZDC+83Z46A0CzZLSR5TOGUg7+YC7MzfaHvD+ZfyXd/3Bi1y6ZpN9GJ/L9OCb4CcrRTmqduRySVVMGFQN6zDYSrmaYxCjsga8gtZcEPCFfOdU2jXiMf+gsuMeZwvhPLGjSGupt2ck60rVnywr84+5B6MK9iAbnQLy30OvjBteW2E0ifIkhvR1BvCRRv1q/7yINrYMhnd2yHBGXUMZEiwL3U6QK6uby4208LP+zRto5LAfHxJHR6zrFUM++rB++CDvRtOm+4yFvQAfV9PVtEYvo7eYFKyxVNZK7qjgWyjmLlrhiTnGBs51O2X0UMXyN/9248+MYuLY7MWCfacUxzBO8Wlwe0J+38Rbhez6mjcv2/XpIFov3u2AoxiEoms0YaE7eXuiMQTODCwxQTi47Ysxw4jTch4CB9gx27DYrPjf8dDLeUoRFHeRXV944BqYIBmyWU5cZgbMVzLyR0rDnjy6p7ZPciOiExq01+yNoBuV5oYhFRDNcjD0AyVclx48XYJk3Mt9wuKdPE1pvyy01EQTZWAJDjZTHHkfk/HeOshgX0JBT6s3CjqCPqTDKu40xuFZvt9MRF1GBmD2cI24fLtwDLiSS3y2vyrc26kNHKKmOZJTmrymLfA8hM9VLz4tdsdtCTW4dS8P+KtR1DwIHXrIeV2Fs+BMltbNvYHZIuvAN3xJS6vv2Y0OsLA4AT5vE6lbSEXa474Mf9UY6MW6+tyvWzPLatb5NoScl/o
 Mg833okr
 XneqPEvOUKcp0+ToE4VqaoyWU4wqbdWaHTDY8/OvTp98L1YGOf/wudKYS5SjiBMk90kEV47M5WusDCSXlE81ApfqPiRXb1bU/w0Vvw0/2PoItyGZmDk8AAR7yoJAigb9setEdb92rI1Iw/NOiGHWVQCWnYGWd6YGL0ceeb6TUql0NQVQYvqWjXCsh8me9FL7LWwSVR2IKOVty42bi2WF8cxYj7kb9LepV964JtUGfdCB4KrXAl9d0fsVVbwcFn8bMzO8e3O2LoFj9odEst9LMH6nPO+SJFtRaB+VqugWhH7lDT2Ws0ACQYcLfmZ/C50T9XPpgs2+3LCLQ7JMPZTSUEn1giMKX/yiDIkVqDPKGsq+BjO4/WDIgkQEj/9aEIOh21oITvPhEyGtP75JYW3w3/56qA0d0FQC/LKa2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We need to check if the kpkeys_hardened_pgtables feature is going to
be enabled very early during boot, to decide how to set up the
linear map and how to allocate early page tables. This happens even
before boot CPU features are detected.

Implement the arch_supports_kpkeys_early() helper by directly
checking if the boot CPU supports POE, if it is called before boot
CPU features are detected. It may also be called later, in which
case we simply check the POE feature.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 12 ++++++++++++
 arch/arm64/include/asm/kpkeys.h     |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e3c8a1493dc8..062d444da4ea 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -1114,6 +1114,18 @@ static inline bool cpu_has_lpa2(void)
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
diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 4f9bdb369b47..70d85b0d69d6 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -21,6 +21,13 @@ static inline bool arch_supports_kpkeys(void)
 	return system_supports_poe();
 }
 
+static inline bool arch_supports_kpkeys_early(void)
+{
+	/* POE is a boot feature */
+	return boot_capabilities_finalized() ?
+		system_supports_poe() : cpu_has_poe();
+}
+
 #ifdef CONFIG_ARM64_POE
 
 static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)

-- 
2.56.0


