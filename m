Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB453CA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 00:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F6A8E0003; Wed, 10 Sep 2025 20:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2072A8E0001; Wed, 10 Sep 2025 20:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144068E0003; Wed, 10 Sep 2025 20:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02D628E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:46:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B8431A0361
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 00:46:21 +0000 (UTC)
X-FDA: 83875128162.13.E646CE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EFD0240002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 00:46:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QB8At8RC;
	spf=pass (imf04.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757551580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhmCRE1xvUkDdFSmNKcdyJjIq+1gf0S/XmVmi+FDygA=;
	b=Et16qacY6AwmbNjyjo2h3cWSVKmoLl1GsQDhGQIGy3piwdsnkaiNFrgq3Cvg8EcchQ50y1
	MrqWtPuHPIV3WXr9VvVfuTmsND9gYlaaOdzV2WQo+quWef3+JLAL++vmbJbDM7g4XpbKQ1
	wApWgZbGHr4/5K1s8wJIx1kGIoGYMdQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QB8At8RC;
	spf=pass (imf04.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757551580; a=rsa-sha256;
	cv=none;
	b=WpYq5xYWebkuFWq3j2cJrv3rqoYWI2BGQFcgidgm19roqEbNcCii7BhUackTu3N5Hcc5W6
	m3WpT2b1XT2KXzd3zW7C4v3o0X2KneDMErNl5BLOCBW1ITKmS3L1Hk5N6VH8hL22Z23+LE
	wdMf8H8ICRUax9gTZ94CVnFP3zX+ggg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8EBD405E4;
	Thu, 11 Sep 2025 00:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1598C4CEEB;
	Thu, 11 Sep 2025 00:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757551578;
	bh=K99ophOl9mX3e/X5pRAQo+wrGNH1h9Nn1UThydP/v4k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QB8At8RCA1dKGbJGXAjAsWM+cwkq9bWk1fm7K3sJG7vxNVKP6xSSvUurBGZQunMNl
	 0btZsSMe1585w9cxhhmI5GHyWBASKD0Q4vMXuOBuUF017rMfS6ktJFxpWz0HVxJGnU
	 y5dLcJdIDuyFsXsEX5KJdbhpsqRaOJr/F+oB/bidzfW9QlCItd26fNhQmDnfZMJpFW
	 NMrEb7LGYzujvb/h6RaJtJoASDh2u7mhKUkSOhpdgvEQSnpYSkziJp4RAGYhbclueg
	 PlYDR7Q2pWHfKj+AJMSvtMw+Q7ukA7O+IOYYTN6mIWK9FFEaGaYjjQn/PS6X/l/nrs
	 NT3rQC8fJJ5OA==
Date: Thu, 11 Sep 2025 09:46:09 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>, "Naveen N . Rao"
 <naveen@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander
 Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, "David S. Miller"
 <davem@davemloft.net>, Steven Rostedt <rostedt@goodmis.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, "Liang, Kan" <kan.liang@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/19] x86/hw_breakpoint: introduce
 arch_reinstall_hw_breakpoint() for atomic context
Message-Id: <20250911094609.5f30e9767ffc3040068ed052@kernel.org>
In-Reply-To: <20250910052335.1151048-2-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
	<20250910052335.1151048-2-wangjinchao600@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EFD0240002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kyfo65n3r7hj3oabzjnoubz5c3swojqy
X-HE-Tag: 1757551579-987650
X-HE-Meta: U2FsdGVkX1+71Zma0zIYBQjXSIZ0xpwYH3Bo1y+A/2gPUyXHucrBqtett3y3ZmF95h21l3SEBm2T0o05F2LyphGN5clup2VNw3NjMxKE/nWmkP4dfut6HkU+itO9OlxfJJWS5a11zWT2Q3POFW1k/Nmt8HRYLc4ufSRXDPJ4Q066A1EP5nlrZLHcj6QS6IDLxq8PjmU61d6oHWyVtYitBvllDxiPscCFtqlk6dI6olhaJdggv0xutKpdZe3XWU9b271nlUX6C5t4MQz2aXjnLC7qEyrG9flZSEL4pLfyWQ77XAYCzFHzAPC7oeRPlsXFjjJNvTTsPlXn1fRtUhmcckDTSfwaOphMaG0wB/ru+p7Is+Dn95Ah4yBDStA/3cNO/+GgiSQNAm6+9oUYKLjYbnK+QxeUV52ZHmT1x+dbg/uJdQeFvd9do9yiwuDauvQMsAi9Z/Sh1GMw+aLFB9f6Ck98V7pbaummF7Cj6xwaBS08FGgCvutgmzWfBDzM84FCdxDx7cL9DrLr86MnD5udhwmuuif9qWhtC1q4ilyhUJz+GR4Ny+8LO0o9Lia53jnLXVDyxAdlpwiNmGUQz92HS2RNOFEP7C22TB0NgBSxXK4qiEGMt+yFH7/V2MvdxTxg23DwUIiWfQaUg4w4b2HZ/6I9HRR/N8P945LQ5SeoEKQQmPQCX4G61JkGbup7n207mJ4nem2wGOGieMCXQvjwby3Xq2wcdtyVkahUFKdQNOvT+XUqYxuJeJ5z7a1weHjE+9p3Tvw8CPEyzezVF/HvrcFgtc8Ips3SihuE0cQ81aG05R90eEy2/8zIN4ZO4k2rL1JA9FceLSaUdI0Z5BJcjO5UdqW8wG81BEESNWWeUgOqxDr4bCXYKWcGHM8wUlV78ItZyHwIRLco473Abb9Wrup+Iq+pQtf2FXykUOJ8XfVT2HBBg2EC6WP9hRc5YLxCw030Ui/LfeEeH/YPUG6
 BPV5LHJd
 Os+Szzgok1bfxMRB5AyNeC+Wqhb4WwAjeA5xe6cVcGMniBoWxJmy0yH/FXKPfh8yQhZiU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jinchao,

On Wed, 10 Sep 2025 13:23:10 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
> parameters (address, length, type) without freeing and reallocating the
> debug register slot.
> 
> This allows atomic updates in contexts where memory allocation is not
> permitted, such as kprobe handlers.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  arch/x86/include/asm/hw_breakpoint.h |  1 +
>  arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
> index 0bc931cd0698..bb7c70ad22fe 100644
> --- a/arch/x86/include/asm/hw_breakpoint.h
> +++ b/arch/x86/include/asm/hw_breakpoint.h
> @@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
>  
>  
>  int arch_install_hw_breakpoint(struct perf_event *bp);
> +int arch_reinstall_hw_breakpoint(struct perf_event *bp);
>  void arch_uninstall_hw_breakpoint(struct perf_event *bp);
>  void hw_breakpoint_pmu_read(struct perf_event *bp);
>  void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index b01644c949b2..89135229ed21 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>  	return 0;
>  }
>  
> +/*
> + * Reinstall a hardware breakpoint on the current CPU.
> + *
> + * This function is used to re-establish a perf counter hardware breakpoint.
> + * It finds the debug address register slot previously allocated for the
> + * breakpoint and re-enables it by writing the address to the debug register
> + * and setting the corresponding bits in the debug control register (DR7).
> + *
> + * It is expected that the breakpoint's event context lock is already held
> + * and interrupts are disabled, ensuring atomicity and safety from other
> + * event handlers.
> + */
> +int arch_reinstall_hw_breakpoint(struct perf_event *bp)
> +{
> +	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> +	unsigned long *dr7;
> +	int i;
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	for (i = 0; i < HBP_NUM; i++) {
> +		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
> +
> +		if (*slot == bp)
> +			break;
> +	}
> +
> +	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
> +		return -EINVAL;
> +
> +	set_debugreg(info->address, i);
> +	__this_cpu_write(cpu_debugreg[i], info->address);
> +
> +	dr7 = this_cpu_ptr(&cpu_dr7);
> +	*dr7 |= encode_dr7(i, info->len, info->type);
> +
> +	/*
> +	 * Ensure we first write cpu_dr7 before we set the DR7 register.
> +	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> +	 */
> +	barrier();
> +
> +	set_debugreg(*dr7, 7);
> +	if (info->mask)
> +		amd_set_dr_addr_mask(info->mask, i);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);

Please do not expose the arch dependent symbol. Instead, you should
expose an arch independent wrapper.

Anyway, you also need to share the same code with arch_install_hw_breakpoint()
like below;

Thanks,


diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 89135229ed21..2f3c5406999e 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -84,6 +84,28 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
 	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
 }
 
+static void __arch_install_hw_breakpoint(struct perf_event *bp, int regno)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	unsigned long *dr7;
+
+	set_debugreg(info->address, regno);
+	__this_cpu_write(cpu_debugreg[i], info->address);
+
+	dr7 = this_cpu_ptr(&cpu_dr7);
+	*dr7 |= encode_dr7(i, info->len, info->type);
+
+	/*
+	 * Ensure we first write cpu_dr7 before we set the DR7 register.
+	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	barrier();
+
+	set_debugreg(*dr7, 7);
+	if (info->mask)
+		amd_set_dr_addr_mask(info->mask, i);
+}
+
 /*
  * Install a perf counter breakpoint.
  *
@@ -95,8 +117,6 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
  */
 int arch_install_hw_breakpoint(struct perf_event *bp)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long *dr7;
 	int i;
 
 	lockdep_assert_irqs_disabled();
@@ -113,22 +133,7 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
 		return -EBUSY;
 
-	set_debugreg(info->address, i);
-	__this_cpu_write(cpu_debugreg[i], info->address);
-
-	dr7 = this_cpu_ptr(&cpu_dr7);
-	*dr7 |= encode_dr7(i, info->len, info->type);
-
-	/*
-	 * Ensure we first write cpu_dr7 before we set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
-	 */
-	barrier();
-
-	set_debugreg(*dr7, 7);
-	if (info->mask)
-		amd_set_dr_addr_mask(info->mask, i);
-
+	__arch_install_hw_breakpoint(bp, i);
 	return 0;
 }
 
@@ -146,8 +151,6 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
  */
 int arch_reinstall_hw_breakpoint(struct perf_event *bp)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long *dr7;
 	int i;
 
 	lockdep_assert_irqs_disabled();
@@ -162,22 +165,7 @@ int arch_reinstall_hw_breakpoint(struct perf_event *bp)
 	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
 		return -EINVAL;
 
-	set_debugreg(info->address, i);
-	__this_cpu_write(cpu_debugreg[i], info->address);
-
-	dr7 = this_cpu_ptr(&cpu_dr7);
-	*dr7 |= encode_dr7(i, info->len, info->type);
-
-	/*
-	 * Ensure we first write cpu_dr7 before we set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
-	 */
-	barrier();
-
-	set_debugreg(*dr7, 7);
-	if (info->mask)
-		amd_set_dr_addr_mask(info->mask, i);
-
+	__arch_install_hw_breakpoint(bp, i);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

