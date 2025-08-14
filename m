Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6187ECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02FF19001B1; Thu, 14 Aug 2025 13:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E3B900172; Thu, 14 Aug 2025 13:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CFB9001B1; Thu, 14 Aug 2025 13:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CED38900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:20:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 893BDBB07D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:20:25 +0000 (UTC)
X-FDA: 83776026810.19.2FE44F5
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id C32D41C000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:20:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lBWSIR1j;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.41 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755192022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mZyYO5B5ck7QWmRaU8t4xbWc323HTKB0CX0wd/hfLo=;
	b=goZrwp62peIXRaKUXgHY6giWcq78gDs+kZOKqXRPwXYhWV13nEmS/ktooaVRYtkBpg0I1g
	Dr1fVB0UjZZue01p4gOkqnod3JJkMWpA/WYbWPWDdUY/wijUG4WOXO7++8kDZCQ4g684Ig
	f7g3PMCOWsy7JcarTnpqQIDEX655Vgw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lBWSIR1j;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.41 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755192022; a=rsa-sha256;
	cv=pass;
	b=M0YhwD/GZDvsBtAvZaT3UovLYbi67etMWyFV6dFHNRRoygXfcspWIc3vZYvMzME9p3kcY0
	nBIIVh7yW0hc5im/R0H0z/zgsXaNhm6dMEr13xG9oT1CEK5kEm8Gxz9Fc7/XY05L1YebRE
	zPnsz3Bv5L/xMbR2AhYwfk/jO0YB10M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v+vxbuchkJkchbwTmVJNiVk+hRvlNHJr+t+bndHW3Favffgx1b9deTanFm5W0Hr2sGQAYBo1F+P65dhFXl21aIHuBFVmPmVaFCuK8xsoays5PdqpSb9KuhRWONpK9bfX4/lRAkMqeHNCgfMt2g2+KU1WUfQjDzHIf1/eCG/LiUEC/ohec/0L4yRcEcJ/+zzGM7PPTDeQDJXxqpw5MkWXvQFu4GhzelriZ5vgA2M7/WVBY6cUrHN5bXJ1p/u50qjK9gcNCeonCF6XP4WmIeyTnz8HX9ypr5y4BYjhEbEc/2xknziVJnWrEQurrg427vX+rhoMLvKSnn9oQmncPsD+bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mZyYO5B5ck7QWmRaU8t4xbWc323HTKB0CX0wd/hfLo=;
 b=Lze0DsY4bfL9VfXwFXkCZZYnAS2AlenQutBzwrU4FGlkKUiTThDXQA6SHuNdUS/mBHyQMJXPrHd2p3eCEahvMPO8pbIsrkDQE5roc4lxfAPJH6jgvneM3hNnnSycc0DVlgO82wxoTHVhiZnNgA9Il3agWvNurazjv8uFn8ZtfUrXi0eBSXgzhWY8DPQmD3xgxlYBNnZFwbD1+qqqJc01LVMo3FliPZNNVVEN435iXdURYoeyG2WgbFkQ91J766RjECFtwGv6MEuiBZV8sXZICoe04ltx/R046LOLHp2YPYVgUUH/zpzrottIz5s5F99QV/OGhAwwOD/OBCtoqpH1Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mZyYO5B5ck7QWmRaU8t4xbWc323HTKB0CX0wd/hfLo=;
 b=lBWSIR1jiTLR0RGjrYM9FoQ48EcmvlCm9lklGi57Oa6NIJw3rxoToLT1KemzaJW3IuRuIq06QP6ItFZ9wdMRIu/TS1HBmr0oPm6zg1oUSZBAblgosbQwA0oyARmAAgeA21PlDkTw4WpXXoyP3mx0dsc2dVgjjhLnACxs9DOcdLzT2XmKjJonq9oGqyjxBglQVyfUxk1Zxr0HwboHU6QDvAqxmwJCps/rvDOm7aN7H9CmeW/3YUlM1NwCrPCMKOMYw/yy97im3u5G07TAeXnhrv0hAP8/rxADayccW2oV+ZngfthCU7URL/EgAFPlG5NX75K0r9QlgSz6abf4RMKHyQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH0PR12MB8531.namprd12.prod.outlook.com (2603:10b6:610:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 17:20:20 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 17:20:20 +0000
Date: Thu, 14 Aug 2025 14:20:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>,
	Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
Message-ID: <20250814172018.GJ802098@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
 <20250814124041.GD699432@nvidia.com>
 <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
 <20250814130403.GF699432@nvidia.com>
 <67b6e041-4bea-485d-a881-cc674d719685@redhat.com>
 <20250814141136.GG802098@nvidia.com>
 <c7bbbbc8-b9fc-40f5-b86f-e43b9a85aaef@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7bbbbc8-b9fc-40f5-b86f-e43b9a85aaef@redhat.com>
X-ClientProxiedBy: YT3PR01CA0053.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH0PR12MB8531:EE_
X-MS-Office365-Filtering-Correlation-Id: f3aa84fd-7186-4e87-d407-08dddb56d840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2tEMDFNcGQvbFBYMmZ5MERtNklRcFBuUHhKeWVidXZGU21tci9zVUhEZS9L?=
 =?utf-8?B?cUdqb0FUQURWZkMyZ21WS3ZZU1c5Z29LbHpMUUJaVW8vMXlYZ1VxREloWk1O?=
 =?utf-8?B?L2hiYXNkL2lSMlJURDdDckJqcnE3WUJzclAxQ0tSNVdaL3dzSTd4cEM0T0Q4?=
 =?utf-8?B?Y3oxU3ZMeldOK0lsMFF2ZXMwUWJmR3RROEpTQ1NSaVlHcG4ralZLZjR2Rk5H?=
 =?utf-8?B?VjZhY0k3ZTE0MVQvZzlVQ25NM0JOOHhDTU5XOTYxUXk1U3lXSzJwdE9EWEhE?=
 =?utf-8?B?QkdiRWhiQVNhWHUvL1NCb3lQQklrTzBFNkZPZmlTMDRsRW9NSVY5ZUQzZk10?=
 =?utf-8?B?Qk03MWFZM01xdStGOERsZDlrOTdwenNJRnpVWmp5eUtmS0NZMGp0eGhRekg5?=
 =?utf-8?B?STc5dnVPQmhvRWRQU2RKUFhUNHlzVTNiakdMZTlPWWFUUm1FZkZXMXIxZnFS?=
 =?utf-8?B?aXh2SEhua2ZZNlpDRTNiOXZOQUh5aXpFUUc3YlBOYXBXZHpRb1RVcjJpTnhF?=
 =?utf-8?B?SmU1ZW5wdFhMa21FZFZBazQraVZmWVJ3aGJMOFFlZ0JpSVlNU3AzczAvNElP?=
 =?utf-8?B?ZUlXbGcyZWpmQ1VSOWV5ZkZmdTRVOUpCVUcxQTJqYlI3cFdsS3pYeDhlTEFr?=
 =?utf-8?B?WjVqY1gyYTNrVjJhL2dXZFRaWldaSGhRN3NBVVZHeFg1REV2dkM3enZITFA1?=
 =?utf-8?B?YjFoR3pwaGM5aUUxMG9JeUNlcUY2ajRoekI1NitvV2EwZzlYU3IzWGI2N3VQ?=
 =?utf-8?B?aG9QbVpYY0tXWVFCVFJPSDBLWEZuc0N0dkloZktKZ28zYTNVazQzY0MwTkdF?=
 =?utf-8?B?cG1mOEpmakJSQndGN3c0R1VjY1h2Nm9YN0t1K01rQXJQSUhDSnQwTUlhZ3I5?=
 =?utf-8?B?UklIYkpsQjVtRzRmbE94QzV6blliMEgra01MQWJjeHY0aUF2SXNqaFNuajcw?=
 =?utf-8?B?cnRTMWF0VW8xRlBlRDdRa2NjRjhHOGtmKzdlTTNLRVFlcllmS1AwTEJEbk5p?=
 =?utf-8?B?a0pnamVUeXFIVmlRaDU2ZklZVUxjUnVpSjFpMDFMVGlZUVhqa20vbER5Q2V1?=
 =?utf-8?B?aHVFMDdBWUQ0NWRVT3A3WWt2L3c0eDdqN3hkbERxdDRydUlCeUJuWSs3SHdh?=
 =?utf-8?B?M0xJa280R1JsUWdQOGhpNG5WMXg4SkdPSnY0ZnFucW9aVHN4NlhRaHljZDBL?=
 =?utf-8?B?Mkh4K0dnZ0V6OU9BYzN5a0NpVEtvNmkxSTd1ZjBUdzViV1NscmV5S254cFI5?=
 =?utf-8?B?QWl4UVZXcFZmZ25DQmtwYmFsZWpKNkVjNW40dFUvK1pmZ3A2VG93dE4xdCtU?=
 =?utf-8?B?TkozZHN0WFhQMHppMExrUGR3MHlYaThUTHJCbC9TUWRpUkN5Q3ZNWVduUDUw?=
 =?utf-8?B?cmpHalA3ZGJEWWJ0QnVtNkhqTFFOTEwxVWZHd2dORi9PczhUaVRqUkR2akZT?=
 =?utf-8?B?SEhTNHlWN1VsV09vK2VNc1JlellQQ3kxRXllM0hyam1tVjJYMzZSWVd0VTdF?=
 =?utf-8?B?OTI4cGF0WkpvMTlJT0VWWWd1OVB3aWVrakZQZm50RDdLdWZhZ0hObGp5cGVI?=
 =?utf-8?B?Z3R6QVZjZTFJY2U0bUw1dFBwSXJCdFBETXc4dnR6SDFDMGp1d0N6QlgrU0dv?=
 =?utf-8?B?amMrTzk3dHhua2ZrWEpBNHZsdXp1aVVlbEM3bEp6SzBSYkhWWXJFNC9zYTcy?=
 =?utf-8?B?cHFFWVNWNmF0bU0vV1p2NVBWTWwvL3VZd09FUGFSVmVlRE9wUDJvOUtEMzcw?=
 =?utf-8?B?bGFpaEZnMC9xTlVyVmJ3SWNrSjByb2pVOUtjYlBQSlpWRlJhZzdiMFdYd3hU?=
 =?utf-8?B?ZDJ3ZHU0Vm9oS2FickdUbzl4VHV6Z25BTlhWVWxjRTBOZG1Zam16NzBvcG9l?=
 =?utf-8?B?NnlqNC9ZWjJrRm4zd3UwUldQUTBPYWtTRWNqdmJZTzhIeHArSlRjbjBQUU5q?=
 =?utf-8?Q?Y/B1669hA7c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHo0MlJMWjBUU3hHaUVhRURtV2ZJS0pHWWFNVTlQTXR4dTBSYzJjeGFOaFJE?=
 =?utf-8?B?MTVOQlhlNklOb3VSRGdieFpUYjVOeVZnRGFScGdoTHFjVThpRjBJNWFYamQr?=
 =?utf-8?B?VExXZDEvNUpNRXBxRnFiZVViQVgrNkx2Ykc3OVprc1k5bHE2KzBTSGMzdXBt?=
 =?utf-8?B?KzVlL0l0OHN5Unl6SGkrMCtSTWV3dzBUNGp2YjRXV0ZENTRJczh2V0pHOWRz?=
 =?utf-8?B?dy9YYmNsRm1ZRE16cjdsY1ZUaHVYU2RYZ04yN2IxelI1Y3NSM2IvUFdnUlBr?=
 =?utf-8?B?UHBUWUpIc3J2eDMwRVBCYUtzeE1OdWxjR2lkdVR5dmVYekttZG9la0gvbkZ6?=
 =?utf-8?B?NVM0eWpOb2JTZytqdjZEVHRLY1B1c1JOQjFBQmk4clRsOFBaMmZwazlUNkR4?=
 =?utf-8?B?bEhlWmdxWXN2ZHRzZUlVY3Z4b2twUm5jYUJJMjR3UUdqbFVJQnV4SEJ6MTZG?=
 =?utf-8?B?cHJqMDdwVjlsTGZZOGtOME1qNi9Cc1VUVXRoZEk4SzFsV1E1UFFzL1Rxa25K?=
 =?utf-8?B?THR0LzBZTUZsbk9QWkttVXJsSzRMWFluZjlUM1dmMGlXWXY3MmpUZW5YcnJz?=
 =?utf-8?B?NmpudjNPTnIyaEtKcHNyTnozNjluZnZxNnFmRFVadlN2TGp0UlFNSEErdGM4?=
 =?utf-8?B?N094S01neVJnNTNVbk5WdE5pdFJVVGZUQzJpcWtsamgwcGM2SlpkYWFOL3ha?=
 =?utf-8?B?RW8ydVNjVEJKais3TjdjVHBSL3dlUVFCNjB4RHlKUFZxanhuUjBrMjRzd1ZN?=
 =?utf-8?B?OVYxaFRvV1VuR0RSVnM3N2hTRXNCK3ljSnMzeS9MUzFFVmc2b2ZqUWNPU1hw?=
 =?utf-8?B?YURLYld4eE1OeDM1Y3NQV3Exc25pbmFSNTJRNVg1N05hLzZtcHdhVWJOazVJ?=
 =?utf-8?B?K3lGR0R6UmhwaGJrK1dGdzhLWHVia1BVeHJWdXBwWU1WaEtaRnlIaGZ2b2xC?=
 =?utf-8?B?RnFFVGZoVzdPUWs0SDVFQmlybWZ5VU9OTXpaSEQwbmJ6L0Q1R2Erd2k5NEtr?=
 =?utf-8?B?TGhBVnhaTW1lZ1RhVG5yU3A2SWU2TGRuUVMvd2ZUVk9hbktxTTl5K01FajJ5?=
 =?utf-8?B?Q3BjYmdRTGw4aEdJZ3BQRjNKaXRyWjAzano0ZXZraDVJZTV2TTVEazZuajAy?=
 =?utf-8?B?L2kyamVsbCt3alFxbWpsbThoNEhxWWd6OE13TEhiRlJReERha3QwcElFNTJi?=
 =?utf-8?B?c1FvRGN5MXBIR2g4TGNxYlI2MklPY3Q4ZnRyMDBpNE9FYUhxNTlUaDlnbkxw?=
 =?utf-8?B?VkZhcHAvTWVaczl1emdDTmhwTkRuN0lHejgzUE9NK0xBZkZyZUgxVkNTUHd6?=
 =?utf-8?B?Nm92a1FBOVlqazZXV0R3VHl6a2x3NmRteElXOEhoQkh6eG93aExCOGFJM0d5?=
 =?utf-8?B?ejJuS053d2I4dFN0dVdaaFlpK3dIS2xCZEpoazN2SjRvcEdoNGVxWWpxL2p2?=
 =?utf-8?B?MWVMRlh5ZnNHUEw4S2I2MWpNelFqdnBuVjFsaEh5eDNmTzRFc29NVGhGL25E?=
 =?utf-8?B?cmVhUkg3WFlCUnlKWnp3UXVOYlE2Y0h6ZFlwSU0rK0FYbDE2SVRmclFnZjVT?=
 =?utf-8?B?c1NwYmNDa0Q0aXBMc25BM0RhQ3VyaXM5cFdQOXp1TmsvM1N3bUg4RU40THBV?=
 =?utf-8?B?bW0yRkNqT0puNTR3Rm5ESnlBeG5pdmVOa1o4RkhjYS9oNUxzMUhyVTF3SGsz?=
 =?utf-8?B?NHVPbTcvdnhncjFxd1EzK01IeG1lZ2lsdDNScm9vOXc0TFlmR0RHNnJWZ0VP?=
 =?utf-8?B?dnVUVkorZkVWZUVOdUIzQURpcnFXT09qMDFaZHhnZStERGlGTER3Z2pPQlNr?=
 =?utf-8?B?emNVYkM0cHFFZ0NscnZMaDRYM0VudlN6M05uVDltRDZSeGx2bjRNVldnNWlV?=
 =?utf-8?B?OUlXZkFzZW1EY3g4aTJSZmhmbUp4MkpZMFJJSXlZWTg1RjVUV0w1eXBHS2xB?=
 =?utf-8?B?MEN0b0tZT25DMksxOWRxcmhqOXhEWlBxZWQrQmxmd0xIQTFNdmFqbS9icHZG?=
 =?utf-8?B?OXAvOEFDSFlpekxBVVJoWHlURmpkcnlyaUZWdEdIZ0gyM0p5RFRDbW42SzVr?=
 =?utf-8?B?dWQ3WTFYWE12dndUNHJMcEViVWt4VVlZMlY2T2NnWFRjZDNKaDFQU3FLZlZx?=
 =?utf-8?Q?c6tk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3aa84fd-7186-4e87-d407-08dddb56d840
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 17:20:20.0243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u4aLi+3a7o/ONQ+WEBjnwRTKmPBJ4ArZy5iz4LuCURIeTjKASo/wkcTfvusGLLrY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8531
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C32D41C000B
X-Stat-Signature: a73hceord7msjzk4h7txio8dwgjq977e
X-Rspam-User: 
X-HE-Tag: 1755192022-720908
X-HE-Meta: U2FsdGVkX18ErMccmEVONF2oYbfbJ4JyxqUhTeqBNp5YGhjJ1oJBATNjWlP9s6PEwoUjGTNr3Rc5o7pK8mnx8WD5pJOkhwthHbq5IagdFi3QGJ17CPFSyLHSYN8Leh5Xsu1t2tpKX4XuK4dJeFFJrpdt+PmM8XCbwt3AD1g0SXf7koMOCgBBCS1hNCY5j3QkyAnuUQaEXB+WOlQm8kT7Gbw2sqz5nv+bZXaIcLjspIcd1jOcN16V9eCRobSQPTvj4W5zK6MZZjBUi6fEYvtO9uGDdGxbm9uV0Uq+QkSNUMMZ5ri35SrdXnyzDhZgcsCm5flymupafI22bDEzRbPqP7c7lzEo/aBNPtGByDia1X1bC8LlahSL6TQXMwAKPbMha7+QyOWoSKYOydaF5a8WB5tJkNO7tOU0kKHmjz/GyYzO7puPDkh+p5fbs2WVJYXLCTfQsBsgjZaWii2lgqH73o2AiFkIWyxrMZvnUhdR455p8w9ZUmKR0h65Faftns6YxFNuqMIK9iws8oKoNyiPLPAFMrxemgwLDVgThwd2kmFMhd/LSuWPoNbS18DSLZDGbA2J9uaSu43z317kNXkoZKiosZ2hnvqDTlRPKP6yi0lb+ZFERpTZ9yaGslWU7F275/slEQHZXfLMbyxRk+cTEaix6phpOMMAwGn3ddzRjzeAKBFgliCdBH28xQb5shBmPyxb1HCvxDmaKjJC0VwVrI8dPCR9r4mkiLga3rtnt1peMMEBAP7diRlRsW9woEgNn1X+kmXJOZFV3sBZgcUI83dwHp0uaCX2sQzuqh7O78QZTL/4vuLArMnNxBAtfBraLCNf9xYNlSQC4qJCvHH5rcwCOtsyEEIWBFhnegAYfS0XwwdYn9ciGuKHyDyA4nZ/LwOoGNdGZDeOnZJihhuYChLzxS0dJAdiKmkbBVA6JB8mgtrhY72H8dJGv/SzYG8x2PM+fOws2zmMgDkk/hb
 0ilcQN1h
 8jyNScSa5X7Oi1Vq5pGmGbveuJOY9xo+qQWMM7PnpbA6/MRXRpEPXhht21f8J44AToe/A3aeaGGziqzOktxQNnqtRf+sBLE4wU6xzzj1OVoA+GLgNZWzWKzRe2/vuH1CNjoX8Do6FMrWYYPfiEfiUJoWr+kYg/h5WWupww+FmBt1Xn8MieDlc7lnBq/MVCawim9bq4jeFWa/q99raX9QicYgwNS3qTIspa3/D/Z6l9KyTAfDoj/rL1veXglnvGI7IYteeqeVqq3L4cu6ZkklJRroYYd/LQexYGOUSl5o31LU2iJQ29s+xzh2H15ceTdRvUcHyJTN0IDlneR1dTXTbyXPLet3QeX6SWEs2sy1Q6d8MOM15v9oYRsozaxbVdQBH2Q7aZNjWClhDGnuDMxJUhyLr+eZIi2TFh4+LJkORroRjWnxrOc1942bZEhYubeMm7lSbiBcxduRFMG8J2MnrGt9VH+cGGuB0ZDsUJgO6G2VsBChJXC7QYtPMjEDr7g8kWIJVpO6Qntxir0v1JdpBEz+N2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 08:00:01PM +0300, Mika Penttilä wrote:
> as well as hmm test module with :
> 
>          * Ignore invalidation callbacks for device private pages since
>          * the invalidation is handled as part of the migration process.
>          */
>         if (range->event == MMU_NOTIFY_MIGRATE &&
>             range->owner == dmirror->mdevice)
>                 return true;

If I recall this was about a very specific case where migration does a
number of invalidations and some of the earlier ones are known to be
redundant in this specific case. Redundant means it can be ignored
without causing an inconsistency.

Alistair would know, but I assumed this works OK because the above
invalidation doesn't actually go on to free any pages but keeps them
around until a later invalidation?

This is nothing like what your case is talking about.

Jason

