Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEA63FF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 06:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1026B008A; Fri,  1 May 2026 02:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270FE6B008C; Fri,  1 May 2026 02:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112E46B0092; Fri,  1 May 2026 02:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9D876B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:51:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97AC54016F
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:51:31 +0000 (UTC)
X-FDA: 84717929982.06.CD482B2
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id E02E8180002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:51:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Nq9Lvo8R;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.56 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777618289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cn26tyL5guctsRPksHVIuVsIGvjwY0qQ0k6lsUIDpwo=;
	b=hJCfemSRYwe/aev25zIb92JhCHp2LJJjANkwl7gvzQw9M1XAl8sbjAH4o7HAtbeDOFBg7J
	/jYDaTpcFOW+4reXkQlwutsFVFeEToYxAVgKwLgVovsPGA0K1RBFqFo91vei2KpBRQhM8E
	DDMmyqxGktOrPO+/1uB6l/GPzC4Aseo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777618289; a=rsa-sha256;
	cv=pass;
	b=qgxiJZfztwyyDwxkovukCNWNrt5Bu6dczeXcHRRQ6vRLRSt7qx80cNU7WWzR9Hg/Yem3a9
	p2BpC1sD+DNFw4F9WABeFw2YIxdzZfPiy5Irip83x/BLFCelMbNJGeR5RLVJanzchyj8l1
	0OAOo4U28lngYA7Ir6vgOv5anxNa2iI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Nq9Lvo8R;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.56 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WM7U3iSHP/v28Py3ywpiTVFiLfFNRBKxQqDq2SrpwXvCMcP4k+9Lu6Aev18datHQFULCZXbrIAUbyALrgNBiw3mHpfOZhWpUViI/9E4/ri9MtJzgs9iptCmRm0eYwWy3FVgPUEvYu0PXtUb3zytk/rQKpPe7CM94gYu8AZmO6UwS+nJb33B7KPDgZydmY7h21QI6eM6xuctAv1FTisoMOJPB7FmxWFAAO+ITOFAI0LQXTRfHGsiasBzH1oKSLS8o+IL//snci1wkUXwoxqREw0nzwObshA6xWiCz063R0wYwPAY9Ew3NAUds15/4EPy/SP6ZK1oNmZYYcPlQZ1SWhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cn26tyL5guctsRPksHVIuVsIGvjwY0qQ0k6lsUIDpwo=;
 b=xn0wnFQa3Es2Nt1RgQsfhbB+JujrjljGPZ8rTH7aeKG49mq3JRC/kOnjMSkvozsu6mh7pSv4vhn+FI/JdXhZSRgfRN/iUb058M0Zt/z4+xnwNKfLUMbKH2vuqHorPDHodHxbjboq1g4N3WgpzmqbwA8hUrNmhgOQ4AnpO3ax249R2az/hq+rK/W9oPf4M63u3/2uvf0dIZ3eH9ZF9uqDdy7skjUmjQo711V3atdyxUy/xk90L149t3jdwFnhInB3gWWFcStQikLCZCEEMRiRUDJuFIt+HO7pePR9c1TVPk8w6XW258jWp6U11WwIQHEw+HujAWjmz38hJuFAFRZXFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cn26tyL5guctsRPksHVIuVsIGvjwY0qQ0k6lsUIDpwo=;
 b=Nq9Lvo8RCDnGB8mDt+kWGDTBxaQUsdo39T6jlZ3VNEIBG32B2uFkKhPSEyXwzGTRCPwbZ8cUZMuHca49I6hmprkaE+ngXtSLZInt3WOAAOgj/wWtBsn0vh8mJ7dacXpi7vkCCEb4qXB9ItfhZ8LtvKh/ot5rpOIfZyToMjBX2EMWSiZ8/nG4sj4IBqCTizG7R+pdauLw+9Pzk3QKj7QoxtjzfBsvgUp/yyrvMqNgZ0EhYiX5GoVvW0ezvqF8h/PBPAoe0FQ6QyP5p/Q3HEUEI4DVAZbaAMWOw+qB8B3gZWsmNq7aBKxF7/HQcCG3bO6wLew739KdB1uX/eZFgkjH8w==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH0PR12MB8578.namprd12.prod.outlook.com (2603:10b6:610:18e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.21; Fri, 1 May
 2026 06:51:23 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 06:51:23 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	aarsenovic@baylibre.com,
	dri-devel@lists.freedesktop.org,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	jhubbard@nvidia.com,
	david@kernel.org,
	Alistair Popple <apopple@nvidia.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/memory: Fix spurious warning when unmapping device-private/exclusive pages
Date: Fri,  1 May 2026 16:51:16 +1000
Message-ID: <20260501065116.2057242-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5PR01CA0087.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::9) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH0PR12MB8578:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a0be34-7761-4827-0989-08dea74e0e7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	JZLKrQSqHPQGNPxT6Fwu5jpdg+ozk51lb5+6qfa/oraTEOoA1Zj9fiAMfZYD/U39d2g6ZxKxs4TVtU7hKK0CvMq84WPG471ZNURtJDeqmvhamHHPwnoy53j3tzYBpMihBNNdVdTvWBNjmZYwEAW+fx+/lScS5AJ+zFKHqLsuPFWZytLgsfYO6kPvtamED22DVdb1Ji7kB+RESjACwc7K44BFVNLCx8ZI9TOlOFI5yZS1ysoNlEZgiAUZAqna5Rk++ee+Fz3uxfUtYmv1H1a5QGfjAqNG+QdwqBaUq/oIbVvh21LAb+NmR4fvEaVIGHusbFoWUSxBf6jdpDP13HzZg8cHUaQylWZgNjGch1EWuhWqHNiD5WCIhWpSaYCSgTlzISMmHY0umSJ10dl83te6cQW3xWaCmE4oX8RbzmFTtwdUtxsXxrHQGZdXcUCinkgxx4U8ltgx+Jh5vXVBp3Ocd77vhgbrabJ6j/idGqFKEhj4/Yp0bLzoOzxuUkyhg6fQXUVZpYOpkD3YcWiSG6WrFhrfbCx20aHeY2wKUj+DdhmO8p5ccV0ZmUgdKHnxcFRmG9eflVdARbJDaoWpXdj9SLFIiJb494geifsDOQ3WHUUA6/lNjrB3szLkhZSkroEJk6PwAqFF3G9AIC+S3lCYKISnMWPZ7IcjheGZ95AldK5JTBmeqqfs5Kj/Is8meldB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?am9RY2x0Qk1mZERvYVFOUTlIVnZmSGdQTHBYNzJnVGZJMDZwMHdPcExKQytL?=
 =?utf-8?B?eHVRV3phUGh2RDRUdHlVYThBSTRGR3VFN0FVRWZvcWF5RXVVV1FCa1piclhy?=
 =?utf-8?B?SWdvZnhsL3V5bGFtVlJRSDNkRkpHRERLc3M1dUlrZEdZU3hTRFE3anRuNm9m?=
 =?utf-8?B?d1F4RVA3aWRkdndVejlsaFp2MnBrM25xbGJ4dnRYZjg0SzFFcXd4R2hxNmhk?=
 =?utf-8?B?c1ZKamdwY05QMGpjRUQ1TGs1WW0zMGtwUWNINHlDOGxlZXVIdVVMUFhqTEQ1?=
 =?utf-8?B?MFNHcGhNeFdMbEhwOFFibkp1cVYrOUdvNTV3OGlXYWUyQnE3ZGpBNzcwMEY5?=
 =?utf-8?B?TnROSm1HYTR0Tm8xZXpvNG5XUjJ0NmtFZFB0VEdHSnJoRlNwQXo0elFleERY?=
 =?utf-8?B?ckdUNXV1bThqeDZOeldIRjl4eGNxZEkrSnVnU0ZGS2hyNGc1eHBDcUM0SnNx?=
 =?utf-8?B?YjlDbGZjWWFsTEtHbjVjaE5rMVN0MWx2RGEzUnByRHB6YVo5aXg5dzQ3dW1E?=
 =?utf-8?B?dlhNcnRZMVdVaFQzbmdIdHdsYkIvWDV6YjJ4SDhiTVQ5VkYvYXgxYjdLUjlU?=
 =?utf-8?B?TURFWThyb0JCRHRlc2huRjNaeGM0NHczOGwrRjVJNHYxU0hHcmk4UmZVOTFC?=
 =?utf-8?B?L25VcitobEl3ODJKNGxubW5NT2VTSDNpWkNXVlI3eWttTDJhYXdwNlQyNlEy?=
 =?utf-8?B?RDdhWVg0UkdwUHU2TkdxNFA5cGNNbklVU08yKzd2R3lwVWtFNGtIWDBNMURM?=
 =?utf-8?B?TGg1bTgwRFV5ZTlDNVBaZXdjUDdUcHdYWG9MRUlhQmhvWUpKT0IrYkZIT3NX?=
 =?utf-8?B?YkltNW5Zc0M4QmlYVElwVkhjMHRxVG5JSmF4UDBRbTVtTUdybUNzM25td250?=
 =?utf-8?B?U0NWT1lDd1VOM1lNNEdoRDh1RHFRV256Y3BvRHRCMUk3YnNuRUFGZ096Q0hJ?=
 =?utf-8?B?eG9DQmlscDMvYjlkVDQrRmVZRU1vZlgyVm5HRzBGQmpNRHJPTEpuakFUQXdo?=
 =?utf-8?B?SXFVRVBVcXZEK214RzhnR1RjQ2QwY2FSK1gxTEM4Y2JoTWpyVTNlT0xEWDkv?=
 =?utf-8?B?TFkrU1BhbjRzZktuVVhabzcwSTUxRVh5THpRT1E3cGI5UVp5bHRKb3hZckFT?=
 =?utf-8?B?d1lCY3dTT1BhMVQ5cFpiclNuWi9JWUN1RW4zOTNuelF4b25NRzk5aDR5ZFNo?=
 =?utf-8?B?aVRCQi90dnIwTHJpVURsYW5YSk5vT1BBdU1Ed2I4dnVwbUF2Wk15aUZRUjNC?=
 =?utf-8?B?aGNaZ2hXQTRkZVJvSU4yK3FlWG11cGZNN28zNndlMDNybUVCNU1KSTFGUDRs?=
 =?utf-8?B?MGt5VDlydkMyTkRtZ1V1czIwNHpiV0hPczVSZThraFovVkFaeFlRb2QxSlZ5?=
 =?utf-8?B?WDNMMlpZakVlUXhjaTF1OENXMDQ2NXNvaTA5dG50VXVTT3Y5MkNLSGUvZEhS?=
 =?utf-8?B?S00rSVRPd3FPcFF2bzZFZVV3R1EvRENMZDExbndvd1BQU1BMNnlHcUtYc1dT?=
 =?utf-8?B?OGJ6bnRuMjhNbzgyUjNqQjBYNFRpRlByMVMvUVBvZUQ3SjFRT1NacWkvbDVD?=
 =?utf-8?B?Q2FhbVRCRGdXam5FYVpESFRlb2txUkgwMUNIc1NnbGNLMTRzT0hOSEVkTjEw?=
 =?utf-8?B?ZU55cVlNN3h1TVBGWmhKK0Nvam5IMitzalI0cy9iNXVGQ1RWR3ltQ0lCdGY5?=
 =?utf-8?B?OG9sN1V4MUxOR08wN0ZPc3JITkswWGt2Rkp4Q1RremQ0ZGVVVi9lZTVLUjlr?=
 =?utf-8?B?VXVDcDFsZ3VCWG5rZWFnd25McWN4YjlmcGgvTzhibCtZS1A1SjhFbzl0ZW9T?=
 =?utf-8?B?RkpJWlNETVdiZHZuTkp6eXhOVXB0MkViSGFaK2k3a2lsZlA0VExqL2FBbzcx?=
 =?utf-8?B?NWEvTzgwVmdWd3NMa0IzalJFZDFPK1NoZm42Y2I0cEpaTEd5cWh0U3k3WVBy?=
 =?utf-8?B?UU9BeHhRckMvZVEyZFJEVWQ1cm1vbmxzTFhDQklILzVDWnRUV0RtL1N2WWtp?=
 =?utf-8?B?SmlkUk5ZeVZQbldWTWtKemE3UkRkRXZWdktIeVl6RDlJTXY3Vitra0xMcGV1?=
 =?utf-8?B?MHpHZEVYb0tadzJBalpUVng3ZkFqVUpydjVYbDB0eFVmajlxcHdaTnBnUUFp?=
 =?utf-8?B?bi8vczNtN0RHSXdqYzNBZUlPQkNpL2NXelZEb1hxUkNqVUJ4aXpXSWlLaVFn?=
 =?utf-8?B?WkN6V21WZjFIRUozWGRmbUhmZFBKNDZpZGk2bXAybUt1Y3hvSkZ2a1YzUmdO?=
 =?utf-8?B?bWs3di95TjhHUUhqak1Bc2VGeTN6azUxemtzaUJHVGlYNWE3RnZEQzNqWkox?=
 =?utf-8?B?c3FpZFdqbGhsc2pSK05OdTNKNnA3eWM1a0pjREdXbVNOUjBMdHV3Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a0be34-7761-4827-0989-08dea74e0e7d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 06:51:23.2089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nHvwEd5TpLKEj/dwXoCPEjJP+litEHJjJ5bb2agRx1deIIRuauoKd0PhpRzsmKpIaE+4BQNImltynzPtjKTsjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8578
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E02E8180002
X-Stat-Signature: 8xnt1p35xqd6w3freq8g69i3pgzkenz9
X-Rspam-User: 
X-HE-Tag: 1777618288-97011
X-HE-Meta: U2FsdGVkX19cPRNv1GLJfCO85HJLCnZP19S+SP2cdG9W57FXHNCGKXiDkEpGEhuyaOSZx9KYhQxBsXg6rwx7wDEJyiEqUewyNvkQCvUIoes7FhBmbrss65qbBwiv9+v1NMHEaauFfjm5Ywu634u4iEfRhNQ8sRUX1LgYAZn7sJonJbJq7k59e9KpjFAWen9QwqppAJOzRe/ISHraq8LLtEne6vRJI3EtdN3ntLP/NjdfX0f0/y0sWz+l/3gJdFoSEfH/FbiTv1xN0an+ySLv6Qe5pXrjH51aKuU95KMWPWwTKYkaUwbBOjIP7hyPVyTT3umE2/NzcgdTUYfg1GqNWaS1figfpWlAF85OVYO5I2u7/5B4+1m/VmLAbsgy8NA+T/v6tFt5xDlcgy1+kr+8SqViTw5m9Kpymn/9KNk7Dyjr4hlSiQONw82Q3FdquH34gVI0oEsOX29upHLCGbLfIBsqBt2UWX/xpTEkFDSCbPUdcGdty8frxBZUA36ijd9MmtG9pbKwptLbgGbKKB3zPvJbgOAyo6Qv8ZCOxBWrtMLCtCK4+CgEdZvXjXdRcle31fKHuJFlYP8O4NMskkfjv1gXK8NqS3qbEtfShI84a3Hq1I+YujpoCyuQY+kFzwcsKbGoMdAUSNOcNXEMK2yxhWgM/kuy9Fp83rPZ/a186Hi1PbH+bi6IvnD7794xd23NcrNG/FZMoJn0Znle/qr/MUGZLkqs5Wvb9ss8q4grVLDOP9vQ5R+9ho0DJnIKV/UPY70MABxLpix4SOY/5IvT3KHnosCiCJWvWiNH0+E2nUUSJ+j8bmyK2gUpOZgwitqrCEsvTx+LQC/TbWGogVglX6u+oxywawsofr1+Qs3DH1+bXZRoReMOezu2w0yvGNze23rHTlS5doww2O54xdmMD7qvnrxhNuXa1gZvEjLCwov66E9LdyEM5mzSUwyowc+lfwFdg7WeJcA0Kbr5uMw
 WCVwdTHF
 yfY2yxBQ4MBBCCC5Iw03m1YyOm1hSNi/m+YBQiqLvlMXBp/l/Fqeg4BG/aocGPxU61nN0fqNuKrwRX5tKZnwGg1mN/k6k9b5+9wETwOdU0Kywp9mj7J+kisJ9swCZcuWSyruWaXNbhnjEa7eBR4uWAVshpoK7yzealmmyTvax508GOFsSZpO9enlFhrbTvZ5XlXbP3bjL42fxx1maxuoJFzi2zPYI+OUIKPk6uWUjYLKosd5JjbJHOZdl9aoNW1XNVa5+r11FAR/tEGB7/lvP+hgFrh447lF7eOugXCUEdS5M6+PcIvrTJClOF290DVzPGulHqtBsnkwzlkYHD0L0JoWy7knDMs98P7zaeDt+kXOnQc1d24VaICe2X8qPdTLQ+txndUXiRI1riCgChfRGQ2umXZW3CY18khzkwnbri6o9HWfoQGYRnllblHbyijq6WiJ8NcCpaiptZnuxYcSc92W463vIl1Itx4FVl+QVyV4drvoh49/JNpFiCjzWIXXPon+0JMxjvn+vOWmGK+uJUAoZ5muXGxtuU5wtDIsh3ToWtrcEkt5y2rafEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device private and exclusive entries are only supported for anonymous
folios. This condition is tested in __migrate_device_pages() and
make_device_exclusive() using folio_test_anon(). However the unmap path
tests this assumption using vma_is_anonymous().

This is wrong because whilst anonymous VMAs can only contain folios
where folio_test_anon() is true the opposite relation does not
hold. A folio for which folio_test_anon() is true does not imply
vma_is_anonymous() is true. Such a condition can occur if for example a
folio is part of a private filebacked mapping.

In this case vma_is_anonymous() is false as the mapping is filebacked,
but folio_test_anon() may be true, thus permitting devices to migrate
the folio to device private memory. This can lead to the following
spurious warnings during process teardown:

[  772.737706] ------------[ cut here ]------------
[  772.739201] WARNING: mm/memory.c:1754 at unmap_page_range.cold+0x26/0x18a, CPU#17: hmm-tests/2041
[  772.742050] Modules linked in: test_hmm nvidia_uvm(O) nvidia(O)
[  772.743959] CPU: 17 UID: 0 PID: 2041 Comm: hmm-tests Tainted: G        W  O        7.0.0+ #387 PREEMPT(full)
[  772.747104] Tainted: [W]=WARN, [O]=OOT_MODULE
[  772.748509] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[  772.752117] RIP: 0010:unmap_page_range.cold+0x26/0x18a
[  772.753780] Code: 7e fe ff ff 48 89 4c 24 78 4c 89 44 24 38 e8 f2 ff b1 00 48 8b 4c 24 78 4c 8b 44 24 38 48 8b 44 24 18 48 83 78 48 00 74 04 90 <0f> 0b 90 48 89 ca b8 ff ff 37 00 48 c1 ea 03 48 c1 e0 2a 80 3c 02
[  772.759602] RSP: 0018:ffff888112607550 EFLAGS: 00010286
[  772.761310] RAX: ffff88811bbf4dc0 RBX: dffffc0000000000 RCX: ffffea03e9bfffd8
[  772.763583] RDX: 1ffff1102377e9c1 RSI: 0000000000000008 RDI: ffff88811bbf4e08
[  772.765914] RBP: 0000000000000006 R08: ffff8881059f7448 R09: ffffed10224c0e68
[  772.768184] R10: ffff888112607347 R11: 0000000000000001 R12: 0000000000000001
[  772.770461] R13: ffffea03e9bfffc0 R14: ffff888112607908 R15: ffffea03e9bfffc0
[  772.772782] FS:  00007f327caa2780(0000) GS:ffff888427b7d000(0000) knlGS:0000000000000000
[  772.775328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  772.777187] CR2: 00007f327ca89000 CR3: 00000001994d5000 CR4: 00000000000006f0
[  772.779135] Call Trace:
[  772.779792]  <TASK>
[  772.780317]  ? dmirror_interval_invalidate+0x1a3/0x290 [test_hmm]
[  772.781873]  ? vm_normal_page_pud+0x2b0/0x2b0
[  772.782992]  ? __rwlock_init+0x150/0x150
[  772.784006]  ? lock_release+0x216/0x2b0
[  772.785008]  ? __mmu_notifier_invalidate_range_start+0x505/0x6e0
[  772.786522]  ? lock_release+0x216/0x2b0
[  772.787498]  ? unmap_single_vma+0xb6/0x210
[  772.788573]  unmap_vmas+0x27d/0x520
[  772.789506]  ? unmap_single_vma+0x210/0x210
[  772.790607]  ? mas_update_gap.part.0+0x620/0x620
[  772.791834]  unmap_region+0x19e/0x350
[  772.792769]  ? remove_vma+0x130/0x130
[  772.793684]  ? mas_alloc_nodes+0x1f2/0x300
[  772.794730]  vms_complete_munmap_vmas+0x8c1/0xe20
[  772.795926]  ? unmap_region+0x350/0x350
[  772.796917]  do_vmi_align_munmap+0x36a/0x4e0
[  772.798018]  ? lock_release+0x216/0x2b0
[  772.799024]  ? vma_shrink+0x620/0x620
[  772.799983]  do_vmi_munmap+0x150/0x2c0
[  772.800939]  __vm_munmap+0x161/0x2c0
[  772.801872]  ? expand_downwards+0xd60/0xd60
[  772.802948]  ? clockevents_program_event+0x1ef/0x540
[  772.804217]  ? lock_release+0x216/0x2b0
[  772.805158]  __x64_sys_munmap+0x59/0x80
[  772.805776]  do_syscall_64+0xfc/0x670
[  772.806336]  ? irqentry_exit+0xda/0x580
[  772.806976]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[  772.807772] RIP: 0033:0x7f327cbb2717
[  772.808323] Code: 73 01 c3 48 8b 0d f9 76 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 76 0d 00 f7 d8 64 89 01 48
[  772.811337] RSP: 002b:00007ffde7f57d38 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
[  772.812564] RAX: ffffffffffffffda RBX: 00007f327cc9c000 RCX: 00007f327cbb2717
[  772.813733] RDX: 0000000000000000 RSI: 0000000000400000 RDI: 00007f327c289000
[  772.814867] RBP: 0000000000421360 R08: 000000000000001a R09: 0000000000000000
[  772.815991] R10: 0000000000000003 R11: 0000000000000202 R12: 00007ffde7f57d74
[  772.817121] R13: 00007f327c689010 R14: 0000000000100000 R15: 00007f327c289000
[  772.818272]  </TASK>
[  772.818614] irq event stamp: 0
[  772.819159] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  772.820174] hardirqs last disabled at (0): [<ffffffff82a57ab3>] copy_process+0x19f3/0x6440
[  772.821511] softirqs last  enabled at (0): [<ffffffff82a57b00>] copy_process+0x1a40/0x6440
[  772.822869] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  772.823871] ---[ end trace 0000000000000000 ]---

Fix this by using the same check for folio_test_anon() in
zap_nonpresent_ptes(). Also add a hmm-test case for this.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Arsen Arsenović <aarsenovic@baylibre.com>
Fixes: 999dad824c39e ("mm/shmem: persist uffd-wp bit across zapping for file-backed")
Cc: stable@vger.kernel.org
---
 mm/memory.c                            |  2 +-
 tools/testing/selftests/mm/hmm-tests.c | 50 ++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index c65e82c86fed..3f22a67a4d7f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1750,7 +1750,7 @@ static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
 		 * consider uffd-wp bit when zap. For more information,
 		 * see zap_install_uffd_wp_if_needed().
 		 */
-		WARN_ON_ONCE(!vma_is_anonymous(vma));
+		WARN_ON_ONCE(!folio_test_anon(folio));
 		rss[mm_counter(folio)]--;
 		folio_remove_rmap_pte(folio, page, vma);
 		folio_put(folio);
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e8328c89d855..eb860b5d6f85 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1034,6 +1034,56 @@ TEST_F(hmm, migrate)
 	hmm_buffer_free(buffer);
 }
 
+/*
+ * Migrate private file memory to device private memory.
+ */
+TEST_F(hmm, migrate_file_private)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int ret;
+	int fd;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	fd = hmm_create_file(size);
+	ASSERT_GE(fd, 0);
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = fd;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+}
+
 /*
  * Migrate anonymous memory to device private memory and fault some of it back
  * to system memory, then try migrating the resulting mix of system and device
-- 
2.54.0


