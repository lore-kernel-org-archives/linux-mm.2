Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C4AC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528E96B00A5; Tue, 21 Jul 2026 05:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D96F6B00A6; Tue, 21 Jul 2026 05:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C86B6B00A7; Tue, 21 Jul 2026 05:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7C06B00A5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:55:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8044EA0BFC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:55:15 +0000 (UTC)
X-FDA: 85012325790.12.CC7F959
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id B7A4320005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:55:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ieXOW78f;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SSRyXgIn;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784627713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Y7k8VMwT1bRXBYuL9ekYtg1ggRsuHighus6g94A0VY=;
	b=xj51ZY654JBt0nyOMYHUQz3pZFYUmP9PJLP/TWEZx0mqC1HGGHxPtf/Ecoy2Cx83hktBWa
	c3AWWPOALSBw4QqQaV93pS1QoEwGqgvCzzr7j/tZN1pEVj9ChnF3rlyH4kEw9kZ0YRwEs/
	wdk0D4M3cVDZBOaiJqTOYKumjAWpnyM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784627713;
	b=AS8PZoYs+Maw0BXE42HXuy7X5V8UdhXviBx46IvIpUvsmgw0IcXlVqP1KLG+erxs1FfgkO
	UAuB2+0OfypJkQuSg1cH5899fPq+lDUdcR7PPGBM9Z2oNVL3B1SQnZ85sTbiKUDheMgylE
	j4Du6uAKGx/ZcPPw1PBup7j+7WhP7CQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ieXOW78f;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SSRyXgIn;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Tue, 21 Jul 2026 11:55:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784627711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Y7k8VMwT1bRXBYuL9ekYtg1ggRsuHighus6g94A0VY=;
	b=ieXOW78fIWAjILQMVsYlTUOZ1UTgK8bzK0a9FGCLHBVf+9rJVR11OSiOV1xzKLS3a1S0//
	Re3fyKkq+qMt8XgqYK9oCvX/SEM4S544qgCeb2EofVA0v4iDdLfyrUfOu0ruRQppDtdT9p
	6rI/DBNxmaEzr3YcthdQBlwEQS/D1PEY/TPSeYksauOhv38rt9m5C4S300wuso+drGtZLz
	47jfhk9A2PElP8BwDUGVGougT/xvXYsf6lb82kuj7yFPI44Zef+ziOettVNCmN/UxywR+6
	69Rvg0aU+hzzuVEq/JP5JIi9stsz1BOhS/mnGeAZ0QSBevQa4z0tUvE+NVFnoQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784627711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Y7k8VMwT1bRXBYuL9ekYtg1ggRsuHighus6g94A0VY=;
	b=SSRyXgIna5kbI0lsCs29JBLwLjxGcAQ7pWRKEzxzXMHb+ely0WM5K0ctSAcuhDto54q6sR
	7/ZVqpBaC9Y718Bg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kees@kernel.org, 
	oleg@redhat.com, luto@amacapital.net, wad@chromium.org, thuth@redhat.com, 
	peterz@infradead.org, mark.rutland@arm.com, linusw@kernel.org, ada.coupriediaz@arm.com, 
	kevin.brodsky@arm.com, yeoreum.yun@arm.com, anshuman.khandual@arm.com, 
	james.morse@arm.com, tglx@kernel.org, broonie@kernel.org, pengcan@kylinos.cn, 
	ryan.roberts@arm.com, liqiang01@kylinos.cn, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v17 15/15] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
Message-ID: <20260721115248-df7f647a-7031-438b-b79c-248d5b403cab@linutronix.de>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
 <20260721081858.1169276-16-ruanjinjie@huawei.com>
 <20260721104810-0a8ab042-2705-43e8-90d2-74e221f3fab5@linutronix.de>
 <8a1c8c38-e89b-4e22-9b46-aa53b0ed30f8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a1c8c38-e89b-4e22-9b46-aa53b0ed30f8@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B7A4320005
X-Stat-Signature: q1ahnmjfhp93qbjejar1rsxkz7prcr73
X-HE-Tag: 1784627713-145824
X-HE-Meta: U2FsdGVkX18dhslDy6h/bsS8BkywCorW82l2OUBID6He3uk5TPSXfAwxGVtjslBA/qObc3t3d2EHN3Y/AGz1h3aDwYq2bD4RAnDgEkdJh4anFH9Xx5jZnOWKpk2rhg7EHLxyVIr7dWg/Hw7QJczBqMYgKd7qfDqiy9AubUKOcH+xDPxPfRwMGpXPKT8vtvxrwzuHE8LQ2vYCJQpDA0mza+yi9Scpv/LhGmb3bEDjFR/SEPyM17Oz0RCJPj/EjSOxcInGq4L2da8Q+2FfcnEQ36TWcSVc98ZkxtsLAw3wTYcE/B0lsLm5z+jntwBpmFrktyCm0iAsejdiDWGnJ2ezCDRw7U6xYs7RUJ6gjdNawd966hWd/EexKj3eg8NA8eUJdPeHKlx4VhD/pZOkWTWo4MKkLCJO3EYgTceBMyI99sn2+Ppci4geMZc5u1y9Kullpa2Vc/JBcl9tfdgdRM5MAwYpt7mXb39iZxwI7kWSllSdA9PcWi7IftUTjuc5+6JQsRRe+UZpnXE8kMPaIMChForRAJhXF8/7cg2KVPZvuICIOCggPwdd9i3hhUsfTFdsFYoshUNK/Me9OOJJfnJMTvIpIGp7mcfM1oJe3jcnT9fBL0AgXsEb+zRk+VKMHp8km49IZW/prQX+fYyIWkTAO+sitZTkNPyU/kkYhzUWlFK7YV+tty6MlCYbtbOB38sVfAd0EEiCuTuqIJIq4XNi7WDoDP5DGacZafQeLwONtNM040wXftjLdtnTaJtbgqbaIPducdJ77Rk2j9S06viFcHjC+CGwVp+Im6yz+24KkSQCriq5GVhHv9i8dWHc1VgzTzZufkWeR+nVJXD53S7Q14Xw2eeVVzYEwIOO1YR0AK6BNj9ZgD365VV5LzlBWlykGUjJk+90zuNcbOXiV4mOCOAiKbeFluL9p1xl/21G7xkAUJK82ia215GYPS3rKwBhTfimjbtHbzxjJ/XJCd8
 yESZfZbl
 eLAW66vPxSf/xn/UIauh3XLOYwII+F//fT7oADNjMvtpI0oV2VXYN+XDCilHfNgCXVnBDNQFcLCHfIHmbpwp3zPWdhA52u2Ohx1u6efk7kMkBoCCIbSUDYFyIW03mhkqgAnp/FZa2WXa0ee0Bni8iF2ZWeZco6QK2DOtGYul2fqp3Rztcl2nE2rPr2JXJ7IDWqaQkFMNhxVjP7u+lltnMkk9f9VIAs+gfAMPvUAApMVTmWo/WxDiJ/UQtUvlCXsobJf8LadOWYVxCD/CwAOZH+ti6HI3l6K2tjXirKx8QWA9e6m2/oliRGjEZ/5fRiLXX3q0CKlbSKCn0Jf4/nbdQEezhzhLtxpAfekYESnE1kFmu2P2QcoQwOHwL40uM1I437ImpFTVGAIVwVxflODyhMZscEg+yBtJA3wKXtyXexL3hGD1UbYaynP1IQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 05:23:38PM +0800, Jinjie Ruan wrote:
(...)

> >>  arch/arm64/Kconfig                 |  1 +
> >>  arch/arm64/include/asm/elf.h       |  1 +
> >>  arch/arm64/kernel/vdso.c           | 16 ++++++++++++++++
> >>  arch/arm64/kernel/vdso/sigreturn.S |  1 +
> >>  arch/arm64/kernel/vdso/vdso.lds.S  |  1 +
> >>  5 files changed, 20 insertions(+)
> >>
> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >> index aea686dce3d5..a41d2b593899 100644
> >> --- a/arch/arm64/Kconfig
> >> +++ b/arch/arm64/Kconfig
> >> @@ -86,6 +86,7 @@ config ARM64
> >>  	select ARCH_SUPPORTS_SCHED_SMT
> >>  	select ARCH_SUPPORTS_SCHED_CLUSTER
> >>  	select ARCH_SUPPORTS_SCHED_MC
> >> +	select ARCH_SUPPORTS_SYSCALL_USER_DISPATCH
> > 
> > From the subject and description I would not have expected this to be in here.
> > Split into its own patch?
> 
> If ARCH_SUPPORTS_SYSCALL_USER_DISPATCH is not implemented, then it seems
> pointless to implement arch_syscall_is_vdso_sigreturn() separately,

Absolutely. Although a preparatory patch can introduce infrastructure like this.

> or perhaps we should revise the title to indicate support for SUD on arm64?

That works, too.

> >>  	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
> >>  	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
> >>  	select ARCH_WANT_DEFAULT_BPF_JIT
> > 
> > (...)
> > 
> > For the rest:
> > 
> > Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> 
> Thanks for the review.

You're welcome!

Just to make it clear: This is only for this patch, not the whole series.


Thomas

