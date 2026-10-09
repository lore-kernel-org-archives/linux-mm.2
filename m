Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7549CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 19:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647366B0088; Fri,  9 Oct 2026 15:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8D86B008A; Fri,  9 Oct 2026 15:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7696B008C; Fri,  9 Oct 2026 15:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2804D6B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:03:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A6FCA04DB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 19:03:17 +0000 (UTC)
X-FDA: 85304010834.05.07E2010
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0CAFF180011
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 19:03:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFr88NQ+;
	spf=pass (imf06.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791572595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TirdlCwzZ2cMnBXETSVn2wNFY8bO/3AuUeLLqbi+80w=;
	b=mXZcD7iePKuUaWbGabI55kNyiJFxL9VBC55D0kEPaERz+Ne5NOtUeOblQyAqdp1zhfe3hN
	AT4FS3/6sXs2GnginsJaktucu8WhKMT9YUd9jFx8IUIAVjuP/5sNJcmiDNVVD+mmfAt/KO
	f1opVLe1DHNEsNPq3+oP35V+n5el/48=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791572595;
	b=hxC6iWKtZZSaYSUhoAaO0hf7AJyOSNDQq+P458qRP6twE8ejEdlxW2HdmCg71YBvNe0cxe
	Y0sXZrjbM4Nq83nwxHjyB8TU4Wqt1YDveOEQ0r92SrFlT0tMYR7QMeKivHrD5rerI10FMD
	szLRkvnChi0BwA/XJG2yjEhNdoRT/f8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFr88NQ+;
	spf=pass (imf06.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D32660267;
	Fri,  9 Oct 2026 19:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81BA1F00898;
	Fri,  9 Oct 2026 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791572594;
	bh=TirdlCwzZ2cMnBXETSVn2wNFY8bO/3AuUeLLqbi+80w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XFr88NQ+TOXU9e4jM3Sku3N23cc2Z0FlIf41klvBBxFfn7opUfl6mqM7XTfAe7t66
	 Bwm+HBpWHvhoEAg9ztR3w5rRCOuPzlNbIRIzgw4oYZXmxm1pjIjtTuPBV7oOuqQcO+
	 zXK48eT943s784+SkktVSzgJyu3t4TiSOsl33stMQ+DrQr0hRyDJC178X0h/ih4QvY
	 dCgbQl1oYdrA38feZKWPMlhj2/Wm+zeyRG3FAktp6DpXCyfadsQfC4dysoym3htxro
	 0PN3h65Zw8aqxuyadA8XmmfAZXNKGiRV8rY+NliN9owq2ALNty8bWTXhTGy30EI3wr
	 4ntoMJ+EFymgA==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 26201F40066;
	Fri,  9 Oct 2026 15:03:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 09 Oct 2026 15:03:12 -0400
X-ME-Sender: <xms:cDrJapSTF-4TR9lYnSeST-jN7FAICdGSH2CxnXozt5nP-9ueQAwcqQ>
    <xme:cDrJanCaOMUT4cjefNwFm2iobY9vNYdZLJU3Ai0yGTvABdvkW_M8Gf712Uw0s2joD
    j8P9UXImlt6cFQZ0v9A0I026aYpPFgB1y9avi_L4AxengiiBQMVxnHZ>
X-ME-Received: <xmr:cDrJarwZAl0DOZByWwHgnfVG4IDAIemmYhfzkvdYBPnJH9p93IM6KuMaL9AfxtxRdkU9FcVZ6kCXHN6EGgHKAyiEFLGx379K>
X-ME-Proxy-Cause: dmFkZTGtq7JcenuwH9YCrRuUTTxkXWfMKXOv9XLn5AIx7CUcTLanJrTmpLXaH7tXe29Thu
    4+EUJ0wq5iP3vYpD9dYfrqbBxeFyum1AHUKkNwellh8jXZyMFNUn2klB0HX8kimMTo+jCm
    orPPwBk7KiiZY3aSSc7xYRDc4junoAPOnmYMSLf7DQDHZr9TcNr2sh9+CyU8GFRY844FCf
    u9Acoo2q0GGZ4sI56HUOSyhyX7ItBVOZ3AlRYVVT/bFfOEynP3wwrCKEwYL1dzy07J4bKw
    tQX1exdPDTa2fjNkSiGSGlkXbHVDf2/f7FPNBSmWvIGPIGmV0Z8PRN8ClzazP6Wfe2TwlS
    aDo6MzGql/jk+Oha8Jymb5DSa/R2gx9s5EnNeC6U9crZ2kw4IqGZKLaO5ELmZWfPGmZy2H
    qNYwLnZstHYOf4nuJsyrajMKOKozOuPZrtcDeGmXzmBnRReaYe3oqb1xd7XLCQ9LXHPmtq
    ZWRalxK2C1eZy4tmXsAZCONcDyxk6q1wnq2EdpG9WmIv0/JcOgOreDx24hKOhZ3rttZEN9
    QfLZhGmE6FTHMO9wZjN47up4l76o/u/5ALRX7gmQ+iUYuyREBhEWhmKXCd+enUvx0A7nxF
    mP64lTmwb8z+5VypLLfJDeDdWXFX+6NMmPQo2LnIj82OboLukcomSNJ3pxHQ
X-ME-Proxy: <xmx:cDrJavtd4yEj3SzhaEH1T6vN5GVQO5emvPE8L8PnrGqcw0xpqxJkrQ>
    <xmx:cDrJasnQgAy0HJgjiAxBmQjQKnlWm3j1nkByuKD1mo6leZ431Xq-xg>
    <xmx:cDrJasCXDpN17d_YTAJWSi3bR8MlAS6CZLJCnKYMltqt5PrWxgXdUw>
    <xmx:cDrJatSBcHIKLTMyCIuQQkLK2MjSPJGTZrOMNnecbpuQX9zjD9IxzQ>
    <xmx:cDrJakK2e6wG_-6YN4ax-P-FRJ0EU7qjzMZzWKfbgovAQNST13ZA8qqF>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 15:03:11 -0400 (EDT)
Date: Fri, 9 Oct 2026 12:03:10 -0700
From: Boqun Feng <boqun@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,	John Stultz <jstultz@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,	Vlastimil Babka <vbabka@suse.cz>,
 maged.michael@gmail.com,	Mateusz Guzik <mjguzik@gmail.com>,
 Gary Guo <gary@garyguo.net>,	rcu@vger.kernel.org, linux-mm@kvack.org,
 lkmm@lists.linux.dev,	Nikita Popov <github@npopov.com>,
 llvm@lists.linux.dev,	Lian Wang <lianux.mm@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH hazptr v2 2/4] ptreq.h: Introduce ptr_eq() to preserve
 address dependency
Message-ID: <ask6bmsDCCacOkKb@tardis.local>
References: <20261009182142.6311-1-mathieu.desnoyers@efficios.com>
 <20261009182142.6311-3-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009182142.6311-3-mathieu.desnoyers@efficios.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0CAFF180011
X-Stat-Signature: i8p8sc6dkqx4ejs7sjmhg4ogwehkfk8g
X-HE-Tag: 1791572594-519587
X-HE-Meta: U2FsdGVkX1+yMvoqeSoiDQNfVw2LBVqPUDamvAIZrfYD14NvLhLpaLXQ5cgDqpeuCwnqSzp8RFDFqpCSsGTcLVsbD4kpL3TJUA7TJtUTDGU6qtUpfRvA0LOS1tffzukmc5KeBY2ZPyk5gC1+ySJbPm542BCJo46RTD4lojOEF3eLfG+ztge/jgEC7qW/TMAf2viwUypzuTvt7FbRmEKL+ak9ly+2g4IUg7sUmSSOjSSG6mzyX0DUcxf3fRmLbvX3nhtTc9837Up4XGyKGgEiI40ro2SIRve/FWZ8TkOhHIorL1H1BZJX7NBpC6SVJcTvbrQ1WOQCbv9indOkfRDPwxMh2kvXGVFMzyKerGjjHAZ1WhjlXxLBY8ILbsX/QSx27919ITpWiWIaZXGa+aTB9xYCy3T9bSqIt9hHSv1U0dmgHFbHRBxyba0ygGgR0FQCc4wvbkS/P7oBhb+IrFKj1qJCUhpaJ6D1dhcTP7CMPRFu+X1HprOGxtdxgWJ2a1BI3DL3RVP+d6iTO5VdJbnu+HExgOKrS925y/NDwCGc+M2KhsDK3vML9x3CpRsPvts4prPsccuvfFcmVILyPAJswp+uXYSzDjhSZicSFjCkNsSsbhZpifdJCKXDNF81+GmY6ERPCbIzRexD/vITmjGl8m38IDXzoUO2jP8pIphd6v5goVmvxWq7duCNMu0M0weFiX/THMa7Rgu2S6Fhe2xM8M/spsPqV2wsZUA1Mmon/uC+ltYkfuIR+EoIOp3dZZeGfygm7t/v2SwDl1vKStPnUhufJ9POYikF2OGqYp6wOsLJitEHoAQ2Nr/rDEE7h5m8s5WvOTFSWmAzCZHm3uRAuAJYMx0X88Ev4p+q4babxP2/l+Uth/umK4pFohE0RH8HAQa94uInVMRY2KKZCQRsE6hg7clT5BAT/5nD45ANnQ1LZxXDacppIoHH9a8xs2atg21xqp9KzM9vPhwZgjB
 vBewtnlX
 R6FYo/JoMPtEV+Tl+dqY/dhIRoJMms7WArnj55SnYSbrNGaBFrbCCK1RclGMGm6u5NBwwgzMmIZOvRBrD5Eh0+/0JjZhGriSouJJ5OQyxSE2/Xm6DGP/rILadfRdzuZDJbSxfCN8msLevIK2h+AGxDErpatT/jHcxAZmfc0fY+HaKO9PtXozh/ZCDFw9YqVtWq0g3ZyK8t9P3tNKMBTV7icXpVVeCf1jCfFEi5P/pdR9CfOg+eUkKXR2yZHFmnEdX6sBjcod8+iQx4yDVuXuRk2oxQeFUYAKistcYycVyObkKKXYNcdAoR99kjBNU1vl9z+jJowAGAf0hITejp97PwTfFMgTvTF3q/MTpcU39BYQk1lKna4eqO2rCA1TmIYhCRMJ2CL7i6PuvfaQLEQD+AKuxvNYsT/dm4sSavd4TnsRYEuivcvUQQoBNRaRIpW8c0WSRDakcvt2VGB2QBPSPxRyrerV8t6ij8E5nowPwGMZcGGgDjlJOsuPf3iLGt12bB8kvQYGECajvcZ2CaxJ/aJIJ/YlIFsWe9v7OufTs3WgVA5lAk7JIADU9zqAkMgIVkEkqpQxeOEpWs8wxc3Qhb0kQM8PtWJIoauJm/WkMiMMvALYqQt8x/fQHOfmCWwt/yB2MfhiuiI619SnSu1XGys1rrggXNeBPZJUprhXhA9GqtF0gTp86uNyHvflADtlEWmwM6aakggT/SbYBfwXg8M/4kXZJP5t9gCB1zfL2XOrmgih90K3CGoe+bru2LcmyJ0SAb1wAoXtw/59+2lJpdEgh1v32n5wFYnf2C7hZXOn7a9nqRi3GfQuV3p+SeFpys3dh+gX0EFixJtf6Z9oqVG8wVmsYeVNmjg8gOuVU3OSsxDpr8tQ/5clGtQJQ7/8JIwgaZ4HKuzjBg60ZAuTR7vDlctjfIUiPQol0krsM3gpfN4mcSmkpBagHo700ctJ2mOy8hxy0duxk3sYVr7obvcAoUvN7
 UPml7VdC
 tl9Biq2eU7XM9e53KwqIOG0rMYxU+kDHCrnvvDWMon05RosbuxyGjYmU2f48JWcyq37HzrESld2xQvfbSOt7pSR97YJBDpUrzDm88SauRbtaz+veLMRVXceM7hlxdZ1f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 02:21:33PM -0400, Mathieu Desnoyers wrote:
> Compiler CSE and SSA GVN optimizations can cause the address dependency
> of addresses returned by rcu_dereference to be lost when comparing those
> pointers with either constants or previously loaded pointers.
> 
> Introduce ptr_eq() to compare two addresses while preserving the address
> dependencies for later use of the address. It should be used when
> comparing an address returned by rcu_dereference().
> 
> This is needed to prevent the compiler CSE and SSA GVN optimizations
> from using @a (or @b) in places where the source refers to @b (or @a)
> based on the fact that after the comparison, the two are known to be
> equal, which does not preserve address dependencies and allows the
> following misordering speculations:
> 
> - If @b is a constant, the compiler can issue the loads which depend
>   on @a before loading @a.
> - If @b is a register populated by a prior load, weakly-ordered
>   CPUs can speculate loads which depend on @a before loading @a.
> 
> The same logic applies with @a and @b swapped.
> 
> The header "linux/ptreq.h" is the expected include target. It
> contains the documentation of the ptr_eq() API.
> 
> An architecture specific implementation of the pointer comparison
> can be implemented by each architecture as asm/ptreq.h. The x86
> implementation is provided initially. If no implementation header is
> present for the architecture, an arch-agnostic fallback based on
> OPTIMIZER_HIDE_VAR is included from asm-generic.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: John Stultz <jstultz@google.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Zqiang <qiang.zhang1211@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: maged.michael@gmail.com
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Gary Guo <gary@garyguo.net>
> Cc: rcu@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: lkmm@lists.linux.dev
> Cc: Nikita Popov <github@npopov.com>
> Cc: llvm@lists.linux.dev
> Cc: Lian Wang <lianux.mm@gmail.com>
> Cc: Kunwu Chan <kunwu.chan@gmail.com>
> ---
> Changes since v1:
> - Move to linux/ptreq.h, implement x86-specific comparison

I prefer the name ptr_eq.h over ptreq.h :)

With that name fix or there is a strong reason of ptreq.h:

Reviewed-by: Boqun Feng <boqun@kernel.org>

Regards,
Boqun

>   and asm-generic header (fallback).
> 
> Changes since v0:
> - Include feedback from Alan Stern.
> ---
>  arch/x86/include/asm/ptreq.h | 16 +++++++++
>  include/asm-generic/Kbuild   |  1 +
>  include/asm-generic/ptreq.h  | 16 +++++++++
>  include/linux/ptreq.h        | 63 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 96 insertions(+)
>  create mode 100644 arch/x86/include/asm/ptreq.h
>  create mode 100644 include/asm-generic/ptreq.h
>  create mode 100644 include/linux/ptreq.h
> 
> diff --git a/arch/x86/include/asm/ptreq.h b/arch/x86/include/asm/ptreq.h
> new file mode 100644
> index 000000000000..593b45f80451
> --- /dev/null
> +++ b/arch/x86/include/asm/ptreq.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_PTREQ_H
> +#define _ASM_X86_PTREQ_H
> +
> +#include <linux/types.h>
> +#include <asm/asm.h>
> +
> +static __always_inline
> +bool ptr_eq(const volatile void *a, const volatile void *b)
> +{
> +	bool ret;
> +	asm(__ASM_SIZE(cmp) " %1,%2" : "=@ccz" (ret) : "r" (a), "r" (b));
> +	return ret;
> +}
> +
> +#endif	/* _ASM_X86_PTREQ_H */
> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> index 2bc00c67dc54..e1d95dea09d5 100644
> --- a/include/asm-generic/Kbuild
> +++ b/include/asm-generic/Kbuild
> @@ -47,6 +47,7 @@ mandatory-y += percpu.h
>  mandatory-y += percpu_types.h
>  mandatory-y += pgalloc.h
>  mandatory-y += preempt.h
> +mandatory-y += ptreq.h
>  mandatory-y += rqspinlock.h
>  mandatory-y += runtime-const.h
>  mandatory-y += rwonce.h
> diff --git a/include/asm-generic/ptreq.h b/include/asm-generic/ptreq.h
> new file mode 100644
> index 000000000000..db5a88628b1e
> --- /dev/null
> +++ b/include/asm-generic/ptreq.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_GENERIC_PTREQ_H
> +#define __ASM_GENERIC_PTREQ_H
> +
> +#include <linux/types.h>
> +#include <linux/compiler.h>
> +
> +static __always_inline
> +bool ptr_eq(const volatile void *a, const volatile void *b)
> +{
> +	OPTIMIZER_HIDE_VAR(a);
> +	OPTIMIZER_HIDE_VAR(b);
> +	return a == b;
> +}
> +
> +#endif	/* __ASM_GENERIC_PTREQ_H */
> diff --git a/include/linux/ptreq.h b/include/linux/ptreq.h
> new file mode 100644
> index 000000000000..5499f65da30a
> --- /dev/null
> +++ b/include/linux/ptreq.h
> @@ -0,0 +1,63 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PTREQ_H
> +#define _LINUX_PTREQ_H
> +
> +/*
> + * Compare two addresses while preserving the address dependencies for
> + * later use of the address. It should be used when comparing an address
> + * returned by rcu_dereference().
> + *
> + * This is needed to prevent the compiler CSE and SSA GVN optimizations
> + * from using @a (or @b) in places where the source refers to @b (or @a)
> + * based on the fact that after the comparison, the two are known to be
> + * equal, which does not preserve address dependencies and allows the
> + * following misordering speculations:
> + *
> + * - If @b is a constant, the compiler can issue the loads which depend
> + *   on @a before loading @a.
> + * - If @b is a register populated by a prior load, weakly-ordered
> + *   CPUs can speculate loads which depend on @a before loading @a.
> + *
> + * The same logic applies with @a and @b swapped.
> + *
> + * Return value: true if pointers are equal, false otherwise.
> + *
> + * The compiler barrier() is ineffective at fixing this issue. It does
> + * not prevent the compiler CSE from losing the address dependency:
> + *
> + * int fct_2_volatile_barriers(void)
> + * {
> + *     int *a, *b;
> + *
> + *     do {
> + *         a = READ_ONCE(p);
> + *         asm volatile ("" : : : "memory");
> + *         b = READ_ONCE(p);
> + *     } while (a != b);
> + *     asm volatile ("" : : : "memory");  <-- barrier()
> + *     return *b;
> + * }
> + *
> + * With gcc 14.2 (arm64):
> + *
> + * fct_2_volatile_barriers:
> + *         adrp    x0, .LANCHOR0
> + *         add     x0, x0, :lo12:.LANCHOR0
> + * .L2:
> + *         ldr     x1, [x0]  <-- x1 populated by first load.
> + *         ldr     x2, [x0]
> + *         cmp     x1, x2
> + *         bne     .L2
> + *         ldr     w0, [x1]  <-- x1 is used for access which should depend on b.
> + *         ret
> + *
> + * On weakly-ordered architectures, this lets CPU speculation use the
> + * result from the first load to speculate "ldr w0, [x1]" before
> + * "ldr x2, [x0]".
> + * Based on the RCU documentation, the control dependency does not
> + * prevent the CPU from speculating loads.
> + */
> +
> +#include <asm/ptreq.h>
> +
> +#endif	/* _LINUX_PTREQ_H */
> -- 
> 2.43.0
> 

