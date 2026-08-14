Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1055C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35CA6B072F; Fri, 14 Aug 2026 19:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE986B0730; Fri, 14 Aug 2026 19:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAF76B0731; Fri, 14 Aug 2026 19:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 671B56B072F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:52:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D584EA02D2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:56 +0000 (UTC)
X-FDA: 85101527952.26.6FF3D7B
Received: from mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id 10E2916000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dRcRUfhS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.56 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786751575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vqNa0sKP84j8oQXBvpQc/I6E/ieKdBB0j7k8u1XHFw=;
	b=UcTyyRO0MrdM2VI0F7W9FvohddGf1ulopIFK8AZ/26xJ+znrmcu4OxDB1Y/SZy8hCTRqnh
	eLRjm/wKSiLpI5iIm5hstwQTiCgP9g82I5hXLmMNy64ysoT4WswgRlWVoirwDJGfhfavYS
	dkVE5bswL/WPbzx5S76eD4+oBsY8WqI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dRcRUfhS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.56 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786751575;
	b=MHWxnX9HgCFS5mOPv57D0elXJebBNjU3DZzG8nPhGf4V8VrnGC9pTkri6fdWfZtHyeIAwS
	QBrlzw58H8PHbrcyA+mgDuWbM1mRLLs7U0KFSGCwsl0ebuqbdlopaDz6Fp6PnzobxEFFRt
	fFTrFTeN5dt50P7LpijemRR14HpYc04=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rmmEfBECEg9NtxdBGrSrtO8BVoQ6tFM6eCk7zrNNAuM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786751573; v=1; x=1787356373;
 b=dRcRUfhSmeuiGbKwsWnWwzjZe0AKOikW5JjcBYeS4jYJKA4EKmnQiIx8tUNvL9Qty0cx+iyp
 MAo5sVhlWq0kCTPFw1KDqb/Hq+wmW2sTUbNLhvaE2/ZbiD1zFRn9a+WHAOp+//bIlJWBhK/aRQi
 UkNLcY4lPO1Q5/Wxo/JTyKGY=
X-Envelope-To: linux-mm@kvack.org
Received: from isolodrai-fedora-MJ0FVMD1.thefacebook.com (2620:10d:c090:500::4:b8fe)
	by mta10.migadu.com with ESMTPS id 42315a227e488f5c;
	Fri, 14 Aug 2026 23:52:53 +0000
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
Subject: [PATCH v2 5/5] x86/cpu: Don't transiently clear the boot CPU's capabilities
Date: Fri, 14 Aug 2026 16:51:34 -0700
Message-ID: <20260814235134.3461435-6-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8bhiamyumktsasxar4x8ti8c5pqobe4f
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10E2916000A
X-HE-Tag: 1786751574-408440
X-HE-Meta: U2FsdGVkX1/8YbIw7rYfkV5mUkKQaiWWr8ZbJHWDss8GLdhxFlLFqE26xggixUNSoD9yFv6ne/mOtpAaOZQmgGfCnJ95Wc0I0FBq2G8pXynBDQmG1TfCFxj8xmYFMk1QhdEGUQDA3BoKJ3wT5xFAb/s8wm875ODjtw8NxTwGHjMskT4apktIa9Ul9YujaVRBLlNH9H0irAsa6ZnfLIMG07Y/Didq+HulxZNhsSq9QCMn9w1GQnErgDP+b+WnbruoDublYhCAuN8TDkywpNxHlVB+aLjFjUx2YJ1eC1JRAjfLt//kOmyzKUHZz3dPkcwwxbAzCk0UEd+Be0GRXDRm+PbVZ+/sK2FwxOcYfesVWW0a/kCKOaQ9YnUcitjIwByUrva/ybLhxhRQETfK5eGdAkj55DPuoCDzk+5nT2QIUq/JzWgreOEZvSaq3Lk+bVWO26241L0SjOu+UO3AdzevTlBN/lDS0XJugQaVkjzDvzqCXHwq+1LRRqMQiBkxtjV2/td3e/x49ISXhJWXC2OyDBRcd4NsPm3n5QIjUhjgRFcrTbVHn3U7u+mlboLuwwEbRSGIjb+2NJgtPSNmyMWE8jnrSpksWPG2wuFfK5dKcMfmjxbYoetiUiG+lD8l66SCXDe35/CyebiVUfzccXE4WnodsjMB1w1HXQjhZVLB2yl1NHChqDqH12U2WoIC+KyodMAFUn98DccZ1DDc9tS9M9mUV5Qpa8fV7p2ooBanTEodWpwflsVW0lvpC1wZwhzkbu6WISga++B3qjD7Tkr+HYnT3BTvFa0BgjWR3X+QTvk+JQItfZsAtV/BmU715PT2PUBXJT7q7zx2FOIIGifAQPLvxkgsCQRdFqBxRv/dMULKuCwe6RtRCso3NNjyWomp74Sr0ieZHvzvk6MinPkeISukCbEu0034kA6FqGLrSvvUqJaDiSweJqlxkoQG1nV4vLTgdl41CqpSGs3HIVI
 0fUWyIEl
 JWwPsfGQs2dytg7xGKZlyV+7sCFBCGVTV/xA4ph+rj/fJ6/DjKPqt1ELGW99OLtuohguef/4+/5aHfMxYTbXjUB+3m4IBTgC5ROoMn3NZ801aSNscrxCuOKVjDgLF0GVxai0ZKlexSHzjcDvjLbVkRSyCznQN8xgYpNy1HiL2fn5Vu9q2bRB8yy7iEtUTq4+whOpcGfxo68PYyNfGQC2yJnHojiNsKD7A9azwQGU/XyGrQ8I3kjrYY51zwwZ0iHAc4P+CR8bBRoXyBJMH9lddPRH2wD0aF7rjZcbJBRuNqbEfkZThJWTl993nWAH8lHPZGGdMuCrg8HhzUGw=
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

32-bit gets the same treatment: the window is the same, and any
feature bit evaluated from interrupt context while it is open reads as
clear. Its no-CPUID cpuid_level default now comes from
early_identify_cpu(), and nothing writes cpuid_level again unless
CPUID is there to be read.

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
index 671a430994ca..e0c70a2510af 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1988,8 +1988,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 
 	c->loops_per_jiffy = loops_per_jiffy;
 
-	init_cpu_info(c);
-
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
@@ -2174,6 +2172,7 @@ void identify_secondary_cpu(unsigned int cpu)
 		*c = boot_cpu_data;
 	c->cpu_index = cpu;
 
+	init_cpu_info(c);
 	identify_cpu(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
-- 
2.55.0


