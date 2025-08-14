Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA10CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3270900106; Thu, 14 Aug 2025 03:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E26C900088; Thu, 14 Aug 2025 03:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1C2900106; Thu, 14 Aug 2025 03:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 706B3900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:38:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3F911383A3
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:38:08 +0000 (UTC)
X-FDA: 83774559456.30.6FC85B0
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id DFE6A1C0003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:38:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=W2xASmBk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755157087; a=rsa-sha256;
	cv=none;
	b=hjUGxyAzg/RoM5mywdGSkCibz03caDvkzdBBqzrDVusBsz7MLOE7TFaHryFnPWXv7UoWri
	PGSKRZu+eacVhcQEpzO9KHn2vmuzNcG+AxBqCSGOpqthKE5+4zbwEAm/Fr6cz+mpBV40xQ
	p+7Er7gjUDcAuDKSH3P9+e/ab/p5/yk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=W2xASmBk;
	spf=none (imf18.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755157087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0Lxf11oo0rXpVqVkWAC0Lw3oNWPIq9I531Yo7XQFWo=;
	b=qYd6wTbzbI9LAQ+ZuuF9i7C2QjNXqU8VbfQccjfxrWWjESoz4ioiSZcxt4j5GvpG7tBRpf
	CfJkTCGoEBR6f/dlty+R2F/pf6fp3Do4adOGO5sD6QtcLEMXfjTjeYkPtwl/PidlPC2a80
	PLGQFzBpWN0V99YmoizpK8EylvjzaSY=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55ce528022eso654357e87.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755157085; x=1755761885; darn=kvack.org;
        h=cc:to:subject:message-id:date:references:mime-version:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=V0Lxf11oo0rXpVqVkWAC0Lw3oNWPIq9I531Yo7XQFWo=;
        b=W2xASmBkcJnI/70E/u19qM77kz0lu0NmwXTC6ou2RkDIhn8T8RN8lCpkbfEvqmYRr+
         iIOOLxI4u3AXZQ5nFoSW3R7m7u+xoIn7v1azV1+TrECW0aBR5ADHx+n9tahAF1dP618u
         yQOm7QMaD0uI01X3HGFRfyq2JTLUb9AKRC0dD/UI6a7AxqbR80WvlLv1HAFHmWfMgqA0
         FmDEn6aQqbVgfzxFc5viwy7UQAxDAXiusluLJgOMgU5hektGFQniBQDndlMGqMa+60L6
         FtJkoHtiDF5oX8GppfkF/uJmECOiIzJmY0TkZvTRpEnmdSZMj+0Js1cm3L+7IJsT3I6n
         oSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755157085; x=1755761885;
        h=cc:to:subject:message-id:date:references:mime-version:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0Lxf11oo0rXpVqVkWAC0Lw3oNWPIq9I531Yo7XQFWo=;
        b=u2Ui29NtZ6rYl8avACneMY5MmnJdOwqJZ50g+4HXr8oYqgGemVACs/vbVywz2yMXj+
         8kMlcGbsOTSxaT6PY6HmcLohfgfBKAoRgXfOs3sh3NRY50zuHhwwJjTJvHwL9hzwNH2l
         QwcbuUwGWMPpyw6KpuP80JJnjBFzQ8DtPs0j09H/FqxyDZbjh25RfKh6aBjT2GX5JNRX
         Mqp4KwTPukcTdow/WJh1mrCQjjsXdAqONerK1KeScw1B8Ij/rbAGA0EiS1ISbdcwWiWt
         Fl91OFA67Pb9EfGMlu+FnqbpjXK5BqeZsEDgjJFadOhQqDMiEJcVLD1nUhWpSTOL3PvC
         H2AQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4cfjEJBaGpZSUdsSajO6j18sgMKXI0Y08qCMI2Tzvwtqr562Cq2gHAwEyqFgkMLGp3VKowIuSXA==@kvack.org
X-Gm-Message-State: AOJu0Yzujfr/iDqYcFQWiJ18cOa/Aob6xa3rcPZvKuXvQMDYZP/6dtoV
	diw21ba8UxVSoliHk2DvgN3xWwK7FUmzdV0b5ehYRO7iUf5dyvf/qgzCRObmrkzCFHKZj9y7F11
	+HUJqzvAr5lB68YPvM4+aUC87sSQDSCkfpAcPum14wQ==
X-Gm-Gg: ASbGncv7E8QDaxdH1vRfqDWYq90cA/pNujfuJCuXzku1AqrnkuRP7Y1pdjZnUAHZ4Dt
	NP47ySuo9ruTYOylJX6fZ/J9HW8yEiV9DJJ7OWBDoX3zX8bDgqWXZ1nnvN62rnc5NWv39Ivz27u
	bU2rHD7TT6u/eifNTsWmvbHkJwfprTT9Rgs+X8FXT8Vw0V2KqJ4uu4TmcbkomXVFCm2PUvVTF6V
	0whbf2S97hon1OzkOcJwbTS55WdGE5XXOTQr8g=
X-Google-Smtp-Source: AGHT+IG9Sl+u2grYbtl9VyHR7FB/EIlQJH9069FCUB+rot4YASaNIAY4/eCkV0SN9BOXHpsLTMBv/3IhK6/GlJjDcdg=
X-Received: by 2002:a05:6512:1443:20b0:553:2dce:3aad with SMTP id
 2adb3069b0e04-55ce5032e9dmr473870e87.7.1755157085087; Thu, 14 Aug 2025
 00:38:05 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 14 Aug 2025 03:38:04 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 14 Aug 2025 03:38:04 -0400
From: Bartosz Golaszewski <brgl@bgdev.pl>
In-Reply-To: <202508132044.XYcvSpm4-lkp@intel.com>
MIME-Version: 1.0
References: <202508132044.XYcvSpm4-lkp@intel.com>
Date: Thu, 14 Aug 2025 03:38:04 -0400
X-Gm-Features: Ac12FXwIeOZwq8h4NYacnkD7oHaEb0grLTUUlutgQw1Q4iS255cFgjytfxzGOEg
Message-ID: <CAMRc=Me+5CSzH0bO=DvMvzdm9eAGHJpz=9NK=O8_E1gVXRvnUg@mail.gmail.com>
Subject: Re: [PATCH v4 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, oe-kbuild@lists.linux.dev, 
	Bartosz Golaszewski <brgl@bgdev.pl>, Linus Walleij <linus.walleij@linaro.org>, 
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
	Haojian Zhuang <haojian.zhuang@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFE6A1C0003
X-Stat-Signature: c3tb711akz3z4seqedgpn1okw79iybqd
X-Rspam-User: 
X-HE-Tag: 1755157086-967208
X-HE-Meta: U2FsdGVkX1+QWVPTP0u3ZYOWL3rVRz305FXifEhrf25UQuegG2XDhD5UeYc9FAefny53O0QMLRS5+IRHB4/u1RbnY/ADu6wEv0jbGfr7BlDZery2MKI8TQ/ia1BdllPSyGz34kCpQH/OmvKKWvtHt9h/M9mjZXohk40Gpz0ySSUi7z7dpA65Zwox2t0y2eQtX3czpxJtLKDiqJKiAvcagWjzjy8Wa8cVsL60UPXimAoTZseC2XQdQcgfWBpL5bDCYx9HPX25O5N45d8Ca/2EK/mx7QU7Sx109u606+bL/qUk16PX+FA6TimZs3Lgi5vzrMQyxZcL3CqpQfkU2FEt8DAyPzUDMmg5QHpOxZinuUEw9bepsTyF3mMs+HGIH7ApbCOMptDMVzy7sCNafdGsqcl2X+Vq2L0AMNSeWjOkfAtl8398nGuhB2Ppgj5+bWTVOj0dGPYM0iefES413o8q/QlxbEVKsQoaZplOLH7FjHF9dH9fb7mWlwGnW5P8/g0jnKEYWwJA9iZSgJl6eER6K3JBl9uJvgzLdagSaxdvIpboad4yg6E6f/Qur8/ftpT/RfNjh5yhxX4s4U7DXulFkpWZPbgpwGzeF3PqRI0nmhPHO47lnZ5FPQ8E7Uk6CXElPt36fClucJ9DvEhWTV0t6SP1imm6StjgFrS39Qki8Ccf0gWA+Fk35A8P1rclwt0RfWGH2bmK/SMIbxb08fVma6dEuSachZw4nR6RDYfy0fDeExCXr5t+Hdu4fzk+U3uRcuFzhU1BOmuIdw7BDI2gRe1glCN0hY2w7N0l641gfZHXe3TFmy7clB4GLmqvk3dOv97i7O+Hr62GQU7oqRKi5AprhqHbbNHokDcebBZRRUQx4qaheRJmsuZ1TmgkRpmopNeTCdxMwb/zySQ+Bx/2Ix7UhDJRYN6JJhuSo32IV/6FZDIJCyVWh5NZe8gaXoK+fk138dn34CZGYghKnJ9
 d5zfjbdB
 9RxXtXtrYe4KV53NdWn7GXB/Eu17Nb6Lfwamb4JwzdWRUtpUurW07PTpwk08LOR9+LyY8IJNnwCqI6ZtWSFxdsBnihV+GRq+0sw1bTgEeYp7L4IDPpQO1EciIy9cF8J21eVQnKOiit5K4VCRgJhqYKyb29s1HGX0RQfQ40QP9BOv9tW9NuRJwLlf+Kl0o3pwkxfnNRmAOvbZWmvZoJJnsV279wPgBF6lnWJvW9qUhtb282+EZ6jTrWKqZgV675buFXrLW2zDREy/TyIDJNuuN/QDw0EdbQpOJ0GVzFk6wRfRAvEUqSpAHcJCnfmJFYITruzMoGqhGkkyLeftTjMKLIUdECkQVTCGyWoXJLoOD84+F82X89VWGFY0I7IWcCUs9UTTSqnxgCGeF9YPk6CjJNQRSbWCWqqR+bunbT+lTR/tl4FQ9geTk0G2nCVUssPiHBckNCtQDdEmUUIxfe1afpwcbT7guwMJWTkD2zHzC3FgXaoIf8ZTpV80UmR93cTdv8kSC16K0q8vcNYaCpjD8KGgAuYavf4xJ4D57lKp5+N9FdIVO0+OscC77nD/nNv5AtUzJb1pc/OUSy/PklERPlQOw9kfiPqThrBB4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 16:17:12 +0200, Dan Carpenter
<dan.carpenter@linaro.org> said:
> Hi Bartosz,
>
> kernel test robot noticed the following build warnings:
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Bartosz-Golaszewski/devres-provide-devm_kmemdup_const/20250812-170336
> base:   8f5ae30d69d7543eee0d70083daf4de8fe15d585
> patch link:    https://lore.kernel.org/r/20250812-pinctrl-gpio-pinfuncs-v4-12-bb3906c55e64%40linaro.org
> patch subject: [PATCH v4 12/15] pinctrl: allow to mark pin functions as requestable GPIOs
> config: um-randconfig-r072-20250813 (https://download.01.org/0day-ci/archive/20250813/202508132044.XYcvSpm4-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202508132044.XYcvSpm4-lkp@intel.com/
>
> smatch warnings:
> drivers/pinctrl/pinmux.c:96 pinmux_can_be_used_for_gpio() warn: variable dereferenced before check 'desc' (see line 92)
>
> vim +/desc +96 drivers/pinctrl/pinmux.c
>
> 7cc4e6b0e4ddf6 Andy Shevchenko     2023-11-29   88  bool pinmux_can_be_used_for_gpio(struct pinctrl_dev *pctldev, unsigned int pin)
> 472a61e777fe78 Stefan Wahren       2019-08-14   89  {
> 472a61e777fe78 Stefan Wahren       2019-08-14   90  	struct pin_desc *desc = pin_desc_get(pctldev, pin);
> 472a61e777fe78 Stefan Wahren       2019-08-14   91  	const struct pinmux_ops *ops = pctldev->desc->pmxops;
> 6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  @92  	const struct pinctrl_setting_mux *mux_setting = desc->mux_setting;
>                                                                                                         ^^^^^^^^^^^^^^^^^
> Patch adds a new dereference.
>
> 6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12   93  	bool func_is_gpio = false;
> 472a61e777fe78 Stefan Wahren       2019-08-14   94
> 472a61e777fe78 Stefan Wahren       2019-08-14   95  	/* Can't inspect pin, assume it can be used */
> 6ba2fd391ac58c Alexandre Torgue    2019-12-04  @96  	if (!desc || !ops)
>                                                             ^^^^^
> The old code assumed desc could be NULL.
>
> 472a61e777fe78 Stefan Wahren       2019-08-14   97  		return true;
> 472a61e777fe78 Stefan Wahren       2019-08-14   98
> 5a3e85c3c397c7 Mukesh Ojha         2024-10-15   99  	guard(mutex)(&desc->mux_lock);
> 6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  100  	if (mux_setting && ops->function_is_gpio)
> 6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  101  		func_is_gpio = ops->function_is_gpio(pctldev, mux_setting->func);
> 6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  102
> 6dd5ffb25d7e35 Bartosz Golaszewski 2025-08-12  103  	if (ops->strict && desc->mux_usecount && !func_is_gpio)
> 472a61e777fe78 Stefan Wahren       2019-08-14  104  		return false;
> 472a61e777fe78 Stefan Wahren       2019-08-14  105
> 472a61e777fe78 Stefan Wahren       2019-08-14  106  	return !(ops->strict && !!desc->gpio_owner);
> 472a61e777fe78 Stefan Wahren       2019-08-14  107  }
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
>

Thanks for the heads-up, I'll fix it in v5.

Bartosz

