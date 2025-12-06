Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07642D3B7D2
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596606B0372; Sat,  6 Dec 2025 05:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E536B0373; Sat,  6 Dec 2025 05:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45CB06B0374; Sat,  6 Dec 2025 05:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31AC36B0372
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:22:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4AC5140481
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:22:24 +0000 (UTC)
X-FDA: 84188656608.23.4269606
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010039.outbound.protection.outlook.com [52.101.193.39])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5B5BC100002
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:22:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BL6d5MGg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of bharata@amd.com designates 52.101.193.39 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTyygqUebNbvg9QSWDmATgQVFkmSv6lNIk/to1GDUJA=;
	b=jSIcWAhkMU315CsES49Cq0YW7Y4DcITITKbPxLxs1f4NQkohWe6lZJYzl/8w9QJXbs7mJp
	WRTgEXso8fzSsJZv4jj94X8BVWWduvQiLy/ArmreCQQ1qrkL4jCfRU2NhhRGLEruGBujbT
	fbFVCLcq/bb30jySrci6zBZoiHiQFNA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016541; a=rsa-sha256;
	cv=pass;
	b=UO5XdCzezA1HNXyD3Rhjpu5gQxnMgylLc+QAwhXk2fYsfYNBwdTwUaU/3Gb4Zn8NcfXTp2
	ug1GG0IcetE61coo2utRI6QW7iyHHmd8TE4XwObuRXUpi6uiF4VOyOVJnctHiIF1lBKohW
	J6T1WzBR9mQB5bBoFVd11dNHMLH+hcI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BL6d5MGg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of bharata@amd.com designates 52.101.193.39 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nhKSf+7iNbtaxy3D2wqw2ojSMtUhKWxADkfH/uiIYeSZRHrCysa114Rc349XvWue8bczKAYUyGd0d4DIJsWPLEemZiRkdtsUvIF7mpK7K4qnAfP2j9wyyIpMq+qoyYiugSULyOLixZ9xyUUM96yDPIkzxbFPtkLJH0apkhLwIKtiYSZIbnQRAQlWJLlS/PliCACMT6BLPmCpkQ35O+MWXdpSVWlIabXwkvLQW9fzgJQCQOqSNLLpT0mwc5oTkYZq8wEwFrt5KDzvhboVWwkF9g2Wwdl9aSqY4uoAYdkScNWG6uEqmzuVMXd6erl3W41S+5HJ2t6kgYiVaGve5+TtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTyygqUebNbvg9QSWDmATgQVFkmSv6lNIk/to1GDUJA=;
 b=MLpQfT65EK2ZXJJdqpLdUwmgkkYeVwOWai0Ef57f8TGi8j9cYNZYYCpRJuSFVvMvildT5o1PQKq9KxFrbmnsHcx8cTNCVvxZ8ZvY+S7VWaY5ASwa0ZyCmXxhlGf3lvplv4TKzhTDRVrhtqu7cZQEatfUD5PKD0yvV29Axx28CXHiYD5h36G6p5cUJqiTkJoHaN2SAk93Ng1/nZSe4D+iFmVwE6605uljnTSwOm7uBPRE5k8T79XGnRssI4Gpa4ov1srDjPoG+baDlUM48+bCM35LKMNpa/J10QS2QHWO6JdtaaoTix7a36jNJWfsurYixk/s2pM4yxDbOKbvqxrZYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=samsung.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTyygqUebNbvg9QSWDmATgQVFkmSv6lNIk/to1GDUJA=;
 b=BL6d5MGgvowVWW+2XskEjY/pXFXvnrouP8mgfZZGT3UL10zfL6ssXAmZOytrmAdPBEvWBgs3mv31rVD83/81rB30kTajAl7RN2O96EjNOJRyJgGzLlN92PaGVYGelbQkWoez79QbtiNmHDufdV6h1oYtxIW4d9+3ZQPF3EU2GsE=
Received: from BL0PR02CA0032.namprd02.prod.outlook.com (2603:10b6:207:3c::45)
 by MW4PR12MB7333.namprd12.prod.outlook.com (2603:10b6:303:21b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 10:22:16 +0000
Received: from BL02EPF00029927.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::c4) by BL0PR02CA0032.outlook.office365.com
 (2603:10b6:207:3c::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.12 via Frontend Transport; Sat,
 6 Dec 2025 10:22:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL02EPF00029927.mail.protection.outlook.com (10.167.249.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:22:15 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:22:14 -0600
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 6 Dec 2025 02:22:07 -0800
Message-ID: <ff6fe9be-26db-4f7b-8f2e-339b8e456f6b@amd.com>
Date: Sat, 6 Dec 2025 15:52:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 3/8] mm: Hot page tracking and promotion
To: Alok Rathore <alok.rathore@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <shivankg@amd.com>, <alokrathore20@gmail.com>,
	<cpgs@samsung.com>
References: <20251110052343.208768-1-bharata@amd.com>
 <20251110052343.208768-4-bharata@amd.com>
 <CGME20251126132450epcas5p123220533572f40d70799294cd3ca4819@epcas5p1.samsung.com>
 <1983025922.01764165001727.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <1983025922.01764165001727.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00029927:EE_|MW4PR12MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: 595999ce-d77d-4634-3b09-08de34b153df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WU9wZzJrRU5ieFRtMkN5Wm1Od0Y1dnhSd3ZZUEFpd2lQV3R4OEFRV2ZkZ0xB?=
 =?utf-8?B?TjYvdG5yaUp1T1lBRGV6Z0x1ZlBLWTA0SEg3R2hxVEdJcjJsc3BDRkNhV0Vn?=
 =?utf-8?B?R0lxeXQvQVFRcjNoN1lTWStVVDZSa25BWlRmNUtRRkdERlJ6UzRBZjlHNm5r?=
 =?utf-8?B?NFllSjlVQU5XTXgrK0x6aXVmcTJQT3NpNUFPWURaUFNXU21hSVRENDFFWVlI?=
 =?utf-8?B?QlFhSi9nRHd3MXVJbGM5NWlXV1BmbVRtK2JYVGd6cjc2NllYYjJ1TmRTTkQ0?=
 =?utf-8?B?Rk9sWWg2YWpDRWxCdjRCb3hOSis3aWtjcnhmTTN2SGJ2ZTZ1YXpMdnZZMzIx?=
 =?utf-8?B?c0ZqaU5KVGg1VGJDRTh2THBoT0xyOHM2SmFqZU92SUtuQ3NQNk10dG1DZ2lQ?=
 =?utf-8?B?MmZOOWI0ZWMwQllSTGtGY0VJaVo4VTJ3dmJ2L09GL2JpSkkvVHh0dVR1Yi9K?=
 =?utf-8?B?OFNwdzBXU3k4UlhlMHNJV2ZRVVZqSDhkWC9qQXVXMmxIeXFXY0EvbUQxQmNo?=
 =?utf-8?B?dUJKd2hwaW1qeW52b2M0Ry9aajJjWnA1RCsyaEcya212L29kSlJaZEg5bmlO?=
 =?utf-8?B?eFVoSzRsVjJHUVJvVFN5Vm41V1ZVeHdJanM5dG9Tb3lvSWxuMkFrVzQrTXBw?=
 =?utf-8?B?M1ZCS1JQMVZYaUI0bGVqdmdBTHZ2TEdCSjBaOFk5SVB2c0dRc0ZoaW10U2J2?=
 =?utf-8?B?czhWVFV6R2drY0h2dXJBZ1RsaU1wWTVJRkVJOXVseTFsSlNRWFlWT3RuSGFs?=
 =?utf-8?B?SHJJUWNCS2wydkx1QW8zdzJBaTMwSjZNMmwvNjRhSkFCL0ZRNjlkckoxSVU2?=
 =?utf-8?B?Z0tCYXFZWFEvTlp6K2J1QnBSNmVQQzJoRlE0RHlNRURWTXdlbVpUenBhMkNu?=
 =?utf-8?B?Y01VNzFGa3R2UzM5WnpFSllSeWhKNHVyZTZwa3NnMjZIdWFKUjFFRmFEMWZv?=
 =?utf-8?B?dDRSS1RpNnlWeit1ZkVCWmdaVThKTzZQVHBVVG5obXl2OUgvWXVIV1dYZW4v?=
 =?utf-8?B?dzZOS1phcmMvdy85MGFoOTd6RzZ4TUxqTEFvVFhhK1AvYkhocWsrUWY1dlBz?=
 =?utf-8?B?TzlhQ1I0d0F1NjMzRmtLcEw3MktITDVESDFBaDg3eCtJbW12YVRwL0FOcDMv?=
 =?utf-8?B?YkpWcVRVb1FHakhWbVBCZnZSK0Z3Y3V4NjRIcFBMemlzcmp3TWcwQmcyL1Bw?=
 =?utf-8?B?dVl1Wkk3ekNhTmZKT0JWeC8vWTloeEtGdUd1ZmFTdDFwYUEyeE5nbnlvVTVL?=
 =?utf-8?B?eGNxNmFBdUtVYUYyVFA4K3pMMHlOOHpVdlp4SUNQT1BsRXVic3lvK0N5L1dQ?=
 =?utf-8?B?bWhxYkJPbnl3WnFNVkZLUFlqRWlWQlBJTms1cGNkZHZPS1cyOHNFaXBqTFZw?=
 =?utf-8?B?bmVjVUpEYUU2VUNaamNpQ1M5Qm9jZEZyblduWVVQMWdycVhxSzlsbzdxRmM3?=
 =?utf-8?B?MnNRZittQWZqT1Q4UGVYWEVuYTlPNHFFaExaU2RNc2gwaGFjUDdDVUJrWG01?=
 =?utf-8?B?cCtDUjh1S1loSngzbjA4RUNBejRjeCtZSXVzZGdlVlJaN0h1cmVsdVYyTHdP?=
 =?utf-8?B?MTZ2Z1Z2SkluTG1zYUIrc2s5b0xHNXdUeTUzL0Nwd1hkbXBiY2JOWTRON3Zv?=
 =?utf-8?B?V0YwYWpSbCsxc3hPQ1JtYm9ORWdxalVHSjBxd05XZWppbTR0Zlo4c0dhbTF2?=
 =?utf-8?B?Y0U3UnRhTHF4ak43M1J0VUIzOGRsOGlaRTgvUjNLclZoZDZkdFJlbTlZL2d4?=
 =?utf-8?B?Y1dpdHAyMjQ2KzdDTE5tbERuY3ZCK3A2eXZ1Z0RxekpaMUZCT1NndmRSZ3U0?=
 =?utf-8?B?cGgyWkxoMVJscVFZMGNZek1PWVlKT2d0Yzkva1IrRUlMLzJ1bEZaQkRmNmFR?=
 =?utf-8?B?U3UzY0Fsak5aRGg3N0xaMExuc2dpOHl1S0JaOEZRb2FwdTFXTHVIb0RSa2c1?=
 =?utf-8?B?a0dXQldMVzBDNFNYVjdXUFFLTWJiNmxneEcyS2VhQUxzMEdrblV1M3MvSXZr?=
 =?utf-8?B?MDBWMDJVSG1SK1NBaDhuR0M2U0UvNGFhZUFmdWxHQ1Z1cFVIU1JiNUdOTTJq?=
 =?utf-8?B?MTJiZjJ5VlF2M2R2ODJPOTV4WndkS0ptbXlrUT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:22:15.3766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 595999ce-d77d-4634-3b09-08de34b153df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029927.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7333
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B5BC100002
X-Stat-Signature: rd3fq8gpq4uqfrxwi71613n3xio6m9we
X-Rspam-User: 
X-HE-Tag: 1765016541-86595
X-HE-Meta: U2FsdGVkX1/FDcYCBloeqmDpE6Cg2EG+KWJjYIyEtF6mOuk8Z1V5RAXmcrLGlIOtWCcuj9qGsvp4NhVHbzXZzTHeNLpSL5V+97jD+M2+OUx8v8XR8u1oHeYkRTpx/aYQ612uZDja79HLcSrANQzLRBLjVjO3pmQbft2J4ywWErVekR7zpuFsr60XkU3OxLyNubUyjAM2MK8n4Q/MQNIrImSs0R8ZmjaN0V4meoIXd8kQr9jga+IYv3W23JjXR3dqdaURG+l8t2nU8uQnAuKDY1BiFNyO134dmbqYOaLO/71COVt+0G5KUtdHH5RvG874xYCWIegknittpmgjM86Xoxqg2iDagZViUOKzOCVeH82jeXGcDhXFfgAJNDFGa3CqC4o54O89LxFLpYUrtrjHAZDbUoJDw0EYPFJrH99RTauMMyRttNVl09HuveyMJNtXJ+FZ6HOwYXVJwyrepW4dVKTF7zZ0pdOuFFJsbwE07yPLdd+FMwGhbeEZACob80S3sNSrZDJb5Vl98JU1cq/kqluV2rfNp83Do57q8eHaVebarJqnt96SyfxSPv0NQYqNeJvcaR6IkZbmtkklyPW9axInkfcPTWJjOH+8ypoMSbpZcaoce0N+P4O8YwJs1++m6ar/fpY2X4skgqefPydo3CKfGxXCp8JNGTn/K9N4eI1Pr0RYZovMb78aAAamoOO3rbWjw/ybSAU9NsDottgF9YwoWBy0nYJxKi3v19UPef0F9H3F1mKEUcHQf2iA22aHjW9zmfqaD7wdOgIE38FXRgfHN3ADgGi5OhPyZBfdo4ZQh2wAg5ahz03v6Mxc4Pkigfv+5V1K26CNobxbYiYZzv+U7ALWjzyDJkdQl3Y4ujGmSpJODoV/fMyqZIj7tur4oWYuLlql0XBSpoedm3ugdwwAcGXs4JvYmcXQcVxuD32p+vPv9FDoKaolUSncm3fbkfFyc4F3Lfa/+7ZgkRF
 Dmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26-Nov-25 6:54 PM, Alok Rathore wrote:
>> +/*
>> + * Walks the PFNs of the zone, isolates and migrates them in batches.
>> + */
>> +static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
>> +                int src_nid)
>> +{
>> +    int cur_nid = NUMA_NO_NODE;
>> +    LIST_HEAD(migrate_list);
>> +    int batch_count = 0;
>> +    struct folio *folio;
>> +    struct page *page;
>> +    unsigned long pfn;
>> +
>> +    pfn = start_pfn;
>> +    do {
>> +        unsigned long nid = NUMA_NO_NODE, freq = 0, time = 0, nr = 1;
>> +
>> +        if (!pfn_valid(pfn))
>> +            goto out_next;
>> +
>> +        page = pfn_to_online_page(pfn);
>> +        if (!page)
>> +            goto out_next;
>> +
>> +        folio = page_folio(page);
>> +        nr = folio_nr_pages(folio);
>> +        if (folio_nid(folio) != src_nid)
>> +            goto out_next;
>> +
>> +        if (!folio_test_lru(folio))
>> +            goto out_next;
>> +
>> +        if (pghot_get_hotness(pfn, &nid, &freq, &time))
> 
> Better to remove freq value, it’s not used later.

Yes, can be removed. I am leaving it here just for a future possibility
of having kmigrated being driven to migrate hottest pages on priority
compared to hot pages at which point frequency value may come in handy.

Regards,
Bharata.

