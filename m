Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A41CA0FFE
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 08:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781566B0005; Sat, 30 Aug 2025 04:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7578A6B002D; Sat, 30 Aug 2025 04:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D906B002F; Sat, 30 Aug 2025 04:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 541FE6B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:19:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82814BCA72
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:19:58 +0000 (UTC)
X-FDA: 83832725676.16.BC6304F
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F6E640009
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:19:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kj19wKuo;
	spf=pass (imf11.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756541996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yz+gNr9wnP1FuUv8NASxp4fC8wPUaxLjhsHiXAOzrk=;
	b=2cHSfVyrtgFOm2iZ0en7OwWlUrMvI+pK1LQurZ7ngFeqMnS0+FpIFb+/kC0zCKRkl2wQPV
	jbpBycTPjcBW0meMhgE+swns9kFzvpMySNPJdPnDLuR4MI78M9WmsPtSKv4/x7bMyUzDYP
	fbN2kRAsigER0lfKfOqlnQZUybND5Dg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756541996; a=rsa-sha256;
	cv=none;
	b=3T645vft6ZKP8fqnWOK/qBQ7wVY2oYjgUx3kg4FGsWnJwuA6CPF5tMgEoxW8+Z+BGBlEIr
	7pywN9tjGBK7gPWu4D5R68xA75/ek4kp3fVCU7ncM/fkcn4rKycyfB5LJplFVXvnofyP/a
	VSFe1sxKtBjigB+fy3KKq61blRn040k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kj19wKuo;
	spf=pass (imf11.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afcb732eee6so477203466b.0
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756541995; x=1757146795; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yz+gNr9wnP1FuUv8NASxp4fC8wPUaxLjhsHiXAOzrk=;
        b=Kj19wKuoj0aFqG5mO9z/DCQccf5IHXzKp6MNIfK099fArviS/bp0fLnvWtSkmNXZr6
         WGmYrUhiVH5q0kWi9KVvbu5ZG4gN1gQfZEfT1M5INPbCOiwpn9elmmN/UiZU9ifyj2p6
         FeQhZo+JpVAQAaRmHRYNDqrB42snfAxznmu10bqz0bsJ7XwrGR9wfaYv5zRteHPffNnc
         CdT/nPSnlE4LHyLOmOv6zDr9Egcs3iFwNNzJaoxT+lDx0/IIf15P9fv1ndr79g8zVMnz
         YWbhSm8rPT9u4aQcS5qPwoRHR7rTmOxUTVzVpEzeKsIzIsEcd7xcuGXWRkvlAV52XoZQ
         iEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756541995; x=1757146795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4yz+gNr9wnP1FuUv8NASxp4fC8wPUaxLjhsHiXAOzrk=;
        b=gc1N9x1M2J17Btm78lAazviiLTM6kWzqXqoIKGHdVhl9cTbaMQmTW6R5iiEIgaXp4z
         wOrAUrCPfVfZNljZNyFdjNRTcEeGuwJPq6jRSMyEPpFN8xdHWyeNMNwOEv95BJBZsD1R
         lD2xvAzpihJWwbQsc1ix0pG/ZXf2AMILcrbDRKfjI0JYqnIJN8S1u+es4n2dgKAKkVyr
         +RQouHSvmafYLkdx9Zfzr+5TrswaVPIOmM+cP4yEYFcMyFmAllYiTdKQfsdvAn5Jn7GO
         E1pra5DNHeGszETpd6s/2x0qCt01QTn1yE+eLYogPXo3w945gzZRAZld+5vPP3mIGfPd
         K0nw==
X-Forwarded-Encrypted: i=1; AJvYcCVIoS2EKWrwWk496/CQ01a3+L3qNe/VIMw4YL3Ux469VG2LC80LoXp7dH7YG1sgIg7Va1hg71EvVw==@kvack.org
X-Gm-Message-State: AOJu0Yx0Gtk6RpuFFeRQBz7V3lND5YnB8tQv/eDrjgmQ6J53KIlzDIl+
	MWvCp5tVpQUUAipvZ1n5GBPm6M/1sI62n/vkjX9c6sjy9GbOfNNEQ+YhyxyBs5Fajisc6EUbber
	6/ykoll+In7LPjJKas9CeDK8NH98JjXg=
X-Gm-Gg: ASbGncuCdZyL0BC7V2ScstZYEWSIRPkc6EjWSdYTeng1Kd6wawpQASyNXkMlrJDCbHv
	NxW8p2Ew6OaiZhtMxG2gwDxIY9xZz71vjRn+3S3IAnQFGKHYd0HWonhCEuBR9vK5bvfRSzzRGrk
	rYLJDkU4vedrwwOWrS8YhrbdhiU2ZaiXB7Ya/X+UzaThbyM0CfL7U+HB6paxVAKEvNBp6/KUX4f
	dFGYeIb86iDzt3BuQ==
X-Google-Smtp-Source: AGHT+IFZ0wex4nlRzxOc5BG8ARrUjGz7n83ilxsIj2vkPtuKrq3/+IPw3T+K7YRUGhLq8JMm7BCY/eJH8jBRTGRUUSA=
X-Received: by 2002:a17:907:d88:b0:afe:764d:6b24 with SMTP id
 a640c23a62f3a-b01d8a6a72cmr138313266b.14.1756541994858; Sat, 30 Aug 2025
 01:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
In-Reply-To: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 30 Aug 2025 11:19:18 +0300
X-Gm-Features: Ac12FXwW6CW7deBsm3Aef2wv7I2Olg4IsebLLUGVz2bUvR7gVeqwu6XUXgRk6VE
Message-ID: <CAHp75Vd+q5NZ=4YSouU-EdbR4TZf7S8PGqR0B0HJG8DkVKKtAg@mail.gmail.com>
Subject: Re: [PATCH v6 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Chen-Yu Tsai <wenst@chromium.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F6E640009
X-Stat-Signature: rabnp5kkxmudtrr4d7ha1rwb56ycuibf
X-HE-Tag: 1756541996-254530
X-HE-Meta: U2FsdGVkX19/nPTm1kOlZwR/Sj7GdBemUqkdHlSTCfgDl/f87LTIZWaVmKfSf+yLiMwL5Nu2cmUO2kfG4E3ps++vju+jnInGCevH+A08kWL1BpazEaiFJd2BfxGxOQz75oVSjX4OlpHX74fWEJJIEdXfFqAbzI0cHORIo5+/xYNG2BM3Z3W0qWTYLNr+txLaSRHtaRc9r0kM+u0syhCv0L6N0L48jweKrl5j1DUYg3NknN6FYf/HtlDdHbbIXsD/A6p98lXsqZecVLOyG+nGmAUU1gjA0CJi/AjbNEJ0lKBV4+EA1MIOUwzUL4nxyC6qtvOfbh1WSLhSWfRPlaIBFidX3xbYT3UJ7w6EHlRoCyYcXIi7W/u7rtq+te1smr/M3fR3XZgmNypQ7wwmlOBetu8t9gXgEgf72C3VzEnRKptpPnDEe3m0D5BgYJCy9WAL9/3yq+5c5v/+vG9GyEWAORbTg5+Wre581KStdyi2gyTfme++UNcsU6b5H3umutYGail0ejgvYNgJ8AtkOkcVoyLHAIRRzkxbV9EF1JsJV0mcwBPOyINMv7rDBJRaNGFuu98n3PK7E7CEdpAs8pSgnG3z8VWziv6IqQyoAQ4wN+oLXlJJoaXaXoVU1Mi1JLNZ+5BvWscKPXF1icV/vc4yNvRafFLEbhnJeSpn3siBX0td5ncQwoWxfJxFKxI6MYF7/ilYPmlFBb63k8jgcowCWR9hG9Ty+BYEqSKL24s+GuaY99LuGkJ/wWXh9w5vHLZ3TxEWaytfSBYWJj6/SIuF1EZYoSxTLNFqXw+YaexQyU+B7NthKietcib8LpxMoQNFSRdTOLWVzPG2Zgger6h65T1nOMzq/vpsEvklnIBL/vtlVkTX3pdjxJVYuO4oahN4Qc7i3ylN7FFkPX79fAwibsrEC03g9BpCmi/4pBGm79psJT6sAxZgGwVtoROSjpR+Ymn4SZDJRWrVz+6oPkv
 nXowyxqb
 tZEP1DueTRGJ1yQH+N3W2hNIlRm8s3737zYbcSiwgjV9Z02cCiJQX18updss0wLYKk5eijgMGE+hryPIYrDXEjlVM3QaAF3u+tFoHHrk8Lq79EbVDtynJ2blW9r17lX4RbVPGgTQln0LWK+QIVwBIjIgN6iwgjIldRIaB6ZJWXHC3ufEqpsG2jaANi9dDKPPwQYExGZ8Xix33NRgRqJoLHui5NtDap+3fb5pfeLkZpKA+Y/8+1VIGq0JJxZ1Hc8ICdC42ypxxuR3NT2KdPiQmmIcpeDMnbMDaxesMUozy9nOo46aurVovEWWV+Pd+XxD+fKYmxiBcDDUhznGz/hi1/RPEkcb0CJ3v6egjXXYTr9tTm4gDVm9fIvL9BcXEoIaPQsBwuuga2ObJa956f2JshF9BTRZ4XmAuQlqWiNqwNxp+Sfhllp8GbeWTkwpjAWPE+6tOdoNX3KJLSIvsU09yf7Zkog==
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
> Problem: when pinctrl core binds pins to a consumer device and the
> pinmux ops of the underlying driver are marked as strict, the pin in
> question can no longer be requested as a GPIO using the GPIO descriptor
> API. It will result in the following error:
>
> [    5.095688] sc8280xp-tlmm f100000.pinctrl: pin GPIO_25 already request=
ed by regulator-edp-3p3; cannot claim for f100000.pinctrl:570
> [    5.107822] sc8280xp-tlmm f100000.pinctrl: error -EINVAL: pin-25 (f100=
000.pinctrl:570)
>
> This typically makes sense except when the pins are muxed to a function
> that actually says "GPIO". Of course, the function name is just a string
> so it has no meaning to the pinctrl subsystem.
>
> We have many Qualcomm SoCs (and I can imagine it's a common pattern in
> other platforms as well) where we mux a pin to "gpio" function using the
> `pinctrl-X` property in order to configure bias or drive-strength and
> then access it using the gpiod API. This makes it impossible to mark the
> pin controller module as "strict".
>
> This series proposes to introduce a concept of a sub-category of
> pinfunctions: GPIO functions where the above is not true and the pin
> muxed as a GPIO can still be accessed via the GPIO consumer API even for
> strict pinmuxers.
>
> To that end: we first clean up the drivers that use struct function_desc
> and make them use the smaller struct pinfunction instead - which is the
> correct structure for drivers to describe their pin functions with. We
> also rework pinmux core to not duplicate memory used to store the
> pinfunctions unless they're allocated dynamically.
>
> First: provide the kmemdup_const() helper which only duplicates memory
> if it's not in the .rodata section. Then rework all pinctrl drivers that
> instantiate objects of type struct function_desc as they should only be
> created by pinmux core. Next constify the return value of the accessor
> used to expose these structures to users and finally convert the
> pinfunction object within struct function_desc to a pointer and use
> kmemdup_const() to assign it. With this done proceed to add
> infrastructure for the GPIO pin function category and use it in Qualcomm
> drivers. At the very end: make the Qualcomm pinmuxer strict.

Note mainly for Linus and Bart:
I agree with the patches 1..11, but starting from 12 needs more
discussion. That said, I hope Linus can apply the first 11 ones to
make it easier to continue with the rest.

--=20
With Best Regards,
Andy Shevchenko

