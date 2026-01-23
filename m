Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1711D72348
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71CE6B042F; Fri, 23 Jan 2026 03:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E201B6B0430; Fri, 23 Jan 2026 03:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22976B0431; Fri, 23 Jan 2026 03:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE4806B042F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:11:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CA59D2ACD
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:11:31 +0000 (UTC)
X-FDA: 84362509182.28.7E6F4AD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9705C20009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:11:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lKdCzPR4;
	spf=pass (imf03.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769155889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcPDFOMcvQsT+yf9kgC0JaiupoYWsPrVDZMltMO89yE=;
	b=tZ6Vu5wHN6OGb5sLGi7DP6KfPt2zk3h0uGqToXYgYdx8LY/kJzIKW6Rrx3bsJp7rbarhF+
	2z0cnl1sbTdhK29asRScw9Dw501ByLjI4n5RdpFmcxfVgQolq0UNPkmeXnT44VeuiRJAWv
	AK3IysuI++OGf5VGutMxlk2DexN6P7E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lKdCzPR4;
	spf=pass (imf03.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769155889; a=rsa-sha256;
	cv=none;
	b=OEyEy3i1IjKDDhvzDOhOPpjRsvURFSZ13IvblzOtX1Wu9IL7aPnVSJdH9CUQbOMiGzFO5j
	r3FiqSj/guncSYc5I9u5xW76btzcLYgMKNNg9pO9Pxul5Rdp4NUeSEUwX5w/fyPxCoD4jc
	8RW2Skpi01o/iOGLHHaX4HBovH8tfEc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769155889; x=1800691889;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QtOiRkTP425/4cQrafxcluo4JRBRv0NYekdLhguDDwg=;
  b=lKdCzPR48p/X8C+SYZnxQsJE8RqxZwpoptSyIdwQAi8vIm2QwpZ6HueM
   znQX21WIdpu3ywhwSKB1wK+rlUQV0oCIhBt7DZtKJJAdbYfdUn0/4GXwN
   iRwuGjS9PhOEwlMb0HdkjyZDA0k/0pYUV5pOo+0WeLYFafTuAzKdc7vzz
   qhzdnNvi/0s4w5f9+ruOJLjwQQyeRz5MxDQJk9NOR0M4Dxndn3j+6i3LC
   gzUdT3nBkXbxrXDZD2tH2Hge/iFb+zo/wUo7/wnNyvX3V3rYyxvT1zbU5
   1KIJ5SMmYLxfZcuCygk7/y/ZgLue4MrGPZjbSKMKO8fygvMrvqX3kK1AM
   Q==;
X-CSE-ConnectionGUID: 9e3+j2WnR7yS9dgwnQAvKA==
X-CSE-MsgGUID: 9Go4v5MnSHmGiF47KZxrhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="81036913"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="81036913"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 00:11:27 -0800
X-CSE-ConnectionGUID: D/r5puBYQOWiTSqaAXqqnw==
X-CSE-MsgGUID: 5+oXIWBBQqCxe61TIqyuEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="206786060"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.112])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 00:11:21 -0800
Date: Fri, 23 Jan 2026 10:11:19 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vincent Mailhol <mailhol@kernel.org>
Cc: Philip Li <philip.li@intel.com>, Chris Li <sparse@chrisli.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
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
Message-ID: <aXMtJ_JurQjvN4tU@smile.fi.intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
 <202601221237.soiAkwkN-lkp@intel.com>
 <20260122103337.26473d1c@pumpkin>
 <aXIzpC6wpdv47cSH@smile.fi.intel.com>
 <aXLOELiIG8MHKcIO@rli9-mobl>
 <b49c9993-7676-4d33-a2d6-9f6b77b0fd34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b49c9993-7676-4d33-a2d6-9f6b77b0fd34@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9705C20009
X-Stat-Signature: j1s3mkgr68fxzgo71qh8tiktrjeuptwq
X-Rspam-User: 
X-HE-Tag: 1769155888-826889
X-HE-Meta: U2FsdGVkX19u3d52P4WsyDgetwmwdWJGatcf1NBMjMQKISqrD2uCYD1GeAlv81ubBpEY6xErUgS2bZxP4FbiBFdpJcwHbroIWwDLVdR1TjueMtVf0f7/Ur3g5j+Q86naRFm1hJFF+3oay/JVkD1+FxrWqrg0nSSVKitCvJNq402eeLjDIsLkt342IdyD/GTzOxwjYkCSK48JHQD8KMFtMQF/FSelTnnFItMDsVA6D0VjMqEahmS0G1IwIdr2SZQhsMjlNil0QZS24td6tAoy3OYZmE1A0PWt67yK6xhuDGaTxpKdf8HXggEswba14vz4x0sC7pWLfD/tiuKFDqtiOTdHHNvDsKISt7ELF04Su7uNPNrMo4GLyOWjyzkmyPbzC+36ze/flJXtf7K1W9OuRwiV/m/3E9qlf2a1d2N3DRXVxh/E71peCMsqD6KEpJ2vWKHI6PEZPdwlPIngMH4PA8HjfDBgj+T1O+vQQ24OzfGjEWhkjBmnZouOCwIA0qBc34I6oSfZ6eAlSD6z+mwU+8qQ0nbV084hqz72COkYOtjClcXVWnPHfz5KZGEoIJIqANMcLhEniY8VkpuK6INzD9NCQ/ICYe4JOc1wevF2J0K6OOuB0/4ew/E0RXUnjcpuyo3jD68iObTt8fbuisWs8xEzU0rpryhqZhjdw65sfnyEXxlml5ZapkpfGpj99K24VBdgZVY3BdbuWWVq5UkDI+6sWnlzHUl9U7gnyIliiSfv23OEjfSD6x0rc2iDch4G5ssu/twwX1brrBOFvZ0Dtl+cJ7/WTw3U+oiXU1is2GcwGxLVA/hMMX/N8XxRBcVeIK+lZL00UNvAb2WKNiYmfaqyE5fQVVrUoe9A1NYPVbzb2y7nixDcXJBN0Vt2ToNfIAVQCzvd0Mr8314vODNBGgGYGJp42273rkK/zSmmUezF57kPRCN5+r3HEfmswZWPoKKNOZE12MFJCkgAQ0X
 PJ5KCJod
 78Jfjrxv5Oal/ABphb94YzZtcGHjl+xvkMLoxHQyDoK4f8YuNXJbodwKnQW+FMoqa917qBlpBxxwV6/YiiHFN0ROFU25aHo0O+d90PCE5QLvcw/v7PermsNWUJcD+FnFMZziCcUuySN5U9nbRsittbU/wu5aW+e0cWlglui59pa0Wj41jIAgNr79DtA2G7zp6mAp5/GwogkF18n/6BtJ0lVraiAwtb+iR1t7lzKn/Fza+LqHYlQPYkp6tFBHzsyhpVoRzAtm1WuaUHUW2q9KydURvPR1s5VvkPNEqS9zJAnpQzBODyuhK61BD7V2sjHQiej3eZXlMgdYAjVk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 09:01:04AM +0100, Vincent Mailhol wrote:
> Adding the relevant parties to the discussion:
> 
> +To: Al Viro
> +To: Chris Li
> 
> On 23/01/2026 at 02:25, Philip Li wrote:
> > On Thu, Jan 22, 2026 at 04:26:44PM +0200, Andy Shevchenko wrote:
> >> On Thu, Jan 22, 2026 at 10:33:37AM +0000, David Laight wrote:
> >>> On Thu, 22 Jan 2026 12:41:22 +0800
> >>> kernel test robot <lkp@intel.com> wrote:
> >>
> >>>> sparse warnings: (new ones prefixed by >>)
> >>>>    kernel/kthread.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
> >>>>>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.  
> >>>
> >>> Can we stop sparse complaining about sizeof(VLA) ?
> >>
> >> First of all, the LKP should install the fork of sparse by Al Viro. That will
> >> fix tons of warnings that are related to modules and speed up the process
> >> itself.
> > 
> > Thanks Andy, i will switch to the repo from Al Viro for sparse.
> 
> Al Viro's fork just adds 8 commit on top of the upstream sparse repo.
> Wouldn't it be possible to just merge those?

Ideally yes, but you also should kick the distro's asses to update it, and
the sparse should bump its version...

> That would be much less confusing.

Seems Al become a sparse maintainer de facto :-)

-- 
With Best Regards,
Andy Shevchenko



