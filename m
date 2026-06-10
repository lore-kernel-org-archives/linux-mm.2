Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F7ACD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 19:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5ABA6B0005; Wed, 10 Jun 2026 15:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31D16B0088; Wed, 10 Jun 2026 15:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20286B008C; Wed, 10 Jun 2026 15:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B37436B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:42:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DE731C2362
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:42:55 +0000 (UTC)
X-FDA: 84865025910.29.F9ACBD7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 51C7E1C000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:42:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dsgeVa7B;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781120573;
	b=gTtAX0HPJku9zwgiYxqz1roZJenKRT1u+foxr+1fqbIjU2Wf2SMGL5YB1xd3k+5D2IXj4L
	QY44bEoW/efkxGO78cEh2VRBfaA4HCyMEeaWrVD9f1vRBvM4jneR7FZLwyXelGWgyhTqWD
	TIdDOEsQi9gNGX6QwIsoYcUdnlFMZJ4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dsgeVa7B;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781120573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58bz1zNf/OMQJBgfzAHBVSCsX9KmSLxmT+3J1ec1tiY=;
	b=Jl6Ds5QuWcY1xWEfd/682USuepusEOd+5g/Wh14c3eJS6MOGssQp4LUlS79DPOTaawkVVQ
	UcL/xjm1kP4tHJ/WyjcxDVZR88hm8D4zi0DfCrxoxsW6jNwY/7L1XW1siadNMvjHxD7+6j
	OAp26hlcWNzG7CbUFy0f3rajfbnkDbI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781120572; x=1812656572;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dP4HXRIDYUSR15Nwgds/5wXJm0luZvRegrcYrhnfNy4=;
  b=dsgeVa7Bkc0R/SJuoEpX7xkdwwIvOupnbyYT+Wi/AohkLjQLg+wb7Dfm
   /RghFr2p3GPDgzVVCYkZ/T+ZjAN2MDi+veStU5o//qHcGgxwrQIWjfqIS
   CUlxag0gdlCxsjfA1o8Uxh/mROv9hkZ2iCy1M/Mn44d0lXNkNSczyS7SE
   7lJMmnGml6feyXJ+jAp1zLXsUcDzcXEtj3hiGfZmLMjaYqvdjv/DNpi3A
   E/28KmTd1VV7BJ5V8M2RQxSR3D1h+7pnZBwzqg0ny5ULavjgizD8hesAJ
   sRbxJ6vuHtvlObmfsCvoK+E/3Ah+ZBmz223r+9CovfRv4XXjO2f3DW0Fk
   Q==;
X-CSE-ConnectionGUID: gTaZ8c//SWevn6+oqTnmPQ==
X-CSE-MsgGUID: v59iub8bR3mKsuHuyLJuIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="92243800"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="92243800"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 12:42:51 -0700
X-CSE-ConnectionGUID: 3jQBOfo8Styw2yrTc2+UuA==
X-CSE-MsgGUID: h4L2fMvHR8umsHN+MGctDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="241847089"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 10 Jun 2026 12:42:48 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wXOp3-00000000Lq2-2zVn;
	Wed, 10 Jun 2026 19:42:45 +0000
Date: Thu, 11 Jun 2026 03:42:24 +0800
From: kernel test robot <lkp@intel.com>
To: Abhishek Bapat <abhishekbapat@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Hao Ge <hao.ge@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sourav Panda <souravpanda@google.com>,
	Abhishek Bapat <abhishekbapat@google.com>
Subject: Re: [PATCH v4 6/6] kselftest: alloc_tag: extend the allocinfo ioctl
 kselftest
Message-ID: <202606110300.R4LPBVBO-lkp@intel.com>
References: <d0a8308b4d0799876d24461a8ed9b5a71d3e1e89.1781042698.git.abhishekbapat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0a8308b4d0799876d24461a8ed9b5a71d3e1e89.1781042698.git.abhishekbapat@google.com>
X-Rspamd-Queue-Id: 51C7E1C000A
X-Stat-Signature: i8ydfu4nhnkhbmw67xip7bmbabqhzipk
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781120572-848224
X-HE-Meta: U2FsdGVkX1+L8V26TIC6/jAwVgp43QkGZ7UgwqMMG9iaaP47z5mQE/wSX0L5qa2J0MEBFasFNlbnmgLU5ot7W+eZxxG8wbiR5pBY28j4w33TVCqJGK0i8H6X07KvyUwz8nTaXLmZlA8FyIYnB8kpLCE4fbnsePm0tvXP5xYWKqZSuCBFlHc+jPpo5v9akuHgiyqFG+GZTMkei8r+cfZP8ZQKBB75/JrKfQHMxSG5duBiOl+EYteJcg4Pxha17PFDJzZu/srJMPIBOiUd/zQQ3qryLvPd2JABMm8aurjpZiALe508dIUyIsBUL6xR1KhUY+MI6WeCP/MgBfiHAg1KaU4IHTbOOL1ZnRumfsVv+3MGCKGTRhVE+xXPlICrtSmuEGvyRBljQC0NDnGCYB8JxKseqW3GR4jV/xfXtFiV7swfLQhrrkSgI5nKkz0MFyGjpN+sDnZ1BdGDnPDO9azJTo28paDQJ7xcXLyNw9MZTQXj5OzeOSFd5OzykalvEyZ881PgvQjBzZA920cYlmA2O2Lea7k8kovPXVWomluiFMQ52DIeEHj2LX2NxAOjbvnUcxc1UZxx97jEgD4lasBUx2HHVmlmwegDfaNDQEae6GGwg1QxkwdOHYp8R+cUp3UHr/+oWpQa4usAqhbExstrv4tnYui0X5BTHoYerOB8tfXsg+szAHq0aCRE0j2Zd6iMkRowQ8XFhV6B+guQiGwxuEoAZ+mvOm6KTfTu2+g/N9tMymSxWC6zqMTbrigD5ULZEzqv+1l2gMXUQtyi8PHJI0X8CosEG9mI02OvHY6+LmM+rYsUCbiefPPiZ9QsGC2LE6Q2vE8k7hi91Vro/HGMlAoRRtbtu17gCOqaVn+SrF4YuR1WH4B+3EMSl3xMS50tvqlXGZmWX1pUwoEgPG8ZTgNinI/eL/pck5W9mSaC28izj36majfJV0Q+CC2ME8lV17BCStYZeiIS46UwXcm
 oYgIWro3
 makWKZs226Le5O1Z19NAqFz6HvfWlcPxsQz7KNMN9h/9D+JXd/nIqVXI/IUMb53DLcfGuuFEN2W/K+WjDec3YW99aaeKoXnpiFbn7+UuhZSnXErig3ZQxXvEKOQXCbNX9l2pTpe5rUmhO5EAW+sGOyq7dU/32P5DS7bJsXOkt9WyjsiDgz7eRoL9gh3DKsjrMHeX+ucxdjhWa6bd1YuEMQznR63z+M4PzsZU1MRWKVD9PyQ5bySf2fyxgzaWyjVycjaAwDQMKHrZ4AT2lwIKA5OEke8ZqFXieiH0stz6XWK+aXxpmxsj5/aM46g44OLvNmDthBn9+V4TDUk4bhATplAt4KimWcjoZIwndkf2G+sM2aKCUzmW+2SU1Q3WM8ZsauR3tDkHJSl2VOTBaUwrSSBa2WxA/m77U33A/8vK5NV9nJ1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on next-20260609]
[cannot apply to akpm-mm/mm-nonmm-unstable shuah-kselftest/next shuah-kselftest/fixes linus/master v7.1-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Abhishek-Bapat/alloc_tag-add-ioctl-to-proc-allocinfo/20260610-081508
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/d0a8308b4d0799876d24461a8ed9b5a71d3e1e89.1781042698.git.abhishekbapat%40google.com
patch subject: [PATCH v4 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
config: sparc64-randconfig-r061-20260610 (https://download.01.org/0day-ci/archive/20260611/202606110300.R4LPBVBO-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260611/202606110300.R4LPBVBO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606110300.R4LPBVBO-lkp@intel.com/

All errors (new ones prefixed by >>):

   lib/alloc_tag.c: In function 'allocinfo_compat_ioctl':
>> lib/alloc_tag.c:346:58: error: implicit declaration of function 'compat_ptr' [-Wimplicit-function-declaration]
     346 |         return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
         |                                                          ^~~~~~~~~~


vim +/compat_ptr +346 lib/alloc_tag.c

   341	
   342	#ifdef CONFIG_COMPAT
   343	static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
   344					   unsigned long arg)
   345	{
 > 346		return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
   347	}
   348	#endif
   349	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

