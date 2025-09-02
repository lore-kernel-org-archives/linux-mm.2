Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60C5CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4FC26B000C; Tue,  2 Sep 2025 10:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E279D6B000D; Tue,  2 Sep 2025 10:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D286B000E; Tue,  2 Sep 2025 10:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C31196B000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:20:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6148BC0175
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:20:29 +0000 (UTC)
X-FDA: 83844520578.27.678A8AD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1E9A580011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:20:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cQPxhns8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756822827; a=rsa-sha256;
	cv=none;
	b=Md3g0iNSHQKl0D8eawdQOoCgmSGEZoFTRc/NtEBk3ADjfKkrLwoL/XffxDo8EmA/9WH0KM
	0gO0mp4aR5J1z4JYFefgtiY8Kw9UMEVdH6nWLz11s/0wj+xamXeJ3R0qX/P3JryuWL/hoz
	XyGR8ZZPQ8GAv7Xa7aMuH/J0xIDjAOc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cQPxhns8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756822827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qHXyTgYlsVDOCondbOXFmhOPZeYBMwy1Jb4bmEJyWmw=;
	b=U4K2c3NOQYh78h8zfqkVwLteu53zW4dyddqy663tC5mn9sACk15g/7BiHj5Qy8ZJGxXkkU
	xf0G5kDz3scAGHjbQwiPHRb2EkWd7YpSrfpEvitFuQuMkdYcEPNnqbju5yM+Aee1N1pzZ8
	+X+oWueWRFdZ/KKEhvZ9aH7OFksO/Tk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756822826; x=1788358826;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=iAXUSwwbvwiZC9bhMY6s6lbOEzUht7j1jWcYwHXsu+I=;
  b=cQPxhns8MHQZenxbPiCBIZ/L0D9MAOHkNmQQvtt97EYxTFc7kpPafqJa
   AhvOIeUXkD7HQd9jTdahYZPNU3UYAU/JVyxF0/vzmIvDl0gJLYcjGJf4/
   tPj7XuD1yoEF2uuOdK+umRraSr+ogGhqsbJRjXZEfZ0Q7Q5t1N4g1ri08
   fhuSnqyjL9bIt71zAmzatUNvQlHt4+8CifJklxIQT7y+XlQxmJNZ4oVSA
   kYQ0X/k+QQwhi6trvJHTsfJvjOVSjYW7ONxNsTaUhDQyOaiffB5JJDfTk
   V3uYMmmXbyKsEugTW54K3GC+XbAmXqOwogdeRGjXN6zq++p52dUZAbXf1
   A==;
X-CSE-ConnectionGUID: 3FeMCDEcRcSCHz9bcy3Z3g==
X-CSE-MsgGUID: ww454mnOSdWRDZtI88hVdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58305906"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="58305906"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:20:24 -0700
X-CSE-ConnectionGUID: MsrrCbkESHiLoR6gD4wQng==
X-CSE-MsgGUID: WARwoctoTZupLE1EBSrbfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="202237611"
Received: from smile.fi.intel.com ([10.237.72.52])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:20:13 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utRrk-0000000AiLA-3gUk;
	Tue, 02 Sep 2025 17:20:08 +0300
Date: Tue, 2 Sep 2025 17:20:08 +0300
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
Message-ID: <aLb9GKnQkAiayqpD@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-1-bb091daedc52@linaro.org>
 <aLbrz5DYS5Yxx_UE@smile.fi.intel.com>
 <CAMRc=Mfx5czDM=vfEYhFtVO3MviYaW4wKBYjGZ9ZnMbr-+T4mg@mail.gmail.com>
 <aLb2HH5zgxdbDiPo@smile.fi.intel.com>
 <CAMRc=Mdp2djgGbgu_uwLSkrtRPomAU=6-SRdzCdSbrHWzS2c2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=Mdp2djgGbgu_uwLSkrtRPomAU=6-SRdzCdSbrHWzS2c2A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E9A580011
X-Stat-Signature: 3c78pywuq8ao7pf34fsjudtrc6hi8m5o
X-HE-Tag: 1756822825-290482
X-HE-Meta: U2FsdGVkX1++woXSiSTQBd0TYHm9ubZSH6GcSj3Dowxgrfl1qMIaQ19APEG2UOzd/apvS5VjaX56aAM8h0nySM2wjmsk1QL/HicSS0rY0MS99wVtPHNxjAnZ3svVxOSc2WlWp/Aa0T6fCFjDziLliPPc/cUVucz1kUCAONBE7X+fY48mVz0GmbHfB1rqWD6M6kPLrOHwY11gjHX9QkUvZjKA+PLy1Pvx8gCJZu1ZCFGGWaKKmstl1x2TqpeSox1VH32EtU31Bkb5a5zzSjEoO1IhYXOvwfoAWHz6KB1GKzj49i9fEUK9WD3MWsEz6KRMUJgqXWL3ftIzKeQ1zbpnVgaNHy0Vbp81f9/SRFAtEylzmoG9bEyuQkgYAf+crowUpXxpBb3Z8noLMfZzuQSkw96JHUPVyjA3h0YzuZWYcCcH7KYstUhFQyK05AZl5a3Le3k6++FR2tOsM6uFl+cE/TNiBvgSE7AlaQhsYMXb5GnjHTLIk6er7p6L41KCsAEK+/5RhobxYKmrsToKVq8hZXz+FRm5fNFnFdpmqeSXOpm5itBDN97lp9Op1neSc1JPOx+G2Iq3a6qV2x+K7lzAqHzOHdG8hNn4kpCO70fZVx7xWTlhswNl2sfNT6rx+fz/Mh18jJr0KLg6/4i3xkjhcZiq89T+a2/hFQEd1Lge3v+NNRmCclqkEmjTF0R+gvIfy5VJmWOwGOLeZ5f9aEYLnA+1D234bwLBkjy2LgiS8VxdfG4WskHVgPzrOmkT/0dTh1RMuCiwpd1hJctYMPp5tjD7wuPEhFtereckn5/T9xcsBPVTG7MLTM6Gi4XYsFWeFjL3LnMLRDFpPnUTyaBa8So6SiCWbtrLFO8XoWEDKe7WlQItKP9Iw7JUOL/ipI1mRQROSAhuQdT3dPsozaZdAWomfHiwjlmPCa9ucAhBLrUpgotUeSEtIOVkvG53dNNJ89fX4W+tbQIkHh1PONl
 ubPnIqPW
 p8RfDwg5SyZhoIT6LSQlJ9OZP+7lZTZTr6lVWL+0xsDXjE//Sjt/Nx9i/Tyt7bKZBT6cwvygjWnUDEkRMvGCoZMFA8FtMD8jRiDxb6kTBWse2iG1NEjh8tcFzs285b9muyvu2D4P4nDsDtW05TDbHvaeimu8e6TabNoG3IIA4q2IItxpcUcF2+WVb6ccVN0LOEHRTl4lZ+sHkFzMtnAZrGmOFcHomoQqqkrCihUPEAiVb+XCHhnqgVrCGBrEGBv36hzfYg2+mnqDdX1LyK6qiWyovxwj8RWjL3e78H5uIC5wuCBc3aPOzT7JdyG+UoQloVvE90arHa8hMx343P5X757LO5kobti72s25oXTa716itIBqXfdCUbBjBDxWmNm7iYbU8wknRM3+A7c4ZnAIxSgnh+CLT+SMsr02j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 04:02:27PM +0200, Bartosz Golaszewski wrote:
> On Tue, Sep 2, 2025 at 3:50 PM Andy Shevchenko
> <andriy.shevchenko@intel.com> wrote:
> > On Tue, Sep 02, 2025 at 03:29:31PM +0200, Bartosz Golaszewski wrote:
> > > On Tue, Sep 2, 2025 at 3:06 PM Andy Shevchenko
> > > <andriy.shevchenko@intel.com> wrote:
> > > > On Tue, Sep 02, 2025 at 01:59:10PM +0200, Bartosz Golaszewski wrote:

...

> > > > Fixes?
> > >
> > > This has always been like that.
> > >
> > > > Reported?
> > >
> > > I mean, technically Mark Brown reported my previous patch failing but
> > > I don't think we do this if we're still within the same series just
> > > another iteration?
> > >
> > > > Closes?
> > >
> > > Ditto.
> >
> > I meant that this fixes a potential issue disregard to your series, right?
> 
> No, as long as the imx driver keeps putting stuff into the pin
> function radix tree directly, this cannot happen. The issue was
> triggered by the discrepancy between the number of added selectors and
> the hardcoded number of functions (we started at 0 which was not in
> the radix tree and crashed before we got to 1).

Ah, thanks for the explanation. The problem is that current commit message
implies a (potential) but lurking somewhere (regardless IMX case). Can you
amend it to make more explicit that there is no bug right now.

-- 
With Best Regards,
Andy Shevchenko



