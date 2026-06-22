Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F04BCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 17:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0806B008C; Mon, 22 Jun 2026 13:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9711E6B0092; Mon, 22 Jun 2026 13:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85FC66B0093; Mon, 22 Jun 2026 13:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1416B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:15:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 504DF8CA66
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:15:31 +0000 (UTC)
X-FDA: 84908200062.17.C9F0A23
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 56983120012
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:15:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J0Ix1Yp7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782148529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5y3USGnElGMdKgxAn2V/X+lCqw7tv4tGIpnPXtqDPM=;
	b=W9tAeY4qHbRZ5wG0J+7NdTb3+jYq/Rz3pV5pB/Xnow3JlgX6Aoehpa18vr77wkxe44NRlw
	PMvOUuyM11Rizk9guW7Y8Sou+64nWe4VqIhVyZRYTuumk41xWOHff3VUUC3g+4j/UrbEea
	g83AYB/5PlN44gY+56ESyTGmxt9Zee8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J0Ix1Yp7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782148529;
	b=ccyKry3d33Wm1Mq63J2CpYPSDp+jcterJZRUTnCiLq+2V3PbzjDF624UaYY232eDHZ5liD
	Znw52Y8H/kBtj4HDo2CVWpIYTr3YfweYlGhuyBQKiHWil9ICwmfKym7cLsMLP2XTWwE91H
	iRekA4fm3K73spprW7ZpBb85FDbumII=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-43f5927e70aso1653929fac.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:15:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782148528; cv=none;
        d=google.com; s=arc-20240605;
        b=T5fE+jkM1/VCkMIwSP/AOWzZlQp4Xxf+7UKbcz/N8X+ofFEXcAj9+SOl1jLPq+mP0w
         mpFbEIpU1LT2PNKLvv8zP2ERIBJ4wMfWmbJHfrYfnmJ+fGr84Vo2Kxjvzi2wLeIKHyaE
         vUJXLuCMZcUixKJy62whO5hBf2epR0pIJSfXz1cndqgRNXGOVjiOdz8aO66AMzQ9Zbwm
         yQJtgDzPc90+lUpCAGrf294J7xHPIz//H8xv09fT7oIlsQwBbRqmW9iHbC6lqVt1Yfui
         5ROlgnVH9tZjjIXQ1QXRYuD3v/jDnSrb4/P1PIctG2PHCddAXh0Y+ZN1X9xhKh2JJVgI
         GdJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t5y3USGnElGMdKgxAn2V/X+lCqw7tv4tGIpnPXtqDPM=;
        fh=8YZRDc8B3F+QQN8btNciucZ6SDWecYmuATencDAkQqU=;
        b=SPR7mu5UKGFy7NqW6IJrjjhwkcNY1UrdYlbzIySRtoo2QpXbbkqjE5fBBf/itFnCjp
         AT9Ac8OpkB5OjunFqTvE84t52epWuktUK+VWStFfwu2im/SFidy0r6ZhMe0FBigRAdi8
         ZUqE3UaHAiUZbgj8WnUm9/yzc1+b+7/uZF8yCXe+WpSqREHpySh5XNUV2C+e9gZX2Z+t
         gaU0AACLaeregZL6jA1AyLyysJk3cUB1p5Sc1noJM/MHfaiIrrC2L/5yEgwxW8+i1wT0
         KbVq9xFJpCv7gh44lSkJA7Y2tc+pbBmBhcRLVf4FzZCP/Tn8An3twTsIO3GAvZ0gJ1dF
         Z82w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782148528; x=1782753328; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5y3USGnElGMdKgxAn2V/X+lCqw7tv4tGIpnPXtqDPM=;
        b=J0Ix1Yp7YcDqZ0GS96HqllD965u+FUGXF/klQmfqBqEee/hYAYLrbTKLMIMdz6e55y
         y5qL4aFx+gvRvcXL7mJ0kbSAj3f+R3KDae0r7rCBC6mR3klOoDU7MU36WvNknTH3/y+U
         i7HqQw+P0QqGIVMOnAEa7+RdBgqrchX6XY7oMXJdr31LmcWVeZOB31i2+Z/1SkeBt+ye
         +OC5hEwfAVVjIoq/oucwJvq64tt8+obZfQEClY+gNtS0iqiNyxTGZwGf4dbgWqNFEb7D
         utRIHcOX1XYhIJ7P1hFarGAotV3dIvX/Qt8dPiEaEPlZKtfEb+eIBGYWGHulGX9DVM15
         KXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782148528; x=1782753328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t5y3USGnElGMdKgxAn2V/X+lCqw7tv4tGIpnPXtqDPM=;
        b=iHLmmFkLtysVxXTBRqBaQUep9ZyqCXASN3ILQaC3ZKlWLcpnGGsSEZoAdUZ5j6J04r
         MyAl4C3oqUfczjuM8xspoHIneB7vwz1Uy1BvUqpNfIaqfpi3+2WpYPzj1IAfHjAnfO9y
         Q0foZL+tfD/fVMjM9XV/P7TKd5bG3Wc6XOxqBbTm/i0ClfACcnZI2Ajsz/EgYrCyrF6U
         OHxc/Km4Knif9n93+Jd7m1trN19OgcKPsQB104etvArXG1aQHWJymV/LA6zm40EIoKsY
         PklidfbmaqaASeEwyF7F86s8MxoHOrMWsftcSeB2m/h2TOIAUCMibJYAa7ENCiUiLf42
         WPzw==
X-Forwarded-Encrypted: i=1; AFNElJ9NLF1vpoHC/YqAAeG3Hvxk6iyRVMLbSulKzzisji5/VrIWRMdW8alzQ5jXM1gioUe7Tuf7g2HP7w==@kvack.org
X-Gm-Message-State: AOJu0Yx9lcRbgEZuwQlWeP3jVCx4CWvRnx+vmNriNvlW4ZMyhIM/5v+R
	VEenT99ruT7UXR8beHYG1CVTeeJSmBKEhPTxSGdc1KSnb2f+0MiUNCpW2xiqukFoXyzVlHDH1sA
	MplG90GEUHkcP0gWOmp7udNEQZOtAUaKw6FWy04H8rg==
X-Gm-Gg: AfdE7cngVNPaPFPnYx4ODHpWnXuoA/pY70Wa/sRVYof51cNho3RDHmZPeuY891aEaI8
	STJVlK3PPHKdKf8UrEzKsHyzsx3Cza2p3dHZMqHthO/ZkpdSUGcOjNmO8Ig6Z6GHXhqwH/lTxWf
	IATFH+DgXn1aJwBDuu8SHXEjvuFviLfqiuLohSnpWBTs/HXR9DucmzDIkaV3jI26PT4jiDL1QLF
	koeDDf08kjGFNHqOaiKGNTiDC+V1HGgJiI+B2rNFp2Z7+b42jUul3kxXEyfOctKeULVHVbaXBJj
	CzTSWpIzCwHrtvn8KFcV6ZMiqGsN
X-Received: by 2002:a05:6808:3442:b0:48a:c065:6fc9 with SMTP id
 5614622812f47-48ac06594fbmr9330170b6e.40.1782148528126; Mon, 22 Jun 2026
 10:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com> <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
In-Reply-To: <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Mon, 22 Jun 2026 10:15:16 -0700
X-Gm-Features: AVVi8Cc5PMYcnmdUaPpm4OauvSyD0_Ly6wyUiTL5YPonWZg26gteXmXywIU7NwI
Message-ID: <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
To: Jan Kara <jack@suse.cz>
Cc: kees@kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	shuah@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: tdif9gpse4et49htthu5jq3w5d8n48md
X-Rspamd-Queue-Id: 56983120012
X-Rspamd-Server: rspam11
X-HE-Tag: 1782148529-259516
X-HE-Meta: U2FsdGVkX1+C1egTGyXo1QHmz1lxkMlCIzhLXHHUgEowVLxUzWWenO+fJXdjl9VmuXTKdlcn/PYMUCA/znljmbIeAbd0MEuxuCaBeICXs7vcG8gdL3vzh3oiqx99qDIu3vUD+PYeizTsbpsn/g2FjMcgIP90Lxu2T3ru7wrcsPNTCnhwsr0KBmZstlaYLMMUZ3iyLOwgGZ38nxPDAC3YK6zwpnPiGPAs6dvcvi/uLYnfP1VbdLK+mboooiR4o4eO24w2SvPhc4uYNtgk+Ev9BW6A/aUNbHJEeDNwjCFG0MPAxagT5cOXc6bgsnHlogjQzbapkoZyLYGE6dFqlaqb7hhuvhUnO4FNsoOVLvdvxBkNbc5V1VFos5R32TftqF6kj9e/vwbUiB80CeBGx2q39mQiUB2iP2wAxZB5rfSU06K2nPAfnej/zpsQCf8ginRJpEZV0U1sVeGK7dxAfXzDbnb1tCBq3/v/xsbwU59S0xd+HwFeWwAskBJ9Kl5Kg1t27ZNqSvjISyUWkVX7SEGWdHPEkuj0681d9Au0jyCTfceNUNNaJGfOsatKas+zq5afSUENYN/wCH00OGNIslrupQU+9kB9h99nBjj3vaq0IInemwkryFCgVPM58HJ7mmwd9gj/by0ZCupxLA0UsOfigGN02i/Bu3rVEmOUudRnzVGBa4Kjp/rrcg3OX10htYXDlD+/0qPKhMuwUfy/vA/afaRjLJvrd3gJzL9NnanlL/AR0hWBSi51hJy9stQ8gTTXUV68cUrHpKWZuMBqwBz1Ug5drN4oYoZpi7jwRCojtiRRmNeCw8/yltRx2rzF4skQ1SV8Y2xtjZT7EnEbMAByk0OyWkn0JpX5sv2FieLM3ztGhu1/fZaQycPfhi65e8GEI46M1raY+sdzX4j4ZqwHbk/Pvsh/kYpNOel5sShhGBQdkHB4vHDR4Xz1Uj1JygznFt5zdThYvjm0GnjqrSu
 FyZOIAmj
 CqyOPPwdSFwu90kgi0PE3DjiF2jOtfk3MkNn2IoilEnuzyMvkccCs7iIjSJYLBUaJZAFW64jNU+kf3ODEbWAVvczCe6PQfOPMvzYVcG4b7S7abBQxIElZ9Z4KNtTEX9RLFnGQvn4Vve/PHogleQl3aUOGDmIPWdXlE+17nQRoxzeXvSTsP0XjvrTFlghwcu53L6DJsV4pUyc6nrEBlkg6JekkoapivqDhvCJCrgbHj5KvulImPgZtyWNFMh/OrBZdBe+kHquOvBl1tn3nSJtlRWKt/v6WfOmCn6HWMOjPXOat4q3aNhEtyDjoW0l8wRTipiJfrzwVIJdS3tV2b3rv+c03dgUite3hoXDcMm/tjhG61UOYB8w29H7EqdVH9gw2BxOfxeKK6FyGa0RoSZw1pWmF9WQlpAwbwEoAmoFy3h6cQWIy4FoNtleVesJMnOvY901DvAZgAb+2kjDnHuwWek4D7wCctAvTtTgz6QFvsVlDFQCaSjuq2aJ5hDDx3zmTjlLF/g0w7hLiu7pZ/2eb0xM3vgVMiDXco+GdrobkAesk1xfJNZosm1WAlnj80qFEylotS/GnFMQjZzN/ZuEzgKcGq6S4FpH0OrVBN4i5zRzcIsYTgDk1z+TmbtXZ7DxLf1kZTQIU1u7I/3TWs26+pC6m/ujzlb3RZfT1YyfW6KhegIKowa3K1Jl92DIlh6KaDB+h+nGLVFv+nKHcBK7KhEuSTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:40=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sun 21-06-26 21:39:32, Farid Zakaria wrote:
> > Currently, standard ELF and ELF FDPIC loaders require a fixed, absolute
> > path to the dynamic linker/interpreter (specified via PT_INTERP). This
> > creates significant inflexibility for relocatable dynamic interpreters,
> > where binaries are packaged independent of global system paths.
> >
> > The primary goal of this patch series is to support relocatable binarie=
s
> > in Nix, where packages are stored in a read-only store (typically /nix/=
store).
> > Allowing the ELF interpreter path to be resolved dynamically relative t=
o
> > the binary's location via $ORIGIN enables Nix packages to be relocated
> > without needing patchelf or wrapper scripts.
> >
> > For details on the design and motivation for this in Nix, see:
> > https://fzakaria.com/2026/06/21/nix-needs-relocatable-binaries
> >
> > This series introduces support for resolving the $ORIGIN placeholder in
> > the ELF interpreter path, bringing the kernel's binary loading behavior
> > in line with user-space dynamic linker origin resolution.
>
> Thanks for the patches! Before dwelving into implementation details we
> need to discuss whether something like this even belongs to the kernel.
> Frankly to me this looks rather arbitrary and tied to the particular way
> you've decided to setup your package management system. In particular the
> usual answer for situations like these is to use namespaces which you
> discount in your blog with: "If you are using tools like Bazel or Buck2
> they likely already employ their own sandboxing via namespacing for build=
s.
> Integrating Nix into these ecosystems becomes incredibly impractical
> because we run into nested user namespace and mount restrictions."
>
> I don't know enough details to really judge but it seems to me like you a=
re
> trying to workaround a mess in userspace with kernel changes.
>
> Anyway I'm pretty sure Christian will have more educated answer than me b=
ut
> I just wanted to express my skepticism about this approach and that perha=
ps
> you wait for feedback from him before spending more time on these patches=
.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

Thank you for taking the time to look at my patch.
I'm new to contributing to Linux mailing list so receiving feedback
and responses is welcoming :)

Having put forward the patch, I'm clearly biased toward thinking this
support should exist in the kernel.
If I had to think to strengthen my argument would be that the kernel
should not be imposing how the interpreter is found on userland.
Finding the interpreter relative to the binary would be useful for
package deployment scenarios similar to app-bundles beyond systems
like Nix -- which is the originating reason why $ORIGIN exists in the
dynamic linker.

To me, the gap is that prior to systems like Nix, the idea of wanting
your dynamic linker to be part of your app bundle was not necessary
but Nix models the dependency chain down to the loader. Such
functionality would be even more correct for these other bundled
solutions as well, making them portable across userspace glibc
versions for instance.

I see Jori Koolstra mentioned that Sashiko found feedback on the
implementation.
Is it worthwhile to amend the patch now or should I wait to hear back
on whether such a contribution would be accepted?

Jori:
I'm not 100% clear on your question but the LLM assisted with some
code generation and brainstorming.

