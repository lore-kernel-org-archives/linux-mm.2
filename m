Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F340CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 03:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A3D8E000F; Thu,  6 Nov 2025 22:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83AD88E0002; Thu,  6 Nov 2025 22:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7025B8E000F; Thu,  6 Nov 2025 22:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABC28E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:21:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 003B816030E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:21:33 +0000 (UTC)
X-FDA: 84082360866.03.C82953D
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011037.outbound.protection.outlook.com [52.101.52.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id 25363C0004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:21:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VGj63tPG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762485691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UPBawhKaV/J3ufvQAXAsSu53F8NLOrIGjTojb5SADE=;
	b=vF/Cybkc5q6WUaCPtRzJCL42KoIgTmxZiXOvs8dCfOWg+O+If/+LttAgewKVuXAJQvr+bq
	e//I42R9fnkcRlHJiE3KtSKu8KNxcrRKIeDCXbdH9kW63t8XJyubm7I6YuhUhfYCqjVWB4
	1HVwkLtmvVz58u6BWBEFtdxp2cxIyGY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VGj63tPG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762485691; a=rsa-sha256;
	cv=pass;
	b=DQIKcTeEE4nHso1GPwqctk6k4WH/GRivOT/NLijd7hl9TAgGC2mA/TMbPUVDD0+EJeSpZD
	MFOUSUDPLo8wuqxBvhD0mEk7UQBlvsKNYF6rFjkAb1h8O2p6bIUgvqKODkiaTuIUWa61VQ
	AImDB19/RR/eStucOYT0j54bFEz6PGQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VcMqN81ya23/fLnVibjlH5RVNHZ4rcXvNJk3HzT0sqN4SlJT+gbW6MEDmG8U6BIDwz4Em8930HCYe/qCtUBiVYlSBZJN8mn93a8CyCR9SBV23NIIlobz/H7QtAYiZaU7xLJoAmqFn/WgbvmxJfGF5Rk4DNboUdAUDxyIK987QP0bE831GoQtQZaqcY+1zjQy6yVjzTXEJ3yf/HmH1uUgKKgxYPQLsdaj1udkOkXqaV0JzZIq6PgdaNNEFtlh5VMdyDSv6Sr+nlBxmsiyJEPmNlWcXmOI47IuqKAsZcbP0ifMRjoVwejfJKBN3mx8S9TI2EATJWpVBY4x66XphUFEaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UPBawhKaV/J3ufvQAXAsSu53F8NLOrIGjTojb5SADE=;
 b=GN1dXWLDpOtcctJSVtN0DgvntOI3FXsoud8Ic/7+6HuIbMnAubVgGG0tv1kcfC84iPGAB4sU37+MugeJSOXRHTrIQ4fuL/v4RUvRfM8gKO86SyKK4VZiIqxc2Pe9W12aCFEgzsFWCVHsEEbpYcCoL9BljGaBhbpm6xS+TSvJmKN5xwtFwEmss818JFgNeqRKRQc4dYckQ7qREQrOegsG4uV1bADSGeHa3Eua9ZC/LUi5nS9NNZCAXhs6f/wQr5OmY/VRrTXI6xsS57pn5RU2W4DWMNfi7K2Oq5sqBA7t/j1qo1XIMf+hAwKsLBdKm5IXe89X+mcKlq856tHTKXuj5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UPBawhKaV/J3ufvQAXAsSu53F8NLOrIGjTojb5SADE=;
 b=VGj63tPGPJbAsZogy3JArbjuREuhqUBmECKoFz5vV+DJQvz6PJ0lYL/U2Nq7fxjMBqX64gqSGlKUiau/nu43TKeRgozAlNutdfoDDK51T9L08MNsa9AwS8DwxsLOvKk3BTi9gwH5Q0uKTe5zSK8wMB2hRTfqVJJzsnZ58Uu5U7dRjuSfJX1kB/P7pKDGK4uYiKZ9lvC+D+RRgGWPN9mZ4Wmw/LY/bjc7d2Q2Ai/Nd9zoi3JaaMvS8Gw2G6pYNWrS00g+HitCqpCsvy1N6U7UeAt+gJKrXYV5MlrU3XP9CV1YFyNjO7l2LZV0m8l5tg+SdezlSYrbfuqbyiDsXQBYlw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB5676.namprd12.prod.outlook.com (2603:10b6:a03:42e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.12; Fri, 7 Nov 2025 03:21:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 03:21:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Thu, 06 Nov 2025 22:21:21 -0500
X-Mailer: MailMate (2.0r6272)
Message-ID: <9271B00E-FF43-4EA5-B180-7A509E839DEB@nvidia.com>
In-Reply-To: <20251107024902.6qu5h6rsmwktzutm@master>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <0D94CF57-A9C9-4C01-A9E5-CE47AE3F10EB@nvidia.com>
 <20251107011721.ez6pile62o3vmjz3@master>
 <136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com>
 <20251107024902.6qu5h6rsmwktzutm@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL0PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:207:3c::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: db70e9c2-7585-475b-14b0-08de1dacba43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HjFJhLAGUdw2+zq0As8dMrIYUgg09HaVOaLI7Kyzp2iIgkZhgUdAsSApIUzV?=
 =?us-ascii?Q?Yf7ZvF6tsW0MQ0ZET8iW8MviClFqAtMZhCiW7jdm2R/HZE44PG2Qaoj968kz?=
 =?us-ascii?Q?Pf7n4zpBV9ZL1uGuZuzyJOR6tiOvl3S5IToIUtfANxLH61N2Z7UyQ8hgYPJI?=
 =?us-ascii?Q?UBqzshSd/E2MhGEPJdHXRCb0K2G470OKUBdcQb1BBHBHTYavvWtfmcqwWwgV?=
 =?us-ascii?Q?IpcjnnsHR1nV3z7DBnoxuBDZDeJ54KTItqWGz4uWwaWJk686KUJHBcYrS8a1?=
 =?us-ascii?Q?VZBQfb02Oni6TUxOT75jfJQL+iyJNElgdkgToFICJb6pNqxzrtrlhUBXNyPw?=
 =?us-ascii?Q?GTKLM97qjkRHzEYhc5HmifsEQ30zhi4tXt93xM2T/M4+fgNHaOXgZGu/v5d6?=
 =?us-ascii?Q?tqG4mQq7O97irO8f3WMsHxaE7oGe0VELsuswKDeSV7srU1CJQ88kaCVI4DMl?=
 =?us-ascii?Q?ABkRS7XXlRkuuLEo/h+iDoMUYpuMBefFx4Pd/Ylq+2uPAfhH2xbulph9BHzt?=
 =?us-ascii?Q?S6X3amo1b4alW+/zKsIfIV8XJt5mcGLoqXuorIpCdeOo787rrT978B9hnF2L?=
 =?us-ascii?Q?RKb2pOJRpw6GMZDFJtQDR8WjuWDPPSvqwIsB20YHRYOk2L9f1OR2KH4M8wQq?=
 =?us-ascii?Q?uQ60/pSxQV1Yo9teRpxEcyjoUuJUNCG3eJVhLKa2tPjq4RNUt1AOE27t74wI?=
 =?us-ascii?Q?Kc/iJ/tc7TXkuXcSL8Vf7NUutvqZBfSdaezU/ypQMjHD3R1BMqXKwB07GH9k?=
 =?us-ascii?Q?sn0jxQpWJbYZwmtIUwfnF/Z+7QfsrONmLsjn5pmqsPvT3Q3D4uV54BhfnFZV?=
 =?us-ascii?Q?r98444qXL6PO+8M7G+KUDoucSepAcE/a8hlSdi/kjcFOCnOQHHozFftEc6MU?=
 =?us-ascii?Q?G+KP/FMuyXZT1XB5JIvYYtDP3kFFmoGZp59Ppw9enBYVld71ibwT4JrqU2af?=
 =?us-ascii?Q?nRtQsX5p5EBmmuo9/rObIFkijgie+F+9C3zAC6Jz2hP07NgE67ctr4WcQuUY?=
 =?us-ascii?Q?Y/058vkl5bfXykHgvwzojei/f0wBIAqdCOW/2dirWdF+BbGaFOd73m+J3Xtx?=
 =?us-ascii?Q?xb3336X64cyc7hMAtYxcirnpGaJPacMqYaCvmEffjTBByj/lnATwg6q+nuVG?=
 =?us-ascii?Q?pLvNxAjgTOpp0LT86HdcPuG6651cyeZ+CMrVkAmIGoS/wNGNjjightaNubEg?=
 =?us-ascii?Q?a8YFlEV8scOx7Prxx4koih8df/eWrlRNIXC2NkS+NiPFPNE7qoHcx+R6GeuC?=
 =?us-ascii?Q?hg0pyAjCFyszJFpB9k/Ad2OVnw/ZuKQHq7kuLi+LPWDkQV3M/mL+wcC2L+3Z?=
 =?us-ascii?Q?V3AwEe4Ytv8IZej/XqCVQSNcL9zekk4vKg4PmyCv1hMrQ6Nczj4y36ZayKUh?=
 =?us-ascii?Q?WMpyL9QWkuxwEx+g/FKVne0b/SZ/lLb04J7vLcLmz+iY9HTlXakxN6WHAZHR?=
 =?us-ascii?Q?ot/iC0yFlejne4+WMgE6C4zEE1M6NFtt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rhUlhU/J5qpjgNztxIL1z+9WKhcYACciOoCWEnKtf5rJToqnc15gK31HhEft?=
 =?us-ascii?Q?EwllSUGwCtbVgU0j3uLva02CKhmVqk9QVvGIsYWeqY6Cm0N02Vs9PYITZxy9?=
 =?us-ascii?Q?Qiyeb+uHQ7UcfddOpuR7JFHQkqfPUvFKEwQMLglGYFwrUf/FdF9s180BsxGN?=
 =?us-ascii?Q?gRk+GC2aHwQHhvLLffGgD9M85tatxFkzROr61RMe3GwLuUrMgAeLk2iYgEhe?=
 =?us-ascii?Q?akTDWOvycE/cPaXGsIaF/2/Vs3VJgIYGcs06rvyJbQcTta3GNx/VJVYinD1k?=
 =?us-ascii?Q?z/qDq/+Vy0vlbHmaqmv8gmKKoPYgYwAQEgneOkXm4BJcI0i0v8ej+WT6tvLT?=
 =?us-ascii?Q?/75RbqSBZ9ScMfpBZZ/EZbiVFjQinhvnhRiTkMYqv5zxfF4PgGB3JwxoXo+G?=
 =?us-ascii?Q?ir9sgWn33aJpzM55QTn0TdQVS/LiAxzM1ZQmuaTjb5VU14cI5+zSP/ZYL0jw?=
 =?us-ascii?Q?jBbSYNSpEMMpT3ZYpr6f6PgIAKj+HGY49PW/pWCdoNCMA5zVRaK16V0silAO?=
 =?us-ascii?Q?bKNyjsq7MJag/lZ0i8EbQIDVoNhMr1T1HUK3jobPA+lTA7W94aiPsnQ5vONJ?=
 =?us-ascii?Q?ux2dYq6WE8Iq1ng1a3AFu6NVzWSw7+JLxUvT2W+s5Aw0TVzzGiEPWvmLKpFT?=
 =?us-ascii?Q?TVj4w5n+RqT74ujyD54qcbmokn6hX9rEYwyXSpkjdqo6sJg1oFbQjlzXap5J?=
 =?us-ascii?Q?hD3duEDNp12+SWzm+tGOeAkoSYy+TCgIn9hIn4XPlJyp0GElmT84S5828cjs?=
 =?us-ascii?Q?PMAc01/TjXGq6xrhoM9Wzo83E70oQO1ZIqh+nDFOwRRPsKAkPx45WwCVpq8E?=
 =?us-ascii?Q?RklUxjC2gfTQab0njBQq8oAgCh4zLLhcs4upm+YelzkckqOj9GXT465pOJON?=
 =?us-ascii?Q?PicXIP/6RtSqxf54G5h2OlVfJBBOQgI1lMCOuFTol5RUhg2X4cEjrK5x+tO1?=
 =?us-ascii?Q?8a1zRfo/TKXrM9HqElJG5gj7HWnK+F9WmYr3edomVLub0XHZ7nMThgbVOnrX?=
 =?us-ascii?Q?kKMXBT2y6wHQWAmrf9opKMUwFOb2UIfvERFdQyq/fuG4G586Ha4Ul1ghxlcS?=
 =?us-ascii?Q?r29PJHPa/g8V9l39XYeJLhk3RvW/wyoOx1qoHf+KL/rte/2Y14mGC4blE9Ae?=
 =?us-ascii?Q?jG7hEdqNheG7C9cLfzoFH8Kc0jdNt7dPoExa2jJnSvUulfgYKKDjQt38pBXF?=
 =?us-ascii?Q?Cg7o6GsofUyaeGsBqBjaa11cHDDs5LGtoJn9DTK10x4HPjojg65gAv2wffy9?=
 =?us-ascii?Q?Cmt81ZpsaGOo9YMsPO1jCBoHlPoSpmhftxkflOJyyjeulCKBAEFijULFpq2F?=
 =?us-ascii?Q?XFNN/pFTloMYCo0NkkhkEoJOEpPkbB85SfH9zH3cGHTr2P1DKkudU0kR7/EL?=
 =?us-ascii?Q?adlnfFneNb9orr/JT/QrkxGIoLTVV+DbkSo3P4T0+THeg5aiFncqAXtaZI1D?=
 =?us-ascii?Q?xYi35XlmutXBeX/TwTRbB5U5p6AZNRFMbA1JTWq7A2/Z8d9CAJzQx33YtYyG?=
 =?us-ascii?Q?HRvZ82FMU+WeANk0us50JtufbHN3HZnfLmjNhxVq7t4ZEto3QYU2EMDkYLb7?=
 =?us-ascii?Q?mGGEQ24zY77ZDDD0REL55/mZU80N/SJelMex2alf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db70e9c2-7585-475b-14b0-08de1dacba43
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 03:21:23.0902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dwK7eS4fOxIVMTRrQzEFpCcpEKmR2YcpEBLURJ7yNvFPT3dWB1GycKMZiQduIM8a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5676
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25363C0004
X-Stat-Signature: uc81dmdgkxep75ci4yrxjhwmtspuranz
X-Rspam-User: 
X-HE-Tag: 1762485687-658001
X-HE-Meta: U2FsdGVkX18AJT+fGE9k/YIgLiZDEO/WoNkaCwM0HiSiRe9QGxHwlSGuu1jT+6faVoE8CPnCzPRHIdHH4Pz79L0MsyuA+2b91LWZH193mYFZn1y55ad42xT4nDLw62f6yJ6E2We2lYoMxBze/px+kW8A7YCprh1JbCqzwG5IRLVS3+TOFVEqwTx+I33RqS+5vMQcVMhmTCJbgXUr+BCsAsZ6148nMBrSM88ze2n/QQdTGvPaf5QaxH1m1X99w+MGCydO+NkNmNGMu/zeKdU/8WxBiVzCCSWJbzkmjguNShFEw03IpKBK6jd/k+Gg56jLucuFTLAsrSJ/JDBCxPkHrbbZ3T+Ujemw+R8ksMDV9R4nPRstEQ59NQs6tZtcwusjUpx1aLYhc8vhRGzXzr23AAKwrItZh+08I1QukAUMG0nRGdADmmH+fNo2TJ+o9vRCQQJrZJ53MFWYmVTxRBGSUTfld7ofKhkaZnefOgA/ccuc0/Sibp3NtRj3p5CJ3vf37SFFCt7NNGS/yxKiTIzMpDJ7idO03LrmzmAeM1ViA5dHyItCi5SYPYgsYiO4WHatnkt76qrl3VMJE3m2enxzFibr/XLUZpjfv38UHW13iwb0eMDZfHWPI9UgpMQm6O7JHw4kLEzaIdxZfIcrVBsU7LY+PtrSxGtcJOrJVOOtw1I8TMoJL9CIXZqsd3qOfTd6xFAQcV+Mne6A1F7lTAQYPcxx/ZDaXwJ8RGGZKq4WyP4PbFnPR5sxo6eyjtJbKs6GbEaJRpyNQ+vBv28UfW7NJq/CoHWhqOH62lT4RhkHFG34aFn4rUjB09zdW/DgQW3xf6sWZy8GLx2LOg5MNi6eo4RsMyNc9pv1WiVfaSyOHVJ3DCAtwe4Qoj6nvWUJUmgzBQp5x3c19H/T3HDv+rvYZldh+CZGrqfdlipSMEMrlvNDQFC9xyknOAM99PUqDA31xG0ammXxn8laeB3wJGW
 MwrSC2Uk
 R8DPlocQsc+zkzrdT2zK6oc/T8v5oBpMjOWhyYd1RshFjpP3hCMdaF1rAYfK8sOQ59tc2+1rI2hcGDxPoE4KqkcDeynOYQpi81UQtPrBVIMAhcbL/1R4FAvSsYxVHmHmEAJ2WNya1aePhBHCXRye9EkOsRVYyu6Bx+5BzkHSFYQvB3L5Mj8x/EnIJlMuwpr5wVPvTGTTOhzRG21SmklEHeOrvk+LNUrrzzpT7EDkPBtQjcxJb1XsCG60JKiLiGVbroC3tx2y8wiMkQlppGtZARisOhLoZsqdvKijXKqwyXcEVOkDuiuuVIVp0k6upLyDnkOuFcRMafDSubyRG/0xxfuTe3SrE+xf0LPWMYwYR4AWEfYTxwJP8+GjtfBn/L/6O2lBsMwqQ+sFt6rtQAmjHKFHV/bJcZiqfx0jhI5MeoiZ3OAXkupOxXCfyl/UAKG5hju+iFFmfcuFIzhDd8aOrfHIjywDjDph4oj51V/BEJNvTFTm0787Ca/D1+FwyEjDzVB6PGO2Ydy4NM9+Aa+epK3dnzsKjRNGOYJJDe3dO2QrHN+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Nov 2025, at 21:49, Wei Yang wrote:

> On Thu, Nov 06, 2025 at 09:07:22PM -0500, Zi Yan wrote:
>> On 6 Nov 2025, at 20:17, Wei Yang wrote:
>>
>>> On Thu, Nov 06, 2025 at 07:46:14PM -0500, Zi Yan wrote:
>>>> On 5 Nov 2025, at 22:41, Wei Yang wrote:
>>>>
>>>>> The functions uniform_split_supported() and
>>>>> non_uniform_split_supported() share significantly similar logic.
>>>>>
>>>>> The only functional difference is that uniform_split_supported()
>>>>> includes an additional check on the requested @new_order.
>>>>>
>>>>> The reason for this check comes from the following two aspects:
>>>>>
>>>>>   * some file system or swap cache just supports order-0 folio
>>>>>   * the behavioral difference between uniform/non-uniform split
>>>>>
>>>>> The behavioral difference between uniform split and non-uniform:
>>>>>
>>>>>   * uniform split splits folio directly to @new_order
>>>>>   * non-uniform split creates after-split folios with orders from
>>>>>     folio_order(folio) - 1 to new_order.
>>>>>
>>>>> This means for non-uniform split or !new_order split we should chec=
k the
>>>>> file system and swap cache respectively.
>>>>>
>>>>> This commit unifies the logic and merge the two functions into a si=
ngle
>>>>> combined helper, removing redundant code and simplifying the split
>>>>> support checking mechanism.
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>>
>>>>> ---
>>>>> v3:
>>>>>   * adjust to use split_type
>>>>>   * rebase on Zi Yan fix lkml.kernel.org/r/20251105162910.752266-1-=
ziy@nvidia.com
>>>>> v2:
>>>>>   * remove need_check
>>>>>   * update comment
>>>>>   * add more explanation in change log
>>>>> ---
>>>>>  include/linux/huge_mm.h |  8 ++---
>>>>>  mm/huge_memory.c        | 71 +++++++++++++++++--------------------=
----
>>>>>  2 files changed, 33 insertions(+), 46 deletions(-)
>>>>>
>>>> LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>
>>> Hi, Zi
>>>
>>> I am thinking whether it is proper to move the check (new_order < min=
_order)
>>> from __folio_split() to folio_split_supported(). So that we could bai=
l out
>>> early if file system couldn't split to new_order.
>>>
>>> Not sure you like it or not.
>>
>> It sounds reasonable. My only concern is that that might add another
>> indentation to the else branch in folio_split_supported().
>>
>> You can send a patch, so we can see how it looks.
>>
>
> Here is what come up my mind.
>
> If !CONFIG_READ_ONLY_THP_FOR_FS, we directly compare new_order and min_=
order.
>
> If CONFIG_READ_ONLY_THP_FOR_FS, one thing I am not sure is for the khug=
epaged
> collapsed THP. If its min_order is 0, it looks we can cover it with fol=
lowing
> check.

1. mapping_large_folio_support() checks if mapping_max_folio_order() > 0,=
 meaning
   !mapping_large_folio_support() is mapping_max_folio_order() =3D=3D 0,
2. mapping_max_folio_order() >=3D mapping_min_folio_order(),
3. combining 1) and 2) means
   mapping_min_folio_order() <=3D mapping_max_folio_order() =3D=3D 0,
   meaning mapping_min_folio_order() =3D=3D 0.

so a FS without large folio support always has min_order =3D=3D 0.

>
> Look forward your insight.
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index dee416b3f6ed..ef05f246df73 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3704,8 +3704,8 @@ bool folio_split_supported(struct folio *folio, u=
nsigned int new_order,
>  		if (new_order =3D=3D 1)
>  			return false;
>  	} else if (split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) {
> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -		    !mapping_large_folio_support(folio->mapping)) {
> +		unsigned int min_order =3D mapping_min_folio_order(folio->mapping);
> +		if (new_order < min_order) {

This check is good for !CONFIG_READ_ONLY_THP_FOR_FS, but
for CONFIG_READ_ONLY_THP_FOR_FS and !mapping_large_folio_support(),
min_order is always 0, how can new_order be smaller than min_order
to trigger the warning below? You will need to check new_order against
mapping_max_folio_order().

OK, basically the check should be:

if (new_order < mapping_min_folio_order() || new_order > mapping_max_foli=
o_order()).

Then, you might want to add a helper function mapping_folio_order_support=
ed()
instead and change the warning message below to "Cannot split file folio =
to
unsupported order [%d, %d]", min_order, max_order (showing min/max order
is optional since it kinda defeat the purpose of having the helper functi=
on).
Of course, the comment needs to be changed.

Hmm, but still how could the above check to trigger the warning when
split_type =3D=3D SPLIT_TYPE_NON_UNIFORM and new_order is 0? It will not
trigger, since new_order (as 0) is supported by the mapping.

I guess the min_order check code has to be in the else branch along
with the existing "if (split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_or=
der)".

>  			/*
>  			 * We can always split a folio down to a single page
>  			 * (new_order =3D=3D 0) uniformly.
> @@ -3827,7 +3827,6 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  		}
>  		mapping =3D NULL;
>  	} else {
> -		unsigned int min_order;
>  		gfp_t gfp;
>
>  		mapping =3D folio->mapping;
> @@ -3843,12 +3842,6 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>  			goto out;
>  		}
>
> -		min_order =3D mapping_min_folio_order(folio->mapping);
> -		if (new_order < min_order) {
> -			ret =3D -EINVAL;
> -			goto out;
> -		}
> -
>  		gfp =3D current_gfp_context(mapping_gfp_mask(mapping) &
>  							GFP_RECLAIM_MASK);
>
> -- =

> Wei Yang
> Help you, Help me


--
Best Regards,
Yan, Zi

