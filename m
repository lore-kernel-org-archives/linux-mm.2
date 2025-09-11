Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F6FCA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 03:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B2E8E0008; Wed, 10 Sep 2025 23:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842AE8E0005; Wed, 10 Sep 2025 23:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A6D8E0008; Wed, 10 Sep 2025 23:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9798E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:19:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB0E8140277
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:19:47 +0000 (UTC)
X-FDA: 83875514814.01.57796C9
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1C4C84000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:19:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D8q7oZQ4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757560785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpHj+MGARfj8blxvVka264X7OkIxIPNR/vshBaT6dHM=;
	b=cGRr9XzUA/1Kav8DieJ458MhJIuUu9niurlAb5m/C2uXgoOhcVsXUs9wo9yPxNrHkbn7Xy
	HojsCgDZnWpWZ521nlKIC13jGGtPwGdc06rKIYsdc7N5/U1dT3oa/RA3yhOglLov8cx+yA
	30HUCSqlm3QLTKfNFOb0SBDMMGHm9W0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757560785; a=rsa-sha256;
	cv=pass;
	b=EkOckk4NyYFCd3U3m8BIQlzJW1n1s738ppPxWDN3SfCsGX+qswdUB4RAYjDJ8Y+l4BQYdF
	Q3Z7V63Y3oIAzRqRGA7Hv/jKiXclJLmNJ5uYiKNvNNyi7FXQ32EPPuTQgZDMXLJy88QRtF
	u3HlMtUCxY3riAFS855cZLlt9TOh3bg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D8q7oZQ4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wt5Zq6V95rzhWCrM4tMnfEimkwREBQaWdH26xtb9GMG7DbOtfh/DeLAzBMkaGlXhOfRYp8k0phR77jYdco+kmQr+uWz6BNx7s12LNdiyHkz8AmvfYpqwhDXW/NSE41lF//nLmLnaw1TzOK7YyiNgILLl2lJCAO+vC1Gjs2UUTHL+FqSClzt6wIxvF3ihVViZcR/e/vvFHcB3145MjnBgZMKxat/e06VShGHdH3DGflc5o+BW+WCF4RDRfMaLevRCedgBg9OrbmGqyq0PtnozU4XNDP3nJuHRu33qbl3lMTeQNPNuoam08dkcS5ShNFV4RNmPbusIMpHOVeEyD7skFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpHj+MGARfj8blxvVka264X7OkIxIPNR/vshBaT6dHM=;
 b=crqTjQEAuikAGB0v3bkOl3OpFkJE8YLopP20CQZ5SxeI98CK2Xq3S8okL18k1eeh8YdJWP5fyxF0EDM5P0z4jGmY3+OAadMgtasvRxxBJ2qxhMzDj8XPBETYQl340oMpzRRD46OFktK2RLA5QxRa/DhnzN7+L9o/XihSNcKSNDcEg3zFwpJuM26ay60XqM458dUmaqnj83yQpMPDlXhzbGxaqr6j7fwDrs17gu3y4LiBDGW/NYVlFq33Yc2wsDH9d98sDdaRJE1X2gAoBFT6E986EGxgCyX1LChGuix3OLAlxOmF+l62z8+97RYt3ZTgdR1luypYl2Z9T8IcY1OVWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpHj+MGARfj8blxvVka264X7OkIxIPNR/vshBaT6dHM=;
 b=D8q7oZQ4SFUZV7YLNXtmj0Zqk6z7YPNVjqqIhLMwwyfWTRX647MN9avQK08WlV2nPU6pChLp96ZCt0smYh4E9SgbrpkxCMg50CJvVhsJ2of9UIjRNJi+Ny14+I74WgqybydpHTSjfoJPhimUud6LUORBpivxcDO9upxGM/+GvX/RQom6GAEOC21K1uG5bNwTwfImmq+0kju+PD9CyIEwyTyUrqThMTgXwouUR0XD23y6jfluGNET8xjMzCNndSiIWk0D5KhYWM/VTyFU7M6jbcj0YWFFtMY9VQh7Bd+4CP1LLjrJGJHO57WmxSplmcpuXqGHgodH2Kk4P0nKucL61g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7208.namprd12.prod.outlook.com (2603:10b6:510:224::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Thu, 11 Sep 2025 03:19:42 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 03:19:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Zaborowski <balrogg@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH] mm: avoid poison consumption when splitting THP
Date: Wed, 10 Sep 2025 23:19:39 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <9CD4E5BC-185A-47E6-9A2C-1B5416DC57EE@nvidia.com>
In-Reply-To: <20250911021401.734817-1-balrogg+code@gmail.com>
References: <20250911021401.734817-1-balrogg+code@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0016.namprd14.prod.outlook.com
 (2603:10b6:208:23e::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7208:EE_
X-MS-Office365-Filtering-Correlation-Id: 07acde44-b81c-4251-949e-08ddf0e20c61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cC9sSW0zTGZ3YjA4SFhLNTFEZkdUWFJoQ01pYStqZm8wcVBEQ0RJeno4TndU?=
 =?utf-8?B?SVBOLzBIa2xWYVJTS1IxQXhIS3JKNDhtNWZnWTNrejBQVE81ZEtHTHhFRy9y?=
 =?utf-8?B?cEtLRU1Za3RGM1lEVUlTMHFXeVFHVmdHOGpreVJ2cEN2Nk1xR09ZUFZkdE4r?=
 =?utf-8?B?ckJzazcvOEZpZGVlWDk2ZVRHa1dMakcvNW1mRDk1UktGNWJlckVQQ29Eb0Zv?=
 =?utf-8?B?bUpwMEIrSFBLWmQxQVNxN1JYNHgzYUsrczVleFFET01ydEN4UzBBUUJUUnFv?=
 =?utf-8?B?SU9zNWdWRHVvSnhWSHJHQW9lWEtaZFBlK0ttOTh0RGpNeEJrMWFmTTFGc2ll?=
 =?utf-8?B?U05pWE5BZlJpcjlPN1U1a1IvZVh4MVV4VFZiakJkZGZkVy9OY1ZVYkdRMUhi?=
 =?utf-8?B?ek1NbWRGMXArNWxBTkdxWWJQaU1OMGlxYVBSNGtZbGNXVGpvUzBmVWlhQ3VZ?=
 =?utf-8?B?Vm5RV1FUYnJTNFdLMHFybnFDMzRjOG9ScHVleXV1TkV2RUdIS2lhaDl5U0dl?=
 =?utf-8?B?ODFLK0VjMU8wbzZPUlF2WEd5cUk1NnEvb25NdjYvd3VBVC9hZ1ZSalUxNXBq?=
 =?utf-8?B?Q1hZOW5RcExtM3RRZG9GemhhTWtmL2I3QjdjUmNvWktTZjkvc3hZb1BRYTgz?=
 =?utf-8?B?eSt2V0Y3MFJQY3NnQ3o0NVUzL0JNRW1SanplWmFMeWlOSTM4bjBubm9NM01a?=
 =?utf-8?B?WjJtbXEwT0FNS3ZSaFVTTWQ5UzM2NUc1NTYyalBPU25uZkxtZFNoUExvazFY?=
 =?utf-8?B?QTUzOERlNjBBWi9hcTUzUFBlTXF0UGZJS0hrRE5WelVsZmIxTlBnNm45VXdv?=
 =?utf-8?B?OStJLzl5NlJDV24xU1B6Rk1xU1NMeVJ3bnpSY1drOGE0c2d5U0d1V0t3UHB6?=
 =?utf-8?B?UzZ2Umc3YWhiRkJJeStZTjlEUnQxR3JLOVliWVVERFFnZHVPeGJJZG9Ma2k0?=
 =?utf-8?B?Slp1a25Hem04RVNZWlJ0Uno4OHJyZm14N3UxZ1R1aHdSenRuTkVwNjBhRHVr?=
 =?utf-8?B?aEZ5YVFvOERTRW51R1lrM3ZiaUdXd1U1d0g5cGxjY2FIUHBIVEZUSkNlcnpM?=
 =?utf-8?B?Slpwc0FrMnVsQ04yeitOWGFPVzV6eU91MU8vVlNFRk05cmVwYTNZQlcwNllQ?=
 =?utf-8?B?ZE05WGNTMmFUNEdhbk1aV3JXd0JJMThjaktGZmRaa3crNVY0ZUtwcUpWUlZ6?=
 =?utf-8?B?Um54VzNsTXlQMjdmOXJDZFNIaHJOUUdncGZ2akg0Mm5SKzR1bEZ0WWdCeld2?=
 =?utf-8?B?K3ljRWNDam5wUUw0VUI3OXJUR3p5dWZnMUVTM3hFWWdlNUxCT2pON3BtN3NJ?=
 =?utf-8?B?bVZwSWxtVmptaERuOFd5N095RG03UStYVDcxcmpGWXRKc0NsZ2QwWlFMaVlm?=
 =?utf-8?B?Z3Z5RXBlaGVka2NoUE55bzFFNHQzVXZTUHgwZHMwTFk4d2dYb2FmcGtMeCtU?=
 =?utf-8?B?VDRtYUUzNVlMUmZHRTRLUnlVK3c4S1VDUjRDL3Nkck5PU2Q2eFdGcmZSQW1I?=
 =?utf-8?B?dDRsYXAyNlN6YU5sZS9Pb3o3SzNMbEZ3c3UxbjBTak5CRG0yVUo2Q24veGZt?=
 =?utf-8?B?VnZlRnp5TGk2Y1NCU3lFQldpT3dPaWxyaVRKUjZyUkhXTnFheHZzVGJielV2?=
 =?utf-8?B?UXZmMktmZU81cFpPWTdvaXA0OTJuVWFKUkw2SzlDTk1yaEcxMjVjRXZCWGpl?=
 =?utf-8?B?aHU2WFFuVGNjSDA0cWgxbUxCSDhqMnlYOTVoaDFtQUFlUlc3cHlYWFNTVGg1?=
 =?utf-8?B?MzdJbjAyRUJNM1BlbGNmSHVibmVhc0o5T3h1Mk8wNVN1TFdCTHp5Y0xDSGpQ?=
 =?utf-8?B?dFdmYnJPMmZUK3NwRWlQWlJERmhCSVlCaEVpWUtRUks5SE5OZkk4Q0dNZHhY?=
 =?utf-8?B?Y2ExRTVHdEcvVVo0VVpqa05ydm9PdWtsV0RWbzVsQ3pLV0NwUk5nTk5ZbFV4?=
 =?utf-8?Q?xsvQ8iRcmYU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUp5T2EwNTB2MVVEOFNrRjM1Q0ZsOXUvRGFSVG1QY1F3SFJPcDNZRW5GZmlj?=
 =?utf-8?B?QXB0YkJUc0RRRkVvL29RV3JsOTV6ckx6ZklkWVFEMnoyR3JqQTJNQlIzMU5w?=
 =?utf-8?B?ZDNsRjVvYmJwYU83WFBZOGVqclVhbStPNUUxaUVUMCtkUFFDMy9GUTRIczNK?=
 =?utf-8?B?TUNJTEV1QlpXVFJDby8zWWFTOTViZ1lhS1VHcGpLSDY3UWsvTkkwQ2RYOWlz?=
 =?utf-8?B?OHNKc3kxbEhJVFRoTTlSaE5FNXlTY1VYTzFqaEk3SkdoZWlobC9ibkhyV1lJ?=
 =?utf-8?B?L2pLNGtpZTlBdEhyMUdqb21nVnNkZWdBN21vMGhRZks0VEg1Yi9wK01oNzZi?=
 =?utf-8?B?Rlh0QU5saWxSaklCSGxUSGp2dzhURnhWZ1ZsM2NFREk1TDFKTmlIMGFXRU1x?=
 =?utf-8?B?dG9vSStoNCs0aER4YkltZ296eU5xRmErbkhiVUFMNHR1WE5IS1FyZEVvbUtM?=
 =?utf-8?B?cDN3bkl6cWZyTEhESWpvTC9Da0JTT1dYSWRjK2l1a2lOK3FzV3ErZzY4ZkFT?=
 =?utf-8?B?Y3dnVmI3SkRRQWU2N0pvdUs2U1lKU250SXQ0aHpMRWs5UU9ETGJFVXFHcWtN?=
 =?utf-8?B?bFp3eThIUm1kWGk4Nm5HbmNWbE0weVF4SWdWNFduUGUzRGV0WGo0TWlHOUVs?=
 =?utf-8?B?T0NLOC9wenlSMm5VTjkwNEFkTFZuWVloaWdVcFlaeGRqam1lQ0UrbmFJR2ox?=
 =?utf-8?B?VmpQS2lpakJMNTUxRGwyeHZuSHhKS2NNWUZ2L0pVK1lUNCs4U0tMV0RiME1Z?=
 =?utf-8?B?bUxSZDg4TW1iVHUydFdEV2J3cmhsdmlFaHFCaHdyclpWRUZPclArM1RDSlNu?=
 =?utf-8?B?aEZFdGRwZk1uaXlXMWk1NDY1L2Y1a0NUaGNZYkFORzc1dDBlQkR4dFdVRlhG?=
 =?utf-8?B?YWZBUzlibUpEeldGYTNES3pFN0hseWhvQmtrbTRMRVpiWnJSWWMwTGlvQmJK?=
 =?utf-8?B?OU0xSkc5NWVkVVpvNWxsWktDQm1KWTZKMVY3Y2tWRlBsQ2VlUitGKzVBdktB?=
 =?utf-8?B?cE1ydCtYQURqZXZ6MzJ4VFBVbThJRUwvTWdKMm9DU2Z2SjhuaWduUGRLdmFn?=
 =?utf-8?B?a3RlNitFR2hjMU9UMXlPMFJJSUJqRzJUOHgxdXA2RThzZWxNd0sydmdVTEdK?=
 =?utf-8?B?RWtBRWZSZDNUTEk2eEJFSGRJOGJVNXk3aHpWWndvUWhPa3ozSXFsaC91NWFS?=
 =?utf-8?B?dmtkUDgxSndOYUNBOXZHbDBjcHg4WWpCTi9YWDBWZVYwV0Z3VS9ldlM2UERC?=
 =?utf-8?B?Zk43dU1hUmlVNzRXdW9qQWRJYXNRZlFnMlZiVlozdnlsbE5KSU05aHNBRjNl?=
 =?utf-8?B?Y3NZV01KSjVYZG1iVStoUHlxU3BMdlFMbnhBNi9FK3hhWkdrWUh1aUtTbVJP?=
 =?utf-8?B?L1RkZGswQ0lTbUluOGxNdUg2WU1pUEg4WDcrcllWbTZZaHhLVUVzendGOC8y?=
 =?utf-8?B?SE52TG02OHlNcy9XMElpWnpJV01tdEZiTFBpOWRYR0xTY0E5bHZuaXJyUXFH?=
 =?utf-8?B?ZlhaSzZna2RjVGlwNkxOTFpqdytJcWV6Yk5QWUtISFB2Q1RvREIyRndUc0J6?=
 =?utf-8?B?QTVVanhvdEtTcFBnd0x4Z1p2TmRXRVltdjhEUVd2Umk3QmdlWEl2a0xaMzJ6?=
 =?utf-8?B?czR1SGZHWjVOa2ZCK1Z5bnlKK3lyOERsS29kcjFaYmdvMU1zNFJybjlvVG5Q?=
 =?utf-8?B?d3VrYVlyem9NcC96K2k1OVN1Y1VwQzJJcVJtdk5vZHpMZGhRTlBEUEFUVjF4?=
 =?utf-8?B?UVR3VnVKSFhsMnNOamlwNHBkSW4ydmVQS05DSXFJQnVlVHhIS0hEdURDWlZt?=
 =?utf-8?B?c3hCcE9TTEdlWnlSMThUN0xLdXRlSitSWGtXM0dBQUR1d1gvSXVPZjZNRXVt?=
 =?utf-8?B?MTZ3SGhMMFhyYXBUTXZaU3krYVRHMk4xZjFpUUQvcU1tNjNucnpQSmRDR2xO?=
 =?utf-8?B?U09QcEtsVzNKREY3TkJaYXdUYVhDNjhMSVlJaG05aEcxSlc3cCtXOFF5ODlU?=
 =?utf-8?B?NjFCcFhvdFJrR01TV21iZWxyS2hDWnFNdFBQVzJYdXF5TFprQTc1TkpOK3pr?=
 =?utf-8?B?azJ5YXZKSHhFN2xEYjNVbkt1d3dWa3BjSDcySFBkYVl1U05oc2xEbXBTeXQv?=
 =?utf-8?Q?7uT5Joc31MlIMAQ5iL4p3G+6k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07acde44-b81c-4251-949e-08ddf0e20c61
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 03:19:41.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYnDe6rpNueeXYIK7wA+cJm4Abg7dfXoJnl9Jfj/FV2rJWRuSKD1mHm7b3rSUR3i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7208
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C4C84000A
X-Stat-Signature: pyb9dnhjhzm9xw5up67hjzd84der9z6q
X-Rspam-User: 
X-HE-Tag: 1757560784-304085
X-HE-Meta: U2FsdGVkX19b4LC69MXMNvWpnvthoSEq3WQWjECmtVy7iEjjFl1/08PZHmu2U52UNdg1YZD+iwUcoKCaSbN5ew1ZmfXll3q3W3XJPGxzM1rLHb8KBWuX8HPxPLjBGAi06fSvRf3axkM1MxoVrUsXI1XnzOXIn4fTDNsRx63aVVrf7GrkpFXbcyb/ydtOMNJulabKlHk72C26vzQQ5ecK7ZT1jSx5pqDXOoKkkiLpoT8F72nCXoWPl6dJXh/g7R+dMVGPxQldbVqEPnbV71KyB00DoE/EAClXBahIxMcVPoZZNPJO1rIdgbzYjFO370TXSwPcyxjE4l53rHcmpKgPNLfEhLYPqUgyLC6UKrfvBBvflHahKvSBJZiihDjRn7nwt0lob1GaXQIfBQSH/pzsKw/Z9I4eq+G8ksDVESlDTqA4XOWCYLocO/7NsXH8JQ5IBLPhQvq65c7NzlWuaWNRc+4JhuOUf+6+GcvxrxUvPL+qbqTKwc5p6BlR3i5f3GcTfmIKjocS0xzoFyVeJ+8mYcO3b8RqsC4+uemNVWz5Z8v/552bqPsaBlDc7WPC68j4QPZDV5YWXNrn2mqlHWk8OY5i7Z/qc5hZr2mp8m3q+bdRNeCNu2d/itXdhkdQ8/nWGk/aoZUsTGqbXIfgbcmDAWsWkCbopbT95qi3WrTt971Ul3JsI7JtolummhK1CT3Zwz0YDZUFGHjCgNaWSncPeVyzv/TXOYytsN9b0csN38Gg4001TfbEWKDzYtfTT3CfS2xMLZQsw+ZMWC/70ObIwVQ4hv2jkOXb/HrIuMMtOayOR7uJfU/FfGAK3dOhm61eJ4I9ojo2UHt3vcz1JeBfl6Fltr3y2WtuN38m6UcCX8+jUvpUt6feXRv+0Zpf+NOpB7pquYRAfGxfNlXRWxTC30HvIpnZwaYYgyXRpCRrMCYh+OlhRXzspWMj7XSrpI/3MGpzSyXIGzCJxTKb3RH
 5ih3onA7
 NXleG2zGT5fyjpvoNQ02LEPpa/yS4VTYmd7oivZgpC25Csikrv/U1xPoscpcxC5vzlNme4QLEOFbGCUzsmEIFU1p0oBbMh0oVU26oZXHTkzbJutEFLAdgihukMKEDvaN72ZANNBztnS2+/Ydwpa/IACOXoCvoQGrH0lDVS2vn2ZGdHBs+6eVyu9bD4XwGuXULRCQPb5HSVCzIyCNK12YAFsb6k5I/KfofT4e3lp4zhdJQrrAY2z/iow+lj4aTPJ9K9FldOuumeF6XStalgBCu4kU4YRrj4xyswWxP0AieUx2tb2AuFEPhWKF6lhnXHT4O/zSdgwe1asHeM8oNYVII1LSbaUHnUaPeIR9ytp7zSm8DYTr0bR0QklPhEiJCfiLi6Fthi5EMfjCwq7uhM52Ppeu1uCP0bOlOnSiNyyViyQEpnYqcAvd41z5iynEDYie1rr4ueXK6jA8ko6Wa6Y0S4P0WwNi2tuG+Am1FmXF5cE7We247m7I4nK09i0W2F7la2leg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Sep 2025, at 22:14, Andrew Zaborowski wrote:

> Handling a memory failure pointing inside a huge page requires splitting
> the page.  The splitting logic uses a mechanism, implemented in
> migrate.c:try_to_map_unused_to_zeropage(), that inspects contents of
> individual pages to find zero-filled pages.  The read access to the
> contents may cause a new, synchronous exception like an x86 Machine
> Check, delivered before the initial memory_failure() finishes, ending
> in a crash.
>
> Luckily memory_failure() already sets the has_hwpoisoned flag on the
> folio right before try_to_split_thp_page().  Don't enable the shared
> zeropage mechanism (RMP_USE_SHARED_ZEROPAGE flag) down in
> __split_unmapped_folio() when the original folio has has_hwpoisoned.
>
> Note: we're disabling a potentially useful feature, some of the
> individual pages that aren't poisoned might be zero-filled.  One
> argument for not trying to add a mechanism to maybe re-scan them later,
> apart from code cost, is that the owning process is likely being
> killed and the memory released.

Sounds reasonable to me.

>
> Signed-off-by: Andrew Zaborowski <balrogg+code@gmail.com>
> ---
>  mm/huge_memory.c    | 3 ++-
>  mm/memory-failure.c | 6 ++++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9c38a95e9f0..1568f0308b9 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3588,6 +3588,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  		struct list_head *list, bool uniform_split)
>  {
>  	struct deferred_split *ds_queue =3D get_deferred_split_queue(folio);
> +	bool has_hwpoisoned =3D folio_test_has_hwpoisoned(folio);

The state needs to be stored here because __split_unmapped_folio()
clears the flag. Maybe add a comment here to prevent people
from =E2=80=9Coptimizing=E2=80=9D it by calling folio_test_has_hwpoisoned(f=
olio)
in the code below.

(I wanted to until I checked the definition of folio_test_has_hwpoisoned())

>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>  	struct folio *end_folio =3D folio_next(folio);
>  	bool is_anon =3D folio_test_anon(folio);
> @@ -3858,7 +3859,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>
> -	if (!ret && is_anon)
> +	if (!ret && is_anon && !has_hwpoisoned)
>  		remap_flags =3D RMP_USE_SHARED_ZEROPAGE;
>  	remap_page(folio, 1 << order, remap_flags);
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fc30ca4804b..2d755493de9 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2352,8 +2352,10 @@ int memory_failure(unsigned long pfn, int flags)
>  		 * otherwise it may race with THP split.
>  		 * And the flag can't be set in get_hwpoison_page() since
>  		 * it is called by soft offline too and it is just called
> -		 * for !MF_COUNT_INCREASED.  So here seems to be the best
> -		 * place.
> +		 * for !MF_COUNT_INCREASED.
> +		 * It also tells __split_unmapped_folio() to not bother

s/__split_unmapped_folio/__folio_split/, since remap_page() is
called in __folio_split().

> +		 * using the shared zeropage -- the all-zeros check would
> +		 * consume the poison.  So here seems to be the best place.
>  		 *
>  		 * Don't need care about the above error handling paths for
>  		 * get_hwpoison_page() since they handle either free page
> --=20
> 2.45.2

Otherwise, Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

