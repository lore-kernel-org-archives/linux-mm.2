Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DECF327A6
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 05:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA456B0088; Tue, 21 Apr 2026 01:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AF36B0089; Tue, 21 Apr 2026 01:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89CD6B008A; Tue, 21 Apr 2026 01:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA6AF6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 01:52:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 935275C993
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:52:21 +0000 (UTC)
X-FDA: 84681492882.10.DC922CD
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012050.outbound.protection.outlook.com [52.101.53.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id C33CD80005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:52:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="mCtj/zuT";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.50 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776750738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NW5MOU1nW63QrKMjzHg4dznPPHcAfuN8G/tnLfhWljI=;
	b=NKaNfeRqMz51rRmlliHI6mLpyngpmGhpkBxRp6M+4hvYcWpZNJlxXppMdY0EvWwUrB5m7n
	FkhrOGh4nWFTlQdsCVkA4seYHHHf1+W1LkUNBE9e1b2Mn4H2VZRMmap41Fm4Y2Ug2eVx+0
	Y+lkQ/mDdB63CXTAvgy54PIgvqueD3Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776750738; a=rsa-sha256;
	cv=pass;
	b=leaabOHRxiSMEgvUUd3XlVPJWDPN8tmWVj//JExyR2e7/2t1PqLqmSyFAb4eifLi9UtPPs
	VYIhZfcUaXhsooctomHxBEOIpCdyqe6siRykbFxdaVw10cRgyCTF/4FRYrutFLG3pCBBKF
	pU7nJZCnyw9nrso5jN9LQjmpqEB8P0g=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="mCtj/zuT";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.50 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BtdarCmbMjRlnqUWVMvY2buE9sBGRV37U/r5pPzDhRMynopp7RlAXJEf/2d0oT5HMmQkEqJo3wuuNwTdmvO9lJ6Khs/wv5jZdtypsE/KJzmdpTdvIgtj01nTuv1el/zE1V2wS8mYMooCyjNLDBNlRE5Smnwc2Bvmj7U1Alnwp5LogQIVlRa8WCeomrcGl4kmxjgL1pwUzreMIwJHc6h5xDyXzV+STO8BiTuLTcYoZ3DK+/dpx7agwgOBZ517delfmZh7edKOgnyEgJXqI32kni1MSDwK682u5z6ZrSftNGn8/wATmCE2Q61QNOh9qMPykO1+ikOdptuSnWm8giwulQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NW5MOU1nW63QrKMjzHg4dznPPHcAfuN8G/tnLfhWljI=;
 b=rM0PIxz75qV4zTtJlt8MZ/KJXzkUak4a/CYrEwKXp46EMyrG4JqA1RylP7s25E/r3dObPHIQpqK2mx6Pl3JQUfM9CuRAzcGxYeUMO9ECFRzlB2EPETwhqFZ5mJtBKzEtzaEdZ8lPInmoBgAyogbLo0uoVbOJgc5xVlh9tbxPHfD+PnXeoRgMQeo+fZanCNWM0hB6q+IywHzhBpbowf3ojhm9jdHb1PnhsZFJEY0aUCsBWxcMLLZUpSsxXj5OB1HzTNnZNIqYx5USbKooKjPghHnxlEqITE1MXZGk5mRc3FRqSqvZjgH24yKvyQYSNMYjlf7lyOsalxDbSC+mWUABRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NW5MOU1nW63QrKMjzHg4dznPPHcAfuN8G/tnLfhWljI=;
 b=mCtj/zuT6NaZFgDlqaMHbgmk+OlsI9FRQw/HDSNv9Uv+/+mrZyOYFjONOW/Lz5ffb1T4JQsqkc9t0slcNST0ubRp2cQ5LSPQG7zMPT6S59zIbgBys002JGkOjWflHUKP4CS/fLwP8iDGimVWDyifCtZs9kY3cf+HoxkhT+B4ZNHeTJD+b+m0SHqxHf7Cvv48LeO7BH8z+HguM4bWOmOsvNHO5iBy5qGNDA0hswSw+uRaQ7XsXckoPKNA827qa/UXGBDkXXMaCpN6PJsyYcNrhoidhE84W+v2ZXX+d0Ubjbbs2BJ1qTX/iPedcEnvqX83x0wukN5GBqt37cqLd8vq7g==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH2PR12MB4213.namprd12.prod.outlook.com (2603:10b6:610:a4::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Tue, 21 Apr 2026 05:52:12 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 05:52:12 +0000
Date: Tue, 21 Apr 2026 15:52:06 +1000
From: Alistair Popple <apopple@nvidia.com>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/2] mm/migrate: wait for folio refcount during
 longterm pin migration
Message-ID: <aecLsTg44qIq2WsC@nvdebian.thelocal>
References: <20260410032333.400406-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410032333.400406-1-jhubbard@nvidia.com>
X-ClientProxiedBy: SY5PR01CA0104.ausprd01.prod.outlook.com
 (2603:10c6:10:207::7) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH2PR12MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c2f538-f3de-4237-2e1b-08de9f6a2204
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Tiypy+Z7Ig9HLZZRy9yTV8T4PEpClgJjgo49K+65g0+PwXvJTEK2h3eFQvPzhNDBwHVmHOOJlHNeLPubT3TsMkbO+l0nBfNGb0wvb6Lc4DOB1KBSQND39PkNURsjmca84mONFBvT/uZwGV0CsgtonRE1ysWz6S7SQrL++goYiSY8OCglI4+axHlWX1p/o59xslig08fZdeem+4ihsjR82GVGVYZcyWCfmpyw/PJfOCUfwXLESqzTcG9ZPHDUAdEMeTYpCAr4k8/u7SeGdy3X8/tmp9r7X54sRz/sGAgG/g/fhs7VT0rNsRrV8Z13qgwFVVgzUMhbMtRglzrhmNpKO3RrtQhxyIgKWZ/7cBujllTx/ckB11yWNYoLif5DENbKv0dn7fz+M2oRoa9xrAMwlT6/yollhg5Y7760nS0bHouEa+92F89jwSE/FWzPGMv2GpWU2zp0GYEKMUO0MdcHXJWy3vd1/6mXe0ZtJdyRJsBua8vscTynM95yssAwAP/vQVAr2QV2NPSg+Sjn3hxGmCmBiynt7b4Ouw00h7Hn+acP4eVVdnabdbyHpCef0Vl5QyLUwYQWCCOFyr/NeoH8NPXpofQD+okJe9VG1bpTxZaiCV9kfevZpMX4mYGhgmjNjzgaIATHu28A4Mw8Bv2D7kLPWrNBWVBvZ3ftDlvC6OaRsvcl1M0eHAix8tSLMCXVGYvGLlYLFwH7yQstH0FJYxxAeIKR3WqI+zQ9Zzffa8A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YsgNRk/G3yhlL31U/uhuryXv7+McMbMekyP4qKICT4ZiVIBNLFdUcLxBfms3?=
 =?us-ascii?Q?OGGjyRX7LVu8xqxwkh/VPLYt8C2ERBIKO1nT9rdWkuPfMLLHSljBLawUOkS9?=
 =?us-ascii?Q?ow5Wqh8d6TgRx4a1AjRP9q/wEGo62EoMfOWVVsuPhjhYSWJGROqLhVSFHT72?=
 =?us-ascii?Q?MZjGI+8GbgQHXhD6iz8mlW8kWRzScHGZS3hc3feBq1Y47Qe/KoJQ9x2TajUI?=
 =?us-ascii?Q?WuL5uPTQa/5W4PdlatRb20P91AIL12vhjHRd2v6MFkskPU6LjyTFh3QyBeri?=
 =?us-ascii?Q?sx4fM0zPz78kTGS7gIQ9pJJ47qhrQs4Q4DEt3mLuWFvKUtfyXxX5pVQBDAjD?=
 =?us-ascii?Q?CF5knCNPKC6fxp3XN2FqVW1pMlXPrxM7O6YFEXL3LjuTjB535T5/AK2kUvIB?=
 =?us-ascii?Q?fF4VUUheuh2R+XZV1ihgd2TQrDIZGxikr42GIU3goKxwOnfUMI8a2CgtQytb?=
 =?us-ascii?Q?j+bFXiMOsoryuyHG6ugipYqgwpzEPEs8o+O86vhZqTrWC3AH0XURRYrTrPWK?=
 =?us-ascii?Q?wgT61YpweIZH8vUm/nOZEllZVU+s9b3l9xqUZbfvB1xe3VehFQl+1NzzWEvi?=
 =?us-ascii?Q?Vi8yQvRlgGacd4o8X3C5aciQQholjdYwKNK95P28uYxrp4zSiS7iibqfo5vf?=
 =?us-ascii?Q?dNLNXxjKaMhts3sHyp+pZqFaRqp2rpJlY2nP2DA68hhaBCWQMFVF0XJNADnm?=
 =?us-ascii?Q?1nuvlE3OxS+ZyxYClW17QYL+UMkNtRs1rh6eOJBh+DB8GUAYFyVVon6vR96I?=
 =?us-ascii?Q?xs/gBlVoctP9iiZRR5H0uXHSEbEAhcV3RQeQ/UL/7pDFqbMGfkT90r0tazbE?=
 =?us-ascii?Q?oFr992RlRlPdwJNk0U/kVb6GpfFk+3Xr60UqpIrREkdPwh60Uq1IR6OPiSB4?=
 =?us-ascii?Q?xgnr2KRNp3E5fi5Y4adbF7dLTd5i7Lh6IldbkHBiFeXtHKKZDsFMYwbQt5dn?=
 =?us-ascii?Q?jSqRcoCgbGNdEbRaBQySsFJMv1/fTFc/Q6m9KF2kXmHqHQqRi27CkvwOl5Zx?=
 =?us-ascii?Q?S385HRmtcD4CYoOETGrBl6dkCLZiW0qvh/CczebCq+hrJVirps5xnNqP9Tar?=
 =?us-ascii?Q?vFsxSl1PEaNfJfurVcAmnu2m9kIVHGGrT0XygYukKPzRvo7U+IzHmhxH6sFs?=
 =?us-ascii?Q?44oLy9OGwiWXj6TM42s5my9Dmil3X65TYtmmkjRAZiqs12RdJoXzRZ50533+?=
 =?us-ascii?Q?KZ+43qTO9L1A2KW7oBd3En9GnOZ8I7YknK4mivQBBK67xT+JoJiKDwDiU7dd?=
 =?us-ascii?Q?8cE7eSfoX25XTUmlLdAm6ufQ59K3K6FVJPTWnI5WVyShWoPA3ZiBHGP4TnSx?=
 =?us-ascii?Q?IvQYcUEKl71W7zozL372c/QOoFXgxX1Mf8vMOTKhkUmdgokBUtSlmx26v0t2?=
 =?us-ascii?Q?PvKI0kkIhVqklRUBkkhAIvheUIN3FzqwFFdME5qK9WsynCI5eOUVrMT2lwMu?=
 =?us-ascii?Q?rSlUm0WQ5rFmYeBC11nakMBcdabdFcMfosFzJK73KfD9dju5k/McxMbAoX9P?=
 =?us-ascii?Q?7xfEPYHIihQxyjnb0om0dslOLgXmYIjA45maM+Fn/Ko6RwtRctUIWVplCfwN?=
 =?us-ascii?Q?soO1/ewzepqCGBWds4m7CpvyssmH/cviRqTKkrLfWBqCHQ2ky/gUdCESbvdz?=
 =?us-ascii?Q?kei2d0/vfME6/BBt2x9t0EUuvDPb1KyiBdXgdtbyr0WpVEQv3SCbyQBXeq3T?=
 =?us-ascii?Q?L314Wx3us0S6b+Ju0X2yBQiS+8U2wqU+nHmmDvP9e5D7dPAHUWD77oKloAY7?=
 =?us-ascii?Q?6O++ZquCLA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c2f538-f3de-4237-2e1b-08de9f6a2204
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 05:52:12.1592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juwhZZWjDgexu1XxWl3C7FJvB7gflJJ2+az4U+z3kPXazLOq+AgDVGWwDPAp11bl28Vt6KTPvkqj+GglJDTXLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4213
X-Stat-Signature: h5g1ks6mk31137raegu48zyhwgota3wy
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C33CD80005
X-Rspam-User: 
X-HE-Tag: 1776750738-713748
X-HE-Meta: U2FsdGVkX1+0I+cOnW3h5OHwHYTYg8Xpr6WeSE34qIAsxuwBGhRoIvzAVIvW3Y1GXzJZLWmonCDV8eczcKi08Nd0NDxjh3uIKZjLtcbQoGY/+vHjm37JqWbkblZVtH++VTUU8PcFpPXqUcdy7BYT8STEyGkERbyvICJr0idgSc3uLSF3JCU0VoilJCBnpz7HxCwWA40T4n6Q1ol5xKt7bWGpzkVV61d0xRj7+CMtfotXPXRheyRSLJxSYIKihkSPHutHS52JDyuVWKZlCMMAbbcl0YsDvRxSdffgMT35ErjB6JjmQsucF7B3wDV3uYHvdrCla974ZWhJ14SnAetbZwjdSYWcAJ50bM5fFluhM/TimPZqBTem+BEdmmZbkTNAAkUBabqYGIyToMycggYl+oKKasTgWFmKbWF7OQm6l5nkkMc2ELOP+N9apDyT6XsGeuZ7Tk2VFx5DMTvhh01yoQOPm4GovB2u41X0oi73n7EoKy6cAMOsHbvoW/fkWd1OlI5Dk6lEAcWzZ4wZjheJqmytwyl8/OvbWnpsyip491JXPLKNGEEbuNFDZMmvQTXYtrh8AeeodAaOHY/PxgMDq+T46ZZ4E5+joSKV4/2w7h/8P/Ty+UgsblfK8xe1gMuTxzYQxlTqTkxVh2QatNdNN3Aqi6eiRl0H1ZRl3de8LnwtQh2BxSyvwRo+kC+Acr/D6Jbwz4bwwHE/7NBg4MEklMXX95ON5nNVSg+o3lZER8tbst1DYK/AwPdMDZqY5bndCDwghhyxGXzpEhKOiybwsLzzHWy/4LIj/jF6LvlLp30fOwP9JlyV1FqDNORyFxU65ScQV2wRxNJg8zrGxzhVCIEcgWu45dj5yBaDJcLi64HOn/HLImcCyfpB5lHXuSvzthCPU2OePG8f9566ERA+HsouF0Ye+iq6k9gFzwM0WDkiNS9yHZ5vBSd7YE5i4Vb0VNYp/aBldup+GjML5jK
 6KGYO7ir
 U8Qvv2xOMGFjreSMmtHromyPhoQaP0zNmfTgPdOyiVtNOk/BOJw15nddtrb6yiT4G0+ahUvBatIPvfc9yRrdKBmrycLSshvyE8Ro3zxl7iyOpggvqYMmDBDfQb17ZVgO8fMA3sVRNm0q6wFrSYQ+/JmL4srVjbfIY9zbMI/iqL39IVH93vEmaeZoSdISk8Q8yLiuhxpGE83drdEx4E9NQZ8swT/Tw/u0HadM84s9bOkxcfSBjdKUkJK0F9X7LQFV7XLz0uL+eQIDurYLM4sNyKeXfCG8kj9oIc4ZQNnZuJbm7BPsHcSCGsT/rYCX5/g1ODF86FOiRwMqHSUNbiCW48NKgV1G5EZpK2Z1PqoShBSxVSHZxX7kgRcnVu6sJ5F43CzSreqV+OZ3mO4MDDcpAtgtgfl+M+8wnpb80SEKKhzOWMnUKKoNiu0Ww6oHB1+aTvx2dNfQo8yiO6r0bRqkaWpZEEq3Igk30Fq79hsh03wwVJS/GV8uoGXhfqWkODfo4vPnr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-10 at 13:23 +1000, John Hubbard <jhubbard@nvidia.com> wrote...
> Hi,
> 
> This adds a bounded sleep to migration so that FOLL_LONGTERM pinning can
> wait for transient folio references to drain, instead of failing after a
> fixed number of retries. The wait uses a one-second timeout. An
> alternative approach would be to call wait_var_event_killable() with no
> timeout, but that doesn't match as well with migration's "this will
> probably work" API. In other words, a short sleeping wait is more
> appropriate here.

This is much better than retrying $RANDOM times. It also seems it would provide
a nice definition of what a transient vs. longterm pin is. Any pins longer than
the migration timeout would be longterm.

> When migrating pages for FOLL_LONGTERM pinning, migration can fail with
> -EAGAIN if a folio has unexpected references. These references are often
> transient, but the current retry loop gives up too quickly. This series
> adds wait_var_event_timeout() at the retry points, paired with
> wake_up_var() in folio_put() to wake the sleeper as soon as the refcount
> drops.

Nothing wrong with the above, just a minor nit that I wanted to check
my understanding of. FOLL_LONGTERM causing migration implies this is in
ZONE_MOVABLE, and the aim of ZONE_MOVABLE is that memory is always movable. That
implies any unexpected page references should *always* be transient, not often
transient. At least that's my understanding assuming drivers are behaving.

> The wake_up_var() calls in folio_put() are gated behind a static key,
> disabled by default, so non-migration workloads pay zero cost.
> migrate_pages() enables the key on entry when the reason is
> MR_LONGTERM_PIN, and disables it on exit.
> 
> Toggling the key is not free. folio_put() is static inline, so every
> compilation unit that calls it gets its own patch site (roughly 500 in
> vmlinux, plus modules). On x86, jump label patching is batched (256
> sites per batch, 3 IPI rounds per batch), so enabling the key costs
> 6-9 IPI broadcasts, a few hundred microseconds on a large machine.
> That cost is paid twice per migrate_pages() call. Migration itself
> spends several milliseconds per batch on LRU isolation, TLB flushes,
> and page copies. Concurrent longterm-pin migrations after the first
> just do an atomic_inc (no patching).
> 
> Matthew Brost offered to performance-test this series [1], as Intel has
> tests that stress migration and good metrics to catch regressions.
> 
> [1] https://lore.kernel.org/all/aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com/
> 
> John Hubbard (2):
>   mm: wake up folio refcount waiters on folio_put()
>   mm/migrate: wait for folio refcount during longterm pin migration
> 
>  include/linux/mm.h |  8 ++++++++
>  mm/migrate.c       | 30 ++++++++++++++++++++++++++++++
>  mm/swap.c          | 10 +++++++++-
>  3 files changed, 47 insertions(+), 1 deletion(-)
> 
> 
> base-commit: 9a9c8ce300cd3859cc87b408ef552cd697cc2ab7
> -- 
> 2.53.0
> 

