Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 040A5C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016EA6B00E9; Thu,  2 Jul 2026 20:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2E36B00EC; Thu,  2 Jul 2026 20:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32EA6B00E9; Thu,  2 Jul 2026 20:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 836E86B00E9
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:37:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2585D167A6C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:31:42 +0000 (UTC)
X-FDA: 84944528844.28.9BCC971
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35BB4A0007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:31:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GMjAWx1h;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783013499;
	b=rw76rYdLzT7TpqnY7n96iEk6Y8ibn606UqVypr14PizFGKEoMcozzjgSs94H0vSsdWrPBS
	DkWPusG9bJvL0OarJ2w6Bt2kFbICSEiUeohPcAIOadjCKXt72QhfSST/UUMqDZ7oSHqsLT
	n4/Sifk7ibJs0EZcvLiTQBccN9iQ2Co=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jo5yLoeXuWuf+nAD//wcllhz2d3upNpzx7rbpTebLjU=;
	b=MHMkNh6l1HHnnf2qkDw5uL8XjMraXh75jT+VDPBOfMecYU914ZD49e9sK8NTvYli5kAuV6
	nUf9Yx7E1ajp7sc4Xt3plj3esosP4xzkmczSJx+Ag+R6xOHR/80W2eIOTH0qI4GHtjkgL/
	hA1IrUjC+JiJk//EQfKFtwK3Fh1gIGc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GMjAWx1h;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vabs8sQ743ZGCHulCD7Tyr3PE2I0M3OfV4DGVR2MVYpDf5R+Vd8ucg4mHgTtbwX/rmcFZolRnbZ/LMh7tY70fowawCHDisUMWsQeJsGRQhm675BTjPCtXsS9kv8P50G2bq1wSp9TkcYbc1SXDK8sIV6wT7qqhhbqbt9kGoILyUKtw3Ksb4tk9weRbPQ34gQOsOnYiGVbvztAc7ZiViQSt2jWI0rbNBuaiPzMtuqJYMa1s9G65E63AUXqu0WHL9BQx2+t9fdyMprEqLgFZpZRcoWaDuo3ot8VLribqUCFwPr6CSzCqnRbD1zul+Du8OA6Da9+CNCP3O7l5+IAXYoJdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jo5yLoeXuWuf+nAD//wcllhz2d3upNpzx7rbpTebLjU=;
 b=Pq7ke5/vaffFvyyY61Pfp9V3YsFktAl+mBxgjrvmFYbzco3A273FF80R/mAGHeKo+kOKANmn5caIVzniUEg1hXUiHp3f2QxqEgXuU8cDOLJ9RuiRIfb6xc6CEqxwhhKBlPGVKLBIvEOZAyHXQ8RfuyobTLTBfBaQCoWmHH/i0wIfwDJ3lLcn8/3zBa5RB5nKtINZmKPidK1+/ZNlgcVqK+WRNFIQe+HPczbbn89zhmjtEy2YcEKC+gjpf6nC4n3rl1CLE5fOvgktF0wofrFqd/aS4stAXR+cxiiY5WVMYoc+xgmoaoSepOWL9o15NXSAITS/haMdvhpCZpDrS6YhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jo5yLoeXuWuf+nAD//wcllhz2d3upNpzx7rbpTebLjU=;
 b=GMjAWx1hWtkjjGIsfjc3Rl109Na0duVnHmV93q6lk6d2hu4dfXLz5UM8nw/dW0lXnGCfEQW2Tz8OOYeLO5McIZsJ+GLQ0IFj2vd2nxHRpjhG+1e8NKdWI02E1e7W2PckW+7BDKA5JMHWXRIMSY/UXhZ1xHyfFdbzb+Z7yxWPyik3aImz9ljXtxANZ5uFO6BaW9Tbd1PtNflTqW/1ftP79dibLrICz2YwCSKt1hPt7r69KcwRp+D2NeHeXC/1FB62l9ZmLpsJUFZd5RkYIHBRBsEuBEZLjejdZywHVMKj5q3rVFx19HriK5aj7OYhkKft12bufJDaqsAIoj1mSIak0Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB9395.namprd12.prod.outlook.com (2603:10b6:610:1ce::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 17:31:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Thu, 2 Jul 2026
 17:31:26 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 02 Jul 2026 13:31:25 -0400
Message-Id: <DJO9J36YGJFJ.3FT7EBHAFZ7N@nvidia.com>
Subject: Re: [PATCH 1/2] mm: decrement MTHP_STAT_NR_ANON in
 free_zone_device_folio()
Cc: <ljs@kernel.org>, <willy@infradead.org>, "Oscar Salvador"
 <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>, "Matthew
 Brost" <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>,
 "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>,
 "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>
To: "Nico Pache" <npache@redhat.com>, "Barry Song" <baohua@kernel.org>,
 "David Hildenbrand" <david@kernel.org>, <linux-cxl@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260702172548.37075-1-npache@redhat.com>
 <20260702172548.37075-2-npache@redhat.com>
In-Reply-To: <20260702172548.37075-2-npache@redhat.com>
X-ClientProxiedBy: CH3P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1e7::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB9395:EE_
X-MS-Office365-Filtering-Correlation-Id: cefc28c8-fdff-4add-67c2-08ded85fbec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|11063799006|4143699003|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	kmID3InOUPGZRcOMT2DZqhgVp08cowxlAsp2B9N4omPop05CZ+ZuhrtEp+xSoF2f4TWN/JLQKYNqTo1ZzUft/hVJc1YIikYzMYnvKcVdyGT43P4+TfMYpNU/eLvkB0seWPOrUVBOaNcdN97aoZgcFYBkVvZPiiSXoecH8D6AlmiOBOUsSgNiBiOhenBPkeC+9Zvv8deoQl5R+ljE1vJZTV+kKVjSWpOhPScEj13cAdfSyCK4kvDLVPgXA1cOIUOFHm9x3U1f4YZLsWJsDffU+oBqBLvPROHc9QKecTpd9I+PoXDlwYwcOR0/NDaN1ugw29l5Oxt4RHeD1QqnkQaUAc57TvIMh+0H+h8kF5JRMzlbtOGq76zk9g2va5m7RWKnyPu6AHDfCEwFBK6TsnPEfXNrUm7DNBNhFIbUsKTONrBhwQW/KKiwLLxoF9qb6HOlEkAGjTzAe5AwwMX2xJ2WsoeJhBOrI9wuV1gYVTVKXN7ZoV+vtqAObkXlO78P+2NNiNq+7ZrU8t+/i/Lza+gZycUNbspMnCL/tw7gVdoAn20J1+3SOmlW35RRfH2X07jKeyih00rSFHrJ6QVPUoce8TmYzj9532CWB4KDP0HtaVz3S/R17HbCYnNxwyBz7AufJnIoEOIO4ZHC3Wgz+HrmMlX62NLDSzxswjCFb0gpqs8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(11063799006)(4143699003)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QURBS0FrMzhFMEdsNnNHT2RBQWlnVjJLNENnS1dEZEJQbGNabS9lZVVyaHVu?=
 =?utf-8?B?a1BPdW14WkF2elgybERHTmF2RjVoQnZrbE1kUjIxN0NvVitTZFR3QWNVM3JL?=
 =?utf-8?B?ZTZ2OCtCa0ZrY2pEWXNQTVpyUmYxOFV0Zmk5c2hreGNGM3VKd3lRVkZMOVlr?=
 =?utf-8?B?UlRHOEo2RzRtNmY4eXBQdWlxcTcrZDVRcloySGZMeWtYcytCejVFK0V3RDBC?=
 =?utf-8?B?VjhuWUJxOTh6UFZTYjgvS2hMR3k1UWYrZmRheVBIdnA5ZG4yZmI3dERaZkpM?=
 =?utf-8?B?RHp4bU9lclJ4b0dYRmhNaHV0aENSeStyMGFZT3VrQlBUTWJ4N3htangzN1pv?=
 =?utf-8?B?eGlNQmNSZWdHdzZYRHF3V3d5bkthekNxQjArbS96MnVDblNTZHBSMEJ2UXli?=
 =?utf-8?B?VnR5RUduSmlORzQvWTBMVG1ZMENaNDlJaXNDQ1JlR0Z1TVdjTURtTUhyZ09i?=
 =?utf-8?B?dlViaU5McHltbUpySlkxQmZvblV1TlZTSzBoM29jcGl4M0JlTnB4dUIzUGky?=
 =?utf-8?B?QUZyV0tMdkdseHNDYkh1K01QcUFEYjJHVGcrZHRqSnE0T3JNUHFpOGdmNldI?=
 =?utf-8?B?N085OWpWSGFqYlgwV3lieWVhSElYWnByN3dPanFmQ0RFemYwVGVxNUp3SDlj?=
 =?utf-8?B?OVBTNWhOYnc0R0JrYnhQcmE0SUl6VVNuS1U0U1MvaE5tY251S2xzbTlDNGJR?=
 =?utf-8?B?MEVnSXZNMEtvWExuUnNEV3Z2K3ZkVW51RWxWMzA0WGN0bFZXNG5WTmsvMWR0?=
 =?utf-8?B?RnZJK0ZnaEhTbUs2YWFjWE5HQlJBTmJFSEhmTE16WVlXdmxNd2JKdEt0QVJX?=
 =?utf-8?B?S3JGZDRyVVR6NmpENzRaQnAvdGpPZUsrYkJFUlFlWnZyU005dXpuRnlKUXU0?=
 =?utf-8?B?RmdpTU1iK3ZKb1pvZkcyRGpGTGNlbURueTJwTTlhRkVQWVl0WU5sYzdlSlZ0?=
 =?utf-8?B?UldRWGNrVjN5M0RvWWpNdHRnb1ZKR0xxcCtsTnJOanlTVTE0cXFCTkZMUWtq?=
 =?utf-8?B?bFVyZ2Z0TlJuQ050QmE5NHhCTGtMWDdTdFpiN09CV2N2cjA3MUVNbnFNOVQ3?=
 =?utf-8?B?Qy9zK2RBWUdvdU9QRjVmQnpPR3Z0SFdUbGVjNlc3MzVQRTFPdGFwenRBUWpw?=
 =?utf-8?B?SmtzZHFXTEw1T1cwWk4rLzF6N2hjb2NlRDRZdUJJQTFqODFVV3VjSW9NTE40?=
 =?utf-8?B?bGJWd2NFWTY0dGRSWlU5ak44cm5hcnVGOUk4aXlGUXBzQjdvb2NNcmdjYmtD?=
 =?utf-8?B?azJnbDdaVzFnVDZYUlppb0UrclFqSTQwYjllRGNEYk9nRnNEMlU3NjB1ZlNp?=
 =?utf-8?B?aGh1UGVZZk5BVUdrQ2lBNFpDQ0tHT3pHQXN6OE9FRm13YlZWWFhtUkUwZGh4?=
 =?utf-8?B?RUkzeE5pcDZyVnBTVFhBaE41K09aT1k5UVZEZkQ4QldDWkhPV2dBSWFnK0Ft?=
 =?utf-8?B?TE9WWEt5S0RYdi9JeTRRQ1BNQTdZRjhsQ2lZblpHazJoWDJsL0pJdEJObzVX?=
 =?utf-8?B?bzJJc1l2SlVlMHZVUnY2MHhGekVjQ05la0phem56VERkaDg5YXU4OEg0aDVm?=
 =?utf-8?B?RTBrc2IxWTZDR2ZJOWdEaG5VOTN5eHhjbDZHays3dmRGZFFnVENKeUpnV2N2?=
 =?utf-8?B?djZuOFNwb21JaVZMVllXdG5qYlBtN2Z2N1E3QlZST291QS83Y2Z4U0Z0cWFJ?=
 =?utf-8?B?a0ZvZFRWTCtGRDI4VlQ2b0hiVjFwa1FrcjVKWm1WbTNtdGI2dEMrczdjRXVt?=
 =?utf-8?B?NUYyNDJKYldCd3V4bVFEeDVKNVIrUEZkRGtDdHVOTzU1dFlFV3dVSVkvbzZ6?=
 =?utf-8?B?VFhFeGIySHEvN3kxWlM2eWZ6RGJJaTVCNS9KZElON3lmODA4QVZNazNpT2pQ?=
 =?utf-8?B?UThGM3E1Q1RTazJvSCtrRWVtalV2N2cwc2U3RGw2clF3N3RHU1NRenFyeStS?=
 =?utf-8?B?OGcrcHJUVGpWZjZFUzUvY0o1c3FqZzMrRy80Nno1MDBYeUhKNU1uQTFBbDJ2?=
 =?utf-8?B?bTE5R2R4U2JEekNzNTFpSjhOZk5tSzN1SE1DeVJuQUZTaG9RQ3NWQXp5ZDkr?=
 =?utf-8?B?bHVna00rdjFGVG1paEFpUE9UWW1yV0hQVk5aQTdhY3NTejRpV1pENHF2UWxQ?=
 =?utf-8?B?bXlrelRJckxlNGFYY1hqZFlxNXFhYVFTUm5jWUpha3F3QW5oRFJyc2tqQ0N4?=
 =?utf-8?B?cmFMcldTRkZYRGY3ZmRPdTdnbXdIMDZpM0Jpd0sxeUVTcEd3RW92a3FOd3I1?=
 =?utf-8?B?NGhxN3VKNnRydHdNRlBUOTdxQzdTeUNLQ2hqWExZZFlUeEMrc1JOSVoxT1hB?=
 =?utf-8?Q?GkzPhc4fP/k5Ur2uDQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefc28c8-fdff-4add-67c2-08ded85fbec1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 17:31:26.8193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GA3MCN8RJPYuRk1igE4jTlN+P/Cqf/Rx6Rjh1mrQ4eE26JeNqFApDiRDEdiGhBFz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9395
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: e9okjryj3qbhkj7py4tt97n9x6bzw6dy
X-Rspamd-Queue-Id: 35BB4A0007
X-HE-Tag: 1783013499-34706
X-HE-Meta: U2FsdGVkX18xf1SODe1K+mufclN7zY9TQ5cTNklKFBx+tJ97KIKiTp6/xJxCphhEPH/iuEnEWiwZDfHoLMLM7XiB9Y0Xog1CmsMcIYW1aZBWHFXlSVBfkMC3JEuVRuUOFCJIielOt011RaKq54zMHXoKfZX3lN9WmmaotAS752Z43M4Pjy3aYzT1xQ6Nx4mY7x2OiqmWWd9O3HGqSiJksw9Z9FB/qVAlPD6VTS8bDiLoB4KEB9b/V+D+gu0dW0OMDK71k5hohHZsyFVBraxWQvSyDSiX8uKBdBKZOpiXxwgA5UaWHUGUEoUNQGsTEOnqBw3s3PBbcRxxxNg0KRAE0Dmk9k3mxD0vzkoOnRWpZSbpia6DSTSbgPWeht4ypmvflM5xDmAkPicw4+6v0DjOEF7zs/9XCd4Lq/Sqp7g7OAUEk2MM5LP+aX8zGDur8hhTCd+72l+ed8TdewMuo4zF7J1INR9K10+AZwoz7XJ/tZxTYOTb7EbyzPTXDIK0o/AZh+St/XvlmjofP3g1hS+PEuPIu+AbNGNDj2bRVjn55+roaQ+hEHrDKhXnNgAlXLwwAQB0lU3ZoOwqgUzuJ7l7bLNGXhKEVqxDkdVokDnFAjn8f7r3TjEeLoP7PD9KQsIsUxRUXTOGBoJUpyZZDHJXaxMhkpBeO4n4SSQvCcTluL649V0Hi+ZnYwwAf059j9tffhz0jsGwOR85/JZP7338Xjt84zv7+0ziyzCEKR668cKpcWeqjWWpoX6bvpDiLGQx2uy526pSol2CROl5duchuyGVR7SLzDNJzv76xJFHvTACPpHDr03IUPTYsGyqLvaRdpUTR1VOqbDWIPs06wadUjnbFyDMt6pezBfqxfefZag/9+3STO7EkMOt+Vf2bxw0ZzqvsjUkVreJzFOA7NxFg2wZlsQhnBEKpprVH2qW37BS/Fy6ZferwBY/Bv6jmWAKYqdYyqYCWkUohqYw9Jl
 EHGfKckb
 aKLWetKBAoAQbDJIPRljFT+FsNffCLoVA03qN/+dIR4rNtEMBomdagl7zplUNij8VC6GGktOkjHLF3BabBfdVeU2uBrMzM19i/KD0tsqy2cB8hnjsNaWINeYeKZSEaVusZnfxpMwBl9Y7xg1h5YqzjMTxlskNJW+g7Ri3WbQzhPzp6UHZHHe9hWFnwWcT/kL/1xv9SJL7MNQxPMgEOxp9F7zA4zhKG+f/imIbDiQ8GPI3s4s0KaozagIxywrk6MBRgJlgzKEC4LvwqoQe0EPWy5cUKBBOi+r+VuetJWHQeuEh0LkGp8TiCSKAtGRH65lAt97nIMj2fdrYr3Z53kfP+rxWFHPHKU8mMclZ5/l5ztJ7dlQZiVpMIf+xBbYmJlC29xP/0sSZS/1aDpTez7fg4cm17ZDzLbb5YW2kN/1DE1lgqYl3ZQWQFHpWQKLXMrvrBljfI4TVc8CUTq5kO8qHZwJXE0SDdpjdCnlaaL2HutW3yv4KPwUosXG728h8rD2DCpkzxPmXidMs8IhM/OWnnSyBH1MuB9tGodjN55ZOySZTmPbpWHvb815PDrIo6d3theap
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 2, 2026 at 1:25 PM EDT, Nico Pache wrote:
> When a zone device folio is mapped as anonymous, folio_add_new_anon_rmap(=
)
> increments MTHP_STAT_NR_ANON. The corresponding decrement lives in
> __free_pages_prepare() in page_alloc.c, but zone device folios are freed
> via free_zone_device_folio() which never calls __free_pages_prepare().
> This causes nr_anon to remain permanently elevated after zone device
> folios are freed.
>
> Add the missing mod_mthp_stat() decrement to free_zone_device_folio()
> so that the counter is properly balanced.
>
> Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
> Co-developed-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/memremap.c | 1 +
>  1 file changed, 1 insertion(+)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


