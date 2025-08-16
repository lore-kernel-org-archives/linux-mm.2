Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2EFCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 11:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303D96B05F8; Sat, 16 Aug 2025 07:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DAE26B05F9; Sat, 16 Aug 2025 07:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9E96B05FA; Sat, 16 Aug 2025 07:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0750D6B05F8
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:44:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6FD58327D
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 11:44:05 +0000 (UTC)
X-FDA: 83782436850.20.34689E1
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A2CF80009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 11:44:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Jp6/nvEa";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.85 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755344643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x98YlXfSRQLr/qyfQQjrsH14PcSUpA//NoxLajxkamM=;
	b=u5GdHvF6sR2ml9kJSw5KcOIqM5K6eIb5alpdZ4wMyYfGEA5mZlr/bYeGR84CxBoPoRHQ6M
	rVVGy873lmq2EWnoTq2k4JVeqIx5i6F/upDpKOCVDfPO3Jsp19PZuE7EZv/ObA1/C29Aa2
	NyhI2L7nV3d7AxA6RGMuaUX1TggUDVA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755344643; a=rsa-sha256;
	cv=pass;
	b=ANedkGW41D/xfoePUl25cCp+7twkRy4FOThwTf7Fl6Wo7aDBAjGL+gB0H3EucfvdAW6WdZ
	qU2x91kgrq/6BZlmZ+TkavirGF86fIqJdGwAj436VztgMk5UMODgzzsmpMKdwgD8yf53hi
	NFUJxfGPPThgXdx8V436Pefnm3Q6/cc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Jp6/nvEa";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.85 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfw8lNnPrU7yCZ0yanUSsEf0yp52p0OmBAkgecibcI0/OKACHG8wRhTERhf6keF5RQbZGUhfQSVacvdV0XsBhP1FQRgKuKeb6sqWwV8v/BN/lYblQm7x/YAAVgMFVlkdQP/g5jl4CIRNowANarZIqH1Ak8ORwPzgBib+KDORbQMujpZQfysUTkLJbnPOFxxMQK774yUksH8xBdKjvsFwOJJFFZ0dhz3zPaUaT7tcHIVFH1I1UJtpUxw3LAblG9E7yEz7E4ERR8zVtvuSvaNZcCN/R6qz7L72k4tIQtryn/ZuH6g7PHqXzY8Du5Oyj7Z1xXdoc2Dwq8hmq5w9kQPFLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x98YlXfSRQLr/qyfQQjrsH14PcSUpA//NoxLajxkamM=;
 b=r2pS8Hr2Z41Zs/XAfSrPONkypNcepncuAuHVXPqxzO5JGLxI6n/QDrux9q+P3OcpnVdVhwb/9wtaPIrnc25OdoOcSISTi6cmUlKWOOh14U+P91aH4Cdei2/8l44q1HRPEkMKAye819RqLo58f9YSeS1/mDKUgC4oC5DMhKgtE07JlY/lOYgqRO9EnoFyZZG8vRUjEE733eSQMFmgzYqQjCpaDYcn3TDrKtEw03pjZbvtiGeJxFww4oTjMSRWD/9k54jzPSPK6nZS7CVcJk4hsTApIzeFL0eYZqwZ1rUlID+2fdtOwNq8ZjPDTo+u1qlpgdw9hpek2Yq8z3EsVmui+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x98YlXfSRQLr/qyfQQjrsH14PcSUpA//NoxLajxkamM=;
 b=Jp6/nvEaDvrLAzbwFRJOE2CDzOXkFbWZbnQcG+ST+2oqEMx//nae0Ax5kb06J7Zp+K/sJftcesshVQzj3SUTHE5OHoObT5cgGTDKfA3Fo/xd8pG1guvir3nyd19jobPwZLQtP7RxuPFBxyVLQZEjNwK8YEu3/T1fEjId231Ow8DUU2j2YPXwdgiaeUXfiJZvpWbaycUZXGAOT3hGiL9t+1+GkQDQv0hzh9J9xgLNm/cLo0Y3P592M4Zpy1zU9d8fFD4FFVQcRA1Vf8JhHa7VnIlZoshHhBQid451BBlL1B+cvjmihq3tE3HLhBQ1FtfC3HdMgMdrtR+nojihYup1Bg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7445.namprd12.prod.outlook.com (2603:10b6:510:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Sat, 16 Aug
 2025 11:43:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Sat, 16 Aug 2025
 11:43:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 3/5] selftests/mm: reimplement is_backed_by_thp() with
 more precise check
Date: Sat, 16 Aug 2025 07:43:54 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <C8AA817C-E687-4656-AFB0-1729CB711D66@nvidia.com>
In-Reply-To: <20250816003013.e12ecb8f2dc45e7f934ff281@linux-foundation.org>
References: <20250815023915.1394655-1-ziy@nvidia.com>
 <20250815023915.1394655-4-ziy@nvidia.com>
 <20250816003013.e12ecb8f2dc45e7f934ff281@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0285.namprd03.prod.outlook.com
 (2603:10b6:408:f5::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7445:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eb924cf-c56b-4d0a-cf52-08dddcba2f9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hXv5KKU4BbvI9qNI6LEGKzeS0z1W8AhRHH6lYewt3p6NAZ+LnkY6XWGADaRR?=
 =?us-ascii?Q?EfAqaCKkqq68XsCAuSUH97VyxESSBjKzpiktTlAZFD1GSYGpNyT4y36guXel?=
 =?us-ascii?Q?q6gMA3rSaI5JCJq7k+MvBDFbXPEZq0CNjBbkcxIi0g8ctHg8wwu/IZOyj/w4?=
 =?us-ascii?Q?OWbP5gPkmp5pADuS5VbwoVc1271Hlf3r921rrp/Bp0/Tg0Penz6mD2M3Dxml?=
 =?us-ascii?Q?0wJAR1Tcl+Jw8+KSSqHR+/L4MnwTGLTB59N5AHVAZAkHuHN1MOlefwTbQQTf?=
 =?us-ascii?Q?RC5d0wOz42g/gnZ1JHqEE90Nb2IMBxan1q+l7Zs+zruStVW7Kb4UUsIyMTIW?=
 =?us-ascii?Q?gl01Ct47TE6jFIyaGwlFv8GEWMnXLWH1oISU/4xfwxihPLA7LdOqi8EgVXDf?=
 =?us-ascii?Q?tiYRcqDRDHAIowZPU5f6eEYqMXafRJgukX3wqqRJf3xFOO77hlnXi/TPHSoE?=
 =?us-ascii?Q?f3nnz04At3BGOg+P7jFgMKSVLh+kXt1wxdPQhvijLL228SD8ys2GNH/2I0b3?=
 =?us-ascii?Q?t5k07/0rY58QpYApWXyaXtdeZhY6OboggqGLXG09QYDVUAzY7u16GscnWpTN?=
 =?us-ascii?Q?8Plmustiby8lvBEuivTPJEcFHJAdls2l21kRoitLLbdN/kT/k+BMzTBtu1X6?=
 =?us-ascii?Q?OgVVEZkPwptsSi2YCGdyDcLwaGe8kAn8RwINCXKa0CfWRbVdt2l3guQeRJgT?=
 =?us-ascii?Q?+OPy4B9rzMsJHh7AeVAm2tgAg3d82i5qSXCtANwdOp7z11UtQjSfm5uYLUeP?=
 =?us-ascii?Q?S4WjpKXIdJysqEKrfUHXHCqfQqy3wg7aoGBTxP5O/FTZuilDaOhoWZTVY6of?=
 =?us-ascii?Q?e/E9S1YZ+pnjiTWZSj4BRU3mxhC140tvEHVZ5WrybsNHrwweK53thzHHWkOS?=
 =?us-ascii?Q?JGDs5w048cIm+x8NcDDM2D5ra37NWNZYqORCsGMJcAx/cKF8e5MQC0qglbX/?=
 =?us-ascii?Q?Y2L9dFkIHozkzSrdkAV69FToDUOrXOpw814ipcdRoDVkgXA68EMqPHTkfCES?=
 =?us-ascii?Q?Mu4M2G4d73opawTHZr51JxJpcoIv+4UHah5zPwGyU/YJGw4pazCM0psZuuTJ?=
 =?us-ascii?Q?A9j+HM6j8MTAl6MWU+XT2QhKQIoHwR2eV5Km3r8XU+/wLwTWKBuOh6q31cr+?=
 =?us-ascii?Q?0ky0Yg5JG1idvIaHNHMUjxEVbRjqMzZuTKEKPHhzVXgIDOoNxSfHs5pqxWcM?=
 =?us-ascii?Q?6RT1tLVj0QLEPqyPgVNlQV0lixYkw8fvOX3qXyfYDvkQY3v0FkvIsUx9Tb4L?=
 =?us-ascii?Q?6dFM9+un7iSdtTD2C6y2lbe+2T2tjFJ4CNGH7OZZooxAlqsXuAJ811Jgx2ik?=
 =?us-ascii?Q?74nvHUx5Y7D6f41MLyHKZ39q2MYFY0+hQIjqHQuGOWMMdNxqF9sDeSDOuiYA?=
 =?us-ascii?Q?My1BLxXAs1/J2dFmu4Gke7cD7r9eYUKd9rp8qNdxXvQgMFCHpqD+jB5yEe1c?=
 =?us-ascii?Q?q/zNG6jZWK0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HCww7jehf+3mTzIO3hpdLmldqbVqVkmm5i0PLYtYs8RFFsbkONFeJkpy4iMS?=
 =?us-ascii?Q?TIW5NJ9NnWVNHgGJ5bMDBwQKaAkXun8tZ/WY+7hH4cJKcKDEOVJ3eZhobbuG?=
 =?us-ascii?Q?2X6tazmVmeXdWkN0ZUFLcRDqAo8zuIe6GVb7KnWQuLppn3h8KtCiouIb/dMg?=
 =?us-ascii?Q?4QqB/6sIOY4O7eHuz4hgvZXAeIk86jV/QkScZ5xUMGX6wT1NBD22Z6REXAt9?=
 =?us-ascii?Q?wfxfcrcn62Vmu1Ps6wcbty/P5arAYnzh1r3mm0/x/1uDCByjaUyQrkmiU8cp?=
 =?us-ascii?Q?Fvdti75eT1RUkwgtJLuClkLLLTbQAMJbU7xvuddSWjKS/fo/bOYgjhfNfOvt?=
 =?us-ascii?Q?uWf5+GRge2IlSqvtxnwUOFUFkUJjgbC473tqPvPI8cHOkhJPh7EwqAZGrjOY?=
 =?us-ascii?Q?y/sEuhb4KpKD23fb4lrzA8MSYuXChwk4Fpwbw876o+hQdCwJMknlou4v3QdX?=
 =?us-ascii?Q?IwWoWwpBdvpCR3XQuyKH20dWxXneMA5zbgGluTCDB1CXZUKro3OY1kIgXxso?=
 =?us-ascii?Q?g+ZnY4YGyzT2M1JlPgoV/tu+Sh7iUZyoXV+OgiG27TYcbNebVoafazy/4g/g?=
 =?us-ascii?Q?GTDrrKsFP4QkscZ37uyH5ze3F5tkyzCYWqavhWf/rDZlC6RirkuFb3VcLxZH?=
 =?us-ascii?Q?kKbIZ21ADjFrN3/UN8tOhgxFZ+75xvuACAXr1WVyEz6C8OpLdCNG96KyYmpj?=
 =?us-ascii?Q?YmgIKHGMBt3s+nyv9kwVlrSpT+EcD+8+2MBUN0VXb678wNv1pZx2dMWo7dUu?=
 =?us-ascii?Q?PEubyvlfp7oYxEq+YMDnj1RXVkTRKyslkVhYrAP5WoYMdnITDsWav3G+fVGz?=
 =?us-ascii?Q?T/ywKBl1g64VwiMGqi5nYfL0xo3p2Kaemt9CfT8pjPGZ8JnWkNa3s1QX8mCi?=
 =?us-ascii?Q?+/TLk4TnQWClz6ZD15iQxxMtAViM4/2SKxX3khnmPmMebZdNs4bDypsPWbji?=
 =?us-ascii?Q?OFyZlolfm4XVXdH/jg5emvuw56+qVHrT9Nb04xu9iO7je0UImRP14q2N6HHu?=
 =?us-ascii?Q?MEeweo34VCUH60dhbZmqMX+18xFz/Yp+eRwqKftwNaD8FhnnxQ1IkOCGKI2y?=
 =?us-ascii?Q?l90DN2bR+vGd5t3rou2X7vghypwtm/sw5So8eDrdHrG5XnVuGfC39EhLRtJJ?=
 =?us-ascii?Q?1YsEwRIeBnjV31sKvSKCKmbK1RVd5EiUT46joVhJPAaQHTn+ryQTIv1WXpMG?=
 =?us-ascii?Q?GGXnKrCgkvdtHCyhBBMs7PHgRz6uKiUCIUsDWSdFfkhKCYE6giCfK2nVCqjD?=
 =?us-ascii?Q?mBy3/1itQ3GrRFYRY3HFZNaaSoHXAc/EoZfwTkO2Yj3DQ7Wzij2BHeFvK6j3?=
 =?us-ascii?Q?ABaLyfQbIe6MgZTirBJYBd2QdDKr+gzCAk3S5Lc2fO1amH26PP8y3CGtJdbY?=
 =?us-ascii?Q?CyvRf0VjVo7guuH0b/wIBDiFqdGhKZfiGVur+PNKwafdKcC01EIfzGhZ63ny?=
 =?us-ascii?Q?0E+QjUQJwnm8iA8BQXr/B3XKu/tLQn+0qCj7+/9wqE+sau0VJnOAgZyo//9c?=
 =?us-ascii?Q?PD7b+d1WyMrrPmvYK0jCnmA9UQ3qah2wD9HHuKvaNy5lh8DnOJaMCVfauJPI?=
 =?us-ascii?Q?F6Tus5IXKpA2g1zmkKXdVQfLPLur+yIz1pty5XzG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb924cf-c56b-4d0a-cf52-08dddcba2f9f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 11:43:57.8413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCSDlE3NA+spXPoQT4/43CzcTZJCD+z9kkjh0legt6IyN0yypupqiplCH9uYALJX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7445
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A2CF80009
X-Stat-Signature: yo4t915ctpugdxrntro6xp31r5wop54w
X-Rspam-User: 
X-HE-Tag: 1755344642-315365
X-HE-Meta: U2FsdGVkX1+ZOd4uVOkNrvHPPO/KB+vM3VzlEoM6E4BIkAy/XNOfPMNx6cevWgbFagnFyER7o3uRqKmZGLwHGud5x0guVvBxF6r8G1Is4oOZuvzup06n8pKI/kS/gQ5GlsYH9eEA0kFHrDdcP4aDSBH5S/2SEKMRDIETpa1YMeQDfPL0p3jP2SJlsJm15InlHwByTEQZdYl07v91//9sYn9b4RNJhraiSk4gZaURO0V9xBhqMg7pxBoB35WHVkmeg95tnMbj7XdIXEm5abVg+GkkXc9Ka7vrMoBFwib0jzfFc4laOd8sKoIVgLWl9FR9/jXnmEjXWN1UPSNzMWu/cB4DG1TYiz5ZjA4c/l8bHkl2q1A+SQsOjU59gng7OfcvPQNGl2w+ggBi4LiuUPrdU69FM6Pxm/mckqWMDhTyMTheGCnKjVXiLYOJaxLHr/bg1Ed7RV0ejxFC8hWm3VDShWuw59kalLGflmaLOhzdhwJf4FKCwHMvVXsDiadsAWLyoaw/6Ul+J/G5R/olUGcFjk+mG0ixuhJaTYPYEmOA8E6xDUdHLYVUkpFFNawkzWXHDb7qSE9P5un6pRlfqn7hcZgOEX+1RK6xKt5NBGE8mLZoTXPokZ4awL9noZsAkw9GKNyPiJ/6ryJYaFXnQ1Cag01G3jNv3xmXSVBA2UC2RYW9S4RAMsQnsSNwWCZtl503nxifkGWTEsuY1r0VoPooh6dSNAqbjyajRvkGjRjfBrPcEzdFn+XCAL1iqdBCtRwkgypC3ByV5jGQGMxTcD84DmEoHYA85DOoXLFhmco2AKDG5EHt6PNJlvqGpyGWMjq7jD0YLOPZ1CqskBYLyR2EIvHxX4rc5cjsHpN1kcSb81er34A0XIgqz/lhPANlxGqFqPr3Mj8Z0yPr4MNFsUoRvRx2pDLKocFtf/wKBv6ZT2Kgu2FAW5yk/f48DYzqQNtBBB1sv9VcKesw2S3W5k6
 pUt88VN8
 8kJFmmEUPB+iDHF+oxTcwdFrg//ynWYCZWV1cWCyCbXvWeH8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Aug 2025, at 3:30, Andrew Morton wrote:

> I hit a large reject.  Can you please redo against next mm-new?

Sure.

--
Best Regards,
Yan, Zi

