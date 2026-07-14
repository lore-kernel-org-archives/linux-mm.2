Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A541BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D556B0096; Mon, 13 Jul 2026 22:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834ED6B0098; Mon, 13 Jul 2026 22:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6880B6B00A4; Mon, 13 Jul 2026 22:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED336B0096
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:13:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BADBA01DF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:13:01 +0000 (UTC)
X-FDA: 84985759362.23.7C9EFBC
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011068.outbound.protection.outlook.com [52.101.52.68])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62429180002;
	Tue, 14 Jul 2026 02:12:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dpqR7s6d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783995178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OzpVzsEzrOi+1R1llMeLuQ4v6ao9CWF+gNb6KB4WaY=;
	b=oTLYVrz6ii1fuSmtKC0i4Y7WYORzOFOfR7QlriPYzLUPrBD/PPBWFz10bsWCfOYgRkTpVg
	FLb9JelNRciYhlnWO89WnFCwl7laU0pYkGArckE6PFy4zXUls0EpLHB+9Di3WxjqwgnJ0Y
	S95Rz4Xdz0U3ldSspzsvbuiZYK/qIvE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dpqR7s6d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783995178;
	b=LSbz5lDtMPy2B4DFm5qbhucUUbA8THPDJJGvlGa7PnCEp8S7pMQDSytvQlKx23lVLEZzA+
	VkOxb4ik1ZvQ4bMHU2AMBZGzcc4MCXuvdU/EF83WrtlKU8tpRXnJTVEt5bYMDBgDlpSA1x
	kcWDuibkV2g+nrikyosP/2kv3AErf6M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gjLwAoUT6HtM7EILc+3qrfgdSyK9R6PI0CnVoAyaP0oqNt8QJSH/FNBBZZtx9AsDQjBUiN0ty9+9Ma/g7UkY6nFn7pjxLsAjd/DXk8ouyQUpHW7iJyCbTDuXNlU+OaXoxf1UsTo9dGHCeoCMib0mB0J9hBjWv8HZkjtVWBTeVSCdbDrREThu5FeiWL7l0s4QR3UNmPRPa97mnKRi+C2uWh53qU69tv/8T+VUO2BwPKfW6jqH5vlUI3RF05DjVPZKVE8lSVL/qfjrUW1dblJfb0p+N1rkQXvJ+eoPsQlYTSquNjCGoTMEYXGqCGa7k0NlpWtNZi7iu1qp/mVwCLaQQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/OzpVzsEzrOi+1R1llMeLuQ4v6ao9CWF+gNb6KB4WaY=;
 b=pGQ/3zRvW+k1YV+u121T+4R6j3lXB6W14AMTs1azzQd4r7vAicaHEJbf1XqKAp32X1eVc1yMpsgKaZJUVdp9MU5BENOnkg1f+lIyzphs/8nVPUtT+M0SsxCLLrFILx4ZFJXZDCXNDXS0D2mGuIvTLwWheAtO95TzZHjNRozpahZLitlIKcad2qnukBGW4ZevC6DxGYIokIiHAQy8kYPusmcO8tc9myliDvG3RgzGtPHgcNAnOF04CW5TtB8Hov5b74SPYpxAH0bHdX4lSllpEe03oR3U88bSv9JPFu+v5m7/Gb48KsLRGPPEq02pQcDIarmJgoVEcJrWUmUjhIackA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OzpVzsEzrOi+1R1llMeLuQ4v6ao9CWF+gNb6KB4WaY=;
 b=dpqR7s6dkKLuBUpq62AVf79g6VjzRgkarX2aWG9eDa9BwEWpdtEaiuuYBSRvB32x4CB7TCpPI53P7xpHFt/DT+JhQT9X+MJV2b8ikE/TpLk2Ymdcmt8jfVoZDpb7KrTn3KINw8yF+fgxn4kMs3rVj8G+Tbq+a0gDVCGAkjHrVd4RkmdXq/m3oLdNGdWnyqEhKvxEwdHnk+ARCz+gnXwVRI3KTjLYNEN/u4R9hqorBvqq51RCkCtJJmRYqxH/TwpyogG7ojf8fkGUtogODlyqiPy9c7Xd9YPFL4fob8tVdZ32kC6Bnco/3hKkRmMBlQDJOpkb9V2RpQxSMjpT9hj4ag==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM3PR12MB9392.namprd12.prod.outlook.com (2603:10b6:0:44::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18; Tue, 14 Jul 2026 02:12:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Tue, 14 Jul 2026
 02:12:52 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 22:12:52 -0400
Message-Id: <DJXXIBZJUYX7.BUUBV4PUAVKX@nvidia.com>
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 <linux-mm@kvack.org>, <owner-linux-mm@kvack.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Hao Zhang"
 <hao_zhang_kdev@163.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260710071344.GA106129@zh-pc> <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215> <alEg6ZPc-ao7s6o6@thinkstation>
In-Reply-To: <alEg6ZPc-ao7s6o6@thinkstation>
X-ClientProxiedBy: MN2PR22CA0020.namprd22.prod.outlook.com
 (2603:10b6:208:238::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM3PR12MB9392:EE_
X-MS-Office365-Filtering-Correlation-Id: ae395958-c6fa-4e19-32d9-08dee14d692a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|11063799006|5023799004|4143699003|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JI6nR9/WavkjD5mpi8ICdmFM10RRhKWDYAgyyNQfsu8Yj07IDRft26xYqR1ynDqN3NmJUFyDZA/jDnx22RwmdSbrVvD3FZK12Ct0VZs9DhhQPQYKexHFz7XuhaM9gvAJELDtGGYM26n6ZD/BbaeCUOjseme04esoPKR1NiUDGItK6iizxbtrkeV6scYLWMJmxxEvbE4a0se/bbHEYya09NSeedAuJyGo3mIilEto4/7YXpReeK3FHXoKdJqmOjotGHC0gzCj56kEC1JPAyKVezbGq06zIEeLX/n4kDLnXrcSFWy8L/62BDjX3O9sym6G44fJzPRrzulgMXYrZxR808lxm9RYsKJWR0eRis2bk7SMF5eXHK149003uULQvXS1tNq2qcmUq46bDf3pSFYu7KyuIVh1dD64q4CJjRB3u5pJaFSnmfV6RlKtZ5lfew+JgH+Q7y7c3ur2w1Qz+O5JApWKEdD0s4wsdjBA592XIptLtU8JfTLZkwspBBypUpkTCpXczVTfI8GaBStK2CzsYj3Y5PIuuQHt7Gnv7HcNAdivDcCpxNo4r7S8o8wYRZvfd125YofyH5TSzJgf4dcOzjC9AOvwyH/DNZdorLiqXBo7RHJTJqtC/2IZO5HpOYdOf/lY5iPUDyaKDI9H7Kt1BPjWw/qvf5ek2F4SKHdITps=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(11063799006)(5023799004)(4143699003)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkRxNlNzN2ZpN1M1VFVTcVlKeENTMURlN3ZlR3VCK1c5Q2U2QU00SlMzTjNU?=
 =?utf-8?B?REpKOWVmMXQzR3dpZ2lHQUlXNTdMUFFSQVJVT29ETHA0Kzgzck5ldzluaCtq?=
 =?utf-8?B?UmJsbkFPNDJlL2s5b0lFU3BJYk1DbDdaeGdPc0tCOFFNa0VOVkx4b3ZiclVV?=
 =?utf-8?B?SnZEeDBxdUFBbVNVQzBaK004MHNKaFB4R2JKTmtoOTRGM3ppRkk1ODdjY0Ez?=
 =?utf-8?B?cFJLSlJXVzAwT0lZRVBSdEp6L01QNlZNNTVXWTNVWFJjS3VMN1NSVnVwYUpO?=
 =?utf-8?B?MWY2OGhPWVhtR3NRVnovcGFwNzhadktFaEFMVWxvMnZGdUgvVlpYU0pIZmtV?=
 =?utf-8?B?SE1KcXY2SzE5Z1E5ZHFMdnpTVUVvRGVQVkhwcHl1endtS1VuMDFVem5NeHNB?=
 =?utf-8?B?NjdONTdlS3g0UHkySCtoWW1nejN4Y1prblRKVU5YYzg5RmV1L2hUUHk0SlNF?=
 =?utf-8?B?V0VRWHdKa3FGVGcvVXZxL2FNQ0lsVmdJSnNMSUF0bHY5NDRsS1VORTRFQ3lP?=
 =?utf-8?B?dFFZOUVTc2ZRT1VCNkNTOVRFYjNsNzd3T09BMUNUeEh0SEdwcTFHUk5jcVl0?=
 =?utf-8?B?TFNvMjRSRjZQZWZZVm84N3Y1d3VMdSsweGVQZ1RRQUxENlJ2Zy9nNWtteTF6?=
 =?utf-8?B?NnJ3cEw3ZlBidHgraVo1dzNoekFRM2VDRkRLOEFjWlRJdHRXVXM4UVBoMzVY?=
 =?utf-8?B?anRxYzhHS2poM3NvSm5lNThjRHFXbzdmQnRTQnU5ejd0dnNLWStRMUs5RWJp?=
 =?utf-8?B?VmNoVlVTd0ZDOG8zaEEzZ3ZRNWppOGRvVldkOXpWM3NhQVhWVUFvSkdhais1?=
 =?utf-8?B?NERrUW9FQjg0RGZBZVZYTnp1d2VNVm1aNDlkMzQrRnlXNFhmanB0SXZlR002?=
 =?utf-8?B?VjV2R3Z0Tkd4a01PK05tcCthZHpENm5uS21aSyt3djJUOUVHNEc5YitOeXFj?=
 =?utf-8?B?L2lsTGNBOTdYd0svZ2pyaGZVLzh3UWoxUHJRb1NUZnJkZmFpNHJLZHV4U2Mx?=
 =?utf-8?B?dGpMdkFHVEk3UTkwaXR3RWFBTHpIbHB2UUhsdEdERW0vVzBoOERmeENKVG1Z?=
 =?utf-8?B?b0pSbnBKVUlnbFVZOXFnbWFxc3M0Mi9OMHAxNmZtLzM3eFJSTUpXcGV1ZzB5?=
 =?utf-8?B?WXhnWjdMTE5RSzRBKzVmMHhyVmp2cHQrZy90VGJBSGVOQnlpeWVXaUxwNkxv?=
 =?utf-8?B?dzJHZGdGWm5ZNllnTWxoSUd3czFVWFlmNTcxSnBhZEtUY0lPNWkxeG1MSFJ0?=
 =?utf-8?B?cnlLd3k0ZzZ6LzhSTlpDOGN3Szl3OUtSSEVXaFB5M1AxRjVjcm9nYW1rSFBH?=
 =?utf-8?B?aiswNzYxMVhhRm9HQVF0cURkTjJVa21CUUJMRUZNN09WY2sxODhveUE1SDlI?=
 =?utf-8?B?dmQ1ckxmL3JocGVyeTFHa29tdW5leDc2S2NmbXhSd0hjVGd4ODBWSnVmYVM4?=
 =?utf-8?B?L21qK0lrRFNnQ3Q0L3A5SVBLNnErK2xvVUJDbEpPRFUzWnUzSXFTRzdwQXJ2?=
 =?utf-8?B?cjBzNDBCMVNsWG10aFc4WXU4MUdBVFhHT3IreEdJQmw0MXBDOHJMUFNJMVBw?=
 =?utf-8?B?OGJNSnF0Y2I5WExxeElXdm53VnN3a0VpT28rKzcvVWV5UXp6S0h4QlVOc3JN?=
 =?utf-8?B?S241YjFkNyt5eVMzb1BpeEJrQ1B2a1R2TEgzeDVjU1JvaW1vd1dZcHE2blFG?=
 =?utf-8?B?eFBIR085VVF1d1czMnI2N3Z1UzNtazZPV3VRUDJKZDhjR0g3T2J6WnRtSk5q?=
 =?utf-8?B?UGNmeVJnSklJVzRMQ1J0YWQreVp3Yng0M084QkVaQnMxQlZsT3FTRzJ1VFdN?=
 =?utf-8?B?Q0NQRm50ajRwM3hUemxnbWtuWDZROTgramxyb1VQNkdxdStZRGo1bnBYTlVG?=
 =?utf-8?B?QWdtQzBGL0IveWtBdmtBQ1NlVWdzeVZBL015YyttdHViM0tMY0k1blZpeDk0?=
 =?utf-8?B?ZHRKdU9yK1hKRUR3alpKcE9Zdy9IL1d5MURQMHk5VjRiSXJWdkNGNDM5dm9m?=
 =?utf-8?B?MnpHU0hDZit6WGJDaURqbFR3KzgzbHpGS0ZvQ3ZLaE1odEM3RHQvaFZIVmtU?=
 =?utf-8?B?RytrcndhbmdscDNPZ1FoWEdzZWVvUUR2OG16M0NveUNxVCt2YlZDU09mc0M1?=
 =?utf-8?B?b24zMWRVcVZaT3diSXBJb3dvc2VOSDdlMUFmZU8rbHZjVmQwdk80d3VEbUp5?=
 =?utf-8?B?Q1pQTndRQnhFbXYwWVAvRFpwQWNBOUxRbmhDRzJZK1AyTnQ0eDgzSFNzSXV3?=
 =?utf-8?B?V1hFNUo5U1ZoUkk4ZnZxZ3l2ZUtYVUV3Y3pRZDU2V3R1L3hJL1JBQTgxMHFJ?=
 =?utf-8?Q?YhjmMYArxe58tLn7oC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae395958-c6fa-4e19-32d9-08dee14d692a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 02:12:52.7656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AKrni3l6IVPuN5c0OSNgX+Q5e7jZeKGdrSfuZ7BDJ4SdINHICN8x1y9FSPfOFU8m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9392
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62429180002
X-Stat-Signature: if4pe17zn6uicja9e6ks6mxtbqhg6mws
X-HE-Tag: 1783995178-82510
X-HE-Meta: U2FsdGVkX19Cyiz3IEtC7WK6V35aXT7DIK9ftnX11nEpPUmohxgYfzh7f9gOtuchecsKAuRU2tNV3SgNXe4uDiY/jEd2vi0/Hl+6r9dbB9QbKbIE8ZAaeNOsGrnyb7n8hSSIb0EMoYBxPhEQE2j8aoJTjeBLIEs1qWpS5iWSj5fhIiV1PSVA81tK/vs/hEK/RGAqci7sF0LAZYaQG1qi+YNXwaDQz3W7OmfDbHJEA4EPgvGnKIHAC6Of7GYECeHfHjKicd9o/g+ReVUV0T7ldAsz/I46eIjoQELU6P9H/1zjnCbuabivQuzK0q/y7Qz8tZgnIkc5VIC1oSNif5m+vp0yqUVEtst9yO15QKGObhYW14fXB+VNqfOPv/FLmf170ZDwVTdHiLMKdouFtpU8Wugti5N6RCLp7XlvOq8E9T2nxy7psa2mNK0j757Rr+6pANWO3UFYxsTiT+YcjEJ6/9WT2HWhWdUX5Y+fzEFpntFnI8YeYKw66p1FXOO3X71vN27RWJm5rf/G68F+j3eVlXwZ03fKs/N6Veo5Wxl2BCqRzDQZttKvnvB9AvJTduAoHy2dLh1kLvDxjwDDefdiOx33JhHRq0khLAKWG9I/uW5iAG6GqTehT+82u4SHuNHYFFjYw7Ax5uRDzdJTmmCBd93NBekprGrxnmPhpMb7Qit+J52DMYyiidp9tnE0RFmdgf9g5jZxBwBfM+bCDlOx+gwMCA5bF32g4Y52H4PiVZWJMu4cvbWDNKHX9O24+LyeI5A39mgIGiqIzFqvGYJZKLO8S/fmUkp3V4wWeDhdexH87T6QC0JIFIMxHgB5CSZNLLUIFdH8wejgSjLrMHAeDIPdrfTgULpDsEbR93wCPaph8lGXd9Y7tXa9f5zoVSNrE6vi+sIJIONAzdRkvlHa76DHZP/Kyi8gZ1iYMNOjJQrhgyrLos8sLZ1WxtcXWVNYzfDxldgOPF4SV9tRhWB
 7j4ioNhF
 a+N/1g21W4f2QC1GxtFe8ri0yxm9W6Xnr7DZ7RsZKgRpKfRsogOIBBI6vFtqrrAPIgpY3XrbXPNJBFwbjyF7Ci1pj7ZkA/Nj1nlBMgF3/6MpRaB2jECsXSuv8qxW+oEs3c1xNoAosP+LkPfV9cZUQwCrYCWUU5BnyVAaSZJivPt5sqz5yT7UU4ZSNTjwrTfUZQ0P9G2/ziuzTCBZ1YrZzJAqyMPuQmfdpC4sQULbD8xvfR+ZFG3dyU5bHsXPSbezsFdh9n6zOrcZOxMK5byBxrGuTffdJVqGzQ59R1qSqt0YLUYBySq0PmxYz45ixLT6/tsMw+GO07xUkFGgTvoU+jBo9wJ2tS1bZJXPxTsSo40jkJJ3eHmzI4bAUpzjT9lPVE/FfbaDZsCRu5l1vQHimvBiezoxQ9f9JXyjnEqSbFfy1NmALYe/J6yslM8rCRPWnbSmPn5qiCGPXJXxqju58Y+VDK3L/laK0ObBbCanygPzUt7IOSfO9Kq+5n9tNAmAoJFwgzCQB6pjH52CLPb/D8tiGxJc3bOt4qiH9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 10, 2026 at 1:17 PM EDT, Kiryl Shutsemau wrote:
> On Fri, Jul 10, 2026 at 11:56:00PM +0800, Hao Zhang wrote:
>> On Fri, Jul 10, 2026, Kiryl Shutsemau wrote:
>> > On Fri, Jul 10, 2026 at 03:13:44PM +0800, Hao Zhang wrote:
>> > > From: Hao Zhang <zhanghao1@kylinos.cn>
>> > > Date: Thu, 9 Jul 2026 16:30:00 +0800
>> > >=20
>> > > __folio_split() takes mapping->i_mmap_rwsem while unmapping and
>> > > splitting a file-backed large folio. The lock is currently released
>> > > only after the split folios that are not returned locked to the call=
er
>> > > have been unlocked and put.
>> > >=20
>> > > That leaves a lifetime hole. Once the split folios are unlocked and
>> > > their references are dropped, inode eviction can make progress throu=
gh
>> > > the final page-cache truncation path. After the folios are removed f=
rom
>> > > the page cache and the last inode reference is dropped, the inode th=
at
>> > > embeds the address_space can be freed after an RCU grace period. A l=
ater
>> > > i_mmap_unlock_read(mapping) then dereferences mapping->i_mmap_rwsem
>> > > from freed memory.
>> > >=20
>> > > A possible race is:
>> > >=20
>> > >   CPU0                                    CPU1
>> > >   __folio_split()
>> > >     i_mmap_lock_read(mapping)
>> > >     ...
>> > >     remap_page()
>> > >     folio_unlock(new_folio)
>> > >     free_folio_and_swap_cache(new_folio)
>> > >                                           evict inode
>> > >                                           truncate_inode_pages_final=
()
>> > >                                           destroy_inode()
>> > >                                           call_rcu()
>> > >                                           RCU callback frees inode
>> > >     i_mmap_unlock_read(mapping)
>> > >=20
>> > > Release mapping->i_mmap_rwsem after the page-cache and reverse-mappi=
ng
>> > > work has completed, but before unlocking and putting any of the spli=
t
>> > > folios. Clear the local mapping pointer after the early unlock so th=
e
>> > > common exit path does not unlock it a second time.
>> >=20
>> > I don't buy this analysis. We still have the lock_at page which is loc=
ked
>> > and still in the page cache. Inode eviction cannot complete past
>> > truncate_inode_pages_final() until it is unlocked, which only happens
>> > after __folio_split() has released i_mmap_rwsem.
>> >=20
>> > One possible path how this can be hit is if lock_at ends up in an
>> > after-split folio beyond EOF and __folio_freeze_and_split_unmapped()
>> > removes it from the page cache. Note the drop loop starts at
>> > folio_next(folio), so this requires splitting at a tail page (e.g.
>> > memory-failure) racing with truncate.
>> >=20
>> > But that's not what your analysis claims. Please share the actual cras=
h
>> > reports. Let's get to the bottom of the situation before changing the
>> > code.
>> >=20
>> > --=20
>> >   Kiryl Shutsemau / Kirill A. Shutemov
>> >
>>=20
>> Memory failure: 0x5a6a7: recovery action for clean LRU page: Recovered
>> Injecting memory failure for pfn 0x81bfe at process virtual address 0x20=
0000ffe000
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790 data/linux/kern=
el/locking/rwsem.c:1353
>> Read of size 8 at addr ffff88800b81c5e8 by task syz.2.11034/45874
>>=20
>> CPU: 0 UID: 0 PID: 45874 Comm: syz.2.11034 Not tainted 7.0.0-rc3base+ #6=
2 PREEMPT(full)
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0=
-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>> Call Trace:
>>  <TASK>
>>  __dump_stack data/linux/lib/dump_stack.c:94 [inline]
>>  dump_stack_lvl+0xbe/0x130 data/linux/lib/dump_stack.c:120
>>  print_address_description data/linux/mm/kasan/report.c:378 [inline]
>>  print_report+0xd1/0x660 data/linux/mm/kasan/report.c:482
>>  kasan_report+0xec/0x130 data/linux/mm/kasan/report.c:595
>>  __asan_report_load8_noabort+0x14/0x30 data/linux/mm/kasan/report_generi=
c.c:381
>>  __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
>>  up_read+0x22/0x30 data/linux/kernel/locking/rwsem.c:1633
>>  i_mmap_unlock_read data/linux/include/linux/fs.h:537 [inline]
>>  __folio_split+0x732/0x1640 data/linux/mm/huge_memory.c:4100
>>  __split_huge_page_to_list_to_order+0x7b/0x140 data/linux/mm/huge_memory=
.c:4203
>>  split_huge_page_to_list_to_order data/linux/include/linux/huge_mm.h:385=
 [inline]
>>  split_huge_page_to_order data/linux/include/linux/huge_mm.h:389 [inline=
]
>>  try_to_split_thp_page+0xab/0x390 data/linux/mm/memory-failure.c:1675
>>  memory_failure+0x1394/0x26e0 data/linux/mm/memory-failure.c:2470
>>  madvise_inject_error data/linux/mm/madvise.c:1487 [inline]
>>  madvise_do_behavior+0x4ae/0x8a0 data/linux/mm/madvise.c:1925
>>  do_madvise+0x162/0x230 data/linux/mm/madvise.c:2028
>>  __do_sys_madvise data/linux/mm/madvise.c:2037 [inline]
>>  __se_sys_madvise data/linux/mm/madvise.c:2035 [inline]
>>  __x64_sys_madvise+0xae/0x120 data/linux/mm/madvise.c:2035
>>  x64_sys_call+0x1bed/0x25e0 data/linux/arch/x86/include/generated/asm/sy=
scalls_64.h:29
>>  do_syscall_x64 data/linux/arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xe2/0x14e0 data/linux/arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> ...
>
>> Memory failure: 0x81bfe: recovery action for already truncated LRU page:=
 Ignored
>
> This log line confirms my suspicion.
>
> The UAF fires at i_mmap_unlock_read() while try_to_split_thp_page()
> still holds the poisoned page locked. For the inode to be freed at that
> point, eviction must have completed truncation, which is impossible
> while a locked folio remains in the page cache. So the after-split folio
> containing lock_at was no longer in the page cache =E2=80=94 and the only=
 way to
> remove a locked folio is the split itself: the new_folio->index >=3D end
> drop in __folio_freeze_and_split_unmapped(). It requires lock_at to be a
> tail page, which is what memory-failure passes.
>
>         CPU0                                    CPU1
>   i_mmap_lock_read(mapping)
>   __folio_freeze_and_split_unmapped()
>     __filemap_remove_folio(lock_at)   <-- beyond EOF: leaves cache, stays=
 LOCKED
>
>   /* no locked folio pins the inode */
>                                         evict()
>                                           truncate_inode_pages_final()  /=
* nothing to block on */
>                                           call_rcu() -> free inode
>
>   i_mmap_unlock_read(mapping)          <-- UAF: rwsem in freed inode
>
> Your fix moves i_mmap_unlock_read() out of the window, but I don't think
> it is complete: shmem_uncharge(mapping->host) a few lines up also touches
> the inode, and its nr_shmem_dropped guard is exactly the beyond-EOF drop
> that triggers this. So it is in the same freed window; the patch just
> relocates the one dereference KASAN caught.

I was discussing this issue with Codex after I saw Kriyl's patch and the
iput() issue raised by Sashiko[1]. Hao's patch might be still valid for
shmem_uncharge(), since all after-split folios are locked at
shmem_uncharge() and prevents inode from going away. So the rule is no
mapping/inode dereferences after the after-split folios unlock loop
begins.

But let me know if I miss anything. Thanks.

[1]
https://sashiko.dev/#/patchset/20260713170915.239819-1-kirill@shutemov.name
>
> This is a lifetime problem, not a lock-ordering one: __folio_split()
> relies on the caller's locked folio in the page cache to keep the inode
> alive, then removes that very folio. I'd rather fix it by pinning the
> inode explicitly -- igrab(mapping->host) up front, so the inode is
> alive), iput() after i_mmap_unlock_read(). That covers shmem_uncharge()
> and the rwsem both, and won't regress if someone adds another mapping
> deref later.
>
> See the patch below. Untested.
>
> Any opinions?
>
> Hao, could you give it a try?
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..9bfa3a879453 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3982,6 +3982,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  	bool is_anon =3D folio_test_anon(folio);
>  	struct address_space *mapping =3D NULL;
>  	struct anon_vma *anon_vma =3D NULL;
> +	struct inode *inode =3D NULL;
>  	int old_order =3D folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped =3D 0;
> @@ -4053,6 +4054,20 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>  		}
> =20
>  		anon_vma =3D NULL;
> +
> +		/*
> +		 * The locked @lock_at folio keeps the inode alive: eviction
> +		 * cannot remove it from the page cache while it is locked. But
> +		 * the split drops it if it lies beyond EOF, after which we
> +		 * still touch @mapping (shmem_uncharge(), i_mmap_unlock_read()).
> +		 * Hold an inode reference across the split to be safe.
> +		 */
> +		inode =3D igrab(mapping->host);
> +		if (!inode) {
> +			/* Inode is being evicted; nothing to split. */
> +			ret =3D -EBUSY;
> +			goto out;
> +		}
>  		i_mmap_lock_read(mapping);
> =20
>  		/*
> @@ -4135,6 +4150,8 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  	}
>  	if (mapping)
>  		i_mmap_unlock_read(mapping);
> +	if (inode)
> +		iput(inode);
>  out:
>  	xas_destroy(&xas);
>  	if (is_pmd_order(old_order))


--=20
Best Regards,
Yan, Zi


