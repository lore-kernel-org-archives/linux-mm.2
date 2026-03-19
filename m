Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89DD71088E5E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA70A6B0562; Thu, 19 Mar 2026 13:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98F76B0564; Thu, 19 Mar 2026 13:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87D66B0563; Thu, 19 Mar 2026 13:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 997556B0561
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:36:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4AC9513B4A1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:36:02 +0000 (UTC)
X-FDA: 84563515764.25.CD65A66
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 722D6C0011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:35:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OAPgK1DP;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqHqrFQPGEt0yXijBCvvl4xO23hoRJUuVIHPx2PKATA=;
	b=ORYeQYe7lkbFlKBtUWPwSUoO4SkOCWk8i2D26bt2RY7Xuo1EGmwVzVSJWWqd2dh9NQhj+L
	rF+xFjbNpCQl7mj9XjfOYpHhk2nwLTbbDs5gzJ+It9Xfze2LPnwe0XdNVNyTasNDmPpqTv
	6zm9nurZRqZyxV6e2cnABN8DSyvAosc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OAPgK1DP;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773941759; a=rsa-sha256;
	cv=pass;
	b=HiPhkMqMMwlsGc0jhnmfgKtuzUg0Mif2P/f8r1oT/kR3y9LwP+C9rVJg/GPW/Memgo6bpl
	sSQY2yKkmnLxZm77jqI4JZeo7eDXd7K3lZVZ7teLM9CM6aQtxcwzd5nQ0tydEKimliOpiY
	PoUJyKKhqr1vobqw+DrOMHhGTsTHYdQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iubV55C78YxfQcSqSb6ISyLuEJROdB1Hcm6MTxRSQPdaWM0gua5+xlS0xYm01A9zJiYuxauIUM3G0xyTWI+D/sIOipL3jbJ/+SGFRlhJDPH9qZZ5VIqhyJlu71UXa+hlgTID2xzlVJR5AyU6mUwl0CyEd/t2OsNk6nNUcUeUijTpqZs4RanFkxWbGZmiE0/WMEZZd8tMr42nhx8Ux9yPFGb5BHkJnFiHNtKwT2Cn0Rh0J3L27+2QsKp0GvbchzPSdFIHWLLMf+xGn8EE8i/xT5wGGiL7P2Lm5coLGhkLdlTn0UWcxmTOlwhJvDOoVjDOn/9a+rlmaZOlIHJrwP59qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqHqrFQPGEt0yXijBCvvl4xO23hoRJUuVIHPx2PKATA=;
 b=ud3UQcJRkx9O3UsSFD03ZHopHQ1JayLQX0RJ5hgH5rEl5Ms/xfSnRSG1uRVzxEW8NUFFBkkk3H17w3D1s9Mny5vlm3ZMRSJME+iRc+Z2dLwJUOdTcFIgp13bEnvXDb60JoKAOiYGxEv5DW187YJQJ9eMgeeGmXzbVxQG/YySxZd13rCRmsjfRCyUxWnQQS4tn1wiSdAqptxSOE3Pp9FbLCFvK8KbCQ9KeYyx6jQ+bAnR2UX7svpjXJqGPoavd9dGCwQTNeldH2V3TSey+yk92JIX6SX2Hz08F3V9z3EiNcMZhIpQJ69Cz18j5VJjSiGBzKdqtRa54wpdV9BFwOf8Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqHqrFQPGEt0yXijBCvvl4xO23hoRJUuVIHPx2PKATA=;
 b=OAPgK1DPTpnu1bb354mXor8bgiDFT1l89JwwFgWfkoQLkFKo3HAU5u3Ter8xIepnnHVqurAwAbQMTl49BCmvWSxbTfP4Xu+DnVXxcAQbde7AcEL4H/LeHSWniiEWvHL3Zm5Xr0Syel60prl1PiwR/Wz9GB40AIlPcI6Inf6HdWqCYZBDhQqXyndT/A6IwXQhNJZh8Q29jM9k53/5CY5JzvGztKVJq+J+3+Yb3TJ1kCNiiIfs85rvCVfxt9FPOsed4krugrbedIfIu+5REUStzl/yT+7hqUeAnZf6osZErtvGIaUWv3tPUmhkZ/D5rJilA9YH9JHjN5qiIK8FE47a2g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY1PR12MB9651.namprd12.prod.outlook.com (2603:10b6:930:104::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Thu, 19 Mar 2026 17:35:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Thu, 19 Mar 2026
 17:35:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Thu, 19 Mar 2026 13:35:49 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <80ED7AD8-8E5F-4E12-ADEB-552C99C733FF@nvidia.com>
In-Reply-To: <20260319022142.277161-1-ziy@nvidia.com>
References: <20260319022142.277161-1-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:a03:167::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY1PR12MB9651:EE_
X-MS-Office365-Filtering-Correlation-Id: df5ee1e5-33f7-4b4a-e710-08de85ddf962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	t1E31d6rdDJEqdCuWVhjj1aEBU6Dn++ySPJA+UEUrq4/8R4pzqeZprvWpJ8bXWofgdII6kwlwVTUytbCLK2NORZwyPqbxlxsSwjtMYMmxyShcgRB9aD8qPlY+fQwjXeg2+b7B1Ojv62wU6yfo4RoxMhk/3N2tlkaHO6dPA+8aXsMe/ypJcEUliM/oIZcFZtNGFe6/wR/c+KI8jlqoujUMNTKhVmotpA9kgSaMmBl299NgpCosJdGGjNJXG8UwZ5p3cTqZFtMojGv9kJvRwYzpN5kilrbp2bEjyT4Fr51WirwDGkJkkw6AXedFwDpvRULaZ9rhPgfgZIx3RuSDPg/lciWVJmuGSBjw3apdrLf97J9mGvbaE9pZRm/OynBnLBUBJm50mMhgUAysTwiiK2lc6liA4h5s3hkzjsogMh7wWlC4tDt1LUUuKrHpyC8FYgYSpyLmsDFLOhoY5NvubV2Q7kR7g6/KTanNZMVIfCMu23FIolp/tWWxqp65Lnor6rpqNlrIcB2gQf01JVZGJet/LD1gsEgK0m0ddjV75OE56D5N9YSdlcK23n/QueaurZkUxvH80Q2b+CbN/PI4/qv/pR4SipOkhufKpm1JmDaQ8j6rfFbBbay93Nohp17+aJ/uWALMXeAki4FBUwS/t2raE9/apMZXp+d2XTMNG0mPKG+C8Kd1zcsG27Ie4USvOucapCqr0V4YkpW0xVaXEYvEOlC7R4gxPqVHsv9oLJCaXmmg2ItO543rnufgbsZgu2o
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n6IHw7Qsj+tkuXv7E91xKVmqoVqSiaD6wRT4x+//pHY+3x4le0BDb3ROeMwq?=
 =?us-ascii?Q?2HyO+ZC0S+IEDISAwt62ywxqFW4OXI7fZrAtnBHzA8fHckxn92yTLQMWcKx0?=
 =?us-ascii?Q?80WoE30YyhttJxab/S28+HEY6XysY3w1UfVhdbwORkVb/fQ6zz23KhNu1z/n?=
 =?us-ascii?Q?RPTdvVoRvMbyvHysJrQfXeFnqE1pa0+2JtDi+UjqS5Z5uJ4V6VV9RN/h0QMn?=
 =?us-ascii?Q?0loit8Y3UXWz5IGcw3EIBGLNnsYq0TBooJOYNk32YTuxWoWQCW3GCsrSLBUx?=
 =?us-ascii?Q?C6pbHJjuLF6t6/Cp9P1w+5NM2weO+kCySa51fRjijdsSleFDOAwDE0FjEnNm?=
 =?us-ascii?Q?SKjff05yBZ8qFlrWW5fhRSZja4t0e29q2bIZSUU9zTEIlmQkApVuGYl6dnZb?=
 =?us-ascii?Q?Aa16uYKRHTi6UlGFrJ3nrzjSUVY+osQYylOV0L+6f4fnD+KzPbNsUEv6+hRg?=
 =?us-ascii?Q?lu1qNPESSmKq4VZyUZSdHPqD20Qn/OkZAgrNRsNWQSSaTWN5h1njOOIjntLk?=
 =?us-ascii?Q?7xW4rU6NwgaHrsrAHYWar/38FEmwaPxRpg31jBu50t0o+vBwdJ8/2X0kYFAk?=
 =?us-ascii?Q?4VfW/ehgCZDUvLxuGPOar9qYb72+mPLsC7t72nebiAHCFiuVlenI69h8UIeL?=
 =?us-ascii?Q?bfVs0jI2aBucGr9AcAY4RMZnzD6htpQVyTN4L9hUa0ljvLfD2/VRVsjQRooH?=
 =?us-ascii?Q?Ec+a052oxtLBupO86Vx8op30w1Oq3wHq+Nc+rgLAwHEuaX0jJ10Re8OhIMZd?=
 =?us-ascii?Q?2ij6BGrBHS2eJxAqymF/FgyzWuQa9EBanc5A1KPlfL/4ocmotp7om7M79B+b?=
 =?us-ascii?Q?H+QUczBOGMr3UFkpXIeeb8fTfHkxA23p1K/L+3vHxrYPR05FNX0BmjqE++5H?=
 =?us-ascii?Q?EG16L0FbZZumjPtnfzw2LaqXN91EfFRZFTH4Z0jMP0+lWoipl6JgRKANfA4W?=
 =?us-ascii?Q?wrYEU89AgMXHn6peCI59LiN1p+o9IIdZw+0KJDzrG9EykYpBm6RQe48boZ+N?=
 =?us-ascii?Q?d7m1ozzctQVwLeuqHkReGuyPIIYKw0uFY8jyPSeEv+gtdTgFoTSh6KhWonbB?=
 =?us-ascii?Q?ZMCN1NfFrbl7aGwmEDkuNhLYFXt3Uuli0bUr6T5XtlWUE4EgLdjaKLKd8EN3?=
 =?us-ascii?Q?/YLo7U8gFHl7YXOA0PwCnVdcahPrs925+ZNreaBsIhNKANGS+sj7KGpWvprY?=
 =?us-ascii?Q?0Q2gvh0FESgEBacLyZaPlQxupgjbIPX3j70tSBVzTIJP3I9YyqD80H+V1K+6?=
 =?us-ascii?Q?RQBMfBdjUwUcYUwRB16GDo6OzVZViF/KzFv+vg5LmvJiM/MBHOIWPiTe/M8b?=
 =?us-ascii?Q?lARahcrX/10YIwoURECwS23Ezqpqcezi1p4OSaRcsdJ55DD77bI4IlGxWgfd?=
 =?us-ascii?Q?bofmhAhRG3ch/VdchDu3OjlWv+IUklxYdYX4laFFwcRBM9NFeUHBvNItUpil?=
 =?us-ascii?Q?60tjH6LA6BHtZm6n0C7ta4eAWYPPaUVwzSblneZliHJhw0wiQHTxT/U8D8TH?=
 =?us-ascii?Q?z7IE1b5n7voV+9yV0zNRiYigVse0CNutFnI+BbwUx4TCvAymq8Vlj1fJSbPd?=
 =?us-ascii?Q?Zy6wBnmCIOIgyrgpqlxGIvIBGTSxJ4XYFcp0d6879wLcnsvPD7lumgOuhMg/?=
 =?us-ascii?Q?zzUPjrB6fMSQKrEEng/aL6xOi+EW/A41a4bUD7ouzJaX3Wh7hxHx/fgTO5mk?=
 =?us-ascii?Q?BKBqQJX7d3+5BqaikT7xtsOCrgj/9lMxwTlQUCdZOBHWentS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5ee1e5-33f7-4b4a-e710-08de85ddf962
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 17:35:55.3762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTJx2hgqH1ZSwLdj0QvpnV3k/lE40A4eWSmGEiVRKXQkizP0lvIwcEQYSBz2maMm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9651
X-Stat-Signature: o1ed4ruowabisgtaqkt3opfi97nkehfb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 722D6C0011
X-HE-Tag: 1773941759-647028
X-HE-Meta: U2FsdGVkX1+ed0aDqoJpYiMmnGRqe+Ic5MaHFjheXEtIJK2NJVHVl+wT7JlmvN018OkwcjcCGdyimOo6L+OE0BnUlaD1xoIRs8X7w/a7ihgtarHkyrDhuA0DiJ0/l6K0BUwpBVPK/4sDIGXkgEDkInKZsuYAd4Z+sRsxGKfpjpYzgRh1mkbrbC6c5x5y1+p05X4jxvC5wJF3dbmqxKIeMvD0UBJZLBlKhBObhcY8n920RmMSok/homLs6Of4Sr/ud+SVhaalgAFv9/RV0bwAPQ5/PIagIVjJqWlaHTEXOZV4ZVHXQ9cZXhwCtyL/GfA5H2EQtiEhjTfjKo4eAToPhbrBf/2g+DM8nh70X+GPluRBHCvIbKXhGRVfXPmo7Ux/zs//LmQekWbInbmapPZ/5NZWWZadJSRls6lisBv8dGVQx+CShEcjyMb1fVHlxTbY/wziaQtwwohRUlQL0mYCEIXPWVSJD6NIbrIwgI905qeleawG8MdmRjMJkOI5nBtBI85tQ/K2cCX3xFwbnsjB3/V3jglKg7w2jLgVFwtQqq4VHmEXKVrEXyxdSiU2M6O5LE98v8MhQsn6X9h4OmjJvQkK+CxwwBOe7V/7AN7aJcpY2BaUOPWjJlDiesRtpCmPO9a/s+i4CQps1evfr36ZjZW3focMjc3lbWlIzG8Mi8LZUMYLuEoOnirpc1he5OljVDwBmyXf5ZDqNQ2fiaAxvV7YxrCz+kHsG+RNJIC/SCltD3kVw1/UEgkTr+yc7pBTlHfs6x6YGgpQsybyEKDLstjYrHVJfk/y8sGbqK3fcEjqRsZm7Z47lz4WvOkHIOvhbpPRwDAM86jQc92gFtWJQFTfWNyyNEQu/YWV/AKY75amKgLAcRtmcDhubDDuRLbClbo8Q9X8HyXn7mP+6xl8I6Y30DqNtPYkdwH+GFlSy/X+UYEpT0hYlvYmsj+2VOwi+9dRqy9nFGIdkQXb/du
 sYyV1UTC
 QKvXuBMVjSwnrVnRxzRDvurHH99nZ1vbH8plguvUu4WvX3BnbUEhyMzdxV0Qgh714K5H+7RQvFowYV+WXkVVWiJZq4hZ2hN32ZCEI6Ao/JFKKSlZ5rEOFGK8DI+LXl+4tel+ml7euTI7UJsAAZ1ko0EuMM/rbO6cvXA/2+vosxjON77EP4ZdRsS3REfY2XOSdNJAwcssOduNEA7/WIjSvOQOfzWl0m9EIj5tWll7v0u5rcibQiI5zj1Ty5rtkwi/UxON/f27OwY2khNBe4FLkWJ9ZX1wE/672RZTCcSVdEz3t7RdNH1B7YNxmvxES8ohBgDvIJoCDzL01fPS3LGrgXCFgWa6cF3xGEKdobDRXI/wAN6ukkDPivFyNPsndtcqPFn/KvH8pBOu8S4+WPwdiB0tfZHJaCbIUZV4Q9+XeCcsTv0/qlAkY11XM4wS+uYqkn2bbT4jWzz53oS2fxkGFiAZ8SCD6sbuIFa4nryjiUMLpNThfDdeIkyc42jc6e3v3XEESoRfvn8jDMS2HJhBu7IcEm1FsZi9h7QkVp5lYZP2+7PlsaFviioiTGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Mar 2026, at 22:21, Zi Yan wrote:

> The added folio_split_race_test is a modified C port of the race condit=
ion
> test from [1]. The test creates shmem huge pages shared by both a paren=
t
> and a child processes, where the parent process punches holes in the sh=
mem
> to cause folio_split() in the kernel and the child process reads the sh=
mem
> in 16 threads to cause filemap_get_entry() in the kernel.
> filemap_get_entry() reads the folio and xarray split by folio_split()
> locklessly. The original test[2] is written in rust and uses memfd (shm=
em
> backed). This C port uses shmem directly.
>
> Note: the initial rust to C conversion is done by Cursor.
>
> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumW=
JdiWXv+C9Yct0w@mail.gmail.com/ [1]
> Link: https://github.com/dfinity/thp-madv-remove-test [2]
> Signed-off-by: Bas van Dijk <bas@dfinity.org>
> Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> From V1:
> 1. added prctl(PR_SET_PDEATHSIG, SIGTERM) to avoid child looping
>    forever.
> 2. removed page_idx % PUNCH_INTERVAL >=3D 0, since it is a nop. Added a=

>    comment.
> 3. added a child process status check to prevent parent looping forever=

>    and record that as a failure.
> 4. used ksft_exit_skip() instead of ksft_finished() when the program is=

>    not running as root.
> 5. restored THP settings properly when the program exits abnormally.
>
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../selftests/mm/folio_split_race_test.c      | 431 ++++++++++++++++++=

>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +
>  3 files changed, 434 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c
>

It seems that I sent a stale version. Will update it. Sorry for the noise=
=2E

Best Regards,
Yan, Zi

