Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EEE81088E62
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 02:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997AF6B03AC; Wed, 18 Mar 2026 22:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9703B6B03AE; Wed, 18 Mar 2026 22:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836F66B03AF; Wed, 18 Mar 2026 22:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF576B03AC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:01:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E9571A02D9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:01:01 +0000 (UTC)
X-FDA: 84561159522.30.DFC3389
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012029.outbound.protection.outlook.com [52.101.53.29])
	by imf13.hostedemail.com (Postfix) with ESMTP id 100422000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:00:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g3fznfWu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773885658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccsi1tFmo2oZRsz+421WSbSa+ISMBOxctS36oMY+NKY=;
	b=tbeqEuwypLS/3Fz4sV5P1pLoONAbYLv5Kkix4PHonuFaMv5Uc1OMgobCf8TKw7YHDDVB8k
	dhMBML0+evBRlQVBV6ho2qW7PZ5H5jpuvRTSYVrcn1JeW0ry6eGTQ+NZ7IR8lT3Lmn5hSP
	+9jcoAKOkpDGpuVaPu/lXaD1ypx7B9o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773885658; a=rsa-sha256;
	cv=pass;
	b=aYKXcGCzSxKrWMN5MfErYSH02xEpmKqBT+B9fdqSBYk8JpPdB/Qw56dVlj5LwX0z4WfDWI
	mPkckvI2CriJqXSvoYGlUPG3uIyaLez1KOS+Q8ohFgbDGy3jidNG8SpgVQcKnJGUHsfLN5
	NurFL32w407jw84ZcTnZcjtwR5h+FnI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g3fznfWu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GB22GQS0Viuh0Q29jO3glKX4hZBgbh67yWmhpTZd1PTceurnJ3lJ1iGvuJcqR3tt7S4EwBSLK/fIfnpoqaA7efpKgBzVR4BuUmnm6kwaXjjtFd0Tiq3zhcCDeNbKwxiFE4oPK2xvhzckrsWZa6m3nbIOiOMBFvD24iBuoZlwMmhRzax7IUWlWMrtQtMa3FJIalxiLO0dms9aQu1y0D0Xnk1L4KOP5srZtuqevnPoNgaH8ROsoSBoeeblKhDC9e33Rz92Ss+HSJyfc4iZDOFYmco2C1Yg6x2yB9MYjeQ6BWGj8XiJ8Fnwt48gXOA7Dfj7IIN4CWLdMS4buCXo8jRrQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccsi1tFmo2oZRsz+421WSbSa+ISMBOxctS36oMY+NKY=;
 b=gG8tMaWHZR+spPxjfUdkirhnKTFW8JGk1FqlxhFHgCu3sL3HHXBfr+W+kBAvKT8HViRTuau6kYZhUuIzpUxIyKk/UEbXdhDlQi1UQm35qyLUv9WCXkYL0hnYZ7ugCxCCKmhCK8pN6yWi0rWn13f0eT4l0QjwhplES+e04Lf1+VOJzThmFQeDEspFzt7yg3Vn8HtfW1KtAWEO+zn4M1nn//3KSDc7h6UngpdMQBLqcKRqfNaaZHvvcK5xhHnS0E5lSggAMmtfQ7zdQ7h6BmX5kb06eqyR4LzT1FXSwoXkzR+m78p3cwPMmPz6U3mts+C2VrtmQ/p+yFoV7KANvel84w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccsi1tFmo2oZRsz+421WSbSa+ISMBOxctS36oMY+NKY=;
 b=g3fznfWu/Co79Rr+Rvq8/NLFZBKUHrZy1nP40+0/FiFkMmnLeDZWrMUx4dOkqLy83av8Xbz28JI7RcHkWMK0CKjz0khwXpg5KApOEsNCmK1kl6Wg+v/Nxa7MBD30+fbbvPQvRMoW6stHS88HlU1pWqhWCapBMKX8vGGawyUpI6zTKrVa3gkTlonR7y/3uWMsF1s+KQGMOSyYcf9wjbsPbIsKve1DMKAF8zc5rhDjUtVxfWA0yijlBK8WTEqTHLs08Xo8IEdbwm4xWE6SvQ/yxaNmQMssx8cO2UgkNLKG466g7xjewNXddKs/Tte/QbKO0bMrpzWxXQNUXUNgxlBkhg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ2PR12MB7895.namprd12.prod.outlook.com (2603:10b6:a03:4c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 02:00:50 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 02:00:50 +0000
Message-ID: <9daab5d7-28ac-464d-93f7-13f965653d7f@nvidia.com>
Date: Thu, 19 Mar 2026 13:00:45 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: running mm/ksft_hmm.sh on arm64 results in a kernel panic
To: Alistair Popple <apopple@nvidia.com>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 Jordan Niethe <jniethe@nvidia.com>
References: <8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev>
 <3f58a6f6-bf26-4c6c-8bc4-c05264ad0cc3@lucifer.local>
 <abtUZpLOSaSMAkCK@nvdebian.thelocal>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <abtUZpLOSaSMAkCK@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0190.namprd05.prod.outlook.com
 (2603:10b6:a03:330::15) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ2PR12MB7895:EE_
X-MS-Office365-Filtering-Correlation-Id: 79d71c75-15c1-4914-d41d-08de855b5879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HPDa/0TAtK2rrKTZaPEVilPSAnsrOMNjU2U8UNOsAiNbmrO5tn35j9RsSTQCJzwVvUdCMcz/bfFSQo/Lx2Do54gZmnDY2Ppn4pHhKxxQ+/SJ3Fo8//m4JpOaX2c3Mm3IF906doeAiLT+Gvshd6oW4HurE1WxJpMA+q9hVRo+zCCmpXh8ld2m1sB3VTuCUOEGHtZT2aCZrR01sWAGoNcR+UzZ2rkFclodRErNODOq7HTHOfOMrzGooeKEvwu+tdTHQ2u4SFqhlUHa+JHIsk31FdhIKHBVkbC0Lg+nY1DN8Vue044jqseIF93xA6Y+IKmCrdYUtbf4/hYaz745sGfPIkmNtVHUFxbiSyGvblbhnmckzvYNftJ3Vy6kvts2FMQbAsOAOmvhOnbUkDCoJXsVFXTJ1ms1g5vmaPDkhwpj5QRgMf/bfSvshIeiNQM+jUiYwyOLzdFfuVtOYHCQK0VajctSm+ENUvMgCSjKktFB/kvhTAr8Csx/mIjK2ycx9BNbs5RZiaci6dwbQCu6+MCmyod7k493G2qU2KPjdSg8U8lbJGMU89eU+g6uTsViR3N/FAsmgUZRdOmaA2JWSzrPxgXuNdAt+B83NXb6D0lHQ3fNZ9/dloXNRHxCsUHUJnE19eMVep3pG8hdBf90L3d/D6aMABWcZkjP5krE7adt9lt2uEv9u4Ez74WpqF+xt9mnwBoH638p3IiVc+Hmu6weCYJRT/7XC5HRW7a6yJL0Ai8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0JMUW4xVTBSamViL252T0pyZzFJQUlxN3I3RjJ2d0tmZnN4dXpyait4NklY?=
 =?utf-8?B?MmNBQnkyanpEdWFJNXNFdUJ6VVcvcUwza0dqdHk5eU0wemlGRkF4WGNrNkNx?=
 =?utf-8?B?eVlyNWZDVXpDYjQ2U2RPcFVGbTdZcUZ3SGppT0NKcTNFWlhWblRmdm42Vm9k?=
 =?utf-8?B?OHROU28yUnVaWHZKTndHRE5ibnZuOWpWa0tybWg3SUVXV2tFY0h1RDhLT1g5?=
 =?utf-8?B?SUtGMzFqbHBOWFFBMFhJTDZBUEdPdkswc0ZoVFJVblVKSGRObXpPMmR5Rjk1?=
 =?utf-8?B?L2dxTVBRcVNkSDQwMElaTUZHY05XMXRxbHg5YWRTRHlZR0VUczFzcE1CSXVh?=
 =?utf-8?B?NGJWOXY1aHRidkRrOG52d2JDLzI2eHJnNUZwL1NwaG4rY0d6RE1OZWcxS2ps?=
 =?utf-8?B?VWxCYThhN2d4OEd2SlNFV09BM0F0ZWRETGZYM3EyQlFlb0NRTHhGdnZSSldt?=
 =?utf-8?B?aG5kWWdWMkE4cW1ESWxjNUh1NjFWem01OExQdXNFbHBCWmswT3ZkdlRjdUZ6?=
 =?utf-8?B?c1NHMzR6aGxCdmZlWXd3dG1wZmNSZWtNQVRBSmF6ekU1YzBDRy8wTWRkeHJr?=
 =?utf-8?B?a2d1QzIyalZpOEcrM0dXK1U4NllLTDVySkFTdTQvaUdEN3NHZDZ2YlF6L3RB?=
 =?utf-8?B?UmNrbmQvaEVXd0kwQWtVY2FWUW03TmM0VjF2UTZyanlSa0RRd0Y5M3VOcXBC?=
 =?utf-8?B?am9Eblp0eUhJbUE2dGRlc21NcHFaOHZNRzJHTXpnM2g1NFBsTkNVQzRHeDFt?=
 =?utf-8?B?aVJsNUZvb3NGOS9kQkNnclFUY2cvMW0wM3RIK0tCdkFSZVNmTno3elJaeU9x?=
 =?utf-8?B?OXhRU2ZlY2ZxQ3JpNFZOaWlNVjNQak5XdCs3RkJVTEtIRlRwQ0VDZDMwY0pk?=
 =?utf-8?B?VTZiUWxIS0ZwSEdmQ3pkei8yUmx3TzBLM2NGTlgrSFUvZExjTGRHRjZHV1l5?=
 =?utf-8?B?LzcyZW5pT3IzVndTUWdoNHcxd0tpb3VkbFJ2WDd6Vmp6TlVaY3BwYjlGQmtX?=
 =?utf-8?B?SU9NUW9BTzJXM21TVkhQTHVTZjJLR01OelBFMXl2Z09rV2tjeFJZYzdjYTl1?=
 =?utf-8?B?VXJrRE1iZTJFY0ozYXBWNU5ZWkNhVloydVpuM202ZzRhWlBEL09UNzlQdXZY?=
 =?utf-8?B?SlVRZkxoZm9mVExxOWk5ZDdSWHpudXN1U2U1STk0L0dTSGRrQ0Q4Rzh2MEJh?=
 =?utf-8?B?emdzK2tIaWlINUdwOFF3WHR5ZE1abDBSNFJ2cHh5M2hSMEd1MUZaYzEvb2g1?=
 =?utf-8?B?SjFpUi9VUGdGbGt2WnVoaVJ4cXdaNWNYRlZlaGVlbVQwTHpzZ0l5RUZuQ3FB?=
 =?utf-8?B?WWJBQlJ5OGhEeC9jSlovMGZPK0JFaEdLeXcyUUtVdmFQR1ZGVXpzVEVNRnFq?=
 =?utf-8?B?NWxDU1c4V2lpMWhUZEZLMTBYV0pyMGpjMCt3NFJYRFMwTENJWkFFbEJyTTdv?=
 =?utf-8?B?aDJRZ01xOGsyWi9NSkhlMElGWnlaNnJBQ09nalRoVjVBVEJpTlRMVnVlczBp?=
 =?utf-8?B?RXphbUU2Ukp4QjluZkJ0RjdlUlVLczZoR2VwV3dSQ0ZNUHBMbkh5MU9FVm54?=
 =?utf-8?B?cGE1ZEZDWnR5Y2tVNDI2cWo3Z3ZzbEhhK1lZUk5FRXZEcUYrZ1g1WkczMHlR?=
 =?utf-8?B?VnZCRWNWQ1lWL3NMeGdzckxZdzNZZVpPSkIzdzJlMlhUb1lEc0V6WUVCS2NT?=
 =?utf-8?B?dTIvRTRSK0RZeGtLSUlVZGdSbVU4dGpnd2xJMVJhTmF2SU9UN2JQeFVkYWlP?=
 =?utf-8?B?Wlo2Z0VtL01BcS9KK24xMW5lVnJXYlNSZlBSTlY1YmVnaVFaTlpUS3JoSFYw?=
 =?utf-8?B?elAwbFMvZDg3T0ZLWU1CbjVTUXAwWXpMdXVHWG1nOWxyNTlNUHZXN1VXQXNw?=
 =?utf-8?B?L2ZNTlFqbDJVSEQvOGRlVGxVM1hKc1lySG9aY3VqL3BQR1JkQ1c1SUE5eGdX?=
 =?utf-8?B?TWpXR0NSMFlvZEVxNERBOFMyQjhYSEkwU1FkU1c5TmdmU2hUN2ZHeXhYbFk5?=
 =?utf-8?B?cmxGbWlRbjF1ZlREbTYvd3dWSHhCUUdYZ0E3bFZLVlYyZktjR24wTCtaRGg1?=
 =?utf-8?B?RmlsMGRhbVovdDhqYVRHU05RV2xMWTA5QkNHYVNML0V0Tk9tUEc1WDNxZXlK?=
 =?utf-8?B?ellJSnFvalBGeXdlV1hMK2tzeTArY1RtRTkvR2tXdWVyUnlPa0dPWG80OVhX?=
 =?utf-8?B?U3hadU9UOGVEY21yaXJFUnNqTXlWeXdseGNZZmFjZnFIcDhkWmJMQzI3alB3?=
 =?utf-8?B?T2NKM3ZrTTVlSlNVOXZGaVEwTUcxaXRCZng5bitaTHVydG1GbUQ1WU9QK0do?=
 =?utf-8?B?YnBWN0txa2RQMXp5OWpyUXh1UExJRzZWekZ5VDdBZGRXV1cwdXdhdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d71c75-15c1-4914-d41d-08de855b5879
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 02:00:50.7141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbkz5pPWu3yEWm+kHWNeYjYov381A0AplZ2OapskmY7ypqfZPJVJQLZbSP+tbabYbmtUTUiJYu3g8zWGEvQclw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7895
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 100422000C
X-Stat-Signature: 8peebsn8idhnjc9su3q4e1asx59pzcj9
X-Rspam-User: 
X-HE-Tag: 1773885657-630498
X-HE-Meta: U2FsdGVkX1+0y8lf/DBCasTFrE2LEn0d09KixOxnpJr/l96SsLUFG4UHMQYOFtpHv5Db33lv8Hu/LKejzQ1v9SDdVFcNNWCW9WQlGmyl+xFogXsrShQq1ag1fPxPz0pqfD9OjE3B66w6NkAhE8rUMSiluIiuEtLQh13rnJWN8uWRglR6x/WkSV9FoO+PBLQ+K39uD4rnPCFiyakFqhA5BiQFCyx44B86+9wzHv7pdNLCanllWqguqlk/fJxdYgh7o62JuhU4YJhivDx4X7qxnmP2FpftgsT02xqCsk0Z0xHhfGUjOhNNM3crhhPQWpSlbKwCIBTmCtiPPq+tHoR1GTEcvZd3VZqDLXJLOfynrpEUeIuRqoRnWPYCBrLG39qRLj/d6KSs6ZxLnzNscp7YHAaOqU7Kn74qvM8URkLOBpT+C3TfUfi2EpncNkahrUWvVJUdBCtcGJgDT/3UUPxjNHLJZsv264W9yfzMmpXuEjHHocuL5Uc8tCAfcsE4tjRsR1eNZiYyjfILy3fqkT+axz1ImatSNyz51+51+DrF820a9dqmYnVMYJbFa81bOTo+jNgi1AeJuexecZeO7Hy0JI/Pyl+h3XB4kBYgYK3/1XSMPuvPclR2lfRfBBJUwfESYIzCVXWIDBbqR4+1PaR7YFGsB1wiHdaN/3O0wl+UAel1PL4mNRphP1ividKoM+TlFQTTTIld+naBCf5vhjMj0Db4dmaNsZKl6Hvzu5HQrRsWKvWq6rYVDqw0Hc0ETP0cLxOC0cMfhS56Jf77A359b/afP5MyfC2A6ibeK7+3iTvz5e5NjPSp/zaD2oL2yKRtC9A3rerLrVlWxuxyE4/aC0GDlkv3yH7McOhqFa7Y5U5nMpNpr1wfWrSCW6gKdy24/s9mgO9sCP2ZoUDF/GMKA8Hhk5AE2XVhytY5/D+JJWgsD32Z+7UlC/1RvaEDJf819P5lbU8Sr62i7kERaN+
 P/2ZmFxJ
 d2araCfHnXlQ2PDhPUGq0af8HLh+AUHcotWPrWn1qLNmnR24vYJGSRknWxLLqqpFXCF6Hvd0r5DR9DJJgQoFDddQ2uttJoBQdUuS3iuoHzuQL3rb+18vMnJkkKiWvDH60kuQL8WOqrHDkTenSIG98QD4lHODQ0AdDFHgo8qkVW6+gepTTSCYhnrwWMVAUpHNC/XzZcZXEn/Mipr68UgZLjyChy93YAONQnw241nJ2JKDnh+KCtSx3FMotiPAfkr/2nEbmyFXTyfto66Y4KtwY0N3h9VJ/1nh1F7MQ5XvxDmASu4qSk5q0HFy7FchtrB1Zk4IotD680LnjLp6/2nEI1/6q+SmHEBokCx9suhzFBwcGSextJO2EcTfX6OivHyFu6LhndIbsI1cD8jRk4r6q0FExeej9y7YuSP+Gd1PqP1TMuasuKBLXHbsSo1yMjkH40oxR/3wYvxoTo7FYwJ1FH5IXD8CAx817wa9pHxk7L3OehisoE9WLGnPxRkqJQYWjcXIsHjR1ZCZJBfNraC20k9lcZGIgrmcZ3ZPZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 12:49, Alistair Popple wrote:
> On 2026-03-19 at 02:05 +1100, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote...
>> On Wed, Mar 18, 2026 at 01:26:39PM +0800, Zenghui Yu wrote:
>>> Hi all,
>>>
>>> When running mm/ksft_hmm.sh in my arm64 virtual machine, I ran into the
>>> following kernel panic:
>>>
>>> [root@localhost mm]# ./ksft_hmm.sh
>>> TAP version 13
>>> # --------------------------------
>>> # running bash ./test_hmm.sh smoke
>>> # --------------------------------
>>> # Running smoke test. Note, this test provides basic coverage.
>>> # TAP version 13
>>> # 1..74
>>> # # Starting 74 tests from 4 test cases.
>>> # #  RUN           hmm.hmm_device_private.benchmark_thp_migration ...
>>> #
>>> # HMM THP Migration Benchmark
>>> # ---------------------------
>>> # System page size: 16384 bytes
>>> #
>>> # === Small Buffer (512KB) (0.5 MB) ===
>>> #                      | With THP        | Without THP     | Improvement
>>> # ---------------------------------------------------------------------
>>> # Sys->Dev Migration   | 0.423 ms        | 0.182 ms        | -133.0%
>>> # Dev->Sys Migration   | 0.027 ms        | 0.025 ms        | -7.0%
>>> # S->D Throughput      | 1.15 GB/s      | 2.69 GB/s      | -57.1%
>>> # D->S Throughput      | 18.12 GB/s      | 19.38 GB/s      | -6.5%
>>> #
>>> # === Half THP Size (1MB) (1.0 MB) ===
>>> #                      | With THP        | Without THP     | Improvement
>>> # ---------------------------------------------------------------------
>>> # Sys->Dev Migration   | 0.367 ms        | 1.187 ms        | 69.0%
>>> # Dev->Sys Migration   | 0.048 ms        | 0.049 ms        | 2.2%
>>> # S->D Throughput      | 2.66 GB/s      | 0.82 GB/s      | 222.9%
>>> # D->S Throughput      | 20.53 GB/s      | 20.08 GB/s      | 2.3%
>>> #
>>> # === Single THP Size (2MB) (2.0 MB) ===
>>> #                      | With THP        | Without THP     | Improvement
>>> # ---------------------------------------------------------------------
>>> # Sys->Dev Migration   | 0.817 ms        | 0.782 ms        | -4.4%
>>> # Dev->Sys Migration   | 0.089 ms        | 0.096 ms        | 7.1%
>>> # S->D Throughput      | 2.39 GB/s      | 2.50 GB/s      | -4.2%
>>> # D->S Throughput      | 22.00 GB/s      | 20.44 GB/s      | 7.6%
>>> #
>>> # === Two THP Size (4MB) (4.0 MB) ===
>>> #                      | With THP        | Without THP     | Improvement
>>> # ---------------------------------------------------------------------
>>> # Sys->Dev Migration   | 3.419 ms        | 2.337 ms        | -46.3%
>>> # Dev->Sys Migration   | 0.321 ms        | 0.225 ms        | -42.6%
>>> # S->D Throughput      | 1.14 GB/s      | 1.67 GB/s      | -31.6%
>>> # D->S Throughput      | 12.17 GB/s      | 17.36 GB/s      | -29.9%
>>> #
>>> # === Four THP Size (8MB) (8.0 MB) ===
>>> #                      | With THP        | Without THP     | Improvement
>>> # ---------------------------------------------------------------------
>>> # Sys->Dev Migration   | 4.535 ms        | 4.563 ms        | 0.6%
>>> # Dev->Sys Migration   | 0.583 ms        | 0.582 ms        | -0.2%
>>> # S->D Throughput      | 1.72 GB/s      | 1.71 GB/s      | 0.6%
>>> # D->S Throughput      | 13.39 GB/s      | 13.43 GB/s      | -0.2%
>>> #
>>> # === Eight THP Size (16MB) (16.0 MB) ===
>>> #                      | With THP        | Without THP     | Improvement
>>> # ---------------------------------------------------------------------
>>> # Sys->Dev Migration   | 10.190 ms        | 9.805 ms        | -3.9%
>>> # Dev->Sys Migration   | 1.130 ms        | 1.195 ms        | 5.5%
>>> # S->D Throughput      | 1.53 GB/s      | 1.59 GB/s      | -3.8%
>>> # D->S Throughput      | 13.83 GB/s      | 13.07 GB/s      | 5.8%
>>> #
>>> # === One twenty eight THP Size (256MB) (256.0 MB) ===
>>> #                      | With THP        | Without THP     | Improvement
>>> # ---------------------------------------------------------------------
>>> # Sys->Dev Migration   | 80.464 ms        | 92.764 ms        | 13.3%
>>> # Dev->Sys Migration   | 9.528 ms        | 18.166 ms        | 47.6%
>>> # S->D Throughput      | 3.11 GB/s      | 2.70 GB/s      | 15.3%
>>> # D->S Throughput      | 26.24 GB/s      | 13.76 GB/s      | 90.7%
>>> # #            OK  hmm.hmm_device_private.benchmark_thp_migration
>>> # ok 1 hmm.hmm_device_private.benchmark_thp_migration
>>> # #  RUN           hmm.hmm_device_private.migrate_anon_huge_zero_err ...
>>> # # hmm-tests.c:2622:migrate_anon_huge_zero_err:Expected ret (-2) == 0 (0)
>>>
>>> [  154.077143] Unable to handle kernel paging request at virtual address
>>> 0000000000005268
>>> [  154.077179] Mem abort info:
>>> [  154.077203]   ESR = 0x0000000096000007
>>> [  154.077219]   EC = 0x25: DABT (current EL), IL = 32 bits
>>> [  154.078433]   SET = 0, FnV = 0
>>> [  154.078434]   EA = 0, S1PTW = 0
>>> [  154.078435]   FSC = 0x07: level 3 translation fault
>>> [  154.078435] Data abort info:
>>> [  154.078436]   ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
>>> [  154.078459]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>>> [  154.078479]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>>> [  154.078484] user pgtable: 16k pages, 47-bit VAs, pgdp=000000010b920000
>>> [  154.078487] [0000000000005268] pgd=0800000101b4c403,
>>> p4d=0800000101b4c403, pud=0800000101b4c403, pmd=0800000108cd8403,
>>> pte=0000000000000000
>>> [  154.078520] Internal error: Oops: 0000000096000007 [#1]  SMP
>>> [  154.098664] Modules linked in: test_hmm rfkill drm fuse backlight ipv6
>>> [  154.100468] CPU: 7 UID: 0 PID: 1357 Comm: hmm-tests Kdump: loaded Not
>>> tainted 7.0.0-rc4-00029-ga989fde763f4-dirty #260 PREEMPT
>>> [  154.103855] Hardware name: QEMU QEMU Virtual Machine, BIOS
>>> edk2-stable202408-prebuilt.qemu.org 08/13/2024
>>> [  154.104409] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS
>>> BTYPE=--)
>>> [  154.104847] pc : dmirror_devmem_fault+0xe4/0x1c0 [test_hmm]
>>> [  154.105758] lr : dmirror_devmem_fault+0xcc/0x1c0 [test_hmm]
>>> [  154.109465] sp : ffffc000855ab430
>>> [  154.109677] x29: ffffc000855ab430 x28: ffff8000c9f73e40 x27:
>>> ffff8000c9f73e40
>>> [  154.110091] x26: ffff8000cb920000 x25: ffffc000812e0000 x24:
>>> 0000000000000000
>>> [  154.110540] x23: ffff8000c9f73e40 x22: 0000000000000000 x21:
>>> 0000000000000008
>>> [  154.110888] x20: ffff8000c07e1980 x19: ffffc000855ab618 x18:
>>> ffffc000855abc40
>>> [  154.111223] x17: 0000000000000000 x16: 0000000000000000 x15:
>>> 0000000000000000
>>> [  154.111563] x14: 0000000000000000 x13: 0000000000000000 x12:
>>> ffffc00080fedd68
>>> [  154.111903] x11: 00007fffa3bf7fff x10: 0000000000000000 x9 :
>>> 1ffff00019166a41
>>> [  154.112244] x8 : ffff8000c132df20 x7 : 0000000000000000 x6 :
>>> ffff8000c53bfe88
>>> [  154.112581] x5 : 0000000000000009 x4 : ffffc000855ab3d0 x3 :
>>> 0000000000000004
>>> [  154.112921] x2 : 0000000000000004 x1 : ffff8000c132df18 x0 :
>>> 0000000000005200
>>> [  154.113254] Call trace:
>>> [  154.113370]  dmirror_devmem_fault+0xe4/0x1c0 [test_hmm] (P)
>>> [  154.113679]  do_swap_page+0x132c/0x17b0
>>> [  154.113912]  __handle_mm_fault+0x7e4/0x1af4
>>> [  154.114124]  handle_mm_fault+0xb4/0x294
>>> [  154.114398]  __get_user_pages+0x210/0xbfc
>>> [  154.114607]  get_dump_page+0xd8/0x144
>>> [  154.114795]  dump_user_range+0x70/0x2e8
>>> [  154.115020]  elf_core_dump+0xb64/0xe40
>>> [  154.115212]  vfs_coredump+0xfb4/0x1ce8
>>> [  154.115397]  get_signal+0x6cc/0x844
>>> [  154.115582]  arch_do_signal_or_restart+0x7c/0x33c
>>> [  154.115805]  exit_to_user_mode_loop+0x104/0x16c
>>> [  154.116030]  el0_svc+0x174/0x178
>>> [  154.116216]  el0t_64_sync_handler+0xa0/0xe4
>>> [  154.116414]  el0t_64_sync+0x198/0x19c
>>> [  154.116594] Code: d2800083 f9400280 f9003be0 2a0303e2 (b9406800)
>>> [  154.116891] ---[ end trace 0000000000000000 ]---
>>> [  158.741771] Kernel panic - not syncing: Oops: Fatal exception
>>> [  158.742164] SMP: stopping secondary CPUs
>>> [  158.742970] Kernel Offset: disabled
>>> [  158.743162] CPU features: 0x0000000,00060005,11210501,94067723
>>> [  158.743440] Memory Limit: none
>>> [  164.002089] Starting crashdump kernel...
>>> [  164.002867] Bye!
>>
>> That 'Bye!' is delightful :)
>>
>>>
>>> [root@localhost linux]# ./scripts/faddr2line lib/test_hmm.ko
>>> dmirror_devmem_fault+0xe4/0x1c0
>>> dmirror_devmem_fault+0xe4/0x1c0:
>>> dmirror_select_device at /root/code/linux/lib/test_hmm.c:153
>>> (inlined by) dmirror_devmem_fault at /root/code/linux/lib/test_hmm.c:1659
>>>
>>> The kernel is built with arm64's virt.config plus
>>>
>>> +CONFIG_ARM64_16K_PAGES=y
>>> +CONFIG_ZONE_DEVICE=y
>>> +CONFIG_DEVICE_PRIVATE=y
>>> +CONFIG_TEST_HMM=m
>>>
>>> I *guess* the problem is that migrate_anon_huge_zero_err() has chosen an
>>> incorrect THP size (which should be 32M in a system with 16k page size),
>>
>> Yeah, it hardcodes to 2mb:
>>
>> TEST_F(hmm, migrate_anon_huge_zero_err)
>> {
>> 	...
>>
>> 	size = TWOMEG;
>> }
>>
>> Which isn't correct obviously and needs to be fixed.
>>
>> We should read /sys/kernel/mm/transparent_hugepage/hpage_pmd_size instead.
>>
>> vm_utils.h has read_pmd_pagesize() So this can be fixed with:
>>
>> 	size = read_pmd_pagesize();
>>
>> We then madvise(.., MADV_HUGEPAGE) region of size, which is now too small.:
>>
>> TEST_F(hmm, migrate_anon_huge_zero_err)
>> {
>> 	...
>>
>> 	size = TWOMEG;
>>
>> 	...
>>
>> 	ret = madvise(map, size, MADV_HUGEPAGE);
>> 	ASSERT_EQ(ret, 0); <-- but should succeed anyway, just won't do anything
>>
>> 	...
>>
>> 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
>> 			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
>> }
>>
>> Then we switch into lib/test_hmm.c:
>>
>> static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
>> 					   struct dmirror *dmirror)
>> {
>> 	...
>>
>> 	for (addr = args->start; addr < args->end; ) {
>> 		...
>>
>> 		if (dmirror->flags & HMM_DMIRROR_FLAG_FAIL_ALLOC) {
>> 			dmirror->flags &= ~HMM_DMIRROR_FLAG_FAIL_ALLOC;
>> 			dpage = NULL;  <-- force failure for 1st page
>>
>> 	...
>>
>> 		if (!dpage) {
>> 			...
>>
>> 			if (!is_large) <-- isn't large, as MADV_HUGEPAGE failed
>> 				goto next;
>>
>> 	...
>> next:
>> 		src++;
>> 		dst++;
>> 		addr += PAGE_SIZE;
>> 	}
>> }
>>
>> Back to the hmm-tests.c selftest:
>>
>> TEST_F(hmm, migrate_anon_huge_zero_err)
>> {
>> 	...
>>
>> 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
>> 			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
>> 	ASSERT_EQ(ret, 0);                  <-- succeeds but...
>> 	ASSERT_EQ(buffer->cpages, npages);  <-- cpages = npages - 1.
>> }
>>
>> So then we try to teardown which inokves:
>>
>> FIXTURE_TEARDOWN(hmm)
>> {
>> 	int ret = close(self->fd);  <-- triggers kernel dmirror_fops_release()
>> 	...
>> }
>>
>> In the kernel:
>>
>> static int dmirror_fops_release(struct inode *inode, struct file *filp)
>> {
>> 	struct dmirror *dmirror = filp->private_data;
>> 	...
>>
>> 	kfree(dmirror);  <-- frees dmirror...
>> 	return 0;
>> }
>>
>> So dmirror is fred but in dmirror_migrate_alloc_and_copy(), for all those pages
>> we DID migrate:
>>
>> static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
>> 					   struct dmirror *dmirror)
>> {
>> 	...
>>
>> 	for (addr = args->start; addr < args->end; ) {
>> 		...
>>
>> 		if (!dpage) { <-- we will succeed allocation so don't branch.
>> 			...
>> 		}
>>
>> 		rpage = BACKING_PAGE(dpage);
>>
>> 		/*
>> 		 * Normally, a device would use the page->zone_device_data to
>> 		 * point to the mirror but here we use it to hold the page for
>> 		 * the simulated device memory and that page holds the pointer
>> 		 * to the mirror.
>> 		 */
>> 		rpage->zone_device_data = dmirror;
>>
>> 		...
>> 	}
>>
>> 	...
>> }
>>
>> So now a bunch of device private pages have a zone_device_data set to a dangling
>> dmirror pointer.
>>
>> Then on coredump, we walk the VMAs, meaning we fault in device private pages and
>> end up invoking do_swap_page() which in turn calls dmirror_devmem_fault() (via
>> the struct dev_pagemap_ops
>> dmirror_devmem_ops->migrate_to_ram=dmirror_devmem_fault callback)
>>
>> This is via get_dump_page() -> __get_user_pages_locked(..., FOLL_FORCE |
>> FOLL_DUMP | FOLL_GET) -> __get_user_pages() -> handle_mm_fault() ->
>> __handle_mm_fault() -> do_swap_page() and:
>>
>> vm_fault_t do_swap_page(struct vm_fault *vmf)
>> {
>> 	...
>> 		entry = softleaf_from_pte(vmf->orig_pte);
>> 	if (unlikely(!softleaf_is_swap(entry))) {
>> 		if (softleaf_is_migration(entry)) {
>> 			...
>> 		} else if (softleaf_is_device_private(entry)) {
>> 			...
>>
>> 			if (trylock_page(vmf->page)) {
>> 				...
>>
>> 				ret = pgmap->ops->migrate_to_ram(vmf);
>>
>> 				...
>> 			}
>>
>> 			...
>> 		}
>>
>> 		...
>> 	}
>>
>> 	...
>> }
>>
>> (BTW, we seriously need to clean this up).
> 
> What did you have in mind here?
> 

I have the same question, cc's would be helpful as well. (+)Jordan has been running 
this test for his patchset, not sure if he ran into this.

>> And in dmirror_devmem_fault callback():
>>
>> static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>> {
>> 	...
>>
>> 	/*
>> 	 * Normally, a device would use the page->zone_device_data to point to
>> 	 * the mirror but here we use it to hold the page for the simulated
>> 	 * device memory and that page holds the pointer to the mirror.
>> 	 */
>> 	rpage = folio_zone_device_data(page_folio(vmf->page));
>> 	dmirror = rpage->zone_device_data;
>>
>> 	...
>>
>> 	args.pgmap_owner = dmirror->mdevice; <-- oops
>>
>> 	...
>> }
>>
>> So in terms of fixing:
>>
>> 1. Fix the test (trivial)
>>
>> Use
>>
>> 	size = read_pmd_pagesize();
>>
>> Instead of:
>>
>> 	size = TWOMEG;
> 
> Adding Balbir as this would have come in with his hugepage changes.
> 

Yes I did, agree with 1

>> 2. Have dmirror_fops_release() migrate all the device private pages back to ram
>>    before freeing dmirror or something like this
> 
> Oh yeah that's bad. We definitely need to do that migration once the file is
> closed.
> 

Agreed, it's been that way for a while, it does need cleanup.

>> You'd want to abstract code from dmirror_migrate_to_system() to be shared
>> between the two functions I think.
>>
>> But I leave that as an exercise for the reader :)
> 
> Good thing I can't read :) I can try and put something together but that won't
> happen before next week, so I won't complain if someone beats me to it. Thanks
> for the detailed analysis and report though!
> 

I'll try that at my end as well and see I can reproduce it, but I don't think
I'll win the race with Al or come close at this point.

>>> leading to the failure of the first hmm_migrate_sys_to_dev(). The test
>>> program received a SIGABRT signal and initiated vfs_coredump(). And
>>> something in the test_hmm module doesn't play well with the coredump
>>> process, which ends up with a panic. I'm not familiar with that.
>>>
>>> Note that I can also reproduce the panic by aborting the test manually
>>> with following diff (and skipping migrate_anon_huge{,_zero}_err()):
>>>
>>> diff --git a/tools/testing/selftests/mm/hmm-tests.c
>>> b/tools/testing/selftests/mm/hmm-tests.c
>>> index e8328c89d855..8d8ea8063a73 100644
>>> --- a/tools/testing/selftests/mm/hmm-tests.c
>>> +++ b/tools/testing/selftests/mm/hmm-tests.c
>>> @@ -1027,6 +1027,8 @@ TEST_F(hmm, migrate)
>>>  	ASSERT_EQ(ret, 0);
>>>  	ASSERT_EQ(buffer->cpages, npages);
>>>
>>> +	ASSERT_TRUE(0);
>>
>> This makes sense as the same dangling dmirror pointer issue arises.
>>
>>> +
>>>  	/* Check what the device read. */
>>>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>>>  		ASSERT_EQ(ptr[i], i);
>>>
>>> Please have a look!
>>
>> Hopefully did so usefully here :)
>>
>>>
>>> Thanks,
>>> Zenghui
>>
>> Cheers, Lorenzo
>>

Thanks for the bug report

Balbir

