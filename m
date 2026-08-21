Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA0DCC5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58066B0095; Fri, 21 Aug 2026 10:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08DE6B009F; Fri, 21 Aug 2026 10:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8D36B00A0; Fri, 21 Aug 2026 10:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4F26B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:07:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E23B11C0184
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:07:40 +0000 (UTC)
X-FDA: 85125454680.07.060FE14
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	by imf04.hostedemail.com (Postfix) with ESMTP id D7CE240003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:07:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L1f7RP7m;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787321258;
	b=YJg5m+9vRD71lEW0OlQl1RSPZADNAB1BmoKEJ6JWqLevBUMMu6fAzjgoC0nSpNPoacmiFP
	onvzvu43c22kewM+iH3DWNJYUW6pong4289i5qLPEaVuBlxcoyWSeNjoaj6DZsro8GGjZ0
	96bS8gozXz8P/X7zZaDTp2fLy1uHzZs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L1f7RP7m;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787321258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFqxCmN6a2JfPCUCeVmO+GOt6njEaxwOJQyNTxlvRRg=;
	b=iENFBE54COTyH3raq1hh/mGObLrCml1voftg+jCegG99Uhbg2/qeW4oJa8TShbNJvMcXSr
	/pccB0VPPVluS6xFctePAmPiueAsLEZBe77AsYyWjANvY7yodic7m9n7/zbpff7GlZJM6Y
	W4BCPRaJBtWNxkWa3rFnqtiBRZCx4N8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cqu+rZsreWdGIDy2QnaOejFfYWgLSOh3ZWPaNIMz8qlnZAv06wkeNgccRlw4W8Lev5opGquEDLN8edu+Z8zCKBndS9ae7QtiTr1/u1VFqFwWYsQlCFNScTd7IYWYdMhgFFpBo3ZjDoztyc1x0iZ4AE0ZZBQoSv4G/J/x0GSev+BVjc6Twy0eVAzm3vdYEZzdpd0wH7NZIVdMk3An2c3HGZpIDX+KJRAyO2V9emrgKAGjICzEyyR5MoKYvly4H+38MMVI/+4nq2ufjvs7tNlC6nV06pv+2fPwV+SuHEmCv+bZ43Crcj/+nGMWcYK0KOCXBbbzfoTpBa2uIWVqjK1qgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFqxCmN6a2JfPCUCeVmO+GOt6njEaxwOJQyNTxlvRRg=;
 b=QHN66RxEd4yePgbSEnHrbadKQfLQj3O29ZB88HE4k11T2sv6CRczo+BPeguD8fAt3wbMd1uYInHmXqJ05NYfhUUMfElGFurMceghH+/V3I4ijGunR21TOirwX6pZ/rILn+xz0qWwyqRZhqUy809xJK4JZjRDtax2cztw2n7YQxPQhPKrKnRemnd7TnBUBbb21rsTghL5k7VrZvJCoHsbeLthv4hR0g4akXFVklK/e0CH2lVFHl08LaVizITsiOM+Kw5itwvRdHicA8UeyUpvYF9PW8GYxc8OFhd0v59QyEhZjYFP9DONrU62VqqffHN8WFvh+NJ7eJJRjotoPPNU1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFqxCmN6a2JfPCUCeVmO+GOt6njEaxwOJQyNTxlvRRg=;
 b=L1f7RP7mASfxt6ZKKNfxgJe8d4TKgfGY4KoWWwT+6FYCftOkvsV8GfPK12P4sM4eH0O2FnpVPPUd7eBWSjAeKOqoDIfgUMARXfZZqtIMQ/iOY5N8gJqO29mdoTeTrYGvQ85m+zICTZiJVtTTV0wuv3d+1q0OHkavSG0ZUwI4g1X2OsBjKtl4FEA9bAr4ycdcf2BwK5C4TeUApnV11o7qirnSOmAx7AwcZkMoFOU4dFFJrJs92BYl570xMrMbJq79EzT4PHnISEz9cgIPpcJl3fHjhoXBO6NHTkxT3UE8YxWSYV95qFHE+UCgMzfveH6EZ8bXgiXo38pL/z2Vb/XHLw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB7584.namprd12.prod.outlook.com (2603:10b6:8:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 14:07:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 14:07:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 21 Aug 2026 10:07:11 -0400
Message-Id: <DKUOHYOG0DVU.HEWABY0ZTEWL@nvidia.com>
Subject: Re: [PATCH 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-1-ab430c58c7cf@arm.com>
 <DKU173CETFYO.1RJA1CSOC5S99@nvidia.com> <aodwNr_zgOn55z3W@e129823.arm.com>
 <DKU60290OED0.12P9UF0Z97DND@nvidia.com> <aoeT20fPw57DtpGe@e129823.arm.com>
In-Reply-To: <aoeT20fPw57DtpGe@e129823.arm.com>
X-ClientProxiedBy: MN2PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:208:239::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB7584:EE_
X-MS-Office365-Filtering-Correlation-Id: dcbe94a6-3aee-46d2-ddc4-08deff8d7f58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|22082099003|18002099003|11063799006|4143699003|6133799003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	yMzzof/KG6t0hqtvK+AvkGy1T6xsl2NH3lmkwcKwme9w3WFbmggeG8Ns8WkFeSeY5Sy6AxUUdv/VYlX2/vR5b1Ly9cxbop+PqAQb9rHj+15LFmxwpystg4bZQyMBnKxgK0PJPu2JGrSNqJoqsrUYUSlt/VdccuXZ0BkUrRLHtWd/+uD4u8nLYTJFx24HsWboRUJxEm4VLH3etFFEKgnOUUMWKRDWNQRTTr6KnwUzrWF6Gzkk1V8J9cL5AjnqCthX8HjWzcpIL2p0tCJQ54dwbu+Ws1ghI2liqqcIpkqVD7+z1nOcNRlnI4Uq8nKFsnWGEmRke2N1PtpwxY8MDqX57ceTf+flDtOe2zBuse7a1DCjUhLqSvLcwlvaJY//Vmrzrx2USg/ePQDgJkRuDrRb+kmgSkzH05MkoFOeFbYrD4GZZDZeQJIIUbczLX8hXCqFw32tW24xCH1q6JHH3gXyiW+fLUW9yatKbHB4zoIKlXTUt8cGZqQe8fyxoCYgUopa22kbeNZR7I0xxxQYAhDf2XLWzttcBfBOcGNPcCSnv6GKFigDyjZ2Dvb31xwC81rxR9bgxrCiyxKSPiPZa9JpghW1meFiB0LWhXeZJmuvkkenoH3uSi4tKRHkObeWvVJvkaGqzhJdLQmu/jdyQb36K/W5YQ4JlfqRkRWCD8C4VOQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(22082099003)(18002099003)(11063799006)(4143699003)(6133799003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dy8vcE5yYlcySjZEdjFtKy9PZ2lkVys3K0RSczJNYmJ5ZngzNmJrNzdZazlm?=
 =?utf-8?B?cTcwWWV5dzNWelhTMTB1SWZWNkkvTklnVDUyUmY1Wjh0MU5BR1FKZFp5T0sz?=
 =?utf-8?B?VFBpdG80M24xTWhOSjBtcno5djVVUlBTcldrVytJV041a2FBY1FZWm1pZnZB?=
 =?utf-8?B?aUIrUno1OGlQWTJOUUdkVTZYWVB3bFUvOU1kdGQvSmdTOWowZFFRREtIOEFQ?=
 =?utf-8?B?ZXpCOVp2ZDN6ZW1uL2dQazErR3JyRnRZZ1cvUm5KYkQ4d1g0Y0NGdDdaTXJv?=
 =?utf-8?B?ZVltMFZZa0hENDZ3SHlvT3R6Um51TG5QYVVielQ2TFlmS2N5blU4VHpsTENr?=
 =?utf-8?B?MWFXQ2cvR3lvTmVkQ0ZaSVFvemVmN2lTTCtxeE9LNExqYTNrcGFBVFhoTG96?=
 =?utf-8?B?NG90K2hZclBmSVplS0N1OXI0U1Frd3Z1RmpqdFdZT1pGRE5RNjJhSGVOalll?=
 =?utf-8?B?MWZEcTErMHRIdERNbDlWK05MLzhIci9WV0lXRG9WZmdmZ0c3LytaNWQvQmNS?=
 =?utf-8?B?RVgzUTNSYW01aG1Ed3l4bTd3WjlMMlZhVzhKc3dIdGI5SVlGR3ZpdlM5WENK?=
 =?utf-8?B?ZVM5ZkFZZis1U0RydEpDby9zVjZST1ZzVU5ERVJrNWc0N0pwdjJYOHliTGFv?=
 =?utf-8?B?V1ZxcEFqSUNOTnpXQkFYeHBQWjAvN2R6OU95VWlZOUt4LzJZbDJQQ0JCOFRX?=
 =?utf-8?B?YTdWemV6c1AxVEN4ZHJwVlgrZStwNnJwU21vaDB2ODFpUDAvVmpPOWZXbHVm?=
 =?utf-8?B?cnJaeDN5c2xlRHJOUEowQ056a3NGT08wei9QNW9XbUpCUmtVWUlEVExEaWNC?=
 =?utf-8?B?VkFTN0hGcTRWWklnY2NCUHJlY2dhbzdxM1RIRVpweGM4TXRyakt4SjZpM1lu?=
 =?utf-8?B?M1hNV2RXb0hQdTEya1RUZG0zU3dVWFJBakNLNnBzbkM5eFVKdVpOVXdRMUtS?=
 =?utf-8?B?MDBLUHZ6eXNvd2owTjdoTWRRMzRNZmVGQUJsOFJvNUVIUU5iRkpGeWNrZ3o5?=
 =?utf-8?B?ck9RRytEOEFLNS8zL1crNEFCaDl6SU5abDRGUUpCekJxNnc3cDl4aThkdHh2?=
 =?utf-8?B?S0xQa1AyRTlZL0twaVE4c3VkMFZPZEp0SzdWUndvVzgxMWVrQ2dVQ2tTdXVq?=
 =?utf-8?B?bXpMOUFaYUFzKzhuczFtaWVpSGVsT2VCK1dLQjkxcUF4NjFoNmtWSnJ0V1J1?=
 =?utf-8?B?eThjckZSWkxJQ1ZMOW1ZR1NKNWp5SUtrSUpOaEVONWNHMXFjS2hrRGtpdTdw?=
 =?utf-8?B?WjRyamxvTFNlUWVrb0dsZDJoL0NtR3RsK01pbE9hOXZzSmZhaVlCZFU5QXJy?=
 =?utf-8?B?ZlVNWlByUENUeENLTXdvRFhuMURkbERLZy9VMHFnMFRjZDYwZWFVN2sxNWQ4?=
 =?utf-8?B?Rnd3MDZTaUgvMzErVm1wL0RIcElUSTVQblVaLy93WFhaOXQxSWlkMzFMa3l3?=
 =?utf-8?B?dHlnVnhNWk5tb0EvZGY2aEFzV2N6Z3JHOFVhV3IzMHI3R0FySVFVMitZVzhV?=
 =?utf-8?B?eVRCTnpZNE56Q04wQzY0U3RTSFFheXQ0UjZlYjR1b0VIMVRCK082SHB6N3NX?=
 =?utf-8?B?TkZLYStWeDFFVGxlZlhVY0NFVHNZZk1zeFY0OTdnZXBvOVQvRWJ1NFl5bWxx?=
 =?utf-8?B?eUx4ZlcvMGVHRU93VjJuaDF3a3BRN2JjOEVmeXlqZzFLbjg0RCtadmtjSVRV?=
 =?utf-8?B?OXNpZncvYStocWZqdmdQQ1ZCd1JSSmVvaTJ2R1lHcTlzcXMrVWdEaDZubm10?=
 =?utf-8?B?ckxzNC9OMW51dmdNTkNxZ2l3TWdQL0krbHdYSkJoQkp1UUJ1TDMyRGZtZFVm?=
 =?utf-8?B?eWdQdit1bktQR0U4ODF0cTBwdFdkcmJZdGJ1TDVXMEM4UU1HeXc1ODF0dm1B?=
 =?utf-8?B?V3lkUjQxVkU2QWRGOTdCZE84Y0NsY3VmZDFWTi9mbFFDb2xIdjVQTWoxLy9O?=
 =?utf-8?B?a1NIS0syYXVCa0MyUlFSRFVzeEVmdEpSZ0htazlsK1ZXbzFRaVdDbDRCMFhJ?=
 =?utf-8?B?QnJONnhvbkNHS1JuSy9vdVhpandCR1NVOWIwVnhrZm9YVXFER2l3MEMvVmE2?=
 =?utf-8?B?Z2xIcms0VE1XcFJQYWhUZDlsSGNVWDhOWHliU2RkeE01elBZN2s1SEhKeXVF?=
 =?utf-8?B?VEl3NUsvN1VFVHlleVJ1OHpmQUVxdk5BM1U5WFlnbk1wTzhBVitDaHNwR3o5?=
 =?utf-8?B?Vk9zZzg4aDdjT2dFSlBHaWtUOWlsSlZ0Vm1td1VKQUlwZ1RGNGI2eDdyWnZG?=
 =?utf-8?B?a2xuMEhqcFhuSjNwRXJ6OS9rRDlFdDVlN1UwY0RoeEpzQnpCVjdNRmk1VWJw?=
 =?utf-8?Q?mSm5k5VBEK/Ocp6CWA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcbe94a6-3aee-46d2-ddc4-08deff8d7f58
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 14:07:12.7599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNBepJPnZU+MEnKIlP0eJXKUZoH8/r9E9EpaWO2e/6D37rW/bw4GYZajC+LMVQlg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7584
X-Rspamd-Queue-Id: D7CE240003
X-Rspam-User: 
X-Stat-Signature: hziqoywj8haebcgitobcr176g6wdjk8k
X-Rspamd-Server: rspam06
X-HE-Tag: 1787321257-876148
X-HE-Meta: U2FsdGVkX18RjTSaTNckqRtDWrgNYbDeD1mtZPvP9F6AyMMzKth9+8GAKIv4EJ3/gEDoMSz/zcG1j3GKzT37UWbNBNLC17aC8cEpVpiAjzeEOO089EIARKLNAz8e/mRfD9WaaLnpfMr9gEqgqHk1SG4BrrSYQZ71yoA8pgJ8YI1asP5lEZKGqiPHGRQHP0/stqg3teHDRSbSUIaLjnpFZQ/yhjATziDICfF92cPvY4W5CsrDrl90l8ZlDUIiwuQFrRPtSXx3rbaKLT4I9wNkft31zGcEJa9gaKaCKsphqmcJSXrqSZyL4xRyyC6gGioQq+az1Raxo3sU4pS6emCYK0fFqZ64xsXHFX/sHg7RA/AYlff4tR9z8gGMAHWPeq2XoHujPG+IjjhYNO7GSec5mmaF4AHW0skh3zGoiUufx2uaSQgeuyV22Wc135LTwqTKp7JpgT87SicMS1iYqlAFQc5IHMJ+dcehy+pr1p/gtEYLNbniM0J2gSwqDHFuVWb8uJ4QTF3NT+7LySm/TLghaceDTLLxcTWcX5NhX1qJouxKL8b6kGyNJ+ZETa4EnOR/eq9iXV3Ur8ABjpuHP1mjN9onCa9QmSWO+4X3tzwW/R3lv0wo0Mx/WC7vj2vIgJFU5pipFfen+4fMYhMyz8W02yY61MFKttTtQpMHoifDRu0qdeurAWkpoIQ0nS/LY/ds94pz3P43YmnEyA8sgtbAktcoxGGVZ9oGE6OYIUpIybHACSGW42vXxNc0M51UIAx6mWO28AJpi+/6iK80KUgi2GUBwl+59EnWRAnm68K+2zVSTxYDAv8uVjA0+yzaR02XVdvC5WHWo4pzqDTPUuzq8SNgf6OQqzBZNRhbZODScnf8fPo2Fyv5n8vtvaam8zDuhV7YXHXK9GwlvWaLyqNkTMo6ShPeuo0gCLCqmdiaeCqFYLn7Iyvo5ijtd9+6hdnJbg3BAnaSROTyirz9O9s
 ZrrIzkYT
 cMx79p5B1McTvrO+gtejCBoC0iFMn7+QoPFKR4Yx5dI9xbgOzw4Fb8OG34aXzzXEtJo1DxvWuPVKynmRo/6nDau5kPjZb3ZM+YV2NDC6kZg2hmN3PJ+rZP0/jHCbsdwzbhmO/8Rzs/+gMWF9Yd7KWhOcFdcUBqdpg0BHUKVbmeUJ6UC5NI2vhTEXgbDkDzX/MPu34xWQSBZTIwzbNxVVy8SnGo3XUW8M3bDIyG8RfLXtsX/YGfkSq2QEHGDkO+nxj3hhApklFihOaX7vuLq7VjxKn9Yxo9NfNHaNye1mMmt6g6bfkUYT+cHJIrrYdxd23d5qBJwWT/U/40UoxYdnKm/8srsgz6KRGw15imCdmvQ2cojXu1WaTUqwI3qDNzbG+dzuhkgjb8cI+3VMV5W3uwlAlyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 7:55 PM EDT, Yeoreum Yun wrote:
> On Thu, Aug 20, 2026 at 07:37:29PM -0400, Zi Yan wrote:
>> On Thu Aug 20, 2026 at 5:23 PM EDT, Yeoreum Yun wrote:
>> > On Thu, Aug 20, 2026 at 03:51:34PM -0400, Zi Yan wrote:
>> >> On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
>> >> > There're some random failure for split_huge_page_test when khugepag=
ed
>> >> > collapses pages into pmd again which had split by the test.
>> >> >
>> >> > Prevent the khugepaged's collapses for split page by setting the
>> >> > mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
>> >>=20
>> >> Why not disable khugepaged using APIs from hugepage_setting.h?
>> >
>> > Well, this also works with hugepage_save_settings() and write the
>> > khugepaged/scan_sleep_millisecs with the maximum integer.
>> >
>> > I don't have a strong opinion but since it seems more hackish way to
>> > change scan_sllep_millisecs, I use madvise() with MADV_NOHUGEPATE.
>> >
>> > Would it be better to change using APIs in hugepage_setting,h?
>>=20
>> No. I did not realize there is no way of stopping khugepaged completely.
>>=20
>> BTW, I am curious about your khugepaged config causing this issue.
>> IIRC, khugepaged scan interval is about minutes and
>> the time between madvise(MADV_HUGEPAGE) and the second
>> is_backed_by_folio() should not be that long.
>
> Yes. it's relly timing sensitive and I've failed to reproduce in the
> real hardware. but in the emulation environment it often failed with=20
> the scan_sllep_millisecs as 10 seconds while the test running.

Oh, it happened in the emulation environment. That makes sense.

>
>>=20
>> For your patch, maybe you want to check the return value of madvise() to
>> make sure it succeeds.
>
> Yeap. but it seems enough just worning message for the madvise() with
> MADV_NOHUGEPAGE.

Yes, since there are huge page checks right after MADV_HUGEPAGE ones.

>
>>=20
>> Otherwise,
>>=20
>> feel free to add
>>=20
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> Thanks!




--=20
Best Regards,
Yan, Zi


