Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAE7FF60D0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C156B0098; Tue, 31 Mar 2026 04:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0CBA6B0099; Tue, 31 Mar 2026 04:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49FE6B009B; Tue, 31 Mar 2026 04:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93C256B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:49:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29E7E1B8811
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:49:48 +0000 (UTC)
X-FDA: 84605735256.03.2314B69
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3C4714000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:49:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ZZk/NHNk";
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774946986; a=rsa-sha256;
	cv=none;
	b=kVXEYMkT/K3sBoUh+HErV5wi6wdSNIgB76iL7EAUzs2ECrpTjvdD82gPnulHPLNDQTNFQs
	W+s4F4Ys/mrIViOV/jcfQ401cDrZhqRNtGxkih/un3uNoQ53NH/Bga5+CyLH54je9SfP4f
	PqZte/R+bD5Ss4cwVa2q+2NQ0s+H6/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774946986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ylwj5m6FghjB84mXTKNcHoRC2MN8ceAn6QL5hBDySUA=;
	b=X/54CRhuD9CEDw+RDF0wjYibaNCmYZEHEF4F3uB5UnIjOBySirWotUQrhr2P0elszMcGqu
	QwMqWo+dz83ZzhFGmlWroY876A2xILdAHuEikLXEFh2r2GoJ1i8x9KnGIscukuQCM0bsWM
	qPf+sJNKDAi4Qz6dl5spIIS6ACxYcPA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ZZk/NHNk";
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f1973455-6af0-448f-b657-274bbf64146b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774946983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ylwj5m6FghjB84mXTKNcHoRC2MN8ceAn6QL5hBDySUA=;
	b=ZZk/NHNk047P/vzjYveNrefMrYGdRud2b9vPCbkuxQN3D9DrSIjFOUUbzBTRsDW+pVUQlS
	prWk41QkBO89u5vWeoIKpNJfWcbuqivwxHTYn7KLlOk4VTNVpExSEx4hKTh45WaO8x27rf
	3b/j4t9xeVn1G08coiCsGW7ief9H56A=
Date: Tue, 31 Mar 2026 16:48:58 +0800
MIME-Version: 1.0
Subject: Re: [akpm-mm:mm-new 193/194] lib/alloc_tag.c:815:25: sparse: sparse:
 cast removes address space '__rcu' of expression
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202603291211.YhY0R0se-lkp@intel.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <202603291211.YhY0R0se-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C4714000A
X-Stat-Signature: iaji8sf6q7ajucbq9w3fy5zpizo745f8
X-HE-Tag: 1774946985-152024
X-HE-Meta: U2FsdGVkX19/OEYY5WC5KkUowtz4zlY3wqfSaRE48Eqguyi5MXPlVllnLGb4DIQ7PEGraCxwepKD7KsXpe6+WEK5BQPUPtlVVdKJ5koXRTakST2gGVBQZLKPPijlYzKQOWZZq3Vq1gC6jwPgvQgbPzcAhnzVZ/AtQg125Y7sBhUKLcDg3zjAwoitS/IiKOcz/ACnGJhW0KGKEfgYpQ1EnJ+XLfMyhoXtoSOaEV1+vOpzlR60EC57j5uJVufZdS5VacvXKkDeNhXSbIEOT+RM9BWlJvZ0oklasM1CFq3ZNWpQ6bdYnz0QyeD2jEK3bVt5lm3VTteMWCHCUqMYhe9LFEcwD8op+Lg+xfDY7jE5u9u9yUZ8vOAV0Ovw97EfLwaNrxVmw20SiWoPjujnElQZXhOhuWCB/VPymG+eqo4jq8Cc+muSyMa+Ka3il/AhHg4tcCXeUJ6wN5lxSD/jqJ7VhB8yKN+5mHBTT0qa9Wu0ciBlbdet70wB4isma7bKvVlVnKCf41HRE9T1Jq2/Z9iIai/59J4CrxZqIgqDXDvHp6bq+8O2FUG0F+bU/FF9HLNne8bl+wTfY6x+nd3Ok5P1zVPOcJZ9LRytboq/75noanoyIlcQbWwPl3x7muY5a1ulz7LNl6/WJ0vHfZp/ZXlvAFOWjU4Y5VsINCpzKNQ3/FIsvy/okIN2GKqafh9nhGRw7JunG8kf/rULitdDqrfXgxl6KIbE8v4jua6XY+NyEMrv+QErrfjghtkTjcuuR1rpGOO3hj9SXS5Kya9xEaYWNlOPE7lYM/6esi/v3zchOB9AFg/G+Xbpaikt/DgkYPeRvCH7At4Adw2FRXrIcLM41CHJDAtxAvJbThbAEhmeEZQ52bVLVEdualL1/trpbDqe1unmdMqBtJwmYIkkDTAZddWxTNDJOoX876ZlAT0uXGZr++uoGq0+V6Uxe1yhsdfdXDaexRQjZAZ2+whPG33
 j+4CJkcg
 dDZQXyA7ifXHIRrPG55HOFQ7yKd/lPQJbiqzVL3Oh5ZckDprO33rHUFMUB8wdUs68pviDLhTw/YbcEIfnE9ywN36+zYqQeVXs1rtm1605C2CvlW+Pgv92ri7A7F3Zyw+4l9EuETNu27Um6/20/kE8fJtk5Hu/FSX2eW6rirm4kg9LbNCY5LZi3imDgCDs7BWWkBkLTLGQCLFt/rTOoWeextekifLjGN7H3tOaFHWtdPeWFmlhRWdt1sSIOiurI+Ashqb0lApuZB5k7zy2s8QVmq8w4gafnmwGEJBk/LovCZrk0SOano54tUkg+qCt6zsRMTtRJWj0Q05DNLbUW6itlYu659FpCACUmtIO8fVCFa6y3Oc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi


On 2026/3/29 12:36, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   df2267b6380964f1305128001f05bc043ddf1f37
> commit: 8bee7b4b574f880ff2c7491212e2ef01cd82f2fd [193/194] mm/alloc_tag: clear codetag for pages allocated before page_ext initialization
> config: openrisc-randconfig-r121-20260329 (https://download.01.org/0day-ci/archive/20260329/202603291211.YhY0R0se-lkp@intel.com/config)
> compiler: or1k-linux-gcc (GCC) 10.5.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603291211.YhY0R0se-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603291211.YhY0R0se-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
>>> lib/alloc_tag.c:815:25: sparse: sparse: cast removes address space '__rcu' of expression
>>> lib/alloc_tag.c:815:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
>     lib/alloc_tag.c:815:25: sparse:    void ( [noderef] __rcu * )( ... )
>     lib/alloc_tag.c:815:25: sparse:    void ( * )( ... )
>     lib/alloc_tag.c:828:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
>     lib/alloc_tag.c:828:9: sparse:    void ( [noderef] __rcu * )( ... )
>     lib/alloc_tag.c:828:9: sparse:    void ( * )( ... )
>
> vim +/__rcu +815 lib/alloc_tag.c
>
>     802	
>     803	typedef void (*alloc_tag_add_func)(unsigned long pfn);
>     804	static alloc_tag_add_func __rcu alloc_tag_add_early_pfn_ptr __refdata =
>     805			__alloc_tag_add_early_pfn;
>     806	
>     807	void alloc_tag_add_early_pfn(unsigned long pfn)
>     808	{
>     809		alloc_tag_add_func alloc_tag_add;
>     810	
>     811		if (static_key_enabled(&mem_profiling_compressed))
>     812			return;
>     813	
>     814		rcu_read_lock();
>   > 815		alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
>     816		if (alloc_tag_add)
>     817			alloc_tag_add(pfn);
>     818		rcu_read_unlock();
>     819	}
>     820	
>
Thanks.

The v4 patch I've just posted has fixed the issue. Thanks for your report.


Thanks

Hao



