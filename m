Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174EECA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153546B0089; Thu, 28 Aug 2025 09:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104516B0092; Thu, 28 Aug 2025 09:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34926B0093; Thu, 28 Aug 2025 09:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E52CA6B0089
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:36:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75783138E3E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:36:58 +0000 (UTC)
X-FDA: 83826266916.08.D6C1EF4
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5D40A120015
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:36:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=hvNGBkIM
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756388216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO3s8KTMvJZFdHoHnp5Qdx1sAV4PfJarnSm1ctLLZ3E=;
	b=2Hij0vpI9POL5WL1LBhCnz4aUS/aCbs2eSpyKYCenO6xFRysY573INZMFIAR1CY4rZePCu
	Bv+PzXdLOxPgvqnddhPTn+WklDDXyK4zx1K60f4ey89iYypgxcg02aZgmQebCYau0omG2g
	q1P85keDQBWfBUA+r7vH5RRNEx5fMDQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=hvNGBkIM;
	spf=none (imf29.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.42) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756388216; a=rsa-sha256;
	cv=none;
	b=H1S2rie4mI9BV3Wp1od8qs+HXVXGqc46B2eMqDqAX9JU5HzB5QR/MXuRanoqcG5RXIBvso
	JBC0zqamDo57PTVL+8w6z082zSKmcExwI6+Czrd0edgSuXYYM+a0tjtE3K48NUuFPOiUOV
	IEAgBV2ecLdH2mZ8GKHLMGsYmvKWhs4=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55f6017004dso632316e87.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756388214; x=1756993014; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vO3s8KTMvJZFdHoHnp5Qdx1sAV4PfJarnSm1ctLLZ3E=;
        b=hvNGBkIMCKQp8iSonNkuEsbJPkFTABgVLKVAum93lCtxl4MzlUq4NeFnTUiJclT01g
         F9O/DfPvWA9NoJMX16NWwkj+GEvFS0ByN3F6qCJIqa8sIAxnPfXLNCEYga9GlV2SOtSS
         Nclyo53w76pw1ynAoPRnwODdl4hRLRh2QflubdO214s62ZKXsNko/W4xKkrxNRPGe3YH
         YIG9aiXAlC43ItP8/KrDzPiB+6HSyLicwQt32QPUNJ3/aaN9FzBFJjbgAS8ULJY10szy
         463IUaO5cr2PAt/fAde6kdVkJv4XYLwTQ6L8r8AwAhIuvNcAgKYDJakuNqHmSJZvLcwL
         UIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756388214; x=1756993014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vO3s8KTMvJZFdHoHnp5Qdx1sAV4PfJarnSm1ctLLZ3E=;
        b=AUbB5cRUvzqpH4ujGGBNnEIUfsmCnndMd4Zuv2W5YRzYPIhIHsWseU1DKDOmEE1A1Y
         OoZK+Xxt1NoVJsxERzt9dRWyNeNHXK//Vq5dpJhPjUiVT/dtjTV/i0k0HCWcWfUHkhXL
         bHjM5Q4P9TdWW+Kdk7AyCaUGIcF+Yqinwq1ucGFaM8vV5uD5gVgqcLMH9iUQZG0T7CXg
         Pz0R2IvzkszniQuVn1nLhgF4yv8zqFJFNpnmAzA5hR09qv69Hh1SMWpUJz8s84zRZmzp
         joc6SzM5zVRNoTUc8BAj46xZ3nlkP9YF7x7yqaSBe9M0sn7KdIeCS0v94nMkE3lsBzk5
         v8/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUJdsFL1MJREBZTWM5fVvv7clySjnAputSxYK+LzyUZYNYawhtu7C3T7722ZrZ0JPb44fPYvrr2g==@kvack.org
X-Gm-Message-State: AOJu0YxvWeGadv4JhNfj8ush8K9EDC77otVs089CnLxbCr/joPVqT4A9
	/cV/TanaPH/1Dj0PjKnS/HL3EbVF9sUkFKgoRlTFvCc1ji9cyug+8NncI1ZtLqsd/uamHZMRWTm
	wVMXDp8dWNnPwygaXwioRZZg9WzIbfZ08N6DZv1ui8g==
X-Gm-Gg: ASbGncuZMYS/g71RSizwnBZxOKO5Q3i89VpYrAvBDoys0f4HYhVKUPcZvcxeCDHBBOO
	EJBKOQFo3RCIhYn/MYl1XHbZHcZDAqU2atwjpQcLsBTTjZjWYPZ0+gSBXmXguojzWU1F26bGm6o
	F0CSzzVzsz9vZpClWHreRXVCHQ+KSX8EkBf3YaIWYOxicgaM5OHfaSnU8fqYllYylfXgTpwaXho
	E0EADe14pzP4PvA6d5Bnju+BQIq6kEoXNHwVow=
X-Google-Smtp-Source: AGHT+IGjT2OYHV9mzILkObbuSFLpi9Xf+oP+6Uws6rzp7smTv5kAfs8i0u8RIWSnII9gINWFQq3zddWVjDxSq4eH8MM=
X-Received: by 2002:a05:6512:245b:b0:55f:51b3:9419 with SMTP id
 2adb3069b0e04-55f51b39621mr1791521e87.50.1756388214118; Thu, 28 Aug 2025
 06:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
 <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
 <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
 <534ad082-08fa-42c0-9c24-f0c11af7d5b2@sirena.org.uk> <CAMRc=Mdn0_yPXyYq4sbvH4P9-h71vEc4arLPBfSk1PiEFaB7jQ@mail.gmail.com>
 <1804d9dc-8814-47d4-af88-c819c3f17bc0@sirena.org.uk> <CAMRc=MdKgqa+vjhHvD2+Tjw5NwBtFv-0aUivi5UuEQd+n4KxmA@mail.gmail.com>
 <aLAYoDyz8Xie4Dhb@finisterre.sirena.org.uk>
In-Reply-To: <aLAYoDyz8Xie4Dhb@finisterre.sirena.org.uk>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 15:36:43 +0200
X-Gm-Features: Ac12FXwlaqUs0TeuR0_lKNQwkWNyJ4q4Po7liyAa4ioyozolnG0jRU9pqqtYG0I
Message-ID: <CAMRc=Mdd3fmKjFAfbUB-AAhx-5_CR+c7f36pePkF1k_2LDoORw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, 
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
	Danilo Krummrich <dakr@kernel.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Chen-Yu Tsai <wenst@chromium.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5D40A120015
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: efo54sc7y7ypgqn8fyn3bd1t3j8c8n9m
X-HE-Tag: 1756388216-284943
X-HE-Meta: U2FsdGVkX18L672C5R+cKzaYWXF7/s+l2O3vBJt4EgZcTREqtfXMsV2Q3DzJnjxpXQkOKOBlikvm+68oa2d835DTd3HqRA4JzUwd9wZiuO6mpQqF00eGUpSKZsxdzSpb8K/Kjmdzt5vFjLmT/JQ+24/w4pl2xAzLoqQJFPSc1YmqP/wjeyT3dpUmwmETwyi3F5lms/2KBykXOfE1/XQZ1os+gTFhOI/nBAvhyJ3P41IUEZvpz5RE1kYoZhympxrhGFDDaOQA0ZFhep5Vks8Lk/VEf1NMODg1O4zF+RCSKTqBzSQFhmqSEGl4eB4EFgaz5B5WRBGpa+b8uuKroHoZ5p6Tvjh9u37NDDhyly914mFJNpOpCwepsP5AHnDl8Kdgm7C/Vq6ro+EOS80al/ELWwJsq81z3V1HRUrPBYrjbHzzdlr2MVoNvNtBexw2MXXG4jpXOQvDK6HCSOxfUHg5v+0An0IcVMOKw02m8HyT2S5qXE8VZX9tGCVI4Crv835dkClyvs0xNlHKgCXbhSV4HdyKmb8rctJHR8M6j7ISUwQXd3K/TgzQ9KrnBc7ywbYtYNDZRjCn53H6XUmqWasvA/4CqSDUB4numPVU6HlrC3ji9bhW0xinH2bYR/Qu4UP9srNpgyC+2vM7Skon1JFRVVe2OlXC7y/OWl2F55nkUqiPQn6dbxqhdINprp4QR6unyx1OViAVSB7DKyD3BECqIpMYNajKBHd1JIIa6J07QoN79YKJEAVI1iH6fumoMJZW7yt43LY/NiEvCaArSN9m30fwJ7IWuaXetC6QaM7WfNIf29vRyD6zDFUja/85KKxtsntGamwoD1ainV4qR6zIQIbTaH7av52fgibWsX9glO4XjV9EWldWKanDHR8xhtEEYTfGg5zJU1/C9GsDunIzUwgQjChT4knPaYzuCRMWMdMC2MPlzcRsI3Xa0M5TKHEmbZVAXl5vqjUCDcjFnJs
 US8CMFoM
 JqtGI/lOlStZh0Bl1hyY9VtHBSIh4xhvcLeTCj3cPhxTGBGJ6Qj6mHUF7RXymztQLlfKzfe/ni7u6c/sMSjSZk97qIvsdWtiOilZrW9vQOBUMv6BHUP8Sw0xZH78h+azgPWGzPXfVnsybQRQQpifIGFsbR31ZqTC9pRaT9Y9K446aDiM7+lT1+QfgZ7fEvDHDi4tIsNpSTO8qOBAVSLYI0DdbtxCRNj4VsuVbGVLBzqbLsNlXBu73Jq59NwfseOmUd1FdAUDpfL0BsPXxUr25/izE66Z6f64Ah6A/342S6t/f9Ecw5qP3A1vvFjaRJucHMdbmsOwLkghtROJ5bssQqXwzXT3Us9zH2ZVZ456DPShTHgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 10:51=E2=80=AFAM Mark Brown <broonie@kernel.org> wr=
ote:
>
> On Wed, Aug 27, 2025 at 06:46:28PM +0200, Bartosz Golaszewski wrote:
> > On Wed, Aug 27, 2025 at 12:22=E2=80=AFPM Mark Brown <broonie@kernel.org=
> wrote:
>
> > > I've just got the log I linked above.
>
> > So, I've been looking at this bisect email and clicking the links to
> > LAVA jobs and I can't find anything. Does it fail to build? Fail at
> > run-time? I'm not sure how to read this.
>
> It's failing prior to putting any output on the console.  I was also
> seeing an issue on i.MX6 so it might be all i.MX boards, same issue:
>
>    https://lava.sirena.org.uk/scheduler/job/1697667
>
> so it's possibly all the i.MX platforms failing.

Not even with earlycon? That's weird. There are no smatch warnings on
this patch and I can't see anything obviously wrong upon visual
inspection. I fixed all other issues but this one I can't test. :(

Bartosz

