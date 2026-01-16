Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E98D4A603
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 06:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22FCE6B0089; Fri, 16 Jan 2026 01:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B39E6B008A; Fri, 16 Jan 2026 01:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFB76B008C; Fri, 16 Jan 2026 01:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED4B56B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:29:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8411A1AE6C9
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:29:48 +0000 (UTC)
X-FDA: 84336851256.30.64FA84D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id C16B6A000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:29:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RIX+7UGS;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768544986; a=rsa-sha256;
	cv=none;
	b=EIxzBXkGbYPddJ6kl2l2uBqZoDBvkbDc8KyZnBrUaLPPXjGKL5qQiCJpfYXP9CdmNBWdel
	0CUbEimMZY5NOBhq8uHXhUpU093cUruntImEPMN3g7vcWl7YzY/8BVjHr/lORct/q5gY4F
	bTHrIagMVHe0NetNIP8pWqs8DKwSCKA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RIX+7UGS;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768544986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4Io3LO0XDEFrIPZ1wVwD06rhILRh/5g3zrQ4rS6Enp8=;
	b=3wq7QUScT5DRmw4woCDHUqbpLB1EvfqudfbhLxFWWbGjA0xHsds0k3GT86idR/L2OSiBBe
	e+OXi8E67Z0PYIcrq5h2aZj7R5L48HMRxjlgWHVLpAgZFIm0Uo63/uJ1O+dfmroH5yWDvR
	mAjIoF6SdcdEAsATJtCusmYDhNjquQ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768544986; x=1800080986;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=203LEnegn6pgyEb+gr3UN6xlH03P3esILLrbrs6t1QA=;
  b=RIX+7UGSYx1MEwde+ceMo856r4GEPgCBoo8dRKEZ1M3oiVQVF1KhhnA3
   exNJctk0PTNC3CJes21qGJEhybmAk9ZBNuDKqUE+pz1NXnre06SZ0MT1c
   /X8wy53Rml4YODbNjiwgCUAcdO0c3lvvALJgQl5nZMyr8npXpPJoOsMd+
   bNQ8LJZKKfBrRXODY07Ep3fW6rZvtzvlgfc3JvGDtBJiTGBwQpX71Aw//
   McmNjezGVG1l3fqvrVSor+Yl8a6wlIqPt4p3w7cKXWwgFDlYey6CFB8y4
   rUHqgB3c6wcIWd5uYPWdwyM3JKp7e2KYUVD8fxq2onVIwdio877kI8mev
   Q==;
X-CSE-ConnectionGUID: s/mcPXKKR12mAaE0sn2Q8Q==
X-CSE-MsgGUID: bz2lw6RSRs2zwbE+w/i2Tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="87276038"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="87276038"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 22:29:45 -0800
X-CSE-ConnectionGUID: XDAfVPo2QI+gwHcQWbjEMw==
X-CSE-MsgGUID: eS4cLMU1QCCDdiroYNztcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="204955513"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 15 Jan 2026 22:29:42 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgdL1-00000000KTq-1Vws;
	Fri, 16 Jan 2026 06:29:39 +0000
Date: Fri, 16 Jan 2026 14:29:31 +0800
From: kernel test robot <lkp@intel.com>
To: Byungchul Park <byungchul@sk.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen"?= <toke@redhat.com>
Subject: [akpm-mm:mm-unstable 101/288] net/core/netmem_priv.h:19:73:
 sparse: sparse: incorrect type in argument 1 (different base types)
Message-ID: <202601161420.8xY65Dyx-lkp@intel.com>
User-Agent: s-nail v14.9.25
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Stat-Signature: dcjbfuhf11386f4so8wgknygs4hp9gc3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C16B6A000D
X-Rspam-User: 
X-HE-Tag: 1768544985-698383
X-HE-Meta: U2FsdGVkX1+cQbHBMM3PwEtx3kZb+f13WFW/HY+D+5/YcjiQAVE045+57QLVNR0Ti2lgaVuySue7UVKEB1yaUZmaZfka/SvpO67YeAJ7puuNFN2Z68YjLp3SI0P5xloyb3QTjoifvIkqadQxX5SWHePPciIwArtBQuO/mjEauZVGTAKUapWxhECUKMNXNeAUWHy8oF3t7NEr8uhZN76MKX9PghrvIjpf1I5oysrvkzH8/qkyyNNlWG9C5XAh8x8cVX5EfO2hXsrRY5fMvYvlMsl/p6r04SFKGXedv+0uesVMnTd5+Qcnkq+BWsQJL0vTTot9lKoS+ibCh/FbSBcZiLeel81TGlYTu26GZcczzfFVXMqt2HKDlV5z+kXuNfZyMul7P2f7I0iM1wrlsRyaEFNDh4gxMNTGw6vKZwK0Pyj/Zu5NPH6DNoA4vNWaFtWFausL7oOlC388RUtl7UdchkU/24PaY3a9Vuv9ndGr7CAWn737nUM6SYdnfp/Q2L44f3W4e4eUx3qgwo3YDKSNg0lFpZNN+WuwD1LhpebA3hCXqmpHiA2Nf6TRU1r2023uSbfwzFJNz/y+HP2ABy1gCLrsA4LHRYQxEr9rTGwgu0vbvBT7UtSo5Qa/Zu6NFB8N/74xqgjHXlQ/nzH827/0JtrBZjKsQu2Qkz70H8R3NZ1BhU4p8OxEJ5PXq0cog4/Tl7LWY6XgoxJHboljWSSUp03ZBqOaZY+3HoYUS1j/lJGCFBKFHBowWC/72HD2X/su5UCKsOMe+t5r4gPLlpwWDTjBJFgEHT+O1fMzxD1k4GO8N8890+Xgegffd75K9dKjgkTNcDPPPAjdbtqcPv1Qi6KkLtGtsZ2sLBJLOpvR3ddJiN2H3ly6eomJn/Kk3wczDrBzov+k+Wp7/Dd+kEh7XfFpdzq9eEKmUmth/i9O8sQo2J1dhC+L+YDbJqk3VPVQGZBi13ILr9fx+8DwBZR
 B2cW21Ky
 49qIWUnfZOouemSExzWu62o6xJwF6grId1JHs51MzfVEGZ0UqnjCrfOVPCgBRhUYUsypZmh+DkhTFRyZlBm54W4WYYyZmrAWSAOuqZj4wMGWTnxJoPXTDL2ATueAPklYFDYBgdJ42rU4AMBtRR+oY5jYF2yK/OrK66KKeJlHT/PFHP9TvvL0B8FfaidVUUT855JLqsM33+MfbJkSsWdXaYno84CoZP2mcWZ6Ez8pI3nxHktAHhPvLL4B12/1+87cqYefy8fJ4+VpTMT3UuDO/2vV3t2ccaHzjiKa6DxW5shUHlY7swzPGcb1v3WYevmIkxRAjOmmsKSoJ7ZwKtjSE3a4EhXiqCDN7VBMrhr+kHFatWaafx7BNesA9h+d+/TUwHUGvVHct5GaZnDgms8v6EeyrmfgXMXduFBhK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   f8ed52ac0cfbddff992bb9600941bfe51e1e385a
commit: 71b73571e052b94a2af7835373d4090afee5e1eb [101/288] mm: introduce a new page type for page pool in page type
config: x86_64-randconfig-123-20260116 (https://download.01.org/0day-ci/archive/20260116/202601161420.8xY65Dyx-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161420.8xY65Dyx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601161420.8xY65Dyx-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/core/skbuff.c: note: in included file:
>> net/core/netmem_priv.h:19:73: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted netmem_ref [usertype] netmem @@     got unsigned long @@
   net/core/netmem_priv.h:19:73: sparse:     expected restricted netmem_ref [usertype] netmem
   net/core/netmem_priv.h:19:73: sparse:     got unsigned long
>> net/core/netmem_priv.h:19:73: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted netmem_ref [usertype] netmem @@     got unsigned long @@
   net/core/netmem_priv.h:19:73: sparse:     expected restricted netmem_ref [usertype] netmem
   net/core/netmem_priv.h:19:73: sparse:     got unsigned long
   net/core/skbuff.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/inet.h):
   include/net/checksum.h:33:39: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/net/checksum.h:33:39: sparse:     expected restricted __wsum [usertype] sum
   include/net/checksum.h:33:39: sparse:     got unsigned int

vim +19 net/core/netmem_priv.h

    10	
    11	static inline bool netmem_is_pp(netmem_ref netmem)
    12	{
    13		/* XXX: Now that the offset of page_type is shared between
    14		 * struct page and net_iov, just cast the netmem to struct page
    15		 * unconditionally by clearing NET_IOV if any, no matter whether
    16		 * it comes from struct net_iov or struct page.  This should be
    17		 * adjusted once the offset is no longer shared.
    18		 */
  > 19		return PageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));
    20	}
    21	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

