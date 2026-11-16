Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E471606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jFnRzLC4
Received: by kanga.kvack.org (Postfix)
	id AD30C6B05B2; Mon, 16 Nov 2026 10:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83C96B05B3; Mon, 16 Nov 2026 10:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9706C6B05B6; Mon, 16 Nov 2026 10:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 748A26B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:41:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12031A0104
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:41:21 +0000 (UTC)
X-FDA: 85441396362.09.BC9C318
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010004.outbound.protection.outlook.com [52.101.193.4])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2A03AC0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:41:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jFnRzLC4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794843678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJstAL6MogaAIeUvGMIAJC1vgqHdVYzx6buEbwn7s+8=;
	b=5YHRImeUMhzfUWubJH9ms702sDheXdWdDGX5VA5ydmDIA8UP1LqAogIzhMOhDQKJ56Wj1o
	QNmsGhTf03tRQHNNHwGJodhYYDK1bO293u0uwREryYNC3KYbj8S1osFeVcXjTaLrG2W5OR
	AyvrJ90PpcHryBAipim9KEcne/2F+rg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jFnRzLC4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794843678;
	b=Mlu68+YU5pQnu6e4whC6VVRmHzgHIJz9Gp8b2vFh6pH3mz883STvGh2+L+JzuWeaKsUT6T
	R9eVH6pkJigVXMacd2fzE6JhaF2aw081n+6Ls1J0/xqykYRhQW+W57E8KarWfoio/fVee7
	nsiwqFph7rIxuKYGr/bcfU5brPkClTY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IU7D/UOtGxSVBhEodp7Gp8UJBkIRAA/PsLtvsga5TjBUZrj3mBj7SFTwew6ufv88KLcVuh6qWE4S5XfOpmOxZXIEP7PLNWa6GzInMtcqLhdqI8ooOfcXabaWW47c2jfuvtxqZIRQLUd6KRi5Dqr/z2/sxWBh8Wkn2NHu7FDaDe9V6mTIwiIvI8q35YbmDDrye9SRTtekc89Gsqjli5nt9UsIAYeN14TAlUMCiY8k3fBWD25YkXqIyxvgOK4FVIMK92RHx6G3mqGd3FMOwxPzNHIeKSMoe3Pa6+Gkqqz8YJ1WBpxkIuiYDzsJLZkhcTAn3IoaU7MNLJ3hXI0RAOVxiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJstAL6MogaAIeUvGMIAJC1vgqHdVYzx6buEbwn7s+8=;
 b=XN6xcfZMXQ8for0o4AF9rTotLphr6K8ubOU3m+OeWPT+CBsDsbGVA1IRyZK+g1AkIcm+e0aMU0gBBbE/0twerveQ9kqpvnkwsa3NCbO72AQUiiV/WRY1NO0WjiHL4XpgWmcCdpXyfIEwbPo63M59vn6UQwytdLuEDJ6kRg2+RTXCCIAv85Pe3WIx14WUN/r1GGVanyTAsyNLoEm5vzItCNnzvsdCe8LdoGtRgypZYrq2czBecxwBzpZAnnvqPRnCUTCcw/yPj8SYEcToTOwA2VOAhfRSaVSgXxLKZti05QJjXFQXoRnAA565BnrC37v/a68X9ypmlGq6O52tbqa4pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJstAL6MogaAIeUvGMIAJC1vgqHdVYzx6buEbwn7s+8=;
 b=jFnRzLC4E2d3dIOHu+DjT/3RVpnKUe4K6FaHhyJ1DN4yFj8WHdxwdL+jQ6wblPw77BZuL5WgCo8B+UHtWGDLUWkLRc/T0gPtaTAoKCaYdQ9HwxPTLwc7kdFroMTsqeMXGCD3tASUIk9Sqf9Wqygm47HoIJOpp9GfD63H1qiKbHHiRqLYG2UfdwINWXz1qW+YkTDPkVIE5UG+3RMCRx4biBG2ctW0KyJOTizUeA8mMvfv86Sr8kFHjiDm/8Lganv/tRTEkwTNbeV2x/Fq19Iz+SqnbtpsUosNdZQlcxsZ56mWVyeA1zMVF393EsIeXvc8FH9rnsDTqWRIYalYb+26vg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA3PR12MB9107.namprd12.prod.outlook.com (2603:10b6:806:381::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 15:41:08 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 15:41:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
 Ross Zwisler <zwisler@kernel.org>, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/mmu_gather: delay rmap removal on UP as well
Date: Mon, 16 Nov 2026 10:41:05 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <32126FB8-E9ED-444A-A086-BE11F2B42C87@nvidia.com>
In-Reply-To: <20261116-dirty_file_pmd-v2-1-571883053174@kernel.org>
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
 <20261116-dirty_file_pmd-v2-1-571883053174@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH5PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:610:1f0::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA3PR12MB9107:EE_
X-MS-Office365-Filtering-Correlation-Id: 8489e147-dd69-42e7-6a14-08df43f80889
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|22082099003|18002099003|4143699003|11063799006|56012099006|10067099003|261102123227099003|261022075727099003|261021121427099003|261021123027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	yXAD/WnY9VJwMqqDQFStzQlFzNKEIRH01iu2VV7YEyrQ3eL0oyD15xuYm990HghgsIEIjLo1h3SfM+Xv3zCHYIfUaI/FkGRoRsPXuxYwBIviu5cjKnfHYpXRRufr3u3yPNLxtFlLQissp6tyfXoYlHEfMeVWV9rSDR3/XQIs7WP1eCoblw48ydTwNYZNiL084qFyY78skBUZBW1LqIJC/ML0dc0Z9qeuaBo10W/5w0mXYLqMR1fCjjFQgVgYVowxfYV5kXi0eUnR7r2O0A0Hraz7sEm3VvicQ5udf3A1N9+mf0YjB2RxkkmmLzGXUWEloU+uRCnPFRcnhLxsaVF2VwPaumOFtZ0FUBz7s/6E8Md8Uy/xKIqLBFy9RYhAQn8PaJo/txDRgb2Gp+j/31kc9MRLBr8ewsNeAv7DyLvQ2maP7t046HDPQdh3lxzrA7+X7ZF3EwYOm2dJwXSiHBHpNUwXbJ9jcynQtBkROrDJYY5rz36Wj5zV7J3EL1drHMfwE5m4YrWaF45iAMb29KpEcp9H/j2Di1W4GSkZ1MVjRMCqOWKeN2zcCcsrv8RnCmS5CnCT2RCJFAY14x5sRyugfgpBGFprKBh1NndvCMmXVhmpkwdLU1SP7AhMkSW8IhtVTUtC/mSPTpH35jOgSzFcKIFzfWDxOnRb3G6OuhBEX/Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(10067099003)(261102123227099003)(261022075727099003)(261021121427099003)(261021123027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f8G9G3iA4Ny8TkppjSqZ8fEiZA3zdfQgp1qS0KoBu9h6u3Fuh1hStkLvDIDa?=
 =?us-ascii?Q?7E61XAQ3BLpSzftFp0HkuybuH+Rsn/F/LiuqOqxMPd2Y4bNsVY1y4Z6VsDPO?=
 =?us-ascii?Q?KQK0swuh9B/q9KTLCSgwyzspiCyC1gVXThKNRBuB/RBH5Mxj4gh1TZYVsEc9?=
 =?us-ascii?Q?bamSAsIGY5QPLUD0O1jHlfD5taXeRE4YGfB+16+J+SUwMsRW7lo9BF/gYtHK?=
 =?us-ascii?Q?QkoOlmmtc2PBb5oRnRJFc2TyDWDFeYHm3tWuhAEidtTShAxd9OTCEBUc6NNt?=
 =?us-ascii?Q?VFw52PeexBQBvbDjkHXO43vjU1zm2w5HWTFt68uWY0XX8H0oBRzvNq4H/hL0?=
 =?us-ascii?Q?avAMR+R25cw1Q4X9ok/zkDLUM/duz8TNwiBO2msLE4cszHna3y/Rjs9nUG/0?=
 =?us-ascii?Q?4QDyOVSiIOa7ccg/lS5y4UHlNOKhsJB83wWUGjJXmvUD1VCxx6UMThecm+AZ?=
 =?us-ascii?Q?HzQkVF8688+sKtppvMTzIuO7BHTeKesb91pRB+v4wcB4XTU+rlCZELb4isCT?=
 =?us-ascii?Q?rP+VyX+QqfIiVoE8WQ9hFE8+fXM7cFlZWQQ6wQjWU083fCXd2+qAMJWHt2SW?=
 =?us-ascii?Q?OrrElBlPT0UNGunhZy2mWbLY17WhPg7KOLl0lMiQfg71/SH2o4oZPeXRGmj2?=
 =?us-ascii?Q?LGNXNaP8GyUAp1v9W/l8ocN5dq7WTEfP54KXLPuE3gRe9f8aVEJ+6ltrgNiH?=
 =?us-ascii?Q?qs7fJek/wexwgcL54mE5Vg71XK1IqtclK3scyQXI7v8RRUheMs5lCNoy4a66?=
 =?us-ascii?Q?++AMhOo3nMyhKB+JSWQCGZexiAewvUSFX+fd1db/VxPB/Wfw9dbQIXSBkw4Y?=
 =?us-ascii?Q?vkLMhRffb3UOua9JclNk4u2hGUeBVY9z4Yh7hYebpeOWeaoMyK44w+0nXuyS?=
 =?us-ascii?Q?byDotLpvyfzlle++JUPXW6jggs4CLbYojp8ltHi0PaVks746wgIJZErs4IyE?=
 =?us-ascii?Q?5VJBvv701OSX0wiQrilSPzsOwO+DT0XpRn2xQF8snppv3AlffrkDsQJ4UMCM?=
 =?us-ascii?Q?wGBcDW/5+jx3ZSiYw+XOPqUcdaMo/UPGLVUi8EDO1RRUynPGvtuWveB3AG1c?=
 =?us-ascii?Q?GJdngOyuVk9CdeOY3aSVlgHan39Hwg61CL8i5y5Wc0tR00Fs9yzybTGqXBsG?=
 =?us-ascii?Q?6w/zYiBIFU2Ug5GxxmvKvMGrySSrrtGLlThNLF2DsT/4WyMEhESMYgj+/LiS?=
 =?us-ascii?Q?Vv0IOLkqKLeKAVF2wt37NjchOFyN3/CBJt5LXbSLfn3dAyRg6UaVH6Ukgm/l?=
 =?us-ascii?Q?EC9hTnKuGK+Zt935w8mfILLCEboWlVuEgI0/JwvVJ/X+wyV9XWe+sAfaSrIb?=
 =?us-ascii?Q?aLXDUM8R36Lm1MmsoJdKLI60/DQAiRv9ExNM14O27kucJ9907q9CjS+rgmuA?=
 =?us-ascii?Q?KNbeE05h2lmQP8mIsZcAQaDWO2nwzLkF+FOgYgQLcVZr82z8qmWz0DZRUpy8?=
 =?us-ascii?Q?+1KKITxMdVNWgM7DVlDscvNyV7WuHINbPP0S8Zm4L1dNw3/fHw+1rnT4nXUI?=
 =?us-ascii?Q?I1tdij04aMlimEZbp2+guLOlvpJsjlTtgJdHPJIoJF8HcfjST1wn7yRbOlqU?=
 =?us-ascii?Q?fKcwNSLxL5YuHTuCC4TagRK5h6QYb+Z+KUwcrMQEd1FO8LkziNWRY6dHsEZA?=
 =?us-ascii?Q?zniwuqeA8yU/KELGd9a+KqTiQATqy2Fb84InjvMRRw+bDIFFUPv5B9JSSq0d?=
 =?us-ascii?Q?f518MggpThd4FkKx+QP7/cuG7dijDq7JofVbGJPtDWefJoAq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8489e147-dd69-42e7-6a14-08df43f80889
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 15:41:08.5289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dBeFWLSqbv/00ICO8NDChCEiMDbz+IK5jXid9cN4qjk2eQeQxK3dHRZ5Dubl/BN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9107
X-Rspamd-Queue-Id: 2A03AC0004
X-Rspam-User: 
X-Stat-Signature: rbegbmggrn6c4xctxd1i9oyueizay87f
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794843677-413345
X-HE-Meta: U2FsdGVkX18hPsYMqttVASCfhiHUpQaDT8Y36Umj8QrhRKvcKnWAvc5KrZ13+5kM4sWbUL4bDHPG/Vlvo5dd36dtzChbvWsp8KfgIFL5klrjYsNW2YYSeM41+run/0iPpILlvfnLapfOsPcmSr1b5Q+dquoSqKZ06wKj/QOqY5csu217fMd2ED4R/cFbRXcwi1bPCCLOhkvO65KLFCPujn0m//aGGNXBM3ShAQBQS1jmhkvRi6+owhrpWNdMH/ySmlNXsq+MBX+po8DQ60UvmEQ2PIhOIMjBsgRYRGsQYwl25DCCW9CCRboJiXgeYNgPAthRb2vsVVyzQfXxySTvJg8EURcbYGPZG1q8EVm/scADTcA3TDjElNQzjhV3awmz4lJfVucqhUWZcH3Y++DM+Ps8ARXVnRoUupIBtW4grTtYctz+xDGbfLJ6SoPh7/+zG76MNrnI8zn3n9rDbBmYNe8ZRq0tsey9RFEdSVs+E6tCGCIHXqta10Zlso8FVlYdMNdH7uc7FsBpnukT8yGnEOb5jQvaho3cxLtQzlXIiOnpaTGy/hmfZNpXD8zPKir/wjeXKCPuuIJib8i5e4y+hI2NPBM0Kgd4jEDbPLzSJbs94oSZL+unRlLoQVMaKG27PGZ7pXGCyN5psA5MqLGgAnhnehpk9Vh8me8NZBHfHT9vF7EloaFQpb9hBXj3BYfFQ8LwL9anSeiaut3KJW6pVq0qv92ntANcSn8Omi0BGt6a73x98EqYc4ZOhUpz5kZWuXVS+XEqPucD2jHaeQleMkloef7XvejdATCEbDjIxQckNDnEMF3BhAxk7/hNfxPhrF2BiRT75AMPfg7dFgtYaz5FbSMMBAXnz5cl+3F0Vgc0BV2n8ypK5vfBHhcBdQySYjRC5WeZCSxTdgYWEWmlG20ulkx/tfUGGZMYvkLaaY2vwu9wpCd4mKoA/hCCEaKsNU8WVjYKTBSESZkliOT
 D0JHfMHC
 K62q5ZbMkwXK3NEhvwZCe9cL+aSRy1TBFMHfS6V4oEktOyCbFNM0zxqYkcJI2SECXJ9QTSt/89Fzt1E5UhKGyMWWSoVHkMmvmZipO5fKIDSTraPzPWp67OUjgXBkl0L7GAaejFEwrp2FWdbM+J3h/qQw4eSeMIwzBTmPePJ9SJ4TZPmt2/8q1MtniOk7zLHpJI+TIeDXkvWqfvyJysjhGd/tIexB56v6Fcha1aiSgdZw5NnUsmbOXijsjkZA1PBCMQKSODwNMhKBul680SWVrU6i1zWmMk6DA35QqlfbJl9oZh05OJz4KoVQLXLgQV0yei9Zps9IYSOqeSa9inP0g5rxPjvAxVpUuetmivLgkwJlI6+uB18v0jtmfWqQTYqt0haiB8R3QS0fBLFI4IqgP2Hv/vHgNSOuGO6LjhG3eZbA4iB6YjC3WJ2Uh6WAxKE7VzoLdZNAIpbDnsko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 16 Nov 2026, at 10:06, David Hildenbrand (Arm) wrote:

> Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
> has been flushed") introduced delayed rmap removal of dirty pages until
> after the TLB flush, so writeback cannot clean a page that is still
> writable through a stale TLB entry.
>
> It skips this on UP, because on UP there are no remote TLBs (single CPU)
> and because the PTL prevents preemption.
>
> The PTL prevents preemption while removing the rmap, but the local TLB
> flush is usually only performed after dropping the PTL.
>
> Consequently, after dropping the PTL we could reschedule to another
> thread of the same mm, which does not flush the TLB. A kworker could
> then run into the original race with writeback: it cleans the folio,
> but the other thread can still modify it through the stale TLB entries,
> and these writes get lost.
>
> Fix it by simply not special-casing UP. Now, only architectures that
> select MMU_GATHER_NO_GATHER (s390) will skip delay_rmap handling.
>
> Fixes: 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB has been flushed")
> Cc: stable@vger.kernel.org
> Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Link: https://lore.kernel.org/r/avrxOt_GyXLXNqtR@gremlin
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/asm-generic/tlb.h | 6 +-----
>  mm/mmu_gather.c           | 2 --
>  2 files changed, 1 insertion(+), 7 deletions(-)
>
Makes sense to me.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

