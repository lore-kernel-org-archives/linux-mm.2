Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909FFC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D30E8E0006; Tue, 22 Jul 2025 10:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA178E0001; Tue, 22 Jul 2025 10:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E78A8E0006; Tue, 22 Jul 2025 10:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8188E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:09:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5B0E1A0433
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:09:42 +0000 (UTC)
X-FDA: 83692083804.10.C9EAE47
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf18.hostedemail.com (Postfix) with ESMTP id 58BBF1C0013
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:09:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753193380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yec/i3cpv8jDD+Aiw5MbalAA0RWzNz+TxbPnIUIK+VU=;
	b=wKhVpCgOTf5ckToZj7oGgUYwZIFXAPqNc8MiwjD9uoOH7HrWrV+3y03GDnZLUVDAaapoHA
	HMKJyd8mq0l0Gq/k0nQceG2fWUwZgIEjYW/9TskeYWBoTM7+0N31RKIYkguOyjjqA9ttJ2
	K1UtNeKWDFUGytSl3tCFpAEq9I86uOg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753193380; a=rsa-sha256;
	cv=none;
	b=Z9OqOy1DELToqblyGR58FJOvenRX8dS+MXqXLFhH9FdcAlyqhm62PW7O+uKBWjhWRhViaw
	w1XamDy5C2aM8gkM43FvI5ClLUhoBB/ymyhZwNLLDmumgHUsDz+hY81ig4fB/3aD3zA/aj
	zLgG7SJHUh+GAxgr09v0HTrp7VHNUho=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 22 Jul 2025 23:09:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 22 Jul 2025 23:09:37 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org,
	oe-kbuild-all@lists.linux.dev, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aH+boS+lxLapI796@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-2-youngjun.park@lge.com>
 <202507171936.fGW4muEc-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202507171936.fGW4muEc-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 58BBF1C0013
X-Rspamd-Server: rspam06
X-Stat-Signature: fz18fkg8cntkoprss7m3nzpos6kby7ed
X-HE-Tag: 1753193380-519349
X-HE-Meta: U2FsdGVkX1+A84wI7b8qIrZb09CQ2+fccfePVapEvj3wtLpTRlyZyGY23aDbwfA4TBdJA9Q4A37I1YOwsHkQxZ3ZSgfmFoF9gRaqOjWng89UGR29ZxrtrlVc1yEdpkaOgYm3eGb3hJeC02/P49Cy/zLYXBK36C2r1hDMTRHf/QBG+eqBlITZmu1cDT9Cvnxu4JlOF4azj/gSeBK+th8FFPjvwhEQgNtp4R3uT9Xmg0hucLzRD5S0HbQc3BV+g/3FDiDuCPkGkuW2A77uv6kdh0YcDIruXF9EaUC6EwRTnXqW1phlHh1sQUFS1TiU5b7bcWbWzElbkEZRIoye4XDQtt3JP1C59W48yFdImcnz1riS7SATR0oczSGLArs84zryQboaOXvOmLSImObjwNbVFokph5HbvzBYxTWHUI3YDdfBVsFYJZMODPpu3LK1p+9lQDtHt/i5jRt0O6QZfR2ETCcVNxU81g1JqHDJDXIIVrUpqVhs01GmHEUewlbdgRd5IO2eCudpT9CKOXNpk8XUBrzOE/kEbNZ29WWtyMXx5TnhtYj6NMOS/y4eyZH3lbakwUhrkTMokLGk6Bzt/3PKrtq+TVr93MRG/XcRIPlQEpVLXlXrYj+ZSzFoR4lt8AO+q2kbEANtXZlZrzBbd/PzP1tlCwyircLXEsfeq4xNVw55ip4JhHEm2losBannQFJRBriwD6kHOokEpRvBXQLTjPUgt+w0pcGqsON6NZIiGJFyCtIMTE6kwawzjgsex/6g7xunSt39uFGvEyPKM1jA3nIRGSFPMlx8mBAyu4/Sso1AE96rm+p6CzKaIqFH+d7Va0LIFytzS+jttOxXbGF+8tDQdhI3utkE6eU0ASPf8k6ItkYgNo0AOIXic1dU1RVLGXyFVtvZtyCYoT8JL8wUXsAMueg+WOXuvo0hGoI9j/LSuj4QDXl+f5FVC3/YMvBn14wact6RwSELfDXCoa1
 31CMP9YJ
 1mB10t+Y44vEO6h7plEHVXur0ofcs8QZOa4G3p5Q+ncqaMDk9CyAvdmCqGDEIPQuNK1XSFHEQHe6tTv1QOAbheflrfEp9oh2FBObmwQelYPWm4dL5YmaRg5to+D2OCQG3O8rIS3QRaIoDyUql6LGhSIM51Amk95msxt+/9EBXlcXkrP0Z+7duSiGnoN/OSAt7MB+ta8NSdNBs7UMz+loLCUmvA/rcbqxVuQUa18lprpiIkPH2hx5N3+xsoRo+BtUf7MYiEACmuZxV9dNyZOlJYlOmhqhZzpSKGEXtmijU+oxOPbsJQ99OaY59hQQl60fpk+88laIvqeVR0ntEKAffcFVHxfoZqqa7GN3Z0s9ZHjIh1y8gzpixnsZV6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025 at 07:20:58PM +0800, kernel test robot wrote:
> Hi Youngjun,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on 347e9f5043c89695b01e66b3ed111755afcf1911]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-memcg-Introduce-infrastructure-for-cgroup-based-swap-priority/20250717-042648
> base:   347e9f5043c89695b01e66b3ed111755afcf1911
> patch link:    https://lore.kernel.org/r/20250716202006.3640584-2-youngjun.park%40lge.com
> patch subject: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for cgroup-based swap priority
> config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20250717/202507171936.fGW4muEc-lkp@intel.com/config)
> compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project 16534d19bf50bde879a83f0ae62875e2c5120e64)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250717/202507171936.fGW4muEc-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202507171936.fGW4muEc-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/memcontrol.c:5462:12: warning: variable 'id' is uninitialized when used here [-Wuninitialized]
>     5462 |                                 memcg, id, SWAP_PRIORITY_GLOBAL);
>          |                                        ^~
>    mm/memcontrol.c:5414:8: note: initialize the variable 'id' to silence this warning
>     5414 |         u64 id;
>          |               ^
>          |                = 0
>    1 warning generated.
> 
> 
> vim +/id +5462 mm/memcontrol.c
> 
>   5408	
>   5409	#ifdef CONFIG_SWAP_CGROUP_PRIORITY
>   5410	static ssize_t swap_cgroup_priority_write(struct kernfs_open_file *of,
>   5411						  char *buf, size_t nbytes, loff_t off)
>   5412	{
>   5413		struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>   5414		u64 id;
>   5415		int prio;
>   5416		int ret;
>   5417		char first_token[32];
>   5418		char second_token[32];
>   5419		char dummy[2];
>   5420		char *stripped_buf;
>   5421		int num_parsed;
>   5422	
>   5423		stripped_buf = strstrip(buf);
>   5424		num_parsed = sscanf(stripped_buf, "%31s %31s %1s", first_token,
>   5425				    second_token, dummy);
>   5426		if (num_parsed == 2) {
>   5427			if (strcmp(first_token, "default") == 0) {
>   5428				if (strcmp(second_token, "none") == 0)
>   5429					ret = apply_swap_cgroup_priority(
>   5430						memcg, DEFAULT_ID, SWAP_PRIORITY_GLOBAL);
>   5431				else if (strcmp(second_token, "disabled") == 0)
>   5432					ret = apply_swap_cgroup_priority(
>   5433						memcg, DEFAULT_ID, SWAP_PRIORITY_DISABLE);
>   5434				else
>   5435					ret = -EINVAL;
>   5436			} else {
>   5437				ret = kstrtoull(first_token, 10, &id);
>   5438				if (ret)
>   5439					return -EINVAL;
>   5440	
>   5441				if (strcmp(second_token, "none") == 0) {
>   5442					ret = apply_swap_cgroup_priority(
>   5443						memcg, id, SWAP_PRIORITY_GLOBAL);
>   5444				} else if (strcmp(second_token, "disabled") == 0) {
>   5445					ret = apply_swap_cgroup_priority(
>   5446						memcg, id, SWAP_PRIORITY_DISABLE);
>   5447				} else {
>   5448					ret = kstrtoint(second_token, 10, &prio);
>   5449					if (ret)
>   5450						return -EINVAL;
>   5451					if (prio == -1)
>   5452						return -EINVAL;
>   5453					else if (prio > SHRT_MAX || prio < SHRT_MIN)
>   5454						return -EINVAL;
>   5455					ret = apply_swap_cgroup_priority(memcg, id,
>   5456									 prio);
>   5457				}
>   5458			}
>   5459		} else if (num_parsed == 1) {
>   5460			if (strcmp(first_token, "none") == 0)
>   5461				ret = apply_swap_cgroup_priority(
> > 5462					memcg, id, SWAP_PRIORITY_GLOBAL);
>   5463			else if (strcmp(first_token, "disabled") == 0)
>   5464				ret = apply_swap_cgroup_priority(
>   5465					memcg, id, SWAP_PRIORITY_DISABLE);
>   5466			else
>   5467				ret = -EINVAL;
>   5468		} else {
>   5469			return -EINVAL;
>   5470		}
>   5471	
>   5472		if (ret)
>   5473			return ret;
>   5474	
>   5475		return nbytes;
>   5476	}
>   5477	

This is an initialization bug where the "default" value may not be handled
correctly in certain cases, such as:

  e.g. echo none > memory.swap.priority

I should have checked this more carefully. I will fix the issue and add
a test case in the next patch revision.

Best regards,
Youngjun Park

