Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 325EFCA0EFF
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 01:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29FDB6B0098; Sun, 24 Aug 2025 21:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251306B009A; Sun, 24 Aug 2025 21:01:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1670E6B009C; Sun, 24 Aug 2025 21:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 047FE6B0098
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 21:01:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8B34565FF
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:01:49 +0000 (UTC)
X-FDA: 83813477538.29.46FE914
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6DA3E14000C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:01:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tiGwmXPo;
	spf=pass (imf09.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756083708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT7fyki4cRVVgwQPXO+m+tGFXjnan9mDi20ca9rK7Dw=;
	b=Sgut100TVF8wpFkS6nq3ejbnDb9Pev2GKwrzoeiwB7gmQAkNLiAVqXX/jVft6CTpU+DmhH
	D0YIhtp6I/g3fEna5KtY0SeVy2Ou8dFlbapG6knVgq9eTK1NubnwhDubR8deNHgUUNcvgj
	6+REjH4I1D9ETnpWa6ky+stkXtjAQ+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756083708; a=rsa-sha256;
	cv=none;
	b=PHK3C5IPP2mCckjWdpleOUMC2ZsJIBmUFzhblXNlIJkqQ2fmuKBw0jiuNUQ7XaEF2Qk+0V
	Wxh/66BAPDIOjznlmqPmoA3jJ0xef/4IuXrxUZkg05J1oTDDqNLzNGFKq43oG6yzNjaFZG
	W+Qn5w0pTsl1yx+xTfZTyj3ZZ+JLaKw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tiGwmXPo;
	spf=pass (imf09.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756083703; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=hT7fyki4cRVVgwQPXO+m+tGFXjnan9mDi20ca9rK7Dw=;
	b=tiGwmXPoXYeNquWUg+tYm5AfvUfsiaJzVZYUNwdf/hvBsxl53vHPvmdIGNNeyl/QzornbqzQw+LYqH/bf1QJ0XvGWoY/k4gcPbO/AAYR69LMIVvTNGY3Xqv+OpqDGxzs2RRaMcCd3a+jU9uFXrA5PEWTOJJsNeO9f72QEgFLfac=
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0WmPcp-O_1756083701 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 Aug 2025 09:01:42 +0800
Date: Mon, 25 Aug 2025 09:01:41 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	paulmck@kernel.org, john.ogness@linutronix.de,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] panic: Clean up message about deprecated
 'panic_print' parameter
Message-ID: <aKu19RZ4tffb8eNC@U-2FWC9VHC-2323.local>
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
 <202508200907.PsZ3geub-lkp@intel.com>
 <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
 <33a897b4-7d9a-4641-9c7a-07c19bb9cb6f@linux.dev>
 <7a34da58-874d-4271-9dbb-7991468d58ff@linux.dev>
 <aKWWcPOf9qPIoCe4@pathway.suse.cz>
 <aKWYELPjbhC7R8NO@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKWYELPjbhC7R8NO@pathway.suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DA3E14000C
X-Stat-Signature: 315w14z8sfm9y7fzsh5xau4n3cwtcnaz
X-HE-Tag: 1756083706-113668
X-HE-Meta: U2FsdGVkX1+xKuFvWsPPMMx3ZjOYRq0UsuYykk9lrBYoFYBMnua5QLbSLpwQU2SpKa6Y8s9klqSywF499dZqdYnUS/IiGgpJIRbJkgiZypSRwwNU93it5qBJHfthw57rcjsQzOILFuWZCvUBOZpz3m+T4OZ/PH01KAbXV2OS1sO5JBMSVXLidCYNCYZ3w4gzRiAs9WyOwT9KG43EAYmhv0pU5mePAJ6ZE5UyVMq8O2ci5YSoZeEymEvlX1vBhxLch7NF3J8AgAeLT4gh+fAsFxd3XGIzbFfkX9SdXXfmPtUz0nl1D/MUmppWUNV+7X1AwFiebCYa6Z8wPX8XRWarUgo3V5o5NNxpa6QfKFBS0/17XSiLMOMK9vHLDJEDoG6kYMQBdgjjLrypWxuwITT3mklFZbn7Miyw/eNFKZKOCGUtiby1FLzPv91PSp58JqqhIDuWfUx/DqxL5fpylnEg88AsvFQ5xIdzTn/7rNZuPE+Lp49zHk/TC2FE7CCw2B9rcMyAs1cMft5/dwdcvnjscz3gWcoDz6k2mP1aV6MuahgvkexQg9WKc7Twlqtp3oHouM6knBAKdpomipCP9Hz5n3RqgdllHTM9vjsK118/NuBkR+67B2EiUw79X+K4iJJ2zKvfMQ3ld0p055uTwLQc03zj7CzoYlXy/x9zrnj95AeA7Qn4JbYfY9kgKKbd4MryrWdKExLIx7/TkramBzXRCCnUlMly6LTvPWKKE/t+KBuxioUNlkBOLEpWs3GJCe87sGV/3T2sTwTnzKNle7/RtN6YvUcKIs11bxdUAA4Y2wPmI/04RCaTveZx6dmMr0wPdpQEomdqRT9Ral78QaQH5Ov06tajvShTkULk6tlLbz6w/Ul48lMUyve3QB0evr6m7EpEoxkiaAxU5o8PlPAam9bbm1uHvgOoSauLEZ0L/ZTlHkomgCWL14FJqKONo1i/GDBLcYC89vTBaNM3tvw
 7fnLH2o+
 YfuDpOw1sNT9m7acNv3xbg3ZpJDF2I3z1aocim+cYY3W2DjlcsV+IUijOut1yW/y4luuWEUOegOk/zC66ajowH7mWnEGdoO6pO/r8+5ulm/anCSF6JH1WUzopAsHR619wXKp13u0G3uOUrIsuRN7eHw0ZqHqFYqFS6vsfIjcpowOfPZQIhvyXHno0FiOGWpat5L9sZ0osd7gKswUJsP0FMYHMInt3BWGQiVbN1oEhJvKIBUcpO18pkuLuwFzxtBxSU5Nw82lX2wLYFnimNikLVlnK/nEJyXu8TRCjjbCnrQ9qs2n6AArO6wNn0at/5E6MJg8uEoWFJRNhxsQrmfDWs2g7F0M2oqDvWBkEnscjlyIvXBTt9gbNnrL7Nw51ZtCB5M2Xey21IwRbTwVegT2yqGoWIQTtYfwoiE+Ta2Ind5spQdk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 11:40:32AM +0200, Petr Mladek wrote:
> Remove duplication of the message about deprecated 'panic_print'
> parameter.
> 
> Also make the wording more direct. Make it clear that the new
> parameters already exist and should be used instead.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Thanks for the cleanup!

Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>

> ---
> Changes since v1:
> 
>   - fixed compilation with CONFIG_SYSCTL disabled (kernel test
>     robot <lkp@intel.com>)
> 
> Thanks Lance Yang <lance.yang@linux.dev> for debugging the compilation
> error reported by the test robot.
> 
>  kernel/panic.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 12a10e17ab4a..24bca263f896 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -77,6 +77,11 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
>  
>  EXPORT_SYMBOL(panic_notifier_list);
>  
> +static void panic_print_deprecated(void)
> +{
> +	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
> +}
> +
>  #ifdef CONFIG_SYSCTL
>  
>  /*
> @@ -125,7 +130,7 @@ static int proc_taint(const struct ctl_table *table, int write,
>  static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
>  			   void *buffer, size_t *lenp, loff_t *ppos)
>  {
> -	pr_info_once("Kernel: 'panic_print' sysctl interface will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
> +	panic_print_deprecated();
>  	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
>  }
>  
> @@ -944,13 +949,13 @@ core_param(panic_console_replay, panic_console_replay, bool, 0644);
>  
>  static int panic_print_set(const char *val, const struct kernel_param *kp)
>  {
> -	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
> +	panic_print_deprecated();
>  	return  param_set_ulong(val, kp);
>  }
>  
>  static int panic_print_get(char *val, const struct kernel_param *kp)
>  {
> -	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
> +	panic_print_deprecated();
>  	return  param_get_ulong(val, kp);
>  }
>  
> -- 
> 2.50.1

