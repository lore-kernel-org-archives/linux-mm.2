Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F975606A330
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 21:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=X3fO7Qsl
Received: by kanga.kvack.org (Postfix)
	id 2B1DF6B0623; Thu, 19 Nov 2026 16:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262576B0672; Thu, 19 Nov 2026 16:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12ABF6B0670; Thu, 19 Nov 2026 16:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0E776B06F3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:47:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B738BA8A8A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:47:31 +0000 (UTC)
X-FDA: 85453205502.13.A60A50E
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011062.outbound.protection.outlook.com [52.101.52.62])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC30320003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:47:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=X3fO7Qsl;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795124848;
	b=eQ1FF2nvd4dU6JPPUYmgpNLLoB7EObQdftM7LDaPrXXWJ//lwJptXJ2ZRiVpJZOsTCclwY
	KJzZD29rayXfnTsuquNJUuNa6cm6bvYBuq6eBhyYNX4BowaK1yQSFdp280anu/4DHzAXz+
	TcmZUSGJJiBSYjB7BeIrgePXBK08k3Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795124848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMlFebgAdFLtndzHd8g6KCosKNzHLk+Lbi9q5dsjTHM=;
	b=sKHPE8lX7PeCVD4kfjOG9xY5try0vqlpIqzFwhJ1QC7gc6WDl8lOCEFMaHj+xPrknqXVpZ
	jxxNiSUsWYajzLJtfTGrFWdHMtT2us4w9vOgMiP6bHwrxTE1gKVCsJSZZy3uWvd5RTtMj9
	uCmUBR1YVL5oCEYnBSgkP60fKhZTlLM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=X3fO7Qsl;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMVml5prmzhErHg/+1+DCCzrdQ5h5byi6pyXpQVBZTpAH72ovLX7sDWsOWPopjhdjQE5Es7Q0UhMkPjdefHbi4C0N2n193w2H5Mx2qQXqQeYTVBraTvjF68FXkrtTyAVdvPauy7KjqyA4Nr9OO643zkLbLselyNTvOAaLOZNa3PEYJ7x/X8wpwRtxrMugu+kqLzisi/zqEp/UrjmgQB87B0SRW5w0w1IETc8Pax09hExzbd82ElGzmer0QpcCw8PindSzFtBsLkv83aIuaiNB1y7653nM9tA55Ya4t39Dq6DrfOO0U0GCtnTbjT5TX6vp/vVnfVQ3F/OHGztk9c7UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMlFebgAdFLtndzHd8g6KCosKNzHLk+Lbi9q5dsjTHM=;
 b=cYtxKkcZYu37wJJWZzZCAsHxIsLbMQ3t3sSoN35ufdexb811FismWlM0rqXir7hEgfDKizGceBLZBE7/Rt4cFNZjythMKk7cDByHWUpNH86xtQfjwZ87+nz0KKhY0aa7mkwtHmwSeCffiBGaLc0nH4/s8BhE04CKwrjg/BFq9N1IalIZwRqen1gK3ZDsQWU2wl7Zs4gBTQpFijhmFEcvPo0HFY2iWDfSadqbvzsUjLZkOsU5XXOxlMsbi9wx9Xc77VoWuOW6f7CBIUyJVj9u88Lso3a5X2sq8ZCP8yIpGdFslS88+eUWfllGpoY/9jIgDvMM4JkPIJE7EtzSRX8rWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMlFebgAdFLtndzHd8g6KCosKNzHLk+Lbi9q5dsjTHM=;
 b=X3fO7QslrwhAzEfaUcWvm5csUvRQSJ00HpDBR4JCx/aTtlpEeBVTeGkW+2qyWardgi6/iY3OhDHocCBnbl+Zxq0UuiqXSxcZEOVgKrTPNIMf9grvQ8rimf+c8TVFo1ycuIs/BZkmtTb25HmnXUq/pEW5RZW0cXiCUA7IhYkccdZnO5iljfvqg9COBAb86HOsyTmDqSwBDHFLC6H4Gu9iHXBl36Wfmrgm02GMNCtok5PeztmbkUskdLnyCNbfXSbygwX7U4Mr1QFf8kgy5MqZ73z0VSiMnK3/HZVBSjceqtbvsBhJmyxHzU/SuNSU66oPucZwEFiYYCPmXgwEvTRIWg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB7173.namprd12.prod.outlook.com (2603:10b6:806:2b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 19 Nov
 2026 21:47:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Thu, 19 Nov 2026
 21:47:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 =?utf-8?q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
 Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/vmscan: flush deferred writable TLB entries before
 unlocking the folio
Date: Thu, 19 Nov 2026 16:47:14 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <270E76EA-7C09-4251-96C3-8A8C45AD1AF8@nvidia.com>
In-Reply-To: <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:408:ee::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB7173:EE_
X-MS-Office365-Filtering-Correlation-Id: b3eb8179-9a08-473c-95bd-08df4686ae50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|261102123227099003|261022105027099003|261026140227099003|4143699003|11063799006|56012099006|10067099003|261021121427099003|261021123027099003|261028144727099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jKPJkinmRw9/gltqiAjW6hKxBCNTFqCUgbpBmDtZe0lfeUQqxH5T1IFfwv9xBGIzAPlIW0mBCPS/NNAs6QKxOWVdJaosTSU/YkdI5gwrT9Qo5UfQQFYtsRjINSv4M0Bm0eSGYXtKFkEoZXVILVU51TkiloAU5mozMoZvQIOjSI6/YFe3XsJGMmDKcpu46xMdf9D1tP8YBXnZkaKgQBxhxhtcucErpRkJJKUDaISq/Jl9WqQOhaoo5euP2QmRBhLAk4YpgRMOgKbsWTayybR2Rp3CALX5OCKqAcrVfHemlOHRoN936DvT2UaLVNWSqvZdwsCnvvEGHWGFVLMbHtRodniiGncarbHKkg2/Wzjza40T7FCZYPdKz5fTlZdodJbEB3n4TKId+laoXoMCoXhLPmH6As4+LptQLtxFtYR6mKcqt4wIjeDVrl2SX7l6rjFkGrEmIqRyCIOnQw14l1if8/FQRozg8ymMbfHI3cT22JcI96xbLiIrYslpLxxhXO8UylW3A8qK+qivOxnv0Q2tcREhZrzaG7ZTbnBPPTjNvvRopt6HlNlMOJf9EM8af1MNam9WfuukjbOXAgf89MXvndoPRHIKv8sv5BvM3t1V8aqo9xFAUtkQ5b97tzf6TCKNYSKpiNCxYSlFvkWSFtL5yWO5i2QXRGvPN/g7s9MeAFM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(261102123227099003)(261022105027099003)(261026140227099003)(4143699003)(11063799006)(56012099006)(10067099003)(261021121427099003)(261021123027099003)(261028144727099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TbQnZ2FQFUdWpPjOXM6/2RkN98dY+IZvs0VYmb0r4o6GyV28+4B7W9h/RMrE?=
 =?us-ascii?Q?qKm6IMS2eCaTla+FB2YNdy2xbq4LDXD1DT+6ppXOg0O3HY+co+Ke1CvN8fHZ?=
 =?us-ascii?Q?RGkHnMM3co6YEA0dWFOx2/NW4Y9CUSVSxhwBvAojub90rrS2rGMgjuXjVm7h?=
 =?us-ascii?Q?SOvv3a5QSqdjar0rsv/i4e7h/N0YxOn9wM20mLSIzXa/h2oT6VLJXlF+3KVt?=
 =?us-ascii?Q?oY64vH7AwFSyby29+SiIMGozC0ys6srbGUe9EP5Ugy0ImBlGQwsImg6Lzj+m?=
 =?us-ascii?Q?xwjoNPSGdyttKztuPcnCr7Hsk3xKZTocFhvSYywot4LjeT5Uytws+fM4olkk?=
 =?us-ascii?Q?/2q7x1nLX4zB0wgq530FuJdz+Bd8v0d/JarC3lGPS+L3qxcRynv5ja6Dpslv?=
 =?us-ascii?Q?9qrMq0Jt9f4QjMnuBSQ3v3McmQ1lezdiENMjC2mYdTGPbUdpMQvjA5BOfraw?=
 =?us-ascii?Q?N3JfMynciEs0opqbX0G5k1MV0kQgC8GGdVjD4wrXFKW+1Tm14RAd6QiUMg1p?=
 =?us-ascii?Q?+qRAKOf31Bnxli/w4YrROqdfxW/AqlT+lLtQTt+DcpR6f7dCD+JLQIF6ZnVo?=
 =?us-ascii?Q?gmQuvAtfAWhN1qQbLo3OcZJjJNIMHNcXWV4IVNp94YOzNCwUdA5yuy3yMBPg?=
 =?us-ascii?Q?H2CsZOK9v4L1Qr+dI0ivh5fSq8eTRtNhCKhCKEIhUKagCc3BL1jnDtGQp5mR?=
 =?us-ascii?Q?nAb2kmEq2hB6L9o98J77kwCzQXwB48Xo71u3VODN/Y/xuVg4C7RVyu2SmSrz?=
 =?us-ascii?Q?IL26NR9RWdHPMwtgUDwjRtjn1SgPZEa/tcDZ5QB7A3OOwHMKYkOKbBSz9CDj?=
 =?us-ascii?Q?Ktik9LeYU9VHCYCm3zUXax5i4T8sODYnLihdZSm1lTnzvpezYgXjFO4UJYUc?=
 =?us-ascii?Q?8lkDT7uzD3GUz9G+hJUOF2hfilCqMlNMc6uyTR0UDhCi/j0g5j+y3LRPpW5V?=
 =?us-ascii?Q?mrHLTqeXoPebep4rpUuUbvIEtngXCyd7+0PO1w/cZQDk2P2yjL0b0u8efd6d?=
 =?us-ascii?Q?FI0qddxGMCVIkA4DJQfXNoToyjTjhpjA5zGZgXqw7xLOuc8TxHmQaXDDElNi?=
 =?us-ascii?Q?NINu+SOLGRl9udZzVfdlpayGhf0FxdNfiJ4A2NSn+TeQqcb28yskcfHCo8EZ?=
 =?us-ascii?Q?QN8j93kXgV7Fynx2ONDpwgdjnSV2pQHaKZpeWxPinBHFCFaqy+LD1igfLgNg?=
 =?us-ascii?Q?3wk8xaV22h1ERKjaGG99b2KKJsiTwVMec8Fysolt1Dw/KTsBTownxl7kBMXG?=
 =?us-ascii?Q?gHzv+gnD90638HHqf2yElgkiGJNYcn5YpS+FQaz7Pu/wvF8bu9VrTekQjx23?=
 =?us-ascii?Q?FV3ppEwygEDkqhg2Lph/QF9tL+njxqksoRX6qRSxgi6qoVAA0dVI2GzV4Cns?=
 =?us-ascii?Q?ohJTw+/fDINlipC0CAxxyGMaWE0s66zXe+NBEwB45yNX4GZQv4UDmZVPEVOU?=
 =?us-ascii?Q?i6m1fI0C+Z+KjeHTCiY590FaTKTm57bULttuKFR5hh5D4bKA3UgdRS5vCoBq?=
 =?us-ascii?Q?ulxJm+kYRXi2bY5N/AiG1hFQTdYXfB9p40jFMWdmm+RolVR17LQAc76PWdqH?=
 =?us-ascii?Q?q7Nq4KxnXF7XRYcEAqhKhqaw1woyRDutFkAT5TKPRXvHhfNRYfrhTuzNgyoY?=
 =?us-ascii?Q?0eTaeOxamFZSYmRV0UoagY+DBD9F5Re5AmyBtw5Sl0PcCfqqmFh+rz5uQhsR?=
 =?us-ascii?Q?f6hSmg1ILBwFTiuNgx1zIQcxF67aIiDkJBg7O5aweG44Jnp7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3eb8179-9a08-473c-95bd-08df4686ae50
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 21:47:17.5881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ef5+tBd0i/i0TYCMAKcBLWKac2TTUvh2OAmBbUc7OmXfsN4PdeX0gNLzMUyH6zph
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7173
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC30320003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jok3ug34bn7orajrszyaiij1zmtfy336
X-HE-Tag: 1795124848-505002
X-HE-Meta: U2FsdGVkX19DjgVlUNsPxVH65zIecJYJgK615JeMrQQ7CSRMdPtiSQsOxUFI+2WNXr2PgVLAyMw2tzCdHhPcNm5Kb80xq3y3miOr3o00Zx70mGsj0UdmnSunzO31WevxdWwYFfCUPqxWATg7aegRHYnOV4BA6dZNnce0qfkz83FHKUUBy0PjXOn/i3ZardO9ONWdf277Utc+wPRs0gPruyoSUzW5Mw57i3HQvkB72JMPUJmlBnLWptIbURW0nMvDRXbrr7rmZyK2OIaODdUIeaSKu9/BV06EIXwG99BNF4fHH8NiqdXr0jIy64f/e7OQUmGu8qOAZPgPXnWBF4V+JbycI3dnBImtR9slj1bwR9l1o0skksjI4JVXKg8UptDKt0YB1IxI/tbjy5gBLEQkbtkkwwlujYesG1daXKKwnJrC30OkPn7bMG2VPmI3tt0g2PVWrLtVwjpIxK7EaZCjn7Hce7BsdRyh2gB8fNHEPc7Hd8XDpahV6tXu2OyZL/IqCo35zwXW45YZuy7xGfeNvKs0Hiv0zEkvbyOk5TLPO8m/a4N4dBc9zVW5On9m8HdaZoQ0s8GYWMvK9RUhfdSih7Ynmoo3R6xcCdF70B+PWCE310YJKY/IB5uB2bT8LxXPzcaCdGEk9vT1EnofkdXw6lt4u2evbbT2sSZhmB3waOxc4/eQ61IPmFbzCfaT8YuAFJElifOjPyvvDELgwgMOYVzNKxUeLpjolQPn4Xnm0Hiqm7BRY1F258k5YHWU+kilL9cYnVLYgfWsKjGrLj3VbrktTmCnkWmLxs1whXUiYFsqn+DTc4Ag5YTs/2EjCIVror+lx2LxIXYDwuPDQgfTMB7zwXSimllDU01J+IfXNK57zx8x+8iOR8/SjnQsdedo6i6Snt3P7F8GYa8ps56wstNU6qDE5mlrYqZTKVyqb6qLXD8MYtKUguq7hhLh1I88n7J5mvp+QCg3Mj1wzOd
 MQwHzIB0
 BeInIAEjrPQe7RanCOaATdKxqZrd0ldiiYvbZwCQBwv12dmU0zycTLzFMkbFay9S/OzgfMKVI2jmRrO9ua/RpDjbPN32gqpbtWJhbWSNBUeD0Ek5DXckB2NW00Ql1nag/vSwDBAfGKd0V7b2zFveEItHA6DVf0NteTSqBgt63QkL4/bDLc/p8BLWmRqELIXOneipIYrdO/lpTlVO+384BxWw1NWdfOz04SUn6Gy+hLDtBbTrYsESFtPfciZVTjWwBRVU1FqpLFAndlgAwxRcOG8FVXnjODhKQjpJiLw+FYa67twXG9d5pdGszeXHoe38ppod0Pi/Ynbkdzzc8xd/xocxreL6X2jEuftsw4JGSAa13GpQGPfH/QgLM23fxI3c7eYRPr7DhHTUO/B7SGnj1QImoBoleAff7Z2dI1+zcaOXzwt5zgJ2Y8Rg+oOq97Srd6HbozDWCZw7VjhFHqjrkizsTieYw2SnYV6rhI/xRpm4UFHqC+w4UuGPjZlsM2aTFZ12QQRDyama2wBtisXZ1PtH122YwKvdiqqx3aue09U7fbV/GACcUKW/oUbVh4JyeQNM8lLNAycM2Yz3d79UmaEtqQis1jvXSpQlJoLTAaXRfVBcpbX6HKyxNZgISgjWhJqaG0vvaaq/gFqn7igiEbYxlNIw9tK5vDz7o0Dov2Kd3vNggVcFnMWvEW6fKpTabcJshoXYi+PeV/fo0FDugxhq99ZIkhWLto2Kg03cTB8ytb3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 18 Nov 2026, at 4:20, David Hildenbrand (Arm) wrote:

> try_to_unmap() with TTU_BATCH_FLUSH transfers the PTE dirty bit to the
> folio and defers the TLB flush.
>
> Reclaim must flush the TLB before unlocking the folio, otherwise stale
> writable TLB entries might be left behind temporarily: writeback started
> by other mechanisms (e.g., fsync) will not find any mappings in
> folio_mkclean(), so it will neither write-protect nor flush anything.
>
> A write through a stale TLB entry after the folio was cleaned gets lost
> once the folio is reclaimed.
>
> However, reclaim currently does not flush the TLB if the now-dirty folio
> does not get written back (e.g., gets activated or kept instead). Fix it
> by flushing right after try_to_unmap() if the folio is dirty, which makes
> the existing flush before pageout() unnecessary.
>
> For dirty page-cache folios that reclaim activates, we will now flush the
> TLB immediately after unmapping them instead of batching the flush, which
> is the right thing to do. Performance-wise, it shouldn't really matter
> much, because folios with dirty PTEs are usually young and reclaim won't
> even try to unmap them.
>
> Fixes: d950c9477d51 ("mm: defer flush of writable TLB entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/vmscan.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

