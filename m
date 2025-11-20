Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344E7CF64BD
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688A56B0024; Thu, 20 Nov 2025 00:46:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639466B002D; Thu, 20 Nov 2025 00:46:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9996B002E; Thu, 20 Nov 2025 00:46:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36F846B0024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:46:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE064B9FEE
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:46:29 +0000 (UTC)
X-FDA: 84129900498.27.E14EDB2
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id D42A040012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:46:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lqAfp+KR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.65 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763617587; a=rsa-sha256;
	cv=pass;
	b=pI+HeBRE49JV3Lv9GfuknEiqg/4ZpsD6rje0F/kI8XyI0JXWxu5ZpjM/numf0QCCNk7d9X
	uOKTxi1tV9Dejy9oCFK7GzphBYbfeKHSxm9dN8lCdQzCBr0EL6tPq971s0Fr6MCrhV5xKT
	yJB1fW8slM2/Qn2ol0EbO/oh3eV/Ih0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lqAfp+KR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.65 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763617587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRIXAuTAfiXQgkRHPVb1acoMjcILmb6GQqNwewcGTfE=;
	b=fNfADj5dxl4B7oHe37NKoWXC2oy5lC7jNnzjvqfkQPqSjXRb7LuO9+r1s52Uht6lFEyDH9
	7LibcOss5y2A1SuU7ogj2+atsiihAa8GK3boNPbIuvrnen2SpXN7L86f6KO5zr/V8/E2OV
	MdUKNCX9mxOS6IUG3aokTN7b1lcsZ1g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b6LPkSmWXE9vnb8RuYlIJhEMF261e/d3G4+lorKQ8oUH72XOMAh9XEUXiflPzA1qdXv6NnqP2giaPHudsheeecLM76DHSalCO2GnVDN+6Bqhl/fbpFRv1cx1bSOzx26DOsBAZJQYrIQQ3t1VHITtVxIO5k+hDmHblbqTeq6OTSGhDo6rwxDSkRAu/iPdUuqfFOtqtQwIrKoXip8RR+t0weDQvfRB3YVAFCtqO/26IY7NOVOlyeOEKvFbDCeY8IK+nKaazGs1G74fAheEZDi2YP/qmfDq+l0GP/0nsfqtsJr14nCFin1v6d0FAE6yUdclaFX1VhL5X/HZBG8Txr5/6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cRIXAuTAfiXQgkRHPVb1acoMjcILmb6GQqNwewcGTfE=;
 b=eMmDr0wHhN/h5DfZdTgQqej4Wp5v9JlZIAfCKRATIqFSuKeyHGaer6cjsDjOnKVHmYEfvl5cYaZssDZ9NaS2LOurt2mOeQxs/4RTDYxbIo2XdWELC/Ypc6ojG3iAdANWP7bRmenkeEeVUbKz69G0FZeU/NpUV0ag3/iUpHMtRN+n3b6v+b95KY4w3avkxmSn0vbgyjZO6KK3058K007PY/0nZYr1FWq8NDpWQmUg1I+wkQZ4dgxLewRsTD/BA7FGkW0pKxGIY0uBCOv7rVkzyoY73mGv+QA3J/Oo7lCKCS6ulAwgJkBUnNDySnclE8qCdg5crX5yzHvNofR2Bv8NfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRIXAuTAfiXQgkRHPVb1acoMjcILmb6GQqNwewcGTfE=;
 b=lqAfp+KR8CI/4UK5kZaV42ugDjvZq1scdWMuRvWPK4/09IycN1XmHrftMRZTzH0wTmtNzf/v3xxVDlRz2yKx6BJxEysvl23UQ0cBVghXcigx1SYs/BK/tGyKC2pqMj7KSGGCyhnu/hKqXchgyNrRQWRCJq5iQXs7ANSMSA0j3Myw1RkrOa7i6XCyOg7zhyL7fS103M1bHj+agQKE5ow/j1UFu2YOiwdfn4R0jskjPa1z445d3BxRs4SCjL+QNghKKhXtOkw+4c5ixCju89dwAveWiouJzaPaTmdmaSehFo92eb5ZB2TaWsyJLVSn37xqPzmWJhpH3i9wv5BqFKNZiw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS2PR12MB9568.namprd12.prod.outlook.com (2603:10b6:8:27c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 05:46:22 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 05:46:21 +0000
Message-ID: <273f3d36-a36f-46f4-a311-b764c52e7b40@nvidia.com>
Date: Thu, 20 Nov 2025 16:46:14 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [v7 00/16] mm: support device-private THP
From: Balbir Singh <balbirs@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
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
 Francois Dugast <francois.dugast@intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251008201740.d9507f4807a73058d4da23a8@linux-foundation.org>
 <a5992f11-5841-4bbf-b190-b5df41b68b0c@nvidia.com>
 <aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
 <20251111154326.bc48466a6962fbbffd8ebdd0@linux-foundation.org>
 <7a0f2704-80b5-4cbd-8f3b-ac03692eefd3@nvidia.com>
 <aR5/uUFboeeSwN0z@lstrano-desk.jf.intel.com>
 <7ecb3faa-8bc7-4eb1-9342-404a9ff52b97@nvidia.com>
 <24d8d39b-5ebe-4f29-93ff-3f7ca2a9b1cc@nvidia.com>
 <aR6HtvxhmVxUvd+h@lstrano-desk.jf.intel.com>
 <e8efd187-237c-47c7-ab99-33183e0988df@nvidia.com>
Content-Language: en-US
In-Reply-To: <e8efd187-237c-47c7-ab99-33183e0988df@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0232.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::27) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS2PR12MB9568:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ba98ad5-54ec-437e-3743-08de27f8225b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qzhpb3hGOXdFKzBtaE53T2RGMXdtdkFGWDZOREk5ZEUwcGxZaG00Y2loc0hB?=
 =?utf-8?B?L0sycGpmSWVtOUYzTmhRekVkamoydy9KbExROXRmR2gwaUlHUC9nR2M2WHpX?=
 =?utf-8?B?WG5uZi9hN1phZk1kdG1YMjNON2o2S2d0d090OUppZlpkdVZvLzVDaXk0MEtv?=
 =?utf-8?B?b0U4UFpPZW05UnBrdXFya25KSGo5Z3NyWGhuelNnTUhzT2tHZXlub1o5bzJh?=
 =?utf-8?B?WTRCZTZvZW42ZmlQallGZGJxWWFQOVVzTmdGVGtCTVFZNDNRMU0vNm16K1hl?=
 =?utf-8?B?VGFPanJFb0FsK0pWbGFubmJXNDJyMTBKeWxwdytETUM1VmxRbFl3MXE2RUd2?=
 =?utf-8?B?MFpsUWJnbEkxWGwwek5RakJsOEdabHRqN1h1Z1hCRGNYNWRDVW1oZkJQeGNl?=
 =?utf-8?B?cHBTeVRSVVI5NmVKbUdUVmZxRzR1SFBlaDN1SC9tZ3JPS0ZISis3cTdzMFBh?=
 =?utf-8?B?Y0d5cjZZRWE3N2JqV2VyUTZzZ2UybDJlcE5Ib21CNG9TTnlyN0hmUSt0clJi?=
 =?utf-8?B?MitTTjFCZ0ZSTkliNnFRQnMwWUdLTmtXZyt2ZmtYdHFwWnYxVWZWeEFCS2hs?=
 =?utf-8?B?Y1crSHM4MExtTzhBcCtzbjNMdDZNNEJxUW9vSSt1L3JvTWpNYWdHUzdkbDVa?=
 =?utf-8?B?WkFWY2lsMnFNNHFlWUJiWlJWT2FTc214UDNleDhyUG4rcXl5TStOUlV0NGZs?=
 =?utf-8?B?RVZoQ2JqUFM3WVJSOHUveTJtcm9GNzhWdWo4UllpSnlhdDhscWFxNVppcmJN?=
 =?utf-8?B?ZjFnV2dVOVNNb0VaOGtWR3BWejdPcXhEYXZpOEViWlJqN0xPUlpEVHYzbVYw?=
 =?utf-8?B?SHJ2RGJPTzQ3SzZDcmZtemJ0V29TSjV1U0ZyNjAxaDZteXdnRzRmZGxnWFhz?=
 =?utf-8?B?MFpoSW9CSGhTM3B6b09YbU1VRy8zZGhzVm8xZ2xHR2x4NmlrZk9CTTBjMG8y?=
 =?utf-8?B?WjFEMWZvcGJPVElpbmxjWTRoZkNLWkdsWG5zRzl1ekg0ZUdLS1FjUS9zeGVX?=
 =?utf-8?B?QmlUeWxrWEp3MnFxNEJzdVhHVit3WGx3Y053UFpIQS9yZ01pd2FnL0U5RHEy?=
 =?utf-8?B?Tm53QlBGRXNMRFFkdDE2d1JBMUFJbnUxUU5lOXZReEJPSE16eTVOMUNOa3lE?=
 =?utf-8?B?ZFc4R3V3eUZWMytjTTNWOXZ2UUloakRWSGFOaDZ3RTZucVlQbEdrMlBWS1Ay?=
 =?utf-8?B?YzU0VDdVa0xDOXdxRUd4ZjBZS21QcnRHVTVUZ0JacjBiM0k1WXVKOVNsbFg0?=
 =?utf-8?B?TGN5dVBvTElnblljbmxGQnJ3bDErVGgwNVNSY1B0bUJST0EwSGFjcHZrcTlC?=
 =?utf-8?B?Y1pzMElwR3ExQXk2d1p6N2ZrUCtIS3dXWm9ISUc1SE5JeTE2M25WSDE3d0w0?=
 =?utf-8?B?VW1jL1VMNUFhM0NqWWY1WWVKZkFiLzBKRmtqMG5mM2d5NGJxelI4UGVRTjhM?=
 =?utf-8?B?UjZncUdsbWdxMnNEdk14Z0E5aUtXNXN5YU80KzkwUmtJdnQ1eUgrRFMrUWc4?=
 =?utf-8?B?ZlVtMDFxQW5FTjEwMUlzL1BOOThkYkFSWUV6blMwS0NMMFphaDBpS0tlck1Y?=
 =?utf-8?B?UWtNM0VyQXFaSVlqeE0vTndZRTgwMzR0Y0duZ2Q0c1lhc3o3RjlZZFJVSUJ0?=
 =?utf-8?B?MzBCbGE3RjRrQVpxaHRGd2N4Y0ZMZU41bDJEQ0hvUGJrVTEvMjYweHhUUXBm?=
 =?utf-8?B?cGVmdmpURTRneEU3Z2Z4dVN1a0xKb1JsRXBwWGxMSlhoZm1oRmJHUUlKajBI?=
 =?utf-8?B?TGY0TGRscXdCeVFPa2ZUV0pxYWdmYWNDYkNSZFZLRFduSkFzTko3SDdabUZH?=
 =?utf-8?B?Z1NMUWUxQTBLZUU2dUljZDFZaGt5cmZwNW1LaVNqb1hnMktibm5PRkRtUjZD?=
 =?utf-8?B?QkZwWUhFQ2dBU1lRYWJnQW85WVZqRU5CSTJKL0J0VVQzMnhHNEM4VVRlZWc5?=
 =?utf-8?Q?esl7kvCN0MZsYVRFj8TuAxCJ0eGD/e+U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ME5PMUJkQW5FWlZCS0V0N1h4b3dUbUpJTm5SVTcrYWRKdDk2QmJUOUxlQjF3?=
 =?utf-8?B?ZUt0Z0lKSEJ5aXlPUG1YQTQrdWt0dlBSMDdWQlVDMFYybUd4aEVOTkw1T0Zp?=
 =?utf-8?B?MUVidXdOc0N6dUIrcGlmd0JSVUErTzZaZEVRS2tKd0Z2ck5PekJ6VW5YSFJ2?=
 =?utf-8?B?eStXNDNDNVhzNTR0S3lBdC9ndFJESDd2RUc1bjg4RU1CTnVaVm5Bb3FFZnN6?=
 =?utf-8?B?bDh4RUhxK2xhTzJiQkxGejZadlMzelVuQnZEVjZZbTJnV3pDYVFhai9uTnBL?=
 =?utf-8?B?VXBEWVpuOUJKNzFHZXZDREh6RTRiMXBNODFoa3dpcUlaVkVJWDNsRHBEMyth?=
 =?utf-8?B?dGNuY3pLSWtBa083U1NQWVp2ZWV5ZXR1Ykgxdi9YZHA3NGxUN2JpNjdacjVQ?=
 =?utf-8?B?clBIODhQV0xvR3QweS9XQkxtNEZLZ25xN0xSM0g3VlNnTmJQeGd0VkxSUzJV?=
 =?utf-8?B?N2pleUdTMHQ5dkYveGhINElnOElqR0MyTjVsV3ZhU05XdnVzYWgxVXNyVWQr?=
 =?utf-8?B?bXlYUk5KVjJDK3FYbE9nczJENjhhZUhXZHNWTGwyajNIVlNSbVZQTmNUZ2o0?=
 =?utf-8?B?ekN5TXluTVdodGJkRFNhWWNUa3hSS1dyenRUYlF2VHN4alNMVEo1K1NNNnRT?=
 =?utf-8?B?VGtIV2d4dXF1VXl2VmhzN0hkbHBmcU1zQUpvQXRjdE1pYVprRnMzaVVPQU91?=
 =?utf-8?B?MGdUN0tjeWpacmlMNHpxcnJUREpJTWo5RSszYnNyMm1pLzRaQWtNWmhWdXRT?=
 =?utf-8?B?dkpPVkY2QURhNTFPbUU4UHdkc2lUcUJ3VSs5QmgrZGY1WFVZMnJSQ3NHNzAx?=
 =?utf-8?B?eUJHWGZqaW9hazhnOVhpVkpvTm5vL2lrNGphQXcyQXBkOGE3Y1IrdHdoZlVi?=
 =?utf-8?B?WE1LVG05VE5WTmFlK05nWXBFcW41c2RZMUVtRWlyV0ZqdTZiV3VlMjJ1SEsr?=
 =?utf-8?B?YnpyZ3hWNThrbFNCd0hFb2tpdnV5L29HNjNyWDdqa1BTTStlUlhqNStyVERk?=
 =?utf-8?B?cFY4bWZEcFpXdFZhbldNZVlyRkw4NXZTcXJRN1AwR0pxL1ZHcmFKUHFxYU1L?=
 =?utf-8?B?dVU4ZkdxNmdXNEF0QlpvN1hUZ3ZwMFJFSlZhcERCUWxWWEtDZzNPTEdleXpy?=
 =?utf-8?B?OE9MVTgyNlZLSnQzY1NRdHRmZytuQjJBakVuODZFTHVkcWtGdWo3K3FTM3g3?=
 =?utf-8?B?UTR1cUt1ZHArU3l5dTY1Ym1QaHlXc210OEk4U3M4SWVNM0xMcHhKYzBlNDF6?=
 =?utf-8?B?dkRzSkY3cngvcXRDWlhodEFadFZ1WmorTllnWGVXZlVJZXk4QnV6UVQxbFhN?=
 =?utf-8?B?M0VlSmxPOXFaNWxYU3NtNDk2YzBQU0FRK0FqSGJIM1BleUUwN2dUUWwzR1Vy?=
 =?utf-8?B?bFFMOTJsbC8xcjU2Zks5cW40cCs0czNLRGJIUXRhUk8yWnhGQ3BuZ3BvN1d4?=
 =?utf-8?B?bnJNbGw4RHAwTldIdUNFMGM4NjdxaG1rWEpQSXQzTExxQkpLZkxZWlo4K3Np?=
 =?utf-8?B?eE5pUXNHa3FwZlZ1SWVtYzIzNnNYeWxoR1VSVnNKK241K0prTUg4S2Zod3hI?=
 =?utf-8?B?YzlzZU9CUkFLaHpJK3U2cVI5ZzRrYXR6ZDQzVDRhVFBWT1VmNEdHK0lSMkUx?=
 =?utf-8?B?Q0xSVFlBenFZeXRPTEpScDRSUUlCTmRRZU1MWUtXc0RJMlh1REg3Mk9oT0lH?=
 =?utf-8?B?RlpqRjhuK0lOUXV0YWxha2tRMVkvcHVHd1dzdlYzd1FhOFpjbnFCSWdLVDhy?=
 =?utf-8?B?eU44aEd5ejhIYXhjMnNVY1ZjUGRDWWdjLzNuQXJTMGF3L0FBUFVNTEswMEVl?=
 =?utf-8?B?ZmM1SzQrdG0rUGFqUm1GVmVEZHhzRWJtVTV0K3N6c3d6bWRYY2QvN2lmR2JI?=
 =?utf-8?B?NVJReGxiRE5HQVA5OVRzaFEzR2dFK05STlRvSzM4L25JZ2NEK3RpMldsdncv?=
 =?utf-8?B?S1hHRzlvV3JYdFRaVjBvVFpSd2JiclZnMEtWYUF3QnJjS1BEclRWajBuK3I2?=
 =?utf-8?B?VDVUQU5zYm1Wek02czg5TWJmMlVYNjZxQ0Y0dVZtZFcrMjh3dlliL1kxVmU3?=
 =?utf-8?B?UnovV2ZNMEJwZDBhUjRoektGWGpwQkNQMkRSRjFCOXRuZDhIRDhEUWgvQU1I?=
 =?utf-8?B?cEt0RGFyMTdDemRpUXlHOEpqTkV2ZVluN0ZYNVhpaEl0bnBkaDh3am5QVlV1?=
 =?utf-8?Q?hT5X2jVuEg7nNJOgJ5B0ddKRafHKzulPx7VxHTsiLSt0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba98ad5-54ec-437e-3743-08de27f8225b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 05:46:21.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cysyCWx2+OC2ngP3aekImGGxkOTl7ir6p7SVJTlKkd2tbzisU+vqHfUCUslctS7wp1oWoUBUHiBq+Dc8M69n6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9568
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D42A040012
X-Stat-Signature: pqbj6pju6ymydz35xstg7aggsa9bq8yb
X-HE-Tag: 1763617586-749590
X-HE-Meta: U2FsdGVkX1+4paupB7ZW4k8lBWqU+I0kJlm3BU80Bhbg/KCq4IuOb1cl5JdVPyT4ZiHpd0eqQQp3DBxF6Wzr3m0LzFZj2mB8VmJ6oa6E5YoPuuoZwG/AyQHKU5e5jVxlzjq/vRejdLlWoSqmLGKNQlPtTJgs1UY4NMMaluVWh2RKBDxPnfscYFcqtf/3ovOA2HnhJEu75dx/h/kG11IvNTjADixQ0xq4asl3fpTvQfrzEm+BlpkeWDDcIRWarVvBZV5cZpM2wa7UM6o3yKN+eRzs86fNa6S0+5FYpEV21hoiC/wz0N+FX1YlPztk+rivsd5yjseXPxprtagDuUuGK2TIXpampj2E2Mzt0TyvSPi1C9xVcDJxVOKfDqUHkWvT/RqpvAZXBGIot7JoJ7aqP4M01vc2izoLq+Jgrx5rYSuK1wAqHnvzOCKXP5ZYuavmRW+LZbaxZIOw4heRgBt8BKtEOzX+9sFCyet4aQt0LJJfHpbiFnTELkRTiy/JE4gBIjoQkne9v4hwNXmR5ULDgcz+tZYjPVH2GBbPOg5OBKAc1d/wo/DpAMF/4cWRg/LHtIhqAxMKBpwx+GaP+v5nOCyrZQZProLzVAYr2VVS9L4yqfOtV70G3lKodSHmRWOXda4Olz0DxbVD2f+r/l9/NltwoskQX5pt13rdAU1Aec3ErNlGG+DVTP+96OpFnurirU14keMmZigd4pvkvdA/CNnacrWdeFhnlWEuDmXSDhbF3i4kd+wI5pR7C8KBBWz7DD9bV17sxrVXrq/YoH2MPEZNhZ4etwy9zdpNWepKVz/l+3kjh2lUgTG9nszywI/MoxYsAFPyGKJFE2GXSEVDP7ZCrd63SYwu97zwnQvu3TeAuMNXZ+l9LZrBaRiljFQeM0LslZxOnsN2uAiIUlCbKAACoxUDUW7knEWvru/33c4RbyDFhxnv1WTo1w+ngk1xWeCjWwbi8/ov2UctxEs
 OVIBUptS
 fy/DeqqdC5aL/bc3Z8MR+zl/f2w9Lja8otw4lEtOJSyKQOGK7liqyFJFkdUdAt1kXE8U5eaMyKfVwYoM6X5KO39nQG3mlXwJeYMl8AtAhvCp+aTVDmxDccQ0SszB4OlkIiCHRPuxMleb5ipAWLf3bhodyCVKNZA7kRzMk+QxVQt2/StOXiyOgdSObzsEEoyI7U47XPa//WGdrBVFYplkZbR3jcWLmhwdBT0S2SPVWi6JT61X72JynQ8OMKh271pJjCC0a8Y5xA3ij5oifVY7soLOudWleQ4qP2W3dR1EWnT4wLiWUNr/x6LUAGZ2MMqgXpvkB0tMETUh0nl3A4bldAiQXz44VxB8/MEF4DqgIkkcBMyo5SR1C1+vaqHQ1il3eJH3Nd/b7VPOsTHGBX1uIzoyNYsctyqAE2d+0vnkvfP3km8c1hiKJq5mCdGou1O0B19XbbvAJIUggDi8YlCLRnnEDlIsYdIRqjcuS35UQUedsDyn9dNJMw6wc2OzDdDwaM+UzZloA3cZBFHQZknuoFPCfBmzAWu01VBIN7VydZ0gKUsA0VNGy9Tp4WUh0hu22BgajBrnbyV9Ocof9hrGpgPKGIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]>>>>>>>
>>>>>>> How'd it go?
>>>>>>>
>>>>>
>>>>> My apologies for the delay—I got distracted by other tasks in Xe (my
>>>>> driver) and was out for a bit. Unfortunately, this series breaks
>>>>> something in the existing core MM code for the Xe SVM implementation. I
>>>>> have an extensive test case that hammers on SVM, which fully passes
>>>>> prior to applying this series, but fails randomly with the series
>>>>> applied (to drm-tip-rc6) due to the below kernel lockup.
>>>>>
>>>>> I've tried to trace where the migration PTE gets installed but not
>>>>> removed or isolate a test case which causes this failure but no luck so
>>>>> far. I'll keep digging as I have time.
>>>>>
>>>>> Beyond that, if I enable Xe SVM + THP, it seems to mostly work (though
>>>>> the same issue as above eventually occurs), but I do need two additional
>>>>> core MM patches—one is new code required for Xe, and the other could be
>>>>> considered a bug fix. Those patches can included when Xe merges SVM THP
>>>>> support but we need at least not break Xe SVM before this series merges.
>>>>>
>>>>> Stack trace:
>>>>>
>>>>> INFO: task kworker/u65:2:1642 blocked for more than 30
>>>>> seconds.
>>>>> [  212.624286]       Tainted: G S      W           6.18.0-rc6-xe+ #1719
>>>>> [  212.630561] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>>> disables this message.
>>>>> [  212.638285] task:kworker/u65:2   state:D stack:0     pid:1642
>>>>> tgid:1642  ppid:2      task_flags:0x4208060 flags:0x00080000
>>>>> [  212.638288] Workqueue: xe_page_fault_work_queue
>>>>> xe_pagefault_queue_work [xe]
>>>>> [  212.638323] Call Trace:
>>>>> [  212.638324]  <TASK>
>>>>> [  212.638325]  __schedule+0x4b0/0x990
>>>>> [  212.638330]  schedule+0x22/0xd0
>>>>> [  212.638331]  io_schedule+0x41/0x60
>>>>> [  212.638333]  migration_entry_wait_on_locked+0x1d8/0x2d0
>>>>> [  212.638336]  ? __pfx_wake_page_function+0x10/0x10
>>>>> [  212.638339]  migration_entry_wait+0xd2/0xe0
>>>>> [  212.638341]  hmm_vma_walk_pmd+0x7c9/0x8d0
>>>>> [  212.638343]  walk_pgd_range+0x51d/0xa40
>>>>> [  212.638345]  __walk_page_range+0x75/0x1e0
>>>>> [  212.638347]  walk_page_range_mm+0x138/0x1f0
>>>>> [  212.638349]  hmm_range_fault+0x59/0xa0
>>>>> [  212.638351]  drm_gpusvm_get_pages+0x194/0x7b0 [drm_gpusvm_helper]
>>>>> [  212.638354]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
>>>>> [  212.638355]  __xe_svm_handle_pagefault+0x259/0x900 [xe]
>>>>> [  212.638375]  ? update_load_avg+0x7f/0x6c0
>>>>> [  212.638377]  ? update_curr+0x13d/0x170
>>>>> [  212.638379]  xe_svm_handle_pagefault+0x37/0x90 [xe]
>>>>> [  212.638396]  xe_pagefault_queue_work+0x2da/0x3c0 [xe]
>>>>> [  212.638420]  process_one_work+0x16e/0x2e0
>>>>> [  212.638422]  worker_thread+0x284/0x410
>>>>> [  212.638423]  ? __pfx_worker_thread+0x10/0x10
>>>>> [  212.638425]  kthread+0xec/0x210
>>>>> [  212.638427]  ? __pfx_kthread+0x10/0x10
>>>>> [  212.638428]  ? __pfx_kthread+0x10/0x10
>>>>> [  212.638430]  ret_from_fork+0xbd/0x100
>>>>> [  212.638433]  ? __pfx_kthread+0x10/0x10
>>>>> [  212.638434]  ret_from_fork_asm+0x1a/0x30
>>>>> [  212.638436]  </TASK>
>>>>>
>>>>
>>>> Hi, Matt
>>>>
>>>> Thanks for the report, two questions
>>>>
>>>> 1. Are you using mm/mm-unstable, we've got some fixes in there (including fixes to remove_migration_pmd())
>>
>> remove_migration_pmd - This is a PTE migration entry.
>>
> 
> I don't have your symbols, I thought we were hitting, the following condition in the walk
> 
> 	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
> 
> But sounds like you are not, PMD/THP has not been enabled in this case
> 
> 
>>>>    - Generally a left behind migration entry is a symptom of a failed migration that did not clean up
>>>>      after itself.
>>
>> I'm on drm-tip as I generally need the latest version of my driver
>> because of the speed we move at.
>>
>> Yes, I agree it looks like somehow a migration PTE is not getting
>> properly removed.
>>
>> I'm happy to cherry pick any patches that you think might be helpful
>> into my tree.
>>
> 
> Could you try the mm/mm-new tree with the current xe driver?
> 
> In general, w.r.t failure, I would check for the following
> 
> 1. Are the dst_pfns in migrate_vma_pages() setup correctly by the device driver?
> 2. Any failures in folio_migrate_mapping()?
> 3. In migrate_vma_finalize() check to see if remove_migration_ptes() failed
> 
> If (3) fails that will explain the left over migration entries
> 
Just thought of two other places to look at

1. split_folio(), do you have a large entry on the CPU side that needs to be split
   prior to migration?
2. Any partial munmap() code, because that can cause a pmd split, but the folio
   is not fully split yet

I also have a patch for debugging migrations via trace-points (to be updated)
https://patchew.org/linux/20251016054619.3174997-1-balbirs@nvidia.com/

May be it'll help you figure out if something failed to migrate.

>>>> 2. The stack trace is from hmm_range_fault(), not something that this code touches.
>>>>
>>
>> Agree this is a symptom of the above issue.
>>
>>>> The stack trace shows your code is seeing a migration entry and waiting on it.
>>>> Can you please provide a reproducer for the issue? In the form of a test in hmm-tests.c
>>>>
>>
>> That will be my plan. Right now I'm opening my test up which runs 1000s
>> of variations of SVM tests and the test that hangs is not consistent.
>> Some of these are threaded or multi-process so it might possibly be a
>> timing issue which could be hard to reproduce in hmm-tests.c. I'll do my
>> best here.
>>
>>>> Have you been able to bisect the issue?
>>>
>>
>> That is my next step along with isolating a test case.
>>
>>> Also could you please try with 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
>>> reverted?
>>>
>>
>> I can try but I highly doubt this is related. The hanging HMM code in is
>> PTE walk step after this, also I am not even enabling THP device pages
>> in my SVM code to reproduce this.
>>
> 
> Thanks, do regular hmm-tests pass for you in that setup/environment?
> 
> Balbir
> 

[..]

Balbir

