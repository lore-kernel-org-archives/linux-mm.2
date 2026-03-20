Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926C51098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D956A6B008C; Fri, 20 Mar 2026 10:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72886B00AC; Fri, 20 Mar 2026 10:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82D36B00B0; Fri, 20 Mar 2026 10:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B744F6B008C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:26:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 606EC8A059
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:26:30 +0000 (UTC)
X-FDA: 84566666940.03.FF40F23
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id A80338000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:26:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QEnHo8D4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774016787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCCNKgSGeEB3xvqqD/+BmNyonVPTkEAQYM+BHVt7uU4=;
	b=em1todLzHtCNT5bHqKDPJYCTafme4O5nUDvz2jISHYS3zX9BoIy2pyXyW0EHdmAVv+3sJj
	h2AzrkKJDA4mgRKGeAruyPjawRrr1e+qZydL8cROW/lbmUfwtxc6OujCMh/gfR7sXPg+FM
	RQ6N/Y5w4FOOHK7AWubjxI6zMooAvpg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774016787; a=rsa-sha256;
	cv=pass;
	b=TrMKM5oxz+eh/7VWvpB4wxwq7aRaqHCEGUIRJkKQCdr6jQzhH2g6EbaLFICmWlF3D4bTkU
	NmlhXnzNZ/nyVzd0XalViEVnA7AXrk0llfKYtmxQupLTkjFz2Ns9BtSM/7eBiiKf6WCYqQ
	CIMK9QozAwX0TAEPXwBfhZEcjZChUpI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QEnHo8D4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4/gwdl7jbWRTonbsEqWaObbGb2+yOdCBqvr1LAtL2EuwiK/ofywMte0Ar15f9hJcax4VudUziHZxV75hBcGu5n6DHV+hrE9nTq+I84aP2c4dxGtYSGwfTTD9sj8F+S3u6u6MLzGhXm9XHURx7sUTh5WCuKHVm0eYPIOcMsTnf2Ol7mGOpc/Q2ewA5QyFyt/B2Zit6z5T/j8Y0CD3N/iE5djpcRxuUuhM4Ej1uE37AGGVjXdo3Rq1YfKvGyCl9FL+AfJaMMqwg7WjBEDnP/Bb2q9w+J4e/B4ivuFUQXIjjGPNcqMMqdMzWnCAPeVS5EibHfEpgvJEv2Mlk6NImqTuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCCNKgSGeEB3xvqqD/+BmNyonVPTkEAQYM+BHVt7uU4=;
 b=qw7nUGtl22YVKeD72iNaf7EWp2pGU1o7MQh4w7Z2HqUevPaKb1mT6qUy4XJMklAEguCauBqX5mdf8c4s6LS4AjRJSE2uF1oaTDDVHOB98l57Mpvb/Gv3iudAfVGYtqXHLK+LMpNHrAEhu3Os1YIJ3yjX2t27VNUqPe0Uw7pB+jJMQDtRzL6s8gUjhbzDITd0Deb6hfO8I7KSehoDbJ9juITV5CRgjoohbWDMUtVE8lizE2DP1LggJLXV8zWVHmIsmIOWSCgCSqUztwJWbxSJ9ddJE+jXPJ/KeqA/di3u5eTRXPn0Bo1ZTC6INANvjwMeTKcp+4ZwGGAqOBvw3q5b2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCCNKgSGeEB3xvqqD/+BmNyonVPTkEAQYM+BHVt7uU4=;
 b=QEnHo8D43BHX+jim/aweSohkWygDIfRPBgAQi7JD4vpVj6uxaWG3Q7IE8UzkjmInqgj72Mll3ZyiGdM0P1iEFccGQXw4SyLxYicOHORKyLgc2nVXKKyMdKk8DMRYUMWzb+YgIfzSR+mvKK7HPCPYAXELiw0JGZ6GnNbosl0kqxvEK/arKCFkuMsMVSSGWsqRDnGEDE5C3nw9aKQMwYewhEvecrN4eIuMnKzqYLleALuCdUqdQ410nqdZc3Lh4m51ZQrBJifw63uatTEDtMiS2FzRizEwkrIk9NswFGrlVG6fMWXaAlItVUjykG32aTi3SBltrGsULhXnHHtlRdDIoA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH1PR12MB9645.namprd12.prod.outlook.com (2603:10b6:610:2af::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Fri, 20 Mar 2026 14:26:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Fri, 20 Mar 2026
 14:26:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
Subject: Re: [PATCH v2 3/3] mm/page_alloc: Optimize
 __free_contig_frozen_range()
Date: Fri, 20 Mar 2026 10:26:11 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DC90BDB1-31E4-448B-A94C-AC3D28D26C83@nvidia.com>
In-Reply-To: <20260316113209.945853-4-usama.anjum@arm.com>
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-4-usama.anjum@arm.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:a03:338::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH1PR12MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: a32d9558-cc76-40a9-b13a-08de868ca5df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BF5OV6ZYkgAh70SW9z0mXpBJh+YQZVKs7eH3CsNZkDi1TTGLUbqiOgCA31ZXzrWuPhoVviLF34l9qLn3D2YSpWGwLt4O1XEbGvlco1rg4fo7JdguCPaxb1dgztTCErc0NtNF+silabe/0b78xxhQlad4k6ixVCFPfyQ67lwS68LT/KpbIZCRftN64F8AV4sJV0VUy4SCXPNwKVCuSEjWThITu39naGA6xbHMcQ2ZJ+Ft3lR7Ab829tYcZ+zcWOBy0fkLOkCt+75T5Nn2NG1wMQTBC/lui9IpVxJcxy2EZWPwtAGb8INURTxI1Cv5XO9asPG5fQ3pVvVBMPZ3+9yXag6LxYJAMEV1WoUhyE6lzWXRDigJ76mPMVAK78v94AW5dxvi794XCOVmz3J58SEVOft8r0BGpA0kjuHcyI5JYic17Hbw30nX1tERr8ek8sCMW7WCRiiOcsdm0UMmFvL2ZIsKz9T4Czc7beJ5LZuPliMWGnfk7gtyo96cbhD7yHnfncgn0j70lTOjGb3Uv6jA1yksNqyVdp6XttxEjm0lmT5L0RIKgZGDRktcqo15R+KTp7xy4u13mfc9aZt2QNZBJ9wxWxdnrqN2fYIHxAONTa42VEH9ziqlYFYeOHNOdnD+o237E9Bs/SWwRECHSKGvOluOE/O9n7flGzNxmVH2jnvJLQTKDvc/Ets6gWokiqqgot2Btm/QAs2CpRUuKAiNDpIUIoy3AEXXfw6fLLAW+Pg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XORPX015gryBHuq/nXpbsOI2AJubA60cMQmlC6vwEpVmZ8WpRYaPns8FkMh4?=
 =?us-ascii?Q?JM4xzJjZh5jFtm+IroG/3HBQogGPqau8Vp3wdLVWwmhLvxj2A7F6h34L7fk+?=
 =?us-ascii?Q?45rj+K3he0YkJqFdoAlOtA3kFMpQrBDCBh3pw1iKJuhWGnnfAmXD5jNHMC3w?=
 =?us-ascii?Q?8Mym1dcs7dCzyhJfs662RSHMLOkfsBDAS5ObRjd8646krNZKu7yHEG0VPwDS?=
 =?us-ascii?Q?h1KTmT7XqtjcGnp07+ztY/mErKzWUkumrd1lOKsmzVLegBHkn2sG4piAPlxy?=
 =?us-ascii?Q?uhgNpNBgzcZXL0EGfGgiFuj46qW/Iwur4XKC8obJd6oMHkCzilRwzlanJIsf?=
 =?us-ascii?Q?3RYAv/eI3CvrqJ2cmNFEXFe4plVEN1UXsuqy0uIKSDJiSNBIE6tpzSD6DbPi?=
 =?us-ascii?Q?AETh35dT19RMYj4tySFYnmoEG62sByCPStJsspULFVgCSqKR/VxqY9Vbzx4n?=
 =?us-ascii?Q?g80xa6FB/p3/UzK2R3YOklitenZ8yUsmKbNfpUWqpMbo0T3hswpmtz6t4Drf?=
 =?us-ascii?Q?gtnjCzWzXBBV7fGltFvRXGRKyWxsSsP5YQJHHw8+XdTDjdny2nlQv+qR+OXD?=
 =?us-ascii?Q?Jab9Ao6jk99d9zCKmhVjcSQlJXR14hbUYkOJEog8NfK1SEuVdjvI+2ygbMwW?=
 =?us-ascii?Q?JuhMgXmCSLaI739LYmD7xlPlLbc6xs/Z2vc25z4ZTeo4CQ+LqXtRp37UgwX7?=
 =?us-ascii?Q?roT3OzeIzXaAyuu5J96DxRTWB4XMnkFbcLpS7eHw92waNrvJwvtnHsgmAdG5?=
 =?us-ascii?Q?n45y8SGBQn1PtMOqGAunpI7cHvDZ4p9eNsE+K0Ov/wH4m6KdM3bAZ5Mp25Su?=
 =?us-ascii?Q?0SSHBhx7Q5tgKQ3Xr5ydaCWuHn69IOVa0NQyWWtyHzzUH6UKtBL9QI+35vKJ?=
 =?us-ascii?Q?rD7IdF5RaNudP9xM740Pr9u1ERbZ+2Niv1KwVd9fXKPJyrJGtJBYMCoWcQlE?=
 =?us-ascii?Q?Ktd9Ra65iuSv2ZmEtFpYP4Z2VOyYy/xc8wBHR6syGxYsqSQ6yJsDhHeoGaxO?=
 =?us-ascii?Q?eN2PlS42Aap22Ee8sVtiBmAOKmeCIWq38pFQ2e1tmLcGrPu9h85O3+2wBX12?=
 =?us-ascii?Q?Uiwr+oDt40Sj7M1DdSZPds2G0bKSLpW+dMVZGD1CObT6rWatMm/IELh4G7G/?=
 =?us-ascii?Q?/W8WQt2eYDLY1ElN4F3wdmGqRsSat5w+LDdnieEYHo1vh4W9QEwANTX4b56Q?=
 =?us-ascii?Q?t7K6KEBnUcznFNfp2XzbROUitRmi3rfrmYdGolU5oIYv4CmDc+Uyxuw13OEP?=
 =?us-ascii?Q?dfrDYx/xflgpei/WlDouuvqhSu6bLvScoioX/5s3UDb0Q9EFFpQLVg2Qd5UU?=
 =?us-ascii?Q?2th3jMaSuKktd/okMpVgigZGXnj1ERV+0ayVy8EF4LZppPmkBLK7TyiQP/7+?=
 =?us-ascii?Q?g9wuXTueKwroWxJtMH+Qlgwr7Rh4LT8RaEYpvYULgGqJVSAaQJ+q0yG2D5WN?=
 =?us-ascii?Q?zmBAf387sBEibNMpfKHmTk22p1YcLGay5UzD8nWW4m61UXiojnjeIh8AtiNX?=
 =?us-ascii?Q?4xiSNB8VF2jzYekRgdldGHZ2wgQf/C1Hvgltjp5G26vFWLcd01V/NzYQ7Gd2?=
 =?us-ascii?Q?XD73jBi+lmj0a56CymRRLn2qJjfQ+NHq/jLPGnH48ezocswZnPGwg8DPnXEq?=
 =?us-ascii?Q?wPgtDQ7d0oGVcYZy4A4aS7EmGI5O/v/B44KWPsmzmlTFq+9ZmSVgXjLzqIcc?=
 =?us-ascii?Q?Ce5cEi/P+GhxoawCvn+r6o306FxZEBdVOf6BExekGid9U4+aEzPlPqHp+L50?=
 =?us-ascii?Q?hf0I2g9ECQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a32d9558-cc76-40a9-b13a-08de868ca5df
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 14:26:17.1504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQCUM00t/kqSd2SUNceE4Y07Jt8zZp1NjT82CPEKkRDKLooI2CPbCcFkVGtijaih
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9645
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A80338000E
X-Stat-Signature: kthhjf8mtu744g7re6obic37dq7bbo6e
X-Rspam-User: 
X-HE-Tag: 1774016787-995883
X-HE-Meta: U2FsdGVkX1+DEBI3LT1HSFAYsBJ9IirwUHq5K0gBwP9TzuR2DXV8TlbaE1tyK4otB+/q5n816QJhJTowG/cSOd9psNnD52EOzIWerSz8+kiOYQvhyiW5ZcN9CYtQFmX0sysQ2qin/x6MSEeI2tYN8dQkKWOX7nuvQUpu3iQ9AzIp7K3Ml4NQxk2d0cfbAzVF3roccpJ2cUo8rLptFzN6mioLrxnD70wSdrIokr0fmaheqhXTftS9iIF/8q65jQWPVowhNq1Z93Caa5cxeDTuBe5/fvmoRoPQF5nRtGHC/x/hUbBrs9ACoQBdGemuXuK8iMEonIZCRK7lf5RIDYl+yVX7GVoko8WzmgIsBm1BnRJ1LQHNUmV4ZgB+zu4z4gFNVTwrYIlTByM8VLc1vKCboKC8Ci8hkrov7p9Wjnq3q6sJr3XGu9ELHBlXRS+VfYxfZ0zYhsdX04rS0Idjg/eqIfkH4f9UXxMWjDk6YXkUEUvOVyth9Wt+/zQXCe/TmDI2l3SxHrfonBHwsJP3+6DxhrQ30Vx+fiGKObhpCYiYXxkAYQBFteq973MY30HybKkf9DD3IKy146n22wwiOSXYXmp2jHYroofIQccAvEnqmWgvh4sCsraiRVwP5Q49/M+GxjqMfJD1GIdPRr8xmMeIGmCNKbbfofeZSrJwh6lGFV/hMxKmtu5Fl+bD8B9SOfzItdHOddpRnAG+EQYfbaT999wJtV/mVLoE7U90tSniqX3GmzC/0HaOe4luHCroqu1p8vaDawXqcB7vpu8uYRs6+MK2iK46vmkx+0ZK5ycwOFSmqG5T/+E1X72sjwAzu5nRMl+k0LGDMVsfAJKI7OwK+V0/mR/CEslb7NVX/ByWMRwiIcBhlLmpusjkqvtaJwIEPZTpa5LftSDZnbHlEAtRtJjA9MNr4PK3xvrrrMHkEor5S9T8ZqvVtRtAmXnFdXx9xBWRQESqwLFLf3EXOX1
 r6Ko5Qio
 0uI03ot27tRPDM6FgAwyLQPHeIBUVKcXdfXFo6ExwpVg12f3OB5vFGHDFkfzm4paDTyf8rQRi76FOKYWofsfuYwKb5Fph5POxEsgx5D4PA3yHikUQ+aNJxKWUZGz31gup+ONIfbjsjCfcHaUIuvYhqBtRu1ifPGbz9LQ+TamCJjaVxF7mlI8ak/4rmda+w1WcfAlsJV1DJIbZi8qCKvVKFlomjnaLx0SYnH0O+CnW0u7Hy+gEDvc7hp/slM9YmtfvvBlYLT9eyF/9QnXLt4noZLvWzxi1Boq5wxNJKJyVQspgfpZzPA0gv+JfhfPeKOgqW3rpMmf69IIy9Nz9hajkwA6U+Reg4XerQUhKV3hm5+/SII1AbUmxa6jwPyx8MlGvCeaWnqlZN83xrBc6ivrp7q3BnZafPXiUon5Dyb47VT9fM6Cxa87mb6B9uUWB78LvW5hoVuBQlf0Eo9wOXg6jblWGR4JJAXMT7tfyMIJMq/r0nmBkjWMT7vrcCK6Z+ETpy5HbdYSg2kf1F72phAvrHP4CQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Mar 2026, at 7:31, Muhammad Usama Anjum wrote:

> Apply the same batch-freeing optimization from free_contig_range() to the
> frozen page path. The previous __free_contig_frozen_range() freed each
> order-0 page individually via free_frozen_pages(), which is slow for the
> same reason the old free_contig_range() was: each page goes to the
> order-0 pcp list rather than being coalesced into higher-order blocks.
>
> Rewrite __free_contig_frozen_range() to call free_pages_prepare() for
> each order-0 page, then batch the prepared pages into the largest
> possible power-of-2 aligned chunks via free_prepared_contig_range().
> If free_pages_prepare() fails (e.g. HWPoison, bad page) the page is
> deliberately not freed; it should not be returned to the allocator.
>
> I've tested CMA through debugfs. The test allocates 16384 pages per
> allocation for several iterations. There is 3.5x improvement.
>
> Before: 1406 usec per iteration
> After:   402 usec per iteration
>
> Before:
>
>     70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
>             |
>             |--70.20%--free_contig_frozen_range
>             |          |
>             |          |--46.41%--__free_frozen_pages
>             |          |          |
>             |          |           --36.18%--free_frozen_page_commit
>             |          |                     |
>             |          |                      --29.63%--_raw_spin_unlock_irqrestore
>             |          |
>             |          |--8.76%--_raw_spin_trylock
>             |          |
>             |          |--7.03%--__preempt_count_dec_and_test
>             |          |
>             |          |--4.57%--_raw_spin_unlock
>             |          |
>             |          |--1.96%--__get_pfnblock_flags_mask.isra.0
>             |          |
>             |           --1.15%--free_frozen_page_commit
>             |
>              --0.69%--el0t_64_sync
>
> After:
>
>     23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
>             |
>             ---free_contig_frozen_range
>                |
>                |--20.45%--__free_contig_frozen_range
>                |          |
>                |          |--17.77%--free_pages_prepare
>                |          |
>                |           --0.72%--free_prepared_contig_range
>                |                     |
>                |                      --0.55%--__free_frozen_pages
>                |
>                 --3.12%--free_pages_prepare
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  mm/page_alloc.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

