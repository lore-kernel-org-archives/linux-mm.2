Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC8E4C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 18:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1352E6B00AF; Wed, 22 Jul 2026 14:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6D06B00B0; Wed, 22 Jul 2026 14:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40EE6B00B1; Wed, 22 Jul 2026 14:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6F786B00AF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:19:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A2F71C0452
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:19:12 +0000 (UTC)
X-FDA: 85017224544.14.7E8710D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 668E318000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:19:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bolhfH6n;
	spf=pass (imf06.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784744350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsZKe67h58zD6TPYh/iONlX3wxFqEjCYjEE0t327lqs=;
	b=kaZniuNF5/lEP74FE5qrA6n9WzseOQUq4lllYI+dNdPzBADcw6CGfPsBRCMyP90OiYfLK/
	TuG6+YDoJFGM1VXDJDQEf/jaCHRtC5hHwro1WOihCxn1A7w+qifYGEz8+2R917BfZyt8r6
	ojZ8sWYWrotkYsA5lxDHhd9rfibTbMY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bolhfH6n;
	spf=pass (imf06.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784744350;
	b=5WL2nXyumqXKvDbA5AaE/F0SlwzUg1jA9ArCXCa8d00i9zb1PZ2AgYM5sPlvtEVcxAjGrG
	xFLPxQjikeKHT1lpA54CZJUqfCUG7tWLBpsgDMqShrjJURiAjVRnAYmJS0Qv8OFstgS6gm
	tFDprSZEqHSnguAme37XYQ3TzDZuoS8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FDE21595;
	Wed, 22 Jul 2026 11:19:05 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B5263F59E;
	Wed, 22 Jul 2026 11:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784744349; bh=gexUY3MO1NYMIt5+4b+Z9AIUlrWUUcj9/Dzpwo5+F+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bolhfH6nwRwlZ9Rt3oQdeQtyGNQNwRenYiTJbVSlKyM4HgMURSH7uIWdk9u24659s
	 2k1ZgV/+heCaAiqMwoGsFmvLA+hXuMW6ELfIoI9wb6jJ4oFjYfiYROeaVy0CbVald8
	 470GVt3Ty9QsOpWvz+uIJHVKDIrr1Y+DFPdxaTBY=
Date: Wed, 22 Jul 2026 19:18:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Linus Walleij <linusw@kernel.org>, Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kees@kernel.org,
	oleg@redhat.com, luto@amacapital.net, wad@chromium.org,
	thuth@redhat.com, peterz@infradead.org, ada.coupriediaz@arm.com,
	kevin.brodsky@arm.com, yeoreum.yun@arm.com,
	anshuman.khandual@arm.com, james.morse@arm.com, tglx@kernel.org,
	broonie@kernel.org, pengcan@kylinos.cn, ryan.roberts@arm.com,
	liqiang01@kylinos.cn, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v17 15/15] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
Message-ID: <amEJkyKFvVOkiGao@J2N7QTR9R3>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
 <20260721081858.1169276-16-ruanjinjie@huawei.com>
 <CAD++jL=Ou_HF5VchexnjUf9qwzrz0xgY+NhA5gZhOwiwdxUi-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD++jL=Ou_HF5VchexnjUf9qwzrz0xgY+NhA5gZhOwiwdxUi-g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 668E318000C
X-Rspamd-Server: rspam01
X-Stat-Signature: wrbxjfi6k6dtmajz3tqmsizfe3tnxfsj
X-HE-Tag: 1784744350-792940
X-HE-Meta: U2FsdGVkX1/M4TPUdvwzR+Wk5lmf7/1X2q62hf29LNGaZ5ck1KKjuFnszEYIb4Anhu65hDcAIe1MO3MDsf4wU8cI0t8v56XPLcCdbAYyk+aCcUK2X9nVKpQCNWkl1nm9cKovE3434y6c26hxm8uRXqFuFuy9jY56c1ubz1WDwPLM65EYh3SEIwxyvklrCTBlS6Qm29Ii4D/jpEU2kMwafPBLWT6Ay0hhIagKqBUljMcyKRZu3MLQ/QRsn/STGBjctakpoYtavi277Gh5DXxklvdQ5DOlT9c/IgXntbwa8M5eaF1of0CgTHKnFqhEjuJQSsbyDubo5sUz0rTNe/AOf4SfbjB66PYgJYCXuJuSI/dYNmjwNt9ByYWD5fQJ25G9dzZTTC062yf04Ay/F7BbkK7cqomCBVX7nJiApT3XOhDEZKTskI54pn0vbtsVWicqNFJVRP/SLVJxt9kMxbc6oBUwj2zJNeSTVifGIvkFWpzHqtYdo7TFiBA4waQZfrynW8SOe/RuNHYmc9b0+nA5gAPlG3gbKoqvT+jauegPLZHTvzi+uz481cJSyE4B0WQJozulwO/H+1ronn1HcVxhTavk67E6Py1yfVPJQVQGXZp8forHTuaqu095KTGPtvSA2cKtMY0A55pxVKk1sMcnkOJXz5nG/4a4r5UKLKGtCrOLBrsu882SEDSxiiZrY+aPG9N2OZHYNvtpdoE1HA2Hlc7Jz9XK2qZo+LOsYYYhNETz03vfIiytKQuXCttMZsna/QH1gf/CPHcTDCfJGnFbHnU+/XodCNPim2CDZqMmMI9E76Pv7m6MXHu3S5Fy7ywM/fWmDLe58D4XeKQxBPKVv8pAVQjJh3jN53xVE5e5NQCIEJB2dDM8/3Deqi4Mc3QYyArvlwUMkPa1ZupYrz8O/lNPeLl33Op8jTPCIX4Q7HDkVTrvDh8UTCqdXjiE8hndHJTkMMaSLjyB4jpMuBu
 61RSgLtE
 E5I5PIqWVHknq0aCW5a2+vQwhQB7NU6Qwf/zmxzHKZM7LnWv1vacVp2tuXwMq26CJ9LlUNgvgRhE+3ZgQw1PMr27Rdx3e1kbVgw83hUPH7XP0jXzuYwWonGul8yrDrhr4Ki754HlyY3CskbXCM/OJmlqJJ0BbmmVNBxTEXaJ49dQLuM91vRqkbo2Fks6Bkb+bBtvZeXZ5NfBolzNggkL1K6hXkqeMxrc/YDlZY8+6SaCiwG5UWKr7Y7aDCAhm9gM2ZhVAh/hFZIpVmHAy1Moazf6HbQt/FpVQHeeGXUEwZG6yKTL/Yc/nW/LjIJHUq1MR8HXmpUIVLwtmXnmqoQ87MDRWZpW14dTMJvp0g8ghZ99rIrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:55:03AM +0200, Linus Walleij wrote:
> On Tue, Jul 21, 2026 at 10:19 AM Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> 
> > Syscall User Dispatch (SUD) must not intercept the signal trampoline
> > code, otherwise returning from a signal with a locked selector may
> > cause infinite recursion into the signal handler.
> >
> > Provide an arm64 implementation of arch_syscall_is_vdso_sigreturn()
> > to exclude these sigreturn syscalls from dispatch.
> >
> > For native 64-bit tasks, check whether the current PC matches the 'svc #0'
> > instruction inside the vDSO sigreturn trampoline (defined in
> > arch/arm64/kernel/vdso/sigreturn.S as below).
> >
> >         SYM_CODE_START(__kernel_rt_sigreturn)
> >                 mov     x8, #__NR_rt_sigreturn
> >                 svc     #0
> >         SYM_CODE_END(__kernel_rt_sigreturn)
> >
> > For COMPAT tasks, verify that the instruction falls within the dedicated
> > 'sigpage' range, since compat signal handlers use this architecture-
> > specific page (not the vDSO) for their return trampoline. This prevents
> > SUD from incorrectly dispatching syscalls issued during signal return.
> >
> > Suggested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> > Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> > Suggested-by: kemal <kmal@cock.li>
> > Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
> I'm a bit scared about SUD.
> 
> Certainly we can merge patches 1-14 first and iron out
> any trouble related to that and split this off so a separate
> series to be applied lated?

I had already asked Jinie to drop SUD back in v14, and he had agreed:

  https://lore.kernel.org/lkml/akegeU59jSK9t7FX@J2N7QTR9R3/
  https://lore.kernel.org/lkml/3ac6d4be-7c57-44c2-80a0-408e2c6f8136@huawei.com/

Jinjie, please drop this for now, as we had _already_ agreed.

I will look over the rest of the series soon.

Mark.

