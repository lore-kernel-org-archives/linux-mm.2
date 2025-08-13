Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788FFCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 16:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025C19000B1; Wed, 13 Aug 2025 12:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F8A900088; Wed, 13 Aug 2025 12:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C7B9000B1; Wed, 13 Aug 2025 12:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9C19900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:57:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B4651A0471
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:57:41 +0000 (UTC)
X-FDA: 83772340722.04.49AAD84
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 523AD180002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:57:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F7v5cd8H;
	spf=pass (imf06.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755104259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2gxI4yFXWVOtLhM/0polO/7seLsXtV2FXKtzlfxTr8=;
	b=Va1JRv+io/pfrFVOkO7xqtGNnPIqKXu0hCjdaf/ruSzFD1h/Gm4SSD7fK+2oYzwtXEgPe3
	Qgq53ToyVbervCBxqs3Z26vX+UHMBHF6zSjR31SKtB8TSwP+ze9EZdhEN6nUqq9vh1/HuQ
	eD0YGwY1EzNZbHne22Z2vqeHIwPmb0M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F7v5cd8H;
	spf=pass (imf06.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755104259; a=rsa-sha256;
	cv=none;
	b=SxLYheXkt7kKQ6cfjRrWPzdELzcOaAc1TtiKf5VSpjWVFEMmBwf9uOPXa6k7dwC0EWjsgU
	32wLB2vbg61HwgBzPmQ7RbzfiLx/W3SVPAWBuFW2b30GXZnnMCFgQlalSmKAk7QVWTeYCS
	Nz6t82HUmCIvL27vWX8F6GvSzfaxnn4=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb73394b4so11704966b.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755104258; x=1755709058; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2gxI4yFXWVOtLhM/0polO/7seLsXtV2FXKtzlfxTr8=;
        b=F7v5cd8HoGAzKbmCSpWc1AgjtK1L+2+2AfKsJrdX63nP9Slh87TFDv7CNTiR/qFVmO
         nZLTf8ctVRR9TZbhcR0WXi7eggvZESmg+Vi3bkDVFnD9Did6DnFHRqRz4orUg+9X0Kkt
         2bu4+Rt7NoX+aa6sbRv98HJqL5gs0WLvQ1TK5ANnrGXewhQJjjtkyLb5I9KcmcnEx7kv
         OvK1xMSxpPU4LRHDg3lI5tsZW9rEip/MXNrpeRrlbUbLYZkWMmzpz/pd0GXZwyQN/617
         2THyz1fAHRlG+YkUUNp1D0bPY3SUtgjyd97yxqB/MhseodGustcwpzUXfchb8dfgYUD5
         mc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755104258; x=1755709058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a2gxI4yFXWVOtLhM/0polO/7seLsXtV2FXKtzlfxTr8=;
        b=Pdj6BPbNwxlpljk8qlBcIDtixQM5QTYxLjllys4iwIVYEii6xvan32HxRjPIEqCXB1
         BmmnkFD8Nti1XLTy0G00kPmWyRPf3Pyk53O+LzabEsdRlSSG0AxLe4a1ik3vRz3eWx2a
         tHwEt2DKObqTf3u2w019iLSaei8Sq0H3X1bfbBDRB4LELOR60q4lyNVMVEEoEmvzSssA
         d7xKCVkslfrrAbfcz3E7ykeBC+RBWFiM0hNMQE55JS60qMDfXLqT+XfVjrOMYbrBpfEk
         0VD3KpNX0dG8mSX9nL8PsgHNAf+KKj8wkpPCSgBqlQHNWBHg3hhIwxAEeTXdSYuPkF7C
         EITw==
X-Forwarded-Encrypted: i=1; AJvYcCWSWUz72BoAtxpFOp9YPmTu0ho0UW84RRe6BwxvRtyBkaJj1sP1ZrKIi+tcfXWeKWO2EDlWlbsRhA==@kvack.org
X-Gm-Message-State: AOJu0Yy4JT39UQVfAL8hVKiVQLdiu+lAVZnEn9j788cox1WJXaFrdxDh
	arIS1U8EmaJPGAPx0CdEUGlGOuAZQ0oNSBZVq1Kzcmk67GW9X2bXv53gClTkx0T+bsEz06XZa5y
	97HvjNhYX/FMNojQUnXxi51yy+DsZMzg=
X-Gm-Gg: ASbGncs12Je+FFKtppjBM65AAqypktVl0QcBln23JY31d1uaPDCfk4WfowwkU05q55g
	eZwPM0z14rLs1bwpFpOxlFO0mgNAKmIoThfjT775H45zt4CiaVjDLWMRgHKo1wNdSviFImXqVT/
	kJ6M4E0v3HnZweqdG3DmMmxMVXZJzgkIzhjkHsF2amahZYlYAjnGnE3UR1lqYxJTGT4wVlFIp1W
	Sy/LfbpYg==
X-Google-Smtp-Source: AGHT+IHbk44OEj1r3kasIcTcyEDngMuhrBuyXGAMgY2npDrtdlj0x5dJHeL/vjl9xwrgnQvrGKpG6wybKFGCryjWMzw=
X-Received: by 2002:a17:907:3f0b:b0:af9:116c:61c4 with SMTP id
 a640c23a62f3a-afca4e44cd7mr358157166b.48.1755104257569; Wed, 13 Aug 2025
 09:57:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org> <20250812-pinctrl-gpio-pinfuncs-v4-3-bb3906c55e64@linaro.org>
In-Reply-To: <20250812-pinctrl-gpio-pinfuncs-v4-3-bb3906c55e64@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 13 Aug 2025 18:57:00 +0200
X-Gm-Features: Ac12FXzRwEdbOG7WcfkJrIX52h7RVyVAx5HnOB8PpoXFNYyQXL2enxp09SWUXag
Message-ID: <CAHp75VeSA=AYDKOV5XQ5nnz7EZRmnhbbVyJrcBUcMO2LrRMTmQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/15] pinctrl: airoha: replace struct function_desc
 with struct pinfunction
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 523AD180002
X-Stat-Signature: 9o1psno7idb6m6bm1wnjubn6td3i7dok
X-Rspam-User: 
X-HE-Tag: 1755104259-52208
X-HE-Meta: U2FsdGVkX18cFDhlSEOFxUcV7Wtbpye3/fUy8LCSMZCQ0WI6pbuP02Sfdas1FfXZQHhJSxilWE+ofGOlbmTTih+YSGApu7oEjq56o8YxOt5J3yw9MLT4xgf6YD7W8aF8+gHsM93yCEl1e/jQumEcrh9+PXlZX05AegyWyGY1CM2sODdtXBPTOBkO0X1ZqfpI6etiXYG2yc0mgDQQBsUJ26ewdokWDckX54l9VfTICom5nF+eJMQINlQpbkqn/dQ4cIoKSt7dGyuo69+SmJKCnCjBAmCYOv2xOOtnVEmEdk74RSJgDaqbKSwZpPLp9s0b7ShFR8pvmiSxqqoveuZu9zNWHODs0a1A7s9yLPyDliC6XJqYLGYwHMS1RzJGPzTqpNgrwvUSc7tNMm8xuJ9rq0uAcMH3H0HkyBrD+BIm0bD1ooCNge1NZiZtPKunr+pi2MRNV0FLnG6nwnHKWzDp3H19mqzELugPXd21AC1XxKApdfjZVJn8Jmncid8pxynY8stSiFKJe4+FgmgyStiXZp58UYuq5mTCsq3SRhxubFyPQB60juOVpYnEDlvPBXGCiq+Wq8lbUt8aQqxLRWMvwi9DNEQ+9MN1uQG80hXfeWf0nRBb726L1nE7XUWbFi6rJ5P4PwrqGT+IfMVStV1/wLuLFSkcR8PCdaC1WxrXive/795a6yGcO5I0SWbm3ev4WrsAskbQiVGVafJ+pj6V+1RTwwZJ3qDc8m9UnI/NoVXNHz31y1VjkAH0tWCjMjR5020fkkrUeXHZtdyo7U3DbcMrbuBOoRNc0v0BKaDBs44dIirCrXPFWiFqhgvvaAmPh2zuM7lL71bTOsEHCdgeFyXLRsQwZmpAVJ+tI01K36HwoKSCHdt21lzyIS5fSDveJuTFQeRL+MCpTHSKJlGDJPl6vImku5S2PQPDcbfN37vwwdBRlIVIk0SUXfxQ1meIoJOTZPd8hTZCtGQMbQK
 bLfHKHPh
 k6VWwJoqS4sn4sHbZAOYbHpqcMlZzW9DbFkuh4vjNFXpTZCe6opxGTJNG0XROEGsWZLKoBvTdkguBFRn5tL/VlBUPl5piRutd6p8LxFPGGxru6CP7JkNWb5Etu+mB9pnVfJP7uwSSXsLVDk8Le6SuIaDbbSCFK/VYJxUQo2xL1lmhHhUHKeUhqk5QUG1LdcrqnKD+w7rTPcMuez546ZNtDBbipvD3vJVyFbe+b3lIGqJyoBZTMJE93evo1+4SO7hOfIQtq1fiNX0WVp3Cj3w7KN8utdOfNqKDu6Z7Vgg7T3ReTwtFplYJN1Ewdqi7HOhr3u0zUfnzpHYw0M+ZlXlkfY6kJ5FvTl2q24geuR9I/bKum0YXFsTTjDEarIJszaTF4IxvvQQi1acyAkbw4jikJkz72UhTHlDHZpAKSMfhnNcjtQCG/W0SAnCqwccX7l+HymuRQEWgyJJ2Eyo33IDoyHNvr2cG8382C2TcxL0uviEGvPsgJPBDe/vJQrvuM+qQaFwQFRTeO7bclTIVxvijFpicTGBEBQNSrBqJH/Ks2v6ZFwUS6CzxYPWS3+m59mh/1zGH
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
> struct function_desc is a wrapper around struct pinfunction with an
> additional void *data pointer. This driver doesn't use the data pointer.
> We're also working towards reducing the usage of struct function_desc in
> pinctrl drivers - they should only be created by pinmux core and
> accessed by drivers using pinmux_generic_get_function(). Replace the
> struct function_desc objects in this driver with smaller struct
> pinfunction instances.

...

>  #define PINCTRL_FUNC_DESC(id)                                          \
>         {                                                               \
>                 .desc =3D {                                              =
 \
> -                       .func =3D {                                      =
 \
> -                               .name =3D #id,                           =
 \
> -                               .groups =3D id##_groups,                 =
 \
> -                               .ngroups =3D ARRAY_SIZE(id##_groups),    =
 \
> -                       }                                               \
> +                       .name =3D #id,                                   =
 \
> +                       .groups =3D id##_groups,                         =
 \
> +                       .ngroups =3D ARRAY_SIZE(id##_groups),            =
 \

Can this use PINCTRL_PINFUNCITON() ?

>                 },                                                      \
>                 .groups =3D id##_func_group,                             =
 \
>                 .group_size =3D ARRAY_SIZE(id##_func_group),             =
 \

>  };

--=20
With Best Regards,
Andy Shevchenko

