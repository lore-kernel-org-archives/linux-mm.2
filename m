Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F33C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE726B00A2; Sun, 13 Sep 2026 22:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFAA36B00A3; Sun, 13 Sep 2026 22:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA24B6B00A4; Sun, 13 Sep 2026 22:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8748C6B00A2
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC04580E70
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:41 +0000 (UTC)
X-FDA: 85210774362.10.FA88641
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id E25FE120004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HHAKigUw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5oQkgIZB8g4TSzZHu0Etfeypilmex6FsVP2ICiojaz8=;
	b=GSEKbhrAWl/Vr64PJ/1KLkh0YfR+X77Wr9snEOPHjjkfn+jdB2hl4NgTOtcp+XxJlOxRzX
	0cUq5rF6bkjE/eHpsL7PnsJayZcFO9xVZX6jsSFXo5wFUsu9/gmup2ZMwFoAFaL0/GtCsF
	WbyAozWOK1lq+HDLEwhiwnvc0LesvdQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352679;
	b=uB1kcuFgFFWnpSPoGeKK59+sEJ11nUlcRwomAviYmQ+/0Scl6ktmnDG13rgTtTdL/GDhPz
	5/kpZ59CByWRdFr4XAin/I636V0zExGNg6+GzIxdyMxHsgVDZCNL7QCtqltzGHCtpEpati
	WoQ8EPgDc5VXco4toHUvDZAkjrcoP2A=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HHAKigUw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pRZmuEgehrC1cz41bokAttP2SMJ60Zp+62B3kcdZ0ORilhcWfmzVyqY1Q/Z5aeqydB1YItreEmbLCCwBd20bDmB0ZigYCInqWek8lGl4nizGhMKlUgxRhZILeVwlI0Bqp22VpU4/wogUUD5eY0Ow9XAvsDDBKujRDD2ZTT8i2OmT39Ibb7UZ9IpTQq1gIfhufd0zvX2wMD7DA8C2pOGdrCFMBBqwqmlZOHt2SKem4swrJDmkNogtUHGPmBtVSm91L9tNT6ajif5rhDI7JAmPu/cyzTR7wM8QBTk98AYEP4zlOdtcMJPky5qAfls7v320QU3XTz+3GtnBo1yfCq7u3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oQkgIZB8g4TSzZHu0Etfeypilmex6FsVP2ICiojaz8=;
 b=SIUmOOUjp9reMiWY4nCq7sAHMjs0IYOK78WI+hOp/QP9lClx4oFkawNsQpFUfZj/AINBiHsI+RmQGvEduc4hV5+Ov5myTb4d0bMx8JGY35gJHuQ18dp0Vs8uUeNfMqwhOSjkqgrdQMBCr6vvHLj4PMe8SQAeo9wz4wRiQ8Ut0Vxt8LB70JKGdg491cVBzKT2DhUxDCF9GJqXG/3Bf8j0HS5yLAV/FBiTbn/5h8TvJ0P7Hoim/O7LDlYtHdSzqTjdT0DITb639IDfM5pDzfK5FKl/QyMl/e/7wuoUbpCx0wJFphX5YoH9RZzVZtQiAexwAsCwJVr0U9qRfyfz4q5Bgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oQkgIZB8g4TSzZHu0Etfeypilmex6FsVP2ICiojaz8=;
 b=HHAKigUwf2NyRqa5aM2Ij4bUzjLKHdvyH6PlKC0MraWmcNba5UHCEcEbXpOSRVDybXMgdJZ5UU8868qs+BMt3U/rDUbIe9l4MKBYMZniPKticDc/BoHRLc8KZUCuWpJUhK/iVjGvrgZhlTmIQqJZQvKWo5uOFKcX3+h7uHtSAGln8ywbhunNHb9SuA9DPKA8xyvWS/DZsNc8owuHilMDoVXl8TaNf4ZtjKH0ffaF2jcDsN/FpXu2NakBb9Aea64mq1cx/7FC9Bb/R3k4gR601dJaLq87IWEPGETEfpwov6x6BaOOyNT51GLNXuicneVWwsL9YwGdyLfloDvwdoiEPA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:22 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:07 -0400
Subject: [PATCH v4 09/16] erofs: use folio_attach/detach_private() instead
 of direct assignment
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-9-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BL1P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b5d5a0f-e1a6-4725-199e-08df120749c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	gsz+V3hty8/wfORFNw/Zm9vNNPQXcgwUtyW0zE9q+Nmb9u31IIi6lf7avr93nI85wg87rO6z0gIu2FzNx85urfiBMoQkKlSYZjI+65H8mw/f3pRM1Zw0W50DAw1VjLSUN3wggIXSTFKiveobpiZqiWcWaAJIK9AjfyAaRMVcalIrGeJUn2++mrAnsDASVUvrtKKTVfaYUFXEVtp1uzMWUHmuzb2wmtZRirUNT8T4jk6xU7crQTzFNE3gO7dCl5yXGhYLJVlmpbA74Crppog+ZO0VEnyiCb0QXuJN1oXWjzZcbr2ffH+x83ePPU+KICfRTorjau2IGSvTc9TrP+ty4KfgY6WHRSqJZLIVutSx8haCONhH2OP8T9Wl4g2USyI+La2gu3bVHmpRjCwbKrWuQ3tpJqYJV8yDWn/eT8pq0QCqlbEVAE+XGVYd3OnveFJxF5ctc57lHLI5gokiHYP9v2SdD8IoJTmvdWemBYtoB1SkjaW0HMYhcjfNHjaB8iKgSpx0NYycFWjyR0TVXO67/JOhjNvx0Ob+kIt7AzVaD95RdjQNMxAgqFMXvlL+gMss9qRUiCWXF7jJbrOn2Fx94LhwmpaZF/Ve/RXN9b5GlREyndzmraThIMipFSAuqjLvFSPW7eEePqqI8hVQIJXtGfTGP9Jw47cwfStApnJcdT10xdnjF1xccxjc86HY55E+2AarSYqCMaG0TAa1ve0H6w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWREUFdFQzljSVAzMWJ5OE8wbGFVTzFkZmtyeldiQjhPN2xhTmJxZlhTOGV5?=
 =?utf-8?B?enlaQ3Vhby9hbjRkQmJaU1UwbW5nb2lEODJIRkpHZzZIcU84NW1iaHZhZTFl?=
 =?utf-8?B?UkJmRmNEcDBNWDNWWmhkSHdEOERPRlg4Wmxoa0NIeCtpMFl5bzBFUm9SaHBW?=
 =?utf-8?B?aWNPSjNibEhGd1Y0dFBlSDFOSnZNSnEyZDBCYzJDbEJaUjA4WlUrY1REem02?=
 =?utf-8?B?RGtSNDlUU1AxOHRwaHBJTkVTRDNSTVRvczk5R3dXN0FjQ0ZCelRmL0Y4Ynht?=
 =?utf-8?B?bTc1NVlOTWMyS3hXMk1DNkowNmtzQTgvckFvZys5T25sOWtxMWh1UFFpOUpq?=
 =?utf-8?B?cytzUWwzYTE0QUJ2N2FPb28xNjJBWGptVXg0YWl0dHZtelB6YXZSWGxsUGZY?=
 =?utf-8?B?b0RTOS95Qm14NFpjUHJBeW9RS0c5UFFqcnpxT0xUNTVjWDdhSytaV2NVQTRO?=
 =?utf-8?B?UEltTVdHWG0vcDFaUU9yOG9qWHl3T003OGljdy85WllKM0ZESFByS1VRNGJk?=
 =?utf-8?B?TWp0RU5wcncvV2Z2anowcDI5a2xMQzJzL25mSmwwaCs3WHUwNGVvL0JXUWtH?=
 =?utf-8?B?L2JTYUJWVGJHZnRaU0VIdnl1TUN5cVFCOWluSG1LeXEyWWhVOHBUWjBmWlhv?=
 =?utf-8?B?TW1GWTBLdDFRajhaeEEvNjdqUWVJaWI1Ym9vWjAzeTlibHB6NzRaN2ZKdWl2?=
 =?utf-8?B?cmVwL0s0bkNSSXE1clhZM3FvWm83dnNqNEsyUGZKaWlRbEpJLzRTOUQ2QWJw?=
 =?utf-8?B?TWVzV1RpZVlkVTZEalluUjZuOEpXRmxMTC80RXZleDFOYTgvaTFVUzkwWnhs?=
 =?utf-8?B?azhCVjRnMkFkSE5yUENqY1V4ZjVaNm1XS2R1TEVnYU10VnlLZlhVaTJpS3hB?=
 =?utf-8?B?RE9WTnNScGlZMklpVUNmVlJtQ014cDhsMW1MbVkyeDZQQVB2S04yZVN0VW5l?=
 =?utf-8?B?U1VyYmJ1MHg0WTNIQ2ZWaWNhS2hCcXQybC9RWllHRHdJYWo1K1BZdHBBOXBT?=
 =?utf-8?B?aC94TWRteDUwQTNka1NtcTA2K0VybzBXOUt5SCtEZTN5bWJBbll1MjdCbzl1?=
 =?utf-8?B?WktNUm1yblNycFg3SjFGb1ZoWHRCa05sS0lUcXp4bnZReHhuQVlyYkFJYXFn?=
 =?utf-8?B?aXg5Z2lybEtZcWk2SWRRajlCSHhHTW83YkZnTEtIcG9icDNpeS9WdWZlL3Qw?=
 =?utf-8?B?ekVBemUwUHEyU20rd1cwamNhQVk2OElmRndnOEV4akhNSnZydVgwZVRIa0p0?=
 =?utf-8?B?aHhSNlUzY1JIRnJZOXF1Z0xmNmZlTVR0c29zK0dEampETThESzVvWU9hRWVI?=
 =?utf-8?B?eERJd1huQTVzRmMyRFBUeFdoQ0V1ZFc3bzF0SExuRlBIRktiYXlGR28rRE83?=
 =?utf-8?B?cGdPL0hXNUJrQTJJRG9WRnRpVnlFcFZqYVdUSWp1OTdwTExLWlMrVnUvOFRp?=
 =?utf-8?B?VnYyeExnZjMyYjhGY1ZLbW1KSDJWeUlrS1NCenE4OVJOY0tXMDBhaklTTWkr?=
 =?utf-8?B?blZ1THhTVWoxWExyZXdlbU1VREdLS0toSlQzdm1PY0txaE4vSERYMjNZL1FD?=
 =?utf-8?B?S21sdER3dXFBNFpJZWZJWWVnUTZEYVkvS0JKL2s0N1ZKbG5ucmhnbnBCQmVB?=
 =?utf-8?B?UXNjYnNxUkNTTDhOeTlQUUIrODkwbnFMZEVLaVJuUEptSjJNL3k0RXQ5cnpZ?=
 =?utf-8?B?SjhndkJzWVJFb1IyV0FHQjlsU1o4cVJOUkI5NmYxRUpzbVp6R2FJNzB6OGgz?=
 =?utf-8?B?dzB3a3c4RzdiYjdjVURhdGRRQlVJTG5YOHdYaCtEaTRsMm9EMnp0SEJnWUF2?=
 =?utf-8?B?cEdEc0pGNlV2ODJ3UkVaOGhDMUVsU3FSZVBNMFJFNWZGb3JabmQ0b0R2OGZr?=
 =?utf-8?B?Sm4vQ3ZESUwyeXJyNjV5dmlRUDZ5WXdyUlFSYm9VWUxza2tLUDFCenh2TjdH?=
 =?utf-8?B?NStoN1J0eVUwcW5UZXI4Uy9RNnVrdlQ2aEJZUUptUEVXbzlDSy9MOU05bzZX?=
 =?utf-8?B?T2NsVGROSDZ6Q253ci9JWUVDNFBteC9yUTBpbmpsall2Zm9iZTV0b3JLSksv?=
 =?utf-8?B?YktmT0U1WHdXSzRydU15MmFEN0tSM2pUSkMxUktaNExTOTlPQjlWWDJKa1Ru?=
 =?utf-8?B?bHZXMlFjOCtxQS90VTRDb1lKd3ZqWnFzSStGbTFhSmFXTVplZTZ2STkyRTZG?=
 =?utf-8?B?R05TNEtqdmQ4cU1PTTMwVDdSRUtNK1cxWldyTnQrNHVKK25kNXh5OE8yV0l3?=
 =?utf-8?B?N2F4aWVXRk1aR3ZpbG1qeDlvaXFJdXVmOFVaTjRJUmEzempDQlhkeUo5Ykhm?=
 =?utf-8?Q?ZEpmxUiT47cUJVjHlm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5d5a0f-e1a6-4725-199e-08df120749c7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:22.2746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /x3fAVW9z31WTZwfJpYVgtLQ2SIugzlsh32Y/pLrrZnUi5RgbwPVxJlzmOzRrcUz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E25FE120004
X-Stat-Signature: keqomfr1zhtcpw88w6csrym6ahrc5a4g
X-HE-Tag: 1789352678-412476
X-HE-Meta: U2FsdGVkX18dHNaFpY8LvxqD/qIFqrs5/gwSSKMvRnWC37HsJwXYd8omIoaFm06ZTaZEwxd9fK1RvzeEztnu0R8VCRyM9N52V8dRRWhEDTYWOPoW4vhXSguPFcV2dd8j2ZBD5QdNdvtc5jN0QyRiLOZc+hR9wCIpXpAL6ONVL3GaeyQAWsWRz51U7cSHO/Ve2GPkzDYVOyYD1fEomUASmJ0F6bwoX2tJyZY48X4Rb3p/xx1knMmG3+riyf649Om1sroRhbJJCI+NhHqwU+jzXvDJxutNkOwJgJK7K9YxFOtOk2ke+0DQ330UalwJEIY/Nw14s2E03gQ2jYBm+fU2crkY3FVZv5FcJb9smMrdTUNiQ2OoFXzplcn1M04Q9RoICKe4XWJjERsGKN9rv+cmf9W8IyKhB/ieYhpAum2ZQ+vzsJEgolx8n7u+lNkgL8NTbZxFd+EUdeFfgS4at03gmwWj13OwdqZ2gqTNNAPPDXp1eVF0RoRyGCAiXtS8lAXDmMmwKg+ZQE2bRGqEhlpN1GKA8f0Hhg502f2cj2XLBRdU+48sXYjnCtVCzSX0vfpQl++DmBU7UZvT2lZd3u95BvRvMPDkleDxOR1VkLmMNsZxDWmeS4KaB27ZQljH0v4YQ7mWVQvyxwwh2Xz0s6jn/mWH397PCpdN5KrcVHifRJkEmsf60wnxJrKFEah3KSM1f4UVfvznQ7ZBcBwrIzJ2DEC9KIPCUbqkxY/AWSkTMXTmHpbDnjLtgE+qRfXa7oTJCAsR0zXaeJaIgfORmpAPNV9s6f2ghxEFPq4WZD9SZDy8mnPW97fvOKnh4pC80+lgotsx8fBW8Y+kndTtAPtIWqvdZ+7cI9EkQhObn3CEwotTifYqLmybLDmcaXiLCfuytSgknmLQBLTaveE4MiGAfu+2n5NGhh4IYZKny/6Ny0iLTMomsvARSdSp16qbbbQo+jlujPWQlMrcZdZ36im
 1a6M+LQN
 W5PPQsiodvPFo3L4G9Ny+vegIVS8P6rtHWA1HXC0EyAjN0WDcmNyq2L3iAktE1lnEtK8idFAye50Z12EwI6UhdA6Zjq53Xc3o1uUsdfYFVg3Kku0EMXgmQATuoJ4k8NDC+TNPx1qao31jxgMRtHWiT19Bdj4pmAzmUDGh+TIZiqsOeZXVVLV0AanKkJbr5++xcdJWE5hRjanFXfpjq4TFkqLzFhrxuNvzAIDL754M99vSfKhu1UI/H/27itipOa2HjrD4RuAyHWnKsrmq4dIG+6zkWONbEzKOOrke40BBf1ERmkFE8RlPFrtxmkcuJBZKGcQhE5Y6HFUmyaKHThk4yDPkTxPyhlYc3wdGvw6vRob+NMNiEpTjrZ0q6EDL2Sx1zahHQSfnw+F00vrI0uWFA/E1mvuGOkgb7Qag9RSlgOKV0nvBGSnF1hGg4gxKj/Cl0TFTJESPyPLW/ejiTTVSz/8ccDFqA+YHANtFW7oDS4kvDH5n8s1mXdtR5vjWWInW2FbhNDGv4z0HG7nDkN8udd01kYpnQHAdr7vi5Z9gNJ58dUoXLdiVhKEwKPbad/9XsAdulMK7gkHSGgGQn4lP7j/65sH6Pr8Vq56/BFz/jU9GkGnz10CTtZr5k4YgBNTJQp0OnL8AJKIJmZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

erofs_onlinefolio_init/split/end() use folio->private without setting
PG_private or increasing folio refcount and it works. But after PG_private
is replaced by checking folio->private in a future commit, it can break
folio_expected_ref_count(), since the folio has private data without
elevated refcount. Change them to use folio_attach/detach_private().
Folios during this process are locked as they are in the process of
readahead, so no parallel migration/folio split can happen.

Furthermore, because folio->private is used to store in-flight I/O counter
and the counter reaches 0 when all I/O completes successfully without error
or being dirty, ->private=0 causes folio_detach_private() to not drop the
elevated folio refcount. Solve this issue by using bias=1 for the counter,
so that ->private stays non NULL throughout every attach-to-detach process.
Add a macro EROFS_ONLINEFOLIO_BIAS=1. While at it, fix the comment about
->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.

It prepares for a future commit that removes PG_private.

Assisted-by: LLM
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/erofs/data.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 0885b1f2fc925..f71c7b51bb720 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -239,19 +239,23 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 /*
  * bit 30: I/O error occurred on this folio
  * bit 29: CPU has dirty data in D-cache (needs aliasing handling);
- * bit 0 - 29: remaining parts to complete this folio
+ * bit 0 - 28: remaining parts to complete this folio, biased by 1 so that
+ *	       ->private stays non-NULL while the folio is attached
  */
 #define EROFS_ONLINEFOLIO_EIO		30
 #define EROFS_ONLINEFOLIO_DIRTY		29
+#define EROFS_ONLINEFOLIO_COUNT_MASK	(BIT(EROFS_ONLINEFOLIO_DIRTY) - 1)
+#define EROFS_ONLINEFOLIO_BIAS		1
 
 void erofs_onlinefolio_init(struct folio *folio)
 {
 	union {
 		atomic_t o;
 		void *v;
-	} u = { .o = ATOMIC_INIT(1) };
+	} u = { .o = ATOMIC_INIT(1 + EROFS_ONLINEFOLIO_BIAS) };
 
-	folio->private = u.v;	/* valid only if file-backed folio is locked */
+	/* valid only if file-backed folio is locked */
+	folio_attach_private(folio, u.v);
 }
 
 void erofs_onlinefolio_split(struct folio *folio)
@@ -265,14 +269,14 @@ void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty)
 
 	do {
 		orig = atomic_read((atomic_t *)&folio->private);
-		DBG_BUGON(orig <= 0);
+		DBG_BUGON((orig & EROFS_ONLINEFOLIO_COUNT_MASK) <= EROFS_ONLINEFOLIO_BIAS);
 		v = dirty << EROFS_ONLINEFOLIO_DIRTY;
 		v |= (orig - 1) | (!!err << EROFS_ONLINEFOLIO_EIO);
 	} while (atomic_cmpxchg((atomic_t *)&folio->private, orig, v) != orig);
 
-	if (v & (BIT(EROFS_ONLINEFOLIO_DIRTY) - 1))
+	if ((v & EROFS_ONLINEFOLIO_COUNT_MASK) != EROFS_ONLINEFOLIO_BIAS)
 		return;
-	folio->private = 0;
+	folio_detach_private(folio);
 	if (v & BIT(EROFS_ONLINEFOLIO_DIRTY))
 		flush_dcache_folio(folio);
 	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));

-- 
2.53.0


