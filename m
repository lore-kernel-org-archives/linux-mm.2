Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF8AC87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 19:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB196B0088; Sat, 26 Jul 2025 15:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B9D6B0089; Sat, 26 Jul 2025 15:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA14E6B008A; Sat, 26 Jul 2025 15:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABBEE6B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 15:29:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 318041DC5FE
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 19:29:25 +0000 (UTC)
X-FDA: 83707404690.19.1F4ABA8
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 411A3A0003
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 19:29:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EOzkRkt5;
	spf=pass (imf25.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753558163; a=rsa-sha256;
	cv=none;
	b=MxkVRRMF8W+XWT0gWUJeombkiEgi6T8cZMPPO3N0AQkoOr4toHP3SSZlkJcbQgfpGmyABP
	L5+Q3JqBWy73ykD9FR5bYvpbUZhqeqfV5mxK7qRzSI+dadjyx08Xt3aFAw5bwB9muE7eFy
	yOnND5p1tOlgEJqRenIuDDM/iZrLNoU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EOzkRkt5;
	spf=pass (imf25.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753558163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vvSfKTsgW67UgHTjYSpiHoW4cS1GZJhJf8MDOP7W80=;
	b=e6SgKppprI4Ecdg80sg8FLs03gKkK/bBV9Gqk6YNTQJ690CQxSJ0irsUiYShnwM9Nts3wB
	X6zK06b9/vb8HnF1CBAm2H7iJaF0FTjSSic4XkkRIfUE6QcQUr8Jv2wIKmPwHS3pb0LItO
	zWDDV2rauzZ4UP+fLhQ4bhQQTIZEF10=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a169bso5109833a12.1
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 12:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753558162; x=1754162962; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vvSfKTsgW67UgHTjYSpiHoW4cS1GZJhJf8MDOP7W80=;
        b=EOzkRkt5jeOOYEMJpFgu5DW1igA58rig75IDWYf0+3fpSHAMq7djnn5zlOI1nM/uR4
         QU3O6DCg/VmC7+/zPZughUxOtRSTesrXmbT4qj26r7CKN73hauB6TYnA4qFHabGTikAi
         uc3K+lxXf1Y/o/bBBS2zqY+Vt0841eKyfX3AcsG59yLQYPHyQFYH4pTAySn6Hv42IIHD
         ZxpaD3umII3bMFwdoMk2ZJB/CNZEgUwPwoSLyeAvt3zG1tYczU+AAl2ApiKrk0rZUgJN
         4i+k8lPeFanLdKSfU94nWptLEeVQAIOy0JalH/PDenebMev9FVXlNc1tH3sRHFqfVlD+
         0u2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753558162; x=1754162962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8vvSfKTsgW67UgHTjYSpiHoW4cS1GZJhJf8MDOP7W80=;
        b=J+kuLOVxAxNGFeEp5GL7B3MWE2k3nzLf7C8Xvc2Si+oDHw1x4OfDZGkp3oC7roWZ4e
         +DdCVgofB4NGUNtntmzNONaXhyqp395PSlGt0Sb+Uv0JaOl1aXkkPmFP5MKydk0OCsbQ
         P7ndbdXdAvldwwa12c7JukKJPUDcxDp3GXd9j6bTnXLfrE4shEF0LRyp2H6ANOG950Ky
         p8sZt/Z/mvQyC6kqg6xDW1ENjKfH+PDJtVZ15UCHoA5nJ4cRmhAwPv5CYCPdR+wwjPNC
         8Ll9KnVL8Df9t4PHfItknnqvm+v1pv/c8l9pymo5jkUzrcatkOGqHHtJYou4j83jPSx6
         UvOw==
X-Forwarded-Encrypted: i=1; AJvYcCXMJguJcrDo2PfOCxBANAuxT4sd44Ypp2gA8N/bcR6KMwzU9m2miT0KhjRjieTn+0kK1Uuj1g53Dw==@kvack.org
X-Gm-Message-State: AOJu0YzXXdJ4CA6OQsbrE3yerK3ny8cxetDb1KgA2irEf7S6RCmRHnx8
	XiTWBVL8+vf0cM0z5zZnRiw5CxIp9bDFAAsK9vzqdwhEj6T2durPPDYk4VpbWmstvm9EC+HlToi
	EcKNG42KXKhW0zldoh4w7bKoXGXQIIeo=
X-Gm-Gg: ASbGncscub4hy+KXzbQyqgVm6R/FBVo85Xw8DYZQ3lGRVU5WRSH8xryhGNK+DEkkSPC
	SonH5/OaHipPM1BpSILdmrg3Woba/F9CCJIwSPz7BidjssnJM+t3c421b+D1x638O1MWcUAX78H
	MgSDauJy4ocQAchEv50WtBkxWRs1sp1mFVIaTRyMkwszvSTfvKMXrykwXzLEQGNaNvU37fYTxdc
	pjfrQdd8Q==
X-Google-Smtp-Source: AGHT+IEX2WYBlju4aPOw0uNBG3Cx6m8n5OfxEhWAzTw7+nGHo7bYaFwlNoIWJ6wm4TCiyIXLTDzfL3Tt7hprvcOBWB0=
X-Received: by 2002:a17:907:2dac:b0:ae3:c968:370 with SMTP id
 a640c23a62f3a-af61e9224d7mr644269966b.59.1753558161391; Sat, 26 Jul 2025
 12:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4@linaro.org> <202507261937.Txq9shpv-lkp@intel.com>
In-Reply-To: <202507261937.Txq9shpv-lkp@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 26 Jul 2025 21:28:42 +0200
X-Gm-Features: Ac12FXymY6tdOYJ4GtKwZ6wBh8I0rBJpt99EqCkKrn08JeG_YAOQylRsmRomyC4
Message-ID: <CAHp75VcrL56_8uKNrmLj9sk+t7qZfKNi6-W-yAKNZ+mSCXU8zw@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
To: kernel test robot <lkp@intel.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, Linus Walleij <linus.walleij@linaro.org>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 411A3A0003
X-Stat-Signature: z7chddqkg35pyf6r9hzz5rxjy9n3rwxj
X-HE-Tag: 1753558163-45371
X-HE-Meta: U2FsdGVkX1/6uNRhwZiVk9sUOJerB6ptV04hqJ1UqXiKqHhEp97C13SjEnXaVd6OlV4BVypOQiG9DfpuGth8MRgK82LGdg5Mes2HV1M47Jq65JQ6Zw25TXmQgG5kX1QD3/mS8JQyneES4zzb4gzTLkrxIgAJjxwlnRC282JIiQhGKmr/7LStmbHKPxrT7/9PdMj/Ag0Z4yfUPyP0+nTTTxAOlvyvdhe9y9pGsRDfrwvlX82RUVHmwbaiDs6VBHtEEBzckv+VziWwlUi5RJEYzRl7Hv+FVhAZZD4iEf3pka6UrGRwzgafcvLdWlksI7BJli5QNML3IqhKFfmVrsbDLf2t59ja/DjShPzDk+6iWV7MeGxFcTdWWEvK/g7k7TCx/u+qZ9/1iQT6Hhozm+LVc4uGSaqOXqnQev7JBCzYwBl9aOw3YYH62CMgMaoTJD6JHQL3AGllMxayHc8CpgYY5grW50rX1MqMlkKVa/gWX1nXr1cdWxTDNRc7NwOuslW4Sp9qQ4ycI5FRQtfyDM0uwS1A1iXqzzS1PIERiLlZ0nzBmEUhOlwR12ZPW6vcabztO5e4AvBJQ8hZqRVAmrwyDLcppppYcv6pHSZ31AqFNf6ur6BeHCfXmamkpJxVC93tCDY5l7+iDxTuMB+2yZKESgeDpw2pH+Q02HiTIGhDf1gDTbbtDG8ZkiInRPgcUFG0mjJXKBWrQUSlJrE0uUbZ9M/mu3gfCcIf7K+YVRdzpiBV1Cpn3WX9iitrtJdZuD3Dk1Llo4CZDb2mosfhrqgUpG/LAcAY1rgZfjpbPs4luUzN0fJWdEL0Fa3ZSvkX/1ev3QJ8aR8IytK/ysW1uHXRQeHWJnnRmRJZA+493kpHc2mfCBxTlTvyHIYwqzX4GtzAo49nxofztVhLxJP4wtxUXGiuKYBCNKj7pAOejRNe8zwAbeRYKpAtLWrLinXlskP/b+x2BTh/aqYPZKCd31i
 XwwNI0lg
 9hUDfpFpkENCz6rAxos96FP8cWTimKdSXBcyFq0tWcw76Fg+9ulGnt8sO5tWeCjG6ViFPX16+lkj780MPyWN3rZOrVVP/mVBan9ppexuMdg/i/IGRuk9rR1WGUrpuyHNhI/yOO8fppzWddNgZNIIz/VzxnPMeHvlCdpO7NDKh6csUoLgalHz+x/YA+6UjxjHIm1gwBgDCJRvc3aZulQnFWwJ0uAeRS52ItC5e2H8gg87eQgXyrrL5xPT97qUnyfhgQ2UF/dwIs/bonzfI4VqpwDeAX7U1fPq2gO+Nq2AqxBgtzfx+ZK9FJoajpgjYn85xAMDuOy8sFFdsLhW4WTpMHUe2bDDZtHLmc4DPonVebTZD4MBM+DVmx1lO47saDK3SHs8uavTbhy//sztA40BAdOsaoizuqwj6V8C/6nRoH2Tw9wk0CU4L4yMLa8P1LJme+Gq+vOzoYc21Km/XvUxduHgkyAsAgk4Cq9ilvczUTZRMldqJM0rYll6dyE+IdIps3cAKMV1mQYKuZtegDl60pg1TJRhQogSaF8vI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 1:31=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Bartosz,
>
> kernel test robot noticed the following build warnings:
>

> All warnings (new ones prefixed by >>):
>
> >> drivers/pinctrl/pinmux.c:917:7: warning: cast from 'void (*)(const voi=
d *)' to 'void (*)(void *)' converts to incompatible function type [-Wcast-=
function-type-strict]
>      917 |                                          (void (*)(void *))kfr=
ee_const,
>          |                                          ^~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~
>    include/linux/device/devres.h:166:34: note: expanded from macro 'devm_=
add_action_or_reset'
>      166 |         __devm_add_action_or_reset(dev, action, data, #action)
>          |                                         ^~~~~~
>    1 warning generated.

Good catch, LKP!

...

>    910          /*
>    911           * FIXME: It's generally a bad idea to use devres in subs=
ystem core
>    912           * code - managed interfaces are aimed at drivers - but p=
inctrl already
>    913           * uses it all over the place so it's a larger piece of t=
echnical debt
>    914           * to fix.
>    915           */

Indeed, this has to be addressed first, and IIRC I also got something
like this in the past.

>    916          error =3D devm_add_action_or_reset(pctldev->dev,
>  > 917                                           (void (*)(void *))kfree_=
const,
>    918                                           (void *)function->func);
>    919          if (error)
>    920                  return error;


--=20
With Best Regards,
Andy Shevchenko

