Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A19BDC982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261966B00E6; Sun, 20 Sep 2026 22:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC1A6B00E9; Sun, 20 Sep 2026 22:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08616B00E8; Sun, 20 Sep 2026 22:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B34726B00E5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F79DA6115
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:48 +0000 (UTC)
X-FDA: 85236186336.30.7BB0278
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4E4811C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rolUObs7;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957725;
	b=P9RkZJX1BdrcSdVBlRxzM6/UzFmjJEI7FlR6GIderw2Wpv86CmYD41Yg80W/zPbUgpDOx3
	5FovCVmIpT5cJM3uaGdp3Jw7EjACed2r2r7Npn+dMNro1bQWcBErGANk/ncbnj6I4ZDvQB
	5IwlNcR1XO6zXHh/pLWlHlkDshz5sxk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rolUObs7;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
	b=0iTagJrof2UZ4s6vd1KCwBNNZBBVu/pxK/Z7f6eTxYB7tIu5SYOp67HcvSJ23fXaMbjraT
	crQugRNra9IKXiIq60EPVd9+pR9t4Mnf2JfAWh5o553ZQwnjvdVFvoil1IAPhh0bTAW7o9
	D4AxcssIdbzVcUiK71sSk6DRqQ/ReeM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BpLdJcLoC4Zppl9uWy9emcejdW+j+IWWgwYq9TWOEdtJW4ODFjfH6KXTqW97C1iUe92eTjXHdCxURBXriTa4ZraJGDO/btiJmGpiOLjZgzYtJIdfimDbQjZtmfOvu/dIVU7cGY4pHQZOIiZqa6sCa3YOcsk2LmblEU63NvLVUmzCHY1pugiurIjoRb8IJ8SaoUmhwgJsjqkMBzCPUWyTBn152526tTEFHldRAPUtR16EREqicVUknPed9LnI+8u4sN07rsR/n5nnN2gqpDeuiUY/YvUf9bmrxSks+JFnHSzMIVglzP95hLHB5r515lPZhvHcm8D1RK+mapwC5j4s/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
 b=vwWEvyV3zlNdQim7tiCr0tfacAdgETEQcq+ftRF9TrCi6ff4uCh8KoOegkvqJu/z7pqEiq3a8c2waFmsdaqwzJqpOS0TsonwNgihpWZZ1bXbqhJzMqYBxl/E4gWgUsSwUpt35KCBfMwjiPmoAZtmx+pACPeSQG11oSl0bxH0ckKGbsiWwFxTaGhT6gl5zJY+pcXFxoISjT75z/ioWHt+nMcRbRbuARYXCEAXLDXHvG6pHnn9BeoN65miZoxmevYMbw6/Ib0+dhUbl6C+QRZ3xciG3GxKCZTOH3SPw/AcddSJCQowMlLGt8toEgXiy6uUop5iSNZamIR1RffdGsdsvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
 b=rolUObs7RU6Sr12aiqbsac0EkRWQZf6QK2lOrQIqci0hFZZV54hOWxuCraIY1FB6qMi4RiwK1CHf/3mWYesukxalpdTfxMNsKhIy/iYbxjAQN/XoN6z4gSRyVXzHgILZeqPmoEWu1wOO2bNKZUMjWoO7uFBoqSQROhtTDnSdFyUX81e64LiG9FbJ6RFF37mTxLjSYhf0kyFrR764PBXlZy4LM669ouKzrr4uZa7k5L5oxbXXe3FBAVf+JgZqv6uE5mJ7a+NZ0IDPD1RV9aUWv4Vs5Ks0wL2wFzGXJD2QA+TRbacdiwzGmE+cJlZm7feBQeETjxilFoou+Whxb2fBmQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:30 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:04 -0400
Subject: [PATCH v5 08/17] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-8-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
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
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0219.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: e99f5c06-2ac3-4c66-9ba2-08df178806df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	18X6OyMVINr05w3eObAUs44oO2p4k+d/Svvxpw2NNfSwiuRWWHCYwLsj/v/9FJnsoSAd+hswvDkLYxzAbnIuY4RGDnCYtOUODFa/4Up2I+3waZP+aJ7AXPOKQ5V+mLMSAOzDJVPx5qpJGAgNruKT7Ur2Ay6n22z5d5+rWRsQ/MjexD2azXxdqF9C2JnFb9rPRAthXFFhqUJ/Xcs+3MQGtxfeJuPEpk4Y+EUGgPgPT1C1DpmkQwsdXjFtruwRfrA6M3cPIFbtSKnQ9JaSdSA86BMYRJxxCyiT9C3ksGGvYUyFN4b/ZP4xUP+SF3IHYRyauh2jpkxSU1oJp7qhx94dQkYnrpgp3awgYSmAshIMvrPI3itfLnRdfdWK9k6F2x34QBXphZeltjgcKIzbd8U+7tml9gAMKS2jmOKnE7HzLfjd11plO1Qru0ytmt852H6f5UFNyvYXdYXEmrKZisAlt7p5S22eGd+a4Zn/xEKxQN4FlVub2RAEElUIrTDhtYJCnVC40auhcX2BQoj+p7VkFloygrghb6wmj9JsaxijR8J4mYYYXAo+OnKQmOMkTrz9nvHAIl3nYSjvxCRewWyrXy/n+MlcokQ5fzLDmWo4ElpdrGUg/y5KUYR4BJM6Mm8EqD4u/2y0h0G0RCETOPtslydo7ceYu38fCeFJsu7ujOOLs8B4sX+tadfEn0JiyZKk3l6TwKmvol6+DV1krLTPVw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVIzcGRER00xUUlHVUUxRXZQc3NhWTVLYWpqbll4eC84TGhPSm95WkJpbWQ4?=
 =?utf-8?B?RU9IZnhyQy8rM0hhZis0M2NHSittdSswL0VHWk8zTmZVWEc5azA5SDU4RDJ1?=
 =?utf-8?B?aWxKazBCbjRNZElSQ3RIdThDSTRaSVErOXlxeFVpNUxTQ0I3UDg0Kzh1blVX?=
 =?utf-8?B?SC9wM2gyNk0wdUo0S2YrNnVxeFFraHFwOGxWNnR0UFE5NkVLS3hzdWZnRGk1?=
 =?utf-8?B?MG1FOCtPbGFWUVNTMG9wdXhCWGFCU3NvZ0hIWDJabjZLUVM0UDJYTFNMUFB0?=
 =?utf-8?B?bTV3c0xmU01aQktFc2JrNkxJS3ZyZThqK3FPMVBoWXdaaUxraVM1SDdvbXFK?=
 =?utf-8?B?aUlWZ2paS3BOeE5LWmdqcTdLenNCVEttNzErR0U4VGw3eW5Vd1pRYWNGdnFV?=
 =?utf-8?B?N3VhTFRHQlNTRDhNdmZQbEJPTndKS3ZhU1REaFp2NkNUbVBsa2l1M0hSOUV3?=
 =?utf-8?B?THNDQzJRTDVacE4xR1hEZ05mVGdWYWhXMy9yeXlvUlByTUkvakNvTXZKTGht?=
 =?utf-8?B?S0RNNThKRmRNdDZxVXdJZ0RDTXJsYXM2bmVXdmZYd1NzdWNXQVd2L3NaQzJK?=
 =?utf-8?B?L3VncXhYbk1US0F2ODB1cE0xd3g1Nk1yMk5jTkNva1ZCTkJ1UnNBZWR4bHk3?=
 =?utf-8?B?eVFHOHBuVk9jRDJGS2Z6VVArbmRlNWdMTkpwZHI2TDBrZDMvRi93aW9iQytF?=
 =?utf-8?B?bHQ3NENJa1dOWXhsQWJxLy9IODB2UWR3cm9hV2g1MmxxWEdlcExSdTVzeGZn?=
 =?utf-8?B?YnNkS2ErTkFhSW5nTExUYTJCMm10c2FPQ0N2dlE0Ull2cXI5SGtVd3FBQ2Q2?=
 =?utf-8?B?Ri9lelkwdXFWbXRnQks3MjZUc0xxbkxGbUE5QStuVG9VUzRoaGN2VU16ZG1V?=
 =?utf-8?B?K2VCZHhsODdqN1RLZ1RjTzJUd1F5RlNTZzVDa3FIeXc2OEtOTktiWk5ibTMy?=
 =?utf-8?B?ejhrOFFWZWVJeEhkTEt4K0tTdXNFa09nSGhNZ1FjNGd2OU1sVlZnWldOck5h?=
 =?utf-8?B?MlBhSmdNMWpFYmp4TW9mdHRHU3EzVnprOElMRVNEMk40YmNrZEU5YlF2VkNq?=
 =?utf-8?B?cUMrdEhXS1FOTFRKU1lkNEpCNVZLbzRKa2FxekpMQzRIRGIwaFpYbjQzcTQ5?=
 =?utf-8?B?SHR3VlRranRJRVU3SU9sRHlHODFQd0pJNWRacFY4S3NTMnlTMTNzby9pblRm?=
 =?utf-8?B?QTNHSkFEOHpGczR5YzlBNlphdEhDZGE3bmpwdkZPNmEwNUxrb2xCc3VSNWxS?=
 =?utf-8?B?dWlyaHNlZFhBT0xFVWpyblpONUpLR0doV3JMbDd0bnhjVVlBOXlTc1JGNkVT?=
 =?utf-8?B?MHc4WnhSditwWDBSUC83QkZqWUZOUlRaNHdqUGhWQkl2WExSdmpvb0V1eDF3?=
 =?utf-8?B?c1pNejVYSXZZQkhKRGozaFA2WEVhN01NM0hGNTAzWkdJY21QRlF4T09MazVT?=
 =?utf-8?B?Q0wrbGRoaWZsbzd1cllmblpxQ0ZzUm5LSDlRekRVeXY0bE5RZUdGQmc1azJU?=
 =?utf-8?B?WGZVcHcvS00xcDR6emF6c2xqaFNLUU91NGpWN1RFQ2R4TG95U2xGMWxRQnJQ?=
 =?utf-8?B?OFNJOTNScVBUaHEzL1F3bWtiY2R0cElPU0p0RWx5OWV2NGV0Y25xc1hHWjF4?=
 =?utf-8?B?REVDR3FtV29LU0JBenVhc1JqcG1QNlhjN1o2bjdhakRDN1drWEdFUit4Qk43?=
 =?utf-8?B?eFpsYmJSajQyblBWblhkRWVrWnh0SmlhNnhJOXVwaVJqdjE2QUw4RXhwNFh3?=
 =?utf-8?B?TGxZeHhkK3EraDJERTIxNURYeTVuYXJ0NElkU0t2VUU2VXpGdWxmSXh2cGs4?=
 =?utf-8?B?M0lTWER2aWNGK1J4cjdEdmh1UllkZmxJUitxZ3VvTklGOEhqRW53dGw3a1Q2?=
 =?utf-8?B?OWY5NTExVkdPL0JRdWp5Z0JuMTFDOU5aY1JoTmV2MVRkS1JFK0c3KzM1TVRT?=
 =?utf-8?B?dGhNOXZZb2xORm9zU0VrY0pOOWFvSitOaFpIR2V6Wm80Z3NUckJ0V215a1hh?=
 =?utf-8?B?R1RaOE5ZRlE3N2ZOU0F6WTUybWRlZ3BLU2ZBbytJS2dLTTM0d0tEMU4yVXdp?=
 =?utf-8?B?L2pzQ0hReml2MmkrcVlSeW9OUEk5djBkVVk4L2JCREtTV2RsekNtTm8xb3Uv?=
 =?utf-8?B?a3VLR3JROWxMT1VnU05Dd0FrK1dEcFdZMmRxeVd0ZTBUR1dwa0JlbitIb3JX?=
 =?utf-8?B?MVpGYWN3OHI5ajhYcm9rM3RUZVVTZTFIeTVRVnFBclN2SDhNb2FaT3dPNzM1?=
 =?utf-8?B?Yjdza29aUDY5NUgxK0wyU0xCMEFkYm9ZVWVWQ3JqQ3hLcWFQa1U4dE1RZTBn?=
 =?utf-8?Q?3d6mCfED0+onaWM5Xp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e99f5c06-2ac3-4c66-9ba2-08df178806df
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:30.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gm10alTkvIExPZTPwvbPY8qFX9TY0PyNbzxWaueCPAZWB2MBp5aP/SSuBDnveG/R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E4811C0002
X-Rspam-User: 
X-Stat-Signature: yhosc4mg1awy6fikpfc5uwyckaj7duzy
X-HE-Tag: 1789957725-822298
X-HE-Meta: U2FsdGVkX19pwjIiZ8cGvQD4aN5KZ2cQKAuHXSo83O85hexoeLX1/4ktLtJPE6eGqDHn0k62dMm4yfSSSMGhWOguGHqFgLJvqszztQcg9ia0Jc32OoN2rVdEWLW4f0lDU4rXzm+/4iNcdC3/9CIzE6Z2KrTgpojis9aEBhhcbZ8pt3n+4fJzxsxvUgVuyLWBqBr4idADp497swmXu1YLhuqLvFXzOp5Ok0qD/sNsEg8ajZaYfkplO7IHq0uFsGIVChFUmKz8YfTaS2Ik6f273j3veLS8Gx9rwgVQrRsqB9DA9aIoFRRUAGnsO763/+sXMVtSHw4mXfAxYKMXI8eoAy7jzUSeMs/qHLuXTLmGxBz7ycgPaemjCirqeL8ICiv2HAZizU2CYvBmDulMV2k/frBnXvb/6GigtyiJtt/EW5biG+Wa5BjfTSWpRWyLHAnB0rssI3SDRyeQ3caHQjd8Z/UDAj0ajcCGUUfpwSen7vCJ/J9xiktyc/8xGPqRTutp/o/+AEg/J/bUMcKcYqHNSIU36hGfOjtFLPXXhZag5zubXuZQknCsevDFo87qPrQUEp0kIlVNYTYXy/RcAJOV/B2r6zY0BvJkQvf47in/yy05NIkmtIla560+HIXNtT8U2i1RiE81J/1VOSLXHodllE1V+tldZldUgxESpLV/pAzai4cgw2StPJjUqdmg04Y80fvJNMyUFi6eNpEbdFrtdQbPah3J3lFPeHaGCsUDEMtk8EsoCHI8VkR72ta6sSXZEy4lr+bR7QrfXWAjpDdLWEj+Dh/Ib+uYwjUUHzd9KZdjSWspFEz447q4WxdSLuGhMrdxfaEuMM9aeBfDsuJukT+D32SNAnxIR3+mJJd2UB0oNgxF24s9cb0WbLzX9RXISZLHEDS5EWL9R5i+q8jXBUVPugB8nsEq8vKsKwgWP7j74Hg/j/Nck0mZ3Gj+YAi4Stxx95tVF2w/mTqyt+2
 D2zAtZx4
 HsPM0joR8GilqP8zkw343V7uHjmF+HPtp77S0DC+xJsSXXY91gRaUd6hFurLkxqCjzTcU+Ufawa8Cu/EBZz20PAiLeVtmBFHMx1v6KQhBMFYFzcxVLwWF7e89E4vUqa2OxI8hCEhb0I5yqUU+2ykwXVG9f4RhaI+Ac/FD2ZKU6j9itSg9NGPgEF8QCb0wE2gSYSvu+zMVCygBgL5ekk2lVv06yd5mxTo5xmQzsuJgXM0jr5Ud/9zCzR4WSXiKBFCRSZOYyFImD/YSWT7ioI4Ro84XzX1kdadAnaRWlpLduLpvLPFJVen6I89t9P4pH5j0yW+h18aOBm6lDDYc5HpBJcIMug0io5+0MlnOMAA1a6wUU012wy7QFzbz8aCSoPwkAxHdNMZ5/FSlf2P3SSeEuQBqX+XR9JMAPrmsVwdIQroV2CUx8e7CVksrYXYdURYskVBTdl8nAyKAuQ30GrR92qgaBYZW2UktOaCrkrhIxV6xB3ETHUiibHUj4XnKs1o2u87J9tvvqXhPnW6Nuaj+MYCFPgGklqQ/YTOFZK4J0g7UB/m2Uo2S5++Spxg3ou0mvdrEPuuLoFtKjIbTEpm62C+I9oT6e/Gbpo63+rFmzDAyunpug18ZB9BfoieGpo3MAuWYao0P0iyEb1ztk4mJAZd3ptddaOAE2JAn/vGyjykciFOpc51VG+ADUa281fUwvrCS2CxgvhnN4aUqaX2PlMNXpAc4NomLpmQ5PbvauSjBsxoVyN0eA12kYxAyVSrIcu+E
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

Add readahead_folio_last() to achieve the same function without using
folio->private. __readahead_advance() helper shares readahead_control
adjustment code among __readahead_folio(), readahead_folio_last(), and
__readahead_batch() by checking new private member, _forward, of
readahead_control.

It prepares for a future commit that replaces PG_private checks with
!folio->private checks. After switching the checks, erofs's use of
folio->private without bumping folio refcount can cause unexpected
outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
reachable.

No functional change intended.

Assisted-by: LLM
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/erofs/zdata.c        | 13 +++--------
 include/linux/pagemap.h | 60 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e1e25ca0d1904..78fd7d980e957 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
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
-
-	/* traverse in reverse order for best metadata I/O performance */
-	while (head) {
-		folio = head;
-		head = folio_get_private(folio);
 
+	/* traverse from last to first for best metadata I/O performance */
+	while ((folio = readahead_folio_last(rac))) {
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f6..1e3462357aaa4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1415,6 +1415,7 @@ struct readahead_control {
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
+	bool _forward;
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
@@ -1479,18 +1480,29 @@ void page_cache_async_readahead(struct address_space *mapping,
 	page_cache_async_ra(&ractl, folio, req_count);
 }
 
+/*
+ * Adjust readahead_control to ensure next folio comes from
+ * [_index, _index + _nr_pages) afterwards and reset _batch_count.
+ */
+static inline void __readahead_advance(struct readahead_control *rac)
+{
+	if (rac->_forward)
+		rac->_index += rac->_batch_count;
+
+	rac->_nr_pages -= rac->_batch_count;
+	rac->_batch_count = 0;
+}
+
 static inline struct folio *__readahead_folio(struct readahead_control *ractl)
 {
 	struct folio *folio;
 
 	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
-	ractl->_nr_pages -= ractl->_batch_count;
-	ractl->_index += ractl->_batch_count;
+	__readahead_advance(ractl);
+	ractl->_forward = true;
 
-	if (!ractl->_nr_pages) {
-		ractl->_batch_count = 0;
+	if (!ractl->_nr_pages)
 		return NULL;
-	}
 
 	folio = xa_load(&ractl->mapping->i_pages, ractl->_index);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1516,6 +1528,39 @@ static inline struct folio *readahead_folio(struct readahead_control *ractl)
 	return folio;
 }
 
+/**
+ * readahead_folio_last - Get the next folio to read, from the tail.
+ * @ractl: The current readahead request.
+ *
+ * Like readahead_folio(), but walks the range back-to-front. The folio is
+ * returned locked with its refcount dropped; the caller unlocks it once I/O
+ * completes. Compound folios are returned once, at their head index.
+ *
+ * Context: The folio is locked.
+ * Return: A pointer to the next folio, or %NULL when done.
+ */
+static inline struct folio *readahead_folio_last(struct readahead_control *ractl)
+{
+	struct folio *folio;
+
+	/* Drop the previously returned batch from the remaining range. */
+	__readahead_advance(ractl);
+	ractl->_forward = false;
+
+	if (!ractl->_nr_pages)
+		return NULL;
+
+	/* xa_load() follows sibling entries, so a tail index returns the head */
+	folio = xa_load(&ractl->mapping->i_pages,
+			ractl->_index + ractl->_nr_pages - 1);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ractl->_batch_count = folio_nr_pages(folio);
+
+	folio_put(folio);
+	return folio;
+}
+
 static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		struct page **array, unsigned int array_sz)
 {
@@ -1524,9 +1569,8 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
 	struct folio *folio;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
-	rac->_nr_pages -= rac->_batch_count;
-	rac->_index += rac->_batch_count;
-	rac->_batch_count = 0;
+	__readahead_advance(rac);
+	rac->_forward = true;
 
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();

-- 
2.53.0


