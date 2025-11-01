Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA0DCCCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 21:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B9B8E001F; Sat,  1 Nov 2025 17:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB528E0015; Sat,  1 Nov 2025 17:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2158E001F; Sat,  1 Nov 2025 17:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDD798E0015
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 17:00:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 741EA5AD8F
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 21:00:06 +0000 (UTC)
X-FDA: 84063255612.10.59A5791
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id B015C40003
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 21:00:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lGA6ALvf;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762030804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+H/0FL0n/u9SW1BmkdZoHJob4RQ9m9Kk1I5pF+cjHQ=;
	b=2+/Udi6O4cZzK+KKDRSgYZJxl4vZZCXVYb0A6mMyVp79MVvJPUK8ml1rkMOsPAMxtkul1c
	1fkGbEh7P6AaYCzb63bwZQNqVbPhJJqJEX89IeXX3PIIx+7OjJJ4JAYCMogHnLJ/c4lS2g
	5c6wd/u/CJnP/1WYUITwnHJw/hoCySQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lGA6ALvf;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762030804; a=rsa-sha256;
	cv=none;
	b=tunXxMwvBH19EsYT+kEw7IHIskVbzyH4sv9UiPAF9HdHFcCxKUvEoOQVawZtTKWkB4a5o5
	7D+0nzwJy9kagz5doarE5tMm2ZvKxzjnvtpGsgZntn5ijGWl4cV082eSi5rqyZ0ls5EUlx
	uDfP+eE/+ZylRuIMZUIEI3z2/jEXeLM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762030803; x=1793566803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=klydvr2ZO3VGv0Pbzb4nCBXbxiw1zZRUG3hwrz4CKLY=;
  b=lGA6ALvfmxOl8PIecSGH8cWxHo/2Wx4ZhJfVpOiUf/tA/ky3QMXyB01J
   HqQmJoFm5vYeniDlSjLne48BMPYmbckTFMMeky6Cp7PR6XSKgbd5MD6gk
   lw9og+xP+bu0yB5vcTSMzhlR1mm04aC9POA/kiKSl4WctkgIyIQSaVo/p
   olcDhOek443QmFL2sx4OLXtXNh1W9Gxvj2oNzTGHheIJamHGENl2XVr9P
   2LdCYdVm6mntZzVg6AT0xXjOrxe8fU+HBMGePu/+NFCZZSWbVoIEsRBnQ
   Wh9c1mlWOtsaYwbRdQn5ONUScWkCLcBx46gplhWyNMCP9jbuE0qI01/XD
   w==;
X-CSE-ConnectionGUID: /dsXcHyqR6ebfrbTpdHsNQ==
X-CSE-MsgGUID: hazz7+YXTlCRlDYHqNip3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11600"; a="67816568"
X-IronPort-AV: E=Sophos;i="6.19,272,1754982000"; 
   d="scan'208";a="67816568"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2025 14:00:02 -0700
X-CSE-ConnectionGUID: 3Iy0IfYfTzCEs3Rp/ozSPw==
X-CSE-MsgGUID: LIwjV3HZST6fJryHpY/N2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,272,1754982000"; 
   d="scan'208";a="185799930"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 01 Nov 2025 13:59:57 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vFIhX-000OgW-1X;
	Sat, 01 Nov 2025 20:59:55 +0000
Date: Sun, 2 Nov 2025 04:59:10 +0800
From: kernel test robot <lkp@intel.com>
To: David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Laight <david.laight.linux@gmail.com>,
	u.kleine-koenig@baylibre.com, Nicolas Pitre <npitre@baylibre.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Li RongQing <lirongqing@baidu.com>, Yu Kuai <yukuai3@huawei.com>,
	Khazhismel Kumykov <khazhy@chromium.org>,
	Jens Axboe <axboe@kernel.dk>, x86@kernel.org
Subject: Re: [PATCH v4 next 6/9] lib: test_mul_u64_u64_div_u64: Test both
 generic and arch versions
Message-ID: <202511020421.ZZPBAIIw-lkp@intel.com>
References: <20251029173828.3682-7-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029173828.3682-7-david.laight.linux@gmail.com>
X-Stat-Signature: gqsn1ppdt596f317sotbj71g5c3tyd53
X-Rspamd-Queue-Id: B015C40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762030803-80747
X-HE-Meta: U2FsdGVkX1/vUtNqI8sgPA8y9vhwoso8M0qVhShmdekJ4/H8nFfigTEI9HekDwr1AR1dNpg1WHmwXIGEGJYObVu4rO7mCV0CTfOiJPW4SK6TaSF4E2r9Kx7DeFmzhZ4nOWnrkgp45PgD8kBY+IZa7YyR/T8EBwUmqW2/x14vGtAotuX75rH2+OxK9XtbfDh5Oqf7FN4u/SH7+BlkGxCfm8J7VGd0rfBEkN+AgTpw1ks9BYXLCIqUGdJh31X7JOSN5u0VzSvYiSBZjc65e6m65WGxxhIMpZG0+KVDN+AJ+K8iGZLn8ONh/S/3/pGIA/2zrmaDcd6ivI2ThNd/5sIN25n9IGRriFwbXnLyrWZ15a4Di0Q2OhR/N4tqgj/pjAe6ev9jm8oA0IBRbGxX1X1XWtafMLOZHH+NixBxdf2NDxe+pb29pOk4V91NzWrNSZ09K2V3PE7oulto5f4WLZ1mORJ3Fh5STU23kGImdsZcfCRRSH9dtNva6kWOOSIhUQMg7qdb0RytRNRKc5YXW35/kumtaDtD1mTPMgVSn0uBOEb2EuC3OM6ASx658luFF8zaz/GNPYRWs4ga9bUxJGD2nuBb8UASfs+6M5G9pLL49PcL4/1pBvu9lSXIokNp1XoemoRzrsnkOmPFgg/Sc1M2WCUzz7O1PAuTx5UOsIa4ict2ypcNMfRBn8yi/8h6iqOfPnzxQisZwgZkrtKERsRoZKiv//cWQvvoOQrGAGGlKqXf7SC4+tQRQEHqKWGDY+39EMd7c5nXiNHnlh4HMtdJlsyJhXGRGbRWKN1NUowJdcwXzIcp7+KPk532Jg9e7TRLX9Kg8f8QJPEPuM+1fFJGKooAgehhKbWNvkp+djxMeDdZt2GhFg+gq7twMhe7WTHR4+6zPyWGU0gu58M7SS++Q4FvJiqPZ/Lhad1ERvdcd99KffCX0ESfKwOVDygmMTqYGZvIGdGDw0CuQprSIJy
 dB+W10EW
 BuV370zGFEFwlJ7+hUAvG0aQL1TuRmRrrbuhXNh/zBiEkoKMaNx7WVsVsWi0A3DIITQkIUTxuwE3TF2LDFRuFbwNXZjDtxMjQEtIg2jdA/yk4EjL2JW/oquJfpZr9ykSyyQYQUUg+olP0evSOgmHbQsRM19Hvt3eU/aaVWqfQs8YYF+iuMKWVjKK2VSR8i01fZ33IWb1spGgw53zXpRpKPYumthRfyxqzUW0k8iuYTYMrUI1G3pR9Y9uy9aPHaPd1EC20wZyU19dIqc/pzXhZeIzAFljOTSvH1AT5mwP5M0kZDxdNuinKKGfZU/h8qVqlcf0oXK+w2h5xPPTrcYTvBq0HDr1+GvinqyS4/KnYb2pKj2EAau/i3QmZcAl6jcpaRYftsJQrUunO5aWzqARq/7nqwmCJC3qGXHGLgYfwyUp3/vnVyu5EEnnSCLB6S+EbYLvP8FX9ng61Bj3VX3MsRgZjgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20251029]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Laight/lib-mul_u64_u64_div_u64-rename-parameter-c-to-d/20251030-025633
base:   next-20251029
patch link:    https://lore.kernel.org/r/20251029173828.3682-7-david.laight.linux%40gmail.com
patch subject: [PATCH v4 next 6/9] lib: test_mul_u64_u64_div_u64: Test both generic and arch versions
config: i386-buildonly-randconfig-004-20251102 (https://download.01.org/0day-ci/archive/20251102/202511020421.ZZPBAIIw-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251102/202511020421.ZZPBAIIw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511020421.ZZPBAIIw-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/math/test_mul_u64_u64_div_u64.c:142:9: warning: '__div64_32' macro redefined [-Wmacro-redefined]
     142 | #define __div64_32 __div64_32
         |         ^
   arch/x86/include/asm/div64.h:78:9: note: previous definition is here
      78 | #define __div64_32
         |         ^
   1 warning generated.


vim +/__div64_32 +142 lib/math/test_mul_u64_u64_div_u64.c

   140	
   141	/* Compile the generic mul_u64_add_u64_div_u64() code */
 > 142	#define __div64_32 __div64_32
   143	#define div_s64_rem div_s64_rem
   144	#define div64_u64_rem div64_u64_rem
   145	#define div64_u64 div64_u64
   146	#define div64_s64 div64_s64
   147	#define iter_div_u64_rem iter_div_u64_rem
   148	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

