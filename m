Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C740CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798E08E0005; Tue,  2 Sep 2025 16:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76FD28E0001; Tue,  2 Sep 2025 16:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6853C8E0005; Tue,  2 Sep 2025 16:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57B118E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:08:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1060A856FA
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:08:36 +0000 (UTC)
X-FDA: 83845397832.08.0EB0511
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 402F9140013
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:08:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UgNOIh/5";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 40.107.96.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71zJY5s5bxTDGhpjlGjMHYVvhmCc4jsEDDlLtNLrzQE=;
	b=77biLV4hGSkNonCZTSNOs5UgXFJvh5hUJNcHDYu0u1w4fIEvEnCPJRLmdv4azVHZAgbFgE
	xa3sq/oCfmkTkB2WXZrRA4e3AGv6X6diFWm3MCy7qPMzwQRLIsHOWN2x7brzTRRzs8C52C
	5ya87ma7MPPO84MJcGjFfAHgwxxT/TU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756843713; a=rsa-sha256;
	cv=pass;
	b=O5xA6XtserOmWarJyPD1uLJdrguSkCktJijjWoOzwffyrDRqUXs8ZO+ld59V7+kwoA0Uyi
	7GLeda4hmugf5Q90G72mrXREpl9bFJLXeku5oQftcwc1qHxmn7cPfK9lwO1/DzyccjHist
	BhM555vTg5Pw1FZToOZuc3T42yd+UfM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UgNOIh/5";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 40.107.96.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fma1X0mQHVxv7vUnD2LONshAYCBO0UpSCqVm9o6JpHZbckg68e69XHzHvpL16MZdFsEgS6kBh5HTQsBTdFzpVR7zIMl8+UhbYwY8SOH1RB2VTfMgbmqnM7hP6M3Gy7xsqWEkTkozboGL2gYhRgADITDo09qjsyHmSrw1yyRbx7YYNa2JS2PnxhjI+Q2C1yOstVjpxFybR7dLCEC04m86GNtpf2/Vh4yDSKMgsjDkeeVuBRERPaCn1+YF0fQELRJZetLXcTdCSfQVlMfmlp05vt4yIv5XWTfG8wSVbksZSFpxO+fo9ePAljJpPFCk2QmdpHOGRo0rOKNQS5pVdH2LyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71zJY5s5bxTDGhpjlGjMHYVvhmCc4jsEDDlLtNLrzQE=;
 b=tMWmHdPgXTFOcOyaBoJDb5VXSy8FXB4FvnrCTFQZNaFcvk+6IWXEvTeRkoKosvTLgk4OMU+NFdkHpuK/OAlgSftJpsvLCS81scLlhE2BoQE/5+F16YoypUR60PE92NS5bv7Sv+3cQFZHORGoBBK45T9F0oijzLsYPeDTgUY4CRPvqoHA3/1ooAHFFRYgIb1vqgxOHOjepKx8QoLp8jvynYYeaBz1XSkj6QKGXbYQb1tMkYe6JBv4xkXCUre+WIHCfKBbFEYwpylrUIkyPMkdUVAIVhcoh4cud65M68uPBZm6Zr9TENjzgD3H408kpRU9X+wvXP5H7xFAoOPHb6CNow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71zJY5s5bxTDGhpjlGjMHYVvhmCc4jsEDDlLtNLrzQE=;
 b=UgNOIh/5XA0FdWZk5tLFsASlCrlqNlrX7vBVpU4xlwfC8cYihmw6Po7xHeotnAqcWPtd6rtJEwLD3jwAPL2aVW+cA5kYPeMOJoO/+xMavbfXFE6cso6JqjaNpqJv/8UcwKE7IfjPMcFrX12u7yQpgi+ed9Xu2MZDv0JzN2d6DUMoVskfGLcoxmXuflQeQ9EPG3cmZ85vtxHOhbgLBePsz24QUsMfvUt4PlbXps1/24eA+I1JNRIWUD4b4wz/0r4gNoeP24gbAW7ZV/aWj0bmfNAjnEUjobC72TiduDDzfYrulrHFz+Wn1m02q4tdvzuTUH/+wP/p9z/BI7AqL1rAxg==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6529.namprd12.prod.outlook.com (2603:10b6:208:3a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 20:08:30 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 20:08:29 +0000
Date: Tue, 2 Sep 2025 17:08:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: Re: Where to put page->memdesc initially
Message-ID: <20250902200827.GP186519@nvidia.com>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLc_nckaDc2ePRv7@casper.infradead.org>
X-ClientProxiedBy: YT4PR01CA0466.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6529:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af5799b-b446-45eb-7d45-08ddea5c7bbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YOxFNb60QIsVmigmfs8R8zjE4Hs/zHBdKFm87TE9drIEIFXm1JlgGFNo4ivb?=
 =?us-ascii?Q?+XAvgF3RgNy7PS4UOQdaZIOHzPCGcNuZUSKFhIPtN4Tz0nZW2B3LwtHiSuxJ?=
 =?us-ascii?Q?hjJC5PxHfShhDw3kbBKU2RAJitWSuqzY2kXVNaB1m236K/lE7oBqzVlKXcUi?=
 =?us-ascii?Q?yJRfw19kXC7tH81b/cKjZnCsGtfGgNVhZvrVTs7v44qOl1ewY3xM7PtuZdh8?=
 =?us-ascii?Q?4JIYIxZUFu6Wi3jLvBjivUhRZt6ElQzFngtLE/7Qbur5rp2Z5QIcD0c5rVEF?=
 =?us-ascii?Q?kzqv+dwPdoiCrugTBzQ+Vysqzw15xq0C8xPKrwK3B9Dt783h1uNXQJpHat3M?=
 =?us-ascii?Q?qf33suy85siNfLdq2TcSfLzTaRYZimMWSCKfg/HEX1E1ahdbMti7gI+XEFb4?=
 =?us-ascii?Q?roZvdadPlQKKUDSmhQO2PJA4aECpzLnn2NxFYjiXJid9//Zj7BlBpe42n3tb?=
 =?us-ascii?Q?4fA7gmn8TnbnRh8PSBYc9W26C9LK/+ngAH++RPer/UuBaY6L8GSsWj2ywArH?=
 =?us-ascii?Q?Vwg95EIrPtRWPjs8lEujXQ1l2LfVPFo6iFYKlgF98a0V3NNxSmmQu4XM67pj?=
 =?us-ascii?Q?UryRv1JiotHpe6r67+XYkm2WK8L8R9RE+qI2DG/kx1/utmVy6S7BGb5KF5Ib?=
 =?us-ascii?Q?4zK76i3DekbM42tUtgGK9mC3hJVPtMOFcqiZyiEe2vtDaJtMHEQlbmkwwrbK?=
 =?us-ascii?Q?nuCHf6L/5Mdn1w8NhC5mdKgeH3t50fX0UCBq+CKBoubLFHCDezg1eQZa51Sf?=
 =?us-ascii?Q?BnQ7H6cz1ERrEasqPwdcDi43XF3l2alZDK/RjwutHetxCrVVmfH6/Uk5innt?=
 =?us-ascii?Q?Hyu1kloH87WGzmTBSWgXrDplGZBgbGHJi8IMv0CVe1i/TBhapXCR2s7grXfn?=
 =?us-ascii?Q?rPKvh/sY8rE3dmRgicvaXYRxDYB/XdldMNA+G/DQ60elx6xGBd5Ju37uIEZm?=
 =?us-ascii?Q?2/hmuZDJuBEePyP099W8vo6e+pAbtjAfNWGlcLdPoaUzuuue3TYgJf34MviQ?=
 =?us-ascii?Q?ZwbyAgA6ZU+2Yu9PS2sBiFZH0Xmd0/JHJUHzSxocvAdk39piHiADXF/kon3R?=
 =?us-ascii?Q?JjO1GlW/c9p2BNoPmI2Q3ciH1KeeHTJpryy4ymPAZJ3VroCs6Dh7tKRo0JWe?=
 =?us-ascii?Q?TygE+rBOm8+KMz7GF6SNapRxBxa4K+gP9CPB0K26JbZdH8tEOnwJtqyq7lfK?=
 =?us-ascii?Q?LAGL9rdN8xabEDEkpx2qKjqsKw3RDKRxICMU5mXQswxu76Aqn5Fi4Q22BzZC?=
 =?us-ascii?Q?ybkpGyaIGFy4xNUprEI8BKbSXmCYm0ZBOl5zFV07d2wXkjZgWGXl1FK1OXCc?=
 =?us-ascii?Q?IopLdajEGoLALdcMLyOTCxYAJnVRa5/LK9zLfeBJf4VVrzAcfhLQWDZvb1OX?=
 =?us-ascii?Q?fkT5BdbzbRc+OFwHYpWmgos+h6Hd1nyLpxKdisebENBwkUKA3/tkoKlBR6E9?=
 =?us-ascii?Q?t2oUY1cGXQQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tsUcCLHdhxImrA9BFcw4Qgn/a/tppJBkGt8H9mihUTZMUqZ75hwGJiKnZcVk?=
 =?us-ascii?Q?WjMrte60f2U56brfUmkyIQEW7EE3dxP3qLjj3N8N+dFIhlMeoL033S3qnNBg?=
 =?us-ascii?Q?ueY8QhTvY6EmAgmDrz6izko2G8MRtBkQJrCyP3rC2bv77KYF3ttxT6aJ0Apy?=
 =?us-ascii?Q?8JeTAsuoz8HciH2V76V63qsCi42+xToH9xt7CI75UEh+1nbV90uZyCS33NUw?=
 =?us-ascii?Q?G6qlx8AP7sTGq7aYvi3cZ1h5nt2m88rRXhSF8sjH9Clx5N7+0ZpP5TjPp800?=
 =?us-ascii?Q?lLoISNcO4xOS0ckxcxBBrGHbQDxlv0xS59Y54YrlWmwtOnzeMHkwr64xGU27?=
 =?us-ascii?Q?+Wd3QUd80bnYQ/iqaFyzm+wJoWWUjT83ce2L6oITWEs2shk8sDdelr45MhDu?=
 =?us-ascii?Q?xIKqYPBccw3oVQRmruZM7C9qkqdW6nDNSYFLHJnynglRJl361WxJByd1mtCB?=
 =?us-ascii?Q?N+yM2ztLLIPjG1nCnfmi8nJ+4TpXFzbiwDRYS1Lm/8pl5Qh+DbcXKFvlrMqf?=
 =?us-ascii?Q?2i3uojtUgB2bEYHhEZGcrhYbwy6JvC8c3zJM0AS2oGEh2KeDH0CAumk7xP6a?=
 =?us-ascii?Q?eAeXXXnDfxhF8xd/aL/Icg/I1QiVstvNlKLOL77gyoco7FBi5N9dJ7g1eWKH?=
 =?us-ascii?Q?qX/PSARREvgDSvvxUJKr0oLzS3qxN/6JOgVziBRKprc2VcTIyZNuaDwjxUt3?=
 =?us-ascii?Q?uL03DPrDHX1U7n877ksd1N1L/LfVfx2/85rp1SIccYHwF8IPNktVA6hTBV6s?=
 =?us-ascii?Q?Dt7v8YdG8duwrpZt9SWUrfwpUUrI9lBJSlx3pST4TEDHgEEsA2TzxSQWoALQ?=
 =?us-ascii?Q?A91J4oEJA1lfZUuT2GPwylYzPI2iwJFr75HHTY9o7bsqFS04CzCCTJ6awc0q?=
 =?us-ascii?Q?8PavisgJU/Knwkjb795gARDd48dmlMNs0ZnjWsnOGASnZNDbyaQSCj9UlPXI?=
 =?us-ascii?Q?UwVQ0yE3aVPZraomD/e73Zoeciig7mcGkuxU2klZ3oTbA4B3PJ2AMtl/g3Eq?=
 =?us-ascii?Q?x4/9kgzx0IrjRM7um+ZEkO9/UUw1jt4RaoTSYiZLPcE+eZKhPvb7pXMfEQYM?=
 =?us-ascii?Q?CA/dI3j6/aCWAXJj2UIgXC168h9bqaGmeMSOWXcmILvhJROC5cwJNrXx9fbW?=
 =?us-ascii?Q?/R2MJ/tGt6qLuzzp7mdt2pEicUcCq1WReok/Kk3bOhHa8wAdVod2sZ0ik2wY?=
 =?us-ascii?Q?vUnUVGJmnNl2H+zTJu7Uuj6m1q366iKOyhakB9GGI2yg31TWaAqNzQeVFINe?=
 =?us-ascii?Q?AYEqAu9fqRVqxmBRmrnSFtQmr7aOuIY3Y38a4XU8NThm7wLzjAAvdN0bGYbr?=
 =?us-ascii?Q?kZXzSxZSddfoZzXoU5316JVBfWJKXx+eF4gzX1CkBi0MVRoZIsBpI/eOM3tS?=
 =?us-ascii?Q?Rj7vN0ADmd6S/fOQQK07xnSEFzS1Uvi1LthSJgus2DnnJxBMoKz9ZjBXOxYC?=
 =?us-ascii?Q?oGixJalr1Nib5irt1l04k3z4c4a6ia3J9Ee9826DRs/CDJLhSh1XN6enetop?=
 =?us-ascii?Q?xMJet81JmmmfZRtDm0N1xRRKOiBP0yoxbilpi0aNsjetAK1FnkS661Gpl993?=
 =?us-ascii?Q?IQXX6X8vkoJajNEXuqw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af5799b-b446-45eb-7d45-08ddea5c7bbd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 20:08:29.8046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +CEv94zoGnOedWk85H777EGenbhf/xV3/iAAjyGefAMkoDQBgxqvCP9kpuDKDChx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6529
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 402F9140013
X-Stat-Signature: djfh9bnqiy6ysbadzt3e96hy4nr3x93f
X-Rspam-User: 
X-HE-Tag: 1756843713-102238
X-HE-Meta: U2FsdGVkX190CUL3R34cxZFrg/Xa6fqTflVs0b8IMEtMFNoBPWmqY5uPK9f8v5b//0IGDtM0ecedjYK6/8iIaMVZmekhylx4p2aWGph+JAMY7YK+KeXY8XEGEoMBwi0YHhOLODwqFyn8761vymlNcvImwIxwFzovEFbu+ZvM3m5ROKmnVVUHTq+GmEx5moWRaPuFThvpCIx+AmlaBL5M6pBjzxUlWffKwsOHOkSQsmLg/zIjaM1dBkKK0Sa4C43GQVa3Qz0UU5h8+OUXxFzfmOj42nQpvYEP4matyQxbIX2GcgoyVfNBDge1ZpqFB1FUozSN4Wldg4dyPfRcxUc4Nh4quTBCmucmeznRLc9CzCyXNb6xoxM5V+7LN1VOdihL+WpJqA4768PE5puxONkDXAoIuuNBw4i20qki/e+ziy0z0eTPOeQpG8b1vXQLSsyxZixrXjIdnZ5VNjuOhZg/5DCUNO21pRSaE8nJuofvpe+iMaWwztjVpPQN+TKkdWh2geUeMxsy4T+OfFenYtQMjsW/MJzUf8IsZNCUgBZdP6T6ybg+RLbphmBvmouPNYoBduEbvG3i0RGGXfiG2RX5bg5suDDb2I7z8t5uaOjU6ViTLIpMaAGD/6kychsPXREQpUhAWE6LPb+3V3NHrKLYfCVkIPlt7vd4WE75XXk58sdJi8LIRf5Z+9cC6sFQVtxuBhujdHskIvf2d8/OmKRP1OXR7PkHgrawNSYNxQ+2U1YWqWA1Eu7imrn3KDqaBQ6d2X29VVhIeKOSXsDapbgCSYfkQrs6uafx/0YAInEjkgRNaCmaBCDj2FdQ46ZTaZh5jgd7Pk0y1xQhBu6yTZioZpEhIWpNolSRBwvnVSz8yn7vzMFH+6u/9pNUq5UBgFIGrOGC56rSdN5kVctvlm6bw1p1gseGAD0oor77Uq3Ur8Uz/A5cJo9hZjz2mp93xgeLxXTNNo7gj0Hngs6npNU
 kJAa2Elb
 vzBBDnoiV7I0TKo/Ewb9uekciBiQrdb3beuVv5FtAIXDa0jj+VSQgsfRLwRsHUWT0Wvop0n/67p2ZFou972pEwJYcb1pMwCZ3qJeWTkWzB6Mv9Z2ETv6FcNAJAykyBH0pEqV0Neh0E67JqKaycb9A94FXtdSopx/yS5pt6nPR/e6olgWfWmFMxhASSMz5Bv6O/iyPpHKjx39F83AuSgYFb8JTaNNqJc/Y5JoOcF5l3T4ud40K/JWFO7ds1IxRPyGegWb9ekT5t/RB9EnkZ7esnlFelbfY7WXx58at5iZn9mEJRVJVxfulbgFt+mvo8AUCJwk7csawAEf//WHB/eNWG+HpjpLqFD/jbFfi9mEkDuuwRXDC0UNqZ0sjeNC4yZqEk2vi6er9J8Ha5MlVt9oF/vH4UD4WMNXehtl154lNTgdH1DyQT7YHY5aBWlkxWUWfmR+GMrLb59koNi9BPurxO6zGCFDaGgTzhnrbaxBnuIpaqZh2UJGDm+B8EA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:03:57PM +0100, Matthew Wilcox wrote:
> So, page_slab() will first load page->memdesc (the same bits as
> page->lru.prev), check the bottom four bits match the slab memdesc, and
> also check page->page_type matches PGTY_slab.  I don't like this a lot,
> because it's two loads rather than one atomic load, but it should only
> be present for one commit.
> 
> In the next commit, we can separately allocate struct folio, make
> page->memdesc point to struct folio and drop the PGTY_slab check (as
> there will be no more uses of the first tail page for the mapcount stuff).

So to rephrase, there is no great free space for memdesc in struct
page right now, but after the folio is split then it is fine?

Thus you have a few commits within a single series where it is less
efficient?

Seems OK to me..

Jason

