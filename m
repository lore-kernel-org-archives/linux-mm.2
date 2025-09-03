Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E184CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94D2F8E0010; Wed,  3 Sep 2025 08:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD508E0001; Wed,  3 Sep 2025 08:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A318E0010; Wed,  3 Sep 2025 08:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 744B78E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:07:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8E8D1DE876
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:07:09 +0000 (UTC)
X-FDA: 83847813378.07.3EAF455
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0283380003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:07:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=xmQXYCiq
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756901228; a=rsa-sha256;
	cv=none;
	b=otFxPDvrbS6Bs60Tm8LonsBM0IEURjjxKPwhFy624l2T1fKXaEVNxuuBU1M1D64zF9b7ik
	231Chk/7CosPebA8a/KnChQe3hz+e1p7E2Jemq3wzaCVpmboq1KOwEMk6kUCHW0xwap1LF
	MaQkdna5ypVSMhkda+BQ9QtIdf5z+tM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=xmQXYCiq;
	dmarc=none;
	spf=none (imf02.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.208.179) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756901228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eo9UJfvaYgRET1kqEn1jPWXs6VN26Af35fGJeuqNMfk=;
	b=CclpPROawe0fYkbEvwNGHS8VHfihf/sgJGSI/+Bt/192i0t3WF+qJPf1IQr9iU/tmnsiZX
	HNPpDopOQ+S0xDz6vFKXP+mCMQ9wagcT3q/SCicN2e7NOa9qEJepyhf4MhxNlKMy5YBWJ2
	pizokE+H0wohVtvuX2EQO2sNZDxp/9E=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-336b5c44a5bso7307511fa.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 05:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756901226; x=1757506026; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eo9UJfvaYgRET1kqEn1jPWXs6VN26Af35fGJeuqNMfk=;
        b=xmQXYCiqlJBAR73ohVqIdsBMEwAXtn9w2vU5GjweSysmGqla/hvxQd7VxaQFrzHbLW
         nuBSLnjnB4nV0IXl/ClsbeIo+FmvRnTnobbJJK2aS1gLxsUADLM0eM+Hwt9MlWMwkxs8
         PxPrTYJ/DouRnMUrDV7T/S92Hc2ZiOdBfIJeYGBnidxjHRtvLd8VsxDjCJzDNBV8kYMw
         YjNAksUZ44FxaGsn2iTHqqdZjNpRgnPC6KODjQ1lEqAJlCvobM3G1DtDzYHtwCB4A7dx
         EbWq83uAtH45JB1opZmvBsewblKjRXmFsJn9yTyFIH1+Ji0jYRZjbCH61QGZyCR6LTFg
         hDFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756901226; x=1757506026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eo9UJfvaYgRET1kqEn1jPWXs6VN26Af35fGJeuqNMfk=;
        b=lCNwfxtB8CUz7kzZwrXgpeOm/LulmMaaAcnqssQxhcpKD4oDvk1vMGbsQz15Ns5xr+
         8lGnSmvexrfZp1J1Vzt1amab3CrHO2693k3tHOMb48/UDOgxjH8T2cdVjl0NPC5bQBL4
         qhewKZq1rLfFQESpB9BD8YbR8g96afDlNtw+rmAA2WXgwI2V2RX01pWPAkRxk332LI3A
         C6yT5u2WSrmIUVu8oHjA4K44BdkwP/UwRrGsalGCPGA8xxB0Yul8hu/DgHJQGahb3VG1
         m5vsu0vVBNRUy4cY76ZPF+ETTDHXK9rpw1ijcywvGuciiic9+s4Wg5Ixz2rkspMLE6zk
         p86Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIm3z+89MGOAl0CtJihhsLRJXutG2P9+le1qGoCK3Jjdd1c/u0MH1ftfUiKfBMJzEVeVYWx/FCNw==@kvack.org
X-Gm-Message-State: AOJu0YxKYIcX6tZu1+Nfop2K6nUnHxBFd8uyGNNqewSSt/15MBpqPKtU
	+UMnUkM5oS7iUsvCvFOjmcnR9y01uukOFyia+NYcfK2cJ04gtsfEhEdp1yiUoZemi7f+s9lgwax
	Mr4tryH7RWoZyc2IYdEUvtR+b2cNr+JUfRMsUxEXdYQ==
X-Gm-Gg: ASbGnctRSQS58KWi9uRXBbvfAPiBDAsv91eh44Pc7E6IQBqNkr9+CdfclYxPwA/R7h8
	9F1owJkTGNtIY4WlT+NIXS0gBUXqlcTg/WU7cKulRxasuaM1fW2eZ3G+T913U8wr0yhXJyuuznP
	bZzREdRxyDRKW2ypApi5WqrMkm9U7dfkyBuI3bQQWN+lzw2C65x+KgwE/dI5b1X1IZMVrMghQuE
	qRj5X/QLGn8edBU11m86IhePqLIX42ljWsrhak=
X-Google-Smtp-Source: AGHT+IFCWFQpsNSj5HbtwgM9MCfjT0JGzQpT+8Q0JOxroU2mp8U3cFtE7ajM8EOI5676CpGuXoSnHTYyKyq5zkghPtU=
X-Received: by 2002:a05:6512:3ca9:b0:55f:6b08:e60 with SMTP id
 2adb3069b0e04-55f6f6aab17mr4829149e87.5.1756901225907; Wed, 03 Sep 2025
 05:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <aLcBcjvMbrxoDYoC@smile.fi.intel.com> <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
 <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
 <aLgW7J-j4nn0u8uo@smile.fi.intel.com> <CAMRc=MdA21fwnamymG6YhqBjKDso_nJs_4xefPNONQNfEcPHXA@mail.gmail.com>
 <aLgaoivmBUgoeO6B@smile.fi.intel.com> <CAMRc=Me84OX=UEmAXxmwE8oOH=1UBsyHe-7XmU0c8a2gG9JnCA@mail.gmail.com>
 <aLgeDNLABpmkShIU@smile.fi.intel.com> <CAMRc=MdD9g4WiBCP0qYGuy5e3pnQf5MUHTqkUOnrUvcWUYK27A@mail.gmail.com>
 <aLgrqZETNLmuMHhv@smile.fi.intel.com>
In-Reply-To: <aLgrqZETNLmuMHhv@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 3 Sep 2025 14:06:54 +0200
X-Gm-Features: Ac12FXx1vWTkfbwcKCR1G15N9111AA5z_ZoC4xZjaCT4bFZgzZIJamSIU5gFH4o
Message-ID: <CAMRc=MeX58XKmxaY1jYCMdy6fQJf7HWMR8f=DQpeovE8APw=og@mail.gmail.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, 
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
X-Rspamd-Queue-Id: 0283380003
X-Stat-Signature: ho8adi4ueafuwhs9tie1f9rpaya6a8or
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756901227-405043
X-HE-Meta: U2FsdGVkX19quYNxigk75Chnw9FzWPqlQaZvaBj/yMWgr9nEYfX4HrcuBxFLvgUQIZdwKDoTSzImbl9p+c5mokSsI5lz72kv2Yc+ZWD4aOkgZd0bdFFTz/UWN49/EeUQpeW7Ab8dPN3AIn06J6NafJZdulV83r0EZEvu6LVTiL2C+XzQGYWeOu/028TQqgyoOwSjmKApkic0+OM6Qm+UjO1hY5gPxMJeBdTGCr+q2cYKOxkAHosuDzgQbKPShKkFsMhsr2hugCgtHqQuodcp7Jgv2is6E+VBT9MahFNomiPBoUF5JhwSMBsccYIHovE6JTqPI0cS35m1P/qIBzl1ycTnxGoANGSRVChwWgyagSIhfa1zxhFxIKTJIz4Dou+fBZ7LtUVPhsxNZs6lUVKNjNzxZSqyntuixf65FhYUWSspYakezrWCGhV9rav0rH7RBJVEYCF7EikgrlQZvgW5uu8XN1z1FY31xyrcl6PtuAJFA4TffUzqYmYCDBs5z9df0pVaRsNTDHBfOM6pZwNG6DjCxqLO0R4Q2KoEBccglNYj55tueG+8frRX90DRMW1hL5nfYNZfbG2OymYJxLwwem/NU2VfCfufFAmnY3RzX3nlooXn6n1RPYKAauErIC21PUo3ucbftHDjanuAJRVFFkblXuoYM1H5IKs9i5A9Hw2sw+tBNNH5t7qz5i0i8oe5Ny6I7aDC1Bgi1wIzUVUkNI1g+ZL4G+mPtVzHttm+ewkTQAYiwFwjlziA4K6yz0VpHkPQTkUp44ZPWhXAUyZ38Cs8SEMMzGh3y1pYllKC4iU5vT/Bx6VT6sCXyZ4PISMIWzR8VN/ua4eCsaTJm+vcTClOXCL2GFX7H390x/hatsKX3dLESYbIIWx2QStV3N3lDfYRDhT9TxeidRpINhbGQQjwzogY090dD7q+9upyTcowcr8cIV7HDzES9PQWDWXJz8I237EEguU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 1:51=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> >
> > I don't see why this would stop these patches though, as they don't
> > break anything unless you decide to make your pin controller strict in
> > which situation you'd need to verify which functions can GPIOs anyway.
>
> It can't anyway, Linus already applied :-)
>

This would be the third time he did it so it's not like it's carved in ston=
e.

I see your point but I think we should cross that bridge when we get
there. Shouldn't be too hard, we already have an entry point:
gpiod_request_user() where we could set an additional flag marking the
descriptor as requested by user-space in which case, when we get to
the relevant pinctrl code, it could check this and refuse based on
whether the descriptor was requested from within the kernel or from
outside.

Bart

