Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E6F606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=TsFM2UqX;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=xAU2/Slp
Received: by kanga.kvack.org (Postfix)
	id 808586B0705; Tue, 24 Nov 2026 09:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9ED6B0707; Tue, 24 Nov 2026 09:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFA86B0708; Tue, 24 Nov 2026 09:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 370B46B0705
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:03:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F39F1C46EB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:03:15 +0000 (UTC)
X-FDA: 85470179550.12.837A442
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD4701C0002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:03:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TsFM2UqX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="xAU2/Slp";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf21.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528994;
	b=DTFyb84BBUHBpSGvwvLp2DX3gwd5I2J69vVvp7SYoS7QtA1gkfrilpDCNtFl4OPc5cGITr
	UeNH0i1BfWECYlvAcN08zZikumtCyNIxeG2khaELnEqkCZg4QLauNlcocZ/NOwxGrHuFb2
	RbNvlo7lLK0esN55zf9YGP/ugteX9QQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVwSuPPW9LnMTHGbyC/LWwKgzpeuxTVxDYf7431PF50=;
	b=Vky6DU01Wsaa0oWBFmy1+u5SvFzjX1N9GTe0514Z1kmmDzuV/tNy0MaCRSz9d7ElgmLwXT
	NS0sju6Uqjl3kc9k0LBbXPbKMdUNGHsjXH7R4iSbali83yEkSfU4o2v4p1uPFzxAE7aOG9
	HCz/LO/xMPxPwUWfZWqagvYJWO/am3w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TsFM2UqX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="xAU2/Slp";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf21.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
Date: Tue, 24 Nov 2026 15:03:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795528991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JVwSuPPW9LnMTHGbyC/LWwKgzpeuxTVxDYf7431PF50=;
	b=TsFM2UqXj5b+V3/3KG4PfYS0lJNbWBi4ZtJFudmyjLsy5pNIYarTh0tMz5+qpiSEDIi1xS
	HyrxXGzCQXJampyFbYOhVPHNR0EzLY86FTeFG6FZD0w4bIGAwEvr4CnvR2tBqmvfdP0Jqj
	ABrv9AM+Zl1RRFdb2qAqPrxpTtptABWGfulBb7/sSoDC3yo156pcTW9t6JksZHLYhIImiO
	FE7G5/5+goHgIN5sgm+L5r/zBFNwItCrE75jN4VU2ZTDRzJkY4OIKz1kICZEQgNgvFoNQg
	lCD+QeV82ITKpmTIMtDIReW4yGPGAIAylgjo7X3eIFqpkmxR300nw4Cyd2ZCcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795528991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JVwSuPPW9LnMTHGbyC/LWwKgzpeuxTVxDYf7431PF50=;
	b=xAU2/SlpVCQkMOYGKKQKfVe4HuUQTiCOuOagdD2hmbXtwhmh0KbeBZnsCI/iY1oyjBa7XN
	Is50/oIaDKTJS6Aw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: sashiko-reviews@lists.linux.dev, Kees Cook <kees@kernel.org>, 
	linux-mm@kvack.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v3 03/15] asm-generic: add an in-kernel auxvec.h header
Message-ID: <20261124145907-12f830e3-70ab-4e58-a330-2fa974be1a25@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
 <20261123-at-vector-size-arch-v3-3-d342dae9e843@linutronix.de>
 <sashiko-outbox-230870@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-230870@kernel.org>
X-Rspamd-Queue-Id: DD4701C0002
X-Stat-Signature: gkuwccpixn5hbuewc6eyxmxbxm7bcuts
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795528993-587036
X-HE-Meta: U2FsdGVkX1/Wvbpa1xARwC/Z13ZGMzIP4FKF2Q7cD0ceNUiUUyeMMda9zgXaUDKiudjeHFnbJ82gBFi6nfHM0QQLVm2853cru/Q6Gr6hGUP9JO1D0JpYdNlbIzHkmvZa74upaKONjbeAYINXUj1DhrEI99CxYoXeKBsT74XJpJ4AdHk6oe22/tXvgBSt28y2e1XiKGkumeWYlIj5wVuYJM2GL2poySD89VBuQ5ZhcpP1O99j9Nxpcq+RkbM0bguZIXm0ynhNnoR9JHrNC+Ie1qr9k0StK1c/Na4AEhHw7i08XrL4jrXZIhORRsKRfYd7nBTOAfXIChMXbL8iDnXvVn7NoilguyflMV0QSTK2Ry8qmsb38fU6CwogqVexp3rmiYQ8x+jEicJmIStwda9VsDvq2+64hy6tt8NYvuPRdbn9tDapHdRLFtWK8dh4K5zhcLt1Tnk1K4sS3Lpqr1Do+vvaNAYYMDMmfY+hju7MzdCVf7LY/mJq153SSo427yofSP1FxC03EwAh2JGsjdqUvBOceBNfwckciBbmuZgf+SZ/aOxPSnFRdW8S9Ge9Eul1+dUQv05xBs+3IX05OcUHhLaust4P0fILGzwHs3UXdL3NKn0GZXVfz0J0MBqxk/Y2E4HA+30MuLjgCxwW+EzJEOpOeemhMfPkgX2v6Y+T1dL5vHEupjIv7lYN5eSmZLx7h8EtRK0+v9nwDGvrchvk3C06/5LokhFb68FrcExh0TK2B0Sp+RHwNkTwjTl5l7PobCSCSV1ec/MzHetoIXQ88xBSyofIXeoIA+TmnYwvxUS0Az9Og5PI2+z8mn3OG7YaBkx5n9AONOI3P3Qc7cnVmMx3ldCtU5Q7vNVX1Lqy4c8tfJ3Qh91Y4pN+wS5IQfQ3jDwVSq1YZosHiMhFVyxrmQBVdZ0+itVtkAiZxMqT8bDxhHNsZjUpMkxj5Lq8ael2NzHryNL4hwAk3xCWNNd
 W8VU4drP
 1K3qdGvBEmat5upyG1QKc1x13TwsInoRQyVegTfXosVnEjWJOlZuwMnIcrlP6Oft1CvlzrcWO87rLnyu2ZbUccLBoan0yC7Sk3pKVf6gE7zgPAUhVSLUGQXwPCTgW/dbUOCXQ6sitgD9VItX9qf2KtZvGgrlYl6Tk/IT/bkXTOOMesJule3sWCgDZCvPgcyp9eoNmCpxJXt22sbe0lF6DXcQ7sKPhWezarwicZVmfs52XPZzFRXwLyu9sX/6y0q+h4uArA/wAvoMIhn71Lnz3AA6lISZSVymbaRtFFX4gnij00XXJztMGIJTyzvSh7gk9EMvmNpyxSn//C6iP/z41/LrEAXIGIaGmJb+m2FMCBYHexK5/jQPr4wiIejRk/ShmCnpTPpvlC4I2Ieo996XmM7vPpFkp6GeJujXr9+26Oo41gD2PC2XK0KdQeZA+NQQAbu7bkJxK0fAWqtDfyuf/lO/zVQKCFZCeh57Wgrb6HEcZ0Sh+tJLykW2z4T9Cq4jeA81xJ56GogNvGhQH3quV3zesxLgMNG6VhSUlaMbIkaXEboYYEwhr/ycMxzQ+8ITnTMWHevtoL8zzwG7mno63Dvd5PQ85Viv8neRKWzQNbVmk5rIk4HrlqjqDVm8QtTkkG15hFBs4tsZ7VGwOhENfPZ8zUblCNHAN95r4pwwbSZpMkrgNcvSn21SUoqHrL8+SxlA5XSxyONiVAqJYaR7usUI5SG+3w0x+wGotsA5iYyYUikQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:49:24AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] asm-generic: auxvec.h unconditionally redefines
>   AT_VECTOR_SIZE_ARCH to 0

This is indeed an issue. Not sure, how I missed this, especially as I thought
to have sent this through 0day.

@Arnd: Could you drop the patches?

I'll prepare a fixed version, probably for the next cycle.


Thomas

> --
> 
> commit 0c922d7a496b0d1a5af6ec9787042de6d54ad285
> Author: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> 
> asm-generic: add an in-kernel auxvec.h header
> 
> This commit adds an asm-generic/auxvec.h fallback header as mandatory-y
> and includes uapi/asm/auxvec.h and asm/auxvec.h from linux/auxvec.h.
> 
> > diff --git a/include/asm-generic/auxvec.h b/include/asm-generic/auxvec.h
> > new file mode 100644
> > index 0000000000000..b5f73f35e21ce
> > --- /dev/null
> > +++ b/include/asm-generic/auxvec.h
> > @@ -0,0 +1,7 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __ASM_GENERIC_AUXVEC_H__
> > +#define __ASM_GENERIC_AUXVEC_H__
> > +
> > +#define AT_VECTOR_SIZE_ARCH 0
> > +
> > +#endif /* __ASM_GENERIC_AUXVEC_H__ */
> > diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
> > index 4b364e639f080..de1c33c4a2560 100644
> > --- a/include/linux/auxvec.h
> > +++ b/include/linux/auxvec.h
> > @@ -2,7 +2,9 @@
> >  #ifndef _LINUX_AUXVEC_H
> >  #define _LINUX_AUXVEC_H
> >  
> > +#include <uapi/asm/auxvec.h>
> >  #include <uapi/linux/auxvec.h>
> > +#include <asm/auxvec.h>
> >  
> >  #define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table */
> >    /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
> 
> [Severity: High]
> Does defining AT_VECTOR_SIZE_ARCH unconditionally in asm-generic/auxvec.h
> redefine and clobber AT_VECTOR_SIZE_ARCH on architectures that still
> define it in uapi/asm/auxvec.h?
> 
> For any architecture that does not yet provide its own asm/auxvec.h
> (such as x86, arm64, riscv, powerpc, s390, mips, loongarch, sparc, sh,
> and alpha at this point in the series), mandatory-y generates an
> asm/auxvec.h wrapper around asm-generic/auxvec.h.  When linux/auxvec.h
> includes uapi/asm/auxvec.h followed by asm/auxvec.h, AT_VECTOR_SIZE_ARCH
> is redefined to 0, breaking the build under CONFIG_WERROR=y and shrinking
> AT_VECTOR_SIZE and mm->saved_auxv[] when built with CONFIG_WERROR=n
> (which causes create_elf_tables() to write past the end of
> mm->saved_auxv).
> 
> Later patches in the series migrate those architectures out of
> uapi/asm/auxvec.h one by one, leaving intermediate commits broken for
> bisection.  Since linux/auxvec.h already provides an #ifndef
> AT_VECTOR_SIZE_ARCH fallback to 0, could asm-generic/auxvec.h omit the
> AT_VECTOR_SIZE_ARCH definition or guard it with #ifndef
> AT_VECTOR_SIZE_ARCH?
> 
> -- 
> Sashiko AI review ∑ https://sashiko.dev/#/patchset/20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de?part=3

