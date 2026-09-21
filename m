Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19CEAC982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12E46B00DF; Sun, 20 Sep 2026 22:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74856B00E2; Sun, 20 Sep 2026 22:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915CF6B00E3; Sun, 20 Sep 2026 22:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA706B00DF
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7707D1A04F6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:39 +0000 (UTC)
X-FDA: 85236185958.22.C873225
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id AEDAA1C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z0N6nmJU;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957716;
	b=N0XYlQapa0XLH1izgSm3euWo1i0MRDftaY9rbeIn8ein9jgH75ztHsSs7t6GLUF9yZEiii
	KG4XEUnSzfGo2gIf4LgSgZZIal6uEHWAvVmszsfJPFpsyHXSslObmztmDQo3Ss2HIjfsp9
	/++I6cBKLrTsm4FmF99gC/+AedDBV/Y=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z0N6nmJU;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpMC3DPaCgBSCOyBuao6sjqogivZ56QdijQSKHRf1os=;
	b=AJefevc/ljNYY6jhRpb6tF0xO+YXT8h4sLcNKhpGjZSYd82PTnXkUXLuPwQamzFRsdQbT8
	uTZbKm1SQWgDy57RdOeC6wEq8S+dZ/ZQTkJLzACGDPhsjbvcrpPygvIhOYBxM8B2UvuHQD
	4R0bCzItKELTiw3Jb1VX+ESubWdiiMw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxfrvHFGH3yAq6mvYcNLbZ0IqZFUyPWdnkfA/522kXJR0gEeqNt/tqPpfHQS4mx000iSFdPIb44vlQh/XkiT6mdJWFd6rTwtX9PwNlsj4wk2B5QWYTRVGzpOyRXqpcfH3gb2Cgcrl2BS1GFabrbU+vgIIY64VjGT1I54kOiPijYo+nQnYbMHxEzx/ZzyPz901QrlDgsLbcwuuYGswFBMbkmV/575MCAVwLUdSHKsGvMqUSxT+NCjZR+EfMT2HuckozbttfAD5/D/boM627VlxldlHggzFbwA48BJl2SIdPHkcymTmWnPqVSaEVTHqVaVyEm1UxbjFNn/rB882YCAyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpMC3DPaCgBSCOyBuao6sjqogivZ56QdijQSKHRf1os=;
 b=eu7FsLlPmwiAuNBwcBYej/R+MzZ6r9fWggo9aWrAMrVk+cltCA8IDWdtzksXWPqmlAdGTn4t68wdX362UEngkBR+82HRiMk/v9BQm+g2k/S+FNdyhJR4Za192W8fdA6iWeBnRqjusOwB3YFtc9cSOAwK8UDNODeExKpY5Z2+9FaoTZnXGmaD1k5rZFKYaLqRO23i4b/hEAOtVGNhJh3usmPQ0CUB0aZbB3JAcSJt1JHXshnfcIcSXAL0Xg05yc3BgsSSnEIAYChUYBlygLhj4wDLB9P4vJWva+Xu9N2ZQAYzAx2d52ioroE80okKmIJ51UxwLko6qwXt7kQPl+yCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpMC3DPaCgBSCOyBuao6sjqogivZ56QdijQSKHRf1os=;
 b=Z0N6nmJU0+AU3bupI5n4kRfItzpwj53epV4JQKpd5OfQF2AKZzNH5ZNE0yG+ShpAstFHZSbIzZkyiD59BcPwAObKyMGKo3YTKOrzU6aqy31V7Zxi8GBBVLX8K6YqNuMDYXzMYpgBt1JxEwAMDEWHjOtvTwj6CPJkAxXTyhtB6V4GQYdXmPwvZbOfH2k1O76jxxWqmuYWm31g390EQskXBiEaH55XTeC/TTnEG949NxFGG7e2qbGFl091RIDPSrcWz4T776y3sCU9E3/ZXmI6auFVqoBAl9TvATrB/wUc+vuOj+P9MR+nnbb1PuuF0+wPi2DzLHlIZLzxpPp1uYfbTg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:22 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:27:59 -0400
Subject: [PATCH v5 03/17] xen/grant-table: stop setting PG_private on pages
 for grant mapping
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-3-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 xen-devel@lists.xenproject.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: MN2PR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: d3dac128-597d-4394-e183-08df178801eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	36kkqR4p5YHKuN1SERPlBIsWYUfE9RFpZ5J4etwUmJVpKUH3zsMuomA6AO3t6mKX7KbAV6Dv5xyYzTyKFgqolwMOMSU/mXU17776DcbsZ5EU++dcUjizE0KpjyORdod6p3BUPJ7Q25uheQ/XHNPxzSMg+BuI4ZgTk9TefDPFRneyBWMBfUWhwk4sygZIJhwLzHiZC1CV9s71N4KAvuiLUoz3sEg9OzTy4j36gegADSd6JhBGKCEvipvQAl/VyVymogchy7ZSaXQMth7f3ybi+L/Wv3zVuevdsdSjsLHo5C9kQugpsXystEKdMz/vaM9SQJQA485gN6CgHGBfKd/oW2r4rgMT49xN6TXtDM26TRgb1J0X+8TtfrU4R64RNCifVNREO1a4zNfv4mR7fZjPLOTvxmhwDQNxiKyg+drzMVb+H1ajTYavRyQLKJvvqjBuFpkQrSg2RrElUhIIPSIi3NdMOWxXqPt8lwFsQYn1cd6VDHeADOqGKiPdBx2//I+reHvDBOSKenoY3HMiYYY2XtFsIOzOTKoOZPMlm+FF2GVkaT6IOjKAg5bYpyzRM2z8dTy4inkt9CC/eanyRoZ5Zbw6yzHfQ/zZDsLrVgCtdNMwtvKj0pUXKOtw8fZSYscd8V19YOw1sZtilHyRMpwV0xaqzRDSoKNVeBeR3QuHJ/unHA0lLe+tarY0++miEnL7h3+sU903iB9L+yq24UhYgg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1lqYmhQVUl5ZTRqVW5FT0JmUDhjbXAyRXlUL2I2S3dBUXg0OHJjNUlmQy95?=
 =?utf-8?B?TUZzTmw0clBtbWVCVW40bTBnVkw0emFPWHgzUGN3WXc0b3p6ZWJoNDAyRFQy?=
 =?utf-8?B?V3EycTVFSXBKSWhmQ2piY1NaaHd0bERiNWJ1Y0NUSy80WnhWaWNLN3FXZ204?=
 =?utf-8?B?SENvcnE2T1NoL1AwUTBBRTVXekpPSnNXN2NSTDJRdWwxNjJFb0J1aXh2TFF3?=
 =?utf-8?B?OUlFeTYzdXIrb3BvbEN4ejJ0YnRhSThjMWlGaDVBamlGUTNqbVVHbmx1eEM3?=
 =?utf-8?B?bTQ0N3RkVFNpd3puT2ZCelVWN3o0S3hDSUQwRDUwWmtRcVYrbndFY1dKVGpG?=
 =?utf-8?B?cWtmUVhtOFhCVU1uRWVVbzh6dldMbjZ0cWlkdTFNdWNVTlAyRFltMTI2TXBD?=
 =?utf-8?B?RUp5Z0JhUHlzbVRnc3JVaXVUcU8xZmh1WmJ4VlFFMitlZGVCemdFb2FYRkRa?=
 =?utf-8?B?RGVWYWZ3aTh2c1N1b1k1YVJ5eFY0cUFFbmVvU2NKd1R5ZEZwWENmUThSaFFk?=
 =?utf-8?B?K1Z4bVJyOHNjR09ZN2tGRmhQcUd5Y0NMTnpzZkpKdkdFc3FjUzRYT2UweFhY?=
 =?utf-8?B?Tm9zMU9DZUxhRXlRYVl0UXlieVdla2tYSHhKbEdPd2xkRzJzMGhXVFpSRDFm?=
 =?utf-8?B?cUxPL1JDMmhMVUErSGkyWDVBQkphS3lWTzhJMUNlMWYwc1FLTEwraW9qSEF0?=
 =?utf-8?B?Nzl0NUx6U241VXhRcFY0YkZmWkVKcWMvTDhsVHZWRGxQOWFxS0U3K0FSVjgx?=
 =?utf-8?B?TzVNak5VRW1FUDVWUlRRV1d6bFZkVWJRMllqUzNVektocnNlcVhJM0dqMW95?=
 =?utf-8?B?SGlUQnpPRXZGbTRadTFEQWRidlkwMEpQQ25meWt5bVdtNzd4bnhzM1FKL1JF?=
 =?utf-8?B?SEIySjd0K3JWdE0wQXdQeGVVOExFTnd1cDVuQytmTEROa0ZNQ0s0VGpWYWZQ?=
 =?utf-8?B?Ry9TbzBlY0p1dlA2aXNOMDRYQUxvTGVGSm9Qc3NUZjJJUzJvRWVIQnB0TG8x?=
 =?utf-8?B?THdQNVNoZXkzQjRldGlJK3pKNHFoNllhRnhTcmt6WWNyMmpZR1ZBODd4WnBu?=
 =?utf-8?B?cklqRDBVZE4wZExFOENmZ1ZvNS85clI5QS9ETDM4RHBnd09HRklYTmVVenZa?=
 =?utf-8?B?WFBUMWprb3lobUkrZ0Z2c2g0Z2d2WGp0TWoxRE5WdjV3UE9rektyVFVWaDZG?=
 =?utf-8?B?cU9pUmsvZU5YaHUxQW5iUVZrdkg4dDN4ZWM1SzhpdWZwYUVUd1ByQXlEVHFF?=
 =?utf-8?B?cXViOXdvcFV6Rldnei9mVHdFaHE4QVRtZTdQS0VrZ0svV25nTVYyL2NKVFB5?=
 =?utf-8?B?NTNmOGkySFgybzZrcytLOUkrZFptUUxaY0dVQ0kycUh4cVpSeDJITXZJWGVM?=
 =?utf-8?B?dmJianlaNW92U3hqK2dKazZpRXNGOVMzaENXSkVoL3FiWWdqVWtHWnFGNis2?=
 =?utf-8?B?ZmZsQXRleXFuYWdqMTRCMElBN3BBd0wzVEtYeHBhYU9XKzVmU0VlVHVuVGVK?=
 =?utf-8?B?NUVDZUdlSE1iNmthaENqcVJTZXBPM0pKQ1pTdFR4akdSWDc3VTlpZTdidUhh?=
 =?utf-8?B?RVBzS0NGR29uY3pVNUQyM0ZFL1VybnQxdnR3Qlh6V3JqOTc1MGNIYytTK3hC?=
 =?utf-8?B?ZmxpZXlKSWhsbitLVW5yTHZ6Rkp4YTl3UmNXQmlMZGF2ajNOUGNOWENwQWZi?=
 =?utf-8?B?VmZiazBUV2RkSGQxQkF1RExRU3k5dS9HYnh2MUhRNUM1Q1pTaDdUcDZ5U09P?=
 =?utf-8?B?Ny9QanJzbUVEdjdINUFJbk85c25OS01CODAzakdickYyeGp5dmRMNWNZc2V2?=
 =?utf-8?B?RDhDcTBlNnBXaDhTdFllWE8xMUJqQnlNRHJDNVB4OERFSGdxVXQxcy9kY3hm?=
 =?utf-8?B?Qko4YmFWakJjcHNLRVprUzJGdnd3UDdUd0JlUjBGcm1nOHJtQWxyQ1FaWFB6?=
 =?utf-8?B?bGU2bDcxV0t6MHprdHJyczNnMzVFMGJZRnZRSnBjejNUOEVqb3Mvdnp5MTB4?=
 =?utf-8?B?aFN2TWRNMXgzRDl4eGkzNXBpSHJMSEdoWDZsbTcvTzMwTW1WYUNmRDFhNUdu?=
 =?utf-8?B?L3l6TU53c3FnS0hoNk85ZVczemtQakJlS25Ucy9oeGFLOGoybCtkUExrcEpI?=
 =?utf-8?B?V1h3aDNPcTdLMC9ldythSXZidGU3dW03a2xsQ0JuS1lza3EzbzRSZldBTHY1?=
 =?utf-8?B?SUpFeW8yU1o5dit6Wm9sMm1VRDhpcHRwU0poMlRkZjZ1UlA5cEFnMDUrcHN3?=
 =?utf-8?B?b1JvT3dsWWNmMDFzMWZ1VVJ1TWZydmoyYzRBVFdNZWNtcWxxMUw4Ykp1N1Ja?=
 =?utf-8?Q?oEYSwmZT8r+icpO+ej?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3dac128-597d-4394-e183-08df178801eb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:22.6170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnizZyuJDDjv7oxstG8ppNpr2WexaCqnVhUrv82Iszs9S8SGxiz7xwhWCXJT2rEI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AEDAA1C0002
X-Rspam-User: 
X-Stat-Signature: hzpgq3j7m6q6rwf85xkekjn5zu4hifki
X-HE-Tag: 1789957716-1039
X-HE-Meta: U2FsdGVkX18ngKF66+mSHhTapEMXNfXvIvP0BQherg/mYXG7VnaYoa28DukeJDyuOZZ67+c8aq5a2NHr5DkiEvydo0PyDge5X7RWmdVfmgUKcOIjED96/ztWd68WJn7+i9Soq2iXRHGQSl9zwVhrXOw/cpO4XcbkWHlirHdltyX0V/o4jpa6TLoRRcFIym68//LzwXCH5zIwnI7P7sLTJvmssOFOFK6qg721KmckKFFwM0g8fjgy3gvN2vEjxYT1+7gLNJ8OgIyK1hkXLsaA9sW+dq0jkP1k79395iBXqerDYD7CEK+Q/7bDBkM2BJxvDaGJqwE1qiy3Lv8V97Dk6oHVAu0jpuaJp3raHm2RxgjgfnlLbww1OOKFq6pHGOb4RMsaPaG3wyAu6PdrJWvPmsn5XW+htDQprwjVkdK96fTVB+fQYHq7nkWNZiSGcipP0wXO5v8x34G83XCfvPsL86z7SkT7a4aQimgp16t7MiFX5hfvtWnCRbnQIGlH1Xnna5KNoJTa0glMr6fCaRaNWjo5JxX4HYSUYDVDhSroPFoNqT7LKd2Ln6Y1tmtZa1pX/NYf84Sqx8x5r1T7yLk/ZFcl8ykzSbmLLwwEYtP/uemf2NBnxNqcxpF0Vu/W3jyGP5qqjRiJVsUKVJ38aREPKPNu9mCy/3tmklXcDnQB6TXCMx6soyinQtXzY11RdU3V3sIGJI09jauYaLjhJg31hfsEFuUnMD+978cSC28Dg3K4O10YaV0GopgQ2jtPqToOzAjPsk7QlDP6djAikyVsnrpsqJk4LpG8UZ9BVuucJ+IyNhNV+sSGXu7ub6cRHQmexrH0q+4j+lP6UCIKl53XCE5xBHjWBANxv79Oar1Ch3h2IuZumAMf9QkPD6w+lZW80y1kxJdfga8nU7dKkT+hXBlqEjoESeq/0El6wVrBndZFGFqqxwL8QgEyP6MLjnGhvCwTgsPurj0CMpAepCK
 ib7jDn14
 pc4b458PG4CVllgOJkb83j9P6xw4Ozv/wtBhN7ZihQD74jjFVXVKaUkpMsheJuj0ZhiVApaKmm3N623GKf+RQIdKVXchS4CMU0tWAqdQtq9cNF/a140OP23ZyflHmQh4TvBM2IjRk7Ju1H0RMSoyvjyKXvSha8ydEkzPcnBQVgtIqcdGUf/K0MNeP4QsvXKpIxA6z+whE6UdwWDy616Z47L+jz46NWyT2BLuKnnYrJrlzD0Qn43u6ovwzpOLWrcEfnIV4g8jwx5pJBYCSsWMnzVVwN4mzlwOyRQaZSfLzf5wz/qnpjXZJXAh8+sQJnT8roUoVLGzOdKtGvbDpl4optsbi/qNXKzCSIc9jjGqTVBycl4ifDQz2f/4SgEx7l1lLOZlLaIkdMa5ek620FKi9v3tNhLjT21q+Bjz/UWOj6rFZAiGnUYc8bZxGWqjj+tcjJ7jqqA0LHiG3ILM0GTFvf+sY6II/jDVYT4Rl0hVTMEqJIAP8FP6GxTFHIGH32nbgSAumDNp+lRvcm0h0CjvffC02UpFens2kZ9KFW4rZtQLE0y1uHMz9/k9LYLQoPC03KAi+OuC65+ftxeaVzyfOeoww+6ipaBnsysmd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gnttab_alloc_pages() stores xen_page_foreign in page->private. On 32-bit, a
pointer to an allocated xen_page_foreign is stored; on 64-bit,
xen_page_foreign is stored inline. Checking page->private != NULL is enough
to tell whether a xen_page_foreign needs to be freed on 32-bit and
page->private is zeroed unconditionally on 64-bit.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
To: Juergen Gross <jgross@suse.com>
To: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 drivers/xen/grant-table.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 69922be28b54c..993f89f048e21 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -863,10 +863,10 @@ EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_frames);
 
 int gnttab_pages_set_private(int nr_pages, struct page **pages)
 {
+#if BITS_PER_LONG < 64
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-#if BITS_PER_LONG < 64
 		struct xen_page_foreign *foreign;
 
 		foreign = kzalloc_obj(*foreign);
@@ -874,9 +874,9 @@ int gnttab_pages_set_private(int nr_pages, struct page **pages)
 			return -ENOMEM;
 
 		set_page_private(pages[i], (unsigned long)foreign);
-#endif
-		SetPagePrivate(pages[i]);
 	}
+#endif
+	/* Data is stored in page->private on 64-bit */
 
 	return 0;
 }
@@ -1031,12 +1031,11 @@ void gnttab_pages_clear_private(int nr_pages, struct page **pages)
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-		if (PagePrivate(pages[i])) {
 #if BITS_PER_LONG < 64
+		if (page_private(pages[i]))
 			kfree((void *)page_private(pages[i]));
 #endif
-			ClearPagePrivate(pages[i]);
-		}
+		set_page_private(pages[i], 0);
 	}
 }
 EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);

-- 
2.53.0


