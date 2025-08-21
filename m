Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F302CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A3C8E0052; Thu, 21 Aug 2025 08:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51F08E0020; Thu, 21 Aug 2025 08:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A0F8E0052; Thu, 21 Aug 2025 08:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD3738E0020
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:34:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72D071A0395
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:34:46 +0000 (UTC)
X-FDA: 83800708572.23.D7A9C3F
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013064.outbound.protection.outlook.com [52.101.72.64])
	by imf09.hostedemail.com (Postfix) with ESMTP id 85F0514000B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:34:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DPgLjcA7;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DPgLjcA7;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf09.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.72.64 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755779682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TI5OjpvFobIwoNgwWHQLuMcBf+X+dq6gWBT/Ca0g+7A=;
	b=aVUGNoFR8F+ThvScm0T4gEMzTDh+KZ67WpRiSO8gZ674wG6zcWJ9BHmRplBXKBcNLQDGmH
	6c89NlabqdBDyp0JnNaEQNbXY0xqSVzWkWKEEecsTlMU22oEA5EDYzZ9hlu02ziS5I+AAL
	oyosvtLNMfUD7Ja8MwwYi0MY3E+RbAg=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DPgLjcA7;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DPgLjcA7;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf09.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.72.64 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755779682; a=rsa-sha256;
	cv=pass;
	b=beid1l7OIRDLCT30xIemrO0O+WFjGYFZnqndbpQqnV05PedDppqij9bz8r3afblGIsF8i5
	k6T56t2Rj+Y1oiXEmPM1TB0ewFs5Nv836BVmbno3Pq2hajTZacr9ytAPak3yhbFKey5vIj
	dhnKJfxlcOHWd37gHc5Te8iaLbMzeOY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BjZtRwV+bxZMg/hNKpKT0NG4Xw5YK8MBqyCqVyWX5Ar86T12PUfpDF5/u1jxGMnPBsVPGfBXxVrh1vGF9Q8UmF9fDv8yBiXZytJMHBLoc+Oj/xXaBpd0lBLpVBXfFHijGhsJHmq6jgXl1qhy7hHejbh74weysmv1VDwzycUxP1a9m0M6H5TN8EM5+eejEVvqS7pvRdGhJBWHlyJ6RhEIhbd3eykVcOC8n1OUjc5fwaKGxxq3pq9P62eBE8BTcZwAIMDaJiusU4y4QwZ1nzV4HPpX/rp32y/INqMaGU8jorV/nDejZBWBuX6NlAV/Ny2k4zHq46jFqEU0Z6mbGpukng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI5OjpvFobIwoNgwWHQLuMcBf+X+dq6gWBT/Ca0g+7A=;
 b=VfkDvi/gei2IjZxp6CAjroQXuvqFWubmrjc81UbGNybnYj4yMwB3azO0HTid8IjRaJ6ed3iCpTiu83Vx4KDaQtOCDBZ4XgLJMJlEmIXhaA0GPBtwh0OtUv75m/+A9w8vG3dDkxS9wuEP0Bm/wjKXkIllb2HFnU9odLPnMFnxK28nmZFa7HCP5rhVkmkuoufUNP1xHMq8eeEdMrgESxBCyOf6gZxXy9hl/SFAcVG7SrghS6G6qmI562Kf+5a6Lr5ynPdr5KWZ3qhMIJG28fUZB2icMEpy2JuzWfm8wAYpIYP3+grLQykL7MLPcPvOllk3MRMxINs6c2ZmA1dggL6HTg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI5OjpvFobIwoNgwWHQLuMcBf+X+dq6gWBT/Ca0g+7A=;
 b=DPgLjcA7f+RQfM/bOF9dHW970xr/YyYP+66WjKO/cjfxzZsMgO+H3EZqUVvQ702SlhnVXIzx8Ol7rNuxW5gJ0/I8IHYj8QO1SB9dZzo4uHsFphjM06h7qmul5jwqZwz2z6DJqFILDNja2Yo476KABQxnnm0sgog8xB7KfkW2KsQ=
Received: from DUZPR01CA0315.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::6) by AS8PR08MB8393.eurprd08.prod.outlook.com
 (2603:10a6:20b:569::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Thu, 21 Aug
 2025 12:34:38 +0000
Received: from DU2PEPF00028D01.eurprd03.prod.outlook.com
 (2603:10a6:10:4ba:cafe::3) by DUZPR01CA0315.outlook.office365.com
 (2603:10a6:10:4ba::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.15 via Frontend Transport; Thu,
 21 Aug 2025 12:34:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D01.mail.protection.outlook.com (10.167.242.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Thu, 21 Aug 2025 12:34:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2Ep7NEZT/3duLtrqWYb8ttc0Wd1IacLLxnn+Qd+ZkpLJYjPDTaeFB7RUzYOH3m1wQG82cwSDSBriGrHZk7y85KNaN3GPjCzvGb0eckX3o+1Xn19RZwQG51i2T+zfU4UHNpFNwkh2HYjGUmIDz1r22RIhFNQo8ItIqe58eqBV0/5udmi3dRsXHT9+qrDJvcQJJRb7k0ZrWmaHsLzpMzR5WIPySqSzfmAFM+kpJ743YYwpE/KqX7K5LOZLGso5372I0soCqSTcDfFPJs7qiKqK4sunf8hSDb4Je3fkUBN2OnBENJYHIpSzUJzJ+oXS+eagYdsbJnYCbIxDnLhpH30OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI5OjpvFobIwoNgwWHQLuMcBf+X+dq6gWBT/Ca0g+7A=;
 b=MqxI6KcGVuSMCYzt3/XAI2d7DNCRRg0drLZl+1bATUoQC5ceGq3BObBTeaI1J43bzLq3tVU8zyvDtW+GK3RqWRoNnb63VTZoqZ8PQuneIMxCY2W7kciBNWJNYDIDCM4irALIUc0H7xZyvt+Gyx2CK98XxQ599qzPsCrKRh2k0v9am1422NMs6szYVHGLzLhzlLB8jmCtmmF8vszuXmsTET3RxIH1n4yeNG2MB4dvVFVDgmbjUMVYpqZa5rR0GA5c4NpL3icLYEJHqIEv2LbxDcHc2G+vUog8VpjVTNl7SG3xuv88B+6+BVya8nwbWA+nvp5MSzG47N5ikaoQ3rlxXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI5OjpvFobIwoNgwWHQLuMcBf+X+dq6gWBT/Ca0g+7A=;
 b=DPgLjcA7f+RQfM/bOF9dHW970xr/YyYP+66WjKO/cjfxzZsMgO+H3EZqUVvQ702SlhnVXIzx8Ol7rNuxW5gJ0/I8IHYj8QO1SB9dZzo4uHsFphjM06h7qmul5jwqZwz2z6DJqFILDNja2Yo476KABQxnnm0sgog8xB7KfkW2KsQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by PAVPR08MB8991.eurprd08.prod.outlook.com (2603:10a6:102:32f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 21 Aug
 2025 12:34:05 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9052.014; Thu, 21 Aug 2025
 12:34:05 +0000
Message-ID: <8e11042c-0e7c-41ac-8da1-b6c6a1c1dbf6@arm.com>
Date: Thu, 21 Aug 2025 18:03:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/13] khugepaged: skip collapsing mTHP to smaller
 orders
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, corbet@lwn.net,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-8-npache@redhat.com>
 <b6ebe641-0a0b-40b2-a34b-07393f883985@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <b6ebe641-0a0b-40b2-a34b-07393f883985@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0020.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::8) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|PAVPR08MB8991:EE_|DU2PEPF00028D01:EE_|AS8PR08MB8393:EE_
X-MS-Office365-Filtering-Correlation-Id: cdca3cae-f2cf-4dee-2396-08dde0af17c8
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?VmV4MUErR3N2Y1Q2WVlTZlBxQytwbEVhd2IvWUpMSG9La0VtQ1dDZTJ0Z3BW?=
 =?utf-8?B?Y1U3anFRenJoT3liR1JBLzdxRXZGWDd5Ylk4Ulh5dHRTOUF0WEpDM2czTTB1?=
 =?utf-8?B?RDhpWFVWK0dSbnJtRkNjdHNyUVFUcFMyeWptY3lDVXZWMEVGaDEwbUF5cmxH?=
 =?utf-8?B?aGVYWURWQS9oUENaeXlBeTJRVUpIZnB1RFhNNStVUlhJK1JINkdmNkYrYyts?=
 =?utf-8?B?Q3FzZlFOOEFBNWQvVjZ0UnlQMVlSa3RobDRqWHN1NlJJT1pLMi9FRmprQm4x?=
 =?utf-8?B?dG9KNWYrbmltK2NGZndZYjZxMk9vZzZ1amZTb0YvMlVDMlQ4ZVBvK2JidjBP?=
 =?utf-8?B?MTkxTEZ5VG81TThMVGo4blBIYjB5ZlBENUxHcy9KVmJjMEFKMHN1KzFFOVRi?=
 =?utf-8?B?L1I5QUUwWlJCRTgyZE5yb1VDOGRVcEhYS1lMT2ZWbTNtcTEyV01wNElnT1Z6?=
 =?utf-8?B?dDM3ZVRkOWM0ZEFUcmN0NnA1S3o3cWZmRU9YZ0J1eXFZY2RWdUs5aUxvU1F2?=
 =?utf-8?B?VytCT2kwUFU3WVU5RTZjTTRMclNUWGdLYXliNGxUK0VoUVJFMXZEbjRuWmNo?=
 =?utf-8?B?MklSek1jLzRhUTdXVEQ4V1pFdHgrZHU0YkdreTZ2UUhaSGU2ZEVkeUczU3J3?=
 =?utf-8?B?RDRKMVUvL3lFRk95dDhRWFREdmNKNWZuQzlIZFlkVE1vUGdjOGxDbkNITEpK?=
 =?utf-8?B?bTMwbzhwUmFnR1JMUUJuczRyTzV1Qy9uTzZhLzdmQlg1R3dtcGN0bStocTc4?=
 =?utf-8?B?S25Sb2paeWp4QUZpeml1dDQzQTdXL3RIVmhnTG5xUjZFaGo0LzJZYWs0WlJo?=
 =?utf-8?B?T2NtK2JwenZQZUxROXplaE12OVpGOW5YazRER2c3RS9Vb1Zyd1FlT1Z6Vlh5?=
 =?utf-8?B?UGFXdHo2ZUVFWFZYekNBUW1CYzhYdC9la3VhTGdLWFhrMkxpUEtyTFRFeisy?=
 =?utf-8?B?U0xkemZGcFBOUnB4dy9QaklkdWV3MXJ6dkhqS2JkeDlya2pqN0wxN0pGbWo5?=
 =?utf-8?B?N0IvWTIxWlpOTnRvbGVHZ1krTVVQcnlaQW1uWWlzQktvZ2RxZ1MrV1d6Zys4?=
 =?utf-8?B?QkpOdGxReC91UTVRUnBMQ3BQd2pQNFUrQlE3Vm9CUGNDSkQxTzBCdGUvZmM0?=
 =?utf-8?B?V3NkWlhueFBuY0NhMDR6TUk5MjZ0NzE3NGdOYjBZaGdNV0UvN2VqbVFMUU9t?=
 =?utf-8?B?blZjdjhEYTNvMitRTG1qQVgybUhTdXpiWWFFWllFODAxbnNUSlU0WG44Ynls?=
 =?utf-8?B?V3NhMmdGVXF0bjBMOGVqV2E5ZWhKRWJuNGJVNWNPOUw2eHJ2c1U5U2Y1ZVdW?=
 =?utf-8?B?a3hKbDc0OEE0NUJmdGNvKzhtWUIzU1Q2alJISEl3TmF3SndoRUQzUHl1T2tr?=
 =?utf-8?B?NGQxUElFemtUYnZ1YzJmR2NsWk8xLzB0K1d4ekJnR0RJcFdKMnZSODZRd0I5?=
 =?utf-8?B?c0FKcGQ4Ujk3LzBycnFYRTU3MzkzMGJFSE1UL2lldERBQXoyNzFHcnlWKzhS?=
 =?utf-8?B?YVQ3NHl0WVNlK1FENm5wQ292cUNyT3VnV2pYRXJvS2cwYjQ5ZDJrRDJSaXpy?=
 =?utf-8?B?OG5pVVRkYWVWMGhGN3EwVXNTbkthOThHUUxRMlFmSCtiQjhpeDROc01xWEtP?=
 =?utf-8?B?azR2SXcxQkFwRmxPeDE1bGtTZW5DNllyclJiR2FuNUNjSGxoNGRRb0MxSHBL?=
 =?utf-8?B?V0ZzZ3V4aWtuaHJtRTFucUp3VUhDWUFEeG5tRkhWc0tlMEV1V0NUelRvaUE5?=
 =?utf-8?B?MEgvOElScDZGaTlnd3l2QlRqb2NHMDFwZ29ua1lEVytON0RBc2Rya0pUN3ZJ?=
 =?utf-8?B?NEpSTFVYUVNUNDFBMnVtLy9nc1B3cUVOWm91dEQ5YktPbFNsejVjQzNZam9l?=
 =?utf-8?B?L0phVmxXMi85YmN6WTN2RVdRblNxcHBsT0w2d0p0SFdDdDgyRFpIa0VwMkxW?=
 =?utf-8?Q?w4UfLh2XAxk=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8991
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6049fdb7-c11b-437c-9fb8-08dde0af0415
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|35042699022|376014|82310400026|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?allDWTkxRTdCdU40aVBOSnVvODR2cm8venZsaFRUSHNSNFZzbVZERC9vYnd2?=
 =?utf-8?B?YmtFWC92Y1F2SDRndTdJT3NNSjlHZTFIM3hTWkZKbkpRNmtDZlg3SHlucFpm?=
 =?utf-8?B?YThUNlg5ZkJGbk1QNHF6SmJ2SDBSNTlxaWEzSVNTZFhWZ0Y2SDBNU1B3MzRa?=
 =?utf-8?B?UVhrbG85VnlSa0FRUGF6ZVFNeTB1NVFFQmdNSW5iUEdoNnY4WTJ0Z0xtaTYr?=
 =?utf-8?B?cmVYNUV1aEdiMUpWVU1wSDhkc2pManZaQVlXWkZHM3pYQ2lDb3d1TzU3MlVY?=
 =?utf-8?B?Mkt0ZlM3M1ZwR211cVdUQ214aWZRSFlaMnAwaTM5MGRzdFJVRVpsQlRPV0h0?=
 =?utf-8?B?YTl6UlBaVTVJVmZ0S3FoeFY0NERteW9idmFhcHZjL0JEeFpvYlNUMTE5S1E3?=
 =?utf-8?B?WU9VZUMxK3FSWDZwWS9WajhXQzlHUXRsYWwxU3pVMmxUd2hqOHhjd3FFT3dV?=
 =?utf-8?B?Z2YxdmZOdEdRZ1gwVCtDVjByRTM5d3hSb1VGRjV0YldsQzl5Y3BPZGkyblRj?=
 =?utf-8?B?TUhZQjBob2R5b2N2QU1iMXVmTDlXOHF1VlJ6a2tQaC9UYUxvMlFxOWhibnpD?=
 =?utf-8?B?SmpwSFYyWnFuM0lUV08zVXVFUnhoVlI2UmFpQ3F1U2lMVERRMytGQ2NXODdP?=
 =?utf-8?B?VVRBR1RUQUtoQU9XZ01zdkVvaXZxbmhXOHpVL0tnazRHUkY2RitvaWwwdmdV?=
 =?utf-8?B?UGtLbUZLS08zZXVWclNsdEdxNGhJS0NQeWN1b3RoVWJsNS9jWTNFc240NU9o?=
 =?utf-8?B?QzU2TE8yYmVoaUVWcHVDYVhtTW5LdnRPTTFlTHdRT0JBdlRldFFWcVQ1NFVl?=
 =?utf-8?B?OTZ3QkM2M25QV2ZENkpDMmxJZmpUek9yTXJCeUJkcW93RVpzQy9IUzhQZnh5?=
 =?utf-8?B?S3MyTjBkSzVwbTFWclBleVhOWXVPOTB5aHVEZ2xEeEFaWkdETDd6UVR2UWQz?=
 =?utf-8?B?RVA5YlliWlR3VHZTMnlSSUM1bDZFYy9QbXU4a1VVb290OWVjcE4wdWF0Vjgw?=
 =?utf-8?B?OXBlSEF2UGxnWDZITFRORG04dWRVNE5Rb1k3YzczbEdQN1ZHbDFQczdUd3VH?=
 =?utf-8?B?dmZXQ2NtSFpZQjVZQVJONkpZNVc4UjNmVUZEYUpTWWM3bzNGcktEMUhCREZv?=
 =?utf-8?B?TklKa0ptL3NFYy90NDRNdExCejNSOWtQTExaVThHbEp5RkJQK1lhNmJPNng1?=
 =?utf-8?B?U2hQWVlKZ0dtUC9DWUZycW5PM3cwUnFFMjZwbTRMZU9RNjJ2YkRLTktsS3ZF?=
 =?utf-8?B?blQ2em9rUFo0dTYvbmloMDBaTDFrL201RUVLN1JtN3lCeXRvSUZtc3lLZnBR?=
 =?utf-8?B?TXc1d1llQXN1eXVPS0xwV251a2pIdzhacGc4ZHJwWTE2WGtMei9WNUQwOWxl?=
 =?utf-8?B?RW1pc01sTTFzL3c4a1lwREpGNDZuQTRzT0lEa21Teld6SitkR3pNL0ZvMEha?=
 =?utf-8?B?NWFYSGJKTTViczJDeHRWTGc4MGFhdndWSUdrSFFDL3NHbWZCck55SkI5TnU0?=
 =?utf-8?B?OW1VTExtVFN4Z0hQRDlIeTNZVkZ1Y0lGQ3NkSmdobStjQi92RHg5OGZjNTV4?=
 =?utf-8?B?aitkNXg2czJKaWh5N1ZQZHVSUFM0Z2hsRjNHellUbXVnMldCZjdwNklRNVBZ?=
 =?utf-8?B?dm1qVFhOMjFDSkdYa3lnM3IwRWVTZGNnTHJRaEhWdG5HaGFVY2I3N2Mxc2Nk?=
 =?utf-8?B?MlMrQ2liejY0RURnOFo5YlJPWnVDSjZXdFhKTUFrekNIWjZQSzlSTXFickg1?=
 =?utf-8?B?Y01JamtXOStkaFF1OU9VbFUvMmpZcG1sYVZDeHdMb1hEQTNWWE9OYWJKU3Nm?=
 =?utf-8?B?d2ZLWFFOOWNPVk11OGxzbTk5N3ZrYStIVTFLMlFYMFhZOTVjOVVrNGtmV0g2?=
 =?utf-8?B?eERPQ0QwczNxcmJsVStWM2NVVEpWeW1GS1p3RWUzbDNsUldyQlRJNks5cURa?=
 =?utf-8?B?U2pzTUNnQmNsZEtWanlQbnZOVFp6ZEc5dnVPdFREMFhrMXdON3pUV0ErVlVI?=
 =?utf-8?B?TXdySHM2cEl4WjNmT1E3VmJQRE5aWVdQSzRoWmUrZzhsbU5DRDJiM0ZBWm5O?=
 =?utf-8?B?RUlvUzFKVVVvb3lkY29PZHplYm1raDZudDN4dz09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(35042699022)(376014)(82310400026)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 12:34:37.8644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdca3cae-f2cf-4dee-2396-08dde0af17c8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8393
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 85F0514000B
X-Stat-Signature: ob91g8q5c6318etk7ccyz93af599f4tj
X-Rspam-User: 
X-HE-Tag: 1755779682-497056
X-HE-Meta: U2FsdGVkX1+pbR1wHyYWsDYhCrvaEgbIdUSMRl6zWkUdzNR80ryqgaBaZn8Q9rUx8K/mzAjY8rRUQucsk6mHCWIoSbGi6q75mpAhGAizPX8OrTnNq31+mkoQ9APB3io4Z5wWRTsclC5BV4p7iMxn5+RSCu80L4/q/C0Ot/uIaPmsrB1KhOjGFANYX1r5V/dZmJ4wkGfEJilvqFYH3jpexN1SRaRY7VIaIfZcmInpMYZbodGUmgucibhsLwSeWL7vlLP7VEV8P/OYT1X2tSavu00M1qpLBkUoyqCbqxZfaQRh2tbuZF7+YofwF5N5eOqCxJvI17JmfWfp9obmXNO+MO49YbQ6cG8KcPkfPZzFLVh10Rtmbk7QSX+9UM7JRz4XyOXUiLpfpAVAUrxEwWlHkR7v4UU6sd0vZAyHBWUmPUdY+5yrXE8C7F4o4o37mb59kQ80qtbOLuz9uDNXIXDpO34LUbMSYo6Gw2WJWlkdXPMuIS4C+/YGbCf6niqoG8YyS52yxRWIGyyXHzmYJNhllnQc521C8TbLDZdNUOlPVldkW3PPXBJ91EhZBfBfwArX/tfwIrUkiX/hjGqj+R5/Geu8B90b6s1esrFEdGedyaklwxqdFxnS5UOTSsDljtOAn/cSfki5qRPlkEXRuDF0iAy/m78dD4dvFOQhfnFibyqfKETZhZd8S9uTHUqygWDMw1B6IWla+eqbZ8kzjUieFinQGFIRVaX7J3IEHfAMzrudCq08FIb+1jM4AmWTwDgl9xbPco/ukict3IMsoKvyQbH8l9j5pOTo8hAe5o3n8WmehxPhCKCFh9eiPDbjtLGxMH0DMmVvQZ34NmwcfSZc3MrHF4ViMyhWzRqcQMYP0t37QUs0h9sOe+XUAM461EUd/I/jW31AbVtFAdi+a/595STXoQ0vwXSD5WUHSSq6RLEACtSduZ3w9Vaxbzjy73zO0xlgkASjjK6pqMXQPws
 AjBBzS45
 6QcAP+25Cd/Jmys1sQh71uduMHHnqToVdD2cq9aKP+IrUwvB49MggzfCjTi0rR2UzCkgOXEPnA37BJyT9UWJ1GtbvyaTj2egnAXAQ3L4a8C9Z9Mis+U5O2Y1VV6OYSJfhq3YNn2IXgsoKSnifTkXo/ZK//pC6ZHM7fZazOHG6HcWqptQeh3iEiNg0ychJKNH3CnqfEhy64ZMBSDqTcG1PCQDVa9Jof0ELiCDLtADTHtmOd0UgVPRlwiFhWWK8r+V2mbKdMqSGX9pIrgwv8wsPxnu9IVVOE3RtNMcQeENLDwitDNAqrsgJm2yY31lgaU96lasJa1krqI2vUbf3Yw6IB/5taQzJ+Ozb3Do+iI+xBjPci4fAnm1DxaIJdEJuS52M8EJiWigiRZDOJPHGy4+J1AdPq1EZNPmaLAvJSGlh4qsL4ozmIrxW3xa/R0J471+B+WZiZdapkPAjBaanHSXiqDC5AMFuIy5pFUQapGREZlBamKwuvTL5qv6YDoP4hjC/tuYt+iH+taezfPzgm2juhXjZpp1/jsZw0onb1IJ3/VReFAgUBrFY/K+aqFtSIItrKAcKYMvOEdPaQPsYk+NXRQ50TUSt1PwyB9ieC9J/BxLFEJPhlMgNhunbnf8A+GHLmfbwfb0+WWfvwnd+cXgb6CGWpfvcRwkHBrq76pV6CQGIERYlto5rYwDMuT4vNNJcMeF3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 21/08/25 5:35 pm, Lorenzo Stoakes wrote:
>
>
>> ---
>>   mm/khugepaged.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1ad7e00d3fd6..6a4cf7e4a7cc 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -611,6 +611,15 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   		folio = page_folio(page);
>>   		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>>
>> +		/*
>> +		 * TODO: In some cases of partially-mapped folios, we'd actually
>> +		 * want to collapse.
>> +		 */
> Not a fan of adding todo's in code, they have a habit of being left forever. I'd
> maybe put a more written  out comment something similar to the commit message.

I had suggested to add in https://lore.kernel.org/all/20250211111326.14295-10-dev.jain@arm.com/
from the get go, but then we decided to leave it for later. So rest assured this TODO won't
be left forever : )

>
>> +		if (order != HPAGE_PMD_ORDER && folio_order(folio) >= order) {
>> +			result = SCAN_PTE_MAPPED_HUGEPAGE;
>> +			goto out;
>> +		}
>> +
>>   		/* See collapse_scan_pmd(). */
>>   		if (folio_maybe_mapped_shared(folio)) {
>>   			++shared;
>> --
>> 2.50.1
>>

