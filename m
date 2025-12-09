Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E66D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 09:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447056B0005; Tue,  9 Dec 2025 04:55:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E906B0007; Tue,  9 Dec 2025 04:55:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B7B6B0008; Tue,  9 Dec 2025 04:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 254606B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:55:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0932134329
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:55:31 +0000 (UTC)
X-FDA: 84199475262.09.FFA57ED
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id E3E6D40015
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:55:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=biUnudgq;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765274129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHnjqa28VSLuL2ZA10MZEvcdyGRXt3fJ8/yesSH4S6E=;
	b=gp8SG05tIt8RYjTHXZT6ndVcAvYC6hw/fSWV4zOsUwdFpkLxQrRsEiDaME12PNSP06PS3l
	otxiYuw4Rnsq1RfxsY/PyXqhTWo4JzAo/1s9AIqXdtFUUmps0cBVU8mGB99yyc/0Evkm5D
	SyZSdMjeG9cViGi/c8Lde1E8EjgEFSI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=biUnudgq;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765274129; a=rsa-sha256;
	cv=none;
	b=gd+7MZ8JiXSbn4cuXIxG2j5PZGxnI5I6s21ty2jYlDp2xqkLVogIUPuF71ZT/DDgJ5/Q13
	ejIAtnU061dgXIq8PB/CWJVa9PsHURdHHkHn0/t3qaSXPF3wyaMtRjSv4UxpZkcqxZ7FMm
	UM1D7tWwS3q8MN5HhdZCp38dl0n/XEI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765274130; x=1796810130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WUs7r+J6bXFpDh7ayirRnSaKdkdL3HYKLS9fGPGyaRc=;
  b=biUnudgq1CUbsZ5ldfjkwFF5iUDxN5ZL3vQHK2kRFOQ2Zw9TTbxqLMJ+
   d2G5lQ+ikflCm+uzGoDKA1BxlMkmyr3wZ4ZWLYWeHbcUd8b0fk9oYsfmP
   +QaGF0nVJimYE4KpYyrfgTEoKConqfk8kH6IBcuwEmUynvvv6zstuO1yR
   a1HmQBBVPNIFBjT0IZ8bAGzm04abG/fAQ4lDogC79FD9ZbTjXcRAgx6Be
   dVDLMD3zDUyijR4Ny95H7+E4wmcTf4lUWR9WMFxtm3QxsAV+yVfumvbzo
   OspGMtyLB+AV4Y+H9TWjizEIiV5FILQ9+LS/MhVNq13+0OGScaPQpwPFr
   g==;
X-CSE-ConnectionGUID: DrCU1U1sQBuEjiGcAhdQrg==
X-CSE-MsgGUID: Av7YTYFhQ42Jo/xp+fsmNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="77549642"
X-IronPort-AV: E=Sophos;i="6.20,261,1758610800"; 
   d="scan'208";a="77549642"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 01:55:28 -0800
X-CSE-ConnectionGUID: BX5nu9W6SOm4T1F9M/xx6g==
X-CSE-MsgGUID: aRr+P5HxRSWqix/GB5gnoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,261,1758610800"; 
   d="scan'208";a="196476646"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 09 Dec 2025 01:55:25 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSuRH-000000001cT-2A1y;
	Tue, 09 Dec 2025 09:55:23 +0000
Date: Tue, 9 Dec 2025 17:54:32 +0800
From: kernel test robot <lkp@intel.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH] resource: add WARN_ON_ONCE for resource_size() and
 document misusage
Message-ID: <202512091733.6IVBDnru-lkp@intel.com>
References: <20251208202921.16819-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208202921.16819-1-ansuelsmth@gmail.com>
X-Stat-Signature: zc7q5a4fybqa1ksy84bge8cx5zjdqcwo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3E6D40015
X-HE-Tag: 1765274128-637388
X-HE-Meta: U2FsdGVkX19Nhz+ZVQO0cRpMSeKlbk28OWRGzllKYGn4bGuP+Co5NMZt8lDxH5J4r0xPgmgOePW/vziz/w9yDOVf6UVNpIYy3FACkOqul+IKsh3PJ6WtFbv2qgIdckXBscuVmF0SuDC7WOFDCSe3zbJ0+KBQGBUJ7v2AI48cqjqrgE+XmZYXvr3riX1FtC+wPKx9Z4D7bKIsC9pBj6rpO3Yv3X7/4hJq8cIT/qWbExOk+7BY6DQLh+hkDWyjYfSIpk0BsOv9wy4z9ykNqsKWay5uPxzRb+lxQZVTRl1hrsD8uDLjqSE7lngNsShxNE0Ut3FZdhl5oTBhhUGxUC9Gtvypf2xY3c7EMhbMBNYR3ATPSMPeMHvCPVMR7dJUJkHk37G7BQjF24bSbGOEgTOgIteB4HPXiI5sUbcruuJmKwHBwUt40XTPswM1N+sDT+FsXtfphBQI2FdoRyKu/+W/48U97eocx9iYCvCZP6DvK2OO1o9L22e9dwdV8Ijl6S3Jex5zAcTWlvaxL8oJSK/iWS8BMygKoJMbs4YPHykZyEVVMa+2opNaloI4X4tKAJhkzq0TnSbos+DqJug9cX9WBHcE6aZRNXg59Ll8NoU10FL2nRmMs55O+U5z2ys4VB7/vjjQG9Iusz68xMtDkwOA1gpwISNISQEUA1KDOUNs6H1PU1iqD+f2ta3wYwXTmHP7uSu3gUT3m8rs/bMjbDWvmws6oT8C5esYiQPtwFnFWxkn5Kt+U9JGl3kS3y0b1nFhIXfNXYtVK84CgWPhZxkFOsp1ssQsQ/uiUCGcj+BH1Xn4B1ttZjWhN75Hg+FlYpC71jqFlbh8yQtaUMxBkGMXxMyEVB1zsde4EyZE6+LUCOQusFBBeozzKPuNZbo5nIWnY3cf/w31GKRji1YCP+2pgKbXKElHQ5Kv+6UzfaudguAeQ3Pppfu861JJp0vgNLkpR9riBne0/Z3BQUpBW/G
 Dhfuw5I0
 Yed7Cx0uhkSiBzkjrfNvsNfyjrzJSkw8Jn5ITk9TsREFr/qWruLgUu+OLwcY7EPkDLLvBXSnxXhphojF42H+YaiUCl/v9uAQL+zB1DcJGoB1PNoL0Jujvg/Z3Vm5moLrmBAiVLqCBeBdAQ0zDu2qXcQtpSpC7S1rZM+15yxA5tMDdHX0ZW3yR3qVAuFkJy7I+lU94nVCnQJxdsaO/3QoLKRIp+gvt/xCKM35/sQ7nNkgogLBmERufd9bptfrRxCxXrgeroTJNpXBFMCjIyD9KK+xZ6L+UnJ8dZvpNn2y5TJBxqPD89eIUcsDROLX8vBhi0GI8iFtshXpiTHc17lEu3ZKdMXLGn4Ag00GXpvYpDqL50HeAA2y3jF0AOqxlpmSZ9nV6vuUJdy49oRpk8TKtSLLs0lLBhqRrXgYJW/yYRbPitXo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christian,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.18 next-20251209]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christian-Marangi/resource-add-WARN_ON_ONCE-for-resource_size-and-document-misusage/20251209-043037
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251208202921.16819-1-ansuelsmth%40gmail.com
patch subject: [PATCH] resource: add WARN_ON_ONCE for resource_size() and document misusage
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20251209/202512091733.6IVBDnru-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512091733.6IVBDnru-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512091733.6IVBDnru-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/resource.c:15:
   include/linux/ioport.h: In function 'resource_size':
>> include/linux/ioport.h:302:9: error: implicit declaration of function 'WARN_ON_ONCE' [-Wimplicit-function-declaration]
     302 |         WARN_ON_ONCE(!res->flags);
         |         ^~~~~~~~~~~~


vim +/WARN_ON_ONCE +302 include/linux/ioport.h

   288	
   289	/**
   290	 * resource_size - Get the size of the resource
   291	 * @res: Resource descriptor
   292	 *
   293	 * This MUST be used ONLY with correctly inizialized resource descriptor.
   294	 * Passing a resource descriptor with zeroed flags will produce a WARN
   295	 * signaling a misusage of this helper and probably a BUG in the user
   296	 * of this helper.
   297	 *
   298	 * Return: Size of the resource calculated from resource end - start + 1.
   299	 */
   300	static inline resource_size_t resource_size(const struct resource *res)
   301	{
 > 302		WARN_ON_ONCE(!res->flags);
   303		return res->end - res->start + 1;
   304	}
   305	static inline unsigned long resource_type(const struct resource *res)
   306	{
   307		return res->flags & IORESOURCE_TYPE_BITS;
   308	}
   309	static inline unsigned long resource_ext_type(const struct resource *res)
   310	{
   311		return res->flags & IORESOURCE_EXT_TYPE_BITS;
   312	}
   313	/* True iff r1 completely contains r2 */
   314	static inline bool resource_contains(const struct resource *r1, const struct resource *r2)
   315	{
   316		if (resource_type(r1) != resource_type(r2))
   317			return false;
   318		if (r1->flags & IORESOURCE_UNSET || r2->flags & IORESOURCE_UNSET)
   319			return false;
   320		return r1->start <= r2->start && r1->end >= r2->end;
   321	}
   322	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

