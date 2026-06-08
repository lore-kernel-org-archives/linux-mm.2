Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BD6CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 04:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6036B0088; Mon,  8 Jun 2026 00:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FFF6B008A; Mon,  8 Jun 2026 00:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107DD6B008C; Mon,  8 Jun 2026 00:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F028D6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 00:30:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76F74C2F27
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:30:04 +0000 (UTC)
X-FDA: 84855467928.29.2B3FBCC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F8B3140004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:30:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XkTzj3Fn;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780893002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAyjfW5hQcjRxRYsnYOnoLADcJejEqx0kStpi8Wxz1M=;
	b=601fcQit8xUK8zfzUO0mglWkO+FEH6vreWWRut0pDcTO2nzGS4Obls3SG5Ncgwp8ukWc+Y
	NrsQASJa/si7kdIUkS4Xj/ZQGN33CEQV1NQlSfMZNXNVdHhj3wAUb/xr3QBSWRUp8SHLS2
	IwO9nXPRCPPr9fUa8ySR3L65HsLQs10=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XkTzj3Fn;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780893002;
	b=npZuBL4NOTlt0jrLP3dT95M0MxD9p9hLlcIdehjvMcjw5BaNmf2qk3wTo91JxOhrbvR+8g
	NuItKyZ5PDLxRtEhyVGhV4qr/A7u0XprEWnKVcZpxac9KH0dcZKhjOeSqNysgmgRRn1h6U
	Wc5gsdELSWnHq3Ig5oczCntfsuwdOAg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780893001; x=1812429001;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+wEs5IJV5oO+EOWekZdDzdA8xuR2rCvRTidHA8gFWO8=;
  b=XkTzj3Fnp2ppb7klY/bbCMZ8i48jIhDpIk2E8s/zrcub4cuBNn6S8Uc6
   ihrwUBp7oytVNdYvaWaNmjJ2oQl3+h3tIjCu5itbwbSPcunddESGn3gt0
   aXkSsv429JoqK8A5Un4LwJCTa9RSqcPBpSEi+uUpNagwILOXP5uYfrpl2
   uyCh4fvhWtzvR7zI9OkmHBHI7+RbJ+bKPrkYm9MWqI8iAobbkwCv+qGv/
   OG2eGvG6/3VbPLli2yWAX4/ykSiJ9b48eipmdcOiY9fjyXSSfjM5TOOFR
   N2Tya1UDPyBkQI3wehrgz9Dy5Fx0hG4TWEaIF3ke5bsyG8Z/SBatfN+ey
   A==;
X-CSE-ConnectionGUID: PoIemTHMSfeCckWBZKmn+A==
X-CSE-MsgGUID: CqUiUyF3QKOOUSAmf9AzSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11810"; a="69155648"
X-IronPort-AV: E=Sophos;i="6.24,193,1774335600"; 
   d="scan'208";a="69155648"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2026 21:30:00 -0700
X-CSE-ConnectionGUID: tcC0YU9KSgSdMLol4prcqA==
X-CSE-MsgGUID: +rOjwvoySaiiSnhAtuJn6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,193,1774335600"; 
   d="scan'208";a="244318747"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 07 Jun 2026 21:29:57 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wWRcZ-000000003Bd-1F0f;
	Mon, 08 Jun 2026 04:29:55 +0000
Date: Mon, 8 Jun 2026 06:29:05 +0200
From: kernel test robot <lkp@intel.com>
To: yahia <yahia.a.abdrabou@gmail.com>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, david@kernel.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	yahia <yahia.a.abdrabou@gmail.com>
Subject: Re: [PATCH] mm/migrate: Add native folio functions
Message-ID: <202606080649.AbjPE8ud-lkp@intel.com>
References: <20260608001251.66847-1-yahia.a.abdrabou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608001251.66847-1-yahia.a.abdrabou@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F8B3140004
X-Stat-Signature: yx75jh7dkxs7673yggcs456fgt4489ac
X-Rspam-User: 
X-HE-Tag: 1780893001-217236
X-HE-Meta: U2FsdGVkX18eJFXWl0tln7NAT2RzuThp1EKSqc6eUILG154O0qUbLhw9GgS3gT4lPmsgRycEuVJhbg6PayCGnDKeADwJ8g7afPUdt00+xb5x5H8TMULGV7YUheC+mXf4P+qJDMu1jd0HgYXDyP7yT3Gng9tKxlEFY+Ucnz4iaQMeOrr6jEECYqwWOrGpp/MYs7APm4fmc15RaXdXIMeqSoHWnTk5W5Tw28si12Siz52coQOUjh+MROvF5k2Ogwtt258sSyxwc532B5xzlTuyLm665gznVrMohfQwmzXwudJlGehCqdA00bRAC6Qn9NgPmK3WJehLlLvG4dKx9g+K1eL4zFxiAUaa+cQVL16KYO6hpqsn04X5uF0FMDiR1TBVGgOprYEQs5PrQIvMYhRqGXSxuReo+xiwBwgshzESSO1eAGBYRxZMExd2FPoJ8nlEnFu+QRLXFnD6cCr37Z5MBXG893ojNUVrzdK38BV9N/wUW9jg0+DCgNTksvRO3O3hzoDxkwRWuLCIL0Pe7To/ClBJVm1Cx1+psio9k+sE9RJRaKGitzBV5wZb442LZY/O+wVXLY82GqOX4Ug8Dy1SvhBXft+CDnLWN3ISSAbQNioi4vFODJXLNI6kRuqwsFewf4XB72gpc2HrF4i1WBsQf+FZc9MRMG1GSZGc+EMjypCcwkt2x7dS+ZFC2Yz8HOIMp2MYe5V4bzhHzjkhosPVx/SPNB77HCZHx1eq9CS5AdvsLcxXrVGFjJ/GB3uI5j17OkoFEXUdEVa05KzSsAux061AQlxzs1xu9cp6dozLYZHEFbds+ATNoR/dvh70dgTj7jGP9+xFmP16WjxxLGBynmdtZH4X4is25J2So3T02brgJ4blLEtLqepiJowC2JEq3Le4D3SnOGLeS1qaHKgtk1u1x3cmb8Lv/KqfNGSYCBnrXUnfdnae7Pob0g21ACNybQ0mcNEexXF+e5g2bHi
 6ewQ1Lzh
 H2DcXhjQHmlShTLkYrz/xsK10Ea+TivjouuCvbeceA30NL3gEsAM5TJEsFC5TQms6ApcZ0Nm5UD6310Hvd9cEQRdJEg0Wpd/aRcMz6SXKXZDw6C5PztomUaYmTMUomDRXKCzYypTHk5AEMnVQnVmw1asqSfLfbCjllny6Sj+3NaqQxj38cBREEVNq1tbotUaz714MI7yz/BiA43OWcz0X6ij5/AhRXsheX5jrCnIKSucwS0DcffJPP9wYlEtuqRibLH6mEWMJyXoGoXPtxwktOh1bW9uY1c+rvrm/qn5XydF9AMKpG02gGE0DA0ehccSVTnJsZhnikPecRFAuMwETwG6CblNUHPjzzl8Alzdm+ju5zxmOwPCkJTJvHvicOIkWMaEClDoGLxmGWnjE0RHDBItFddYRo9jEP/SBV8d4svSvAVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi yahia,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/yahia/mm-migrate-Add-native-folio-functions/20260608-081741
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260608001251.66847-1-yahia.a.abdrabou%40gmail.com
patch subject: [PATCH] mm/migrate: Add native folio functions
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260608/202606080649.AbjPE8ud-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260608/202606080649.AbjPE8ud-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606080649.AbjPE8ud-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from ./include/linux/bitmap.h:8,
                    from ./include/linux/cpumask.h:11,
                    from ./arch/x86/include/asm/paravirt.h:19,
                    from ./arch/x86/include/asm/irqflags.h:100,
                    from ./include/linux/irqflags.h:18,
                    from ./include/linux/spinlock.h:59,
                    from ./include/linux/swait.h:7,
                    from ./include/linux/completion.h:12,
                    from ./include/linux/crypto.h:15,
                    from arch/x86/kernel/asm-offsets.c:9:
   ./include/linux/page-flags.h: In function 'folio_test_MovableOpsIsolated':
>> ./include/linux/page-flags.h:412:19: error: 'PG_MovableOpsIsolated' undeclared (first use in this function); did you mean 'PG_movable_ops_isolated'?
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                   ^~~
   ./include/linux/bitops.h:43:32: note: in definition of macro 'bitop'
      43 |         ((__builtin_constant_p(nr) &&                                   \
         |                                ^~
   ./include/linux/page-flags.h:412:10: note: in expansion of macro 'test_bit'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |          ^~~~~~~~
   ./include/linux/page-flags.h:1113:1: note: in expansion of macro 'FOLIO_TEST_FLAG'
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         | ^~~~~~~~~~~~~~~
   ./include/linux/page-flags.h:412:19: note: each undeclared identifier is reported only once for each function it appears in
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                   ^~~
   ./include/linux/bitops.h:43:32: note: in definition of macro 'bitop'
      43 |         ((__builtin_constant_p(nr) &&                                   \
         |                                ^~
   ./include/linux/page-flags.h:412:10: note: in expansion of macro 'test_bit'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |          ^~~~~~~~
   ./include/linux/page-flags.h:1113:1: note: in expansion of macro 'FOLIO_TEST_FLAG'
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         | ^~~~~~~~~~~~~~~
>> ./include/linux/page-flags.h:1113:37: error: 'movable_ops_isolated' undeclared (first use in this function); did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         |                                     ^~~~~~~~~~~~~~~~~~~~
   ./include/linux/bitops.h:44:44: note: in definition of macro 'bitop'
      44 |           __builtin_constant_p((uintptr_t)(addr) != (uintptr_t)NULL) && \
         |                                            ^~~~
   ./include/linux/page-flags.h:412:10: note: in expansion of macro 'test_bit'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |          ^~~~~~~~
   ./include/linux/page-flags.h:1113:1: note: in expansion of macro 'FOLIO_TEST_FLAG'
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         | ^~~~~~~~~~~~~~~


vim +412 ./include/linux/page-flags.h

dfbac6dc68bae9 Matthew Wilcox (Oracle  2024-02-27  406) 
f94a62e910840b Christoph Lameter       2008-04-28  407  /*
f94a62e910840b Christoph Lameter       2008-04-28  408   * Macros to create function definitions for page flags
f94a62e910840b Christoph Lameter       2008-04-28  409   */
dfbac6dc68bae9 Matthew Wilcox (Oracle  2024-02-27  410) #define FOLIO_TEST_FLAG(name, page)					\
ce3467af6bded1 Matthew Wilcox (Oracle  2024-02-27  411) static __always_inline bool folio_test_##name(const struct folio *folio) \
ce3467af6bded1 Matthew Wilcox (Oracle  2024-02-27 @412) { return test_bit(PG_##name, const_folio_flags(folio, page)); }
dfbac6dc68bae9 Matthew Wilcox (Oracle  2024-02-27  413) 

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

