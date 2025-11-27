Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5424ACFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B346B0031; Thu, 27 Nov 2025 09:51:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8529E6B0098; Thu, 27 Nov 2025 09:51:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F956B0099; Thu, 27 Nov 2025 09:51:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 699C66B0031
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:51:33 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 119DCC01B4
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:51:33 +0000 (UTC)
X-FDA: 84156675666.11.F56A3A3
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 68D7C20004
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:51:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hbwvzb36;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=p9WbnQvb;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764255091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZiGM0rgOh8rCPA4Chxa2korgREX/RFMjcGVwmNVipY=;
	b=Lls7xGq/joPqYGyS1BrryZFd1M8OYASbM1C7E4BA0tVa330goxifOS8EU0rNgmzae5uWwh
	cugNlcIHNLwZYnmhrWaveeCuGNBzUCcyEyKYr+1OAGeNXAy2wAz9dgXw9BagTeU9mREPhL
	DpZB5P13AwCVwo/2habSAyC6wjAVl3k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hbwvzb36;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=p9WbnQvb;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764255091; a=rsa-sha256;
	cv=none;
	b=KPSGCVwbstpmVAKKOv/EM8EsexxNQ14v331B41eLypLEzM71HOsRNm4xWtjucWkztx2gL6
	V+EC7LKood6FvZ2nwdTtg80z93Qnk4rAJ8pckjOfxt1ePozg3/An1Q53E3nxKDuF0kgJvh
	sr2TqNAV5lvSbsAuPXg5vlp4BsDh2AM=
Date: Thu, 27 Nov 2025 15:51:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1764255089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dZiGM0rgOh8rCPA4Chxa2korgREX/RFMjcGVwmNVipY=;
	b=hbwvzb365mil7ujSwC8oJpF8CtccBGMjUFmYcTY7jCpfPuJm1qBs5AaPCZPMADrLTWU3TA
	vn13NSp93U+rAvnpb7CJ0J+MVeIUYV+xdakfOm1+LMSRjb7xUMuysNXNhTsWsNcMQiPtCy
	mgyDlVsWbMeHTe0PUshZ5WZZiozDAxx4FSniJOK3nA7unx7A7VajLGUwsB5JV00+dV+U67
	UiuDXqGtIZWaUf7Govw33nazqzbo1QKrSKB2ROJ7mNru2DaY0svMNx441cxH6kdtMmp89s
	7AROEeoJjjKgBMjjOE8d7wS5gvIildHIZSqs4jTxKPt9HJQaFfYb+OOYc2OWfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1764255089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dZiGM0rgOh8rCPA4Chxa2korgREX/RFMjcGVwmNVipY=;
	b=p9WbnQvb7y0LNdkXZr9Yzo0gHnHa6g+Z2WXDmZUBwgqVuoqJOXmUV0kOAeAdzwMXc7ytE7
	mse1wFdfR5DBq6Bg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: viro@zeniv.linux.org.uk, will@kernel.org, nico@fluxnic.net,
	rmk+kernel@armlinux.org.uk, linux@armlinux.org.uk,
	david.laight@runbox.com, rppt@kernel.org, vbabka@suse.cz,
	pfalcato@suse.de, brauner@kernel.org, lorenzo.stoakes@oracle.com,
	kuninori.morimoto.gx@renesas.com, tony@atomide.com, arnd@arndb.de,
	akpm@linux-foundation.org, punitagrawal@gmail.com, hch@lst.de,
	jack@suse.com, rjw@rjwysocki.net, marc.zyngier@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	wozizhi@huaweicloud.com, liaohua4@huawei.com, lilinjie8@huawei.com,
	pangliyuan1@huawei.com, wangkefeng.wang@huawei.com
Subject: Re: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when
 handling with page faults of kernel address
Message-ID: <20251127145127.qUXs_UAE@linutronix.de>
References: <20251127140109.191657-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251127140109.191657-1-xieyuanbin1@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 68D7C20004
X-Rspamd-Server: rspam11
X-Stat-Signature: oiwby3s5oejazbdqycyit4yo48opbes7
X-HE-Tag: 1764255091-909760
X-HE-Meta: U2FsdGVkX19RBckIxiU/yj7WVdnHbKpl4Yd6FbrnkgUuJp1VUM9eOBIkVPGPeaop59HMOqPDU8emyd/qjB/H83vHZmxbDZcu+51GyTpq4u/t7nr0ysT/BB0WX3ZZdeoJx1AhCSn8DCu6yX3mzwg3JkqaVfA06zvlfDsjOC1xZesI+7bACCrOd4GmiqYFJIgZuY1xipjgEy02vnk+VUlB6OXBGu56o08GVWUFbijQEK/8yxpQx3Plu3DHsymfU0mYvkqd3+TvIzG25kU36JDx249Gn8WszPGEJEPbKBy7OxLYGxy5iWFzrl25e9FsXhcnIrLZjcm40fpVGzKNMCSWmgtiXgwsJCFbaFt2aM04rKHAEl8VrRvlsX2/Rdx85W6nc+PfqCfetq1R8se+ZaHfGmNWYqYppl1wQKx6aIuGbaT3KkZRXvbwceKu86nf2gAwlQ7m2XlrA/5OHKQCAzmPfxzOka4zSvYiN1ockJua2LRppezOuNy6thymuL+kmbn21NhegSWFKcS59zer/WzOLuCaqGPfYNpNq6IKpVaQNHSH6Vfou6IMWkQMzIyPQ233w1LUdlMw7+tLoLwCPSenX9beb/LnsjmwIpY1fybf8Cmp5Ivy08M+BBH5epyUIQKWHCvY+sKj6jlCrOKZlWCWcQXbyOh57jr0BhipR7v9eDuIMibrtlgMxAxu0W6vo0Z30Zs43bXI7OKmxNEhweZux7Vo6nzD6SJUnrT/7G/rEgBzGEhxu1KrON6/5qoEIx8u1QUWvB1p/8iU2Q2Zv9L6EIGD5ZAinLbil1O+YI+N0iadDl9rCKXINwAikvk7lwfUnrcbTvKPJj7fL5LBebBIOzqLqXLqPqpqkABZLd8J9qtRaMPzkfCyIfHsZGReJEXD12Xt+L2bsUGxQj8tNhWomjwjiIUj5wLE6kxhrvGWVAXE2ntrto3TibiPy+Y59/KAilijYRLH3jIRWnJ9K7Y
 ofbd2IE7
 fdJLB871S8Cjc/GbuegqJBySHlRn2XGI70oudRFVkJgl1eNBdAbRtAid6j5LSUrDUZX+PijT6CmCTMjmrDMDt1+QFdL8GDqKlPnNcK58Rna3QfYkw+3pw83FGcocA4X1ir0u0wyArn5DbkHbKH15PynFR21cmOIZQ+5DYB3VSU8MzBDtKQc7xL7tLF520JN9KnpIDu0in6xZ7O/rpqnoM5iB/wRQAIlwFMi0h5sw0eyKfkyPRKdlXYN1+zJQhmpljnd3x1Bpvva7h0AzvNsh44FofArqxCfQBvJC9uKXRAFNcCGq5U92SgXTgVX162TPI21IT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-27 22:01:08 [+0800], Xie Yuanbin wrote:
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -270,10 +270,15 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  	vm_flags_t vm_flags = VM_ACCESS_FLAGS;
>  
>  	if (kprobe_page_fault(regs, fsr))
>  		return 0;
>  
> +	if (unlikely(addr >= TASK_SIZE)) {
> +		fault = 0;
> +		code = SEGV_MAPERR;
> +		goto bad_area;
> +	}
>  
>  	/* Enable interrupts if they were enabled in the parent context. */
>  	if (interrupts_enabled(regs))
>  		local_irq_enable();

What is with the patch I sent wrong?

Sebastian

