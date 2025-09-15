Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 219F4CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4B98E0005; Sun, 14 Sep 2025 21:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C048E0001; Sun, 14 Sep 2025 21:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E568E0005; Sun, 14 Sep 2025 21:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF4758E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:36:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CC09C0406
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:36:00 +0000 (UTC)
X-FDA: 83889768480.16.00ECA79
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4E829120003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:35:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DaEypQhu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757900157; a=rsa-sha256;
	cv=pass;
	b=6s19sCUuem2ValcCGItE/xC6b9FQjhaJHHOvQGYaQoqdObGg+Sr0s/yWX0J81BH8S7Twtb
	henyrLhXIMZ4Br4jfzoyvc5gc9fwRBt8mL6gshHEM7cW+5O3CGeuFaVlehjHV8r24g4FwX
	p2Qll8RkgX0RM4XVYWTenWETPfQ1LJY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DaEypQhu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757900157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JT0QBs2Tn8Vx6FQhXEHpsH0zUhOBZIvEqbIqQjG/2xo=;
	b=FA+BJV3ccDww2tO1/fhof6ZxTL3M6qr3UgY0/R/143CWbDHou+dG2uel1eJ7RDXADQHink
	WyheZbTRSC868jmPXGqiOOEaUm4NQ2lt91oxEKd5tyOfNSWqEejrPYyRKIp69rLQxzpAlC
	RlKMV8TkTr57wDB2rsxA7Kcj13KeXec=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=reNmD58aHGsRWCXUQOPi6V37l6MzpC5azypd+xb80CcUFXUJSfpDbWm3wu9X5EBxN2pdsy9SXWUcAwJ5s6CeVMJKbR+3l3N4tz5A4Fjt0kXFPhtLOrwQm6EO+W0cEkRlY8cy24Dn4ncXfr/iDjpNiBCF+4K4/hlOWmWnM/fAEzxL2HfwUK9cc63HDbh+wpnMcU5yqvzPoPAi1s2c/cD6MvOnJXO70qgDIiCLuF2EYJzxR3pGwSRnbjbdI5/dkCYxGKD1ha2mTSFWfzpUKtFPVL0GJz6AbXHfP32lTL3yrEt67F0uTqLRohvRyezmePbGBnsJ8NMcPitO3qQlm3u2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JT0QBs2Tn8Vx6FQhXEHpsH0zUhOBZIvEqbIqQjG/2xo=;
 b=FZkulvrn/b7f0B2or+aUpaxfn/EHtX1BlNw9+5aG655H6vOodWx+FspTK09yMxVllYroQ2YmnunYRuH8NOkQjAVoShLk84LbiqpNPpXI5vKM2IqeFJMGyXYiYNdaO81cB/xtlY84Yr1i3pmJqw41maWm5gp0fkm6g71z/XtGNk29COBPgfy4spG/v/XTArhlZdCemmlJwrnxNIysehD6A8AiO0wRWiUPntE6qgtIw2WKrXXOiH1H+mQYjaFv0POZGe4ku1nIu7z9HBnGHuZN1TYauWO+xa6xMwTL3gQ8NhZDcbVrv9+Oqmdgp5I7IUWNNPu1oAKw9+498Y9u27JyqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JT0QBs2Tn8Vx6FQhXEHpsH0zUhOBZIvEqbIqQjG/2xo=;
 b=DaEypQhugGO7ztBBLcFwjzsIWZbnelFHH9wtoy9Y7f4KAc12Mqj86Em55+36cFQ8ieHIgsc6yEqK8gdt/19kCrKnyLvAnUjuebI4CjEtd4dkTeHV8TAW/W6aaTp8EzBh4NLBPymJAC33GVSruvNOWoeFpylMHpzepNu9BA2j4QU1tGchE+nk/4FhqEU1cVPDjH0WqTvZcrjCxKxE1TT2Hk/2RBuRY9Dc3EnBrJWHynKXWNSrcDzulaw+ZbKVpQe6V8G+doW1TUmdzBeopsjw65Sm+qOxlA0aL4ksTNLyXytrGmUG0n2FqcokeRfN7wfHXRZsLlklXkuQGv28wMq4vQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB7916.namprd12.prod.outlook.com (2603:10b6:510:26a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 01:35:53 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 01:35:53 +0000
Message-ID: <49776f0a-d891-40be-bce3-c2b1f16bd825@nvidia.com>
Date: Mon, 15 Sep 2025 11:35:45 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 02/15] mm/huge_memory: add device-private THP support to PMD
 operations
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-3-balbirs@nvidia.com>
 <17e3c19e-0719-4643-8db8-cf8c5b5aa022@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <17e3c19e-0719-4643-8db8-cf8c5b5aa022@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:74::19) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB7916:EE_
X-MS-Office365-Filtering-Correlation-Id: d0b2af56-4774-47ee-5c01-08ddf3f8355b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjBQZ0F5ZGlPb2w4eUZnY2pzWGNzeGpDUFAvMGZzalhaYy9IUHpkK0paMjVU?=
 =?utf-8?B?YloyWDBkKzNkcGx4SnQ5a1lRRDArQVFoS3NPOWVKTFo3Z0h3RWsrMVA4ME8v?=
 =?utf-8?B?RHZmRDFSTlJCcUh0Rk9lN1NmWmhNSnBlN1dnS2xteG5jaFZXT3VSV3NZdXJZ?=
 =?utf-8?B?ancrd214M3RHelF2K2ZwMmZyMytLRXNIQlRlTlUvRlJPeUJLYjNpOHo0WWNU?=
 =?utf-8?B?TUtSWkRSNUx3cmdmdzJ0TmpWRGU3SkZ3Uk1QQlpZY001MFhHVU03emxaYlBB?=
 =?utf-8?B?eEdjM0VhUmovVjhHN2w2UnZqV0xVMjNucC9HZVRuM2ZlUktxb3pudW5oRm9i?=
 =?utf-8?B?VmI4Y2oyZ0VBeDlINmJvcXd6ZEVWblJNdzcwcktqOHNOQUJuTCtKMjlkbGRQ?=
 =?utf-8?B?MFB3bUR4TURtRHE5NlR2cXR1cmM5TUZUTHFYSWM5bmRBbWZyaDU0RGJCYk9Z?=
 =?utf-8?B?QUFEZmxaaE94K3l3YTF4cFVGdmdvMlVJazE3ZlozV0xtODZraXlScENmaHdh?=
 =?utf-8?B?K2dnNnhIL0g3SXhzYWZmc2FVTGtoSFhEQUdhK1N0Q0QrNjdKQUlIMXVBSEc0?=
 =?utf-8?B?SFppZTA0dm9PbjQyMWZXbFpSUGhSRWd1ekIyVFhkRGJCTTd5TXlDTEFTVG4z?=
 =?utf-8?B?NFYwMzlFVFl0dzUxSC9IV0ZwUHppUFluMjA1L2dSN24vZTFjZloxUWxrcmdk?=
 =?utf-8?B?a3FIWGpMVG1YYzdmQS9SZWFLR1VneVI0NUtiMlYyemRkc0FLSEVKT1M0dktk?=
 =?utf-8?B?R0x2M3VzTmYxWFNZRzExcG43U1h3YU4vWnJIWFU2MGNCN2VXakFValhDK1Zj?=
 =?utf-8?B?S2MzblVJOTFjWnVuMVhVaU1vSzdwSVM5SXRHSExkd3RNTlZnUDk4K3JZNGZM?=
 =?utf-8?B?OEx0Y1FjS3p0L2EvK2JNaU5SVTV5OUswYWJjek85SVZUUkkyUVZ5SUJNK2JV?=
 =?utf-8?B?cVdYYXNLQTlDVTdhY2EvN3haa0o1ZTlGY3FLRTRoWFp4a1pqL2FuWE9NV3V2?=
 =?utf-8?B?Zmdhck9wYzY5Q3NrMkIrNGluQldtSGloQlNUWlVSRzJUTUsrUzI3MjIzWDZE?=
 =?utf-8?B?RW80Y3E4a2FvQVoybVFCQ3JQcGgxVnNmNGFGWmEySE1rdWx6c0xHQ0ljV2Ry?=
 =?utf-8?B?R0xkU2hNK2JrSEkvZjE0TTlsV0p0QUdLekx6TUN5bENRUCtiUFFyQzM0aGRv?=
 =?utf-8?B?cWlVamkyeHRYbXlQRkVLTFhEVU1JU21JUnVlK3hWYXZRRjFreGppUE1iaFRT?=
 =?utf-8?B?VnIwdXNVVTZKbDJWd2tuYS9TbEJYREdxMUxOeWlqdHpaeVhzODQ2c0kvWElw?=
 =?utf-8?B?QWRsK0RRRUlRM1p4Rkh2UkwvU3IyZ1YzSDZsRVRhLzFFdVk2aUhaSGlEV2oy?=
 =?utf-8?B?ODIxdVBGS3hUL1hjR0M4S2VPTnplVklVTjJpcDB5aG1JZjMvTjdiYWR0dUc5?=
 =?utf-8?B?OVhQd2w2Q2pPRFlYL2RLQTBCUFo0aFgyMkYxczd3VjNVWGtSWTZaaEg2N0or?=
 =?utf-8?B?dnhkSUh4R3FqT1pzYlpsaU5PRTM5eTllc2p2bUt1b3VwaW5CZlowSytqSWhu?=
 =?utf-8?B?Uyt5MEFUL2o4aDlZVzB6WkNQMFF6YllLMFArZHNMWWp1ekpubUJ2UnU4TFF3?=
 =?utf-8?B?NU9ZUytOUCtSallvZjBMenhsM2lWMEpvMHdTaC8yVEdZUE1oVWQ2MG5QcWtz?=
 =?utf-8?B?ZHFqS1RGdWQwU2U0Y0IzbnlxaER1dXFQcHpuZGcrRk11a1hzZmdUU1NwTnNm?=
 =?utf-8?B?a0JLL0FBMlNJenNFclRoQmdrL3ZTbjQzVVc3MlZNSS9zVm1rVGQ2WENCQ0ZX?=
 =?utf-8?B?dmp4RlVLUThSYzZ2UEJXVTVNMExnNFRWR0UvNU8zRnAvbkJUaG9VUGZENzI0?=
 =?utf-8?B?RVNrbitLSTl0bSs1MW5VZXhWL2V5REc4Ym9ZWTJlcjRTRDZKQldRb0RsTWFr?=
 =?utf-8?Q?ARzKwaWFUtI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWE1M0NpMXVZc3FrdE1CTnJUTDBzL3hCalVoRkdjVERma3k3S2Mzb3llSzJk?=
 =?utf-8?B?T1kxczVBalArNFVUMFN0czZYeEVMZDdYK1JXMnZSUHV0Zm4vV3VZRWJvVUJi?=
 =?utf-8?B?Mm4zMU8zVVR5QlNSMjJ2dnh0TXo4NTRyVFdrK3ZrSXZiSUp4OXhkZ1lQQjJ6?=
 =?utf-8?B?L0k3WGNoOFlFNUdvK08zSCtuSDJOQkZRNHZGaURydzAraXdIa3JVVmZ5OGRt?=
 =?utf-8?B?emFwOFh5ZDlSRkQzMDNVdjcrY0lmU212cDY4dEdxdzBwUlRNQzIrT3laUnp4?=
 =?utf-8?B?TjVCWWxJMkp5Ry9Wd0FrSWcydVZwSUUvdk9zcXVxQ0RUTUl6OHlTWktRd2RB?=
 =?utf-8?B?NVhMMDl6L0o1cENwNmh1VDh5cEZJK1ZkL1RZODhaNnpTQi9ZTGVtRGc0Q2ZO?=
 =?utf-8?B?aFdnM0hKcVV3K1MyRjhCR0dvRGhkK21pVzkyaHJrbUFNc3RjUXllZkNwUVZp?=
 =?utf-8?B?azJPbTNISHdUNU9VZGJCZ2QyeGg2Mi9rUjQxcnBLQ1YrUnpRRzg1d3Z0K3B6?=
 =?utf-8?B?cjZ0WHZqekF1VUVyVGs0UC8reWxHVW5CSTRJQmdPMmhTZmJxemZlUE15d0Vk?=
 =?utf-8?B?b1NnbW00QkF3ZHhFbzlTUzlmL3VwQis2QmN2Z0NjUjJ2Tm5Bb0JFenA4eEl4?=
 =?utf-8?B?Q1QremhSMDRrS3cxM2g1cUdReG82SGhFcFRVRVdGTGRYa2cxK240bWtuUFBR?=
 =?utf-8?B?dUhDQlZxdWs0MnlyV1VNM2tSWTdyUkhQTzZwd3k4NmttNEh3UDh4d2hrbE9W?=
 =?utf-8?B?ajd4eW1KRmFwc2R3VEYvZ1NQekppcmIyaFpkaVl2a2xkVVJaZWdNM3c3VmRp?=
 =?utf-8?B?bnphSHNjUVdQWm83Q2N3cm9FVVVYRXZJNnE2alk0NzlsYWpHSlFDaWx5SlFB?=
 =?utf-8?B?TTI0U1VWQ0hCcjVrek9mcWFJd2I5RE1pR292dENudTA0RzJuWVFXa0ZXZktQ?=
 =?utf-8?B?My9sQVgvWXBIN2hTcFRrVG9JTHJxNFllVklMS0E0S1BKWHZKUkJtVG1GNzli?=
 =?utf-8?B?Sm5RYWVoT20ray8zQVlJdlZxSjN3MnNyK3FBMFpEZDgrb1U0dk5ZRDhVZk5L?=
 =?utf-8?B?UFhxdGsyMDI0OWxVYXRnWlVoOEs5d0tGSlFCMzNkK0xycEIvMWRSS1dIVXo2?=
 =?utf-8?B?VGdvNGx5NnoxUC9Tdm8zUkRzSGhmVlFNbmZJbjE2VFpHeG5jL2Y0VUpBL1A1?=
 =?utf-8?B?aU9mWTZLVmRQUGd4eUhDWlBLZEllakxrdzdyOE5aUVdnNnVkUlk2UVpWenQr?=
 =?utf-8?B?U1AvTkozeCs0V0ZlSFE3dVNGSmJUZG1COVBrSnE4REZkQVZVMENOcU5zTkd0?=
 =?utf-8?B?amtER2FuZER2U1dsT2NUanpjaVdjVEkzY0wxdUZYVGJ1SmhsNkJ5bHM0bE5C?=
 =?utf-8?B?dDdHTWllQi9JNUtPQVQ2VXNFZ1d4MmFtSUJwU29mNkRza3NlOUtmZTlGN1Na?=
 =?utf-8?B?YWhTU0VBajdhbWRGQmFnVVVmNkVrVlRnTCtQbHJlc3pTNCtHS0hSeDQ4NGp6?=
 =?utf-8?B?dUNCaUF0NXJiTjFqS1hWTkZsRHZ1ejQ4TDRhejEyVjYzZUpvWU9XR2kvTXZJ?=
 =?utf-8?B?VmthRDBuSlRyRUN0aS9hT0Fwa0E2c2JZNlpkenV4UGJHVkEvbURpVktQOWlT?=
 =?utf-8?B?emUyem1WM005UVRPZUdtVjlUbDc5TmgzbVpDeE8zbGZlYlV1Vml6anpERGRI?=
 =?utf-8?B?V3g3dkU5ZnpCSzh5ZEM3NjVFM0FqS3R6ZnJFbWVQRG14VWNKa0pQL1RvUHM2?=
 =?utf-8?B?TE5ieHhVdkhHVWZ4WDh1U0psRlZYbXp4NGpYY2FCdmxmQjEyTDUrNkNWdTFU?=
 =?utf-8?B?d1ZGSlkvZHRBUmZjT2ZBQkpNSUpTanBsTGFkcnJjV0YvUU9scFlmYjJUK2Q3?=
 =?utf-8?B?TFl3K0pDTWJRZExTWGQyaEZIRllhZkVGRURtM0hLVFovM3lCQmh0NlRuaWZZ?=
 =?utf-8?B?a09jSHhUUlU4cWtVOStEUnIrSkhLUndpWUNZdGlubFJwbHM2cW9ZWENUOS90?=
 =?utf-8?B?ZWRNQ2lIaHBPallDOWVKM2FUUG85OWNxNWFNZ0NMbTdDcFVBZlRDRGU1SmRP?=
 =?utf-8?B?MlNvelc2UnhnaDI1TVhPQU1zU001NXlWVCtNZk9LSy9MWXAxaFlZMGtDbnB2?=
 =?utf-8?B?Ty9WV09XVDhQQ0oxcS9wWE9ObGY1TlQydzlQbUlOQVR5OXRGRTZTbXFLQXVq?=
 =?utf-8?Q?BSq3CBnNHsOUt1ixVCVT71KNVLWsnsWIt/DdJR5WVFF+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b2af56-4774-47ee-5c01-08ddf3f8355b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 01:35:53.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xrEIcRy0kxOJJmHqLJUA1P5/+KCdvGLJAU1JVa+ZG7WuIDUsjO5gr6W9xiQXSEonMvmYt2ZnsK0uApY6eaALQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7916
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E829120003
X-Stat-Signature: dc7u9ca8ytkn83zpejaumwxpoeq1duuq
X-Rspam-User: 
X-HE-Tag: 1757900157-740183
X-HE-Meta: U2FsdGVkX18bOy1fCkMQF7Cgo/N2gzaGZLYYw43ZoDqdVp3M4L0opTXz/GwHfU/5WdU1ySfDJywpZdSvBRmeTRgxYXezz0gByKtlSHiVXv8d8I07e2o++tth+GARidTLi4HQXFMQxxKbywDTYK8ChG5ABcArhmHLCO+rQopjsAAvSxZ4sIPGY4MgUl/ZOOrRBRAVokctzLA0IfViWXoj87sqeb/zIp3BfcMz1iZSTa4agDwF/mAvUE19aKexaQ02WO0URENiTM1mcc2bu/5a58QP9J5PYui8o6CFvEOVZLOPk5DsMzNOuwPAdC5+jsQ32NM1RxmBz9XR6KQW3ngDtIRHAMNfENuvs3vsKhbVk7tXbx2vyiNVwlTmNs3XT4O/hqPYMRavNqibHkWLOXS/3IZ8wQ5PdYKofaMGEZXsIWZ4vDh7QlEL0stj+Qx5haZzmjvmUZyRjNm8cTO0kfbcD/po0pqaO41F7uB8LXMYklSbUZZKHTwsnaUL4KalRLnpaoaAO6tlUIpbzYfboouBLaRCGQSLNYzg80phfkopl2BRWwFaSeZaBeegexNimLdZOrhGTKjsjnmLKXQQkkuspiJl4FAaoKSnkW2sC6ILgInnLqYPO3RNJThPrU7yKxSIRMDImk39CWeMI8VfAUtWBociVMNStWbKIdkD6+Gsc8xG8BXlgF/ZaDP841GJ/pdk8dfBAceQ1L4VPbQMPZ1+XEU97lk3bgrRXGxWGJcMKFIbvUvYLyl+keLIjiyDk+Jui8zdoOOJT+clBKQtEjOKXLx/oS9fHfE188DJhaAv7M6DrQwVKBebXP5bEAF9FBA9VOBHN8Pmtj839DnTRVIGyJ7TOADDNyb0Pw8TWedyUfVG1Y1HSzx5MYRDxKRJRZNi7TDboPHUmtrtk4Ky0Dy77zWLCoxBB8dksLrREWxHLuqwEg+NOVdzM6DRKl5YAXzOzYWb20QQmOMuebCit7f
 ft8Lnqwn
 hz9YPsCKIcy85ZSvrqqEN4t631Lbl+uuFCOmkE/2AgxbVHIA/xTSDBQhQ6NgbvkOF9p26+4LXxcxjAE4MKVYaFov2fQu0ftXIZvM213K5K0o9hrSzvm368ThfwM7wXiwoYvZZ/qrJp7IYeFmSl2L5Ahgd7vjM+frHocBvw4we+YqZopzvdRGWqbRlshFgCG9Af0vXkXoBb77LYSVRpHPQaFsWCWjJEnx6XVOgccU4EsYQwyFUERDISyqnNtq/uTzjkPgO5xkEWdOkf4GJ2Z2eUuzhcYeAIDPHE8KlOoB+U4V+JavUCMRMcRid2TKWbEw0w0zYdJQdsNsFU+KvhMp5zQU3rwLwzPRDjfQ3szdawHiEQ0WKqALIzeCX1vCU16desGDnDrqiQupoXNyKh59SY8dP1gPz9mH7jrK4U/JCkp4kg+4kdt/5sEgxHY9oTKyAPpgoAR6zU1hCH/RWdUpZ1e7MRjGcqiwH0IilpyMIiIh1cvqR8NnOv2H485ogYAhjUYzR/VZsmDWvjZjJfkTlsccDMDiS4mHF99KzWDxC6cYnhSP9Z+dyu0C2F5uq7wFlRlydFI8IUORJqopC+YBT8pSSOYKVudCuBHZ/kWqZPtCssHBFzmtqBrBW8+zJ63X31fAlpl/SxknrL6ZZqOUTrGJK9ERvhtsrXfJ3SrrWhrJKykfGWUaON1aQVpv8kilRFayMTz/FoOkYMZl+JGZxAm1lgmmTY2gJPOqQFmEM9zAl9R2SzKOGsYoO4HgfkB0eG/5r/ZpTeeDnT2fFZZtMcM8V17Rgg3TUvSn72gMhZCx3CjhwUyzUPrHvSK9N+iOAUYLIMz53/iYc99FVEuTY7GGLdlXTlNPybdqZSDQ33WabXMjY1tenyYbbPSyv1EX6dUu3UNNLqu67WRR9y/x8OuiBxzyDFzaMlOHwjSaL7GxBY5YLSqzwcmXGt98rTHFi0gEvCV2ETPGhx2qQ0WlLqaBiI2uZ
 q5h0puWY
 18Y/jG8A4DRKuEKQrLRLvENja2n+3erkzd3z+ImVYQscH1sxZ/+pM7dneVGg0JaULVNiWGFa584jZCtEoW4PwrfLJwcN4DWW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/25 22:15, David Hildenbrand wrote:
> On 08.09.25 02:04, Balbir Singh wrote:
>> Extend core huge page management functions to handle device-private THP
>> entries. This enables proper handling of large device-private folios in
>> fundamental MM operations.
>>
>> The following functions have been updated:
>>
>> - copy_huge_pmd(): Handle device-private entries during fork/clone
>> - zap_huge_pmd(): Properly free device-private THP during munmap
>> - change_huge_pmd(): Support protection changes on device-private THP
>> - __pte_offset_map(): Add device-private entry awareness
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>>
>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> ---
>>   include/linux/swapops.h | 27 +++++++++++++++++++
>>   mm/huge_memory.c        | 60 ++++++++++++++++++++++++++++++++++++-----
>>   mm/pgtable-generic.c    |  6 +++++
>>   3 files changed, 86 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
>> index 64ea151a7ae3..59c5889a4d54 100644
>> --- a/include/linux/swapops.h
>> +++ b/include/linux/swapops.h
>> @@ -594,6 +594,33 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>>   }
>>   #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>   +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
>> +
>> +/**
>> + * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
>> + * @pmd: The PMD to check
>> + *
>> + * Returns true if the PMD contains a swap entry that represents a device private
>> + * page mapping. This is used for zone device private pages that have been
>> + * swapped out but still need special handling during various memory management
>> + * operations.
>> + *
>> + * Return: 1 if PMD contains device private entry, 0 otherwise
>> + */
>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>> +{
>> +    return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
>> +}
>> +
>> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>> +
>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>> +{
>> +    return 0;
>> +}
>> +
>> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>> +
>>   static inline int non_swap_entry(swp_entry_t entry)
>>   {
>>       return swp_type(entry) >= MAX_SWAPFILES;
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 26cedfcd7418..2af74e09b279 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1703,8 +1703,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>       if (unlikely(is_swap_pmd(pmd))) {
>>           swp_entry_t entry = pmd_to_swp_entry(pmd);
>>   -        VM_BUG_ON(!is_pmd_migration_entry(pmd));
>> -        if (!is_readable_migration_entry(entry)) {
>> +        VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
>> +                !is_pmd_device_private_entry(pmd));
>> +
> 
> Wrong indentation.

checkpatch.pl did not complain, what I see is

+		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
+				!is_pmd_device_private_entry(pmd));

It looks different in your reply (is your email converting tabs to space?
did you want me to align the conditions?

+		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
+			   !is_pmd_device_private_entry(pmd));



> 
>> +        if (is_migration_entry(entry) &&
>> +            !is_readable_migration_entry(entry)) {
> 
> Dito.
> 

Same as above :)


> Wonder if we want to be more explicit.
> 
> if (is_readable_migration_entry(enrty) ||
>     is_readable_exclusive_migration_entry)) {
> 

!is_readable_migration_entry => writable entry or read exclusive, did you mean is_writable_migration_entry()
above?

> 
>>               entry = make_readable_migration_entry(
>>                               swp_offset(entry));
>>               pmd = swp_entry_to_pmd(entry);
>> @@ -1713,7 +1716,37 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>               if (pmd_swp_uffd_wp(*src_pmd))
>>                   pmd = pmd_swp_mkuffd_wp(pmd);
>>               set_pmd_at(src_mm, addr, src_pmd, pmd);
>> +        } else if (is_device_private_entry(entry)) {
>> +            /*
>> +             * For device private entries, since there are no
>> +             * read exclusive entries, writable = !readable
>> +             */
>> +            if (is_writable_device_private_entry(entry)) {
>> +                entry = make_readable_device_private_entry(
>> +                    swp_offset(entry));
> 
> Put this on a single line.
> 

Tried to keep it under 80 columns, but I see that checkpatch now allows upto 100 columns, will fix

>> +                pmd = swp_entry_to_pmd(entry);
>> +
>> +                if (pmd_swp_soft_dirty(*src_pmd))
>> +                    pmd = pmd_swp_mksoft_dirty(pmd);
>> +                if (pmd_swp_uffd_wp(*src_pmd))
>> +                    pmd = pmd_swp_mkuffd_wp(pmd);
>> +                set_pmd_at(src_mm, addr, src_pmd, pmd);
>> +            }
>> +
>> +            src_folio = pfn_swap_entry_folio(entry);
>> +            VM_WARN_ON(!folio_test_large(src_folio));
>> +
>> +            folio_get(src_folio);
>> +            /*
>> +             * folio_try_dup_anon_rmap_pmd does not fail for
>> +             * device private entries.
>> +             */
>> +            ret = folio_try_dup_anon_rmap_pmd(src_folio,
>> +                              &src_folio->page,
>> +                              dst_vma, src_vma);
>> +            VM_WARN_ON(ret);
> 
> Please just drop the ret + VM_WARN_ON here, like we did in the PTE case.
> 

Ack

>>           }
>> +
>>           add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>           mm_inc_nr_ptes(dst_mm);
>>           pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
>> @@ -2211,15 +2244,17 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>               folio_remove_rmap_pmd(folio, page, vma);
>>               WARN_ON_ONCE(folio_mapcount(folio) < 0);
>>               VM_BUG_ON_PAGE(!PageHead(page), page);
>> -        } else if (thp_migration_supported()) {
>> +        } else if (is_pmd_migration_entry(orig_pmd) ||
>> +                is_pmd_device_private_entry(orig_pmd)) {
> 
> 
> Indentation ...
> 

Same as the discussion above

>>               swp_entry_t entry;
>>   -            VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
>>               entry = pmd_to_swp_entry(orig_pmd);
>>               folio = pfn_swap_entry_folio(entry);
>>               flush_needed = 0;
>> -        } else
>> -            WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>> +
>> +            if (!thp_migration_supported())
>> +                WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>> +        }
>>             if (folio_test_anon(folio)) {
>>               zap_deposited_table(tlb->mm, pmd);
>> @@ -2239,6 +2274,12 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>                   folio_mark_accessed(folio);
>>           }
>>   +        if (folio_is_device_private(folio)) {
>> +            folio_remove_rmap_pmd(folio, &folio->page, vma);
>> +            WARN_ON_ONCE(folio_mapcount(folio) < 0);
>> +            folio_put(folio);
>> +        }
>> +
>>           spin_unlock(ptl);
>>           if (flush_needed)
>>               tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
>> @@ -2367,7 +2408,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>           struct folio *folio = pfn_swap_entry_folio(entry);
>>           pmd_t newpmd;
>>   -        VM_BUG_ON(!is_pmd_migration_entry(*pmd));
>> +        VM_WARN_ON(!is_pmd_migration_entry(*pmd) &&
>> +               !folio_is_device_private(folio));
>>           if (is_writable_migration_entry(entry)) {
>>               /*
>>                * A protection check is difficult so
>> @@ -2380,6 +2422,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>               newpmd = swp_entry_to_pmd(entry);
>>               if (pmd_swp_soft_dirty(*pmd))
>>                   newpmd = pmd_swp_mksoft_dirty(newpmd);
>> +        } else if (is_writable_device_private_entry(entry)) {
>> +            entry = make_readable_device_private_entry(
>> +                            swp_offset(entry));
>> +            newpmd = swp_entry_to_pmd(entry);
>>           } else {
>>               newpmd = *pmd;
>>           }
>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>> index 567e2d084071..604e8206a2ec 100644
>> --- a/mm/pgtable-generic.c
>> +++ b/mm/pgtable-generic.c
>> @@ -292,6 +292,12 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>>           *pmdvalp = pmdval;
>>       if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
>>           goto nomap;
>> +    if (is_swap_pmd(pmdval)) {
>> +        swp_entry_t entry = pmd_to_swp_entry(pmdval);
>> +
>> +        if (is_device_private_entry(entry))
>> +            goto nomap;
>> +    }
> 
> Couldn't we do here
> 
> if (!pmd_present(pmdval))
>     goto nomap;
> 
> To replace the original pmd_none() .. check.
> 
> A page table must always be present IIRC.
> 

I am not sure about the pmd_none(), a page table may not be present, I've not audited
the callers. But I think we can do

if (unlikely(pmd_none(pmdval)) || !pmd_present(pmdval))
	goto nomap;

and remove the migration and device private entry checks

Balbir


