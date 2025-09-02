Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E02D7CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CCFE8E0008; Tue,  2 Sep 2025 10:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D478E0007; Tue,  2 Sep 2025 10:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245AC8E0008; Tue,  2 Sep 2025 10:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 102088E0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:39:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D16E784819
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:39:01 +0000 (UTC)
X-FDA: 83844567282.26.C3ABFD4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf09.hostedemail.com (Postfix) with ESMTP id CEFFB140011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:38:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iD9XVOxb;
	spf=pass (imf09.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756823939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WF7aEQnm0jLfAjvjTd4aQ7WUKxi91KNM+dqsY4Waks=;
	b=NA0mH9nbA7gLi1fDsLrfFE9TBEkgT5MfFTLHDahXeCRN2bM3yVuCjPY9qb2kaZFtZ9j+i5
	vjdmX6cZrsSF6JlJ0OCXl5HvK4G6afKXbMYIRgO1luL2t898UlhGLfYljRP7FrJijXJsO/
	bfki41ahXLQi0zv+2etOuBNePLleH1o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iD9XVOxb;
	spf=pass (imf09.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756823939; a=rsa-sha256;
	cv=none;
	b=Tq2yU23tDEjOSGdnKkPlEg148BYnxxTLj0VQ6LTat4N3ijAxNvq07ANBm0Zh7/1AJIhFgw
	ovRNGNH0NV2D3RBF3vf9Oef6dMNQcyv2tYJcVmHQ3NXLLugeScO4TNAN95TDTo0wLMZiXa
	y1r4JE161b6BPZTqcChYVufVrLeY+2w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756823939; x=1788359939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZYIXrBHD4yIy6w4Vca2iFtAhmSRGyH8KSR03FUXVhpM=;
  b=iD9XVOxbucOkfNww55xnUBBPa8fj8ex5WtzGUUzbvAI2GANK/+znEAIy
   +BDm32fFU8UmZ7fHXZ5ltXHeAJAJOQwuY3QSYFNoYOseRd1Q7WkwB795Y
   w3afsnr1P6VRgyfKV6zeGKeeSpUm/kKZjGPfkLv7peOR4c1dLGjPaVRRp
   hKvCQlDDZg/gTW7R/bZPgEyUf/z6ATJusLCf34NfifVx2x4LkBVSXDyHN
   yr447UnnQ5B4VCxJGC+j8PvOZhqnnt2M2J3QjvR65dsNJn8qzzEoXsW97
   KmJ2qE7OpkOd34PqD72pyiQ8larfAPpgqRhr2zGD8B7+/g0u6mEtgDr4l
   Q==;
X-CSE-ConnectionGUID: ZjcIDHo3RV2tCtbjMeImOg==
X-CSE-MsgGUID: wSCKLuJJQY2oqO5ZjVTyrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81685670"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81685670"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:38:58 -0700
X-CSE-ConnectionGUID: kELmzdc/Ro+s1d7reAqBKA==
X-CSE-MsgGUID: V+D0bl4QSJiRO98p+FkBCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="175657994"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:38:47 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utS9j-0000000AiZa-008W;
	Tue, 02 Sep 2025 17:38:43 +0300
Date: Tue, 2 Sep 2025 17:38:42 +0300
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
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
Message-ID: <aLcBcjvMbrxoDYoC@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Stat-Signature: zx7f3e4b8ho8rt5cka15pesctkqtprdp
X-Rspam-User: 
X-Rspamd-Queue-Id: CEFFB140011
X-Rspamd-Server: rspam05
X-HE-Tag: 1756823938-806339
X-HE-Meta: U2FsdGVkX19b3Pq49tlBmjeRivYgF4qrz5blV2U3EUPIAQ1YnbqgBcML7Aw1QpAkXVT4pyKAyZILSI0hGAKnrqtgmUfz8aeTvdLBHnGf/QkToRQ5g9MM7RxSB93gu1xPBP2aEirshYSJ7gBN7+QPZi+XZ7nAQLAeXMgKU93Whw8/EAGnf899c2VGhMDSRIpfZgfa1prInUo2Qzmor7Ho8zeRtvXyqe9u9qQgU5uOFjSh9Ld2XjOEuTfeW/FKxF8eFIXFD2t0ZErlg2gvvP74jy8xYfBbAbb4SSFYCEhHIIooN1HAXwQfruYMn7m6gwIz4FqmRw6u3dmADvrTNwp4VBrY4fNr7jqdQQM+LpesAV4QUHu+GKTgWc44IORmXT0PoMO5YsjCWHryn8D8DkBXp5HnUX0gC7P/VtF/9uaKwTK2i/AwpQbKreIWL1J2s4HM9MhQR2TMQ9w1RGQnM03nuTFTOs8u3+uBe2iJmWKPsbvqxiARXBvOEqLw4PrE9DXJgtW9D2DRyXW1f9ixpy3g3SaWiuB+QDpLpvLfNaDWHdIObXgBq8aAG0AkwuiXzE2iDoaTYwrNuM8SgplBK6IliG3Ri9hm4f2A6+a8PWg0R+8PkpreV6TNSCPhoUw+KbLJkB3bfFUOy2DDk714yv8oaY1A1FhNII5AJ+wqwtLeu16Y2EHu3HjmvI/m/RlfeZL5uhfLM2Xi7u6fkGx8JojJfOlsPqUthM8iVmiSStfSF4+BUeAdMf6VDfWzx5eQJAJQOBOMJsrv0ErYzlXhXZRb2pdB5/eEkhVns6RwtA82aO6iRtQX6bUIM5p6lfiENLQaOlMetn/rvl9Q1SAPBYfOU8JoEhIqbJEDTCnsHpKHqnjfm0o4KgOENzXPSGRMjEZZEvrOr1KH1qBExmhTY5SKuFPz2r+siX6ynnvpyXkgdl2PDT9e26JrLMeijQkiJ2bo2RI7GH9AkzkCPSO2W69
 6FAiEJsw
 QTU2tO354Gwbu0Pwa9vgSZNZXXT2HpTAYQcO4NqODop298X5kulgpngjhlOZY1ZWuV55B8vaCDv+7zZ2g61nbP+FIWGPDw+YFCX9YtMLEkbVlIyz70cgjrDyn4Rh+YAWglFuiXpS5IiOymPozdpxWQWJx2f4qHX2EYNxFhYSaj5k5k7uQ34uN3C8RuhvxMiv42Zz3/C4Vm23iKm1+Qwxb9XMbGxaWxB0pTKcglJyuCug5woGUmZo4E4WvfE8KKK7QApZ9PCT6PzkJZ2TuQvO1gz3LNSzfmv+tf/TMDszyj++Jdbab7FRj4b5Hi8xd1oApZIWSZeCtjVk8spb+IAsjGnu4HJ1ZjeTeXyMC0J42KqfCAFi0BnaP3Kftgj3gxcSGrQrzaPTigRAwTBaZOgZQvZCAUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> The strict flag in struct pinmux_ops disallows the usage of the same pin
> as a GPIO and for another function. Without it, a rouge user-space
> process with enough privileges (or even a buggy driver) can request a
> used pin as GPIO and drive it, potentially confusing devices or even
> crashing the system. Set it globally for all pinctrl-msm users.

How does this keep (or allow) I²C generic recovery mechanism to work?

-- 
With Best Regards,
Andy Shevchenko



