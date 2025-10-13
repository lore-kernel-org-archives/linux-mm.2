Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3EDCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 22:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFEDB8E00AC; Mon, 13 Oct 2025 18:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAACB8E0024; Mon, 13 Oct 2025 18:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BFB8E00AC; Mon, 13 Oct 2025 18:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA568E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:52:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 328EE1A0618
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:52:01 +0000 (UTC)
X-FDA: 83994590442.21.98D3E49
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011020.outbound.protection.outlook.com [40.107.208.20])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3E46E1A0006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:51:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oz/OkYyA";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.20 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760395918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLnUUAZXjqj7jQN+44+goSNdl0+/B1/OrJDcUY6yfas=;
	b=ZZs3henTyv/BV5pwkq7XrKJ2KqF9UolzgwUZSn6s0CQE7nTD7mMOx76Bdcvfxndvmu/6KX
	29S4QYoS+Wm2RPz8xKPyVhl9NNWl0ip153PodeMN4m/uAIcJsM01lzs6qGFwZIGJjbL8lf
	xQnPy4PrHIosoVEDfF0X2MCX+8NpREU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oz/OkYyA";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.20 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760395918; a=rsa-sha256;
	cv=pass;
	b=Uu1huEWk86zln/QRIuLWpzPfMB3CuIxLGvlYsGXdD85UQ8241bE3XLZppu/TNrNPHS06vo
	u6aLBNwjXaLGXLuwr0tdIBtpju0/0eWoZs0TCFnj+nCuiLoputXN5tW2Adiph/l3tMaWN5
	iucPwpobxURoCIkYOpKAyDyPm/TAlx4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L74jl/i5V7BDn5XvAt81O4pdRquG3IRMQMzESqYppQ5vzfZjCNEvqH4fPEQAhzHRGkzgb4a7yZ9le4PWOPL1Ai7JT9SVs9sgRh262LBRKgH5iP/gYSDpbGb95f3Y4FTxj1u83p1gfAu48RNTVooD0ZYsgydaxZaoHTI90U47fhMA7JOQWYwvKSZAiXLfYfsPGgbH05qXbq1CsX2H3P1mHLGjDXt9QWLlgPee5qFVekzcWFtHAe7+ssXy7vZPBAgd2bQ7DLdLrxarMH6soIwLhPftm5ARyMBSQjkGxM9bRLL0DZ9AV6sEYai12ihkX1x/gvpBQpmTQo4+X+cpC1u6vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLnUUAZXjqj7jQN+44+goSNdl0+/B1/OrJDcUY6yfas=;
 b=QeotAz9N/goPWGBr9wnxWl+sowV/eI6e8JK1JTZhxASIsbQEMQVvSq+acFQBBHCxT7MXyVjIfbvM3c+8S/pqitEw4nnldX8DMGa8lV9z/g4QTfaFFfDqOz4oqYkss6NJpyJ59b1p8DETmAnDLq8fFnuO0+EDB6zDBX8vCSkD+0AZ/6CuXryGm2lsvkImLJZKRaipCtnwM1GypAjuTQC0vbbI92s2LK2yMLQe+2i73DqvcSd52RsLwqWxUbZ08sF3YgH71pro2P6t5MHrthRzduJmlsfvCa2CTZ8ZErf+Y8dqmofB/I2By2d+MEqhVrI/V0G6YrOlSagwr5Ak+iPP2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLnUUAZXjqj7jQN+44+goSNdl0+/B1/OrJDcUY6yfas=;
 b=oz/OkYyAGg1GValrE/sKVYuXdJJUKdx+8xfKnJestFpmkO1/Pk0aF57M0UDsKYDOjAG3TZV5dkMbm1Rt3h8kVvk3Zifa7bmdai/iDefW4M5Jz9gJpb+1ZlpbgSSXr0CxJUheFjMiGW63D8jeWWnqwqJh9RUKeh13Gv1NmvOKv38QbvIU6LAM4Yd8W0QyDYs8kmAapGGTDOlxMjf+yyUvxXUAaZcCkjnlB5JZBK356nDu8DfX+/cKgXjGjWJvtUuLZBjxk9jf4FKbuQNR24HRb9AEgk1L4xjR/bUjK5YwFj2nA0NW3DbYwuYWGYyXZbTP8uu0cMu16V+uPclz4xaJcQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ2PR12MB8652.namprd12.prod.outlook.com (2603:10b6:a03:53a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 22:51:53 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 22:51:53 +0000
Message-ID: <4667dcfb-e02a-44ba-9cca-f197a5aebe4e@nvidia.com>
Date: Tue, 14 Oct 2025 09:51:45 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [v7 00/16] mm: support device-private THP
To: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251008201740.d9507f4807a73058d4da23a8@linux-foundation.org>
 <a5992f11-5841-4bbf-b190-b5df41b68b0c@nvidia.com>
 <aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::24) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ2PR12MB8652:EE_
X-MS-Office365-Filtering-Correlation-Id: 61da0198-6ff9-444d-f03c-08de0aab1a53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TXVMRVJNZjJjY3FUT2R0amtLV3F5NkEzamNpMjIzcUVTanZDOEYwZ1RkM0p0?=
 =?utf-8?B?OGZVeXQ1YUtXQnc4RkliOVp4eVhUMWRGNHk2cnI2K0ZsZXIzMkJZY0RtVHpT?=
 =?utf-8?B?Nm5JcVBrQVRTYW9oOElpRXBBekxZazVFV2dSaXhJVHVvc0ZMbDM3eGVWSzNC?=
 =?utf-8?B?Qm5vb2Q0QTJBcFBPNjRZTjhPZ2tYcUY0MVNhSTdxK09iREJqN2t3Z05yY1ZQ?=
 =?utf-8?B?Q1E2emJrNVJZT1NXaDhaaFkwTi93ZGV6NHhVMXZkYVFwSjI1WDFxUkdvTnJC?=
 =?utf-8?B?VjRjeldhNEZ0dCtORHVZQUJycjFWU3JRUjk2ODRjMFZVQSt0b3UwYnVzNkhh?=
 =?utf-8?B?dDVIMmJFOHBqZmJSclc1U0pUR1RDNHFURXpxN3ZEU1pYTEhmM3ZiWDZrc3g1?=
 =?utf-8?B?UW0xaEhQWmkrSWMwdE85S1pyVDcxMld1a1FGRUQxbm9uTDFMb1NCODJJNUEz?=
 =?utf-8?B?TytEeHMvRWVqM0dGU0JkQkh2ZDJYUldFLzdVM3NEbW1lUFFvYjYrT0xBdXBw?=
 =?utf-8?B?NXF6ajh4SHhKaWpxaGdraDRSUUdQWk9jR1g5TytkOVZoN3lieVBSYm5jUlB0?=
 =?utf-8?B?eUZzLzBibVVJN2hGd3FtRXljOEVaT2tpL25Eelhxa2JVa0Z2V0wxSzVEOGRW?=
 =?utf-8?B?VDVtRE84ZmVjSnBzNjhLK1NqYktIaXdBNjhqL2hkd3Zma1VidmkwcDg3Vzds?=
 =?utf-8?B?YjBrZlRGbEdGZk00bGQzTm5tSFB2TUsrdUNxbnBRcUNKbEF5RmRIRlU5aWI0?=
 =?utf-8?B?ZzZ6TG11MVdMY3gxckN3TmlZbUI4dDIyOVZUVkJOZ0xLbHdwZ2NGaEYxSjNN?=
 =?utf-8?B?UkpPcEsvRmozOUtpSXNnLzlQVjlNREtnRGVEYVVxb3dUZWQxZ3lneW5HdHE1?=
 =?utf-8?B?cUUzREJpQWFldy9qR1h3TnR2TTAzMmM0MWkwbzNEV0pqWjVUVjMvVjFTRmMz?=
 =?utf-8?B?R05hamhtRis1MWhPd1R4QjZCbjlHeEJSZ0ZSeGF0TXphSmI3c1BBQUpja1Nm?=
 =?utf-8?B?VzJ6SEo4SG5vTVRTcXdiZGgvdHpPbndiam9RWXNOcFdydEZQZCs0VzJRMmg5?=
 =?utf-8?B?cXNqVUtCOUxTM3d0WlV0UVhXb3BKRkc3YzZoN2dxV2ZEZDlyTzBRMUlxQkFN?=
 =?utf-8?B?citlTEtpNWplUi8rMVk2UmJLOS9YS2IxZE1Wa0VxSzEvSmdhZ1FlMUhtMUlT?=
 =?utf-8?B?Uk9rUWg0WUJqMmRQcnF2VGF6OUFRUWEySHQzVFF4MkhBcEJvNzBaYkFURjhh?=
 =?utf-8?B?MFlpVjM2d25MU1liTUdLZFNXakZUNURKVXV1b0J1a0xsZnFnZEt2ZXcwMGRk?=
 =?utf-8?B?ZW1jcGR2cVBSNExMNENpL2J3NEFOeWVzNmszMlA4UWVNTlFPSVYzM3BrYjh4?=
 =?utf-8?B?dWJpNEQ1YmN2djhZVWpaQ1N4aW9ZdjBEcVVZMmZDOEQ0dU83VWNIWGxyQXBC?=
 =?utf-8?B?bzlNNWo4a1pFVkN5R1h6K3NQRWdTZXpPWTFsOVczeGxSdXl1TVlyWEJ5VDVo?=
 =?utf-8?B?WjArWlVNSklWbEk2UXB1U2o5MVUwL2tnUWRRMEtSVUxvLzhmUDlPajVFYXd4?=
 =?utf-8?B?NDZXc3JVMHJlcFBqRUFaVmpYQm9EellkK2o1c1p3enJ0UmlDZEJGTFVVTkkv?=
 =?utf-8?B?cWFRRG9IQU1xbWp6cE1ybWp2dDNucU1ZbWNrSlhIYkxCNDR3S2JoTXNLSVNp?=
 =?utf-8?B?WTVqdlk1WUhDaTF5TDF0QklibnlYY3M1SmZ2eWY5U09IaE5ib2VRN3JzUHBl?=
 =?utf-8?B?MCt0cTgrUTRHTXR3R0tTcWN5WjN0aDJoY1ZCdWdZSzRTSGU3QVVzY3Z3WU5Q?=
 =?utf-8?B?OUxWNWtmb2NZS2xvdzR1bDk5UXZPVk1xc25EWTNGMjdQeFBBajI1a3JVeXZy?=
 =?utf-8?B?ZE4xcS9NWkxYNFFtaFc2ZGtRZ0Z0ZjBydHhmRkJIalRNVUI3K2VaNitNSHNp?=
 =?utf-8?B?ZFBtRDRvRDRmOVBmbGN3blQrQ2l6Uk9hTjNMTWx2T3A4TlFjTFRTYU43V1pB?=
 =?utf-8?B?dUxkckJLc0xBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzczNURjRGptWSs3UEtEcFRQWmxuU29ueXJ0c0hrSVFlZjJJSkRMTDMraWR6?=
 =?utf-8?B?QTRhU1hCUExhbDRZZ0dzV0NNZlcvVnlxL0Irc0hMRjNudkpFa1hraWF4cEdo?=
 =?utf-8?B?T1lmcFd2bTJBSU5ock1ET3B5ZVlSMG9LSzZNME1vMjZxU1h6MWVJMzk0Nytr?=
 =?utf-8?B?OGxMVmNyVE95cUFrM20ycnpKSitWM0ZGMTFPa3AyTmJHV3ZNUlNab2QxREc3?=
 =?utf-8?B?NGZyRDd3WXBxMkhZd1dOeDQ0WFhjK1UyalZ2Y0R6U3J3WnpzNldlV3Biajhw?=
 =?utf-8?B?RFk0U3hVVUdZRUFBRzlLcjhhZnZreVZ2ZHRDbW55TWpoOVh6R0FEeFJkczBj?=
 =?utf-8?B?bW80M3pqaHhrSFA1TTRxMUdsZ3JKZnNHTFlRbi90ckFlVXhudDFCOTJBVGFS?=
 =?utf-8?B?SmlveGU1RHo0a056YW8wZWJ2b3dFWjNBVGc4UzBLN0V6YkVBNklINm5lcktS?=
 =?utf-8?B?THE1ZWtlQ254b1h5OHBHOEJETlhuclNGMVo4QjYrbkl5NXMvckRYRk54SVZ5?=
 =?utf-8?B?eGI1SHJRMzhyNjY1S3ZMam1JYzVVWFhucUhLSlE0elgvNmpuSGNoV010ZWN3?=
 =?utf-8?B?Wk9ycy8wdTBxL2xla3dSaGV6all1cUUvU0xOZDBoWDIwamoxY2dRbExDNnZX?=
 =?utf-8?B?dGJ0eVFUdVdCQ3Z6bnIyaGcwUTVyMGk4anJEa01VNDZ4Vm1GOGpVSWJFOFo2?=
 =?utf-8?B?TkF5S1RzaytQdGE5Z1JwTEJWK2hIejgwTlRIL29ZNnh6eU02Q2VsZm0yTCti?=
 =?utf-8?B?cTRRdnM4dzlpek85R25Db2g2SlhxQWdmaTc3NXRHQjlxdjgyZHhobEM1b1Nn?=
 =?utf-8?B?cmFNelZzQXUvUCs3ZGtRU0d1ZHQ1Nk5XT0gxT2ZiV3NtWXRxSmkrYmQ4alNo?=
 =?utf-8?B?K2tZbGFHb0orZUlIOVl4LzVhb3hDTHNrY3JvZ0ZDT254d3ZEQnBueDZxWXBU?=
 =?utf-8?B?Qjh1ZkFRcnNWM2srYUtoRmF6SExVK0hzSy9Lb09KNXRnb1loV2VaZmp3S3NN?=
 =?utf-8?B?a3I0dzU1cVlPa1p5b1NHcFRZbmRma2ZESFFGbDNwaGdpNG5ZcGRmZHlQQUxX?=
 =?utf-8?B?TlFXa1M2bTV4SkFYMWx1WmhSWGROSll4TGlUTEY2T3RRblZqcXU0LzZHYmhG?=
 =?utf-8?B?M2JnZG91blJLUVRpWGxXVmpGTmZaSHlQM21FWXNEclNiSG0zdzkwQTJBSmNt?=
 =?utf-8?B?UFN3ek5mRnpOMUxSa2RCNTZtS1JrZDg2MjNBNnVRd1h0V21WeVljZlRvYVdH?=
 =?utf-8?B?Njc5Rzdra2pobGJ6U2FYaDZyYVFhcWppNzdjUzh5dXRaOVA5MEJqV2V1TzlR?=
 =?utf-8?B?eGxvb2R3Q0xHamxxK0prVE5kMzhoODJMUWhEd2NDaW02RVRaYUdkRkZXVWxs?=
 =?utf-8?B?UWJpMU1RejQyTTdpdWpiY2FPQ3U0clZ1UFh1bTFqd0gzYzM0TC9KamNLTkpr?=
 =?utf-8?B?U3REc0xyczQ0N0N1VVgxRm1waGFhOE05cTZIbkFwWnhFVk9EUWI0Zk01bkkv?=
 =?utf-8?B?cndDRFZFMzNzUktRWnQ0VC8vcXdmaEFzOUZjWGVCVzBvVTVDUU1HTGg3L2pi?=
 =?utf-8?B?bEpjS0x3UGk5Y0JvQmxlTHR1L1pjM0JlYUNobVVrSDRqZCtQdVF1d2hrTVIx?=
 =?utf-8?B?b1lyWExzdCtKRjBWZ0xQM09oWklYbElsUXhTVC9LMHFpOTZpNTRJOEZMcDg1?=
 =?utf-8?B?SG1GYjBwSXU3Y25oekRISS9ZemphdEZESG1GeGRUdmhGODNlcVNVQzg4ZnJi?=
 =?utf-8?B?NE90aDlZdEQ4Qkw4RXplUGJxQ2hFbU05aitSeVdIRExXV0NOaEVaSFhDQlVw?=
 =?utf-8?B?WUhFRmkyRHBBYjYreWR6T092TWFCOGtsOVh1VjJrTlJIVm5CVVAzMTMzdzI5?=
 =?utf-8?B?ZUhBcHRqdHVZelZWSGZpSWJHYTJBZUpXdWVFTUtMb0RVSnlRS3JSSmkxbGZ3?=
 =?utf-8?B?UTVMMS9EVC9Qd3JROWZzQ3V1S0RPYm01RDh5RElzbmpTTXRkN0JUTUFOM3FX?=
 =?utf-8?B?aVJVOWpCSzFMcmdoRkdjT3FrYnNqcnR4dUZiR1cydE4zUEtPNTZ6QXNwQVhG?=
 =?utf-8?B?Y3l5eDd4RGpUZjlJRlg2MmNlYnRHazNyOHFDV1N3cW5aKzhTdnBHWjhBVXdY?=
 =?utf-8?B?VWZGTHp0SWVWU21zWG91dEVUNzdJYWVvRDZWQ0xYQlFGdTdPb0tKcVhQaVlu?=
 =?utf-8?Q?3mKgYAumCej1RwgAMyF+JgdbYtpmY2iwQ70YfIh0SBU9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61da0198-6ff9-444d-f03c-08de0aab1a53
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 22:51:53.2974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sabe1xHZxk9aa9OpgMOxW4z1TkD7XIqCqipUE8qz4aHf0rV12qzcern7F/+oUHHwnkBj6dq5FqgDz6fqv7eHbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8652
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E46E1A0006
X-Rspamd-Server: rspam03
X-Stat-Signature: jcybsrxoctf1fkniug6i8yf4qyqksusq
X-HE-Tag: 1760395918-678871
X-HE-Meta: U2FsdGVkX1/pO1LdZNzt0kGP7yy4+VeZv/7MILQkSykW2ugcptrzxHrQo+lDivdQPQHypbmKehIKe/VfVD6MIqATuVxHjCW/CQ0nhqEMOQEwr86wxL3kHclCIeCOtQH3TBbFqqL0M7ywRKeVAoFKK3p+wOawRu0sL8r5lcST2/oyFY4avGanFubNxDU/iKYwgIrLFqHJO23tdbxr4LPi7NHxV3WvBry9alJj2kFtm7iTT17F7wCSTIwD+HEI+V2HN3c49sopCwiD3PbxWNaPZTHVWjoElaUj7o0WjQvfz95yYmQ2gNL9jMx3WjuV6O09vcso/At5xboR1CufShikk0XKYacrEWpLXz8uklx/mrCHq58HTxAlvhVZdy4qTMzxja5ee86uZhNOyAUSfBJmxYMA5pyYrkWQ7/uOtiJ135aO/ECgsmz41o3kKhLUaX1AgGRVjbhETdnw3vOSehYCVNeDrLlRHbl33NU4OXbsPhWeSnfau9j7lEp7BothLdSxk1tO4T2je0wgR7ubG0cjRTYEABsKFBf9ZifPxo+tztZdfqaeUW1SwhIu1OgqqawmpK7Vq+Zo9gOkZgavSb5KPy6NyIidbdnbM/Y44Tk9v0c81eCN/d1JLwmh89jI5hIJkDqmAi7wp1fNxBhRDKOeRCkN930Is9lPif4xCTr0ttIPd6wD2NjXjuRj/HACu1C5BtvzzsuwInGpAEJSXoDurCFCkeJfHCX/OpPOkL9JwFd4a02eL7dD82H1ww6FAQxEHeZ3kbUlLtRvV7MupPrlSCo7fyGQRC7i2iyUev9tDiy+C3nkSinSGN1XP7dKj6asmbcbKW1JMYu9fNbBE6Z3dqsJ6NAIt33z4bFcshvKmOuPkj4rh6LfM3Ebju4MNa2dxm+DmsmwwFugxI2/yx5ly4zKiAZTbrv6jZfDzpP5l+KNEWI6C/EnbJzZrHFvzXdOAgQXpO2F3wUbAzq3y3l
 s/sykkqF
 JUNkOhcDUmUWaItpypeAAYhytZX47yCkAyNX5bIQku/TAmO986JIJKg1tINN/JDG9+aguG8d37mE7mWGvXtdp+iyQL71dEVPsRpNcPwdRD9BJyQQenafkaK7lMC1UxjCcvyfqGQq9dHYSQgc2wTB11Pw5SExkKJZMufIGF/w/2CopmOqPoYq5G4Lp00QHFB5l4an+EENzIlVEGBPq7MdDS70d//0HCqMYt6YAGpm2+2wSarrelgj4nWQFT9OMu0LVgTmiWPY+re39fX93q4OaMjSMd6/Nn0aQBzq7LNTvmmm3qlN02LQCiV1hzGxsk13VgTbM3EUSVoiXMFc2de1whaEqZSuCa9/SE1iTR+B+U8LKVq2YXqgdn9pnhYoNiF2DBf+1xYLdhD2BN0P8SJywamz98+WEnHBIAlMtgF15Rg1zvwHVxC7C3yIySzobtkhU4pS2iqT7wCpdwSXykDuVYbTTCD+dniq7M2lzhB4FCvWzuTmdyIRTRL75C9DfGtn7JvCxeIyK7bORcRXsssQmrq4tVlFsysLKO18Vhc8x4L4J1M4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/25 21:33, Matthew Brost wrote:
> On Thu, Oct 09, 2025 at 02:26:30PM +1100, Balbir Singh wrote:
>> On 10/9/25 14:17, Andrew Morton wrote:
>>> On Wed,  1 Oct 2025 16:56:51 +1000 Balbir Singh <balbirs@nvidia.com> wrote:
>>>
>>>> This patch series introduces support for Transparent Huge Page
>>>> (THP) migration in zone device-private memory. The implementation enables
>>>> efficient migration of large folios between system memory and
>>>> device-private memory
>>>
>>> Lots of chatter for the v6 series, but none for v7.  I hope that's a
>>> good sign.
>>>
>>
>> I hope so too, I've tried to address the comments in v6.
>>
> 
> Circling back to this series, we will itegrate and test this version.
> 

Look forward to your feedback

>>>>
>>>> HMM support for large folios, patches are already posted and in
>>>> mm-unstable.
>>>
>>> Not any more.  Which series was this?
>>
>> Not a series, but a patch
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=10b9feee2d0dc81c44f7a9e69e7a894e33f8c4a1
> 
> I think this [1] means this patch is Linus's tree?
> 
> Matt
> 
> [1] https://github.com/torvalds/linux/commit/10b9feee2d0dc81c44f7a9e69e7a894e33f8c4a1 
> 

Thanks!
Balbir

