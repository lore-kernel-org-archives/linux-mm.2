Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D80BBCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294668E0006; Mon,  8 Sep 2025 21:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C6D8E0002; Mon,  8 Sep 2025 21:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15AD08E0006; Mon,  8 Sep 2025 21:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 044A68E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:11:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82593855E6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:11:34 +0000 (UTC)
X-FDA: 83867934108.09.694C78E
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
	by imf14.hostedemail.com (Postfix) with ESMTP id B07E4100002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:11:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KmPJTuzN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757380291; a=rsa-sha256;
	cv=pass;
	b=fiUk1uiHq2H+LzUNg38euREuBsCe2IUnA0rte17veIPYGHCGtmGjmdMBxF+YIov1C9/lSn
	ZEfaZ4sBIirL4OWYOn3JeX/3s4Q0YqXpGo1WDwchCEmJWOE/NaHt6ceA68Q21hYnHBkZIF
	kwRyFVVC7uk73Hl0AZJ97cl6EddVZe4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KmPJTuzN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757380291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amcCkDCZ5uPMp5ui2vCz7NdO9Hc9+D1ni4A7KTjpR4Y=;
	b=uWgRJZaiIDSa5d0DR7DSfxvHsOeyBnRSeg/TRaUxVnVG/T2WkMXNYXP/YJX2xxH3iynVZ2
	5EzV1RZoivJVFCPi9I777JAiLjQTzZYxZ4kQ4vMqlNvHqyRNFsw5Q7uerwAkTriDr+tv0B
	+Au4SoGO5CiFhB3UopOVa2GGRz1s/ho=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xML0n6ZghtKbiwbNKY1Y5Sg8TpQIB2E099IeBDt6SewsvxJ08uYZaKiR7iWzYKhZg2NaoL9fa91y/l9xb4q+nbItvsprMWxOQB0ZsUmVofikgk1tGx3jFu1GD4Jn8RyyshFPW5AJF1P+XkTyFIncQwGpuYnRRmHVPz3lkReywa1KeIb5uspjVRXmdW60EP13VoAAR5pj+a4QlVgt7Wsnc+GVNiWlc/vCpXkgCcohVYslhx/Fc0faUgbvmiRGIOgC1ZytN7YtcwXHWK5d83etFNWweemejwgdK5Hef7aTI+AG0PVeM79KW6LCq5Q/f5hvkU/bYrrxknVP8RE0WgsX8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amcCkDCZ5uPMp5ui2vCz7NdO9Hc9+D1ni4A7KTjpR4Y=;
 b=n9EOcl47MsIA7/lCKQeBrdsv3nj/+yhUuWrsVdknb3ASHFZzJkXhXR+Q7+7xcleivhLXFhP1mw9Awwa9JcWmAqnhLW0rib9vQiAWhIoQbrmFzgAcP6VX5A3RD07HkGGohn8S5STIASpK9uysczCCnOW09HiUht/jpFXJnNPQRlWDThVEa9pehff+eQaOM4AVZsAGzVWe78uThmVghpQMSuXQrlsHNs9GtrNo6MgkN8pPeiYAS6CsWr+9lClcINBFe8Fj3o6hG+QhB50Z/zWlc48dOfHwarBnTjGqQwl8Pe4RNciSgzqUWOZ1cbapGKI4qlyKUaO5YRfZzTvna9nDbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amcCkDCZ5uPMp5ui2vCz7NdO9Hc9+D1ni4A7KTjpR4Y=;
 b=KmPJTuzNgnj/3DpL7ZY+Wh8cISHeE9CHL4T+w9W7q82TrO9IPjPvjgqZsZa4Leso9J6SgGB4FrDHLf3n9xy2FiJYoAmnSX9HbTxaORU0RbyrJLHxWsdPVhxLh1QRxqLZDb5nn0UFKt4hVsLfHqlXdehTyai97+GEIkzHXQ+BOjnFqAjetDCPjJUB6Wz6FiUTKkSpnifnbRHOk60qirndmJnGmsPCL3x8xQqUXBfBxPRfNIsKofy5IvEMQ1jbkz4eHmH/iWHY6iCALslwo/R+8OkcqCRzc/bNhl4Az5SY45FtrZ7iJPMXJfaWASRusMb/QWJYNZbGTobJllyMOX8TEA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6031.namprd12.prod.outlook.com (2603:10b6:208:3cd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 01:11:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 01:11:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 3/9] mm: hugetlb: directly pass order when allocate a
 hugetlb folio
Date: Mon, 08 Sep 2025 21:11:23 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <64DE9265-7B31-4128-9949-84AF050CBFF4@nvidia.com>
In-Reply-To: <20250902124820.3081488-4-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN1PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:408:e3::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: 58189a61-82dc-4578-79dd-08ddef3dccca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ck4a/0pXFGiOl6xzjHcDpVK/ybU111Iuu/kqcoRGq8S7x6ssqj5gAqaaNg6A?=
 =?us-ascii?Q?sOG0qCAgz/QNx5Cy+1Dpv4fUk5SHaYB7eiwpDwVZRn/RNeCuJbuFe0nz5ll9?=
 =?us-ascii?Q?H+lbG3gMlg57H/zkyOcDW2Q/HwYRdjEYUap5s0dBrut5fSbx21bCkeZC4MVq?=
 =?us-ascii?Q?WWVYggE34SyR6kocItHoXJtR1ZnrEHsXnL3FQky924JbCo5XJk9Qa1CBthSc?=
 =?us-ascii?Q?WAA0ax5+y8OlZvfH+Saf2LhinMPlHhdsLSIz7EUeL126tgd74tR8yN4ZMtqP?=
 =?us-ascii?Q?eylLNh04+zB8oantARNxShPMwPeJWX+vhxLZrR7NR1vbJjVl439EjGiP2gIc?=
 =?us-ascii?Q?2kBm7QrOMwYHBAUAxvxzAPWC/pqHZsppQ35YXmUQiqkjdrM1tsDoqzmnUxeW?=
 =?us-ascii?Q?ubrm13SBSmBjhZL56ymbF+Kzq5maoCZIwe0U51pwdnYILeEOlkjdVKWm3RNA?=
 =?us-ascii?Q?volw9gstp+q8/NPGebL6laEevDRvUBE+PVN7SzlBZulfq0kkbzixyh+A0HgG?=
 =?us-ascii?Q?s456lI+OKaAonHN5oE0SvkeKdYrQw8T+vt2dFm19KIkkwR4/CjCeOfSXUCdb?=
 =?us-ascii?Q?qERUdVweRuwgNg0fMIIaZFoVbQtCiJdia6s8go0+cUD7Y8CRcUrjI6moShaz?=
 =?us-ascii?Q?uIqShMH7HO39JHBmn0NPJsxtCGIur5QX5ENbK1T8Srle/bdJ04IHO6n7c6pz?=
 =?us-ascii?Q?uM9m6+TIicIMgi3KuKQTCEAW/Y0/JTE7LKCumme15+ObOthdzLy6OgmNsQZd?=
 =?us-ascii?Q?XiW7Ee02x2YWFfNg8QayhQY8I+7ynBUgXDZn7CqitGS15TxTLQ2RadRUzYyF?=
 =?us-ascii?Q?hzUDq3Q2pxG+KILUG2yM3O+5+6bvWBxxCN4kq53D+9jTJcT2cp1WjwoMKVvO?=
 =?us-ascii?Q?G5aBilI2Qpsr0sqJwezxerMywS3lsizm7Y81aLA0xruqCyKrOlGZUM89V0ES?=
 =?us-ascii?Q?j4dHuJ4PdYzHPV6eybGE7iwInPXHAE2qkxVexVMb/G1BsjjQ51WDonel37sX?=
 =?us-ascii?Q?boGwmLniTQamEu1uh2G06fdmh8x4Ltjr/i0FWs/oXKSP6Ne9jN6c1QjlU6qw?=
 =?us-ascii?Q?ZFQhoOAchLxPY46oUCUOap9MDtNH4kO5uWCjmnCpcKtKmOAVcdbP7CLiceis?=
 =?us-ascii?Q?CiALSfXUJAEKUWcQ3Yd75qkGKKWrBTIAXbe0u6SjaNIXGL1wqHKalDc5Pkw4?=
 =?us-ascii?Q?q/9MCGUrrL1IyMUL4hzVLNMhUZ1FSF311J9Cc/sN9D13GViNdNapiFPEXcjf?=
 =?us-ascii?Q?3TGhxezYSskIQAc7W5ysgMrtzmd43Da9r1lDPP6bcTbtTBuJWDHZOkgTx09Q?=
 =?us-ascii?Q?uB59Cdzsc8eCRgaptBMOP8CVYH4QrCp88+e60zC3hx7IM+velqAYcKOeeBs0?=
 =?us-ascii?Q?rUfSlWOt/NnVLgqd7Ze0cJbwXHn1XeByBbISJSkw+vIeQtpTQb9a+x2KgWNY?=
 =?us-ascii?Q?LpvnUiNoRLM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aC5IgCkm6unnEAIGgu0I3joFIvyIaOsMu9QMmnnwQ0sbDhr65uixiUS2NRLb?=
 =?us-ascii?Q?g795ImFtXUM4sph2Cm3Nc1/TAeXm2ZxlBjtKlY1Eo9RUnG76QrP5X55CDanw?=
 =?us-ascii?Q?I4zrCzenkKIEWxO1qisyRWbMh6M8CAp430PfTWo1SygXjEk2SA1NxcR2QTYC?=
 =?us-ascii?Q?H5a0j2djuqPE1ZRM3QFHCaGPJb+4nllKfcW+7/V4oewWOP+cqS1BXZvKQr8K?=
 =?us-ascii?Q?t+ob8iNXUAmHD0q6GFYAiaDcPSKJjtGsA2oBJkUULFAI92X1XKeiMRnDvzJZ?=
 =?us-ascii?Q?wvAJTsFYa7fGXRAPVf6GUlKQ9OSiDg7NeKSKCEfIZS4Utvpqt1xdJlbWBd0z?=
 =?us-ascii?Q?Dt8dcB1jI3pK5b8mkU2qs3z6/ovZDIlPk/UIaMbK1AiQZOxOvJZFZz7LAWtd?=
 =?us-ascii?Q?peqhVaFSqSzLhmvIwINYRSofTJpVrgeFRPzpozmW/vz4x2hbMzy4AspkBq2r?=
 =?us-ascii?Q?1+HSc9Ly4hL1hgkjRArnAAVNfWFCU2CQjOSEQB0KKCHVE3akO8jCI9zNS/M2?=
 =?us-ascii?Q?WNSJtHjUV1pg5AkvbxkhtTRfodfdQfE2X/g1ERqJbpkaOLosrx8x0otesW1E?=
 =?us-ascii?Q?SzSXyTEKXbtdwnR4Mn7PWcrPHogP9krDdl6+n7ScWhbObWssd1srxTBaoumD?=
 =?us-ascii?Q?gkGL71MzkUfDkOJUQbuJhmOM4g3Lcd6J5755UF1Iny5ZQ6RkzuX0n+w59g4v?=
 =?us-ascii?Q?ZpLlun8nU8WMI8ocX10T3dnHFScYcqG/mrHVV4mkygUKoXHmrw6Ngdw+sT1Q?=
 =?us-ascii?Q?zHcZJKXNsVZPfGmbnklY5QEAa/a8jLKMA07aO8MKuVX8DuV6lLNSfERf8Om/?=
 =?us-ascii?Q?TLBkU0XMnYvndh9aFCnKsgZExFilacmWEcDO5Ag1Z2fL8OLQXRpZx6h3KeT1?=
 =?us-ascii?Q?kzk/Eu139Dk5EBXNNPXmq/hex1l0RArgVvzXfqRzBq/lp2glfaO8yX6Wtqwc?=
 =?us-ascii?Q?WUo4CAgC1KgnNg+2q3Y9KQvSvlBN4aAtSxBQuggjT1X+y35HGceA/VQ+YFSH?=
 =?us-ascii?Q?a5SaZg4s+AgJC+nFkOE15LY1PfXhT5+sH4/J/KpK3oJ3CqazIhuv/4fAnWHy?=
 =?us-ascii?Q?Dk8IY5Ujs/6n4qhfCrbaZn5X8DGpOY5ZJM4lDgUPifgfgbkKmk7mGqw2FRz4?=
 =?us-ascii?Q?QOuBcIuleGC3qMNMek1NLxHKUXBYNxDkWnImHfczMxiu7ozzzVP3tf47Uck4?=
 =?us-ascii?Q?S1uZvoReX1RhQFBFA7SJTTkCOMRy9uD1esTRSWU/JpP+nFVFXKoKV0bremq0?=
 =?us-ascii?Q?/z7UM/+PVDmPPDUdhjVDT2gmJfqJrZPZZ12GIiuL+Pge8ySUXtED3bx1QnPl?=
 =?us-ascii?Q?HVerShA+hALPFZ03CGAFEwR5EXpPDlz4RLiHLUDhlH+cq9UkMtA+8LJLul0r?=
 =?us-ascii?Q?KbCfOZNtWoZe3I30CV8O8Mo+f/RPDbtzTHrKcvH1dDX4BR6Dfdj46Q2z2IZT?=
 =?us-ascii?Q?T6gprFeuS+jUlpHAwY5mz5BFCPG0OLo1rM8m4OGR71nBZF9MHEsw+kHGhRwp?=
 =?us-ascii?Q?X5tHy218mXiqWtaD54GffqAJvTyAXQvVPp6/2ff8HqEzS9T+fO/EEbJId58w?=
 =?us-ascii?Q?PfsK7uINHiKE/d9qVWcC8ZqFFm1+kNqmmgzZAR8m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58189a61-82dc-4578-79dd-08ddef3dccca
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 01:11:26.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i10W3kh0+gy6Sskqa6MbV92nkSiKmvSyVZ89vP7FagzjX3kazSi6HdMW3NodFD/7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6031
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B07E4100002
X-Stat-Signature: gjiftxyytocjtghmjoywmiohyaykdhhx
X-Rspam-User: 
X-HE-Tag: 1757380291-935836
X-HE-Meta: U2FsdGVkX1+oz4jPCrUst1bsWe7x8FqIWbMhiMsiEoCthhJ0++zO4BSR7UZ9kIgVCThEXLNmLBUcPyEWO1mUxisliLQU1Gbatk1GL0JI+OcqQq6fFUOsvk88IiYHSV3KCfl6CbfTadcELy/voCo9A/FxhtKF2PKWPZEID2cIufVcQQ3zq/fwdYNDt4phaJzCXwE4c4flVVOHHGZTf4z+N/nqrRHP6mgdhPqF0rwaIKcUV1o/Is+ntSOowcbjFWmxWlUO/Mc6H1vhp9IaLuC5CwuguWLQtzN6N7GYigBosVA0EhdPPezqW/8IBLg29iuHEiffPJQ5/+OxNIf03hEy2Hxm8h+kjXc9Cd1YLCedYRkCDphDvKsyXX7qbyF/EuB/AMFomuVQ5GGuvBD3plvrSikOipMUFV185A60hnEU1PIc9QpiLo2BrgjRFlG544lnlRyXdSfiMuO4CSHOBloqV5Vl9Vq0/YYRA+uzgjrfhhmwjYXDZ+9IoSbB+AvZlgXF3gZ0EQN1j5MLQb8XTKpT7zxBpDFAAaNBk8anVT6Vnr1d5GH46QbXaIA75tW8KvtrNFeziKTXqOgzsJUPwdyJdGO6Xut8oKHrFmjJk4sFHB2Q70H1DN/je+8hqivAjoUV51fZnh0QgUJjgGqywlJ9DN1hN0HQR3XddwDv5oemp7u5EjW5kd+PigURZ/2wI88TgeM4y6bgvOnZORMco/q7MPQH9AGW4mXPdmBKrGKJSc3XrNn67l+3wxVIMj1aucW7kC3Du8IQPPRbMFVGCvNL9hf8KEwe34Yy5NcirUclXU9oLXTfAis6U39RKmW0aH3iD3qoXgNyfKOzx7xd1hmhcKD5nklL6yDo3hKvD8w1CRBsbb6Se7ELJL24eKBtD5AYybkSJJJBaSzxiHNEK2CRY2qhnexl6ECKShHgHA/LHtR81Su3iBhA4WxgnmQneBvNMv3BLs2YEUCTc7Ue0Vt
 3UZSfGcB
 aLZNVn4wp2gXOoIRBo3a6O4RSedBBBAKKYhidFWj6y1VGtdT5ovvH8I+tNJKdQEsfpfbCTzCPRT0piC6fEFzPy3k3PNWPEH7cpOvA0KuOgAYp63pLg8Y5GzamACjQO5UiQNzlk6xpaEQvkUs3mk1JsdJ0fuj6ApuQf3dVu6JoJWQjqS3w2t3ah/lQZo19dDBba0Q40Ijq9ZO97W0FxdlX1HnhDs6d06MGXyTbEhr9D3Fs8q69s+nWexLVAgDKzPPvE1dsy044mRa4fYAZLgaw+coxLUCmzgCmQHI+1HhZgrwlxxgTAXoPV/B9wpdT77yJd5Cgsr/gydJolYJ8wwBYtXev5og8mocoDWF6BmZyzMyrBIdaoyWZiH0CfKd4mqqXM+I+OceKa9/y/z+WM07l3OZXELgpEQU31fDHc7Nn4ooqGmYm/ypHNBi74by3UVoa3ArS6+1GvPLFsjVS8f0Ew3tyKIKwhzcNEUqUycirulZKhVO22uRuEco9/xWhzJcndsW/BHwl7uECBWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 8:48, Kefeng Wang wrote:

> Use order instead of struct hstate to remove huge_page_order() call
> from all hugetlb folio allocation.
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb.c     | 27 +++++++++++++--------------
>  mm/hugetlb_cma.c |  3 +--
>  mm/hugetlb_cma.h |  6 +++---
>  3 files changed, 17 insertions(+), 19 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4131467fc1cd..5c93faf82674 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(struct hsta=
te *h, nodemask_t *nodes_allowed)
>
>  #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>  #ifdef CONFIG_CONTIG_ALLOC
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_=
mask,
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>  		int nid, nodemask_t *nodemask)
>  {
>  	struct folio *folio;
> -	int order =3D huge_page_order(h);
>  	bool retried =3D false;
>
>  	if (nid =3D=3D NUMA_NO_NODE)
>  		nid =3D numa_mem_id();
>  retry:
> -	folio =3D hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
> +	folio =3D hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>  	if (!folio) {
>  		if (hugetlb_cma_exclusive_alloc())
>  			return NULL;
> @@ -1506,16 +1505,16 @@ static struct folio *alloc_gigantic_folio(struc=
t hstate *h, gfp_t gfp_mask,
>  }
>
>  #else /* !CONFIG_CONTIG_ALLOC */
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_=
mask,
> -					int nid, nodemask_t *nodemask)
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, i=
nt nid,
> +					  nodemask_t *nodemask)
>  {
>  	return NULL;
>  }
>  #endif /* CONFIG_CONTIG_ALLOC */
>
>  #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_=
mask,
> -					int nid, nodemask_t *nodemask)
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, i=
nt nid,
> +					  nodemask_t *nodemask)
>  {
>  	return NULL;
>  }
> @@ -1926,11 +1925,9 @@ struct address_space *hugetlb_folio_mapping_lock=
_write(struct folio *folio)
>  	return NULL;
>  }
>
> -static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
> -		gfp_t gfp_mask, int nid, nodemask_t *nmask,
> -		nodemask_t *node_alloc_noretry)
> +static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_ma=
sk,
> +		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
>  {
> -	int order =3D huge_page_order(h);
>  	struct folio *folio;
>  	bool alloc_try_hard =3D true;
>
> @@ -1980,11 +1977,13 @@ static struct folio *only_alloc_fresh_hugetlb_f=
olio(struct hstate *h,
>  		nodemask_t *node_alloc_noretry)
>  {
>  	struct folio *folio;
> +	int order =3D huge_page_order(h);
>
> -	if (hstate_is_gigantic(h))
> -		folio =3D alloc_gigantic_folio(h, gfp_mask, nid, nmask);
> +	if (order > MAX_PAGE_ORDER)

Would it be better to add

bool order_is_gigantic(unsigned int order)
{
	return order > MAX_PAGE_ORDER;
}

for this check? And change hstate_is_gigantic() to

return order_is_gigantic(huge_page_order(h));

To make _is_gigantic() check more consistent.
BTW, isolate_or_dissolve_huge_folio() can use order_is_gigantic() too.

Otherwise, Reviewed-by: Zi Yan <ziy@nvidia.com>


> +		folio =3D alloc_gigantic_folio(order, gfp_mask, nid, nmask);
>  	else
> -		folio =3D alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, node_al=
loc_noretry);
> +		folio =3D alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
> +						  node_alloc_noretry);
>  	if (folio)
>  		init_new_hugetlb_folio(h, folio);
>  	return folio;
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index f58ef4969e7a..e8e4dc7182d5 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -26,11 +26,10 @@ void hugetlb_cma_free_folio(struct folio *folio)
>  }
>
>
> -struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask=
,
> +struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>  				      int nid, nodemask_t *nodemask)
>  {
>  	int node;
> -	int order =3D huge_page_order(h);
>  	struct folio *folio =3D NULL;
>
>  	if (hugetlb_cma[nid])
> diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
> index f7d7fb9880a2..2c2ec8a7e134 100644
> --- a/mm/hugetlb_cma.h
> +++ b/mm/hugetlb_cma.h
> @@ -4,7 +4,7 @@
>
>  #ifdef CONFIG_CMA
>  void hugetlb_cma_free_folio(struct folio *folio);
> -struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask=
,
> +struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>  				      int nid, nodemask_t *nodemask);
>  struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, =
int *nid,
>  						    bool node_exact);
> @@ -18,8 +18,8 @@ static inline void hugetlb_cma_free_folio(struct foli=
o *folio)
>  {
>  }
>
> -static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
> -	    gfp_t gfp_mask, int nid, nodemask_t *nodemask)
> +static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t g=
fp_mask,
> +		int nid, nodemask_t *nodemask)
>  {
>  	return NULL;
>  }
> -- =

> 2.27.0


Best Regards,
Yan, Zi

