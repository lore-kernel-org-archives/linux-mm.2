Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A1DCD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 06:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A966D6B0005; Tue,  5 May 2026 02:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E226B008A; Tue,  5 May 2026 02:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9841B6B008C; Tue,  5 May 2026 02:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8710C6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 02:34:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C035403AA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:34:08 +0000 (UTC)
X-FDA: 84732401376.21.C72CC90
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf30.hostedemail.com (Postfix) with ESMTP id 39E628000C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:34:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=u1R7aGqI;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ajkXX1nP;
	spf=pass (imf30.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777962846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSzVT7Fb6Q1GJvMmXV4hAtUQgAfzR7myXYKHCqT7Zp4=;
	b=dyHefc+lbu2V+11n3PCDSV1uOIanwwj2MyPSFeFy6X1+pRlawuCrLym+mTFNGsatwtx35j
	LzcUzLPibfNrnbEXV4MRBEZYrJCo9CA1qVibDJptlDUQQFrKc5JKF29DoHUkEEf8Vi+WGz
	JyxXuqP+ghSRLKZprcdrHDJDlj6teE0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=u1R7aGqI;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ajkXX1nP;
	spf=pass (imf30.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777962846; a=rsa-sha256;
	cv=none;
	b=FWCcusyNfRPFJBXoELEiOj/QaJ3cqEjmhTk6gFiyGkz+m0e0v5gBQ96mfPoQii9Tx2H6yv
	03OKX0vF8SWZb3+o4sTJXUlyleEv9wgNB1rRBMYB0L/LE00dCy8/V0YL1S15/SMviVdt8I
	JoB5SRUuciZ7ZmIdmVgxf2yMsfYLdCU=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id B09DF130028C;
	Tue,  5 May 2026 02:34:03 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 05 May 2026 02:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1777962843;
	 x=1777970043; bh=mSzVT7Fb6Q1GJvMmXV4hAtUQgAfzR7myXYKHCqT7Zp4=; b=
	u1R7aGqIUCFHM+/QbYGpsFVEKiZeLoCsSxD6etpr4TI1UhmqIl6UT+oFHi8hc05w
	0Kh9aq4ttEtsryomzEJEv9kPB8Fftb1JtIP+uWtc9es/UdFJvjtmfZByxSRQdISj
	hKwz24Zmre1KLPUOkI0Hn/wASeAoPUQh12qShGm7UZNKBBQ4FfTdc/jHMpYZui62
	mzIdz6iBI/24IO3jpBXC55Edd6Px2sYtlBrDGRQblJjdavx2QnZCA9BgMQkeBB7u
	l5yQ4GsAKfjqk0an+lys1CTVV83c9xbtX2TyR/r17pep5BV10h9nr1XzvPWxNOEw
	sTQbBCVBg+MY6GIg4QycmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1777962843; x=1777970043; bh=m
	SzVT7Fb6Q1GJvMmXV4hAtUQgAfzR7myXYKHCqT7Zp4=; b=ajkXX1nP6snZdVKF3
	j0gwvAj5S9cREUzuND2pMdCFhf3YMYp37T1kxU4Gsk48v/h7/ose5qJRMEIzdGgs
	fe8yA5TFh4XHKm4b76NQUwZ48xElDEi9fmTKyKk4KYtJrSRjs+Vmc8yOGCPcY317
	4ju7HH81ucPovlqXA79zHL+ulbK8niU69ZTg0Yxq1QCqk48a7+hgSkv7Inl2WBi9
	vCclUolYb4Cc7GXKp7lbbXxwCu0c8xFvQl+TPgiEqPmp5bQAU+kLKBTvSvtXZMhF
	bIz6HbPn4psmb/MbWw7iG7uOE5/SBBx/d19Wbh7PwW3mWspWrXXtMKqj2yg+Fwpa
	roBXw==
X-ME-Sender: <xms:WY_5aTmdaM4OKhG8xWdJ49xyodp-nrw4qj7CQ51RPQU42f9CPTX39A>
    <xme:WY_5aRr75hktxD3-avGWlXJ-Zw0-igJgXhKy1Xing9OPwcM_Omr4mn_bAo1ux33Fz
    SSGlHbI-bwj8TbyQ53wq3ZCUlq1_DIpB8GW-6iicUhEU7YsOm-mOKc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddutdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvffkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhkeeltdfffefhgffhteetheeuhffgteeghfdtueefudeuleetgfehtdejieffhfen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeegjedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheptghuihihuhhnhhhuihessgihthgvuggrnhgtvgdrtghomhdprhgtph
    htthhopegsvghnrdguohhokhhssegtohguvghthhhinhhkrdgtohdruhhkpdhrtghpthht
    ohepphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghpthhtoheprghouhesvggvtg
    hsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopegtlhesghgvnhhtfihordhorhhg
    pdhrtghpthhtoheprghlvgigsehghhhithhirdhfrhdprhgtphhtthhopegrnhguhigsnh
    grtgesghhmrghilhdrtghomhdprhgtphhtthhopegvugguhiiikeejsehgmhgrihhlrdgt
    ohhmpdhrtghpthhtohepmhgvmhigohhrsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:WY_5aRP-G1AZF66xxJHwKdzzA4REx0aM98VL9jtjTc-7cNqSRC2JrQ>
    <xmx:WY_5afupNhAomgYOUp9eRs5fIzdUV3vo78FkWK8Y5wILvs0fjAzaHQ>
    <xmx:WY_5aY1hkGHq06h0lw9neBCLRVCRbvSxiX7tdKxyRk5szccY56SvQA>
    <xmx:WY_5ae1sqHKpt2devCX1YzTH1h8JSb6XlF2sb-7RTsitxUPltD_8BA>
    <xmx:W4_5aafHexNRNA4nUj3kE13hAfhlWJDQLkDJihm9sNYAgzDk-Kj8TeiD>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 10624700065; Tue,  5 May 2026 02:34:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A7c2EfDQgAZJ
Date: Tue, 05 May 2026 08:33:04 +0200
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
 wangruikang@iscas.ac.cn, "Atish Patra" <atishp@rivosinc.com>,
 "Anup Patel" <apatel@ventanamicro.com>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>,
 "Justin Stitt" <justinstitt@google.com>, qingfang.deng@siflower.com.cn,
 Linux-Arch <linux-arch@vger.kernel.org>, llvm@lists.linux.dev
Message-Id: <3720c3a4-cc0d-4ba8-97ae-35def0189e2e@app.fastmail.com>
In-Reply-To: <20260505062026.91724-2-cuiyunhui@bytedance.com>
References: <20260505062026.91724-1-cuiyunhui@bytedance.com>
 <20260505062026.91724-2-cuiyunhui@bytedance.com>
Subject: Re: [PATCH v4 1/3] riscv: io: avoid null-pointer arithmetic in PIO helpers
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 39E628000C
X-Rspamd-Server: rspam06
X-Stat-Signature: auhcw4nacya7picwiix3gsdyrfy4j6ns
X-HE-Tag: 1777962846-207218
X-HE-Meta: U2FsdGVkX18C1+qpPpvazNBZdScIQkP0X8Rkj+EUFo/bjCcudVyvriGXQwfjpsCXHPtVrwxl3R6r6U/uh1H0Y5x6k4V41pKh8+FUt3CznHiWJwKh63bNqsOcmwWBfIzgBernjJKnUBx44jJVdn96ExdFvOrg65oxnR6C2VaENnF+t5wdP38/f11XbzxyykeW4fCtLyL/AM5TK8Oiz3AM+L89zTdoqC9MiC2cpvTSHSp448zFL6THcC1/nihuDYGD5k0TUgv4T2kUgQ8dmjraUcoNMFCrlBk38cWR7oLNfGbA/5xUsH9QE3og7npJZ+D6Rk+5TuPAPs9+6o7Ya+2BRrdhPsM6arUqw419XSNjEtv2WVbuEi1le9V4y7bRt2qs585xyJugg/vY2EsONQKjtQAQQYrrBT28j9bTMjfMT5ig7wvkTOnsf9wQTMCelq1AaP4Eenh4WqoG+DE5aOLcl6s9Pz+Bx11IUkA7m5m1/zMHx7/s7Mfs5QVtobVSkbLG2RAN6vdq0kwk/l4E8c63iLkcyGoqlhJtG/E7jEEWlOx7V+X+jWRKVAMnUhmRlQs0kCgDE8dLNw+R33xMVAB1fqqeOeXn9Erfo8QhK01zX4HfNuTJw0eDTrdgkFIX8kL27nnXJF3YMb3tcOkg3qbx6yVMd50VQc1F2tENvBi1/9ahoumpSWn/lqbozqb2RmscM6V0J0ZPbfAwBW7MING8/IT55JsrFSuB7bmZUnvsPCcF+UVDK2MvMjZP/err4+ExygaCZ/L8zHfXBg5o2QOYHTHkoDy+k1qgqFz+XZJ7W0/5t8FWqsM0w2M1LggmeOk+vQd30lAmJR3ucpY2DDSpeERoblQN9a3MBgyKmdSjOWo1+p4FWjai+fJ6y+HOS3E/voa1ZqHpFt6RUON0b6UuLNPY+cDFZDMFJQWe1QObX4+V88YwVkjaE+n9ZCZGQwUJjUnFQceRh6z+VShw1uv
 ZW+LKOmh
 I52s3yqoEVQT9lxpCV3P2Vst/txON4Tx5w0kxl4wsfPyY3YHOSi1akI4dYovATjXc9DTeu4rG9pN746owuNXPn2xgCISICUdZhFJtB0OBKMvrhizUWv1pOkNjrZzjhb/DiOja3na5W8qGnuYAjMt/pVmH/54yIqW37gDzad1ze7wob/YwJA+B0XhSfKI/wjhnfxQsEgK4V1/D7eodEc9zTRovpdP1Mjsdd/uoMPwpVTXkF0Sxin5V0kbls5xnUVgVfTZW+MPidpLKgUnUoh75vSUgl2RbFO1kMJfDQeraw9DFJtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026, at 08:20, Yunhui Cui wrote:
> The RISC-V PIO helpers derive I/O addresses from PCI_IOBASE in ins*(),
> outs*(), and ioport_map().
>
> Under configurations where I/O port support is not available, these
> expressions can still be formed during compilation and trigger
> -Wnull-pointer-arithmetic warnings from clang.

If a driver attempts to use ISA port operations in a configuration
without CONFIG_HAS_IOPORT, there is a NULL pointer warning because
this is actually a NULL pointer access that will crash the
kernel if the driver is ever loaded. You should not attempt
to shut up the useful warning here but instead make sure every
such code has a proper 'depends on HAS_IOPORT' dependency.

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

Can you try to remove the custom accessors altogether and
use the ones from asm-generic instead? These should already
have the correct behavior all the time, in particular they
already come with the correct #ifdef check that is apparently
missing in the riscv version.

> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index ca5a1ce6f0f89..d799e5ccc9437 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -1205,8 +1205,12 @@ static inline void __iomem 
> *ioremap_np(phys_addr_t offset, size_t size)
>  #define ioport_map ioport_map
>  static inline void __iomem *ioport_map(unsigned long port, unsigned 
> int nr)
>  {
> +#ifdef CONFIG_HAS_IOPORT
>  	port &= IO_SPACE_LIMIT;
>  	return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
> +#else
> +	return NULL;
> +#endif
>  }

The function definition here is guarded by the #ifdef CONFIG_HAS_IOPORT_MAP
check, which should already prevent it from being visible when
CONFIG_HAS_IOPORT is disabled.

     Arnd

