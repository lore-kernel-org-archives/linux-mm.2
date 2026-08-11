Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D41C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508EC6B00A6; Tue, 11 Aug 2026 16:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BA246B00AA; Tue, 11 Aug 2026 16:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A85E6B00AB; Tue, 11 Aug 2026 16:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08ACB6B00A6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:48:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7867E120219
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:48:57 +0000 (UTC)
X-FDA: 85090177914.16.E25759E
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7B8341C0006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:48:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="E12x4/L0";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786481334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUCG59ylm56PBitf8sW+NStTeYOo16YX4wvqn+sULnU=;
	b=GAtpdLvMrfV9497TXDKBIjsWdjNUQMk30zWAjP1DsBWP0NDbsOsYOalnTcKpBEJVSZZy/F
	m4GGvpssyxLQpo6lh0NHz2r1Nir/Y2B9wdOvdCnycbrsQSmCdmq/vW+3L6+u9zO3D4aiGW
	OGtq/c6XCt5NRjiVAZEpnO6x/g3i0R0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="E12x4/L0";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786481334;
	b=X67UWO+ROdkm0XCewnBalk7ekQjCEK2El1S5FHslZWgZcmv6epBoy0oToO7WXtpe9nZw0B
	8EiNNVSjNDtwJaXJuvsg9C0U+/8Mn48VMJGnvrwBg4W+G26Fg76N9WKWJWGjxtz4R1bL58
	0sIOpKI4C9c44DoLoqI7Q1s52niNuPw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K76afvcnZY+XTvCWnIeajwLpxXk8cCku05lZOo54Pdr5DPiPTiQDkwslqILw5Jm9eFPtsmWDpQWD3PZQuG1LIOXUwR/GbA27xnRW3A9+oG4ByqfeAISAPC9O37aJ+zB3ihSrRJOCfyTrrOCdK9z9uJwxUg8cyFN55wccJT9KylNm972q7LFqwNCqQ7CLGoTuwh+5PCsI1p5pofokeHBquGTGTWjTK08ddiH94a3MoLy0mtdb3/dyY3ffEwpFS5yo6iRqOxcA76jbFCJT0Wn8xPYVSPmCmUWHlBBVtYOxSlzzyCV8yIs/lnOduNkyzb5nPX82H6g6F8S9kydhAUNHhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUCG59ylm56PBitf8sW+NStTeYOo16YX4wvqn+sULnU=;
 b=j2WAp1C7Cj7g7Ol4OTk6yg2ThiN+zKFddGMzJjugEGaDBfimTYHiaZmBRf4QIKOvHR7N7rZQKoo1WdM9DFqC8oybZjZlMy0d7K/LQE+lV+F0i/K6Zmrw9jmj9y3eh9vesQQQ2ZZm+IwVq4DeG1kghcIoA3cVi41whRLBocgOp0/FY3lmK/1bweIi5HG+dAfBg83fGdE8UFYnhL1mzTtZPb4u7M2Vgpr2KpstmcPI1aGWBqj3WxezOwvMH76W3NfVAmascYu7DfsvO4pcwupbfTvNvj9IZ4n7EV9l5wMFsHA++chWE7z8h+/OLP+1VXlpkUMCbkQ9uA4+Oiml28azaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUCG59ylm56PBitf8sW+NStTeYOo16YX4wvqn+sULnU=;
 b=E12x4/L0FBxiGiFuYuFiK1ZXh7h3VShfhaYhy9P8n6+Xy8wMfignSEe3bA3x4HoussDOXCoBn7IIlXxfT3hWnu0CD0TDNLNtB4oB+wT4CAgXiIpvbua5wTkDlZ5DB2+HUp+1Zlv3zH6L7l/WUlQcRzKUCSvVc6AXOWDOF0WKmP6N0FV1qGQUrmk04hLq0M2coi4eVObOTy/Yn5+8lQw+1V2VI4RgVmwTfwppu58KQDR8nmmN8Dz8hm7Pb6uQ6v2JdULcmnpXvT1x4iaCNJq18DQljBmGAhCADZzvE5O1JUp5v2+6hkHe+EBaMFRxtNDVomueuw+8KLZB5soODUh+ag==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB9612.namprd12.prod.outlook.com (2603:10b6:8:278::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 20:48:46 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 20:48:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Aug 2026 16:48:45 -0400
Message-Id: <DKMERZ4V4UJJ.JG0N6G9IEUSH@nvidia.com>
Subject: Re: [PATCH v4 4/7] mm/khugepaged: fix outdated comments
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
X-ClientProxiedBy: MN2PR15CA0048.namprd15.prod.outlook.com
 (2603:10b6:208:237::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB9612:EE_
X-MS-Office365-Filtering-Correlation-Id: ad25276c-f79e-4b6a-6eb7-08def7e9f054
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LbNLtJGxsgvHTgHaLvKrgoNcaRrSt193Hab+K73uOp2XPcVe5WGClvPrRTIjXlL65jWxdYJkQopeG0uBfeyfTJmd5fukliVu/GPDa8IQoFoKVUVHDFyalPb2nGNg5BMVUZenaGA0iCHBT5doVEOIQwYtkb/Ys7LsoULVccQp3C7lRz8k2TelTggAQSNDcJAOhCFfZzYb5ly9pbZcebkR+TdfefY5Uf7eakUczpwqPZhOPLca2NJAPUpZ3RSRFTSLZnu4uskVoBFvNcWbtlSDEt90nDt8rQtQ3utZH0p0qGG7a7TZRyK4QCCfofxsJxND6zATCvyu5Vk83PBKCDpXIvYtZ9JtCXOqpplj1jZvlKHZG6pTh3wdAZxZmPntpxVLqmmCHsrKHblrtfHbhfZJw97GaBeJ8tgKZnLUtt03KaEwqwIw+7+R4f9PwXw1UxKCXbn0baDAsOLFmx5A0I9j1aoM92OofiyCHr47xnUna/MOOOfX3e8wcsThuClXJjrB/g0wl8kY8xSinOyCdMf1jdiNxX4rIjDXRV3m0zcyi4yzlFP2szEW8kK9RZOG5W+UfUa7rnPqyj6cxP8doX8YBvP63bD5mZbA/l6SUwtTK+tOjvgdWmBjvJvPHOZY8/xd7qx/9uoUsZoEOjjEEpJNUHw3w/HbeorK/cJrn01rVR4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2wvdnZUL0FuMEtMN2RHSnhRME9DMGRIQkZmbVZhZ20vb3FvaW9UQzZPWWlz?=
 =?utf-8?B?TXMveHQ2b0I4ZzZ2SzJCOS9FeUNMZ1J4R2lpTkZuMmpEV2dhWUdDOHZQdVlh?=
 =?utf-8?B?djMreVdNQVlVdTdVZ1FVcml4MW1POUVVd1JJYklnSUMwVkVYS1hJOFR1TkQv?=
 =?utf-8?B?eTNVeUlrTlUwQlB6MERBWS9Xd2FSSm5TWVoybzNid1hIWEs0K2dQVWpJZVVW?=
 =?utf-8?B?M0VLWmhHdUJncHRsWjVIN090Zm11a3loTlN4Z0lUMWFqU1NKM0FtUU14MkdB?=
 =?utf-8?B?K1V4RGt3OEQ2RzIwSHc0TmpobXcxUERxUlJiQWdXK052ZDlKd0wxcDNlV1g0?=
 =?utf-8?B?dFgwc2NKTFR4TUZhOGRMaGJId3JpVk94b3VUZTZGRk9nMElnRE91RjVJaFNi?=
 =?utf-8?B?NFYzRE1JSW9mTE9ZS041UXFZYUphZm9vcFh6MU1ScHVWY3VXbXdZRVpFdCtz?=
 =?utf-8?B?Kzk1azRtRVo0bTBqYVFlUHptYXMrZjJvU21aZzFtNHRkNjVMcGdoMWhlOGJU?=
 =?utf-8?B?Z0dQSHRQUmpHcjdmUVlXRXhSa00rSGZ6ZkNUVkdHSG5DSDFMNEw4WGlJWXBJ?=
 =?utf-8?B?M2o3SkZjdnNhRnZhT0pUaGI5OENQYU5ONEpoZitqVDZtMElNR3Y4L1RxSnZD?=
 =?utf-8?B?OU5iWERXWGNjRmZ0RmJXNWJFSStpZ1dHSm9Db1FOeHdvcGxVaEx4cm81MFdz?=
 =?utf-8?B?aUpVa0h0N3BDKzBxWm4zb0h0aXNDaVVHZFdRcHhGanBoaS9Ga25CZ1ltTFdk?=
 =?utf-8?B?OVZLSW9CUnduckplVmJYMGZQTk9ud1prc3VGK0ZRa3I4M3BxVmdvSGJVV1Vz?=
 =?utf-8?B?SVdQVjl3ZUtyc3c0MXBVNjdtWFhyajB0SW1zQ0FTN1RwdjE5ekR2T1ExSFJy?=
 =?utf-8?B?MjFPUFphZGNSTDdJSXArQ0Q5UHljeU5hcjhYQlIySHczVjNVL2hqN2hHMXd3?=
 =?utf-8?B?M1Z6RkhNR3VaSVllbW1GdTNzNm1PTFdXdDlzcWhnbGc3VDBoeVRmMkIwdmlo?=
 =?utf-8?B?NjhCREt6WjlJTnBVcVZrUFVkUmFCNTJoalNlckZsTDAwVGk4a1hiZWg3Z0Fy?=
 =?utf-8?B?cGQvV21KY0VXd3F0V05pTXVWUWVLakRCMUF2MjkzcGQxdWpuQy9wcW56akZp?=
 =?utf-8?B?WThwQTdNQWFRc1ppWU9leUVQZkZUbnhyRTZETnk3UkFNdkEvNklkM25PT1VM?=
 =?utf-8?B?cDdrb1hQS0VXcGdRSHNVdG5Pd3R3RmdUc21kcEt5UGRacW5pMTJtdzNOMnQ0?=
 =?utf-8?B?a0RJSzl4c3ArclBSNFo3K1R4MFBLdUtydXhhQVFNL2pnaldkKzhpbzJXSXkz?=
 =?utf-8?B?aDBEcDdZeGxjUkhQUTRiR1hBZVdLbjVYRVJlY2FmeFl2NVFYK3ZiLzF1NkVB?=
 =?utf-8?B?WkVCaWFIMkRDN0JSZWZUL25DZVRHMlNOei95L3lnR25GMEN4NlRCWWY3aTlH?=
 =?utf-8?B?N1NnaDZ6aGJudUZ3LzhnV3ltQ2hhZU00SjNjT2lxN2xZdkVSTmFQdzBjK3ov?=
 =?utf-8?B?Vmg5RlZWQ283Y1Y3QkZDbUsxaElnTWRwN3ZaUTJ0bHRTN1FtQUo2SUpLbFdZ?=
 =?utf-8?B?bE9wN2ZFWlM5NUtOZUpZeWxxL3JLWU9EdVZMSWttWGk2TUZCUTFwUmlPRDZk?=
 =?utf-8?B?eituaUxyQkdkMGNaV0NoZmtMaFhEY0E1Tmp5Qm9MU1g3a1ZuTjExRE93SGlB?=
 =?utf-8?B?cU1FdWRSU1gwTWFxbXlGbWVKK0NwY1R5bEpvOGN6RzM3U2VJWlUwUlNaU2JM?=
 =?utf-8?B?Zks4dGJnc0htR1VCUVBIOE9WK1ZKUHRPZkUxQTIxcTQvby9yN3h5L2tkcmFP?=
 =?utf-8?B?aHBBRGl3Nm1JYkdRMlRFT2NmdFJpa1hQSHYvUUxhZnV0Yk9iMjU1M3ZQanBs?=
 =?utf-8?B?VDMrdUIrZ21xOFkxb3lJbFVLVUJJcXd4TVhPdHp5YmhEdXJNTERBV25RNTln?=
 =?utf-8?B?a245cHN2RGlKOWFWSHUyam9pbHVPZ1F4SzBPbVRLVXJtMDFWMDhtNWZyZ1lB?=
 =?utf-8?B?YVhCQVFSRTlTbkkySGEyT01sS2ZwdFdWRDkvKytOaytQWXdDbk9pK051UEtN?=
 =?utf-8?B?OFl1WjhWS242QnpLbmN4ak4xb0grOFo5VGtUekE0bG13NFFXekY4d1NVb1g0?=
 =?utf-8?B?ZHloOGcwb3JRZE1tbUpNRVpRR1RiT2taRSt0OHM0eU1ieWR1MkVSZ1ZwTGd5?=
 =?utf-8?B?M2lha09vRzhmVnd3MGdMN1ZBYXR2aTlxUWtyU1o4a2dEOUN1ZW9wRzQwOG1w?=
 =?utf-8?B?NHdVOTdqUnJoeTdTT2k1ZHRNNGFCU25TWDVnWDZXUnhIaCtiV2ZKVGt4Wnoz?=
 =?utf-8?Q?y4Z7D+9KLfvpoB+N12?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad25276c-f79e-4b6a-6eb7-08def7e9f054
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 20:48:46.5770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6x24fo3apwcWk89JH5cSIBnF3LUxkQkKr+7EQCw2ZxZtHYGdmPr1RPtbaPgFd1P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9612
X-Rspamd-Queue-Id: 7B8341C0006
X-Stat-Signature: xyramkooio31cc9wtun6ax3oipdyn3dh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786481334-155915
X-HE-Meta: U2FsdGVkX1+28ezue8oFnDUeOS6MBsTzaYehEelAYBE23v5kDNWN9plfvnvV1cDUOI0i+/73jdiaNQ4EUVZEKkVFr7eX0TcCGSELJPpYetJEume5vUI3KFYh0DsDI6YjW3lcCT5hc5c+1ZJYVkLKpcv9tGrSHdqAyYjqBuyj5gYDOg5j7hOJA65DS7pnxkwWUbZEWosfKP/mihsYagsgkw+sGCtc+7QAj8gDC1mrqVyluMpOHfV7uDLrnzBlayvmjaYbqaHo488LbRoxia3222IbqcLDCVgMEYXeu5ToWCoS9SC3pOE5xaRaTXbx9QD48eEBi9/CFghHgJfkAIAHWia94DLOWGsMTdH++c+jObsgmQbtAU4/s+laFnlhxLg1pgvqbxVxOuKZQ7i0/84j24lOr+7vI1CiAPduNwk9hujldwW7ysyxZ5KxyWYmBzH3M1rj7r1aCbi1Oi6vu/df8Z12QRxEw7/dM4THDWPoJZPCMTmIbUNJLx6RmqxSgEzHmHdBr2r3GXt8kKAqK5OSioHOPnCn/gMCFMQyD/ofJZMeVUqdXzRUz2lmhwxEt/q9/VFFa1M3RvSrH27Y+p85qd2dH8FmlKKbXQx3dXXCOVfq+t/3mszwAyWQkpJmISS3f8kSARD595WvOM8eR9NlJUmT9FECO9Vlj3SSQNk7JZpHBfXYxhF7f1UJFWQnFFY735nCwHKAHJF/ay7RmUQhv5TyNPsoz+30V9Svba5we4S+CgWDUTvXaRFOgbpW5SpbaQdxC73uLOt2I/WGH9WU9bOWOL3VdUB3gmLmOK+wk9h6Pb3qVD7ofXWQMMjFJ9FQBneo1FX3JZxMoKmPjMsjjitGpyrGLyMx+WXTr+iGP1ACY1UTMNgMsUMZiXs5gLKneT+sDVyr5dnGfSKhhHZsXceqoDVScOO3ZW1uOjFH/uLaGZzCEjwPSPDGyhINy+F/T0R7x+fHMRvrEwS6HOi
 nSz0kaiz
 5x3tF4gHatp4HYpPbtlxcgXTaCvj7t1Xd36CfWeYH9zZ/Lv2tQz1jjuqfZF2hIanTNbvkOjMW+LQzMfANM5aNzWVzbbWwyR2JjXTANfBaGb1nOfYYQ+JWloB7nzdQ4QeCOannUieRXZ3b+ptZyhzzao4QvowuuCmg7W/jWcVV7VbZgLblTM0V3US4stTuKjk0wufhimRSvv5U/227QdkfLTgVY7iGz1mV0FX92plrZk6ql16OKaM8VqxI4i3vi7bra4lzmXvXjyM6yDy55yW2ymQap8+Z2z1EJwvuIlhwrUEV4hlS7uGjJ9xrTPJLdr9tUvmsz4FrKD7NI+M549a9MgkzlxXS9uWhbV5V+ZIfJJ4eRpdF+KrDlJszhWTGGMfZYaHWXhUYRIUuPNLkF8weI2pjFTt/fTqDwuRVhHcJBcI2Dtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 11, 2026 at 8:48 AM EDT, Nico Pache (Red Hat) wrote:
> Fix comment in collapse_scan_pmd() that still described the old
> folio_mapcount() > folio_ref_count() check and a "512" false-positive
> scenario. The code now uses folio_expected_ref_count() !=3D folio_ref_cou=
nt()
> which doesn't suffer from the same limitation.
>
> Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
> when the code actually uses pmdp_collapse_flush.
>
> Fix comment in __collapse_huge_page_swapin() that referenced the old
> function name khugepaged_scan_pmd, now collapse_scan_pmd.
>
> Also clean up some simple typos and stale terminology (mmap_sem ->
> mmap_lock, PG_lock -> folio lock, page -> folio, grammar).
>
> We also clarify a comment regarding where the max_ptes_none check is
> deferred to in mthp_collapse() from the original collapse_scan_pmd check.
>
> Update all comments that references a function to include parentheses.
>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Assisted-by: Cursor(claude-sonnet-4):4.6
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 44 +++++++++++++++++++++-----------------------
>  1 file changed, 21 insertions(+), 23 deletions(-)
>

Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


