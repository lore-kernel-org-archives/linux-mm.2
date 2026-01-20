Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DE1D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 11:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57AC6B03C1; Tue, 20 Jan 2026 06:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05A96B03C2; Tue, 20 Jan 2026 06:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDDD46B03C3; Tue, 20 Jan 2026 06:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A75736B03C1
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:00:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FB331AF25F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:00:42 +0000 (UTC)
X-FDA: 84352049124.24.CFC98BE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id E20A1C0011
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:00:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="lr/+G+Qi";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zyvEnosO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768906839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1ptC+Z2gypzN4UX7HqN9T2zJydM5XNUgxbEjkHBF4E=;
	b=rmlSwQcuiD5+v9eCAyqp6ANNKQDfjiMSxzv/XG82f3BCnXhPyH2zM5TtdujeUJB+xEiA7h
	NIvXN5LDfc4hrnrZXGwyBwfuwir4JZtWgEoWWo2vH+pnkb2WXdObB2Ki29hx9oG+nI04pa
	BriueBUblbtigWFNfMkXDZhHezNm1xM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="lr/+G+Qi";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zyvEnosO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768906839; a=rsa-sha256;
	cv=pass;
	b=DzOv3zdi0EeET6+xOMAMG5SSjeQy95ZpZQSCsoW4xbCJ8iolye6Pfw+r3mgogFEIWchM8t
	CZpm7Ooam/8b15GaCWZMG1hWOpb46TPerr5OrxwvZ7UABcqlwKoH5GQyGlQ6iXLmmi6NjX
	fRxCYkPl3WC/7XuElquK1TWWt7sE+I0=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7v5EC3523836;
	Tue, 20 Jan 2026 11:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+1ptC+Z2gypzN4UX7H
	qN9T2zJydM5XNUgxbEjkHBF4E=; b=lr/+G+Qis1RBQQL6bnO7BzJw53V+2e7uWT
	27NH1CXwuvK+rAsySkB7S17kUv+JWKGErNiYuOXbTAwbK5UkA+fVultY8Oun0TNj
	fnRxDM+M2wv+QkHJXDSo8qNqcJ9ZjQ2vfQ9XMQIs7lrglDU6PnA3dq+bJAuzQhg6
	Ugu+GLW9cMgE2G96N4yZgX8FpUHFhBQdtRt/gHG98VgxOPEMvoLxoN+XKZh2kej/
	iEk9a5EVSQ29GQivjABWp3zWCM9jz1fNCcWCFKDkvjjp+mKQiyY3cm56Tt3XVh8d
	V7fOADiOStaGK8tqLAd5qv5kk+96K+0N8vdF864CAEw5pO7rXRdQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qbfd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 11:00:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60K95H8l018933;
	Tue, 20 Jan 2026 11:00:20 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012055.outbound.protection.outlook.com [40.107.209.55])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrq9x8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 11:00:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJvQFN06D1eI9HzFKDRDAgbMbuo88kyNC4y9Dkvw2XJzTi4922LpUVIapf3Wv0UCshQvC5UgkynU3FFLwMK8DEyLMwsztXAqnUDI875eXk+R79BHvd6oyAjTLGhsPfOZyiZsN8yIMCHhlbYpxZ14BAop8umjGI9heq096fJB32j4FB58ouoG9hVzbhqtLDtKIU9KsSlB1KS5iqIXNyJPvzpe4wBKIYXoYUaB9ATXkyD0p04Abd/sZE1IGQbnzWDshIy++AjYCah3dgzV/yDAmEsVeMBJndWA2tJPbyfdSAjG5BPu3JngmLp+9/dMBpxfoPrCYWcGfk+MxPZS+6m1WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1ptC+Z2gypzN4UX7HqN9T2zJydM5XNUgxbEjkHBF4E=;
 b=mi700mGrsE0kfQfEGaYNIE2AU8P/cFMuy5YVVvJLDixXaZkCiO8cOrlWmwWTzR4BGVnyuoCgXAO6rgqR19VQn78ebk/rapxoKY87euT5gZUJ5R/TtGIweDIJbBM2W5TGoVAoe91JCm78SaSryOR5lkhMMaFC35OjwiOBeASo9DC3q3ZtdOUZbu3aUq9ljqnMu5ksayoU9PNdoNnUBeYkCwmEssHQrFmZiwYXhnVAo8RNg8VK40SQ5U+yGwccQhveDD8vasxGq94ckPqaGIw5fM48az6UiXBgbzzEh3P/rPC3oN4rHU6jj8gU32kNISNzH2zctnc7Nn0L2D10N9UJNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1ptC+Z2gypzN4UX7HqN9T2zJydM5XNUgxbEjkHBF4E=;
 b=zyvEnosOVzlouO9R37wJkNIdKYjD5/uIGPEUjJy6hf4vS2pW02kHkMuKlg1Tqw6NI6otUt45xjGsK+KHsL6XuBlPVSpld7T8KKYcbtyMGWtcHFCcf31UM0xvkOgBplMu0fcAmgRj9QLnPpi//xp3oW5N2xeQFS1iw8IguqcO534=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BY5PR10MB4210.namprd10.prod.outlook.com (2603:10b6:a03:201::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 11:00:17 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 20 Jan 2026
 11:00:16 +0000
Date: Tue, 20 Jan 2026 11:00:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 417/421] fs/ext4/file.c:825:36: error:
 incompatible type for argument 1 of 'daxdev_mapping_supported'
Message-ID: <534796d5-0b8d-449e-b32d-22a20d7991b7@lucifer.local>
References: <202601201215.7iVpmWIM-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601201215.7iVpmWIM-lkp@intel.com>
X-ClientProxiedBy: LO4P123CA0405.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BY5PR10MB4210:EE_
X-MS-Office365-Filtering-Correlation-Id: ed6ce6c2-c791-4dd6-6dba-08de58131813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sackQAy1yuf3M5tWhpRY1Srd3ZPVIFHqhLE33JjB3HsvGCLgQOg8YOvTLIP1?=
 =?us-ascii?Q?E2TJXHr5MOk8JA2YVDvHPKqdn8qT82yIoWAzNyDz658LnAIt8Apyfqw00zV2?=
 =?us-ascii?Q?bl3k6olRkrM8mIpdguaIWaCEe2bB+18TgNAy5FqbEBKJ7BLPACFxMmCB3KYL?=
 =?us-ascii?Q?v93PWmXlTUqbLsoTHhNQmdfQedEipQj/vfl5uCQdIDnI/Svf1uGbBPRXcnHo?=
 =?us-ascii?Q?t7KRvI1VId7WWFHcgkqCjWchDGIVdeoVFJ6qgwyagS2iCvwX2NYKZqo2vSco?=
 =?us-ascii?Q?ds585h8OyURaB8Oc+lBVX/03P9zsRhmwt95D0no9d+JScOiNeW63IHnWNs4s?=
 =?us-ascii?Q?sW7IZMP6vtlQqS03PlA5IBn/jEdTvXTLWiuyCsWaNQIPaBPCVqCOr6WYzi01?=
 =?us-ascii?Q?3wZBO7ly0IZ+kf9PxwAa5vMPMAW2iC9mae2DnHiGhPbNLdftRGlwzqNdNvTV?=
 =?us-ascii?Q?5WqRyY0pr4z6KZblYSn0YA1iNgyWkAeoHr18jMCXQ4E/GgDx7MsgVHO4PebX?=
 =?us-ascii?Q?8mvx4u41zTP8ljImQpgFdoFfi8Vl9KV5AjrjDvZXWP62NJL8zA4rvwyXm02W?=
 =?us-ascii?Q?j2d0twNOmJvjbqB9fpGqsiHCSb1akNrWyMetXYQeczP+PxBPec7M5FTWHbUM?=
 =?us-ascii?Q?Y5BT9rZ6Hk5Zs5Hyp8v5NA8ahZSHPUeerzkEONwdXAKxzTQYT2CJbJri6MQq?=
 =?us-ascii?Q?XAcnrP+uCi4v29NUC3/0xcsfBn0TLucPgwkGsoiY4HdQEDxpVRNWQe+0rivo?=
 =?us-ascii?Q?pMIZl6CzK/A4564fQINF+KYAl8VMpPEaLTKgFXNkd+35u+ntOWt5ojQlQzhR?=
 =?us-ascii?Q?PZexEQqrgp914yr2eki5Dbzco7JP3qUwiCY5lfaOmloxsACGmX3w3Xngo2WG?=
 =?us-ascii?Q?QdVLQGthOovAPZOYjaRvS/7rfFWiBL9GXpMlUoNfzbqr58wrqEq556kyGq33?=
 =?us-ascii?Q?FR3TuyA8wpDLtunrcDZ888UINOPUOVWKkWtMLDmOlskOKHqE8xNusa0thDRx?=
 =?us-ascii?Q?fE3wUEhBB05xe/iLCfraRtRsKpZ7Ok2c9Y7iufCtAd9Vjxd8C5e+bkyTMsHw?=
 =?us-ascii?Q?7/+9HdoAnbkEvLoJ6x9aAc+fwcltW6/O9FexUN288cA/ubjUldefXGUik9jg?=
 =?us-ascii?Q?f3molfm4mUiglTbwLA7GTeJFA/Swv0KCYvQyrHD1jGRBfaIyKkBnmeRIAELo?=
 =?us-ascii?Q?K9vOdUdtJBn8vATbWHzWpL/NxzT2z/V0WjxZ1C6N03gNjuV3cyMMo4OTmw1e?=
 =?us-ascii?Q?Dm6JUgYfqpwm4o+z2KgabnpFztqXJM1jS+LTyvMDCxYZXYqYfVdyVqyiPPuw?=
 =?us-ascii?Q?MSNLqRcgSpBWFCAadxILwHFiV0dvD1SM3/1NiNY/GucR5xhbvCuJs5eGG3Yp?=
 =?us-ascii?Q?FGIMPzl4G6tXi5+da/QX/MlatRU4gnGIDFJcED/7w8jHqHQONJ1Cj2B7ydAN?=
 =?us-ascii?Q?i7/pk4pwqg3yF6q75KDrjPecKDmqI3YrKIlXtpVdZ4Cub9poakRtipv+avYR?=
 =?us-ascii?Q?3RVT8L6KyPs7TIYJtTkUy1QYzzWylkD5JLKq9MiJgG+8qi/Y3gUpN0sfqwkS?=
 =?us-ascii?Q?Ri81BIBAEKDnlXE8vFzZzU24SbEvMCuekrRdY3LD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?edc7ymY3sRpQP+FM3Ovc+X6rYDRSpJM3i1+aauN68XF3f7o0WO4mPa+O87rx?=
 =?us-ascii?Q?QQcEYVyeY3jGOwRo0/76SYNNFjwb0GZLOvGxczg7hZYUwCJvw6EO3MT3yT8Q?=
 =?us-ascii?Q?7MUF5W6XKKxxMJtZHyESMv9QXaTg3NB3OZfcwvU7U6JUwf00MsRZze+XUtYP?=
 =?us-ascii?Q?Mnz3ls6qbB/FPQ5ZqnzeuAWmdMGfYgrQq67BvfFWKEl7IbWw/aK11eBp7NXx?=
 =?us-ascii?Q?xt02oywd+xXjP7GtRzmin2RYhTUsBCLAoIjOauZmt+HErB3uKofaRTx/zZsz?=
 =?us-ascii?Q?ba4JLdeEVMvB66sdlJbQnMYEQBg6RUbyszTBaE3m8QbX0pcspClkk3RBtJ1n?=
 =?us-ascii?Q?LxdMAbVnb/ZdSt2AdGLE7aUoSnvHEylLoDFCgtXG+CtLMZfDRPgGmO8O3iLP?=
 =?us-ascii?Q?CZwcsyLbkpG+EOjsKwZsgH1M8FU8WpwuqgqYCcdo2JMOg/aGGjRcn5wE5PnW?=
 =?us-ascii?Q?KRsYM6VqRCU6q0N/iBSqLusZIrIzVbzBjaLK+jGnjGUC4I0nscLQjTcdJWpb?=
 =?us-ascii?Q?tzv19PojB5ETGObQAX8U2Jl3vJmSqqnNH6VOFP+DMcV1vM292GBLzVGbn3Iu?=
 =?us-ascii?Q?2SV3bVbvbcNqxxlPtiBFylHS8TryR0GrfsZK4qtNCm+Z36sfYtOiLCUFQ/SQ?=
 =?us-ascii?Q?0GPp+3ZbKRL3rdijzKmhlK1Pl8y5W0pRmtI0WTCwo+Z1TGYcZAJD4U7BQHwU?=
 =?us-ascii?Q?boRoKvFPCPbguIS9Uv1haeCRy4qbPb6HN1owtIdhqjhK5dLJFcudwEoaU0z7?=
 =?us-ascii?Q?vqy3JV/WiCZIjYNxJg7f+p/HVBbVJbgqHUXTg8vLFzjF/t2VM3uqelNRopvr?=
 =?us-ascii?Q?noA6wUQG4W8UpIz9FmFeNS46W9vyn4YgeuMZ1bKBFpBNmLvEKh6eirBRp851?=
 =?us-ascii?Q?5pT8ptCYKTwbC0ls272Kr1vB82VmO7f9kTRPKbEHq0IQs+0uVkxSbFD2zk5d?=
 =?us-ascii?Q?7gMyu4C5yUJumCcfO/SxcXHsu67sbl3GMJXPIG3w64lrMPGuhG+IlDJRT1YV?=
 =?us-ascii?Q?wWIJc/Ziw4YOxbKBrzTYwdae94whjiCLYl3fgWdA65Jk2RtYZYrP/RIHwwvY?=
 =?us-ascii?Q?zRIBPaIhg1vNLQS8UBK1NDCUVqRzXALIiKD2rfHEg20nmpgXM7mwPTg6B3zU?=
 =?us-ascii?Q?fECmESwe/UkZb9H2d8pjBuLX8JtkxjlRBrL7H2zW3q8W33ihQ9gw/v21+Ur8?=
 =?us-ascii?Q?xi2epeqOyFPJ48NY8qqjow2zzuHi5JaoWEU7GRbk6n+6v2QPgzE99kQ9kRBg?=
 =?us-ascii?Q?UB78B0cRFTlu7Kt4nr7Pa5Fi1sQIrBJ8u6Wic+5alhBAZhMNF24vOpLyj8UK?=
 =?us-ascii?Q?t4SfcLMAoYTfqSe+5nlZ19CZSZ+Rymq4Ld/nes3xDyhOXlCrUKG30UyJmO1p?=
 =?us-ascii?Q?PvlfUk8gXCy5lKqJZg9ffBbDbcBbcrHrQbZ64T+15oWpmSXrZEaeGQIH1sm5?=
 =?us-ascii?Q?f3fBPUaFhzQPugFqByaaZx1yVb2/O0uZPK9PuLxvhtS9FaXFTYJTYsZLvK34?=
 =?us-ascii?Q?eZ2PC7Bdb1kzay8Xu35ONIqqX0GrjKVmBjYuOhzFXAULToG4SxcGuYRsSuUO?=
 =?us-ascii?Q?frFF9a1rc/0LDJgs65c4LPkDFvqFKaTQ5EqPc4CK4aDyIDHZ6t043fmDw6xH?=
 =?us-ascii?Q?y8qoBSDktxKbTHFcJcbUfqHAcyI5qSYVoKDidJUl7HKrfwNiUswr70iSWQTS?=
 =?us-ascii?Q?JT9yo41OGlbHs/IX/WOP7roiyZf0tw3lsM2d8vI5Eu3BxsVgbkmPbjZaCatj?=
 =?us-ascii?Q?QSPBFTplS2SwfcT3IzvYFOEvcj8S34k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TZ7xDASDTLPCfy+fVcEOaO+HvS3Ji4PeHgKMnVWBcG8MxloDbMmggXn3cFC5drKq+6gtrOccuITFmDCZX3O5u4YSoioD4edWjmiM75gXEq/lrFkxAbSsX5vSKgSvopAhyQVsefOAtJfDEnhPxxLXjp1hVvRiU2atwILhFuqTfWLIYR/3Eldh6DlbReEhFkH/s9pPAKCOSn9bCce6JssVJ4v9Hk6Zd8DSU78YuJwSBgDqt8e1MJNshZHgik/arprlmINZfvt5cc5uqRjUkl8rIdAFYxw+s4vcznzg0aS4UnDTgIrCe5aKjSJpAlTUpo0cro0jwfiCrv7/R3Z3PSmuFaBXshHDmAfLusVv8n4CxnyYk7MODJ3dm6bFOv+3V5rX6G+ffVOnLSUqxtXmFgiX4XEmouXpkwLFfclJXuHzZTkkDxjMaXCPaKbVZxVN/AjMyFr9DD6xXcQJnQVHvv033IUN/GZLlXTUIVgEWmc9jiRxNldsZXyKdkiagmTHXIp6fV3H7L1zIQjPBWc3a89Jbpz3+jSYm8SNAcOpCE/PThaVf4bW86pIh3zVgs87Nh4CPlMLOovHDV8uP8c1SUiW9ab8YzZdTtPaAfBs912+W+g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6ce6c2-c791-4dd6-6dba-08de58131813
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 11:00:16.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DnuGxYnWjQEGKDbrUyYvp95bQH+p/vKobXz0A7QpOB7Sou8NiNUEGuJDZ8ENju7oKP9SJWE30YBZJc8vVgXhxCBEMBYob25TwbTNlYoV0oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4210
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601200091
X-Proofpoint-GUID: NNLGYXWwSDClJ-cOcRa2WYmZS4_M60Pb
X-Proofpoint-ORIG-GUID: NNLGYXWwSDClJ-cOcRa2WYmZS4_M60Pb
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=696f6045 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8
 a=qKGKbIWm5fsQ63df97AA:9 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf
 awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDA5MSBTYWx0ZWRfX9nyLx/3KsIWW
 ugHQoWgOqIo3xXfc/OQUDhjOh6ZmsdKdPPcAJxVyElCWkm7WSr95v5gLqQ1/xAQVoMjrxjDAnTY
 7nYpG4EgLNb+nf5n+UoDB1ipoJn9qeoNZPcCVY3KeZcTBDlVf48JzIHVGsMcNVis3rMw84/gUy1
 H8CGeSNS0u1L4lALnI+u3y78Ebi81T2bVd8rj/z7UbuLj5JQL3PCvP2ZOt45nbCQZBWCAeD83Kp
 dY+PfjAlk7uOX0IDTqFvKOedpDhyfSJxDKA8ik4PITHwk+HRR+ZfIVXPtmRyVslD2CanuoL5gjk
 nx22zoySIoYBfreWoOoBT1MsknVROsbdKcZQULlH2/Yzr/Nbna5EOAMB31bbPM5a5O5WJvv1UgA
 oMaABrgeFFYzCZB7tZM7bRw1nd6NkkT2vUQdwUMDPM2IP1y678cLpu5ulLe5cN+200b9JLWZ0xD
 EOZdJc3ky9hQJ/XoxrY9G/E1epFCuV9lNnvL77ro=
X-Rspam-User: 
X-Stat-Signature: ykt1xdyqdeoa8rydqr6hy7onw8e1f4y9
X-Rspamd-Queue-Id: E20A1C0011
X-Rspamd-Server: rspam04
X-HE-Tag: 1768906838-746526
X-HE-Meta: U2FsdGVkX18h8xwp4kGiAJEahDOnkixp59+i9042R95dP17XCSwv/5HWSMgU+m2oAfWjosPUxtVHVbot3IyGG3ADAZZ9n3hkVTqey6aT9jl+hEw6XSbwfamkHWk/1SEjCOfyxXY+5xw9kqhMq15Ho0zkuymQ4V0xqBitrPpEKcFdM/KNLAD3f1NBmX3DOpmB/ZaJ4DV76P7ZPpc9Lg2wZXkMHQn3YaNnqWDbNC7R+kci/jdoGxTdX7yRj0h4W0I5Zx3SnfWNv6yycAfoU2f3y28+xA1IGq075W8yR2ybXye1RAGWY5c5Y6aF1URLxPV6oxdSWLBAxJ13BWNDjjYJExMnEoPQ71J5W/RFjfqr5yYz2NXsal5/EbF9yiFHMvmeIWGk2kWn+E9FXuNblF68Dan0Xfd3SCuBo3FsiysU1OlKB5nR1yvvqhsJujnxVFOR0TVdZMZujXr4RW2BA9vsrnYWl30l27bRzZQ8g9uOicvqhBC6K4GB7QSz5WFajv2pkbsPx6qbQ36Zxi0OWVhzr/r4XFxZbCUoW3CDEcXshiiifHRnC/49Xpp9Uo1g13yzrjzhDCzBqOq7f5ua/SYv/i3MlAgVQ9ptPKcAtTJh2MRGl4k0Co1XMcJVoMlUyexC7N+q+VesHe6fTIZM1F7RUYUn4J3xziYuuP+CXFE9uGhmiV+/+y/84pJ+kZBt2Lc1QLaXSbdveBvo/hc14JBEt1iCTtolNdmhz2ldiGjWrR6EfaV/8tGnsMaTXXB9lYcx6LJCHkv4lzwvLnSr+XavfAf41BIyk3G3wedlzxPCf8HvL13rmrUo/aY8PEGvx5Tzc4vawANz5Q1qxpIVjQdczzKz8xDPfBb6ZxgJN12zcq2g9D7O8JyMd9Hg6Jrrnq9+OxNaHAUV3jG3FN3MUfSGxqB8HzKa8Bm+Do7NDReuDRA4fGLbv0vhW3wBcpm3FKCN4kw0Rg5bCfI2S8oj+5u
 R/8UrdOU
 e+jiNJUlSWSwyWg5X5qat1gKHNefS2NdsYhTzkphvgstzEMRF3a3U0ZVxTYtXj0KxwO51Aw5saGyp1WCkDd0Yp5CHHFsSXxph0IYz6ArQ2PzC3Qcf4DWcyRxlfKf3n+UHz2O4FEdmpzGhFEsvpQHCmQgT7bioZHGNieWS5tOzYDianuG3UUA48TDkHkRaqcrRUIxYK17eXx5Iaag4OOnIcSR3ad1qkYv1psT4plldP2wtC2nv4NBNy9wtihiKWPt/x2XCBMVLXncYCCBpiJdrppt6NEI2Aqf2Vz+vIKuayy0nh3hwhudW8784JljwaOYT5dVUGbyIfHGfyVz+Z3P6lwiChPxFy4F/QumR/IW10aW2C7JYL3oSBA3+FCavD7cF5+njPArsQ+Biiq/P2WdFEoJp9Y1IHx+EcljsxviV8Q14CAcW7a0KJ6zfLNiQcEadlhjwagiWGHTDYb+cKDCupdrxZvk9XXJJTkaxxYWSdNyBgXrDcujCTYWm03mOMTTHyYJsnFA/Vw8AEntahSTfLJImb3KLFndKyamQ/wClOrwPkOvRJrFR60rt+0rvwPs4QzjeJ5w4FAIiS5OXAKMxIpbm4zjRB++wX2BcJwkmu0KqDi7ZGYWEPqiAW1KQG06ho0l2iYf/T+IMCufDEssFC+mJBSEILBC2L64HIC/gfgNH0BNUivjip2wD89n1UYtzcpCUVLIj+EfQap0a5fP4H9Zh/Mo901Z9HzGOLhUjDzNLC7qcNCvxEyoNNfZxuav6ThIZv/ihJZRin0LSFLxHhroGntbF0eOMh3q0f9dR0mZR4eNpXDx16TBbje2OF6mduzQrWe9hcTn5yHE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 12:30:12PM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   e4348a62bb1acacafcdeb149c9363291fae08c0c
> commit: e3900da1b37f861133669d26ae02415f18fa71b9 [417/421] mm: update all remaining mmap_prepare users to use vma_flags_t
> config: sparc-randconfig-002-20260120 (https://download.01.org/0day-ci/archive/20260120/202601201215.7iVpmWIM-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201215.7iVpmWIM-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601201215.7iVpmWIM-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    fs/ext4/file.c: In function 'ext4_file_mmap_prepare':
> >> fs/ext4/file.c:825:36: error: incompatible type for argument 1 of 'daxdev_mapping_supported'
>      if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file), dax_dev))
>                                    ~~~~^~~~~~~~~~~
>    In file included from fs/ext4/file.c:27:
>    include/linux/dax.h:114:56: note: expected 'vm_flags_t' {aka 'long unsigned int'} but argument is of type 'vma_flags_t' {aka 'struct <anonymous>'}
>     static inline bool daxdev_mapping_supported(vm_flags_t vm_flags,
>                                                 ~~~~~~~~~~~^~~~~~~~
>
>
> vim +/daxdev_mapping_supported +825 fs/ext4/file.c
>
>    806
>    807	static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
>    808	{
>    809		int ret;
>    810		struct file *file = desc->file;
>    811		struct inode *inode = file->f_mapping->host;
>    812		struct dax_device *dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
>    813
>    814		if (file->f_mode & FMODE_WRITE)
>    815			ret = ext4_emergency_state(inode->i_sb);
>    816		else
>    817			ret = ext4_forced_shutdown(inode->i_sb) ? -EIO : 0;
>    818		if (unlikely(ret))
>    819			return ret;
>    820
>    821		/*
>    822		 * We don't support synchronous mappings for non-DAX files and
>    823		 * for DAX files if underneath dax_device is not synchronous.
>    824		 */
>  > 825		if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file), dax_dev))
>    826			return -EOPNOTSUPP;

Yup I missed one case here as pointed out by Zi, will fix.

>    827
>    828		file_accessed(file);
>    829		if (IS_DAX(file_inode(file))) {
>    830			desc->vm_ops = &ext4_dax_vm_ops;
>    831			vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
>    832		} else {
>    833			desc->vm_ops = &ext4_file_vm_ops;
>    834		}
>    835		return 0;
>    836	}
>    837
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

