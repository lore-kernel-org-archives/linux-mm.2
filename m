Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B4CC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0E86B00A8; Wed,  6 Aug 2025 14:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9006B00A9; Wed,  6 Aug 2025 14:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7566B00AA; Wed,  6 Aug 2025 14:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9776B00A8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:31:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36DC5115E8D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:31:30 +0000 (UTC)
X-FDA: 83747175540.18.26C36D2
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	by imf11.hostedemail.com (Postfix) with ESMTP id 74CC440006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:31:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jzmVHc1k;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.77 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754505087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUU08jHtr/p0F3C98WtJL/ECV1OnZ5K6fMT4toBtQIw=;
	b=DNqoc2/16LyeIMHPlJutzNLDGpc/IsFu1+5Y8VAGQDRKUj1o7wK5QnrkYd+2TgheD6v0FZ
	jj+OpsmEA+4SmV5AmrFCQO1wnkutPIUkxfC49GjLMFHG/SJoCCSagLwiPGi1LqXgkoXVhS
	1Tac0jgTPu44ui2GapSw5NczMpcf3xU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754505087; a=rsa-sha256;
	cv=pass;
	b=KDi038aXTKNVez/0EVEKqHC9SSAIUTB6k/cbNNITq9ZkxAj/7u074jEbWs6UN9J8WDhm2l
	8vX/gXPhzAxRne3kU2l/H82a98K+QdXS8D17gV+gVFXUn42inqQP25DUe2pEHoCfIH6U39
	dXAl1HW9chfXRCgTejvBWkq7aMEzo2w=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jzmVHc1k;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.77 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bitx9rznsLpuBGD2++6ozIzfdXJqvJY/xfGNyM6AE5wjUmGDPytdy3z/Zd36oxVaTgy9/VNu0W3OfzTM2jRVwEpt9pymNC366oRj2jK9DVsQBzGm1a4ss9DyhGeG1BLLsSG83ZRuRsvj5HiBitDJ7MOxNZSGiqdloJ+xi+Ew+u25aS1/KS+XJAcpYcS1i1v5gsia/xL4FvhlQel05+62JTcBjeLaufhasLftzd6vwYZJoP4SI6aD73VMyZ2jls8CE8RqGB1UFmGK3M10RVOLEQj3KGB7+Sd/QwrZNC2TWFAcP5jo9HXaEAFjy3vxolsBelTu1w5ZNn0F6uZQf7OOKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUU08jHtr/p0F3C98WtJL/ECV1OnZ5K6fMT4toBtQIw=;
 b=HXZTAqi3i+hlhBnbK/97VA+1v+KEEeckQiQ0PrIr8UeqX2WdZDJLXI4fX9ViRBI5zOjqmjJYY/ijYeL3TKPvMvONYBmvcHndfE4DNHKB81GGdzHIJ1gdYGusUy6j6lo8xi+Gxn9d1inGHH4XCs6+pUhgzSFXzyZrtTCpAWjTMt4myR1/zYLEPx9lKzBobyKlHcQZF+ib5oHUHkcNn5b+4bZxo1lHQ83gF6ZTxhIyQezxwGkDysFaBzGvR05mUW7kt3pSbJoxF8CX2rd+yAcm2//eFyx3AXUklHgKIW+vv3WtBwX1WjZPhM+8vtnUiDevCvCiN436it2c8oxUXG+OUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUU08jHtr/p0F3C98WtJL/ECV1OnZ5K6fMT4toBtQIw=;
 b=jzmVHc1kwdxVXg/CBmp+R2mH8vbu1X7GzWQYmSmNqMXXoElJIp79zs6WHfVengcZjxBO4FAFtmpzLGZgkIAXfoJb1x/yzIT02EPGrTRClsNaSWiyjVwZp1v+BnPc1tz7GlEoqCQ7On5B6NHLHjCQCgfg0vhheTo2MvZRSQ72HaZPwqxh8k00tBdYZvlHW/slXklVD/vHagfUAlzXTJY0KtqS73JaD286VoecDkdg8BxffLiW155WOtRzQzjPjGF+UTGI+Zy7C9mnHmGPEpmHF3RmPr8haqLkMC7antLLGL6UWy1NnqNOQxBZd1fpipYimuZTUbwlbPBOcPg6XYW5Gg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYYPR12MB8870.namprd12.prod.outlook.com (2603:10b6:930:bb::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.13; Wed, 6 Aug 2025 18:31:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 18:31:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm: Convert page_to_section() to memdesc_section()
Date: Wed, 06 Aug 2025 14:31:22 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <3DFB13AE-B22E-4B7C-A543-B3028FE85726@nvidia.com>
In-Reply-To: <20250805172307.1302730-3-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-3-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYYPR12MB8870:EE_
X-MS-Office365-Filtering-Correlation-Id: 45dc7703-9a86-403d-35eb-08ddd51772a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YINES2zbOJ5gNG8MTNhVV9L1j4pkQ480XfHG6Bqb3jEa/QNDan7Z6eqD/WRu?=
 =?us-ascii?Q?LZ3lJ/eABqUZUuwBCaGGtoVxUhy9eVz8Y6J448sz3QPg4CVUeGqkOgrK7oNz?=
 =?us-ascii?Q?cc0hwDwr1kH6QAmZ6zU0F3xny//LfdOFgvYjitpOHVUHK/JI6TgMKuohm5zY?=
 =?us-ascii?Q?wlEW8sRoQOIKh7JLvRKs7B6fRBP1qTCqP4DiuKjSiCK+uRlsPJc4tzdBPDIn?=
 =?us-ascii?Q?6Hc+JgdrT0n3YOsZNFrPEIl1tqtrZZpBvjl454g43OonIAzhQOBpedTIuHWV?=
 =?us-ascii?Q?hW3o5N8bgRTr36kf9/Oj6OkRr+zPJtcOrIYgCuD4bERpN7epPegFXB8SW/lt?=
 =?us-ascii?Q?VngrkEbpfNHLgVTSHP8Egd7TmOEVheL899Z7brjUHjKkkuJz3MKxrvcaArrK?=
 =?us-ascii?Q?3wxsxsmQR5mtQ16KYFZfc12BzZlxyE31oRL3alx3yGmqhGImiNJ/EqCHRRVA?=
 =?us-ascii?Q?eJiDAWcS2vh4Cv9/iMWc40h29hqdRYqBpYGvw6r8xlAoBJ41t5i7xrFSr18b?=
 =?us-ascii?Q?7ZLpeAEElJPaJY9+yo1FVOBmVArMtHkKxmV4LPLHbm/R/+oBE+AwpiKrHw3Z?=
 =?us-ascii?Q?jBKhSsv0LrzCWOscuI+g3ZJ/YBBelReJtpWDQ5GzekMHqc7TBCkXvOuJUJ+b?=
 =?us-ascii?Q?MznL5+2bXfBORSlhOSW97OYKjcKpBtH4Ud4SolS/i9Pfy0zbZkajCsbQV5X8?=
 =?us-ascii?Q?QWHYau+BDYQRGEBkBHDPrUgxbcgjrasoBAhcuFo2iNZcsnUpwl1Qcy28+rot?=
 =?us-ascii?Q?XgeObFyUyTT/z25JrYUd8wKq+6KDZ2fZx8WVbPcg2EXiEhGre0GwhJhkSuqW?=
 =?us-ascii?Q?tR6DN4hjMrW4jaqCljOenUmXMrOgB5/7F3gjt7sjYNqkdWYJWyR3EpXnKKH7?=
 =?us-ascii?Q?xrEQvzpE/ZIHt9SmitRLsm8zVB40tJylDQGQLhXgZSpfhWXkbpPC5jnoEQYp?=
 =?us-ascii?Q?SkgpF05hzoDQibbbtjUsC8e+sOU+5YMM1Jd1+pO+6xdim23HmZnDi5zCaRQ5?=
 =?us-ascii?Q?7DKPV7BQUAL3tRBexmS+PEvG9DLK9+zH7n2VeiHIEr9PoOrIXcCi5w3tKbq9?=
 =?us-ascii?Q?Rth5riZmbdLC6U8IPHfZSvTVSt5SJoHvxtseIeG2LZq3rTSJkuoxj76nYfo2?=
 =?us-ascii?Q?DzfnJ06pcmYHvbkue56+6nTaRXnnMDUz4WmXSeCloMobZ6el9/4oQPGfORW4?=
 =?us-ascii?Q?XDHdXQaO7o1cvrf7ZAPkx41gSef/pO/qm+0hzIOTPL2CbYI3SSlBO2R05JCw?=
 =?us-ascii?Q?NqS/TANqjn4p/lXUrJ4kADYj4eQV2yGvmXqpbn4VMTO6zJmgrtlAcEdM0yDe?=
 =?us-ascii?Q?Uuq9NwewJdCrgfirTZGbQoYTxay/+j9oDIRWJPX614pRsEnna4wPJe978dNj?=
 =?us-ascii?Q?tZL1lytjWVeYBrlCNe2wqcOrSHkZm+H9psOnK0H6dmv6NpEbXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D6nXQFnNOi44+4yMIh+UjAP0PAvQnhzBmkptlvqoxzQ4BijkbmG5dcXXDrCv?=
 =?us-ascii?Q?/rsLFHRGDFwWQhDubgkOw8dAW3dMHuLKKOWo9atX/2P79DJ4wMFsOaiBjkFW?=
 =?us-ascii?Q?JBpI7bnCFL/pmRDDLgP0aByv6dhfVtdOVz42wPmhuOZPI9L0lJDxeCIMoaZ9?=
 =?us-ascii?Q?pWxwB5FQJt9JEQ3/6Yb1OGOgeii8IUdF+R5r+jb3B7RBX2IerUV6L+9BxqMh?=
 =?us-ascii?Q?u+Um58sH0H94sISzpAeVCQYh8JramWlMgNnAr4CC4VRne8vUQMUi4zOPpnou?=
 =?us-ascii?Q?laCeSGQOud8ygiqxYoZp0s6cMDCPtX290mj3dW4JD9wHhH4a/bsAFzlJo4+N?=
 =?us-ascii?Q?HfkZHeyFHVTZxGgHf5EwCw2Uq6hWHhir+DFygSFw0BRm82qACEP7iD83WFVV?=
 =?us-ascii?Q?UNlnvPIWNvTA8i1wRDz4ILhhsyHAdC4eHVKp4IN/iclwhgnjcWVObZ3v/iVE?=
 =?us-ascii?Q?KBAka2FPwFu1UCB6O0RdoCzdOEdqvvw5mZ1QC5ZD9gAOV7X2yGTNr6NMUP2S?=
 =?us-ascii?Q?keJhO7QxysCEq5Y3ViB1sQRGZ5dCJUNE6Gci6DsrZIwRrYwEc/2m2a4Wu6SL?=
 =?us-ascii?Q?+aIFI8UO14Y0M5AS8pY2vtlbPu/LxXraAKNGck+bEhs+M4W4KMzd834c9uXY?=
 =?us-ascii?Q?9Yy0U+fRNV5hM7Hr2TcA02Ppqx5B9CRqt75ZbgfJwFE3XmOUUB7KxWSu1Z4i?=
 =?us-ascii?Q?SwHDPCtvJA5M2r+J0qQ54xFe+haBeXcOnJacVPoLZ0lM66Indlo6b0kZFSVo?=
 =?us-ascii?Q?84s/+8JvX55JROFqZ1drCbt75msZE4DHmiYRTR59+ln3EEKS2SrA50r1abHN?=
 =?us-ascii?Q?z0k5kSJDCQ7vQ/YNR7jB4+PXQMDfO6LDoc1pNMwJhAGzdMrWDzKUoiLpgLBP?=
 =?us-ascii?Q?ZiEjxdIgjjzMBgLZtn2kklnOgbxoByNirNLO4zct7FnO/QkF2+9z5EjG/LRT?=
 =?us-ascii?Q?orShxoOxGjHmVMlZ/teUmzWLu2OxPxS9/JGoi2/Q6Pwbkjtuad+Wc3KOCizc?=
 =?us-ascii?Q?To73j+gGuoqTcm+uuYw8eU75YPYXkSmZA2Lx3I/pkEHqG0oQ3AfWZ2ltY+sX?=
 =?us-ascii?Q?Rp3mN78vp8eGpRUuMUzs3oZEgwu49ACttOhgNUpfnlOjtRvLyUH2vCWIUwL7?=
 =?us-ascii?Q?v3dCSZlrk3A9VSyd8zKxLgelUDJlZyMtyp+7LjYjgVEa18ZDkc5G/qNUNOIl?=
 =?us-ascii?Q?V3iL+9w8EFro+tLxBNDHbT+spFSlODyaL54bXCCzaLX3iRiUgcBlNYLkgpa6?=
 =?us-ascii?Q?4/n+dbvwC0BUBikQqPWOkYOSrnrfhejymf6ZTn7AJ/1FsY7+BTIP/W4SwW8W?=
 =?us-ascii?Q?vKdnd1yRp3asuY+n4bONNTPFIcBIe2ThQVhDAtVJ3U9GXZHWs97YJRXGOnT4?=
 =?us-ascii?Q?etnemiKv6yKNcZihVfIFfmn7Mp/SiiiY/MwIb3f7ZUjJoVMgxM9F9d7x6W3B?=
 =?us-ascii?Q?cM0t1/G3dWpcp3/IaUKwbSbGMr4jec/qc9OQG2ewnVjRDOYngkkdNTLArrWG?=
 =?us-ascii?Q?+X0tfDN7xFZas7+LPvbvLRJGvIEqKEJns1sHIOyvKVrKizFIggBzvpy7e4NR?=
 =?us-ascii?Q?bBv0m1IMDLNcunp5cTtpPIt1eKDRIOjW/S/GwTnY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dc7703-9a86-403d-35eb-08ddd51772a9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 18:31:24.2416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfbzvnhJIJLZrc6osWYwM6l7kMuBs0Tk8EVUXl/LFl8FD0OjS6zb+QUTTvP5I9QS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8870
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 74CC440006
X-Stat-Signature: ws9j4mnqfuoxy1kumk4ubodo4yeub6ke
X-Rspam-User: 
X-HE-Tag: 1754505087-559726
X-HE-Meta: U2FsdGVkX1+R+j1VHvKdf7kcCQ8Ctwh+O3hgPsH0+0ZXmdm99MjE2d1wkd7dwJOB1ZjPNri/N6FsWQ2+6R22t8C+sckroT1YuP73tJFvkMNcsTmFwNc+U9WnZLZvjV0GyKNW751dsDnMOoXy2QVtKsW1ZbdDqPhahyGbWFLOEu4Ty5ps0LJJnzlEyN6geMHh45hQhdhMcDMsbGW6DOBkaQtdXhxmBymUmjtQN/y+mmEE8L6wCXpo4yqmxx8SZyymKsD7ff7PRwFIw7RWdOZnXJdp+yXmKWie1RMID/AbyDqOK2nBImiOu461nXZG2P12jsI3KTZgAbvhT+Y5i9YQPPYZ3wPfYEnskNnqrLBU/lEuLWdzcs5NZNpQ6hLKPlLCIZ+ILL25Zwj3zNM4XIBRUddwpMqHCYj2gE4KUJqJjJVdgp/u9vdDAH6pkX3OZQXLmwmxaNDZtyfAJ4+x8WkCJutYypAJDGGxzA3pEJu5Zfs6jMvXEv8JrHqVZEt9m0F9tMM7Pd8ojdYOmeP291Y1d8B6MqifMXz3+MA1Pa5IYCKadJW0CsL9vay+S/v4UdQVm1651EXpUo+FSuUFzb9/ZugwXjWzBZiYnwQ4VUyCTWFUu3RiKtVjSM9Z+jHRs1xgIyjf77SHkvlTJE2vSO/SR+XdWfz/FwAHtfVvIjNQjA+2LJUJ+0FnkXyUW0v725rGdpI0OybNF3kNp5wJBiQ+2q1ioZ4Y6SfCNcSWhrbKsdktINrlqtJ0+4XzZoBQlRfiI+liO8ZW8pioklnaN1LVxDqzD8gpawS6ndSvtC1bNa6iWvFFHl7VgSv4kRkoSGi12jPaaXx6NiPQWaxBVqxNTZ31voa7WE9dUvq31rDJsRZIDHzBbtm6IdNufD3P+NIn06Xuv9LLFb2paSMomtiCZJwSsNTAjOanFcd2nrbJXg6EJz69IVTYgEoXFI3YnpZnljmSHSxPM2J9NhGTSqN
 Ql1BAGNs
 kPeo0nHfwCBihwt7hWjIoOQBZOLe5y899eq7k+w0ju+S1TjENutAZ91ADc/vn6G9JDB8M/G/DXXzVvpCc/tRLFbU978QTB8bvgivVPUITbjbSIFQSvJ4kOpuOrXeI5CWjDLKQz6Bu75KjmosI7UU32LD30gKuCYJbxLjabnQV4dVDSDWOxZWaNFBHQONb2TvoirpE6D7hNBxOrcD9KbECs9mSeALG/vbbrRml3thrtJov3V9RhtJzELwgPbD9WWTJuGjXhndJ713qR6uiyjhrnggnOV0ReuQGyONZdnLGUi1LAo9OAI83616wGhJ3WNjNUDZDrjbcSoSJBczTRe43QEUZZs1JMrItS3+4kUwd2C2NJr9oZ3XDtjNoITJWHPyRrJr8tEbADf2al/3itOk9qJBAunA7pkb0tMG+fFebJUc6PPW/Ws5tRggo1GotRs/rZCuFTa7vIDnWTo/nFf7sapv7vSM8cCQXC+TwMkaVVt4/zzO2gniZMf89jxZ446FhtOecCPENgAjsImYGAk7r+vFV/09jJgfiDYki2gOuxgSOAwQ4hHcEu8J+ivWWDPBHRu1vFybTrWW9HE8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> Pass in the memdesc_flags_t instead of a pointer to the page.  This will
> allow us to remove a few conversions to struct page in upcoming patches.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/asm-generic/memory_model.h | 2 +-
>  include/linux/mm.h                 | 4 ++--
>  mm/sparse.c                        | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

