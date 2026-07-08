Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9184BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35B326B0092; Wed,  8 Jul 2026 10:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332756B0095; Wed,  8 Jul 2026 10:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAF86B0096; Wed,  8 Jul 2026 10:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D31B36B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:44:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31409C07F3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:44:08 +0000 (UTC)
X-FDA: 84965879376.30.0D9A164
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011058.outbound.protection.outlook.com [40.107.208.58])
	by imf08.hostedemail.com (Postfix) with ESMTP id 447DF16000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:44:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hYcYnBOB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783521845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YCKFE33/PkQ2gzrLFqZFab4AEaLPXQdMpgCSnPsGU0=;
	b=O05l85t4uhAJkQ5fbckBMBe8jz+KoZxFZgL2x3MqcccrMuDbb5sDhtqP/COuYbLBmBOVZl
	vmjwZzGiCqcNUYWE8Ki8T4g5oLbojgNhZAOesUu3OXh+T/R1R0fgucoHHfsnkoZdMqMgGn
	owqdojgJomvGnuliAL3JkKem5vZ6wnE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hYcYnBOB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783521845;
	b=gPRW3e8I1gbgssE7VtSew6XM7iC//84l8dgDsISjhFMDtWMIIA0BYN6+9SDAIoxQbNStwt
	comofd9hSQpWPBfX6Jf5PHHC9OkW3q8g1Ktz6OkQjIKPz+9LmxL1PIzWVvrd9N24ueweER
	Z4BiXKzkfsp6pVuxZv9Bpk3XPzh0t8Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XDwHY2ipVHV4f8NCM9cxHKIeiMACXuwU3SlQZfJhGMqfYPLjDxHA6omKrPKm3uQkOiR+2RK7/LBIIl9HBXF8FOp/Mrogv/gGoESNH9jjInAS9t9vwDYE/jk2E4C+Kn6C/XcKqEkPv3iIU/JBVtwvahd9xJ3th3dre0Hm6oUqMxUCEAZsSgd6PORKNdI3eTY/IoUc+XcZIbamQ/u30mhsUl3gwF/6XiEidAS4yp3XEAedZPMHLa1Njq9wsavGVNzSuPx9DZh9wdI2ty1a7aNOH25sss8LamnVOx5Sza9BbIaif6Cenx2kaGSSpsmskSsdt/UvLMeYeaYxLxzZlIip5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YCKFE33/PkQ2gzrLFqZFab4AEaLPXQdMpgCSnPsGU0=;
 b=cgBr2x6QhRg0bHjJVy3xpKKl3yLZtdGsxcHBJT7cyZiPGFrU/fUavKm+H7dZ7M5rIB0OLulT8/Gu8AHLfUkNLtouk4VT4khAxDCBmWSpU4MQiOBfWIU1kka0AFZuoVTVJMNahcElYsxASg2YsVFZSs2n4CYQzDh2PPQkSHiTi7ikFLFFI7+W9dtMG+ldnT+Z7wWts3XJrPjDB4yDAQGkkiWM2K4HNH3pM5PCuz21RyUEe8KHPafk5RogwjTQjUUu7o+pCkCtcp9F1MJlKDgGnBEvmZcz77aEFKWbYWFfj+V+UKNupqBzuish/jao9+O72yLbkSuKDNsDeZ+QM9qu2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YCKFE33/PkQ2gzrLFqZFab4AEaLPXQdMpgCSnPsGU0=;
 b=hYcYnBOBYIlBmU7oBIHg5ubMzcAv7mFVV9pElLqYcjdTEwsnTqzlLwk3cquHDU4w9VeGtKEZBUX3GJ4j/aZFrfno3IqHPtH9p/R4t06lObCxezOmEb+kcBcv8/PkATr+4Vj5UATSpCi1SgGyIQ5QN/euaW+xjz9kiCcfLkdeOyw7Z19wvvkLo8Eru2dckxne8wyau3pBMcgA5xaDKPw8y+NVhbjUijHW5tav8rEDrqxJ+MHn0RpkpxMxZLPWmOsCgMs0WjZrv4nq4Se7jNymAPo/5Y+JeD5Sz+cQX3jhnyWGIB2LpKJzIFubarM4wAFGfUkiRwpOq7j4MZvErzvB9w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL3PR12MB6595.namprd12.prod.outlook.com (2603:10b6:208:38e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 14:43:58 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 14:43:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jul 2026 10:43:57 -0400
Message-Id: <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Sashiko"
 <sashiko-bot@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Balbir Singh" <balbirs@nvidia.com>, "Kefeng Wang"
 <wangkefeng.wang@huawei.com>
X-Mailer: aerc 0.21.0
References: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com> <b806c878-e1e6-4af9-8816-678955288d82@kernel.org> <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com>
In-Reply-To: <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com>
X-ClientProxiedBy: BL1P221CA0036.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL3PR12MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 756d20eb-96a2-443b-c13e-08dedcff57e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|921020|18002099003|4143699003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	u7997DxKK5+O4bNwjC3Vt6MWX7LzSauDzkeoKtEEalSSd6ED0wrtVd9GtCSe5UO/nR0nPgk18H3RanEheS087WYAvqtDtXe+CzawG0uuEeAv+ZJsSBchdLNOQn6iOZgMPcCN6mvztOBVS/Bo1/jYrgaWAl3UYqwWieBCJFkZkZ5sEiuDheJtxXuZMhA+DpAgNWFU4NeGbJopTvcFkPyJ+Jfbz6PFOSe2y5fQUXZWNG6/PQfenYzF3yy3tSvlWIphiJu41EoWsr1PsPWI7HGDrVThgXF17AtI5/T+V25XMRjJxSzZFWzQLvs3ETGjfOIwsnkBdwtpsfXzXJnoi7pW4W9Cl9MtNE5lcS7MxYcEGdv2pIuHYTDjyW3AEJc42OobJ3N+gxcG/XZtRDMV3CsJW05/tVSRzUfebPjopZwWXpa4Ubu4/hIBO3KjVwWc0oRBidogtTHMgVKxnFxru/N41erxY+8GANPx29h5ahveTW0UfVYnnll0WXWx545vULkrimRvE7O4PhZbxlhQ/xER76bYgTWomlDGKtwRiSPcyOIHkrbXGTN7wveCvta3+YbtOSqPoy+oEYOn90YFZaIsTzC2Il3FuTlrG86TX2/Jsw1m1RU1F6n6xYpduI1lZfq8q5jZhC/vjgPmST+0AJyqKSkq+94RhqgT0PcX74FUJ5mfv4FXm99ZsxKZ4H5vTAxBg7i+Gh+hbhN3cDSIPBDD2w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(921020)(18002099003)(4143699003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUFkeUhESnNVMWJIbFMxUmlFR1dPM0NjTmJhUHViWFU0MlJqM1VMNkxFeXNF?=
 =?utf-8?B?ZTg4Y3dTTG0xOVI0M3ZDeEFQeDRDZEF5VkZucXR4VVZVR1MvaHZ1T2tVZkZM?=
 =?utf-8?B?UDNERENoeW5FVDNjNkJ4YzJVWGRYNXZxb0pwdC92cm5ZWUlQTU43Z2MwZmF3?=
 =?utf-8?B?SEVpZDBBUjNDaUVQcTlDU3JoeFlPUGphMUh2UnJWdXYxU2FhZDl2b2NGbnZF?=
 =?utf-8?B?M3pNaERXR1pFczhwK1JjMFppUEplKyt0VGV3RjB3c3VmbHlwRHluTnQzd0Za?=
 =?utf-8?B?ZFdxK1J2V2hzZ2RhUndKUWtSOHp5L3kzek1IN2ZJVUZKMEZkOVhRRU9GQ1k1?=
 =?utf-8?B?VWV3bU41R2R6NExoNmZoeW9WSndCTHEyWlZXbm5ndzhnTXZ4TlVRYjFYZG9z?=
 =?utf-8?B?MEE1emNMd1hOY2VZSDB0QkM2TUhPNXU4YVIwbEJEMFBIVkFhd0xQRklXVkZs?=
 =?utf-8?B?MnhrYlptbTdHN1JOMXMxZU9pU2syM1kwWFo4YjYzTFNlckZ3VFJjajh1Q2pS?=
 =?utf-8?B?SXlhQWo5Rk00N21UQkI4VG95czh1S0dLNjZ1ZytybmtIWmRvYWpjWDJkcnph?=
 =?utf-8?B?bm83Uk5XSHdTWTRUYXVwY3Jlak85VGE5SXBsa2Zhb2NDMlIwZ2xCaFlCT0Jw?=
 =?utf-8?B?cTI4Ymc5ZzVqZURweWJxUnFlek1Bay92ajV1Vk9zV096eUt4dFZENEcyTkxp?=
 =?utf-8?B?K0t1RXVseGRuNHBMNUdjdFVieDAxcENybFRGTUVLQUxXY3BHMVFIOFAzMVBq?=
 =?utf-8?B?TGZTMWpoTFVQdEVYVVF3M0VTRnJmU0NmR0tWd2lzMWZGa3F3ZWZXZmVNYXVU?=
 =?utf-8?B?cnRmMFJsYTlZZ2FpaHZaamhmU1plbi91YnNON3B1TWNEelo4cGs4eFRSNFpi?=
 =?utf-8?B?NE5WbEFSRTE5eTZRanJpV1NEZ1FyY0J2c2pMdXpRZitwTUNOSmI3SzJkdzdy?=
 =?utf-8?B?MEdXTHhJWnBwZEpRcjBkTytPV1oweFZTc2U1bWFYTHE1WHpySTAyazEyT0dB?=
 =?utf-8?B?aWNuVmx5ZGNwSS95YU9pZ0c3dFZxM2pMblE5eWNsYkYzQk1XanE2VHN3OHBO?=
 =?utf-8?B?bC85enpkSHd3ZElzK2x0cEtjMlN6NE5yL3JDQVJteXg4eE1nc2p0QmdHenZL?=
 =?utf-8?B?UmVDRmtRQ2hIS0h4cDVFR0ZEWC9WMkkxMVVtYXRlQzNIbUk4aEVhUTNCbkRN?=
 =?utf-8?B?R05nVVhqc29HaWFzcm5GZ1RQelZWcHpSQSsrWjNJOVk4aElEVkVDNklzSEIz?=
 =?utf-8?B?Wi9CU2o0aWZ5b2tZdWFJenF5VVJIY2h4UjhIbE10Z0N2NXZDWFRXbG5tZnJE?=
 =?utf-8?B?bStEaUZLdE9pM0pjWXRlc0NTSjZ3a1k5VWRxTitob25sajJpSm02OFQwZjJJ?=
 =?utf-8?B?UGN3c2Z6cmtxSzlrNWdyL2d6TWw4ZVA4K29yQnV0MjN6SVNiUzZkWldPU1Rp?=
 =?utf-8?B?NkNWSktBZXo1RlFuczN3eVhZWGtyZXNUTjdsYnhBYmZqZG1yOEt4WU1NRlB1?=
 =?utf-8?B?Z3pqc2lVNWNQdVpPMFBBK2pDRFNaZkNuZDh3SHFWREI4UG9EMGVIUFRrd3Q3?=
 =?utf-8?B?UktNUm1sRnFZVlprSmI3NnFCZ1JHWWFDYmVScEpQZFVOVzBWSGxXa2JWUDUw?=
 =?utf-8?B?WDNhb3pPMzh1RWxpQUNJTndPeTRHQXJNMllpQUZYb1dHSTFpc3JEVUhaZE9u?=
 =?utf-8?B?cGdaSVJ2SVFENTUwWjFOZ2dVQlJDKzhZOCttazFNT2FEMHJ1VDFZcU5kbEFH?=
 =?utf-8?B?VzRZZ1JQVW5xMTFWemdxbFN4My83T25mQU9kRU1tL25pcnlxYldaM1UxNm9r?=
 =?utf-8?B?UFMyenpKR2p4S09XcWMwNDNoZU9JeDQ1S2xYaXJOOEh2bWYyTGdlSjhxOGtZ?=
 =?utf-8?B?Wm0zMXB3M2VPeW1ka2pQZnI2bHJ0cm4xMnorY2dvaVd3bTVXOG0wSUZTdkxP?=
 =?utf-8?B?RXFrNkNuc2h5QWlXRHArNjdONGZyYTQ4QWUySFczdGd2dzlZY2VxTWpkTmw3?=
 =?utf-8?B?eDFkbzNKWTFxZWsyZWlrZ0pHd3pZKy82RW1Lc3ZrU2dWd3Qxa3NtMDc5a0Nn?=
 =?utf-8?B?WnhPYjZYOUFqRFJzU1czR1hpRTlOK09ZK0F6clVYZ1JiNEFGN2tGRFRlSE80?=
 =?utf-8?B?bWxLdzlVT3ZBeVlVVnZYNG45aTNUUzkxdnQxelFtOEFzUStGTElTa0dQMS9D?=
 =?utf-8?B?SXAyTkFmS1BKZlNMM09IczhKSTZ0WVRhOHFFdEo0VlNYTGpHaDNTTDQyZkR4?=
 =?utf-8?B?WFp1cHc5bHdBNlgxU1c1ZWVDRDZmQVV4Zndua2dWQVhIbElhVGZiYzdTYUxS?=
 =?utf-8?Q?Pvr9pvn27oIrzrI4i7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756d20eb-96a2-443b-c13e-08dedcff57e5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 14:43:58.4259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/2eTQKqpsOWLzX+u8eBAag37oz9AHCVlxcONIU6n2bJ/x2Z3LVNMl6ijjZI5Dq6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6595
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 447DF16000E
X-Stat-Signature: hxi5himo13npjxtxfdicnt9p4fz3ccaz
X-HE-Tag: 1783521845-878395
X-HE-Meta: U2FsdGVkX181je12053+qZucho+g3l8FIOIqNlKdHrPvnPneBysBFyI8ANS2lkV/Y0uz0D+FO1FUCXSdmV0HeAJO+a9TglUIbGaOruEGqTAvY60L9pz784BmF+nWDkfui7MRj7wkL2cUpMDtn+P28kTcd53Nr5dJKYNq/TxHp0hF89EuR6ywqj4EVP97vNrYN3O+Hwyn+JPW9p7rupAw0eEJ1jAko846YKCDMd8DdcvXWiS3DBLdlDlGwY7CW2KCd6k1Ifjo2LQg78Tu07xy2ojj4+zMyjoABuQIPqNw2YK8f6/+Z4kVKDcu5rx2W5McQkOZHpr6AJbC1VT5gQ2h8MNRHcZ6MVFIL0Xxexe4r4S36DESQPyhCzozHfzpa9k6Vg2qwVdcFVMAoyj7kvzAcWlBNp3rGUg8GKPG39nYChHHBGYbVhiMEgTH/oRyDt21FjMRjIHbrPd/+mWFRmYbBZZBo+NSzs31Y3HLF0DozXI6Fz6BuxWmvKwfgLygE0n6RnofJzA9mAmDdhp4FRJlz+OZwMDu7oXnIfh+DOhBJstVGborl5FCGvkiAgd3EWXc896OfILF6egKXhJQNNkC6s12EfCt67E73fLVMN/5BFoX78Xs17Ai1pS0lgfzd2j7jcqb157+jQGnZaPLoIPqRH2hVwI39x50ViXwb1L+jMHqVGRKleORfXpvMtJSXzlHP/FKT+Q58BIK7pBG5QilX+/SZRXIcovDOXhA3B1K8h0qiny+GDPfB6KRrXY4DepRFJziWFrdElzjwRd038t2iK6ejfxZulAgVdgI3V8dDr2k6NsU+8dWy8PSg99x2k91OxA2Hj3csTMpFrlPmy9qRgld1fqM+7HiOPXC+ud2kqysDgxYCY1NN1+GDqmVCKQGBVzF/uGr39VkOV2yfw8WCXNd1Xg7VrhwoqqaNQJV/FAKtnYoD6n8/xlMVLXZpLUsYkbPRORAzuvYOk4jghq
 ZTttBM9N
 z1ATbjUXuyatfyJNbTw9mdnREabQFhLqhYheuQvGHQMbelQ0x96qdyz3qsorYRSFr/DP7M0ppQLseTQgE3pt1o8mOKRZ5o7llXq9qkLYXI3G1WzsnlLVIH4eh45AuhFgvDyKgJEeiu6J4VFUEcSMwd71H6w9PUPJEkN6pOUXguVrc7Z6veI513vPgMDnLK0VDSh0EjHtspIFxEZVykMbLb8ctUtoE2MNOdZdpduZWPi2fAdPlGPKc93zanjMCx2+yoLBsLJ4PC5r/VzBbUZiX0DTT8C+FYtqse5eJijHbEto1Q1Xp1II8xdx/yxxVAoO0iVFEavQJFFV/y4V5UX5RuwBVyjGUQUXePLJAXYHs9vzSimyMpKOlb3VLOi7l5KqJpf9zlI0QkiF7anuyMaUW2yhIRMd0bDaPqDA3CRrRqcXu/pQsAFUHRRgRcSMA9+Z4VfefDJh/fsVIkK8/4jQ0Ondzc7mo2uklP0ajsKRbV6+SjvW8ws/Lx6EDsVKwbTQYbkJU7RQKUudJjk1gOBlxgxltsjmDzA3gx1CNm9BuFGJQZ7V1T7WyN9trRw1/5ote9d6EVbtm+FADeBbVqBn+qBUB0eUBjySjm/BPXdvjpFF/H9TO5Zw5eOFRHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 8, 2026 at 10:35 AM EDT, Zi Yan wrote:
> On Wed Jul 8, 2026 at 4:43 AM EDT, David Hildenbrand (Arm) wrote:
>> On 7/8/26 03:50, Zi Yan wrote:
>>> migrate_vma_collect_pmd() can drop pte lock to split a large folio and
>>> restart. But the code does not handle restart properly when pmd becomes
>>> huge or cleared. It can overflow migrate->dst and migrate->src arrays
>>> during the hole or skip collection. Fix it by:
>>> 1. avoiding migrate_vma_collect_huge_pmd() if some collection is done,
>>> 2. skipping the rest of the range if pmd no longer points to a pte page
>>>    table.
>>>=20
>>> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zo=
ne device pages")
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkef=
eng.wang@huawei.com
>>> Assisted-by: Claude:claude-opus-4-8
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>> The issue is spot by Sashiko during a patch[1] review as a pre-existing=
 one.
>>> This patch has the minimal change. An alternative is to reset
>>> migrate->cpages and migrate->npages and restart the whole range from th=
e
>>> beginning, but that also requires a restoration of no-longer-present PT=
Es.
>>>=20
>>> Link: https://lore.kernel.org/all/20260706111958.3649651-1-wangkefeng.w=
ang@huawei.com/ [1]
>>> ---
>>>  mm/migrate_device.c | 19 +++++++++++++++++--
>>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>>=20
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 2fffeb1f99694..6ceb47ec1da24 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -257,7 +257,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>  	pte_t *ptep;
>>> =20
>>>  again:
>>> -	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>>> +	/*
>>> +	 * Only check pmd when addr is at start, namely no pte is collected.
>>> +	 * It avoids collecting the same address range [start, addr) twice
>>> +	 * and overflowing the collection arrays.
>>> +	 */
>>> +	if (addr =3D=3D start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp=
))) {
>>>  		int ret =3D migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fau=
lt_folio);
>>> =20
>>>  		if (ret =3D=3D -EAGAIN)
>>> @@ -267,8 +272,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>  	}
>>> =20
>>>  	ptep =3D pte_offset_map_lock(mm, pmdp, start, &ptl);
>>> -	if (!ptep)
>>> +	if (!ptep) {
>>> +		/*
>>> +		 * Skip the rest if pmd becomes huge or cleared. Flush if any
>>> +		 * pte is modified
>>> +		 */
>>> +		if (addr !=3D start) {
>>> +			if (unmapped)
>>> +				flush_tlb_range(walk->vma, start, end);
>>> +			return migrate_vma_collect_skip(addr, end, walk);
>>> +		}
>>>  		goto again;
>>> +	}
>>>  	lazy_mmu_mode_enable();
>>>  	ptep +=3D (addr - start) / PAGE_SIZE;
>>
>> It's hard to express which feelings reading migrate_vma_collect_pmd() gi=
ves me,
>> haha :)
>
> I guess I have the same feelings.
>>
>>
>> In case we split ... couldn't we just undo what we already did, before d=
oing the
>> "goto again" ?
>
> You mean we reset migrate->cpages and migrate->npages and restart from
> the beginning? But it is not only that, since the code below also
> changes PTEs into migration entries. We will need to revert them as
> well.
>
> Hmm, migrate_vma_collect() documents itself as "update the src array and
> "takes a reference on the page" without mentioning changing PTEs. I
> wonder why changing PTEs is necessary, since later migrate_vma_unmap()
> also changes page table entries to migration entries, although
> migrate_vma_unmap() changes all entries to a folio, whereas
> migrate_vma_collect() only changes PTEs from the specified VMA.

OK, it is an optimization[1] when migrate_vma*() was introduced. If
there is only one mapping, migrate_vma_collect() will set migration
entry immediately without waiting until migrate_vma_unmap(). Fun.

[1] Commit 8c3328f1f36a5 ("mm/migrate: migrate_vma() unmap page from vma wh=
ile collecting pages")
--=20
Best Regards,
Yan, Zi


