Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98256CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBAD86B000D; Tue,  2 Sep 2025 11:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64D88E0020; Tue,  2 Sep 2025 11:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53D88E0002; Tue,  2 Sep 2025 11:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B199F6B000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:27:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 433B016026A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:27:56 +0000 (UTC)
X-FDA: 83844690552.18.45EC018
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A19F40008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:27:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="g/zSCtEJ";
	spf=pass (imf07.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756826874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFfgn169VvA80SefCI8IpUZ827vddRaFufexbdxmOro=;
	b=xSNp4soAgZtWO8AXN0XrZac2L2REfif6GKBUbBOeEyEQKObxCb/pDIrGH9dQnKHVEBrNvX
	GhWid8+opz+ZZYZD21kUgBDFMO3bvhgKyMk5sZaPC7m+BOf68UQAFtj7TeT2SbMV3j2LLc
	6uX9EeLAsEgebHf6dqxaDH0B5cCMadU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756826874; a=rsa-sha256;
	cv=none;
	b=WxzpG1a4zHfeVkp86kblir87OdGB+SjrjQAcZX7JTJLlm4t9i7MoPxQIZFK6MkuKg/RDuy
	rKZLD2jQnAPGgyo42CuJVM4k8ZW+9qpu+r5Xqbst5VwT5Sg8Ky0Wu5cOhsvgbhfjsVjR07
	U2gPNUCcV/r6hbAACyByRQZnvdElnt8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="g/zSCtEJ";
	spf=pass (imf07.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756826874; x=1788362874;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pxDRyV6r3uWk5lkkZlh4n7lncpUrSzOFA8awI6XQfUU=;
  b=g/zSCtEJpEzZkWgiqbx2BzDseK32syQUMaOJjmLrv3bEQWv4QWPDuZgy
   +uQQm1Lr7g5LO3Kq4ijFEUyHRcsuJgHBaoUp2b/l3yyny6zroVhdt9zVB
   mGCsBsIG+muxEI0LV/0sJ3RC+/nmzPsUWk8IlhMZyQoCHViHjnE7JJU8x
   h8q3S8ExHijw1WZp5orM3nmJGzd//IGD0SnClJMUUJt16lVxyRf64U0u4
   jiCkIykVzHTYS6pSe5jwKwdl+RvkZblWg6FyV3MQDwz6LsD2Ui1LB04ea
   G5rXHby/exF9mfDrFM1gFoTgBhYMPqOyxYc8u2gPoHZZwvgShDnUkhH2S
   A==;
X-CSE-ConnectionGUID: ogMg7wE5SYqhDVE33xAdyw==
X-CSE-MsgGUID: L7J8Ag0PRV6f1EYz7OMmHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58965305"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="58965305"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 08:27:52 -0700
X-CSE-ConnectionGUID: Mff6GxWfTJyq2rWNK/1oVw==
X-CSE-MsgGUID: caNsXPCtQ0WFMdHw7a+vaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="170562537"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 08:27:40 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utSv1-0000000AjNy-1oS6;
	Tue, 02 Sep 2025 18:27:35 +0300
Date: Tue, 2 Sep 2025 18:27:35 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>,
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
Subject: Re: [PATCH v7 12/16] pinctrl: qcom: use generic pin function helpers
Message-ID: <aLcM58IEH8hGYLnx@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-12-bb091daedc52@linaro.org>
 <aLbt2euqYQM5xXuZ@smile.fi.intel.com>
 <1034c70a-da67-4914-b23c-8d006b7611bf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1034c70a-da67-4914-b23c-8d006b7611bf@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4A19F40008
X-Stat-Signature: 796mn7r9z6yb655enjrb6hzcxsk3g43d
X-Rspam-User: 
X-HE-Tag: 1756826873-968559
X-HE-Meta: U2FsdGVkX1/2xndnYZeLLVwATLIWh7R/gx1gz+N0+S606ROTStgeYjIazUrx/xukSXvPQiKrOlo0Ajzb2zk9AiIizq1gvDORKmtmoonFOEpKFKK8p7ApLepRTnuW7LFX/+HdWxTjbmKp01mNtDMuT6CIGtRCOYCj806mAeIpZja1OlGzZ7JUIH/6j1XVmZb5Kq9ZlC95vzsn+Fn0tExjWxLVSSGm5rW669np4ADGep5t2xhJzO64+Fv+VKvPrDIm2TFQmTTq8sP5tQvZvr9gQ48s7hc0EuqCoDSwgLM3fEIbvq9gjsdnXQUHe5VDSzeasPzKUMNOpcWhedePLcNbgGBbb4RHh6rJgH+dmKbfexoRjGIClMLUGxxjErTlCkR0u/vjGrB6R8s8AsPrjlpzZ3M6UqgZ7dRZS9hJf2PWi+AWITgGP/dY3e2ULQBoiRfnbdQbBj5A6CMm2rp3oQ4jQCQPWKWZmJiiXNMaW6X84kuhxmcwihiv7snHtAGUIxiivVB8QFztqyEAEgsF4e85ffJLXz/z/QiwOuP1YPZLDrMS9rcD0MWlVJvd3Vb6Kbb93OL7x9OE4hfRDFPTztPyFO4ae2f9+g8yBgKfmX1yTr+5IH0D6puRgL4CwxMOYUyt/8toowHkZXQy6M7sjqww0JtDMce15a5CeK8+Vl8+feRFNi2tz4AP807H7AFEUae2jo2zLeUBOdGuT+W9MpFhnqr8IoW8qFS9AJdlrEvI69koNGbsxIccl5Oxdgl01VLhGRszTGaM4cKQ4aMf3ui9rDavAA2ksfqW2V7FhduEqcdIW4HYCRds87tDVD0PFdwaSnd4Wj8ZCASWuCZ2HJy4geAbZqfQAX04zczrOnXiHpQ5e7lOJpa979Tpte+8VCiFVRfGg1dFJ3Na4+bgxVx448bn23njr6z0UIWXdXv/C6t+Z6A/jAA0GrJ6j1CRJTNmgW62vV5SvAZRtMV/sP/
 Mk7+DJeJ
 Deevu5HSCQqhtkLCDqJeMBhlt4lpv/lEwTeEyhwooDl0OdW9f4GmAbvEbWrZMIGFIlYrcQwIPuPccimNHFT107n5eGYIALEAPSiB5dB1zXgQgr3FwjJxkWOJA7pOZOfzcT2Ia52nY9oc5cB7n9KKml0povGA4o+/8qRTwDaRN1Jff3t/jqvqYLPSu60spKcbRj3Wz72QYxoItMRLiTncih9S0AweOAvMxJkZtq5n91ahZuIWEJaFQeWiDC07I66Hq/1hcRkwpQSE9DRx6AgpiYWWj3H8DPJgU9iROB2a8jgKpMxjzfmx2j4/QXFXRT10CMnec
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 05:12:24PM +0200, Krzysztof Kozlowski wrote:
> On 02/09/2025 15:15, Andy Shevchenko wrote:
> > On Tue, Sep 02, 2025 at 01:59:21PM +0200, Bartosz Golaszewski wrote:

...

> >> +	for (i = 0; i < soc_data->nfunctions; i++) {
> >> +		func = &soc_data->functions[i];
> >> +
> >> +		ret = pinmux_generic_add_pinfunction(pctrl->pctrl, func, NULL);
> >> +		if (ret < 0)
> > 
> > Why not simply
> > 
> > 		if (ret)
> 
> Because existing code is as readable?

I don't agree on this. And Bart explained why. So, it's an API requirement
after all.

> This is just some serious
> nitpicking which is not actually helping at all at v7.

Agree, this comment is a nit-pick which can be ignored at v7 stage.

-- 
With Best Regards,
Andy Shevchenko



