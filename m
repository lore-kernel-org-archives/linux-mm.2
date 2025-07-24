Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD139C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC918E0059; Thu, 24 Jul 2025 05:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3448E0051; Thu, 24 Jul 2025 05:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691518E0059; Thu, 24 Jul 2025 05:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5166B8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 173B41DA280
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:43 +0000 (UTC)
X-FDA: 83698623246.15.6BD8345
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id C780480002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=gI3DxKhk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R+Jk1KCKeq5r1SUXMgObkBW3hrvYWAaOodBQW7tXaa4=;
	b=cAHY9KKaq9qNLViMxe/tx1HNUpZ6JrKScMt0nb/soDTu2koOOrbDZbhzmbRfmz5VlWNjqs
	NlWFXVF8afHhZIzufF73zjludyvVbOCI/PRr/0Dt0I97Cu43sbihZRof7S9230g1MoljIc
	899n2DsqmiYwj4h/fhqyuKzkqfq8GKc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=gI3DxKhk;
	spf=none (imf02.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.49) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349081; a=rsa-sha256;
	cv=none;
	b=tpOHDfxumrZo/W+DYH5AB5t539iy2T+/j128hMVZUSnuwcSelurYQ+ljqK2Gz1aE6QPO0S
	xvD5JttYWtEK/6JtIZzA6CRePyUQ/UGbyuLiUHRMNj1TORfA1ncL/+QnJuDQ9G3VfDSIXM
	Q1m7Y+GaZiX2USZGKVjaQ9P6Dkixhgo=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a6f2c6715fso592085f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349079; x=1753953879; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R+Jk1KCKeq5r1SUXMgObkBW3hrvYWAaOodBQW7tXaa4=;
        b=gI3DxKhk0MjbNk9Od8BuRJLKLfXyuRG91FxL6a7D6vsPShoYTxF2+Ho1HAfaUR83Sr
         JiRi4EcseuDSdGP7Om1yaJcCQJc7ArakfWxNgk1eDERXYkUx+pkayHZRWzeYE/0Gxa9W
         Pj+BmuEglMi+CLQrO0ZSd95RnpP6DwI6nFcP2Rf7iX2T1MMubS1tukxt2pZYMFe6BuWu
         m/yjdrQjFz/rXsTU7WuvLJtRLKTFYw32WVNciVyOgF/NRuopJfG/RCr84EoyjKnY0xXG
         doQFJlEBpXid2UI38IxSt0Ko/i0QnTm/wHF4Z9CzWLkz9RI2vAetIrTpa1MwCD+CoAhx
         reEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349079; x=1753953879;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R+Jk1KCKeq5r1SUXMgObkBW3hrvYWAaOodBQW7tXaa4=;
        b=aBmCGv2V7RrLT6oFYE2PS4PlhlzMFxNbQiIc1msD7J/K44hGyCaX4Lil9BQN/Ux/6V
         fbkIrp7TTIqgrwBxqJ3xS9TG5orgosWKcI4HlGlx1+g76M4/DxxUmrorGFQKMlUGuY3a
         eiR2OSgBIRgeoA3xYvuNPl9wRXcCi0WQEb2Ne4B3lSpoOm+OEaRIWTQTMQF67Dz4ETLm
         QnFQ5X9zfXjh3Yd/GaulAvZJmIJERnoyXFRQXnXQLgGy2vBROkdfJIyXfhFlU+k8y+ZS
         B5275NV2snMZbxOHluLnwJgL8R2csivEEU1ABqXOtuY6Srk+IWIVh4QfzTe4HbaSO/wq
         a+xA==
X-Forwarded-Encrypted: i=1; AJvYcCX5HGWTv8ZxvX4y8OG09EerH0TC3wUIszSvHGFWAzsvFGInLaEddZF/P1sl9JEKLpqyYZHOvFtjHA==@kvack.org
X-Gm-Message-State: AOJu0YxD5SuElrUwm7KYTzbDY/CkfjwDbwF/FuIam15OIq6TE/BnJib8
	RJd69Tv8fAbi62zIr85zy5Qh80IzXjhzxfjPcYtjUctuVa1uOxHAW0syqnaMTkiKInE=
X-Gm-Gg: ASbGncvniSwXBXWFjkZZpLtH5LSxYsrschLkDUmkX1xCSs1invt30hE1n772eksXK8G
	XxSPGMRBWe4e4Coya0u3AYxdXuh2KX8BD23pc7bOIOXYom0O4VEMHc7kshw9oPGvu0HcnYl4Hy4
	SSJgU6r3ey1H2ly9zXWlZvOR7RW+bhWmiN/HoY4WkN3ZFn3OBrx0glwCgxg2yNFxjtiqD+TmDk6
	VcugMmbzwxLswgUJkHRqRgvoZpmCg27MeM1QWbBePvsFhFMt+v/UZF4/q7mJSVRexB6LtZA7+GU
	C9N+/MLH5aqP3PboiUUUhh0ahq9gSAxGGMSdTzYlVmCWDMvpkKZUZU93FOdjwyit3tc3p9s6eJD
	dPqFRwzAenqpr4xDY
X-Google-Smtp-Source: AGHT+IHiVNcL8dxsUjZ9ow9Nkc+BPBzrSJjl1Twm9rUjXxGqsNrfckwjhBUnI30ZoqBFVxil9UcxCw==
X-Received: by 2002:a05:6000:220c:b0:3a4:cfbf:519b with SMTP id ffacd0b85a97d-3b768f00de3mr4831049f8f.44.1753349078746;
        Thu, 24 Jul 2025 02:24:38 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:38 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH v3 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
Date: Thu, 24 Jul 2025 11:24:28 +0200
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM37gWgC/3XNTQrDIBCG4auEWdei5qexq96jdGHUJANBRVNpC
 bl7TaDQLrJ8P5hnFogmoIlwLRYIJmFEZ3OUpwLUKO1gCOrcwCmv6YUy4tGqOUxk8Oi26J9WRaJ
 NyzstpFRVCfnWB9Pja3fvj9wjxtmF9/4msW39ivxATIxQYnRWaS+qptW3Ca0M7uzCABuZ+C8jj
 hiema5hZc0qoagWf8y6rh/JREqyAgEAAA==
X-Change-ID: 20250701-pinctrl-gpio-pinfuncs-de82bd9aac43
To: Linus Walleij <linus.walleij@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Alexey Klimov <alexey.klimov@linaro.org>, 
 Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>, 
 Andy Shevchenko <andy@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>, 
 Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 NXP S32 Linux Team <s32@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Tony Lindgren <tony@atomide.com>, 
 Haojian Zhuang <haojian.zhuang@linaro.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9733;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=KDOYk7d1hTlQEQ7jNP1FzXMIaIbaGvdp7Q2kHJYhtvk=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvRru7ED4AJHRVdp9Kj4Fl5NEpjpe67nSkHi
 V9JX28Zqt+JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70QAKCRARpy6gFHHX
 cqOhD/9NkukkbU4i8neVl4M1zDGb4hvB6yVojOnaSNoWwaxVnKVMQfpikAbVV/HfuxpzpwwVVQP
 tJVltv8yEMK+cuD6u7m/wj6oVZjvj4t6i8hUIbbgMFoNzgUlJWxpCQOtINLTpjvzbHeE6Uh2W6f
 8jkFtAevV7SgP0dUz03+W7tFIOR1+6JSu6rdDGAx5qiJqohs3T8C8RO+3deQIH5KGWIowyzj5FT
 okGFGNH2JC0Xne5rXd4JfXL2atbI3FSJLeKft2j3xtjDimXTMOcQdEd0DEI2FmFv7PJJOUuj20s
 aRyBV6LZjwyNVq5TqdQf/oEgpEFxwcidA2kUfEz+off2/0I9UJmyZz6RRP/JRR5h+xrjtghKZni
 2g8iUlZaHo3JCAbJQcoC+2kQ4vrwh/vXzuyMpDKFVX4Pd+a+kuAiYuIvoGXDN4mIcgDDsq0pfZO
 yH+8GZDLGTcOxnhPqR6sfmqjHUdmfR7p6SUILpMbM2dN4peWBNEskGyahCNKfzPzL0pBmro+cRV
 wtbV2TZTwv2vhkkF1HnIKjYV25VDETtvtD0utHRWVt41PrqNN7lw9mn9rLwSGcotHgAQLj7vXF1
 nuBuqhwLixjojObQfQ79GxdMLnTaNxi6djsDWYT1J1vWtAy4mstwLUY2g6XuDwOmGvLT8xaA5Wy
 KmiLVNZOHlhKL0Q==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: 6ftoop86kfuqeiwfckfyyjzexxngxeoo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C780480002
X-Rspam-User: 
X-HE-Tag: 1753349080-291431
X-HE-Meta: U2FsdGVkX19jksopTcOiBGlJuTdFTbTszDQLABVgCIh+/piutSkPrtQaKPPXpiWCBfGOVkqMUScDUFcRVb+ANkksEK4sSz46us5PHYk0GASo9lQr0JPOccrcM/nhinpWEISqH1QkbX9fq1/WCrlrKZI04xWJPJ1gR2QaM26JivIup2tSURLxgKe/IlnHdqeXkR7gQkPdAS616rW5kCUbcAe9U0YK8CJBtII/v9BCPODRKuUksX8V85gtR9c2aaxCDkeY0EWHUMmv+NqQo5PvrTOf32TLx9Z6DhM0jyP0077XkObpzQO8HOFQ34Ib4SiXVA4ZUkJg7xp4FfdBcEdLojv9jb0aZWD7a2Wq84hZhAJbBeth0cu1NJJkmbPN120RdYQ6EoA2WTUUjWXxkGH95T/Xf3w+NaY3OX31hmEpNyUozofDYvpBpNe7ZrWDHF8WtKTjxdkTRN0eMmS3zeobsBsVRbLHxaFrTD1WrspwLOb/3bgbuDsoMhZBt5+Slwr/NcFeZKF80nBn8VRGEkiBfSg4f+YWkayW4h/atePp7XYgSPNKtpJr7InUFe6GTpkZSaCo6KedqqZ9LuEUm5GfArePm2FFs/mGA7PDe9N9bcuCGNlVfL3f0QdyMvEbcow8PvJS8Sdhfw9Q24PXnHy2Jk65TJon2PM7vmKJbPQInZFi1Cka8JQuHhNXweo2jXOsSTAUCDG9dYOqmB5nouAVvy+/5NmIsVdEeWWj/J1ah72iTpclc+W1KRKsMq1CbhA1Cs7/qGRGdvAzX5tzUKIZ18QDsM/q5qn+nDpSztFe191KVX+7vHo+dzXdWaXERK8HmHbI4SOCTPUnH+57Ps4UhcUY2goWZEqt7xBZD2ZmqjVlsk2oBhYyDXn3ZLU/WMtXVc+ZuzwFhRQEUMjAgvjb72fhPz4QB/GizUxA6CqOZJeeaCb+I/19sj6ShJaZUCv4aA1EiiVw7oDSarxDOyf
 RKBolLDl
 F95mxx75EYdFZmGTECUjBYiCcRoHPd/Ad4vJ3Fz7MqRWGjHQE23C6dqeq9ImxIEYcOMn1PDAGKDADS/YZamn3E/ncB/dOPbwbK4PMeQaPQ6xNFdb0KO20P8wEiesP40bpGNUSOLjTfnz7oZgRSQ6P+yzRWo8MB5xnStBu7mZkjbOc4Jh7tr4xeydbG3j5xHktddUJfoiB8YesDM94gPlbcenhGAJM6bvzPRL4fgMD2bbovDfeadGeJTmg3hpOVX9IhgvAmycOuwxlB8laoBTj2cpZvcrxrbtn42xnBaPFauXi2ZDF/5HWi4n1dOVDLOEx2Mm2385rmF32omOIPVi/qNaTX8LiMzE+WwhhljkWwl5/8lGtKq5KonRqRr1xo2KTowlZmlIMHXKoGZsSfOUKhvAaW0KL/+YTYQUJYHVu4Euw0lNITjlsSOlXD2OcTWTPhFYTOM1jOjWAR48jVRaNs7XaSA8gjpSLTXODZb/dnyHS6y0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NOTE: This is obviously targetting v6.18.

NOTER: This series is a bit all over the place and looks like it should
be split into at least two separate ones but I figured sending it in its
entirety better shows the whole picture - namely the fact that the
pinfunction handling rework is there to allow using the generic pinux
functions in qualcomm drivers without ballooning up runtime memory
usage.

NOTEST: I tested several Qualcomm platforms but I have no means of
testing Mediatek and others. Tested-by tags are appreciated.

Problem: when pinctrl core binds pins to a consumer device and the
pinmux ops of the underlying driver are marked as strict, the pin in
question can no longer be requested as a GPIO using the GPIO descriptor
API. It will result in the following error:

[    5.095688] sc8280xp-tlmm f100000.pinctrl: pin GPIO_25 already requested by regulator-edp-3p3; cannot claim for f100000.pinctrl:570
[    5.107822] sc8280xp-tlmm f100000.pinctrl: error -EINVAL: pin-25 (f100000.pinctrl:570)

This typically makes sense except when the pins are muxed to a function
that actually says "GPIO". Of course, the function name is just a string
so it has no meaning to the pinctrl subsystem.

We have many Qualcomm SoCs (and I can imagine it's a common pattern in
other platforms as well) where we mux a pin to "gpio" function using the
`pinctrl-X` property in order to configure bias or drive-strength and
then access it using the gpiod API. This makes it impossible to mark the
pin controller module as "strict".

This series proposes to introduce a concept of a sub-category of
pinfunctions: GPIO functions where the above is not true and the pin
muxed as a GPIO can still be accessed via the GPIO consumer API even for
strict pinmuxers.

To that end: we first clean up the drivers that use struct function_desc
and make them use the smaller struct pinfunction instead - which is the
correct structure for drivers to describe their pin functions with. We
also rework pinmux core to not duplicate memory used to store the
pinfunctions unless they're allocated dynamically.

First: provide the kmemdup_const() helper which only duplicates memory
if it's not in the .rodata section. Then rework all pinctrl drivers that
instantiate objects of type struct function_desc as they should only be
created by pinmux core. Next constify the return value of the accessor
used to expose these structures to users and finally convert the
pinfunction object within struct function_desc to a pointer and use
kmemdup_const() to assign it. With this done proceed to add
infrastructure for the GPIO pin function category and use it in Qualcomm
drivers. At the very end: make the Qualcomm pinmuxer strict.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
Changes in v3:
- Add more patches in front: convert pinctrl drivers to stop defining
  their own struct function_desc objects and make pinmux core not
  duplicate .rodata memory in which struct pinfunction objects are
  stored.
- Add a patch constifying pinmux_generic_get_function().
- Drop patches that were applied upstream.
- Link to v2: https://lore.kernel.org/r/20250709-pinctrl-gpio-pinfuncs-v2-0-b6135149c0d9@linaro.org

Changes in v2:
- Extend the series with providing pinmux_generic_add_pinfunction(),
  using it in several drivers and converting pinctrl-msm to using
  generic pinmux helpers
- Add a generic function_is_gpio() callback for pinmux_ops
- Convert all qualcomm drivers to using the new GPIO pin category so
  that we can actually enable the strict flag
- Link to v1: https://lore.kernel.org/r/20250702-pinctrl-gpio-pinfuncs-v1-0-ed2bd0f9468d@linaro.org

---
Bartosz Golaszewski (15):
      lib: provide kmemdup_const()
      pinctrl: ingenic: use struct pinfunction instead of struct function_desc
      pinctrl: airoha: replace struct function_desc with struct pinfunction
      pinctrl: mediatek: mt7988: use PINCTRL_PIN_FUNCTION()
      pinctrl: mediatek: moore: replace struct function_desc with struct pinfunction
      pinctrl: imx: don't access the pin function radix tree directly
      pinctrl: keembay: release allocated memory in detach path
      pinctrl: keembay: use a dedicated structure for the pinfunction description
      pinctrl: constify pinmux_generic_get_function()
      pinctrl: make struct pinfunction a pointer in struct function_desc
      pinctrl: qcom: use generic pin function helpers
      pinctrl: allow to mark pin functions as requestable GPIOs
      pinctrl: qcom: add infrastructure for marking pin functions as GPIOs
      pinctrl: qcom: mark the `gpio` and `egpio` pins function as non-strict functions
      pinctrl: qcom: make the pinmuxing strict

 drivers/pinctrl/freescale/pinctrl-imx.c          | 42 ++++++----------
 drivers/pinctrl/mediatek/pinctrl-airoha.c        | 18 +++----
 drivers/pinctrl/mediatek/pinctrl-moore.c         | 10 ++--
 drivers/pinctrl/mediatek/pinctrl-moore.h         |  7 +--
 drivers/pinctrl/mediatek/pinctrl-mt7622.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7623.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7629.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7981.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7986.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7988.c        | 44 +++++++----------
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h |  2 +-
 drivers/pinctrl/pinctrl-equilibrium.c            |  2 +-
 drivers/pinctrl/pinctrl-ingenic.c                | 49 +++++++++---------
 drivers/pinctrl/pinctrl-keembay.c                | 25 ++++++----
 drivers/pinctrl/pinctrl-single.c                 |  4 +-
 drivers/pinctrl/pinmux.c                         | 63 +++++++++++++++++++++---
 drivers/pinctrl/pinmux.h                         |  9 ++--
 drivers/pinctrl/qcom/pinctrl-ipq5018.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq5332.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq5424.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq6018.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq8074.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq9574.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-mdm9607.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-mdm9615.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c               | 45 ++++++-----------
 drivers/pinctrl/qcom/pinctrl-msm.h               |  5 ++
 drivers/pinctrl/qcom/pinctrl-msm8226.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8660.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8909.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8916.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8917.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8953.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8960.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8976.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8994.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8996.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8998.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm8x74.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-qcm2290.c           |  4 +-
 drivers/pinctrl/qcom/pinctrl-qcs404.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-qcs615.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-qcs8300.c           |  4 +-
 drivers/pinctrl/qcom/pinctrl-qdu1000.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-sa8775p.c           |  4 +-
 drivers/pinctrl/qcom/pinctrl-sar2130p.c          |  2 +-
 drivers/pinctrl/qcom/pinctrl-sc7180.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sc7280.c            |  4 +-
 drivers/pinctrl/qcom/pinctrl-sc8180x.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c          |  4 +-
 drivers/pinctrl/qcom/pinctrl-sdm660.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sdm670.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sdm845.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sdx55.c             |  2 +-
 drivers/pinctrl/qcom/pinctrl-sdx65.c             |  2 +-
 drivers/pinctrl/qcom/pinctrl-sdx75.c             |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm4450.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm6115.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm6125.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm6350.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm6375.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm7150.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm8150.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm8250.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm8350.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm8450.c            |  4 +-
 drivers/pinctrl/qcom/pinctrl-sm8550.c            |  2 +-
 drivers/pinctrl/qcom/pinctrl-sm8650.c            |  4 +-
 drivers/pinctrl/qcom/pinctrl-sm8750.c            |  4 +-
 drivers/pinctrl/qcom/pinctrl-x1e80100.c          |  2 +-
 drivers/pinctrl/renesas/pinctrl-rza1.c           |  2 +-
 drivers/pinctrl/renesas/pinctrl-rza2.c           |  2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c          |  2 +-
 drivers/pinctrl/renesas/pinctrl-rzv2m.c          |  2 +-
 include/linux/pinctrl/pinctrl.h                  | 14 ++++++
 include/linux/pinctrl/pinmux.h                   |  2 +
 include/linux/string.h                           |  1 +
 mm/util.c                                        | 21 ++++++++
 78 files changed, 275 insertions(+), 224 deletions(-)
---
base-commit: 05adbee3ad528100ab0285c15c91100e19e10138
change-id: 20250701-pinctrl-gpio-pinfuncs-de82bd9aac43

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@linaro.org>


