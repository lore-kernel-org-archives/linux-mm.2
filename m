Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3195CE8D4D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A5E8E000D; Fri, 14 Nov 2025 11:12:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221C68E0005; Fri, 14 Nov 2025 11:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9B58E000D; Fri, 14 Nov 2025 11:12:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF4C18E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:12:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 997EB12DE51
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:12:24 +0000 (UTC)
X-FDA: 84109705008.06.52D6D44
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	by imf29.hostedemail.com (Postfix) with ESMTP id CC69C120016
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:12:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BirODJAV;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763136741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNAbC36QhtY/RAEKm27eOCa68Qc4SCla8xlAH19tQA4=;
	b=diIGkP/0L/Q+2bp/AKsDQCJKoSxI3gXGZJYn1ig9TX72zElRXhejhPTHCpXTf21xeLpRzp
	ssVMl6B6tlbTVVNVzy8jjsk2nr6hLB76Kkq6T2wC52p1RQwYnOCXAOz/etUe/ber0+y6ob
	hInLfYpU3EQscHBkGpuCHRAyXWDOebw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BirODJAV;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763136741; a=rsa-sha256;
	cv=pass;
	b=n1bgyxCpJjk+RdErApY9t4uh5k3Hgy8Me+US+sPG9/qvjSQEWCsVb7iOweqCe9NrJRmkxV
	Slu/NFlwCO+0BLwfnNqqKjC1tL8mPFLgv/wOXv1tl1jKxwxsXSEAfcDm/HQ/wmz/JvHM4W
	a3zJ+pa4xiDXtacR6ifdZkoR5n5ULQw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nOTaJuNzvdwCMY1wtJxuq/Z648oYdnTOAn/SggNlVAFxY6dSUWZp9OjwXxZdICtPhX5X/Gg5svw6C73aKHGaqW8LHQj8H30zNeMFNHdNT/tP1od+Gakz7RnmteIQ5n3PgEFlvyWzHg2FsWJtrZdtT564FDPHXRWAs19F4WySkzZqUkX0XgrTXelC+jq53kqPfCLSCpzGh6d3+39/CYpAuYX7Enk2yzwCOmM3lHHHycSaXM+kjv1njXLRpUPiijaBveVcBs+E99lUiBto0zjfZGXXV1EtDzG7ySszaOU6luTzuJg0M5u63ovI/bcdSgNgyw61xr5vcH5Wx6TtMh27cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNAbC36QhtY/RAEKm27eOCa68Qc4SCla8xlAH19tQA4=;
 b=djcBoLrbJCESIBgewLs7SccTkYUshxoUMr58Ur6k3AR5Q8Y4EexpP4IclatFWDzUYcvyRzu+h9Miydg2bkrkbu638h9q89tFpKxDNxMpDet9bF/AIwLEEbImsaxzVBEbxOigMhbZJ+7ts6OGYj6M7cLeU5WZhT6d8JcnwTFXwrbUQWjvT5M8epzGcDbk8fBm9yp/o4Ic1T2C48V0o/uJ3QoTr6CGdKzN7epZ/MLCpiA00beiFXCqr8PiwfjcoxYF+dUYWBWR89Bvnxq9vKRhtfy1QfdQpLIThO8t/VNZyhXhPFWzJWaZoBLmBdrW7hDOOD9jC4XMI9mZJUohQIEmGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNAbC36QhtY/RAEKm27eOCa68Qc4SCla8xlAH19tQA4=;
 b=BirODJAVPU5MpNc3cah6pMHZbxtN2hCrexiaXiyEysd5KvsrrImnueCmABXPWXl6hZpQmla50YDYU+PxyL8B6bYD2kDpxgowbebWukkbQc512deXJujMMkPhhMi6S/Xkj+QxNO68vecnWYDmJzxMePXPL1AQogNPvDlf/d3DUiDb+XyybU0FIgPexxTpoUMty1pMxn2DZ5cwC+Iir7EY93eyj+uIhug0SY1M9QyxWr3HC4RMQK3s+AKy0xPCIJ5U3i7vx4QKsi4zf0FNvXAHaqhKawcPE/LMQe079IAP3LISqS1P4Qh0P6JhG3I0pUF+XRwldS+ziAlPiNlKALfDwQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB7293.namprd12.prod.outlook.com (2603:10b6:806:2b9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.16; Fri, 14 Nov 2025 16:12:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 16:12:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: fujunjie <fujunjie1@qq.com>, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: optimize lowmem_reserve max lookup using
 monotonicity
Date: Fri, 14 Nov 2025 11:12:16 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <912CFDB8-6374-4428-A0F2-29FB00E6ECE2@nvidia.com>
In-Reply-To: <DE8F7PLNB92Q.1L2EKEK4C6TL5@google.com>
References: <tencent_ED235B379E160A5C2BCF688ADDF3921EC808@qq.com>
 <DE8F7PLNB92Q.1L2EKEK4C6TL5@google.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:335::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB7293:EE_
X-MS-Office365-Filtering-Correlation-Id: 0538789d-114b-4c63-6d02-08de23989579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GhxRG7j63CIR2Cty/WjAVvLyenh0NB1SWKkOTbTZEhnbp5YjAvtT/gdhYW1/?=
 =?us-ascii?Q?/ja7w75lV3DRDzi/NXGqDzZPecXb+qrHYVJTDhHlZ0a9EEUoNlk24HG6gK2E?=
 =?us-ascii?Q?sQUeHsSICv4GpRkCyHRP2+P4dQPV3uHr7G8h2L+ThENLO9SFfM6z7kXuRscW?=
 =?us-ascii?Q?PIXipXWsicOMCPm2upMfXtc4ssJQ8dseHTa/UYQkc4UoQZKhjInCjWK9OqmY?=
 =?us-ascii?Q?k6zrVlX1qz5+7CEMV2crvsiqrqRIUpmZ5qz67KZMrNvjspQVsDkzjhtMOjEK?=
 =?us-ascii?Q?sU2lvC1cKd1hKU9ieNlT+YItdu0HZGH42Ti5fG07fkPBJ3yBP8AWzslj+xRA?=
 =?us-ascii?Q?TLQFQLMJpaIbMH0oYOMdLbkRPzZ/yjtP6/O2bCa6Ief8cp9qR74MYxl+dHZA?=
 =?us-ascii?Q?Klp3Yz2y5V9znZCnQ+6m5gLl7LM8I1zyXXnyrlZ8DGg8pGjNlQTFJ9kFVJXS?=
 =?us-ascii?Q?ydMclIrrw2+JbdiS3UbwnDD3lul7qTcH7GlD11LDhDZAXpJ5P9sGwjt98SZv?=
 =?us-ascii?Q?HOGidVykts0EwrmxX7jjMKpLyUbFW7o/tnOoS6Q95V1zYNwUu4MfyzDq2c3E?=
 =?us-ascii?Q?fYBnnuCZRDiteixIKohPJHuZuPmCBi5ZyKJJleQkssGfj/niwnsEqq/gFznf?=
 =?us-ascii?Q?xLDEqjhr0BSKvlldAWZFMMjc8CiXlgbxp3VI8qGbMFiwYhnS31X04ov2P/4F?=
 =?us-ascii?Q?uwcbFhHGoN519IubVl4IiRBn6l/LUL7VNh5AKw3e5XsL6mYX3GCpS1/uynHn?=
 =?us-ascii?Q?jTpL4hcwzMp/Rw/hHSavB0NcmepzroBoPrPmXEA3OT0+CqVJf9wFg7SoqBV8?=
 =?us-ascii?Q?iSqvjP7jXkpRDzJArJWpOauoituFNVdSE2Mg1aa93+c7vO9Vf7PH3/mBncad?=
 =?us-ascii?Q?ALnPL4FJc+bdeKqxd+DEev3z7aDCb3Hbyh+/tDHZ4xmIoTT7F3usTPyISBvV?=
 =?us-ascii?Q?IdBaxRpuerfGn0wNS2V1kOWCTjR5kcZZIfl9yHs2q2aOcP8qKvbLipJW0Y2U?=
 =?us-ascii?Q?1bkvkNJ/UtFohG9Pl6+8vYbxD610rnG689+G7R95G6EgCTi6vYEvSYmfhaCl?=
 =?us-ascii?Q?79JFMGzcKfrMa/QtPOcloI2UyaxCwM4esk4ndBw5TxrxD17qhvehOc9O6ruq?=
 =?us-ascii?Q?ChITYn+Rci15CR57GpeaGMfpnAE01EiHF8mRitD8LOPYgqOzmeB7xRP28bT4?=
 =?us-ascii?Q?YCJd8glaS68yomIz56kodqjPOipzNlwb2wD+VIGuQUanZp3So9pt/H5o2stU?=
 =?us-ascii?Q?6Pw7O2Y31pto7MnN7UWWbrd0cQLxAYED89VMGbx2P088LnCtCXA9wDPt78Ub?=
 =?us-ascii?Q?LaqeGqXmgy4LqATGteeDuJylOG3TlZOUOXvzv9fhIplDx2z74kj2ymdN/6c3?=
 =?us-ascii?Q?0smZmL/zWzhuoGrV2s6+H2QLaouQTP1PkpjuLMGxri1cUoYIpsZhyzsv7g1D?=
 =?us-ascii?Q?bZ+oJuEkpZUU+uI/9pYhqOKj20341B6P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6b0yzNiYGO0tSb0kFeoeqLSzhXmoK8FtsXQUeUw8y6ztrhHi6eWKLyKFrIzl?=
 =?us-ascii?Q?ppI/ZWkcDcvuWnYLS7ZTk6PzUxD+OHD/0Q1oCy1CBulA07MUfQoAkGleGZ3/?=
 =?us-ascii?Q?DdT3ft3or/KWIxdk/MT1q58ItCWk3Ichw4Bk+CeHq8UqmsnKssQoEwNrrVTP?=
 =?us-ascii?Q?z/XPRTV8rP+DgKXOJyt+EKh2anjxWHL3f9Yndq4IbA+6BKiftZlDkSKwqKpl?=
 =?us-ascii?Q?4hSkh+u3dZG6lHdJxDZztfhQB+/gYmUou/UmOH4bdzFgp8CviKt6M/bdbD0T?=
 =?us-ascii?Q?u0SEtQFhsJXKyo+WD7rxaeTiDsINjOnKcs2mF8GBRCWlRXJ8+DML0OAApYRV?=
 =?us-ascii?Q?YdkWRWnUm818iawg7uSUI1p9e95fc74NKQ9kDtCz8xMf42GhWNTNY6ceoYb7?=
 =?us-ascii?Q?9EQvvovgLaVdMJXVr1/g1yPTCiUGoSMoGtvDT9ULQbaBTUZT9tZKEyyBV7Pr?=
 =?us-ascii?Q?XhtNrOof07z223xJUTn0dNwZeh9rRQyouyTVX6JJfV0lPiYUlO71fd44dDVK?=
 =?us-ascii?Q?Uhl21DV89nTUxZYzMk6yjrr6r+0JiQ6UCNkLK1KQIqZCud/eXZR+wKNtL0Ru?=
 =?us-ascii?Q?zLAS0TfoydDLIeDC5vkk87FTn9srInkEELV5PBjhr4Zfv/k5yOIYO6arixSC?=
 =?us-ascii?Q?GcWxGCEom3f4gwk698hE2U9bug+ikfSI+AE5cp/9pWPvSh5c4aV8mMRom0nj?=
 =?us-ascii?Q?Qdgkh5JesMPkVkr610kCdIZOi1t1O7H+vWaO58LZAeMFUdDB1Ka0c1QasYLC?=
 =?us-ascii?Q?Z9eUac1AEtf+H0GfwujcRLOvMFriA4rtwn/ZgcrWoG5tPyMIkjfmmZVOkwHs?=
 =?us-ascii?Q?n8fQNbufx5x8ZzCtQT78bJV2N/MiD+8xCGVVhX3d2Lhd2NOBV2JasT7dR+0u?=
 =?us-ascii?Q?xaH/FHu2yGYqPHccYPXHUFAfCMZAQaTRZmEDNU57vQUPIjgBa7oEHa3DueU6?=
 =?us-ascii?Q?IQolpwR9/5T+OMahdu/RY/Pql0BCMIU7v5eCZo+9Wr5RuPKCknH3eBH4N/v/?=
 =?us-ascii?Q?ejBgzHWc/djgNHVANGDHxStdUhX8WHeu2b+CX56cbE01R0vbSYd/z2sPMfez?=
 =?us-ascii?Q?c0AxQ7I3cWgCraFdaPpk5eeag4aOyqR3yVInD/7T5U+b1sA7DEavVrgNF9Nn?=
 =?us-ascii?Q?3onBEHjne71YdjCwrvX51WckvA4WJdLSt5M96VR9MO6Ac2HmzMKM9ZVa3UAQ?=
 =?us-ascii?Q?TmpQ6vXPQ1YSQY49fuPwNwMa3AcCHCvKCiamQ/AktdCmlvlpM/p7UAhQ1l/r?=
 =?us-ascii?Q?6YGALvvPUPruRH+rbjWgkGJsNg6I3eA6aPf9xKrfiTHCbhdJ/H0VuYF0vhR0?=
 =?us-ascii?Q?jysfpB49w1tPWKtL9YsWn/Hf7n9OE9UK3FnqLsArK+oT/JjgbqKdm3eVAk6t?=
 =?us-ascii?Q?6CQec5WDtp2SXyxRb581KuvJVRF5ilpT9MYkqRoUh/yWfF4HoUhM6b/mQmzE?=
 =?us-ascii?Q?s1Q4qIMrsFsgn/f9G7uM9kop+Zp0tM1iE2CkugjjL647dMdK79kOJE130L4t?=
 =?us-ascii?Q?Ltg/+oTRnMMvcAHtYV+0TBb7/DQCwcHQQbbAM6AgWmLHnSPmWKwpVpCaAZxj?=
 =?us-ascii?Q?DtDVxjDFsaeV7/NZzkSq37S5Z/4vagzDfdiDemux?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0538789d-114b-4c63-6d02-08de23989579
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 16:12:18.4101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kmHwVsz7aOfkCYxVPva8KOgxFZTcvy7aA2zVYva+xbInCvavVklkyr7h+OqDIz7L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7293
X-Rspamd-Queue-Id: CC69C120016
X-Stat-Signature: tat7s5j19enqw9hak4ip8dd8b79587gp
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763136741-52022
X-HE-Meta: U2FsdGVkX1+vnCje8NybhU0icPtUgE7SwAV6G321utoCgLpb8JlK/r+6NAEYh85VAy3+6tnnzeNytVJXn3vixmYPVqE53Amn7SDmvPh4hfzwVbNiLCpiqGadczgDCOEpuiju4M0EcxYG8zefv/FaOiFHxRb0nRQNmkIr/raIpVN7gYgUSXj//e127H8pFk7Igj9RY5VRR/xyvGD0L93UXSNshjDckdROlM7ZQICKvMzaXksPwW4oHH3Vh6xx+M7+UewrgaPTWYImG2pDLlXrrF+ubM3bWYHZfstgAEcGM4syAYEUpLVHweKKbQd6pyTts/752mkVtC5oZSprzuYqHSHok+gAaAsdr+AHfVyQ/+NQ9WDMKJKKFuH3kZPCy2UM8ZPvFdrO/26oqC4dNBUvmCME+rAFlTmh3z8SbcPU0Mlb1K80AJ8Pz3/0uE2F+MkQyK52LfB0+ALwNhOe/jUQE/6BKAGWolHcGeLGnEhu7FbptKUzyT529dhWpMtbqSDEKGwKHXWmKc1wP4DVaHNzGBNKQe9iOJlllqj7p0r7lQeIqTYEM3WfOMGbS6M2m/od1/VY8FF3Qb7Jz4mbArz1bazqRpeNVQdQy5ttMMGdIq2+FFNkd2y6ZHS1foYNGGPT/1fSdf+8j06nAMB1CWqACyudqD5agIv5zhZHM9swZXGMpGiM9EyEqRGJHPVS0V/OCBQB7ls/6euFyjg8aCTjOudVmkDmIap1ldiZRglJJq3W/qUQWbGIYHyBIy/alhQI2FOTwOB+AGxmA6xmNce7Dy6fn99+enxpbTlQ8YWK7MkbCRHawEu6RHFcqHU4KKu+PIKrWvKhHKiK5kVIg7MXf2smqm8OLmFJ8K62FeAbGx8w9WjPurDkzgsJBGIKDz6OrakKKza6HKBoSRhk2t8vhKTG2/5dP62MWXpoTuP60L//3h80r94azKTQGO4UgnHRN4pQaorjptTl61ZzMu0
 O+ewc2KW
 zc+kzyiwisSREmpSVJKUt8j1KmGBMaWA/c+03A43MhZxMcpft22oe85JSK8HyqcxSRDA/749H1m1q9haRpTdNLXLvT2mealsnWp7Dj17hCTnGTLimNXWM47IKV4SODcDaA6XMeqWpuqqxr/QzlknWwHtLYjA2lsbBYqMNF7sIZLkeQAHhsfPT/HxbDTAbbB8KWPmHXmRWBYT5uo2RMGjSR14QQPa1W4n6nDkoFPpF21+lXJ2wGmFOkyF9j5ZkTxNXL//6SCf+lCVwgUY9pBanAx0PtrY0yE7QNLXIANPhJI9uWxWhJETQS+0pLFsXzz9XBZHvR0OUQYIXa987Hb/T3GnP2EXbk0/QR2sEAzZZhbNEH66h7PTOJbcxgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Nov 2025, at 7:36, Brendan Jackman wrote:

> On Fri Nov 14, 2025 at 10:40 AM UTC, fujunjie wrote:
>> Although this code is not on a hot path, the revised form is clearer
>
> Is it...?
>
> If people do think it is clearer, let's at least write the right comment
> in the right place. Instead of having one piece of code
> (calculate_totalreserve_pages()) describe at a distance the behaviour of
> another piece of code (setup_per_zone_lowmem_reserve()), let's describe
> an invariant of the data ("lowmem_reserve is monotonic, up to the first
> zero value"), at the site where the data is defined.

I agree.

>
> I know sometimes in code this complex we do need these
> "spooky-action-at-a-distance" comments but this doesn't seem like one of
> those places to me.

My concern on this change is that the correctness of
calculate_totalreserve_pages() now relies on the implementation of
setup_per_zone_lowmem_reserve(). How can we make sure in the future
this will not break when setup_per_zone_lowmem_reserve() is changed?
Hoping people read the comment and do the right thing?

Best Regards,
Yan, Zi

