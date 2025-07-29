Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CCDC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB44C8E0006; Tue, 29 Jul 2025 05:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64D88E0001; Tue, 29 Jul 2025 05:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53308E0006; Tue, 29 Jul 2025 05:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B00B08E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:27:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AE25133B80
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:27:58 +0000 (UTC)
X-FDA: 83716775436.03.7B93D27
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CE6E12000C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:27:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="EMOmzY/r"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753781276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuYSK4gM34dvKj46U2AHyFVlRRjXrZ8f8iJud63I7rk=;
	b=OL4LZhl83RnD9dG9CSUuubbZlIMqfrdyINk+nfnx5XO4XroJic1zVPQhT8YKE+kL4OqL/F
	ujC0s/z3XPNizfEZTagBSfc6BDnSJ5irkN8YzJhQquhKhe0iMeBKrD31L+EWLfmtZ+qZdO
	PoaW5FeeGO2GhOvudhzrTECXtZwlrMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753781276; a=rsa-sha256;
	cv=none;
	b=QRbF6C+onYoBlhezAHdD/tzerb6xX0ajnaBZk1iifhJXUuyQ2kUX+JkSGRMkrk0fsqdDrF
	AsmsiVHek6/nFOMHmpiGWSiCetyGKvegIuOoGBGlpCajH4Kg9Mnlaur4al45lWXGkm9UoL
	ltP6yPEM3VDoKVYPQZLHhBmgc+XQmus=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="EMOmzY/r";
	spf=none (imf29.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55a25635385so5974663e87.3
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753781275; x=1754386075; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QuYSK4gM34dvKj46U2AHyFVlRRjXrZ8f8iJud63I7rk=;
        b=EMOmzY/rA0hAGH7elCSyu7pwuNf4hUs8+SW4L6RIGlBfmnejNlRNSrfRrGXR3bcI08
         zrEkrqDcdoWdCqs/sxVczQIciHGb1e27WTNY4AyQiosLH4wCuShwSO8eaymZMZvu5xwx
         1uOUuFp7cVRBFBsdt2cA/JIRzHJh6SDSShNO9yCunwcZkSTgNZTVlorpB8j2NFpFTmp7
         /TLMWy6oc5FOcbynfTLqdZXb23bFma3HiOwDyrNkdbAwN5bHNY9DPmodfuSrK8iMGlHe
         Af7A26rYNMst7iAF4IYjHIXhLSnAsl8gRoRtr5qfHxEaqG9UXyKtk/p3BlE58vDXhZua
         hbvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753781275; x=1754386075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QuYSK4gM34dvKj46U2AHyFVlRRjXrZ8f8iJud63I7rk=;
        b=p/Lsmdk8L5eiWytF4kY23Rf6VQkuuwGWjp6pgNNHeoVGzugn0aAsjoy5QCwinsdbd5
         zIuUIE74+ptwaTO8NK7jIZhSOGz8zYRBAv2qsGNCXgkESjFbJZFDb0FovI+jUMlaufSa
         N2O331sx04nyytwVKUPfIgc9iM4tronDEwlfkFCbvawQDViGKC8XY3Qgn9Qr74JaW2B1
         LmL9xZtd2ERf1XXpzAWZ7J7+expBs2lB8HjurOn+r2gg1Rx27NcFa+5CDhxGilNQrQTZ
         jaGj7U0kn1/EsT7Fp4nQgBbBmfaZBtpRnwikL8u+NY90568ABS6r8Sh4F+DDC6Nn+DZ6
         eCLA==
X-Forwarded-Encrypted: i=1; AJvYcCX+3g6kkzBW8sNwjOA6rlcwdPBBFZ7UDcRMMQnFDb9EqnwOh6EcWS37zfSs0qt+0X0gLGg09yDvYg==@kvack.org
X-Gm-Message-State: AOJu0Yw9ueD/QY4BtXQaY3Djoadoy9CAAzn/GzV1qPTFXWqusNNCToWo
	uXfEJTpq5WDns1iB5uU2VLgxk+20uy2QB6cF1KfKYCE7j/l/lP+4MwtKReWyGpPbAQpRFL6wj+s
	98tn9li83VPYwSNWNmop0gfWklGrHIKLqZiAM7lIwpg==
X-Gm-Gg: ASbGncv4nMPJm5A+ZH+XwRXMnedheoN2X7Vyb9mIRAMwjlMDkYwFuoCub1YoHSG2D8K
	WJfKii2/5Sh8VHV7X2P17zw0Y0QntooE2ZmsUiUni1zmJnuxa7kQQm+nzBay+EnQfvhq64Rgaqd
	RAohxvY79YYh7Tv6r4M8qwFILypWNLJsHwOy6DTwgUb6fxjZ15NNhDKFq63srCCcc/Bmg0bx7mJ
	IXJcNKk3usrY37QDOKZTnbIql4LzwtTGbqNEuM=
X-Google-Smtp-Source: AGHT+IH1xjV/IusjYm7wD8jJwivk100eFvhpmAtG34em5DQvAFyq0WxlVADr0UXhPPNReVxqcy9+hVN8vSu0g22pdSc=
X-Received: by 2002:a05:6512:1245:b0:55a:26ae:56e1 with SMTP id
 2adb3069b0e04-55b5f480918mr3865559e87.27.1753781274688; Tue, 29 Jul 2025
 02:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4@linaro.org>
 <202507261937.Txq9shpv-lkp@intel.com> <CAHp75VcrL56_8uKNrmLj9sk+t7qZfKNi6-W-yAKNZ+mSCXU8zw@mail.gmail.com>
In-Reply-To: <CAHp75VcrL56_8uKNrmLj9sk+t7qZfKNi6-W-yAKNZ+mSCXU8zw@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 29 Jul 2025 11:27:43 +0200
X-Gm-Features: Ac12FXzctTCjvP8s5v8QO4Q26z9E9jC3m2QKR1Qn8JCLGwl_tkRpE49-qECZAkg
Message-ID: <CAMRc=MdfMEAjgkTNENZejzRPN4svCiy4VZS9Y5HG7Ht5XwqUgA@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
To: Andy Shevchenko <andy.shevchenko@gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8CE6E12000C
X-Stat-Signature: sks4tfijz8s5yzhrjysm3fdnpwfbybpc
X-Rspam-User: 
X-HE-Tag: 1753781276-482936
X-HE-Meta: U2FsdGVkX1+bxINOTllqN70MkJl+gRuSJm/PymVSJ1adxyCkui6Z4w+T674tnSMtbJf22YoH+RBho1Evy+Qvxaiy4CTcXuM4mxr7vUlju2AavUJKcCm5t3u/fA7jA7KjOOeS/TDV5e6xqKek5a8AWOQ8ikB+rG1095kb/lDFlNPdliA28FDp8rltpfwkdWIjS/vMvw/sMWz1fJmNVfpIFLGyhXxH7wB9qOuxMjLzG5HRMRvieXaUWiWZSqmsi6fcV+Tf5mFZee2pE8TEf7fz/BbEWqjQEixCiD2BlyNsFYxxUL+o1vcZCsznwpzI2u0TZsKmDKvz/4hf+fKmr5JKIiHf/QTUSSsJrlDY197YlFmIpBpWSMHxSIuepOPW71da2F5WlAvcSLQUyjbPTIec62E3rasFwOeYor8EYq+VpeaPkXYxXFGJtvgA27wNzXFlvv+vzThh8iRa3MEFe3PIkzN7AdQP7K07dTuIfaRsKLDTdZpGy2d5WzE3aBwmr1nSduPq4Muyl7xpdgJxiJe+emWgXTFmFILyq5iFJVRJQ49Y4TYfuO4LxAmC4xmWdcB0w7T1dnllmC+s+/HQMMDc0pGZ0RcwTMC+pD760VHuffEhNG+nHqKdx5sHf6lGQeXlE0S4Rz2z8MSVqoURPi1yqeiaRywKwlWnlpMynlCa+kkSfp63VERLVgDKmZ6XMnG50cNHr03HmDd4JMHy0HlMish5Nkg+zTN/7Hhl74JOZ8ML3g1J3++RH8FCp+SPtdDgjHgXwt6ev2KdGA0Xtll168gcFYs+5F0QHCrdok2sE3Q1Bc6YeOwUV/ZDtpLB6Sux6ZNJ9DZ797+8PwQGxxD1BryHOEn1atg/LP7kKXb0Goauff4sGK2JULjMyEn0NnuJmiH7pILnwYpGqQrqPNHQ7K4xgqDFy2dKvueefmIqXnSNljkAPrsYzAnb+x0/+LJcZemQM1HRmmTrNxdnEFh
 k0Xv68T8
 GhUENFJbQ/xMJ651hT8I5xbEMlE5i0OuXOOUk39leQ8UR0sPpQdSvC+YrOd53Jt/V6eGM5gUF2EwjyMvUhJcsGSc4g1ZpWWsZMac+P7Nr/hynREu1cY/Wc48Yq9wTJZ95wc6pZyAkIMJdPiE4rWSZ0A7KmyjykSyD4Eyy9wRCWh3aKyR7QnqeGoSHY15UGp9l2AfQTo02w+Ww/AihtDauwhkDtW2qkzP/KfCYJ4WeRBUwM0V+BzvMfWuom1/8p+726dF9mLvqXhlvBvQacybO7E5Jd1FBabiTzm6eRWk704SD/hnHwFZ6KOTWN561KAsPwZ042AZZfjLrmPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 9:29=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Sat, Jul 26, 2025 at 1:31=E2=80=AFPM kernel test robot <lkp@intel.com>=
 wrote:
> >
> > Hi Bartosz,
> >
> > kernel test robot noticed the following build warnings:
> >
>
> > All warnings (new ones prefixed by >>):
> >
> > >> drivers/pinctrl/pinmux.c:917:7: warning: cast from 'void (*)(const v=
oid *)' to 'void (*)(void *)' converts to incompatible function type [-Wcas=
t-function-type-strict]
> >      917 |                                          (void (*)(void *))k=
free_const,
> >          |                                          ^~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~
> >    include/linux/device/devres.h:166:34: note: expanded from macro 'dev=
m_add_action_or_reset'
> >      166 |         __devm_add_action_or_reset(dev, action, data, #actio=
n)
> >          |                                         ^~~~~~
> >    1 warning generated.
>
> Good catch, LKP!
>

Ah, strict function type cast...

> ...
>
> >    910          /*
> >    911           * FIXME: It's generally a bad idea to use devres in su=
bsystem core
> >    912           * code - managed interfaces are aimed at drivers - but=
 pinctrl already
> >    913           * uses it all over the place so it's a larger piece of=
 technical debt
> >    914           * to fix.
> >    915           */
>
> Indeed, this has to be addressed first, and IIRC I also got something
> like this in the past.
>

I mean, it doesn't have to be addressed first really, it's another big
chunk of technical debt but we can live with it for now and address it
in parallel.

Bart

> >    916          error =3D devm_add_action_or_reset(pctldev->dev,
> >  > 917                                           (void (*)(void *))kfre=
e_const,
> >    918                                           (void *)function->func=
);
> >    919          if (error)
> >    920                  return error;
>
>
> --
> With Best Regards,
> Andy Shevchenko

