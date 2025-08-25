Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3086ECA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 10:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5D18E000F; Mon, 25 Aug 2025 06:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57DD68E0001; Mon, 25 Aug 2025 06:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493BB8E000F; Mon, 25 Aug 2025 06:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35AA98E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:31:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0F051DD540
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:31:35 +0000 (UTC)
X-FDA: 83814913350.12.668B393
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf07.hostedemail.com (Postfix) with ESMTP id 124634000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:31:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lcsdjk5W;
	spf=pass (imf07.hostedemail.com: domain of mhiramat@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756117894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPoWKoPx6eYI6FGnlMh7W5NSx1OwZh/ovPZpP2CoK9A=;
	b=YHASoyxw/lZtIwsiNZtVV2s8jgql0hA4m3L0SMergn3Ivd9N7z0dUE9NJ8wIoo8w6AgPyK
	Ai65OuhLQI5Ejj3Iq141eTfsY3Ig+CtRoL9KkSxN4LwAVP1lTNk1BbVOV4eaeWwC0VK5rw
	BTFY354NtMrm22T67prXp5NsxiItn/U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lcsdjk5W;
	spf=pass (imf07.hostedemail.com: domain of mhiramat@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756117894; a=rsa-sha256;
	cv=none;
	b=c50gd2lQEc0j9ExKlaWNE9pDyOt7COVnC4fhOlr+1qUq/aN0GNZ4URspb4qn8VUdlGBypE
	lScx4zfrEN16rrpBXDRbU0OjOA9/BSI4eDLlMR56Bqtub7bjR/T+J41MJCvZq3+UyilcVN
	fmYiJko4VPMGUcJQ0HCyn/xMTHGiB78=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 769B65C5A0A;
	Mon, 25 Aug 2025 10:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AE1C4CEED;
	Mon, 25 Aug 2025 10:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756117891;
	bh=DagyeZFyvQvu9dcSKHqH6sIuhOg3IuDx1uJP36Hi9Yw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Lcsdjk5WPEu5YcN3zcRiAuHS5TcZGkyS8HxubNM7obfocjx37IjRtd6HK/w73qsP0
	 erN8QRG5I4xEkNsDRoxSlD6ZKrlX86qjb+/q+ynIniTAy6SalxIXl+d+2F7mwjUJDV
	 RsOBMANh/+1M2Vu2c6/2LrEAYMIYDgxhFOdZ88cIUTVTkhck8vaOmulpyN4xZlS+rl
	 h8D6fbqOUsdiwbSOyF19Pz61tMmfE2LCuylCDhJjkaCa/vOQdCyFNzwqt3fiavcoXC
	 DpcxaBuoVkeW7VYaVFkPpRaQP52ntahv+AylTq0oGsX5haF6EZzNzfH/BuoS9lYsVq
	 zkC15AwIMtuuQ==
Date: Mon, 25 Aug 2025 19:31:27 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: akpm@linux-foundation.org, mhiramat@kernel.org, naveen@kernel.org,
 davem@davemloft.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 07/13] mm/kstackwatch: Add kprobe and stack watch
 control
Message-Id: <20250825193127.a0acb9831733e0e51a5ef81d@kernel.org>
In-Reply-To: <20250818122720.434981-8-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
	<20250818122720.434981-2-wangjinchao600@gmail.com>
	<20250818122720.434981-3-wangjinchao600@gmail.com>
	<20250818122720.434981-4-wangjinchao600@gmail.com>
	<20250818122720.434981-5-wangjinchao600@gmail.com>
	<20250818122720.434981-6-wangjinchao600@gmail.com>
	<20250818122720.434981-7-wangjinchao600@gmail.com>
	<20250818122720.434981-8-wangjinchao600@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 124634000D
X-Rspam-User: 
X-Stat-Signature: fy1sh33hzptw7iwjwzky8sqsz5b7t7sk
X-Rspamd-Server: rspam09
X-HE-Tag: 1756117893-975492
X-HE-Meta: U2FsdGVkX18qukN9/yqhhWEW1gPltboJYbJW2AF3Z6SVlfERqi2r3JvK7J59CaBAfawNFrtI1I9xsQnoeBZY/inzzImvRRPnXnVz6LZ0M5roigAJSrldA+VqJ9ivYMlrvDbyOJpC/f3W94OxHIuOQ5CL/UmVsTYdMu0oueECh5oYwU4nfcaWMaw9tS4W0bxykIuz5XrHXdAf4P/RnfYXv91NAbzuZP+nCWpzY+4hxKxh72nxoFZNCZMzfFq4sr+qQ2uGdoZxG4lsGzTO3DCkNOQeeuXADd+87pD+x8D8SaTFgWm0NVb0tM9QUkWxTzIpwdEOOCIHQm1VNwDFwf7TxUDoWtEXEcmyjGxlqxDatMkLwBuK4w+w5QJYYdUlQbAfW/2MVc2P2lpAOXXEH8C2jAJb84Xw0rOphynwaF/RcchuB2RljvRCSs8+Krt3JFUonb2xYQSH5oHLdY3bgstlxWH1JSxbIGInHdcdAX1kGtU3ZRyFH6tsX+nm18iCTC+vGow9FqY8m1/egYvQY0mytiL6TWQ0xhBZC8tzKNyplHiMqqEhYeSqJQQOPnvSVIsjn3KPTK8mEWs9ajrr2jwg02EPDAf5KgBTaJaeryE2PUdAyucUEBlQGTavPMzzEFDxypuHLW6TfZ6pqDFdu5V7fFeTLLAzguKnCz1w3WM0oOqGQwRgWvIU4gOPfUUC429naVy1bnvLF+NhT8J29IFMJ4NC8YEvSpHd72h2I4IEe+kYBP09dwCXzCuhvOIYdSeWg6CHmkjo1Srapycf6CZPCvTAgcvGL3qC6M/2U7Qnhl+a2ZUIhkQbBomDyguY0plsIqmMrrxlA2TjTjHGztKFDk/82czKPW3gTIBCV84qV8ykv6h7Abx8BCTmb3+X3wRifyKFeg+HHSavZGChHcT64dkJcC6utd+DAaFH+QvbAypCscxxmnxZXXXFYEygOdYUUFnwjr+3Kia6ByNZ6/l
 pZqVtB0d
 L6uzGc7sZvTreegdSRWVfgNPdZj+EcoJFC6G0Aqi6JavBdnFbQMItmZW1dEAQ+fLGq9pItt+TLdY2poq2B3yGukRzX5KUyVCdhHlkBBOf/LsUoYj0vQ1Y8UtmN6IivlDVLB6XkbWbnjoeZGCS2l+rbXmNfcwDMmMr9Jtw9iqj5T7SJ9GOPZ/j4KfynBcBjj2UhG7IVjPxQC1FcLuQexNJbzJXWG0N3uNEt5D/rdFHnqanZj3rsVfWtjnlEAyLFeHwbf5Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 20:26:12 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> This patch adds the core logic for controlling the kernel
> stack watch mechanism using a combination of kprobes and kretprobes.
> 
> A kprobe is registered at function + ip_offset to turn on
> the hardware breakpoint that monitors the stack. This allows
> the tool to begin watching from a specific instruction within
> the function. At the same time, a kretprobe is registered to be
> triggered when the function returns. Its handler is responsible
> for turning off the hardware breakpoint.

Could you use fprobe instead of kretprobe for hooking function exit?
kretprobe is an old feature and will be replaced by fprobe.

You can find an example in samples/fprobe/fprobe_example.c

Thank you,

> 
> By using these two probes, the tool can precisely watch a function's
> stack frame for its entire duration. This makes sure the HWBP is active
> only when needed, which reduces overhead and avoids accidental triggers.
> This also provides a clear and reliable way to manage the HWBP.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  mm/kstackwatch/stack.c | 86 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 82 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
> index 8b558cdbda97..ba5280787e8f 100644
> --- a/mm/kstackwatch/stack.c
> +++ b/mm/kstackwatch/stack.c
> @@ -6,8 +6,10 @@
>  
>  #include "kstackwatch.h"
>  
> +struct ksw_config *probe_config;
> +
>  /* Find canary address in current stack frame */
> -static unsigned long __maybe_unused ksw_stack_find_canary(struct pt_regs *regs)
> +static unsigned long ksw_stack_find_canary(struct pt_regs *regs)
>  {
>  	unsigned long *stack_ptr, *stack_end;
>  	unsigned long expected_canary;
> @@ -33,7 +35,7 @@ static unsigned long __maybe_unused ksw_stack_find_canary(struct pt_regs *regs)
>  }
>  
>  /* Resolve stack offset to actual address */
> -static unsigned long __maybe_unused ksw_stack_resolve_offset(struct pt_regs *regs,
> +static unsigned long ksw_stack_resolve_offset(struct pt_regs *regs,
>  					      s64 local_var_offset)
>  {
>  	unsigned long stack_base;
> @@ -53,7 +55,7 @@ static unsigned long __maybe_unused ksw_stack_resolve_offset(struct pt_regs *reg
>  }
>  
>  /* Validate that address is within current stack bounds */
> -static int __maybe_unused ksw_stack_validate_addr(unsigned long addr, size_t size)
> +static int ksw_stack_validate_addr(unsigned long addr, size_t size)
>  {
>  	unsigned long stack_start, stack_end;
>  
> @@ -73,7 +75,7 @@ static int __maybe_unused ksw_stack_validate_addr(unsigned long addr, size_t siz
>  }
>  
>  /* Setup hardware breakpoints for active watches */
> -static int __maybe_unused ksw_stack_prepare_watch(struct pt_regs *regs,
> +static int ksw_stack_prepare_watch(struct pt_regs *regs,
>  				   struct ksw_config *config, u64 *watch_addr,
>  				   u64 *watch_len)
>  {
> @@ -110,3 +112,79 @@ static int __maybe_unused ksw_stack_prepare_watch(struct pt_regs *regs,
>  	*watch_len = len;
>  	return 0;
>  }
> +
> +/* Kprobe handlers */
> +static struct kprobe entry_probe;
> +static struct kretprobe exit_probe;
> +
> +static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
> +				    unsigned long flags)
> +{
> +	int ret;
> +	u64 watch_addr;
> +	u64 watch_len;
> +
> +	/* Setup breakpoints for all active watches */
> +	ret = ksw_stack_prepare_watch(regs, probe_config, &watch_addr,
> +				      &watch_len);
> +	if (ret) {
> +		pr_err("KSW: Failed to parse watch info: %d\n", ret);
> +		return;
> +	}
> +	ret = ksw_watch_on(watch_addr, watch_len);
> +	if (ret) {
> +		pr_err("KSW: Failed to arm hwbp: %d\n", ret);
> +		return;
> +	}
> +	pr_info("KSW: Armed for %s at addr:0x%llx len:%llu\n",
> +		probe_config->function, watch_addr, watch_len);
> +}
> +
> +/* Function exit handler */
> +static int ksw_stack_exit_handler(struct kretprobe_instance *ri,
> +				  struct pt_regs *regs)
> +{
> +	ksw_watch_off();
> +	pr_info("KSW: Disarmed for %s\n", probe_config->function);
> +
> +	return 0;
> +}
> +
> +int ksw_stack_init(struct ksw_config *config)
> +{
> +	int ret;
> +
> +	/* Setup entry probe */
> +	memset(&entry_probe, 0, sizeof(entry_probe));
> +	entry_probe.symbol_name = config->function;
> +	entry_probe.offset = config->ip_offset;
> +	entry_probe.post_handler = ksw_stack_entry_handler;
> +	probe_config = config;
> +	ret = register_kprobe(&entry_probe);
> +	if (ret < 0) {
> +		pr_err("KSW: Failed to register kprobe ret %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Setup exit probe */
> +	memset(&exit_probe, 0, sizeof(exit_probe));
> +	exit_probe.kp.symbol_name = config->function;
> +	exit_probe.handler = ksw_stack_exit_handler;
> +	exit_probe.maxactive = 20;
> +
> +	ret = register_kretprobe(&exit_probe);
> +	if (ret < 0) {
> +		pr_err("KSW: Failed to register exit probe for %s: %d\n",
> +		       probe_config->function, ret);
> +		unregister_kprobe(&entry_probe);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +void ksw_stack_exit(void)
> +{
> +	unregister_kretprobe(&exit_probe);
> +	unregister_kprobe(&entry_probe);
> +}
> -- 
> 2.43.0
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

