Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B29E92716
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 22:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179846B0005; Sat, 27 Dec 2025 17:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD626B0089; Sat, 27 Dec 2025 17:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002396B008A; Sat, 27 Dec 2025 17:12:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3D1F6B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 17:12:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 835C762CB7
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 22:12:16 +0000 (UTC)
X-FDA: 84266650272.10.B95EC0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id ED4EC40004
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 22:12:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="svlL/IHA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766873535; a=rsa-sha256;
	cv=none;
	b=Gzsl3R50d3i8z31PxueFdL+Dr8CSzvwlEWkc53UwiE0GBvlMjCeCJpizH0YQgAGaiJKqnK
	EqYnXeduXUyjOcy/2DkOmR1/LVodt/Tqh6l+A+V0pwxuN4IIC58x+5C80MB1xZXcslh1ZT
	x83ZEwxsMVboFA2QEZSKzypvwL+bShk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="svlL/IHA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766873535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuU7xVJ5TKKNvcUfBXSSwYZs3ARkGYWTcksgRApSaOE=;
	b=Dacm9q3mNCFWoK0ZUBlyj5UGXuIPZqknWoxqRvW4846lyrFTlPVlkoe1k6gY/iYasJ6zoZ
	inq7kGvgJB3Kqi22UJDSFJOwMbubX7JWXylbqjLrEBFZiMlzzSZr79PlBdVrDNnyPa7PSw
	ghXogz821VgxEfKIYbq2/aVj7qQchis=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF167404E1;
	Sat, 27 Dec 2025 22:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F66C4CEF1;
	Sat, 27 Dec 2025 22:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766873533;
	bh=VOh/YL2n8G3f+/QICIKeFajquKb19s2MloMaGXxPaq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svlL/IHAsDuzcsygJQQL6bqUfHBQ8mf1KQDuQC628cQfUO5fgZbkggax/Xp9mYZxf
	 /kGaXzp7Xi8L17G7bpdrQUyIwYnJnS1PrAG2EIXZ/q8VVU9pZiUyEewb5inI0uroUL
	 fqOcS9lBr1s5tC/cZup5FFUXo6EsH0iiXUK09Riavai75+mTex0/z63bVZhZ8qEv+L
	 uzTkoHX9qPbbm5uy2h0dx92dZDtRFCdpXX/UQ86wpLAXqmy+8+QEUMqneU53wGsRMm
	 sQaNgp5O3D2u6GzM1hJwKJ7aHNxJP+BFESWpcHumR8vRGAzb6Z/eQBktZgXH3E3fq0
	 s4fut9++L5D9A==
From: SeongJae Park <sj@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Date: Sat, 27 Dec 2025 14:12:05 -0800
Message-ID: <20251227221206.282703-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202512262045.CkWwCNp7-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED4EC40004
X-Stat-Signature: b4orjymu9htdin3aucc6788mkrx8tsbh
X-Rspam-User: 
X-HE-Tag: 1766873534-259249
X-HE-Meta: U2FsdGVkX18pBHktIIMuaYibncLcFYl3wC8deM7P8m+dlOHG3YDjYYygx8FMtRQLlh4H91VxwnhqHA2St25Gh+//1MyuJWUf/A6ynwekSqgwxT8kMkjTPoCi3KDQ1bvCCpbfFWJAOC4RkD3yjSpLn2RZr5mvsVXLDLrH6hisE8MXXb1w6y28XfxpMv/Il/k2h8y9z+gH2cTLuRGeaPN5iYqLhvQxs25sA6p2efo+GTugOfnt/t37Q3BP6JR/YMXzaUtuHIaPjOlD1NW8D9Bj4Rk2vGeTixqXlAPFZYGVX+qH+VxNh1FxKcbnrpMKLmSo6NDhRrQXbsQyNTbWeauB7OqBnHKDmTU0iZpPozcMQq7T1sVaBanvG14O5O5pIObH5u9Ro5Sn281pwPlAKkz1vkEmHMIYOlGkhFuv5JpBAFT4MB0OXS9Mt70UTVkWLDepPm3aNTrzEOwGzWAls5++xPqQVU5ibjIfuEiO+jB/Da7707/MI7C7odAPtdLnUTRhBL4+Sjx3Iyg7cVwhMmUmwJAIGHyimWqrR/arLyRT5Vj7npPaoEPPiej7xVQi6oP4Erz4AB06Qwi6foXVjv7EwsnpmtpG4RgykSeSgkELyR3BMHLLLWkU6Fr2my6Fe4azsscnMI/jQUI57ltZQbMO2xQhbuqnZ3UnXnddeetd4ZnwjlRi2MufhFK8NDIEWEhxzPWW11EVhfuFjuL/xTY3Ix3cB99ocqSBYkFGwBql5I2qEhRgzxfmg37tdrSWXkRWDpusNZB20zUpXig8b8a+2FJjviP6HWit+ADqoswndF8dC+kTYXInQuYeqbm+vqa5q7BwJX0LAuAOqNnk22N6FwYrOlmoqyw0YXiKo/MCAVnCYeiZog/s/5tGUKOyQxcxQejDXM7/UD9heCB1o7otUS2k1CuVSg8NMenr1k5FPe3pGqoJQMOFV5k9cGVHMtwpFzEVyqV4J34cAveQX8y
 P3DjGUwD
 M6XHC0T4VAkHqMmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 20:31:38 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Shakeel,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on sj/damon/next]
> [cannot apply to akpm-mm/mm-everything tj-cgroup/for-next linus/master v6.19-rc2 next-20251219]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Shakeel-Butt/memcg-introduce-private-id-API-for-in-kernel-users/20251226-072954
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next

damon/next tree contains some debugging-purpose only changes that not aim to be
upstreamed.

> patch link:    https://lore.kernel.org/r/20251225232116.294540-9-shakeel.butt%40linux.dev
> patch subject: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
> config: arm64-randconfig-001-20251226 (https://download.01.org/0day-ci/archive/20251226/202512262045.CkWwCNp7-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251226/202512262045.CkWwCNp7-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512262045.CkWwCNp7-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/damon/sysfs.c:2704:33: warning: format specifies type 'unsigned int' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
>     2704 |                 pr_info("id: %u, path: %s\n", mem_cgroup_id(memcg), path);
>          |                              ~~               ^~~~~~~~~~~~~~~~~~~~
>          |                              %llu

And this issue happens due to a damon/next chage that made for only debugging
and thus not aiming to be upstreamed.  Hence, no action from Shakeel is needed.

I will resolve this issue after this patch is added to damon/next.


Thanks,
SJ

[...]

