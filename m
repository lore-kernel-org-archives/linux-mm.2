Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1702C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 11:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B6F8E0071; Thu, 24 Jul 2025 07:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6231F8E0051; Thu, 24 Jul 2025 07:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560A08E0071; Thu, 24 Jul 2025 07:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 470608E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:11:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 173F6B8525
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:11:45 +0000 (UTC)
X-FDA: 83698892970.25.60EB5B7
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 21A071C000F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:11:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ktZKirqD;
	spf=pass (imf18.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753355503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1M55MjNHLP2A27D0IMUuTEokYqJMg2OTuUCTRKpy8Hg=;
	b=XtnQ1JLHD+D8V0DjQbLiRvaN0qXmUn/24dObI/WqPWs09DxFYVcV63CSRIZhE7EYVW+THJ
	2AS39AbYMMMGnEZXpQtds0EA0eXhG1ExaPowjwv5wds/peI3xBRiHC5lKyTH2f6X6O8tt7
	bRGlnWwqWIUbmSbfYwTK1JV7WYYxWHA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ktZKirqD;
	spf=pass (imf18.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753355503; a=rsa-sha256;
	cv=none;
	b=RPZr6cucjmvPbbMq/cW27VuRtQhl6g4a/DYqljiZ+i3IdKMxxfoT9TrrSO9UdQzDvlXd6n
	ZBFKaPSo96Gtxd2Sb7c0W8ZXZS4n4kcDWp+pUmN6MZR77/L6NVAZj0cer2jcn5Y7mJOHUJ
	+vX8nIBeJcXyxUcLuxlCSGiRtK1z4/w=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60768f080d8so1690364a12.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753355502; x=1753960302; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1M55MjNHLP2A27D0IMUuTEokYqJMg2OTuUCTRKpy8Hg=;
        b=ktZKirqDNrrYNgyT/cmPluwaLVd62QeMtOB80kuKu/d3qLZpEMv+k5Thvyyma/lY6Q
         bxQArCVVb1XXGG6uubTbvBP5Z5yQ1kM4lydk0HFcgei7DGPNUImG3e7G+w212TgOX0El
         jktAiig7xE7f05WGdYQVV8OfYc7mdoBT1ZSfwcZeNsJVlQAgLAWUrYumiO8XcnXXAIqY
         3W83sbIhqyP7jKTDRIZsi4ylh7fR/MXBpc1KOU1Lb2GBwb9hr/d6g25w1O26tIiXlrKP
         U350NsfRpZtlOzpp61ynwOBWmTPRzVXejsQHpIwUrzMYfY2ysexikRVe9+EXTrtRbCW2
         OVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753355502; x=1753960302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1M55MjNHLP2A27D0IMUuTEokYqJMg2OTuUCTRKpy8Hg=;
        b=a2LweGk4o9+lXEWPNzNyVMYMk6H0Ng5Ju86XZ1lH2pw6aw3QpEmski9p0ovxZaLPki
         nZh5LVek7FxRvT0cdFQ3j15TpgC8T2ehQ67NoExGr/6bIoKG1NlYYsTRl9zbf+S59qJN
         YLN4UfDnReoftPG8gW2CzyTk6UmVXK1WcqZXm9UVaDvNLAlEDlzeY0dpIHKBHuD8zqyj
         PT1cwmsg9asTDRMD/tzvMkOOigcEXHCg8pq518I1m0VgpGyuE5wU4Omd8lV0fI6n6+f/
         pMY5gIG/4LFwkvgVVd/lsiIdDm+63OJOXDjnlasR7I0A3Peqv7PRyfm1OmnbTRZl4gXv
         L8Rg==
X-Forwarded-Encrypted: i=1; AJvYcCUAUrWCPuv8DaZ9EjX9Wy6k6YW3T/LDc/Z6sVQdL8rurUBxFx8M9lsAFBMPFu2a98svQbtx6/XTRg==@kvack.org
X-Gm-Message-State: AOJu0Yw7gZAM1OfC52eYexAC9AhuwgvozoTQSCoUchY82QkcSt2Ci64J
	OnBwtCZRhqMlEWrY7yX+ZZGi7ubnztIwUf5y+PXT8mghIVB+tK2gZbKJxvs2WGiBhtn52G0j5GY
	AdQfmnBpdW7POtx6wVAs7GPGfu8hkFes=
X-Gm-Gg: ASbGnct3b0gC85R1YaPGRMacxhwKjwKv19BmXHl3PpcQa2ty5/R1TgpmjKDEP22u806
	yFcezp/QkDSzPlsTtMwFVH+/lmylijELXM1BxV0nbwvlaCZ+reYs77kZlfAMSoiKBnIpQ0OzZD7
	cX1dRKxVbRxzCY+DdpMKPspUMXnC4IucilKRtKYO6QQqshVriGTpZkpqr9md8XBGCvfoI0jvb6N
	nEVvPP5PQ==
X-Google-Smtp-Source: AGHT+IGQZoX+LT1IzNpJkxMjSxSTE0HFrqyLNxJY+NiaWstSlkBVLBDC3jnocxQOgR/J/b6wSO0Ggtf4mqZ5QLUuoio=
X-Received: by 2002:a17:907:724a:b0:ae3:6068:235f with SMTP id
 a640c23a62f3a-af2f8d4a15amr677213666b.48.1753355501419; Thu, 24 Jul 2025
 04:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org> <20250724-pinctrl-gpio-pinfuncs-v3-8-af4db9302de4@linaro.org>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-8-af4db9302de4@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 24 Jul 2025 13:11:04 +0200
X-Gm-Features: Ac12FXzgEQ0Ku4jr2sgSveo2Ph25gzNpv1tdxFI9mpW2KmHkqCwhSh2Uki2L2dY
Message-ID: <CAHp75VdMmfV=z75K9AmB7GsWV8C1bZPLGi33duTCt+CM79spJg@mail.gmail.com>
Subject: Re: [PATCH v3 08/15] pinctrl: keembay: use a dedicated structure for
 the pinfunction description
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
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 43y3caj9dfpbumazqnmsirheffghhsor
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 21A071C000F
X-Rspam-User: 
X-HE-Tag: 1753355502-18233
X-HE-Meta: U2FsdGVkX18t+diIVT8qKVH83yOc/6S2/DM1pLKM7pzlnrNcqPz+3991OLEaW08NxL+Z37ehu8AlhzSaWAWBcrIMJfWlz+sii0Np7IO2k9sKz/2RreW9PQyIci1t4f3EiOCAUc3x4Yp8dBT5d6I9+aE3y6aIjYpSNfhsjo5OaoeQYDtoHmQDw8cEtWqwTO3x4Su39/Z9Ttwt2IHmDBoWzoZAHerjUMVla1TezU/2Dnq8dvc6WdWeKYM7T3js57AeckB3ML2sjfQADdtrenzUIdvSQa5XkHY/UQ9JkDYcNXLx1icRLYZUmzTkiHygxiDyDB3JvaCp96emELjJgU+pW55XC9u8Yjhdh8BIfWeHIwCx/mECBncwXX03Bq2qGHt/4vMhmAb/pS3OUI14tgYZWF+AChyfwkAhf1zEoYHDLY0HkJfuXv9tJkrs7dtuPMOcRmpCli9bnvOd9S7Ooh9YfvG/wvAtiS4/jZqqWGU1muVYsny01ax2Dr7yc7ZtethAHs2pQFav2wjgVTlqtI5bdLsLXIXgND7y13KfHChUR9cTZJIdaB3seWuQtqwxlgV41mWltSSL76UB82k2tpfHWTqjhWSDR8uq1L3ZHGPB5VW+wK2IV6EiyoLn4/80AGWGwxZCNLCb1ptuuN1440EX3oxXDNONcWMvjQsQgfmeNK2ScpAg5w0XVp8jeUa6I2c75WrpTi8Hl9/dd9lUmn1eAOTZIfPdOozgoXzrI0DNSJ7vsktWuhGmgYHR1Jneq9T7qYTKLC2BHG5Y7Et0B/qldgUfoSG2w49mu02r0+ZX1CKRbC+cbmMOUYwZ+sUVlmPyhRZZFgzjqT2xKB605YoDZjdf4DurGKnL1oHt0IJua9Oh4Ssvo73o6w6nYePKBBTOSbJOMD2qgpvQS30DLdpH5VfsoCuIT8rm3I+Ae0wYrk04PQQeIOwzTz2/3anso6BJVp9JfZ90S6pJ9UiZiQG
 lLtVh2Xz
 u4oQu8uMnCcyVY0696jbrITxIwNz1gBmmY/ymQnCdt0FezISK7UwYmU/JcA7dswXthyodOE1f+uGxgd00nOZEqjJhLUpt37PNKgGgSmsJAPZ0fLQgXeTZAw4UkXDFOsnPw6tLXd54n3hydSoN17ich0HVRYTvEA3YldfFJEZAcalWxud7amO7EdGwrB3oQDlyCcqrktQhU7JNUeAJB1q8bc8JekxJ5GIjYbuP47sl1p+dsA7y7r9k2MLifj9t0L2QQVP+ez5lYcTi+My+M2MpnyTzxlXc5mxWDOmfYv0XiOIxZpKozAMVJeaFjrog/UKwdBDBev8ZRV5V3tAbaPmPDKiJDqER9KkANSt2DJFJr4kJJi0p85hWRrONIbsYwZOak5DwR2sylZ4DgvRaQpEZNK0rglp+H3ABfsgrjzsGBigMl7VHWgyMNxwaiA8FPii1fswyq3jqKUTrgcgSuScT5dytnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:25=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
>
> struct function_desc is a wrapper around struct pinfunction with an
> additional void *data pointer. We're working towards reducing the usage
> of struct function_desc in pinctrl drivers - they should only be created
> by pinmux core and accessed by drivers using
> pinmux_generic_get_function().

Any link to the discussion and perhaps an updated in-kernel
documentation and/or TODO?

> This driver uses the data pointer so in
> order to stop using struct function_desc, we need to provide an
> alternative that also wraps the mux mode which is passed to pinctrl core
> as user data.

...

> +struct keembay_pinfunction {
> +       struct pinfunction func;
> +       u8 mux_mode;
> +};

My gut's feeling that this type of construction will be in tons of the
drivers, perhaps better to provide an alternative like
struct pinfunction_with_mode {
  ...
};

Or even with variadic arguments... (just saying)

--=20
With Best Regards,
Andy Shevchenko

