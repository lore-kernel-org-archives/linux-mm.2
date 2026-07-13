Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF5EC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9A16B00BF; Mon, 13 Jul 2026 12:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79FA6B00C0; Mon, 13 Jul 2026 12:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68806B00C1; Mon, 13 Jul 2026 12:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76BBD6B00BF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:18:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83612C1383
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:39:37 +0000 (UTC)
X-FDA: 84984163194.09.3BD6F10
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012014.outbound.protection.outlook.com [40.107.209.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6E191180005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:39:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F6cEHZsA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783957174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHCkHRk1YLI3qGCyw2qXjXWdin9xpTSnXU8htlZvsaA=;
	b=mhbjiIoR3gi0dGhQ35xZoKTJqdPOEFsGiSZpoKcfjkzuIfzjfMY7Cn5sUxUpyAQ5bgJkZT
	6iHEK76qmUF0ymlrMxv/BsAE8fnogZv/hZoXuPY5eayRN3lKQUxmrpgbQGoX15/K063fdA
	QlLqc32mEJnVQTZehntQSSPpabDJeEQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F6cEHZsA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783957174;
	b=VhAlps4SKnZnLnCffkOTkqs6nV+Uz7aFbUVUofCJYPeUFbApWm2SOqQbBgZFWk9hm5cYtB
	jHpGkIFbPJUiWihF507VDlZ5x40uWDn5jfCbqGqp0b+iK77NzGFLUPt9/X/5y50kFVNpb4
	b+ZuFtgjfv3UkGWc4BrDEEd8zM3hrJI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jpCfw2s6XBeuMauH57I4hea5Qt9nGnxOsiN+EaqmJeiALFDJODbrq2YBbuFtwzvCtD/XiUSmJqs7Kqd5s0l8zkIIohckn8z4B6vhF0za/gbhqpeSEsL/k0tj2stWsiDtYQpET0SfHBCZxmqaieB+hWtolmiv8WOVu63SIiY3XF05gQvErlLco4vOSmk1dwJcTer46HSkF6dTF/Anx4k/XEiNoYpKKtfkgryh+z7S+9z5nwZAsHXzAgfC2kfGvvuV7ORAvedCzy3u4WMkOouUQ5TSrj2gqYbjlWjbI5MHfRHjFMi4ZOTpSJ1ma9U6D7BykTu0nqnYG6YDM2/9d9E6Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHCkHRk1YLI3qGCyw2qXjXWdin9xpTSnXU8htlZvsaA=;
 b=tQJXVdIaKyYw9JWKspCkmjkAd0gGoV6aHGzlur3ZKv9Iw4DZVqyA/B2rr1Cy50Hs/gFANIytW+gxrcy4WE62/FPHiOH5+BtJh4MfdYDoj/fyAzPF1G4kbxgorEdz8tiwpWD0v0wdskbtyOj110HfqRRimTNIY2KSOfDZbTr9T5d8tvkeuWe1F6Qzrwityqc4FoM2Af6PWwkTwUzxwYOpsd7dsS0NzAZv3AhJG+7Uum4qqQ3rkjUTWQC51qnczZ5qEPcXgkYzlkQGQGWpSWj0CmstY0kiULpAACPBHOvWGKCC87J9RGFazZFNiYU+mmC8M+2AjhnYFTs/a5qjm8E9ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHCkHRk1YLI3qGCyw2qXjXWdin9xpTSnXU8htlZvsaA=;
 b=F6cEHZsAO75Wc7xFsNiIpvDlkXuTZufNK9a/c63m8TAXfhmkdutEMftOuR4AVU5tiDA56nMGEwnp98nzfzZ/eCRz+Bahwj1EwpyfSLGTRd8pZ/BI8DfWjTD3ryL/0suIRjmXj2A+4TI/hNrn7T0SWgAs558VtnoAZBJ4WP6Ao812cv7ZUWEt4mEtNubUV+q2ofH0zBA9qC62x1z4+EDnU2VZLGgcmvBpcTcqW+HRpD4igQzE4EBL9wxUp8K9clFy+kN2K+rx+Aunnx4+BCtj8zRljJG/8FCuGibTSGz/GuiGmCx51AT1GkbwV9SkRPsH5isK/HCcQ/GbIKj+MgCLqg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB9139.namprd12.prod.outlook.com (2603:10b6:a03:564::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 15:39:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Mon, 13 Jul 2026
 15:39:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Date: Mon, 13 Jul 2026 11:39:19 -0400
X-Mailer: MailMate (3.0r7017)
Message-ID: <F14401B1-7388-4C5A-A19F-E031002A76CF@nvidia.com>
In-Reply-To: <57cc487b-6ec3-4ca6-8735-f37644e2b0ab@kernel.org>
References:
 <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
 <b806c878-e1e6-4af9-8816-678955288d82@kernel.org>
 <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com>
 <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
 <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
 <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
 <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
 <A1606A10-AB38-4101-A058-8355E5E81C47@nvidia.com>
 <57cc487b-6ec3-4ca6-8735-f37644e2b0ab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1P223CA0038.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB9139:EE_
X-MS-Office365-Filtering-Correlation-Id: 358a2883-3416-456a-186d-08dee0f4e831
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AVeUQ479M38D+lVDkg8R78jnXmRlm4uIM+I2QVeYY0Oz3PwvNd+hDN8plHMJkoIYgTGsKF5kbWDAXLKOv3/oD8isMHlNkJHIYPrXchEt6XFkA3vjG14O7BVLMWnn0zFwWwCaqzfc1NFPwXzGPNM3rjhbCo932CrY5N8a2vQWdx8pNIdZeXLmaI8YR64Nfyr0/QTPGtRL/2G9F3QIjANfSDIiQkl7vfJwOw2/am8R+sVOoO85PuGsZcFYbFe97mPOH8amcPbzJkCCF1DBa8DfhOgv/7RY6opB/IOH1cR0GXrRLmtkByvOAeMhVkx5/7N9HEyNFtCoZircoHCWIv/w0Qws4faramKEU0+R1kt4v4/loA7f6AiK9fGmqA2H722u5bqcwGN1GDHoU7qFx9+IwMpEToYprLavuLkvdZp5jYmPs1Q7z2z5pAyp3GE6CoK+W7ZMWpjlezaLaYcsJqUGuMisiYk/Ntx130ULTFZJ9+kMiNDU18c/kLGEce66425uSUusbid0XtxIDh0PNm3V4zUpL0ZqmQaFlhC2Re5zJx+EZL5IiBVnL3KadjvlCGIuUzeEoN9/z59t6+tnNY0QreYhLMJmOUkx1L8zXtePUB/XrrFtllxMCK/VGmZuCwAph+EhE6PhwdxKLrLR2XKwMAGNaMPi+GJpJVtEzeXUutA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b21rNnZnM3JjOGZpZXBLWkVwS3hzdXA1SGthMDd4WmtTOFBzdjQ0ZWxlU1pm?=
 =?utf-8?B?RVU3ZFc3QUFLaDcxR3VreTBDZ0I1TjFXU3cxeVlqam1nVVB6QlFlNUptUTFq?=
 =?utf-8?B?ckxaN0p3ZnUvOGdXbkQvSjNQZHZPVlBJbWVKa25pQVR4V2VDeWpqczVPcU9q?=
 =?utf-8?B?TjNFQUxWTFpBRVVZTDVrTzRmWWNGaHB5UUtZcWtZbUNvcHFsRmdmaXJ0Q3oy?=
 =?utf-8?B?QkNaOThTT2tpWlJzQ2UzNkZxMkkyMENJcGdjQ3ZxREp5S294SGJadG1GeEJX?=
 =?utf-8?B?UXo3NmdoV2wybzZVejBWaWdrR1Vmb0E2NklMeFVSZ1l2NHR0b0p3V1RrRXk4?=
 =?utf-8?B?bGJnaXNqdXAzd091bFphN3V5TURrY25pMEdHOVc1aEVHUFBaaUkwNUJSZ3JN?=
 =?utf-8?B?RlZMUjZ6OVlIZEl0a1BwMEM3dHNxYW83Nmw5TzZVTVdNRXRmNmZQQnJKSHM4?=
 =?utf-8?B?eno0a0xGYWxVVHdIRXE5K2lyaXpzTDBJd0Rzak0wbGNkK3JzUHJMdEFvbE5O?=
 =?utf-8?B?WG9QSHZrQkd3N0Y3dm45NmxpK3ZjUUN5UXNpd3lKSTdEaEFyVnIzVHlySExK?=
 =?utf-8?B?WEdJcWU4L2xIQ1BCTHdNK2x1ai81WVg2SWdRRG9LRkw0R0szZ0tzdCt1Yy83?=
 =?utf-8?B?V3gyNExaNXJOUzdLbjhKMWpmZnVDQSs2RFZHWXZBOFc2ZnlZdlBVdlg4SUVo?=
 =?utf-8?B?UVgvdVZlNHBEcXhjVi9ZWXVrMFR4U21Udk1oTkhCSDczeUtLcjYyaFl1ZDVu?=
 =?utf-8?B?c09oQTVsMFdwN0hkNjhFVmFmeGUyZTdibEFzZENabEtDbklMYUtGNXdQWStL?=
 =?utf-8?B?QnFzOFFVQzFkdkU0TFVHU2t3d0g2M0duUktMZU1nMUVsWEZ0azl5NENGWEpG?=
 =?utf-8?B?K3BYS3JVUktuQVQxcWRJYlowZWlUM2FPc1ZhMW90Sm5yajdYUklvQXl3cWZV?=
 =?utf-8?B?d25PWFR1TTBBNzRsSW5oSE5GQmQ0cVZBZy9LckY2d3FDbUVYajZtM0dJelV6?=
 =?utf-8?B?VzNWVkZXUFRaMWdHdzhEOUV2dWtqU1hyT0JlTUlLTlJjYklOZ1RXbWpIQ0RL?=
 =?utf-8?B?Vno2Mk5IS1kzTU00MlhaTTMxK1JublNzM3IrYXNCTXdnWEtDak1oMjdqL00z?=
 =?utf-8?B?Smptc0tHWGU1eG52N0RqTnFZMmxrN3krRXVzeS80Mk04NVRVS0N0MDRSR1hJ?=
 =?utf-8?B?UENwMFM0eG4rYzhkZGR1V0h5YlMyZFhxYUNaY096bkNacGJFS0xKdTJWcDFE?=
 =?utf-8?B?WjYyZWdQYnczS0E1S0MzS2hKVER0aGZEY3BBS1krNkJEbkY4enFHRUx4cVB0?=
 =?utf-8?B?LzhCTFo0VURIZW1qQW9xTHd0NXl6dnkwWkxtSitYUDdjb1pZZmxNbThubzN6?=
 =?utf-8?B?QmFVMzFVdnF3bTZvTzdTOUZONm93WE1NY0hxTkpBYVNsVStZN2NSSHFwNytr?=
 =?utf-8?B?bkl6N3BsUk9FYm5vTUxmdllnSHVCRGFuKy9tZUFTS3JXdEFTYjdXcnpQL1ZS?=
 =?utf-8?B?K0F2SUk1cUZHQ1JnSExsc0R3ZGVjYmplN2p5Y2dXZTMvUTRjMUVDR0M4dWVD?=
 =?utf-8?B?SVVOQ0lZdHFiNnB5RXVaWGtici9DckFyY1B1blRabDJEQ1ZMWDl0bElXdlNv?=
 =?utf-8?B?d2FTNThkRTF4WXNDRjU0QVRKVVNZWHFYU1ZhMEduc09xTDFZNGZtY0s2azU3?=
 =?utf-8?B?Z1ZMdXNiMXhrR1hzdTZIRHc2OVRPNUMwcWlGcGc1NXdxdUZPYTNMenR5OUpv?=
 =?utf-8?B?V1RZQ0p1SklGaGYzLzRWMkpCOEswKzBFZHgzWllOdDhXYUVaeTJDWXVSUW9a?=
 =?utf-8?B?ajVQVTNjN3lXRTNhZVF3RHVCL0ZFT2xXajUzN3RrOExWM25tTnVtT01QcGla?=
 =?utf-8?B?NjFqQ3ZIQUZGdlhQYTdFUVEvbFRwaDRIREF2eVVJVkJHNGsxVW9FbkhGMU9u?=
 =?utf-8?B?U3ZDcjAzeWpEbHNEaWlGYVY1bzVVR2h4cmx6cGZkSHdESVhtVHpvNldyM1lw?=
 =?utf-8?B?amRkU3ZUUStnK3IyQmNXVmFHVDg1YU42Z0ViU01zWlY2WjN3TUtxaHNFU2NN?=
 =?utf-8?B?YWRrMHpmZlJTL2hleVBlalRXS0RuKzdHZlhlSG5icFhEb1pZVVZOQWV0SlVO?=
 =?utf-8?B?bitVWDR6MjVsVUNhMSs2M3d5SkJpcXIxV203WnY3SVp1dTB2bm9ZVCtYK0xj?=
 =?utf-8?B?bEhnMmFBZVVsbzZYYXhYNFVGOVZNYzJGUnVvNkxPMmU0ck5TRW5tc3diaUJU?=
 =?utf-8?B?blhyMDhndVdzRzQvUnhDT0hHU0U1U2tjUEZ5b2ZacHFvVzZxUUh0enBYSWpl?=
 =?utf-8?Q?lzS42dTSX0yuaHVIji?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 358a2883-3416-456a-186d-08dee0f4e831
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 15:39:20.6932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoNfnMIG87mNaf1J2IE7m1cWwX9S2VLzQXnXKFd2CFEK9gUQ+LG+gZZWlQqRZK2o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9139
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E191180005
X-Stat-Signature: 6ixc6m14hxw1gnoqcj9pctuztu79n7ki
X-HE-Tag: 1783957174-954553
X-HE-Meta: U2FsdGVkX19wngEhh3abKkIMmzSe+S3y336luMkoZdZhJfwT92+igA4xTq0wlkMFRfTRwTCzSkHK+5FFuA/g+ncb+IS98gGyYu/hlhnMs2bxrNY7pRXM3X08qq4pB2AHSAKhsqVYQ76UzeMqsk6InHb2Z6i4j2zkk0Cglc/B7eaUeqFkUvqDFzU298CZfv8YUqUUvm6sdrCrov6fVGnZHM98xCOlmT59WIzPkgipqxE77F119m09tjKcHWYXIPCbqNXy73zGZHtfMtDIK4Ns57GfS+OHcmmUW9NTFImK+TD85VAw99RpdDyBQL6wSza71Rxlk5+9li1fRjo7oBJ+0gc2X06P/8jLvkF7erEpSC8yGNWHRnWAXBCOEwgaaGFrT/r2V8gvMN7lNob6Lr0ZuGX2FuRdLmP5Ouj5AMynPjST5lUYzzMDDxhmIs6oynqh3ROhbE86cfpfbafSVFAGsAw6feJlvjotXvNoNWh+SfG7zz2z6AtI60piKdfXogkPk9sQc8N7C7eydiKDexz++OVPUyHPPcSYrIGFHMSZZY2nupzRazLEn5JXX3h9UVIyINcU1R64+feg5CdWBuWnHeJkLl2GvG6mH7+nB+mgSZW9g7XFxakddza2PGlMsq/iykh5QZT88QW597AxXX37hSXOylZ51XN1kkCvICy7cnm9YQf1nxTQvQ4Naag+Im1tMEafdV7acaFaCPbvG7Qn9RpTuckRS63lhr4+7UpoEavYSSob2+ejpkOHTQIeBfvK3eMyCQatQvosBQYBJ/QY0cPGrNbRenrQvz4J9F3nKe4dpOrsSnulP2iXY+EZ6aYrf5GNU3e7O4+zXLDlOKE1ugqLVhkGtg4w640fLPCJDrwrrmV4qmjUWJ9coo5jcS2Jim2ex1T9NodYLLvbl7j0tyW1N+qdJIzsKD8ho7tBRPeFpLcfqjOH2TmtE4dsuw8lbwzmf66fxfFTDbp5JDs
 pgZxfCKx
 oTZpC5MscvEpQdZPyKp2Q4lJ0nLojZpChtuVBy7VuZ6UhcQ6jI4YSY6QmdQyAeMeI6jNhZaVKQGtS3QGWrGZ99uEXCiv+A47gaPShvF5w9PvehlbR623k1T3HGii0Sy3drIJfmUaTZ+1mLoRZMPumABkgOhdRJCKi5BvSvV5WiQa9SkHfIbfAkCpKfopcz1mxi3GbKlYdbwMhCpbxHFDwZXn1LK+DwkS3XIRtHRrZsdXe40Hz7RQIBvknFuuhAJuyPuinw+1W+TuvHudauk0xzRyuLEaUQoyViNbYfkgS+WSjewCUWufA36wXvgdmG/WtR4+tz0Vr+C05vMcy/tiaNEMrfBWvSiGipxyhk1laOrclFcurFQzqzWL+n2kpN61yHpz1RB2EZUwiN3P66rh5oCH7yP5G7KFyCxx+rBUg9RArZIXWDgZZVLH3ytjtLejLTFTFdSEbn4AzZlo4VJFy1bj1ksAcoK5ul+OkqpeQ22mZbflnZKoRReqaT1c0I/ll/6Qh+idkZHYUBCCBeGGqRJtTeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Jul 2026, at 11:25, David Hildenbrand (Arm) wrote:

> On 7/13/26 17:20, Zi Yan wrote:
>> On 13 Jul 2026, at 8:57, David Hildenbrand (Arm) wrote:
>>
>>> On 7/10/26 17:35, Zi Yan wrote:
>>>>
>>>> Not all the time. After a folio split and PTE lock is dropped, there are
>>>> different cases:
>>>>
>>>> 1. no page table change, the collection grabs the PTE lock and continues;
>>>
>>> Yes.
>>>
>>>>
>>>> 2. some PTE(s) is changed, the same as 1 and the collection continues;
>>>
>>> Yes.
>>>
>>>>
>>>> 3. the PMD pointing to the PTE page table is changed to either a leaf
>>>>    PMD or an invalid PMD, the collection cannot grab the PTE lock to
>>>>    work on the remaming PTEs, since they are gone. For the collected
>>>>    PFNs (they are mapped more than once) and folios with elevated
>>>>    refcount (they are mapped once and unmapped here as an optimization),
>>>>    they will be processed later in migrate_vma_unmap(). Since
>>>>    migrate_vma_collect() is best effort, there is no need to revert and
>>>>    try to recollect from the beginning (to get that possible large
>>>>    folio or skip).
>>>
>>> Yes.
>>>
>>>>
>>>> BTW, recollection will be more feasible if migrate_vma_collect() does
>>>> not do unmap singly-mapped optimization, since in the case, no PTE is
>>>> changed, we just need to reset migrate->->cpages and migrate->npages and
>>>> restart from the beginning.
>>>>
>>>>
>>>> Right. The PTE page table should be gone and the original PMD, pointing
>>>> to the PTE page table, becomes a leaf PMD or an invalid PMD, since
>>>> someone changed it when the PTE lock is dropped.
>>>
>>> Right, so I guess we'd have to remember how far to rollback, and rollback would
>>> mean resetting migrate->->cpages and migrate->npages.
>>
>> For case 1 and 2, we do not roll back. For case 3, since the PMD is changed,
>> we just roll back to the start address and set migrate->cpages and migrate->npages
>> both to 0.
>
> Can't we walk multiple PMDs and have data already in there?

migrate_vma_collect() is the pmd_entry of struct mm_walk_ops, so it only
walks a single PMD at a time.

>
>>>
>>> And for the entries we rollback, we have to decide whether to folio_put() and
>>> whether to folio_unlock() [fault_folio != folio]. That's the confusing bit given
>>> that the code is rather "interesting".
>>
>> IMHO, it might be much cleaner to remove the “unmap the mapping if the folio is
>> only mapped once” optimization, so there is no need to roll back at all.
>
> I guess most folios are only mapped once. Do we have any numbers on that?

I will defer the question to Balbir, Alistair, and Matthew.

BTW, for this patch, since there is no bug report on it, we would like to
fix it properly without worrying about backport, right?

Best Regards,
Yan, Zi

