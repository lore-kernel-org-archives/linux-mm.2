Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57641C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC5B6B008A; Tue,  8 Sep 2026 11:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D176B008C; Tue,  8 Sep 2026 11:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24806B0092; Tue,  8 Sep 2026 11:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABC006B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:45:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 042C01606D6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:44:59 +0000 (UTC)
X-FDA: 85191018360.12.0E12A16
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011013.outbound.protection.outlook.com [40.107.208.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id D77B440017
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:44:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VQx6+JOE;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788882297;
	b=ZPyMyFDm0ecaB1Lw+X54BBkq/3L58tdrjGmoDRHljl9KuB6EBe95AEb0A2+pm/AiBzb0WW
	g14TZ68GkxLJPh+0w/T/CFnmf3U7jM5p6avmb/2vTNrV+WDP2sTH1WDgGQPFQ+j7kDdJEU
	nuZZ69QsMEo46WFrFZiP3q+ByBSKMqM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VQx6+JOE;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788882297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUonv+1fXdqRVR64AjAKSh8fzS4K5yeQQGpHI4+sTZ8=;
	b=srYgU41vUECh6KyqtB6OvyXrCa6HZJHYlu6G96C7YDaNffBdfjL+xZnNQAdqCiIj8Vxtpj
	15V0TmLDOxitiVF7ZcV52KcIy+F4X7kGt6Vk0PAeS+IA5W8dRCN9jbTUdUvreWjGrQ6nmY
	POzojWrBfB8UZwbWtBquPxoTRgrvXl0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XNXTeJn3wAg9WXnadc23COLow0t+fVtyrSLdBMioSg5aXICV5bD0aB1n3v39op2ITN6V93hppovIIPHIo5pRlumrqSHEI+ea/kevee/IT8UhCPUEsHmKkJ3mldz8BUGhQFkOKIhnuU+5dzAeMHXChSYWnx1wzVI8YtvxQXedsdGOLpMznnnFdC3PSbxZTDnbT0q2phGAf4VOiNRHMUsx0yfwwccG4NMp+sP6YPQhl7nTlH7z/6gBnKLwHt9JDV2cRwt4PUajH8ySLywTgqKbCK/CyUDqHyr4ueNvyUHJ0r4g5oos9Zhm3Wzk/L32ldFSKpDkNo6kB5sP36NhVPkBJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUonv+1fXdqRVR64AjAKSh8fzS4K5yeQQGpHI4+sTZ8=;
 b=PikpR45oEYt7MOJrMl878COZoD2IIZKHqiCAwU58mVam3iieo2TBvGtCh/j9um5cL1A2iMlsqPQgLVZwEQua7eA9S9omvpF6t1V3OCx4Mgztnm7AaLNbw0BfjhZsaAYaFADhkaZyeLC+6n4/Nm3qCyw3ewxvpFS8Oz0+LncaaO14l3spbkJWmM/tFP9jCHoJ8J8O1Lvi0ZWDc4L54MCSLAA/qE//ge7iFLRVkV+LiH/QL129zXUPD221WRuRtjvV83Q1RlbYUYJIrbBqsSV+6srlsuFiVfETaAS5WS6Pywl0QJNH9gYXo0ENyLzrZ0NpVt7s7JcTaFMcm2qZtma4ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUonv+1fXdqRVR64AjAKSh8fzS4K5yeQQGpHI4+sTZ8=;
 b=VQx6+JOEraj6F3kNb1lGvXWTN1o/WItmH/zgpXqIqgTvd/xwyfGVpRMN0IejkRjKj63anvIeHtak/4zmN8cbKRHU8FWG6ZPn4b95MnE5BZT44qeeX5g0aRmbUs9Az8hhZVOjxpCbmIS1diERpW2YQoiPHHeE/rgLtMuqFwL1aILcIyVB0p8kP45bWm9efkuBk8zAg2gZkv5JVszC6sGzooeOg6mt9Uuo96TjleJWDGc9uowAsXgQdIPRbPTbTNelpaAMktdLfNTvkwwDGZt4ki+hBH4p8/+d3JcF9iMclf11k/r9zoCPHrG6ydqkAxF6AB5rHTLHQU7AP7zyZ0FTfQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DSSPR12MB999211.namprd12.prod.outlook.com (2603:10b6:8:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 15:44:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 15:44:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 11:44:46 -0400
Message-Id: <DLA1UH74Q0WX.1D02BUATXHDG6@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 03/14] xen/grant-table: stop setting PG_private on
 pages for grant mapping
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Juergen Gross"
 <jgross@suse.com>, "Stefano Stabellini" <sstabellini@kernel.org>,
 "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>,
 <xen-devel@lists.xenproject.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
X-Mailer: aerc 0.22.0
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-3-6ae22f9d9272@nvidia.com>
 <fb8ab0ac-87b8-44ea-87d2-006a7a7569f1@kernel.org>
In-Reply-To: <fb8ab0ac-87b8-44ea-87d2-006a7a7569f1@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0188.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DSSPR12MB999211:EE_
X-MS-Office365-Filtering-Correlation-Id: 2942c721-1277-418e-bc0f-08df0dc01d2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|921020|18002099003|22082099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	XaYRZ3hMQP1dy8zHLVQuJFN5za1QToGQt9Np4pUCVCDk0m5zU5/n9F7pr0ubBVv20NDKcCih2Whe8JgqBx+5Ca5Q747AsQ5Lv38E96I82nShv7lgit+PCqqwNXuDrCm4aaZvCrplHUZjpp1SmNciGZvIftAkkXsg5Yh5IY8/MrwlIvsWHVmcm8mQxJnOPceQYiJxM/03zdLcdcv/At02p7ThuMRAHUEe566VIP/OcD++mMgGnHLJ7ixzSXCnt6Jl5xxJw9PoUiDw8vZYAVvRuo7SJOmjRR6hcOqKg7IOMbo2ZvRy1eJxYTaCY43yeaQuhbvbKoUKCQsxRsATmIGRsUsgtGqImuf4v23nNxoj7h/GPjSvL3ejGU0QeuQdXCMGmT6GjVMh8K/Pi10q34gW/yghJU/wBuhaMrEATFRoLtJ+l9qPEnTQwjErQT8KkkvDOja6zS3h25UELh4VCZVwg3D3ndPYJN7gBt0a8lUJ7NGItcGExgsRAcMpSkBMcKVV62FCDJnK//N4c0VMsnBHcvsLygFdSHc0CYpLZVPosIaHl/mgM0ET4wh/DmPS/6UJsX8HhgLnGH38TnO+NL6eusjsHFYnjWj+qqtveTG+gPhI/tnqsUIMa1c+mWhOAcDwn0JCE5clzRqvJjqm30WObf813onLye+4tPFXdlxaQLJ8yiwcTxX1N2aQfHLYfuvS1r1DESH47op/YTAN3zQl3g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(921020)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bG1QZHNEaEpGdWJNK3ZaZXhKbFFSQzdXak1CdUJYZkw1VnQwWlN4aWFGemxJ?=
 =?utf-8?B?MjlpUmJVeWVjRFpaYXpWUVAyQkFGMW8xR3pDRGtxY0ErcFVwazhlZXZSWG9M?=
 =?utf-8?B?bXVNUnBsUURZZy96QnY1YXpVVlJ0YitXaEhwL3NNTEt2KzlWOEZ5S1Z4WDhZ?=
 =?utf-8?B?SzNsNVBYYlF0REpXOVdpTjQ0R3dXOFFLNVp2ODlHT1BBT1JwT2U5TDBhMVBw?=
 =?utf-8?B?alcrUzVaWUlHRVN1MkxaWWNCOEN1VlQ2Vy8zR25EVkkvQ0FROUVZM3hZaVVx?=
 =?utf-8?B?bEcxeUphc05SYXdML0tGTVl0ZFJDMWxJWm95UWNxWk5ZR3dqTXBXZ0hvdWwy?=
 =?utf-8?B?bk9VNGpDbzV4SzZMakR3UFlDK0dURVNVTlUxMmtOUFE1RHJ1ejc3SXBvNXZ4?=
 =?utf-8?B?WWxvWUR4S0RuMjZtTlNoVnBHQVJ2RWJ1aC9udjZNRmhOcXF2K0lpTGUxRFo2?=
 =?utf-8?B?NTJmVzhoN2ZoS2IzOCsySlpCQVlVbFhsTGVXWDV1dUZTMEtoYWllSXI5cXdy?=
 =?utf-8?B?cmlOcHVPcEFkNXJpQklVeXNoK2dPK0E4SWEwMTllTzRoa0Zwb1JTcDVEa1kv?=
 =?utf-8?B?ZmNGTTF3TzgwVGRVd3hQMWZsMVRhbmp1S1lwVTJqWllucU8vL1ErOVpXV1dl?=
 =?utf-8?B?OE5adjcwS0xJbVp3a002aGJJMnNjNmtxbXN1NUhMVmlERDRaaFlubFY1Y0ZC?=
 =?utf-8?B?Y0xOU044MmxEdXdoVzQ2WHBYRXhMbWVENU4wajEvNkJrWkpLY0t3bkNsbnkr?=
 =?utf-8?B?eUMxZkY1Y0pRODJOUHUxK0RXbm00M05TaGIyVGZteDBBR0tKejliai9VeW5x?=
 =?utf-8?B?b3ZBczlUMU9TNmxBUmFveElEY3JITXhTRDJTYkdVMzdSZWNPdGV5cVVqZ2pQ?=
 =?utf-8?B?Vis5UHRvN3U4U2Z3OXNiRWZVdVIxL216QllOb0d6YjFmcXpHcW0zMWZ1Mytv?=
 =?utf-8?B?RW0raURBYWFXamNKK3BDVzlCalFIaW5tQk45cHZzK1VXSFRQTkUvajBPUGZj?=
 =?utf-8?B?VkxrWHNmMVVJcjZ3cUMwcFZtWmdtaUJud1hxdTlhMWtIM2lhZVpxU0R4QnZu?=
 =?utf-8?B?Mi9NQlR2elpPTnZIa1VuTWp6N1FyYUU5SW5tUERYOFRkMStmb3NIcGRVMHhC?=
 =?utf-8?B?NVJ2NFV1aEZNK2VzeGhHdUJjeDZrRUIyQ0hCV2l6VEEvbTBrWkxxdkh4MUpO?=
 =?utf-8?B?NWw2QWp5RnZvN0x4V1lKTHUzenpzbkpTK0MzbHQwYVU3dFBZcTRsZzNCNk02?=
 =?utf-8?B?UHBqS0k4cGFvbTVWc2k0TjhUOXM1RGVkeDhQdklWK2VsR0dnRG1WZEFTM1p0?=
 =?utf-8?B?WThIVnhwOVNDcFVPeER2dWtyWlE2QnNaRi9INWVMSVlTUkNwYU9DTDR4cTIx?=
 =?utf-8?B?Z1o4Y042YUFEMGVVeWg2dzJHZWcvazVhM1JweTlsRWVtT2dCT0ZFYTY5aXJ4?=
 =?utf-8?B?alNqMXJUbVZYQmx4VVBhZGl3Rjg5aEZaTnRTdG4vMFRiamtxMnhUNmsrVlBv?=
 =?utf-8?B?M2F6NVdjdGFqWTRBaGZnTy9EYXhEWnY5allHWUlqR3pyTjlQMHc3SUJvc21l?=
 =?utf-8?B?RzZjdzIyVUFEZ05MZmcvdVBtbVErS0ZINGtFZGsybEgxWkVGeHFJK0NhaGIy?=
 =?utf-8?B?cWsySmNPaHdCOUFTbC9jU1FhcVRlaG5Pc3l2Nk5NZngwY2xvY0VqbXoyMFdS?=
 =?utf-8?B?REFSbU9YS2pia256amJJY3JXTzg1U1FhQmJWOXFvT2ZvUU1XZjlNNjUvVXR2?=
 =?utf-8?B?a2lGVTJQODJudUJTZFRPMHdNaC9EWWxJQ0NuUk9UZXF5aXhIc2NzVG5wekh5?=
 =?utf-8?B?b2plSjRMQlAwVWllS1RId1AxR3M4K1RBWWRrWm1td3ZrQzZUd0pCSlF5dElj?=
 =?utf-8?B?ekVtTENtdUtiYmNCcWdXSG9iaExoS0VZUGttODIyc3FWR2s5Ylp4cUZQLzR0?=
 =?utf-8?B?T3Y4em02aXNGcUhWMTcwYXhiYkhsNWVhZTJWSU1VL0hGS3ZSUXcvZjFjMnVq?=
 =?utf-8?B?ZmU2SFd2NXdMRS9VdkxNRzFxOEN1TXdFWjFOcXdRamQxZGM4Vk1QQkprb21u?=
 =?utf-8?B?Vi8wSllnRmw4Qk9DN3RnSGRDQU9QOXpDd2E3YVV5bFp0Zk5rdmRrTHowdmR6?=
 =?utf-8?B?cHdEUDlIZ2IrVVM0R09SN29kTWx6N0tMa1VYcHJDVldkV3RTVmlkMmtrNUFa?=
 =?utf-8?B?cTU0SVE2bnlvMnBMNjlVMUNUZm5sRzZIKzN6QklsR25Md2RocjcwZ1RpOW83?=
 =?utf-8?B?K3V0YWxPZ0dkdmxwNDUwZEJLT2lnZHFtd2liTnYxVndtRk5pUnp3Y0JJVHlz?=
 =?utf-8?Q?c0ed76aK3anHzx1UPS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2942c721-1277-418e-bc0f-08df0dc01d2a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:44:48.5324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfRJXV2NR0FgilVsT6+QHdVji/HcNkfjCIduQjGWJd6mj1bOCPnzJy91HGcXIOh9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSSPR12MB999211
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D77B440017
X-Stat-Signature: puysf1igsjd8i9w49e13fnnh6qhs4rkj
X-HE-Tag: 1788882296-735326
X-HE-Meta: U2FsdGVkX18JkWvqoCGZD9HqCNgA/caMWor9kgyYZcXlhJYoAIp0wKVTIURfwpc8Lq4htOkE8VZ8Lm70NEbMNr5kGjjKY8yQAnd44OI58vlzFnptqNRz6gH6eh/WzLY/ZHXBNEL/lOz+amVPOaobCk0lwVG2LbICC4MoCljHdnjLF/znWjTAQw9EXwp0HFqEx6jSFzAC0DEoN9wx/Y4TVGnVOcLgTII64HCklEheoNhXFvhxoxeTnLygxHbhesrz5XQPOuIeQtWRzUxdC1rz6sCjNXuXOECiiVkPEEDXNh3Qu5DarDbXnVb5Anuhb6jfJvjWn+LrUsXjAIa2hCmYyGzePTW9gvOPe68U1COcgL3johPQzdj4U6CHbeqwmty3j66e11mre6m/UmOMdVSoi44THT/UJKgfOTteBugSQzCk9OjLeRUI2THyAAM9BNrtyK3Y7NgAubQGyZr3YpG+q0v1crArsQ1yijWhY+NY5+pR1F0w26tCeCMojXi/a4MxQfE+S9J2oyQLAtu9Mz5VDQG0ER6Fln1EawtQcCpKrX2GOWx/3Iq3Vk8G94OgmMvKkzadPp8HC4uzSc1DGA2mF8nqch0SPMSj+fN2GyUa0zrVUe1H0Hk8TuXUenhawpvwmFTThtRyJG1eW7dmkyOJs/iTvRU+mNfJ/ocfV25E74CqHGfSl6q5wVksYkzCp4UiYSJdnc600O5B94Q3txJ/ObZYcop9hmoNUnE99g/pALF5VLv2tDaVpSlBrj2AWk/BSKVPAkrkRIo/RHl95V3/R/Y90M+v+OZjjZwib2nXKIoCICdkomYAfFutlSoVUBCyGxUTa53Kz3QZmw4QIs2AzzwVF6k/l9B2h91mTiwmESa3Rr688qtmdA+f9U3+DUjUWZQacR2SiuGk3WUfEV5KQvyXFf46TJT0JYIJodr3mS3bckTBGaa7Yvx8suhrN8zhYKCedT4qaGdMCkwhxJE
 qfPLXwBk
 N4nn6uYYACgx07E82IZALVPZxMs83zhZ3fq8Dky/ZhU+uG00lQlz9iQtZv1I+JUWXV9KTfTXKTl4Bo8/+i+K1Kuon7W9TP8Hd5XUEVoY8lQj6W6pejICzPjFOWp5NKtPYcwGIvzURJtfxYAS3u2uK/B9uE8XQBlGAjnqNwylAgugNvLf0vbVRby9UPUtHuAuDWaCeegGdlq0vd1VyVaRd//1NMu26MlBUSycH9MHoaz082ic5ZlnYZnK101+7ZrzNtKpzC0wogmbmd5fDk8nnUs3CqSBMYSltwjv80EXY9/7VVcXtBoajYSyYOYQfgOG65PPSVRjBDi4oxyPkNiS1e0b6qX48WFLEjR+BlfebOfBAZzRwkOlpDo2Wmul+/xHvNaHrBJEdYLvTlAaEdvEY2rXzG891Wdi1VWokihtsHfTEgAWA0ildNevhf0ydk5QPMDsfy3RI9ayyeflCJmMVMpux+sV+a95Guw0by8aAHzzJZJGLi5KmZKyt17GEI4QG3EnecQtKVfgVeyqYA1PpXRlEOgKVaJ0GKcpTkSbQCgcjOb2gpGz28c95fqu4V7pDw+5cnOwY/5SUv2Iwzgnq+XPAsU+RcgsHK5xLz/ADKv1C3T8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 8, 2026 at 11:16 AM EDT, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
>> gnttab_alloc_pages() stores xen_page_foreign in page->private. On 32-bit=
, a
>> pointer to an allocated xen_page_foreign is stored; on 64-bit,
>> xen_page_foreign is stored inline. Checking page->private !=3D NULL is e=
nough
>> to tell whether a xen_page_foreign needs to be freed on 32-bit and
>> page->private is zeroed unconditionally on 64-bit.
>>=20
>> It prepares for a future commit that remove PG_private.
>>=20
>> No functional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Juergen Gross <jgross@suse.com>
>> To: Stefano Stabellini <sstabellini@kernel.org>
>> Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
>> Cc: xen-devel@lists.xenproject.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/xen/balloon.c     |  5 +++++
>>  drivers/xen/grant-table.c | 11 +++++------
>>  2 files changed, 10 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
>> index e7f74ea7cd5eb..fdb18348cfdfe 100644
>> --- a/drivers/xen/balloon.c
>> +++ b/drivers/xen/balloon.c
>> @@ -182,6 +182,11 @@ static struct page *balloon_retrieve(bool require_l=
owmem)
>> =20
>>  	__ClearPageOffline(page);
>>  	dec_node_page_state(page, NR_BALLOON_PAGES);
>> +	/*
>> +	 * clear page->private before giving it out, since it might be used to
>> +	 * store xen_page_foreign info.
>> +	 */
>> +	set_page_private(page, 0);
>
> Who would have set it to !=3D 0 in the first place?

No one else, except
>
> e.g., gnttab_free_pages() resets it to 0 now before calling
> xen_free_unpopulated_pages().

After reading more, I agree with you that the above change is unnecesary
and will remove it in the next version. Thanks.

--=20
Best Regards,
Yan, Zi


