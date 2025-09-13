Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FF3CA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D966B000C; Fri, 12 Sep 2025 20:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE036B000D; Fri, 12 Sep 2025 20:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACDF8E0001; Fri, 12 Sep 2025 20:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 746B36B000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:22:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B1AA873F4
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:22:41 +0000 (UTC)
X-FDA: 83882326122.29.8A300CC
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62B3B140008
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:22:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VaQBfWyD;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757722958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQlqyHJ7x1zhYaABs88K9h1mXOBfgI38Lh9FU8kNPTM=;
	b=daxW05BNlzh+zPmElXUVwoubJcrppZ5lcS8cHX0R/BZxBvidKU8OGaCvfaNQUfm3wZJbwk
	YoO85b9POSdyntgMdzM/Blm4Rh332mFFydsCqRlFlcDhvZ6H4x9Poj91ElAjZ4dRxtUAs+
	Gs4DM4X5yN7hLfUQanlkUo0FnlBT8oU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VaQBfWyD;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757722958; a=rsa-sha256;
	cv=pass;
	b=np4VZ4RbEQgO00aKvIS7S3JuVIZo68N7mfXfLWW/jaJrfwQBp5DVWWM7EjWYLprsAxA5/k
	fq0elwBClRUc1BxwGbVGpTixfs9hmmwGv9tLahpbBqTA142Y5YO753qbssS1eiR9ewufxE
	F+qGot8vbIP8DT69JtwrmU1gldUuYpg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BiqU/lp05qULgRjB9/pqcGPkYR1K0ghBCA+NICH7BWgLlIeroRxCTw1ShCOtL84LDwrPdePvPJIvF2/IN/hM8p83mo7hVgj/VzexNzymvA27tuUOH+P1xl77G4R2geeSPbPKc/Y6foMe/pTX3xsm6nSqDA6LvgP9jQ0jAk61qihvbOwikrA9yUryKUVo/D6WW0ligvcB8Tgez/AP5X0vmJaWqXsHBWjzvno7Q7fOfQP2IbLsXeqD2HTQ3MdhFKA6edLzkXKdrzMZRt1ksmYikpR8NjMwowOZWsdfr2bUktkgbU4J8mjIHpvGXScgxjBinl3+h2hhH6R5YeG5VWypCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQlqyHJ7x1zhYaABs88K9h1mXOBfgI38Lh9FU8kNPTM=;
 b=dylH5jZrYEG56vi/3Bpwn22TadaZYV5I5+WPRlxGHN5H9653lwWapfPO9SmgQ0RKpxOoGv7RSkIqlGDyqB6l1r9KGm5+U6sIhwtwAiNh+1/6aH45ghNpz+CRweHhBqvbFebkiQjnq1mI4CRp+qda3gvQTfZl/9rQsZJdiiDQ8QxQBQrB4yBko1GpGGWrtSgTn6RQA/BD8FA9a0lpVB9TMdNDl9cq5ZDUXXdDK+r7NhLotWLfxIgaCgKUHs6xiEZDSVMmt7+5eTq6AXdPjOxpkOkvBWyKVG3hS4oGiDyQTH0uhn/UIexEC7ZE4S3OWb/y2JqBawgel+0+s92FYHybbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQlqyHJ7x1zhYaABs88K9h1mXOBfgI38Lh9FU8kNPTM=;
 b=VaQBfWyDtuQ9B5KSV1r2hnx6P09KbIEB5vh5zQa4Nf+QZSMYrHc7neXekvfzt1w7Ibx3wdcRX8/x2bNnb3Tje67WDmfcb7cYy6SNbgGCb2YaOMHmW26ZeqvvocynEqodLZh7W4doqO9gaVLtY+VLCcPSIlQ2fq6t5tFWVx1ZAey2ePRQDYVU9BbZ5rQ9lg+f+bA+1XPR+FUs2GYgk1lmf8JHIyGwctJjlrJ0rYQF7DbXA1jv/UkUPxMrRznMjdZz0dHlMKb3WiLlo5XRLxW1mhrvHGQbw5h5ckTu6zpH9BQOs7Pz6GLQJ4YtbF8jLbUIxQROICJGJcGZqRz6vk7DZg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB7739.namprd12.prod.outlook.com (2603:10b6:610:151::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Sat, 13 Sep
 2025 00:22:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Sat, 13 Sep 2025
 00:22:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Fri, 12 Sep 2025 20:22:32 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <1E7C1A9D-F8DB-4CF4-A84D-09B7FF75C1AD@nvidia.com>
In-Reply-To: <2e2dd208-c3f2-4d44-835e-003af2f019bd@linux.alibaba.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
 <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
 <20250911033413.qcs74q4n6n6767zj@master>
 <20250911063034.uafc5mmnf7k4d7km@master>
 <EBA618FC-889E-48A1-AC02-9A18F6B5943E@nvidia.com>
 <20250912002854.plq5uhy432xq6puv@master>
 <0D6DB0F3-A893-4B60-9939-FF4575FEE3CB@nvidia.com>
 <2e2dd208-c3f2-4d44-835e-003af2f019bd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:208:329::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 172d94f0-eceb-44f4-c0fe-08ddf25ba2ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1Vtb1hHVWo2SHgvRGhzSlk2Qk1jNkgzV1J3ZzgxdExvbkxqdHFLdWtVdGMv?=
 =?utf-8?B?ZUw4c1d0K1JFRUdYNnh4Ny9RcVFUYTF5cUsrQkl0N2xPMElMemJXa3QvWWVi?=
 =?utf-8?B?WmpWMEtocitTaitBUzM2T1FiT21WanlIZUEwYmVwaW1aR3V2djZLM1AyczV0?=
 =?utf-8?B?WWV2aUZEUER0K1BJS3VYbUpRSlluNkErcm9SZW9kSkR0Q29odFh2ck9MRVN6?=
 =?utf-8?B?VUwyRzd0NVlHcHRQS0NIa1R3RFhBOE4xRVN3eS9Jd1hsMzY5NWp6Vzkwdk9J?=
 =?utf-8?B?R1hPNTZvNk84VGFZNllqMnFib1RRa0s2STN0TEVzbzJXZjBRZHoxTWhBc2RO?=
 =?utf-8?B?dVJjbEpxMCttRzZLTTh6Y3RpSnZ0dVJQZ2JrUmxmdlZvckdsVjNLK1NWejFl?=
 =?utf-8?B?Z1d4UkJGQnJCcGdZWThna0laQlQ4MFl4WkwxM1pXbWdSSVZzUGlwV3BIbWVJ?=
 =?utf-8?B?dkQxeGR0YUo4Q2VGaS9UV2pEQ1N6dEZCY203MGRjbVhyRjZmeXJIaXpLakxk?=
 =?utf-8?B?NjJIejV6NW5sN1N6eU00a2R0WnczWUpXUzloSVNhZ3dSRDFuV2QzcG1raXd2?=
 =?utf-8?B?VGk1RXo5dWd6ZUtldDMrbHM0QnYyTVoxeTFFdHk5S0Y4UUNXS0l1ZkRxQXc0?=
 =?utf-8?B?Nm9qdHhsZ0RtUTF0dGxXRGNEV0JqK1ZMcnoxekZUL1F3YzRFUk9LeWNmbi8y?=
 =?utf-8?B?Q05sbUhzS0ljWjNNV3ZiSkMybkpWdndyZHZQVFErQ0NSbUxWMnNCOHU2WnhS?=
 =?utf-8?B?Y0lRVFZzeTRRaWhHVjVjZnBEc3M0OFBJNUJWVURsQUtwODBUV1VPdS9NN1hC?=
 =?utf-8?B?L09VbnRtOTJZYWx6YS9RYjR2TTZ1dEJEMndiSGkwRm1LNjJzMWtTRnhSeUdP?=
 =?utf-8?B?TDg4dWluOWM4S3J4M3BXOEdjNjVmSGNLdzdrNjBxNi9zb0pBeHNMdmFjaTRF?=
 =?utf-8?B?VkE4d2t4R3Z1Q2VYTU1Md2VYQ1NZTEd4VHJNWEhnQUZydWcwT1c5ZE9GUHdq?=
 =?utf-8?B?TWRzbVh2aVVTMGFVZ2dNM1NCVWllNW82UFZkeHI5emJvaDZ6eTNtWWxDYzAy?=
 =?utf-8?B?blNscmZFV3ZrR3dobTlJVGtjM1FPUGV5NktGM1V6Y0tiOTQ1UW13dDZtd1dS?=
 =?utf-8?B?dEpCdjFlNnB1c3ZzN21FazBmRkRLWU9vRi91QkxEVWNndTRRRS9UNm95RlRZ?=
 =?utf-8?B?ZG9IWWlXZWc3dlVOUS9PYWtWL3N2cVp2MndKck5XZk5EOG43ODZ5M1krMThO?=
 =?utf-8?B?WlFFZ1BISFhjakRLRlZCNnBGSHczbkF2emRnKzZWbXpwRjFFV05LYkx0Mzcv?=
 =?utf-8?B?S2FGVTlvMDg3Y3FVN3VsV3NxN2ttVm9tY2l1UVRYOXVzVnVXWVVqVzNjSVhG?=
 =?utf-8?B?c0RTQm5ROFRucC9LRis5OUoxTVM1UStZNjhUbi9RV1FCN2FrR1lZeFpua2lr?=
 =?utf-8?B?T3JOdGRxMFZiYTc5M2ZUblp6K0dCNERoVzVuS1RydDRnWmJ1WWVuY0c4N3Zs?=
 =?utf-8?B?eG1VTTNxaEMydFV2Uk1rRTFoVU9iKzQ1NUZ1VTVQMUI1YUJ0TEVMM0YrdDRY?=
 =?utf-8?B?b0tjdDgxc2V1SXF0TWQ2U2tGOG5pY21BTVJvd3JyR05HK2RUNXk3d3Z1UHBM?=
 =?utf-8?B?YUQzMW1ZM3BmNU41azBlV3dHS2JMbk52T1k4TE5FYWtFMi9qTGVSWG1kUmxE?=
 =?utf-8?B?UmhMMzR1cmxGdE95REZkQUk2Y2M0U1hMN3FvWWk4SDU5ZCt4K0dHWStpZWw3?=
 =?utf-8?B?QXdGaVhFVjVqOFZOdFROYzVtVjVXK21aNElzSUt1RitSMmZ3WndRdHhFQU5O?=
 =?utf-8?B?QUl2S3RaK2JZMUYrSEFqMjRFNWdLcTdUZW1tU3kvYUNsc3lXVG9vcnA4eGVY?=
 =?utf-8?B?VDlIdXlQS1ZISDEzNFdJYjlEcjliTlZFQWRYUnBEZDRrNlhFTTlUV2tSbG1z?=
 =?utf-8?Q?BU3Wt6cso2g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXdUS2I5TjN2cjlXZjZ4MjBzTGVWc1dCUUJ3Nm8yRk9vdUNZZm1sbk55ZXVa?=
 =?utf-8?B?aUsveFFuakRIcGpkKzE4L0tlb3EvY01aeElsaXczNHZzcWNNck9EeVd6ek5s?=
 =?utf-8?B?b2xOTzE3N0krRmhkSmdUclRWSTF2T1R0VE5zTlBnYklicFpGWUpndFhISG5j?=
 =?utf-8?B?NkcyWCtLRHNaVHkreSt2OXh4OGg4cGZ5YVVpbXJvNTU1clN1V1NpY2NFZTZa?=
 =?utf-8?B?MnBzRDJUR1k4bGliMEx2UWpjOHhBSGZ2MUtnU1YvTjRJVVdiNllFTm9QcnRq?=
 =?utf-8?B?a3IvU1EwazVVVlN3SFpwVWc2NlRDSWtub2lOdG0vWFFFZUlMWDFZN2VCYmpL?=
 =?utf-8?B?Nlc0T09GZnZWWmtUTnRPVnByYmlhQUFhWGRzcjBPemZaZnNtSGFhZ1RXbDVE?=
 =?utf-8?B?Vzh4emZ1bFJzT1lUelVWejF1VnJoUllXa2JhVVVRUjI1V0x2NDd2QmVydjlE?=
 =?utf-8?B?dEtQZ1pTU3pSdCsrSHFuSEh2VDVqY2VNdndpSzFjZlVvc0NXeDlLY2duWDNU?=
 =?utf-8?B?ZHhMTUF3N05zV0JJcGxSVDY4Sm0wR3J6Z1kxS1VSejNYSkJSZnJKTXZIU00w?=
 =?utf-8?B?YW5mT1gxcHBvL3FHcWpURTVTbGROMlU3RmU2cFZ0ZFMzRk1BWkt3em1NcU40?=
 =?utf-8?B?TFVuM3dHVUFoV1NRTWpwL2lsOEI3WjMxTnh6bDc4WlVFRmdXUUZBNW80djk0?=
 =?utf-8?B?cnJSbkxKUXNpNGdiNFA3bUJRVFNOdzZHTnVHSy9JQk9oS05XTFdPU05zc21z?=
 =?utf-8?B?MDRKYXdBU1pVWTcyVFBmVDBqR2F2QmVtSitoMXg5UlkvM0JRVEN2OTVnUFd3?=
 =?utf-8?B?MFYwQVFhRldxZUkzMTBYdGQrb2FCWWxqeXZMdGVDQlRBSS9oc25YbjNBQmoz?=
 =?utf-8?B?OTdyNzQwQWl2cVpFYWJnNWQ1SWIxUEh4dUwyaTZENkVBWWNaeGtLN3lWaWNp?=
 =?utf-8?B?NkdhYUwwUVpIODBRT2VDalNHdFNWNlpvVXRkWXh6VkZTeXlBbE9GQzNxdXBy?=
 =?utf-8?B?dWlRS01IUFNyOHlDeU10WEgrY3dGUG1xUDI1RHViVGx3ZVhVSGNyR1ZWTnFm?=
 =?utf-8?B?RW1PZWhXSWFlRlBWUmVPdUduVFhpaVVNOXBZQzhLalVxS0dmNmNkT0o1ais0?=
 =?utf-8?B?eDRuR1JabDRraHNPVFVqZ1BZd3R6dUsrV1Y4RDM0WVNZc05mSTJRNzJmaHV1?=
 =?utf-8?B?dkZaMyt5SzNrVXlqQm5sNjREMUZxTjlSYkR3NU5TWHBPbmJrOXByY2NjdDB6?=
 =?utf-8?B?cWZNV3UvNndmUGI3SXphOEovaWsvdjRZQytHWVI4dFVWUVJWMlpLaTF3c2M3?=
 =?utf-8?B?ajg3QXZoVmdBeWVoM0l5dDlsOWo5VEUweWgzRTJjTzZwQTl5Z1pRL2tsTkFl?=
 =?utf-8?B?VnBPbENJTWpqVUdRdXIxSUN2Z0VtUE93emF1ajJJdHNQU2hzT2JWM2FCL0JM?=
 =?utf-8?B?Y2I1cHRFazJMczgvZXBVNDl2T1VSODB3aEdwMDIrZTY0cFFrU1FwbFN2Qnpa?=
 =?utf-8?B?RW9pSGVHR1RpVnNpb3p4SDhJRW9QK2lVOWhnTFh6SWJnSzlaOGVVUjY3N2VM?=
 =?utf-8?B?aUtwZ2h3WEc0TmJKcDFaTkVZQngzdlRLejJ1ZklESXJGdm9Oa0FFeGdDWDFZ?=
 =?utf-8?B?TDllb082YjFsV0dCaTNuSVV3US9XQ21hdmZxbDZhM1JyNmk2ZTNPLzNGL1dO?=
 =?utf-8?B?VW4yOCtoSGh4cHVjVzBMTFRObS96OGVmcjVndEFPeE53d2Y1aVU5OVhiaCtB?=
 =?utf-8?B?SkZ6ZHBYdXRJYUZNUzAxT250QlJsMTFzZFM5dEJPY1BScEJQTXIvaXJGdk8r?=
 =?utf-8?B?MCsvMm9iNUJOTHAydWVoSTRrdHV0QjUxVTVVVUVCSUw2YnZlbVJvWVZmSnVx?=
 =?utf-8?B?aHlkeG9aOEVYT2l3UEx3NGhLNlFLVFFSTGZvSENmQVF0VGtpM2hoK2ZFOE03?=
 =?utf-8?B?a2liWmpZNE16YnZ4b0RWV3dJZ005UXNwWjVYbEplZlpYNlMrVjRiZHpjV2d0?=
 =?utf-8?B?dVVCa2laQW81SytBT3lDa04waTJOZ2tpQks1R0RiVllnM2lQcnlEeDhUN0Y4?=
 =?utf-8?B?SEZNbE03ckNqdlJvUHpWS1JQTUN6alN2bGs4WFRHNHRDNEFWSk1obWF6MUdK?=
 =?utf-8?Q?VH1rXrSifDJ9tc/XNGBjdP7pj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 172d94f0-eceb-44f4-c0fe-08ddf25ba2ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2025 00:22:34.7289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzIxuvG45kGp8WfUGmyTzlIgMbX6zOh8JFzwXVeRaFcDEVWo1U2HeKH1dpt0+pm8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7739
X-Rspamd-Queue-Id: 62B3B140008
X-Stat-Signature: xn1z7pndo8g9ygx7z148x1h6wzn3zm45
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757722958-581311
X-HE-Meta: U2FsdGVkX19lSk6EX6U7mzCspmlIDO3dgBIUAZaxugR6h/KUq+DabQWTzdhtcZyY91UeecSi9x9GKIUQ3Gq8DTzqrpBlWj9bI+jEIQVYS8xEMAM0+TGskLkF/zh3C+LHJmYdQuDMuTomq57YQSnXe56JlAx1tHM3TLyH6qgMIoQD5CLBJIctBTS1zKiJvC4Nfw/bJ3bLKpq3iHxtfylkJEbgsr131/XUoPe2AL6BByji52RS1jKwnd6jLBoUoy2DqtlGppsCAwf9/jgG6YkvS1TbZWBNG6hk6IyuHfK7UuaK6zipoqaRV1tq2QYug8L+J/JNvPzx2HoAWeK1S4sZwyYKf7DdKJsTyjNoyFX46bsxdG9V/hm8S2ERzn8fNJzAz3/gdHbLKwYRLGBOBtXRvor3FXKxjBDpG2J9t/IGVjD/SaA47hHNv6w3uvX0dblRJdqSE2YmCqF0GG2r+uLwjsd2grc8bh3O85OBispg5FC2ZTbr27QDmdbeTSVi7HkG4z58g09JLBkaors7UTu9Hk2zTt0nTEILgjB2AB6QlLE0FXO0Kn6iUlAPZYbFGhOAfMPSCiN+9qQUKUFTolt0qX68QeqskM3B7CRAsqQ558OqST6Y8wnzyBTrlevK4646x0N0o2AuiAdJllAM2VxeQ/LD+L78JZnAZ5YWmZs78OGexxGegAZ2yShETBQEHbREQL17SV683cz8Yeghwa23jDXuRuh3ctO3Bsbspt0OT8WIYG+OE+UM+ReAkwBhc+xhwldG4V1eeMEXqDUOlWBj6BB9UZs92GDvZpx3oZcrQtXCryg+3iZe+jjyq+2Rd0CmBEsZsLsFTvra+OFiDGq+LdR9sfbvXjugTdtpblpi7vcN8VAY4xa21rDxCTnBnxVhiw25RUs6hTPxfVIoQ31m6qUOpHUwotuDstX6LgBeGkJBvzM4Jk1UEBypLvWBZp8mvuIPdUC6pfgwumRtXxK
 ZbhfSCbk
 G1c9HxVhOanelAQ9Lwd/LDBNP8LyTuShr7AiIqPoX9v3V6fM25wF/RjasHvGUY3rZ4mcX+kojjpjCzPg2/tHg2xUyTNOM31/YtjcHUdN7kKM3b9VWwWpU2ThSUti/OKI918vkrcq5mI8TkpWoHV0unthJlY5PVzCUfQ1A4szOWaR9TgqZzppmLoIixpKaVdy8myvj1plePJBJdSu0ZzRoignadesYdBLfkfbahNAGWSNYg/CZOy9nFTQgmAxwhN+ANyIpnqXC7IsH0GBgvNp26asNQZBctYjY0YfOzisCl31IeMivfpUkgOa/2YgFh43+I+It8ALCMpVdMT+IsUSYyPyw8fhWaveyfTAQ6vle5Dt1ax0g0vW7cXa/DhsvvbpcBhcQd06mPMk7sXSItgkxkPBpXom8kHKMLGPpVn0xQyE6agcBRrF242eFILCpEkxgKpS6QtrehOBofG6e9avMStnKSrAcbIB0kA+ijH7nkszf05/ihqfzmeXMVlGzbrF2cr5TjfL6GMiBkm5XOeD+84qIOOoEVtEKgwjezux5MX5snREAI+2ygsK07IXfcyG+OBGIjc0h2OgYN8dv9T5x7xicTBldt3T3/OpjpuroZT32kqo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Sep 2025, at 2:00, Baolin Wang wrote:

> On 2025/9/12 09:13, Zi Yan wrote:
>> On 11 Sep 2025, at 20:28, Wei Yang wrote:
>>
>>> On Thu, Sep 11, 2025 at 12:28:24PM -0400, Zi Yan wrote:
>>>> On 11 Sep 2025, at 2:30, Wei Yang wrote:
>>>>
>>>>> On Thu, Sep 11, 2025 at 03:34:13AM +0000, Wei Yang wrote:
>>>>>> On Wed, Sep 10, 2025 at 09:50:09PM -0400, Zi Yan wrote:
>>>>>>> On 10 Sep 2025, at 21:38, Zi Yan wrote:
>>>>>>>
>>>>>>>> On 10 Sep 2025, at 21:35, Zi Yan wrote:
>>>>>>>>
>>>>>>>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>>>>>>>>
>>>>>>>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>>>>>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>>>>>>>>> isolate_migratepages_block()") converts api from page to folio.=
 But the
>>>>>>>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn=
't point
>>>>>>>>>>> to head page.
>>>>>>>>>>>
>>>>>>>>>>> Originally, if page is a hugetlb tail page, compound_nr() retur=
n 1,
>>>>>>>>>>> which means low_pfn only advance one in next iteration. After t=
he
>>>>>>>>>>> change, low_pfn would advance more than the hugetlb range, sinc=
e
>>>>>>>>>>> folio_nr_pages() always return total number of the large page. =
This
>>>>>>>>>>> results in skipping some range to isolate and then to migrate.
>>>>>>>>>>>
>>>>>>>>>>> The worst case for alloc_contig is it does all the isolation an=
d
>>>>>>>>>>> migration, but finally find some range is still not isolated. A=
nd then
>>>>>>>>>>> undo all the work and try a new range.
>>>>>>>>>>>
>>>>>>>>>>> Advance low_pfn to the end of hugetlb.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in=
 isolate_migratepages_block()")
>>>>>>>
>>>>>>> This behavior seems to be introduced by commit 369fa227c219 ("mm: m=
ake
>>>>>>> alloc_contig_range handle free hugetlb pages=E2=80=9D). The related=
 change is:
>>>>>>>
>>>>>>> +               if (PageHuge(page) && cc->alloc_contig) {
>>>>>>> +                       ret =3D isolate_or_dissolve_huge_page(page)=
;
>>>>>>> +
>>>>>>> +                       /*
>>>>>>> +                        * Fail isolation in case isolate_or_dissol=
ve_huge_page()
>>>>>>> +                        * reports an error. In case of -ENOMEM, ab=
ort right away.
>>>>>>> +                        */
>>>>>>> +                       if (ret < 0) {
>>>>>>> +                                /* Do not report -EBUSY down the c=
hain */
>>>>>>> +                               if (ret =3D=3D -EBUSY)
>>>>>>> +                                       ret =3D 0;
>>>>>>> +                               low_pfn +=3D (1UL << compound_order=
(page)) - 1;
>>>>>>
>>>>>> The compound_order(page) return 1 for a tail page.
>>>>>>
>>>>>> See below.
>>>>>>
>>>>>>> +                               goto isolate_fail;
>>>>>>> +                       }
>>>>>>> +
>>>>>>> +                       /*
>>>>>>> +                        * Ok, the hugepage was dissolved. Now thes=
e pages are
>>>>>>> +                        * Buddy and cannot be re-allocated because=
 they are
>>>>>>> +                        * isolated. Fall-through as the check belo=
w handles
>>>>>>> +                        * Buddy pages.
>>>>>>> +                        */
>>>>>>> +               }
>>>>>>> +
>>>>>>>
>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>>>>>
>>>>>>>>>> Forgot to cc stable.
>>>>>>>>>>
>>>>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>>>
>>>>>>>>> Is there any bug report to justify the backport? Since it is more=
 likely
>>>>>>>>> to be a performance issue instead of a correctness issue.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> ---
>>>>>>>>>>> mm/compaction.c | 2 +-
>>>>>>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>>>>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>>>>>>>>> --- a/mm/compaction.c
>>>>>>>>>>> +++ b/mm/compaction.c
>>>>>>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_c=
ontrol *cc, unsigned long low_pfn,
>>>>>>>>>>> 				 * Hugepage was successfully isolated and placed
>>>>>>>>>>> 				 * on the cc->migratepages list.
>>>>>>>>>>> 				 */
>>>>>>>>>>> -				low_pfn +=3D folio_nr_pages(folio) - 1;
>>>>>>>>>>> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio,=
 page) - 1;
>>>>>>>>>>
>>>>>>>>>> One question is why we advance compound_nr() in original version=
.
>>>>>>>>>>
>>>>>>>>>> Yes, there are several places advancing compound_nr(), but it se=
ems to iterate
>>>>>>>>>> on the same large page and do the same thing and advance 1 again=
.
>>>>>>>>>>
>>>>>>>>>> Not sure which part story I missed.
>>>>>>>>>
>>>>>>>>> isolate_migratepages_block() starts from the beginning of a pageb=
lock.
>>>>>>>>> How likely the code hit in the middle of a hugetlb?
>>>>>>>>>
>>>>>>>>
>>>>>>>> In addition, there are two other =E2=80=9Clow_pfn +=3D (1UL << ord=
er) - 1=E2=80=9D
>>>>>>>> in the if (PageHuge(page)), why not change them too if you think
>>>>>>>> page can point to the middle of a hugetlb?
>>>>>>>>
>>>>>>
>>>>>> The order here is get from compound_order(page), which is 1 for a ta=
il page.
>>>>>>
>>>>>> So it looks right. Maybe I misunderstand it?
>>>>>
>>>>> Oops, compound_order(page) returns 0 for tail page.
>>>>>
>>>>> What I want to say is low_pfn advance by 1 for tail page. Sorry for t=
he
>>>>> misleading.
>>>>
>>>> OK, that sounds inefficient and inconsistent with your fix.
>>>>
>>>> While at it, can you also change two =E2=80=9Clow_pfn +=3D (1UL << ord=
er) - 1=E2=80=9D to skip
>>>> the rest of hugetlb?
>>>>
>>>
>>> Sure, glad to.
>>>
>>> You prefer do the fix in one patch or have a separate one?
>>
>> A separate one is better, since these are optimizations, whereas your cu=
rrent
>> patch is a fix.
>
> I'm afraid we should not do that. Because the order getting from compound=
_order(page) is not stable without lock protection for a hugetlb, This is w=
hy we add a sanity check 'if (order <=3D MAX_PAGE_ORDER)' before advancing =
low_pfn.

But if page is not the head, "low_pfn +=3D (1UL << order) - 1" will skip
more than the hugetlb. But it is OK, since these two are isolate_fail
cases and make alloc_contig =3D true fail anyway.

OK. It seems that we should leave two "low_pfn +=3D (1UL << order) - 1" unc=
hanged.


--
Best Regards,
Yan, Zi

