Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 846A6D6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 21:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B366B0364; Thu, 22 Jan 2026 16:56:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48986B0366; Thu, 22 Jan 2026 16:56:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54F16B0367; Thu, 22 Jan 2026 16:56:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C173C6B0364
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:56:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7044EBF453
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:56:52 +0000 (UTC)
X-FDA: 84360960264.29.5654770
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8210510000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:56:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g0DAFs2H;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769119010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Sju0/uBNJAFaT2N2jcYw51V21Jpb0sazE7YFwzTXAw=;
	b=dWsxaIE3z7R1wKEPSKy+EzOtO4LrQQifPnGghlhKC/CtY566iod6/55McX76xQGnyz1Vfp
	HxyN1THAMMXsypb4w3SPpwJARpMOzeaLgC5xGcnx1gYfHs4bgqWKpVhKfSk2B2vY/Rf4O3
	4vq1FFizafdzgwZmY3kEP10GSKlVrfg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g0DAFs2H;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769119010; a=rsa-sha256;
	cv=none;
	b=goW/08ENPTLQy8VcU9kQeeIDLJG877hVnB1INVfr8/Ky0TLeyFjsM1nLS+itXoAIE/gviy
	cqDJG7eTqq8vwChHKC/KHCeNiMgn90ZnpLqIenC1tvVTkZZXoTjbMDLRnTqeTK1dvICya4
	xpoAqj3wNBIWOvxOu5sL5dIVPKNzJVc=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so4316822a12.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769119009; x=1769723809; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Sju0/uBNJAFaT2N2jcYw51V21Jpb0sazE7YFwzTXAw=;
        b=g0DAFs2HFAHniz7C362kkyiIYxw7K4Maain6UfenXPAhWyIOv63zeqyeXoEoCw6NpD
         WuR4LjvRfgCW/vwrnnsHdtJTWUE6NLy+SC43vHbvWr6JhrGkiybKklDQWXTvc5KQZD9c
         9wwmwgVGcuHtVyzCLdshvnFKzymFJZndNM4M8NPTH/YPjCGThw+Ig/9yMq+uBHmImlHT
         S7utX05bU9dJzW3svL/pFbwMMqot2sXb4ey6et31JJTTeNhDZai2OfuizMvzMi8/a8xJ
         0m0b/bWCuN/WVs1Jgb0YHeDK780+mJT2A62sUL1pSTC7B4ptDD7HHfGMgUQIcg4+mDw7
         Eppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769119009; x=1769723809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Sju0/uBNJAFaT2N2jcYw51V21Jpb0sazE7YFwzTXAw=;
        b=fF5/q2WEDIX0ceu6KbaVrAmkN0rOEAKQ2bDTECK1HewxDn9w+n6MNtDtt4T1GU1z5Y
         s4XVyl3PAgNkIinITCj8tpv8ygKPM9zu1+3sJsqxOLozrD55bC0CBvnfBTAfBUgCLXwi
         XlrQWLIwu1r2LPszuYfXtmNzy2qfPKfnHRBcWPaXPKCg0gXx/38mPZUiyt8riz/lerJz
         TqQGqUBBuYQZ+Nv+doTIJNkXz+0ttWk4NX+5rpZyfC/0wFQzZD5zO4WkbDR4hGRfUliN
         MOU4ITUWxeJqRbDSI9xPfDOB6fRKklaZh72rTdCPCbrC3mO4t3O/JvDZN6bQY9kt0tS3
         2gjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6GPFz2r/nf6NExlUm8zD/cJLv0pGzPipPueUtaqxD5f/yn0JzwbzAo+jj0V/73+Icdf5SvTtGUw==@kvack.org
X-Gm-Message-State: AOJu0YyTN1uBPCTPl9+qHyc5oWX9gGUWendzY/rGEZr/+vuv4h+zZzMT
	YkuKNhpfm+/j/hybSR+ci+tOyXf0QSTtCPFOBU9Ioln2ppQAlkjnwAfg
X-Gm-Gg: AZuq6aKc0jshM6uhOhwpWhnDLoOqRmJDEKNEqjEf4/PSgtZAUibatWNtymD4kMNN62J
	hLwULng1qDb3OFfaz74pB+0fZPntLJKlDSnzQ6e6V547bJtUMa7TJDZZoh8z6OJqCCfDNsS85vC
	uHUqSM55E1HLwfJ8jd1sV0yT4yaSkcoWq4t3h7T5/rifoBvFrXzXZvvXonGV58NLrOhjBsfR5C/
	abgGoqUXSuLAUA8d8CESQG4Rorm5lRNWQTiQ6bbfbnVMZsb0GZYKVKTCNj0xOHPat2azaTH5KBT
	AQdIjz1zxMhsuVEvajQ7qrNnU0Lm2eYttQNKpOVjexcstz7eoKw2o9izsZYwgeg8hmP6bMtcfO/
	FlJ8UyDQON3YaTsvCRHxa07NW3qsBwOYQ3z/GBYhplQqyv4RMpehdNdKgQPNkc7bDLMNTnJs7De
	v1gSjPBAzO493jXLQPUI5tnigXEl73mmcAdrIFCl0o/YRRhQ48gfXv
X-Received: by 2002:a05:600c:1914:b0:479:13e9:3d64 with SMTP id 5b1f17b1804b1-4804d2f6b5amr9565905e9.15.1769112622797;
        Thu, 22 Jan 2026 12:10:22 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804dbb6315sm676845e9.4.2026.01.22.12.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 12:10:22 -0800 (PST)
Date: Thu, 22 Jan 2026 20:10:20 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Arnd Bergmann <arnd@arndb.de>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Yury Norov
 <yury.norov@gmail.com>, Jani Nikula <jani.nikula@intel.com>, Vincent
 Mailhol <mailhol.vincent@wanadoo.fr>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <20260122201020.2479d180@pumpkin>
In-Reply-To: <20260122102554.1cc7a2a3@pumpkin>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
	<202601220829.MgTMeqqN-lkp@intel.com>
	<20260122102554.1cc7a2a3@pumpkin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8210510000B
X-Stat-Signature: zay3y7bdpcsmsykdyoxkeojqdmjaatcw
X-Rspam-User: 
X-HE-Tag: 1769119010-877283
X-HE-Meta: U2FsdGVkX19m5JGriYGQKZVidX+uNj1O4SIc36JTnmoeppEPEMWKrHlNRhRI9OG6VnAWAattyDJRaztcvuOQUJX3ghmZETW4LATDs28TY1GM550IlxRXDw/B4naEbTogKl7ZMCZKeEU82HGDuXLjLuvP+WsXKoIQGtYHYstfaWHMu73TbLS/LvGGvihE/DHHTRkFkRUJxCZ2aFNt9Fw/XA8eYCfg1CpVHkk/qsAX+eyP5FHH+DwaFkAinsmEPNGAI5LGDdXhYwt7JzY8jym7VRuGPlBIWBJh0jE/Ksmf8WAK6CzB+GSvIOWcYp0tfLWC5sHN6Q2Jnu0Rk5yrDcq2FUZwZwuDuoYc+qO6wTEXNTVK3uIBGSG6y+qPmzyr31jYj2Q0RMWzxa/9YPKu8PymxqAb0p8vJcONhoTioGtLmuGq/BSFoJRIqv34+tv/BbLARgCFFlhPX55hd6bMLlipzODprqKVmqALmmNosHqy432/GWjxscnz3NZQ/LojyDsrlz2lPMjx+03aC1yyw5N/lHQ412XZQnCr8PBHdpFlvVN0KymDf/xSH9GsQ3QbFHhHB0J6kd15cGtVusRGesJ/rjV9so91/XTB0+dY5HYdD2SRXY9oOdF0alivmZ6ygVEeoDgFQOlpaoB3+5Bg75ESti/tUBJKw1Fa5ffeSsYCHCwgC9qNg+kDQmKarFkQFYSp62WsciLHHLWUmaYctFYz32cTFQrmUMqw4Vco44JxSxYf+ypJNrCEU8RaUvWUjzA0P7mleZaJY5pHmCCa4ngskVS7hAXl4dNDaUktGxIK3qFcy6T737SZC4cd7K4pVemoAtJUZ4rO0pS/uwwmfybqtuGtQeoqHG2A1YKNHCzAuhGvyMfEJsNXKRhIMHuNdV5ZT9Rm5+tVWbi1w0+bUHUiPHpB4r0nw/dnLXru2nviAfDinFc/Z4/nyvSqiGVxzeGFyUGTflxaiFjymHnIazy
 grfdSAlK
 Hz1Qor4dhUpYScE54swg4GTrMPzjEI0QNRaoYulsOxeS7tBktxB+QXggo4GQr5oin6RZ4Yi0BdUTSz+he+C4kRo3NCL1Qb7oGl2MsT0IYXs5GhmNMCjP52W3fGz1g8TUVC7rXtqUw9O0dpjMfd4HSYZR+c1lz2DMvW6A3Bh8nofBNwVILM6mmV+gqqc26xy8jmQWtfCHaGHzGeU5OtklCdiT0k9hFGRwnlAEoVtrzmLScoLKJDaXxvqkVDL+pL+qaWSHE39CMw0ZwDwl45DheT7dp3HTKaD45/4VeXQRZXqY5iHP/N3C17jdYO0TGDew+1Ks6NUDklDD+9gfYoZpVVStO6YFHIgstKoAVqfTh3A9o0DJTe68VOOVt6yZELJki2dKKzeYKQRwjxwgPrXWI1eNn+KnppYDHfyQbUxGi2ZurGeUFgMpV9doEvVhbNoSpv86K0RVFakkQq+oj4PTiFgdht8I5wauUaNzZufAKmdWoykK/ZElOiLBr/dFF9as8p9fRvl3GBppgDsH/Du6IJAX2x+Y09VEYPx54JL7ZpovmH/YbPWAYkhMNUIu+6G5sKF7kNPf5oiJl9zXt4LHdN0WpFCHd/nwDBKyCe+A2K2dI3g6wH9B0rpPMWocZ0HnsahhYwAPgFqFY7rmy+0TzkDbIhcnvxzfBBOx19hq+9PK21xHeW4AOJ9WmkKvzqI7k4wRexDx2ttuhOXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 10:25:54 +0000
David Laight <david.laight.linux@gmail.com> wrote:

> On Thu, 22 Jan 2026 09:11:53 +0800
> kernel test robot <lkp@intel.com> wrote:
> 
> > Hi,
> > 
> > kernel test robot noticed the following build errors:
> > 
> > [auto build test ERROR on next-20260120]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/david-laight-linux-gmail-com/overflow-Reduce-expansion-of-__type_max/20260122-013456
> > base:   next-20260120
> > patch link:    https://lore.kernel.org/r/20260121145731.3623-12-david.laight.linux%40gmail.com
> > patch subject: [PATCH next 11/14] bit: Strengthen compile-time tests in GENMASK() and BIT()
> > config: s390-randconfig-001-20260122 (https://download.01.org/0day-ci/archive/20260122/202601220829.MgTMeqqN-lkp@intel.com/config)
> > compiler: s390-linux-gcc (GCC) 8.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220829.MgTMeqqN-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601220829.MgTMeqqN-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    In file included from arch/s390/include/asm/bug.h:60,
> >                     from include/linux/bug.h:5,
> >                     from include/linux/mmdebug.h:5,
> >                     from arch/s390/include/asm/cmpxchg.h:11,
> >                     from arch/s390/include/asm/atomic.h:16,
> >                     from include/linux/atomic.h:7,
> >                     from include/asm-generic/bitops/atomic.h:5,
> >                     from arch/s390/include/asm/bitops.h:75,
> >                     from include/linux/bitops.h:67,
> >                     from include/linux/kernel.h:23,
> >                     from net/core/page_pool.c:10:
> >    In function 'netmem_clear_pp_magic',
> >        inlined from 'page_pool_clear_pp_info' at net/core/page_pool.c:721:2:  
> > >> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers    
> ...
> >    include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
> >     #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \  
> 
> This might be a real bug.
> 
> The bit of mm.h is:
> 
> #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DELTA))
> #if POISON_POINTER_DELTA > 0
> /* PP_SIGNATURE includes POISON_POINTER_DELTA, so limit the size of the DMA
>  * index to not overlap with that if set
>  */
> #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_INDEX_SHIFT)
> #else
> /* Use the lowest bit of PAGE_OFFSET if there's at least 8 bits available; see above */
> #define PP_DMA_INDEX_MIN_OFFSET (1 << (PP_DMA_INDEX_SHIFT + 8))
> #define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && \
> 			    PAGE_OFFSET >= PP_DMA_INDEX_MIN_OFFSET && \
> 			    !(PAGE_OFFSET & (PP_DMA_INDEX_MIN_OFFSET - 1))) ? \
> 			      MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT) : 0)
> 
> #endif
> 
> #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
> 				  PP_DMA_INDEX_SHIFT)

I've managed to do an s390 cross build.
It is all quite obvious really.
For s390 PAGE_OFFSET is usually zero (I think kernel and user mappings are separate?).
This make PP_DMA_INDEX_BITS 0.
PP_SIGNATURE is 64 - so PP_DMA_INDEX_SHIFT is 7.
So it is doing GENMASK(6, 7) and, I think, expecting to get zero.
But that is taken a mistyped GENMASK(7, 6) and treated as an error.

If I rewrite __fls() and __ffs() to return 'integer constant expressions'
when the input is one I think it would always have failed.

A comment a few lines higher suggests that the code expects the mask to
be zero in this case - and handles it properly.

	David

> 
> I've no idea what the values are, but the 'hi' bit number must exceed that
> of 'long'.
> The __ffs() probably stop it being an 'integer constant expression'
> making it just a 'compile time constant' - which I added a test for.
> 
> 	David
> 
> 


