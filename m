Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA7BC54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E566B0099; Tue, 28 Jul 2026 16:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEDCC6B009D; Tue, 28 Jul 2026 16:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD5E6B009F; Tue, 28 Jul 2026 16:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69EE96B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:59:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BF1EA172C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:59:04 +0000 (UTC)
X-FDA: 85039400208.02.D49B040
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67CE3140003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:59:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=foRJXfQd;
	spf=pass (imf09.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.51 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785272341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUb+POZ20c7lT1s/iGFphUv1U5CyvVU5RuFQAUxcxMg=;
	b=Im69VH0Gz3peLltyb90+AfUHyfwXamcStC5Uc7GHx+dXvfcxtHW1a1cUs9CsI8b9NUypTH
	ACTIFYOb6eKkE76F3RGaHwTdjwtDs/EsAjTngNEgNQcRonw3Xiubl+dzmr9iWXQMarnjkY
	B5BMfhwJYGJLuPRUQsh2F1F4LfJ5tfE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785272341;
	b=T9KxBkkOg9u7sWkLa5Viqf0MHL4iVIfdPtKAS7oPG3vxCO2W3kMZGVd5WQrVj4lCSi9r2W
	pRQFqtin+P+ghGWcZChpCj8zlBYSli1fZ6d+4YvRoRGMPAkKhblT/SQzdRITHWVqdveBDS
	TCmeDTso/YnjM0yvd7KZgB4LuL29UmE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=foRJXfQd;
	spf=pass (imf09.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.51 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BpUbTVDymQhvF1uvgZKoaYS92uOvsv1kSADtmiGwJq4S/KzF0f937Yn0adBhzmdkFOo/PQYyzSRP6M7nG1gEjtqFteG6W7QqPQcL6dPL77U70KVYExOSinPU4Aq5v1JOtmXBH4PvPjFmVbOLlkCPlvG3WBy59QpqYVKTTEyCjP9USmlLOKCro20O6Krd+/MkdSKBzgZlpPY05EKVvKmNDQg+azUe8W+xyqZ7ko83uEquvoY+4xqLjTYIlqphLnoR25jiNRHu6xK4v5ywuXQDYUDWF5gwYUfsmD8CDVjHit/2qz8s4ym+TPjsVtDKwwKrxjRpOh/fdhvCXxvI2z7Brw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUb+POZ20c7lT1s/iGFphUv1U5CyvVU5RuFQAUxcxMg=;
 b=VVPMCbktOxGChRwSqsVXWmXOKLtfUlnj/XrTdXC+AqTBLEGvhdGNCEB3jSB/isCjnm/2CWakgew9yw4cymhGPIu6wp3JJSVsPLRNqJAJGUnm1FfeS6BYJKtsg1033qbbOSmGCV54JK8p+eKjmNIcapphhIoJt5e1F/Lv9X6vIFELvPUJzoRf/bThyRK03CQY/6iSbT0tpWslrTcO+Klkw5on+YQO2EPdRrNKIvEfsopLpgClOu1JaHuqFZ82SvSr4ZR28nnCpsYLNoNR7XX6qy8YQbm+YuhqUsH5j+aoN3TmwBU1eb8E9DivMhIfdz4CRkg0WgBkvXMDUaihT3d+dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUb+POZ20c7lT1s/iGFphUv1U5CyvVU5RuFQAUxcxMg=;
 b=foRJXfQdqsJCb8xE7EzlY8I8TvFndGdN3BPthuaYZ3k3EydPqPp4HmPH2NfCcHVNs+eM5mkvhsB6CdGdzTMtDx69UXARdH/htS3caal9SXIy4ht4sQazG8XbqWEIkDNoWHmdMpp/pHwXoxsuyPlKT3TkS7++Isa7VQZaX+4oXe3L7a/OekAPLUUL7EmCnv8SMJOBiWWaW0FGn9hGG7wf7cCS9P+gGsJiPYACurDpIBKh4lkzgU72r0ALtSREGKql/rCTcGtSHUIbwJh3JdEBwKsuNdnVBVwcI/II2C6Ds0TJPZAFfFR7UlzZ/StonXFAGMQVqBcSRm4XGR+ok1oqtA==
Received: from LV3PR12MB9412.namprd12.prod.outlook.com (2603:10b6:408:211::18)
 by PH7PR12MB9101.namprd12.prod.outlook.com (2603:10b6:510:2f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 20:58:54 +0000
Received: from LV3PR12MB9412.namprd12.prod.outlook.com
 ([fe80::c319:33b5:293:6ec4]) by LV3PR12MB9412.namprd12.prod.outlook.com
 ([fe80::c319:33b5:293:6ec4%4]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 20:58:54 +0000
Message-ID: <46d2c819-5035-4724-be1a-776de1110456@nvidia.com>
Date: Tue, 28 Jul 2026 13:58:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 08/12] selftests/mm: cover /proc/pid/mem access to
 VM_PFNMAP memory
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-9-riel@surriel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260724222934.1463812-9-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:a03:333::22) To LV3PR12MB9412.namprd12.prod.outlook.com
 (2603:10b6:408:211::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9412:EE_|PH7PR12MB9101:EE_
X-MS-Office365-Filtering-Correlation-Id: 31f73948-d483-4b77-ee2c-08deeceb08de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10067099003|4143699003|11063799006|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	U2knA+crRHGyAducYj7eA4fWUYEE2rFk+xBH7Rnd4j68i1816R3y30pqEIVhabtfGHjEn58hY6G+cMszZ7aoB2MccnyaGhynvykO1S3mWKY5B9AZgIgMcmr+WdA8xZH0mmwJfvA7Tl2EfbrxuDvAGncQL2NhYBPBPwVYIH2+HXxT5rLWgm6cMhezemMlLO0tm4wJCVbEmElgyL/fXrotW4lz1o6Cl5+hlKXvMihdNsdNRK1/QyNRnL9Hc5hgMN7X6QdiGnlHhrSeVBCL6wZPfoBT4bEfOe9iYJfrAZMZ5ht1vS3BilBfK2a4U4BT7yCAaq0/6R/Z+R22x19U7RW0L5rKOBy0yDxj0GMgTIelHQWk8mPRSJgRGvmMQKEglnQTJaNvTU6jVxsqN6IWXSGwLeLZnNWeLg1DFQ2aN0y/59o0Tn0P4EZSOt+QNwwwltyllBhxQc261WplMEfkkUURxbAj67dCJcfYZI+PbVUV1hXNKtV/tHrJWXYFfGRes5G/lnfliLGPcOpRpw5hpvc8+fsYgfoTv5UElpmOYLe4iyT2QHBUwxy5/4lQPUGsG1MNoEa879VnX3Z7seZNEzV3cdtlAZMjUUppiiHiguTBM+flcogNIgx8hGtE5TsEKvVaYHs64OokDy5qOZsXkPCLEYRyuYJdvT9OuM4aMkcyYOE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9412.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10067099003)(4143699003)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SENyVXJ3TXpCVjJoSC9nN1E2TWUzL21PWTUwMStaUitlUzh0UFhvYWNZN3Iw?=
 =?utf-8?B?dFQzMUdpQW1DSnk0bFNUQWd0ZC83dGpZdTB2UmR4SEJBQWRPb05lSlVSR0pj?=
 =?utf-8?B?elJvSEFkTWpSRGxjVWZvYUUxSzJLUXk3MHFvTFVSZmNqZ09hN0JVZzg0eHZn?=
 =?utf-8?B?SEd1QWpmcmI4MDNYZW8yTWRDbmNvT3lpdVJXeG41dlJ0K0tPT0hxcmMzZHpO?=
 =?utf-8?B?RWt5SHZOZnoyRTl6T0tydTBMc2krdWcxTHk1S1FPSFl1dm0yREJzbkh1ZkJq?=
 =?utf-8?B?L1gzSXRTMWRxSmFkSXc0dzZjTEVJV1JzWEgvblNnN1F3RGxiMGV6ZVd0S3Rk?=
 =?utf-8?B?cXZEVW45R045ekc1emowU09wYkpDSWJDbDlJclV2cFF6c2trVHM4aGtXeXhn?=
 =?utf-8?B?WlJOdHNOcGVMRDdqMWpka1JYU2svTVBvMXRVMllqWTZTSnowayt0UzVwMHdW?=
 =?utf-8?B?SEtLdDZRd0FUblU3YnZEWFduSXlTeEZQRldiQWVmUG5OVDF5bGdnRWVBY0lt?=
 =?utf-8?B?cGlDbFdKZWtab2RkWWprdi9KUGVLNVNyQU9ncnNaZ0Fmb0VIVWorb2Z4aGdT?=
 =?utf-8?B?dzZHTHJISi9DNkRYZG9NM0ZDWStqQjJjSnNUaUxjK1hKYVJNblR0ekIwSVpQ?=
 =?utf-8?B?TUVuM29KSFRuWW16ZVBpdXdMY2Uza2J3N0dNTUQzbFJja2lTNFM1ZTRBT240?=
 =?utf-8?B?UTQyVVZHVkFmTHQ0b2pqeUl6WUZMVWZoeTU0Yk80bGRrbVpvR3VvN3lveGRN?=
 =?utf-8?B?M05yYlVKaVJ2c3d3MnY1TnpKUVliNXk2aWZsWkV2K3dVTTBIWWxJSHhQN09U?=
 =?utf-8?B?ek55ZFBiR1N1eHZyTG5jWFJUQ3R0cU16czhCNE9FRzJRUGJZREpPM2FrSzVl?=
 =?utf-8?B?VmUwQU5OTy9kQmpTSkR4QUZ1bzAwVHppbUdya2xYRjREa1RTakNSSE13cllP?=
 =?utf-8?B?R0tzb0huVVdzL2dtc2tYSnBLNVZZTi85Y044WDFyUXovRTBrSEVNYTVPMUxq?=
 =?utf-8?B?VzFmckVINnpaUWpES1BKd2JKYVNzZzVsYzBzS2FWUmZ6VlRDOE9zVlA3am9Q?=
 =?utf-8?B?VkZMeGRGaDkxMW5rSm4xU3ZUajRGK290U0NqYkxxZWk0YWt2MDEyK29ZVXlm?=
 =?utf-8?B?ZEZ1d1FTN2puVmVCT0owcTFuZGVXZ2dXNUtVRnNsYXlzVU5sUjVPaWtOckZQ?=
 =?utf-8?B?SGxDam9wWnhtTE1QYzYyMmtkcUhVK1VnOVBQdzZoTlpGQ0kxQzM0NkhqSE5m?=
 =?utf-8?B?QlRiSDB4aTl3RjdCYkl3a1g3akl2KzNYanh1VWlLTk9naVdZaHVMYm5hdmQx?=
 =?utf-8?B?Nm5VOUc4dERLRllEZFg0dUNkNWw0aVpmSUd4Z0NUKzJlN2hpOWNOOEEycTh6?=
 =?utf-8?B?emYxQ0Y1MEUreVJxNFBNMTRuRVNkbGZqTTZzeUR0S3BCSThtMDFSTC9TM2Jm?=
 =?utf-8?B?RkhtcG1GMTBCb1kwMjZsejNucWpHQUhxcmJVUTNjeHNhSTgrRDVPcUtSL1pM?=
 =?utf-8?B?RlYzTG80ZW9iMkZvcHhZMG5jRGxOS0ZEVVNPVXFHcTJBdUVBSjIxQ1VFQXZ4?=
 =?utf-8?B?Z2VJV3VScFY1dXBKNUt3cG0rRVU3SVFwRDBJbUZGK2YvMjdmVm0wa1JGRDgy?=
 =?utf-8?B?K29GdjVuNjVuR0ZpRmgzdEFDYy9zVEtzbWJYbzBvRDk2OFh5Y05DK2pISzA0?=
 =?utf-8?B?UzJoQXJLMTIrdkltWHVCcitTTjNiSEJkSzAvWElCVFFWMkdNVGZFMkM3b1RV?=
 =?utf-8?B?MXlTQlF2QnhzMDJiNEwybmtseXdkQ0RSYzYyUG5ncmE0eVdTaEFIQyszSFM5?=
 =?utf-8?B?MGRwa2JENHo5ZkZhTUV2VkVuMHp5WTN1aGNiaXQ4YUxHYkRDWlFDc3dhaU54?=
 =?utf-8?B?V0xkNlJPMXhIZEpSRVFObjAwWWljYVBoWW1Pai9ZUGV3alBOMDB6SVdPd05z?=
 =?utf-8?B?VmRVdHdoZ2ZZM1RzcmswNWFPUnNHK0FOUWpjK29yOTRURjFTWDVuODExbDgw?=
 =?utf-8?B?TnJ5L3VWcStTNjFkb0htRyt1NVIrWUw1N2NXbUgxNHRiZ1Rnanh3emQrVDNW?=
 =?utf-8?B?empqTktGR3hKUnZHRzJ6NFJpaW9heVl5anpSNGEvd2ZmM0I5RDY1RHUwL2RE?=
 =?utf-8?B?MEl1Wit2aGhPZmY4LzZYNUNvT1RoQWVRZHhPMjhXck5yRm1QaE0ybWVCMWRR?=
 =?utf-8?B?Mk9kM1hOa1hyNXB0ODlMcjBLanJ2T0JWVXk1V3NIT2ZMMzVSczJpQkhVZTdt?=
 =?utf-8?B?OGdPV3ppS2tLZDV3UVNObzFCMGprYWgxYkh5V2dKN0FwUFZyQVFjZ2syelM2?=
 =?utf-8?B?Q0NMbWlZTUxwakxkeEdkWXlHQXZhZGI2VGdtbnFuUmxGUG11L3U1Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f73948-d483-4b77-ee2c-08deeceb08de
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9412.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 20:58:54.5368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlloK/+ChlfaNREkkD+45vWFRb3OGAGplfZE5CbEHZ6urZtgQmb4Zand5SpnhFaqZFQZUaSwktV8zRXr8DrYeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9101
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 67CE3140003
X-Stat-Signature: 13t3yzyitnobqksa6f86n1m48r9tqxy1
X-Rspam-User: 
X-HE-Tag: 1785272341-35559
X-HE-Meta: U2FsdGVkX19hG7rzS5CQ69nK/WlO4QiPi+FbXvm9kJik68e0+k5TK/vG7y4Dk1R3igwIuj7IVbH5NOnNE/wXN9pzQx2E/AHWSQlV5oxoG4oFq0tQii9E7FX24+8nk0/r7Ng2wqWl3ZmcH0s7ajow7GglQe6ama3pvDZgVJVRXZfUMcCDwFFaPHd5keCDnrPpi8t+wyqQe5CanYVW2iSitIgNRMyWNWZlDSfSdn7ueyHFMEOfxQUbofGQijpxCES4mnTO8r545mqJTRGD0T2Ybm7sV0K+oIxsEgl3bP3MFyIVt7X3pigm8PHUUU9sekz3PZKIfB/GmANXW/WUIC1vDbrro4dX/o9KYUeEvWgOBN4IR3b6mMPbBJT+SorrEEn8M0Te5pQ8rWGKhI6fZswDQuCYvi/LuXCgqlI1SnNkzhLkhotZI8gtqifP+rIjBrWqhPVa5pxF13kVQZVTZWvBOWBGRdQFGuwf0gENuSZGxajZN8vgywEi8CzdRYtbFLpO08euO2aIsilrkhbMikhEKmQyLCzxuLHTDCxi2afVaW0BVuKNbU0S7mLY0R2r+rFOdKta592OvjP3hGHBK0lWYEc+ffutjT0iHBeK1cMseCzZrmkjtJvtbQ4tCy80o+RBlIVpNLkN3XwM+0y8ry01MyCjF4mpnWAQKhfBqe8eR8cGhfeN45XSvabNpr733c0hVhcQe4bVX7KZQv8jI+SDH9J2Nia9cDDfux2q2azRaxipDaqWS9TYrDlfc8imM8c1/pElkIK91rvcxdgGMHGz85zmuWm5Ys3ZtyZYsO9B3ZvK82tEjETj64PYCr9Q1dXSUV0guQiOMEp3uPQhTh4MQyntsK9karfYwaM6zW3HNJcgMcNh1K5vlZvBFU8rOM7UrW5RKQTDUJyl3DM5mGQVvAOhA4c6lYYCIkuMaRhFrNXaEMYl0t+t7QoU13ofJNnNqA8R6m1Y9BHIUK12CVd
 54CFA03O
 tJ6+vF/Uc/Cq/dTonehAm9Bu2QyztfHM3f/JkgI1+3bpJvIWg7yENFefQ/DT3bU6cCXCIpQ0BFNQtvLptm4Izyn0C733XA8QVFejV4/IzturpJV1oQWsYQlDDqtCw+fii+2Da285PGMAroL2UEUfvYVN/yHVliz9DM2NRJqfHp0xtcPHS00PbD/CKhhk2/mMmEWR+Fyx39upP+rvitvFctRwBv3ZAEn+/4LKr5oHfjOzP4hSkqx760ityxlfuyg70hBIZhYEHbn3ioZhO/+DF8ql1SdrYFAcggdzls1GxfJ5gF5e2xA9cPPCg5iI2Pog4PIQ5n4se3xdSGnWg+C2khWSEF6pgiXqk+9r2lKiaz3wkiLsnAVRo39oXITleFdkyTY2apIteAddQo0MnhiYi9KBskCQUpf/RXx8vre+XSmIu7gOJLsO7lQDi7uioM5uRV1Vnh5gHghOMbcnWkjewf3MrKMHYo3ApSPJl53lq8R8VQ0Xr9PK37/qO5tay6WdP32fqXxK4cGW5ehM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 3:29 PM, Rik van Riel wrote:
> Reading a VM_PFNMAP mapping through /proc/pid/mem exercises
> __access_remote_vm() two ways: a COWed page has a struct page and is
> returned by get_user_page_vma(), while a raw PFN has none and is reached
> through vma->vm_ops->access().
> 
> Add two tests to pfnmap.c, both reading VM_PFNMAP memory through
> /proc/self/mem.
> 
> procmem_cow_read maps the file MAP_PRIVATE and writable, writes to COW a
> page, then reads it back. Without the struct-page path in
> get_user_page_vma() this read is short: the access falls back to
> generic_access_phys(), which ioremaps the PFN, and ioremap of a COWed RAM
> page is rejected.

This is architecture-dependent. RISC-V uses generic_ioremap_prot(),
which does not reject RAM, so the old ->access() path can read the COWed
page and this test can pass without exercising get_user_page_vma().

The raw test has the same observability problem: checking only the byte
count cannot distinguish ->access() from an erroneous GUP result for a
PFNMAP of normal RAM. 

Should we instead use a deterministic PFNMAP test provider
whose mapped page contains one pattern and whose ->access() callback
returns another? The COW test could require the anonymous data and the
raw test could require the ->access() pattern. That would also avoid
reading arbitrary MMIO and skipping the raw case in the default run.


> 
> procmem_pfn_read reads a raw PFN back through ->access(). ioremap rejects
> RAM, so it runs only for genuine device memory and is skipped for the
> default /dev/mem System RAM target.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  tools/testing/selftests/mm/pfnmap.c | 66 +++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
> index 4f550822385a..6ff5d1029517 100644
> --- a/tools/testing/selftests/mm/pfnmap.c
> +++ b/tools/testing/selftests/mm/pfnmap.c
> @@ -31,6 +31,7 @@ static sigjmp_buf sigjmp_buf_env;
>  static char *file = "/dev/mem";
>  static off_t file_offset;
>  static int fd;
> +static int target_is_ram;
>  
>  static void signal_handler(int sig)
>  {
> @@ -113,6 +114,7 @@ static void pfnmap_init(void)
>  		if (err)
>  			ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
>  				       strerror(-err));
> +		target_is_ram = 1;
>  	} else {
>  		file_offset = 0;
>  	}
> @@ -271,6 +273,70 @@ TEST_F(pfnmap, fork)
>  	ASSERT_EQ(ret, 0);
>  }
>  
> +TEST_F(pfnmap, procmem_cow_read)
> +{
> +	char *priv, *buf;
> +	ssize_t rc;
> +	int mem_fd;
> +
> +	/*
> +	 * A COWed page in a VM_PFNMAP mapping has a struct page, so reading it
> +	 * through /proc/self/mem -- __access_remote_vm() -> get_user_page_vma()
> +	 * -- returns it directly, instead of routing to vma->vm_ops->access(),
> +	 * which ioremaps the PFN and cannot reach a COWed RAM page.
> +	 *
> +	 * Map the file MAP_PRIVATE and writable, write to COW a page into anon
> +	 * memory, then read the page back through /proc/self/mem.
> +	 */
> +	self->size2 = self->pagesize;
> +	self->addr2 = mmap(NULL, self->size2, PROT_READ | PROT_WRITE,
> +			   MAP_PRIVATE, fd, file_offset);
> +	if (self->addr2 == MAP_FAILED)
> +		SKIP(return, "Cannot create a writable private pfnmap mapping");
> +	priv = self->addr2;
> +
> +	/* COW the page and stamp known bytes into the anon copy. */
> +	priv[0] = 0x42;
> +	priv[self->pagesize - 1] = 0x24;
> +
> +	buf = malloc(self->pagesize);
> +	ASSERT_NE(buf, NULL);
> +
> +	mem_fd = open("/proc/self/mem", O_RDONLY);
> +	ASSERT_GE(mem_fd, 0);
> +	rc = pread(mem_fd, buf, self->pagesize, (off_t)(uintptr_t)priv);
> +	close(mem_fd);
> +
> +	ASSERT_EQ(rc, (ssize_t)self->pagesize);
> +	EXPECT_EQ(buf[0], 0x42);
> +	EXPECT_EQ(buf[self->pagesize - 1], 0x24);
> +
> +	free(buf);
> +}
> +
> +TEST_F(pfnmap, procmem_pfn_read)
> +{
> +	char buf[64];
> +	ssize_t rc;
> +	int mem_fd;
> +
> +	/*
> +	 * A raw PFN of a VM_IO/VM_PFNMAP mapping has no struct page, so

That is not the VM_PFNMAP invariant. A raw mapping is treated as special
even when its PFN has a valid struct page. Please describe this as GUP
not returning a page for the raw mapping, here and in patches 5 and 6.

The new pread() offsets also need 64-bit off_t. On a 32-bit ABI, a
mapping at or above 2 GiB converts to a negative off_t, and pread64()
rejects it before /proc/self/mem sees the offset.



thanks,
-- 
John Hubbard


