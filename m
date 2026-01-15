Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3E0D4661E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABA36B00CC; Thu, 15 Jan 2026 14:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CE16B00F0; Thu, 15 Jan 2026 14:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458306B00FE; Thu, 15 Jan 2026 14:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 327376B00CC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:50:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C1E78BB29
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:50:16 +0000 (UTC)
X-FDA: 84335239632.05.34551DC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D68E2000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:50:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mfL11jOj;
	spf=pass (imf13.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768506612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwpL1oKJyS1p/aErWcgKTgtysx+5ip0yAw2CjbMvGSE=;
	b=lSJ9Nh1zhBQla9907XzSucSAg7Ok4DZhiytcbf0hNc/llwCfbQ8phllc4OOuYr6Qji3Fo8
	OaKVsvc36+JSI/7gJMmVVi7GgJFtQsZKRnwnKUX+NSqTGMfika9ESOtYAsJvBxDCoW+Kqp
	i8z+nU8lUZ3yY4rNazt3f+KNZSCIAbs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mfL11jOj;
	spf=pass (imf13.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768506612; a=rsa-sha256;
	cv=fail;
	b=IuUAo33E1YEQAf1gQRZMmY6Ksti0h6gqh+GzernQ7Ea7UmKVjJOWHiKAOhTVob8Is8zqT9
	/gJW4KfybAjBNQcSc8zU1a3yWZu8x6arP9HNapZ3a8o9UoaN69R9CUau2t3wmsfQHTYjEU
	lzRGo6KCit/jyRxpdtYKsGFj/V0Koxk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768506612; x=1800042612;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=esQsXuEGU9/K5u0CQ86ZXzsiWT+RzLFX1vCjtYBnbWo=;
  b=mfL11jOjz693+AQmPZ+5xW4ibDXr6Bb6UmBXzo2QYPi/eYI8fmU1DlUu
   M7/kBISu6kukdLi1HrGYoH6oLPmxNW1PXjP2pqy/sMQr28HHIFbgJoUdW
   zxnhQExoq4R3e8wn3h+zk6qOMzrGpvh3DOiNJ4L3SmkHqIQiSADS5Wt4B
   x5UuC9yTFzIjAdLP3nAiSZtuxJt03pV9/pmlaR5Gpw5UubBhK0Flhz5zu
   +NctY02bIBqsGdpbBRBV3NZaNz+itm0unA9te0MApZ52LDZd9GadEQLPO
   hkX+HDjubz8ZbvX4N2O6BfAaMHmynHf+Emebz8X+jNSsh8UgtrM7P4Pfq
   g==;
X-CSE-ConnectionGUID: 6TkefmnhSSyGAQIuqXIs4g==
X-CSE-MsgGUID: jUhWIeBkQWGsp1dWIdZRpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80540247"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="80540247"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 11:50:11 -0800
X-CSE-ConnectionGUID: omFCSVHRS7+pRnfdFEhYtQ==
X-CSE-MsgGUID: ka3fXhVISD6rpHnkVPjz1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="205455004"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 11:50:10 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 11:50:10 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 11:50:10 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.57) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 11:50:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XC72WodXATvN5jptIRzF1vayd899SFikqJQJ//llwvHEDkIJg8ResUPIMvlX4w+6iCeliZrfT2gDAb78vCQle6SHpuinsLgCV+1ma24nXTT54W4DRPtl8yrfopyo8jbAhRrY8XdZmWAWIlwjwx5x4bR5rHH52/ZgkTkQsbFq1zKaU4X3Ma93CgXCnU+oWM17aAqXG4KFEWjhXEf/9P1/BzJ9YbsDjoDk+WRR02c3eBS5zvcq0MdKAnLdPLy3rqBBu3k3pU80GcT46dkk9ydjRTQ4MYaRiBRoP9YSLdDwMSmehoZB5bjhh3GgMPFSOzE4+TXtke8z+YyS7eoiniGpCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwpL1oKJyS1p/aErWcgKTgtysx+5ip0yAw2CjbMvGSE=;
 b=r5TPQDHSsQrTOzlTtmEb7cZgekuYg/HH1Y91Ps/B1yKIM9chgvS2OUW/AQQSxkBm3OzZAoW9Zkl3pYv3oNJOWTai8FFDdTakGY5hCMaqUE64Qj1R3esKnmH5EjZcC8qN4ceX/HMzCDvvTFlkqWD0lTXEcts+qiR+T7kS5H77GAYKzZtjdjKr0cQmi603lThKXPktZCuBuqksuWkH3ZUASsI0hxlyBcYaNbtGoIVHn2OvHYRIiIEW3JRGBp4FMjqm9KWiZH28FkrsVql3ifUSfS07FWjtIiuVws6kBuXIF8QJpPoxhBTSlL77Z+uf6zHjq1OIJNPQkT82E3x1Dp4DNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB7989.namprd11.prod.outlook.com (2603:10b6:510:258::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:50:07 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9499.005; Thu, 15 Jan 2026
 19:50:07 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 15 Jan 2026 11:50:04 -0800
To: Andrew Morton <akpm@linux-foundation.org>, Cui Chao
	<cuichao1753@phytium.com.cn>
CC: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Mike Rapoport
	<rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
Message-ID: <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
In-Reply-To: <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
 <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
 <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
 <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
 <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID of
 CFMW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::12) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: 0832a00a-eaa1-4957-1f0c-08de546f48b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZHlJQ2ROUDlsY05mUDYzcGlWYTQ1dWM3STdvTlJSQmlSbUpodGFWWkhiZ01l?=
 =?utf-8?B?M0FWd1BLQzI5RWlRbXFQc3hGOVRBY1BvcDY0Qlk0NkU0SkpKRzQwd3kwNW9h?=
 =?utf-8?B?K00zWlhkNHRhb2JmNkxlMGIwVmxPTGxXWG9CazlEa1daTDRCcnJoc3ozRDlo?=
 =?utf-8?B?MTJHMG1lNG52S3p6eEYzWjZ3SnpWYjI5VjI1Nk5IS1lOSUt1RnpNTnlmVDIy?=
 =?utf-8?B?UHRuamRTWU52blpJRDIyZ0llVEpxS3pkaU85bWVFSitqeWVoREhMU3pzUFhj?=
 =?utf-8?B?aUltYTcrMHpXK2lsVkc5aHZQaFBiV0hzSXp3M0ticWRRS3NvcjVrU2tvME1N?=
 =?utf-8?B?Rm1qTGZCWGpoSDdhSTV6ekdhbU8wSjRxZTV6TEtOTjVXS3lLNTYyTjZoeEt1?=
 =?utf-8?B?cGIrRkQ2QUZrNUJadWZPQzl0UWRob0E5cTkrWGlzMW5PWFNROUg4QnNEUFM3?=
 =?utf-8?B?L1pyNWhmc2lrd1hOMTdRaFFCc2gyZXYrZ3hXOU1zZi9ETnduOGFZcGJMUGNh?=
 =?utf-8?B?Z044WUJ0Y3phcjAyMTRrc2NRcUkwd1VtMjF4eVR0dkdaSkFyQWRjRktXdVp5?=
 =?utf-8?B?SDZaMG16YjVLTm9kR3VXTlFReWNJQk42ZzBwL1hhTXJOZEtQLy9MeFZWSWVS?=
 =?utf-8?B?U3lJV3cxNTA4VHdzdUwweFliMjBGSUJVcnVxS0E3L0RmT01xN3VnK2drMi9n?=
 =?utf-8?B?Smo1NGUzdWlDYXRmLzJ1bkdOYWdwb0plT3diK2FBcmtwN1lubGVDd0ZFRkta?=
 =?utf-8?B?Z2RSRWM0ZFB1aHVxbnJLaUs4cUs1dEd6SjdtOTFaeURuWHYwTkQxWi9FNC9x?=
 =?utf-8?B?YmFuelcrUUJ0bXBNVk9MSWlzSjZ2T2pQWGRxSzdWZUZUY2tJT1lhYWtCdlJo?=
 =?utf-8?B?T3VUNWEvQzNSSXRJMUFtZEJ2NGQzWG9YeFVsTkJ3b0JEbitjTSs2MGFJSStZ?=
 =?utf-8?B?MTZ4WHdnMmhDa1RjbXhKbXhJY1ZpRi9ZRUgwajZ5NlJsYlBtZW1ualBzeVVB?=
 =?utf-8?B?SHNmZmkwcHV0bWdhcmw5MFN4emJkVTE5bDFsNXZhUUpmYkpIdWk1SmZMSEtZ?=
 =?utf-8?B?MUhBeGxyZ251QnZmR3RKTHJZUzRkUDh4Y01DT296dkdtbkdvKzgwcG8wZ2ow?=
 =?utf-8?B?M2FEelJ4UnNEaE1BYmRRbVVQbXZQNHkrdjNhMnQybEtab20vdDNoTXVOV2s2?=
 =?utf-8?B?RkFUWXJmTVk1Q0djenU2YXlVbkNJVncwV3JyeDRtK0FIdFpHQ013MzhjK3Vv?=
 =?utf-8?B?ZVhVUUJuQmNLbFZtMEN3ZWZuWlR1YVFsUTBiU0kvSXF5VmJoMmxyQTVqNCtH?=
 =?utf-8?B?ZWF1ZmV0cVNmMTRlZ1dJdnkvZEVta21WdDA0blJIU0FldkVZa21pYzFtTEtj?=
 =?utf-8?B?bE4rVm5vWko5UHdEOWNVRFEwVm9ucjlaTTFpVkE4anBzQzZ5aU1QUmVMeHBz?=
 =?utf-8?B?dXAzZ05rT1p6SjNCK2QrUVBSaUdwSTBIV29acmhRQm1qVkZXcGJmc3lLa2R2?=
 =?utf-8?B?bU1vTU5ablhjOWtqVldwKzA4Y3MxS3gydG80Rm9ZZjdwU2tLamhpMlh1K01H?=
 =?utf-8?B?UXhFSmNaVklGVk0zbGhSY2l2S3JNKzBlWHgwV2tGb0RHdDZuWktrN0RDQ2l2?=
 =?utf-8?B?RFhadFFmRGVxSU5mOTM1ZnNpY0I2eHAxQnBKdThBMjdPcnhiMThNR2VtZGxB?=
 =?utf-8?B?OTdKR2c1dFJNYlFTWTNKcWI0ZVBzYkwwT0FEd2d1NVRiRWp0c1FIaG54bjBM?=
 =?utf-8?B?SVRjZncwcDJBWGtReno2ZlIvendSNGJidk9EN3dIYTdhd0toTVM5TzA4RE9J?=
 =?utf-8?B?ME9vLzJJZzBBQ2VTOGNGUEdXd3JoTEVxcFlzaFNRc2R5a2pyL1JNVWtraHY5?=
 =?utf-8?B?ckswQTJOUVhUN3FiRXI0SzM2ZU9kM0w4VEw5cWYvV1RCY0poNzNoSW9FcWph?=
 =?utf-8?B?ZkU1V1k3WHU5S0xsSVFwU2hNcFh6MFRiYkl1aHJLS1RsNnlhaEdSSWVySzRY?=
 =?utf-8?B?MVNObFJkdGVxZ0hSU3VjdDdGTHBWRzltUityQ1p4UW9IZllMZDN3WDRMNGtm?=
 =?utf-8?B?UnF3c0R2OFhrdEZPZ1orTFB1UXVSbDVLeVVCdUNOVHRvSnlHQkkxT3lZMUQ3?=
 =?utf-8?Q?/z4Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzJWMlZCVU9pSW9yc05ucjN0NklhcUN0R3V6S2x5Sjd5dmljMkFzdjVacWIz?=
 =?utf-8?B?dE1sdnN2bVFVS0o5dnczbmtkcnhWZmdFaHNZVXNWWU9wMjZpRXltSFQvZWdu?=
 =?utf-8?B?bFFQMVFKUmR5WFlZamszbkFKYVdBM3p1TXl1M0FkdEJ1Sys0aG1pU1IwL1hw?=
 =?utf-8?B?UCtvemlTNDUvMURYcTdoNCtKTCtQbnU0NkxPb2JBVjNETGJ1QXk5WEYyR2h5?=
 =?utf-8?B?UzdtNnpyalRwSDg0Wlo3S3dHTnNqbk1xc1crM3hpTS9CbENxZ01wM3A2VzhM?=
 =?utf-8?B?RTdONSt3VnlISmVadFJnVFp5NTlhYnhLMHFBM0FlYmZ5cDFzTnBGWFIwVXpm?=
 =?utf-8?B?R2JrYzE2dCtXeVkwVGNaSUs4b1FIRkE2RFVXTmNreWtCYUROQmJYdGtmakM0?=
 =?utf-8?B?aDRvaXA5TExGUnluckxpd2hudFdFRERucDJ4bmpwWjhNT2RpTFM4MTZLdFNN?=
 =?utf-8?B?TjFhY3ZydERwTFNtMEVkYlkxek4xV2dURU80VitWYVhzelhEcDN6bU9RbUFq?=
 =?utf-8?B?QWxqcDRwWDJHT0FTMVFsVjhyZVlyRXYwMkpzSklLVlpCZWZiZ1FmTEtFRGlU?=
 =?utf-8?B?bW41TmtwT0FqcGNNbkpiTTBwTkM0QmZwS0pPTjFwTEZ6ODk5NGpWUjh1VXRK?=
 =?utf-8?B?TXNKR0I4SnBlb1JRTTBPa002RCtkdXlWOUFNUFJ3cnhidzJpS3d0RUFzY0lw?=
 =?utf-8?B?Y1pTL1ZUYkJxbkEwSjhUVW9YbEZMa3VqVkVFb1VMU1A1Y3crUHZlMTZzVnRm?=
 =?utf-8?B?V241eCsvRFg5T3ZIN3o0dk1pdU1sUTd6ZWxiK285RlBNYjN6WWYzaGtxSjlX?=
 =?utf-8?B?aTdjRCtya1pCckI3N0xsWHdoUVRlZ3JISDhFZjZ0bC93dURSWlNhMWRlSVhp?=
 =?utf-8?B?L3RTR2xHT0hwa25HaklVcnJPa2tOdUE5MENTNlRjVmRMOFk4QXdCQ2l1Z1ZJ?=
 =?utf-8?B?L2htZ1dRNUFJazNaT1ZZS2l5K0tLYzhLOU9TVXZqOStRUGdDbUw1ZEJLSU9R?=
 =?utf-8?B?RG5hMGVLZlNvaDRmOVpBSTd0WHliNTg3NVR4OWpsa044a2JUMmpiaUFVSHR3?=
 =?utf-8?B?dHlOL1NjUzdpemhRS01wVGlTUVljTDdJYXJSSkNOK2VpbVozLzFuT1hlNzhN?=
 =?utf-8?B?M3Fqczd5a0lwd3ZnSm1YdlBWczNDVlJTeVl0VXFVOXFCbUZjYVpJSEtHSmc1?=
 =?utf-8?B?MldpN2hDbFRLZklXbDR2TjRSZVZMR1NsbC9VSDdza3FlL3Y2RHZIbE1oOFVy?=
 =?utf-8?B?aXhpSWZHSnhtY0Zrc3JFMUdkWkxkc014V2ZQbE91aUhHdzdNOTltNWFoMXFT?=
 =?utf-8?B?UFlMNXgrQkYyeWw2ejhMakxDNzhaZ3owb1QyL0NFSUNSMDBxcXFocVA1QW9L?=
 =?utf-8?B?TUlkc01MUC9DQVF1dDdlL3JHZGFmQXVuTlNWZ0w1bHBVcVhoVFEwd0N2QVBq?=
 =?utf-8?B?ak5IUEI0ZkMxam0zYndVVFNOdkZwcWFEVWVvRzJ4cVNQc2tpUVlLaTNYd2RL?=
 =?utf-8?B?S1IySlhMSXdRblpFWWM5cnZqc1ZoK1ozRW5nR2hCSDlTVEV1OVJtWExjN0JI?=
 =?utf-8?B?QUJhWnZNZmVyTjVvc1Zqemh2RjcxQzR1N05UTTBLNDl1b1FtSENFRnVqOUlo?=
 =?utf-8?B?QkZldExGRHpZekx2QmxjcHV1OWlRZEdZL2owVlA3aVJTYjkyRXBib2w4SGEw?=
 =?utf-8?B?Z3N2MFZYbmEwRkdTKzEvRi9hMmVQOXVuNUlYZ3NXMWRweCtJSUZYL0VsZ203?=
 =?utf-8?B?YzFqcTEydCt2MHhHUXpuc285OWt6VDZrMDJBWGNlWEFMbkJ1Yk91aWhXNXlC?=
 =?utf-8?B?azJJaEgybE9Ebk1oMXdMQ0NYbHprQ0N3ZllVYzdwR3lUVjJXdkV6THhYbmlN?=
 =?utf-8?B?ZVNqSUJRWkN1KzQwSEREVi9xZVFKN3dBSXhkcFR2bW9sSVZtUytaZk5lTCtt?=
 =?utf-8?B?akZvNVdQeHYrbVBYRWlEenhWSi90d213N1IrM3E1VHhKVGxOMENrSlpYOWhI?=
 =?utf-8?B?b0M4NUllYjUyZ3JENU9uTkN6a0pEMG5LeFBzQ0tiayswV0pGVTJZS2s4Z0FT?=
 =?utf-8?B?TXZVYmJ1RVBTZ1RIMzBFRWkwSTlvWC94MXVMTW03ZzlJTkE0Vk1DRy8xTzNN?=
 =?utf-8?B?UklFZkNKQlprSFlFWDFkSFR1M1JMd1lRYVNMVDNzZ1lQNjg1ZVhHeHYxQVN1?=
 =?utf-8?B?R3M5eGNGZUp3WVlOMzM0bnFwNlVOQ0M3bHdncnRyaTFMVlhLS3ZpWEVud2Vq?=
 =?utf-8?B?NElvOWR4dXJpUXNEY25SblY3RVFzVkkza0xYNVErdUwyN1pLU0YwUmNEYmpE?=
 =?utf-8?B?eTRuQkhwNllxYk5ZUGI3NFlRZFJqNERUaFM1aUpXZnQ4RWozUzhNaTJ3dC8x?=
 =?utf-8?Q?cXo72RnmnTIe1Rig=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0832a00a-eaa1-4957-1f0c-08de546f48b0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:50:07.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMdD+x/FgLrXh2yDJpthlua80D9euzqgDlQc8oWC4bIHrWM6sq1cx9IpVQlTlt5PTrdoo3lEiKsQv0ozN3QGWQObyPuvta/ai/QIhX9HTxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7989
X-OriginatorOrg: intel.com
X-Stat-Signature: uc39s85666ma8ytde9h6ezyzwaidewbh
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D68E2000F
X-Rspamd-Server: rspam08
X-HE-Tag: 1768506612-13966
X-HE-Meta: U2FsdGVkX19mR5iB5BuVlFNe1iozmIsWH61HQFvRU76lpyxygH1vbnKmyBT2dLd1iAk9aQhFlx4j7VZp/uCJtGDGLpkdkOeF77vAVjjtFG+DkhNiUo4EoowlI7jkcNo2LK4ww8qR80SV/FyDeqgq0yX4EcvdcyF62rZFW0TLeoamEsqyesOh0PwNqZHtZAZT1opd6bzB1m2103C3qnSPtmZSLq6cywusiRYbGu2Kks6d3pl0Pn4bToVBt+tBlOZk5X6WyM0vMlABd046ues3F6AW5Sj6R/zDCi0uEWOI4eWqB2IRoLWXUoDZLUpSMpYqkjZwceOBVPTP/D5UVjzDiPuEWvZh5537oo6faHHhIVDQS9XEcuhtf8Ft+vAmSCbTx/zx6GIjxJF9Y1qkd0JYeigj8YGMZMIB147WuCdJ3Ad+bXJZ17oBEyN9rU6gRCzWicUs0cnVZHnwe5ht7KXE0M8PMwIm+5PK9LLA7ppVVkIVQ0BjOmO+D6WgL99L9ItdgU23ksxkjB9BCtES4N/4L8IQbd/iGMqCfPTdZ90qNoYoG3cxxqjhYIaGcNFOcisIu19hgD7nYVPh1E2bpL6/mI3HxhA/VTYJsavqRKjKbWGhmSpLZo4r3NRZYTkCbKryhGtVxchvgX5PA1n38BFhbhU6wjrDSua/hqI0f6RuFsSyFNgI7ED1Bct39hLJ7dzzhw77aPf6oY7ii8WUoCJIE0jm8cdlAWJVRJATLiQQUqShKkPBLB4BR6mYC/r/Pd8JHppKrWFIHUTuDeWU1fwISalmDfekCIZCYGpE6CoT33YxuIf5wVTXP+7s26iOqaWVV3kbVbjCH2r5f0w5B0iC+OURV45tuoGZlBWyxzmypNn3DbSYdz4qXWFiokevXdVYO64T3Za/C2jmGxaBiJsBLUseuhyO9RwuRa5ACdYgAla2zZfRfW2y8YTtASCLRa7g+7qQHcA435NYi5yHpDd
 V40sWb9p
 yikwAUhHR/5V2eqUpB1lLOrp5af9ZW4Kv9lROSdAMNjsWEglxFwzifm/UiFYNDetAwY+G4CJwimBTHo0HXzkJ9JDh9v0S1uJ167I2lXBXORXJ8pbQ4Q/k1SR2WPckv+foyHwGYgaBMx/TmCUxmNHjErcKQgauXWPV1nqI0Qqrlmo35MHRsRMCy3h7NMDvcXkqVpfLfAv5x5g1khU/sNQ5psOR41Q8CyCIOfz78ZIEcW/y+uELZUySn5sVx8VMSBoz+FqtwKbXVAnqxfy0wn+2DncbbPjjbveAmfO4quIgmPEiOqxJraX+abWsHtiKjxLv2rta61JGihku4/pUyigSu1fuX8rxVK7bjHTEEwmk6q1F55RKsgrrGVdu+iiCog4mknZcBvw7SECLGIOzBq/lh8XwJLCXfgXslOKTYCdptyc52UdP2JjYuCqQbBfON/HK/DYWhihRtPPeHfuPBuak9NQPHt7ftinbampfZXawrnasRKCUCPzlwxiyR32PwLXk7+YG7mOnkwdR9+iR7wKtn3/kPWqQSmZxZiZw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton wrote:
> On Thu, 15 Jan 2026 17:43:02 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:
> 
> > When a CXL RAM region is created in userspace, the memory capacity of 
> > the newly created region is not added to the CFMW-dedicated NUMA node. 
> > Instead, it is accumulated into an existing NUMA node (e.g., NUMA0 
> > containing RAM). This makes it impossible to clearly distinguish between 
> > the two types of memory, which may affect memory-tiering applications.
> > 
> 
> OK, thanks, I added this to the changelog.  Please retain it when
> sending v3.
> 
> What I'm actually looking for here are answers to the questions
> 
>   Should we backport this into -stable kernels and if so, why?
>   And if not, why not?
> 
> So a very complete description of the runtime effects really helps
> myself and others to decide which kernels to patch.  And it helps
> people to understand *why* we made that decision.
> 
> And sorry, but "may affect memory-tiering applications" isn't very
> complete!
> 
> So please, tell us how much our users are hurting from this and please
> make a recommendation on the backporting decision.
> 

To add on here, Cui, please describe which shipping hardware platforms
in the wild create physical address maps like this. For example, if this
is something that only occurs in QEMU configurations or similar, then
the urgency is low and it is debatable if Linux should even worry about
fixing it.

I know that x86 platforms typically do not do this. It is also
within the realm of possibility for platform firmware to fix. So in
addition to platform impact please also clarify why folks can not just
ask for a firmware update to get this fixed without updating their
kernel.

