Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7726BEF0702
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9EA56B0005; Mon,  9 Feb 2026 23:57:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BD26B0088; Mon,  9 Feb 2026 23:57:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C240B6B0089; Mon,  9 Feb 2026 23:57:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF7C26B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:57:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66D151B3101
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:57:00 +0000 (UTC)
X-FDA: 84427337400.27.60FACC6
Received: from xry111.site (xry111.site [89.208.246.23])
	by imf04.hostedemail.com (Postfix) with ESMTP id 65CD64000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:56:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=xry111.site header.s=default header.b=kUW2q5N7;
	spf=pass (imf04.hostedemail.com: domain of xry111@xry111.site designates 89.208.246.23 as permitted sender) smtp.mailfrom=xry111@xry111.site;
	dmarc=pass (policy=reject) header.from=xry111.site
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770699418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7S/RwYpthg8tXjbrJE4w6sTQLQrQ7h2vcjko87DBKI=;
	b=BDXPV/jXrg94ktN9aGkijN+xbc7xTV1g30nAwTnc5fynkd/0TBX3gS6Mb6DYhjS2n3A+Xd
	CGqFLPJx1Vo33Z5woVddYYatOuHrVZFi7FUzhGh0fcLg6LPNFrqoor+l+1tB0XZ1Ftrq3f
	HAde3exmn8YHcxw65jbTUYY384oKgG8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770699418; a=rsa-sha256;
	cv=none;
	b=oDpFTNsP2wZK4MZGOyOdIfKPsRu78IweUs7jm8Ey0VwTKGEavoUrDyRU4r0KXjc1NEHqDH
	xRItjOuZFMGMkvhh0ip6znqJf85pJWJZOWgMWcbV3VPESWuRoDUw4PR+ApMyl+5UybKBWm
	yOni4nxByxh5wh5nLgak51DW8CuUYYQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=xry111.site header.s=default header.b=kUW2q5N7;
	spf=pass (imf04.hostedemail.com: domain of xry111@xry111.site designates 89.208.246.23 as permitted sender) smtp.mailfrom=xry111@xry111.site;
	dmarc=pass (policy=reject) header.from=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1770699409;
	bh=S7S/RwYpthg8tXjbrJE4w6sTQLQrQ7h2vcjko87DBKI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=kUW2q5N76xasLaNR97zoGtQHnIvmUOvDpWavvSP0MvJkmykc3ybvyrdM4KaLzHgoC
	 Fcnw1yUeADhSYiqx1WEjmTiMvGcWZxeIBs0wc04T3hV2COZu8glN1w5vd0t25QbdGc
	 THeZf+UtqzZtojSxSzPa5sSEzqjbT270FTExl3uI=
Received: from [127.0.0.1] (2607-8700-5500-e873-0000-0000-0000-1001.16clouds.com [IPv6:2607:8700:5500:e873::1001])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 1DD061A43D2;
	Mon,  9 Feb 2026 23:56:41 -0500 (EST)
Message-ID: <32ec2da7ad9b0c65f41b7c3e14fb6d8e1a5c1865.camel@xry111.site>
Subject: Re: [PATCH v4.1 06/10] x86/entry/vdso32: remove open-coded DWARF in
 sigreturn.S
From: Xi Ruoyao <xry111@xry111.site>
To: "H. Peter Anvin" <hpa@zytor.com>, Jens Remus <jremus@linux.ibm.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)"	
 <peterz@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Thomas
 =?ISO-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>, Xin Li
 <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, Andy Lutomirski
 <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov
 <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Ingo Molnar	 <mingo@redhat.com>, James Morse
 <james.morse@arm.com>, Jarkko Sakkinen	 <jarkko@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Kees Cook	 <kees@kernel.org>, Nam Cao
 <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,  Perry Yuan
 <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Thomas Huth
 <thuth@redhat.com>,  Uros Bizjak <ubizjak@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-sgx@vger.kernel.org, x86@kernel.org, Indu Bhagat
 <indu.bhagat@oracle.com>,  Claudiu Zissulescu-Ianculescu
 <claudiu.zissulescu-ianculescu@oracle.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Date: Tue, 10 Feb 2026 12:56:39 +0800
In-Reply-To: <e31817cb-c102-485c-8844-d81c39eac442@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
	 <20260106211856.560186-6-hpa@zytor.com>
	 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
	 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
	 <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
	 <e31817cb-c102-485c-8844-d81c39eac442@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 65CD64000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9wys97dw1pkx5h6pwbk8tocmtrg8mdx5
X-HE-Tag: 1770699418-69520
X-HE-Meta: U2FsdGVkX18cUwRXiOXSFJEC6OfrK1l0XSyLmLspnNvDCTR0a8zOJCdV0PMZVoN55V8j8SwzaOrqghwEU9iibZo2VKb1ACpyvWkr7dE3vGRgSnignRoOfDB9jHfckeXJ+N2xYgFrRRKrlBTC9KRyQ8Rwl68FfOJ5PBEBJe8iES8QxC6kZLNYmlkaZdtBMHTakFK+ngILavhauy8YXWoLAs4tZJutBg1RBOm1wUc8R5h1PQzQIrQSIhN8PY17XZxp3ary2IipSL5Of6Vv1Qj+Fl80444WgNUOicJVDTP5tMvaSly5G8yugdGsHjNKgdMGAUSiRYMSVxspqSy1BPIyAsug2hmw8u/TFkJJoODytYQFhPhIOOy7NHoHOFhME53Os0fV3ewdIx22d02C5zQNvbQhb4A23BVkeSDLK+r5fPFUARjIAr/77VANFICbhmG23huHFEKKLe2GEZGG0SrHM3Y+vdyg/g7R6BaCVRB9Nv4JF1GLENEPFdT7LPMRvieedL3KyHz7Imay1Y6yvJluDV9e7UcYHDtOiE2J3cVNZj7XmIubcWoKnpWB2JKx8LbQsJd06iS/PXXPuwwv1nJijhqyZIJhRJ3z8EUd9fcl8hMUxadeMFlTtk6BlyAQD2kMxtTknYSOFjwJym1n1aJJ4y5sX+N6x9XVxhcu8JH2inlJguq4/1sx6NvnrRJZ6UXjRzcz+zSGP6+GoE4dDD5gHSemj6VPuAEmcBsEW+5Uibm/VZlBhuMAYD48BrCmHUSSUM4vJah6qwtiL9YSFzjMpTGrAlnsarbvJrPcQsC5ChEaeTzRnGaFqQ3+Lu8a7RvxQKM67yRo3hdtKAToRHwjn757ckE8FV1BaN3TocDioyA509kDazaFn0XIpIFJUOptfWO9tjTZS0gqs9fKGO0OdCYOwUjgJYevayc0H+77JeCeIHQnNNpB9aSKrSUiJl1urBqdixCbWlQxHJNEknq
 1SjjwxB/
 NYuyW/AoJa+o4v/kySePr60wiICraCuh+odSoa2fZMu79EUCXYCWFbLJ8IF6H4QuBHJdZEJuLpFWHnj1o7La1TUz3DfBu90PnDjf/doDqDzcc7dkxv+1YTjiChEb4xw313sHhO7j5/1vd9d9a3IPEXOrqUS31pdAsk/WQc6MmJGljLlrVCWMPd7g96vX6VL6iHC//yEGLqdBBfSIvuPLXE7UFSOwBVHQJtrPqa/BBK7wVjRUul/05ilX35QZ5djeecv3Et1rN6D5O1t70Ztg8kwTuep1ZTCdG/y6Ym1RxLPJ2BtEjtcpExEcx/csYTYQ9UigWJdd70zuq/B0SHcsCTpp+QjiSJb0XQHsMh+A+lDPC4uZ6FpZp3y6DnYZ1Z3qBurj4hyurKTi6Y/mAeecZJc+Nff8MNOkOX/WMI2kG6R4+ZPhqaudeh13/Ultu0Zbz6RW7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-09 at 20:51 -0800, H. Peter Anvin wrote:
> On 2026-02-09 19:11, Xi Ruoyao wrote:
> > On Mon, 2026-02-02 at 19:57 -0800, H. Peter Anvin wrote:
> > > That hack dates back from before the signal frame extension. It is no
> > > longer necessary.
> >=20
> > Unfortunately at least it seems libgcc unwinder does not handle the
> > signal frame extension properly.=C2=A0 The code reads:
> >=20
> > =C2=A0 fde =3D _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (c=
ontext) - 1,=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 &context->bases);
> > =C2=A0 if (fde =3D=3D NULL)
> > =C2=A0=C2=A0=C2=A0 {=C2=A0=C2=A0=C2=A0=20
> > #ifdef MD_FALLBACK_FRAME_STATE_FOR
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Couldn't find frame unwind info for t=
his function.=C2=A0 Try a
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 target-specific fallba=
ck mechanism.=C2=A0 This will necessarily
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 not provide a personal=
ity routine or LSDA.=C2=A0 */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return MD_FALLBACK_FRAME_STATE_FOR (cont=
ext, fs);=20
> > #else
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return _URC_END_OF_STACK;
> > #endif
> > =C2=A0=C2=A0=C2=A0 }=C2=A0=C2=A0=C2=A0=20
> >=20
> > =C2=A0 fs->pc =3D context->bases.func;
> >=20
> > =C2=A0 cie =3D get_cie (fde);
> > =C2=A0 insn =3D extract_cie_info (cie, context, fs);=20
> >=20
> > Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
> > ... _Unwind_IsSignalFrame (context) actually extracts a flag in context
> > which will only be raised up by extract_cie_info.
> >=20
> > Or am I missing something here?
> >=20
>=20
> Well, it looks like this might be a non-manifest bug on x86 *IN THIS CASE=
*,

But only if after the patch _Unwind_Find_FDE returns NULL here (instead
of a FDE of another function).  I've not verified it on x86.  If glibc
tests (specifically misc/tst-sigcontext-get_pc) work fine things should
be fine.

/* snip */

> Could you file a gcc bug on this?

Will do.


--=20
Xi Ruoyao <xry111@xry111.site>

