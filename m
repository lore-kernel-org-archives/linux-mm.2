Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A633CFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696846B0008; Fri, 21 Nov 2025 13:55:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D336B0012; Fri, 21 Nov 2025 13:55:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5111D6B0029; Fri, 21 Nov 2025 13:55:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 306A96B0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D71BDC06C8
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:44 +0000 (UTC)
X-FDA: 84135518208.28.D506B5A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 548F710000B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=NA5z7vlf;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFtNXw38IE3HRdDCdMoM1V9qz9lJ/AVCWnMaz6ZoLPI=;
	b=eqv5WZ/5Ndl/QzxfX4dZ17k3IXUFxHxOyPvj2X26MLcrVoneA6faAaUwYaRLVNMeuy41pQ
	3mnVhW1zOUNp7THeMBwcPc1QRmA0arSkWdLL6q/Bo6OzMFIw1Lhs3QgYDNrEm5SAbSwhuw
	dl8tugr2d9CRIBvOTLD4NfwyOXYml7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751343; a=rsa-sha256;
	cv=none;
	b=zeAFQWGERt+3VX1WBg6uBgFpqE/TA4BGt659cCugmz095Fv8KtFjTTw6IVLRhb0/stABUd
	icFv35vktYTQXOwB6C7hA0Nq6iIdGNxrLAnuwudI2h+qWwECoLkaxYPnu9FN5cLDZhxKQZ
	UlwT3jx28L7WZk2SsgN3pdFQstEVEJo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=NA5z7vlf;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lFtNXw38IE3HRdDCdMoM1V9qz9lJ/AVCWnMaz6ZoLPI=; b=NA5z7vlf/bsATWv9tvXtLCcgfw
	hYmnIk5IUs5Qp+EEs8zNJYhVYqbJ9TX6F636UFk538EEkuW5qkDhjdlOJM+azQhNl4bErHZSVkjrN
	9wHW3G2j/+HK0EJDL/QvzmF7ePEkA2/Al318LvauERbHC5bwkqcmZjqVMzdYx30UWHD4ugIzx8mNP
	BIkUitADajkzZO4JShqJ/hESdl/dT8351dE/iqrnUgI/wYCCVzwTslNYZir/HptpGijk/xuAHu8z7
	cuj0LFaDzVL3oWXMLuWdVeloAVxeYZkex0xulc4I9sCvyZ6Id6m8x3N2lHdH4oyKaOeqo1piZWmzK
	Bgpr4WvQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-1keH;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de,
	Rik van Riel <riel@fb.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC v5 6/8] x86/mm: use RAR for kernel TLB flushes
Date: Fri, 21 Nov 2025 13:54:27 -0500
Message-ID: <20251121185530.21876-7-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121185530.21876-1-riel@surriel.com>
References: <20251121185530.21876-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7dw6qh7p4xq5dzneary9ydhzqgkspkjd
X-Rspam-User: 
X-Rspamd-Queue-Id: 548F710000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763751343-819583
X-HE-Meta: U2FsdGVkX19Nf6wNrrz4Ej2C2XQIgS9QxAbm9BD28Do+eg9LJXkRYIgLMRC7Gg5oo4OrbPkezW2rHBiIyS9H+IYaxGihHraoH4qyCRivB7jgtCn92AJ0/bidwa1IkaUpsZjKVINXmEorKU5FlxSURCBEL6LA7QgdmkNFZ3lVfz9E7aR1QpyWtPMMms3LS95EywG1Eefx7iQ9dL4UJxcaxHpeP8Q7eQOWRwcljo46JviZj4qxAWVeJ1DNOqEqCoRuCkOpeIUVYSLMV7/zA9QXvhkkB79cI47XGlT8+XqGDwP9zw7+7PC8gyfHCMtSCIKygik6psHaLx814ui1HWKwzbZLG0kT9YnlmLpG61FfVLXuxB9nX6jXQLSUv6xvCTdSglHMw67ORA9fIW261AYxA5cA723lYOZK6RWHkPNzU8QszBgPvbFj8Fr3xqV0ph6CJbST2i3UASAUTetU4HM3bA+yCAUOnmIyKNWOXjQ9Izpt9++GHXXUfMNUjxsUEdCnLbaWo3zeCeJQZc7oNjIFWUk2EvWSed9ePPVZwLR66kr2kQ9kIjuDWK6REsQikQ+ksIONUk6PGkmapWHbR6DgmrKEOJ0gp4ubVmGrCwfEJWhx1EJxgtbjXbQtXvWn0gwHtgKS6ExjoRrbQtn30vb2J0SyFjvPu+McXhO120bNM/wGIQ7zJOXQsJ811xidUqNiZlaW0u3HWuV8iCbtp96qMQGhF+l2ApQdqfmz2N9WTb/08O8Qr2xbz0l05HlZOUWMsJVhaH7cJcAInva8uooguMlLbf/+EBaMvWolWDKGy4Ul5Pqk7Esk7yBNZoxbXUh4XKWyuU57fAQ5VgQC2YgMQcTLajrfMI0FWK986edkGSGHPVPVd83FfeQlPvd7VPNFXI27ZgrBBP3/zoNKgoW1r92TTNkpkO0Bh+ls7eQAUZmjst4tJAh1Hnb+b94BQ2rT0DVNr/dOaRUGLGfw8wr
 hhXEiS3m
 YU1XqK//T2f4gWj4aGu7dz86Hv1QXj0x09bOiNOcrtDdqZiYhQY2oE9UwJaCjp2IN8ZY3ttu5wBiqVmjcp1L3Dz5A4UVpMhHk2Cyf1yNlONBtCWkIiJZzHZTcCR/KU0zAtZyjZ8LgYxjAn6M4Co8RMiRFC47RM9i/jK6X+q9fdJ4MOnxHVQ0+pMEsG9JSUudw4+J9gWS9XP0aKObZRj49O6C3qljKx+ClKEAT03IDcemvzAoevV22Ya2IZTga+/bzOHXMZwzVkMkeNNSkhwHWJVKsK7EGKBiYo7S/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@fb.com>

Use Intel RAR for kernel TLB flushes, when enabled.

Pass in PCID 0 to smp_call_rar_many() to flush the specified addresses,
regardless of which PCID they might be cached under in any destination CPU.

Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/mm/tlb.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index f5b93e01e347..19c28386d8de 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -22,6 +22,7 @@
 #include <asm/apic.h>
 #include <asm/msr.h>
 #include <asm/perf_event.h>
+#include <asm/rar.h>
 #include <asm/tlb.h>
 
 #include "mm_internal.h"
@@ -1489,6 +1490,17 @@ static void do_flush_tlb_all(void *info)
 	__flush_tlb_all();
 }
 
+static void rar_full_flush(const cpumask_t *cpumask)
+{
+	guard(preempt)();
+	smp_call_rar_many(cpumask, 0, 0, TLB_FLUSH_ALL);
+}
+
+static void rar_flush_all(void)
+{
+	rar_full_flush(cpu_online_mask);
+}
+
 void flush_tlb_all(void)
 {
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
@@ -1496,6 +1508,8 @@ void flush_tlb_all(void)
 	/* First try (faster) hardware-assisted TLB invalidation. */
 	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
 		invlpgb_flush_all();
+	else if (cpu_feature_enabled(X86_FEATURE_RAR))
+		rar_flush_all();
 	else
 		/* Fall back to the IPI-based invalidation. */
 		on_each_cpu(do_flush_tlb_all, NULL, 1);
@@ -1525,15 +1539,35 @@ static void do_kernel_range_flush(void *info)
 	struct flush_tlb_info *f = info;
 	unsigned long addr;
 
+	/*
+	 * With PTI kernel TLB entries in all PCIDs need to be flushed.
+	 * With RAR the PCID space becomes so large, we might as well flush it all.
+	 *
+	 * Either of the two by itself works with targeted flushes.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_RAR) &&
+	    cpu_feature_enabled(X86_FEATURE_PTI)) {
+		invpcid_flush_all();
+		return;
+	}
+
 	/* flush range by one by one 'invlpg' */
 	for (addr = f->start; addr < f->end; addr += PAGE_SIZE)
 		flush_tlb_one_kernel(addr);
 }
 
+static void rar_kernel_range_flush(struct flush_tlb_info *info)
+{
+	guard(preempt)();
+	smp_call_rar_many(cpu_online_mask, 0, info->start, info->end);
+}
+
 static void kernel_tlb_flush_all(struct flush_tlb_info *info)
 {
 	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
 		invlpgb_flush_all();
+	else if (cpu_feature_enabled(X86_FEATURE_RAR))
+		rar_flush_all();
 	else
 		on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
@@ -1542,6 +1576,8 @@ static void kernel_tlb_flush_range(struct flush_tlb_info *info)
 {
 	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
 		invlpgb_kernel_range_flush(info);
+	else if (cpu_feature_enabled(X86_FEATURE_RAR))
+		rar_kernel_range_flush(info);
 	else
 		on_each_cpu(do_kernel_range_flush, info, 1);
 }
-- 
2.51.1


