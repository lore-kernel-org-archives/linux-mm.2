Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F5ACA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F468E0009; Wed,  3 Sep 2025 06:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F348E0002; Wed,  3 Sep 2025 06:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59DC8E0009; Wed,  3 Sep 2025 06:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1CCF8E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:42:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E01611A3B1
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:42:06 +0000 (UTC)
X-FDA: 83847599052.03.28EE048
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E508120007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:42:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756896124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DICLpeLEk5QfxI0uLHQeTK/2wiRnzmCNbLnrX8FqT8=;
	b=tetzBRG/lhAO6ixNKKpoHhy47pCrTj+Ez9QZqAv2wokPRRPPSckDTDeSwknTU4pebChbHd
	V5axvs7x3MQLL3PqIQbDOaWq0T1k/0KxMFaFpX51Mwb3b8gAngpZtzxd/p53YfC5LcPwb6
	kK0/rVm+tSu1U5yfLmobxrVL+NCYGe8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756896124; a=rsa-sha256;
	cv=pass;
	b=YgDlw1bGBgpWJLD1xvtoJTvzTaioOJJcI6i1IdnbdPaNMVMrxwn7YfW2kVMuaUWmjNV5jW
	Xrda8zO2mFbpbhYb4bVJrAhQSXOaCb1ExV83VYM9vF/DBDVzaq0cYYaflNZqZ/OVHSaikZ
	8Si2jMJ9jfW+U2DwHJnnKu3hm/A8hFQ=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7E871A05D9
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:42:03 +0000 (UTC)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E13E59F1D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:42:03 +0000 (UTC)
X-FDA: 83847598926.05.C83A8EA
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id B038B4000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:42:01 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756896121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DICLpeLEk5QfxI0uLHQeTK/2wiRnzmCNbLnrX8FqT8=;
	b=nWXxCDG8+/InUBZRDXWHntFWS8TG1xvA3Vy88nYu1lL+stOHpLjYRVG84i7p3TzzIdNvM3
	2QJbtm9JdJ9YTzJSi8s1S2DalPGfjxje7p8Qb7vnxDxvj1QqBW6r9QscQ648/YxoCZ8KIF
	K2Bd+T5aw0Ehg/qjKD/K3Sfm2mZZ+io=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=NmwBuGAd;
	spf=none (imf27.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.52) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756896121; a=rsa-sha256;
	cv=none;
	b=Wmq3kNm4q5IBQBVnEsT9JBc6YsPTEl2KaqUA3k+VaC3QngeqOdJNqv/I3iyxMDU0jLH01F
	pXygN6h57bNFueq4RpC5aKXsZlaQ4073PLI+lxwlGtR0nnVH1W0SYg6kjaN4Ocn070+hlZ
	XDi6l5HTgeX9gzMV70m9ehkCg0xYTN0=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5608bfae95eso562777e87.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 03:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756896120; x=1757500920; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DICLpeLEk5QfxI0uLHQeTK/2wiRnzmCNbLnrX8FqT8=;
        b=NmwBuGAdpupq7eynkQcyXaTdIT8G0eQwMVpogapC2VRt26CIwm9P5SihIXvBubV9nj
         IsFBx99EekRZ+nfTIfcBOYeVOEyInK3hwG0JEIbdrqGROzJhoXZ67L3YmYTYv/hgtZHb
         G1ZA2HnQfNxmiEywvIMEGk5yFxbn9NfJ6gEmKSZmKbgQoF1FKOCiqRo1ghcj0LyHUHa4
         Ti5TElhpgi1ixdG7q94p1WsrruWTeYJM5NEVs7A+hUmDjfMztjZps/TC+sO1s8Xu1Mc8
         h5wCrKiYa8LnXRH8pxuSAEPA4GWvmxjHGW9CEcvI9UPrHZ5n7OuAOdONEr63tDgNs0M3
         JI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756896120; x=1757500920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DICLpeLEk5QfxI0uLHQeTK/2wiRnzmCNbLnrX8FqT8=;
        b=ePn24ypnhDb2piqWzNdEgLqJAe84msVif/myxxUsH1NcoxDLOTcp4L/9vhJS2DF2WA
         u55Odqig6lrAmNQ4Jvzbt3xkt0wiX67bYyoWg4Cd3QdzX0ns3yUqvqzA5QxwoqUFaqIc
         7PqRTDrt07ThqmdcmMO62QxdWhazxvQ0NdrRGXI9ZhQQPbeJo7zvs4kWwsrsv1n9m4L5
         HICU79PwBg8yrV7cfjz3x/ZfsMwHRj3NYOv3RUKsA8UUr6XF8SdzU3z5VzIrcq4oZTic
         vfbXzAJAT/xal/RJ4C/A9ZK1VisZHngnFqh66zawj4rOTZP0/8mIqfZZQ4w+DohyJj5e
         8/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/e1zOox/6ot+67ftFN7HnY0MKaAmudcQdddNQhyryJH1dlSfYS0ndh2/VowKBvBNTIC7eI0l13g==@kvack.org
X-Gm-Message-State: AOJu0YzMm1xAAQV5Hk3E0JTZb13tx89RZWC/VVaulIG3mAllPZmXHwaW
	R9/STnFKON0/9iEEALDJNr/bK0jD6Vcegrwwa9E1w40XAeGbEgie9BknVtmXzpG+LfuZ7klOoZZ
	ul0OLuy3W+GyEUhJTsjPe97NhvJVUAwTA3ANEFk/Z7A==
X-Gm-Gg: ASbGnctYWIBiKvSWCesF0dqPVZSrWIpJ729Hn6Ovhj+eYZSRIjCni2yWjgAT9ff4sqm
	CrLRztmYaZgmEBnE1/PfFfXO7F+edWHJ8MWFA0aCzNa9Tbp0XBl1OBqFaDNrotb1ky52EM5888h
	qdWTNfQzFxMq2VJnPnR8FEsSv850KRcBrGtsbYnEDjzUAAdRp8Vq0ypTgfImHjPIs/F4pMpXKy4
	IqoFJPG1HHkyYZpMGZNND8VVy/JXMT3xMbObFg=
X-Google-Smtp-Source: AGHT+IG+m7ivvcbSy5vEIztmUhS+t7hNv39lHZt0A7pC6ogTKWUtHExG+a5EtFY7oJjunqJek5PQQ93pvgc0Giy7D2Q=
X-Received: by 2002:a05:6512:2447:b0:55f:6adb:b847 with SMTP id
 2adb3069b0e04-55f708b1b9cmr3479644e87.13.1756896119817; Wed, 03 Sep 2025
 03:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com> <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
 <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
 <aLgW7J-j4nn0u8uo@smile.fi.intel.com> <CAMRc=MdA21fwnamymG6YhqBjKDso_nJs_4xefPNONQNfEcPHXA@mail.gmail.com>
 <aLgaoivmBUgoeO6B@smile.fi.intel.com>
In-Reply-To: <aLgaoivmBUgoeO6B@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 3 Sep 2025 12:41:48 +0200
X-Gm-Features: Ac12FXzqWEtt2S2TE9mSxpi98I-TDCIBZvSibEo9i2pyKL48Vs1B0BzDGCeR2o4
Message-ID: <CAMRc=Me84OX=UEmAXxmwE8oOH=1UBsyHe-7XmU0c8a2gG9JnCA@mail.gmail.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, 
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, imx@lists.linux.dev, linux-omap@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Meta: U2FsdGVkX1/rJHRGASGedgCGxuq87zSxpPHELpkg2ocD/Re1HGCdrRFXLh7pDFI1JCsGZAbOsNsEmBmKDIkJGKQP/OPMA6T9kKhzZWRpjbx6uMZuo4o6VvEdtwolKv1T8qZrX3MIaAB2Zw6kEYJxACouwqRy7T8WYLwmXQ3Ek39EF7TJ2mqNqnUtGU0YbomgnSxguMNOUcVQw0r53bbmEtPw7Tfgf8we7zYqHqBF0RzIN3wo49mtn2+4L/mSMsukYzkeKYck9R9D2IM7o/i8dnLDKNnQeBk+IEv839rhxnuO1vH2QBhxUoWXng7TieQXQap18+gSY+72xhALlen7zoxuxs6pNIXI1TQWaGlNI2wc0zRreAiYmoI9mLXNWfNNvLiFUpXdTqfnQ51ID7sYuFxPONv4mc1f37+mKgu0KM/bmHXGIb6j0BxnU0MvTosAg2oUy4aa/T5C4cuRnLluTi/cFKcxXdfAIRZmz/GSJJQ9tn23mlj/eNy7Umws+fITZ4VxHncFev0hCrRD4NVXYa3wZIWso+6cKIxmmUyADrNFQscStRL8AHmvclmzC4/ClYr/HasYegc7UYtvzS5CHocgSwu2mk/YIqjSWb2enF/1Rgrsiv+xTrULok+VCtH3HLK60Mj323JOD2c+rp5ISEbH177TulPujFlWADOf+euQx5KwQpy6G4jYUVkUs+59KC82i8t5EBmurl2sUM41qfFp+J81hZvxvnRykvKLc3NpOOpozgQ106jcXR2zEwEUeWInhwwKix4/Gq6/KzH5fGk46E1xDifOJ0Y3IOCxbKHwidaX8Qo7gMsZafkthMRr4CbvEoAIK7j6RE9jDdTry86/vDQdQ4rpW6v0bFqRxFh2OicM8zES1q8SVyHeRRJzbDX/D370ERWNbGFupttqg9t91Pxgp1eqIiXd8MOn/0hMkZ4cq7nO05hdc3fqOU2YZ96oRNoqWMk=
X-Rspamd-Queue-Id: 3E508120007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: r5opap7xx8kiwqw3hq3kads9szumgk57
X-HE-Tag-Orig: 1756896121-879247
X-HE-Tag: 1756896124-356878
X-HE-Meta: U2FsdGVkX1+3E23QfC/+dBB+ckkweaYS+X6xwKv57DFJuRfqTq/X66sUSBSKOjPzGpcca4eah0wGGmSg7bZD9BThiv7DtL/HatYMjyGsVFcPdi2UpDQfw/M8Tn4R9rfNQx1I95q9+4tOy4PrUHeA56Ml88yVx1/G9hSsFha0Ym/2j8UfXuLGhCQq8vZFslT4m0v/e+qhHKo2So9sh+GUS8fYweqxkvFsRn4LiQH2dqb1q7W0b8J5jlA8smHiSBYotP0NdKXiT4Y0rSlvc7tWcVHjb9pJtb570dnxHk06TgivyAwlXgIImoJv1mEwF9+W/JEJuB6oDoXA7EIovySFPq6DAbq9fI0j5H6ThExJOOdug2kMgyFuTeac10QyjnZq6JqMts3xdsla7+ug0PYw1hsyP6PtYs1THqHoeM+lTForb12V7G7XemOGoDSNDxWmZLqso3f7pHacqhzsPK7552xI7Zoqv5s4J2Mb/CpBpQh+Ks0ZW5hbq58nckAuX322+S7oMrOMid6Bke2fVeACKn1l/0PZRnpmCTBs1bFWI/ax1F/B+2YIIcJQM7nPuQrwb05gqxz7agBxb8IO3HH2GbjD/rU9rkklfi/bSCttMDmX0nDbnA6b5QGSui9ZdK8kRIfDsBvJN1Is5YFfswCr+To3CmUI57rHzk0AQHGVrs6QOVynxfQCbrKw1VhfI2CoFnMwxQNEduNC7j9NOhcvLvY0xJomiLxPXpcaJ2ADGqs/sYDE+Lt2UF/KIKnj8xJ0YmMTSBCH970z4AwzlsgjbtZMwH0lQN/bBV2pMm5i4w+S2cGfiye4LgTo6fxjt0lnv8hZN0P7mLAJpqN/9bmdq9iKFBvK1IIFPvmlonAC99zSseWrWHlociDmlgyHoolpIY3eT1MzXnSl2bS1bzLMyDbuVMdbUMK1vVNXxPJXcc5girrIF9WYBRbr6YMG3bdkkWpNmSuBGxrrKlgVscJ
 DxCh6XGe
 Y3ufF1JmoYBQ5JAwJtL7dzQdf16nn8VcIJWAVxVc//hnRD391xFbqyQm6dcLmwNTBAXFRLDjdVRPX7xX+0XyZSsAJADyLAnCjXIy28fLvDtnWrtYKzhLsHtDXPMq2u+txc2kARkaN6RSU+3YbLPrrTlee6Ma6N7WmdHiJaNNaVM2rAnfIZG5SRVGrWmftI5FdMB/ED+0vGItG1rqLI5ILyTj2S9FwtujWHQYwMXc+FDoeqBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 12:38=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Wed, Sep 03, 2025 at 12:34:00PM +0200, Bartosz Golaszewski wrote:
> > On Wed, Sep 3, 2025 at 12:22=E2=80=AFPM Andy Shevchenko
> > <andriy.shevchenko@intel.com> wrote:
> > > On Wed, Sep 03, 2025 at 09:33:34AM +0200, Bartosz Golaszewski wrote:
> > > > On Tue, Sep 2, 2025 at 10:46=E2=80=AFPM Andy Shevchenko
> > > > <andy.shevchenko@gmail.com> wrote:
> > > > > On Tue, Sep 2, 2025 at 8:42=E2=80=AFPM Bartosz Golaszewski <brgl@=
bgdev.pl> wrote:
> > > > > > On Tue, Sep 2, 2025 at 4:38=E2=80=AFPM Andy Shevchenko
> > > > > > <andriy.shevchenko@intel.com> wrote:
> > > > > > > On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski=
 wrote:
>
> ...
>
> > > > > > > > The strict flag in struct pinmux_ops disallows the usage of=
 the same pin
> > > > > > > > as a GPIO and for another function. Without it, a rouge use=
r-space
> > > > > > > > process with enough privileges (or even a buggy driver) can=
 request a
> > > > > > > > used pin as GPIO and drive it, potentially confusing device=
s or even
> > > > > > > > crashing the system. Set it globally for all pinctrl-msm us=
ers.
> > > > > > >
> > > > > > > How does this keep (or allow) I=C2=B2C generic recovery mecha=
nism to work?
> > > >
> > > > Anyway, what is your point? I don't think it has any impact on this=
.
> > >
> > > If we have a group of pins that are marked as I=C2=B2C, and we want t=
o use recovery
> > > via GPIOs, would it be still possible to request as GPIO when control=
ler driver
> > > is in the strict mode?
> >
> > Yes, if you mark that function as a "GPIO" function in the pin
> > controller driver.
>
> How would it prevent from requesting from user space?
>

It wouldn't, we don't discriminate between user-space and in-kernel
GPIO users. A function either is a GPIO or isn't. Can you point me to
the driver you're thinking about or is this a purely speculative
question?

Bartosz


