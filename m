Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E93A6CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5091A6B008A; Mon, 24 Nov 2025 14:52:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0BE6B008C; Mon, 24 Nov 2025 14:52:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D6D6B00AD; Mon, 24 Nov 2025 14:52:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF936B008A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:52:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E46F8140538
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:52:57 +0000 (UTC)
X-FDA: 84146548794.20.F6AEAA9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id 464971C000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:52:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZG+IzGZy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764013975; a=rsa-sha256;
	cv=none;
	b=xTLD70SLpBqVM1/dTp6efflylMSxHos752BTMap6am6sfZJJrx6QjpUHNrYMfTLHobiv7O
	swSgYyizW4pFrp7O3NLEUflZrV/nEQZh/SqhXCDKeZNWPoGAjDJ7UF5ErJKLaP3HFVBHBl
	ZVuHPpAnHfxAllGJiqMlErO/g81RIaE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZG+IzGZy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764013975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/zRUKBqbMLfD3RV4Lqm6yzkgRjfS0+cyILgsVzGuH4=;
	b=PXYXn5EMbRUG286NC5SzIAYDr0VxX6SM3IErmRSFAWwctGXqAA/1wLfE8OpLwI36QM1Eh9
	LyRX8eRpG3W1bQ24oiq5GF5RJcERdnY5fbYrZHkSMfIGdpCmxXYqaaldQozN/De8/oDTlb
	T5Vt9eK0thJF9pU4y7FBGlKnysNCOeE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764013975; x=1795549975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7yQkTnU6EMUyWJJWpfaiJgWDhOTYKY7pBae4ZQj688c=;
  b=ZG+IzGZyIOZ0mlS9pBIdN/Nozz3jGzZf1W7wS+nwO3WHhCTQq0zlDj8A
   beeUCVPieB4KoQ81IFFIYXTpjrlkE9o46tLFkmoaymdEnP59SKJ8qsKYw
   ET/nYFZ3zL8UkFDoOhRgh2ioGPHtE0IYsycAUam3kJIkZ0ejVHSSv2zgF
   CcGyqHj16ZICWw7MaeGZ7rXh09JwQr4oJ5TvSJFySl/4rW7Trfs3QqDoX
   xPuyjmMft2IiZ1qWuZLpxAGNtNM/6xcxefaVi16rd/5WPoqElZbB4n6jm
   99mq3V/otT1x6jJQGMyFLlexygHKTfDtxWpiRuxsKmwQLECVUKIm9T+/g
   w==;
X-CSE-ConnectionGUID: j2v6ZTOvRDmPSpjcvJpRKQ==
X-CSE-MsgGUID: ZZtPschHTteklDcUGdMMXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="66184081"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="66184081"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:52:54 -0800
X-CSE-ConnectionGUID: xEKXCNjpSEujSYiw47iKaw==
X-CSE-MsgGUID: DLDS3QRdQaSinAkc4J+jSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="223401752"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.244.5])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:52:52 -0800
Date: Mon, 24 Nov 2025 21:52:49 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: "Stamatis, Ilias" <ilstam@amazon.co.uk>
Cc: "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"david@kernel.org" <david@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bhe@redhat.com" <bhe@redhat.com>,
	"huang.ying.caritas@gmail.com" <huang.ying.caritas@gmail.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Message-ID: <aSS3kXfoBppO1a-Q@smile.fi.intel.com>
References: <20251124165349.3377826-1-ilstam@amazon.com>
 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
 <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
 <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 464971C000A
X-Stat-Signature: qhpouk6oomgxib9xzn3dyzxjje4mb5ia
X-HE-Tag: 1764013975-398327
X-HE-Meta: U2FsdGVkX19yNfoYFyA4i6FJW0ufr86fXAA40p6o1XXrtYuKiGynSpMKRKR36hVKO+P99Ua2F8mgEtvOM1JHs/7XLu2DQsZJXxBhefCXXbL7XXcxrGdLQeS0K+s0QiDY1GBUwCwBLnQEF2Zf2pb6Gt/tR9XojkPLgPW813DZmtRbLuJcqbEPjKtHMqJwwb/VjoUnZ/csN0HztQXqhb2z7xb34uLCI1anRI3kEcUPJktQfjqQysCyQRIxX8FPMTmfT5zdw0UR9/uc8El8fRQ5DeMgmda7UHZukPNuYtjJX7oYG+oKRfdxV2OT9PPflVtiq7nEBHVfL820sdJRbH8jnK+lBb4GbBfCD1o8kfQydUU1zVIxQ4PAnJP8g0CUVGG8JGWpGlTJ12sH5l2WnpOWALQe0wVvZxPRDjIlJPUuasCu5FX8NqxgATW3TQsbVVjUrqcsCKhZQNLBvRgjVZuad81vHGkzuDO5uIvciLF0+luvFQWGTpD9oYoTCjXyVNik+7MidT+SBos8F/mgkM0RS4C6pzpdcIdF78hrJKl5l1FUyR+ubi5UYzCkV3VIRiKduEAZm4sXG2g9r2YYIHRWr4RBfui0sM+HQImyySHeS7qIkvdFthcx7zEWxAcOvEO85XQcZXpAY3eMy51XgBQDjvurQPtt51AunZffpTq3ka7qDjMxFIAUtgh65tDUJn2ac1bNKFH7/L4YJ/TXgWXzuRbr6Y0vC3w2uALYp85ArUN68tr6rU11FrUN2JJZLQuez96Laz7KPLgDs0C/oozNtI7j5x7+WNCFJ6z1KcsmKIfOTZI8Ap4xNvHHFgyOF/qTrx+SUx6RrAl4Awy482MKFIMmbT98gF/dySmmSgrGVCAZ1c7PR4WDsV00KBt8PccLK7tKYkIbPQ27yr/0EBQTxF0xG8Ft6AcZnwwLvlNLPl3ovAU3LEwjmISc4eySmw7qaVw0kpQpPGGpWgrhnDO
 +CEMAtOI
 MNziV32XAjx4xmGmOsEwpRwzOEGiYR/mQiIbFjgNmgE4pUUoZ3bSJ/me+1OGpM+ns0pkHXPHUJVr2U3XaXU1P192R6eZrkiozaDJ+53+gtQ31ViWoNByCnTe7mEymKd/wtt+GgRVei5t5GmNzgIMTTHD/D6c/l1pZZr7hGalEqCBrlDVJIk+J7y9ridIhOGJKd0gM22xmk5vdHwajqYqtxO8A+MkdEyaPmHQ2e4hfPryM0dGHkEdtPtMpitzzbD30OfsT5voW0ozOy+nEbPhslrBFgO6cGW8SIKNo2BDvyovWlCgx7l3h1PQHFiwhvam+dBeNZOlg/5vnQT4doAFCdG71JZpUwQ1uCHaq07uSPT1YfV/Y9vGT5W2oSeWvj//EzZdA6BRnkiKTbBWBYEbJOVIBUlIK99dalArmjDMzJS53waAVLvGjXpfUG3d6Y4TIjpdM+NP7mhWm2zs1wT8W+ev90pziESMoYjBfxcRDNP+4JLPzDIpL5+9DIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 07:35:31PM +0000, Stamatis, Ilias wrote:
> On Mon, 2025-11-24 at 20:55 +0200, andriy.shevchenko@linux.intel.com wrote:
> > On Mon, Nov 24, 2025 at 06:01:35PM +0000, Stamatis, Ilias wrote:
> > > On Mon, 2025-11-24 at 08:58 -0800, Andrew Morton wrote:
> > > > On Mon, 24 Nov 2025 16:53:49 +0000 Ilias Stamatis <ilstam@amazon.com> wrote:
> > > > 
> > > > > Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
> > > > > logic") removed an optimization introduced by commit 756398750e11
> > > > > ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
> > > > > was not called out in the message of the first commit explicitly so it's
> > > > > not entirely clear whether removing the optimization happened
> > > > > inadvertently or not.
> > > > > 
> > > > > As the original commit message of the optimization explains there is no
> > > > > point considering the children of a subtree in find_next_iomem_res() if
> > > > > the top level range does not match. Reinstating the optimization results
> > > > > in significant performance improvements in systems with very large iomem
> > > > > maps when mmaping /dev/mem.
> > > > 
> > > > It would be great if we could quantify "significant performance
> > > > improvements"?
> > > 
> > > Hi Andrew and Andy,
> > > 
> > > You are right to call that out and apologies for leaving it vague.
> > > 
> > > I've done my testing with older kernel versions in systems where `wc -l
> > > /proc/iomem` can return ~5k. In that environment I see mmaping parts of
> > > /dev/mem taking 700-1500μs without the optimisation and 10-50μs with the
> > > optimisation.
> > > 
> > > The real-world use case we care about is hypervisor live update where having to
> > > do lots of these mmaps() serially can significantly affect the guest downtime
> > > if the cost is 20-30x.
> > 
> > Thanks for providing this information.
> > 
> > > > It also would be good to know which exact function(s) is a bottleneck.
> > > 
> > > Perf tracing shows that ~95% of CPU time is spent in find_next_iomem_res(),
> > 
> > Have you investigated possibility to return that check directly into
> > the culprit?
> 
> I'm sorry, I don't understand this. Could you please clarify what you mean?
> What do you consider to be the culprit and which check do you refer to?

The mentioned patch removed the check for siblings from next_resource().
The function that your test case complains about is find_next_iomem_res().
Hence, have you tried to reinstantiate the (removed) check from next_resource()
in find_next_iomem_res() and see if it helps?

-- 
With Best Regards,
Andy Shevchenko



