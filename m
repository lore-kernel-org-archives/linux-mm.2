Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB95FCA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3263B8E0009; Wed,  3 Sep 2025 06:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7578E0001; Wed,  3 Sep 2025 06:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7D98E0009; Wed,  3 Sep 2025 06:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1BE8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:16:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A84B2119E44
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:16:50 +0000 (UTC)
X-FDA: 83847535380.19.37C143F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4FB7720005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:16:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NRJqWy2O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MmOqhnZD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pd2RLM2f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JThfl9co;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756894608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rvbu/jM3MWKUIPJPhYZELsI7iy4dSk0i6DfRhasd5mw=;
	b=N2XBMnzDnKGCunKiO0JJkAB4T5do/S9fR5VqCSAzfygdrr7/PL/X0/Kmp0yZJiZDPs34SB
	61Mvkv32akuf3LnrIeQjrcvqMxMFfbsVMyFbuzYOyEU07YTrC1rGJh6YmOtDPjf9sHC4ix
	3tMLzXIS+U/2MoSYp1X1ycyTXA7uaVU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NRJqWy2O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MmOqhnZD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pd2RLM2f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JThfl9co;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756894608; a=rsa-sha256;
	cv=none;
	b=pl3a/d/I6o5E7WeRCrle/y1yQYFhrFDmVDO8h6lvaE5dMiOhukKIYL4R6CldCVARgy7Uil
	Chs4E+7KQb3TEn2195XcM5e3JEM1bGfTCSKx5h/Wxjjoag5+nZ+hYuvx1zQXqy30PG6f2a
	gJsgzIz2nfplTo/zh3q11IA/k4NPIGI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D433A1F456;
	Wed,  3 Sep 2025 10:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756894606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rvbu/jM3MWKUIPJPhYZELsI7iy4dSk0i6DfRhasd5mw=;
	b=NRJqWy2OAzMVfAvO/FglkVKF6nj1+/m4L8ngdXC3kGDFYNgHxZ54yHpg41iLhYS3enQsi8
	phAxgf7pIZdrbYpOY6cheeAnaCKy/fpitFAPDicU6EqNEJ9flKl6V+2w9tOAEi6lLYlIE4
	yRlIoOFNUE6/w8EHA/80oJZakxYu7Sc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756894606;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rvbu/jM3MWKUIPJPhYZELsI7iy4dSk0i6DfRhasd5mw=;
	b=MmOqhnZDsS+Dw1rQ0m2lOxYacrLtwq4UZS/57btWB6jyBmSfpVLwAPHcrRrPlaYJ36hj/r
	St5IdAZ9Z+K/E0Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756894605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rvbu/jM3MWKUIPJPhYZELsI7iy4dSk0i6DfRhasd5mw=;
	b=Pd2RLM2fN9EOFy5KvDBDYtDC4HMdjXX2cfVMv6bs9bQl+hI2z94sCqYlj1mSe8HqdIwgAT
	Xxq0C5blRDVbygHaFsiOBmo9KNn/FGZDCHhrdFmFGbW5j7eXsexrtqoK8s/2cRtHQw2hyP
	Ib+iEk+9ch44eVULObDy6Lqr3qyNegM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756894605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rvbu/jM3MWKUIPJPhYZELsI7iy4dSk0i6DfRhasd5mw=;
	b=JThfl9cowFhidj+RhH2CYaaqUA2m0CO2ExgZKUbiIK/sb7b7pcy0spTHxmZsEWuNZb0i4P
	OWSnJ+8mtweMVxDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC1D713A31;
	Wed,  3 Sep 2025 10:16:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id X7UJKY0VuGiIAgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 10:16:45 +0000
Message-ID: <c41c82f0-e5c3-4c2e-b711-3ddf8fcb0135@suse.cz>
Date: Wed, 3 Sep 2025 12:16:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, Yueyang Pan <pyyjason@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>, kernel-team@meta.com,
 linux-kernel@vger.kernel.org
References: <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
 <202509031744.HcibSETe-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202509031744.HcibSETe-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4FB7720005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9ibrxsfgfoxw6e1f81rps5cyz1gnstkg
X-HE-Tag: 1756894608-737107
X-HE-Meta: U2FsdGVkX1+Zexf0v5s75l2Ylsisrlu8wW8lTXeecCquLqGhXDX/245/0ndRt2aH2b6XkWvOtkSMWTEfhaWcQ38a6a7A9axH/CEn/HtcSpYZVaV11XNrEwjWSTFspB07if0ZCtTxnAd6CsnvXT8sTZ1rzOrApOOCtctRfmEhWB1XkorvO9LXNBdCg7gWbpIrUJjugZVRt0hXeJAC5uxXcn7a3c/yGnnO3YF7duRi0oD4CH6r5FB8CzAimC/X/ZepyAN5MBgkjPAUbsE+yyo40rzErKbHe8inbvvx88mElrMgIaDXUbm6cxEgZF6jMroRTULg3kGDu1YEDVP08cKmoRQt1//62fNoU1prpEHk8zHtlOOwu1jn4Ut0pYjAWfpruokvq+I16F43gt5QM8PSPG8p1YJjCD6MBg65l5rDPQM7HywG3inveStFOf58WhOcJfTN2SNs10/ecb3IyVNo/KWgTTue58fNRgsTgEIFN7HFwsB5FitS5uW0iQL9JEgnVo9XwPQqw0PnhYPw0+9nd9Fft7CWBDOwMR5TTx+slWYYxHg5sZyKCQwRumZruyf4tIfqUOgkfSHOCPBDFmb4ULylPqL2WrRNXzo0AV4UOQCsq5GTBRXhZq8Yf8BSpyqt0T4FN1Oc0Qvv4nzoaT67mimsehoS+IXkceAiwqjTBCwohZXB9RgrHNMeS+Dk/8g6hk9I8E/OofJxVDvS+1k9D8XG6BcJHM+w+6WiehKeLLBPooob6r9STF0jATucXUYkXuxn3yqeRYHHISrht1B+nIi5FPM3POoH4jeE548YHjkHzVpNUkfYLAPQjaO957AiDkNfFEmDIE50Db8gdqxORleST613QPqgjsHnxx4aa9qSJx4sSjHRBTFqNgl6piotYa3NQKk1KvcOLxOjuBLslhpJ61rn7iBwatPs7bTbf1kGu1iVEl2bmgoIL7yJ1YZDLAuClPnswLBCOvZcl99
 9n6YjqPy
 dYj26PjbjAX8OFjm/LItICwYkXI+CdhYV3ZTQbN0oKN46W7SE7wgt7E2PA1sXWCwutn6+LZNXYK6wOH7qbm3LozEpX7fiD/XByE3aC4uLvDCWLxcaQS4Wll4sRIP+Cci9DPuXVfBEJ0T2g2VUv6mpJVmRq7Ywb5NpqUGPUi9jShVLAdULewSpB6pNV0Nm69bGRsIXDgJBc028qwlV58Coa9wOgxGyD1d1LMsUYWLWzcwAX87h8ThQmE/u3aJF6HZJYyFPRX5D7vkbYVpaz4yus18d8PcpkIq0vZnC/w30iZNA308LxZDKHJ48LspuvfuCssF4O7YfnV+87qXR+a1xmImV5hKGb68dBqhgQo+TQPHac1OkMakJ8Qb0fmixb8vHf91zpU/TqbngC7EqV7JH6DI4URhv3/yaYqqsHfOrni76MCHqHyFmF8+KLom47537jW/RZ+lhmhuUvYmhVFz4rZLosAepRUQpH575fQ5VvUNm3akN3UxyIVdkQlEHBP7g/CuWz2KtM7JE9x/hQ+wOrjTfGQZLQSD2MpsYfmkA5jvvmDvBQwhqnbdNfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/25 11:47, kernel test robot wrote:
> Hi Yueyang,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Yueyang-Pan/mm-show_mem-Dump-the-status-of-the-mem-alloc-profiling-before-printing/20250903-000616
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason%40gmail.com
> patch subject: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
> config: i386-buildonly-randconfig-001-20250903 (https://download.01.org/0day-ci/archive/20250903/202509031744.HcibSETe-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509031744.HcibSETe-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509031744.HcibSETe-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from mm/show_mem.c:18:
>    mm/show_mem.c: In function 'show_free_areas':
>    mm/show_mem.c:336:49: error: 'NR_ZSPAGES' undeclared (first use in this function); did you mean 'NR_STATS'?
>      336 |                         K(zone_page_state(zone, NR_ZSPAGES)),
>          |                                                 ^~~~~~~~~~

This is from a different patch and being fixed. Interesting that lkp will
report additional warnings even in presence of prior errors.

>    mm/internal.h:560:16: note: in definition of macro 'K'
>      560 | #define K(x) ((x) << (PAGE_SHIFT-10))
>          |                ^
>    include/linux/printk.h:512:26: note: in expansion of macro 'printk_index_wrap'
>      512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
>          |                          ^~~~~~~~~~~~~~~~~
>    mm/show_mem.c:298:17: note: in expansion of macro 'printk'
>      298 |                 printk(KERN_CONT
>          |                 ^~~~~~
>    mm/show_mem.c:336:49: note: each undeclared identifier is reported only once for each function it appears in
>      336 |                         K(zone_page_state(zone, NR_ZSPAGES)),
>          |                                                 ^~~~~~~~~~
>    mm/internal.h:560:16: note: in definition of macro 'K'
>      560 | #define K(x) ((x) << (PAGE_SHIFT-10))
>          |                ^
>    include/linux/printk.h:512:26: note: in expansion of macro 'printk_index_wrap'
>      512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
>          |                          ^~~~~~~~~~~~~~~~~
>    mm/show_mem.c:298:17: note: in expansion of macro 'printk'
>      298 |                 printk(KERN_CONT
>          |                 ^~~~~~
>    In file included from include/linux/spinlock.h:89,
>                     from include/linux/wait.h:9,
>                     from include/linux/wait_bit.h:8,
>                     from include/linux/fs.h:7,
>                     from include/linux/highmem.h:5,
>                     from include/linux/bvec.h:10,
>                     from include/linux/blk_types.h:10,
>                     from include/linux/blkdev.h:9,
>                     from mm/show_mem.c:8:
>    mm/show_mem.c: In function '__show_mem':
>>> mm/show_mem.c:399:32: warning: unused variable 'mem_alloc_profiling_spinlock' [-Wunused-variable]
>      399 |         static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);

This is the warning

I think you can simply move the definition to the existing #ifdef
CONFIG_MEM_ALLOC_PROFILING block above the spin_trylock(). The kernel now
uses a new enough C standard to allow this and not only at the beginning of
a cuntion. While not encouraged to do that in general, this seems to be a
valid use case.


>          |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/spinlock_types.h:43:44: note: in definition of macro 'DEFINE_SPINLOCK'
>       43 | #define DEFINE_SPINLOCK(x)      spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
>          |                                            ^
> 
> 
> vim +/mem_alloc_profiling_spinlock +399 mm/show_mem.c
> 
>    396	
>    397	void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>    398	{
>  > 399		static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
> 


