Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740E0CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E778E00F1; Wed, 29 Oct 2025 16:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6248E00B2; Wed, 29 Oct 2025 16:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723FB8E00F1; Wed, 29 Oct 2025 16:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60BEF8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:10:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F18312B43D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:10:36 +0000 (UTC)
X-FDA: 84052244472.22.1C54324
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34E96140008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:10:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=IAf8Yf83;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2a1Kw0sC3CsXwE/Uet1J3QooijcrYchVxhPMvMQoO4=;
	b=778KmECnsxhHyp4taNbYBFZ9zdfsyRXTUo9IH1IJCMNOApVHHMtPSvLzF1fnyVRAKEJ7va
	hWAghJ2zu3fQAND3Ngueuf6MGceQ3tzk/zNjGG5MghMnV9OPgowLfkROc3rKVICtEWDvmP
	JJ9p8mT5khIBZpTibNjQB9dvJGjappE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768634; a=rsa-sha256;
	cv=none;
	b=j6Sd2RzF3boPYWdUfX51yR7ibjMsgZxyICZgYroWhxDi3WwGRs+cphCWCqjdDjju9zYSmw
	A9udkSGBgTZ5/BpOxlp/RREUSTpyhn+ODOLRfrrIsxlwUdPXt01PcJc4hWbg4RDj0TPAsX
	8xtvEdf2wea2wj4X7Xfi6i3PnB8uaK8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=IAf8Yf83;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761768631; x=1762027831;
	bh=S2a1Kw0sC3CsXwE/Uet1J3QooijcrYchVxhPMvMQoO4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=IAf8Yf83jJpokLTSbKrc6oZO27DAaw7BQUnE7WCUryg0gLluEitf1I28vmC/H7oml
	 bjw+r/ilmQ+FUR4ZrZ/gaUrnBytCchvTJWpL3VZOkGgYjmYKURcbqbQHdnYxCYWLeN
	 9re+mOvg0PqgLR5FpUhW6rfiKnYi8Ry2ssLz3XCsOgvkpInMaxWEe+dOpc18CRsWgk
	 4N4hCGNQG4AJ6xEXdQIaI+pniq8mMD2ntUxxe+DxtFOWAvmeACobKS5Nqb1DTw+C6x
	 xOus8MYRr0WlJflGSWspRnnlWmjeV4ZsSgXO8DpPRXLVZTHll8Qu+wV7nOCuGbYgBC
	 QQZoRZPiCqMqQ==
Date: Wed, 29 Oct 2025 20:10:26 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 16/18] arm64: Unify software tag-based KASAN inline recovery path
Message-ID: <0a21096d806eafa679798b9844ec33bf8a5499a4.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: ab91b91b5b8eb35edef4ae212700531bcd4f5e1b
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: oz1q8m85rinu4cr3hrrf8b95we1jctzs
X-Rspam-User: 
X-Rspamd-Queue-Id: 34E96140008
X-HE-Tag: 1761768633-586084
X-HE-Meta: U2FsdGVkX1/cSnhy9hfWYY9dv3tN8BVMmyttmbkuGCTAztcuEMGTtkv4Tbwla01nLHqRytCh/J33YlOsWqiis0eNP+3bADD4WQjW5/uRoIPIvngEmn21O2B2TxIDiyvq997BiIhIITuoTcDmDtzcoCVNt4MMB3PyZBNFqxza1z34wWQENWB/ZTRllGoJqbH3YHdHijHXFtxGQ3itqYNREWs3P43KMrwCd3wNtPYGq/+7I7kTq6pciTxhey4eR5uuAZ3F3S+VwvMJcMIt7R1b9rjY/4DtkW8tjvZ77oPi1zkrWvMIUNBDtn7cmJnQrU0rNwi98yqT07tp7JK94aI4n0o90AhzZCSJJS2Ic6gHjIQnHFOAziEXf1ZjGfFhc0IXnyHoNh5usUeGpdKBFCRzV/VMfUn/fhkA0e+v0XB6KeGB180/bD/8domAOsVGm0fh28kdUDv6Ci4UfZJtFjWcfgwPB108qqSlrzINAfwKhnB1yvC6aRDYF1D9oELIwqrn7XiBR5Uh1r+Q5ftP0qf5VNMVPm/8jxgmIFfj5C+Vdp5HaUaiYZtLa8Ip2Xa3kNGqOiAVkO3mDijFaQ2A5SHrOLlf2z7H+mszl+RnkSxB4etK+hbHNFaJ2HtCG6LcuXJ9tqIRaBuaVIu3iZE4ffiervs46IFbX0GN83IRGgTdRilfLfVLkjOxP9nSGDpc7p9+rXUZPJV4UdU8HkJ+Mw1Z6TwpNAKUDtk9/XFDD5rEHT0c+TRws/a48CLllxq14E8N6JX/yUTriGGgtemDtVIT0W9WF/2N/x8Q7x4ub+1qk/ecuuOLWk2I1TEFhL9R5j6R/dhzIjTa3mNeL5+g8gLVOV7U/T5H8VyTiNMzUgCehZXkplZLTLjddcQyEJcfuMnrQ8vrnWJf+IaMjjPKZJe98KIX9+fqwWhhBCtA6NbKHE3IZKY9bZ6rWx5vxhySQw7CV4QuxnTcKOY2YJ2Sqgv
 JMBhwG4Z
 XBI03EXHi3z9XYp/qC2Cpc45a2j7d1ZHlIuEvrubsPVDlvbOct8bHKfr3R5pHoLZN2wQsJb4UcjZNvgCT9OLvZZBAWZyWce7TuK/Ckn99ilqkU7Of7x1w6tAB9YgK7M1A0a7AmYjWW/AE//P6OptAgGgoAo1WFtfVCM4BPfN8HVzBdiCj6o1eWcYMbf1PM81U7M7A8t8e6RSa6DvrO2vOMpSy8EXyiXm15f9JJgSdBS4mT8RamwaxCKHq0uoC7+1gWxO+piQ+TOduXfoKt0Y+SF55x8oLB8b2NIbkll3d8ZjP1EK8bToKA3fxik5vdVfxkUwGl3Md+lHYoCWH6E8zoLzi9Tgn0fSsrNA0jOWSkKR+F7DQqGZxph2goQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

To avoid having a copy of a long comment explaining the intricacies of
the inline KASAN recovery system and issues for every architecture that
uses the software tag-based mode, a unified kasan_die_unless_recover()
function was added.

Use kasan_die_unless_recover() in the kasan brk handler to cleanup the
long comment, that's kept in the non-arch KASAN code.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
Changelog v6:
- Add Catalin's Acked-by tag.

Changelog v5:
- Split arm64 portion of patch 13/18 into this one. (Peter Zijlstra)

 arch/arm64/kernel/traps.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 681939ef5d16..b1efc11c3b5a 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1071,22 +1071,7 @@ int kasan_brk_handler(struct pt_regs *regs, unsigned=
 long esr)
=20
 =09kasan_report(addr, size, write, pc);
=20
-=09/*
-=09 * The instrumentation allows to control whether we can proceed after
-=09 * a crash was detected. This is done by passing the -recover flag to
-=09 * the compiler. Disabling recovery allows to generate more compact
-=09 * code.
-=09 *
-=09 * Unfortunately disabling recovery doesn't work for the kernel right
-=09 * now. KASAN reporting is disabled in some contexts (for example when
-=09 * the allocator accesses slab object metadata; this is controlled by
-=09 * current->kasan_depth). All these accesses are detected by the tool,
-=09 * even though the reports for them are not printed.
-=09 *
-=09 * This is something that might be fixed at some point in the future.
-=09 */
-=09if (!recover)
-=09=09die("Oops - KASAN", regs, esr);
+=09kasan_die_unless_recover(recover, "Oops - KASAN", regs, esr, die);
=20
 =09/* If thread survives, skip over the brk instruction and continue: */
 =09arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
--=20
2.51.0



