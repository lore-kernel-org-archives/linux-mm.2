Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B2B1099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A076B0098; Fri, 20 Mar 2026 14:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201876B00BC; Fri, 20 Mar 2026 14:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118136B00CF; Fri, 20 Mar 2026 14:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02EA26B0098
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:00:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99DC8C1791
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:00:36 +0000 (UTC)
X-FDA: 84567206472.12.19C0C8C
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010011.outbound.protection.outlook.com [40.93.198.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 95B331C0028
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:00:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Nga3jd3e;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774029633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCLzRq1udfiUMdrPGQG2psqOKWRWpmVTZLu5KNgdDLU=;
	b=Pd/EQb8p5xg/AtTIQII50o26Fr3PXeYQXNEV8WF2hazFWjx8dcKFha/SUX4sqbd4bZUQQN
	8iHOGNg+BM+gspLbvIFtdyeRCMclMLDc5Y+xleC4/DLzoopXKKnJFArKZSkH32ifBlsRk6
	k08AFsbysMbvJ2Bm0w/19MNJbXli33c=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Nga3jd3e;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774029633; a=rsa-sha256;
	cv=pass;
	b=E62XkWxiaL9XZuR/krZW1FWozMiU7YIpZFyDyGkwVIHlx7mU9qy04prtyWNBwpigxfYCBb
	e8S0HMZBDE8dCqFmt3cCuqDaZepRtqzUDEq/b1+AjcrfMzQkBTdBTzGW1khXtdLehaGOUW
	3N/KIQ6xkUkOJKJ5kU4UISuuhhZpK5o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYbWOQD29HLEW1aSreAXq+OaAg3ZbNId7krL+gaU39XU574t8egUErjvJppoErucCm/mx3DuJHnUYk7LsciwR4gf4e8ZCwBmgYqNpMALjuprWs2krFKx4FokQsV9S3iRjXwFjIjKFSSTfh7M/NPLo5zLUcbPZNKuDzP0dZs8V0D5Wjo6f1GUavsEUp7DCi7sf09vmHCor6/o/XroJ2w4gQaTEZU2e4WSKzcG/Nao/V8Qr20n3n4mvxW+u4R+jQAxd2U4Kv+DpuaKKZtB6p6FKhqvR7nMVwPqKm6SqUGuCGd+X5ogZMDZY5QAWQ7J89+UMjinXspOO1oYHeHkw2LvQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCLzRq1udfiUMdrPGQG2psqOKWRWpmVTZLu5KNgdDLU=;
 b=XBxidEc40eA+jrKu7lPNtVIQp4eKAKbR2fXPh5gR64Gyy8RoXUtRHFKuV6lDUA1RPncNE1eHUHKnPjxaYpNAMNMfrQfAN5sca1FzFaURVelE0e4rW05WqaoumnBoBp20ruDOvkFZwjqvxZiNzr7BF3Q2zaokr102WuoO+IPw+5YS12dw4Z+Nwbr1GC7iQz5LDDWocmD3SEfrEY834eVwx256UGR8QajeOIGQK1ViMgqYuKd3Hznqu4y45UC+Y6d41R01oE1GIMa/3o7jMIds8mzwAeyCpxRrpMA3N7yBGU5wA6ruak7gnAIbrzE2mX4nN/BUEYKIR5iQ0Jv2ATJA3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCLzRq1udfiUMdrPGQG2psqOKWRWpmVTZLu5KNgdDLU=;
 b=Nga3jd3eYeqmQRjkbn2CD/jSZ032K8kiCeM/OpXhzhfqvb6DoY9CQaw45/JiMdDqgrdNWAdyv3RkYHji3aML2O5YLbzz8ELQPQReiXyWKanXt9FCHPNcLonzErcNofDqsTS1nhKVxmCDOIDTOZEzP2YGex+ardHiuPRI8wGHOYxrUgo0w4eKWsuj5LOJ4RdhhhkrtAYQF9QxIJK8PZnCoGiu1NZdp+Z6g8OULh/O8roV2RjukXbcA7F4gi5nwcpGwpJMLwZ467pMXsB2Q4U7dHhDd694Dh8LzIh2uwJfiopg9Igi97Hi0FRCSsx85mrAadjGnYyX+TrTz5gwJhs/Rw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6993.namprd12.prod.outlook.com (2603:10b6:806:24c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 18:00:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Fri, 20 Mar 2026
 18:00:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Fri, 20 Mar 2026 14:00:18 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D9C1B581-D7BB-4DB0-9E96-221F796D6201@nvidia.com>
In-Reply-To: <20260320142219.375118-1-ziy@nvidia.com>
References: <20260320142219.375118-1-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: a8d1ea41-d04e-45ae-4a0c-08de86aa91c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	dM/DOjXGml+3yQFKAVdmhkqCJHgiuNYMfleuY1OFRIyH3pfO0K4BcWZ28IFWQoCbtj03WFkayU2as7/RLIc9r/8K2GGwI7JiM48k1+Fk0ySRasNv6Y6L6kBrBngd8C948/9zv8jhQ42qUyRvvr1iIHZuH4PkR0y570aTu4YU1KRA6dcOSutFeupteyUotWtMic+XqG07Mx3fCmmKRjfUfUOPf3KuP162DR3B7UU8pphWvjJg2vIM/Zw4oRoDprUGWp75LyVAGhVBwYj5g/XG1Iec7uzwDyYrVo/NbYzD/dVeKKJoyzDrn/o4qwT92GRrEdiqm6FBsg7a0quoXZRzKyz9SXQZTWT/oxNduNcS01Gdh9emqkELMU607b3nxwJOZ/zBT36BsAiZ/Re1parrr8fCLsj98F7bGjR7vCzmbxmhGrA/gP6UmvLf3QwDIBcoujr9rk0gMrr/uxRGlvtJUEoKlVGN9KBYVr1ZyQHjTXlUqZytyS81YX5ggRloYlblvE7MhecyuPkPQiS9CxBD5RSejHDTwoAZv4kpWow4ZAa3NZ1FmJckoH/mlTBwBDFwNDSMwmzzp9MQ+P0v7Ol0aRWLWPX7+FJnH+KEbqANP83srk/DsRYjge+LN8nJ3M+gTbLD5X4FREV7DhiiXDIEM78GpZ0vEZZWbCx5RW+Gf764ZBnpNHNm5EZZfiry/M5FLi/ir1gnTPGvt2UjCoi6cULe1lXz+BVa9QSX8PM4GAtbJa7GzTClmBI6SRu2naNv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g+SYg3RlzqxBo8XopCuPaaKdJYynv7WMZefa12qhHSkqd/eXOLgT4EUFTCm+?=
 =?us-ascii?Q?1ik51U7u2c5FITjQmPLg7WY/d9MK8jGOCTMX2aLe5HjajLTcAorQZNZdVf+p?=
 =?us-ascii?Q?pncbqVilcrkH9kDDVfwR1hJeqbdvWIrovQvhn6RQyZjuFfxLr/pHfiYtlawJ?=
 =?us-ascii?Q?jzpZEH88yDhqow3RRKjOo2XQK/fmMEoGgAFTSqH7Ye/Qd76ejW0bF5LwyWln?=
 =?us-ascii?Q?JIUxY+kXEp+38/oF2bx2VFDVjRvc7iT+edsMy5cGLnJSY0TmVHW1owcMdmDm?=
 =?us-ascii?Q?v1T/MIg96vPsp8amC+juFI1vuCJ4L4MwRSjZM+huqA8Ibjm6hBnKL7IcjSEB?=
 =?us-ascii?Q?SLVmF6Mfw1wLCX+qObpcUjOlm0LbmCCVwxqK3xO9W6o9QPRakSvuEOZzwW1L?=
 =?us-ascii?Q?VGLSZPc80fgOzp6QPmp3mMMHDALBAsvIbu9pG2O5QsoLvtjf15ouL65bSua2?=
 =?us-ascii?Q?uD2Eeu4zEMNH4Kl3b72Y6IfVoxcgc2xxwEq1pE2K+mIGtxbLZCKPI8I1s1sM?=
 =?us-ascii?Q?BepeiD/0izhMhx0JtHG6HNANqVQ2+mBNvRGapcMkAi0vnpMGZ7uEU/iPNf/J?=
 =?us-ascii?Q?pucv2Yh4zh7GBnFyYaQ8AgIdoNcKcY+tESSsSu8mJ+nnGDPYs2+jsS6haV9+?=
 =?us-ascii?Q?YXwiBeBHuRoDzpb1rsyLiD+TCzJd0n4gKg6iRJOnwzK2D4ycNjLNFSY9zYAz?=
 =?us-ascii?Q?IGJGEM96hRHAf9/g4sOz5u0LJoUOBsYIdi0bLK9pwP/MF3FyaoieqVno8S4j?=
 =?us-ascii?Q?RVIAjwwuiWYkqdp/6OEci+NMXMus4A4DHn9VjLlml5ZY4saM0wPpmtYRFORW?=
 =?us-ascii?Q?rxyfsHLI6TtaHu1Vrq36jHQcC3JODBFNSAF489N29TjAY7HhAivEghBihD5W?=
 =?us-ascii?Q?OsdJMBRGFyFLOVbnGOMfIFrkboO5fwJKDqxKIYaiwBbb44vuIUIeF3fcmvMa?=
 =?us-ascii?Q?Y1BunjmmpUviO8jpPuywv+WpMZ+3JsI8deUmfxSgLlWlUsQtYLpg0hTUAw59?=
 =?us-ascii?Q?3Gv3VU3wLPdVTUT9atgIHJlk/0Ckcvbm5FQLUs6gCvc3O/HzvGMzSVJXyptl?=
 =?us-ascii?Q?Pc9qwosSqC8nGn0A7qkxtFS7F3U8O1NXJFytsoY9t1842Au3VBg72ybQa6w6?=
 =?us-ascii?Q?m7EodooyIryQKag19EpVXoPDd3kr9jv/rBQS5kPYAe37NpDFwrIheAZBoD/L?=
 =?us-ascii?Q?WZKl3K+m8H9OKg8I7upQ3Sm3biCu7kZp3YscuOq17nN8QNXYU7tMbRQjwEQG?=
 =?us-ascii?Q?2YtN4mstRlrVat2nnlljKc8S/xdIaOT9M6Tb09uH3d2+epEHM7GkZPgnlc4I?=
 =?us-ascii?Q?jNatNDia2qlCtyudp/ZnDdVnUeE8qT8tNh1frKuy07rgTGftbo432kz+h/6L?=
 =?us-ascii?Q?cavbo4Zmx0TYGpr29Y820OZPMxp2ZjNbP7P8FMyLdSq2Z47VcKxquNLk34xe?=
 =?us-ascii?Q?jKiUgdO6pCzrpq6beQpSM7MeArtW7LvPUkay2Mn1PhyWtVvspQJglfTG8jZY?=
 =?us-ascii?Q?IOALXwZ5n/xx4tAjvxGhQNorbm4gsFe8Yv2d+PfzEkVsnJp1Ow/THLPqUOAi?=
 =?us-ascii?Q?/KuGvhLRGfJatFYK5mHDxYCZisYoPlatALV0vbOGlWHfQw3ozfPo81TT3ftO?=
 =?us-ascii?Q?YaFwbsSUyhcUVargcPilHYv/Mpy10KxdO5WkXe7/0QZAxhsZPpv3zY49GXMP?=
 =?us-ascii?Q?u/NDD5vUAhz+nGG7Z06XDYwKvX3GnmchCKenm+hzGNGAg9UMUeFNRhCNqfNx?=
 =?us-ascii?Q?Q/I/bAY4aA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d1ea41-d04e-45ae-4a0c-08de86aa91c3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 18:00:28.2839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HdmOmU5jBDEutd2ZPTGdJN5QDDZl4EB5estb6Teni1ky3iCM65kKNAXO0IfGPbnB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6993
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 95B331C0028
X-Stat-Signature: zsdr4x17fbytbyuwqspsr3haohynemqb
X-Rspam-User: 
X-HE-Tag: 1774029633-778452
X-HE-Meta: U2FsdGVkX1+L2QFkkDUTD1ldhiw5WJUfZWEfg2RP51pefLhflW0KudvpmPaGxSt4x+3vY5Ni/bYllz07fLQjWGFU/R8kXJb8t2pWCKLrpI//gK1W3uvJ91ceNqfF9lXVjjWG0jk6v2RdwvMu4TVEc2BJaKJwYUHI22EvAgrhZIYwgP5coAgQim9Jrqe5hAbzn1kK8J/75PaV6RuZwsQoVO2JHsWe8BnKdqoURJFOGLO+hcfsBlQKF4dNty98FKgH5p6hTzQP6BipHNwB/5uPNrf+IjyGZg8wVWn5L6AJ15RwR08hKEzSHdf9Uj427O13Dg58/aU5ID7meMjbvixZafBeX4GEECclX7r3dbUWk5BZ0QFTMH2cwO82ejrM02mkTV9YfJz58nybeqc9+TMsqCJE7QBeiE6lKWPcHZA30HHIqlzOEG9c4fz07Gkjr6m+yINjbqjIJwWK/kQbKV57OPGHTBuC1gXLmXHcvU8IlNMn+ESaVaVqJ0V0MZ4tkvnyYT5AiFYqxk6QGEak51/+5X2CpQoiZLIlMMvxvzrr1N4Uj914UKIEBB8SggOm5QLlHvBhyU0BeJx862p+wmu13yh2bV94SIM2jbEkMrBxkwlx6lso2dk0F1iL2KdHb1F0QaxTWaYvDMz0qpnPsugxC0yLv/n1X/jJedxqHJANYuZdK2ZQADqcj6zt1OBxbglEZH3c+PQwz0KUP6alXGXVN/aysMeJmn7Szf0M2f1Ucdi4N8jggHgB3SJYTjdQeb6NseCUTL0wXdAYvEf6k9wm9KjYfO6YQDTn70CgFEdfeM/VfKaiFXCP67kRoXxENaeH8lK3ekq16w+wfuUEZI10c4W48nI+cUzs0phk0lurT/DqacEXFLxZuXDySuS1RaB9xTl53vgAVJYYkDKym8nodylTaNwkgBondwJrmJDvb+MgyzUu1wTWB7yCb1IGHezrtOxNqm+8PR93HDWfjBo
 aD7+3aS4
 XQ8/ICtYg+dn+290Hs6mdmxUjSbAXuJLn1wDptMvCK2widQ6ZQ3xq/PjM3kpe2R3miIwZBgNUxIiWxFwuvawPae+Zj2S/DvoptH4qbeZk/UKfZyL2/CZtGBDdTKCW5Tc/kMyO1xC+FKrxkMc/TObnrJxofIHr0++H2UyTU2nXMPvyBHfwixLcZrqG4xrqSqRga42PSB1HRrjIdXq4ojp4p7093NHqG3lBA+Om1oK4iOcMjBJGrzyvvV8+v/NrvAI796RcmJAjr7FHGaMjezfnWG2Achz6lQnrBISYJ0eshTTYtEKDzdD9/fu4FCqSihxxbBe0tLQYtdkaTGCQLtD9hdwxrPXIOmLsf56QajiCnnPGW0D04HqMdASSBenfl09b9ttxyf5qAe6+H2UemQqIa8kOSHHhe2nEkraNCfVcBHmltROmUYhjOrpYgeAXBO15w5jed07/vAPLVVh6ABWR6k8uXPpW/ux4k2D9yZJFsDtQM9eEJkmlQauy/JzpKLwAngZUgEwHXJ0sC8gSGYIWP18hJuQ4pzlcIki+PNRq1qHcZcOPvh13lXxw/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Mar 2026, at 10:22, Zi Yan wrote:

> The added folio_split_race_test is a modified C port of the race condit=
ion
> test from [1]. The test creates shmem huge pages, where the main thread=

> punches holes in the shmem to cause folio_split() in the kernel and
> a set of 16 threads reads the shmem to cause filemap_get_entry() in the=

> kernel. filemap_get_entry() reads the folio and xarray split by
> folio_split() locklessly. The original test[2] is written in rust and u=
ses
> memfd (shmem backed). This C port uses shmem directly and use a single
> process.
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
> From V3:
> 1. fixed for loop stepping issue
> 2. used PRIu64 instead of %zu for uint64_t.
>
> From V2:
> 1. simplied the program by removing fork.
>
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
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../selftests/mm/folio_split_race_test.c      | 293 ++++++++++++++++++=

>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +
>  3 files changed, 296 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c
>

Hi Andrew,

The fixup below adds folio_split_race_test binary to .gitignore.
Thank Lorenzo for pointing this out.

=46rom bd164a7090c0e8b6e3013502c64c161214e38714 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 20 Mar 2026 13:56:04 -0400
Subject: [PATCH] git: add generated binary into gitignore

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selfte=
sts/mm/.gitignore
index 83ad9454dd9d1..b0c30c5ee9e30 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -61,3 +61,4 @@ guard-regions
 merge
 prctl_thp_disable
 rmap
+folio_split_race_test
-- =

2.51.0



Best Regards,
Yan, Zi

