Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E136C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722966B0098; Mon, 31 Aug 2026 15:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2FF6B0099; Mon, 31 Aug 2026 15:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FEC06B009D; Mon, 31 Aug 2026 15:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 177A96B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88EA91A021B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:10 +0000 (UTC)
X-FDA: 85162545300.29.E37848B
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	by imf23.hostedemail.com (Postfix) with ESMTP id AE81E14000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EFoojrD2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204367;
	b=T3s+5GaZceCA/a0QSQ+Qmy5AQxdUyF84SCa2TttHMDu70+5I3lxres0pyKQ7bXVJ8yMYFl
	AKWNjdwpiQD086Et8/FExdpfrxoiFjTviBmYr1dtIkPfduc3SacHMNcaGu1tnWvgppdcyD
	bBvw4pu+ax84xy7S1IHuEZimzoJ0QkA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EFoojrD2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2oTi3b+3hCoNxGuOUkwhWgvncgMihYm5DrEEikckAM=;
	b=4O5zW5V0UnHxF1m2tHmRynB0pH6wYAHo+1rA4UqSuHMMMepaYH487nTqibbsU56d1NmSjg
	Ua/wiASN76Bdbj1eswS8kizIRIJINcdPvYAOpfhtEp4HkANVRqgTS4OcaawNmEzInOdWqM
	ds5jYEaXvzBwKGZtJyRZWiZ+Z0SculI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWbpei4aNYaxCET4nLOy7F/009GUz3XXpV85kl6eVsJkFFd1iF9KrdsqwJe5X4a3/5oPNMhn1qZygmj/pgIN7QEaIhi1dXFwpU0B38cX9QZ30R1jgQArGQAhU/TkH9+wH9aCkBExlDAw2iw9bCa7Wo0iXOL5jyz5Klv4IdZNizv29We0+uQ4lieRZT7m3WMqCMPWW/FvNuq7PLn8c10pTIwtHSgS1Rxt69ByOrBijB8iVdmVCuYaJ8IksVqJD5aLkiSI/2omDxEvoLkYiBVKjaZmRS+ZFGYuxeyL/pzWXBJ0TzffKRK75kqeECgs5yUWK3rvxBRLkLECVJTACLrqAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2oTi3b+3hCoNxGuOUkwhWgvncgMihYm5DrEEikckAM=;
 b=kOO0mHKP5UpXzVBaYTjRijutWLfm23tVdakOGtt3sM7p0c8SXlKwrOJCDO8Y/OOetCeZ4t+02+x+yGmbTVb3/Pjby6i3aLReYOiu7DowdfpEOvCxKiPEFY4MLp3iAa+iOSj+V9LdJVLWTLkchs1yjxjuljdseys/PN2a41nUrIMZA1YyxA/tuAT5IvSNlbi+oBJjONHEX6qGMHLoFDoefIb3DHvzGJBDPkf7kcjheT+aipH+9u8V2ryQxCLdIbrW2gbXxzAoQ8wwAAy4sLTxp8g+gsCTtpCrM6MvXGxYpJObf11FWfmIyr6kCPJRv7UeNLlUrF4/dcMHeJsij27w4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2oTi3b+3hCoNxGuOUkwhWgvncgMihYm5DrEEikckAM=;
 b=EFoojrD28YJ41sCgZRSriYJ/O2p2CXEl7rUNuPgTOkyykKXTZkhrdkBVBxECTEiWmolJvaQu1MywYUCStqRg3+B8HMb0SItOBluyZWHvCreao7k2NmioHXSFISRFs3a5WnU/t9ABmMyaD2CJmonTwfDy79l1YKM50cJa1ZaXmiboC2gW7Cz/zaToORObtbe2YBbv4VWXRxJ1MkZdD+Ysu/YYKnsmVuOZK7PYaCygnqwYte7TDLVcVU3D0At3A57ZYtZporU+2sgAwpXJ/FD6wvmvdsjiMVfvh37zRFl9K+4ScJnXtlFa3Jy5VOYkwYouTpL5eyokknz06xiK0bHkTw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Mon, 31 Aug
 2026 19:25:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:44 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:27 -0400
Subject: [PATCH v2 04/14] fscrypt: stop setting PG_private on bounce page
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-4-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 linux-fscrypt@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: BN1PR14CA0003.namprd14.prod.outlook.com
 (2603:10b6:408:e3::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b57b664-f74c-45ef-61ce-08df0795a73b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|10067099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	LRTbmBzJk5aemF0UaEM7iZypwutUnJzZYOKE15r9W9isYImX59u1EbltmC0dvvj2OrAToKF0Nl6NoTQR5GKS62C8ogs4v+Shyn9VlIy3GAKjIzJ0fOEpYMhFlPqRJxziR+hv8C+KbDtHrcgY9O6poZHl68+GxQHbJe+cEC882DLBYX6icU8kuyy4ooQJPjMSmUU6JLDOvA3HWNOEQXKxCWj3J0xMzRxsggsIBVhHn1FbgvvwVO3EkwunYRFPmVce2Pen1rPgRpOIhzj/5eMIb9VCBkJNA2/xNj58sd2f2rS/JfF4NjhMkbJvdV/89kFm+iKiqKrNGSvtLJM4PGmtSj3hCXi99mKDyaTOVl08H/kMIOcHua7OLQ6gu3Rdvf06IByQX/FIZd+zmdqdThNdAOy7m8yl8y5yghxA7Yy3mQiOHfO6FfgJzfXxKj9YPuE1V92f2SDpk4gJvQwPkiHrogCDBJhhj/qN2DXrM07cf5NNXpYe8Q2wheF8GHi6KQxq+bs4rpQWqV6kXQhGDTB6jSyb0/+5kWBPXkbAeHg9hw62NOP0LodFUtRCHfMLduTx1EVvYbiAXoqPDdMUrb7/wASPNBhNWFYw68oaJ9Cik0BwA+G4p1jY9G8EnUnN/mxedTW1h+0IZegyuGCxe0ISpk8vbSX5wE0I4jyCrrVrOQtRqz3VZtrIc22zeUXFBamx4pcGKIQ39Q3Ppuw/Bvlljg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0xCaGg5K0luZXl2SXdQTnR1U0xpMUk5ZUtWVnB1dTBHSkhRTjkrdS8vakdi?=
 =?utf-8?B?TXhyT1EyaGg4Zm9jZnNlNDBucStMQlMzV2NDdzlqaTcwc1hFSEJHU0ZhWVNl?=
 =?utf-8?B?TUhSNVhxTFJiSHF5dlFRNUJQMkUxc0IyTDlNeDM1TTVLdnc1ZmhBMzk1c2RK?=
 =?utf-8?B?TlV0TWpVRXpFWHV4c0FvYnNoUkhsZy9DVkx1V1p5UTd0cDhDeExwSGJ6TTV2?=
 =?utf-8?B?TXRpTHVzVGVkY2NUSnh6Q1Q4SWp2RHczT1dXY2IvRzBDV05pSnUwampkRGNv?=
 =?utf-8?B?OG4rR2Q3SzZGNVBQdFF1bHlsSDhlNlR5azJFeWE0d0tkWGJnbHArclBUM0dG?=
 =?utf-8?B?RzFEM2gvUyt5SWl5bENPbnpENzVFWlZ0ekl4UW1HNU56cGVMREp5SFlya0gz?=
 =?utf-8?B?OC8za0ROeDRLZ2dsTm9aalBxOG8wUEVScDZldjlORXhKR090YTVqY3RqQ2JV?=
 =?utf-8?B?NEtNajl6eWRhcisxZmJIbE0rV0doU3hyUjlBSkxGSUYyUFpaVjNyYnpLZk1l?=
 =?utf-8?B?UzlXVWk0bkpuUllXajE0RWRpdkd5aXhaN0pGQ2FwMVAyd2xKd2ZvZzRPYXFi?=
 =?utf-8?B?a01OeUNvbFB1WGkwU0prWU5XTGJkREk3aVpNMkVIQ3E5V1oraWVETnVMeUhV?=
 =?utf-8?B?ZjMxb09FbURPZVJYNFZBQ2JZamIrWXpFaHdIc0dUM2diSVQrZVVPb2hLWVNE?=
 =?utf-8?B?V1orNjVtV3VrQnlTdXErQWpDQ1BSU013b0xGaGlTZEFRSFdtem1NRGFjdGVp?=
 =?utf-8?B?amNrVGNKc0txNVJXYmpuV1N6TWNiUGZWaXlZVC9adzR4RzZZUzBHRXNCem9D?=
 =?utf-8?B?Y2JLc1dyZG8rWTdqSUZpWXNkYm1lU09JOHlIa1hrT0lkYTdZU2hPUU1PZkpX?=
 =?utf-8?B?V3Q4YUM0UVYreHNUV01xYit6bTBiblRVeGpFV1N1VjZsT1pSakt0OFgybHpo?=
 =?utf-8?B?YitZaWZ3L1RweHk4S2JVeGtLN3A4RmlkaXBIdkZjd0ZPbSswWk80bStkTEMx?=
 =?utf-8?B?M3JpNW9ISXRFMW5WTU5YZzNsc29RVUxxdWM3azBzc1g2My8vM3pCQ2ZkTzAx?=
 =?utf-8?B?VkEzQUpuQ0FCN1llTXBEb2JWczBaQjZ4ZTRxNHh2SkJqdkxsY29HYnZZT01i?=
 =?utf-8?B?bDV4dXpjSUw5dWVuU0hjRnAxaHozSy9UUkN3THJCM2VrSEdWc05PcWlCTEp6?=
 =?utf-8?B?M0JiNVZzMGpnVWtCUGtkYm44bm9VNmwrenZHT2lGb1pBY1JDOTh6U2lvbTlh?=
 =?utf-8?B?cDBEMnJPVWpCdjdiZFJrQi95NERiemE3MlpPc1VQNkFYM1BtVk0ydU5qUWdX?=
 =?utf-8?B?aSt4bEw2QnF4V29KQWZWU1V1clc1dVRwU2svM1V4YUdLcHJkeXEwUGRXTlNv?=
 =?utf-8?B?bU1JOHZxZlo2cnVmL3dCZnhsRjkwaENvTCtLYmdRd2R4TzM5a2pDNk1sL3Fy?=
 =?utf-8?B?emNLNWxoMU05RVZxRHMxZGYzcFNLa2pHRXVnYVB5M1g5Qk9YMWxGaUlRSzNh?=
 =?utf-8?B?ektycVBWYUhjSWJEL3Izdml6RXRBZ1NNNlBtSzVEeFFIRlkxdE0vbkIvYkg1?=
 =?utf-8?B?QmFuWm1pSlBIeUI4Q3A0VzNtenNUVmdVTncydzhRQ05iZmRwR3BLcXF0blp3?=
 =?utf-8?B?NmsxYVovNmhUUDJ6T3BJZ1dINWsybGNVWXNTUnBWZDhDYlIwQy9oWUllaytw?=
 =?utf-8?B?MWRjTmNnVFVaYnQ0VnFiYU5YNkUyUFU2YU92TG9WcVdXdWcyNW1kMHliTnlp?=
 =?utf-8?B?eEROQkQ1UmJCOXQ1WmVtMFA4eVNnaHQyRE52YStCVndSdUNPL0NkWGdZckZB?=
 =?utf-8?B?NE9pUXJHbWFtQk94M2dlUlc1a2c1T05YSENOejN0RnBiRURwTFV6bm5NVDdE?=
 =?utf-8?B?VDZWeGhoeWxNazk1Ty9QdHNJei80UlVKUGwrRWtFeUExaDRpOHc1WFNNNFhG?=
 =?utf-8?B?TG44d3RMN2w0cEFLUk9pV1l3NE1mSTVxNTkvanZVZHNheXEwVWgzbC94b2pI?=
 =?utf-8?B?eENXNHBaaEhleHNGUnJlWkpBRHVnUm9uNk9lV1FXUGZMWS9Za1d3SktMbVV1?=
 =?utf-8?B?TXhBNDk4Z09yMkpXZ0dmRFgwcDJJYWFWVytZMkJZUjBlL2N6ak1mcXVxUFN1?=
 =?utf-8?B?VTdJcUR6THJzL1BnY0VHMEhXdlZ4aEVvbmlBeDFXWEwwQTE5c0ZQS1hzaHhL?=
 =?utf-8?B?UW5lM2lHRUFzK2lCQmRvNDVyY3EyTkZnTXdzREFKUzZLV1pBR1FJc0ZlTzRN?=
 =?utf-8?B?RFZjSUt1UjZpaVphZjRveDF3WWhBalFiWWEzY3R0Y2wxWVRRVktydEY4YXVl?=
 =?utf-8?Q?R0mTOoRQAzsowZBL70?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b57b664-f74c-45ef-61ce-08df0795a73b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:44.8572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gHvEtSFdfB8+5UKbmuAo4/HgfAoz7Yu3wumYQt6gz/1qYZgtFXRCG3anwI28HfPV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AE81E14000A
X-Stat-Signature: sy7p1n8hq43fzb1ho1yenrihncjcdxup
X-Rspam-User: 
X-HE-Tag: 1788204367-812272
X-HE-Meta: U2FsdGVkX1+THYhtT0hSdGNvRAPT9LPtOrcvLdqTq/vM6u/n36FfGL/1sLzeg91ekmXWfGnhtNsJn4ftljZSyJcaMrCdoWDvRHZloygLw4+jZjxnnwW/Tf85MKmLE+NZxOpnhj2f6dLT+QEMtgX3UHpiGpEgzq5NCkC2M2Mz5CtBM0mKZ3ES1dzcAg+Cyt15Jk4GeK6jL9Xb2MdcPCYAvXrzcz5GRIVD1QNf7BqTdcr90S8WoaWonzZM59lzgierhI1UxKLHOaEBQTk5RJt9HYtDnbjloccMMfoMqSnqWXcDOPJlKFyA/ueFTybrYBzaZKCj6Cn4UIfa94u0YfXIdLpDYp+Ik00QrtUUh+2paFpBtnRrataX9sedNubY3+awNbOthBDZLVBkNiIlczOePLgsY8qs6eeVWLwySoJNIJ6+6muF1cEmWELEhJoQRSbDuGs+qJYCe2UcSSDuv5QlUaPApKF1YbYz1lCPn+/8mDrV43dTJgb/xrUHZqwOeGH8nk39xNssNrAOY3nMd8ECpxgAOQAkw1E/R27IZiD3P5XTsNoXQ8PP69V6eeylfexs6C+qtizJ4tzh1sGLQAdmrfsA44ajnK7k03V8GphpR+Gim3qkxR9pFBTK5MhRxjixC1ERt21qApIP+w7ijrFr1G+aES6BpmAkR73LmaVafw4lrpY3UtfEKfbff5flENqpC6pxorVUoc52nPvRnTOBnX33IQQyAAPAPdzcmAHlhctYePWwYH9AfPsEIzr7kABqmhBy/Yxsd203AobgAfUZ8CBcfb+KBc17ojh0Pwi97D6Rdkx7mJWqkbtfWccyhooenWeUcfFLNDtaAxp/97GrTA8jv3Qt2QXDjHLCdcOE1557HwFBEnJd+OIHxdtpNPvavc9p9oRaIvJFvlRIHQRHeHYqcChaAZdSmtAUGtm2lBj9ABEcQcw5TfBYaeRc6JJ14jEIegDzur4lC/Wd7/b
 mOGPwchL
 K+8LknK1fCVxFkQFiA5RYfWE8uICg4yK1FtB6nGMgX1/6m38GnvcvpUUmGVwOnd6E2kvalAt9HEqC99Q8JzE3Hi+xBzki2icRtOufP+Y6WbfM2nFrKgDEMuk8OWHuJAN3ci1QA8NjlX1Jp54Sx6on+bU0lPRNtPiEZaJcoIo+BbqMMgABvcN1WJ/hOyiPgZpBOdIvUmZAsLRlG9UfifyVdBRMTE2CQDvkv/8AtDUtp8uFHQRdKVod8cZeU9J5ZKzTdk2CX8te7QIV+kZzauQE5fIhK358jkOGwxIN6Zp4MdyrfhI78yv3039Y1vPwYSMY7ORileI5MVQWkxrl9RwrTHhlLgqpfb1aePAn+3lLgO64IugUIw0o2RJcsolNmpUUJiZisomiUqcNcu6ASQDGcQSISgZREDvjz7+9/f/B0adLgvK97LXl5HEsExkTWgCU4+M73EUa6bsJK+9COWVpIyUddg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pointer to a plain text folio is stored in bound_page->private and
cannot be NULL until the bounce_page is freed, making PG_private redundant.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
To: Eric Biggers <ebiggers@kernel.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-fscrypt@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/crypto/crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 5286a124b0d98..aced5c50a4601 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -65,7 +65,6 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 	if (!bounce_page)
 		return;
 	set_page_private(bounce_page, (unsigned long)NULL);
-	ClearPagePrivate(bounce_page);
 	mempool_free(bounce_page, fscrypt_bounce_page_pool);
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
@@ -210,7 +209,6 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 			return ERR_PTR(err);
 		}
 	}
-	SetPagePrivate(ciphertext_page);
 	set_page_private(ciphertext_page, (unsigned long)folio);
 	return ciphertext_page;
 }

-- 
2.53.0


