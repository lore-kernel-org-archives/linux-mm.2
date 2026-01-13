Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED08ED2F349
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 17:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3A86B0005; Tue, 13 Jan 2026 12:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580D96B0089; Tue, 13 Jan 2026 12:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462AC6B008A; Tue, 13 Jan 2026 12:48:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 335FB6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:48:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9E6F8A956
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:48:05 +0000 (UTC)
X-FDA: 84327674130.22.4D3CFDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 02046A001B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:48:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OpGZ3yss;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768326484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVf8l5aSkWfwH0xEMRZ4XjWkTOPh6mOEJTs6QwTDAj0=;
	b=qhuEhMaO4CDYBMp/7tpAD2Nj31etce6Xm5hN1Ru/TMDFTfyP8rulC8rrx+kpDvdQNTLU9c
	JyiBdyDPOwk1Z2wGMs2WEptzjZ+9T+krtnK0K+m6zjH6MH7FalHLsqQZb+qjbD2dwCUw6a
	XB0oNIh8z0Ayx4/Shj6u/6ZvQjwHRFY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OpGZ3yss;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768326484; a=rsa-sha256;
	cv=none;
	b=nscQ6YLVWnYFjWNfjMnokWAVF3TDx0WzojZ5779xhQSPeBctdBW7GW+IvY3ixCMzJolwzS
	ulPDAikt5nYfKdNP1OvUeN3q7l7zyBn4ePuoYRari3ljqogl9TsvOpnQ6naVdIFki+t4oy
	wt4/RSyFkZMSochxJgmda9+tgFGCJJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C78040630;
	Tue, 13 Jan 2026 17:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A041FC116C6;
	Tue, 13 Jan 2026 17:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768326482;
	bh=fho/6LES9b2wOoZ4zL2IQJlpYc+Ky63LIbZXUvbTdWc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OpGZ3yssRspFyzKe0wuuKWibepGV8CX9QpjqywYEBNasl/uWFX18DeVp3G2Owc6z6
	 9s5Vnyaf+U+EUIR8hehPDgyxDJJHqv8hb/VrNs7ZAJdOupkJbpsWYjVzqTmB6PMqpS
	 LSzs87KxCwNNwy2CPBrpYr3ut8OxuiXJDMs5onxk=
Date: Tue, 13 Jan 2026 09:48:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Petr Mladek <pmladek@suse.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-nonmm-unstable 77/129]
 arch/loongarch/net/bpf_jit.c:1322:7: error: call to undeclared function
 '__bpf_address_lookup'; ISO C99 and later do not support implicit function
 declarations
Message-Id: <20260113094801.d3c7b9d327959c6bcb8f4db6@linux-foundation.org>
In-Reply-To: <202601140159.I4b0kwpE-lkp@intel.com>
References: <202601140159.I4b0kwpE-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 02046A001B
X-Stat-Signature: qt6ryohdzsa7s7gi9qd4cnugeoe1t349
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768326483-450370
X-HE-Meta: U2FsdGVkX1+eRb4tdhRqMh2wzDzN0WrEoMgFzB+ZjV5HBNg+Px0RSzvZeCDzb5F5vfxCphwZvZbRuWVpq+JEamwL0QQy2m7Ya8TpfoFZriN0u/TLml0kyCjGkdfK4D3eVwm9t5kygrHpQANeZkywSFsuYTFptuX0R0NddCfoWbgjsSS/jgwHNMcF2q+K19eeuT8N/WGkIChB6nfwoW13Q4Hh9p2b4/tHQdQKUCjupcU3Za7OfX9oEKXYZdpkmWe+yNlfSwrRQuDiO1qPtcHw0ecAlENPP9Q5rCq0CMeyAQhZ5nwHDWRZZyCma9V/nx9avrbI2b6K7CteHYRpxHAZf2EdMSnJSOhaLu749E6oU0YLskjnvsJWS5OwWvCGcPYy7kBE+a0PheGNOWmION0W52sDp7NJRK8l1ceNGem6mOsdMyEfmf3/Un8Qct8XF7EngQ08V6er+FpT6NF4WNQLv9DenAquGi8pti/qFGbvErv10v6IYfosCdR7hrN+mTHprvgytMPvKzKfBc6fMyg20tv5QyzPZQolZI9tAsDtSy4ezuHUt3HdQ4iAWL+o0zkd5Ww2TWGuaXjbcEQShcHNsS/2ZL7c6pyIO1DShQww+ImkCdote5RRMUgx7J/qHo1xCW8bPFQanHy3hccJJLo12/eP1AhMxJ1udDodIghSiERlni9dV28jWfwO+2dZyu7IAZ920aHrdnSmzENFii1ptDObcgGg10PgtG+hqIVcMWEw+uvI/L/c/ewZz4NlGLt3NG/DMH1Cz4H9y+G71nnlNNI/CZaGYNhxaiasrYOODOXxoEZI4HLSFy7dUSub+sk4RsQHvShanEfQ48rx9wbfjwzoS0oNGBxKU5uC5b7K73xJonUavzJyRM2ybheGsOk/xvEpgCU1aTestQCqav+lmBEoMmSrDrxR9CkqVmOF1JwAWXOW//WZNm6oaaikus7BTiGEX+67ObDoSc5buLF
 SVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 01:37:38 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   01c8de771f4a779caac5d841b1cb2207ac23330a
> commit: 0f1766dc93f077061bf42cc6222bb2ade96422a4 [77/129] kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
> config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20260114/202601140159.I4b0kwpE-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140159.I4b0kwpE-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601140159.I4b0kwpE-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> arch/loongarch/net/bpf_jit.c:1322:7: error: call to undeclared function '__bpf_address_lookup'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     1322 |         if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
>          |              ^
>    arch/loongarch/net/bpf_jit.c:1322:7: note: did you mean 'bpf_address_lookup'?
>    include/linux/filter.h:1378:5: note: 'bpf_address_lookup' declared here
>     1378 | int bpf_address_lookup(unsigned long addr, unsigned long *size,
>          |     ^
>    1 error generated.

Thanks.  Presumably this:

--- a/arch/loongarch/net/bpf_jit.c~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix
+++ a/arch/loongarch/net/bpf_jit.c
@@ -1319,7 +1319,7 @@ int bpf_arch_text_poke(void *ip, enum bp
 	/* Only poking bpf text is supported. Since kernel function entry
 	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
 	 */
-	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
+	if (!bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
 		return -ENOTSUPP;
 
 	image = ip - offset;
_


