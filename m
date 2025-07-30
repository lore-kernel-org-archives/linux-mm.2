Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC1FC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3496B00A0; Wed, 30 Jul 2025 05:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB556B00A1; Wed, 30 Jul 2025 05:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0526B00A2; Wed, 30 Jul 2025 05:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C96F56B00A0
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:54:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 727921DAAB9
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:54:54 +0000 (UTC)
X-FDA: 83720472108.22.9CE6497
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5A1E6C0004
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:54:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=yCYS1csJ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753869292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6vdhp2EWkPtq+IAr0ObGae8XoJd1fUV2G+NSQOgeB0=;
	b=TsRZIAxU5X8IdOANQ+Nt63QCM3r7kcD5l2MGCzCR0fXWKGLj8Mp08Q72JbvumGMnxZUA7h
	Z4r4z56oUYl0SX8m1olYdQnA78YAkT64QZlhFYxq9WhEGwGkltFqhR6xYXUQxzIy6IKVOH
	w8Nw5rHYBXyNL5XzR7X71veDMNCX188=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753869292; a=rsa-sha256;
	cv=none;
	b=IsRJ/xHtDd38FOuqRbxs6UjhU8+Xmn6A4mY2VjkE0H4Dz/oKS9j8OSaFxkrQOUT6aLSRNs
	796rO0Ye/rySwAgBLLf8D8PTQZE6aMcnqHGbUPhTLwiV1Ehmi1B6LiNMl2Sf9xs8CaNGOP
	gCoGouXMzA2EN9rqalpbkZSCx/Dug5Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=yCYS1csJ;
	spf=none (imf10.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.44) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55b81b58eb7so517329e87.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753869290; x=1754474090; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6vdhp2EWkPtq+IAr0ObGae8XoJd1fUV2G+NSQOgeB0=;
        b=yCYS1csJTeXuAw54nFJrShsSI8c0KFPX+9DV/AvcoFl1g4nsPjGLsTJPy2Gta/RpQq
         jZPnPfQbLHNQWnyUhEzLLi4SKOEao/OPum4xdpAew0t7Qo5HB0/Eb/6CU8Ag1iaEx2Lr
         wCBn7sEzDz2Ycrb8wXDSI/uN61fJlIQIbsxkNeGXTOfUqAyzpSL7IOcbrHi73GLhfHkH
         BYoDP92Db8CtznK8EUI+evEc8Og4RUzop/TPELwUCyQiNn8k6/Dd/sTdm7tmWfcAM68q
         XaJyogcoL9Go2r8DdA84bH2l1/FnZMosd2x/lDEY8t4j34jtmTopaaiMioV2zq7xFzYo
         VmYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753869290; x=1754474090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6vdhp2EWkPtq+IAr0ObGae8XoJd1fUV2G+NSQOgeB0=;
        b=NHeaN7eO70j5GI4dpE//KNO0UymDkQrjlhKG/cVp9gKxruVBfLDNoyARZRvYQHjfob
         ILzsDFXR5jExBplLE/mqoj/YXmAayRtJAQ4aId+YPGh9IiIjrE5XPTxcRo3PFpaO/8u/
         SUU7OzrNTAefjbyJ6dnviWAJ4zZ0tgqJoScbJ/KO9jXW4avGsyig+wMsSQYghvVLNZSa
         fgxikySV7DvpTsz3P6eICxwesKebfQeHG5QoF7S+fTkJ+P3MiUHme28zZk9bsT6arHe/
         Rh4n26RusytzJ6YmSpeDdtJvAOUF2LRwbxOUx9YdJ03EM7PfZA/jRHwbzM4Qv8bfYQZS
         cWYw==
X-Forwarded-Encrypted: i=1; AJvYcCUO1YXqh4CcBtcyEivV6Mti0OHCb1C+JkHUy1MK0+0WMacktWin43BvfhM5Eps2rizDERT7t3ndxw==@kvack.org
X-Gm-Message-State: AOJu0YwhebRUwcoEkGVx1DHs9m8vcQCf/vsMT8NfhlAq7MlkpyCGNK0Q
	Ps1xKN0/6iluV/dF/mK0SZvze+bS122dK/e5cV1vtvmLNzDxazp2wHKXjMTrnh9GP+/A2pe1WXx
	uB6zGhFc7B3RTxYYtJfTaswR1uWrGaL1ZR5KQW/P7iQ==
X-Gm-Gg: ASbGncvQbiHKcgwD0onYF9oY0ZpIFvXWUtOhRwSGcrnh+NmU/e59M7gyuzLlMfQg0xE
	YGLn2gOslF+OTSodIu5b1NFA8EPS/gyr/+IIwltCWbjGI3JmZ44TnNSlpMCbLNRoZhpnl2EK3yB
	pRg1aIYSUp7cDcRrzzAkkNXAWGpwSVB9PQUSTbKd0lpieg4K/H2Sb8jv2eBj1yCeLL/znzatGU2
	p+OwZnhX2KcVahCGtjXz55w6s2BIQSLWFVBF+s=
X-Google-Smtp-Source: AGHT+IFD0mC+adTu2tQIUqoYqi4YbEm6lb9KfHl4WlQUhUVwQ9owZPBnvnUOvhF+89ksRVwAv/r0YIR9B2aVVdKhoAo=
X-Received: by 2002:a05:6512:33c7:b0:554:e7f2:d76b with SMTP id
 2adb3069b0e04-55b7c0b0f66mr939851e87.56.1753869289592; Wed, 30 Jul 2025
 02:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org> <CAHp75Vc4vsJh_-GbP+YO50veoGoGtfAPL4tjcF+73uophfmnGw@mail.gmail.com>
In-Reply-To: <CAHp75Vc4vsJh_-GbP+YO50veoGoGtfAPL4tjcF+73uophfmnGw@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 30 Jul 2025 11:54:38 +0200
X-Gm-Features: Ac12FXyouWksKyGI1Z-cYawOTPPQ3IbuMxJxWat2oIDr-ST0nxIlLBCifNIDusI
Message-ID: <CAMRc=Mc1ophkofB6MmtD4adBAi69C3JyovM-S9YD_y7UA3V1qA@mail.gmail.com>
Subject: Re: [PATCH v3 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
To: Andy Shevchenko <andy.shevchenko@gmail.com>
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
X-Rspamd-Queue-Id: 5A1E6C0004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: owrsas93oampndzqa6786ribn3td1knu
X-HE-Tag: 1753869292-74569
X-HE-Meta: U2FsdGVkX19oqPujq/6cu9YeHj8sRMXZYeEQbfiUzpGvo4xFdsoh5QmEPOjH/6HpYCaCUoyIuM5a06G/VjK4xjYb6BIZq1kY56mRZ+WDEt7Yia9UGp0gTndEhaaio/yGYcY+BXZYCgWIDjfvTQKP6S4/TGfpEaCo2hd1PMkoTxDpN+lShZL7CJ0q/bhdRXA0++z/Zx+Kkwa7e2loSf1pYmxYFAmFVAsgpZVjXYIRFb4sNQjP6AonwB4sF8RLlSCgKXpbzXHKIFY2T/CyDtzh4di/gL2BvbZW4lzKP4BTFxP3F6p0SBZFGmtU+J23jqDVADahtVGXGiz/y1+lh8tw6pEuAy5T7UZC4TCEdSJ5okCuslCesjLACr9vF/TpVwyqh5qol20Nqn0pyz1K9Pi5JkEFjjLkRBEUB9TnaHrTw18BFDRNsNHWhrlf01S2TbNEDHMCbQ7kMy+JYbzWdXDcjbY/dqfY7GKqj7kZwmNo3jEvmMP50WgWGFXyIu06dGQJvKHgSQ5xs3l2rFsaO3twnKYuMDxFMY7zIniHhO0ChxiWmv+Sv3JPsZvyTYt66f470N1jyd/OycQb0iRdI77+IkrVq03eTy6zqJxqmNnjxVUE/yPDaDR0eHaDdCmRMt/s+Fapn1bFUh5hqpXVfB7unQ6LUiGRbNcBxOhojpwLJRIz9+4gaML8Hz16h6O0O44EtAnuckRtFc0DPEutyrTazqpQYZTMs2hxqXs6Zoh98QEsxytggUx46V2YjruoxorK3uuH2XU1908nrOYGmcsXTClzv7jU23DZg2A2b2S5HBYh+dZlscjE9vbjf7qT5LUhrPnGEQDTZviYkorFkf2Tisuv+z/v1NtSQoTqz+/0NP1dTtaeXKDE4alzw2tJ1VOIn2RId5+vzd7iiysHoLxq2ykgQI6bCDg/lO//zaxBkbsXPpySzqfLt9tsKP0H/poJ0v8wHQx6Ckj3s1tbbqZ
 mxLDOOTJ
 ERjNmWuM5KEqro/eHbvEKQkrqhFsXAimo4oND+8dM45r2N6+g3t/rLzVc32vVyw/sSR6ijTVhSEZ3sQezXKuf/BOAp0OJOacLpVkbmbSWz0pCiCQvbqRGvB4G1iO6QtlLKUf7nFmRpRN241BXrKN30bk6GpxvYB+xXggnsnXWj/tbofExf11//jIK6sVcXWJsbI88rOQsSh/ZmU+/f5ra4DpZX+WqJZbB6mU2VrhTq6Eh8eqyn0FeX3xO5qxOyn+2yUjVuYqEBaBQNljEehsjHl7JYTRZpJsLskYoK8SAiMan+D0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 2:22=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> >  struct pinfunction {
> >         const char *name;
> >         const char * const *groups;
> >         size_t ngroups;
> > +       unsigned long flags;
>
> Not sure we need this. If the function is GPIO, pin control already
> knows about this. The pin muxing has gpio request / release callbacks
> that change the state. Why do we need an additional flag(s)?
>

I'm not following, how does the pin controller know that the function
is GPIO exactly, other than by the bit set in this field?

Bartosz

