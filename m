Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FFDCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D886B0008; Tue,  2 Sep 2025 10:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65226B000D; Tue,  2 Sep 2025 10:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B076B000E; Tue,  2 Sep 2025 10:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C71696B0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:46:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BD1511826B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:46:43 +0000 (UTC)
X-FDA: 83844586686.05.09A95A3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 16F3D4000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:46:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MFGskFyj;
	spf=pass (imf11.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VBlGuvfwBGT8f51xAODpfHeSqf2gAVbJfrF+G5qQ0Q=;
	b=1ESFYzs9yoPX7HmTGYf//k2Bo/gRG1jK7AGOLuqS9vahr9xkW8xv1yaOPoAHxAtrM+TEM+
	0LjtODC/8sj/vH57JBOCqq9xeJ0kaGpql5i8jpn1LFvmwNI6nIXS9JYhy+AAbZe5oErdrR
	KHnGtufQPbC6ypnpvTJwXBEi0sMPw/M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MFGskFyj;
	spf=pass (imf11.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824401; a=rsa-sha256;
	cv=none;
	b=XxnvM4H8StKX3JF0xtF/PwR7Cr+tzcB8dogptVIWDpOWDLZP0p+UMRn0iVFtUQbXX8As8j
	jQiF7M16ksgwUkPacNdYQPQPmJOE01fVa/OonWzddIGQxKGhOdUtRtbviFlxAbwyg3JqL9
	QgQX2hX/I/1hPuYRNyXNhulwLvI+y68=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756824401; x=1788360401;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wx5EU3ck/BxVVGxoCPPqG0+FAlUpEvvPwJtcEzKjaII=;
  b=MFGskFyjsH15aNbS6dY1N4MLFe5sztvKqv3LZzw3uPRMt0+432xXJ6kc
   G0tcOzCQpdFrbvYFoQRcywZjXq5nK+W6Pr2i/XTw4TpNUTsYoWq01eGqD
   ngU8m21J34F28/aG4dx2G2hUnokG3l00i3V8IwX6b4cQLwWaabfDWVUsk
   dk2SvviMH1Nn4mO8bsLEvmQFQ4hJELprvMUICB/aj7f1igd3d6M0Xlf1/
   iM1MuEKcflAdgqdooCX+ulEPvrAlXSQwHPhSjbJZQ1IVspwzPoG3m+GDh
   dPpLBaVKxjhGDh9Rqe4Dyp3v81BOoA/aJZHf4HIlDyqMqACEAhR20OYPI
   g==;
X-CSE-ConnectionGUID: cpZ1e/McSvK86LK+CNg5JQ==
X-CSE-MsgGUID: fwekvq4KRa6gnYlTkUTpuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="76545797"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="76545797"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:46:40 -0700
X-CSE-ConnectionGUID: USnIJsbFRhyH+qHMzQmVsQ==
X-CSE-MsgGUID: 2OVUpl5DTIeZGPOdwEp2Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="171189727"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:46:28 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utSHA-0000000Aig8-04Qa;
	Tue, 02 Sep 2025 17:46:24 +0300
Date: Tue, 2 Sep 2025 17:46:23 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
	stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v7 00/16] pinctrl: introduce the concept of a GPIO pin
 function category
Message-ID: <aLcDP36eEIZ_tqFv@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Stat-Signature: nhfixc9cdiyrktqysutf3c9jorutb8zx
X-Rspam-User: 
X-Rspamd-Queue-Id: 16F3D4000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756824400-640514
X-HE-Meta: U2FsdGVkX1/uLAqaVG+tAqZzwwm8O7dIlas8PouzRlnKB066zqE+5r8mObMBNcltNTJL/pnzeCkA/uwFusRwQsKZ+gwDeqb2ChhK0TJsDra86tpd0wUXOC3FfrG5lEV/7ZkEecKucmBw1bMDRzNzef/HyR5MA6hPwhxTRS+8B0nhcUfgpZaC9ojv14jS5AQCo1Oi/oRnqpaTeCHU4938nbrcA+uDWurvz9e7CeKObnpRNa177o6QkJXD8Yly0nXTWMoCyllT2LNdfvmuYuAFE1LFesNF0DF5iIL+ADEymwNkvmL1Q/YNFuKQK61+knxEV0f4LcM68eAkQVgYCvvput1ga03d4bpGR9p1cxo/rYzAcTPpIw4gXwx8Bs1U+k945y4d2GKglyKNoEYvsFmqDLKE/w2Xh5ID8YINvG2ldgvV9aJa1Iv60HU2mLC/q0F7gGiDqpnJVdnUaaUicl6geUw84ApViKilXTcMDsUQxE/xroy1wtMUe8Tc1cs9mONZCFFvTm8kBp2E5Uapgm5ovCUYKgnJadWVDUnoKcfepMgFn2FA5+stkzpQf8DKB4HyvZwgmbt9ot0Ju0YdcNOwcHsRu5/uJxYkkbUKKzbTp0abbNMUrsjphTrhop6PsWiAtO2W77k3OxFgTZKQJi6zr60wEj2iAlNsailCo/tUjxsIKOGSgpBF3g3vzwkZvWYA8Mh4sTFtld/e9Z4G+Vv3kxquqHGIvBAd/GxsgnU0Zljlo9c7VcgQ1LfaHeFdWMNfuLivmKE/gvME1dteeeLGzTf1hgrFxr+5U0sOO3ILUyhlzeBWefaz+GSEa2MecJHFPclY/h4eEvgbkTQxISId2kuzedawCBV0EpNRFRgisHVFA5W7xFobZL9FwPvAsyqYsvyZ7nrdrxbRXuXybYvLnk/9mgdlNR6qK7i/VF44wohB0h8WDSuTERdaRe/gYCuVIhKnY0utLQX4SpHBvgq
 3d51Yz44
 uNtWIwegUXkfZmJjw+chJE/4TooHwiouCAcMGBlYu/yB/WXzSdfgIZhwP6QOdJ3eBz8OW9Uz8uEjDxPsPI+844LxkW2YStC1Vkw0FY6+u33DlLp8YHx+6hgXOjV21Sta5n3XLS3lqy3NjJr7WNa2OmNuf3qZdd+NTALynBfCVzB6C1QgX3gnHaZeuHqIYAJZ/PScGQvxKpBClM3n4Re/R31rJt/rdDMI9RqMjB5cOV8HN/iyBj1yvcw0AKIIIuD/LxD5h6hNeWwMIwoDSVr+t1Kq+u1H6fQDLUgsw/SULoMoce3DqhvyCVY9wEpyMENV8sJxI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 01:59:09PM +0200, Bartosz Golaszewski wrote:
> Problem: when pinctrl core binds pins to a consumer device and the
> pinmux ops of the underlying driver are marked as strict, the pin in
> question can no longer be requested as a GPIO using the GPIO descriptor
> API. It will result in the following error:
> 
> [    5.095688] sc8280xp-tlmm f100000.pinctrl: pin GPIO_25 already requested by regulator-edp-3p3; cannot claim for f100000.pinctrl:570
> [    5.107822] sc8280xp-tlmm f100000.pinctrl: error -EINVAL: pin-25 (f100000.pinctrl:570)
> 
> This typically makes sense except when the pins are muxed to a function
> that actually says "GPIO". Of course, the function name is just a string
> so it has no meaning to the pinctrl subsystem.
> 
> We have many Qualcomm SoCs (and I can imagine it's a common pattern in
> other platforms as well) where we mux a pin to "gpio" function using the
> `pinctrl-X` property in order to configure bias or drive-strength and
> then access it using the gpiod API. This makes it impossible to mark the
> pin controller module as "strict".
> 
> This series proposes to introduce a concept of a sub-category of
> pinfunctions: GPIO functions where the above is not true and the pin
> muxed as a GPIO can still be accessed via the GPIO consumer API even for
> strict pinmuxers.
> 
> To that end: we first clean up the drivers that use struct function_desc
> and make them use the smaller struct pinfunction instead - which is the
> correct structure for drivers to describe their pin functions with. We
> also rework pinmux core to not duplicate memory used to store the
> pinfunctions unless they're allocated dynamically.
> 
> First: provide the kmemdup_const() helper which only duplicates memory
> if it's not in the .rodata section. Then rework all pinctrl drivers that
> instantiate objects of type struct function_desc as they should only be
> created by pinmux core. Next constify the return value of the accessor
> used to expose these structures to users and finally convert the
> pinfunction object within struct function_desc to a pointer and use
> kmemdup_const() to assign it. With this done proceed to add
> infrastructure for the GPIO pin function category and use it in Qualcomm
> drivers. At the very end: make the Qualcomm pinmuxer strict.

I read all this and do not understand why we take all this way,
Esp. see my Q in patch 16. Can we rather limit this to the controller
driver to decide and have it handle all the possible configurations,
muxing, etc?

I think what we are trying to do here is to delegate part of the
driver's work pin mux / pin control core. While it sounds like right
direction the implementation (design wise) seems to me unscalable.

In any case first 12 patch (in case they are not regressing) are good
to go as soon as they can. I like the part of constification.

-- 
With Best Regards,
Andy Shevchenko



