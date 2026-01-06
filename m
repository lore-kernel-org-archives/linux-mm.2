Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6A1CD0430
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2260A6B0088; Mon,  5 Jan 2026 22:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD646B0093; Mon,  5 Jan 2026 22:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5576B0095; Mon,  5 Jan 2026 22:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E98C66B0088
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:48:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E21014037F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:48:40 +0000 (UTC)
X-FDA: 84300157200.13.4F512F6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id 647DC40004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:48:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Qr6LHmZ/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767671317; a=rsa-sha256;
	cv=pass;
	b=JuLWgsOTaRcB/ezok/U7gDNiQnV0Wm+DmI3LOi5Wt6zqBRp14cylebiYABeXQpI4V1AyZN
	goHhSqOvrvLijh9dBl5+Kg+3yxoNBYdEifxtueQJJi4b4iqGCk6/fz52q97McVU9pekHJZ
	RA/7MR6DVrMC1oydi8BxeQrEalHtVds=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Qr6LHmZ/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767671317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRO0h/64vIXtFN5XCmJthZkskXUPGnzPtpYYzsgmoV4=;
	b=0mhei+Zu0VZA7vvfngxTt12xKQ6bCmOunrAn4Jge4ZMweg2rLqU3aQXTEUVnHpnrNtYAA6
	IN4dfO7cFHuxiFWVRKGl8kBTL++WfQfc4KGY21MNnQqEAe7/390etaYCIHfCuoBxERfHr4
	v+deU1vTde5diTSW34R8Go0I2gE/XGw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767671316; x=1799207316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xRO0h/64vIXtFN5XCmJthZkskXUPGnzPtpYYzsgmoV4=;
  b=Qr6LHmZ/5nsSqdMM3mouhFqayXsqrjXjOrh+SyJBRCKC5GW+8XA7crk9
   vdVm5BRV549McimusZZEgZ89x9SqXYVpxkuVGIJdGevTJ7iqUKF0BFrRo
   4WYqL0s/je072o4lrNZgEF4Vlu+7+RJ0wV/XjsdkB4ma+w5tvezzF3oHD
   5Uvyx4ta8TsP3jHKxtD/VtFWpEh0W6iRjvlZ7yaDTg9Kfgn+bHh+w+P6I
   ElHmiNm+He3Df7S7fKxtx0uYCAP3QbUYQsXEKKeip6VpHbKlz7Ti+htmW
   oImbCldtQ6g33HYDlxUXCqf0IbrMcE6hVs/0a/umUk4sJePiH/Kr322fB
   w==;
X-CSE-ConnectionGUID: nfL547QRT4OyYoUoDATAfg==
X-CSE-MsgGUID: XDoABVO3R8qnTlwjKrrqmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="69079724"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="69079724"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 19:48:35 -0800
X-CSE-ConnectionGUID: iDWhg14KQjqCFjVZC4zNfg==
X-CSE-MsgGUID: jqTALbqBQvKrJsriOO1LeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202795976"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 19:48:35 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 19:48:34 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 19:48:34 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.51) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 19:48:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ivIRbboZ3w0fkZ29Ix8MgiKisj3tZ9XH7KYbNoX1M8dpFkvuVvgOXc4A942zwezyHORI/JLy0KLnqRWokTXkzEH0eQKo6sw3sT9iRucx09n51i8b/+eotv4d83DJBV9oVkeLix7ac789W2Cejr7HOFvzkVYLg8rhwZHRov1mFbpcMrK33KHt0D6HCNJl/gcEjauPlEZlqWwugwUGHia7F0EYkPobBKEAkpr3mwLlpWUPiUCIWxegRTOT+ztQd38ibEMCSdwRQRka7CkrA5Xs9vu6tA7YuoCZOgbRWQcuoibhSyCxgFJ5Cxmi7T5oOriRgIF2tPFlE2dxvCs/r3WrHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRO0h/64vIXtFN5XCmJthZkskXUPGnzPtpYYzsgmoV4=;
 b=M8VoX94p1IQToK5ig5O24MxeFRSHomJQ+HUF8aPlbVrXXX4KQ0OEdgF9VPBQLWhwuNj0fM+UY6gKo84pge5LKgcK+EJiPpECzj1Zx48wUW9AkKGq46ChsLWlCM1+1sHaBfCaYZWkuc7vK5BcuGqpHFIpuWc9zECYeYu+L+CJJESXhAkN87UK5pl2dbbg3HONDjzU8cmBt0FD3XuBqFHXcPdyO+hTj1yFTpsCVQ6hw/PcEn35fnSJ+9AnIxKFSnwqV5QDvTGtHRDRWcWCedlpYQyJr3Jkb9+AqJsfMuzrSJ7Ob/QvUOm2YAobGtWx45ykgby6Tr+w7jNtb4KtEkE62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SA1PR11MB6893.namprd11.prod.outlook.com (2603:10b6:806:2b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Tue, 6 Jan
 2026 03:48:31 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 03:48:31 +0000
From: "Li, Tianyou" <tianyou.li@intel.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, "Liu, Yuan1" <yuan1.liu@intel.com>, Tim
 Chen <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>, Chen
 Zhang <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 0/2] Optimize zone->contiguous update and issue fix
Thread-Topic: [PATCH v7 0/2] Optimize zone->contiguous update and issue fix
Thread-Index: AQHcfj3lIGl3TmNCaEWFLurNEiTCLrVDw/2AgAC9uMA=
Date: Tue, 6 Jan 2026 03:48:31 +0000
Message-ID: <MW4PR11MB8289F4DC0FBFCCFF6ABC9AC09587A@MW4PR11MB8289.namprd11.prod.outlook.com>
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <011e2691-994f-4038-adf0-02e899eca777@intel.com>
 <c2b81430-e89e-49b8-8557-1a374f2e6d01@kernel.org>
In-Reply-To: <c2b81430-e89e-49b8-8557-1a374f2e6d01@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB8289:EE_|SA1PR11MB6893:EE_
x-ms-office365-filtering-correlation-id: 716a6c26-a450-4699-eebe-08de4cd67598
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VnkyeS8zMU1ER3BtWVMvd0NGVDIwWlh4SXc5TFZ1M0FKengyWllGRWZIOHNn?=
 =?utf-8?B?NnJsOEZZbTdxZjhlVUFvRFNDYU1EL0pqaVFYcldBYWR4N3k3NXhZcVJxaWk5?=
 =?utf-8?B?VmhhaXhJZnEzVzBxeVVWaUZFTTRva0FhWGNUTHhKbzJ3MEdKVGJMbTlBL1JM?=
 =?utf-8?B?bmg4eGM5R1BTeU9zckV1NnJ2R0lhTFVCbWFuQ3R2bXBUZ0g5dkVvcVYrc0s5?=
 =?utf-8?B?MjUxUnRXVktzMHV2QU5ZWjd1Z2hBQXlOUXFGUEhpWm1zSjFqbDhpRXR4VzR2?=
 =?utf-8?B?UUNOdEdoTzY5T1RHMWZQRUpQSHI1Mzh3ZC81ZEJaTG5UN3BsQnlKZDlUQUZI?=
 =?utf-8?B?OU9aTFNqb1JKUjI5WDl5bmYwZStvSWU4dDlpVng2U1I3NjA5Tkw5UUFhQTRH?=
 =?utf-8?B?YWJBQS9saHUzWlduVWRONWFvQkFTQ3FIV01kOTJDMlJmNkZsVHozMmZwQXd2?=
 =?utf-8?B?aEJWdGUvN3VCTHZYQWZXWW55M1lqNnNySmlCRmEzL2lPYitrQ3Q1MmxTWjVi?=
 =?utf-8?B?aW5ldkt3eUdMWUh5cThNcjNpcnZUd1Y4aU5vSGZIaEtNV0U0RDI5MXNHNCtZ?=
 =?utf-8?B?WE9YZ0F6cTY3UHFyTmZwc3NuTEo4ekVKVm52K2xYYm5hUUt2THd4K2QzSXM2?=
 =?utf-8?B?SlJpSXhRT1ZKaWd1T25IU0E2QkZjTTVYRk4rSmM0MUR4VWc2MitZcDNzSldZ?=
 =?utf-8?B?dlF3b1NXZmRmazZ2VVplNlo3TVRCdlR1WFBEYVpOeHlRR3FORWtianFiVC83?=
 =?utf-8?B?WXhESFVndUtoTklNY1JnM1BYNjM2T0RWUGtIdUhHdmVobDVvWGdEcDNMNFFK?=
 =?utf-8?B?cWhWdTVYTmVYQnRvbTc1bGhKNFRCNzZDaVFCN2JPbnhTd0hQSmtzcHpOajhV?=
 =?utf-8?B?UllENVp5TWhlbTV6NE1xR0FJOVdIbHRjR1loQ2VEWks3dHRJdVQvNjNhQWRo?=
 =?utf-8?B?a29YWkVidVdVVTVCb3Z5S2RraEZteFhtMndVRjFYT1MwRDhvYklBMlRHcjZP?=
 =?utf-8?B?czdwK2o4bDMxb2R6ck54Z2J4cU4zVzdFMkFCeXNyMGc1ZEpiQWhmQ3lWTXAz?=
 =?utf-8?B?aXdkcGxRRFNWa3BqSzQyTS9SRFE2QVkrdithY0NPOVJoT3NMVHZYUkNIaVFn?=
 =?utf-8?B?eFdyVlk1eFlIbjdHZ1U1T29vN2Z0Z2JCemU0anZ5aUJBamdndUQzZEY5dVFs?=
 =?utf-8?B?RG1keCsrY2hUbHhNYm51SSs1NHFXVnpZTDFTREx6NnE2MUplSHNrdWM3MzJE?=
 =?utf-8?B?UUxTcW1Gb3RmQloyWFFOd3V0VXU2Rm1Hd1hJUDNlZ3ltQ1dzSTJULzJnOHl2?=
 =?utf-8?B?Z2JKZzBrdCs5WGczd2NvVlYzNWlmcDJkUDRnYmF6VUtCUHBjQjREN21GVUpH?=
 =?utf-8?B?YTZLVWFEdnFQYWMrbkVGVjY0VTRpTE1zSkpCK21GZGhvaDJXdURJY1lFbWpn?=
 =?utf-8?B?Q240cEE5SVl1ZEdsamNkR2UybWxNc1g4SUgyZE5VbVQ1V203cXY2SkE0ZHpW?=
 =?utf-8?B?TENBLzljMDVxOVYyY0hCTS9JRFpFZHpRWXNabUlaY0dNMFVMM2cvZDdCOEdD?=
 =?utf-8?B?ZzBwbGhDZVJzdVpVVk8yUExKMWdJYzJrMURBSEw3ZEVnMGpyZ1l6alVYa1pj?=
 =?utf-8?B?TTBBWE5PTDhBRWhsQ3pGY3NpUU5hRFFyMDlQVjN2R0R2S3F1dDRqdjExdWtN?=
 =?utf-8?B?c2tCZ2owMUx3bGZ6MXFOS1NYcWc5Qlpjb2d0eFBUNHNXYlB0RnZrOUt5NFZs?=
 =?utf-8?B?S1gwcEtITGtDMU5KMUhFMEdqaVZkcUllYm12S3dTUjA1TUpycmpLSmxZRy9D?=
 =?utf-8?B?WHMyV1RKQklMSVNDQVBDSWdPNzB4ZmhFREYvd1duYUhnRGMrK2NXYWtYOEx0?=
 =?utf-8?B?bnZhcWx0aGsyUnJ0T2p2NFJrZldwZVA2bU14NG9UdDFOeWZQSVZBbjVXNFow?=
 =?utf-8?B?SzhIT01rN2xoazJiWFBPdUtWKzRJWGdSWVJ0alZyTXFITkNrSTJZMzZScExw?=
 =?utf-8?B?eWxqNXJJcHA0MGJGN2JRRnZVbmFZa1N0dVB5amQ0K1EvTnhwZXV6MDFncmY2?=
 =?utf-8?Q?Y08d0b?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3RHR0FiOGlRRGJoWGtuY1pBbU9OQVlGcDIyQjZCZXpiTHZjbzlHSklzaUR0?=
 =?utf-8?B?OTRLTDlueVlsS2M3OTQrTGJXUmUxSmtzdlBndlYzd0pHajhQR0FMRzdvVWRh?=
 =?utf-8?B?T0hoZkFnK0Q4YVVYS0I4L0hzb3JvZUt6Z0tEWWttSXBTQ3RqNEZBWGtpVG1I?=
 =?utf-8?B?Zm5Jc0R4a0xONDFGNVVCWW1DMFRVanYrdmRhajhHMXZiYlJEODFRWUl2UFli?=
 =?utf-8?B?enljV2xZUnV6c1g4Skk5eWQwajFrSGJHMVhWM2FxRWFaTXVlZTBwZmN3U3U1?=
 =?utf-8?B?LzcvMEJpL00yRzhHc3NpeTYrdHNJd0RYdVl3NG1sbkRwOXBJUmg4MW55ZUtn?=
 =?utf-8?B?M2l5WC92U2MwY1FYenUyc0lzVUhDdlRWcDN5SGovUkpUcks1alJXZmlQSSty?=
 =?utf-8?B?WGk2a2J1eTNmZGZRTEE0eU81RHdlakJiZE55c0gxWFpMSTE2cVVFWFVnaFl0?=
 =?utf-8?B?S2N2UDQxMTFxdVc2Wk9TYXZyREdIMTZVb3J5MlQydEowSnhXeDJWaDgvZGlq?=
 =?utf-8?B?MUJpRzJpdlRTMnFob1B2dUdQMjN4amp6NE9PUFZRbGtSNHBZM2FLem5iYkZP?=
 =?utf-8?B?R2tLZDdNbGpGOGFxeGdnTFVjVG95dmdvejVZT1FyRjFGTk11NWxXcjcyTmc3?=
 =?utf-8?B?ME5Xanl6TTllb0N3Rkd2K1dqQzR6R3d5Q214b0lmelJocURCd1E5dExTR1Az?=
 =?utf-8?B?eitZTzMvY04xN0M5Z05sVC92V2ZoN3hzS3lQY3lrVFVEVG5EV3dqMWliRi9p?=
 =?utf-8?B?ZzNnNUxGYXA5ZmE1bG9JdE5nMjVWbnFrWGN1aTVHd0pUS055ZEtQSUx1cmhh?=
 =?utf-8?B?ZzczS3RmSFFPN1FnYzZXSlNKTDB2V3Q5a2lSUWtla09nWUNrN2tuaDhJMlF1?=
 =?utf-8?B?RmhyejdwZzRsMXFsRThrNEQvYkNXRkpNOU00Z2YrYjBKSjROa2xubjRpcU05?=
 =?utf-8?B?OXFVSFhxSXczbkhKancvbWFFcEljK0xuQ25JLzRnVlFYY25JN1dqTjAxV2tR?=
 =?utf-8?B?ZU9BT3ZGTkZyQTc0RDJzSVhURFF1Vk1YbXBid2FBUFdHalVyNHpFY0dBM3c2?=
 =?utf-8?B?eVlodnpLNjBIVUhZS2FUb0kzSzhGRWNuY21pQTQ5MVpCdWhBZUVmd3dhR1Mv?=
 =?utf-8?B?VmJkTkxEUXRvWHVrcE5GYnhST0lpMDNhc3ZLVE9nWkdRaXE1NFZ5QlpJZm5y?=
 =?utf-8?B?cFpreWRreVhGK3dpaURrR1dUSXZXak5MRmEyNGNlU1BkcmpnMGRIVDg5YURI?=
 =?utf-8?B?TUxkNC94akhETW92Rjd6cHlrOXJXM1FmSi9UK3RMb2k3SzAzeUtuUUNDajJj?=
 =?utf-8?B?L00rY3FGNmJ6Z0sxdU9PcDE4bWlZcjJCN3VoaE5jM0MweFVRd3o3eXJ0UWRK?=
 =?utf-8?B?endyelFxVk9pZlRCNExBbEw2WTB1dVpKU1RSRlJhSk9RMFdZODl5Tm9mYWUr?=
 =?utf-8?B?RnZJUFFjSjdIR0x4UUlaUElnSzYva01nYUxPcGNFWTlWWGFKZjZNc2hJamt5?=
 =?utf-8?B?V3k2elpBakJycnV3S2t6SEQxMXlYcTJoZklNUmJHSFRoUzFuQmVBMGFWaHky?=
 =?utf-8?B?TnUyOTNPRElWRlkrL01GVzZjbTJYRXhKYmxNVDdzbGxEWmdyZXdQSm9URlNM?=
 =?utf-8?B?V1ZacEw0eTNlT21mbWFVRVJnQ2JVWVlRMDI3Z0lrVm5Rblk4eHdiczVIcTJh?=
 =?utf-8?B?YkFLc3ArZDBhVkQ4dVVIbjRZMlFRSTN3a3lqMFp0RVhVSkVQK05oRUxYRjlh?=
 =?utf-8?B?enpxakJTMmJFSk5JUHowaU5tQnl2UnZVRXFIbThjK2M3d1ZraGZ5QVF1cEUw?=
 =?utf-8?B?eUh6OVZNNW5KVHJ5MitBNzFuMkZWL1phYjlsOUVKUWhETndzZTJ6NVVrZUE0?=
 =?utf-8?B?MGVWOGFrd1d0ZmJRelkvT0x5V05CbmZGU1Fyblo3ckRLU1cxNkl4c0l2S0s2?=
 =?utf-8?B?RHg0ekdocFptdUN5TmFOZHRJYmx5RVZ2YkV5Sjl4aVN0M0ZBVExEWm1NaHVj?=
 =?utf-8?B?a0xyaHphRzBDbnhRdURsVjhic3NYd1IxV2JqRldRWmFhbVN4NWNsQjJ6ZTV2?=
 =?utf-8?B?UG9Rb1gzb295UER5RGVvMmZ4Q1NvQW5Xb005bm1zcUxkM0V6eWpUcGxUblJB?=
 =?utf-8?B?UTJhcjMxMThrRnpmcnhTVDhmcUpqZUE4OEJYSFRsNU1GUGV2Wi9IWGdBR3lh?=
 =?utf-8?B?QXpjblpILzFweENJVWZMUkVhME1hTmpxZkYwMDNDbFhJU2pRU2didzU5R0s5?=
 =?utf-8?B?eFBDeFRFMzNzTUordWxLVFZNeFJsRDlyemhVRGdyVnM2RWxmcVFpTVUrYmFo?=
 =?utf-8?B?bXJ1UitEZVVwd01zblR2LzlVREVNdUJwR0hBRXcvS1ZiUjQySXBNQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716a6c26-a450-4699-eebe-08de4cd67598
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 03:48:31.2831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T1DYCvz82dwbApwFoxnu4Qsdm9+9/8YtwOHst7qiVFueQjpB/XaFvQ4tUySl0VcB6DsSWPwZeuALy0bGrld55g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6893
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 647DC40004
X-Stat-Signature: uksfofbjohq1d3hatyn9bpjch8zefe44
X-Rspam-User: 
X-HE-Tag: 1767671316-455185
X-HE-Meta: U2FsdGVkX18JBPwh0jJ44FBZ4nJG1zOxz19qYnEygvAHJYfUMre0R4UpfLVyedoqfvtNmO6ngUJxscZryXu1wBa52cAcD3PtrBlqBcgZRY13sqraKiV+49cfJUEUAlNBCFfhx+hmfc9GC2trCjOhGTqZnkfqDf9JdD2+KNClxu8Di2/u8aKteBqcGYzGGxxx3VHvLyh4fdoW9JqS+TdqlAd7/eD09Z8zR9KCWG0u6zrsSnfTXMJqQ7l0rojalc70oab6dOtuBGfR0chNDJw824V/BltCAB9A78zahMV+cupR8Xom10I4uCqxszBIvK6yJLgLcN0gUJTEyVnUfv/PAXIFON282937Z8KkyfclrlOpQ0AhZD8rBG8Ns2vky3ncSTezK4m4J5Joczoh1h50yCTiVchFsO1ADLvAQ9ob4oSD8E5Y7FVeyOghVNAZjCQzO7PMcPiOw9VJjqVkozW4bvE84dHzM3gK7jg0+T45AKMPPJOtzInUXpaa6MYbiqkZrwoszIMplLzT//QwqHpiwZdIRjy8Zv7oo9wnBI06va8vr8r0hk+xx3XyoSTVE78t6Gf7VT1W4SECHRZZ6NG7AwtXA/TDi5rm2YJS7uEt0cT1J/kvCtQM+mi8/y5ZjYrx+KRcyIQ6HvZpFbZw73yjFSSZxQeIBPjKurnnLGi3vLFPxXlFkS4aFY6nl8EGFpvHhpUf7lyk1OBD/YweRwROtitv6N41REBsX7HTkgjwDZcHm/pJj5JGvXvZfip6VMgghGryqtmWX1nqjl0+NPEFx8fCDfaeNSGF6vkwkfTan6toV/u/FUwqjD/GJKoLQaOZ9tqbnq9GYOJ+JBr81PheEVsX9jd/SGKOb/NCw07Tj7phYKDc1D67V1sOUfFNPgcDE6/8GySAPG7kVZBRCG1sj7Unzl5UMSBL0JjPmhft1+fb35ogaPZAfN1iuGHksS8+mgOJNga2R8pGcxPxnFn
 6o0esfoe
 olm59LGWNpy5BNq1cMk6bJ3IIou6rVqymeF5L16EuUMSpjT59Hp2KpbpcsQ38xCqSwvslokxVPwnTRSiGDfl/bnQ4X0hREKqAlSgnPS54hgzR6QTTdcE2CswjHor+LgIVBg6YE/Btkbhzgvl1KPAC/MQL81aInyEMCvhAUPgUgf+mkaKlcjccAqPvHQQh7rW/at/0bEFd3mdH9loO2bSJQU8ml7RrBcGu6KCLGxUuu8mqv+yGBwlB38eOnkVsMmr9950v9PYb4Mpyl7t9v54F8DnCA8ws/7WjrA8KpDyeJ0cakCpgShxFVazxtiNau36AtF3/ORnG4D894c/LL5a1Q3uWxETwwbUXF+lG4yGqoq90JLWPYTBRME1Ky4GVyK8/8DrjrTX/2yNACCqpSt9Mu4gFr97dWPRoy7OgSUlksh+V5tGsL29eQSaq6exK3ueJgSeyWLeFjEaehj8TCmolKfsO/PF0T1j82c8G4XmiMfv1Rw6NDMJPh9jAWNa5AuBHFH+GtdPeQYbfWHSZCPgsXVL9VovcRG3FP+VWPdAd4bXWRMrTnariD1Pjo5Nj3EX0k8mVrng32+IPDA67lpUe4RXPtQsZIrpxrZ6pFnf1Y61p9YVm6CCJHOzsQn2IH1u7BiOk6RZw+CBMcChSA4kDC0byqr9EHwcRQnsIiRWOQJT11miY7KuPDnkUDd5zF6wMd2i+btS6lhKD6ac5QM1iQAF3sujQ+y4Q/f/YfYgKcnJlKUKNiyyuYS0Bqy3pg/+NUjKHT5LDTHptbi3jAs4Isrt9belgT6FhtBZB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VGhhbmtzIERhdmlkLiBNeSBtaXN0YWtlIHRvIHVzZSB3cm9uZyBlbWFpbCBhZGRyZXNzLg0KDQpW
ZXJ5IGFwcHJlY2lhdGVkIGZvciB5b3VyIHJldmlldy4gDQoNClJlZ2FyZHMsDQpUaWFueW91DQoN
Cg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IERhdmlkIEhpbGRlbmJyYW5kIChS
ZWQgSGF0KSA8ZGF2aWRAa2VybmVsLm9yZz4gDQpTZW50OiBUdWVzZGF5LCBKYW51YXJ5IDYsIDIw
MjYgMTI6MjggQU0NClRvOiBMaSwgVGlhbnlvdSA8dGlhbnlvdS5saUBpbnRlbC5jb20+OyBPc2Nh
ciBTYWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+OyBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCkNjOiBsaW51eC1t
bUBrdmFjay5vcmc7IEh1LCBZb25nIDx5b25nLmh1QGludGVsLmNvbT47IFpvdSwgTmFuaGFpIDxu
YW5oYWkuem91QGludGVsLmNvbT47IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBU
aW0gQ2hlbiA8dGltLmMuY2hlbkBsaW51eC5pbnRlbC5jb20+OyBaaHVvLCBRaXV4dSA8cWl1eHUu
emh1b0BpbnRlbC5jb20+OyBDaGVuLCBZdSBDIDx5dS5jLmNoZW5AaW50ZWwuY29tPjsgRGVuZywg
UGFuIDxwYW4uZGVuZ0BpbnRlbC5jb20+OyBDaGVuIFpoYW5nIDx6aGFuZ2NoZW4ua2lkZEBqZC5j
b20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIIHY3
IDAvMl0gT3B0aW1pemUgem9uZS0+Y29udGlndW91cyB1cGRhdGUgYW5kIGlzc3VlIGZpeA0KDQpP
biAxLzUvMjYgMTM6MjEsIExpLCBUaWFueW91IHdyb3RlOg0KPiBIYXBweSBOZXcgWWVhciENCg0K
SGFwcHkgTmV3IFllYXIgdG8geW91IHRvbyENCg0KPiANCj4gQXBwcmVjaWF0ZWQgZm9yIHlvdXIg
cmV2aWV3IGFuZCBsb29raW5nIGZvcndhcmQgZm9yIHRoZSBjb21tZW50cy4gVGhhbmtzLg0KDQpT
b3JyeSwgSSBtaXNzZWQgdGhpcyB2ZXJzaW9uIChhbmQgdGhlIHByZXZpb3VzIG9uZSkgYXMgdGhl
cmUgd2FzIGEgcHJvYmxlbSB3aXRoIG1lIG5vdGljaW5nIG1haWxzIHNlbnQgdG8gbXkgb2xkIEBy
ZWRoYXQgbWFpbCBhY2NvdW50IGluIG15IEBrZXJuZWwgYWNjb3VudC4NCg0KV2lsbCB0YWtlIGEg
bG9vayBzb29uIQ0KDQotLQ0KQ2hlZXJzDQoNCkRhdmlkDQo=

