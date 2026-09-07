Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C56C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 19:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE076B0092; Mon,  7 Sep 2026 15:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E646B0093; Mon,  7 Sep 2026 15:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D576B0095; Mon,  7 Sep 2026 15:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08C146B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:48:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 938DC1A0297
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:48:21 +0000 (UTC)
X-FDA: 85188002802.22.F6BEE83
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012030.outbound.protection.outlook.com [52.101.53.30])
	by imf12.hostedemail.com (Postfix) with ESMTP id CBA4F40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:48:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ig+Pmq6e;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788810498;
	b=xZ2u1gflmDP5b4ZUhMlZYX4C7Y7BeR/T5r31QJSfPRKEEIP+yNG/4rGp99vaphT/qqbnrO
	8etq1LUFDJwmSOOmWDgohsK2vl+cc6f+zsV7tTvvqRE4Qhwyes215Y1W82C6SrPbRRmka+
	aXwFdywwGyYnx90wtoD8IhcciKMjNqo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ig+Pmq6e;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788810498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2k4NKfXrrV5ZJlPdKZJ9vvdflcEn1xGlFlG123xAWrE=;
	b=cXO4Kc+1841mh6XtXTXuGSz7ciEgswZXs/MmzD52DQqcLDfRYDKwx3PjIL5EprNfcg8zzN
	UqRaDzPCHl2+WUNzje8AnVUpIOjy7qmfK6Y+Pk4CZZEKCXFFy2y/sFFkCLPZuvovIqoxZN
	yfajhzgHkRG4bbyi8/Pj1/zyCzyaFac=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TJwEZky97n3gz3ZStm1B3pWkgUrykz+krE1LmCMccbVvmm4q8V4rKrAe/UjEClhmIEmQmxQzacZfpp5iSIDiQeANO2jCy1u7/UjbXFCyPbsK4K5i3WUMW0mAg3qA/+tiIOO6xQlXkJZcUd+2WlY5gs3hhIA2gBQ+hbqhQgcWJOFce92nOZdKe4ff2eNvPC4qcrM3sHIxUTk42KiMvkkAn74I3p3GF/sZ8zA+2RdseFSwJZdW7vgILqCqMlrW4fE47C5YqVGr9szQXT7RT77XKCi/6aee01QrMYlZyJMYFvAZvc8tWWhvagFarnXCpQ5lANAW+Jan9EwMPnQGCKyYsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2k4NKfXrrV5ZJlPdKZJ9vvdflcEn1xGlFlG123xAWrE=;
 b=VN6QiNGeICZ3uYT4E1z4a8toxlBkytsshf4audCCU6T1hUtsFtOD6W/7fH+Ym2K4Snk5yOV+hi7JHP7VZ7Yd+1Yl+BrLSk3GqIbOYpZv95NqNN8T94XdBOjkA2wkHPdhSEx/eM+PPnGlS5fsVimsb44zLxfUHyatf70rY34y7xJRQmoRc2sOs47DeXAsSeyZeHq+XlXOBS9xRBrqrHKIjzHra/WLvJslIeIyWffrhHYLgBWmfChIyZ/qrU1azRAaEqfNsrlzRcQwz7niKSEOWX0+h4famnu1A0/s++vfwaaQzAUFNh/qb0zRFuedwvECRM3svy6KqX/cDKcLvfIzKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2k4NKfXrrV5ZJlPdKZJ9vvdflcEn1xGlFlG123xAWrE=;
 b=Ig+Pmq6emuAPzEUXfVmLmm23qaaf/woMV0V86I542bkQHEbMUr/82g2/jB8gMit+Wz2ZFojZiRB54USAZ9u8SVhVZ841QNKcvCcunpP+zpiSxNPI7v12LwL4UvVf586qjveq5AVZ78KfarLYFxFhJMZnTiuHNGPbRTiDZW1bdJ0aSrbAYFxjQ+84zxxVIykSOp/zfno87ZHgjAldQNEOGKTjpt1+spKkCzPR7GEjDk2LE+2TAYZD5NeVPIx7GCrz4z6ATXZ50hhR30K5q3EEqDIdj+SoaYfK20dvC9EpU2UQlDGsm9X4Rsz3g84Vz9dkSIUy8h8TlbGX9fYg3bAPgw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB9056.namprd12.prod.outlook.com (2603:10b6:930:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Mon, 7 Sep
 2026 19:48:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 19:48:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Sep 2026 15:48:12 -0400
Message-Id: <DL9CEBN36P01.1VDGI5DUQE2CK@nvidia.com>
Subject: Re: [PATCH v4 09/17] mm/huge_memory: rename remap_page() to
 remap_folio()
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Yeoreum Yun" <yeoreum.yun@arm.com>, "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>, "Shivam Kalra"
 <shivamkalra98@zohomail.in>, "Kairui Song" <ryncsn@gmail.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-9-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-9-b532a3f20e71@tencent.com>
X-ClientProxiedBy: BL1P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB9056:EE_
X-MS-Office365-Filtering-Correlation-Id: d45beaf5-ee88-4cab-d663-08df0d18f3f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|4143699003|10067099003|6133799003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	o+gYcLZR49s4J7BmGmjs1frtue5w9NGQsUcIC8Viitwup5lesG6Vscg5NXeCFD9Hs2ig6Xapr2/X5flWxqZDIg29gJ1fX/nU62mwnoAPPGlLKZICi4Cl0Xf0lkUj7g9PLlZZq1Ay4wNr4Ghtpttae9ifRP1O1LuOtqSQ8RrdB2+baTc5Wruph80jjsG5pjiLox1+7Tns1vBvjM4w/MjNKU7/hLqYFBrrl9mjcJocT68SC3M+Di+rDYCvNzbyfpW9yR/5mlR2RMpDaGRjsZXVx0JDqPOezY4eR0pWS8R2Vqv8o80NUYdiDnYjKyQWBRs58Ihws/PaF+CjPy8E22AV2sCMeHcIQu0nkU2jMpW9IoP0UeOAOwQcwXL/1d88UcG4d3JRkp3vNaC2asSmBF5rcuixRWDX1pCAf16XkD9TOqxWpsD7rZlKiXLzckytA68+pbIePt8uMBheD9dCxIyZsk/ZbU4gD0JeRKEjeOLmMrd+Or1hIFLzCoaXSkYbtG/oGLlM7SBvmCPEal+zilI6bme8NEl87QZn0RMIuNAj0wnslBRSx4/X+miqaDbxefuyaICeQlBNiO2wzyxQkCaVUzXomghYT0HypyS+MCuUoYH2q7l278M65P2cHjcFnfRG8vqjbZFi98aiLVd+qQg1v7wZe2C0cvNjLHJc8BKD+XI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajF0SWFac0Vkdmx6eGUrNFFUOGpvemRWU1lKK2c2WCt4OFhjTGFJbWhESEhu?=
 =?utf-8?B?T3JZM0FNUE03QUFVVnU1b0d5NXZhUi92NnJVcjBNV2JENm5uV3dIeGN6T3Yw?=
 =?utf-8?B?cEtjUTlBVnk4RFR0SS91Z1dvZmJpbjk0STgwc0pkQjVDQk1xM0Z4ZDlneTNr?=
 =?utf-8?B?UERpMEMxV29NbFlvaHFWTC9yS0Erbmoyek1McFNUNE1SbVoybEpBU1dZZmhv?=
 =?utf-8?B?cWlxUXNDcy9QWXdJZFRzSW5EOWRJWVRyb0RxRUNnamM0OFN6bVZzSlJRSEdL?=
 =?utf-8?B?VklaaHB4NjNqK0xrZG1vNWxDUDhNcURpS2JVMzFGb3VqaHppVW5GV2xJMlVE?=
 =?utf-8?B?cUVjaW8wallmdzhwdENWUjJkeEs3NVhwZUdlZVRBK3FyVC9aOHMyRUpSL0VJ?=
 =?utf-8?B?b2tTWFZQQXJ0UWR5UGFYcFFwUTk4Sk1WQUdKVXladkhweTNJZldqM3NZRVlT?=
 =?utf-8?B?MVI5NDdWUm9wUXp4ZDgwSmk0WURBN0duNWFpL0g4cTJ2WncxUU9JRkd5SEZ2?=
 =?utf-8?B?cm10VXo4QWw4d25JUkx1anQ0TE9HdVp3ZG5tNmUyTXBERmZiK1pDd2pEU3pM?=
 =?utf-8?B?QzFIc0hJK3JxaWkzd2R1ZUVkQmhzR2tqck5EQTQ4VnpibytaV1BPb3F5N0Zr?=
 =?utf-8?B?YjVza0pBbnJTK2hScHhmakVvWXA5ZkJ2TEZGMUdkdlhwc0ZSQVhVOXYvc244?=
 =?utf-8?B?ZE9yZzU4Tnd3QWV5V3d5bnE5NmVIZlZsL1djM3o5cHEzTC83Rm9ZQUw1bEw0?=
 =?utf-8?B?UG93NHhvQWRibGNsRENEYjFPVjllUlo2RkZEOEtZVGdhVjU4OUxMWXJybjJw?=
 =?utf-8?B?Wm52dU5aeUd6U1A5Q3ZCdUs3SkpnTWZpZ3lrQjBsYWhDN1N1TVF6M1lzU0J1?=
 =?utf-8?B?U3h6R3pWa0V2MllmTTJuK29mQUcyS3JoTVNpbCtrQnYydURVbSt0dTVYamZx?=
 =?utf-8?B?WklWMWlqU01GM204WFArbzV0SjFhczhGR2s5dHJncjRZZ1lyU0ZKNHQzcFZN?=
 =?utf-8?B?MjZxSnpBQlBNUFcrK283YWRXQUpISWFvenZPTW1wbmRBaWR5SytHV0NCdzhz?=
 =?utf-8?B?ZXNmWlhKREZUWUN4b1Q0YkZvazhhNi9rYVk4RjdrblV0czFEUFVKaVpyN1Ju?=
 =?utf-8?B?WmJObndVdm5SdXZLa0xEV0FqclhWY3JzazlRSmhKYlc3eU40Zzk2SU5VbGhK?=
 =?utf-8?B?cm15dG5rbkhBODYzWGJlNWQ0R3VkamUrb1BUVHlxckNXR0hoRG14UHpQekVV?=
 =?utf-8?B?TzZ4Y1hOVklMb0Z5WXBaUS9YMVpncnlZNDErb1UySGpsdlZ5L09DTWVYVFEr?=
 =?utf-8?B?RDIwaXhaVHhOUmp2aEFxeU1Yekd5K3ZvUEU0ZnRyL2hjeGs0S1JUem9FNDhi?=
 =?utf-8?B?Q0RtYTNtZG9sSTRJbGlUTHUwTEtNMGF6TFN6c05LV2E5YnpXaC9xM0cxam1O?=
 =?utf-8?B?U3ROMERnZG1BOHRSTnpvMG9pNlplOFZXeHRhR2g2U2orbk9SSmtSRnNpRGs2?=
 =?utf-8?B?NUlNZnhab3BIVVlRamdRaVVNWFp5S3I4aXo3RjVMVVdnMVNFK1BaUnJQWktp?=
 =?utf-8?B?bVowS2Z1ZnR4V2dsWUNKK0c2SlRoRjlrbUQyZE5JYUFseWQ3ZmpOR0liSEhu?=
 =?utf-8?B?QVgwRjFVUDYyYjNiS3dwMldzTkMzdldDaVFsM1ZDdlYxMnpVcHAvTDAzK0hC?=
 =?utf-8?B?UkNNd014NDhXelF5ZlN6czlxa2ZNdGJMQ3plMXEvMTR3RkZHeUtBKzM1MkZp?=
 =?utf-8?B?bHJPYkNNT2t3WXAzeVhNczVVZWhYaEJSRldyT3p4emJvRENrcmNTQ1d2ajZ0?=
 =?utf-8?B?YS83M3pvQlgyMXdLaFBNZFVuYjl1UUZNVXdxVW5ZQVRXRVlMMWZSdGY0cUs3?=
 =?utf-8?B?WGxuVGtnOVNaaU1RdEhTdjQ3aTg0cnE2TnJHYS9OUzhFc2tFOFBtejFsLzVs?=
 =?utf-8?B?QjdNUkhsTTJ1Y3RiQVNVL1V5R2JGVWtzRmNNY0F4cXB3NWFIVFR3YTNKTXBl?=
 =?utf-8?B?VlRwZTZsRDJxV2tIKzlVZWxjYVdUTUZoZ1V4Rmtkd2xSaEFYVFlUMXQvNkVX?=
 =?utf-8?B?Yjk1RFVUQXFlcHAvQjZBT3RQdk1uSzJXVEdlcjJrcnRHeXhOMGFYMkZGVGJx?=
 =?utf-8?B?NE1YTzRDSWcxK1c0NG5xeUV1MkQ0L0JXVDlFczV5RWFPTnZXeFkyUVRTVWNL?=
 =?utf-8?B?cUEzTFNrMVZvUkNCS2Q0TUtPaGNHUjJuUEkvV2dadXFVcFpZWEJla0F0TjJq?=
 =?utf-8?B?dkEvbmF5NG1EdXdFUld6L3ozLzRydnZyYy9IOUdRZXRGOFM5ck5GZDczQVlk?=
 =?utf-8?Q?GR4ydqYUdKihElUUhM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d45beaf5-ee88-4cab-d663-08df0d18f3f7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 19:48:13.4317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c0EnJi6IpyIKGXtvHK1EJT/+lYoUrTdfQ3DZSO0pNn5trl/piFwnuDeRzGWFhoiL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9056
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CBA4F40006
X-Stat-Signature: qk43rik6485gaubi6mfhwrxiyuqghh5b
X-Rspam-User: 
X-HE-Tag: 1788810498-34782
X-HE-Meta: U2FsdGVkX19JPWfxZC6/uqDPbQtSoZRcQYhEvKhbFUkhJKgJm6xE/cWwviZnjuxHAAGrO89vcbIAU5u+UYqZwIIZ7nK/zLDGEEJwzTcPymWUWeArEqgHLNbml8WzruDDGyA66BAk457MhiuUghZFcAof7OMgylKI0jaWt6aFVAwZ8ey4ehnMULJ4MMA4aFCAl+zQUrZ9IplpgR89Rhuq5pTevtD0cbINMs4LVkut7mxNM03j//Ed6xzNbkO3pob1g89iwbZrE3U5qJfHawZtPIo02u64Y6K4T8PCaGDIqwIHsPY4BPjXPGL50oL04UUusIXLmwuaJoOo72SLxGGjUSQ00d7MEPDEwF6+pqz+77C+nulRJrJu4DN3rXVP1EMVjLqquYHD/WOHOCS8V4ArykBiIW7Ks+VW7XYuUYsCs3/62YopJ3CjpH64qPX7jCcf9I92X56F5U9kLbFT6NMdWqNhQpIxOi0ud7DBsayXXVyHcCHn8iTNITkATeRLWZ0Ka2dZhR1ZmKbN8LqMMVIDF+CxHmDXEwMTkx6dUNCjdcwT+ZGjT+ARc2uujSw7FUnKzp4S66nocWMSLGRfkdIReeif5QLfsp1asRmtU4sTjp5Sr9q/EImboUMp8I6p8D52vjbiaQyx034oXWouNUuMsjTH1gIF7zo8EPZ4UxzNJes/s7kp07o+8zMLEI2EsDNoDDO2nqwhCKyXpHGnng+SxKdWvhcJ5zgHln5wy1FNMT7wu4LwIqASrefzszWUWLZ7ILQpV4iH7fsOv1x9WrIEe3S8dGbXTt1As9HjdagteEROwUQh1BdbyvkAvJL/KXCZ5VDFGLkCk/GiLWwa5dq4XDnXIO1HSit/zvnBaO5L/IfYNBsNqdzkyLuhjlIjTcHyUMkppQwsqMAXB426Jg2+PFtSp7mLnlwUY5VLvk8c81bx4LMmvGgmNA+/KFFkTBQbOq35EESChC1uvXPNyWn
 jgjDw3Qx
 JDyNl3hPwvt6zkotGbBbUi5Vny2ANNrHCAzyhiMa+smFr8zufc4AuAFCiFsKUVJhWdBTjZE5FUyPKN+MSAg1B5DkRyFywMdqhl4ZF7Y1YdBCDiFklCSxNZRul64jfiNA6fBMNEynBqmE0L8bBQ8KREL1OiDgpUJnBW+Ln+xCEOXWJFWTxL9WmHtI9R8crzLHpNfP0/3hHEab7kLfAWFOz1wrVySMawEmx6bnvTCiuNPdwZNvUluuRhR2mfJ6NDQOxmnK/cdC2ZZCSId5C2BvTE5dcPsMt1dm+sclU3CwIzbxUY7B7KacCMykUcGsJWiIcmTpkiO9GoDXlT30t46IjBz5/l8sv0qacYeckaGTtqSAdpQQEazMu9IOeXzFoMoWN87t7vFIQ1dSPs33QF5l/J4SqVEEavJOglNO+jBK38N08J8tfW7oux7Lat4EzFAQlzvdhWks728agyD1Gy9+82DJNwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 7, 2026 at 2:12 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> remap_page() now only has one caller, __folio_freeze_split_anon(), so
> rename it to remap_folio() to match the sibling helper unmap_folio().
>
> Also add a VM_WARN_ON_FOLIO() documenting that remap_folio() is only
> ever called for anon folios: unmap_folio() currently leaves file
> folios unmapped after the split, so they need no remapping.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


