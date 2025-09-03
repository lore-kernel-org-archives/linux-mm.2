Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63622CA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D57E6B000E; Wed,  3 Sep 2025 03:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD4C6B0010; Wed,  3 Sep 2025 03:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2BA6B0011; Wed,  3 Sep 2025 03:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE376B000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:34:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6D07160556
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:34:58 +0000 (UTC)
X-FDA: 83847127476.07.687748C
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id A29D2140003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:34:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756884896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x+a63vXZQbYfBRMYForQk38b20jSe1QhqlF3QJeCGYE=;
	b=MhoRiHcPqyDyPCNeKHQOA2S1Jhn5opyd5zGx3Nx/QXgi68HgxbiFeaUY7+2E6j4b5xFdm7
	y7vMpUBIf9WuearNwO2+q9rJKC8caU6O0ijLa7AmQHrldQGMAO881g8vwd7iE5J/yF9DuM
	XGJg15IWUC2lrOmarxMVGdbNaTNvtO4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756884896; a=rsa-sha256;
	cv=none;
	b=pnE9yg9cvEaySoRobKJU75a3YWYcDOk60Bc/kpG4EIdVprsbumoTX+b2GdrM4dyrjwSavw
	9qWQAcQNucxvjmGVJ/ggJHr3Ced9O+ZwaPfQMVUKneaHaTaGOqQtf7rVofMd8bT9LCH9GW
	19arNIxGb5EAjcvbx6cth7wYsKDdXuM=
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-52b7402151eso1812139137.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756884895; x=1757489695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+a63vXZQbYfBRMYForQk38b20jSe1QhqlF3QJeCGYE=;
        b=U8PfD1eyqWSHqr5lmPQMFFywnXYCrNy3+Jds83mq+yMiyp/y8Q3FaRpoOkCKar0kst
         ZHSrgk+TslLgqiTnzUefM7I6tT9yZWw+C8Bl+oRQ/TZKNQvZFOaQpgNU+kYf+EVOzW8x
         S0pEh5tlNmDY/8EDO7hdeWl3qw4bdXaMOwEERrXrhhB33GrURWD4v17uBTUf71Q+nrD8
         wSue66K175+upxRsXv/A0drulcQUoXg2nXMm1Cng7LdTxf1i7IVR+C4kkAesuQ2ckUE7
         CWjjpTOxo6l3sk25l8e4Sxoc9G3ELFXM4QmuqamE1dr2wGhyl8jP6MAHyuvPhNPrI/y+
         zEaA==
X-Forwarded-Encrypted: i=1; AJvYcCVQsbtKVB0AezEaCtiFnTgadN08W4cgOUepbNery/XbTkhEcVrLxEkbfn/BkXs2e7qAYbWDE/O5Wg==@kvack.org
X-Gm-Message-State: AOJu0YwtLPu4VwFAFRNLOokCCHnwh40SM2h8X5Ha/mMCqI1e6TxDjItf
	xTJZVX3G807YOIiT82SaJGV+Y9leSvPUu3CjoshQp+2O41+1DoR7okMnGhwy56NY
X-Gm-Gg: ASbGncvSYCEU12/E1Ow+mXtZianr0AeBAdsxUYM4KMGBRHXkwmwnKPWw6NjYMFxv/BT
	kwIQSDSblifNBT8FP9/khB9lbW88ktyBvas1sZ4F4o5U+iIeoe9W/SADWlYqheCI0Ycc4rxQWuu
	TPpxET3aK+0Iqfkw36IrQ7++46tBxeH3mCIVPkVTxScBzeUqawbGaPWt2H8rsCzogwiMGMgaX5v
	vOpxMvl6TRIxDXJYMfg0SgDgiTrltkry4gXWzcFlk0Hrc/Xo01MeMryJrjI333n+d7zVvclq2jp
	4tWWT9GavL+YeXLgfS0P3Oc6lQ9VFk4YKYH+nCNDBDbmYzun1F0xvEv9tdVM3814HWUey/LcpxC
	GVoqFTJZmXC7v3eOXyx4TnHxWNWZcKPHO+srI4u4ogBwxQdkr6AM8bLtcTqn9
X-Google-Smtp-Source: AGHT+IFY4xQDGB1diI7NbGdmJP29amleseu/sfsoPEZmauAzo11In5p4zFZ1RpTgdNSTD/frHZQW4g==
X-Received: by 2002:a05:6102:80aa:b0:4fa:d2c:4fe with SMTP id ada2fe7eead31-52b1c352d2bmr4784912137.26.1756884895379;
        Wed, 03 Sep 2025 00:34:55 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-8943ba549d2sm5339956241.12.2025.09.03.00.34.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:34:54 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5299769c79cso3040230137.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:34:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVA9rroW4+7/ZLoGH10B9N/nobqVr/r6AlamLEc9xSxod5HQNcc2Ft+G8qOk/7bxVvGIEh9EuQNGA==@kvack.org
X-Received: by 2002:a05:6102:3581:b0:524:5266:f74c with SMTP id
 ada2fe7eead31-52b1c8811fdmr4486002137.31.1756884894118; Wed, 03 Sep 2025
 00:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com> <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
In-Reply-To: <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 3 Sep 2025 09:34:42 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUd1PeUbdkmrhaFstknwP2x=03m24gacJBJgEeCDf7toQ@mail.gmail.com>
X-Gm-Features: Ac12FXyh8sb0bID330gK0HQPUvNSBJ0mn18x9ggidNhkopon3DqspiWAPKYplC8
Message-ID: <CAMuHMdUd1PeUbdkmrhaFstknwP2x=03m24gacJBJgEeCDf7toQ@mail.gmail.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, Andy Shevchenko <andriy.shevchenko@intel.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Alexey Klimov <alexey.klimov@linaro.org>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, imx@lists.linux.dev, linux-omap@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k9g6f7uiuuq5ahf3i9bc89yi3n591mj6
X-Rspam-User: 
X-Rspamd-Queue-Id: A29D2140003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756884896-736780
X-HE-Meta: U2FsdGVkX1+LflDHaomT96cFhaToiFVjp6/8vqYqzuznAsKNYQLe5i9c0hx8xt4qtMzw00Mc3a/hoxBYnsHOM4AqUtwASknS4brW5qdZW/3G+95dYCMOiQ1Ncmy7kF9lsTFBYvL+kue9Yho4IolX7eH2Mtw3WjjwMjdPrKjAL23MGOzAszs3VdujetYJxGdYlXc582hS8ZgYi7UmzZek7YMohLSQIK0uEfuE4hI/l62q9V8/m9hSntcT6kmJ21tTIHZxRA8tC0XM8r3+Mz8HMIqJ7caPOFQm97poofV00TQeUR8Pv1KUyDGsQj+pcYccXRl5AnkEna1m/21IwqiYDSLZ8hnAG0NdCjVjRyQUQxoDTnB+C5A8tZ3f5u0TqON5ksdoZk92UibHXE0BuaYK0+UHoIl/tir12eU+7JUjYkChVFkQyBpL/u9AedzRfvJUWG+UrJWTHa6Zwmxy6FwmVseLjCqXbNmIdE6W+gyMMVf0e1GkE730Yu9jtZ/B+7uR8Zv+hOF3VLes5jL4IFtYdQiI7ARgN+BKRFHv/IOFpB5f21NFR/gjWvPaIu4UAZS2M6qpzkylhsofSMIIcU6wrtPEQ5NPFWWyyLHCu5FnKTyzV4M96n9rz4aPr3f7a04zpqLP6uA85R/yzqJWwVWYw46wWNMwIqDrOFqOgSt6VbWnf23K6s6ADrL9nWsjWWcpKizFbjkU1FaISwtAuCrst/8tVCYeizLswjnZBs+8imdOAnLBKgR3ZAto1ON2rOLG2l0Ce2+B8fEKQ1YC58KlIn930sjz1lFYvzfHek5J88nTQ+cyOBklqyafgZJKYQOctfRygxrspI0TzXkNNj2ICoeCpQHBSudgExOPDe8SUfU7Pt9SsghInIkLOaOXPiJgEgZLr57jcZHjaSixJ/xGy+nARmXw0ng7KVXo9CEGF5ZEYNZg+uG8hRKa2nvurjkzA1lsSCJNvSxdWpzRX5D
 D8YqNIKp
 koGoQxonwW8HMHX0aLVfwS+aPNnafMhRRIwX/ERhqJnpYsE2tPyGDpg23XzgRVvZKhxsyA3u7CyYjqWAuBGOJKDjM8PmSZwkSPYf2/brp7NZrwYzmgmKJPaI0UwDzfuAWBY06HrBkU1/UaSstHgiAh1V6vGBByBkUJRT6KLNZSdUN8wXnjnSvk6ZwNwZAAAUevmTVmdOKBfGCJJpE90JClyelg5POKso2QZKSNLwkjQ4l6DKh8u/vRo8+5aS2/ye2x5/FKGn5rqHjNkl8d5mdG83trftI5hTfsyehsR461HfHwvTkEQ3W8qyZ3qjRKc1/P/nmIkFt6wxQV8Jlg5oWQFr0YVatRK3nRpJey3/0hrmBdVeqgInxxi3zXMBXxI2c4Wy+VRE1cAGUKzMXgM2HqU307CHnvLA0hz8eS9s1lbM956k3xW6hJt8UggNwmlxdvDemkWNl/39/XUI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andy,

On Tue, 2 Sept 2025 at 22:46, Andy Shevchenko <andy.shevchenko@gmail.com> w=
rote:
> On Tue, Sep 2, 2025 at 8:42=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
> > On Tue, Sep 2, 2025 at 4:38=E2=80=AFPM Andy Shevchenko
> > <andriy.shevchenko@intel.com> wrote:
> > > How does this keep (or allow) I=E6=B6=8E generic recovery mechanism t=
o work?
> >
> > What even is the "generic recovery mechanism"? That's the first time
> > I'm hearing this name.
>
> "I=C2=B2C generic recovery mechanism" (I dunno why you put away the I=C2=
=B2C keyword).

Your original email had:

    Content-Type: text/plain; charset=3Diso-8859-1

Bartosz' has:

    Content-Type: text/plain; charset=3D"UTF-8"

Note that the Gmail web interface does show me the Kanji character
instead of the intended "=C2=B2C".

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

