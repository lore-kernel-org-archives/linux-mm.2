Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC910C982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 03:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E304B6B0088; Wed, 23 Sep 2026 23:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0CC6B008A; Wed, 23 Sep 2026 23:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9336B008C; Wed, 23 Sep 2026 23:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4F2A6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:55:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F07B1C1115
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:55:57 +0000 (UTC)
X-FDA: 85247292354.22.52C4DFC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7DEE160005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:55:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZyaKOwnK;
	spf=pass (imf08.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790222155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=SovLuJiXFuQD7/NgHVQy8LgeEfkqu0F0q6QOnSFE9YE=;
	b=rTOamNaekxvgwbaInwn32Jb6oB+pZ0NOVOa/o5g82UIJMesIDJBvrj/l9W20ZX5nWwra3L
	Xvw/19V1QjD4/Rlx7puSjzBAK/huGe3SlTNTsr0tgYPT/4CyFvaqutNU8hH7+ntw8Jjwl2
	TKDY8PI21jp0zYdFrHQqRjvBsSn67cA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZyaKOwnK;
	spf=pass (imf08.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790222155;
	b=3yTE1IYxJf9D3aqEc4M3HP2FUkLs1vktdEatfxJ4nxeefSz4Oe2SDj5+UNVuM+/lQC3mnD
	nlPEqgU1mx6hxHIvf/ocArCkEBSSOwuBnLZBv62bBVfIhZiulUrVnX4ewHKglPkvhrs4SM
	WzuhGu+fvWKDnnIbDJfSPsPJEouEhJI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790222155; x=1821758155;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=lzlSPTzlh/Y5qjIW/JUnZhJwQdNHGCW9Q33UHnVlrS4=;
  b=ZyaKOwnKVnH8KU4USggQzkghFBgPf6KqCR7rDwxUYaAKoSzr82rhBELZ
   o0OM+xcoyEEfhc7NQDtMygeKnONAE1fGvtEn32l++4mJfJ1uU9BH1o9Gs
   1ve4UdjqdX4Ufr2fLi90Ih4GJoYNCpZb+Tl0LrgwMMiIV1aal4r+7KBv9
   dXarDIturR5oSyRr6WGIdGUfGe+yWjC09+FxWwzAjh01Vw59/YgIwWcoT
   at1L+AMZraNxR8DIYdD7Me6wWQoINvPMwYGUipaCktW0zSlzOVWXujzVp
   FR95qwBx2u1K+anK59H4E+pq9Zo6DezPJPbp3xl9/bnfeizOSBtxxDUon
   w==;
X-CSE-ConnectionGUID: Q0Rp2ejMQoWc2+Ldn2FG/A==
X-CSE-MsgGUID: 07GKQidcQnCf0Yd/nUPlJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="91087216"
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="91087216"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 20:55:53 -0700
X-CSE-ConnectionGUID: 6IppWfUsRoKkrEUti05hiA==
X-CSE-MsgGUID: FU/g7o9gQVqhsp1vb3mJVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="273381451"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 20:55:50 -0700
Date: Thu, 24 Sep 2026 11:55:47 +0800
From: kernel test robot <yi1.lai@intel.com>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Hyunwoo Kim <imv4bel@gmail.com>,
	linux-mm@kvack.org, Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-kernel@vger.kernel.org, yi1.lai@intel.com
Subject: Re: [PATCH v3] mm/slab: take n->list_lock in
 __slab_try_return_freelist() to avoid race
Message-ID: <202609240534.9fe4984a-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903-slab-fix-aba-v3-1-b44cb6badd54@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7DEE160005
X-Stat-Signature: 5fpdj5i6uirwbnxpgazaqbdggs3bmypr
X-HE-Tag: 1790222154-134402
X-HE-Meta: U2FsdGVkX18KbvR2EJUGOfyvDJVeTQmwHMDgdE8qyAj229YdXcWZ/3/QVmxRNhKWk9J8/SZwLHCI32pG+MpC4kt+pqZTgxy2QawEmdEEnpLlspKj1PYOlD4jg63+e4FsQMpBQ1Q/gRfMo6XDSmQAEM7TMi4u6dJPofjbWPlw8dRlON1F8IXVaMI7J08VVkHJTvoZKvPAeOmZXPbBxjMQfDLQjd6g5Hha4Hjaq77YApXKDdHLYFKC16QpacpWiIUPKwXc83LeEUlo5rF4vQZDxcwj8Ze08ZrrUUxSfPcVvRyRa7HqG8ZM9qLi+qxYKlOkmGkbXSjD3I88mntUo/HTjRIdfEOyLSjtjPcBMQiSBvtCkfObd2S+WU0nAyYRQW5mL4untXp2zkHJeYSPcSYnfgqWf+3YrS7HUirdZhe0UgwKT5syyWIcPx6zBI7YB2j1J/0cVoIF63a9xIWjRSQ9w1bePOe5HvzdeMiqDlF78hDphqmobyX6TL/1dZwH5rJIOJ7QhMb1qnL7yTV1l/GVujmXem3WPxzu2G809hUnN45pBUp6mbuJ40/MpE4eEJb0vQZZuzab5nojqTAvkcltB5U2dXpw0Ybp4uMOjLgHYe6j6uayXEORGKIMegP7kfvmyoSw7v9wnrSimm5ACvJ+xu5bXmzreZWt9tIAVtgxwBPg9BUiQ4Fatrs9VcxEBBX5MLtOdWeC6IGDIFicoZv8l3z9aR4odm81f8EPu7EV2G8mvo9LVZ12fp8FjrYLlXh/Nq93V3Fv+ZVzVI0y3t3FxEyCjpQK2HhH9N3/JY1nTODyPVpKeqdhEb9go4OXR9EfceunkODKpP/tm/yrbCs687KWLPMnyF5crftxqgdGcqGcdPytYbHNWWPUQaIdpnVBpnKR+cCMrtwOvKbpQMkTR7J8NlQ7Gz5CupLqnDvCJH363yKS/B2YuLXZlhxhQ0Dmi8ZwS1bfvi0PucRw70j
 CCfE7P3L
 7R4g7M2meF9G8Wp1gL6hnBmwCTvztT5Wrg2xFYq9vRCfozEsfG+0Uy/e0PpNKWCHN6blSAEh06t6Ucmxbj0RfWf7I+Y9jCr76gpmYu5Pexq/f18sSlKRZc3wnxiaFO/s8ZqquY6qxWgmy6OnmylV5UH+Vvvt5t+J6nhgODGREdCc8NksuhoFgPWHViRiyxNCCsMRAxc5Qcm4Cd+L/kHkchQ/joZyh7/I5pZX4lp9hU5cpTVnhYFwel9QolW+aKpXtbkXYmrYFhFU95OTQEOuHbIRlI1Bv7kuYesdo9oL1oh27l3J6d1IYnvhiomM/SBnPrLgkD5AVUq20s3PMjdiC0i8sDChNnE1bNhJatQXzGIAY4h6YeaH47K1ncQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

kernel test robot noticed a 2.3% regression of stress-ng.pagemove.page_remaps_per_sec on:


commit: 710555228bde64392410a9e8959d0324c1a0a598 ("[PATCH v3] mm/slab: take n->list_lock in __slab_try_return_freelist() to avoid race")
url: https://github.com/intel-lab-lkp/linux/commits/Harry-Yoo-Meta/mm-slab-take-n-list_lock-in-__slab_try_return_freelist-to-avoid-race/20260903-153226
patch link: https://lore.kernel.org/all/20260903-slab-fix-aba-v3-1-b44cb6badd54@kernel.org/
patch subject: [PATCH v3] mm/slab: take n->list_lock in __slab_try_return_freelist() to avoid race

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: pagemove
	cpufreq_governor: performance

If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202609240534.9fe4984a-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260924/202609240534.9fe4984a-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/igk-srf-2sp3/pagemove/stress-ng/60s

commit: 
  v7.3-rc1
  710555228b ("[PATCH v3] mm/slab: take n->list_lock in __slab_try_return_freelist() to avoid race")

        v7.3-rc1 710555228bde64392410a9e8959
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  74699042            -2.5%   72797565        stress-ng.pagemove.ops
   1245981            -2.5%    1214288        stress-ng.pagemove.ops_per_sec
    291125            -2.3%     284309        stress-ng.pagemove.page_remaps_per_sec


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


