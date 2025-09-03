Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1EECA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186EC6B0006; Wed,  3 Sep 2025 06:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137B38E000B; Wed,  3 Sep 2025 06:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40428E0001; Wed,  3 Sep 2025 06:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC2416B0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:22:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80D5B13B20B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:22:55 +0000 (UTC)
X-FDA: 83847550710.16.623FD20
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id B40F0140006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:22:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HggVaUDs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756894973; a=rsa-sha256;
	cv=none;
	b=WKl2NWhXC18DD70mkdY1nrloE8m/neCvy3hX5MKwWI8faByN70CJCzlWnHZpGnMiN7joXD
	M3h0WduXurVw4dOyW0q/qi20y4GImGqo8QJNfiLgke/R0aNOgL4kN07hjNPOCP6cH5m8or
	0VzSWxEGPBiMdtwXFN+B7ZB1W7lvGMA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HggVaUDs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756894973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T31GhvMgDcDqa/8wxluLN+dNwm4mTxHX2BFlOQeV59E=;
	b=ZKy1+mK9lAD0abI+PEFBMuL+saGh+g1Iz1C45KZiXwlOO28xqelELmdLxNUierPZuzwDa7
	JoJAsEcNB9mmS03Yj6VSxXeUQiO49BswZbBjVyDDBWqqrPVuot2OW5WjsrKNIbTm5XoQ0B
	lFqUlltTayxHVBU08dJfQtUedH8Ccmk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756894972; x=1788430972;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=hEddkyRBq0eYhs86EpYDI0PR1kM06ibMXa7C70wF0A8=;
  b=HggVaUDs6B5f0jjwnfhFSe8/Ze/5LEgjauNQ/5TUJY30DB18cimKRVkT
   +aNsLVgdW55iJaeiH7gtEgadiG+IjSN3n6xz20M2CsssdMiQ0/aLUtxlc
   vCgaGi1TB7AbGvlg6SgwfpuANKZ9vf3lKfLI1k8V6BsWuiC+kv095E8sM
   OZE3t4WV4l13e4hwEWIuf4Q+dVawdt66nXtB5qSekXcp5xPM5iX+QLm96
   2DjXdKqLpo/pKvvgwFGszxCfBbhoaMEKEfjafZYOW9AEgzkvYZwBDfXy5
   h97+mgrGnUqBdI38YP63yiC4Fl8T1uGjmG1zPyi6o60nqR/5is3wICIE3
   g==;
X-CSE-ConnectionGUID: X+lik4XMRhatXNxRFxFkDg==
X-CSE-MsgGUID: 3a49P2O7RIKOGw+kVywAcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="59318121"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="59318121"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 03:22:50 -0700
X-CSE-ConnectionGUID: YTo0WasPQBSP1GD2jJB+Ig==
X-CSE-MsgGUID: 5tCXY7/9Tha1Hp4Y6DZptQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="195180921"
Received: from smile.fi.intel.com ([10.237.72.52])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 03:22:40 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utkdQ-0000000AxFa-1l46;
	Wed, 03 Sep 2025 13:22:36 +0300
Date: Wed, 3 Sep 2025 13:22:36 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sean Wang <sean.wang@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dong Aisheng <aisheng.dong@nxp.com>,
	Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
	Jacky Bai <ping.bai@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	NXP S32 Linux Team <s32@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	imx@lists.linux.dev, linux-omap@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
Message-ID: <aLgW7J-j4nn0u8uo@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com>
 <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
 <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: B40F0140006
X-Stat-Signature: qmwpfi576tsfebxeaesxez186ft4sp47
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756894972-905386
X-HE-Meta: U2FsdGVkX18+1k76EPZnTDNz39U56MulJHGP/jmQPJiaq252YwltwdEdeJbBpOVrtlmOcuwCC1yJfKF3glKI44jTcgjpmvzLQcMBlxochTJrqXquAQRwOyi9JI0kB3hRt4FL8Ho1xYr8jULuQZEf8crvnad/ZqjuvM1JGLQlx7UEwc+DApXj8Oqs9fhM9KA3UK5wrn1ABKWhV5raf+zFIlEWN7mTI8X4DhdSUZE4JqF67ty7zfDMLyGLOt3GPorUfr1OKLccjAh7zXoRiLIAGaSbxWD/RL7gjdMctg6VemtUUya5T9XEpGpGLT6T5T2gdVSj/dqGj0ZklFDygJdtpPYVUIVaiZUWEAmlmPj6wsViysJzmapb9MqX7zjtsc6Nq379po5uBJN0jkz4eLzHNILX5PBJHpR6uNg4XLzn5/WXKEWXZbB+rp9Qak2uqm+sSUfnk0Kr/4VMuIFC5lktUZYF8GjC6SKI1Ke+/Zn/q4bSSg2Oz6JF5hC4DrYxQGYA3JSjSZfElgQFyufs1ZSXaBNrKiY4UDu77X4xobkl9GLix3s8Uw2PO4qiLXAaGThj+69JXHq8ZDlJIqTq8XoqePJVanaXOThYIGYwlwhWhfS4nJVxQcpSozBijkVUzY6maa1ItZzktDsH39gsOyi7uuZYeJI/s9FqVpVmOQ5XFbhsJAWGNJNjK5CP36awxjmU5LBdvba01XvWuaTMfXPvicG+fsnuxaqBtEEB4/VoyPQr2k3TnSMraW/E49NXVFPu2CFW7htnpNRnR1NQvJFEovVVXuZPxXRCgIdsyQO3pPnFQBGQuM9K0yJ4T40qSjzZsu4Cc2mViDaEADHYGdp29q0ICShrqm/oP6/9Z3qJNV4FMJZIJIwVLtnfhDfZ8/d40t83y6FVKnDcEq3bE7ekGc2TGNvvnugwbIv/PEQpx9MLwHqPPS5AH1QrypU4yCtRqC4frEtxntVev9xB8sW
 iqfJNUz7
 uDK092GVsaA0kqfcEwmT51qSiQKjSKIYp0HZtnr4di3LNfc8RRkUm2MzEm7NJv8XLe6O8cxthZX2sN93jeRBifn6+/LqEY8HF1A3l+whilXGUickmsZDBa+v8zDIu86uicW9X8ech4zvJ9V9e8tvi6CdRpdpvIoz/DdTPggT0H2C6I1azfXgtElq3njIcSLwGSxnvxEfvI1BdXBerIj2I+7XHuoE10/ynOqE8U0D8j+LYr8kKYxnlNEbTV3W2JjHl5dgfs+Ce6mlf4OjOxAItkCwkJl7D64EaK0OYLCkUB0E3/bKbLUEZXsE6UN39aek42geRbgUs8OpQyflqh3YIyGCxso0li0ldJM8J86pInOp7JMSUBoYpm4oWG/POmHYzsTBJExU796ZNsdg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 09:33:34AM +0200, Bartosz Golaszewski wrote:
> On Tue, Sep 2, 2025 at 10:46 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Tue, Sep 2, 2025 at 8:42 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > On Tue, Sep 2, 2025 at 4:38 PM Andy Shevchenko
> > > <andriy.shevchenko@intel.com> wrote:
> > > > On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski wrote:

...

> > > > > The strict flag in struct pinmux_ops disallows the usage of the same pin
> > > > > as a GPIO and for another function. Without it, a rouge user-space
> > > > > process with enough privileges (or even a buggy driver) can request a
> > > > > used pin as GPIO and drive it, potentially confusing devices or even
> > > > > crashing the system. Set it globally for all pinctrl-msm users.
> > > >
> > > > How does this keep (or allow) I²C generic recovery mechanism to work?
> 
> Anyway, what is your point? I don't think it has any impact on this.

If we have a group of pins that are marked as I²C, and we want to use recovery
via GPIOs, would it be still possible to request as GPIO when controller driver
is in the strict mode?

-- 
With Best Regards,
Andy Shevchenko



