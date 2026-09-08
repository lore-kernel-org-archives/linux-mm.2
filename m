Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90860C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910516B009E; Mon,  7 Sep 2026 22:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A486B009F; Mon,  7 Sep 2026 22:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7139C6B00A0; Mon,  7 Sep 2026 22:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC056B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F1E014033D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:50 +0000 (UTC)
X-FDA: 85189082580.14.1C13635
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF0751C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EARkzWTx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPJDDJcKa9lvexi7Wypu3m0WvDuY+EowhGLAL4uORvw=;
	b=xczQKLC5hMqaci27MPJCIQmkgk+hj9ODF7vn7tp4EMzq++qJgAhqPAChBLrVFmNgDKhDNV
	zpbmGjHBqKV+PbekP/cCDfTnSr11xng4P+NifmS0dgSPYwzaWl4N3zYCZT3hP1138ixOWl
	1OLjzeKZzddAM65/ptkjjrYMB/hqC9c=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EARkzWTx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836208;
	b=DZj4V2Z1VBWHB3N9uZJo6pQAwtH05CHbprgTyMj87Vuep7+n93t2FJXEvlHcv/BcK5UIW9
	XXAebs8yuXqgI0x2YGeRTZiLEnoNzXGnt8OE4avobSy2xtWkLckkiRHJBNsxprY7RYraCp
	Nb/+YiNRiBWhsh78uzQBBCZAJ/YgTcY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qb5YnqaXickL/Z1I4J8SBo3ow7zXXdF21YXsTqNrtsBoWx7eQfkU7wgbixrmRQsfbtc/IlOqfm7802bMaxkB5oEJ5GZrB4qB2iE1LKTT8viwsA/cfmlgGBsln0RKIxyFOM9GVt2vaXGkt+otVqzPR3yMc9jXzeAAfrXqPrXwYYQz9AaiL5tksm0v9hojjiC+fGV/rPK9A1Zv/o7dJqA9H1KL0Gk7gjen5TQ+ZWB6ulrQj/cDOdLpyVo64rKrZJPez7iXMhTYlhh7+njOjU7dDLnrReQB28cpTlbnrHMPSE9AvjTj8bFdrpXjoupa7aoznXg2QmfcHbSKVpeZtD07XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPJDDJcKa9lvexi7Wypu3m0WvDuY+EowhGLAL4uORvw=;
 b=EXmF0MBmnX6VwQ09TOC/Fszt1RVG+oW3l3/LIW/L3QNm8nqXIGX570d6AxAKxkoa96JQEi83DHp+Loskrg26Ev0fkYJ+kFwx1fav9hMna62MnXV6TEHsCqwwsvtlyMqQuu42oJ0S2f8xFJh4UU+meqyn9chbDj5QtuiNIyGqlmw2qK/y3wpoL4+EUErb120YuxKTN7dCXYgx8WKOQWIXS40zUeDjrFxgpDcpgl1pWseGPTduz0aMA2xuGNIO3LhQwFlz6BAivGOEriTuzJd2v97y5pHjVw63roevguJ2nSBWi8NAAVu83LXFbIwi1St37QaBB/tMQ/DJ3xGso/Sl4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPJDDJcKa9lvexi7Wypu3m0WvDuY+EowhGLAL4uORvw=;
 b=EARkzWTxbjGbUg68P+hRHi3O1NbHrC2dhgZs+vOzQApEzmFnDF9mCDUZ7k3aFF7PRV96WZNzLeglEaoJy0tMFXeV0IKdt0s0fqiIvuvCYnsM35xCjjGhjrETmR1gJyrDk7UhEw3tTGxoVEk/IxJYYidgqusa12jdBn3v4KPIy+59OKljsYtfLe1jmI8FsmzyEjtL6QzJ1OGAzPQcpqjbYfWg9moErYLdR4eVcWwoFdazc1g2+BholwXA0wy0e5S72zfCwGDkkLpnaVh0aoh58Sc5EiT7wAu1Hwf5MqNQwvQTwFsoN8ILiYqX2fUOpsLjctdtHOcaNDF/jB0W4Sj85A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:35 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:13 -0400
Subject: [PATCH v3 06/14] f2fs: stop using PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBP288CA0035.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a18082-af24-4e07-d94c-08df0d54cb45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WH+/tsI8ILKP3E30KxAtGmboAXDp84snsAsWiw7brcVsY2AX5KhUKpsH9yNckEgIHinVu5jThRUkVeSIG33H+gEBqLFZ2fs/TCA4TMVVUOCw2E/G3Re7nCp8ErFClFLsUme5AaSmR19qLV/3YCwfAvFW/HxsGATXrJC1x8DximiN9mY81AD68SGfUB48KSgO0VbUwVMLIv4GCN7i6u28iU4kM7u/N4iQxFzL2v3q3hVGzBfiPXV/Bg0q3OxtuImi0HTe8QpeopcgKfNDFv07AZGiFKI8HqITx7hDpMBrI9fjj/uoUSY+W7Vty8CloD5LSN+lYJBIhCW48HLTQaP/ebwodFAfEcD7IPyU9q2FGE1Qb3sB0WLtEvqgW4v7A2WkVxKk4JAuUz9N/0HO2r+4dwQ9a4C8BQth2/c+epceCUfJ65pV+PMovLfahmEFnbvse8XXH4jICAmYE6DEy7fm3uyyIg4TsLO2QmPNjuyO3goIGNKRtp7q+5lmaoCDpwZl1LnOk/z60mGMrNZrEEDmWbfxSBojsd515Balz1JhqgboB8iX+pXZVVXz9xX/79wUOOXhNtO8dWSTDfbboBTBjQZ5brpRJX4Gys5bBIfQpTCB2NaH0/CmbwKWJubdRxIm+wYpqlrtmM+c0+z1ZzYoCwfQDTXS1vzel6e3TJ/m7r6SgxR7FiWzvfvUgpf6rmK2TjN8aZ9phQiCi+t72kztxA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFVNZ1hpZGJRcTJkVWYxSk5UVkdaelk4L1RCV0FiSjUvTFI3RllYakNocThz?=
 =?utf-8?B?d0UxZjJVRm02cjIvaHUxUjJ3K3RnQlBqbFprNFl6VnVqQ0JBVWcrdXJTUklE?=
 =?utf-8?B?OHVtR3RhQmovaFg0dmFGalBXNklJcUhjVWtiTE5FMkppZSttUWppUjVTRDFU?=
 =?utf-8?B?WFVRUGViZWkzNFZKdzRwblVnaGVHQW94MVlZWDdhK3FjVUVXK3U0bFFXaXVF?=
 =?utf-8?B?ZTB1ZjNjczc1TTAxRGtldnpOTVQ3emRtbXhRYjR6ZnYzK0dJak5vRVZaK0ZQ?=
 =?utf-8?B?cDJVS3pkNi9UeFhGRkFVWWkzQjN0ckExYnkrOWxzNEF4WDBORDNBSjFzVFZG?=
 =?utf-8?B?dHJYVTZDNFI4V2NOVERib0NxYnIyQ0laMXlqcDdYRmpqY2JHMzgrOXFoZHVZ?=
 =?utf-8?B?ejBkRWhRUGkySVBQZWQ2RUUvd1NHQTIzUU9SZVRjQ2pSL0JNWHhUd3l2N0Y5?=
 =?utf-8?B?dWdSQXUxcmFsRTlTcnR4NHFzZzVxZVpHdlhaVnNRWS9vR25ObHY3Mms5TVBj?=
 =?utf-8?B?K21nZkw3R0x0Mkc5TVZtRmxuMU84dlFpY0xBN2xXeEt0S0ZBT1htaDlNaTFK?=
 =?utf-8?B?U25HUFYxNmRSQ0xmdW0yWGJsK2Q1WnZsaitPNHNjNzJKYUoxbldiRWRzeGVI?=
 =?utf-8?B?SkRQV1FLdXpXMEFock1sNEVJS3V5MjZBUGU3T0FKUEdNRVVDUHE2c3k2SHRx?=
 =?utf-8?B?REV5OFB2WXA3bm02TG9xWGxiSVIySjJsN21vNmdDYXorTm8wNXp0NlVudmFZ?=
 =?utf-8?B?QmV2RWpZTlVxWlVvaUQ2YjBhb0RZS21FaXpqdlR5SmNmVUV6dzlBOHRIRFJS?=
 =?utf-8?B?OUNyTTFsaS93Y1ZRWWd5b09RS1ArMG1hVzkzSUR0bU96VzBvVE9JWXpYdDls?=
 =?utf-8?B?eE1MV1Rzd21VVCtNYlJWVnJuVks3SXNWU1dpWUJIWGNJSmd4ZkFPTDhQN2Fu?=
 =?utf-8?B?V0NpZUpaemFRSTNXREg4b21vRzVvUWg1Z3UvaFZKZUp6aWFrQUxoWE9VWnRP?=
 =?utf-8?B?RjFLMXJ6Nk41cWdPcjFhempmRXp5Ynp6Nmg5UlBlVWRRWldFK3h4ejZkZUZr?=
 =?utf-8?B?SVpzRWpuYS9BWFkxUjEvM2NSbWhoMGluSTc4Sk1QeWZVb1VBRVZiZE1Lbkhx?=
 =?utf-8?B?WUtOUUQ1U0tRSWZiamU0eW5hcStOU1dMQko5d3BwTE9FTUVIM1N0OVNBVVFs?=
 =?utf-8?B?SSt6RW91RWg1Wm1jTnFmVndZRmtxN1ZxeWNhZnNUUDVVU3N4WTBPSkZUaTdv?=
 =?utf-8?B?Zlg4ampybms2ekhJZjN5U0ZJTGVxNFg3RHlTSmZVZHRNdnZkWUtPTTdoNTNX?=
 =?utf-8?B?TVBKKzFPZWsxVFh3VWg5MEgva2lIVFZ6UzFkLy96aDZ2SGd0Rm9zdlRSc0ov?=
 =?utf-8?B?SDZoeVRYRkVKWWZ6WWVyTEpEbm43MjJqSitsQmRHM2t5Rnd4L2ZiZ2FwTm5k?=
 =?utf-8?B?MkxyQjFkRFU0Q0xIR0p1cmpuUW00MEIrNjcyblQvYmFid0FJTUxaNUNSSmdW?=
 =?utf-8?B?QVJORVZtamhTUDhkdDRJN00zQ2pwZnZ0OUJZNjV2blFOVVR4M2RTU0dhTkty?=
 =?utf-8?B?VFNIZ1lTWit6Zmd6cHhSR25odEszU2VCemk1ZXl0ZVZ2bnJlQ1Fmam1kMFh1?=
 =?utf-8?B?aTM2QlFpNzV3RHBodUFJcTJCVmE3MEI1Y2dCb1NUM2F2MXl6b0lQdEpjWDFJ?=
 =?utf-8?B?Q2tMclFFRW5OYzdFc29mcXpTQVRTZHQrZ04yem5PeFQxbTkrL0FmZlZBZWNk?=
 =?utf-8?B?cllGZWZxRkxLUXFpVHBuRlJEZ2RiUDQ4WnNUWWN5QXRJSWlpYjRnYzExS0gx?=
 =?utf-8?B?Nm4rRjVKNFFzclNwcW1BeDk4N2xLSHNralV4K2t5QUQ2SnVDcytzMHBIa0Vz?=
 =?utf-8?B?OWVVRW9FczRyelkwOE1tYjQ3L251ZENLMFlENXVCUS9IRmdHRFhuU0NCZkVH?=
 =?utf-8?B?eTJUVURuMjV2YnVITGlGdE52SFdKZ3hwcjUraTkzbk9IYkFYOXB0SkJtTlp2?=
 =?utf-8?B?MCt4bVcxZkFYS2c4MVBhMVI2RWN5RWNQM0U5UTRyWFcvUEtybG52UmZJR0do?=
 =?utf-8?B?bE9BNXZQUDFrRTEwaUdTek5pRms0bzBtelliVzcwc1NuRWV5L3czdXhzUWIw?=
 =?utf-8?B?cW4zUFE5RktnMm00S0d0T1N4Mkwwa2lVZUFDZ0o3ZlpXRThZamIwVldaL0NJ?=
 =?utf-8?B?N203SWRIbncydnVmUVJxeVRGZlJvcXdoZm1wRzE2blBNOEo3NTVZdlRCVVgy?=
 =?utf-8?B?NjJsa2V5VkwzWlBLUWhlZEtXQ2ROOGNDMFo5eXg4RnArQzA3OFBMaVJPbFFq?=
 =?utf-8?Q?6a6oikmQZwlzpj26AU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a18082-af24-4e07-d94c-08df0d54cb45
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:34.9450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r1/oAVdGIBZnEmvFucxy22m+HPnBjiPoDyjG9wZpwPel4Eu0JDQGcwNoMfUV0Z7w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Stat-Signature: an5nxrx9y1n4hr6q89ibdowrogcoa4fr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF0751C0003
X-Rspam-User: 
X-HE-Tag: 1788836207-317018
X-HE-Meta: U2FsdGVkX1/ivlEO4xm2/uydYUuR3tuh+V4XkK8z+g0TXuU1JeuLkQJGk5B3RP1zzAf9AOnfPkfnyWkKKomTRQ+grWL/IW//+7qP2aQCmyvvdVAWLKXDO2cvA5WO1jP4yupSXVOCNsOpo6pA29oghLGFbTl4U5DMYWJ9kAlf58nWHfbCl0a2lVom/D2P/URztwWCe/EbqBWNbje0SYFghBA2YdBErMXrpT37TiHYKyhnHGN5HbaiZyMAhwKezD04c/Fjz2c+WtLsrqiQoneRe3jq7ouWXHIT98lYCDYC4jyJbv1MFaXic/Q1uOGQ85LNr7f6X83FS927eimRUwj6qekAO22zRb/q6G+7Ay72+++Fim0yW0sKX1Jo4V8m8etRlOvuujJLy1va9w+XnpaVbbfG9lgbL5P3Rtsb6PqAoJD5P66lWakeObM+gA7bK+dQWSdsy6jsCIXvXVb1IVts7mBLS31LLmDWBbqP6oq9zjdwWdzC3NKoLvkxhDs3k24obgbc4eqc7cybOD2gwLviN3xZQiejmyNE4ycxrIj8ulIxjR+pSlCQken+49jGA3g6T+d9Y0+UeutyjhVVIFalP6A7APrviaNkOZjPp30cD+vlJAY0GRhGBjIAnWNd9JdFmVEsrUl+rrdp1cZoX6GLBmL1uYR6PA+6Qz4QYEP0s9ka/mMj123wrA7Vn3en4UjiJa/3n/7DI+hqsDk69B3jvOJE1pc0TNkXBzpeUrS2waovi+fffE+qMwJwHB8yceVFfUHT+/T9JbTSvvJ8Ez/urj8ytrYK5+trYNB3xbDxtCy5t1fN5ZL17vNm7VGs1dF2+75kGVTa2FLRnTDklAzssvIQ4AFYiCeUR/G+XK2Psb/CaYbPGfdfKEt9O3iOCr3SSIWDGryW2J3PGsdbFevT4v8Fxv1EVMUyC7PH3mCrDFIzZQgtf2wBJ9OAsoJQ7mOA24gZCp/IgNdN15+vt7f
 TBDGBCIu
 3YmdKd6Xv8DjASxf9+eIbWGEj9FLTHhNdErG67mCYkFTZKB4kQwrLJ6lfnTFXE+1RLdK3/H4KmpPd0UEuY+fqgH8D1FEIGWAYKC2XzCSSMIJTrG0prYFp16JL4FscVlSTJAsB8k5B5ZDlEUVHfiLqiiUi1bV0ZsbMWy7qd3pk0RGhfxdQirQej3PNsG6pBu/X/+/F8QEcE1/IX8LB0GTxUAdGq9TtaK9kiIzWuiVul+8uV71MZw/TIL5/IQpDT4LJpplmvCRQE3G5GQc340Oj8ZMXIZ5aKmudWFTk6Z0YBw11JfJwOyByHdRNVrmbt11HDsARjPSO8wBKwp8RVaSKWC81C7mSL6228a3qjPhQwLdmq3jrbxIwox8z60qCuh+C/nfSl0SputLnJoqUBOPB9gumegf2zf2QcJf82WGVwBNnpZtgK2/KMTtwwU8Q3Tb8zmsebh+CHvXCgCQBwSvXQ9jBg9vQJsZdxqTdz0nnft4rJ6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
page->private != NULL is equivalent to checking PG_private. Change
PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
but it can cause confusion when PG_private is removed and
page->private != NULL is used instead. Change it to initialize
page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
semantics.

It prepares for a future commit that removes PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Chao Yu <chao@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/f2fs/f2fs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9940a6cecf1a2..2f7ab5888b078 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
 }									\
 static inline bool page_private_##name(struct page *page) \
 { \
-	return PagePrivate(page) && \
+	return page_private(page) && \
 		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
 		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
@@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
 }									\
 static inline void set_page_private_##name(struct page *page) \
 { \
-	if (!PagePrivate(page)) \
-		attach_page_private(page, (void *)0); \
-	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
+	if (!page_private(page)) \
+		attach_page_private(page, \
+				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
 	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 

-- 
2.53.0


