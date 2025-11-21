Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE501CFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0BE6B00A3; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12E96B009F; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0516B00A3; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80DB26B009F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECF57C070F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:46 +0000 (UTC)
X-FDA: 84135518292.14.4726AC1
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6842C1C0002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=VheqOwN6;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/tEc5tFrvTtBuLMXuLE+3Ir+qQmPEaILfulPI2BDOU=;
	b=TgjIqIz2XLHzrIezrMswpcj9S1SvP3rfPeaZJFKoRbTaU1w1Cp8T4bHWkVCYCS1d3Lbntw
	TjBTjNYZ543izUfWelpteazTdPmvo0JLU6sTZp82WGXWwWjFqPRsSncuaG70FADpXGOb/1
	4DS3jAP8c9aSoli3mAOHYNiUboBOKZg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=VheqOwN6;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751345; a=rsa-sha256;
	cv=none;
	b=GMKLxyfoXcDL+3BZ39NpKuYnN7lNyc5IStu8Eqqh9GisW6wSax9tUVfw/aLCwSYLcBrACp
	gnoBQB47JkJlhJdZ4ibvTqT1Lycste9m0v+79zGNBjSdIgGVeQH3gB+Pa38TJ3EIx0DsKH
	Du3dSucFHnjd31Dau35kL62MHEHgwDA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A/tEc5tFrvTtBuLMXuLE+3Ir+qQmPEaILfulPI2BDOU=; b=VheqOwN6A2nhqQpeYKL3X+7bW4
	oVtNF6AZIrS/xvOmeFyApFmstN2D+jPT8I5GrBf6IL6Rz0UH4BVH6zAc7qeqped0EUPzhe7CoyvVV
	NQQar/MYTER9IuKdSs3nAjWJhTZFQk21AXMc8N4+T1VmUkAfj1gG4uRFEiiTGOpWU3qV8OKywzvpg
	D8qT6uHRmzt07V2KuvF939mh1wXIDct2V+tldBrFe7gSTEkVGtD4hNTMfC98BbJ5+fEIjOj34Qz0e
	WRyo5RcMjfkA8AezN/s3fVFIo9I4TaRW/2Eg09a9LqZRhKu6zPuCq0KC0ODVPc7SsUxivt1USi7N/
	vrIIiHJg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-1QJt;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC v5 3/8] x86/mm: Introduce X86_FEATURE_RAR
Date: Fri, 21 Nov 2025 13:54:24 -0500
Message-ID: <20251121185530.21876-4-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121185530.21876-1-riel@surriel.com>
References: <20251121185530.21876-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6842C1C0002
X-Stat-Signature: gfectp3dm58homhyne6yh8isjtjsymat
X-Rspam-User: 
X-HE-Tag: 1763751345-247647
X-HE-Meta: U2FsdGVkX18/SmqmlctHc/BmySt+NXjv2JSqiWOGJkEmdhbUoRYgJTWrDVHbqz7zj2+VTSaKVSb3Q8pT/N7xwqTzjuTakK1pCCol0EbLkMHXYqhxbqAzXFCVnI9Gm+aOPKv75++EAGE+YCpPxPPJiveFlcGqk4xVjHMrMNSCCYVaJOQb/nUl6kBc0xwbNrKfV6nRI5jU0ENthepdo0yuDV/xiDAWbgsUzPUNAZrbOZYdL39rncGxJ6a/3DlxdAHMLEifmhfKlWVDliUsZ0vnQS4x1TCpWQ6j2i7r1fq+k6cd878pNU1IUtcXg6Jq8xTqWMOcwZqgpOfypGxq1GSekzRBxg6kC3hAwFo0Z7cr4Vk4h1Z8xGCmMyM2b0+11c5Zak5Goq6STqimWD0UX7MKBwlN9fOQUDF7gTZzHa4j4O/d9bT8tD9WoRZir+jyW9ABdg1ss3qvYKvcSGYTZH7oBZTmx9ouDqZPAtNLc2h1bExR9LamtjgiroCTnJTYq7fKhDtAYEeSCelzK9pLTJjYIRt9xAIdvuNI5BWvbQXrDM06eVpw+dfqtP9Ds0iAmW1uhcweM0wk9AahqNvIiHtM1Oyc6APPNVTHOk1z41MYxNxmb5vP9YqG7cR7FapahPg5T0ho4moW4MiSaSMVDMawX7qCDvQ6qPRjv470LWdR3XHpfmN90fogGvSeHL5w87UQqq7FvdrMmlWoM7fogTzwTkTF9sm+lY2lCcFfeDBZqnD3UAYJK0fJTF/DINocX1uCQr82a9KMuXuYL3z2B82OqeuiTGQErVlhfCNdj/ESpSTTpCGG0GMnd0PUxYElTZFqF1aQXnoapCVo3ZGmwkDU8o6SC+0O/LySIfl1wwpAiQrZDPO5Hz/mEAUa+jqRO4GgZEAEasEPBuBHwowXEje0cSFRWNTybocPEO3/v7TmN1YpLV0tZAn5RiUNLFIhlkt5BBkSm+g0GTXkWHuOZ2O
 7R8ixySJ
 milR3gZQi1RHinIr6r97nqI81rzSvEPIgNbaW4oPXAWa2R0EURbo3bpCR+wJB/6cy3x/CNdcxIWSfoYJwRX53rDDpi/J7UFFkSYLwTgcMZcZCpeNSJEXa2lZdB2t0fayFwWvfF9ZHEVMGnqT0JaBAoLFYhll2JxTZCFx0YRQvuFnoTuaVtxzGWwhBiHcAqn+QYCGfKz/obiOaw84lmLzV/67mF8uJ1U41mwZMdRSY2QDtDc5v6LfCXqGIavHiBERPOC9Lm8TKDlILWtdS5PCl/9w0yG8vJMNaHr++LPhOvVp5SLlocO4HH/oq45E7WHV7JrYqWBnGHj0TUBgf885XS3wPUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu-cheng Yu <yu-cheng.yu@intel.com>

Introduce X86_FEATURE_RAR and enumeration of the feature.

[riel: moved initialization to intel.c and disabling to Kconfig.cpufeatures]

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/Kconfig.cpufeatures       | 4 ++++
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/intel.c        | 9 +++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig.cpufeatures b/arch/x86/Kconfig.cpufeatures
index 733d5aff2456..6389f0a617c8 100644
--- a/arch/x86/Kconfig.cpufeatures
+++ b/arch/x86/Kconfig.cpufeatures
@@ -199,3 +199,7 @@ config X86_DISABLED_FEATURE_SEV_SNP
 config X86_DISABLED_FEATURE_INVLPGB
 	def_bool y
 	depends on !BROADCAST_TLB_FLUSH
+
+config X86_DISABLED_FEATURE_RAR
+	def_bool y
+	depends on !BROADCAST_TLB_FLUSH
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b6472e252491..5cb57a820198 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -76,7 +76,7 @@
 #define X86_FEATURE_K8			( 3*32+ 4) /* Opteron, Athlon64 */
 #define X86_FEATURE_ZEN5		( 3*32+ 5) /* CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_ZEN6		( 3*32+ 6) /* CPU based on Zen6 microarchitecture */
-/* Free                                 ( 3*32+ 7) */
+#define X86_FEATURE_RAR			( 3*32+ 7) /* Intel Remote Action Request */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* "constant_tsc" TSC ticks at a constant rate */
 #define X86_FEATURE_UP			( 3*32+ 9) /* "up" SMP kernel running on UP */
 #define X86_FEATURE_ART			( 3*32+10) /* "art" Always running timer (ART) */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 98ae4c37c93e..b53bf3452d6a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -719,6 +719,15 @@ static void intel_detect_tlb(struct cpuinfo_x86 *c)
 	cpuid_leaf_0x2(&regs);
 	for_each_cpuid_0x2_desc(regs, ptr, desc)
 		intel_tlb_lookup(desc);
+
+	if (cpu_has(c, X86_FEATURE_CORE_CAPABILITIES)) {
+		u64 msr;
+
+		rdmsrl(MSR_IA32_CORE_CAPS, msr);
+
+		if (msr & MSR_IA32_CORE_CAPS_RAR)
+			setup_force_cpu_cap(X86_FEATURE_RAR);
+	}
 }
 
 static const struct cpu_dev intel_cpu_dev = {
-- 
2.51.1


