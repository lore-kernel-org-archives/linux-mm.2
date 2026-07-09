Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE40C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DEF56B0088; Thu,  9 Jul 2026 07:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5846B009E; Thu,  9 Jul 2026 07:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FCF86B0088; Thu,  9 Jul 2026 07:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1256B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:28:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC0BBC012E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:28:33 +0000 (UTC)
X-FDA: 84969015306.15.A18BDFE
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id 07C19120002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:28:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=et2VeqbG;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AN464t3GErrzCu0A8hyIj0aMpfRwo0PDzzsVvqxolEc=;
	b=vnv3l6AGAOR+u8AO9u//2Pzva+9mjoyKv3VC71aQjhPkApfdia4azoyMpWlfilehTvACx4
	tyU4asxDvsYBRVFSCOp8M7nzGTe61n8ssBuit1WQYcTVf0FD8NAiQQgi7pylVvg4dDNlRS
	2NrBxKJiGw8hTFvdSnKV+1T8BGA/VNY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=et2VeqbG;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596512;
	b=CdTPxR1f9I7VpN3qsMY8K0+XZ9l+dDDMtdoN5P6iaIOR8ME/O2bj/1t0blu5/AEx/3lxlE
	QClCxtgGlLbi4qvLD4+xvUKNYGLYn8YJ8sD6zE8DsNrhTV5TeZfIdfn0gCuXYByRoymMKK
	LMCKBSq5p77HuVRwe065sXV1jjF8DgA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596506; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=AN464t3GErrzCu0A8hyIj0aMpfRwo0PDzzsVvqxolEc=;
 b=et2VeqbGY3Yb26WM2odN801kehVtE1LMN9E9+kSbKQWi8OyTNkzF0dKE7/SplLzTRZT5Xq
 DlS2o8wxkCRO8fOD5UX6WeZ8okhfIUTQP/5mngLll3U5FSnqIcu+CgarfpyFLR2D6M1VkI
 TDJzKO7V/odmu6FOslia3CqaQOQnD3FSxlARnCzM6X9b34YJ8ZLRNFMl0G4wf+El4e9B4h
 jdM4vCCy0dFiFs5/OJUjk20mFjt2FeMbTQu56VohMLBU/LOSWqrgS2Ryl/m0JJZ+JxBHHV
 F8TPANhYmSsGnJ0g/mzwwt9iadY7o/nH3RbsoyTDanEV0DXLAsQheEXfTKxtnA==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Subject: [PATCH v6 7/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
Content-Transfer-Encoding: 7bit
Date: Thu,  9 Jul 2026 19:25:19 +0800
Message-Id: <20260709112520.24857-8-lizhe.67@bytedance.com>
In-Reply-To: <20260709112520.24857-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4f85d8+c6ac53+kvack.org+lizhe.67@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07C19120002
X-Stat-Signature: kdgawi3yyuc9ptqqf4ccs3o9eorrqmdg
X-HE-Tag: 1783596511-900499
X-HE-Meta: U2FsdGVkX18c2sq9i9bUBmJpYH2pY6R81erHflZGWQdhSXlhJAzt4Z+4J7CQrxxkoLf95XExnNztAiQEgckG44NvTm+dQxvXB847mw25LLDzPddb5yX9HFxwm93Wrf0WqpvFFXTG/2EPzOBAUw3NMeSgx7tRaBa7OMlpsEeP32zSTC/rd4skCmZAfjNgzfxhBDV2xMSUcJI5Fp9Q+l1PRwNA505N3x03sJAYLa18TDZaRu6Y1T2J349ZCxCkvYc8i+s93N5FGDZKr137/XHCBne2cTfH41yvfTdjCqr/q2IbGKUQv8c89uV+a7HXJDw1u+6yZu9zT+XXWvjW2d8orjKVXBBTlnKIGF87ijKoj8E37QoyzT9X/ceCkgnHJtW/+X3AN6Jrnw5pcmZEiY+GiWnCc3cpqaiMccDv/kSHe9zMqrIeIKbfa4x5NYLWlQsQT6QM1bxWJi8W39J040wTcESexpQnNsD24J5MOX3mL7FMXAyqMo6aC99fku3VNErn01YaW5dmht4By7kg2io+mY7dCGF6k5IU+FYscZJJthDIOcuGIir8YqWEVLQaRVAtC7jIznBEyNntTUT9zwusXaz1i8taY/wJGpNkZbLJMcTGBKOmScBqDglko+rSKSI6MhNpuvcnZ7huh8axOQFDMwU1wd0cQ8ryX49K/N8wLsu26XSnjKcPlbXd0Lvct7SF98Y9A5jn71FDdR7Rg1P6GAfMDyQHcIX5sQN6Cb0dzvKnGw0DCF2mT2mNGKsNBJeEp10vYBFUisrE/n9AvwsCSP1zuCI6u2CD/kvqEWwKkzZN3uMv8AedW4eYHNXhyUNYFclqtxMvlNx2/V5fad1JQXXXWwOKT2BFRiLstVJ3A2dUwrV+VMNjrKbOgEqPLFicNIiiWMp4ZvqWCW3lsL3BLUGJUPDeCRzZ8ntr4ah/AUpOkbO9E8KR0gVCatlwpsXA4awunw37T8fcUUQQJ5L
 Dxg4pETn
 xOAYHz8dyz2Agkf9niWaubkrBDR2L2GXFQdblvIYumAxc9s2/izP9oEFsO8NBMm22Xg32JpHABY7IwZJUtAw/HGvVW62cLNu31ThxzFgCWlxoJ2JZhyWxkgfBdk0MBYROFaxHcvMvQO+8v4v+tq8/xiVktjpp1VyhH/pJilR4SbA0C2o2kvXtsWhCZ6hvCx4CCXKYm81AZV0bmWNsApOgaxXGX63aIWcHQdbZzz2ZIxhdtWuL1amB9edo4o72+pzEchH2mf3jkf+8rEYafwG/5h8bp3kE2n5JghENc8yEQgPDTfMUcOLNIjTr6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new x86 memcpy_nt() helper in this series maps to
memcpy_flushcache(), and the ZONE_DEVICE fast path uses that primitive
for constant-sized struct page template copies.

The immediately relevant x86_64 sizeof(struct page) values here are 64,
80, and 96 bytes. memcpy_flushcache() currently inlines only the 4, 8,
and 16-byte cases, so even those constant-sized struct page copies fall
through to __memcpy_flushcache().

Add 32, 48, 64, 80, and 96-byte MOVNTI sequences to the main fixed-size
switch so those constant-sized copies can stay on the inline path.
Factor the larger sequences into movnti_8()/16()/32()/64() helpers so
the switch can reuse them without duplicating the inline assembly.
While the ZONE_DEVICE template-copy path only needs 64/80/96-byte
copies, keep 32-byte and 48-byte copies inline as well rather than
sending those nearby fixed-size cases back to __memcpy_flushcache().

A microbenchmark compared two memcpy_flushcache()-style helpers that
shared the same generic body and differed only in whether
32/48/64/80/96-byte copies stayed in the fixed-size switch or were
redirected to __memcpy_flushcache() when the destination was not 8-byte
aligned. The timed interval covered the copy loop only; wmb() was used
only to separate rounds.

In pseudo-code, the two variants were:

variant A:
	switch (len) {
		case 32:
		case 48:
		case 64:
		case 80:
		case 96:
			do fixed-size MOVNTI stores;
			return;
		default:
			generic __memcpy_flushcache()-style body;
	}

variant B:
	switch (len) {
		case 32:
		case 48:
		case 64:
		case 80:
		case 96:
			if (!IS_ALIGNED(dst, 8))
				goto generic_path;
			do fixed-size MOVNTI stores;
			return;
		default:
	generic_path:
			generic __memcpy_flushcache()-style body;
	}

For offsets 1..7 averaged, keeping those sizes in the fixed-size
switch took about 0.410/0.411/0.426/0.426/0.428 us per
32/48/64/80/96-byte copy, while redirecting the same cases to
__memcpy_flushcache() took about 0.962/0.956/0.923/0.998/1.001 us.

Based on that measurement, keep these new cases in the main
memcpy_flushcache() fixed-size switch without a separate
alignment check.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 56 +++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 6cb9e0ac7fa0..1e634264a31b 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -83,7 +83,35 @@ int strcmp(const char *cs, const char *ct);
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
-static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+
+static __always_inline void movnti_8(void *dst, const void *src)
+{
+	asm volatile("movntiq %1, %0"
+		     : "=m"(*(u64 *)dst)
+		     : "r"(*(const u64 *)src)
+		     : "memory");
+}
+
+static __always_inline void movnti_16(void *dst, const void *src)
+{
+	movnti_8(dst, src);
+	movnti_8(dst + 8, src + 8);
+}
+
+static __always_inline void movnti_32(void *dst, const void *src)
+{
+	movnti_16(dst, src);
+	movnti_16(dst + 16, src + 16);
+}
+
+static __always_inline void movnti_64(void *dst, const void *src)
+{
+	movnti_32(dst, src);
+	movnti_32(dst + 32, src + 32);
+}
+
+static __always_inline void memcpy_flushcache(void *dst, const void *src,
+					      size_t cnt)
 {
 	if (__builtin_constant_p(cnt)) {
 		switch (cnt) {
@@ -97,8 +125,34 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
 				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
 				return;
+			/*
+			 * The relevant fixed-size copies here are the
+			 * x86_64 struct page sizes: 64, 80, and 96 bytes.
+			 * Keep 32-byte and 48-byte copies inline as well
+			 * instead of sending those nearby fixed-size
+			 * cases back to __memcpy_flushcache().
+			 */
+			case 32:
+				movnti_32(dst, src);
+				return;
+			case 48:
+				movnti_32(dst, src);
+				movnti_16(dst + 32, src + 32);
+				return;
+			case 64:
+				movnti_64(dst, src);
+				return;
+			case 80:
+				movnti_64(dst, src);
+				movnti_16(dst + 64, src + 64);
+				return;
+			case 96:
+				movnti_64(dst, src);
+				movnti_32(dst + 64, src + 64);
+				return;
 		}
 	}
+
 	__memcpy_flushcache(dst, src, cnt);
 }
 
-- 
2.20.1

