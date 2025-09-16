Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD15CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D19E8E000F; Tue, 16 Sep 2025 08:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B708E0001; Tue, 16 Sep 2025 08:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16728E000F; Tue, 16 Sep 2025 08:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D8EC18E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:22:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F9241A00FB
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:16 +0000 (UTC)
X-FDA: 83895025872.17.3CCE80C
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id 31EDC4000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gusJhDR4;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.15 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4Z1JGU4KgRYcKflrtXzYaSY6matRUuT2y6jsKDdqeM=;
	b=S1Sj+I3dU/elY2Kznkeii53dVhCZ021no3wZx+VqVABUxqG3GxTFBZev15Uo23dqv7+MEY
	WlIfrPN683LgEcLGdU+3J7bpKdW4Q+/UhuP3AGcoIc8QczaXZzF++KRJeigSePzw2zs9Eb
	8GA/Yj+nmEYMCF7XHDKT6MAIB3VdmH4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gusJhDR4;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.15 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025333; a=rsa-sha256;
	cv=pass;
	b=mOTvlTgZklD67CZ5BWcFqg/bhvRDf5HHKfpgGgVV6zVZ3lnXwvbnBi2wbYT0YYENU6zbYM
	oY2/kLY65ndCpE5gmGyGJ2ZpIqfMfkS3Ow7Y07tR7cIofxUkDnGFvL44/hqnISzjiz51SN
	6YP1AKY54lsJeMwCShaia/l63L8A/zA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F80E/r4+lxwTMNtORvLIDH8VSSXlmbCozFbGI5otJF60K4xkMJyO9I2NpR/0dPuSn5Ht8T8Mlu4jf0wbNb56u3w4bmoXh5PIhoOMC9PrON1HxXnGG56USrQF/ic06rZV3L2INORylKBd7EYML/QWCI62izL3qfO3iEIUdXFymezlBMRCY0exR/eyFqYKbphwPPPFTKf++uTVfQxVj96uM5tQf8WLzo0fOKvSH/al3I/bkbPiTb6zrbvdSZQ2C3sX9c0PSdOohkLSXD0Wg67sXiq2+Swgy7b0F7kUcs9N0LQ//eBuzhipxry1vbs/Jegf6PHGqQ9rq+3vC1zm+ADe2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4Z1JGU4KgRYcKflrtXzYaSY6matRUuT2y6jsKDdqeM=;
 b=HKdebTQvEqYkRqQvBqKv57BietSelqBg+IYapZxPXXzkY+MlCFItCElzQjPmtlb0PnPxIMDAi/DpHyApvvuovVQaz8GNrL99m/SByqj1s02FTDRVfwwSmmwR9t8bMOu4Ran4xx+fIzI96W4ta6DlSB2+zd7HmSGCxQLJol1Agb3yCnoqcck63HwD7lAZ4PC3heT0ZqEXUcQn+xc7E1ecXUgcqoguP47rasTLCv9fJEWSAiY/oiIyRiFWjiRfN/uOAsj9uCEEvhJm1o/uSTqTWGPpX1O21moRHMKnFbwxW3szcj21G+KIf1IWli355C8UJi4MmUbbkLY5nKrZZJkVYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4Z1JGU4KgRYcKflrtXzYaSY6matRUuT2y6jsKDdqeM=;
 b=gusJhDR4gn/1ba3Cmuwd2lSv4jlZQmECULUkDpXy5EkRpCsJFkOSEJjOhZHjn0JgXtUOuSJGMnhluB4i5iA7YBQ5QkZjh24iE9gPSmpw9FOvVnceVu1LFMTT4CkkzyGySdtziYjRFF5q12dE+Kjj6H7PBnxY2YRKHrV5qL8kSiiySOVrj/VsBv+Ria3twcUPhBRPKeafZ1cq0ZWv0oAVmDc5Z0a7zPcWeNOrwk3DDWIbry/ObWd30xojjaoWakPLZCG2U1aUtEpJZXhAg0GX1qX+e3g7eQwp71fW49/42Gx1NL9v9Jjw3XDu4b+p4akU/OHcYzt12xcpucYMLRXggw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 12:21:39 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:21:39 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
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
Subject: [v6 01/15] mm/zone_device: support large zone device private folios
Date: Tue, 16 Sep 2025 22:21:14 +1000
Message-ID: <20250916122128.2098535-2-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P282CA0051.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20a::14) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: bde819f5-9727-423c-4b03-08ddf51b9654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzRzbXJmZHhJUHRCK2RZSFF2bzJsNGRzREpuTUVBVnlvSGtyS09nY1lqN01r?=
 =?utf-8?B?VGg5SW54YzR4VWdxNzE1NUozTVoydzREN080WFB2WHI0L3puTGR4WUpKc21J?=
 =?utf-8?B?Q2d2aXduK1hsUi8xNDJScUNya3hybisxVTlKQzllYWJtdWc3cENVemR2dXdK?=
 =?utf-8?B?ZHRjc2ZGOHNYTFVWSTlQdWhVa2lJT2lKMU9VWXZmL3hKZDQ0SS9LdW9DTUVG?=
 =?utf-8?B?TXVFenh4UEs5anQ5UldHWW41WjVWdXhJdE9wZHIzejNoeXpCTlN0SytoQzl1?=
 =?utf-8?B?ZlBOamtQTHpjaHZxZjlDcWQzS0FYYnM2UUh2YTVjS0xYM3VOZG1qRlN4ZlZ1?=
 =?utf-8?B?U2V1cUhoTE56Y2lmTXorRVYxT0w4dzE5NUdQeWNVOVBDSzdLMTdMYWFkM0ds?=
 =?utf-8?B?SlF6b2R2QWtSay9wRk9PdUpWdHZwQmxtNnRPRXJwTkdYc2pzR2V5V3pGZTVt?=
 =?utf-8?B?QnJTSzFTYi9BSUI5WTBsNFhiWlljWDJhUjV0cGNwdkVQWEZ0cEFUc2Y4MWlj?=
 =?utf-8?B?Y3RIWS9HOHBwWldGZzFsOVFnbzV2NTArUzNBVDdBWWJZRFVqdElBeExDTWxs?=
 =?utf-8?B?UGJvMXdyVjFaQklQTytEamJMNzBIU0w1MUVtOXpGYnNwdzRQaC9zR2dFb2pt?=
 =?utf-8?B?d1ZLL3Q1U2IzMVFtWjhPYUFKNjI1ekx0RnRuZXAzeTNEME1YelVnK25WamxI?=
 =?utf-8?B?enZEdzQrZmpmWDRKRzJmUUsvOHhqNU1oVU9jNnpQL3lkczEzQ1N6ZWtQQnNL?=
 =?utf-8?B?VG0wYnZQNnd3d3ZjeGZJWEJNL2pFS3lHNEdSUzgwU3JRckY0NGFBbjBJeVFq?=
 =?utf-8?B?WDM3bUJiSmhjSnhMUThLN3Vmdk9qL1g0aEh4WEN6SkN6UTdvWllhN01SZERF?=
 =?utf-8?B?bmg2SE94L0sxS0Z1VWc3YkVhRk5ka1U1c2ZDRjhBc2JjZFpUdzNHVXNPRFB6?=
 =?utf-8?B?QnNCMzRRT2xGaXZiODVvaFBCOTZTSkljTVJFaG40aWxyeUVkY2hGYWU5cEJC?=
 =?utf-8?B?akU4bDN0cGRCWENjeVZCV0hUZHJUazRYRnVJZXBIRjM2TVUvS0VBYlBkcDlU?=
 =?utf-8?B?NWhCakZyaVRBRTFrZS9tY2lya1NTRk13eDR5Z01tc1RmK2xkcDdXWDZneFpk?=
 =?utf-8?B?ZS92OWpqRStkc2lMQWRBcUZ0VmNHL1JFaGwwSmthTmNjZDI5STArOTQxK2Zw?=
 =?utf-8?B?NVVYMkZSYmFzZ0xVeDM5TXMzbkhXb1JRam5VMWQxaEVSZFZsSWpHTk11Szhp?=
 =?utf-8?B?Zzk4V0djc2F0ODVzc01HSnJjOHF5N2hkNnRFSnFkcGRwb1EwaXQvM1JvYTRu?=
 =?utf-8?B?VzZHMFV1cUdFRWU4UFJzSkRJdE1pMGpxclZPdnFWZFVTbGtiSkRmcGUzdS9W?=
 =?utf-8?B?NWZBTHBpTXZxYjVidHFGQ3c1RlN5MFRQd0ZWREFRZVc5ZUhxUjl2dm5kcWxO?=
 =?utf-8?B?V3YyUU9JVXRzMktWU3Uyd0x4b1lKc0RFa09BNlp1TFFidW5FL0dqYkNTMWFv?=
 =?utf-8?B?Y0dIQVRXZ0FUeGMrQmVhRG5wZ0JLSDhqY0pZNEgvQUI3bndKMmQvRDlNcFVi?=
 =?utf-8?B?bE5rRzNtbEJWdVA0TEVWSDNOUmdpMDlDL1JEUHdFUGpqR25wQXFnSXY0Wk4y?=
 =?utf-8?B?UEFTSE5Wei9pbHZJYVNWRVRyWnp1NUZiU0NqY0pBS0hyMFNTNDg3RXh2VXE3?=
 =?utf-8?B?UU9saEFHSTUxTkxxcnFyZ1FoWXRaMVJ1T1VOVnArYTBnMFZWUzFVVmlrdThn?=
 =?utf-8?B?U3ppSFRTSlZqY0NSQjhFWlY5S2c3QWpPVzN4YXFqKzdGUmxnUlEvNlE0Vk9q?=
 =?utf-8?B?WTh6MUNxOE9tTktpOTdXZWZvYUJZT2NhODdJN2F4c2o2NUZVMndnT0IwSnZL?=
 =?utf-8?B?cFNVSkdhSkNycXlGckdrU1k1MURuMThaMTY4SDlobTZkdWZ4cUdhVkJhS2xl?=
 =?utf-8?Q?5lCjl8v9r/U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFFPWUw0RDAxK0VQTS81RWNCUXk3aDY4dTcvemltWldUUjhFY256TTRFUlFs?=
 =?utf-8?B?NWZ6Sm1aMHh2UndWbGZsNkpLMUVCdlQxOVBXd0VwdTFkVGVvVWk5SzZxLzVW?=
 =?utf-8?B?dnFsWUYwUXNMb2VDSUt6ZmtmQXU0aEQ4Nm5ZQ0JaN01xTy82dU0yT0VsVEN1?=
 =?utf-8?B?N25TN1lyWGV2OG1oOTVMQ0o2ck0xVEhXMUJaVmFHTk4yVzljazJzVnNWYTA5?=
 =?utf-8?B?RjA2amYrbVFKK2tuZXFQaGpqSGozRVh0VVZXMkdTc0xvUFk2Q3l4OUtkcjI2?=
 =?utf-8?B?Tkk0MnBRVXpsM3Zvak9VOGNDbHdIbTdkaTJCZm9ic1ZMUkdXTGN6N0M1RTJv?=
 =?utf-8?B?Z24xOVYzRkNkeHUxVytsbXY4anBINDBzU3ZDSmt5eWVQNGtZcmQvSlB6bVpK?=
 =?utf-8?B?bUhYVytTVnNiZTBpZkIzVTI3R2d3QzAvTlpnN3Q4UmJJdjVRS2tnUHlMbzhE?=
 =?utf-8?B?cEZJYXhMZnVVd2RGQnNVT3NnZWtUYTNYTVlVZnpWZ0VLUkZvZWFzYTF4dHVq?=
 =?utf-8?B?TmF2WXpVcU1iQWlBQUtmdjg2QTlSM0laaVM2SXNWN1lmQy9pSjVHbHRZRXhS?=
 =?utf-8?B?aVVWY3RoaTU1RjdnV29EWStuenlrMGM2R0QwUEJ5TWxHeEVkQnllWXRJZ1B3?=
 =?utf-8?B?eVExTDVTSlBLSTZIYXFtWDFGWjNlVE1ZcVNaSHV5UndscVp0ZzJBWU1JVG9h?=
 =?utf-8?B?OExySXpXN1FYWURqRjE0OE8zNmZHUllrSUVkcG9SN0t6Qk8wb2JxaStCVElN?=
 =?utf-8?B?ZlgxeUV0aThnTkxyQ1Azc3lONEtJZVNVZUdFcEo2Ujk4dFF0ekZrZm5PcUQ3?=
 =?utf-8?B?Y1hnMVpWeTRQNkdiaHpLMHppK2JsREFia1NUR3lISzZ6dUtaeTRnZUdTNWd1?=
 =?utf-8?B?ZFowZ29YOFl1b2d4aWF2MWE4cWczai9BS2M5SDN1dkJaaTVjbzJaSkJ4ekp3?=
 =?utf-8?B?SGU3VzU5WjNGUjcwNE02SHlmTDBWRW9PdVh0MHgyRXBOTU5rWnVIZzQvdnBl?=
 =?utf-8?B?RktqcTNGUW92b2xjNkVFMGN0c0dCbUdqc3REQjh4SzdRb2V6TnRYMTJSZmFr?=
 =?utf-8?B?bmdISHJsbzdtMXlDakRDVVV5NEFaZkhlRjh2Q09Bdm0raW9NUnphNElwdkNO?=
 =?utf-8?B?TXo2Tzg2bnlsTUhFSnJLMElGdFVCd0ZmU3ZOM3lzMWFidktyMVU0MGtaN1lX?=
 =?utf-8?B?NVJCZk8xb255WWJLWjZ3cTlkR0dSR0lPekZhLzUxd0xHdkl1UHF6WGVCb2lX?=
 =?utf-8?B?alhnUElVeEhTekRUUmcrVGYrZjhZVTVOWUpMc1VaUVNDbm9kaDJHVmJFYXdS?=
 =?utf-8?B?cldXa21IOG9TTWJFQWpOYmI3Wk5BU3ZHMjA5SlBQVy8vdGxENHd5cEE3MnJV?=
 =?utf-8?B?WUo4Q3IrcTcvNS9Rb2xUOHBHKzZhOXZGOEZiemtVemdwcW53S3FQYXdDdFI2?=
 =?utf-8?B?TzU0ZEQwWTZRaTVrTEhCd0FsMElpOWtqWUNYQ3RBYzBSWHozSFluaENiWmRr?=
 =?utf-8?B?NjY4L3hrUGlTYlBTSk1qYndzcG1Obkk3N3FZVC8zdUtYbjNvUkh6S1NJOUVC?=
 =?utf-8?B?d2Njb2t1OXErSTRIZ2ZqSHpxLzVHQTJYdm5OUjhsZjhaTmVYc1djRHRweXhl?=
 =?utf-8?B?Tk1uM25vR2xVaWFnNUNSTXBHa2xaRkhxdVF3S0pJV2ZnVFdWRlltbzRwNjlo?=
 =?utf-8?B?ODlVUjY1a3NwWWF6bWJXenZVcC9MUGxHM3ZPSmNDaURBTlpEVzBkUWVMNTJv?=
 =?utf-8?B?emtPOWwrNzBoNHRVaU1iU0VlSi8yZTdhdkNCRWx1YzB6VWczQXdpQTEwSGxO?=
 =?utf-8?B?YWtBVkRCcFh5OGlhMzA4WUhkdXBUMHY1TG9rMnJuS3J2SzFBRnJCSm5LYWJw?=
 =?utf-8?B?dWZiZi9RRlVrR0lhbGlsTDRidnc5UGpiR0NxUTdZcGdLMDNuM0pXSXdQdXEw?=
 =?utf-8?B?YjNXYTFjS2krRnUvNjg5WlUyazMwMCtodVMrSHBuMXBPQ1lMZjNxNVFYa3Fv?=
 =?utf-8?B?bDhtSkdoc25ZNllkTEY1aXU2WDJmZEU2WmtjcDllMGJmaFlGZGYyVGlHOVJP?=
 =?utf-8?B?MDZpbVBWWm4yWGQwdFBSQ0NIeis2ZHlpNFNvVTJaNnY4UCtJWVJnbi8wNU1z?=
 =?utf-8?B?NUhCKzFlU2h0ZFNGbDhpaFViRDNtamhZcXpObnRBQmEzSnJEd1pYZy9CV0d1?=
 =?utf-8?B?SVE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde819f5-9727-423c-4b03-08ddf51b9654
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:21:39.4264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hu9gFVXPgo9+JADEyQst+GIPExf1yKmwIreeCfNmHwzNcViagZw9K1POVXsFQyVU25F5epuSIzexCQ/qs+BUWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 31EDC4000F
X-Stat-Signature: he6uri1xbwkbmjuruhuxiuyuqnztj4s7
X-HE-Tag: 1758025332-22125
X-HE-Meta: U2FsdGVkX1/MrfLhcPsq6uDMah5GdXthj+ngt6trdkSvv62ezoZdGlfFaOPXH1hhnnTXd7eOOcOPRqNF6inHPldaX2OCO7Iy5kq8bI5rn6C4e8shCiu+OQXQZe3zR/Lm1WqSkWCNJAop4eUBN9RFK8LRwUUaSu73CNVn7ChpW/9Fxsae/PoB5V9xaon2/eDzEC6WYy39e5WevmoivWI7jMm+1PLhbdBZfPJaWWWJ1Z1KlXohneKxijb6JwBRomqmTIJQdOAdZYot9wlIMzWGTtJ153f8r4lFY+K2s6UwmiRDanOy9Gi5nOztAlO1VbI1VAeyecWC+nVahhFYBJQQBkcSTQt+AnEbAsIH4LD9stht7I4Tcs5tXNBCtkf/QdT/tbPl6WYKiU2gpHdm3GW+HeeKkbrxNIJOlgZmc+igonq05YEZ2X5Ksn2mGSplEMtpT6TCXC2QylPjfKfhmI5NCLNGSj1FEsIEOJxPUjrRehxgcrS1mdaoCzzrLLv/WlBk8VWIlOfuSYH+SeZREYGYrvujCP4BkMP4Q2tQYx1wBbhKItXKlJCswQWq+rkTcswawh/GzIkU4wrdXUB54whu8RzdT4MUBXYo3+pErhT531B3p/7qoniufjIY1AveHWMMG23LZmp/yaviEbcDyeYn5pZxqpkExpuwRzyjYi60mjuQY+unEPYiGRu9pIIkkSBUe+Exn+P8Tbx9ZtyF9fjlDG4JEE+2w3AuU2KY44Bw/xkO9aa9/OnggN2w94a6CK/pB8AVrJWBq95EFfGCMw0VeTQfBNXT6sDoaPM1+VWJYo8A7UEeY5jDM7VGX7TGhr+X/oD9olFN+hKBico7MaANxjOniXbbDD5k91ONmIESPfgJedGI5SVNxHuw8qYSkDwHL6xYXZ4VQnw1A1EZMEdlcJbIK1AhIfZ6XZdcd9i4EEO8x+6Ajt9/TkOqB2rC2gLIVZZziUcNnL0BD7CaE75
 6cJczFmi
 Aq6Xc1KpC3xw0Zr3E5pRPb+aaN4d5t3IDbVKoX/8sJjSl2lNTsOSB2xogjcUGV8iqN7rwDuKNfhu48J3+KmfOXC82TIfHqM5t0WV8g8iMIJaoct2jJ5ukBb0TkByIhbJ2NqunVG7hguefx5KrpfGHyk2rGZyRcgeSlIEElOs3AUTMtvSiSo18Mr1KleI1Rb87mlq3qyXkXME8PeP52y/hpVGO9he+xttCCSvtrzVrbjPPpIRAJ3cej6hE/tC0svuyopiml/o5CBJ5I/XIu7VUhJjrTmRKRLWIWfhOfG4Nt/Yqgg7BuXr6pBJgV1gADyv6mbaCJn2eTgwjLX5TjbduN7I3kse9nwn8NtSuzbHcdUdKrP9mlQ70OVVzxgnrKWgD2QVnJ7CcKHJupLGE0JlYS5rvi7P0WqOatnC4BGqSsQcYyJkvtfNDiGC6EgWHcfp5ZDxI78jx7VqEAMP5GZ+x4P17/rrhPx40u8hBJSmK4WZOKKHnwIak9ioJvpfoviKy5NbqpAAk+ikJzTdM+iLmM/NrDI6/s/szAZoL76xN4Bi6eWCxLbs4PQ3eBeTD+5xCOkBlg6U2OG2iCB9bzzqoX87B/ArvqPf1o+kPC4ZGMDWsHgnbINXwgxGp1lCi+jUAe+MMErlp/3hdigkKi0Mm9tPrt8IM3LzvCCOscZdwmN4n6L3jYlyMH+Pl/PywiWLa5MugEhni1P4pI18s9Lp9hzOWjuGeU+UPav4EmhDsYk54IG1CmZ2rP/B3f06h+gs8DEKvqs6xUq+L8Tj+b8KGLWVX26/k/RboCIFVHLM54G14rYPzYtqtXN1z60Ll4n8SdPxDd8yQ/BF9G7iZ+6HKeAyCmOqPlneixvKn/4cbwBxKuSPS4gfTi/G8qOyKLmdWwgyMhddYIFUyKqmqHZocuhOrR67+fkUYG2BEDX1KyitRdfE94o04j0vz+KqCLKaJL5s8yV/CDJXbnzkTEaxhgcVsfh8b
 86llQIsH
 nHUt1dfTjnriqpJk2HCVn8nVm4DrEowwRXptIDSoyw03ZUbjJLNb3/PmjBWlw0RQnvH/KCoV2Nzv2zTItxrgK1XkuKZv0RsUb+7ztWePUPwesR1Pktifm5Lk2seblC07
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add routines to support allocation of large order zone device folios
and helper functions for zone device folios, to check if a folio is
device private and helpers for setting zone device data.

When large folios are used, the existing page_free() callback in
pgmap is called when the folio is freed, this is true for both
PAGE_SIZE and higher order pages.

Zone device private large folios do not support deferred split and
scan like normal THP folios.

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
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
---
 include/linux/memremap.h | 10 +++++++++-
 mm/memremap.c            | 34 +++++++++++++++++++++-------------
 mm/rmap.c                |  6 +++++-
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index e5951ba12a28..9c20327c2be5 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -206,7 +206,7 @@ static inline bool is_fsdax_page(const struct page *page)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page);
+void zone_device_folio_init(struct folio *folio, unsigned int order);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
@@ -215,6 +215,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
+
+static inline void zone_device_page_init(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	zone_device_folio_init(folio, 0);
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
diff --git a/mm/memremap.c b/mm/memremap.c
index 46cb1b0b6f72..a8481ebf94cc 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -416,20 +416,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 void free_zone_device_folio(struct folio *folio)
 {
 	struct dev_pagemap *pgmap = folio->pgmap;
+	unsigned long nr = folio_nr_pages(folio);
+	int i;
 
 	if (WARN_ON_ONCE(!pgmap))
 		return;
 
 	mem_cgroup_uncharge(folio);
 
-	/*
-	 * Note: we don't expect anonymous compound pages yet. Once supported
-	 * and we could PTE-map them similar to THP, we'd have to clear
-	 * PG_anon_exclusive on all tail pages.
-	 */
 	if (folio_test_anon(folio)) {
-		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
-		__ClearPageAnonExclusive(folio_page(folio, 0));
+		for (i = 0; i < nr; i++)
+			__ClearPageAnonExclusive(folio_page(folio, i));
+	} else {
+		VM_WARN_ON_ONCE(folio_test_large(folio));
 	}
 
 	/*
@@ -456,8 +455,8 @@ void free_zone_device_folio(struct folio *folio)
 	case MEMORY_DEVICE_COHERENT:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
 			break;
-		pgmap->ops->page_free(folio_page(folio, 0));
-		put_dev_pagemap(pgmap);
+		pgmap->ops->page_free(&folio->page);
+		percpu_ref_put_many(&folio->pgmap->ref, nr);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:
@@ -480,14 +479,23 @@ void free_zone_device_folio(struct folio *folio)
 	}
 }
 
-void zone_device_page_init(struct page *page)
+void zone_device_folio_init(struct folio *folio, unsigned int order)
 {
+	struct page *page = folio_page(folio, 0);
+
+	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
+
 	/*
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
 	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
-	set_page_count(page, 1);
+	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
+	folio_set_count(folio, 1);
 	lock_page(page);
+
+	if (order > 1) {
+		prep_compound_page(page, order);
+		folio_set_large_rmappable(folio);
+	}
 }
-EXPORT_SYMBOL_GPL(zone_device_page_init);
+EXPORT_SYMBOL_GPL(zone_device_folio_init);
diff --git a/mm/rmap.c b/mm/rmap.c
index 34333ae3bd80..9a2aabfaea6f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1769,9 +1769,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	 * the folio is unmapped and at least one page is still mapped.
 	 *
 	 * Check partially_mapped first to ensure it is a large folio.
+	 *
+	 * Device private folios do not support deferred splitting and
+	 * shrinker based scanning of the folios to free.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    !folio_test_partially_mapped(folio))
+	    !folio_test_partially_mapped(folio) &&
+	    !folio_is_device_private(folio))
 		deferred_split_folio(folio, true);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
-- 
2.50.1


