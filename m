Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6B8CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243C98E0006; Mon,  1 Sep 2025 03:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B1F8E0003; Mon,  1 Sep 2025 03:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158088E0006; Mon,  1 Sep 2025 03:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 029108E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:06:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BCCA1A06CA
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:06:08 +0000 (UTC)
X-FDA: 83839797216.29.3DDF26D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EFC7E20008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:06:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f/L9cw0y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756710367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=futEXIVmzqq6DMpppiYZ10OvvjFHVAv79YOB9UtpvM8=;
	b=cMvhHLu8iWq49NLNBv40rzRzZzB2KHTMcKjk5hjo9VrxtQ1Dm3y/Gu26vn5fSvMMTRFd08
	CLu67RXZGfXNOsVVT+u4JCZ5xCVNgDtJQ09iwl1mdbwXbFwvaKNglVUuKqcD/nC0ZI5Y+l
	fy52oLdU+oMpf6KNmBBv7ImcPIqxJM0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f/L9cw0y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756710367; a=rsa-sha256;
	cv=none;
	b=nzcyeJGS1rr0Q2Y8mn8L2IX9BNTLbBgOHN+m7YFyFDoUl1raDJTFcrDyzfgcnILHb4icIV
	4JmkplfZs1TAPyqtZwAPUVC4E1v65HZKG5s9YlyW11LqT0gN5wAE74ai8ACOg26iuXctRo
	L0waGeh8BMTk4bxmy4MHQiJHa1C0/Hc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2628F601BC;
	Mon,  1 Sep 2025 07:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26255C4CEF0;
	Mon,  1 Sep 2025 07:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756710365;
	bh=747fK6P72FtpW8Xa07ErmzcnXoqfZK5W40Qvrzm5FMo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f/L9cw0yZrXERHgTOCzGbXDqwwy7Uvc7K/kcexV6d5LQXVulWsdpMLQtbBZgga3ND
	 VX4DTR70FAT7YBwAFyoC9z1JzIJLVqckRKfnYM6sQngd0croia9bMqhenrd6Uk03Zc
	 mOVgY5njS4dfWqvtLhxCQIuVP/Zaid0xZyQ1rbTUGEppp0JjSrEDcyxXjlGQlCWa7U
	 YNCES8giSF7+gPK93wL1CM3GcBLId+FLfXsJulUEmSHbwx0YuRw/J326t5u6LyrhKx
	 hU7ZDNluohqog/jUfmCC3Ewzf+Z4qwUZPYhsGtm+DCr0RNJFXnfY7ZCLdrjUVPY8Zl
	 liVH6jhqhlIHg==
Date: Mon, 1 Sep 2025 16:06:02 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: akpm@linux-foundation.org, mhiramat@kernel.org, naveen@kernel.org,
 davem@davemloft.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/13] x86/HWBP: Add arch_reinstall_hw_breakpoint()
 for atomic updates
Message-Id: <20250901160602.e25f0107e7b0ef4af1078fb7@kernel.org>
In-Reply-To: <20250818122720.434981-3-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
	<20250818122720.434981-2-wangjinchao600@gmail.com>
	<20250818122720.434981-3-wangjinchao600@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EFC7E20008
X-Stat-Signature: ubnwu7o1bkyerttyp139ec78suuk61yf
X-Rspam-User: 
X-HE-Tag: 1756710366-211497
X-HE-Meta: U2FsdGVkX19KlnUlW4+RmD2jiZ8ZcQohsUxE9tMXWlvHV2vET5/zWQuUVxcrJ/G7pQDryCI8o4rFjZTRL2iwAfSAbk855IigxmIHRt3dnTM+eWJe/vygSJiYMbN/R6LmccCL+Xm6CNMgNOw+9m1JnQH4Mv2sYaGiKGtbq2PNFKmVF9sVDtJWQ1TecfpwK+CNPnM1ov5GhrlMjP+y+zquMrAw1W4+9Ggwf+7Op63ImfAEYME8aXoN1jIcmtM64PGcG2G8nu9J7Vqdi5FN1PxgQyJkycMoIqsbOho28KIj5KVLpoaRbmmBQ2EIL1l2tylbt6q+pX8G/TszWdk7+0zxAfWo+d3tbVdURGuBaI848DI9rdyfGisjXX3XXT84tNW1EFRkWXMVMlerTXbvcnMM3L4GzUA2G6lZmUf7HoeKDVnqD99YlUZMM5dxIQxm/mDiVwjYQxQoQzTs6dvAYf/cht643TfVbBBOxM3F5SM+92nxxssmoUclfPxeHtJ1tl17TcXABBrdYcPk9hwT8lZoStYhqe9+TdLeJ2IMgsc2SsqrExN+1wxH7x+FR73Mv0ZfjFvzGeBt1J7DuOHdGmgY00HQxmM0hi68beWoTxEhY8EJBu1PMqX6WxaED6OVNWGj/rwigAxmSeYKMerp3aTkhVFMclrlZ3/B1s085dtU1PMY9kLRmQcx4Lu9bkFjirlw0+Foi6iFvIGsiyJyhr4eyp8p/RxBZtRDPIOWZ2rJyYNXC8aBGkjKjPmA/0LjgA7HElkmknT8T+KtZWR2Bv4Xou2RbU0ok1N73nEONqsq+T5BtDqPJbDOPqGbYtPnBwFyfpDrsvJ7Dy4WU5KkdNpyZpeFgPdLoOGoA3koR0rlePxNrCpizFkolyGJkdUU9WOpvNgbtMi6cLHwX6wbaTmFiYJYBh7hDLMCPAkRFxl3EeURWO5V1mGv5F7nQkKcP3GFYd7tlwdJ8BZf5NERxDb
 WfN1iI6L
 C/VM2IUTN9W7vBMx9vCSOBkNf1PJxdra2P/4WXu2tnpbQvY2a/8qmFuW7gyQPMBm6MamQtfMDl2UFfjh8dbs+rtQ7kAb2a8NKLi4ZbqB4zjvvOjii5iUkhfIkBh0qXtBPO2xDzgIJcMaAgnQY0jYLghV+CcONX6bI+FfKEHdEPP00MshSkS69BRMrGWJFrlNNZkjSyrqc7IYquU23J/Nk6mdxlYTHmTwvP7vz6HABlkIttRu41dNuR4tQlAlBro4EiHekUG4pL/3IvTU8me6QH1xbJoRIrLZUNDYb2ZrQxJISH+7M6WCxBccPl/o/nlXF5NViYAVEh7YcTiDJoRBrYGOlmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jinchao,

On Mon, 18 Aug 2025 20:26:07 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> Add arch_reinstall_hw_breakpoint() to enable atomic context modification
> of hardware breakpoint parameters without deallocating and reallocating
> the breakpoint slot.
> 
> The existing arch_install_hw_breakpoint() allocates a new debug register
> slot, while arch_uninstall_hw_breakpoint() deallocates it. However, some
> use cases require modifying breakpoint parameters (address, length, type)
> atomically without losing the allocated slot, particularly when operating
> in atomic contexts where allocation might fail or be unavailable.
> 
> This is particularly useful for debugging tools like kstackwatch that
> need to dynamically update breakpoint targets in atomic contexts while
> maintaining consistent hardware state.
> 

I'm also trying to find this interface for my wprobe. So the idea is good.
But this looks hacky and only for x86. I think the interface should be
more generic and do not use this arch internal function directly.

It seems that the slot is allocated by "type", thus, if this reinstall
hwbp without deallocate/allocate slot, it must NOT change the type.
See __modify_bp_slot. Also, provide CONFIG_HAVE_... option for checking
whether the architecture support that interface.

Let me share a patch to wrap it.
I'll send my series with this patch.

From 9813e9d003f4691b5fe408094a02bd9e6a5fa249 Mon Sep 17 00:00:00 2001
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Date: Mon, 25 Aug 2025 19:37:24 +0900
Subject: [PATCH] HWBP: Add modify_wide_hw_breakpoint_local() API

Add modify_wide_hw_breakpoint_local() arch-wide interface which allows
hwbp users to update watch address on-line. This is available if the
arch supports CONFIG_HAVE_REINSTALL_HW_BREAKPOINT.
Note that this can not change the type because it does not release and
reserve the hwbp slot based on type.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 arch/Kconfig                         | 10 ++++++++
 arch/x86/Kconfig                     |  1 +
 arch/x86/include/asm/hw_breakpoint.h |  2 ++
 arch/x86/kernel/hw_breakpoint.c      | 11 +++++++++
 include/linux/hw_breakpoint.h        |  6 +++++
 kernel/events/hw_breakpoint.c        | 36 ++++++++++++++++++++++++++++
 6 files changed, 66 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8e3fd723bd74..bec164bea0ec 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -409,6 +409,16 @@ config HAVE_MIXED_BREAKPOINTS_REGS
 	  Select this option if your arch implements breakpoints under the
 	  latter fashion.
 
+config HAVE_REINSTALL_HW_BREAKPOINT
+	bool
+	depends on HAVE_HW_BREAKPOINT
+	help
+	  Depending on the arch implementation of hardware breakpoints,
+	  some of them are able to update the breakpoint configuration
+	  without release and reserve the hardware breakpoint register.
+	  What configuration is able to update depends on hardware and
+	  software implementation.
+
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ad7a6d139006..ca8331522c07 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -249,6 +249,7 @@ config X86
 	select HAVE_FUNCTION_TRACER
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT
+	select HAVE_REINSTALL_HW_BREAKPOINT
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK	if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index bb7c70ad22fe..b3db25eb613f 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -64,6 +64,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 void hw_breakpoint_pmu_read(struct perf_event *bp);
 void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
 
+bool hw_breakpoint_arch_same_type(struct arch_hw_breakpoint *hw,
+				  struct perf_event_attr *attr);
 extern void
 arch_fill_perf_breakpoint(struct perf_event *bp);
 
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 89135229ed21..7dfc88ff6cd9 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -278,6 +278,17 @@ int arch_bp_generic_fields(int x86_len, int x86_type,
 	return 0;
 }
 
+bool hw_breakpoint_arch_same_type(struct arch_hw_breakpoint *hw,
+				  struct perf_event_attr *attr)
+{
+	int glen, gtype;
+
+	if (arch_bp_generic_fields(hw->len, hw->type, &glen, &gtype) < 0)
+		return false;
+
+	return gtype == attr->bp_type;
+}
+
 /*
  * Check for virtual address in kernel space.
  */
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index db199d653dd1..eb14f9ab5bdb 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -81,6 +81,9 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context);
 
+extern int update_wide_hw_breakpoint_local(struct perf_event *bp,
+					   struct perf_event_attr *attr);
+
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern void unregister_hw_breakpoint(struct perf_event *bp);
 extern void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events);
@@ -124,6 +127,9 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context)		{ return NULL; }
 static inline int
+update_wide_hw_breakpoint_local(struct perf_event *bp,
+				struct perf_event_attr *attr) { return -ENOSYS; }
+static inline int
 register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
 static inline void unregister_hw_breakpoint(struct perf_event *bp)	{ }
 static inline void
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 8ec2cb688903..473a5b76941d 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -887,6 +887,42 @@ void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 }
 EXPORT_SYMBOL_GPL(unregister_wide_hw_breakpoint);
 
+/**
+ * modify_wide_hw_breakpoint_local - update breakpoint config for local cpu
+ * @bp: the hwbp perf event for this cpu
+ * @attr: the new attribute for @bp
+ *
+ * This does not release and reserve the slot of HWBP, just reuse the current
+ * slot on local CPU. So the users must update the other CPUs by themselves.
+ * Also, since this does not release/reserve the slot, this can not change the
+ * type of the HWBP.
+ * Return err if attr is invalid or the cpu fails to update debug register
+ * for new @attr.
+ */
+#ifdef CONFIG_HAVE_REINSTALL_HW_BREAKPOINT
+int modify_wide_hw_breakpoint_local(struct perf_event *bp,
+				    struct perf_event_attr *attr)
+{
+	int ret;
+
+	if (!hw_breakpoint_arch_same_type(counter_arch_bp(bp), attr))
+		return -EINVAL;
+
+	ret = hw_breakpoint_arch_parse(bp, attr, counter_arch_bp(bp));
+	if (ret)
+		return ret;
+
+	return arch_reinstall_hw_breakpoint(bp);
+}
+#else
+int modify_wide_hw_breakpoint_local(struct perf_event *bp,
+				    struct perf_event_attr *attr)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+EXPORT_SYMBOL_GPL(modify_wide_hw_breakpoint_local);
+
 /**
  * hw_breakpoint_is_used - check if breakpoints are currently used
  *
-- 
2.43.0


Thank you,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

