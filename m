Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B85BCA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F5F8E0011; Tue,  2 Sep 2025 13:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FFD88E0003; Tue,  2 Sep 2025 13:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7D18E0011; Tue,  2 Sep 2025 13:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38C2B8E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:42:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D131716032B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:42:01 +0000 (UTC)
X-FDA: 83845028442.12.942CED7
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB053C000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:41:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="tZ2j/QiM"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756834920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HY/P1wmmQ5CXIAhE0M3q1QG3EUDBLGeGAVW5/TOHSa0=;
	b=3Ay5VMunuDTY0bOWwlMKPuj8Y/XWHMBxx/MQF0hhAG4G3E7R/DgCDgFWNjxuz08Kujot9l
	UHg/R/HUBZN+CJBnqNeesVXXnpTqloFkPTOfmlE5fv2CCaNfEhX0d9PJlsUW3mNv41xhWI
	/2usYVzIUSePn13i9M0PX9xc/9uGLVk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="tZ2j/QiM";
	spf=none (imf22.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.43) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756834920; a=rsa-sha256;
	cv=none;
	b=kicmMZLGSjgTmoT2P07eWKT16hIoG9QJ/TYSZA31RPe6uwdKg5+SgvOMhbvd5pkCp63522
	DBAMXUydfVdJB2ZHrNtYwP2xWYr6snCdA+TE+2XC+0a50kup3v4bIUVI0IvpraYSDFdjaR
	9+GCvs/QhLolrHI+9gD1KWYoyFmYncE=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55f76454f69so2601871e87.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 10:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756834918; x=1757439718; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HY/P1wmmQ5CXIAhE0M3q1QG3EUDBLGeGAVW5/TOHSa0=;
        b=tZ2j/QiM+F+un91cTFQuvVAtr7HnJLLkdqeiK0iGHGJNXiN8A1kmqTiHhvAkDQp+77
         tCNOXR0jlcWQY8DHWL+lWrvjoP+GVxAJJI9FTdwoaonm+C8/Jb4MR7/HAmq+MdAljw2W
         TlRCzHXrK0XfKstaAqPWseuO9/+MwdfFPxVVIU2GcpxeZ10suq9EqiYI//htNuwSCZen
         VcEbl79RuyZ5PbhLQPrnnDkakpUZU+88BkAqzTESCVKoeOEqnNKKBhSbleiNFbgTtUh5
         m8yz/SHVCeEpRF/lnQHoFRZ6o1Fga3++FMqx1RjRSFnP3yVLXmobw2fIw10+TXLW4Ls2
         DGTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756834918; x=1757439718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HY/P1wmmQ5CXIAhE0M3q1QG3EUDBLGeGAVW5/TOHSa0=;
        b=KDgr72X0BbSRj1kJzbvC4QLlstzq0dv7BIJqyWX8e5Zno3XRHkfKI08LmBM8z+l6hL
         qAwCYDz09RNQBxkFp06Op0hluMFl/8ZSh47jAR4SCkEilJDHB9fwKjgmeT4Rw5v6HZpI
         u8UE/Lcujy8a4o2La8H235cgSHoP4mIZo6YZ2IeZ/wMDuXx6H0BVZbzvnKFRs3cchwtq
         fGuemBLvxJ7aeUe7v1kMajCF1w402ggFFWR4Uo01AZGqfFkxXVtZtANfVYn5XgY43paG
         E/CKLeija3Gs/bMwzmNygm/vhh5QoBQySm0TH2+nZ5L/8IBUL1g2S80EX36IBSFmv2pQ
         Nqgg==
X-Forwarded-Encrypted: i=1; AJvYcCWgfQAoCnT1UwTFrNjkjNmcYOyZXYN5cQJCjX+TjBbv78vyKgOzEVXjyvBN7Tkzdm8vMgZNQT7YQA==@kvack.org
X-Gm-Message-State: AOJu0YwmHqIpW11ZhuxV6btrKfdtDmNKNvO8CDcRjDEHkYlOYQn/wDf5
	NTaKio0kxtEX6N0lHO6CwOzcGqNmca+cRZr4JC9dcQ/uAD4unSt2abms1XLmYOxlLk4iE5czr2y
	QXyewAgoCox+QvKMT/93FUpeGYuEVDqBCrrJ0Thr9og==
X-Gm-Gg: ASbGnctbRbOK9DxRaNTq5DnLabMopc+iYXoiTXNAhBFMgPB/RIkH7PN7ZqqbJtI7sKF
	mWcvIV3CS7JOsu/U5Imn3VnSO0OiwRcp0n473TDd+9fdIet/wdrRQsyN8y/48YRrGtqZ9fUDWL1
	hWfHCZoLbE93cKafvtRw/4PLVQuSwizZw5wkONVBAd+/FtyIaI3vCJp2O8nMqz1jr4pDSiOA41R
	8FNPT6PYcYFtax36pVauTDtZCaPekAVS9iOwO4PKm+amgji5w==
X-Google-Smtp-Source: AGHT+IEj8d7P3cFn9WHSMlcQJco2rutroHWRWEZV/BsdBzW10JlelDxpX/d5bcqoiRzS4+dxD5+bg22V2Ltijnn3kOg=
X-Received: by 2002:a05:6512:61d5:20b0:55f:727d:408c with SMTP id
 2adb3069b0e04-55f727d46c3mr3142298e87.50.1756834918139; Tue, 02 Sep 2025
 10:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org> <aLcBcjvMbrxoDYoC@smile.fi.intel.com>
In-Reply-To: <aLcBcjvMbrxoDYoC@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 2 Sep 2025 19:41:47 +0200
X-Gm-Features: Ac12FXz-Ict8QGMZawDnah9byaE6SYSj17yQF92en6o4smsRWpZmv8sya_ULoRc
Message-ID: <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
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
X-Rspamd-Queue-Id: DB053C000C
X-Rspam-User: 
X-Stat-Signature: usqxgh9yi9epk1wby1ja7bynghjpzpz9
X-Rspamd-Server: rspam09
X-HE-Tag: 1756834919-105968
X-HE-Meta: U2FsdGVkX19pjUHWnFXyguSlWd3f1aXWrkCR/vgKEtnwr6xYBo/eHvjbXExJc14SSAS1vdOxDG6vp2lVOtMTGSDjK26HUAALBa/07YeojKK3TQ0+KlqKQWTjEDlGJRH/T2xkITmB2852AluhiigKi+WfwOuen4cJgYpfJSja38XIn6sArueYHbInoVlLbkBkaqhrgD2fMwbhl/u55e51IwUeWbdv55HGXPB94hEeFwH0dk9pIjgk2p4R7YqS2hcIOe9U+d6bb29rpM99+EZXk303cE9ZUdrAynZrpjt6zVZr3SBVJWK2chJLXa2wnCGfd/ryHhMvtV2MMxp1zBZ4gtjZRhTy89LPj0wxJkHk29dmVi3BhFHfD8wHVSyu3jKORwKvrBrfFA5abkKHbPWmYeevZpi4+k8LyO4rjcKoye3CgsfZEBXmXF26JT5vZ3YcFQnoquq+4ziI7A9UJUDfgwyQzqUCKCs3VAL/f9Ffx+81+9IbvauVNmAaXWgqHie3o7LNQF+axfIsEVFpEgqI8NWrTkN0JDasdGOtFiQ0PTVbVcdxG5MTa6OUGv5zpVzTfDKbvW7eDytbrokI9ybFZ+a62RbeatNqQoeLl88Yg2C3LlOz9X0jKj6/BV2caXclqiZbgaNnfY3tZkD2V1gqhhPDMD5hS4U40a/Sad+BKxvKcjPCWlkrmQhYuDBPY4HEV7UJaWilkeYrXIZKb3Zwtgm3/0TNe5fL9mKQutShM/OxCGNK05G53Qq824WHQ5g99DBergDagYBT1MGfAozEhJLh/sP9VJBqv+Vmv74NqTO7Cio4kiy3USj17xcX1pJy+LcQ1Jp75PoxhXNyFHTP3bwm+RoPxfCLMjDLQUbg9zpLrKbPqIw8I9h/Rg1y+mA04hbZIM0AQjgeNRZl+cnAZY85Hr33Iv2SN2HivpIGpAHfqYkIYSC2d3X5tc00hsx1Mv9u2Qf1daevTNEq+Z0
 7X+EnWbX
 BPfLxIGN7lQq4oP4alVAGSYgFchswVuXZVvynEDoEWGCXxPngjm0i2z9R1YHEG48fMmm5qzSjv4Ejlp9djBAgwOrGDmsRuFujiBoYnKyv4J29Gl3OuoUryBIwmI8ZiQA+iuMhLO00a8PWrUOAddCXdwFCWHAfSEXm3nSTapj24oUfnERlhMvVYEDWw2lme25lkZ9wqTirve0s7+mvYz071Pa4QyZyCUvln6ghpB+RbdKeHwRbUneK6esiLOAZwD3uuDGCxw1r1CWheZ/N14hJXDNeajR26R8ZWjJQJ7Z3eyOKqYq1yGYVEZXSIj8O+G357saO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 4:38=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > The strict flag in struct pinmux_ops disallows the usage of the same pi=
n
> > as a GPIO and for another function. Without it, a rouge user-space
> > process with enough privileges (or even a buggy driver) can request a
> > used pin as GPIO and drive it, potentially confusing devices or even
> > crashing the system. Set it globally for all pinctrl-msm users.
>
> How does this keep (or allow) I=E6=B6=8E generic recovery mechanism to wo=
rk?
>

What even is the "generic recovery mechanism"? That's the first time
I'm hearing this name.

Bartosz

