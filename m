Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 908FEC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 02:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030606B0099; Fri, 31 Jul 2026 22:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF3E6B009B; Fri, 31 Jul 2026 22:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27F96B009D; Fri, 31 Jul 2026 22:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A54C46B0099
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:17:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3375A0101
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:15 +0000 (UTC)
X-FDA: 85051088430.18.FA61D3F
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013055.outbound.protection.outlook.com [40.93.196.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id EEB05A0006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cqL2slsZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785550633;
	b=Pvamcu5pcWabFcPZU5AWTW6U/cPTIvbpG0/eEX8GMZ5t75w49adrbCSw8E5T4BR6I57Y8y
	UjiW4GYIhcAUyMQpvwHlTNwTIaze481qWtNfQ1TIC3/iiYoZ6AfRziNpgeissVxZEhUdoA
	OEFwblSvVFd5/JoR9nzg9brn44HTDj8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cqL2slsZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785550633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cu2PNoyPHXaPHHDe/kk5zDlt2W8gJm9Sv8bR1p8K1bM=;
	b=FX9ULWaneC++o33Dw4vDC6wF3Vfed8cy91/FqglYJ4tuP3kTixWgoPyd2rwvgWivoQNukF
	OS8JYEKhhxUG9KGMXuPsPl7M3opAax+1pPgiWTF6s5fl7qCan8rFxaPSp+NBi+0YdFmOKw
	4hirLRHk8/gWHc+kGAGgvdes4iJ/YL8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hQltLXNeMPD1NXXjLvK+awgv9a3snayNMjtOfZwOrRkLksPmZlEFFtpDCMI9oKHzCzc/lZKeG8k2Ya/ZmlI424oMTuHGIKIxunVVC8oUS2PIN27nr+uCFBHeJvOykfMJg5aiAYNpokKqRj2X3FLPupCwIflXS2I86WstG27IUTDJ3Sos9LO93gTq+s6oSD04n2qn9Uk4vgFAZflS00+e8fpCuTY893+xicjVcFzl2/8YeIgn3wJGkvsSiwNJ5AWnILH6B4+nN5ijQ5jR9bMGw/2snkiSpNMxXJY5wH85DOyMkX1CxWL9y2G7FX2pB+MLpmKKTjbozblz+4u7z38BGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cu2PNoyPHXaPHHDe/kk5zDlt2W8gJm9Sv8bR1p8K1bM=;
 b=a2KPswTbQxdVFxfCs2eT/0ZM8mprJs6zcE+7hEuPHZGHgrNqRMQRBGja8EEzl14LNORhCsnpS++lXcBgEnimmCafCIdcbOSugjroGkbob4jtoUPXgyOmvqvAmFeQlwcmYV5p4IkgHjoeSjlMF2p1u4AKpU9hrdfnsxDJxRBtbpIlCB+j1et6Ww+zt3ikj8YAdWhrdfOoCHuSJPFnKwRMok9nBnROB0bkUgbcmS3sMJXSwQuip+SMfhml6S3S1KYtp8DQuydIdqoJLOvOsb0pznpaKkiE6nEwOEl7vXae+BUkMSL+GZ7dyDeRIO5IdvN7i6j6oUGrvxJpk8KbT2yJ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cu2PNoyPHXaPHHDe/kk5zDlt2W8gJm9Sv8bR1p8K1bM=;
 b=cqL2slsZebnGMQ95nmBSWGj1jv94ONjMj7ucuvWuVaw+a6mtVNg3siAs/Psssbkh3EOvL9pyFoc1tmoWwL0IhcDTJYMW8MpWUIX+slGpwqZXxXK7spaJmlPqBzMLJQLzuBUUg4fhdNDdS0jEPHuO03x3xTcGWmZ1WD4TYQI1FsMZi3GF9xCLLxFNL/32w8eb98p+UHPgGTmxs6w0NkLqTfyfPz4Qvod95zWtUptmqwpDeg/aopLzLzNYgwv7L/6hICsudrmEd7f5kWQH3VBTNmLvJuk4GzNiX70jkG5hUi7m7wt8wXrofsMj3db2jnvXzcp7oO2tom3e9WskbrJkTw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 02:17:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.015; Sat, 1 Aug 2026
 02:17:00 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Jul 2026 22:13:30 -0400
Subject: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Jan Kara <jack@suse.cz>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.14.3
X-ClientProxiedBy: IA4P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b718f75-4527-4ad5-4b46-08deef72f81f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|56012099006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	cY6vXdRV/vF0F+k/47PdhIkvJwP7SpFo2Xdk9DC83j1gYreI3VXtSsJ4HiOI1BArl82P4kh1ihEpIJ60MFBxh/wnq+6Rd9zleuTIOr7kHg1FY2NdRiU0hpT3ViJFZTvIwZa4i3eEla70a6YhPk52yuR1oiZB+SpgL274/iyNMEaJtuU7ccsRTWBj7Wu6WnuI4l/hr8PHb+in23N5i9r+ibmdxfYw8elIm6myzuy47VpTxg4+4cVD2zLy/bF3qNxFSEfGs3kOiDkkTVkU7+HMm669OtYNQYUIYethxneB7A4YFTrQY6BkORFn7eZaMIP7XO7ZNw5Kj6jzslRVmHzCIy362icfIy6YV89YAMSwsb64AHVDAjlyK6s5u8N91iG9sgK3pwj8cdWyh3bmF9hmxJovYM4y4ypXh7hvqLryQsu0d7xUvyA/bwj4hbecs0rn/fp/zNPXLRPAIxQGtCPtq5yEwyRXBIHGqYB/2gth/7TwBqVbvFUwkSAFbqRL4mtLQTgp4eLedAN3A9ZwbzUnH/deyQ/L57gO2QbGtx1j1VdW/ASzb9vZb0XNM9A1B0U/XrTZLtSaPym9K1iXbBe43EQjL52+zxFzxAhq1WORxQIFx7/RdMv35JqzH+rThg8emKWKexHmbFn0OpmAMoUYpy2y6K7u+0D8jset7179X1y/KORjp8/3/BbVVO6BQUAMzOsBdaf0jMRdF6CGwWoFBA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDEwOE5ITDhMdmFhQlFUaExGK0tGZEdlbUZFR2FtWmg2U1pMTkx1eUUxWGZ1?=
 =?utf-8?B?U1JnUTNpTDZYS005QnhJM1EvMFd1OFVWakowSEViN2wvclhpQVJuMUd5TC96?=
 =?utf-8?B?WWpxLzdScDdrUGN0a0hZZTlZL3NDcFBnZ29GazNsVTdkaHV1UnV4M3krbEx1?=
 =?utf-8?B?VGRFdll1VGoyajh6RnU5ZS80WlBLQUVxblovQ2RKNXRIWndndENpcE9wK1Fm?=
 =?utf-8?B?bzBLWWFVZFUwQWFnTGdqakd5dk5HdTNwQmxaYlZUMzB3UDlIdjBuNjk5YXQy?=
 =?utf-8?B?c0Q5TGxOSCsrQ0s3b083QXdQRjJodmFtdVB1RXREVzNOYjgzenFyb0MrUWwr?=
 =?utf-8?B?MTQ1d3NCNGtKUEZ5VXl5bklhYjdvR1Iwb2Z4bFdBTERHOFI3NVBLdkJER2hh?=
 =?utf-8?B?K01sRVNRRWVNK29sV0djWkhCdDZJVmw5Mmc5bnJPQlUxcUpiWFBOa3JleFNP?=
 =?utf-8?B?bDYvZXZveE9nZXlicEVhTWpYcnFseUw4ZnJCNFEzbmU5b1I0VlVNLy9pS3lG?=
 =?utf-8?B?TjRSMHJRQ3A2b1ljRUFYaE9yTDFDTzB2Ny9TZ3FHM2NxeDB3ZEVoOXJOaCt0?=
 =?utf-8?B?c2NaNFh2Y3NHT2ZFeEtPVmxSbzdzeXEvSUR2akppUmkzelJxYkxtRk1IYkky?=
 =?utf-8?B?VWFiWFV0ZUtqVFhGdmwxMmVFTEgvZWRTU0R1QXZJaHQrc0F2OW14R3Z6S3lP?=
 =?utf-8?B?Z2wzZ3FIc1M4U1FPSzlpS28vZWVCY3FQWk15N0xURXgvZEF0N3F5VmZqbXZ3?=
 =?utf-8?B?TmV2UjlIZXQ0R1VxOWVhM1hPa3VOQWQzYURUem9Edktpa2x0bWpSelJDYnlB?=
 =?utf-8?B?TzlXOWZPVmpzYzJwSjNtc2ZtQVl1eGlWMVZTSDVqSkpGVTZuUmYvbFY0dXRw?=
 =?utf-8?B?eGNxOGJOa2pXNFVTaW1IUWxCeDRTZmVnZk54WW1SaTFqQnNlcEJWcnlZRlBL?=
 =?utf-8?B?eHM2ZklPcG9oMUIvbnV2VlUrcGxkSHJwNVIrZGpNb05wYXNqWnRBcGNOMzRz?=
 =?utf-8?B?RGpxampUWEllSzZYR09qbTNaRERXZGZvSXc5Q3h1bEkzdVl4QTN3YWxIU3Nh?=
 =?utf-8?B?ZlVJVjI5ck9wUlpybUtkR0NaTFZSaC8zT1Z5OHlsQ0I4QW16a1NPNXlvSkxF?=
 =?utf-8?B?eXJxRlltejVRUitrRnEwYkZPdmZQVVhSMGJ3VWtMVVU0V0pvdnpvdzlJSTF4?=
 =?utf-8?B?S2hJQmRqWG5tWTQ3MXlZeE1McG92VDBheE9MV0llaVdLcno5SUVyRjU2S2gx?=
 =?utf-8?B?L3pjNDQ0QkxCK0Jub3ZMOW45T2RpdytsWEdrOVR4ZmJmdk5aZzF6d2pWWW5Y?=
 =?utf-8?B?SkR4czcwVWQ4d2J0UmpzSC9ReXZndFJvWElkUkFJMFcvb1JaR0xROEFCdi9h?=
 =?utf-8?B?V2xqelZuV3YxSlNMeHNFaGg4b3UrSGJlMmw2SGY1RVRCWWw0dFFBaHZVS0R4?=
 =?utf-8?B?cUVzTUpEaW9aYWZ2N0NNZFFyQ0VZSVhrbUw1ZkNuTm5hMlQ4clhSN003Szcr?=
 =?utf-8?B?VThCN3BqSURpV2M3KzB6ZVBhdTlVZ3dqaGxNLzBUdnJTajF1T1YyODE2aDR1?=
 =?utf-8?B?eGNpTUd6bkZUQzVrYTJvYVBLVWFFZVk5TUJkUGs0eUV6Mi9BZ3J6Ym5ZOHZq?=
 =?utf-8?B?eUZoOWtmMTNRcTFlWWZvV0tweWV4UGptYzhDOXdGUVFXamlrMDNaRXFpaTZJ?=
 =?utf-8?B?elhPbUpGbW9MbGdmNEt1Rk1DanFUYmxUcG9OOE81eVpWT0ZIYVp5cTI2MGdP?=
 =?utf-8?B?MmYwZ3hBWFp6WEM5YjRKK0NpbjBrRXNxL3JVN2R5dUx0YUF5cVc4d3ExdmE2?=
 =?utf-8?B?cTI2RnFJRXdROVhaMi9wWnBCQjFOOEtvOWl1MWx3WnU5VmZTdmNzRWFzWXdT?=
 =?utf-8?B?cmxCcElIazEvNDlxRm0vQ1FoTGFLRjNLaEx6NWo3WlFvSWdxRUtPb1ZBN1pt?=
 =?utf-8?B?ZlNjbnNWb2FFT3FrRE1MSjZUQkhlVmtJZG54TVYvY0JNUGtuY1Z6NUhzYnRQ?=
 =?utf-8?B?YmZ1WXRWcG5TVDQyS0lsdG1Nbkh3ZCtMd1JTVndSb2Y0YUc5VHlYMFZJRlla?=
 =?utf-8?B?ZU8yeTNmWWxnVUhHeGFJaWwxOFo5V2ljUGZ4TmVLSWhvSDExNDFLTDdsNUlp?=
 =?utf-8?B?dGVSdk1KaHFhOUZyMkFnTThTVllvYVY4OXZZaXZJMzMxMjRkSzF3OVNIODJl?=
 =?utf-8?B?bFBMNWUxV0dJa25vL3dYVWxQL3gwUlVuR1NHMnB3b0xOdUdncHIrR3ZMZy9X?=
 =?utf-8?B?L3UyRGZJbFppUWVYWEJoOHpUTHJ2SWNqaS9mRmw3NGtvc3lLYWNYVXVPeWs4?=
 =?utf-8?Q?Q8UZdz3YGAIPhFr/Bs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b718f75-4527-4ad5-4b46-08deef72f81f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 02:17:00.1951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: due+TvJ9NIwYy7oj02SiKmUnCFUNpRJ6VtB8+179ZDHkHol703nFyxLh+tNAby6S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Stat-Signature: 1jd71poi39m3wya3ezcokxd9ggjpb6ya
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EEB05A0006
X-Rspam-User: 
X-HE-Tag: 1785550632-152416
X-HE-Meta: U2FsdGVkX1+WgjDz5n5QEHIH4oU6P/oWwxZjpF9ZtLQHmUgGYHccw0fOWzlRUne7qcJJFskJ76pMzXDKv3uQyMgb1BSVIrnVs0EEeK02udDrglclTr5+yeJ/T3XTP5O4NdkMD2WJ9EK+aBnOI4l8pahxG5F4bmvaymf95bWBbDL/h61SYu1q8MQSv/C+lGa/Fk9HY1ASA9P5uff98rEsOcCjSO8a+3aizodBk88kqygw2v7HrKvP9LOAqTNpHobddCCgqcwLb2051KZV3Prh/nrrAe68qoG8gROW+fvaQ5h28L/JloOOM2Km11w2W0n/dpS2Efolsbthea3CliRpGd8icjsY44JAaWZ0KI+js4paNv68Ew6hur3XdPIyDfUM3p54igMRYeHkZwwOFGiigTB4Ks3AqQs1o1rLKQqF0F+MSGDB4ar8zCNjgbiaPrGNEFQq5mgy9nQunnBKeTIJ3FKnVCoaZUfifDyyhLxpxGCaZPfDkj1lxsQcwj2HeZ6gR2vKO7/ZPbeMpwX6gl+BQonPCSHxZkfkO9ANJ04uPCYonfhEx18fVNbv/cCIDKVMttZPloRmfdMq6LOdVep9dXo5OPOb1yt0nCgeWwG5MjhNGfO/AahwvZ+mNBa54CieMFOo7uPP9iUUksdIw0gd0Uz+fvVuBhlHOFI3qDd3ym/O7yWapV+AxjBlMaY+YRnizbJzOmRSUMPRxrEN6U4MDljl1i+pxyZSX7guqvtPbqoYBvfSF9p6cLQX8RK7ZTuUvY/HR2yfpTCOH59cIwBrzMTVdNS737zGSKWdou7riqtBQJcZuhBhkC31rkhZKmVXGLIRZzwOFK4XW7IUUFiV/vJWYzrtv5grLgp2vBCie+1Fe/+Cg7lyJL5PkUkRgKVKWo25jB6aAoHVWGUTi8cElrgrdP+23INN82tOJPCKDrlBVMeGPa7L5zReKnNKjtka1aMg+1emwvhGPe2vPrq
 IHSFAADN
 3d8zq0Wpsl79SzWHGd1dNxp1rD7/CHIu580xAinhG5ESE5rky0gnuhE+0HkgbSqsHTQRuVl8x4sWQvqwu+/V+W9oJsls0rliGsaHRhxwzRNyh16GHzscMvcBwGxYTLSRFWeau5hCLhV6xfuSzmNhTOzkZbbNiGfyOtqJuvW115SY9olHeGx7Eax/pmPaAu5LpyXXFej3Av6fcDcHG26BEx/bt9/vKeJXGhhHw5YsDwpfQRysbsA7YbkCIo1EEU817rI2O0gKxr22WYXNGraJ1Fwk3u6QGxiTDe9Uwm0pBDe7uI8V5iIqNEC/r8CneSIx39cOsj8UXxJn9mC/vL4akSBS3WcacOB1VduqbscxS0Y0n058nmpw7A/hsl0kHhUXJlztFJYwJe5hSQxU4/2JDsKePheZl/eiMeBd6rB0SQgc50Kd8HieiWHvCQ3BHTqNnaRA1FoNXztqXG0CZAAqRwUvjAFUY42TW2pbQEBBi+spwDLVYQoB5FyEirGfjO76UN8uOHSBgdyu6mEsqGoa12Z11pmO5vKCxJnOu+k0Rw5S7jbM7oeH8+p6LROyhyj/HMPg2/iGxrN+qYa7fdXExexzeFC7W0ep64XkSjOnwTMnf8hidNQ9Ewf+dFmuJtjZGd7lmu0e0fAVqtxTi0FCe+DKAlc6sEWR1cGfqsVm9lpIqKNr7boHSjxKGYWz6ZsCIVahdXv3ZgGN+t6QhDPK2b4S3Tfa8Kn73kHRQ8CsZPjUno3I447ULQ2BLVNeVQ4Jht0Se
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

erofs needs to traverse readahead folios in reverse order to achieve
maximum performance by
1. reading all folios from readahead_folio();
2. storing the prior folio pointer in folio->private;
3. traverse from the last folio to the first one.

Add readahead_folio_reverse() to achieve the same function without using
folio->private.

It prepares for a future commit that replaces PG_private checks with
!folio->private checks. After switching the checks, erofs's use of
folio->private without bumping folio refcount can cause unexpected
outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
reachable.

No funtional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 fs/erofs/zdata.c        | 11 ++---------
 include/linux/pagemap.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 74520e9102596..b59f2745a8e72 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1902,21 +1902,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
 	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
 	unsigned int nrpages = readahead_count(rac);
-	struct folio *head = NULL, *folio;
+	struct folio *folio;
 	int err;
 
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
-	while ((folio = readahead_folio(rac))) {
-		folio->private = head;
-		head = folio;
-	}
 
 	/* traverse in reverse order for best metadata I/O performance */
-	while (head) {
-		folio = head;
-		head = folio_get_private(folio);
-
+	while ((folio = readahead_folio_reverse(rac))) {
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 4e8b2b29f6d3e..90904a4d173b7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1549,6 +1549,37 @@ static inline struct folio *readahead_folio(struct readahead_control *ractl)
 	return folio;
 }
 
+/**
+ * readahead_folio_reverse - Get the next folio to read, from the tail.
+ * @ractl: The current readahead request.
+ *
+ * Like readahead_folio(), but walks the range back-to-front. The folio is
+ * returned locked with its refcount dropped; the caller unlocks it once I/O
+ * completes. Compound folios are returned once, at their head index.
+ *
+ * Context: The folio is locked.
+ * Return: A pointer to the next folio, or %NULL when done.
+ */
+static inline struct folio *readahead_folio_reverse(struct readahead_control *ractl)
+{
+	struct folio *folio;
+
+	if (!ractl->_nr_pages)
+		return NULL;
+
+	/* xa_load() follows sibling entries, so a tail index returns the head */
+	folio = xa_load(&ractl->mapping->i_pages,
+			ractl->_index + ractl->_nr_pages - 1);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	/* Shrink the window from the tail down to this folio's head index */
+	ractl->_nr_pages = folio->index - ractl->_index;
+	ractl->_batch_count = 0;
+
+	folio_put(folio);
+	return folio;
+}
+
 static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		struct page **array, unsigned int array_sz)
 {

-- 
2.53.0


