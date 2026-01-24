Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFE7D715C6
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 12:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DC86B05B9; Sat, 24 Jan 2026 07:31:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7454D6B05BA; Sat, 24 Jan 2026 07:31:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3116B05BB; Sat, 24 Jan 2026 07:31:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7BF6B05B9
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 07:31:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7FEE1A028F
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 12:31:16 +0000 (UTC)
X-FDA: 84366792552.28.F4FE59C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf28.hostedemail.com (Postfix) with ESMTP id 071D2C0008
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 12:31:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FC7qtMww;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769257873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbLd4Hv6QPrYI/YCDqoILrVY/tx5yFWgTbQIlqSgv9Y=;
	b=jFWvK8WT2vcsYvE6hf4KiBXQ2S0whXedhkeA39L4mE+xqhdHAgGzimNwnHxzzLrKXthS2P
	ib/qJgyGJ102/e0pY2TuDU/BtDlUm3zX8CJJiClS/U8gc7qvCChxRlVmNAwXCAUjE98AhO
	RyqaxyIHsDu6FJS+gbizQpR5wk5ojQs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FC7qtMww;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769257873; a=rsa-sha256;
	cv=fail;
	b=b0BtT6+AT0QKhs3pyI/NwNz+NInqgE6FuSnDUfpLYgZjuQjUEKl93Lzr2FLh8ZFDLDBFZ6
	p1X+kbw9o6jZ9FzuW6hcWZk93Lf0XVAbFS7RCff8dSkRnRww6zBZWepdOPl97kk4oKACP9
	ve48tEQPDRx3O3OAZtBSfo00IFGxiuc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769257873; x=1800793873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SJP2nNOYRwUhAdY4Rkgmf++mdW/YOebWXDfe18bWa9Y=;
  b=FC7qtMww0qG0eo+TtPZj7tzbtsYxtQ+5oLqWHS1DoxRE62ZDtvS4kZqJ
   Cn6afHZsfBfaUbmSZAH+vtCN2F3eHG2uWbKRGUCSRAd342hrxApuY97o2
   PYthVLBGxfvR6ikgjLuxTv0gqUnI08jEjvdwmSykTaIyLrVMdGIkwDeTF
   SbBDZEOpVpGobEQEbn5/ae2PtYpxXG7QK5aeyryz+HUo5sXsj+Nl2k3aS
   WKGtHJjjnXsfa8rPH74Ze5yJJx3E2OsweI+fMqvfOCg50pyg6dDCqnL3a
   34bkX3olHhCwkVGxBmL90AFW0AQO8DhQnVFfJk9HfZcWwhjvh7NwGW6Lq
   Q==;
X-CSE-ConnectionGUID: 9WFjb546QUyZGSa9SZUG8Q==
X-CSE-MsgGUID: FtVbGCqQQLS4el3TGTxDLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70211693"
X-IronPort-AV: E=Sophos;i="6.21,250,1763452800"; 
   d="scan'208";a="70211693"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 04:31:11 -0800
X-CSE-ConnectionGUID: MU0rBgS8TZ2oTTOtxsuAXw==
X-CSE-MsgGUID: UAc5CNx7Tl6zdpzNLWtmXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,250,1763452800"; 
   d="scan'208";a="206510400"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 04:31:12 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 24 Jan 2026 04:31:10 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sat, 24 Jan 2026 04:31:10 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.46) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 24 Jan 2026 04:31:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XbgnmXT36PqT3+XBnUsXxSwzpy7gwBuzEqY3mPj4ShpDi8izx+BxH5SVk2TPQm+VbJULFoz5yFXLucZ12MKxQ4z+YMMHiO+LW0BOgQTOHKeqQVgCO/4QI95R8Z3JZqgt1ppCuf9ShD6QsEjf1ylPhQ03j7D7DrKEK0VN+ZOXJJTpkmN9GzUv06nVX2/93Mm3x5EBUcDFjT3TfrlRse90titypCmfm2g/hO2xtylLAr/iY6pGnN9prE0fey82pse9Q7a1QgcxzycEqDn4Vd7WsAhVosDFytwsRbPfhCP6Ah8FCmwNR8t/ZPlKE1KzqLGrmEebnSbnH+Dwk7FwYrGP6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbLd4Hv6QPrYI/YCDqoILrVY/tx5yFWgTbQIlqSgv9Y=;
 b=UJgAmuGrn3L0aNYNpj8QBqT1RBTwl8a+aBSL8E6P9koI/q614hILcxo/8ISK6bjP6seSd1egEVsbdi/1EDdtG8/1BBGgJdC9MDWKVCP7LMs6W1LHZEbMuarSSiCTqzOEcHD4ZtMKx/zRGHU6Vybp4pQ5rL/UBzFGp2BQrL+98KaUj+YPShJpAvd4IsHvWgXFM/UthgYbw+uG1M3qa5xDHf3QSlBYnfewb6/znmlSi17nWheQdpJIUNuv39a2IWJDsG7H1vgIhHdXvukykZJ8QfFAUlbkAwWhJUFhZNdIG4RQNkq46zijGhyfqAn6RfcBnyVeyfbzDBTd4GYblS7nng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SN7PR11MB6873.namprd11.prod.outlook.com (2603:10b6:806:2a4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Sat, 24 Jan
 2026 12:31:08 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9542.008; Sat, 24 Jan 2026
 12:31:08 +0000
Message-ID: <705d63f7-2451-46bc-b1f0-bef718b82283@intel.com>
Date: Sat, 24 Jan 2026 20:30:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/3] mm/memory hotplug/unplug: Add
 online_memory_block_pages() and offline_memory_block_pages()
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-3-tianyou.li@intel.com> <aXIK55fQeKfB-jM0@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aXIK55fQeKfB-jM0@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0119.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::35) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SN7PR11MB6873:EE_
X-MS-Office365-Filtering-Correlation-Id: ecec7f02-743d-4430-3511-08de5b447362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YXNLRmpkYkVZRkN5aTMyRDhicXg5M2RickVhVG5NcEFKS0JlSVdENmQwM1Nl?=
 =?utf-8?B?cGhaV3ZWQlVUOXB6UTNRQ0s4M3lKMGxlUTBVTSt0Um5Bc3dPMWE3V0lqMng1?=
 =?utf-8?B?djNQNXlOeHNTR0Z6emM2ZUltSnVpbzE1OS9rc2V1dWJCN0MzN3R1NURCN0Ru?=
 =?utf-8?B?elZRcWU4RUN4R05od1VCYnRRdE9Bb055dElmSHo5aS9WMEwrTDQyWUxOMWkw?=
 =?utf-8?B?M3VEUlZLcGZYemNyRXVKVFJVQ041ZEUzK3lFUGtXRmtLTEFTZUtRUFcvZE9x?=
 =?utf-8?B?WjNNZ2RUZXFyWVlFOFY3cmJMd0xSQVJrU09STGY1TUI2MlJ3MllIa3ZtM0tZ?=
 =?utf-8?B?Z05OQSsrVTBKVkZCa0d2YndsQ2dPWHFqbWZNb3cxYmVBd3hZak9GNnFvMkVs?=
 =?utf-8?B?RXg3Nms3cEdxQ1VSUnAyZzd5TmJJTFMzTE9kQVdOZ0hzaytqQ25JMCtxRnpZ?=
 =?utf-8?B?bUdVdjUyWnlWZFNQOFJMNDROb3MwaEVCWnZ6RWxkdi9vVXZQTFU3bEYvd1Yr?=
 =?utf-8?B?MXhTWDJnMFZzZS9ERmY4MEFkV3pLT0xnVVhDRTBrK3FiY0NWbUhuNmJZVHRt?=
 =?utf-8?B?c1QrdUo1RFkvMytpUWVCNWR0MWMwbjhzeDlUZVY3WTd5OVQ1cTI0ZWR1Rk1l?=
 =?utf-8?B?Y1BDb0hUaS9PNWdhVXJ2azFKRG9kRlI4OGExWFEvTURQRnQxajkwekMrWE1X?=
 =?utf-8?B?ZCt6RVBtbkZnbG9kS0Z6ckFCYm5VcHRkSm14MTFYbTREVjAxZVJocUxjMFhW?=
 =?utf-8?B?MTNIanltNlZMSVNhYjlvdWRQalpGQUR1QlY4WkUxeTQwelROWTZNdk5qOURz?=
 =?utf-8?B?UkZXanJUY3J0bXA1RDBtZlJhc1NVd2YxY1pnSWxUcjQxUkM3dkVlSVVqYkpm?=
 =?utf-8?B?b0tBclZpNzdwWVRCOWdNZjIyZzEzYzREMHkxMVl1MWhKVHZTRXNUUmd5REt2?=
 =?utf-8?B?QXlGTGFwL1k4aDczMnA5NEIzUWtlODBYTk1rTmc3MkM1Kzc0Ly9UU1dRRVkv?=
 =?utf-8?B?NHZ6aENoUGx2ZDF4SWNiekNaUERWaUlkWENhV1RxbWREaFl3M1JsYWRLdGZ2?=
 =?utf-8?B?TUhXQzlqTnZIeWlIM0VtRmJVRVRYWm9ldURlZG5pN2lCR0M5SHhkR2UzUU16?=
 =?utf-8?B?T0RPamh3ZW9uaVY5RjE1Z2o1aVlScmFsL0NIQzlyaFJEUFlEamQ4RG1lV0Vr?=
 =?utf-8?B?MHdJM0VGaEVCdW5ySkZqcVpFbE50VjZKdW4veWNOREtDbHFqYlFGVFI4UVpN?=
 =?utf-8?B?cWo3UjE1T2tjallJZ0pWOXB2TDZDeHh5WnZVelg5UWdoY1c1ejBSY1VDeUlD?=
 =?utf-8?B?Q2VKeGtPbW1TWkRjVkxsTitaWElpVjlLbWJuREpZN1d6aThsZlROQ3RmcHhL?=
 =?utf-8?B?SmNPaExZeW4vR3VDRnRFTk1BMGNabGplcjNLeVdqa3VRUUxPcHljTU5hYktz?=
 =?utf-8?B?VG4yWVIzRkpmWTVnYk81dTdsdElGSHFCN0VIcnVMTjRxbmJ2emxoRW54RjNP?=
 =?utf-8?B?L205UzVPbmZtRVo3cEJORkdITHZhUXg3VHV4eTlJeXpiVEJ6b2tMb2xOSFdF?=
 =?utf-8?B?V21kNzQzWVg0bUwzVjhjbmVpM3krZElteGVjdkhJT2toaUdjVEZnL3ZYOHlm?=
 =?utf-8?B?bjdUTEZKZ1VOa0hZNWJCMVFTdEFsNHc2Ri9GUGdac2M0S0xTKzJnc1ZxTFJD?=
 =?utf-8?B?aFJVYWgzOTkyREo4Wk41QXFDalpMeWMyOHp5Q09qbXQ1WUh0ZURSalZpd2Ju?=
 =?utf-8?B?RVo0WWNBVCs1Yk5yN1Z2V1Y3Z3BPU3BscTI0anY1bFBBWHRwUHgyb2tQRFVl?=
 =?utf-8?B?S054TkFFWUpScFJ3K0YwSUVKS3Y2Tmd4NVBpMzY3c3EydkVyUHdLeDlvQ085?=
 =?utf-8?B?a0FzTXFrR2lKemtoekZOczFsV1E0WERyc3ZpVUJuRlh4dzNaNlNSYjNKK2NU?=
 =?utf-8?B?eXhzb0dvcnJHNEQzOW5mbTUwamtpRHp3bnV5eUFmZGxIcWhneWpidEQ5OVdm?=
 =?utf-8?B?Wk1OZlY5V3RDVjF2cCs0b3V1djljMjh4d05Ma1hWMldJQytEbStrNlpzbjNZ?=
 =?utf-8?B?RDdaOEFUdFYreU9iYUF4bXNWalpYdFR5NDlLZEJ1QVpPRFgvdHVLK09PWmRw?=
 =?utf-8?Q?Fqn8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WExjY0ttMlZhN2lMRzROMFpDS3REaVdna2JCdGZRYXBhYVRONnlobVZvTWpw?=
 =?utf-8?B?NW1qSXNUUTVFTTdGVzd4dFBWYWlyRXltRzkrVVlOYldJUDBaYkNudkJ6bzBa?=
 =?utf-8?B?eU52RU1BMmRUcTYzb1dac3BoRHVtL2puWTc2S0Vqc01ITmgrWDAvSUdRYmJs?=
 =?utf-8?B?S0tXc1FyWHVxUCtNRjFyVkRmVTdDbDBodGhwOXJsVys3SXdqdUk3TW5wQ3pQ?=
 =?utf-8?B?TWVzNmZ1bDdyUHB4MVFVbVpRSVY4RndnVFlEMGZmS29iYitYTmNBUmdjQmdr?=
 =?utf-8?B?SjI3TWk2ZlJmbXU2NFVXT28zK3R2Z3llZml5ZWhOd3VMUEJtSWNYRE9XQ3lD?=
 =?utf-8?B?YVJWbWJrQ0RCbVVEVWtsRVVjMExpUXltU1BKR1BXdDBBVmNIS2lwdUxpMndh?=
 =?utf-8?B?Y3F1WEdmRXlaOXMzeEVKTXNkU29YSEZYeGo1RVArWGdhbWFuVWtVaDJaSzlk?=
 =?utf-8?B?eGYvWXNhVTdFKzkvT1FpQkpjeko2YkVHQnVJY2Y1c1kvUzQ5WCtwZzIzNFpo?=
 =?utf-8?B?WFE1M0loNjZsNG1DenRWNWFoN05tMWpvY3Y3bHpibDE0YzhZcDd1UW9aeGxP?=
 =?utf-8?B?ZmpwalNMR1hScTg5UUlibzNGK3ZQMVdjYkpOZ05uSUlrQXNlV0ZRRTE2elY4?=
 =?utf-8?B?Y1ovVHNxbUdTcERKeGF4MnpmblFNRWgvSHcrLy9TdS82Y20zOTVtUEZPV1FQ?=
 =?utf-8?B?bnZRVmpqQkFGODdaYnAzei94SCs2ZHBKVUtLM0R1WjJ4d0FRbk95ZExOV1FB?=
 =?utf-8?B?dU8xbHZYVVU4S1NhS0FrYWN3ODFTRU9ObjRFNUlxL1RGU2VtYzh0MzJrcDh6?=
 =?utf-8?B?dUtyRjJ3OW9zOHo1MjdaYVY5OXF4dUEraXpnS3VnTzZpbFVpQ0M3MVErOXBk?=
 =?utf-8?B?bnRzNG11SUZFWSsvTjIvemF5YjhmVkVkQ0pHbDlEYyt5TVNJSnlBVWdjVHVi?=
 =?utf-8?B?UnhxZnZOTGhESTkxM1drTzBpaEVxUTJ4NCt1UEd6Q3czNFpsS1ZCQzJlTXJ3?=
 =?utf-8?B?QldmWUszV3RnL3RoUVVjMWVWZEhvWUhVSU9wTDNLMFFua0Z0RmJJdTBnbDVr?=
 =?utf-8?B?RG12b2JQYnpyUmRGYUw1YXA0eWNXQ3FzdUpxQVhDcktweTdVZEI5VVJrM3ZF?=
 =?utf-8?B?V25lUHVlYndNRTBzVWVadklhZ1RPWi9QaXlzZXpsMW45ZmtQM2RsZCtYMis0?=
 =?utf-8?B?dlhTd3c4ZmU4N29MZjdNeWtYR29NdzFCWkNTOThEYVNTcXJ6UTg4UEhLbGZi?=
 =?utf-8?B?c0RxcjY4RzBaWG5NcG11UStrTjRzb00zZFBzTGNKaEFLaWFEOVpDMUtybjc5?=
 =?utf-8?B?K3VpL012d05qdzc0VElUTnlyQ0xmUGFjQ2E3aUFGQ1pYaDJmeGZIWlYrQmNF?=
 =?utf-8?B?QjI4cldLOHAzU1NvRWhrVGhSL3crbXIvR1BlQVBTb3M1Q01nQ3E0UHdZUjNG?=
 =?utf-8?B?ZlNHZ29kSlh2Vjk0MVVBU01yWndRdXd2OG45TVdIV1RROEd2b1pqUitMTWJU?=
 =?utf-8?B?d056NkhqelFLLzd5VjkrMFBZYllBd3pRbGVmMnl1QzhkcnhQYzh2UUc5bmho?=
 =?utf-8?B?Yk9waUgxaCttdXovQkhPQzQrN01nbjNWYXJFWWVQVTR5VVNHSW1QVGV6TFp5?=
 =?utf-8?B?cUcxcWFQNlZpL0RSam1mTjdIVCtXV25aN21nWEFGa2pvdmVEUFdPdzNlTzRI?=
 =?utf-8?B?bWZtaXNIOTQ1WWJrNHJQQXUwd0R3UlF5UzI4STBkUG9qMDdzajVhL21EQ1Nz?=
 =?utf-8?B?ZkovQkNSMGhpMFdKSDRTd1U0UjRxT2MybVJFNDVzbkliYTNhYmNYR1VFUEJI?=
 =?utf-8?B?Z2ExU3FUSEZTOGRqdHpVamdFSFllSmpEakczV21DR1kwcWhFSUROMVdvMlJs?=
 =?utf-8?B?NHhUejVDZW5yOHcrbE9IN2dLcWZueUErNVRYQkwyY1UxSGhycDZDNG1uK2o4?=
 =?utf-8?B?MXNLZ3krcWtOQVM5c1lNUnE4WUx6NWVUaUF2ZXZIaUV2TnJMeW93MXZSeXJo?=
 =?utf-8?B?S3FRcnJZcG1tY0dweE1BM1VNVlhtdXRHRnNweGVySHBYZlJxK2YvcDRQN3Fm?=
 =?utf-8?B?VEx0c1JvSmpmN2ZJV0I2dnJ4NHpaaVRlZjhJYmlkVWdIZ0ZFaU4rL0ZEREFR?=
 =?utf-8?B?UzRFNkQzK2NGYlk0VEJMeEtMYmFsbkx6MVR3ZHFEOENTS2duYWpmY1VRcTlV?=
 =?utf-8?B?M0JZNStUL0hldkJGQVRqMDVZRTc0WWRaYzVQMmlEd1M4Y0FpWWg0TFFsSGxE?=
 =?utf-8?B?Slg4UWY3VFhGME9UM1R1eldVM215M2dNNFJqcW92clpKclBEZTRWVHdTaHE5?=
 =?utf-8?B?eCtzbU9veW4rVENUeHRFZGNSYW11UDN2UFpXd0xKSHkzbFZqWUliQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ecec7f02-743d-4430-3511-08de5b447362
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 12:31:08.5933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tR/p2TrLHKPOj6f6xtRjI30dDnUaKnCXlzZK6KoHMxZY6rSvRv2NMpSQRwBSFKHjXyMO/C6nq8wrEIapB5eN6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6873
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 071D2C0008
X-Stat-Signature: ynm53opym9yjiydkkmc3aeucyu1oauf6
X-Rspam-User: 
X-HE-Tag: 1769257872-461509
X-HE-Meta: U2FsdGVkX18Cl5+Y7/AbqafOhp3+j3uqQz4r6U3Ykr+zQ4FAT7t5hln4pjQiagFOhW5Fwj4m7iYdp/F6093zNdszUqJHYaKEYY4e1Bm8lDQ8bq8lRYBdScvln2sFQm/JAZUyVaRg6huxA+Vn0OjEanoIs5Jnllv5roUBUaGKndDD8yMCkbJQGlzQqGYnQxCVg9nOMsZ2mR1Bxu2N8k5s+E3CkZsikScmdjr7doWH3gTBTOtq96K7E79NAeiJcsVY6rd4pvLcmbXXJlOulzYIBmNPeDBtiLnGFfXc79xGwtcjQA3i9FMWBqTqGH4jDKk99wLFH+TDxb/P+q/z0J4nQsK1iWEmJMLvH1uU2rUfEQONny2LDHgWZzHJAjYpNOoPfmQ0PbwA302azCTOThwwadLX2Z0n2qJfUXU8gyLaf7BewqrMIoin3ZREVmn/VdRB1laFSAhc2O/pjN5qsRKEElOEmD0yHASrwNdgAxD74Q5oE4O8oDPpzKhCInlDguJA4WFDz+0YGZsDoJ6gnAwmxRl0E/kZTAYU/LNnuQf1j7NdOYof8jb6o7/jFChhgUgpIBFO2hR9NI37+XXlGJkaGQbGO1Ib0mIsVroPF0Irk9QhPEit3YR3DPLqcwhkE72qlYt9LUb0+UfytCmL6YuccRJhTgNc826h7msvWVfwbhZPBWeugfvjPMd1KnGpUeBxrs6QhUyIlXJ5VCxoLtxmzOcGYOXnlSjh+YSE9njJWmmNVdSbz/isQNKR6QcT3qKaMoJ9ufIb8phBfAnqZhu4gjdU5n/fdFmgbdUlCdl8LTLpCDAUyxyOts/lxBjbagugO8pQ9t0/pXNgepgM5Lh1YGvYjRWpRT3hQmsPJfW4skpSW+Q/d2/wZABGKDTl3f8bsHHu1Q4sR2OmZ4KDJnv4eccffSVagu+jxJIIW786nZzmK5CRk7wRtU58HucBPe/+pYFixWM9+O4pnv1NulT
 nC5iIQit
 EN5nouXID+n4W3GIolX40vApsANwGyJBPLsuv8lZCJOCzdTea75gL+l0XVUQLumiI08g0UVFtCXzf0rUzlQ7DMXG4KGQPtn6Zn81CTUnIAim05WAl+gF25SGnNvyYDsmO2bvRTQScdzTR0BMQ9KHcC1Or9IMqXRMcBk5M1GZ8JZI/e4C6BVG5HsTOaYSR5NjzHaz2f+gTM4hW1vvvGqF/VxL40vLoiZr5A1cvhHQTMO5QY1sUlqhrpy8p9qFgHzKIcvRBloKRaLcmAP1ADTcz1c8uolAxafWefg8T0+XRIoqoqrj9Go0oOgKtTkINEXazolmQRR26wzhRSrc64FZIw8TJW4P7A4b8SH612nfYwX0AX9UIx3J7eLhmBH2/fD1Z3N2ikXQL9WQFdWtfankPb4pVoPcFpj0rgYvu62YtR3eejqOeeW95al8nV4pYrbPKNVI/gCILaiQU4NSru8ahXFyqF1xqfH8b4WkgFI+h2mWQQDtcxdFeuWhnGVDcZLnh7SPsm52V4qoKqMHlJlptPEejWC8Xp17yTd4Rj0D05xKY7AgqrqeJSMER0YzfDlegn+Dj91vVVsABInQc3whEp3ZNeUpndwjbkT309adVisllt4Uaf0AntgBqGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/22/2026 7:32 PM, Mike Rapoport wrote:
> Hi,
>
> On Tue, Jan 20, 2026 at 10:33:45PM +0800, Tianyou Li wrote:
>> Encapsulate the mhp_init_memmap_on_memory() and online_pages() into
>> online_memory_block_pages(). Thus we can further optimize the
>> set_zone_contiguous() to check the whole memory block range, instead
>> of check the zone contiguous in separate range.
>>
>> Correspondingly, encapsulate the mhp_deinit_memmap_on_memory() and
>> offline_pages() into offline_memory_block_pages().
>>
>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> ---
>>   drivers/base/memory.c          | 53 ++++++---------------------
>>   include/linux/memory_hotplug.h | 18 +++++-----
>>   mm/memory_hotplug.c            | 65 +++++++++++++++++++++++++++++++---
>>   3 files changed, 80 insertions(+), 56 deletions(-)
>>
>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>> index 751f248ca4a8..ea4d6fbf34fd 100644
>> --- a/drivers/base/memory.c
>> +++ b/drivers/base/memory.c
>> @@ -246,31 +246,12 @@ static int memory_block_online(struct memory_block *mem)
>>   		nr_vmemmap_pages = mem->altmap->free;
>>   
>>   	mem_hotplug_begin();
>> -	if (nr_vmemmap_pages) {
>> -		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
>> -		if (ret)
>> -			goto out;
>> -	}
>> -
>> -	ret = online_pages(start_pfn + nr_vmemmap_pages,
>> -			   nr_pages - nr_vmemmap_pages, zone, mem->group);
>> -	if (ret) {
>> -		if (nr_vmemmap_pages)
>> -			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
>> -		goto out;
>> -	}
>> -
>> -	/*
>> -	 * Account once onlining succeeded. If the zone was unpopulated, it is
>> -	 * now already properly populated.
>> -	 */
>> -	if (nr_vmemmap_pages)
>> -		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
>> -					  nr_vmemmap_pages);
>> -
>> -	mem->zone = zone;
>> -out:
>> +	ret = online_memory_block_pages(start_pfn, nr_pages, nr_vmemmap_pages,
>> +					zone, mem->group);
>> +	if (!ret)
>> +		mem->zone = zone;
> I think we can move most of memory_block_online() to the new function and
> pass struct memory_block to it.
> I'd suggest
> 	
> 	int mhp_block_online(struct memory_block *block)
>
> and
>
> 	int mhp_block_offline(struct memory_block *block)
>
> Other than that LGTM.


It's doable, if not other comments I can change the code. Would it look 
like moving the functions to mm/memory_hotplug.c, change the name to 
mhp_block_online() and mhp_block_offline(), and change the references 
where the original function invoked in drivers/base/memory.c?


My prior thoughts on this was just break the code as small pieces as 
necessary to handle the pages online part together with zone contiguous 
state update.


>
>>   	mem_hotplug_done();
>> +
>>   	return ret;
>>   }
>>   

