Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87B7C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 12:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6707A6B008C; Tue, 29 Jul 2025 08:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6284F6B0092; Tue, 29 Jul 2025 08:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536D26B0093; Tue, 29 Jul 2025 08:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4356F6B008C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:00:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D58721340A5
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:00:46 +0000 (UTC)
X-FDA: 83717160492.11.AB21EEB
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id A861240016
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:00:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M9DZVpBC;
	spf=pass (imf12.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753790444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T71omp5VnPaPYUhkD5VGEAJJeTj3czjIV76TIGjrbtA=;
	b=XAASkSJMjLILNrAKDMtUk0UU4ezYK7ularRc66jW0txFS2Vox1oCAYFLW6g8R3hx9YsK4Y
	4bZgZytpViVpO7T+XL9yAesEiJXJqWBA/d+nx5Djzx9iJGaRdX+KOIAI5io/k6NjsSngv4
	ccO3GvqDalPdMxzH2M7qZhezOG5VsF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753790444; a=rsa-sha256;
	cv=none;
	b=BsXtcFGpQkPbmJRoU55oF+DYIod7hCkNOKRLZ3W2nzMU/6lDZDB1ehz6BBCKgZVLd6DDG9
	AJuGQe1c/RX6NsDCmlUY6ev6Jom9jt3sDHzBysqt0z/+9oh3vTtx1TlDEROTn0sIC3ls3v
	Jj4wfCNSxR1IsjHhn/hfG8XVUC+Fh3w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M9DZVpBC;
	spf=pass (imf12.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae0bc7aa21bso1115726966b.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753790443; x=1754395243; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T71omp5VnPaPYUhkD5VGEAJJeTj3czjIV76TIGjrbtA=;
        b=M9DZVpBCaVVTPhvcXxJMkj/cDYZ57iLaL0bFszzI/6jjG6iKZmp5BD158TrAIqZCk1
         PFz41w38WCyFE8n0buV8hT//id2Vb0FCveMsY5tYVSFLvC8EDYqtChTAqXRuzTjoaE3K
         tzPRHHor6u19UpUI4Rztjqvcme75UEfWW6Do2Kf8G/i/Uy8YqEQlo9zNau2dQNbR5bLF
         BJOzkgAeiyemMyYcU1cxLiDKphmPileNWbW11SnZvLyzQ9wSJFrM4i07bM6yt+gTaTI2
         ZOxqqH0M7rCrzEclxz618SveYKkIVy5yuglufh2J9N1L2sl0Jcsw49DNvFtrCdCV+Gru
         M0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790443; x=1754395243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T71omp5VnPaPYUhkD5VGEAJJeTj3czjIV76TIGjrbtA=;
        b=SQIRbE+xxS8GhGE5G/v1COWyKTkNoYTSfas5qbQEacEJBfQZIlRl55VWSRwTUd+NWm
         6LaB7e2RtQVkpxHizIeWPCtXWXefXBhPQ4Xrekalavm+1YB+gkxmG7D58bAJITRIlUaj
         Lz2JW508EHDpVFhZNwj8/ztaUeVmYgbVXY2kF2aL+Xhk44KR/Pfo16BRpMtsyo5boFUW
         ZupjdUD9IrMng7CSH+eQIzJu00uwstMJRE5XDgxHNBbo8NyU7sztudVjL2ALeTIcwKsA
         2nSBm0R1TnDrmMg1PqkvF59+pkb7zc2o8S1LLOVjrm9lPwiA9FDZtmDB/nhwFFEOg22K
         Hozg==
X-Forwarded-Encrypted: i=1; AJvYcCUnMusDQJKtS8nuTwkT1eRYp7D65BFajmAAFZ+QQm/IgIGY8ybL1IkwS9unUd09urYPULpFJkOYxQ==@kvack.org
X-Gm-Message-State: AOJu0YzIjWwUsVd5iuvnoCc223rVWAM+Ly+njbcoXU54p4TYA9gO3wzD
	XWi7pHYuPMLoiQl/1vR8WJVYz++kVBqlivDQsFk9EedT8pcDPQqX20/EWl38Wv9TjVrtJJGP3Sk
	t59TPuCg1T+ExXEzZ9/rfRqlKDlJTx5w=
X-Gm-Gg: ASbGncsmYwz7QX9v5XNQJ2GqFB5LQmOAJEwrxInHMATXs3xFrwjlz+EY4oG/0o3z9Id
	piMJbrok/hK0okjWQWV77LFAMIOj1/ic0X3ObY+Rnkpc4mxGo0qPEVnUwbnzAhQgqC80KTkGl11
	aOO/kLTXoGAN/n0OuuijvEqCZjCCLPABO6eMHLWZ9MQtJrT3SF12ckm+DPwC2iQd3cb06KCdAw6
	aFdxAKqj19SyN919AZX
X-Google-Smtp-Source: AGHT+IHI50mh77+KmKYUPFMQpLDoGMPMeGaz5hvMplW+BGg6jqyM13nj/daE7kf3KpgtX2epm1dM6w59Adlag1YAld0=
X-Received: by 2002:a17:907:3e12:b0:ae0:b847:435 with SMTP id
 a640c23a62f3a-af61eb0d30dmr1821169466b.49.1753790441500; Tue, 29 Jul 2025
 05:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4@linaro.org>
 <202507261937.Txq9shpv-lkp@intel.com> <CAHp75VcrL56_8uKNrmLj9sk+t7qZfKNi6-W-yAKNZ+mSCXU8zw@mail.gmail.com>
 <CAMRc=MdfMEAjgkTNENZejzRPN4svCiy4VZS9Y5HG7Ht5XwqUgA@mail.gmail.com>
 <CAHp75Vd6Vwk8pLarDk+hDQ2S_ufZ6wNw9xffMUJfQ5M8bPJubw@mail.gmail.com> <CAMRc=MdNN_J_uB4wxGgpvaxmhgGCYwu5LXCEFBOurNWc2OmSaw@mail.gmail.com>
In-Reply-To: <CAMRc=MdNN_J_uB4wxGgpvaxmhgGCYwu5LXCEFBOurNWc2OmSaw@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 29 Jul 2025 14:00:04 +0200
X-Gm-Features: Ac12FXwnzreOOhB0DO10QJJwRXKbVGABZpGShwmlXbV7ZXNZ8Iy65zL8Tf8Pqqk
Message-ID: <CAHp75VeJwGm2v=jGrd+cnitZ-cyy3bXoiDKkV5xQ70P-oecvyg@mail.gmail.com>
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
X-Rspamd-Queue-Id: A861240016
X-Stat-Signature: z8wwg7ohzfu1xys7dta1d49jgt3bbjdo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753790444-570062
X-HE-Meta: U2FsdGVkX1928dxfsm0OgngjUXOs2CVmuw6sZgLEYjcLDLuE/q6sKrrGaCJ7F9FdqzrB1JzUYqnaPvB59KGtqXJQPiLWCZ2bQi1vIuWKFmNckvDSW3CD7nkGIXrSod9wAz4wdlVRbWgQbi8acF+cYTqmZ61253D/OOphiB56MxQQtchrdpq8NuqfNIaiS/YeAspqAGVAWw1VCyXf0NB7Vtbuh0hv1ua+m4mQNGCE7zLLfaKaNr/yYIEkMmsZqA/DM/NfpZm6exEyBnH+Owl7e3/oUrB6y341Xy4tKw2nhJqfrBvOkhD8twWrKjuev45u5xo781IPgBvWI5RjkAm9f+pat56auiMojqX8SP8+RjHRQfV3gHqwwA2ye8LlUrAkaGC67k6JtCxz+rRWSZ7WCCWoVz+EUGI5CC8FgoY2dPUzrXPG/n4/PB7my8x4N+dVqE/bcSYQ9rUICUVkeCLBdefJNxxBxWsJTUuxdE0O0uMGe2pC/ahabS9arqzWip7XdJ3KgdkUGbDkNULWb0vGgpZoDYOa3M6z7Xa7ID5F14JhXFSEfi2ql3m1XOMDaC07AyBBEiktMrV9uKjTGrbslY8+gQE3AeGw/JKgf4Ee0ZZVGDGPtid/3+d0pJe/jF3OW3jbXP1tCQrmX8PGiquWsMXar4EMF4kKF5oFKoLEF7oPp2JuLh74qO9CSynpFAHb7JqL1L88tAoquvaB15hmOIXVb/Jx4pIoJYdoFV0DjP0JLmssMVpcZ39cuTmDB3f52+hgVi1BNK1kZcsKtUdEH0KocTQtHZ5ynB9ZVzS+xUjwSJCHPrl4/qkr0AJEb/1e0pwVJERNk6FUgwkDHhJNBZ82O5DDpnWJzTnW8goE/GjjQUXJUULPRet1ccnvgfDe73E43OsKweMXLMn8TYIEdFbO890FbRwlHnJoJ8ybSupKHKnqtpyN/t1jJvIli72F2hBNi9AwVG3X4ZS9Kri
 ZyA3HX5o
 L8MyZorIgGLYv2hCruMd2bSn7JAfXEW0Oa3xdtr4tdwA3NwERst5IrInjbmUuIBbgjpioDcJDe20Hr4hoGUrypxJ2I4MAQ/y+t75fbSl5ucumLEVwxy2r1xKUG5d4APxNTLgwOGIrwxJTivJFkw51kP69mivufcAqY3D+ZPZlMPCqAwszkzDBVLSu+WaUaa7UFSXb3+L+s741eVnEv0qiE6uB0RJ2EBlpcUTS7+qTsdaUGlLtjwkyuR9JX/+9JH0smE/VvqDKQacc0aC7NYfB1j19afzAIbQsUwulNz8kgHQWyGOivWKsHfO+xDwf3IWDPHaMU4D0Tj+HYxaYRpsssskfllIe1fSkYCAwSaLQuQCsESli+v8hLJElVzdusST8aIfhgHcDS1rBCE4EX6iotWWmGu6mqW3L7A3TJOU/HcmBjp7tYSUmZqQPjmb+uvz1Q1Y8Xfvdurj4NY3UoeCigJ/VybnE1AjFA7SsoZrcHNpAnW4/QMhhR/KxzT+meURgUmU3E+QfbRwVN0XDQx/a4FBvE2Qkhet47XyiUDrtpN2ncbQRAVoFEL6VHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 1:06=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl>=
 wrote:
> On Tue, Jul 29, 2025 at 12:32=E2=80=AFPM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Tue, Jul 29, 2025 at 11:27=E2=80=AFAM Bartosz Golaszewski <brgl@bgde=
v.pl> wrote:
> > > On Sat, Jul 26, 2025 at 9:29=E2=80=AFPM Andy Shevchenko
> > > <andy.shevchenko@gmail.com> wrote:
> > > > On Sat, Jul 26, 2025 at 1:31=E2=80=AFPM kernel test robot <lkp@inte=
l.com> wrote:

...

> > > > > All warnings (new ones prefixed by >>):
> > > > >
> > > > > >> drivers/pinctrl/pinmux.c:917:7: warning: cast from 'void (*)(c=
onst void *)' to 'void (*)(void *)' converts to incompatible function type =
[-Wcast-function-type-strict]
> > > > >      917 |                                          (void (*)(voi=
d *))kfree_const,
> > > > >          |                                          ^~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~
> > > > >    include/linux/device/devres.h:166:34: note: expanded from macr=
o 'devm_add_action_or_reset'
> > > > >      166 |         __devm_add_action_or_reset(dev, action, data, =
#action)
> > > > >          |                                         ^~~~~~
> > > > >    1 warning generated.
> > > >
> > > > Good catch, LKP!
> > >
> > > Ah, strict function type cast...

...

> > > > >    910          /*
> > > > >    911           * FIXME: It's generally a bad idea to use devres=
 in subsystem core
> > > > >    912           * code - managed interfaces are aimed at drivers=
 - but pinctrl already
> > > > >    913           * uses it all over the place so it's a larger pi=
ece of technical debt
> > > > >    914           * to fix.
> > > > >    915           */
> > > >
> > > > Indeed, this has to be addressed first, and IIRC I also got somethi=
ng
> > > > like this in the past.
> > >
> > > I mean, it doesn't have to be addressed first really, it's another bi=
g
> > > chunk of technical debt but we can live with it for now and address i=
t
> > > in parallel.
> >
> > I don't know how you can solve this issue without addressing that
> > first. I do not consider "fixing" by casting out const specifier (the
> > whole point of which is to be not mangled).
>
> We can do nothing and keep on leaking this memory or we can
> exceptionally cast out the const and pass it down to
> devm_add_action_or_reset(). The scope of removing devres from pinctrl
> core is quite big and honestly this series is already big as is. I
> don't see it as a big issue. I can meet you in the middle and simply
> implement devm_kmemdup_const() manually to avoid casting out the const
> modifier.

It sounds like a good compromise to me. You will have my tag for that,
if it helps you.


--=20
With Best Regards,
Andy Shevchenko

