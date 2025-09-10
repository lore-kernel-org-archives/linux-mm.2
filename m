Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA7ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595268E0011; Wed, 10 Sep 2025 04:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547A48E0003; Wed, 10 Sep 2025 04:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BECD8E0011; Wed, 10 Sep 2025 04:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 263D68E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:24:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD9FC1A07D9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:24:01 +0000 (UTC)
X-FDA: 83872652682.21.6DFB048
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id D71A280006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:23:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mNvz5z1N;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757492638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8U+Pt1K//jwGdtFwdNoyT+KdjwJhZrb6GsuR2FFSf90=;
	b=bxvJ6SGK2YS9zDEixD77F61V9qRGVdmd6U1fe6oq6KFG8ZOPOjkHgvOjUqE1Ju4foZ9t7c
	jd/3mivdZnqj7pGNR0G+jCRj+2+/NZSPieMGixDR8Dxv2w9xrXmO5EjETQjwaa7E2ofPVI
	wgTZDDZK1Xs6E5QpKWmJF8a2MkLq5I4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mNvz5z1N;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757492638; a=rsa-sha256;
	cv=fail;
	b=ZF29jMH8umc3+cb6ImWXygBXseNXLpcP3QYT4XD5OKjdozQCua5C/YaLvlktzIltxL9tZo
	lzWjBhweSXQqBRbfJF1GSH07mhZgleP+V09UM8SN5Sx9KjS/qYBf7Mn6giBAfgp5DF2VA5
	jfiQQH5VKwqZ1SLuYrz0e1/4/P74HDg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757492638; x=1789028638;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=9ATc3NID8XJREDHOudA71wbs04FGbw5KOvS4dpl+r/U=;
  b=mNvz5z1NxaMTPILeOU79MFH8qlAhhTEV53daa69+ogGx3AQfQGJodcYX
   3k2s/fJZ2V9r6obcKPU9XTIJqsJO6moEAg3YORDdTr1BWXYWUOakS5Zf4
   OThxNY+eO0lNC6iabr61NnG8Gllj3qnaC/GYO6jkf4ksAj5p+XsgPQAkg
   YErfoLY3jzqJXnoliP3Lou0Vg7oUy9d7FBqoyMEzeLgmxXa0Lxg4hD8i6
   i9D+lPVA/wYXlI0hyRxFtCfFIvcoVBJ77IyPQBKyvxH0A9uiCImtHDV4T
   pvSgeL36vfZvB+YWgvuismq55arQGqOCyNpOFmD6ZP4D+05VggsZJeitD
   A==;
X-CSE-ConnectionGUID: b1NE0msMRFuRCfLFgeedxw==
X-CSE-MsgGUID: zoMTSw3bTD2DYmWSjqvFXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="70414721"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="70414721"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 01:23:55 -0700
X-CSE-ConnectionGUID: vZKvSrNVT0i/+SwV9gVb4g==
X-CSE-MsgGUID: JEagR3QMQEa8FrBcKPaoeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="172894434"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 01:23:55 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 01:23:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 01:23:54 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.81)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 01:23:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OTmeLwTPPmcosKjgbXg7DYO2xCMJ7iyYHsUYH+5fVqfxDFuE8Ji5R4LiTr2XMrWXUb8uCnSwDlgJbMK7FRxJGLZ4Uoa5Yz4+fVnsJFPUaum8XdB3ezj5GdTiDGj5SZXv+SbrjNvb0VYpNOhXNS46N/XIXnWqmqYKYC2lQh8ljggoS1PSIi3kN1VBkZIR3NtORaOJHJDxjsro5UTsWLU9fSyxbiAxIOEng0IU5uGu9unadO9mxxJsh4HiMj47mHgRomFV1bivyiGjOkImDkiEkkar2pE31NAodHud9ZCpXEzrhJMHHRRoYLxVXn5mbRiZN8f1VSE6cgSYD3FeqQnFoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAaXSaIVoADjoz6HPGtQzawTt9gV+5J32gfTC4nKTbs=;
 b=ijgKlGmSoN2KW/ZFNMkFbNxf5KSGWSBYZ8GY2ft9IOoj30RF3DVl2JvhROUakaBbUNE9xaXCY3unV17/lN9pBRgixJqbUZg7aRllzlTCkTBvsx8bUaYYhKpqwpwg/UfLC0hdP9J87aNv9vO5748L+q9Hl7CYwVDCmKDZexG1eo/pkpnReEhlq0vzVodH6khhp55BOf41Wvo66rEiNUj+mKT73FUvGMUpNz4pCyEhtn7L6UdiV5XjyNRmScjtMJg+14a6weY9v2p68oDNYqijz8Fz/txg/ckJJMwipVZ2Ix+fS6j41byS96ybEf0xojzNUkGoBrn/GwmTR819rcMy+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by SJ2PR11MB7519.namprd11.prod.outlook.com (2603:10b6:a03:4c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 08:23:51 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%3]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 08:23:51 +0000
Date: Wed, 10 Sep 2025 10:23:37 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrey Konovalov <andreyknvl@gmail.com>, <sohil.mehta@intel.com>,
	<baohua@kernel.org>, <david@redhat.com>, <kbingham@kernel.org>,
	<weixugc@google.com>, <Liam.Howlett@oracle.com>,
	<alexandre.chartre@oracle.com>, <kas@kernel.org>, <mark.rutland@arm.com>,
	<trintaeoitogc@gmail.com>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<joey.gouly@arm.com>, <samitolvanen@google.com>, <joel.granados@kernel.org>,
	<graf@amazon.com>, <vincenzo.frascino@arm.com>, <kees@kernel.org>,
	<ardb@kernel.org>, <thiago.bauermann@linaro.org>, <glider@google.com>,
	<thuth@redhat.com>, <kuan-ying.lee@canonical.com>,
	<pasha.tatashin@soleen.com>, <nick.desaulniers+lkml@gmail.com>,
	<vbabka@suse.cz>, <kaleshsingh@google.com>, <justinstitt@google.com>,
	<catalin.marinas@arm.com>, <alexander.shishkin@linux.intel.com>,
	<samuel.holland@sifive.com>, <dave.hansen@linux.intel.com>, <corbet@lwn.net>,
	<xin@zytor.com>, <dvyukov@google.com>, <tglx@linutronix.de>,
	<scott@os.amperecomputing.com>, <jason.andryuk@amd.com>, <morbo@google.com>,
	<nathan@kernel.org>, <lorenzo.stoakes@oracle.com>, <mingo@redhat.com>,
	<brgerst@gmail.com>, <kristina.martsenko@arm.com>, <bigeasy@linutronix.de>,
	<luto@kernel.org>, <jgross@suse.com>, <jpoimboe@kernel.org>,
	<urezki@gmail.com>, <mhocko@suse.com>, <ada.coupriediaz@arm.com>,
	<hpa@zytor.com>, <leitao@debian.org>, <wangkefeng.wang@huawei.com>,
	<surenb@google.com>, <ziy@nvidia.com>, <smostafa@google.com>,
	<ryabinin.a.a@gmail.com>, <ubizjak@gmail.com>, <jbohac@suse.cz>,
	<broonie@kernel.org>, <akpm@linux-foundation.org>,
	<guoweikang.kernel@gmail.com>, <rppt@kernel.org>, <pcc@google.com>,
	<jan.kiszka@siemens.com>, <nicolas.schier@linux.dev>, <will@kernel.org>,
	<jhubbard@nvidia.com>, <bp@alien8.de>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-mm@kvack.org>, <llvm@lists.linux.dev>,
	<linux-kbuild@vger.kernel.org>, <kasan-dev@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 13/19] kasan: x86: Handle int3 for inline KASAN reports
Message-ID: <63ocq6aadqn74e7g57a6p3cqkr3sf4hmejfp6hxmuju2b42iny@2du24bomvk4n>
References: <CA+fCnZcMV0BOJyvx2nciCK2jvht-Hx0HnFtRzcc=zu+pQSOdVw@mail.gmail.com>
 <couuy2aawztipvnlmaloadkbceewcekur5qbtzktr7ovneduvf@l47rxycy65aa>
 <hw7xa2ooqeyjo5ypc5jluuyjlgyzimxtylj5sh6igyffsxtyaf@qajqp37h6v2n>
 <epbqhjyfdt3daudp2wx54jsw6d7jf6ifbr3yknlfuqptz7b4uq@73n5k6b2jrrl>
 <CA+fCnZdJckDC4AKYxLS1MLBXir4wWqNddrD0o+mY4MXt0CYhcQ@mail.gmail.com>
 <ra5s3u5ha6mveijzwkoe2437ged5k5kacs5nqvkf4o7c2lcfzd@fishogqlatjb>
 <20250909083425.GH4067720@noisy.programming.kicks-ass.net>
 <20250909084029.GI4067720@noisy.programming.kicks-ass.net>
 <xeedvhlav5rwra4pirinqcgqynth2zrixv7aknlsh2rz7lkppq@kubknviwhpfp>
 <20250909090357.GJ4067720@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250909090357.GJ4067720@noisy.programming.kicks-ass.net>
X-ClientProxiedBy: DB9PR06CA0016.eurprd06.prod.outlook.com
 (2603:10a6:10:1db::21) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|SJ2PR11MB7519:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d615ce0-7877-4c1f-6a3f-08ddf0435f8b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?O1j00+Ekys610nz9REzx+VXDlQGjEkDQkGiIRP5HYqYOTbTsyDS5q7jIez?=
 =?iso-8859-1?Q?jRfl7ulWLJgldc9EczPIQTxKQAJYM9bZNPTHT/STZJ85BPvfCoYHqXNi3j?=
 =?iso-8859-1?Q?cKTt0E6iLfJkR11xj0LeTohE2EfWyPkqMZZXQxDuTzR60Y+xJfVYVGs9Da?=
 =?iso-8859-1?Q?Ewx4jWs8scC7TpOkCz4QYh4YR238G9/MLqv7DS2zsnaU102ccnMcjIH841?=
 =?iso-8859-1?Q?vE8dfRZ6rgUvu7/auypVTkymorbBJIsbdq80GmFIUxu/ALRmqVmC4cPcVG?=
 =?iso-8859-1?Q?hty8+CiDaniDUDbFqLeLNjDVv3I7lR1F2otPp2UhoosEgCK4v6W4n57PSp?=
 =?iso-8859-1?Q?8OEdBFJTlqGUvolVD/AfUcEFdGQbvJTqDaQLGrivb/ELik8h5jVXXoiKp2?=
 =?iso-8859-1?Q?U+dchHEahE1HORDx1t7WnaFpq/zfAEy1jrKuJeZJd0GUr3Y1BvKyP3tIfY?=
 =?iso-8859-1?Q?PGdphGOYUoIVR957d3RMYFU8fn8gQxTRWI/GYZbfFc8lgYJP/lOwCVVIz8?=
 =?iso-8859-1?Q?uW3+MJIaABb6m2dWRf1ZIqNKoVdfgtQsXnmnu3kiLPlC66btKvyVLGCiNl?=
 =?iso-8859-1?Q?5vRQB/J+lOhvoww0ZDUfRBm90YERc9ZYVpenK72WGPXQJlwWXrZBmk316i?=
 =?iso-8859-1?Q?Lm2bVo2oytiG0YJ3XZU6sCgNCKBw++b8JWF3WoiC+1fxVZdpxLpk5omik4?=
 =?iso-8859-1?Q?aaEyy4wXUYa2QAYaNX9XJqiiTeQwmh6rbz1FeY7S/6edI0JC6BnQMS+ue+?=
 =?iso-8859-1?Q?jQdWkll+vEdA2r9lVglKDoF/6bHASuF4l7akCc81h9h2RnPk0I3KCukAbW?=
 =?iso-8859-1?Q?fChbpgaMSOQS5aKLE285IU4U183jRj4MGKokDXuSX3b+vlpDf+f+wFdkMv?=
 =?iso-8859-1?Q?AEZRvKIGZxAoWRUbE+ihYm8hg9DVP63r5Gf9CGP3lsnKyUD2R8209aT+x2?=
 =?iso-8859-1?Q?ucROp0pQEJxcG01dQBhtjhl+DiJAvpFmYGVAbR4P6dbrupu5yPYQ1LIMbh?=
 =?iso-8859-1?Q?l7jH+fvBFz8CJ8kb9Ws2RA9HlMU7msKU/GomCYvNwGTh35kZHt25kHCBWd?=
 =?iso-8859-1?Q?6avYhAZtJQpjv7+eqOQgdzr+ZiLLyBvvn1Gixh8deR3jnWqZNY6RXiyKYu?=
 =?iso-8859-1?Q?Frg+rbwapGNACM4WwOOH082XB8LwvuNSqNySxmmoAaEjV3lyTQCN9P8meC?=
 =?iso-8859-1?Q?uMIXGLvy3ZMEMuhzccDNm4xdYogWt7nIpd0x9yUwqmecPwWnw1tW8KHNg1?=
 =?iso-8859-1?Q?XcOpXX1w8sgS8AvqJmxHERQTFJToYieoSlyl2LfjiI2Wbm7qF40BHwBkE7?=
 =?iso-8859-1?Q?H/jQjwmrhdRr2/gCdhRvkvWKF4zJDVrs7v+8sPHKuHpTzR52ho4wxTA8ab?=
 =?iso-8859-1?Q?TXHlsZoarITgH2rn51VF+lP8D7zPbj4YAEFVHCEHGtfJhIXprPwX1fbQE1?=
 =?iso-8859-1?Q?LToKZCIhzA/26DcHVoffptrCAipesoEnzyVR8s3noA6JRbQ9/AUc9i5rOD?=
 =?iso-8859-1?Q?M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?e++uzuqBO2cjbBlUfDsfx5XzXUmH+faLilMr+EIYnrqrfbPmZiOZOPJ+7W?=
 =?iso-8859-1?Q?kQ3/D/H/aHK43WDEFBb3DUhhb545HToI1jyZG3Fm1GjkaU8XnYBpCKyjwU?=
 =?iso-8859-1?Q?kkD/oeO9uNTEWDi7n2IKKaxeYOFcGiKhOrapItCrNtisJ1dkRPsviKECK5?=
 =?iso-8859-1?Q?8AAvKQhJOcgvMhUhnQR6F8KudLDQCLNliWs90/GiPTQ2ytiJk0/blj9RoB?=
 =?iso-8859-1?Q?AZYBBNQbX5z7E7J07s66P52/M5yXlYBdqEonHCCwvly2vPb9X8sNpNrbL/?=
 =?iso-8859-1?Q?u1fYcNEt1qEWUk9shV2CAimTIDHMgRqGzapo1IuFjq57I3Ep68q52Ma3+D?=
 =?iso-8859-1?Q?xkLyoB3EuFATsAASYTdfrSZPydcAPP83mdhcHFYoPzf+7jsHv83XBhhdjg?=
 =?iso-8859-1?Q?14kbL2eCfkSaGS4w4OTUVui37heeZsIZjCgk+Gsh6B0Fv3g5GfM/IQ8fuN?=
 =?iso-8859-1?Q?NSjiEM8bFH4q6WaBuucnm0oN24+oQTt94RuAG0dVm8A3YXFP+zGfH8/RFg?=
 =?iso-8859-1?Q?jrrp4W9DJSs6YsqAYFT2e5ZOIktvDOpSgJLFI6E+1QBsWfE7bmgS9gwS/d?=
 =?iso-8859-1?Q?C+doNSddKOiCNvdfuWPuPzz+hy4qWkBW4bsuA3Mprh+HE9WCIOAyHFyBRs?=
 =?iso-8859-1?Q?18Ava7Gw/hvflMYbK4LGD+y8CQqsuomOmm9ljLHgVRPLxEfOs1KOf0m4mr?=
 =?iso-8859-1?Q?uyChuLsDu8HE5enztKCmgN8JNTXqVZeB7txpSGiSHka1MurFywrPULnRdV?=
 =?iso-8859-1?Q?ZUGZo4mGPzINld3oruplBL5uodz/OFEVzvnbWvGIwDKT6vtuWlxlIC8cN5?=
 =?iso-8859-1?Q?k+HuiOCQ+uR8qu7/scYURmMXtxf9osMOG3QSQKRaJvmHTgRu4Nn+lRyRBE?=
 =?iso-8859-1?Q?S/oj+sk6oaVEtRZljX/4AVoxyA9hMR32Yl+mkmsiLYi5/2gGIMIe03wyK/?=
 =?iso-8859-1?Q?OY0tRJjbzBMoLFL695/02akQYk1TXPD/KyPQvo7ITtpowTX64JNjJ42VAD?=
 =?iso-8859-1?Q?Dmc9+405fmYXTORjJBNQZwWIulJXBfEaMhkg/PTmCrDWVxOK8I9xnOmPyk?=
 =?iso-8859-1?Q?BgCtXHSPlWpm9ixvFdZ5z3cDb0JPjZ3RzcKkaCqwvkPWZmOnbVx0dnyUBx?=
 =?iso-8859-1?Q?CRAQ0Zzr6e3lDxgCMDVOLem4tbWOatn23oFu3/+SU7Yr0rcr542+ylQS8l?=
 =?iso-8859-1?Q?oXwe2G/dclXYaO0hZAJAkA2g/FRdUuUQJ0zQXxifG7p5umfD5/NBFCCqWQ?=
 =?iso-8859-1?Q?3st1iX++AHaz9TuwpAAqoRG/jwHnMyUUfe3xwFPSIMvuPUNX2I21TuVjMF?=
 =?iso-8859-1?Q?bg0j9zJma25eJykcCplO2xMfBYjmVHSdPHfL077VRxsCDRwWdvC5K0S8MK?=
 =?iso-8859-1?Q?9Q5k2i0yAQsua40EENs7SQz5SlpDIbCEaLOgicjKruKLlLAdEfRpTKvWV8?=
 =?iso-8859-1?Q?0zbKRcuQDauxo4LnfajhBqcf5Vqfc8YxN8TXzLKrhvhalOsbDZBFjHRrl7?=
 =?iso-8859-1?Q?08gvXqtwNEMOyJu9qGK1I7H7xoEAMV1Sf7CfLu+rayWI6PRA4x/VDGuQmR?=
 =?iso-8859-1?Q?fwuX034WzVVS4I5pQ/ICKpydxzLj3Lk7S1lUdvyk+DDwNtqkUdoagdlQBn?=
 =?iso-8859-1?Q?+v5ROGw3Yx+f7/Rab3MmJbUBKcZAEFUgXkn0ltrbVXxBWk1vDzXq+0Rs31?=
 =?iso-8859-1?Q?wbWAtWFi0zzIyG16Fwk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d615ce0-7877-4c1f-6a3f-08ddf0435f8b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 08:23:51.5114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWUa+B/zhAfZlX9LY1imQIDvmNagix3F3GeEUAbXvvB7+dXBkkEMWlLRhLfgK6BuEAlxVeB+lxhbflBZCW7IbwIAC1Z3mfGjQE/3W1hRNp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7519
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: D71A280006
X-Rspamd-Server: rspam05
X-Stat-Signature: bjmboaxacgbr9jf4yiqkrp3j5ggir1ex
X-Rspam-User: 
X-HE-Tag: 1757492637-187564
X-HE-Meta: U2FsdGVkX1+0kGaLXhmpNtrR6+M2kEjK3HrGuBYO/zHmUZIDi066EsiOFgt7TwXitV4GZJ7blTb2aLBmeGk6E4fN73124ZUAKVVE+OzttcJe34HZERoRyVYd3pErCVyntQc9csdhIklCh1Fo/F5oV4tIZPULe/9bGJP3zGjlpNGzXMbd9bhUw4rA3gug3QQ0GbW66/Bubd8XVegUvNNVhr5m8baqmfSAOoQROdbTJ3y0ZaIBHSugC1KHHiNt0y2EjPO63tFp4eDJ1I94LIwHDlaOEqI86tTMHzvrc4EJv8GH5+Xdqp/+6ZHmJco4EQmbDSMuiWF1urtHe4XXNUc4BipZxa8C8WVezV0TqvWoHdwf0mHjm+2rAPmIZSpmMilmmVl+2Ut7KkCc5rT0lU4Skxj5gtSOx8fHyoA44DlKhVyLlsDZH8QS2Wlv1PrsZ99xdy5EXWbu/1EZZ8wShCk8vUStcqUmuwodx5WKTBTfNZLKEOC9gxJ1d7d/xuE94QclktuJfkPxy2xBZk83uKf4sfxoLxSnNuhAavVOsCpNNx07eVuavPnhrLMq5ZAUAva+42KaJWGLAfwCpO58yyGebYesnLSpc+iCcICans8rfMeWDD6ygWLKoJKx8wNTIKWgk42zGVPmLmwXQWPBqnelc8OHX1S8GjMZP3J/dCxTc2HC3fdoEq1DI6KNhzD9dCaNO3x62pYk7kYWKzl1bWk3m/lH3A0hKC+ss3Q53hiAUW7NYMWIjzlWt6EEA/GxKfmaWEGXf7KU3NlwFH7TH7yEhupxrpE8vCdRtTsPrcfkKZP4bwYKHkT6uCEpyugrumHMOYAgPzDv/1xtNQVeNiLSFcAdyR/3Oi3IdBkS1bnjrIyi9yOMDBSEADE9l+szq7dClarqk2sdzCIdL7BmzKiPbz+ZaHBax+IxUQQ0apQTcQhGFz25JdwXBJ2MrmwsYGFv97bvSOzNf9h24cpzxAE
 5PCcaWdx
 /LwcFbDeuDugY/XRKphA0o3qvIldk46jY7t0g82a3ijGrhoRyGmbsR/mgzy2xInO7895x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-09 at 11:03:57 +0200, Peter Zijlstra wrote:
>On Tue, Sep 09, 2025 at 10:49:53AM +0200, Maciej Wieczor-Retman wrote:
>
>> >Specifically, look at arch/x86/kernel/traps.h:decode_bug(), UBSan uses
>> >UD1 /0, I would suggest KASAN to use UD1 /1.
>> 
>> Okay, that sounds great, I'll change it in this patchset and write the LLVM
>> patch later.
>
>Thanks! Also note how UBSAN encodes an immediate in the UD1 instruction.
>You can use that same to pass through your meta-data thing.
>
>MOD=1 gives you a single byte immediate, and MOD=2 gives you 4 bytes,
>eg:
>
>  0f b9 49 xx -- ud1 xx(%rcx), %rcx
>
>When poking at LLVM, try and convince the thing to not emit that
>'operand address size prefix' byte like UBSAN does, that's just a waste
>of bytes.

Thanks, that's good tip :)

-- 
Kind regards
Maciej Wieczór-Retman

