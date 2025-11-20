Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896B3CF64AC
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 03:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4E5D6B0089; Wed, 19 Nov 2025 22:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE366B0095; Wed, 19 Nov 2025 22:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F636B0096; Wed, 19 Nov 2025 22:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF4EB6B0089
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:07:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 490C81A0748
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:07:24 +0000 (UTC)
X-FDA: 84129499608.27.D60E102
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010029.outbound.protection.outlook.com [52.101.46.29])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83F58C0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:07:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=niAEVTKm;
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763608041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EK4btPPY7g2HbdNv4D1dc5WjmP8kX/C3F+vSkC6551c=;
	b=ViauX/QXRhvmnbtEtPM3M8mKkumOx8WcFFRGvifhI7MStiTEu50ii/AHiUxjI1cjlmSBwx
	pkJSXYHQDElPcP2kLLwUbademOn7saV0uI/2UtBOjkHxUWXaGidXk22yp7m1WEt9OTw9Om
	9SyHwKXJxWMODWPBQf3r2IdtNXGyW9c=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=niAEVTKm;
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763608041; a=rsa-sha256;
	cv=pass;
	b=NSoe1zBVmJrJSqVa0QLlm22bKcxSoGVdR0Y+NSuE858JodW6UixigouoZyUJQ8O/XzERxB
	OGGNbiseSkjd+N2MkaqlCLUwG06bhcIKk8kxrwkcyukxnFm/lXwh2q6DRIT2VbiX2xf0kM
	P780CrlhieNyIMxNheIP7okSMTYmII0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e7j3ez3vo0Lp4iWQD7VAuJKRn5J97vXnTMZTpqYT5duSIOXcEnxAhv1if4j1APvmsJ0iF9TeifrPKp0hGlebqLTNIg7cmHiSpEqlZ5ZNraX/x14pAjAZuW27L96UpX/r35a50dXKyJIsdn6OQTjPe7dYXtmofQOy1lU2JPTLLF8pdnmkRPHDnncOUMAR4jQ4k1gMxbzwYWVSNig/AK5ka4XrdQZoby/69quppqxxJ90MhLrCJpKHkSnHYtpFed/cYypQYaGyrkp3jskAV4aLxh4lAmkVuH/rWrYWIjQCXvuB5f63Ree9Eb/WzZrcWWbL2QWHtKSPVFwTCvL4uZpiqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EK4btPPY7g2HbdNv4D1dc5WjmP8kX/C3F+vSkC6551c=;
 b=U6qwTaAtmG74ZNv4zyqsT7wO+gK1uaL3k0CD9XJz2/BvRvgIwrWnLi82MPX9ODOFw4YLypx98n3Ojw3C+YTcn4VVm949poYYysaBzETvUipUwxQPdjdepV9oSuXe5dgKxeV1U4fGMV6ZskNI7SPZG6vDB6+BbFslflkALs0sSc8Gc0XAwkDpCn5ldUS0dGBn3VBeKGYE3XXboh+n2sMX1F2BlsA+FqfsBkWTcA14slB385RkPdn39dAGtBjPgrVD1tqFwQ9eH0Ip207Lv7RSDYzcUBz6delE/za0jN1k9wQsr631Yb0iZXF84saeWAMSxq4YNXRQtOkJc0rWipkHxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EK4btPPY7g2HbdNv4D1dc5WjmP8kX/C3F+vSkC6551c=;
 b=niAEVTKmrInxqYz32IHQ92ZUf0bJ4nUdFuRPNAtdVVcV+pDnZIPl34tPxV6KKghHYCyJNuLq7CgONqQfLBkqxEQVwTlCLYowRpQI+oqIoL4+3ireu03G1XeSHPTuMgZtghlx+xiyuxXxvZWGOtqIAwYFBpQVm2D42L1uBs7rFz6qo4hu3lQg2Oh2yzo1jzKVbLVgibxaA8jI0t0LaZFo5ABlBnNQ314ewFaMZkvTyqfebrkUEOcA36HP5YI3xxrRBzJTKi+ylVGKgCkqibnXg5CmxhlH9Q5zRNJxugGnsBhrXzz3LWe/Px5daeXP57gawxSXMkK1tlZDn4LwgKMw8A==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH1PR12MB9598.namprd12.prod.outlook.com (2603:10b6:610:2ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 03:07:17 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.021; Thu, 20 Nov 2025
 03:07:17 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org
Cc: Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH] fixup: mm/huge_memory.c: introduce folio_split_unmapped
Date: Thu, 20 Nov 2025 14:07:09 +1100
Message-ID: <20251120030709.2933665-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P282CA0196.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::7) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH1PR12MB9598:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c635789-7fca-4dd6-5ea5-08de27e1e96b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MGJINVVVT2VWTHpRWVJpcER4U1VCS3VEUDMyMml3K1lpSFRlR1RhdmZzeGZW?=
 =?utf-8?B?UWd6b2hGbnVNdTRobldSMnlqTzJHdHpkU215NDJSbUdHUzhZQlZIeUUyQXJx?=
 =?utf-8?B?cEhGYzFzeUpLNHVLcS8vYi81RFQzQU1UNXpzbnk2ZDd3ZnNJRHYzK1dPRDRD?=
 =?utf-8?B?cEprbmhXeUQySm8yWE14cmozWUZTcFF2QnBGMklFSEJ6UmdUODlLd01QK2Np?=
 =?utf-8?B?ZTR2c0VTd0RFdWR4bFhad2p4Qy9XS1FiT215Q2VWSHRkRTZHN0p6a2R6OHlz?=
 =?utf-8?B?QzdFek5Wa1M3S1g5bGp2ZklER1o0Wkt2QTdmUDNDMzlLMXE3WXhsMENRSk1L?=
 =?utf-8?B?bmQ4ZEQwK0xDSUprRHQyZjVLeHJLMzgzd3dHRklBOUNKdjc2UGt4aXlOK2JQ?=
 =?utf-8?B?aUF3SFdQQ3pMWndsU0VqK3lXNnFxbTN6WGpsVVZNN0lheXNxWU1hY0txWWkz?=
 =?utf-8?B?M1lmRHQ0c0szeEU4OVNDdFYyLy8vbnEzcTVCMm5zaFpGN2I0VFpYeERTYWtu?=
 =?utf-8?B?Vm9JcHZWN25nZVl5dGNITE5tYS9nREJKQlpDNVF3WXRKbjhZM1FXT2xkQnY5?=
 =?utf-8?B?cXFLd2JrNENNVjJ5QkFoYk94RmorUVVLVitOVTU4Q2lSUlR0ajUweGQ5R24v?=
 =?utf-8?B?em1IZ21uZTRIU0NOUjdFVndrUnpDN2MzUUdQK0QyblEzeTJSWmxEaCtvcVlH?=
 =?utf-8?B?YjNyeEh2NDRiQTc3TEZXT2VJSEFSck9GeURRRWRLZkFkWkJ3SWpXNzlnMDla?=
 =?utf-8?B?N29MbGpDWldmOTltWXdvNU9xd1lTMFJQaUZ4OGZydlZxN1lCUWxOTWtZbDdx?=
 =?utf-8?B?czRXVTZVZVNrMUdiS2R0Wm83SExTNUdKdVR4dzZzSVJkUXRlTG9jQjFYMG45?=
 =?utf-8?B?N0o2SWdldmJiYk83aDdQb25heklvOXlQUlVFR3A0TWxnVTNPL0VyeHVaVWlC?=
 =?utf-8?B?MURneTZsbUd0OUljbHpxT21kWTZVd1ArWHNZZ2x5aS9CQzN4dmxkR2o2SW1q?=
 =?utf-8?B?MU1LMEVQaHQ5YUVkSG14TWpaU2hVUE5VS3RPMUFoY1pzbmhtL0gyNjY1bzVQ?=
 =?utf-8?B?dkFWcnZqM29aeE1IREZsdjJMcUpFR0FXU2pFbEUvZEw0YXlxK1NCNGdUU1Y1?=
 =?utf-8?B?dmNWQytVay9UY3FjTjVPM2pGQU1EU0hLMmxGRVZDbUJzNWZJRTRWVVF4TDlt?=
 =?utf-8?B?TEw5aHQ4Z1V5eDB3ZWFPNWhCOFN3SzZuUDFobnhDa1lJcjl1RlRJcEtoc0FZ?=
 =?utf-8?B?S2ZLc08zY1FXNGRlZ1dQK0V5MmpwZ09HSTNZWmVrNjAwck14QVl1QlZ0VHlB?=
 =?utf-8?B?TDdlRnlYKzVHMXVNTWdWdHk0cStRTldwcGovYUwyRVVBVHBNeU0rOE51azNi?=
 =?utf-8?B?ci9wNVNpM0NsQkkwYWtsSGVoYTh3S3Vmckh5bTJVQnJtdHFCeXBnU1FXMlRm?=
 =?utf-8?B?U3RpYTcwTlJxNVdFWHBoY1BDOXAzYzZPMXJpOGMva2taUGdzWE5Ob09jS2lh?=
 =?utf-8?B?N2VaR3pVK2c5YnVmbXZqcUUzL0FOcUJURGdSM3cyTEgvMUVDSkt3cEhNbUZE?=
 =?utf-8?B?Y2dmVDY5T3hISWlWcTdPRTdaQTBtTXVsNWJHWFpyVHhiS21jR01hLzhZc2V6?=
 =?utf-8?B?ZjlQUnZ1T3NEaGFvV05xNVFOYWpiT0hQSUFYOWtVcUxVUlJBWnpZOXRmTFlk?=
 =?utf-8?B?YWthZVNUV2RST0poMFdFdjQvUDRRUkZOK2FTbXdKUEVPRFFFUVZmMFNnWlpo?=
 =?utf-8?B?WUh0REUrRnhlTVVTbGhVUXBrZFllcHBvWTR2cyt5ZjQ2R0xLQkZ3MUVmNXM2?=
 =?utf-8?B?dXo3blpFQ0NKWlJMYWdVbDBERktHeGVZYkI1UHl5OU0rUk9SS2F1d3lZSS9o?=
 =?utf-8?B?eXFJTDcvOU81WVdCUjhoaGNEcGtRRTdwR0JBVWh5cnA1d096L0c4Q2J0b2NZ?=
 =?utf-8?Q?6ATECXr0/vseBDLTFsrx19sCR5HFK5cb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlZXQlpaakFMN2FLYXptd0dxYUZtcU85RmxRb0NOZjZPeU1LdVFmeUZRejRv?=
 =?utf-8?B?MVJiSzM0NUpwT3JHQkNFUXI1aU5reXVkVEFOTlp1cnB6N1VNQW5XenZhUUc0?=
 =?utf-8?B?YTNrVTI1SGxNakJJTEZBaHlGK0JQaXZidjFwQTVvT0FCNVhrdFllVWU1Rloy?=
 =?utf-8?B?UW8yYlp0TmppaHZ5RE1JMlNDTXVEUjIvbmN6MEhseC85RUVzWFpsOFVFOEhr?=
 =?utf-8?B?eG8xMk5KTHpURXh5WDF0U3pmd0F0TTVocTJaUW10M01XWk5hSW5XQ3ZvNXcx?=
 =?utf-8?B?U0EzM2hEY2xha3oyekFuVDNEaFNqYkdjRjNHR0F2cVJXZitVVitxTmNsdnVx?=
 =?utf-8?B?UGNLTmd0N00vTEdvbFpoYThYc0JoYnBsODV1SFJocmxQQ2FTNUVzWFpVNFM5?=
 =?utf-8?B?bDZHbTUxUkpxMFg0VXlpN2JjbjFmcTZpd1ZRQitLUHd6M1FUK0FPeklQQitU?=
 =?utf-8?B?U29lWkRKaThmUzQ1cjI1d2lEWHV6UVRjcEpWUjdzNllJZDdEUGhtZCtZTlRz?=
 =?utf-8?B?U2dNZTRnaWZ5UDM4L0pPeDN2aEpLbUt4YTJuZUVZeUY5M2VqSVdsYzQ0Kzli?=
 =?utf-8?B?TTBrTVZTTCtMdC93eVBCMFdmanZuNXNKWG9rWjNBVDczNU43YStkcDRmVkhh?=
 =?utf-8?B?WXlPMW5pdEhzZDgzWTg2cCszZnhvaFNxdXovd3JhazRWVXg5cGZEOWhoa0dJ?=
 =?utf-8?B?Zm5od2NMTHJhajVQMTI2ZUw4bnlNcmdxVm1pZWQwVFhjR0VoTlpQSjRMbEtu?=
 =?utf-8?B?Y1UybmE5RzhSVkY5d05tUEhCNjk2OWd4Rll1Nk44ZnpUNjRweUxvaTJKUkVM?=
 =?utf-8?B?MW0xNmMwWlZyaE9aeGJoMTR0dngvd1F2MW1UZGZsSnNHdzVmSHNSN3g5VEJR?=
 =?utf-8?B?WGxtWDJJZWFkQm9MSzlTNitTS21sdHpvcjNaQnA0V1U2Z1VITnVpTElDZWkz?=
 =?utf-8?B?ZW5MYW1hUDVJVXh2WWp2WDBlNEdXeXEvOGgvUElQcVh3aCtNbnJtQnY4eitq?=
 =?utf-8?B?OVlKNnVUS1cwTWRrL21OcElCZ0pwTm92L2RYaVJUQk9CUUh6eCtHNURhcUdz?=
 =?utf-8?B?blBFRVFHbmxZMTlVRjMzY3F5QzdFMkt3OVpaZE92ODZQRzZQVEhCeGVQZ1Ev?=
 =?utf-8?B?NU94YVFpckhBYk9jdE9DUUF6OXlPU21HcjA5aDVaYXVCYlNPMVN4L2VucllQ?=
 =?utf-8?B?NDBUSHp5N0NNMEtkemFwYldpQ0Uvb2FObEpsb1FiYUF1N0o1N3hIb3dKUFZW?=
 =?utf-8?B?TjZGZXQ1YVcrZmxTOTl1RWhxanFqMTJibmEzRWcySTRrUWhTY2dqb2pxeXlW?=
 =?utf-8?B?Smo5RGg5ZWg0MFJESm4wMVdXYVl1T1NJNUVyS2NRZG1HcEdONG5YWEl6NHVa?=
 =?utf-8?B?VEdTQmdObXI5NW4rbXJPdmhVbkdLdWFVMjhxTmxzVHNyWnpMK09ScWIxNlhz?=
 =?utf-8?B?TWM3Tm9QU1kzekJRK2tmSStrNFRMQWRvdnR6TklRWC9NMVQzK2VVeDBqdEhT?=
 =?utf-8?B?ejE2emFsUjJsRE44Yy9aVXkxd2ZZM3VYckZmR3BWV1VkaHdwZGYzQktvQ0VX?=
 =?utf-8?B?NktiYzZkNFFlQUFZSlRtb2pwUlcrYTc4V1dvUGMvWFU1Q2VSczdydTljSDJM?=
 =?utf-8?B?Zm10WTYzOVlLUGVrd2F4clBQYjNVNVpqRks5Mk8vYytBNWhPOEU1ZmNSS21u?=
 =?utf-8?B?U2t4enZ5UmFmQWVhK3JlRFg3Mkw1WmJDQVIwTHlZOWZ4MjhRdXhkS0h4YVBJ?=
 =?utf-8?B?RHZIU1JOanl2WHY4Ni9lUkxxTFYrUWJsTStBbERkT05GRUs0a05WeGw5U1Vx?=
 =?utf-8?B?MmpnRXJUR09GbWM0YWJlQUNGUEdaQjZCby9VVXlRTlFrYzh0ZFVHQm5Mc0xP?=
 =?utf-8?B?MmtHVnBYM3NXOSt1T2RRZEw5WTZ5Sk9relpsbjkrcTZ2MGdpUEtSV1FOQzlE?=
 =?utf-8?B?WXhRUmpkZUtCYWZndmR2dFpCZXY3Q2sxVHJqZWdUNUxMNU13bm5ocS8vZlM4?=
 =?utf-8?B?ZjF4VS8zQU1zdUZyR0VYMy9QRk5BSVdkQkFsaUxRd2d3T0FwdFBtRE44d1hy?=
 =?utf-8?B?akFidUhrdlJtZy8zZkJqUHd2V3cyZkl5cFBDMUtURUpoY2cxMnRveFA2bnJN?=
 =?utf-8?B?bEE3SlQxMHlTZzJQZFd4a0hoeUd4NDVnWWVGLytPa0p0R0JFOTI3eVI0THBI?=
 =?utf-8?B?N2c9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c635789-7fca-4dd6-5ea5-08de27e1e96b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 03:07:17.3208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESN3B3mC+G+kv1xzzj2gmYgjRE2LLnyZfNU/wS+C2/n/tgxBz/Zayi5MJM/RQ+YYRlEDCijLHSZPTp66XjhPQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9598
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83F58C0006
X-Stat-Signature: qodqrcgnciqpyamz8y7misax6h78x7zk
X-Rspam-User: 
X-HE-Tag: 1763608041-523440
X-HE-Meta: U2FsdGVkX1+5X+roU+jY/3JLOCzsgk06xmKK2pUjJCfSS+Gba34yFVy5nfF1AxSMQrRYN0wLopONwrd25lm2ax2DdvULwlkG1qBw6kryzT5UsOq1rU5lXDBmMs9OWqDlR6AdKH+LhVv8n/X5rY6fiHzhhLRDLqRvJsdMqxmDllDLnKNrn0by+ZGsn7SObCW38rHsvRd9WQ/9GNQA+aewsivm7NJJpf6icGsSAS+tHxTHlbMDJ0CQqvFUMxROeoadWnOfPjgSh3CMLWT6qbrz2mMe0Ch2/IaMlYt5g516ymFm3pCOUYHyJzlK9M+H/VcrQeEk5F1ZqhKJQIt/dXjSZTWdZKICbPPW3W3Krub9ehL6Tb5b5/4cS8RT1fX6L7vMlHK3I32j4ZuNAUneevnU7Vla5bX7uSYRcLI0/bxPo8aOLqHUUTjq8LC+wRA4hbhDQA6qzmt6WuA/XHAQ1kMcBLDo649EtaOENT16Sr0qWlDzUffV3FEeCby1XiLU1NDDd0ovAdAsI2+TAl8D8CyTvD7/almWBY0ifgK1sNRZJ1OcKE9CJ56y1QAImoxaYuudLSH/ilT/8Xz5bqrXQrOZIrL9gFKEwvB/Pol/7GcQW1Joe9K7UwPWb4Z4bnJDrZRRJR4OLRT1GwLZZfyklA8i+AJPqZ8fizeaQLIgSKTaxWyja735RswtO1SSIjbqRDIggkwN36pVTzpMag1X/nellb5V8TmI0vOksmUt38mkRgTPm6UFTEl+F8kd7J1sSFZfEqPknma+kXbcL/q5N7KsTcDJaAuZQFGKomv2u7pLLhxyaIBdwKJZMRnAzA6fc9cwztm9Lz4pN2eBjYNtnQ0fDX+XwiU/FGyLfZrD4POaeT/89Jc2XpMlR2h2GMR1E4SuO+nOIm8j/AZ4p7Ifz4AaWmvNNQj0T8nWK39f8YXC0on9fkYHzLMtz0MaA2vNM9zInGUFuE5r6zG3uhJ7ByH
 70y8dgIL
 21VWdKQFtKhwz5jExzG6l3Zvlph6VklN0kvjbZRhkYQXyG94RyUEmSS5NcPYTsBAa5d9fSIsQLRR1VGrgIa66J6mwAGKbXET+NoSeT/nfR+5U3Dc07PIKNKh64dLSFjEfzQ4WXs3QCfbRCwL4T2SOXLHsc+Czqw20jUspvOPtxBEsBUiZloQntSYdWeIDV9NVpBYKeLn7aTVE13NN9hI5McqhGlwsVvZrbq63bxZ4EThYLnR32u7ta1Yswj311W54AOzIt4Zwzf9KhjY5hbPE+OIXGsQwSNMjFOpUYWrAu2UToW0qM8Vhv+SscB/Tn9Y5mCfDB+U92BsXk/XMv6eQGnuzs2lsvJn7ilBgwmW1jKegPyIxslTPSTnAtN/zo4+4upoWTDhk6JTSWpdrfm8WIsDBci69AKTLUa5QhSMzoDAGAgHx+EtkH8v+p4qnXbonoEmKyc1fqZSWwnZXRO/JTIV37DTXu1HfkzAskTTSKnCVy3UFuvbdKllIfz4+0cOOOGzzo/W7W1MMlUf3EMAe7JCmzPt1GTz/BIvG5C04uTUWoAEnZRVJlhguDb+zVUCKr+G+WNatAc7NdAi+E3o2Xj5rhCqpmd0cqxzEJsnif4+tlYiuqvfqT95S3IUeGYtnDpxdfD2RfuviSyMAZDpblcj9ywgcYNRsHYiX/Lti4aBMpZaaORj5o3tqCYQplB3s9cRYkjvaT2wbXS0azIIFnhfo847ipU8LPXl5uaZQD8ULS1Hilr1bWY91D+eL64ohiFQ572bGjvzViyT/qmywnrJHLUAqhF0eCYGo0hbtTLUuwn2EQkqI2uyAu02A2Ko34AOPMkMTJLPjDziz+f1FxzPGIBFZi5Szk6PFEm88v31L0x4oPl+rwZDUcGMM4E79nUbSJOpqXRem8RCCTbsbLfAvGX+MA9nhmJeH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Code refactoring of __folio_split() via helper
__folio_freeze_and_split_unmapped() caused a regression with clang-20
with CONFIG_SHMEM=n, the compiler was not able to optimize away the
call to shmem_uncharge() due to changes in nr_shmem_dropped.
Fix this by checking for shmem_mapping() prior to calling
shmem_uncharge(), shmem_mapping() returns false when CONFIG_SHMEM=n.

smatch also complained about parameter end being used without
initialization, which is a false positive, but keep the tool happy
by sending in initialized parameters. end is initialized to 0.

Add detailed documentation comments for folio_split_unmapped()

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/huge_memory.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 78a31a476ad3..c4267a0f74df 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3751,6 +3751,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	int ret = 0;
 	struct deferred_split *ds_queue;
 
+	VM_WARN_ON_ONCE(!mapping && end != 0);
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	ds_queue = folio_split_queue_lock(folio);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
@@ -3919,7 +3920,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	int nr_shmem_dropped = 0;
 	int remap_flags = 0;
 	int extra_pins, ret;
-	pgoff_t end;
+	pgoff_t end = 0;
 	bool is_hzp;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4049,7 +4050,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	local_irq_enable();
 
-	if (nr_shmem_dropped)
+	if (mapping && shmem_mapping(mapping) && nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
 	if (!ret && is_anon && !folio_is_device_private(folio))
@@ -4092,16 +4093,27 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	return ret;
 }
 
-/*
- * This function is a helper for splitting folios that have already been unmapped.
- * The use case is that the device or the CPU can refuse to migrate THP pages in
- * the middle of migration, due to allocation issues on either side
+/**
+ * folio_split_unmapped() - split a large anon folio that is already unmapped
+ * @folio: folio to split
+ * @new_order: the order of folios after split
+ *
+ * This function is a helper for splitting folios that have already been
+ * unmapped. The use case is that the device or the CPU can refuse to migrate
+ * THP pages in the middle of migration, due to allocation issues on either
+ * side.
+ *
+ * anon_vma_lock is not required to be held, mmap_read_lock() or
+ * mmap_write_lock() should be held. @folio is expected to be locked by the
+ * caller. device-private and non device-private folios are supported along
+ * with folios that are in the swapcache. @folio should also be unmapped and
+ * isolated from LRU (if applicable)
  *
- * The high level code is copied from __folio_split, since the pages are anonymous
- * and are already isolated from the LRU, the code has been simplified to not
- * burden __folio_split with unmapped sprinkled into the code.
+ * Upon return, the folio is not remapped, split folios are not added to LRU,
+ * free_folio_and_swap_cache() is not called, and new folios remain locked.
  *
- * None of the split folios are unlocked
+ * Return: 0 on success, -EAGAIN if the folio cannot be split (e.g., due to
+ *         insufficient reference count or extra pins).
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-- 
2.51.1


