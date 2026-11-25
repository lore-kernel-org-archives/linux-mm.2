Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4271F606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Y3Foe6Bp
Received: by kanga.kvack.org (Postfix)
	id 37F6B6B0A1D; Wed, 25 Nov 2026 08:47:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F966B0A1F; Wed, 25 Nov 2026 08:47:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F106B0A20; Wed, 25 Nov 2026 08:47:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E55A76B0A1D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:47:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18A67C0F00
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:47:15 +0000 (UTC)
X-FDA: 85473768030.03.E1224FC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id D63DA180006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:47:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y3Foe6Bp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795614433;
	b=Kc8dm1rvlAVmaAKumHdFxR6zb/rfGT81OUqLPW5GlHBzqktmXr/CS8CUFR+cH7T1PkyoaD
	Sf14/xxDWAfiiOVHmQhej88NGOX4Kb1VrhMopVl22ek9sCOl4RTNEgmiqQJFyEeCse+Jfn
	6UY37O4FrZHZ46YH1CPteEmyLZuK6sI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795614433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Se8wT/fU+HdNWsGJegIdeQkIxuwrabWdV0hbMqDYi0E=;
	b=ymNCOfgHYF6qI0XN0qLXzWQSeGW6TBE43Om8CwAiwsHCOdGVd0tbVPjKLU1WP0OxuntHEc
	kEt644D8rCCQz8OnbZrHM9Stj9jLi7TOMz5TvP/858dX2XYcrHy+m7y2maDGmNybYVF/Ep
	qs17DO3MeqNDxBQmMseIFT2bAsVTj3g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y3Foe6Bp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795614432; x=1827150432;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=85dtCJhxafyH7yNjIQIXWSMxs0vF+3hxEDtwFRfZmf4=;
  b=Y3Foe6BpYUmH6T1XqhNNqT7qH3DLqLvfnmBW8GNjqA/LVQ7Xf4vufgZj
   zzI3h7MfYbc970HtXkNV/bMlynKJnVY2q7fMBiXcoTG6H6sfrwlHJhukA
   d2TWHYLUdkDT0UYO5lk9YeHQtk7N1PQRIwXQMuIkMDOnJ56iaxRqbaNj0
   K1TK0T6B9J6I6ZcH5TKi9FUHPJKRydUbhAijrRy85to/jzMveFwdDnJbq
   iXldIshrjN0Iay3F7H3yU7GNMaWBQTCZwemkN+JjO9VIRRON1DVBy6k2p
   bNmJloSLyz4vS7QfsNN4xsxLFhOEOwolmDj16odZEQvti82Jwzq0Y2r0s
   A==;
X-CSE-ConnectionGUID: OaGdNrXITG2CICqlZ3hJiQ==
X-CSE-MsgGUID: W6dbnj3cRu6tYnyrmxHzgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4405967"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4405967"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 05:47:11 -0800
X-CSE-ConnectionGUID: sOwTZi0oT1a8yYrbS8PixA==
X-CSE-MsgGUID: GKirioOfRvq3CU9Yc2Uxuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="11859261"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 05:47:09 -0800
Date: Wed, 25 Nov 2026 21:47:05 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	David Hildenbrand <david@kernel.org>,
	Eliav Farber <farbere@amazon.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, yi1.lai@intel.com
Subject: [linux-next:master] [mm/memory]  f8eca7ec1b:
 xfstests.generic.437.fail
Message-ID: <202611252134.37a9cb7e-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: jzywd8ddwisycecf333kmcffpuqk56km
X-Rspamd-Queue-Id: D63DA180006
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795614431-699327
X-HE-Meta: U2FsdGVkX18fC4SaUuOpAdWDSE6vkRAnvWFAoqLdbuNJ1d035ee5PEOvTXNkTzUnAnplVmtUq7W4fVSMInYEYnk6p9IOy6rPIGPeeHIJhjnPwVe4UiNLd061jk/kYs7F3lCtduMgweGnmamQULhjAR8l3BRlmVQhNonFRhV5RERAfXRPOyZUAXnof9u35D54eKcthDi+B9itntJLG2xKfaSHaNf7elPCk/v1zayrO1TVGp4BMajGDACdeSk9H9V1Sp4J1PokAbgxLwsg8NnwzlzZc+4Q3S4tUSa972whUs6jy4L5pmyoOb0Uemb4iFiu9IIwzudznhogtPqIH1cjq608bDSmTLg1h6HP3o4ryOn7DljbjMiMM4U3VNJ2tDCa3n5e/yQcLQ44hV8zvgzrUc9UG3bfusgr2VUTfB9VfXZrY7U1m9y5bglP1O+cnse1suGvcKR9YX1elckyaNP8g+/QQ9qjV1FZzmXGyZ/xoqLd78JUBYx3HVDmZ8UywvMM/mRr5ausP/wD3lLXh2haVDUEbH95LXXmEOjM58YwhWjvJ0EJkeAltjckF8AEKNT0RaOKim3Oti2RR5ZQA9AWPdFvnLsnrPTcHM7uBK3MUFnciQFA0ThXqn3XvyVTwYLM2TCTsPaMfRKkeivE9C9G8m1DuwpeBeQ+3AOnbe1Q1QCtbRfDIB3OigeM824d4elB/HqC3ZJgR0RnF78dKWyKvbOtPT0jwzgEOcxs+epqzCavsS7IL9KN+2DrW5T6j+ZOozrxKqCCV3PLGwbcnK7HybrAQj3fdPqzsgOc7NII1F+ErOd3h1mqF9wZqZ4fXdOW63NQmi9lSo7ERkMTA0RHOq/aEbry0aOqoOi46HAllDX1LxlF/M2JFks+Pbx/KCKtGNc1H8i1oUH/nW17Io1lY9wI95cFFBHBtRxj5IPTxGSwX0V9lDNK6mfS5LwiLJ/sPYTCVMrpC5+M0hrSrjO
 ufDVPHYI
 mBa6ExPi+T5HErsh5d1zcLlpNPVtqKpw1Pmh5G1Br6hDc9F+oymHm0hbGX60E9gPOQ8qMW3Y4cSLpKZOV2Ct+CsLgpMSnC7X5LeWkaO0IoytTUbRwCbrtZDgbh43jHtWlzU6fJxa5mfJq9Kd8JFkLJtClqk3OS5WZCH25mlxK+SXAgJyl3tknXrPEAhU0U9JB3+lnJsitAJO4FJG47bwmh3eHkdon0/BXfr+oWTEu7hhP55Ht+DzHI+OGzR5uZberuaxGGH8K/QRxWod+AyCT3xMy/pZkCAnySRMz/ByIyRFQnQUCpGp7l9hc/16yjUVh0/3EwHOYPsH13zz8nbP3SxI1zn56kCJT8rgHpwOrcnwtVKWmCqw1nAjPCIYz/z/ttw2UBVyjzGhoIAnBuAfj14lN97zp+AYhBMx0Khjtxilf6n6wQlmbk0t9QSW02HXWgJRtgdcu3SPQMYeXqTVaOFua3M4C5H1KWjzjBj+J6Yf8u18I3GHXNUbCUqt2u9A0KXqRPmdwvYY8MvwE8PWKFTjchBZDmsu9Lu/txwHE24DE+Ls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



Hello,

kernel test robot noticed "xfstests.generic.437.fail" on:

commit: f8eca7ec1b368557613cc727abadc82546c1f46a ("mm/memory: do not report OOM if insert_pfn() races a huge fault") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 3dd8c790a7b7027abdd568e36db5e82ffaea7c77]

in testcase: xfstests
version: xfstests-x86_64-d07dca72-1_20261110
with following parameters:

	bp1_memmap: 4G!8G
	bp2_memmap: 4G!10G
	bp3_memmap: 4G!16G
	bp4_memmap: 4G!22G
	nr_pmem: 4
	fs: ext4
	test: generic-dax


config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 28G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202611252134.37a9cb7e-lkp@intel.com


2026-11-25 00:16:54 cd /lkp/benchmarks/xfstests
2026-11-25 00:16:54 export TEST_DIR=/fs/pmem0
2026-11-25 00:16:54 export TEST_DEV=/dev/pmem0
2026-11-25 00:16:54 export FSTYP=ext4
2026-11-25 00:16:54 export SCRATCH_MNT=/fs/scratch
2026-11-25 00:16:54 mkdir /fs/scratch -p
2026-11-25 00:16:54 export SCRATCH_DEV=/dev/pmem3
2026-11-25 00:16:54 export LOGWRITES_DEV=/dev/pmem1
2026-11-25 00:16:54 export LOGWRITES_DEV=/dev/pmem1
2026-11-25 00:16:54 export MOUNT_OPTIONS="-o dax"
2026-11-25 00:16:54 sed "s:^:generic/:" /lkp/benchmarks/xfstests/tests/generic-dax
2026-11-25 00:16:54 ./check -E tests/exclude/ext4 generic/413 generic/428 generic/437 generic/452 generic/462 generic/470 generic/503 generic/605 generic/606 generic/607 generic/608
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lkp-skl-d01 7.4.0-rc3+ #1 SMP PREEMPT Wed Nov 25 07:55:29 CST 2026
MKFS_OPTIONS  -- -F /dev/pmem3
MOUNT_OPTIONS -- -o dax /dev/pmem3 /fs/scratch

generic/413         4s
generic/428         1s
generic/437        - output mismatch (see /lkp/benchmarks/xfstests/results//generic/437.out.bad)
    --- /lkp/benchmarks/xfstests/tests/generic/437.out	2026-11-10 14:32:16.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/437.out.bad	2026-11-25 00:17:00.840164485 +0000
    @@ -1,2 +1,3 @@
     QA output created by 437
    +/lkp/benchmarks/xfstests/tests/generic/437: line 22:  5709 Bus error               $here/src/t_mmap_cow_race $TEST_DIR/testfile
     Silence is golden
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/437.out /lkp/benchmarks/xfstests/results//generic/437.out.bad'  to see the entire diff)
generic/452         1s
generic/462         1s
generic/470        [not run] xfs_io log_writes  support is missing
generic/503         5s
generic/605         5s
generic/606         1s
generic/607         3s
generic/608         1s
Ran: generic/413 generic/428 generic/437 generic/452 generic/462 generic/470 generic/503 generic/605 generic/606 generic/607 generic/608 Not run: generic/470
Failures: generic/437
Failed 1 of 11 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261125/202611252134.37a9cb7e-lkp@intel.com



--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



