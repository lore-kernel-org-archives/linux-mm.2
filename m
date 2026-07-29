Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F144C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 18:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B316B0088; Wed, 29 Jul 2026 14:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41CCF6B008A; Wed, 29 Jul 2026 14:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B176B008C; Wed, 29 Jul 2026 14:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 051A96B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:08:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 922421A0773
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:08:14 +0000 (UTC)
X-FDA: 85042598508.28.24BCC1D
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8D4C31C0014
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:08:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rostedt.org header.s=fm3 header.b=JRdh59Gv;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="b +GMsB8";
	spf=pass (imf21.hostedemail.com: domain of steven@rostedt.org designates 103.168.172.154 as permitted sender) smtp.mailfrom=steven@rostedt.org;
	dmarc=pass (policy=none) header.from=rostedt.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785348492;
	b=eUt/9l7sojAalSHHGLo0dNDKOUkzhUxSmsAhL1RB7PiY0WUPw43jtPCwKo1a8pbDqVp3ku
	avfGxcu7j20CXkFsGA8LgWmvWN0SEUr642hlSA7drVzC0wdYu8IXdqkUmOsG4votL7OExb
	pO8Mt3qoTWyk8R7S+ZrQciOz6VuypLY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rostedt.org header.s=fm3 header.b=JRdh59Gv;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="b +GMsB8";
	spf=pass (imf21.hostedemail.com: domain of steven@rostedt.org designates 103.168.172.154 as permitted sender) smtp.mailfrom=steven@rostedt.org;
	dmarc=pass (policy=none) header.from=rostedt.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785348492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwF6WahzMHm2895PJCZr64azvFZo3rJf0ZJJcnJOyTI=;
	b=E8ESmVzs3H7Ri8kNVlOk/5O4DaSSgOIpE/ejN9dAyw4DtLWrQ4b9JE2bDuobLAhHCoTSyM
	abGwlErKyEATfPlg+JtspIRJo3OJVW+LRWC/3K8E24prjaHglxrRK4EmWj1NRHgXW/xJRg
	QsnV1jyXG9XORYDnPMgmtinwN5XS/6o=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D8C4014002E6;
	Wed, 29 Jul 2026 14:08:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 29 Jul 2026 14:08:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rostedt.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1785348491;
	 x=1785434891; bh=NwF6WahzMHm2895PJCZr64azvFZo3rJf0ZJJcnJOyTI=; b=
	JRdh59GvEw2YJjNl4b0sb2XXDN/Wb2PCc/JW2F/OV/a7kRmZ1FITXfoI7p0tHTaa
	PQfszlVejq3AKOGIYMQOVDwUGQBfYl9XxtIiJpAMGDFPb19lvoltUVFNTztlks+m
	Om3B8fS/cHK/74JHMylRgDm0kSQ/X/s2bPIacOm35jJTKdriFb5QGfpQJrY9FMp9
	loU7WNOFAV1hd+pI6vt6xPrgbEzy/j9+0r++VSFSWVmBJrcYasOnQHuDBamNUDP+
	Pj9vL0+thOKtr2e3HD437RT4jjVTaIqyy65XLoJKhVDrTKwWbImbXZejxFV5TPZj
	FC4mTzZlGLCfuGEtRglsfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785348491; x=
	1785434891; bh=NwF6WahzMHm2895PJCZr64azvFZo3rJf0ZJJcnJOyTI=; b=b
	+GMsB8BaZzp9S8uTtN2iW19GRLMCZGSp3VyhrRheqXMvJBLUaMENric23PgprnJD
	nHSxBtYmlEnhyGrwozhx+cQ/0W5yS1t6L3oP2Dld7mD+CLhv+BShND6GcBiRYBaP
	8Iy2MSEp9eAT+Q8oT76faaJF7Mh87fdOBkEJ1GnPYlvTL2Bf4GQIzP3uZfrHxaTe
	dogakftHkBPHR29e/nmeBME5RrgL7UndR6O031XBs9L1Sf6iF+ws0WLch4hGsprZ
	NEYtQI5v2663sQ4i5x6upgzj0Izl+uevzcFEWIYWJ3qRAimaR4lShiX0FQf/hoRD
	aSINvusbC8nowItbuWp/w==
X-ME-Sender: <xms:i0FqahhvI6KHKauYf_IyzQZIy7_zl0CAr-6dWfkCngQGSu2O6gNWxg>
    <xme:i0FqamaRFOOyx-jGTE4cRmB_MMTOoDuv7vtzGXnUCgoMptFFHi9YOOIbrq7BpeUIk
    Mb3edO6KE5cq8dGtjqfMOsqO4BNirUMEl8Z_g_DXmPx-39El-yG26o>
X-ME-Received: <xmr:i0FqaiOaJSdwHME7YRhRV89o6RnwAiqdny4zwCKU1urScVh8w3DltkhOEzMcVLnU3tJxM4eN>
X-ME-Proxy-Cause: dmFkZTERBjXApnrZrwfYcYubtd8IizaaJqU0kamfvzZdOJhvnPPUf06TI5DFPDTIcatc28
    2an4NFY/41OsegM7YIizOcF3moFF5tPsTqvOEWMQ49m/J9ujLJLevMme8PQF2WUY5QmBm6
    nz5aape8gfrzo7xjNg52J0NJs/H4wY2qB2dO5GSMsEmMJIUk/rcHiWJhe20Z6NwiObz3Zq
    WST4S9B1DwsDaGGoeQe7/o/DEIO98FM6f2Pi93sG4xJiOjE4RmWz9v5f/bX5w5JPRan3cw
    07qPOtAsZ2FWnKk+GUM3y2FQotAisp7eo1YGmOF5z85KHeLwJts5U1vJy5sA5C2K8HGZOk
    3Bjp6FkzfsKLiass48861fo/4E0zzIvGq6ByRJTsHEwMciPmcsNZktiMu5OhwEmv57UMXo
    ZKc/YcbrEZqakZat4X2VOMt1S71EUwUqpjXyCW4MoE7F5GSFUp8vdZEFBwwXM/ghCGugAU
    BOZyy/vjfXooose5kT6eg2PhaoNf62OTrq2Cy55Rp22J22kjvzvz/vMBQW0s8QS5+IvJ9z
    m7rnUc8W0NlQn7g+fUcB7JlG/CT+z6MrN7Aqy8BEP5cx0sxrtyVKUChNUFRs3CeFp0UnHO
    7pl2URwtEkDfDgPeNdo14bH/g924Y+OGcIPl2hCq/P/K4kryJG6+lvlEz+OA
X-ME-Proxy: <xmx:i0FqaiTEk4Px3IqRWyOkYSyoiqXYfXwwX1WvdWljVc7YUMXKh5-unQ>
    <xmx:i0Fqat7fgWxLdBgGJXISIihWXY6hiTMv6aNJjTAN7jmgXHhrHMb6yw>
    <xmx:i0FqalZt0XGFuASztUrqxEPNuEGH_xf577Ar7ulgqgxf4GO_06xlag>
    <xmx:i0FqahZv1EOEd6ncLcch_4PePD-5cJpSomOqh2vqcgvENPJRFiuY9w>
    <xmx:i0FqatanVUSGSY54zh1guP6xSXN33irC96kRL2jFnJmgAxSp2N8YF8xV>
Feedback-ID: id06e481b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 14:08:10 -0400 (EDT)
Date: Wed, 29 Jul 2026 14:08:46 -0400
From: Steven Rostedt <steven@rostedt.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Hongyan Xia <hongyan.xia@transsion.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Oleg Nesterov
 <oleg@redhat.com>, Naveen N Rao <naveen@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Jiazi Li <jiazi.li@transsion.com>,
 Pu Hu <hupu@transsion.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, "llvm@lists.linux.dev"
 <llvm@lists.linux.dev>
Subject: Re: [RFC PATCH 9/9] arm64/debug: Mark debug exception helpers
 __always_inline
Message-ID: <20260729140846.3c18f437@gandalf.local.home>
In-Reply-To: <eb38b41ae1b3216ec69fb45555ef5df57efd7b8d.1785153469.git.hongyan.xia@transsion.com>
References: <cover.1785153469.git.hongyan.xia@transsion.com>
	<eb38b41ae1b3216ec69fb45555ef5df57efd7b8d.1785153469.git.hongyan.xia@transsion.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D4C31C0014
X-Stat-Signature: exypsxskau8hdud1ct84k4s7ikr6xufc
X-Rspam-User: 
X-HE-Tag: 1785348492-556847
X-HE-Meta: U2FsdGVkX1/t+LiFFO6zs/TpbYmy+2+FG4PUYMwjb+UFTJrFNDjn/ico7UvzZbUlt6TmZQRBFBzQwH2VmmT6ulMw7UR8Wdx+xcEUF8k6OUb7Bs9NE37M5zyDXPmVhZN1GOjH4SPH02begxueR+NbVPdrp2IcUsuR50qcO0Gvmv+YD/Gjb+nUrNZlVYO1zW1AVNKtGuBzuQbIQa1ZHQv4wuV8irDZP+9ypMBkc1mLlpq0mtOBCj/jw0W66X1SmSqysLl43Z9FWybm3J7ECc35vNNGiYReQpchn/aqXnj9s8z13qJh/Fa1+IB3GlJtch4Z0H382P+QnupA40spYH5C6Ims1jFZ2eRTmK+jsIZxRsogCYPzo86usal4isb8jtBqOqKBerwMmOxEMrE659n4DXMirGzZax8mo9VzShPHoLleNmRW0NLEIffpEeNwhCPo/lL+JFdY9qG1bMWga2Io4/hLlIhQsEH42QIhISUUAAF8fuqBNqGZo/Z5D3SSVbjs5VaVeajEEpie44N940AvuHRUuT1KCMuGRgwmFzGb/WETXGo+Z8ZLiYPAHuSI4t+DhWYXTpxTt/3308kE7bKTojgKmB4CxQI3EsarbvIoRwwVV0yIO+7uYikMz5Mc5UI+RwwKeBM3HU+znuOuuqiC28yFP73jIr1P9HTfqn0/nCuu2JI2tiy6PTkaqnwsqaPPg5mfPj94hWzg5T04zDThYivnF+97akqO80nw0p7X3CKCwY6VGcw55JGnEtJKSZIk591Z6vOeFD9+wTxmAL/zEVs9fe/nPXcxktXi8ier5K47G8Vn6GK/1kie+QSO24nJ029JoKacjKxLThT2Sc8DRVFygOMk/N2oikHE4o0wEmBfhMDszmdZOMjDeZ/ftI23hDvM47y3dQLmUs8b4/qe8ws6ktSfhYVCBsf9DJ++UJg1iwLszrHXYkrXmiynNa9G9JDdp7IGle1X2gsLxr3
 0o7/ZiBB
 t0Z7RMD5dm+oWhHE63GJVBLJiLSCc/RkonWLBL/luNheWcRpGPrb94cT8CROhhVHU7bA6eXnUg+xD1KTJWwjztew+jT3tUze18ggcyXFzA0uQnnfcuK1NOd74/T60wHghdPLznrhpX/Ud9uDtTZDFucpOth4yZhHLo3orVlOXfs9/tluuW05mysB8Xy7lKlcB9tTjFxTIEza1ZEx99k5BekWaIrKerWYgt3m48CHbmAIVBZU+OcCGsMNqX2COJksAZXKyvJlIz0I19r/jscMgZo29SreA6K5FWBF9ywnzS2+geoBBJuZ5TVbMcLlndnuRephtvYsZ7NxhpeGicFgh5X2S794Kz5nJnHZiiRupIbqWdvz+HdSZmEy8PoIQ/Ey8+WxZdEIzA1gmtTH8yMdCdMyBSRNWXxhDQJXo7CvuyuwUBiOewzSnNDWTnv7Efr6iYVvN0v6XW54eYTITpLn1QEEukQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Masami,


On Mon, 27 Jul 2026 12:25:48 +0000
Hongyan Xia <hongyan.xia@transsion.com> wrote:

> From: Hongyan Xia <hongyan.xia@transsion.com>
> 
> Static inline should be enough to actually inline functions for most
> compilers, but my Clang-19 somehow thinks it's better to outline them.
> These tiny helpers then live in normal .text sections instead of
> .noinstr sections, violating noinstr.
> 
> Mark them __always_inline so the compiler can never outline them.
> 
> Signed-off-by: Hongyan Xia <hongyan.xia@transsion.com>
> ---
>  arch/arm64/include/asm/esr.h       | 2 +-
>  arch/arm64/include/asm/percpu.h    | 2 +-
>  arch/arm64/include/asm/preempt.h   | 4 ++--
>  arch/arm64/include/asm/ptrace.h    | 4 ++--
>  arch/arm64/kernel/debug-monitors.c | 2 +-
>  include/linux/kprobes.h            | 8 ++++----

Are you OK with this patch? If so, can you ack it?

-- Steve

>  6 files changed, 11 insertions(+), 11 deletions(-)
> 

[..]

> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 8c4f3bb24429..5880445ed0f0 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -384,17 +384,17 @@ static inline void kprobe_ftrace_kill(void) {}
>  struct kprobe *get_kprobe(void *addr);
>  
>  /* kprobe_running() will just return the current_kprobe on this CPU */
> -static inline struct kprobe *kprobe_running(void)
> +static __always_inline struct kprobe *kprobe_running(void)
>  {
>  	return __this_cpu_read(current_kprobe);
>  }
>  
> -static inline void reset_current_kprobe(void)
> +static __always_inline void reset_current_kprobe(void)
>  {
>  	__this_cpu_write(current_kprobe, NULL);
>  }
>  
> -static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
> +static __always_inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
>  {
>  	return this_cpu_ptr(&kprobe_ctlblk);
>  }
> @@ -449,7 +449,7 @@ static inline struct kprobe *get_kprobe(void *addr)
>  {
>  	return NULL;
>  }
> -static inline struct kprobe *kprobe_running(void)
> +static __always_inline struct kprobe *kprobe_running(void)
>  {
>  	return NULL;
>  }


