Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15810606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 19:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RKikyTCu
Received: by kanga.kvack.org (Postfix)
	id C085E6B05B0; Mon, 26 Oct 2026 15:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92A46B05B1; Mon, 26 Oct 2026 15:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32796B05B2; Mon, 26 Oct 2026 15:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74EDA6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:22:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07D1F14082F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:22:41 +0000 (UTC)
X-FDA: 85365749322.30.7DF3D64
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1E9E510000C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:22:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RKikyTCu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793042558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1ctztWNX482NIjIqYbvV+AasLz2cibtJKVUc8+Ifug=;
	b=YipQYM7LrRgJuvdBUe2LH7/LKyQpULZd7HB91IrpF+N4ImRmtvO+Z1N21wMxB4/VkTeJvM
	LR2u+0mc1/wkkWdCE/mGbbnnl+A/hlE9AczeP8QX40XVebBeN6RgygpKmlAEe94b6xmNJG
	8MkWBwJGZpSzzGTAkQxDYdJNbrZNw/o=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RKikyTCu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793042558;
	b=gWul8t2hvDlNqLOVLP7DQCT4T9PSJeIx/MYf+UahCDi6EcdCuiThPa/o3U9UV2qvSHAmFP
	lca/arKkb+YCvpgE4UIP4k1kqamqciW5+DITBECJrID3t1axGtjZpdwx9JQeIE013ESIak
	idWZb/wAQ70dM8jGfz4Nx3/5taS790M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GPz5LUnri8YL8owt4sEK5jP5Mh6NSrXZNnaz7XBeoZG6LIsh+XCh75qXBrdDr1y5WtniwMwD17HIQ4+KbknENgeb786MZIJ37G4OgKAqUWYmsH+o8KaNnc5sr80Z+E4G7OozrWMP6njYJ7b8QALeTaNkluphctsG+av+u8Fh/d57JXeJyp9CL8uRUmmG1e4N2e/oPPRnbXrUY8tzKp8zhH4P6Illlz30y0vlfObEzRixZIKUpgqnVHLA2hbfAtXhqI52XvuEzuk9gar2TOI3GVkgrWOEDRLmpD1LhCLNo2pR38xKLpoAqLjri8p03cBSj8caO5P7B9niKotHCLsyBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1ctztWNX482NIjIqYbvV+AasLz2cibtJKVUc8+Ifug=;
 b=O14HilhGAbqnzrGSnjS69Ktab8VB3VvD3jq61ZA8QJaSk7UmcJC9OCqyIfRuU6Bui1Qv2zC4CVz6WZk50wRRNTJGZQIqVjDnACZKmnZ/X0gvuVl/hwRmN8+MXFGPOzbAnxCHp5LDVrw+SCHL9+AEjn204fBBhELA24R0mBpQ8PW888R9qHjXOzxZaK9MfHwR7Vqssn4gEKurLPzQZZ5rNcO2GSoaph9mTF6N43iNuSmSaK+zq0C4IsqfZQofc5+1syCeW0XWJf83o4MlLLJnZnOtHidMwRsqhPMAiv6KtGJ54dMUBzYCvX40dUT4K5ccmsBDDP2UAA7EbIWmhggNtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1ctztWNX482NIjIqYbvV+AasLz2cibtJKVUc8+Ifug=;
 b=RKikyTCuTv0TGyRj3RxzPP6nrDuvNCovU4Gjg5aL13kYTj0UHurh8Qa7XuKTWJFvsFLnEKz1UKkeNNFAzBw4/4jkzBPfZvC4x7OMjPkbZdFeqXusrXWHGdWr8ZOQZaMMtYru4kZ5KAZeiptzuLDgVgCoqovbDauGFMD6FHkorVs5MtAe4S+aIcWUeBs4YVNy3m7khxEqz0I7kPz7MZHsd86inevrPSb0hCXxNcU3FHJM/mpu0OmL1Wbi9wSFE9tO1f+NkOKIIOOJlcFdaTcJ+VMiWd6hbjpLyrjnLzebzJx+w6IpcPNWf0e5dqfV8JG3z8gejljx1VlljonM3IwsyQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV5PR12MB9753.namprd12.prod.outlook.com (2603:10b6:408:2b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 19:21:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 19:21:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Subject: Re: [PATCH 07/16] mm/shmem: avoid moving the truncation start
 backwards
Date: Mon, 26 Oct 2026 15:21:30 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <2E377C76-D62C-4A2A-94E3-ABC40C6FCDD2@nvidia.com>
In-Reply-To: <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0892.namprd03.prod.outlook.com
 (2603:10b6:408:13c::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV5PR12MB9753:EE_
X-MS-Office365-Filtering-Correlation-Id: a7b4ce4e-d6f9-4d34-eeaa-08df33965907
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|261026121527099003|4143699003|11063799006|56012099006|261022105027099003|261009223027099003|261021121427099003|10067099003|261021123027099003|22082099003|18002099003|6133799003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	J6n6AHmOZyoIcgd2VKZifHWDFd6cwrS4MNchjxGsoV2TjQQbeTIVmbY9uTq2iUVglJi2NB6zFftPpv0RO+8nnuUUiRipIZFuof7TmfwO1hyuTnFvdFq1J7aiwM2ebGumhrTVa4qLotgrnTTzRdLrSwTSjTbZQxF2E5C93qAw+WYnWglyGZb7E74KUqG7FNYnSSvyHh3NSQNtaj6Mn2W6zzZYaf1yaarBNX5llIZAKYrbQTs1N4Zp9qBP0Gh8YHepY7rbVxPmSTF97HKY2CpJkU3x8yEXIYVQt0st2YGgK8msWauMYRtxV6bhE22sRv0nmKbYalCYhn2gET6yKsdPuRnPULj+d916SAyJMV5UAvynwAtlTKtvNkWxgAAY52xTyMqImRaDR2RdWNLVI0MGfLwVwnqdv/rj3LKukt8rpSZXQTvVXG+qS/Z3ic27xwWCbX0OwnHZ7VC9ZoauTdMt7tFVvpq/4DZF+4A2JpcLV7l9nvN+ce4BLBYrHnh1rV7CHCufpbfjrao+FML545QFc1EC1cQgSb0PKDGnltSAWjzYNz8iw5i+d1KuhZMSqx8O/VL4tIoF2ZtrWR5GTSi5T1XLrF9ZDM8bw0t3mxZl0opl2BjhvDpQkwxUw3KYxgotEg/VghC6pDYA+dV3f+MpOJkfpIbvSvSVkonDRScsn54=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(261026121527099003)(4143699003)(11063799006)(56012099006)(261022105027099003)(261009223027099003)(261021121427099003)(10067099003)(261021123027099003)(22082099003)(18002099003)(6133799003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MENrelJwUkNqSU9lTHh1dHB4ZFNvbTl5N0tVN0tCcS80YnE5YnVMTHYxdEh4?=
 =?utf-8?B?MWdGK0gzTmZCMFlJTVg4RTdKNmlQSXFGKzc4MFEvdWFySk9Xc25LakRYOUxX?=
 =?utf-8?B?bGpvbDk5YVZ4cjZwSkQzaWRLL2UxZ09mNDU4K25VSXJDWlQ3OHRvZFV0bUZN?=
 =?utf-8?B?YU95amhxMHA0SlZyRGZnTG9rTkh5SGFEaFVON09DR1IzNyt4UVJDREJqTTFQ?=
 =?utf-8?B?dUlpb0F4R2ZqSFIrcVhYNFhsbHRMVXc3UlJuT0IxVnIzbnpqc2NHQjhUL1BU?=
 =?utf-8?B?dDYrMVZvTEs2TU9kUjYrVEhDQUJsS3FLdDlxMEhuRkhlVHFyZ3ZBWi9kOExh?=
 =?utf-8?B?dnNsWjF4dlduTS9QWWw4SHNrVmlxRzlFQTdRNXZmWEs4N25KYUlsVnRzQUps?=
 =?utf-8?B?aDRxaWwvT0pWZ3liQ2xITURBWjRuNFEvN2hyQnRDSWhMRlFraFI5WEVFektP?=
 =?utf-8?B?RmJKM000RVBnQnI5TFRxRUkzTXdZT3l0MEtIYWJKWFFGN0lPRmY4a29kN2Rv?=
 =?utf-8?B?ZWNEZlFCNklOUGMvSk4yM3RxMk53dk15bU5Ca0JEeHcrNU1HTXlWcTBNdVRE?=
 =?utf-8?B?Wk10QXp1WWdjeVJ5cXd3QTdyVGw3S2l3V0JFbWxFSVRRNTUxY3ovbDNFaGF0?=
 =?utf-8?B?Y3ROaUtOMHBBY1o4dTBTcWtnRHBETDMzdG5ZUDVoSEtFTXpRdHE5bm5kaDlk?=
 =?utf-8?B?dS9zUGV3d2gzYXZQZE04SHhnN055RjFnSFpRYUdCZ083RVpLd1Q2S0pBR3JY?=
 =?utf-8?B?SVBYNUc4OUFyTkpieWwyYnF4SHplckpjTkV6OVdOS1YyNzB2R0VsbU9DTDVB?=
 =?utf-8?B?a2t0SzdWRkVkZ2lzY1p6OERMcUwvM0tFUElBV2RPbHEyaXI5c0tIN0RKZ1ZM?=
 =?utf-8?B?UkNjZHJvazZBQjJURHh1UGJpL1YxNWtoTGQ0SG5FWUVscmxMN0RWbEEyQS81?=
 =?utf-8?B?aDFDWERDdjNFbHl0aTRpWGcwdnBGcTRnc2Fwa2NRelQxTXE3Z1FUU1hGdFJr?=
 =?utf-8?B?S05EOTlLZW03b2ZyK0ZPd1hnVG0yeml0dnV1dmF5UWVNSndXdFIzeGIzK0Fr?=
 =?utf-8?B?TFpHVi9pdjYyQzdaY25ac2xnYkpxa1dGODlGUHVRK3B2b1FQaVIvRk5kQnQy?=
 =?utf-8?B?TXN1cmRjWS9ndHZqYVJNeUlaNEhPbXZuNGFvTU1LTm5ORlkwVkwxU1NXWG9E?=
 =?utf-8?B?dndNSmNaOWZ4cmxyYnNaNmx0OEUvUDJIRnlFcG9tSFgrYzVLTUR3UGdleFhv?=
 =?utf-8?B?R0c0M3pmWXErYTkzcVBsNThZMkVJS1oxdUJ2YTl3RXlKT0U5dGRoSEw2bFgz?=
 =?utf-8?B?RWc5ZWFMeUZKK05yb0hOQk80dzNETzhMUzJ1RVpsYnFJWHpkM3Vna2NMQWlj?=
 =?utf-8?B?VVJkZWRxS0g0TFlSbXBkMTIxUWtadVRoTmFvbW5GbC9UMk0wajlxZ1FoZ081?=
 =?utf-8?B?a3BzRjVndGtzNkZsbFJob01SNnBvZXlhWmhIZ21hYjFBLzlIQ1ZYVDZHMU1u?=
 =?utf-8?B?NU5JU0xxNFA4V1hXSFdZNUxxT2ZtUXdvVldBT2R4ZlRrVHZ2bUI4MUNlMkZt?=
 =?utf-8?B?VDlsSzBid25abDNTL2hXRnFkZHZlMk1VQjl0VTBoVlBJd1hXZ0dqUXJjbGN2?=
 =?utf-8?B?ZGI2Wjk3OUF0R1hDUkVsek5sczBoVXVmOGtXQ3ZiaDBubHBPeFJXUWtlM2Nt?=
 =?utf-8?B?SDg4MGlMRktRdjhRM2U5SkpEN2Vrdks3Y00wNTdWdUltRGU5dkw4ZzR0WE51?=
 =?utf-8?B?RjZ0d2NtQy95N1l1RUpIbm16bEpQQ0Vhc3BxTWZQNm9IdURmWERuMVlvVUhD?=
 =?utf-8?B?RnRiMGt2N2Z2b1d4YmxNc1dEQkJVd1RmQWtaK2taRXlROTg3U1pnMFNxZmlk?=
 =?utf-8?B?Tmdmck9NVTZYQk1aNWVVZmdLdjE1M1k3cXdFVHpiTmQ3am9WYjkwZTk0eU8w?=
 =?utf-8?B?ZUx3ejlLYllONnB5eC9tZ1Z1a1h2U2E1VFNOR1RwQXBYcHdOM2FVbFZ3UCtq?=
 =?utf-8?B?UVlVMVdsT3l3NlY2YkQyanpkNU1kdDlnL2svWi85V25qcFl4aDRnNGl1d0Mw?=
 =?utf-8?B?MnhabjFXTWVwMjA4Q0RWMjVrVHRxNnE4UkF2ZEFiUmhxNnVLVEM1RGFsL3J0?=
 =?utf-8?B?dmVIaU1JSDlLVXRwMmVpZDRscllYTS96ajMzSlJOazNJSk1jMHNiTlFqSlY0?=
 =?utf-8?B?R2cwaWorSmI2ZUlKT0hUbHo3enNkcVdrYlJ1WStSSXlJYjV6blBIUUdyOHhG?=
 =?utf-8?B?TFI1Y3gzSkdkc3Q1NExuSmFhRmNtUXNmSDVYb0srMWxiaVNUOWt0bXQwQ3VT?=
 =?utf-8?Q?dBZ2c1fDn0F59g92OP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b4ce4e-d6f9-4d34-eeaa-08df33965907
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 19:21:34.2919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yb9dV+1uBU5neY5oLETyJrabFI3IKNc2INvdlmYIUnD8SGqfyIVKLZ5X+8FloTAG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9753
X-Rspamd-Queue-Id: 1E9E510000C
X-Stat-Signature: oaohryqjkdjuormxpa1zdezc9yr7aoye
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793042557-847082
X-HE-Meta: U2FsdGVkX19ybgjZJ4yi1zSGlhm372125u8ZE4WVmpryULYbb/+Q5qVO6xl4g3GH3RwDUzYOIEGUvGZoGL/cC0TkaJMyes29lP7WmVWT1zWqYclBZpTz40U+1nKiq67RK1J5mESJRvB+va4+rdgdV0doX5b/TAbQSHtqq+vOkdqNFsX64Ix4WL0Tvq38aGRwFeY1CPgupg5r4C9iIDMFHsQFjO1cjQIbNwiXWvc63HhGKBin19BqjkZiT9HsrsBU0jwOtQw16WPM/Sj7tNNemYrHtj3R8W5ccy20dKXvIBfcqPyx61cibeI3ZK7OCBEg+mmTxR4YZ8KTVtiWBdpiNbUr9TqiC+rqkVPfgRoNKAvzsaHx6xLkACR2yexudXO7bAQNw5T3BLaojMvIpz60EXf4OVBET/N+v24mwZ5XqFJVdZ4qpUqgO4BnQ9KeTxDlrCI4jZoz64KWWCnOdYkqZDTuRSop6pG25siA+IuzG4bRM6XNMUeLwJvXaTSTgnN7PLCy9fZ+QVgTdpO0TyksoE6EPgz2ERYbeYV3zQ2/Z8vmzQKV5zXEplDZRCYOW3twZi2EPao/pXp4HdbY9QQUsMlVkKu84p4MgXtG5wAJ1oCvKDe0zlRLf34YvRVecNLSqVUQU7Chq4QZI4ziTN/gQoQPgw17SuPOdYUxFk21SyWQScm4vTkT9Ykm/IwL6+FnDhe8vyV4CSJvozo6h807UyGW/XUXBXF5d7BAw/cC4pfWoP1vBIP12SueXCBbQ8qEC28lghn8KbuqXJOhtc6RPKAwwERQ58/KCz43KIn+ADqSI1IdPpm5RadEk+bvmgbvHUyYK2MPsIE899zNsTzRSRc68WZW8/uHAI4jS7v9+tTbO1zylC0IZe124ZJzMsgG0TjRk/QUDhvQ8sqYLuJDgqZV7KZUVn3GJI3FxwdL18wOfbxPDIkQMC7sbjB3JqtOzGYrep5FrWAIr92XpNM
 U/331jqD
 sOGIRvmotfusycBNW8ugo+Jz6+iYNg8BnTN0wj6Zjd+TSS3VOpnWdOuXFsD8x6f0yKdY0A+gJmKTcS/ME0o063DzvqYe71mBJ0Hm2NhetpTaYcb2EiZYbeXqOvKRt5RahoL0sJ/LlwYgu3634dxsk0fzQgomG85lL8UC7DNl6ZPyWoZTptJnlYg4utIP0TezfNxJ1i9FI8rQdhNO38Oui5d7fMFPBoqh9vP0uIBr8qkGmgYGvbdgCZXb3lQ+Yxvc1+Ii7EFkEwSryDfferD2dqcFRFki/egtgLmX7ilKkZ8NpCr+skLBOl2P4keckjQrWFx0Q6N8FCfkaKnht+QUc6TGeb7xW75uUaV/y4QS6TLXMbacBdvvqrSFi0j6Z8CXSiPIVjV2Ia78tFAL2p4H1MwSqvmPJ3G3N5Y2usPrCQZ0L/AfBUucsoZFqvNkIFgpdvkfUoMp6cOalzHCxXZjdKBb3ETa/i6a6kGVbUZrk1O1ePNadjogZ5jpY3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26 Oct 2026, at 5:40, David Hildenbrand (Arm) wrote:

> From: Chris Mason <mason@kernel.org>
>
> A nonuniform folio split can fail with -ENOMEM after splitting off some
> smaller folios. shmem_undo_range() then sets start to the end of the
> original folio, which may now lie before the truncation boundary.
>
> The final scan can consequently discard data below the new EOF, or
> keep retrying a large folio whose split point lies outside it.
>
> Keep start at least at its original value when skipping a folio after
> a failed split. The part in the truncated range has already been zeroed.
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operati=
on")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: split fixes, simplify descriptions, adjust comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/shmem.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>

This is fixed by Zhang Yi=E2=80=99s truncate_inode_partial_folio() fix[1].
I think the commit is ad27479793682 ("mm/truncate: fix data loss
when splitting straddling large folios fails") in mm-stable but
not upstream yet.

[1] https://lore.kernel.org/all/20260928120833.3440834-4-yi.zhang@huaweiclo=
ud.com/

Best Regards,
Yan, Zi

