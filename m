Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1608ED79768
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 12:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6BB6B009D; Sat, 31 Jan 2026 07:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E436B009E; Sat, 31 Jan 2026 07:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636A76B009F; Sat, 31 Jan 2026 07:56:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BFA56B009D
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:56:48 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFA4013BB09
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:56:47 +0000 (UTC)
X-FDA: 84392258454.26.93B0BF3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5B0EA0009
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:56:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A+QOHidg;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf15.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769864204; a=rsa-sha256;
	cv=fail;
	b=Z3aUgUXQYwj0rodsDxtU0TXIuJJvMqiUoN9aDKWtT4uVkuDbx3EhgpAekEk4wBICZzyknl
	KcoT3RF+fJh5bLCsBLix6ljYfFxuUeIauuKaenngFiamk4QWqk6vXky45Z6h21MVXZVJ+s
	xriz13gpukN1oZxpmRgAOghdpz6v+T0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A+QOHidg;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf15.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769864204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J2p9ij9ba6ZbfMv2Bk24H66/IJwjYjD2JY93R2IRC7s=;
	b=1VKMh3c5Ph61M1sj+Q7oMvy6aXN4JnXQCzAklv3z/EGkg4cwd+q36yxfHwCUMzPGYJ4g5E
	B4UO8wbc0auxS0jIf/0ky2/6VKimCeXOEIL8JzAlHRPtVi9w5eVT0sRj+pg9KqxN0+VrEL
	4W924go1Omi03YmD4faYITTPLiH/6DA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769864204; x=1801400204;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=l1eVGAMdFfUeUP+Dk83ZtOQUFrLnZq+BHwwLEv5JYQQ=;
  b=A+QOHidg1Pwe2E2GjEfL3Baa9bhSoM1B3PNKbRKi5EpS0phRMCkR/kIZ
   1eRcnOpHmZhriFUQAl7UfaIAYjCe4ZqIfCumOJNvn7To4LYx3S/iAqLqj
   Fu1qOMghot6vJTIjfPRGyN1aTG4apxy/0eBXYium0yBbXGKNPiPs69DyS
   m7NAWEWFGVgkAvHZvWnNU7xogAeTHplCou+F/dEoM0WReTsawl/A7uOFx
   KTFtDqXH8wu8Nns/KHpb2iEPhhfs3B3QuUJFn05rgD6+lx1R6wt4w3eQo
   AAeNTEZrkMipZs4Jm4RvHSH0GlAbxYSk9fzFNCHet3udyDa+iVrWG5iAu
   A==;
X-CSE-ConnectionGUID: YT8a1yNeRBG/nwLMryRL5w==
X-CSE-MsgGUID: q891PJtmRTO4+j5vqzs50Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="74957073"
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="74957073"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 04:56:42 -0800
X-CSE-ConnectionGUID: 2nfWk1Z1S1+f6lewtqL+7A==
X-CSE-MsgGUID: qvrW2zXBQFi5d9qUlrgL/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="239787289"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 04:56:42 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 31 Jan 2026 04:56:41 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sat, 31 Jan 2026 04:56:41 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.55) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 31 Jan 2026 04:56:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3UuWmurgz2SUAHp18cfxS0cSIBiJYyZW4dZg/qIt+ekePMulYFvvj1NnuyXL1seVM53w2E7eex+iUnlUNUtMZ7syVhUW2+XK+txS8VCqhoWqaM5ZRXpq8JbO2Ob05nhxZRzgvClXATQzwnQkrzV3cvdMFp4Q6nSChgRNIlY+wUwZAfNAfIOSuU0seuYM9LXMdmJMueaJJ0Gsk1CFvR9Ze+6syKmp3iRLJa17de7Bvv7Fr3ueV/iuRqPT8V+Hb2Zz6A6F455cOedC8XHdYSa+nGWpLADHOlPmG0tjGtFED6e69pp+JFgrOLK+4liUjEMjMsjYGYpsMG0ZPCqjcCVjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtHXQBwlGcOEpIN3UhRenZdZZze5Pl7S3m+nJmjSnO4=;
 b=e8bmwEGtxis9p2u4pwO+AhnmmdSAoY4rH+Ahf76QlFXS78S1SoVGaM4ODvBh5kvkSWQboIwJ9BgN6Tp66FZNLcfmoPsHsJvEDD5QZYJ1eXTqhxa1w4LlmO9TinNXmU/iyOfoQ1R83gQGcj6TUChXb/aoPwmgDyBx5RLNwDyLus/nPW0k8vfD/kTNIhOUI0QuVOVW6wZK3l408YEfq1iK8CXuPU3L2GFwPGTZMhDpWFFiUTVQhW9SK67CYq8wQ5Yucta8rbW33pHZYnr8tmbZOP5fJCp5kK4fi5hSdRnwW5gFPggee3vq2n3ENOKsPJvOtueVpEMCFHmMo1eq64htKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS7PR11MB8827.namprd11.prod.outlook.com (2603:10b6:8:254::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.14; Sat, 31 Jan
 2026 12:56:37 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9564.014; Sat, 31 Jan 2026
 12:56:37 +0000
Date: Sat, 31 Jan 2026 20:56:22 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Andy
 Lutomirski" <luto@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>, "Boris
 Ostrovsky" <boris.ostrovsky@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, Konrad Rzessutek Wilk
	<konrad.wilk@oracle.com>, Lance Yang <ioworker0@gmail.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Li Zhe <lizhe.67@bytedance.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
	<rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Raghavendra K T
	<raghavendra.kt@amd.com>, Suren Baghdasaryan <surenb@google.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm]  94962b2628: will-it-scale.per_process_ops
 4.8% improvement
Message-ID: <202601312034.df465f26-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SGXP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::18)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS7PR11MB8827:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf3cbcf-da9d-47b5-68dc-08de60c82b60
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?hTuQqV3TCghbNdsYorTGxnQpY8XyZ2EmdWxjXAcMmNQru9mM41D2CPcw/9?=
 =?iso-8859-1?Q?mNimd5INRcjXvkOApkCW5/JSkEthGMl6vT8Dz1sTI2rLdJyd1jXmmi4MP2?=
 =?iso-8859-1?Q?+xjrWorX4HBA0Tid2Pi4rxUE9/xc0cIDJFaG+5pupfrbFD09ex2qjaCXar?=
 =?iso-8859-1?Q?8Tm9cF6Z/9d2lY/2+nxhuJ+etpsvJH2pnnm8katzKm3V6QCCa2RrxoH8CS?=
 =?iso-8859-1?Q?uDuUH3Q0MkBbNXMKVAM2g6OIe9lMUwt+W7AbCzRyHQzimU/qH1h3w6p9YV?=
 =?iso-8859-1?Q?EmiopgaP4DbaG5SPW30hcfdVWoArftt38NkRAtn1Jo3QxZXf6sd2xj6JMl?=
 =?iso-8859-1?Q?4iOSFBDF2sr09LcUJ2Lr/5QD7NQmWW6lazSIf7OmjO9s1o+KXIgIHjtLOo?=
 =?iso-8859-1?Q?AcjlgWn4UaSgKLSP1YW1t7Avo2ssh3lainR3FKSJvE0KJF3Kl3BPPSEb1H?=
 =?iso-8859-1?Q?PSGiO2eTkeags8AK0LskcXhiGTt8C0SyYxtu/s3rwAKrz4eaRKW4Bvd57q?=
 =?iso-8859-1?Q?JPO+gIHi/mWJ9GSyusr9VdQb3QK9ku4JYVxCRSGVSataB2LF/UyVZLQA9g?=
 =?iso-8859-1?Q?ErxeiEZfY+mBc8iHLGhwyEO0vj6n/7jXN9pzX0K9EDAtKz0dZ8O+rkRYOi?=
 =?iso-8859-1?Q?EM485ITvRLX+CuMkYv5SD0GCc2XI/Zqw8r/nUH6wBU5+oI6M3Oga8LV1ka?=
 =?iso-8859-1?Q?vYixdXA+Y2D1qxDtEsllb2fJ3e06IYCaDB0BKs5Aj3y91R1pl/kSC6xVMO?=
 =?iso-8859-1?Q?+3NrFYgJM6P1MO90F5AY6RnZUTN1o5EF64Hsa338HwmOEn1mkpyiPBMUUU?=
 =?iso-8859-1?Q?QEm5w89eODs3Y+pMtOZF8B6mymNuN3AzL0ts8jTdyUtU319Kj/fceSlxDx?=
 =?iso-8859-1?Q?dMecMTBR8UhKpJnN1lmYDf8zCRRd2HCt/2cBYpgMC5nRoVit2pPOAud7nQ?=
 =?iso-8859-1?Q?B52H1D7gCv4MBLAEzdwDc/VPyaNCAhumCs1ieTWZZf8Hp+ZrNxk5sONfVa?=
 =?iso-8859-1?Q?+LZhjn0Pa31U+tfwUObpp2ZQRx4csfDC+p7UJeO3aaQ45EbxagqK/7KoPQ?=
 =?iso-8859-1?Q?sT7/62URwYRH4fykQyOHJSNAn0yV2542/ibFFY6euQfAYAJXsgqtW6HuCP?=
 =?iso-8859-1?Q?N/qR5YuPLAXeAIKWh1LupSrh7gUj0hRe1CjiL2/41SWDN49GtBx5fDh2is?=
 =?iso-8859-1?Q?a1P0RWju5+OBUyS6V3WVowGKcxniAyv458yS2fKFLOd1Th5ICt2/yXx6aL?=
 =?iso-8859-1?Q?+jUeFerxJgaiO1zSEyjjv708cf0CH8ehAx5AmazSylMYlRw8Efi8zED661?=
 =?iso-8859-1?Q?8I//NEb8XAyqRRTUF1YWJvcvIOD7aHsd7wO0xd+BIp6r7Egmy29fAEavLS?=
 =?iso-8859-1?Q?cl1qiJV9XER4azT/YOlnV+pW0ZsGf/7bKn5qhr7y2L3kd4ITPN0xNbCqld?=
 =?iso-8859-1?Q?k1+W6ug4afb9nK5zDQr/toQyZdO5n1lxg6d+I/ns2loCzpxq583zuez2NV?=
 =?iso-8859-1?Q?rs+k0lCEDcsep4jFwHoXJhfWQHLZIZeiak+WwPfe/ErN2mMKeYOxDFxbvR?=
 =?iso-8859-1?Q?2HpM07Hu4lTMDI9/wlVX94W2oAwnqeKoD19WgTZpS1Knn7up7ovUYjWCtx?=
 =?iso-8859-1?Q?g6chY+94nmi9JtdwrmqT1MhRkmlw4e3qcf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HTLtj/WicID3YSLdnZdpCTJF71PGdaYAPBw+KSBUs9GvuEJWceo+AFbeRW?=
 =?iso-8859-1?Q?mX+4EXYRkkc7H8t2IfqGbonupsazpP8QzCLBHUDVulo06X2bBGXnNzXxnu?=
 =?iso-8859-1?Q?dy88wNLI0ODG3FKi0EwV0INeEOXuE2gq3Mc5suhCiwopUdG1s/ib+deDhs?=
 =?iso-8859-1?Q?+1jIGNo9enEoXQxtovt8GeL2O6Keey7W6Lw2tS3bqb8zAcmy5Ia4qjuI8r?=
 =?iso-8859-1?Q?2Leu/z3fS9T4u/PeHns1bN4N2UduR4JI6ezEMjU93OW+jOI95rPojbObqq?=
 =?iso-8859-1?Q?yzSqO2zD0xWajdA1mSfHV046XzQaTaKeuExw5U9UZLUzJQHFyRz9SstHlg?=
 =?iso-8859-1?Q?somcVyPBGVGIZ3HJ298R/rLerBmrD7PEj7SVp4FsVhUsEZ8uNQKHWsV6ub?=
 =?iso-8859-1?Q?vCs1qzPXcgPGZTm5DbWMtILDshIwlOcU1jzAf2jGuccyITxs2fyjk+cjEC?=
 =?iso-8859-1?Q?pgS2V/Q/ZxwnsrmUpkLarGGkUkAplDyv9NkomAxAWtx/z7zerABLNGR+Re?=
 =?iso-8859-1?Q?sup1yRh3gyQTJC2NcPL7qf3ThorHxKxlTN/j58rFV7vZNS/0+H4XL8xuxN?=
 =?iso-8859-1?Q?rjeIErI/D/Kt/99AMsqMbKDWHtciXzQiEqpfuQLoIvx13z1t2q+NinuYiI?=
 =?iso-8859-1?Q?6l4ANSScCwE+y8CT+B4asZfZJ4NfbE4kAu7wWSOXG8ExNPEvinoWVLzXwt?=
 =?iso-8859-1?Q?HKtWQ8Q87BTld7CRVhv7gFiuWGcR2Z7yDxekGx5dSFIY0+VtCRfRIOZrIL?=
 =?iso-8859-1?Q?SxYBbXkVN09h6ZnrIRSTdPIy9MYVL8W4R6nJFoSPBalveYeDkkfhcxaC06?=
 =?iso-8859-1?Q?P2+HNhoX0BrRv5QupIgOEyCTu008nm3tHGXQQOFfMt2y7WR1So1/vIhpKo?=
 =?iso-8859-1?Q?IZ4XMwtgFw5ADe0Xym2/vn0/40TaF3gurDo0Vcxhr0w0oLpGrUPS42N3M0?=
 =?iso-8859-1?Q?WKgpYvTDgTVaavaRfL8UH91ao1KW/1hYPiJEtAafL4dtCsVsnzM3+19HR6?=
 =?iso-8859-1?Q?O4z6z0xfQM++aeVzaZvqeWhKw820ApuakThWLlAUCFI084TaRENFEOw0+d?=
 =?iso-8859-1?Q?IAPMI3t3oGNMMnvQ6dQQmZguz1ul2oyt+m+tajB38d2SopNK9PFPggtOR9?=
 =?iso-8859-1?Q?CidG81HTCDVSrHxc6r0rSPuSmXkWTj0dG7sdg0X8hraeUPdZOLU/3IiToD?=
 =?iso-8859-1?Q?6B1FsX8Rzaj07R4S/NnUQWGasmJ6oB5essAfUadX5Woy50e46lSBgAlPyn?=
 =?iso-8859-1?Q?6KiMs5br9EG67B4MSor/utZSHpBn3Fx2BJi1cfgSolLqi0lCq+FzlK6izF?=
 =?iso-8859-1?Q?NYzyBXNjLxs9CRq5/mKxjEmrbM4w2dZIpxYtmHoY52vgpgI6a7xZFf8O2I?=
 =?iso-8859-1?Q?nmOAZA2l/otZJzncW1iAeD9TDbw3FKb7/JW1Dvj6wID4TONDyXFghOxJIG?=
 =?iso-8859-1?Q?qjCUQ/1bnw/E9jax32ClhFFXNrWhAnmchFopss2cHoxzKtW2LiFFUoNOSi?=
 =?iso-8859-1?Q?3GuZ4ZvI65vmVS7StXX+FZ3JVkuc1Uk5seFAC0rj4+a+bxZrtInhESvFqX?=
 =?iso-8859-1?Q?lA4b4X5K1Px8WeiivTCY1LT5E3ygGntZkw/TpfZWD+4+GGfb54MAt0TzOB?=
 =?iso-8859-1?Q?JwWDEF0p0tFfFliQzcbl3QrLwAYJkwcuKaoTADothyUO335OIUcuhAMlNi?=
 =?iso-8859-1?Q?6HCQ1HGkFh+qb/PywrVMG7I0fAp40rgEJSK7nU9hByHSVLLQ846GhxS7su?=
 =?iso-8859-1?Q?IF2JJ2kh/ACmADdd5YdN8SR56NXl4SyXTBt9zsCt0WEt0gLaY4rmroWOoJ?=
 =?iso-8859-1?Q?Ue/dAl4GCA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf3cbcf-da9d-47b5-68dc-08de60c82b60
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 12:56:37.2699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvmJZIEMKmUssc3gI0g7785w7JXj4i4nz88BfonoleBFqqgYf/pKktxba4/zOzWA3Q+dTBnHgoh6s0hmSHOp9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8827
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5B0EA0009
X-Stat-Signature: jsx1fjxr5crmzbzbbfga5bx8zhzxf4yr
X-HE-Tag: 1769864203-487806
X-HE-Meta: U2FsdGVkX1/mS8cFF8Vy/VyfKzh8zfBgR6hWWcshxSjvdcyybLnfmn2qblb8e7H+uHGgw3UHLfZVfN6v+aA9njf54NQ8uT4Y3CnmAT0//rQnO2S67MWLrE4aaFvvxXuDKZc4sRssHtSAXVs2CRoIIEjF0aHlwd+HzwTf3y9fFimwcGP9sUejpbvD24elXN03yS5ynBb+T5TSmCpnmRlClHV1OZGUPCnDfcW+QW9/vv5XXrJZ894x5UIQDCZZR8Y9jg2fuhY927xvZLjEYqHRxDr56MdESJGcofq2jr2skVLyDkUqamq03C/wLvW0eZtSgo1M/qjwCn9p1KJggWM8uGGZKndFeAYK7bo4q+zzW5ZWULopkS2rH6p99xaTX9k6s4wJf7Cj7PPqvF4RC/JEKWf2KY9V8huZXA4S4aG+2HWkmQkf0emyKZ3XK7gcCuJ7LU3Zl5S43Dv7JTTdXmEyoXxkoiU3dFh7tGusnu31roeO5utCLJeq2bgBw95Ih1VDrqpD9V6GK6b8QkhyWDeEjdEt/d/2ntDW5NqdbWcrWNURlpFB3fmcfUOsV3tzyTxkWV51ZPNr4jX6UwDHxy/phVYQRzauRr8ZvJNRN/zH2z/YSN8231oFWm+UM16qef1YARk3q4SK9/kkmbZaTMYQ/8we9gQbdArMz4/UT37PBaQVXrVc5lXS0WFW85hFQav+GtBEqmSfLppTNTJ5rzmclNABCLnf1hLkQeIVM/kxLXzFRuUnStxGmiGn0MmPgRUAV/k2sUVpf/lz6mBDeZMhZIN8SlJ0GgSnElGmjjexpHBzmfuVtocXBLFrM7figLBf0SqHL8TcwwN5mJsM7ltDCeDDys7f4TZJH8Cmj+1LBEGel6U6OEl+DXlOl3YOYYnmYOZ6OmrrahXSE+7q49/K8DNtmiNfm72dd9xikOhaiGLzlImogDO9AH+wxZWJq5acC+qyDRgBlARJF7HD4WS
 QRamo/qu
 NPkkdS6ppXpZfst++jyD3zZv/DaGXc22vkME9nRriJ2/JkgJ05awOvQRP7CwDbvG6E+e7/qO8uF1WxEnMi2wul9N8Nrz5Dhwb3dSJD1yn/g/KkOFxTVwagANCw6AKkhHL3YWbd7IAwJF/PAG6ePYOIHizHpv6neNI9z8JwgDJgbC7IQWb/Omg+7tzLspEii3M4eyyt9OTjmTWGOgTRUY0RFA7yDPJ6S3KRvPyvG9705TujNrzSa6xSNZmf2r+sR/MQq8ANtUgKuxPwskXx2eVSq7eAhjXMUyGHG3Nbk1EeOWnEIa0tl3uc7mK95Y1r9l+O7rL2m9JeHarjHkpXHKE33dipBUQagQef/siwwQiuCRRm2+Y7RM6bZPZAJhFIFPIhDq4VzvuzNmbOJ3bEKFk+ElhfVPIOyFwAVTzRbRgP2cLMJZPln/ocg5HZbWFrheQYjwciQTYLDtJmpzU8+2QZZwibxH5jR8ydPPNPUFR4RmVX97gGI7Vuts4RrZrcIfwkSswP2XJAErFkBin9Ky6Ohq1ksXak+e1FZN05iGOt91o2ZOL3MFD35NoJjOM5jy5QjAUMMxh0Tuf7fq8W90baIC74F5v9PgZ0ZppifoOh1IAYe+2APheTcvrGyJ01F+Ng2a64DVLsNN1DeQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 4.8% improvement of will-it-scale.per_process_ops on:


commit: 94962b2628e6af2c48be6ebdf9f76add28d60ecc ("mm: folio_zero_user: clear page ranges")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
parameters:

	nr_task: 100%
	mode: process
	test: page_fault1
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260131/202601312034.df465f26-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/page_fault1/will-it-scale

commit: 
  9890ecab6a ("mm: folio_zero_user: clear pages sequentially")
  94962b2628 ("mm: folio_zero_user: clear page ranges")

9890ecab6ad9c0d3 94962b2628e6af2c48be6ebdf9f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    188907           -20.7%     149831        meminfo.Shmem
   2571826 ±  4%      -9.8%    2320837 ±  6%  numa-meminfo.node1.AnonPages.max
     55533            -5.8%      52308        vmstat.system.in
      0.05            +0.0        0.06        mpstat.cpu.all.soft%
      7.97            +1.2        9.13        mpstat.cpu.all.usr%
      0.50 ±  9%     +66.5%       0.83 ± 11%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.50 ±  9%     +66.5%       0.83 ± 11%  perf-sched.total_sch_delay.average.ms
  16857808            -5.8%   15880074        turbostat.IRQ
   1047246 ±  3%     -43.1%     596149 ±  2%  turbostat.NMI
  13326899            +4.8%   13968231        will-it-scale.48.processes
    277643            +4.8%     291004        will-it-scale.per_process_ops
  13326899            +4.8%   13968231        will-it-scale.workload
      7632 ±  4%     +53.0%      11676        perf-c2c.DRAM.local
    336.17 ± 15%    +172.4%     915.83 ± 12%  perf-c2c.DRAM.remote
     55.17 ± 28%    +109.1%     115.33 ±  9%  perf-c2c.HIT.remote
    548.33 ±  7%    +119.2%       1201 ±  4%  perf-c2c.HITM.local
    158.83 ±  6%    +183.7%     450.67 ±  3%  perf-c2c.HITM.remote
    980465            -1.1%     969931        proc-vmstat.nr_active_anon
    966522            -1.0%     956717        proc-vmstat.nr_file_pages
     47257           -20.8%      37450        proc-vmstat.nr_shmem
    980461            -1.1%     969926        proc-vmstat.nr_zone_active_anon
  16479858            +4.5%   17219093        proc-vmstat.numa_hit
  16430403            +4.5%   17165377        proc-vmstat.numa_local
  4.02e+09            +4.8%  4.213e+09        proc-vmstat.pgalloc_normal
   8603457            +4.3%    8969427        proc-vmstat.pgfault
  4.02e+09            +4.8%  4.213e+09        proc-vmstat.pgfree
   7834289            +4.8%    8210993        proc-vmstat.thp_fault_alloc
      6455 ±141%    +750.4%      54895 ± 70%  sched_debug.cfs_rq:/.left_deadline.avg
    309861 ±141%    +750.4%    2634973 ± 70%  sched_debug.cfs_rq:/.left_deadline.max
     44256 ±141%    +750.4%     376343 ± 70%  sched_debug.cfs_rq:/.left_deadline.stddev
      6455 ±141%    +750.4%      54895 ± 70%  sched_debug.cfs_rq:/.left_vruntime.avg
    309855 ±141%    +750.4%    2634967 ± 70%  sched_debug.cfs_rq:/.left_vruntime.max
     44255 ±141%    +750.4%     376342 ± 70%  sched_debug.cfs_rq:/.left_vruntime.stddev
    219.53          +873.1%       2136 ±185%  sched_debug.cfs_rq:/.load_avg.max
     60.71 ± 10%    +444.0%     330.25 ±167%  sched_debug.cfs_rq:/.load_avg.stddev
      6455 ±141%    +750.4%      54895 ± 70%  sched_debug.cfs_rq:/.right_vruntime.avg
    309855 ±141%    +750.4%    2634967 ± 70%  sched_debug.cfs_rq:/.right_vruntime.max
     44255 ±141%    +750.4%     376342 ± 70%  sched_debug.cfs_rq:/.right_vruntime.stddev
      8.51 ± 12%     +67.6%      14.25 ± 14%  sched_debug.cpu.clock.stddev
    148335 ± 37%     -79.4%      30520 ±  8%  sched_debug.cpu.nr_switches.max
     22646 ± 34%     -73.7%       5946 ±  8%  sched_debug.cpu.nr_switches.stddev
    586.24           +45.2%     851.22        perf-stat.i.MPKI
 3.795e+08           -23.6%  2.901e+08        perf-stat.i.branch-instructions
      1.19            +0.4        1.55        perf-stat.i.branch-miss-rate%
 8.737e+08            +4.8%  9.154e+08        perf-stat.i.cache-misses
 9.041e+08            +5.1%  9.506e+08        perf-stat.i.cache-references
     94.80           +38.7%     131.45        perf-stat.i.cpi
     83.43 ±  2%     -10.6%      74.57        perf-stat.i.cpu-migrations
    162.14            -4.5%     154.78        perf-stat.i.cycles-between-cache-misses
 1.806e+09           -22.0%  1.409e+09        perf-stat.i.instructions
      0.01           -20.5%       0.01        perf-stat.i.ipc
      0.10 ± 36%     -59.3%       0.04 ± 38%  perf-stat.i.major-faults
     28196            +4.2%      29394        perf-stat.i.minor-faults
     28196            +4.2%      29394        perf-stat.i.page-faults
    483.60           +34.6%     650.80        perf-stat.overall.MPKI
      1.92            +0.6        2.51        perf-stat.overall.branch-miss-rate%
     78.25           +28.5%     100.54        perf-stat.overall.cpi
    161.80            -4.5%     154.48        perf-stat.overall.cycles-between-cache-misses
      0.01           -22.2%       0.01        perf-stat.overall.ipc
     40822           -25.7%      30316        perf-stat.overall.path-length
 3.784e+08           -23.7%  2.886e+08        perf-stat.ps.branch-instructions
 8.706e+08            +4.8%  9.121e+08        perf-stat.ps.cache-misses
 9.009e+08            +5.1%  9.472e+08        perf-stat.ps.cache-references
     83.08 ±  2%     -10.6%      74.23        perf-stat.ps.cpu-migrations
   1.8e+09           -22.2%  1.402e+09        perf-stat.ps.instructions
      0.10 ± 36%     -59.5%       0.04 ± 39%  perf-stat.ps.major-faults
     28093            +4.2%      29283        perf-stat.ps.minor-faults
     28093            +4.2%      29283        perf-stat.ps.page-faults
  5.44e+11           -22.2%  4.235e+11        perf-stat.total.instructions
     86.63           -58.6       28.03        perf-profile.calltrace.cycles-pp.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
     97.92            -3.3       94.64        perf-profile.calltrace.cycles-pp.testcase
     88.40            -2.3       86.08        perf-profile.calltrace.cycles-pp.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     89.13            -2.3       86.86        perf-profile.calltrace.cycles-pp.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     89.28            -2.3       87.02        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     89.18            -2.3       86.92        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     89.49            -2.3       87.24        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
     89.48            -2.2       87.23        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     89.56            -2.2       87.32        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.testcase
      1.32            +0.3        1.60        perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      1.43            +0.3        1.72        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
      1.43            +0.3        1.71        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page
      1.41            +0.3        1.70        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd
      1.45            +0.3        1.74        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.45            +2.4        3.84        perf-profile.calltrace.cycles-pp.free_unref_folios.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu
      1.54            +2.6        4.16        perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes
      1.54            +2.6        4.19        perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas
      1.54            +2.7        4.20        perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.55            +2.7        4.22        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.64            +2.9        4.52        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.67            +2.9        4.56        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      1.65            +2.9        4.54        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.67            +2.9        4.56        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.67            +2.9        4.56        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.67            +2.9        4.56        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.67            +2.9        4.57        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.67            +2.9        4.57        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      1.68            +2.9        4.58        perf-profile.calltrace.cycles-pp.__munmap
      0.84 ±  5%    +111.8      112.61        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
     97.97            -3.3       94.68        perf-profile.children.cycles-pp.testcase
     86.84            -2.6       84.21        perf-profile.children.cycles-pp.folio_zero_user
     88.40            -2.3       86.08        perf-profile.children.cycles-pp.vma_alloc_anon_folio_pmd
     89.13            -2.3       86.86        perf-profile.children.cycles-pp.__do_huge_pmd_anonymous_page
     89.21            -2.2       86.98        perf-profile.children.cycles-pp.__handle_mm_fault
     89.31            -2.2       87.09        perf-profile.children.cycles-pp.handle_mm_fault
     89.52            -2.2       87.30        perf-profile.children.cycles-pp.exc_page_fault
     89.51            -2.2       87.30        perf-profile.children.cycles-pp.do_user_addr_fault
     89.60            -2.2       87.40        perf-profile.children.cycles-pp.asm_exc_page_fault
      0.75 ±  5%      -0.4        0.39 ±  4%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.66 ±  5%      -0.3        0.34 ±  3%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.66 ±  5%      -0.3        0.34 ±  3%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.56 ±  6%      -0.3        0.28 ±  4%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.44 ±  6%      -0.2        0.22 ±  5%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.41 ±  7%      -0.2        0.20 ±  4%  perf-profile.children.cycles-pp.update_process_times
      0.27 ±  6%      -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.sched_tick
      0.18 ±  7%      -0.1        0.09 ±  7%  perf-profile.children.cycles-pp.task_tick_fair
      0.10 ±  3%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.__irqentry_text_end
      0.10 ±  4%      +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.12 ±  3%      +0.0        0.14 ±  5%  perf-profile.children.cycles-pp.___perf_sw_event
      0.07 ±  8%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.try_charge_memcg
      0.04 ± 44%      +0.0        0.06        perf-profile.children.cycles-pp.mod_memcg_lruvec_state
      0.05 ±  8%      +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.mod_node_page_state
      0.37            +0.0        0.39 ±  2%  perf-profile.children.cycles-pp.pte_alloc_one
      0.06 ±  9%      +0.0        0.08 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.36            +0.0        0.38        perf-profile.children.cycles-pp.alloc_pages_noprof
      0.05            +0.0        0.08 ±  7%  perf-profile.children.cycles-pp.free_tail_page_prepare
      0.06 ±  9%      +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.x64_sys_call
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.load_elf_binary
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.exec_binprm
      0.01 ±223%      +0.1        0.07 ±  7%  perf-profile.children.cycles-pp.charge_memcg
      0.00            +0.1        0.06 ± 15%  perf-profile.children.cycles-pp.asm_sysvec_call_function
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.bprm_execve
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.folio_remove_rmap_pmd
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.asm_sysvec_reschedule_ipi
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.free_pgtables
      0.05            +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.__mmap
      0.00            +0.1        0.09 ±  7%  perf-profile.children.cycles-pp.__folio_unqueue_deferred_split
      0.00            +0.1        0.09 ±  4%  perf-profile.children.cycles-pp.execve
      0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.__x64_sys_execve
      0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.do_execveat_common
      0.06            +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.vm_mmap_pgoff
      0.05 ±  8%      +0.1        0.15 ±  5%  perf-profile.children.cycles-pp.do_mmap
      0.00            +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.__mmap_region
      0.00            +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.lru_gen_del_folio
      0.00            +0.1        0.14 ±  2%  perf-profile.children.cycles-pp.__page_cache_release
      0.08            +0.1        0.22 ±  3%  perf-profile.children.cycles-pp.zap_huge_pmd
      0.09 ±  4%      +0.2        0.25 ±  3%  perf-profile.children.cycles-pp.unmap_page_range
      0.08 ±  5%      +0.2        0.24 ±  3%  perf-profile.children.cycles-pp.zap_pmd_range
      0.09 ±  6%      +0.2        0.25        perf-profile.children.cycles-pp.unmap_vmas
      1.47            +0.3        1.75        perf-profile.children.cycles-pp.prep_new_page
      1.64            +0.3        1.93        perf-profile.children.cycles-pp.get_page_from_freelist
      1.46            +0.3        1.75        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      1.79            +0.3        2.10        perf-profile.children.cycles-pp.alloc_pages_mpol
      1.78            +0.3        2.09        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      1.46            +2.4        3.86        perf-profile.children.cycles-pp.free_unref_folios
      1.54            +2.6        4.17        perf-profile.children.cycles-pp.folios_put_refs
      1.54            +2.7        4.20        perf-profile.children.cycles-pp.free_pages_and_swap_cache
      1.55            +2.7        4.20        perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
      1.55            +2.7        4.23        perf-profile.children.cycles-pp.tlb_finish_mmu
      1.64            +2.9        4.52        perf-profile.children.cycles-pp.vms_clear_ptes
      1.65            +2.9        4.54        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      1.67            +2.9        4.56        perf-profile.children.cycles-pp.do_vmi_align_munmap
      1.67            +2.9        4.57        perf-profile.children.cycles-pp.__x64_sys_munmap
      1.67            +2.9        4.57        perf-profile.children.cycles-pp.__vm_munmap
      1.67            +2.9        4.56        perf-profile.children.cycles-pp.do_vmi_munmap
      1.68            +2.9        4.58        perf-profile.children.cycles-pp.__munmap
      1.93            +3.2        5.12        perf-profile.children.cycles-pp.do_syscall_64
      1.93            +3.2        5.12        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.96 ±  5%     +55.6       56.60        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     84.87            -1.2       83.67        perf-profile.self.cycles-pp.folio_zero_user
      8.24            -1.0        7.28        perf-profile.self.cycles-pp.testcase
      0.10 ±  3%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.__irqentry_text_end
      0.08 ±  5%      +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.mas_walk
      0.05 ±  8%      +0.0        0.07 ±  5%  perf-profile.self.cycles-pp.mod_node_page_state
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.free_tail_page_prepare
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.zap_huge_pmd
      0.00            +0.1        0.08 ±  8%  perf-profile.self.cycles-pp.__folio_unqueue_deferred_split
      0.00            +0.1        0.10 ±  3%  perf-profile.self.cycles-pp.lru_gen_del_folio
      0.00            +0.2        0.17 ±  2%  perf-profile.self.cycles-pp.asm_sysvec_apic_timer_interrupt
      1.32            +0.3        1.60        perf-profile.self.cycles-pp.prep_new_page
      1.40            +2.3        3.75        perf-profile.self.cycles-pp.free_unref_folios




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


