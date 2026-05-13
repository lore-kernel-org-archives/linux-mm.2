Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FCECD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11A96B0005; Wed, 13 May 2026 02:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2766B008A; Wed, 13 May 2026 02:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8296B008C; Wed, 13 May 2026 02:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEB56B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:12:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 324701C0604
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:12:49 +0000 (UTC)
X-FDA: 84761378058.22.29272AE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf12.hostedemail.com (Postfix) with ESMTP id 54AE04000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:12:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VEDpkUeW;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778652767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kulAadu8v3nhPZk0+R8d2UtPX/USAEPfnTvGdtyvtak=;
	b=be+j0PbtV1uFs/tHK7RRgbaDrCIB/qSho3KG+rqHtKKUTZJ5vnW4gwKDZdx96QyiHhNm0m
	SK0rdFzGrHJGiTME5B8LmXQex/oJ7xSAKyRyLXF4aahsB6cdrwbHS5pN5Tc0kk+EfH5InR
	p6EczbDPYve5lPp2TKust8nfd10ShFg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VEDpkUeW;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778652767; a=rsa-sha256;
	cv=none;
	b=G1CMJQsY3KkSyQGRGRZkZ1GvuvyPs3MNDjwC16uYYPTG2bPDVMC9cCfmZ4hoT9xwrpzqNA
	DirkxV2+Gjgn7KNEpV/3uZtNdMAeAdMB3qi2kB9LECFXUm+3RsIeXUESN5LO+1dQueHkaY
	y9jOxAZ+zOB9/q1YBivBKKRs16xkZqA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778652766; x=1810188766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8/g0tgr/8x4vCKR3FY6O1wuKpyVe59KewQCyaI/CkQQ=;
  b=VEDpkUeWfbefmGze2MvTkpd497gn6bEhnhZ5xkQ/a+/JA/kAJlqYfpc6
   YZpbpZEyjWpgIS3B6LrkmAR5/UtJrdzbkT3PgDBgmM79NmwILQ6XKxjOr
   PJL5AnhVeZBVx88LgJ4ugbJ5k4wd41xtjlSb2fn2n5icTLmuFJvbAHCME
   IYkZ25QIKp41iUpOlj5oZZdBpDkzMdVDmmzEfoo0Tnxs7u5x/T+UqoRVT
   e+dB4Vf1oB25vtJkOuYOv8jyVecYUlgqZR4tO2AodBwN3tvcW8+g1EQEI
   HOcU2bkoDyYbFD1BheWZrX2A/XFmch9s3UHJjxjHk9+C0mRhuRBisK++v
   g==;
X-CSE-ConnectionGUID: ZzqQFvmDT4GeZ6rEwuWuSQ==
X-CSE-MsgGUID: xoKTUv+vTlOuVWEoH3Tz3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="90955032"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="90955032"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 23:12:44 -0700
X-CSE-ConnectionGUID: 2i93/dl6TbWCCX0UwefHBA==
X-CSE-MsgGUID: phmejI5KRIS5n9pT4+TNMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="233713261"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 12 May 2026 23:12:38 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wN2pg-000000008UF-2M6L;
	Wed, 13 May 2026 06:12:36 +0000
Date: Wed, 13 May 2026 08:12:05 +0200
From: kernel test robot <lkp@intel.com>
To: Albert Esteve <aesteve@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
	dri-devel@lists.freedesktop.org, workflows@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-doc@vger.kernel.org,
	peterz@infradead.org, Guenter Roeck <linux@roeck-us.net>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Dan Carpenter <error27@gmail.com>,
	Alessandro Carminati <acarmina@redhat.com>
Subject: Re: [PATCH v8 4/4] kunit: Add documentation for warning backtrace
 suppression API
Message-ID: <202605130826.e6Lyyytr-lkp@intel.com>
References: <20260504-kunit_add_support-v8-4-3e5957cdd235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504-kunit_add_support-v8-4-3e5957cdd235@redhat.com>
X-Stat-Signature: hoqxwp87m5gke4ix8w1saimaku5u9j73
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54AE04000B
X-Rspam-User: 
X-HE-Tag: 1778652766-37975
X-HE-Meta: U2FsdGVkX18WDyBLtss3pgxG7iaPV33U/VdOvqlO6uS2AR5e6TvddJZiSApvPfKvDO+XnjjQZahf0gTbkgfSGqI7jCCelPvquzCRtp8RUWCF3jQ0E7e9O4onWYXw6TgKzdcCvdmAkmP1KXeThEAgAo70oq7MsRdcGYQcTKys2dNL/nx/JeQGqLWNQy/Qdd3E99t8LipCIEUtW9JIkXC8l2D+zxzyzdh9Om0xwjm08SSbyF4vlIFY07T1itbmc3d09xmiL+y3ZSO9e4NdFX9BGhlXMDdJ8IUEqzaVbPC6RcIX+EGN018hmu0SVoSDyYSMd70C4v+5xVGvGfrs72MgtEsfQL0/zLoVdc9hDTFJLHN/EEKWa15XWepRrIoz57GNxJBxVIRy0lTBsKm6iC8II9gVlzdQXgUdeIwsfmv1KOxd9963RGBWCgkYMi6A/+hcfGnI/l+DXNOKWSoxa5P0HSndNL1XNCpPnvNZVoEnyvbyQXgsA+T+qkxUIaUmJePFvpbbpBYlMiRfjjtyetAclGVLMvtueaJ65hoq5+5i/w2R25NK/SukR2IoPJfRVeuRVnUDCWvzd0tSnJe12FsCTvtmzv5Ff/jf2Z8e23aCxP7XfLDzq8IhtrsUcxYUz+JCLpjjYDzHo6Q89axnvvY7XSUa5hCkKqQam0WAS1lJ3XfVS1N3PmoQv0va0RxKoAES2NlLdwlXUdlMm7FgP+XfFwdze3MXv+0iZ9FofoVgaPAQiamzT7av+q6+P5MmK47FzkfCXOubTpwvR1brpo4Feu5J9Fn4QITJyC5ZO+JU0nAYVsVSelWkMsTJN0bv1/91sughVlhIIZcjEM+aYyrJ3ACC3sRnya/psfA15+VQYLh0bc4b+grk7iCHUM7jFZkZqKpXpl2sV17U5YvGEkH5W1vryiu3UeVF/8aXwAQPlp+cwFieWvdvSEdX6cgPU8zVPLTQ1+gBjUcHa8P/qJE
 6W4CbSgc
 6ZvEJXxfB0QtbDMDLz6TIPMi+5bEQFMIuj3f20zXNtUXw+DCFzLIqsl6Ref2eQ8PaDDi5+yDa2X7tD6aNw2xzYvzn0BfH60c3qS+lbF8p88e0LKPJRujVzoVVAb8AqJxVcLH3uI7Q6YiMY8Tjc+KLw21/ApDlMg+p6KxCspvKazGtYULhYw5w8cP8qEPKjXGWK2lRXqWz4S/uvRa+jjjRY5l2USI1ME13LJB86tN/qR3Yhwf2XJaUFCieEg5ZRT6FO8SgzcMSDGyUi3TmzQKWjTESHce8iY6qcd7WZ7O7R2kDZGH8dF8M1c19RZoHkOd3xx+w3eW0rgz5fBsFoZr6cqfcOXSWot673xRV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alessandro,

kernel test robot noticed the following build errors:

[auto build test ERROR on 80234b5ab240f52fa45d201e899e207b9265ef91]

url:    https://github.com/intel-lab-lkp/linux/commits/Albert-Esteve/bug-kunit-Core-support-for-suppressing-warning-backtraces/20260513-043807
base:   80234b5ab240f52fa45d201e899e207b9265ef91
patch link:    https://lore.kernel.org/r/20260504-kunit_add_support-v8-4-3e5957cdd235%40redhat.com
patch subject: [PATCH v8 4/4] kunit: Add documentation for warning backtrace suppression API
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260513/202605130826.e6Lyyytr-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605130826.e6Lyyytr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605130826.e6Lyyytr-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/gpu/drm/drm_buddy.c:6:
>> include/kunit/test-bug.h:90:15: error: unknown type name 'bool'
      90 | static inline bool kunit_is_suppressed_warning(bool count) { return false; }
         |               ^~~~
   include/kunit/test-bug.h:13:1: note: 'bool' is defined in header '<stdbool.h>'; this is probably fixable by adding '#include <stdbool.h>'
      12 | #include <linux/stddef.h> /* for NULL */
     +++ |+#include <stdbool.h>
      13 | 
   include/kunit/test-bug.h:90:48: error: unknown type name 'bool'
      90 | static inline bool kunit_is_suppressed_warning(bool count) { return false; }
         |                                                ^~~~
   include/kunit/test-bug.h:90:48: note: 'bool' is defined in header '<stdbool.h>'; this is probably fixable by adding '#include <stdbool.h>'


vim +/bool +90 include/kunit/test-bug.h

    88	
    89	static inline struct kunit *kunit_get_current_test(void) { return NULL; }
  > 90	static inline bool kunit_is_suppressed_warning(bool count) { return false; }
    91	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

