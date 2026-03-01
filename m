Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189D6FD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 08:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342B96B0005; Sun,  1 Mar 2026 03:25:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0C36B0089; Sun,  1 Mar 2026 03:25:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF716B008A; Sun,  1 Mar 2026 03:25:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE576B0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 03:25:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAF60B818D
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 08:25:58 +0000 (UTC)
X-FDA: 84496811196.20.ACE580B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2722FA000A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 08:25:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y+Noax4D;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772353556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnmtOowvcLnGYWXBmjLfbTevphSDU8Ra/es7Vc8SERo=;
	b=0uBW3a+RSr3ozIvi4E88vWuzVH5G0HlldKbL5p6+UnBBrm7ruvS1XWg6BKtNRvKiTPOPQI
	Ka9uAq0mgjKxCDAAj4VjHSpU+Kg96ktpLUl7u+aC38Y1+i8zpWqhxKEDMc5B05HdT9BLCP
	O3yDeYjO5FjOQc3rmlfTiVsa6YmcdWU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y+Noax4D;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772353556; a=rsa-sha256;
	cv=none;
	b=E4s5qUkjJKctxfyuFE5Jk2MCEchRtQdW6ZpS2lKFp67wKY2m0STg3G6456awr7l39JWUjl
	hiD9WRB5VGi2auTQjDB9aec7vjStXzHrIPnRXdjbj5gJSj8lVHGaSDTqwSvo2xyt2732+n
	M5btJWwsK0NC7cVjsCxmv2Bt9UHc/c0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772353555; x=1803889555;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f2Pvjk7JSG65hzMSwpYeBqHr6b2wxFUS0wZ+zeQcS7E=;
  b=Y+Noax4D9fg7b6Qv9uc6C8vCkiIrA+YSL3B+nN4RfvcnrM+CrSGorpMJ
   fAKdUiYpr2uSXhCn0q/+9qzkqGKk2p11VvoRF7IqSgYE1d4LCmsValY/m
   Ac9ZhFvWZlvYXmx59EE2tQ11VVN+VYe5D/KxiYjsDsZIELwe/U5OLpKaH
   yHx7zPZ3ccLU6mIXYUtSY6PPacXeX4IncYKlOGmOj+ocMkBxGkhU+hz2B
   5+JR92DSVeKfAvlR1rWnjjPxCisDOIUCejtLpH8/h/pWtAfweev/Y7+/V
   T/nIVs/MNUtDdyWSgLrMwZq0JcsWJkRk72w7XnjtFA8l+czGzgwIMXWLT
   w==;
X-CSE-ConnectionGUID: SR7leyxbReWXHjvQYugJOg==
X-CSE-MsgGUID: EnXANJEKRFWlyp0bgTFb3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11715"; a="73430621"
X-IronPort-AV: E=Sophos;i="6.21,317,1763452800"; 
   d="scan'208";a="73430621"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2026 00:25:53 -0800
X-CSE-ConnectionGUID: d8hc9fy+SdWghNOIGBnFCg==
X-CSE-MsgGUID: qnJsAdZPQF+KgJQozITTMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,317,1763452800"; 
   d="scan'208";a="215056542"
Received: from lkp-server01.sh.intel.com (HELO 59784f1c7b2a) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 01 Mar 2026 00:25:49 -0800
Received: from kbuild by 59784f1c7b2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwc7X-000000001LR-0n2u;
	Sun, 01 Mar 2026 08:25:47 +0000
Date: Sun, 1 Mar 2026 16:25:41 +0800
From: kernel test robot <lkp@intel.com>
To: Matteo Croce <technoboy85@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] KUnit: memcpy: add benchmark
Message-ID: <202603011603.4178c0iZ-lkp@intel.com>
References: <20260301011209.4160-1-teknoraver@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260301011209.4160-1-teknoraver@meta.com>
X-Rspamd-Queue-Id: 2722FA000A
X-Stat-Signature: 7ehtmiefap94zrtfhsya9u33szr1ng9u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772353553-213781
X-HE-Meta: U2FsdGVkX1/9rTZEftjMASSYULhCtempyEg1h2XiAnqbbGSc8BXwvpKGBVTeG4ijNsLOXD7FJLKa+bv2E/zDdCJg5pVW7LwBPOZhPxUyaPuvhZ7Y9hzgnsMCsO93fhUbM9ADePNa0R1B1N2aHmcybf49EJSi4ijLYr59TAMazA0f7SEmmXry/zsuiNJzubYxmaW9thjl+oNmIy/4Uy7nepttOKBnsb+dKihKkvlEKVK1D0nX1NFtj+MC9JEPgqb8Qvaq2zJzb1X/qAL+Flyy5kGR3dbQzxWE1BfpQXTxJtSgiKIC09xTC4tdVSF7MSjf98YV4UCwmfMBMWupnWeFkZMyrY9wP9KGgeWKj/v3Hb3eFLFwmhvS27YkBfCTzAwDkzmSrgU9PfG0KVnSD8zeH49didlRPkezogUpFVZyB+gDvOOHJAulpQMm2TBA4WiBbDufz+w2r/GmzXyGEcRUVejKSoqEpkNI44TGyqb1y0KbTWavAEGy4tjPrUdbytnaxrT9l2pvsZ7QpJl6A1bcpKRqAk2ArVMhFybzH5Ldc5d569COtkneMCBMW6/i/K4x8TBwnlvb4eFfNZKjGs26HW2xV5DXSGk6mc+VJL84UbHD8DEIQp1QnES5ypaG5t42DcjvdCGBytxriGrQVeb3spBY6w8xtU+cEIyHriMtSmJ00M4upC4wEqmicl4sLb4eq4newNZxmWSQoDLC1Yqtke2BJP6nLHhb5pX1bQgCY+3FRoOxr06yUbkCIVDC+y+oiVqBYUZJcp0VDrs2thviFFCrr/VtlbQPtefgilUPI3yRa57oKkRBWs04vPzQtB3UWBshmboB7WkORbUpI8qmeltcvQjBD3kdZucGmDjZRX8yWc46GO6HHuJaMCJfXEM1G2VRvl3J9xzA0jLNX8TLygcNsMUH0YeVe130lyQLdlqu+KfBsASb7jLAIqQNFRBdQ7P5HcSV3HIszdN2ZvR
 yepc+QuF
 oHwWvNGy26qFOOcy61Uypu0Hvy6tB8mxteDEuvHkVwzve5xkuTLT0JFZWtg+kxhVsjZvR+ve+vKS2dxTaQ+9hSwD8gKfjGPpHaKAykTI9iOpYWhc2deh5EbkLbQTMO3+W7VtbpcVxJm/Fj3VS1J22asuwKMXDJ98J/TpkNJYVw4ONSQ83y0riUULbRt+7ipXbFPKMWL9I81xQj1wp5/4JgtTRlz6sygcpyuLVRtgOBBgsuWSCNHCek7xnDxtdQ7cQOtpzdVhXwyNmbOjUwhwS9n+bjF2DP4qgS8MDed9Fgvfc1H4iK4+S6kRl6a0QvBlRvk/3Yj/AuhEv2If+AnM1TctNcQUUaUnwoE33Y7pG6JRxghIGSksSgQiZmVN3jPM4Arb8lYvhyAJZB7DAiWsQpqxU2AepRjC4CDHHX7Xjw/AgMm+xhZVO5mYPEL49Bi5ilWB8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matteo,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on akpm-mm/mm-everything linus/master v7.0-rc1 next-20260227]
[cannot apply to kees/for-next/hardening]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Matteo-Croce/KUnit-memcpy-add-benchmark/20260301-091336
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260301011209.4160-1-teknoraver%40meta.com
patch subject: [PATCH v5] KUnit: memcpy: add benchmark
config: csky-allmodconfig (https://download.01.org/0day-ci/archive/20260301/202603011603.4178c0iZ-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260301/202603011603.4178c0iZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603011603.4178c0iZ-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__udivdi3" [lib/tests/memcpy_kunit.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

