Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F14CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2A58E00EE; Wed, 29 Oct 2025 16:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A531B8E00B2; Wed, 29 Oct 2025 16:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9462D8E00EE; Wed, 29 Oct 2025 16:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 787E78E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:08:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EDA45BBC8
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:08:56 +0000 (UTC)
X-FDA: 84052240272.24.ADCF423
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C53FC0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:08:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=f2ixPvRO;
	spf=pass (imf22.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vFEd2i7cGwKfB76083zqMnaJRzsau0IVtzvsF2hHkA=;
	b=IIIxFKB/ctHUDA4A6EWXNdl0MDBPVGASSVlJuzeraY0QfuK2ikMxJ7lmlVCnHl1qIytOGe
	j2R4U1sNVaw0f5Zqoy0nBtdDrZEHgP3OEJcQDAShZAUyOMioKC6yLcYEgJvo4qyN6TOTra
	fZER9B5y1rjUmVSqY/fMj0v62i+vM9w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=f2ixPvRO;
	spf=pass (imf22.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768534; a=rsa-sha256;
	cv=none;
	b=SzStXeZXBNhygwQaRCpGDlL8H7sid8nDgOPQ896/tguMuKqjGOpZUJj5q4qEYqVvFMnT1F
	hTFwpzAUDnOgKQq8zL7KkMqb7AxfPCCx5LUYZec1dVvZTyqMOZgs3SrsDbYnt/Oy5v1GOJ
	ZKXEaFJ5GlE1xuL1jq2Zb7FvU7yaoFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761768530; x=1762027730;
	bh=+vFEd2i7cGwKfB76083zqMnaJRzsau0IVtzvsF2hHkA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=f2ixPvROXBBe3oYcnt46ZpuoD3whpqDkx+uWuzdhIU+YPbduMbbLBUYy3V19N8DdT
	 lJCQaItYc4V04frYC10Qp8vC4v6QealyZOWFQ9x+4qrE9lklIogwUqZ4H130zyymmQ
	 QuU0Jp39WS7X0fe1Z0N55I/Nb2bcW5EMWiLI8MAIscT6weHJpTE4qsZY5FWESEyQBa
	 XhAFbluJjDjJ4OVPWlAMCFRWCe1eIQ5pzDu9nHbw1L5wWjcHpVsCvn8VHSo6rvjAi8
	 DZuZbhfARnsZ1Xh2scxFMiBarfrU81v14JAR7983upQVZyAIOMSBej2abjtKpLwF5M
	 HwEJuccHvAyqQ==
Date: Wed, 29 Oct 2025 20:08:43 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 13/18] x86/mm: LAM initialization
Message-ID: <96559d5a8e897f97879259bad3117db617e21377.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 0e1842514ef97eaa33355f60d534577848d5c6b8
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C53FC0002
X-Stat-Signature: cm7g71qapben717emz1if173fjw86sa6
X-Rspam-User: 
X-HE-Tag: 1761768534-273141
X-HE-Meta: U2FsdGVkX18uhsEOUE4ITuApEre+lFEgzkoU81xT7xK6NhUMv28foqgPK5AoCnJjXjWWr2GZJYQrCOSrUZmrSYNS7+d8CItvYsmg4ULTWp6FNpO+SOWREpoTNighif0c6SKaHXWFLuueqmuoEjyFFG8qwtpf13OrAGrI+r435pI5whmooQNLEv5POELACE+QiiSQUfdkOeX77fbPN2+rz4CeqlAfK2Sg27B/SV6zpiDCTvtZUic8o5rfvmZL4JwUHnERCws/2jICv79/OaX4MMDtHHtPKByOLFq9FQoyteZmMy8MqcRadGuen2F518HxBkOgwsS8y8Mzm9FxuYGhzTxoARGqgT+Aa6VsXn0APUXuf8GJ216K5ICtPXm/XCRSC0YwlN15wkriA8ARNkdJTeSIGOrBByBlk2eVWT3X55zojnGzYwqDvVBuw5OHxhHJW31fqmljV6mRuFq4TnJGUFPcG7fTI8JLiUfyt+DJmiVlg0fT+Cm5T2M09C5aCSAVOhQ6DbLUNxj4Fb6oYqHj0Flw4Qe5io2UoKEsET6y8VfGsaWunlfMO8XbKIhkw7NS9FnEWNbePFUiGEfXW9xmwY14r5xWsIXAw73OrgExZr/8f1saTTfjSQR4G7SrEOkomlxg7v888QIMZfqutMdKQQJFBgg+opDDn4qh6sItWSj79qU44bMCg3MzChu9bU3Q17fKjvJeGpo4TzBHpzMQaAI2xPRyqq/DJbbxKp6NoRI2RyIc9154MT6NpFYiGTNNUl7dC6qVxJ7GhNK385MUH8ua4/ezCqkmIo1mWLMmUsvHIGwXx3A/jYfD+l1tYXBFdmM3+W1dhCrmJZlUE2/hAXUvbpVKySfC1HbUfXrpaQbZ+LfnXm+wE6DhRX5D79uKFCAe59FXCi7t6BhGrUEv4csW2c1xgf88
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

To make use of KASAN's tag based mode on x86, Linear Address Masking
(LAM) needs to be enabled. To do that the 28th bit in CR4 has to be set.

Set the bit in early memory initialization.

When launching secondary CPUs the LAM bit gets lost. To avoid this add
it in a mask in head_64.S. The bitmask permits some bits of CR4 to pass
from the primary CPU to the secondary CPUs without being cleared.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v6:
- boot_cpu_has() -> cpu_feature_enabled()

 arch/x86/kernel/head_64.S | 3 +++
 arch/x86/mm/init.c        | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 21816b48537c..c5a0bfbe280d 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -209,6 +209,9 @@ SYM_INNER_LABEL(common_startup_64, SYM_L_LOCAL)
 =09 *  there will be no global TLB entries after the execution."
 =09 */
 =09movl=09$(X86_CR4_PAE | X86_CR4_LA57), %edx
+#ifdef CONFIG_ADDRESS_MASKING
+=09orl=09$X86_CR4_LAM_SUP, %edx
+#endif
 #ifdef CONFIG_X86_MCE
 =09/*
 =09 * Preserve CR4.MCE if the kernel will enable #MC support.
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8bf6ad4b9400..a8442b255481 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -764,6 +764,9 @@ void __init init_mem_mapping(void)
 =09probe_page_size_mask();
 =09setup_pcid();
=20
+=09if (cpu_feature_enabled(X86_FEATURE_LAM) && IS_ENABLED(CONFIG_KASAN_SW_=
TAGS))
+=09=09cr4_set_bits_and_update_boot(X86_CR4_LAM_SUP);
+
 #ifdef CONFIG_X86_64
 =09end =3D max_pfn << PAGE_SHIFT;
 #else
--=20
2.51.0



