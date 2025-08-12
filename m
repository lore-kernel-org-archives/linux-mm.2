Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F443CA0EDA
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 02:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44158E00B0; Mon, 11 Aug 2025 22:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE768E0045; Mon, 11 Aug 2025 22:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98ED18E00B0; Mon, 11 Aug 2025 22:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9A08E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:41:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1884D11512F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:41:14 +0000 (UTC)
X-FDA: 83766553668.24.9E7174C
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5412F1A0006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:41:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fuwfc53n;
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.95.88 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754966471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ar5uF/GQ6lEI7wxq78t4b6Aa3GN8D2TEWsnX3bw6rKI=;
	b=BIBaTvGqHLyA5Sp0kurNq7yCqaqRamU5BqzR/MB44/w7dytNdvGLkEnNnxOTT4lk5dkBF6
	NO5FqhhEsjYSfePPCZ2vlhnFopPAhXWQkJrNSEyABhBoPASDbNpSU5JNWuplSPftnB0rBG
	EVLHrS5vtHkHkPDOc8cmqLCs8Ga/3qs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fuwfc53n;
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.95.88 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754966471; a=rsa-sha256;
	cv=pass;
	b=p4oNS/S1YrqPM/ZANhCzCIyPaPqwN68aeNOY4QFAh9zwbnwm+mxLhFKI35FnU4Xrw2rrsY
	GnveJ8hjejg0BG3rirdBWMAs8jfT9gEEKYLaby00YCStOA7pBYOFI1ujcdspxbuCwYqJxA
	fYSvhI8yfDk7k+9MVXEQn22DmWX0Ta0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lN0qSHqkYkgIBmhtkmUqtiRA8NTgXkyZWy1Oi/KrBjHleflMMkug10qp39KsGvpGxZLrstEX+X/rcVveF5GRcSGZTwKHFFRDVfRYVF8eAxg7FIc9p4a/2BraFjs+tLWyTksKI1zFFasLbyRqEShVp2QBU1acLb/Fig3cFtcfDDqivse1wTC98VIG4cHCvh1xRBUFmswkCWORDlRVcdC8OlBC1WdGOsF/h9zpnGj/jzKSQrKIxT2AC+LHzog4FCibr9wQxom56QRxOzvd5aqHuL/NgJFlK2Oc2VQVEKjp6YFJoWvgNcG95xpGB9NrCKdh9DsjTN4MBZdkuccChf8n1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ar5uF/GQ6lEI7wxq78t4b6Aa3GN8D2TEWsnX3bw6rKI=;
 b=PgO+2P720vwsDdsWgNLu3n2dxdv+X3IlYLG20Wmqde7V+rYW7Q4YvcUE2lc5U4hjncvcK6w6cvOiG+vrUco7qq1bcB1FL6Ah7CRSvNUVqhTTTUOTlaBjOeMBKE+IFgGSuTJbmyL3FEJFoBo2LiT9Thds4/tWvzvNWa2ia2GUmb0GojUQmQrkk8bN4BjCjU5d5qOyUb3+mmRSI2zEofieRGjuBJBWQAnxRNT8iu1NyrIRcP/IQd+vhsDGBUfkR6sEYhtFiX87ghwjmXPmW5Sn5ZHEbHerBAYWlJPJrrlNroSnrjRFllXa8mXkJ7ibq2nk+wH03TE2yEwdMREHVypzYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ar5uF/GQ6lEI7wxq78t4b6Aa3GN8D2TEWsnX3bw6rKI=;
 b=fuwfc53nbgL13OlUoUzRk0alTJ6xN/mHsiTlpxOgZKjqr+IsSfdPMSrmtpMv4UlH+0YdQquoUaSwUOngBOqPERWM0YvyZy+Q0R1feYeeY8LoKyBd1bRLMK0Z3sGVucYoBGyC+m1t6JVqGo34pQaLjEEP61T2Dg8Saw3M2YguRYVqCkfDYAfyX+ZAgCrHs5Kst1gzmJR/6HI1mBOx+yEQA9FmXmuRPVdk8KMtkKQ8jaT2uNWrQWucg3u8M771m1MFeZNllPQCdGIdpBBLin0+DrZ63GOLrI36E4tONut2dl9srrf/JaGijVfk3teNL6zK3JGr1FXPKdQcrLtojUxuWg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Tue, 12 Aug
 2025 02:41:07 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 02:41:07 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
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
Subject: [v3 07/11] mm/thp: add split during migration support
Date: Tue, 12 Aug 2025 12:40:32 +1000
Message-ID: <20250812024036.690064-8-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812024036.690064-1-balbirs@nvidia.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYBPR01CA0097.ausprd01.prod.outlook.com
 (2603:10c6:10:1::13) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MN0PR12MB6317:EE_
X-MS-Office365-Filtering-Correlation-Id: f584eb07-3938-413e-fdbb-08ddd949b041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUMrb3oyRWZENVFneVFFR25HQmkwcldHb2gvaHNWc1BydHN4UTkzL1Zud09O?=
 =?utf-8?B?TWZYU0dITkE0VW81RXV3SmpXQzhpak5COXNxRlFMVEk0V29HOFBwamFPM0d6?=
 =?utf-8?B?UkFUZ2VKTk5oMWpMdUFQZ3NMQ25JdGVkOG4zb3BMY2dwczRZNUhSVk93KzNo?=
 =?utf-8?B?ajdlL1N1aitWZ2RsT2tKWk1USUN6d2pSMEsxUU5FK2JaTmNNRFJyd05qeTlI?=
 =?utf-8?B?MlVTZVBNSUNuU29kaEM3cEJnUzRHWXZEOVhkUERUZXRlSFdvRHkwWXA1MTdp?=
 =?utf-8?B?c0ozOEZCSkszVUk3OFBKZXVxS3VQa0MyZ09EL2hmUnRXekx4dkIzOWFhQ1Ew?=
 =?utf-8?B?YjJjWXYrVXNKRnh2K1ZlWTk3OFMrSG5jWXRDSi9nRlFpQXNVcXBNN25ERXZn?=
 =?utf-8?B?K3p3WFBiNWwxQnJIaWdrMHhVeHh4aWtINStPT3NxZXJNWS81RXpobGpVT0xw?=
 =?utf-8?B?TUN1VW1nRmRlSWVWck4wSzZ0azVQVUQ4d2dGOGN2QmhMMHRBS09LR00wNmJu?=
 =?utf-8?B?ZDRHN29jK01NN3VwZWNSZnVJeTFLakV0aDBCSXl2S1FWb1E4cnMrVmt2N3JF?=
 =?utf-8?B?dFMyWWx4akIvbG1IbjVlV3IybURGK0NMM3BkU09HM2FSY1NzZ0V1N1FJSWNa?=
 =?utf-8?B?Qll3eUxkY2RFeVAxdFg0N0VCaG1ZSk0raG05NE94UTBlYXowMzZ5TWpaaHZT?=
 =?utf-8?B?ZkFsZnhyZkRHTjhONm41UXlpN0Y4aTN0YTg4cFlnNXlINGZ6RHpoS3NQQnlJ?=
 =?utf-8?B?bWlZMENCeFNKSzI4UEx3dlRNMjZOTjNIY09LelB6Sm9VS2ovL0laWnVvRVVQ?=
 =?utf-8?B?NkR0Tm9DRmlickZpRWR3NWFybVp6ZHBoR2FoS25sWlVCemxTclJIUUJzeWNt?=
 =?utf-8?B?WHFoM1UrL3hIT1NBMWNEQURTbm01eGFRVWZSSFRLZkcvOXdsUmxua2dCNVVV?=
 =?utf-8?B?NVBEY3VhRWZ6TmZKVUVBbWFOcVlNc3BRTU5QaWY1R2NOV29mT3BRb1VRekFD?=
 =?utf-8?B?OElFL3FrS1lITzJyZ2NsOFovTjZyQ3I4eFpTOGxUeWNqSzZtN1pSb3A3N2Ri?=
 =?utf-8?B?M0FRdVdYTnlDL3BHNjZnbHZYWEx1MFZnSFBjekxLaUovbURPNWFodHIxTElz?=
 =?utf-8?B?dDdkUFZ0Q0VPUVoxQVNEdmx2YmZpWVRYY1NzbWNORGNMWnEzQ1g5RjNOaWNQ?=
 =?utf-8?B?L0E2VXBjY1JvbXNLVDBkOS9hR2Z4UlpCWnl5eUExSGZyYnpYR3pucWQ2YnV0?=
 =?utf-8?B?ZFQ3NkJtdURrMy9HZjVxdEgrZTZ5WENmR2R5bVFVdmdqa3NOdGwrYWNWU0dt?=
 =?utf-8?B?cDV3bVFMK0gzN0dwRXVLZDlHaUhZU3h3QWxRS3Zxd2RjZHlUZHlyYXBneVd1?=
 =?utf-8?B?OG5yNVdKQTRhK0l3N2lWMFBoT0ZyRFBHenFrdUs4ZFV0ZDduMlRqdmJwaTMy?=
 =?utf-8?B?c2ZRZHJFVTlSY3Azd0U4ZjV4VC9JOWpjdDkrNmEwS1NjRkM3eXNpdFlNMmpN?=
 =?utf-8?B?bFFCQWlxNjdCZUlJeGRGWWhCVWliT2lXZ3RXMEprQ2VnU0Joc1M4dXAxVjVy?=
 =?utf-8?B?S2o0cytwM21Xd0pTcmQ2N3VTVUhCcGh0UUFyUDRNc2U2ZnpOdlpVaElrZXg2?=
 =?utf-8?B?VWVpRzliNlFHM3dBbDd6ck5PWC9STTJrWHNxd1B2dGkreWgyOG1sSkdFZWZt?=
 =?utf-8?B?UmZub2xYdHZzY3o2OVZ5VjdJaGtUVHhCc3IrZTdmd0x4RW9lQ05IZHErazNS?=
 =?utf-8?B?eTF4SVBKT0ZldnRFcS93MmsxODJqeHF3eHljZ1ZRN0Vxc2N4WXVwNWh2NmtJ?=
 =?utf-8?B?VjNCc1pQSVlaMmlDR3l1eVZJM2JiazlLUm9wQld6OStPZE9zVzQ3RGMvVFVu?=
 =?utf-8?B?U0c3K0hxck5ncXFDU2pWdUk4T2pxdEY5ZFJweW1ZN2IwMm9xc1FJWTdNWnRE?=
 =?utf-8?Q?kkTHehI6piA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzFOVnlDOXNNOFFlMExmREJ1QWEwd1VadGozQmlETDk2bWZNTE9adlRqYXlo?=
 =?utf-8?B?Wnc2dWdKbk9kZ2xiTm5FVzQ1VGpkd2JqcVo3d215THlUSHJ4UDJiYVdjUHNR?=
 =?utf-8?B?ZU9aWnNRK1pJNGNFN1JWeDJPRThHemwwenhvT2NneGk5RE5WaWhPRFVzcXFL?=
 =?utf-8?B?Vkxtb1ZUclFBOXg2WUVYMVE0T09jV1cxUDV2QUpRS1dMdENSMFFlUHdvNFlW?=
 =?utf-8?B?eGVZUzM0OGZzcEk1Y0FjL2gxM29HQnVaeE1nVUdEMjZoRnRORU1sWE5oaGZx?=
 =?utf-8?B?ZDMxc0NPSExZYTdDbXJDN1N5SHpjRkZzZmUwYmRxQm9ZK2RXZXJ3SDQ2azVX?=
 =?utf-8?B?S2kwTnNjaFBXL2JkSDlFUU94TEppMzJSWGg4b0ZYaCtlbUd3SlhSelBqSlVl?=
 =?utf-8?B?TkN4Z1BZU2RKUHVVSHBIcCtmM0dha3VUM3NMaTFHL0lWVG1CSHU5RDg2b2VM?=
 =?utf-8?B?WU0rT3NlYXZkdVh0STRTdmorNzd3bkpjaTZZc3JTSEtoR2xoRG5ZM1FoeDJq?=
 =?utf-8?B?ZkQvdUdaYW1rbzFURHVta1ZFUFB0bmhleVlneXlUajVQNTAzYko5VFNMOWpj?=
 =?utf-8?B?bUtFb3JaaS9DTHRtWVhpVXVCWXM4eGdOUURpd1pBTkR6UlM0N3U0UHhmNjRB?=
 =?utf-8?B?U2hGTVdvbVlEVUM0QlZ3OUZUWGc2Qlg5N0xyZk82SkJpUFl1YVV6UUtxQjFR?=
 =?utf-8?B?NStGY1dZSjlOb21SUjRNUmdUem9FVU42RlI3M2NMbCtqZ0lwQVpGeTRTK0dY?=
 =?utf-8?B?WnFKSE03Z09SYWg2TnpNUFhvalRFZDFFaG8xRGhadzJyOEVaQm5lNGJtNlRY?=
 =?utf-8?B?Ni9uYjBjeCtzWlg4WGtnSStrU2lIMXdrU3dTcXJvK25xMXMrYTNqRVg2NXhQ?=
 =?utf-8?B?N1BPd3Q5K1dzSFB0clVUZmp3WHVnb1l4TkM4ZEx0ZTVhUFJxSU1MNVJ0SnlF?=
 =?utf-8?B?ZTdlU3BSQklLNU1aeXp2SFFSK1U4TWlFNHJZMG9RdGI4VkNxUk9kdXlYU1pP?=
 =?utf-8?B?a044YlpzOWFXSHppbFF0ZFVMRjRiSkxRclc5bzA0aFJHd3JSdHlPZFVTWW9q?=
 =?utf-8?B?Q2RaejE2b0twNEdvVlVxZWNPOXc0dnV3Y3E1SDdJNllyamQyRlREdWNvQ2JS?=
 =?utf-8?B?Y3lTM3RpdVloc2tLUFZJS1o0NEdBVlFzdERYeTE5Q2lGL2RNeWd1cm1XZW95?=
 =?utf-8?B?SE1NQXk3RlRKcnpvempPWGJ4S0w0VE9QbW1DSStib3NBQ3RVRDNQUlFHK3Jp?=
 =?utf-8?B?TU1KMkxDdkM3VXYyNFNjVkV4bldoYUZIbTlXd2N2QWs0WDBhcXd4NjFXWEtH?=
 =?utf-8?B?LzVFNjBVdVBnbUNWZ1RaWklqNU5zT1VWK1dGaTZUcXVpcHBUYjRKUVZjbDZI?=
 =?utf-8?B?T0hLbVViVHNqN1NKN3FOcEFQVDFjbERzYmtCTkFZWGsrQ2RmRmNwTXQ3TTB2?=
 =?utf-8?B?TDU4cGl5SmhUcnNTeXJoaEs5Vk4xUWJNZW84YnFFQjdDYTJpN0o1aDZVKzE5?=
 =?utf-8?B?eTN3SDZ0ak1VL3dIZytGTWdBUnI1Vngrb2VwVkFMdm1PNzh2Y3FJKzhSUVdn?=
 =?utf-8?B?ZjlZT2MrYnMrSVdCenVDL0dEQi9ldXkvVWNQRUtQek9wVjhLQU9DNkZIS2lp?=
 =?utf-8?B?ZDJqVmJGMytCWnlxenhIZUJLcmhlSXVsNlMrc20xRHpDZ1ZrMFd2bkVMYkZX?=
 =?utf-8?B?UUhkNUZsWnRGczlWZXV5RVcrZ0MrZTQ4NkxKbThoVlRhMEtXZ2pkUUJHZDJV?=
 =?utf-8?B?cE16NVVTZ2x4cDIrbFdnY2JRd3p1US9lWWxDOGpoWk1rYmkwOVFoNFl1RVZR?=
 =?utf-8?B?OGpLMUh4eGlOdWFBSkZSN1BReTBpVDUxaEovKzE5aDlPNU9lNlA5ZjM2cjlH?=
 =?utf-8?B?SDZxV2VnTGxjcWltUHQvWVU1WUxlM09VbVhWMlFmYUtORlBKdHNkMTlLL0NW?=
 =?utf-8?B?aHVpQmVUYk43RmlUTWwrTm9obXIwazZ4dGtralhlbGY3Q211NkhpeFJ1Mllw?=
 =?utf-8?B?VW10NE5tSktGZWhydVpEZHdRbzVSL3ZJTFpaUG5RSmljWHVTK1UvbnRPRHh4?=
 =?utf-8?B?T1Q0TEFPWGpTWGRQaC9obGMzRFVDeVJJbnhFZGRQejhLZEFOTXN1ekVNR0lr?=
 =?utf-8?Q?kW4zjupnhXEYnIUxVUgORlBLQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f584eb07-3938-413e-fdbb-08ddd949b041
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 02:41:07.1338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1XNQS4+n1D1mZ2oixejFcSBwRxxQ5s4AercwY0f0LR4mvxi9FWk5U+uoJbtiJw5fDN9A7ao99JwyFdt4cC/GJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6317
X-Stat-Signature: zta9c6jdj5cyfxnj1hhozedzqqp9fru3
X-Rspam-User: 
X-Rspamd-Queue-Id: 5412F1A0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1754966471-936991
X-HE-Meta: U2FsdGVkX1+0YA5WJJjYA4S5wHXMtu68nwrwD861qEgoq8VjSoH2Z3KDN0qlGivxCbg/kmvBgBesK4YGrP5KfFWkkj1CxZPlhdUujFKxfsCxc2u4yxB/73f8C61DC0HJsSKXgwsT4m331QdBVHgq52+TQf0l6nj49qAAqHG+HBbppQlnLbwh7Hr8mWjaW+JMGs1Yv1hSPRi7tKVva2Znr72PAZxU+cAC2smMxSzmgNYYcZywYCLvMhCPDDn7qME2UuDBSIAG8hwCNrEViNhr5F3Feq29zN7YyytH6SLALlKspWXATy5ftTuP1zYgwvnGqWoySztzFucAKnbHTlZOam6oEESI3ISuRSfuB7hADC7QoW2uSNKs/v/oJoTX4RqF0C5+sKc5y83M7VhWVmx3eqc6ZSPdkMSjz7Dn3DHxy5pobu6yxfzTvJF4Pcu20kHSlfJcXaJrkegbPrFCZdw7GkHTURO0mWmdRWU8oSHInB4CV9gg2rrxlij+aXHaZVFQp93v8imw3ibBtuIs1VSboIRiOzZud8huMQbD9eg7IcbVKykCAiLJbP/2J1nJtc3RbUT0g1E9e3eomVXR1uxq2z5HjF4iUW8F1n43FwPL/dAK8pQje6jHOhDso20Ju7ooLp8yaV6/yxhn+GbBAvbIrUoEYjc1lOfAS3tS3tAiJRDO0kNSUl+W8yl8yp7Co/CGZgseZRxbtr+5xLYhZjrfSGgLnt0t1HovQXtMhykJdYqASkkbxizM9sZTN7SoaijgQMX9glvuo8DjHjx+oHKGD7/RzmSFq1Bywq5vkk6lBbiR4TJkDojJ6d7kt0v1zBayHcFUQMnThJ4dcQnGVbetOWXNfpVpyt1gCs/6Pte2Mt6Q+oMVC0Wb0drbCxWHpVDy1Xm3WVQ8C/RtPipbZghkBSgLM43X40o99Wppk36fZGy1uZ4iuTv+gJw1FQbYXQJDZT8SXZf2WphMD1Gguo7
 12RvlX9b
 uvm69wRkOB8V9TxKO9BTWdpeSoByIlaQwoadiXznS+wrXggpJ+Yc0J7gs80lk9GylveO4IJkDdw6uaEh3PzzEbOUBnahjhxznZEbBWcQuBkqCJqfs8YMsOhomWvdeq8mIOJ/yP2CA4+zAfZRmsPHlXJcpONBF+S9P/AoMejWq/N+nVSLkdRTlc3JnIMrAq2pwzLi/VhwCpMSmXaC2bW6hL6/zp+J2AI/8KDbK7u4o/Q2ws+0Nt4wgsjG4wgy+tcmzYMdfO+OkLrXXbGEx9e+sMOvTymGDplP9ERLO9O6cZybc4wV/RgA4a732h8jD4TdZeJmMrOAYlYsF7B65TpVQ/PAGTL1EO4abFJ//AaRcA4ejPg8prQ99BpoC6jxHXFlVxiK0M5j45CTWyaLolBuGFZf0RLcU1Dw2XXvLPY/FMCS/S8jw10BqvW/TVN96SDLGrAWLs4vi2dsMTv++BB2NQzZ54qgPyBGQ5v07Y0GEif/90jFL8u2uBn82Oq91Ts3al76eh0Umt4wq9Rc6Eu1Jucv2ikNuU/g3V/x0MMhMFesUbjsyTDFTeiPKLxnwH5JTcLgrptgG74j9wrsfk8+W+DF0OOhmoVElJYDgGUV4HnwhHQTvB5NZplqv0xRYNpp1U+RnSi6VJvpCYzStBNXDFWbpPbzpxwV6+fzoLvTZaQS+lurJtSGU7KVxkAFOt8yGUrbBB4bo9cDApYCS2xbFjlkiNvkzADox0ozLIgaXzO+An/BbVViZt8GgQdct4sixiLTX1yP1NyU8yB5CvFn/eXR+8NeBX7Foy1HKObO0s9DBteAjsN5ScTR1N328irwMEfCqzKl1z3WR+PR8NZ7Asrdrim7td6dkGfpeu7wjOV0UApdRFCSwxsmM8htU8uqfCNN0RF/MOyrHrj9yOCXTSRom8MRk/OwvLqTes5WIRKnStPAUniZIU/ikpzUOZqgvNqYYIRUVcmOOungxyXxvrCNgTL66
 hmLwwEnq
 Jdr2DmXSepw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Support splitting pages during THP zone device migration as needed.
The common case that arises is that after setup, during migrate
the destination might not be able to allocate MIGRATE_PFN_COMPOUND
pages.

Add a new routine migrate_vma_split_pages() to support the splitting
of already isolated pages. The pages being migrated are already unmapped
and marked for migration during setup (via unmap). folio_split() and
__split_unmapped_folio() take additional isolated arguments, to avoid
unmapping and remaping these pages and unlocking/putting the folio.

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
 include/linux/huge_mm.h | 11 +++++--
 lib/test_hmm.c          |  9 ++++++
 mm/huge_memory.c        | 45 ++++++++++++++------------
 mm/migrate_device.c     | 71 ++++++++++++++++++++++++++++++++++-------
 4 files changed, 101 insertions(+), 35 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4880fe98e46..52d8b435950b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -343,8 +343,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order);
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool uniform_split_supported(struct folio *folio, unsigned int new_order,
@@ -353,6 +353,13 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
+
+static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order)
+{
+	return __split_huge_page_to_list_to_order(page, list, new_order, false);
+}
+
 /*
  * try_folio_split - try to split a @folio at @page using non uniform split.
  * @folio: folio to be split
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 14dbce719896..dda87c34b440 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1611,6 +1611,15 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	order = folio_order(page_folio(vmf->page));
 	nr = 1 << order;
 
+	/*
+	 * When folios are partially mapped, we can't rely on the folio
+	 * order of vmf->page as the folio might not be fully split yet
+	 */
+	if (vmf->pte) {
+		order = 0;
+		nr = 1;
+	}
+
 	/*
 	 * Consider a per-cpu cache of src and dst pfns, but with
 	 * large number of cpus that might not scale well.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dc58081b661c..863393dec1f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3474,15 +3474,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
-		/*
-		 * page->private should not be set in tail pages. Fix up and warn once
-		 * if private is unexpectedly set.
-		 */
-		if (unlikely(new_folio->private)) {
-			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_folio->private = NULL;
-		}
-
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
@@ -3711,6 +3702,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @uniform_split: perform uniform split or not (non-uniform split)
+ * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -3726,7 +3718,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split)
+		struct list_head *list, bool uniform_split, bool unmapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3776,13 +3768,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
+		if (!unmapped) {
+			anon_vma = folio_get_anon_vma(folio);
+			if (!anon_vma) {
+				ret = -EBUSY;
+				goto out;
+			}
+			anon_vma_lock_write(anon_vma);
 		}
 		mapping = NULL;
-		anon_vma_lock_write(anon_vma);
 	} else {
 		unsigned int min_order;
 		gfp_t gfp;
@@ -3849,7 +3843,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
+	if (!unmapped)
+		unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -3936,10 +3931,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 			next = folio_next(new_folio);
 
+			zone_device_private_split_cb(folio, new_folio);
+
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+			if (!unmapped)
+				lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
 			 * Anonymous folio with swap cache.
@@ -3973,6 +3971,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			folio_put_refs(new_folio, nr_pages);
 		}
 
+		zone_device_private_split_cb(folio, NULL);
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
@@ -3996,6 +3995,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	local_irq_enable();
 
+	if (unmapped)
+		return ret;
+
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4086,12 +4088,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * Returns -EINVAL when trying to split to an order that is incompatible
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+				     unsigned int new_order, bool unmapped)
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true);
+	return __folio_split(folio, new_order, &folio->page, page, list, true,
+				unmapped);
 }
 
 /*
@@ -4120,7 +4123,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false);
+			false, false);
 }
 
 int min_order_for_split(struct folio *folio)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 6621bba62710..9206a3d5c0d1 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -864,6 +864,29 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	unsigned long i;
+	unsigned long pfn;
+	unsigned long flags;
+	int ret = 0;
+
+	folio_get(folio);
+	split_huge_pmd_address(migrate->vma, addr, true);
+	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
+							0, true);
+	if (ret)
+		return ret;
+	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
+	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
+	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
+	for (i = 1; i < HPAGE_PMD_NR; i++)
+		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
+	return ret;
+}
 #else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
@@ -873,6 +896,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 {
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -1022,8 +1052,9 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
-	unsigned long i;
+	unsigned long i, j;
 	bool notified = false;
+	unsigned long addr;
 
 	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
@@ -1065,12 +1096,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
 				nr = HPAGE_PMD_NR;
 				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-				goto next;
+			} else {
+				nr = 1;
 			}
 
-			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
-						&src_pfns[i]);
+			for (j = 0; j < nr && i + j < npages; j++) {
+				src_pfns[i+j] |= MIGRATE_PFN_MIGRATE;
+				migrate_vma_insert_page(migrate,
+					addr + j * PAGE_SIZE,
+					&dst_pfns[i+j], &src_pfns[i+j]);
+			}
 			goto next;
 		}
 
@@ -1092,7 +1127,14 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				nr = 1 << folio_order(folio);
+				addr = migrate->start + i * PAGE_SIZE;
+				if (migrate_vma_split_pages(migrate, i, addr,
+								folio)) {
+					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
+							 MIGRATE_PFN_COMPOUND);
+					goto next;
+				}
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1127,12 +1169,17 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 		BUG_ON(folio_test_writeback(folio));
 
 		if (migrate && migrate->fault_page == page)
-			extra_cnt = 1;
-		r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
-		if (r != MIGRATEPAGE_SUCCESS)
-			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-		else
-			folio_migrate_flags(newfolio, folio);
+			extra_cnt++;
+		for (j = 0; j < nr && i + j < npages; j++) {
+			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
+			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
+
+			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
+			if (r != MIGRATEPAGE_SUCCESS)
+				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
+			else
+				folio_migrate_flags(newfolio, folio);
+		}
 next:
 		i += nr;
 	}
-- 
2.50.1


