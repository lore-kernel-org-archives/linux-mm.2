Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B4BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B858E00F6; Tue, 12 Aug 2025 04:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B738E00F5; Tue, 12 Aug 2025 04:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12F38E00F6; Tue, 12 Aug 2025 04:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 968568E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D66E115291
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:12 +0000 (UTC)
X-FDA: 83767425504.02.B7D1F72
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 01AD8A0004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=sNxqkKRw
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LSqLNFw5ZoJT+eJ+R/4RbrBYWHEJxUchO4svyAYAyHQ=;
	b=6rJe5imRpF1/EqHuu+S4XCJLlf1qLtj02QMeeec0xo4aPVBBhL0J1Hdxeol2aBYnk04nm7
	NpSsLPb+mnKDn+OHR+MVZX5MmZXqEe+gRQxsoRRiItCEvVh/av/g9ZX1/AbdU42S3fE5T5
	qjlKYg6kH3dZRwqhV9xcZJvccTpMQPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987230; a=rsa-sha256;
	cv=none;
	b=c+izei8J+v1rxCVbewHsilOuCN94irwDXe8EiAbLr+NS1h5rZ2nOvN55xSlRxoCbyFVlTp
	WPNjnAySI4c6JeaLySEseJUpWOGsyPa2omKDfR0/c3PeMgW5GuBzi0puUPr8upVOYQm8JB
	0myjrc+ZnoVCbi+pcFcCAILtnIOATec=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=sNxqkKRw;
	dmarc=none;
	spf=none (imf25.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.47) smtp.mailfrom=brgl@bgdev.pl
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b8de193b60so2932697f8f.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987228; x=1755592028; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LSqLNFw5ZoJT+eJ+R/4RbrBYWHEJxUchO4svyAYAyHQ=;
        b=sNxqkKRwztZSbNP2UnvSaDByNmsEzGDvf/iq10Y61xNdPzP1uoZcoScBfcaDObN1wZ
         x6Mp64u1q7YZmgXgwZzuQpR961Q/TQQQNmq7q+RSuTo8CU0SXxJH4GkjaSCSjS2Knljf
         AdgNcqJK93By7Xf2apPDqUiHsWTTHuwdYYm46IEx1hUbn2qiS6NLMAVcpZAptvyA7XRi
         DcMolSWTfMo1o3Sz1/FKQAqqZA1W5ipJ5ZS+h+1B8gpSbj7Dm195yLUoAq/3biZnAMI6
         D6sUp/bJMZEbr6iduwZswyv5MxXL17dihXieuTQJZpMOPQ2dMne7k/BngT88JokK8Zu4
         AoOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987228; x=1755592028;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSqLNFw5ZoJT+eJ+R/4RbrBYWHEJxUchO4svyAYAyHQ=;
        b=iWNI/Rq6wMENzWlAYD/DBhMKjJOtXP16LCnC5Ci/h/kPx08BQMkQBG1MeW98wLu+Mp
         yWUUTrzR3yb9Gqa2K/0ZtIMKoOlQwFYoiOIfRA2DPSQb8R17jjAcHoxPAcH4taV5I4E1
         dNZNbXG7kYU8PvzZHCG5UTmQt1c0EnHsEI3gO8dtzA24c+VoBLQArS9zaCUSRxiC8rCp
         FKMopb/GHSc/FGLJ6cuhAoj2mHCjfMOI8zonfwiPPbN6g8D7oNi/SEk3UOYdQ8IlMM+n
         Iz1KiFySzBPGMBZ8BFR4Ug/fFa7WJ8CzosOP5NxN5iPgpkUufRJfedxofKkAIh50awKz
         U46w==
X-Forwarded-Encrypted: i=1; AJvYcCXnZGmGjP+Hkv4Af0mv7OjYKhdCiWYXFsfqvghPCpHrHF+sIOtVJvPeXUBLHRkXj1y+fisq6KvXZQ==@kvack.org
X-Gm-Message-State: AOJu0YwG8ZCx5BnpTvDg0YgCrF3BBHj3pCZO8DvYqvAQhzHjEIctKJ/A
	ikXq9IFrkPpCgBqwJkaTd56V6Jn+zzHk6ZB4G+hbpEZ77eRgn3q7IB9iB/7b7JRrLHM=
X-Gm-Gg: ASbGncsleeMLoNpWPRQvSPvGXAys6HkfTx5JVh+Cs5adrPXOYAk4aMQ7ksVOdl/6u1L
	H2wgaWJxlSO0PBVv+oLhXzsl+ZKCIog3TavnRkAzhYYcgPkatFAQ/St8YSUiLDgiNfNxBdenufT
	1+TZhQJUULg55Os8KBqz4KNKGhj34qb82xZ+QVOwoLQXgHxsRhBSWCuRr1M82oiyyloJS5xXEtd
	U0TkzinMB8lswIBbTsXMJjX76xtS9WKAowgRYjIpXYfQfn29QHKZBYnvpnulsRyzjGRfBQE1SKW
	JHfe2HO0rO95ZiU1RgbADNSu4QKANWIluMBZednLaAeEa7IhUfoobmu3uL1OkjXEdJdqYILiJI1
	pF7tuH6W1abv5xDA=
X-Google-Smtp-Source: AGHT+IGt1Qdhl1SeHXbcRrXyromUYjuvLPhngmkyHILzZlpKPBo/s3ygqlYuwwSu6svvDg9bM89tcA==
X-Received: by 2002:a05:6000:400b:b0:3a4:ee3f:8e1e with SMTP id ffacd0b85a97d-3b911031495mr2033996f8f.39.1754987228110;
        Tue, 12 Aug 2025 01:27:08 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:07 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH v4 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
Date: Tue, 12 Aug 2025 10:26:59 +0200
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANP6mmgC/3XNTQqDMBCG4atI1k3Jn9Z01XuULmISdUASSWxoE
 e/eKBQsxeX7wTwzo2gD2IiuxYyCTRDBuxziVCDdK9dZDCY3YoSV5EIoHsHpKQy4G8Gv0T6djtj
 YmjVGKqUFR/l2DLaF1+beH7l7iJMP7+1Nouv6FdmBmCgm2JqsklaKqja3AZwK/uxDh1YysT0jj
 xiWmaaivKRCamLkH8N3DBNHDM+MaoVpJCfMWPHDLMvyAQqoo11JAQAA
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
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=10405;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=UDQSxGWEdaNlEt2M7Mav0VdZbGU+CXX3IOWp5CNXy64=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrWB2qIjviAYzOzF9rGQxbtFl0bfNv3xt3BN
 hJcX75YR9WJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr61gAKCRARpy6gFHHX
 cnenD/9QVkiYWaN45se9mVCv1Kmd7fcDNhqOnqO5k+01l7TQAlPMrQt3gTyvoe7CiEK5dDfa5ng
 aIbDkSuHtaZBpDsgc/BXeJMoESoAl36UvqOBfrX/zRL+EXlA4pE843GNpasFYss8kGdRGKbtO4U
 gcJKcstwSwRux/gfffXVtbEZO+jh7/3gggLSCCZHX0R6kJJWHhzou5kJ0h6bek677sBClWVmoY8
 eysYG00x5CQE0RPIPIM+4S2fQfWfxzhhRWIEq/YuuvJ4CuJ3LFO28NteYEEc4Y765gqgO5aQ/Go
 cn/UlbQCcl5oTQDS++2t1KbaW3KN/GDVlTpprFJQPsNzI1LyfcnlvtpUkvJeqZgN6oh3GCf55Ss
 gI0pMQB3Mudri5qmQ/yBPMY9RoPMVyuVEEfItLwmQVPnFBCFaUtksAM7oU6HqbEoLI4QwIN9XsE
 CFIHwvjFLRP9nqeDtNCtAUwKro0rLOkIkDmnsCkXIIZnZfimLTmSyBrLTY/elmWUlxfkqfAEYKV
 +z4qBQkVA4AJg6liF53vwd12SvKxjZQ8h93srCOICJ9uz3tOlOm/ZNpgXBuy0xTOpxbL9hJk2t0
 RGNzvJ1D4MnTaRwEHz9bw+spw3G0XBBakwDrnhB7sOPsN9dUclNtSpGJxeVXc4cqeavZgYMr3mj
 g7yTIfabzK5/L/w==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: qyk9aam5o5rrtptq9oiy57bown8bdu57
X-Rspamd-Queue-Id: 01AD8A0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754987229-375451
X-HE-Meta: U2FsdGVkX191HkyL4jO/dfpb1lcjv3nbSFyrzqbo5ZWErLNlfSCRzL9xpAZRyO4rvVVC/15oXO6HXJKbut1eEzqemunTphJfbsiIYbPaqgDtoXDbAEc2YcQ5+7kkvRzwUcS0ppYwD4YjvlhE6/kUKZGySCyn7brs6YHxUn81lLPQ570aNViXazhW8W8hSEzUBfK46x1ZFtJXKLsgyY12H3Mj73qLgqHbWcjRJr3ztH/xys9xL8r7x4DQkLurG7tKRv0hoo+zAHcYSDVEQQ8orOehPUt000Uv0u4odsodDb7LaJKOJYIh16nVpJK/ObcX0f2xgFMeRRLnrhBnQkBSe4YSIJXi8DOlubgU+ipCpNtACt8xFCwsbyv14BYYF7F2XsLOP7D50tqI6/yik9AjCwdnLADgWwk7BOkMt6v5wZCkfxpZ9Y5fT93LYlrR2cHb298hT+ofJdWZPNV3CzK05nJ6A9WWIExg6IioWoE/Qhj3dvhv6Z7MobTiNu26L4vz7yPJE1KvDC3BXSPeMz9mSyv97CV14wdgY0Zg+NSMOPaS7TglBm+bHUfTIcKd7UK5O3RsQHljLfxIRwd7cHCu43WJEWGzOtjicrc6mqMotIAf7WDAqffJRzskgOYtHnwMA/VHVS6jbB0HiqCrJvQqsk4oMNFEM08WdvUAFkx4qXrhhStn55MkRUgCbLwpdBFW/wyufTka/cUZdQ/FQvztnA27ZO3rlJYrgJ+ZF+0Ai8M8cEdOwoSdGJ49gpYgpdTU37tUHEc1J++ffndo9xTJMiQm/tjwzRaExxP/bl0KIjAYUj7EHnI1pOBhKXEuZNMZ4Bt0v7XxqM2ozTnr0zKJ3MUBgwCqFLAI0T93cVzuxwj3uA1QFS3dp8Y15cZfJ6GsN5ju/uKDRD/vxCbW/YwPtvnbl+R2YilUqyY89f9UxUnCUuc1Y4FEHjproSsHQdHLdJzq0oW3WlVixUlk/Ux
 PTNYiJA7
 uT7IUgSulII/OQ7lBnBeQf/jMrYFvdNECPfbhXgB6ilj2AXIb+BlHbZkiC2lSZckkHs69V/z2QrDValuD3RuaGoKU6e2aAay/AYnHBvCMkCYKy5LyxtZ9xQ+rsSV0ton8nhSyvdBTwROXKVWkn0gWd1YPhXUH5MoCW1EYJz/m9SX75QnEhhwjc1qShrn9yeKykKYAfVyu7kqDXP70LCXeOZNRSrnt1l9ViZhn2Jp/PtfH7WW5HZg4gGh0HqfALluDs26wnGlN2F0dirrRJ1yOB6ATa8hWRFW3P37SVM5tqj2AppOg7C/g2bBs1IQycRevlDzCabA4QxbRFtIQWhPwet/owK92Lx/u7Dlhcw1habLtv9gndp+zIiBa7Tjnmp015bmIZvRMBRZXe2D1x/XK/4Qrjsnr2gopUXSdyhjWu3QW1tJ3i3DEWPHaA2uq1PjSSx+J0mk1n6vMn8nIFM5H85/QxKIUiIxU82Bpgr5VH8MXySK6k6Kw+udOZu5WkKODvSAG/Xh7lKyeXQZy2mcXsxqA2g==
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
Changes in v4:
- Update the GPIO pin function definitions to include the new qcom
  driver (milos)
- Provide devm_kmemdup_const() instead of a non-managed kmemdup_const()
  as a way to avoid casting out the 'const' modifier when passing the
  const pointer to devm_add_action_or_reset()
- Use devm_krealloc_array() where applicable instead of devm_krealloc()
- Fix typos
- Fix kerneldocs
- Improve commit messages
- Small tweaks as pointed out by Andy
- Rebased on top of v6.17-rc1
- Link to v3: https://lore.kernel.org/r/20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org

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
      devres: provide devm_kmemdup_const()
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

 drivers/base/devres.c                            | 21 +++++++++
 drivers/pinctrl/freescale/pinctrl-imx.c          | 42 ++++++-----------
 drivers/pinctrl/mediatek/pinctrl-airoha.c        | 18 ++++----
 drivers/pinctrl/mediatek/pinctrl-moore.c         | 10 ++--
 drivers/pinctrl/mediatek/pinctrl-moore.h         |  7 +--
 drivers/pinctrl/mediatek/pinctrl-mt7622.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7623.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7629.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7981.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7986.c        |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7988.c        | 44 +++++++-----------
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h |  2 +-
 drivers/pinctrl/pinctrl-equilibrium.c            |  2 +-
 drivers/pinctrl/pinctrl-ingenic.c                | 49 +++++++++-----------
 drivers/pinctrl/pinctrl-keembay.c                | 26 +++++++----
 drivers/pinctrl/pinctrl-single.c                 |  4 +-
 drivers/pinctrl/pinmux.c                         | 59 ++++++++++++++++++++----
 drivers/pinctrl/pinmux.h                         |  9 ++--
 drivers/pinctrl/qcom/pinctrl-ipq5018.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq5332.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq5424.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq6018.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq8074.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-ipq9574.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-mdm9607.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-mdm9615.c           |  2 +-
 drivers/pinctrl/qcom/pinctrl-milos.c             |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c               | 45 ++++++------------
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
 include/linux/device/devres.h                    |  2 +
 include/linux/pinctrl/pinctrl.h                  | 14 ++++++
 include/linux/pinctrl/pinmux.h                   |  2 +
 79 files changed, 274 insertions(+), 225 deletions(-)
---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20250701-pinctrl-gpio-pinfuncs-de82bd9aac43

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@linaro.org>


