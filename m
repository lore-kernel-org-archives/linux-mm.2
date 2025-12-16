Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259ADD609C3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 16:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E97F6B0005; Tue, 16 Dec 2025 11:20:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3975F6B0088; Tue, 16 Dec 2025 11:20:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2244C6B008A; Tue, 16 Dec 2025 11:20:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0766B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:20:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DC11C041E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:20:41 +0000 (UTC)
X-FDA: 84225847482.22.F5D525E
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013041.outbound.protection.outlook.com [40.93.201.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id B1C651A0017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:20:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jZYRYHrs;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.41 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765902038; a=rsa-sha256;
	cv=pass;
	b=tjdpJR0kw+aEQywrQ8FVS0ONkeqyTEr5FV+MIwBCWSPG2ikdrGd63aUuKFSD2MTVwOysbj
	DiArbxJFqXWWeoRpMGDKVTEffk37wdpZaR8lgMdAnNecxehKOBzYVfCTQBREMN6sWYlK9f
	YCW0lJnuog832wLc9M3tRsW2KCMevcg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jZYRYHrs;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.41 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765902038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59p77+vmmS/kKVdLYdnOZWQuBG9LD+Q6VdbgyXz3O0Y=;
	b=euPE3BTCuU8vL18e3e45zsNabNUbRo7Wp+Lw2rTwdc+uRW3UQjfjWyKuQkvidBBOlF0xeV
	xisprh7N8h29hxueuchTFKPeFzCb1iAXb3Lk/rY4D7aaxpduLQxKNoWXUxha3aKhBBSt1V
	w3B9wwmhydItCmL4CjNph9gRdG63qX8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ng5XkQY63LywPUgVw6QYtX5OsFKEJlTsfCzi01CTdj9InewZSXeN+libJtWBuNlETrxlxu7138X6u9F1GTrYcmmuZYR9MHuWoEj5SySvnDx61dgYVMYgOqg9JVf07FZAKY+68Rb1hhOAgzwkmMlvWlKaJMM70imOvZ63fMubdDEWH5E7D4uRg2hNbyIhXUE3jkwvbGow9h/AJr9ggpRpvS7GALJiroyrzhu6SaQj7dR60c5g9Qbt8jUwjGJpolX5vzkR6s3+koaUYV+erNFGU0QJ7vXlFCSGmHunP2LKwlVjRcaRFa8fVmU5jKEVebYIQ5GhDGYipcKI8esG+ZwykQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59p77+vmmS/kKVdLYdnOZWQuBG9LD+Q6VdbgyXz3O0Y=;
 b=xoxtbt4cEn3guiUFBDhwiMDj8kMs5+I3K2lbu3OgwTRlkyr7RW65NAJBAMQOkmnrvbZ5n9wYAZlhKn4G9+xdwu625m/FwlajhddShin0tb4I/xuubKEyd23SIv1Ppr5JZ2HdYcj34coZC9nxebyZUh2xrGZ/tXOjOE6wMMS0ZUaM+Nvi5NjVcodE8z7e9UBgLIJ7PzusuNftfG1kLtOesmqfBGoy5VoSBuAvgrCedy/RhiKk47J8MPu3hk8R+tyj3XvcCdu4sLn1BkD1qEu94IloWSx9Qi9kNBf99MlqjbwE52m+ZlgwKqtv5oKFv85dbQZcZlNfyR3UrUrR27s3mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59p77+vmmS/kKVdLYdnOZWQuBG9LD+Q6VdbgyXz3O0Y=;
 b=jZYRYHrsg4I/+ZSmVMPXoyqKPR3tAi382nFgG+M4KC1ZUsuPLbnrpfIBlcPiSpMacJJwxEX3yk8ja+l7La1UYjhsN2b2lNXG/m+wksmH96fjKL/JfZWvDVR6Q56/2ngYrKRnhTDivXP+6yBK6TLpWod04tdeLcb+P2KHnBq0dxY=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 16:20:35 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 16:20:35 +0000
Message-ID: <6b6a1b82-1ee4-46fe-a928-865d440d1457@amd.com>
Date: Tue, 16 Dec 2025 21:50:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/khugepaged: use enum scan_result for result
 variables
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-6-shivankg@amd.com>
 <D9E6B402-528B-46F2-B4B0-9CD9549A449F@nvidia.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <D9E6B402-528B-46F2-B4B0-9CD9549A449F@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0076.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26d::7) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|LV8PR12MB9715:EE_
X-MS-Office365-Filtering-Correlation-Id: f226c797-d7f5-4db4-b699-08de3cbf0a9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0syb00rUmtkNjVTbThNZnRHYUVKbkh6K2pEZ0hEY3ZyTjNJb0hqSEYzZEpk?=
 =?utf-8?B?OEcwdDdYQkpBd2tXRUtieUFJZ0tJUDFrdlRyeXlBU1JlcTRwQzNMSHhZcWtH?=
 =?utf-8?B?MkNCMHRRdzg1ZWJVcndpSCs3R0I3VmU5cUhPL1RVb0dMUHRxOHJENTlEWUZO?=
 =?utf-8?B?YzJvbXRQUm42WENRSjkxbENZSFgrUHl3SmpKbXZFdjBYNFl3K2x4OVFpT3J3?=
 =?utf-8?B?d2QrTlNqbmhrNkJUOE5RdXMrd3duWHMyazJuWXdTaW94VnVVR1VZVmZiY2FC?=
 =?utf-8?B?L1NLaFJQMy9UVXZZY0xxQktJM3UxbUM1bnRDejF3bDE4QndxaEFneHNSeE1N?=
 =?utf-8?B?bnNMM0VwV1ZPV1l3ZVEwWXVXK2o2aFZRZG5aVHlHQURhTmxIWm1TcVpQL29x?=
 =?utf-8?B?ZGptVCtyWW93VDBZbGlIckdNNlkyRzNpOXVTWHg3WlBLZ2VWWExvZmVqRHFx?=
 =?utf-8?B?amVrc1JPcGQzc1E1aHE4bGFxMHc0c25NRmRxc3kwVi9xd2VaL1VmZm1oc3li?=
 =?utf-8?B?aC9GVUFzR1VxS0h4bkVJblVKUmVoQXNqbC8xS0Rhek5oRkZRSjJ5MytaRUVH?=
 =?utf-8?B?UlBFRVVZK2N6QW5qNmNrKzdLampPWnlDYllFeEtMQnRleHoxZWd0R3ZWLy9o?=
 =?utf-8?B?RnVTdHhTRWJrcGtWZ0VVQ0dQRzJsTzk2U0JZQ2dRUXhzaFgrdlNDVDU0SFRk?=
 =?utf-8?B?Ymg2V3Z2d056WVBUaGpweDNvRXJhTkY3K1EwNlVBUVdaalZLUDdiU3BGWmNB?=
 =?utf-8?B?Q2EvVlhFZ1Zma3NFSGlTZ05EUnZTZUNBZWlXbUlVTm8xSDFkUmRIdzNIeDIx?=
 =?utf-8?B?aWVCejhpSEVrQnk4RXNyUG9qdHNKcER0TFQxR1pYZ3YxMFZoNVBuaGRkR0xq?=
 =?utf-8?B?L1ZmUzJsSWtCRWdYcjNHSGFwUFd6OHZ4ZDA4Rkl3WjNJT2d6SGc4SUc4QmxN?=
 =?utf-8?B?WkJGb3E2NFZFelpUNjFEOGlNRFBBQTFxRzRMd3NUZnZUaVd5Q0RNRGVLWVJT?=
 =?utf-8?B?QkhUWmxlclVVbFhNTi9JeUdEc2JJMFlOb1ZleGM2VDR1amN2UEgydUFRYi9F?=
 =?utf-8?B?a0ZOY1RwMWJIdy9UVUlObm82WGpmV0dWSG9za0daWVhlZDVFdHk5UVgwd2l4?=
 =?utf-8?B?QzhPN3FPMzJpWUh0ODkzMXRvSUJxZnUvWm5ZekcrQVdFRVNkME9UZmI1eE5q?=
 =?utf-8?B?MEYwUVZ3VDhiOFh3bkZubWlaSTU3K0pFN0E2Sy9iQnptSVZRcnpkMkt0cHdh?=
 =?utf-8?B?UWYyWlJpbTlFc2hrK2NNSU9aTkJ1Z1gwelY5M1FDa0Jlc3pralo1K24veks2?=
 =?utf-8?B?T1BPayt4cmFqK1krdThzYlFReURaLzB3TTFTeEt1ajAwMmZuZ2pNY2JtMm9Q?=
 =?utf-8?B?T2hrOFR4c3oyUjd0NytMT2Yvc0xPeDIzYTlFRklqR2pWMFdrbG1sMWJqN1Ry?=
 =?utf-8?B?OTd2a094bS9RUTBOdkxHY1hFVzI3UGladGNHRWoxOVAxbjZNbThMclFlZUxT?=
 =?utf-8?B?cGJSdU56SjM2eTlUN2tKTjF6SXEwSW5tRTEyWmlTbWlBaHViZ1dSS0RocWh3?=
 =?utf-8?B?elFTYTUwSmd4VzhZWTVsalBYcEJUaVdSV0Y2MEJUcDYyU1l4U091L0hPQndL?=
 =?utf-8?B?dGZLNFkxMS82OWthRk8rTEttYWZtcGZaYWxXVGlPNjI3WVV6anNqbmE2c2tP?=
 =?utf-8?B?dWFUaUNDWEYwMFBCZEpPVW1UZXR1ZG5OSU93cVovckdNc2V3SWVlSjMrRXoz?=
 =?utf-8?B?bi93TXRUN2M4S1ZsREtNL2dPTUVMYTcxOWxPbjJ4TXQwMm1rNVNxNFlVZ09m?=
 =?utf-8?B?YkNLd0pYdWlIQjkwd2ljd0o3d2RHNS9qajBxNG9ScFBPWFgxOG1BYitEMWlr?=
 =?utf-8?B?Z0JTeUR1U2t5T0ZhdHIzejJTT2QwL1d3NEtxUE0vZUVKVDFzVFBuMUgrSDJL?=
 =?utf-8?Q?9Doxj3bJ6h96YI8nTigCDPD9em2XcsKd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXRYeEhOSHpBa3lZWVVRNk5PRm1hd01lejMrMUlVU0VSNFJZUGU1Z3NhK0ZU?=
 =?utf-8?B?cmxuODVnQXI2N3F3cG94NXZ3bStLZlF4SXhZbVZMalhZc0ZsaUpFUzFJRUYz?=
 =?utf-8?B?MmpxSUFTYzNldWdPNFBRQ2F1ZjVoZlFnU0sySDR6QVFBSTVid1R3Q2liNGxX?=
 =?utf-8?B?bkk4bExkWFczSmwrZW4zTytiU1dXaFp2N3NEb2ZKVGNmQWhyVmduaDZsdW5B?=
 =?utf-8?B?YVc5TFc3dk1EUmFVNS9yOFJDZUMrekp6cHZNZUFLYmhGSHVoT1BLY3NFMnV3?=
 =?utf-8?B?NkljYytzZGMydUpHUEUrNHZxUWRibDBLK2YwZXZYeVJwanRib2NHSDN5NjM4?=
 =?utf-8?B?MWpJYlVsWUVGcU5WYStYT0Vnc2FnRElGa1I1R1dyekpPYnl2ZWlaYUlaU0Rj?=
 =?utf-8?B?VGFWamlVYWVBNGNqeTA4T3JoeXBENm13YlFuMzh2bEo1OFlYY0Q0UHpOcjVz?=
 =?utf-8?B?WDhhWWFucmpTNk1oZElpNjBIVXJsK1BkaG04V0xPeXA0b29kbCtvaWdJQ0Zy?=
 =?utf-8?B?a0oydEdMNkppL2R5TXhiVmhrQzNRbDJhV2tYd0gxTkNmejRtMjlOaXB1VXps?=
 =?utf-8?B?Z1BsZEQrV0YzUmRCUkF6bWRnMVIxT1pBYWw4UzV3SExoNmc5KzQzeEhDcks1?=
 =?utf-8?B?QWZreVBMR3lwRXpJTm1Sd042N0M5TlFwQmpkazFraE9XakdERWF0ZWNLL1M4?=
 =?utf-8?B?UGVjUjhrYkVZRXlUa3JnU0JWZ2hYMVRHOHQ3R0UyYVNWSXRZWXFicGp4L0NJ?=
 =?utf-8?B?aWtMeG41TndKa0FqSEt3TklnT203YUhET3hoZ3BJN2JMM1ducUpnYVI4NUY3?=
 =?utf-8?B?eFBiQk91RkJjREEvM0NRaCtkcFVCMTBieVZCSS9tUktIaG5VVEVLdWM1SUl3?=
 =?utf-8?B?OS9CZmIzd1ZUNCtxd3BGV0ZRdDZhanFaa1N4eHJ6aFBpa0U3Qk5iejEzWkpH?=
 =?utf-8?B?YkVhN1hOa29uVnJ4S0VlTzVRN3EwUkpRS1pHY1A0WWp4RWNLODY2bXQwbDdo?=
 =?utf-8?B?UjRnQ0Y3anpPVVgrR1M0QkFTM1ptNm9kYkJOdWFwZi9BMGxsWVByb3g1NHVE?=
 =?utf-8?B?ZStmWFJ2bE9hMEcxQjRGaXg1Y2tjOE4zVjdlbUg4MjI0TjZJNXVaWUJyenI0?=
 =?utf-8?B?VVJXa1d3TnNJTTloRjROa3lvTWtOeE5XUSswKy9hL1daQ01pRGlGd3R2U3dv?=
 =?utf-8?B?TW5xYS94ZGdtZWY2M0d3Z2F4aEc0ZmM4Qm85TExQd2EvQVNabHJ6aU1oY095?=
 =?utf-8?B?TGxGL1B5WkRhYkcvS3I4bkVRdFI4VndCV0dvbmlPTGpFNVZmOFIyT3MvRXJl?=
 =?utf-8?B?RlYxdXZ2QW5KTFNIYXF1V0l0Unk5azF5bm1SL2VVd2ZLdDFCdXRYbkJoNlB2?=
 =?utf-8?B?YVVTMFVqK2NyYU1zWkxnNXhHYVFYOWVwYVNxS0R0cDF0UURwZ1NLTlBFMmZQ?=
 =?utf-8?B?TjYySjlrbGpwRnVQOGQ5TVVha3hSbHUyeUdzc0JpUyt6VTgwZjlkMzhERFJJ?=
 =?utf-8?B?c3B1cDFxck90aEdGTEJzdEVhbDV5TFpmQk1HSC9jRnMzck1jQk91dVdwc2Rp?=
 =?utf-8?B?enJZOEZZL0JPQ0U3QkcrWjhyQU9nZlJhQzhPU2sxdUF4WTQ4ZWFJWkVRT2dJ?=
 =?utf-8?B?alhVa3FnaWUyK0VDM3VnbUE5ZGt0YVo0dFlFM0dibElFUkkvWWxIUWk2Vk9R?=
 =?utf-8?B?WnlPMWdpcWdHRDIzcXpnTTdST2l5ZFZTd1BybTdxRE5JY2xPKzVsVnRqb0JF?=
 =?utf-8?B?NFYxb2R1azUxVDRmWGRWNFpJMDg3YzZRb1h4ZlFsaXpCbzdVNkJJWjlHbnpH?=
 =?utf-8?B?N0JJZWFHT3ZRZGlseVNLcE04RTBZaTlSQ0tUcnp5ZzRySk5jR21Bd1pkOUlP?=
 =?utf-8?B?R3NIWlY2ZVdtdUEvZFhtM0diWElvdzZBaVZmQzBHd1E0dk5helpCRHlBOXdR?=
 =?utf-8?B?NHpPd1VkK09rbEx0dGgxTno2M20rSHliTFNLcnh1WlNIUEh1b241N1hHT29S?=
 =?utf-8?B?azQwTk91WkJ4aVYza1lsN1VVRE82a1QwdDdkZklobE94STRiL21pWE9UUTQ0?=
 =?utf-8?B?VXhiSVloSlpucGsrNWhXVldCV210R0FqK0ZYQkRPelJNRVhDL280MzU1MW1G?=
 =?utf-8?Q?buonXYM3B9H21rfBALSCuCxP6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f226c797-d7f5-4db4-b699-08de3cbf0a9b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 16:20:34.9527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVo6D9OwJQpqrU7rYHdOxfLQsAJVy7C/IIY7k8t8XuwiabzoPb8f/Ik0pT1bdHQDT+1VVtnlJQGOhxt+z30vSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9715
X-Rspamd-Queue-Id: B1C651A0017
X-Stat-Signature: 7midcjffext399ukkqz4kq4i494za13z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765902038-418087
X-HE-Meta: U2FsdGVkX1/Ik94kHJ2xbGiaEdiBsK7NqqO3aaEgIP/G7KRzdQpPNB8qxdyCCkbKqLCogdU2Ih6RvJ+ph0xB86CFpKR7gfkOlG5a9DnyL6rcVmVexdsswpJj9efPY3ebbQhmyjGWPd89zvyJs8PsGnRvRCE9HXs1errF8gWsMJdCHk2AtXjQGk5pkg6a2mO15RV6QCea4Gz9d/nz7jYcSC8j/WXN4FtQBUNd/GmXNS+cYAZ0YEy1JvfNmW7Nx8QAQIpoBZGe8Qdi8IiJGGoWnZnxMmpfVnp/Wjt4MTqMW16nW3Ou4LtvFHQbSpOpJlmpzijREVnURNlsepw61tktADFlFwmvR1Had5Q9kLj/YvXsN0JvfnbMQOmzUyxk5GQxKU65k8P2hJpR4/ElybCdajSghTgl+J07PnWky+lXOjKbrMP31xoBHNdfDl+ZiapjojYyL3ZQKRUzZC2Z/Wtpwc/Jfhbvq3VDf8wW/DqkL1EnOvrZP/UasThqHp8We8V8NGCwvTs/7MW70hw8u7EHVuIGJNZJzYMZWfmCZAbyDUqUMjdF3LZ8HhZB8zHgohprZsJkVKLZvlVBZ8XZopkrLi6rZyUoAUTSIRYD3zYUKXUAOVh5v8rwesQzfQ6mFmiaNPKLWNXPMYTmNioeHqhAOl4qTMIW5doGMnjq77uTfFt+BP+uBifPMecF4BhnidOgerYriXz2XQzc1T1B2MyvOrgeFUWkEE640/f5JYky9YfKxs26mv4sGJrYtOtFaNgz8C+Q0EgY5MRJUDfYiXde0lX5VCpRItu8ZiHa/4Jb30si2noUV1KIyyrSrGjqOEWeS3G+W1o/pAWt1ZtFgivb1ODQhxg/ZJyIPXwBXFXatWpQt00K1dzAz9yyFmCzTr8XzeSXcTFsoHzyF0ivgUBknj7JjCGs6tqL5ojFOg0Fbrx1p3FeLl8qUy5RgHzpPk2bEl9ElYn0F4lnbAfOYuH
 hl9d7l54
 4iqAwULb45GBUDRHAURsj4vi1wZtnyAdJGwhC8T/q9BCjWd8SqDPuZ6qYuzqym2YQ6P1rZKqRZQ88NpvXpwJiGiMGGWHbHQxtwsNKa4Jezc/NOrsJls02qbq5WIJg8egguuz2BypdZsfgPa6JyOmvsF4Y3q5fooew2Dj9+sEtQbh32JcZEaw99Z8PxFU0doPY4KAZX0f5AHnjdFZbl8U0BPG2XHAGdDSMNLM9StKXAuawEc2jDnvDy+UFHE7pKKLGMHvqsFLc3aYo2WqxaDx2KjrLQb1LgROzn+WuNIM+TAlKzAI9SnsN8fmjyrOfk1Subo3/TiRfisALCpKBcGEKDT4kvF/vuauFUJBbPvtwq1cNJg+w3oc0OGJEmr1ZgByvQNr+EnNxbeyOHVeqzlAZenPhkaipwL+wgglBejDr+9lvefAwpk9Rr/daBNTQG/XaAKEXbFILytUqR8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/16/2025 9:08 PM, Zi Yan wrote:
> On 16 Dec 2025, at 6:11, Shivank Garg wrote:
> 

>> @@ -547,7 +547,8 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> 
> The return type could be changed too.
> 
>>  	struct folio *folio = NULL;
>>  	unsigned long addr = start_addr;
>>  	pte_t *_pte;
>> -	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>> +	int none_or_zero = 0, shared = 0, referenced = 0;
>> +	enum scan_result result = SCAN_FAIL;
>>
>>  	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>>  	     _pte++, addr += PAGE_SIZE) {
>> @@ -786,7 +787,7 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
> 
> Ditto.
> 
>>  		struct list_head *compound_pagelist)
>>  {

>> -- 
> 
> In addition, the return types of find_pmd_or_thp_or_none(),
> hugepage_vma_revalidate(), alloc_charge_folio(), and check_pmd_state() need to be changed to enum scan_result too.
> 
Hi Zi,

Thanks for the review and suggestions.
I'll update the return types and send V2.

Thanks,
Shivank

