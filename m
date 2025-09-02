Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1673CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D548E0008; Tue,  2 Sep 2025 09:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64DC8E0005; Tue,  2 Sep 2025 09:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AC78E0008; Tue,  2 Sep 2025 09:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD12F8E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:10:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6083C1A016D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:10:25 +0000 (UTC)
X-FDA: 83844344010.11.962E795
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 18A37120015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:10:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SLCOT4T5;
	spf=pass (imf29.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756818623; a=rsa-sha256;
	cv=none;
	b=4/+tP7+s0/ypMsU49BRBEQ97pNWrcNhr7z1LUpfc5FR8LpE85/vlkLWM98y0SrQ7Zu97iW
	OkjQpXZMpATRA0srLhY6A6v9jtJXXzKANciK7uqRICvngWIzPxkolCIgg+HAAl8xntfzs6
	5UyMUFAFHOwfrPFG9HSU7liHsywJZSA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SLCOT4T5;
	spf=pass (imf29.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756818623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pDO3CiZDcgl6FpTMD0qpu93FtQQ0Hu54ZUk55r1Ur4=;
	b=MZbx4NaXhGiz5BYCGk67QnXZTSFTRKhC4YARmDPyoKZ0irn/DoP1Zxr3ZyBPpH2NoJyWgu
	cpS8NMmn/QZWxmvkgGQzQ3Huf6ISzglvpLu3i09gjKvXoK6VV/6NK8i94m5utlX1gY4cma
	QUW4hnlojmbuou/TQf0lOW/wAPms3tU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756818623; x=1788354623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1LweHExYhd8TIGAtsNsPF1dVuZ9HmUdwiz8regfEmyY=;
  b=SLCOT4T5qLpZpZl7fHQyAljcIndFmagyl8OX5Jd/6deJ9FphAMxNHgFv
   J68jHmg6azBtxFzZWvE8Omf45+esXU+nDASf4a3i5mpDmtwmgnMnxqmyk
   ao+286l9BjMIBqG/w21l4WVZvLOQVYMHnDEV8pz7bKy1i/DqRNapFdz/Q
   zivN0cZm79POIPgf4bX9ArvKNZO/vZ4jvEBYpTcEEIyfQ8jPhrrSP1QLE
   fFdP5U1G5+ks5tnek4yttZmuPvRD3cUen04iYd3MnLqg1ZYoYyyMlXJZG
   59eTBHRFwCKjq3pS2yV1xHv42Mjdp6WLfT5Omjiy8AOSg5gLWD3WsyPz9
   A==;
X-CSE-ConnectionGUID: cABV2O5OQMqf1HoQY/WeRA==
X-CSE-MsgGUID: GVN5ROLIRMq/IK1ICDV+Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58296867"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="58296867"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:10:21 -0700
X-CSE-ConnectionGUID: ABQ3ZIn+Qu67Yn1YR+Rhyg==
X-CSE-MsgGUID: rodiyp3KRASXPRSRymwAzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="175651755"
Received: from smile.fi.intel.com ([10.237.72.52])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:10:12 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utQlz-0000000AhRr-2lqG;
	Tue, 02 Sep 2025 16:10:07 +0300
Date: Tue, 2 Sep 2025 16:10:07 +0300
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v7 08/16] pinctrl: keembay: release allocated memory in
 detach path
Message-ID: <aLbsr4s7nfvCKLnd@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-8-bb091daedc52@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-8-bb091daedc52@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18A37120015
X-Stat-Signature: k5qy8xesrzj67gd44h17tc7yr916z3i9
X-Rspam-User: 
X-HE-Tag: 1756818622-55786
X-HE-Meta: U2FsdGVkX19aO9jcUMTov9IEQYcCFTit+1v3je+laP8eGa3qdbBTJ0NQX5t3VmaA1qqgJ58syLdp4Cij/ONS1hwok6riuj3185RRzPep3qMYV+Qo0Vm0P8TkyIQGAnZjEIeAHi9mUb2wCqw2osFHwPFsxmTjoVlAdXlNXpRWzca/aiKvr++TUv0ea+fbUrfV8Amf0m2uQYmIfgfSuVCu5oKtpUJWl00SwP79WxTe/QL63Ea0gcrysnV3IepZ1v16H4CJ8v5Usp9GSdg2eVNj9ALdTC/TijB7v8pvutI6aGqzcacwjy6MdeooZCmmsaGfWskRdHehPcbr90HOKvSUyRSKBQmlOvzkOiQLd3CslDdl6n7p7k4z+zo7gpVJYAzijPpIN4gwqiH9Y4iGK8qQpDVZgPgUPQY8/hMsKi+LgL1jUEawYZde9yyK7VE76/DrRbnB0eFc+FPM/UW+zttXjZqeHDJf3J9JpP53Y6MQF2XqD0bstWswZB/TBDIDNz4DyoDnydn0AlNn0TBU7lhgLq4NfWhH0lvs9w5tuPXSoQ4HZeGLpfTpUrOgezuRoTdh+wXo1NtKMmlgGFsoYry5KEUFBhXxXXMkCPfHPloF2xrZJUxFKJK5UNVFYKsXOy0tl3xzTn7la3XnTccHJT1e5GEOEcE4Xl1SK/5T4FShtaFATBw5Zt5up7NrdDSgU/9cO6o9jyJgNrgNkHQZiVMdX0lJXEFvNKqiJqjxHe8f1ZknJq1lIGlFgD2BvR0Vv3WrI0J6/ib1cVIggMhifA1u7vfsKoE2u36Xo84oqNfN2acWZWztCpt+XBObr/XfAQBxItsw5EweF2agGWGThDMyXlyo9aDvbRobvFHHrsfGUE+SCD/jm1niqlE2E/su++AQ6uslVMP74uJ6nawJoEofSgxFtk1FMFjgNSempV0W5lyRc0Qios6MSjQ4NZI6pfJPMGOWOcZ8Eyq+3qfqLnl
 bGm901t/
 WCdxLT5NRrC51hp/qKsCPvkHj1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 01:59:17PM +0200, Bartosz Golaszewski wrote:
> 
> Unlike all the other allocations in this driver, the memory for storing
> the pin function descriptions allocated with kcalloc() and later resized
> with krealloc() is never freed. Use devres like elsewhere to handle
> that. While at it - replace krealloc() with more suitable
> devm_krealloc_array().

With that in mind...

> Note: the logic in this module is pretty convoluted and could probably
> use some revisiting, we should probably be able to calculate the exact
> amount of memory needed in advance or even skip the allocation
> altogether and just add each function to the radix tree separately.

...

> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>

This tag is not applicable to all patches, I do not believe this has been
tested.

...

> -	keembay_funcs = kcalloc(kpc->npins * 8, sizeof(*keembay_funcs), GFP_KERNEL);
> +	keembay_funcs = devm_kcalloc(kpc->dev, kpc->npins * 8,

...switching to size_mul() also adds more robustness against too big npins
values.

> +				     sizeof(*keembay_funcs), GFP_KERNEL);

-- 
With Best Regards,
Andy Shevchenko



