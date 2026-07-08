Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C27AEC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BACDE6B00B8; Tue,  7 Jul 2026 23:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EF36B00BA; Tue,  7 Jul 2026 23:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E3C6B00BB; Tue,  7 Jul 2026 23:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 688DE6B00B8
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9F08A05B7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:42 +0000 (UTC)
X-FDA: 84964134444.13.94C3CEE
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B3C0A0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="v7k/CHYI";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3679NagoKCPolvjqwijvqpiqqing.eqonkpwz-oomxcem.qti@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3679NagoKCPolvjqwijvqpiqqing.eqonkpwz-oomxcem.qti@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYFEot0xG+gqPBMU77C4lYbv1Usc9k6OYGJ/3Ree3IU=;
	b=8o+G9ptdN/LJ7Ft45clWLo35w3+0ozocfktLy4SfnpieQ+ehrX56ia/Q2UWPVqaNDTE2gj
	ASUfoUQ9lISgHlUgjiQoBlljykDXKmSdo7avCvalCIrOMKZlvvcyHmHEB9YwJ05yRD36mS
	YjzKvJNYKAHCYss6dn0gtkxkn1ibxpI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="v7k/CHYI";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3679NagoKCPolvjqwijvqpiqqing.eqonkpwz-oomxcem.qti@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3679NagoKCPolvjqwijvqpiqqing.eqonkpwz-oomxcem.qti@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480301;
	b=lM+rPrZxjmoEviU5yOqRlM5+5nm6tHHrT6Uv6Fgq8tlEJy8SKf/DJzCCxNJI05wb94GHW8
	v9SCno4PrR+URa3W4vzb0KW6JCXUS4UiWPd8/E9jcvASA9xzqW+mJMrgTZrRAnuI+WOrQY
	LwIa6RPs0dtibuwRltnyV4MOSWz/jcw=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2cc8bde6318so5478845ad.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480300; x=1784085100; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jYFEot0xG+gqPBMU77C4lYbv1Usc9k6OYGJ/3Ree3IU=;
        b=v7k/CHYIgS19lk9REUOwqB/rLtZtuSvgGohdImhrtnV9GT3hPB882JcIk6PdzxNJME
         3WvIOHl187pB6lWmu9j2PTxem1FLXvimJveIoVKFS96FHwvJKnQrvpG18G5H30pZE75J
         53MaU8wBe9BnNF0U75OZw+0IQD5nIexerOkSjqzVmFN6av+4XfcgPzpNmPKsWM0CBrrL
         AR7m9ibWFd3tRB5MZ99d878I1OPwgS2Nv3gXeDYV9euobdhRLe8KBxHvWYCofsehQgf9
         zhakV4pf/69UIlK0WsApy+uL19Ig6k0196x9V9XexHaHMdWKKq3Qackj6w8/e7bmUmnt
         Yj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480300; x=1784085100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jYFEot0xG+gqPBMU77C4lYbv1Usc9k6OYGJ/3Ree3IU=;
        b=oHwljfRkz2oeyxmcpvCaZiTOYJH6bDsdBgkDPUfMauWKNRiNx55M+QdzS7ccUTGLzV
         jvR7JBQj2PM4bbiFWgrLH7/STnMp14EQf8sk1cac/v60PSk1z7wGozl4PqVYXfkcCS5D
         5siC7X/PVO/R1uKjLed7Gi8U+RR3a0IK7JA99QBT/Rr2dm5buaKHzvjmEXMTJZsgGXuK
         DfXMLXOFH9mfd7yENmgvGFOkHV2p0nBZ6IwcrLl7a1ZhEBFbYMggadJ28iaXu05jHvGH
         +E8PxKYFY+9JjDG45t7R542R4gtyW933k1VSpPBDWp6TEqweOo4ZwarZrrnv26YlQZ+C
         S7zQ==
X-Forwarded-Encrypted: i=1; AHgh+RoMprP1ZEyxyWaBpz4z44VxX5D3NmceXXLaq3j4DJ9BkRqwE6ei3cHmcnjUwrcJzU/No+bIWm8Wag==@kvack.org
X-Gm-Message-State: AOJu0YzBgW+gUyY7i7GpnFPh/5SZ6AIZxZk8jKR8DxxHQywp6WprAMtz
	ocWCl16PP86Rm777WdWkcj8AO2hjxF5QbhiBAQvXDfdvY6YJwxYPjua5zRzYZ2sMAyQYB4j/Nla
	V0w9FufrqvMeRVHxT01dQAQ==
X-Received: from plbkq14.prod.google.com ([2002:a17:903:284e:b0:2c7:e8ed:e941])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b4e:b0:2ca:d658:d874 with SMTP id d9443c01a7336-2ccea45e8camr7594005ad.23.1783480299668;
 Tue, 07 Jul 2026 20:11:39 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:17 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-8-jthoughton@google.com>
Subject: [PATCH 07/18] arm64: Add system_supports_hvo
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1B3C0A0005
X-Stat-Signature: x7yp8b8z18topcgx8ujqrbqybj6jmik1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783480300-368865
X-HE-Meta: U2FsdGVkX1+t18KlZnX7wogl0GAkvKiOuHsRoKOBfuazI0ZGEmxVxI1FPaxhzvgn6zUuxwrgzOxvWjUoTh2lJ+Ybt/E3FSAlGQWsmJd9NrWJ0vNXLBxFVbcb0Gy++sb2O70t62gOnUhKft9op8Czv733gpNMiPfafcaJeR2Dtst67xOfzPEPIJiDMceZeHRiu7De97iPVwtb80asB1UAByBoBMXl93b9QX5BMv9JNpJ9qB4TbEeMiPqzdbRaad0veZ6eJW26uMytQ8VMKWzRC5KUuz97Fhyr8j7SMXdMSvgTFnopXHFuSpySsPUqa8biF/WWRcpbQkCrV9vNCyBJMY+Uk3Tybvy4sHY0MC0s+/Ocj57W+BIzd/PPV9suexS1dlc8I23ad/MuGGM/EEtEUYXZaUVNepDel5Yy3Miaxga+o1y0h+kqz9ee6BHffG0nO90aOCAaseQVxAaN/okLvmFfkxO4RFreVSDSoUZ+fUcAubEOR82IckvV0d6/jkQ+uRFNSFkBrO0NiFwj3RhbzlgNStsTNxJtpJKEQu2T3kQPorle53F1wm+tF63V4FB5n+1/FNs2+xFGJzpQj6XAexkv4zOjop9mX6eXaON3a7RHZrC9pr5IB3TODK1dOqVPVs4lq9/w7CQP2rwTqNVB1It+uGfCyXC0dxota2NiIJYdRE8E5e489pPlQhk7X873TsUaweEo+V4D5flDNx8ujzKvtL04T59zBCzyT79qJNPruiIpi8PYRH9iU1hsdsW2e3WL3+zQmLLDphcK5eYOqeRxt9IcYrnw39ir05yE9OZiZDUfAsfXIdUze6yYCrYUdv9taOwuiOfICsA4bzj1JdoPN2m9nCbvuGQyxjET9wz1gmimkmDfxe9SlKVmIFqcBpu0uJFZD7RhB+DNjmQqvAoLw4BzNtkWT4I5ztz9XYfuc1OkLqISYGIXrfRKLtNQz4Qqczya4qKNrrtm6Uj
 MX3kZD4u
 g67d/U1VCqmpue19xk6Jl/bk8gRD1sBQ/uFTl8+Scu2TSfhnl1ok5ejSVdePQWkO1aHjDLRTL3Zdpd/co/YzV6NfgEpkHE9tByalAHVti7GWV5zoJe0/D7eUcabt1/YmGWnwHAjFus5ZT/O33YlJBS4iA75LIAKjhIJ24/L074+ejtz/xQpd3J0mJfQKEM7uMkxvSEFZkBQR+92szkAs/PK7BnKdIDmOFQiUKoxStFyRSVcTxpVDOIz/ao8gIcO8gR3YO4qccQRogpT9RZ5slDpWpLt0KNSvGjT3a2QyFjjm02swlW9fYgxVRa6p4ot/OiX+6tG02oefkhIWcGXZGal90Xogzc9puF0SH+H/G75pBVBDrCdjBdnbLcYlr0rPYDwuREuZOOiG74z9tZYmOTZkxZna06N6VuZO0nn7yJhpett+SWwsHCcEKC2RrFNur4wxRGJ6D2QHjv6Dudl38MViHVwYBds1sn8ubwaEhuMPa/TkoDB85/bNxpav8iHEo0aMcHnSzaUeU91sVesCGupxE9myV5q8zeUtWOrdqihnslURNvt2W/WiAkjN4RMELxCr8DKBy8beEV5cByqTRiyTMmL6EkkZ6sFRkgSSWJO6OYBCwbVeXiEQYjwTSAyUlsWasNkSRs7lq0R/Q3+C/urK+npDYmEOoi0gL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track HVO compatibility as its own system feature. If every boot CPU
supports it, later onlining a CPU that doesn't support it won't be
allowed.

HVO requires BBM Level 2 no abort for the block -> table transitions
when optimizing the vmemmap, and it requires hardware AF management to
avoid taking page faults on the !AF translation that is installed as
part of the RW table -> RO + new OA table transitions.

Another possibility would be to disable HVO if an incompatible CPU were
onlined; I haven't done this.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/cpucaps.h    |  2 ++
 arch/arm64/include/asm/cpufeature.h |  5 +++++
 arch/arm64/kernel/cpufeature.c      | 16 ++++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 4 files changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 25c61cda901c..6db3ef827f86 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -75,6 +75,8 @@ cpucap_is_possible(const unsigned int cap)
 		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
 	case ARM64_HAS_LSUI:
 		return IS_ENABLED(CONFIG_ARM64_LSUI);
+	case ARM64_HVO_COMPATIBLE:
+		return IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP);
 	}
 
 	return true;
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e818ad1b56e2..a62c284962cf 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -885,6 +885,11 @@ static inline bool system_supports_bbml2_noabort(void)
 	return alternative_has_cap_unlikely(ARM64_HAS_BBML2_NOABORT);
 }
 
+static inline bool system_supports_hvo(void)
+{
+	return alternative_has_cap_unlikely(ARM64_HVO_COMPATIBLE);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120..3b9224b99a5f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2172,6 +2172,16 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
 	return cpu_supports_bbml2_noabort();
 }
 
+static bool hvo_compatible(const struct arm64_cpu_capabilities *caps, int scope)
+{
+	/*
+	 * We need BBML2 to support Block -> Table transitions without taking
+	 * faults, and we need HW AF support to support changing the OA without
+	 * taking faults.
+	 */
+	return cpu_supports_bbml2_noabort() && supports_hw_af(scope);
+}
+
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
@@ -3067,6 +3077,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
 		.matches = has_bbml2_noabort,
 	},
+	{
+		.desc = "HugeTLB Vmemmap Optimization Support",
+		.capability = ARM64_HVO_COMPATIBLE,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = hvo_compatible,
+	},
 	{
 		.desc = "52-bit Virtual Addressing for KVM (LPA2)",
 		.capability = ARM64_HAS_LPA2,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9b85a84f6fd4..630953d59c52 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -70,6 +70,7 @@ HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HAS_XNX
 HAFT
+HVO_COMPATIBLE
 HW_DBM
 KVM_HVHE
 KVM_PROTECTED_MODE
-- 
2.55.0.795.g602f6c329a-goog


