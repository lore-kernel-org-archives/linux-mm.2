Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A79CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 11:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBC28E0008; Wed,  5 Nov 2025 06:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493878E0003; Wed,  5 Nov 2025 06:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFE18E0008; Wed,  5 Nov 2025 06:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9128E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:08:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD87C5801B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:08:50 +0000 (UTC)
X-FDA: 84076280820.11.CE27BAB
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id AB9CAC000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:08:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf28.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762340929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=uvCZqOBPO+pd4k0mUTUYJ8u93KUSdsRxLeSdDownsWc=;
	b=saWsWWOl+Z+I3huAi7bIuLrmkUmorlB48+YG/XZmuX01oqfuvWCToQVdbYckNPjCOvFs4l
	XgLHbsyZeJTZNvKIDskwJvi3BoZ2INpVa82r+BAmG2583sd9LBu0fyJ1zgfQKc/L4upgsG
	cjhQzVI89ehwDfSh9kmH9XLXudMlYXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762340929; a=rsa-sha256;
	cv=none;
	b=ahFX72Smsec52c0zHSIx0uZfVVTfltpehcTuU+Du7OoqehA9odXUJBwihJ4eZRdCo2CzJZ
	+jrtK0JVRerY5m/wMFPRa/QR77uP0gypXijk31q9s9ABpo0CKDbfI4al8MQ7Bzi5/UwlZZ
	WIz3jppdiK6bTKQ47HnyDNxZNGdFhrI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf28.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4d1jHd2Y2rz9sSf;
	Wed,  5 Nov 2025 12:08:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y4uEqxYbuSVd; Wed,  5 Nov 2025 12:08:45 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4d1jHd1Pgxz9sSb;
	Wed,  5 Nov 2025 12:08:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 1E3F68B76E;
	Wed,  5 Nov 2025 12:08:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id x-YBUja5U7Aw; Wed,  5 Nov 2025 12:08:45 +0100 (CET)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 76C418B76D;
	Wed,  5 Nov 2025 12:08:44 +0100 (CET)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Arnd Bergmann <arnd@arndb.de>,
	linux-arch@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Peter Xu <peterx@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH RESEND v2] asm-generic: Remove pud_user() from pgtable-nopmd.h
Date: Wed,  5 Nov 2025 12:08:07 +0100
Message-ID: <ae329757996213171c92495e4e4ad698c24f9d42.1762340395.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2987; i=christophe.leroy@csgroup.eu; h=from:subject:message-id; bh=TapBhVgQzm2A+wV0+EICT9kNVYEysKeqSw5mgwHSFA8=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWRyG4hv2mLy/4if7bKly48+d1CtzVdk/3JzVc7i9B/9/ QJPa2dEdZSyMIhxMciKKbIc/8+9a0bXl9T8qbv0YeawMoEMYeDiFICJMJxgZOhZ2VexMVfobuPp 3m1vTzlHujFxKxYs5V94XuDiBfNXNfkM/3S3n/334qvct9N2J/xrHmnNLT7BpmYSlZAhsGuH0ZE 7yhwA
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Stat-Signature: canznn4au7tdyenkqdg1mkfqm7t8nujy
X-Rspam-User: 
X-Rspamd-Queue-Id: AB9CAC000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1762340928-1456
X-HE-Meta: U2FsdGVkX1/b9j7iqyuNJ62kEN5lzg16Cyh0C/TkJp/865yxhUsynwbiRHbwMVZ0X2pCvomhvd0PYim0SP4hfIpK+rrVT3j+DAxE9aevfy61y7Gu4E6jsxitUgwAZ/leHWm1qCq0xi7pWHvRGhV0bDXOMB9024H3p8jiUc9nIw28T/NNu1LGJ1tW19htbxAY8af2dDBQi4pibUCwShb/YGOVbMIAKqwbsEntTTDAHA/iBXqJQmKjkmN6CnKbtgW2bJQaz4wLOd8gKxt7HRaW2UpS0nMkUEEwhUGgi+qSoyqd/1uR3WERLluLk8+ARF2ZG66VJLgBfSo0DYx6OzU40ez3/+dc4XTj5Wdc11v5ErADxbOW57k8l19v7QfzdJPGA8A/JTTCsjiDLBLAFNifyIV353W/t04N4ra7M+2mg6vVaMXlYD5hkzaJS9h6Or6rJLNKxm2xDPS9lpqdDnx3XkwdfkvtaccsxDIIyO6/vK1+TxAq6ICtRV7MnVjkmSLW9vgSz37GN00Ba8yXgtTgafo5nIvRVAS+YiR28ZYF8UOQptM/1m73BVFmuQQh9qwFmBvAXmqHEeCk/Qpme7W5rrOAZ10skOXo7JUEnyehUU6iJhWPQ/l+oPpkJBWgeZhcdLo3Td5oNKVpTQEhvnUaoYaPdwH0TsMKVmWZsYX35qjMnrbhCAfTRWFI+Tugg9hdWBTXhvXf6NAgXhN6LOiuYLX0ichifdVHuh1ch2BHkNeS9ODuaUvkmmd/p77TPkAf9vUKfKfL1nJqtFv/7NS02nECA13K+b26IcLlzclx+/R3+wBiJi8Pn19Q76AAHbqOqCFsubqZFhdZj4jFYiZqqcrsBRhONLrFH+zxJqxL2AR7pxdEAlA1HkepuEAIS/4rQLfK/AwnqQ8TaECspNyOXHVvxcyDJEYK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2c8a81dc0cc5 ("riscv/mm: fix two page table check related
issues") added pud_user() in include/asm-generic/pgtable-nopmd.h

But pud_user() only exists on ARM64 and RISCV and is not expected
by any part of MM.

Add the missing definition in arch/riscv/include/asm/pgtable-32.h
and remove it from asm-generic/pgtable-nopmd.h

A stub pud_user() is also required for ARM64 after
commit ed928a3402d8 ("arm64/mm: fix page table check compile
error for CONFIG_PGTABLE_LEVELS=2")

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # riscv
---
Resend of https://lore.kernel.org/all/c2c9fc69871a7caaa205e237ff73557f19f5e176.1755509286.git.christophe.leroy@csgroup.eu/

I was expecting Arnd to take this patch as it is on asm-generic, but maybe Andrew should take it as it is linked to mmu management ?

v2: Change ARM64 pud_user macro to pud_user(pud)
---
 arch/arm64/include/asm/pgtable.h    | 1 +
 arch/riscv/include/asm/pgtable-32.h | 5 +++++
 include/asm-generic/pgtable-nopmd.h | 1 -
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index aa89c2e67ebc8..256ce4a6162e9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -960,6 +960,7 @@ static inline pmd_t *pud_pgtable(pud_t pud)
 
 #define pud_valid(pud)		false
 #define pud_page_paddr(pud)	({ BUILD_BUG(); 0; })
+#define pud_user(pud)		false /* Always 0 with folding */
 #define pud_user_exec(pud)	pud_user(pud) /* Always 0 with folding */
 
 /* Match pmd_offset folding in <asm/generic/pgtable-nopmd.h> */
diff --git a/arch/riscv/include/asm/pgtable-32.h b/arch/riscv/include/asm/pgtable-32.h
index 00f3369570a83..37878ef374668 100644
--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -36,4 +36,9 @@
 static const __maybe_unused int pgtable_l4_enabled;
 static const __maybe_unused int pgtable_l5_enabled;
 
+static inline int pud_user(pud_t pud)
+{
+	return 0;
+}
+
 #endif /* _ASM_RISCV_PGTABLE_32_H */
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 8ffd64e7a24cb..b01349a312fa7 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -30,7 +30,6 @@ typedef struct { pud_t pud; } pmd_t;
 static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
-static inline int pud_user(pud_t pud)		{ return 0; }
 static inline int pud_leaf(pud_t pud)		{ return 0; }
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
-- 
2.49.0


