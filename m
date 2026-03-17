Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A05EFED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE456B00A4; Tue, 17 Mar 2026 13:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F5C6B00A6; Tue, 17 Mar 2026 13:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718B56B00A7; Tue, 17 Mar 2026 13:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC726B00A4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:12:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7E491B71D0
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:12:46 +0000 (UTC)
X-FDA: 84556199532.01.B7EEC52
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023078.outbound.protection.outlook.com [40.93.201.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id F000918000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:12:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=E6e0zAwx;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.201.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773767564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YOuISBoWEODjY6DzFY5shyPZi+OwatGTgXFwa2s9IHc=;
	b=mp+9Hg6YduNUAJHn0WeXpUPDyWrmhS3ZkM33WrJ3YwMOVOvm3GxQGR28dTKbmSdJSCty5p
	ITVA/dCr2tdbeLA1dPK6mBJkPWm8tIWSMFJFEoBpTJ4qvoqLSffS7W9rftPqKT95upsWjX
	rQV0W7WKwpdUWp2C2sScWM/OMjvjx/k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773767564; a=rsa-sha256;
	cv=pass;
	b=09OYNQrR2HO/H2NKWJcaae5Y4g3nFdHHSGTqK92v+VORnw2HudvtGLN1KGqNxd1bRPaQBk
	V82v91xk1fuqYZCZjv2nTCBrWie4eyCkUwbNmQvGDClX147/dpp0QKA4kDzv7pR8kHPbbt
	YLwgZBHoC0hN3Q0AMvJqNc21tBWX+5c=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=E6e0zAwx;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.201.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zdjwhc1CyMTX56rV4hykkvwxVGlRz56dZOsS6+kNyIk0WXXo60/RZDZHZ4FCklVeisttoOmOpy9hxOm/bkXo8AThpH0sLD38PwBCaegryeVm+liFnSZntYElmOsvQsknSCR4VqmlF4TPPsm32xXOBTfaGfAFsKWeSq7Cwrkf6VVqwqJDMKXmiQCrazVb7bwKRglC3lB4+zWYZhPn6cpLVnFHJ8Cz4qfYXGMLfILo727cizfBhrHbo+hJ/+XDKhqBkH+/+RtzAxQtTz8PgmR623GEv7Iw1NgDeerJguCZdBlMKzxwWpyZnwlWKuBUcKXo6m6vWZzBtHgXjq0d6Cq8lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOuISBoWEODjY6DzFY5shyPZi+OwatGTgXFwa2s9IHc=;
 b=EL2l9PZY3L/HrCwq3cq2dImN5PZpK46pu3BbJt+Cy4vguATn0HhJShBUhQ4/MQ88pSu7fGw1L1hc7WdHfdMNOe6a3D1LuI7AK2TSHaajQHhePX4sYqPz3HA3rHrovz1qn6RgZRVAv33IWZfHANRpgi1U4bbMeJg/Q7IDgDK2j8Sbk6cAlhU1qHhh8wmDBlCAl98Sdcm/GgP/ydEpoPDvVXaCN0oCd5FNaeDcPCdlRMD//X3Nvo6GcBKzNOvqktrj99rlRUmpIzZ88Sv3woV4oggobPnK5ahBAdXK3HN4PyOV4ZQ8qeHjcxmTIVCYnR9golpHor6/uNvEmq5LQ1HWMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOuISBoWEODjY6DzFY5shyPZi+OwatGTgXFwa2s9IHc=;
 b=E6e0zAwx50VhLQCNcACfSKcBqtJA7qcUeQSwyNySLtwSiHxahwkuJ9V+eUIsGnDGJRxwf0M5wzpay4jIzz0V6cjX1KG4726sOlFvQEXdycS/8XQt7D3OLNIQht6M1BMbHqP9onRzu5HCRE8gPl7V3Otv64ws4V84AK2NYgWuJWM=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 MW6PR01MB8413.prod.exchangelabs.com (2603:10b6:303:239::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.25; Tue, 17 Mar 2026 17:12:36 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 17:12:36 +0000
Message-ID: <95ed9dd3-0320-4fd4-98c7-65e531ebdbe0@os.amperecomputing.com>
Date: Tue, 17 Mar 2026 10:12:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Jinjiang Tu <tujinjiang@huawei.com>, Ryan Roberts <ryan.roberts@arm.com>,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <0b2a4ae5-fc51-4d77-b177-b2e9db74f11d@huawei.com>
 <de0b06cf-15a5-4109-b339-75c10d9b8a18@arm.com>
 <0a740020-4780-4156-a9c5-f8b4ada9c8c0@os.amperecomputing.com>
 <e35ee155-81aa-453a-8197-2c87d923f84c@huawei.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <e35ee155-81aa-453a-8197-2c87d923f84c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:a03:333::13) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|MW6PR01MB8413:EE_
X-MS-Office365-Filtering-Correlation-Id: adfec328-7d3b-456d-c7bb-08de844862ee
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|56012099003|18002099003|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
	JwJFT0fCK9DU5MVU8GtA6vUG19UB7iMSRvSKlPv7syk8aRUY6RGB+O68Hfx7K3s4cyFPWl7dCxNcM8lQilr4hCupdtFFcW5OedFTwmK6I4F4YkivYIIdyvo6A75n7aNXdvZWReieKvkZB8HtyBq8em9nWknCKz3acGts7qaHx3cAXYir9YaokSHmdnd5dL3pePMXngZompWh5HCCU6zM/85STAMRHBV2KsaapQhhHVKN2kaWuxHPkPnxjECR0KeGq/22pu3eJULCrmePt1Alh+ExpLJlDTBh65RRD6G5QYlYCThhmOy7y6D38S9NVhDlKmMihq0Pa4zHSe4uXJsWvQ9piKbRQJxb/yRl+rR6sdyhsGAGUjYaKR3zMVHiQWC5TleqPKeetoZ5mVkKssvCCtoNMDL5mb/Sov5GFeg55cELgtyfCDqW8d1RM2zMu/YKapwD35uE2+o7dseaq6tm8iZ+vVJJznbOfuZjNL78Q6IUBn4vdkRXb/Cp05d/ndtNPPmAfp/1f+uz5tAmRKhqNkWVUGyu+L0upYSExzaz4YbVZzTU9MniWEGtHwmRwPN6h+4tNJW4NRQjJNINNWM7Y7HIo4+KgRRm0JvHNpU2+H7qf4YxdE2qqyCG4JOoADZZux5OZAQQJtnTULBR02hhhDLzWpUsur9+BNim3EaWnFU8X3FyURUBBAhzCfhp0RbR4H5CBSc9VLG9xaX55U4ZycgHeD2su13vI9tQcrgXlylp9wYqIv7ybM7moaRssLNotSx9dCjVZfuc0m0Rh7lw7UftCcmx0ZVE01lJzL9aGNI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(56012099003)(18002099003)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkJOMUJZVDgzY3lMaDBYRktzN3FaLzhjRWFvcXlEeFhtb2NXWjhGUWhXbGFM?=
 =?utf-8?B?VFcyMFlwbXlENkIwS09Pck1rM1NRL0NIcDBLL3RXM3dvQkZBbDN3QXcxWVhl?=
 =?utf-8?B?WGlKMm9nemhmMlF3WFpaTSsxUSswZ3NkQnZDaktBQ2NRTGw5ME5xODBZVFNm?=
 =?utf-8?B?ejhQbVZhSUl6MEw5dXc2Ky93NjFialpuN0hzalZ0Z3U2c0d1Y1puQi8vTldn?=
 =?utf-8?B?QnhnUmdsQ2FHMnBJWEhrdEVjZEllc2RTazd5Vi85RmxTZjhuRzFBV25TWmdy?=
 =?utf-8?B?TVZYcVZ5Rmlva2ozUWZvdlVocEg5a29oL3VCSGtsbXJQYzZUMTV4WDljcDJt?=
 =?utf-8?B?bG1UNGZpL0VMNEFGNHJNWThoV3BkY0lNbyt6NWt5REFPaWpKcGZ3aEFSa29B?=
 =?utf-8?B?U2JUZ05SVWRhajBvdWJWeTcxK0Y2UHEra3Zld1pHUzVFUFk1WUtIYUEwWjlH?=
 =?utf-8?B?dlVTVzcxUWJvbHMvL01GZWtGODRDZ1JoRXNsbStTMHc4Nkx0cUVneENaV2pX?=
 =?utf-8?B?WVVlRW92K1JTS0VNcWMrZzVmN3ZQbm0zdzBaMi9NQjRSdWRwaWFnT054bTZK?=
 =?utf-8?B?b0dzMm5PUGZudTVmcFEwa3pTR2ZOaHZmZmw0WURZcHBFTTRuaTVhOHJVa0RM?=
 =?utf-8?B?MVE1M0RQdnFWY0FtbXdSUHU3bnA2SkF6VmdRbnpWVFFhQ1N3N05jWXdHQ3Nr?=
 =?utf-8?B?NC9jcExuY1FRZEd4NCtPZXZZVXBTTnZRcFQrVENzbG12eGZsKzJjb3drUUZN?=
 =?utf-8?B?Umxnc0VSYSs3SE1OSWs0emMzbm8yci9FZGcrbFgwWmNYR1ZQa2tCUS9hc0dr?=
 =?utf-8?B?QVpwZG9yQ0FPaEo5anNnQllZa2RicmRpYlBJcUJLTGR3RjZJcjNnUkVjYStK?=
 =?utf-8?B?SURmZm1XVEVMUTljU3NIa05rcVl5ZzdETGRURGZRSWpZNFJRekh1NEZrZExM?=
 =?utf-8?B?U1NOcGJvb3Bsb1RUWEVCQnd3em96bkxIWWpMWkhhWmhWSnNiSmJtanluKzk3?=
 =?utf-8?B?SVg4MXdob1dhUjF5dkNXaTRXMHY4RWczdk94NDlmczBiUXgrM1kyL1g2clZv?=
 =?utf-8?B?MTZIcGI0ZlJqeWRHbi9RTHBtWi9pdmtIM2dwd1YvakM5VTE5Q3Y0NDlGRits?=
 =?utf-8?B?djY2c2t6RFBROFZTMDUxdHhORkNrYVh6VzhVU0F3cVlGajk5czFSbkxmUVV4?=
 =?utf-8?B?NHhKa1hmVmJtMjBtWmxTeXQzSnEwRXBlL2kzaWNFa1Vqc0JmQk15clNpWkhK?=
 =?utf-8?B?dUlPSitGeXcrWGtRS1FOWHBsZEZNVDZlN3hvNmQwTUVOTXF5SlF5aXN6cmll?=
 =?utf-8?B?dmo5cHJnQllxZ0pVTWhMM0hEZFUvZHdMTVAzYWVsQ043VklvQU9aU2hHeEhm?=
 =?utf-8?B?MUVBeGptSkI2aXdtV3h2MlZrRVpoWjJjU3Q4bExJcUN2WDlVTEVmeVBmZXlO?=
 =?utf-8?B?OC84MnZBQ0ZEM3VNbW9zNnpMSnh3bUlkMUcwTWg0SXpHVjY5WU1OUFpoV0RU?=
 =?utf-8?B?djRPclNhc3BkL28zcUxaZnRPaXdaa1dzL0pMcmxNdWJ6cU9kdFhJMW00NU16?=
 =?utf-8?B?N3o3bEdKNVJzeVNIdmcxYmhWQ0hvUVI4V2plTnBsTkw3YTdKcWx5L1k0TnFu?=
 =?utf-8?B?anJNT2RYMU02ZGl4eW5GRlFmS1M5ejE5ZmFlWXBFYnhRaTdTV3ptTFJKOHZF?=
 =?utf-8?B?VzZUNDJzSkIwYTQ0NEFkaTBJRUYxUTdMa3BHMDcvcVV1Y1BFNUd3L2dCekFZ?=
 =?utf-8?B?REw3SHg5N0JPZmtBR1d1d3Jwam55OFB1V3VJT3hiRi96a05WN2RvOWowcm03?=
 =?utf-8?B?aVcyUDU3WnVQdE1GbS9nMGNTdjFSdVpnajQyUW96eHV6dEZJdFk2RzhrUmlR?=
 =?utf-8?B?TEdlUFlzY0p6VzJqR3U1ZGFGQ0lHQ2dOTWpoWitRd1QxZEhpT2JTSlpoZkg0?=
 =?utf-8?B?N1dsL1BnamlpcGhRcTVPN2pjMTU1N0hZSDRSVnlhWWdCMnk3R2hJcE9zbkFG?=
 =?utf-8?B?M3JINmxqWHlweUhCRUdWNktMdE1mcU1EMURkTkhrK2pOQ09JQVhxMmNWSm1r?=
 =?utf-8?B?ZTRZQVlsNXAzTTlVNnE3clB5ZVM3a3J2d1R3N1RvcWJEbTFTU2Y4d0Jna2No?=
 =?utf-8?B?Skl5VTZVMHVVS2xQbkEwNTFueUYwSnQvbDVjN0VwZ3RhMDhXRjVjYVhKOTlm?=
 =?utf-8?B?T3V1a2tONGxwS3Z0c0VhU3RCTU8za2hZQUxPTVpTbXBPdzhxSmtBWnZYTk5n?=
 =?utf-8?B?OXR5WklQcUpPaWI3WTJKMHdFWXRRb0o2Z1U0THBkdndvMlFxNEIySkVaeXVw?=
 =?utf-8?B?U0RpRis4T0c0OEtSU0FzRkcxVWNPQ1RCcmVQN3B2OWxhb3JZYlRxY21OU0kz?=
 =?utf-8?Q?GxkHD2G5U1VPpdSA=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adfec328-7d3b-456d-c7bb-08de844862ee
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 17:12:36.7448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntOvf1Un0R5FLaveu2aPl3qXfuAxaeX0sfE1/Zz2shd72x8lnxvirEol+sZJ9zRHOv8JyYMZT4qPxCzipIUgk1ejSPFUdi84rwinKhkl5vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR01MB8413
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F000918000E
X-Stat-Signature: itwbig14pfw83t5fymotmjitn1ekwmr5
X-Rspam-User: 
X-HE-Tag: 1773767563-685246
X-HE-Meta: U2FsdGVkX1+hH2bRWqkuJpzCrfn9bcYYnzkjG+8F0Rsyce07/mZtNIqZDznVyPBEDJuq2fD/RY0DWCyxDhaLG30hdUAzBgpHCbfGf0UoVXOIlVJfKPVei1I+jMpGD4u1wQk15U+Tpmrf4eKK5aDP4Lt9h/vbnc8aX8mHRwybSp7r9Ri1Km0VluZHRcce8uZmi8XXagcmBXR/zAMEUovZ5tclEC2dqPHd8NnfQ9yaX7/UvEMRBvuKzp9AN8OAF/qZnDPQ4Jf9kGe1RBJZjPn5I18CwSZF2jQ8YoAO1lneuuY3RMiPVkC7R57m8eK/zH3fRfTyDVAgcOPFKbN91B/n63QJIQx2MLQtzCOzv5/qBANL1KzOvOFm6Kh5VUYaPJLqJkpN9r8uoM7rOwn/ZP2Xzn1/gGyodJA8+8MyHD6xXfOA8HM0tc0dOpJoBmlizbsrc84fNR9pPNKuPrEpdVnuOL6SB1nx31W7Pm/zXYde+hYv2IPbHd2qLI29+nGYfL0PYwsZZ8KrOL7L56le0e7k9AnfbYnR0S4QBL2/zS+y7ryiBayJHSmzuVbjtDzCjDvIjOoQYgj0GMTKMCn6/ikWM8iyXZqvwYqMiD1T52XrQYFbNlZUHoP6d143qxQiljnuC6COmiLNVi9gn9/rGFLtx3ZOqnYz8jNa4x3dJBYAmApiZGcmE0lD+GVVQXNIT0yNYZ7nXIkO5TF8CPQFi/0guQgRpe5ILSGDxq4UzJXK+lipjNM84PdCXonxhGzeOOL99PQ8X9o0G3+/17/N7AgtJHir13hL/z+oaHM348FZnADd2rMKen9wFWKms4t0fdTTVtsR58u0Wa2cmo1MLpovuR85SyJFNMFUAL0t7acCnA2XCyZRvubFWqiAZ9Bi9zYcVY/WxgtwjXeaKfQKDbyiZZnA+FEXvC3Hxt8NcqR6P4ViPE8L/X1RR3FCh02O4BdVt+CjEzBmacWptYGhJMP
 f1vBHbZ9
 XLaQhv0Y+lNWnR04fAN4uPTECTGHfZwLjZrWuPtfcm0qFxn2jzOYF1jtJR0SbxogVWXlx5ndvMzeRMDE2rYMbYle4Qbx2NkpEik5WIjH3DCnAaSwaylNA5BI0sNvVhT7JQVihZ02AMy0rvSnC1ROWMWVVGHk+cmfhGdu2ZJYWJvVZoIa2A2zTCTmiy07VGYXbQHYyX1ClEv+jc1LTMG1MkQFdQiA/PxWVOcKo9O0IDtSHwB/enduuhAkdTqe7hb6aNhGpInDQp+L/BQvwlucbNLChSiaoAsYj5WL3FxeVIVX/+M11VJ749jGyVTHbtVmikPj1GTGv1fGirwvNiJONmiAzoQDsJzhQDdeRBI+RCSRpcKSaB4DfPmYz3zekb+QM2zN+TH1v7uUZtDs7iTTQiB97Glzzt/4jGueETI6Fk7+53SIJ+Tba5jKHrMLfH1AcpeQS1Mp2kh6dZ+1MPnER4RdYjVC/iVpD9AVtSIGOZv9SZZDARxvrsv3pXNPUeLhn2n45x8Spd41n47JC90FdnLAybrQfu//zI2I3O7oWDaQSkqpE1xoe3iKTx78eGy/Qw1UNiXZuRnDVGkDenNMF1JhQNDQ+p2xMVAKlXbJwu5f4A/vyRRGNKUeD8CyPWbP8ed1pzgTY7EEg+KkvgFha3chFmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 7:06 PM, Jinjiang Tu wrote:
>
> 在 2026/3/17 8:15, Yang Shi 写道:
>>
>>
>> On 3/16/26 8:47 AM, Ryan Roberts wrote:
>>> Thanks for the report!
>>>
>>> + Kevin, who was looking at some adjacent issues and may have some 
>>> ideas for how
>>> to fix.
>>>
>>>
>>> On 16/03/2026 07:35, Jinjiang Tu wrote:
>>>> 在 2025/9/18 3:02, Yang Shi 写道:
>>>>> On systems with BBML2_NOABORT support, it causes the linear map to 
>>>>> be mapped
>>>>> with large blocks, even when rodata=full, and leads to some nice 
>>>>> performance
>>>>> improvements.
>>>> Hi,
>>
>> Hi Jinjiang,
>>
>> Thanks for reporting the problem.
>>
>>>>
>>>> I find this feature is incompatible with realm. The calltrace is as 
>>>> follows:
>>>>
>>>> [    0.000000][    T0] ------------[ cut here ]------------
>>>> [    0.000000][    T0] WARNING: CPU: 0 PID: 0 at 
>>>> arch/arm64/mm/pageattr.c:56
>>>> pageattr_pmd_entry+0x60/0x78
>>>> [    0.000000][    T0] Modules linked in:
>>>> [    0.000000][    T0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 
>>>> 6.6.0 #16
>>>> [    0.000000][    T0] Hardware name: linux,dummy-virt (DT)
>>>> [    0.000000][    T0] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO 
>>>> -DIT -SSBS
>>>> BTYPE=--)
>>>> [    0.000000][    T0] pc : pageattr_pmd_entry+0x60/0x78
>>>> [    0.000000][    T0] lr : walk_pmd_range.isra.0+0x170/0x1f0
>>>> [    0.000000][    T0] sp : ffffcb90a0f337d0
>>>> [    0.000000][    T0] x29: ffffcb90a0f337d0 x28: 0000000000000000 
>>>> x27:
>>>> ffff0000035e0000
>>>> [    0.000000][    T0] x26: ffffcb90a0f338f8 x25: ffff00001fff60d0 
>>>> x24:
>>>> ffff0000035d0000
>>>> [    0.000000][    T0] x23: 0400000000000001 x22: 0c00000000000001 
>>>> x21:
>>>> ffff0000035dffff
>>>> [    0.000000][    T0] x20: ffffcb909fe3b7f0 x19: ffff0000035e0000 
>>>> x18:
>>>> ffffffffffffffff
>>>> [    0.000000][    T0] x17: 7220303030303178 x16: 307e303030306435 
>>>> x15:
>>>> ffffcb90a0f334c8
>>>> [    0.000000][    T0] x14: 0000000000000000 x13: 205d305420202020 
>>>> x12:
>>>> 5b5d303030303030
>>>> [    0.000000][    T0] x11: 00000000ffff7fff x10: 00000000ffff7fff 
>>>> x9 :
>>>> ffffcb909f1e27d8
>>>> [    0.000000][    T0] x8 : 00000000000bffe8 x7 : c0000000ffff7fff 
>>>> x6 :
>>>> 0000000000000001
>>>> [    0.000000][    T0] x5 : 0000000000000001 x4 : 0078000083400705 
>>>> x3 :
>>>> ffffcb90a0f338f8
>>>> [    0.000000][    T0] x2 : 0000000000010000 x1 : ffff0000035d0000 
>>>> x0 :
>>>> ffff00001fff60d0
>>>> [    0.000000][    T0] Call trace:
>>>> [    0.000000][    T0]  pageattr_pmd_entry+0x60/0x78
>>>> [    0.000000][    T0]  walk_pud_range+0x124/0x190
>>>> [    0.000000][    T0]  walk_pgd_range+0x158/0x1b0
>>>> [    0.000000][    T0] walk_kernel_page_table_range_lockless+0x58/0x98
>>>> [    0.000000][    T0]  update_range_prot+0xb8/0x108
>>>> [    0.000000][    T0]  __change_memory_common+0x30/0x1a8
>>>> [    0.000000][    T0] __set_memory_enc_dec.part.0+0x170/0x260
>>>> [    0.000000][    T0]  realm_set_memory_decrypted+0x6c/0xb0
>>>> [    0.000000][    T0]  set_memory_decrypted+0x38/0x58
>>>> [    0.000000][    T0]  its_alloc_pages_node+0xc4/0x140
>>>> [    0.000000][    T0]  its_probe_one+0xbc/0x3c0
>>>> [    0.000000][    T0]  its_of_probe.isra.0+0x130/0x220
>>>> [    0.000000][    T0]  its_init+0x160/0x2f8
>>>> [    0.000000][    T0]  gic_init_bases+0x1fc/0x318
>>>> [    0.000000][    T0]  gic_of_init+0x2a0/0x300
>>>> [    0.000000][    T0]  of_irq_init+0x238/0x4b8
>>>> [    0.000000][    T0]  irqchip_init+0x20/0x50
>>>> [    0.000000][    T0]  init_IRQ+0x1c/0x100
>>>> [    0.000000][    T0]  start_kernel+0x1ec/0x4f0
>>>> [    0.000000][    T0]  __primary_switched+0xbc/0xd0
>>>> [    0.000000][    T0] ---[ end trace 0000000000000000 ]---
>>>> [    0.000000][    T0] ------------[ cut here ]------------
>>>> [    0.000000][    T0] Failed to decrypt memory, 16 pages will be 
>>>> leaked
>>>>
>>>> realm feature relies on rodata=full to dynamically update kernel 
>>>> page table prot.
>>>>
>>>> In init_IRQ(), realm_set_memory_decrypted() is called to update 
>>>> kernel page
>>>> table prot.
>>>> At this time, secondary cpus aren't booted, BBML2 noabort feature 
>>>> isn't
>>>> initializated,
>>>> and system_supports_bbml2_noabort() still returns false. As a result,
>>>> split_kernel_leaf_mapping() is skipped, leading to 
>>>> WARN_ON_ONCE((next - addr) !=
>>>> PMD_SIZE)
>>>> in pageattr_pmd_entry().
>>> If no secondary cpus are yet running, then it is technically safe to 
>>> split
>>> because we know all online cpus (i.e. just the boot cpu) supports 
>>> BBML2_NOABORT.
>>> So we could explicitly only disallow splitting during the window 
>>> between booting
>>> secondary cpus and finalizing the system caps. Feels a bit hacky 
>>> though...
>>
>> I think we can check whether system feature has been finalized or 
>> not. If it has not been finalized yet, we just need to check whether 
>> the current cpu (should be just boot cpu) supports BBML2_NOABORT or 
>> not. It sounds ok to me.
>>
>>>
>>>> Before setup_system_features(), we don't know if all cpus support 
>>>> BBML2 noabort,
>>>> and we
>>>> couldn't split kernel page table, in case another cpu that doesn't 
>>>> support BBML2
>>>> noabort
>>>> is running.
>>>>
>>>> How could we fix this issue?
>>>>
>>>> 1. force pte mapping if realm feature is enabled? Although 
>>>> force_pte_mapping()
>>>> return true if is_realm_world() return true, arm64_rsi_init() is 
>>>> called after
>>>> map_mem(). So is_realm_world() still return false during map_mem(). 
>>>> Thus
>>>> realm feature relies on rodata=full. If we fix by this solution, we 
>>>> need
>>>> to add a new cmdline to force pte mapping.
>>
>> I don't quite get why is_realm_world() relies on rodata=full. I 
>> understand realm needs PTE mapping if BBML2_NOABORT is not supported. 
>> But it doesn't mean real relies on rodata=full.
>
> https://lore.kernel.org/all/5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com/
>
> This is the discussion why realm relies on rodata=full. The 
> initization of realm
> coudn't move to before map_mem(), so is_realm_world() is false. As a 
> result, realm
> need rodata=full to indicate we need to make pages shared/protected at 
> page granularity.

If you read the follow-up discussions, you would seen something 
different. Will's reply is quite clear about "rodata=full has absolutely 
nothing to do with realms". See 
https://lore.kernel.org/all/20250227172254.GB25617@willie-the-truck/

It just happens both requires PTE mapping if BBML2_NOABORT is not supported.

Thanks,
Yang

>
>>
>>> I think we just need to make is_realm_world() work earlier in boot? 
>>> I think this
>>> has been a known issue for a while. Not sure if there is any plan to 
>>> fix it
>>> though.
>>>
>>>> 2. If we could try to split kernel page table before 
>>>> setup_system_features()?
>>> Another option would be to initially map by pte then collapse to 
>>> block mappings
>>> once we have determined that all cpus support BBML2_NOABORT. We 
>>> originally opted
>>> not to do that because it's a tax on symetric systems. But we could 
>>> throw in the
>>> towel if it's the least bad solution we can come up with for solving 
>>> this. I
>>> think it might help some of Kevin's use cases too?
>>
>> May be an option too. When we discussed this there was no usecase for 
>> direct mapping collapse. But if we can have multiple usecases, it may 
>> be worth it. AFAICT, the ROX execmem cache may need this, which Will 
>> or someone else from Google is going to work on.
>>
>> Checking current cpu BBML2_NOABORT capability before system feature 
>> is finalized seems like a fast way to stop bleeding IMHO before we 
>> find more elegant long-term solution.
>>
>> Thanks,
>> Yang
>>
>>>
>>> Thanks,
>>> Ryan
>>>
>>>
>>>> Thanks.
>>>>
>>>>> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 
>>>>> possible
>>>>> modes by hacking the BBML2 feature detection code:
>>>>>
>>>>>     - mode 1: All CPUs support BBML2 so the linear map uses large 
>>>>> mappings
>>>>>     - mode 2: Boot CPU does not support BBML2 so linear map uses 
>>>>> pte mappings
>>>>>     - mode 3: Boot CPU supports BBML2 but secondaries do not so 
>>>>> linear map
>>>>>       initially uses large mappings but is then repainted to use 
>>>>> pte mappings
>>>>>
>>>>> In all cases, mm selftests run and no regressions are observed. In 
>>>>> all cases,
>>>>> ptdump of linear map is as expected. Because there are just some 
>>>>> cleanups
>>>>> between v7 and v8, so I kept using Ryan's test result:
>>>>>
>>>>> Mode 1:
>>>>> =======
>>>>> ---[ Linear Mapping start ]---
>>>>> 0xffff000000000000-0xffff000000200000           2M PMD RW NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000000200000-0xffff000000210000          64K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000000210000-0xffff000000400000        1984K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL
>>>>> 0xffff000000400000-0xffff000002400000          32M PMD ro NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL
>>>>> 0xffff000002400000-0xffff000002550000        1344K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL
>>>>> 0xffff000002550000-0xffff000002600000         704K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000002600000-0xffff000004000000          26M PMD RW NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000004000000-0xffff000040000000         960M PMD RW NX SHD AF
>>>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000040000000-0xffff000140000000           4G PUD RW NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000140000000-0xffff000142000000          32M PMD RW NX SHD AF
>>>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142000000-0xffff000142120000        1152K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142120000-0xffff000142128000          32K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142128000-0xffff000142159000         196K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142159000-0xffff000142160000          28K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142160000-0xffff000142240000         896K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142240000-0xffff00014224e000          56K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff00014224e000-0xffff000142250000           8K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142250000-0xffff000142260000          64K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142260000-0xffff000142280000         128K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142280000-0xffff000142288000          32K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142288000-0xffff000142290000          32K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142290000-0xffff0001422a0000          64K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff0001422a0000-0xffff000142465000        1812K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142465000-0xffff000142470000          44K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142470000-0xffff000142600000        1600K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000142600000-0xffff000144000000          26M PMD RW NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000144000000-0xffff000180000000         960M PMD RW NX SHD AF
>>>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000180000000-0xffff000181a00000          26M PMD RW NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181a00000-0xffff000181b90000        1600K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181b90000-0xffff000181b9d000          52K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181b9d000-0xffff000181c80000         908K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181c80000-0xffff000181c90000          64K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181c90000-0xffff000181ca0000          64K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181ca0000-0xffff000181dbd000        1140K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181dbd000-0xffff000181dc0000          12K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181dc0000-0xffff000181e00000         256K PTE RW NX SHD AF
>>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181e00000-0xffff000182000000           2M PMD RW NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000182000000-0xffff0001c0000000         992M PMD RW NX SHD AF
>>>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff0001c0000000-0xffff000300000000           5G PUD RW NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000300000000-0xffff008000000000         500G PUD
>>>>> 0xffff008000000000-0xffff800000000000      130560G PGD
>>>>> ---[ Linear Mapping end ]---
>>>>>
>>>>> Mode 3:
>>>>> =======
>>>>> ---[ Linear Mapping start ]---
>>>>> 0xffff000000000000-0xffff000000210000        2112K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000000210000-0xffff000000400000        1984K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL
>>>>> 0xffff000000400000-0xffff000002400000          32M PMD ro NX SHD
>>>>> AF        BLK UXN    MEM/NORMAL
>>>>> 0xffff000002400000-0xffff000002550000        1344K PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL
>>>>> 0xffff000002550000-0xffff000143a61000     5264452K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000143a61000-0xffff000143c61000           2M PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000143c61000-0xffff000181b9a000     1015012K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181b9a000-0xffff000181d9a000           2M PTE ro NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000181d9a000-0xffff000300000000     6261144K PTE RW NX SHD
>>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>>> 0xffff000300000000-0xffff008000000000         500G PUD
>>>>> 0xffff008000000000-0xffff800000000000      130560G PGD
>>>>> ---[ Linear Mapping end ]---
>>>>>
>>>>>
>>>>> Performance Testing
>>>>> ===================
>>>>> * Memory use after boot
>>>>> Before:
>>>>> MemTotal:       258988984 kB
>>>>> MemFree:        254821700 kB
>>>>>
>>>>> After:
>>>>> MemTotal:       259505132 kB
>>>>> MemFree:        255410264 kB
>>>>>
>>>>> Around 500MB more memory are free to use.  The larger the machine, 
>>>>> the
>>>>> more memory saved.
>>>>>
>>>>> * Memcached
>>>>> We saw performance degradation when running Memcached benchmark with
>>>>> rodata=full vs rodata=on.  Our profiling pointed to kernel TLB 
>>>>> pressure.
>>>>> With this patchset we saw ops/sec is increased by around 3.5%, P99
>>>>> latency is reduced by around 9.6%.
>>>>> The gain mainly came from reduced kernel TLB misses.  The kernel TLB
>>>>> MPKI is reduced by 28.5%.
>>>>>
>>>>> The benchmark data is now on par with rodata=on too.
>>>>>
>>>>> * Disk encryption (dm-crypt) benchmark
>>>>> Ran fio benchmark with the below command on a 128G ramdisk (ext4) 
>>>>> with
>>>>> disk encryption (by dm-crypt).
>>>>> fio --directory=/data --random_generator=lfsr 
>>>>> --norandommap            \
>>>>>       --randrepeat 1 --status-interval=999 --rw=write --bs=4k 
>>>>> --loops=1  \
>>>>>       --ioengine=sync --iodepth=1 --numjobs=1 
>>>>> --fsync_on_close=1         \
>>>>>       --group_reporting --thread --name=iops-test-job 
>>>>> --eta-newline=1    \
>>>>>       --size 100G
>>>>>
>>>>> The IOPS is increased by 90% - 150% (the variance is high, but the 
>>>>> worst
>>>>> number of good case is around 90% more than the best number of bad
>>>>> case). The bandwidth is increased and the avg clat is reduced
>>>>> proportionally.
>>>>>
>>>>> * Sequential file read
>>>>> Read 100G file sequentially on XFS (xfs_io read with page cache
>>>>> populated). The bandwidth is increased by 150%.
>>>>>
>>>>> Additionally Ryan also ran this through a random selection of 
>>>>> benchmarks on
>>>>> AmpereOne. None show any regressions, and various benchmarks show 
>>>>> statistically
>>>>> significant improvement. I'm just showing those improvements here:
>>>>>
>>>>> +----------------------
>>>>> +----------------------------------------------------------
>>>>> +-------------------------+
>>>>> | Benchmark            | Result
>>>>> Class                                             | Improvement vs 
>>>>> 6.17-rc1 |
>>>>> +======================+==========================================================+=========================+ 
>>>>>
>>>>> | micromm/vmalloc      | full_fit_alloc_test: p:1, h:0, l:500000
>>>>> (usec)           |              (I) -9.00% |
>>>>> |                      | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, 
>>>>> l:500000
>>>>> (usec) |              (I) -6.93% |
>>>>> |                      | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, 
>>>>> l:500000
>>>>> (usec) |              (I) -6.77% |
>>>>> |                      | pcpu_alloc_test: p:1, h:0, l:500000
>>>>> (usec)               |              (I) -4.63% |
>>>>> +----------------------
>>>>> +----------------------------------------------------------
>>>>> +-------------------------+
>>>>> | mmtests/hackbench    | process-sockets-30
>>>>> (seconds)                             |              (I) -2.96% |
>>>>> +----------------------
>>>>> +----------------------------------------------------------
>>>>> +-------------------------+
>>>>> | mmtests/kernbench    | syst-192
>>>>> (seconds) |             (I) -12.77% |
>>>>> +----------------------
>>>>> +----------------------------------------------------------
>>>>> +-------------------------+
>>>>> | pts/perl-benchmark   | Test: Interpreter
>>>>> (Seconds)                              |              (I) -4.86% |
>>>>> +----------------------
>>>>> +----------------------------------------------------------
>>>>> +-------------------------+
>>>>> | pts/pgbench          | Scale: 1 Clients: 1 Read Write
>>>>> (TPS)                     |               (I) 5.07% |
>>>>> |                      | Scale: 1 Clients: 1 Read Write - Latency
>>>>> (ms)            |              (I) -4.72% |
>>>>> |                      | Scale: 100 Clients: 1000 Read Write
>>>>> (TPS)                |               (I) 2.58% |
>>>>> |                      | Scale: 100 Clients: 1000 Read Write - 
>>>>> Latency
>>>>> (ms)       |              (I) -2.52% |
>>>>> +----------------------
>>>>> +----------------------------------------------------------
>>>>> +-------------------------+
>>>>> | pts/sqlite-speedtest | Timed Time - Size 1,000
>>>>> (Seconds)                        |              (I) -2.68% |
>>>>> +----------------------
>>>>> +----------------------------------------------------------
>>>>> +-------------------------+
>>>>>
>>>>> Changes since v7 [1]
>>>>> ====================
>>>>> - Rebased on v6.17-rc6 and Shijie's rodata series 
>>>>> (https://git.kernel.org/pub/
>>>>> scm/linux/kernel/git/arm64/linux.git/commit/?id=bfbbb0d3215f)
>>>>>     which has been picked up by Will.
>>>>> - Patch 1: Fixed pmd_leaf/pud_leaf issue since the code may need 
>>>>> to change
>>>>>     permission for invalid entries per Jinjiang Tu.
>>>>> - Patch 1: Removed pageattr_pgd_entry and pageattr_p4d_entry per 
>>>>> Ryan.
>>>>> - Used (-1ULL) instead of -1 per Catalin.
>>>>> - Added comment about arm64 lazy mmu allow sleeping per Ryan.
>>>>> - Squashed patch #4 in v7 into patch #3.
>>>>> - Squashed patch #6 in v7 into patch #4.
>>>>> - Added patch #5 to fix a arm64 kprobes bug. It guarantees 
>>>>> set_memory_rox()
>>>>>     is called before vfree(). It can go into separately or with 
>>>>> this series
>>>>>     together.
>>>>> - Collected all the R-bs and A-bs.
>>>>>
>>>>> Changes since v6 [2]
>>>>> ====================
>>>>> - Patch 1: Minor refactor to implement 
>>>>> walk_kernel_page_table_range() in terms
>>>>>     of walk_kernel_page_table_range_lockless(). Also lead to 
>>>>> adding *pmd argument
>>>>>     to the lockless variant for consistency (per Catalin).
>>>>> - Misc function/variable renames to improve clarity and consistency.
>>>>> - Share same syncrhonization flag between 
>>>>> idmap_kpti_install_ng_mappings and
>>>>>     wait_linear_map_split_to_ptes, which allows removal of 
>>>>> bbml2_ptes[] to save
>>>>>     ~20K from kernel image.
>>>>> - Only take pgtable_split_lock and enter lazy mmu mode once for 
>>>>> both splits.
>>>>> - Only walk the pgtable once for the common "split single page" case.
>>>>> - Bypass split to contpmd and contpte when spllitting linear map 
>>>>> to ptes.
>>>>>
>>>>> [1] 
>>>>> https://lore.kernel.org/linux-arm-kernel/20250829115250.2395585-1-
>>>>> ryan.roberts@arm.com/
>>>>> [2] 
>>>>> https://lore.kernel.org/linux-arm-kernel/20250805081350.3854670-1-
>>>>> ryan.roberts@arm.com/
>>>>>
>>>>>
>>>>> Dev Jain (1):
>>>>>         arm64: Enable permission change on arm64 kernel block 
>>>>> mappings
>>>>>
>>>>> Ryan Roberts (1):
>>>>>         arm64: mm: split linear mapping if BBML2 unsupported on 
>>>>> secondary CPUs
>>>>>
>>>>> Yang Shi (3):
>>>>>         arm64: cpufeature: add AmpereOne to BBML2 allow list
>>>>>         arm64: mm: support large block mapping when rodata=full
>>>>>         arm64: kprobes: call set_memory_rox() for kprobe page
>>>>>
>>>>>    arch/arm64/include/asm/cpufeature.h |   2 +
>>>>>    arch/arm64/include/asm/mmu.h        |   3 +
>>>>>    arch/arm64/include/asm/pgtable.h    |   5 ++
>>>>>    arch/arm64/kernel/cpufeature.c      |  12 +++-
>>>>>    arch/arm64/kernel/probes/kprobes.c  |  12 ++++
>>>>>    arch/arm64/mm/mmu.c                 | 422 
>>>>> ++++++++++++++++++++++++++++++++++
>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---- 
>>>>>
>>>>>    arch/arm64/mm/pageattr.c            | 123 
>>>>> ++++++++++++++++++++++++---------
>>>>>    arch/arm64/mm/proc.S                |  27 ++++++--
>>>>>    include/linux/pagewalk.h            |   3 +
>>>>>    mm/pagewalk.c                       |  36 ++++++----
>>>>>    10 files changed, 581 insertions(+), 64 deletions(-)
>>>>>
>>>>>
>>
>>


