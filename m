Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B1A7D3EE6C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 14:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD226B0200; Thu, 22 Jan 2026 09:26:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87346B0202; Thu, 22 Jan 2026 09:26:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB72C6B0203; Thu, 22 Jan 2026 09:26:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C98826B0200
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:26:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D66FC1A45
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:26:54 +0000 (UTC)
X-FDA: 84359826348.15.704020F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0EBA9A0009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:26:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k4NopIZh;
	spf=pass (imf15.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769092012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJIJrSPmtOKVzHx8MfTP8bybqf9aM6s3hAgCK5YneI8=;
	b=rnGqHX7B3hjT5f7+4zdNxKGZwSU3AQo8SPe/itN+x+xd642szcopn6SIIAcGBcnrWXwIP0
	2pjsiW2GuwpOKKWZXDLyBV4NnOTU/td43qdngHGknmXXp7dpzhirHfwemxo4PnZJVweSVB
	AFrOzQtSLEJKCU2GDEcaMnJoLbF4sd4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k4NopIZh;
	spf=pass (imf15.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769092012; a=rsa-sha256;
	cv=none;
	b=kSuGquwJPjERi2IJUkTuv2nt+8h4IhDmVyhKUzZiJneFdxHLj7lsVM3OBcVlI2wxXshaIH
	WbauQaQXyzsQKwPux3e9pvS/NnhXTetIgqAZWJqPysXJFmSPfi0TpD5vRw5xiuG/8ZHlVN
	Z8a0Q0+qV50A65w8/Dvr8ZTjijCnfgM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769092012; x=1800628012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QB5NUK4YOqUArNa5QXuw5NpYDg4DBBZDL0+JySd5Y7w=;
  b=k4NopIZhmZgevbLcisYehW1C6UuzYTsc7aK/oxpapv3YJgN2hpZ19ThH
   cUVqrlPAWFOSQcRYPKfsQzbQW6O81IZ10MNdUYYM/X7NdxQpmtrpKNY3v
   01OILsXn8X1VNeCKgFEODa6o9GG4eWwX4D44jmi+9mywq8SMwc/gkDzLr
   aovWihsX26Bb8GWmbipgJCi4HioW/I8A/pF8Db/uzuw1gZ1Ng1cUBD9+3
   5n3GPirdLmPzKP25H0QzEFfFVxI68SPTPkO7GI4g8C2DXzYBEm6PMo3G7
   ct1iCFvUTwZws5ITQQj9JZlWeaT+FBxaYSRsd4mY7al01OLVSt+0axMow
   w==;
X-CSE-ConnectionGUID: ca8Ajj4bSa+/crNu7bEwlQ==
X-CSE-MsgGUID: iau5/IEFTQmlusFfQR5z+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="81705811"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="81705811"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 06:26:50 -0800
X-CSE-ConnectionGUID: urOX2XhJQJG4sCfejh0tog==
X-CSE-MsgGUID: dSn0a2/0SCi8GKyD8LZLQA==
X-ExtLoop1: 1
Received: from smoticic-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.225])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 06:26:46 -0800
Date: Thu, 22 Jan 2026 16:26:44 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <aXIzpC6wpdv47cSH@smile.fi.intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
 <202601221237.soiAkwkN-lkp@intel.com>
 <20260122103337.26473d1c@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122103337.26473d1c@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0EBA9A0009
X-Stat-Signature: am6otm86zs75qqtmekdw9tyyjrpjs8pn
X-Rspam-User: 
X-HE-Tag: 1769092011-290689
X-HE-Meta: U2FsdGVkX193JD2HbKTXNDpnh7XL8xY/y/128myM7z7W5aqqoWM4/qrv/bVLOOWmZ5Fuw/hIWl02TwMkBi2JAjAv7yztkMUC605fkhLO6w8in29tLiLSb9Wwt8GVpMGVx3U2cunbvivs+Ao1WXnlo9q33tX1jV2ikvaLcnbwd46NyAJjns0NT+MqfEN+8nfq9cQnEMj1hKBfYMkZ6inzmpeg4R7Te/DW/x4CgkoGWMi6qnkP3/nwIGN1yrPKI69C+NkWPo4q0gnMao1zlGSeYiCuTQKJJJTBXfkcg5rIcbjpp78Ry2jpaCRmTAikPquYiFujLWYpU/7Mwd2emf/NlzEbXAwGfoJdf66YbJp7J8GRHiPWt9W6ppPkXYeVzgE2trg43eZ2B73DRxzp+oTVBy9gjt+lCvXUSt4TDZFUZgDClBnuMOD396FdAObxyqKOqJpGm+BPO/MhReD2QGpQ7XWufLNUfQJGpR/WTDpVYY4+C8kElsxkO9eqZif/V3PpzTCkciic8+75jPkGLS7gfnjq/ioO16GmygXJ2MFCvf8csZx2oxLtvTyNYV1qfnzAxGvD1gClmohi7AeupFdha8UF3QYj+79LYlWwqOv+DEt65pBRcutCxaGkWltK/wRFbKUpFj4KE42qVRF5aylahmJXNIr0AD6W+nYPmLHvwn7N5nWRX5fX7MYhtq9L6Nh7ie/svxppn5QsX5unWWm+2Nw0Jsl4CuZOEbGy4psQvzNn/5aUZT9jmHtzHRtgT8vL//dmc2hrc/oyqAWkXPAH5yQVQR/6ioXtqIc4/t8jB5qa+2PyfK5jIHfKwihNqJVqFIA2VDvZN1jzOEH7K92VKNbnPXGodLNvOuqMnnnbXSi025JUE1Wne/CL+U+zEJAWJWXI3kyFa8/Ejw75D8gMGTu2qYXWQ2h+xR+uv2kU6elhkQkcee2hmDfINQGQgYeLvwqZRQzJWFGoPMxe3EV
 gKQDFhRh
 KcieGYJIMntlRSyh0C6N1Xk+IK+xDe9KW8NMt3skPCPPlY9d3ac1LtNjHTSnnHUNY/RWw3k6ZNMf+O/dcGgLJIPtq0YZVHFciyGGym5hpaFxznMJ0z0wEg52fIQSNsJcQGnUu3ddtDKxOImxHVgwaV0cQ+8OS1LJ1r0VMRkPelJeOSjsEBOHbXt0afR25mMFe9SqGGllZ6fgOwtExTW+eEIphEHfVdmV64Iaeh6oic7SNoaq4xiU715IFjmZ2evmLPmINsY8BfCSlKI3pGGRqBRjhG7STwFVawrNdbKJQx8alC2BhWnBoGDjLdcxgfl9eMKvcwh1B5SzwziQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:33:37AM +0000, David Laight wrote:
> On Thu, 22 Jan 2026 12:41:22 +0800
> kernel test robot <lkp@intel.com> wrote:

> > sparse warnings: (new ones prefixed by >>)
> >    kernel/kthread.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
> > >> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.  
> 
> Can we stop sparse complaining about sizeof(VLA) ?

First of all, the LKP should install the fork of sparse by Al Viro. That will
fix tons of warnings that are related to modules and speed up the process
itself.

-- 
With Best Regards,
Andy Shevchenko



