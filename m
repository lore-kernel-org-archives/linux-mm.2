Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119D6CAC5BD
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 15:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F998E0028; Mon, 29 Sep 2025 11:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046AF8E0002; Mon, 29 Sep 2025 11:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E778C8E0028; Mon, 29 Sep 2025 11:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7B108E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:19:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EBB31DDC07
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:19:42 +0000 (UTC)
X-FDA: 83942647404.05.6208B39
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id C55DF14000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:19:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lj6pInSp;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759159179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycvlcv0f++1J6FnOCBxziW/v/y8Q47j5L6dIIaLkKRo=;
	b=mESUbNUGXypC9Nr5l7kei7wpITtkOF0GfhFUuJdU0VJc66/f4FGlVATvyueHEmbxTWxMVY
	J0j1SJcZcCkJhPA65RF86RCI0rRoA+YxvL9X3afi9TmatMF/wMNZ4KFcPZ2nIo2GoJ+e0L
	FaRI6kc5L9LxGOe/+a3cc5VWnnHfwZ8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lj6pInSp;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759159179; a=rsa-sha256;
	cv=pass;
	b=JAOAApLehp2C1+tjfz2mfQWNO+iY93+HB6n9jEcFQMMyoDZ3lFHQ7i0zFQ0YzFf1cY9WiM
	tdwTbEmVff5UkFNHxe0TsJWDk9D0ZOdX93RJcVs3CSE7e7ft2J3hw1cZgjsx4Odm9w9xy7
	hAA+XucLgLg6A+m/nBKvsz8x7F9mzfI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vp8v+lQMMtcY8Julvs4HNvcEqhv1OABvmAERbpnNW8Ah0k2syTnjVat8rLGpZ8MqDOJqvH8HPo4WHAcOz4NYxzYA59NSgnMDHUGH/m7Dg4NtSOPwgU3SllTCnHA4DQVILUQbdPingsB78VIYskVRuj9h703c5E4vLHXimEMwWvl8mQBqwwxzOZaU3X9SZga/QJ+r3P6em5mzQ47SWt2+OYs4Y0hNiGiNNqzKnrHguEy6cl6R7LhMqTT+lEs4FLo7MGWp6atPmJae7TAYyIu+OBFbS9RxD5eU0B6XMk/9/gKfFOSMaR3CNaDeIdcoqvls0Qt3w/2KjGfdlwINSopJBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycvlcv0f++1J6FnOCBxziW/v/y8Q47j5L6dIIaLkKRo=;
 b=ZNS9Y0cX7CcsSX2Af2Ifvc3KNWlstSgnOcG2+FqY935QA0OgmAfjGXy7eRBuBCUr2Daj1qLG7VWqC5cDAmlcUl8iGGv5DIbJ6raNCm621pHX07iMCwS+cZof7yN/8JdpfGuT+MuZ0wIwBEE8+O7PYNJLT0rFY/znzp7BFR39wTpwWEQSXJd6tVHA2NFQVE55VQH0KCkil7kooeXy5rU9JgECnUvpLz8+1rtdy5Ym62gP5Hi/X37nLQtyeVka9mDxsqBwH62FZN5WpHTiXgObE5/pxW2aErJTDgzN+CwgSv6FJMlGAckKx3ikEX3U4Oy0/iZDnfz+lkSLxMfwpINsrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycvlcv0f++1J6FnOCBxziW/v/y8Q47j5L6dIIaLkKRo=;
 b=lj6pInSpnbyO20qPt5c0eLtVZmKhwCZrAwxd5hZrBLesj93R12taQ7o9s3gB82lLBTpYPoIh8tzq/yX4jeWyKxGq9TLot5/54KRPauJbqXud9ev6qWuDfx2ur1ybULqZtDXhV2NdOSQO4j8TE/DSwoGlcUsTPs6TED5692byzs+GdIrc9KE1veQgcO8qPCdNlBKpZBXNtOmRprKRJLM7lXYkhHzMHdJXdTgegobhSsLpRAJJtb3lVfJQyKS7kxGyeWydGariSFdzQKxkSstvm5D1wN4wtFXCesKlH/J6x2vE195y38x69p5PbBN2ZZb3y0GxU3CF8I6PzuitJu95Rw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8123.namprd12.prod.outlook.com (2603:10b6:510:2bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Mon, 29 Sep
 2025 15:19:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 15:19:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/thp: Drop follow_devmap_pmd() default stub
Date: Mon, 29 Sep 2025 11:19:29 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <FE3C99C5-08B2-4D8D-A11F-6492AA67D739@nvidia.com>
In-Reply-To: <20250929104643.1100421-1-anshuman.khandual@arm.com>
References: <20250929104643.1100421-1-anshuman.khandual@arm.com>
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:610:50::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: ea538d04-e8f8-426a-f5d6-08ddff6b96c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k8ElWqebBAESiVuXFP1lPO6ChQRlOCKzmurG5Ri8TWkL2MjBYZzrP4x06E3h?=
 =?us-ascii?Q?cvvLri/BdhYWL0/xOUrfDFr7CfC8qE4Fr9m5E/P3HphJ27crYkz9reQ5iSjG?=
 =?us-ascii?Q?hiJoW21xCs3bMnZFfbnh+chhbEXriRfLCxaS2bny5fOrykIJSTa21ldi5rez?=
 =?us-ascii?Q?HoLGzE0VetXNnBp6khYwQJp8go+v7LPHBOvOd+znqaQhXwQ/1lNd3gc5r0Do?=
 =?us-ascii?Q?hdIo6Dbs46Kar6tkCg7A697UXjMYycXFt7BeLiq9ThPsKM7NIR8WILYYFH9V?=
 =?us-ascii?Q?61aLm0C/h8K6ZQOyDk9HO2xG4wTa0zo0OZjjiZxuNM8bQkwqE+XUBDvKVihN?=
 =?us-ascii?Q?bW0/tr3pcsbUGIF3JQgiWWGfKLCxoruXWud2Yl4xKzxjYouLOFu9ObKfczeu?=
 =?us-ascii?Q?WFHOKZ0YZzwB7IS1xEesqVyn1xwdMXrTO5GdHPvD1s2UDVk2qejh+6SjRTYc?=
 =?us-ascii?Q?jQyj11nsKwGvjEWfBVfhgqzuJNr8/Pw8JyhCEfu8VJL7yX3smHmGUqukQG5h?=
 =?us-ascii?Q?8dWlzCAKYRqWdd5B4xQDMoAlIgNWM3Vevx4SRVLELHaCsle/Ol97v6tl+Sth?=
 =?us-ascii?Q?+tDy1a5QCw6VqlnPNQOyierjrq1l5/xG/ZLq5ohnwM/Lcf4ZJ2DDXNZr8UnR?=
 =?us-ascii?Q?ec2iu0wfWCvY/jljxryGLeTo5Qs+9/AeRwxLCzaQLUL0QVhqX5cbXWIMy7NA?=
 =?us-ascii?Q?Krb5mpO0km8iDAyYht29XY6dq+HsCQYEgxJODOm2iGrOWuvtsoJ87wSM23MV?=
 =?us-ascii?Q?J+uSqzC5Ro6Y8IjQSuf++nuKZI3Y/eX/L2hwikmAOKdLrA5sB0MGD64ODxRl?=
 =?us-ascii?Q?CjXsrUitPMAABZBtTdUeXdVWKn4KfkxBBFgoi3uVJ20uuKphrA1Bn0PZZnR/?=
 =?us-ascii?Q?jrdSKirnXIb6uyv5HZdbDO38Cbaay8Gcf7ydYxbeOcZ40dziJaZ6E81wfirB?=
 =?us-ascii?Q?P4rnliMuygOxKtrsGCWMmUpADb/zUVe0FJ6YJZGR7gMKTVhju/zP2ecW/YAK?=
 =?us-ascii?Q?NDedbIMXkS/mg6nwPcYR0Bwb9xxAmKU4+D3RKLJlbctR9MY+IKh0mbjrRgDv?=
 =?us-ascii?Q?7mCaVPqaAw4NGm5a3ceRKWTfuMtBNQPVlSwWCyjS/F6+AolVAQFKGnh/rnZO?=
 =?us-ascii?Q?cE0Fw2XziCarfY234rGdcEKfKQu4AVBJ8/LHDIUA8cG6inP3z3UY4NzaZurK?=
 =?us-ascii?Q?bC8MNswuAH7j4c3D7Gn+6nEvscLsfuGu/OcOTS+3+zMpRQ8S/3GqVCkKHi7k?=
 =?us-ascii?Q?wzKASjEQD4qYpBTWXnTAXXGxiONpcI3QqgSwQcvmuZzZkFxyX4E4ADj8aFF+?=
 =?us-ascii?Q?vBp7tPC7C7lLh6z6rY/CGbvk78vVEfU2xnuxclhQfE2JCYbomb5l8o6cJRm1?=
 =?us-ascii?Q?UBjYQ8aA+f4I0eoQ2QYXgEa/gnzj1SXOxMs9MHzNkz7Zsf0pvoQ7ISxhpUvc?=
 =?us-ascii?Q?pcGjF/HGr3qwQW45R+W4puB8NclW29PL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cCVhLe9pyG+UbLnLkKL+pT+3gTE3qCunYiQQRFgf3u9VCKO7BVSpQB56B6Zq?=
 =?us-ascii?Q?OBgCGUYaDbceInYhWyQauCnTko5qBICxSn/UNaqbYOUO57pS5B8r6EO7n/Hl?=
 =?us-ascii?Q?tGtbH0RG9yFgM3OCYRTlVL0wmlvUhSYBekqSUXgcPfF95i9bprNxvJROqlTL?=
 =?us-ascii?Q?86XHHmOOnXDN7vEzxWukAZdXvqf4+8wYn5dISSe/tRBvy20Metyu2o5dc63G?=
 =?us-ascii?Q?mLzXiWwsI4Wfo7Xue+r0cd5mPLAp7YUQIDXujQdZ17Qvp90JoIRVI+JSsxmq?=
 =?us-ascii?Q?Cz8hqnBmuxSHUYXS6uRQ3alOLxKNOeFl7NoOJBe474hUxZ31NfQNLKuA5X3n?=
 =?us-ascii?Q?dZ5+Tb9EWTKs9ZgR7ywCgy/0l9uGLidYZnSdOtSnPU5mAzgk8SBRLz3ItsWv?=
 =?us-ascii?Q?p8woBKPJWDKnWJv+ZEEfkQqyRdYh8/t1ZFHFILSQeUZTroPWHuYg8V2WeEv6?=
 =?us-ascii?Q?rcnHC506Mt9EkdDufAgZa5vM5on4guF5dZArBXU1gz7UVwIiimX9DpWrrWKx?=
 =?us-ascii?Q?eo7Bo/JYyq3RChytU0gnqD65oZaRvBjsVWL3u18HOzxtznOxbJA0ymLEp3Uw?=
 =?us-ascii?Q?7SpqVd0BWlXosMrON7+EEcmJguLr/zj6TOiI/1NXpvyF3vmTR744TgcvHReX?=
 =?us-ascii?Q?sOMMFSNLgnNO1/yVwmBUOwv7vZwqdr8yMRGa64REXjb1ri6Mk3/sVaWhFj3n?=
 =?us-ascii?Q?BEU1fYU11LhtUKPXwqZ2ODpGv630qgiHazhVtH50P8lEmTwZtNwKj7HUFODX?=
 =?us-ascii?Q?Q427FfwS4tlOKuVwW9teLMPDXZiAUCKbmfMd7+j9RJ6FJEZSPDCb3+s7FRIP?=
 =?us-ascii?Q?AGlDpMWk5lRtZXX6HdlMdvk/A+6foEGcGlzVYpSjZfvFOhGO/NuDHWhDuGSJ?=
 =?us-ascii?Q?tl7Yzz9ix1BiB0k5crIErflf3rAT9vVTsJ3kO6PsYWYqKK5P7CuWz33WB3wu?=
 =?us-ascii?Q?woMYIR1RVm3Ld2jAcmaAu1iamQ3IS+aQ33rWeu/+asK5+9W1Bpww04a1vRJ3?=
 =?us-ascii?Q?iaCmUV2D9faWHj8+I4NX1rY+82IawSQOYjt2D6/K/D/rp8EMZOzDm5QK6FLU?=
 =?us-ascii?Q?ysVr/KHJuk1mODtuZ//TTtLcSUysir+zb2BvCifYimRftAEg4vMcPfTd7bQz?=
 =?us-ascii?Q?5l1tdXXOfKaQ4pboXVBxuKZauet1Qw/XXEW4Bkt4hGXo+c1QHz+JMKYPd8ID?=
 =?us-ascii?Q?DH+K60Q1NwkXUTJVsLB7oZZVHmL8Jyt88pYwRTZvarGF7FDGidiCvbAK6ZUi?=
 =?us-ascii?Q?84AzihkRgCL3VyHDSgcs4Bfz34ZTuQmgUV+DGjoJrh/2PlfOQkAPeWZbDaJ7?=
 =?us-ascii?Q?yB7vxf5HaASp7ePNFfVoDfbB0bU34I42BTSlOZrC2hugy6LkFWZfzF/J6amH?=
 =?us-ascii?Q?9K4ug/ljqrFiGzs50CQOh8BYKUlyTnOHqszAjOfJh6pN8elu8wSw+v1evLpk?=
 =?us-ascii?Q?Kfon/sGtPmMOOPRDq0wAYaJmI0vFQEyG7rzBu5amQc/t6RcRkK3FekueH3t+?=
 =?us-ascii?Q?Gk6c9xNDUgRYAhMqPuzIo29io2timlN0h9bXdCRddhvJL4eQ7Tu3EF8KFs/b?=
 =?us-ascii?Q?iTDiV6DLcRqqWzGGnY/0I/+TceMV2u3usBNF8o9N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea538d04-e8f8-426a-f5d6-08ddff6b96c6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 15:19:31.4320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fv2KyYkmrwCOCdCa0Y1AS918H0Twp7OxDBFjh72q+3UZDMOYq7oVoGoulgYD3MEX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8123
X-Rspamd-Queue-Id: C55DF14000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mrhkwh4eni8t46h9sq9rs4bdbq6dwbta
X-HE-Tag: 1759159179-887524
X-HE-Meta: U2FsdGVkX18srt0X1nHY6SWvttEJDlCGXyaEhpTD5ewpl1EUugud0NDDqZ1Gc0b+tc9iTqUI8JiNCvFXVKlYSU8N3ikU9h4tlr2R9Ia9pUCqMB2vf/0XdZ1hPdHwMP67BL8gg2vMZInf+30iJauBDtnvA3sM3ALCr1zdc2w1LUf5e5TCHjtZgRl6B6V1pobankR/kYO6RzVf+LeO42ensKS5E2vwh8qL/SsDA7vb+jervk1x0GBsYoAPkf0uDqIZZRhbOg43tJuqIZ1xRBNIi0kUCayehljKMLioDU3ZTHiMMzJQK5NxEPAwjWfP3ALqXF/SGVgAQJCMXFB8X6iqc0aYx8lZCcBtGGLw18gF75PRXp/1dSw6ccYbVQ7qzZQYxLRRIxfpGD0yVJGckSL7cNoFf5hWAQ3NaPacExLnpDFHETo8BJrXmg99VQ5Zd3RibAP1kYA2otEV/TtSgkIqCIMg9oq+sYieOc6He/BQpb5BhU/6xZB1pwEqtTkrTQxtVf033owfzakVzbEEyL+B3+5AWZibQVNSxlu3esSqfNDsUb3NwOHD0IVZwCXs7tljpeGgZbgoGmmAAiWTbrWwN9MEnaAl8Sj6hbbJ3wGzijTGDv+RKl/A/ApDWPPhNHoloulHG+1FufR6CJZ/xHxo8iRtBpX+WwyJ9AD+DEaQEJ+CC3G3Ls8Sg6ueTLmrmrjCKQCuoHNvtGJAPV0sWs0/xHK8fdE2I18G2kJCfhnHut0L/9Frg1b3DpJBDmFVlYkiZ8AmFJSJchU2uSb/06hXwITp7W87Rq5CYjeuYSG8nDtgiXqIE8+AYxbYX0rgN8L4Na/XpekqCKghNFtv+2BDI1EQUkHWQUla6/xcTEMo/BMjS6ev5yyGWlfKsnZdIfxrfigK93Gp+NH1pKc2CSwXSqZJLHRS6MtJ19bMIT1kpAsfQ61ptzh3/8pDqIowctfK/RGy3KwKPhoFR02u+Nz
 2twQmfqz
 G9crlQopWb1tDtpdJ41chjlKwqL+LZZGJwv5B5fnYoG08i4D1YzguP8s2KWw2qhhO73H/ibfWYIGqVCyMTutV51u/pK9Hhn48TbegeF/kcmoqpxhuSMVBZazouCYdwEoyWZzGNWODi4pnn3KjaqC2iXnDcUy2M1LbK4NvqE9UnqX9CYNsjhqIRxWNEXRUcv3bws7aRYHDQned6OrUxKm68CcMagYrY0ut6p/6nmk5esPpeNdsGEeSTn8iB+1b9i6h2nJrpci7FyRiUZU5pOoHkJjUnEPTsnG5K6fSzrEV3lEiJgwrdqiSu8tKyJX57KsYcDjmnIwvSyKubYsrFA26bwyurnDJDTSzGtCXgPslDn0OVb2UuBQaExCsiEPxWe7nD9QCylt2zQxrqO1jqsv9fMT0hrEq47He7Cc9lxfy9xqQlhQmgG8i8FxCd5D+vSVv4Z0B6Z61IR02UUttTz6l/qGuHwUuXDFWGych3CqJY3sP1oigdLOKn5kGX2IraBz/BlW/G1cixAlu0BN87ENvTAq20MhttHYSgQWxw5Dzl2B2i/dHpxqzcT8Du8vbPk0eqrUDh8eHfrgXHiqgG8yr2ytxp3q8RESJc6ihEOfHDC49oNpweCMlSJdtPcD7WqG5bmxKEra1RL0Aoj6URSTZnZEi8JvClACXjLgLe9wJ8wh/iDGDPDzk+dWqdWvLBdKL7MsY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Sep 2025, at 6:46, Anshuman Khandual wrote:

> follow_devmap_pmd() has already been dropped by the commit fd2825b0760a
> ("mm/gup: remove pXX_devmap usage from get_user_pages()"). The fallback
> stub in the header which is now redundant, can be dropped off as well.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  include/linux/huge_mm.h | 6 ------
>  1 file changed, 6 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

