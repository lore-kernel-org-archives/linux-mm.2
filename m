Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A433D6E2AD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02AD6B0095; Thu, 18 Dec 2025 10:53:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9CD6B0098; Thu, 18 Dec 2025 10:53:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81B16B009B; Thu, 18 Dec 2025 10:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3E9E6B0095
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:53:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2323816014A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:53:01 +0000 (UTC)
X-FDA: 84233035362.07.AD372BE
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013071.outbound.protection.outlook.com [40.93.196.71])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F674A0016
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:52:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GpRvCtYT;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766073178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJumiU3u41xG20BwOCt0OCAVufoQTpUFxprLzHlxZeg=;
	b=w/Zmnh2nblr3DREzH0Q1oOmWNEiITSNsdgfoui4YXIXFVkqxiRLIpOyhVL1Ul37OsTxcR9
	62CG6Yj6pZT/ZA8WHLTfxXKK/JVAJ2adtAhr3jWSyJkvLb9xSpr+g/aQmt+CkPkI/8nW8r
	Lg2ZCU2l+for+lJmq1Eh0h0MqYGUy/0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GpRvCtYT;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766073178; a=rsa-sha256;
	cv=pass;
	b=NIH6lUmEo4TfWpf5EgRhfbYs9otXRowKv4q2LeoN5TzC34a4BZt/DU8Hh8CVNdlNdg74ks
	zMhPEpfjtG8amishJ1wIw1sEiAaTjJ+X7yFpNxrCv9F4ugzfC8CpSrkSP7EvojIFuEzVTX
	56j3pXli8mUfreS5Af4KlfKvqDmpEF0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yex//+DZGcDIAMgrfg1rY55oIc9tbaAK2fM9WaEAo3EzyFjobialZXs6qWvjyqP8it9UVROucA06KsqTKShvvmDHBd+VnglzLUwlcP/9JTRdwnBCcQy5TbDaCKMBr/0qcoBB/UQOgeY9IiPmAs8AN0e/NA9mkjeEJcwTa0ckiLb/Rnw7t00UZyzGT/o+leanXzuedaQApdk6++3KLletCbeEBfplIXPS9lRBQyqB+q8vEDgt0cPZQegGUua0EZHcV3MXL81WJodpoKgtFHmiBXbYCCII1A+17Lm3MbjeA/uCI5CMJu6EYHAmvrMxwVuCOesHOKjRNYyi19QnU9y0xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJumiU3u41xG20BwOCt0OCAVufoQTpUFxprLzHlxZeg=;
 b=e/2HoN5gjl4ouZ3SZGKMpIgBZ8WreWUgVs06orTNVeHYtrzZ5GU0o84Jg3qG52QoUCuBLOrD4HKcrTVmDpIoijlARPWx7KmHgNeyYe0O0i686XdvA/kGiLDsSjbfoL29OgHaMrkRdejdNXnsOvgKlPVk0Hn5+NZQ1GK5NxhIixrW9Bwhqchn9Fig9pCWu+I4Xeqazk1Ok12sZd7Q4RVEYx7nuMHgVxNvACTu5htIoZI86C2XbiV5PnH8pea6X0jujEHSclOtP+2cj3JNWIcqxaaW9ll3dg90Snx1z/lWmOqpUcN1kbgDvC17hnVHQNYJ/jncx65PIvhqCGZtwop9+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJumiU3u41xG20BwOCt0OCAVufoQTpUFxprLzHlxZeg=;
 b=GpRvCtYTjr+Xbp55Pq2n3uaLpD/NvAsN65kJK6KWRI8zOexG0kOWdPEkIK4JrldNCv3YksR3RD9d175jsVtOIzjgxHVx54WC5TzeAA+a6PVCnVIDXJVn1qitawUX2R7lKCcfyzLqTzDWFM8T+JX/+onVkekFoSGJj60NkqkuvuMXe+lonWW8860FS2EoQpbckN7agbR0/cFZ8vAfWbUn+wRzVFcHsvF5Uxd/jgZpQNCDVL1UhLnP5+Bc5XQOP0Byvt+qdCUDUT5/sDHnrSGFc6zbUM0efkWw8SlQZ1JaQ1POG/0UPPYNQsQiaJa/plhlI8oR17En8wqgfFOm2lTIZw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 15:52:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 15:52:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Thu, 18 Dec 2025 10:52:50 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <0168824D-37E8-4E22-AAF5-43DDB38F0FED@nvidia.com>
In-Reply-To: <6e7df7a8-aaf4-4960-82be-dea118c5955c@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
 <4B10600F-A837-4FCA-808D-6F8637B073F7@nvidia.com>
 <0eb081b8-3982-48aa-a9ba-9cdde702b4df@huawei.com>
 <A276ED1B-89C8-45A0-8DA9-9D5CA1D8E2FF@nvidia.com>
 <6e7df7a8-aaf4-4960-82be-dea118c5955c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0329.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5825:EE_
X-MS-Office365-Filtering-Correlation-Id: 174ef180-5645-4480-f2a7-08de3e4d80f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHNjNmE5TDN3RVZXdUY0TDUwNnk1STRYbTdmWWRManZHbW5PMStqS2N5OW5r?=
 =?utf-8?B?TDFPSUh6ZjhsZm1LbnlYSHpEWW05NG01dnBqYXBpU3lGZzFLREZoZGNUanBz?=
 =?utf-8?B?ejkzVzRxZk1ZT1JsZFk4TGpZSFZTWEhlbzBRZUkzL0VrV2xpQzNENmFXd2w5?=
 =?utf-8?B?cXM1YUdnc3hzYUprZkZmMUI4bnpDZkRONm9OK1BJR1JnbVB0bnhSZTc5ZW1s?=
 =?utf-8?B?NDdjWHZHZFpNWG1XSjM0WFg2MUtEdGcyV2gwYzdQNmRVTXFLb3FUdy9JUTZm?=
 =?utf-8?B?UmJJbWlpSVpPb1dZbDNUZGFzMkVYakpDVWpaZWQyVTIxQlR1STkrQ1ZQNUVp?=
 =?utf-8?B?WVlrNU5YYWdvSDg3aGs1b1BBanBGVG5pL0xraGRNYXkybGM0ODNCQVRZUFV6?=
 =?utf-8?B?RDZpMWxXRUtXMzRpQXZQTEpsQ3ZzZUJqUWt0cXh0SDFtOFZZbVh5S21CQlEr?=
 =?utf-8?B?Z1dJZWlUZ0FtbklaR3p3WnBrVzUrSHBCcWZnUXVhaDZkaFVOcmpyUEJJWEtz?=
 =?utf-8?B?TEM4b2hCdTFMclZmV2drL2tVbitrbVFpbFo3UTYvYVE2WmF3SmljMWJ6aEF1?=
 =?utf-8?B?eXJtTEJtbWVvanNaZ21ucGUzOEQ4QlFKYmVkc2RKNXZ1bzU2RytmQmxVaVRa?=
 =?utf-8?B?RFZvdlhGVWYzK09Id1VVVGZjSVV4eGZIOUNrWVI1Um1XVWtsb0E0b1FhaUc4?=
 =?utf-8?B?MkFIUUJFcmhMSDdjdFNMWXJpdEtYbTN5ZjN4dEQwUjkvTWlwVllSQ0xMbTFv?=
 =?utf-8?B?S2RwOGIwUmErb0pZRFM4RFR2QkpZbEQyMnBhM212YUkxQk1BaTFQZnJ6OVpM?=
 =?utf-8?B?S3JRSGhWamY1T1RkSHNtSzZRcWRrUVRHRzZKTzY5RnN0Qk1RNjRTUWxXZE9j?=
 =?utf-8?B?OUN0N1JlTGlNdDdaN3lON2J3a25acENYMGZiTkxXVjFwcVUxRWtyejNveVg2?=
 =?utf-8?B?ckdnbjh4RDlOaGJtdXk4YitIalFlRjV3RGJRc09YUlpVclBvcjdscGUvN1c1?=
 =?utf-8?B?SUovb3FsU3JFOFJmbzRuMzRxN3FhUS92WFVaVlcvQXR0QXRMOGNMZTRNMWFy?=
 =?utf-8?B?bUllY2NFV3dOZWhjRUY0WExLQis3WGozRkYvM0dCc05VWVplNEluVlpIUFBr?=
 =?utf-8?B?eWpkODhKbHdxeUx0MWNHOVhYUmxSMDVlYUJTd2hwcGRhRm13ckhXTXhIRFA1?=
 =?utf-8?B?cGxCZUxwQnB0OUR0d1ByL3Nkb0FDOW96ckFsdlNxY0ZCTTVDUi9Mc1NUY3NN?=
 =?utf-8?B?ZjZsaW9tMlJlZXMzYUZUZmlCa1FCSmhRWXVMb05hV2E1TnJSdFZ5MHFoTjNz?=
 =?utf-8?B?TlJ3Q0ZBM1NZOHEvcUpFRzU1RDEzdExhM2hOK3IwR2sxNWxFaG9LMDI0MkNm?=
 =?utf-8?B?NVVHdE56eTczSzhQbjR0TGFGeWJudUI3QXc1STBVQ21HbUtEZ0t1ZG9LOHdy?=
 =?utf-8?B?RitvUk1YUm5qYStsSUh4ckswbytscEIxcjNFMitlSUw1L2d6bDdocHAxU3o3?=
 =?utf-8?B?THhyOE9MUXVlWGltTmh3b2svNldwSlN3L2pjNFd4WmVERkJidDJDRmhaZmUz?=
 =?utf-8?B?V0hBSUZBTERLTU1saXBwNHFQeWRiaVh2M0Z5WVNpQ05vcU5nMnJKdUM2NnBx?=
 =?utf-8?B?Q0V5S1NpM3BrSHZNamdUVXFxZURpbVRvTzExbHRRdWJkSFhVWllIZUMyNTVp?=
 =?utf-8?B?YUVDdkVKcU0weitGTEs4ajVzbFB1K3JHdEhrL2hUTndseUp3WG9QU2VyNXVI?=
 =?utf-8?B?d3dQNi9vbWh4S3JIVGZ6L1pmVzBkSFZ0cndxSFRueStCek1xRjNzdEp3dXpx?=
 =?utf-8?B?OU1WbE1pYU1QbWpBNnNSbTBteVY0SVBQalhPUG5YRkd5TFE5c3lFb3FxcnBF?=
 =?utf-8?B?elAxUHRLUkJrWnVQaWJwWjFyZW81SSsrdGdjOFVuUW0wSWg5WWM2NzR1dzRU?=
 =?utf-8?Q?9z09GS0wzNWcPH2cSooTKUOmnmUrEBg9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzkxZU9SWGVIUkZsWEo1ZkhNclpnWWIyUHF5c3V6TFUwdTBVVCtLMllSMjRO?=
 =?utf-8?B?ck9WK1BNUzRXNkphZkgzZHNNeFdXMXZ5Z2pVSUpWT25UTHNWMzliVk0zRkVW?=
 =?utf-8?B?SUdFRWpTQ3VDQ3dtWEJkWk1MVm5lMTFUdGVka0NpRHhEWWpDNk0zWkRUSy9s?=
 =?utf-8?B?YS9xanJUTGdDMm9RTmxpaW1WRGdBcFZDbW1HeTdZV2tUaVduQ0VPZ1JDWTRh?=
 =?utf-8?B?S1lySEkxVWFsSFBwcWlFdkZxc3FNQ3BDd2pxT0dtT0hvQkcra01FbmpWWE53?=
 =?utf-8?B?L3E4bjFTUm00UkoxdjhtT01KZHNwVTJCZHExSURzWDA3bVdST0dOS1Y3WDdk?=
 =?utf-8?B?VWtmSU90amlxN0NoUGh3b254K2VrUEovODNycTB1dWNZeHQ4Rkh4RzFKU0JK?=
 =?utf-8?B?Z3JaUy9oMjhXR3FmNEJib1FJZmw1cWZoOTVQUTdkMTJoRzFTUHcrMlV5djBN?=
 =?utf-8?B?bWZtMlZKcnY2SnRqcFJNUHZuNjVpY29rT1dqU21xYUM2WU9YQUJ4eEZFTVB5?=
 =?utf-8?B?Y0hhVzByeEV3NllhZFlFUWhPMFBPbFBBZ0w5aitHK2xFSk8waFByZTlwRnVs?=
 =?utf-8?B?MVZvZEZGN1A1disyL1UyTlYxWCtGWHFWR2tzeXZnY2taS1R6TGN4MDZQN3k2?=
 =?utf-8?B?dWdTa2oxOGRBbkxOcExVcnQyVStvaGZEN0lNSC9ER0tWZE5rdDYzSFN1WVNq?=
 =?utf-8?B?b0tYNjMralJxNWE1R2hPbXhZNDQ1VjR0WkdneE5NdFNzdkNUMkRwVGNuNkZv?=
 =?utf-8?B?L3NLVGVjS01QRURpdXZCQWdzekxzQzc4bWRlM2NOejJ2QlZmREthNExnMVhv?=
 =?utf-8?B?NE1CM2pHOU1GMXFOdkJJWFpINTRFa1FBNk84MmZBZjNmZk5FeW1qblhzdmRh?=
 =?utf-8?B?RFlqK2FrbVpVM01ldnVLSzk2ZDBpZWNjNDdXV09iVWpMTkVsalhUR25mYy9h?=
 =?utf-8?B?TUZ1NzNhNVNVQ2NVdkpNUHJOQjN0ejVrZUtBTUpDUnVWMmpadGNWVUR2NHJ5?=
 =?utf-8?B?clBZWW9KNUdXcEo3ZWt3ZE40QWIyaWVoRy85Mjc1VFQvc2ZzR0pKbGZkS3Vn?=
 =?utf-8?B?UzNyUnRWRmNsbUdxaGxQZmdkYjVwbmkrQVhkRFJoSW1Dem83dnpoc2d0VTdl?=
 =?utf-8?B?VnBnRFJoRlZ5aW1tN2xuTWRWNHJJTkEwbW5EOUtvVUh0cnFmemljU2FQRTNN?=
 =?utf-8?B?d3ZzNThoYk1RUm12ZGx3bFYvbFUzMzdsWlhtVmp1a3hhSWRKcFB2V3NCeUNW?=
 =?utf-8?B?NGpVS0tFUi9vVjM2NWxLNVcwbWg0cHR4MEJ4REFjMHRxU3NiSXR0QTNIWnJ4?=
 =?utf-8?B?U3hCRXMyTWNQa3BrenlBR3V0a0ZEVC9QdG9ha2Ruek9SUEsrK3NncTh0cERj?=
 =?utf-8?B?NkdxSjYyT1NCNTN4Q0FiZ3p5alkrZjVSU2syWVVRdmpVYi9yNENjb0pTd2xr?=
 =?utf-8?B?QmIzWUJmV2k5VFYxMGE0czdmRng4dkEwV2lKdVdMemJlQVE0TnlXdjQzRE04?=
 =?utf-8?B?elllWlNWU0NXK1NoNmtLYUJZbE1DWVNUOTRZWHZxb1VFSGlHQ1djOFJsZmdC?=
 =?utf-8?B?OXcweE9xL0hBRHhrM1dTY2xxTWkzQUxxWW15cGc3ZmNiNkFvdGtTdDlrS2J3?=
 =?utf-8?B?RE9QbEpZNkZOOTM2T3pQcVpWWWxLMktkekJLRW9SVU42SHoybVhNU1ZVK0J1?=
 =?utf-8?B?eU5sOE5PS0ZQZnh2SExMQXRpSm5zV0Vtd1NxWjlZY01Sd2p5ZUg0RCtacmZN?=
 =?utf-8?B?cHk5K3pESG8yYzhyWmF3d0c5ckZKMUlBV1pxeWFCS3hFN01QeWZoVW1WdXo4?=
 =?utf-8?B?V1FFLzN4cWZJMVBIV1FTSW9Gb0dWUFJEYVNnWGR1TU5pa1NGNmJmVmsvZlhB?=
 =?utf-8?B?SCtqNlZ0ckk5ZnFjWHA2TGFDZ0t3SHNZNUJwQXNPenlBU3VPQ1AxTGdPWDdD?=
 =?utf-8?B?bnBEL0xqQUVxQzZWQ3JVTGl6NDV2SmdOZFFPRGhpNE5vdlJoc3ZuZWJVOERE?=
 =?utf-8?B?Wi9ZSUQwcWJIOXdGa1NEYTkrTVRxNlkwWlZ6OXR4RXNVQ3JFd0VnZmlqRkVy?=
 =?utf-8?B?bWpTUkNBWEV0cmNEZ0tObWcxZE9sQ2pBYTd0Z2RNbTFvM2haMlFLaFJyWUJo?=
 =?utf-8?Q?a9OgxAb5CqOmFs+GnwpSwgdac?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 174ef180-5645-4480-f2a7-08de3e4d80f9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 15:52:53.1687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NBiqyvH+0AEKxGVFKEWBsuFKjzOJ3Pk59Qy08e9vizoOcMDhz6KCjq4d1bIVy08j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825
X-Rspamd-Server: rspam02
X-Stat-Signature: mkijgtkbpg3yrsx7yatjbj6d6f4cjoib
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F674A0016
X-HE-Tag: 1766073178-14729
X-HE-Meta: U2FsdGVkX19AGkEXuLLQ77ZSC0Z/a2fFSKhr342c2xU41RfAKjepBs8OjqQpr+B+AHcpOcoT9u4+SuChI8sdH61rAxxoJQym9yolpFelzDb7/B4DvQlAn9+5pkjALPbxDCukmEZyBJ6VnSW4V1fNXPg2SU6421QhzIV0+tLTh8Rs/xp2FKKl1MfmkIGEiTGImePsI4pxK74og9YYeSUtpjJczGmMyAXhh3c+fiHFIwiDcFQZ++L57ww8IBGPP+rd2hM+ifUelV255LsYjGD3BSSxWuTyfqtOCt00g5rckdc91EqmjDOBokf3cksvECG+VF6AaUOqNF58lxenifCGl2ycPRYtRJup2tfRBW16idK5GOw+S2K7Yv2iWDPtXfbcSKwZHEZygm28M+x0qeP+ZS4383Fo8FdlglLUM5SoQxbOkX0SbL/lmCbqyIkFo6m93f6kD7w7JhvvSDJz94wl8Ix/Uky0JwxALflQExloY6xkB3MjbiTwNC3DJn2ToYVlLEwz0t0+V1A2qwMotzknpcRfieagj4oLQYuVVuW5Tn6GIpH6Xw4paHFk66Tvp5q4U+LBNPho0vMEDD197DLMrPVOHf0L21HmJXOeDqfpw62w6tZjbqq3aWz5XRBn+EPctFO4CaqH2/cNTguEM+NzlGo9n+05N6hc7A+RROKx3M+AEQFLiTY4a4tKMa58+dDK4QwoM6SWG93E6wbBylcWzpWVNIILoDqogcd8raMuNUCIbOeNS5vOIrBiJbgSYbehsv+Wlnx+ZXFCq6crqqEw1nHNT96koxjCrubD5cQnGB+3OuMg//ZB682dqtFp8u8WghGWVeWdFAnktNWuwd5paJeOBpuDF6oShIgJkUNXxBoJtOlzvKzUoNBckzyp40e422JOjVgZeur+OKbWivB+MWerLgxzy75ZOZHQakQ0CZt75D3BdrdWgoCqb+GBS/YsCaIcZvpEG8QYBB3MJ1S
 ElsiWBDg
 m5h7GNIC3Lx0yc7/nhhAnsPn7XN/JdhUInGwdgGsKa6lEYZsITqNhSQWM1KGFyztMpT2sFeEobW8/CsXaUZjMaW1mm9+2lCFzLMAMzuNvTw4UcU2wUKC2zNLim2M8/qtGxh8C4tG/6vIF6jmnVVrtWy9jKVi7h8K/075AK7VGgeKid4Ni+KSqAnNUPbiWSwHp6wTxAw8qGmF6fNTrleIvp4zqAFtYpV+q/q1iDXz6y6BqfDqnalylBIfC6DVptrDXXw139kPSisHWbHEJvAImSSuVwNCogVXilBgPVEW91eLsjKGQT27jreE6QqysBneq6AHj1BqNDvBAVCu9W+BiKUdt4QupMF9r7M+pzOEUAqhuid04BPBmkYujW490jcSMAlO3d4RtjksBgOfXcpJyk2d7sfZO70IY7KXyDQGRQwo9oJE1QspnUljnBQWLb48ziLHySdg6ZUQkx0yd66QiVGl4v3wwWCwx+M9E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Dec 2025, at 7:54, Kefeng Wang wrote:

> On 2025/12/18 3:38, Zi Yan wrote:
>> On 17 Dec 2025, at 3:02, Kefeng Wang wrote:
>>
>>> On 2025/12/17 2:40, Zi Yan wrote:
>>>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>>>
>>>>> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
>>>>> incrementing their refcount, then convert hugetlb cma to use the
>>>>> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
>>>>> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
>>>>> into mm/internal.h since no outside user.
>>>>>
>>>>> The set_pages_refcounted() is only called to set non-compound pages
>>>>> after above changes, so remove the processing about PageHead.
>>>>>
>>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>> ---
>>>>>    include/linux/cma.h | 26 ++++++------------------
>>>>>    mm/cma.c            | 48 +++++++++++++++++++++++++----------------=
----
>>>>>    mm/hugetlb_cma.c    | 24 +++++++++++++----------
>>>>>    mm/internal.h       | 10 +++++-----
>>>>>    4 files changed, 52 insertions(+), 56 deletions(-)
>>>>>
>>>
>>> ...
>>>
>>>>>    static bool __cma_release(struct cma *cma, const struct page *page=
s,
>>>>> -			  unsigned long count, bool compound)
>>>>> +			  unsigned long count, bool frozen)
>>>>>    {
>>>>>    	unsigned long pfn, end;
>>>>>    	int r;
>>>>> @@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, const =
struct page *pages,
>>>>>    		return false;
>>>>>    	}
>>>>>
>>>>> -	if (compound)
>>>>> -		__free_pages((struct page *)pages, compound_order(pages));
>>>>> +	if (frozen)
>>>>> +		free_contig_frozen_range(pfn, count);
>>>>>    	else
>>>>>    		free_contig_range(pfn, count);
>>>>
>>>> Can we get rid of free_contig_range() branch by making cma_release() p=
ut
>>>> each page=E2=80=99s refcount? Then, __cma_relase() becomes cma_release=
_frozen()
>>>> and the release pattern matches allocation pattern:
>>>> 1. cma_alloc() calls cma_alloc_frozen() and manipulates page refcount.
>>>> 2. cma_release() manipulates page refcount and calls cma_release_froze=
n().
>>>>
>>>
>>> Have considered similar things before, but we need manipulates page
>>> refcount only find the correct cma memrange from cma/pages, it seems
>>> that no big improvement, any more comments?
>>>
>>> 1) for cma_release:
>>>     a. cma find memrange
>>>     b. manipulates page refcount when cmr found
>>>     c. free page and release cma resource
>>> 2) for cma_release_frozen
>>>     a. cma find memrange
>>>     b. free page and release cma resource whne cmr found
>>
>> Right, I think it makes code simpler.
>>
>> Basically add a helper function:
>> struct cma_memrange* find_cma_memrange(struct cma *cma,
>> 		const struct page *pages, unsigned long count);
>>
>> Then
>>
>> __cma_release_frozen()
>> {
>> 	free_contig_frozen_range(pfn, count);
>> 	cma_clear_bitmap(cma, cmr, pfn, count);
>> 	cma_sysfs_account_release_pages(cma, count);
>> 	trace_cma_release(cma->name, pfn, pages, count);
>> }
>>
>>
>> cma_release()
>> {
>> 	cmr =3D find_cma_memrange();
>>
>> 	if (!cmr)
>> 		return false;
>> =09
>> 	for (; count--; pages++)
>> 		VM_WARN_ON(!put_page_testzero(pages);
>>
>> 	__cma_release_frozen();
>> }
>>
>> cma_release_frozen()
>> {
>> 	cmr =3D find_cma_memrange();
>>
>> 	if (!cmr)
>> 		return false;
>>
>> 	__cma_release_frozen();
>>
>> }
>>
>> Let me know your thoughts.
>
> Yes, this is exactly what I described above that needs to be done, but I
> think it will add more codes :)
>
> Our goal is that convert all cma_{alloc,release} caller to
> cma_frozen_{alloc,release}, and complete remove free_contig_range in cma,=
 Maybe no changes? But if you prefer above way, I can also update
> it.

If the goal is to replace all cma_{alloc,release}() calls with the frozen v=
ersion,
there is no need to make the change as I suggested. Are you planning to sen=
d
another patchset to do the replacement after this one?

Best Regards,
Yan, Zi

