Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840EFE9462F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 03:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23876B0088; Mon,  9 Feb 2026 22:11:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0146B0089; Mon,  9 Feb 2026 22:11:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1D26B008A; Mon,  9 Feb 2026 22:11:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4356B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:11:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 196141402AC
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:11:46 +0000 (UTC)
X-FDA: 84427072212.11.19BEF4A
Received: from xry111.site (xry111.site [89.208.246.23])
	by imf25.hostedemail.com (Postfix) with ESMTP id 348E7A0008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:11:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=xry111.site header.s=default header.b=jEcl0Mom;
	spf=pass (imf25.hostedemail.com: domain of xry111@xry111.site designates 89.208.246.23 as permitted sender) smtp.mailfrom=xry111@xry111.site;
	dmarc=pass (policy=reject) header.from=xry111.site
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770693104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9px7Ui8PtzZwXAEBRwukPtIGEvdyEJKbwGQDV4ujkZs=;
	b=XmA1+M9aTwp4b3MlH6JEl8Cfqpyt01Val/CVXQp0OH5bvR6Vb4SCzhuoG8kKwc6VJ8kbFy
	G2YrcF2fIwR8lIJRNyj4HzQFxQtc70SuWZtJGpCXqerLXfxugJI6Gm0iN+6bosUuvFN4Pg
	tH9NGuv8V1a5vIXopDGmG/clrTWzoZ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=xry111.site header.s=default header.b=jEcl0Mom;
	spf=pass (imf25.hostedemail.com: domain of xry111@xry111.site designates 89.208.246.23 as permitted sender) smtp.mailfrom=xry111@xry111.site;
	dmarc=pass (policy=reject) header.from=xry111.site
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770693104; a=rsa-sha256;
	cv=none;
	b=DjkgV49D35xhogZE71rtQ3aFMSTGvDfL1xjBrEnzlhZRgmX2h+ff01N1fIOpaJxHQLXSMO
	NuUC/VjQCslbSY4s0H0cu+VMaaKgmY4WUseU1K1ubT9c4aTLome1GGJ+YPcJK7/4M5MZZP
	3PK32CVa6y9bwwBpnm3LiFT0yxWlYpk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1770693096;
	bh=9px7Ui8PtzZwXAEBRwukPtIGEvdyEJKbwGQDV4ujkZs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=jEcl0MomuTS76a+go7td6z8P9IRn2Z/4QJdsB/xPIwJFVyTlRwVNdjujKmVAWJsPA
	 PeSMLtk4blAC8Np/J5hek7wugWB3PNaqKpOCdtVmRtXqR8C0h1xm/2wkBZ/XTnI4EG
	 3zsDS1m0iWTOmATN0wENIaR8hVpSn7DzOKXbH4cU=
Received: from [127.0.0.1] (2607-8700-5500-e873-0000-0000-0000-1001.16clouds.com [IPv6:2607:8700:5500:e873::1001])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 64DD31A405B;
	Mon,  9 Feb 2026 22:11:28 -0500 (EST)
Message-ID: <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
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
Date: Tue, 10 Feb 2026 11:11:25 +0800
In-Reply-To: <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
		 <20260106211856.560186-6-hpa@zytor.com>
		 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
	 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 348E7A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 1nk9mcw6dcgs4xqkn89jfy65kd8x6nte
X-HE-Tag: 1770693103-824501
X-HE-Meta: U2FsdGVkX19jLF8zOZUWTT/W59jW7XyLMvUUK6aBBlyrvFMgB4n1DONtr5gVGQcb9gwfhzYie3yt76yCbcmgeVeX+tSlLyBY/0CyjWqvBcNYoUTrg7v+Gh/bUBdV+vPKxLgIdIpoKXpH4iowUga8kIofn5q/17st2crImw7lf7xWOM64SYWTz8gKXhDT+8wAPaLBuFILkVqPP8txvy3mSqGy//NmEi+hrzHf+02i0qcMybRdH0l8JbhvNusswtdeBBa8k/4fZwsacfOwT38YQ0t1LW6m5TghSNkhjqSJJ9WP62PX3HaCJzuboo4+mt4JX1yFTqSXObyU2XjzKSqf1P9FIzkHtAPiZYQATeKTTYX/pxxtZ7QF9ppov0puUEQ9xUCEMykKnk9SgiqjHQxylTrBiIEin4UTQZGPY6EBS3DCf1k5OSjumWkYLrbiJ54SToRJJZR0yvC+VpAxVbw73U8446Z+E4+OauNulyvLqcIvz3FY1oeDbUNVhzIGcb6h1CVY3BD9wvdD2KHGv0XyI8jaHs6T1riBEWTgV58lZrkLUb2Da34xu/1pcFF6eV+akORzyYZvk5uNRFajHUrjVDX1T0xr295WBLBBibNwx7EoSD4JSVmDx6Eud2UEre2v34LOHM6YM4689JpsRuBFjDfZtsHluqY8Ekf2jj4DdWhtPPMVZAIWrgef4iXWfMV5lwnOSNxH3Udb+CNjFSSE9g8sUI6V5Zki3RK8gOCvQANtCNPBmn+ncS/aoWwaLvMgYbKEjBQkP3xU70sIef9kA/UCKryPH/Tr/bQThaI51pENv55ooqTNDDJ0tR9KUPWjV2Mmz1oVa0cK0AQrIaQ5Ah9ZXVAgrVt5TQFp0ec5hxXK3oCS11A9pTC3cIaPddzsQvfKSilJOOZoKxXUWyW7r5r8GlpyE+0mnOtFb+YLZaOITESLgpm3MxvDdsnTWmTtZKw1y2BWfmbIzAKe7ts
 Kq9amVVt
 tkTcR8umcI5aRvA9Bumw0ppTvadJsImQxPOj+0Uy7rRmJzvwmoOquQPU1jI2kyzymEkeuj3rErtgoHL6Guk6Qy4M1uG9pz8Obz6ieg5rpU6pB0ZGnwhn6ueu3d5JYuw6iZ2M+r192/fC8iRj71XS6BLHBueR1oHcR+xQhogJLbuhG9LAMQBAVTecIRrD9OxYbjBbynqCXvmdkhfY7kk7nzsYT8repH1v8JmTcA1k7oq2KOXvQYvXxz/eJozkHiXx/JOid5wRSGG5GIdfVrQnrtAvBMThlVCF4QLSzmGiYsFQUOsMl+uOFC7HJbiWkjLD7Ia+Rof8DJ6MGjnMEUVVbmFV7Yv8SSdzJfEVKeiyWNd1YPjgA1Eg1VfRlAc5omnjx1QI0fmie77q9f5hKgxk2gh17VjlzY4QU/5p37vIwkqIk+z3eIP+INULjfIJ/qO5Nwa3G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-02 at 19:57 -0800, H. Peter Anvin wrote:
> That hack dates back from before the signal frame extension. It is no
> longer necessary.

Unfortunately at least it seems libgcc unwinder does not handle the
signal frame extension properly.  The code reads:

  fde =3D _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (context) -=
 1,=20
                          &context->bases);
  if (fde =3D=3D NULL)
    {   =20
#ifdef MD_FALLBACK_FRAME_STATE_FOR
      /* Couldn't find frame unwind info for this function.  Try a
         target-specific fallback mechanism.  This will necessarily
         not provide a personality routine or LSDA.  */
      return MD_FALLBACK_FRAME_STATE_FOR (context, fs);=20
#else
      return _URC_END_OF_STACK;
#endif
    }   =20

  fs->pc =3D context->bases.func;

  cie =3D get_cie (fde);
  insn =3D extract_cie_info (cie, context, fs);=20

Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
... _Unwind_IsSignalFrame (context) actually extracts a flag in context
which will only be raised up by extract_cie_info.

Or am I missing something here?

--=20
Xi Ruoyao <xry111@xry111.site>

