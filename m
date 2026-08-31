Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F904C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12FB56B00A1; Mon, 31 Aug 2026 15:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1296B00A5; Mon, 31 Aug 2026 15:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1A36B00A1; Mon, 31 Aug 2026 15:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 889546B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24DAF160227
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:19 +0000 (UTC)
X-FDA: 85162545678.16.A74BB16
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4CB2B14000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PYBid6iJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204376;
	b=oVpt9DsvbdOXiDfqaPSBJAhQqIP3h5wyYbgWgKQhPhU/Ngj8jv+RWfNmCDbJaVm3ED0CrB
	GgTTqMBQw8coQ5sfQv29jkWk080IunhMk46EBWcAKzygJ+1rOp7NoZ//sVjcga66p5ZK0X
	s4PD1n5RABpHjS2LbKd6N6x0DfmMfcE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PYBid6iJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9fPVkDVsEiwg5A3aIUFy0PO5BH27mCIZ5RprNl/2rc=;
	b=ML9P6KpVXS6LWt+p6JE4SIhD0b695NsqPJ4dCr6MELGebrMcgB13bnJjW/PWZLdiQ6GEQ4
	eGUmbtjgX+kYg5vdwc8Kcg7551pOKFUmSAeR8IBAXjrCylXTg+/uelVYPIFkh1au9eSiVJ
	MxvZ3jz+PLoQEhnQkDvKlSsyXLUH5Do=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IrBzxAPU+QwR2KhQfLprfz/gGJNg3WuD/7idTnOkWbXPM/XR0KnYzf9b1pl9fRyJB4thV1ZSamzERsuc4SEq0q1A2tVyRDOcu8x56eoLB8drxPYkycPQPyz4/6zoLMKIUQqMeMN3rFJWR+E4UzT5uMzuEzhUDEmcc/866aewbrhIRKBXclRYtplftBMeg6PpFYq9sNDhEC4JFlkFfH5eyFeucTVLxdB542bC0ZiaQ73TyCDhs1jrBezsCdH1YGHilzvPDFyJ+Qxr3uosTM083WFFUy0FICSLkPFVekR9DeP12ADbwdP+NZKJDeBQMXwoYjOZtGAanF2Yq0Vw0yW4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9fPVkDVsEiwg5A3aIUFy0PO5BH27mCIZ5RprNl/2rc=;
 b=feq9SYjnY/p9V6nn8Bn/YicX4vaQ7MMK24H3h8qaQwyfDLa5IVxY95Z3g5mO+dBOvvvbIyaVH/iXGGdtp4kF3M61vrxjC4cmGWtbHQSp0V4ZgdgB71d7jd66dZ53gCysuOQUvTk+hqANgy5Z/cnZigtKeu+ZGZTjjoQDeQCgL8CYSSEk42tcRdKEDVQKv6yh+HwXPGTlaKDO2eHkMcpc8stPpZzKq9/Mx3IVK3K/CaWHljelEG3nVzIutxruHclJq8wapuOJRple5XmlACVS6WlGJHfKPTVpd+ZD5wR4yMdQJIwTyW1tPprdMOPdPXMEWhYlKdt8eWahdVHCrOl6cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9fPVkDVsEiwg5A3aIUFy0PO5BH27mCIZ5RprNl/2rc=;
 b=PYBid6iJ9AW98Uv9fYnPYsm5KFNqvYK5d/tmEIOLOgYKr8qKJyDq/0AHUnE936C7Q3Wso18N3G1NP+qmuANhw3wxOzs4wF/Kvo/l9MmUeprwyGPc5p/gqf47BS4GyK1RYlVGQ2fBvX7nAi/X7M3qQdBGCZpEZvcZEowT9InRoYDct0l9azqJuGx2zAaqWHzQR2NNrYEPKe4wLDqd0rABrSVw2ZdIlRf33PgqmGXdmv3WHIQ22wk2fyZxCMn0jCiMZBK02WOfS94CKx52P6G9TcD2HHjR3cCvm5TXNywgJVghRx3KTBoNJQOwy4ekGZVmNPbwW/uY4ah9hWWOMVBBHQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Mon, 31 Aug
 2026 19:25:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:55 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:32 -0400
Subject: [PATCH v2 09/14] mm/page-flags: check page/folio->private instead
 of PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-9-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Jan Kara <jack@suse.cz>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, linux-fsdevel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBP288CA0046.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc2b33e-f5fd-48ba-d902-08df0795abd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|10067099003|5023799004|11063799006|22082099003|18002099003|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	ElGByrrL7Cl1kA97Gt6SHEiSssdqtgx6+mEOkPmfi8W4u+xdX4rdh93RMH4MJMmDEyGxC7fzprdS6EVALit5IXCgWsgE0A+XOR3I/nLEEbdtMfSCS44lRx6+fSutqpXn7nt+CUUr96NeqKyk0WSzw7JZSqkA7e302WDkwGXmtotAnD2ktkARLtThXOJH7kwNZOG3+I0eRAH2vhoopMvWCm3SBJY0VgRo2LLSxb02ydiVt2n3cNkHduAnYwMHkvNqECzGZltF+vfWu6Vbr2ksxDSO2zmCn/YbjeXsSbar0WaKs9Q0ciwSsp6toct0wD7Ntdo9tzWfIAMVuvhI1CizMc6aRFTmXwITddiv4nEabrrrIjpqr5Llvm+cUEKeamcprb34LCGa97W5iX5Xj02rNKSLEe8FGIwUNRUk8RBZM2sgSw97kERYDJBpL1wHNVm4CTFb3YkGszjTvgw/MwJkzLdwCoaYxJ74aeFRFJVo2nP2cVB5krk1WeeEl/fM5esKJP+z9iFZiyokG0HP5stmDNSfpbKU2gO0SikRaqmb4Xd5yYf+ve8TTVuI0rEXPJhcUoNqa9chW9uCC104Xf0xJ+l41vYNx13DBJVKgBzeZ/VRjy8PxfNsC2pHPqvzGrmFgJqh8NTBRR5fNPHAie1bpwaBtlF4bCTS6uJV2fe88PKR5thN+01gamXuIdgJjNWt1m1TkXa0L13hTyA/3vzgTQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(5023799004)(11063799006)(22082099003)(18002099003)(6133799003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2ZBbWRXcklNZ0NuTW9YS0g2OHpHdFVldnk2SHJYSnlVblMvWHRZeXNmcFlh?=
 =?utf-8?B?RUs2SFdTa0svMzhncjRFYUhEa3VuWFZTRXVaKzFKS1MvSUk2d3Ira05VRW5Y?=
 =?utf-8?B?WFNaekNKSUNoeU5DMTBvY0hwQ2RnM01PY2JHQmU4Qnd4QWNtTE8vazJacnpR?=
 =?utf-8?B?SzEySEJldURBcVUvMHZ2eHNNTFVjMU9ZWmdsanpmNTJrUGsvS2Z1bXFOWmNO?=
 =?utf-8?B?Sk55akhGZVJVb0V0SGF1ZDByK21URi9SWHJSR2VEcFNXSEp0Y1g2RlJSMjRL?=
 =?utf-8?B?U1YyUG1meXZtamlmQ203TVJUdjRITmxlbkg3alBPaVBoN25EUDFFNVR2Mk10?=
 =?utf-8?B?NGdBcGVMWGtXVjRJNVBqb0VscXNSNFpxUk9VNVg5Zm4yN0drVklMbGhIRWd6?=
 =?utf-8?B?d09DSXlLZUF5QjkyMmliMnFoTHpnVkZ6aHUvM2M5Skx3bXp6MW9VTVNTZkty?=
 =?utf-8?B?bkttRTBhSU9mQWJaSDBLVVRmQWNBcU9IMGdtcy9kUFVFdE56Y1JydUttWXc3?=
 =?utf-8?B?bUJBQ3JlOVpIMFBONzg1ZkdrRkNIaHVmWHpyYkdGQ082Z3dCMjNNV3pYUmlx?=
 =?utf-8?B?UUw2S1MyNWcwR25vWU5QRDZZaWRoWFpUTGVQQUZJdFJMT3QxZ1BWWHJqcFc2?=
 =?utf-8?B?Y0d3M2sxYW5ZeEM2MDZaY0hUMjJFVEhIWkNDWlArMHhXa3ZVUFYyUG96YWlo?=
 =?utf-8?B?YUpCcEgya2VtYkFaalBkem15aTRtQzVyNkNVQytNak5lTnY4aURoSDRTUnh6?=
 =?utf-8?B?SzlmSTNtdk81SzNYWWlDTkNHQ0N4ZVhXeXN3bFpWUmRoWlFZNk5Yb3lPVEhB?=
 =?utf-8?B?NGJJWlM4bWtISXhDbmYyam9XQVJSemtYRC9pM1VQaXZEUytmOE9JOUVCZjdQ?=
 =?utf-8?B?UjhvMzJLaVNPNFlWL2RLOUQ2SXpqejA5dFRGTVdyZ2d4UWJVQmZqUkQ2eU5r?=
 =?utf-8?B?SFQ4U1BjZURSaWdWRDg4a3htQkxYQ0drcFZUYkFQMGdhcVVBRlliUkZ5ZE4w?=
 =?utf-8?B?QjRZcC9sdjN1RTVMVVRoY2QrWWtMMUJjNlZRdXBjcFlHR0FZenRzbCtGaXgz?=
 =?utf-8?B?SldPKzY3MUhha2xEc2l6eFRIMVFsaVNhZUdLSTJkeGNteDFudFJDbDAvYlVF?=
 =?utf-8?B?SzNOMXVEMEhmYThwZWpiNzJPOFpDUDQzZTZZTklVU3FWM21SWEpzTE5Jd3NC?=
 =?utf-8?B?eUJpZVJRYnRDNFF5eEE0d1VudWZYbFJNdXNwR3h2aVNlejVFVTZvekZVQ0dt?=
 =?utf-8?B?Sk1xRDBoNkFWaGVwTDllRjE3L28rMmxWdWwrZE9HME9qNmlKUkw5VnJMeEs5?=
 =?utf-8?B?b3pzMzNlN2RwOEowa09RZFpvOHNmcGhBbmRML3pnaEFvc25ONW1aVmIreXhU?=
 =?utf-8?B?Rks1OHdnRC8vRXljUUhyNGxUSk92b1VudzduVTVBY21pWXpOelp1NnlPa2sz?=
 =?utf-8?B?YlR5MGxvM1BQM05VWlhDNDdvZlVHRy9WRC9BR0I2cTJNc01vV3gyOGtVSVJh?=
 =?utf-8?B?WHRwWGhpVEl0UTRUSGt0cVBwc3V0Zk41T0RQVkJKMi8xcUN5Y0tnNXR1a0VI?=
 =?utf-8?B?ODBRa01tT1RydFJDQUkzWkM2Z2Vxc2JkYXV2QW8wT2NYSkNjOHczVEI4OGk5?=
 =?utf-8?B?b2N0UHJpNzBpeVJtWHIyZ0duZ1RwQzhWUUVkUFBSa3BhbGNzM2pHOXBxK3hx?=
 =?utf-8?B?RWNaeGJLc3FJTGVyeUVlV1BqRXJBMG1iRENhSGJZdXYvYllyR0pCdTdmZjlL?=
 =?utf-8?B?TlZEOUYvbTgrdy9GcExWNlM1QnJyejAvYUd1ZkRjVk5GMVdPLzV0M3M4Sm96?=
 =?utf-8?B?K1B5SG1DYU9lK0l3eVRVdVRWOXdrOTNDeVhKK3kwRkFNRGdEU3hJM2MzeFFl?=
 =?utf-8?B?c1RSbndYbTNJVDZTWGR6RTNRbjNIY0xWRHluSHhYTkNLQ2k4a0hkbXpTODIw?=
 =?utf-8?B?czNBSmdpNnQvOG9pdXMycmlWazAzZDA4UmxxSTRoZmNMWTdSenNOUVVVUmdL?=
 =?utf-8?B?NStKUUdueVNsMWl3cHNLMGxDRkJqNm5ZNXRPUkVaUHlORUZIcUc5eWxJQkNu?=
 =?utf-8?B?NTJaOEQwZjNBVU9iZzllRGJJdkNEK0FXMkdYWWdCRElTbE9QbzlmQzlTSXRL?=
 =?utf-8?B?MkJQK2FvUFh5Wlk4ZEZlY0lta2ZleE1xZW1oazVYeG1tWFNWcWxVTnkxRGtP?=
 =?utf-8?B?QnU1aEJockowd0h3T285OVQvd3FyMGZrMUdaY3FrdFJ1WkZYS25mSHVoOGVn?=
 =?utf-8?B?dUw3UHRSY3g5N2UzekZ4ZStGUTB1MzRNTEdmSmt4UmtmVlZTOEREelRPZ0tD?=
 =?utf-8?Q?sng61tDcs2KtVR1YNQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc2b33e-f5fd-48ba-d902-08df0795abd5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:52.5395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ntwS54ZZp3xlBqOFghqrpDqiDfDrnLihengUAlJW9sPmNa44knjX2MH8RRGZp+E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4CB2B14000B
X-Stat-Signature: yi9t17apsit1485urib4gjqk7r7jqyfh
X-Rspam-User: 
X-HE-Tag: 1788204376-98921
X-HE-Meta: U2FsdGVkX1+gHCCzh09NTvFyuMw4JMfg/jCT++d3lrTmVPytheNYWmUWFw0vb5inkHH5BcokBsHsrYyTawcIvxArUiqI0gmF2ztl1ZQ/pKxj2tKjil0xjY15mkdGjHlZuMsex5zALNVFjYXdXuf+g5MAQCpAW8LveAcR+NPv7BYkJafYYrspiAH/juL4eQDKg9xQkrMhBToHXEQeJbKuYpX25dxj61eVfejKUYheGxtOkA75hmfwK4OKoBea3HtAQw2vu2b+QXJtYcx9UgNMRgQmqedm9MxI3LbmngflBLHQx1+0xJaGpbbKsOALHp7ccASf23yoJwJMOt7E0HTlPknelqL7AZ+RsI0QiMwpvRrlaTZMHxQsjhxvalY38hBU1qCwz75LmYExplH7WNBRpS1B2Axi9C0yCj5sDk5NYap5gdTCyZtdoHmSlp+pLkgsq6X28DQljJ+LzNdFGAZh3S6AZb6+eupkVXxhKNVZ3WX9YKxCGTeZDtSHkiHNeTBreslhKfkfr2Thn+Fs+Ef6FLcfK8zXQh2s/HpZWyGfLU0EFuTwI0EnjASnGtIhm26FDkF6u0IGQcfQ4kBEHE36Ke6+uaeGcCsa9hVZbJ69cJcw1qyHGypin09ZO6ud7WL6RCA0LxnWSQ3x6bfKe355yyQEgAGjTYXFg2QfMNO92hbRFWUCY3EoBvsYDSlJ2VGfTzAUDhWEMErDhq6jujuRoBu83M3iBRWih+eLppmMAFleOJ/Qem0lOA4Q2CO2HWFLLGXbZPeQCgArDTiVSbBp4cC817LsIqT4QTGnDgUr1qfhDAjJPHmzmTlKKOPRmpTNiVjVnT+rr4JfqzXbaWA4pK1oUglPRj1wm7q6+Mg5h9Sx6NMnS52A8JX8W3gyPpGnllReJoXhgzIBRZfhtelNrJgbc/d2/yolp1W36eMTQSYD50KzsUwThvSPvVS/njReWKofHNrzfg9zJPje/jt
 TFw8GPWl
 iAgegCV7PUc8L89O5xGfjja0u7zW7cy+MapJQlWzZCupLXbs4K9DeAwVVsgBP7m+aaYrKoPwmPD26+QSUzHP8QVbq8gOaXcI4wQ81g+ZIJnfJdK5KadhF11RFv9Q7XAzdDwHyxoJQwfr+ttP7fNWp9yk7f6WHbtyhlx1uuuBT0s1xL5f3vkltcq6VqZmVbIZ0MZT01PQ9MnqcWuRg0vj+LBJkKZzHyyEexdhjlWjTKup1dmOsw2FEO5+DxXPdMM3SVTPmme+bdsr8Mmj3HQ21UnApKVw0/L4bdoVozGxjpp5/dQNMtV+IyvNIR29XxWmLR6nEudBd9Vx2ypY3pYwBme1U83oCZtDMwU0lO3POSbY3ufgyuJA0ztDn6k4sgzwVr0RoMzFfXdRgMUbermRiWk/y7oGZ8LE97xH1CHNGbCaS2NRP+wB7o/+ARFpjLsAuGhXyFCYWSvwnzjX7G2icJJ21//7WZ7VzafwvZWVZpb5xmyor3rfSN04fA/gvbLFHveHNRL9RKun0EmzB2oBnVVA/Ovrk36zm1artIRmi1kPmbtRdZOa85DbOLPMsq9hQd875xTXg5qIzNkdqYdXwCEqSawowk5DHLA4aRlUWmMGk3EngSfUp+4OjoxpUJbY/cTiIYxkxeecAzU7pE+rRWFEl9rf9qBTO/kmA6QZgP+OQbSbR4ojsF2SZ3jctjm79SLbThIx2Ub6RsCfVHdiAUX2MmETno/0a+ECPBMkMDK4wOZY/EBnfO5A/8xzFsnfQ2VtbKDyMO/P2E6NTA5P13S7Z/X1dxBPbXR4s0p9novXRNSKUits49tpm3445N9fZvG7nsbtHjYm3KMfYVluAGeDaWHjQD5VWohT6IDJplv7sKaLG6cV1LZqaFdsbyyGjEJ7J6jxrMXA+pQ7a9cwmEzJyw+5fh5rgG3DCatd8l0iQd7MWhW6b1t1vtOpttAEpsah6yaFTg5NibDX84sR1XUlXbJvV
 M8K9PDM5
 mKCNE/e1KgKXRJdVd6n1nFaQdHhxPbKu4mIweQzNXb31Y9gqTNb+6WI5kpz8zrBS0vpub+QQDx9vn38fStMueKVyBkMe88LLKYZETl675yYuF169X32RIPfDbG01tpihitsi8dtzNjpXaKRqNuSODYeSNipOnLWL9+0J8G5YThAL3PiZftZ/HHqVzzL+BCN7DJWcqjsHvDqILz6RXOtRgM6SKYKUaDNLEa5lWl4IjQjrV2VTRbgdEwFapAlee92pLPtBIJeN6MsKqIkobhGEwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After the changes of the prior commits, page/folio->private != NULL is now
equivalent to checking PG_private.

Stop checking PG_private on pages and folios and use page/folio->private
instead, except swapcache and hugetlb folios, because the former uses a
field (swp_entry_t swap) overlapping with ->private and the latter sets its
flags in ->private. Exclude swapcache and hugetlb when the code is meant to
check PG_private only.

folio_expected_ref_count() can be called without folio lock, so annotate
folio_test_private() with data_race() to avoid triggering race condition
checks. While at it, annotate folio->mapping too.

folio_set/clear_private() and Set/ClearPagePrivate() become no-ops.
PG_private is no longer checked at page free time.

Remove KPF_PRIVATE since PG_private is no longer used.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
---
 fs/proc/page.c                    |  1 -
 include/linux/kernel-page-flags.h |  1 -
 include/linux/mm.h                | 22 +++++++++++++++-------
 include/linux/page-flags.h        | 26 +++++++++++++++++++++-----
 include/trace/events/pagemap.h    |  4 +++-
 mm/huge_memory.c                  |  4 +++-
 mm/migrate.c                      |  3 ++-
 mm/page-writeback.c               |  5 ++++-
 mm/vmscan.c                       |  3 ++-
 tools/mm/page-types.c             |  2 --
 10 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 260772b20bd99..f90e1030825e9 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -232,7 +232,6 @@ u64 stable_page_flags(const struct page *page)
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
 	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
-	u |= kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
 	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
 	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index 196778a087c4d..fe5ab6e50bd70 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -11,7 +11,6 @@
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
 #define KPF_OWNER_2		34
-#define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23e..786f8a47cea6d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3022,9 +3022,9 @@ static inline bool folio_maybe_mapped_shared(struct folio *folio)
  * @folio: the folio
  *
  * Calculate the expected folio refcount, taking references from the pagecache,
- * swapcache, PG_private and page table mappings into account. Useful in
- * combination with folio_ref_count() to detect unexpected references (e.g.,
- * GUP or other temporary references).
+ * swapcache, private data (folio->private != NULL) and page table mappings into
+ * account. Useful in combination with folio_ref_count() to detect unexpected
+ * references (e.g., GUP or other temporary references).
  *
  * Does currently not consider references from the LRU cache. If the folio
  * was isolated from the LRU (which is the case during migration or split),
@@ -3062,10 +3062,18 @@ static inline int folio_expected_ref_count(const struct folio *folio)
 	ref_count += folio_test_swapcache(folio) << order;
 
 	if (!folio_test_anon(folio)) {
-		/* One reference per page from the pagecache. */
-		ref_count += !!folio->mapping << order;
-		/* One reference from PG_private. */
-		ref_count += folio_test_private(folio);
+		/*
+		 * One reference per page from the pagecache.
+		 * Use data_race() since folio might not be locked.
+		 */
+		ref_count += !!data_race(folio->mapping) << order;
+		/*
+		 * One reference from filesystem private data.
+		 * Use data_race() since folio might not be locked.
+		 */
+		ref_count += data_race(folio_test_private(folio)) &&
+			     !folio_test_hugetlb(folio) &&
+			     !folio_test_swapcache(folio);
 	}
 
 	/* One reference per page table mapping. */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7a863572adce7..ee7abb3000c11 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -578,7 +578,23 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
  * for its own purposes.
  * - PG_private and PG_private_2 cause release_folio() and co to be invoked
  */
-PAGEFLAG(Private, private, PF_ANY)
+
+static __always_inline bool folio_test_private(const struct folio *folio)
+{
+	return folio->private;
+}
+
+static __always_inline int PagePrivate(const struct page *page)
+{
+	return !!page->private;
+}
+
+/* no-ops during transition */
+static __always_inline void folio_set_private(struct folio *folio) { }
+static __always_inline void folio_clear_private(struct folio *folio) { }
+static __always_inline void SetPagePrivate(struct page *page) { }
+static __always_inline void ClearPagePrivate(struct page *page) { }
+
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
@@ -1170,7 +1186,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  */
 #define PAGE_FLAGS_CHECK_AT_FREE				\
 	(1UL << PG_lru		| 1UL << PG_locked	|	\
-	 1UL << PG_private	| 1UL << PG_private_2	|	\
+	 1UL << PG_private_2	|				\
 	 1UL << PG_writeback	| 1UL << PG_reserved	|	\
 	 1UL << PG_active 	|				\
 	 1UL << PG_unevictable	| __PG_MLOCKED | LRU_GEN_MASK)
@@ -1194,8 +1210,6 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
 	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
 	 1UL << PG_large_rmappable	| 1UL << PG_partially_mapped)
 
-#define PAGE_FLAGS_PRIVATE				\
-	(1UL << PG_private | 1UL << PG_private_2)
 /**
  * folio_has_private - Determine if folio has private stuff
  * @folio: The folio to be checked
@@ -1205,7 +1219,9 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  */
 static inline int folio_has_private(const struct folio *folio)
 {
-	return !!(folio->flags.f & PAGE_FLAGS_PRIVATE);
+	return (!!folio->private && !folio_test_swapcache(folio) &&
+		!folio_test_hugetlb(folio)) ||
+		folio_test_private_2(folio);
 }
 
 #undef PF_ANY
diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 36c3a90f0acca..fb9abec40ec79 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -22,7 +22,9 @@
 	(folio_test_swapcache(folio)	? PAGEMAP_SWAPCACHE  : 0) | \
 	(folio_test_swapbacked(folio)	? PAGEMAP_SWAPBACKED : 0) | \
 	(folio_test_mappedtodisk(folio)	? PAGEMAP_MAPPEDDISK : 0) | \
-	(folio_test_private(folio)	? PAGEMAP_BUFFERS    : 0) \
+	(folio_test_private(folio) && \
+	 !folio_test_swapcache(folio) && \
+	 !folio_test_hugetlb(folio)	? PAGEMAP_BUFFERS    : 0) \
 	)
 
 TRACE_EVENT(mm_lru_insertion,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43a..546b37ccce37f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4810,7 +4810,9 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		 * will try to drop it before split and then check if the folio
 		 * can be split or not. So skip the check here.
 		 */
-		if (!folio_test_private(folio) &&
+		if (!(folio_test_private(folio) &&
+		      !folio_test_swapcache(folio) &&
+		      !folio_test_hugetlb(folio)) &&
 		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa7..f14e7bfee14bd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1327,7 +1327,8 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!src->mapping) {
-		if (folio_test_private(src)) {
+		if (folio_test_private(src) && !folio_test_swapcache(src) &&
+		    !folio_test_hugetlb(src)) {
 			try_to_free_buffers(src);
 			goto out;
 		}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eeab25d6ce364..4022d6c381896 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2705,7 +2705,10 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (folio_test_set_dirty(folio))
 		return false;
 
-	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
+	__folio_mark_dirty(folio, mapping,
+			   !(folio_test_private(folio) &&
+			     !folio_test_swapcache(folio) &&
+			     !folio_test_hugetlb(folio)));
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5c..ac275eec086b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -955,7 +955,8 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	*writeback = folio_test_writeback(folio);
 
 	/* Verify dirty/writeback state if the filesystem supports it */
-	if (!folio_test_private(folio))
+	if (!(folio_test_private(folio) && !folio_test_swapcache(folio) &&
+	      !folio_test_hugetlb(folio)))
 		return;
 
 	mapping = folio_mapping(folio);
diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 7fc5a8be5997f..47e4781c5fc38 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -73,7 +73,6 @@
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
 #define KPF_OWNER_2		34
-#define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
@@ -131,7 +130,6 @@ static const char * const page_flag_names[] = {
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
 	[KPF_OWNER_2]		= "d:owner_2",
-	[KPF_PRIVATE]		= "P:private",
 	[KPF_PRIVATE_2]		= "p:private_2",
 	[KPF_OWNER_PRIVATE]	= "O:owner_private",
 	[KPF_ARCH]		= "h:arch",

-- 
2.53.0


