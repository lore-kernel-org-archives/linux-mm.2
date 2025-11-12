Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0631FCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618998E0016; Tue, 11 Nov 2025 23:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF7B8E0015; Tue, 11 Nov 2025 23:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7958E0016; Tue, 11 Nov 2025 23:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 357938E0015
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:47:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE213B5BA3
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:46:59 +0000 (UTC)
X-FDA: 84100720158.24.B0FEBD8
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2216B4000A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:46:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gv+MtJWI;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.65 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7GKPhoPvYzgxmlzt8Nq93rUpfyMvpqcHCkblmiAAzBY=;
	b=rTwtzk6ZOWBLdCaAQwXCrtFyhbPtmKKB/DZrNw3HzUdBVU6BDvKjtwo33V7OVZIJmZtmdR
	bC9ULdOoFiYJW9lBXBkFzwozTdVEjjfh1z26G0/n7EnVWoMzrt/trKUrB6/N2+ewFhONrn
	a4iSg2weW8uYYGSrKkvBkT05Yus2SFE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gv+MtJWI;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.65 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762922817; a=rsa-sha256;
	cv=pass;
	b=hj5A/Y/6PxHiHWqlswl4TG7piHhPVoLCzLmJyNT3vM8NyFm3KRtgTCIQP6T2zvg+Rh+q1e
	QBvKOLjRSJnw1unSYR26ng381vRqe5o/LGLt7RGvqYXDRDl+0D3pUUukOq5spoGtqDe/rZ
	Dl2K154EzWf2S+76PbE63VYJAk+M9Sc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SgRbfeET4brHu6BrQlizLT+1QRcCHYVSnpsrrTWi28TN5U9hVDmo/s3kf0hQE7xQEsKTSDXdz/KYB889PYyKgjSv093lH8Qzb3fK56bl6s4Ap5CAefcdpTbhwcwg2yM3TpfFM1TGV6XvhDg91X61qhlNj0KQX1apfcXm1cmugwC3nP6F/ZVGlR/KoR9LG6NUVUTU0VoaflCwyxoOR0g26D+mYoqn63cAMS5Vl3FgXk5D23/GttSMGLD/A1IZ4bMaxnPh9vD3agICjme0MENBIRVLyoraDZWyI54QOhfZMsD1TzWLdCMq6nVnIshoxcEb1Rt3F9KuuO1SsZGFx7ZS0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GKPhoPvYzgxmlzt8Nq93rUpfyMvpqcHCkblmiAAzBY=;
 b=IrYeYlinzVMuCXV2GcR3hZ406uUjxg3T/j3Gcr8ZfF1MbhdtbUXTZATjI8GSBhW8qdOpzDXVZ8wUlOb6cjboDLQSYQIGmHe7+fyB9h2QF+RcdLSTxuOo86hXGdsdlQP9fY2A/LLpSI0Fcx9nAkmMQ2BRXQLVhfzl/m0EUIr27sF3N7wAChkxQS8gHk5Dzn8dv116h15pcT8JTI3gOGP7RbR48jYM+avnAyNzylJUCw1z0D6yWRrWyqm5ycX/vowYVJTEDbzvUp9WQz6x1hahQTvJZzkn08LILAkCuvbILp0c2qbixEJqJOTa7boFJjn+dpbf4nI/ein1zYWthliOvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GKPhoPvYzgxmlzt8Nq93rUpfyMvpqcHCkblmiAAzBY=;
 b=gv+MtJWIOio/X0UoIc+yJBzx2I0CkvgHNzSOwRaceBjj3Zqp6xfzCxDxtoNq+YZSPFMN+dl7YjtPN/DllJHL4DbQZ6BfCXyk7zoZo6tDhJTpN9ndbFTb3ejFHY1YoEMEUyw0DmaMmzuRTq77kZ8tA0hmzBD0Z99RzD6apu6dE9PisOpBi5qZ1mscDA4m852Ufx4veXKB+rqwU9SG+iobeltZepLOFrCW2aEToxdTdeycW6vd2pcW4YlCspjwTlndXKIxx5irPDCt9zDrpJPziCZTLc4VZFrFW2mNBxZbN1TsRIh7fCz+hGWAzkJl4kvWRyRR4iP7xA/OeG4IKgJKwA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MN0PR12MB6175.namprd12.prod.outlook.com (2603:10b6:208:3c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 04:46:51 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 04:46:50 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
Date: Wed, 12 Nov 2025 15:46:33 +1100
Message-ID: <20251112044634.963360-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P282CA0015.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::14) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MN0PR12MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: a39be357-0c3d-48e7-1ef9-08de21a67e97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkloU3pQbWhWNnJ0TDlKVkdDYmhzWG5tKzkwMUlCTDk5RmtzYkdqeVVPNEtD?=
 =?utf-8?B?OTVIb3VqcCs1WUNEdmVuVWt0S3EwWjBjekFrSG0zZmhDd0hFeWhpbXBmbG14?=
 =?utf-8?B?WUF3dzlxZ1E1SEgxZFF5SnV5MnUyNHd2emZWR2o2MU1TUHZ3V2pTN2hsS2lm?=
 =?utf-8?B?QTNvTU1teENrN2Z1ZUpsYUxyaXM4REs1NTVsb3k4b3FRR1ZVVEl2TWp6S1gw?=
 =?utf-8?B?amRLU1JtVWNsVng3ZGQ4bE5Kb243blo5dXJHeW5uVENoSktCbUlXcDU1SDlk?=
 =?utf-8?B?ZTVtRUU3KytFeHpaTE9yL0Y1bm1Xd05XUlYzYWJwR3hCYUJnVXNLZTRKK2ts?=
 =?utf-8?B?aFVzNTVVTFF4MlRPUS80NkY5c0pkTW8rK0kwMFZLRkFwZzIyeS9pbGRuKzFW?=
 =?utf-8?B?TzVqTmZzVlpRSEFXV2lweW40UUV0MWpwYldCQllBcXpOaWp1SnFrdVlkSWRy?=
 =?utf-8?B?SWN6c2hMV2ZoMmJ2cGNJUDhUQW5EWjFEa0d0YnZtMExSQWhMOUhJdGlyQTNt?=
 =?utf-8?B?dWVCU1Z3ZDFHeklkejBpMDc3TXZtVDQ0NVZRUzdZTjRqeU43a3ZpbzR3ZFdq?=
 =?utf-8?B?RHF1M0ZRQUtDWnhzc2VTRjdVRU1mYUNvVnVPdkEzOHUvRy9kZU5mZjRmdjI0?=
 =?utf-8?B?OUEzQS9lWW5ZT0k3NzZHWDZGVkFadGVUQ1I4SDE4d2VuRHZVQzVLbjRGVDdI?=
 =?utf-8?B?VFpmVjdnelUycm16Tld3WmdEQVZlejhGblhWbFJSVkU5USs4TTEwdmxjdUQ2?=
 =?utf-8?B?QlEwYlZTTENZeGw3Ulpsa3NVRVdhMUNGWHlsTER1QlgxcEgvbWNQSVVzUFVq?=
 =?utf-8?B?TW5OelhyMEZYNE5la0x1VUlYb0Ixb3JQWVE4S0J3U3NpT0xraHJPbXBzQTNx?=
 =?utf-8?B?WjAwTUsxQi9Rczg1Sy9SdXV3bjNnMThya29zMENpUlFMd3l2RDNRekt6MkFo?=
 =?utf-8?B?ek9NdUMwanFrZHFjQVByRVZCZGRuWTFGaDA4b3RxRWV1U2dDTGo3YTFIcmhy?=
 =?utf-8?B?MzRJWnFnL3pvS2E4TC80WDlUK09IVC92Ky96TFVqZGxxZlNpTUFacHFadkVV?=
 =?utf-8?B?OEFKd1p6WDE5R3BCQ0NIN1JlODlVeFV5OUtlajYxNWJwZC9qSitQN2JqSUVS?=
 =?utf-8?B?QmViQUJNWjF0bjNTeSt4NW1iRGFmekYvSHZzU0pjeTVTeGFpK29SNnlpMTF4?=
 =?utf-8?B?WkNyMHlxTnNva1lhLzlxT2RtNG1LaXhnemg5UmJGbkpOVUMyeWQ4UTN4OUlu?=
 =?utf-8?B?eVh0cG9JTUJaaFBQdElSTHdVWkdOdXM4ZXFoM2RWN1lLdTRaTmdGakE0K012?=
 =?utf-8?B?enN3RGxqSUtaN3g3Z1YvTTFMWUdGbFVDUTFXaStXbnRsd05hdmExRUFveVcr?=
 =?utf-8?B?dThpK2UvNGo1a1drVzZGc09vVUkvcENhYzNkUGNyOEpkRmllcVN5NHJLN3lV?=
 =?utf-8?B?SkNqWjZWY2FyZWNnWDcrTHIvbjBia3k2S1hHOWlJYjVzYXMyRWdkRU1KU0Qv?=
 =?utf-8?B?UDkzeWRPSmg3YmJZUzRMQzB1cVVPYTIwQUxkUDhvamhDaFpPcENlaDNPMWQx?=
 =?utf-8?B?RS9BRFZ0UGh0VlY2cHN0RVNZVnBtdk8yanhQUW1pVjcxMU1lS2RXSloxSnkz?=
 =?utf-8?B?RDY4UDdFYW45Z3YxdHlYOEVBYkxYM3lUWHpqMkN3Q0RxOVlyQWpoVWF3azA5?=
 =?utf-8?B?N2JRUXVhT3RrRkN0RHVEcU9USU1lZUorVjQxc2pTbEhaZXNZdVRIRjFSQzZU?=
 =?utf-8?B?VTZjZEZ4MUxSalFmUXRCTmhVMS9kOFdWWDkzajB4eWhUYkI1YnFXOVdrd2lL?=
 =?utf-8?B?bWpXRmV1RDYrM21EOG9Dd2NuOWQ5Tjd3S1pyOXRXY25GdisyZHNRVjdBam84?=
 =?utf-8?B?bjY0Vk14S0Y0by9qNk5FZ3gyVGVxcVRkZG1WUzdSeURKd09KWnNBWjNNTk0z?=
 =?utf-8?Q?s58EqR2nNm5lSXaThJ083Pt/iymv/t6F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHVmVVI2K2ZBWXB3S2gwSHBXbHRER1Y5dkZDRFJ2c3VTK1JJQlhiMGtsUGk4?=
 =?utf-8?B?OS9rZHdSUXJnaThoWHgvcWJGR0NIcktGRll2TXJjbXA3VVhUVkNYSFZZR1Z6?=
 =?utf-8?B?WVlROEVLZzNtY2hBR1NGeGcrOWhOZ0hpa3ZtOUJBeHVaaXZ6VVpsRTRINFRn?=
 =?utf-8?B?YkM3WS9PWHVQWFBsOUtHdDkrT01rdC9TeEFaSktsWmtVaFpQVU51YnJReGZl?=
 =?utf-8?B?dG0vakF1YkMwcGJzMWNJcDA2eXR2T0c3MEJXYjFMQ0FRdmhZdW8rdVdSSU5G?=
 =?utf-8?B?NVpqR3h5R1AyZHUzNE1NMFM0YnJ4L1lNOWJRemNJa1N6VXhhMlpmWDRUTnFY?=
 =?utf-8?B?d0MvUGRneXpsMFQvcUpGdnNCTE44RGRyaG15TUNVZE9LUTl5SHFBOW1GdVFR?=
 =?utf-8?B?Z0ZwL1VNb2lEY1hoeUg5K294cURyWmg3VnkwTitURkVHUjlsNkg4VVRDS2xK?=
 =?utf-8?B?L3BJbEF2a09XK09KMC82U2hQRHZOMHhmeG1pem5QL3JpU3FLZjI5WTBzL2oy?=
 =?utf-8?B?RTdRdWdwZE8zUjFla0FkR0FybDFXOVk0U29lQlVaYS93N2prYllHZzhoNjJD?=
 =?utf-8?B?NklENThxdTBiVzBRQzhERG1iNjBwLzJiVHFLckhadmtIOFhmZmhhODBlRDN1?=
 =?utf-8?B?Q1N0cXp5ZzNqT3l5ZXhkY2l2MWw1YkZnNGtXMDlLbjl6Ulc5RnVyZlNwOWhB?=
 =?utf-8?B?Y0JOVzdyeEZWVDNXL25YL0R0cFhQcHdVSjZKclNabkE0Rk1PSmdnZWFSOUhS?=
 =?utf-8?B?OGhYZnEvYlA4OERHQ2E5TUtzR2lkNkZYRWx4UXZOK2NQZk9LcHIrMEFIVklJ?=
 =?utf-8?B?Z3l3bTU4eVVnR0ZZSWQ1eTRwOUFVTkZmUkpKcVJ0R3FScFE1RzdKTUdCSjhD?=
 =?utf-8?B?ZTV4U3Nkb0tlTGtDY1RBSE5EOUYvRHB2OWI5WmRrVGNUQ0liQVNuYXVObjNT?=
 =?utf-8?B?QUVyWkNJUlZKcVhwRXFHcUducTYvOXlNQTQ1OERhZlRiaDl0T1gzYU5XckNu?=
 =?utf-8?B?MlJaRkcyYTVTc2FlV2h3aUl6M1hIRFNxUG5OYlVvd2RCMjZGYWtQQVZUN1dt?=
 =?utf-8?B?Rjc5Zm1WUDFRckIvRzVsVVpUVStvWHFQUzdPVmRJWHFiK2dwenhRaGhRSnhJ?=
 =?utf-8?B?RVFHS0NNSEtaM05vRHAzQkEyRTFhOCtaYnhwWmNadkZZSU55MU51MjFzU1lm?=
 =?utf-8?B?a2xqemNlSE5OaGx6WG1kRHJKbUlINEVPa1ZxOVR6U0N6alJnMkIyMDhvdzRu?=
 =?utf-8?B?MHhINWxuTmplZlJ0dlQrZXVuUEdTVmxNazlNbWVBdXBDbC9EZ01nbkkzYzRQ?=
 =?utf-8?B?U05RRkRFaHlMOFE2Tk4wczhoT015ZXhHNmFhRXI2Q0hOeDAwcy8vREM2Z0ZJ?=
 =?utf-8?B?WitUbEpmMXArKzR6ZGlKb3Y4NndYNGowbmVTaUwzL3QyMnl3QldKNzVkb25M?=
 =?utf-8?B?bVZOZW5Ic0FEM1p3UFl2OGU3Qys4NWVEbzRpY3MzQkVjYThaQVpiV3dxT3NH?=
 =?utf-8?B?d0h5bmdYREFoWFQyRnV2Yi9CTmExK1hvZkQvaFJZdkZUOVVEK21VbXE1WnNG?=
 =?utf-8?B?Y25nTjAyZ1VVdTFadG1PdVNrQkEyOWlNcEkzZ0R3dFprR1BYa2s3V3JxWTZj?=
 =?utf-8?B?c25VcnMzM0o0cUlQQVd1SmEzN2tac1pSVmtkWEs2cjdaTlgzaXoyZkF0VlIv?=
 =?utf-8?B?Y3YwQXRjeitaWFpsYWJjV3hlUmhNMDFCWEVyb3AvNDN3endoMUJ6ZHVqdDFQ?=
 =?utf-8?B?Z1hUblB1ZHp2SWF3Q1ZmMGNydEs4dTBiNTh5VkxjbHhrTWZuT1Y3VDZlcG92?=
 =?utf-8?B?b1RERll0Vkt0QThlNlhEMWk4SFpCMmpyT1VjcnBrTVA4RDRNQzVJYTBkNU5r?=
 =?utf-8?B?ZW1IZDg5U3p2MytIcDhaVWxoTGZ4RkYvVm1tVURNNjFCaURtN3R2MDMxWW1X?=
 =?utf-8?B?ZzV4bEp5dEFBQUd4aExZbDZtOWlyckdDWmxjTmQxNUpRNTh0eWJtZ2dDblVI?=
 =?utf-8?B?R0Y3VUwzUkRnNXdpNUh1YWxvK29HSG9kdnFDWUNtK2VuT3J3L3VUMnZiVGgx?=
 =?utf-8?B?VU9xMUpuODNnMnd1V1NLdzlFSGFybWxnU04zUWI5VGE3cDA3RXdUNGYrYmpT?=
 =?utf-8?B?Rnk2WG1uVTQ1OENXalh5QTE1SnB0SlZFTXdyWnc4Sks3RFk1aDVxdXAvWXM2?=
 =?utf-8?B?VVE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a39be357-0c3d-48e7-1ef9-08de21a67e97
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 04:46:50.7361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVn3TLVs/KXL4hZf7QuxdAqvWWBGzLJU5JoE6qn90mXn5L/fuRnVM1OyyyYHEWzdrE3iRv+hUa6h2+bj0frhvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6175
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2216B4000A
X-Stat-Signature: y65tunnpu5gnkid9qt7pbnhehard63c1
X-Rspam-User: 
X-HE-Tag: 1762922816-961727
X-HE-Meta: U2FsdGVkX1/JsKsVV9ksz+d48CGzho+BgC3mX17uG/p4WhegG9T4g5ZVXcd8vuBYNgPWRZRJIJvkgMCEeQdfF320SID59Lcb1JjQjaVPsZd1EsAXP/orsfHsQ6JMKu5VF3SUTx7o2sO4KmVp2Cg2kj8Wf7pxyAu9stCd1w3VO3hbtOLAtVbJ6YqOHSTUtRl7LokClPImcphdZSeZhse3ocrxfc3GnUo84Q2oCwLpz1itmygYD/Ss+JQC4XD4NbTR+O7d8BHhB51L93QHJ1u3kUl8vsFgfPVIYjj4G3wcsXo8q5JHj036ZtJSZ9CqsYWP92Wy419FcybJdYsxLf5iykwnzK8TW6+EPmscnCCOw40rNSf+qHTLLCQ5hS66gWB4GT5kegLDFIYPa2JHmSkxxNdWwjaADlXB2GguZatidI3HcOTPxBcqUYpNNLB94ZEncHrqE7DuOS3cU2+qc7PlS+aUBmDd/EKBdx4JqnQS4e6GGMD4sWGLzTZEux99AIvcOHwSihqsUylStcrWx9K8fmzYnWI16WdWYsAbXS4fOqw+72Hn2MCGdTBWOC+zHolAx1henJTWxkWKil0Tm9B3Qo5XuPw4RalB7FmcQM/FZJYGr0usoN/swCwcYI8K63298Ho1k06XKDNxl6id5VV0qEHED/NVBGPVQ+TuoMyrPP2wiEZqMp5KiO8EUVC+exkG51VsJVL92iCQXdL1cNg0aTjP2Z3raK9Si01nuhrhVh5bHE4pGuvUj7VlQAq1WOw3KUQQlU7+ARXmdEk0+Ot7Ic3LFz+PWgErdFRAruo0ITSU1KOvCtH2GvO27CJnjZ9zQ7HuWiGg+gDlNvpxTeI+4qZ1uolKo3XV4wr2RXUKHbEmDQgQAy6SwswsreOYyYztP3l+TCsj9Rkdwq8Ws2CjAFoLbQcC3a7RdgC9SFFdzbVdRku4PrqkzrYnYXjmh8JeYBUxn6zaPaYEsTEm7A7
 IjGmxObB
 7CbPng65oZwV8y7f5fZs1kvO2zQRLeobCLB3hJJnxhG9rE5KxJLqFxgi5hDk6LZ6HvmjwZAl2gYQPEX8uKPoPtCybMtZc4QeIq3WxeT2EfK7vYBm2dO9/OhJ2Jkyd/eOaeA/GIqLW8qkcbbh0v2iwC6Uofioto5yhjAiGUHVvQNboL+4DRIamkN8KMpmgVCr5+bhe0O0wlm05VFqxRwBGn/MZ24cZ23toAq3ah+Q4sg58XxERivvbsX+ZmZPc+/Od0+wY3mOvyWFnRNAU6wHJtAjaF+Jq2tviu+NbGQ46ysoqsC45z6JJdOtDnag7QDctvolgVOBEZGg3MYWA37DpKU6aSxiZ373oKiBuM0B25Jm6vtflSg/InI1zyJ1VeDmi+/oakvJs+cVpMxysghRjt+QvYYg46cJnl8V3NT7Rd5HIlB8Q8c67rv6zaLHxynaiaBtomL65ICKAQsCwsAyB7lm8q+Ufs/lWyF3SmOEB4Bx+PLb67Txq06sXOHw0NsHM0gO0nFtz6kMrweLygWNLQ0MRyTAKXg2zJG8/sCnSc8CHsldOW2UfMbJZ685HNzC+usQFfkKQpvggXuKlbxxVUrW7Y2eZ4S/GQKDOE/Jq6T6Pn4kJ5oQ3p7RtXaQMZgE6oPnT05vlzPsK/MzsDD9HFbmRpt4qgjyQs/P/UwHTDKg4MTDYjHC1oi7our2h/omFeNwfqUiVtcLLRxPhqeGMjTaY+HekyW/L1a9ztH5chBZFrCTve3ME1A7RwSKVMvUIDhjnmg7dF9VYvepslQhGTeL+J80t9ZU4XtoArQ0LSfTyNE8upDUMWu5QNeaiTY6OgvtYqwPxLaJQLfAmLfUKAvZzsxy/La3PLKnOnRpY9C5BGdH2QaNpbYKuGA3o8i8zdt5yEE7nbCaMN1kf5MMik6za8J7uVifiPXCg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unmapped was added as a parameter to __folio_split() and related
call sites to support splitting of folios already in the midst
of a migration. This special case arose for device private folio
migration since during migration there could be a disconnect between
source and destination on the folio size.

Introduce split_unmapped_folio_to_order() to handle this special case.
This in turn removes the special casing introduced by the unmapped
parameter in __folio_split().

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h |   5 +-
 mm/huge_memory.c        | 135 ++++++++++++++++++++++++++++++++++------
 mm/migrate_device.c     |   3 +-
 3 files changed, 120 insertions(+), 23 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index e2e91aa1a042..9155e683c08a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -371,7 +371,8 @@ enum split_type {
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order, bool unmapped);
+		unsigned int new_order);
+int split_unmapped_folio_to_order(struct folio *folio, unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool folio_split_supported(struct folio *folio, unsigned int new_order,
@@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return __split_huge_page_to_list_to_order(page, list, new_order, false);
+	return __split_huge_page_to_list_to_order(page, list, new_order);
 }
 static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0184cd915f44..942bd8410c54 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3747,7 +3747,6 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
- * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -3763,7 +3762,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, enum split_type split_type, bool unmapped)
+		struct list_head *list, enum split_type split_type)
 {
 	struct deferred_split *ds_queue;
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3809,14 +3808,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		if (!unmapped) {
-			anon_vma = folio_get_anon_vma(folio);
-			if (!anon_vma) {
-				ret = -EBUSY;
-				goto out;
-			}
-			anon_vma_lock_write(anon_vma);
+		anon_vma = folio_get_anon_vma(folio);
+		if (!anon_vma) {
+			ret = -EBUSY;
+			goto out;
 		}
+		anon_vma_lock_write(anon_vma);
 		mapping = NULL;
 	} else {
 		unsigned int min_order;
@@ -3882,8 +3879,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	if (!unmapped)
-		unmap_folio(folio);
+	unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -3976,8 +3972,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
-			if (!unmapped)
-				lru_add_split_folio(folio, new_folio, lruvec, list);
+			lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
 			 * Anonymous folio with swap cache.
@@ -4033,9 +4028,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	local_irq_enable();
 
-	if (unmapped)
-		return ret;
-
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4079,6 +4071,111 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	return ret;
 }
 
+/*
+ * This function is a helper for splitting folios that have already been unmapped.
+ * The use case is that the device or the CPU can refuse to migrate THP pages in
+ * the middle of migration, due to allocation issues on either side
+ *
+ * The high level code is copied from __folio_split, since the pages are anonymous
+ * and are already isolated from the LRU, the code has been simplified to not
+ * burden __folio_split with unmapped sprinkled into the code.
+ *
+ * None of the split folios are unlocked
+ */
+int split_unmapped_folio_to_order(struct folio *folio, unsigned int new_order)
+{
+	int extra_pins;
+	int ret = 0;
+	struct folio *new_folio, *next;
+	struct folio *end_folio = folio_next(folio);
+	struct deferred_split *ds_queue;
+	int old_order = folio_order(folio);
+
+	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
+
+	if (!can_split_folio(folio, 1, &extra_pins)) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	local_irq_disable();
+	/* Prevent deferred_split_scan() touching ->_refcount */
+	ds_queue = folio_split_queue_lock(folio);
+	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+		int expected_refs;
+		struct swap_cluster_info *ci = NULL;
+
+		if (old_order > 1) {
+			if (!list_empty(&folio->_deferred_list)) {
+				ds_queue->split_queue_len--;
+				/*
+				 * Reinitialize page_deferred_list after
+				 * removing the page from the split_queue,
+				 * otherwise a subsequent split will see list
+				 * corruption when checking the
+				 * page_deferred_list.
+				 */
+				list_del_init(&folio->_deferred_list);
+			}
+			if (folio_test_partially_mapped(folio)) {
+				folio_clear_partially_mapped(folio);
+				mod_mthp_stat(old_order,
+					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+			}
+			/*
+			 * Reinitialize page_deferred_list after removing the
+			 * page from the split_queue, otherwise a subsequent
+			 * split will see list corruption when checking the
+			 * page_deferred_list.
+			 */
+			list_del_init(&folio->_deferred_list);
+		}
+		split_queue_unlock(ds_queue);
+
+		if (folio_test_swapcache(folio))
+			ci = swap_cluster_get_and_lock(folio);
+
+		ret = __split_unmapped_folio(folio, new_order, &folio->page,
+					     NULL, NULL, SPLIT_TYPE_UNIFORM);
+
+		/*
+		 * Unfreeze after-split folios
+		 */
+		for (new_folio = folio_next(folio); new_folio != end_folio;
+		     new_folio = next) {
+			next = folio_next(new_folio);
+
+			zone_device_private_split_cb(folio, new_folio);
+
+			expected_refs = folio_expected_ref_count(new_folio) + 1;
+			folio_ref_unfreeze(new_folio, expected_refs);
+			if (ci)
+				__swap_cache_replace_folio(ci, folio, new_folio);
+		}
+
+		zone_device_private_split_cb(folio, NULL);
+		/*
+		 * Unfreeze @folio only after all page cache entries, which
+		 * used to point to it, have been updated with new folios.
+		 * Otherwise, a parallel folio_try_get() can grab @folio
+		 * and its caller can see stale page cache entries.
+		 */
+		expected_refs = folio_expected_ref_count(folio) + 1;
+		folio_ref_unfreeze(folio, expected_refs);
+
+		if (ci)
+			swap_cluster_unlock(ci);
+	} else {
+		split_queue_unlock(ds_queue);
+		ret = -EAGAIN;
+	}
+	local_irq_enable();
+err:
+	return ret;
+}
+
 /*
  * This function splits a large folio into smaller folios of order @new_order.
  * @page can point to any page of the large folio to split. The split operation
@@ -4127,12 +4224,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order, bool unmapped)
+				     unsigned int new_order)
 {
 	struct folio *folio = page_folio(page);
 
 	return __folio_split(folio, new_order, &folio->page, page, list,
-			     SPLIT_TYPE_UNIFORM, unmapped);
+			     SPLIT_TYPE_UNIFORM);
 }
 
 /**
@@ -4163,7 +4260,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			     SPLIT_TYPE_NON_UNIFORM, false);
+			     SPLIT_TYPE_NON_UNIFORM);
 }
 
 int min_order_for_split(struct folio *folio)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c50abbd32f21..1abe71b0e77e 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -918,8 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
-	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
-							0, true);
+	ret = split_unmapped_folio_to_order(folio, 0);
 	if (ret)
 		return ret;
 	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
-- 
2.51.1


