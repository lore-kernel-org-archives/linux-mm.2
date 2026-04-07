Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF63FB5191
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 04:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A236B008C; Tue,  7 Apr 2026 00:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB1B6B0092; Tue,  7 Apr 2026 00:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA2E6B0093; Tue,  7 Apr 2026 00:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 895EC6B008C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:00:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E79E1B85A3
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:00:47 +0000 (UTC)
X-FDA: 84630408534.26.36EEB76
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B5AD12000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:00:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=itU8Xorb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775534445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ii1Ea1UkZAmfOAWtXKmsQJdWOCx9znCqyuDUx0gRxRQ=;
	b=XuCX/j6YTEXcoj/KhnGC4R+9Mdft5PmlQ0ocv8mh2tKDrgOjmLgVm7LDdEz/iJdWfvNZB3
	Kl2vRqCYnb0pPbMZCVOb+ajuh5TbUJDQmxF0xcdDlKDKtd4Y9OnUOgClUCueYsAL5Mun0i
	A3TgHTlJi2xnVz4+SyJn1mciXdD3Srk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775534445; a=rsa-sha256;
	cv=none;
	b=EO3lZOumqAFZ5j7eWq1H7+Skxwnuv4IfDN9NAg+vALVeVbzLcOKx0BWaxtSamVJ1TXx03g
	ut6Hov3YqMFv0nLsF/id6b5qAcUcSZiqpBdUdvhnecLn0nd7HpOm+77bXCwHJAXAy27Bmt
	Arg0RVkbIH6I+dfPEzPG/Kzhc0tgdXs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=itU8Xorb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775534445; x=1807070445;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1er2E8TY9Tpy2Qwo99UK/oBDNc6k2nZpUyVSIYodlfQ=;
  b=itU8XorbtQ6fA4iQmwlcRYfMJTVw5q2NepnLS/nnKs1mxvLKvVTNmHRp
   XwKJ8uqpJEMwakb5bYAQMCgmyyHEb5YgbqnK0v+bKZ+X7wpcQcSemSEaI
   4OzI9hYDIb5hhOPHj2LICh+UkQ5wpnp7zPbjkLa8rxGK/z2gSAc71h1ZX
   LdUFuHX2SpokfdrtyXWMHfqQ2Z6mVHljzsJ+QnSsXqh9PiSJH3htQlNWX
   iTVW6pIpEELSHHPn7HrKMWHEeiuTvwTLT8dpdKrfmfOOzD5Y3OsQoJWyG
   y2ggrsJF6mMhZnWdzlGTXoDHKMpkWepFpnlg19Hj7JQc/WXGWTgzuvV+G
   A==;
X-CSE-ConnectionGUID: LcILIVVYRMuVYV/JOjU7xA==
X-CSE-MsgGUID: E+zajpTYSQ63lz2BxYo0+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="86782289"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="86782289"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 21:00:41 -0700
X-CSE-ConnectionGUID: 8S/r5/AsRyunzJ6lfbUhWQ==
X-CSE-MsgGUID: Js3bgglnQXerX3pfS9bH3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="224844899"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 Apr 2026 21:00:37 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w9xc9-0000000007J-1v7Z;
	Tue, 07 Apr 2026 04:00:33 +0000
Date: Tue, 7 Apr 2026 12:00:24 +0800
From: kernel test robot <lkp@intel.com>
To: Yunseong Kim <ysk@kzalloc.com>, Kees Cook <kees@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, max.byungchul.park@gmail.com,
	"kernel_team@skhynix.com" <kernel_team@skhynix.com>,
	kernel-team@lge.com, Yunseong Kim <ysk@kzalloc.com>,
	Byungchul Park <byungchul@sk.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [PATCH] lkdtm: Add folio_lock deadlock scenarios
Message-ID: <202604051847.ywz0arFk-lkp@intel.com>
References: <20260402143947.162844-1-ysk@kzalloc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402143947.162844-1-ysk@kzalloc.com>
X-Rspamd-Queue-Id: 0B5AD12000E
X-Stat-Signature: 45hpbtm6krh4bamsyzmpp79fm7rm5uxk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775534444-414449
X-HE-Meta: U2FsdGVkX1/2Ky0pqcOpsFiwB4NmboCLRcxEtZEoXEqeT8RiY7bqvijANrt1SbTT86/lI7xRKUAMMlMgtNtAA+Hm0a0AnGP3vggIRfJ0uDdcwEPfYcVHh1AO1wqKPT8PRfsiFmASLecgbQ8iVZ/wyvuRQ1IKdknTt5PSfeUHIutW5pK/iINjGBmnkc2ASaqdaDbq2QbJkG0Ua4r3j+/djeDlXhZK31yh/YOKwcKXPGFAq2O1iZ0xJ4uJ9S4WBG8cQlhLEemUTvFXMNfCDuiyDjGNkbdKBs0n4t1a4wWf9a1xghIYryjO2jYxvPjLUroO+xi8tPFlvcVrlHX4fMNUWYu9oxHY3e1eYz/VYRvd9O/Tloj807VjuQmhsBlV89YyPSTBXRlxBGrpGYVkj+Un+fBnvmkcDcozmjuXOafaLfUh+zg9k8z36lY0RG8cVWNtcqAsMYH/gDBKzIgjWVf8tAIYp/xoh3oJ2VhsGWQvey+fCURCbh/obuSX5wv6xblpif79pEvhfX2F3d+Z3GIog/duKGpHJPHLOfjKZ2/d5/mQ2ryNW6Ll48G5Fij1kX1AQyHWxABDVlw34J1gDu3AJ66l1wkxvkTjSHvBQ/7boGozLYga9beC061LNqLvrl+DrYIphbQjg8WLJCM51HzVzQthaJFdWBkyVwIRB7babLGlwR+Ci9hkdm/dLU7OTuXRw3fEkqASjvldHzXDjz3QdoqA+JfU8rFrKTo04780VOTBN2OuWfctYMiJZoDeHNRy0RUqTDY7EIOL0dke76jAUu5LAYGuDv/x+3Ghb5yecS0fs8xUWdgNHek0kpoXrtyo+3IEYDQmndtG+XAU20IBezy7h0tWGSevfwBeJC8rvswR0PiiAPTFknAQpKBeXwxXgMJApM7jWU4iDALPPGI36IukjJgNUS9aVN7rXB1w0kdENmTMwJq6XkEybGuwasDEYvbRV45awuHCOCRomKn
 6L+go6m4
 tgPejrIJCaIUMsXonKKrOUMyXVT9ufXQ/DB3dj80G5SkKk2iP8/1FqZL6iVzL8Sy41Ld7xN2vFJ6QEWl+WArq54qKpxJqOvix1lpbPAAWSlLyslcEyK0yHCKmtBkD50Swlk5f8EWav1A2WmcHU0OIYUj30rS9QrU4SXoRThcFqAm0OmLHi1H0scbOIPNPZDoah6jWzctad4OimI1aEWqXXp5rNTvV57YwrQVFAM1JT5hEE3seUmkOF6ERQksKno6bxf8ndgLNaEO2EAVjbyjpVDx2ML29BvdJ4T2OIFWEVzAeZKcx+awEuiBsBQLhC1UpQ0ZpXGtvQUgtleUHvIc5TYIqCwAuX8ppMerEokKk85fXfJqjKEb8Ape1mUBeihemlgAjlRo9Xb8vj0AdsqCWNdhlEYEMZocNFDc6BiMWD6kSJa2GcKLFBoTh42XEQzs3YORr1rd6XckhahsKdbuEkqPNbnpjDO6SGg7YNq7W6v61bBplW5kOG6lM1OGYnSUEhQnv3ohSbMyOi0jqpuQL9LsmfymguompzhxaLoIb2WuOAnfi6uDth6z9lnoL05ul6ttY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yunseong,

kernel test robot noticed the following build errors:

[auto build test ERROR on char-misc/char-misc-testing]
[also build test ERROR on char-misc/char-misc-next char-misc/char-misc-linus kees/for-next/pstore kees/for-next/kspp shuah-kselftest/next shuah-kselftest/fixes soc/for-next linus/master v7.0-rc6 next-20260403]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunseong-Kim/lkdtm-Add-folio_lock-deadlock-scenarios/20260405-145013
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20260402143947.162844-1-ysk%40kzalloc.com
patch subject: [PATCH] lkdtm: Add folio_lock deadlock scenarios
config: riscv-randconfig-002-20260405 (https://download.01.org/0day-ci/archive/20260405/202604051847.ywz0arFk-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260405/202604051847.ywz0arFk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604051847.ywz0arFk-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/misc/lkdtm/deadlock.c: In function 'lkdtm_folio_mutex_kthread':
>> drivers/misc/lkdtm/deadlock.c:99:38: error: parameter name omitted
      99 | static int lkdtm_folio_mutex_kthread(void *)
         |                                      ^~~~~~
   drivers/misc/lkdtm/deadlock.c: In function 'lkdtm_mutex_folio_kthread':
   drivers/misc/lkdtm/deadlock.c:112:38: error: parameter name omitted
     112 | static int lkdtm_mutex_folio_kthread(void *)
         |                                      ^~~~~~
   drivers/misc/lkdtm/deadlock.c: In function 'lkdtm_waiter_thread':
   drivers/misc/lkdtm/deadlock.c:228:32: error: parameter name omitted
     228 | static int lkdtm_waiter_thread(void *)
         |                                ^~~~~~


vim +99 drivers/misc/lkdtm/deadlock.c

    97	
    98	/* Attempting 'folio_lock() A then Mutex B' order */
  > 99	static int lkdtm_folio_mutex_kthread(void *)
   100	{
   101		while (true) {
   102			folio_lock(folio_common);
   103			mutex_lock(&mutex_b);
   104			mutex_unlock(&mutex_b);
   105			folio_unlock(folio_common);
   106		}
   107	
   108		return 0;
   109	}
   110	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

