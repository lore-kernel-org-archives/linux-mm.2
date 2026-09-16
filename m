Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEFEDC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7B86B0099; Wed, 16 Sep 2026 15:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067796B009B; Wed, 16 Sep 2026 15:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7FB6B009D; Wed, 16 Sep 2026 15:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBF946B0099
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:52:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58C40C0134
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:56 +0000 (UTC)
X-FDA: 85220673552.06.664E7BC
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7C0D54000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nj75s8lu;
	spf=pass (imf01.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789588374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UB1xIs73G2ms0/tfz/DuKTaMeA+G7EAXCR8u2pshxgY=;
	b=Bq1xUWbc+nIZrnu45kTaa9Sufb/KOzivriLt/jr/ads+2w+eVQBNtsqJUJbNWrgWSH5jwh
	AcEaCYdAD+8cWTPTgGVHFEN5JXJ1UDJ/lxmQeKS4Vsgq7otX2Dh0XrDy5RGCaXExBfr8q6
	/CYxBb5atxY9VuJUvu5qx94iW+F+vU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789588374;
	b=OPPWk7dBFU2hB0g0W+BdLkuEk6jt2xgm1/a6wg7xERxyFHb57aHkwa6fRrnven/xd1ULZm
	m4GCRjcVW8Jqw+X1DymiD/mcuMQgc8/XStpI6BR4QttX4BA1WkdEzPYiFzU0Fi2Zwqu3Qt
	mlbAaGSS8B2VTKBiWsumXy8aCl6HWs0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nj75s8lu;
	spf=pass (imf01.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NALIzAyd257Q9XRdPDmwZcj4GGaZ5ZdrW+pWs0t+wH0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789588373; v=1; x=1790193173;
 b=Nj75s8luQiePcDHUhOJVN9Qwz62YCYi2E1I9K+KT/omQ4z98CsRkHNkTZITIjTz8aEWqlFs+
 O7O62kfXqKOJ+1l8wMFWKaMGf3I5My20sua/6UBq41dTfUMoSeOQ09E8MB6bcrHh+tWvVuX+XRs
 +tjKKOyvgVnl9DlRU8gJSyBE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a2265ddc4010ca96;
	Wed, 16 Sep 2026 19:52:53 +0000
X-Mizu-Trace-ID: a2265ddc4010ca96
X-Migadu-Flow: FLOW_OUT
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3 5/5] x86/cpu: Don't transiently clear the boot CPU's capabilities
Date: Wed, 16 Sep 2026 12:52:03 -0700
Message-ID: <20260916195203.1099646-6-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nngsne547tqdwd7ho6hekotc1foguzk3
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C0D54000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1789588374-852889
X-HE-Meta: U2FsdGVkX19hlIn/y359HL36xduNT+uIJzxc7+9d7pDPo4ORZgJn9qnhnZvYGIYIJt5sarsAtCXCFgU4ytes1t/cpVSScUBF9WgE8bsw/jGc7F8ZO3E0VHfp1Jrq9ShjbsKNQggEm0gV2AQ3s+GhYK9NSKhHM0iKvy6fptRgOuTV7McqsIdL7m4onCe7RH9jotjj2mcaUwUbLSsyc8PwXRrSjCUtAQhFK0+iumc/EaTI6C6UvSF9n9ImhJC9SLjGez0OGFy6R19IUWPxXVmzTrPQkegrGAg+gygrn/vK7jzRd1enlUqoAxqJiY6E8sK8Fryo0f7wujn91BUvlV+iBTKJa8KPgQC3z1XCJRIyr5LjoFJNeQPXy0TfO28Y65T9og/wwLF06pUCsAzSqgKhLXX2yUsVZWy58fX9+xDhb+VqZjJnGiWHjov50cLOLK9kwmA2DvLyFSPjbHoUTcoFvMcAVn2JzQC6FVAMCNnDM2/4CSGVm5uZHSTNi8WGUyufV7gJ63/Ux937K3Hcrips50cuKxiSFGb3/vL4YwXekxDIgcwBIIBwPKj14P7ndv9lQ8htqxiEHyICGLCPadcZ2MS5ZDWOKe0hMivFysNL4xWu2Yxpra8iHIkGf4QtOHfHjPfLfN5DJaYNz0OsQBBBglNuXr/aY6O9WoZNlc8zOsIa3L47jdXAku9tHQUtq5/rDLWxWsIEyX42BX+V0uedzn63r1wDlK5G+mrB4IocAuvdSFmGD8BeGuQPFMrpas/SJkdiggNDacWe9evzfwgIZJmgRapDd+DPWyXEHvfPuC6iQhkoiWZoW9GEggpieOrwlYfH22+eIK+T/vIBjoLrOeROxm/WrGTDu1TrLoyr82H7zynygNYwogklLvHlpZR26hWMJ7OBOwAo6SZAu71x923/mwoeQn6SGJzfkFAELBdU9GfWUgAOz69ioDwFsWgpv8ubrAqBup0Nz95WPLY
 s4fZUqdd
 cjCBpDOeP1LzCBelhKxgdjALyPnQJT25xCd5VpEi9CFqf03yVec7zPWazZPSPEtd2q1eXZ8029JG7q0thCFaq3Ye7S3k6Xp5vRhq7TD24AI17KtwvfLro/ypJcPOIL/4l+1lu/wSzW1OwGzt5USRsp6eLdxcT9rzIADgP5cwti65L0WNCm6FLDSXfGFFRx1mWNGgekZxNq19A+F4STCixZDGeQ+zIU28LlGCpS0ZQWmxVg8UA0Z0wKDfz42tLuQ2UKfp8UXBrzuUuZ+zh0W80JnTGmOoWQT750UdWHw9C7at7RMNaCVFcLrPRwMPgPy+vGD8lXjWiiccS7fg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On the boot CPU identify_cpu() runs from arch_cpu_finalize_init(),
with interrupts enabled and before alternatives are patched. So
cpu_feature_enabled() still evaluates against boot_cpu_data.

identify_cpu() rebuilds c->x86_capability from scratch: the reset
zeroes the array and the CPUID rescan fills it in again. An interrupt
delivered in that window finds X86_FEATURE_LA57 clear in
boot_cpu_data, so pgtable_l5_enabled() is false and KASAN checks a
5-level address against the 4-level addressability limit. The result
is a bogus "wild-memory-access" report, and under kasan_multi_shot a
report storm that wedges the boot.

The boot CPU has already been scanned by early_identify_cpu(), with
interrupts disabled, and its capabilities cannot have changed
since. Reset only the CPUs which have not been scanned yet.

The window is as old as identify_cpu() rebuilding the capabilities.
Commit 39b9552281ab ("x86/mm: Optimize boot-time paging mode switching
cost") merely let KASAN notice it by making pgtable_l5_enabled() read
the feature bit. So no Fixes: tag.

Closes: https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 83d613d07997..496ffe429496 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1998,8 +1998,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 
 	c->loops_per_jiffy = loops_per_jiffy;
 
-	init_cpu_info(c);
-
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
@@ -2184,6 +2182,7 @@ void identify_secondary_cpu(unsigned int cpu)
 		*c = boot_cpu_data;
 	c->cpu_index = cpu;
 
+	init_cpu_info(c);
 	identify_cpu(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
-- 
2.55.0


