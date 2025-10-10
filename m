Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4098CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4EB8E0041; Fri, 10 Oct 2025 11:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACB58E002C; Fri, 10 Oct 2025 11:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E228E0041; Fri, 10 Oct 2025 11:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2D778E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:47:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9A86160371
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:56 +0000 (UTC)
X-FDA: 83982635352.29.38390B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id F2A9040014
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MBW6oBoh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lrJSvBCTikD7TRV03gO07iD7OhDeDgSrJU4nyWpmM8=;
	b=flsAa2zExcSWhjGLFFijjJY88lhusWJLMYNUi19jLmDNuFsYN9gUc/kO2eS4IqANCj+0Q2
	nu3OlQAC85F/GOvWb3Hv5J5uHEioEy2jOOJzCJ0wTjMH2GsnhuWd9o397htOgV395as2pL
	hth0/y5z7nIox9LsYTWULOawgPbs0eE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111275; a=rsa-sha256;
	cv=none;
	b=C+5RszMtyGXow3ZKB4YeVnOSXRx1BJwekInZzMHJLFstQGxgqCFKMrXMXcQ9skiNIHsgaZ
	0C2ngqP64kugtTOXgdupjhxFXrTRRjD7yEKzza/SEJ0llxdKOw2FHQdEgmvXRSom+QsV8r
	MRqmzA4O4BZyPyfzkjuBFEjWvvWEqeY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MBW6oBoh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/lrJSvBCTikD7TRV03gO07iD7OhDeDgSrJU4nyWpmM8=;
	b=MBW6oBohdgjVUs4y6XLXc3eYNcxlBionbFD4u7LpCirzZyK4WJsYKwawCK9bGeeJDQxsmw
	Gnr5ZB5K+JH4xu1hCnD9YSEB043c/qj2oUvEspM8uataic515emxocWa1iX8N57td3S3kz
	2hUHvFmY02CM/ivzrLjwRFP1ogi1eio=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-LjpbKfoTP3momteVKJ_GvA-1; Fri,
 10 Oct 2025 11:47:52 -0400
X-MC-Unique: LjpbKfoTP3momteVKJ_GvA-1
X-Mimecast-MFC-AGG-ID: LjpbKfoTP3momteVKJ_GvA_1760111266
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A5A719560B4;
	Fri, 10 Oct 2025 15:47:46 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BA791800576;
	Fri, 10 Oct 2025 15:47:31 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>
Subject: [RFC PATCH v6 27/29] x86/mm/pti: Implement a TLB flush immediately after a switch to kernel CR3
Date: Fri, 10 Oct 2025 17:38:37 +0200
Message-ID: <20251010153839.151763-28-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam01
X-Stat-Signature: yixo7trn59nk6cg7sfofu78cx7u1oekb
X-Rspam-User: 
X-Rspamd-Queue-Id: F2A9040014
X-HE-Tag: 1760111274-655352
X-HE-Meta: U2FsdGVkX1/7bA3WgCsJRQ82gzkWVI7ZzooIuR/PCAdNrmuvHA8zYbgWxj8OeHv7LvvxtvUfa+tfGWuZvR/ClpVoPpJS+w950Gqwo3ML2nyCdo+4xapt7rsa3Px0kdF02E1v4c9Tdr9AENnIDwkjCtY+GiXQRcM3lDJyWPzluQUmMXNKcERhQ5yGz7tRHz/ybAoDOlgp5ppiI8yCRSaqnWPAAhgjMe46ZXYzcdJ6oNCpAx4IRk3mZwKoEJ9L0VdgBGStnvLXIboyd0Bx5nfDnCOSaQG/lbJ96icE2TrCVwck6cS2YRpaigjiu+nSLi5FUAlmdT8d1HWkdo5604sB3yIf+UnnJhJdBLnzzKAoRbynXSLyde+HlZqP6gD9kiMzcA75gafuCACV/V7nDSY09F/+s9aS1DFyafY0Y+zd1nWezGrhVWDmBT8XHNi+1wvit1rS3rwX1lEKT0vgvdI7nVG3VWlgSmwT3DEOcHqP4PEIH+9kB/LZGhXE0MMDlINnWKpPMJ1ab0MHRzI4AWYPy/XZsPdNBR6C9XItb3v7ZXFoRVNuHu818t8ditsq9HaHakchXT7aWhyjhcOIDTbXm8tot6RfpYFoZfEatGZHImRTe5WUaPjc4FhHuTSVBbXa6ARr/HaIhteVSriTStvrbSLYYVjhnvVxxPKEy0L9u9XIyifbR3Eznpefhn1KryBzzwjL8axdB+ZlXZ7/hNAXtGEGp9jhw4TvS5m8VRjBSWU7qZlYNWcUZfJ9QTXRP5eBe4ryq1LvgeN872Ne4Yx+2rVIP38UMtyBWdhUgV+v/J0T/dk5CdrZZ7SlnYTRdz3WM76ncQyG1Bx3b1bMkTQ386nzRjcAKlrpjqklMjoswgjwkCFNaHBLvcPPaN/GknNrxylsUvFiMol6SZy0LY3hbN8//lrLh579yMeZOjkeBeakmovyW/1FRJTprfxBcEPdeHxm4grozrYHxUtdJdM
 zCcdaNCC
 SvpIpk+b/v/L2zlNYhr/P+jPXHsuq5sVF27j2bWPQJvlW8anwFj9vGRuVV/RD0zBruveJt14zirIAUtcRXqSgAStP6sbgsVAKJGva16wjyGlme+tm+tDm6T8qng9IV59/IaPwbc/7osps82ztTYQPFTWcH8lkvbt43+JnHGlAJTBBMdKSgRAEq/zsGfAb/cgi4LpdoLZzXJWfAjmhWrttmFSKCYPH6s7sALptPOB/BdBNKeq5UqLRrMBk/YCgeDNrSA/Q+3bGlFntCoatXYdQmvWIY6kVdu4GTI/dgA0MmWmUf/dH5JTtEJ0U84Gv72KvxWu7eH75YGQi1QBCr9pq2hzKUOw0ALmxHFTBa5EAG1stNGNunU6FpDhJgRu02r7qbY+PP4YKlE/M88Ndrdgb1oXTHE85XBHZgJxicMqCxm5cpfx/FVPH3+EUJd/Z519SQRW0XbHDJsp5w5b3ORgdba88IA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deferring kernel range TLB flushes requires the guarantee that upon
entering the kernel, no stale entry may be accessed. The simplest way to
provide such a guarantee is to issue an unconditional flush upon switching
to the kernel CR3, as this is the pivoting point where such stale entries
may be accessed.

As this is only relevant to NOHZ_FULL, restrict the mechanism to NOHZ_FULL
CPUs.

Note that the COALESCE_TLBI config option is introduced in a later commit,
when the whole feature is implemented.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/entry/calling.h      | 26 +++++++++++++++++++++++---
 arch/x86/kernel/asm-offsets.c |  1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 813451b1ddecc..19fb6de276eac 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -9,6 +9,7 @@
 #include <asm/ptrace-abi.h>
 #include <asm/msr.h>
 #include <asm/nospec-branch.h>
+#include <asm/invpcid.h>

 /*

@@ -171,8 +172,27 @@ For 32-bit we have the following conventions - kernel is built with
	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
 .endm

-.macro COALESCE_TLBI
+.macro COALESCE_TLBI scratch_reg:req
 #ifdef CONFIG_COALESCE_TLBI
+	/* No point in doing this for housekeeping CPUs */
+	movslq  PER_CPU_VAR(cpu_number), \scratch_reg
+	bt	\scratch_reg, tick_nohz_full_mask(%rip)
+	jnc	.Lend_tlbi_\@
+
+	ALTERNATIVE "jmp .Lcr4_\@", "", X86_FEATURE_INVPCID
+	movq $(INVPCID_TYPE_ALL_INCL_GLOBAL), \scratch_reg
+	/* descriptor is all zeroes, point at the zero page */
+	invpcid empty_zero_page(%rip), \scratch_reg
+	jmp .Lend_tlbi_\@
+.Lcr4_\@:
+	/* Note: this gives CR4 pinning the finger */
+	movq PER_CPU_VAR(cpu_tlbstate + TLB_STATE_cr4), \scratch_reg
+	xorq $(X86_CR4_PGE), \scratch_reg
+	movq \scratch_reg, %cr4
+	xorq $(X86_CR4_PGE), \scratch_reg
+	movq \scratch_reg, %cr4
+
+.Lend_tlbi_\@:
	movl     $1, PER_CPU_VAR(kernel_cr3_loaded)
 #endif // CONFIG_COALESCE_TLBI
 .endm
@@ -188,7 +208,7 @@ For 32-bit we have the following conventions - kernel is built with
	mov	%cr3, \scratch_reg
	ADJUST_KERNEL_CR3 \scratch_reg
	mov	\scratch_reg, %cr3
-	COALESCE_TLBI
+	COALESCE_TLBI \scratch_reg
 .Lend_\@:
 .endm

@@ -256,7 +276,7 @@ For 32-bit we have the following conventions - kernel is built with

	ADJUST_KERNEL_CR3 \scratch_reg
	movq	\scratch_reg, %cr3
-	COALESCE_TLBI
+	COALESCE_TLBI \scratch_reg

 .Ldone_\@:
 .endm
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 6259b474073bc..f5abdcbb150d9 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -105,6 +105,7 @@ static void __used common(void)

	/* TLB state for the entry code */
	OFFSET(TLB_STATE_user_pcid_flush_mask, tlb_state, user_pcid_flush_mask);
+	OFFSET(TLB_STATE_cr4, tlb_state, cr4);

	/* Layout info for cpu_entry_area */
	OFFSET(CPU_ENTRY_AREA_entry_stack, cpu_entry_area, entry_stack_page);
--
2.51.0


