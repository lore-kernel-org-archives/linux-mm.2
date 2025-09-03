Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F83ECA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839968E0007; Wed,  3 Sep 2025 06:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8109D8E0002; Wed,  3 Sep 2025 06:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7267A8E0007; Wed,  3 Sep 2025 06:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 626548E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:38:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 155BA13B2DB
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:38:48 +0000 (UTC)
X-FDA: 83847590736.11.1AFF307
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54532A000A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:38:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AG5HwmcZ;
	spf=pass (imf15.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756895926; a=rsa-sha256;
	cv=none;
	b=HALiLHTwVsV1exvycRJ2TXlYCHlVGUc5K4PgXW1vUWhjecUJD6nDc0orbDcSchzANchosL
	08DsSuhFztfs6+7pdaJtLlzXrKxE3pEdiWqDAk6N8EuBlUYVW5CNMNA5/zun9k/oPk4xG0
	gxePTYdlp4KQE8/IDQrPfpiNdeqQnME=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AG5HwmcZ;
	spf=pass (imf15.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756895926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpoJObt3fXHmnCgApXAd+PJkE0iJXu1bG38S0G7zckA=;
	b=SMQWq7FnRcsfga2fRYxqrUXU2pbITCLgL6/BNpw6o0Vc1dJ6SllqzsbFXtusrbih9N/PVM
	XrYuiW4ukwA1J8apSj03NEZEnETOJo2waDnv02hT5ygToIlGINwBWcJbiSBr2XOCOn17GU
	7lVQJVI5HlP/UQdp3RU89vL6lBBHNDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756895925; x=1788431925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GCTF1UYtOSCeRAlhubdQAJ7qhlBqyZpfpnhA1MMIZJE=;
  b=AG5HwmcZ4MXQjE0JiaqcTrX55XRiU1vxrhMhuIdyNXMs/sB7Tm0A73oJ
   AeHIUjgPVlOC2/nWB1Jwu2MDyMoKOXUgD3E8gqdAnMoyG7Z8RzDgUWTpU
   xgAsoD6QosUCEboll+6GnyUolFHFgwz8ATO88A6Yr4mEZILcQIP5dX/OI
   znEvQoaFiuZGMBJ06vt5P+gfx8Syx3EhWuqtUX7Q4aAKYWOoi9bz+CDIp
   Stz7p+EfGiyl2BV44RNcpGi2/g4yW0ViynpFck0heTTeMGxh+39cHV7ZE
   0poMQLrUGBJ6Ac0bIydhrf5spVe9uhHHsDh9Kf5kIkimgJPAJ6KKtg7yv
   g==;
X-CSE-ConnectionGUID: 4jByi+/tQpqbyX0U7SSM1g==
X-CSE-MsgGUID: sfqWiV9bTEyB15EuIMnKTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="70632583"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="70632583"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 03:38:43 -0700
X-CSE-ConnectionGUID: gcUgIZtvSDO2dFM95UNdfw==
X-CSE-MsgGUID: hQkiLlfsRpSs+9G/ykDw9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="202430131"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 03:38:33 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utksl-0000000AxU5-0dpr;
	Wed, 03 Sep 2025 13:38:27 +0300
Date: Wed, 3 Sep 2025 13:38:26 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
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
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
Message-ID: <aLgaoivmBUgoeO6B@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com>
 <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
 <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
 <aLgW7J-j4nn0u8uo@smile.fi.intel.com>
 <CAMRc=MdA21fwnamymG6YhqBjKDso_nJs_4xefPNONQNfEcPHXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=MdA21fwnamymG6YhqBjKDso_nJs_4xefPNONQNfEcPHXA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54532A000A
X-Stat-Signature: mfx5io9k89inbn5cid3q1s4c6p586wfg
X-Rspam-User: 
X-HE-Tag: 1756895925-467786
X-HE-Meta: U2FsdGVkX1/H5enFMPLr4w4+DopKD7RtCM4Q+6/qbSFgjRNAehnxtXT0yXcbWqk1Kf3AZ846VkOIPKTdaiM0MhYiGlj77mqhdyizsWbD/CiFj3GHrkh1uYJ0S8WwEB5/Dsnom/j7HF9GqRr3egsz5Yk9C2s7ahSsMrYo+2dY4xlLk8qxCpqy+4bswgxucp6yz2gdSdWeV43uBSIKtd7ESJXIxvL3TQyf9YHBYIZT9tvd73Shu/ZQeJLZWxEnzHZKSzluoDBJtl4fxJAjKaiJUnWnOq+x3syB8GSfKkZ7qNENIxMti4VZeq6pf6wr1yi7MgAuZMpDwYEjxeCCHNgzdM5BNt7KIJcSGM5NNDSjPyrvNJ0PIJswgmlAkP23XMB0A4Rg6nYSR31n+2KEL20pj1cvP9NzqNpNLOuPBnBUAECNU1Ri2xag0yqPBdjSjhcAjrLYFvnaViA3qCUIeKjA74NX7ZEIcLwqItsAZYgNR3kZzZmF1w1IEUuUGhVrabKe7fA41JdrMJKgFacoxH46JH+RwLIa/hQ0Uxa30JuFla2QIr+5Qb5UnAApyxCF/w9R1uC4lkMop11tEm3HjeH0afgMy2YojuN4Tf19zgXVQgyEITuiei5RJ7CKfxOxCOsPB8KaIMuh5PzvHJka0F8lgvK37quw+jovrVynctSoxDidFsKDkq73AX4DXuXmzwEMzACDEy5bgFIPLt3sfLeBT3WAjFAwQx3KMk8Rp7tJFcor3yX7frAM/0NaNRrQGxMyNmumWP+NKjzm2yNLJrmi7gp/A0uUjjTvz8AVKaweMW66a4GHuwjKYJ18M3mAS+sPNgd2gNPjLraY01ZxareCog2uxxcCnwTqgbWj9zlBfv8QtGr5AUYPtGtOVhjmVkjmL0xO7hPGhVqFS8XTCU1igJUfRlixiuufjdmJ5ONfviGOuFD/lMb51Gfq9wzSTem1VBIgWynSOw93KZFmOFj
 5M2IHUdK
 5DaUUAOq6KDYP53/F1+O0YRfaRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 12:34:00PM +0200, Bartosz Golaszewski wrote:
> On Wed, Sep 3, 2025 at 12:22 PM Andy Shevchenko
> <andriy.shevchenko@intel.com> wrote:
> > On Wed, Sep 03, 2025 at 09:33:34AM +0200, Bartosz Golaszewski wrote:
> > > On Tue, Sep 2, 2025 at 10:46 PM Andy Shevchenko
> > > <andy.shevchenko@gmail.com> wrote:
> > > > On Tue, Sep 2, 2025 at 8:42 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > > > On Tue, Sep 2, 2025 at 4:38 PM Andy Shevchenko
> > > > > <andriy.shevchenko@intel.com> wrote:
> > > > > > On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski wrote:

...

> > > > > > > The strict flag in struct pinmux_ops disallows the usage of the same pin
> > > > > > > as a GPIO and for another function. Without it, a rouge user-space
> > > > > > > process with enough privileges (or even a buggy driver) can request a
> > > > > > > used pin as GPIO and drive it, potentially confusing devices or even
> > > > > > > crashing the system. Set it globally for all pinctrl-msm users.
> > > > > >
> > > > > > How does this keep (or allow) I²C generic recovery mechanism to work?
> > >
> > > Anyway, what is your point? I don't think it has any impact on this.
> >
> > If we have a group of pins that are marked as I²C, and we want to use recovery
> > via GPIOs, would it be still possible to request as GPIO when controller driver
> > is in the strict mode?
> 
> Yes, if you mark that function as a "GPIO" function in the pin
> controller driver.

How would it prevent from requesting from user space?

-- 
With Best Regards,
Andy Shevchenko



