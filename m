Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C967F3ED67
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 01:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE2A6B0089; Sat, 11 Apr 2026 21:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38EDC6B008A; Sat, 11 Apr 2026 21:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284766B0092; Sat, 11 Apr 2026 21:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 163896B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 21:37:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9806013BF13
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:37:50 +0000 (UTC)
X-FDA: 84648192300.08.13817B9
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012010.outbound.protection.outlook.com [40.107.209.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id CBA8F100006
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:37:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oJwkbP6Q;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775957867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RO45sYd6Yll3sX7NPzk3T8bKiDYgTE1LYxWhPE0z7Pw=;
	b=IEWwV/3ncN1TuZ7fR2ztF3oOrS/QvObBeMWBhLDhsd5GESXmSTvT97NOR9scZc/fAc1XGh
	OAHvOWSe0LNBmpdEdcfo5/efKCIHhWdCWT1mfiZqFjlSpfLkPzvMdU6M9dwXXMlbzEs8wi
	CA3ltyeC0d9ztqm6H1DCL1bUd4cj5BE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775957868; a=rsa-sha256;
	cv=pass;
	b=RXJmLp174NkA2poaiX4fI1cBeu/dnkVSaAwYFjYdSbW7aKhcyD3vuLQ+7GjhahRSObArK5
	tfa3j9VrkOXceCRzlOEiWlp3DYZzTkHMUP352tju4WmFuthKZTDUE9gqKS/DU4E2hWEm8r
	WM5JSCsaN49Sfjd2U/eok+eVFz8c7r8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oJwkbP6Q;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tKmFFDICrgmuJ6mKnqB6nZK1ITljHfQ6DqaDZhYtWgb2xKKXYPXcoYAALcRq5WTQs2jlwuLDkwtS6TnhDk51XnDyJFrn7ZIyrSHCaz5PGd2BeAR/D6NoYQxWC2fJiCyRyo9IlBWTwrDzT1G99gAHafdLaPMtNNda3IMYSJqI87RaIX7QuUJRuoCUbFMBWlsJ0t+59juo69J230coVKZPOJitNp+90DOX5FIAtNRZWo+Ho+YrZy0L5lE2/zfP0kBQlcv6V9dKl08KVkkxPsgY8MnzNwghQGvipOwEpYGWYnzvYmnJetIsi92HbLsl+q2Qtm7tMa9CwIX99I6Gq2370g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RO45sYd6Yll3sX7NPzk3T8bKiDYgTE1LYxWhPE0z7Pw=;
 b=w3R5cxSrtU2GRT4ISUxDy5pTbrlRrJUNyB7/TUm5YYpx53w1gPwOuMDdZVHqm+xjIPJFS7bEgrPjyAGuFXl49iOVZc9MHh6JpsTuoHt2x5XE8fN3w+mCZv8QovxjI/6IWzZ7T7k/uE0QEqMy9r1F4jHz/gJgQmKn1kzaiSFtEclFkEIFhKRWNFIEo0f3y8/QUcS8h4He7juiGGM0fFabQ875h3iqN4oV178D8heaBnQDVw7Y1xXVD7xCQn3Kr1XNmGHoljEBVncMv+0Ea5vQj+WgDPwFC3arSSUODFziybYnJ40YFmPe5mc4HEJcBExW5sqYzHK9RDOrUibpK1o76w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RO45sYd6Yll3sX7NPzk3T8bKiDYgTE1LYxWhPE0z7Pw=;
 b=oJwkbP6QS6Hkmo+pBZ0gDH5L8EL7I7q343paTzCdk0rYal3l/v12CVKXTZ4u0sKFQSGRB4dAAf5EnV8xmZ8tM7baAegroeKFuR3tvI9aV682SG7JOQChpFva8M6rj3aXBwrXvrfGNauGf9qfwDXuj4mmlkFprg3/IlQWdgc9qucxv3wWL1c4C22IbmAF91qYEPYlMRK1wVZ5jOesO3D6YSFWEG7rJDDMfdPJbXuuJmsOX4LAijuXpApCkKXuf3+GCSN4yzqFchtNDaqOPFftrCEDG7MjSjSAbIjjFLFQcpf0Jv7PcHgIFi0cXLDwoC2zh3+rCAbk3A6BmNxwm12lvQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB7709.namprd12.prod.outlook.com (2603:10b6:208:423::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.45; Sun, 12 Apr
 2026 01:37:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.044; Sun, 12 Apr 2026
 01:37:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error path
Date: Sat, 11 Apr 2026 21:37:39 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <5D47664D-8997-4A3F-A4FB-08144591C5B3@nvidia.com>
In-Reply-To: <20260411062152.2092967-1-lgs201920130244@gmail.com>
References: <20260411062152.2092967-1-lgs201920130244@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:208:256::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: 56390c5a-7565-4a71-602c-08de98341634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	GO9m6xp7D/u+Cgm0Ggj8hqKKnBu8/mwB3Dv/Al/5QpWzQNgSxnL36biv4edm325Zbv5nxuZKdM877UQeOUTHwCSeA9zYaL2jrxRTiyYW3eExy1p/eSlI3JFSYH6w3E+fTC/aZzoGA3FWWufhqlBXH+9gDtJYUMLIGV8nvoD5ADrao+eiPAPdtjHOLW6xFuGOCplZNr/FMlzhBYYZIJjqWd6WckWp50Pg+vsHeV891V/NBRDlqzQS7QF1I0hwI2bC09GmBkZN+SdQoPY4JkKG+AOzJjbKHm6bpvOAp5E/7Vmx6LRfX98fz2tBCAcb/WlAm90ip2yi6M9NVukAKlWaTV8hFtbVZIiT9rxuKx2itcPLS4Qoxk9xDYwtfu1308/iyN4mslzhf/AjUMoplFxH8CWzKdYbLzLpPZVb+7wQfRyRiJW4lM8ZP62/sWEYEKYSSmAx0Q9vwSInUfmbDt3DpAZyCjZFmxLkJJJjLZ8SMjpRez8d5NP9v6LTsZTnX0RHgdDKWR45jRTHCN1kNLatdklMSKpjKFNPeahnc+0LYs+1+AxrQ1HWRbMFBjcMQ7PLUC6ZpHDFj9XbiAA48uCZaQIssJ0ODq3espR+XkviLBiqiAK3A5eILBj2iPimuNgmMkiNpGZumk/2K/5m76f1DUy2Z0fLFaUY9dnnAgDqexcV0fHpFT2tirNWfytMNOVC0cH2Rx7gSoJnrQI9ISJ5aNoZDEDORNe5EwIB07PoQJc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JaYj5BDFXVvAu9gQtYA6uOlpNG8HWWPGT/q/aEOZYR+W9yIe8/uG87W1pSl/?=
 =?us-ascii?Q?Qqpn4tjnsAJUYj4svrHhjdOuKyMJZdNPnDUuxLCf98H7b9uox/l/cD7UjGnx?=
 =?us-ascii?Q?Gj3EzN4XzZHoW6R+bn6I2rR/ByeeyU3sPgp5ShIezYR4i+yYC1DdMYN45P5Y?=
 =?us-ascii?Q?S6OBubpqAnP3eBE5+2ONufSQb8daL6UP+LNed8XaOExLzb58dT40Zq+uxN6q?=
 =?us-ascii?Q?P4HEqLmo1k0OJqkTjxLh1T9O8ZOPUINiFh2zVcqXI6tkQSKT0QpGhY/OUaf/?=
 =?us-ascii?Q?iyBAFbOQsEd6cYVLe8JxN05g3ESTel9F3YCvBzHahPF6tyYwLAkIY0mtnig7?=
 =?us-ascii?Q?fWb7duaTvP0sAPoRXHueP6kcswXvymRl64Yza8PfTPnp7F1CqtKzUi7wLX8o?=
 =?us-ascii?Q?U4EfKTYvZkb+B+1NfQPFiy+iqs8ZxJcHuQw3fEqFoHlvz76CwEa23Ii8B7dt?=
 =?us-ascii?Q?gVtvMwHAmvpvlzprKfQlqS3MA2xgFHpacaUcomht+du6fXnTWwbqKLRSB2BX?=
 =?us-ascii?Q?QjHFCd2yv4PYigAYISSZeLxZpmabQNtBVo0EXv600W/HChkad3oozGATt7Y3?=
 =?us-ascii?Q?dTErvY9adUsvQI7WtEgMM06nQ0dJBZod0yXJ2+JRUEkdszsitzqOweLcWUif?=
 =?us-ascii?Q?WRnuy3DS+UYRFITKPBb89q3All39hJ9MSNH8KvW6M5Vv5aPhG8eCENHwCBV+?=
 =?us-ascii?Q?DYv7vtjcSlN+Z/75g56j6um+nyIS3z07di95hhbHK8OW72KFzBxDXeA6moIf?=
 =?us-ascii?Q?32lUP2NgECeyuDrB3n343YWpKZBcFaMEXwldhXFSrit/xpGlsjQuffNhzf53?=
 =?us-ascii?Q?49DhQSBPKyEptnx3xC+ngLOBZ8ftYoJrg3xXJzmzINWDup07tKjd5/j5Tmc8?=
 =?us-ascii?Q?UUP5WYtufe0rPFRt+j6iES2gD4DyBYi69UDdn0zI6xX4VWOTcH8TU0ik89LZ?=
 =?us-ascii?Q?gCzVUCUuxJeKlU/vsjXNCR6fBh6V+ml4I/x5dV+q4Xmjpcd2xJY1Y+McuqY2?=
 =?us-ascii?Q?N6innB1/+6S3f0DArzPoGtenUTEYpuQw33bxm2zz0t7rW2yLekPVOwUn7s9q?=
 =?us-ascii?Q?A+igsmaZFZ+ZOSoWiBWtgNoAuQJmQCcC3DhC7ApENJlEVL2p10h1umJ+c85A?=
 =?us-ascii?Q?B56jrg5dquialnQgdzHumQNdvFFrqWzab+AcpvRyQmaRuRIMBcv5xln7IPc6?=
 =?us-ascii?Q?ANDfGXUheCjdguOcgEoYFVYHk5+Z7QKKvp1Mvi+FjM4aktlenwS3SJfdV/6j?=
 =?us-ascii?Q?sBFjKZI8juRhmcxBLP6DPqOOSVn/CBXitKu+qkrYl81GQGLH7sdWJ6y4mAA5?=
 =?us-ascii?Q?Z3VvXDEqzQvXLvscbg5r+G6l0Jss/qc2QNXMiJKs0AmvCC28wGPcLCuaiVct?=
 =?us-ascii?Q?2QnRiWD7psaEUlIwi9bkSkTfVnFT5PmPWkJPfJKflFZi5tajfwiT7UUpdmeQ?=
 =?us-ascii?Q?q7UWcEWe7KeEVC/rTb941LxaR53ajBRnKHaUcnFw2y9CTEfBuUZz3+Kt7pLO?=
 =?us-ascii?Q?XjVIV8E2YykTkKIG60f2MbXdgt5YRCxdRkpTLdW29qcrCdGAa5DfwZz/26NL?=
 =?us-ascii?Q?KIShuEJUSNA6IV9aEkS4AaFjyZ0vy9+HgbMDZZ2uhuuC/RXXbz0ZmDvsmJxy?=
 =?us-ascii?Q?R/MVyxrli3+555TX8mMaCP66MBevFLWd3sbpMYVspNlqSd8oZgEWZhCJ67Ry?=
 =?us-ascii?Q?loG0FyqqKMvxsslA4VBTfodfxsbmcJFRJoTbHmrqOhdsjUyH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56390c5a-7565-4a71-602c-08de98341634
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2026 01:37:41.3272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IrZX6Bi5/ia6HZIXqnJ2kzOVUGkr2YlXUGpzv8UyNlwBUyd15pse0XQUWxrWA684
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7709
X-Rspamd-Queue-Id: CBA8F100006
X-Stat-Signature: esijikarg7rke3td4as7njuabidg4nqu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775957867-62192
X-HE-Meta: U2FsdGVkX1+/e6BSFyJWeCao3hgO+sV9kMPghF2MREszHepqVqzMJxkMSG4EzpKTC15HsEI11qYki8D/Y2l677gKIuPIutfDCyYjYZP42oR1j6aFUpLySaTwic344z9JzZVgCBVNYiHBr3oJPvD9uNsLThAHuJHYAU2toNwSVj+mCl7kUoqTvh2h3q8q6pAeDvH8yD3L6oo5fdBJkzsvP6KGmKYJLUsWpWfWZDfu5K55WXlAFgx30MjkpUPQ0io23o+nT2ZrOTj+6+JaIlRwBMTm6ePXUbT/PV1aN8xTRknnodu7/sK+y1WvSvCkWvVd+1/fdEyl9CDediaUTv/S9bdOd1ZaAUajzQGsOcODtbkMpnh1Szyex6126XiA9sZESn/ov+1xm/1XCpXK0oP82Mh3HJZLsT9TxT6255Rtih5Adc+Exc0cpa2W+ZxcPwpeQIkgjfRZqt4KK/xM+fNrUZNgMQUoB/jl5r88CVYB6Ceej0o7xrmB+unm25FvGJ3TghTLLILuYq6mvmM955piX1xPnIU9K18QlPFe6XREBRbZRuRGZzIAO0Dltfr92Du3A5hVR8pM+WsOWWemq0BtWF37QQu/Q+8N4FBRY8q1VIdfjacCVpX3QPiKLs+zKIBgVyBnNCI2xByQ0NYfI5SWZrtPkxj96w/yh9k8gsT9qop+YQHDkiUrkZtot0vswNZr4vCjUQFugsTyklwDEQVYyTd8vT2VHvSD70Kt8xsjC0RBDk97XteVhQBVbnFzaVyWCDpk2hykgghys9aELIl9SQT95XUFmwKxDN6ajVOn3QRVnVlgOp5oLjTqD2mTnMzIN2vVewj12DM66d1rZyr/DjJrFf8Cvk/CVM5kvjJnJvP0h/i3o3DHQMC+Rt79NOL0A1ysyEj2mfQ49gGQo6nyG57QtC7lIc6LWQFPaOETzAX6g7b9oNq6Rb/0TLSKJjhAJtpBehVPHx5qYo06Nfu
 NjBBwqje
 bG66wSWl06uWIbVKrj58IMKVHzwFSDrCW1gC9RfmMRtVT8/lOeG0KJ3eSAKzHkzMZT3FORU+cj022hGP7WUoud4thuB6Q7pNrio1pXF+cDW/1brlZLFz2HkI5RSXHrRw2Pr88lFAbdLOrtT+2CpU5qHlJIKyLx3Gwkg0XC+1ub0vbjzbEys/5H7ywXETg4cdY1RVuVDULjkyeFG40C5sPim9IhTxWYkyaZ8a+gMA1yAkDgkORNpqRy5tp1b9bkCsqVEQrCe7KzoXny9GGjVjgbupQ5RQwUoJJC8TDlFbNh/ygDyKuUya7fUZnGP3rcFGkRGx5reVDN+8HIqUOm5xTkVmeCAmaVBKjRxnmWYNxEmUhpQz5Dz6B/H8MtLpsLdq1dyi02Z/vQDvVMO650FCFuv4OlNpvhhgKe3x+7+JJUkgwPDB20cKTWfsrHPMrS43ouuIb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Apr 2026, at 2:21, Guangshuo Li wrote:

> After kobject_init_and_add(), the lifetime of the embedded struct
> kobject is expected to be managed through the kobject core reference
> counting.
>
> In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
> directly with kfree() rather than releasing the kobject reference with
> kobject_put(). This may leave the reference count of the embedded struct
> kobject unbalanced, resulting in a refcount leak and potentially leading
> to a use-after-free.
>
> Fix this by using kobject_put(&thpsize->kobj) in the failure path and
> letting thpsize_release() handle the final cleanup.
>
> Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  mm/huge_memory.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan, Zi

