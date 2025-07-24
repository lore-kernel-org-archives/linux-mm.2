Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCE1C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 11:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68FD8E0075; Thu, 24 Jul 2025 07:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40898E0074; Thu, 24 Jul 2025 07:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956838E0075; Thu, 24 Jul 2025 07:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 869C28E0074
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:52:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18BE380333
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:52:50 +0000 (UTC)
X-FDA: 83698996500.15.A316AF3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id 71A684000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:52:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bcRma8CR;
	spf=pass (imf27.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753357968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAYSetqh9eSNkwVhXRc1QeqVbL4i4v1DvR8ou7zVszs=;
	b=mAbLbcFT0bHeMLpJhymMus5bS5OeTasiWBqwHT1I499EZesm2mm0eGx+94c68e/XAdqdDl
	MPtGRrOUXQaebAaoF/sPeXBX2Lklb0SkIzUeKbknu3cq1ByOleNO5GLQnTRDO1C0aioGm5
	8HVZAWvTnRw6suiddOlRgS5axiWNaBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753357968; a=rsa-sha256;
	cv=none;
	b=xQwPoSE8YeQRlE83P3t58TVju5UPLeaUDHbnFoF6pHthoKL4LEp+EG3a9Rs4PPyEsiw+3b
	SAe8q5bkGZf5gIF5uBb+dZazJsM1VVYYuhg/j2uPYCP5O9c8PhFIFLauA/xzJqqnZYr7uS
	eTq44DgJeQHZOQ7VmsAro6ZKJfNkf0w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bcRma8CR;
	spf=pass (imf27.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753357968; x=1784893968;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=skduPBA0XOiRRFwQNtjlPasZ0GUfqz6drj8febfSOhY=;
  b=bcRma8CRP3UW30GkutBL0z8Dp8DbyIw4IlxAV340H1KurmamrVCte0i4
   cAx0ScUU+MdC4+bOXqWMYsFrzSucqQmxKOEQpj8BiSbRPyccXF1ks3JU5
   ibvZnsR16IDV8iOJApOthx0KNZuZf2x1aEcqFzc1uwIg6WGvwXt/OiUE6
   0Dmmog1oeTP/1Cgq2eyeKS9y5S0Oo80uEgLXwCtRA1RMlhSRU70OFCv4j
   1Eb/HiZ5Fqm6gVRoqVVtNnpSFhnlxQ9RypTWyrEIYcNswFMJNEInmDEMv
   hjwCoLyUjmbUQN5ZNvdxl8p+97j8Ocmj4nzd6yZUGylgbl18lhEZcgZSI
   Q==;
X-CSE-ConnectionGUID: 6Y9NMW44QXS3AQc9nrj+Bg==
X-CSE-MsgGUID: kQ4liyjtRwapiXbqmELScA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59473451"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="59473451"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 04:52:46 -0700
X-CSE-ConnectionGUID: gH3texk5RoaLOe2vbIi/aw==
X-CSE-MsgGUID: lF7KjgBaRhmOljQc+wknEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="164253907"
Received: from smile.fi.intel.com ([10.237.72.52])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 04:52:36 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1ueuUx-00000000Yl0-3pfo;
	Thu, 24 Jul 2025 14:52:31 +0300
Date: Thu, 24 Jul 2025 14:52:31 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
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
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	imx@lists.linux.dev, linux-omap@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v3 01/15] lib: provide kmemdup_const()
Message-ID: <aIIef0MDcZiElgN1@smile.fi.intel.com>
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-1-af4db9302de4@linaro.org>
 <e1253b8a-4940-417f-b530-09e57c6a8932@lucifer.local>
 <CAHp75VeWbhuL1pYvEza44Pnb5YUufgY=1WYXSx2nNMJVfcytTA@mail.gmail.com>
 <5c7edf57-bf13-4633-8348-791e0620cc79@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c7edf57-bf13-4633-8348-791e0620cc79@lucifer.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 71A684000C
X-Stat-Signature: o6wy74a4sstb8x3819bfdfcq86twftcf
X-Rspam-User: 
X-HE-Tag: 1753357967-158253
X-HE-Meta: U2FsdGVkX18HgiPcFCxrOr5/kIRuoM35mXGYeTkvVhdp/5+lOTW8C8gn0ew4W4f9IOGawgWJORXWFIN3NQLTN8/shVl6DQC+fkdHMylupVsKqJiY96OOuJ9Cv+V1WNg2W0eZLgbPXQaIabGG2L63gvZk0Os9udIjWNpdVFcyjumhWDh3mWnBnPK+t0oOlGRbcSzGjv+vK4c/mwGryT2Is0sMaHJWQfxCz61ibu0nRVgptrA05z7frVrD+ksmxsdnIwr57RHaTNTF7QeYPAH9u5TJ8qscVFznyQW5AIrwuWSbqUg65a24H5sfvWAH7XzMIQlmre6jALGTIClhbPiQTJJ310u7Huhl9A1H+/HN4tvEVg6VdZP8N19D2dY2V6zhhooAIfrXcJB+Gw82zQVYf+K1SRbLMgYLKr68L0J8H6scuuof0D2po+LpKapHzIV0cPKRn+F58Hkj4xkyNPUKTpN1eDM+QVXsaWPglk1ACeAGkIigZ0bog1KZIQCxxekU43GHd7PLQp7hcFSr5eVBXFSS6gMUS5NvIGG7wqLmaqpWibodirHD3t67F+CQcybRzgM06FBuz2iJgDgAEXxQJzffdnUQjYNU7MfEzraJwZmopaRnxpuUcJ4Hqnhbgmbmp4XIzqFL/HNxEWwNRQYO2jbB284Dvmq27kxnBCD1j/6JKDxR+/zx3600u9aS4Vl6iRoI9e6sEeVxOCKmANkwajos093I8ukoZwUPJzLe9jKasOwNKz0IQ4nVbE7b3r7loMjs9brGV8gLpB9/yAy5UpgpsSdimS4kaJ9nOseN7kd0PY/MmYqoS8kymXulvztZGemS0QMPhyuabJjcVRvewZZ0BbbCwP9YCy4SvqwzRPxoQo9CilX2MjNrhJziVdOA/pOziD8mMcMdX8dNjR2UQcvqhh+4PofVmmcZTiXnyLi781CUmqjyyXQ0JLoo1MjeVH49dJ3KXMXZ4qZSYPJ
 R0zFcd40
 AodTS1Q/+JmNxhYtx4avpdgzOqxMkXu3mN8amqV8qmys8TicTRrAbO9w7bB+T2/ohG5Uv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 12:15:11PM +0100, Lorenzo Stoakes wrote:
> On Thu, Jul 24, 2025 at 01:12:49PM +0200, Andy Shevchenko wrote:
> > On Thu, Jul 24, 2025 at 1:10 PM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Thu, Jul 24, 2025 at 11:24:29AM +0200, Bartosz Golaszewski wrote:
> > > > +extern const void *kmemdup_const(const void *src, size_t len, gfp_t gfp);
> > >
> > > Please drop extern, it's unnecessary.
> >
> > It's all over the header. This should be done as a precursor patch and
> > I know that usually people push back on doing that. I gave up on this.
> > Kernel is going to rot sooner or later... :-(
> 
> In mm we just update as we go, this is probably the best approach to avoid
> unnecessary churn.

I agree on the idea of eliminating it, but also I agree on the consistency over
redundancy. That's why I prefer to see this done at once for all (in the same
header) than doing one-by-one. And this approach got a lot of pushes back, while
the former even more pushed back on the (in)consistency matters.

-- 
With Best Regards,
Andy Shevchenko



