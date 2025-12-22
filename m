Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09FD5D68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 02:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED6C6B0088; Sun, 21 Dec 2025 21:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291076B0089; Sun, 21 Dec 2025 21:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149596B008A; Sun, 21 Dec 2025 21:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01D056B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 21:30:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D3828BB20
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:30:34 +0000 (UTC)
X-FDA: 84245528388.20.15ABB29
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010045.outbound.protection.outlook.com [52.101.85.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 55FC51A0015
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:30:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tesZ7u8b;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766370632; a=rsa-sha256;
	cv=pass;
	b=EPl5R4i1fj9XSTzGXLw7gILLGixm1aXGmxSRVKJ43SY1OAsroVGkE+pACogruOfLHqeYl9
	w0qheP2tEw8U/T0+eNo3h+mMenLH06cdMsh1ovqIgwXV7UyLANmxAmwXXdZlubZukykPVZ
	+jBlv1Aa0Lae+gefimI2qfHKlks4jno=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tesZ7u8b;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766370632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G10bK4TrRbNOoRLAaJ1ZzHPFoT71RC2LwEZuHoJICLs=;
	b=nInBR2YJDqSD7OcYX+Zj8P76yOnIOQYqNdtsMjyN7n8KYGq1scj3AB6Oi08PgZFzxpPiaz
	wPJQls4IvpwvFOuCjrKLO/38hdPaSMfrS3zAelWv3ZWyx+vZTh2PIlL0Uu2szW9W736s71
	FSq3kYFfVspXKsogOkUj/UjVKTMGv6U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wBmU1aFqAdgT/iLnxXY85MF6csb6Eot0+nR/ergEcaUmrlD2sBryLbefwMcaOSlu0Cf6cosYBacTBxT7Ly6CGT7HtItYAh36Yw+lfF6Coi5HyoO4JKBwSsVKHR974Os5o2SsCNFNOQ5rtCD9+A8JKGd+7v3DOqCSq/PYpjVh8wZHNrJ6pHbozUBoO6PlefBpfvulxuAoWg2chuehXC6OF68EjzomQM7oLnGG4TOX/R7RhoQ8WJHWRUVguIlSiDb1UQ2C77zwkyrHfL3ZLoFXBuzbkand97X19akt44HFptX2tjee2FuhpmmCt9fS/pcIuiLSwZzVMJqspSdzXQH6Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G10bK4TrRbNOoRLAaJ1ZzHPFoT71RC2LwEZuHoJICLs=;
 b=cFX+MIRTOVDnTrAv7C5HJ1I+wJPTmjZA4oVEtLQ1Iyrdjxh4Ra0QFOfNVO/yg/X+s2KpQnh/4ys+O69+9FinDIrRdkVXg/GDdaWzZU6ZQ2qwaG6dcMyOfxeK231poE+u2vRbLnUHVJJjyr/YS7e0W3fZh2GHvoEqJEriD73k+FoMzIPpxgFahFVN0IZ99aikrUui/prfm1MAH50gWWLcMu+Ce0IFSUE3nn43Ldvzvy/J9vHXrbyD30Hyj4eB3JRTMAcuPUffuR84/y3y7LTlsFDew6Vgy0m6eE/lssmycbBc23K1VDq7yHBCE7dGfyg2BlkiBr5SntVcf1+EvzXupA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G10bK4TrRbNOoRLAaJ1ZzHPFoT71RC2LwEZuHoJICLs=;
 b=tesZ7u8b019g80+q7Pmnf8FZ2VlJ/gAC04QzOpgWZh2ffgEvB+SccDp9o1KIwnw7uNpU/TCfyHX2xl1rUbd8KXmnidMKN67SBG/45/+cZvuQ0vtdvlp799CqHWEB6k/y5ujAAMOO39btc02tvtR9lmpymGVZqBoVNdrtUgAQNu0DUAz5w8Sjcq3EIzMXqs2LNbhQRLs7+si8of1WaHxuMBzhKremLayxZn+yb3yZTsRejRvV7t9+/vzPl0/IMdmK7jSKrBM+fXXFDEszNhl5+fuavDiJ3Tg2XGmpa8JeU7MtQDItgfE1JYIFUch6P1iVkl9Y9jCMUlQr4qVmc2TsKQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8457.namprd12.prod.outlook.com (2603:10b6:610:154::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Mon, 22 Dec
 2025 02:30:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 02:30:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Sun, 21 Dec 2025 21:30:24 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <FB368603-C871-48A4-951D-B8B605DC4583@nvidia.com>
In-Reply-To: <3627fca8-4133-40b5-9883-5163dcbc91aa@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
 <4B10600F-A837-4FCA-808D-6F8637B073F7@nvidia.com>
 <0eb081b8-3982-48aa-a9ba-9cdde702b4df@huawei.com>
 <A276ED1B-89C8-45A0-8DA9-9D5CA1D8E2FF@nvidia.com>
 <6e7df7a8-aaf4-4960-82be-dea118c5955c@huawei.com>
 <0168824D-37E8-4E22-AAF5-43DDB38F0FED@nvidia.com>
 <3627fca8-4133-40b5-9883-5163dcbc91aa@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:208:120::42) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8457:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f2aaa1f-7058-4e25-9073-08de41021123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U205bXpPRmZlTm5qUkphc21uZ1R6ZksyQUUzZ2JYSXQwQ1FWTFZaNDI5VkRv?=
 =?utf-8?B?amRmRm0xenB3b2VKS0NBalkwd2J0SlFOL3VyYmRUYmpmRXZXdEk1azVac2U0?=
 =?utf-8?B?aENYVUFDN2M0Ni81TEJrVzhIc3hETGZRSmptZXFDZ3oySlJselorVUlEU1pZ?=
 =?utf-8?B?YUZXbUFtRGQyZ2hjU1dIRUxwN0IvMTQ1amJpWVdpeVc4cTFPemkxTjNmelk4?=
 =?utf-8?B?c1NYQlF2MUZoN3V4OFJWRTFGUGFhTVNzbkdWMkhMd0pPNDlFUENtK3JNQTJS?=
 =?utf-8?B?NE5iTW5tYWQ1a0o1cDl5SGNaakx2YjFud3kxeWtDdWcweDlhNnBiejJMYzMv?=
 =?utf-8?B?V1ozNEZBZGs1bDJ6WWkybEJRMnpsZzdpbndTZlZ2OTNEUExiQXdDVEdHVWg5?=
 =?utf-8?B?NFQzcW1PMUFEVTRrdUxuZW9BSUJmeW1nZ1dtZ3duWEVUS09pRmZKdWNJYU5j?=
 =?utf-8?B?dU1sVHJpSi9udHRNb2Q5OVFzd3h2L29mUkRvZXprUjVOWjF0YlBSbzc4ZDNB?=
 =?utf-8?B?a1dtSEdGZlJuUFdRNi9WaGFNVjMvcjRzRFhGUmY3NWxRWlNuVjhUcy9ES0E5?=
 =?utf-8?B?QzhmaWlXMnBVWTJXOTN1K2VTRXk1UUdKTTNUYnpGbWRNaFllT00ybnFteFI4?=
 =?utf-8?B?RU01TE5SK0VGZEs0U2QvVUQ2MjFCNDlmdEtjZmNlLzkrQUVydjB5TmVjSmlM?=
 =?utf-8?B?RUhPVis1SzJ2U1k5WkRVUGlZVFhTN3JTV25NbnUyMlRnOTZoK2ZpVzlDZHVH?=
 =?utf-8?B?enhnYUpHVStXNkZYVXF3SVNEU2hpbFU4Sjg1RjVsZXlSSTJ4ejF1NnoyTFh4?=
 =?utf-8?B?anhoMkh4b3dqUE9XdUpVT294Wnh3R0dBL1VNeTl0TURCZ0VOTDl4UFYra0Z0?=
 =?utf-8?B?WlRNNWozSzJMZkRYa0ZiMDFtMTMwK0ZFUVh0Y2RPZjFLbWdmeUkwRTRGc1FI?=
 =?utf-8?B?YTlDT2dIWlpxMXVvRDRnV2txRzhIek1uTlVDWWlKUmU1dzJQUmxmUlNBaGlD?=
 =?utf-8?B?T0JmZlg0VXRhVHQxeVFJL1cxbGIzdFh2cTRCOVdFdG1McXhXY0xKeGJyNG4z?=
 =?utf-8?B?dkpwb0VJZ2JZK3RBblhKMmsvN1M4d0NNZUd3dEdVTGRURkF3cnVrWFh1S1Rj?=
 =?utf-8?B?NmxQMmQvbDhYNUphTDdsc05yanhxdU8zTXdQVnhmUU8xd1ZRenV2TitTY1Nk?=
 =?utf-8?B?YllsWU1GMnFPMjB2Z1NhV20rdFpSWGZuZ0prUUwyMXUycEl3d1hSOWhIVnE3?=
 =?utf-8?B?VVoyODA5d2tmMDA2SzlYWkNlYUc2MjFXYUVPbmNnbDNIc0N2UkNlNUFqQjlU?=
 =?utf-8?B?VzZDU1BRN2VNeDZZNlVKTFVjRVFSVGtGN2VSQno4Ylh5d3haMi8vb09lUm1M?=
 =?utf-8?B?MndKOEJHSzdCanNldk1tN2JzYUd6Vkp2aUZva3Q1dGV1eTRGZWprUDY0b2Rx?=
 =?utf-8?B?MVZ1amJPLzFia0hxd0p6ODNDeGFJMlJlSTJnMkxLckJ6UjVVa0pMNCtzYU1x?=
 =?utf-8?B?Um81cHB4ZDBHYmNEeG9LQTNwWFg2eFJVVVBSOWY5RFNpcU9RandQUFN4aS9j?=
 =?utf-8?B?S0FjL1NEdk12KzlhbHpFUjdhSy9wbEoxMHNIWTVPOTVHTEgrMXAvbnFYbFNx?=
 =?utf-8?B?TEZJcWJOeitpRVh3d2h1S28zT0Myb2tzdFZLLzBRQWV0VEV1Yys1NWFvRjF4?=
 =?utf-8?B?bFJibmt3bUJnSFlTS3QvV2sycHRZa3FvdzJtZjZWSUpaYVpwZURkV0hoWG9p?=
 =?utf-8?B?RzRPTHJWM2RDbFhPbWhrdEFaSmg2UHZoeVhnZ1JDajEyV0M1TmpGS2M1YWZh?=
 =?utf-8?B?TjRnQjFZNlAzdmJJM09kdVcxSkEzSlRlN2dRM2xNZ01NNmplb2tzYTdOUmRH?=
 =?utf-8?B?R29LMmpiY1hFK200Mm5qRDE1RlE3b3FXcHJaZE5EeThpT0l2OVZseElGblUy?=
 =?utf-8?Q?kHgOEQY31iB8DmgRdMj3OOafCG17Ax8j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajlqcU1xU0ZaRHpKclBoaURHV2NpZHhRKy9GVUdCRU11Z1hYTFJMa1JMQ0Vr?=
 =?utf-8?B?OGJWR3dPRE82azFRNC93cVdhRWtCUnJjUmllWnFhM1A1OTBNSGVrbTBtbXdt?=
 =?utf-8?B?R0VRWncyQlZ3V0NOOVRuWUhqT1NacExYeGxUS0RmTzZzZEZDNVZDVjllTTJU?=
 =?utf-8?B?bDcwajZPT2hsSjRITXQzcWZIbUVsUFB6MTJJRGJoazZIVXV2OXRjUkdDcGNh?=
 =?utf-8?B?c3l4L3ZqOG1RUkNlWEtValdVcTk4Q0VJczlrK2EzUjRadFNyYkVwdmxPaENW?=
 =?utf-8?B?U0paM0tHWEtod3pscURDT0d2S0doQzl1ZzNrYjFMVHFNV3ZwRVVZZ0h2VEdx?=
 =?utf-8?B?Y1FweUFQOHNiQ0JHMHBYNEpMV3BHK1RSYUttMVEyTnN2NEk4QlVlYkVOM0M0?=
 =?utf-8?B?bU00b1hSMkRMTGRUclI0RHQ2a2VwVThwWDJKRmg1dDFGWW51anNPTkZ3Mkhj?=
 =?utf-8?B?YmZLRnBUaHlERDdUY1VCM0VpQW1GZ21uaDU4Y3hRalhvMnhyTHJyb1lXbTlD?=
 =?utf-8?B?c04rVm5aNWRDV0p6eVlvK2dKYUJQVlFaRDBOUDNCRWZrdVFLMENuRzBDWkpS?=
 =?utf-8?B?T291bll1ZEhpQ0dJNm9mdDZPMVZhcUJKTkJYUWhLTWdxVDhpRGhjME53bHpB?=
 =?utf-8?B?UGp2NVJHVnRaaFR1RkJmRndlalFuK2hEZ2pyT2RnMHhlSkRSajRMQ2ozQTJo?=
 =?utf-8?B?cEhDSGYzZGk4NWh2S3M3ejVBTGliL2paNlU5OGRqNkVvTG5CNUcxY2dVQVc4?=
 =?utf-8?B?MndlL1U1S3dSY1hUQlhXbmE3WGk0ajZiV3FUNVVLSkNSdXpRY1JGZUpEVnB5?=
 =?utf-8?B?cnJhVFBzd0R6SFJMclRCZ0U0aHNiTmZXNDhXLyt6bS9RSEtkM1VMQklyZTNi?=
 =?utf-8?B?SFNFdUpHREY3UFg3c3lnSTRNYytZbHp4dkViOTc4emdWQ1B5cENDbmUxTkpn?=
 =?utf-8?B?Z2FRbC9NaFRVd25aS2xrLzdhdTAvcHFGcHV0MldzdFpZT2RIRVA4OGJxc2RH?=
 =?utf-8?B?M2ozWldJd0VQbXlobVRnWXR3SUN3aG1BWnBCRmtpNU9Eb3Q4cHE4TWd5ZGtX?=
 =?utf-8?B?NXMrcEJkZnpPcUdFZEt2bk9ubzQwWG5DaDJ3a1JiOUNHM25Gc0E3ZWxRSWhh?=
 =?utf-8?B?cEFsZmFHaEpWMGs5bXdMV0ZFUlBrdjNHV25TT0VtT3JCR25keU1XSDFLL2Fo?=
 =?utf-8?B?VlE4bFcrZWRqR3ZPeUwwMVZsdW5hZU8vRzNnVFZsSWpDRU9IWDVkdGZhVnpX?=
 =?utf-8?B?TTVmbTRUMFNXRlNmQ1ZkSE9ObXlDbzhseklkT3YrTkZRUjNZb05XVHhQbkRP?=
 =?utf-8?B?SW9VbGZHZXBBZUorQ25aOW5ad2lOVDZ2Tlg0MXAwb04vTHdvd0hkUFVJQzQ2?=
 =?utf-8?B?emFQRE9FN3VZNHFhVXNnV1NpUGdublJYV3dZZkZ5UlREcUNTV2xvTlFIVG1k?=
 =?utf-8?B?L1hHQW05d0JubWs5UFFZRG5sT1VBVHR2Yi9IalRVWmduK1lPWFczYmxMZEtJ?=
 =?utf-8?B?Q1lSc1R5R1lzcDRrcE0yK29qR1loWkFPS3Z0SHZHLzNmRnJHVitDcFVIOTIy?=
 =?utf-8?B?L1FUOXN1bXA2VERPb2lrcUdNL0t3RllMZ0dJMnQycUZHVFo3ZGk3YmdRdjlq?=
 =?utf-8?B?Z0lOWGpwbXl3Uy9zODlNbHlKdnN4MzFBLzZpWldhQkVFRkVCd05nL21GbUg4?=
 =?utf-8?B?a0JZdUoybHZTZHJWZ0ZoUmVkbENEVGQwVDFzS2J6U0NXcXZzVktXenIrUEdH?=
 =?utf-8?B?MENTZFVlUm12VGg5MGFWVkVMZ2dlcVN6enp6bzB1cnBjY0I0WlE2RFc0d3dw?=
 =?utf-8?B?UWQwaDJBbEhSMlQ2NHo0L0x5Zml3Vlg1Sy95UjNZSWN4RUxaL2JnL0Jqd1Vk?=
 =?utf-8?B?YUR5Yy9kdFhPSCtVbEFRRHNuV3g3bngyT0ZXNHJHYlZVOXV4MjhIb0RvWHZl?=
 =?utf-8?B?MlBmc0hYeTh0N0swSGxsT01VeTFaK0piM3NTbnc3OGVwNlVGRUUzbXJ4TllE?=
 =?utf-8?B?bDBtTTBrTDZMckZNRWhzQXBKMUtCNFdxTDZBQVplTS9uejhaZVJ5VHJiak5J?=
 =?utf-8?B?b2xjY3lnQUlSa3QzM0ZSR05XQkFCeDkwMndUd3BRZFE5UFluNDFzYU84Vk1V?=
 =?utf-8?B?NHlzV0FzYVRtQlZIUDQ1eVN3VVJ4V2RyT3MrYXhJK0NkcjhWZDFqYUxwZ0th?=
 =?utf-8?B?SEdGSVNPOTJ3Y2lFWjJNWk5CajRyN1BBaDZtVDYyZHh5bmg1WU5mYzhqWmUr?=
 =?utf-8?B?MUVLSlppZXdhOWVaQnZSelQyeXgrSE94bXFlNkdRUVVmZWpjcmFxQVlBUE1X?=
 =?utf-8?Q?ofNwvfsewh9kydz87U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2aaa1f-7058-4e25-9073-08de41021123
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 02:30:26.7616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pf1Ns2HwUmdX99Md+eij0gKgaKJlmSNAcwXr225SZV4PPgP/vWdoB1dCeLf/cQIG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8457
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 55FC51A0015
X-Stat-Signature: cxferr6d4an84ihucgyuadi83zgmt4yd
X-Rspam-User: 
X-HE-Tag: 1766370630-45402
X-HE-Meta: U2FsdGVkX1/FFrYwV8UHDUkdWFkV37SFXtlny2VL6DcEzDtKXTHY1n6/Spogns4B+pS3sqwqklmjb8NEiUnVR1OLBjBUy+G2QBtlcHjq1Kj8DG0FmgXZP7tDtBXNTd7LpHqVwEeOhN8jzBus83bvgjTiMd/KMhHk5G+1P+mpRMFuMWnm4RTmDC7bKkBCsYOjbsw8TyPn97Tf1PL5e56BHj8/8IoAFEvswqprVHvXKLjp3OCm89PT3DfMWA+1X57Zi8K3x/bNzBSHHgTrGHwy/KMFFCj36pDpXFYJizXIIW9q8zL7IBad5y2iOlsEmXvT6jrUAD2RgJvcvuaYBWMP/jkYrfwTXPnJX+nf+6eWQLAcWz+7GPMUNnAT2B+OHb4GbTtZS6d2yKAP2L67dRD+onbhdtpqWs8ZEnLSp8Acec1ybdCBpk2+KLQtx9TD9rJmdQNhvE2qgrlkKJteb8VD6eExpyzEqjlBbgPoiOx3CQJS03gCiL7JbEsBTYFIFfSKQgFOMqO4pIOu/vEGT5d3qKX0pzqtwwO/kb1DyC21Mik3pRBWNPRvkijeyYPyYMw5fWuWRbxc5A8zQtfUvO2GTuY7NoSumL9oj+a+azvzbbPGniJRrIHcTZWsT2+d3tqaGCor6uqwIMXoGmdi8bErwSsJHhuC7BYlcISI29EDfx8tXcb5Hv6Et/sWDnpQpdqHlZLJXGQWzStvAkUezY9d9kgGsv3/vdht0M6bTvLUOxSAJQ7zV6N0rpTlXRhwlW36stutphhiyj8xZ003mIK+V7tkYE+N10xFm7CVPx4IEksZHs2ddY3veLgcwHZqJRO62e+SCn0s/ksTT6iUDlrlLkxUDKuL6yc6K47w6tG1RgieCvZgDT4HZsujVw/h9DgNw6zg+Ltl+bOG+SzhGI0tdxN3hZ7QwS/SDlFuuysz3fxish/z060LtwJ7CCkiomNzY8EPZ9tmons=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Dec 2025, at 23:09, Kefeng Wang wrote:

> On 2025/12/18 23:52, Zi Yan wrote:
>> On 18 Dec 2025, at 7:54, Kefeng Wang wrote:
>>
>>> On 2025/12/18 3:38, Zi Yan wrote:
>>>> On 17 Dec 2025, at 3:02, Kefeng Wang wrote:
>>>>
>>>>> On 2025/12/17 2:40, Zi Yan wrote:
>>>>>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>>>>>
>>>>>>> Introduce cma_alloc_frozen{_compound}() helper to alloc pages witho=
ut
>>>>>>> incrementing their refcount, then convert hugetlb cma to use the
>>>>>>> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
>>>>>>> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
>>>>>>> into mm/internal.h since no outside user.
>>>>>>>
>>>>>>> The set_pages_refcounted() is only called to set non-compound pages
>>>>>>> after above changes, so remove the processing about PageHead.
>>>>>>>
>>>>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>> ---
>>>>>>>     include/linux/cma.h | 26 ++++++------------------
>>>>>>>     mm/cma.c            | 48 +++++++++++++++++++++++++-------------=
-------
>>>>>>>     mm/hugetlb_cma.c    | 24 +++++++++++++----------
>>>>>>>     mm/internal.h       | 10 +++++-----
>>>>>>>     4 files changed, 52 insertions(+), 56 deletions(-)
>>>>>>>
>>>>>
>>>>> ...
>>>>>
>>>>>>>     static bool __cma_release(struct cma *cma, const struct page *p=
ages,
>>>>>>> -			  unsigned long count, bool compound)
>>>>>>> +			  unsigned long count, bool frozen)
>>>>>>>     {
>>>>>>>     	unsigned long pfn, end;
>>>>>>>     	int r;
>>>>>>> @@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, cons=
t struct page *pages,
>>>>>>>     		return false;
>>>>>>>     	}
>>>>>>>
>>>>>>> -	if (compound)
>>>>>>> -		__free_pages((struct page *)pages, compound_order(pages));
>>>>>>> +	if (frozen)
>>>>>>> +		free_contig_frozen_range(pfn, count);
>>>>>>>     	else
>>>>>>>     		free_contig_range(pfn, count);
>>>>>>
>>>>>> Can we get rid of free_contig_range() branch by making cma_release()=
 put
>>>>>> each page=E2=80=99s refcount? Then, __cma_relase() becomes cma_relea=
se_frozen()
>>>>>> and the release pattern matches allocation pattern:
>>>>>> 1. cma_alloc() calls cma_alloc_frozen() and manipulates page refcoun=
t.
>>>>>> 2. cma_release() manipulates page refcount and calls cma_release_fro=
zen().
>>>>>>
>>>>>
>>>>> Have considered similar things before, but we need manipulates page
>>>>> refcount only find the correct cma memrange from cma/pages, it seems
>>>>> that no big improvement, any more comments?
>>>>>
>>>>> 1) for cma_release:
>>>>>      a. cma find memrange
>>>>>      b. manipulates page refcount when cmr found
>>>>>      c. free page and release cma resource
>>>>> 2) for cma_release_frozen
>>>>>      a. cma find memrange
>>>>>      b. free page and release cma resource whne cmr found
>>>>
>>>> Right, I think it makes code simpler.
>>>>
>>>> Basically add a helper function:
>>>> struct cma_memrange* find_cma_memrange(struct cma *cma,
>>>> 		const struct page *pages, unsigned long count);
>>>>
>>>> Then
>>>>
>>>> __cma_release_frozen()
>>>> {
>>>> 	free_contig_frozen_range(pfn, count);
>>>> 	cma_clear_bitmap(cma, cmr, pfn, count);
>>>> 	cma_sysfs_account_release_pages(cma, count);
>>>> 	trace_cma_release(cma->name, pfn, pages, count);
>>>> }
>>>>
>>>>
>>>> cma_release()
>>>> {
>>>> 	cmr =3D find_cma_memrange();
>>>>
>>>> 	if (!cmr)
>>>> 		return false;
>>>> =09
>>>> 	for (; count--; pages++)
>>>> 		VM_WARN_ON(!put_page_testzero(pages);
>>>>
>>>> 	__cma_release_frozen();
>>>> }
>>>>
>>>> cma_release_frozen()
>>>> {
>>>> 	cmr =3D find_cma_memrange();
>>>>
>>>> 	if (!cmr)
>>>> 		return false;
>>>>
>>>> 	__cma_release_frozen();
>>>>
>>>> }
>>>>
>>>> Let me know your thoughts.
>>>
>>> Yes, this is exactly what I described above that needs to be done, but =
I
>>> think it will add more codes :)
>>>
>>> Our goal is that convert all cma_{alloc,release} caller to
>>> cma_frozen_{alloc,release}, and complete remove free_contig_range in cm=
a, Maybe no changes? But if you prefer above way, I can also update
>>> it.
>>
>> If the goal is to replace all cma_{alloc,release}() calls with the froze=
n version,
>> there is no need to make the change as I suggested. Are you planning to =
send
>> another patchset to do the replacement after this one?
>
> There are few callers, the following can be straightforwardly converted
> to a frozen version.
>
>   mm/cma_debug.c
>   drivers/dma-buf/heaps/cma_heap.c
>   drivers/s390/char/vmcp.c
>   arch/powerpc/kvm/book3s_hv_builtin.c
>
> For the DMA part, we suppose there is no driver using the page refcount, =
as too many drivers are involved, maybe there is a very special usage in th=
e driver=EF=BC=8CI can't be sure.
>
>   kernel/dma/contiguous.c

Even if drivers are not using page refcount, these allocated cma pages shou=
ld
be still have a elevated refcount to indicate they are in use, right? So
cma_alloc() and cma_release() can be converted to frozen + refcount manipul=
ation,
right? I am not sure letting drivers use froze pages directly is the right =
move.
Frozen pages should only be changed by the one freezes the pages and no one=
 else
should touch it.

Best Regards,
Yan, Zi

