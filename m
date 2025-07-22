Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB5EC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380FA6B00A7; Tue, 22 Jul 2025 13:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358726B00A9; Tue, 22 Jul 2025 13:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21FDF6B00AA; Tue, 22 Jul 2025 13:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1569A6B00A7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:26:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7D4FB9AA5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:26:32 +0000 (UTC)
X-FDA: 83692579824.17.F908CA8
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1FC0A100004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:26:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EIb6TLQ0;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.81 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753205190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Ho7mEGzE8qh5/5UFBZ5GGrNFut1RxZgpAxrnn522YI=;
	b=xUq6bNkQuRP9fx5bcQO+ybCLyYivTHMLRz/rgrs6X6lhQHgzN6Zpp+ll7S0vCbHGJAzCS3
	5qrpW9J7EIeRcICpGOlVZNKXj+lhQzAthPiyPedNB0rluFA4ZwnSoxaoqDWdayyrmMG6IJ
	+dnBcLVTL3eQQ+AZOM4/itG0Zng1JE8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753205190; a=rsa-sha256;
	cv=pass;
	b=cWb1fPHkoFyxVamPRJR8PFK92Oka3oKCLaHt9Y+GX8LTd+ga7V3IAFHIUbt7zW8m0QBjPf
	0a7MjnFrWoFs9PwDjewdyoow4fZo9uo4rCCl43wC6XsDhD91C0uqYLXsRGQGL06bYcTiiB
	KIDWYk0KOERnf8+PGscsphmAXMgLeSQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EIb6TLQ0;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.81 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPTija1haEPhHvq//kFz4zuhTIhEJ4jnmFoTjmOZpl7458K6nrRpkz4duZ5iTvsy6L/+EfqXcFO9Vec7YllX2DtesCKFfc7uhEU5EbYWAZu4+k17nXy0kjiyQSIq2BxSzM7VLrtkulpUOxznA8plL+FuBy0eVxgUkSd2yWyPXYNdd7XlbIXBAay7W7SFogb2VklGXMVan//fgJnBnaiPW9mEtIGwc7E7qIbOaf4ll/YjuzS4kde0tLGVGy7qIspUeqWFap98RcikFsL5P7I6la8yGBDC/OnVg7oKjFnZBmo/gTE4s+TbJLvXRDyGkj/k4MLWNRbbaaypmvFJw4ZAJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Ho7mEGzE8qh5/5UFBZ5GGrNFut1RxZgpAxrnn522YI=;
 b=hCrflkPwlf/q3vuMJBJ/lttheMiB8R4gMxyE05JnTznuJ6NB5twxJmSNkOwVEla5yAELMr1pOIcffTXd2qRXDb4+Fwb5OkeKLcCX8uR+j3IEiHLOuVmo7o90RSZPKHiBNa2JAbSxMfV4/Kl4EvrbYIcZ2aRumaPTnvc0vd0RLZBDS1+1LyVAENzeLmILiTjgll20t1GKGNsejFigXu2r/D7VKF5nErOjmRRcxm9QBSk+x4BXiknJWXk1tM3tFYjJurSESTkUyr5RS+vW064nFZNjnxD7hUkjhw4U7PwSZ6LVsbo6/DtEVL9lNewoY+wb9Vw2FG+5JIHugtnH0/Bl+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Ho7mEGzE8qh5/5UFBZ5GGrNFut1RxZgpAxrnn522YI=;
 b=EIb6TLQ0N+M5FjGVUhS1pPrLeTvZQFVTYcvQnXStOAxUI19yIgR1ILYMrvJ6311gXV/ISX56yb2J3PtOhouYXgAEnULqDCPpN7QoguRWof9vmk1F7v5CyZW+svOmDL0u+Ydv6Nawx6v9rQbfWOy5YqryQRSzL8Ktm+ffd/vjxjcAO9zyojlC/EJ+c7KnBlzo7L25g1kCSiIbXvfWvdiMVKg3uA6johXFLFQbqe/alTz8wD1gNMPzwwhAIIxw0RExw5Xp+zZa5MHngbwpTA+Y19+6PiCgR3b03QQmp3dPbgbd8hP7ssZtWN4FlSfPODmtTkIYcRTPE2cR6cmeq09uaw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4342.namprd12.prod.outlook.com (2603:10b6:208:264::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.25; Tue, 22 Jul 2025 17:26:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8922.037; Tue, 22 Jul 2025
 17:26:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add missing mm_slot.h file THP section
Date: Tue, 22 Jul 2025 13:26:21 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B2E5CD10-E574-4D3D-9C02-FE23800E11B6@nvidia.com>
In-Reply-To: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
References: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0115.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4342:EE_
X-MS-Office365-Filtering-Correlation-Id: 20b4de4c-b2dc-49f4-30ee-08ddc944e374
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j6FdoT4qBc18ZqwW2Hh1yADIjZe0kscGr/Ny9+ubOGxNCgaDluJdvTwUOmwC?=
 =?us-ascii?Q?+loz8T27WfA7ilSPIc1L8OWfHNt/v5ESQo2qnW6iXM/qgmSPMnjr2ddSJIbD?=
 =?us-ascii?Q?U2vzgLAliB/uqnptapX6xTOu9pJryEbJ/Bergj/FYmO1ZoXiGajyxU0VCt/g?=
 =?us-ascii?Q?j0u11XdvtjyVPUjuSU+djnktL1lzpp8QZKwsHrMi9nsGqIKHrZxbALaSeQ0h?=
 =?us-ascii?Q?SImmjKQHHYfMtzqF/8nXdSrTdnkJXgUHRKUlF9LGM7lrS/6fzEPJoFVSUYgc?=
 =?us-ascii?Q?W9/anX8vqcC7o188xK87gryuhZtzNc34H92UkKNoIonNobsyONyInnHHCC27?=
 =?us-ascii?Q?x3J/vPhi+lxkHR965nDTfZk582UubBBFb/OxDFfQKId4HvLVVw68sp6AMyxM?=
 =?us-ascii?Q?mbp6GLiQZAgpGCqpL9aROgGmSiJZ0oyResc5nlY0CY97SBGZTlHeoz1jmOco?=
 =?us-ascii?Q?PdVyPY70v71pF0SMBIktnNFsiImRhsrPmev/1RslC1wS5r1crhTZaB/eHE+G?=
 =?us-ascii?Q?4UpQAO7A6Uz40m6pA9BWGao0rAAQmeLV74DzDAs2xsj2vRCHGSsejmhUb5Mp?=
 =?us-ascii?Q?FEqKD9yNvV1LvVM9S5chiOqhxExUS37odqDD23Iu2oumRnwzEBogZ0lIwX9/?=
 =?us-ascii?Q?bph2QcDoYF/DvI76vCAou8HjVeXUMk7j1MDUhplcG/fqfjSwjwaQwuJoMXSE?=
 =?us-ascii?Q?iqPg0tnrnN/wCqSAjX4KR2OTL3ydFRyZOD/ZUUNVvPHYNJ0K7gwTNiR3T7Q5?=
 =?us-ascii?Q?CAldVEhn1qS2DESt9NgjRPfwejiuuggoHCEjGwRLYPFVH8O84hKnxPtdRIWT?=
 =?us-ascii?Q?bEnzrW4yT9FrCpWZSVxPyueFtkjzwR/USrhkFHInmZ5lu/rSSvFPnc2Fn41N?=
 =?us-ascii?Q?xi4iivs2hzVtMe3/zdqflcxK5n+aq3TwppB2xrEY4n8ZkDWTpzDMckzNRwNF?=
 =?us-ascii?Q?B5k/1xn8k2aFZ5sP7QZ39jS3hyi8fA9tsKGHHeI566g3pYW9ZzOZQ0gjKHlN?=
 =?us-ascii?Q?m6U+LfdLiEpWrXIgEOQ5GOcTQpR4Yrya6Qm1Z41f7czeWqnhbBApjOvqbt4O?=
 =?us-ascii?Q?+AHPOTeFQZcxNiDaF3/kUeyJOh8ytm6fnEzT4F7MvSfepR5/5htLVo3rPxd6?=
 =?us-ascii?Q?EWbW8WeY/EfJxlmdVe1dz51c72BFPw5gR6CVhXuXf7YvxFO9Je4jHdpk6vul?=
 =?us-ascii?Q?N4dfy7i31jFkwbJjGE2qlqUFJx3k8ALXrOmWAA+ISxWBrTW26SGm2ZHUqZAB?=
 =?us-ascii?Q?OD2ku1gSpY3dp1d3ZtgTa803+PhmC/BC75BugnKlsr0qwyNQJGyF7RJYODFd?=
 =?us-ascii?Q?bmmqCxWpEH5KhcvnpudLAebv4cshJ9riH8uJLQnGZMBEq78a7Z8csquoUJer?=
 =?us-ascii?Q?M/mbBWyd7ecpnnYJyE4Jqg2MsZxZVzdVG5WgSjtNo1rMqZwpkdocxIU8T66d?=
 =?us-ascii?Q?c+9tDHhir3c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wc5f4DAhPWfXSLPRM9MRanfgcAZjZC8lWfPMm2WRT2vDuw7V7JiZRbu+m8bO?=
 =?us-ascii?Q?N2xpxfILtYpITX++GnL2vyoXkf2poyUy7v+QYB3hsG/gG2rvInP1wiOpwwZw?=
 =?us-ascii?Q?n7kEiqpmEN4SWxRne/o2gJjMmWNRuVEu6TcjzRHma5HjJj0Q8Wo5OqQJ1y5Y?=
 =?us-ascii?Q?s5qCH8IJLxVxPXFtd71HH5zJD9ovXb+IP/CQLNiIK3LZ1FpPM+iz8aQNfVMs?=
 =?us-ascii?Q?jikzLdI2IynYRz7eIt/n5rDP5Axmr+OfZsLC21Xo02aIFgEl52mBGixgnD19?=
 =?us-ascii?Q?pFKJlbh7kA+nJh7X2UYtbI1KlHrIpCO4u8MhP9211RkCoP00WDWOaPdaf1cC?=
 =?us-ascii?Q?3B3Wr69Jv0mXtRbTY5+XE1Vhr32mwz3IczgxAjfFfM/ba2M/kuUr+zMhLFtu?=
 =?us-ascii?Q?5VmShL815zpkkOVkGTCtchndNUacDbP9iLPOHfOKGlC9jyVC5L3x3ip9W87L?=
 =?us-ascii?Q?Sa9Zv779yDCiOWopmR6KJk6UdLvNU7IrC+kysxKGRqQ9J+DC4NevWITP+VnX?=
 =?us-ascii?Q?A/a6i9w9MZhV/+2fKeVgJSRRcGY1rhXpwi8BBaFdhZuW4QxfEIaMQcpiRABC?=
 =?us-ascii?Q?XOtAXkIN/Pz3C0jbBlveZFzJex6QY03bMufjDRL5aa1/M7sHrX23Kba6eWf8?=
 =?us-ascii?Q?vY0RyuLsjWw/EN+Do0i4BXWg0EX5xB88Q34xuNIZ3kpbSimPtZOe7D5zL1O2?=
 =?us-ascii?Q?YC8e9CaLN18vrNwOegUIWehupcQ1QNYQoui5arJmntZeJn264wbFlpLWkMxy?=
 =?us-ascii?Q?30Ae660Hh5g9WKKySbh0jkJw6DEsqP9zFQNSdIcugM8cannEgNHKZVk9y5bf?=
 =?us-ascii?Q?SYZUqHgl5ENlbvQnCsLwN/ugQy1VMIvdulS2PE3RNyChsrcHBRT0Pe6F542n?=
 =?us-ascii?Q?kZtP5V7IjV4PNE3ofYS6ukUsy3fuajgziexp5/6ehRl7LD4ULAw0zozFAKDW?=
 =?us-ascii?Q?Q1e25f/QKkqmt4Fb9aUablhMYwkJaG996fAQ4bJlK9rmYA0CbO/JuKIpuM2R?=
 =?us-ascii?Q?xGY7Eiu43k6b5TJSDuTZ55GIXscN1XEJgwQmhCC3mrufswGbR8Q0RCydmETa?=
 =?us-ascii?Q?eJSQ+0YM5jWT3M3HF/QPrZrPDwEqEoxSIdKqOktflofeQrAURO0adlzzXjoX?=
 =?us-ascii?Q?SLveS/hWmXTlinl5DQiqmZQ7f3iRe+Ft+R4UVSzgBGM/pCElIny4vQq9Hj9o?=
 =?us-ascii?Q?OeSMzDtoKOcRHWn50GhfSs9IJ0jpNcXtfXax3UCB6lHpPxL+HFM2FImCy+kq?=
 =?us-ascii?Q?Qp9CjSy9uu6e3bQgDHLlsQVzRWa2xhUaKUjP8giftrlqfwglal3dPMVtvA5d?=
 =?us-ascii?Q?/ysbqfZMFYeBvVZhLl6wEkYB14a/fYGsDcpCzDSm02VrXfikrV2Cwa+FtNQV?=
 =?us-ascii?Q?HP9dVGKvMC1Ay8EHLdsuV/ZWld3vpHA/8V+CPfxSbw6OmWpzKlS/il5TE9B/?=
 =?us-ascii?Q?e6JPnYUsdci7miLlNo4rafHwwGTU7Ex8n9uNXjhVg4k4L4xefHIGgrsO38BJ?=
 =?us-ascii?Q?5VwMU/qomsJoyXioyE+pxWWu8Z8GQOZSx+Rko0DY7CflSS4SGeckIyMObf4Q?=
 =?us-ascii?Q?aYJuuXtakhNCfnieilkeS0PvvZLLhg/zgmZT/uHL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b4de4c-b2dc-49f4-30ee-08ddc944e374
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 17:26:26.8476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IChQHYso/qWMoGazWFqAFnlcqc56W+2FUsXyojjYcRWkxMy703OegzvvGQT9eO4h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4342
X-Rspamd-Queue-Id: 1FC0A100004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: t7tq74brrg6p4q8e14yqfxfepekax5oc
X-HE-Tag: 1753205189-137782
X-HE-Meta: U2FsdGVkX1/IKq061iOkv4SR0wwyGYkWIFJb/b9Ms1Lt4Puc4+G3KN1cu0KNGku9ndFLonFPYTaMjDRrCR2nuF9nO53b9KWfHyzjJW7QVa4GRDMOBC3+jitlSFn0udWU/iVLDT5gUkIOZSaNZ0cqjjWjDQl9wiu3imKLJz6ibl/lQH7b4E6xwBNP1tBzXKLyOVd+u+ZIZyHV7ki4QpZFrKapKO95fXrVqBCgfJDaGHzxeDqy7sJa6CjTj2d87lkdV7Hl630YBADw7nf/gDXBIvsthd+ck7r4Rloq6Cd9Znop8exb6wIFzOe0Ce67jCipXrJ2sppALS5XaLgEVcBRLQfvh0wD4jP7FDdLNNDLm71HCI2cx+Z8+FEfVmWBX1wSmqkUNHxotLzZudF9tFAW5YlaLEhdvrtb6k88oXJRDuu1ERb5VN8nCFTUveYO7MbAWHpW1NNoI4kLCpToIbwLrzoMp1cR+sLo3G3QK9PiUmoP8s3QJhKJq30pqlVkirruGEWYtp9EkdtG1AJyk+zSHJESjV2zg15h4BbxyRhm17Dfy0c7p/YeajhIxeqfQvpMglGs3jnZfJG/Urd4A6SHo4U7c1gxByq2ZVMzha4h0ydHfGwwktK7ZoCPvlgcr8WdfKSVqYBAVQpaex5ZRQ410UZeJMOxKIgIDwAH6Jn3t+9CHSUY48hzaCzoA3HWTwr6tKP864J8ggrootdcWGdLv8EarmZZY8aRJhqvYnVV1APsy7cX3VlYHoP7Klt1ScOp1A7GSQ023w9J3tMe2UwqYhUhvtbLSh0GQHgMB1FK3v3vKEuttOSPwpLcqMBR7qgSfxiPIbx0ddFsMujm/uaw40ztmAmU5JviTy9U4SIF3ftOE2wFpgcmyvjlp2/yln0pVx6Fas+UgDNjSN1H6V26PRwZoOkkYqKYbH5hT1y4vsXOOZSmMXBgUbTeKXUcZ71xG2JKLlsU6CjkbO7tdAW
 nuUHFMH/
 EoKIWyjtHE7J3Du30a8Ow6sZetXD5JH3QkOL0Rf1Gw4HE75bi9hGZ0SFjDWiSNoa24IVu5nleJWaLI8wxuE0c8lIW0lwcf6wivUjTTk7i+787KZNG8FlDEf1Yri091c8I04cKlOLNAZRYYSKaqA8sd1rTHog5m47uW1C+XmviDMeBrFMj3/5SzTPQslX3Kpa32DuDSf5hG6wyZ28FRCSdHloEeq1mtTuwuJIUvNYm6BgP0SRZ417DyGTiCu6YZWzGm6FqyJirQTxq5NgWDd6e6FO32QVFzja8VfxebZlm9Hf3DUJ+XspweO1pOOEBSCh7JGydR8s4WXzLMS1mJcsW8t80LH8kgwABVX7zklIIlXGZlyw4J2Wt534T7avJUUzuGKAioVK6HG30K7FnvQ5e1ckpjMXg9g1aLaUsSMr/Ms5WLdhDTk9GsBLJizVQndayuLTeO7MD6ctBLZs0ptvgPdstEv8TCwktnXPbJ9rDnI4S9jzxvab5X5NR9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Jul 2025, at 13:19, Lorenzo Stoakes wrote:

> This seems to be the most appropriate place for this file.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837bc5cd6166..3f83fb317f51 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15966,6 +15966,7 @@ F:	include/linux/khugepaged.h
>  F:	include/trace/events/huge_memory.h
>  F:	mm/huge_memory.c
>  F:	mm/khugepaged.c
> +F:	mm/mm_slot.h
>  F:	tools/testing/selftests/mm/khugepaged.c
>  F:	tools/testing/selftests/mm/split_huge_page_test.c
>  F:	tools/testing/selftests/mm/transhuge-stress.c
> -- 
> 2.50.1

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

