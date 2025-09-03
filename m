Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED12CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302698E000B; Wed,  3 Sep 2025 06:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C038E0002; Wed,  3 Sep 2025 06:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CAA8E000B; Wed,  3 Sep 2025 06:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EF4078E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:53:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 882891DE6FE
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:53:21 +0000 (UTC)
X-FDA: 83847627402.03.BAE6BD5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0124D18000A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:53:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MKG3fhKo;
	spf=pass (imf06.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756896799; a=rsa-sha256;
	cv=none;
	b=JancDFJIoHiy/x0edQi/JKrdEQvOfIhe6Lgw+D5TzegsDxz1v+iXo8AbDUnfxvuU8R5K+H
	UhMttvZ6ezPUWLvUltMTvo8mLnTkLOPJvvvtuFp6y/s58Tb71/VPqtBz+2ChFjaqpEIpkP
	meJcAitYfCJvqJW8xFawH8FpFoaxsec=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MKG3fhKo;
	spf=pass (imf06.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756896799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXY0E2WsQ9csWMZHv9bqH28cayEHGe2aO8uPYZUAjXo=;
	b=Q4IJRwtn6mzDwLWksmYmawu0TBUnagWYGdJXnRllPRJpMhnB0HAYSEpeb7z/gZeMiCHGBF
	8YBQMUBEHU2EeIibhHqjWNO0Hsfqmp2eW6ZeNdm18f1zbiCdcpeNKNWjSnkUCoDsPG7MWb
	BEWgABYe5tPJXJtLGIU4xePl8FTu5Jk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756896799; x=1788432799;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FUmeNCPfNa/iZWbYGZH641C9Ogg0J/3dPBsw0VAIiWE=;
  b=MKG3fhKoBhoTaz9Y56R+Nb8Fh8+tbGf25Bu3jP2nNkz4MUrch0uQ5Hf7
   1WW6cRd2ztYLd//y+NdqwdKtgpFTokKHG7SwYUt95OPvrYMJrRcihAWo8
   O1BUddL3spgB+DgjFnst/7R2hc0s8esiNkXBJazlUWxOtCpZlO1cnIGqf
   Cod/Z9axZ2RIvAFvseBXUFY38LrQMutMzyy87xNKKSj/jytz1/WPE4X89
   EDvvMcpgkTQz0zWCWm7HpKzl9cZXY62TdRQYvNT2wfNnpf17BoR3+lGED
   xOOsdM/BiXWblhnuFBr4fp/XIxfbNzqlXHbMliey6sbiyqSyjaVrsTqkW
   w==;
X-CSE-ConnectionGUID: UjuOiUEIRpezb0JRLsaS1Q==
X-CSE-MsgGUID: ave9oFo3Th2iqQ1B8wePng==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59273789"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59273789"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 03:53:17 -0700
X-CSE-ConnectionGUID: fZSJg/OdSLSicfgtY1CHmg==
X-CSE-MsgGUID: PfccqARKQ1qrVxLteKqPew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="175704587"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 03:53:06 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utl6r-0000000Axff-11tp;
	Wed, 03 Sep 2025 13:53:01 +0300
Date: Wed, 3 Sep 2025 13:53:00 +0300
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
Message-ID: <aLgeDNLABpmkShIU@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com>
 <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
 <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
 <aLgW7J-j4nn0u8uo@smile.fi.intel.com>
 <CAMRc=MdA21fwnamymG6YhqBjKDso_nJs_4xefPNONQNfEcPHXA@mail.gmail.com>
 <aLgaoivmBUgoeO6B@smile.fi.intel.com>
 <CAMRc=Me84OX=UEmAXxmwE8oOH=1UBsyHe-7XmU0c8a2gG9JnCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=Me84OX=UEmAXxmwE8oOH=1UBsyHe-7XmU0c8a2gG9JnCA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0124D18000A
X-Stat-Signature: eqhz5j6o5mij8y4eyfnmmfjz69pjbmtb
X-Rspam-User: 
X-HE-Tag: 1756896798-300176
X-HE-Meta: U2FsdGVkX19ovk/voeel0yV6s6N3NFdRuUIjAk5L/K837UpXaumJjhJfC+Y205+/bGAPSX8qUJ1sD/KR6kwoEJPv0MIyVpgl59jiP6L3fBt//nYcZ/YiHV5unjFr4oj1bsWY/INwPtB2y8nTenHRg+NJO95AK103Apr+AzIET7lNCJQbOyjTHy/5OvCj8+/wo6epAWuuNIKPQF9o6bQVmiHmeIMni0vnfPUiu8HbMN5C5/phamtI8NWZrd38KkLLXfzN+aVk3h5na/hNGmbl+lkGcbB6V01xeyNMdaZdOyiPhMqqkI3NCLIv1BTWyLgq1NKw3/a6tngdLGKpD+IhKsAn8cPVXKwKjQ3QCB5nETkNlnfGxOLsVW09oRHLzGDMVjlNEpyjUfFUhnutKvxnoRGZPuHotoSCmV/VSnx2GaJY7dq/3n9TwBSgudpfheG3b/neWaGSMFGZyzHcd/n2NLlfLo+L7WNDD/WMMqf20RnvlSEyX9D/+XFwBX/cC8XfwYaH2aNx6+Hi9xv2/g5WpK6Ix+foYjWFYemGzTZqvKinaN8oRPGsqkiMwfCjSTFZZosPqjNLwJI2mHDj8wAmZS1PmyHsZgKfm6xMzNfCIiqjkM5jQ23s4A5aIvxYnVEq0zsX9vlTqHAxRjLD582VAy19FkYnkNCOvf6jUUxO3eZxdkTjJaUzC5gG/W9IIrCAkY58Np+OZeiJEcOEPENeIMSZev00QlQyVzmGj0qSyTbpqXvZZa7Jv2r276hqJf0DGQUlBIyKSz3DND0i3zry2ro2m/wJMxHms5oFe4RQpedN5Gf3Vah3tVe70+duriJEB0aUba4HqZlO+0mJTwhgoXA9IyHIu0Rnw9VjhwpyK5pRKI0l1E+knlXpckMY7J6+315/uNx0ddFu1R2u3r0Co8RM4nyr/lUu1NIlRnwrVgSAyqTfGpc0i9uYoB+SJMQDa2wAF2PJ4pZVfz35THD
 7dJlkPOB
 5nUe2kVqOy0OQrRQX0EwtBmt0ilALY74+H/mfZu7wVD0WL3sPy+d5TRhmHPMc6YqOQonsa+ZXnpGo0kefo/Az+ItE5Ay8vfBnA+40B9BmTsQKQViyJsQjLYWiO+pxhoMtoKo8MsFa9yKnn6dbxPfUtLG6+M4bvMZWcv5aUDwCFbsF8bOji3auDwwT8wAzoXLQub7DhNt3bXJPxCPUGYJ89h6pGuFWyGcyxpgYxmE+WXD7P0y4QuoszqQygdm9PJyQSOhQ15mWSI7bdju1uBTDDG+Mo75CIRgmbAW2q9kFZDu7m2P9WAQpE0HjMzAfhf115Ug9tDBpjTpa9NclRl/smCdsQINhFR+3PLORyw4SgxdqgUK1fhCZK5ZjV0siTz9307eePm3LvS4263g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 12:41:48PM +0200, Bartosz Golaszewski wrote:
> On Wed, Sep 3, 2025 at 12:38 PM Andy Shevchenko
> <andriy.shevchenko@intel.com> wrote:
> > On Wed, Sep 03, 2025 at 12:34:00PM +0200, Bartosz Golaszewski wrote:
> > > On Wed, Sep 3, 2025 at 12:22 PM Andy Shevchenko
> > > <andriy.shevchenko@intel.com> wrote:
> > > > On Wed, Sep 03, 2025 at 09:33:34AM +0200, Bartosz Golaszewski wrote:
> > > > > On Tue, Sep 2, 2025 at 10:46 PM Andy Shevchenko
> > > > > <andy.shevchenko@gmail.com> wrote:
> > > > > > On Tue, Sep 2, 2025 at 8:42 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > > > > > On Tue, Sep 2, 2025 at 4:38 PM Andy Shevchenko
> > > > > > > <andriy.shevchenko@intel.com> wrote:
> > > > > > > > On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski wrote:

...

> > > > > > > > > The strict flag in struct pinmux_ops disallows the usage of the same pin
> > > > > > > > > as a GPIO and for another function. Without it, a rouge user-space
> > > > > > > > > process with enough privileges (or even a buggy driver) can request a
> > > > > > > > > used pin as GPIO and drive it, potentially confusing devices or even
> > > > > > > > > crashing the system. Set it globally for all pinctrl-msm users.
> > > > > > > >
> > > > > > > > How does this keep (or allow) I²C generic recovery mechanism to work?
> > > > >
> > > > > Anyway, what is your point? I don't think it has any impact on this.
> > > >
> > > > If we have a group of pins that are marked as I²C, and we want to use recovery
> > > > via GPIOs, would it be still possible to request as GPIO when controller driver
> > > > is in the strict mode?
> > >
> > > Yes, if you mark that function as a "GPIO" function in the pin
> > > controller driver.
> >
> > How would it prevent from requesting from user space?
> 
> It wouldn't, we don't discriminate between user-space and in-kernel
> GPIO users. A function either is a GPIO or isn't. Can you point me to
> the driver you're thinking about or is this a purely speculative
> question?

The recovery mechanism is in I²C core and many drivers use that.
I'm not aware of Qualcomm drivers in particular. But mechanism is
in use in I²C DesignWare which is distributed a lot among platforms,
so using word 'purely' is incorrect, and word 'speculative' is a bit
strong, but you can think of the issue coming later on when somebody
does something like this.

The same applies to the in-band wakeup UART mechanism.

Which means that with this series we will relax it back anyway for
the above mentioned cases.

(Not sure, but SPI DesignWare requires programming SPI native chip selects even
 if the GPIO is used for that, this might have also some implications, but here
 it's for real 'purely speculative'.)

-- 
With Best Regards,
Andy Shevchenko



