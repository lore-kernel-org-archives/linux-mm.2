Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555E2CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB786B0098; Fri, 26 Jun 2026 04:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469FD6B0099; Fri, 26 Jun 2026 04:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B526B009E; Fri, 26 Jun 2026 04:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F31766B0098
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:26:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 775A1120373
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:26:18 +0000 (UTC)
X-FDA: 84921381636.15.4CB714D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id 039A1160003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:26:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MAj7JFjw;
	spf=pass (imf08.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782462374;
	b=KMtdeC1YRg4maImGNzBzjTz35lLugna0XFMYgWOAP8JqpKrJ26J5Adm5R/3HGIREOOUtpI
	w/LrBbXwo3jKOv4ivvGScCnoAZjJqqk9r8+DUVA9WTLBnma0eVp+o8IKaWiGjUbHGvrlrL
	xqNyLAulEzSZre7THM928HP6jF2I3SM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782462374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xm97ZmIBq9w0s+96ctZw7u+adt1ngN+G2JgHHHwT2E=;
	b=NOUGbuTqhrH0CsqoxlARweqAnZ8+bm0VD/ch3R4tytM7ZbkyaBW7LBYYgSyIIXooWfd49Q
	3ULX/tFAiYxHAVhfl3EjwQDrFZi+HHVlj9SHKZWfPKUhzGG9A7XT3LPqchuRUPh0FmGxM4
	h6ibNhKcPMSXCG69SKTQE9dHVc+Trvg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MAj7JFjw;
	spf=pass (imf08.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782462374; x=1813998374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3xm97ZmIBq9w0s+96ctZw7u+adt1ngN+G2JgHHHwT2E=;
  b=MAj7JFjwqeyneJeTWzB/1IwDvAyohDPWsa3NJGY6BqKEFdJT6N8Sq6XQ
   F+kegBr0DLkfRopk+8kfndjszEYRGTSi2DFC+64Ba9JeCzT1twhRLhBbm
   7kJKQBT5f1zyJcqyTp7ZJ8Sj7YF/D86H1zFy6uXxs/xSx0jLMKotnpBUn
   G/2+02gcgn/evHrw6fD28fArPemi7zxbiosM0NvC7MCTH2ZlDPbe2IR6L
   EhavYgaj9c6L1rTawDaUsZbwH5RLx7Mpl2FsQA8sgh3KzHmp2Qdf/dg7Y
   i5YjHF5dMbuhlLaVEcBa4vadoTYctrBJKXiGe6n3Xceu2dVrn+qFH0NG5
   w==;
X-CSE-ConnectionGUID: 8G4iyud9RFuQ0OQOY5RPWQ==
X-CSE-MsgGUID: 6m/nWaXxRo69WcK4ttncIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="94740151"
X-IronPort-AV: E=Sophos;i="6.24,226,1774335600"; 
   d="scan'208";a="94740151"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 01:26:13 -0700
X-CSE-ConnectionGUID: mwhMdVAzQLqrl6Ldx0JVLA==
X-CSE-MsgGUID: 482dNCKjReShEJorN/U0GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,226,1774335600"; 
   d="scan'208";a="281357168"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 01:26:13 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 26 Jun 2026 01:26:12 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 26 Jun 2026 01:26:12 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.61) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 26 Jun 2026 01:26:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kzyKAuqmVusbZ4fqh42jGdjSluX6DYA3K8l/lxCF+65hfHqXNmPIEVvULmCItK5UzpqhE0O5euELA1CA6Lh4PRvcCZhlbaqBY7mz1VmEzds372hVlpvBo+ETo3vB1Xz9buqSTvCouQrdSeFli3EhmHyVBRJ+rYb+yYlgd5bb/E8LiGCGsljH1BTkaQfbu+loh2PeT5NwhRspMbESWRs+ov1pmuGBD8IPbxWRQ9GfskkziXQyUtCGcM1FYGugRw5Fzk0GoRTPjxzaCyKVH3q8spdK+qpqUhdfJitp9++Zk1yztxtU/N8JNErxoFTQ6RDz4w3+xB4KxjZ4E4f1lhvm3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xm97ZmIBq9w0s+96ctZw7u+adt1ngN+G2JgHHHwT2E=;
 b=bHmprSdBRdKAxfGBrn4emvUDUoKEcBZdI61UJS1SjQbxEjm79PwKZqQxN+Crm49wBS2d7P7FCaIkGSpryiwBGWXHLECRr56fmp8uiZ4+G4wxuXB8kx8TINChNZdIS2BMpMASGMDQJNxtoTM1HNJHzaaKYD3/hHb6S7ymWrUCFNSKGNaxM+H/zgkBTRbscOepQvX4sLL3YFLeE5CZyczQyG9jFQPnfqwW2eQwEdjNq0JgSZyDc171KNMq83sBK5t0mZcAGB7e9q1mcPTIvuA9omuJ+snUOFQS5FuK0RQv7bzDCFV0FU4xPUGwiTE3MNZEmy/6lonZRaK1NWgvneMJ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DS0PR11MB7787.namprd11.prod.outlook.com (2603:10b6:8:de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 08:26:03 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%5]) with mapi id 15.21.0159.012; Fri, 26 Jun 2026
 08:26:03 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Thread-Topic: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Thread-Index: AQHc6DwJDfX3zlWKz0C/zOkb6gw/RLZPZSYAgAFR+hA=
Date: Fri, 26 Jun 2026 08:26:03 +0000
Message-ID: <MW4PR11MB69365DA722268E4CF7C8D0CAA3EB2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260520093457.3719960-2-yuan1.liu@intel.com>
 <fc62528f-99a8-4759-9880-d56077a0f6ec@kernel.org>
In-Reply-To: <fc62528f-99a8-4759-9880-d56077a0f6ec@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DS0PR11MB7787:EE_
x-ms-office365-filtering-correlation-id: 88467297-1564-48cc-b50d-08ded35c8fa6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|4143699003|56012099006|6133799003|11063799006|38070700021;
x-microsoft-antispam-message-info: JnZzJvSLdkSdjr8ju9wFKdtBw3MAeBPo0zGdPrEekqxgJW5PWASrZ8bUN9deYnqlZDQ6/EHfr/uPXBxyJlMA/aRuB9yEBR4FuxrOM0JlCiTJB6HMhS8yBhoEuKiUYSmRyRkHQ08ZnMSgXV7Vr8Gti0QI9HOwkWDF5v9Blpjkb3mJv6ILwNGUp4yN8Hn4HNh+EEXjo90j7HQz4XEXuvdJJWWCwIP+dxAAO81MkbNmZ3GftIYqd78tupNzcm70cLbvAAP1QXedi147iqP5d8012UrHsAHaUkNVwOjzMlG6xqLM9CSKo6KWUWDVrpoBCkTssoURubCTMe6P5/uT++aTWM1Hg2jx2egr4VcXaE3foCU62oJvGLj4sKPUVfzs1sDG3Ornl3XQDD/Bt6cXgH9sP5y3mMMXiVpoKN1oAkQwyNl54cxSO+8xg9s9zJPknkrhucyeqP52/t2VDJhP8iR9swmcdUXTCTULFHAsXiSSuaNxMLUMpFXKtAIYsqz7vri6nG2NzEs6zHbelY0hilP1bRt3AZScrTX06gplLI2J2f8G13RyAPG4xBl4h/E1nU+768sEvd3lm74/cUKQKvTz54sYCSceWExjYAif5COgkY8a85W5WMnkTk0tV6XhZaXfwgDYz+3zkaDCbTZ4cRQf9alW/EDQF+oh/chygnY5K7E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(4143699003)(56012099006)(6133799003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VStQc0RyQXZVc29BcXNuTVJxVjVhTHRmU0RZQlhXMndPaHcvQURhN2JBQTJJ?=
 =?utf-8?B?NTJOZVdFMXRZOFVKam52eENEazFycnh3MjhrVnRyRzlmN3EyU3VnZlQ2cUpN?=
 =?utf-8?B?KzhrRlIyZ1dwMkNRWXNLZWFJYlZNTVpqL2FHL1Q5aU5Td1ovc1J3L2ljdmZT?=
 =?utf-8?B?MHRxUGdhZHZub1JjektkaVFRU3RsODhCZDNFQUZXdnpKRmJEdkRTTUF2Z21O?=
 =?utf-8?B?Z2haZGdsUkhoa0NkamRLeFBRZDg0bEJOeVcyS2E1enErVmlsaWw4eCtUSzVI?=
 =?utf-8?B?VjU3WmRiYWF1TFNkaXhZckpEY3oxOThENmlnQzBsMjV3VWJqcDBIbmtnZ1N5?=
 =?utf-8?B?Wis5UFVsYTYzYTMrci9oRGJvY3lkcFNTZ3pSVnVUK2ZjVnYwZ1dOdGhZVmVn?=
 =?utf-8?B?VmxYamptaDIzS3I5akVhaUR2ZWVoU2lJWTZJejdvOUZuNWgrSDNyRmJkNmRU?=
 =?utf-8?B?SE1MMTd6NTRzckQyTktnd2VtblR2L1RQbVBRalpJUzFrdEJYZXhQWnRMc1dM?=
 =?utf-8?B?ZjNMeGE3VXJ4b3BoWHN6TGRrYWdUTE9zWDR2M1hBQUY0U3pIc0xvdTdVb0wr?=
 =?utf-8?B?aEp5MHJJTGd4bXNWNXhBbW1MaTJMZ2MzeTBuU0JjSjIxZEZBR2dGMkcxcUpt?=
 =?utf-8?B?Nm1iMGV6TVl1Z00zK3dmNXpaK1dTL0lsOXV0TlU4KzBBNC9RdnI3SVlaOWp1?=
 =?utf-8?B?Q0MvNFNsaDA3a3c3ZG9qd1pGTk5IVXRvemVxTnZiZi9JV0E2aUdVMnpQUFdh?=
 =?utf-8?B?ZGd4ejFCKzZhMTNCWktzM2FZMmlXSkNKOWYwUm5veWxIU21iL3dwWXVmMmpF?=
 =?utf-8?B?YnhpV1BPZVViR2hPcmJCY0U0SHlDeE4yYkNTVWdrV1VteklXajlRbUppL1N3?=
 =?utf-8?B?MXowNW1nMjZQaVZQZHlGTTY3RlJENVlsWlZqVlpBUHNyNXlDaXpqc0NJSUJJ?=
 =?utf-8?B?REU5aG8wZDZxUTdkNk42VnU1RmpoUlgxajE4L1AxN3BIS1J0N05DNDFHOW9I?=
 =?utf-8?B?UWdjODlnSmxuYkZKUllCYmRQZTg4cnlNN002WkYrbkxlSFJIelZEbWlEd3g0?=
 =?utf-8?B?ODErL0l1eUc3bWFvWXBmMERHRW10bkJCNTdZZEtsT3haRGtpUHcvN24xV0VJ?=
 =?utf-8?B?eldIRjhrZXFMblRFVmM5cTZ0bWF4V2NHcjd6RGNoNVVsdmI2S2wvcCt5QVNL?=
 =?utf-8?B?VklnVEhtemJDUHFLclIrU21LUmo3bVJLWjU4MlBVTStIaXJhb2lleEdhZkpF?=
 =?utf-8?B?QlZnOFh2cHZnRG81SlcyWCtIWnhhQjJsbmxQaFFEWUlmSVlxWXJmTzdiSU5P?=
 =?utf-8?B?eTZaa1VTM2YvMmNrMUJmellGQ3NtZlREWnFLdDBiZjJkYi9LZGo4NXJPd3pi?=
 =?utf-8?B?SzJPeGxyTm9VVi9VRTBMZDQweHdZa1EwVmdRdUFoU1lDQXRHdVNrcitVNTJG?=
 =?utf-8?B?ZGtRbHdEL3lPYWlZTXkvQXh5dGdYTWkrVnBSWGs0TVFlamdtaFdPY09yTGRS?=
 =?utf-8?B?Z2ZHZjVNR3h2K0psNEJkc0xqd000bjFjdFMyNm1XNXBZNCsxSjhjOXRDR0pE?=
 =?utf-8?B?TW1WbjdXN01FVGxWb2xSWjhqWVZwK1hZSEcxcW03RDBmN3ZJL1Y4TkhvdE1u?=
 =?utf-8?B?TUdSai84NHpwZUZFb29QaFJ3eCtnbDVlckdmVVpNN3daVjJ3Z3dId1d3U1VH?=
 =?utf-8?B?aVAxMHNZa1FIdnJ0R3A3bm1jakpHbTVoZTRacjJLWjhXR0RUSVkzRndtTTVI?=
 =?utf-8?B?aUhFZVA2WDJOendoSVJoOVVyaUdpczVud1M4cEc5TGk5WnhZWGNDdzZSbHJW?=
 =?utf-8?B?anozRnAzRitYb1NGbHJySWtUSGpLd3NtWHZZa1puV2tiY0M1QmtLQWRsM2o5?=
 =?utf-8?B?TFVRRi8vV0tTdXhkV0dHQjdXd3pTMUdvNjB2QlVsQ3Jmbmx4cGhTWHl1ZnV3?=
 =?utf-8?B?SWl0TDlzNmRsQVpGUHVLTktENjRlUDlQeDdZaGEyWC9vMUdld3dSdElyR3cw?=
 =?utf-8?B?dGlnMGkwMUlsQnl5anBpcHg2L0JGR0MvWXNDcER3dFIvUHFwOXJOTFRTakp2?=
 =?utf-8?B?eTB1NkVNeC9JbVR1T3Q1aG9wM2NKdHVESmlOQUNIcGtldE1KMDBJWTVpT3dX?=
 =?utf-8?B?ZFJWOGV4UEFXWjd2VlZiNUZNOFdleTg1REREdy9VU1BkQkZpQUxIKzJtRERO?=
 =?utf-8?B?enQ5S0tTZGViaE1tV3NSWk1QUzNVbFhaMEJDdWJsZVcwNFZpTnZtbVRkdXJH?=
 =?utf-8?B?eDBoN2xVWVByT3hMdzVseVltT1g3OVQvY3FZODFtWkNnWXFnN0ZOaUFTNGNx?=
 =?utf-8?Q?0i9NdKYIL9o81B7rmj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: CzyB+C3ifPrr/RhGW30tolY+JsNzorMW/KLy2nM5Qrqg97IROXUJM0oOwhSOk66lktg+07y3w0i8s3hdtSpb/BBqr45HTw3qkCgcULjq+IEpUjg+qa0fhEdp2cHC1yYGtXbwhIc56gsqCd81wSmRFrgoYNRh8gl1mtf5LLjbk/0KH3ou3ut2c/BVEs5sEYyDlZDia66fl1bxm9B3kE9ypJQbgdduJ8p51ul8IQl5zcMsiffLaaONVWFL8qcdJ34q23ihXSqfu1Jau+WjsZjNjH/CmWm+sWAjIgbYcJ1WqW3CfgeJZI8BJ2S/WLM8pDdgeh95BXaKhBSmN7F85BVWFw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88467297-1564-48cc-b50d-08ded35c8fa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2026 08:26:03.3241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y0pnZiJNUut6KIf8bOxA1/sxM1nPZA+sulCVDhQP7Tuasm6nSMmYMhobMjSeipYnl1OFJiDkzNjQo+UkhJcqVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7787
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 039A1160003
X-Stat-Signature: bcjdgzh7cta4rkm5y8qpjwk1nozgpxgy
X-HE-Tag: 1782462373-644800
X-HE-Meta: U2FsdGVkX18RFZwy0dxYwEmnXTiwiOc2MeM4XNoGA1tss4YOVknsEjUsSOnBnPaNm+YF6P/wLsZ2KFy37Bu0mZnMv7v50rz5B0wsvjv3XGoprGHXwLKfbnZD/z3eWRNe8629tGZ8cRRoBuAFSkGcAyai91fa/g/shEZVZITN9Ce6bQiVaEHt+/fm9JcWvnH//8CcAYnN8/X1HIdEkYQv4J4Za1Bd+ykCJ50XJlChbDu/SOnjicuOTsa7kxtH336EAjrZetNUtlo+EHD2r6FR1EPakmAfShNXePhnVwyO04anG4KcQhlZfivYyWrE7SmH6J9e6H5A+Cy147yF6ywcAecvXeoaeUPu6EUUHR/Z3EPCScQjuRV3cxMKlA04LWgQ9MZtBQ38FMVKb2P6C45H2DZyVY2bOMlzBu5lAGT/1YHID0IcWmqLGc8a4rv6ztDgj5/Mk8oSVmiPpP/D88cpZSgWMf4O0DNrmd5Y2FHTUWazQfQ1pU0KWiGXjVByka3zuue0CNoYmWz6wzNH/2h7zFE1b3u/cR90L5ceTYd8S6CU0Z6K8pZe3hjAvq32nx3dcOZ4u2bCtScHD5dl1PzRUfC46NAQrjUlWA6pH5WuJNIsMgLnqmZkAfEvcL8+fzT3bkt5EP2JLTLPmBhtLu8FfpUnecf4QAWdsqJx/zDWkoBJQkOmIZT7si72qg6A3/SPZZfq4PbPouePLaBg5eyDZczeZGHFLSjTONKc3ok+6ThzDEfelcv3U2bXFySA8HmP+QC980fxjWYvYd5b+tUAeP2aPkarqoKCNijAeJbgCkf+O+hpLo/3NXIdyMBqceVohrvsYpR/QWNdHCvx70zYF7E3wzySPR//RWFkzoXxcMf2BCVE9BsnUFz3iwlpUOFVG5QWDmJQP3TBHXrNHEdBh2Lgw/QG1hrMfG6CXPpi2Z2Q+hRSyplyxNYno48uxU/sBT2dNlVcb8S1nd1GocI
 ss94LTam
 izmrIvvxtO50CzrjayjqN0+YMDm05yG89yLuI7AgN4an3PUYXqO25nZm2TINQ9GEWzL9NQpsPQ9bcFxsFPhJlQ1cSQaqHf4JSOOzwwgTwyOXzMyLuuw7bgW3145PkoCUvf8zeSS7e37UEiqcbg1a0BsqiLPCOGbbFypaGpifiQxi23AB9EVwdEo7LaPGyE5NLIEJ6lbKsPOrActVY7Iz85I4n+9TNi1TwSKQYFIXBDEc9jEpLFI40830lF6JOx5/YshG8eYazCZ4btG0CeBrnhVxY1kGgNWbHobVt6eb7LYXMAcU3dfhyaILadUhrQSOVL0UvWfnjpVHjgH+oxHEP2rdKv0CNdbhGEtWgmsNtQHZOknZGwVBPF35yT6WMjR4bhmZ+w/3CqHfvPZmhyXHU1k8HrErN5zxW+/cJZL7CCR8pBmKsWiWmCdbcXMPRdRjQF7RCxecb3HOfrDGvKdarEBzvD+oWLIznsXUdZu+R4VnCyftvRDZjBE4jeSUBAVosVLD230hKSujyGmvYJ1Kp+s0MiBq04g5jCeLp0OANt0T4G28FAkUPGjgxwrLFDn93Gppb7osZjHgzFKxvU0tBxDPSQLR3MFHVEYPXgN8tWfh8nUyFLMolVb0GnPgXISNRdKKeDA1YBhKl17iy6eK7hLc0Rjw+Jd5gS1QEJBsCWDH75Q3tCnpUdTVrRR2x80dt1cZkeIXSMI1RhmkpnIOO3zy1yUrTdCxBlv5HaflznMmWVl9dB1zgN4Mjzy699EjJL51GO1gcczsDqIzPcQxonKxyRC5xte1GDBUZ8eAC0kF6HZCpPicD/htgLsZd1g2NanKKG2XyTMEWPDlDkFApeyG9Sks/x76yyQXm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERhdmlkIEhpbGRlbmJyYW5k
IChBcm0pIDxkYXZpZEBrZXJuZWwub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgSnVuZSAyNSwgMjAy
NiA4OjA1IFBNDQo+IFRvOiBMaXUsIFl1YW4xIDx5dWFuMS5saXVAaW50ZWwuY29tPjsgT3NjYXIg
U2FsdmFkb3IgPG9zYWx2YWRvckBzdXNlLmRlPjsNCj4gTWlrZSBSYXBvcG9ydCA8cnBwdEBrZXJu
ZWwub3JnPjsgV2VpIFlhbmcgPHJpY2hhcmQud2VpeWFuZ0BnbWFpbC5jb20+DQo+IENjOiBsaW51
eC1tbUBrdmFjay5vcmc7IEh1LCBZb25nIDx5b25nLmh1QGludGVsLmNvbT47IFpvdSwgTmFuaGFp
DQo+IDxuYW5oYWkuem91QGludGVsLmNvbT47IFRpbSBDaGVuIDx0aW0uYy5jaGVuQGxpbnV4Lmlu
dGVsLmNvbT47IFpodW8sIFFpdXh1DQo+IDxxaXV4dS56aHVvQGludGVsLmNvbT47IENoZW4sIFl1
IEMgPHl1LmMuY2hlbkBpbnRlbC5jb20+OyBEZW5nLCBQYW4NCj4gPHBhbi5kZW5nQGludGVsLmNv
bT47IExpLCBUaWFueW91IDx0aWFueW91LmxpQGludGVsLmNvbT47IENoZW4gWmhhbmcNCj4gPHpo
YW5nY2hlbi5raWRkQGpkLmNvbT47IFplbmcsIEphc29uIDxqYXNvbi56ZW5nQGludGVsLmNvbT47
IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djUgMS81XSBtbTogbW92ZSBtaXJyb3JlZCBtZW1vcnkgb3ZlcmxhcCBjaGVja2luZyB0bw0KPiB0
aGUgb3V0ZXIgbG9vcA0KPiANCj4gT24gNS8yMC8yNiAxMTozNCwgWXVhbiBMaXUgd3JvdGU6DQo+
ID4gTW92ZSB0aGUgb3ZlcmxhcCBtZW1tYXAgaW5pdGlhbGl6YXRpb24gY2hlY2sgZnJvbSBtZW1t
YXBfaW5pdF9yYW5nZSgpDQo+ID4gdG8gbWVtbWFwX2luaXQoKSwgYW5kIHJlcGxhY2UgdGhlIHBl
ci1QRk4gY2hlY2sgd2l0aCBhIG1lbWJsb2NrLWJhc2VkDQo+ID4gY2hlY2suDQo+ID4NCj4gPiBS
ZXZpZXdlZC1ieTogV2VpIFlhbmcgPHJpY2hhcmQud2VpeWFuZ0BnbWFpbC5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IEphc29uIFplbmcgPGphc29uLnplbmdAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFl1YW4gTGl1IDx5dWFuMS5saXVAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiANCj4gSUlS
Qywgd2l0aCB0aGUgcGF0Y2ggZnJvbSBNaWtlK1dlaSB0aGlzIHBhdGNoIGhlcmUgc2hvdWxkIG5v
IGxvbmdlciBiZQ0KPiByZXF1aXJlZCwNCj4gcmlnaHQ/DQo+IA0KPiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9yLzIwMjYwNjI1MDczOTQxLjE0NTAxNC0xLXJwcHRAa2VybmVsLm9yZw0KDQpIaSBE
YXZpZA0KDQpZZXMsIHdlIGRvbid0IG5lZWQgdGhlIG92ZXJsYXAtcmVsYXRlZCBwYXRjaCBhbnlt
b3JlLiBUaGUgem9uZSBjb250aWd1aXR5IG9wdGltaXphdGlvbiB3aWxsIGJ1aWxkIG9uIHRvcCBv
ZiBNaWtlJ3MgYW5kIFdlaSdzIGNoYW5nZXMsIGFuZCBJJ2xsIHVwZGF0ZSB0aGUgcGF0Y2hlcyBh
Y2NvcmRpbmdseS4NCg0KVGhlc2UgZGF5cyBJJ3ZlIGJlZW4gcmV2aXNpdGluZyB0aGUgaXNzdWUg
d2hlcmUgcGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwIG92ZXJjb3VudHMgc3Vic2VjdGlvbiBob2xl
IHBhZ2VzIGluIGVhcmx5IHNlY3Rpb25zLg0KDQpXZSBwcmV2aW91c2x5IGF0dGVtcHRlZCB0byBh
ZGRyZXNzIHRoaXMgd2l0aCBhIHBhdGNoIFsxXSwgYnV0IEkgdGhpbmsgdGhlIGNvbmNlcm4gcmFp
c2VkIGJ5IFNhc2hpa28gWzJdIGlzIHZhbGlkLCBzbyB3ZSBtYXkgbm90IGJlIGFibGUgdG8gdXNl
IHBhdGNoIFsxXS4gDQoNCkkgY2FuIHRoaW5rIG9mIHRoZSBmb2xsb3dpbmcgYWx0ZXJuYXRpdmUg
YXBwcm9hY2gsIHdoaWNoIGNhbiBhdm9pZCBjaGFuZ2luZyBzZW1hbnRpY3Mgb2YgcGZuX3ZhbGlk
KCkgb3IgZmlyc3RfdmFsaWRfcGZuKCk6DQoNCkJhc2ljYWxseSB3ZSBjYWxjdWxhdGUgcGFnZXNf
d2l0aF9vbmxpbmVfbWVtbWFwIGJ5IGl0ZXJhdGluZyBvdmVyIHN1YnNlY3Rpb25zIGluIGVhY2gg
em9uZSBkdXJpbmcgbWVtbWFwX2luaXQoKSwgdG8gc2VlIHBmbl90b19vbmxpbmVfcGFnZShzdGFy
dF9wZm4pIGlzIHRydWUgb3Igbm90Lg0KSWYgaXQgaXMgdHJ1ZSwgdGhlbiB0aGUgd2hvbGUgc3Vi
c2VjdGlvbiB3aWxsIGJlIGNvdW50ZWQgaW50byBwYWdlc193aXRoX29ubGluZV9tZW1tYXAuDQoN
CkhlcmUgaXMgdGhlIHBhdGNoIGxvb2tzIGxpa2U6DQoNCitzdGF0aWMgdm9pZCBfX2luaXQgdXBk
YXRlX3pvbmVfb25saW5lX21lbW1hcF9wYWdlcyhzdHJ1Y3Qgem9uZSAqem9uZSkNCit7DQorICAg
ICAgIHVuc2lnbmVkIGxvbmcgcGZuLCBlbmRfcGZuLCBzdWJfZW5kOw0KKyAgICAgICB1bnNpZ25l
ZCBsb25nIG5yX3BhZ2VzID0gMDsNCisNCisgICAgICAgcGZuID0gem9uZS0+em9uZV9zdGFydF9w
Zm47DQorICAgICAgIGVuZF9wZm4gPSB6b25lX2VuZF9wZm4oem9uZSk7DQorDQorICAgICAgIHdo
aWxlIChwZm4gPCBlbmRfcGZuKSB7DQorICAgICAgICAgICAgICAgLyogQWR2YW5jZSB0byB0aGUg
bmV4dCBzdWJzZWN0aW9uIGJvdW5kYXJ5ICovDQorICAgICAgICAgICAgICAgc3ViX2VuZCA9IEFM
SUdOKHBmbiArIDEsIFBBR0VTX1BFUl9TVUJTRUNUSU9OKTsNCisgICAgICAgICAgICAgICBpZiAo
c3ViX2VuZCA+IGVuZF9wZm4pDQorICAgICAgICAgICAgICAgICAgICAgICBzdWJfZW5kID0gZW5k
X3BmbjsNCisNCisgICAgICAgICAgICAgICBpZiAocGZuX3RvX29ubGluZV9wYWdlKHBmbikpDQor
ICAgICAgICAgICAgICAgICAgICAgICBucl9wYWdlcyArPSBzdWJfZW5kIC0gcGZuOw0KKw0KKyAg
ICAgICAgICAgICAgIHBmbiA9IHN1Yl9lbmQ7DQorICAgICAgIH0NCisNCisgICAgICAgem9uZS0+
cGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwID0gbnJfcGFnZXM7DQorfQ0KDQpzdGF0aWMgdm9pZCBf
X2luaXQgbWVtbWFwX2luaXQodm9pZCkNCnsNCiAgICAgICAgdW5zaWduZWQgbG9uZyBzdGFydF9w
Zm4sIGVuZF9wZm47DQogICAgICAgIHVuc2lnbmVkIGxvbmcgaG9sZV9wZm4gPSAwOw0KKyAgICAg
ICBzdHJ1Y3Qgem9uZSAqem9uZTsNCiAgICAgICAgaW50IGksIGosIHpvbmVfaWQgPSAwLCBuaWQ7
DQoNCiAgICAgICAgZm9yX2VhY2hfbWVtX3Bmbl9yYW5nZShpLCBNQVhfTlVNTk9ERVMsICZzdGFy
dF9wZm4sICZlbmRfcGZuLCAmbmlkKSB7DQpAQCAtOTg1LDYgKzEwMTksOSBAQCBzdGF0aWMgdm9p
ZCBfX2luaXQgbWVtbWFwX2luaXQodm9pZCkNCiNlbmRpZg0KICAgICAgICBpZiAoaG9sZV9wZm4g
PCBlbmRfcGZuKQ0KICAgICAgICAgICAgICAgIGluaXRfdW5hdmFpbGFibGVfcmFuZ2UoaG9sZV9w
Zm4sIGVuZF9wZm4sIHpvbmVfaWQsIG5pZCk7DQorDQorICAgICAgIGZvcl9lYWNoX3BvcHVsYXRl
ZF96b25lKHpvbmUpDQorICAgICAgICAgICAgICAgdXBkYXRlX3pvbmVfb25saW5lX21lbW1hcF9w
YWdlcyh6b25lKTsNCn0NCg0KWzFdaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vMjAy
NjA1MjAwOTM0NTcuMzcxOTk2MC00LXl1YW4xLmxpdUBpbnRlbC5jb20vDQpbMl1odHRwczovL3Nh
c2hpa28uZGV2LyMvcGF0Y2hzZXQvMjAyNjA1MjAwOTM0NTcuMzcxOTk2MC0zLXl1YW4xLmxpdUBp
bnRlbC5jb20NCg0KSSdtIG5vdCBzdXJlIHRoaXMgaXMgdGhlIHJpZ2h0IGFwcHJvYWNoLCBzbyBJ
J2QgcmVhbGx5IGFwcHJlY2lhdGUgeW91ciB0aG91Z2h0cy4NCg0KPiAtLQ0KPiBDaGVlcnMsDQo+
IA0KPiBEYXZpZA0K

