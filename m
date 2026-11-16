Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40DD606A8A4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WGFtOJWe
Received: by kanga.kvack.org (Postfix)
	id C6A196B05B0; Mon, 16 Nov 2026 13:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41716B05B1; Mon, 16 Nov 2026 13:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FFD6B05B2; Mon, 16 Nov 2026 13:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 846816B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:58:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00D82A7BAF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:58:45 +0000 (UTC)
X-FDA: 85441893852.16.A6CAC80
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012017.outbound.protection.outlook.com [40.93.195.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id 201631C0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:58:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WGFtOJWe;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794855523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSJQwAVjqtKC68lGy7Idfh+eTeZHnkXWIJOGxpRoXqg=;
	b=N/bKE4O5USJQPPZ9P9O3HkHBoP1sF+gDlLxmA1uHMmylgCgUUSNYfxjVDE1bhhdVsfNqH+
	4zaQhyruaHDRh87QEAE6shMQ7vCW/6X4ksaqLpXR50nJ4GVlE9G8qRE8DYLNxBeTEXLQvt
	1EnqULQ9gAx88lex5dPhn2EGluTQxq8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794855523;
	b=zh0ty3NqLMV8AGtP6yUDFBcLwCNY0icnoaeEN0/KB7qk1fr8KPUEwv+MvFqwmhd+USW6FD
	fJqrpo03Rw+ABt7ShHeOEJgQetbqLn+VWBicq6uOidpxPzjq4bopi6owBVJ1EXZ/Ggzsh1
	Q08NpX+Vug38eb/+ExJN4KDF+QCGPx0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WGFtOJWe;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mr0QZ2Ek5XAtbJMrqFs+njtohX7u68o9YBWgabEJWL3wDmnJ/yQXFRa8tM8We4XXfi5psRj6FOIieKgM7ap9EehW28ykzz4f9tjPrvAHB3LfUjFgJY124NUYgUB3VPZ3vPpEse/VxGzVXf5uOs7nppPyBl/IW62rcDwVXTDA7ZOIp3xZpSBdgATGZipJwlsxi/3PUoe/Ge9BKPTmW39IipXKSDRrOATU14V01wWuJ0c6AWuB1SolNg+nUNVFIbhKB/vKCGO1UBjHlB30YaqC06+xMZ3dLK2cPjQEfzjDorgBcZkL1Is+BT8AKjdpqJZDCS1pHnhxbG0MZDtQvQ/NVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSJQwAVjqtKC68lGy7Idfh+eTeZHnkXWIJOGxpRoXqg=;
 b=ZZWjQ1ivUKZ0sFGstYgXEhkSb4cAFgVH9GWaRaOOen1qmps8G0Itx6AUvIS8FFeimWBNacON5KkU1IfaX6Gb1CL+y35W0rw08C5TKNOHVylMLdGT/f+VdlVfZj2UZ+6jk1l9NdfhktTPYOra/9be3myJVbEsadrBV4ziesef1HShXTgFrS2+mkmml/GE5zqIlJp0OAV0Omtmg0sbEi0TEHvdGt61gQ2detl+WG7PkiJNGnFyeTwVmIQZkP+MuuF9tPgj1rLvmNj4K9r5JSh4YsE+cfHNhNauFqqaWDzv3vYE34RSAiE4W+KVi3/OcV35fWw0RlYc5CkVTYuStel8PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSJQwAVjqtKC68lGy7Idfh+eTeZHnkXWIJOGxpRoXqg=;
 b=WGFtOJWeAEhiJjVCZs1/alNZZ5X+lz0rD4OkKxwfvoWNv2txnlnEYZQhFDu45DFfnlkSQSY8pBfvOeLEgDodU2ht+wBbQRbPg76BNwt2/v9Z2NHod0FZYxzfhJpQTx5+qsjbuf995QxHyfYePMIYuGlZpUUY57/iC2Gn9Rubi/64U2xnGRrDUl/9ZUCwpDKlMDrFqyfZkPM3I/LqUvZlcdl29M7CM8YBEtSB/HT8uAB9aswJQ7rD1ZabKPdo+AGudRjQ06IDJaRBI9lBZGy5rNmoN3ICVvkBjCY59WReKPGLT2pYxpQS4/deSLWK/pbcKmCB0wr3q8P9O0nf5V/fXw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:58:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 18:58:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/migrate_device: avoid leaking folio references
 during THP splitting
Date: Mon, 16 Nov 2026 13:58:35 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <F40191DE-78E7-4861-8CFB-A460A543F49D@nvidia.com>
In-Reply-To: <20261116063624.1382944-2-usama.arif@linux.dev>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-2-usama.arif@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:208:32e::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: c9400155-85a3-4a5c-9d7d-08df44139f65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|5023799004|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022075727099003|261022105027099003|261021121427099003|261021123027099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9fby0mjT/koKjqWluJpHmiAyS7YPXgUwWIyv8VwMVlj7wSeGaMZAa3Qv9QLAPmyNeMy5xgEufuX6pfhVj6YIhn/t+TT6KVE9z5ZOjvZj4mXpKp3VgB5+RUijO0gJkfsLliOIKFBl0ZGAFK0Gs4CLxo2XvxBgDZ+TJqdvdVJLIA2tCqpIwa28dqcGYUSbjsbB/aITtGEjlfcJOI+U/cIKF70890zDFZKwqPMBKII+lEfjldJj2USyXboyDCSIIw2eWoWhHLr0i7S1V/TPwKfVoc8OwxXagUOWgXM/NhiidO6pk1t9xl1Z1mrUUPH1+WGLcjru70qhC+t+bf7sjAMy7dRm6v3wtgQuex+u6K/Bk2+H4lUweLOuE1bXtSxLZgg/zpVrSPX0FSiqqGF5pOha6zdtWlDi0lrzoYy+VfSGNf1H0AsyVpg9haizchKf9MXaAQVhYAg1Qu2/rsM2niTBmUXKGuTjYfVfEHFRRhOpd1x53WWCLf9pBMBeTi1t/Qx2WVL61Qo7PYPn2e/CaMixb0xbMnDC1KJ217iC/YrGb+Ff8gk1069oKTUXAWF1f1Uw7ULSt4TNxkdtO5avU2k9beGWE8+zdD4iyMq49HvTa25/h59A2CPIcR8PCriOusKwFF7Mcuc+Mwxpd5k/ohdnDHyuLOdT8aHcWBFBG7kFJ8Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(5023799004)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022075727099003)(261022105027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S4KChVLOqc9H4DIPgDSt9/2SUSIR6haoWyUEFYTVe3QgcIRzSoJxZPKAI3Az?=
 =?us-ascii?Q?zQZk13K3uz1kVzgZV6GBlOFIMSaQcF+WVR883AQFnntfLJKeq6CXr+20ZVuh?=
 =?us-ascii?Q?r4m2Z4Y5FwlO9XPI84al8hFQsapjPkpHSbq/gF3HQhPpn9xwxVQDNmKJEPrc?=
 =?us-ascii?Q?4CDF/vy5aqPgqH9gR7kjSjDh8kzZ0U37IBrmObyZpGRiDgpiaZ6AVgS8yS7n?=
 =?us-ascii?Q?SWLCyXgmxoN0JOXZG1BrjaNCVuaslMVWKItO3nTEeJ6eFljmuaidIrWwYz0y?=
 =?us-ascii?Q?S89vDwHfjw2mEzig9e/HNfBXfDtVpCejY3mEOuv+sZRrx0y8mPgmx6QWpAKa?=
 =?us-ascii?Q?RXn98KFmoUBNJDBP6nJdv1NG24ADQFxPlgjV/EQVppO+uiDTZyXdyWooV25w?=
 =?us-ascii?Q?aI0OPIOopVn4aXwRNTo/kLL1pFzExzIRgbdvPt4MzHoexwbNfMCuf8pDELEE?=
 =?us-ascii?Q?emo72me0Fj1CVZTmhQ6d3k/ke89gBa6iFdHRIKEo9hgClNvkopNwGfUqs6Ea?=
 =?us-ascii?Q?QRGvhjrH99VS7Otlo4QpdVQRzpg2rj47vXp1B92sRp9aKH/5nj8Csd9N8wPw?=
 =?us-ascii?Q?6k5M86evFtI8+TtDcyZ37U8+zvp1QrcbxY3Aarpx9augOeD47xuzQNWiqEfg?=
 =?us-ascii?Q?GcHOAIPEIaRUgeccvDxJiMjU3hbuRRswKL1TixSxyVwuQ4qDtCrZVEaOuK9Q?=
 =?us-ascii?Q?C0MMJErgWMh+p8ogDhRfso89nIkQqWltNs6eZIs5nIHXdKjNxlV72EmMwnsB?=
 =?us-ascii?Q?SEWsJyUvW5Fvzi4EsLAT6AKLZmQ4+kyxOxaVzqO/c5+R2qpPlw1RA3gvo8r5?=
 =?us-ascii?Q?VSuEVWVTv0pfV/hIjLWN55WiBHky/0urf/Mwh/t6oIdwcQBGtsrCXVC55N7p?=
 =?us-ascii?Q?8cVKzsnmWfIacWQ4sD7nzqXrTicIZzanAjW3FJWAx2vIpy4UuHgSGeiKzgiz?=
 =?us-ascii?Q?vlpUj415qs0TQIXT3RsTniq4RKQGMhGoTx7tCq/jzCyyOTVZeMqfgmyhuJp3?=
 =?us-ascii?Q?8a+3xOB1pf9V3AP9sILRN1sUMTXVVDwnYnqeKQNLl5Hl3FZT52oLWF/5XQJ9?=
 =?us-ascii?Q?yVwaFEQjbzgu3KIUSYGO0cW2ey/V5NPl88Ra5u78a679PFPBJpshRMlyw0oQ?=
 =?us-ascii?Q?N2WeEaSRe/ZicqcoeVhAGgMQ3BFXBluxZppeAG0ZG8GDrHbrKWdxQlpMAEpd?=
 =?us-ascii?Q?OxPQqotJpwL55ON4fVx4uhxn0KClRgyAgCeCC/l/7C7n93q9orSeixT9JHkm?=
 =?us-ascii?Q?75RwkOrA+GEvCreg4dJgUnP56BcSmm1htuLg2+XLShM5EMXDBPoZFRigUuc+?=
 =?us-ascii?Q?+U6aivE/Qm04msXijY3rxz1rlu3O0tHSaRMcwhZb5nBYOF6wG/k9zmEv1FTy?=
 =?us-ascii?Q?fT+4mDV0hANA7qymYB4OYkdyYE0CF0iwYtLpwzvx8PhSByG6plYW9Jl4c9UO?=
 =?us-ascii?Q?unBDJsxe42t61XswDhVqYQ1zLMGJ25Td1WDCQB+tMWPiF5xMOEE/mF4s3b7x?=
 =?us-ascii?Q?0xh+fu2gNu6RCVHR27jL1u/dY0A23JW5rADvEDfXRIGI5K9UztB6e4GBQWus?=
 =?us-ascii?Q?jtsprvDj208/nPdnxHaXmSPhtRprjeVO3b9L1k8d0DtRNsv1P3lFjasG3dCt?=
 =?us-ascii?Q?cSpK9c5szNPqXNOrigemYxll9v9PEa8ULrPLd2qnML8xhpviL1o6kgq7F7dZ?=
 =?us-ascii?Q?4Ju3hl/qPIQgI0AEGuib0XD0nTMSt5nU9y02wohnKyL4ojKd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9400155-85a3-4a5c-9d7d-08df44139f65
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:58:38.0389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zIGJalD5NCpvmQgYBBboyl2Dz1Y/fDGIS8Fb8MiSsaYBFDFxZvbBeX6hqRN+D99
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4269
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 201631C0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: es5go4hci9s456zj8mrjaebcn7zm1cwb
X-HE-Tag: 1794855523-780039
X-HE-Meta: U2FsdGVkX1+bfzuJbn2Arb770kQkytDTEpoYwIEHq7U8sljzACtVYXEo1QZvpKmPSkk2XjMKpQacmqCOMZfgpQFnl7vH8uhFaU89vgR6Cgt84z5uKJ7ZB3X5Uim8bmaraW6deWOCYmadxU/8BeShfZdpxqtZ4kZSOInUbrlu7MwShAtmXTZobnBbBe0FoVjbos1acJMoeT1HbD+NUv7TW6tQ4z7FvUijFnMbZMNaijCosakZjz38h/daJyEtM/Yg84y7oa/kYWmVqi8hO79UOdFKEJEvSx+hUZrkThhIi8YeNxYJMrQzyCBQtjghb4BP+ePy7QxTZW6ovtJH+TBHS5QJaAmA8Py0brgyAEiIumproaZxKBxMgvEwkCtxjiLqxOKqX5Yv8J26+ZM5qgp18CRTsLRTvR1tp8xqURdRI/8nU0ixyaZP/Hm9o38M0Ta2SIc6d8smP4BmWdSiGt+X0hNVmVLoRhOkrgcs7BGFwIpAZJGP1er4vUphkDB9cvLneUIFYoModLq4+MFbYqdBTLBrtTOikP9JNJ/g/HPCwZ4WRjk0km/x4TdM/bZUJwC47jhKJvXyKkXQaBuIb1rssB3CQp1EDDf4lRG9d6rwdNcMVKicqYbqKBNvDT2x72DjkfM+XfBchbBtpJl1WpR937f5TIKicC3pAAjZNZFUFTrJxwYI+vvX8k2aZ48IjVf23ogzLSsICDSVgvtdGDHxVS2kxEfl5eKXPq9nn5ahtAj63w3CiqdK/0BjF4cA2VxRbFaCP28VQBkA/dSTPJ1mZeTjMapWHoJ6AONf3aLpeyTeSwnRZ3jj9bFoCmFoBhd9qJfHPotAiLfQXWYidJpRU0rsGSFs9zaPDcJfiJ6tEbytbXVZ2sjm4InX1izckXMiAdpzSPRPo5JVgqmEhuod5hCfctj8FrkNuYiRqZwAkt6Cf8ur9z6+bieJwVnqQVWN2559r2cJkv0aKvyhDm4
 G+Pvjx+0
 ajTlp426erxImfOhdCGb4CeTzXAWEWXoJ3k3NIeMpOn11V/Th50s9zXqt/pDciiQ0n425K5a6jTb+MahykxfK66DFjwCIedW03Rko4+15U/mEyMemgbdeFYAdfKkK+54xx5QBoORKcvuPzHQQEbt/pirpRqSNdHkIgXGZhrV14ZW9ZH7JozSdbkQJzW2wBJiQe/g8Xl6B8VX/cCW/7OF8i6bkmV3cz6iPDwpXuDKGZDLZQAB1SxSO9DDXxyCSNbyMyM/qPlfuLtYJ1vaMknEbVy10FXirRZoVJsYbfFVz6tKhaZvlvj6U7S/UgCKUANdTgkhiXI6tjY+CBJRiZ0YZbOrevLAzaI4s5q/IdH/pTxGGnpTod4e62nTcGHxFe02zAAOVMYGQq+FTELYJzFEp0x1lnlVHYYW2dPeUFjZY0OCx8mdICPCAmK3zHBf7fQIrxKiJRdm3BOk6lhbyo17LfAURkH3Upy4FiXV2ND6YsYi9hgimBviX0i3A2m1xiivv9XFZYTvdufPp6VsXL+yKg4OQ8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 16 Nov 2026, at 1:34, Usama Arif wrote:

> migrate_vma_split_unmapped_folio() takes an extra folio reference because
> split_huge_pmd_address(..., true) drops one when it splits a PMD.
>
> However, migrate_vma only holds mmap_lock for reading. A concurrent
> MADV_DONTNEED can clear the migration PMD, or split it into PTE migration
> entries, before the split helper takes the PMD lock. The helper then does
> nothing and leaves the extra reference behind. folio_split_unmapped()
> fails with -EAGAIN due to the unexpected reference, and the reference is
> never dropped, so the source THP is leaked.
>
> If a THP is faulted in at the same address inside that window it is
> worse: freeze = true replaces the new folio's mappings with migration
> entries that nothing will ever remove, and drops a reference the caller
> never took.
>
> An existing migration PMD is expanded into PTE migration entries even
> with freeze = false. Use that mode and remove the extra folio_get(). The
> reference already held by migration keeps the source folio alive whether
> or not its PMD migration entry still exists.
>
> Reported-by: Zi Yan <ziy@nvidia.com>
> Closes: https://lore.kernel.org/all/DLZ48KMS7YG8.3BTM0UUU8CTU2@nvidia.com/
> Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
Thank you for fixing it.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

