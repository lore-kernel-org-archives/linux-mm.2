Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6704AD72347
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEDF96B0449; Fri, 23 Jan 2026 03:24:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4FB6B044A; Fri, 23 Jan 2026 03:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC43E6B044D; Fri, 23 Jan 2026 03:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6F26B0449
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:24:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FD55139E18
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:24:11 +0000 (UTC)
X-FDA: 84362541102.07.A5BC125
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id 24C5340004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:24:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SiSXU6rK;
	spf=pass (imf17.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztj69k1nbusOojUJk8jDi2ddF1sRi1wMajjOdkSgexM=;
	b=ookaHe9QRGeV8XZ93XnYq0AWZarcXhP0Hra6CTVIqnSrwnLihn9tlVFgpvUpJQ4t9gfthD
	PqyIfBuoy4s5Eux7/vML2oaeP+1I4EZ6jsLe/SlSRod98UxhvgGn7z6l6LigGYYOSkArwv
	VM2FZo67ORwcI1BARs6qyJIBVYV0kOw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SiSXU6rK;
	spf=pass (imf17.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156649; a=rsa-sha256;
	cv=none;
	b=Ptk8XPfCql3EfxYM4r+/BQEhXg5Wgk3cvBT46hMadxM3r4CGsNGG+JE+jkAphJ/sACDIsw
	1nCq6wok+8Hr6UU2crwhO09XT0MFARV4sCiOf3F+rqPXH+f0xhRtfUoNov+o2W4ocvAzL/
	xjqfvz/l+3413AMHQD+TVaVv0wtSwf8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769156649; x=1800692649;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dwMlkmjcBaCYcjWa46P1uHRBsYlOiR+4SOQZ1svV6MQ=;
  b=SiSXU6rKYgeB2iMsvI8mT9Lrq0AJ6myyWIigjBxYKVLYo+nLKJjkx5/s
   g0eEW4Djs8R7O3atQhZuNsEPuhuqbyGkbwOXYBJAZTVao9FL7CQB2Tmj4
   3s+vDpDIkSIGU0IxVNjK5xeAczbRvQuEkOuVBBtHFZBrUnrPWwn0wQEV0
   2iGMAvBEd+h1aCbUV+DspxQRy1GdZCRrLjlKU+ynqHuz6As40hSGJv0Ws
   xpH6TQ6of1aCSqdwHqCx/iRBXyV8H5i+710o7uO5qCCG2e+WCyqh8qxFE
   3P/D2bjHRRXYrVswEfx0w7l+8/Xr/j/pdJQqYk5BiHYRvZsCOEiPvp3zq
   g==;
X-CSE-ConnectionGUID: nIVb3f1IQiC+vhPow1hrUw==
X-CSE-MsgGUID: XzSi1A1BS+yVrb9G930YQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70318214"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70318214"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 00:24:07 -0800
X-CSE-ConnectionGUID: lkoPECn7TsODORNe+iM/Hw==
X-CSE-MsgGUID: Z3qn46K0TxqDntbM2syu4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="206874169"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.112])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 00:24:03 -0800
Date: Fri, 23 Jan 2026 10:24:01 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Vincent Mailhol <mailhol@kernel.org>, Philip Li <philip.li@intel.com>,
	Chris Li <sparse@chrisli.org>,
	David Laight <david.laight.linux@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <aXMwIcH7Zh-1yNq3@smile.fi.intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
 <202601221237.soiAkwkN-lkp@intel.com>
 <20260122103337.26473d1c@pumpkin>
 <aXIzpC6wpdv47cSH@smile.fi.intel.com>
 <aXLOELiIG8MHKcIO@rli9-mobl>
 <b49c9993-7676-4d33-a2d6-9f6b77b0fd34@kernel.org>
 <aXMtJ_JurQjvN4tU@smile.fi.intel.com>
 <20260123082027.GJ3183987@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123082027.GJ3183987@ZenIV>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam11
X-Stat-Signature: gxh893nos7oykwi9ot8b75b7nqwdkjtz
X-Rspam-User: 
X-Rspamd-Queue-Id: 24C5340004
X-HE-Tag: 1769156648-257329
X-HE-Meta: U2FsdGVkX1+SqwA/FwbtE+PvOqyZm1iapXIWdcaDgZQr8nNIVbfsmXDDnSgmpJiMhjtJKlQAwQKSGT+c3ZzMwJZhek6IdtHcOEDmCg3vujmDhoMH9TiHVxdcXziaxltLB18Wcg0BIPgKPh3sB5W5lEcPd0mGw9aMSCvDmSaf06FZtHmjqVOnmVMBhBEStImHpOobfa/iRgx3ojgknENPkn23YzmgioELFdsDIrIji1Qt1tAI2WZtiVX8DdmBkrkpqL1nzY/ElJKUy2PmqCzdALER1oulbh+hZQfObAUCB/y71499pqKJYjyrwiH1hlnqqZ0V9/och1VNuXqrqjHeD38kjY4rbWlYTAasvG3LU8tHEGDVS4mioACxXeOxcgjlssEFUs8akc19IABiRl2NYuyWhASh7jUug7rBi8mPG6ycLKzNvt03XpbEVVQvCoAap4HpPtbJue4/nCeYCa2pFpNUGgoPiM4qIz2da4mEq1PZfK+D8dSiHCJGeJ3SWnZY8nGA0O3Y/5ZnBpQy/HXeW79PqJfNfdSGqCi/MLcn5fQ2wxMnUSTtGIBWSsN93e/Z66OTbEVD+7mDTjsTglUOQsgRB8P9coFPbd3BJHt/7+8Dii/QLFu1KmBGy/Fxff9jKJT6sKKZpdqS6XN1PkMf0emPrjTkHTYAkXubQSR99DUEIxJZPjvKZCGXPHsXDL/GHEJw5k5Le3SzRCyFCWhSl+4pq64j1XNeWwm7rMTaQa0a9yQ2j8F8H7MScE9FUhq3ClGmzV4KM7mcDjzZipdOj0xS3T3X9rqVP09rBV0KFKlajTbfhDdjWUC0rrKVMJmAMzOMS9U1uFpyc8mI9SbmP2UFO5OmNIRZQqtMQhAx4Vjg74sBCeZStQgvP5CTqyi9WUAEOcH0UsxH+OwklgekLMzHSc5ihj7xhnjCT/hdTNVgT8+G6bXQIZ2cRH1iozoa/7OFagXjMVPnDlvYJJB
 5SqhXb9t
 vzYbVmnU1vGGiJK3m7Md+mT4wZITN+i7icPJomCdVOVOCqwaf/6x+bpPjoq7mdxJzRf1gMiLWgeiv6OCgzeale+k1H0fg8FlGvg/YIOAyL8HQ0TFt7Aw7WRpoh/oeId2HchP4Kurl4a6NID97iDFikSi32JLqoVkuzzmbi5Q5AP42YkwRyZZmqBDn6CeHNHEbKOvwToach7Cx9N078iMDqCRyZv77Kf++FYW4HkzD5/cgM+hAQakBYXrZW+CyNYkSqrl0ZAEc1P0MtMdVy/bp6EwkhlqB8JBEWfP7jht2iuL+flKKMqMPI0AWtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 08:20:27AM +0000, Al Viro wrote:
> On Fri, Jan 23, 2026 at 10:11:19AM +0200, Andy Shevchenko wrote:
> 
> > > Al Viro's fork just adds 8 commit on top of the upstream sparse repo.
> > > Wouldn't it be possible to just merge those?
> > 
> > Ideally yes, but you also should kick the distro's asses to update it, and
> > the sparse should bump its version...
> > 
> > > That would be much less confusing.
> > 
> > Seems Al become a sparse maintainer de facto :-)
> 
> Huh?  What happened to Chris?

I don't know, but upstream sparse haven't applied any solution for
MODULE*("FOO") stuff, nor reaction on my ping in that discussion
(I did it like week or so ago).

> FWIW, I do have some followups to that series
> sitting locally; need to get that finished (mostly for proper __VA_OPT__
> handling; that got stalled on the lovely corner cases where the interplay
> with side effects of macro expansion is really nasty - gcc and clang do
> not agree and gcc is arguably buggy) and posted.

Thanks for doing all this!

> I've done quite a bit of sparse work over the years, but I would rather
> prefer somebody else as overall maintainer, TYVM...


-- 
With Best Regards,
Andy Shevchenko



