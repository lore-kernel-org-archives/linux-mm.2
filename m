Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C55BD14893
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E006B0088; Wed,  7 Jan 2026 22:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B006B0093; Wed,  7 Jan 2026 22:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702B56B0095; Wed,  7 Jan 2026 22:25:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF976B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:25:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 140CEC218C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:25:21 +0000 (UTC)
X-FDA: 84307356042.24.B583B0A
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7C612180003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:25:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fk7KwJeC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767842718; a=rsa-sha256;
	cv=pass;
	b=r6PlO9g4g4P50jAGN8sFHTPFh7borV0kiK1s0OjN7x0UecBHTp3Jflq5cnrBKP6p1eUnVA
	r1aoRvkm1FdWGVAwB44IIVmltYTOfazeC4bZofGkFUTGf2MjW8fJhCIjk9jXIT0KStJLew
	dmlLESp5/S0dOj6uKEtfKxxGJXFbMdA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fk7KwJeC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767842718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0u2sgtuS65eyzNyxuV6esS/g5Mf1My0Zl3lCt+u9Fo=;
	b=TuFyMpmY7VoVcVHA7mNT913htQ6JjUCoAsngaq+Qu/Ru6osGi1M3Rdz3sKR6ScDyk/MOxq
	gI+iC42GnQhnFz3zJpf2H2v4dcpvlDaLYf8l5zM2NOAdH/rbSYzi2PnVEVDe1psy8K2Gwn
	HY0/Y/ce5CVrVENLWGWyEbj5p0oCgwc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a0vYIwgAv4mehG+qnFnJBVI3143wwVWJ7Q83bFmx0M0xNHj5NqRZjiQcXSrqquk5FHh2zvSWTBUccjHRI1J3RlFruLzY7umN7sK1wfi5Vm9/RTwrepqVcTlOrHNW7J/mq+0IDRYd8hMAGbv9AEdu9mlYWJWM0jBYlsZtni6rVeK9nA5/HjTeIDmRUvii2+bBquYRk3OEETSJ3Ecwdoz2khw7XYUngU1CTt2EHTX2Tl3s69N7QV6NO0DuzsIXwgtX6Osx64ysJfmEN/+daXOXtqx4zYibtuaKESb+SROjsHy5PmDqd/EGEF/ffLtoVIPFdTNM4JsHnjkgpV6VS/BXDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0u2sgtuS65eyzNyxuV6esS/g5Mf1My0Zl3lCt+u9Fo=;
 b=gBkjO0GZAn7NUQ4cnm9/8xwmWtOFqRjagSm5KAoc2HtNuZe0tg/+KpeaiDsYcza3DE0ehMUWXf5bKVfZbk0Y8u4GMXCbyV5vwBbERiKJaMXVlCNh/3lW8gKwybiGa4SyoBee/3djCyYU/nSi9GLJW0u96cIUv/KlskPl8l3Exv/YzVJKyadINhIh0UAuZ4lAH25pQaeq74DxpbSMrT/GPAEjb8QEXD7+LMTcK/AH7ortzWBHPeM9OSt4AkgDtjRwjSHcOXWJtAwDdjjlX+r0/yjdJH4fpo//9gVKKwLJVlO296bgY6BOq5tVIC24jRxBMWpYOaHRn6jgiq2ujyqO+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0u2sgtuS65eyzNyxuV6esS/g5Mf1My0Zl3lCt+u9Fo=;
 b=Fk7KwJeCJgaUIUuv/YRsumyXvb5Or5mk98z5ySDY1YbKXAG2FA+VxeTebwcVF8SXDjLY+HnM5sK3NFlV2vccrMOWo15uoCBaYWz0dTsEaOrYmQEv8Wb55tDQN+P2PHHLbiVNNqPYfXtNOvwaq/HPDERWoKj6f79XdoF0+H+rVL/SbFKsNGwm8MXnG9M7Zf0TReXDtgSxZHA5UZ7IQazWHDBloEroRPIrrp5PNOm3QRuns9Fxcx6YjUmrOp26s10eJWDZVZEU6Yo7eH3O8li5ZQH7i6lpw+yU9guX/zuSJnv7fa1pnaBbSrxKjC+8E4l99j8EnkG+cjAaPv+diBYaOw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB999109.namprd12.prod.outlook.com (2603:10b6:806:4a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 03:25:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 03:25:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mark Brown <broonie@kernel.org>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
Date: Wed, 07 Jan 2026 22:25:11 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <F951C85D-87F2-4155-B592-DA3D53145957@nvidia.com>
In-Reply-To: <7b0330e8-e42d-4aa8-91ab-1098a9f89c7e@huawei.com>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
 <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
 <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
 <eba617a5-6d8e-4998-bd6d-e25330657380@huawei.com>
 <7b0330e8-e42d-4aa8-91ab-1098a9f89c7e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:a03:255::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB999109:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b8cdf9e-6fc9-4447-e8f6-08de4e658aa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|14052099004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0JUbEduRjBLcTkxWE1jc1A1UFlSc3duT3QrZDRVbXlMOGRrRVJudWFqWEpi?=
 =?utf-8?B?Y0pjODA2MVRjS25XVXpnditSTld5aElxcVlwNENFQnNZYkYwN3g5SmRkbjMy?=
 =?utf-8?B?cUJ2WFFPUlMrZDZFSUs3Q1FOdmI1TkFVSWVjNUFCZ1AyZGJFZUxQQnk0SmtE?=
 =?utf-8?B?Z2xnRXRqSjIzNFJkTjJweGpJVHFNNkdFZHhFRFJGUy9pVGdNRmxsSW5odWIr?=
 =?utf-8?B?cnhsdk1zclJabFl5RlpUd2NDcU56UnVSeHNNdlVIczQvK09NUUx3bTJWTlVQ?=
 =?utf-8?B?NHdHc2JkcEs0S2V5L0Z4b1dYaWVvclVPMmMyY1NBT3hMZzdQS2QwL0tnc21K?=
 =?utf-8?B?cnNOR0lod3V1Q05HWWJocFQ1dE05QXl1TXlJTzN2c0lJVDhwNjRGK3hDdWlz?=
 =?utf-8?B?Z1JFcjVrZERiZkpSNVhVWkJ5TzVhUXBaaTFVd2dlRCtsNkJrN3NMQXlOQ1dr?=
 =?utf-8?B?M1ppRWdBRTRGcnRNNHQ5TDdiYXZHazNMQktVakt1RmxZOWFXcnZzWGNyWWR4?=
 =?utf-8?B?bFpsczRhQ1MrSWpoYy90Nmt0THQ4RmtWSGl6RFd3eW41U3VUVVp6TXdBbXdj?=
 =?utf-8?B?aUtKWG5jRmg4VlppRmlJc2FGRGtkMDBabGFxakZST1dpTHNGdm1HN2FxdEZ6?=
 =?utf-8?B?bHc4NEhoTTh4aEpwK0FIN2h2MW05R3kxOWdRbm9XOVhDeWppZ1cweDU2MDNq?=
 =?utf-8?B?RHpiSE5PZFV2a3dSc0luMkxLQUNZczJrc2YvRnBGYWdUZVYyS0E3Um04UmZU?=
 =?utf-8?B?WDE3a1FOQVppSDNDYWdHaDlkVERSVHhVcmR1elFLZGVUQlpTM1A3T3Iyd0Ft?=
 =?utf-8?B?Z1VLQ3dIRGszMGU3RWdLTnV6eG82dzdmRFhWS09hMjZMdjd1bEx1UjZ5NnRT?=
 =?utf-8?B?M0lGUExnZW4yNzBkMDgybGI3cE1qdEJkNGJaazl2MGRIWmpFNzY5ZEIzVk82?=
 =?utf-8?B?MjVGNVN3aHIzTFdLTCt5NitsU3hZWFZmbmR2ZTd3SE5TdW1YcUtDenlHN2Iv?=
 =?utf-8?B?dlFIZFE5WExwa2J5bXkxQS9IaGp5bzkyNm1Ra2Vkc3duVHBGSHBGMWM3bW1w?=
 =?utf-8?B?U3c1MTRna3dmU0xzbFdyRkJQNVV3Ny9SVEcxVDdZQWRRU2g0Q3o4ZlVGWDFO?=
 =?utf-8?B?Rm8vQitKMVExSnhzMDVmMmxBUUN6UHBTNXB2ZE00VFlEaGdEd3I4eHJ3WTNn?=
 =?utf-8?B?K3V5VE5ZM3VyUnVuRWtoVlp1dXdnMFFWT1VsQXRMZGJoVkR6R01EaGk4TGRm?=
 =?utf-8?B?YVR0WE5nUkxjY1g4RldyZE5jWjlrNkgzbkF2SVJGTWhsemlZZEY4Q0EwT0pV?=
 =?utf-8?B?NllCZzlJRUhuNTI0alNMQmxPajZzNTZCcUxyNWIxeklnaFBtNmJFWXVLR2dm?=
 =?utf-8?B?UU12blNIM3d3L2VqNDViWEJBd3hMdjVSd0RSa015KzVIbDNpRi9mS0FlQXNV?=
 =?utf-8?B?Q0RBcVpXdzVHTGVkQS9LTjVNaTZ1dm4yMUxHSHM0RlVCNDQ1UlJVR2pERlp1?=
 =?utf-8?B?bEFENHJDSXZodXA0aWR4eUxZZCtpR0FTV3pzUHNIekZZeXZFdmVlbHpYNzdn?=
 =?utf-8?B?elpqMlJVYnRrVkptSzVoTmpFNWdKSUphYzhoSERiMkdqSFNTelIySVEyS093?=
 =?utf-8?B?a0JRd0wrbTFGZXkwczJkNDR2Y3ZPa0tld0JTMUFxeFdXVG4rcDNNK2N4cDVF?=
 =?utf-8?B?R3RUSFBVcGNtVXlaZnVnbFJ0clkxNVJLRlNuVmJxdEtTdkozSW1CZWY1UHJV?=
 =?utf-8?B?L3hzVVBoMThUNEhZbHp4aUx3U3JnQS9PbkJYQmsxdTFyYXlrSFlUTjB5eTV0?=
 =?utf-8?B?Skgyb1FNMUo4S1NGbnJwOC9MRUpqYUx4TnR2T05aOFhMNEdlWThyY3hJT0JD?=
 =?utf-8?B?S3prOGYzV2FrTEJOMVYzaWY3aGV0RzVqYXlBQS9LR3Azck5PWFIrQUkwck9Z?=
 =?utf-8?Q?cm2vfNpSPHkgBmmT5H9tufhiC0bllG7y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(14052099004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2ZhaldRYmNYUGpWREJRcC9yWis5K0k5amtQem9TQ1FqZ0VITG9RK2hRTmU5?=
 =?utf-8?B?dEx0ZGZOYkgxejVhTWYvT2RJbHZwcXNPS0xZMi8xclhEN1RLeEMxSSt5RnlR?=
 =?utf-8?B?bXZ4b2VPeEdGeUhPZEFFeE9rdXppQjhVVWVuUTlYQmIzRDFMWlk0U3ZXQUhz?=
 =?utf-8?B?b0h2YkhCTm9yNzZ6c3lRSlFyOXNPVDFkVm5PQlJhRFltR1ZTelBzUHJWK3Jn?=
 =?utf-8?B?dmxIUmszbTFlaDdjU1Q0Tmg3THplUFluRGJNRTcyekdyaFZVVWlNSmJMbDNL?=
 =?utf-8?B?UFVJY2RYZUhhNTBkMEFpNzluV01RTFBZZlFER3ZPSTBSVkU0bDZNWklrMnY5?=
 =?utf-8?B?MXJLN1pwVDM3TmM2RTJSTWVEQytzb0FIQXpaeDA0REVPYjNuYklIOHJNRk91?=
 =?utf-8?B?MlFlWHRkNEVJMGczQjR0VDNOUUZBWk5CT0Q3T1NqWFNabWFXaEU4Z2Z4U1J0?=
 =?utf-8?B?Nkc2ckdJWlU3a1dkQmV6V2NsdFVxSVdyQmJnVWJ2ZEtDRVg5aSt0bEJRK2lr?=
 =?utf-8?B?SjFNTlBvTmpEMDRza2IvZ0k3TkUwN2ZaTVozeXdTS0FLeFd6RWlvc2Q2WlFB?=
 =?utf-8?B?MUFESzhLWVF5QWE3dU4xWGwwZk83NC9XR0RXczZTMHpCUUZCRWN2dXpyV1gw?=
 =?utf-8?B?UXVLakdFVGdOVmQ0cTltRzIxVVZ5Nm5vWGJMRnpwTUhEU0pvWCsyc2VDRCtO?=
 =?utf-8?B?ZXZLN25Kd05vamMxb3QySEtlUGk3RU4ybC9YZVpFNFFGYnVZQmNKT0tDS0ZR?=
 =?utf-8?B?a05HQTE1RnB4L0pVbHhFU2NubTFwOUFmcjBUUEJvbjRaRi9NODBaZzk0UDd2?=
 =?utf-8?B?RFppdEliWVllOGxjcmFrZWJCTThOL0RQK3NvbWJET1FTNlpCQm1SMmUzZ1A1?=
 =?utf-8?B?ODBteFIyQWp1cjJpMVUveDVZM1FhK2Rjc1RnYTYya1FYdjRzRDFiUDN6cmFa?=
 =?utf-8?B?Z0xiRVJnQlBGZmlKR3ZJQ2Q2TXBYc2ZSc2hYNnozY1o3OS9wYkVSZ0l1S1Jo?=
 =?utf-8?B?Y2xZcHc4QldGVXhia090aDF5cm11M0pSWHVTSzBraGh5bldzL1hGdW1yRWxo?=
 =?utf-8?B?MjRQSE9DQ2RwMytkVHg1VE5MZXpvNFdLRmkyLzhHQk5lbUNvRjFDYUZaSjkw?=
 =?utf-8?B?YkswcDAxelJhQW54OFozdlppeS9STWZ4MzUxamJKbktrL2NsbERoT1NEZmFT?=
 =?utf-8?B?RStSUHJUc3paNWp2ayt3Vk1GR1NjcEZUSDk3K0hpM0YvcGw0cUxjY0UvSkdr?=
 =?utf-8?B?UUlvNlhIZEhQS05WMEU0bkZlN2o5VXdTUXFNYXY1Mjdyb3d5Tm5VQklqNHY5?=
 =?utf-8?B?VlBCUVBseUxyZzNuWWkrZFFjUkx0OWlwbHJTbHloZ1JnZlN0OUtKUGNPWVQv?=
 =?utf-8?B?dDExTFpZWDJPVUtBQVN4blFXbFZIWkMxUE8vbHN0d0J6VzlZUldmaTYxM2Zt?=
 =?utf-8?B?NkhLNnd3ckhqRmQvMXVKQVZ2c1NSczdPaWQ2Y25QeVZCTGhMMWZFU29FN1Nt?=
 =?utf-8?B?cVo5UEFWcGI3MXMwbFpLZFAyQ2M0RTAwcFF2bkowWjBOVjVpTGF0MzFMU2Y1?=
 =?utf-8?B?dW5qSWhBQTV3bFllcWtOM3NyK0UxVXdtYTZwVkxaK1gvSDRzenJEVUVRRGV0?=
 =?utf-8?B?Nm9qZFJkVFRjQzIyb29qcDg3S21PVXNidTQ2NkMyQkY4M1QvRHBMMG42Zk0r?=
 =?utf-8?B?QSt6L1RkUThSeGZlbWk1ZlFMSWNPVTRLZ3RIditpQ2l3cGpRNVNhQm9CdmhK?=
 =?utf-8?B?dXRCemgraWl0Q2hOTzFvNVJCRThFMGFSOXNqRkpBVzBjdU5Ea0xPbEswR0FE?=
 =?utf-8?B?SmNHZUt5OTd0WUUwS0lCbTBoTDFXUEZLYTcxZVMvaUZsN1BRbVIrM0ROSGV2?=
 =?utf-8?B?T3E2VkxBcTF1RHhVVHhvZGVxc2hEMVZNL0UyclJIeXlnNG9lSXcwcEt3Ti8v?=
 =?utf-8?B?elpybkR6SmV1VlJxd2ZPTDV5RXRvTzB1NFNkcjZjMmRzbGk3MW50NnYyaXB5?=
 =?utf-8?B?dUtObGVQVXRSdlhZd3pCRHVQSHp3TThyVm5ydXVKNGZ5ZzlBdTNicHcrV3Ju?=
 =?utf-8?B?SVRVRlVZZi9nYWFRRWg2RnJ1elpKUkFDWjI5YWZOdmw2SVpGbDRPMC9FZzl5?=
 =?utf-8?B?M1pGMnBoZjczRHB6RkowL24yMExHMkIrWnlzckVGV0lqSDBTaE5JMk83OWI0?=
 =?utf-8?B?Y1ZtQnRhNVRHcUlXZFQ0SWE0MUhNWldiQ2prNFIvT1E3N1VBRTNTQVpMdkVO?=
 =?utf-8?B?b2E1Q0ptcVM0UUdybzFaaGNIblY2UytuSW1BM0xxK0x3bEkzaWhVTi9WbWE3?=
 =?utf-8?B?cVFVYk5uVU92aVY1NlhyWGN4UUFMVFlWK1NqMkhnWVFvRGJFWVdzdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b8cdf9e-6fc9-4447-e8f6-08de4e658aa7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 03:25:15.8977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AnMnSSoHZJnWnv0JUyH63Qxw3H9lM5kYKXmYvP3lekfwE74C/oxUrEniN6HYu2M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999109
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C612180003
X-Rspamd-Server: rspam10
X-Stat-Signature: p5i1nm7f51bjrw37wsrk3si4zk1wiqjc
X-HE-Tag: 1767842718-356916
X-HE-Meta: U2FsdGVkX19MVyCZY/Xb4rwits9SzCjNu9Rw6cgllBf+M1qLNIAGstQcw0rUFn2pg2iluFtxweS93t4ppxz3SPP3xx/hVE3x95miZAxN8UtDFWNnPMscDU4xdf3xTl8je5mpHVHNYNB2J+9CBV30/r0iKkufGjyx1KqKW2su3/TeKPvb4i29ubeykuYjwzDpWGq2nzZURVaKsiIhoDwoHK1AY6ORm5KbeHtn3gViumObihWcP47wTdI0Z3JRJGHoBE6sdIWeUUybflEdlmrvoJmJi2AJqqKIfCkcGzSQ4XCxi1Ow/J3DAETT46t/O2Ty/7IMVv1RxK3LruM2SZiEwfy9bG/nsbn8822SO72pxwcrvqWdhStIpB283apF6uhRHkd1UhEKkD3EJCObKtrF8lhKr+xxRSvf0cIGGlc2eGXd/MpvucdSlhQFdjGz4cATqKEZWvaBq1f/1IMDKdMVAZ60Aw9RnO2wTaXLOJR5Fpro0M20zUNR7F/JHQ94/nhQVfIMbY/nGQPNzL6ARW5pCnf128gqT+MLNzMc6OrbAzruHoVWdesv8E5x6lzS7fTUDALrGcAbEHkQjRezo1v+RGs7U3i/7lOvpntkIIy/6Bs4XCyXLHzJGwDA9yrJdEOIHwg1L8fyi2PQcpJsTOdQk2dKBsJWznFhNiw8kwwgnOisg/yS4vfQ8Cq9gJgVAIDDxQBAoNiGIgJtgn+6RBCMTn0GpQ9G2YG6kWXUNY7Zf8Gxi8eCCeUEnpJ0cH1ptWMv1YKIOz6y51sjR3oUslP9F+Cptk7I4fubUAyCQqbRsV5Bd/A1tun6LqS3JvU+BSxY/1t9MMBYxrDF9f2+iQ8wFJVCLmTfSC1jpkjnOdAfKInwKIBk3baz13mHTfwT/hvaDDBkTXBXZ4njgZNIkGOlSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jan 2026, at 20:53, Kefeng Wang wrote:

> On 2026/1/8 9:05, Kefeng Wang wrote:
>>
>>
>> On 2026/1/8 3:38, Zi Yan wrote:
>>> On 7 Jan 2026, at 13:39, Mark Brown wrote:
>>>
>>>> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
>>>>> On 12/30/25 09:24, Kefeng Wang wrote:
>>>>
>>>>>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound(=
)
>>>>>> which avoid atomic operation about page refcount, and then convert t=
o
>>>>>> allocate frozen gigantic folio by the new helpers in hugetlb to clea=
nup
>>>>>> the alloc_gigantic_folio().
>>>>>
>>>>> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing =
suspend
>>>>> to idle:
>>>>>
>>>>> [=C2=A0 129.636729] Unable to handle kernel paging request at virtual=
 address
>>>>> dead000000000108
>>>>> [=C2=A0 129.644674] Mem abort info:
>>>>> [=C2=A0 129.647456]=C2=A0=C2=A0 ESR =3D 0x0000000096000044
>>>>
>>>> This is also introducing OOMs when doing at least audio tests (I don't
>>>> think these are super relevant) on Raspberry Pi 3B+ running NFS root
>>>> (probably more relevant):
>>>>
>>>> [=C2=A0=C2=A0 64.064256] Unable to handle kernel paging request at vir=
tual address fffffdffc1000000
>>>>
>>>> ...
>>>>
>>>> [=C2=A0=C2=A0 64.087583] Call trace:
>>>> [=C2=A0=C2=A0 64.087586]=C2=A0 kmem_cache_free+0x88/0x434 (P)
>>>> [=C2=A0=C2=A0 64.087598]=C2=A0 skb_free_head+0x9c/0xb8
>>>> [=C2=A0=C2=A0 64.087608]=C2=A0 skb_release_data+0x120/0x174
>>>> [=C2=A0=C2=A0 64.087615]=C2=A0 __kfree_skb+0x2c/0x44
>>>> [=C2=A0=C2=A0 64.087622]=C2=A0 tcp_data_queue+0x948/0xe50
>>>>
>>>> Full log:
>>>>
>>>> =C2=A0=C2=A0 https://lava.sirena.org.uk/scheduler/job/2341856#L1721
>>>>
>>>> Bisection identifies:
>>>>
>>>> [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_froz=
en{_compound}()
>>>>
>>>> as being the comit that introduces the issue.=C2=A0 Bisect log with li=
nks to
>>>> further test runs:
>>>
>>> Hi Mark and Claudiu,
>>
>> Thanks for the reports.
>>
>>>
>>> Can you try the patch below to see if it fixes the issue? Basically,
>>> in cma_release(), count was used to drop page ref and decreased to 0,
>>> but after the loop, count becomes -1 and __cma_release_frozen()
>>> is releasing unnecessary pages.
>>
>> Oh=EF=BC=8Csorry for introducing the regression, my previous self-tests =
were
>> more focused on the hugetlb part, I should be more careful about this,
>> and thanks Zi Yan for the quick fix, I will do more check and test for
>> the non-hugetlb part.
>>
>>
>
> Based on the cma_debug interface, I performed quick tests to reproduce
> the issue before Zi's fix. With the fix applied, the crash was resolved,
> and no other issues were observed during testing.

It seems that the series is dropped from Andrew=E2=80=99s tree. You probabl=
y want
to send a new version with the fix folded.

Best Regards,
Yan, Zi

