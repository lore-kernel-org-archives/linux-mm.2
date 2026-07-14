Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8D0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE6E6B0005; Tue, 14 Jul 2026 01:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F976B0088; Tue, 14 Jul 2026 01:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6474B6B008A; Tue, 14 Jul 2026 01:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 260CB6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:30:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2C44A02B3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:30:48 +0000 (UTC)
X-FDA: 84986257776.22.4A156E0
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013066.outbound.protection.outlook.com [40.93.201.66])
	by imf16.hostedemail.com (Postfix) with ESMTP id CBC56180002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:30:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gguS7Wb7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.93.201.66 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784007046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mcNuxZFNx846+TBVrb6ozWyBpeDpYNRPTD+O/My2Bg=;
	b=X8/AMZd8HGfSlHP8ZxHxh0druYkypK5WyWYUw+3mBb9bvodmSQNrlrb2hgvQBGzx+RNDfJ
	mHLiyLudMxH1wfQ2ajfoHmz965uohbLKcGFPE2lpN7uOne8Blz24KnQzBa4dL7TZxjpF2M
	pae13p30xgqhQaF7fsGLejB2numez2Q=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gguS7Wb7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.93.201.66 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784007046;
	b=LJdAxme/GbUfSXDRkc+p8FekMFcXz3y009nHzkhU7wo2s+HJ5YguLM7Cn4nqcd/UGX77g5
	1VcCg3+p2eXd2Om2cEbubdoLOHjmzDt4Z4kiUMLxlBHHAjdz8rkxVEC8BhYVx1umQGA+I0
	/KP/Esy+KcScXqx6448Mu/C2vzH5Cow=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ppSsC/Hzo1lzaXFt+xXGhXmKTFeQQknSOUCoWO6M8B5iSDAndOoOjvfvju31ZuxTnXN4DC5PiKpeieUQoM85zLBa2NTeCTaluaBzmb4U/UaB0LYEd8oYEInM3qSMto3NrrQxjCmEDIKXtx2zR3W1tsyDZP/x0lExgGHK5YEpCe+GLSZ7xk0dqp4/4xikWShqA0YQPHdE0xSAJJw4GVtHtccsBtKd4IiolUNwv+iX+mNxh+3dH+NdV1yvZhsftVLOoFPua07e9FN5FlUuW+G7XZemmX1i0Kl2zR5dC/XYx1nEH+LDtskp6vmuwNVJXgJgye+VJcZ7GONZRFjl4esvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mcNuxZFNx846+TBVrb6ozWyBpeDpYNRPTD+O/My2Bg=;
 b=ZYLXl4Ok/bm8kXa3HQvxxBek7dkzDdg+qbaco3Ko15wtBA5gZkHAFHlSETxRjFr9+WxE77sVE7CcSVj4Wv8M4RMl96+3xbDORfs/RuhOuuM8q9wVgWfVFyDgn4ikPeH4jhQsXZI2h/hGfWL60kzW4l0jseYm+vclUC6lp+T8D21PDvIEwHaZr0XNV+6D+qsP0yEifqGwaobNYScmGxl7ItDuzZuKVnqGEzAzOfFLXErhX87ww2eh5vA7RzL5AfEvCQCdVPVLEyocA9hrR+04YdbPPyFdQmvukx6lMXO/SU7GxwU5eTNTOaRnUmGnuxt5ePGEl5U6zH8IGGIq/8Pd1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mcNuxZFNx846+TBVrb6ozWyBpeDpYNRPTD+O/My2Bg=;
 b=gguS7Wb7CP2ItiS0NjnHLOHEdq6ixFLQGMIhDG9To6LeVESXMf5HKh51Efc86MRQcOB6oIzKiknLGAZB2qUcXCKMC51lSBinzFef7Ix7gOTRm+ZsaL0i1WqwPDkQAo1YSjnzDjyiqNs0/8t7FfWrN9NNZgqTnzi5JNniShSzRKMA4/bov9438Np+BLzee9wIb+I16rVQ/bHbU1Mp4QNeU03dXNX8jPhEv2BnwjGgrD73tvrnmKtf+/TlSy3PsZIP+NM5Xd1RRpIbMG1nAauuEPE8cOJTjlgmeBtXl7C7xN5MDRB8EWAM/jfriVvUn3X1HcIpKKa0itdyQi1m7aRrvg==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 SJ0PR12MB5675.namprd12.prod.outlook.com (2603:10b6:a03:42d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 05:30:39 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 05:30:39 +0000
Date: Tue, 14 Jul 2026 15:30:32 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Message-ID: <alXFS7BJWLwH6Wpt@nvdebian.thelocal>
References: <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
 <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
 <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
 <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
 <A1606A10-AB38-4101-A058-8355E5E81C47@nvidia.com>
 <57cc487b-6ec3-4ca6-8735-f37644e2b0ab@kernel.org>
 <F14401B1-7388-4C5A-A19F-E031002A76CF@nvidia.com>
 <alVjyqWiAggf1mTG@nvdebian.thelocal>
 <aaab69a7-d1f8-4fba-be13-6de109f37348@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaab69a7-d1f8-4fba-be13-6de109f37348@nvidia.com>
X-ClientProxiedBy: SY0PR01CA0007.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::15) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|SJ0PR12MB5675:EE_
X-MS-Office365-Filtering-Correlation-Id: 4051a16b-0de8-4566-1b78-08dee1690a3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|4143699003|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FT9aUx84IR249KAan/PU98lHDANn8fns4xR5n1ohM0AzrnTV8rn28vK/GkXBdqtF8JTyyrWhy+Ds+lnrS7P4lo7Ah6ufUPLlK+zVndXahuoUX0uTe6hPHTiQybDIXIUvipwqDH3gNKGIIDdXot5gxdnPweHkCM/UzP0/Ly0wMi7BjjY54HuR4ElKyQhCEJvXh3Ssflo7+5xQpy4kPYZDyQcsKdxfJAvM2comk256kgnjwSd80UHEA/QnGBLUqsCbL4zfL8GhJJUaiCcm8pzFgi81mmN4cg0oAfDuDTZgpKydZ175xHKt04Ch7Nf0oqmhwcquqL4xc86H4lVq65l8o9GRKAOp411mKzF0ZSL+a93lTQAlQrHPwP+ExiFtERyDwgRjwk55CR+yMLakd++0HvQPzEWFLl/sqXKJbbvzgkoBavFwcF7ZX+yBIuoGAwcGzQw/g0DV0LU8QD36qt9iDQze1xdJRA2vUfgN96GIuM+ne576Se4DfRe6oiL1hg6YKqKxszgtis2v5Lytguo9wZuL+zOoCW6n37xRvIVfd3L5UyzN4VL2TAwukkuhXN67tVbhNRSXM446H7kzZaH4WxAYEV2CFRnmmEMd982Fa5VcVBFsYDkLcl+BVIo+y4RA8rdF6nhRS7D5IUqHtnHiYWEscw7vs/zWMdehMr4fskI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(4143699003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVRNcFozcnZ3eVVJMUYxZlRwSnlHRXJYSW9ZTldreEt6K1B6ZUZhamZ0YWtF?=
 =?utf-8?B?WHFRb3h0T1RJQ01nT3Y5QnlsZE1uV3JkM0dqLzJCU283RDVLRFlMNklxUWZL?=
 =?utf-8?B?T09GbTBrb2l6NEJ3N3hpSHFKQXczditWNURJbGN6QWsrK0xVVitvekVBSi9q?=
 =?utf-8?B?YmMrZmkxcHdjN2VNVlMvLzBIYWorbFU0R1VZVkxGTWtZVk1XaXJMdXBhVkxw?=
 =?utf-8?B?YTVNbHJxSk5nazhIcDh4d2w1c1hmZHJnMURkSG05b3lxN2REb3VSTUNHM0Vj?=
 =?utf-8?B?dXZKRkJqcnNTOGR1VTNZNkFnZmRyN0ZNcG94QklBY0FDUGFZOXAzZnFxcS9i?=
 =?utf-8?B?Q0c1dmVZTjUvMkZ5ZEhQUVBXM1UzcmNIbVRObG12dUJPZ0RnaXBrakpnOVVY?=
 =?utf-8?B?azBYRFZvSlZJM0x0TFl0c25NZ3ZpZGtBcGZOWGtaRUg4bmdjSEdVT25vaXZ3?=
 =?utf-8?B?V0tRcCtqdlpRQmlNWEw0UzRqU0l2RWVieUkrQTZ2SmxwcktlY1dwK3FpanVv?=
 =?utf-8?B?T0FqUStFOHRTQzBrc1Z0Z1FOREs5WG4vMXp3ZUVUbmhXVUZmWCtwTVBvY3Jp?=
 =?utf-8?B?WkpqYkdhTmJ4NkhKemw1cVJ4M1lOTTRKaUFBUG5PWlJ0R3dSdzBXZXJ1cWFM?=
 =?utf-8?B?cVBzTGI1UFJqcEs0cElYN2xzR25oRlJpUnlsUmJNV0ljNFovWUYxYVJ4TkxH?=
 =?utf-8?B?ZGNvb0NFdDdqVjRBdzBVNFBwR1U4Nk1BSGk3ei96YnE3S3MwZjJScFp5blpV?=
 =?utf-8?B?SnJkaTk0amNDRDdtaTY2U2tCbSt2OVZlQVZ2UmxMWEh1UlpLZ0Rwb1dLT1hB?=
 =?utf-8?B?ekVMZkxGSkwrUlUyaUJURWc0Q3ZUMFBTS3NDSldULys0NitmR2o4cnNoU1lG?=
 =?utf-8?B?RFY4U0ZWVDBSVnlSRDdjYklQQWN2MU5oQXFYSFQxYUhEdGlVblJZdEFrcjha?=
 =?utf-8?B?eVV5ZzZyQUNEOUNYSzE3V1pHMk5OVHdNTG5Jem15V3dmSnloN2d4enJWZUpy?=
 =?utf-8?B?RmloMkpYZ3dTNFlSNDU0MG13OTl6blEvQ0hxV2taM2dORGJTKzlkUFk2RWFp?=
 =?utf-8?B?Q0huOGd3V2tMVjNIS1VteFl2QXVTRk1XMmVCMSs2QUh2RTdSdEM5RHhObS9J?=
 =?utf-8?B?b3NWSzZYRDN1dE5DNkRkNG1EZmpuYzFaZVlBc2hSaVpQVFZsQ0RTK3F4bUZi?=
 =?utf-8?B?MTBtVGF5QlM0alUxOUo1M0JRcGdGN3hHTWloWUtBL25hYXpUbk83VnM3RE14?=
 =?utf-8?B?blRlMnVZTXF2Q0k5MlpnOGpvaWgrc0xqbVNuZzBjTWE5WVhzQXRxMEUxZzFv?=
 =?utf-8?B?WnFqTEdENUZsbTYvTHBLOW5qYmgrZ0FZL3V5ejVRdjZkUi9nSDVaMkxiSW1T?=
 =?utf-8?B?UTF4R21sQitPTDRQTmltbnp4MEY5UWl0SlZua05qaWxMaUd2SVAxa3pqTEk2?=
 =?utf-8?B?UEIwQjQyQmc1Z0RWWC9mMXgwU1QwWmdUWjZqMGp1OW5lVm5TTHB6VFMyNTUx?=
 =?utf-8?B?b2pkNHE4S010T3A0OTRqY1ZWekh4Tlp2YS9INlc1UXRSVU9seU13MjFXNlFN?=
 =?utf-8?B?VkxEOXFIKy9ETXdyR1RhdGs1WTJtck1OaE1IZmZjZTgyaFo2eVNKUVFmdTVy?=
 =?utf-8?B?K3kxa3ZHLzNYL3NBREp4aEJoQitzeXgrZVNQLzNRZUg2OEFtaE1hU3pxUzdM?=
 =?utf-8?B?K3BUVUZkeHpCM3J1UHdzSE8xcU1KcmFCaC9KeGtZd0tyR0NJelZ3SjFhZExx?=
 =?utf-8?B?ZG9GMjNLQ0RjcFRYMDFoT1pmbkpud3h5Sk9hUkRXWnRMOVIwZndITVRqS09k?=
 =?utf-8?B?VjRlemNzUHhhaFhMWk9zNWt1aVorOVd5RlhrQ1A2Q2ZsTVQwK2x2NDFxQ0dE?=
 =?utf-8?B?b2JaaGwzWlB2UW9MVHh2L3QrMno0ZXFHUVdmUGU1Vm5semhlandvNmlPMkxN?=
 =?utf-8?B?SW5lM3IzM21JaTRCL3N0Yld1ZEhZSkZrclRlWG9KWHY4L0NBK3k5QU82Nktx?=
 =?utf-8?B?am9CVGtFR1ZhUzl6dDdvZVkwNVVlT01nT1FtcnBlZHY3VEdmL3NlVms0YThO?=
 =?utf-8?B?T09RNWpXdzFKZndUalY4cVU3Ni9hUlBQK3dtVGxkVFp4S2R4NmJwcXlwZnNh?=
 =?utf-8?B?WTBUc1RMNGQ1d3FDMFRBRmtDRG1mZHRiSjczbVYrZVozMnRuUm9RNUJhRnNX?=
 =?utf-8?B?aGJsblZnTkE0L1VldVhyclR2Y1d1d0kra3FZdG14Tm5pSHI5bFl2VjBCWktj?=
 =?utf-8?B?TXQzSEJIbjd5NUxHc05SQXJvN0o4dkM5Y3hmNVNSTHFZdHV0cTh3eG1BTVcr?=
 =?utf-8?B?ejgyaytuaDVRQ3I4ZGpZdytBRllaTFQ2UGhyQUZsZGxLT0poamNhZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4051a16b-0de8-4566-1b78-08dee1690a3c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 05:30:39.6067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3/seLa1SLhSHbHQ9/qzNkLFSOagqvEqg+ObdEW1a+MLPrXdqaW5EVXXokjaSOulhJ4aK6RMA7v7ppg4eJOGeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5675
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CBC56180002
X-Stat-Signature: s73ih7t8uhd7o971rq7jxcnikmxkhtxe
X-HE-Tag: 1784007045-408860
X-HE-Meta: U2FsdGVkX18UOD5dGRJVJkatziMIoikUDQaMHAhj5ldsz3MdcShpdx4fKznBsNLGFNzjuIrl2s9zQw7GJSSxPT7GYMKZ416Yh036wPVjLmkkB0Aq7+/Tm3h0Z+PzU/vWItCz8Bz1kS6b3ltNF16FkI8QmtmfLlT5fOt9aUyBZdfAJGK6Lh799BDww1DQGQScQPo+tjZqVw1+fOONQAteh+h3yYzjcWczlcZWjdRq917dE2IaK1oPeWNNOQbXwpJo2RMxr2GuW1Sr7Gijcu6sjCEJNkczdQ4Nm2ZJu5gbq0b5xgEEUULqabry/vDMof9HJ/fwpXMYaAOuOYcKPxkU+NCbN+8DhK07QQzltivsQPJtsd1h2vzEmxSDkmiQE64fxl90VkhesQjW8wNz/Np7zkK42rHOAeV+YQ3ntLPhNBGYrwRkhSsd5yJaQAuj9rZ8efjnYiIIxeyR925t5pnc2yOCPjA062q8KN74mDjMDzFDqI8Xvd/XP/m+w7nyq6MLszgF5CYwI4+qDBTx1CNE+xnAZ8FOTxHLAuTHjCxz5dyDrxpE67MCaeAejBznLc2jF+ILzHhKj4YtxsIZh2Yr1iGJlj3ZpGXtCK+PLLEj2GadD+xKhTwzhwB167wPa7LG8aPSYkwhHRdFaYJMsHQfaxOwhjNK184SLIetZS2pg2VizABmBxDmeU6UsDiwPKlP0D+3I5YRl61sFLOtqOFpa1teZlEnl+P4/GQyi7aurWMm+/miifUlzK6aUUQJ53GQj7khmq1wQLjSmvCuiYwVDgCTJx0COvciGFt8GcjPUMdcnF1OYDs6hSAKI8GpyZMfr5IyuuD5zqvAwDs4FNt2/RUmxpuAvWpryBAlpHh/cyBA0e56Kj/knWyczdMHLRtX3K/lk/yJAnwU1TZsyLiz6TxXbIs4R1JNQLYJQY6/NaHClxwoqW7kvmRQHB/mMw90nsbKgQfTgyxKXv6WfY0
 aNowr1mF
 NUjF4exbHy1sADdyyfVul6TNNvyUlaiHHRNmme0mWhUFgiaTFZ7r2nENeS2GDI9rTQOifWGIiOtxAGIYiYtXJ46gSFkAK2jJSPWxSqzeEiRtHLxvzrB13rpBhrg055gg0aqWwHFoHwA5EG1i2Eg9Mnl7o0uG5Qxgp4YfNpu0tVKPRhy/NEhOTV65gXEdxbjyuVqFjYKTJrWlp+GGTWxB5pMZkRDmtIGf22NWeLCsEwh9juTnCkcOP0juM04R0JuScbz3+Hmosd23RcpOSGL/bhc6lTx4K9sN9NzSZGDSn/ZsfHDrwhPYTQhDDl0Mdj+pjJSUpUoY7AcJMg1VKu6hPA9AyDXEn2B+ueQpCf5dVb0j8Kuk7c9gQHdovOziU5pgO0UcQHWrGAPoAETFo4mMAaq82b4+rIlRc0qGIfHg9RXyhnOv+IPD60Vge7qbYTtLaMXCimt7E0c1zwT2u6Zl/GvUdeKMwF+z7XVbUzyuq/h3UNITRtq9csWTByJqs0nXpYwpNpTt51Owt9aRlmxEkRox0IIhy4sGOYK6K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-14 at 10:10 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
> On 7/14/26 8:24 AM, Alistair Popple wrote:
> > On 2026-07-14 at 01:39 +1000, Zi Yan <ziy@nvidia.com> wrote...
> >> On 13 Jul 2026, at 11:25, David Hildenbrand (Arm) wrote:
> >>
> >>> On 7/13/26 17:20, Zi Yan wrote:
> >>>> On 13 Jul 2026, at 8:57, David Hildenbrand (Arm) wrote:
> >>>>
> >>>>> On 7/10/26 17:35, Zi Yan wrote:
> >>>>>>
> >>>>>> Not all the time. After a folio split and PTE lock is dropped, there are
> >>>>>> different cases:
> >>>>>>
> >>>>>> 1. no page table change, the collection grabs the PTE lock and continues;
> >>>>>
> >>>>> Yes.
> >>>>>
> >>>>>>
> >>>>>> 2. some PTE(s) is changed, the same as 1 and the collection continues;
> >>>>>
> >>>>> Yes.
> >>>>>
> >>>>>>
> >>>>>> 3. the PMD pointing to the PTE page table is changed to either a leaf
> >>>>>>    PMD or an invalid PMD, the collection cannot grab the PTE lock to
> >>>>>>    work on the remaming PTEs, since they are gone. For the collected
> >>>>>>    PFNs (they are mapped more than once) and folios with elevated
> >>>>>>    refcount (they are mapped once and unmapped here as an optimization),
> >>>>>>    they will be processed later in migrate_vma_unmap(). Since
> >>>>>>    migrate_vma_collect() is best effort, there is no need to revert and
> >>>>>>    try to recollect from the beginning (to get that possible large
> >>>>>>    folio or skip).
> >>>>>
> >>>>> Yes.
> >>>>>
> >>>>>>
> >>>>>> BTW, recollection will be more feasible if migrate_vma_collect() does
> >>>>>> not do unmap singly-mapped optimization, since in the case, no PTE is
> >>>>>> changed, we just need to reset migrate->->cpages and migrate->npages and
> >>>>>> restart from the beginning.
> >>>>>>
> >>>>>>
> >>>>>> Right. The PTE page table should be gone and the original PMD, pointing
> >>>>>> to the PTE page table, becomes a leaf PMD or an invalid PMD, since
> >>>>>> someone changed it when the PTE lock is dropped.
> >>>>>
> >>>>> Right, so I guess we'd have to remember how far to rollback, and rollback would
> >>>>> mean resetting migrate->->cpages and migrate->npages.
> >>>>
> >>>> For case 1 and 2, we do not roll back. For case 3, since the PMD is changed,
> >>>> we just roll back to the start address and set migrate->cpages and migrate->npages
> >>>> both to 0.
> >>>
> >>> Can't we walk multiple PMDs and have data already in there?
> >>
> >> migrate_vma_collect() is the pmd_entry of struct mm_walk_ops, so it only
> >> walks a single PMD at a time.
> >>
> >>>
> >>>>>
> >>>>> And for the entries we rollback, we have to decide whether to folio_put() and
> >>>>> whether to folio_unlock() [fault_folio != folio]. That's the confusing bit given
> >>>>> that the code is rather "interesting".
> >>>>
> >>>> IMHO, it might be much cleaner to remove the “unmap the mapping if the folio is
> >>>> only mapped once” optimization, so there is no need to roll back at all.
> >>>
> >>> I guess most folios are only mapped once. Do we have any numbers on that?
> >>
> >> I will defer the question to Balbir, Alistair, and Matthew.
> > 
> > Unfortunately previous tests that I've done showed the optimisation is critical
> > to performance in the common case (ie. singly mapped folios).
> > 
> > I say unfortunately because I have similar feelings to others here about this
> > code :) I tested this a while ago because I was trying to clean up the collect
> > step by mostly removing it and replacing it with a hmm_range_fault() type thing,
> > but the optimisation proved too important due to unmap having to do another
> > rmap/page table walk.
> > 
> > I don't have the numbers on hand atm, but will recreate them just in case my
> > recollection is faulty.
> > 
> 
> I had a patch to add tracepoints to the code and some of that instrumentation
> included this data. A combination of the trace points + hmm_tests will help us
> get some data to start with.

But hmm-test already has a nice bandwidth benchmark :) We just need to force
the slow path. That used to be easier before I simplified the trylock handling
but with the below patch applied I get quite a lot better perf from the
optimisation. Note the patch isn't entirely correct as it assumes any locked
page was locked by migrate_vma_collect_pmd but it's good enough for the purposes
here.

Optimised results:

HMM THP Migration Benchmark
---------------------------
System page size: 4096 bytes

=== Small Buffer (0.5 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.097 ms        | 0.120 ms        | 19.5%
Dev->Sys Migration   | 0.061 ms        | 0.062 ms        | 0.4%
S->D Throughput      | 5.05 GB/s      | 4.07 GB/s      | 24.2%
D->S Throughput      | 7.96 GB/s      | 7.92 GB/s      | 0.4%

=== Half THP Size (1.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.217 ms        | 0.212 ms        | -2.1%
Dev->Sys Migration   | 0.136 ms        | 0.138 ms        | 1.2%
S->D Throughput      | 4.51 GB/s      | 4.60 GB/s      | -2.1%
D->S Throughput      | 7.17 GB/s      | 7.09 GB/s      | 1.2%

=== Single THP Size (2.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.290 ms        | 0.506 ms        | 42.6%
Dev->Sys Migration   | 0.095 ms        | 0.283 ms        | 66.3%
S->D Throughput      | 6.72 GB/s      | 3.86 GB/s      | 74.3%
D->S Throughput      | 20.52 GB/s      | 6.91 GB/s      | 197.0%

=== Two THP Size (4.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.634 ms        | 1.026 ms        | 38.2%
Dev->Sys Migration   | 0.195 ms        | 0.567 ms        | 65.6%
S->D Throughput      | 6.16 GB/s      | 3.81 GB/s      | 61.8%
D->S Throughput      | 20.05 GB/s      | 6.89 GB/s      | 191.1%

=== Four THP Size (8.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 1.301 ms        | 2.593 ms        | 49.8%
Dev->Sys Migration   | 0.541 ms        | 1.444 ms        | 62.5%
S->D Throughput      | 6.01 GB/s      | 3.01 GB/s      | 99.3%
D->S Throughput      | 14.45 GB/s      | 5.41 GB/s      | 167.0%

=== Eight THP Size (16.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 3.853 ms        | 6.119 ms        | 37.0%
Dev->Sys Migration   | 1.731 ms        | 3.354 ms        | 48.4%
S->D Throughput      | 4.06 GB/s      | 2.55 GB/s      | 58.8%
D->S Throughput      | 9.03 GB/s      | 4.66 GB/s      | 93.8%

=== One twenty eight THP Size (256.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 70.022 ms        | 105.921 ms        | 33.9%
Dev->Sys Migration   | 31.175 ms        | 55.393 ms        | 43.7%
S->D Throughput      | 3.57 GB/s      | 2.36 GB/s      | 51.3%
D->S Throughput      | 8.02 GB/s      | 4.51 GB/s      | 77.7%


Non-optmisied results (ignore the THP column, I wasn't able to test the slow
path so easily there so just skipped that bit of the test):

=== Small Buffer (0.5 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.000 ms        | 0.321 ms        | 100.0%
Dev->Sys Migration   | 0.000 ms        | 0.276 ms        | 100.0%
S->D Throughput      | 0.00 GB/s      | 1.52 GB/s      | -100.0%
D->S Throughput      | 0.00 GB/s      | 1.77 GB/s      | -100.0%

=== Half THP Size (1.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.000 ms        | 0.660 ms        | 100.0%
Dev->Sys Migration   | 0.000 ms        | 0.571 ms        | 100.0%
S->D Throughput      | 0.00 GB/s      | 1.48 GB/s      | -100.0%
D->S Throughput      | 0.00 GB/s      | 1.71 GB/s      | -100.0%

=== Single THP Size (2.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.000 ms        | 1.385 ms        | 100.0%
Dev->Sys Migration   | 0.000 ms        | 1.152 ms        | 100.0%
S->D Throughput      | 0.00 GB/s      | 1.41 GB/s      | -100.0%
D->S Throughput      | 0.00 GB/s      | 1.69 GB/s      | -100.0%

=== Two THP Size (4.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.000 ms        | 2.863 ms        | 100.0%
Dev->Sys Migration   | 0.000 ms        | 2.323 ms        | 100.0%
S->D Throughput      | 0.00 GB/s      | 1.36 GB/s      | -100.0%
D->S Throughput      | 0.00 GB/s      | 1.68 GB/s      | -100.0%

=== Four THP Size (8.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.000 ms        | 6.199 ms        | 100.0%
Dev->Sys Migration   | 0.000 ms        | 4.904 ms        | 100.0%
S->D Throughput      | 0.00 GB/s      | 1.26 GB/s      | -100.0%
D->S Throughput      | 0.00 GB/s      | 1.59 GB/s      | -100.0%

=== Eight THP Size (16.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.000 ms        | 14.260 ms        | 100.0%
Dev->Sys Migration   | 0.000 ms        | 10.457 ms        | 100.0%
S->D Throughput      | 0.00 GB/s      | 1.10 GB/s      | -100.0%
D->S Throughput      | 0.00 GB/s      | 1.49 GB/s      | -100.0%

=== One twenty eight THP Size (256.0 MB) ===
                     | With THP        | Without THP     | Improvement
---------------------------------------------------------------------
Sys->Dev Migration   | 0.000 ms        | 234.215 ms        | 100.0%
Dev->Sys Migration   | 0.000 ms        | 167.061 ms        | 100.0%
S->D Throughput      | 0.00 GB/s      | 1.07 GB/s      | -100.0%
D->S Throughput      | 0.00 GB/s      | 1.50 GB/s      | -100.0%

---

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 554754eb26ff..9f5563af8cd9 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -397,7 +397,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
                 * optimisation to avoid walking the rmap later with
                 * try_to_migrate().
                 */
-               if (fault_folio == folio || folio_trylock(folio)) {
+               if (fault_folio == folio) {
                        bool anon_exclusive;
                        pte_t swp_pte;
 
@@ -466,8 +466,16 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
                        if (pte_present(pte))
                                unmapped++;
                } else {
-                       folio_put(folio);
-                       mpfn = 0;
+                       /*
+                        * Slow path: couldn't lock the folio. Leave the PTE
+                        * intact and collect it anyway; migrate_device_unmap()
+                        * will lock it and use try_to_migrate() to install the
+                        * migration entry via rmap walk.
+                        *
+                        * Keep the reference taken above for
+                        * migrate_device_unmap() to drop.
+                        */
+                       migrate->cpages++;
                }
 
 next:
@@ -605,6 +613,16 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
                        folio_put(folio);
                }
 
+               /*
+                * Fast-path pages (folio_trylock succeeded in collect) are
+                * already locked. Slow-path pages were not locked during
+                * collect; lock them now so try_to_migrate() and the finalize
+                * path can rely on the folio being locked. This applies to
+                * both regular and zone-device folios.
+                */
+               if (!folio_test_locked(folio))
+                       folio_lock(folio);
+
                if (folio_mapped(folio))
                        try_to_migrate(folio, 0);
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e4c49699f3f7..3a673181b9ad 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2936,8 +2936,8 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
                        break;
 
                /* Test with THP */
-               ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_sizes[i],
-                                       iterations, &thp_results), 0);
+               // ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_sizes[i],
+               //                      iterations, &thp_results), 0);
 
                /* Test without THP */
                ASSERT_EQ(run_migration_benchmark(self->fd, 0, test_sizes[i],

