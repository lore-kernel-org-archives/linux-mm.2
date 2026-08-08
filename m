Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6C5C5AD2C
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 18:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BE96B00CC; Sat,  8 Aug 2026 14:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB4F6B00CD; Sat,  8 Aug 2026 14:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB40C6B00CE; Sat,  8 Aug 2026 14:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB466B00CC
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 14:01:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E483A140414
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:01:55 +0000 (UTC)
X-FDA: 85078870590.08.87358DB
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011026.outbound.protection.outlook.com [52.101.57.26])
	by imf24.hostedemail.com (Postfix) with ESMTP id 074E7180007
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:01:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KKTJLctR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786212113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0LXLZ9bl6suvoXO4s2Yx9fEgNwuV4WwA8sLl1umEf8=;
	b=RlNAIeX/dUDjbAYsZ3EWL+195MdSjv4/Cw3TTw7Uen7LmdH8t5jTT1hY9kLOIGcWXHzeDt
	upYlzITIg1ek4hisSy8JzQHPADY+VF2h9mt0C0YKtWz7yoX9lhY9dPt3uzxvBMLt2FwStt
	gn2vHTm8L09Pe8eUS08kdsDLc1mVOgE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KKTJLctR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786212113;
	b=3QljB5QHn7w6eCPnHdgGr3GrUSNjfLeH7TSSjyPIgbqcT/d3T2uy33v3NZcUDXDpHuqHEk
	ppP7JjkHxcX1rf1aQpw8MAuycafzXQPlnwoaee0i8h1K+KRkgUgWuJ11VaKvAjRW2BQXhJ
	4nl9qIp9Z8GH5gDLquoYITvKTmCH2u4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lj6f7JORAcXhfjXUdUSYWqzvNPIMDbz0QaEnkoITRYEMdJ1xY8/+a5nbs1yXq66LxH+weZvBNfDPioBVuBTHoJ+q2reX4okCEEmXKDxz/6XUG8/F8z4DfvrDdu7aI0YnUP7LRKtHvT9Rh3akeHEZznQDCneYpk1qkVK8y35Wc0c+ac7jBVz28w6/vUpRvHo+CH0zIXazVnKD02p6vQ50Fpb9IFcteXcpaffZ4mEb2OAMybYwveAVZByC18uTaOlJxpd+A4XH7HkEcnZ5D9zrwxSrnJR18acZhKnkDO5AxJh1iPrRWU1bFgUaL/hPFn3UqLBmjpLdBlfJN0zReSuPPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0LXLZ9bl6suvoXO4s2Yx9fEgNwuV4WwA8sLl1umEf8=;
 b=lJrH2xpA9vQ1bY3bhXDo0r4PZKOAp6uDiw41ptcAoD4yAxfAO8NCpoIoI4fcZkHxYs6lwTcZ30w1iStPj5wQdpCoD5X7Scyjf4Q25cr/f3sT2dG45gJYgKiXkOB3IdTHvhKIi+R+fKifKq9nOczTw+TONwRrzHmnXNWQOfb5OHsIOyhT7/2wML9oCE6URNBROUMVcn3p/zyzq3gTbqshzKrn9yavR6X3vaYhJ/I1ARxb8aSv1aBXvPvWa8wBL6qOVl4+dbYr+MMB0Qzcd/BNM9BTOPFL49vQV4DwydmY3Vq914U5xw/Cg1YCff58zUHOeKe+uBSc/gssgL/BQt9Eaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0LXLZ9bl6suvoXO4s2Yx9fEgNwuV4WwA8sLl1umEf8=;
 b=KKTJLctRrAZVvQF6olkz46wqqFKwl8Ff5JV2fTFjClt7JJ0TC8VYfhg8yT4E3cvkaaN6LtkBg1GadbidYQm9NXKIIgkQB0CkGhTX2h86xZuroGohFmEFi8oG0bNRlpUDdv438z4aSNX0zkkno9TjIKBPwUlqmLxosj9XOwhIcGJdz317V4Klo0ad8mDcR8wYMuQTcUsdn5pAYceagKWrBhf1kO2eCGxVbbhhZ8KKzr7l0fB0vxA9uM6UZ97xxNxeCVwVwmQdiNkrybFly++8muhbBsNEJDgHUlZRLNydkwIulW+ggwUFIKJpTxZ3BVV8Tnl/k9c72bq8ES9eVLBNQA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9691.namprd12.prod.outlook.com (2603:10b6:408:295::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.24; Sat, 8 Aug
 2026 18:01:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sat, 8 Aug 2026
 18:01:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 14:01:46 -0400
Message-Id: <DKJRCHRR9H73.X5JV4PU1MF7X@nvidia.com>
Subject: Re: [PATCH RFC 02/13] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-2-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-2-689939a7ccc3@tencent.com>
X-ClientProxiedBy: BLAPR03CA0142.namprd03.prod.outlook.com
 (2603:10b6:208:32e::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9691:EE_
X-MS-Office365-Filtering-Correlation-Id: 46f6dab8-cd4c-4a25-52dc-08def5771d60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|11063799006|4143699003|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Gd/byLJC62x+EXBm8B9PeI305fuxKg7EVwr2w5/74CnLDhy3Fv4JZmnVvxd6Kper6l6dLmjfzD8MxW8KVrX9TMEFSdN7A+5MMfivbE5/fmvQOIRwsufQP8aI2heau6/wTUtCsKH3YBNoGzN7jcsy4j4lv6iv5sTSDqda+6OZ4pnzaajfYuv0bY0Nm3b2CUxt5eJsnf/8wAhD96jCCQvizbOKoyPiQcYJbei+oxkcUHj8wPEVcjVHtd8GidfwgzuKGMXbax4Ux/j4mbx92/gR4+ZcHzKuOn3fYvijTO1B6BISS/l3puesvyRto0e3EpqCwyZnACuU5cgDvI5zMhQUGTDT9JFUbmWwpcoIQa7dLcINWt6qc4+MA5847wNY0y6rdjnYeUWzAtYwfFSxRWrYWYw0UBHEGcLWabRslE73akS5SRLvamKADSAwIF6FfDeVj+42IXWrx8wMSiGbTN8A3iN/XnIueNDvl85MxiL1AwHtsdL2tPzqNpdtV2YjwmqClKDGytil7Y6lpGS0HstGV+eovF3yKkTYCqJekG7Ykng+F6uoKLgodytPLqF6UDw6+Kz1ti799xCkPg8x2ZebP2EFM5wJj8GIRbRQlOpQvUPYCgddjF4YNCZpnieOO57YGlf/73/oO1Qi2qB+OAIimL8Le0c+pIaG9KfLz4uAJxI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(11063799006)(4143699003)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bitpSFBpQzgvNWs2NDltK01OYk9RTXAyZXNnVjQySk01MkZXOHlDbFJLN1Rp?=
 =?utf-8?B?NXBSSzMyUmNVMEJzN2dreVhZM3NqbnRiVFBZSFVSbm1oUXlQWjI2aWQ0NUdm?=
 =?utf-8?B?bWVWNUM0NlQ2R0VSdDRESTdRQkdCMDR3MStFVk9SODAwT1lia05WdmtESmxV?=
 =?utf-8?B?SHoybUE0MFhuMDJJS3QrY0JpVGVWS3pVZWZTUzFuQnJxa2lVd2JnbXdwQUZl?=
 =?utf-8?B?aVFnaDU0SWVKTFBkN1NhTlRVNVJnbFFKK2d3YmNQVm1RbVdiMnluM2JQQzZ3?=
 =?utf-8?B?V0wvVFAxeGloS1N2bjIyNEhBUjZPaVBPQ1Q5enpKb3dXMUlYSWxVZmQ4M3FN?=
 =?utf-8?B?S0RaSVQwQWxlMlViYVZXdm51R2FPR05sTHBvUWpzMnQ4UTJaMkcrcE5SSjhH?=
 =?utf-8?B?NTZnMCtJNDVUTzhKUXE2VTE1ZmVIVmUyYWc4bmdERnBRYm9uL0YzbE1RbUN0?=
 =?utf-8?B?SzB2a09YRmNRek16RGtOeUhaL3V0bU9ZVVg5K2dveXBkR1V6Y0pFNUh5SElV?=
 =?utf-8?B?dnZpS2tPOXR6THI3K2UyVURuWDdhTWNqdS9ocnNCcXpwTlUzQ2RYVHg5WDNJ?=
 =?utf-8?B?SW1yblYxVGNjVlA1ZmF1aWVjU29kL0J0aTMxNVl4ZTFXY0M2VWhFdWtOSGd1?=
 =?utf-8?B?bkRiQWxPcGtNYjMvZmJMcjdSaXRLWW5BVkdlUUp4WFo1aEg3Rmp1V0E1TzJr?=
 =?utf-8?B?SHhLV2F6QXlYcXdwS21kc1N2UURRWlh6WnJTOUt2aUFNMkRrUkZYUmRITFRX?=
 =?utf-8?B?SytZTTh2M0ZNWlBSOU5XWDBuWXgybi9WakVTSUJGc0tlLzJIL0hLZTQvaUIr?=
 =?utf-8?B?ejhvbWdySHc3b1dvUXo4bE1icmZlL2QxVEh0R25GTUN6U1V3NHlIRUdjMlI1?=
 =?utf-8?B?aHlDUXg5YzloNG5PUVorZ1AzYWlGMExQN3VXNmFSaUdGVDMzYVQ1aHhNU3Jt?=
 =?utf-8?B?YjZsdGd1ZGdoeGVQUmRVNXkvRkxpK1lvQlVjRlNxczRZclIyRUI3cjVTam5N?=
 =?utf-8?B?ZUQ3T25uWkRqeWxuRi9FdmF0UkxFNDkyVjg1OVhJK29QTVAvamVFRURWQlpx?=
 =?utf-8?B?Qzhxd012cHVaVHZzWGhZMElMeUlwUThNdk1XVFlla1VvaktiUEZmcWdtL1g3?=
 =?utf-8?B?UzdCVmtLYisyRkVGcVU4NFh1WkczTGc5RHdoMzlnc1FZeUNiNmM4ZUhQS0d0?=
 =?utf-8?B?QkUrbHNzMXRSOVhjQlVpbXliT0xpWk1RYW9WZ1dxaGhRem1EUXZjbHVXcmxr?=
 =?utf-8?B?di9XbjJzbmF3Sy9ySSs1am1peThpUk1leCtPUWxPZHJUTXh1S2N5MVFMcHcv?=
 =?utf-8?B?QjNkaGVHeHNnODhXR3NVSlk4Q08yUFhocitZUmo4TnR0NHF2MG0wLzRBeThk?=
 =?utf-8?B?OWZHUTFVMTdsczdkbys4RmpVQzlEc0pKTXFjakFxK2tqTW1VY3FYaGFOblJh?=
 =?utf-8?B?ZlJocDFuNEtUbFN1d0piVnJvV3c1L1RLZlZyNDdXcFByNXA0MkJtUmJLRk5J?=
 =?utf-8?B?N0lGc2VHZ2twZDZiSzdpcmFFYWdORGZjbTZxb0k5RmxibE9PeWRiUjlabUl5?=
 =?utf-8?B?WWFYUFVGZm9sTDByWExOdmhhdW53K0J3YmxPZGdNRG1jNnV3Q2Jpd0d3NzV0?=
 =?utf-8?B?WmtHczRVeGZFRVBvR050QkgwMEF4T1dTdG5Da0FqK29OL1U1QjRvOVhOeVA1?=
 =?utf-8?B?RzdTN0ViL2VqQUgxMllUc3lHQzF5dThhUzJtcVN2d0xSL1dlOGx2VVkxUXZY?=
 =?utf-8?B?V041c0FWZGJIYmVuVms2djBPK29PbFJNaFNFYUNmQ1JGcS9LaGFHbTFyQTht?=
 =?utf-8?B?bVVKSk15UEUxcG9vRi9Fb01BZ2xzcGhlNElxMEd2c1J4YzlraGJZOTZGTUZJ?=
 =?utf-8?B?L1RoUEJmaVNwS3RHbVlUUzYyVHNlWDJRbERFZXZrNGhtMmtvT01PbHR2K0pu?=
 =?utf-8?B?NDAwRTc0aENBWnpNV3MyaGhNcURJS0JwNCt2SFhqVW1oc3pseHA4alJkalZn?=
 =?utf-8?B?MFFTN2pHT1VVVlZIMGY1Nkl2dmlFNUEvczJGKzNCRmFkZkxKaEw0N1EvTFA4?=
 =?utf-8?B?SGdvWVZvWXBWc3hmaDg0TVZ3cGo5Q1hLYktiQlY3RHlkN2gwWGkyTHk0ZlZj?=
 =?utf-8?B?V0Y4ZFhieGpONnVpM21TTWpxUWRETEdxUnN5QW94UkJtSmo1MnNJSDFqS1Nz?=
 =?utf-8?B?NW9aRWwzR2tZWFZHci9RMXVrSkxUODFDRjZwRDJFNm1GT0ZiZG4yVUZ3eEti?=
 =?utf-8?B?MlN3YmY4VklWK2xHZFo2SjVVK3ArWjVoWDRzdGo1Q0p1OHdGNHhoY3dwYjVB?=
 =?utf-8?Q?/to21/MoD8gb/vJtwD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f6dab8-cd4c-4a25-52dc-08def5771d60
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 18:01:47.7326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tergqcYG6vffHOhQ1MxG1mPBRmHzj2ZkG33Rp1h3fW4jEv62vPtWLGSuCs2b/vmh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9691
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: zugtecf985a56r1o48u8m597r98g5m8q
X-Rspamd-Queue-Id: 074E7180007
X-HE-Tag: 1786212112-341883
X-HE-Meta: U2FsdGVkX18WrQeIavVVVvV+poIVMgLIdG6KUxgyPHkAQNjGl2otUJbRqRG87QXrbE4uMbDHUcM5aXlWfJdR84rgYJYifZtGpcM5W1r+zYAhufJzqytuL8+pPlN9+lXjAGPQW2c+tXbzOmMRtbfEArlBNKKrzlDPJzwpE02k2ROCAYS3MZX+Ywl5AEshhtCx+e5QKy88W8Qr3+NbRXijpZxMBlhVuXICW5qyw+oS7cRmVQuVdDCh6CcPvxx6hlnpLSJVzlj1X/25IZngK9ZFSj1VERP2yJdku9b/5owzC3a7lGHT45VgOp3W9EHqtOXVONawKtIPgyA4J8olHg/iBwaE8xnOmhYYr3+nhN01wzvTtyJ6a34blfa61yv11dwTPQARa1KPmDyYRsRlwqOdY553izC0lusMuh9EhDh8xBZiriMNvF7iINgPY32XdTLIBb/quS6L0b+WANVlkD7tQRDzvbRbBOyA4pVE0PpE17RhBoTZESLZrfZaBLWwnpUDo//kkGSPLkT7e1OjvQFpMt38QKbCQO7xvxjfK40Og5ld0Aq5g+82FT0MCOH21ma/3EU62CZainjymgn0GCrn43+Et0W5+jK6Vy7LmzL+OuyRjiBPJfNbLLC2NH2duUc2Lwk5Rp7Ls3Sc1SZalS7RFsHzTalvU2ux/X5gl5Kua9TX+6m7CSryo2BPNUF2MTkL1Tx1XIvNWn0mVH+W7KMHhNORcHl7i85KUIX7rOoHSmNsJE/tN178WcbLxEMBAO4xcll62fU5mWCKqyFx14ZaT0mVeHQTehgTDvxk+f8aaLRSZzHKQz9ETmILv8kj+/JVlz3TdApXnXNjHRX1Qon6hNZkRaD123yX76SVY9vNTuWg+NLTWj732rY9hjesm125EmYN/JQxe+B+HAEYSU0sTeE4aqrqX1ffyMvxP1pDawZUACvqK8Zs1QHeX7G6US/bu+gdTKEDQo2lyBgU/Bi
 V0j06sA4
 J/dsH49LBwJ5a10v2qkTbPsPOav2tb1ieyhRqe7y7u4UoC7SU9jdmKvb3if7dL2Zbg/XYLxQGkq7dRmW1FLkqmdZTazW7W/O5+3A5Wr4RaDVS+/xT+ucIV6Rrz8UubByF6bfQofUokgmG/kv9l06XVBXcGAhpy0So6WIeKdUVyWHW8PSqc7KDiocoRjCMIxAx3lOuYONFlcZv0LE1EgqJuIsWHx++/477js3VL7Vq5aXLu4W3DUZCOCc1HF+SPx6xAYXE1lbidvv/neumXxxp8dkHSk9FSMYuefhS7Ijf2hZPIUOcn/GmfTU8rzmZOqzSbfZqgvupH0XVAwz/nYm7dSKDMoXL8a33+kWQ5MtjuMe/qXMqOVKD5hVPDSvIsngDXrjvbDC29k5/MCxcCqcS4RXcI8nNlF9H0Q5U4iTTPeOX0efaCGEV+HuKpCtVTPTCOusz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> A folio in the swap cache cannot be split if it has a mapping (shmem).
> The split code only checks for this in __folio_freeze_and_split_unmapped,
> after the folio ref has been frozen and the NR_SHMEM_THPS/NR_FILE_THPS
> counters have been decremented, and returns -EINVAL without unfreezing
> the folio or restoring the counters. That error path is fragile: if it
> is ever taken, the folio is left frozen and stuck, the counters are
> skewed, and the VM_WARN_ON_ONCE_FOLIO would fire for a state that is
> actually legitimate.
>
> Check for this case up front in folio_check_splittable and return
> -EINVAL before any state is modified. Under DEBUG_VM, the existing
> "Tried to split an unsplittable folio" warning in __folio_split
> reports the rejection.

Should we return -EBUSY instead? -EINVAL means the caller should not
split a swapcache shmem with a mapping and the caller needs to avoid
that. The Fixes tag tells me a caller can split a swapcache shmem with a
mapping, so with -EINVAL, we will want to add checks at callers to avoid
it from happening.

>
> Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) function=
s for folio_split()")
> Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __fo=
lio_split")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..2fa72158e063 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3878,6 +3878,9 @@ static int __split_unmapped_folio(struct folio *fol=
io, int new_order,
>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  			   enum split_type split_type)
>  {
> +	bool is_anon =3D folio_test_anon(folio);
> +	bool is_swapcache =3D folio_test_swapcache(folio);
> +
>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>  	/*
>  	 * Folios that just got truncated cannot get split. Signal to the
> @@ -3886,11 +3889,11 @@ int folio_check_splittable(struct folio *folio, u=
nsigned int new_order,
>  	 * TODO: this will also currently refuse folios without a mapping in th=
e
>  	 * swapcache (shmem or to-be-anon folios).
>  	 */
> -	if (!folio->mapping && !folio_test_anon(folio))
> +	if (!folio->mapping && !is_anon)
>  		return -EBUSY;
> =20
>  	/* order-1 is not supported for anonymous THP. */
> -	if (folio_test_anon(folio) && new_order =3D=3D 1)
> +	if (is_anon && new_order =3D=3D 1)
>  		return -EINVAL;
> =20
>  	/*
> @@ -3901,7 +3904,7 @@ int folio_check_splittable(struct folio *folio, uns=
igned int new_order,
>  	 * swapcache folio split. Only uniform split to order-0 can be used
>  	 * here.
>  	 */
> -	if ((split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) && folio_te=
st_swapcache(folio)) {
> +	if ((split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapc=
ache) {
>  		return -EINVAL;
>  	}
> =20
> @@ -3911,6 +3914,15 @@ int folio_check_splittable(struct folio *folio, un=
signed int new_order,
>  	if (folio_test_writeback(folio))
>  		return -EBUSY;
> =20
> +	/*
> +	 * A non-anon swapcache folio that still has a mapping should only
> +	 * be a shmem folio under IO, there is little benefit in splitting
> +	 * them hence not supported. Reject it here up front: the split
> +	 * routine cannot back out cleanly once the folio ref is frozen.
> +	 */
> +	if (!is_anon && is_swapcache && folio->mapping)
> +		return -EINVAL;
> +
>  	return 0;
>  }
> =20
> @@ -3983,14 +3995,8 @@ static int __folio_freeze_and_split_unmapped(struc=
t folio *folio, unsigned int n
>  			}
>  		}
> =20
> -		if (folio_test_swapcache(folio)) {
> -			if (mapping) {
> -				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
> -				return -EINVAL;
> -			}
> -
> +		if (folio_test_swapcache(folio))
>  			ci =3D swap_cluster_get_and_lock(folio);
> -		}
> =20
>  		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
>  		if (do_lru)




--=20
Best Regards,
Yan, Zi


