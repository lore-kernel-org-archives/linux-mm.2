Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4993CFC28B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 14:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDAD86B0010; Fri, 21 Nov 2025 09:59:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8AD66B0011; Fri, 21 Nov 2025 09:59:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D524D6B0089; Fri, 21 Nov 2025 09:59:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEAE76B0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:59:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0F3313B4E5
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:59:54 +0000 (UTC)
X-FDA: 84134923908.09.DD454A8
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010064.outbound.protection.outlook.com [52.101.193.64])
	by imf24.hostedemail.com (Postfix) with ESMTP id DA7BA18000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:59:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MSDTUpaJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763737192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQNlLmHTbIsDIGO+uH21OCZh/nXLoyz/CqEADasCz/A=;
	b=UPVTEoIxBLWd41THqQiHofzSyGrzNlIQFO/Q1Az3CFeGa4xx9Gt/q1zSZkFXzSJ7P3yMgq
	g2pJYrFO5u6eRZU8u11ujiWcseJiWmMFsRe4Mf0RNXHSwHluh1QzZe6eRoaJU3W3cUr8w5
	J/PXY6vysqC3caFJh6V6+FyVp2hPzjk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763737192; a=rsa-sha256;
	cv=pass;
	b=Y70DYnAQNq6akphqK8AIjt9QRqhTvGDnenKKwWjfiGo0h8ou+gdNnQSReMTUL9GJLA0rUN
	Ec1Kg9y3DnlFK8v2R/XPYWfzRaO4O0tiaxjt2YdPRxZ10WT06YSF21gHSSLPeW11Qu/Fq5
	aMC4Vb+K1DvM1DbHqfsmmZLSanEsPGQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MSDTUpaJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cq4w8CjRhGr8kiE9X2PgGkPNtjLqPJ8ZKaXvweBz+F6wz1qwbLLhmTmPnKP7l2mO9+CwAQ/Cby42WlKSNfTGKjtKqankMMY5AKzI4HGJHGJvdQqnwtqvDvRBHTDoHbSWfLDL9DjWVnIu6YceTLouI5VyVKqk+lCiihRdudNwe4sapFQ9Y8S4aOpeA0CqDSinP91SRp24pxsVFcn1CJ8X6QDFcwm/zAkgImp+uFTLhpXzjOHnr9v1oPN38FqO+vIGP5YEYew0J0erjN3xSqvzuqVssG36qNG7dfZ8jVjAQPCRo+l1OsU+qIPGMiFLUQjP1VXAFThmVE3ftgTorqOezA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQNlLmHTbIsDIGO+uH21OCZh/nXLoyz/CqEADasCz/A=;
 b=T1La44TbdGbURkomIBgDKmpX73+u8zwzsS0fTDI6gbAZ/MrKlbpxpxSnCtIWZ6TA8QA9qIF4UBh68opaa9zdWcjqnQAFLh/bAKqQAu3oThRIHaxZjiVJFKvev0kDKbRkURfBQmmOotsYdxK3emWSmJWPAnJGSx+1JtDC1aHJthnbuLZnl8A3X/ymOhdVQ8Ccqrpva1xr6SBRRdeShmqCcFi4N6r1Nnp9y8NOvzTQ0vElyRL8JEhCtp+RVTKH9sB+C2YVKN4kF1LEJYXPM5eTPaj33N+uY9gCh+NDSKNjT8X9o1VvjJfoVScdtDVP5zpEMJ7JrU7ut0kVOEtutXbI3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQNlLmHTbIsDIGO+uH21OCZh/nXLoyz/CqEADasCz/A=;
 b=MSDTUpaJvWjPeG+6G7IXqPQvSRhIYLqepWD0QcKnSpq7I/Ly0K+4pnQvGVdZ12QMQDqrBQXWaozEC6EUM++s+bH+U6DLVoG1l/XZGK5bxtb5rqjn36JEWFlkXmoVwo6+pc/KHwD1JyqY7+APBSKs/raHVagvlPHpnPMkrsDzbmukzb8s+n8fk/36sHFOS0MkwYyuKj8VsyLuTZj0U6Y9HbwsDFv6dVRNsuLN2vn79Gby3RgY+GUCkpx69jhA2Rh/MhHURZs3WVJOoVdFxZdC0u68izlUdROvtKhmJIKnRRET8vQYE47R3dzKXdBSxbzLYtEd/nOTyfIzZf/w7BcpEw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Fri, 21 Nov
 2025 14:59:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 14:59:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Fri, 21 Nov 2025 09:59:42 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E7C2F025-4CA1-4739-8661-343D60D82F7C@nvidia.com>
In-Reply-To: <20251121090048.3n25tjhusu45xpoo@master>
References: <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
 <20251118033339.7rukw7vvjvlbj5jb@master>
 <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
 <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
 <2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
 <20251118140658.9078de6aab719b2308996387@linux-foundation.org>
 <20251119005248.ddlbhokgjdmlkhkr@master>
 <20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
 <20251121090048.3n25tjhusu45xpoo@master>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0471.namprd03.prod.outlook.com
 (2603:10b6:408:139::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW6PR12MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: cb78a4b7-c912-4e1f-635e-08de290e9b01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XmRibBck6XdekLMFF52HTrCj4CKfjUUdmB/BfE9tFcOcxklV56G5+0Gtqdxw?=
 =?us-ascii?Q?XzuD4PxdoVevus3VurFixsGv31O6d0n/O3Xf7alXlRjAq7/2MR638Mzvsh1P?=
 =?us-ascii?Q?r9IdEMWjcFgRUzkPLzK4HsNm3uRMgW7kYswjJyrUBgeTs3kNYKjQodJ+3DJf?=
 =?us-ascii?Q?jjp5PGowmDB0YOn4aQAZdNS0kC+HxzIkcpUD0ugxfYRlblaglU0d1aVNSqEP?=
 =?us-ascii?Q?Au08y8KhhKtjvPoiRrVqAwKO/F8U8drmPOuQQO73zY61clGugoFNPOSfS3su?=
 =?us-ascii?Q?ZCLZzdjTtGqmTeb9eBEZmVOQLUh3Samh4NIsDdU5VDKqPRvwsDvtyTsnddqw?=
 =?us-ascii?Q?RQO5yEoCLkKuv9SWfSzafb0eEDxfBQY31HI9tHQerqUGROsKz3nmKjv6QoPj?=
 =?us-ascii?Q?Gp5ZZgllTanasyI4YwlwTWatxqqY91rmIAenA3kVWU1l6F5ICLEZ9B1NANFs?=
 =?us-ascii?Q?JqzLnQitPfirwmDjPZhajQy3TASLBIOIxPcRXsJFsugRvf6AS2VMKpkoxw9D?=
 =?us-ascii?Q?EOB8mrKfAXjILuknXquxUpoYh0dbsFCRojtJlGzB91/xMtngIdNLEN734exW?=
 =?us-ascii?Q?4Nn/zJ56kkOFTe5Y6nuSSg5IwvLZpz7Wv4XS9rSq4IsXmxazK1UzcdgQW1K5?=
 =?us-ascii?Q?0k6ECyYW+AfUVYgsncKtGOKRPAHsSzLkw9aQRrUL7fhrisgJXOWYDYO2vJSQ?=
 =?us-ascii?Q?Lda1I2LG6vC+peLbyWk+NdFfiXC8ek7i+jIt6zRVnhtyFY87ZZmDIwoxC3gA?=
 =?us-ascii?Q?J7lqaUuNo3Fp0xX6vp9GLdWVldWjE7hQDxcCPKG4S12F/JPF1IOw2fCnu/vB?=
 =?us-ascii?Q?p/Sv8SZ5woQ23mVM9/CFOq6/RmLxl9Wfs2DBhoiHdSjiBoQTx2wI1yFshC+t?=
 =?us-ascii?Q?+DRXCDTfrmUnZQ+qVwkPPjWssMzgpEp5jRQDidBhEZhjftzu8RdjHToFbdAu?=
 =?us-ascii?Q?nZN8YtgTTBs3odqAgWuzIcGmHBmZ876WfmH6mYgcynWh8lHLGVV5rwV+2HC4?=
 =?us-ascii?Q?+XxfdVff4OKP6Xj0HHsZjT3CyQW5qrMXZ6zqR4WnqVQ4qsc7/UrbtbKVe7db?=
 =?us-ascii?Q?BEf5AQAHOHWwcXUVdF+1KE6d0uFJkgo0M5eRxaaT9XYbhp1yJpeTKAqNdemA?=
 =?us-ascii?Q?ehomrqeub+fabCdQVdRgIKXH3B7EvtUsVFwsmdV8Gpqdjx6UuUzWi1QrHvWi?=
 =?us-ascii?Q?CAVz9jQONtHLM2BgpnDkElrHQFOIOUM/uXTaukno16yC4XWcVHAmxAx8odKu?=
 =?us-ascii?Q?Itr8Lq1OTmOyaMtiOQnnl+4stSCvZb1kjrZ8GPkIu4qAvKfBS3DfqTlt6DHH?=
 =?us-ascii?Q?xnhJzwlhDfzCgcupUei8zhmR9O/tWEdK2DFV0K2vULZmmFYPd3T9PDpgrMYz?=
 =?us-ascii?Q?Dwzv4E3BQA3daeZ04TpN0Wd5VqamQictR1jUlD0XBzVsGhSBHq4BET7yEe0u?=
 =?us-ascii?Q?c2hfeOYx5feoACEAnJw1a+YJ3gYyCefEEq+dWINe5JfTV6Gv8twFaw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qDrlQy0iWJ/3X6+RRK3Nwkb62JUpF4cq7bnLq92ztMxMhWYMNrJLNhlkSdWH?=
 =?us-ascii?Q?CR8ZPmNLOewSBJ+fNYoW+eGlQkiI7XfvzMf8sgznluDujAPfH78+yDjBKG1v?=
 =?us-ascii?Q?p4qrnlB3d6y1QZ2OYhmQUCefhuB1fBejedA+1XST8k2Zdlrfdds2iqYEdur4?=
 =?us-ascii?Q?M4yPiwj+sTfMddI1dbmZ5Yo2m7I5ZFoZfZXZ5bvoeSGGz6XwalAvY7kkBxIG?=
 =?us-ascii?Q?KrkME0iFTy1tshz8zYXVhtq+d4iGMEjsCgu+dz2mzNs/LLyk0ljFTRcuj+St?=
 =?us-ascii?Q?Ehx9PouU4lMYsrj8J13IU/koy2CIlrjQLSYfQd0AQUPSwcixB66VcOTwg6d6?=
 =?us-ascii?Q?eC+GvED03ECFmO2S6A2iPQOL5XuoJlxL37itlWRT3MTo7xoLMpDMVyn9Hk6Q?=
 =?us-ascii?Q?5bRS2V50w+4RStNApohMPKpRzLukpgGv0eJnxGumtZJ3Ep2PISgKZDs24y/Q?=
 =?us-ascii?Q?J4cfczoFXNYrfDxbTnaKNeMnghqa3TfU8UEja1OyPWZ9Xhh4f1+ZxsSfH8bi?=
 =?us-ascii?Q?BwHbJ2PeX+ooMSESKbIieJlsmj4XtSWHfLuYB3eDnmvCw2K4uaHdaecgb8sT?=
 =?us-ascii?Q?29m5ln2CKAj++O5CVECifb71DptT9vwwZwHSYq526EOIz8YtD6x5ozbVobm2?=
 =?us-ascii?Q?pppDO23KwtTMr2BzEL3MrLHChtEof7V8KL8P+cH9Q6M5Q8DfzdGf/hwuzrKu?=
 =?us-ascii?Q?YG7oC5VIKtMQUzuj9pex5ZIOeJOexgEQswPbQc1UTMYo7H5QMoe5GscLgJRd?=
 =?us-ascii?Q?7e9yDmohWAM9sNabeetzr9+UQsUSmEJlv55hndMYoiJDe/KlcUsea4oGzJl5?=
 =?us-ascii?Q?vrd+cyeMKAC10pgffJsyeQN1LDTACg7SFiawril5yfxh9ChZ99DZgOb+hGc5?=
 =?us-ascii?Q?YZkxRhJyBp2RJqz/9O4AJvX1BBZdgTJLmwxq7HPU3eeZDU17D2G3TvFV/cqS?=
 =?us-ascii?Q?qp3aJY04vrdx/3mcuWDDKziBU/6hG4jXu/0WzT4Gnh+Sr4iFWeUwQimgF6OR?=
 =?us-ascii?Q?nhFBaElKOyzGySFcQTEOPmAB/SooUEpiki7sEBofrBdNtP3twHI32XMRHFMq?=
 =?us-ascii?Q?DN3K7a4JQN4nBB03QAlwNb40i9exLb6uGIwjQisg8Nva5Og0yAiD4RkHYyvh?=
 =?us-ascii?Q?tUx9XabvBUSKH1wKL+8jSDZ/Kft5n3EQRaJEF83jm1aKcLFA0DhUjCoErWxu?=
 =?us-ascii?Q?SN2vetHeNxhbCAXVe4yKGN5DkKXUkgI9EITZFccjhVh7vwWRp2OQQrOH4ggK?=
 =?us-ascii?Q?J4/PvSAJo2sm9NHKCwyVE5J2Ob9Xb/Spjx1wJNXw+AJJEB+GfjNfCRyJG8m0?=
 =?us-ascii?Q?pgMnhByiN9/lfpQT3G9dD7QeOkFK3SfNjZY/T7SI59ZXH/L38fbBOU5J98aA?=
 =?us-ascii?Q?VLAlRaZZ67M8ls5e71mNzDnu/LjMw2zQjOYfC1jWyEVtADxA5zljfCetqid7?=
 =?us-ascii?Q?Xkf93HejQGqcL8DaTEzzKsvZsWmgGmO55z0p5efHh6H4xBTmt9Y30eMXX4a9?=
 =?us-ascii?Q?1MjGnA6GY8h9cXDvC469O/fIlg5XvFwSrma9Bl5R8DzEW1XLLdkPzdp7h7Nh?=
 =?us-ascii?Q?QmbIzeld3SdLWKRO10sLWmEqFpsCFaV8hvE6WjZN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb78a4b7-c912-4e1f-635e-08de290e9b01
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:59:44.1656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfXDFNrs2ni/oHONmn1PJ9SHZRdc2v/YAbQisDJWh5wG+HJZy7es20Xs555fi/wa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086
X-Stat-Signature: thqeo38x8fda9houux369b6yorniehtm
X-Rspam-User: 
X-Rspamd-Queue-Id: DA7BA18000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763737191-220070
X-HE-Meta: U2FsdGVkX1+/1YKo9WpYE9AXtGdX7E+rw4yiRRbKPFnT675RtXrnpnkHlVF9XnqO+uJY+Tt45F1eDv3V4V3L5ltNWNlmHcb0VKe3R3UMvcbvHkD9NdDt/YA0Qy7L2lbfn3Rzs3Ohvt2eQrZyKIge+ECJ6RsFrKGijPB2fT04x3YOWFt8vDk1w91a/jusM7QIDbQXtDEoQrAkQ3C3mPGpX1xNnytEGpFLydtsr9vFisxDQFqPl/v0J/XoyQpdvSeS2WXIM5LWlKsPa5o6n8vNmdifQzLVMOVm+I4JjK0EhwVEBoWX3mCHE4caU40aJx82mSUEWlmUJUEKTnvFjMfwKhN0V1aKVQGgMID/S20vas34KTM7RXnOKV6c+Qh+jBlChKTCRcqU6p5vrxHmx6xgzfYtiazYqTE2YDuhwlNsXsXcP2l9iIucG+MgQe2HJ5xRUZMv7i3PKx07uh4ZEebzhj4Th2PL4sTjGERng5MOueZiwGforRpEhnNBKynRE9DAeMA6ql6QtpDogvo8/dur4HVqsGriAjMf0ryNl0nvDNw8PB8soW8hjXlW88lUU9GyZgjrdJ7jjiko+EdNIjjo57l3sF7R1k2tZq9ZzWJMyN1UlM7jRwN8cSe+NqqfP7Fgvgqcj/UL8E5/mlKHJAS/bzt4tGa49sBWETLvXB6DDWYsp8Zv9uFSz3h6yFzqbbEd3eWPYmIDx4j6jwG3cBfnfts1s9e18MwQTZqg/RkwpSsAixtyVIkj6pHTbmU4o5LyFNwdx//yv3n3RuPiidmyrGoi+8Zv+H4HKc8rLVJmj49BmUO+3Ml13IrTqRU+9Mhp1S9/RAyUobKjnwmxxLFIPJoEIVkWrEraSDWP924mOlEU4coaTO5uVNrxGWF1vJbSgfNjcGBHGeXKz9U2jqTPrnJz8BC4ouXSAwP9TS1FJ10N5VR9Qo5rm5/MM0lgZIH4N5tA/ru3952DhM5ltSA
 p+alP9ac
 AsW0dQd+x2DWP2N8qj+ri4/OiYVdIuiZThiHzN4AMqOBVYOCif9P2dRLaePTek0EI0+YJrTkeZGx/MfhG7jFbhXuoWVXVVS1Am4+snjdZv4orDU4uXn062ipZKdviFGAf5LOr5U2ebizFXPbh9AzEyn5hUDMj6UbWSE+PI+TItA7yhQig772iy6KHRCpzTkjnwpgSdJ1aWp9YhQ6ps4PqWkw+AtI2ch31eCYM6t6GNTpuw4NmEjRaNYDLszkUb4tr4hfvz+bCjljT3hKmXX8M8go8dfRwPJKDhV6hDg+MH9yj990q5R1ftPw8x+L2j8VW5M23fkPJWb2SYkSksV00KQmcYQ751Cs6YNnJ8K8vgSK6rO/5nhgguhVH2eN9Oye19n8WpQ3n9NVVVivp3uVySg9EedYXkrLDi/fWNPzHlVg3Cykt5mG1NRx1ywad50ISEOomjBxkeVxDsvzQnlpFoZBLL06rzgV7ZJHjzKhNftQz+bKbnH5kTQrGhW2SJI8SWDS/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Nov 2025, at 4:00, Wei Yang wrote:

> On Thu, Nov 20, 2025 at 01:16:21PM -0800, Andrew Morton wrote:
>> On Wed, 19 Nov 2025 00:52:48 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>>>>> Hi Andrew,
>>>>>
>>>>> This patch does not fix the NULL dereferencing issue yet. Wei is going to
>>>>> 1. send a patch to fix the bug on top of mm-stable,
>>>>> 2. resend this patchset on top of the fix in 1.
>>>>>
>>>>> This might be easier for back porting the fix. Maybe you can drop this series
>>>>> for now.
>>>>>
>>>>> Wei, do you agree?
>>>>
>>>> Dropping this series messes up later patches.  I could of course redo
>>>> things but would prefer a fixed up version of this patchset asap, please.
>>>
>>> Ok, i will prepare a fixed on top of this.
>>
>> Did this happen?
>>
>> I remain unclear on the status of this small series.  Issues which I
>> have flagged are:
>>
>> https://lkml.kernel.org/r/20251118021047.uyldr7aay6fb5evt@master
>> https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com
>> https://lkml.kernel.org/r/20251117012239.lqm33uu4vl4y5zqc@master
>> https://lkml.kernel.org/r/337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com
>>
>
> There are two related topic:
>
> 1. A null pointer dereference bug:
>
>    https://lkml.kernel.org/r/20251118021047.uyldr7aay6fb5evt@master
>    https://lkml.kernel.org/r/20251117012239.lqm33uu4vl4y5zqc@master
>    https://lkml.kernel.org/r/337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com
>
> This three mail are related to the bug, which is fixed in :
>
>    http://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com
>
> Currently looks good, and will do backport when necessary.

This one is picked up by Andrew.

>
> 2. A further cleanup attempt:
>
>    https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com
>
> This one is the related mail.
>
> I proposed one version in
>
>    http://lkml.kernel.org/r/20251114075703.10434-1-richard.weiyang@gmail.com
>
> But it is not proper, will do follow up work later.

Please refrain from sending more patches related to __folio_split() and its
related functions until the above hotfix is merged. I also have an ongoing
cleanup patchset[1] and want to get it in before any other changes.

Thanks.


[1] https://lore.kernel.org/all/20251120035953.1115736-1-ziy@nvidia.com/
>
>> and a couple of comments from yourself indicating that updates are
>> required.
>>
>> Have all these things now been addressed?
>
> Hope it is clear now :-)
>
> -- 
> Wei Yang
> Help you, Help me


--
Best Regards,
Yan, Zi

