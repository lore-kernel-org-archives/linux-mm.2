Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F42CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF976B008A; Thu,  9 Jul 2026 06:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36FC86B009D; Thu,  9 Jul 2026 06:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2857C6B009E; Thu,  9 Jul 2026 06:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 050156B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:00:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D541120476
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:00:39 +0000 (UTC)
X-FDA: 84968793798.05.F55F0E0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf04.hostedemail.com (Postfix) with ESMTP id 190414000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:00:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PXSI5eSx;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pmtqCkezIxkfCuNg85sacsHYUMmNK6uZKGGoC3lmd4w=;
	b=K/vTjozeoseTGBQo0RV+z7QXB7JfxxgJ1dEogCR+0Y79eRzNoEWlibKddrEQ3om4ZhNg0w
	M+RJ57zbbmwG2WqiW/bljP9jaCsJGpawu5YLH5HCBDVzn1vyyGfAGG0pnikRrBCr8BBCLB
	7Kka66rzUN/5P0X+ryEwNoGA05DIrSc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PXSI5eSx;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591237;
	b=8gx19hFjgQrfwLekDg0pvFFL0qsGtNAJI3/MZhYbas9Dhm6OprDcBwDxpHoQYgUP/v4e2G
	l1jq9ZgpFdkh4FoTwD9bEWmvek5SadRXEXNXp8Rd8i36ri1W8WL39ZojHrBw1MgmDA/KYW
	uYtR3BARoCN+ZebtLPdbYcf7vO1aHUA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783591237; x=1815127237;
  h=date:from:to:cc:subject:message-id;
  bh=0cJoZC+qaLhu9Bg6i+Ath8h0hHRAV8J8wL90JZ+AZZE=;
  b=PXSI5eSx9sW4FQno5+KNI/j7xyFDgOQtXRB2iuGLmO8FCU93WVRBwJ3Q
   R0/pYFXoiBC7wKjALOni6jwoap2OLqe2YbssWgLlGRZE8YMiycsfm4oC5
   WLreIJWMQZ+cvyQclfpxkXHpKuXEC9Zl008m5swsKUsDfljmbJFBa4BZf
   Ft4h0g0bafkV8Dz6EfW5fpSNGqsRNTcM8mhGRYKnhrT0lWvmIEeLq+IcX
   tt1hUt6j/1A0XL30yLc2rx8m3YFqDZK71PUYrV0wRBNHCIq8XEx8SbwjX
   wxkFtgzrfNDBWiSWAEKYoRK1EMNGhph9oS8iiCNPRX/5L9/jCC+Ujfg3K
   w==;
X-CSE-ConnectionGUID: masLzjOcSEOWuMEDys8JXw==
X-CSE-MsgGUID: ac7twjhITpOEE/IXTeyhDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71787465"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71787465"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:00:36 -0700
X-CSE-ConnectionGUID: OmH+vFaKQ8ehc0En6Au0aQ==
X-CSE-MsgGUID: ZKk3Lb4bQzOcoydwEY77DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258845039"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 09 Jul 2026 03:00:34 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whlYU-00000000HX9-3zxq;
	Thu, 09 Jul 2026 10:00:30 +0000
Date: Thu, 09 Jul 2026 17:59:52 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Subject: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error:
 implicit declaration of function 'compat_ptr'
Message-ID: <202607091820.qbjlGhKK-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: un1ahgsc6kr6888b1f7eoxdw5bjsxubk
X-Rspamd-Queue-Id: 190414000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783591236-601550
X-HE-Meta: U2FsdGVkX19nQTVu3tDgxnXf7bGWZuTJT6tqIdV75s1LhzHFdm0COeT2MaFSdZUF7e2j7S1RDpsk8sGftGmBpddTrpj7Qwc75rw9qurd4ru0VqBv6vx4on53R415ax3kw4te6Itni/Nm+qmmNrNnKSKR199asff5jHWhRckYdeDWTTsCdB4k/WJ7eikDfUQ7GoZiswlkqdU403ruQPZNG+gJUmYzBHrfgrhqWzBhVdh3RabKsQPNl8KIZKnPttfdM3wai2Alko6YvYDYx5vl9CRTBFJQfUG62BF1GDTRyaTE2LyzLKOgtWlZCHLcHMHw6QOOaegJfUpfXJ3p7hsCs7GYNbGfHPEEDQTAZguehYdW5C3jCUsmzSgDMzctUGHA5cpqZcAH5cA20zslam14ki2SJOMeJGiO4+pbGv2eX45N7Uw7XzM8UvwjToc9aakqzwSF208tR2WjMnER8ySuFuXWKAKUfLUG6GUvh7P+kDVyntObLH777L/tHkJe/AKT/718TmrFttIzNUANU2uhiZQ5ptM0+OFYKEAK5ILz1ZppZqjQ3fV8YFOOCx5EksHjYOxPu3BpuMuvv1M6WLlWqQdwTnPWhb3csN+jXOYB6j0KOM5dKih/jqr8cE669cJ3BMY8yVGW7MQnZs2I7L0lytJvjA3uMgVSQmkomeQ+sFbFg9bMU3KlWHjkigU0kmOygHMJcFnwGItiTM8DTi422Q1DzjefbJHUoFYBncDI8IX/dE0kSVIzERxg0WZTVVf4/VVzs+BVfOAt12pKmaqL2yGrQvDAHe1B5xr+UEEOceyKRDcHn4QZbYUAmb+C6Mk7e5StoXHwjRCDguJl1xUL2IW5vb0qx3/i8pK5AODZis/HvMqSl4EPfwjPNdBPEO9vku14rZ6bWB7GopRboOi7ySefhQ0DJpZq/bc9lO6oabM/2Art0PkBDSrMfZkXfw7kBRP02FIqczfMuO5JXBu
 XFPHheku
 iu9PODeKqSYEUstWv7lZAnYrOsbdpZIo3QRzrgRyxBbAfJPUyvHfkPlpHxKw0ThYTF0Znzv7Sps5Zp9sksov08bEiQfj1Ag0UfYzZL2eMUs+UDvCZD3tG+OcBmAQwG9d5eA1CL0eeuh24ZcmHq72QNMmBFoyfK0bjhmElJeGXW+/7s1+XgDo+0yoL2UjhicTmeQfz8lI0apZLACjkIFpPSqddJHdgKT0W5UZVDWiXk559ITJav8ETkSV767Z1v7Ku08iY89OpIcyQLSWS5ZRuTH+Yv5H0/dNEA/adyJCSewDTaMXXBExbGIKKE9Li5367pqbHBGNQ7sudEio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   59e34180e138a293260301c139cf7ee800978533
commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_tag: add ioctl to /proc/allocinfo
config: sparc64-randconfig-001-20260709 (https://download.01.org/0day-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
>> mm/alloc_tag.c:356:58: error: implicit declaration of function 'compat_ptr' [-Wimplicit-function-declaration]
     356 |         return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
         |                                                          ^~~~~~~~~~


vim +/compat_ptr +356 mm/alloc_tag.c

   351	
   352	#ifdef CONFIG_COMPAT
   353	static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
   354					   unsigned long arg)
   355	{
 > 356		return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
   357	}
   358	#endif
   359	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

