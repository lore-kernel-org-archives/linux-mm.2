Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B13D59F7A
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 08:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB7D6B000C; Sat, 13 Dec 2025 03:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C3C6B000D; Sat, 13 Dec 2025 03:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B806B000E; Sat, 13 Dec 2025 03:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7573F6B000C
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:01:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AF9B8AF6B
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:01:25 +0000 (UTC)
X-FDA: 84213702930.16.BA740C6
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C06D1A000D
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:01:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765612883; a=rsa-sha256;
	cv=none;
	b=guqvZ9vhQfIzKkfFwa6AagtEC+oZp+EzEGjOp683H6J6dGjb6ynwurM2dBMPQ8xr2LRJFu
	/4COHC4YtnhhHZyLqUDGgpaUPkfn3K1V4qRrFok/5VnbrnJ+7jW99YoJNgB7rrO6gqdhyv
	l06DaAieBVq8HldyeMu2Rdebf9tQvqI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765612883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hO0mmOrLQtX2f+WnOsj3vCPvjsJC7haFxv/QfsLP6Js=;
	b=G2rxIYd+4h5Gwb21HOBnNRY7OF2B6OgPfgRLeteYpaYsyhUotOUz9VNSBnLmZ2YWtdfBut
	VeBExV6F/i0QEDz/DPaIrLT+32MX36+5GrEWND4Br+uQco+ZsyY4uJb1Gd9XgqHvgD8HqE
	fC7ZWuD7jKTmTt+/1YQ6cOumwsKWzs4=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-299d40b0845so28558795ad.3
        for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:01:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765612882; x=1766217682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hO0mmOrLQtX2f+WnOsj3vCPvjsJC7haFxv/QfsLP6Js=;
        b=OdMY4ASMKHsj5zL9SwcOeLuZV7FwsD+y9SEz/AmEn68cBTGYyrLrwYvQ/dixgrfgw8
         tjwc1zGb0H+VNKn+IJdXbelTuqHd4fJapHn4suR0dLPKK4PHdvMAl2nHhvyyGPXokA78
         wN0EPJl/A669B6DRitPezB1bl2+Oi/tjlZwWruIEVjVXew6uXg7BJ+WpOVbloCjJU4N6
         OMzPZidiTFexPAujNnQCdg0LXIDQpCnZqt0aiDCtM9OImaoizt6RjizrPe3fU4zbQAns
         /5h0maY2YOYlMGTkvvgQZJ6Ugcsp9tZvToPig/e/dAZpeYJz7lCdGhkD4Wgra0fEZDLU
         guqg==
X-Forwarded-Encrypted: i=1; AJvYcCUShYfuw22xF4SOpGnMJHgYFy7JOaSDl86j7YdQOoxrjecBiESdEWOUKkfGGiIkpl8MM5UKpZZq+g==@kvack.org
X-Gm-Message-State: AOJu0Yy0mWSnMe2Y0GS0UM3tVyKear+ZKWed/xbkCfZewK4jBYHEjU+B
	aQklzJPdLvOtCS6b6pvyNg03CujxAAvPwJN0Ig9ERPPzT/byfs6Xs2x1
X-Gm-Gg: AY/fxX7P3Q0mUs0Vi5jobiZ5pqTGMaW3wv/igmex4f1ry864mHVSDrUbZuKupDgY5PR
	bVJGdD4Xc399CtMbof8PSnFS7d9GOVZCGy7GcpGo6NdceemGTB9HpYKgMx1wCXvIVGEnBnWslGt
	ZwvM3PxuuI4OzcLfIaRIOgaG72EOaf9zSfh/GyRz99VX2/oNB/K6HZPQCH9pNKHlyAsHKly/jXB
	v/NGg8XnlygZ+42mty5Ui02MfrXMA5fYr8lP++n+t3DqeWYYaQKfz+doPrukpQfKymwdCkZwiqI
	K5F6IlPtj2+h3HLZZZ0h7fbOc4AiXdw0nMt61KKKwlFqkEjivWBykGCysszQuVFlpxyppckiE8R
	hnBW/1YKR0eijS5PmXaZ2f0e3a898CeycLja3egg84mefqsWieLF/OPBo2RQ3giiERrdlChVndL
	NdfRZ28vZwd/l7C+P7lry95Ev1fQ==
X-Google-Smtp-Source: AGHT+IHVDW7jzJQJmTW2QCX77VaaJ/gbOI8PVom/MrydMKNXuHfqI/AK6StmWZkRHj080xHzVr0NUw==
X-Received: by 2002:a17:903:11d0:b0:297:fc22:3ab2 with SMTP id d9443c01a7336-29f23c7336emr45692435ad.36.1765612882029;
        Sat, 13 Dec 2025 00:01:22 -0800 (PST)
Received: from localhost.localdomain ([45.142.165.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f05287fa3sm53149155ad.5.2025.12.13.00.01.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 13 Dec 2025 00:01:21 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RFC 2/3] x86/mm: implement redundant IPI elimination for PMD unsharing
Date: Sat, 13 Dec 2025 16:00:24 +0800
Message-ID: <20251213080038.10917-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251213080038.10917-1-lance.yang@linux.dev>
References: <20251213080038.10917-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C06D1A000D
X-Stat-Signature: dwx1jrwo6u4ks7phri4c7cqkbc5a3rdm
X-HE-Tag: 1765612883-92164
X-HE-Meta: U2FsdGVkX18Db9JsR7PyJqAnzoQj6PW03tM0BcPPPNdAJg1MBgql53kdPR8E9A9/wuYeQnQQKWOSO8iwiohWn448Za6QDm9sgyGD0gZIHm4DINsYeOQOmgjSpsb8Yh211i/nNM5RYKxqw9dV5WX7nkayYnaffm328o1vQdRj+Ow4YnuElPh3ulNrgRw6yCf+hpktR3dHpuSxI7jl00lwMClKKBXHbEJ0qbfABXuW7iGuZE8xr4B2UQMIip3jFtLiGWN5kBDpsWdOYucqbmC4alU43qF9+Eb8ZgjSR9yLQlPZEHFttlqYX//xoqSQn7ARX19MWz3pw6siI/2QtHX/qbGRs66Pi7aTn6EamJG9RI6MeuYMpofhkbtqObN3RRz056Gwa3MscvhMGuWC4A19/+cOUIpNhrqfBZfL1JnKAVjeTng90LTL+GgKVKgnNTLaV/Ee6l6LpRU3sbljrNnqzh6i74fLcdoR2xn8FdViQ8RQd6GlQw8wqk1anecxruTiY1Wx4Gt83+YI9mtBxyB2jUBjhm5AofgloSuWooDJGPFDltWH6G67VI6W4UWMaAgQYfCy4x3Z+QTywPGHcxGveSkpRh8YGSh5WX6E5anTMCik8BhaQRM6wTxOibVHPmNdyvY1NPIgH8/UdgRgazDlrcxzP82iKF8Zuz9fZvONZhn2Am46/PfxKQazBhy2+UBF8781bBsCye9WHj1Uw8YgvkaetTXWiPjUNc+D6wd+606N1m3kjk+hv7N8iX4ETttRkZUaNAVSfhwR6zoHkw+OuLAyR16HWnV8WFTtpz7L4KrmKY0iZQAysGLE0ZZKl5DAdFaw2bLbpS9C2D8KzjZqlReG/DA93dIl2S84SVvZYZvtpidmFgYUs75C7fpt4yKgaJq1wVemeamMgsfxjAruvjpW0WGP8bCZ/HU+48wpwSRjlm5OKoVii+Eznw0lLksIsYSVGlb1bN6xTVUcl2E
 rb74E24b
 k4vsvbWrtCREJdAOJkVlupLpLhUTa7sfWz7jToidqvDos4xUA5Xuzo20/BN4MQnR/Pzm6W2T8pIyosLJK5FXjFvK7wmoZH9n4fS/RxTRuIur+5nPWsL29aqvl/23UTwq/Yulyu8tfWL8ISH5X82JKJXozjUi0kx2RhgrKiW95kcpQNxqujbmeZzpKEL69Z/stBHBLFHc8EIfLZszUyQSsH5tV7UsfjmvTFGbztg84+0r2CrUVwEBUKCxPg8lGBY1tcOykhkqS81Azt/vWhZVZdOh8RU7+tSX4KxksK+aFnqd/CbrcqzKOva4dPOZv8nJpRWub1C42KEcVFreVF+7e/FKb4VcE66PuO5VpCMOaV3Cw4dBh8dV/3Ekg+TtZxwGEI8wwXTWqFzghXUEzWxWhgwWLVJHLA1T4CLCNznhQIRJE36yxlRAvoXfT4fEnLQjMRQpjd7AjLTRDTAdn+MOy12iSXVpwrgAxk5TS0yBpBdH2mnH6YdN8BWd4YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Pass both freed_tables and unshared_tables to flush_tlb_mm_range() to
ensure lazy-TLB CPUs receive IPIs and flush their paging-structure caches:

	flush_tlb_mm_range(..., freed_tables || unshared_tables);

Implement tlb_table_flush_implies_ipi_broadcast() for x86: on native x86
without paravirt or INVLPGB, the TLB flush IPI already provides necessary
synchronization, allowing the second IPI to be skipped. For paravirt with
non-native flush_tlb_multi and for INVLPGB, conservatively keep both IPIs.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/include/asm/tlb.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..96602b7b7210 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,10 +5,24 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
+#include <asm/paravirt.h>
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+#ifdef CONFIG_PARAVIRT
+	/* Paravirt may use hypercalls that don't send real IPIs. */
+	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
+		return false;
+#endif
+	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
+}
 
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
@@ -20,7 +34,8 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
 }
 
 static inline void invlpg(unsigned long addr)
-- 
2.49.0


