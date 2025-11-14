Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255BCCD98D1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7568E0011; Thu, 13 Nov 2025 20:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777AF8E0002; Thu, 13 Nov 2025 20:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667888E0011; Thu, 13 Nov 2025 20:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 530A08E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:24:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE21057488
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:24:31 +0000 (UTC)
X-FDA: 84107467542.09.BF83BF3
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0ECA68000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:24:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P2pfErw1;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.9 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763083469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooRmFueGoOYGN6E4IZs4ppsf6l/QSftRiyCKXERqvH0=;
	b=jKh/a9+LDAcFOCqKMcSwrgu1p4w9+q0dcvU1eeMVLPEBfJ4BBkjIf+XNUVdEgMZObvbEO7
	plTYYS2IYNN8jG/viEz4t/jydM4ocYx+556bwQObS7QxxMewevt83GlPJ7dUZ1fPNbUwxz
	5Gg5wWESUGtD8A8CBeAy7pVSdhlTsSg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P2pfErw1;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.9 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763083469; a=rsa-sha256;
	cv=pass;
	b=hO3RXJm5d62bW4bfIxfDFoQ4stwV/+OzV10ZuyG6kxjpU/D+xUvVgrc3JoEc/IyFIyaARS
	PfzprXD1dccW8yC+WZr0/9+dZIPnmRjtTY3bjMzv5JzgA1HBNNDojZCZdEecmFnOerDZyj
	IScWE+I3OX9cBRTuPvewLO9RRajplSo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K5IL2b4UsXLb4+rv//ls0sWXN6gZxLB/z+MlnUQK3fUR5O+29uCgHPa1UmLUFSuIahHuw65EwT8c4lH1yJn+qwDhXl3/dzxGEADt0GcEd8XHTteCF6PxyeKGLB6Tk6r2AoNHEAP/ugoPQReb8Hi6CEeENACZFXFHj/ALOnusieGB0ABtmtDh3MhzUL4zwHJf84CHbsHhXynl7oxdPFGL8ilLwEhRHHSlmCzDuVdamDgSDDUx1auMIFqg7BjbxNAQcsgz/l1Dou7EoPzMAL5IvQR76q4etchb3bGTj8WjWuv/WnYOYnYFYj7/HbwUOUoEqm9PYkTzyPprVOJi4fla4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooRmFueGoOYGN6E4IZs4ppsf6l/QSftRiyCKXERqvH0=;
 b=Ixs+iBai7Ryft49DI48x3ODLhBc9m5bqwxaTGsUSf7VUArGC+H4O35I5+PKM5RtjyQaaZA3rNFrDr0HkRaypLHuVcXxBi8nvfxiMN6fGwgaq0xRGhEApjocluvVvt/X2b8EoWgT3sF8DeCOnQzpq9DNg23Odekb2tCsoR57Nsd8RQlx7dcXqr7b0eMzoDoL2P7e02cYLyjqGK2k/HCEgi2bZm6a+yFSGcLZ98srl14Iyk4uIsy+3+2tAKnKySN97GYMRMj1cpIK2UyKySJII+xU09dezeEKPTYRhksziN69oWrmOd45HIR7ujq2KPnOOiM9Dy5/NlZSbEtWFIdJ+7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooRmFueGoOYGN6E4IZs4ppsf6l/QSftRiyCKXERqvH0=;
 b=P2pfErw1tO9vL8tbP3hSwMMqKA2FDIN/c6z4z20adQnA9iPFNHWezwcARUGHbxmGwGdXNo4L3zzbPxpJVFGgrnpY1MDpd5qWhrbksgZpIeIjBdnhE3KYLxApsU7wwZA2NPKzQbGkVsJPBafYLh2UI5ONyqMDdIhIOJ6gqfzivyqXX0klhyBSAH3ZC0cFC9abAtViwO7fJT2dBF80i55ZjetzTcfj4DmlJ3EwrBavbArBHTo7rFCU3Hw7KShfeSu9URzYs0ANzDR+nQmpHLrOmMf4LXW/zPHBX/8J6a4PBLLPEAoanuyPYL5DzhjbR/vrligjmy8537xP8t4EDqE6Ig==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB6769.namprd12.prod.outlook.com (2603:10b6:510:1c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 01:24:24 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 01:24:24 +0000
Message-ID: <406bad47-1637-4891-b418-31f510382384@nvidia.com>
Date: Fri, 14 Nov 2025 12:24:17 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix override of entry in
 remove_migration_pmd
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251114012153.2634497-1-balbirs@nvidia.com>
 <20251114012153.2634497-2-balbirs@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251114012153.2634497-2-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::22) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f4d1544-c97f-4ff7-2b06-08de231c8bcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkE0cjFMUUFFM29yVjgxSU9MZmw1dUIrME5MN2NyNHR1bUQrSzVqTC9yRUE2?=
 =?utf-8?B?aVBRNDlUZHZKWlBOM05Rc3RWeEZHNFhDZDZpTE5RRm4yMFpiRlJNZ1pycmxn?=
 =?utf-8?B?ZXpSQWdjTDlWbElVeEpuakY1ZHBQWHMxM0RYNGpiQlZOK0tkdmtjRllUNGly?=
 =?utf-8?B?THF0Wjl1cUUyZEg1VDJwTU85bi9zaUxVa0JwZHhta3htamRuamR0b1pzM0Rq?=
 =?utf-8?B?b1BvWFhtbVJydjV6TkdpNFNIa1VuN29keCt5Vk1sUzVTd3Frd0FWNHlMMkVZ?=
 =?utf-8?B?SGE3OHBXMDRtdEw4RVhnVHFEaFRVZFpiUVYyaWhUWmhnWXNmWHprSjVKakhq?=
 =?utf-8?B?QkZzWkNvejdNaDRMNUlDUjVSNE5tNE12QUtnSHNZN0RqWTJCU0VHeUxPYVAr?=
 =?utf-8?B?SVh2VWt0ZWN0NElOTXlXSURqY0RJOTZWbE4xeUlPZit2bUNwS0pid3ozaXlV?=
 =?utf-8?B?VGVEb3ZKTTI3TlduMmVoQ29Pc0tyUWxpZC9rQVFteitqckpZV1dnbVJDU1FG?=
 =?utf-8?B?N2hUSEIxVW9ZUDdHRmVOQUlEUDFNMHVma0t1c3NPc3lRbkUySVk3K2RrZ1NZ?=
 =?utf-8?B?MHNmZjlxSHlxclpKcUdFOGFYR3N5djFEZXQvVS81OU16azRCTXZGN1YyV0cr?=
 =?utf-8?B?R0VuYW1yTzhBRk9mMUJWNWF4bWp2RTliQ3RZVGVYakF5QjlaS1lnZzMxR3lx?=
 =?utf-8?B?cWVRM0NwUkljZDJ4RFVUc3FLM2s1OU9nYmc5VUVobGU3MW9vK3NZM283U0FG?=
 =?utf-8?B?Yi96d1owS3o0VEVKMjBTMUcvZWNaVGZqSDBrNkdvQW0vN3NxOUpaRmkwSkxX?=
 =?utf-8?B?NzZlTzYveXhwdEx3VlNIY3lra2k3NHQxNWpSVVpOMUpRR3hQTkZpQitmd2N4?=
 =?utf-8?B?TXF1dUhSaWd4dWdqbGFYYXFPeDM4eW1ycTlaMFJuZ3JzV0crV0w3UEVCTkh6?=
 =?utf-8?B?ckVWMTBZcjlHZ1ZYOHloTThGbkpVanVSQjgweXgvNGJoQzJVekg1TktTTHBs?=
 =?utf-8?B?N0Vob1pPZW1kYWZ0aFZWREtOR0RjK01CekxmSGVTNGEyOTZMK1h4U0xRTE83?=
 =?utf-8?B?MVU2cDJ1RHExN2Q3MDFQRWJGKzJabHI1SFlHYWtXOTZpcHowZG9MTzdyZFA5?=
 =?utf-8?B?cGNzK0luNmVzdXVNYTRsWDlHb2VEdy9VSjdXRXB6WGErVmZYcEhsTit2MDU1?=
 =?utf-8?B?RzlESzg0QzNJS0p2WE41R3BVSS8xMnc5YWZPSXVONTJta1FDSDlCZDVUNXkr?=
 =?utf-8?B?OTh2TzNONjc3aEJITnI1LzNPanhRazFUWkNDWC9OZVIyUkhYSmkzT0tzTHQ2?=
 =?utf-8?B?ci9LZU1GU0E2R1lZZHNUakhpLzJ1VHlKSERNMGw5R1MwYXVmNWdSS0tXLytv?=
 =?utf-8?B?S1ZRakJHWFdLb0Q0VFpZc0w5UmE2WHArWXNubUp0eU1yOVBiTjhJWHl1MmtV?=
 =?utf-8?B?MmljU3U2cEFXYWZNeWtjcFBueXpKQVVJVFNzSFpmZVRiS09CdWM1Slo2cFJJ?=
 =?utf-8?B?elptSzNhclRJRVRiL1J5bUdoSXBMNzA2L0VBc1FVcXZJSzFkWUxQS0xvTkxj?=
 =?utf-8?B?c0haV3F6eGRpdUpVZmhQbVRLa3Bxd2xja1NzaTNHT00vdFhQTzVEMmYwWU5l?=
 =?utf-8?B?d1BoZzdXOTdYQVpQYXpHQldrUTgyMjRhRlc1dFdTMitpTVNSMFVLMWxRTzlC?=
 =?utf-8?B?c1BhUUw2VzJ5M2JVb3J1NDNIVzdWU0RxY29zSGxWZFBJcmhnbWJ3NEQyYjJM?=
 =?utf-8?B?bWl5Yk9NTlFPZm9xTUd4Vm5HaTlkczFoUWp1NCtDNmdQaVcwQVBUbWxGWnZB?=
 =?utf-8?B?VTZrdEcvQXpoSVEraUl6OFBuaVhxYTFhMjlPMkx1Nm5HQ2tCQjlZZ09NcGJv?=
 =?utf-8?B?SUd6UXBaczNrU0tadzhxUGcxMTVZVFhXSWRCWERyVDRLOUJnbjNObkE0WjlC?=
 =?utf-8?Q?Qi8DW4YngZ6mhSujN7UZLjYcSaL5jtGU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1JZa3RZc255dTVVVmVma2s0MEo1SUNLdUxzaE8yazNkbXFZSWRPY3UvT3Rn?=
 =?utf-8?B?UXBnM0dHQTFKQVhnYkxVZ3h0QXBBck1xeHRUZjhDWkZEQVN1VGtZa2NQUkNX?=
 =?utf-8?B?K1lQd1NJSXFGSWdqbG5rV0VQWHE2QzY5dzdSUEFBME4yUUVTb1lybmoySmxK?=
 =?utf-8?B?N2N4VDhZOXN1UmhTNkhhRS9IYUY2S2h2WXQzTGQwZlZmWkRaS3BpZDZlaUdk?=
 =?utf-8?B?NTdXbWZoZ0lIUmdCWStONUN4QWU3ZDlqWXdEWjFrbUJqRWpNcjJ4RFh2V3k1?=
 =?utf-8?B?RjNoVExlazJoeEwydmRDM0FUY0VSTUE2NnhoUm1SSi9SbWthMVpJYnZtT1lH?=
 =?utf-8?B?QjAvM1pZbGllUURqM1pOMHAzWjRpUmtpNEV2QXMvamhremdBTkV4ZzhJeWIz?=
 =?utf-8?B?c2RmeXRZL3pQRHp5ZmNkaUxHSEs5VlZ5VFk4SGR6N0lvNWEwbnhzbk0zbjJk?=
 =?utf-8?B?MVZTREUrT1F5TmQwUHBzSE9YZlNyMkg3ckFzSGgvcWhmWTFnY1pKT1BGbEEx?=
 =?utf-8?B?YTluZGxQcS9CUGlDNWYxRVVzQlJKNWhMblpOUFFzVFNURjJubjZocnBTVm83?=
 =?utf-8?B?SkdrT0FWUmhhOFV4b21idVVHQ1dpVnBrT2xZN2VVb0NOVWVseFVkaFFqVzR6?=
 =?utf-8?B?eGUrdnNtbUZmSXhRc1Z6Tm9VSVByd3pMSERBWUZvL1JXMmJGL3ZpWHJ2U1BZ?=
 =?utf-8?B?YnNqL2VuVm1hT256UlNVTVNtMnE4eWoxVGl1ZnUwNTlpdkhwcWttenF2ZVZG?=
 =?utf-8?B?V2xhTU0xZWZmMklTMEJvUjRLYzNpa01rNmRhRXZEeHdXbEp6K1JKRG94bXA0?=
 =?utf-8?B?a0U1ekJXODZwbVl2SDQrYWRpcEY5dFZIMk1CSS9BTHVxZkRTd2JyQ1oydTh5?=
 =?utf-8?B?cy90RWsxOThLc0VYZHpQTGpwa1l0U2ZveUFGRk1WMGZHMlhyaElEaHN6Z3dX?=
 =?utf-8?B?SUQ1d0hVUFNZNVF1SkhJUXpCcjgxNFg3dExLZ3N5NENCRm4wR0dNNmg2V3Y1?=
 =?utf-8?B?SWhEdjRTN1hNVklLYXNBb3gxMUtyNjJpUFpHVkdEdXVmTll3UVl5aXVVM2Uw?=
 =?utf-8?B?bnBhZjN4aUhJL0JiUkFMeDNITEZnaEwzTFFKL3hWRWtMZ1pJQUFOUUNjaXBP?=
 =?utf-8?B?N21mUzBYdXhiTFVBREdnWExTQlZ5QURWZThVdktPUWJJR0ErWHgzNlV0dFpJ?=
 =?utf-8?B?b2NGQWpCRy9MNVBzQmd3aWdDV21DMm9QREcxcFY0VUNwNGJlcmowN2VaTnZZ?=
 =?utf-8?B?YjlrV1M4WnZuOFExY2NLZDJzSFNJOHFJWmhsd1VadUloWTN6ZUV5UlBjSlND?=
 =?utf-8?B?Q285WnI2bGFEbnd1RVdLZmFQZERSaWFKMnVKRGZsVE5GRllZdVJ1bVV1akdQ?=
 =?utf-8?B?V1krRUpsRmFTa3JMdnIwU04wU280YjV6cGZEUXovcGV3UHgzVFZLZ09GaFZQ?=
 =?utf-8?B?NHhPRDVFeVBrR3ZxYStlQmZRZnplYlNaRWZwTVdOM1RKQjlDY3NrTzEzMHQx?=
 =?utf-8?B?cEZRSFNTUFVhMXdGTWR1Sk00RitTc1lOZThERnNvZTN0Q0dDR2FRck1OYlls?=
 =?utf-8?B?VlZBa0RrZHg5d1lmMmdBalZEYVlpS3A3UFkrUE5PczFtMXg3cDViUy9YZnd1?=
 =?utf-8?B?MHdnaVdxSGxSSHVXYy8xWnJsWjdsblRFZ2pkc1ZhVEo2WEJwVGVHWEFEbTg4?=
 =?utf-8?B?RmZQNDlaVjJ4d0s2Z2lkREFMY0cycCswdGJFanI4QXpkWjY2M0lneUlSMGlr?=
 =?utf-8?B?VDI4Qkp6a1RPVThSbWFLZFkzcWVVRXUwRWk0QmZkS2NuNnVzdXF2WUJuaFRN?=
 =?utf-8?B?N0ZabTZGWk1LellRY3g1d20vUDgwY3VlUlpuOTR6M012TDlHVk5OcW9KRzNy?=
 =?utf-8?B?VTJxSHBueEdNd1daaml6OEN6bTVQL1kvRnVYL3YwcmR3dk9CYXBCRmpoNjVN?=
 =?utf-8?B?U3JKVURiRUxmVXpucWZFb0EwOS9vQUhaeXdLQm1WQUp4eHlIdnptYXFhaGtE?=
 =?utf-8?B?d3k5Q240VjNlNU1HY2ZFZlBNRThXV2ZnVGFFajRqaHpXeGY5Y29FaTJwNnZN?=
 =?utf-8?B?VDZ6MUxjNDN4SU1JSVBldE1KMkR1YXE3VXpaQkxCZW1mN1JSTlFvUUl6ZHZ2?=
 =?utf-8?B?TnVGSFpXVFpuY0VadGdILzExR25VTEdyWDJmN1Bod0V5am91L3BBSVJUZ25W?=
 =?utf-8?Q?1KcSbGGrHgOik8Pd86uuLA5HvTCtJ7pGaSwmRI4tGu35?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4d1544-c97f-4ff7-2b06-08de231c8bcb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 01:24:24.5572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDkgBpZZB5dXcO/9E3JOjiHg+PnLenE8nzx3DVoJKRoi6Mmc7fFr1fEfQKbQywYyNt0H9ye8g//BWdgTWuF2iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6769
X-Rspamd-Queue-Id: 0ECA68000D
X-Stat-Signature: oz8a3a8ga756j1xgxmy55yiiaye7ppni
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763083468-802220
X-HE-Meta: U2FsdGVkX1+k2jkGlrGf2N/O3x4amo2SXo6DGqCI1nd9bKFr+ptaEDiDtQ6GtEmZLftwl0p3xPTKMeGsGLQpZE+YvHp799EMwZnfmNEFUoN1/QbkGd4iONlWJpT13/cGQ3FNM55wYlvVWIxaUvuCCLAjDJfhwTb5VFP1WXl7hiec8hglhzIxpdYjlXhW9DP42KX0B3XoTpY+GKgzVrzOehgvBaInAKz2UjKdXtZM6DuswVNXxRiq9mj/7BlJL+te9/08qqCmVUKsIkQycQQbbMKCUPRXHHaiO/NlCFf5HvK6vI83cwKWtpRA29bqXU6mOsBH7AIZIf45G0m+WQ6AblXVEQD65SFe2T40nvwwU8hibjCTdL5eqgRNJbFsZ2wNZvRKCGeMt2uV3yVV0ZyuiG2ecg08Vt+zG4rT08s1xz5AL2mXP4Xpu3IfeTYESsUbCCxsaKoD3mg5Zdb2YlzNKg8a9dbPZoiZgRfokBI42oJRRqDfcsAuVMkYQDEnyGxJ4KL1P10M+38aHJKY1y0Kv4+JBDgggcV6tGwe903XzEeP9sAaDcRtZWCrHRqSBWNq4u61E548JRszwEgSuhsdOBQokMPLolhxwuNq3blPdi3Nvm0fz0VpGQchhu4D9SErWkTM0hNldFF+dHGCB5B2nqNrpYS8SeTwr9wv1q5ZP9jbCKRq4GAlYFgokRWiBy66ov4rlX4WtXG1fjH7VoNsyJRem3ikKyxCxEUj5QHcgqVvoEjoBSoPkKXMjnS86sSfvA9RnVEvChHCrLA+NNiZS9kDsoX/0kj623aY0zSzkb6uoquD2+vbuy0Sb8/GG4VJZR2OJs1VUDdKx7JRm9+bD9ZAIPC7NUv2t0xrbDk7CC9KgsZhQnb6l1urFNbojYJPVp5P2szbBriFf4HJnT0hQLgSKaQrLFIybnFUEP16EoR6ZZ560IQqa/dS+6Z1OwbLrkF8S1ccPQ+PKPY6GGt
 me+jLPKc
 bx3EarF0UAjNwokxKYNzO9i3xgGegTOHeX+o/uulgfpgffuDpt+pe6oXPEqpPyAIGPRzdqSvrAtRcf6pSkTRdQt3sRyAxYvqSiwql5aUDiyvzXN4tb/FBG6i+UA4/eLZz8gHQ4raQLkMEs97YyyN4F3yfQIVHPEb6XTAhQtcQlH5xnre0zGVZOVHovVn1RKisVscFVojmQ+zi68Y3ekg2FuAvk3MyRfKtogKAY55gvnyymH6oOZ51y3YG+fDRLZWTPAAVsnrtbyptjLqnsEShRn1CXzl62DjBmLpt6dtaW2vkC7yjfHZR1L9UfaBerFY84rPdO7LRm+ff/pi/6AxBLmZh1h7IHEVxgmAskr9eMSTXThB93gcIT1WpJrlvAUtC0Hc/pg3hzw4A/GtGlUXQM6vnljp9onu4EvwveBJAa0Y8vXEjGFRXCoOvnEide5mLtjKKEJJC1YWideSPeCF5VVAxevijrBYXuj7hmHwcvsWbiMvH20AlmzFqj8sKzU3rnesBtVWBZsZ7ktrk5nUN01hC46Re2rWcuxSB36CDOxGtvmLtSkA+i+TPKkkQ2vYw+asHHN2/Rc6FaY8+9gK3GxUS1SHoMM4dQgTCDtYFMN4jtLU6KT3cpq7Db2oenkAZgcO1hepAmJSsy4wULdm2ZAIh599sCzTQ9pwvL49nGuJxsycpWcKxuXPasBXnuMYzzltV6gW8ZU+UHnw3UAxhsEYBgwO7xpEbG9HF4IEUsyPKFld2vBgG5PcHM4aMoN194ZtMD7vSePATKg7s0vT7Z1el0om7/f/vCDhdlAnT8LdILb9A0+PcTykAJ9+ITm1wMOFgHcBfzTwas77HlQ/80nyLSUJK29v4X3QZzO4KnsAupCzyE4yzfx1GjdMcc4NWrk7bGU86xablwhoX9iWOuaoztiHxDoDolQEA0RdU4YuJI/f8Chobc3OgI3d+R0Is/46/CmTFdN3WLUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/14/25 12:21, Balbir Singh wrote:
> Recent changes exposed a BUG in remove_migration_pmd() where the
> migration entry was being overridden when the folio is device private.
> 
> Use scope local entry for creating the device private pmde. Make the
> pmde writable if the migration entry is writable by moving the check
> is_migration_write() prior to creating the device private entry.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/huge_memory.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 

Hi, Andrew

This patch fixes a bug in mm/rmap: extend rmap and migration support device-private entries
in the thp device-private series.

Thanks,
Balbir

