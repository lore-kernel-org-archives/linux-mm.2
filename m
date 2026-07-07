Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16177C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15966B009B; Mon,  6 Jul 2026 23:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC62D6B00A0; Mon,  6 Jul 2026 23:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66456B009B; Mon,  6 Jul 2026 23:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72E9B6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:04:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE0A21C7C18
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:04:03 +0000 (UTC)
X-FDA: 84960486366.19.919A082
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	by imf21.hostedemail.com (Postfix) with ESMTP id 39FFB1C0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:04:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dyH3vsUH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.60 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783393441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKReyStzCu60GUZcWwZ29FnEijq1osKolLGH9MuB0rs=;
	b=ujOi99jd3KWSueh9xq+0FtmjLV4FMaX8pAkSdciQy0GOfh8cMfWWXe0UKdvELTO8jJ7Us3
	PJiOoTEPHSb1+udU5Dp815gxWxFeJeyxZ5tAlLOPZpO3/OEoFf85O5sO0dfIcZ+BVtrQFR
	d27rffkWsRv712f9tQDOC7lhhmcGwpk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dyH3vsUH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.60 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783393441;
	b=qWidhxdMa51FSdtpoRWKU774GeDBZ21IlbwdysmnmgNEREOh6H2IQGEudG3SjtpoknQnog
	+mYh0g6fd7eM0yfUG+O+SCQksybeJFVwElhc6gTVJOIO63PoL7hGgAxGaFDEBCB6KFiamI
	AoHT2vYITwdgy5lD2b2vH6I6Gz+iFwk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9hqZc7RW/7sVmXFtDa4PVrqWzzhJjeAo3JDKrUYEr7IlKKRgeMWDIsnSef1YvyJ6UTYyfjrgB0YLNC8SnAFYM6VsDT58dH4IRmBSAC+9d2FNGRo75PzjYlin2jWkBc9J6pFMP3fAYS0B1xJmQ77RdfTW0tLwdKLjj4Ft0aBcsPgM5qt/XNbUiuZ3LK0IvRb7qrdB8OzGbMIyuKmiSEhbC8bZ7rXpe3KafY6KWG/+OLLqhL9XgvhnzGpOZ06DohCtjN3MfXeAaixwvEG3V5JYnMf7JdkvXPeJu0/9scT4e2dGB1gf9em1QcY8JTwvNFTVFwmoTwSaP5K4/lixsfJMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKReyStzCu60GUZcWwZ29FnEijq1osKolLGH9MuB0rs=;
 b=Jom20b1E/HBeTU45pSrHATUNxJRFfMeoR60D+Qmq+EUOJvxqplh1l7rzSSPYMkhwh9b6dW5bEVn7lNPuTiPIy2Y784cqmqnBd5GGI8qCXAmQtWxBJYhpCxv/CE9IvDK+WakkkFT8Aljq4AbSqF4eDMKSnOU/s22SbHjEJCWaM8sgggPJK2lPanUlW/2uEH15IZ+SZJlVi+If/Yncr//ptteiZL95t8wQQW1UQuWyst8yDeTAkWFdNTN1bz15B7OPvZ1wCywy64hrniJtKJcrz58k4Hrx1o3GYg2zsEWcmEqx5rAGpCPTZp7SInyg0+St1hzRkdwCapjlbsYKPckWCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKReyStzCu60GUZcWwZ29FnEijq1osKolLGH9MuB0rs=;
 b=dyH3vsUHtMoEr6pxSrhrFj9yaoPxJLjsRx82SataptDX93hAEtyGosF5vEoy3dmIBHD3Hw3x2yXqBB4e5riisYpgH7a6ahrQMBcwlPJYLgPZa1BO8HEP8uiIEQ5qKthMIk3NWcw6G9MIG/ctcVsNK88hV62HfaMhj+GXwxyqYPGieTzFeD5/LhCWhDRREKFS0pZ5Ckoqfc4QqJv22Xm2cX1UYo673CdZPFVUtww4jLmKdGYghqaRxPKtBbBk386fyKxtqH0cI0qVYuh1SD04qGZqfz5FoobuMFMEkUFbHC9lnXvh/LTtE8MU7v/XsCY8IB6d5q5oyOGS4aUYz2OiEw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CYYPR12MB9015.namprd12.prod.outlook.com (2603:10b6:930:c8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.8; Tue, 7 Jul 2026 03:03:03 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 03:03:03 +0000
Date: Tue, 7 Jul 2026 13:02:52 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org, mingo@redhat.com, 
	rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v5 4/8] mm: add a template-based fast path for
 zone-device page init
Message-ID: <akxpS3WOP7oUBNKF@nvdebian.thelocal>
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
 <20260701090553.62691-5-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701090553.62691-5-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY5P300CA0018.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1ff::6) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CYYPR12MB9015:EE_
X-MS-Office365-Filtering-Correlation-Id: 690283d6-4620-4bbb-64f2-08dedbd44286
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|56012099006|4143699003|3023799007|22082099003|11063799006|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	lsIn/MetmaGZ/SKIlKggkkrcL0LpzuSGbzYVA5Qz6A+dvvlxIjfpx2hjifcez+uYQcclebjPQ7VyIdh271PzPQ/R2QBzPBGdnDE5A3YStMeVxTHmRERXefYVqMrU+bPPLxV3uzrY3/D6YrxjAgO7PW5yD1TIXvH1hramph6nzr9K7xlFspVMzoyZyfFZzoyWWIvZN70ruhv8RVp+nsGXEsphugHzro7ShpWAQJ8BSIhs1DThLEsiutZbbhNqd+1Tg2fuVGhv7c8pngYkRSDof/GfkgHeygy7bck2v+UB9BNbcN9nFQpD0nbcWkiU2vPGKRhnaFje8kkuZ1RF8joluKhvloAkV+6jOnpYUXtM3IQIN9YpmcPNzdn/pw5JxvZGq2Q6YZEhBhMf972syVXtALoCWb91BCEPjJhcWsd2gIMTSSNfp8iFU9GItr+v6QsqfAvR+Ap/msMmgpKetM0GwHnY2BtJIuFNCiXzcM3Iascd4pnJwHZDPcFnI6f9X25/0/MH4e3Bd/SOTbApywagQNGpA8vbh68q3R2msz8rJu92hmFo3zRoopg1ooMK05jvCXG7V17uvJLIO5FOcv9vtG37wbKR6tAeM1W5J0s7Ypee8889np24DpXA1rlhKwY3vAAMKoSZvHD7JaevvxEsQeJsy9JFKHrBrDDA1gHheKk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(56012099006)(4143699003)(3023799007)(22082099003)(11063799006)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QP6VkFD+zMJXEL59T2OntIxXv34U07I0Mqh47+RQteTDi5S/vZvPZ47tyX7u?=
 =?us-ascii?Q?zsJsJg+DKKxB8euv+OvQimP+TQM3FQ7VLrlidpyTp+VNJzSFF8C+DqSEfOYy?=
 =?us-ascii?Q?zc66K5bx+gVtjy2TI7mSBbYQSth4+V/IqONIc5s+bVi/AooEvGrdf5rggCfB?=
 =?us-ascii?Q?zJiIvKLdkUrVmsg1bpwFskjqkWEsKIccIbsQVDkn96hjDYK7QewJsy4nXMCk?=
 =?us-ascii?Q?9KVniVNgMSANUz/qrdt1/q3CMA0FSrfa2QPt3NIsirT8NloaDowqyXve5HPl?=
 =?us-ascii?Q?VJZm5Kcsaq+6KS8w4vjgCZE4nyy2b4UQVJ+V7hyvM3N9Zb9872mk/KtuVxsi?=
 =?us-ascii?Q?cEYsP9luHPSx28Qybxu8HfaGpjaxVIZu42B25nJ1ToBAt6wSCjaso9F/3XN2?=
 =?us-ascii?Q?l0/0Xc39rv2+lk+qyzPU+jnkxzhORJIZjKbhmx0/HTa3zs5395c4hoWTnqui?=
 =?us-ascii?Q?tO5Fjah5l/rDDH9tWbIQlPtI+AQLsUHBnxRe0iv1ObaT+jwy6bI0Ea7CwEFm?=
 =?us-ascii?Q?97T4SZaSBFCjr+23hj8PyRnaQGg/3k2jgUYsKK/eV7tEofAvFHJwAoep3LF6?=
 =?us-ascii?Q?Cv8vhobkp23dEUe0L9NQjU8enn4diLykwYAB83xGFiFjCoRB8++bc+6jVvAd?=
 =?us-ascii?Q?2k3C9lQrY8Cnr5gwmogL2/5SRg0704J472u7aMQIeciCbhDZ5HWBZBKSoxd0?=
 =?us-ascii?Q?svqf7QTTPQ9awI9YmHnAEd+j0OC8lR1i4W/pJoj7URe8zZE2KVZt5zo1FPk0?=
 =?us-ascii?Q?DISy2Jf6CQPjUQ/jgYPfCiUpwULbkEPuv/6Dsb++6hbSMxJLgUaY4UDoXnEg?=
 =?us-ascii?Q?QcRWotCQqalRrqrrNbAD5415b1iCArdQBT1SuABvIX+O8JFkQgZKS4mpSz+T?=
 =?us-ascii?Q?c6OtKmzxuBbIOCijADBRJ0+1uaDsDANwSmp53DLntOvbEZd7xEMAxkrIiLEm?=
 =?us-ascii?Q?zdLaavnp1LL4IZli8vIhfuTOhJ08CoJ9/IChjc5MsSe+eGrrtAvAKnUdl8u8?=
 =?us-ascii?Q?h9aYFaN/x55ncGkaOgq0XbM+GBZOoa3+DUO4b2UFDQJf/Fu/9y2TJatMzbQx?=
 =?us-ascii?Q?6Km0jNQTnts2WDcpMQ+Pfo7Jy2aDQ4gAB8pUUGr5cnCbqC3+szOOBkkDqUHt?=
 =?us-ascii?Q?yjkNTb4DdKUGIrTFWO5O3VyWOWddBcTuUzN0mIBKSSLgz0o7+/m00RVyKfqT?=
 =?us-ascii?Q?GEtdAEVDuMK6IzSuNUMdSTR3iptpLIfV9u+FmK1lBrzDcs3BdrYOWTvYQDNm?=
 =?us-ascii?Q?EYBhgTgUfSneBQcnYvUYUKbFn8wR0P919/kqol3zhAVuGUvhxyiMtGK3gtX+?=
 =?us-ascii?Q?3lU2wHq7BZSR8V5T50slxTKqhmp3zAYiP4qHxHgR9hQaWCqmEWF/cbA46cYb?=
 =?us-ascii?Q?WlBuDdEGzHH1ytCmkZBxJqb/H67EBxMwHRyDpOifhmyULirtXRTKPjiyeWqp?=
 =?us-ascii?Q?kzHgRcHcdfTWjE8hPiinYvu8oOdx1bhO7isSnzH5HXcNtjLjV7O9zdrSdw5q?=
 =?us-ascii?Q?swTFUvluExbmcvVKPM9aMU2fNcuc7+nj/2pF3nG95Q6oiGImx79y1iNIcDrV?=
 =?us-ascii?Q?1SIXJSxhpVbzMtqNbbJjybVnHJ93zeiLp+SC27WhWytwgIqwjIyrgUOh+wwj?=
 =?us-ascii?Q?e19LBkKJ9XipjSZDECSKLlMbOu2XQNWKb5FDJAymSwNKS6LYjg9xDdLbWGfa?=
 =?us-ascii?Q?HWD+dBse3O0TkzUdSr4b8pTXA7/D4wd0dvGQvJaY6whNLAEnFPTEjtgXU/pT?=
 =?us-ascii?Q?k2QzEdUz2Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690283d6-4620-4bbb-64f2-08dedbd44286
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 03:03:03.0375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ASNhkDSyU8YBg43XP7HjYM3fVMgwa45C8T6rc6LhmqxLU/BW1XDMy1R065JQlKB3rH3CSWD2d+UBfuJb4Jz0NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9015
X-Rspamd-Queue-Id: 39FFB1C0002
X-Stat-Signature: e4ir6b75efuru4snhq3fwcjofdr4e9y5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783393441-987867
X-HE-Meta: U2FsdGVkX18ezJHarLXicMQKfSdB3lbRftLUMZ2UCzRfIQDGKHiIGq2Oh4TeJPZama7s6fNdX4qxmFoU/Ir+r+P/lerHwcFfLmBvr7a2QPh+MeuCULZvFkjoIABLK3BnxkI54f0xTjCJ5L1bdSIc4WlH97AlpYmKA9AlR7Yeb/qMGDiqnpE58Bg8iZ99b/Jw8Uv5ZItHZL/46MifO7AQ7+DcpA7di/B8SLxGxNjV1tkkj8QMbXzGG7dTjidYjcj+Jd9dHPtWRqeUBTjQJk/L4BYbT6FuZ4Ucl1TGAhh2GAD/IgkrMNsfC7a6+FjJRO2sK8fW4rnXe0T0gkcLwSeATZTXCAoakb/lDfja9x0q5gbXX7YOnUj5wPTtcAnIpRO5PczXJFtr0iY7kvoZc5r8hI6LEmS1GrU34X38gt5UUPUQArB7vFCDAa7WnCyoNIWnyZ11r/CkFNPYTqGcm6gVK8ni/vBvytUN4gFgyHZsLrwk1oy9z9fxCWkY2V8xOcr37+nzVIb/3PmajNz7P7IyMHEkk2+362eyJgj2o6xVbZG9I1202WNZ++W/tZKcyTzwRwvw6f58U1sUIWLQvLqzPTZy5CnR92V9ZS2NxqEgGkYrTNhT1teaoHgw12oUng8FHRox5blLN/OV4C9HS3b1hkcgxbY4SwzNaMJGdsUwEwgfbKpHuXSf1/h8RpKcEzbPA30XZHmWo8mMV+9s/gZIycXBxY+cA1xB0lnsZ7sZDkKnKGoebSOWgIqjR70WSsjqNsCYLdLxsZzwoQP+7bQJTBOKr8FsNjEdIBzPTbDhc53p2OoTOtZyI2aBvjHD+DA0dq/pHVsq317mtCRSOn+/MGP+0e2F6KhJ1P1w1k+E2GE9af+CmHVtcThWxbkhxCcR6hLb1jtiSBOTWK2MVXOkv/T8cxeyXihPBeOjBY91sOyqmFIkQi8R6U1BtwGCxNprWs8miGtZxkSaRlHo+8S
 A6NQc3dt
 5zlAdtZpvTThDmUMRXqCLturFhOg6C/eIBb/Qj/NSlCmJ/+jU7HfhHvW05TF+1xRgTqW3OpD4FDDdmqZH/t8vOy0xa3ELgVqGUSulvhFjlwcct2o/F01/6QrOvUbIDWfrZ8+6vvdNQ8Lrt9PoF1shwQR63Gd+l4NykNV9RMcfJ+O5YZBhSzp44o1pK522fCy5EGKArQQvwCRZFGrqAzyhSuBtcTP48fpFya7/rogJ3S6RxDcFBOUsWadS7X7+usM6lbxTkswrzxmnwQRGlxFtfDziVINWl+LZBCq4dkCWbRykA8ke98otYyvN+3oGamOY0do4ydDSlH4tAno94QYwt/O8m9tBmhuxt0K286buWc/fTA2Vnm0AIlfelk3YIjLTx7hBapB2K6/+d0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-01 at 19:05 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> memmap_init_zone_device() repeats nearly identical head-page
> initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
> template through the existing slow path, refresh the PFN-dependent
> fields in that template before each copy, and memcpy it into each
> destination page.
> 
> The optimized path assigns _refcount through the copied template, so
> keep it disabled when the page_ref_set tracepoint is enabled.
> 
> This patch accelerates head-page initialization. The pfns_per_compound
> == 1 case gets the full benefit here, compound tails are handled in the
> next patch.
> 
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
> path (pfns_per_compound == 1).
> 
> Test procedure:
> Rebind the nd_pmem driver 30 times and collect the memmap initialization
> time from the pr_debug() output of memmap_init_zone_device().
> 
> Base(v7.2-rc1):
>   First binding: 1456 ms
>   Average of subsequent rebinds: 244.28 ms
> 
> With this patch and its prerequisites applied:
>   First binding: 1440 ms
>   Average of subsequent rebinds: 217.19 ms
> 
> This reduces the average rebind time from 244.28 ms to 217.19 ms, or
> about 11%.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/mm_init.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 4c7fad440c2a..cc8417951467 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1066,6 +1066,50 @@ static void __ref zone_device_page_init_slow(struct page *page,
>  		set_page_count(page, 0);
>  }
>  
> +static inline bool zone_device_page_init_optimization_enabled(void)
> +{
> +	/*
> +	 * The template fast path copies a preinitialized struct page image.
> +	 * Skip it when the page_ref_set tracepoint is enabled.
> +	 */
> +	return !page_ref_tracepoint_active(page_ref_set);
> +}
> +
> +static inline void zone_device_template_page_init(struct page *template,
> +						  struct page *src)
> +{
> +	memcpy(template, src, sizeof(*template));

I'd drop this function and just open-code the memcpy as I think that ends up
being clearer and removes a naming confusion - I kept mixing up the purpose of
`zone_device_template_page_init` and `zone_device_page_init_from_template`

> +}
> +
> +/*
> + * 'template' is a reusable page prototype rather than a strictly immutable
> + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> + * the current template, but section bits and page->virtual may still depend
> + * on the PFN. Refresh those PFN-dependent fields in the template before
> + * copying it into @page.
> + */
> +static inline void zone_device_page_update_template(struct page *template,
> +		unsigned long pfn)
> +{
> +	set_page_section_from_pfn(template, pfn);
> +#ifdef WANT_PAGE_VIRTUAL
> +	if (!is_highmem_idx(ZONE_DEVICE))
> +		set_page_address(template, __va(pfn << PAGE_SHIFT));
> +#endif
> +}
> +
> +static void zone_device_page_init_from_template(struct page *page,
> +		unsigned long pfn, struct page *template)
> +{
> +	/*
> +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
> +	 * page. Update the PFN-dependent fields in place before copying it
> +	 * to the destination page.
> +	 */
> +	zone_device_page_update_template(template, pfn);
> +	memcpy(page, template, sizeof(*page));
> +}
> +
>  /*
>   * With compound page geometry and when struct pages are stored in ram most
>   * tail pages are reused. Consequently, the amount of unique struct pages to
> @@ -1121,6 +1165,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  				   unsigned long nr_pages,
>  				   struct dev_pagemap *pgmap)
>  {
> +	bool use_template = zone_device_page_init_optimization_enabled();
>  	unsigned long pfn, end_pfn = start_pfn + nr_pages;
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
> @@ -1128,6 +1173,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	unsigned long zone_idx = zone_idx(zone);
>  	unsigned long start = jiffies;
>  	int nid = pgdat->node_id;
> +	struct page template;
>  
>  	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
>  		return;
> @@ -1142,10 +1188,36 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  		nr_pages = end_pfn - start_pfn;
>  	}
>  
> -	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
> -		struct page *page = pfn_to_page(pfn);
> +
> +	if (!nr_pages)
> +		return;
> +
> +	pfn = start_pfn;
> +	/*
> +	 * Seed the reusable head-page template from the first real struct
> +	 * page, because the existing page-init and pageblock helpers expect
> +	 * a real memmap entry rather than a stack object.
> +	 */
> +	if (use_template) {
> +		struct page *page = pfn_to_page(start_pfn);
>  
>  		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> +		zone_device_template_page_init(&template, page);
> +		if (pfns_per_compound != 1)
> +			memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> +				compound_nr_pages(start_pfn, altmap, pgmap));
> +		pfn += pfns_per_compound;

I think it would be clearer and less error prone to not unroll the loop here.
Instead just initialise the template page and leave the for loop starting at
pfn = start_pfn and let it handle the rest of the steps. I can't imagine the
extra call to zone_deivce_page_init_from_template() would cause a noticable
perf impact.

It also avoids the obvious danger of someone updating the loop but missing the
unrolled version above.

 - Alistair

> +	}
> +
> +	for (; pfn < end_pfn; pfn += pfns_per_compound) {
> +		struct page *page = pfn_to_page(pfn);
> +
> +		if (use_template)
> +			zone_device_page_init_from_template(page, pfn,
> +							    &template);
> +		else
> +			zone_device_page_init_slow(page, pfn, zone_idx,
> +						   nid, pgmap);
>  
>  		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>  			cond_resched();
> -- 
> 2.20.1

