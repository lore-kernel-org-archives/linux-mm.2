Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B856FF60CE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 06:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD516B0099; Tue, 31 Mar 2026 02:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A59D6B009B; Tue, 31 Mar 2026 02:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA5C6B009D; Tue, 31 Mar 2026 02:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0A46B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:35:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A59C160B10
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:35:16 +0000 (UTC)
X-FDA: 84605396232.11.EB9B715
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013052.outbound.protection.outlook.com [40.107.201.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E02E4000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:35:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XmvThVsY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of apopple@nvidia.com designates 40.107.201.52 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774938913; a=rsa-sha256;
	cv=pass;
	b=wVamT5LCVcMAJpRNZGko9MKtQKz0A7gP3D8k4iXDa1L7VJ6lyFAfLJ4IHmITahKWBoeqJi
	XFB3SOtWdLIAIFJtgHaOnrxR188hxXXNhhy0UrGGNkSUf1jqUKEfMbXNFGoEW7B6dZcTvz
	X0CP5nsJR8upU2MK8bA7a0c8ZOQgBqk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XmvThVsY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of apopple@nvidia.com designates 40.107.201.52 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774938913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onh0xecJPor7saZ1Yw03mb2/rQXDP9YLm4UZNgkK2Gw=;
	b=rWi9lNN19BTrSFuTdMI4R9hlHa0vZWKLI95YQXw9Cx3PFDD11FW7K/mIj5JUVyYqIwN43D
	Y19ZFWXauGovAfgMTnX5IYyK7xfLTAPgVcAsWyAUX98GUOwRrtY5FFeH/kOA2lYyGcnwm9
	WDuTHCsek1B1SuqQwM4Rnt6jJ1rUhT4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I6UZoMcfelKjBbKPRhNVYqbJndri2RniBAfW9olQYcrWhp3SjGgBRGFBMoWlJ8OrlGGUub5UwXiLI6QaLW4NVC6wDHU/gogjKHP08MVYTdQfmvMCGVelScYUXEWD4gqmmCy/DuHGTkB/DDZrKscSdiDCPp2rwVdqbox0D3dxAuDm1xU6/GZHfghaaWD400O9Y/DEnmMMb1R05o4Z2Gwhjy6cj2hy21U3H+NV78oDCU2rXbwL4we0DyBu3AF23LkVvgvDQdrdgSWErxXdhooUxHrv5Dv/WQSuB4FfbY5UxZgcPY3wnedPtrkdo2tM6GUOkNuay8ETl0X+WCZgwgoHog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onh0xecJPor7saZ1Yw03mb2/rQXDP9YLm4UZNgkK2Gw=;
 b=dJi1zuJbsODey8bfUj9TJ+xL9ejZDufW7pi/og+NuPaZIZU/SQATxSEhcHNaOAQoJxy8GXTNAiit6nwVIjt6b1wYPX3NRyb9mlfWAK4okceKnpUeYX9egrZpTTOMgwRS1OdeSylYIdSPXxU1AZcU4EN+ba14wGUpCo7S0LUj7cDOcid7IfaiZ4SafX7qGVsaaU5xfbzrDXicnzqjVm4l+drgcbmoTFeLwxYgBXDyosLVw+igVKx95VH3X4ee3g8p3hWEajeyf3+8uDqDFvbF6ToOEJwSbcVZlll8F7evJLz7cl29tmqm11+zlUmpxMER4Ri04GsKBFGl7XJG6AGE/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onh0xecJPor7saZ1Yw03mb2/rQXDP9YLm4UZNgkK2Gw=;
 b=XmvThVsYvBRU513LgW63EhEQlyfyMuVu2SfLjw9f79mwN2XmFgRKUU7fW6tjebcP8cx7yAxiU0+pygfkvoRAn0CsV+o2Kc5+ZUXcM8/NCVPPaFKfRJkTUAQ6+VLO/33NAlchsXAXjmBT2ZtQkZGkn6YRXh6ACJoIYTWjKXRj5xB2CbkNIf3JDU/6P0zOIo9hVxmzfjd/epqq1RRy9h2CeexoQRUmiAmyB0Av8IvdyTjQgqcNMKx2B9C5TrqAdPU1sWlu++5iIUHzjxanOsvop9f81vgbUSuoXGAkMr9Z96CoopY56P9cBGtKpRd2gMBzA1/07whsSTJ3cgPCWsea/g==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 06:35:09 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 06:35:09 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org
Cc: zenghui.yu@linux.dev,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	dri-devel@lists.freedesktop.org,
	balbirs@nvidia.com,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 3/3] lib: test_hmm: Implement a device release method
Date: Tue, 31 Mar 2026 17:34:45 +1100
Message-ID: <20260331063445.3551404-4-apopple@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331063445.3551404-1-apopple@nvidia.com>
References: <20260331063445.3551404-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0146.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::7) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MN0PR12MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 06db78b7-f863-4952-ebb7-08de8eefa75d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	sEQeDRADUwY54whjGGYwABymwVmDcyDzBapkJl4eF1TK2gqphFLKcYh0Lv5EV3A+Fn1aFfXBB58vZH5kNcL9cAvJtj9uDoZVUL0uluK7jEg+IP1j+l+1fFTOqryRAhtSMMekuiT07evhosNd8LCzhdzSKRP4RCDa3eySstVIyuMSyvsjUhxw9+fT+KZll/zccMkUzTAyBlCs/iXBhbij9yWrrmXhqjmSPzMk04E8sLra32ESVz1tUseqkdpkjO+Kt5QcL5XYjB9E4l5OojdqcNKUh/pjXeICILGSf4n2fkuL/aW2DFt54XS6MwjIMI0aBs9in0s91Aq4EmSeAt3fiJxqfCr/w2jwZ7V2dM9/7CKiRrwj6eYSl4r77QF/FnMW778w4U84pStaJ3PBzgBb2I3FoOR/FqAD7jOHhvyW/5TsFj60OPtTbbKN0hRaWFttYMdxmo8/lyTYbt3utNVPSWT5jdKUZBwE6k4HEWz8JmZK38JlXxZUJls1frkIndxBLhFmGq0JF2RPoaqKOQgJm0iDZyw9MwXIWbuFjqfe4FrhzAl/GVuX6T8WEd39ocGTAtiHf2wQVf4oEn46SRvm6BxOQIStwlCZ2CTydXPOjtn8rxbK46vx7tq7TAUIa6qVJCJVt29x/0NGqoyZaceD2p/ULPq8opBmWmTiuckxZ7kOltd0GSsSxzO/8Q9QXeR1N3KfJeacoUk6FjZ/Ne5foV4IgFxdC9s63ELFYLDyinY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZBumgQGvdRZkgyEEfBY2koAWFapJp2lsnq6+T/4d8ES750ZumLTelZqzaDw6?=
 =?us-ascii?Q?l7AfQl5M/pqxcy6BrQW31NYrsAFu1DVEa7olgBUmRL/+0bhJ8+gVeJwJasb5?=
 =?us-ascii?Q?GIC9GHKpZmhoaCpjvfZNtigesPfxDJVxnhMzLm/p9rzF7dvDX/rkajZ1AtX0?=
 =?us-ascii?Q?yTmO3x0oBWakxylzp+rXE6VzcK+QoVMfyTAfiJqQtgD1IH/u0myxRFTj4FZ1?=
 =?us-ascii?Q?v+0gULdwyGTskNjIZZH/U/JrJVsKSDZ3w8LDJOphdhUxS/dmZ0WC0E4HHfQc?=
 =?us-ascii?Q?fSFcPo3OrMon67Q9Q/EJ50J6WvsjX3ET5GhrFTtRyflbYbNPKO5UYLZrAJLb?=
 =?us-ascii?Q?keRg/0xhw/D2A86626eoHjoxxifT6OOV/OwWCf9izL2VNJQAa37Ktm6XPZqm?=
 =?us-ascii?Q?NkqVSCWMFm+2dfaehGjMv9WAJRw5qrPU6ud0rPE3EkCCEqYNK6HP28QbRMGX?=
 =?us-ascii?Q?oGf0Tdug2xU0whGWkPo5u2HesIUp1Jfn1BkscAyfakB8VLeq90Bo2qiUNssN?=
 =?us-ascii?Q?BqsboHMNxKrPbmmF2pUqfuTdQAOwtO4YatSFtuz1r3aKnUcuLT9pt1qT8j3V?=
 =?us-ascii?Q?SGFTXsKTHkr3SwfQ2zyJQ94TM9gPZzvVwTjY03ZqPNB/QBsf2H0d3JKpkOGY?=
 =?us-ascii?Q?WOzQGVrJY6Wmp5ZnhBXUi0EmQq0KHfq7Opp1koS0SBIGegCdyEI4xhs1nMgL?=
 =?us-ascii?Q?P9OhLX6BI/o2X2xQg4GXIMO/JQRWwdpTBVkpDNYmuFrNGm8lf9h9E81+TADU?=
 =?us-ascii?Q?NIiL/QjNW8ld6axvnwQeebmWKEj7wWBYMTxnBxJjijIUafJHTSATfy+Z8e9y?=
 =?us-ascii?Q?J0FLRjgkQCVzXtz3Elk8C4sz4nSVdeN9PkR2c5GEJcZmnE//QxfiWAxfedjU?=
 =?us-ascii?Q?2fbYQ71PLh8w6SCx1r1BpYp46bbUpME5PsPYImL/YZNog+G+m8BYtunKcObE?=
 =?us-ascii?Q?nUwbMc2OwGp/wshrpAnLQjWSjTXJwU7FubZA8KXKirxoQyl1zBbR2Sx5Bl5I?=
 =?us-ascii?Q?RxWx8KdYry5+2d7g57/1demnoZvCPIdGkK79AEbtiYlj+Vph8LdpGQpVt0vF?=
 =?us-ascii?Q?Vu7hBOtcbV+KOivhF3oQl54qOil8a0CE8bJuMoVi5IDUdlg9OZ5puSYNjk4c?=
 =?us-ascii?Q?4x9/ZnpsMq1XAEcTvz1WoL8OorCqd+ZfIc1W5b5KaQWfS0sHa9hJVcXVj4Q5?=
 =?us-ascii?Q?v4PD9su4TvGVnerK6U0L/VXxVIDmudxVoilRb1rvcEb/3BEBVDqt4pdw/7p9?=
 =?us-ascii?Q?gB6T6hGxiPp57GDeOJdQQEKMFqEXiyD8oeiYPu0SzvT7vgRQpzb3P/QJnAeh?=
 =?us-ascii?Q?UUces9ym1P1AltXET01OPcwQy9SqHlfFEv5oHJZKLVQfsSFDkT2KuaR7Srvk?=
 =?us-ascii?Q?LpKHIlglP/VCTJ/MMKBf9okBbEu8PT8HlbC+bIo1WDnXUQOap+oUfLt4Qdlk?=
 =?us-ascii?Q?+D0Pm/19mv969oE+67N/e72Re3ozEAXZ86TtOKOA7WHF1ViGgZMR5UWzU75M?=
 =?us-ascii?Q?XOA+Y/ugOn7XlWzYnQOFDMCXp1i1nejR5mWTTEhzKomtq7pVlTMBdMnhT5gm?=
 =?us-ascii?Q?wP3rt5shbNp3/PvD1njU+Tct8oaqWvL5s8DFaGMiKjLkr5ogzBI5NnD+tDhK?=
 =?us-ascii?Q?yf2hhMaUy4OtNVGVl2syzxL2VGe/FIEzdfjN97NyBuKw80qWHnbzBzYYxs/w?=
 =?us-ascii?Q?SDfX0R9wdtic6Luaw7fRvXWAm4mpeZj5ocU6X8N/shgQuCANdQXiUjTzTBRg?=
 =?us-ascii?Q?1c1FxJK7DQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06db78b7-f863-4952-ebb7-08de8eefa75d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 06:35:09.0781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRfIqsM48HGjCF/nc5TAgcpGLPZrwfgIerP6J/oEL/DKRoPv7zrKjTl2K8ZSWpwOJG+KiT3M2gqZbsf0C0H9hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6150
X-Rspamd-Queue-Id: 7E02E4000E
X-Stat-Signature: 9j6c9bhrr1m6br4edkk1snwey3ysxohy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774938913-766622
X-HE-Meta: U2FsdGVkX19/aiECO8haMlqVsQ299GHmMuQ+bPypvBClRwTq1H9BCf0fQj2qqecT8IuBnxqvPamqePmlUjgwepnzOsnp0ZtgRb/cYhk3swRVxdZl06yR9ovLFbrpAQEyC+xnk3jgxL8je40bArCJe9AejQL3g9FgiJBmFeWRrGFJwjGw/69I4nuKgBxz6g5ASyR5+0SjTDfJVRsVq9roj7uvCJ0kbmwz68FYc092zr9kmcV+grhYRt3vrs7SubQJVLgUU+BYlGnXrwbdmYHP+EyC/sOr8ZtPMm9puceNgp5BQUET3FTxNY4S/a3Cns+ETl7MCKMz30wYBoej1mRRD6TMd8K9GRh2kTtBLUzKAf3iqW5TJQKWUaVKl3mWfMkAf/d5MSjqUoG1HwBfm5MEnEjFecBu2o4dSjk/mCiIHOz0gYfxqtEBcnyvYL6y49v6e8MvTL4pOfQy9/DYQOjN15EBk3V9cUnibQz/tVd7FqMDiIistA+m1fIT/xv0KD8Ya/ELzLicRHhRCYTVQ8n+XMKVLj7O6a4yREu5efNp8XhrbdYI2q/1TxSTtTtYpcXfG6V5GI0gCe3ILz34MflF0vQQvPYDWeb5ox7GC2huCmOEiZLxfyLMdtiyCJqrVT5VBBAr2Ki2M+8/v03Iht6cC/4ytTc6U5oNLIlBE3tdr2C94OUN7GRGNsP4+CatCLEFvXM+FTJPIPicZkm3Ro1jKobVw2s3IFFTzwKB0XzYtoQ8WlVe9xJZ+lQJy9zYPy/ZXzLUApDmMTAl6H2ZBtq4pVWttVyOC+3KSZWekkx2AGD3pdZKQcQoWeyiReVtIl/PCZ+wLC6pFqh6REZ1pN0Jnyir+9Gnycf2z3CHRBUt/PrWMssZNVUVirNUst1/jozB8Xu4c7m5TFL9TxR+vuaMphMRInnrsvtlbVxmEl+IQd2XVqgkiWE03NE8fUEnRM6JHwnvBfBlOA+hWAiepvG
 k8TazNsQ
 BPdzkPWX1+MwpCMnqyNKX8a2S+JXM+0ElPVQuMFkzmV9ApNYnnOXLGnmOY3vFbc46qV71cey5t0jbFj4RTvhXzFGr7q6GJRVz/6DWIih/E3ZzGAe58FXTHD8sNjdu0z2XgmutuwfuduSPN69ELZf42g11BdGXwAOLTgnNyQnHiBn3/Ywh1ONcWUPujZMKo5dG01wYjgD7+AVZGH3XvyhPnK6GCzPFBXF11tlKq8Ih8oBVIwEJKQ6XUQql6bHL+JNtI9/shWoAYWiWcNw9idcfSF4XPe/pvMiL71V2kI6yepHB8nESq+2efobaMQiFnRrQYueoP+FfMFqbPEDf5uA5qqR3D+m8zOCB5j2XT6z0P1gCmy2K796yHDyIvtH6d0CTeLRzVVfONV3vZRIqi++8bmtBkwWPCVZfkvvdyi263hrt2q0G6KrREZ8YKy7RpaWV79kXc4xF0jUZBzV35fZexNdzU129iI43DE8EAG+4HZGEK+xP7YTsMkASVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unloading the HMM test module produces the following warning:

[ 3782.224783] ------------[ cut here ]------------
[ 3782.226323] Device 'hmm_dmirror0' does not have a release() function, it is broken and must be fixed. See Documentation/core-api/kobject.rst.
[ 3782.230570] WARNING: drivers/base/core.c:2567 at device_release+0x185/0x210, CPU#20: rmmod/1924
[ 3782.233949] Modules linked in: test_hmm(-) nvidia_uvm(O) nvidia(O)
[ 3782.236321] CPU: 20 UID: 0 PID: 1924 Comm: rmmod Tainted: G           O        7.0.0-rc1+ #374 PREEMPT(full)
[ 3782.240226] Tainted: [O]=OOT_MODULE
[ 3782.241639] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[ 3782.246193] RIP: 0010:device_release+0x185/0x210
[ 3782.247860] Code: 00 00 fc ff df 48 8d 7b 50 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 86 00 00 00 48 8b 73 50 48 85 f6 74 11 48 8d 3d db 25 29 03 <67> 48 0f b9 3a e9 0d ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 89
[ 3782.254211] RSP: 0018:ffff888126577d98 EFLAGS: 00010246
[ 3782.256054] RAX: dffffc0000000000 RBX: ffffffffc2b70310 RCX: ffffffff8fe61ba1
[ 3782.258512] RDX: 1ffffffff856e062 RSI: ffff88811341eea0 RDI: ffffffff91bbacb0
[ 3782.261041] RBP: ffff888111475000 R08: 0000000000000001 R09: fffffbfff856e069
[ 3782.263471] R10: ffffffffc2b7034b R11: 00000000ffffffff R12: 0000000000000000
[ 3782.265983] R13: dffffc0000000000 R14: ffff88811341eea0 R15: 0000000000000000
[ 3782.268443] FS:  00007fd5a3689040(0000) GS:ffff88842c8d0000(0000) knlGS:0000000000000000
[ 3782.271236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3782.273251] CR2: 00007fd5a36d2c10 CR3: 00000001242b8000 CR4: 00000000000006f0
[ 3782.275362] Call Trace:
[ 3782.276071]  <TASK>
[ 3782.276678]  kobject_put+0x146/0x270
[ 3782.277731]  hmm_dmirror_exit+0x7a/0x130 [test_hmm]
[ 3782.279135]  __do_sys_delete_module+0x341/0x510
[ 3782.280438]  ? module_flags+0x300/0x300
[ 3782.281547]  do_syscall_64+0x111/0x670
[ 3782.282620]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[ 3782.284091] RIP: 0033:0x7fd5a3793b37
[ 3782.285303] Code: 73 01 c3 48 8b 0d c9 82 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 99 82 0c 00 f7 d8 64 89 01 48
[ 3782.290708] RSP: 002b:00007ffd68b7dc68 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 3782.292817] RAX: ffffffffffffffda RBX: 000055e3c0d1c770 RCX: 00007fd5a3793b37
[ 3782.294735] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000055e3c0d1c7d8
[ 3782.296661] RBP: 0000000000000000 R08: 1999999999999999 R09: 0000000000000000
[ 3782.298622] R10: 00007fd5a3806ac0 R11: 0000000000000206 R12: 00007ffd68b7deb0
[ 3782.300576] R13: 00007ffd68b7e781 R14: 000055e3c0d1b2a0 R15: 00007ffd68b7deb8
[ 3782.301963]  </TASK>
[ 3782.302371] irq event stamp: 5019
[ 3782.302987] hardirqs last  enabled at (5027): [<ffffffff8cf1f062>] __up_console_sem+0x52/0x60
[ 3782.304507] hardirqs last disabled at (5036): [<ffffffff8cf1f047>] __up_console_sem+0x37/0x60
[ 3782.306086] softirqs last  enabled at (4940): [<ffffffff8cd9a4b0>] __irq_exit_rcu+0xc0/0xf0
[ 3782.307567] softirqs last disabled at (4929): [<ffffffff8cd9a4b0>] __irq_exit_rcu+0xc0/0xf0
[ 3782.309105] ---[ end trace 0000000000000000 ]---

This is because the test module doesn't have a device.release method. In
this case one probably isn't needed for correctness - the device structs
are in a static array so don't need freeing when the final reference
goes away.

However some device state is freed on exit, so to ensure this happens at
the right time and to silence the warning move the deinitialisation to
a release method and assign that as the device release callback. Whilst
here also fix a minor error handling bug where cdev_device_del() wasn't
being called if allocation failed.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 lib/test_hmm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 79fe7d233df1..213504915737 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1738,6 +1738,13 @@ static const struct dev_pagemap_ops dmirror_devmem_ops = {
 	.folio_split	= dmirror_devmem_folio_split,
 };
 
+static void dmirror_device_release(struct device *dev)
+{
+	struct dmirror_device *mdevice = container_of(dev, struct dmirror_device, device);
+
+	dmirror_device_remove_chunks(mdevice);
+}
+
 static int dmirror_device_init(struct dmirror_device *mdevice, int id)
 {
 	dev_t dev;
@@ -1749,6 +1756,8 @@ static int dmirror_device_init(struct dmirror_device *mdevice, int id)
 
 	cdev_init(&mdevice->cdevice, &dmirror_fops);
 	mdevice->cdevice.owner = THIS_MODULE;
+	mdevice->device.release = dmirror_device_release;
+
 	device_initialize(&mdevice->device);
 	mdevice->device.devt = dev;
 
@@ -1756,12 +1765,16 @@ static int dmirror_device_init(struct dmirror_device *mdevice, int id)
 	if (ret)
 		goto put_device;
 
+	/* Build a list of free ZONE_DEVICE struct pages */
+	ret = dmirror_allocate_chunk(mdevice, NULL, false);
+	if (ret)
+		goto put_device;
+
 	ret = cdev_device_add(&mdevice->cdevice, &mdevice->device);
 	if (ret)
 		goto put_device;
 
-	/* Build a list of free ZONE_DEVICE struct pages */
-	return dmirror_allocate_chunk(mdevice, NULL, false);
+	return 0;
 
 put_device:
 	put_device(&mdevice->device);
@@ -1770,7 +1783,6 @@ static int dmirror_device_init(struct dmirror_device *mdevice, int id)
 
 static void dmirror_device_remove(struct dmirror_device *mdevice)
 {
-	dmirror_device_remove_chunks(mdevice);
 	cdev_device_del(&mdevice->cdevice, &mdevice->device);
 	put_device(&mdevice->device);
 }
-- 
2.53.0


