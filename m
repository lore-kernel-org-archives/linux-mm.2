Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CFAC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 11:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE628E0073; Thu, 24 Jul 2025 07:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5418E0051; Thu, 24 Jul 2025 07:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAC38E0073; Thu, 24 Jul 2025 07:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EABA8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:15:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D68E21314A7
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:15:12 +0000 (UTC)
X-FDA: 83698901664.30.C1B17E8
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20B3F120007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:15:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jH7E+p1y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753355711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAtHv6jVtOKPfBxG+t4sPI1ngV8CsevwVhkX4+9+HYY=;
	b=aWRkKOPmyl5nAXRZki9jsrmUUavXsn21KiNHsOCvxo6yTwzLYEdrl1/36PIcD885A0IHdD
	di6uu+W3WgTTusP9k+WDSwcGEAh+1VFT/+OCuU1KUuyf5lRh73XaLOptxRHCn4Qn7dUxAx
	OZjrJ6wu2Xs97Y7KZjtjtvKGcbUDbac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753355711; a=rsa-sha256;
	cv=none;
	b=Fcrza6Ko9iEJdIA3JMbsIMKghW8ZE7MS6m476zIatWwX11hb518AJMuyylxCMoaBcwhgJu
	n9XeBmpgOLD8ccOaZWAkZHqqqlcaANmHUPo2MvbP3LTngA30rqFcIxaFBSYWZxoRoz2nqk
	EqQJIwmGa3Iog/G4DeViexP2NbNHUdM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jH7E+p1y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ae9c2754a00so139798766b.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753355710; x=1753960510; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAtHv6jVtOKPfBxG+t4sPI1ngV8CsevwVhkX4+9+HYY=;
        b=jH7E+p1yCXqA2Jm/l1AMRXwam9x3h03jMzoL5cs/yiJpzyBr4N3v1BUuq9Ghc1oS2p
         wJA9rOctBktClaqI9hg1z/g+pS3RfvClwdKzSGAxi9cTlDhHWnWxj5QZ/ll0IrW/kaWj
         6e0gSKO4vsdkT/mEudUg1tIboHB/uw8z50PKJk+TUIHlNCB9g4zL1jwy69apcO40z9Hu
         8VsP5u7Lk/EaVJ7GBESIIyqQCXIihiKbjLRHAVU6GdZ0G9m/6H0pKCOK4/Mf9CNL9B9m
         pAq9h0DLdr6H7PwAHqssEhlmXRUOIKvO/TpTVDwak5sulJ3Cr58AoJj6aX4acehZKaXL
         lmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753355710; x=1753960510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QAtHv6jVtOKPfBxG+t4sPI1ngV8CsevwVhkX4+9+HYY=;
        b=g/5GW/MVG4aUf+pVWkj7yCjAAjzucxSeJlrbAiuC5+T/aOUjIRQSW2xAVhRhyMk1fU
         bHtNvgPN/Eb2Ssyjdu64fKtOV7p8xlG7KQ/RHP/+5CSF9IRb/NI583SJLtrjZP4Fkpaq
         TKAJARFH+mCUGzj9xPk+eG8qoa/Nqpm+W5ldLYQWGGehgXDkKVA/wLyD7LhzOvzR0RBg
         iELrIcEPTQj10A1QNGmtQtPBrmNVWyZzNWQEvoOjO509ywKipaeaxe/dnuaJIyje8qM2
         OmFEpVZFgp1BQkE07hequEKXbFa6J4gQpaIgZ6CudDnKn9ydWuJ+xBe3b2pEzAemn9r9
         HQ7w==
X-Forwarded-Encrypted: i=1; AJvYcCWuTYfg3VXX47A75VOHGV8IzOEMgob8/sttFo1WfynNw9MPipXwU6thvcPe+Var3KAKhwGR1uEYkw==@kvack.org
X-Gm-Message-State: AOJu0Yw+jm+nkj5vfOBZnOrHHFp7HM6TqN05teHtLOmtw9w2bBnaFt+N
	aWWFJ/eiBVhqzUkeOBaFap8nLo37U8xsMkeJtMiJnWllDJ8PDufZsAAMKJqKvoc03FNcTrICTmc
	KNHRX8sk1c0fPVP8ecZJGrCvIE2v7/W4=
X-Gm-Gg: ASbGncvREEe18jQhJ5bTf2XZGTUtOy0SoHAwQTDxMrQukRWHnePWM8sRVG+neUKbK32
	DG6Mix0yPIyIxO0KtxB4UHaXWY8D83ghb5SmumJGGs/U6FDIHrtcXoO1VxwjT3fABMNz7C6C4Gb
	OWpZZYELYzdCz4RkiC0mTosAUvV2hf1jTkKlh15MRj9hGgn3chMf6gXnOz9gmao6bmkrYsMX0hQ
	e0R5nRWrYL44KE3AyhK
X-Google-Smtp-Source: AGHT+IGWvdFdi6zzckyJlm6N2JYQgwAj1cZ4UkHgtQjTXi3F8fk1lJZ/2HIRvhtKXI2VlvbdwgIvW4p0HjJsBk5xRxw=
X-Received: by 2002:a17:907:9487:b0:ae0:e065:ddfb with SMTP id
 a640c23a62f3a-af2f6c0ae2fmr725433866b.18.1753355709200; Thu, 24 Jul 2025
 04:15:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org> <20250724-pinctrl-gpio-pinfuncs-v3-9-af4db9302de4@linaro.org>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-9-af4db9302de4@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 24 Jul 2025 13:14:32 +0200
X-Gm-Features: Ac12FXyOn0y78pX82gZjLVt_m4TA-GVnUEaS_-xxL1ntUx22Wj5veadNWvnjdU4
Message-ID: <CAHp75VcEX6FBzAu3+-5iia6Z1+kSQLYFGp0FnO71gXwCF+-wDg@mail.gmail.com>
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
	Haojian Zhuang <haojian.zhuang@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 20B3F120007
X-Stat-Signature: bmc3gbku58cgwd3fa5mofq59sp6bk39d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753355710-93090
X-HE-Meta: U2FsdGVkX19965vNKH5DI8erb7Py/LeWvBta6jqM5UzCtW7ezOAb/tkLjXySPTkIF3IMjy2oyGWhekUJx6GmvROnz5psA8l7SjaHokDaiPH7/XX1GzJVVIUPI6GXv72wcfXaAfQF6CxDAPWEUWFn6kUmagWc7XIzeProa/Imrx6KmsCHIyBCJYvs/eBYu9Bm42a3tsMjmB6dKd170BIkC0YpWmw6P5DMx17CBTYAHREMNU36EByC2F850KscMgZVNQmkopzMmCaOI1Sstt5nEzlH5ZCdrgtW4fjnDIcbDhIKHHNMIdbHEnkILwPMNAKwuaK8cxAcMPU6L5u9+hXEL1cSVYjzmlOyeDyY+RBU1Zyiuw11S3IIQz9PMAllaXZOb5zuiHJb3TBpK1UYalS1HEx4vrSir9+gKrmt0XXLUuazEPrZ8k9BtKV8JUxOaZyhrTHNujOvHW6r9d314bRNeZJhSlEW/z4oMrAKJqrczXcy96ujJdovupxgph9EB9JUkCAtWU2HPaiFaX3FuHkHTfcVq4dFLGmt7J93SRa/Y6YaxMnH4XAqKYzqjTYPYUpjYGN8VpLAp/6DsMfURQpFcxlRMZ4bhNSVE1NmuIcac54mdeOXNRdg8MZqkAeYM1oVwG+SsS+xefJKE/oOTzzwzHUCr82ixEWb4xNj7IO3qXlS7T+w+INJG2dygdFHgy10EhAOyG2EYuPh/ZJmYlfxsgQC4bHdo+qr8pxuy5+ByAVS357Pb9FBWJDeW8/mGzQmBqO0scBwDs6jLa/4i8TTEnNa5/w9FEaVVZWrqwEOaJSKjbCfLLbfuEQl0d+JK/2hoydC8o2VVbg2m/Md3UP6UQ6ezdYqpus8v4He9yG5rlWDCUChaPxvrNvRVSivVy4UsMNvLtjS2CKw08HyWTOpCnTm1E/sL12lHR71YkPb6Wf2p9ALkjEnFXqGlpCzMNeXEoyJqftREk96PY3wNAy
 wCzjsmrU
 jRiLDTMv6G4/NtxtZeiiuLSQjKBy+Iz3gPPA7YK4JobP3JAYDCnNJXrAchr5/2zHuW/ZC+CV9NDvLwR+K55XFGBOoUjNaJCUxoECQXppq978hPKHd6DS0C37YAFPIPQdN4QmRUKZdFG4s2EQP+rFq6SKcX69NpWmkiuOmBYlCHVy8LH0=
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
> With all users of struct function_desc limited to only accessing it using
> the dedicated function and never modifying it, we can now constify the
> return value of pinmux_generic_get_function() treewide.

I like this change.
Reviewed-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko

