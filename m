Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE15C5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710B06B0092; Wed, 19 Aug 2026 12:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69AB66B0093; Wed, 19 Aug 2026 12:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561ED6B0095; Wed, 19 Aug 2026 12:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32E6C6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:59:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5A91A2DD7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:59:40 +0000 (UTC)
X-FDA: 85118630520.25.2C2EA84
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0E7FC20004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:59:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OG6XR9qt;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787158778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ul8sL4o49VwrfdmFYNMm1nJQlfGW7WlZrpLS1SW87Ns=;
	b=G3ifFpeFhIRNX/JN5SUn5ySjvKwDRSq1T7bqyWVZkeX0SoSz3ikic5pkKc5Ro3oJ9fCKU2
	ZKK0J72QbLsHx7B5wE0GJpLfzennx1h1qpI0C0lXx5juRvjf9Sl/GFMHqi3ckiFWLfxBJL
	FFzbBPT2pwBTl9COvdtroKBBgUYqbs8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OG6XR9qt;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787158778;
	b=lRAsqVCezDtjQjdA7nq5BDkU/En9RzodR9A6C49EH1WCxtKs8V5xl5hSYtDgh8VJZDqLGZ
	5FpPVP5cYX/yj72JnAf1dA4QD8PWs9WDT5QS70HSxsDLLYL8D1UHdSNGbUWOTPOod1FagB
	jypj161uIMoSvQgzfFALhKwCnJA1mgs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787158778; x=1818694778;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IOTVPUO0ZiUEmg41bEMQ7kpDRfBcTt+r8BmdyGIX5b8=;
  b=OG6XR9qt/qLRTwqFDlnl8FO1jmwr20t1TytNEN6aW5asisTE1/pHKCub
   5WvmKwIlRwswzBDD0W1If+ECJaTQXqQq5+kcWCjqJTSZhbR9pbfWZKm1K
   Ye+8iYJokHiG+eCobic7aEhA5LXrGDjiHa1aY7rmrvOTaDmDjpziXn5lR
   gUF7WcAQDBYKQvryHHpcxLt26LBP9VTD1s69R0CHXVEiNvA4Nn177K8dj
   7sJ12pwPQG8nl4F8KPlRp/VX8wIx1rpwNXKgiWovfcmwAMstdo6fHJ8NK
   k1TIztihzYW7S4x1B1I+BYh4wXqkzIqaqedeGvO4XMsJKyN1As/PrzxpR
   w==;
X-CSE-ConnectionGUID: 2z2shECPSMGEo/wz2E6ipw==
X-CSE-MsgGUID: PA6O8/1WQlezoLZ5U7sWvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="98352304"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="98352304"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:59:37 -0700
X-CSE-ConnectionGUID: UL1gamXjRPOcD03otLMATg==
X-CSE-MsgGUID: i6PhILTnTgKZeR+SeSVNgA==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 19 Aug 2026 09:59:33 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wwjdS-00000000fqn-15qv;
	Wed, 19 Aug 2026 16:59:30 +0000
Date: Thu, 20 Aug 2026 00:59:06 +0800
From: kernel test robot <lkp@intel.com>
To: Konstantin Fastov <kfastov@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>
Cc: oe-kbuild-all@lists.linux.dev, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev, stable@vger.kernel.org,
	Konstantin Fastov <kfastov@gmail.com>
Subject: Re: [PATCH] drm/gem-shmem: Install writable PTEs for write faults
Message-ID: <202608200018.9K0vPu3P-lkp@intel.com>
References: <20260804140403.16337-1-kfastov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804140403.16337-1-kfastov@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E7FC20004
X-Stat-Signature: hrzar8gisk3pzjtptsbqeidee6qppj9j
X-Rspam-User: 
X-HE-Tag: 1787158777-606847
X-HE-Meta: U2FsdGVkX1+mZEf33onld/zwATYGdcoLsy5Un65hQzDDpcqNwdvIp8CbCA6xUW/WO75ZOj0BeBNBf0+WBhuWJ+XDdmNLIxIuAIeVkeYi4U7kh7QZM57PEgsgS6No4gHV+gjAkZJL/AM+ZtbrMPJGGr/NdkkDAqWN3LYXGlkcVYsVFGOyF/g2Rh7ob2STjxa8ZzCp5dr+xuu5gQyXIP1APzi44pOt6hY7GDJ4FJiM/vQRy6agmeNpfTFtswNBCdiBCLhxB9zbXGDjORFCmZRA63Eb83qIMlQcmbgFPvl1lvRS4r9yPesM+JN5sPDaKGYoaPUG5Uez2mk+znPbdsUGBrM2Ua/xTqgA80fbvWOa9GcbobxiUtwe3zRlue5OUhGVver9nEpYynEutPWfWLB6t+MmcVgkuOZSX5QPN7Dj9Sdjg0wrUl0wjh2qNCnkvNJCA9Xgyvu1j71K7n90NvCN89MHX1a7Z4wr/7jH8P67O5ASq0XPTNfz33BeWY0641mP3A9U+cGZKqIfNycVot2hhGQVJbLaQMcQKpU3hH9AmPvLo44UYHpV1hy0pw92OKA17Xu5v8+DRAQy91fb9/L8ZWnFCG/RiEfqoBulsVgh0XXlm6PZwsT5+ae+3qRQtN99Kgig0XTx5E2e1xs6l3rU+RjJvLeXiMrWcHRgowiKrPBJakS+4x1zeHPAB5M1Q0jLwjI3byETv63GPLUOQgqcn4VoNpLN45ejUc4FAKjyCFRLW1VW3kc8oiZQZelZ5OrWcH7dctWxabKbd34DkGTvAQyKrWySkvMTxacI/v8eLrpRnZtBP/y0CwI5B24jF56jd6/s0qUELu+Iw4REBeWMJw0QZMKza8/BEypVE7CxKQQ3HwIC+jWRZvJdK/q0Vd7bm2BszR7W4hAGMhVPv/KslMdgw1Fz1yWGPeh9jsz2XNZfcLxluQMJNfRRop6+t7Rck8KlIRSZ+cMQROLGm9K
 2G9fqE2A
 99siJwNXyLngQ6B5/XJEwhnz2aBnOdEfJklgTdUo1AhEyAvCIMACNFm+LmGhlLC+yyezkcD5OVWqKTAOVG0vxuLqCSdez6wiIVSaAXiWKwhkgdbH47Vq0NiRgnwsHU6bDiOCtyB5GOb8jhdFQ6LcCMjBQcm8NLAxa9qh52n/8HeiCELYTmeL1rmWeRhvYu95HvsiV5fGUxEBy0oF0INeR5QLraTAbidVQMwi0JaUeDIvoaqJLhIKmattP+vEd8lwxPz6MDBJ/7//8HgjnQ3SkEYKltXPu+is0rDgISC5HJEBWI+tGcS0QWwnOygsMjKjMlvpWY9E+w0/U41u1F/tRnsuqJg1bTUrXS3mGyeS8IiHsMLTZdZmm071GIFo1G2f4xwok
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Konstantin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on drm-misc/drm-misc-next linus/master v7.2 next-20260818]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Konstantin-Fastov/drm-gem-shmem-Install-writable-PTEs-for-write-faults/20260804-170403
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260804140403.16337-1-kfastov%40gmail.com
patch subject: [PATCH] drm/gem-shmem: Install writable PTEs for write faults
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20260820/202608200018.9K0vPu3P-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260820/202608200018.9K0vPu3P-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608200018.9K0vPu3P-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/memory.c:2887 function parameter 'mkwrite' not described in '__vmf_insert_pfn_prot'
>> Warning: mm/memory.c:2887 expecting prototype for vmf_insert_pfn_prot(). Prototype was for __vmf_insert_pfn_prot() instead

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

