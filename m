Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C269D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 18:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD6C6B0088; Sun, 11 Jan 2026 13:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AD66B0089; Sun, 11 Jan 2026 13:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FD56B008A; Sun, 11 Jan 2026 13:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60EF16B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:37:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13469140D1F
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 18:37:03 +0000 (UTC)
X-FDA: 84320539926.24.E594952
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47166A0011
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 18:37:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D75qwCAk;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768156621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzQkztuX7VSyZNlCSHEfhfVSo/V+ipxDtnnVBaF9Y2o=;
	b=XXxvN7ETY0wdwZM7+Mv/vK71ASmM/hpMCF4wCW8XChB0M2TnmsXXZv3f6WaHQe08CR1U7V
	Bi/4h8JxNNrxi9gJDYMtBvobJn7dm7o0G9f6y1o9R03JA5nfOhOcp2ICuSGmv/iKh5f290
	kfG40SD/aSklsuYH772IE5EbL6N0tTU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D75qwCAk;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768156621; a=rsa-sha256;
	cv=none;
	b=pLrnoGWL1U5Xxz4+8oYoTlpbRo3PX/KE6kdwjoigPJ9sV8hrPfLuDFO7nmZIDQP04gJLAD
	RVpLs1A8cIowStuAFQGP/xRs7Xe/QqLsXNsRnnQzV5Xh5QC/+I64klCQJqRi0wmkq34Y0J
	kLPG24FrV2JaurDpQC/KsVNs8RGFYX8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768156621; x=1799692621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/w6ZMO8WXEMmm7vJ/Otra44ARG2F23kE81QbIE4Nn2Y=;
  b=D75qwCAkSauemKXFxTk5nfk9OvTJx7WY+jcLC1PJf8R8VQSQ9SAxNg47
   nMrYDAGWh8WbhndwVCd1Ac1WuLJMQbaeTyTSLOXOUic4rgoWAjpiqSs/K
   +KyWtmnXx2G/U9FYfQ8Kkh4z4PO4wrbJDGYhYOmiCE56vu0xf9LWu2mx0
   fFfHU7Z1EWKsNssY54m1V4to21mFFKigQLlSgFg1IDiUDqlnBcvQuc+7x
   j+hFM4Wr76/NGsjc41CvGxdGIvzGNb8LtBdSoqq02Dx5+aRKWMsZQp23M
   BdtGrYTILQeEtS5Jkzj6RGjUlmnZ4ASy91Djwv5I2nrWSGq+Hs9DGjHat
   Q==;
X-CSE-ConnectionGUID: VBWyQK5nSmGUExi4Sh2ozA==
X-CSE-MsgGUID: P/ydzDjJRj+OO0F3jd84+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="94922864"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="94922864"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 10:36:59 -0800
X-CSE-ConnectionGUID: k1tkRtkqTVqG2qXf9nkLZQ==
X-CSE-MsgGUID: DJg8LxEbT2KC/3DQ+cF+3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208402498"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 11 Jan 2026 10:36:52 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vf0Iz-00000000CcG-3Izs;
	Sun, 11 Jan 2026 18:36:49 +0000
Date: Mon, 12 Jan 2026 02:36:32 +0800
From: kernel test robot <lkp@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH v12 1/3] lib: Introduce hierarchical per-cpu counters
Message-ID: <202601120245.v2Trbgck-lkp@intel.com>
References: <20260111150249.1222944-2-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111150249.1222944-2-mathieu.desnoyers@efficios.com>
X-Rspamd-Queue-Id: 47166A0011
X-Stat-Signature: oi1n5tzujwwykmr5w55wf9du157j1rg6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768156620-349070
X-HE-Meta: U2FsdGVkX18l/BTkC1Y04Ww+Y8NYj6wg7vtc9y+yAxobQn1NKE4dgh88ATQ9qBqZsmQ3QHgl4vpqCiSIzy8oER7XtwA4XU2E1nQbkZBB2jhGZZt9t2PJlOJ6P2QM6sqp2WO/FbZ8LIj/OF0LnfHdp2dCTDWNMntSQb79hcmYpr4XVHJwKXQNKw/xax4uQH2/nYQWE6rm/3jm6GOsPdJHmoFRwywYY4U5mhLGtYjqx3/jIql3UhqpHgTvC/ut1K7i0UFnO3bWddlkSeqKU7ixQpe/6M6aEC68Mh9kFNTufowzJ+0fHqfojoOAUYr0JBScMI9am9n62+iIFedz4fl3qnVxnZ4rWBnQLMp1wwhngsjcyNSncrdaqc0l/8fXiuLx1Xrw7DV+LYx2TlL4h+QBEMKKvbP3Z0/mGswU21Q1hDdxeklIJ/3TjHKmLMqrwIO6tWxU6LS+sRRhyIt/GQ65JPyROE/a68/PbzTGvAMOCYjGJGGL2ZoJJRqdJ2ynuWSGtApl5sLyC4DEh1UiR+SALleA4XYndgUAqi4qnd4uq9ZvbTJiNz05NLjZJMrkeTTY5/5vTV+CyfJ0b8UvVUBRXRFiZPPoKu1a8BJEF4itfz5AfFSiL5Ro6msi++O1xuMFWKc8EsTdv90rfMNFuAwh9XNGKnjBAl9STx/mL7YB2ikzgmBUe9rfHlOc0IRyNV/nsn4lbGGIe32KAwzl5IysJQoBOknSadhcXSxyvS7a8TGenrtj9Evx85npGtmiaCK4qpp+2QXIXociI/+V7Js4kFWUcZMg98GcgsZkruo16N9PcBEJx/zRedSaQAtaITau2ZSTYUEybi02plQ2bT+jwbOu4XwlJeHtdaku+Q5b+Lz7bp8t/ZRjXEiqwuZjqDM7L1rDkv/4sfs/w/4eDW+8uYKI0K84hr4R0bLKeIwPBYaZRcvx+NAX/wHB0SmYv6aVbWxb2xburwPbSyo8//a
 8W0N3D/f
 OmOt6810URjXrMXuVWcKiPykY9DUOJQCQe41E7WHCw6dXfDDVWYo6nOgD/HhnUUOjweLH2ygyHLrDuA+RYu75EFlLzD3XQw1QOqZHDG0gJpeAj0Rd2dWwqvHCICOYJD5VgUrk35jnE7hF15zlb1xcBODq68RA+d+McjyI7J3A6cnu0VGP1BCFIaMl4Ldn1GrHf9TE7gPhIS2rNyFm2bt9yb6pd9xKKF6J1Qe67ZwIB3Ew+K05Bbct10DcbGUvtFJ69f2KzVCUAJcwpX2DdbRBZZJXNWMeiS0FecIezD+fumvms/eC6A0/6AWHSdOKtySU2Es5d/pPhl+iZVfKB0eYZJqMHtfdt3Ff538e8OgipguTaXil3caasUE6IJs2mIfmIdiwkpiQyJjBAsjySoIiOn/Z5GHlyppoxvK8vLF8+MdHzCwjNQJ8JT0t8h6/SQCZmmQFGoO7d81gDH1bdqcns0Dam5yv0YvXExFu7cmznuw4Wp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20260109]
[cannot apply to akpm-mm/mm-everything kees/for-next/execve tip/sched/core linus/master v6.19-rc4 v6.19-rc3 v6.19-rc2 v6.19-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mathieu-Desnoyers/lib-Introduce-hierarchical-per-cpu-counters/20260111-231206
base:   next-20260109
patch link:    https://lore.kernel.org/r/20260111150249.1222944-2-mathieu.desnoyers%40efficios.com
patch subject: [PATCH v12 1/3] lib: Introduce hierarchical per-cpu counters
config: x86_64-randconfig-161-20260112 (https://download.01.org/0day-ci/archive/20260112/202601120245.v2Trbgck-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
smatch version: v0.5.0-8985-g2614ff1a
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260112/202601120245.v2Trbgck-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601120245.v2Trbgck-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from init/main.c:107:
>> include/linux/percpu_counter_tree.h:230:13: error: incompatible pointer types passing 'atomic_long_t *' (aka 'atomic64_t *') to parameter of type 'atomic_t *' [-Werror,-Wincompatible-pointer-types]
     230 |         atomic_set(&counter->count, v);
         |                    ^~~~~~~~~~~~~~~
   include/linux/atomic/atomic-instrumented.h:65:22: note: passing argument to parameter 'v' here
      65 | atomic_set(atomic_t *v, int i)
         |                      ^
   1 error generated.


vim +230 include/linux/percpu_counter_tree.h

   226	
   227	static inline
   228	void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v)
   229	{
 > 230		atomic_set(&counter->count, v);
   231	}
   232	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

