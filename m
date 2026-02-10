Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64CE1EE6B73
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725F56B0005; Mon,  9 Feb 2026 23:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4196B0088; Mon,  9 Feb 2026 23:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5926B0089; Mon,  9 Feb 2026 23:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0F56B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:46:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E187FC19A4
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:46:14 +0000 (UTC)
X-FDA: 84427310268.14.EAFA62B
Received: from xry111.site (xry111.site [89.208.246.23])
	by imf12.hostedemail.com (Postfix) with ESMTP id F32684000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:46:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=xry111.site header.s=default header.b=kKWQii54;
	spf=pass (imf12.hostedemail.com: domain of xry111@xry111.site designates 89.208.246.23 as permitted sender) smtp.mailfrom=xry111@xry111.site;
	dmarc=pass (policy=reject) header.from=xry111.site
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770698773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maTKwIrG4gBsB19kvjBipujcA/45nYbxMGmoeNQLwM8=;
	b=fmCFZ3JKAlHYkQasTswFhsuqhKYzNJFQ6xZm3YzO6xY+XTu/jPM+DrR7xYtxrLVjXhiGTX
	ziVsGuG+pYGMKnW7kx4WOBfsmB8a38+v1MagRQeMhvbjekLYZEJBiU6udjO5oBpwqrIHja
	sTtu4x2Q/EYuoJLB6UsnLFQoYPX51Yc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=xry111.site header.s=default header.b=kKWQii54;
	spf=pass (imf12.hostedemail.com: domain of xry111@xry111.site designates 89.208.246.23 as permitted sender) smtp.mailfrom=xry111@xry111.site;
	dmarc=pass (policy=reject) header.from=xry111.site
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770698773; a=rsa-sha256;
	cv=none;
	b=AAPb8MtBrS2dfwGVqbxGMwa1QfWI/XhjgXaMamv8v6J8VNYDFhlQpcBCFWXtZqrwGwF5EX
	JAgj8KB8wRV2M057CxX4KTi9l3RCyxxD4zOmI5rqeKKHjfxGwOWgQxOyVNB4X/kMPDJAW4
	TT8TeR428wGypas4nXuGuHHVmHYZ58g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1770698763;
	bh=maTKwIrG4gBsB19kvjBipujcA/45nYbxMGmoeNQLwM8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=kKWQii54+eoNj+a+pDddfbxUnYtyqYL9QkXLWPk5d9k7oyHdsvssdlqW8kEU1T9Hx
	 6RluLpriI+nIsXQ0NElu78VNhSgMgpkZOpzX27+uD1fO55tl/ToPiVNzbfWMNRAwdK
	 Uny7oFXe2ky4GFzVk0t/LFFt9R3UAULl3WLbRleM=
Received: from [127.0.0.1] (2607-8700-5500-e873-0000-0000-0000-1001.16clouds.com [IPv6:2607:8700:5500:e873::1001])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 570B01A40A4;
	Mon,  9 Feb 2026 23:45:55 -0500 (EST)
Message-ID: <0ee773dea213f6efbdac03009ee80f350b17c949.camel@xry111.site>
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
Date: Tue, 10 Feb 2026 12:45:53 +0800
In-Reply-To: <29D95765-BD93-451D-8FD8-54250ADE1DEB@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
	 <20260106211856.560186-6-hpa@zytor.com>
	 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
	 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
	 <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
	 <29D95765-BD93-451D-8FD8-54250ADE1DEB@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
MIME-Version: 1.0
X-Stat-Signature: c1fbbgd5i88d4rbdcqm17sn5czobt77u
X-Rspamd-Queue-Id: F32684000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770698772-359612
X-HE-Meta: U2FsdGVkX18FVsf+nwMm/0uqfBsTcpbZbxSRFy+YzrM3z/2wAfHms3f7Dd2r6uk2+8YtSKbdoES3cfNRGTCHfxizzMvdAljzo7cIvYJkbQ6MHODiDkKD/8A4HdqbRojgYAA3Wi3RFdbpCdncBCgpk8au2opBX4LWalH3p00Y/4/3PTiP+1k3grKAcCuimwY3PUl+qE2qy3+uNSsMsqJ6YiP+WqxT0m7kehfc8Eqg8y7MpEQ+NFpPDpVqRaSECrEnEcnEOW07fuQkRM/gWLbXnt7BVt+5uSkdQ8wBEIf4MintZrlUghDNEtLAyPlk7fYTHYKRzCfEo3Xow28AAQxinw4PGDnNRuzWhvB2mWqRh1xDvOPWl5Us54bpcFdzs8l68gGVQft5H6fSmF9Oea/vyacGx72iUG71WcISlpuNqk7jl6dVe2Z1VVus2aKhYvP2Oexj2hWmOoCvINNyE5WW6YZCrIzR+yNrvtWZaUMvSC6OhHHCjyjM1dhTVnHu0S7Iz4X9PvE2CILyt8jxTXb//pBweiJ45VFnt41RHnVLBQtN0UPSAav6SyGR52DM7sErmCn5tSQzdfdElyYupn8ut21WYR9dYmB68zo5eUWaL/zX4U0ppjhsRQ/QmFbVWzx3O+Oi+ufQm8/IwWbWmBLIjx47NKbOv2T17aR2TLocdn4W9Av4XNWdB/yDotESUrwRjoESq9+254YIpewKDiEm3rEY94er54iV0Ahyc9VSrtJb1K1Ud6MbgS5z2ySLFHx1jTLLFHwwzYQak1UCAZELxP4bYDMsrVE1RqOswdxRb1zILCABiqJ9X2waqJefb+2UP+MiQPqv4pK9YQ/ypNVqkwyUtYjhbjAwwS2rK+anfRt+b1wXMO7cd/U3m+o1Yq1wQcE0+fa0nfIEV6KzoNX614RNqEYyDm2ZvcLxEqBifo5XoNogJx7PljzUL8qFVMKwqnc5UFq9+v0nCcKGZix
 3/RmC9iV
 44WghWOO/GfJL9Tx7x6RgBOSLJ0PhK9Uu+oJ8j7Tl6mDh987MBZToebnB3Po6AukO7uF5QzwrTtFr6nOPnHbXYSbk/O1ip6XKg75nMS4Z+JMNcBBBjKHP0mP2qFosPhmMSN3j5XknROHFGBZfWAvBX50yHxP6qMD/B5zOj5ILoZ+aq4Y03Qc8wGgnVgl1Zy4Xm/QF+jqHnafHbNwAB5qR1CpS3yqm5O6vhOserWy3eKYNDk3s/d7VgaQQ0+5HTjEtqDT5+X+IuaFeCVDW6NqTxNgWQbkkFqmgr6ON0rcI8M8G13+NvRBVvWQPPZr1O7lAA6pzxk9bCcHgBKXALWoPibYDLzEPkLVPMpRKZ3zL5/QWR1dRcNTMpl9X8MRWwos1m7FtgJ28PttpE1xYKmCniXNCFkQek6EZn5M8HGKDTleeL8r8AOcOMWmQAKAFB1EZYH29
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-09 at 20:15 -0800, H. Peter Anvin wrote:
> On February 9, 2026 7:11:25 PM PST, Xi Ruoyao <xry111@xry111.site> wrote:
> > On Mon, 2026-02-02 at 19:57 -0800, H. Peter Anvin wrote:
> > > That hack dates back from before the signal frame extension. It is no
> > > longer necessary.
> >=20
> > Unfortunately at least it seems libgcc unwinder does not handle the
> > signal frame extension properly.=C2=A0 The code reads:
> >=20
> > =C2=A0fde =3D _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (co=
ntext) - 1,=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 &context->bases);
> > =C2=A0if (fde =3D=3D NULL)
> > =C2=A0=C2=A0 {=C2=A0=C2=A0=C2=A0=20
> > #ifdef MD_FALLBACK_FRAME_STATE_FOR
> > =C2=A0=C2=A0=C2=A0=C2=A0 /* Couldn't find frame unwind info for this fu=
nction.=C2=A0 Try a
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 target-specific fallback mec=
hanism.=C2=A0 This will necessarily
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 not provide a personality ro=
utine or LSDA.=C2=A0 */
> > =C2=A0=C2=A0=C2=A0=C2=A0 return MD_FALLBACK_FRAME_STATE_FOR (context, f=
s);=20
> > #else
> > =C2=A0=C2=A0=C2=A0=C2=A0 return _URC_END_OF_STACK;
> > #endif
> > =C2=A0=C2=A0 }=C2=A0=C2=A0=C2=A0=20
> >=20
> > =C2=A0fs->pc =3D context->bases.func;
> >=20
> > =C2=A0cie =3D get_cie (fde);
> > =C2=A0insn =3D extract_cie_info (cie, context, fs);=20
> >=20
> > Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
> > ... _Unwind_IsSignalFrame (context) actually extracts a flag in context
> > which will only be raised up by extract_cie_info.
> >=20
> > Or am I missing something here?
> >=20
>=20
> Oh, good grief...
>=20
> How does this possibly work on non-x86 platforms?

On ARM64 the vdso does not have eh_frame_hdr at all, on LoongArch
eh_frame_hdr is empty (note that an ampty en_frame_hdr is actually buggy
and I'm trying to fix it), so _Unwind_Find_FDE returns NULL and libgcc
falls back to MD_FALLBACK_FRAME_STATE_FOR, which handles the sigreturn
trampoline using some machine-dependant logic.

On RISC-V things are more theatrical: the sigreturn trampoline happens
to be at the beginning of the vdso .text section, so after subtracting 1
from the PC, the result is out of the .text section and so not in any
FDE.  Thus _Unwind_Find_FDE returns NULL and libgcc again falls back to
MD_FALLBACK_FRAME_STATE_FOR.

If the RISC-V sigreturn trampoline was not the first in .text,
subtracting 1 would cause the PC to be in the FDE of the previous
function and then _Unwind_Find_FDE would return that FDE, then RISC-V
would have some big trouble.

I've not taken a serious look at other architectures yet.

--=20
Xi Ruoyao <xry111@xry111.site>

