Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B888BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A29F6B0088; Thu,  9 Jul 2026 14:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852AD6B008A; Thu,  9 Jul 2026 14:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A4E6B0092; Thu,  9 Jul 2026 14:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 491F46B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5AF61C7FB7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:06:55 +0000 (UTC)
X-FDA: 84970019190.15.860E883
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011025.outbound.protection.outlook.com [52.101.62.25])
	by imf07.hostedemail.com (Postfix) with ESMTP id EDD4140013
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:06:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=etSN4muc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783620413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EWADZkvN2fSW5FnoYQ1FTi9phbaLrUINnXe14nX6cUM=;
	b=BKkhTR6wVLIxwDgYvdzExFE+36kdNLpOnhFj4/RrVkeCWRiQO7Lv5ExHawJdcrPwh8o2Qn
	oWpcNCzeXRunrWZ/mquZqauMl+fQ4k2IuusT0bt0A9pLQXY3UAgjBMjplvIWmvSiWsMSou
	hcx5P0DwqtTMdNzZhPqUeVadhkHFLKM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=etSN4muc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783620413;
	b=4+oq4g4GdU3aNI0RPMMGY0XV+TK6vXI2NybMJQVP5jSNDwwgatVTIJ5hclltZk+NOcLVJa
	rDfBbIUVSPPU31Rlf8L+6xoeiu1brpNGd2mbSZZWtOLfSouuXIhbSAD3qWhM8Zn0GCM/ln
	hAk+ZGcs5GPLOJYCxDY/u+Uz3BTSYr0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSBBFdpRic3HUqiVXNPCFbPyH8lob1inv6M0pbDOS0URP8jzjQfyEqkbFU23Bs71rLTwyfyLbLFqI6pogPVMF1Lf/RR7YUulqGoCypWKO+Ih+noYIQjw6cVvHfQ0FG7g6LKKQZ5jSttiuZWf8xeh6nmcOuLLfqXob/BuFVFbEDJchJxsd+R6WV8hJr+soXXgnOvJjhNws2YJ7nJddiIz1sYFOMHp27zyycnngc81VIBqJVN9+eHQwA6yREEqo4s4ID6JDbWPOthBCHwuCp8846wjePZGLvfJ+bq4Vq0s+peJUSfYsJBqtkn2vtcKAav3CNraRrsnqsV0LdLjoLDmOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWADZkvN2fSW5FnoYQ1FTi9phbaLrUINnXe14nX6cUM=;
 b=rlTMOOfQCGOJNAkTplfalCcz2NDVz6LOQ0YuFUVE5bZihhLcPaYd5qDKpPLQriZnZSswCWOO7fv9cOPbLqFreLiQQ0BOarFI8JNMw11O4TEzI+cEZu7EbR/J1W97Vn54yuuSTQIHgvH3rUjv4SkT3Wdouehy1sAo8/4bA5hJhsdUehjEJOpGs2CGVkPK+V2Jja8teyN3yTcSgoY1RSLarEg2QVyE6uAinKNY54YR64avpxeWBnLgUmWTPxA01AoYErPbdw0TCUDYHXEgHI3t1d2UsDZQ+Lb1SHD4WHuX2J+Wm92TrsiiY69yDgCCR61qXOtv6QdUpZGKD/22OVOMJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWADZkvN2fSW5FnoYQ1FTi9phbaLrUINnXe14nX6cUM=;
 b=etSN4muc2+VHRVkya9DKvtBlwefIOnrcWbaUcWJBDp/K1XRBAcNhQa2TqAaoCjuhimCsTm6HM8xHvSCk3e3f+RR08CybPROU31Px/tR7vOl2vGnO7gzmkz/SB8u1tHYbfRf+Tn6LT1A9sZEpJXx7ryKKWMH8L4H8Ek6bek5e1Z7JknprH3RxPqEMvW2sXQK0zZpGvepm1+debASrfZWjy+sUU0LFqxQNb6hXVqEbCFHbRiMAdpIQ+0SBUwERYzqoan+gDCEJ7/bGPbOUTHQHVbAMKUrx5AyBoh7uFglVh/bLwrwnnDSQuA/vXsA+0LDZOCvkYevj7XuhBXHHdOtEcw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 18:06:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 18:06:45 +0000
From: Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 0/5] Keep tail page private zero at free and folio split
 time
Date: Thu, 09 Jul 2026 14:06:00 -0400
Message-Id: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAjjT2oC/43OTQ6CMBAF4KuQrh3TH6DqynsYF5VOZWKkpMVGJ
 dzdQkyMO5bvTfK9GVnEQBjZoRhZwESRfJeD2hSsaU13RSCbM5Nc1rzmCm6IPcTHpTf51gdKZkB
 4Y/BgBnABEYxAUaqKy8o2LDt9QEfPZeN0zrmlOPjwWiaTmNuvLncr9CSAgysbVHvFreDu2CWyZ
 LaNv7OZT/JH6lUPJ5lJudfcodba2vqPnKbpA8VrrIMmAQAA
X-Change-ID: 20260603-keep-subpage-private-zero-at-free-a1e1435025dc
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: MN2PR15CA0055.namprd15.prod.outlook.com
 (2603:10b6:208:237::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: 173592d2-9ba5-4f50-1a60-08dedde4d657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|56012099006|11063799006|6133799003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	cFcKPS6u/fjEVhABbo+Zi8Kf8fPDrU+f7Dofy2feuHs+75x9g4Y7aaM7IttcL/0MyQUggd3dWaiwDfhRn9w5KsNK7sFUF8dAPrwSkk9tawMPQdAiDCID2EF4ldXUJbdu5jMw40sweuWcXSnVDFZzAWW+qX4AoJ4JdM24oAgfcf4jBps7XPNaid0IPKYu/O5xKX9bivDIRdne+5p5zxoP+G6Q4RR/1tTqVTlqDbNdq0qYzdntctGJfAzdDXXJKwE6pYaVL3RYUtPNWxiPMphOfzErnPdHm7xTMATxVX0sWUJPfjZT0CkBR5bCmIG7+Ym/Qq7K9eXPsQAwA2lriaBMst4ep8zzbeEaiVBPPbzwrGrx+Y6DrM7lIt2eLyM/YuTIcQzUk/Bsyrr55QIGN2iTDrNkQcKzOdMhoS5HS/ESfBN4i0g+D40Ufd2zIlJFer868GMiPpcdEQhpyzrLMP+MVfzHn7tqXLyoZQvl5THbsI0fe1Lm7RQUUjtv1IPZvqGRyjwAduu/vQVSoC/VGAg7+x5/OcYjslj304br6bQGq/zqayCRgZl6qTpW0N7QkFqDxhd7lxKziED+x+VTthaj6KbiGi0GNstS+rlhAapjTr6KLj87FeQpqOsYxRmEdxpIhauwC5NKmaWFr9hr6jgY3EXMfiiXe8fkI/Kwo/trfX+R2wpKdsjenHapnLSeFwVlBqZo70WhH5huB4FUURvchQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(56012099006)(11063799006)(6133799003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHlhQis3WkkyRlNuWjlHKzZQUFpUMjNjWm40di82c1ZVaGVCZm9wYyszenF3?=
 =?utf-8?B?cnFPSEcwVlU5a2tlTzk1N1RyeWl6a3htUldCK01OaUhtak5hTGZaMzl0MU82?=
 =?utf-8?B?VjR5emxUOFNTZnpZMUxlM2hyQklub0NvZnlqL1kxUXZ6ZDQwSXdJTnpMK1Zj?=
 =?utf-8?B?US9wTTFPNGJ0VXI2aFFrT3Jab1E3Yk92SkNVc3BoMDNGWFVjVTBrNUQzOFoy?=
 =?utf-8?B?VlZiVCs4NHFNNmRMTU9adXZ2eTJib095Y1l2Wnd1YytpRGlSK1pQU1VSOVhp?=
 =?utf-8?B?Z1IzazhnSkt0M1dYRUlWNEdvcXp2Uk5WdHcrMFo5RzBhTXoxMEpkSm9IWlBw?=
 =?utf-8?B?RzNudDNXaVYzVkR1REV6NUpkYWRuME1rS0JweC9QWHVrT1R4ckdOZEVBMGRL?=
 =?utf-8?B?Zi9jdHBRQ2ZBVVdUVVk2bXVNSmxFeDhZUDEwY1RsQ0lQTE1mRW80R0FWSHVk?=
 =?utf-8?B?NkxOdkJoNHlaOEsrRFVmZ2JFck4velpUQnZua1BqZG5FeDIybG5yUkJYZVN1?=
 =?utf-8?B?OFlCd0orMFRUQkVHYldZcElPeU56amNJZ1VMWDQzUDJLOVRJMVpjSkN5UEth?=
 =?utf-8?B?WVAwK01CQkk2NXByOUFuZU8weGpxS3p6RXJEZjZ3YUkrckhkRlEwQ3JNbmR0?=
 =?utf-8?B?NzRDWWx6ZUdVV2tFYnNydkw2dDRoNzJRd0R3bjVwWHFsQS95NkFJMXRtcWlq?=
 =?utf-8?B?TmdxekJFY2pDOU9EOVpvWldtUDk2MFpuZFZJWUtsK3hkYUFSWldOTkVQSWdv?=
 =?utf-8?B?dEg3Vm92T3RmRlpRSFBiMmJIT0NEN3l6cTJzSHpkaGE3T0Mvd1luTU00SFQ1?=
 =?utf-8?B?NUtlTFhWV3JLUjJvZzY5YzBpdkNKU2tkei9kQjQ3b2FOZWI3TG1SZE12bkF4?=
 =?utf-8?B?VVIxdXl0OWk4S1pCWnRkMkthNjd0YlNVNTU3NG1IWEtUTmt5eHRrSGxGUUN0?=
 =?utf-8?B?c2Z6RlhrVlJqMThNaXB6VmZkRkxHdHJsQi9Lcm40UTI5cStRQkx0anNYQTQy?=
 =?utf-8?B?VlZvZ0V2aDNwZjVaZUZ1Vk83TzVOdUVJYitldzFHSXdBY1d2VzBrMkxFRTFW?=
 =?utf-8?B?ZVRNNlZvMTJvYUJtNXgxYXJ2T0ZlNEhuaG80aTlMb2w5RXMwb3gzZmRKbGJK?=
 =?utf-8?B?N0VSZ2lJd2dISmpucWFVcnpGN1ZvRmZlb21WMGpYRjR4ODFYMzNld2J1Lzha?=
 =?utf-8?B?V1k5YlFJM1JXcXZVMm5yaXBHSERndUZ1bkhrbmdnRStyMUZESVZnRDhVUW9C?=
 =?utf-8?B?dWZKQ1VBeXVXZlpBSzJaMC9Lcy8rTWRKR2k1TkpBNjNySWhsbXBSQzM1WFZ0?=
 =?utf-8?B?ZEliZXkrSHlZNG9tUFRUV3VwMStRZFowdWU1QnRvWnJHOCs2V3Q4U3BCQWRD?=
 =?utf-8?B?Uk5GanBOOU44dmRNb01HT2lKc2gzaURXcmlhLzhJMkhyS3NSOXBmOWNOYkhP?=
 =?utf-8?B?QXpGTGZqMjJYSCtLWG55NkJTalpEL0FnYzFQM1BiZkJPTVhxQ1JEWkFDV0Fo?=
 =?utf-8?B?STNHZG5vdEZCZ3VNTUVDRlAxbUJWQzVUcnpDQVpaVFN3cjJmM0VYVW9CczhD?=
 =?utf-8?B?NjBobFJkTlplWWlnZXpwNjBKRnBka3M4Mnl4SUMwSTRJZmpSMUoxalJmb2p2?=
 =?utf-8?B?Um5UaEEyRnYyTnVPRVdTMGlkRG43Z2laQXRTVVAwL3h0VEE4blFWRmZ4ZjZI?=
 =?utf-8?B?WTBheTlhb2ZKMWM2YlFOdG56cTVQVms0enN3eWxjd2ZxNGxJUjA5N0ZFdFpi?=
 =?utf-8?B?emtRUU01b0wyekNuN3U2NW9iblJGR2t2SHIyRFgrNE1VZENBSkVDTGd1azdp?=
 =?utf-8?B?c1JPUDNtV3FzUm1QTEFyOVJjN0dtaFBHSFFyNGVnNG4zd1JORWF6K3VJWU85?=
 =?utf-8?B?NlFUUnEwNUEvYVUyWVZRUllIZ1NvVzVtejBnRm8yUGVMNmYwU2lGUEN6WWV0?=
 =?utf-8?B?UThmZURGbVI0MFFlcTdES2JkMm5FMjBZQWx1WGw0UFFFTFphTmYzeGF4QXNR?=
 =?utf-8?B?a1ZWYlQ3VXc2bkVLelQ5QnpIWGlHRkN1MDZHTk1FcGgzNjk4NUZueFZ4bDRR?=
 =?utf-8?B?TmlEcjNJMVB1bFZMZWU5TjlBMW10d3NmSERENStVakhGZnlMei9VS2FsM0FU?=
 =?utf-8?B?OFZ3ZXpDWGhQZ05mV0N5QlVVVlYxUVhlOWY0eTdVUzJaZ0VDVEdSaWNGQktB?=
 =?utf-8?B?Mkt1MHBYRk4xSFc4d3FRZEdpbElRaTBDTC9OUGs1VmZoYXdaUlcrUmVXYnBU?=
 =?utf-8?B?TnFybC94amFGajVsNDIxcUFobWtnNUZKaWJwN0t3NU1IeVJNYk5jNWhMVHJk?=
 =?utf-8?Q?SATE3rvBOdp/+Ehp0H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173592d2-9ba5-4f50-1a60-08dedde4d657
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 18:06:45.3134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZPNs/OD8QZRmdo3YZ4q4bnZIvh7gBgNspCtTA/9oNSUlp8gBp5XbiMuOFgxvO9U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDD4140013
X-Stat-Signature: 7yox3zwaaf4bi3kgn83sbkuoimxgmdzi
X-HE-Tag: 1783620412-689629
X-HE-Meta: U2FsdGVkX1/ncceEdoMeF2GNpDFiDrzu6CSlRAf60SccFDjUk8FN/wBJJVHenAMfFwlTENB4kfZgM4C+SXGw6EY7U/rEnsNoJczEnnAKos5IuCXDOnLE3YOwJhznhf7GPvknU6AH4EhHWe7iC2Ict1JcS37abqR/ec0OAMJBaQ1Kh5zLDSGUcbOEKTMj+/kP1gnYW2MoRrE1KDyoFV9AgH0RRqOEIH1Uf0ufTzk1uw4cCWBnEBpdtwdorlTuAX924odSUuv2LZU2lS1GTo6UJIiXNpnPnduy64b9RwJQlFmXHSbVCDtVF1Dpy+2EL0KrgSCH+2372jnk4wzd+rf4OGkQeNAqqypjuu70OsugXdzOhQI77awjvRbf+1s4xx2uP/co6wjA/CKi+rndi9gXgJOaX6AUw9yjxlaODmH0ZVDVOTD+ckKmk+abTBIiuhctg6UBCawU2GxmTzzNCY6NE08yWYO5SZbA46SrbfJALpeQDfhwFI9aRjcPu0Y7vgzevR1cFLKvNJVkKuZOMVKxHjwq2n/DpJyA65t2RAL8EoedFrqMGQ/7GzNGUC3Le4Cvyzj4lfZn8zKFYjkb0VxAD6wdDJYJRWTEdSmgKRDiyz/v3xoHPgiTbwsSgZUQvl2cIej2hdOQqNX+/AwVka0BUs3OGaAch+qM+PvB/vz5tHfshx91R5P/wfgxS0HC+PVUT2bR0RNZUYWFRf8wt/POA8+QUNWS12Sg7s/8UhAaHcXVEATUGzpHg91HIa+E3uMbLQRvEf4yjwsFCmgMqwtx6DwSMZlwgq+yR9E1ETNKVGDq1tlYsoyZ73otcLRe6Jm7PeFMqyociWEQZTeKg8RkBVYBFTHyEzMwEQEUSVqYx3gAwQa0edUEP/QX2VLVBKiokQEo2lzbOqsVqmVC/F++uGitPGyVn3s94M/CEWs/O+emyR4XidT793gSHEq44mVPxSnFrA+QD4GDGaFdndt
 D8jQRuHR
 nP66gT7jZKzGCxXD2YNh4xfc32YhsoclKQCh3qFU3NBlEE0e+pIRWVGqmPwKjkcRODiSWcDGSQ64ARxD/SEZ7DtfdS+LUhYl4QMJdbX5qKz81f+ecnMUH+JsssQHxI8V/DAMMl1kur4qw5pqmv3r9C+uU5xCdhnAoPZhDtT4OqyX8TX8lc4IFOmeYYze2BQouDXJ+zWX4hDQqLjTQyGJMGQNWcmVBul4CavlEofA+5JS0ccszDDU+bWvQ02BbccCL/ERvB5E+iefFUtQFcY5eU0bVroTQSffwKx1M/ZyxvauJcbZfcRfH4yrVwPJI6YxXWQ95X6g47VMHGj8QLzc9it/Wi6SYKc9Ya6lMxnNSbG0OJgBSaOOJoY4CGt8A/w3M5YvY13xstyvbgzOhwFciLG+WQFZtEJ1oSfnyBRNPJ6FM4FHeP7BVTMT0Z5uTTRIRt8N0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset makes sure tail_page->private is zero before compound or
high-order pages are returned to the allocator. It also checks tail pages
that become new folio heads during large folio split, before their private
fields are used by new folios.

It is based on commit c7bf81a726b51 ("samples/damon/prcl: do not stop DAMON
for damon_call() failure") in mm-everything-2026-07-09-05-55, since v2 is
on top of it. I also replaced v2 in mm-everything-2026-07-09-05-55 locally
and find no conflict.

Note on ZONE_DEVICE and DAX page/folio
===
ZONE_DEVICE and DAX use prep_compound_tail() to reinitialize folios, so
tail_page->private was reset before this patchset. There was a concern that
after this patchset stale ->private can appear after ZONE_DEVICE/DAX folio
initialization. My reasoning is that no code sets ZONE_DEVICE/DAX
page->private, so their page->private stays zero all the time.
ZONE_DEVICE_PRIVATE page migration only supports anonymous memory without
swapcache, so after the migration ->private remains zero.

But let me know if my reasoning is wrong. It can be fixed by adding
->private zeroing code in ZONE_DEVICE/DAX folio initialization code.

Motivation
===

page->private is zeroed at page free time since commit ac1ea219590c0
("mm/page_alloc: clear page->private in free_pages_prepare()"), since we
concluded that it might be too much to ask every page user to free a page
with ->private zeroed. The holder of the last page reference might not know
whether ->private needs to be cleared.

For compound and high-order pages, tail_page->private can also leak to
later users if it is left uncleared. The page allocation path does not zero
every tail_page->private field, so they can be seen by new users and cause
unexpected issues[1].

Check tail_page->private at page free time, and check tail pages that
become new folio heads during large folio split. With those checks in
place, prep_compound_tail() no longer needs to clear tail_page->private
when preparing compound page metadata.

Overview
===

1. Patch 1 clears all pages ->private before percpu-km frees them.
2. Patch 2 removes setting page->private in compaction code when a free
   page is taken out of the buddy allocator. cc->freepages is indexed by
   page order, so storing the free page order in page->private is
   redundant. In alloc_contig_frozen_range_noprof(),
   isolate_freepages_range() is used to grab free pages from buddy
   allocator and it leaves the aforementioned page->private set until
   either split_free_frozen_pages() or prep_new_page() is called. That
   stale value without resetting triggers the tail_page->private nonzero
   check once set_page_private(0) is removed from prep_compound_tail().

3. Patch 3 adds back the page->private check for tail pages promoted to new
   folio heads in __split_folio_to_order().
4. Patch 4 adds a tail_page->private check in the page free path.
5. Patch 5 removes tail_page->private zeroing from prep_compound_tail().

Link: https://lore.kernel.org/all/20260206174017.128673-1-mikhail.v.gavrilov@gmail.com/ [1]

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Changes in v3:
1. replaced "it" with "a DEBUG_VM check" in Patch 3 commit message
2. moved tail_page->private bad_page() code up to the existing
   is_check_pages_enabled() block in Patch 4.
- Link to v2: https://lore.kernel.org/r/20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com

Changes in v2:
1. added reset page->private when percpu-km frees pages
2. replaced subpage with tail page/tail_page in all patches
3. moved implementation details from cc->freepages patch message to cover
   letter, since it is too much for a patch description.
4. used VM_WARN_ON_ONCE_PAGE() in __split_folio_to_order() patch without
   fixup. The expectation is to catch any violation during development
   phase.
5. guarded tail_page->private check behind is_check_pages_enabled().
6. replaced tail_page->private reset code with VM_WARN_ON_ONCE() instead of
   deletion in prep_compound_tail
7. the pre-existing issue in alloc_contig_frozen_range_noprof() is under
   discussion and might not be worth fixing.
   - Link: https://lore.kernel.org/all/d44ae8a5-ec70-456b-92a0-ce7ccabf6917@kernel.org/
- Link to v1: https://lore.kernel.org/r/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com

---
Zi Yan (5):
      mm/percpu-km: clear page->private before free them
      mm/compaction: stop recording free page order in page->private
      mm/huge_memory: add page->private check back in __split_folio_to_order()
      mm/page_alloc: make sure tail_page->private is zero at page free time
      mm/page_alloc: remove set_page_private() in prep_compound_tail()

 mm/compaction.c  |  3 ---
 mm/huge_memory.c |  7 +++++++
 mm/internal.h    |  2 +-
 mm/page_alloc.c  | 14 +++++++++++---
 mm/percpu-km.c   |  9 ++++++++-
 5 files changed, 27 insertions(+), 8 deletions(-)
---
base-commit: c7bf81a726b51f1ba9f197491e1e4c8fdf317326
change-id: 20260603-keep-subpage-private-zero-at-free-a1e1435025dc

Best regards,
-- 
Yan, Zi


