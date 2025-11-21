Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B9DCFC295
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195056B0027; Fri, 21 Nov 2025 12:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D1D6B0032; Fri, 21 Nov 2025 12:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AAD76B0088; Fri, 21 Nov 2025 12:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAEB86B0027
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:14:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C21454EEA9
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:14:21 +0000 (UTC)
X-FDA: 84135262722.29.702FA94
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id B924C1C000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:14:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OzaXz1na;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763745259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0Ln7Qy0WzK6KcwM+QrZ+sKZlNXZITj0EzL0IqlThdI=;
	b=Ed/SA9o+tZpUiRueOly5s+DQgsrD3Ig8ePprwro4tpdbgJqrJBZCm49U7vqh47Qa6r5Qbd
	8Rfgcu3hFu6EUCFQvgRD0htB/R7+y9xBsSYC90aMN4pXxCsIRb8su0dcVU6HcOEUjNJvU1
	y8qRotQ7KEWqVInNE0mVA/4rMvkDhYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763745259; a=rsa-sha256;
	cv=none;
	b=LIAgH3rX2LZxevLI2vtdq1hfcWiKVvwce0IRbxBypwfySTvSa5ZGkhyFvJ/k+loVBC3Zpm
	kWxBGxfb47No6+iA9aEGwXbyVNRTbr6xaU1KJ3p+OL3NmJ5aKKhpiVJege36wV5IPXgX3A
	wpl2LHN9uhmszKMMdXLeUWQuHWuaFw4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OzaXz1na;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763745259; x=1795281259;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=150knvdVimP1Sxf+IHS3A/Uh2qRTdjSQ1ygg39BCet0=;
  b=OzaXz1naJnKJSEtDak9zlYApSCxERwPr0cV97YD+ft3SorACLSOQVvVE
   C2LNGg7wA0Iqi4MR8cp+1OBvlXmZgW0XIZGLEZkBSi9/V9XlGru3bcXw9
   EDhXg5r+bHvLnz88vtE+jsRKT6etQvJa5KMECgKy51apU5Ercb7v12UHI
   YsA/mJH3YzEHolG5iH69OC5SKJ6BnGRIveVweqdH+sMZScXoL+srM62Wj
   L7y4wT990gErW3t+UcJd6do/fz/gphlTeX7/igYsfvYX3qIInI+L5sR7r
   I/wfUz0lenxYqcJAUMiTn7Mul40sMUCA086onjAgXhDDVXmxfgyTxvFDe
   Q==;
X-CSE-ConnectionGUID: yFHgP2wRSYKy7FocIHs4Pw==
X-CSE-MsgGUID: 6I+upg8KTUaExUTyUdUbfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="65792213"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="65792213"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 09:14:18 -0800
X-CSE-ConnectionGUID: qu6B9a0bRZ21y0YvoYxbGg==
X-CSE-MsgGUID: Ssd/qetKQuewq4dpfK3Qcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="196687127"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 21 Nov 2025 09:14:12 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMUi1-0006dT-2W;
	Fri, 21 Nov 2025 17:14:09 +0000
Date: Sat, 22 Nov 2025 01:13:52 +0800
From: kernel test robot <lkp@intel.com>
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	tglx@linutronix.de, andersson@kernel.org, pmladek@suse.com,
	rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
	mhocko@suse.com
Cc: oe-kbuild-all@lists.linux.dev, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: Re: [PATCH 03/26] mm/percpu: Annotate static information into
 meminspect
Message-ID: <202511220009.u6dJXVkB-lkp@intel.com>
References: <20251119154427.1033475-4-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-4-eugen.hristev@linaro.org>
X-Stat-Signature: x7kp5nchuyrgdk6tf39sk3kjjrs5qox6
X-Rspam-User: 
X-Rspamd-Queue-Id: B924C1C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763745258-743025
X-HE-Meta: U2FsdGVkX1/rWBV2Se8BWIfF+HqY3YBOhYb2IZjSfoD5mKUvwqCR6Gc4Bdw6jiH8U+JDXo7Fl0x8TpA/O6MQ/MesShQmEI8yd+u3tDs9l5wCqnnc4HQm2mHpD+WuBq3KUBsh96zlku41dta8WU2Jc+t+sLWCP1faesPwYXlKNuL5Q4rCjnxoJtBI2VqofykSXqaAKNH9nmtNT7LN/9UNjPhdh8ae2FdCIrcQTCO9Cs1t1q6pccrzGbvaR6kDV1dXCHkh59EXYk/ZyjNbjW+QXkhBcmaosuvQZv251jU6IcjXzNH1t35EfPC51RolHyD7as36xNrqgSwsAFTZtNbxz+2QUSWerRyv5bDvQsjjT4atdVm+NNDmfrVYjlqskoNM2Ybdr6iD7dUVRYro64z72iR8BE+cc33uYNPrDeTDmnILf6IqC+dD2Pl8Ywm31G1PZX0o426POS+PtqC5WxUNdJQIK+DEhUzHOwDZidYlZD8Pht3u9uHeCwOCFZmdQo23WPZhujTUlUl5LlYhb/04sQk40w5CXNL5L3Y7LXFEvkS7IlR3llmb/qs0KTLBAM4oYW9Tttur8rWnRA2arkZhyfy1SHSOfF3uXlFUbWaxQh+h0P3Nva5qsCprYoGuhRsktEKgeXttQX2vI+KFQTkU44AUtqyZNnm1fPx3/4zgSJADsl3RWrUFhyk4HGCrShciZTlHlFyT2HYJaaN1A6k+3hn6A2n/cU9uRQXnw4+m2CRYCmjAEllld+5R4HT/zMEymTtFmsI6v+j2qXl8VjKYtprjVCFGeFMRWO/DL8jReSzSUT4yBzfurAVI6Sbz+WI40n43wY4hO1I+pLhBk0DYC40r986rEeyanyO2qI48u1A4qnHS7oAQ90vZkKFnJo5kQP1PaSz73H+JzI+hzMmR6RwXGK9BOx6nJaCCTkOc0mUNmPYMEwmiDuuUM+UOhKbnF6N/5XXZCdL7QTzlxdK
 EQqjeGaJ
 a46iB+fF9jgTapyvaL+gVZBMrfcPaQJoEeBUgLZvuxIdMVJu3Bc9vzIAubuwdKp8btH3FnMqVonSSWGTXq37siFaf2dNCDJYYHWMBYWCjNG3dS0O7Lo3Sx6rGPpXhCqSebBJbSfovtohKmoJRe85YxnrP6rClScdNz+TcMjixh0zbDsVwH2hu12l4rLPrltDFtCvTnwdvWXNWJSDhz3SyqKjXJST/fDi5v3NeCmAY77uO/lsYk4rtLdMO2LG/b4E70OYwDSwsNGnzWi0RQHOOnWEk8Eok5Wp/FWTlUgFOYlHzSz4GndQHcW2vygbYcyrcXHFVtpT6JOkD0VxA+UynrasinJBv3rV8GkwrBCId3Qh1yqQ/fFGIIf7gp/bhktgExq71mbQa5dWxq5mfuWwRQ7TOZieKHNv7WsqT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eugen,

kernel test robot noticed the following build errors:

[auto build test ERROR on rppt-memblock/fixes]
[also build test ERROR on linus/master v6.18-rc6]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next next-20251121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eugen-Hristev/kernel-Introduce-meminspect/20251119-235912
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
patch link:    https://lore.kernel.org/r/20251119154427.1033475-4-eugen.hristev%40linaro.org
patch subject: [PATCH 03/26] mm/percpu: Annotate static information into meminspect
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20251122/202511220009.u6dJXVkB-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251122/202511220009.u6dJXVkB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511220009.u6dJXVkB-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/percpu.c:90:
>> mm/percpu.c:3350:25: error: '__per_cpu_offset' undeclared here (not in a function); did you mean '__per_cpu_start'?
    3350 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         |                         ^~~~~~~~~~~~~~~~
   include/linux/meminspect.h:92:64: note: in definition of macro 'MEMINSPECT_ENTRY'
      92 |                                                .va = (void *)&(sym),            \
         |                                                                ^~~
   mm/percpu.c:3350:1: note: in expansion of macro 'MEMINSPECT_SIMPLE_ENTRY'
    3350 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         | ^~~~~~~~~~~~~~~~~~~~~~~


vim +3350 mm/percpu.c

  3349	
> 3350	MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
  3351	/*
  3352	 * pcpu_nr_pages - calculate total number of populated backing pages
  3353	 *
  3354	 * This reflects the number of pages populated to back chunks.  Metadata is
  3355	 * excluded in the number exposed in meminfo as the number of backing pages
  3356	 * scales with the number of cpus and can quickly outweigh the memory used for
  3357	 * metadata.  It also keeps this calculation nice and simple.
  3358	 *
  3359	 * RETURNS:
  3360	 * Total number of populated backing pages in use by the allocator.
  3361	 */
  3362	unsigned long pcpu_nr_pages(void)
  3363	{
  3364		return data_race(READ_ONCE(pcpu_nr_populated)) * pcpu_nr_units;
  3365	}
  3366	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

