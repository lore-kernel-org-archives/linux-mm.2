Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A997FCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DDB8E0011; Tue,  2 Sep 2025 06:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF478E0001; Tue,  2 Sep 2025 06:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFB48E0011; Tue,  2 Sep 2025 06:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D91FE8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:11:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B7A213B2C8
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:11:05 +0000 (UTC)
X-FDA: 83843892090.07.E9FEA07
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 916681C0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:11:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=segwQmBL;
	spf=pass (imf20.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.50 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756807863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9/dg3rMdImtSDs9qVPDpc7idBTBiPszJRQRzWERi5Y=;
	b=0CK9M8FmPxJIC+YhQV0qxAq2rFNjuV8MI3E4ve72rYu6ajLAgOdGKq6IgahTOo6KhDeV2p
	w7hQRTLic2JWJMlbKL1x1DG2dpIQ2RST85keMIc6EmPsmONAHl5+5/MRNmPi0cEO2buvJs
	wFG+n+q2cnwArjPwUsl2gY/WZAOtGzI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=segwQmBL;
	spf=pass (imf20.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.50 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756807863; a=rsa-sha256;
	cv=none;
	b=uKspKh4E8/oDp5pwfYwwBQ4F3HwGYjJK5j92aCpT7WwH1TjAxvZO7ta19TWw8r40GDVjE0
	Zjn2E1kRA8iYlCI3FKZunPDxhzxBIkrPVMfRGQXpY5+GIlb/X3QAHZgbv9G+MwjRxRdJfW
	71mgsaw2ngyXk3a3PrGrtxxKutE1Q2s=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f7039aa1eso2680090e87.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 03:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756807862; x=1757412662; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9/dg3rMdImtSDs9qVPDpc7idBTBiPszJRQRzWERi5Y=;
        b=segwQmBLJJWKU/h1fp69gH2jiGN9Cf97vkJ+s4GOxLTxIHEMgjX2HC3BjJyZmMvVYh
         cVNYBsymSvlOtQngVQ0i9KEvRGQnpD2NjuEL9s2fjMpLj35Dnk2kMldBGiwIJTEpP2sp
         vY1n+kw3j8bp5FkekzgF1x+ut2OvEWffDYZeIybWCcO7Cwtelhk/lfkCD96486nXW2Ta
         CKVmc2y2p+weCp+vVPg2sK+b9pC4HRQ8bYSP6muYuTGLU3vxTv+/Df5bQQtskTPWRcx6
         BeR1fIJQZn/fGR/6dOFUPxsE23QFa3ZE2xR/dDtbPWhLyM2vaAynbX6lNepMeOsl0+hE
         q7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756807862; x=1757412662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S9/dg3rMdImtSDs9qVPDpc7idBTBiPszJRQRzWERi5Y=;
        b=qBjmtfSQVyWt9ZX7bM8zj80W/hYwslWtmwK2pb4XZkxfqpoYDz1BvcpljRSXylmt6O
         dOLD8aTC9FQK4f7OF50DYnKSXsBwwW4zTx+69rwLQzY1PKnzc2eOvjUCGnuaqkrN+Xdg
         RUcCo8pIIvYYjBvh/m5TtG3OUtxF05ofEK0YgNdzmB+8tChCH71ZC/B1U9NnpuhFy53K
         FOtlNrVXdKnFcgFgpEz/CA3ZvoczxDaRlEvMHtCQt7w8cN5yjxt2XucMygfH+/376WCZ
         pfd103HM3vX/eBieef5We1QjQvBW4n4pZ9aZ4fQG7DnP/NJehSDM+cR9q5BapDcZbAsB
         S4yQ==
X-Forwarded-Encrypted: i=1; AJvYcCWN9Ri72NFEZACdWFlj3k/BeUkzUjlOgDIgEd98pQNo3UclpBv+fGn+FM099XyruMJkYgqsx9ywYg==@kvack.org
X-Gm-Message-State: AOJu0Yx34se8vPKR5ybVGnjn4S1QYAgm1fImrJZ+GpAFXvYfnGHZMeFd
	1RiQKIbsO9zdqSNNJH6JBi1wEn8vsYAOzLucAXnUa1WbRLSESFFnsJYZA+yfBkG1vCeowIpRD9+
	VyLNYfNzh6FuP6WKI4RGiNH6mlFCYvKCvqLo7sJB4sQ==
X-Gm-Gg: ASbGnctpqYgSZoXiMEtd789Z6OVfJrBVV6ZkUPFaEpugiaY1pMRYMVPwG23ZCOMlMLK
	O9tz0cRx341vFER+Hwx/4B2doS0YuoYOX1/AAmB8qVQC0TJgGBpx+BTsTrBrAPRJRwa0Ek30bri
	eE7/015LKfMu29KPkWo9+IR/1ANNLy9PqMbiYLhhyHrwuXxnzhD0ZhtXu/yCvRze1HSz0DPp0Yt
	BXaDR4=
X-Google-Smtp-Source: AGHT+IGvJOVNe+LUFvOCbgL5wgN/h/Cjvl043KlTfsb1COy3EuiSQw/TerVuRTUEwrGuUBs+VE/GG3RycL486iAnqi4=
X-Received: by 2002:a05:6512:250d:b0:55f:34e8:b1a4 with SMTP id
 2adb3069b0e04-55f709dda1amr3184317e87.56.1756807861583; Tue, 02 Sep 2025
 03:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
 <20250828-pinctrl-gpio-pinfuncs-v6-6-c9abb6bdb689@linaro.org>
 <61bad868-d976-4f49-805c-8d14d4d8b3e4@sirena.org.uk> <CAMRc=MfB_3e0sjCpV+XaKcKvit7Opk5LczH2wsxO=RftrAabjg@mail.gmail.com>
 <4a633387-08a9-43c8-81d7-488e7222aeda@sirena.org.uk> <CAMRc=Mf0dOvwsWb6uraCQXeauLYP0TqY6xsQnV3fM0w=wROW+Q@mail.gmail.com>
In-Reply-To: <CAMRc=Mf0dOvwsWb6uraCQXeauLYP0TqY6xsQnV3fM0w=wROW+Q@mail.gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 2 Sep 2025 12:10:50 +0200
X-Gm-Features: Ac12FXw4LKCvHHNtKGBjLfwABtGCHq93WPj_v3YPD6EUsw9OMGyVKBEoUj5pgYE
Message-ID: <CACRpkdbrRc6E5idzkdN53QPDCSGpPUfdjmFmEFsS3g+v=cB6LA@mail.gmail.com>
Subject: Re: [PATCH v6 06/15] pinctrl: imx: don't access the pin function
 radix tree directly
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Alexey Klimov <alexey.klimov@linaro.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
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
	Danilo Krummrich <dakr@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, linux-gpio@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, imx@lists.linux.dev, linux-omap@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rwsmqg4771ubpt9rwx786cafedidp9pe
X-Rspam-User: 
X-Rspamd-Queue-Id: 916681C0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756807863-592600
X-HE-Meta: U2FsdGVkX19D+QabAqDPH0q4plgXfUbuDOeib+0oJ5hNxTulS1TX6P3t9EubbiuFTU9I3z9nVwUZC6uYkLg0FJEQl0Q0o4OyvL5TrrPKiz/ZkWaehOH5U1zi0q0qTKU0fwVaFuYfjSAsNLhnTgYoHuHC2bI+4YIRfLfow1CrcnDFlSCnMOvjfaCDqKrtqsos9fTsJ9GtXbZaByoa4vrvJWeF8J4xSdVZGlIkyx9qZxjuds21dGR5GHDhv/Psbvr+YPDvG64sXO0VVB/ZmJg2DKZFMrDAXyMScRFjD9Iosiq67T67y8ur76PA7dk8e1P680EvEZJLcUFKWjvl7T/O2TW0PEsQl5wg8Y6bDhmkfGJmqzTnvgevgj3T5bCieOR0lr93U4x87hmBEfQ0tAnjafmcME0PCld0gBGYxZxEmzf/xHWM+lKa1neZACb9FpY8nD7cs8R3IYC9Jrdmltw3I9d2GwR1Hybl/WmUsxM445vVTDeWC5IJhtQVXIrVELboLO191REXbOZyTZFa7bW5A6ELKFe9o0rIZ99PXjNbLb2OcvWdlte1LBxbXEN09NuAXoTEe+rSvzCCZQlwXAGZ27X5bR3BeywjRXeHTvaPvXbJ1ExZ3gVFCl+IoPqgnvSe3Mozbk8Trp5kg2aKRmtWSXyaeDNpwNdnAQxsSOuQbGZWu/V8BP3RLCQrOpnylUZKzuNxPzxfAzUTwK7y0KunkFNrL/KoHR5hxJZ4y20CKv+u1EOeSxQfdpzgShEPSFTtbgNtDrayXdHpJmBOakFthlRvLYyUppTqiCpqp03mghp9+pld6e3psriK15XYEpfH4UwnR1a3eiAnTU6PxFbjOxrK1fjBYn+8qPPCwcAcvpfsVPJFNjdoOQ/q/bUxJ+slwnUfCgUZkNETkqGHzZk2r3ONqjD1Bj/7bYaKeSEsEJG8f0Cpp0F9gtF07bc/6Rp+w+8E9rsZbgJsx+0IUMu
 RK/aQkB5
 Ks2069PCu81gL4LfCVYYSq6UfjvxULeVjHiuIVinfUtfHewI1VcXvtkk7t7i+R4vZnKWeWza0Q4S2ZQBnFqBhbplfk6Lf9UhX+HDEIActVohytIZTBZ5V1V5BmFwZarHymAIG8FrTeFw9iwEjE6IygKlqVE3zCncE+2CVEAiLiBTbuS7U3XHq2C+sJYDJXj28QQQEHmhCBwyu9Zk8cMkZ3eCg+I2++vVWdmj030exkPA5u69KQzju1nL9cGH8RP/eKR8XLnWCdC8LfWWY4HhC5oG+wV+0J+NwM+hU9BY0atxAjOO1Pel4dYnzb7uDN1DoNKmOB/Siw7cbN059iGQh9NSXGoDCe9xQF6SG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 9:22=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl> =
wrote:
> On Mon, Sep 1, 2025 at 4:37=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:
> > On Mon, Sep 01, 2025 at 03:20:44PM +0200, Bartosz Golaszewski wrote:
> >
> > > That's not a lot of info but it fails in strcmp() which - I suppose -
> > > is the one in pinmux_func_name_to_selector(). Any chance you could
> > > check what the value of np->name is in imx_pinctrl_parse_functions()?
> > > Is it NULL for some reason?
> >
> > [    0.628245] imx8mp-pinctrl 30330000.pinctrl: np->name pinctrl
> >
> > https://lava.sirena.org.uk/scheduler/job/1758947#L705
>
> Linus,
>
> FYI: I reproduced the bug on qemu with an older ARMv7 IMX SoC. Should
> be able to debug it and figure it out shortly.

Awesome, thanks a lot for your perseverance on this important
patch series.

Linus

