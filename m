Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0494F9D0D6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3307C6B0088; Tue, 14 Apr 2026 11:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E15A6B0089; Tue, 14 Apr 2026 11:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFBC6B0092; Tue, 14 Apr 2026 11:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5246B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:56:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92BEA138DBE
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:56:00 +0000 (UTC)
X-FDA: 84657612480.21.D25D053
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011045.outbound.protection.outlook.com [52.101.52.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id A30E8C0010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:55:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="H2zdk5/n";
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776182157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkSMBL7JpEe1VpPaULzELlXhgxOBXeHBmEOZyeMlB74=;
	b=V+67TuBwZJwuxOA2Dom0HPkYOvF9XfGe6iiSyYR8/AyoiTqA5J18en4EK9cFf8umeJu6Dc
	WWOz9cV9+xeg8q18aGuEgWy+1gY1SQ97zQJQ4qIO3fmy1Zpcikp+Ex+G8yLPQB2mtj8U64
	DAT6V8yuBUKrgnSAqd+z6dvI/P9yw9k=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="H2zdk5/n";
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776182157; a=rsa-sha256;
	cv=pass;
	b=qM9psFECEBjdFKQXsUvWAKLVePryBJiTcs2Rr//gIxkWyFQH96uIRCKKEtGOoNlRf90fNj
	2OSYHLYRvi55JxZ6JxdQOuaQXUpzZ9eMdZi9MQVCmchuQGGrYZhswV7UkMMmvQ1Uii8zjQ
	lv5rHPSrDPEjwRLO6Sh6cvWSyaXUG3I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEs55kLAY3zLecyQEZZhBUeNDG1QP17LtZgePfZmD+oTKFADJ6Mdw/qAG+YL5YcEl+AJoUxiiVyWYTuoqXg7zpcR9o4CoQm5p7Y/JRfq7QwiNIO9+d8IboRxMwknOwxL7bEjdlInV52FGK6kOVV8fe8sBJAIF3QYpWIImlJlGkF1Dcjya1MFEB30IQe+LP1luY7Oe2a/ZfPDP/CtIC+7KLCmikZs6U+e89UKQGJEOa5VRzjW/w5dIQGbLwCUEqZD2r9n6iZ077oTrcwH6Gb2ChebhesXTxJO7XqrLiJoAK5eSBLscriflbc5Cm9qBZ/7UAYPVjBiYmMzlESL6T60Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkSMBL7JpEe1VpPaULzELlXhgxOBXeHBmEOZyeMlB74=;
 b=Uf8uTelq0+GpHSMuQW2xC+NknpEsMDimZ7FesGciCyfI0heajpjPSkwb58EvCIuibEZrdKEbINtX629nem2V6CQQebmKosPC1HmKlFpTHdOSJZPnb72+L5LocgS/cTmPw62cvPAgaP5xdGAGJQXrUvZ7BxMfbULN4WL8wMWD02thvX04wpol3/B/5CmqlkToqJjOmgtWJrMQUN/32dhyCvSKHw7FVV3o6fW8PTjM7VOw/fbnMwEpvMGioOs6spTJGVcZ1eJgaI9NyoWjqWGzTYGrtNTdOhzZPNaVSj9qROfsuMA5R5bkUmSvAIfCqbcHGRJqGpc6aOgWcT+B6R9+YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkSMBL7JpEe1VpPaULzELlXhgxOBXeHBmEOZyeMlB74=;
 b=H2zdk5/niV2iGCrVO/lLvPZZrxiQfEqJNhftvQEO87CB+ZiJAcevv0LmfmKMVHJgonF+Av1MTtsvVRpZ49/eeJWNDIaqgJhYCIP4Tz3tp9aYAd7N5N5MtVUE2Up9RNsXtHb9tOfhLAtv5ZcPBthKoZbTudbtinkikQFwbwzAcWBWIX17A8JId9CJ13maaJcOffpe2zOqSvUcEB0SoFqUXyLGncpEeUVn8cVdYDr7kQ3epQPWkuuOQj8KsdYJDTFZW3XYMsUDoEsxQyCBeGlWOXjQ7/cRrEZBwNwOdwLUuk23CxWW43SS1/0kWdKk2d9zpKzoPEr///GcgX105+FQ0A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6639.namprd12.prod.outlook.com (2603:10b6:8:be::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Tue, 14 Apr 2026 15:55:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 15:55:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap_flush()
Date: Tue, 14 Apr 2026 11:55:42 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <842D3AD2-32A0-41E1-AC09-08EC793EAF7F@nvidia.com>
In-Reply-To: <10aadfeb-86c6-47b2-b6ab-b86657aafb88@kernel.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-3-ziy@nvidia.com>
 <10aadfeb-86c6-47b2-b6ab-b86657aafb88@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:208:236::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: bef77dde-6e37-4836-ba1c-08de9a3e4a1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Lc/d+gAbw52wQB5V01WwIz6mnAGOpjSRaWIQHTpIRpYqRygMm/PDfI7RPiCKN9BsN9kADF3jDEN+0LB5//ZNbFYTrxXslKW6iOGMimCQ92to2PoJde/iFr1pTjA85+0ouZdlQ24GI3pds1af3K2XQthu0PgkCP/EXj77yJgh67E808kZ/lxcCi++s6PkQ7W3TIJoBrtrNV9JVQP+uE0TShIz/+9garo8z0yG56ygUnr1bD1hfJI5ERB9yXZFQDyscHc88ZOptZ7Vk4NJ8lCfbk6jhqi0+2pFxDq0ePlwN2mYeYNJt2fuZ/tsuQPurosy5lWqgRT5nnIyIVKbX9NstahQH58b7iSz/WTUzxagV41a92HYXycfgLuJxPdA/+/G/JmLNYLe9psrnRjEu8ox2/XRN08M5ThgZVyK03cSQLcvsryz3sLDDtdy1lEbEgV8BhubRn7k9hV5L1RlraNig8gkwv2ueq+tqdd7pCXD/PX9cymZkHTN5/IBXz0909kO4uv+clhpJHk1Eb0YWAbMYuCrE/wM53HuuV8QmU6GOLiVpRzufSqo16grwbP9E4/PmAs7RRBU9DHsLOvltviC1X7MiKJh07sh/VwBf7R2qY78AFQzoPzBx65HGMXyymajYJ98Hswre/q2K0Dvlo+q98KWP/08EHJS8CPm4zATiMJoINf20k0OTlxLSMmabavnCZZV/HwY+QgfHACdYyFZpvyDz7K54npWUkwDJ5DzlBI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?occdMKOa21HKl4a+lLJ0cPZhbQFhypL0z1sZYpd3jZbDKfwLSjg1qTEWzo2Q?=
 =?us-ascii?Q?+u86tK706R/3uPdqUeNs4cWMcf1/r6RyW7DPC28bFP9q2emeBeRJCnORd3tg?=
 =?us-ascii?Q?t4j69blD6yEqTp3bBWfRltZWSrrmevZbaO3NiQzHQU6y3vcQSh1L8gkQvXq9?=
 =?us-ascii?Q?UXXYgI416BYigMOOUNOV0k0IcWkQw3blZCvoJPmM5kOhjd4YMiwO82RBY9gE?=
 =?us-ascii?Q?SIMj+rFvGLaY/+ACconf9E15JEscfqfwf3bGDIKAo0sSOnbUnvYVzCIhvtG/?=
 =?us-ascii?Q?26l+U7tUT0Zkdr0a1mP0DSszDAZseCkkqbQlZjyZXenNPIHDsykHMunOeNtU?=
 =?us-ascii?Q?sf9wCdKAA0P35Krsfuu67ZQQ7pCCd7xrnm+xl2VR9eJRxT4r73Rhhz+pTPzR?=
 =?us-ascii?Q?ZTWoWs+dDIKKtvtZCB3we3GopJ8KhUA65YQw7TJkjn2Bht5AmPhEgU13HbXc?=
 =?us-ascii?Q?4QPUjeDJ7TiBmLuTNSIgCWnL2/IQqEGdD0g91NrJvKbf+SW871GH8Qh/+OO5?=
 =?us-ascii?Q?02mJUz3dGnOEBg3EfQ9RGxVd+O/yNmSQAARoVi9cRyxri17rQLumRb1FLPXJ?=
 =?us-ascii?Q?WxxPAFMDGt5EO+DLTtV41TEJuLnd8O1XulBd9j1CnaOfhWm+MRSroEAXKLSK?=
 =?us-ascii?Q?GC4HC8557Dv14mj8viZY6zlss+cf1YvgFTu6v4iB8XOMjssMWcssCeVaB5Bk?=
 =?us-ascii?Q?wZSr6OxWAgs9YP8R2Gb6diu5O+NWGH6dyEXSkxVtSf9s8jcHBvIJg/lUclh1?=
 =?us-ascii?Q?FeA+ThqP7HO/3dfTS/2jc5rs5oyAV730RozOeVhq7Aa4qDPwnqSnL3q+T7n6?=
 =?us-ascii?Q?PD+IOvV2anCfnHh1j0pt1GDpd5V9p4lLn9AyT2dFeB6bAgB/BLTyxekhzOnT?=
 =?us-ascii?Q?B7OO+V2Afv+WM64bUM4wVEMtCR7qaPwW+G7109VwkzpfsRKSYO6wyP9S89hH?=
 =?us-ascii?Q?qtRnqXpidotRsmgr2HUjCeEmkxE5A1VQSwu5zJdP076e/5xFS6s5r2HGnu/L?=
 =?us-ascii?Q?z8DANmsCpWRL5yO0q/S9hY8Ftr/CF/hTd6Uz20z4oAzX21zYhEpZcusKrzzO?=
 =?us-ascii?Q?iKbXJmYIfmkmwVbx1Poa633v+nkBDs5iXSnFFp4xIM4XxTF4DxX64vwz6awk?=
 =?us-ascii?Q?BsvWzk62+m/qrz6T8W5XChxa5NILFKdORmwxPK1mXn7EYLnqyd7BAnEZFo/c?=
 =?us-ascii?Q?KdF3cm4P6bnnkiDkxuY3GT8I3TZnaGZzb8+nxL0iToOz9GEEuJH4pBWGyL23?=
 =?us-ascii?Q?xnjkbWLfMX7zYO2iROQbkBjx/XJegy06e3x75q19o8V/DEmNjbGwlhTxYMTM?=
 =?us-ascii?Q?vH+zVKv6QMRTu3pSVyVcnHM3JOq8hTa4NmzVqJqc7pA1JRWz6WBw7pPaWhKq?=
 =?us-ascii?Q?/2Q0oImMX8xFw28eNaPHoXpBiYzlMQs+Y1Bjd49V9YD+sBMJgBvjAKdhlJs6?=
 =?us-ascii?Q?QDWHEESQ5rV2EHOozlJPQGeE+b1y84WLonYNSI7tH6aGDHhOZGRLkmDkJ+6R?=
 =?us-ascii?Q?KdtCzD9e0y+8KRHOw7EKDxjU4MFE+5URUYZncJb8Es49EbuhFWUNi0jM37PV?=
 =?us-ascii?Q?Idfewt8s5cEZO7CQ0ppXVz1k/z3qwX9siz6zUgd/hgWXO3HPRAnAP9gNNgsb?=
 =?us-ascii?Q?wbtH8iSuZOpHhax2igf1/OXqwBYOqmFKupd/w/JeluzzQZOQyGRL67O7Mnu1?=
 =?us-ascii?Q?1UMXZRigZNuR43YfE5Nvag4wTWFJ0kUYZKmbQT3pdgJYqb72HQGElRsEc1kD?=
 =?us-ascii?Q?tyaHLBY7DQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef77dde-6e37-4836-ba1c-08de9a3e4a1d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 15:55:45.6889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtvfAyH65cuG2Ss+rxQG5OTk2umc8BrxULh5sZ2/7zfG6aIutaiiOs3TNDdwx8MA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6639
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A30E8C0010
X-Stat-Signature: 57kswn5wwm8tnajch8mptnsy1xniccw8
X-Rspam-User: 
X-HE-Tag: 1776182157-681497
X-HE-Meta: U2FsdGVkX1+T9s8CacFypFnhoxSAVlW7YtnC/7EKlUY2Ti71bI6sufoDDYVKwtMyxlds/4HUsgLfYz4KY1+ljikUCDcCnfaLX9SCWlLbEmxMw6u36cYZK3AGySRAHLV+38ByPauiyiOoS/vxvFYOxpHTVn+GXGYaeNODk+kur/V7P1TK9t+JhwezvJ3yDHlIe5Yrm43ai7m2YhD/joxHbdgbNEgvmPcz4og4zQ35xZ/JG3kicX5tPyoqGDgLprgw8jUPUdjIakhJuB3zvK8r/v5deMIcd3XTHU5P1uLM4U/hwjYYkQzHe7bOD6pecKPdn7APRXkKwZXYRgvX01Bafnpurf0KuSTcu4wH+Y81fIHM9yfQ20Rl+d0FFPOvFYQu5Pq9UOFc6oeho/WYP75ohoVhuoBHhop0hSSBdKB+f9UewFx/eFt5K+zN3y3+qxKMlfTxq4y87If+TTZA+JchzOYspuqEB4i7+nnPgQpU6FVOM60fMXfuT/K/fThdtypy2o02ly8CBynUY0ohSA7R+cWn/p04lCFWa9hgOQiaerMqqIWXJv/9cGertRnO4Y31W/pvpWcUcpalQrg14uUhv6Q7rbEAJ3syDWXiR9VXOUUfkWFfwH0B6rtULfRdUffiE/sli/EBqOD2+53fxqvRCoucIDhcxbDxSDXQnGswj9T53HxIgH0njK9GQ+K5ggV7ubpqxRmXXWtZ7tlalu5wr8emZA2E5jx0W9955uBpuF0tk6fVEUoUpbld5nKdio2j7j1PyRKkpGzxCaAPfWWZci+EUq3Z+0IyPfYrUYQAtUa1SKvYzPHuNgFRFB4zj2jR/V3im7qppde6acCX8etCBAQvUlkERi7kfG5iGydj/DeLnMuN9F01+gBRt4votJQ5Wh2tT5RmCXwNSVGfwX5/K76XiWmvLceKn0HVl29ATjFp+5MzJ0nivraL+BsWbsaxXDZGEC3eHj3GpK3pBGW
 b1jF4jmh
 wt/PZdeTe9sxn+xHVyiTraSfAJrXr3evZXOQc4t+/EE2SM6CUQ6CLjR2n5QXdZXgxjpFIkwsHx1qXYnGw6rUSXeALoJa8i2Dk7zzi9avYuORs42qnrIIkgL0NEZpc4tcpKwqkONvnbzBWURx5TPgETwIxdb98sHG6M8THu2ycZh5dpC2XoZhohZvYmEHyYfY8tGyk05aKXIt3JcCC50biNT20UDTGVIOIUbVsyyIpKMMQg0pJOwloQ5r2zwH0AB56H5x2G7bwHjz1jOhnVsGVfomNhX5yr1KCird3YRr1y/4pZYMjbZetEA4vBG6r8FjzntKyqf1lxsdPnD3Uq6LElmcgUU6EbQcwihYRz9+czncbVpB1yC7/n+yJ9bBeiov1fxfyiJJb7BFXIRIkPit1zOHEMZgHSBeXBeFGhoBdIaNi0deshirwIjsVaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Apr 2026, at 6:38, David Hildenbrand (Arm) wrote:

> On 4/13/26 21:20, Zi Yan wrote:
>> This check ensures the correctness of collapse read-only THPs for FSes=

>> after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporti=
ng
>> PMD THP pagecache.
>>
>> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_t=
hps
>> and inode->i_writecount to prevent any write to read-only to-be-collap=
sed
>> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and =
the
>> aforementioned mechanism will go away too. To ensure khugepaged functi=
ons
>> as expected after the changes, rollback if any folio is dirty after
>> try_to_unmap_flush() to , since a dirty folio means this read-only fol=
io
>> got some writes via mmap can happen between try_to_unmap() and
>> try_to_unmap_flush() via cached TLB entries and khugepaged does not su=
pport
>> collapse writable pagecache folios.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/khugepaged.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d2f0acd2dac2..ec609e53082e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2121,6 +2121,24 @@ static enum scan_result collapse_file(struct mm=
_struct *mm, unsigned long addr,
>>  	 */
>>  	try_to_unmap_flush();
>>
>> +	/*
>> +	 * At this point, all folios are locked, unmapped, and all cached
>> +	 * mappings in TLBs are flushed. No one else is able to write to the=
se
>> +	 * folios, since
>> +	 * 1. writes via FS ops require folio locks (see write_begin_get_fol=
io());
>> +	 * 2. writes via mmap require taking a fault and locking folio locks=
=2E
>> +	 *
>
> maybe simplify to "folios, since that would require taking the folio lo=
ck first."

Sure.

>
>> +	 * khugepaged only works for read-only fd, make sure all folios are
>> +	 * clean, since writes via mmap can happen between try_to_unmap() an=
d
>> +	 * try_to_unmap_flush() via cached TLB entries.
>
>
> IIRC, after successful try_to_unmap() the PTE dirty bit would be synced=
 to the
> folio. That's what you care about, not about any stale TLB entries.

Right. I missed the PTE dirty bit to folio dirtiness part.

>
> The important part is that the
>
> So can't we simply test for dirty folios after the refcount check (wher=
e
> we made sure the folio is no longer mapped)?
>

I think so.

>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b2ac28ddd480..920e16067134 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2089,6 +2089,14 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>                         goto out_unlock;
>                 }
>
> +               /* ... */
> +               if (!is_shmem && folio_test_dirty(folio)) {
> +                       result =3D SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +                       xas_unlock_irq(&xas);
> +                       folio_putback_lru(folio);
> +                       goto out_unlock;
> +               }
> +
>                 /*
>                  * Accumulate the folios that are being collapsed.
>
>
> I guess we don't have to recheck folio_test_writeback() ?

Right, writeback needs to take folio lock and we are holding it, so
others can only dirty the folio but are not able to initiate write backs.=


Best Regards,
Yan, Zi

