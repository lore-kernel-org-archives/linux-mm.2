Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD05CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960DA6B0005; Wed, 17 Jun 2026 11:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912166B0088; Wed, 17 Jun 2026 11:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801216B008C; Wed, 17 Jun 2026 11:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52A176B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:52:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC5271C1D8E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:52:52 +0000 (UTC)
X-FDA: 84889847784.05.04F580B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012028.outbound.protection.outlook.com [52.101.43.28])
	by imf08.hostedemail.com (Postfix) with ESMTP id 13DC4160007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:52:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=InYYAgFe;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781711570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMD5XWhhc5twxHGn/FXdfnHPkdNIkoea3dWVU2ve2oA=;
	b=bezQKWSzI23EWj06mpQvEqh4slWh2x9sw9ufMsCOtNEaJNCIG2h3X8y0aHnJEMXHhyJYwn
	4eg52w0hfTJmfsnbfHcAKsOV4Py4tdlhrNiPGfPNO0Zv0gKWQJsATsy/c8RjW503A5Tvzy
	TOVzVJRDZ1qvQKm9SlWTAoyJSWhthmo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=InYYAgFe;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781711570;
	b=RGrSTIBtUlPuUJEmS1U/QeQWJeM2N/allOTkQePxW/rcZsfhpaHnVFqTh/MdO43N/EzCoY
	wutuAaGpF7/EYQiMBJDMv0XGmI0uD2iMk/6QvhyYx1jvhcBp7RBbDQO0FqzXH6gpG8cQb+
	2QJlBIhnZorczDPTnfFMeMSWqI5u04s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHPMRIJ4UbNKZMR+Ai9/fQP9SfZ/3OukU1N6BPyLMwXdZlJPo5BJTlW508lOxlk46LnuSq+bOCKTJJJfLLikpDZOMZcnAslLVlmZ169LYjJzV4Td0tooEPPaAlKrxQnyhp7BtinMkd9a4VK5jzhbGIz92CS8vZEnoVz9gJZJgQ94cBz12rEnfTI2jkwnu5dbIAuQl6Asftv0WSawpWi5j0gs5s28Ir5LUdk07Q3QtLUGwCcpN/GfsiI/qB/Uz812n2WaLsE38NRGBviXNuPKO+U6ydpTplh+J/zLiL5NNdoK58Ex75nXdrElD+P1UWLNeEt+QVyceNiFCohJJGoIhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EMD5XWhhc5twxHGn/FXdfnHPkdNIkoea3dWVU2ve2oA=;
 b=fhMcBj4zX3a2QdTCi2rF6AfWx5xQL/63zRSAfQXSxEJsoILgSEl24Lz7ET7bPFIb59GVQuLdBVEvYJikHUPLiXcSwnlY5XJm16t1D6ieoQ5rlKQm4zCb5C226FoR5CoydJkkP3Uo1yVqrNRfGY/0QPu9pXoa/TZXn3pcvcADeZN+56iXxrkl0PnXRbUfTSsmmW3N5HR196L3IU6sDtjP0WG1tT0M6IM6kadLred4Y/hd6JCK28MK1WXBlegkX1wBKbkaWxzYivyIV8K35BBTmm/v5R1OKDCHLmei5Kfe/SOcsj7bXc/K2LTjyRIErboPbF9fRpJRrQ8t8XaFy0DalQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMD5XWhhc5twxHGn/FXdfnHPkdNIkoea3dWVU2ve2oA=;
 b=InYYAgFeX4CC7eiwRs2n8NMT5yReXx+b3FWZCM9EUOChROBMRSwoI7ifFPOAgSOCRSPebcCVCTrvHTv6KsiAGSvrQQ2oTrW2gsOWWS6BjbIAPcaMgz8NeetE8muH9G7WRVznj10y1iGl8dPOJi3BqiTU6E2FBW/LZqWSncbhNOSCS7iJQpeGnzIhMUvRfVVAp1cLWKtCRoJj7Nl/BegCqz9D2l9y5XgV0AsvqAzNKWYToy+BVObsKFT1lE8Kx34LR8FBqA4plDNDrTwgG0FsHq+rUvWqpJCtsWJM1U5koTICxu78TzkyYtpjGWheZ8uFsKjyLKXdepkFbs30AFLw/A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS7PR12MB6359.namprd12.prod.outlook.com (2603:10b6:8:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 15:52:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Wed, 17 Jun 2026
 15:52:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ketan <ketan.kishore@oss.qualcomm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Luiz Capitulino <luizcap@redhat.com>,
 David Hildenbrand <david@kernel.org>, kernel@oss.qualcomm.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
Date: Wed, 17 Jun 2026 11:52:40 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <46EFC111-106F-4C41-88C8-4966AB5D2DF8@nvidia.com>
In-Reply-To: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0495.namprd03.prod.outlook.com
 (2603:10b6:408:130::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS7PR12MB6359:EE_
X-MS-Office365-Filtering-Correlation-Id: 57e8f2de-7dcd-4f04-a41e-08decc88779e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|23010399003|376014|1800799024|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kKNEJB07sYoNLdva63CA91ztCWY89PfEAs0Y9uZQ5bev44MYzPNzuG4Y1SFbvMHCYM1vsOBNlztN6D8j98pgvpKr0YiGHYtMuCUDOMO6Fb304OLjGyMpsM7IJDmIMM6jxkgDZztoeBNg75nrcl2KgMTJDpv6ilyRUG9DJBIYbe30rZc+NcmLgpzqx8qQmFOwY4/36zaMZ13cGB2NQzro8/s9LwsIUxC4r9gH1mGqyYpl3dXlfKFwnREstrubOnpMKTTG1sADKAdtZMTcaxs6kju7IWx0bUqw3QbKnG/QeS83Tkvh+IrDChlzVl1XT/DRychu7ZInWDNLAm8y7DiemFkSoym3v9ktI4CME4u6bIB8i1ActbzFgV3ToYYdyeaYnGt2TPZ5bzGR25VRWwO/Pq+96ljH5lRNdDihhpL03VGugTq60NwzqpYq07nkwN0KQAB+Z0Lsk/5nJZFmiZPotQ0UNIusOrzgEj+uGSqgh2q2DNuVxXHWADcyb66tkQs2aZhjBpYL85yJjAh5jmhuvR6ndmCSvm4WQSJknnD0F9z7uxmN2Le7yRU6j64Lr7Dj7p5qyMMK7YP57CuKJzn/GiewLefPpimITLwZ5t3SdXN6W5t7/p3jTSqyCyRRt1NxOkDcLihlIk27PiFTkYa/0fwPHR8aoGrUr0Aw93rQ3l225OL88a2cTSOHwqTmwnMe
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(23010399003)(376014)(1800799024)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LJlgWgwyQnqxtVrki74ghAfKzzE9VczNtcUVcoOYAIkS0eHOXkAk6IkeWwP3?=
 =?us-ascii?Q?+5HkgdJ6z8d95gpSuowHwcK1E7qLG8yqumRyRKEiBicrZNvfbIapy/fyRSjO?=
 =?us-ascii?Q?3EuF+cHXg3Er0omZrupSYKpQN42AIk/QK7Mm6g92wWLzBmMKya6JL8UhfREU?=
 =?us-ascii?Q?MXgmlFycYcABCze2ojUKf4Z1CcAVD9viFHSvlYPTrunArYuKXxHQvmGj+QZ1?=
 =?us-ascii?Q?jXn692Zbu9FHhXW4LBAm+cxdrFy3DGDCKLLvOsKvczntEvz0A1iTdntudpOj?=
 =?us-ascii?Q?f9oM3K8RJ686u2XgI9qCO5nL8gYwW5lmDYHEHd+ImybEo59INyxV3bNxskUk?=
 =?us-ascii?Q?dZSZ0IqyQGOw4QmS2EZrvUk+p7wAM+Q8s0/GYaI399sRMyRlYM8n5jH23qi3?=
 =?us-ascii?Q?5UZGBDiFDrskCfdN5tcHDXQ2lV0KLNgMXiEgbQJr4c3kpf0hrNXgB8nlfLqC?=
 =?us-ascii?Q?ZVmra5Pt+uyB4sfWMTm/dkFU9qUDzD4H5FbK0fZy5g+jr+cwYcoIoSWEbT2g?=
 =?us-ascii?Q?Mho98K7JdhzTY3hDO0S6E0pFhZQjD6Kpmk48bn1OZrEApWqPk5qH75wt546m?=
 =?us-ascii?Q?nWPctwjRyb84habfqLTcrSWiAhiUCMII3qewDLp/HwVspe266wF88sZ8o4+F?=
 =?us-ascii?Q?YzhTLQQd/9r2v/pNZ0URjjLu2LpZGEyUclN8mjt+uZ7nC3O/BFAh67WVToy9?=
 =?us-ascii?Q?F/J6AiAx+xQYbzf+S4xK92qfoVTY5XhqfTJp1gWl3EKplJ2mrUKCc2zhz1z1?=
 =?us-ascii?Q?nlURNsuKlbmpCKwckziZZWCk7/CZEOMEGfqUasHGnKTqvGpLh2RuP5MvfALp?=
 =?us-ascii?Q?24Zwz2vm4NFFjSdxkNfmJix8QyGRA9SN9kVNbhEQyFFgFqi/sVtNi6pIdeq0?=
 =?us-ascii?Q?iJr6tOK+bBy5cR2tl9rvCJ7EJvbNKNxFCcCwLMC8zMrcZKp8v7mh+OzA/2DA?=
 =?us-ascii?Q?gbJcLgvC502DBAH5K5HrgOmVZN2X/p4YTC1hzHoepVWf+aEKGmKH5FpbBF4X?=
 =?us-ascii?Q?bh2AMbBmDURiUEPW+ixGq6l5rzkVkRNwFkQh3EAXkdUVsVjOooLoX3N1dhZK?=
 =?us-ascii?Q?mhJDt+tP+F822W2iO6wQLXKXgZPP39FPvR+iYfCISEcw5TisQnG7c0B/8DAH?=
 =?us-ascii?Q?HuuZh0Q2lOC26TG2YKV9jCRzJsE9nif/pUBEODZuCKt3V86tdUhcOk3aVxrG?=
 =?us-ascii?Q?96uqhnIEWOKlFQWhb15XBPDkIb6gQjaiL1R5q2aCXZ+XkNR6L4QzIhMXMcm9?=
 =?us-ascii?Q?laIw+5UtsD6u06P53Sku0F84uWFcfbDtwQihcROHsAUlfWsq0ypX8yMGisC2?=
 =?us-ascii?Q?LJmwsAWOZE5C5zuGdNMrMrljp0lsY6Hg8yrhiTU90i48GQsqk28YF6b3lFgc?=
 =?us-ascii?Q?PGL9PMrrn0Law0RaA97JsZN0H8Zzo5af5nsNR8BxYUQPgG4A3bi/h9UXfhdw?=
 =?us-ascii?Q?mZ9hsd8lrRh3ZOHdxHg1XRO2HcvudHBNnl3LPowvWlOL71ezgy++iwwqnADU?=
 =?us-ascii?Q?UYs8a3vRk1GZdq6QW22pxpD+gbe26lL6hZbEoaZWOgTMvH2b4sfsWAmkQ2gc?=
 =?us-ascii?Q?Ipwbnkh/rJUK+iENiOgqDiPYL7pOzYZXr/cneCiNQJDWCwSalI5OUOPubwm3?=
 =?us-ascii?Q?H0LLWT+VtpAyqOOqKFhLw5A4+sKWdEpfM9MdiU4+3myKGLkJKeudNV2r9PyB?=
 =?us-ascii?Q?G+FMJEok/zfauzdz3a0JgW3TOznjgy6TN4f3qfNzlcGm41XG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e8f2de-7dcd-4f04-a41e-08decc88779e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 15:52:42.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqPmZNcs2l+na5N15V1lqvVjuFgP1Ty2eu+cN/yHrL01K7cjCVNcgHuLaU+9muYN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6359
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 13DC4160007
X-Stat-Signature: e9c3an3w8ucc8x4q7euz3w3aqorgwptm
X-HE-Tag: 1781711569-611047
X-HE-Meta: U2FsdGVkX1/N7slnrYN6rw8U8wbrKUjDC7oHXlWZehBb3fg6qEY9ODU9UWWbFSVjO93XLJgB1hbSmCrW7gbRh1dhyxwo45SN1AcsT3EsYwLgkNuLxV4JGUjq9rpUz/Vb03ClbKipK+tcaHnFCudCKHaPKap88GiIigrFr0LPHP7s+TZ5ZX2zck/0iblPeb8fBQY1qmwGQ4PsbOxTwlV7Av5S1ELQ/LERefKuisgCv3ZCdWmPtjJ46M7c2ZyoulmZaydEI4J5FkaSblF+RbaTModdeCn9GTTNhOw+2PRk9tO9gjGvfKnZ874Zwd2jwHcIFu6q6oWThK+IvFiWXH97qra5ptNuYDsfHr+gittypXtpIATkioUx1p+Xg5rXelHjY3gA0HHBFjqayG7uyjyKzat7BOAvHVPpmej9auuazb583DqvpOxbxW9R0f2Clc/Aihw/hkAe+cjUT9zkKSZsHmb8WlurRY2D01SKR0T/gYunxFiRmOZJYWpWtTjXXdF/zmloQniMmqNf+SMHaaqs9Q89T06iPjmvWCvyoQwnWmp4vVX33vsFlt3/TO4C2JyEZRED05QhGZ8fZv0vLt5pvFD8eTxdqbZlCsTrBz9KbyaahxzpiAv2qYEHonlt0GKOqpw6Jvz56WyKs+Z6DpN8nKjl5UhotdDhJW4sAXdbhQEuhMOEundFivZLiP7jg7SnO8iqudZMOtqgnsoK5YLJdbF0RPv7v6A6cQ+kRBNBB0frtGVXv0zw0sKvHyKMRG49scmqNk8gG+maqfTVf5WWg+Um+g5050R8czr/Bq8WM/Kv2K+IKl6QhxDTp1b9PH6I7txm6LXayRVoPycj7rbTSgVXQfKmtE7EACYLOk4DzCDrLO3ShP6BSNXWxbHWR1odToVerpMGp8280gkBbMoDgm+LGM2gKOuFwanrpK16m8G/uc3nQjwcNDaz1UEISJoj2omqLqn4Ojanh8tCFdz
 CDJOpWmL
 KPUamS4JRpH1X+xKSLM+JhobnFzNi/PUttHBSmmJt0UiELDHPXryHD4gHNVQDkcqjzle/m0UygwE1XKmW+z0R/vWkc+L+GR3rbjl43Uv7F36rkZPZZtYp7tbQFjFcXGGyq2L4uLuIOiYw1A6uN7hloSkBCybASrm4wuWGE/NyfDMYTG+uABEyzK7WlaRs/JeMfm0pn1u65ulKJaiEGyiQGp6EdBgb5Eh1QYhsH/h9+FohqlYGM2BS32IPbfswFhbx10hdMXGbdSwi1ulPjaA7KI2vXQGTErtCssNCw2gWdixfeOZ6Yqs3VEVLefV8eEB3J8uxLghwYnR0Lym6hMyosUpuOl2jOoIP3QbxoWVBJAzh61xLZypDrQstxxizcOFYUFVXt8vC9XZITZYfK+BoySwAq4X1MNL7GdODjB9q9d5qbjEk3QJSwQlozw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Jun 2026, at 11:09, Ketan wrote:

> The page_ext iteration API do not validate if the PFN still
> belongs to a valid section while advancing the iterator.
>
> When dynamically adding memory in hotplug path, it can lead
> to a NULL pointer dereference during page_ext_lookup at the
> boundary of the last valid section.
>
> [   14.555124][  T846] Call trace:
> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
> [   14.555129][  T846]  __reset_page_owner+0x11c/0x260
> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
> [   14.571206][  T846]  generic_online_page+0x14/0x24
> [   14.597782][  T846]  online_pages+0x178/0x30c
> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
> [   14.597789][  T846]  device_online+0x88/0xb0
> [   14.597791][  T846]  online_memory_block+0x30/0x40
> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
> [   14.597794][  T846]  add_memory_resource+0x280/0x298
> [   14.656161][  T846]  add_memory+0x60/0x98
>
> Add a valid-section check before looking up the next page_ext
> so the iterator stops cleanly at section boundaries.
>
> Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
> Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
> ---
>  mm/page_ext.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/page_ext.c b/mm/page_ext.c
> index e2e92bd27ebd..74067ea740fe 100644
> --- a/mm/page_ext.c
> +++ b/mm/page_ext.c
> @@ -253,6 +253,18 @@ static struct page_ext *lookup_page_ext(const struct page *page)
>  {
>  	unsigned long pfn = page_to_pfn(page);
>  	struct mem_section *section = __pfn_to_section(pfn);
> +
> +	/*
> +	 * section can be NULL when the page_ext iterator's for-loop increment
> +	 * computes a PFN one step beyond the last registered section. This
> +	 * occurs because pfn_to_page() uses __nr_to_section() which succeeds
> +	 * for unregistered sections that share a root array with registered
> +	 * sections,while __pfn_to_section() returns NULL for them.
> +	 *
> +	 */
> +	if (!section)
> +		return NULL;
> +
>  	struct page_ext *page_ext = READ_ONCE(section->page_ext);

Please move up the definition of page_ext to make code clean, although
I know it is supported to have a definition after a statement.

>
>  	WARN_ON_ONCE(!rcu_read_lock_held());
>
> ---
> base-commit: c425609d6ac4012c8bbf01ec2e10e801b1923a7b
> change-id: 20260616-page_ext-31ef555456fc
>
> Best regards,
> --
> Ketan Kishore <ketan.kishore@oss.qualcomm.com>


Best Regards,
Yan, Zi

