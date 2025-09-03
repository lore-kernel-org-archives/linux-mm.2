Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19CBBCA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 01:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AFA68E000A; Tue,  2 Sep 2025 21:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685DF8E0003; Tue,  2 Sep 2025 21:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D368E000A; Tue,  2 Sep 2025 21:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8FA8E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:19:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD4361DE015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:19:52 +0000 (UTC)
X-FDA: 83846182224.15.36BEBB2
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 099EDA0004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:19:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=brJJcD79;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.237.54 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756862390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JA9H80VVQXYRADuOMDr3jLSFxlMvjrmpaPYQpFB6IA=;
	b=NuDv9ihaQBYhTK7rk08BxvgWjP1caR9dtp1xe/4efhoNtyiSEuJxElcuC0a/xS+i19u4fn
	Nb/xTCHqum6Ezfw+9myGOnU0R3AjjyS6CAZPznJjXWFWpnN7AQfpTpd5msjGPVLM6D/KcB
	9fFBfgXDKWTBJxJdrOFC1zjbMXIWIFM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=brJJcD79;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.237.54 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756862390; a=rsa-sha256;
	cv=pass;
	b=BuEjc0QJsknEqiCETmD7hgyklmPYGKRoQDKa/IjOTAKtITE2Ugy59Ajdytw3lP0dGp0Yl6
	FvP9pB97fQfcu7As7vmwLzZPySDfxBg77i11Zm8oWdtejHQS8BqmPwL1L+gLo52hElYo4a
	/6pczjb+lG/LCua7uaVlOh/MiLInpJM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7byaeR5OnKkhjKVSZpnTo+KDOqgaEN6uPOEPt8iCIn0MUSYwS2QdBh19Joi2Fgw210UGRNjBtDu9AGwgqy6YDOilx4+2+7Y2T1rAU85iyGTt60qHPKM1nd7S9NF6gDvXIf+O1V1LyA8jWNDJpMcC17Xv81eQKkdFLEnUM2qU+d/IZFCbLu4fHQweRtd5cxows+ACR9IfFOHxowu1yjBmRQsQcSpyvhdicohvzYC0sRvKcTz91+dUDD/CWbvldWPv24MK98+fLbwiPiiSP6v9H8+FgudcD3r1SVMPN2XEZ/whXCzxX+fI0ypLZiL7fe0Vrr9r41v5nuN2xzk3L/Qcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JA9H80VVQXYRADuOMDr3jLSFxlMvjrmpaPYQpFB6IA=;
 b=BDVd0Yuj0maKxBhR9NohEJfgbnfKAnypfd2zmYJg+N7gu6Jvl+YLlbhcNi/YltwN2d033ZZe9QGRh/hUl1w7aMzhILsrWoQUQDB8xTXDhTG3VGH+ZGfPbjc8Q2cR/NPEu1tcOxkpJXexRf9zmHSUMe7h07X+KOXd3Q4IYOVt3OtjC2ozA9LpgzcYU/Ey4DzzuUPupgSFwZNOyN2v+3n3QNo6qjx0kgDAijqGhBBThwaOzmj7aAehtXfwtB5399sMgXVzO84CdWWnBPz9Xu5efDXb1Stj5xus6FyMY8cAxNOBREj4B6AJaeSv/WEFYkXCWuAsC5c7xkgmY7n4sT3GiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JA9H80VVQXYRADuOMDr3jLSFxlMvjrmpaPYQpFB6IA=;
 b=brJJcD79c4WDhq6r5SNQ7GmYMULJ5XYq4bGxR9Fyt6anKmKN+3r0fNOZOGAsPOsYJzn7FOeHZ1pSW2KFs3h6wGKWSG63cIxiaUqjrBltovSdDFZvXdH2FiGLsNLrIiiUc0b5/b3sT7pE3Ycs6dfZwBhX7CISZm/e6n2qUE6UgnvnIf0X3utBEUZw0DWqApKj9AssCgGDUfZ9/YpBAJz6NeA8JfXOxyMNy0uldgombuWXrB7Q3UEHDGaK+yPGdnvua81XIfhn2FKWi9+Pq8jS8CZe4k2/ZtfJDdijPqCyQu63DKJ16r9Xyk575mOjOWVxVussKJwlyd74sD81XktYnQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB5950.namprd12.prod.outlook.com (2603:10b6:510:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 01:19:39 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 01:19:39 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
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
Subject: [v4 02/15] mm/huge_memory: add device-private THP support to PMD operations
Date: Wed,  3 Sep 2025 11:18:47 +1000
Message-ID: <20250903011900.3657435-3-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903011900.3657435-1-balbirs@nvidia.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::26) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: ec343c2a-5313-4c1b-1783-08ddea87f3e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QS9wT0pSYWtCT2dXR2VETXFVRnRub1BLRVJuQmxFOFljUEtzWENWc24yd0tw?=
 =?utf-8?B?WWVuaFJzYTltZlZZODdYT3g5NWN6bU15d2cvamk2WTJGYTdheUNLU3lOVnRL?=
 =?utf-8?B?K0xMc1BETGFqeU1JenBGSDJUblVDWjRldkZTa3B2T29DbC9ra1R5bCtBcUE3?=
 =?utf-8?B?Tk4rb0xiUlBIVlFVOUpsS2RsY0VFK1NDaFN6MVZiVjE0YzRhVHdFb05qWU9x?=
 =?utf-8?B?Yk5kSjk1QkFFTmc4ZkpkcklCcjFFK3dSQjVqV3JmalZHRGFJSXJoeThPdlM5?=
 =?utf-8?B?ZkFsQVRmVGF3L2RuL2syTTJOcDMzWlhhNUhzYnV5MFMzamZBbnNCeEUzK2w4?=
 =?utf-8?B?QTZEOUM1SWd5eUlBK080b0l3V25oOXlsaURsSzBQcnhvUlg3N2xXU1c0Z3BT?=
 =?utf-8?B?YlNRakI1K2p6WTRFM0JNK3lERVFZd3lLNURQajczbXM5aG56SkVJY1ZzZE5Y?=
 =?utf-8?B?cERYR3JEczVCTVhIYWQ1WXlGK1VpVXpnOSttUVlCaHBvU3FESXA0U3o0WGJZ?=
 =?utf-8?B?czRxWmlxUTdsaFVhQ1BuOWRTWGVUdUY4NzRaQ3pNUXRHOERSV2FjOE9OK3BJ?=
 =?utf-8?B?VmhwRmd2OFpXZzBycWJnTlNtdDRiZ0FLckZJUHkxSnlvdFFiUzRhcUdwOER4?=
 =?utf-8?B?R1lQLzd3MVo1bG43YThvV2RlRzk0SXZ1TFkyc1pyL01UOFRFT1ZkQ1NIWE91?=
 =?utf-8?B?K1Q5UkNlWFUyQU1Idnpsd016Zy9kWG5WRlEzYVN1WVVkZ3lyemQxcE96T0ly?=
 =?utf-8?B?YW1oWk05Yko4SnV1OXB2bktPU0E2c1lDQUVaMUxocE1zOFphdWNOSzNZbnha?=
 =?utf-8?B?NSs2M0E2TTdLUXBZY1JoMXVnY0VwODZrYmI2YTVoWTFEdTBaNFhYYjBtNytx?=
 =?utf-8?B?cDhrK1ZXZGJ1L2pxRmJxWFFJUlpyZGdpSTJJU1FqcVR3OG9JbzJybXppbjJK?=
 =?utf-8?B?c2cwNHhKUU1DaDRCYmxRQnB0UERVNjJhT0EyamJuVWVpWnFKTGF5RU1WVE4x?=
 =?utf-8?B?Qy9PSmhhUFhVTTYwZW1yeW1DaWVsN3dWbEllZzc5WS9nR2w2WWtpNTNGVEZh?=
 =?utf-8?B?R3BLa2N5VEUrbmw1UTBBK3pYd3FkL1BRekpjYU9wMlZlWVFXeWhRckxhUkxS?=
 =?utf-8?B?M0Q0bll4eG5UdmhXTnZpeW8xK2cyUFozUnVGcytDQ3hMcGlxdnpTZ1pKSi9P?=
 =?utf-8?B?M2wwUkE3YnlTS0xtT2RJcWxxcWF0ckIvam5OcHluR0tBanRiOXNYa1RtN2Zi?=
 =?utf-8?B?UG9HSWhjMGxOTmJOam9ReGU1a3ZTaTI3VnRrRXZydjJEbFV4R1pNQ2ZabUFQ?=
 =?utf-8?B?OXl6Y0tYR1lQdytDUnFScWN1ejBwc1kzekhWbkVhNVI2bHlZQnlleUt4dTJL?=
 =?utf-8?B?K3NWdS9QWFZINElBQUpMK1QrQzBUTHJwdVRNck5pWXBkN1VveHJHSjB1cFFm?=
 =?utf-8?B?WE8ySHIvRXoyblVxdXpEcGFBZytsbzVyZ1RKbng1SkVsdmxCQytXTGt2UkND?=
 =?utf-8?B?dzFRMk04eU1HRFp0NVRUSXBVaUp4ZWlEYktSYkxmeXRBM1A5UE1MUzVPeHNC?=
 =?utf-8?B?ZndKMElIM2FWTXBvV1Rla0xMMm56WURDZ3AwaEtYWjhRN1pQOGhsQTRUeklk?=
 =?utf-8?B?engzc3dWR25PTUtjdHJlQk4wNStocTE3T2ErNUpPQWJiTEhWWkdhVEg3QUdh?=
 =?utf-8?B?V0J2T29UUUphUFNmR3hHYjZrMUVRTVVVcmNiR3BrM0hJU0VBRlpmbEE4M1g0?=
 =?utf-8?B?akxnUDNUYW1uczhCMXpoZHZ4QzFrMnRHRHJYa1pjblFMTWJ3ckw3RitlanI2?=
 =?utf-8?B?WWV3VUlJS3hBQXJrV0NIc0hEZ2FGaC9aMHBZT0RhY2VZRDhlZGtzazRDUHBP?=
 =?utf-8?B?KzlZVUcrVG5tSzllQlFsOEJsbEl6Z25LbFFlTWtCQkFtd2JHMVEyQ3lZYlpO?=
 =?utf-8?Q?yT53MqHTnRY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVMvdFIrK21TMi9xTllDc0Mxc1ZFaUlLYzlPdWVaVnF2Wmc0cXNPeVQ0VkxX?=
 =?utf-8?B?cVR6YmtIc1dKZllhQk0xM2hyQmhQcm0xaHNUTFRsN2JRUlhDeWd3RFpUamIz?=
 =?utf-8?B?U2ZWbHZWc0tGcENzQUd6OHcxMXNOY3d6OU5pN3hCYjdGR2lmaUt1cWQzVkZ2?=
 =?utf-8?B?V1loaHZkOUxnVWI5RCtOMHdqVXllRUhZSzhaZHVHY2lLRVBIalM0TFFzVFph?=
 =?utf-8?B?NDd4V3VsSXRkRzhCK01BQ1dnR2tSSkFTRjN1cm5VNjcxU3FaZlBXeWE4dGVR?=
 =?utf-8?B?OUl3enUvY3dHZ3pOcGZqbTFCQ3VDRDlsR24rRk9Oc0Z6a1BBTlJYN3RnMm1U?=
 =?utf-8?B?enF6clQrNG1CVS9udHN6UGJ2aEhpcFcwNFVCakVaQXNRZGZJaHp6VWlGMGFx?=
 =?utf-8?B?VDhBUnRibUhMOVZGYjc1UkhoQWtUaTZ0cHNtT21kb0s3RkVnelc0Qy83YU4y?=
 =?utf-8?B?U3FyNklmWVk2SlRGN2Q0aWJwdW5DT093azBjMnBWTE0zZklPUFphSHF0SUZ1?=
 =?utf-8?B?d3g2dGtiSHMvbWhFZ2JoV2xPRXdRa3ZtbTRuUnRMVlF1aHFraU1YWTZjSWEy?=
 =?utf-8?B?UHZjNXkwaXczdjUxRWllZThQaFNRZHlXV1V6ZGVvaXNkS1ZVQ2pmbHZGdlZi?=
 =?utf-8?B?NEQ5bFZRcktpOGZoOU0zMm84dkEwcXNxNTVhRC9TRE1ITStjQ0VESVVtTnR4?=
 =?utf-8?B?QjFCZDhpM0dhQnY0N3lGa0pSRzJJT1lRbWI3Nm16Yk81WjBVUUZFT2dvajBV?=
 =?utf-8?B?Q2RWU2Zqc24rTlZMK25JVXoyLzcvdmR4RWNZRGdYZk41QjRrKzBWWGltY0Jl?=
 =?utf-8?B?a0t1dktxeWEzSytvTEoyUExqNVdGSjkzL1daUEFPT3FIVTRsVUFtQzZNZ3B2?=
 =?utf-8?B?U3RJNG5HZVMyS1lNNTMyVFFFVUFCcXhhVldWU1V3WE5OOXJ1MFVpRFNnYzF3?=
 =?utf-8?B?Q3BRbzNIbnRLUGwvckRhcXE2dVUxaWc3YzN0OVd1RFd1MzVLWXpmcmNEUnVo?=
 =?utf-8?B?Uy90aW8xTzlVaUFBSVRMc1ZlUjhCcm8wUzNDeks2cVZ4dytaSkpHZVp4OXha?=
 =?utf-8?B?ZzZKU2Y3QWFpSjRFb2I2S2drYWsvRW5OdEU4YUJZU2hXdk9WQmN3TnUrOFBY?=
 =?utf-8?B?MnhpTE1kdWxaL1R5RHFGcmJEMEtDSmFuZHovb1AzazdaQ1YrbExzNE05a0h6?=
 =?utf-8?B?SVpFNVNMT3cxNDhZcmdsREZpaWpwbmV2SDUrY1BEK1Y2bzNpTXN1TVhVMEpG?=
 =?utf-8?B?aWhaVTdvYXdBS3dLaFFrSVFhK3N3L2lFd2V1OW9xbjJYMGlxYnQzWi9GOUxp?=
 =?utf-8?B?UGNmTWIwMWlKckxMUm1LZWVWM2lXdVBRbkw4Q3BmVXJXdWRBV0QxLzhqSlVR?=
 =?utf-8?B?Wi94cnpMRVNnV0Y5UE9wTlZrV2pxdjcvaXNyZ212SjJyd0pCQWRTL3pwaTJO?=
 =?utf-8?B?U0dtdVZsOTVyZHhveTNQVVJZTE94OXVGeU55ZTRMWmZIWWRtWVZ4NGNFc3Q5?=
 =?utf-8?B?cS9UV2FFQ2dZa2VsR05IMytwdC9oQlVIVi93dTFRcm5vQ1NTWXVjZEV1M3VX?=
 =?utf-8?B?Q3h1SFB4cnJUSjRiTklVWkNIMzd3cGxPSXBSL0hQOEhPbzdqQlhGTkFSdDdP?=
 =?utf-8?B?THFCTFVNajZNcmNyUmlnSlhxaWUwRTFXNUFUVHljRjZVem9ydFlTVEJCbkJs?=
 =?utf-8?B?NHNFZmtxWk5VZkwrdHFEYVR0NEh3VHYrZUlEVkRuRHNKUlRIL3RjOUZVcStJ?=
 =?utf-8?B?QmgyUkpnMkVTVTBiZVFPRExJeGxxNjRaWTdoVzIyK1YwRWFrM1BubXgrNjN5?=
 =?utf-8?B?MVA5dlgyVlZkZmVrK05EOEwrSUtWVWRtRytnVWdrWXR0djlWMlJpNEVybngr?=
 =?utf-8?B?NDFtUGlyczJRcFhCa3hvVHoyZlhvdVMrWUdtc05YdnI2dWlwQjhEVVhKTkN3?=
 =?utf-8?B?QXd6WGN4NDFDTk1oSDdqUHdiZ1Rob05ocTdMWGhDZFlVV2JYTjVEb1Vvd2gr?=
 =?utf-8?B?dmxqeEtiT0FUQnlsWDRPYkszY1FTVFBRRHU0cmhSMnBDMllrSW56b1pGeEFC?=
 =?utf-8?B?RU9WTEF2OFJ2TDR0cDBoTTMxS1RwWnE1ZHF1QlJsL0E1aTNvQy9ibTRtRmd4?=
 =?utf-8?Q?BmhqTKN/pr91qWlOudw2NDURj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec343c2a-5313-4c1b-1783-08ddea87f3e3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 01:19:39.2668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6Q3oFCE/0xNKbVGQ/Mn04R+zT3DiXzvqi5Pc96B8O0wbGKlANmpRBfeCBe/aeiPpIgQtqDJdSKNZ1aDQ1dAJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5950
X-Stat-Signature: z4dxcp4n8xhwarncr679t5b8saj9gype
X-Rspam-User: 
X-Rspamd-Queue-Id: 099EDA0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756862389-139509
X-HE-Meta: U2FsdGVkX1/mGnFgrHXl1cf5sKz8563KH0OTZdxnNsQf8Sbtbo93HP3dCo8jvO7zUQ6r1LPig2XDyUk30RHpcgOY0p8nDpCm5EuS9asb5nESMKBp3KaNzBqobNT1BFOTmk39QeKM6baBOMkO/yMgTGQ9Zls+PYixrMRp380zIBR1p7d7+Dvmn5T6c6Z8m6RzDpCOyqpaG3BxK9SSVcVbGaE5A+3zpL0Vaf4ftcwHO3NTSrP2JJlLu4x+0xukL1arUC4OoWvfKpVa6ykQ3nUpT/3ELT2AXr2rXhEyZj1jFy15pmYACTKBkxL+TinMLEyEosnRTe1P+yEvXQCH72F8Ppt7bebHeUJ9f+bu7YwGfHfItxRuAAUIG6+EuxTwZwVZ7MTrN6p17iCw3rkt9vxZMjNb31KTsdoLnAULoDamK16vIjwrY25SeAkQj7p158s/X7DhgytmlReMNbjzExZJazzzwiuxgS7B8qB1d2dv1NVdnyIkvNgD0IyvfhIt7E+qDSg+eyMkb364sxy+CXPbGK19zPRMRGbBcImdqzRFmB6pSlWMyOQ0S7RmI4kug1xJqPFK7ELP9LDIXtylPCCGx1ccYCOHCktK49dkXzIOxCDvh24/UVdJ+pqCVVv18ZiplrWtg1An9hJMhceAiKjWPvM4FJmzx2Pvjf2VsYuHi4umIfhASBMTp6fobYKn6P8S988/TWL7lkf2S4qNzOmX8wQD67PJFpdHzblhrXReNPkqMK0DfNKWJvq/hp1ml4B9UDPHO2XUgTlhzTMNFwu76MoRx0pVXF2NqWO+5NLlYcC4EsF1nZH/7XuvRGiQMPDlEDtKRZUjTDXUr3wFZVU2sZJa5o1gNZmD+GRxULCfFPXS345QkrA74/3hcH/0jFhGsdG1ZmGaNVWq3BvclDXfX6iz38EkpYWuI5/zZX9iKxvZeBqtr0dH8KvJ1f0VBTmNfJRZT7vuwmrJRJbmZam
 1hT1bPOU
 V8ppjhkYB8zPtDhfdUfUlMHOMbBbz83u3xxbzHqv7lvMlmXLeudLu4kuLM0SI8P4/4otB3eCAnExNECF7fwFZuQ+BJIbyNwYedBFQamIOPlwKGYKom75ABVdFGBdaL5LhUXcDQyZu7f0w0Tr11Q5yY1xozFzSkhsX8utOhv2m+5OToRA5y1hLru2MMCBHNwmwxWclY3fAZ1djx8kInXovUC8dfjQOffJQmi5LazCzGTZImH9TlhQOgWC7Kmpk3as8f2eXLcea35zPQMpHJXHdhgQzZLXu/Jsf6dcLNzYCWhMEzxKTwdSW9NN67zGcF8AG74XMGTu9G+vvaHqqJ+13ZNcRC32qxgquRMkC9NX9lCDVBd1vlVwwyxLWdcpMSisCq2NPzKnvEqF4IEteFdf3wkM0XKTj1vpSyjWoeoaXHZPpdH4BpA6hAmycIgZgUarZ6Jc3tfm1euIJmg9w1lv/VREyiEtk3Kaew95eKjaYMPP8YbF0NXWxwdMEfvP4VmMtZ8vtsQiBNb4J9QNkPUEAkVVbGZsr8bIrDke03vrfgkQVhR2XjEHwKbpcVZ+MQYpm0p77VX6UAQALtnfOyPUnE79VlvSYHPtR+2MDaN1XKO6zoOyvkz4nbgshnh0Mh4owpTVx6N19DmP4cua3BKpPQPov1n/+wqUwWvRa7z4B6cOAjD112BgK/YkFytko94HsdJDVvv9IDFu2xfwkoeZLEHwZIeDw7IUeMYhCvE/DhFeO3H7uOhVi4T5lymy3MveHQUjRyPa9E/NxeyPdlUIuj3qAAv3OyeOUl5rz8hMuqBtgacXoZnrVrR+e5ZCkI4tsK4l90d0/TZjceHiziX2s9ZGn4OX6/64SxBSSgX2QKeFoJ7ER5OgWNhOXJPm4gFrhzdzy48bfGUZ476YbXBVESEtDk2C2t5XxtMMNP7k0tnYmtAtmRDVnHSs9LMpnnOzcaT4tb/fN5RWL1mwlw7c0Uee7PKCL
 nX4QP/aK
 pO1JWn6SeNcAqxn+XuTo8jtb8rnsMFxtMm1IQGM22yuqoBhapL/a6O60oEEWcvWm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend core huge page management functions to handle device-private THP
entries. This enables proper handling of large device-private folios in
fundamental MM operations.

The following functions have been updated:

- copy_huge_pmd(): Handle device-private entries during fork/clone
- zap_huge_pmd(): Properly free device-private THP during munmap
- change_huge_pmd(): Support protection changes on device-private THP
- __pte_offset_map(): Add device-private entry awareness

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

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/swapops.h | 27 +++++++++++++++++++
 mm/huge_memory.c        | 60 ++++++++++++++++++++++++++++++++++++-----
 mm/pgtable-generic.c    |  6 +++++
 3 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 64ea151a7ae3..59c5889a4d54 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -594,6 +594,33 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+
+/**
+ * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
+ * @pmd: The PMD to check
+ *
+ * Returns true if the PMD contains a swap entry that represents a device private
+ * page mapping. This is used for zone device private pages that have been
+ * swapped out but still need special handling during various memory management
+ * operations.
+ *
+ * Return: 1 if PMD contains device private entry, 0 otherwise
+ */
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
+}
+
+#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return 0;
+}
+
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..4acdedf84fe6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1711,8 +1711,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
 
-		VM_BUG_ON(!is_pmd_migration_entry(pmd));
-		if (!is_readable_migration_entry(entry)) {
+		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
+				!is_pmd_device_private_entry(pmd));
+
+		if (is_migration_entry(entry) &&
+			!is_readable_migration_entry(entry)) {
 			entry = make_readable_migration_entry(
 							swp_offset(entry));
 			pmd = swp_entry_to_pmd(entry);
@@ -1721,7 +1724,37 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			if (pmd_swp_uffd_wp(*src_pmd))
 				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
+		} else if (is_device_private_entry(entry)) {
+			/*
+			 * For device private entries, since there are no
+			 * read exclusive entries, writable = !readable
+			 */
+			if (is_writable_device_private_entry(entry)) {
+				entry = make_readable_device_private_entry(
+					swp_offset(entry));
+				pmd = swp_entry_to_pmd(entry);
+
+				if (pmd_swp_soft_dirty(*src_pmd))
+					pmd = pmd_swp_mksoft_dirty(pmd);
+				if (pmd_swp_uffd_wp(*src_pmd))
+					pmd = pmd_swp_mkuffd_wp(pmd);
+				set_pmd_at(src_mm, addr, src_pmd, pmd);
+			}
+
+			src_folio = pfn_swap_entry_folio(entry);
+			VM_WARN_ON(!folio_test_large(src_folio));
+
+			folio_get(src_folio);
+			/*
+			 * folio_try_dup_anon_rmap_pmd does not fail for
+			 * device private entries.
+			 */
+			ret = folio_try_dup_anon_rmap_pmd(src_folio,
+							  &src_folio->page,
+							  dst_vma, src_vma);
+			VM_WARN_ON(ret);
 		}
+
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
@@ -2219,15 +2252,17 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			folio_remove_rmap_pmd(folio, page, vma);
 			WARN_ON_ONCE(folio_mapcount(folio) < 0);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
-		} else if (thp_migration_supported()) {
+		} else if (is_pmd_migration_entry(orig_pmd) ||
+				is_pmd_device_private_entry(orig_pmd)) {
 			swp_entry_t entry;
 
-			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
 			folio = pfn_swap_entry_folio(entry);
 			flush_needed = 0;
-		} else
-			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+
+			if (!thp_migration_supported())
+				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+		}
 
 		if (folio_test_anon(folio)) {
 			zap_deposited_table(tlb->mm, pmd);
@@ -2247,6 +2282,12 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				folio_mark_accessed(folio);
 		}
 
+		if (folio_is_device_private(folio)) {
+			folio_remove_rmap_pmd(folio, &folio->page, vma);
+			WARN_ON_ONCE(folio_mapcount(folio) < 0);
+			folio_put(folio);
+		}
+
 		spin_unlock(ptl);
 		if (flush_needed)
 			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
@@ -2375,7 +2416,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
-		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
+		VM_WARN_ON(!is_pmd_migration_entry(*pmd) &&
+			   !folio_is_device_private(folio));
 		if (is_writable_migration_entry(entry)) {
 			/*
 			 * A protection check is difficult so
@@ -2388,6 +2430,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+		} else if (is_writable_device_private_entry(entry)) {
+			entry = make_readable_device_private_entry(
+							swp_offset(entry));
+			newpmd = swp_entry_to_pmd(entry);
 		} else {
 			newpmd = *pmd;
 		}
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 567e2d084071..604e8206a2ec 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -292,6 +292,12 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 		*pmdvalp = pmdval;
 	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
 		goto nomap;
+	if (is_swap_pmd(pmdval)) {
+		swp_entry_t entry = pmd_to_swp_entry(pmdval);
+
+		if (is_device_private_entry(entry))
+			goto nomap;
+	}
 	if (unlikely(pmd_trans_huge(pmdval)))
 		goto nomap;
 	if (unlikely(pmd_bad(pmdval))) {
-- 
2.50.1


