Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9720EA4FC9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555766B0005; Mon, 23 Feb 2026 09:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5037E6B0088; Mon, 23 Feb 2026 09:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D79B6B008A; Mon, 23 Feb 2026 09:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24AEF6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:28:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B02F91BEED
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:28:00 +0000 (UTC)
X-FDA: 84475950720.21.B4C5B24
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6DA3A12000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:27:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="XW/hRZ5l";
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 52.101.46.22 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771856877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4M0bto+fSumVxsJQ0r0IFQ8RsFZIaHQ4rvRjEXNo64=;
	b=jZVtwnOez8GjP98ra0QUJGBPDg2eJZzKumO9QZh3UICLJFiUH0PF3A4bua/kVKNU7xMtWN
	h/3JqOO+0AA/mwNiNhCs1lmgrb1KhQwyYaLEFsSuVMxFl80dsrlvKkw+ROSZ+I1SwX215V
	y8DeCch8xRm0dgMn/WfoS+J+1VmEbak=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="XW/hRZ5l";
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 52.101.46.22 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771856877; a=rsa-sha256;
	cv=pass;
	b=gjUSpDU5/38jnGfY+sqkL4ZOeIMAHZWiDPgSJa4XqA7/N+EmCm1do3q/6RYyNL7HHsgg4D
	YiOPnJCDa07n2i6EnO+RARdyzAQB3osSN1mhXgD0hUqcFhGP7VGSmwDgpivN507U6fKMWF
	JGB51yANB25MvVuaKW0nogeLx6bMAUw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EsmRSKwMxMwb6YyZKlFkfaSUVamdJNlGd9lWUq5CWHiZGMjzQFE/MAeHmdi1Qgk1nNtPK4EJHdNHtsRHpL1kI1ihKDD3VCVp6kWNa+xynhd9phOKdA+R1qHLa8Bg9bKvIEpovhS49JQOoGxaoUL2WahDsyeG/iRLMBR7/uefj6x8cvV5Wdxmh0HI2c2xf8XwNW/DTSdhrWh1xH7Ak0NSpN03EAE3/8I4kep+Z+CIofRYGbeLwv+1l08epZp4pvJcZwL2uhuSN1bQGNemIvMO1Z8bwFBej7jxlfzwtIsbHAhYTPzq/X3yxI62Lem94pPzMA8Za3Piynw4nZSWDXayfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4M0bto+fSumVxsJQ0r0IFQ8RsFZIaHQ4rvRjEXNo64=;
 b=wPuOOnls6f3Op6tiCmvT4Kk43c3BPDSsYzp6RRZF60/yBtGclwuRmg6o+q17CkH4L8kq6b4UdNrxhH2KJSJ0tHHEViTgglNONVI38qrELfnZvltzIoT9Dv2uBnwFGOklYuG542PwUPnIEN7YZwyJ1ruVGBbdsxXqtWut64pgzP+iKsZqftZ4/h5h5Hc1jax1QtFvqtJztVaMljx0D6BqK7y3mopIUzfxVv7IsQOTyWOwCrMzJ2WskR35KSxWgy9uGvAubiIsmfK1IlgoEgcml+dHVHiQCGna4JHGHe6wFuloRs4hgaDdRfro7d9ZkcKSdh0rv5IJMjKhZDH8OoEG9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4M0bto+fSumVxsJQ0r0IFQ8RsFZIaHQ4rvRjEXNo64=;
 b=XW/hRZ5lgHpxXQ6KP243+iW4Row+xgHawZeWiAJ38eksuvN2JgcUqRd6bxefIkuVqaI267f3KAIeOCd2zgTHE4HV4TTTcy+nzLslwhEKlHWgFHn3vzYPc+tBV4krlR2DYFTTY1ZlIQB4W47qmLmRvkO/f9peRYZzsqsX+fgjxQ4=
Received: from BY3PR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:39b::19)
 by DM6PR12MB4156.namprd12.prod.outlook.com (2603:10b6:5:218::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 14:27:50 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a03:39b:cafe::79) by BY3PR05CA0044.outlook.office365.com
 (2603:10b6:a03:39b::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 14:27:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 14:27:50 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Mon, 23 Feb
 2026 08:27:49 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 23 Feb
 2026 08:27:49 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 23 Feb 2026 08:27:40 -0600
Message-ID: <a8d1efd6-2ca4-4f1d-9c0a-c8aa17732ee9@amd.com>
Date: Mon, 23 Feb 2026 19:57:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|DM6PR12MB4156:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e2aa836-c8e0-45f8-0fa2-08de72e7b931
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M05SdjdEZU1admhLOEhoVEh1T3hINzl6VTlkQ3pINUZuNkplM0htUTVtb1R5?=
 =?utf-8?B?VDFPVnZWU0huMFNOM0wwNWZyZVR1djhWbjNNaWNJcjZsUWg5QmJXc0l5MjhT?=
 =?utf-8?B?a2R2REowNW5VVjBSR1VEb3h2Z21FbVJUUjdoc3NlTDRCZlZSbU1iSDlrZVVN?=
 =?utf-8?B?TU5SWklmVEt4bk5MZUdyZHUrSUVhUEVYVVkzd09NQTZ6ZGt6WUpQK0d4bHFm?=
 =?utf-8?B?WWt1QlZ3K3ZrUU1BVjI3ZklrK2sxa3NFUXFVZFFqZ3VMSGNFQ01zNXowRWhx?=
 =?utf-8?B?a0hLUUZBVlhBbHFSYlZpREpIdFNQamRuaGN4TmpCRUovb0lQaFpmNFIxT1d4?=
 =?utf-8?B?d3RPRXNMY2htSkM5c01oaEhtK21sY3RiTE5DNk1EbUl3SFlhcEt0WXlBeVFU?=
 =?utf-8?B?VW1nOU9IMm5zdE5LbExtNWpoRHIrWmwvVEFNOGl6VjNZcVZJVGlHT2R0ZlF0?=
 =?utf-8?B?VzJGNlhWVTFlRlpaWWxkQWs3ZCtocjhGU2pmZjBxZG10bTdjNUZuMXFVWERq?=
 =?utf-8?B?bzgwUllRdmZoejRxSEdSaWhsMjFrZ3VEVXEybkx4U1ljVDZ4Z043SHlDSE9l?=
 =?utf-8?B?R0VqWVVNZ0FGOVF5QjQyNmRNUklJbzhZaEdLSmczSnM2MGlnK1lSR3VHZ0lJ?=
 =?utf-8?B?dkZiNFJNR1ZDNVAxYlZBRnY3M28vUDFBQnJ4d1MwRHZmT1MxV2RCN3JyK3lI?=
 =?utf-8?B?UjJSVjdxWUNIeWpvaUoyeTB3Q2IxZlFudFRVYWptdmp2NE0xaHV5bjB4eitZ?=
 =?utf-8?B?THpKa0xJVGt3SGxMQmszeGtOUEVNMkJPZkg5R2pnditZSlNNdGsvUHpuUDVt?=
 =?utf-8?B?WFJRM1oyNkRDQnZ6cC9ubkU3SnppQ3kzcWN0dTRUajJJcjk2V0tHa29qSzJU?=
 =?utf-8?B?U2Vud1BKWFdpdGhXbGhzOWQ4dWVmbStUZ1pKOXUrNHhiZkYrSDJxSEtwOUJi?=
 =?utf-8?B?S0NuZk4wdHJwRFlEbmNHekprVVpxRjU2bnZTZWxJNHBpQzc2engrM3ZWWG93?=
 =?utf-8?B?clhIdVM0a1FZV0E2MmxxUTZOWkovODVMVW5tUnRPbTMzREd4MWh4MHFwby9I?=
 =?utf-8?B?K1FyY0V1K2NuSkhqaVB4anBrZ2p2aEJKeUgzcXEwOWFqT1I4QW9zeW9HK3VN?=
 =?utf-8?B?SWRJQ3ljbmZWMlZzS3hGSW5ZOWt1MTJUekpOU2VlSWYwMGZublJhcVJMQWw4?=
 =?utf-8?B?dGtWcDFFdHJwWHQ1YjJvNE1kMGw5WjNDb1UrM0J1d3hrWlkza3F5akZtZmQ1?=
 =?utf-8?B?QVhmOU1oRDNCaVE2a1h2ZzNrYmd0R1ZZeEN3QzdORjlxNFRtMzBya3F2MUdC?=
 =?utf-8?B?ZFY4NSswZjNMbEpJeFZTZEJVSzAwQmg2S2ZUT3BjWHNnNHcyMXRuS0c1bU1G?=
 =?utf-8?B?aWdtTDNPaElhMnZQc0NLd2RmUVlXRnNnVlk5RUVBOEM4RUlUamJJbDROUDVh?=
 =?utf-8?B?WXA4YmtvbE45elpmZVBLeURoMjlGOUN5cEJ3bHltLzJtTEcyR2RxbktCWFZG?=
 =?utf-8?B?Tmw0bWpjYTlXZ2djNmlCZXpPeVFsb2RXRWwzM3dFZXhocWhyYWFaZi8xNlAw?=
 =?utf-8?B?MVFnVzREaWtCZmZqc2E5QzY5TFREbXJpQ2QrZVQ2WDhhU1FRRHJvZ2pDQXM5?=
 =?utf-8?B?NVl1MXBVUkx5UUZ5b3VzeGZ1dktscHNNeEIvVUY3U1FRd1lFcnd1VytqL0NF?=
 =?utf-8?B?NnJOVjM5SjhBUTg5RVBtZEdsZXA2bDZ2Z3g4ZkxKTE1JSU5TKzdrMVMwRTRq?=
 =?utf-8?B?bnd0eTk0dlBubVU3OHJEMkdHUWdKRjl2ZUozRkRGRk5RNWx4UnpIbTN4QVBK?=
 =?utf-8?B?T3RMTlp6RTlWK211ZE9lZVM3c0hWNkxFNFpSY0dmMkNUcjI0dVRTZmNvQTND?=
 =?utf-8?B?c21LcC9yYjYweFhqNVdOVVZmZjZuQlIzS1drR3Y0L21lY1VMWG1rM050UWlG?=
 =?utf-8?B?MkJNUmU4bXB0YmlKTFRnWWNGd0pxZnRmMkRBb3QwNlNTOXlrYzJjcm1OTE4y?=
 =?utf-8?B?dEd5V294YytxT3dlMGtmb0EvUEIzK0VFZnNVSGphdXJyR1o4dHlGbEJLRWhz?=
 =?utf-8?B?T1BmZ2cwdUtURUM2WGJ1dmpSU09HanhlYUhWaGt5QTgxNkdsVVhNd2NveEFS?=
 =?utf-8?B?VTBQRG05Zy96QTkzZU9SM0ExeVR3eVhFbEZNOHJpYUdHdXk0MEk5cm8rL25F?=
 =?utf-8?B?RU54RkFwbHoxNXJOdHZBN0lzbFcvZzNUOWp1T1pTUzQ2SHJWR2t2L0NDWEdj?=
 =?utf-8?B?Y2szUGVtZHpXNk8yd3RzTGx2N2p3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	emRfIroJVaoZ1aXL8Ob19SMYJ8q7+xGRsNYglDlgDO07VoWyBVE3AsqPoVRQWuwHbXwxG/YM1Qd6Kdsww8MkQ/wxFHoAmk2Vz97w1TrmCYCdB9hx5WuCR4f1HImDNnlEruSltoxkGpXB/vXTIjJJsIGAOMziVWaaMIRv7sBjfmAFwVUkdQU1+nhNQNOVEaTSSE9SKZcLwAkOV8YlqV2liailEvzXo9kZIJZ5ahHtq/njW5y3ORM23K8aUXClagd7ECrSOFkOkvEDBMjpbPdJZ30WcwedG5e84sfQN05gfgL/kp+s1yCnaQ1jPnI1yGt8b6itolbfNXatM+4XPUtm3fmNahaQGIma/E1IkeX6+NTyJsCd01JotEEL1L0CFaBXkEOp+L9jjD7ZDX6UQGY/wn7SoM7Vp2iUVc/POL8GavhNqfAK3cIPQoaI/141F6wl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 14:27:50.2373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2aa836-c8e0-45f8-0fa2-08de72e7b931
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4156
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DA3A12000B
X-Stat-Signature: uieku8bx34rweixrn641ofxzcdxz6nmw
X-Rspam-User: 
X-HE-Tag: 1771856877-999020
X-HE-Meta: U2FsdGVkX18Cz7HVXGnfP4iY1ClsqEvqiegEWbvO5HgGsIvZG10RJLSnJGViKSSVouYqibndg5Iyrzr0TTLlAC1JIW8TIsZKTRuHA5zIvOIOX7e7Fuha4ynfaL3hISF8ysYC2JeHD96+5uYhF6RtdZI7JGwb3iRZLfm2xuKy8t9KoNC8TWoTNRGwPz8D7Cc/rEi/h1owhfOqT4aAHGjZ2yR6avcGvzpy0XzCaYJ9J1ekI9SboGUMHlTUdZ5H+0nuyt/7QJDr2nhVucjBSJnLwTacIOYz8fyZ4mHpWpOggmn8k8k2UTvlJzpvG3mlWaERJ7y5b8zmgempzUeQ79SR0D/X0AOOzkquDgUYoGrw1AIkk4lV5B4XKpjTk2KzGluXtix0uKZpDLNybKh6g2MqJS4O4wG4pOMPTje4VB3O7oAzwMsxhfUHLE8K7wrv8ujZbi86StqG8JOhAxFLeCMa2IEgfc3Yx26Vcdg6QMO3S5UM33b059+AHuWPAIua3muJTFkC7OMyzTSn3wDa9Bg2oINeUN7ceLGPed21TOgXLv3gWV3yHNEArwkIkq3hCj3uRXsrAeVNJnJ75NvUUWTt0KTWth78FQQtEWKK3+tzazOFzIEpxJOPeI2Qk/Jcar5uYhPuN2+AWfYGP7LDSIcCCxvIO5c6HkvK1g1vs5ogN4304LaAIVRc7a6nxll5ibyrFTSv1qt6vzTMw28F/dHYRNT2l8swZKIJkKZup2M7PZw9+rYzNCtjEYynqWphBTuNPwAkUt1+HVM9TR9p2FiaCsVHxvYKxjjmy5mmmKTaLx5emqNDMWIFH+/oGTTH+J/hxB77uFy19DOb0hmIKtVJee3+qs2v9WRXr5tRlMzL5UAmqQzPBehcu1UcoNVf2H0cquEVt8xXnR6xUkIRzV3vGvqSgGdAkp/mN/7YErmdYXA+8CffqD2mPy41LnQTI4UKXM6AOM2+ve75SrTMUpz
 nNRp5XS4
 MNER8AaXOK//QMmqJ94ofRb0ZDe3AxfsyrPwgvSGVAZ3Mt/bLDdD6kfd1ti+WSKnRBSmdzv+JqOAsJPIlMhCLfsmsDMDkK9lWwMLX1RRKO9W2R4XYeLy+FSdxWGIoDa24daEe99zDUcR5MzdbPyq+jbKMNTgEKpLVra2hf6XBv5HLemxB5lHFG3oISkxNsbBOKaRLkASG0c01lA68NKKebmBj4lDEKZ7I0r9yAYyJvRkAhOJIo63nzazwMFqBxOWV7SVG9sOuPDir18tEs2uvhhlv74oGok5KJ7NcdbRvtjIEFtqs6giJ7RjpgOWBeewNE23B1Ba6I10SvrGlNx/oobrF0j7jKAPIbXYWtvMOsvtNBmR+fQRFPmfaLcLtIXvBrukG8QeGP3Iun5FgV0mrv64nCJ+S8nFoRnP2UhdDFEtkbzV7ahDbLq7yDlAY97NF2YUY7fh1r7AocMIeeg8SBFHLdnLDvcwimeE+AXuciq8Psiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29-Jan-26 8:10 PM, Bharata B Rao wrote:
> 
> Results
> =======
> TODO: Will post benchmark nubmers as reply to this patchset soon.
> 

Here are some numbers from NAS Parallel Benchmark (NPB) with BT application:

Test system details
-------------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2
  0:  10  32  50
  1:  32  10  60
  2:  255  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the pghot case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the pghot case.
         Both promotion and demotion are enabled in this case.

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)


NAS-BT details
--------------
Command: mpirun -np 16 /usr/bin/numactl --cpunodebind=0,1
NPB3.4.4/NPB3.4-MPI/bin/bt.F.x

While class D uses around 24G of memory (which is too less to show the benefit
of promition), class E results in around 368G of memory which overflows my
toptier. Hence I wanted something in between these classes. So I have  modified
class F to the problem size of 768 which results in around 160GB of memory.

After the memory consumption stabilizes, all the rank PIDs are paused and
their memory is moved to CXL node using migratepages command. This simulates
the situation of memory residing on lower tier node and access by BT processes
leading to promotion.

Time in seconds - Lower is better
Mop/s total - Higher is better
=====================================================================================
                        Base            Base            pghot-default
pghot-precise
                        NUMAB0          NUMAB2          NUMAB2          NUMAB2
=====================================================================================
Time in seconds         7349.86         4422.50         6219.71         4113.56
Mop/s total             53247.66        88493.630       62923.030       95139.810

pgpromote_success       0               42181834        248503390       41955718
pgpromote_candidate     0               0               577086192       0
pgpromote_candidate_nrl 0               42181834        29410329        41956171
pgdemote_kswapd         0               0               216489010       0
numa_pte_updates        0               42252749        607470975       42037882
numa_hint_faults        0               42183772        606540729       41968150
=====================================================================================

- In the base case, the benchmark numbers improve significantly due to hot page
  promotion.
- Though the benchmark runs for hundreds of minutes, the pages get promoted
  within the first few mins.
- pghot-precise is able to match the base case numbers.
- The benchmark suffers in pghot-default case due to promotion being limited
  to the default NID (0) only. This leads to excessive PTE updates, hint faults,
  demotion and promotion churn.

