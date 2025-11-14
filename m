Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8614ECE7B1E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B8B8E0032; Fri, 14 Nov 2025 10:17:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4C28E0002; Fri, 14 Nov 2025 10:17:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4318E0032; Fri, 14 Nov 2025 10:17:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9AB88E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:17:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 891FB1603D8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:17:12 +0000 (UTC)
X-FDA: 84109565904.21.84BC32C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id B11291A0015
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:17:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9ieDmNm;
	spf=pass (imf19.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3X87uiojng2a6RCMXxkyxjZHQ7qUm6Xyc1h3s0fKM3s=;
	b=7g7Cf8vSXo8vxXycLYuLyVdNMctNf8iBEMs3zyLBKvP9kkpbSzCjjzI7oj3JP7lNOcNWRZ
	5Y3t8czEWbPvdw0A8kcKKxFX3nDrKk/OSGlxo0rEOWHH8vXatTflB1a5kCk3TzW9iCp9L3
	ViNC0/cEeDGMaiDZNnqoErvFJFG45HY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9ieDmNm;
	spf=pass (imf19.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133431; a=rsa-sha256;
	cv=none;
	b=ryCjOlpad78m7x6owjW3llghiPbOjCrHaDg+LsOn2h3O/fBAlFbRJdWgFM6S2az2MAkhMm
	DMeW0mGYq8ixCxtfGPi7rP05RoLTyp3uEo28OQBK9qeMVmIFfQQqpM6JMzTNgXheX4kaO8
	xI+MFLFp+i8hGjaTFszxXvA7R+1gOlI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3X87uiojng2a6RCMXxkyxjZHQ7qUm6Xyc1h3s0fKM3s=;
	b=b9ieDmNmY08erKkZRkfR5pN7xyCCv/Gw+CmorIyqNkJ3eqxSpqPBMbumfwx1oqfFUrO0f8
	VI2zWgLZ7T7N6y5Y5ghp6xjRgU33bOvjXWLxciXfHt6sobbJKPvF8PSG5o5U1X8rRWuW2x
	NvEYTnnGwndpGAT1t4mFlkVNzevOm6I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-2-uC21UoNNia6LI_UqojzA-1; Fri,
 14 Nov 2025 10:17:08 -0500
X-MC-Unique: 2-uC21UoNNia6LI_UqojzA-1
X-Mimecast-MFC-AGG-ID: 2-uC21UoNNia6LI_UqojzA_1763133423
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8653180009D;
	Fri, 14 Nov 2025 15:17:02 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E4EA180049F;
	Fri, 14 Nov 2025 15:16:48 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [RFC PATCH v7 29/31] x86/mm/pti: Implement a TLB flush immediately after a switch to kernel CR3
Date: Fri, 14 Nov 2025 16:14:26 +0100
Message-ID: <20251114151428.1064524-9-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: B11291A0015
X-Stat-Signature: 8s3fmsar68cbm77szjrbujpo69kuxi37
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763133430-505155
X-HE-Meta: U2FsdGVkX1+0NoYI9qRzZF6mfK3nkVAedy/FukX/x3t7IrmA050nzmzC/30O8SmgdJCj6n9wD7rVC2MRp+pZfGYtzDdfrxnMLhki4ogFZh0SWIQftrs/UgNF3vTSsRTrH4cifMDDiO3BFpkrhHnaxyVBdZpUGbL21eUSf/zy2/RdolQIQE/El0vMJuVELGFGzXdH+/rhjSX0EI1ErMHgH9+zjgAbRZf0N9o0vhM7F7OAbDHDLumlt3RFTwp8wxUoO4Jux9Ds23D5CQ0BJn98RJAMkf5eDajQZKH6tVEt9h/OVA0qtJOsgh1DJGQ7vd8xuZIqU4ncCpJnVJxcni8dTyCRy4hEHNXdols1bxy4ufjGCKXAqQHleoAUO1Ll2XJAfEOHIQhgRooIb/m1R/1meMrPunZBrn/OMcgUhlLdykETgXvBczqZnBpYO08hi7vdaAtYLtc+d8fyW3CV18h3cxQpifwSvlOpnfm5yCSRDVKP+DaSvaDttrVKtHYAU+flg7PwytQafRC9PMx7VNwDTVaKn8QZnywZ7QcuiSpsqI15cT6crtdEXHgPiD3p5td73fLUVXhhcERcaSI2xIB22ieQyisKMJVFMveXxLwvNQy86U19aSepIWO+RvmslSNjExsLILtGKAJpn+pPsgIRW9OZNKFOPNperdRrdCvJ5KeaZTbM/HNyZCj2KR1awD8PkQP+X3lg0YB2tUdMC4tbdtptoq6AL7KiVtG7zwne4lQH3YUROPYr88lYcMLEdV0brgSA39pYODyX/8okwu/VXVbKu1vtf4lgYb83aC8UP0wy9GlxdtNlcmqLWInbfs6jJPN4cGH8bqUWsR7Ta56CkiPbv03562ajcbe2HgBBRYZd/3sJQDKp6KJlTu4zlU+nA2EvUmwRkOix3JX0UYnS/WQyyWx5gmGugTIn28JXuB0L7vALYAzCz8K8O6SlESBEfq1YqrfaZBhSI7SGr5W
 /NiFl3VJ
 FvS5A9N3C6FVIlBrom5D4zSjA47523Pltcq1D6ibndB67/K2tqXevvBw8AkLUqx8Mv0rCZnQKlHGIPas/DhVxu3cw5GBAon/yjpcdAKwJvPDMatzq+gfi3L4mSVrwG+eudJtd
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
 arch/x86/entry/calling.h      | 25 ++++++++++++++++++++++---
 arch/x86/kernel/asm-offsets.c |  1 +
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 0187c0ea2fddb..620203ef04e9f 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -10,6 +10,7 @@
 #include <asm/msr.h>
 #include <asm/nospec-branch.h>
 #include <asm/jump_label.h>
+#include <asm/invpcid.h>

 /*

@@ -171,9 +172,27 @@ For 32-bit we have the following conventions - kernel is built with
	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
 .endm

-.macro COALESCE_TLBI
+.macro COALESCE_TLBI scratch_reg:req
 #ifdef CONFIG_COALESCE_TLBI
	STATIC_BRANCH_FALSE_LIKELY housekeeping_overridden, .Lend_\@
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
+.Lend_tlbi_\@:
	movl     $1, PER_CPU_VAR(kernel_cr3_loaded)
 .Lend_\@:
 #endif // CONFIG_COALESCE_TLBI
@@ -192,7 +211,7 @@ For 32-bit we have the following conventions - kernel is built with
	mov	%cr3, \scratch_reg
	ADJUST_KERNEL_CR3 \scratch_reg
	mov	\scratch_reg, %cr3
-	COALESCE_TLBI
+	COALESCE_TLBI \scratch_reg
 .Lend_\@:
 .endm

@@ -260,7 +279,7 @@ For 32-bit we have the following conventions - kernel is built with

	ADJUST_KERNEL_CR3 \scratch_reg
	movq	\scratch_reg, %cr3
-	COALESCE_TLBI
+	COALESCE_TLBI \scratch_reg

 .Ldone_\@:
 .endm
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 32ba599a51f88..deb92e9c8923d 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -106,6 +106,7 @@ static void __used common(void)

	/* TLB state for the entry code */
	OFFSET(TLB_STATE_user_pcid_flush_mask, tlb_state, user_pcid_flush_mask);
+	OFFSET(TLB_STATE_cr4, tlb_state, cr4);

	/* Layout info for cpu_entry_area */
	OFFSET(CPU_ENTRY_AREA_entry_stack, cpu_entry_area, entry_stack_page);
--
2.51.0


