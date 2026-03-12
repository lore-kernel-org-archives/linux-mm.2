Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB8A106703C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 14:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D136B008A; Thu, 12 Mar 2026 10:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2AE46B008C; Thu, 12 Mar 2026 10:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF1A6B0092; Thu, 12 Mar 2026 10:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD09D6B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:29:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 777061401D9
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:29:50 +0000 (UTC)
X-FDA: 84537644940.29.44B2865
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3BE5E1C0016
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:29:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aOdcUHgS;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773325788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3sgA+5xvHiUIUrR8LGZnCr/90wuIFp1Jeb0b0kcwnw=;
	b=yCARoRbS58c1hzR9foucAK3lqD/FywXVQPpILmQ61NRLCW2S31tFPM+SEPrbe+32+PVsTW
	MPtXnYz4kBjjUOfsExucCgGoqFH5/VddLfjPTqiP1T/C8AYT6K+XMpgtDpKa5zfdUo2csM
	A+z2UWw4CeJCEgtxFLbNOG9a4+OC8TM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773325788; a=rsa-sha256;
	cv=none;
	b=blO48FQ7dB1ufAJYp94vZtWfzddvRQTfZveRzZOc5SLRC77TCzDGwoL5M+BWeu/LggH7/Z
	x2lNd+Dt4Qx/LswOYBLNoSBg7exhM2d+KsJQ2y5EzmDP1X6P3iZ4LsSVVzJ6r/vB9tKT/o
	u3JLIDgTchN7cxrn5cWTjpWyxxNmi3g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aOdcUHgS;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773325786; x=1804861786;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U6h2kSkaL3m+HufZ+v4XEQzA63uvN0k+ygU09TQOjv8=;
  b=aOdcUHgSV4abyZsv83d8rq5gVuwxbbg5CjWpho6kRbAMwYJtu/5HHvP2
   AoXnXNbpc/vl8rUn4zBcjmusLp1rpjQ+qp/5fNqWx5AKku5RX/2sU8d6/
   LxH0H0oH1TrynlgrUm8p7HnsSaQ6ajhoQo5mBHF8RMyA6zZZhwJ82RlYL
   9QfvJbAZe4o4Sj287Np1i1em1qTOHMnNBUGjSN3zsXaaGDobcqLPTd5Ad
   v3K/Fx/UwU/6un3fhdTZvQnfHYk31rPLc1nXQSWrJrOQ9b7y+LO/wMOkU
   mxniSLlRYeCteSu/qvycT2OwUbDJjC9YUXqZEujJVhdIRJ46lRieSIe+9
   Q==;
X-CSE-ConnectionGUID: RjGyXSFnQyOLnQpxcGz2Mg==
X-CSE-MsgGUID: lE6kMTL1T5m8jIbBCuiPuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="85773985"
X-IronPort-AV: E=Sophos;i="6.23,116,1770624000"; 
   d="scan'208";a="85773985"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 07:29:45 -0700
X-CSE-ConnectionGUID: 4MKoUK6kRgGlaA8Dhfivaw==
X-CSE-MsgGUID: 5lbBIi/WTwK4sairjG9Ekg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,116,1770624000"; 
   d="scan'208";a="218641912"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 12 Mar 2026 07:29:38 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0h2c-000000002Yj-1R2Q;
	Thu, 12 Mar 2026 14:29:34 +0000
Date: Thu, 12 Mar 2026 22:28:35 +0800
From: kernel test robot <lkp@intel.com>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eugen Hristev <eugen.hristev@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Brendan Jackman <jackmanb@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 13/25] mm/init-mm: Annotate static information into
 meminspect
Message-ID: <202603122259.3cXlDDN9-lkp@intel.com>
References: <20260311-minidump-v2-v2-13-f91cedc6f99e@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-minidump-v2-v2-13-f91cedc6f99e@oss.qualcomm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3BE5E1C0016
X-Stat-Signature: ga3ubj86dcxzxryx8a1tf9z7149wh6z8
X-Rspam-User: 
X-HE-Tag: 1773325786-661239
X-HE-Meta: U2FsdGVkX1/x+zq6b/OyeeqJujETSYH+CQIbfbykWqAOB7wKP5PdsHWRYT8TlBK5iAgjVA5otCyY7WwcGYFWfIgpjX0p/GIDAWvtURFCKwmvw9ETgPs0Q3iOXKSXdLhzSMGmYeTR28Bjb5BbenlWFP8YlL7AFltllb8npQRfYh5gc1F7DXwRJ7xsxzdfny5bdbn1fzWmqCwnjE3FyfGxDWTdAbDuFbUbcTIoSHd6OZDB3psDSvwbRu1QG/7898sBb4272y82vP8X1/fXpV3GEj3PECTsVlE12PtlkCcs/5Ho8xVzzDSc/AOhn6XN6GfozbEDMM0tCDPqOCfkgHBzMDZy9DWco0IGDCq1DveLI1g1DZQnRElAYLp9kBclyw+yrTR9qK4aGxL3AgLRGtYjrhjr5tFhNpxrUi14l9qy+LTn/xtLtEgFSDlAtZ87FVEu0FDpNUqtVj6pdlIga/gRuxP2wn0U4G/4LGO6bufPcHP0ZevHZg7mkA9uLXHg2gz0CXtdy0gfOI/LkK1sf8Om21d5bejQSeTKK2kqf6swYWWx7sCEAI0ZWnKOD2Z/cZFJcLQUK+ZayIHHq3jJVojxZuePXr/RNGbL+2VmV1Ctm2jvBTgF77oJZIsPP2ORCBn5jAf3L8Cq++qXTd30UYm1ngQ6uWWHv2uzw7rUAMmsfAWCg+ZkJ26kyBXpf5LJaFrmfvb4obmo7YVp211EMOGInNTsgEkOwviIjsE8GNjfFK2RuloEXYucMX0dsPgR2Mp+oyprFnAEj20nmIiEVu8eQkmLhGN0veywRALPb57netCZyLiFheRFyHVxBo86A71dZWufWDkPy0FfNGnifgsIAWg5Cjv+V0m0G58MSHvUyRDs1WIOy9+45SZe8EFXscqPVXrRaMb3cJ0eyQcl0DLVDTyo55Q/DT48STLAz+zZnf4rewesGuN8xXMDzIvxrbhSGBzI5apf0HUaifdam41
 BQW/GJJ0
 6KtLAm082EgQC4sql90jaA2PmxDhBdq7Wk7HjHBY9Vnoq0ZpKTOgk6PVQAqQ4ArTOlqsS4RKdn/AYHjhvXfjqP4oTJpaIcrbAEhwoQpmfahjn3tkXcR9TzllL6KSbEwTuMiAOCBVTP+7g+38fn1EB1IzTe0M0uv3L+pzAvcZ9MHAQMIv8DVHoB3xySWewybxbXB9PYig5bDsYea4pRa//I+/ve6nv3wRdvREoB0gzXeSsdK2AhOaFQ4my0Hwhh1JHQgDNHe+52Y1CdnJdf14puL8X5xmXwQjOwus5eXbp527urNitS4wf4n4SutJ6WtD760xorW9lBvjG/BUcinOBF9M8hu1iCAR7zRns
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mukesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on 343f51842f4ed7143872f3aa116a214a5619a4b9]

url:    https://github.com/intel-lab-lkp/linux/commits/Mukesh-Ojha/kernel-Introduce-meminspect/20260311-042334
base:   343f51842f4ed7143872f3aa116a214a5619a4b9
patch link:    https://lore.kernel.org/r/20260311-minidump-v2-v2-13-f91cedc6f99e%40oss.qualcomm.com
patch subject: [PATCH v2 13/25] mm/init-mm: Annotate static information into meminspect
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20260312/202603122259.3cXlDDN9-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260312/202603122259.3cXlDDN9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603122259.3cXlDDN9-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/init-mm.c:23:23: error: use of undeclared identifier '_sinittext'
      23 | MEMINSPECT_AREA_ENTRY(_sinittext, sizeof(void *));
         |                       ^
>> mm/init-mm.c:24:23: error: use of undeclared identifier '_einittext'
      24 | MEMINSPECT_AREA_ENTRY(_einittext, sizeof(void *));
         |                       ^
>> mm/init-mm.c:25:23: error: use of undeclared identifier '_end'
      25 | MEMINSPECT_AREA_ENTRY(_end, sizeof(void *));
         |                       ^
>> mm/init-mm.c:26:23: error: use of undeclared identifier '_text'
      26 | MEMINSPECT_AREA_ENTRY(_text, sizeof(void *));
         |                       ^
>> mm/init-mm.c:27:23: error: use of undeclared identifier '_stext'
      27 | MEMINSPECT_AREA_ENTRY(_stext, sizeof(void *));
         |                       ^
>> mm/init-mm.c:28:23: error: use of undeclared identifier '_etext'
      28 | MEMINSPECT_AREA_ENTRY(_etext, sizeof(void *));
         |                       ^
   6 errors generated.


vim +/_sinittext +23 mm/init-mm.c

    22	
  > 23	MEMINSPECT_AREA_ENTRY(_sinittext, sizeof(void *));
  > 24	MEMINSPECT_AREA_ENTRY(_einittext, sizeof(void *));
  > 25	MEMINSPECT_AREA_ENTRY(_end, sizeof(void *));
  > 26	MEMINSPECT_AREA_ENTRY(_text, sizeof(void *));
  > 27	MEMINSPECT_AREA_ENTRY(_stext, sizeof(void *));
  > 28	MEMINSPECT_AREA_ENTRY(_etext, sizeof(void *));
    29	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

