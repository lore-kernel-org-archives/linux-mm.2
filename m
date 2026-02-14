Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0008EF99FF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 06:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA126B0005; Sat, 14 Feb 2026 01:08:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D876B0088; Sat, 14 Feb 2026 01:08:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C8F6B008A; Sat, 14 Feb 2026 01:08:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C16046B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 01:08:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07F58C2610
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:08:02 +0000 (UTC)
X-FDA: 84442031604.28.9F64B03
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9824D40009
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:07:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cdH8R86q;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771049280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=no0641VudVeXrRHzkRSWeF2KhikFrGdGXw+29YZaO/g=;
	b=J7gwNo9ZkOGA6VE+TU/apQ+lYK+Uy3wzbpJ/kfpSv6y2APeC+mBPNv9Klc7rlUyVzQoCH+
	9Hu/LkX4Ot80QihzKPcI8/nRiEt3W0K9Bq/Ufd4WorLEBBJlaYoh85b+IZJ1MhLDqAXP2w
	UBQttgrIs3tVm5Na5l7lqaDb5no5+Lk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cdH8R86q;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771049280; a=rsa-sha256;
	cv=none;
	b=k7hBfFmoMZLRmzYTcUFJwuQcAChi6/jjPmr2VI6rZoElvtH9YXFHdaJafMaaKRxEmQOSpW
	vQpjFHPZXpbpCyM5dT0DqiVUsbUfe4mn/Qvcb3kNRBcHOnozJN3MWvbbzdQiwgHK5bIUyN
	mAl/I4DRPV/NLsCFsMb/bFL8+mIg9is=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771049280; x=1802585280;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=IGKa42nsywCL4/RfuIAFDvXFWWy+IVTktuQ3GFSXscM=;
  b=cdH8R86qp5O6TrArccwA/YTqI88O86sgPqnIKeizOVDtOnjkTTAVE3zr
   rBrgsT0O6gBM0UQrf63XZkx05F+7OlZmJJbUtolpy6NtgxAlCV2jhwysp
   ESjABkE+EFomrkzWWWjSopDkZqhItP/mvi09ZuwFz78cjuPXAGnst/KV0
   SidsNPINYr9d7kFamVulMSsHuGPEqx2sOdgVkvwtI5rFV/aNWgOG0pGha
   lnA2BGlHgdehieJROxIRUlG56rqGxFSQCRGkNghXDF2nAsShdJusz0Wd6
   Q1PpOv1w0tJSdqz5xcWRf1FENVB4XrB5WAZZzDLbLE2FbkznHzTgIUHlU
   g==;
X-CSE-ConnectionGUID: pwQMbKveTFG6ZTsaZidYdA==
X-CSE-MsgGUID: aCbdNarjQsmee77aZyyDOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="59796840"
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="59796840"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 22:07:58 -0800
X-CSE-ConnectionGUID: Uo1L4ofhRu+aVLwHTMgZSg==
X-CSE-MsgGUID: 3CKVyPSYQiWJdsZnpk6QDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="250776319"
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 13 Feb 2026 22:07:55 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vr8or-000000001mv-2JAh;
	Sat, 14 Feb 2026 06:07:53 +0000
Date: Sat, 14 Feb 2026 07:07:30 +0100
From: kernel test robot <lkp@intel.com>
To: "Bala-Vignesh-Reddy" <reddybalavignesh9979@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Wei Yang <richard.weiyang@gmail.com>
Subject: 
 =?us-ascii?Q?tools/testing/selftests/../../../tools/testing/selftests/kse?=
 =?us-ascii?Q?lftest=5Fharness.h:107:40:?= warning: format '%llx' expects
 argument of type 'long long unsigned int', but argument 6 has type '__u64'
 {aka 'long unsigned int'}
Message-ID: <202602140755.vIpuPels-lkp@intel.com>
User-Agent: s-nail v14.9.25
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9824D40009
X-Rspamd-Server: rspam07
X-Stat-Signature: ciqxwa9iimjuuw47xajozawk1x4unju7
X-HE-Tag: 1771049279-280539
X-HE-Meta: U2FsdGVkX19EvfutaK2GjjbPsCHL1cCm/0DCYi4dqZ3f6W2ABJqD/zGsh/C+UjXSBf3u136r2h0zOuayto+2MolvFf1Y0UmBzPvs3VvUYeN+XIxKbdZN2neOqf/CQV2uyxJ8hC9I9iyc6ZH2/Zbtb7ynf9Ack7bY/qKcIyEuCkqk9UVzyVcexFPZnCBIr2S4AjinyUkfdvVjAsffU2jVftqSAkkYM2RgHChXD540TCY77kGfoEREmHqhGzOcfjMhHSupjfX44TGJwOgA6o1JuoC4+KdlJJW7mft1UTCZduXGV5reJiqFsARe79Vch8W5RB2uT3UcqCg7miU/jQ4quyxJTJPttSYs16mrma21WHZGsQeiwXz/5DLmvu1NCpb1k1PwAyZoZuhdy6JaCbG34/9ZjbviX2RYahJGlMB0OtyHIdtSphiqMK3zLvG34Gqufj/5tYinPrWXiVitgA8ozMIt69h970Q1kb36Jo8X2kWV8hqsq4v2gr8FGpS3+REW8NQIjfp/b1SpLy1VlZwFHcm7JthlWT6U9kkFgZRWDDa9nUchm5nOhojN95LK3hMYd2vUuxlCEo8aZwfeWGXQOg1MrV4OP7aNBwyHhWx7YU+XwLluib4i0RbbEb5yLEb0CQxLah50O781vPDzLaOccy+pcVx0XQe5tc2oxtzGri9XYzZtcPy+N6iaG0FtVZxv7af8ONnfL9jJ5KzVOl4L+8Bok9MLUqBqr1zoWfkKQl4rBq+EdAf7kdgoYHEjTzNFspTWeV5WLkPSG3kvlh+JPTBoVm7kamYoG57MRQKei9SeflRcXoNNr5vZD21Xy6EgOJrzYkFmLYEcWGgLfaBfLXoX8QVK6GbOl3zPSW2li3468i7DBwWmr2a86V9PZRaEdeqkcSvFGQ6y+rZ795EahSC8THsLBoAdvqQ16Idl6ARaMU93H3NTy5OaJNO19blUaaGz6OuWh5lspu0433b
 NjN8H5b1
 0GbA9fh1YNj7QJSjyOzrMQphnK+dQWSyUhOwZYHm6GGG+ZoS3fmr9533LBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git =
master
head:   770aaedb461a055f79b971d538678942b6607894
commit: e6fbd1759c9ece5044d3470f30a5e2166dc9de89 selftests: complete kselft=
est include centralization
date:   3 months ago
config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/=
20260214/202602140755.vIpuPels-lkp@intel.com/config)
compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archive=
/20260214/202602140755.vIpuPels-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602140755.vIpuPels-lkp@i=
ntel.com/

All warnings (new ones prefixed by >>):

   In file included from common.h:20,
                    from audit_test.c:22:
   audit_test.c: In function 'audit_layers':
>> tools/testing/selftests/../../../tools/testing/selftests/kselftest_harne=
ss.h:107:40: warning: format '%llx' expects argument of type 'long long uns=
igned int', but argument 6 has type '__u64' {aka 'long unsigned int'} [-Wfo=
rmat=3D]
     107 |                 fprintf(TH_LOG_STREAM, "# %s:%d:%s:" fmt "\n", \
         |                                        ^~~~~~~~~~~~~
   tools/testing/selftests/../../../tools/testing/selftests/kselftest_harne=
ss.h:102:17: note: in expansion of macro '__TH_LOG'
     102 |                 __TH_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~
   audit_test.c:152:25: note: in expansion of macro 'TH_LOG'
     152 |                         TH_LOG("Failed to match domain %llx (#%d=
)",
         |                         ^~~~~~
   /usr/lib/gcc-cross/powerpc64-linux-gnu/14/../../../../powerpc64-linux-gn=
u/bin/ld: cannot find -lcap: No such file or directory
   collect2: error: ld returned 1 exit status
--
   In file included from common.h:20,
                    from net_test.c:24:
   net_test.c: In function 'mini_network_access_rights':
>> tools/testing/selftests/../../../tools/testing/selftests/kselftest_harne=
ss.h:107:40: warning: format '%llx' expects argument of type 'long long uns=
igned int', but argument 6 has type '__u64' {aka 'long unsigned int'} [-Wfo=
rmat=3D]
     107 |                 fprintf(TH_LOG_STREAM, "# %s:%d:%s:" fmt "\n", \
         |                                        ^~~~~~~~~~~~~
   tools/testing/selftests/../../../tools/testing/selftests/kselftest_harne=
ss.h:102:17: note: in expansion of macro '__TH_LOG'
     102 |                 __TH_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~
   net_test.c:1332:25: note: in expansion of macro 'TH_LOG'
    1332 |                         TH_LOG("Failed to add rule with access 0=
x%llx: %s",
         |                         ^~~~~~
   /usr/lib/gcc-cross/powerpc64-linux-gnu/14/../../../../powerpc64-linux-gn=
u/bin/ld: cannot find -lcap: No such file or directory
   collect2: error: ld returned 1 exit status


vim +107 tools/testing/selftests/../../../tools/testing/selftests/kselftest=
_harness.h

1256a525573120 tools/testing/selftests/kselftest_harness.h    Micka=C3=ABl =
Sala=C3=BCn 2017-05-26  104 =20
1256a525573120 tools/testing/selftests/kselftest_harness.h    Micka=C3=ABl =
Sala=C3=BCn 2017-05-26  105  /* Unconditional logger for internal use. */
1256a525573120 tools/testing/selftests/kselftest_harness.h    Micka=C3=ABl =
Sala=C3=BCn 2017-05-26  106  #define __TH_LOG(fmt, ...) \
e80068be21824e tools/testing/selftests/kselftest_harness.h    Kees Cook    =
  2020-06-22 @107  		fprintf(TH_LOG_STREAM, "# %s:%d:%s:" fmt "\n", \
1256a525573120 tools/testing/selftests/kselftest_harness.h    Micka=C3=ABl =
Sala=C3=BCn 2017-05-26  108  			__FILE__, __LINE__, _metadata->name, ##__VA=
_ARGS__)
c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook    =
  2015-06-16  109 =20

:::::: The code at line 107 was first introduced by commit
:::::: e80068be21824e4d2726eeea41cac6178d212415 selftests/harness: Switch t=
o TAP output

:::::: TO: Kees Cook <keescook@chromium.org>
:::::: CC: Shuah Khan <skhan@linuxfoundation.org>

--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

