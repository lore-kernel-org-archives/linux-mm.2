Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44838CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88F028E000E; Wed,  3 Sep 2025 07:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866918E0001; Wed,  3 Sep 2025 07:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CEE8E000E; Wed,  3 Sep 2025 07:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6726C8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:52:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 313B21605F2
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:52:21 +0000 (UTC)
X-FDA: 83847776082.12.0CE9888
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id D6D9F40004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:52:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kvHUnwvV;
	spf=pass (imf12.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756900339; a=rsa-sha256;
	cv=none;
	b=o25d17J7wPv1vwQQMEn7wYXplPNSTkpn+s2ssd+jp2OTLLFWgikjXioPPN+yra22DJ3+UM
	8UsjQ1hRml+yRc9EBKWKXi30sV2laHVCkduYUcU8FD7ltXKSu/zpXNExdIUSWEWJ34iG+h
	V5ACjShrY+/6gQPLgPzGqC7d4cXdDwA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kvHUnwvV;
	spf=pass (imf12.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756900339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHZN4q7ULscnLBVN5oyiAwBFdj4bB2ZTF7RZxwdQl7g=;
	b=KQ9MhcDb4oJSrRnLkQYr7CExE5efF5dCMOa9Gzy0ggpsvAcMsOzxXzx9dDo5iau2Ahh4nK
	y/5ytICAMI+CbbvgLzYSnw8xOmT6/KuYV6g9DR7jzO5YbkomcY65y4UnR2y62ZEz63Baku
	wpgFtQWYPLGKWK64cSRf8qS1qpOhDiY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756900339; x=1788436339;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rCkMsvnUjuBn7HONdhIgvsPhXdCF7ZF1EijdEX8RKxc=;
  b=kvHUnwvV/N0ZPGXC2V6Ond7NHVlRL23Sf5tjPcVX2ANRRXFZbH3ttL/L
   LmsGeSb3zORhtOYsh27LPkNn393bSKuom3rBNn+m7pRB2A0bGhGljKYJL
   6oE0D59b8i9rj3cFjiProl//iW+54WcFXi6yCK2wVoSr5ikFUNtFJhM1G
   3V7jvEtrvlZG69yelk4lAFJvkcXACdVBR9Cc7bO9dU7YlxWC5SWbqXpvN
   jrVj+K4dRHhqmZytCX935aRfgJ2sO9V3HzrvV9L2ibmtQb4JhmUwWKqcH
   Us9CBjRVPgIEifKfEe0aS+I0a/iFUuIhuyLpz0F+Bt7yRP/sBzMCtu3eF
   w==;
X-CSE-ConnectionGUID: qkjNrjQwRDKKHIOglcSJpA==
X-CSE-MsgGUID: zRraFdN7S2GVA+aE+pV0cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63043883"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63043883"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 04:52:17 -0700
X-CSE-ConnectionGUID: LSXzFaryTGiV559A8n4EkQ==
X-CSE-MsgGUID: vvcyrhQPS3KYbuchLY9f0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,235,1751266800"; 
   d="scan'208";a="176849676"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 04:52:06 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utm1v-0000000AyQf-39cY;
	Wed, 03 Sep 2025 14:51:59 +0300
Date: Wed, 3 Sep 2025 14:51:59 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>,
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
Message-ID: <aLgr30rvGBCcsOWa@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <CACRpkdZ-Toq9MziPisZCcT7zcL3rosQYZ1Jw=RWCH1KZTbeBug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ-Toq9MziPisZCcT7zcL3rosQYZ1Jw=RWCH1KZTbeBug@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D6D9F40004
X-Stat-Signature: pfzqoaphfbawsarhn7g6cussin93cqzy
X-Rspam-User: 
X-HE-Tag: 1756900338-150140
X-HE-Meta: U2FsdGVkX1/yRN+bJAM3MPR0hSBLudzWFDLUN1xYoFn6hklwRaexUG1RGbFvlTagPqSFvxxZpkdtlpNLh8KDRzVT6r1oB5IvuEfH2qG+16oMruShQrU+qNu7L54h3yCycFuXjF+rG3VhgZ4OzTT9BHmhdTO3v5vTZ+97JzLXYmVFt8i/bRqvqVwm+R12BRZTdV+f0nf/36QGRT+72U0pyYoOnAaGwzXu7qdAE9b+ZywdhLQy3bAODSiGwN8hX4EG6Nx7uErUlqDvfNgsVtf6/pr5+se+0Lm/WgdXgFRRq2f/i8q1+msFu08uKcw3TZoi/QMqPrvPvBarYm8Wr841nWp9hvNJuWd8Za44WnPeMAP9IhT+KcoNtKxo6xBqqfnfPb748YI4CzV5eyzJI2LhZbvWFOLX0xpp0NZoMgxqHmY8eFew4QQz7sNXgrZkZeYTx6E0yCWf2zwB1IvZtPacst48p4KdGgS62/QNKLJSbQSpYoqAN7tGItN4wgIfMHR5z3zfVKYk/jXO1ub3Zj4MPaT4d9lbBdteuKcla6mcTlQwFUPwlYlw3mV6Tfyfz7vd8ZKpRe/V82MX+CtyvkxLJqhrxj+tDaMt06CYdWSF8n/xqygAgO1UvjVmX6YyS/sR2x+72/StNUlOTcQ7fU/+p0+iro2rR3J/kOzLnh70+Fkq1oAryUYyRr/kk0ghC6sEXld6nQVIUQS/+veGjt3aZsdV3nvpqoj5K/IVib26+1ABDeT6Zi79oX5FgmKXymqm5uu39mWLUijHYxcNPCjPgIzfVD7iGoUzYvQcO1wSTAUT/lt9tcX4a5w1NCm/kTFtZpKI2es5jS7DEorVxlVuqIW3goQsfmBaHWs3XIPQtVNM349DOuTO3tbe6u8NoxwBQcO3awrddDIgOoVqLobIUSWbz/rqX0/G8bs3McZDumAWpNlex1lOpBjk/t8geqblmuoeMKDsSgTQTqG+JK4
 5CgM/ItQ
 oIQFoEeq8kHn9mk94I1FFj3yVYVndN2Ox0WMfEpzjZMBEXW91Avqe94W/FBan0l2zlTGtBGuXcXgmJlA7r61oMGjjBBI4lGEbJAAofe31tpM+vB16mYp8zXMeN6BVjvQraKHOcuevrbBjhDvWscasHK6yXBlTsck3wJmYuSpnDnZwnioBfyFFnDEs51ag/p3OUMsE4CiY3VONspzNSUpPpJ8e8ufApGjV+hxFIXR1o5f2iJFPVL5YjH8avi5njQiAWbk55IKJfsXZxjSQFb81+eX7zQctZh/zbiLre9lT7e7SVjQsuzhVW29AWiGACu8s7D6YOetAwZpm3QwFKo+NXVFiCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 12:18:18AM +0200, Linus Walleij wrote:
> On Tue, Sep 2, 2025 at 1:59 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> 
> > We have many Qualcomm SoCs (and I can imagine it's a common pattern in
> > other platforms as well) where we mux a pin to "gpio" function using the
> > `pinctrl-X` property in order to configure bias or drive-strength and
> > then access it using the gpiod API. This makes it impossible to mark the
> > pin controller module as "strict".
> >
> > This series proposes to introduce a concept of a sub-category of
> > pinfunctions: GPIO functions where the above is not true and the pin
> > muxed as a GPIO can still be accessed via the GPIO consumer API even for
> > strict pinmuxers.
> 
> This is what I want for pin control, and fixes an ages old issue
> that pin control has no intrinsic awareness of if a pin is muxed
> to a function providing GPIO.
> So patches applied!

No objections, let's move on.

> Any remaining code nitpicks can be fixed in-tree, I need this
> to be able to apply the much desired Broadcom STB driver,
> so this needs to go into -next now for cooking.
> 
> I also want to strictify some drivers using this, bringing GPIO
> function awareness into them, which is a good thing!

Well said!

-- 
With Best Regards,
Andy Shevchenko



