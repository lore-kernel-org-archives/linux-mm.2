Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB84CCA0FFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 17:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B96A8E0005; Sat, 30 Aug 2025 13:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0930D8E0001; Sat, 30 Aug 2025 13:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0FD18E0005; Sat, 30 Aug 2025 13:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEB1E8E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 13:28:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 649B011878B
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:28:05 +0000 (UTC)
X-FDA: 83834106930.26.0F11C26
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2BDC7120003
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:28:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZA+4vpbA;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756574883; a=rsa-sha256;
	cv=none;
	b=xpx89GVRNYhRE2I3b4w1dGEAOZEhfFJLc1TPDx9uZoK/mb0C6Kp196MmxV1M/lMAww3M51
	xjXHK0h+qoRFOx3SyoVhyyq598kWGUgq8SX8DsGA8LbHNIId/OHntCICchDPG9h6zltNjK
	hW450KOrwqB+r1NqJHQJm6IFkxxmcx0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZA+4vpbA;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756574883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpdPWSfwjwXoTfBejQxi2KDPjYMfnTZnZXqsCNTrapw=;
	b=dEHWOhwgFyc6p4pWoGeSMR7Ea5VYvsJND+qEt1nHAiSIuicWT7uzASrZcvADyBFRmBS/AU
	FhDCCdRzp9RhcvYkwRhGWZ0HtIs2lv8nBkU1SAsSopOaNdMkTGyeG6hzADYQbnKpzhgidt
	IgZ+EGXwG6dWq45agPGw98U4UTa+FBQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756574883; x=1788110883;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WUfCPkzFUj71u7WVWssbAcnhvyk6h57lStw9l7AzM8U=;
  b=ZA+4vpbANR8POU0HnXu+AdED9fzuZTWBE3vQa2ff+W3nsb8aYHET0Jxw
   iVtQtLppnrDNoZyHeGz3ppmz/VwxJk2A0sOlpIK2o/lTqWBI14d/pis3x
   rHQgQ1qavY02XjMZ4ixlfJhWnemIWXEH29UWUNzVg6wU8nrdZiYkmWwkL
   GTjORCFmHjy4dcfIGy3JW9VgEran+dPDgDgTw+myj3r39UJYzyMiJIWsY
   wlDRJjoFolgbYiUfeIIbaaw5rSY4nNnrVtqrNYTVXtLh5dIYQHIEcox0S
   VNs6Ioq3J9Ssdk7Do707ppkZAaD0LRc7D06hOVa5BMHM6uQGWoQv1yBMu
   A==;
X-CSE-ConnectionGUID: 2cOcbBVVSIiwnvNNgYSOsA==
X-CSE-MsgGUID: 9hvvLsA5S1mL5Humd/dePQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="57857460"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="57857460"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2025 10:28:02 -0700
X-CSE-ConnectionGUID: yIewHApFRHyJSdoRoYbYbg==
X-CSE-MsgGUID: dfuZ6CsuSSCvvWECCVmATg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="169922695"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 30 Aug 2025 10:27:57 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1usPLg-000VZf-17;
	Sat, 30 Aug 2025 17:27:24 +0000
Date: Sun, 31 Aug 2025 01:26:13 +0800
From: kernel test robot <lkp@intel.com>
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
	david@redhat.com, axelrasmussen@google.com, yuanchu@google.com,
	willy@infradead.org, hughd@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Cc: oe-kbuild-all@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>
Subject: Re: [PATCH 08/12] arch, mm/util: add const to
 arch_pick_mmap_layout() parameter
Message-ID: <202508310153.i186f6o5-lkp@intel.com>
References: <20250829183159.2223948-9-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-9-max.kellermann@ionos.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BDC7120003
X-Stat-Signature: 9q86rco715fdgfindq43yt6grkrccsuy
X-Rspam-User: 
X-HE-Tag: 1756574882-275821
X-HE-Meta: U2FsdGVkX18IlzAOJPKthiBQxwwPxCMaTuqWk5+Vy0VXx8h3RbOkcobGtO6I/YCM4ZHPK+NJkld3rE4ea0/9ww+Pbq2zPtnflBRJm92Fc10DsCmX0kFrh1ME75JpAQAVpZYkLM4T2mLit9CLlEebQ8DF4TosdB2KbZJ1v8UgK01lhCSXSCVnECBu0lJwO1OA6sNRlPCPWxYuhcMLSu/qXuFdHAVM5B2oUjY/SWf3CcN5FqB3uky/Avtx5nmqn0GvpXNqexbMVFvYiEdE2kmGQDZF21oQQAEhkHJ8TqZDszbrQqxTLt6lgCDe/wZtS20yJIHCrPicZTlXNWOCsLQK3SIBjnBF/w0zvGtWaDP3rPRFDGfZnt1rKznHl0z6Y2I/gzAFOCDaxmWtFr/q+CWfUkWeLv3svkvvDU6h0kveVVvE15M6CyN63CoYwGWtzGFG1FcpplhnWCE7pWq8Ky0QbjjqEtHc4KLGjX/UYUXsLQiQTDJZYHM/QhRRDe3jFLSxfVabmnPIuxNzOlNFPNCdIi19m9g8HDp5JJujTg9D7mmVQ8bXSYATS5zCNtHrXciffsjbli4fLxQxcUedYA1HbsS64sBQhz8B3nNgF6aaBFmJKlJpvlTsDgIgGNEkJzDsJesdwMUig3CBgaMEgoqp9OEqcKWBN931KEvWzPb2jZLk6ccIk9UUuyKRgulPRsbwosSdAPJN3uv+OzwsuTY5CFE1brnzSVUxDQIdHkRPSQtwFtKWbkP2I9wYu5HG7CCiOURxRO9e5biavGwMf3ra+FKPTGTdF73LuSD1l6qA0NTPqpiAfqj3K4HM3Rfa0j/pkhEcGMhOvsPAyPkEWiCu7gYkukLC3QNci/06vMN5schxLcl8lbOaz2zJtmjc8uoXVovENp4lIzCm5cjI0L38RwUFw8D1tDqr23fS1q4dsOOU3sRJwdyG+kUX6Ej30W/rvCjH5EYTHd9EnVlDBXX
 1/lU9zQJ
 lsKp3TBPSQp8AO+TTwk8+j+KTHVfKYQ7aMCvYJADfdHlzdzXPJkQaIhPsOXELktSq6KVVW4qwTqLQJVT7lS3gO/frsvfVUcsjeNTllZJh9m1xFCz9ZJRm7vJJ91ySz6+3H8Lr8ac/Qh4TTY1SzzVZ6ZDMemTu+eDudfR9lUjEUgPXh90mmRwgMxQMrKkEY6QTfY76BTD7POU7CMtGThUuX9qgFHk+aPG+oFhNKq7tfeIWdow1jz33fGOxfSl8f/fbYXivBqBQ7zTllG+tPwA6CfDtMN+4/wnl67yRpNzVNaa2DI5abvHGfXv/oBlOkyvvQDWQtkA0XUr2oBizMUjL8WoC0hdnmCD3bnJ3kRNb33OV5eHLgy1QKMJInBZ1ChcjUhHqUblZCIEf/eEGU1gnI+/bqkyqenrogG1s3zbzE8i0otljk55dWyAQYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Max,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Max-Kellermann/mm-shmem-add-const-to-lots-of-pointer-parameters/20250830-023442
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250829183159.2223948-9-max.kellermann%40ionos.com
patch subject: [PATCH 08/12] arch, mm/util: add const to arch_pick_mmap_layout() parameter
config: s390-randconfig-002-20250830 (https://download.01.org/0day-ci/archive/20250831/202508310153.i186f6o5-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250831/202508310153.i186f6o5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508310153.i186f6o5-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/s390/mm/mmap.c: In function 'arch_pick_mmap_layout':
>> arch/s390/mm/mmap.c:187:44: warning: passing argument 2 of 'mmap_base' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      mm->mmap_base = mmap_base(random_factor, rlim_stack);
                                               ^~~~~~~~~~
   arch/s390/mm/mmap.c:50:26: note: expected 'struct rlimit *' but argument is of type 'const struct rlimit *'
              struct rlimit *rlim_stack)
              ~~~~~~~~~~~~~~~^~~~~~~~~~


vim +187 arch/s390/mm/mmap.c

9b11c7912d00d0 Martin Schwidefsky 2017-04-24  167  
6252d702c5311c Martin Schwidefsky 2008-02-09  168  /*
6252d702c5311c Martin Schwidefsky 2008-02-09  169   * This function, called very early during the creation of a new
6252d702c5311c Martin Schwidefsky 2008-02-09  170   * process VM image, sets up which VM layout function to use:
6252d702c5311c Martin Schwidefsky 2008-02-09  171   */
f547a726bf8dd8 Max Kellermann     2025-08-29  172  void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack)
6252d702c5311c Martin Schwidefsky 2008-02-09  173  {
8e89a356feb6f1 Kees Cook          2015-04-14  174  	unsigned long random_factor = 0UL;
8e89a356feb6f1 Kees Cook          2015-04-14  175  
8e89a356feb6f1 Kees Cook          2015-04-14  176  	if (current->flags & PF_RANDOMIZE)
2b68f6caeac271 Kees Cook          2015-04-14  177  		random_factor = arch_mmap_rnd();
8e89a356feb6f1 Kees Cook          2015-04-14  178  
6252d702c5311c Martin Schwidefsky 2008-02-09  179  	/*
6252d702c5311c Martin Schwidefsky 2008-02-09  180  	 * Fall back to the standard layout if the personality
6252d702c5311c Martin Schwidefsky 2008-02-09  181  	 * bit is set, or if the expected stack growth is unlimited:
6252d702c5311c Martin Schwidefsky 2008-02-09  182  	 */
8f2af155b51358 Kees Cook          2018-04-10  183  	if (mmap_is_legacy(rlim_stack)) {
8e89a356feb6f1 Kees Cook          2015-04-14  184  		mm->mmap_base = mmap_base_legacy(random_factor);
40ae96eabea408 Lorenzo Stoakes    2025-08-12  185  		mm_flags_clear(MMF_TOPDOWN, mm);
6252d702c5311c Martin Schwidefsky 2008-02-09  186  	} else {
8f2af155b51358 Kees Cook          2018-04-10 @187  		mm->mmap_base = mmap_base(random_factor, rlim_stack);
c52d638d6b5da2 Lorenzo Stoakes    2025-08-13  188  		mm_flags_set(MMF_TOPDOWN, mm);
6252d702c5311c Martin Schwidefsky 2008-02-09  189  	}
6252d702c5311c Martin Schwidefsky 2008-02-09  190  }
fd5d210fa66bee Anshuman Khandual  2022-07-11  191  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

