Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1609FE9D419
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 17:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D79A6B009B; Wed,  4 Feb 2026 12:23:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384D46B009F; Wed,  4 Feb 2026 12:23:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E8C6B00A1; Wed,  4 Feb 2026 12:23:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1115C6B009B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:23:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDA1613985D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:23:22 +0000 (UTC)
X-FDA: 84407445444.09.7F8C463
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012055.outbound.protection.outlook.com [52.101.43.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id CFFE31A0008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:23:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dVZ6xNxC;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770225800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VrIawD1TzWE2ppS4qiFF7g7LfBC4JUNaRUz2IV1eyY=;
	b=nthD8nOBwEuYrOle2DjGdJcXi1gxdv84v4V3Nj2VSr03g6atjtlBiUJcjyKEL88P2oV5hU
	1UXJyOp5DNym5EhJUSna+/yD9nAQbt7l8tiuAlDl5x6GeiFWPIvF0MyS1lyuxTv0xdhdhK
	mR2Mz+Jpf8wqGGnUE57b6Zc+ywW0laM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dVZ6xNxC;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770225800; a=rsa-sha256;
	cv=pass;
	b=8rkw0QBZ0sSnE0R9xGZWKH27JIAGjJuYmJN5UAEBsVjSjMBGYECJWwOrophLGRxQAIjk+K
	D2WoCtXrMtgIaIvROgE6WRV9Oq1/XvlTuAiOEaY+G35XutUwGavfmteQCAdS2jA3rJXf7+
	dvOW5aE0k3RsAUQ6IV0fAu4ILmIJYic=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TFWadTH5tH5frffOdFq0UOhQLiCmR9nKUFRXHiBiV8QxfoNAihWmuD+E5OXRDnKcBUorSpp8Rx0lDQwB/r1tnLRMoKKZu6nIYy7jHKRcZJWbpKzcLmpr5W7JFL16f+aC8to+dSqnvjsFcB+S1z4Tr3lY3pa3zpsQWhKrkLACx6VrIZ1ghRVRzvaQcP7NRb3/zhMQVr4W8GCSMyCNrMQAehZiiT23CoH+3arl693onD7aUwWTxTpNoBWjeV+IfCfC4MY6VmWrZxeMjDioFYAP3gmaBqZGWH10XzY3JLD6ZsEy5sXWm92Z00/+7D6VY4d9WnpSKr/hOcTqqMd08Uv0CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VrIawD1TzWE2ppS4qiFF7g7LfBC4JUNaRUz2IV1eyY=;
 b=HeVZwSMUPDO4+4RvusMfRysClxB0BHxx1nchUbMEQMoNuF3RxPNVBRMxWStVJP8r18sQoSaAxsST47cb0s4zlDigDFzWfSRkT/NAUC5KugFviyMYU37bPLg4ePx82CTtaj2qGqPMCE148G+6vpJexj2oHNrcqUYvoVW4OdBVkXBvYvIl5EisngxejMiPPVfDADLDbxT+gGAtgy5Wj9LSyYE0pf1Sorgc7/CjFEJzSef0QAoxGfii4bYmYNNS73FD6NY7ZJdebyRPlV2vGiTE8tX4JxPysbtAvrQqDfypSi4y5a5212QbELqXNBazHTAOZ6SR+a2h558L34YFmItdqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VrIawD1TzWE2ppS4qiFF7g7LfBC4JUNaRUz2IV1eyY=;
 b=dVZ6xNxCNzW9pJFavLx79FmnLOiaau8pjtjszFbxXKkS5s3zZrLLKZKeI/+3BY8avL7GjS9l8O1kc6gz2Gj0leRSa+FT78AY7T4k4BwPcYBHQwX0VsMopWvtinv3a1x6D3AK+d2+onnbswa8cwcXQhwb5Me6LSC4A0uIvXuh4WeLH55GhDmyFq7IiX+SYjnu4hD37VxqxxufaYhKSsINiGrHOWFp+VubBORYoLY1Js/QIpm4X3q1DcWDg+3n9S2sQruU63RYP53I7d9VGlhWQH0BxdqugdehKT2xc7u9YyFmAKyamYolfQcB9zA2lAhUweH/gVkmdRhnbCVUaGiZww==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Wed, 4 Feb 2026 17:23:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 17:23:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 12:23:10 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
In-Reply-To: <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0236.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 05e1e9fa-2bcf-4e82-1122-08de641212f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUMxc29HQlAyZ1lyN2o5UDNueTY1K2JpaDcyUjVBdWtjOWROZi9yTWtZSVIv?=
 =?utf-8?B?R0E3ZG1MTUFMWHVjMlZ0MXY5d2doSkhTbjNFa08vaW1haU50cUlkWGk4N2sw?=
 =?utf-8?B?S0hrSW0zL1M2K1JEdDJQVEdWUjg4MFZ2OElxNUpTQkxSdUtiR2F3RXZ3NHZK?=
 =?utf-8?B?ZVlXaU5weSt6Q2RZbjJQNEV5R1ZobW9QbFBkNE1CVWJ3TmYzKzNONlVEOEI5?=
 =?utf-8?B?ZHcrTFpEaDVUdkpJSGxpY29EWjB6cXd3TEtOTDlZNEJwZGcvZWh0eU00d0JH?=
 =?utf-8?B?Qi9SeUJEMFVNbHFPYjhXYjlVWkxMeTg2Mk8rK1dza2o0UDJrZHg4KzRBQ2RY?=
 =?utf-8?B?bENjRnVib3U3TGhSSnBNN1A5RFB1UjJIL083elpObTM3NGRYUkkrT0JkRHU1?=
 =?utf-8?B?RCtaYWUxRHZ5Qy9pU2tpSitNQlRmeUdHN0FGRGFaTy9ubTluNXJTREY5RWNh?=
 =?utf-8?B?cnJQeTNtU1c3aEFyQkN4UmVxK1cvWFVBRGJOZ0tEN1g2SHFHMW54eVZhajBj?=
 =?utf-8?B?b3BxUW1YZWpmSGFvVFNUQndzR2s0V1ZDTVR4NlBFY252WDA1R1g4ZWhvaXNo?=
 =?utf-8?B?VTZRUW5jdE82QlhFcGo1QkVYU09ldHZycTFFUWlqQXptN3g1VGVsNlVneFZo?=
 =?utf-8?B?cDgzcmtLNGY4a0MrbjdoQUdjdllaYTlwV291ZnQxNFFkZldWQlF4MHFQZjdm?=
 =?utf-8?B?MXVTQ3dWYndVc3FxbkFxdEQ3OThiTjBNV3VZcWRvSis1am5ZbUhPSDd4a2NP?=
 =?utf-8?B?YmJKUUhRdFZkd09JUDJlcjhRN3BEZU13L3k3eG1HMEJ1SUVURDl3N1lWTlZB?=
 =?utf-8?B?NEZwQmJZRlhEY0Jqd3RMaUlWS0Jvckx2eFlSSzR3SkQ3UElxVy9aYjh5dFZr?=
 =?utf-8?B?cnBIUXNDc3h1U09RZW0vVXZmcmVYbzFPaGFKL0hsdERvd3JMNXRsL0NldzBk?=
 =?utf-8?B?ejV0QkVyUVc3Ry9mRTV3eWo0K0hFa1RLTVBoNlFQUE9kR0t3Q1p2dVd3dWJF?=
 =?utf-8?B?RmxETGlmUitCZ2ZtOWZiN3ZKazZyTjg4RWE2YnJTMG9hZkFpb3RtY0syRXcv?=
 =?utf-8?B?WTdtMUtmUzZaQUQydkpIaDhkbXFSYVZBckIwSHBFeDhuVjFSZGJTNEpmeklB?=
 =?utf-8?B?Y3ppaGRNdmJEU0dPVG1jMnZNMnYzQUlaRzVEbmttUGhZQXdCbEFneXVpcmlK?=
 =?utf-8?B?MDk0bUNwcVlpVFhQRlJ1YWlwM2w4VFM4WXhXcVV4Q29YNWRhWWp2cDVNL21D?=
 =?utf-8?B?MWsyYWpJNnAxSFdiWTJEbGhzbDZSNmN6ZDdMNnBnU1dVUHBRY2E3UVZuQkVa?=
 =?utf-8?B?cTh1UnBSSUJXVjJPWm0xdTQyVFdoS0xrZnRTSVFKcmpYU2NpMURubk1rWmVG?=
 =?utf-8?B?MUg1QmJrSllNUXZBL0ZLM1p4ZTN2bjFxTHFiVW9mZUZZU3loWEp1SUN0amdK?=
 =?utf-8?B?YWg2c2tMQWNmRFlEUkNXUUVrSHpiMGhINUNnM1hQdkkvOU9oTlBpTWU2aUVk?=
 =?utf-8?B?RVZvamd4RVl0S1Z3Zm5RVDhVUW1wQlczajM4NzEwNlZPTWEySEVDdkVYOUlK?=
 =?utf-8?B?UzhUNXpKd3ZZK09pTlRhRlZpVk8rTEJIQVIzdGZmRG92U0ZMT2FGcHBHREU3?=
 =?utf-8?B?ZXd5bDVwTkRicnJGT014c1JBYkY1cnF0YUJBU3g2VmtaWDdPUGVVSlYyNWN5?=
 =?utf-8?B?SmFueUU5b0l5blBMbFlTR3l1SUtrTVBETnp6RUxOdE9zcHVwRzhlOEJvR1hG?=
 =?utf-8?B?MFEyN1NUR1lrYVFjOGZIWVlhbkZRT2xTZFBJWUZ4ODZrVWM2ZVo4WUs1Kyta?=
 =?utf-8?B?M2ZCbDZFOEl6blQvdzgxS3JaYmpmTHpyUSs5SllNamd2blBqV3lINEo3ZnRL?=
 =?utf-8?B?ZXh3bHFjbENJalJrOTVFdnNZOVNDMlZHMkQveTZRMGhTOTR6Rk95MSt4d2ZZ?=
 =?utf-8?B?Sk9OVWI2UHROSjc5WVIwa0hRSUhvV0NxdEVza3FBdXZ3OFQ5eUNRSTFJbjZm?=
 =?utf-8?B?ZkJRdytrWmFGZi84ei8xOVBKVG1HemRJdjFESE8vMDJVbUJGeUVmSHRQdW1h?=
 =?utf-8?B?clB2MlNmbk16REZtb0hUM3ZJTkV5UFZ3NURCUUkrUDNkdnRQd1VBaHhUMC9O?=
 =?utf-8?Q?wf8g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RE95ZmpMNUZlVXVNcmk0c0xBZVRNRFAwMnJuUEN3aURVZUdwMnJaVURBK0Zh?=
 =?utf-8?B?bXgxT3ZyUGNNNU0zTVlxT0dvR1MyU0FXT1FQM2RGa3pPb1BsSUFYeXBhbFRL?=
 =?utf-8?B?cEJxdUEvVktLUmxxVjNsL1pVNGgxOGIzdDRtRTcvZDI0MktTY21tNFZoYmxm?=
 =?utf-8?B?YWpmK2xqNWhudFVaRld1QldOcWVRdE9oS1FrL3R0TGFoUXpMWDZIcXU4YURy?=
 =?utf-8?B?bEN6OXRFT3laOStwb0lyVWNEeUVHRTBSdmQzRkxuUWI4eW9kRWtFNU5vbHNH?=
 =?utf-8?B?ZnQ1VVVpblhoOEJZV2UwYjVpaE5jdDhKSnIrWkZxclZTa1pBbG5GUlhTTDhv?=
 =?utf-8?B?YnZDVWt4ZEY3eXAzTDRyb055OEhRb3ZydFZtOGpFS1BmWmZMenBKempnOHAw?=
 =?utf-8?B?ejdSdXY1ZnM0YVQvMUZDN29GV1pSeEVYcWRBT2R6TENIYTVjeHpxT3pNcHFU?=
 =?utf-8?B?aFZibFRoWG9GTHBzdGV6aUs3aTlvcFFLUm1zNDNtMlczTy9hSjdHVDJTZWZW?=
 =?utf-8?B?VEFlYjdDWVdtSDhOVFEyc01ZL0Z2UTRoTUp2cDNyRE1WYk13aW9ERXBOVDdD?=
 =?utf-8?B?SmozRkpUR1EzaDNLUVhRdDArL242T0NlZ1kvOVl2NXR6QzlRQkMyVmtLcm95?=
 =?utf-8?B?SUtUNnk0dGo4MVo1QVB5N0Nld3E4RTVsaisyc1NtcFRxdlFWMENwRDJwTmlP?=
 =?utf-8?B?WTJJNlREQWhTOGJoNnBXeEYwSnptVE1zYU1uWFc0VjJIYnc4cXBEYlNsdzBu?=
 =?utf-8?B?VHJCUTQxYmY4bWwwS1Q3dm9BeE1wRTdwcjg0UTFnUFpHUWdPODM3cDMxSHo3?=
 =?utf-8?B?QklBSG1aMll2dG9tc216M05QZHRUT1UzcnErSDc2b2FBZmFnWHFxUHI0cnJG?=
 =?utf-8?B?MjNkM3BqZUQvazlwMVNsOWxkVzE5K0gyUDVqcjZVOFg4a2dad3JjU2VMYU5o?=
 =?utf-8?B?WUg1d21vWUdyNkI1L09DdVR6dFpXYUU5MDhhalVaTmJ0d3FOdmUzN2hKNUxz?=
 =?utf-8?B?blpFTmJOVVd6Wmc5RG1tMXMxRWZqRXd5SDlXQktRRFZRL21XTFRONVlZaGl2?=
 =?utf-8?B?QVhldFI4ZG96UGorcUNrS1FDTTlHWURWbnl5amVjY0IremZlbXA1UnRmWk1v?=
 =?utf-8?B?UmlnbTd1MW0xeHNZVDZOYnd0d3Z3ZmJ6WVVYNjBzU3AvQVE4OFJLRTlTNVds?=
 =?utf-8?B?OWRySmZnWlJ4bXdnNmd6SXJvb1U5dGR0R2o4TngxM2FzdVlsTkJrUDdXK05P?=
 =?utf-8?B?eGpQRGE0TDFKdXUrZHpKT2lTb1M4Y3FsSFB6WGN6UXVlTnVON2xVc2p6WGZH?=
 =?utf-8?B?ZWRtWmUyMkFQM0pSb05jdlFOM3MwVGlCcEhFY3lLek9xdnBLY1YvOHJUUnA5?=
 =?utf-8?B?Z055YXlzUWVHYmxnYlNFa2FhNDJIbW05cWpMc3JDMUNpRzZiOWIwM0tyUjFz?=
 =?utf-8?B?WGV0clJ1SURPQ0ZQbWtJdjdlQ1BZU084bzR1alNUK3lFSHVxWFQ5WWU1UXBU?=
 =?utf-8?B?b1pOZG5lM1NHRU5HT0d0RkJ4ZkVYOGFLaHQ5OGErOWFwNEwrejJBb1BVSEtj?=
 =?utf-8?B?YzE5ZFJhcmZwM2hWelh3YXVWWjJmR0ZVd3doSE01TStXQjV4UWp5TFhsdmpk?=
 =?utf-8?B?T3lONnpPTk85N2RnVVlFS0lLMmdybG40ZjhSUVBNZE1LeXdTUDNRMFpSZFpR?=
 =?utf-8?B?S0lPY0hnWlJrTUlxdThMN0F3YUQ0K3VEb2VnSCtMWHpNdS9LcWE5ZXg0UXdP?=
 =?utf-8?B?cXFZNmdhZEd0WitzZU14ZVltMURtdkNaSEFFUlRHZjdIY2swdFdvalJxQThy?=
 =?utf-8?B?VmxKSlg2VDlGR05GUUF1b1hCZHVmZ1hxZktUaEt4R2F4R203dlkrZXZYRVZs?=
 =?utf-8?B?bXJUVTlMeUxNR3AwNnNPUWdXVWdlQW9hQjRxMVltKy96RkI0S1hQa1poZGlv?=
 =?utf-8?B?TDNFZURocXVrc0laTFBmR3UyeFN6ZUMxYnhGSnhETmFaK0w4SkRYd2FUWHBy?=
 =?utf-8?B?U2NhV09YalVSWU9GMGZwNXBZMzVidVBFbmV3dUwwV09xZ1NaTWxybDFMMENH?=
 =?utf-8?B?OGJQQjBiVTcwMmhGakJDNVY3dldZVXBsTnF0MXFLUUdRNkxtZis0SmRWKzJ1?=
 =?utf-8?B?eVVXcFV4aFE5MnlHSWZvK3lySTZSMFVUK1J4OGlidkpsVnBCNDJQWVJmckhr?=
 =?utf-8?B?R2EzSnVScHdGSzZBN3ZhaE1ia0diSmVBdW5PSE1RWnVHS0hNalczdEFEL2I1?=
 =?utf-8?B?dE8ySTB0a095UUwvcXprVUlnc2NjNXRlaCtHTlRzcS9zVy9EQ29YUnA4NzEx?=
 =?utf-8?Q?s2FcRZHWWKyoaz6Amv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e1e9fa-2bcf-4e82-1122-08de641212f0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 17:23:12.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jopkL0Xy7zqiOUjU3askVakr2+fi8Qd1UNTmS8JDj6nYxHVKch97RazvTCTY1V0A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6120
X-Rspamd-Server: rspam12
X-Stat-Signature: 4fhf45zzrat9x8ym1s59zcqxkeufq5qa
X-Rspamd-Queue-Id: CFFE31A0008
X-Rspam-User: 
X-HE-Tag: 1770225799-949234
X-HE-Meta: U2FsdGVkX18bG1B40Kamr5LM5pcN6lDfpogUbhg6QyLx6kLMBAQluFImIFHeD33Rp7UZxW7JpGifnkFx3E9iNCMsjCh5gHoxYDj23e+ObwcosXK5bzAzKL5d4SBj0+f3xVwSdppSJ82sODLLf6EgPteVeB+QgZLrgfVJwEKXTa5BfLuNOk6A9OFhAYktbQShJnwb49OZHU8UYT7KYy1jU+F95y28XnyG80LALggx6ezVppmpLws+MIdCRZwIE9xEkIcNCVvyPWj5XpngjEMmA1KdR1/dF1M2Tp4TWhxwSXae4FY1fZ12fqWrg7nIzJJjwJZpzkXElZW5pZXcYBEf2FchI1rnEGhqHQEIVDKKsB6w943RKIYYWgtm2ZrWAHKSd6gFi1llVwkcrjFiYbNZZ6s2EReuGbo+hlvtZBUXDtSsdnFZ3K+X5KXgxjmTFsCHfz+dOxnIdQSkhCcD4CV8ads3db+jlfeuQZQPW9NsQg1d2kY5A95FoIJ1+nLhHNIgK7liK6hwgjEzmxiw7KxWLqkYsJCHgaAXe64t3cLKRvpHQOvHAg7XMow861khCuYli3eGzabOFu+4qT6MIIHiZ5KRrCT4kgItFTxbp7TGB4Q5WNFO4cy+Scx+JOb/+W+JVoCaf9+qQiZiXGXwgGzWUrRJPKPbxxkLT2C2lZazDbjcLOMTz2YWhU/x35TKKksWtMSRGenfmVXbR2IUjJrwyE0iDA8JKeEIKGdwYdgUrY/BLQTSoEtr//H0Z/iC6jotcO0Bo9sm/yXSn34gUmozI0q49CY+B0KvCZvnTmxP9uUIzWGNUAnCsH7ktcPSoVOIc3NBAWMTLyVp7Iqd2w2U8JLR86J0qR4+ep7OOvu5aoxD/HI02ozQUO5Wnv32/f1EbBm5/N8bf3713SKWu8kG7RIGL/Kc4irBtRfKuCKcjygiIt64TEcS5IatLvznBKP2OsS6j1Ud26dQVhxxufZ
 W+47LK20
 ZdHDWJ4j+bwm18VnoxR91gCvzFF/KQI/jfqKHFXcmXf3ywg3D1TBG+1zEThshZ1BOcJdPfMRUOTAD5uAJfeAfXvsE7MSdAvKBk6QJbv9RN2RdLKut6tC68pedI2IoEysITXUHhcwP0VJNDIde3gugqLABWN79+8DShuQn4JBahEgs/GSu9MniJVk4mSH3gp6X0ihaRefWO3wyBB/aQn96FETnHI2Bz2dRjm7y2WsTWN94DXvyLpv12IGpNSSy80iHN5HWtGzZBCTbcK0LEBi7zeMySfbHjcl5D1qPqxF+SSX7XSCqcIFlH1iGX4SlXcMdAz/Q08SSu47gjrMszCk6QOA8KXb3MBrMyyq+taTSrl2hrNGer6jW3XHtXeKXs2+nrELfrAw149dapKj4mD6t2kr4CSnXfF7fwLsgSnEjXDXGSou1pgA/QAtvrG4xoAQ9pzay
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 12:15, David Hildenbrand (arm) wrote:

> On 2/4/26 18:12, David Hildenbrand (arm) wrote:
>> On 2/4/26 13:49, =E6=98=AF=E5=8F=82=E5=B7=AE wrote:
>>> Hi,
>>> I=E2=80=99m reporting a reproducible WARNING triggered in the hwpoison =
/ memory_failure path when injecting a hardware-poison event via madvise(MA=
DV_HWPOISON).
>>>
>>> The warning is triggered by a syzkaller C reproducer that:
>>> maps a file-backed region with MAP_FIXED, touches related VMAs, and the=
n
>>> calls madvise()=C2=A0with MADV_HWPOISON=C2=A0over a large range.
>>> The kernel reports a VM_WARN_ON_ONCE_FOLIO(1)=C2=A0from memory_failure(=
)=C2=A0and points to include/linux/huge_mm.h:635, suggesting an unexpected =
folio/page state encountered while handling a poisoned compound/huge folio.
>>>
>>> The target page appears to be a compound head page (order:3) already ma=
rked hwpoison. memory_failure() seems to reach a branch that unconditionall=
y warns (VM_WARN_ON_ONCE_FOLIO(1) at include/linux/ huge_mm.h:635), which u=
sually indicates an =E2=80=9Cunreachable=E2=80=9D/unexpected folio type or =
state transition in the huge/compound folio handling logic during hwpoison =
processing.
>>>
>>> This looks like a kernel-side invariant violation rather than a pure us=
erspace misuse, since the warning is emitted from an unconditional VM_WARN_=
ON_ONCE_FOLIO(1) site.
>>>
>>> Reproducer:
>>> C reproducer: https://pastebin.com/raw/UxennX2B
>>> console output: https://pastebin.com/raw/wrhKRwZY
>>> kernel config: https://pastebin.com/raw/dP93yBLn
>>>
>>> Kernel:
>>>
>>> HEAD commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
>>>
>>> =C2=A0=C2=A0git tree: torvalds/linux
>>>
>>> kernel version: 6.19.0-rc7 =C2=A0(QEMU Ubuntu 24.10)
>>
>> @Zi Yan, this is weird.
>>
>> We run into the VM_WARN_ON_ONCE_FOLIO(1, folio); in min_order_for_split(=
),
>> which is only active with !CONFIG_TRANSPARENT_HUGEPAGE.
>>
>> But how do we get a large folio in that case? folio_test_large(folio) su=
cceeded.
>>
>> I think we rules out hugetlb before in that function.
>>
>>
>> Looking into the full console output, this is an order-3 folio (fully ma=
pped).
>>
>> How do we end up with a large folio here? I am only aware of that happen=
ing when something would
>> allocate an order-3 compound page (not a folio) and map it into the page=
 tables. Yes, that
>> is nasty and can still happen, not sure yet though whether that is reall=
y what the reproducer
>> triggers.
>
> Looking again,
>
> mapping:0000000000000000 index:0xffff88800fe2e600
>
> At least mapping=3D=3D0 could indicate a non-folio thing.

From the C repro above, syzbot opened a dev "/dev/sg#" and did mmap on it.
Is it a device driver issue?


--
Best Regards,
Yan, Zi

