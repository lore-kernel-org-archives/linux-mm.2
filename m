Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08924CA0ED1
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 03:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6E28E00BC; Mon, 11 Aug 2025 23:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDC18E0045; Mon, 11 Aug 2025 23:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABDD8E00BC; Mon, 11 Aug 2025 23:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB358E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:26:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5E2056839
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:26:56 +0000 (UTC)
X-FDA: 83766668832.25.408F810
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89F43C0002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:26:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SSouMlE6;
	spf=pass (imf22.hostedemail.com: domain of yu.c.chen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754969213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LkJji+PoyJVGgqCBu8ROUYBtMjgJQEXPR7Y2rvbmV6E=;
	b=BXGDUJ2wQtCb80FGLnUo4/S4155tse184R/DBkfe6mftnSyZ9SMnGaKQSQk0e9/+/mCNLU
	A7+uMeRmdwc46KQtmtBED6laLQGRWw9iBG1ibLPL6Q+0xI5xJVWK8wkLWrBk/tYvBbD2uj
	MceFw6LSmwlFVS4uhQEh8hlf8kNHX28=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SSouMlE6;
	spf=pass (imf22.hostedemail.com: domain of yu.c.chen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754969213; a=rsa-sha256;
	cv=fail;
	b=3wvg0MIQIjfY6UTW69CEs1aquVm+/IBmtAabbxwsQM1xykXVBaM9hZz/tz5NamujODeZ1H
	A8EQ6Y9rghkyQVKzKutKFvdFFHE7LK3hIXcr9ITCLS1B9210t2PuIofvsYzfRHb+oO//gu
	uVlRHSg6aUceyWRDwa0E38lTUXW9LpU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754969213; x=1786505213;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lptoMt2jVgTKTOZhAi9zN7YLILrZmdNz24L94HWFCC8=;
  b=SSouMlE6MRDT8kF5LK0gp7LVVxLpWhKfYxjrXMiJL6aFg4zLFN4hDKu9
   qqIgSX1XjKWCesEz+VMYh6/hBb6gLClFEJnNlwmqsBuoiLrY4uurNivpi
   t6Bn5GBvCZ201llAHJNl7dUx8OT0S9KAnNGBOP/89ZojPpJ2/BKlfSO8k
   5yTwviqRN1YUu+CCjcFepiwCalrM3/Im6TynEbBDz0P519Ame4ITTBElN
   ymWbDFmCqNujTOgbLd8urBjlRkQVgkr367Y86GxGoIXHdDqDZRgQt2L+B
   C6P8v9zx8ZVCwFR+dyB4yMSc5N5AlUjOs6mykxttC2jnbS74ef1U7q+aF
   Q==;
X-CSE-ConnectionGUID: f/mtqAjZRAGYOPbjEeZtIw==
X-CSE-MsgGUID: MqnQy1UVT7iM6jAUYdbHYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="82673312"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="82673312"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 20:26:51 -0700
X-CSE-ConnectionGUID: 0UcUX7jRRNetlCG33EV7xw==
X-CSE-MsgGUID: 0DxCI0MaSDKXKaWzwqs4tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165318183"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 20:26:51 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 20:26:50 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 20:26:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.42)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 20:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NfkNGLo39B41M90Jjg92dfM0cm3brxvBLZXYpfZAnzVEivSBFKXur7lINXNE8wf+QvquNPGMT+QFrVODQQvx87dmd2ScuIjB0tfmkBTRmJ6JFdcN9q2Ag5CTItyKumlPeh+G+Sdc1mvx3x97ifhuj92Qk9PI1OUWU4NuI54MX+0bLLl44w+hgaxp+vMQCV5BNciC4eIfKlHmVC2iukRuhNd+6f7k1UsitEb1gObKr0kag9mRg08bb7oJIlvI1XOwYUkJoBlxwbw+FUS2PXRQIyxtCCrTwn2Swf3b5BKGqM/+S3KUhINpYrZZzwtwsGQbK4WQNDcKzHwgz0nJlQLTRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkJji+PoyJVGgqCBu8ROUYBtMjgJQEXPR7Y2rvbmV6E=;
 b=UoQF6iBXDNheZv5JeqIKLxdLoWn7WAXjCj0/4OBb39sMNbU9ujVmQgxpeWPRtuQEPfTZf3wJPr4c2MWblNCutQ0y802cVHCtXDsNvKmfG+MmJlZkKCirGIn4t312+C6sZ31x5Q0o+x9rd7EYQcfhCc21UAeUZ0hoxzlLnxEX3EZXs6oLbZ5/WNY0tKjPmp9El2za6R8nlezh8f+ynoIEc2nxue3xQEakNZyuzOBCuzI8w9L+R0SQssAgKFV/EI1AlTmDe/DmHtVothIfXVSHT5Z1jnrlflhC2CS9y9tbtPKZYDAqgti2OkMpjBzYENemAtJU2vC9awJsoxAPvZ4xOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH0PR11MB4823.namprd11.prod.outlook.com (2603:10b6:510:43::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.22; Tue, 12 Aug 2025 03:26:46 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%4]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 03:26:46 +0000
Message-ID: <2623ee0c-b967-44c1-a9d4-4ca7dd9929df@intel.com>
Date: Tue, 12 Aug 2025 11:26:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 01/28] sched: Cache aware load-balancing
To: kernel test robot <oliver.sang@intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <aubrey.li@linux.intel.com>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, "Gautham R . Shenoy" <gautham.shenoy@amd.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Juri Lelli
	<juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Libo Chen
	<libo.chen@oracle.com>, Madadi Vineeth Reddy <vineethr@linux.ibm.com>, "Hillf
 Danton" <hdanton@sina.com>, Shrikanth Hegde <sshegde@linux.ibm.com>,
	"Jianyong Wu" <jianyong.wu@outlook.com>, Yangyu Chen <cyy@cyyself.name>,
	Tingyin Duan <tingyin.duan@gmail.com>, Vern Hao <vernhao@tencent.com>, Len
 Brown <len.brown@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Aubrey Li
	<aubrey.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Chen Yu
	<yu.chen.surf@gmail.com>
References: <202508111054.58c525c-lkp@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <202508111054.58c525c-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::14) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH0PR11MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: df5e9f7f-3d06-443b-95ce-08ddd950108b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bEMxdHJwOWNwZTU3NEwrZmEvQzB6eitzYWVuS3ljSWVjZVhLem13aGZ4MXRK?=
 =?utf-8?B?a1hwZ0x1NWowUmI1dVYzRHNGQzRRMFEvcEdtbVFRNkUxL2tlcjB3a0ZBY2RW?=
 =?utf-8?B?dnYzcVllS1dhVE9ybmhESGJaT2l0bGxoVk1yZHorWWdraU5rWTRTUUw1WEh3?=
 =?utf-8?B?Z2VRa2o0UFVvRnpWcVhQL1p5bjdhK3dKSEh0YlYyZ01rcVdpNVNqZzc5c3gw?=
 =?utf-8?B?cnVkTExvYjVtS2RDcXl4NnR0d1NtMlVlb3YxVkpYYUdPSlRsa0Q1WnpnNDFj?=
 =?utf-8?B?N3hZQlR5ZWw0OTM0Z3JVNHViNnR4NmlyS3hKSnV0UmNqcnRzS3VEeFdzUSt5?=
 =?utf-8?B?M2Y4ZFZPdXdKYkNhbExOb08vT245OU5CT0NhRGY4ZURuT3FWZFNjb1lxbTFl?=
 =?utf-8?B?UGxDcUtxanVRRzZ2YmlIRGdvbjJqSjQ0NDBKU0lCVEZEcXdsdlFtRWlSd3d1?=
 =?utf-8?B?T2hBd2NiU2YzdStYcTZBU29nVnowMlpaVVVVUnlndWd6TnBWa3NEQmJnSVY2?=
 =?utf-8?B?Tkhzbk1JL2hJelNCcDc1dk03NzBKVDNLeUZRS3BJZ1dJdXNudUNtNEFNcmFK?=
 =?utf-8?B?TFNOQnNyWUdvNThlSHdYUHdYdnRFMUJtOWxsYlZjVDRmaWNVak9BbE4xWXl4?=
 =?utf-8?B?dFlxVjRHSU5pSUFWS1V1UFIySG96eWRVODZ4bUF1Skc3ZDNHL2xoakd2T015?=
 =?utf-8?B?MXVTU0JEL09oQW1vdWtZT0JhM1htRGhmOEJNdXV2NXJmeENRckY5ZFBNT0Zr?=
 =?utf-8?B?SzZYWG1vZVd4NmNmcmM1b2JUOXIrL1p2RCs0dHhhcVlBTWNUbjB6WUVxUXBh?=
 =?utf-8?B?ank2UnpQb1JjdThaOTRVUXdhNG55YnNIMnZlQm5wdHlod3kyTGdLSHNTZGtP?=
 =?utf-8?B?allRelVpU1ExZHg3TXAyem5OZ2dJbXBZVStLRXZYeFpHaTRDN05pVkt6VGVP?=
 =?utf-8?B?MWp2bDBWOHkzREplS3ovck9NRnpuUEw1Y2pOendqN3pPQzZnUmRoR3Frd1V6?=
 =?utf-8?B?UkFMVHZnamdVRFg0aGhlN05QWDBjTkl5U0NuZnhqbm9jZllLYXFTS2dPa3hl?=
 =?utf-8?B?bVkvbmN2cXp4U1R2NjNTMmJHYkhHdFJ0V2tvQ0JPb2x0bjYxRC9iUitjcmVU?=
 =?utf-8?B?cnc5RGVGUk9iYkI1akQ2MFdPMnBoR1JLclpsZEFreXkzUlVBc0VldDZpb0VJ?=
 =?utf-8?B?RkNBRURzTitGQTQ2Qm1kV1JWODRlZWphYXZIcGd3bXVRZjJNZXhOdjlYNUc4?=
 =?utf-8?B?bkRSeTJvZk5IclJGNFhkWTl3cmdoVVYvQ1AyRy9INXhVbFU1dWI0VVNVc292?=
 =?utf-8?B?ekhzc2N6b3gvRVpJUFV0b0dBVzYrQmJweStCZ2lMYVhnZDd2RjEzREVsakVR?=
 =?utf-8?B?b0YxcVhqY0E1cDM2cVBPY0EwRCtoL1BHTEVWY0hVeGFJZjVsT3FmMnB0WFlG?=
 =?utf-8?B?a2NHcFpiYWMzcXIxUDVNdkhFaXU2ZXlNVVA5RjV5bWpMNHRXeTlTWEV3Ri90?=
 =?utf-8?B?Vm5wMW02czEzczB1cTJOUks3YlVBV00zTXUxLzN0aE1IbFVqQThRekpoUnJB?=
 =?utf-8?B?QSt0SXdBbGVKREhBV2RKOWJHSkNuZkQ5ckNIcGhqaGdjZ2ZRRUNEZUdOK3Jw?=
 =?utf-8?B?cXNBZUxaRzR6dWVrc0tyUkhBYThkWkhRUkpmVE1CNTcwVjZnR1hrWTJtdk1E?=
 =?utf-8?B?WWg1QUdFVkxoMHRKb2pQNjdGUGR2VWZCdEpmV2dPa3lQdTBjdUhTU05JQ0ho?=
 =?utf-8?B?czlpbkZsMGJQcEV6SU5Pb1REYm1nNXZBdXJBMndjMXNEbGdCVVRGRGxnT2gy?=
 =?utf-8?B?T09qS0g0N3E3a0ZpOHhoWjBaNHVGSCtKRk53UmdRb1E2S0lLSVdIdlZJdGdB?=
 =?utf-8?B?bmdaTjQ5Yk5KV0puQytrOWNpdVR2aUpwdTNXRlF5dXU0eXc0NHEyRHVRSkhJ?=
 =?utf-8?Q?H2y4qHi74xk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0xueldpQm9Da3l2NEpzQ2xTSTJha2ovNzNYR01sVWltQ1BoQzlXVllUUVZw?=
 =?utf-8?B?Q2tFR001Z1V5VFhZK3BiQ1dGMHovZ1ZRYmEzclpmS0pHWXQyRHZLc09ib2tq?=
 =?utf-8?B?L096akRxajVNaGw1QnFWdkVvSU9ySTlyT3hNSmRxakc1Z3d0bGFDVm1LaXJY?=
 =?utf-8?B?bkw4aE9ZTHRLaHQ1Vk5PZmN3NGphalBPaHRxOGhXcWhTODVhMUxrRFVFanpO?=
 =?utf-8?B?UFVhM3J5eEx1SmxDeFplWHhraTFVSDNKclVyYzdwTXYrSGJSbnhRYTRiQnc5?=
 =?utf-8?B?MW9CSDZrVCtMeS9IdWt2cTMwWmplM3p5MitHRkZ4RGo0Qk1MK3VPdG9wU3Nk?=
 =?utf-8?B?NlBhaWhkSVA4U05HcjlKMWhVR25mYk1zYVJ1Z04zWFBWbGpKeTA3Vk45SHpJ?=
 =?utf-8?B?bENoeUplQkF2OWF0djE1UW1qVE5zRkJoYjBLVlZ0eE80dmJCeGZnVk9hSmZr?=
 =?utf-8?B?citrd3JzWXJPTUFMNTlTODR4VGl3RVAxZzQxbllUWkZYRzJXTmwxdEprUFlZ?=
 =?utf-8?B?K3o5RXVoL1dDMDYvZUZKdmw0R096WGNhWHY4di9DcXFwWGpEdldINk0zdWdk?=
 =?utf-8?B?bVl6ZzI3TCtQN0xTWHNLNnVOVjhCMnZvdi9LWUJhY3VyZ05nTDcrelN3aFY0?=
 =?utf-8?B?QVo3bEdTY1RMaHlnbGkrTk8xeVBHTnAyeEc3cFRlYmhUcGV6S2lqdkRFUEJQ?=
 =?utf-8?B?MG9WSUxXQ2czQlhmbDJ2bEl1TzEvK05wKzZkMWtJeVRhTWsxdmNCTWh4dS96?=
 =?utf-8?B?by9VTXdIaXpaWXphU0VuYzRDd1hTUWpDTnQ3S0JYZFVHNkZiaXpwenFZOFFK?=
 =?utf-8?B?K1VsMG54ZTVHY1Rqem1RWmRsenZVVXNhU20vNVRrY1ZVUm51MTUyVVUzV3Rl?=
 =?utf-8?B?SHIrRVJpZ29rTytuN2RnWWxsdEtPbHR1ZUQrUjR2V0x0NlZQeFlSV2VmeEZq?=
 =?utf-8?B?Vkd6cjdUejMvOEhrbjRvdWdjSkl3L3FEREQxM0M5N3lsWGJOaURFTHI0cEhp?=
 =?utf-8?B?RWU1TVR0VnVvcEdkQytZRWZacGl0WFAyb3ArR0ZRNXdEK0w2NzdYZlNGWWUx?=
 =?utf-8?B?UUpHcS9iRDBVQXc4N3F0cVVBblpzSUFGNEZyVzlkdzBBdHQvblBEZGgwTDR1?=
 =?utf-8?B?aGdHZ3dWV08zbnUxd1FaM2JHYmxIQjBPTGkxb2luWGJxNjFlMlo4b0pYb3Jq?=
 =?utf-8?B?RXRaZUVJM0c2eXRzMmJoQnYwdForSVhLcitMNlkxcC9KQUpiY0ZuNEVIN0Nw?=
 =?utf-8?B?WDg4aWJOZERURTFMUVRnbGFtaTFXNW5TOUY0c2g4MVpERUNOQi80VUVqMDF2?=
 =?utf-8?B?RFpNUVVSNFZKOEQ5dzlqeTVtVGRub1o3b2M2ZFJESFdmNVJZMDkwcVljQ0sy?=
 =?utf-8?B?UnFHRGJyNzBvU0ZlM0ZvR1BjY21tM3RBNU9obHJ6UkhxR3JiUXlCbDdqQTBP?=
 =?utf-8?B?MzdMT1BtdU5naGt5encveC93MWkvRUM2THVFcGE0bFl1Yzc3WmNCb0YvNk9O?=
 =?utf-8?B?TDcwQ1dqcXp0RmJtSFJiZHNkMnVaTTZudG1taFBqVEFocnRDajNPWTdtSXpY?=
 =?utf-8?B?Ylk0YTh4L3NOZDVRNHoxQkdmSXlGUHZlTDhHaHpVekNhZFdyQ0tXVkdNdmVG?=
 =?utf-8?B?Z1FjNGx3MGFhYklVem1mYXJVWXVUMnZJb0NVbWp6NlJYeGt0TEgvak1qRmx1?=
 =?utf-8?B?dEhSOUNiWno2WGVHMlQyaE8rRWpzL2phTFA3dE9sVm5GZVYzK3RvNW93ZU1U?=
 =?utf-8?B?QTYvSnBlR1pRUnJaTU9Rbm5KcUxhcTFYTXpzL0Fzb1pJN1l2N2dscnlxcHhn?=
 =?utf-8?B?OVUrQ0Y2VllBalQvcWQ3d0o0VldKRkxDc3hzNTk0T1hpRjdZZUpnenZsdUNp?=
 =?utf-8?B?REJGdi9ydk9vSmEyMzNCcUwyUjdKZHNROWlmQlJxTUI2YkQ3d08wdWQ1SjZW?=
 =?utf-8?B?Q3hyY05LTE00S0R3SmNLYWZUWlAvZDg3NW0rMUFmQ1RjcUlwb0pJYmZER0Zx?=
 =?utf-8?B?V1htNFladUh3VzRNT1VNeWJWQmlYLzRvbE8wcDU1NkVDVTkzUEJxTFdGbjUw?=
 =?utf-8?B?MTFBRHdmYlE0N3FkUlZ5QVFrazlDc2VCVjNzRHpGRHNuRTRyZzRhV3hiWS9U?=
 =?utf-8?Q?/FgiYjnrbqqqfNAHN93Fc33Pl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df5e9f7f-3d06-443b-95ce-08ddd950108b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 03:26:45.9544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8hj3cuszralpGKGaueymChnGWOL+Cjvz39ecpye/fwjnaBVi+F7MwZ8tCXWOhzMFcw3+FQItvpJAqR/kl8uxbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4823
X-OriginatorOrg: intel.com
X-Stat-Signature: geu4fw7hajgsau95qs7qahtsgpytboiw
X-Rspam-User: 
X-Rspamd-Queue-Id: 89F43C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1754969212-530699
X-HE-Meta: U2FsdGVkX1/IgRnwTBJ66ArS7XQK2nV+rkpYoa5cI6lt4Zu4SsW0MendFyUoPH9WbF5/Om4q8tijSDoaNfPT6ZTpaqaiEnBTvQ7BWMuBvWaOMPvzg+hELiNHUebIkk1x8SHBRQzsVCw2gLat4/ud0piUjEE9Fg5fe6p3wtACvvDVQ473ApnA4o50rMJsRruDy7dB8jscdWatpH7E1yap9naAv5vwdqnfkb00laYeWkfb7xMK0KyXaRCzAf0sQy9zWEQScYhTcA20OkpWDIDfe9TaQEZAi47QKRLKFKDbXjwx6AuYinl5BVYCfEPgMIEPiCWAIsglBtT0wygv0SKePonObV2XO1OjfhM9sy2yMI7s5U4/Itbvz7GATBrVRfTkk8v29UYsU8oSDTxTs3LJY9Lp+75Wa4WOhQFwYsOxpnmwMCEyZaIsQbZPGpv8766Mv63T+H4pyZFxCioMvYJHR0UC+CwN4DRlN1nwpziXMn0I+XgqL16qi75xjXMJUwRHadWzL2ryT1FUGyruI7sF2wXkGX0z6yNq600/cXnamDH9/brAyKN9tyPJpx979GPnl4FZyySgH95kTR4eNPucH08xOfi+jk7WlgTwe+MT77TA/+sy4o1vDf8ZiZezHPdiKh7UB/4o9voZRIy2V5NiK3f5qwVthwED2Z09qhyUPMvmYmePYMA3hpfkRh9BMrIFJWRD03hXMi/0gdPHHsp0LKNaakw3FBeXCJ5nyz+YOV9wZ0y3WRDeTD0hsvMUx4Lu4zQYEkl4ZnKa7bYgXAWSEO0UUf+lEdiddSrLtBuVOBaMvpEd6zd8V92554WQzTz7ezk2i8znJEmIc647lfUh86SJ1M3kxXsVIKpcdlaEyGxDnUJDlb5kTz8Z1K7Gq/zbg9BhdEfjEaHstyUPIEzm1nGcU91MB03PlXgdRHfdX+UAr4dBId9vhzxDSVtanh/7RmCTeZDehof6c0RecIM
 vlNwhLjJ
 JFRHkJIn2k9HEA3JxkRcrmarzTos8gq/YaWOMX64ylEca2HLPAvN344hsHjDGhKk839ZimA09a3OevgQ83Hll1kmEbiIm1wJYKiL2UPJFl4y+1r5gsW95p+M/PsqFntCu/zjUPGtCkHWVhOXCB9ZtKyHMx7JoR2aHUsZovfb7qFKlXVuXxOJW6w7mevePa6fsRMy+aUgMqnmTZvlX+I/bs4tdVq+HnpYVibRY2hSHJrAgQpquRbPS8hQgyqwiML+heqAaokgbNe1gJeM4S3Ts7jTFzQHqpYemZQx1fEYHW+78LxrgK6V/KXgwDTBvTRuxxHdaFjQagu8Behdg2+02e0s3zsoZeMoQyYd4wcZzpCR+uayjmhH4eJcSbUARTmcAQgUU6hKurzmzHlHJLUW7IFw+n/DOgdwrQARQ5Nc4KDQH3NyFKOaaYaRom92FvYFkSCKU/45AwRz7meNC9eHkd4fjwv1DbagWGgGVJv9JlF4ErXuiNxMJVci161wfw8Na748zv4gwuR31CXOhFF2HjI7aac6dVnBZkEkLX+J8+vj5SYn4V+e9c8FZpJAhPG4rUD1obxYBfZHAa8hL213wtEKOwvLdAZ8LtuCic0TTteCQE3ytii79xZiNcfyp8uuKIcnHdBSQ2MAF2rA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/12/2025 9:30 AM, kernel test robot wrote:
> [ 18.146207][ T63] RIP: 0010:_find_next_bit (kbuild/src/consumer/lib/find_bit.c:156 (discriminator 2))
> [ 18.146207][ T63] task_cache_work (kbuild/src/consumer/include/linux/find.h:71 (discriminator 2)
> kbuild/src/consumer/kernel/sched/fair.c:1325 (discriminator 2))

This should have been fixed in the second patch:
02/28 ("sched: Several fixes for cache aware scheduling")that the LLC 
sched domain could be NULL and we should skip the
NULL LLC sched domain.

It might be more applicable to test with the whole patch set.
As this is a RFC version and we will create a formal one with
the fixes integrated into the 01/28 patch, after the issues
have been addressed.

thanks,
Chenyu


