Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36366FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F386B6B00AA; Mon, 27 Apr 2026 08:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2AC6B00AC; Mon, 27 Apr 2026 08:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD92B6B00AF; Mon, 27 Apr 2026 08:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C57016B00AA
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:04:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 574CB1C0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:10 +0000 (UTC)
X-FDA: 84704202660.27.4819717
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 53D7D20013
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Miik+htN;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777291448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ge+gLOghAHu+0FzCbaZCe2wrIYxRBjK2+0E6CvN8qo=;
	b=tdrItqYmz6JKD9OEsL0ZV9QqGvxmw2ppfRP8ek6mldadFqwSTFyMGtlxd3nJXpVfjRC463
	G1nUMV810B/X4PZhGnZbr4hV48h/vDa4rH7ZQ+bMPOv6kceS6f+xoN7tsAxvgJTljpUTqe
	IMYaCe6nIu1joSsep1W4G3De6Ul0LAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777291448; a=rsa-sha256;
	cv=none;
	b=5SvnVGv8JmoeKKHgeoGiyeiXAevgdAbdxYaPoA5rxyXuLLyNx2NnBnqaUASNs7I5wwNOjk
	wpfNvqZE8QXbJoWCOQiCJF6k29GXNdmZBi8IZAYY2W4e6wQPF8J+RhzNuceO8VQpXBbimx
	s7q0Bamy3yc5BaS80qaF4j++VzvoTFk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Miik+htN;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 023032437;
	Mon, 27 Apr 2026 05:04:02 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA85A3F62B;
	Mon, 27 Apr 2026 05:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777291447; bh=ldcRjHyX3ikGZr7TkP8sF4TKynkn1s47t2JOAAGYL7E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Miik+htNqUHD8vM0xx8JqEjpijJJ/3fmWSdcOzhiUxUJX8LFyjsOuhSbRJ6QTtLCF
	 x98ojX4IXXUjskp5T8b8iUrxWEOkFCf6JjJnIoySQSzjTKSt/V1TDI4v64H/FLFMrg
	 9YAfKQxrgNv/njWtR81B9dfN559OxTMw8e1GvVXQ=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 27 Apr 2026 13:03:36 +0100
Subject: [PATCH v2 4/5] kselftest/arm64: Move/add POE helpers to
 test_signals_utils.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-poe_signal-v2-4-2bd9d6f16ab4@arm.com>
References: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
In-Reply-To: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777291437; l=2017;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=ldcRjHyX3ikGZr7TkP8sF4TKynkn1s47t2JOAAGYL7E=;
 b=r24fR4zGfLVsqC3/BUO4grJOZYk9vXPaWiQGFFkqbpPG0E3bWUZYasLlLJnROsUstdfZcv6rz
 l5q3dEkmPbMB4V4cqfkWkRZN/jzikVM6ShcRdFYHENfVT5ULyQjmCrh
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 53D7D20013
X-Stat-Signature: 9rqt5xxfnsurcp1wxtfyhsc43d7gu3id
X-Rspam-User: 
X-HE-Tag: 1777291448-947301
X-HE-Meta: U2FsdGVkX1+E0dTAGF0EPkavotENLGN8N+yXMK0eAShmlE4vGTv6ImFezrlN5FyFw3bo2KHVpNvjdIbeedbfRKF+taaNHFRfoMxT9nim0UMmWyjT8xb5QkPgnU9bV8T+d84A+59QZgUB3Pc5J3E2Xk8CMMVa+ZR/TL3QKal53eJv/Y230q7G2mNve1iCw4MGAn7k0HLwqp0aClxsA7NSaKIoul2JZ98gASzOQWNdVP7EFXSCLczN8QOm6YeHNIrF6JqQud1SBEmhuaMd/0YThNQwyacsLuTQNiYb4Y76mbRVC4gKqKR3N9Hy4BmItIXKHCRE2jNOUYUmkOwGpHUuDTBCOdmTLRHlZu9qZFo5OrWfdoWoyC0qUCN0SIsjXFmYPxPo8xtNfKuF/QaQOsj+pRP7vCy9nW9ng1CtDwGl8resIn/vxG8wQ1FwHrr0RaaJZUkji2RBjtDSE+5C9kus9KSpztJq/dXWNaSJSdJxWDx0kOTHYgcS7pAuxSj0AKxgamlccX99PdHoriyUTbcUfXtNo/0/YsIISx/2ZERtwWIH/h6p+2QHBI/zsBfoDtwjcC0mrpl8ybUav3Fod/USMd/l0wv8nm/qCNPmhylL7d/5wTNpDH62iRCV9qWjqXvsiBUoI54MAA1GZoNCNR5OTar4kG3BJ84phvOGewuBs4wvTZ4mUBzzGr59DLQL9/p46rx7oex9JArw7y0gjwVElyN41uJsA4RmYbb8uXg8h988SevzicnKPAgUY9tTQGawGYg1HAOU6SnlA6AYr2ZTLGhhnJlH6cOuzAOV5JeW6fiZsw6HpUl2vd9knD+W4VVyio2gBuLR0dj59r2Td2C7Kj1ItRAXMHJeD2SwlzohXklCj6ylGunZuJDh0blYRuktM4QQA+LjA8WgROfyh6XetXGUbcfXQMuYoR4MVjDM1H/LT8bJtGpZiNx4un/G571IgeG+lPJofnveFiVaNZ4
 7tcobLb8
 fefmLtGzQiEsZVEc08nyxhZXwyd+Tgh7iq01dsJGUgoem78iKHRebrXfX0w/bbMVzo41lREjuGCdWKWHEDsFxSmZaJkHCx9bJqJ+AVDv8AUQVZLtwtwDNFecCAOPuY1PhZDVGGsxZCdGhpDVr1PAyBnrGZXiCX3lQqIHkk88heG69qajErIfgXn3AQ5nuBBco32vsDAqI9Gz/oE+S5PetxfoSbZna1lZ+XYUiFj3G39qsB8F2vsM8/i4pBmKT0jV1vf/00Aj+wricJwwpiMNw372wpIX9L+Sqzy5y8kf1Ar9wCDIZPDZ08Rm2N9IEOnRTU3TJ9Sm7Ja5qaXI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation to adding further POE signal tests, move
get_por_el0() to test_signals_utils.h and add set_por_el0().

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 .../testing/selftests/arm64/signal/test_signals_utils.h  | 16 ++++++++++++++++
 .../selftests/arm64/signal/testcases/poe_siginfo.c       | 15 ---------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.h b/tools/testing/selftests/arm64/signal/test_signals_utils.h
index 36fc12b3cd60..2c7b8c64a35a 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.h
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.h
@@ -57,6 +57,22 @@ static inline __attribute__((always_inline)) uint64_t get_gcspr_el0(void)
 	return val;
 }
 
+#define SYS_POR_EL0 "S3_3_C10_C2_4"
+
+static inline uint64_t get_por_el0(void)
+{
+	uint64_t val;
+
+	asm volatile("mrs %0, " SYS_POR_EL0 "\n" : "=r"(val));
+
+	return val;
+}
+
+static inline void set_por_el0(uint64_t val)
+{
+	asm volatile("msr " SYS_POR_EL0 ", %0\n" :: "r"(val));
+}
+
 static inline bool feats_ok(struct tdescr *td)
 {
 	if (td->feats_incompatible & td->feats_supported)
diff --git a/tools/testing/selftests/arm64/signal/testcases/poe_siginfo.c b/tools/testing/selftests/arm64/signal/testcases/poe_siginfo.c
index 36bd9940ee05..e15fedf4da6e 100644
--- a/tools/testing/selftests/arm64/signal/testcases/poe_siginfo.c
+++ b/tools/testing/selftests/arm64/signal/testcases/poe_siginfo.c
@@ -21,21 +21,6 @@ static union {
 	char buf[1024 * 128];
 } context;
 
-#define SYS_POR_EL0 "S3_3_C10_C2_4"
-
-static uint64_t get_por_el0(void)
-{
-	uint64_t val;
-
-	asm volatile(
-		"mrs	%0, " SYS_POR_EL0 "\n"
-		: "=r"(val)
-		:
-		: );
-
-	return val;
-}
-
 int poe_present(struct tdescr *td, siginfo_t *si, ucontext_t *uc)
 {
 	struct _aarch64_ctx *head = GET_BUF_RESV_HEAD(context);

-- 
2.51.2


