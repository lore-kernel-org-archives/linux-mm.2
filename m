Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86E3CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 08:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8328E0002; Sat, 30 Aug 2025 04:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAC18E0001; Sat, 30 Aug 2025 04:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1778E0002; Sat, 30 Aug 2025 04:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2B6C8E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:05:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EA7D11A034
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:05:17 +0000 (UTC)
X-FDA: 83832688674.08.CE0C245
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id A67ED140008
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:05:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUpvQcp6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756541115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+3FytFWpN13QNaZlIP9PT23YkoDdof1b13hg+sNa10=;
	b=Zrnqxwpcx2wU6iBOCyxWpR9UwK/uvFz0720qP2SicUxKoVomofHTeqT1hsQUIVFII3Ik6f
	YKmtkJO4sGh/GqgVe1YVBjGcHfr1kBd8Qr85TTWZVXrL25wlrt2TqOHPBlQv2V94wmm1Qa
	aYSgwhNvov9d8iua33cAwzmudil0g4g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUpvQcp6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756541115; a=rsa-sha256;
	cv=none;
	b=scyF3YmrMK+VDb1jz66qzBk+VgJCs/sL6k/H415Qfq+yoQ3HA7WAja3zkhFLVMY9zmaf/j
	8711oNqMryJw2ulmNn/AhQEhklNFWNcq+HnKqxPmX2TSib/43dVAIaHfxv0jZFtFQO8v5p
	KszWfcx9TDZWK19w8JyOJaLm4+BBinc=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afee6037847so426611266b.1
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756541114; x=1757145914; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+3FytFWpN13QNaZlIP9PT23YkoDdof1b13hg+sNa10=;
        b=AUpvQcp6aXzwnudy+YPOgu9xQHZhG2AGa/09Vqy8fxUjm3QA+fBhB08oFk3ZxjohBi
         oGHntMFlX7ZzlJgjzLF+SslRfDcsdZaGuNba//ZFseVc5jussj/Mz4vrUoYGyik3cs+t
         D7wU1bd7IJvAzBoxt6qgyaYHk152NKQ8eEhuls+tWBAL7Th0O7I3nB5+BoSqdihSQ5hI
         eitKMj+vHnlsFQOlTHMlwiHvuJBGI2tD5SNMiFEJsjmTtviznOIPVonMv7ITKfPNma+C
         7sPLOOIC2lOS3LKD4YYu5LPNBJTXjW7AjwMBhiFbSLEIaDtOAAZHi0OsbYZC6WckHGop
         gTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756541114; x=1757145914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E+3FytFWpN13QNaZlIP9PT23YkoDdof1b13hg+sNa10=;
        b=mPn6RUeBjTDOleUmOBEM4mZ8wjjd2cXhe0up1Tonx7Kxm6g0vUoS8YE8FRR9WUexqk
         TFN3OHvAbqpDklKGW0bRAknTNfI3OxUavqviIpMs3eRThG3OQjb8oyCus+V13EQLgbak
         h0vj1zVZNEt79g20KvvmCkvRlUmVa4P2Jstwaa2mOj1P4L1+9vNaIZTV4BIkkxloBdg+
         Qu0lbNTlY9I+uQ+f1G+pXyDlla1fC5J/ukvTA4DVXNEr1zOajKbt/mqqhLYqTTLaV3J4
         fSdVpQiKCfirrFEoEhA0hV0zIMz/i2zLhijVv+OaXZWk3SNIpQX0ogt9Fqxqy4pUclJX
         IGHA==
X-Forwarded-Encrypted: i=1; AJvYcCXCUg6p2XyUyLyuThXEjcIFl/IK+8w2wBMTUGYNnkWcvH0Hwb7MFsrIjFbbmfIY4TcQKB2JH4dGEg==@kvack.org
X-Gm-Message-State: AOJu0YzbhE2jP5GZUwCHmsF2TwWFPiyVMWu2ZLu4rZGfo87qBq4M/RK1
	QZMnRODP/T8WzJg2MMzy1ld4bV/xNhTU5pSlEbBkEvZDSy2tNHfZlCjeS9Dl5OmcKMI1uKrjPfh
	cv7pthh3tOlsGyizdOXtgdEEqpSvujEo=
X-Gm-Gg: ASbGncsJd1LjaCxPdEknjT1gsbzBlHag8fBIknF7utwXvaQQOJPYhuSbhWfF0qmtC7a
	T5MpibYpZSYG/PAtKSeOxBdNusT8rROllqBynUZxwIUhiDztfsZAmf7dSFlyoyCZBvPJjXQpa+B
	c9pi6XPIYQFv+zFdhOuVKVd51T7EkRyVR0V09XtWOPl57b4ZaKU6beJ5SJjZI7EF3ULGlvRcJ6d
	BLKoS0=
X-Google-Smtp-Source: AGHT+IGzflFMFHhQCk11BPmcxfewbn8R9ACv8Yo0SSn9TtnTW1JgawjqxVwsmdBQr0ZCbodUJMXZIPy39a0Dt37TD0k=
X-Received: by 2002:a17:907:7244:b0:af9:6e2b:f30c with SMTP id
 a640c23a62f3a-b01d972f530mr112838566b.34.1756541113922; Sat, 30 Aug 2025
 01:05:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org> <20250828-pinctrl-gpio-pinfuncs-v6-4-c9abb6bdb689@linaro.org>
In-Reply-To: <20250828-pinctrl-gpio-pinfuncs-v6-4-c9abb6bdb689@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 30 Aug 2025 11:04:37 +0300
X-Gm-Features: Ac12FXzW7SA_uUOkcPEFLfZfGLYsYzzZVOKlWfYhU6akvDLYnA0W6YgK2rZDIDs
Message-ID: <CAHp75Vci1uAcA9ahofn95hxufa+Yi1Fjt4w74HSObQq-Rz5zMQ@mail.gmail.com>
Subject: Re: [PATCH v6 04/15] pinctrl: mediatek: mt7988: use PINCTRL_PIN_FUNCTION()
To: Bartosz Golaszewski <brgl@bgdev.pl>
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Chen-Yu Tsai <wenst@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A67ED140008
X-Stat-Signature: e9ec88xs137jsyhbjo7toktb4t4p1t6q
X-Rspam-User: 
X-HE-Tag: 1756541115-859187
X-HE-Meta: U2FsdGVkX1/Krdel6Ga9l7QeMlGBsM8vST0yGRIHzxtq22VPS13ld6l4LQMirlq4QBQp2cxs6CUWEmgSEFG3xvAg+xnezBbjVqiuzswS6DgPbQawRC7MqGxmX2UTYBCJ8A7cJS4rS4wE72lkrrqksDl61rq1ODEuAXp8ZIlS01nY4CN/Vt2K1/CvGok+EuhVeBNtFN8wwIE3zeaj1qD0yn8fZaaLi9etHhtJKPVfrqi6OLgNYQnO63rPzBXEu3L+TAwAiUV0Wonpsgu59l0mQ9BfXDe9OqA5OX7DWnPZm2cGTEpiFiS3Oo7pQBY+LfVYJrTicoHn7CzK+UWzNdP2FEyrMktwOW4WR9nKhvTrsyuH+2oFuY5VzuRamgyoYUFX8wZYAqTsS9FE0hXa+oV2FMM4BxkHOjJ3ZX1mBmiR6cKa+e6W5W7QdoNVntFnvwJkpJeRrHNGyxtQFjEaJa7G439dw8S6qLuXmE5jXlYx6TOrHtCvX/VXoF6Sum43yEnspl3ml1aMJSb6Ei+Gp2ZrKuJlw0gcF+7uzENeAnSANf8/5gaCruKrOubiAQpRdY8zwrxOpp8McCfVJXAUAjDJ+k4pK3Fbn9edcZdqrIIOI1/X7gTT1vDf9IuhXnxf2iT4klPLDiALjRVV3SfIFvpz3HXhSAVGsqvK1MgPtQd4+yxH6ioIY0ZqBHFfRCdpPwT+ZvW/5TfuCN8/oIKZJkohIMlo8Dq+lDr7HUT7tv7nZANu6ybSrNabMyt0ndbIBbBHRoTnbh1QtglKu2FSkq3YelPtsvwer5352YIwVHtuhTuHTeACxtpBdkzbETgfguyveWazXmu/A6ltqCSVrQFRmy9mlhkUQhb58abfKYYNGLWmxxWr01D3CfkqluyXAVsQ49u4OwXhFyw4MXz+HQoBU9JKF57aTa2q74PlpudY8wASi6+ZcZVcTO7jqb5jNYPA8HnkZL8KukJeBZSBrqI
 nyPP6abM
 r1OG83MTJ5H3po9Mabcak8bAkR0h1Cl+f1meNr8IPfHuTcNStt7JcQ3+Sob4n961n3af0FfQNHabdhc6QGZyXcvlYC0OKC93q9awItfU1EDMFnr8Pj+9AMG34sYk0ju8TWWEqiijOdVGuut2xPODm7wz6raOmg7D9IWU4A8eS50t3hrroqsZ+qIPR98THXXpXVlwRvg6j/o00LJ0rCPhdFFzWeVU+PCelBx7//2V2HWF3K4ME8gJzI83nz0tqymB2ic0ASGhx+POzKRnImRQEULixZALfMTX5HSCT77gsF/pSXWejElg6Td9O7xXimBcpHN4DUjRmqv8BVQ1PeQJS30LKfHV8lL1LvsrmixduQ9tOltGqG7yKNGN+lCz3u/NWse5SRtgapqU2l71D5yX+5o9zvYA431wmiLmRGoftw89kZW1aCvauwhgwElor8eQM2Dq8VCwCKC0jHZXXpfJjUVrM7AU+ic2g4DYObQYd63WOlOmdMCC2RB4Fp2pE1ki2SuLKfOD9veANlrtP9+vckSMaY3n04/zHxSFTH11VPkzfSMFt2g1DiKoVY1FW93kki77PbeX315HBR5LXaXy9YFbDEHpvb/xF+a4sb0BOsWMDWzNQs18P5TNbvZ2asMAA7cSw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 7:00=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl>=
 wrote:
>
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> We have a dedicated initializer macro for defining pin functions for
> mediatek drivers so use it here.

Reviewed-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko

