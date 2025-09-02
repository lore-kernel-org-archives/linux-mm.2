Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72781CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFDAD8E0001; Tue,  2 Sep 2025 10:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADB86B000E; Tue,  2 Sep 2025 10:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75918E0001; Tue,  2 Sep 2025 10:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDE96B000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:33:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 406CEB6B50
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:33:14 +0000 (UTC)
X-FDA: 83844552708.10.5BD2BCD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0E7E5C000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:33:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=meafgg8O;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756823592; a=rsa-sha256;
	cv=none;
	b=Fhu8x7iXqzlzY5aHaUlmHysq4f5XlGm7/tNoGOd2cAZ0296QmMtU7A01iToDbq8oFCpbXK
	w3AhAz3nEMOpdwhp6SO07qd9KlQUdgDxokmhlmoijPoyUaAAk2Wq49pioOsRq+OeTcDLd5
	QAilrqq5jD4nKV2aVUf/UZc3u1GmgJc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=meafgg8O;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756823592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vy67ObTbkZdZhbIeej3G7oE3M7Losn79kkcFsXwKCg=;
	b=NXU5JY1C8psLD5ivjn6tqjIS3ydKkEcpjlVH5jx8gyGQVafGmjKZB6MXjsehQze8f5p5Mu
	Mi5ogzl4qz/kc7IZ6yCr2X64TynqDSCCRqv1eWFryrV4aWLmvxCCrdF2VHk07wbRHW/g/6
	wr+O1TTH5JmMk/y7JWtFg1EiXmJ5Mo0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756823592; x=1788359592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CqeygO38G2UqLYwyJWypxYe4AznIXuR38IzQgfyWO78=;
  b=meafgg8OJu0T6RohHETMjiaKPCARIs7ryaEnB+BwtpUYj8w8V1diDRQ2
   2NuYlbNRhbFBUck0rr3/iiKyrgWHCPm8kU4u8fzRBYXZhEK17a0fAP3hm
   7ZJ5RTfl/7nEbCduhkslyatQoly3/MtlMQKXsYou5mlyYrIQPl4A2t6q/
   /9Hy9Py9LupJzDgc562GhpdQIKL/Epm4A0PNZNuDex4O4ySiFok1l4kdY
   cL5nRG2fDIq8/j8HF0qF3uxZAXpW2MPibSf55xRjpJKYrY2sRipJ5sRwo
   R2OvIxZ8P9hw3OiBSvOa8G/grvdvJfVIsI/ZTX6xxjwIy5g0bOHGO6jPB
   g==;
X-CSE-ConnectionGUID: 24h6Me1ETJ+QXeE6LrJu0A==
X-CSE-MsgGUID: 6yMlALlERkO15QHJ4W674g==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="70529026"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="70529026"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:33:10 -0700
X-CSE-ConnectionGUID: t6YdkPslS0eCpPn1gsG2vA==
X-CSE-MsgGUID: 2hQHF1LATnKCD8YNAvpqBg==
X-ExtLoop1: 1
Received: from smile.fi.intel.com ([10.237.72.52])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:33:01 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utS49-0000000AiVG-092e;
	Tue, 02 Sep 2025 17:32:57 +0300
Date: Tue, 2 Sep 2025 17:32:56 +0300
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
Subject: Re: [PATCH v7 15/16] pinctrl: qcom: mark the `gpio` and `egpio` pins
 function as non-strict functions
Message-ID: <aLcAGKnrh-GeR-NL@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-15-bb091daedc52@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-15-bb091daedc52@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 0E7E5C000C
X-Stat-Signature: uwniqn8fi8xcs9ho3gfzoh4r8eho7fa3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756823591-892090
X-HE-Meta: U2FsdGVkX19H3SL7/anR6DjWcbOGGbwPvTvKtvqWp5+KoP0NDKFcayERgXAGwzcGY9Bcdi5O3SxJVjHy+ngE09yYtBk+PzV4Z8fQVXvxJ7QJzoCu6kdx6o7cG0mW2QU9iHUm9EHQNx/wAHqaIVBEqGmeCHfa+++zMXlBnr9H5VFvpLXY96GrVlg2qzRMjS6C4Tf9kr6xftSdYHsELndQjqKfuBCd6fm/DEOSpSNJxPe0T3t/Pa5O91IVEt1eWZB6lplkZZdfE2Fc5QnF4xbQp0O6QyaMXRkEbtLNcZBeo9OC/nuOILhNnHb5DnO7GLfrtjbnAFL2Egj8oKCJLgqPGeOfYdFKTbOkDuII+jcvXYEmYNeryxdWa+HzdrKsVL1hZk+0mvs1h9tO2o5GP1L/2/jIm7BkIvItGhss1ULJrQRFGcH7V3dxHualzu7OqAZoVBP54Wd9Pd9/yx1X9aU9X5zCMoHsd1dJ61mSINYs6AMSNps+ck7By9gPFFc2jQKXVrSJgGPqDNw/VEag4C1SuuD0fg/6CQbKyL2/TyJhdPXvGRvLb2Jh2W2PlWoM7IXB/dZ53N70tRLv7znnvKEbOEUsIazCG/TykRH1c+q1Di7F3+0ZcQDZs4Jr9g9ssBvE71mbbPa0yzcL1F/H7dHjMUosUd4uZ/4TvnekR2pmK6GnxLVQGuBcF/MCx6DVCwHSG1ySueocrW0aWVUVMVnTx5OB952HqEnNOkLuIsRB44nZoVVnI8FncvUqQxEa8Fo9IWtVJH+z1gDT6LMpTlmFwcnh1o8jZSkEEEMG6QtBUpet/XrYTFOgPZwO5gTMOpeONlFKMd+Xx7bvAnD/9oIQebCmNrOq10UkouE9Bnl1U3daQlB5SMFYVYiI5Y6vjNJuzOwM4Zh1bbdCoISQID/wLjYdp4GVkwxWqfXi4XhQ1s1yjsREByZVmWqrI5CtCKfjxKbYO9vlWd/sqgWmLJ7
 a52aC5QS
 Q86H8BI5t8p2ivYRkUNNvxeKJLEGLt/1hZnzCb0yQPUJg7gTxtpD1HJZZsJLHaDONAbOsbENKhaw+vsQtQqB+lI064ATxvVV9mrLuG5MYFzaMBhWTwBkhnHhCEuQelc8/0sj7nCT+vRII3FeWp3P/jcNZez0w+/gwEt5mgWPTV4gPwYY6vgxrlIEnbjHWOC2jSGDa8/YwnkrStm2fTY2TLf/FWGGA2owvDp9n5VkZ57/Nddi7khExzG/55DLGbIceFBB7nhWLjo/o0j5Eqj/qgEgX4S8ceknRoPN9ridIPu/fAX5rNg7UkB4UVhLSOlxEosnY39P0ZUpfobGHvMrTmRzbY+4uJzaEMhKzABXn7/mY+AF+F6jp8ZNle3XA5ynk4xeZhiddoXw7zkE+6cPbCgwqZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 01:59:24PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Allow pins muxed to the "gpio" or "egpio" function to be requested as
> GPIOs even if pinmux_ops say the controller should be strict.

Why?

-- 
With Best Regards,
Andy Shevchenko



