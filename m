Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF57CF6493
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 23:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F181D6B0096; Wed, 19 Nov 2025 18:29:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7BE6B009B; Wed, 19 Nov 2025 18:29:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42476B009F; Wed, 19 Nov 2025 18:29:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE0626B0096
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:29:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9C081405A5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:29:29 +0000 (UTC)
X-FDA: 84128950458.16.80E254A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 75E7E20007
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:29:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ghbHL63U;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of adam.c.preble@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=adam.c.preble@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763594966; a=rsa-sha256;
	cv=pass;
	b=TLDIn7hr9Noa2N7oIpkbGdwWDSkmZT5zaKfrzbS81OWiJA22n5+T8vuQ3rZUkfaVrOtkZQ
	v2dKc00/bWD5bulz5YvdrvBwaom3LP4b4ss4U4spHawccBq4kGlXnbtZiSmmPJHXXZJjcm
	j/mscPFoQp2sUs3kWlIlXsassPpRc7A=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ghbHL63U;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of adam.c.preble@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=adam.c.preble@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763594966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBZYZBmAvD0ms15o3LlAC3LOg//XfRJIyeChHgfR+3M=;
	b=1gS5eXBZ5+aXIxU4hKhEu2qlm3swolOpbPRddvcZAdwDnVJaKnvacy/Rehi+wcf1MCyTS5
	P+G/8OnNFZZgr7n1V3FZKHUwkFPwN4diel/jwFOHm0BxItIrM6KIInf+sCIoie6NzvqqZV
	xiidImd7NfoOmQ39F8YkgggP6gGgkZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763594965; x=1795130965;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kBZYZBmAvD0ms15o3LlAC3LOg//XfRJIyeChHgfR+3M=;
  b=ghbHL63UNYoVdwmkr2btzbXjCoW0w2aa2VH07lYAlVyOOSeMbJD8CZSk
   CqwVzgFz3cmDHk3mvHsNksVWbhcOwX3CIknJiRFm73TKs7Bx89B0owB0Y
   k6jxGJ+JCnCDuCleuSwMGzAZspxBTnGQxfW413KsZI1JMNs6+LgGsvOv/
   q6F1NuwCbwSqEPYWFtHQ9Os9M1N0T2QvbrdQnYn1R9XGOwI6oTCdwyyEe
   K6deVmDdz14iUOfjbknAqjoqPOsyi/zEw2cBRJPWoGPmDhxNHIMAZyFTM
   IZjwcedMAFR0Uqp9PTsxdcJMIpNRCOv2FU2jHBE1+3M01yCdeSl9p6kTa
   w==;
X-CSE-ConnectionGUID: 3g1jGxEbS2aYHFe/3dAvcA==
X-CSE-MsgGUID: 3DqgNAMcSvG/x6ZhFgu2WQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="53226020"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="53226020"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 15:29:24 -0800
X-CSE-ConnectionGUID: M018CmK/SI+tG5erqNnkkw==
X-CSE-MsgGUID: FEPLeqKMQe66Qu+a1bFYZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="191457507"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 15:29:24 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 15:29:23 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 15:29:23 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 15:29:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jtO8gXHBY7IPRNlo0GI7PNnM/g8sPsKOywTts9c8OXksmOaAGqTMmPymmiBpzKoGq5qEbtCkYpD+bSHIbInVraLqskE0ZtrbB6tF/+xNdVsuy8MDthLSnj+AUTKMivUArCNJomwxRgwV419LSL4qZg0832yxL771MU4EuVrbIO4lq2Z74NrIQwTqHXO1WbAmRiPB6cViYMp+mXnnCopJmaVCzEyGz0PiMjEvWvnzQpr0nDl9jrA0l08AHzBha7nRiXYQuB1poDtJKgAto8FPhrDKoHDmegUjxJFrAmO143znUPWZXsm0iL0KGAkQ8yGDr9MY28JRh4HqVMV4/HMpZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBZYZBmAvD0ms15o3LlAC3LOg//XfRJIyeChHgfR+3M=;
 b=N23fT2++VV2gcxyf598/IAHxub8mTCM3rfnZDrk/L8aretpHRqpU1oHycld8gY4juq0U/XGzvV5rkB46y9MKD5UM1tpQoCbfE3jREaJR7Cy2OD1AknC9t16GZ3k2TdWQPlfB8VuhNliKtY45FDrSiq0ByLwX3dv30fd8EQipPlL6fA1vNtO1Y2piVWGYuZYZ3EfI5TLeLrLCFLXAIjuV4XldG7i+UC2nEOEBPsPxud2y9czaeq1TxI/yBkXhQ7cQ9oJkIG/Wev7gRLOkIX8Q/CEnxYupyej65B2DGwjrbjrPYih+3n6aX0XynYb25JUlqt3bz59A0+DtOWGYoud7bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6523.namprd11.prod.outlook.com (2603:10b6:510:211::10)
 by IA0PR11MB7378.namprd11.prod.outlook.com (2603:10b6:208:432::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 23:29:18 +0000
Received: from PH7PR11MB6523.namprd11.prod.outlook.com
 ([fe80::fffc:36ac:37ac:1547]) by PH7PR11MB6523.namprd11.prod.outlook.com
 ([fe80::fffc:36ac:37ac:1547%4]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 23:29:17 +0000
From: "Preble, Adam C" <adam.c.preble@intel.com>
To: "vishal.moola@gmail.com" <vishal.moola@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Understanding profiled tagged allocator growth in a stock kernel
 that's just idling
Thread-Topic: Understanding profiled tagged allocator growth in a stock kernel
 that's just idling
Thread-Index: AdxYGCtDtjwVOPyeSNicTIEIbszh3wAoHYsAADzokwA=
Date: Wed, 19 Nov 2025 23:29:17 +0000
Message-ID: <8f18b00f3f25471e650dc4ab1b23cb314620eb4a.camel@intel.com>
References: <PH7PR11MB652386A774115119B0DC7B38A9C9A@PH7PR11MB6523.namprd11.prod.outlook.com>
	 <aRy59MtQ6UtauWrQ@fedora>
In-Reply-To: <aRy59MtQ6UtauWrQ@fedora>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6523:EE_|IA0PR11MB7378:EE_
x-ms-office365-filtering-correlation-id: f079e35b-72e5-4506-cb62-08de27c375ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ekE2TExsbTk1S1M5aVNORktMTWlBNzkxb21iVGNoRnR5dSt5NzhWb3JYUTVZ?=
 =?utf-8?B?dEJ2THhYdzRkV2FqOEpGM25reWtlQ2g3VVJPZmxmQWFGSHhqSS80Mml4aEVw?=
 =?utf-8?B?WkFNb0ZDY1E1WmV1OTNseXB6d3NVSHVaZ2YwVmoyMzZBc3NKVk1TWWlqbGYz?=
 =?utf-8?B?WHFXWW4rQlMzZVBBMlVNbE1NTGZZNDJKVkI2UXhtUmk4blVVZUduWUsyUFht?=
 =?utf-8?B?cXJLZENoN2Z4Zm50YTh0b1NpZW95b0N2NUNxVkNVMTY0ZzM1elNMMTV4ZDZ1?=
 =?utf-8?B?ZHdGaWx4cmxJUDJPTmxWOEFDelVRTDMwOHJTODk0bVVYd3MvakppMURDcjVB?=
 =?utf-8?B?cjM1MTNDMXBpOEw5YTZFWjViWVc4UUdQMjQrREVtRmxtVS9jZEwxUVNHWVJp?=
 =?utf-8?B?clRLV3JwZGo3aHdlRXpINXJxcmpZdFZjYzN4Mk1PRXh3TlhRVnAvUWdTSWtq?=
 =?utf-8?B?Zlg4eElLdjB0b1ZZazRIbGtpaUl0ZkhPZUZIeGhKK3pNWlpxbi9PQTI2bkIv?=
 =?utf-8?B?TVU0dHRpaFJrMU9ndjAwak00SWJQOFlvWndYcXhudHY5VUs3dkdVbzNnaWd5?=
 =?utf-8?B?UmtMT1lMN2FmVHhpNlAweFhDUWJNTy9jMThjMXFiUFVSSzlGY3RSdk8wV281?=
 =?utf-8?B?QStaazVuL0pNMnpJRmFodGUxOWQxUW5yUm5HckIxTUNwSW40L0ZqRDJHaDR2?=
 =?utf-8?B?VjRRSVFSbEdpL2h3MUNRcFVCaVNqVE9vdGlMbDBUV2F0dDF2RThJempkQUVl?=
 =?utf-8?B?QUlCMTAveTY5U1ZZVUtNTXcxOVg0ckpTZzlMRU5BOEY5RkZuVFhySlpDSDh4?=
 =?utf-8?B?TFFiUkE1VE4vcUI1RFFDaW1Gd09saFZZWXBheW51RzlpY0V6K2dLQ25Vc1Fr?=
 =?utf-8?B?eG1iYkZ6OGNLb3ZFZkdCdWdXeUZHQzhPNElvSzVpblZLOWI1dExuRmhSZlQr?=
 =?utf-8?B?QWZHdHQ3cmZUTysyaVpVaURnN3drZnlpbmNjK004RC92N29pMERpNGtPUlY2?=
 =?utf-8?B?ZG5rbnFoVy93bU5YdjM4TGNUbWxjWVNzT2tqMnpBTThXZkkrQTZrbVdkZkpC?=
 =?utf-8?B?djNJczhiQ1FTV2xQYXc0RndrQ2RvcEtGZ1htODRaR3dLQWJ5c3pubHdRT2J0?=
 =?utf-8?B?dVpvK3phMFRDZEkzL3F5OStkenVFSWVWOXp4STVYT25rc0ZTUEZrZjQ1ZHMx?=
 =?utf-8?B?aVpsU2lCQTZBYVNYVmFlSmprUnErcUtOek1uMFlOMGhOQ1lVdGNDeFVUVWh2?=
 =?utf-8?B?NTRuMnRCeG1JdXJ3VWY2Y0FWTmtqaHNpWVUzREZ0TVJvSTg2dEJDMjVlWHRW?=
 =?utf-8?B?MUczQ2dENmxUcm5rNG5VYy9kSytKbzgvbWIzUnY2TXBQSllySEZacVZUcWlm?=
 =?utf-8?B?NElGMFlWRWFFNzcyQ1l6dlgwSXhRNWgwbnJ6QThXdzkwdGxtektsRDBreUpq?=
 =?utf-8?B?TzA1VUNlcXBmdHZrRnQ1SzFpL29XVTR5TVlCeTVmemNydzVLT0dDamZIM2N3?=
 =?utf-8?B?M0hrWHJCbVRMcDd4clh2c1ArWjIrTHRPVHdQZzB4bnZUaUZPdXNlYURGa3px?=
 =?utf-8?B?dGp2enFQUDNna0d4NGdFbnlycWRRVDZOM3J1YVVPQ1djdjlDaG4yQ3hGM0Qz?=
 =?utf-8?B?ZXY4NVRIU1ZjZ1I1NXNpelAzRlFQTnFkWHJ0L1lyR2FVQlFDOXRGV0pkZkpY?=
 =?utf-8?B?TGtPTDQ3TmNUTm9nQmFUcHF2RHJONzkreDFDRmdNL1pkSVl4RlpBaVdITSt0?=
 =?utf-8?B?emhpcWFoK2V5Y3ZDeStjTDMzY2NPRVZGelJpMUlDVzBoenN2aUJ3RSs2MDYy?=
 =?utf-8?B?aXRqYnpoWTlnSnhQNWtwZTUzaEJwMUlmUUJmZEtobEpXTTFCTVYvRTdVeE1M?=
 =?utf-8?B?dytFUUxNQW9zSzQ4a3F2MmFtSXFpb3dpTlFhUUZ1UUVvYmxGQTVuUnE4eDV6?=
 =?utf-8?B?cGpsaWxJd1VPYUZMWE9KalpCWm1XQjRHdTh1Vjl0VGs2RTVKRU1tYjJBbUx4?=
 =?utf-8?B?QkZlRXpWT2xBWE16Zlg3bnJDVStiN2VtMUNybVd2SUlrd3hLamVYMTl1elQ5?=
 =?utf-8?Q?BT6kSF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6523.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjFwL2Vrb0VBcjRZOEtJSTE5SEpjNk9NamxiMlVtNnRsbEI1c3VybjhDR2Yv?=
 =?utf-8?B?NDZEUkJTK3dRdTJ5dmZWMW5Ec1dncmpGTFNaNnkrWDJjNFBKS0lOVi9zZGxk?=
 =?utf-8?B?azdtSUx3eEhNUENYWGVCNUtqM0g1SXgvenBWaG8zRzF3aDZYUmUxLytkMVJW?=
 =?utf-8?B?N2VDcTlRWWZoUEwwa2lSTWJFdURCR054ajhQWmhZQy9Uc2VJd3lhVUFsODJ5?=
 =?utf-8?B?T1NUUktZa2JCMVB6ME1yUlFWdG83NC9SK091aGJyMXBTaGVMM0Q2T2h0VnVM?=
 =?utf-8?B?OXJ3UWoxK3BIMGkyQVZmUm5sUnJudHVOUHNtRGpxL1NIb0EydFhudlN2emNP?=
 =?utf-8?B?b1NLdHZvay8vWnluOVhBaHFaQjZZc2RVTEovUzBXZkpWdVQvOWE4RVpmb3NE?=
 =?utf-8?B?MWJINFBRQUtYeHduVHpRR1VrdlJTOUxhbkJzbDZHMU1DblZJNmcwZVU1VmR2?=
 =?utf-8?B?RkxZTVdTMjFVYlQzSTdDWG5zNDYrRmw1dWhnVHNoWW93bUtrOGRzY2o5dUJ0?=
 =?utf-8?B?anF4enVwd1VjL2RDUlkwckVBd0Jrc1VCUXFTQkdRQ3J3TTJESGNLOHR2eUhk?=
 =?utf-8?B?K1dONlV0UklEaDBSK3BpOGRxOWhhYjhaTUFGLzRmYUpQVWQ1cEp3eStwaFlY?=
 =?utf-8?B?SnpoSDlQT0Y2QmJRUDNlUUpRK1VaaE1kTVRWT0V5dUxWNGlGVm00bGF6L05R?=
 =?utf-8?B?QkozM0lMMmdJbi84ai9sY0VhNFp5UWxvY0d4NnFoNHl0ZEI4OGFEajFUdFJz?=
 =?utf-8?B?UExFMHZBVWgvNnYxVmlhRllyYk9tK3FOdnNaQ3hIRzNiaWhOU0p4WDZvVndH?=
 =?utf-8?B?OU9RQ0gzTjlEYkx1elZmSEZwc3hxWFlpczczeHJvZkNvem41YkhDWHJQVUpo?=
 =?utf-8?B?cWhhRWdHSWFwdFZvalEzbmtJeDQyV0ZIZXk0ZjhaYkxYUXFmQSthQVhtL1d1?=
 =?utf-8?B?NExKNWc5dFNueEdUYzQvTDNSMGpNNmZJRU9LMXFHaVNFZlFiUkwrS0wyd0d2?=
 =?utf-8?B?akZYK3BMYXlwNWluOGNzTG94UktuM09yOU5nTkxuUnJoNG1nUndNWkxOdWd5?=
 =?utf-8?B?RkdzMHZLK0NldExqWFhQYWJlQ2ZFc1dVdStwTjlkZjlXUGdSOW1qY3VOWE41?=
 =?utf-8?B?YmRsY3Q4MlJJUzNRN1ZHZm56MmphL09QVTRYKzVsT0x2Y2FKU1NJY2tNUFZy?=
 =?utf-8?B?Qnhrd0pzcytIZCtvWmRMYUNKdUJpbUhBT3NFSVRVaFE0bUpRaXJvTEttT2J0?=
 =?utf-8?B?ZDhrd3IvOEJyYVFMZXg5K285ZmI5a2tWUHh0c3RYU1RsOFZNQUVCcW5uQ2xE?=
 =?utf-8?B?a1diTlRlN1JKSWhjSi9adnQxTzJKTDV1ckl2TjVUTFVleWhwbm9EM2JDd001?=
 =?utf-8?B?OTVoT0h4b1BhdW0wWnNITVptVlp3QVBKR1JNZW1adVErc0xWdjBYZlorR3Av?=
 =?utf-8?B?b0NFdHFzWDVlVGk4eVc0TVBoZ0ZrbVl2VEpSaDBaeEtCQTAxeCszcmE5S09u?=
 =?utf-8?B?QlFpazhONXhmWXBNNVltdEc1TzZia1FvMzVZNnRWZC9HTXhvYnFKZ3J1MWoy?=
 =?utf-8?B?QVM1UWM1WGVnMEwyWmtGZnMwYTZKaW9GQTlDT2RhUlN1eit5cTg2c1ZjVUJ5?=
 =?utf-8?B?STFRL0JnQTU5bzl4QjYrRDA3K3V0VHhRY3hFQU0rekJub1J6bTRzVzdOTCtL?=
 =?utf-8?B?TzJaMmxDajNXWENjUUo4VXVEVVRScmVFTzFIWUNSOGlzRWQ4MHdGRTNJelNN?=
 =?utf-8?B?Y3hnSlpEek9pYVpZQVI0S1lESlhYVUZrSUY2SjhkNkV5ZHdBbjRwUUEzZmp6?=
 =?utf-8?B?MGprVzFWVTNUb2FqVGNZSjl4N3JLQ1dNUkM5UG02MFFoWHdRM2ZpU1kvWGph?=
 =?utf-8?B?eGdrbThOZ1RQUjhXT1NtbU04ekY4ZjQ1Y256ZmNUeGRyZ1ZzZmRHamFWWHJa?=
 =?utf-8?B?RWVqRmlNYjk4UmEyQllDdVNZcFF3SlZjVzBPWm82V0JHMkJaOXZ3NmQzMmZK?=
 =?utf-8?B?L3VvZVZHaXhIbWdHSlJMOUlLUW8xQXhvK1NyZWJNRkVlVmVna1FKTnhvVjdp?=
 =?utf-8?B?U2wzdUQ0UVRTRFhpbkhiQVExR0w0eW9pYlJKWU9tMnZTZXZ1ZkFNSEZta2tH?=
 =?utf-8?B?NGF1V1h4Y2czS2ozY3JIY2tzWGxJK0ZIdExVcVNhWW5LeXU0Rk5kMnhScHdy?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67D35FC8FCB45040ABE318DACF795766@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6523.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f079e35b-72e5-4506-cb62-08de27c375ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2025 23:29:17.9296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wCWYSueSi+yYzggZBiE0bixh18oIzxhWksVM4OB5R20Rsgfm5ugs1uIpQyX2snQCARsL+bKRDvlEePUR/rHQug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7378
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75E7E20007
X-Stat-Signature: 5e6o6o3sroji3rgeizkf8azt3fcpibay
X-HE-Tag: 1763594965-490092
X-HE-Meta: U2FsdGVkX18e6LJCSVz6gV9LqASnnO//Oi341WnVkJc4yImK6y87e4zw6eO8zm0Kcse+gYNcP3aeWtj5If6M4ZJuZLGXO5RwSFZB/YlSraRKd4ht0BIhu+s4KCfddVyRN8Wdxzfml8zpN9jiNU5zu4eZbFvvbv1fLZ1HilHXHju0ZTE60mrJPwKcM7W0HRlstyQ8w2cMGY6JCd93Nne/D3Nx4tI3Wdg6V/NzaJFquxp3P2oXP31vOaT+9ofcKMJSq704ja4o5PoinKsOcGnAKv1ZRIFAVCaIH9rvPEqWdb1VXPsPV9Jqjai1itcCynjdpSDC+rloQgEvX+ZUpLmmc/hjsdFSYVk33nZ86tgPO6eGxfk0RxshtKxNWzams16ONaHYCYBnhL/wm5aGzzUOCBbiJnt1CkkZy/UmUxxQ4PfxY4TYRcJZ1hMYvPFA40da0YVD3wgG8mqKeDRsGMAeJpV7RRcbZ9t1Oz4UnYWiJWlPVswXpfnDRhEwE/ry3ion65LTxbllvWIBcviLHcw6NodipvsFtNsnA7AcpQ0KZQzFGl/VMFnwoAU0dgIJYtuOPylAqfxubWjHHt40Z2ZMhBE4t1a1Y6VWLGMMDbhf05CBO00Y7CBbE/+EhCcKtJvQdjuwo/3fJHyKW7aokRP+F1n/rB6yEULSYgcfI3dxhPEZWr1M7DWj1ruD1isI9f9/9CHRat6dBNgW4NF0CXBXweAAEwBHPCARKyazA0RKdVnjkOz50/msBdyNMrU3tGUZc3xn2MapooCvximOHdb/MbFl6hU7lle7p+dYXbU0AWpw/mVY2x4w8RE5uHSGQHdUIt96BJclDdseEnEY5u3VCy5pxUdNTXrY+U8S8bQ51yUxoXslCjfquAs7vikpScfoiXv+rkYmqtqNBd+8JSY1Y580uXzx/0LeNeynJGKaKWzdyS1zh0+0cNRCeDJ0/V/BU3jGr+u7ZWohi/y1baO
 MOeNrmaT
 6Z10gKlUmimxE+pxRejqUSFVtgUDhGK7Ba0Hb5SJByloEnOyywhMEem9eVkxNkYnDchybfRYxYWaMNVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVHVlLCAyMDI1LTExLTE4IGF0IDEwOjI0IC0wODAwLCBWaXNoYWwgTW9vbGEgKE9yYWNsZSkg
d3JvdGU6DQo+IFdoZW4gbWFraW5nIHJlZmVyZW5jZWVzLCBwbGVhc2UgbGluayB0aGVtLiBFc3Bl
Y2lhbGx5IGluIGNhc2VzIGxpa2UNCj4gdGhpcw0KPiB3aGVyZSB0aGUgc3ViamVjdCBsaW5lIGlz
IGRpZmZlcmVudCBmcm9tIHlvdXIgZmlyc3QgcG9zdFsxXS4gSXQgbWFrZXMNCj4gaXQNCj4gZWFz
aWVyIHRvIGtlZXAgdHJhY2sgb2YgZGlzY3Vzc2lvbnMgOikuDQo+IA0KDQpGYWlyIGVub3VnaCEg
TXkgbGFzdCBiaXQgYWJvdXQgaXQgaXMgaGVyZSBbMV0uIEkgYWxzbyBnb3QgYSBiZXR0ZXIgZS0N
Cm1haWwgY2xpZW50IHNldHVwIGdvaW5nIChob3BlZnVsbHkpLg0KDQo+IA0KPiANCj4gVGhlIG51
bWJlcnMgaGVyZSBsb29rIHByZXR0eSBub3JtYWwgdG8gbWUuIFRoZXJlIGFyZSBhIG51bWJlciBv
Zg0KPiBwbGFjZXMNCj4gd2hlcmUgd2UgY2FuIHJldXNlIG9iamVjdHMsIHNvIHdlIGRvbid0IHBy
b2FjdGl2ZWx5IGZyZWUgdGhlbS4NCg0KT2theSwgSSBhbSBnb2luZyB0byBhc3N1bWUgSSdtIGp1
c3QgbG9va2luZyBhdCBub24gc2VxdWl0dXJzIHRoZXJlLg0KDQo+IEknZCByZWNvbW1lbmQgY29u
ZmlybWluZyB0aGF0IHRoZSBleHRlcm5hbCBtb2R1bGUgaXNuJ3QgdGhlIHNvdXJjZSBvZg0KPiB0
aGUgbGVhayBmaXJzdC4gTWVtb3J5IGFsbG9jYXRpb24gcHJvZmlsaW5nIGRvZXNuJ3QgdHJhY2sg
c3RhdGlzdGljcw0KPiBvbmNlIGEgbW9kdWxlIGlzIHVubG9hZGVkLCBzbyBJJ2QgcmVjb21tZW5k
IGluc2VydGluZyBhICd3aGlsZSgxKTsnDQo+IGluDQo+IHRoZSBsYXN0IGxpbmUgb2YgeW91ciBt
b2R1bGUsIHRoZW4gY2hlY2tpbmcgL3Byb2MvYWxsb2NpbmZvLg0KPiANCj4gQWxzbywgYWZhaWsg
dm1hcF9hcmVhIGlzIG9ubHkgYWxsb2NhdGVkIGZyb20gd2l0aGluIG1tL3ZtYWxsb2MuYywgc28N
Cj4gaWYNCj4gdGhpcyBpcyBhIGtlcm5lbC1zaWRlIGxlYWssIEknZCBzdGFydCBsb29raW5nIGZy
b20gdGhlcmUgZmlyc3QuDQoNCkkgdGhyZXcgaW4gYW4gaW5maW5pdGUgbG9vcCByaWdodCBhdCB0
aGUgZW5kIGFuZCAuLi4gaW5pdGlhbGx5IGRpZG4ndA0KaGl0IGl0LiBJdCBsb29rcyBsaWtlIGRl
aW5pdGlhbGl6YXRpb24gd2FzIGJsb2NrZWQgb24gc29tZXRoaW5nIGFuZA0KZGlkbid0IGNvbnRp
bnVlIHVudGlsIEkgZWNobydkIDMgdG8gL3Byb2Mvc3lzL3ZtL2Ryb3BfY2FjaGVzLiBJIG9ubHkN
CmdvdCB0byB0aGUgZW5kIGFmdGVyIHRoYXQuIFRoaXMgaXMgYWxhcm1pbmcgZm9yIG15IG93biBj
b2RlLCBhbmQgSSB3aWxsDQpiZSBsb29raW5nIGludG8gaXQgdG9vLiBIb3dldmVyLCBteSBub3Jt
YWwgdGVzdCBwYXlsb2FkIHdpdGggdGhlDQpncm93aW5nIHZtYXBfYXJlYSBkcm9wcyB0aGUgY2Fj
aGVzLCBzbyBJJ3ZlIGJlZW4gZ2V0dGluZyBteQ0KbWVhc3VyZW1lbnRzIHdpdGggZGVpbml0aWFs
aXphdGlvbiB0ZXJtaW5hdGluZy4NCg0KSGVyZSdzIHRoZSB0b3AgMjAgd2hlbiBJIGxvb2sgYXQg
d2hhdCBJIGNhcHR1cmVkIGFmdGVyIGhhdmluZyBhbGwgdGhlDQpjYWNoZXMgZHJvcHBlZDoNCg0K
ICAgIEdyb3d0aCAgICBOZXdTaXplIFRhZ0luZm8NCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KICAgNzE3NjE5MiAgIDExMDcxNDg4
IG1tL3NobWVtLmM6MTkwOCBmdW5jOnNobWVtX2FsbG9jX2ZvbGlvDQogICAgOTgzMDQwICAgMTk0
OTY5NjAgbW0vcGVyY3B1LXZtLmM6OTUgZnVuYzpwY3B1X2FsbG9jX3BhZ2VzDQogICAgODYwMTYw
ICAgIDExMjIzMDQgYXJjaC94ODYvbW0vcGF0L3NldF9tZW1vcnkuYzoxMjM5DQpmdW5jOnNwbGl0
X2xhcmdlX3BhZ2UNCiAgICA4MDY5MTIgICAzMzgwODM4NCBtbS9zbHViLmM6MjQ5NiBmdW5jOmFs
bG9jX3NsYWJfcGFnZQ0KICAgIDU1Mjk2MCAgICAgODA2OTEyIG1tL21lbW9yeS5jOjQ2OCBmdW5j
Ol9fcHRlX2FsbG9jX2tlcm5lbA0KICAgIDE2NDE2MCAgICA4MjI0NDE2IGtlcm5lbC9mb3JrLmM6
MzExIGZ1bmM6YWxsb2NfdGhyZWFkX3N0YWNrX25vZGUNCiAgICAgNjE0NDAgICAgMTUwNzMyOCBr
ZXJuZWwvZG1hL2RpcmVjdC5jOjE0Mg0KZnVuYzpfX2RtYV9kaXJlY3RfYWxsb2NfcGFnZXMNCiAg
ICAgMjA0ODAgICAgMTM3MjE2MCBhcmNoL3g4Ni9tbS9wZ3RhYmxlLmM6MTggZnVuYzpwdGVfYWxs
b2Nfb25lDQogICAgIDEyMjg4ICAgICAgNDUwNTYgbGliL2FsbG9jX3RhZy5jOjQzMCBmdW5jOnZt
X21vZHVsZV90YWdzX3BvcHVsYXRlDQogICAgICA4NzYwICAgICA4MjExMDQgbGliL3JhZGl4LXRy
ZWUuYzoyNTMgZnVuYzpyYWRpeF90cmVlX25vZGVfYWxsb2MNCiAgICAgIDgxOTIgICAgIDI2NDcw
NCBtbS9saXN0X2xydS5jOjQxMCBmdW5jOm1lbWNnX2luaXRfbGlzdF9scnVfb25lDQogICAgICA2
NTI4ICAgICAgOTU5MDQgbW0vdm1hbGxvYy5jOjMxNzYgZnVuYzpfX2dldF92bV9hcmVhX25vZGUN
CiAgICAgIDU3NjAgICAgICAgOTAyNCBuZXQvY29yZS9kc3QuYzo4OSBmdW5jOmRzdF9hbGxvYw0K
ICAgICAgNDA5NiAgICAgMjIxMTg0IGFyY2gveDg2L21tL3BndGFibGUuYzozMTQgZnVuYzpfcGdk
X2FsbG9jDQogICAgICA0MDk2ICAgICAgIDcxNjggZHJpdmVycy90dHkvdHR5X2J1ZmZlci5jOjE4
MA0KZnVuYzp0dHlfYnVmZmVyX2FsbG9jDQogICAgICAzNjgwICAgIDIyOTcwNTYgbW0vc2htZW0u
Yzo1MjExIGZ1bmM6c2htZW1fYWxsb2NfaW5vZGUNCiAgICAgIDMzMjggICAgICAgMzg0MCBuZXQv
Y29yZS9za2J1ZmYuYzoyODMgZnVuYzpuYXBpX3NrYl9jYWNoZV9nZXQNCiAgICAgIDI5NDQgICAg
ICAxNzY2NCBrZXJuZWwvZm9yay5jOjE0ODcgZnVuYzpkdXBfbW0NCiAgICAgIDI1NjAgICAgICAg
MjU2MCBpcGMvc2VtLmM6NTE3IGZ1bmM6c2VtX2FsbG9jDQogICAgICAyMDE2ICAgICAgIDI4MDAg
ZnMvZXh0NC9tYmFsbG9jLmM6NTY5NSBmdW5jOmV4dDRfbWJfcGFfYWxsb2MNCg0KSWYgdm1hcF9h
cmVhIGlzIG15IHBlcnBldHVhbGx5LWdyb3dpbmcgc2xhYiBhbGxvY2F0b3IsIHRoZW4gSSBzdXBw
b3NlIEkNCnNob3VsZCBsb29rIGF0IF9fZ2V0X3ZtX2FyZWFfbm9kZS4gSXQgaGFzIGFuIGFsbG9j
X3ZtYXBfYXJlYSBjYWxsLiBJZiBJDQpoYXZlIHRvLCBJJ2QganVzdCBtYWtlIG15IG93biB0cmFj
ZSBwb2ludCBzbyBJIGNvdWxkIGNvbGxlY3Qga3N0YWNrcw0KZnJvbSBpdC4gSSBhc3N1bWUgSSB3
b3VsZCBzdG9yZSB0aGUgcG9pbnRlcnMgYWNxdWlyZWQgZnJvbSB0aGUNCmFsbG9jX3ZtYXBfYXJl
YSBjYWxsIHdpdGhpbiBfX2dldF92bV9hcmVhX25vZGUgYW5kIHRoZW4gYWxzbyBhdHRhY2ggdG8N
CmZyZWVfdm1hcF9hcmVhIHRvIHRlc3Qgd2hlbiB0aGV5IGFyZSByZWNsYWltZWQuDQoNCkFsc28s
IHRoYW5rcyBmb3IgdGhlIGlkZWEgb2YganVzdCBsb29waW5nIGF0IHRoZSBlbmQgb2YgdGhlIGRl
aW5pdC4gSQ0Kd291bGRuJ3Qgbm9ybWFsbHkgaGF2ZSB0aGUgbWluZCB0byBkbyBzb21ldGhpbmcg
ZG8gdGhhdCBraW5kIG9mIGV2aWwNCmRlc3BpdGUgZHJvcHBpbmcgaW50ICQzJ3MgYWxsIG92ZXIg
dGhlIHBsYWNlLg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS9QSDdQUjExTUI2
NTIzOUZDNzc2M0U5NTRENEFBODI4QTVBOUNEQUBQSDdQUjExTUI2NTIzLm5hbXByZDExLnByb2Qu
b3V0bG9vay5jb20vDQo=

