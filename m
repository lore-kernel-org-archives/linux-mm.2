Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFE4606A89B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EU3wBpIy
Received: by kanga.kvack.org (Postfix)
	id 4B9D86B05BC; Wed, 11 Nov 2026 18:15:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A6D6B05BE; Wed, 11 Nov 2026 18:15:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3321D6B05CF; Wed, 11 Nov 2026 18:15:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8A56B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 953BD12041C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:15:42 +0000 (UTC)
X-FDA: 85424397324.18.84D3C22
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010067.outbound.protection.outlook.com [52.101.201.67])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC65440006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:15:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EU3wBpIy;
	spf=pass (imf17.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794438940;
	b=yuCpGJTC2uOPyxgkX5wKt/mlb/Y5r6SUMTWxERwylkJlRsj9XUoaU9m8V11XW2BWHOxoDk
	+NV/f2BOmWUjcghXxZXh9sx3E989uJ7+DqqiNj9cpIORESjq9ijNBxQ+qHPkdcgYQLFl82
	CMvPUlLLOhUzpO8Ghi4GkgE4mEaYIDo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EU3wBpIy;
	spf=pass (imf17.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l24hbdstZoU8pT+qLZIzM9ey6mHPSs8iHMnFzfzHnlM=;
	b=TiTlwCmWXpyotovVHbPNyJMSYDtE9AY2t3Yk7flsh7uDxjBd4VTveENVtZm0tMvZOLH7zc
	8zs6JBJGzVhEJch0+zgJEoT05hZSnpKpmKPKqFwGTreshTxnr1wdiMHGSRDlYTtWxrlSp9
	/JmshK8eMsuFWKEyDV7tjqiBHOOemXg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aQk1OSIi4RMTsfy9h1AhemrAoI4TV7Zgnmaqwck7w8urDIAprbe5Cwqcm/wlZsVPamoRf3WwlgLJyl7F8ifiMlOeud0XyWE3zXRW4NxYyeWudfR/IOKHbUHlPOryZco3fff8dka17SAX8K03htCUmMNL6d/HrhKZx52HiAqoR0XYLSOf7GTurTxurVZuf17vX3PS6hXHWx92LLzm+DMUHMPq6bojmsaNZzCwB6Dpptg3nhnvE8iPKOLiSscWJIFgmX9Kc8vi2UGrvFrPmcHlTpKEXAMVtWFcZEvKPhqxYMx7BulMLKv5bmBNO75kPh4XozUjcuWjwXkbkufCrEj7EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l24hbdstZoU8pT+qLZIzM9ey6mHPSs8iHMnFzfzHnlM=;
 b=FwU54WGWJR2u0ys71T9Pm5eIWUqanTBEpFPxYfrZlMn17jyXaBOWusN9sFCXj27y752jwTvw+4/58hcGlmQsyjZ1pH4B/LErxD6mncbK+rxJUB8GfMdtqLzojr0XDjwV6eyTLwJBrVXin7N5jaeaT1gceawAkt9kV3eHzUyJKSChIe4ttC0YT1MU0+I9e95ClcS9TWOE0xvCG6MPPJdlPr6t7a9LjB1n8ae8lrsAmDy3Vam9Gjr038N6B35kkWvaD7Y3v4nc4wzZRUVtsDmLjdXKr/vZ3SsSagry1HhOmeEMVaUFKC/rUWKM65hx35sH3P/Acla0jUog1eHnV1sxOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l24hbdstZoU8pT+qLZIzM9ey6mHPSs8iHMnFzfzHnlM=;
 b=EU3wBpIywsakbpPoR1k6d3Uhfc4Y1BfomcoFcTSoPq4aXW6grTWNOON27KACmDJgNZgmUkRDWjaRVLWBQHmvy0kQe8tCB7Hx3vDLRDY0VVfKOaSY+rB/BXVkE5bq4WJzyCp672YMvQ4JOOnBrbJ2z3u9311kDadN4aDd+HvtvplfjvYBdXdn1lTg3asQtfjMdwcjnYRImals2HXd4Z3cp8Zp5/Gp1tr67gd/CeTX9HipgjbSHR1JRY+H0o3wQZeCHF+u2WZqv2h1TsoA0skj6hmZ78Ss9NHiAXuCS/3L5u659bjBMt4jM0hX8bwQicknSFQqwHAKdi+g0ye4wjp9wg==
Received: from DS4PR12MB634945.namprd12.prod.outlook.com (2603:10b6:8:514::7)
 by DM3PR12MB9328.namprd12.prod.outlook.com (2603:10b6:0:44::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 23:15:28 +0000
Received: from DS4PR12MB634945.namprd12.prod.outlook.com
 ([fe80::24ec:530f:4816:dc]) by DS4PR12MB634945.namprd12.prod.outlook.com
 ([fe80::24ec:530f:4816:dc%5]) with mapi id 15.21.0615.008; Wed, 11 Nov 2026
 23:15:27 +0000
Date: Thu, 12 Nov 2026 10:15:22 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
Message-ID: <avT2FNTZoEuijEZP@nvdebian.thelocal>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org>
X-ClientProxiedBy: SY5PR01CA0105.ausprd01.prod.outlook.com
 (2603:10c6:10:207::13) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PR12MB634945:EE_|DM3PR12MB9328:EE_
X-MS-Office365-Filtering-Correlation-Id: d58076cd-9631-423c-a33d-08df4049ac23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|22082099003|18002099003|11063799006|56012099006|4143699003|261028144727099003|261021121427099003|261102123227099003|261026140227099003|261026121527099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	4GYQ+jiDImRHARbt9k9zD1dhK/V6n83PM0KTbSlyWk18y7VLnysnXake+a9pFJ9CJMtXQYwKJhrd/ppw3Yz64WTFo0VbvrwFEWQFIdr4+Xk8aGsIhSJYY+OwQ4Yh2jIV7HF2YruH5L+uYNbpNg5zqGCdbWf1/Y4yvHDYLN5JfR90ejoGNqyBkd/EL6WXrVQ1KV23XYNYFm2V5bCbE6kJR/NTxeETZDNHBnhU8Udjv5dlksqBTagVLtaK643uTPJzS0jkVLQuKlwhYQkWSrIpWK5IFAba+8N1IswB72s4GT3XxaHQ7hYbCPu8+7iLCAAfH8xlNzbyetGc6OcIfmhfcwYr6+wYiwWKDtHtH7/SOWOeQVCstlc08rh6OpFVzkwOpq3Vdl+ucahAoQNCDS/2fsmJyCYLSxIDwaMcYwG9WLwQ0apdvU4BXmPwhu33XpSksj9QZxNC3uIcSszeRbCgTOXqb3ciac2CXjxELlrdzQMRVs6c00E+aCayvAfSpceFUxRtVpPTUjEMLrFi8XZZJ7fg3F/OVLWV0FORnshpatlsuFeESI4RGR8DLZk9DLJJ9P4AqQ29NcD1fZt0CI5XbM9l3Sahy/INkqR1GGVyBX14VrmgQ3C5KZrwMyBM3C2YJ3uVYcWKrncUCYXkG1EiLagt3Bo82s+BegbhFTGoBWs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PR12MB634945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(261028144727099003)(261021121427099003)(261102123227099003)(261026140227099003)(261026121527099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G0ZQorIlwpecL3itzRhy+8iDyALUz9OaDSuNlzAI6RWjJzuQe7aLtcWaAINc?=
 =?us-ascii?Q?U8lyqU8/DrvldDSThntQY3FHHblgGUvuB7LZbzdDvTUtau4Bt1+TH3GfOsSw?=
 =?us-ascii?Q?LoP4T6A/viKD3lfMG3i1heNdwmznM9jZE0DCes6E6CvDpAdDPh91QcAXidAt?=
 =?us-ascii?Q?LkQSDb6m/JrzbugynQd+zcssJ6s19XsCT0BGqSYcFtqSSc+tEyXCqtutD3Y9?=
 =?us-ascii?Q?YFrzyEpVo9eE0YpmbUjxTkpdCcLDmqIRoixvzA2MvT91lMaU2Wc54YGcrvHS?=
 =?us-ascii?Q?czKzEg2YfURSqzx09/ZdASndHM7bKYdaXzQZ5Ysgs9i52kgmoYpaW4GSGLpQ?=
 =?us-ascii?Q?F0l29qLfI7eMSMVPekjELhZXB5BMY9KPHfHBXf/NITMTcHYiSatxsVq7lG7z?=
 =?us-ascii?Q?ynt/cXTPUPhmnl/Hi72IxZhR7lpAzu9NzqJgJ0JefPqF5AcQxpzA/zLpha88?=
 =?us-ascii?Q?6BYS8wjJGmwX0iPGf+jA1raMRzvZU8ZIYaiWygTV/H0R7vmZGy306OolpxHw?=
 =?us-ascii?Q?UcutIYkFTBotXObtQrFS2VOxZJzfYF5g7RrCm9j9uYDgGxk0SDJU/73+0LeH?=
 =?us-ascii?Q?tQc+UUdor7p4MfCnCGroo7vIxMMjjrTWj4/lPrkZTnTSlJglRpgLl82I18de?=
 =?us-ascii?Q?sgIpI4Txmj+RNY3ixQcAUe5cBde1vVgAcCzzdOb7j7SDb31syxciBeo1rOvR?=
 =?us-ascii?Q?zQ5HLGh7k7Pbe04xJ8PW0Mtiahubu9Hh4+ALVRGDmNVWOqriHJs3ER6nYISv?=
 =?us-ascii?Q?tA6DMikjMOmz46IMwJrSo84sWIL3nguH02Dxv6K9EADd1u1jz1/PciMUJvX4?=
 =?us-ascii?Q?hVOrBXn1bXLzAJdUJP9xfmF70d8YyMzzOjWY8sdkeVpwNBxomWZXq1pNC/61?=
 =?us-ascii?Q?7GYyuMtalZNfOWjmaPBTofyvBoSeq0+D9c5s/QwBYrpppcY3KKTvc7ID9NX4?=
 =?us-ascii?Q?0HDR6B/q7n/HtYEjKITEXTa+7IgnzJ/QPEo/oqp18aTPQ1w81cnOMbmGzbBO?=
 =?us-ascii?Q?Qcve4k0FQXLqQEHwEqTm2Sgtgxj3Hanbxd0O39SAOYJoByCyR7PDyxudBMBT?=
 =?us-ascii?Q?a8PdNq3qI6ol+IDgbuya/Urc+IoAzwXyjIbhpXDsJfQWABZLFzYyTzQkUOjO?=
 =?us-ascii?Q?R/d8/2YOwaKZy/rM65FNJfn+kMsBK9cz+jGXB9fbmFtVTqb/d1RM8QMPj5Wm?=
 =?us-ascii?Q?1ltZOEt+15eCuujJZ4+kA0oECVE2Va8p5TckIX83tbG5+jhFooRVqsbINbuT?=
 =?us-ascii?Q?5aU72DlWyY/67kTN923b/Z0dfj3KnSBRRrjLc5dYTmfH1nXVDwIrGrGiPp9x?=
 =?us-ascii?Q?KdstMiAlMLAOIEt5r5eoBJBB8g+r//y0lr7JWbp0n/8l++ae+dD0k/jC+skt?=
 =?us-ascii?Q?8nrCNxJlBppcOMAsWOa1h+E79brQwslEy+KqrFYDwLhICZ7TpMewylZy7im0?=
 =?us-ascii?Q?+7ocshtedfafpGn3IVGkIH+46NeM6dTma98HXjNgMFibFs9Rj0PMkylz7qTZ?=
 =?us-ascii?Q?AFecsKqaD8ngPWa5YcbsqckbdNPBhQknRfcNWeNlQjZXWFEolWYfqim/oiG/?=
 =?us-ascii?Q?7Bxt16F9x2AK7tGBIVIg+M8pN2tY7ujdqlr3zneX8De90RV8i7gNpmbPsxnj?=
 =?us-ascii?Q?PM35gheHo9k3P4qYOkhluto+GoKqh7ABHRb/pfvr3S1J3SLCuut/9k5aVp+V?=
 =?us-ascii?Q?KeZL9MODo11t9P2iSEc6evyaM+A4dvj08hteF/r9EC33utsfvR3L9wnwyPEn?=
 =?us-ascii?Q?URBdssSY8A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d58076cd-9631-423c-a33d-08df4049ac23
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 23:15:27.8667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSKwXduKy99LYwG6sdRex8m/vShAhyoE8L1FrrMO05FxRvdm1jofrFCaN5ZKd6qz7QDRaSetRxI+jigzuFBYaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9328
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC65440006
X-Stat-Signature: 3eud9eahr8hzeum1sauwoow4ar4fcpho
X-Rspam-User: 
X-HE-Tag: 1794438939-826716
X-HE-Meta: U2FsdGVkX18977PQOgeANtEkTF6vw0Unon+HqECtOpp+czM6jnbJDVFJtmAB577vhpxTR/6gWFr5yPwN6rdcYoNtOHNJkD4N+FDMfd7bJzRjbbQWO5si8FEbKkGRXLHgjZoiuopRZqeg+VZP8PG91NS1bGsTHx4d6LqdT8lPme/I72HHpvR8UP7yUuF3fG6UtYO9fwLc3qTzzfHCOZeiYg3ojeg6S6bbsx43fjNW1n4talkjGGC+P4MJa1HROILHaPEMiH2t47e6WBU+LsO9VgYnGewuULLR2pk6YxbmhrwkiO8R4ZNOq8fDpSnkUX2owo/uIfG/37etD6wv7Fl9ESCSPevwowM3qiCQwRdAXmPBro7zYsvokVv4Rx6MPrnwj4JYCA7BI4dCCDbE7qhjcWWD7NsGrjzLfHKxbQd5OjF42AIw73S50NK/aD3UQBXU1Z84t/3F3o2f19XubCxRWhlki+T3lrnIMWWEzr2NiverHpZEFm6MovOZpsZbcfIgsNwDJhbpZfUUG31ThWeWx4Rrx0VYEYb/3z7U0tVzMMjMpuzG6YViEs/z6MaDu3uHqnhld9I3Jd8uISQEYtQyS8DoCpJPKSlpmlIgcyt7Y/WP65A3YEFdfDcJR/xzQxPTYjXvvccy1MIPVwcXAML0KKRgPJc9R6Bs/4zK3ghcMA2MTZHFHJBpWTVa9ileED+T/ZwNzKhLbmh1fZiTyy9Yadw4mMMoFtzuRtG0aiLnMdiaInSpU5PXs3pRHgGQ3C8O+m0zw7AM/7Mzl2VzR/5X7d+ovydG2MdQx13i9XqlRAmj6Vxp17MOyThhQa6/13xtDY4CksM0ojDC/QB2HohkuRFeOeY2JxmMZynonNE0OA0B2qkRcBhWeTYA/WdnuexZTlsEVIBQT2+QTTeupo7wkq2uqJjtlMNDxv7cSFjDrAQckkJW5O14jhTfKlErv9bj6C5IZYeL9eO1Mhd0T6/
 fA3byu5H
 xzSExGvlvFhopZNYOiFpCfiekryLKiEp+nJBDMpEz9RHTrJDMaMbFUWKFJ3oRLWuxHSKuWfuTtCCa8rEIYOidWDQrP0KGduo4b/fa7J0osYqcNX3DTSNE61Oh3mke8+Rl3XgV6+tJi2auuLh0f7P/iqTp5wtwkvybNKT8hyGcS60weqqlLzUjg/M45ERaQeVJ+MfXqc1Vu+V4VeD0FwH/Xk6gQ8irGWnEA7G7Ak4GvNIG9O+Zrows2FVyB8U2w/QcdAAEYDvtXiLKyG6aou6eHuRUAzzcmxmnK6EUAFKAx6n5PBBAcH5zM8YuXPHdwzC/h0HiRuvcTOKI1QsEZQsuUqjJvF9lrwK3+CEiLrf1zcZsVh1q0ohSfUfi7LVsmWpZZWsOVW+jnHWafBsXBopCH1d6H/YQKeq5idY+73OxqdGiuLoD9lhSvpFiupy/pBrSEBq2QHbTFfjI3r8ISEnZVoXFTA/fvZCu53wPbinJBni43/AIvSLv8xIayHMSDvlSC4Karjj549c0fIW5EqCHUwGUCFS5sSyuDjth
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-12 at 05:13 +1100, "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote...
> From: Chris Mason <mason@kernel.org>
> 
> The kernel blocks ordinary writes to a shadow stack. But pte_write() is
> true for a shadow stack entry, and migrate_vma_setup() sets
> MIGRATE_PFN_WRITE for each page where pte_write() is true.

Does hmm_range_fault() have a similar problem? It allows devices to mirror PTEs
into their own page tables, and AFAICT it doesn't check for shadow stack VMAs
and would see the PTEs as writeable. Thus devices would mirror the PTE into
their page tables as writeable.

This change looks good though, so:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> Notably, the nouveau GPU driver takes that flag as permission to map its
> copy of the page writable for the GPU, meaning that the next CPU access
> migrates the page back into the shadow stack, and the page then holds what
> the GPU wrote.
> 
> Be consistent and disallow this for migration.
> 
> Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: removed unnecessary comment, refined commit msg ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 5fe11dd01291..a59864f2e9a6 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -759,6 +759,8 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	/* The migrate_vma page walk has no hugetlb support. */
>  	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))
>  		return -EINVAL;
> +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> +		return -EINVAL;
>  	if (nr_pages <= 0)
>  		return -EINVAL;
>  	if (args->start < vma->vm_start || args->start >= vma->vm_end)
> 
> -- 
> 2.56.0
> 

