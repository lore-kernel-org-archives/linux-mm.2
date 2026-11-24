Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D4D606CC3D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 09:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WjmfLr4t
Received: by kanga.kvack.org (Postfix)
	id F1F546B0661; Tue, 24 Nov 2026 04:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFED6B0663; Tue, 24 Nov 2026 04:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5776B0664; Tue, 24 Nov 2026 04:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA6956B0661
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:49:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42AB71A0A92
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:49:28 +0000 (UTC)
X-FDA: 85469540016.21.21DFEA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9EB5B120006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:49:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WjmfLr4t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795513766;
	b=EzUQfcyH6pqm8wg3mGvyo4fzMiYev1jNXw+3eMxwSKTio7p3SidHhFOwoXYXTpQJRGzK/i
	C+yFc0/B+Gkt6/Jgo/OcXOtyTK16PmQXg7itXrIcsLu7qDKQYJSPxRLy8W3bRIL6rBwAE9
	6lHlrnb5sEbYr7wWCbxCVxu/OdBg4UY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795513766;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxDJEG4ECCixBI+jObWBIWZPiO5kbGYkrtOcQ6MxwLI=;
	b=G+Sk7aNSc8NMa3lChzEwR8ooy5vnD7eO+tNVjGCSnwJpQAPdVAFJksGWdfpzqSBfU3vzSs
	KWea/8K1J8qjPcN9ZJbz9C3Rh/x5+cneYzd3lddajuTFq+9059SZGwljYDVcwPF5Nkjr82
	k9fWPGom72nWx9H7DesrX1s2qFeImJY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WjmfLr4t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D690D42DE7;
	Tue, 24 Nov 2026 09:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366391F0157F;
	Tue, 24 Nov 2026 09:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795513765;
	bh=gxDJEG4ECCixBI+jObWBIWZPiO5kbGYkrtOcQ6MxwLI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WjmfLr4tnmrKSf0NqOeWbj+53Bvnv/aL+2cFDYxM4CZIYPcO5dhScA1yJgTasE+As
	 ukLcFid27f++zEm28fU+dum5jpdyhnMNfTanDA7FzGC2yZm3EDJzsVSgyGVjo6jVHi
	 uSUKdTzCWcq6rFkdYN2ZISkvDsO5H0SVcreJPr2c8vhrNUXHxMMdzcLoBnRisQBZwD
	 01tlaW7U/tzqYP9SGAu/yxmMOhdDgktvgVTuYEIkmipJyBYNWk6HKi3p+FK5Iz9ffw
	 VOwPZVy5/slRDMTPx0nch+Tp27YnrLQ4x+q7BN9ss8JDeyUEPwRvUHVnTwvKcVXXUk
	 ccTokDzHnVu8A==
Message-ID: <sashiko-outbox-230870@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/15] asm-generic: add an in-kernel auxvec.h header
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhvbWFzIFdlacOfc2NodWg=?= <thomas.weissschuh@linutronix.de>, "Kees
 Cook" <kees@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261123-at-vector-size-arch-v3-3-d342dae9e843@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
 <20261123-at-vector-size-arch-v3-3-d342dae9e843@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 09:49:24 +0000
X-Rspamd-Queue-Id: 9EB5B120006
X-Stat-Signature: sr8ji9qz4uasb5rq4p8mo31iydik9yf5
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795513766-4372
X-HE-Meta: U2FsdGVkX183cY2OsH4vV3V5MLyXgBlCrTIMz4MH06OqFer+f4HckGnL1cMuWxnt+XfN0QxodA5pIlB2GPTaEl19E9Xr1rNrSdU5B7RbVDEUTGk99VKu6GRMSO7u/t4JobRIrqQx+IrWehhSBJ8JtodVd1N93ysI1i+jN52i3BwpPtJRC4tag9n3V40xgR/RH4LmELb+1Im7jxDR8e810/GrxWwC0T2PJDjsS9lCIhsjvY8LPrELWVVCyLtud4WSO6AIlnCDJGnXr9jKMpf3nDNrgn0npFVCMNz1GpSAfqqs2r4PkJOU+w9enY+t0LmZuKeHyg34oHC0m+t8AILc/13uxUC/+LcNqYOX6K9Ny0Oz2ydTxSOjlvv8WdSt0jdKdOA6XfkGK/biIRrpH4d1pbmbxXNNsj0LOJPVhydYsbhupSH8BD5Xo84moRXScc/SP/D4uKAlrNMQ8dKqyuR7EOhUw7ovbOVED4YJcYCG77ZowsmuKcUzxQnWPuxanSewPg5jrjaAKkKt5vtD0WOfs2uiAs/d/2jmcrH0gr9+45CE5Yhk/drc9qRJ0g1EmaLHQlGYFFmB9l71ktYHX9B3hiSb834B1qxO6oTmL9n8Dp1RIBGOTtgl/X8zBUT11alv7ZR3MK+CwD42gQO6l86pH7TsFZvbFPiYCONQs2sCmqB64t/PxL/70XYi3I4lekX2KiuIeIFqzfVqOsr+pxRXVRjzrG6lOf/TVifD04+Fg6FchCpdIN5dyZN2xVh2HxyvxDH7LRaCamgxc2yeZwU6y+SDRcz2znrePzrLnOSyQqS/6hNlasf1jiCtVojqEWGPMMpWOrlk/lYYgXrINKyI9fKiu0i/NNFYqYeFwUTobr0+1eM+MwXPpXakH9W+Oigh5v/Hsm+DOmj16N7abW552kn7Y09Jz3wQB1UMZM3S9NGWdevSl7j5dsKvBUW9AgO1AQO0bKYyw8ptUtWE7Vg
 qz+ZK+iB
 dFFGy3o2Fc9IJd29JlmW+Ml34Y8rvt27VPdiWCN5XiuW0dRCYSdYKXfqPJvr1muAHXl6IQ2qQZr317yT1P0RX7NRWrvR+1xDZH7E3XYAxxjuYgb/Dc/oiDEcY2/RopEmVxmuTQbIJPfjDvTgoHT51uBNMOQKn3SwtWXfpTUsrjMYCHtl9gX8Vn/I12l9R/IijBxHjB5+OpqxdFOdBecEp7DGJubMXTu1p04TgAFUslik7bvEH5oHIazgH7qWO6yS5Ms/brJ7wbePDcytcKrZr1NOCs1n8OXO2lllbdQfy59u67CS9ZgQU+Du3n+IblRR0O2mZycUHEJO83L0/s+GgNAeU8WeRHZ+gS3QJ/26ZdUBc7ZklE/YgwH03xmMHOlLktNOq0jLoNjfzsYgV7DQugnoeZ7RK365S+FCDJhSCsGjR6iXqCi4vIzYL6/8t26mreJpsTaP+V/OTM+a49SwKVBHDu2zhlpEgrhU3Sssc1lWo8Oj5sNySOUR3nmd2RGz53YkVFNtzbjplKPOWxINDQfWxZl8VfMFb+g3f6CNsI5TOdltQn3hKjYEoFjxvttKai6H5U5iQVnDA2O7v/PeK7EObwPKuPk8RosD5EbErH4SwHmyLDucIYpnoMPhuiYrNmw61rA+cWtYo5iUtxdXASDs7Bn8YpN2wAyVzcvShygflc4Z325JSX/poHNInfeqD0gOiDEFwoi7pae1wbgACyGf73xwWxH7D/3XdbGmAJ362oDuBX/lI9NA/ylVQP73s24u+9ICzLPVgTqANqGvbY0gay0EtbPDNM4AJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] asm-generic: auxvec.h unconditionally redefines
  AT_VECTOR_SIZE_ARCH to 0
--

commit 0c922d7a496b0d1a5af6ec9787042de6d54ad285
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

asm-generic: add an in-kernel auxvec.h header

This commit adds an asm-generic/auxvec.h fallback header as mandatory-y
and includes uapi/asm/auxvec.h and asm/auxvec.h from linux/auxvec.h.

> diff --git a/include/asm-generic/auxvec.h b/include/asm-generic/auxvec.h
> new file mode 100644
> index 0000000000000..b5f73f35e21ce
> --- /dev/null
> +++ b/include/asm-generic/auxvec.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_GENERIC_AUXVEC_H__
> +#define __ASM_GENERIC_AUXVEC_H__
> +
> +#define AT_VECTOR_SIZE_ARCH 0
> +
> +#endif /* __ASM_GENERIC_AUXVEC_H__ */
> diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
> index 4b364e639f080..de1c33c4a2560 100644
> --- a/include/linux/auxvec.h
> +++ b/include/linux/auxvec.h
> @@ -2,7 +2,9 @@
>  #ifndef _LINUX_AUXVEC_H
>  #define _LINUX_AUXVEC_H
> =20
> +#include <uapi/asm/auxvec.h>
>  #include <uapi/linux/auxvec.h>
> +#include <asm/auxvec.h>
> =20
>  #define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table=
 */
>    /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTE=
LF} */

[Severity: High]
Does defining AT_VECTOR_SIZE_ARCH unconditionally in asm-generic/auxvec.h
redefine and clobber AT_VECTOR_SIZE_ARCH on architectures that still
define it in uapi/asm/auxvec.h?

For any architecture that does not yet provide its own asm/auxvec.h
(such as x86, arm64, riscv, powerpc, s390, mips, loongarch, sparc, sh,
and alpha at this point in the series), mandatory-y generates an
asm/auxvec.h wrapper around asm-generic/auxvec.h.  When linux/auxvec.h
includes uapi/asm/auxvec.h followed by asm/auxvec.h, AT_VECTOR_SIZE_ARCH
is redefined to 0, breaking the build under CONFIG_WERROR=3Dy and shrinking
AT_VECTOR_SIZE and mm->saved_auxv[] when built with CONFIG_WERROR=3Dn
(which causes create_elf_tables() to write past the end of
mm->saved_auxv).

Later patches in the series migrate those architectures out of
uapi/asm/auxvec.h one by one, leaving intermediate commits broken for
bisection.  Since linux/auxvec.h already provides an #ifndef
AT_VECTOR_SIZE_ARCH fallback to 0, could asm-generic/auxvec.h omit the
AT_VECTOR_SIZE_ARCH definition or guard it with #ifndef
AT_VECTOR_SIZE_ARCH?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-at-vector-=
size-arch-v3-0-d342dae9e843@linutronix.de?part=3D3

