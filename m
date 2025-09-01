Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D25EACA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C2A8E0035; Mon,  1 Sep 2025 09:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC4D8E000C; Mon,  1 Sep 2025 09:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BBC58E0035; Mon,  1 Sep 2025 09:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 070398E000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:21:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DB2111A3A7
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:20:59 +0000 (UTC)
X-FDA: 83840741838.27.ADA9766
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7100840005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:20:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=VzXFRxOj
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756732857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ApJifxHePLgmXB9tTWAWedH0XfL5fOO8paxsOA3xkw=;
	b=UXm9oASInLwciqHXkdw5QWkoWBFylVktLGzq5FlvJdM+qzZxC36aqCmicfj8V8mFb4RmKf
	hvpiVE8vxFeWeZDbhNkOtKI9PqCRq8zVDLm8MvkffzEbRK5L3sjKVNJU8S+fRQiys9ylOk
	prQpjmhPOMXaj4gtOqIB0ZKfu9D9TIY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=VzXFRxOj;
	spf=none (imf04.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.41) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756732857; a=rsa-sha256;
	cv=none;
	b=w+AiFUULqvdlwwCNtO/zF5/53mifqaWu3m8OVrRjk1JbSJu4TfGDdsIy1syfSGYf6oHF03
	vI79syFh5c3gxo3mpdp8I8A8S8Ht+Uy4bukodiVEToW9tSW8y6srK1+sp2KIuzc3bRP3j+
	ClUbIOenSc6YxEHGT4b/gVjLgANno4s=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55f7ab2a84eso1089914e87.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756732855; x=1757337655; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ApJifxHePLgmXB9tTWAWedH0XfL5fOO8paxsOA3xkw=;
        b=VzXFRxOjnXJZ/dCZZ3Yrq8hH39juKTnwVjkKWZ9t4l9EwP08IIkG9JWKHMmM4gCueR
         QIIdwCXfH2UHA9iL83c/1Ov0s7oJENWcqFYo00+JBdWdaH9q6q9WTe+8laUaRWKeZ2Pf
         K1OefPoZ7OOvN0oZc8wJq8qttE1g9ImfCvSS7dhCgFbG6P6Yjyh092GvqYop6WdoukUZ
         5bu59+DCYijSNEhjfXR3SSoUAZWKTdyvzkPiOWfkGJrB/h4Uv/o3ew4S6NLukwK1H428
         TJSQaRa8vDaGcQb40rOBiSsW0haOebZJu91TREXfMttGOxARGUjg6hRppJ54WwyyaVJw
         rP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756732855; x=1757337655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ApJifxHePLgmXB9tTWAWedH0XfL5fOO8paxsOA3xkw=;
        b=DdPemey1OnOtWbPHVPzOfaiiZeqPA+gblmpDJP6Ry2nxuydR/fhAuzOJ1kJT2cExXc
         LULZlMNKBM4eyA0TjXGGi0FfCeM6qFc+G0csNLY5BaMAAglM2ejcta+Pj0ftwUO7FROt
         CpsKTS5JGyLj1WNrNNF7LkkWm5g9g5cDw/go/U0NLSs4FG/51dJU2mR+3vwjoWx0zpHs
         4apCIaam9Vk7Wrkna/ZMwN8NWsJIyErTaZRXadZ2x0gPOxFAppESp7dAwCLWu2kM11mo
         Ff6Fa58N9plf+QQd74Sl8Brap1m7WxljwRyqkEkBmT9ilevupciEzPFT5ZA+8Wm5yX+c
         m1DA==
X-Forwarded-Encrypted: i=1; AJvYcCX/UbwY2CyhQAKpcaECwfeIf0zPtg5l0bTuKFJ9ZVzN9aAOCcUJxs7iPMDKK2dtQIed3BXJh45kmw==@kvack.org
X-Gm-Message-State: AOJu0YwelQqtGIVtmoq9gwgeHCrN8lHE6EoJK2O5s796ETFVRL72hkcO
	JJu+Wj+St71uQ5cLsY2uiN0VXP/L/uaQtsXg1H/gyKQ6zUSJ5LlqrYNxBoXXOMeHTTR4FjN9o4z
	jAc6Y3FBFRk/jv00Z+MrrSqNWXpTV13oorWSS+3W2bA==
X-Gm-Gg: ASbGncuuv3eQqMYHywKHdBjpqqnwFQbTFXj23b85u4nXJpw4lFncYaANknVpflwk5no
	uKxE2unEir3xWJKRx6MnhwXx/WDTQ/LB6CbaSFTYUocr/bhJupMDpK1e9UKAbdbKcLdtm70Hlvl
	xfKDEE/7fzKErAtwVxqv9bBHC9DIBt+4KKM2PRRdiKsacVTqCA2mzPpusf4bcPgBayg/4Xd+/Fd
	7FkxEb7p1+JhZhtYYNId0XLfASXhv71y69jeXc=
X-Google-Smtp-Source: AGHT+IH912XrSXzjBk2qT9512Zc2BnDvh2hCyUh1tIL/e/b5XAWzm9U6VOUb2k8kMnjWcaLf9C4w4UWLuNtsABXzYyY=
X-Received: by 2002:a05:6512:2513:b0:55f:4016:ad2b with SMTP id
 2adb3069b0e04-55f708eae52mr2361617e87.30.1756732855435; Mon, 01 Sep 2025
 06:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
 <20250828-pinctrl-gpio-pinfuncs-v6-6-c9abb6bdb689@linaro.org> <61bad868-d976-4f49-805c-8d14d4d8b3e4@sirena.org.uk>
In-Reply-To: <61bad868-d976-4f49-805c-8d14d4d8b3e4@sirena.org.uk>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 1 Sep 2025 15:20:44 +0200
X-Gm-Features: Ac12FXxw4k3UY5TBARAefSnKyhMDuDCBaUNs2qyNKYW8yrbkHP8etuyQPhIAuGM
Message-ID: <CAMRc=MfB_3e0sjCpV+XaKcKvit7Opk5LczH2wsxO=RftrAabjg@mail.gmail.com>
Subject: Re: [PATCH v6 06/15] pinctrl: imx: don't access the pin function
 radix tree directly
To: Mark Brown <broonie@kernel.org>
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
	Danilo Krummrich <dakr@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, linux-gpio@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, imx@lists.linux.dev, linux-omap@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p8o647niyb4o3uwb6pek6p9175p7ur6t
X-Rspam-User: 
X-Rspamd-Queue-Id: 7100840005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756732857-978416
X-HE-Meta: U2FsdGVkX19srtutR6yJsMXPQAiY9bePRCBvoAJfQ2aMxTXsMnWsmvouSlvC2yAjpdfdkVDVuyjiHqSy8D50Q22VTMLGSPIsTkQwgrKo6mlHM/uHacwLPzesnw5DXsEDstaj/m5MkPh+zNY+d/W+nIHtyz1l1sQrH4pWNc3ERvU/Qp6fAQUtktb53weWM8h0JPoeOkKyOMdTyLFT1eN5VoRKt3Hco003AfyhbY/MJZ+1/jCQvJ+8ZH6ka5Ff7/jYZSBcj80zYLgOZD9MktZ8Yi/Va1XxZm1hbmgs2zzv0WAsHNXtmctoH0klsnyZdoK15oivvbGLK6Xkf2NDwIC9d5iHptzYs9n5rzHYMNBB9CVybKP7lUuJRW5UYK7k4/E7H63/7oxm75aRNUyhiTFele9WWxwzA0LDi9tVR6eNIaq01NV6cSewzFVUgPfzV+wUvsbcNU7+10KBF01HZWomdhDdV4FYrTB3a3yWVQIvhNQnpXxRK7ssLVVgwkEaDA2jNX86+Ce74F2b0F7foXeoqzk4I1xkpBX5LAxn0OpXexx3vnPjsYeVszXcRy9bB+P1Zp+heqlf0QJA2gR61kHcGY2Z3l6zRcRED3vabL4uQRbh5u9UgvIyAJ0C1XtuK0HJeKG6y9+9t4wDVFY2UKF5cCb2CtjcmJDspTvr2Lv7zkSfEb3bf/wU4THshFlJ0uF2py9KC+7zuNss/sdf6tO5B8PScjRP9jfDLTTzsqALdex1FkgiuArE7ZxfyQDBmZHILOAFep/KIecS8j19l0/W1YS3D52SXGxoDqAkRwOFDCTEjNwyBI9uv4trCsMEplEVbjrggejGp2oGvfk8EUgoXqBt2P8FzYe0d1qdAlNmYORclzhWeRUUXO1GtfUA2RW8Dy69uiBZmheTOtEQWC038ff360IoLdLAPoLS8IkcQwxnrNymagAeaJWavbWHi5xwvyqnZjKDHBhRj0yqvmO
 VASt1sK1
 GZFh7IxMRWvPSXx3VR0+Z5BpjRfMCY5/U7ybaZTF5I+Movceto5/LaGbZe2a67AzF4+AH/GUOv0+M00+pUdAUORcvkZxs87dmdYYdemaEBqmdHhfJ+hLI1JptoKOkFjxC2GLXYT9PRd/Gk0rhBJKwPsvZtllX8gQJEnn5SOcpIsSSjSFStGaUXFFR6TNtLIux4bPB3ql7mFnctlyN4Kz4G/CzE929NwKyphUCn+JNUfhEMBYuef2i4y5fmomDs5SlQtWsM6wvzTqxAOBaJ4mTEHT7pXr1DTsyTjhC7VpvXnO5b3J6ZtTW7xXZHJStaNwlp18tOPzSY1g8sj6YGy4bBZ2VnH0T9WVOrTFdFHIfoziTq4L+b3SSdhf/csvngAdEqyei40USloIOAgIm95Z6frj75M1YInLpu/H5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 2:07=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Thu, Aug 28, 2025 at 06:00:14PM +0200, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > The radix tree containing pin function descriptors should not be
> > accessed directly by drivers. There are dedicated functions for it. I
> > suppose this driver does it so that the memory containing the function
> > description is not duplicated but we're going to address that shortly s=
o
> > convert it to using generic pinctrl APIs.
>
> This is still failing for me:
>
> [    0.628221] Unable to handle kernel NULL pointer dereference at virtua=
l address 0000000000000000
> [    0.636506] Mem abort info:
>
> ...
>
> [    0.801855]  __pi_strcmp+0x20/0x140 (P)
> [    0.805704]  pinmux_generic_add_pinfunction+0x28/0xe0
> [    0.810777]  imx_pinctrl_parse_functions.isra.0+0xf8/0x4a0
> [    0.816289]  imx_pinctrl_probe+0x404/0x520
>
> Full log:
>
>    https://lava.sirena.org.uk/scheduler/job/1758025#L704

That's not a lot of info but it fails in strcmp() which - I suppose -
is the one in pinmux_func_name_to_selector(). Any chance you could
check what the value of np->name is in imx_pinctrl_parse_functions()?
Is it NULL for some reason?

Bart

