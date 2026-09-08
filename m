Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD7CC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1D36B00A0; Mon,  7 Sep 2026 22:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DC56B00A1; Mon,  7 Sep 2026 22:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F696B00A2; Mon,  7 Sep 2026 22:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E57676B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 788CF1A034F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:53 +0000 (UTC)
X-FDA: 85189082706.04.8D92C69
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id B3D591C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uJeTMkrK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
	b=Ls60Vvur5H9jxugGeaRNAvCCbjQIKGlKm9NLVpVXNP7NFRSKPsjgcfbxmUZr9ikc3/CPUO
	qSog+4oaXdvegcNZyruy27/+qXw7mdhXNxAacl/UCwIJOtDnG9tgpX180mzafdP7geGcYB
	u3WvrTyiyxJuTJ5Cvfa54+w8vDBbNYQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uJeTMkrK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836210;
	b=CiyW7qj3trrIADGTmttVIn0S/4dHOTGsslu1kjzpzyXc9EpO+T81f+RBAKrxkrTRU8lM9E
	X4V/S3MVxEj+A81C9vbx9MlFLgr8Cz/7bnnciz1j+V/RIOA+7mdGZVk0ODuZHk8ZngEYDl
	gLhw/m0coRJq9C0tFodjJgjVkY4MeIk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/XdrlSjylUB1y+ly+/8XYRi7kGbHa+FyioHnEn+y+DL2bt/3nqOG1ZASXGw2kAe8S2i0srBnZEX7l0jVFq71RI4i2IQBKbs/iYTr5RAJ/loNjwyNXZwNDelkq0o9zht9Y2Bvd0EEf270ygP2Em78yxRXeSK8NJDJi5m8KqUIelTqdpCGVrjbSwN4xtbR/n4T3a6JbNF1UpR3hP9Bk7uF9zHSNJ0KR1GSxZFTxLA7wFi3rlZKtPiKIHNp8jbB2KwcSJokOKQqaHtybXBoO00bqsEXDQUkVoyev/Zh+twzNzZ/mLW7I64hHuQY8CS3TZRKS5ZADFa+a6FD1cWrjNXGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
 b=Ty1ilNkAIujtZDN/QS1ALgD4itHzu530+ZIh0qaVF9vWb+zoZbMZvkh8kbyqtqmjtmyS0lF7Bo7ZDCfqpLILErR7wt6gKyVg3mcMUxLf32CisRLnSEiWxlvfOTN3/wp7KBtwGX7zpwohxX3IMkVtkCdIJ1RqrjAkJk7Z63OswZPv6C5so7LrNkHnlrlUfzq0V7rI8ZDjurufJ8HgUT0kUvdLk84jlF6RYIldTvurO3ez63K6OfuwOyl2fXiPaMVNS1Hh3pv4kMnBKFrLA0ZG45tuvbH661GdBqs3bQquwyC2OBocDEgPtGV+HimlMWzkfgTHieb2p/IZ4A0SjIYNbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
 b=uJeTMkrKN4oOSfrgr/noxLTyP9/k/RiTUmhu+KOBMa8Vh2yOWTYs4zlfpEesZ5WZmnKEsUMLWSo9dm7XMQ5UIIk/3R/Ge8inwZa+yWIKelm716rsPbgPHyjbzEkOKNND29Gw7oKMVcT3ARQamp2BMIdrNiIYgWgGwl9fEYg6UTT/Vhd8RCOJ1qjkRi/x29pCIdbJVzZE8A+t4ZvkI2Cyar2ZdR98Nww912P6PpPBltxtm9S62Yk7HxSs+xPez4yPKVEB+I7SU0nhN1pBCvbbOwV3MZQcxhtGh7hsonJ70ejmX2WweTiTk5PxjoG2WahdPQ9SLYZdCnbA5pIl+5XLww==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:37 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:15 -0400
Subject: [PATCH v3 08/14] erofs: use folio_attach/detach_private() instead
 of direct assignment
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-8-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
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
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0250.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: f18255e5-a2cf-4b7d-33ec-08df0d54cd06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aLvUlpuBIIy13vG4Takn733L+Arzks9WGlLnQ1sjT1LC45xy4Kabs9QA5066gAReoxdpwX4YsJK3x6wFROBK3L5MBWS+DbC4dzHR032XF3MUGoNDsRm81CrNBnU9dqR2yjWVeIotTBL039SLNxoF1dZrl4Sq5xyFisGsxA6U7Q9mFoEN5sS7SExokce3mcBHGJa7YuYFWVqpsT9FW9hFEyDqoeC9DjQAsq6Xo8QNfhtY4VP69fioAlgJY1Y3p8RP2Vbc1KE2OkdyAeRa3LLZjfbYDIVooej6xp6lKqxFiMs1+o6I7KQWc2dRjFbWy1k7goj2p1MpqDicj0dX6XBJaVoaUGeE8Xbhb4dW1ykL4qgRPBVdbdS0+1mHe/wP6ZOHUegFshdGF3h+nfzgWIDBYfE9hjijjVuKSEY1rllczy9AdW/U/YHcgqKTOmnLia+Js1Xw7IRYK44P2e5WE234mg5Ojwzddhm8TVxDqm9V2FgyYcYnvVZZc+5H+djxqxvsCDvKxATq/W6zoWXCyy6iU4upfMGsM3gB+PKblhbzICwA05WwmLTSBY8NC01SXED5VfhBLRDFtfnJtYt67WcEJjBr+jyiVsqqYn91VN/rwlkOVX27p4dUqPcKN+rpATWANYSmNtD3H0PFU+OmpUAZROHpdw2Ao944ScPuFR/ZQDKMjT303T0w9aa/kDYal73ZAE25iSu5Now6bXcjXmEH3g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3VnNU00TktJQk13cUI3SzVXZFFyWTJoVk5sdCsvdWZpOG1HVHFRS3NtUlZV?=
 =?utf-8?B?c3hRT2tGTkxEdVF0MjdLcktFeThEcnpHZE5TN3RpNDY5cm5xdEV1ampkWXI4?=
 =?utf-8?B?RW9lYTluMDU1UDhoNWsxUk5ndDFSWXFYU0lzemY0My9CYzlyd3c2dXYvSWxD?=
 =?utf-8?B?Kytpd0NOWDlnN28xRWxGS01Ybk9RTDBFajBlNnJ1NlYvRTRQV0RWSjQ3R1Fx?=
 =?utf-8?B?U3pLV2gxUzZXNk4rV2JhVVVDNDVoVHdiUTJGL0RRTlBnclNQZEVSZ0ppeEtK?=
 =?utf-8?B?NGJKK3JxT3JOZ3RMQmRIbEN5MGVuUXozQVRmVUNEUnN2SFNZK2tTZVorKzB1?=
 =?utf-8?B?VEtOa2c4SHB1VTJHaGxHR2NlUUx1bVExRmVCN2JLQ25ZQ2cyRFNIQ2dqTnhh?=
 =?utf-8?B?Q2UxOEk2eE11UHpmWWxldldPc2R4MS9tU1ZIUW5XM0l6dFdLa3NYTi80dk5l?=
 =?utf-8?B?TVJIL2EvdVA2bGMyNGR6eHBEblprcmwxY29MZS9xSnE2dUFiZjd4VXJlZStq?=
 =?utf-8?B?VkVIVVpqVVFXUXR1Y1RYaEJrS3JpY3dpTTh6elhjd1JEQWVNcG5pNW1YSUpL?=
 =?utf-8?B?ckIyNTlTa1VyN1JlU0xOd0V2anNQUGJkak0xSzVhRUVHZ1ZINm1RMkRUeHk0?=
 =?utf-8?B?QXU5U1lMVG5xWnFXaEUyNEpWYTQ4eWE4Q05PWmRtRTE4YS9rTG8ycEkwZ1Bq?=
 =?utf-8?B?YXVHNm9BcXdzVXBjeEljWkwwR3hFMWRBNmlUNHB0aFpQMzV6L3JYSDNHMFZE?=
 =?utf-8?B?Rm9CUms0NGUzSCtsdi81M0gvaGRFY1RnbCt6TXp4aHZnV1p2SytONnBkWXdk?=
 =?utf-8?B?WEUyYmpLZFdWSm55ekZ1bGR6ZDBKOHh2WG5ZbGhrSGxXbVVyZHBYMVc4Z3BY?=
 =?utf-8?B?cGZ2dXltVFJ6WGNPck9HQ2pya0hOclpadDRjMXQ5SEJvUVNNRFFrYnlXbGtL?=
 =?utf-8?B?M281OU8vUjEyVFRGMi9rMERjbytvUXpxbmxaMHdLby9abW5VVFlhMCtOaGQw?=
 =?utf-8?B?SWFENmpSWFhpN0tqbkxWRjJabmwrZVhuSTVsczdSUHlhUE1SL1IxcUVjY0sw?=
 =?utf-8?B?M1R6Z2RFeWNTQ0IzRTdHMzFodGxRQ2hScDdTVnJHRXpNNnpnMTNKVFR6blE2?=
 =?utf-8?B?WjJjZ0hNUVBuMEI3WjBlc2JmalczbmF2dkF6clJlc2VZZHZnNkpiMlkvVWZJ?=
 =?utf-8?B?QitpNU5YUnVOZTN1Mnc1WTFEM2FkMWNTWFJaVzJtVUJEQWtXa0pUOC9aYzha?=
 =?utf-8?B?Qi9KZ3RrZHdVdlVFM3RYV1JCd2dEdUVaWFBwdXdlQjZqaTdQZm9HcW5Ebkh1?=
 =?utf-8?B?T3VNRUFYWnV6aExHYkZaaFAxandLc28zQ1pFSEd5eG9ZenlLQ3FLV1pEZGpl?=
 =?utf-8?B?YUJxVEVmUmxpRUhUaTVxdTFwNFJyc3l2RUloK1pSR0dxYkdPdzUzaGFSZFRJ?=
 =?utf-8?B?eThQNzdXZTJwd0lqL25ONXZjTll0ajFpSU9lbXV0NUgwMkprUTgzNHFHK3Zr?=
 =?utf-8?B?YTh2OUp6T2E5OEtVMld6NUNDNXprSXlpM2t1SFZ0Q2t2NWd6eGx3QkhyK2FV?=
 =?utf-8?B?cEJRWEV6bEhneHdEYjFYSmFWRUpoWlJ5OGVlNWZYc0JEbnA2aVRYRzE2TEwy?=
 =?utf-8?B?RVkyN3N0NG41SFVxMXRvdlZIVDZrbGg0aFlGZDdGTi9BU2ZkNlVUeUExQjBy?=
 =?utf-8?B?bldRTmFoNDJyNHdLSHU0UGpjWFJHSkc5eXFmSHFDTHgxK3p6V2tqQjJ6QXNM?=
 =?utf-8?B?SkdER0RUTTBYZHFjYjRrR1NGVjd3RWdKTDVXK1BpVE9uWHFYNFRzc3hHeHlC?=
 =?utf-8?B?MFB5N25NNHV5S0RxSGo2R3EzbHNwZHErVmVUeC9ackR6b1ZpUTFMS2Z6MTdO?=
 =?utf-8?B?YW41RHRYZ1dtcHdSSnNWajhFbmVsVDdYMHl4M2JudnFGbFAzTEY5YkhKRzNV?=
 =?utf-8?B?MHdkckNRYkwzZ3Q2dTl4MTF1L3dmS2FIWTVZT1c3bFR4cExPVDdXeU1lNm9Z?=
 =?utf-8?B?QUhrdjZxT24zdHR2SXF4SEZQZFdwdTIva1hEWXNFNnRYU0lEZ3kxNXY2d2FN?=
 =?utf-8?B?NDdPVlR4a3JoYjBsQm5zV0xnNTFpNmZDOEsvZXNZaU1memRCZ3VhVDFMMzdq?=
 =?utf-8?B?aG1WZDVrMUlVTXpCZ0FWK2JCenNFSmVzYVFVQ1MxOHhla09lNzV5a1dHS3FR?=
 =?utf-8?B?amZsb0JzMU9FSVFlUDY0Y0p6UlJMVGNEUjc5Tks2cFN4S1Y2ejRPRFZFWFFF?=
 =?utf-8?B?NndVZHFCY2lySmU1cUJVa1JUSytsTzVtNHUwbFA4L2V4a1lkNW85S0kzYUhU?=
 =?utf-8?Q?4bY6iVe77Go4ZCVIlu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f18255e5-a2cf-4b7d-33ec-08df0d54cd06
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:37.8895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YP2p1cKXab8zxS47zwsYwrzYzUElbyCS25c3LL+Djk7I2ZRtHw3b1B5+fMd9BwTp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Stat-Signature: e4e3o8fctmnjpk31sd7nbo6zg1i19urs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3D591C0003
X-Rspam-User: 
X-HE-Tag: 1788836210-122464
X-HE-Meta: U2FsdGVkX19NUidhLVNMIcLnGqIY/2CCZDCYr6tCdXN5FC03gbRs3NJbGoc4U4ASlKi8ao1+3zIBHo8vaHeBqRqnhSHxkjrrb+W6yMWBOZgPxHx28sxOLIAESCPJp0H3yQrlK9Y13f5rzEU8w8KWv2CeW3FkxO2fPTFLujdjMXNro4iVXoPQur6Sp2n2PC07eKQuw6hQRxwITiErwlISvWbWa00pRHI/sh7hFtA0/bMwcPmEYza3NNxRc+KAzjsFbxg5N6EQwSSytP1NemnchEOY5i5IgzxUgBjAPq59AgbQ+7xlKyn+Zp3NUcP40yD6Lf31OaAtWnd+Jc6lHjuS149+j+g3tuaLzOjYH+szmltkHmd3UCiGPOsPl2hI9wqW4TXx5kN2s1TWkXXjyYtQMxM9688e/G+IRFMt/q7AocqltUdusj+4mzGyfQRLGoaVHIzzNt3nEuYQcD8nWPOksFVZ9/OW2bWqZ+icGY2gw6qGe7720ioyE1wioeC38p0EGcZagUZzSFLIzjDgGhTiXc9P41UUTBZn+Af/9wb8xlATtVgQ5RJLf1VBU6KhNVsHbThRoyrTEfi7wxeeNunQvvml77pBUKVxHO0lJmumr5o5++0RnzOiRGWiTakAGnsGfQMVn2MzPu5PMnX3tfM+vYKOOAdjyY3u7czyqV43OiKQDIUe9jYoHMfbIs5FNqopBTOy1yJoyQlckxaqHb9avxfO1DH+x1w0JWzWtr47fEHM+V5cnwpGtPnR2AyKAYnPa1sddLqd0wNkntg3f3K1bm0wpRj351SOCBscypfixoZl6vae4kBZtkrSeNsAm7s5/W8tZVo9DKgmqDyrSrhi+qYkmqIMpxYgeIJ5OVNCDBxRugE+h7yLd9XSzjimSJvpkPEuMzQUPj8Xx/B05xaFIvvlJC3hUufWCXV0HOKQ48LpXzV0lPINFipVXaAq3oS1ShP/PsKBeu8QogvRk9y
 bzsTmVMC
 T6/wRqz3ajfeRmM2qEcbjrD+vuKHlAcMvVw6r3kvxhUFNLgcDXs9NFBifskDtgKlO6HwVYQMLstQFi8Img0cME64oHmkMh1u1uoLeXx0p/PIh9rqADKwYM83qKkO6ZMcg/7t37dUpptSArkWT7XjXJkTwE8XVFo2mbsf8T3NSROUhSy5m8WmIgvu1FZMgImxf0mAqZEn1+xSuiF282zTwbFNrl71qBjrcSjg8gtmuX3x+zh9sbtVIATO0V2Q46y3+mvf7tUGcHR3CHXa39MgfsJwtM1IbjofjLJl6/cPJIEUx+4vC/Zest7Yot/VVqwdfStiH3oFSlcBVxCinXtznMIHPVwB+vuH3LirLtKctG3bpl2IX3yWv7Au9Pk8nKQRjTOc2tW3GZFpvQzNe/1iSQQWMJ1Pe8iQbY3lk2IfxOTkG59KLdPcHIhAfGBfkQVpN7E010myAN2TSqQ+cPDpOy4/7KHvi7L7zzJo7kZ1fWAFPurckIOgebCveVnn0YifBQZcprcwq1mB//jxUKcg+RwXzn3IxfYMBm1/gHODvKpIa8WKpjdOuEZS3clowlbms/XVswDxJc2DXHQkoswbl6qLlRj5b7/QPNuuFHEasiNT2Z/gUcIe36uZgFgIer4hAl9Fa7cDIjglA1cE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

erofs_onlinefolio_init/split/end() use folio->private without setting
PG_private or increasing folio refcount and it works. But after PG_private
is replaced by checking folio->private in a future commit, it can break
folio_expected_ref_count(), since the folio has private data without
elevated refcount. Change them to use folio_attach/detach_private().

Furthermore, because folio->private is used to store in-flight I/O counter
and the counter reaches 0 when all I/O completes successfully without error
or being dirty, ->private=0 causes folio_detach_private() to not drop the
elevated folio refcount. Solve this issue by using bias=1 for the counter,
so that ->private stays non NULL throughout every attach-to-detach process.
Add a macro EROFS_ONLINEFOLIO_BIAS=1. While at it, fix the comment about
->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.

It prepares for a future commit that removes PG_private.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/erofs/data.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 0885b1f2fc925..f71c7b51bb720 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -239,19 +239,23 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 /*
  * bit 30: I/O error occurred on this folio
  * bit 29: CPU has dirty data in D-cache (needs aliasing handling);
- * bit 0 - 29: remaining parts to complete this folio
+ * bit 0 - 28: remaining parts to complete this folio, biased by 1 so that
+ *	       ->private stays non-NULL while the folio is attached
  */
 #define EROFS_ONLINEFOLIO_EIO		30
 #define EROFS_ONLINEFOLIO_DIRTY		29
+#define EROFS_ONLINEFOLIO_COUNT_MASK	(BIT(EROFS_ONLINEFOLIO_DIRTY) - 1)
+#define EROFS_ONLINEFOLIO_BIAS		1
 
 void erofs_onlinefolio_init(struct folio *folio)
 {
 	union {
 		atomic_t o;
 		void *v;
-	} u = { .o = ATOMIC_INIT(1) };
+	} u = { .o = ATOMIC_INIT(1 + EROFS_ONLINEFOLIO_BIAS) };
 
-	folio->private = u.v;	/* valid only if file-backed folio is locked */
+	/* valid only if file-backed folio is locked */
+	folio_attach_private(folio, u.v);
 }
 
 void erofs_onlinefolio_split(struct folio *folio)
@@ -265,14 +269,14 @@ void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty)
 
 	do {
 		orig = atomic_read((atomic_t *)&folio->private);
-		DBG_BUGON(orig <= 0);
+		DBG_BUGON((orig & EROFS_ONLINEFOLIO_COUNT_MASK) <= EROFS_ONLINEFOLIO_BIAS);
 		v = dirty << EROFS_ONLINEFOLIO_DIRTY;
 		v |= (orig - 1) | (!!err << EROFS_ONLINEFOLIO_EIO);
 	} while (atomic_cmpxchg((atomic_t *)&folio->private, orig, v) != orig);
 
-	if (v & (BIT(EROFS_ONLINEFOLIO_DIRTY) - 1))
+	if ((v & EROFS_ONLINEFOLIO_COUNT_MASK) != EROFS_ONLINEFOLIO_BIAS)
 		return;
-	folio->private = 0;
+	folio_detach_private(folio);
 	if (v & BIT(EROFS_ONLINEFOLIO_DIRTY))
 		flush_dcache_folio(folio);
 	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));

-- 
2.53.0


