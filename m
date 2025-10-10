Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89265CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37A48E0040; Fri, 10 Oct 2025 11:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3668E002C; Fri, 10 Oct 2025 11:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEDD38E0040; Fri, 10 Oct 2025 11:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95FA48E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:47:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F30013AA2C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:41 +0000 (UTC)
X-FDA: 83982634722.22.47BEDC0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id BACEB40007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GVGEogVZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZSxQNDyqaqLbPz4fQtAMe+wkuer6c/+cc0bKB75WPM=;
	b=MqglD36A/jEFJA8BlMFqeA9xyH5k243kB12nEYH0NEbHR34ozrzctK0ZVkM1uXu2CDY7/I
	1qkEWRFR8aXlpXS2MRwUvSz83aQ4YUjlS3LL9unEyPPpzNHSMDNLOPuttgo31frVt8XNzU
	0W3RSFOWK1CkLH3hCeuMxQBppFvFf38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111259; a=rsa-sha256;
	cv=none;
	b=CbuVN0NlioDIUQQGCwfbyFuNtyEI5az8Gq9ZhNp7TI4C294/bT0h0nhQDq/Zy42jwb90nS
	a4aJg8g+Ee9Icg1qqF5xr/2bEe4rgBWHJNquYjhYi0LjB/f9T4DqqSZT9KejGdTBS7Vyok
	28Ns1M1Nnnt6h+B1k+qp4XFkVXhjBcI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GVGEogVZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tZSxQNDyqaqLbPz4fQtAMe+wkuer6c/+cc0bKB75WPM=;
	b=GVGEogVZR9EjJDklOSXn6CbcSImq9E/l99Bood7dXlO2xD2BkEk0iME50F5VmTTv243bhc
	ryqQ4WPkwy1QB8/mzEVt6qzFq/Gw7iu+yW227JaFqwHHDRgRNuCjdgylaHxU/HPAdgLeuF
	/1femitW8IZPLFXgwuV5KDVC3YdewM0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-gHsLeaZYN2q0fujOe0R-ug-1; Fri,
 10 Oct 2025 11:47:35 -0400
X-MC-Unique: gHsLeaZYN2q0fujOe0R-ug-1
X-Mimecast-MFC-AGG-ID: gHsLeaZYN2q0fujOe0R-ug_1760111251
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0A791956096;
	Fri, 10 Oct 2025 15:47:30 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDAAF180035E;
	Fri, 10 Oct 2025 15:47:15 +0000 (UTC)
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
Subject: [RFC PATCH v6 26/29] x86/mm/pti: Introduce a kernel/user CR3 software signal
Date: Fri, 10 Oct 2025 17:38:36 +0200
Message-ID: <20251010153839.151763-27-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: BACEB40007
X-Rspamd-Server: rspam02
X-Stat-Signature: 9w5y53u8fp9q9kmui8geessr145cykud
X-HE-Tag: 1760111259-441449
X-HE-Meta: U2FsdGVkX18p8ULf2crTVVsnBRvyvcvSHkjTlVV2mwUgq6Kq8nGYswWwcdx4jfOudyn4jGwwFKi7JESYKMc0BJ3f+WvFrR3VRp+Zr59KgWDTBxCpsBYNtaTK7ZjMyH0RhT0QCTiXV7PRPI4LE5B/86KAY8syZnz62Y2WKWL/Hz77yC5nd+SKbi4jE4ElKKOfYzoaQUWrJNjNU19HTVD9uDvemnLmrpoAmnhUdyXEN9e/ogKG2rZJXOb13dYjQLcW1rtorxfexcNyyZRY/noa4AopjJhN/ZBrnNa1HC2XNG9n4o0VfIgMxkIYyJ0sdDnyHaS6uNCZwLqCeVKRj60iSQPnyQB189ntwMS1g/5lbQHaghpKKZjj1Fg3VoxdQfZ0CHUS6vjEKj+eDx7vO85SuMJHyedNRD5OGCbCmuvazkJ0Y+TA49EIfwQwgf/2iAG0H25ETG2g7Rw1+MMhEXF6IbzWF1jjiIXpmSWrjLjru1LxWNNGSMPfmuTfhjiwh55ACQCl2NqL9LjoW0aQLAIyX4/fa4hU3Oc5Ux05tqfkT4cmC9/Kk8pNdhd+3Y2xkIsKjnzzczZjGFQiUOB5fjAxNxk/EHEjP7I+DTgHhFR+rQtpwzR8Cf4vZd6a04wSMTZhwYT7e7g2HQ9Mb8beps/q+1VCLcz+tmNUNMFckkxfSWAW2xMpZkSgFSrU/XSYMCDdhXntyuKT0T9JGR5RXzIDK9oxyBQQa/Y9/bhqSIDhaRIs+Ja53RnGzqqN5bl82KoCxEXgdLA00m4spvKbhdiTmBEzbL0dbb/j2XKjDyqFY3D+AKmyuQKz0JqK6MTUpc79i51JasNL9Fz4IXwUVmF9daInReVphBejmAzhwoKYfbm0BpfMtiB+xzJpysGsIFXTJ/Gi0BW/pg692Mi1njMHTHDRmA3mD0eYB85psyJfkjGGd473gFU+9TTyGiJ3wvBkuZSSfWGD2eCFIDDxixd
 JjiXbgOX
 wWRMWIU1w/7zo27mzf8oELA9Ro2DDPjJc3bpUsvu/tVjHM9OPYgZJUeHkLkE8oDFsljAv/XjBMsr88+Wxh5hUwFsqhTgWcZxSbcZOCHxCq+6GQlUdG0jWocvcfnfjigiSxvoW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later commits will rely on this information to defer kernel TLB flush
IPIs. Update it when switching to and from the kernel CR3.

This will only be really useful for NOHZ_FULL CPUs, but it should be
cheaper to unconditionally update a never-used per-CPU variable living in
its own cacheline than to check a shared cpumask such as
  housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)
at every entry.

Note that the COALESCE_TLBI config option is introduced in a later commit,
when the whole feature is implemented.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
Per the cover letter, I really hate this, but couldn't come up with
anything better.
---
 arch/x86/entry/calling.h        | 16 ++++++++++++++++
 arch/x86/entry/syscall_64.c     |  4 ++++
 arch/x86/include/asm/tlbflush.h |  3 +++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 94519688b0071..813451b1ddecc 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -171,11 +171,24 @@ For 32-bit we have the following conventions - kernel is built with
	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
 .endm

+.macro COALESCE_TLBI
+#ifdef CONFIG_COALESCE_TLBI
+	movl     $1, PER_CPU_VAR(kernel_cr3_loaded)
+#endif // CONFIG_COALESCE_TLBI
+.endm
+
+.macro NOTE_SWITCH_TO_USER_CR3
+#ifdef CONFIG_COALESCE_TLBI
+	movl     $0, PER_CPU_VAR(kernel_cr3_loaded)
+#endif // CONFIG_COALESCE_TLBI
+.endm
+
 .macro SWITCH_TO_KERNEL_CR3 scratch_reg:req
	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
	mov	%cr3, \scratch_reg
	ADJUST_KERNEL_CR3 \scratch_reg
	mov	\scratch_reg, %cr3
+	COALESCE_TLBI
 .Lend_\@:
 .endm

@@ -183,6 +196,7 @@ For 32-bit we have the following conventions - kernel is built with
	PER_CPU_VAR(cpu_tlbstate + TLB_STATE_user_pcid_flush_mask)

 .macro SWITCH_TO_USER_CR3 scratch_reg:req scratch_reg2:req
+	NOTE_SWITCH_TO_USER_CR3
	mov	%cr3, \scratch_reg

	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID
@@ -242,6 +256,7 @@ For 32-bit we have the following conventions - kernel is built with

	ADJUST_KERNEL_CR3 \scratch_reg
	movq	\scratch_reg, %cr3
+	COALESCE_TLBI

 .Ldone_\@:
 .endm
@@ -258,6 +273,7 @@ For 32-bit we have the following conventions - kernel is built with
	bt	$PTI_USER_PGTABLE_BIT, \save_reg
	jnc	.Lend_\@

+	NOTE_SWITCH_TO_USER_CR3
	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID

	/*
diff --git a/arch/x86/entry/syscall_64.c b/arch/x86/entry/syscall_64.c
index b6e68ea98b839..2589d232e0ba1 100644
--- a/arch/x86/entry/syscall_64.c
+++ b/arch/x86/entry/syscall_64.c
@@ -83,6 +83,10 @@ static __always_inline bool do_syscall_x32(struct pt_regs *regs, int nr)
	return false;
 }

+#ifdef CONFIG_COALESCE_TLBI
+DEFINE_PER_CPU(bool, kernel_cr3_loaded) = true;
+#endif
+
 /* Returns true to return using SYSRET, or false to use IRET */
 __visible noinstr bool do_syscall_64(struct pt_regs *regs, int nr)
 {
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 00daedfefc1b0..e39ae95b85072 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -17,6 +17,9 @@
 #include <asm/pgtable.h>

 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
+#ifdef CONFIG_COALESCE_TLBI
+DECLARE_PER_CPU(bool, kernel_cr3_loaded);
+#endif

 void __flush_tlb_all(void);

--
2.51.0


