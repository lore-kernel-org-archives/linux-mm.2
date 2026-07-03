Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E4DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB1B6B00D4; Fri,  3 Jul 2026 10:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B976B00D7; Fri,  3 Jul 2026 10:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0666B00D9; Fri,  3 Jul 2026 10:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08E8B6B00D4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:15:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F7BC8B5E5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:15:19 +0000 (UTC)
X-FDA: 84947662758.25.A970A64
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9DFD78000F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:15:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EiOFvREO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783088117;
	b=EMTeR6dGudDqhTsNrmxQ05SV/z3nLAdJfu7I3EbhY/0tAYVLAHF0D60vAiq9xMSM3cdyE3
	kRHD2PRaSWKKFV16OH6EfTzWZtrVdhLJCjP3s+mOt+35325KKLgTzXhMwxcqg6mHGld9Xa
	98JamZZZs3HlIBWtAW5DsSLcf4WwdC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783088117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=VVlWcHvzBGVvtRU0HZNkUmHXt1mZuFkEhcfNnKYjfKA=;
	b=EEYUyy1MG3Ll99rusUsKTchmdJXM0mdce47+nZNyjNVjMhbd54W9MNLnD1u8uBdJZx4jK4
	NnOznciojFSi7tkWr/SCgcrNhfJBb+wiUjOZcgY+pHbdsG/rEHpFmcmj1A1SHtBZyRL8IQ
	BygEAkp88zg9dgCjyfg7CQ5Nn9TKdz0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EiOFvREO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783088116; x=1814624116;
  h=date:from:to:cc:subject:message-id;
  bh=mssUN9MRux+VdHWpXmTi+DJe1noOKFImv4q9eLM5sbQ=;
  b=EiOFvREO8FZSuQOmyUcK5eBnq02kcJYD4T0rMtPWwl6/WCMdLU1ESvg6
   ZlU25v0Yc5ZiSC2suSzowuLRogLzatbO17SczA6veUZ/s3dH+zq7pKWm1
   QRLzVkv7SFIpkqb7vwQDGvEvlYeVmnRK3XEwF/13KGHhqbLtUFrGObLFy
   P98IILODpabsu3GcoTwriCzo6EHVVZc9vY0MTDq+c7FbyYBR4CRLES+Qk
   XTMTp4lHqlTzjpTlOXEJLcKzADe2+W+ZKST3TNlLCzKOdesRxv1mDgx5R
   ov3iQ+gR0KoTd0DRV79vCif+Rndw3YYM4l4r0MqSK5WRkHlXvQVeQ0F75
   Q==;
X-CSE-ConnectionGUID: tEvMrzHzTg+3voIBa4nXXw==
X-CSE-MsgGUID: ws8cwH+fTUWbamP9QjVBKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="101263250"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="101263250"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 07:15:15 -0700
X-CSE-ConnectionGUID: NvVg7GuqQrquyAbvLICZGw==
X-CSE-MsgGUID: H10oQFSMQL2oRE56n2HspA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="248675895"
Received: from igk-lkp-server01.igk.intel.com (HELO e5a8ed462067) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 03 Jul 2026 07:15:12 -0700
Received: from kbuild by e5a8ed462067 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfefe-000000001Wz-3EcE;
	Fri, 03 Jul 2026 14:15:10 +0000
Date: Fri, 03 Jul 2026 16:14:58 +0200
From: kernel test robot <lkp@intel.com>
To: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 43/44] htmldocs:
 Documentation/accounting/delay-accounting.rst:237: WARNING: Block quote ends
 without a blank line; unexpected unindent. [docutils]
Message-ID: <202607031654.P4fsMqo4-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: i7tjzzaqe8xbn1z7urk931mnr9rxwab5
X-Rspamd-Queue-Id: 9DFD78000F
X-HE-Tag: 1783088116-540498
X-HE-Meta: U2FsdGVkX1+O62GDaB1fTv+SdLKGUT+UiHfB0keTBqfp8LxN7rVN0asr5Uiw5P5T/Vkpt6zYPHO/hNe4zBXhFoC/2VIgms9R//yz/nutw7BscFodMG4qG5/HhFBgYq/yyMrY0XwpQZtjz25WQTcK2glqamEJA1dlve/pU+jATRd+OoxftHh36laVkbVA2oYtTbK36npawTQ6wE17QTjr/dv/gLr8+HOYx3XpPcLwx14RLVNd/rJu4nxmBne8rwkQ288N3RUO93IGYc+ZJ5qSySMT0Ndg4Icxyn2dz4vAiPb3bprfFOHsGvs/4TXMisvxOv0pAnb2hkwH8F+W2a0+lcjnuBNKYUFMMQATuoo9VjmT1Z7tcV+q36aGRJBc3+qmIWVooK2iGh1hpwnxB40ETc29rMB5V9EaoDeDv/sBTQt97eMySW0UDeH4RhnCO/Vt9iNbZk5TehpOVJN6+ptH88cai+RfLby3xMrMwWPgwEICV58DqHaI1mQP2OXknTRwnx7bGlqcCDcGh2bcWcgQb3gTltpcPI3QfNDjaHgxNLvDHyBzHRckVc3AvefV/o0UEVSTSShlF19Ngsol/IZL3SszgvSr1iFvQR4XVKed53GlUz2+Ranic1GtlXEV5m+Ci9dTgYA/53mq/gCPvqPVl1uc2m6dbsCKDXdsNzA160IfhCHRF6EPS3Arb0go0enIubrqtlsO8Kvx5KyzvZTtheTYuHk9OdvE1efvjUDDFnUQFME9q1HvAHzI7mkiB+kMOu4vkMBywPCV7Bz6ADwOyN/m9pILavmZGEdUtzD0+/h9wfEMM+An3Sfia+vvQd5fPRll8mWNAxCMp+zvRz22vwXFZxhSOyK7qjWgHTia+7H/w+Vj+Oa/1CnJgEdZc11YKXsE7eP4AXGhAF7SAN5VHeifF3INKtEmkt/rzZkHQVduN1jdeycfrIvmhD3eaya7kPkO7MtRusXyTjDLWSL
 yp+2EGOk
 j3gsLGrRftV6FfszypVqTBLH9emuIugnkKxML7s+Qt/I/nRTXuR67XpQnTLX+NO+twh20RbjAt4WMk/TBV730QatET8w/62+EHkHqqqbd8tGjxsg1v0PeaU2JKSYcGkpGzeZkbZgqw9PguZ7VP6mCH2XWioMx+rmy8JCVXZUgB655V+aHgbOZtyY4qtwnHAmuqBHjXKqh/G+JrAzZK7hyuoYlCRdTbCmHML5AY7imDKNAJ7gFBGVClub6JstJAFaIyVoY2b2vugmJpQWtU7tEqgCYx4ygJzWOzPdS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   604ad02caddab12905643d5191b4a301d87033ef
commit: 7f18b4ec38272a00b16cb2995ebb06281e0f26d0 [43/44] delaytop: sort by max delay to highlight top latency processes
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
reproduce: (https://download.01.org/0day-ci/archive/20260703/202607031654.P4fsMqo4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607031654.P4fsMqo4-lkp@intel.com/

All warnings (new ones prefixed by >>):

   [WARNING] /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/os_mode_index is defined 2 times: ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:373; ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:243
   [WARNING] /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled is defined 2 times: ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:636; ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:252
   [WARNING] /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled_index is defined 2 times: ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:645; ./Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:261
   Using alabaster theme
   Documentation/accounting/delay-accounting.rst:236: ERROR: Unexpected indentation. [docutils]
>> Documentation/accounting/delay-accounting.rst:237: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/accounting/delay-accounting.rst:237: ERROR: Unexpected section title or transition.
--
   Documentation/accounting/delay-accounting.rst:239: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/accounting/delay-accounting.rst:243: ERROR: Unexpected indentation. [docutils]
   Documentation/accounting/delay-accounting.rst:244: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/accounting/delay-accounting.rst:246: ERROR: Unexpected indentation. [docutils]
   Documentation/accounting/delay-accounting.rst:247: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
>> Documentation/accounting/delay-accounting.rst:249: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
   Documentation/accounting/delay-accounting.rst:246: ERROR: Unknown target name: "pool_workqueue". [docutils]
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/os_mode is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:364; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:234
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/os_mode_index is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:373; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:243
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:636; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:252
   WARNING: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/touchpad/enabled_index is defined 2 times: Documentation/ABI/testing/sysfs-driver-hid-lenovo-go:645; Documentation/ABI/testing/sysfs-driver-hid-lenovo-go-s:261


vim +237 Documentation/accounting/delay-accounting.rst

   224	
   225		bash# ./delaytop -t cpu
   226		System Pressure Information: (avg10/avg60/avg300/total)
   227		CPU some:       0.4%/   0.2%/   0.1%/     220(ms)
   228		CPU full:       0.0%/   0.0%/   0.0%/       0(ms)
   229		Memory full:    0.0%/   0.0%/   0.0%/       0(ms)
   230		Memory some:    0.0%/   0.0%/   0.0%/       0(ms)
   231		IO full:        0.0%/   0.0%/   0.0%/      12(ms)
   232		IO some:        0.0%/   0.0%/   0.0%/      13(ms)
   233		IRQ full:       0.0%/   0.0%/   0.0%/       0(ms)
   234		[q]quit
   235		Top 20 processes (sorted by cpu MAX delay, largest first):
   236		     PID      TGID  COMMAND          AVG(ms)  MAX(ms)   MAX_TIMESTAMP
 > 237		------------------------------------------------------------------------
   238		       9         9  kworker/0:0-eve   0.59   16.87  2026-05-27T13:32:39
 > 239		      30        30  kworker/2:0H-kb   2.87   11.36  2026-05-27T13:32:36
   240		      27        27  migration/2       1.05    9.51  2026-05-27T13:32:37
   241		      50        50  kworker/2:1-eve   0.50    9.13  2026-05-27T13:32:37
   242		      15        15  rcu_preempt       0.11    8.98  2026-05-27T13:32:37
   243		       1         1  init              0.17    7.12  2026-05-27T13:32:38
   244		      67        67  scsi_eh_0         1.20    4.23  2026-05-27T13:32:37
   245		      23        23  ksoftirqd/1       1.12    3.77  2026-05-27T13:32:36
   246		       3         3  pool_workqueue_   0.72    3.55  2026-05-27T13:32:38
   247		      62        62  kworker/u20:2-a   0.49    3.03  2026-05-27T13:32:37
   248		       2         2  kthreadd          0.18    2.82  2026-05-27T13:32:37
 > 249		      11        11  kworker/0:1       1.42    2.76  2026-05-27T13:32:36

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

