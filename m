Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590EBCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 18:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD078E018E; Tue, 12 Aug 2025 14:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55D68E0151; Tue, 12 Aug 2025 14:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D452B8E018E; Tue, 12 Aug 2025 14:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBE768E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:59:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B9AE1D62FE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:59:27 +0000 (UTC)
X-FDA: 83769018774.28.7EB248E
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8897E14000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:59:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b="BqWTKN0/";
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf26.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755025165; a=rsa-sha256;
	cv=none;
	b=X79hq1Yz2OkTYIXUoZ0iaKIY99gMSzBjNO5QQRlE9daQEnIEhva80u9LAbGmECO+jYNYYQ
	KuTSsrtVsuMXoE41kd7LTvDm8eRF/GWlweqPxrO1A3yKW6MHQ++kyPsf/O8K+yHW8oQSoD
	9XZpbBVKiKQ83REUa+rq49cus7Rnd+k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b="BqWTKN0/";
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf26.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755025165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DMQ0VBygMOvwakIBCsvDifzmVs+bPS4rzyHa/WOn+o=;
	b=a/5B9yXQ+QvQcwnGdEViO1rPat51i864kZtZSsdgX82WydfbY5EZSjSSkTgIkygyJ6bosD
	Z4A980AhcrEE11pAtgVUER4SZNEnP855CoCORAzifPW/wn7oyoO8Xk8DcOnrs6QZuTcSLo
	malUO6J4m8MR+ZgErOiQ5ZQ4A752xic=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=1DMQ0VBygMOvwakIBCsvDifzmVs+bPS4rzyHa/WOn+o=; t=1755025165;
	x=1755629965; b=BqWTKN0/JLL2AfkEmIlK3DF66zHWt6yRRl/fwRF5mTsh/4ydWPJTSr/IEYnft
	43xHriY+iqhJ1I+fa+V7Xn86FYWt4vvx8zL19Jv4cdYLAd+Uqf5kPPsivCKIoZdJ4edCiJgdtaOg+
	u1wGVykC7zBCSYCRiUuIPuHhB4MDlANbpJc1nZIVqI8IrSCGJtXVAMDkXDehjV642L2Jm34/prBno
	OMqSVt0eYKNCPV6gkZyjNRm8Jqf0/Vd4E12URlMlpYGM+YY30+U9AIvHthOdahsQSLGbIlgtvfm3G
	Vw9Q6wFiuvkxVaKcm4HWJxPjYgVCe2HxVjY2xXIt++CfleA2YQ==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1uluDJ-000000023LZ-2n1M; Tue, 12 Aug 2025 20:59:13 +0200
Received: from p57bd96d0.dip0.t-ipconnect.de ([87.189.150.208] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1uluDJ-00000003wKp-1aOu; Tue, 12 Aug 2025 20:59:13 +0200
Message-ID: <c69487a248eb5660aa817fdbb0f9a10d770feab6.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v5 18/23] bpf: Use vmalloc special flag
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "peterz@infradead.org"
	 <peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>, 
 "luto@kernel.org"
	 <luto@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Cc: "sam@gentoo.org" <sam@gentoo.org>, "andreas@gaisler.com"	
 <andreas@gaisler.com>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, 
 "anthony.yznaga@oracle.com"	 <anthony.yznaga@oracle.com>,
 "dave.hansen@linux.intel.com"	 <dave.hansen@linux.intel.com>,
 "akpm@linux-foundation.org"	 <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org"	 <linux-kernel@vger.kernel.org>,
 "linux_dti@icloud.com" <linux_dti@icloud.com>,  "will.deacon@arm.com"	
 <will.deacon@arm.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
 "tglx@linutronix.de"	 <tglx@linutronix.de>,
 "linux-security-module@vger.kernel.org"	
 <linux-security-module@vger.kernel.org>, "sparclinux@vger.kernel.org"	
 <sparclinux@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
 "linux-integrity@vger.kernel.org"	 <linux-integrity@vger.kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>, 
 "kernel-hardening@lists.openwall.com"	
 <kernel-hardening@lists.openwall.com>, "ast@kernel.org" <ast@kernel.org>, 
 "x86@kernel.org"	 <x86@kernel.org>, "kristen@linux.intel.com"
 <kristen@linux.intel.com>
Date: Tue, 12 Aug 2025 20:59:12 +0200
In-Reply-To: <7e4dfc01e132196d3ff10df18622252a8455d1b8.camel@intel.com>
References: <20190426001143.4983-1-namit@vmware.com>
		 <20190426001143.4983-19-namit@vmware.com>
		 <14437e403ed8fceacafe0a89521d3b731211156e.camel@physik.fu-berlin.de>
		 <1738e24239cc0c001245fdd4bd3811175c573ce2.camel@intel.com>
		 <49b112b80b211ae05b5f3c36a55f67041783f51e.camel@physik.fu-berlin.de>
	 <7e4dfc01e132196d3ff10df18622252a8455d1b8.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.150.208
X-ZEDAT-Hint: PO
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8897E14000E
X-Stat-Signature: d3wfuarm33f5qj51wttnee3jtns5486y
X-HE-Tag: 1755025165-315098
X-HE-Meta: U2FsdGVkX19yhRLMh2Q7eRvyJm9JmjimPM6PLs5rHEDODPDc5PBCqNgWVMGELsGHAk16iAo/+xn8qX8wUfedTUL/QHPQJBrAa7qe9YBliKoaXoblFH3nctHaAvQEcVb/N3nRPwK2qE1OKCDKXMw82+hA90M8nc8Jka9JuHwlwRSL/FXJzvKNiu5NMddVa6DO5GWW8S58C2XN1oRyhb+iV72ljNGL88/Myn0SMSMeQPKsrKKYRJ1qrjcGbWFJvHddQmRBkv4an8OSRn8yyqnvxkz19NOOLLjIi1EEfe9xwH92P7QRRcvxYuknJk8JL5KSQFdBh1atmekmV2bKgJhHe68EmOaFpt7rNebJy5XnwZXovG3Gf7P2pLFftWsJ3EoVtieAzcy5vhOX3xN+zM8Htr6o/+X52JjBBCYTJa8iFLpBxGIGRnTUpPqtFh78djM4k5tvLuGkGUEiDZtXzlb5aRshCnttLR/WWo/FBV6C+OAb18zjX0Jd7IbrCNYH6+4XZYcF5sQqohMCYDoWcwrQWVjF3S/YSgNOco6kKQ+IyEvkALLlhfKf1tRIDoJ8YWJiY0csuWwZRJTMmDpVK22whhcxjJ5qYKJpZH5xqaaBYesivPkTEvVPBP9jK/uIcCDVGcwajzPQW9QpfNYt0Ub5zjIW/NjdjXn3/IS2RteSWYw9Jn86Rf893qRB0rg9Vy1aX1Ujkfkfpvq3cLGV9yPWNO14drx22FqPZyV6O71mZgNx6VqRV3vW+9FsMN6EMXvklBWFtc1yMFIu1fgXQXJfNcLmPdE2UY8i//b9Cbt4VlRUdr44/jk11IkQ3xo2LiJ9EtqnLPmU6RStP89pd9wKOQX4Wx5fV/JTB+SeXB3x+UYUcMuEDF+fwjsdqWyIwg0QRT4CnQb5LhzbheDTVs7pv1FY3LCV/m4d52EkM7wSG5IVlYsde9CbxOPll33S0AQNeLDELejRDmGwBrJ31BE
 x/0yXLEv
 WOEx1pPPTH6F37b6orGtwPgZdBZbUNkMhEzxp42yaBO+Vhl5dwwm0Qu5b7NMCEpr7hYm3Kh9ByoK67+X4r2wn0C2tzGFEaG/hW1AwgavORW3CHVP7vnoenDtY+N38GVVlFYrUa2XkG6DI+PpJL/paCMJB6t7onUg1y33IhDp9JiQqwMhLDG5SftDyHk6fl0t2OyMXxJsp67cCk+o3UsE0ZSe0zmVphhjZceI0+YttKxmYDPF7s2CXKRJVjP6H7D7/OSy4IQo7dsPola5d2YOemSfEb66cD3LXG6V9DFDln4SKYkFiXLSPgyR2QnkwdXYnghRzjo4RqRzDW1K5bRuu2YF89AtEOxX9K+hURZFY23S99d60wXXqJlHJGXb6M1m5vzbIf7Mlsv3S5zBcyvExEpWjD/OakaWDgmk+PytP3Z1M5kbpJU3VeYh5aVOmBzitdTWQVrC93y9Xw29VfNPLBRgTO5VehsXi4wPtesi6hEAyE4y+IL6rirbttup4Xwfg8jAM/h20d+k8YybNY3U0URSWMrmMEvJhCwLSIc/dLqUGCwSdb1p69pztQdB46geP/zn87l0j108TbFZb9HcdokP39He5Js7ZuaLxgQqOqwvl84g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-08-12 at 18:49 +0000, Edgecombe, Rick P wrote:
> On Tue, 2025-08-12 at 20:37 +0200, John Paul Adrian Glaubitz wrote:
> > That could be true. I knew about the patch in [1] but I didn't think of=
 applying it.
> >=20
> > FWIW, the crashes we're seeing on recent kernel versions look like this=
:
> >=20
> > [=C2=A0=C2=A0 40.992851]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \|/ ____ \|/
> > [=C2=A0=C2=A0 40.992851]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "@'/ .. \`@"
> > [=C2=A0=C2=A0 40.992851]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /_| \__/ |_\
> > [=C2=A0=C2=A0 40.992851]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \__U_/
> > [=C2=A0=C2=A0 41.186220] (udev-worker)(88): Kernel illegal instruction =
[#1]
>=20
> Possibly re-using some stale TLB executable VA which's page now has other=
 data
> in it.

Makes sense given the memory is actually zero'd out.

> > [=C2=A0=C2=A0 41.262910] CPU: 0 UID: 0 PID: 88 Comm: (udev-worker) Tain=
ted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.12.0+ #25
> > [=C2=A0=C2=A0 41.376151] Tainted: [W]=3DWARN
> > [=C2=A0=C2=A0 41.415025] TSTATE: 0000004411001607 TPC: 00000000101c21c0=
 TNPC: 00000000101c21c4 Y: 00000000=C2=A0=C2=A0=C2=A0 Tainted: G=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=20
> > [=C2=A0=C2=A0 41.563717] TPC: <ehci_init_driver+0x0/0x160 [ehci_hcd]>
> > [=C2=A0=C2=A0 41.633584] g0: 00000000012005b8 g1: 00000000100a1800 g2: =
0000000010206000 g3: 00000000101de000
> > [=C2=A0=C2=A0 41.747962] g4: fff000000a5af380 g5: 0000000000000000 g6: =
fff000000aac8000 g7: 0000000000000e7b
> > [=C2=A0=C2=A0 41.862338] o0: 0000000010060118 o1: 000000001020a000 o2: =
fff000000aa30ce0 o3: 0000000000000e7a
> > [=C2=A0=C2=A0 41.976728] o4: 00000000ff000000 o5: 00ff000000000000 sp: =
fff000000aacb091 ret_pc: 00000000101de028
> > [=C2=A0=C2=A0 42.095768] RPC: <ehci_pci_init+0x28/0x2000 [ehci_pci]>
> > [=C2=A0=C2=A0 42.164394] l0: 0000000000000000 l1: 0000000100043fff l2: =
ffffffffff800000 l3: 0000000000800000
> > [=C2=A0=C2=A0 42.278768] l4: fff00000001c8008 l5: 0000000000000000 l6: =
00000000013358e0 l7: 0000000001002800
> > [=C2=A0=C2=A0 42.393143] i0: ffffffffffffffed i1: 00000000004db8d8 i2: =
0000000000000000 i3: fff000000aa304e0
> > [=C2=A0=C2=A0 42.507517] i4: 0000000001127250 i5: 0000000010060000 i6: =
fff000000aacb141 i7: 0000000000427d90
> > [=C2=A0=C2=A0 42.621893] I7: <do_one_initcall+0x30/0x200>
> > [=C2=A0=C2=A0 42.677931] Call Trace:
> > [=C2=A0=C2=A0 42.709953] [<0000000000427d90>] do_one_initcall+0x30/0x20=
0
> > [=C2=A0=C2=A0 42.783158] [<00000000004db908>] do_init_module+0x48/0x240
> > [=C2=A0=C2=A0 42.855214] [<00000000004dd82c>] load_module+0x19cc/0x1f20
> > [=C2=A0=C2=A0 42.927270] [<00000000004ddf8c>] init_module_from_file+0x6=
c/0xa0
> > [=C2=A0=C2=A0 43.006189] [<00000000004de1e4>] sys_finit_module+0x1c4/0x=
2c0
> > [=C2=A0=C2=A0 43.081677] [<0000000000406174>] linux_sparc_syscall+0x34/=
0x44
> > [=C2=A0=C2=A0 43.158307] Disabling lock debugging due to kernel taint
> > [=C2=A0=C2=A0 43.228077] Caller[0000000000427d90]: do_one_initcall+0x30=
/0x200
> > [=C2=A0=C2=A0 43.306995] Caller[00000000004db908]: do_init_module+0x48/=
0x240
> > [=C2=A0=C2=A0 43.384772] Caller[00000000004dd82c]: load_module+0x19cc/0=
x1f20
> > [=C2=A0=C2=A0 43.462544] Caller[00000000004ddf8c]: init_module_from_fil=
e+0x6c/0xa0
> > [=C2=A0=C2=A0 43.547184] Caller[00000000004de1e4]: sys_finit_module+0x1=
c4/0x2c0
> > [=C2=A0=C2=A0 43.628389] Caller[0000000000406174]: linux_sparc_syscall+=
0x34/0x44
> > [=C2=A0=C2=A0 43.710741] Caller[fff000010480e2fc]: 0xfff000010480e2fc
> > [=C2=A0=C2=A0 43.780508] Instruction DUMP:
> > [=C2=A0=C2=A0 43.780511]=C2=A0 00000000=20
> > [=C2=A0=C2=A0 43.819394]=C2=A0 00000000=20
> > [=C2=A0=C2=A0 43.850273]=C2=A0 00000000=20
> > [=C2=A0=C2=A0 43.881153] <00000000>
> > [=C2=A0=C2=A0 43.912036]=C2=A0 00000000=20
> > [=C2=A0=C2=A0 43.942917]=C2=A0 00000000=20
> > [=C2=A0=C2=A0 43.973797]=C2=A0 00000000=20
> > [=C2=A0=C2=A0 44.004678]=C2=A0 00000000=20
> > [=C2=A0=C2=A0 44.035561]=C2=A0 00000000=20
> > [=C2=A0=C2=A0 44.066443]
> >=20
> > Do you have any suggestion what to bisect?
>=20
> This does look like kernel range TLB flush related. Not sure how it's rel=
ated to
> userspace huge pages. Perhaps the userspace range TLB flush has issues to=
? Or
> the TLB flush asm needs to be fixed in this another sparc variant?

The patch you previously linked actually fixed this particular SPARC varian=
t which
is sun4u, i.e. the non-hypervisor variant with sun4v being the hypervisor o=
ne.

I was already thinking that the fix in d3c976c14ad8 was possible incomplete=
.

> So far two issues were found with that patch and they were both rare
> architectures with broken kernel TLB flushes. Kernel TLB flushes can actu=
ally
> not be required for a long time, so probably the bug normally looked like
> unexplained crashes after days. The VM_FLUSH_RESET_PERMS just made them s=
how up
> earlier in a bisectable way.

Yeah, I think that could actually be the case.

I wonder whether I can revert both d3c976c14ad8 and a74ad5e660a9 on a curre=
nt
tree and see if that fixes the bug.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

