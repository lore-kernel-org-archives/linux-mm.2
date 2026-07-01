Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A769FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55B86B00AD; Wed,  1 Jul 2026 04:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06DD6B00AE; Wed,  1 Jul 2026 04:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDC56B00AF; Wed,  1 Jul 2026 04:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58B766B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:19:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D670C167D9F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:19:33 +0000 (UTC)
X-FDA: 84939508626.17.1707183
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf14.hostedemail.com (Postfix) with ESMTP id BE25C10000F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:19:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=K1AVRFkI;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="k iPaY/U";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.138 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782893971;
	b=KNjYVKa102UT+KJfkfaLJbIDzQUnkgkB4TaUuQEtfrD9SlWWrkHg6qjeDFjWOX4H19Kwlq
	+G4Neah+jL/iLQv5Wfs3rGK9nzSmOM7716ZDaooNTNl156xiEaNXt5Xz+HP2Fbt6Xl1waD
	MSsyT56vDHflbQXkbEvAHkYsG4Wz0iI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782893971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atm/oFB1k6o/+QMlFBz13OKx3DmwNZLM96tS29Pr8hU=;
	b=xqC8jiUNaQ2dzJqo37TuQ+zUoASTRTWUijC7kYWOhJcBeQdtqLRZGFeHiEvfyB08E4Yw41
	Si6zKP+tzRKz+TDS7eydN8RnAOZjKABsgB3p6627GQsFCugy092MhifntPp313TcgIyaZf
	SWnRjQbFvXuAJTnOWyDjV5y5ovqXu54=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=K1AVRFkI;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="k iPaY/U";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.138 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 229A213803CC;
	Wed,  1 Jul 2026 04:19:31 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Wed, 01 Jul 2026 04:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1782893971;
	 x=1782901171; bh=atm/oFB1k6o/+QMlFBz13OKx3DmwNZLM96tS29Pr8hU=; b=
	K1AVRFkIbXU1+TlESA73lCoZj4w01drEjtVNM2dgYeXN8CtYE6op3ikZ/8GDwEEC
	RMuZOdzHE21ZpHCOizk9L4gK+c9CGo8P6hhyTNfDV/wOxUb0e0MpgYZmXW/t+6dH
	smEoBASYTNWCLOXk5Jbtl/0ZJi9erI0qIGPgcMgMV3Ew/NPzZa4LIxiDmUxYCL+c
	yK8oaa+26WZM8iJPDZnFJRVk80pR3jRylRTpdE2A1+n5dW5BD4+pLluZqp9VgwQU
	mkIXi9q2Um9LLxEy+JKSE3Q60fhRlniCFuRH5/g33D3M1NYl34CF5GQc5n53F9xt
	Cn5kepwaoRbMs7HHqp4f6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782893971; x=
	1782901171; bh=atm/oFB1k6o/+QMlFBz13OKx3DmwNZLM96tS29Pr8hU=; b=k
	iPaY/Ua005wvf+bsQ/pbv7beYQi4BKVuSKAGtdOqyIGUgeuCXzL1xsbBtupHNdW/
	sE1ukihF+76MvC2mHYAEugHi66PRWJNhb/R0+yY7LKk75xyN0RxD6le8gIiVk5Gs
	DB50jTrjqFooq4KMl4nmEWzap1bZrRVjG5rBL0BkdPUlQpSdUBNEKGxjpG3o5Qop
	3ico2mD3vEpbH3yDLdIk1KeUrUi21Q1hibvvV71qcBM8wA0u9zMwXsHAlivnI6f6
	QDm3F/1mQwsR4kG5+yJ7XTx6VvrZG++9l4t5xzlBDA4ITWfsbE/1w/ZB3Fw8qle3
	+06tiEVkrQZ9y8Qu6/tFw==
X-ME-Sender: <xms:kM1EapagAks29Mlj6Hc9tVn10-N9GeiSr3f3R--dXG63jxphRP-6LQ>
    <xme:kM1EarP3O0ZM9HBVFzIuWjfPN70pwh9m5CwrQ0_B6jL1CVnDo3_rWKvohUHUq4iKT
    ATpwHUnijPxhQhyctojGblQMW3UQVrEtd287ZqFaKsFvx15tOjswito>
X-ME-Proxy-Cause: dmFkZTEeP3G8xkQ1KP2SrTZAasNCY4M11KLkbOP0XnfWNC56L/qn/u391laENuopD5qAGX
    XdSeYYcaBv6U+0mlnw2hojg24bMIldkeh9rJOlPHHXTtzPg61OMH6Gx+iskhxcRCmCZmZv
    QavFULhHqvGwLZkiRtpz3dNO7Waxs6/pvwvxnhzNoFetGCQZM42JLxmZGkKTYEecIwuICl
    Y2CC9WchXcEToEYwVevwrE9N+xqu5ZpX08PAFOH9lxU2U2ch9g5gEeV7Brt0Sh/zlWI/Gp
    8mR4RrKv7hZlyjOLkjY0vA0iBQ5BUM5fS4EV8M1tmtLpPpxoJuMH8Kd9lyq15ZFJfn78Pt
    VClB6BjhVMdiVYBbPJYeqPE3vBC+zz6n6Fuzn5HfWwyZDJpniXbGO3VZQo8FiPpqmUiA9K
    UJtupIKp1vwbXqLHr157ohtF0Q002sR8l1AYDqlkgdlTInmUYdsolbT+3dW3JoAZuiYOr1
    f1MhsV4HS6Guo6IQOLhFqOhJR1enGLBdSwe4FDyMz2Vj1KAYckH9WpT/puZ85UhGSys65p
    jCThNKAoBetrV8EAioQL7lY8AHPXoKM8zBXz5sK9iwdDL1/rKbkdmzYVqUps4apsZ0/jfS
    a2XsSeGWIcqQDyeYWYY9QL17fuyxcH488dnKgSvHjj5lRoGdRTHEEBqzSQVw
X-ME-Proxy: <xmx:kM1EaqjK-Q-QQqjwudu22I-4ML_A_b0oP3RF9myugQeQLVdX_ESRkw>
    <xmx:kM1Eamyj0NYYg1ZMPYC3cdgYclqhVqAZkUORLd6lGAC6eo1YzROHcw>
    <xmx:kM1EaqocZzkhUxt34UZqXUdB_uwBL1J-Pwb_SAhoVr14RC6ZmtP0nA>
    <xmx:kM1EakYm7um2lJ_bXL6tdlc17DYysxvtCyLnZvHT8V4gfpjmTtfErg>
    <xmx:k81EagCHXXhD8NQoqX1MdQCFcr3Uhmbp6ftT2TcxWhYaetfMYfkzI70k>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 65D24182007E; Wed,  1 Jul 2026 04:19:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A7c2EfDQgAZJ
Date: Wed, 01 Jul 2026 10:18:58 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Yunhui Cui" <cuiyunhui@bytedance.com>
Cc: "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Dennis Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>,
 "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Eduard Zingerman" <eddyz87@gmail.com>,
 "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
 "Song Liu" <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>,
 "Jiri Olsa" <jolsa@kernel.org>,
 =?UTF-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>, pulehui@huawei.com,
 puranjay@kernel.org, "Thomas Huth" <thuth@redhat.com>,
 "Andrew Jones" <ajones@ventanamicro.com>,
 "Ben Dooks" <ben.dooks@codethink.co.uk>,
 =?UTF-8?Q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
 "Samuel Holland" <samuel.holland@sifive.com>,
 "Zong Li" <zong.li@sifive.com>,
 "Conor.Dooley" <conor.dooley@microchip.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Deepak Gupta" <debug@rivosinc.com>,
 seanwascoding@gmail.com, "Andy Chiu" <andybnac@gmail.com>,
 menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
 "Vivian Wang" <wangruikang@iscas.ac.cn>,
 "Atish Patra" <atishp@rivosinc.com>,
 "Anup Patel" <apatel@ventanamicro.com>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>,
 "Justin Stitt" <justinstitt@google.com>, qingfang.deng@siflower.com.cn,
 Linux-Arch <linux-arch@vger.kernel.org>, llvm@lists.linux.dev
Message-Id: <220b899c-58fe-4110-a6d8-c6f25324ee4a@app.fastmail.com>
In-Reply-To: 
 <CAEEQ3wn8AFVqWZAiXfQd4a1ZzH=2L8qRX4W3S=KcmQ5FORjn+Q@mail.gmail.com>
References: <20260505062026.91724-1-cuiyunhui@bytedance.com>
 <20260505062026.91724-2-cuiyunhui@bytedance.com>
 <3720c3a4-cc0d-4ba8-97ae-35def0189e2e@app.fastmail.com>
 <CAEEQ3wn8AFVqWZAiXfQd4a1ZzH=2L8qRX4W3S=KcmQ5FORjn+Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v4 1/3] riscv: io: avoid null-pointer arithmetic in
 PIO helpers
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE25C10000F
X-Rspam-User: 
X-Stat-Signature: 7hhm9epochsq1xf55xdri4ijozxuf715
X-HE-Tag: 1782893971-6600
X-HE-Meta: U2FsdGVkX1/K1HR93E8QApY5DW0NALbJh+dMynaozJQjDzpYhtnfeNgcxEVuTK8Vr41HfcZkJhKurd4xIDNBGnKqVYQ+Az154ugBtZDhYcceS+dilgRZgAE+MGwap5HTOrclpcM+H+BGuj1MjaE4rSvye/royraQjQ5VCC8J1L4l5+N9wWKADsSUSsWXBGqeWzKiwxjP1gKt39i5/nETV0B9Ftq86vjvF72I3inrWgQWa6+U7xfG0fqa15rcRONKAHYUNSYZsLLEMLtyIOquMs5nwVsl8V//uRa3phoSe+NKldrj8Iq40woX0YUL4fwU7p0mNngyRsFpT20UaR9OtlmY3w7ApGBPH8qnBPQDvYUiOOh/q/22mw2W+Kj/fh84tJXJe2za9d+DIgpy5ivpYCr2yRcX8yBBd1hhG8Ai7bTo1goQsBJKZQLTcigCUFCu6p8h0/J+UA3XW7Jwqe1eGBuaSPT+mtAzmwd1BMO8SiiRzcjMvkTmH70OAdhS7Eh+ZI5NYNTfY7qd33flZjsZsVigs++Q4Q60UdNDu8Edkf/WM1vO07c8mAXUiSiWHteBxPMlwCp9v29fY6zA7RZ69jlkcK+09y4isE+MX/+oRwRxG3/trleqOjdZcqit9g+fVnq676OyyCCtjyiX5WUO07SPSBS75RJ2QIf4eB0NPaDV/Sg6wq0A8fItnnCPY7yuzkxkjSyqcNPLa42SUn+4ab0X9MrlAz/Dhoi3uXc0Gx4JQBvXn+ZiUJhhPy9JJbohZf4mztiJWKkMpBfFNRgfGaAGaPFMD5n1LBCJFhJrf5CIr2NZ2Td0VNmVEX7ATLV/9Tf0MmNqQyE0VyvL9US/dAAUolRSmCKl0csTYGNX2U3HVSKfgOs21ct8RuoRERH9MyEbuUmyWsOHy4b+O8q9q2UHRTCO7oK6zikrdFwK/SbElZvVHua4HijrgGlJJ267VjRn9mosRX4x5PoHbdt
 JmNftgZ4
 GueYoTuqX7ZQrJsu0zC46d/I/TqOZ1yrLJ8Xt15jxx6Pwm94EypuN8N0u7TUSP9kVFZerOszzaYjlMCX0xkMgTFpUkrUA5g8mSLI9rLRTesmTReiTBPN/36+40xFAZDkRQHz6cGPWxw0zRJSZtBBH0TZJOEil4ZfP1reVryTdbQa6sD8oabpLiz7kpIMfoImuDS2cRiGbdjt58bZIsuGNlPu21aER4XRdj1pGBF6rntDJv7njJKClAHUjfm2qTimtrmgTuFgCwpI8S4sg9PD4R4zNu+6AjDPzFrGxxHfNliWkT/RINzWJ3xMMA6M46rNfJ6TEKRueU3BOTGd0QbvuJcUZxc5m7KhlissPuGrJwoFtpU/2xOhlFp7zQaSPDWpXUhAg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026, at 05:11, yunhui cui wrote:
> On Tue, May 5, 2026 at 2:34=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> w=
rote:
>> On Tue, May 5, 2026, at 08:20, Yunhui Cui wrote:
>> > The RISC-V PIO helpers derive I/O addresses from PCI_IOBASE in ins*=
(),
>> > outs*(), and ioport_map().
>> >
>> > Under configurations where I/O port support is not available, these
>> > expressions can still be formed during compilation and trigger
>> > -Wnull-pointer-arithmetic warnings from clang.
>>
>> If a driver attempts to use ISA port operations in a configuration
>> without CONFIG_HAS_IOPORT, there is a NULL pointer warning because
>> this is actually a NULL pointer access that will crash the
>> kernel if the driver is ever loaded. You should not attempt
>> to shut up the useful warning here but instead make sure every
>> such code has a proper 'depends on HAS_IOPORT' dependency.
>
> Thanks for the review.
>
> I agree that NULL-pointer arithmetic warnings can point to real missing
> HAS_IOPORT dependencies in drivers, and we should not hide those globa=
lly.
>
> You are right about the generic ioport_map() change: the helper is alr=
eady
> guarded by CONFIG_HAS_IOPORT_MAP, so the extra CONFIG_HAS_IOPORT check=
 is
> redundant. I will drop that change.

Sounds good, thanks!

> For the RISC-V ins*/outs* helpers, they use PIO-specific fences
> (__io_pbr()/__io_par() and __io_pbw()/__io_paw()), while the asm-gener=
ic
> helpers would go through readsb()/writesb() and use normal MMIO string
> ordering. So removing them would change ordering semantics.
>
> I will keep the RISC-V helpers for now and only guard the port-I/O
> variants with CONFIG_HAS_IOPORT.

For the non-string versions, I think the generic implementation
should be identical to what riscv has, it should be trivial to
unify these.

The string helpers are a little quirky here, as they don't really
have any barriers at all in the generic implementation but go
through the low-level __raw_readl()/__raw_writel() loops. This
is necessary to avoid endianess issues and barriers inside of
the loop.
I think conceptually, we'd want the string helpers to have the
same barriers as the relaxed single I/O accessors and only
serialize against other I/O operations but not against DMA.
On most architectures, this would mean no barrier at all,
which is why the generic version works for them.

On riscv, we currently have custom macros that also do nothing:

/* FIXME: These are now the same as asm-generic */
#define __io_rbr()             do {} while (0)
#define __io_rar()             do {} while (0)
#define __io_rbw()             do {} while (0)
#define __io_raw()             do {} while (0)

If it helps unify riscv with the rest, we can certainly add
those to the readl_relaxed()/readsl()/insl() helpers
in the asm-generic version, but I don't understand
exactly why they even exist, or if you'd want to have
a separate definition for readsl() and insl() here.

     Arnd

