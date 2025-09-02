Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAFBCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457478E0003; Tue,  2 Sep 2025 10:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42EE98E0001; Tue,  2 Sep 2025 10:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36BA88E0003; Tue,  2 Sep 2025 10:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 236278E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:31:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C60AB84990
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:31:20 +0000 (UTC)
X-FDA: 83844547920.01.7E291BA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id 64D5380013
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:31:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hi7F8Pqx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756823478; a=rsa-sha256;
	cv=none;
	b=Jq3ifX+ukU5MbOr6TFWu9fsjh9/rDTwhNYHpD28fLVY/8s2YJQSeqkkuIXTqS63meEfYrf
	7LiJudx5ptJJyUe344ffRt5TdE0dHx3eTbmqrOzGN3BvmRTgfFQowzDsJXVC944Q6eZX24
	PCowkhhg70Jpr0mS7VWoqwk+XmjhoYc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hi7F8Pqx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756823478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tasK8TskdTx60J9GJNRpcyksYAQk990fnvsSxxEeMs8=;
	b=AtxVOaFQralR5+uQ7gZc4gA4oWBoYdpeSMu1WwCJwLs4Hm5JCUKmPM+0/SC6pYkRwilkkR
	F3NdFKkTLEps5hnMSh0531XyMrm7ddMJzVEZwgiabAAKoJhlcEAA+S2qaMaRZpEp3+xmjt
	3Jro3DB9xSKJ/wUjH/dLhaKPvQLl5gc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756823478; x=1788359478;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wNLf2ov03mImFGkf61U7OTdGwEMuGY1mZCV4bcE5xQ4=;
  b=hi7F8PqxTiWmXg6tOg2omhuA8qoAj1WmL2vsIhAh++8y2daC+M56gfv8
   OJ04UBZMGEfUbTKFmlWjNST+zfchgROgDLecQy+PhAalpzreLiLtbuyhG
   9r8xqXc8TR0M6hyjO8GHw8Y77SqvfQ2+TsVEDAv1F2icxHwzVqbwRiS4i
   zdCK+819Z3deGa+JTJNaVzJMM5T4laD6qXOu3vUP865+vBEY30lMNK73w
   qWbrHPx/Iy5UJ0juwbiniKCgS7T+mMgxaZf+QCiP2b6Cln5APBk/5CVhj
   DPhiGZbTHJ/MURdjtPnjiQEEZPzSnaMbTaDWIcQFWU4Si4Ppsn9pCIMRq
   g==;
X-CSE-ConnectionGUID: QcjstPy/SgWPZT4bLTO0Fg==
X-CSE-MsgGUID: 7F1vjFJQT8aH1AzLymHkhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="76543118"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="76543118"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:31:16 -0700
X-CSE-ConnectionGUID: fiXJ/SYAR0Our4Y6vRb6cQ==
X-CSE-MsgGUID: /BXe/BoATnONrCvRrOtmbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="171186010"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 07:31:04 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utS2G-0000000AiTf-1Q9X;
	Tue, 02 Sep 2025 17:31:00 +0300
Date: Tue, 2 Sep 2025 17:31:00 +0300
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
Subject: Re: [PATCH v7 13/16] pinctrl: allow to mark pin functions as
 requestable GPIOs
Message-ID: <aLb_pOG-yc-CHoiY@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-13-bb091daedc52@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-13-bb091daedc52@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 64D5380013
X-Stat-Signature: at3q45rzdafkx1pokzdpmgqycmtdzg6u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756823478-338872
X-HE-Meta: U2FsdGVkX19hYlg32gu0D4w5HRQXsOLTc71MtyKXXYRZ8tASwZv7l5EDwFsn8gO7/XYC9aFji0OKl+fu/VeKLrL+IunVvdIAk0Zqd+KsCOkCtkfJwYLSezqZQyVRzTFfX6mJR8QnZp5YVNhOHjb3uwZUSjgY8/iF2AFLu/eFaX4Z/Ow0U+u57VlMW9LQfjOszNETkiU0iPmKwwn6Hld/WsyPy12ILZCqT+Ki7LY21eqb+ITbrXWfpOJYWm0Tx3Tugzu7XyLmgweOd2eznD0HiHeUQRhvyBMfjzTdGZx8+q7kTFfPwop/QUqBR05SjUb4nCAmdUC7/blCa1bWhGg7uhDZwHAxWUpfosONVl48yHmUcgmoazuj/X40E8dx7LQSAx5DB8283n2ytGIArRUCymIdG0Wr6lTxKUmV8yGvKIgGWx8+18QcvfJaRGB1PeihPhjo4o3truPOPClkP2D0a9n82GIK1spKl79g2mDXamCojDBo5xMk8X76xlHeOwXC6rnV01MKV6ohrcGMVodwR86QjaY2ZxQ2nQdRiL5dDELL/ILs+ABPyNtuRs0OMLfb++AI8+T6teeeoOX5I4mlfQhJ0K5xCoXf5miRn677sZjobJ/vvub5zcDF432m2GixRmarebFAvbMgl/61kxF8sZsrn6zEoqsPtG77aqDiirXAxiycmxq3aMwaH4U0b53qiMZn9uypLL39146aSiPdjnvpTNfWDlRzcnYa3Jgfc/yIaF/nge0UpA8ahwkwvf4j3tGPfA+dBY2ADeaJzAHTYc/dS8r4Y05uXv1O0cSfebOsDjHNaPBhxJhX6TSCZjeEvCFdc5W8NmGywjlIwErIqPQfM9LaWe9HIqeBazcHP/CN+USDlxFDVCK0t1A/corSQ1DSAmrXcXi2vl8mtQ6j6OxuwYREMKygHvgZVaVO84Is/NgLBfH/OqBxAGU+/SVc7WLvfJvqWfycYkOdYOW
 qaa76Rid
 FG6cBHz5E5/zhklt3s9XNQKZcXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 01:59:22PM +0200, Bartosz Golaszewski wrote:
> 
> The name of the pin function has no real meaning to pinctrl core and is
> there only for human readability of device properties. Some pins are
> muxed as GPIOs but for "strict" pinmuxers it's impossible to request
> them as GPIOs if they're bound to a devide - even if their function name
> explicitly says "gpio". Add a new field to struct pinfunction that
> allows to pass additional flags to pinctrl core.

Which I disagree with. The pin control _knows_ about itself. If one needs
to request a pin as GPIO it can be done differently (perhaps with a new,
special callback or with the existing ones, I need to dive to this).
On a brief view this can be done in the same way as valid_mask in GPIO,
actually this is exactly what should be (re-)used in my opinion here.

> While we could go with
> a boolean "is_gpio" field, a flags field is more future-proof.

This sentence is probably extra in the commit message and can be omitted.

> If the PINFUNCTION_FLAG_GPIO is set for a given function, the pin muxed
> to it can be requested as GPIO even on strict pin controllers.

So. this changes the contract between pin control (mux) core and drivers.
Why? How is it supposed to work on the really strict controllers, please?

> Add a new callback to struct pinmux_ops - function_is_gpio() - that allows
> pinmux core to inspect a function and see if it's a GPIO one. Provide a
> generic implementation of this callback.

-- 
With Best Regards,
Andy Shevchenko



