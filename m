Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BD3606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nTRs+bQn
Received: by kanga.kvack.org (Postfix)
	id 4DDCF6B05BF; Sun, 22 Nov 2026 13:45:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48EEE6B05C2; Sun, 22 Nov 2026 13:45:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C956B05C3; Sun, 22 Nov 2026 13:45:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7A76B05BF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 908591A0710
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:11 +0000 (UTC)
X-FDA: 85463632422.16.B3AB789
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf29.hostedemail.com (Postfix) with ESMTP id CFE25120005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nTRs+bQn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3NDgDawoKCBE0Ay5BxyA54x55x2v.t532z4BE-331Crt1.58x@flex--jthoughton.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3NDgDawoKCBE0Ay5BxyA54x55x2v.t532z4BE-331Crt1.58x@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373109;
	b=SfxndlBZEwpvPAepp41Gkudu9iIvN5cC753CXBiwI6nngme8voREfWwAof5/aohMBW0kxK
	QL8ZMt5hc80PKZs8l60q9c9WrG5PBpQLYJPAu/tZSsNojgFfKU9ZuQD1uENA1AM1siuneS
	hyEhKEysED0VI0Yi7LQART1tlLRUP8o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UO6lsBJ7c54oQdvfF5gDh+eGlBppWPfqiUT6SIqJiU=;
	b=ryINcrD5uMXiVtXxVuT3nRlkLvQRula+iVH7DGwLJnc+oyN2+UKLxx+5UYACNpFiXiuEOa
	Rm4LWBOd4SY9zLYw0iC9w5ejk5jyY7/yy38RaBrheEWPDbRLfV7zuk8inzK3O6T6yCbjBd
	kJvCVe3pFweH86XN1u6xUZl7dGWuUZs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nTRs+bQn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3NDgDawoKCBE0Ay5BxyA54x55x2v.t532z4BE-331Crt1.58x@flex--jthoughton.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3NDgDawoKCBE0Ay5BxyA54x55x2v.t532z4BE-331Crt1.58x@flex--jthoughton.bounces.google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b18165dc53so3084915a91.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373109; x=1795977909; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4UO6lsBJ7c54oQdvfF5gDh+eGlBppWPfqiUT6SIqJiU=;
        b=nTRs+bQnN8Mxo6DNjb8BUjDZfuTYtuCksPjRW2bLv+KYtQglbex6cyymMOFuonnhxK
         jQKVfIzJvdp9WBuvpaw2DYiyfPlTWEau4qhAOUVrASx0xHSmNLnlcW8dCjAVD2wDfTch
         rqCNefzxbPBZ0T6nt6RHMYpubv9yBSGvJiFMafrW3NpwwgMdh+/X8lq1p0dDxCVV4rgt
         jazaN37nNvhW8FsMk05cjzdds8LIp1yYcKJmYexapbsMxFdn/b/h74pwiu9RqvvSuCrG
         EOA3doAYizl9V+02FSCjsQxlxliVX/Q7eLfND/g2ZZCCHSBmzhewCM7+NOP8NbfzlLKM
         eO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373109; x=1795977909;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4UO6lsBJ7c54oQdvfF5gDh+eGlBppWPfqiUT6SIqJiU=;
        b=nlk718P14FATqhLX23rUAQB6BlBpZrx7Un9zKS54J+Uz1J9gd+i7lcrThP0Pp0QBlL
         4rJ/5KNuCqBShdpC7e/4ChycWQmPQKbgYMITxwLYxHDqHoqv+cxPagKChb2jcQCtRv/p
         9MANkAXHWMqYy2zbxmEk8qWLihuVraF3zwpc15oeZ/byBWGsz44wja0NoyfpMdjyXZV6
         /YORka9a7QB/zF9nxXFVBHHDXoJtd+Qe3J2IgIxDgeIZsDu0iLcZxFf8zQDbPEFrDQXQ
         df2z0X64Ot8t2qwOQpwpc57nw76dtjfCS7FHRy9YefTcsAJVJ79HJvi6SMH4OyKDTtLF
         WqDA==
X-Forwarded-Encrypted: i=1; AL+hErFMelDHnVFUrWyN+dG98aQ1vfUPsBker5EKCGpNtKEtO9cx8Qa01AQosniRq6qmuwEYYe91LSGFbA==@kvack.org
X-Gm-Message-State: APuU4Z+pWH8pnhxco1lLZ+nLTPWd1vWIeTXGNq2sJFhpArrodNaMdF9Q
	1qzgUDH3BYrwwcoIj0KJj5KKoO3uoKCOMbwoqRqV7qwJossp5/yu0i1n6Px3goobQevy8aAOXUx
	pUK7LTpjDaRtAqAmDKmXl/A==
X-Received: from pjbie6.prod.google.com ([2002:a17:90b:4006:b0:3b3:c164:f1d8])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:17cb:b0:3b1:3598:f881 with SMTP id 98e67ed59e1d1-3b41cb20b9amr8960448a91.53.1795373108395;
 Sun, 22 Nov 2026 10:45:08 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:43 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-10-jthoughton@google.com>
Subject: [PATCH v3 09/19] arm64: Add bbm_through_af capability
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9xf3up6f99u5yehgqotzq5jkbj51drwa
X-Rspam-User:
X-Rspamd-Queue-Id: CFE25120005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795373109-271652
X-HE-Meta: U2FsdGVkX18pDI/TMMpaLCS4fHs2zHLutVirQ7DPZSAXB87FR4TVOkhdT8FqPuMmYGyWFWgU9QpOxWoFBbnd7pSwpaj8DN5wzNQoUTQXweHIFqGKkmIPQtb9GZ51LCm2+hZguRlLoH1SO0u+cioehnnLnpqMdXSkZTQkpo1+p/t2iSPYAammCMxNlH3htwGfqS/dvSSwsCMCflco8uSiFyhF2H6ijQCYuhFfTDXhDk8gJ8BApH4JLZBeBxejxfGwkC58AekHgNzi91TMJCdfAFeEFFcailCGePg9Kq+bJj1AkYSflhoRr9l3ZOx8JWG94zIFbPaWFoOoAqQRr/TuxgS/fBpYVFxU+ymdQsIMHj4bcMpekRpUfzRRal3K4AAl+GiQWEpvS3XO4Way3Fiuojqu6f2i7W1LY//8ZEISH1GDxA5qQAbH6IYPSifCTX4DEYEIjdYykevluIdAyLj45rFo/mgebhlp8j17GGfMO583oYCZYYETw5Ccsx877DGInrjY94ac/FDclP5oaI+c3MruFfvYjC/MHHIADhFhj/kkIbQeOT2xaZNRiN026KZuSRbh9NirxSKX+D8B/EC5EP6HEnyfZ44ZrmxeOpslVNR9ToKfpk8Sj4wp9SiK6SI3NhHQcac+waZzTGjB4Hk6IEnqEGNOh26PE4Ekl9721P6dCRIbx6+NQFuNmjLJ/FeSJrV4DAKGa9mY3qG/FitlqpGkSixoZALNXG+2b/TDsPIzwBDXrk/zu/UEaFLJfleHpZ0b266co2awDIX1o4/B6MJNPFNp9spGfA8el0FmQFDUDMXmyIvdFeItNPmyT3jtMtll1Y0q0znIBNf/fsoO4PsJI6rXgOvIQ8vxwz95dnHbcYX4DNOVeGM9d0qGjffS+FxnR1sj+FvAQHKDaVNbbGa/uPi5oGeZvDP8XsW0iy5TvWJveN49XOdbcORZBO7pVz1k1B1d4SbyDLm9nQy
 zb69jHLO
 9iUq4qJM9LPkmgmpCjWqYWwvHMWl3fSyDdwLrvcZ+oe/oygNGyDtREcFDBfkST7RK17ua0OBgmDkZahLrRaoVibHLexw4jKvxefRCaJMUKWnEh4zXtXuL5tOtHBnhPGn4csdJYrJWf1+BCwwTlCBiSH98A/u/AlJE0vQfH1Q1aTeiX8i7F2pDp5Es9kmB/Fr9Dt/sw553/ktqXtYiQz8yVf/ULa/eyRevJmYy6Nuz7Wro21CMqRgtTVHx000FISPUh+Laiq2x92spy2Kv1KHOP9cBUcXcKGuYxiEbl1ma3XuuzE8c/diiPKJZ8U+CnNgTuMhElBt8yUDlSvLoufyvM6efdYdXaHKidNy4djWJlPw5tZwuBG7qg8IOMMO7AMjU5BcWmKjU3LI6kWXXe1H2Sn+yHE9YMkyhZTrZeIoWON1G/5K9Nvufv3taZS33DSMGVLx1PBTHo6ZS4dRn0Urqq4zMIqY6vaHpt578CRJTLfMQ5OYwpcKJEVyF0e1wZUOQCQE/e3xkcIg0I7fVNMVnCXFgZaUaoF5Rw4ueP1+WEA8hQm1FjMTJ25VK34JLptJVhmn2KJPSnmwaukVLYoIEJ0Qnz39203zgdCYsmpruxXiC3VB22nV/KQKLKU4A19vndvA7ELGfLfXnojgMrXa2OZa29k8PfVko/FjV3vM6lxqGk2XF6dT4LGJy59V+xECJD/2nV5ZXzkDRGzgkVEnfdgq/BUhak9UoL9fFuKFFnglBYaoQqMjwHm66Sf5/Nh1cc6hgP5WpXQ8sJMWByn3g5E6gDThaEUh6QMBHtwnsFabW7YAjo3VDZ1iS2SIFUzeXWTvY1w3CrayIRoewvlCN91jzKB/OE73+SHCzsU4+LwRwsza+leemilCZAE84YAptPo24
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

This depends on HVO enablement not changing after boot, so select
ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/Kconfig                  |  1 +
 arch/arm64/include/asm/cpufeature.h |  5 +++++
 arch/arm64/kernel/cpufeature.c      | 33 +++++++++++++++++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 4 files changed, 40 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9b08b2457a55..4cce60c2de66 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -61,6 +61,7 @@ config ARM64
 	select ARCH_HAVE_ELF_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_HAVE_TRACE_MMIO_ACCESS
+	select ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	select ARCH_USE_CMPXCHG_LOCKREF
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e3c8a1493dc8..b9106b5a8dcc 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -909,6 +909,11 @@ static inline bool system_supports_bbml3(void)
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
index c9c9a6889455..d241638b5143 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/hugetlb.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cpu.h>
@@ -2044,6 +2045,31 @@ static bool has_bbml3(const struct arm64_cpu_capabilities *caps, int scope)
 	return cpu_supports_bbml3();
 }
 
+static bool has_bbm_through_af(const struct arm64_cpu_capabilities *caps, int scope)
+{
+	/* The kernel only enables HW AF updates with CONFIG_ARM64_HW_AFDBM. */
+	if (!IS_ENABLED(CONFIG_ARM64_HW_AFDBM))
+		return false;
+
+	/*
+	 * BBM-through-AF is only needed for HVO. If HVO is not in use, don't
+	 * penalize systems with mismatched support.
+	 */
+	if (!hugetlb_vmemmap_optimize_enabled()) {
+		/* Only valid if HVO cannot be enabled later via the sysctl. */
+		BUILD_BUG_ON(!IS_ENABLED(CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO));
+		return false;
+	}
+
+	/*
+	 * We need BBML3 to support Block -> Table transitions without taking
+	 * faults, and we need HW AF support to support changing the OA without
+	 * taking faults. has_cpuid_feature() checks HAFDBS >= AF, reading the
+	 * local CPU's register when verifying a late CPU.
+	 */
+	return cpu_supports_bbml3() && has_cpuid_feature(caps, scope);
+}
+
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
@@ -2953,6 +2979,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
 		.matches = has_bbml3,
 	},
+	{
+		.desc = "BBM-less TTD updates via Access Flag",
+		.capability = ARM64_HAS_BBM_THROUGH_AF,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_bbm_through_af,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, AF)
+	},
 	{
 		.desc = "52-bit Virtual-Physical Addressing for S1 and S2 (LPA2)",
 		.capability = ARM64_HAS_LPA2,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 3125695122a0..25292233ecd4 100644
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
2.56.1.809.ga0b61035b5-goog


