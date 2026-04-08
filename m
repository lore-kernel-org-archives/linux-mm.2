Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9D51073CA6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1A16B008A; Wed,  8 Apr 2026 08:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8EA6B008C; Wed,  8 Apr 2026 08:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3356B0092; Wed,  8 Apr 2026 08:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA8AB6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:29:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD2B01B9014
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:29:26 +0000 (UTC)
X-FDA: 84635319132.24.ABDCC05
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65C6BA0009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:29:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RSTp05Of;
	spf=pass (imf25.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775651363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmt7jGPc/BHWJ0lS7/yAl+Uh0kWODn9vZ+cyUObNJGU=;
	b=AHk7zF2U+ZS5XVoT6EF9P9d5KZ95atAEJMGhC6XLNaN2iRxwqXWKNrb1PLLBE0l8acQjCs
	vgyV33G/uzcT+q20E4ai4oN67dFwoFlOhS/mqJfwkJ5q6X8RctOiYT4RSXYFl3Z6lr/8Mf
	UiXx3bVrw6OzuDu2x0Apl3md8u2YlEc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RSTp05Of;
	spf=pass (imf25.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775651363; a=rsa-sha256;
	cv=fail;
	b=6KZ3ADjqQK0De0bdbinmmc5KX3R2E6R8zhjS86aSQ40S2Pbf4t+mPgUfRji0KW9WjfRReo
	LxhjadElGF52ASyeDt1zWXhwWzlBvfMa8EjJOcl+I2AMxcxVN57zKI31npMAC4qEMgbiY0
	pkrh21r6m/kP3X0oG5DlZd+j98ikx2M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775651362; x=1807187362;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kmt7jGPc/BHWJ0lS7/yAl+Uh0kWODn9vZ+cyUObNJGU=;
  b=RSTp05Ofo38TfNekKnVS3mUMEJbPoeUau2xjpEm3ZCPMkMbofw00qCLU
   GrllBzZ7jOnA5s1lDMSAs5g+fryMTGvOnEP5w/Y2GexxjMS0oizQc2d9c
   YqiVBJMe3pEw6VM1BvY34MYZQcXVjtcmnddYso12CL7zHsikq2re86XwX
   S676EaCf7AcusMX6amXnLemGMA/rJ2cy7A/SC2vmyahEeMgIEd0xbciiy
   S/eZ/hoQztI9pUtMVsKudKb+qWRoGDaxztIG7zIaH45yNtGpT4xjC5xxb
   L4Rh3Ah4cf6aVTfHA7mQE+OMR+kDueA8U8GhEcPqulq5SZSNJ7ghBVG9a
   g==;
X-CSE-ConnectionGUID: wAAcpSIwSi2l4I2NC0osZQ==
X-CSE-MsgGUID: nM6swXEmTamSd4Yc3vJJ8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="76702694"
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="76702694"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 05:29:20 -0700
X-CSE-ConnectionGUID: ua87amQ6TICXhUiCAPqVSg==
X-CSE-MsgGUID: PE1LEwYgTjSNv4zJq6ZNbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="258885688"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 05:29:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 05:29:20 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 8 Apr 2026 05:29:20 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 05:29:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dncgNdGD7aiRgMWwdlRejtdfg5ytwOKBKQBGmopY4lGRp5dmIFv1hX3XWyt17uKcMf4RVXbPUpzUbCNAh97ed5I74bmw9Nw1U9/OxQhQJKme2w2RGsWpKobLVh2nOiWqYNaJ2L2L//zOPb3bvytG73NwmyIBRmrj3GwHiiW6xWL1MemKiivFGLkZPTfGUecqWFsP5Mgkm+rWrpb4Dn9ULLoPgg6nXlTGimT2H1Q265ePxH6nXKd0aHYYSJ9C4ycV4RbPXupo14WTFy1hkCeo0jISkTWs91f9USIoTjXQlwCVX4zGPYysszkscEVDH5/N3cp1ncH5qVhHpnXlZB3BZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmt7jGPc/BHWJ0lS7/yAl+Uh0kWODn9vZ+cyUObNJGU=;
 b=F2vJqLGiYDutKo0U5cGYiD0+pQcOHnDkFW82fBA05RufTNdrM2lkNnk374Ja4dXElqgVS7I/o8ATOn9zSloTuiz51K7Ua9C/fVNWmkKEZbt1eqe/7qo96H//6/gUp1ecelEeMuGdne6sWVb+8ky4Uw5QJjwnP422oRFOW6XDF2W3ZI0F04HsgtbxaDPWUyIfk8U61XyeF4OvGOqLIXYkshXsYyU55HsG1zsVVrEUNkf5ds7YiZJ4fmuCN9d0RqyVAe0p6svgsYYKHVtKdZ3v8+MWN8BXb8zZNfUItXL33J95A2IuIDygmAqu1u+jPYUX/Fytb+Levy2q75e8/9fVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9009.namprd11.prod.outlook.com (2603:10b6:208:56f::21)
 by IA4PR11MB9201.namprd11.prod.outlook.com (2603:10b6:208:561::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Wed, 8 Apr
 2026 12:29:11 +0000
Received: from IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541]) by IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541%4]) with mapi id 15.20.9745.035; Wed, 8 Apr 2026
 12:29:11 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Topic: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Index: AQHcxwYPPar5wabLkEWQfiO/Xde9s7XUxrUAgABPwPA=
Date: Wed, 8 Apr 2026 12:29:11 +0000
Message-ID: <IA4PR11MB90099CF424CDD1E88A30504EA35BA@IA4PR11MB9009.namprd11.prod.outlook.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
In-Reply-To: <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9009:EE_|IA4PR11MB9201:EE_
x-ms-office365-filtering-correlation-id: a221d3b9-55a8-421e-fa1a-08de956a7011
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: JjSxsdqMlutcS8C1baMDrF8RC9MV0J98YgaDIBjjNjTJFIw+I6+MQLHm/HjOMtIx71YzbHajj+PCtraG6S6Hg8tuzdc83j2FwRIKyzXojIcNbheSq4Eci4XSTzV5WxwlTK0Fryg41DeyrC/98FTd3jEf3mEkI8MjXlW+xHkPNU6kOA5g1qXBiOMMJ0Uh5FEav45acIKk9bTXc8UA6YyzOOkBf2yqpEnzrILJcnROCU12Yjo/zTdaBsBWJy89vp4oLrTPWX50p/QWbA69ZhNxG4g2mo8oOjTUlrKVEg82c1zaICcuxv4f+HUgYQbRt3Ljk05mpBCZYRfFVWsgMgNxT7IYiTLlldgSQcpm2tpS8ORr5EYTo9mLqm8j4U3KluVAeIRPSev6dz/6JxPiulOeDtW8xXVed9Tibbv4WNqCINFLQaYC7MifXh9MqvLc340OAc1fstlYm5yHQkI6H5XfpUyowd4T4BmOB2mMeL3/Bg0s3odMI2H2BySN1WBtAeCfnmmQ8rYDO4o6LfImsE8rVVSLhozTwSitVExOedMA+RYo5nS7M7lfGpT4sNBlgvgpUaSOdPsw0XAvA1ZHBeY6Dbu9dMGdKpxODyFtISIzSgRMEaPdxY3ahdz1DuOmfkO2aO3XbmLPT9RM5Z+W2oaH1yAn7YJypBxpF30qKnR7GkrkSDIQYDe4R4p1dEHQiP50PpVQcWemmTj+dC/opBrMJ1t7veUsSvzFCZ/mWjASexiuuv+/KMmCDEa8/CuIdvP0KIhec6Ze27S3mGeMhnV41U2KF35r/ykqmsWWOLGSwFE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9009.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUNnTnM4YkRGZTgxaTZXWjFZd2JlRW14Z2M0YnNZbFd1eTVORXZCRzAzSkVh?=
 =?utf-8?B?OC9aTlVRMTBPWkR5MUJ1Yk5tQjlDV0FveS9HeFBGWEw0V0g0OC84Q2IzNTFv?=
 =?utf-8?B?QkVCSDB1MFIvd28wRmVaVXJ0Tk5lSFpBVGEvcU50ZVUvWE9SR1hWRjdVWVpz?=
 =?utf-8?B?NUVkSXBmTmcxZUtBenhjcFJ2aFVGbnBFbEwvNFZyTVhQY2N5bVBIRUlkOHdu?=
 =?utf-8?B?SE5QK0xXWEZMcTVMUEJkU043VE5nMDlTTVB2alVVSzNIL0pQbHJ1Si9keTE3?=
 =?utf-8?B?ZVpYdW5VY20xUTFTd0pDODRuRmNORWlJV2xMZmVVdjBYM1IzdnIzM0l6eHRQ?=
 =?utf-8?B?SW9wenBWYkNUTmNNVktNU2diWW50WXhWWnBFTDdSLzVUWDlQT0hudFgwY0Fr?=
 =?utf-8?B?YnlDN3l3VE1UZmRDK2JGbUJxNWl2SDdXNVVHb1RoVGkrTVlYbWd4ZU1FNUJm?=
 =?utf-8?B?cGxXZlNqc1FZLzYvVWNialMyby9nYmFWTlc3NEo1ejkrd2lIcUR1eitnekg5?=
 =?utf-8?B?L0YyeHp0OWhPMlJDMWxjd1ZhdEFReThQL2V3RVI0M1F5V0RqRTFRMDZNTFdK?=
 =?utf-8?B?Q21XL0hYN0hIaUlXS1VVTzZQY1pOSWJWenJ1NEcycHE0VWRKRDUyeDN1OUNV?=
 =?utf-8?B?eVJNbFNiemQ1dDdDNWgyZk92bnM2a01va3Y1RVVLUjl4THUvaDNSbnhJS0dz?=
 =?utf-8?B?NUs3enN3MDNBcWppOTI5RjlUbTdZNkZjY1Y4ejdLRmJBaitkemFzZVROT3NW?=
 =?utf-8?B?NTJTaXF6bU8rTW9jVktjWGJJWGwzdlBhaUhvdzU5TzIrbWM0N3FUVE1VRGgv?=
 =?utf-8?B?MnBYUEVkb0dBRitnZTQ5VWZiTjR3K2pSNjJqOUM3cUE4b0NneFRQaVVWNVJq?=
 =?utf-8?B?U1dEWDZUeDg0eE5vU1lPTm1KOXV0K2c0YUhQcHpGSW5MN0JiYmZNZ0NVZHJF?=
 =?utf-8?B?elg4a01xdnJPc1FlMVgvcmVkSis3aC96WHJCeGNxdWd6NGhJZ0dvOGRJZ2FM?=
 =?utf-8?B?OHV6ZWxIN1pIem5yZC9uTW1nZU1IZDRVWkpEV2x3UWVZN05XbFVYejdPRUZh?=
 =?utf-8?B?NGdJZDVwR0Ixa3RZWHprZzcrclM2aFZUT04xSnplVkZqdzNDbEpTbmI0anBj?=
 =?utf-8?B?d2VoVmF6N2IwZ2NXbDFkZjJJazFuMVVQcE82V3VyRmJseENoOHVuNnF0cFhU?=
 =?utf-8?B?SUs0NnZZVVpyc3BKaDl3YVBnazJYL01GNCtCSndKQ3pxTUZkOWZINVdUSlla?=
 =?utf-8?B?MHpicFdZbi9QdWF0YytzVVJtSEtEeER2TWR2RWJYUGYwSGRhQnZETW9Md1ZW?=
 =?utf-8?B?S3FwQmc5N245MllqSm9oNWtlM0I1OHMvcDFFdm5MWnBaSEhWbkZjcUdpTjdl?=
 =?utf-8?B?b3J5VFRXNHN1V2dIYmR6RlUzYkFYd1hQdXpLQTcwaWl1eFhobmF3VHhkVUxu?=
 =?utf-8?B?NnpPNnlvZzlmYVF3T2lUbXpic3FXZDhCdFVjSVhSMk0vMS9uV0VaZzVrZUZw?=
 =?utf-8?B?RDVGdzNHYTVHb3M5UjFEVUpTSVhiT21xeHZCSStBeHZqZXhkaVpXRitmR2tK?=
 =?utf-8?B?b29wS1NqbDVreDFFVm9KVmhtRnFEWjBMVnlodzk5R1BScWdmL0E1eE9Xa2g0?=
 =?utf-8?B?bzdxWWFFVG5KeUdBdlJHdnBrcVR5VGIxYkdYTCtxSlFMTGRHRVJjOG16Qndq?=
 =?utf-8?B?YUlScm9MMXpYc1V4ZVRTMzhKb0R5dSs5RUFHemNmS055dXRBdlIwRkdPcFli?=
 =?utf-8?B?OXU4TU42RXdRdjBJYjU3MWdjUndOVU1JSVd4dnM3SDd3T09IVUpxSXlPSTBU?=
 =?utf-8?B?WG41UXp3eFhwVVNIYmRuemVoSS8vYVNsQXJONU41YU1LazJWWnkxajgwdkxh?=
 =?utf-8?B?R1RIRWljZ3JiaWFxVVZ6MFdNbFlVNHp2SWNwTFRUN2NSNkVxelF2QVpDVHVo?=
 =?utf-8?B?SFl4bWVPUXJEZTc3eTVVdUFkS0ZKTWZBWjlUSjdxdGRPMHNnUjBMUU1QSmcx?=
 =?utf-8?B?Y2dZTW02aVRadEpHRGJmQzB5MkpNL1Ruci84U2tVbFNGMkk2dGV6MzZvMm9L?=
 =?utf-8?B?SFJybHFyaUhiRm56cUE5dHVSZ3RrMkV1d0U5YVNoSitIaDFSVlpJNEg0S3hP?=
 =?utf-8?B?ZEZKSG5tbk1lSXNRZGp5ME1kM0FxQTQ4R3hVK2dQSk5CMTRsek5jTFNtUlhY?=
 =?utf-8?B?TEpLc2J4aUk4RlBtdjJhc0xoR01yZmxEbHBRdVRqZXI0VTVYYXkwMUM1ZFNN?=
 =?utf-8?B?c1ZERDg3MVJzRDllRVlpS2xUYXc0WU5BY2diZDNHYkZHRmI4MXNCWHFOUk42?=
 =?utf-8?Q?krdL1VpvjPCKs5CDOn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Tl1hiTLKtHOqxG2ZJ36POX4MaGijzyHi3Bs+S1GUMvq/1K8zDN23VT7tU71uZDtmy0P/43absOEOl9h9mqGXVKA1OVRjtPti3M3D3lPH/3nqJMLwoHC8So9eSY7vEq2TQ34X/YsWuTnUmJfKMdtH8dUZtIk8AT3HP9FqRWFJyVN1HSqT3lxgBObrhq3VyH3AYp7sWhUcbxwX6JqCqIZkT8nNtOGGFU/WMjWntson5lp2rIOoKl1ELFm/Lcsi1bUcG+Ieqtm2npAYpg+fT8VDGFi/Dukisjh4xO+Y3TFP9tB8z99mu5Pf0qX3CqD9qNFAQDfDhoJAbpsWxMb1IcnqjA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9009.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a221d3b9-55a8-421e-fa1a-08de956a7011
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2026 12:29:11.2341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ahJ4WEnHsaov4J+C4b9bqB/Sgmk+xqQvMGrWUyaKES0ZpB1Vpi073ds4oYp1JTCf3SL3R11IL38JoF6f3wuS9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9201
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 65C6BA0009
X-Stat-Signature: ymuihtdkumz5by9zcnjt4str7esai5io
X-Rspamd-Server: rspam06
X-HE-Tag: 1775651362-923701
X-HE-Meta: U2FsdGVkX1+tKmzZnDymihD/hrAvzSFUS5Ip0kQCF2FAVCQ2Z2UWryQR5pSzMXzVo6PXqEZr2V0oJz2Q/MLgYVhIt3DmA45uYoi/aDWSfJjNLXXltIcyH+w/lnLugl/c/jd/eWUAPsjIehR/J1tz7mbBNGUDrcqBxov+P7FTM+8r6AptwwOYfgOFoF836IwkkWSG28asO7B2ip3Dm93jl8b2LDcQp+IQ/J75gx2iY9ZUba5C26R/CRvVq8O1vjxD0hY17zNu38j3fyHb7XM6oaGI2jzCnb+FG373fz9SAtPEq8+HBwAsTljVV50W1CB16xDOVmd/6yQ/+J99wrELgB4JKdq3VhYAKkXsf8jtkvcSv3z7JJZMpYHuzbZcCOxfiAd+W2aqoiCtU6pbOvsZNbdo1bn2OCtc6JfhAAAho6FiZuArNHoi6echwBPz89caIsKKSsZeZ2GlvMk+XNEScRIPbWxbtY6x/NMfcRZOV4IZO8HPDZ5vVokXFQZEJZvBRWLPYWVScadpWhW2PEDIdn6/bpluabSKPNqKGF+TuMYOEs+h12iHtT44cCVIvLyUBA2ZLO96/sOn6Y35XJm0lKjc8TsNpXa4KpmDPMCSFNjhKyv8WctHwgh6LMbavWcMtLJKq/muHbuq2QyIrTXn8lYDgVXC99z8jN0ikoZft/jgH1TlSqrK+u4NAahUQhln0vzCOeiqG9Wm6U6Z7137ZRdUlnXqjV+GthBam5IDIWHcRc1UWE7YnO6PHx2UMrZs/LpAS5u+EJNZapstXasLIovK8rOVoy8Tk1tOyr9IwRQ1hel28gdJXbobh9TCnsh7jv8xvR+Ri8galn3jJdlAtpmdCVAhqj3Q5+4a3UTFXLWWeb8w6jAKoTnr/O+w2EvTKtheymPaFnrOs+/iLCZLANllE1xCRO/RQPUmjL1QUpkScGpkwcLtF/zPXXJZIJ4+O2pX/O/T4gxtXLKJDsz
 LmyryxRZ
 aBlcQb8tryEYJNsrkKliPMl/9wSdonZZOyajw8F6g25DFOvZEYNMh/5nli7i916rBZJxKG3KWAL+nKHieU2Bo1mTU9z4dzcSPCH9wUzlP/mPKaD5MLullFS1h8IKOHqqxnCVMDSmYp9gGUQHC+RZd85dm/uJgYyUGGSMYOyuMReKO3j08juNol98RQvXffny33lLPaYzbfavyGEU3b+rpeTGu7Or4VTgov+G8m8bguzGuf0k0swebmZlaMyy/8zL6eWhy5xP/1/owSWfV5FzROOd4B4ldt0RfpNMuzYks8YFLxxk7ZH5XKu5pFm9hFuF7zRBv8VbhbaW0HhA+R8y6GJdGOjL3eXAnTx8HeD53ne7qdLSIPuiTzWO/RKH1p0xpbHWJxqYHavVzYu4v/5XEm8idONla/IvRYnDDCG7u2QvCb9916jNvHcIc0NX8t0g/08XQJExARsvONv7tO76elNCkoNYzDvYLK4wZKKiPU+OEK3VDTsYeiUrfGz2IaIB9CVzlhYCBjZ0L35NVFRHY0jP+ngzJSk+ekmVShs1QUsvzW+nnNvIfkviq4x4p+uS4H5KNCuHBx/LzMMPG2fT/YB6CeQrUBjZnZJUmCa7k/2XZ7icQtaRR/zx0+u9H5hK9IvG+S5keXZV1QEBTN7CkmNEsf9/zUEwlCYTDYT5qdiEiVtcXQsmhl6nH8tG+ml903BkQ5AxJPW+H1pTgqJ0CDXct1w6MHZYbKYApSLQ4ZLaB7dhOghxFyWnfuJ3wMfom3JVTRw0HlTyw4I5WPiuwo/UtefJs4V9dxbL5ZVq0isQK+irTrFrSBzAhDzhBWXHkKPtW9vcl8qxDS7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCA4LCAyMDI2
IDM6MzYgUE0NCj4gVG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBPc2NhciBT
YWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+Ow0KPiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCj4gQ2M6IGxpbnV4
LW1tQGt2YWNrLm9yZzsgSHUsIFlvbmcgPHlvbmcuaHVAaW50ZWwuY29tPjsgWm91LCBOYW5oYWkN
Cj4gPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgVGltIENoZW4gPHRpbS5jLmNoZW5AbGludXguaW50
ZWwuY29tPjsgWmh1bywgUWl1eHUNCj4gPHFpdXh1LnpodW9AaW50ZWwuY29tPjsgQ2hlbiwgWXUg
QyA8eXUuYy5jaGVuQGludGVsLmNvbT47IERlbmcsIFBhbg0KPiA8cGFuLmRlbmdAaW50ZWwuY29t
PjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlAaW50ZWwuY29tPjsgQ2hlbiBaaGFuZw0KPiA8emhh
bmdjaGVuLmtpZGRAamQuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYzXSBtbS9tZW1vcnkgaG90cGx1Zy91bnBsdWc6IE9wdGltaXplIHpv
bmUgY29udGlndW91cw0KPiBjaGVjayB3aGVuIGNoYW5naW5nIHBmbiByYW5nZQ0KPiANCj4gT24g
NC84LzI2IDA1OjE2LCBZdWFuIExpdSB3cm90ZToNCj4gPiBXaGVuIG1vdmVfcGZuX3JhbmdlX3Rv
X3pvbmUoKSBvciByZW1vdmVfcGZuX3JhbmdlX2Zyb21fem9uZSgpIHVwZGF0ZXMgYQ0KPiA+IHpv
bmUsIHNldF96b25lX2NvbnRpZ3VvdXMoKSByZXNjYW5zIHRoZSBlbnRpcmUgem9uZSBwYWdlYmxv
Y2stYnktDQo+IHBhZ2VibG9jaw0KPiA+IHRvIHJlYnVpbGQgem9uZS0+Y29udGlndW91cy4gRm9y
IGxhcmdlIHpvbmVzIHRoaXMgaXMgYSBzaWduaWZpY2FudCBjb3N0DQo+ID4gZHVyaW5nIG1lbW9y
eSBob3RwbHVnIGFuZCBob3QtdW5wbHVnLg0KPiA+DQo+ID4gQWRkIGEgbmV3IHpvbmUgbWVtYmVy
IHBhZ2VzX3dpdGhfb25saW5lX21lbW1hcCB0aGF0IHRyYWNrcyB0aGUgbnVtYmVyIG9mDQo+ID4g
cGFnZXMgd2l0aGluIHRoZSB6b25lIHNwYW4gdGhhdCBoYXZlIGFuIG9ubGluZSBtZW1vcnkgbWFw
IChpbmNsdWRpbmcNCj4gcHJlc2VudA0KPiA+IHBhZ2VzIGFuZCBtZW1vcnkgaG9sZXMgd2hvc2Ug
bWVtb3J5IG1hcCBoYXMgYmVlbiBpbml0aWFsaXplZCkuIFdoZW4NCj4gPiBzcGFubmVkX3BhZ2Vz
ID09IHBhZ2VzX3dpdGhfb25saW5lX21lbW1hcCB0aGUgem9uZSBpcyBjb250aWd1b3VzIGFuZA0K
PiA+IHBmbl90b19wYWdlKCkgY2FuIGJlIGNhbGxlZCBvbiBhbnkgUEZOIGluIHRoZSB6b25lIHNw
YW4gd2l0aG91dCBmdXJ0aGVyDQo+ID4gcGZuX3ZhbGlkKCkgY2hlY2tzLg0KPiA+DQo+ID4gT25s
eSBwYWdlcyB0aGF0IGZhbGwgd2l0aGluIHRoZSBjdXJyZW50IHpvbmUgc3BhbiBhcmUgYWNjb3Vu
dGVkIHRvd2FyZHMNCj4gPiBwYWdlc193aXRoX29ubGluZV9tZW1tYXAuIEEgInRvbyBzbWFsbCIg
dmFsdWUgaXMgc2FmZSwgaXQgbWVyZWx5DQo+IHByZXZlbnRzDQo+ID4gZGV0ZWN0aW5nIGEgY29u
dGlndW91cyB6b25lLg0KPiA+DQo+ID4gVGhlIGZvbGxvd2luZyB0ZXN0IGNhc2VzIG9mIG1lbW9y
eSBob3RwbHVnIGZvciBhIFZNIFsxXSwgdGVzdGVkIGluIHRoZQ0KPiA+IGVudmlyb25tZW50IFsy
XSwgc2hvdyB0aGF0IHRoaXMgb3B0aW1pemF0aW9uIGNhbiBzaWduaWZpY2FudGx5IHJlZHVjZQ0K
PiB0aGUNCj4gPiBtZW1vcnkgaG90cGx1ZyB0aW1lIFszXS4NCj4gPg0KPiA+ICstLS0tLS0tLS0t
LS0tLS0tKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0t
LS0tLQ0KPiArDQo+ID4gfCAgICAgICAgICAgICAgICB8IFNpemUgfCBUaW1lIChiZWZvcmUpIHwg
VGltZSAoYWZ0ZXIpIHwgVGltZSBSZWR1Y3Rpb24NCj4gfA0KPiA+IHwgICAgICAgICAgICAgICAg
Ky0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLQ0K
PiArDQo+ID4gfCBQbHVnIE1lbW9yeSAgICB8IDI1NkcgfCAgICAgIDEwcyAgICAgIHwgICAgICAz
cyAgICAgIHwgICAgICAgNzAlDQo+IHwNCj4gPiB8ICAgICAgICAgICAgICAgICstLS0tLS0rLS0t
LS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0NCj4gKw0KPiA+IHwg
ICAgICAgICAgICAgICAgfCA1MTJHIHwgICAgICAzNnMgICAgICB8ICAgICAgN3MgICAgICB8ICAg
ICAgIDgxJQ0KPiB8DQo+ID4gKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tKy0tLS0tLS0tLS0tLS0t
LSstLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tDQo+ICsNCj4gPg0KPiA+ICstLS0tLS0t
LS0tLS0tLS0tKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0t
LS0tLS0tLQ0KPiArDQo+ID4gfCAgICAgICAgICAgICAgICB8IFNpemUgfCBUaW1lIChiZWZvcmUp
IHwgVGltZSAoYWZ0ZXIpIHwgVGltZSBSZWR1Y3Rpb24NCj4gfA0KPiA+IHwgICAgICAgICAgICAg
ICAgKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0t
LQ0KPiArDQo+ID4gfCBVbnBsdWcgTWVtb3J5ICB8IDI1NkcgfCAgICAgIDExcyAgICAgIHwgICAg
ICA0cyAgICAgIHwgICAgICAgNjQlDQo+IHwNCj4gPiB8ICAgICAgICAgICAgICAgICstLS0tLS0r
LS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0NCj4gKw0KPiA+
IHwgICAgICAgICAgICAgICAgfCA1MTJHIHwgICAgICAzNnMgICAgICB8ICAgICAgOXMgICAgICB8
ICAgICAgIDc1JQ0KPiB8DQo+ID4gKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tKy0tLS0tLS0tLS0t
LS0tLSstLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tDQo+ICsNCj4gPg0KPiA+IFsxXSBR
ZW11IGNvbW1hbmRzIHRvIGhvdHBsdWcgMjU2Ry81MTJHIG1lbW9yeSBmb3IgYSBWTToNCj4gPiAg
ICAgb2JqZWN0X2FkZCBtZW1vcnktYmFja2VuZC1yYW0saWQ9aG90bWVtMCxzaXplPTI1NkcvNTEy
RyxzaGFyZT1vbg0KPiA+ICAgICBkZXZpY2VfYWRkIHZpcnRpby1tZW0tcGNpLGlkPXZtZW0xLG1l
bWRldj1ob3RtZW0wLGJ1cz1wb3J0MQ0KPiA+ICAgICBxb20tc2V0IHZtZW0xIHJlcXVlc3RlZC1z
aXplIDI1NkcvNTEyRyAoUGx1ZyBNZW1vcnkpDQo+ID4gICAgIHFvbS1zZXQgdm1lbTEgcmVxdWVz
dGVkLXNpemUgMEcgKFVucGx1ZyBNZW1vcnkpDQo+ID4NCj4gPiBbMl0gSGFyZHdhcmUgICAgIDog
SW50ZWwgSWNlbGFrZSBzZXJ2ZXINCj4gPiAgICAgR3Vlc3QgS2VybmVsIDogdjcuMC1yYzQNCj4g
PiAgICAgUWVtdSAgICAgICAgIDogdjkuMC4wDQo+ID4NCj4gPiAgICAgTGF1bmNoIFZNICAgIDoN
Cj4gPiAgICAgcWVtdS1zeXN0ZW0teDg2XzY0IC1hY2NlbCBrdm0gLWNwdSBob3N0IFwNCj4gPiAg
ICAgLWRyaXZlIGZpbGU9Li9DZW50b3MxMF9jbG91ZC5xY293Mixmb3JtYXQ9cWNvdzIsaWY9dmly
dGlvIFwNCj4gPiAgICAgLWRyaXZlIGZpbGU9Li9zZWVkLmltZyxmb3JtYXQ9cmF3LGlmPXZpcnRp
byBcDQo+ID4gICAgIC1zbXAgMyxjb3Jlcz0zLHRocmVhZHM9MSxzb2NrZXRzPTEsbWF4Y3B1cz0z
IFwNCj4gPiAgICAgLW0gMkcsc2xvdHM9MTAsbWF4bWVtPTIwNTI0NzJNIFwNCj4gPiAgICAgLWRl
dmljZSBwY2llLXJvb3QtcG9ydCxpZD1wb3J0MSxidXM9cGNpZS4wLHNsb3Q9MSxtdWx0aWZ1bmN0
aW9uPW9uIFwNCj4gPiAgICAgLWRldmljZSBwY2llLXJvb3QtcG9ydCxpZD1wb3J0MixidXM9cGNp
ZS4wLHNsb3Q9MiBcDQo+ID4gICAgIC1ub2dyYXBoaWMgLW1hY2hpbmUgcTM1IFwNCj4gPiAgICAg
LW5pYyB1c2VyLGhvc3Rmd2Q9dGNwOjozMDAwLToyMg0KPiA+DQo+ID4gICAgIEd1ZXN0IGtlcm5l
bCBhdXRvLW9ubGluZXMgbmV3bHkgYWRkZWQgbWVtb3J5IGJsb2NrczoNCj4gPiAgICAgZWNobyBv
bmxpbmUgPiAvc3lzL2RldmljZXMvc3lzdGVtL21lbW9yeS9hdXRvX29ubGluZV9ibG9ja3MNCj4g
Pg0KPiA+IFszXSBUaGUgdGltZSBmcm9tIHR5cGluZyB0aGUgUUVNVSBjb21tYW5kcyBpbiBbMV0g
dG8gd2hlbiB0aGUgb3V0cHV0IG9mDQo+ID4gICAgICdncmVwIE1lbVRvdGFsIC9wcm9jL21lbWlu
Zm8nIG9uIEd1ZXN0IHJlZmxlY3RzIHRoYXQgYWxsIGhvdHBsdWdnZWQNCj4gPiAgICAgbWVtb3J5
IGlzIHJlY29nbml6ZWQuDQo+ID4NCj4gPiBSZXBvcnRlZC1ieTogTmFuaGFpIFpvdSA8bmFuaGFp
LnpvdUBpbnRlbC5jb20+DQo+ID4gUmVwb3J0ZWQtYnk6IENoZW4gWmhhbmcgPHpoYW5nY2hlbi5r
aWRkQGpkLmNvbT4NCj4gPiBUZXN0ZWQtYnk6IFl1YW4gTGl1IDx5dWFuMS5saXVAaW50ZWwuY29t
Pg0KPiA+IFJldmlld2VkLWJ5OiBUaW0gQ2hlbiA8dGltLmMuY2hlbkBsaW51eC5pbnRlbC5jb20+
DQo+ID4gUmV2aWV3ZWQtYnk6IFFpdXh1IFpodW8gPHFpdXh1LnpodW9AaW50ZWwuY29tPg0KPiA+
IFJldmlld2VkLWJ5OiBZdSBDIENoZW4gPHl1LmMuY2hlbkBpbnRlbC5jb20+DQo+ID4gUmV2aWV3
ZWQtYnk6IFBhbiBEZW5nIDxwYW4uZGVuZ0BpbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IE5h
bmhhaSBab3UgPG5hbmhhaS56b3VAaW50ZWwuY29tPg0KPiA+IENvLWRldmVsb3BlZC1ieTogVGlh
bnlvdSBMaSA8dGlhbnlvdS5saUBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVGlhbnlv
dSBMaSA8dGlhbnlvdS5saUBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogWXVhbiBMaXUg
PHl1YW4xLmxpdUBpbnRlbC5jb20+DQo+ID4gQWNrZWQtYnk6IERhdmlkIEhpbGRlbmJyYW5kIChB
cm0pIDxkYXZpZEBrZXJuZWwub3JnPg0KPiA+IC0tLQ0KPiANCj4gWy4uLl0NCj4gDQo+ID4gQEAg
LTg0Miw3ICs4NDIsNyBAQCBvdmVybGFwX21lbW1hcF9pbml0KHVuc2lnbmVkIGxvbmcgem9uZSwg
dW5zaWduZWQNCj4gbG9uZyAqcGZuKQ0KPiA+ICAgKiAgIHpvbmUvbm9kZSBhYm92ZSB0aGUgaG9s
ZSBleGNlcHQgZm9yIHRoZSB0cmFpbGluZyBwYWdlcyBpbiB0aGUgbGFzdA0KPiA+ICAgKiAgIHNl
Y3Rpb24gdGhhdCB3aWxsIGJlIGFwcGVuZGVkIHRvIHRoZSB6b25lL25vZGUgYmVsb3cuDQo+ID4g
ICAqLw0KPiA+IC1zdGF0aWMgdm9pZCBfX2luaXQgaW5pdF91bmF2YWlsYWJsZV9yYW5nZSh1bnNp
Z25lZCBsb25nIHNwZm4sDQo+ID4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIF9faW5pdCBpbml0X3Vu
YXZhaWxhYmxlX3JhbmdlKHVuc2lnbmVkIGxvbmcgc3BmbiwNCj4gPiAgCQkJCQkgIHVuc2lnbmVk
IGxvbmcgZXBmbiwNCj4gPiAgCQkJCQkgIGludCB6b25lLCBpbnQgbm9kZSkNCj4gPiAgew0KPiA+
IEBAIC04NTgsNiArODU4LDcgQEAgc3RhdGljIHZvaWQgX19pbml0IGluaXRfdW5hdmFpbGFibGVf
cmFuZ2UodW5zaWduZWQNCj4gbG9uZyBzcGZuLA0KPiA+ICAJaWYgKHBnY250KQ0KPiA+ICAJCXBy
X2luZm8oIk9uIG5vZGUgJWQsIHpvbmUgJXM6ICVsbGQgcGFnZXMgaW4gdW5hdmFpbGFibGUNCj4g
cmFuZ2VzXG4iLA0KPiA+ICAJCQlub2RlLCB6b25lX25hbWVzW3pvbmVdLCBwZ2NudCk7DQo+ID4g
KwlyZXR1cm4gcGdjbnQ7DQo+ID4gIH0NCj4gPg0KPiA+ICAvKg0KPiA+IEBAIC05NTYsOSArOTU3
LDIyIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBtZW1tYXBfaW5pdF96b25lX3JhbmdlKHN0cnVjdA0K
PiB6b25lICp6b25lLA0KPiA+ICAJbWVtbWFwX2luaXRfcmFuZ2UoZW5kX3BmbiAtIHN0YXJ0X3Bm
biwgbmlkLCB6b25lX2lkLCBzdGFydF9wZm4sDQo+ID4gIAkJCSAgem9uZV9lbmRfcGZuLCBNRU1J
TklUX0VBUkxZLCBOVUxMLCBNSUdSQVRFX01PVkFCTEUsDQo+ID4gIAkJCSAgZmFsc2UpOw0KPiA+
ICsJem9uZS0+cGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwICs9IGVuZF9wZm4gLSBzdGFydF9wZm47
DQo+ID4NCj4gPiAtCWlmICgqaG9sZV9wZm4gPCBzdGFydF9wZm4pDQo+ID4gLQkJaW5pdF91bmF2
YWlsYWJsZV9yYW5nZSgqaG9sZV9wZm4sIHN0YXJ0X3Bmbiwgem9uZV9pZCwgbmlkKTsNCj4gPiAr
CWlmICgqaG9sZV9wZm4gPCBzdGFydF9wZm4pIHsNCj4gPiArCQl1bnNpZ25lZCBsb25nIHBnY250
Ow0KPiA+ICsNCj4gPiArCQlpZiAoKmhvbGVfcGZuIDwgem9uZV9zdGFydF9wZm4pIHsNCj4gPiAr
CQkJaW5pdF91bmF2YWlsYWJsZV9yYW5nZSgqaG9sZV9wZm4sIHpvbmVfc3RhcnRfcGZuLA0KPiA+
ICsJCQkJCSAgICAgICB6b25lX2lkLCBuaWQpOw0KPiA+ICsJCQlwZ2NudCA9IGluaXRfdW5hdmFp
bGFibGVfcmFuZ2Uoem9uZV9zdGFydF9wZm4sDQo+ID4gKwkJCQkJc3RhcnRfcGZuLCB6b25lX2lk
LCBuaWQpOw0KPiANCj4gSW5kZW50YXRpb24gb2YgcGFyYW1ldGVycy4NCg0KR290IGl0LCBJJ2xs
IGZpeCB0aGUgaW5kZW50YXRpb24uDQoNCj4gDQo+ID4gKwkJfSBlbHNlIHsNCj4gPiArCQkJcGdj
bnQgPSBpbml0X3VuYXZhaWxhYmxlX3JhbmdlKCpob2xlX3Bmbiwgc3RhcnRfcGZuLA0KPiA+ICsJ
CQkJCXpvbmVfaWQsIG5pZCk7DQo+IA0KPiANCj4gU2FtZSBoZXJlLg0KDQpTdXJlDQogDQo+ID4g
KwkJfQ0KPiA+ICsJCXpvbmUtPnBhZ2VzX3dpdGhfb25saW5lX21lbW1hcCArPSBwZ2NudDsNCj4g
PiArCX0NCj4gDQo+IA0KPiBNYXliZSBzb21ldGhpbmcgbGlrZSB0aGUgZm9sbG93aW5nIGNvdWxk
IG1ha2UgaXQgbmljZXIgdG8gcmVhZCwganVzdCBhDQo+IHRob3VnaHQuDQo+IA0KPiB1bnNpZ25l
ZCBsb25nIGhvbGVfc3RhcnRfcGZuID0gKmhvbGVfcGZuOw0KPiANCj4gaWYgKGhvbGVfc3RhcnRf
cGZuIDwgem9uZV9zdGFydF9wZm4pIHsNCj4gCWluaXRfdW5hdmFpbGFibGVfcmFuZ2UoaG9sZV9z
dGFydF9wZm4sIHpvbmVfc3RhcnRfcGZuLA0KPiAJCQkgICAgICAgem9uZV9pZCwgbmlkKTsNCj4g
CWhvbGVfc3RhcnRfcGZuID0gem9uZV9zdGFydF9wZm47DQo+IH0NCj4gcGdjbnQgPSBpbml0X3Vu
YXZhaWxhYmxlX3JhbmdlKGhvbGVfc3RhcnRfcGZuLCBzdGFydF9wZm4sDQo+IAkJCSAgICAgICB6
b25lX2lkLCBuaWQpOw0KDQpZZXMsIHRoaXMgbG9va3MgYmV0dGVyLiBJJ2xsIGFwcGx5IHlvdXIg
c3VnZ2VzdGlvbg0KDQo+IA0KPiBMR1RNLCB0aGFua3MhDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRi
YWNrLCBJJ2xsIGluY2x1ZGUgdGhlc2UgY2hhbmdlcyBpbiB0aGUgbmV4dCB2ZXJzaW9uDQoNCj4g
LS0NCj4gQ2hlZXJzLA0KPiANCj4gRGF2aWQNCg==

