Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575E9CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DCCB8E0006; Tue,  2 Sep 2025 09:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3818E0005; Tue,  2 Sep 2025 09:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C99C8E0006; Tue,  2 Sep 2025 09:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDFC8E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:06:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40C97140167
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:06:45 +0000 (UTC)
X-FDA: 83844334770.28.502487F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B95B140014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:06:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UQCIDNYV;
	spf=pass (imf09.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756818403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/e8OrCn7tyJZ6JB9iUKgm7HoNe0cFN9wyIlu1mO1DA=;
	b=2GpT8zbmeQ7DeRq19M/hB8tCtD4GhtfWMROLqyPgULwDY+u4UMQF/0DEJN5VjyrqCTEYts
	2XhoSI8jo1xqjmvlOq7p9++uck/ROh1CZBcef/gbSqo+oWIhlfLkixiFWeuVcSR4xEbe35
	fIXo8RgIZeTXbG1EZhY+j/sF+Ea0USs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UQCIDNYV;
	spf=pass (imf09.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756818403; a=rsa-sha256;
	cv=none;
	b=3RoDY/uDIwpS6301nteKoXpGynSuVZpwzMg1q12yI1i0dgKqYfq8ZDk/hYSM6ftGN5yBim
	VhAzRBQo01OpSwBwRaByEw7ntY2vypJ/p7TkFmF7OByC640d5V7jog5ByGiT+bcuJuOkHz
	0Y38/wGNIm0Gmna9Qaurefu1ZzEKIr4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756818402; x=1788354402;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=304mhcCsZ3DPW/ZeHF0UCdKTce70KODDh/J7W7FbB/E=;
  b=UQCIDNYVGpxtvgbkoY7oFmF1uEHsOnvPkPekgEus5qGJynNt6xWHlzFa
   TWHxSPe0G3h5Utjn7kuBwsm64ho/mdg76e2OvNOzK8lNOHc9KIr9WD+p8
   3zER82Z0y7/EQNQ1p0NDn++8QH1CpnQbKEWuxamzkJzp4+v1Rc37odw56
   wDJ30Ycr7hTDWtJcY45rF0SjGNTR+BQ+EaM2ai9fSVUTo7ipuwHJ87ge+
   zug56QWzODqP8bIW1vfmvzkiaU6dRqgDEm/EZfxU0PAkON0tcjPECUrLN
   ZeLPftYJbNYKKjKs677gxRgzPge20DevVGRTYJsP+Tug/Y/AKJfPvkntz
   g==;
X-CSE-ConnectionGUID: vFbpqdlVRmCd0eDyjYbA+A==
X-CSE-MsgGUID: lYkHxccUSnWJ3fYfTvKCFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="59028190"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="59028190"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:06:39 -0700
X-CSE-ConnectionGUID: ahJv6su8QkCwIee8PybbEA==
X-CSE-MsgGUID: WBNgT/TJTkOlqIdmDhs4Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="171432863"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:06:29 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utQiN-0000000AhP0-4600;
	Tue, 02 Sep 2025 16:06:23 +0300
Date: Tue, 2 Sep 2025 16:06:23 +0300
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
	stable@vger.kernel.org
Subject: Re: [PATCH v7 01/16] pinctrl: check the return value of
 pinmux_ops::get_function_name()
Message-ID: <aLbrz5DYS5Yxx_UE@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-1-bb091daedc52@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-1-bb091daedc52@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 8B95B140014
X-Rspam-User: 
X-Stat-Signature: zuip81b73owyt97kieqc3enaurxnohba
X-Rspamd-Server: rspam09
X-HE-Tag: 1756818402-895674
X-HE-Meta: U2FsdGVkX19RBBCq6H7m6d1ePlSkz5webZZZ64cmg4fGJzONx8o8FWWOIh62rTtOC0jUbwFhXA8UYrpLgFW7cXKZedBL3SDH+cnDce9NOq/nBGZ0jTrWv62GDXtgkHGNovQ0mvvTqggLG9FfNvXh1tsiHYPekZ+QWRRJ5/soCB8sjCFi1HnnTM+XJusJRGjTF7WEZTXMfd7Gb03YJ1ooBF0XA+3mFuamD7ddRUEHehYpeCY3H9jiJb5O6ISDhgl0xvizIH0fwhgRNjDPFDH34ebNMvpQ7RpUQlD7KMOFJkLiM+IqKdw5WG3D7XjS476WKneBHnvyzL0dAdIWisZjukiXamiD48N/zKvPXNVuCDcuU9VFabbcYwR8EvhcgQjUIrUT+SOTESctzm4sW7HleSybmAvzAgnt1XW+93GZu7HLA//rWJmnWR0WyG3ZC58dfk3G5/moAhQQJmw6fFXzlbluvv+q59bVtCEY/91oVV0W/mJJnlOscCXYnyshe8qNENXtw1hEbnVczQdx6ircAGiKyR0rr6MlbE9oVusU/dzDuBq1SdhD6daH4acvWSG4MxuHVPz1gZVHsVKVyeefTbxkbQtRpkHQzSYUe71oOscOztPR2fffqSoTaNCZRiCm4pKmB8TUI7Y7S3A6gqaKaf8yalnKVhC7kP1LDVaphDuPduU/MhO7K1hrvE6gG9R/gLMtahC3ss9EFyT2ogjq9Wq+W9yDaIdxVcAPUTus5v1UAOwXjcYVNCFAW1Kn4V2khS/w9svNoICBMwwca+jkhjIiH+PCspXnY6UdJseCSJB4TjjCTIVb4t/MvdzAdVQsnxpSEHhgHoDo4U4Zh/FWBQPf4wSoIP/WS8FO32xDFP5RsjtVK/TKjtFxu0ox0nOW0yWmApNzdPcuhuYNkxhzPLGxfcHQNVbzWEH5nABSXAGX/S+axWz7Xn/8B+CaYbB1lekZJP76bkgq1sXy3XQ
 804zmS9n
 rObXgvM2JnE+Y1Bw5WAYanljV2K3KENfc1Y9Nl8v1SSiIHaBAhf1Wc3C3v3XtCNK+GLNDYKBJIBJJBA+ptMcMJ5uLbhKOxPaFhn3xDo8OlDi95UIpqOJu30COgjpOmBrf0y2q3po85L15TP07RPsjCLmn3PTj6VXpomfOkYNBudHd2GV5vee3sq2LsnHoDQOd8l0cZqC9xd0ziVuv4+ECy9Z6ydFQnfKfGZIDB/0H0Q6o5kYLG3GBk8ZIJ65laMz8QwER8vLt92V6p7somZOHbAt6ZqfazAog2FLcYBCxY+0GtaDzkuLdD3ZZTkHWn9MF43gcvgEHeFL5VH3FhTRxwzPb9+zy5OvPs+11sTGH5G59swZrOO6kp+HRGhSraEoTC2lKam+8gqJOJovLFbBkI/rU9Y4dQ8fJZ704pQ0077YnKXw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 01:59:10PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> While the API contract in docs doesn't specify it explicitly,

So, why not to amend the doc at the same time?

> the generic implementation of the get_function_name() callback from struct
> pinmux_ops - pinmux_generic_get_function_name() - can fail and return
> NULL. This is already checked in pinmux_check_ops() so add a similar
> check in pinmux_func_name_to_selector() instead of passing the returned
> pointer right down to strcmp() where the NULL can get dereferenced. This
> is normal operation when adding new pinfunctions.

Fixes?
Reported?
Closes?

...

>  	while (selector < nfuncs) {
>  		const char *fname = ops->get_function_name(pctldev, selector);
>  
> -		if (!strcmp(function, fname))
> +		if (fname && !strcmp(function, fname))
>  			return selector;

I would slightly refactor this:

		const char *fname;

		fname = ops->get_function_name(pctldev, selector);
		if (fname && !strcmp(function, fname))
			return selector;

>  		selector++;

-- 
With Best Regards,
Andy Shevchenko



