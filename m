Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80397CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2698E0044; Fri, 10 Oct 2025 11:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52248E002C; Fri, 10 Oct 2025 11:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9411A8E0044; Fri, 10 Oct 2025 11:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3218E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:48:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB705B8A68
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:48:27 +0000 (UTC)
X-FDA: 83982636654.07.574549C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AAFB180003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:48:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FX7FTCoT;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BS3ds8Up0Gh0Vcw12QbhifbfMtExSe/6UKJ7yZRlT/s=;
	b=5mtQ8WNhxSEe4zjEJrG+ylJo4akQvx5G6VbYV3mpFw4mVd3Ufi8/1xN8un1mGyZybR3IE1
	Q4xx2LIz/9FXHVqvX7I4kY2EFnL+7N1DeOqNdNtnrFTkvRi4qE20AgZkneAwc65mTSdrIW
	mI2klwzXFkhfz0s4oEE3ZuEiLrC35sY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111306; a=rsa-sha256;
	cv=none;
	b=VLesYiyCd/hnyXK0zueO5UmlumuyQxmRtSDsLgxszafLuiGrPSziAQSnuKhKWsQubyPZV5
	gk332T7z52BpdTacVY7PV0xVO5wKKgE7sKOVvPo0goB9kYXTaAIq+pghIW834PPAbOZn7G
	A3ZXOKlodmfP8/lGAa5+CziGw7M7Hvo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FX7FTCoT;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BS3ds8Up0Gh0Vcw12QbhifbfMtExSe/6UKJ7yZRlT/s=;
	b=FX7FTCoTceZo3jtDT8QA5XBmtCNDsrhDGRNCXX0UosPtRRk8aqs6Pdpozie7J0nPG4EC2B
	L/reYqhY+yd5e63CooyJg/ZWPeAc9wjCZ/7TFuoM8x6DUyGnwQoXUouT3Z3PDtT6pp7xS9
	Mgr/UGivrrf4vUOjPWaegbswM4EwtOE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-mm0n-4RTPUCAn9uW9vCAGg-1; Fri,
 10 Oct 2025 11:48:23 -0400
X-MC-Unique: mm0n-4RTPUCAn9uW9vCAGg-1
X-Mimecast-MFC-AGG-ID: mm0n-4RTPUCAn9uW9vCAGg_1760111296
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 566A519560B0;
	Fri, 10 Oct 2025 15:48:16 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0D471800578;
	Fri, 10 Oct 2025 15:48:01 +0000 (UTC)
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
Subject: [RFC PATCH v6 29/29] x86/entry: Add an option to coalesce TLB flushes
Date: Fri, 10 Oct 2025 17:38:39 +0200
Message-ID: <20251010153839.151763-30-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam05
X-Stat-Signature: 7cdttcmybzzui7ac615usddt4ioitins
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AAFB180003
X-HE-Tag: 1760111306-544378
X-HE-Meta: U2FsdGVkX19vt6N9IfVxzGC7KeBiRKOj9Y7xt3eAa3gWsmgCnE/9p+Fj9qAm4JwrgVrso0zHEJ6YgPo+WhOlAwxpic+60qRsuSjUr1uaxNuA0lc04tETIYNMeUCHh4yxPxFHIUPsX5wrvev4clkYokvGkBhiqTsE/pmuhFQH8snlx21NxUiA739FnCT+xOceHsn04u5rCrqfkx+30KMnNxqPiVJD8hrY6r7NcpnHoRz8oK7y5Fy1tIg4q+HaxTb9AHqj3bBoKclOmg9QDjuI9vXs2YJ3lPl/puZXgHhXUkzi9ONG7sKwNGTXbM5Uaojr2GiWW8MVgoIJ3SlwsyC9Y8SZjFPaGaPRE6CF6uUd+Dxh3Qw0Gr2LCyF9eU8eQWpY/z9kxyxj42FglUM3kpgN6TmHWxblzPx1i3P6hcsvBlWteYADJYuUL8LomDQ2rOpaezunY0wga8sQVp2D3xrndzIDsg3d2Em/cIofFtsuU/6BYvClF2GMHaZJKG5ysJBHSVnCLBP2rV5ValLT+iJnfgNCbRQIxZ+nhILMdSvab4HNfFQK7Z7bHa1gcPHvKyKrStvi+FFWA0odPy4Z6qOAPja65IltD41fKhWvZh1WPhcrn9JaSCmcB9cSu0VmFTYsbrvGP920uwhnRib+NgzBgOpIFqUAGhkPi7OYma3+kOneigBDBj/u3WQdgA3a/rZBumY6JcScokv0QklJZc7gnc8U8zTe2Mho5JmfSTZ965DM0Vm8DEu74QcX9gq8o1Ir1yGBd7lr8Ex+68UsYxhzT+DyI0on5lFaj7rkuhTOMB5qV4Q2Em/Ys+JttYr4c/95/6wLapqu0IPeQ3cZKLdDpXeHhnRTBrfJLF7MFCrksAaCfHxVZTEawEvEa0gX2WGo9QTbJvym4gWBTzKD3tg16I7jV8dljTH2sSINJEJnyJo6BMi5D/5KLfN+em5PCOn4Gwt1uV93C6h9d2qtJiJ
 +N6CHxxr
 HYmGpk9PHy+IUm0VVSWsrtmgz8MuxwyQPLx+tVAJw2I7QDrbgO3eBFcvcZ9pHiNx1bpyz6F7jcKTmwH4Nq17dH3KxrWM2N9t1exVCIIgxXztYelBhd3/DwBix832OpnvP1f3Aqk9f4xd59gljdr+9uAI3SQtt2ftJtqAU8Y4aLXGVPayXZRWL2s3DLPZK9wx21ReO9RogL6JetZVWNpVfHzXc74wWEQGFeUASEoyoQiZvkJJ+eSs4ee9yBS/aUPHZ1droFr+26lbzt7FrWmhnw85cdlQIl/G2BfFoG0QNZcCt7ul3nI1FU9cbnflPXaX/nGgefETACRv15lUDxc7L+3r81GOwQuhT/Sa4w6W/LUL1HX3b9xaQvU1nAs/6UBJRiCcMhfSlmIkpb1pcUeWYH7/ziOTlGLEpdxBTljXNzVQLYcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previous patches have introduced a mechanism to prevent kernel text updates
from inducing interference on isolated CPUs. A similar action is required
for kernel-range TLB flushes in order to silence the biggest remaining
cause of isolated CPU IPI interference.

These flushes are mostly caused by vmalloc manipulations - e.g. on x86 with
CONFIG_VMAP_STACK, spawning enough processes will easily trigger
flushes. Unfortunately, the newly added context_tracking IPI deferral
mechanism cannot be leveraged for TLB flushes, as the deferred work would
be executed too late. Consider the following execution flow:

  <userspace>

  !interrupt!

  SWITCH_TO_KERNEL_CR3 // vmalloc range becomes accessible

  idtentry_func_foo()
    irqentry_enter()
      irqentry_enter_from_user_mode()
	enter_from_user_mode()
	  [...]
	    ct_kernel_enter_state()
	      ct_work_flush() // deferred flush would be done here

Since there is no sane way to assert no stale entry is accessed during
kernel entry, any code executed between SWITCH_TO_KERNEL_CR3 and
ct_work_flush() is at risk of accessing a stale entry. Dave had suggested
hacking up something within SWITCH_TO_KERNEL_CR3 itself, which is what has
been implemented in the previous patches.

Make kernel-range TLB flush deferral available via CONFIG_COALESCE_TLBI.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/Kconfig | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3f1557b7acd8f..390e1dbe5d4de 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2188,6 +2188,23 @@ config ADDRESS_MASKING
	  The capability can be used for efficient address sanitizers (ASAN)
	  implementation and for optimizations in JITs.

+config COALESCE_TLBI
+       def_bool n
+       prompt "Coalesce kernel TLB flushes for NOHZ-full CPUs"
+       depends on X86_64 && MITIGATION_PAGE_TABLE_ISOLATION && NO_HZ_FULL
+       help
+	 TLB flushes for kernel addresses can lead to IPIs being sent to
+	 NOHZ-full CPUs, thus kicking them out of userspace.
+
+	 This option coalesces kernel-range TLB flushes for NOHZ-full CPUs into
+	 a single flush executed at kernel entry, right after switching to the
+	 kernel page table. Note that this flush is unconditionnal, even if no
+	 remote flush was issued during the previous userspace execution window.
+
+	 This obviously makes the user->kernel transition overhead even worse.
+
+	 If unsure, say N.
+
 config HOTPLUG_CPU
	def_bool y
	depends on SMP
--
2.51.0


