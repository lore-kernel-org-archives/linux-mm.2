Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED94C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 10:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B2A6B009B; Tue, 29 Jul 2025 06:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCD6D6B009C; Tue, 29 Jul 2025 06:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAA36B009D; Tue, 29 Jul 2025 06:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A787E6B009B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:32:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74EF31139B2
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:32:31 +0000 (UTC)
X-FDA: 83716938102.22.CAD2EAD
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8019D120009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:32:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ctKdu90u;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753785149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUlNfqlQv51czIMEh6zHw/PUQr/dXVTYzNTmvEdWeJQ=;
	b=VVl9NmrkTPv/42U/W+juW+Ro0bh4oEQK0pBrtWnv5hPl5coFE0lO9ZZm2CIihST6JHPC0G
	T8EEhYxDX9Mdbrn5mBwHpvlis1gJzgcLv0nhT1hpapEVSW0/1PQNY0cUnVZC3VBHCd8315
	huD90hikRubNehq+r65Eay9hVCh1TOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753785149; a=rsa-sha256;
	cv=none;
	b=4o6HCdybFdHnFTBqiFxlXLxi4E6GZ5lc+UT1XYPCmJ3/o3eTU9DkYdu6Vk6HKjdfcLqVCJ
	CYeuN48CmLiEtHYHZosZOMHQfGiXgAUjdoVwwz5n3aoTdXH5UbASM4Lkuhofk3eNONc4rV
	eUUGEv3C2sY94e5e3A6qyo0hNJ8r3PE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ctKdu90u;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ae0bc7aa21bso1097191066b.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753785148; x=1754389948; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KUlNfqlQv51czIMEh6zHw/PUQr/dXVTYzNTmvEdWeJQ=;
        b=ctKdu90uof37bcNwECooJxLjC7oHPOyoiHHWptxKnhmbowiCGdD0tuna1KURAUIw+G
         HktHSqQx0gKaKhW0ivnGZV4z5BV3bWIi4E6fLLVowgOHwY9JfGAaPOni5JwqRWOCpEBV
         dt5HWMsoJM8ZrH2qD7rPEJ3kH3fCho0LM6ZjOY2WgaDVfrXAIZz23/s0xGbQBgOXny88
         xzp38+6M2+r7tWqX/AbOTGirBrNfJwzWvDVqI214XyTyNwsjN0J59yEf1UYPSmWvOScl
         /muuxdWpabFYWLOAFfKursVXqIH1rljbsgvTanbU8jYSasWpMcC4DZY7JplKPJAoUvm3
         CNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753785148; x=1754389948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUlNfqlQv51czIMEh6zHw/PUQr/dXVTYzNTmvEdWeJQ=;
        b=ZRjKT6Gks5FIDD0eidytqZSMmNrYFwsZNT70ccR4GD642SLYskzfkJhX1al5Zubb5a
         Yc/1nsXf2JNINlvcNwAayJTM6s5KItWL3oCOSo1XuXhx472TVmTPiemDDnUjZhf29tCt
         vNoe4xXO+2cUQ+lGQmdymdASefX/1YJZoOXTVblGTGcPoyRSa/E9QLRm7oBm/1p12Jjo
         3RBv9iyLe9RuGPM7AFJGQsDtsPdIsZ7+2gK0oOyVuG+KvqWSCnI7D6zzke7aQhL6MJb9
         SoJIfiRQ3IjRGLqqamqpj3fdLmJCNfwMviHqTPmJSOfwVd7kjiuCvfoVD6mE7zjSQWLh
         mwsw==
X-Forwarded-Encrypted: i=1; AJvYcCWl59sU8ChCm/2dNH2RLoVPwhEiYR64pcGhCvC3P9nTVmh/1Osed0bfFOD3vKsPd4AuEaweI2lywg==@kvack.org
X-Gm-Message-State: AOJu0YyYKZQlu3tFTDyFuhlC5HNILrDv1sqzmKd1RgtktY3t+AQqODwf
	ryAMl5r0s6H1aC6cj/aF8P/4rDJLjIkG252MmjoP/nNfYvhrCz+bd6jJZb7Sq4mC6t1ZtXLId5J
	jD5Hp2mftV1tzdQF4mQQ77Oj0svVQLEU=
X-Gm-Gg: ASbGncs7VqFUgeRQMa8p++wMdua6aVtDkH5m2sZhWcF70x+maSi579h/gPBFb6+s6oN
	yLGqslk/hQwOvib7lyk6QH0SyQOfYkvotXGt/wDeIE7skn/0oongmyNw+SikvW608kJZbCv6ucl
	z/hR8ohOAkIhTY7E3udfzqVCYgBCDfwZXvpwpx8XDWGKJX/r4X5NYJPStDnr2K1Rkfm9XMeMmeV
	VKu/RErSnSicDreT3CfCWk1ob2MoYYba2cOI9sY6g==
X-Google-Smtp-Source: AGHT+IFxXAHjt8+mCk+a7x/xU7iaEiDEIirgDpLkHyDsxKg57EPvq9+iw9tF06YJDhuR9Pkw7TMPw9RYYKU1vYDLXKk=
X-Received: by 2002:a17:907:c1f:b0:af2:b9b5:1c06 with SMTP id
 a640c23a62f3a-af61c8aa24fmr1664968966b.14.1753785147471; Tue, 29 Jul 2025
 03:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4@linaro.org>
 <202507261937.Txq9shpv-lkp@intel.com> <CAHp75VcrL56_8uKNrmLj9sk+t7qZfKNi6-W-yAKNZ+mSCXU8zw@mail.gmail.com>
 <CAMRc=MdfMEAjgkTNENZejzRPN4svCiy4VZS9Y5HG7Ht5XwqUgA@mail.gmail.com>
In-Reply-To: <CAMRc=MdfMEAjgkTNENZejzRPN4svCiy4VZS9Y5HG7Ht5XwqUgA@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 29 Jul 2025 12:31:51 +0200
X-Gm-Features: Ac12FXyzhjLDpJil0UBomtlZ5A8XPq4-tiZzez2Wp0eBW04tx8ikqHk1kggUetA
Message-ID: <CAHp75Vd6Vwk8pLarDk+hDQ2S_ufZ6wNw9xffMUJfQ5M8bPJubw@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: kernel test robot <lkp@intel.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Alexey Klimov <alexey.klimov@linaro.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Sean Wang <sean.wang@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>, 
	Andy Shevchenko <andy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>, 
	Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, NXP S32 Linux Team <s32@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Tony Lindgren <tony@atomide.com>, 
	Haojian Zhuang <haojian.zhuang@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8019D120009
X-Stat-Signature: uo64z54sr8ui8aaj4ujicq4d4kbg8kjc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753785149-931154
X-HE-Meta: U2FsdGVkX1+rG6XeqY1giPI43DKq3Bc7a42OAykxnwpDoyXb08PydeqeK6BtPjks8amhevSv3nzpaIE88qK/51fs6DYMKlPLhkvHWp6Mb2MhQnRnd/i8Pzl8VyRnYFC36Y2DnFA/eYQBQiYKl0kWIETX1b9jtrFqd08wHraW1FZKKyOVurF3HBJpvFGsjodlnBealaezLIZauAt0NE7LOidm/Jy/vfqkGJ3hNtfy1R3EFU9ItcXLdDfQogsewhTLqLIur2VC9L9KyNAMGprTLWd6Ca/BSzVrxqjJy9qThkK/fGCLXh606/lQiyGsFK+8dYQWxGJQ4O86lbnnF8SfMnqcDnNcvUTa5qJjqf3Ax+RolKANZNQIiCVvbvFfPkV+i1BkO/328HMYQUIzQ1LyrNG/pvaXAmTAZNHnux44osgpoFb+i7A58XCbWyoOO7JRqJVxhcywoiDOY3+E83L0XlszMLasKW1xs6oANqtO4AcdYsXIdhYvU86f6i9yFGDyCx9IiS37rpxD6MS0Ik8YbYZvgRZwGBBpJby9WB/7w8LsX4s7jkexyLv+6Xk7X/XyrWAjkekOBZmblIhNNp+uiWCZARQcIoyQ4kIaArW8nyYZTK65eGPjsM06yHPrV0i6HYJWBlsBoQW2D0q4TECyMO4A70GDlGFl1LQJR/ZHnXhu8lgNWAe8h+b1P6iWUkmyNqEkk53lVLg9e+3/TCG5P17DEs4n24LZX7vJYmArV8Kg5l5wdZW9nXOMUPSeIr9Ntu1Vu2ub747lYkaC8oXcGWYoDA3bh6F29z+jmxKNb4a/2Lm/IResPfV+cODX22b3KWTnmIH04OS/+f/jcoPYWrHLG4FMh9Tk7kVLlfOvDfXzyZbIzpV304fsl5sZ/KgLdxZynozq1aXRwKt8ZjuX1Wp4S1msdYPTK0sf0GYzXYUs6WAcR+OWx8BQ2rGIa0N57fusuVjjuKO+ICtD/UN
 N1MLOk/X
 WLvaVUVyK1/daM1uMkkLzLBrGHNtJ810RL6qRzhl0aYghuAnVWWeiA2bjEq6N4m1nEIwPYb20X2wxi0ntwrjZS0nXRFoyT6jNpFcdeFVW8vfCxb7mRvWKXL7blMoO5YHQR+kcj10la36fHtwIMR2UeZxyrF2Ds9O3XhE4cN8Kg1cUEIU/EM2dGOFP3aVptV922yDDP3HrOyDBz4EMyEl54ffI1AdLwbZpr7bJvJNgQUeMZZUc3TctxEKLCQTknbzc6T6HSymcWczI3I5z9Pua/SqkNznsJS3ltyRwGZrXS59GsXqPl8f2xMasAgwknY6gUCNTCM9F/hBPKz7hEyb/mftu13ARVSbSCDy7hUr2fSx6+ZvAPLoALzeCoK4cPfpdYaomvnhLxtOuJjf0jYUuHLG4RpDxamwCXUxa1pYqT8sqWHYrxTDkCnfzx6exj5qABYZ9TelE//6M/irOZ3ynONWh9k4iWAr6yjYO83kZ3Zns4lQwCIHBW0AbKdBMUQNhzdmfsAd6756qdOaladmSVBRWg2gGWXRkXPVheQMEbYOA4z331oky+8gKqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 11:27=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
> On Sat, Jul 26, 2025 at 9:29=E2=80=AFPM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Sat, Jul 26, 2025 at 1:31=E2=80=AFPM kernel test robot <lkp@intel.co=
m> wrote:

...

> > > All warnings (new ones prefixed by >>):
> > >
> > > >> drivers/pinctrl/pinmux.c:917:7: warning: cast from 'void (*)(const=
 void *)' to 'void (*)(void *)' converts to incompatible function type [-Wc=
ast-function-type-strict]
> > >      917 |                                          (void (*)(void *)=
)kfree_const,
> > >          |                                          ^~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~
> > >    include/linux/device/devres.h:166:34: note: expanded from macro 'd=
evm_add_action_or_reset'
> > >      166 |         __devm_add_action_or_reset(dev, action, data, #act=
ion)
> > >          |                                         ^~~~~~
> > >    1 warning generated.
> >
> > Good catch, LKP!
>
> Ah, strict function type cast...

...

> > >    910          /*
> > >    911           * FIXME: It's generally a bad idea to use devres in =
subsystem core
> > >    912           * code - managed interfaces are aimed at drivers - b=
ut pinctrl already
> > >    913           * uses it all over the place so it's a larger piece =
of technical debt
> > >    914           * to fix.
> > >    915           */
> >
> > Indeed, this has to be addressed first, and IIRC I also got something
> > like this in the past.
>
> I mean, it doesn't have to be addressed first really, it's another big
> chunk of technical debt but we can live with it for now and address it
> in parallel.

I don't know how you can solve this issue without addressing that
first. I do not consider "fixing" by casting out const specifier (the
whole point of which is to be not mangled).


--=20
With Best Regards,
Andy Shevchenko

