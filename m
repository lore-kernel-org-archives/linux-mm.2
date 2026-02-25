Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3A1F55449
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 03:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82E26B0005; Tue, 24 Feb 2026 22:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27246B0088; Tue, 24 Feb 2026 22:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4296B008A; Tue, 24 Feb 2026 22:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B850F6B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:14:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52B0113AB09
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:14:35 +0000 (UTC)
X-FDA: 84481511310.14.77B9021
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf12.hostedemail.com (Postfix) with ESMTP id 491D840009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:14:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PXamBTxf;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771989272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/GW9x/Fk4H2UxY7sgyPwLLANKW0qoXwW/ht/j414AGM=;
	b=oAAnJtt4ONItEV5j3rTzubbfrtbFtY8BIrkFa7F9g0hCj9CB79WXOusY8bB2PoEpFdjs1r
	9VR+on7G/EG1tP1NIJ1rW4DWiha04CqujJmQJ17Dd/RHwxQHRRrGd+e1zkQRpmp4wV+l9C
	a8r9PlR0X2WPpTsbx5XJBG3DS71KYWY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PXamBTxf;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771989272; a=rsa-sha256;
	cv=pass;
	b=uFn9FudrERHMTux5jT/Dhp/3QTE+ujPYiY6uOhPpwOeZ72qqM58Qrn/0HvEDeIXs2tQ8L5
	W+wYleYRZN8IBD1KKf1UNnTw1ErWKGMsbzKc7mvA1tRyqc/tA2QslPOuoeg0YlNQEY/abc
	5C/2uAk+uwObvUXe+aP0I/IhRM3mIo4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKMtTZoig90QOCyGR7e/B78sOlaPbCeOJQvZR9s1kAxzyZqsDp/OA0hGruoT7YDUAfni9vJSDeD3POqXLoXrl//HkGbUioE16R4MyrtR06r/dZlEHd6SlRkIWvlQy3YHIsTtCMIDW8esHx0tpNdX3sF3r5xLYCeiUty19oxuus+L35GbFR/CSwzqzq6bpXcK7gJjp2eLTt7IISumiVZzs+q4XAm43Mb9jm6gVfvvJet6gcfAkhix2rtXeh22pXY7rgqTGATQ0o1nhPoTXDyg/1U8Z1BSbXwK0JoyD3QXwT6DMZSimdoy3ezkQR2Q0qWZzyzmc8m4sa5JHjGes3D1mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GW9x/Fk4H2UxY7sgyPwLLANKW0qoXwW/ht/j414AGM=;
 b=s5uGXhJu0sDEktz5Vp0VZH5WaE5O7di576v9qncGHjvpQeat+N7YMPZa2sQ/IE/BJOA/ZgQbrSjmzW6nRS41yTxmciLbaRR0LSY3zoeNUiHgVVlEI64xl9nHauLTJIxZCYV++4XdTpUpvfgFOv6FF7lncIucSvQG9SoJ1SXr0+8fHzEftMOKGpGZ7evxL7G87G/abS0SdoC2N8cBuDsnc1Du/L/FpPRJ3daWgNbOSNhDPY4Qp9Xmc4FBpX14UzQKCg9627yKj3J5WdHYzH2D9K7mKSrNxR0tbTkD5E6cliuDRCwJFcF8SKLYaV0tx/BXeV5ZTsqypmniuqDQ15Ocug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GW9x/Fk4H2UxY7sgyPwLLANKW0qoXwW/ht/j414AGM=;
 b=PXamBTxfSSBt1r+26Rbc1b1izLNDLahK77u10rMPulMD9JR1hCmx+6J46EOihDGMsmS2YHmjPj39XcCr36tF+31SuQg1rmZaKTr+qR4olx8nOf4hN2OfMmwQCCllidErkmbhN0Xyx5WU52aBb8ex8HYH3rsQr5iezzLD2zTafFDBA0rNQhT8U/XTtgIrMl+Fr1+BENa3cycaozopM7qz+C9aHsn2Dyw2k2vSa3TpoHHYbYZFTl93A2S6GvWS9VABgg8oOaXxBtMgSqvIvCKuHidKlWqmVWIUc7Ad1bUTnEX6Qy2xyJ+JrJ7w2GYpUzH4iyk21tIe6vo+cI0ryah7NQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6912.namprd12.prod.outlook.com (2603:10b6:806:26d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.22; Wed, 25 Feb 2026 03:14:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 03:14:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	SeongJae Park <sj@kernel.org>,
	Ron Economos <re@w6rz.net>
Subject: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 22:12:31 -0500
Message-ID: <20260225031231.2352011-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6912:EE_
X-MS-Office365-Filtering-Correlation-Id: 629ad36a-ce25-4280-8cd0-08de741bfc02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q3hD6cAeJdF/kaDDK1lnmiZ+/hH9hPzNITWeCPhD6TokTSoVK8VsENABf5fa?=
 =?us-ascii?Q?ZM1SE1nNTZLbz9frqDEXnuCdCqrB1Ix3MkdzRRzsBfIV9CsXM6WNYrtiU4P6?=
 =?us-ascii?Q?lFO4zTtJ1Hfgr0S5D+wuxPBgpLJj/1GZmQFaDzuimFcztECXpE3gmw9ixtQK?=
 =?us-ascii?Q?sdZA8O80TZTtTo5iK6Wgb0Ha7Uag261ZtWc2JQ8LZxNYchxhmTn5Hw5RhsRV?=
 =?us-ascii?Q?jW2w+23sG6JshAdIK1PnVpnnAYt1kCmpYaDzQvaUWogFxGOVs43aAgF8W614?=
 =?us-ascii?Q?rDSTgVyoAWETGY63ASPSSvqAbEpHsdMF54mpKkKBruBCOrO1iGSdu05a9X5P?=
 =?us-ascii?Q?vAFO2EpjqldSWtEBVNfZD000mOSGfIt3Y3eRt0TnNTAPjTQIfdIzpWxv+Uyk?=
 =?us-ascii?Q?QzfpibIS7ewbHzzMLpoLNoSMF0MRx6LZjN0RHQAyQuBJhrB/S02Dip7IJ19C?=
 =?us-ascii?Q?R0vzAWts2jede8PRLD3z3PVHIdyHlg8ptQQtW0A0VqNjpnK8znfSwOlWZer/?=
 =?us-ascii?Q?O7MGBmRDzB23Eo/zH8w9GdX9VFWHqy2NDCdRNAPhOHGJ6J7/wXHIX8/JFSgK?=
 =?us-ascii?Q?5ZvQXciCQ1Zdm/uuzm017/Lx3lVTOkQCWPZdwapLuZZ7+S64mOBMSiTG+pVL?=
 =?us-ascii?Q?JORllXR8uOS90ggpy0VLJfSfkn8FSWJ1wkSKaZ4bsDdaK7PtCHKyfHNQH/25?=
 =?us-ascii?Q?NPPnIwcQo/68dCsJ676wxL/deSKhRxWmz3rWMOiWKo5Un9wWlLYoq5DucC3J?=
 =?us-ascii?Q?SK6x9yGMf7qnmPSVkHwhGWN6E7PXOonkKhStofpMwr3/vVUEhy18fmRIUcfu?=
 =?us-ascii?Q?i/c1mAJP0usODhyr6JlFySWRLFJYDtXF8e5iCtS8M05OvJi/Wj+LwNWpw/wf?=
 =?us-ascii?Q?i298LhvTsZYMfk3peM3PREbjFsKKrJHV37mS25XUu+8pxP7jbBxXHHu9qxFL?=
 =?us-ascii?Q?zZs5UYzBvamfqTJZFbwhJcr0KU2K7f3CqhmlolLZZalAb/Voh6kOO98l5mwF?=
 =?us-ascii?Q?EqUAye8OuX5tc1YWFIGHKlz/ww8Yjp7mKEQJABigPuYjM3TDNgfwpwISHqtW?=
 =?us-ascii?Q?LUZYa91juT3aAh2bSvxlCIiXRX4EZwgCVlw3+nYOUZuIjUneA2Laqrw6FOo8?=
 =?us-ascii?Q?lMwB6EgI7wBdIxumdORGeeLLeweelp4BzA72InnY1lsSzzMvUKB7WYyEzU2U?=
 =?us-ascii?Q?iFdaWMxrBRA7TA0tB4m2XHQU4mMdkOdoDWsK3wbnsR0+tdhDSmVTTm32QUJa?=
 =?us-ascii?Q?sXIpyCdZFUVqxylShDGPd8e+b0fPeNPdjnaZDw+PZgN3YnJ12FXyzMQJ2W7X?=
 =?us-ascii?Q?gKOxwidJJzCjfQxaDiqJesWTMAw5L8NPBn9ZcyvYklRwMudr06Q/Ow6Wxmrc?=
 =?us-ascii?Q?Nlp3lqKjfqRcOX846nDcr+eZNUVQFRTOj9D2V0fLOPU7Ucbk4VnwQNQNaLuE?=
 =?us-ascii?Q?gfCLp6e/hOdaxI+fypQ6Rk3fGEaceCB3/doHw35o/INhi7tYlUqk3oniZirv?=
 =?us-ascii?Q?P2ItN5mnIOpITMPlSI5JXKwEan0bs66GSkHWKmtgyRpICwx0gvgyUBfR1da7?=
 =?us-ascii?Q?Y2okXpwRxEtutwxeAYI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dD82BxeAWJqmhYtnCnBwU7atUj7mGTEXQcsLD+TU/hg3e9QjEP/HqsybWXcw?=
 =?us-ascii?Q?yvjJoaI+ai4kJCxtHyLiNIdIC+HL6nElzV1qqcafQnj+50L31jWBc+AWPMa0?=
 =?us-ascii?Q?1dUliVgM9dmpnqEvHAnOJa0vIugfDjIf/ILyeBXZ23y4ZGwsB35L9n0RMqkD?=
 =?us-ascii?Q?Ej7blZFL3VN8Lyutbzy/3iFFc8FcUorfEiLCF3FcW/ENbwqYYv+SBLlIOXrc?=
 =?us-ascii?Q?hSrOErVPfHrdWYb3mzsiXDJzjzK+qbRIcIDmdWe+5ZEogFcU3xuUr3c5aP9l?=
 =?us-ascii?Q?AfrfHP1OmrkjNn0afCiFJWGSyVsT4mDMbTEiR+B+51uM/iraM9m8TQOx/QYF?=
 =?us-ascii?Q?3L9KC7TzQzO0xUgNX88tYhU8yU3uv9ZGcmezR3HR/p+OFvz1Po0G2TCmzZFp?=
 =?us-ascii?Q?5D+eLW/vxyENFQ34gMuJFWdkDkatE+oxz1uaYnOVffU+Ft2P8V8+AYAEXORv?=
 =?us-ascii?Q?C8ytiNg/WfFXUkROAns9kz2aDTOyFInpzV5hSZbnResb8paoEi8eXrGIn9OC?=
 =?us-ascii?Q?gCp28XFI8YGXFZOp2dHKGHkr/e3QaEHsKKfG9dJVQ6cYq0u5tSaxr/tCmkdP?=
 =?us-ascii?Q?loY81uiT0jeJ4qhViRsRDXlpuZxVVTNWOsKsnQ5gjot5+HlYTf+/kVFg3zJu?=
 =?us-ascii?Q?lOh2fm9A+4dcJtvw2OL0E6mnJ/tE/jHeGt6HANLYwXPO7iALBTyNf75oWYR7?=
 =?us-ascii?Q?OyXu+IjKAZFHbrMdSNM2twoHBTzRm29tVIYt/h5U0CQ8mGHGT8xUIWF853bO?=
 =?us-ascii?Q?TKhZTDxOJsejlOXmZt83/2s/B3dJb7YbM+k8d2J3L0ebhlgrMtiM9MsS3VrT?=
 =?us-ascii?Q?LwDK1EYBSfOKbbQZFklpIOSHYHgSrMj4xKX6nfL+1s2C4zJFNih51ng2/4/A?=
 =?us-ascii?Q?ut4dqmFaNywwl4E2GbVbkCdQcmGxEQQJ8YY5rLDG7DIC72LDFrMXY1Yy7IBv?=
 =?us-ascii?Q?PyeuHEb7Ykj/T+OPpBGpEl3Q5H0oijsWH/k8hePl11QawI222WA0B4xEO6SZ?=
 =?us-ascii?Q?cRUmCJMhrcygTHKdF7Udy24wy9Pyx/9YTJolzEH6CjPDrVoQLKW6lcFZoAMW?=
 =?us-ascii?Q?CqgqECsko0L1zO51PkjOrbmbKNCC/X9y9POWpsWps1Ibxv5BJxNbm2TWQ/mV?=
 =?us-ascii?Q?8HX+yljXTB1a00O01Uyr8oJ1r05/J7Pu6zCK163zn6f+8ZU4X9v3xn2NEP49?=
 =?us-ascii?Q?DyqZD0Gifi2doUU9wgSoSAbRsBDpY7E2KZrxyB8cOicl74hgG4acXBeK2LqP?=
 =?us-ascii?Q?nwtpE9LkyCa1uBskGrMo1AIywD/5K6L2HUjgoxbc6+eUyc9wCO8iunGHtoTy?=
 =?us-ascii?Q?8/trz8vf0uNk5DCB/QAF+P1A7YnYVGk+YYO9e8TEQVzpbWY63xZ5KQGwbhVX?=
 =?us-ascii?Q?0tGaA+/ksPJNAMn3ZMNK1TdBpMLWgqhwgmoV+Tp8dr//k3TTsbHVsr9dI6Ly?=
 =?us-ascii?Q?xOqP099nMOgYEroKam+tJwYlvY/7U94fBhgU6YHG9I07ukR4gctQ1mBrstNO?=
 =?us-ascii?Q?r3Ehp/6T220PvU2dUDzAP/dlTxlNBfQGGnvrtFVTNRRHCK3rXWXpbKElY5vg?=
 =?us-ascii?Q?rVOcqU4rRfVLslFSk8hm4hbsh5Qf01LGg4VBcEUWdEMiLRb0qJQnW2Djp9LS?=
 =?us-ascii?Q?N/PJhsbwOoSzrV0MxY9bE5SwqlcNr/A+c2kPj7SyxjaSBpxT5MP+N6SMZM7J?=
 =?us-ascii?Q?xB4FFIFz4+WhorZJxpe8AmNumIUCr+HYRtGhHEMkPvuhVdhf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 629ad36a-ce25-4280-8cd0-08de741bfc02
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 03:14:27.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dyx5YSnPRo26I1EmYTHHpHTwCfJ+heO55gSFPy2JHa0FWRzZro/FFBZSlJ7eMfMJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6912
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 491D840009
X-Stat-Signature: c5w66ryceg55ag5bt88qysxabh8a67fg
X-HE-Tag: 1771989272-357111
X-HE-Meta: U2FsdGVkX18Ju58L+JRAsbzbYj5i38DgNqXEA0j5m/1gGhxzM/3ClJJAMWTFrlScGam91qxGdIW4ji+v96zH/1mwGNyF+AC+meucCQNe1MVvlEGog1eh1L8co2ZWkhu3rPDkhyOjO5Qs4iyzg9LQZhNakpzuiP0RaIKSj+YaDBPdKDwW5NQFgq1Jk31hps3qrRohe4J60sm4IxE/nHtP2oXBuzbTtQJiVKJvIsluPzicshCcccf60O8M6WOG7wa37ljMCK8Q6C2+txnplEEmg9BEi8ajvpgND8F52SSrJnGmgTsO9Ws9BK3QE/MC5zpU8g9Zm3nkuA8ABWyFcno7P/H150XdeosMp/yglLQb8YBvIHWB99WbYlc94F/4GPzSSAn8Q5IBdyc6qaWTRH1Afw7Yv6SdsQnwePXUNT2CJRF+tKzizHatRzUIcYPCyX2zVo56R9EeiUt8ACFkqJdYtU17vZYQz+LvKeyEfazlmOr/wyTtOjXTd1jnaVlhECwjfK9J/YgVZnn9KUdKpB7Rcn/ln+1HCuRrVAJuBV+0WLWQEj6/elnag1O9S50VnFwzqxC+K1I+yYLchCIwTSKTM43R6FGOi4jsd6ig2jIBOZr1EGGyOR0oFTS62VyxBCZJLH2KHROLv6hvIV0UlLTXeSRwH29gGepOPJhaIug4pYjAJ6i6K1VJJoUaDz9NRiPptJuCXYelvfSjtuyilcYQUEWtio00fKY+CK6xpRjpQtFd7p5FpBufipe2+p6d+Tz1hlY1PsrXAlhOd7E49TW5H3kF+3vAY/cuZcDLChwU4pAQLPLSo1Njr1hmC7YA8QEaVzIH8WzJgpNE+hgz4MK6BNVoIWT3NhiH26FQNnFCkcinJ/21bEqmg8iEYhNLyfHOWVWsLKJCEx8XJ3OmHgn1CDIQZFDg5TR8J7FGUX5gHLn8qTtGpeUmswUK5EGDOq+uyoJZiSPlzQCAIL5qenN
 7mO8tmGT
 2sryj4LzDpRti/MjGpA4C3pwoRzrLwtWo6sdhFWBobL4Zdk1LN79LuMMTz8B8wy8ZQUfLfbyPisizAo4giYkTWaf+6mf4uBg1UGn9M8jIeoT0IQyPnKDKOS9p3MdsuPpYL7ky5y0X80LyS3i9SqSKddz0oKxkXI2tDubtWJVuQICLreNnW+7hvwM97A6G2JHWdPckAPQ/HBsnfGkwD9C3Ix0rKgcEm9kEnqeHT1MjX+TZuCB3HbzZFKSRnfIZtYziu67DLGl7lLjYSkBsYryMlDI7EydgI2Y+WIFpaL6L80rPBY1cPekg6lppKbpd5aR2rLyskSCzaPTKMBfyQtcALDZJQU1EEQKuKeRcpirkQCqpz6nlKLwlLH7/nMitTxoMhOlCxjWie51G4ZFxpOX7fEnH9oB0oUenvi1uu5pjv2y3kcn3OIPscVzBeJMJW0y6Iij+8gkVVQoZOMnaXk6BxuO//8Q+oNZwHmNuaOAMc4T6fZP9klaLH/sQOA2Ilwl1dPTpoRuvBaMsK1h31/FdaAnPDxqZ2HDB566X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
with side effect inside it is incorrect. Collect all !put_page_testzero()
results and check the sum using WARN instead after the loop. It restores
the same check in free_contig_range() before commit
e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
the commit prior to the Fixes one.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Reported-by: Ron Economos <re@w6rz.net>
Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
From V2:
- Collect !put_page_testzero() to get the right result.

From V1:
- Collect all put_page_testzero() results and do a single WARN after the
  loop.

 mm/cma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d..15cc0ae76c8e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
+	unsigned long ret = 0;
 	unsigned long i, pfn;
 
 	cmr = find_cma_memrange(cma, pages, count);
@@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	pfn = page_to_pfn(pages);
 	for (i = 0; i < count; i++, pfn++)
-		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+		ret += !put_page_testzero(pfn_to_page(pfn));
+
+	WARN(ret, "%lu pages are still in use!\n", ret);
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
-- 
2.51.0


