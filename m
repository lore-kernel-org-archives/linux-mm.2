Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924BDCD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 21:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11BA8E000C; Thu, 13 Nov 2025 16:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1AD8E0002; Thu, 13 Nov 2025 16:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A630A8E000C; Thu, 13 Nov 2025 16:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4548E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:56:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BBD6138DF2
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:56:38 +0000 (UTC)
X-FDA: 84106943676.22.F377006
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010044.outbound.protection.outlook.com [52.101.201.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DE44C000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:56:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kljPNct+;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.201.44 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763070995; a=rsa-sha256;
	cv=pass;
	b=dZOV0UOaSKiFJwCqD7EwKqJynal4EOhGQwz6BgnBPkEiUoN9/hGLa9O1C/zPzdiSpFGxrH
	YBYuqEnDPM8lsBF3D1vWOpgblsgpGxmHlMIv5zmdFXWkqikYb80PdcP72gqTtDVkxcTJvl
	noAsv8ox0x6XwUei61o15KqR72OHzuQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kljPNct+;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.201.44 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763070995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9I5fJc6hA0SXjWh4IoH39vngSAXJXf3jXt/glTvaaGM=;
	b=58ZbZatWONnZVsoEXrgBZFgHE8b2la9NkGVylfJ7yL+tzlA0dBIkZpmk+4SeE6kJgerPbt
	6lMjz9iMyoLtFr6BVkXHZaQ0cjWGYJjohCa20zaJoGMDMimxnkwy0Z473CoIvKFBxN5mPv
	NBUE/tKJ5pAfD/uzadP233g4aJWYgw0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDPpL8op9MF3Jn7j0SjCgLVjDBNIZC5kxZzySLQ4WEw0OxpiXyUQvgoCl6a1gLFjLw5M0l+D17YG2uyLMZWUs/41A7lGb9rJYPYrVt0kVEVPsd7s9iOt+TcbQgitMn/nLB3pWG5TeddwZuEul6zu409bY1UU0C/SNWg4AJkcqqsTBKoMqpACZD/KW2Ur4axMQVIvqhR0kxRmE6tujQtcno0VFYFoGs8+/hAo/mPAjdfXfEZ53Y6SD3NXJgR5yC2gAmjm+xX+Eis8LvytkeSDXz2pxVemSdyN/zvjtVTvUOqjCcQNSqXH8PWVNJZYLHiYtS6xtDOGcP2bYGbn3cNWuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9I5fJc6hA0SXjWh4IoH39vngSAXJXf3jXt/glTvaaGM=;
 b=qmJXHm+pCa3uItaODKoB42q7JPQnorFDdkaBHs/E6rKnNgesw69ep3KSOF43It/WohQng6qw5ZE3Gk30L0AU7qIO7sp3F1MLdxuy3ishmJMqjJJCxN/oa5wXmz/Xmzl4jG5lFD7gORcyNxc5FKpQtoS0xpFufsj32E8MTzBedmQaaj34XhWImJBYksKOiJWH3DQZT2vwlTmbstTfRJ1NHn1Nbs0AuXA9z7h9Ywmxc99eE1QtMjSZ8WE7UZLCL1jXrtl7MkMxTEb7rpYe3dI/1d+RUI1T2IR+nzXfz9ij1QFOyv9juLem8mdvXQoO68TLDZOYyp3ZgxNNReLUxu5GQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9I5fJc6hA0SXjWh4IoH39vngSAXJXf3jXt/glTvaaGM=;
 b=kljPNct+ySTVWs4HvkIknS8bSM/I5/x5yVieqVuxUiKiA+JPXBcdamN/YB7hAnInKPK01xvvsl4bbm0dqeh1Ce4ySuB1wwIrO6jJAk/rq35k5oI80S4svz21QDUd+2b0y7x7Co0CMyTo5/swLqc215LUlPbSCo8ldWwBAoeeWylyhvYlkPQaiUy1kw7bFyEqvjmSTNgKvUNQVExvRCXczghZZK1eQXdoaHGrV1uyFYniM2ou2Lz0ziuhQOxhn9HmH5cna73X8oih36ddm6p/DZOqxEg1hRYLEXOB2OSC9OgYN8/E0Asjmkt+2mfNVBLJPxvA3Pgccwddq+KBFap2xQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB6771.namprd12.prod.outlook.com (2603:10b6:510:1c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 21:56:31 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 21:56:31 +0000
Message-ID: <ebdf1926-2e9b-4226-b80d-4f9975f72f7d@nvidia.com>
Date: Fri, 14 Nov 2025 08:56:24 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
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
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <048134fd-6a3d-4a6c-a2eb-9a9911c3b35f@kernel.org>
 <efa37c4d-8c9f-4094-a713-4fd4452ae917@nvidia.com>
 <826df5b1-b61d-4794-a96c-dcf9ac19e269@kernel.org>
 <bf8e0c95-15a1-4eac-ba2e-52d361050039@nvidia.com>
 <20ad8b5c-1bb3-46bb-bc03-8e9222a7f7e1@nvidia.com>
 <EB4C7FF1-8350-43FC-B879-20EA0E733F09@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <EB4C7FF1-8350-43FC-B879-20EA0E733F09@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::43) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: 204fa6a7-53a3-45ce-48e7-08de22ff8103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUE4Q2EzWHVSN01oaGlyL205QkNqMGJtK3pqdGdJb1JWanAxRldkZFVFcUw0?=
 =?utf-8?B?SUpJUG8zblVEeVA5WUx4d1RZalRValZhVTZ2S1FuN1dqQzI2ODFGVUNWRGdY?=
 =?utf-8?B?RStsK1g1alNsZVk2QUlrcjc3YU9jUDIyT0N5cUpjYWU2NTc2MHQrQkM4ZCto?=
 =?utf-8?B?cTZYbUxrNDJNZTE2d2JvbjJMa1lZT0dBMmpNSmRSVUlydEpqRmw3ZmdGeUQ4?=
 =?utf-8?B?Nmk5UExza0F5L2MwVmUzMHRWeXlHdklVN0ZLbkJTZm8vTlRyQm1LYXJMbTZw?=
 =?utf-8?B?US9OTC9FMXA2WHUwb095ME1LWUpPV1dOcWM1K2NQajdDSVdBcjEvQndqaFN0?=
 =?utf-8?B?OFhPQnZwVzFSNDBXVklGSVd5clRFNll3cjBEWlgwYjNpcUZqUnNLZjVwczF0?=
 =?utf-8?B?ZGo2MUdDM3d1OXRCUmljOEN0NHVNampRdkVuZm1zbnZCUEo2dzhEQjRENnV1?=
 =?utf-8?B?RFE4NWc2azhHMllHS3k5VnFLVjJ2SWZJYUU0clZwV2plcW1NSWd1Q0RQQVB5?=
 =?utf-8?B?NXh3NnpiWU4wOEdQWG8ySk1ONk5hbkp6NmdmNjVYeUJGaEMzOXE4MEh1VTZ3?=
 =?utf-8?B?VC9YMy8xaGN5K3hweGpNYkNVMHVNelhGZThVZDdLNHltSXUyK2dzUFVoeDRX?=
 =?utf-8?B?M0VVLzFYNTA3UlEvWnJwUnB2VjNFdFJwaG84UDZsQ0IyQ2hrcnlibTVSSDRN?=
 =?utf-8?B?akZMaVN6bGZWSkYxMnZCQklRTEZTMC8ycGJTVTZSVFl1Ty9EV2lRZUlzdWsv?=
 =?utf-8?B?dGI5cVE1US8ySjZnZWdrRU1aYVFieDZYYzhDb0QwYlpZd3RWdTFCSW94ZjNn?=
 =?utf-8?B?bnVHSHhCbm5lQlBBMlF4VzF3UXhjWHp3Q0NFenlZcWVabE5mcVZvSGdRZGpK?=
 =?utf-8?B?YTcxdHZ3ei9PTUk2NWZSM0ZjTURjaFZGSWZiaFNVOXFFY2lBdFl2VEl4RVY1?=
 =?utf-8?B?VDdZL1JKa293OVZqWTdudWc1UzZIZEVDbGQ2YmZuTHlTemJNRS9YZ0Z4ajNK?=
 =?utf-8?B?RVk2T3VUYlVyQVR4UmJWeE9rNVExZDQ5NUtReXBjSnpqT0ZaeHF3ZFRQbk9T?=
 =?utf-8?B?SzVta3B5VjhrV3ljWk5DV3UzTFI0K0xCY3FTZExSQlJvbGRINkdJZDM0Q3lD?=
 =?utf-8?B?enJmeWJISW1OUmI2OEZPVzVDUDFGYWp3L2FaeUJpenFpbGQyR2REUVdtelhN?=
 =?utf-8?B?Zkd1OElsMkdmdTlYdWdrV2xPN0RHR0txS1FOd3ROZm9BaEtWenpLb0ZXVnhV?=
 =?utf-8?B?NnN1Nzc3NUFGQ2NGOWRhVnNGb0QzQlNlREFFU3Q4cTAybXFmZ2oxQ2MrbVV5?=
 =?utf-8?B?VHJ5M2NpZXZzSnJrMmpEZTkxWEQ0TTQ0VnZJbGluSmpPY0s0eCtnVlZUbVlT?=
 =?utf-8?B?TGFTb212NFdDT0l6UkZ2Qk1EdjgybUtWaVRsdnJKckFhRkpPQVE2WENsdzJs?=
 =?utf-8?B?TFVma1p6NjlqejVpRGFldWsvYktoR1ZDbTBZT0FrZzcrcXUzYkR4WWU0ZVB1?=
 =?utf-8?B?RmVPQjdHRDRCT3NwOCtlbTNxMGRScjgyRENPeHNDNkFkVUZTZmtzUWNTeHY2?=
 =?utf-8?B?dkI2dngzaUw2YUN2RlBMQTRYUkVSU3RjeUVLWEZnb2dZTjZ3RzAwRTh4Z2Rx?=
 =?utf-8?B?WDFCNWkyZFlPdW4xMUR4N1RzYmo5UjBDR2xBQTRYb3c0UEdSdUxCRHBmNHBv?=
 =?utf-8?B?MTI4OHVXckNjOEpMYy9HR1VIRitpd0t6S0xmaDVOVnFLZ2M5eHVma0UzYnVX?=
 =?utf-8?B?UzZhV055dnBRVTFXS0o1WUhlRzlvQ1oyZnlJenF2eUI4QXhDeWQ2UjJnVkJD?=
 =?utf-8?B?TzR5dkZCeEtBV29rQ1lNUGRoUitvanh2SHdtR1pheG5ySUNROC8wTnpIL1Z6?=
 =?utf-8?B?ZEROa21ONnhuaDdmT2o1aytpR3J1SkxESzJBTWFjU2psWVZNd0JIdXUzR0NC?=
 =?utf-8?Q?yUWpiuHDpZ2EJM+Q7MEy8p6VHjRl5XLe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEVtSi9oelVBSkNIaDNRZmZGbWFxMzZSVnhhb2JKWjQ0VEM4Q0pmZ0p1MHZS?=
 =?utf-8?B?K0pWVmlVejJJWkNveHR4WUdZVWtqZlIzRnJvUDhTT3EzbHV1Y3UrQ3BORGV1?=
 =?utf-8?B?cHVQUHU3QlRJSzFia3ZrblorUmJFdU9tYjc3ZWxPZXZob3JMdXFOVmZ3UVB4?=
 =?utf-8?B?a1ZhNFlrOUtpaVFnaU9peGxoNE5zc2dhaWg4Rmw4VmRqVHg1eGJZSUhoQm5o?=
 =?utf-8?B?SnNhaG1jaE9GKzllNmJ5V1cwT0FCT1BsSENmdVdSTDBQU2RtRkNEdmRpcXY2?=
 =?utf-8?B?M2VzdU1sZTdMOFpYS3JHSDhuSFRNcUt1cDlOYWRHeVFtMHZCZmpLYmUvRFEw?=
 =?utf-8?B?cktUVm9NQ0xLQ1p0NUx3c2xERS9IMWNmMzNrWExHc3NPUmNGQ09YbUpZNXlh?=
 =?utf-8?B?b3lsK2NNRS9hQzdLenI4WXJsOFBpNmRpODBhT2JOanB4amo4UGo0TEozaW9D?=
 =?utf-8?B?Und5dTdnb2VJVHhCL0lVM1k2ZlZYMWd6UUl4czJpZDI4VmlYcjdJSWQrUXhj?=
 =?utf-8?B?WDlNZW9CM1NIUGNTclVFTXo4aGJOU1k3OUdoL1lvT0hMSEpXakxvMmRuYmNE?=
 =?utf-8?B?czdDTXhpdVhhUnRpSTBHM1dPTmVPcmlEbVJENU90aDNVdERib0l3bGRYZW9h?=
 =?utf-8?B?dm5mOWpWQzNZQW0vcEMvVy9hM3RwUjdkdDZLNWpvMWZCbnk3Zk9hMHdocUxS?=
 =?utf-8?B?WElhbzU4QUE4NTFLMnl0YWZCVnNlTU5uMHp3d1pPMTNQS3V1Q1JpSjgvQ0tQ?=
 =?utf-8?B?a3pMRjIxMmcrZDc3ZVdUbzJ6S0RUM1hNQ2dqNzZRMDhkZ0t6YUhTN1RUYXNZ?=
 =?utf-8?B?clNZVW4ra2ZLaiswZ0krVnJvbDkza3RNUm0wNC9DREFTUEZobHlqN3NPS2VX?=
 =?utf-8?B?aFN3amlBZGc3UmI1cjROTjFtZ1pKcmUvdEdkVnBBUVhiWEp0Z3dod0t6eVQ1?=
 =?utf-8?B?SjJQMzV6MmpTOThkVDFNemhmZXBpRi9ZYmtUSnk4UTdYU3NjQS9vaVBpNHZJ?=
 =?utf-8?B?elNKc0ZTMUZ2dGF3VURIbWw1aXkwNGw4VnpWQ3B6NU85UWUyMHg2eVNQQWtJ?=
 =?utf-8?B?NWo2azMxOThFUm1JZUxvRXFubnpwQTJmRkpRck80K0F3Q0dBaWhlc3EyT0s5?=
 =?utf-8?B?U0kyTkkwNjdEVmQzTXk2N3A2bWdNSVpBZUpEM0ZRZGdxSFVCV1d3M2lQR1JK?=
 =?utf-8?B?T296Tkczc2tGakRZVWI0TzVSc0tHeWVBT3E5dSt6M085UWFXL1p6MVVyZ3Z5?=
 =?utf-8?B?Q2QrUmUzV255TDQ0dWJoNEhINzB3TTE0cE5xUW8zUno3d0NTRXFRbC9XQjRN?=
 =?utf-8?B?SmtCMjNPam9lTVRidmVsWU1mdTZvM0ZEc3RWY0dIdE5iOFA0dHZoNW9GNlUz?=
 =?utf-8?B?UDk2cHprK2JTNG1BZUgyQTF0YThmRUxNMGt4NjFKLzNZVDVhczRTQVdjT3dD?=
 =?utf-8?B?LzIxNFJ5TVE0T28wazF2QkhuQ3J3RHNMKzR1cmxlQnBGUG5JcmdVVnRFcTVh?=
 =?utf-8?B?ZkRFRHJwNGptV1hXV21jSVNaaFdlNmZSaGh1ditPUFlmakRUdWh2anY5R3Bj?=
 =?utf-8?B?L2ZLc2ZhcDFMdFBYVVBoTnREUklTL3R4RnA3bHdFZk9aWERQZkRDYkZVMG9q?=
 =?utf-8?B?Zkx0emdNa2NISWtNdzcvVVp5YnZKMFArVXl5M1R3cm03YlhLd0I0YVlwVTNH?=
 =?utf-8?B?Ly92cGpyd01JYTVDVWZsMlVQV2VTVnZoTmE2Zm1odmh5eUwzeDZkYmpQTkFQ?=
 =?utf-8?B?YzRHT2w4bDZETmRIOWNxamVqN0VjUDRIMkxnUUYrMzlxTlVaWmRPMk91WUhZ?=
 =?utf-8?B?WlcrZ254aTl3U0dhYmxiNVJEN1dQdFBmOGFqZU9sbURhMTVjbWxkN0t1OVZy?=
 =?utf-8?B?UVRZdVBCUlR5bFNtWHprQ0NyYjIxMk16alZkTWlOT3B6SkxhUlMyUWlWRGNP?=
 =?utf-8?B?VElKU0IzRHNkYU9idkdYOHRJZThqVDB4akkvTGVjSHpvNUV4NVRkSWxPcGF3?=
 =?utf-8?B?SHp5RkVwM1RTTXhUaEN3VUkrZHArMzlqYlh4YlVBeFJ2M2NROUQzaFB6L2p1?=
 =?utf-8?B?aCtGUHhWQzRqRmdwTUw0RFhBeUtZYTBhUGR2UnRhOHdJUWlPKzk0djdiRTlz?=
 =?utf-8?B?cForazgyMVhRYTFneitlbVdtUndyWGxBOW12NElzc1BzT1ora2hFdml3dHgr?=
 =?utf-8?Q?p15GKxhHTelbSWZJDTamlHFTmxjx0TEIca55s/4PitjX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204fa6a7-53a3-45ce-48e7-08de22ff8103
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 21:56:31.2702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fD0ApkJdSkWPLEutnTh+EBhViwa23p1H34a+SaQ4jgIv4u9bFVkLjhcvn6WZRyJG1xeVcWUWg6QDbNiOzzAP9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6771
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2DE44C000B
X-Stat-Signature: qyhtunbmmfwd4ioou3xnk4q7k4n6hxpb
X-HE-Tag: 1763070995-397658
X-HE-Meta: U2FsdGVkX1/avCJSaromUbxD99BENCwvWKgm4MRoibaUOk1BLKEr3d7bRWpc+D5RlAwIue5HiUkZeM3N7C+3oSzNPGue9YGUSLtfnVBnO/SrRInlCsvRcIDm4vvnQypZo0hlY4ucoyHpcU8QJViiF/i9YgCMXCeEQm75E1zxMAe43y7aHKZsrnJGSFqUtyPLND2fiixze96kXDR+6FFZli0jgtVe911IjHkN5jr4QcyVAKg71gNhgVE4sUzq5Q5BzQfVu0ixBDq98pVPf6GlrdRv75VXYFCXCfo0sv9bQie3mgGcRAnsZmc/aiZN2iYKxzTm2MV1tM3G3dwZoeKfmIS8imFf9D7EHny/cXBzHkamIGSDGgjKn8qmadBkOBRwRUJsGsrWNEkBycKfeefTkQecUc1s5pi+gvrf3kNcx0+gLr16E8aClk7UJA4Ywa84TNKzaPszibdisEhKuFI2Y4iqllvSHqZsZEufDp9BiboyrBdvLVWoS2wUQBIG2wsb8nf04eC/eV7b2mHofIzOSyAMKM8A7I079ULdUY4V3PRPZ/nKsNvqcgdaFoUB7KSMw4KPUEiUKxDI4s+cSM/DAv+sizFt+K95S749Rrt67Ldwwwd5z0+tiKo/vmGSykuwIUwxf+jjpx6MCY1q/kYs6iqdrx7On6QlbwmdJmoSeW9fvSNQP5fz/Q+5wzz2EbKL9zBM33UYDee9xIuXadQdZVLyb8YphzivhQuGO+GTDy+O7gwwczTbl7fIQVthc2dioUjwVDcW49hPmJNwo+9ZKtNENKd9gU8SCN7/ZjQSaGR7f5OT5Qb4lHi+nP6/QPY90P6Puqqk9A796+WCCWMw2VlNc55XTHLTAvDTzKB1Inj+BijTnzTyGMpVFNY9jZQpoyeI14GEsWTKX7IQH0s5sWSyKOvsvtBad6H9sxJLA4AnAsWg4eOP/BEoU1MaqpmSXvKTcH0q2T0cs3jH6K/
 nvDy45V8
 O7pVNXuuVNQEcrImdcKgkqFyXQu3U1Y6kPE5550LZ9r/1tUmJggkvn9e+pbVCpss3DS0DglgDZ/Ale225S7/+spWTdSVSFCRf3sy7ytNbH0dxAMzD9TGvqrqBRFeg0YXdoXzanxS1VVim7c5cT9yADKoZ6VVKiZC7PlAFRVlJIUGacdBoBc0oCASn3KC9cZyRktGv8g+z+K5awENOIxfbe3wjrSAyUsuTK3drnkJOTH6W4YZguqsuUX8FcQXYnokN3cqKFJsc13uCn5KxtCbo82mJUkcT59dVmmOFXx7hgyqbnQ4HfSjZx0M5WdQXS+nzVEgJjSx32rSiczhvkGkuujjUEAOCQoSAPk+F6czIYorEZ4scgpc6pOkIKnAe3TplII/teA0z/q5pZvXcLVtbIc/wBZin4nn/SuGpKPNPlZwzwBq07myPijv6a7KOQL4hWNipMGkOykZ7AvMx1NZ6zRMNoygT7zhqTDZOCGWk8Jmsvwk6T7OXPe1col00KhsUuyx9PjF6XIGOcoUQfvgpdbkBv0IO5i/Q2KoFB80kKzIgdwIKWoNrD87uctB52GHYuDz8KILuH/ximtfPT8c0y2OlPeHjdRg9b6m+fXt+l+du/fJc1FCjt6XNPrZkAgVTZJXjH2uj470mYfceLYKn+4wWUiGjW7jwOPjIubCMaLGy1lBqXTft5Zz1guwfL2tj0wkhTI7Azwn40GOdtr5oyKZJpyar8icbvZcUIyV0l90JQPn5bCg4vMSyLzZlxO+aKn6wJ1c99wkQRZo34OJVc9sE5jb8oUqtPEqQSGrOw0Jgw/JPGtbutZoIC4sxaA4pa2DHfuOMDq4lfZw7V0H9DWENFg28ln522dFt2ijSbSTfcK50aA8gYU5apCSIuSsd0Jz5EdgbRR/LjWmlpL6gLccVbQz5Pv/0hBiYChPA5UMA3GQ64Exx4/eOTvE8/KrVBtKA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/14/25 08:45, Zi Yan wrote:
> On 13 Nov 2025, at 16:39, Balbir Singh wrote:
> 
>> On 11/13/25 10:49, Balbir Singh wrote:
>>> On 11/12/25 22:34, David Hildenbrand (Red Hat) wrote:
>>>> On 12.11.25 11:17, Balbir Singh wrote:
>>>>> On 11/12/25 21:00, David Hildenbrand (Red Hat) wrote:
>>>>>> On 12.11.25 05:46, Balbir Singh wrote:
>>>>>>> Unmapped was added as a parameter to __folio_split() and related
>>>>>>> call sites to support splitting of folios already in the midst
>>>>>>> of a migration. This special case arose for device private folio
>>>>>>> migration since during migration there could be a disconnect between
>>>>>>> source and destination on the folio size.
>>>>>>>
>>>>>>> Introduce split_unmapped_folio_to_order() to handle this special case.
>>>>>>> This in turn removes the special casing introduced by the unmapped
>>>>>>> parameter in __folio_split().
>>>>>>
>>>>>> As raised recently, I would hope that we can find a way to make all these splitting functions look more similar in the long term, ideally starting with "folio_split" / "folio_try_split".
>>>>>>
>>>>>> What about
>>>>>>
>>>>>>      folio_split_unmapped()
>>>>>>
>>>>>> Do we really have to spell out the "to order" part in the function name?
>>>>>>
>>>>>> And if it's more a mostly-internal helper, maybe
>>>>>>
>>>>>>      __folio_split_unmapped()
>>>>>>
>>>>>> subject: "mm/huge_memory: introduce ..."
>>>>>>
>>>>>
>>>>> I can rename it, but currently it confirms to the split_folio with order in the name
>>>>> The order is there in the name because in the future with mTHP we will want to
>>>>> support splitting to various orders.
>>>>
>>>> I think we should start naming them more consistently regarding folio_split() immediately and cleanup the other ones later.
>>>>
>>>> I don't understand why "_to_order" must be in the name right now. You can add another variant and start using longer names when really required.
>>>>
>>>
>>> Ack
>>>
>>>>>
>>>>>
>>>>>>>
>>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>
>>>>>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>> ---
>>>>>>>    include/linux/huge_mm.h |   5 +-
>>>>>>>    mm/huge_memory.c        | 135 ++++++++++++++++++++++++++++++++++------
>>>>>>>    mm/migrate_device.c     |   3 +-
>>>>>>>    3 files changed, 120 insertions(+), 23 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>>>> index e2e91aa1a042..9155e683c08a 100644
>>>>>>> --- a/include/linux/huge_mm.h
>>>>>>> +++ b/include/linux/huge_mm.h
>>>>>>> @@ -371,7 +371,8 @@ enum split_type {
>>>>>>>      bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>>>>>    int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>>> -        unsigned int new_order, bool unmapped);
>>>>>>> +        unsigned int new_order);
>>>>>>> +int split_unmapped_folio_to_order(struct folio *folio, unsigned int new_order);
>>>>>>>    int min_order_for_split(struct folio *folio);
>>>>>>>    int split_folio_to_list(struct folio *folio, struct list_head *list);
>>>>>>>    bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>>>> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>>>>>>    static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>>>            unsigned int new_order)
>>>>>>>    {
>>>>>>> -    return __split_huge_page_to_list_to_order(page, list, new_order, false);
>>>>>>> +    return __split_huge_page_to_list_to_order(page, list, new_order);
>>>>>>>    }
>>>>>>>    static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
>>>>>>>    {
>>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>>> index 0184cd915f44..942bd8410c54 100644
>>>>>>> --- a/mm/huge_memory.c
>>>>>>> +++ b/mm/huge_memory.c
>>>>>>> @@ -3747,7 +3747,6 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>>>>     * @lock_at: a page within @folio to be left locked to caller
>>>>>>>     * @list: after-split folios will be put on it if non NULL
>>>>>>>     * @split_type: perform uniform split or not (non-uniform split)
>>>>>>> - * @unmapped: The pages are already unmapped, they are migration entries.
>>>>>>>     *
>>>>>>>     * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
>>>>>>>     * It is in charge of checking whether the split is supported or not and
>>>>>>> @@ -3763,7 +3762,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>>>>     */
>>>>>>>    static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>            struct page *split_at, struct page *lock_at,
>>>>>>> -        struct list_head *list, enum split_type split_type, bool unmapped)
>>>>>>> +        struct list_head *list, enum split_type split_type)
>>>>>>
>>>>>> Yeah, nice to see that go.
>>>>>>
>>>>>>>    {
>>>>>>>        struct deferred_split *ds_queue;
>>>>>>>        XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>>>>>>> @@ -3809,14 +3808,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>             * is taken to serialise against parallel split or collapse
>>>>>>>             * operations.
>>>>>>>             */
>>>>>>> -        if (!unmapped) {
>>>>>>> -            anon_vma = folio_get_anon_vma(folio);
>>>>>>> -            if (!anon_vma) {
>>>>>>> -                ret = -EBUSY;
>>>>>>> -                goto out;
>>>>>>> -            }
>>>>>>> -            anon_vma_lock_write(anon_vma);
>>>>>>> +        anon_vma = folio_get_anon_vma(folio);
>>>>>>> +        if (!anon_vma) {
>>>>>>> +            ret = -EBUSY;
>>>>>>> +            goto out;
>>>>>>>            }
>>>>>>> +        anon_vma_lock_write(anon_vma);
>>>>>>>            mapping = NULL;
>>>>>>>        } else {
>>>>>>>            unsigned int min_order;
>>>>>>> @@ -3882,8 +3879,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>            goto out_unlock;
>>>>>>>        }
>>>>>>>    -    if (!unmapped)
>>>>>>> -        unmap_folio(folio);
>>>>>>> +    unmap_folio(folio);
>>>>>>>   
>>>>>>
>>>>>> Hm, I would have hoped that we could factor out the core logic and reuse it for the new helper, instead of duplicating code.
>>>>>>
>>>>>> Did you look into that?
>>>>>>
>>>>>>
>>>>>
>>>>> I did, I ended up with larger spaghetti, I was hoping to look it as a follow up
>>>>> after the series with the mTHP changes and support (that is to be designed and
>>>>> prototyped).
>>>>
>>>> Looking at it in more detail, the code duplication is not desired.
>>>>
>>>> We have to find a way to factor the existing code out and reuse it from any new function.
>>>>
>>>
>>> I came up with a helper, but that ends up with another boolean do_lru.
>>>
>>>
>>
>> Zi, David, any opinions on the approach below?
> 
> Looks good to me. We might want a better name instead of
> __folio_split_unmapped(). Or __split_unmapped_folio() should
> be renamed, since these two function names are too similar.
> 
> Maybe __folio_split_unmapped() -> __freeze_and_split_unmapped_folio().
> 
> Feel free to come up with a better name. :)
> 

I had __folio_split_unfreeze() to indicate we split the folio and unfreeze at the end, but
it does not reflect that we freeze it as well. Looks like we are trending towards folio_split
as the prefix (IIUC Dave correctly), I like your name, but if folio_split is going to be
required then may be __folio_split_unmapped_unfreeze()?



[...]

Balbir

