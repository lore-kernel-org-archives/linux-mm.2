Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FFE9CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C85C6B0012; Tue,  2 Sep 2025 09:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979086B0022; Tue,  2 Sep 2025 09:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868446B0023; Tue,  2 Sep 2025 09:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 727586B0012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:15:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 028D983FCA
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:15:23 +0000 (UTC)
X-FDA: 83844356568.04.4BD8442
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id 89AE24001A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:15:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Idi2tQSb;
	spf=pass (imf11.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756818921; a=rsa-sha256;
	cv=none;
	b=fjJt7ibMx/8la3W7CTDb6kV3kbqeyZ4yIMRZpFdOq3Ob8eaSzKA0Iaj1aWbxu3OBD42XJK
	m5qPWMUxCklmJmxxlv0rTZwsZv8IC/HQlr3co+mvKEmfNWIcBXm1wESLCKMlAmza9/NyYK
	Srld18iJvY3SQOV+F967AbfLwPWT8L4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Idi2tQSb;
	spf=pass (imf11.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756818921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRJDgRmHBw+J65zqV+/QCRhrrek5fZfoXh2Mkgbf81o=;
	b=m7JZ538gy9+rJAsdyIM8GjWrAudUBn1xAXObZqdrzch4s2ksHR+CLMjkeKxYenBrpPzOEt
	5PJwmFbaHK9dcM2BjkM9CVsTMY/VdtAzdt+r+KdGblxj67ynzOao9yq6oTLGa3O1otc2pm
	HnnjLOQQRwcE+KPOairN+W3CDIjgn1k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756818922; x=1788354922;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cIei6RTUCtT55QsspDgWfZe1lPcqVs/yM9oKakcEt4M=;
  b=Idi2tQSb55UzmqQkC3Q/wUdfHFFjGdLEc2vsAphWQi8JdQFmZt4CjGLF
   e8irzvfQNmcsAlLeayFNOxDU9+Ove0kdybcgwhOzKQhBf9pWL4QwX3saD
   HUov6qL85tEfKBj7q8kIR22lsAuKZj3/pWnAgB+qBmPF9DPSphRekE5yg
   7SubnznaFP/r0hwWbZYczJJTOXh5ZmkSPANnJiIT0QONxJsvowaee6l1R
   5DrSJV6JZBCwlrblLJMLftlf+CmCkZ5JQmtB0x/3cmPpH+t1+qveddfVy
   CmKq6i77NQXFvihddDe4wT5EZLc101qmtFbJ0uSLQZNuLqgEf/2OtiQfr
   A==;
X-CSE-ConnectionGUID: tAX94WZ/TwqfgmrKLmhFiw==
X-CSE-MsgGUID: tYmDTvccSMqIZVvGYkMLng==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59041787"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59041787"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:15:20 -0700
X-CSE-ConnectionGUID: QF8sMWo2SGOcClSTfRIdKw==
X-CSE-MsgGUID: FLZgbnm/Swu9LSfjg8Kdhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="170530232"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:15:09 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utQqn-0000000AhVQ-1jBt;
	Tue, 02 Sep 2025 16:15:05 +0300
Date: Tue, 2 Sep 2025 16:15:05 +0300
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
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v7 12/16] pinctrl: qcom: use generic pin function helpers
Message-ID: <aLbt2euqYQM5xXuZ@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-12-bb091daedc52@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-12-bb091daedc52@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 89AE24001A
X-Stat-Signature: eh7h66cgx9fmx9j5asu9wdhjrhnfyhrd
X-Rspam-User: 
X-HE-Tag: 1756818921-743614
X-HE-Meta: U2FsdGVkX18XiiY4pMK+vl+HjcTaTjkYTv7Bsexp9gKgl69nhhCgMvE3uodp/rb+28C2NZGYgY/gkMFgeRFJ1Wm1K4r72Z1FfkJuc08NYdmqSiarZGDz2l+PkwdQ9VLrZ8XTzYfKuoGAyPq/LHGZ5NkM9phB5YCbOiOLGX6H8eguCBQMIPfH++WVj9EOnOOfaSIC0Hr9dZiY6+nMLjlyYCoqd7KZNEIAkmP4HwjpoRZsB/a5dV/fYggepkpW6LkkzmOzABzjPWqrdpEvCMdrAwlAs8ZxLnRUpaUjUBv7nkDiFtywQ4X6Jc6fxhkIP3gMIe29pheZPp/oMiLZ5t29U2VuzzDn63XPjBey2BTJuVVVv0vlt6O9DLoc3mxv9Ln39h0alKE9DmzIh+4uGWOHn2URl3bAXXkhTgJIrCU46G95CxgEmAddvHM8Z3gjzOLh7AF7jkgEDON7r+tZmJ2/6g1Bh0jwQcQlvvFiTuqO2nCQP51POMhKkvhykzaDr5fLIu1T9lmuxiewXMWp0NhpKe9sMjbJm+bksayPbyMQkuX+wRq7uUfx6WhhnfuqHiFoRy0tr1mhqwY+vhU+vGos3io3xzcciCm09oAkHENwmBlDIaoybQTEbXGDyXsS7tM85zh9yh49lLoRWHt51GxUTbi1Bm7Xu1cvZUz+DYH+mMcIAcMZFuh1kmkiT2rH+u5GkKcOqCpTsgzPs0r0G2bVQDOsMCr80K9qoh8dg+asHR2UiPl2STQgTe8r2+5IhU0ZhQjSMEHPZ9rB55N5OmF0hsHO3VzJDCavvnQXpqXl5dpWuYSURB8i+1M8Fg/Zl5nLy/ryWf4QVkul9YoXl4UY1lsDnLSAWSUjVyijXmwziEAdhus6qrLsUMc9T4bD05dh1LWObHyiboEPh7zErxWP37AldNNvo1z/SOrQK9HkcUYExuaekvIs3XG5Ae3oL75udXOJpF/h7XHQ/bMwffO
 ZQEsp9uX
 oU0/zC5YUWgpjoV/Zgn5TGR5bhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 01:59:21PM +0200, Bartosz Golaszewski wrote:
> 
> With the pinmux core no longer duplicating memory used to store the
> struct pinfunction objects in .rodata, we can now use the existing
> infrastructure for storing and looking up pin functions in qualcomm
> drivers. Remove hand-crafted callbacks.

...

> +	for (i = 0; i < soc_data->nfunctions; i++) {
> +		func = &soc_data->functions[i];
> +
> +		ret = pinmux_generic_add_pinfunction(pctrl->pctrl, func, NULL);
> +		if (ret < 0)

Why not simply

		if (ret)

> +			return ret;
> +	}

-- 
With Best Regards,
Andy Shevchenko



