Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31A7C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 23:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06EC6B008C; Thu,  9 Jul 2026 19:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB73C6B0092; Thu,  9 Jul 2026 19:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE1F6B0093; Thu,  9 Jul 2026 19:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9696B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:49:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8046120308
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:49:55 +0000 (UTC)
X-FDA: 84970883550.21.4D5299A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 411C31C0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:49:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EHOtvqF9;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783640994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14I/OIUOvPE++U6ixxkq7lr8VNi5s9TDJBiz5Ica5m0=;
	b=5pbpIf9EFujg4pQdpVVxQUccUaeTQgE0peK4IN0WWVJ4KT1Dm1VC4AQUZlBH6DVdF4JxKf
	oxHNx+BjX51HuetD614fFEYecROJqsl4AZi8KnoYyj11TckgO0zGJ6FTAhFhT+jRhxe8fv
	CEBV1cz+gZx7bPs/yJWSpMNOevmFgnQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783640994;
	b=trIyuHOtgz4+uR/LeCzmY4V+6wheDlEfoEXR6z2XirCrkcL+uHT1zf2IZxXB0KFK1kEh+V
	R9Ru2dTcDv74ld/EZWjoxHhVg11qHHY0UK+Jf/hRTEGs3KWViyXhyaBl416aBqCQ+p3Gpu
	wNIk7947Tk4OEp2g3xTCuBMj7+4nhO0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EHOtvqF9;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F6CB600C3;
	Thu,  9 Jul 2026 23:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5341F000E9;
	Thu,  9 Jul 2026 23:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783640993;
	bh=14I/OIUOvPE++U6ixxkq7lr8VNi5s9TDJBiz5Ica5m0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EHOtvqF9fQiz+50/sGzEDe9IPMZTj66d3m1XmucGNT+/13uTlRGuAJBChcLnTgfXT
	 ZuzKJSTIwlv9HyO9OF96u/fzdfx3L1YOL5gboPAzucw371DY4WMjfr6QrV/ugeClmL
	 WNJkapoIk7rowTRHk29ePkCK9zbzUpzuciXhgwl0=
Date: Thu, 9 Jul 2026 16:49:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH] nodemask: use nr_node_ids instead of MAX_NUMNODES in
 __nodemask_pr_numnodes()
Message-Id: <20260709164952.6630ce13f63a3104c2c53572@linux-foundation.org>
In-Reply-To: <20260709071739.2408-1-lirongqing@baidu.com>
References: <20260709071739.2408-1-lirongqing@baidu.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 411C31C0003
X-Stat-Signature: qtq9rh5ntkg6174tnqkwrrhqph44bofq
X-HE-Tag: 1783640994-497349
X-HE-Meta: U2FsdGVkX19rBpB16uBJLimaIhv7uDUJ5TLJdiGWkQ9hLrPNeLNljbsM7egTrLleOX0CQf2CPLe84EW15+hGgswlg6ZQLCnXbIz3vDoiqfGCrHsFL0l4DONLpbMy/Mq+V+XLsp9nQJxXDCy+QPeQfZ+DEm7QsJkf3+GiLUzFPoSm8XguXfSLYQWg2BjcTR/mRfPvIMgxE7DW0jsRB2WGbVnXMCNqEAsuTdwXBf3FJAMzG8DMAmi6S4af8U5ltZyxNA7xn/gSv2JUINp2JoV8SsDKU+rRZJrkOKppptGdhm17kSDUWpchEX07j3+q78O7W+QAblQzsUm/VQtGyZsn3DlvJzpcz3ofyJwaVaqPCj4rbvPHWGfI93sfD5YHUQh4CIH11uLOxfptBFAYBb/zJVjfrVVJk+0O+KyaVB7ToJv6UFDf74jfZ0RZ34PKTauhj3zsM0aO3Xz3clAULth6J7fglR0dK0wGKz5yq+dNqZ6eEd0ayAUU3hNluB8v6ZEOkg/Kx6MSc6yZT6b6gmpcqe1M1AbH86pXqTerPUgfXznbXyWPBIGAvIPwGo7YdxdD5VPOwwr1BmAhaQIPhbJWlo1AxTxzbd9h4XlwvnB+7+ML5+DbJglVSoNxQ2hFdfayXMlwqWE5lcK4dxvJWoJ52XgusTtwQmtaMq5LuUyn4sXYIzuSyxg4betXoc1lZOwzJTZXH65QyYKeTLuLvCNBN2xW3OCAjQG7qC/q3vHCJFFU2qYN3qPQkWHSz5ZGCX5KUgF895w51UGWe4JvuTgVmQqYpk1s/z8u0ISXeuIR3D7sRuO996qSgh34sMPOAqi7gXp1jbluEUEry0J8bDG/QT5uFzMSLVAJRjRUshCIwIyNi+sOrxqXcGPEpfyI3qDsJDbIAXOrCrMJGDvodCKJ4210yuxYr+RyeohAJlgCie0GQvpbvjYVUKlpwOocvfpASHK88jTrzj+qnqx+dvg
 u1gaINom
 FuU2+RzxBQh0MrbZv2z3/FL39fejBdUG3oK/CUu9n+F+uo/QmsuIYSLEN5rPzcMPAQn8AvskdmNJmQQuIzbdfh1MHvJrYwzfmhWep45v1VULL6sHFtafQyPus9tiZ7A8he5/0fazYg/xWKaU6ECIh8/RkcVK9R0KPT5KNBnbOA4gt5PKof02Qj/2Nx7iMtwqS/enLvHcbE8lqDgel0E1fo4guucXNuD5/PL3pPon8QmHi6SWqEY+8mBtjU0FOuflEk2Z2/dfDKlD62vykqS3cfZcHpXsD3Anw+PWFn70QGnF98Tc4Q+1kcZTPgfWdhY+0gT7D5VvjoJEPVVMd+nFiPuEyAcWScQlypVyflKlRkhrgCfAQuYyH6yvdxJUmPo3aH8YXsssTqE6uOOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026 15:17:39 +0800 lirongqing <lirongqing@baidu.com> wrote:

> From: Li RongQing <lirongqing@baidu.com>
> 
> __nodemask_pr_numnodes() returns MAX_NUMNODES, a compile-time constant,
> as the width for '%*pb[l]' nodemask printing. On systems with few NUMA
> nodes this produces excessive zero-padding, e.g. with MAX_NUMNODES=1024
> but only 2 nodes:
> 
>   Mems_allowed: 00000000,00000000,...,00000003  (32 groups)

Please let's completely describe the effects of this. 
nodemask_pr_args() is used in several places so I believe that a number
of userspace-facing strings will now appear differently?  Let's spell
out which userspace interfaces are affected, and how.

> Use nr_node_ids (the runtime highest-node-id + 1) instead, matching the
> behavior of cpumask_pr_args() which uses nr_cpu_ids:
> 
>   Mems_allowed: 00000003
> 
> Move the nr_node_ids declaration earlier in the file (guarded by
> __nodemask_pr_numnodes(), and remove the now-duplicate declarations.
> 
> ...
>
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -95,6 +95,12 @@
>  
>  extern nodemask_t _unused_nodemask_arg_;
>  
> +#if MAX_NUMNODES > 1
> +extern unsigned int nr_node_ids;
> +#else
> +#define nr_node_ids		1U
> +#endif
> +
>  /**
>   * nodemask_pr_args - printf args to output a nodemask
>   * @maskp: nodemask to be printed
> @@ -105,7 +111,7 @@ extern nodemask_t _unused_nodemask_arg_;
>  				__nodemask_pr_bits(maskp)
>  static __always_inline unsigned int __nodemask_pr_numnodes(const nodemask_t *m)
>  {
> -	return m ? MAX_NUMNODES : 0;
> +	return m ? nr_node_ids : 0;
>  }
>  static __always_inline const unsigned long *__nodemask_pr_bits(const nodemask_t *m)
>  {
> @@ -438,7 +444,6 @@ static __always_inline unsigned int next_memory_node(int nid)
>  	return next_node(nid, node_states[N_MEMORY]);
>  }
>  
> -extern unsigned int nr_node_ids;
>  extern unsigned int nr_online_nodes;

Let's relocate nr_online_nodes also?  To keep them together.

>  static __always_inline void node_set_online(int nid)
> @@ -480,7 +485,6 @@ static __always_inline int num_node_state(enum node_states state)
>  #define first_memory_node	0
>  #define next_online_node(nid)	(MAX_NUMNODES)
>  #define next_memory_node(nid)	(MAX_NUMNODES)
> -#define nr_node_ids		1U
>  #define nr_online_nodes		1U
>  
>  #define node_set_online(node)	   node_set_state((node), N_ONLINE)
> -- 
> 2.9.4

