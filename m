Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92539D1A63B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2FCA6B0088; Fri,  9 Jan 2026 09:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCD66B0089; Fri,  9 Jan 2026 09:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC00C6B008A; Fri,  9 Jan 2026 09:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9C9A6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:30:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3769613BF2B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:30:30 +0000 (UTC)
X-FDA: 84312661020.01.2376F2B
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012005.outbound.protection.outlook.com [52.101.48.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E51718000E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:30:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YOr3EP1m;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767969027; a=rsa-sha256;
	cv=pass;
	b=B8NG54wgZ9eEH08KsCNePFGm6mo9wMSsdh7R9r40njOQrTd7RS07Jy5mV0C61c38WkWQCs
	2vakMgRTdTUWGk0za6Ab8RnFroVl1dGfmBBvcB1AP4gnG3Pi13Us01iYpX71fu9QRux6pd
	kBpLRdQckyxdOj7g0FcgvxYdKhV+yQU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YOr3EP1m;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767969027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0Kj7inp3VCeurmhx3/3ypG2vtYmxbiMzuXEEL6EpDs=;
	b=DN7acWs4ixX/w74x+DKl1xVxd6ZOx8Tq1CVJwfHUJRQq5vYSSaDHnRmiFnvJjEYWKYYaJk
	WUubqIfMCVRXggFe5v3TOrI0aOjXlDp9Cox1rj1g/ma572CGzW1HtVAYVdBLeY3dszO371
	7ZO45W+4Nmxzkz3SzZ1yc6rhQ/rvYwQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rb5h6PeSJgpoyMckSNWAHuTnQC9ZnPFZBmJyeMWT6d+VT0gc9kxYIJhaCrmJvQisWfMQwngHdoUqL2Rvf7Kc1TmztnSxT7nZUnvr7wyZiHRab2AU/N9mUWN5yAYwTwy6qFiYEZKsHggFqL1wUCGEuiBHr3T7ZoeIsf/1ib3caZBueHu5vzhxzXWP2czSpDsR4x5O/x7Xnz5bsot3O5jjobcHET/eUaF4Y+2L/v/eSyfZjs+lu1YUQaB+eWSV9/DhtbEIb7K0qX+CDUVWGPYEJytu56HLgV9m4yw0OUDej5pRQ8ndrWF3W5EnA4mSKLxZe6+STxC1pSNjzDQfyvyBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0Kj7inp3VCeurmhx3/3ypG2vtYmxbiMzuXEEL6EpDs=;
 b=JQluQLU/PE/P1X4yLGUUh6JdNdO5/OiYKqarHE+E6XqKAcPPQIbMA7qSa1SHAazictTMnSCoAFXx7GcXqpMDd2S+rav6/KL+4YNyvDq10VkaVBGESrxsdEbRJMmfZ4nzXT3gXG0fMtoT0Idsnk2OVe4j6ijLaj9ruMwbvPKP6Xp9KiS2268W5twVVNbSj2/yPyZADSsy/2B03QB43vrWKDcYRd5mXKH3ZRQSKLKDVLZOWQmRQ+k50fxrqrqWGCAb7D4vGJE5jOEfEDN9u5kr2SSvyMd5fMJwLLnl7NQI3wrhYkoTTGkOgF0bj99VmoivgWaCx3lb+gnuXyXiQWO4Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0Kj7inp3VCeurmhx3/3ypG2vtYmxbiMzuXEEL6EpDs=;
 b=YOr3EP1m6dsd1rtFgwe33PCeZ2ctDZnUjrWOmsNucOanEawGWgpH2iGZXZkbOM/YNSHAuV4H68l+p9xfKr7E9AOKZ8IIf1qt6mKshUyeqTyBBZhxQj5ll6wK5r+DwyLY3gAtY2+WWgB8SXDfniaZNFdHp+Idq0blC7RGf5Cg7rQivrU/MUh91w7YjesORkhahAnFily0P+MZuOa4lDOx9H/PW4B56FSHYWDlIjIXcmPd9/os3YYvPd8fSIZg46KbbkS+1xtP685C/AX2R/qDrBktywt/meAhprDoCBBRFnHHsrnfgpRWJ3lpvvBgjk1Zmd4d86NtauoZ9dRFHTjXuw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB5838.namprd12.prod.outlook.com (2603:10b6:8:79::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.4; Fri, 9 Jan 2026 14:30:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.002; Fri, 9 Jan 2026
 14:30:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH v3 1/7] mm: Add folio_split_unref helper
Date: Fri, 09 Jan 2026 09:30:13 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <A5512463-283A-4137-B4A8-780783C5DF0E@nvidia.com>
In-Reply-To: <1319a24a-bcfc-47e5-a022-f5d00994acc9@kernel.org>
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-2-francois.dugast@intel.com>
 <59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
 <1319a24a-bcfc-47e5-a022-f5d00994acc9@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0334.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB5838:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ee3aaa2-a61a-4e19-489b-08de4f8b9de6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rJzXWBeK//WCGGiKbxXFkPu7g0t3vHcVuyis31bKd99nN8st//wd6Z2nffcE?=
 =?us-ascii?Q?/JQWtHWZXAkysr0D4mp3JSGkV8JDFk8Xxp5IpS/UiC2nnR8eInerMqlxS2Q5?=
 =?us-ascii?Q?bIlGgjt1TA/lyMuKQO0XkJxNdkZD2kbW3Ak8y1VXP713iv/AjXzz73+3/K+P?=
 =?us-ascii?Q?N9/Imx14ArZHfPuKsNcGdu+fY4tyYvJRNuD4rVBejWBciQPwe2Hir3Thej0j?=
 =?us-ascii?Q?Lod1AbcNPeoOLqqEIvGOyLv5BV6YPGBo1CxBHOsJSX72nDZ3qcTJyPsZzTfv?=
 =?us-ascii?Q?U1nkcY1upxDDA6DsmZLxgKdGXEAlgBuIgyr45G/FTEA234fu8z2Ua+yLjxY3?=
 =?us-ascii?Q?n5/ibJTVnTwe8lCIDRt8mBj4I9zRn3r4x6A/6yURejyTaEZdG2QSP+a758Ow?=
 =?us-ascii?Q?3zol8rjoOcEkeu80jrIZ5JniPr8JtcUGp2fAn/NaSPigT87WozrmkA8KU0iT?=
 =?us-ascii?Q?FBf67aANd/GpYa5owe73d3l+FLTG9NzyEMXWCsVej6atPiLaHb/DBN+fRjDO?=
 =?us-ascii?Q?x7uhXz8uVSHnr/GzDrUK2ycnh5vN1khutVX12Rght9icFozpXKPSN9uoAyxp?=
 =?us-ascii?Q?MF/u3uhIJJmNkTXir70gQrSjJ/nbTPfm6El7HBFIohGW6rnGh3n8gQPBHFm2?=
 =?us-ascii?Q?I3Vc5Od5mdCWNmBWVqwTal7y6AO2IL2gqmqugKZ3NME/IeLYCOfpCng769hB?=
 =?us-ascii?Q?VWng6ICuA4I/RqQAx09E0yvffVMvpK5jdB+Y+LHbXtygaVCRovvVxJJ0wTp6?=
 =?us-ascii?Q?hzJTj3lqFejWb5E0oCMW8+yCBpcZ/mgOeI6A2iJTHH65EORZBfwykm4xq4Of?=
 =?us-ascii?Q?vvnQawimI4W+zlfj8L3xwQTZXpNWAkjk6gAXxd7WicVyCqx0wyl44WMctStm?=
 =?us-ascii?Q?X8Rv2Sqf8bheOT39QegrC1kXaGnXJ3XwdeigIV2Wx4OSMBBKQisyd8MA2Bie?=
 =?us-ascii?Q?xMnbjymkjmn1YZtFm0/PQ91x2V+CP1jfhdqfXwfzyTVMaSeziZfIPrXDaw6g?=
 =?us-ascii?Q?pL5asXZnjBNaEwCth+nnAYJTuGXH09hWImSX8+v72tvCcbSzZU2pIoQcVUM7?=
 =?us-ascii?Q?QNgsFHfDmFMCanKQOk9/JlGCp2h+JvZNgu63fTIOX1KSDHCTb70iYls6Nj9M?=
 =?us-ascii?Q?IUTjdQ6WxblU34CvQqMpjOlwg0T5JHwwgDoKBk0zuOrQNmxCJjBTlxHLBGKz?=
 =?us-ascii?Q?HudGIiVcMCeh/fBim55+jxVmLkXq5oXayw+xLMlXBjn84qNxtdEcaw7Mhh4I?=
 =?us-ascii?Q?xQgZWKpi14QdXODsWtxSGLMkaZq0rdbp2eq3PBYyL87YASuf/lKI+bSISk+y?=
 =?us-ascii?Q?45Cx5LNG7DEoCL0tOn2W5oCSnIbY+ItNqKRAOPl8kIoUj6uo31ZROaqnlrRA?=
 =?us-ascii?Q?bpJFcLzHR9EfNt2MSPS65X7UlTt3lb8gkuFxFaCfglyHxcobXZ+4zfhkeDtr?=
 =?us-ascii?Q?b8LY0lmmhTVhJb5O3mU+HlG5s3nHw/bX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zY0i7W0KPleQX9/zhB2Gs+lMxLJCrGu8Xf80g33M6g5QQepsCOsuYgGh9zCE?=
 =?us-ascii?Q?OIwn2paEhrKUeRVgqv+L69hr6pgP4PvbIKqKZ9F+Xrq0dE2v5Yc0ie59Dp7k?=
 =?us-ascii?Q?qCzDW6p3eVO9i1WCAylBiY+rrZ81bMzuDuGtK4hVX7/3Dmw/GIt5T3/2po87?=
 =?us-ascii?Q?87oExKiD+Yq07PBNZtZNyLW1sf3xqvvcsnorqpNYZN14L0o6TlaGlb/Oq+qc?=
 =?us-ascii?Q?8lW+uNGixfMzFakMUv74/IKuLhz6NBLpW7UxgGlbU8/kOegHnBeOETEu/XHS?=
 =?us-ascii?Q?pllCEUzs/8Mg5I7f3hPAn3UJSgZ6Inb2jUvbM/BXwpgEJpxhwzXOjIANz4c1?=
 =?us-ascii?Q?H8ETiU9NM73KhLqpgS7BJqVYai9YP0N/+KBGm1H2DyR3DjR9HlKPQ06r7OZ2?=
 =?us-ascii?Q?OFqm7LAYDI19OCvP5N5VKo282zNrVfZNZhVw91b9lT8HixmyLLnHZus79FsE?=
 =?us-ascii?Q?zn9oppnm/8RAvfZ+tYF28ftrYLyCcGTduEa/s80awbGT2sWQsRnQiQFjnvNh?=
 =?us-ascii?Q?k+TruLeItrKtC6++L8ZDcP0LorXHNYfOe8Xdf0Mfz5JJEngk4YeFZXQcUobt?=
 =?us-ascii?Q?XGLe8RVweJXvpWXF0Y80J6idqwbhJf48dYrQKbbtpVVk3qCwP1cJ4d4PGvB7?=
 =?us-ascii?Q?x6QjAkMuzVsFIddHy2cGKh9ziOkLem4LoXyAnlPuIWXcvHFOTWxYlx7e8E7b?=
 =?us-ascii?Q?y81y579SfQJa+1HK/GFUzfJXCYo8fZ8MXZKvvJCXUB7xoBUCqWGhPoT0vc8V?=
 =?us-ascii?Q?3Gsnzs2RT/h5U9twx37F4KujDtbFA/QMk9c/E4gH8m/00XM2MPBE7t5gg2Pm?=
 =?us-ascii?Q?ILyb1oNhpHQaDfYk5AH5szccp4jyJthdbabtHQi0msXuBtTrYlIjc5PrafOG?=
 =?us-ascii?Q?qq27s5ZZLlpNU4Vbxx2T/oqLh2YGDBdwZc3tDU7AOtfcwV+U0nQV5tDeDoGs?=
 =?us-ascii?Q?PJ8GBAuBwT5Dz5fVXO2UmHJUIx7nPH2qUczUneVLlWmTgO19Z4IHVtZCjNm6?=
 =?us-ascii?Q?OSBw/9M9lehBGebmWMDV5DJfOA3Lz1yxmOh8ES+34LIXFnUxyxBI6UyxBADl?=
 =?us-ascii?Q?u0JSDZdbIkIywQoyqxpIT9jMoDRTRv4FHVV+aeHskmTd7Fcf1TJeHhPREoyw?=
 =?us-ascii?Q?AIttpiYNvV3Nuz1d8q4vkiejI0ucZPtxIHZrBk6nJ1LiMYKZ64zjv0anZbzG?=
 =?us-ascii?Q?OBfLCJCf5jYiiYV9Yssr14Kf6HaBMuTvdLml7mziYarpiOS7ezJknJmSyrbH?=
 =?us-ascii?Q?k049XYIZS/9CSeC3762QNsf98Ug99qM8pDYZ/rQpYtOOuur2vmX+pnqAQel1?=
 =?us-ascii?Q?mgpBHy2SGVm5Ymr1IRsJiZhQJktsBXicseiKgjTwqPoFxmZR5EF7mtS4GhPS?=
 =?us-ascii?Q?o7hfPYavT8HiiMb2UuoxvEePRHZVaCON7JgARiAzGxeHWdQMnDq5eJ/48GUx?=
 =?us-ascii?Q?72Gr+yTasuHK3J4vgHudlqvi9VJkpuCcy+uvJ1OwD14KcfJADO/W11cT4PlI?=
 =?us-ascii?Q?MGzQkQiLXOa5b55IyTXRDm5MomhxFTX/TzXeUv9bQAMKaHOYXwEDbSW0uVQC?=
 =?us-ascii?Q?GEJKJGSiaVzjk+K12GsPOibm+d4bettaWNKwonliJU1p0TVp2sK2A8vpDCkI?=
 =?us-ascii?Q?ZMsWCpTmYYrGimR2RUnMdUEJKPEieQ/szKeGmAp9342n1/p0+bKNANGBenii?=
 =?us-ascii?Q?kk+upp8+vTAlbuRSf+CKgLabcHUYxczIe3Vf/cSpUrovlxUd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ee3aaa2-a61a-4e19-489b-08de4f8b9de6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 14:30:20.4086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSIx/lnDbfsP3CnkP/8KB7ShwVcecAmpwuRkIakju6n3Hq1Fiukv9kSQRs/pPU9K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5838
X-Stat-Signature: x338ioupx6cgtgz4hmin5ip3ftwz9rkk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2E51718000E
X-Rspam-User: 
X-HE-Tag: 1767969026-427057
X-HE-Meta: U2FsdGVkX191DRXAhzs8aIb7FBCEfigkwvd1BYAvdbIGDNsVTpvXBd4nk4rd4czkm4tBOHpKQsrcQfumxUhyIvt5IgMDotXA2f54yTxzF5oM6ZVDWHVtfCH6jwqxW7sMJ4b5Vqf1gckawZqAFPU5hKZ/WOrAA+aNEuu6z7bJfJxALCkLZCszVyKsv5lP5BZDkAZ3zL9FGCLUxF6nL3h1ayFkiz1TV5D6G6GvcmviPHb+/uXW2EUcZPwckDm/A1m2MxJXD0rh/IQQkR/O9fZBCkK51sHHUaDEXO+BkMVOQ0rkJl71IqESnN+n+qrsXMLB/kclzUK7NXrwyKY/UGl9mMASvA1dCbfYs8kLMnqWEa9BCn/pJlne4qpgda2k3IUXdPl7aKeDOmSNGg8lvfmgefHY1rhGKyXRHglfj1hDs0hFMOk5s9wdCJjH2l6xOIeKmYyozgkKkUWJVv2DC4np7mXYzjaaLOeC9TtnW8+weGr3Xe5kgRnJsnUgSKz/u/D7+5BudaruifAsvHgu+yttautBeLUsHacSI0pZH3a6kdNspqRu+TBzQEOERfozT5dAWW6/ET3tjBwugwiYE9a4Ysov0E1FWxmevyg41IB+BfJXQXPjU9YSJEToLp64uzxMrej9M5Sf0UwNKAuI8Lsjj1ukRH1l6xgB4P5DgkeDTHA75ui1ScmkgQsYizQNDDyNRPSVf8wnyebRQRGjJOG9KObisL/BjT1j2PPQaUIiNFeAWYdGJjrsj6BkUn6qsos6m5aAhAiNsfTzuWVXDIqEZsP1ZP9B+hqk1SvIQuiBM7rTJYEwQgb9sB482lvOFX/Io96G/UqjIBRY8bSgJy7yWg+tB2a5V3w3DYv+R729mNLvCuEfT2AwqmWRTWVJVPUvGgPNeoF1vil1e5/egVZgFRTxYBz9836y/nE5ncgKGDBiBSJwKTeiPraUaEUKy65e+J3k7a+ytWlK7UHVu8Q
 bVbc2JUR
 eaRGN4+VhuQJvZF558s9edKYHjd9Vivza3oLjkBnVNdEhm3B2cFQJ13AYY0lJpt0vVwQrCGTd4ft4U1xNkq4PiORGudXtBkfjcMAQiVlSJUsybrEKb3N/AW3IgXWa5k0ak33l0x3v4hdl11TQpmL1FeSm43lw/aFrGQ99FrAT0B3xWkY7t/8Nh4iFY/oXlt1TzyJ6gECyZUK8fjsFG0frqt0Wr9bKoYcSPuhZRM/5uGzLEZaayjq8XIRDWQ3TV4AhPPbHKCOvn56lWG8q4u7CgFtaBF5fuhN1O2InFMKlcC92kIWod3sZ+Tzx8cK/FnakMFKZ+1Q/YvMQ8ULyRf7XYSxRJi/c0sFXFsXNyHIh9xJTNu5hiTg+7Bq/yOFEfSwcMQvJtgSLxxDWbO73Y2CR/tilIP5VtpWgzOaz/7sQfiP6MC5tdG6c/tCdfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jan 2026, at 8:26, David Hildenbrand (Red Hat) wrote:

> On 1/9/26 14:19, David Hildenbrand (Red Hat) wrote:
>> On 1/9/26 09:54, Francois Dugast wrote:
>>> From: Matthew Brost <matthew.brost@intel.com>
>>>
>>> Add folio_split_unref helper which splits an unreferenced folio
>>
>> split_unref reads like "split and unref".
>>
>> You probably want to call this something like "folio_split_frozen" ?
>>
>> The very definition of "frozen" is "refcount =3D 0 ", so you can simpl=
ify
>> the documentation.
>>
>> Are the folios you want to pass in there completely unused (-> free) o=
r
>> might they still be in use (e.g., migration entries point at them duri=
ng
>> folio split)
>>
>> So I am not sure yet if this should be "folio_split_frozen()" or
>> "folio_split_freed()" or sth like that.
>>
>> I'm not CCed on the other patches in the series or the cover letter, s=
o
>> I don't see the context.
>>
>
> Ah, I was CCed on #3 where we call this function on folios that are get=
ting freed.
>
> In that case it would be acceptable to initialize folio->mapping (and f=
olio->index?) of the split folios. Do we also have to initialize folio->f=
lags, folio->private etc?
>
> See __split_huge_page_tail().
>
> folio_split_freed() would likely be best, because then it is clearer th=
at there is absolutely no state to copy from the large folio.

Yes, basically, we do not have a reverse function of prep_compound_page()=
 and
open codes the reverse process in free_pages_prepare(). For zone devices,=

zone_device_page_init() calls prep_compound_page() to form a folio but
free_zone_device_folio() never does the reverse. FS DAX has its own
dax_folio_put() to do it. Alistair suggested to come up with a helper
function for both FS DAX and free_zone_device_folio().

Maybe free_zone_device_folio_prepare() is better. And put it in mm/memrem=
ap.c.

>
>> You should describe in this patch here in which context the function i=
s
>> supposed to be used in later commits.
>
> -- =

> Cheers
>
> David


Best Regards,
Yan, Zi

