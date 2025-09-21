Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB50CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 18:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72478E0006; Sun, 21 Sep 2025 14:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC358E0001; Sun, 21 Sep 2025 14:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C37D8E0006; Sun, 21 Sep 2025 14:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 808A88E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 14:26:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6AFE13AD2B
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 18:26:19 +0000 (UTC)
X-FDA: 83914087278.19.3D8C892
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id ECFA14000A
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 18:26:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S1k924zH;
	spf=pass (imf04.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758479178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4zmkAHPjhKHpB7D8+DDrYGAR3U5WXK9thJ0sK89yEc=;
	b=V3B3OlDjqjQsnyoyZPk+HE44+DZWAs3t9ehx7qOotbjNmoE8c+Z0kKm9DTdrwL/11YYUkw
	lVS8s/6XCLF5tem8Cah0JWdf0EjHv5skLmh+bgMzQzqvjdAfTazYU78D4qWhrAVd/nmRkU
	m79V94LUjpT0AnPBjjUjdmZSH8KGQYw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758479178; a=rsa-sha256;
	cv=none;
	b=SrrRlqlCC1RBmwLJCeb+EpHlU3t0Fzc8J4V17vYPcudKDPHs+vHJ02EwKndpw6krSw3n+j
	CpoFsx9STkXL6MDfA+WyqEf4dnCGav5J2ZzwM88rRjW+STmnxUhN7kfMEbPkoPvJsw0EVt
	Mhy6q+OTrcUJpyNGb68Ng9zmDRdNeW8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S1k924zH;
	spf=pass (imf04.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b0787fdb137so553039766b.0
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758479176; x=1759083976; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4zmkAHPjhKHpB7D8+DDrYGAR3U5WXK9thJ0sK89yEc=;
        b=S1k924zHkExAjgb6qbQ6TOmpyk8LvzTwJAjWZ+9c76a/LR3vsITXyacSHqKlaUJc63
         3fy2mCoOKfadaWERS5Gjn1f28WItkEE/4jW42A/3WQ2u6GShj5SXEcJwh14ugWgTw+Fk
         HSnVNqc5aaivrfGROh05j4QDDmiQ5yvyoE9GAx8yuS7NWerNlXpdUcz35xlZd0uprmFg
         ZbKrlU7WRRUW9eFSo6pk4owxbuv1HJKrYXtBaDA/Z3Q12LrOABH+dRAXalgP5Xuuh32k
         VSlIHs/VV9Pp4MJCQ4YYHgx7A7QGeJJIsiXA+r4I9e34pfwXl+bbdFx931izscZPYdmG
         ycQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758479176; x=1759083976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F4zmkAHPjhKHpB7D8+DDrYGAR3U5WXK9thJ0sK89yEc=;
        b=vb6V15vgOIak4Y58mrlVKPIKaiuZNcu/v2zEg+AIKFa3kvlcFE98FM0OmY9QbKvGYH
         H8UtsyGWTYNNHxO+pcvyqDwHDX83zBi4KCO2nEznPLYu4OoJyAvufF2Y253shYLMcNqi
         2v9jQDyf1YPPT5crj516F3Q+Md4s26UXhEQ0bTb5IQMOzpmZAZWIuQsKeOlONgZ+cfE7
         xtZB7i45Sv3KtgpUMd9TpywFqFdwdstR9TK5NgLiaBwPf4BBB6TMASpFQdKBhWjoyhfS
         N55ezLxwznIg/w0Svs8qiAkR6wiZ/rAIXxYjh0jhYZlKfUZviEs/SDUcPCQDRJYYm/3W
         9OLw==
X-Forwarded-Encrypted: i=1; AJvYcCXMO9ksatoNvscJPEXeAwphbq/M0Lp4+uYqQVLnMgQxiiHxi9GW8t8ni/41qYvx+kS6ojW8MgoYPA==@kvack.org
X-Gm-Message-State: AOJu0YzG3AzGqAVrdgYctEDDTb4aSkQtiqq92CYag7fMbwGJGXZoB8yi
	Fzvf1h6juM2KJhEOx3mu08qBHxIbpl3Gb/3ThUGEcihFT3bT9gGvZEc9vLyasjyALhF+z94ufZ2
	ik2X26BuwdS3IE5GYILj9sGSFemSUGnU=
X-Gm-Gg: ASbGncsW6LDyrJQogwxL+qZWgBsGL+AXarVgFwPMUY+MVUekZjtGSQoKNMsNXBP5Vme
	GH4mASMbLU7VBgmnJZiY+grsyw1WTQLTsoCNdu3j3bovS5ULV+gsCZhBfN1qSSM0IsffvA2olwI
	nPF+aL6hT46q1bQFLiNNpUcds3S7yWRelLV5XG6sgu1TsDbCDmiUwmJRqdL5r70oEAUm/1eIjVG
	C0nYRM=
X-Google-Smtp-Source: AGHT+IHh9e7xoMHQuFzPAPTA2CQWR9c/d79fb3/OPULapQmLwjGLq95LNatOsDtZ/08h/6VJ4lMyXWHqYMA+9gMoEKQ=
X-Received: by 2002:a17:906:c155:b0:b04:6fc2:ebb9 with SMTP id
 a640c23a62f3a-b24f442d968mr1064293266b.45.1758479176060; Sun, 21 Sep 2025
 11:26:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <20250919145750.3448393-9-ethan.w.s.graham@gmail.com> <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
 <CAG_fn=XTcPrsgxg+MpFqnj9t2OoYa=SF1ts8odHFaMqD+YpZ_w@mail.gmail.com> <aM6ibO75IidHOO3m@wunner.de>
In-Reply-To: <aM6ibO75IidHOO3m@wunner.de>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sun, 21 Sep 2025 21:25:39 +0300
X-Gm-Features: AS18NWCeZeZJHwiXQSoRlyelBxs_br4n2Gp5Ptss7c3DoCLdwMlYv5AhZy2eILA
Message-ID: <CAHp75VeyCujEX3dFBVF=ioHOqPbWQRtuB7_zFGndAejYbMW05w@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Lukas Wunner <lukas@wunner.de>
Cc: Alexander Potapenko <glider@google.com>, Ethan Graham <ethan.w.s.graham@gmail.com>, 
	ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmoar@google.com, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ECFA14000A
X-Stat-Signature: mx6rmok8cfozywghyyn9ftpos1jgpo8r
X-Rspam-User: 
X-HE-Tag: 1758479177-953022
X-HE-Meta: U2FsdGVkX1/UErgWj+FkE/FXtYGcvqENFk96k9mF1ucvlJv67AAjC75Tmo+4FIdQRbgQNWJvAeiIg2g5gY/7bmBVpSXQyEiqbSsyCCk81atz+UVpb4PkpzbSPYNaGImgKj0tin8Wt261dIYB1CEbOMZFBRXSHrX3sta4Gt+r4aUzSwuOF/bWE2+kQ7d+edwV2KimCYvIwEC87w/OwAwgGxbsNirOoARCsOdmd5AX43lBDBujBnoSCyYQ4pe+iDGX/uMV2SFC30obyZpWfC2hC1Us3FmbLRwXI3JBkyhe7zqZ9jB76p5cMHAkhJ40TKYCXZuU0j9qnOHE44mxRKl7oJe4cAm15bSm3a0Pf7PfYhVFWJ9RAHHkS1Z3Bu6jFKNMpRsUQHpCpdpk9vW6EY2kznqVpTR0LXEFK2oW87LfC4wsPqQwsN8GOglEHEj2YmciF1Xgca14+z8BojTXAh18K5HGF9STa4Z2+/jfSB3LxZnNKAINWkeiTGElbv4l2V8Hk1IrqMiU7R+Qe94N2c8FpHWgp/wJ1H44NN+7rQw47Nw0mnXMcrYkTvSgiv/H1KR8RNKnAhrnikyydBbB74r5z5MBOEj5vthU+ppHygmCzdka6cumcBy8i3KmXKH3EHULgPLpsr1Tr6QvlNQNn3+VTZ1akd4uiud9JX+oTmJjhPMVHuJUMmmE3lWbAYfvMWyK7qAu7PXZ8hmtFwyP6RXHiRoj2sId56i23F9+lSfGJz7lO77L0Cp8JXqOhEhCHcvWlo+t6falbGjtGNFcsrdM1y7uXvu8c6mHYf48eV66Ja7IX9G/Qp586nbAfxJLQXLyWqF2yiS5QWnQgmEd3CbCmMn/GGvXgV98ElRO41XXeBTWrB4JGGjiJCc2kaaCQy/KDXD80dvERqAq7W8IBptTVRq9l9Y4Hm5rmRy6trB/XsMDtiKRjY6Bb8STK3EFChPuSeNXRMZc/z7Ro4DSNg+
 haoU01YB
 9c9WpaBIkgPZeyZ5n5R5ji2MOYS/g5ucS1g7IEKEW1Dc3xZzWNedFAa/QfLSyXKWhdeqWECOjJ8mQahADdI6qibOFflU0IMZRtfLnsO8J5RDzaxeKdDPfHtSya+P/8FY7ClJXN+pJGoPwNSAhrVUSeHzuVkbPRdWho0BtQXXfhOxcbH1RTL0CrieAqe8VM/jVW3hHx247Wb2GyQhrQv/e8hSyt0icseU5Hl4wHiTDaBjqC//hMf7KUzoTfBTh69kG7qJqvaUZMepo/ePM+JRPkuAh2dstnZPlfP9kmhy+kg0rEdv4ztHy6BJ2q4cvB80haal4hwdEMGMjRwxV8bIEvLiYa8CSwxC6hSdMInHPPEDYiGzPrtPzuGPa3sypI8DGMTU8JO6xpve1BlloFbVO03aXme4PQP5LoaVG4tiay/wHLbTtmMthvqTi+1YOYAphF70sKGhhAM4nN+/gSuqG/ulWXEzCf71AEZuQmHCfbztAJBYE7kfyfj/Cfcxce4Hmo8SUwzJtz0B7JXsakz+BepM09A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 3:47=E2=80=AFPM Lukas Wunner <lukas@wunner.de> wrot=
e:
> On Sat, Sep 20, 2025 at 02:08:01PM +0200, Alexander Potapenko wrote:
> > On Sat, Sep 20, 2025 at 12:54 PM Andy Shevchenko <andy.shevchenko@gmail=
.com> wrote:
> > > On Fri, Sep 19, 2025 at 5:58 PM Ethan Graham <ethan.w.s.graham@gmail.=
com> wrote:

...

> > > > +/*
> > > > + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file=
 to ensure
> > > > + * that KFuzzTest targets are built.
> > > > + */
> > > > +#ifdef CONFIG_KFUZZTEST
> > > > +#include "tests/charlcd_kfuzz.c"
> > > > +#endif /* CONFIG_KFUZZTEST */
> > >
> > > No, NAK. We don't want to see these in each and every module. Please,
> > > make sure that nothing, except maybe Kconfig, is modified in this
> > > folder (yet, you may add a _separate_ test module, as you already hav=
e
> > > done in this patch).
> >
> > This is one of the cases in which we can't go without changing the
> > original code, because parse_xy() is a static function.
> > Including the test into the source is not the only option, we could as
> > well make the function visible unconditionally, or introduce a macro
> > similar to VISIBLE_IF_KUNIT.
> > Do you prefer any of those?
>
> Just add something like this to drivers/auxdisplay/Makefile:
>
> ifeq ($(CONFIG_KFUZZTEST),y)
> CFLAGS_charlcd.o :=3D -include $(src)/tests/charlcd_kfuzz.c
> endif
>
> Alternatively, if the file in tests/ always has the same name
> as the source file but with "_kfuzz.c" suffix, consider amending
> scripts/Makefile.build to always include the "_kfuzz.c" file
> if it exists and CONFIG_KFUZZTEST=3Dy, thus avoiding the need
> to amend all the individual Makefiles in the tree.

Thanks, Lukas, for the ideas. Yes, something like this would be acceptable.

--=20
With Best Regards,
Andy Shevchenko

