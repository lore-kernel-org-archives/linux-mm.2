Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 217F1CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3169B6B0005; Mon,  8 Jun 2026 09:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7286B0088; Mon,  8 Jun 2026 09:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5D66B008A; Mon,  8 Jun 2026 09:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3DC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:46:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98C53160BED
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:46:27 +0000 (UTC)
X-FDA: 84856870014.26.1428FEE
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012027.outbound.protection.outlook.com [52.101.48.27])
	by imf24.hostedemail.com (Postfix) with ESMTP id ADBEA18000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:46:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lM29aSJY;
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.27 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780926384;
	b=pCwVA3OPtOWhAdjo0CODWVsvAu5QcBuhuJO08Ce0MN3PxR5E3rKe/qLFhrrEOF413IkqpI
	8Zrgr/UR+GEnhXYZtYzwMPq9TIVpGlLpvi2inBCsNT7gpO00FaO7isuWAbkmS0tbqZmecA
	h4xfkZb6/owIqHs0n9WiQDcZyezWSdc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lM29aSJY;
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.27 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780926384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PvAJuUzC+2YxP86sA9cuRNKnunAVgf7z5MAwRNiKKY=;
	b=VJqqpx89BJzazkhQtjlhuBjQ9GsTNYIcYv2Oc8Tnjz4P7juj8xw5KfKP+02hADMxIfU3ZZ
	j4ixxAhlzYbmt+EiHfk3VH7xfCWEdqBkvx7nx0TL1nQV5rmUet8ySyb14UZPQYeYV+zyWC
	ayfb53lwhU+oWpXC5JCtSXeuj0CqOSk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/hgESJn7Ep7mWVrH8v6FnH7kDwiwDjYiV7WsGZL8nBlxpXU2bJKvJ9ZpFQtRI5mhW0MCGG7oI4TxgnD7j+RETiwe0L1xBToz/fpnviYbUDfuUOJZu1ZJ2puUa7miowfhn88JQLMFmYbGKaK3xhlFlApTFs6xo9Q6yKl63aPxSXp48nhu1QQF5MIVEoPW3qUB9nROl5Sjeym9SOzjyvJAqzMuzkTI9nR2cv10KKMBz6y1Q2HT9UvIJjJrq0Nc3HPG+/qYqCy1HjAMXQ2HiSc9FRbjhiIg8OlZJmo8SXBfpXISI79U8nB2Xf53635/gw7ETi93kKhqVw4amFqpIwmcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PvAJuUzC+2YxP86sA9cuRNKnunAVgf7z5MAwRNiKKY=;
 b=Fp7VhkjEO1Et+UU+3fYt9lzsyxXCr34wUZ0IoJ4rFSk0btvAnWZd1y48X0IYDKaPfK7bzkY1t7SD1ug1fORGQXaGVcAATajPs3G9CLkkYEVopdSVPJGpIPGYVgEjVLnd4oloSBIE8clDYH2+fRs6ueSRolqx94fHgiGkZXu1kLoqg7Qmv+l3f2iAJhZ8d+WgC75IXozU9ElotgmLQBBjc60YllouKFWTmnaZyfc+rV4cJqxzJU1UT4V5D9LBLOfM/kFa3sooKw9I+t/0idoacJNpYrB+vt2/VGBCp1emsY29+QSp5CcfhbnRhCnr/Pb47GbB7Khds0HuqtxJcUa7WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PvAJuUzC+2YxP86sA9cuRNKnunAVgf7z5MAwRNiKKY=;
 b=lM29aSJYY/iMwdgSuOPci6uYoSNyDCihynaD9WNxmo0XOd0R3w6QiMWa5AUuBeyuQxnLxE5JLKvtOvcdGuVlj8Ecp6u/qMtzUUgpOe/Ws5lbSXPxpiMzaNVIojS5as2yr0NG3tuB97naUfN7IgQ68UYPP8y3NUqRqdCzfBAv3JpQfc2OM6Wdai1khj1xnsGHzHMAvDFwgCrILvtm+qFip9PwGJ6OVa6pc1kR2coyUyVcWtClUFQoMBYi8Upg5VYwTicSqm0/Ndt61WCo40iFqmE43pUCVKvQ3fOkX1oliPUYvqI9QXltkqbnhq4s1vfCWZvcyxlFO3dCx5v4FcPp3g==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4261.namprd12.prod.outlook.com (2603:10b6:610:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 13:46:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 13:46:17 +0000
Date: Mon, 8 Jun 2026 10:46:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yiming Qian <yimingqian591@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	keenanat2000@gmail.com, linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] iommu/iommufd: Require write access for writable
 MAP_FILE mappings
Message-ID: <20260608134614.GA4111154@nvidia.com>
References: <20260607085320.73274-1-yimingqian591@gmail.com>
 <20260607120935.GG1962447@nvidia.com>
 <38b49fb2-c2c0-4c7f-ac5c-3e79d54728f0@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b49fb2-c2c0-4c7f-ac5c-3e79d54728f0@kernel.org>
X-ClientProxiedBy: BL0PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:208:91::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4261:EE_
X-MS-Office365-Filtering-Correlation-Id: d4b69835-a714-4875-d08b-08dec5645045
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	MWY4UoP3GDg33NBbBWWbAlGZvUkaMin+nTshtEUY4c6dtfcN9Tz5PL6EPa5zbSIfmrqlK2fnSx6dJG655TceIq94tEP8kJhHpWHtsW63A3bDwbxLCGbiYXC06mZJ+3knzJmIBS7MeoLxkk3/EUFy1KMjFAHdBpJ6Gxz+nYwIouXqe1gY5Twv4j55KZ1Aafpvd4ZyEDoarmoSW7Xp8hxyl6m25cpGMlyz4r6aYWwwiXL5iQgvP8147e//tKk5ELSavXTrhTdJ47gLi8JIgKrW35khhG7JxCNoRu0m7W0UkNiqjB4bpQXxEoybMKT21Ygc/yiTsWlex6KYPPINb2hMaIwUg6FwTM4P7oHx9KbApBVcWzqtoRY5sdMfoq2NOVfZTU1vv2bhtLoZJYJzyKKbeebIb+sZPJMTJnl3hEmwSIq5T/l9LFBFGab8pyfY57C0J/hrrHydI1n+Deqiq0hQORXqrsCo6ECvDzlRQ8fnVAsIaFCOLdNakdJVkTtLowDgL5tMhiG1pbRVtBAWlADvtW9uXHCgDeHg7tVBtImdcvjuOhOTvhUiWNTXdIrJdzndAXBK5wxDEOKKaX8AzvLOv2SC38ufn6poq78CIly8Ewz7/NjR/zsAVJ56o4L0JxFWx1asxrKmrKn/3t20IBcAPp5dlZDohl1LbrOfpo//eYbs9Ez7Ads9vn4d/W33KWuZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+O97uql4uEz/BPsMISv76mZ2vZnX7Nc7FgiKXnwcPGYoEh9SQ1aU+joY8seW?=
 =?us-ascii?Q?AQgx9QamLfRo0cff91D1CkoiZ7H57/MrCuWJ5qu+xBcdHI5RsGC3L6t9PGjM?=
 =?us-ascii?Q?No8dFZ17j6a1B8Yb+kMEnsipmr6I5Pq/JYS4G6+lpkAROfYMlUpl6Itk6bTw?=
 =?us-ascii?Q?iA+gd9y4oVlSOc7OWBeNMakR3CNZwQ/Z0PCQVZcorHLiRGElzrDdx/AiYUD7?=
 =?us-ascii?Q?w9SEBj+4/Sp3Dfogl7zXWiHGCumexL7nznfSH1yovsf68opdDDS+84JIFneC?=
 =?us-ascii?Q?vFaqaufkLt6/eGqFCXYNeAavowkhrJGX8Kd9fHkUrED03blbhY1/8XpSwgkn?=
 =?us-ascii?Q?niTut0w+lMc6BekhZwKDyeqFoewZpFZnKhV6oKbmtt4PDHmbcVGEZXDgHscU?=
 =?us-ascii?Q?b8M6NecGkifbzdqoJxq6T9Io2OJv3ebWE2Lie2UQ2XVnymsQYQZZREdnhKWM?=
 =?us-ascii?Q?EJ1jOtFKOgXJDdM7lQ+TzwpHpEk/PqNZvOynKibGf5YYmJ3Q3/78MfTm5GdY?=
 =?us-ascii?Q?zxv6zsbr8fLjsNTKzMHQFsHWbqfRlIci0rJ3cmVf579jjKUYtNNwku4fz3+S?=
 =?us-ascii?Q?byMcJ1cQT1NJNmvtEvZsQ171kwHMr1nwaIeviKeSeUtMb2hTDD9dIwr9GR8O?=
 =?us-ascii?Q?AaHbwMTF9ebFwzDkpPDHjgH1sAx3kbOsHSUosWsIHiGm+sDwB1rtTXbbqFtg?=
 =?us-ascii?Q?ObVdqINnq6sX3yFxXLEl5C7PNAjtc+VlfxZ8FciDnXf5K6D/NggkC1HRyyC+?=
 =?us-ascii?Q?c7naDcwnLpFnjH61PfNOpQNhtfxGKGZPeBBTNjWVLAgeoqxsi9LMXcjVj9Xg?=
 =?us-ascii?Q?jf3Qy9Yc+X+NbXI/pUCIs2aQrsLJpuGus3E/hWms5sBukCYdzbrrwOki3q/C?=
 =?us-ascii?Q?TS9KDaDbg2Y57mpl84jIh9VkyYGPEo3MORNqbUQIWigEfzKi1vSBlN7E1MWx?=
 =?us-ascii?Q?pCKnC3PWlT5nuVpx9D7EBHAC+7PaVaN5ZJp6T3sWxnJNFpqsHg5M87gCcyDO?=
 =?us-ascii?Q?ogq8jyD7390z6ilLE/tsIuekv7LnF/ouU9DWPwnY9yL7dbTD4KVZ84Nj2hkf?=
 =?us-ascii?Q?Z8wwvljfFSNxNYHse6268OKTUT2j8RhzNYyYFq4e9HIuYCeraDJqNoDp+AuN?=
 =?us-ascii?Q?d+LX1gx8DOSH+MkhsfBo+rc3Kuvk+QcMtoy3ghzlytQoHtszpJq+pXxQZtPr?=
 =?us-ascii?Q?PI4Uwt7TEUTnFeENdlLMnjd8wcAKDrt3Hd2IzRIauWs7JopIjdQfDSQVV9J4?=
 =?us-ascii?Q?Iaw0Whjt6OqhAcU8K1nA5U1zrP6skS9N7oTb3Hd9PobHAVPABjkZvUZeOsgJ?=
 =?us-ascii?Q?RSWakyoTuYkmAV4WpDUoD9o2Mhmvq/305dYIoPNcFvPntCeOD1+47jssQWw6?=
 =?us-ascii?Q?IOIGlGarr+7UHpri0ZGUKke3VZ8jjZlx0tZbo+wmDBLyhQYqrSznXV7H4o/4?=
 =?us-ascii?Q?mJTbaBIn7bKVYrz21TzbJJ3m6GZ0vxEJ0aKrZq9sAhLd0psk0FRkkr5Jk4c6?=
 =?us-ascii?Q?sB+xo81E0rlU594HSE8VuLpjr3XE5/o2anfm6TzK7R4ro5AebdEEjK1Ckgbw?=
 =?us-ascii?Q?yx7vm24P0oKQsvOBuRfWga8utCwUABNFr/3NVP+KXjmV4+X8cYMZnn5Pg+44?=
 =?us-ascii?Q?UjG56BXcq/So6UaTlp9yBozScQgkKoFeSNO4Z9mJDPDtKf2Y73GVclUT/U78?=
 =?us-ascii?Q?WrV9TlF/IOChzXAeejKzRWFPNs6tLjSKsEJ/6RdZthSc3ZqT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b69835-a714-4875-d08b-08dec5645045
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 13:46:16.9115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YXvBCZzu3rG9D98ZeFxXIdZm7aAfpBx8KarZH8LU/rSufgVs0Lk5jVehfDxyijx6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4261
X-Rspamd-Queue-Id: ADBEA18000A
X-Stat-Signature: d6bdekcfccybx7pyc6ows8bewx3jna54
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780926384-916074
X-HE-Meta: U2FsdGVkX18YAAZQiI2gornmQ1iZTPW3Xn/PMusMWH/UEiz/5crSDPMZDoi3n2Xqpttdu9L0pW/ZMwX4+g4mfuZ2I5PFtbCEcvXpnOa7AI9U+LEWR+dmv3a/3kzTDS0GTCeTncERGmijsU5w9ToNWPeVeAXJ82J/Kj+nBNxkwS/mRdgyS0GCVrX9p8T2APAUiYxvVHqvz7rwaBc+Y7IXsCK2y/OeVo3CfoSYOxQbkuA0M25Qa3J+6d26ojTB5C3UpdmnDNCKfYO16tIp6NjfuXhoVuLTLrIgswFxQIqRXvyKz3CN/DkrGRM+jUjA2sFFcRdxT8ogxOpoucJVAQfw4OOJhF7nAoWbgEDVoofwxYNOzyOk8R3HdnNNbVvKghFk4Wj0cPtYRK+X/3a2dYMmtjq/6Mr+au49xW4V4V/SGoXbO1kKKBuqRtHZ2HeZs4vLhJR27gAUwJr0sSG8GtSRYgEVaouJ8b/rfQ057+VHOb13YFgnKkFAFkfcsxPj9CcEoldlLbFUYck4HcEIpju5CJGLLglrpuhyK/5oJyfswNxGmgjsBdPwHGG7pYU0du517EZDTYZzhm//iW7uVOKk/tCdYOYdBhfL5+Pl3W/ghEp/umjcXH1ZDCrH8Odyz+P8/bsoq9yK4VePnKl5K92AoqK40b8O16mZ32wTm9b0ZgL/cAfXI1eTH8ktV20vNzckgkOeE/ZMHHa6aj+7AfyC6v4+CLnRd2RhIUeZFfdt+8g61IetmGYcScPC61osfojW+zOArNNq7XNe9JF3EgkM3pNUsTXp2xiqNx16uVG494o7gPj3F1oBjRo0Vw2oXF2H2ymZO7G0QWJh2Ahwl1S8NMR4KXX8pyGxNUKSlfrlWVzZ2BfWWiSHD8c1W0QgqkeHiRADOSTQVteIeVjM9cj3sM6R0BqPxMPkXZcx3WJJ/kRo10hzHXWIwB3SqdLkG6g2k/JkA3gOvAXuKMdiExx
 ACexeWJE
 tK8tmy4xzg/BpBlIbfQycrjBL4dS2Egob/uCT3gvjIcGcWUT7XWzsjM/Hmx5QX0pFQ/kol3jPGfqQZ66Qrx7wzxrKGQjvjuICHne81c4lOzivpPWwYK+4L1FK8vnXsmzbLCBDH3SEc5MlIF+hh2HKdGc5hgib5LC12ZtAijHi9w/8f0zVa3sB//1eWD4r+yqp21ocYB7xmlmKBNrapEFjXOaKgRB8jgE1mqjlcorMXM7nZ/ykM5ztQfBfOTbgVw9NgVms70OrprWzTA7VRTDMr523KVUBcOgIU76M5Ip5wuNxf3sfC03JROP5j1wdOm6o/4oiHSmZcDgiRKxNJHnx3KtlVaBA7wjNZU212No01h4dn+lyDYKCZnQ+6qa+xzMIO1bnR+CS687wCJtxXSVG18G8D70vs4x5OXpLfRif8iNIII0xDjZJJtxjHBi2+av5t8m11fYwRBuKp48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 03:38:00PM +0200, David Hildenbrand (Arm) wrote:
> On 6/7/26 14:09, Jason Gunthorpe wrote:
> > On Sun, Jun 07, 2026 at 08:53:18AM +0000, Yiming Qian wrote:
> >> IOMMU_IOAS_MAP_FILE pins folios from a shmem/tmpfs or hugetlb file and
> >> uses them as the backing storage for an IOAS mapping.  When userspace sets
> >> IOMMU_IOAS_MAP_WRITEABLE, the resulting IOMMU PTEs allow DMA writes to the
> >> file-backed folios.
> > 
> > This looks like an issue with the API design in memfd_pin_folios(),
> > all users would have a similar bug I think.
> 
> Agreed.
> 
> Not sure if it should be part of memfd_pin_folios() itself.

I think it should, drivers should not be open coding this.

If there is such a thing as a read-only memfd then memfd_pin_folios()
should accept the usual FOLL_WRITE and deal with it internally.

> > start/pin/destroy kind of thing to manage this?
> > 
> > It should not be open coded like this.
> 
> The permission check is one thing that's clearly missing.
> 
> Not sure about the mapping_map_writable() handling ... it's weird to rely on
> that when we are not actually mmaping.

I don't know anything about sealing, but it shouldn't something check
if it is sealed read-only ?

> Assume we GUP a page and then munmap, mapping_unmap_writable() would be called
> while we still have a writable GUP reference. Hm.

I suspect the user doing the sealing has to ensure there are no pins
to the memfd before it seals it. If it already let the unsealed memfd
out of its control then it probably cannot be reliably sealed read
only?

Jason
 

