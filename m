Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCF5D715DB
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 12:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187F06B05B7; Sat, 24 Jan 2026 07:18:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164006B05B8; Sat, 24 Jan 2026 07:18:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D466B05B9; Sat, 24 Jan 2026 07:18:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E25006B05B7
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 07:18:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F1FB1394C4
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 12:18:58 +0000 (UTC)
X-FDA: 84366761556.19.D815CAB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id 237651A0009
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 12:18:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c1kGzeMF;
	spf=pass (imf19.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769257135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfH0DkX25kOT190fgOqXznWBbHVbdBH5pJp9c7HG06Q=;
	b=s61OWlbhsldmApBvrd/nT82556EQR/+kM7wkin49Gn/hJ8J605lwjkXe3uNiOTlsdp7J4Q
	7e6+mDnAhFI2DJE7M/p8n/9orjHwW0M9lX3rzLN7BfW/Fgc7qi1VoxmLWsCglWSzQlkoAI
	R6VKjmTddsm9/cRBZFCIYcUniO/Rz4Y=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c1kGzeMF;
	spf=pass (imf19.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769257135; a=rsa-sha256;
	cv=fail;
	b=TjZR39WuzDpP2aeEpo+LrNOKIrfl7+u6i/skUcIGs58EhEZqWFF8EHimqpGwMfArMwvkGX
	xhnduT6OeUISXzuR4RKJ4pCRzR1f8ckVw1n8dOjQ80TMUlew2nLmVeHn5xd5SC7No7Qoj1
	lgYKtqPRneisJo+MQfEo4+OQ7EHit6k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769257134; x=1800793134;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/fAfbfHWsTZQeJBjxS7EuuoqpmNnz9/s+NLxYgWxHR4=;
  b=c1kGzeMF9qxZ0n9P32T2UeNbX4OFpMfDhla2bVhDsfctFfeEBlgF0BIq
   z9juyV0KOdcqX93Zd75KLf1js+zHAoP3/UzDbS0FwXzo/nEHZYSEJl+OT
   tPIw4nCiuL6yyhKLZS/DbnHa5l5DT1nkDnD/tpt5JN3xHIShZ4rMJwBYw
   1nWG/O1jeHXEx1NijSS3UhzdcjtbzKH92vY1rnMG2/pHLYpiW0zOw3Czs
   vWc9EPayJgZQJDaS4ylTP5iPWnXiC3YrYfeB43BtZs614n5lVogdczxKR
   wV+wRPHwoheMtF/U1MQWU5UJPtjT8Mgu/RAlOqsw+4x7B7sYLC3DMKJU0
   w==;
X-CSE-ConnectionGUID: MnS7CYGbRiS1jHHtO94jqA==
X-CSE-MsgGUID: khtXEsM+QuKJSTBxg1YT2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="81858102"
X-IronPort-AV: E=Sophos;i="6.21,250,1763452800"; 
   d="scan'208";a="81858102"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 04:18:52 -0800
X-CSE-ConnectionGUID: BFGAelESQCCcLrdNPGHKVg==
X-CSE-MsgGUID: jzPJTHoETAO1Pa5jX2N3/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,250,1763452800"; 
   d="scan'208";a="237910351"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 04:18:52 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 24 Jan 2026 04:18:51 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sat, 24 Jan 2026 04:18:51 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.20) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 24 Jan 2026 04:18:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgUBbzpqofst+u1E626E0v7XusndvOysmsyCpccKbiJOfoDkwstGY+sUobUjjrSC874ggsnUrLuEu7GW/hsVVBCfuH3mCEsYMykclxhmtpQwXNQFLKUxssowktp53lyvh7dumsEZNDK7QNYHsjaM0sG8oSJSJXVMGtmX/ITbZfJgn9jT/QUq3uRXqfydxmoN/I0FUJ1f19rRKEKPfjGt4fatfy1FqsW7AbDLtzPqjw3Wzzon7UKOhEo4d9QbQk/kfrH0ipwccw7uowJElzroiMKwsc3DP3lLAgMcCx2ZomUZRjRnj5efsJdRXRZASqk4Lfbuv09PdBqumFXy4v4GrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfH0DkX25kOT190fgOqXznWBbHVbdBH5pJp9c7HG06Q=;
 b=SUTxV2pKi9SEKSHB0LJ9D3CMhbbWxO1tfAN65Epp0sEFjyU+BOiWu2/GMcA0D1yeVgMkSbPjzWrneKHyKuNeqcW7WRgwZhPFdWIInqur0xBkWNyL8tvlT2CFGfSd4iIttMcZfaLiFOC+5b+6v6G2Ft+8XevwssjqhIix2zRBBTUyxYDKycykAkd6YYQ4K4mZQ9WyqEBxx2fA+nmmegV1BhiJbRn1tDWBI/cTSD0sohg27h9RzadLl3aSOVZI7ytGGJs0Z5Jf8PVDNBDF+e+cgHIQ6Q0hGfkfTBjWoYMGE7N/c8sE9P8ZItNDcKPBuSZDbaLIpqadKIux1qggo8MxkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by CY8PR11MB7195.namprd11.prod.outlook.com (2603:10b6:930:93::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 12:18:49 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9542.008; Sat, 24 Jan 2026
 12:18:49 +0000
Message-ID: <804139fd-e210-4387-9a63-ac76f4df66c7@intel.com>
Date: Sat, 24 Jan 2026 20:18:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/3] mm/memory hotplug: Fix zone->contiguous always
 false when hotplug
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-2-tianyou.li@intel.com> <aXIHG8MQhMRt7M5d@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aXIHG8MQhMRt7M5d@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:820:d::9) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|CY8PR11MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b84fe9b-47d8-45ee-0163-08de5b42ba7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UTVwSE5jU3RHS1ZNYm1wQlhycGN2Uk9EdXNGTXhveHdKS1hpbG9VcDk4S21T?=
 =?utf-8?B?Qm9ZaUJkNzJaYUxHMDh5eUlXZEU5bGpZL1luMllNakRZaGU1a2REQzBER0F1?=
 =?utf-8?B?VmdzY3JGbFRpQXRLV0Jva1NCRWZOUXBZK0VVSEdNRitmNURTQ2hVU09Lc01L?=
 =?utf-8?B?dWk0ektkaWlFNzlRUnNmd0pKckM2dnZzVSt4Um1ic2xtM0d4dlhJRWVuejdy?=
 =?utf-8?B?Mjg4eEdKclFKQVhGa3ZDOXZkWWhLTWQway83eU12ZjYxOHZZNmpjS0RsMUVF?=
 =?utf-8?B?WVJpc1V5NkVoYk1SSnBDeGYwbUxMaFlrdXlNc1VtRVc1aDZTVzd2WGdycmdZ?=
 =?utf-8?B?L1pOY3N6MXBkNnNJbHN2S3NkVUhtVlhaTzNXR1NRcm5kWmFWYXNlendzRkg4?=
 =?utf-8?B?ai9kTndoT3BIMkZBbU11V0hPNlJoeEwzYzBZOWxzK1gxNGlTMkZlQlVvRkV3?=
 =?utf-8?B?dWxiM1FMYmkyajJORlN3aUVjdDhrREIvbVJBVm9xNitRQkRBRmFNWmx3c2Jp?=
 =?utf-8?B?YjBqTUMxVVRLbzZWYU5GV0xqUXAyalpNZ1JCaWpzR0M1T0dFSXFhUlU0eXJx?=
 =?utf-8?B?MG1ScW9JYmlmakRrTkNGdjlxUUpiNHQwYVN1UVZBbnlZaXVXWGxGMFVPK05H?=
 =?utf-8?B?N1AzRnlqY0VuUERGbUNqR2JMb0lzQUFHL2d3am9VQ3VTRkF1UzR0b2ZOZFc0?=
 =?utf-8?B?dTFDMmNzc3ZlQVZVZHZ1ejVhR3ZFTjNlWkxhNWU1QnJrTVdvZkNNMzVyVVdC?=
 =?utf-8?B?V2FaZEhJa1pWblNmdGJyd1BoS3BXbVlOWU1ld1RFRUdCUlRZRXdLK3lwbmhX?=
 =?utf-8?B?OStWR0UvNHgvZ0FYUjk5UTN1Mmtnc2FSOUQyNHRRdUNhYnJRVzliRE1xTTJx?=
 =?utf-8?B?Nm9TMG5ZK0k5bVd6NzJaYWhndkl4MlpWemVleDF4RHFReGZqN0NCRmNudGQ4?=
 =?utf-8?B?TDZ4L3JYME1wMVV0dDBkc0FvQUpxeklQcUV3REowNkt4TlRsQTR1U2s1ZEhq?=
 =?utf-8?B?UXVEQStneW5nM1pqc1VLQWxmNEwyRHQ3blNEbDJ6TnBPek9yRUl3NE8vRlhV?=
 =?utf-8?B?WnhoS1ZRdEZPejZLYzMvZ2x2WVNsNFhSVGtwWXkwcTk2ZkY3TE9FMzdzQk80?=
 =?utf-8?B?VlRWRDloaldaT0h2YlNRK0xiUVdQU2RIeDFLZHk1bjlUcEUwbXduamxkQU5o?=
 =?utf-8?B?K3p4V0p2dTZzNUxHazhrYyswcVFUUDBJQ3NVNG5vTUN4VkFQdXBhU2lhTWsw?=
 =?utf-8?B?cEg3ZHdrNTNVQnJ4VnJOMkZRY1kxSHYzZlZraGhVd3hVRGErd1UrNmxNNnY0?=
 =?utf-8?B?dXE0SDRhdnFwUnZudDh1U1NlODd0bHlCMTdXYWdZZnpzN0ZJWDNEU2h6dGUv?=
 =?utf-8?B?SFZQa25BTEhSb3duVmgwZldZRkRhTlFBOTAxa0lycWlmZmxIcktrSXM3STky?=
 =?utf-8?B?L0dMMnVHQ3VHZ2ozcmMwZFR3ajVLb0pRMzIwbzQrRmpuZFpRQSttYWtKM3E3?=
 =?utf-8?B?d3VkUy9lYkFabXNvaHVKSG50S0xNZG9nWXdUZ1hZREQ1Z1RnbFVPR0x1RTRZ?=
 =?utf-8?B?ZUlvWjhBbzhGNEY1ZzRNT25NcmozRzh6SGZnQXJSRFJJM0lURzVoK094OHJR?=
 =?utf-8?B?WUpMNnZFSUk4c3N6SmFSQkxCUFZEdm1CRkc5dkwwaW9NUU5XenlWT0hHSjJD?=
 =?utf-8?B?YTZaZkI1UUoyemE5NUpvVXZUNmpyT0xYbk9YS2FxbmtmMVM5YkVaQjJBWUhp?=
 =?utf-8?B?NERTSTRsckluMTV5YTlHZUxuYnRFa0NGeTIwV1lFdkkrSXFrRisrMUk4ajRU?=
 =?utf-8?B?NjRiQkZnOVBub1VubTJoNHhpemM4aWZCcnZjLzlDYmR1SjVRSExFRnRTOUp3?=
 =?utf-8?B?VW9FMU5JLy96OW53S0dlNVFhYUd4S29FcTNHMlR2WngzRG5kM3RuOGNiN21x?=
 =?utf-8?B?Tm5MaUY1TlpwQWhjcmxaNkY3aXUrcG9KUXJnbHZzS2RRUzRmV3JUV04zdXc1?=
 =?utf-8?B?MXp4YTlNSi9hT0VEVWlyMzlnbGNtWjRQOURhYjN0dW1ZaHdQR3dneTFGUmRT?=
 =?utf-8?B?OStxTzVjSXZxNFBKNm9HTGlJY2srVHZFYXEzd2JiK0tUekl5K2d6WFNjYlBH?=
 =?utf-8?Q?FgR4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlEwb3FHZzV2V2RSbmJRbFNYM2FCU3N6QTZjTWhWcFZDU2lOUTI0MVEraktx?=
 =?utf-8?B?S2NOTDF2OVFHNzMrYWtnQjVYbUxvNko1bi95VU0rYjhlRytYbHltQXhCVHoy?=
 =?utf-8?B?OTVES2NwVTFSNWx1MjhOSzUzYndOWWZ0Q0YyZVVuUUZqQVRRRFBIbmNQL0RO?=
 =?utf-8?B?citva3pmaWJhUWVYd3pVMUhUWUxlaFY5L3ptK3RSZWdLM0lTTEozeUtXdHpI?=
 =?utf-8?B?VW5sVjhkUjgybkVLUnVtWmRUOFIvaFlmekxVRWFtNEVHbFdmNS9JQ29LN1VP?=
 =?utf-8?B?S0J0Rm5ycWZJRFJ1dU4yZUEwank4cXpGdndWNlVxTW9NUWpCNDE0U3J1cU8w?=
 =?utf-8?B?aDgzUWNFZDJkUWhhQUFnZTFjZUFlSlFJODZpeXJGUW5UTzhUVjRmVytGQnYw?=
 =?utf-8?B?ZGRVZmxaMXprMGlBZUlESm04TFdKY0pwNG1TTHFmUHdCcWZXK3pPUC9NRExk?=
 =?utf-8?B?YmhpR1dCVGV0TWFyK2YxZDNnQWtneW9FT2UzbTVrbVhWL01peGFDaUNIK09J?=
 =?utf-8?B?UVRKVFNtZGVGZjFFczF5bUxUem52YTBEN3hOU0MxdFZUcVhkOE5ZV2txeGs5?=
 =?utf-8?B?aEExQUJ3K1ZES0t3cHJzS05pVTVJNlNtRVQzVXlzckNhdkwxbGh4aHhSSXQr?=
 =?utf-8?B?TXR1RkY0NW5SdkRRZFJqdE5JekJIellxcDRRaUUybnlrUXR6Vms0ZXVEWVBE?=
 =?utf-8?B?dXlpdDg1cW5IMVl5ZURiUEh1b1J6dllGajE5eDFKY09vNmpnYWgrZDhOd2xI?=
 =?utf-8?B?Z25JaVIzdCs1UjZoR1Y4VFU5M3dSNzM3OVdSYVBUYVB1Vm5vb2tZUStYZGRS?=
 =?utf-8?B?c3hFdjRpa1pLd0w5NG9WeW11dHFGWnFQbTNpbG91clZ1bktRSWI4WDFXb0hR?=
 =?utf-8?B?Y05POUVVb2hoY1RTcGdpS0R0Wkw3ckdoZng1ZThHUkRrWk9mc2loSjFHK3M5?=
 =?utf-8?B?Z0xIWEQxZnZPYkRoVm9HSURiZnZIeG1TZlNqcE1pM3JQTmE0WXM3enpSZzFD?=
 =?utf-8?B?N05iNVEyL3N0bnFaenhjL1FnS2J5K1VzcXRvaWVYb0svRDF3U05zTDVVY0x1?=
 =?utf-8?B?aytua0VOQXJ3ZnAzQ3FmOU9Ib1dYcWphMUhSMXR0T1hSQXMzZ01oaklLSzNS?=
 =?utf-8?B?Um91cjNtQitLcXlRbzFtU1FDUlVBMTBFbGZEWDlWdVVPSWU3R3lmcU1DdTJu?=
 =?utf-8?B?VHNIOGYyQzZxMVluclNQaGlMSnFlakxBL0FQcCtpSDZ6bVZBVDQraXAvNWVV?=
 =?utf-8?B?cmM1eit4YXlVTE5KVXFuNDlpbjdPdXViQW9lVnRyeEFEYm5ERktLNHFXaXBG?=
 =?utf-8?B?UnU2cXFSb0pzVmdIdUJGVi92ZUg1Nmc0Yk9RSnlMcW13TmNlMzJTdURWcGw1?=
 =?utf-8?B?MHh0T3FRTWdta1B0bzJVYXNLMWhtckZyckowcGozR0lnYVRhUjVjQjB6Si81?=
 =?utf-8?B?MkZTN2p2c3MzTWhrODBVdUxLV25IVWVVL1lkNlpBNmpBakpPb1dJRVRJSzJP?=
 =?utf-8?B?K2VPYUpOK3pmUW1QdHdnL1JNaklNL0k3a2JkWlJibkFNSG12N3BtNXJCMEVy?=
 =?utf-8?B?TUhRYy9qM0N6RVp1alUwWWlKUCsxN2pxSXZaV1VCSksxNFFySzI0MzZGVTNU?=
 =?utf-8?B?MGcwNm1KQXNNQVd6Zzg3SGw4VTZYTlNEbENZTFZlb0hianNlUE11QkREb3ZW?=
 =?utf-8?B?eUp6NFM5VTVNcUw1YzFmcDArQkMvenVlbWo5N3psMGR6Q2VqN0J6Q0diMDhu?=
 =?utf-8?B?SHVQNXB1VllqNnl2aFJEdEIwbDNXWXRZb0l2UzI5anEvMjVPTVlhaCswNmd5?=
 =?utf-8?B?VE4xR0lIdlREMjZXdnhobTJhYjk0b1JobDhDbEVDQkQyOU9jTDNOc29QeDVx?=
 =?utf-8?B?K2xxa2d3Zk5LMFZqelJvSkRyYlN1cCsrMWo3QnExRGNkMHhTdTk2cEk3RVpt?=
 =?utf-8?B?RzBtWDFuSjFNeSsyWHVjN3JGQS9TWG5NaFdrU25mOGdZTEMyM2NzZ293YW00?=
 =?utf-8?B?RU81Q3c0OUNlbGZ1VVpneVVHb0M0VkZDSXNzemdqSG90TXFwTkoxNzJkM2dp?=
 =?utf-8?B?Nk5FMC9sM3pCOGY0cGZoRUErRGpKMjkrRi9QV2pXcnlTSTIvZ0E2TW5MZDND?=
 =?utf-8?B?cXBnODdyZGtDdEpYSWFXWGhVT1hFQ3F1QkN0UDlJQjBnbi8rSGFLeUgyR2c0?=
 =?utf-8?B?RFVHQmJjS1VpaVB1a29xNUhHYnVHUUR5OGJtdEc3RENXRUxBTUF4RFBXSTNM?=
 =?utf-8?B?ZiszODUybitHQUZkK3RUZkdPcVd5Sk1XQ09NbzU4YjljbU9uUUZXT0FxWDZj?=
 =?utf-8?B?Vk5NOGdRZWFUdTFvSjJidjBMYUhYVklsSkxjbHRxcTRQdHNkQW5jQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b84fe9b-47d8-45ee-0163-08de5b42ba7f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 12:18:48.9466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3+YNc4WTBNTrVwXWBt70lODQ+F3WLL6FHtFF1McE1JTKiCBkVdsKoqgUoZDQ3ziK96v0r3REd2RW7+7DODAuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7195
X-OriginatorOrg: intel.com
X-Stat-Signature: rc5e3yh3bt1boufpchphtg3fxesh1mzg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 237651A0009
X-HE-Tag: 1769257133-215280
X-HE-Meta: U2FsdGVkX19bncUjJTFvykYFe8fM53LC7hQdCwRm3Tzp2ThaLmA79pOXSjpUkbIuwxVcDgihRoY+6WMaMEuOG6+34vIi7LLz6hzPGwOIe4d8xKnWoc/zs+m/E3qXnZ1oQLIacNVnwGWKgMOGv8czC83SKsuLvtLjcRdAzFAO0cnfzt3FtqBk+hZxyuEqCE4mD7TZ8vNmUf6zwNuZ4l2/vNk7eD7plDwPsKWlRcvKKu4sRofBm6FgRelqXPCd3YeTQDmVq53RRy2/+AWO56ZZqvjBjQulCeI5Zd7+pLV1u6eYAdlFhDC5Qsl+YafbFwbDjuY6pNw09fL8q+YuNoTfHu1302mbw9jbebYeS9ak4hPDJ4ezERVD/FOlqz7O3HI4Ptu54FPuCbWhO8tgpNtWKRTjCZNYwKsyeDse0RiIZRJsLffmZiYr0d2HBaGRta3mOyZR5R9EidRCLYuXx2m7iyixDlpZQ+drEdcZAghd7X76Y0VzGIIpFAphK3y2DRgj+JlEYnMqWlw1i2/VVFbVUb/8sknjlRqD07gJRVnr/Nba+pasPo+JUgYGNnZUK/iFCAiKxtO+P66KMg3Jb+FxvrHNPFPdBUgyTJYVm52fKFcJNsEMeSah9XEiGw44pMmoj9UNZmdcoBPNoq81ayYTiIuTQvA41iSR1Jh699auD4yzl9gdh2UdTmylm6kgYF0VEopv9aN2GL0BgROJDlVZocMEcCIpUZYY30IuFv577WAFyLnUdpEscE1BUON/rytPM314657UVoOWFl2tde/52/zD8wSjWhp9jfBPd+bxngaXLzGs7wGxRg32e2HGbCXvXz8ottCZYrpkpbrz+Tm8KmWIUKU0dkCesmyHcmT2QpYMUXBfiC0BQqISilk8GizzrqhU/QDiy9A2fw176SodSF5qbN0x1GiWqwaUAU4iAV9VTbsLdteaH/XfaKtEGyTwi3BM+iQNDwDQa/g2JPM
 YHQ2hTbd
 I2BOu0I2B5PJuKuvqE41ZgHQh1Hlpv66YpoDdke9wx95qRJxi+1yVknucldUme9DLmFlkOUfp5piv98xXKfnMv/JoDmZh9LS3Y7pEZhfsZUjxs0sMBCSns8e+dmR0Rav00oI3LrwU9pFALQVNyKQdtAe8UvlTgLb3nsrZUJsFPtwToFMzXzCTFy7CqlI+uxr2hfBKUO/zALh2WwIpDqEdO+uh56uL5Tthzl9tCt13N+/7dCTg603Krqy0MAJ3EbdoJ2EHr35L7OIC4nrhhb/IUb3KWBWUsOXPvr4lZVgM1EqsKZM+ayV9JqBlYdbNaZxUXvjjWhyCiHJd7C+6BzOfCTse4fSeeqJKsmezSmVEzKnuY/E2pLKOHQYWBhoPLQpDM8UxsbWSV/BL5gDRgB8eOLznaFF0UPeEZ4gXJmLBI4uEnfs29ZvE4NQTpUrzrsPfyocbBXoNKny+amgH1LdnULsHf6CXdrySnhNJKyDgzT8eF7w1z4cGNrmrCXcE5vkLWtE6K1+WXKb1PH4rwtoin14AUpxElRUDOAju8ETvJeaN9WGvU1PKZsU9hfcrpeDFbe+Eul0s0Tl9wU7JIuihK5vF/rxdh73XmfEJxVVlG5ZDL4InbH/rxjJ4crZ/zDtW8UO/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Appreciated for your review, Mike.

On 1/22/2026 7:16 PM, Mike Rapoport wrote:
> Hi,
>
> On Tue, Jan 20, 2026 at 10:33:44PM +0800, Tianyou Li wrote:
>> From: Yuan Liu <yuan1.liu@intel.com>
>>
>> set_zone_contiguous() uses __pageblock_pfn_to_page() to detect
>> pageblocks that either do not exist (hole) or that do not belong
>> to the same zone.
>>
>> __pageblock_pfn_to_page(), however, relies on pfn_to_online_page(),
>> effectively always returning NULL for memory ranges that were not
>> onlined yet. So when called on a range-to-be-onlined, it indicates
>> a memory hole to set_zone_contiguous().
>>
>> Consequently, the set_zone_contiguous() call in move_pfn_range_to_zone(),
>> which happens early during memory onlining, will never detect a
>> zone as being contiguous. Bad.
>>
>> To fix the issue, move the set_zone_contiguous() call to a later
>> stage in memory onlining, where pfn_to_online_page() will succeed:
>> after we mark the memory sections to be online.
>>
>> Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated to have holes")
> cc stable@ perhaps?

Yes, will do. Thanks.

>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> ---
>>   mm/memory_hotplug.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index a63ec679d861..c8f492b5daf0 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -782,8 +782,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>>   			 isolate_pageblock);
>> -
>> -	set_zone_contiguous(zone);
> move_pfn_range_to_zone() is also called from memremap::pagemap_range().
> Shouldn't we add set_zone_contiguous() there as well?

I did not find the place where the online_pages was invoked along path 
of the memremap:pagemap_range() function. Would there be other functions 
to online the pages remapped? Much appreciated for the guidance.

I leave the zone contiguous state remains the same as the optimization 
not took place in case any unexpected behavior.

>>   }
>>   
>>   struct auto_movable_stats {
>> @@ -1205,6 +1203,13 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>   	}
>>   
>>   	online_pages_range(pfn, nr_pages);
>> +
>> +	/*
>> +	 * Now that the ranges are indicated as online, check whether the whole
>> +	 * zone is contiguous.
>> +	 */
>> +	set_zone_contiguous(zone);
>> +
>>   	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>>   
>>   	if (node_arg.nid >= 0)
>> -- 
>> 2.47.1
>>

