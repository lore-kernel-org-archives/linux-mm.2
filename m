Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F93CC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 09:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE7B8E010A; Tue, 12 Aug 2025 05:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84688E00E5; Tue, 12 Aug 2025 05:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DAD8E010A; Tue, 12 Aug 2025 05:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B03D38E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:17:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 672E4B7310
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:17:16 +0000 (UTC)
X-FDA: 83767551672.23.5CBC9D1
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7F528C0004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:17:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=etPHxHBU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754990234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FH40Q72Hlv1Q+FKRAVO0gIDPDVp0pGWeafDOUhL/q28=;
	b=ewai949upBl12wyTpXWhSYdgTpqAG3MZVSGQNEh0gJhN21DB6uZSx3ryZi6jPzCDTeo7q0
	oNBrkcNoLs/4mV4XpYA8FSe9+A0kC+l1rB3UN/nJC51/jCba1P2x5eJca8cG/dotUu7NVl
	hYnEwiI1I7HyE6/eOpBXne9gh3srngs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754990234; a=rsa-sha256;
	cv=none;
	b=HIOLZ++jaDUtMjEIWIflofDBnGcS6xNn+rQ94QwuX4rEJBrSGsiZq0ce01T2S1Q/Qt2kDR
	gMKNTNgzMcOnfApINN9Pjt9wdCgIQOQ5vEMIw8ke2VO2e9NsQ4c0lvAT8TBaabWPfBgLYo
	UrqAjfd6/SkGFm4A9aJlIiTnONG1T74=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=etPHxHBU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-33229f67729so46940221fa.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754990232; x=1755595032; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FH40Q72Hlv1Q+FKRAVO0gIDPDVp0pGWeafDOUhL/q28=;
        b=etPHxHBUk+yf0s7D8XZyrfWJSdDgX4hJkPqtFdkXhWy3fqwERPnLMwwrY+hybL+yKw
         vbM3pTqwlltDF5JMV6kcJBwNq4rJyzsoYSJnfa8HOYrpU+KFjMBI5NN58U/IJwfXryMd
         vwCtaWSYWFLc/JR/Y6WFhizBj6o8Jrim9OK1wgM/OTlq/ZzIQmHs/ahu9jQ+SGQmBfHF
         AI4LiOUTr3mKXFMSUWoooPnUU4goJwQkmSRnblc/j5IgbdvcyJkR9BrrM7t72E1HPEq+
         2i6Ddtskd94q1G0qLlZSpNrUgwjYr7EkKI6FPR/kgWdrQYYyov4E+rIDipg1qq9EGLrY
         biHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754990232; x=1755595032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FH40Q72Hlv1Q+FKRAVO0gIDPDVp0pGWeafDOUhL/q28=;
        b=H2bvQsygOwpBh1OyCYeXXMq4tOfMuB9ScGcRIvii6Pj2FFK3FWqnUx1ZoW1MgELwNF
         dZqZmIc22bvOk9y2/jpamrC8fW4n7OmSLTynC4qlok620HDYeOq0xikdJpNt8r3vzxxE
         mSuKEllj1etjRACGbYveXcLJGGPFNVkyQ78oiSQWAp7A1wLO4wqNUOOmA9OmMb9PuemA
         wP4+iJApYZYSYJuLUZqIMqSoI0GeTmedyeiP09JkCEPcEZ1AuUrkmeFlNpcYEaGJF6Y0
         7dXKzJY47Q1U5XwvkVW/ZjQ30fAV3buUyTXb63i9w4Z1J9VJ6Jm7kO7hUOh0EwCaHAKd
         7Z+g==
X-Forwarded-Encrypted: i=1; AJvYcCXCWz6yPuvUKlX+S/g1jdcO5nqIn4LY3z4Pepews9F/RWzS6LE7VqUC9+12AYWufvIuQjgRQX0qEw==@kvack.org
X-Gm-Message-State: AOJu0YyfIvUi2b2woUnhwZN/5EWfj1VlfADFlzB3T8M9Mm9jU21pidks
	J51rltLzWzVm8XXnd8Y895w+SHBpDRByfxexp0w/54/bZNV2gfMq5abMwGufzKc90PmBPt3mawR
	JdWn6iXiOSb+bt4ERJNjfxgXsQNoDb00=
X-Gm-Gg: ASbGncsGlDrFG7A4p771F5YTxt5Ge5pttHeXm5dxjxk4rWDxCVrctEvZZBpHnUKw875
	bc3KOiffNXDrS5NAchLh5W50A1O1BQfyGQtp7kvghUmDwynf4tr9Si8k2QUyygxU8jsbDWtu338
	seLelxDBtpO9fax5nHs5NacCLmeg80axRGIBsqQiFyoRnwo9D9ABdLNo0fOxxsIpNbntQ5AoUbj
	e5NXWKU7w==
X-Google-Smtp-Source: AGHT+IEhcflI5Ydaa1GuiuNmpjFNx5ppiNgejnDAuoNiBIEGufTrSOsbJvRUoZYThN0W3IOGq2XThl67s2szsla47bM=
X-Received: by 2002:a2e:a7c1:0:b0:32b:59d1:7ef3 with SMTP id
 38308e7fff4ca-333d7d29e55mr7575061fa.35.1754990232270; Tue, 12 Aug 2025
 02:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org> <20250812-pinctrl-gpio-pinfuncs-v4-1-bb3906c55e64@linaro.org>
In-Reply-To: <20250812-pinctrl-gpio-pinfuncs-v4-1-bb3906c55e64@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 12 Aug 2025 11:16:35 +0200
X-Gm-Features: Ac12FXxOADkY0Kt68GjCLZnzoIn9ZUx9AbefjcCXbQIHx05RgPhrrqXj4qTh3Ik
Message-ID: <CAHp75VecVi9XZ25_qY3vX97xbDndPT+O8z=+V=Jocv_8yOQ=4A@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] devres: provide devm_kmemdup_const()
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
	Danilo Krummrich <dakr@kernel.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kkprsfkoo5y91duefuwha9qjaiu8rumw
X-Rspamd-Queue-Id: 7F528C0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754990234-833862
X-HE-Meta: U2FsdGVkX182Q8lYsXao9x+nWf9I24eT1xXtT71ggxGEPNaMHx2UuNjSNsKgzDBu0hZNs0hj9pSrFdgcSIeQALAeDIj/OyEV0wsRrDr+fZfwhWpQkYoAlH+eJmhfnkjjOpQN2P7ZP1Pjjeu7QmNGcM/dh2fqzOwZJ2tR0XNY3k/owtAZ85dQaRz3GGWyCswy1QyzK/LJgaVRpCyd2aaVOFoYEv6mWYyrmSupyyV6X58qtOthIRsaZWhup0dju+Dp7LmGfabv3uwJ85azlROAq9gBd8l8CkH3VVT3e2Lzqa0Im1kpshtVf0PJnoYz05Vy5K7y2weQr2LzRLeUlAaXoW6RiyxEvtPnz3YGLZ42c59LgUWFfMF0jI8R6uDuyLLu65bBTJ9DGbTdcTabj6Pm1cSVRU1L8z5t+FTBHCpnIoRD6Qh1XSgqvlyn5tDG7IJKfFeZFt+xz5+1qlpl624D2KW9I1pQA7/W6ItbqYsTkC5yFR9IsHP262yEGuIseUilNQpn75qprjh+pQJwoJCjEaVoGnKRpVvkMnbB74YnYwfls/qRSjMpPVquZv5TlJaCvch9DFhygrK3ky6mVeExc//+EErGUrvTjfoTKVj3Bwco6MO5SFLwnw1nDK+XMh7hLwn79JvBSPTSHoC+Yw/KP/WzAVfI1y/ZC7zeUX8MK1DPay75yjYYgM8g/TGrMYKawK7qsPpcMFCQ5wrXqeKqcCCh2OS+YJSKx84sm2XASBJ9Iz8qbBGWdjI1WLbtjEHOzov2RCDHHAj/TlGwFFjduCVM1cVM/W8pmWvrKWgr9o7nq4qUVhqudrBqpXLyFlkKLpNgeTrOr+kvMYAitpXIzj21/YxiMQ6K+mTRfaSECzoiljfY3ZRs6cFXNgk3savS04z7wEGdOv36eJPOfH624ZtPq/6Q5snDDMsufsEcvVOWC1VHyMnAW4z7phl/0aGvkAAfMi5UUsBLHf7e1eq
 iM35efQw
 Y1G98hfAvFhT2gA8zEJsX5kFanDHewhV5n0TK4O6b3I5kYLVKZngJsvNcMWWdLIkYz3xFxgLRNq3czG825sewJfUaDWxBG+tQihQPUqq95OYIShnwIQpLeufimNuPTLr6ttZHlwMFpFaxSQ7HEyPZtXt5WwXDFI5Xpp2ImP1+jG+kNInnnm+gqPw2AdEM3XHch0IbQRfLvUn08MUrLnrEwHCNbpH5sloRByNN0B9o2PC5vVseKCexnAOmpVAijVCx8w9c+F/xy5euZMByeWnRLXhW9fFRdfqXK6IAbgoWjyX3uUyXYb40Xh8uzNFLgnKoGoxFDUWYuHiPYh/eQVuBe7aQvvAez5TURnCbHw/7S/wBjPTNNYN3k3BsFFHUBcgZDKNklC28L/fr8+BtGL75EcdMlIhXjtuFZ5QrVwF425nkKxuDEMrlyBMlVBYybjfqLMS6DYDz5pXyqs5BZambnh5ncDDDE0f54nZ/aCVOiQsdPkf49b1s2WyG2/nyFCzLBeMi+zIhzd/VOi0qaWN+odULSRhyQwzvmyARjdxV5AiSR5IVurScaqfwTwSqvFZ+ezxPhm73OdqpGUOGe7eoluMxNRuNW+hZWvquVI0PH8ynWGnzhmAoU0L5Bl0uZ6ZFeHro
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 10:27=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
>
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> Provide a function similar to devm_strdup_const() but for copying blocks
> of memory that are likely to be placed in .rodata.

Reviewed-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko

