Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377D9CE7B1F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A938E0034; Fri, 14 Nov 2025 10:17:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B8E8E0002; Fri, 14 Nov 2025 10:17:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3868E0034; Fri, 14 Nov 2025 10:17:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B03B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:17:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 390EC12DFB1
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:17:46 +0000 (UTC)
X-FDA: 84109567332.30.5869D1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CE27140017
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:17:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lw9MRslJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133464; a=rsa-sha256;
	cv=none;
	b=MVUV7/qEZ1behbFKMK6NhPoxhhYGKyK7/mIshznHDoPlLyo42q2zNEyY4z1hQQGcXVepy4
	rBvHAjOqhhGICTGmLqOHsESryQUJdrpGKrPLyVfdv+Yf93W/mzpfI9uY4TRgx8ThXIVoR5
	38o+jBQtbFSPwr0zrzoXd+sXQbZimxg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lw9MRslJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHbOf6w5rlj656BCFSOxLzgqhHO7ycdTLJssDuPvEBo=;
	b=GjGSkSf6PZcsyXQJXqjHuWpiXae9y/81X40Ia8wh7HKI1nT/cb4AnJiX2akxi6lZJaw766
	BBU4ChDcv8v2QXaNXV6ThWPO2c8+CGljP64mRKAbHTXZf4VC6qF3lmqbz34iixUVm8q1pB
	l62Z/9J2M83+kULX49cvNFuy/yTWmTw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YHbOf6w5rlj656BCFSOxLzgqhHO7ycdTLJssDuPvEBo=;
	b=Lw9MRslJKFYzHr/HhC4HPEcbu6PG8aYs7tP6hY7J0KrmLr9x0nv+9c/izvQ/VuHABwmk20
	11k5WcHqQUkwAn15nnxEh70Mrmc+r+xNrjL7CCvmAwp2x9t7vuEgCcK8p6oLwJf5Mjlixt
	SOSRYcrXYQnRhpuCnv3X3Id6jMUKlFA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-531--Ii0M5UDM1-LvTUINdpoDg-1; Fri,
 14 Nov 2025 10:17:37 -0500
X-MC-Unique: -Ii0M5UDM1-LvTUINdpoDg-1
X-Mimecast-MFC-AGG-ID: -Ii0M5UDM1-LvTUINdpoDg_1763133453
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DC7C1956096;
	Fri, 14 Nov 2025 15:17:33 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A94EB180049F;
	Fri, 14 Nov 2025 15:17:18 +0000 (UTC)
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
Subject: [RFC PATCH v7 31/31] x86/entry: Add an option to coalesce TLB flushes
Date: Fri, 14 Nov 2025 16:14:28 +0100
Message-ID: <20251114151428.1064524-11-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7CE27140017
X-Stat-Signature: cpkc8dkxskdeg71ubfdnb4hyygunxtkt
X-Rspam-User: 
X-HE-Tag: 1763133464-3003
X-HE-Meta: U2FsdGVkX19/RFnIb4f18YoSFtSBwwwZQaYA7mcTltz8eHiSpY/R7aCRTVmUb8F8UavqfQvaoJRqn8Qfjb70oNsETqyo2UyPnax1OxtqaDE6W1g+3H6CfW5bqjjhm08n02dHBSvV6ZlaUDlFzVpyg2ESNUYEt4UvADxSIXFjR6lo3zouiWSF7dROcABrNSmD57lCttN86GvgijO2pP3/Q29YsG+lptYhCm3stPDPDmnEyU9v5JzuEbge4n46BJ8Z38h35z9Er7f8ARyg46i7IyrouQql3hZ3eZ4BCbRwXr/gApz6HBao5PvpImO6PA9VmPmuO6Slx3rbajWENKc/PvXe4lnPwggCPQ2Ixj3oZ8XIv45ZpSxY3+jmAsmV0NWSrVyYlaMuSjyuekgD4oE29kJIDOOPuh7pjMLDWAYiwiTesAVG2WbhgWVuOHQNXFyw3lSGxM6R28I+d25Et7R2V5a48n4LSDAyCdvfqOkCU1lCgOCna7NgUkjvJmWGI6ocB8/CWBkYDv6tvJwxbsmT1FGH/1LC8nDGVAzs1jHXd7KI8O/svym1WniRcjEk7jo1MSa7xs9FaQOxW2b7oF8uFlFLvgRAsXYJJF/YiFuZXKvajjlhNUqJDlBF8XlSAdQOfJi6GSM6brDk7M92xhzkABCekqVZuj7qTtfjlqbat90FgVvqla1aw7Ys/raT3aTUjQk07g3qXQZE6P9ZDErgLez/pNP8dzbLnPg+Tg+xW1Zju3L1tu3i9QfDUkOnsxf2cfovFLrIIp8u4PiD9ibvLr7AW8mdHhg24KK/RG5cW+cWc2R1G6N+bmu9WBkD8Pde9ur3WXbRz5/AxaAYRyE275PJEb7W4437nU4EPVKg1o2Nc9tOHMuKQ6lciuowJ70l2ivZ/h62bblO3G6F+3dRaChCAMrG2jRcHCBs1y4AdAaT3826H92+gpCOxR+23fV/LNFV1x8zCQqK+XN69TU
 ab2bqdQk
 rjwt8mr2Yl9DfeWFxbH6YAB7uc7x82FLQt6Tzp9NK7oqfXNpbhzk+wTVqOv97rBwLUiGqZLszPpJH5GEjXh6vDJNAMXTYTvfkCTHj2cNBnnfLuVNPk9wrfykVi6euGJOV3mQWeXaIyFBsTvusb839lAbV/1I0hFQy5EX7bzkMP4nTkqwLVu2u4F/L8Bs8Q2fJAxrJA6F/ckPIqFX9pG4C3oQGVot1n3p1SQeUwySmYJ3btffVNHDhCjqEtAUGF9a0KB65rfGDCEtbVnKWgVO3QM6bWbH9ArWDFZ3ZKdwRteo6x3r9/mjEjSbYpcoxCMUhcmaQ5jTMqhC5iYXnU5Nf6N5Arou4b5UIwmAE1QvcUDPOMhSM5dF5zdIonSO3r92xyI9vYM4qOlai5QhcSteWarnJ/TQ+x+rckgngTHwnOIoBPQk=
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
index fa9229c0e0939..04f9d6496bbbc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2189,6 +2189,23 @@ config ADDRESS_MASKING
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


