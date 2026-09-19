Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6FEFC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 17:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8DF6B0088; Sat, 19 Sep 2026 13:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7A146B008A; Sat, 19 Sep 2026 13:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68F76B008C; Sat, 19 Sep 2026 13:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 913E96B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:53:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C93C41402E2
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:53:48 +0000 (UTC)
X-FDA: 85231259736.28.75DE638
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8180840008
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:53:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=UWEyhuG8;
	spf=pass (imf17.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789840427;
	b=GSOSCgyJ1y6ijOIrLT1ZqiUmpfdpjdR2qhubtgozjOg8VXDyXv2gXAOZCeTCE9I95s22BJ
	EWDMrJc3fh+OJlHHA57ZVLJvSF5GC8mHsFYX2pTrVHg3KdLDaoZNm7jnCpsSXG3Muvso52
	Hm2p7KPhjjkWE9CRf+jDUzxMg/qHdcw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=UWEyhuG8;
	spf=pass (imf17.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789840427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxycNRe5Xp8R46Q2iiGa2i7TtEiTDcNhh16gfvNbu7U=;
	b=xWrQRrzgRcl96sblQrjCRKEQ7bNXtmKSc358Fk+kUn9SuIuArWPVlvPUi4esKmzRxqEUJV
	OnTvT366dZ4xJQ1n2GuRFCB8xWYjmcBziHBDp694gweVBmaCx1S7uabZ2VXQgugamzrsQt
	bOKsJ6SMHbJJcJtXKbDPAUgtUaIzwGM=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D6C4840E0173;
	Sat, 19 Sep 2026 17:53:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bBIJx-YJV69X; Sat, 19 Sep 2026 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789840413; bh=SXiqwKtdNNUw70nrLfz6bcKBIdshJmQNRlHzGsoGp7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UWEyhuG87+5c3DEkcI6k9kbCf7oqNuWc7NNVp+B0jdkCEFaq+bUs3xutwcASp62Dm
	 xBdQHX+gY060/K34myaFqGgQe+2f/z3C6mpkz6uOkpM01sUZzWw/aSPJsD8Z24qiLI
	 Z7vqWAQbgKb6wHT7E1CBmb4dnbAsxOY2OJ05fCl1kSnIqEcGHIpe6aaV3+jzi6lJhP
	 cbU8nC6dsoKI2Qyb2fvOVN+oU+2fKN38Alu/a4rPUApwm0ccFCz4IAWeO15OO1aOTE
	 UYVdJU357+iOqhipNfoJXMn+ETz0RFXxRlNDMIrGWhVRUzduCPwkeRBSyuGTSPMMxu
	 aOphzimH8sxfRQfHLI5C7d0/rJFlUDBpQW0gR3rqbUZ+nWFkcYaNksQVFRPXsdgNbJ
	 bKx1DXIoi3wmz5BqmhsveI6MCk1Qq6PZU9spJoDhgwKKEecM9ON5EVsxz1XxPcQowK
	 LyByULYfxFktJ100cN6FT/nzQSE5HxRuoF/iRJSgndbYT5FdTvPkvQ5vV+RXJXxq4b
	 SHlmUxnFz34Xj/7YurGtkbj8n8tIL7lvtnMSdOkFVIu6Gl70ewQ/HFNOYSjlaYWWIf
	 59OINNfItYdX/nmbWo4bsu07fF2iTiY7QrOF1wL4vdDyonaaah6s9CFyEBhbZD91UY
	 3MKqf3aAd5VBi4CrKQFnm7NM=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5DB9140E00B9;
	Sat, 19 Sep 2026 17:53:20 +0000 (UTC)
Date: Sat, 19 Sep 2026 10:53:16 -0700
From: Borislav Petkov <bp@alien8.de>
To: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>,
	Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD
 F15h
Message-ID: <20260919175316.GAaq7MDHnfhdJFPtsM@fat_crate.local>
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
 <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
 <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
 <0B48BE2C-2E72-4961-91D9-35E215F537A9@quelquesmots.fr>
 <20260829185120.GBapMqKFM35KtL0Mod@fat_crate.local>
 <78225f07785ed89e0c3e5def8a8bb1a48e444322.camel@quelquesmots.fr>
 <20260916200247.GFaqr15333nu5IAfjU@fat_crate.local>
 <45dc4a4f62e49107de788b4be9a4039e0d772fa1.camel@quelquesmots.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45dc4a4f62e49107de788b4be9a4039e0d772fa1.camel@quelquesmots.fr>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8180840008
X-Rspam-User: 
X-Stat-Signature: asfgmhojjzrkempn3xuhezkpd8awhmpq
X-HE-Tag: 1789840426-217519
X-HE-Meta: U2FsdGVkX1/n5mD2PHxLd+p7lghaxhoIaxVzbPARTyJCI7oiqYA8jYQZ1E9Gm8ghtSo5gUCcCQWD4vhQ5niwsf/a3zscs5tByRYhrW/UZUzrGnJ4mWEuXr46mY2K1tUeBo5D2PiwpVCl0s+FcnBlW1x3dSM1SrnKkLmjtzfYEJCyNMoW1PMmGDOpimJQVJ9VMFy+g/5Raoj689OkxnznHt4zFh7xDoZ9Nn0pwTJGLzQ3oM5LwHtLnDiH6kr1kPI+BFXiz7m6P0cuP2O1dkYPBbtBTsj6nwdAd5AJlIn3eKKbXZq5uYvFyym20SlA8x1u8+IhsmSFmW2pgN3a6K0V8XdwG9h7r3F0xQgnZ2UV0qrzsqJNejfZho0U/f8oehf8ofYsXxa6VZixAkWyAPy2rJi7v6Brnh/z0lMJwTDElUz9HQ+4SJrVpGk0Kr/YXyqINMrVt9gJIiwKZIVeH8sefLNsC4xjeEaUVL6MErWY4UOtnLzLWX6R6xezbH6zDGlUwJ5apOYrEdhw6rxNTN9rh8vupvvlss1JDmTRmx0R3L6UW4kVQuDJkPpw0AUdF6HciKgucjxAr/K+q88iOsFpUw0CU3y68ntCBdPNn5qSL0UNy6BI1yBaAqXEwlpUCQABQgkr8ynkp+zSb/jYDSgwAtgbWvUJbs04/WoyXsOtJxmPHcsAMxX3RotAqqnDLeowtXdV2lM9ph443vLSrr1mWMNj/ZM2Jyy4Jm4xMG7fiQFVRR8qeuNBIt//Kw0wKE/R0WdpMuNK2QhiHIcEs+ez0xVFRodDO181l+SXuPtawD3ifKY1tn6GzoF9+dcLH+uPSpVu35OvTXRB4wa/btyLa2silznkJKMk3EZf9hWksySgGl9EixqHogynXPY1Q1Zt6jcIcdhOpOQrUNZT1YRzAmLWCdEM5W5l8fBgpPfF4dq+Rr9q+Th4CGT0oMecM9or6+Q3SmFv9ushniUjPxu
 aFLMdNqN
 bOMvC4Y7EeyZmoLoxMaLNs3M/+c+aYhkjCY7EoV7Po0O7M89KrBKtS1uaWD4nfuiLOzx2OErZQ51kD2p3JbLyhoAr9MkqYs1AdXAshy73y9CGxe+XCBL8yiIrloGAHG6uT7wgpaLsmv0Kw9m8ewgXjwVGyHWz6budhw1gB0h/y0cKYzLxCJz4PwWwVLTBWJJxi8d1BxF9BXE3ZKnyboZyIgyOnHxAjJVytvgENY05oJe6qjwJQbnWYEHPGsqeNAebYhMp4TgdyzjZNX9CG889/Ymyd+9G7hB5xXf+fh/H+SUfepI2j/8r1r72OQtRvpbJWr3jgA/EOogC/OgT1CTxutz/ariGNjk86zIfqjiayzSnpoHw/+s4R/t1hcYHDe9HaXQYM0m59F0Iuf/VriAGxZAUaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 10:47:46AM +0200, Laurent Wandrebeck wrote:
> Here=E2=80=99s the =C2=AB v2 =C2=BB patch I used instead, on top of 7.3=
-rc3.
> Works without problem (several hours uptime).
> If this looks ok to you,

I can't complain about that too much, but let's see what Dave thinks.

Dave?
=20
> diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.=
c
> index 776ae6fa7f2d..a54f930e2c9a 100644
> --- a/arch/x86/kernel/sys_x86_64.c
> +++ b/arch/x86/kernel/sys_x86_64.c
> @@ -28,7 +28,7 @@
>   */
>  static unsigned long get_align_mask(struct file *filp)
>  {
> -       if (filp && is_file_hugepages(filp))
> +       if (is_file_hugepages(filp))
>                 return huge_page_mask_align(filp);
>         /* handle 32- and 64-bit case with a single conditional */
>         if (va_align.flags < 0 || !(va_align.flags & (2 - mmap_is_ia32(=
))))
> @@ -50,9 +50,13 @@ static unsigned long get_align_mask(struct file *fil=
p)
>   * value before calling vm_unmapped_area() or ORed directly to the
>   * address.
>   */
> -static unsigned long get_align_bits(void)
> +static unsigned long get_align_bits(struct file *filp)
>  {
> -       return va_align.bits & get_align_mask(NULL);
> +       /* hugetlb mappings must stay on the huge page boundary. */
> +       if (is_file_hugepages(filp))
> +               return 0;
> +
> +       return va_align.bits & get_align_mask(filp);
>  }
> =20
>  static int __init control_va_addr_alignment(char *str)
> @@ -157,7 +161,7 @@ arch_get_unmapped_area(struct file *filp, unsigned =
long addr, unsigned long len,
>         }
>         if (filp) {
>                 info.align_mask =3D get_align_mask(filp);
> -               info.align_offset +=3D get_align_bits();
> +               info.align_offset +=3D get_align_bits(filp);
>         }
> =20
>         return vm_unmapped_area(&info);
> @@ -222,7 +226,7 @@ arch_get_unmapped_area_topdown(struct file *filp, u=
nsigned long addr0,
> =20
>         if (filp) {
>                 info.align_mask =3D get_align_mask(filp);
> -               info.align_offset +=3D get_align_bits();
> +               info.align_offset +=3D get_align_bits(filp);
>         }
>         addr =3D vm_unmapped_area(&info);
>         if (!(addr & ~PAGE_MASK))
>=20
> --=20
> Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

