Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18524C5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 02:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D550F6B00F3; Sat,  8 Aug 2026 22:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06D86B00F5; Sat,  8 Aug 2026 22:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDD36B00F6; Sat,  8 Aug 2026 22:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 784576B00F3
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:22:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB0C2A0499
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:22:12 +0000 (UTC)
X-FDA: 85080131304.13.D367B18
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id E7F04140007
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:22:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XCsVJXUl;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786242130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1VUMuAzRWvELwp/hBjTQ0dPBLiL2/YPyqqtkLPvCkw=;
	b=06hbPWVqhNNBcLRO8n/EuGOIrEjiI2E2hfVXljFeRD8AuXLsszLwq1nMdILdOk7+Tgoh28
	qHQaL1jZlRohULHkTyrM2LTnUTLspElTqGv7VQqDTltqyI/O06e5iW5JeJqt0hZoMcTwDO
	sMyGdOjAz85DCoPDzzArUH6sBqWbd5U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786242130;
	b=QnKO9t8D8niUnB9e9aMXch+viDZzC4cp+PDKehI0hLQRhvWWZzxl2+DlBUTJajhkQkWwzs
	FV+PyWU2VcP8iudnbEKGgZM10f/nIjmEQUr1uoEbGu0vhMGQPSTTd398P/PdzFLaAPYpIm
	pddMa4/V0FECyC4CM5i2mx/oIkQCbjA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XCsVJXUl;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVS2hh3YRph3P7G8FSbObbyosGVqW8FjM+AW7itmV3wixC4L/MI/8BxrTikeqc+MHT+NnxkohzYNLXTvyoPtIxF046NJzEavkEURwxYgmdVM9HP6bSqNJk5BaOqgsfmpTJ/z2x2TIIbowHQSv0qDxAdndiYYbK28AF/tXtyWbqVDxOZQ6fgwqJQBTdsV9zUdv3FxEV2SA/rgTL9vfIAvjNGgVZfExCE+pvEsZNJ2P+6Koqxy4631/SM02bFoIk5tYvdC+arW+DUMeTqxkUATXz0AQ4XXmMb4quPg1atFcEZoITRSpNbpzDfYLCnOIPgVib2MdeKs915PLAC79jh0Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1VUMuAzRWvELwp/hBjTQ0dPBLiL2/YPyqqtkLPvCkw=;
 b=m2SJ+RPoSS9utcRIF2PE0w1jB0NgEs0vO4zJZvJh2p9w1HnEYbzCeJuhyn4EnelZpXPbQ/6Mn2PAa9fT5KMLYA9qR8HaNauml39xCImBnUBCGPh7qpCCaIDgxiB6alpCpF5drElx1kXU4jUW+8NqZW+BTstAbtJYBupLAee9Jrhhbkw249DQ2VQIGLhbHEAM2O6ZDqnFvhd3gKgB+Mtq2CEvzU2IhIQlIYlMDR1KTlah/Tyao2O9UULCKXv/aiKoLnioX133tggN0NJ0DIx4jKSAKcKbkaHpUQPs8zDVj3nAdCuVS9oIdhNg25hQWuBiq/Sdi+fk07hVn6v6Sphe6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1VUMuAzRWvELwp/hBjTQ0dPBLiL2/YPyqqtkLPvCkw=;
 b=XCsVJXUlP5NOO2ieQuzvnAP/cjZSkgkZ8iSaStfTnj3GKN3Haq7p9zuYTW/cFklU4PlYKWNnWF4T1mxs+a4Z328+jk0HmuBH7KilKBU/na/Hy9N6iDAGntxFViHDbsEhus5V1CZB9aIfuR3THmfOK/ltyKPiRxzFlDrMVBxBTtjupmr8CFwsbtNhlgKoYSjnEO949Eb4X3fmlZISqkNtvWgSK0TWGJF2hduGkpn0pJepwwSnd9oYjIEw/yG2siJsEIMbbw2CvzYmDPIhwM40b1Z6cisTEzMBrUy4jkLj0KNWVbfgSyavlcApstX9n+Z7TqbaTtReb9ZqkksIb9ntwQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL1PR12MB5852.namprd12.prod.outlook.com (2603:10b6:208:397::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sun, 9 Aug
 2026 02:22:04 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 02:22:04 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 22:22:03 -0400
Message-Id: <DKK1ZJC9HO3K.BZCWOF9Q9G40@nvidia.com>
Subject: Re: [PATCH RFC 08/13] mm/huge_memory: move anon_vma and filemap
 management into split helpers
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-8-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-8-689939a7ccc3@tencent.com>
X-ClientProxiedBy: MN2PR18CA0028.namprd18.prod.outlook.com
 (2603:10b6:208:23c::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL1PR12MB5852:EE_
X-MS-Office365-Filtering-Correlation-Id: 645cc582-0d4f-4366-a71d-08def5bd00f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|18002099003|22082099003|56012099006|10067099003|5023799004|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	vHE7uISutpZqBxkmPwPAx6KMJSex0v5YDv+Cnp/5kGvEyT/BGYv8+5HPTLqGbd/qnxZhMYl8yedHtBFnAamau1+J+JsMBMAvOLxerSPQPpI35G4FcESB1p04fMggCQsywLEgN/aHcTSo/FqLqVuFTYD7NQHZQ87eZVE0wR5pRu3WU048IZXktd/CapJr7Wz6ZUrm/DC54Xcp3sv5ndrOfzn3pf6hD3qLzQTwRZdvlmCA1gfycTAHxx7Q2x9KiDtM10dgjfE7Bg00WkVCURokAFj1V99aVJOb8rH50pSZyQeRcwywr8yZrvribcyEyL+sGaZmhmciVDMGsmIFBSTx2DHhj02eQKIF8Q9K3XVR5mi98an65OSX1b0SoFAYVr261btDlx5HFyr0UIq2aEDE97xriGp93K/MF38miWIeAf6RVyM4UdrUJrHyPJRQDbmA/U2G1zBhvyrHPIFondAg0IW2YZ02b2aCW6itp4Y23W1a8pi/1cx4vcFEKqNVj6yd73CgMKgh3qdph5uRLfQZ+xxCSOxwXBiaXj91fQo1/7EtWWGTX+UwTjOuJQ+/8uv/WVVYi2fR/ZBB2206oyhfXsMIHzp5HW6NhsMVPiET5tcmammajJYOvHKOyRiB23MO+h/vKRm1C+L1hNfQdO/kwkIBlJV6wdDNDkGNISmyZRA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003)(5023799004)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ri9XYzc1SlpxYzV0NlhIVnUvUERxUjgyRXlqVHVmVnZCeDR2QUdhNGFVa0lG?=
 =?utf-8?B?Z2R4WHJBN2haaHFBQUdZUXFMcE9sMG1DcUJaWTJkUURXY0JvZmQ1MCtXWWZJ?=
 =?utf-8?B?VnNSM1pZc3psTmJsdjdxMmJNOG4xaUV0Nmwwbjl4RjhpOWtMeG9JWXlOcEVv?=
 =?utf-8?B?NDh0Z0JGWGRqQTBlRStRZlpRWXg3Zko3bmQ4bCtkRnBjZWMwcnpVS1dJTXFL?=
 =?utf-8?B?dGU1ZldOdS9GRlVKelF3NVB2NzFsTXJIRE5CbjZ4QWxVajR4NU1LeG5SaGRX?=
 =?utf-8?B?ZUw4MUsrbzRYQkFISjVMbGFhSmp6anhLUW9hQVdvZmJUMkwrUkkxRGNKc2xp?=
 =?utf-8?B?YjJCOXk4OUhPTXQ4QzFKQUxkaUR5ME01Rzd5Q05YRnhEZEk1eTg3R3lIVDhG?=
 =?utf-8?B?anRKS2NOa3BucVJBS1Z5dWJnVmVnVVBvU0c2cC9tTElJeHdCQzh1TWhpWWky?=
 =?utf-8?B?bjd0d3p2cUE5c25hUTgvU0dJZ21sV0g2TFVXd3dORkdxMVlpTFRWWXlNd3JS?=
 =?utf-8?B?bk1GK0V1WmFOWURCUUFNZXk1WUQzNURhSy9TV2JzbDJPdUF2QUsrMDNmTG8r?=
 =?utf-8?B?Z2dhR0VqMVp3V0V3cmZVeUF6VVlZdnZvc3FCU0ZpanBmZElTdXdPTXR6YS9n?=
 =?utf-8?B?VDBRZWo0aFYvOU8vSUVEWUhYaE1XYncyWUpkUGRBZStSVTRNWFVVbXJkS21k?=
 =?utf-8?B?ekROcEU1OVRRczZhcERHYVlWQ2hPaUhZWUtEQkU3Sjk0M3RWU0RVbkxYN0FD?=
 =?utf-8?B?MEl2bXIrdER4M1dnY3BUeEF2b0NwSmJ1WTVBODlpbkxyT00ybkFCU3RlVGdK?=
 =?utf-8?B?UmZWQ093UytnM05heXY3aG9FQm1PU1Z5TEhiWG5aaS8wenRIZGg2Tmd3cEgz?=
 =?utf-8?B?TmVvZVg1bjRkRkl4c0FpODFSdXpUWEdWSHBhdjRxM2UwSGJORGxnNnlPdFV6?=
 =?utf-8?B?S3ZNL3krVldJMnNGZ1lCajZyZ0hlVnlUWnFJNHdIVGN2dit4YTRoSmVZZnpm?=
 =?utf-8?B?Zm0reFR6TVIzdHhRWWRBSWdRR1R2RE9oYnhKakw2ekRJUk1VV1ZFNVlxNll4?=
 =?utf-8?B?VGp0V0VyVG5xSFZtN2c1SFZFRFAza1NudnZ3Q3RrTzBaTFlFWFNEZTI4TjlH?=
 =?utf-8?B?YmJLNlcva0xhbW5mb2xaVU96M2grR2tZNURoTTRkeVZzU2d5WFA3enBFeUN3?=
 =?utf-8?B?RDlEWE9UR1gwbXFvWXNEK1g0a1VZUUJaeTJtQzlla1gxK3lLZG5CYzVzaWg5?=
 =?utf-8?B?NFdob000ZVVtSmFXejRKWjNWTHU5V2NiT0UxeHVXa2czejhVcXFpd1daUHVs?=
 =?utf-8?B?Sm5kbzYvKzByeXJDWUE1Ti9IVzcvT0N0VnEyQ2xtalI2WEFhTmx6Y1pwRExW?=
 =?utf-8?B?ck5BdE1qelUweGViS0JwMHI5UzFsRm1CS1Q2Ny82QjUxb1VGSmRaYXNIUmho?=
 =?utf-8?B?SWVqdzJqMUE4eXBmL1orRWNGTzE4eDA5VlpyZlN0UERMVkp0VmFWM2FIZkdl?=
 =?utf-8?B?dkVwMmUyakpsbllUaTZvbmxJdk1QeWpuaGZsQjByOTRNTHFXN0FGUWlTZUNE?=
 =?utf-8?B?R045QjJkYXVUcmN0UkgvMC9CdFdKU0FwaHRab3BIZVFiWnZ2V0tac3JUblEr?=
 =?utf-8?B?WEZiaTIvUVdiMnpmdGFzMWh1anhBMmVWY004eERTY1o2ZXhBUW5Db2NHOW5l?=
 =?utf-8?B?VldSalBGeXJLMjNBNTFqekdMNUxhUUM5WDVKckR1bExRQmVxRWFBemNjRmR4?=
 =?utf-8?B?Z1lFUk0yRkc5UkVhdDE1Zk9mWC9UcHNEMUw1RDUxc0cyQkYyd1JkbHFMY2sz?=
 =?utf-8?B?WXJVd1ROTUM0T3pHSHB2ZWRzbStCamxQRktHSGc4MlhoOWFvRksxdjJOdmRi?=
 =?utf-8?B?a1BSc1ArKzBLcFNGejRnZFNscklnZVZwTFhIeXZtbTVRNUdaT1FxQms5TGFi?=
 =?utf-8?B?Ylh3M1ArUlljM0twVjJGcnNobFhDL1ZpeXIxdDlxYnZBaDJsZVBGK2prQnEx?=
 =?utf-8?B?TU1zTHpaRkdoK2QxQlA0cnkvRkJsS0FKSHk2WlBiYUQ1ZmE1MXdzZi92aGhC?=
 =?utf-8?B?c0ZZZHVnL2dHWUE4aTNLVjZ6aDFSeG4ra0tXaC9hSHlZRGVoREhmYXE0STNy?=
 =?utf-8?B?SE0xSjhjUDJFYXo1TlhSZGxIa3ZkMnV1bG9ET1lPaTFSanVZYktESkFxakU2?=
 =?utf-8?B?ZWRtZ1drRFVNbmoxNVBzVEtCaWN2MWRSa215a3IrYzR4NHpXckR5Y1NaOVJr?=
 =?utf-8?B?VFJYdkE2T2U3TUJxSU9ybDhXODlDZUp4SFVkdlNVd2Fjdmtla25MT1RFc1FN?=
 =?utf-8?Q?yaMpEGZCd7nxt5pzFQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 645cc582-0d4f-4366-a71d-08def5bd00f2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 02:22:04.7726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cd01/1jNSRk/rpR+dX+TN82iTzs67KBOo3+mdPfoEzCE7QrFjYvk68ivxxqEfz4n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5852
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E7F04140007
X-Stat-Signature: y9r4gzxmgfn7rmcpu58fikjsqkhpmwse
X-Rspam-User: 
X-HE-Tag: 1786242129-463391
X-HE-Meta: U2FsdGVkX19NCxY+8JEWIvlwtCggvsKLtBI0EK/OB3q//y3MBtHbMvkkWOw6tSTqX0c/V80tSXKBrgIh6Qk++h5zz6zw/kDTREQNFrlYQf8e8KVPPMiBQXjdHdFZA3j8okzqoJjIsLPgUNdTryZpWIBsHNHe4ftnf5DXCSCZUakhGuLTjdL+iPQuMuJY1rdFL7gV59pb2SdsUTNNXXJ4glB1ryw6juMYbfzCW0zEPleb+MtO9KaFcqumxtukHgAPxgRoNPFSePUX6VCGC+i+qziM41V43FQ77fPZN0mIgRaltPFBum3DDC0zq3yDSP8+XBriEF94lSBuL8xBETARRSGGyYaacgdtUNDSj5xdgleHHg0IRdUeumxkzXJAHlgDnAW9uwpyK4AdpMPgpei3U2NUYzZ5bWalBwInKGK2HMLj0f0GN+cfQ3VXk+uhCCgPucMFRNR+Bv1wumJ1E+HQXSC0FgfIBU58nrvKiLYoL26cC9Dq7GLpUrJeAhD17m1A6qYeYemx8UTCaFFaMB+3Nm8rNF6RsqlHieaoPNiVEKTgmSQwwHdGFqNMvGi5N0lAY79YJy4Q75HL+dEA9QXcv4n7i4HFn29hVtEJO2fSh+1x0eGwQmwYQCG8PVdTtEy340xXj+YL8BgxdkqTveF/2ekwhEuTtUrJL9jNjVr84Ehi2arEngOWdH1uxA0qAWuAwPGkC11buehsb+I/+NYZfG8eFfXx+5RnpA6nXUS78jAwI46a33hZT0P/taU7xnh3qINTQF/ma2RadV1Y94b+MvoekljSX74wIvDWHe/BQu+4ABEpKBMq3YmGEc10v5f2WowWpVagMwMk9gyOPDUAjAGk4Xyrf1pVxuY3rwfCSXOaG8myOkbnJcvMHFUPHrYhCLHIAHXK9vTUJBWUDy9ChCyF8a9NEmJ3arFxPsVD79e0NeEIPSCIxfGlKCbUSIRGrDoKXVhW7Th6CZ7gUKx
 pfE0bhux
 XO/WFIRkysIjP61RTHHaqARmUrSHaFdgpDxfLk+DegRlaieBRkRbgGjQ01WYjD7z6GyQ+QBGekxwFEtVpd81Y7DTeUlEwbTrbU5V7shGzCBOHldN5xH1PugFDJx7dfYC9MomtlixK+Xyere3Ht0bA/ujFIx+UbqOTZjfXudiQzYagBrm2A1ZVZ5NMBAVII2nRAWLolju59thKXt0Zsaz/DN0NNPZC3Rpba0t0SI+D8rO315ED7M2Htu/Sh+MvSKcrEOXNz9BuOOOv10iyVLz8t6BEqL0l2a9OJYxhAazIZWP768+yfBwu17i/oeB9Vym1W40+Hya0D8Ahb3+vZoCgF/2Kolt3nqbIzhnc0zLp7VcR9tvhQjScYmpZUzvLvK2uS85baHT/VMvJOztTIhBxxCGoJLvUkbLBczt1synK0QyOhcaKTtP13gUSO4kppDVREYv7oSS28O3t7892vXJb7KP6Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Only anon split needs vma info, and only file split needs the filemap
> handling. Move the related code into separate helpers so they are
> genuinely more self-contained.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 177 +++++++++++++++++++++++++------------------------=
------
>  1 file changed, 79 insertions(+), 98 deletions(-)
>

<snip>

>  static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned=
 int new_order,
> -					   struct page *split_at, struct xa_state *xas,
> -					   struct address_space *mapping, bool do_lru,
> +					   struct page *split_at, bool do_lru,
>  					   struct list_head *list, enum split_type split_type)
>  {
> +	struct address_space *mapping =3D folio->mapping;
> +	XA_STATE(xas, &mapping->i_pages, folio->index);

mapping should be always non-NULL now. mapping->i_pages no longer exists
for anon code path. I like it.

>  	struct folio *end_folio =3D folio_next(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped =3D 0;
> +	unsigned int min_order;
>  	struct lruvec *lruvec;
>  	pgoff_t end =3D 0;
> -	int ret;
> +	gfp_t gfp;
> +	int ret =3D 0;
> +
> +	min_order =3D mapping_min_folio_order(mapping);
> +	if (new_order < min_order)
> +		return -EINVAL;
> +
> +	gfp =3D current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MAS=
K);
> +	if (!filemap_release_folio(folio, gfp))
> +		return -EBUSY;
> +
> +	mapping_set_update(&xas, mapping);
> +
> +	if (split_type =3D=3D SPLIT_TYPE_UNIFORM) {
> +		int old_order =3D folio_order(folio);
> +
> +		xas_set_order(&xas, folio->index, new_order);
> +		xas_split_alloc(&xas, folio, old_order, gfp);
> +		if (xas_error(&xas)) {
> +			ret =3D xas_error(&xas);
> +			goto fail_free;
> +		}
> +	}
> +
> +	i_mmap_lock_read(mapping);
> +
> +	/* Racy check if we can split the page, before unmap_folio() */
> +	if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) - 1) {
> +		ret =3D -EAGAIN;
> +		goto fail_mmap_unlock;
> +	}
> =20
>  	/*
>  	 *__split_unmapped_folio() may need to trim off pages beyond
> @@ -4060,13 +4118,13 @@ static int __folio_freeze_split_unmap_file(struct=
 folio *folio, unsigned int new
> =20
>  	unmap_folio(folio);
> =20
> -	xas_lock_irq(xas);
> +	xas_lock_irq(&xas);
> =20
>  	/*
>  	 * Check if the folio is present in page cache.
>  	 * We assume all tail are present too, if folio is there.
>  	 */
> -	if (xas_load(xas) !=3D folio) {
> +	if (xas_load(&xas) !=3D folio) {
>  		ret =3D -EAGAIN;
>  		goto fail;
>  	}
> @@ -4093,7 +4151,7 @@ static int __folio_freeze_split_unmap_file(struct f=
olio *folio, unsigned int new
>  	if (do_lru)
>  		lruvec =3D folio_lruvec_lock(folio);
> =20
> -	ret =3D __split_unmapped_folio(folio, new_order, split_at, xas,
> +	ret =3D __split_unmapped_folio(folio, new_order, split_at, &xas,
>  				     mapping, split_type);
> =20
>  	/*
> @@ -4145,9 +4203,19 @@ static int __folio_freeze_split_unmap_file(struct =
folio *folio, unsigned int new
>  		lruvec_unlock(lruvec);
> =20
>  fail:
> -	xas_unlock_irq(xas);
> +	xas_unlock_irq(&xas);
> +fail_mmap_unlock:
>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
> +	/*
> +	 * Drop the mapping while the inode is still pinned. @folio stays
> +	 * locked and present in the page cache, so eviction cannot free
> +	 * the inode yet, nothing past this point may touch the inode or
> +	 * the mapping.
> +	 */
> +	i_mmap_unlock_read(mapping);
> +fail_free:
> +	xas_destroy(&xas);
>  	return ret;
>  }
> =20
> @@ -4176,12 +4244,9 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>  		struct page *split_at, struct page *lock_at,
>  		struct list_head *list, enum split_type split_type)
>  {
> -	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>  	struct folio *end_folio =3D folio_next(folio);
>  	bool is_anon =3D folio_test_anon(folio);
>  	struct mem_cgroup *memcg, *old_memcg;
> -	struct address_space *mapping =3D NULL;
> -	struct anon_vma *anon_vma =3D NULL;
>  	int old_order =3D folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int ret;
> @@ -4212,84 +4277,12 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  	memcg =3D get_mem_cgroup_from_folio(folio);
>  	old_memcg =3D set_active_memcg(memcg);
> =20
> -	if (is_anon) {
> -		/*
> -		 * The caller does not necessarily hold an mmap_lock that would
> -		 * prevent the anon_vma disappearing so we first we take a
> -		 * reference to it and then lock the anon_vma for write. This
> -		 * is similar to folio_lock_anon_vma_read except the write lock
> -		 * is taken to serialise against parallel split or collapse
> -		 * operations.
> -		 */
> -		anon_vma =3D folio_get_anon_vma(folio);
> -		if (!anon_vma) {
> -			ret =3D -EBUSY;
> -			goto out;
> -		}
> -		anon_vma_lock_write(anon_vma);
> -		mapping =3D NULL;
> -	} else {
> -		unsigned int min_order;
> -		gfp_t gfp;
> -
> -		mapping =3D folio->mapping;
> -		min_order =3D mapping_min_folio_order(mapping);
> -		if (new_order < min_order) {
> -			ret =3D -EINVAL;
> -			goto out;
> -		}
> -
> -		gfp =3D current_gfp_context(mapping_gfp_mask(mapping) &
> -							GFP_RECLAIM_MASK);
> -
> -		if (!filemap_release_folio(folio, gfp)) {
> -			ret =3D -EBUSY;
> -			goto out;
> -		}
> -
> -		mapping_set_update(&xas, mapping);
> -
> -		if (split_type =3D=3D SPLIT_TYPE_UNIFORM) {
> -			xas_set_order(&xas, folio->index, new_order);
> -			xas_split_alloc(&xas, folio, old_order, gfp);
> -			if (xas_error(&xas)) {
> -				ret =3D xas_error(&xas);
> -				goto out;
> -			}
> -		}
> -
> -		anon_vma =3D NULL;
> -		i_mmap_lock_read(mapping);
> -	}
> -
> -	/*
> -	 * Racy check if we can split the page, before unmap_folio() will
> -	 * split PMDs
> -	 */
> -	if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) - 1) {
> -		ret =3D -EAGAIN;
> -		goto out_unlock;
> -	}
> -
> -	if (!is_anon) {
> -		ret =3D __folio_freeze_split_unmap_file(folio, new_order, split_at, &x=
as, mapping,
> -							 true, list, split_type);
> -	} else {
> +	if (is_anon)
>  		ret =3D __folio_freeze_split_unmap_anon(folio, new_order, split_at, tr=
ue,
>  						      true, list, split_type);
> -	}
> -
> -	/*
> -	 * Drop the mapping while the inode is still pinned. @folio stays
> -	 * locked and present in the page cache until the loop below, so
> -	 * eviction cannot free the inode yet; @lock_at is not enough, it may
> -	 * be a tail beyond EOF that the split already dropped from the page
> -	 * cache. Nothing past this point may touch the inode or the mapping.
> -	 */
> -	if (mapping) {
> -		i_mmap_unlock_read(mapping);
> -		mapping =3D NULL;
> -	}
> +	else
> +		ret =3D __folio_freeze_split_unmap_file(folio, new_order, split_at,
> +						      true, list, split_type);
> =20
>  	/*
>  	 * Unlock all after-split folios except the one containing
> @@ -4310,19 +4303,10 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  		free_folio_and_swap_cache(new_folio);
>  	}
> =20
> -out_unlock:
> -	if (anon_vma) {
> -		anon_vma_unlock_write(anon_vma);
> -		put_anon_vma(anon_vma);
> -	}
> -	if (mapping)
> -		i_mmap_unlock_read(mapping);
> -out:
>  	/* restore to caller's old_memcg */
>  	set_active_memcg(old_memcg);
>  	mem_cgroup_put(memcg);
>  out_no_memcg:
> -	xas_destroy(&xas);
>  	if (is_pmd_order(old_order))
>  		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
>  	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAI=
LED);
> @@ -4358,9 +4342,6 @@ int folio_split_unmapped(struct folio *folio, unsig=
ned int new_order)
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
> =20
> -	if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) - 1)
> -		return -EAGAIN;
> -
>  	return __folio_freeze_split_unmap_anon(folio, new_order, &folio->page, =
false,
>  					       false, NULL, SPLIT_TYPE_UNIFORM);
>  }

__folio_split() looks much cleaner. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


