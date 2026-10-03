Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8515ECA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05DCD6B00AB; Fri,  2 Oct 2026 20:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035BE6B00AC; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D626B00AD; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B62CC6B00AB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C46FA781B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:47 +0000 (UTC)
X-FDA: 85279411854.13.CEBD6A6
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf23.hostedemail.com (Postfix) with ESMTP id A34EA140003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lIA5PFGJ;
	spf=pass (imf23.hostedemail.com: domain of 3mErAagoKCIsy8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3mErAagoKCIsy8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgJgaArgO+LTLU+v+0vmnZUyY2L/xXa/jijIgJz7koY=;
	b=NE6nHluLrAYaNnq0+aO2PIvKgpRgflFgTQFx1MlxD7f/szviIsOwVyT9TniVKQJuYW6mTl
	LW8riORdKqwc/LlDSrwrWkSYSQnWN5uZGJx2VVsQlN/jbPsKrEvke8+GfU49xO4UxY1kn+
	HLBRNZuJvdc4t9BQqkpN5pztp9LUqBI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986905;
	b=EhJ3VJOIEeLTU5MGsCSk3cQz4KLsWAFwjr4TUwiXnutW++NlQZnyySuMshm9Gr7VpedGcp
	8S+0gD57zQF2m/ZWX60la9w3DAQePHDJCPA02WIEntjNhM+S1c+6W8ZOg/d3TATdI/HE/J
	eOwmkKuNM3sLiikm6H1+isHL0GrUFsY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lIA5PFGJ;
	spf=pass (imf23.hostedemail.com: domain of 3mErAagoKCIsy8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3mErAagoKCIsy8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc73895c7d5so181240a12.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986904; x=1791591704; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kgJgaArgO+LTLU+v+0vmnZUyY2L/xXa/jijIgJz7koY=;
        b=lIA5PFGJVxwik8nTWMN+eQRLy+tmr+3Iq2aNxTeomfAIFrw+PnnSlTWEok1duVlkbn
         nFwQoNAqS+JS/DQUg3YHcbOKkriWsZAHIUXms7rHvi8Me2Y8PMWVTDVlFIj4Px4EIruC
         m23baDEI09/zh8+Hwos8M9iPwdapYEpPJEK+4ggO7Z6xHKwzXIQRUpt5YeipDXr+fUaC
         8vr3c0x3vHnwQ5TVgQMVxJaiFdgwHafClBy34vQ3LqBN+SOkyyaUvGz+SuHGKOh8uZtC
         MWgxhs5MCTJJgUhpL3Z4fp6MJZ8ByM5XCHLGU8OACVNzqmqq+j4YWa+1OzgY8y2S5i/T
         eLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986904; x=1791591704;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kgJgaArgO+LTLU+v+0vmnZUyY2L/xXa/jijIgJz7koY=;
        b=0pbgv81SffmmMXD+WZFryxA17SnlvpEb6uX+YNBtV7C3FYRLtCz+ja2LZzwufmYiNt
         tRwLI763/K14zoc8QLaqUNcjdnHIysp2ojN3KzcfDjm1AXfHtJH/wXZhb8fUPmYFqcOv
         Zni5Vx7tU+QBERx2c9/cCWYmhZ0aQA1/96uN1IIKzK4q/YIDzAi1GhNdfH+abS8+iC6j
         SAIJF1L6Ob6kgSDVCLiPABwfNt7xXcTb88hO1SqNjXqhOWKoo62hq5pt1vEzlBKJFypo
         19ySiRG97AhKnRULsTnsbo3REEAKrSgyVQJTDQNg8dmljSS2MIjYgj3tvXuIXLa4BISp
         di0w==
X-Forwarded-Encrypted: i=1; AKwUvBxEhqn0W8Ed0CKvmvo37lYSa/xofqVfduceRI35j9MnmAOqg8Hwyl66nYbPrnamFjJVZRpF9PKHGw==@kvack.org
X-Gm-Message-State: AFuF++kqbhrjvM5yp7ztChW9QiplD252b7E0Bz5wD+pX7nDvmucNUoOc
	3rWtSLS+LKWt6WIz6fj63rIo67Qc/CeDqReM0wZXG+5VAz/j9c2CUiIe4HxYYAKCrMtfc6yBJKZ
	lTgQMspsihH2jLP/4ITv0KA==
X-Received: from pghs8.prod.google.com ([2002:a63:e808:0:b0:cca:5338:9514])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:cfa8:b0:3de:4662:16f3 with SMTP id adf61e73a8af0-3e0d6b4a29bmr858218637.50.1790986904231;
 Fri, 02 Oct 2026 17:21:44 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:14 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-12-jthoughton@google.com>
Subject: [PATCH v2 11/20] arm64: Add bbm_through_af capability
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: e6h5z5hwznedsu8idu6oqrd8jzq3raqh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A34EA140003
X-HE-Tag: 1790986905-901440
X-HE-Meta: U2FsdGVkX1/KcPVe8m/6XUu78xKHsV77wB35d3nfUyI/IxdrsV16zMR+UK1zw9rsuEgOhFlVQ4owmH0HvDx0PbVnU6F3xleYx506pKx9EX8HGusIVgBCQa9ViYDfk7KJd5QO+QGo6gK/DkLYl6lWxJBBusfWk70L2zLdbMYfbmapipb09N/GogxWTk1hlrxcriIQ0H5666chH5Nr3Mp0nGaHc0BBUEwDmBOXOW2jqyzoQRGFalqqTU10ncc8M7IRvfTNEw8U82unf9LXZvRbWhg/uajAsnWDRTZye+OUVZQVk1YTaInkLKQyvtOyx8L3RZaZxzUCc+/r8jrYNl9rh7xXxjFvM+EH8e9BHIA/s+KFOk2DeVtNwCNM6gUkQzxwN8XUMARpF6mtjsRkeZu/1CW6BmmgERum28vkOVLtZnle6L5KmcBCD2y+OsCif+wXDH4flvfnZxUAcP3XOtwB445OAlEe5IyOWjlFjfq7AAPNMM4AT1SkfKk1GPaj9E23H/u7zifKTj5TJAN/NdPPpnZ1lxAD+DccR5JWSxAyULaZ6LXQH7hWd74Z5Vhd6+ZSMvum86EUSPuLzy8R+rj2sJ0oq+1liYY7c5OJ6YiQfozpNRv5q4kmK/tKSRVYZaIp+E7xK8fLdGKWcfXD3OmG7uwGGg96S577V5W/C/2HwZgqHzVaNz+6/rqCldgUKLIpk5mBSvUXFw9ehQLG+F/o5Fmbq97RG+aNvmxkriwIjAen7sPVYj51dqbAwgOOSQehv6lBqOHq9e7DjYTlLorTCNYC059BHH5PXAvKprPGfoMlxIesNnDmOESAF/7Cpw2WBTump6xlH5PpLaiFKcE2TOLRtSLRGZ7CiCojpnDrUhQqZvz3mVWS29TN2PdDHeMIWuPcziCZtgdn4tgiGXGydI4jzRmw7oOK21D4SCH+kQKJy2snFT7nmwLxuZmABQ/bHHAuFTIX3oGdXl82R9z
 SReLPqvT
 LpTyVand2YySuHPU066POQ6MwpXTmGLdGao7AgklrOEuppnJVGM4T96XWBxgY0MpFs4T2dupAGhfLYz/xnNHiXTfyr6VyQge00z2Aj5fLnH335HvxCzvCT96/furOwVW2+PMVrO6DpoDOwWCzUi8r5hnf1LxC/YWWvsP8nylun3IXr8CsYDsYHqk+6Ey3IlYe+ZPO/uCbzwdhUH7GEJGsCY/WW6zesO203ig1+jv7/zPJZX9CV05ihdieBjEr1BIn2xHhmdFRrhIY3b7285Rvz/RZQgsXu3yY9o21cOZGm9el/eyxrEbLpjf0Bl3tFqI8avNb+nv2g222hfxVTZhmpMc7SLDWTYmNmq7uZUzyG6CwQatxcOnhJC9DnAPGzD2Ux3+CTcUu1OJS7KKFWIWZMKhcyoZ9Qb0cy64bBpV/uo45Ag9xvYYhFc93kkGP+qvSHf519LjzzNCf4BFKOIGJb0s1flMQ4rdRkcm6rTmVLk5gb41uBOAswNEbQj8Jc0LX/m7H9Y29YzZOVQLGaz8DSQxWf+kVWwLBm5+4+IF8EEecAIZzp7Az+DDcgghUhSeObqBJ6+oBlj3y4oHnf66p2RfeY1y02ozOlO/kLIAmDLa4FmLfwosM3PhCcOHevi6HkUr8/cE4skMRuiDis8k7CQXE8WKj4e/2OM7z1x9E/Go5ag1j8Rho8ekLuIwoDmAw4hcl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HVO requires BBM Level 3 for the block -> table transitions when
optimizing the vmemmap, and it requires hardware AF management to avoid
taking page faults on the !AF translation that is installed as part of
the RW table -> RO + new OA table transitions.

Call this requirement "BBM through AF"; i.e., all CPUs support BBM-less,
in-place TTD updates. Model this as a system feature, as all CPUs must
support it for the kernel to use it.

It may seem odd to check for HVO support directly in bbm_through_af().
If this weren't done, any system with mismatched HW AF will no longer be
able to start late CPUs that are missing HW AF if all early CPUs have HW
AF (and BBML3).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/cpufeature.h |  5 +++++
 arch/arm64/kernel/cpufeature.c      | 26 ++++++++++++++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 3 files changed, 32 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4f04ad82ea34..fbededd7b748 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -878,6 +878,11 @@ static inline bool system_supports_bbml3(void)
 	return alternative_has_cap_unlikely(ARM64_HAS_BBML3);
 }
 
+static inline bool system_supports_bbm_through_af(void)
+{
+	return alternative_has_cap_unlikely(ARM64_HAS_BBM_THROUGH_AF);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 32102c3912fa..448d4ef085de 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/hugetlb.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cpu.h>
@@ -2193,6 +2194,25 @@ static bool has_bbml3(const struct arm64_cpu_capabilities *caps, int scope)
 	return cpu_supports_bbml3();
 }
 
+static bool has_bbm_through_af(const struct arm64_cpu_capabilities *caps, int scope)
+{
+	/*
+	 * BBM-through-AF is only needed for HVO. If HVO is not in use, don't
+	 * penalize systems with mismatched support.
+	 */
+	if (!hugetlb_vmemmap_optimize_enabled()) {
+		BUILD_BUG_ON(!IS_ENABLED(CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT));
+		return false;
+	}
+
+	/*
+	 * We need BBML3 to support Block -> Table transitions without taking
+	 * faults, and we need HW AF support to support changing the OA without
+	 * taking faults.
+	 */
+	return cpu_supports_bbml3() && cpu_has_hw_af();
+}
+
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
@@ -3102,6 +3122,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
 		.matches = has_bbml3,
 	},
+	{
+		.desc = "BBM-less TTD updates via Access Flag",
+		.capability = ARM64_HAS_BBM_THROUGH_AF,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_bbm_through_af,
+	},
 	{
 		.desc = "52-bit Virtual Addressing for KVM (LPA2)",
 		.capability = ARM64_HAS_LPA2,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 2775ba3359cf..25a84aa8a363 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -15,6 +15,7 @@ HAS_ADDRESS_AUTH_IMP_DEF
 HAS_AMU_EXTN
 HAS_ARMv8_4_TTL
 HAS_BBML3
+HAS_BBM_THROUGH_AF
 HAS_CACHE_DIC
 HAS_CACHE_IDC
 HAS_CNP
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


