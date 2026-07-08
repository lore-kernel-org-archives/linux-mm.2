Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C87FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7124A6B00CC; Tue,  7 Jul 2026 23:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3BD6B00CE; Tue,  7 Jul 2026 23:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1F36B00CF; Tue,  7 Jul 2026 23:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2713E6B00CC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 776D1C3E27
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:51 +0000 (UTC)
X-FDA: 84964134822.20.8698C50
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id B6610180006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cJIBm7l6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 39L9NagoKCAUoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=39L9NagoKCAUoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2GJhcciwaP4fHjsRT6KM4zWTWsLGZ2JTjerBFR60HQ=;
	b=0eKzB+wTMDA/V3uzLD5PlGU5QoGLyg62Hjb+I8LcScNscD2N96f6BfNXsPy/407dTHl3Hl
	GHD0sepLGgKM92MqgOHxgX/SGlVHEO+2bILOmSzycsGHnDa8X77XlFjMMXaB+NDIirld6C
	BdhvKoXALvvZt3ocHRMAZS5ZJrUBhZw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cJIBm7l6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 39L9NagoKCAUoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=39L9NagoKCAUoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480309;
	b=5FJ6g6EGmTtBo8TO6JiA27pfiHJOpxMcIdAe89CtAltlZL18PmQ2lC6RHymoBfMfzNO4Ph
	PhZXgJD/rc9hu5lalDGN2iQzw0cTFpgtb+7NuyNOOhWo83gBbhMaVY7+YKCuAdYNcxbU1C
	SlSJ2UiTiucm+ZQwfTYo5xnY17WdQtM=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8482b95574dso287968b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480309; x=1784085109; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f2GJhcciwaP4fHjsRT6KM4zWTWsLGZ2JTjerBFR60HQ=;
        b=cJIBm7l6/rO1J6KPhhQ6dm1e2UsFWEp128KnxpvUr1KBhUE2Rpmnu80svv0F9xsmud
         Zq+M/hAhe2eHZK852S7Er0ZVN2NJrPE3Bz3GZ9Or8eKhnF9MxpseAeoC2d8OJsof7MEG
         21+45nut5sliaw+or1ULDXs6JTpYx5hFkA0+0rsx2RqT8IIm7E0KLef72jzuBXGgLMnq
         5bm5Kg35Mg+got5uGgvdfdMyE1+9AwGFnttUmWGsQuXHa30dRoq/UMEHZj9LId9BV2VK
         5XKDh87ocOfIZFgyURqa5keX2AEpZ5U2UhRkVyHtmPTgD8Cqxw+lCof/YHj5do/panou
         iJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480309; x=1784085109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f2GJhcciwaP4fHjsRT6KM4zWTWsLGZ2JTjerBFR60HQ=;
        b=pNwHP0bHNV5TXo5Vwmi9Rf/bDwxUbz2+M/pL2XBd6uAsD8oGqDkqyOiB3F55X2xfZX
         SFkaj8t72Hp4vmIZH5wLD82fYbwCUuvrClXa1srbwQA1VdUc1MACv5LfpfNJku7cuAsN
         Z0CrEbq7jU4kli/52UK203DNI7b49uLCsq11sH0ZprRWvbiogVEcEN2T8yXvpmk2P7u7
         jbi+PgZpUp4T8aARcY5tqFCSOclbm1mEr5B+v0uuX1RHdNivOJ4arfh0QfQsdtivozzI
         pI+Y1WSv4oaKn1sQ0te7iF/gmnMt74n/Z6/e0mwkc2EmRmPLrudVqnGUNYPaIESvV8qz
         GVJg==
X-Forwarded-Encrypted: i=1; AHgh+RpmIHfbNfhzLVVCwFupQvJnIZdeOLZtTh5q5Eenq245ysyG8JQeBPgiLQuosTvH4aVPCtI9fYfRCA==@kvack.org
X-Gm-Message-State: AOJu0YxFdkpW57YJJEAwmHTFTsiAXYMXT7gZW5Rd9Y+7Lo70JZldz0AA
	2T0Fbyt3ZhdQepgI52c2I3eZbGhIHAoC9/vq5seNLIMOofY94eGIMmu5S4gVl/ijn33yW0HhjHi
	zLCYzVc0itrp1jy/BiLyF6g==
X-Received: from pfbjf15.prod.google.com ([2002:a05:6a00:6e4f:b0:848:42e4:9622])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:178c:b0:847:70cd:395a with SMTP id d2e1a72fcca58-84842fce3a2mr805556b3a.59.1783480308390;
 Tue, 07 Jul 2026 20:11:48 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:27 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-18-jthoughton@google.com>
Subject: [PATCH 17/18] arm64: Permit onlining of HVO-incompatible late CPUs if
 HVO is not in use
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B6610180006
X-Stat-Signature: 97ied8xf4qawednxcm1wz3z3cz1yhwnh
X-Rspam-User: 
X-HE-Tag: 1783480309-565648
X-HE-Meta: U2FsdGVkX1+myeyGUTEk976fNssJYfU0ApPFZyxGqt11XOhjg+jd7Zy8vJVIEKUEk0dDISA194YMgFmaQ5918hXkmkLvRDGD39uUKRJNzf2VQhNrN9hfCEmvfNvZ90JtOdG6nC8xgS3lLnDYE8Dl29vJfeLmGjqlYS6hZOCtDJLkBmQF0OHvvHTUFNmDw34O60FbgLK4QOBRqpDThXZnLGHX2RttsYvyPmQu4hXUTUKPm9Ut9R1HJ91zuy8VdbHAfeNoH7TNpPqTcZAWJ4A0vSkMFFAGx2LBZhodDStWM3ZIeMm/FR8EpBw8aKosTWKAHjtemv+KdA2LVU6opwXaiIYoBJD/5KcWDVUeoVIc+Bc0/Vn+BVW34PogxrmzzjFuPDTOn/FnKGlhGmMeo45BWklWHgOexyPGe/nqlDMAhWUV32k5wdskvGGrZfqL3zg7y2KBuZjF5tu2xowHDCAceqbLJDi+8s3UulLAAc5CSfr3UrcAlZIXhbxXXGS+axcZ3RP2EL1CFqLfjQ4IGghOG8IGXkA6VPaBdtGZWLjY4ZegP5cqjVLLvI+jcVqGdyIYHN7I5LCZmdiYzn+xlfFfgCpvOZd5N+ddYufGlPZy8TIm9fdbqrfLzf4ybYm/2hYF3bsTt/mCthijwqGZjU1j++2KrrF/kV4oG+oUYnA1wKcnMDXZ+/buo7BTLLlO+/fcICDiguidpASBMQXIldRZ2qFbcI3zmDku8WppQ/xVHyaPCd/firGyMCoinF0V0vx9f9AIsMD29qjl7YSM/m7phcjSqKpZ3khMhzbDxFrkCUbnOoHbIznTQWiQfT3wlT2nmN/dEX7TnSPakuTSkVacwgB2hH+rW1YjVwwRJ7sMQdVxdcVqJoCE55LiosT0rfPxxiLD4vJeVksiomnDLpqsV0SAJ/xmcnSzT0pzV3U9LH2V2yfKRdhDQJhCMAF+qWO6WpDmHRx2zHacYAIsnX+
 8d3774S5
 NxLOsJdOIweLvCRFpmSBcGWQDTryL1fm5d9Ujl5qP96ZUJWJHmwfQFMYJPJsjAN0LUw26NnbMugwTgXxj/wHOnEXBwfu6FPnOSTB20y2dVt79uF08q483woHKckigzGeQv9NhKcK6KIAI1yJuAgTkKXIR3tIgvTsDfsRZbasDJvCWrY+2+EkyUq5BUDJos9UsaTusEu7Fxo0uYnzjwp/WYPAP5tdftLLExzuYS53xktqhWCUKHDecA8mojet8/ODzICo3LZRsTJ/KHfUWcFVB9za1kpYk6RmM/PobNzobRZIkVb3dG3K9n/Hg5KAmnCnbI4lwiPlXMo9XVCPZz/9rmUvKG6cM3GJopAYDUXBEKb9josJx+Mcpp3Z+MZ8DAEplIZ36T/7W6nSZrwSFYJKIM8plC0x3hiFILEV5Pp05MxLRRAdTsiJtCYOV9XxMv+ANFPu4T8JeIjU/vpYyw+FYnHGywKiUJzp0XXaaDE805M6FPMsDC1XCfU3r8RPvg+dJOC/2fU2h+3tO16pkC/pm8zlwyrJUf9O5xCR8iK5OBSNZYkDKpi0273Jww6OSWJ9buUqT6EP+Zqy2MXdYlXaO5cCOAxKUX0rpkRUEc79yZD3Y7KtLbGZQ7I380LNd9SVAwb/6nkfZ6ogh63I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First, HVO must have ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU so that
incompatible CPUs can be onlined if HVO is not in use. The
late_cpu_enable() callback is used to check if HVO is truly in use.

If the late CPU is incompatible with HVO and HVO is *not* in use, HVO
becomes permanently disabled.

If the late CPU is incompatible with HVO and HVO *is* in use, the CPU
is not onlined.

If the late CPU is compatible with HVO, there is no issue.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kernel/cpufeature.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7e2c134f3b55..65bb3c7c9595 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/hugetlb_vmemmap.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cpu.h>
@@ -2181,6 +2182,22 @@ static bool hvo_compatible(const struct arm64_cpu_capabilities *caps, int scope)
 	return supports_hw_af(scope);
 }
 
+static bool late_cpu_enable_hvo(const struct arm64_cpu_capabilities *__unused)
+{
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	if (cpu_has_hw_af())
+		return true;
+
+	/*
+	 * If the CPU does not support HW AF, we cannot online it if HVO is
+	 * currently in use.
+	 */
+	return hugetlb_vmemmap_optimization_try_disable();
+#else
+	return true;
+#endif
+}
+
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
@@ -3079,8 +3096,11 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "HugeTLB Vmemmap Optimization Support",
 		.capability = ARM64_HVO_COMPATIBLE,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM |
+			ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU |
+			ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU,
 		.matches = hvo_compatible,
+		.late_cpu_enable = late_cpu_enable_hvo,
 	},
 	{
 		.desc = "52-bit Virtual Addressing for KVM (LPA2)",
-- 
2.55.0.795.g602f6c329a-goog


