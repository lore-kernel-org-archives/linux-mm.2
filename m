Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0874EFCE47
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 21:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7C06B0005; Wed,  4 Mar 2026 16:54:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B526B0088; Wed,  4 Mar 2026 16:54:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113826B0089; Wed,  4 Mar 2026 16:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3C496B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:54:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84B2459664
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:54:18 +0000 (UTC)
X-FDA: 84509734596.11.8541301
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89B531C0004
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:54:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=onmjBIX7;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772661255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cZCVqPasNCi5EjChBF6O3aNt8s94mRxhy5reJB2Uvk=;
	b=R8MFCh+KCdwnMWponoFeaMzxP1wmc8yEPtBlFimIUXoLLMJv9hocs12VJH4S4sBa2blglX
	3y+B+/NP5G+miAv7lRaHwZ9yHV2Kd9PtvFZiALngYWJ2D2c7zC1s+6IiIzOKU39O2DxuQM
	2DEJpQbHgdO5psrcHoSKtTazcJxNREE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=onmjBIX7;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772661255; a=rsa-sha256;
	cv=pass;
	b=i50lYgIKkl9vP0uXSKL445o24/mpRCVtTnCpJEZQ6PCwHOF46UQErL5N2j+yUkmcY7nqpE
	Xn5qnvPHJ+DjRyyGFLkOtSd/+EcAj01VLkJsq8arCwRAVoTM/dObM/66vrJAVltofU1hDj
	9zRElD/LI8D/iXetqT1Y3ymGeNH4QBU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q0Z2FjVgek/NjRQonDHksEiQK8m3tX5Hvtoycjwq7Qo6XOSlX/xEDcAizK7qgtDfBESt9xVorYLfI+HYVp196tkaREv8TVKF38kuT94/SKGWLZ5S6EJLDDjwKNrjJblYJybxmOYaxI0cpDp0Y3yUdZ3/BnUugvBZoPFMuse9VpXEwooVrJWNxuBjlult3cDdYZwsipqu9xN6u98EO+icvGX3ZzDdRFX42xaEqcK0uxebvtbWYUBeW0qAMNRXKwui8CmvSEv4SpgNQiP4Al86fGnJWSAdV69VKWf1zbJyFMqVHDbJA2rkdbKmY4Knl8f7UDLIfDYRvZqZBi9FNAM6sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cZCVqPasNCi5EjChBF6O3aNt8s94mRxhy5reJB2Uvk=;
 b=MWF1AmH9jj3bpsyxO3mDJJdt/73IyEIbWJvOIMSRTq1JBihQ5DK/6JkrtXDs5nSfwTY9NjVm9NmY1GVwuNvZyD/e4tfPoZ5P/F3JDYxVI6qfdI1q+b33R1XzIg9zxUg9x7zALfAZkX+Id8RJH0t9LoN268u0OaUA3gZJYZMGPrE6Q2d8PPvMqqkkrvCvTX3PfEErep8KEuontnosD6a5c1CoNvRu4d/5e49HlN7k5SxWn/Kh3E7NH+Y/Lpth8hw2/GHfKONtzIbHXX3Z8GU+KVCj+4ovfrKMg6+sMDgtDD/LzkWLpYYZVeMaZVh3N+rRgYXGL/u+g9KVochyrcln0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cZCVqPasNCi5EjChBF6O3aNt8s94mRxhy5reJB2Uvk=;
 b=onmjBIX7X9Fn6BydqQ6bHza1LhrE0fBzqLEpOV86ArfIdraMIpKGmuT5mLtBzp3eMTyYeJRd7tntDTY5lFMdz46ugCYNERXd9KbfHhjCladhl+lx0mtcQQotgSCzwRSMz5fIi/F9Zqu3uV8lWxvTRuNwaOwFFhTZMvV4jJGctrYofGosrzPsitHhPRDxPC8ufvEgPC/4Ib+nVD60y5/Rz/Rx6qGkiiiT4lDy0Ljo/DSLB2mQkf1vcPDMc3XlJ5NyFz8LyvEEf3PwccBpPFX5C8Pj+lMl28mA9dJaCSmJNZBbEXmgoJmnYSZJe8KvGd8/kTOulKwWxZxyFQ28NOMlPg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Wed, 4 Mar
 2026 21:54:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Wed, 4 Mar 2026
 21:54:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 david@kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Date: Wed, 04 Mar 2026 16:54:01 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
In-Reply-To: <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR08CA0063.namprd08.prod.outlook.com
 (2603:10b6:a03:117::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: d43e3562-3044-4156-953b-08de7a389023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	qD5nB6zwCthRnQyKtvUT8ZGk3BVGs2TWZyx0kBwC51OYx/KdcnxSMgNEwlpO5pzlJNyPdn0ZvGRAMwlruFKuWfk/dDJsZ/5AscWSRp9NmX2Cy7Z2LHlv43LS3jo8f4iA/BBjWGijOFlKCr28N0H76F5LkZT9zY8Aie+UDEDowFnA/STmkq5KMTE/mX+dLPmNkxrS4qwFUvtSH8OFhme+fUL3laZM+4P8/Beg4Y686VCDAP8A7i++hQnqz33HMobK/Hl3+Ov2R/up/cjjeE6RvdLdb9PfLsmz0XlLDWVaUFSq64XNoZfBzDtR+ewzJstQ2QN7zL01jiUN3AqQ3Bnk6xXaRS1rqz5UZ1SFA8NoTpztQlh7LsHn9PzL1pqjn5oDL+spoCjmnB1kidsGITa9Vh9+eS+Lp0qWJBZjm5Oaiuhqv2pV3XTJgygxIEHKw65BMQZWt2H67TuqSZz8jTg9TskWGN2JPYxYbMEwZ3RVp/RyqxLppOiTVj9gWzqBMQDxQEf4ntelfC4chxvOvRhw/MrFC8E8eRpMwUwcyXASr9o69xhHuqC0/FyT65ugLc+pyBNPQibzmFTm3COn0CyCKOf7kRxIPutp5m/jglx6rKr3wdhUcdVL4vyml0y/uSYS2d6n/0DrXf9YJ3MpgnPPMi0pk2lNRcox89FuULoaXRqQIpv930epJtumXc10JQm8QEccO58VN9LQrKoT1Ng9xZJehbLtCTykqtJfO0iDRVBrYELQt4PRGdRQubrYJop4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWdKSzhkSjRyZUx3QVZickNLVFlCZHhEejJjV3JsTW1PRXMwQ1hIRElLNXl3?=
 =?utf-8?B?R2x0MVpsMThVNDBVdkVNcDdFYStHZFVDUi91YnBIWkExcDBEay9jdFhDZkhL?=
 =?utf-8?B?MG5lK2xNT28rNXcwbzk5Q01uZFNhVlRxbUJpaEhwS043RUdlbnhGdDN2UXZG?=
 =?utf-8?B?Yko2eXRxTk85b1hWLzJPdkJYTU91RlBEeENKMkM2QTJoQTJlRVgwZ295Y1F3?=
 =?utf-8?B?R29zeWNtblR3QXFDQU1uZGFydWJ4UFU3cXJKUnZjV1JBSFNmdThjT1ZhMWJw?=
 =?utf-8?B?aUhndGVsOGhYTDJZVmpvU2J4MFVOdlNZczU1ZTNMb1JmYnZtZjdqcW9hN1VB?=
 =?utf-8?B?MVBPajdGZnlaeGdsUEh0OUR4cGFNRlVibHFyQU84eXNMam8yc2tXK1BWLzBG?=
 =?utf-8?B?bFpTSkRVRXJuNGtjM3FScWhyVTU0cXBKcW9pc1cveGdRVzhrZDB1N3hJVGgv?=
 =?utf-8?B?THliSW5JMWxKSEV0SS9zbGM0V2hVTHBLQWdlbEViVHJKKzNuMzk5Mng2ZUNo?=
 =?utf-8?B?elRpWE5QU3VoOEpVNElQRTBYTW9UaDQ4SjAxRWtxNndzQjZLYTNNWVZucUlh?=
 =?utf-8?B?dit2WEo3SkxMK08weHBCdTN5MnhxNmNxTVpZZlhUdjNvN1dBbFZSUUpjanhK?=
 =?utf-8?B?U3Q2b3pha0hEdXppZyt3VTcxL2ZaSE5NL25MaEFMSTkrbWZ0Y1NuUGovTGk1?=
 =?utf-8?B?RjN1anFaUWdicm5SVTEvWEhTTlBiNHdCU3U4ZXpFL0FUbGJiWkQ5K1JWZHJH?=
 =?utf-8?B?ODd5R3FDd2RxTXQzNHE0ZkVDUnRKR3U3QTlFUGtmQjR4S3VHc2xVOVFab1dS?=
 =?utf-8?B?UzlHamFPOUIyVFRzSFM1cVI1cEtzU21rcGVTSHlOK0FkWnFnVzFSekxLVFZv?=
 =?utf-8?B?ejNLSTRHcVlGUVh0aG4wZzErUXk3dE5KWk1uWktHTEM5MXV3RHVOY0tvZ1dT?=
 =?utf-8?B?NmVrWnUxbTlpcGF4VXNVWlBJaC91R3NwUzR2bncxZlE3bjM0U2ZQRlFwTDZR?=
 =?utf-8?B?ZnFQZnlHMENhejErYzl3aXdjcGVBejFVeW8xSnFuOEdCdjN6UFNCOTVlUTZX?=
 =?utf-8?B?TzVxNnNMSkplOWJxZGJQd2xteEhmQVBuT0xZcGVxYXJUQ3V6TUF4aHhqL1Bv?=
 =?utf-8?B?eXUvb0xhTmFjdVRDSjdKdjBSRU9rejVqOFIrNHo0MDNYanhJWkc3K3l1RHBV?=
 =?utf-8?B?UFVSL3lMdzY1dnRieUFYZXRuNWlXNGJ3V0pMeVFKd2RmcjBmSGJ3SWhIYWlQ?=
 =?utf-8?B?VFY5NnZXb1JlcmpGNG55NmdJcVdyWmlBRzI5YlppMVRKcXlSTUwzdlVOWDBy?=
 =?utf-8?B?NlBINFA5WURxZFNERlBJWlFBTkx3Y0F2RjJrNVJMRlNiSEtPdFJ0Nm1iY0s2?=
 =?utf-8?B?cnUzdzc4aVlaS3BPeHN2UzU3azB2dklBQk5OV0VDdDQvUlhldDJVc2JJTGNo?=
 =?utf-8?B?ZEJVM1NTRkNIQXJPVXlhUTJkRi9xNXhhZ1loR1lwcVJqa3pUQ21XelBMWWds?=
 =?utf-8?B?SjhJaXVmYWhmWmlNNWpuVGFkZWlzNkhubFRDeTVBWGhmdzVCT2pEM3Y5ZGFF?=
 =?utf-8?B?S0dTY1Q1SlZ4VXR1TVFOS3ljR1JUaUF1QmFSQmNKZXRIYzlPUTVjdUk2aHNN?=
 =?utf-8?B?ZGxYL29IMVVlOEt0Z0tWMWE3NXBBTVZmVUdQbFAyOUdKVzhNWFFZdU9CL1pC?=
 =?utf-8?B?dE9rakZxaWlLZXpnL3hpSmtMelBDMVltR0hEVDlzSC9kelVqRHRUdVY3bHl1?=
 =?utf-8?B?T2xVNEdhM1FjUDJ0TENRbjRRT245VFNRaTZyQzNaN3I1ZmJVYzhSYWFJb2Mx?=
 =?utf-8?B?dmpqMGVNZVVTQ0E5cXNtYzM1bWNkcGkrL0RJVVN1dU0yWmx1Y1NhSW9nUExw?=
 =?utf-8?B?dFFUV1hMWHpXSjFSZG91NEd2VElkV3RXM002TURVUXVwM3J5dDVZZFY4M2h4?=
 =?utf-8?B?ZlFwZWpDZGdhQytMNDRSc1M2V3BjMDJwcVczbTdxUkduRDY0RDRINVgyaHJU?=
 =?utf-8?B?Wjk2eXd2Rlpha1VoSE5RSThTeG4rdXVOaXJKZmhLeGxySFVHOFVlQkJGazEx?=
 =?utf-8?B?N1lrUXVFbnV1MVhzYlI3eGNmZ0JoZ2haYThjLzhjVWRtdDFiSFFEM2h1bUZB?=
 =?utf-8?B?UElXR05TR2lJYXVUU2wyeXh3L1hsai9JSXZzcUc1WkFtbXZRZGJzMUZhVk5q?=
 =?utf-8?B?Q3lJZGg4WWJkbkdSUVU1TE5WbDhUVlVXeUlER1BwcWlXb1JManYyZkl3Lzc3?=
 =?utf-8?B?bXh5alVwRlpuVHI1WmlNbWFVWWxJdnNkeFBlRGt4ZjFDaGprN01mcFFqY2xu?=
 =?utf-8?Q?lohoFMiTW60eNhi2JU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43e3562-3044-4156-953b-08de7a389023
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 21:54:08.9531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owNOcjY2AxDhC5ymLWhZVaEmbMBMdigY0A9SfTvWBuMife6h6FGzQzuTjNJI1aAa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956
X-Rspamd-Queue-Id: 89B531C0004
X-Stat-Signature: fp6y8chqeommypg1ym8u6scszztzhpmi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772661255-685995
X-HE-Meta: U2FsdGVkX19JRvbkIokpMBsUsd3ofbzeT6g0lg552QCj87eDkGTTND4RSXsXQ/DCXKcyqU7TZBZe8B/M5vI7IlZeyeHGLafdhGtiSH5QMpFuSgJVOB/imlmwhwOGXs6beRk8VbauXp0KfrskMR/GjUXQebYH7pnkj/FWj0aJqbHPfvuSXBdw1Ct53f0Xab0BX3WFvB013+u/c8oHnNr9SHUmE4Aim/R4ge3rAxpsN6NGzaq2Tvso+lLlkFlKvYsHKV53Zj4VnZOb0D/PubR2tRvjNNyTisRRHkkAvcvPHqHKcFxbEC+K76Z9ClM+4g/XDnfBf4tM71dRHW9kxL4TXsePZXSExAOJ9CedChU+QawKfikp25KzXBkaTolamkuc7Uz02Aja028R2D2goyaFPt9CA8znzXBpX7L7s+ravq0Dcm9+7IgfSJ9JQwzJL3pCgXdahKemL643Javd3omBT7oIQm+zN2DV2we6ASk46hOrBpd8pUPhAgPIQ2DT8u3gcWbgt7MwxsQ32+Awi8ZCh11fbKEYKGffDTu2E/NVmec6du9v8KpFqNaTC1spwdeGjaBHBR+EL7b7RCWAVKLoEmmqnMdyMniHVKUbh/t5Ht8WirrgFF/FYszCmeudINdE6vPDkYdag69y5d/GM45dNwEifUeAU2Wz/aspe9zgsJEsR2lMH/Su2Onbs3VEFgifWcbwgfLNYiMAzFFfOOVrrAmxsjFdgcEa3rQbAiJY9ahj9c/do0NYoMPcDUhItcgfTP/g5AEWV1sir1mTWfTzk30VNfBV9qB/6Q0jnlj2blu6BFdjz5pouDQL+Hr4uTWnAn2l4qrXwtoP81YzsMVvFOCVM7hfkzVV8xLdL5wyWCbETroD+k/CYSZED/nJBVXVVb5EoFDqHLbhbN+l2BV49MD86OSPCq7idNTTUV9p0ShpWGCxod0O/Q0B/Ff3JoYpNkB8wrFZ36fsQcIDmPV
 rVonwLQD
 hnXhRSxX4s+zGR0abYbHBfysuZdJ97W5sVa3W26E9XwUGMYU6Vq7G81jthQ5w5VXSxggVja+WvdeAp9TC1EnbRR17OBe3SLW2X12WfW+fkYWWbpWs5aRQvXvHslCuzLSSVhGpkswunRO7UrBOfDdc6+4TE2NMvQN28TxbJiyJXjFcerW04kK9/+QH+Gf6uGvoumgX15n8Lx1ELxQ5M38mD84F0jfsXqKAJBcIst0KMYRJv//Zwi2yHJtr5ZKix/XkbfnZxhb+oaLloFdYYC8gY7FCahsQIOGw+shd4sH0di2SwRJX8MeikDr1Kx7IgqAwNYEIAGDwU7iXBQy+rThuJF8S6WSBj5WXgeRncSpceDHJKS+lIhYX36MKZj7fBXPH/BUNMJRAuRonAD8UyANXSqn8Vme2N1nm4BCSvWkxhDQGmVrqVpQgkRX0jSJUDFvynhnDUf04kUkDL3n6S+Fc5hSpBXZu5xtN6vEsLhaG8LUHEWD3DnWJdBQbAE1WB3YBFb5C4E43icTqmdQBBtWTVLbFzyMiKJmq2Tnf3otLpbRI6T0uBvO17Q7toA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Mar 2026, at 16:48, Balbir Singh wrote:

> On 3/5/26 02:17, Zi Yan wrote:
>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>
>>> From: Usama Arif <usama.arif@linux.dev>
>>>
>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>> folio_get() before calling folio_split_unmapped().  On success, the
>>> split consumes this reference: __folio_freeze_and_split_unmapped()
>>> expects the +1 in its folio_ref_freeze() check, and distributes it
>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>>
>>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>>> -EAGAIN), the function returns without calling folio_put().  The extra
>>> reference is never released.
>>>
>>> Add the missing folio_put() on the error path.
>>>
>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migr=
ation")
>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqV=
sVxq7DhOUB=3DL4PQA@mail.gmail.com/
>>> Reported-by: Nico Pache <npache@redhat.com>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  mm/migrate_device.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 0a8b31939640f..351ecd9065d13 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct=
 migrate_vma *migrate,
>>>  	folio_get(folio);
>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>  	ret =3D folio_split_unmapped(folio, 0);
>>> -	if (ret)
>>> +	if (ret) {
>>> +		folio_put(folio);
>>>  		return ret;
>>> +	}
>>>  	migrate->src[idx] &=3D ~MIGRATE_PFN_COMPOUND;
>>>  	flags =3D migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>>  	pfn =3D migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>> --=20
>>> 2.47.3
>>
>> Add Balbir, who wrote the code, to comment on this.
>>
>
> Thanks Zi!
>
> Just wondering if there is a reproducer for the issue and how the fix was=
 tested?
> I expect migrate_vma_finalize() to be called for folios, even when split =
failed and
> drop the lock.

Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
If so, how does it distinguish between split folios and failed-to-split fol=
ios?
By comparing source and destination folio orders?

What we see from migrate_vma_split_unmapped_folio() is that
it adds a refcount for all input folios, but only drops a refcount
for the split folio. Isn=E2=80=99t it cause failed-to-split folios to have
additional refcount?


Best Regards,
Yan, Zi

