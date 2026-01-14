Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B18AD38FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF386B008C; Wed, 14 Jan 2026 12:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9717F6B0093; Wed, 14 Jan 2026 12:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76EF66B0093; Wed, 14 Jan 2026 12:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 676BC6B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:22:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1ACE81601B9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:22:42 +0000 (UTC)
X-FDA: 84331238964.11.2BF0679
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by imf18.hostedemail.com (Postfix) with ESMTP id 274F91C0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:22:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t5Y+jaug;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.69 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768411359; a=rsa-sha256;
	cv=pass;
	b=qOQoXmOmsyaUHBfIXYjAnUZGy6zVK4JRDJyRzvYLG/7T+mbN3cs7fPM5eOQSzZnANchA3K
	qnceqtjqrq5bTP7HNA0iKGT3/SLu1PCqHjocUE1nuQp31A6CvO/4cUll9U4Y8XVAa4QVKe
	mm4EtTHLvSqtofKwzBVIVE7U8pewppE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t5Y+jaug;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.69 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vtuGYbXDGWw+lvnGnKqEi78jGFN2bwMihLEP0SH4IQ=;
	b=V/rc5KMSgP6AvrlOu3DCT9UTmuTct1iji2+26eKl8GE2ayWhTvLtQPtzQxZm2IxfM6VCHI
	EY6lSvhIVHwMdcNqu//VZDfYwAydFzG1d0Bvb/QI0YQwSEuiUsILgqiu+dNRDQNGDns4pB
	+3WkJHVFaSSXZJYcxR2KPRpmHcoL8lE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWXvDXgIRHo7w7LA6ok8gbalQb+4BykphpPTBpSUgyfQt2OK4maSfWxrlGK8DpprXuHmMszYCW6+p/ihjptq1folwkW386ne4gMFzs66QoCV4zlAVL8cVPZ13CysDAWCAYaCjXNWTke015+k0GBH6zdpB/3NaoqONl5s/cy+rMc0/AUJ8vRjRDfzoOWT90JShuAI8vhXd8sNVl2WkLiZafomowQsYjoYQNAaoEyDsKxlcFjr2r3X3BZ7MduHc7ZxBIemX/zK3Tk9NmpD+85Pbxff2tb2jflsiXo4y0jDEAnhx7/pUEozjcc4y2eWtawBAAHx4AJuNmjHNBKP6xWTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vtuGYbXDGWw+lvnGnKqEi78jGFN2bwMihLEP0SH4IQ=;
 b=XuUQu2WBGyRRO9MeOqCioH89YSQuDUaowYUmE19U7/F3HrJBHDqeYQew6aHJ6eiyhHJrmsZF3/Mx4IE3Gp0kCZj/R8qtERnWgLMTKSFOFYmg7TR+gKXnJVcoYJm6RXTineumBlzaVe5s9mRQIDGnuB6Rnp5KQZ7Ztl0Qeei53I2RkZ1foijO0sXfuNAGXEAAmV8RcfHQqztWlFILVwyNBtpKu+KlIyp2BeA+WjTvaDqqI/QbbcCl9C8WBVzO+L0u9WiDIiYPCTEek2RerFGV8s9MegiJRt46XWkM59l5k2Ir0yCwX4CEtlkKhrptTWXaeFamHwthJyO/B4+4Fh6HqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vtuGYbXDGWw+lvnGnKqEi78jGFN2bwMihLEP0SH4IQ=;
 b=t5Y+jaug6gfRwEuOD251aZBU+DwQWrBG8+8FNkAHeFtcVUPO7x9bQhLuWtesx+iaKYD9S6ggznZvW0ESWGVhdG8Y/vuATxrMe0koVtmzCBhbfViNPSQmDR57NaYyoQCEstMn4elqF5TrF4pvlPWS3D8DbF4CEeCZ7Jg16Cpdkm70VJ0yWzIC7C0YZQYoY8S4WKWeB+5c9y+EPdp+XNLYdpZAxwD8NcrO4jD1B18eihwSDUewH67xop0I2GzxJx0E0TK6TiyT/O2Mbj/bnJP5xeKE08kZctlnKR3YxJVh/AG5NvozvxALnfHDfSSfTuWNMOU89ZhGI+uReRD0radMMQ==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by SJ5PPFDDE56F72B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 17:22:26 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9520.003; Wed, 14 Jan 2026
 17:22:26 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cgroup: use nodes_and() output where appropriate
Date: Wed, 14 Jan 2026 12:22:15 -0500
Message-ID: <20260114172217.861204-4-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260114172217.861204-1-ynorov@nvidia.com>
References: <20260114172217.861204-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0370.namprd03.prod.outlook.com
 (2603:10b6:408:f7::15) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|SJ5PPFDDE56F72B:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e87cd62-c2fa-4af4-9341-08de53917cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZMSDdjJ5DQxIv3/niHX9dbkZJL548E1/gyoFoWqxJyFJ49ICsgVb/M5j7sJH?=
 =?us-ascii?Q?LxLB8w7RstSYmmzriY5hxodYhITBSoew9DSLSGeiRSpxD/e4NwPzZU4PvNSL?=
 =?us-ascii?Q?W1ezkkfk4JRMgMARwBnAsGlvnanxIewiSqDz9ADyC/JZ+rAIOzDX7MWRjM3E?=
 =?us-ascii?Q?tMAEB9t1JTDY4942dW1p+FVUcbGEbC7+GOqLm4DfvWdUmpX1cdaJku7gBGVI?=
 =?us-ascii?Q?Yf+6KDM2ETc7AweZqjro403ZvEsTVkADR0ofYFZESYz1UuN8cJBJPOaw4T5w?=
 =?us-ascii?Q?wbZDN/sZTbRXr3my7hDhGLYKyX80NBVzS7drdxWJ7OkJlWZ4kSL0vYew1J6M?=
 =?us-ascii?Q?mStPAvxMqDbYsjosDspiT1vFQoPqXt3QXgoJsCUGhjIvQLKLs5BvJZl/vKJr?=
 =?us-ascii?Q?2HhgdcRzxOjo/S128pD7Nz2HPsIMdyPf+DZ7aL+0qJSul+YhFHkLDscaMsSS?=
 =?us-ascii?Q?aeAfrpn1CMpWtXWOeEgazfaXkBWx+N1SKyyh9wJSp/hjbv7EMC22uC9Yhb5Y?=
 =?us-ascii?Q?8g8rEftto6Hzaw3ywPxSzPsxyHGwY0bk2TP1mCZkl/GaXfjtDpyAKgQNhn0r?=
 =?us-ascii?Q?4UCQkB9TxEVunVMje/jaBBPdeG3LMxx/heDhkawO51B85juBj6+NKGrQUaoz?=
 =?us-ascii?Q?Ov/iIssz/YkiG7RJ8My+88HJmToR3g1ucHcQWh/Go5xUrudIT4tCu64eGeDH?=
 =?us-ascii?Q?rU1H5+s5r5/sCfspqmmhwjwKY04+JTLxDA1ip0fk35zYtJDNtNu+s0KvltEN?=
 =?us-ascii?Q?DOH5RkFvCOniabbnvNVvcur6PLD2vyhufXUIqUv5X/y4kwrI6WQoKxsToDxA?=
 =?us-ascii?Q?mpwf0mi4g2rPaAXXl+Nl+Q5HvQc7+v5PO3M594uuquNjIdrnp8pMlMFSlppo?=
 =?us-ascii?Q?+QvTS/kR/YoBjZsqPWtrhDV9tpL4JTWQfoRah9EwjMy4CDcIOQIpeQmsVPLt?=
 =?us-ascii?Q?yB+gGyngkZcJh4b9bk40yyrTxcz27GCTfJbkz9N/eht7IscZbIVYAxy2Enyw?=
 =?us-ascii?Q?FN0osFzdVtFWyRBA/iGPH39wQB+1/0aga1GuG2FRisTKfLWAe4Fvz2Zv8ej5?=
 =?us-ascii?Q?9VhaejPUljpKc2HZPceb+mbLh7A2lqz9lFe1aHfh5Zs0xiVQELOlj0dgNKjt?=
 =?us-ascii?Q?dOL9TEs7T1aZQiTO2BSyWSlESA5fyfAntHdPPc28Wmcf9LbpMdEufKI4xd1Z?=
 =?us-ascii?Q?HdCHvjVYSUxAaFPk0MHPBODWdfYmhWkxOwdbmIU9DQq0qPmIf5QF1y8yD1ko?=
 =?us-ascii?Q?I1GvbFx7MaPpvXTEC0Hp9TmvPpGglUW8OOonX7XZWooi+LVNcvCxgTDl6rtc?=
 =?us-ascii?Q?JN3r7osl0t5EduQHdE8psnya9nNR/a2q67sj/VFU+sHARQQw1esODX3/QlBf?=
 =?us-ascii?Q?S8RZAqePmbYdla9263ycoSNZSdKG68H6tIlFnHMyJOANO31ssUvhd7qd5jLJ?=
 =?us-ascii?Q?pjekiPNYzXxzdkVyjXUOq+XXstliKQAFfJ/ddgWglAQEt0Hl4gUR2SfMgWoR?=
 =?us-ascii?Q?EhUrWN7qrqiTND7RZlVdkrH7YC0/MLhqS+6XKCJN8krCHRu9yjRQIMGgooAv?=
 =?us-ascii?Q?qh76coxfUgO1NIx5VkzMvPIFJI3aUEenh1AQjuBR6bZxf9hg65iTFRq8faT9?=
 =?us-ascii?Q?gg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MX5IYJw0sUom4ifuNDl0K+Ykf5RqxIoXHlL7h6H39TRo8yA/BudcHQwKJBoY?=
 =?us-ascii?Q?OY9GiToDHGaNosAP3OUfbZWse3fJCP7JAWuzYEVARIcF3eD9BjnXws10x8f8?=
 =?us-ascii?Q?mEu9NIUSKfxjdcwnXWAnY87V+zaA9ZDSmHja+YIEhW+1PlUtRaAHvf6+HPg9?=
 =?us-ascii?Q?dsA2E6scKPW/Oy0JSqsufAwSsvQtt3bbfNMDJXHrxtKMXLJ8DzlVDNi/uj1k?=
 =?us-ascii?Q?zQd48k6H+dShKACQWpShp1v0gYCTtRzFQbwicU/6s/yDwCx9uAXUvvKUtDO1?=
 =?us-ascii?Q?DCr9dF04t9VT7giPLFEQMiH6KXqUxBv2mCrVSdZrz1gqbj1mQoCK/Jx+0WLy?=
 =?us-ascii?Q?Z4+cLhw5AhKxVW6R6YwMT5a2lX8XQgNK1qK3KKYeiwWAvJs3+63nL5GTafgn?=
 =?us-ascii?Q?tBwgeXL5cU7gjgUlUc4QYZ39RPZTNgsv9m0SsrANyaoDGJ4CazVnnJds6OLl?=
 =?us-ascii?Q?gm6pTn6Aw02lQGAlw0LZOnV9p/2hchQUcLjubXj0qoZs8br6xDdItgjyc+sl?=
 =?us-ascii?Q?g6CK1Ly7mLkJ0F8IbKG4fR4QWjw18GUyWkx0uZgDTvWVC+J2o+P3bxXloDEJ?=
 =?us-ascii?Q?gcGUFSquNGTVV/4pSckQ7U/2u86sSmMenvwOW26n2dUTxaYfxcOLCf0H+ubB?=
 =?us-ascii?Q?YLb8ExGGamCD8OksvsbUqqxNJlPwi1Mmzi453ujfyGHaPXDYG3oRaPG/OD9J?=
 =?us-ascii?Q?30NdVYHRlFrq09rb6+YJbo3hHk4oBEcYb6WdEV/EiPlR/oCIuDx/R4bjzPCL?=
 =?us-ascii?Q?KwDZXfzZkhywxcBFEHdyIjPw6mRoXVgYLD93tONsFyF+t+hbcolZpsn9h0Vk?=
 =?us-ascii?Q?WZf/UOx722B8fRMtqTvzzBJKnMxhWgiiaF0HO9JuK1Pr/2Ctrq7xFT5wFA6S?=
 =?us-ascii?Q?udZw3JZZ1Nnt6Dz1JSizW9EN+dK/90k8sKrsk95U77llS6/u0Fd3DXu/3J3g?=
 =?us-ascii?Q?74vuZlZ+XF8F/yXNRaBeCgeptXCM2TSVK2pQOykcXwFZnM4yvdoezMLJavYK?=
 =?us-ascii?Q?YCeI5VhXpAmHSm8MaxySUh6SKmw/vHVs73P2hMswf4iOkbmBBaN4ewQmEyMY?=
 =?us-ascii?Q?uIm/b0tU25uwPKdAPo3IHHYS3r0K36S7zhpaj0UUrHPhHTyV6IYHzScdqXje?=
 =?us-ascii?Q?NKUEKNoenOUHR7KC1XF8ATBFyy9gSO/MWuHr6op7KslaZA3Vm4YkbqktB6vw?=
 =?us-ascii?Q?7w/0B+/zsko+JkbKhcVFbch531YZj6ti1JKxcedGDfWZ+YstzY+T24+jfuNl?=
 =?us-ascii?Q?sPVxqBrPllPQLcZRaW3DYnl54Qh7kRPZkKLUJ5xvzRtQXQISJy3IOoHvNyKo?=
 =?us-ascii?Q?ufYWdzEhyjZKn9ARCuvh75iOMwtDnhvGQWMnUYN8MAnCKrvk4zkSyknG81tn?=
 =?us-ascii?Q?tMNtDKNAPDxaJ6obAHXPqNvYig1IsBCxFK6Yw0F3zvgw29seoF7pR/CLoTW/?=
 =?us-ascii?Q?gAbyh6kOF5sdyDb1c5DYVj46SgIDNyeZdrL97opjXKIyWHzA0gBOkJNacIOs?=
 =?us-ascii?Q?Kt20cZDKJ2vB2uS64ZqLBfczxCXJINQcYQ1XPE+Pteu7CpRVfgVniNaNvh1v?=
 =?us-ascii?Q?1I7jCfHyTNIsKUXaEMpjwWoY9j/S7aN9WnLKZjmoLn5c7NLp2JT9RUEcAlad?=
 =?us-ascii?Q?zupLg08daTdjgnInjmFeppPnX7cJb+ZZXSV6fsX12D+xXmfq0NHVIlKeoFhj?=
 =?us-ascii?Q?yY7661YhbGQsePfOoVquXicfvqWFTib7ZCNQIT10Wf0J10XKTgxWWkBsZYqe?=
 =?us-ascii?Q?FWmMJli7CbV2BUbL0+jdXwR5nRf7DmToMUWvp1ZwAZF11n9xIYOU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e87cd62-c2fa-4af4-9341-08de53917cf5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 17:22:26.6843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCgn1UyfPbS6WOzt08JtrYwvb0qyMMpdxJLaLUsGrOZ1BvkF7hEu7TAwj8UGoDnXviWRaCWFLe3T8DJYz23dng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDDE56F72B
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 274F91C0005
X-Stat-Signature: xg8dk3xi4gggupyhx6gzt713fuisig69
X-Rspam-User: 
X-HE-Tag: 1768411358-809168
X-HE-Meta: U2FsdGVkX19xaJdgyTo44AyvWzZvjKRCc4D528g8neoi5IRjqLyLogv/cqal0Bz2o5gZrxiTUomiJmnv35UD+u9twyKRar12HzSGZlPriVyYB3wjCcykFo9TT6dWP9VvxMKuPP21hgwERGMBGqJC9Rk4w3kBj/DypVEiTeCjrW+T117MuInPConbQ3OTmTG5dlrl1Qt4K91ixq88FcV6Y7LAvumSc/qpCbwDDSqXZ/7AoEQSw7LFTtJWBNNJWaptuUGlfRqhq+lIqwuG6PYSv3Ih5GQznEpcapnH8SFknahvRjjpsugPkI1YwMvpdEWZB80UmE4up7a2IJTa0VyH3uMWfPaPlzPgNdWqsqcFHDQQwJjMaelWv0CvvFX74solhuHE5NHeSFvN2iZWEifEj33sqH8suSMLii+iDqBRHVDKH+tyECr03J9PmTmo3DkAigGcQn5S4FEjM0WSWZB1/ixnizIdHpGoJkVz8O0D4UC3lowaftDSXtKNUIkTf+BhCy+GLkGTgDweRo2pqwIPo6wFWTuss/vQbq7Xb8NOPvpnEF61nUK1zv2lrbZlY5ZMP8wOpQ1Qv+/Z/9cx7e/N5OLNeK7XT1NVEjyqRXhWoc6GSNXwIJGu2UAtuqVdQs/3TljgKmoJmQ8yGUL0ar51DAXdAxkWJFaMq3jp+N4zHGO+sm8H+x2Px2vHgu/g4eFBwR8vThm4UuoOVDSUzJa5mh5NzYhQPHnmDUNIWK89E2edVVZ45ZAwqAy+rgBCGaQiYTITWPLL/kWl7a6tiRfNQKv5Jln9KqCRllEE+rUplsWPG0W3pweGlDkMsifoIo1RpWiJnGwEyzdE6xu6UcGOKphDf2zuOWh+6xvmtkvTI8zxFi+ZvKQzeu1XAeZVB+AMkS0D+L0d21jnbhzhps1GBqt4G3BUXJZdGuY5lQbMpBhRTcaiAwRNeGbHE73lGOHQWaOfuUcv5S0eqiIQhn/
 +Cze64VD
 12yiO5e75X7hnvqOFxbFcqoPjrs+Uzu/aXUiUze2lb8ha48yxgCyjo7i10J/ISQ7mXKWdu5KTLS3OKtLGBXgy93rKwFP4pMvRKyiWE6eNSgeEP3IVGvbIrkB4yo8TZZgSRstUbVna9KkEcPpmWnnT74JXaP1Kgbt6IuhMQL2lneVmOuc6syDaGn6kiqgT7lbzbt7JZDd/Qw3bkHU/FpDZLo8/ydPyuf43Zc1krgH4Ltzz+ZxIffuB78gufHFMxESqrPqn27tHklgAijutzs4wDCtYUbsLiDEzs9Tvb2ApkZRNbRwaKX0bADUvm5ol3ovk5Qfyig/Yg1ZQfFimr7QagGnQ3rwBnR6lY4iQwk60AwZn2dmLXSjOTxG0fktv/pJxQLpfV/rpsLz3JbKX/4sVOqbVnMH2BOkGyzhmUuEpxuKEi6LgJtuL+EyBYGhJHOWErkSOVrnT346MC92oflNeujua9eqeNTtAq5q08OuLkV7XSzpBO27ZL8e4kvOohXxQhHiNd5Ug3k85+Ku5K/iIYR3kBw14A0Y+zwhm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that nodes_and() returns true if the result nodemask is not empty,
drop useless nodes_intersects() in guarantee_online_mems() and
nodes_empty() in update_nodemasks_hier(), which both are O(N).

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 kernel/cgroup/cpuset.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3e8cc34d8d50..e962efbb300d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -456,9 +456,8 @@ static void guarantee_active_cpus(struct task_struct *tsk,
  */
 static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
-	while (!nodes_intersects(cs->effective_mems, node_states[N_MEMORY]))
+	while (!nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]))
 		cs = parent_cs(cs);
-	nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
 }
 
 /**
@@ -2862,13 +2861,13 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
 		struct cpuset *parent = parent_cs(cp);
 
-		nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
+		bool has_mems = nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
 
 		/*
 		 * If it becomes empty, inherit the effective mask of the
 		 * parent, which is guaranteed to have some MEMs.
 		 */
-		if (is_in_v2_mode() && nodes_empty(*new_mems))
+		if (is_in_v2_mode() && !has_mems)
 			*new_mems = parent->effective_mems;
 
 		/* Skip the whole subtree if the nodemask remains the same. */
-- 
2.43.0


