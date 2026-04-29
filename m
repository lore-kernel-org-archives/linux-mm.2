Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45FFAFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8409F6B0088; Wed, 29 Apr 2026 04:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1EE6B008A; Wed, 29 Apr 2026 04:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706A16B008C; Wed, 29 Apr 2026 04:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB6F6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:28:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A89781BA121
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:28:30 +0000 (UTC)
X-FDA: 84710916780.17.4EEAD4D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id D3CDB40008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:28:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bI9NqMP9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777451308; a=rsa-sha256;
	cv=none;
	b=osQ4NADV6DIh8LITJXAJgk3yBZnWfv+NhFe5WokzFpT2iP/kbLbm7eLR3s/nx22CnnvDjx
	P8VIVEXapLZz7DJY2oSQduKCmqDMQEDi7CByT4vt50k40c5pZYDu1nbDZ6JzznzKSCzmeS
	i6jm56lXjqDk12wLmIvqL88YYWbllSY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bI9NqMP9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777451308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8m+8sVnmaYHkTa9+PFXFunu3jSY1eXSkR2qKEpxhJOs=;
	b=3U2nKJl3xfyP3/171uDGh/gtbYRvuXjFFHMlec7oE7mde/8K+mnDUPxx50MqFe3NWOUB40
	RzElkCby1d2OG2mOxq/4jOeLrxOG4/0HZSExFGZdpiADWnYePL5U6h3xkrY5+kAG0zVrOS
	xwcR9AAGiKT4sFXMlySXZpnOPHf1SBc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777451308; x=1808987308;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cOxa4CgWhjet1z2EeEEdLVqhmu6YFrkVnG4ZICWRr0M=;
  b=bI9NqMP9hWMJ9N2drZ1XYGth0GXh5dtF9A6zro4K3PtrGkMQjHdeanEv
   PY+6QWgs06a+6Y/gN2hJ4XOQTTCzlMnuX99yE3FKRtIBRpy66DG486lRl
   wQmDMgtycrtqAVX3cm2A8vlY3E1XrHIEeg0CH/uq6F+K/jp7eKPCz4/rS
   Ofuka2bO7v43RT+BLjVYfWXhaVB8ohJDPKtigOyt6AqDODg9pcp9twHn7
   nuYuaB+ktxvMbrPexZJZ2jrL//c4yQSeiaTtj1sCKYVEqoP5BlcHfI9PQ
   ty6GHswpOQ19ZLoMn5PRS60OVajYpKQWN+m2D9V0FRAK1PXoiJP9Be2JI
   w==;
X-CSE-ConnectionGUID: YX5CQjaQSKqjuu9G9h6iZg==
X-CSE-MsgGUID: txKzh3yqTlyVkMZoRGzOMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11770"; a="65905228"
X-IronPort-AV: E=Sophos;i="6.23,205,1770624000"; 
   d="scan'208";a="65905228"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 01:28:26 -0700
X-CSE-ConnectionGUID: 8mkmh+WgT9iotp82+uPsdQ==
X-CSE-MsgGUID: XnmKZAYmTgyF33Wn7Sdevg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,205,1770624000"; 
   d="scan'208";a="227692057"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 29 Apr 2026 01:28:24 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wI0HM-00000000Ap2-3WbZ;
	Wed, 29 Apr 2026 08:28:20 +0000
Date: Wed, 29 Apr 2026 16:27:32 +0800
From: kernel test robot <lkp@intel.com>
To: Christian Brauner <brauner@kernel.org>, Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
Message-ID: <202604291646.noNYgx5i-lkp@intel.com>
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
X-Stat-Signature: ip9osax3i73hhsmka6pd7rordo6zf9cs
X-Rspam-User: 
X-Rspamd-Queue-Id: D3CDB40008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777451307-428983
X-HE-Meta: U2FsdGVkX1+S/aNfDGT2CdbBCsQYBwJyd0xWH46oHQQ72jOWlmDL53VExQZd1Gf9ZqXhkBz0e4sCErxJVJ97dOEt7osE6/OjT4/dnXdI+g5Q+3E/IWwnQvD/DdqLuXtbj8eTTftkSfkoGCGT6QFNEJ6kJTATzwxixT7mXIhxyNP4HQlecnkl/oXTWf2RA8YdxiR9JMMzz93qrNGtMdiPeuNmEzMWdBK4YRVhWZdkboBDqAyIUfU8DMVe+2anGk7wh2wTIeM41OydIyOIgwHwK0Q2uOfGxKUHpSytEaAZnj0Hq7l+XhB5lBh2sJiQb1meBDlRVpzIqvAJg93nhDepsjdW7jm+4803zGXT0UaEsMZSBqi293j8rN1f8PDs+DMr3v4E74LX1ERGo76cJG7eqbPeKjc0U/GzO9aoHC6uhmXhqBYYJhZnydchBklzt9JWogjHISCnfhemMer5yqaUZdPrmytEtrTW9w650SjAWHNBa8L+1YZIUCoF9YGIyoIefHZ9G9hrfm25pY2mx4K/UbA8T7P2BwSu9qITFc9cWHMnmy67vvutM9WVl0tHxcvgZIVGZ65SygRdVGB/vVlJXbjeKvM/eJIgYP1LMuvOgIUa8EgZQANE8W2mZs9Qy3jLThFs9BYtI11tUntvznpVgCWxGfZ9dv2pEnENLyRAb8fKtnnMx5+rJK3qbNLg2kJ09VMI2DW8h2wga4AB3HHbp6w4jCn4Rw0WuEY3ZonKO3kO8OqiqSoLKxOXMHTbz5UTLwUlKNlLpd/1fuhhNkXjDednmz0J5PlPKoIiZ1vjMPgIVFGGFUpcVguiKJag4pK3ofYtkcYh8G/3yiUV+ujQhUjjJSVXy2wcvI2Xo4dyTuEZVShmhhvD1VUsCkHwmQiSI1zUoqGfljesjF8C8KrPLj0KC5SHcFLUyxc1GCYyWcxGvfN9gIvt27rTptcKnPfia7c7N8XHturbXIviNHx
 GF1N67US
 iErEOWsSuJ8p/wb8E3sjT4OzddFaLugiobDRWmiWXpD96b+VAH7nC5yYc1WUfAlvfH03H3f2Bn5ZHt0n4pemkCMWkB4Ekq5jKZSghBhU4V1ldho/3xJHaJB6HSwoGhCGzkVu0FlxBEYR+UiKb4ghfW5paIWB0BJmjnCx+yfNJmpVe6PcJJwcW88LU3FWgmQW44KGdbHm4Vgy0ADh0DuSIQO14mXNzEF7PtpUWTmEfw5x/w+OXVe9amGoHFNyPVxe3WM9efyH73qZDxPfmQ3ey2hyb02I5etYAyWJUQ20mrScO+Fo+uRf9gXi+Tmd5DqOupIHj+06XXt8baiD1ZIRf3Aq8Eg72m1rv3ezRyaRrLot8dzNRNOvoRAhleBnUh7EC6oiiH21oIv7Po+GDzAKyMnXKar7FCez/iDr83XZ3ck42A24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6596a02b207886e9e00bb0161c7fd59fea53c081]

url:    https://github.com/intel-lab-lkp/linux/commits/Christian-Brauner/rhashtable-give-each-instance-its-own-lockdep-class/20260428-182539
base:   6596a02b207886e9e00bb0161c7fd59fea53c081
patch link:    https://lore.kernel.org/r/20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2%40kernel.org
patch subject: [PATCH] rhashtable: give each instance its own lockdep class
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260429/202604291646.noNYgx5i-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260429/202604291646.noNYgx5i-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604291646.noNYgx5i-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: lib/rhashtable.c:1030 function parameter 'key' not described in '__rhashtable_init'
>> Warning: lib/rhashtable.c:1030 expecting prototype for rhashtable_init(). Prototype was for __rhashtable_init() instead
>> Warning: lib/rhashtable.c:1104 function parameter 'key' not described in '__rhltable_init'
>> Warning: lib/rhashtable.c:1104 expecting prototype for rhltable_init(). Prototype was for __rhltable_init() instead

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

