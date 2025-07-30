Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48688C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 14:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B135B6B0093; Wed, 30 Jul 2025 10:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE96D6B0095; Wed, 30 Jul 2025 10:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A269F6B0096; Wed, 30 Jul 2025 10:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 934876B0093
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:54:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48BFF1D826E
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:54:14 +0000 (UTC)
X-FDA: 83721226428.04.6F4ECC1
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3686AC0003
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:54:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753887252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oCufAOV94HIMKHfZVdb3wjn9NSi/Vfyn02LpL1/VMoY=;
	b=ySpM3Ckqx8A2d0Ha0JTon5DuXATtH+UoOjjp4EVhtYHYmJLAwqgzYpd0ZTKPmboKqPPH6y
	wutgrt+6QDNDg+QEcdi2Phtxr+1vsB2JJ4ewnwn99hKhKr04L93Pw730zxTnVs6XvOcvon
	z3epME9nGo5lTCnEA53I0h1pGD5pKEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753887252; a=rsa-sha256;
	cv=none;
	b=LJrzX9K/R5B7aIWxfD1rv3RiukS1MQRZGWi6tgNN6dR7gkbx6gr65fmpBLyNhKwnamLYp0
	k6l0aC4pZj9Hur7IKPmyATG1537PoHoOt8c/5YzlbUr0mZHskjHhZjArLIO/ontQd+nQjM
	Yrz3yd1uuZsIpfsI0qskE1As28byzAY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5316a5e4c6cso3126144e0c.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753887251; x=1754492051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oCufAOV94HIMKHfZVdb3wjn9NSi/Vfyn02LpL1/VMoY=;
        b=VcCtdwB2wRf1AEupv+5XjOKL46UpqmjkYZr/xaw1WufZVkYJlz56ISw9tz8vzYCCMC
         gD00CvBBPFeO7pbNzb0tLtvoL5NCs/0iVPoNIuQz1kFSDM0nBGvFQzT4MZZwokBzeXxP
         GsgCJTLDXvTBMyMgoWq1Z0chTJGDZlL8m+ybMx5Z+0QKwnRFcwskv3it3ufHisCoR3cw
         GIjed0tpcHuaESu0k50myZkmWqxm81KUjib6sWb/qJc9g0Avy3a178/xAMR+f3gPAN6Y
         P+bFAPi/MkzMT9d0FPnLZAwPuMlIagQ8r+yPSxffi1nsFrraAywKN0mjRgbmUHgAH2Fy
         iqXA==
X-Forwarded-Encrypted: i=1; AJvYcCVVmTI5QBKGVC6qNeNzION9WlHq4OwcEyY3u6lod7yG2xC8R6u5wlXyxugKH4L95mqBcWpWKyHc+Q==@kvack.org
X-Gm-Message-State: AOJu0YxSqZ+HvGPTaD+VOb2loGjitSGnbeK8Ytq7m+9jRmuetd+1Haab
	i44RXbs47K3/4itST+ECsM0LXUd6aodBtnEak/VmJj02metmCVBSVeAzu1YEDDtQ3G8=
X-Gm-Gg: ASbGncsByJBEBJ2aelXKMhNe5J4tAAisKHcXS9kRldTr/qzUAWPHB73LepR9oG8sGi7
	VVlAVVn2rb4jYsDakufZN0miBzjx06nboAWCRmrXP52er8WH/8beDBy/6UfWO3vlY+aCeW2rTE7
	XyGsYKA+Mh/9+f56JIbYu4Ui/wu06rmf0FYL4yqSZ2OaHNdNiJ8F6o5BB6tFPQugQK7w2qBaoyo
	vAca1w/kdbzCv/AJiOYSs0OBZgqmtqrhbV+HwbAvA+2IVPCbpaSxjiaIUXGVSknLsk480RKOpoF
	W46NFKdp8MzA08HX4iHsjcrzz+PIJODsjvTwGoFQ33vdv67YmSr0fJYHtScrmwAQ3uvbOGlZixH
	Dgm4u1++IZrCS2VP5K7uqrw7ICWJDlNuw+P85EUXNHK4xEn6fuFBclchvpIDV
X-Google-Smtp-Source: AGHT+IGywI4pPYJv68mW16LeAlwMF19caw39weOX0x81HXRxICz1CWF0Ic2aTog6eyoS8CR37qJZKA==
X-Received: by 2002:a05:6122:d9e:b0:538:dd8b:666b with SMTP id 71dfb90a1353d-5391c9d0a70mr2326914e0c.0.1753887251042;
        Wed, 30 Jul 2025 07:54:11 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-88bbda04d73sm1178891241.0.2025.07.30.07.54.08
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 07:54:09 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-4e7f367ea11so2922103137.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:54:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWJ5Gz0L9WLy1O07PP5FUb1XRKnqM7BlOF44v/V1I2ai6nl8GWQ36A9bwKqiacMZ/Qfqvh3k9lL/w==@kvack.org
X-Received: by 2002:a05:6102:358c:b0:4fa:85f:31c0 with SMTP id
 ada2fe7eead31-4fbe87acbd8mr2306438137.19.1753887248543; Wed, 30 Jul 2025
 07:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org> <20250724-pinctrl-gpio-pinfuncs-v3-9-af4db9302de4@linaro.org>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-9-af4db9302de4@linaro.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 30 Jul 2025 16:53:57 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX+fmSPDZ1q0UeWxYJsrUgHPi2+_HC0Hy6TtC+W=kaULw@mail.gmail.com>
X-Gm-Features: Ac12FXzcRmJnrFvnxFG5jsyy_jc5Ss1VNLUefIVdE-6ssqD0s07eH4xzZW0L3Ow
Message-ID: <CAMuHMdX+fmSPDZ1q0UeWxYJsrUgHPi2+_HC0Hy6TtC+W=kaULw@mail.gmail.com>
Subject: Re: [PATCH v3 09/15] pinctrl: constify pinmux_generic_get_function()
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
	Haojian Zhuang <haojian.zhuang@linaro.org>, linux-gpio@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, imx@lists.linux.dev, linux-omap@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3686AC0003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: oe89fubgiqzy8m8rf4obpxpx4gahasdc
X-HE-Tag: 1753887252-626523
X-HE-Meta: U2FsdGVkX1+7ruOOprA15SuvPdrrEA63yJz3u+JVd612HD3CXk6+OZ4vwPd6vWwCCXVYBbxZ1t5qPa2+wKn/ll3sPHz8lTZupZ1jNLy21sSZxOt+K3O53i2bDAl4cqNEAXhWh5lPZWnsgIPZdiWMYne6bWDv9d7ip3oDor5FMA0JB62PS4LHwJPqTWCNm1ARam7oS/DoAGoN/oMLNQHPyhiVtoNY7bjBeWLsuIx+iQ8HsBkP4yW/mcFbkmCwSefI2meP6WXZ16XYDTZeE8nZTf9XQpN2Zik/RfZGh+gNZhYDg4BvTM8pWy/wff+fsRkTmd77yHphvQcLJPScH9HIdPexpuqzt4VvCQjm3HP1mQlBZPogJYnz+zW97Z4EXe/twvsCc6f81NPEz5V4ZNd2o1YTdQmr0YQ2/Kx5BtRS/KECsAjXeWdmquO9e3t3lpQkbl6WMGca1qzmKmyVAiTPL6odmbcMXaUgzohPk8puM5DhStCHUldMiDvo1J1K8KEAAVAKIgNiRLaBf1mM8uR6TTGj5ss9kwiUec66sjQB3lbx8/tYS5T9vT2/xXHwQ3L+yOdBDyQnKv7WBDXRfqeZmf7jg9LHbrbpW9Yx/BgrVZsHogUb41Jwb0GM5J8rvjybWZSFy+FTfQ78W71vkJGHJEqImiggsRom9Gm9jHZQ9Ypq9lP9FyWFx23s8DmyK+pYmMqRMLkeV4IzLmoHCEm/9CS+EMcG7c0TvwQEdhNU5N8sS1v/mJd0z7LanUea3EhKAGVX5JLw24cTb8iJU2TxGcgQhGtE11B4nIQ5ygPEThaiPvPio5ytwtcL07d14xj0I0yju0LuTdgWdt/8V52v2xPvmWUiGb48RJhXoFOn1u0ArdXtzRi7Q94QGXtaEBndd/iq+zHS4LY85YmKPQ1hHsQM39HXQE8KoPlf9dc0/SAteP1//PiWtYDKxJrM2JHTHsTsBDOn6akelE3svh5
 71/bxoKa
 khg4vfAsFa5lQKSVYC2D92ZwAfrx0zagJ8uju/XfY9SQTjwIftEha2fpAn82SX3CjekEE+O/MU5Xm8XzO/PpJKbOu5zLSD5F/vK/2j7qUQ7Dj43vlNS1H1OsrPnWmXEhEZA1dvxALBv/+Xu/A9Ss6FK4xmWobXOpR+gELUmtjnhDR7b1E1lJMLjuTbxUUYjEXQ/+Ao4HoybrjIlPlFnMQNbahWzfF3D1Vbu4c4Z+ydqCFxkUwuV/NTBQjAKfhZKdwfAOvt7einxKjJMa/g4kDBM15GlqipeNPmw4jrXmL2HDe4/6z6K2J1fWo1xJpAs+6AGh0uynBMANgMi33qgaZwL9UP3TPOzuYq7ypgoWp4hyIoXYKOhhHK3C3HKuIWK0qF47FHhbzd6ihPueWKHoWp99WEcEUZ7U8zzd94KGRH0O3d58hR9GRsNVlucfUij95Kti0q+fQNxdp7E1EcWbsVOHlDNHVs0tK3ps17tnIjeMeUO6ZNOFZIVO9ySwLYCGZJB88Lb692iQIlpfHDfqnfwA3QsE1AperaktlDR8ifXhFxt4AWTFuoEL5PYUo2nhnM+KaEl90JahivkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Jul 2025 at 11:24, Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> With all users of struct function_desc limited to only accessing it using
> the dedicated function and never modifying it, we can now constify the
> return value of pinmux_generic_get_function() treewide.
>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

>  drivers/pinctrl/renesas/pinctrl-rza1.c    | 2 +-
>  drivers/pinctrl/renesas/pinctrl-rza2.c    | 2 +-
>  drivers/pinctrl/renesas/pinctrl-rzg2l.c   | 2 +-
>  drivers/pinctrl/renesas/pinctrl-rzv2m.c   | 2 +-

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be> # renesas
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be> # renesas

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

