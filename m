Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C44C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8826B00B1; Wed,  1 Jul 2026 02:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08FDC6B00B2; Wed,  1 Jul 2026 02:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0F16B00B4; Wed,  1 Jul 2026 02:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B77D66B00B1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:25:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C791C163C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:25:35 +0000 (UTC)
X-FDA: 84939221430.28.AB42B2D
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F00A80002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:25:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="ZAEo/ZNk";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KH4gK04V;
	spf=pass (imf02.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.141 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782887133;
	b=qpklmXmrU1wcubPCJtDETkipaXoGj6QUm46+QkGjz1cVO272WdMSXz3RS2s7MTS4uTIxKZ
	TJ0Fuenzj4lFd9ptGYahGK5LHzGwYaEr/uWTtfz1MdlEKXjL/hFlkD/gkN6nlo5juMEx3+
	55XkbScUAFVYRbItHkGzFI6v4eRWwJ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782887133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b44fp/Xs200vmVmERTgFd09AZSIVEJbxoZ/zLTkjWAs=;
	b=xdfi+KkxLBQ4/bEGuKLrAAzeH2Cs5D6/AeQQstig2eNx1B4QxJ5RHEOLZzwogR7w3hliXv
	iFe1eWCcsNa22OjBxwGURWFhoG8H1v6x0svJJ1RRNH3rswHanWkvS7/8WYvpMAuGq3dQQT
	0N7niZX0h5FHwLG80sN5NvdGjhSCrTQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="ZAEo/ZNk";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KH4gK04V;
	spf=pass (imf02.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.141 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 35EDA1380326;
	Wed,  1 Jul 2026 02:25:32 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Wed, 01 Jul 2026 02:25:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1782887132;
	 x=1782894332; bh=b44fp/Xs200vmVmERTgFd09AZSIVEJbxoZ/zLTkjWAs=; b=
	ZAEo/ZNklCq7HmQEk3ZyRkEqqp0NAs1NuYnrrERijClIWx+s19L6FuvIXKdtFruy
	4V89DusI3RY+PWxVDApjhWzHTyjpdA2xSUWFPAsFdcFupvmlqwaUhmnKBG1Qj+A3
	aGgtYpFNkgAjsd/I4/5LLU/QklAxLdmIa7rQMcIiR6atyFIFZJTE5nOy6AMIH0RE
	lyvdf1uqqx8qwClvFZS3mWbrktvGFtDL2wj+5vdLJTyzu++JTDl0jY/qaQFuTovj
	gDaDaoC/5siXjVCoY0jI7GyPsU8yQM2K39vtKFpR3GQQ9wMuIymhBSRBRIY9A719
	BH0I0QP55BkqHPusExFKyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782887132; x=1782894332; bh=b
	44fp/Xs200vmVmERTgFd09AZSIVEJbxoZ/zLTkjWAs=; b=KH4gK04VMYiP2pLwR
	0x9WgN+0wkRQBW+gE0J4ZyalbyvhKPaSGAr1c3UqG2YKkiW5B8ELH3HIr9CXBe3N
	UQjjBRP6whm1/bfbFFamkf4sAOD7pGrqQWvYJPBn3NSiserEHozBs2EjA5I3GFBI
	VEvaP+gNWAudrlx9py8bakkizoWWV+qi7NNPJIWMEBk7/6izbZ1iOUtQwcnCZIFB
	/aqQlRI74LOsotM8lwcmH1Yw0Tv8CSz9W6J+X1v+9uiliFFPg2VX5AFAPiuJMez6
	Vd8bxd1c+PO36W6Zj5kUkNluLwp8Z4iQh1ooHvEo1wZpOs0IwOtaj8czVZu2nQ3P
	dtpXg==
X-ME-Sender: <xms:2bJEajJRWO8kVZq70X044fUeLf0f76XltHggeVJX48t491vhArm9TQ>
    <xme:2bJEah9SNFNYnnAb1J_vkZotnw3X4i1g3o8fu7TssuHiXQo5W2VjJZRgP8swVnGlz
    X4CymXicSA7ZWVxw69O8AjpeWLmZVDRxDX1oNv7x3h18SxceiNAVCYW>
X-ME-Proxy-Cause: dmFkZTF1VoUsxJAijmmlORYiQyK9Goe4LUYUDFLRIryl+jqUeZtZW3yO5gJDbpHv3EB9xX
    0aLPbAIfQieGYioCKK3co9wXz8U+shxephSBq5+VUjtIdlQEq07P/ElJPcfp3rEbsUbCW0
    l7whtRe1Yr3PnTNdRTBIZQJ9PcaK+K3csO1DgQcA8BLFNtW7cyHVxo3P2rmNk7SW0lVEt2
    /RD362A2qa/XvfS2m7DMJyFC7DMueziHirYypDh/c0u2a+Kc3xajINpZ1UwB7QSvGTZlii
    DLQiMQRnSTgxvgcLUTQzuPJ9XiTQP+uKdmA5s/je+k6H6aL16kXT8Ijk8X2Rcg/HGr+zpz
    7z/ssG2wd3dId5yDIhYXpEsbZGkwAzg/SZ2S3SltFeOeO49dDXuOHe8OVHJKD39gonqLBy
    gd2qKEm93sQu8V2hKL8wI1iRJbtjdBfWO7F9O82etnW+ff4w0qCiuMHKqZ509jgwm0ezaO
    yq2/pUblQLEf8lwgpKPFSyILpZHZRKofIJQfR5QP9emF7ID+ha6kqUuJDgzwO39OCs14te
    lNXcHj/U0d7hEDTA+yLc6mK6Os+/wuLZLhWF/Qxfba4P9Hiz42uRyERz+mVNyvqJ7pYzaM
    0WVqv/7cFLaZAEqmqZTNoBwuzXvL8ZbM9Sz3uNVKGMexSSDT9buVIexiEfkw
X-ME-Proxy: <xmx:2bJEauRPKsD8riqousolZE0WI0zXAE_JCKfx1UY3IMK9PKky9lP7vw>
    <xmx:2bJEavhFfU4kCmHPJrS1vVPtAVbhvCWvwICQzm9xJwnom6erP6Z9Dg>
    <xmx:2bJEakYaAolbEk3jQRR1gnJNxKPYk9wJisr8ue5-6jmqz4Di0prDYA>
    <xmx:2bJEarJJliJWNzjwLDjDG-UZUmdP2JUvsmN5H-BMD1reGuBdz3PGLA>
    <xmx:3LJEamxytfe7H_axgE5obOZ_MbiIy8MkZAEWJzfhzKF5EIjf7S7IGDjZ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5CAE8182007E; Wed,  1 Jul 2026 02:25:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AFAd_idRoH9R
Date: Wed, 01 Jul 2026 08:24:35 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Yunhui Cui" <cuiyunhui@bytedance.com>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
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
Message-Id: <ea525a80-1e6f-4304-a371-3ec17d91ee96@app.fastmail.com>
In-Reply-To: 
 <7988df83f6341ea045ebd7294af2e8907dbd5ee7.1782877663.git.cuiyunhui@bytedance.com>
References: <cover.1782877663.git.cuiyunhui@bytedance.com>
 <7988df83f6341ea045ebd7294af2e8907dbd5ee7.1782877663.git.cuiyunhui@bytedance.com>
Subject: Re: [PATCH v5 1/3] riscv: io: avoid null-pointer arithmetic in PIO helpers
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F00A80002
X-Stat-Signature: qpgug48yz1a4wrodnar5q8fyz7tp35f6
X-HE-Tag: 1782887132-502062
X-HE-Meta: U2FsdGVkX18KNaB1D8SXso8aCtXR2Iw5rWPfxqkIeLdrzcus9IxoYLdow5wyMYmreOzt8I2o+0RozbjR2JPYuGX92nWPWwzZTFBqnoKscROjqbFDaqQDeJxexIgUSJwq2kEkcjRZ6c510/amlrjQ4akWuMo+S0dPs2xlYxazaKE1s4n309VsEJTzGFUG/p1TYfgX54TW36UwEi3t9WHO2E11c4v8UReoZaxziFkyZ71KtPDS/ATTlUzkKVqMkU7xhEImDMo/yuPHjJIDATSUwpbwx5ARWAO3Y4BN02M9T++SID+wlLvXYiYhpMZ3srEnUH2F2FJ8vcDognlfEVRRt9rgJUwK5Yf5tbFD89Aj25NvV1j94IeeUxoPRL3ntfmMpvV3iwOP0qfnEELxQtWkW0SmuE02cf2qsTEVWAqqXODxJqlqAJ1hgVEbJELLJsOmYb8eT9g2zjjYX73+8PtUdd13Uo+7zglwq4lWlWcwr4vlFFXyKuWNRNfk83ckfZ1fgbtlOjx2ao346sr5lUVHhNtjurOq4wPT80DcWjqR6jWgA8yyLHEAwmc5cBIJd/r5E3OQbE5xXdYblGMdbcPC9SJLHX+iItjy6xfMPWnsuLaFUoRK262c9fsxQVl6YJYESNgNGxnoTGf46f5JB9DyWC75NP0My//sX5mV9EGqyTAECTZecI0dmhEVf79r3HNHiPqWSDWDIeA40dY6WM5OfP4SHOBvUqglnOfj4eQ490VJKjANmQNT+DmAVWrNYDZFh+r0M5HSqGHC9FuB+Vd+nPHlOaJrgdaP/72PHdaBurZIuADkwe0bJkO5w+1jRojFjYy7Vigtcdv9fhOCRfdas5q+omf7WVAJ0vW4ziU1Xn827zF0GhNBHHyQes5PQfOA8ouz7Rh0J3cScU6twhSNow/kxK6Up5GXzWKUXHWCR8388oWpwlDFymTIMVKjUyG43LXe7+ai6OR86ryjGHt
 8E6uSCjm
 8SR4M893W0wFtQfPSwfc8yDV4jDPAl4RN4x255qCaB/2755VoJ33QtZrQM1CbA7m6omfudDB6NaWvKXZGukSjLS/VfkjQHGIYjl0BR1r1sOcemhYoTsX/J/QP6Us3T1IGgX7SFJ3boL0C0l27q/crnmTQQCPi2mKjg9J4ukij5ikYbAV3HaZnbMGIOJlOc6OFdX6UbI/On/L0VBDIkNNaMITwQjLIguPWJPL6CpOGrmkG/i7sH3wqlO/097WA7GVa45e7OLd+Nx8EulOAWhL6ZNo+j+9FEfawT6UBz9Y98vuE/m8+zRExfLYz6CPJS6yVlETa7lhpKx/z+42Jm/yfkvZLuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026, at 06:20, Yunhui Cui wrote:
> @@ -56,6 +56,8 @@
>  #define __io_pbw()	RISCV_FENCE(iow, o)
>  #define __io_paw()	RISCV_FENCE(o, io)
> 
> +#define PCI_IO_ADDR(addr)	((void __iomem *)((unsigned long)PCI_IOBASE 
> + (addr)))

This does not seem to have any purpose, is this just left over
from the previous version?

> 
> +#ifdef CONFIG_HAS_IOPORT
>  __io_reads_ins(ins,  u8, b, __io_pbr(), __io_par(addr))
>  __io_reads_ins(ins, u16, w, __io_pbr(), __io_par(addr))
>  __io_reads_ins(ins, u32, l, __io_pbr(), __io_par(addr))
> -#define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, count)
> -#define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
> -#define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
> +#define insb(addr, buffer, count) __insb(PCI_IO_ADDR(addr), buffer, count)
> +#define insw(addr, buffer, count) __insw(PCI_IO_ADDR(addr), buffer, count)
> +#define insl(addr, buffer, count) __insl(PCI_IO_ADDR(addr), buffer, count)
> +#endif
 
As far as I can tell, just adding the #ifdef here should be sufficient.

      Arnd

