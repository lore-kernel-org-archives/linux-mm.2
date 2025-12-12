Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D605D43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 05:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF83E6B0005; Fri, 12 Dec 2025 00:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFAC6B0006; Fri, 12 Dec 2025 00:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9982B6B0007; Fri, 12 Dec 2025 00:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 877316B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:35:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2ED871603E0
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:35:34 +0000 (UTC)
X-FDA: 84209706588.04.0BDC848
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5A97340006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:35:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q0Fi0xGy;
	spf=pass (imf01.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765517730; a=rsa-sha256;
	cv=fail;
	b=yiqXvjSwzcn6xYvQMfGb7Aon1Q3t56olysaTygz9UjbHHQbIeL+ycMFfYUHiPXfJbLnIDk
	i0yy8+Nz44wzNGkcy3FEWVEUJARRUuRS8ksl6/rXWZrjv4wy7LXp3iV+Ovn17392RpvqtR
	kD6j2q2q2MLEzFwnmCMJL9fqZrNn4AY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q0Fi0xGy;
	spf=pass (imf01.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765517730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cmptja4g3FvCasB5ivGWdttTB0CHkJlYouksm6LF64I=;
	b=jp4ieMv+HIYKkgKrllVuzHNMjIgRGoy5bEWazAjAcxq/ODmhrqhm2E0lrZmyJBmEVUBcop
	e7ETsz9fDNUfLSwL2fGtPKiaDVEbPoCaHHtBtUwKykTJOCACqlZWykMhTVl+PtuNHe12kG
	PCx8G88CQ1pnw00o7WkgmSO2P9aoE8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765517730; x=1797053730;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/zSgI3GauOdiCguMOqqOHDS9hlBjC/WJwbapMRJNjOM=;
  b=Q0Fi0xGyCS1Eu/sjI7Zya0nZGCNA2HWm217HuNSfujevCcSDc+BadRhB
   NNE+Qdi7715XUH2960T06PN9/38Uu0dn7hHvEjqwQmdAHrh5gjE5cNppP
   XQXzdowlU9XOXgbmTFbQqhCYHgGE+J7+Qfga48d6PNS3KFkJ92z4Qe0x3
   GqMu4pGYUZlP+UmhdHKsBOUmQ+SBRybtNu2XPZGo7YYd8/YXUosMNb6u5
   QFfRcawXNZApfONke1BgE6RDg6IMSlNtMwuWpxdd/EUKrDHGtWMvZA5tm
   Cpf9HDuGBAPOK6ezFv7zrXpg9uHkfcU7sWNk25c7ejwEI2zsEt0mVSHX4
   Q==;
X-CSE-ConnectionGUID: YHaLUVnCR2KFDyxHHpTyXw==
X-CSE-MsgGUID: sivuCIrgRcWrO67DfkhahQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="71351863"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="71351863"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 21:35:28 -0800
X-CSE-ConnectionGUID: TkS/1esLQ9yAK1ZoHOp7Ng==
X-CSE-MsgGUID: LkFz4RN/QxCtHw9si0LCXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196280093"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 21:35:28 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 21:35:27 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 21:35:27 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.47) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 21:35:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OyzWBni6jZGHn9s3RFd02339E/wOpYWjrrtBsdDfQnu9vLOo6pdKsq1NyK69GoAud3Roy49TN/PA8BXk4bBjTW80C+I/itLGyGhjlQqEoDGahQ4t+JQGTUN2zkkgrLQBIfX7P88TAN2pq8owzNvGUnG0S/dpej/P11kFV+hJERKWOxZk9pevlmt4f+wxjpA9aFF2gTNTAB54DQ4JQYp/pCPLUDoRZ5WBTF1x6r2FHHoSXDNLxfrECB5rdI4KcnwIIi+LkwB9OQkG8BMjP/dDhM7O/llaV+D5SNcbLc4kfW+X0x/93zP4E6B57fdvtylIpbDquC4YxRokUZcrbrpZjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cmptja4g3FvCasB5ivGWdttTB0CHkJlYouksm6LF64I=;
 b=XR7JkuuUwh1rfHj4TGeTqLr0pknl8HGJkfTcjoiyfb8ApqkTuZlGiM7mp3+spIkWDWePAdIe9qxcEW14Y0oAAhllblH1BR1qSNc74CQUGb2b4n/BpxxSOhQ/WGH1k9rTio9XprTXkFvKGUTwHH1+5OTZaaX9bOGG2L0UymD7ElkUqVJaPZNiOnMa1AhzRrtPGHLP1dzbMLmWdP1oxbIekydepgb+L98ryBNNwiimhKRYAb2dY87OinWtdmwMfSwp6NW1H09Km1xaSr0KVyKgPxr5Q2Qg+VuTWaB1JwYwyFbmq8z20M95YsXo9690HAnCZqI7NfeEVb5HOrjQPOb9Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB8281.namprd11.prod.outlook.com (2603:10b6:806:26b::20)
 by IA1PR11MB7811.namprd11.prod.outlook.com (2603:10b6:208:3f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 05:35:20 +0000
Received: from SN7PR11MB8281.namprd11.prod.outlook.com
 ([fe80::e4c6:587d:ede3:2f85]) by SN7PR11MB8281.namprd11.prod.outlook.com
 ([fe80::e4c6:587d:ede3:2f85%7]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 05:35:20 +0000
Message-ID: <031db8b9-846d-4fbd-bb5c-f28c860dffbe@intel.com>
Date: Fri, 12 Dec 2025 13:35:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] mm/memory hotplug: fix zone->contiguous always
 false when hotplug
To: Oscar Salvador <osalvador@suse.de>
CC: David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	"Wei Yang" <richard.weiyang@gmail.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20251208152544.1150732-1-tianyou.li@intel.com>
 <20251208152544.1150732-3-tianyou.li@intel.com>
 <aTpTkuBkVmcSuiIi@localhost.localdomain>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aTpTkuBkVmcSuiIi@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0034.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::14) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB8281:EE_|IA1PR11MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 3689f800-09b9-415d-87cf-08de39403c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aEdBTlRTNHlZWHh4MS91cU5kZUd2TWpNWHlBNFk2bzUzVTRjYkVaQmlPcUtz?=
 =?utf-8?B?ZklYekhlcjJ5Qmxtemd1dEYzNFR1bkJDRC9IQ0lBaW5Xcm90TkFFSXhTZ0Jy?=
 =?utf-8?B?STlwV3R5ZmUwUHJJV1ZoRG1hcWdxRllFRXlyNUNnL2pvZWFyZUxoMVlBQWlS?=
 =?utf-8?B?cGl2dnZaQThVcTYzc3MyTGVISlNrS2EyZll3UklHWTByU21QS3IrdlBvQnY4?=
 =?utf-8?B?MkRoMHdUUGo0UVVrM0hxYlNlYlgrbzBMVnFUZ2dFcFhhOXBLSjE1REZnMDAy?=
 =?utf-8?B?Q3NETWJzSTk5eTFLVHMzYkxMRkNLbndCM0NCUDNsUkhVMnFIVU52c1NIWEwx?=
 =?utf-8?B?M0ozMkhrMEJVY2JiQUJUSFYwc1BHenNLTjZFWXZrNGo4ZTBZNVpCQU5XcHJ6?=
 =?utf-8?B?SmR5Z0QwSURXSHlYSDF6N0ZtMkxEOHRJZ202THUyZC81bURrY2d0Szkwc2dU?=
 =?utf-8?B?SFRqOFprd0hUSlNTUDRzSUJrSVFzYWdyb21pYUQ5MFpsbDVMVEp2c2htNUJY?=
 =?utf-8?B?L0NHOXNkdDMwcXRNOXFVM2EvamtOcC80M0NkVnc5ZmZWWENLZDN3enliekNs?=
 =?utf-8?B?cDhtRFdPNkw2UGxyMDUxUXdSTFdLOTlqUE5md3dMMjNBdWppQlR1VEJCb2w3?=
 =?utf-8?B?VzJoNTY0alZKNUVORloyM3Zpb080aEpTeGtyUlNmQWpoa29HQVRJTjZXaFIr?=
 =?utf-8?B?QlE0ejIralpnSm0wUWJxTGVyVCtEWTdHTjJsenRGNFdXbStSOVRyRm9FUndU?=
 =?utf-8?B?SEdpZXNIMTgyb2U0djRnUFNtWEQyUmJ3WGl6d0dseWxOZVJpTEZNTFBhM2tZ?=
 =?utf-8?B?TXIvVmd5bHBPZGRFTWtRZkRCZHR2M3dxUS9GeVhHelJseElQMzAwU05vejU2?=
 =?utf-8?B?UkdLc3pBZmwrK3pZTGVwdjBsQ3QyWXpmQXhRRWtXWWF5R2JkQXgxZDdYNWxU?=
 =?utf-8?B?ZzhvT0dkbU96MHZaZkh5eExHaVkxWXV1dU1DMFZoWElnYWlRNDg5NVczN3JO?=
 =?utf-8?B?ZG9vb1hZN0RUNjMwdnAvcDJmUjJNRVdCRVR1akE2RmxWQmFBd1I0dndtNmxj?=
 =?utf-8?B?c3ZHN3l2dmJucE5QY1dHdHJOY1hwbWlQUmwzR2tTVGRYTnF3eGlGL2F1MUM3?=
 =?utf-8?B?dEU1bkNQZVRwZTZGcDhCU1haM0p6UzVRUUlteGNDQkl0WmhiaXRyREMvR2la?=
 =?utf-8?B?QURIN1ZXVUxFa09LcXRlUWkxS3RRTzRqNWZUOHBhbmdEb0ZwVXNXZTFIcmRY?=
 =?utf-8?B?MFIvVkd6MU96VUZ1T3JoOWV4UUd5MGovMjhVekcwTXNmN3BoY0J4bUlUYmlj?=
 =?utf-8?B?VzVpMU94bVJZNkpnZzd1VDJya21hR2NKQk1ESHRaTEt5R3NzY3A0a0dsM3Jm?=
 =?utf-8?B?dW05WFVLMUpaNzcxM080ZVJnRFc4ZlFtdXZjY1NrM2pKSFNTTDNiTkNtNk1w?=
 =?utf-8?B?RGdMbG8rUWRxRjN3SmltblNHVFhtWktvdGZEY2p3NWE1c3lhYmI4R2dJYXRV?=
 =?utf-8?B?OGxVSzArVWxZRk8vdVhHQ3dNZmtVbEZVQmdVUWorMWZ5VmdoaUszTUd2OUdU?=
 =?utf-8?B?Si91VDJJbFlpSlpzL1JmYVk0dHA3SVBEYm8xY2ZJeFp3bENLNFZzaFZySWpZ?=
 =?utf-8?B?ejZKRG8wbVNqOU9kNVhrczZVOG9VZWoySUZ2VU8zb2FwNTVybkZqNVlubVVx?=
 =?utf-8?B?Vlk2TnMwNk1LaEZZMHVVU2tKWm44MHJTc3pKVmZqejJSZ3Q4NmY0V0VFbnZT?=
 =?utf-8?B?cTU4QlR5cmlNOGFsUFJjemZSVXBDZWxPS3Y5aFdZSkVnUEZKc1dUM2lWVVp0?=
 =?utf-8?B?aExaYnZ0ZDlkSi9nRG8vK3AzaEJ2MmFieHNXSGdqM2Q3WEFXbDg3aXdXTXRw?=
 =?utf-8?B?RForbis5eXh2eUJLdWo2S0xxd2N3VU5Ob2x2Vi9kQlNUVThwaVdBcURWV24w?=
 =?utf-8?Q?kauSOH7hd5achZFZIc5taETnHEeBt/49?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB8281.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUpzRXJsWThDSWl5MTdVaTZUOW1UcTl5THFOdmdkeGpyS1N3V1RIQjZmMGts?=
 =?utf-8?B?QUFPcjQrRVVlZzlod2VmQ1NhUDVMSmtxbENidmRPanduZlF3amF4Zi9RREQ5?=
 =?utf-8?B?cFROVVdtTTZCVTJBS240TlNKLzYzSDZNTE81dVlkbE5mVndxZzlhSU5CVXZD?=
 =?utf-8?B?bE5weWhDWW9Da1pIUklFNjY1NXVaSlBpb2tHOE1CL3BpL0pjM2JKd3B5NWVp?=
 =?utf-8?B?U0hDL0Q0S3ZHeVZiMGNtUlRmTVZwb29DU2wrMEI2Zzd3RXhVQ1lWT3JxUE42?=
 =?utf-8?B?OWhseEc0MTVKbjMxd2QrSUNnRHZyNzRPWUY4U2Npcy90UVI4UU1ESWoxWUV2?=
 =?utf-8?B?UzBjOFhlbi9IelQwZVByenZKTlcvZzRTRzBkMHdEMlZaMnZoSUk2bEo0NnFm?=
 =?utf-8?B?bHlZdFJTV0NaeVloa29ZSlFkUlByY2lrQ1EvYzRvRWtkVWc2S0NIbSs2RVc3?=
 =?utf-8?B?dXVIRjk1M2RkTkU1Wjk5WkdQV1MzaytPQmJUN2NmaldGT0NkZE9iM1NkTzA4?=
 =?utf-8?B?UE9FL005bHl1NUVQUndsZEdxbnNTVWZuSWdQa2M4Q3ZlK1VEbmh3cEs1dlVv?=
 =?utf-8?B?RExySU1Wd01BNG5EWVNNOG5vTTdZVjlBVGN6NXl4NFRScWR4aHRSS3lPZWkz?=
 =?utf-8?B?OFFWZmszTGJUczNDV0RleHJRNnJoUlAxWXRXeHFYV0REbUExNElOYWtxNFRI?=
 =?utf-8?B?Q1lHYU5EenZOcHdtZHNCN1VUVjdaRnppc25tMDBKY1FaYlVFVlBQVGtIekZC?=
 =?utf-8?B?dlVQRWI2WFdVZ1pDc0lXTUViVmJRaVhmSTlkSUx1Umd1RmZvTWZXQk4wMGJG?=
 =?utf-8?B?ck9raW9xU202Q3VWb3dHTkV5bnJxT2ZzR2dEbmtxckFCdmFRVXNOMWRPK2R2?=
 =?utf-8?B?dDkvU0Y3RWlVSGViblBSL0s0aS96RkQrb3ZoWUthKzljbDdDK0tLVEVNcUd3?=
 =?utf-8?B?MXFpbFc1ak9ZbzcyOXBJekVkWldDaS9adkRReVFVaEpwaU5pZWxGMzNEL0xU?=
 =?utf-8?B?M0lPSWVEN0dqbW9XcnRDUlFCWXI5SHBxRlRva2lwaUgrMC91dXZDc21EZ2FZ?=
 =?utf-8?B?Y3lrUEk1WXVlSmVRLzlPd29VYkZMTDg0M3VPOTc5NzArR3k1eFl2R3dUQ1Zm?=
 =?utf-8?B?dVBrNG5sR1Z6Uk5JdTJJcFlBVjlWS05WSWlIU0ZTQml3VGNiL0pBb2VvRm5T?=
 =?utf-8?B?OGpQNmx2aXVnaTJ3aGtXRTVvWlR2bUZvWlZDNHNrSGJsT29RQ3laczNQTXJC?=
 =?utf-8?B?blVsejBQMTdmTDViWFIrQkw2Tm9vSENkTmRLZW1UQ3RCQVdZak91WW9tYWg2?=
 =?utf-8?B?Ulo0WGxEUElaOGFNcTEzYTVxeEtZeFdydTVMNmtQZ2VJaTlaSy9zZzBjQnhm?=
 =?utf-8?B?T085eGZrYjI0dlBhRStnQis5R3lIVXB1Ym5sWUhCTThLZ0NET1ZWZU40QXhX?=
 =?utf-8?B?NzJHMC9YMVNrVzhxcUZQc0FoblhGQ1VNS1J4SDdMV0pqQjVwQ3p1QTNZN1lI?=
 =?utf-8?B?cGM3emtSMjNKbTIwMFZXRG1CcjhLelpYOUxKQ0lSekE5M1hKVHNXSUtXd3pH?=
 =?utf-8?B?bkhweFdTOHZnKzc5ZWU3cW5kUGt3MnptY1Z4bXVBNHZqbzJiWGlMam56SDhX?=
 =?utf-8?B?QjlXVTVQbGZuRTNKNFVacE5mb2NqV2VVVURxVnFDc2ZxcFBqaVFWVk1vSDVz?=
 =?utf-8?B?N2ZxYUtmUkcxQlU2a0crNTM0N1dyMU1xV2xrSjQ1OVdKNVJ2MTl2dDFIRDdx?=
 =?utf-8?B?ZG5hVmJwZzQwYTJna0tGZVBJQ1orMkxiSkFXUThkMlJ0YjhENmsxZGNzRW05?=
 =?utf-8?B?VHlwaGYwZFQyV1N1L1NlY0FQTmZNTzVEZ2dmcGxneGtqajhqTlB4bTFINm85?=
 =?utf-8?B?TjBUZkx3bStsUHplOHpINWdsZHZZYzN0SmphdXNVdlFXUW83bURwa25Wdysv?=
 =?utf-8?B?ZFRyRjBBV1ZpRk5YT2FGYU1HQ1JFNUNlTmMyZTRTVk1ROERGbnpHZGtWbHhl?=
 =?utf-8?B?RFE5Ky9ncDBwdkdySTRiVjBjTmJySXNEQnoybTgzNFcwK2w4aWh2M1d6NzBj?=
 =?utf-8?B?OU9UN2pPMEFyWHg4QWNXUFBnNXhkeENEWHE3MkI3TWNQWEl3OFNhd3U2bklu?=
 =?utf-8?Q?P5ar2fdGgBc2Sf5ejb6BCiiTa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3689f800-09b9-415d-87cf-08de39403c9a
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 05:35:20.5690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4Gs3Ofz/RVwJMcGavNI8C9GBokCpT4eavbnSeOsmj+Gdwr48VhlX8kggRd8bOHu7wpAdbSCXkUWTtvJ916LrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7811
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A97340006
X-Rspamd-Server: rspam04
X-Stat-Signature: g759nwbrhahmsjgfpisa7kxjrbrofe5k
X-HE-Tag: 1765517730-896757
X-HE-Meta: U2FsdGVkX19ORF+zCSS9Pr0HOp6kxYH0LH+4T8vlDqcG9rSSXFCX7InHsNmFzVj7prj1VXH+6/RcC4WFu7dXgJMDzK/LjQC7g1pmVALOGFI03/2JDF0dXri6iwY1WZtAGpMOO53LSvEZcAXJ7QLx9KaWTgUmaKXWUgMbxjyU4xkihUwg8scxcluhZ5UQhR/YpduAPaUpJnoVPu92rO0kD8A/9T159qCDzMMLZToWyOQJO9d7iDocuXTtqvyYyR52E48TajTQGKcG6nb0qttPjBiel1vBSkDC26u0eHvUGhWyy7NiKHWLVwf3chS7e5Kzh4Ca8mF12EAPgImDjjdGjAvGL/ii7vPPi5P0+8dB9DuT1yHjJHYVZzQEJuTt1vWFx3YBRcyyty7WJdT7mBxtoCUnbi9ULb0nts3R8b7v+GspbXDo7gNWK/ztwdDoQ+QK3UBwNtxK2jSWJs+8okapz6QcyR0q81o6CEP5a9TNrLL/1nT2/vEuTxqCX0jnWBGk4pkI/pGvZmv5rV9D4Wzh6mrO8EJH67RtB3O8P2fLbKZsMMkke1PMoPLFU+TRSv2t9x0RttFWPiAX/VKzEvrPmQW2mpE6xJ8H9Ce4A7HUsMDMioIiNMGNgVJtG/phugMLJAaWrltmQR/Jj5saOXSt/PKajnSTzgOOpoj41kYa0Wpj6ch7/MjnjeoRlHwN5NVa3qlKT3WA79XJmbO8fKb5HuTPgo6VeuFuRUsR6C9Axn+o5NXTgED1FhrbWCCYC84q8YX0/JQeYnwp0Y2hhCdMRoN9cFcePO2YIn+9/xDj85u+32AWq0dBP2fYcTKSce9hCMm+Hi/CjnQH9CDLDdRdl0w+DGY0Wf1daAMIgx5NxvDSTlLxKQwGA+cDIBxkEmG2h4Svfu0Loi45qnQilByiqGAYd5AnEfhDGVKRlt1f+Y1D4itBwUH+/C51G+xWI48IaFsPhm1pBamKSAGj2mS
 KbOIf3zu
 1ozTB4vIB6PQqlrOZxiBSoYVNqY3IGeVgfrmbhRRnycJ7rhGbRmxog83oHzJMIGgqPGTF4SdSc02VOsIyjmIxiUQ7BCpCoAtg58p7bg9YSvDvqj1yWiWNpAA/4UVD73d/wVtFBMrMRAXwa34KoI45tRIlJAKR33Q25mL8/wSMK2ynPQR/j7PctH/4kGL0fmehkIr9uzmfCRBBuGUFbp7hJkqMeESarEipB4lE09ofV2/NpD94QVGm/PwawD8MOgamUIzpKkYKrWeXlRL0pxpnZgbsWMdwTPzyyCVc4xHGG3a6E4ugBsbshwCmTTj4JGklvXWt7AoE4KF0OEzxj+51v99Wxs+HTEWgMWk01R0L5Ru864KK7ivn7GDMp0hBkNegnHJALO5HKmwZ/emI4ikkK2xB0GbAfk9epdg16cKTBEYFX4gOslJe//cHFXKNsHigPu2NLVZ4d1PVw5F40fWY/xQP+xbJTsCBzrJHQ6ZXQye6UPzY/w/sVf8NNC7x3qZeLCr5yNo1rulxzX+tzR0fBkSYdtQoU7GdX4F/b93bmbujKsrqIdA+rafNkk5Yhw375pp1Qkgcr5/krwFw3NPVn49BptF0vQtUclv/TjT6qBdZovY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/11/2025 1:16 PM, Oscar Salvador wrote:
> On Mon, Dec 08, 2025 at 11:25:44PM +0800, Tianyou Li wrote:
>> From: Yuan Liu <yuan1.liu@intel.com>
>>
>> Function set_zone_contiguous used __pageblock_pfn_to_page to
>> check the whole pageblock is in the same zone. One assumption is
>> the memory section must online, otherwise the __pageblock_pfn_to_page
>> will return NULL, then the set_zone_contiguous will be false.
>> When move_pfn_range_to_zone invoked set_zone_contiguous, since the
>> memory section did not online, the return value will always be false.
> Then, this means that zone->contiguous was always left false on new
> memory-hotplug operations, if it was false before?
>
> I guess we did not notice this before because it is just an optimization
> so we always took the long road.
>
> Nice catch.


Thanks Oscar. Yuan Liu has done the test and compared the results thus 
found this issue.


>> To fix this issue, we removed the set_zone_contiguous from the
>> move_pfn_range_to_zone, and place it after memory section onlined.
>>
>> Function remove_pfn_range_from_zone did not have this issue because
>> memory section remains online at the time set_zone_contiguous invoked.
>>
>> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> ---
>>   mm/memory_hotplug.c | 14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index d711f6e2c87f..f548d9180415 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -809,8 +809,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   {
>>   	struct pglist_data *pgdat = zone->zone_pgdat;
>>   	int nid = pgdat->node_id;
>> -	const enum zone_contig_state contiguous_state =
>> -		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
>> +
>>   	clear_zone_contiguous(zone);
>>   
>>   	if (zone_is_empty(zone))
>> @@ -840,8 +839,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>>   			 isolate_pageblock);
>> -
>> -	set_zone_contiguous(zone, contiguous_state);
>>   }
>>   
>>   struct auto_movable_stats {
>> @@ -1150,6 +1147,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>>   {
>>   	unsigned long end_pfn = pfn + nr_pages;
>>   	int ret, i;
>> +	enum zone_contig_state contiguous_state = ZONE_CONTIG_NO;
>>   
>>   	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
>>   	if (ret)
>> @@ -1164,6 +1162,10 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>>   	if (mhp_off_inaccessible)
>>   		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
>>   
>> +	if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
>> +		contiguous_state = zone_contig_state_after_growing(zone, pfn,
>> +								   nr_pages);
> Uhm, I think this deserves a little comment.
> I guess that if we are not allocating memmap pages worth of a full
> section, we keep it ZONE_CONTIG_NO.
>
>   


Discussed with Yuan. We will add the comments as you suggested in patch 
v6. Thanks.


Regards,

Tianyou


>

