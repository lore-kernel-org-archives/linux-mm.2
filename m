Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A299E83830
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 20:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302CA6B0088; Mon, 16 Feb 2026 15:38:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD216B0089; Mon, 16 Feb 2026 15:38:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187116B008A; Mon, 16 Feb 2026 15:38:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1BB56B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:38:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 662958CFFF
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 20:38:39 +0000 (UTC)
X-FDA: 84451483158.08.5672D68
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id 778BA80007
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 20:38:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=apeK2QOt;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771274317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TojxoJmNhyjU53IbkwPrjBwXeygl21fLvoJT/Zzat5g=;
	b=CjdtFNduxR1POCCjj8lDeaMOKDr4uiprTetxCU0CCQ6o97LD+PWOSoZosdIb+LPed4ePhh
	shUnX4QxFnrmBVaM3ybL7ZW9gQaz06zFu72LgJLWhkTCqUwd6Qush7KuGap51cuodfgunP
	pDV/meqpz1VkLx7MQ6R7sSQcq9UMlZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771274317; a=rsa-sha256;
	cv=none;
	b=vB7JokwNAYKxq99SPIHe7TcVMFRbSbvxrI4V0qGBXZEmJ7Jk2xvuvaxEDB64yowhwtuVzk
	MW8XUw3a00n8oNUom3fJUsBgdDVeGBZ9hdwdACwxJru6u7I2sjIYKgBDiI9GlasDJQLHFX
	cMy3IA+cAKti09Sxjk5UhkW/eNu92O8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=apeK2QOt;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771274316; x=1802810316;
  h=date:from:to:cc:subject:message-id;
  bh=K+r1yX2mtL2JeTD33rvmC2Bma1Q69iZQhwAXDSfGFLQ=;
  b=apeK2QOty3aCCpYIyhmlkLo77cpdvzgajwezrE6mDpSzn2yxAe0R9uR/
   oewfAhdWM1VhR6vrV0mNjYm71oNZRhADjSiafFiJZu3898CELVjY8DOfS
   izHrcWrPkizK7A/1F59UkcDQtR6JdnKvieT04SQ99WPdHt5FXiVQpOXPT
   xZVxSiNe/YX7A7OBEdL4Q+WzQCIVOpGzUABAhPVMAZeY8QJ1R9gZBB+yl
   hTPfSL3inORt20vJNN3smmyRcONK+4sNWQmGkfix7cR5FQZrjOcjfUQGa
   4DPCz9dHy/OFIH45LyQanjn95wPGACXsa2rrqtjUiClESaGl+5UwXuyGX
   A==;
X-CSE-ConnectionGUID: S3QNHmYhQcC8UP3eX9CYHA==
X-CSE-MsgGUID: 4Otf0XOGRl2xUC3IBJmfYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="83079012"
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="83079012"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 12:38:34 -0800
X-CSE-ConnectionGUID: LHhPrfsnSK641ZXhCaEDmQ==
X-CSE-MsgGUID: f3dc1gkIQzeIVBRPMKXseA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="217844711"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 16 Feb 2026 12:38:30 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vs5MT-000000010GY-3URm;
	Mon, 16 Feb 2026 20:38:29 +0000
Date: Tue, 17 Feb 2026 04:38:27 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Dan Williams <dan.j.williams@intel.com>
Subject: fs/dax.c:1885:21: sparse: sparse: incorrect type in
 assignment (different base types)
Message-ID: <202602170406.kegA2Rkg-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 778BA80007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: brhwgo97itcrieyi4o99gscfpf9pkj6e
X-HE-Tag: 1771274316-736468
X-HE-Meta: U2FsdGVkX1/zF0EVk3UUlhYH/+9ehuppX5wVBt8QA5oc9D+ptmcEMEh4BxtBFzBj08ggW2+hMW3/BPY0/nWo/dmyYM/S2+deJo+SS5H14SMYZXSRKDCSZcstscwNRDPEhM5joTkI1oRDXZM3gKdN0v8bY4/VlziCKDhb1OcytWWsp24Y9AnHuHNj/b8pSUil4JgG73Ei6BPdl7olVQlC6CFMYP1yOJO4Uq1NEeAMftd2Q8ob1Tjy1c1D5n63HF/x3voWIxFe0pFb2W56WgDDWCbS5qsfaoj588Rd97aT74K8kh6zNT2PlTb4cuLbuC1tGfVkjNWMikC7wLjUNVluRPyde1ct6LA1X64YeCiAxnuPyxH/4wOUxreaYRpRjvpDe0ZJoWHYsHIkxd9DdS/3xRjvXp3YqbKfcAPfVjT9/+7h51PNkWRKWu7h1XQABzmdcAY7ouFqjxi1czMte7oe89IR0PAG5YGnEEEwTAVryiNIEo6aukpYzgmedTmZDpLZYz4PeQsYTTYOGtxCtDAhC1bvGd7N0t1JF2QH3fzoPPNiT+KOzr750PTR5tPymfRaSurGb/YLUtolSzGJkLgOs5Cma8aPxLXRZpxVveH6gY0ZfiK6r4CONCRKoUSeMZhcYLzORfpSWu9r/RJDGkYFsSmbbi3TwNt+9dsjC57Ot6HX4IinTaKFAQ0dDy8TDko9lkHVKiGOlWai4pSUGSbYRbyQF18DsguuPK6IIrg9vmOb9n9tpoT6EXddCul15oyeArOg8JGt/R/Go+8/qayxlpQXdWOAzc1kEq83xJVA01zoFwUiD2ROpx4/JJPG9DNNMbO+XhAOtKw8U/nqTuXL7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   0f2acd3148e0ef42bdacbd477f90e8533f96b2ac
commit: 38607c62b34b46317c46d5baf1df03ac6e48a1c6 fs/dax: properly refcount fs dax pages
date:   11 months ago
config: arm64-randconfig-r121-20260216 (https://download.01.org/0day-ci/archive/20260217/202602170406.kegA2Rkg-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260217/202602170406.kegA2Rkg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602170406.kegA2Rkg-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/dax.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/fs_dax.h):
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   fs/dax.c:727:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:727:39: sparse:     expected unsigned long v
   fs/dax.c:727:39: sparse:     got restricted vm_fault_t
   fs/dax.c:729:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:729:39: sparse:     expected unsigned long v
   fs/dax.c:729:39: sparse:     got restricted vm_fault_t
   fs/dax.c:733:31: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:733:31: sparse:     expected unsigned long v
   fs/dax.c:733:31: sparse:     got restricted vm_fault_t
   fs/dax.c:1376:41: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1376:41: sparse:     expected int result
   fs/dax.c:1376:41: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
>> fs/dax.c:1885:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1885:21: sparse:     expected int ret
   fs/dax.c:1885:21: sparse:     got restricted vm_fault_t
   fs/dax.c:1888:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1888:21: sparse:     expected int ret
   fs/dax.c:1888:21: sparse:     got restricted vm_fault_t
>> fs/dax.c:1891:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted vm_fault_t @@     got int ret @@
   fs/dax.c:1891:16: sparse:     expected restricted vm_fault_t
   fs/dax.c:1891:16: sparse:     got int ret
   fs/dax.c:1909:46: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [usertype] ret @@
   fs/dax.c:1909:46: sparse:     expected int result
   fs/dax.c:1909:46: sparse:     got restricted vm_fault_t [usertype] ret
   fs/dax.c:1925:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got unsigned long @@
   fs/dax.c:1925:21: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:1925:21: sparse:     got unsigned long
   fs/dax.c:1966:51: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1966:51: sparse:     expected int result
   fs/dax.c:1966:51: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:2046:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got unsigned long @@
   fs/dax.c:2046:21: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:2046:21: sparse:     got unsigned long
   fs/dax.c:2080:62: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:2080:62: sparse:     expected int result
   fs/dax.c:2080:62: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:2142:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t @@
   fs/dax.c:2142:55: sparse:     expected int result
   fs/dax.c:2142:55: sparse:     got restricted vm_fault_t
   fs/dax.c:2160:58: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:2160:58: sparse:     expected int result
   fs/dax.c:2160:58: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:279:13: sparse: sparse: context imbalance in 'wait_entry_unlocked' - unexpected unlock
   fs/dax.c:508:49: sparse: sparse: context imbalance in 'dax_lock_folio' - different lock contexts for basic block
   fs/dax.c:575:17: sparse: sparse: context imbalance in 'dax_lock_mapping_entry' - different lock contexts for basic block
   fs/dax.c:1148:9: sparse: sparse: context imbalance in 'dax_writeback_one' - unexpected unlock

vim +1885 fs/dax.c

  1826	
  1827	/**
  1828	 * dax_fault_iter - Common actor to handle pfn insertion in PTE/PMD fault.
  1829	 * @vmf:	vm fault instance
  1830	 * @iter:	iomap iter
  1831	 * @pfnp:	pfn to be returned
  1832	 * @xas:	the dax mapping tree of a file
  1833	 * @entry:	an unlocked dax entry to be inserted
  1834	 * @pmd:	distinguish whether it is a pmd fault
  1835	 */
  1836	static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
  1837			const struct iomap_iter *iter, pfn_t *pfnp,
  1838			struct xa_state *xas, void **entry, bool pmd)
  1839	{
  1840		const struct iomap *iomap = &iter->iomap;
  1841		const struct iomap *srcmap = iomap_iter_srcmap(iter);
  1842		size_t size = pmd ? PMD_SIZE : PAGE_SIZE;
  1843		loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
  1844		bool write = iter->flags & IOMAP_WRITE;
  1845		unsigned long entry_flags = pmd ? DAX_PMD : 0;
  1846		struct folio *folio;
  1847		int ret, err = 0;
  1848		pfn_t pfn;
  1849		void *kaddr;
  1850	
  1851		if (!pmd && vmf->cow_page)
  1852			return dax_fault_cow_page(vmf, iter);
  1853	
  1854		/* if we are reading UNWRITTEN and HOLE, return a hole. */
  1855		if (!write &&
  1856		    (iomap->type == IOMAP_UNWRITTEN || iomap->type == IOMAP_HOLE)) {
  1857			if (!pmd)
  1858				return dax_load_hole(xas, vmf, iter, entry);
  1859			return dax_pmd_load_hole(xas, vmf, iter, entry);
  1860		}
  1861	
  1862		if (iomap->type != IOMAP_MAPPED && !(iomap->flags & IOMAP_F_SHARED)) {
  1863			WARN_ON_ONCE(1);
  1864			return pmd ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
  1865		}
  1866	
  1867		err = dax_iomap_direct_access(iomap, pos, size, &kaddr, &pfn);
  1868		if (err)
  1869			return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
  1870	
  1871		*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
  1872	
  1873		if (write && iomap->flags & IOMAP_F_SHARED) {
  1874			err = dax_iomap_copy_around(pos, size, size, srcmap, kaddr);
  1875			if (err)
  1876				return dax_fault_return(err);
  1877		}
  1878	
  1879		folio = dax_to_folio(*entry);
  1880		if (dax_fault_is_synchronous(iter, vmf->vma))
  1881			return dax_fault_synchronous_pfnp(pfnp, pfn);
  1882	
  1883		folio_ref_inc(folio);
  1884		if (pmd)
> 1885			ret = vmf_insert_folio_pmd(vmf, pfn_folio(pfn_t_to_pfn(pfn)),
  1886						write);
  1887		else
  1888			ret = vmf_insert_page_mkwrite(vmf, pfn_t_to_page(pfn), write);
  1889		folio_put(folio);
  1890	
> 1891		return ret;
  1892	}
  1893	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

