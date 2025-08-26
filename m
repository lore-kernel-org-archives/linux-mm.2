Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477AECA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979E18E00DB; Tue, 26 Aug 2025 09:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952318E00D9; Tue, 26 Aug 2025 09:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DAE8E00DB; Tue, 26 Aug 2025 09:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 641F58E00D9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:26:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D6DB1DE634
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:26:49 +0000 (UTC)
X-FDA: 83818983738.13.AD82BD9
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4DE49A0009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:26:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ffJyHWHL;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756214806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdz2FINpHJeY9rRJlcZjM6Gh4aOf/CDvhXRdDUF9G3c=;
	b=Ihhgv/H30+aKuTvqxDRxc+n+AdVLCVSUj3hrMkKCyJA09nXXEwQWJzT311bYH5HFv5o9yw
	HUA1/eVZCNqVs+azLaPUR/aTpDd1x1funjwU+nMIhPpRuHmlsaGhUPSyDIzrlXR+OvXfDL
	pd/aWnrPzwWpsSxpkSI3zZB6UFiwypE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ffJyHWHL;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756214806; a=rsa-sha256;
	cv=pass;
	b=eUAOTY/v5bhc/0I5GtLlY+o6oCue5Ukl/zIVQ6MD8Zy5w8TBPw6ImGaS4ghN8YObdvsU0c
	FZeltjPqbLKAd1oJtjR3ptA0K8DicnjBp65plYl2nrq9LY2CDbsgjaQsYeYWDI5tCSjm0p
	m8ojnmZcyWW4vBYk6z4KHmuozLhDXkk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rJ7IAkjh5AAajNX2uaQyAbvnltSGY7Sf83r0Y4RSqvynFRJc9kzeFKqnaCC/J9AEQwefyrFMqE3tBZW43dh7XH8N5x3QukkGa9elhJwx61BkbWqTB16Kdt1u+L1hBy5uQR0MlsnNn22cgneFU24TsQQ4gzgu2a/XbAEu6vtqsRN12yDW50n+41Gh+0kxz93EXfoEpHE1f5AwKKkroIw3BGKsCmUuaxn1RF4wirAhukXkXqnS1t1OZgiltqLJZ020M2Z3CY8to5PGV8X6quSxm6ZnD90MZq8OvYrPKxvguPV88OwZaX+QiWVWdLVelO4PgylURaA9jMWE0bsPN86tZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdz2FINpHJeY9rRJlcZjM6Gh4aOf/CDvhXRdDUF9G3c=;
 b=eb+9rDute4GBmu+GdXhr7TtmsSRdQ16U9+FQUsYnRdqafxAq05rp7nJaCes6dL4sgnZXbd0q6van7VW0TSgL5p4u56lRSzbQfVaWvuFnL2HVlIUcL8+bUn+RQts90aYiTHR4iJGW1Qw1U+fuMJaPBOh0LLY6jnYFGaz/dfd9obqdCXi52rBx5TqtXvJhlS1G0NOC2cTv7dVqK6GFfHhAGnC/gwT9UTQ730s5HGkjPXTGqpJIPiKfImTWSRtc7j93WE/iA2kz5ROYbZoLMPMWZWiHn9jN46ND04YjxAt8Q3gJMP/LhaJDuGbhKNIWaV4W+QbJN6b+iyj4hCTsKhfFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdz2FINpHJeY9rRJlcZjM6Gh4aOf/CDvhXRdDUF9G3c=;
 b=ffJyHWHL7JAXMbT9nCuc4+Z8L76WeCgaDUQ1EC+FHYF/fN2u3SIFgN+ro4qRLM8/2nx1SEIracm8xujT9leegqN9kwDSzk/ofMm63VFLpQyOT0y9nWO/LORQmjfiHHmFvEPy+9nqZykiIngZStOomiiR5Xv/WeEqUigVv0Qs7uoi8LzrO2afZrDbLPfIZF6d5vZSFXq6hA8Z3idWMpTA0H2vLQHtzJF4NtQFfZwHR/ShW5Jqr2vI/Dq/FZF5XHY/welHKVJlY1TfEPM1pSQSTVTCTvVpypk5w9XSlWv4Kzj6I06389J5A6PAFi4tdy5W/gQYtX9JMotbPh4oQ6hx2Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW6PR12MB8915.namprd12.prod.outlook.com (2603:10b6:303:23e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 13:26:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 13:26:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 vbabka@suse.cz, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better
 reading
Date: Tue, 26 Aug 2025 09:26:41 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <8BB17567-9E40-41AC-8343-F8A468F1155A@nvidia.com>
In-Reply-To: <20250826093148.30190-2-richard.weiyang@gmail.com>
References: <20250826093148.30190-1-richard.weiyang@gmail.com>
 <20250826093148.30190-2-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0506.namprd03.prod.outlook.com
 (2603:10b6:408:130::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW6PR12MB8915:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e852c79-bf77-458f-3f9e-08dde4a43292
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PutYGbZ5eBMnBFqnd4owOM4GA61GeC9TRIqqZss96n04RSc8FALxjoPjKh/M?=
 =?us-ascii?Q?gbVllABwIuXjkiYUEhX2/h4CpAt/zx1MaSMUSeNkQBB8X5P+cLIKD5WxNjJf?=
 =?us-ascii?Q?wv68MSQb9d8RG9mZqYptb3xkEtw45FFnZU7+a/Mq4nxSUS0YOIMTzHrypH57?=
 =?us-ascii?Q?CQeFBrULGXqDjMS3OsrsViH3ev0MLsCtS85ono08HUiQKRSZCrkVQBEYlHuh?=
 =?us-ascii?Q?QQiar6vlAnyIegEPKrJgxU2/FkHM7kPMy/0QFRVU1W7Eavcf/DDVNby6o3+c?=
 =?us-ascii?Q?bcECYgprcbI1wm99Qr4eBOOb2Y+Z7ejRoHQJwz4x6Hgjy2D/A4tnEzvwya6W?=
 =?us-ascii?Q?QMMKASvo3LDVY96tFoMe0iQG1hiZOPGwvYScaWDvLS8NvyIEh46KsR1ZEaeR?=
 =?us-ascii?Q?pqgFPgf9/aUyzNCuqxp2D11gJ93PS9iumEqEJ5Sz6TWaAIHChW1i6uj8ORB7?=
 =?us-ascii?Q?TwxrOlRoch3gIjmN+w7WBFkI8BL/w+61SXITWIhqtiaYixtPglp6yWN/iFZX?=
 =?us-ascii?Q?lSAbfYz8u29QTbNIP4Q3DtgxfdOt9RqfTVjcXxDWSGaQlANfc4IPcv5rqLiy?=
 =?us-ascii?Q?h7u7GcwRJltazuYBOxKKH/nE1Nn514DkgIJ/K3zSnI2smQRazJiKX6D97u7C?=
 =?us-ascii?Q?3l9j6L0U4PqbO+lwkypO7AQn5NDaUNtNo+Fwhg3FYFrSFtM+liwy7WnlmRK1?=
 =?us-ascii?Q?WJpAXk6byF/rmgKHTytNznOvI5elXAB2CAZsJmh/f2rKgMee+HaH7015DuA+?=
 =?us-ascii?Q?R20TKFGN7NQztyGzb2wx1dttorUHuuRLZU10wRl2S6sPxMqP6/qLGjnalKvI?=
 =?us-ascii?Q?ykR9X4Bc3xCWadBJaZAv0/bKUUgeRvGWBSJpV43Gpv1C68vgULWoWVgE2A/A?=
 =?us-ascii?Q?tDcLO1udakFGMcb4XdrigiXsmR+OBNK80OG+0yr7UK6VPlgSZtlziJihfHiG?=
 =?us-ascii?Q?HYDG4gZ3ZP7mL6sQw7D3G004RdeMmI7nL/5lVe92bUtCfgy5LV3of3ZdxLsU?=
 =?us-ascii?Q?NO58GXj1SiOVlaWO4DWR9/Ciz8lRwjgfBIBHgSrRMQywXkMdHSyP0curCjy3?=
 =?us-ascii?Q?dkXrri0MKtESxQIfJXwui6Hk7XXXHqIJKRrqi189i1MCjPmAB2AepdkqR/aC?=
 =?us-ascii?Q?1UYWgy03rULXzRbeQ85TCWQqmxbMtAZuphobqGYYTsrFIUF5S69nmUFsqyGV?=
 =?us-ascii?Q?iDVqEZCJUhy3phi4c54kcnoWaR0FJaxLKR2cMK4H0EZdDUi+OrSqVlZ0ivEK?=
 =?us-ascii?Q?Avq8WEdz+uMf4ERCfg7zcDGLP6TPEdJhqihnreIhes3LaiQWSTrenHHOrB5m?=
 =?us-ascii?Q?8U6NTnL6LFWqzlgbJuK93CnfnkhuJ8CpaOYpgwksDoMGGoTcfWHmK/UCkpQr?=
 =?us-ascii?Q?W/vD0hKF7kY/mij56j9DeP6iXTqarbuCJH3uzvaIPX1dGxGeHLWzvLBM7b7O?=
 =?us-ascii?Q?nh9IyQJMwXE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mT3UnyshkajBoXKUI/e8ozcsXs+J25tc9ZrWTNDvQsbQ9yozh63l0hXLYIaq?=
 =?us-ascii?Q?itiDbi9tsE2hPyg9ur5pn+hvwtxyue9RAextuBZXAZpWwTs8xU68LvXHTJJS?=
 =?us-ascii?Q?KvX8q3cAstzF4WM/vrlWTOL99/rsmzWuuRK0KJHg3ORE3EKTB01BnW43CcMN?=
 =?us-ascii?Q?GEQSB6SzOB82Xd+ZWkRI20Evs2jkeO1frLnbU51YRe1xndmrsD4JuRRmnhn9?=
 =?us-ascii?Q?S0qGWFBKR9j805Czdo0AoWYAlxXqaSBZ6sAKYrd3DnFVN84HCM2yLxeT+l6B?=
 =?us-ascii?Q?VwYIofjvjeDGcTmO68VwFtioxOy0k5dnQVQWYQkE3FbjHlbzQ3UExWX5ajGd?=
 =?us-ascii?Q?735MLdxBL/FEHirdMJA++mnuivfBEcnzEq0gYct9AwyBWAZcQQ1oGD+CJqAE?=
 =?us-ascii?Q?sphW26UAApuNmsgKYzuzBfBUsni/4Bjdqua7MgRGX4ZcsP+V1cesV25HcnKc?=
 =?us-ascii?Q?dEJ17yvZ0Aghp0lGDYRvWNUAvuJIzzfWTxedXrYjvp4vGHtHn+IFVS+6Bw9S?=
 =?us-ascii?Q?xPfMKBFrsakApOpkx/ZbAU5xcOkJn/7NaUeAbAbk3b4kPL3ZwEvsqBvOiKeJ?=
 =?us-ascii?Q?j68ZVygA2mgjVS8h9TIyr3AB0qlmNLq0sX/yVgpDiBndfPesq3JIMt03zan1?=
 =?us-ascii?Q?JoDg/IMTgXgk3YeEoOSwxnVhE4+0rg6ZBs1PA2geBn7gCTnxAgHA3eBAhuUl?=
 =?us-ascii?Q?dMsX0skrjfSVJewrNy8ABYxnVccXGh0nW5+GSyJtMfzAGhGV3t0sXpV4UXIY?=
 =?us-ascii?Q?M0q7khgAzF/Ya6Wnr7lDauHaCoAWnHkp2zRkYNW8hRzU6RU4S8iRoQFB6EZn?=
 =?us-ascii?Q?5qUwbEMOGz0Iizmxx5DMSM9dPHQil2QkHv7SP6mtzwPQhLzLFVSxZeS4iIBm?=
 =?us-ascii?Q?/1L+t7OeRr73uKQo52We9I9OCkuR/ZeFiFotHLxzwtzVSrg373lzOtScjE2o?=
 =?us-ascii?Q?+VEe+rwmQUfoSRvuxs0QRFYUlyQ/s57FwAvJEcfHphNnDh2bF9uQ4yLy2Fhj?=
 =?us-ascii?Q?RROXFoWMGATFDDiNwIDcem365DRqVKZSmwJ5evt+ip2NNAaueFVT1mhvjSBY?=
 =?us-ascii?Q?L9q/2Qilo9hoMhfMUb0u9TByRnev653npNmBcAlrp7guJLn+y40xsSPgltK1?=
 =?us-ascii?Q?1USsK24GDe/uw1CwEIOpz0L7/8V8MBAr+zKNYLCnzgsjZRZ/vn2mzEUzQ3b2?=
 =?us-ascii?Q?Pp72FsyrcO1k5B9mfX66G9dFDUUdaCuXlZ6A9pe3Cj4gjTA4Sgd4GrnxhXrp?=
 =?us-ascii?Q?pz5BhBd/6p4jIRkQkCEHBdYP/I019LjHD6SBkJNq8CTrxXGcSGLxIpFeiye0?=
 =?us-ascii?Q?WI1P0H0nAkIS52r8JWjR51tl57Hek86nKVgrodxjKZESEU4noiMj8iTKHx/Q?=
 =?us-ascii?Q?e0x55djE3DyaEsTmciR8u8AI2BIyLjz5hsE3ilHMtglpvz8Xy0BO6ty6h9MI?=
 =?us-ascii?Q?MUoLt9E/Up0QhEsOQnJymYYWVsOsvaAGf6PEieaNl/6lM9BL4bB9sA5bKeDY?=
 =?us-ascii?Q?DznR+Gq+/8Mc/LSDod4AM6jXovz/AmLiGrDL0EFHOzHfBcwahXSjL1fp0bUj?=
 =?us-ascii?Q?A36b2CsM/WBQW4dWxBiyd4ZXlgcTRwzVs+uZY47j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e852c79-bf77-458f-3f9e-08dde4a43292
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 13:26:43.2757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eA/D32l24vu3XcIWAMyjzSHptiebe1ihzhSszPgExJKaM329hzLQRSnjQXSRt2Jm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8915
X-Rspamd-Queue-Id: 4DE49A0009
X-Rspam-User: 
X-Stat-Signature: 5jp8kfxdmnayt8ro8ig4ow8jmd1yuiyi
X-Rspamd-Server: rspam09
X-HE-Tag: 1756214806-444779
X-HE-Meta: U2FsdGVkX1/c9nQmgxI0H7MRllLJIDpJdmzd4La/ET4iMmVGJXWD43WFrPHMWbzrLFrU4oP0WwfcQSelidIipPvvNlIq4drtghyTkatV3jXz/R1h7cwe/kIKoZiqYcviaB3qqZH5M9fa82sTMobOTr2Q1jAN7IoP4ZmoN43d7xYCrD/HCAivKrIEYy0vX+zu6c0pXHtQWNEHHlW8Ac8dLDbCaC43OebU2Z5622ubxMZN7FZoqfqQZs4lv8Z/JmRaa5k0n6k4LNHcKDlgXhVo4E1G4GFAjBdpEdsX+2U7dtBDoBk2CWTtgVj8yKPxJh52o62EhrORysziHRQ0S2RVqu1Z4srkIc60ctniWmtbbgqDIjQ7yqkk7JAoSD8LAlTQDis160NMh9IZ8Y7bUlNkOpdWHqnebuZ/R0hXBRu9ypBZR++fnVnPhLHnV1njmWiGla3f6NkvInwWS376woK6OYXNy9r2qEgacFBZripZP1C1/u8LVQZ184zKmsygZeqLcoASzYn2vO7gy+O0GROwEFJjch5R6QufpnB8rZbq2Ws/lc2eYVtbNUtm8B8NOlrdiKFGH4CUYmQh5s4AGB2byVexWaYjWFD4sBwTQiyVzdCUNF00ZGEyw9D+/mY9zRRlJEULQPfpIQarWjCBkVZUX6rTnLaHGUJkG2hgDVdOriwY7eUuiQ79hSAXdIcOVXFHu9YIA4iezRJqkIsJBe/wrj3EctYogpmXHGFNbtCfmW7JuQOOXGVnVT0eZMZsOHoLiSKeMvRtUCJpk/OqjDJnZplfhOX3bIMWXMnh8NM1xZM9X2s6XDNcjzGhU1dtq09Q6aFUTF5DtAnNW0mgpei0Y4EdLYxfuwg8NrXUA0O5chVLSt+4x+0ApknDpmBXnSNqqhpqNEVy/rQvS3eNdx4eKBAYuST2w39eiYsqfdV6FbxVVk2CXXDjuqychEU0NvXzgPZlA4LG3mk/J/H1J8G
 0nWlMy4H
 HCReENq3bKbaX4G17AGshA/QrEt2Y6nOPrmuY8AljGbjYsweE0jVjoyVipnzkqZ++v4EgfJhkmJGJVRUbuRQNCdQXIP6JxWnhHO6Qwxoav3UMP6eYH+wi4aFn8ZCs44k+kUouqSipj0SeAzUDV1sgSys7kCBFYJxsm+PZ/oB7jhOyd5yox23v54dpswvos/dghs0ftPBVYaJC3u6chj9cpt+Q0csHRKx7xCyy7f4ijpL9kYlE7t8JaEGfPZ+G7ShzIlnNUZ9wPTM8Ph2kk5RedRwIHChYfeDTj4q+2ObWkLt2eGCe42ic82TGI6bfVKpSS4CVEztLEDJi1NN/brge6nErzniwru2TlnkDAgRhvLa2kRvrCSy14+F2+IHlXq9sXPqgSoBR7kQxxnNH8jnGi82am5nor8MW7yY+AfqewUK6XLr5EOK6JUr+nz8e+Gqq0GgsSZewQaLRzP7yuxJFxmHz5QwQ3ivBQ5DDNY8H3RrLlS0B27bJQkTO8Map+hA+7HhtuJ0xnjKqwq9mkH5a67uo1i1ZFZgGomdCEXIag3+u5qrYYeeeK7oS6F37uoIZR1VcUEg1NE8cqzLX795BDlIu8JawFqiFg6cO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Aug 2025, at 5:31, Wei Yang wrote:

> Since commit e904bce2d9d4 ("mm/page_isolation: make page isolation a
> standalone bit"), it provides dedicated helper to handle isolation.
>
> Change to use these helpers to be better reading.
>
> No functional change intended.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> ---
>  mm/page_alloc.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

