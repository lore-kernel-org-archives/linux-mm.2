Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42CBCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4206B00A1; Mon,  8 Jun 2026 07:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B806B00A2; Mon,  8 Jun 2026 07:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37AF86B00A3; Mon,  8 Jun 2026 07:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 255A96B00A1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:27:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0B1EC343C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:27:22 +0000 (UTC)
X-FDA: 84856519524.28.59FB234
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	by imf20.hostedemail.com (Postfix) with ESMTP id D5A901C000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:27:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=igrmXyyq;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdDmtrrV8LZ6goi8PnBkjBF+SJr0gEaabFIFAHpLNvk=;
	b=GoIQUhZOLio5cqkvQlIfILBy62Jobut5XGVp8NyICIgV413LvN2g2nmh1+pOa7+EgyiidU
	4nIGCMHxdA2pEo+rAFnqkuxbNDdZeG0a2EpE6Erse1cXbFcCkaJt/dlbMhvnZeAEqdRsxr
	yrZkq9Oy4AiSter+yrY8uf96r6j8+cc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780918040;
	b=aVtgm/ZjnBs/CeHkPKP2WNYMjP9sFAgTVR7ML9JK/CHIZCanLsy1WhspDV+6KAr0iAL6zT
	Q0Iq8q3Remvy6/WBElux/swTR/VWQ7ERq2yOzcu3Ax6BVU5bxxI7oSHQAbIVD3G8YyWt8Y
	/0E9Xq2ILJSvXPhJVc69uQQk/UoHhOE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=igrmXyyq;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m1a9/OJzwjN88Otpva2cFPGkqjC3AvhwhatStWqJkDYJ10W0WZZ6UMkNSfBZzspPg+GhMxfIfHygySSWh+9Tp9VcB5TZvX+SqhCc9NTZU2pT2iQ88pKp4Yb9nvtej5dS3Br6Tcyf+VFQfjxqS+lmiC8U365bkAJIsNetnKZD7Px0p6TX0k7/zM7LBri0FLIhxdvTyUgYu/GfG4U8QaCOwxYyZw8wQMJzJ0WB4uAHHBN7Pi4WbTeK7h7kqNnm6GoXAO8u1h1JZjPuDtfBPVpuIgVFBUKK+dBS9KeK3sY0UN++oxLQtnMwUYPKp7tSxHhGF15IC+4SEWm64kBxtBdyLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdDmtrrV8LZ6goi8PnBkjBF+SJr0gEaabFIFAHpLNvk=;
 b=WhSwzKwMF9pQPCiBZ8wKo2x0Hk6D5ntUFs8QHR+8musiNaPMUsvLv8Qwzxva5O5w8RrC8nIlcsKKiVzekU2eM939je5x1qQjrX2PXPoya4gYxrqJboe3BVwu2EJLEE/sskEkVRpbMyxjNt6PhHSz6xryo1+P3we19gKw8fzyf6jO1VcneSeGK/iG8sxSXvX1I3Ch+nsCrbn841YiSFo5KA5gplR2otIHeT/Rf0X4KahbRwxEuL6tQOWpikEZ8yStAWyLJnGZw5mpCeUsBxycibAOzjd2nY6Lgn8jjk7i6fNjsOBaOcXdSvj/7vLGMTqU94aA+z8e9C1LHdVY1WOl3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdDmtrrV8LZ6goi8PnBkjBF+SJr0gEaabFIFAHpLNvk=;
 b=igrmXyyq54bOx3JVpb+Ld1Xwq7UYOVMR3IcdUqtIdZKqho+5YoDGboJ4gdtfYMRwn8DjQlc/rOyR5S01ZDEM9bBh6aFHDQMs0ftHcyZIj9E4vjl1yIWvyP8n1jlsjclHi//14XKVtTr6JSxKyRVuu0Sso7JpIEXLZW6svQo7jAs=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS5PPF016FC81DF.namprd12.prod.outlook.com (2603:10b6:f:fc00::644) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 11:27:11 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 11:27:11 +0000
Message-ID: <7e6a7626-5a1b-4672-91bd-85b0f4ee2ecb@amd.com>
Date: Mon, 8 Jun 2026 16:56:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
From: "Garg, Shivank" <shivankg@amd.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
 <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
 <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
Content-Language: en-US
In-Reply-To: <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0024.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::30) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DS5PPF016FC81DF:EE_
X-MS-Office365-Filtering-Correlation-Id: df0bd9c8-39f8-45aa-d614-08dec550e1ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099006|4143699003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kF90hOsCKWJaY11raV4cMqfZXsawgrOoH/zyEvey4cbCq6isv9CgY0k4NH9rGMdXfjlp4Ern8uyxHA0E+2DQhDxWeKkZN6c0zzA9XQNSZe7qKMiXiruIU0r7wn1OVk+/PQTET1cDydAZzmFzO/GyMh2Hz7ob3IuFSQNb0z8RMGJlWbm8fLItTm0L7/7ChVnf9MIKLnwJs7KSnOkmTLCr6gpDVNK4/VRJenpGQwHwT5UZQgmeX/w1qkxzJdpDY20uhqw9EYMz9ZkvDZLArtczkYZqJdDRO4nQKmI9XliYoTMdDQMXoyEjXW6snSvYsH7wp3KckoRTdHOchUS3oh0XfIjsCyWny8oAtyRn186cmBIX9xhS7ucXu0wwdJe/D1TIpylWH/Fcn5Ji2SNYai7cW61+DaBTjNpmO7b3eW9JM+zNce/H63GMgPP4Z+tYIs9UlH3hWkpF7sC4smBose2FwOMYvK6bAQv0lbCqtkJ2CIRM6sJj4jK6DBDBDptuaSTJ04x1ObiOS8aA4wwucYwHLp7qAzCcZp43clLfB2t7fqWH0AEzzXwEl72v/Um0TAw5cJvdV3CPWKDgCRRo3Lqq8XkSSMGDdOPFpKewnYR+K3mZdGB+99+/+97Wp6QcGMMUOcpiPcfFUMGxWPy8hyPCNhCkO/TIh55YH8aVMTwQy5G7HhTv9mbrY302y68ZOMfl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099006)(4143699003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3NCVkhDbmlGWHF4RWFvL2xDYkFoMTF4ZDVHT1I4ZHBwRjFVblVMb1NwZ1p1?=
 =?utf-8?B?ZGxCK0hFbGZMeS9JNnc1bytXbWNzZDM0TUxDTCtMRnRtS2FjU0xJdmRWbDUz?=
 =?utf-8?B?SjlwdVBqaUsvZDViL1lRbElLUG9sWDQ3M0t5UGxuNThjYUpCdUFIbFV2MnUr?=
 =?utf-8?B?VXdnV3dnWk12amdidTdscGdoalR0MDA4RnBFMlBMNGdKUlNWVUFJbGNxQk1T?=
 =?utf-8?B?WUJobTZoVEhzZ2EraHlVK2Q3VVJ1RHFLVlVqRG5MNDFMNFhxc09jNVI4cFgz?=
 =?utf-8?B?STRDUHUyRWZ4YmZRdUVuUFJOMEtJTFZpbTA2L1hIUXUrUmY0aWFUUWs3UXpN?=
 =?utf-8?B?Q1JReHRiMXdLSHNSeXRSUlhDa0NaN1g1R2w3U2FLcTFBZkdrdmdkN240NW9r?=
 =?utf-8?B?QzhIWUhTZU5rUExDMUhKSVlSclI2SkhMVis5bU91cmVTR0F3T20wTkZCWnYv?=
 =?utf-8?B?eXczaDUyYTExZUpUT0Q4bmkzMVNkanJPQ1hkVW8rS28rL1NRcWV2eWpydTR4?=
 =?utf-8?B?ZzdVUmk3ckUxTmhjK1h6ZkgrNE9FNGkrbnpZRnJVbjNmb0FnQkdsOWJJL3R3?=
 =?utf-8?B?SXZQcmJJWkd3cmJ0N0lqRk9rYVRSSjYrc1hEWjRGRGFUaVhmWS9peElYejBJ?=
 =?utf-8?B?RUk3MmdoK1hrMHJ6S1E4U293ZHI5YUUxeTVyRnFmMzdsenQyMGNzeXBNSHlw?=
 =?utf-8?B?YnhKb0U0VHZuY2FGVGxsMHlTamZIb3g2UU94VU9lL0piY0JvMU9oU3dFRjhh?=
 =?utf-8?B?NGRWRUJ6MG52cVZXNFFMaG5xYVFFUmxGdUJJSFpZVERzNHlqNSsyRUFseFVI?=
 =?utf-8?B?YVRIOWh3NXRBaFRtZmtSWWNCNDdTOG9PbVo4YjRuN1VCTldBVXRQV0pJcWhT?=
 =?utf-8?B?VEtBNGh2bys1WjhuK1pRQlBRYWU5bEphc2Evb0RUSFlrNERrWEN5UGZVSnlC?=
 =?utf-8?B?OG54dVNyMDA1bC9ENDhqaDFVNUJUSEFKOUlKbC9YR0dkOGtiejZveHFvNFVM?=
 =?utf-8?B?ZWdnWllPeTVrbGJyay9adnRnOERqd2x1bm5GVlhyMzBLa3R5MHhRRExPRnNY?=
 =?utf-8?B?SFBERWdqRUZwSDludzJMd0UxbnNlTnptd09scmxpa2c1NGFHSlVPZG5rb1Iv?=
 =?utf-8?B?RXR3MHpHN2FCa2c3WG5nT2JhbkZOZU9PTlFFMXBNR1EvN0lNTnNFcUN5QlR0?=
 =?utf-8?B?YXdJdmRMcVdHQkF6NG9tNGNjTlhIaXpKelF2MjVxdENNemNWN1U0UXR5UUtM?=
 =?utf-8?B?djhHRURVWEtIamZVL1RRTU85SE5iSXc5UFZsZjM3ZGFmT0k0eDQrd2NKeFJq?=
 =?utf-8?B?OHlaMytoL1NsVGpEVmYxL2Y2RUFNVkdweFdpMS9QdU9tZ1UrVk1kcWNMLzc4?=
 =?utf-8?B?d3BXR3NZbjMrcGF1ZjRiV2U0NWZVb3Fwb2d4OUpERHQ2V2lCZGNaakwxSm15?=
 =?utf-8?B?QU1QUGVpTFVQdkhWNFJITGgxRUIxY0hmU0N6QW54bWdTSVFURUVncUZaMlo1?=
 =?utf-8?B?RXdSZkw2dkZlVGdZT2J4bzJOeDl2U2w0OE8yb1NVWGtkK0JRbEcxRk5MNVEx?=
 =?utf-8?B?NW5hUThTUm5acDA1ckpVdVJtUVNGWVNWckwzZjYzLzErYThuL0pxSnJZZXpO?=
 =?utf-8?B?VU9yYUQ5aDRCQ05ObGFpSGVVdlNid1dZZk9DblpQeml6QzByQzlKSzRxVjNT?=
 =?utf-8?B?UHRiK1NwRFZGOGVSY2hPSytTcXNZYVJqOGpLbS9OMEZNSytPQnIvQmgvcUZF?=
 =?utf-8?B?UGNuRG02OFFOU1dkYnZaZG02c2VXRTlCVEgyaXI1STcxUGdETUtZZEd4V3hY?=
 =?utf-8?B?VEpVOUpMZkNRLy9JZzBnWnltcG9RSkRvMnJWN1l2NEhSUzlwZzF5eFIybFI1?=
 =?utf-8?B?QXFWU0RsVHFxc0hBL21Td0luUlE3Rmd1c3hyb1ljQ2syNFNubVRncXQ0VzV6?=
 =?utf-8?B?eUdONk1hWExnQlhhT0NRM3JTcHhhNjZkaXFjVE9xUWc4Ym5kd0lEbFJWT25r?=
 =?utf-8?B?Z240UEhzcktGbFNQODl6dlB4MWFjeko3K0VQUXEwQ21nQWJmY3BaMHI2RWhI?=
 =?utf-8?B?bmU0ZEdoQVV6UVNhZTRZR2syZjFuUnpuRUhlN2xaWHdaaGpWdTM1eVBGRHRW?=
 =?utf-8?B?dFlLQk9BOVlSYzNtRkRwSDIzekc0bE1KdG0xNDZjbkNna09wS0RmL2R6bTZP?=
 =?utf-8?B?V0t5YkYrVkY0dGFEekRqS3lnZCs0bzVoZFFLZGwyeGRIbnI3THdKOCsrRUZJ?=
 =?utf-8?B?VXhaZ25FMHRtTDdJWk51MkFZaWtwbEhEVzFWNm5XWUJBcWtwNzZxMTBudTEw?=
 =?utf-8?B?UFlTb1YwWGgzUzNCZFJNTFBhbTlUZlk4ZEhITEsxSExsZjdQUGFzUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0bd9c8-39f8-45aa-d614-08dec550e1ea
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 11:27:11.4877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XTS3278U541HbmXRTKoKvNAB1hS5aI0wYuEwmNd6i0fHoaSeBRLh7kOjpNx52l7rajgs1tI09R6T3cQTpMcn5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF016FC81DF
X-Rspamd-Queue-Id: D5A901C000D
X-Rspam-User: 
X-Stat-Signature: uqyzfpydukdhioyub33atm1zpgbzpi9k
X-Rspamd-Server: rspam08
X-HE-Tag: 1780918039-391711
X-HE-Meta: U2FsdGVkX18yPyVen+QpqrVcmgGEsgg7XbZZotpjRP9bJrCQUlEIVuV2jUD3OLZRlwxTdoNu9+qqbccCD+RorgOuosktCWlgY2aVCTy7KpA0Ntq30vycFyj3xP2nwA70te1m+AEAelZ0ewiUOVcJQaRw9IsR1pBhms4qGd5oGg0yMPRsPl3x7O8Ed0BEGJYPkFiU0o0AqKDuA4gy/zDxXz6dAWKgDY3kzRLb3EygJ4+09ikdcbU8kMvwpTwsWfGegfQxYkqlDQqNcRZZUIukYQJEXmqr6AJ6qiJS7DmX1QCylfPTtxBSCx7Pgqrwzcn7xHvvDTIXW2sFzFFqCnfWodYNFAF3z04QD8e+VEhP2HPZ2m7SA4eoRHp6M3W/iqvtU9hp1fTfh/23m2yYIC5GIKaXCGZ/CMHl0qXWi3zJiiqC1PsgnbIoVg/k+RGTRWb/8N41zz+wmzzBep/a35oT0RS0oow09gZLBO+Ijznwz8+iX5Ap20OzIr8ClfMHFSuB2crf5T8Z7f3UAt9MAFGF+mItB17HX5ksWIRUT+sMs/9hRuTpz3CePHW4enO2/OzG1qnAVOTAGkd4lg90I5LecTYdIfklp9DM4ntHNEjP7C+Sz5qjqmz9RTZ/uqho71QDGRU0gdrQlLYDYLjT+uEudgllP+UgsgkdIlokDw81QqVr24pisj3tCHrJh5HcYrmg5jsjXQuJv9tqautc6qKUzTbwEzv2oUu5KSUT1NJNJL4TturjAmkWR07tTxekuW4g/T7kUeCr+K14dMWK3VlMrm5kpE37g3UiF8lYtQtAEuttjelHX8HoLa5Unt9vfRGJGxZ+MmPDZL2I3rYRtYkEqimtLFykP8Ssap/r2YVEfeotvwuA8+bbTjR9wfcnD1A4xfIyr7iZggi0vCsl+ce33eIR6lt3jgdOqEzOYQPdBnnKyMxgNQRwKXEcIH0SmKhDa22Bict3eWt3eZ6Q/fZ
 U9meR6mF
 ldszL+RRG0TNRJvQhkmSWvBsJo7UZCrzgBITtXc8PxSrXTpVN81EQ3Tk+r0Nug0kRdsq6XL26rEU/FjvAHjLWsEZuXrOh/N2YOsRR8ykAfECq6LiZ1B7lucsWmOEvZZKT9iVone/zbjuYo82Gr51rXWijATtuRzZhfmR1LC7kOfCnYxA8qJ1IMiSwvQid5uCOf/aThGwVjw7KTwpsoj70S/knp2W+3MHyubYBDGHgVEjDsqytvs+8gG85rAeFpgPBm1yRnCFk43q6wmcneIfKdGxaZYuRfxn0tmjPEHvB6KuJFDDa31EW1qvqKJC6+/bSswRthXIBtLQyCJbIF6uGl+cFXcIszXiVxrli7v4nh+4yLk9IMF/24ya/g355ARF76bi3d95y7v9KJa++YvxuVRUIXyiyMf8NJiThhjBWrAvc82+2vE/V3BE2jwjRhSwwEosHO4cmpZR3TZyxuAomdXS/888bfY9Pprqtzr8Wb3GI9Icbf/dH6991d1tcoKUnqlNvY+opy0Q38rynQkRT8b1JPix9XiA1D8GryFEwToEzq00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/2026 8:51 PM, Garg, Shivank wrote:
> 
> 
> On 5/11/2026 9:05 PM, David Hildenbrand (Arm) wrote:
>> On 4/28/26 17:50, Shivank Garg wrote:
>>> Add a FOLIO_ALREADY_COPIED flag to the dst->migrate_info migration
>>> state. When set, __migrate_folio() skips folio_mc_copy() and
>>> performs metadata-only migration. All callers currently pass
>>> already_copied=false. The batch-copy path enables it later in a
>>> subsequent patch.
>>>
>>> Move the dst->migrate_info state enum earlier in the file so
>>> __migrate_folio() and move_to_new_folio() can see FOLIO_ALREADY_COPIED.
>>>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>  mm/migrate.c | 53 +++++++++++++++++++++++++++++++---------------------
>>>  1 file changed, 32 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 03c2a6f7e5e4..c493e67e359d 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -850,6 +850,19 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>>>  }
>>>  EXPORT_SYMBOL(folio_migrate_flags);
>>>  
>>> +/*
>>> + * To record some information during migration, we use the migrate_info
>>> + * field of struct folio of the newly allocated destination folio.
>>> + * This is safe because nobody is using it except us.
>>> + */
>>> +enum {
>>> +	FOLIO_WAS_MAPPED = BIT(0),
>>> +	FOLIO_WAS_MLOCKED = BIT(1),
>>> +	FOLIO_ALREADY_COPIED = BIT(2),
>>
>> I wonder whether we want to talk about "folio content copied", to not confuse it
>> with folio flags copied etc.
>>
>> FOLIO_CONTENT_COPIED.
>>
>> Thoughts?
> 
> Good point, this is more precise.
> 

Sashiko Comment:
Does expanding FOLIO_OLD_STATES to include BIT(2) silently corrupt anon_vma
pointers on 32-bit architectures?
The anon_vma pointer is packed with FOLIO_OLD_STATES inside dst->migrate_info.
To separate them, __migrate_folio_extract() uses info & ~FOLIO_OLD_STATES.
Since anon_vma objects are allocated from a kmem_cache with align=0,
ARCH_SLAB_MINALIGN defaults to 4 bytes on many 32-bit architectures. This
means a valid anon_vma pointer can legitimately end in 0x4 or 0xC (meaning
bit 2 is set).
When __migrate_folio_extract() masks the pointer with ~7, it will silently
clear bit 2 from the anon_vma pointer. Any subsequent call to put_anon_vma()
with this corrupted pointer could cause a use-after-free or a kernel panic.
--

#define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)

I initially assumed this to be always 8, confusing it to be same as size of
unsigned long long.
But the GCC docs note that alignment can be smaller in size:

https://gcc.gnu.org/onlinedocs/gcc/Alignment.html
"For example, if the target machine requires a double value to be aligned on
an 8-byte boundary, then __alignof__ (double) is 8. This is true on many RISC
machines. On more traditional machine designs, __alignof__ (double) is 4 or
even 2." 

If my understanding is right, Sashiko concern is valid, and I can't safely
use BIT(2).
I see few option from here. Either I can gate batch copy for CONFIG_64BIT,
or I can force anon_vma_cachep to 8-byte alignment via kmem_cache_create()
align arg. Or I can change the migrate_folio() callback to pass already_copied
info to change to dst->migrate_info enum.

I'm not sure if touching the anon_vma cache would be preferred? Gating the change
to CONFIG_64BIT feels less risky to me.

Thanks,
Shivank



>>> +	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED |
>>> +			   FOLIO_ALREADY_COPIED,
>>> +};
>>> +
>>>  /************************************************************
>>>   *                    Migration functions
>>>   ***********************************************************/
>>> @@ -859,14 +872,20 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>>>  			   enum migrate_mode mode)
>>>  {
>>>  	int rc, expected_count = folio_expected_ref_count(src) + 1;
>>> +	bool already_copied = (dst->migrate_info & FOLIO_ALREADY_COPIED);
>>
>> const, and no need for ().
> 
> Will fix.
> 
>>> +
>>> +	if (already_copied)
>>> +		dst->migrate_info = 0;
>>
>> Hm, why is that required? Might deserve a comment.
>>
>> Likely you want to clear the "already copied" marker?
>>
>> 	dst->migrate_info &= ~FOLIO_ALREADY_COPIED;
>>
>> ?
> 
> Yes,
> In current code, migrate_info only carry FOLIO_ALREADY_COPIED.
> So, =0 and &=~ are equivalent and similar for |= case. I mirrored the
> how anon_vma/old_folio_state get handled __migrate_folio_extract().
> 
> But with your other suggestion of marking already_copied immediately
> after folio_mc_copy(), then bitwise clear and set will be required.
> I'll do this.
> 
> 
> 
>> But I wonder if this really belongs exactly here.
>>
> 
> I did not understand this.
> 
>  
>>>  
>>>  	/* Check whether src does not have extra refs before we do more work */
>>>  	if (folio_ref_count(src) != expected_count)
>>>  		return -EAGAIN;
>>>  
>>> -	rc = folio_mc_copy(dst, src);
>>> -	if (unlikely(rc))
>>> -		return rc;
>>> +	if (!already_copied) {
>>> +		rc = folio_mc_copy(dst, src);
>>> +		if (unlikely(rc))
>>> +			return rc;
>>> +	}
>>>  
>>>  	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
>>>  	if (rc)
>>> @@ -1090,7 +1109,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
>>>   *     0 - success
>>>   */
>>>  static int move_to_new_folio(struct folio *dst, struct folio *src,
>>> -				enum migrate_mode mode)
>>> +		enum migrate_mode mode, bool already_copied)
>>>  {
>>>  	struct address_space *mapping = folio_mapping(src);
>>>  	int rc = -EAGAIN;
>>> @@ -1098,6 +1117,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>>  	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
>>>  	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
>>>  
>>> +	if (already_copied)
>>> +		dst->migrate_info = FOLIO_ALREADY_COPIED;
>>
>> |= ?
>>
> 
> Will do.
>  
>>> +
>>>  	if (!mapping)
>>>  		rc = migrate_folio(mapping, dst, src, mode);
>>>  	else if (mapping_inaccessible(mapping))
>>> @@ -1129,17 +1151,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>>  	return rc;
>>>  }
>>>  
>>> -/*
>>> - * To record some information during migration, we use the migrate_info
>>> - * field of struct folio of the newly allocated destination folio.
>>> - * This is safe because nobody is using it except us.
>>> - */
>>> -enum {
>>> -	FOLIO_WAS_MAPPED = BIT(0),
>>> -	FOLIO_WAS_MLOCKED = BIT(1),
>>> -	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
>>> -};
>>> -
>>>  static void __migrate_folio_record(struct folio *dst,
>>>  		int old_folio_state, struct anon_vma *anon_vma)
>>>  {
>>> @@ -1353,7 +1364,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>>>  static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>>  			      struct folio *src, struct folio *dst,
>>>  			      enum migrate_mode mode, enum migrate_reason reason,
>>> -			      struct list_head *ret)
>>> +			      struct list_head *ret, bool already_copied)
>>>  {
>>>  	int rc;
>>>  	int old_folio_state = 0;
>>> @@ -1379,7 +1390,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>>  		src_partially_mapped = folio_test_partially_mapped(src);
>>>  	}
>>>  
>>> -	rc = move_to_new_folio(dst, src, mode);
>>> +	rc = move_to_new_folio(dst, src, mode, already_copied);
>>>  	if (rc)
>>>  		goto out;
>>>  
>>> @@ -1536,7 +1547,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>>>  	}
>>>  
>>>  	if (!folio_mapped(src))
>>> -		rc = move_to_new_folio(dst, src, mode);
>>> +		rc = move_to_new_folio(dst, src, mode, false);
>>
>> ... mode, /* already_copied = */ false
>>
> 
> will fix
> 
>>>  
>>>  	if (page_was_mapped)
>>>  		remove_migration_ptes(src, !rc ? dst : src, ttu);
>>> @@ -1720,7 +1731,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>>>  		struct list_head *ret_folios,
>>>  		struct migrate_pages_stats *stats,
>>>  		int *retry, int *thp_retry, int *nr_failed,
>>> -		int *nr_retry_pages)
>>> +		int *nr_retry_pages, bool already_copied)
>>>  {
>>>  	struct folio *folio, *folio2, *dst, *dst2;
>>>  	bool is_thp;
>>> @@ -1737,7 +1748,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>>>  
>>>  		rc = migrate_folio_move(put_new_folio, private,
>>>  				folio, dst, mode,
>>> -				reason, ret_folios);
>>> +				reason, ret_folios, already_copied);
>>>  		/*
>>>  		 * The rules are:
>>>  		 *	0: folio will be freed
>>> @@ -1994,7 +2005,7 @@ static int migrate_pages_batch(struct list_head *from,
>>>  		migrate_folios_move(&unmap_folios, &dst_folios,
>>>  				put_new_folio, private, mode, reason,
>>>  				ret_folios, stats, &retry, &thp_retry,
>>> -				&nr_failed, &nr_retry_pages);
>>> +				&nr_failed, &nr_retry_pages, false);
>>>  	}
>>
>> dito.
>>
> 
> will fix.
> 
> Thanks,
> Shivank


