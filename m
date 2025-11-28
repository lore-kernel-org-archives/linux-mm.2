Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24025D116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 04:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8FF6B0023; Thu, 27 Nov 2025 23:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5906C6B0027; Thu, 27 Nov 2025 23:42:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F936B002B; Thu, 27 Nov 2025 23:42:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FEB86B0023
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:42:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B149712C36
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:42:33 +0000 (UTC)
X-FDA: 84158769786.23.996E4F5
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013015.outbound.protection.outlook.com [40.93.201.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1A2320004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:42:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ld71W+lB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764304951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DnAJnMCyIV2ki0beYuoBEpOMHbG9qoF9O84lo1Pg5Nc=;
	b=wnlWYM51vHqXdBZK4FU0XLIZx89V+4qJnjbYwTuQZrJWyMgCsz9qTWYCEx0IFQRdnqz5jc
	T2sHd1o0+sKewysKESc5MC7nsw0Vq/b7CiRbkXnqNjTOfc+hXCk+S6qviaIPeE/o2Q0+A1
	09m03v4j86jrrCizFvsxzhevt1mlnik=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ld71W+lB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764304951; a=rsa-sha256;
	cv=pass;
	b=C3n1acGnvj7WwN4PR3Bs/jYw7xrzLq14vOS1MXR/In+4gsHPdH5x+EF/Eg/aDthCHb+Dil
	CvbYnJ+6ZFf+R6xjBXoxhokkYfYLPIqFy6cFJPaFkQfuRN8G4Llht3VtF70muS6uaDs2Ek
	d0RgNn+c/l8sxZVA5KwT/Q5xHky0ixo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wRfppwqifPk8rqv0ggAoWS3LDSfydgdGiOavu529IpZdkFkIusMwwMxeQPd9wXKrs/mtITF7Jvy9SC3k6jW324J/jSl4buyKyKk9zN/y1msbte+6RHn0O/5QdDm0UfkEHZyq5BII3jXD9tr+d28mP0NLo24K7Vzyzy/Pd2E6zi7FSeNPRlr9StKi8+GDyAxAybtFt67KChx+4lTW0M3wleQKKRBVrbFuEnItBvOnOSQJldesEW9YGGrwoFDCRCA0VC5U2yVoSjy6OLr2i8Fkk0hy46c1gQLq6KF0igsQaa7dETaGRVzywcEPNfs3jg1cBjtQWbo/BdVnJ8kgDkP4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DnAJnMCyIV2ki0beYuoBEpOMHbG9qoF9O84lo1Pg5Nc=;
 b=Z7+rIJ+3g6MzazELQOc9Y0P9AnZmkdsOZ4A1Bcj+32/KIQXZ4uJXySBMlRU04dUDbsIFzYcwNS2mUSHljk+u+ijprhJGw2E6oi0/Rd7uHJ5SXppfykm8K6plyUGcXPEOI/NG/4N3N9vAMXVJcFDXDUcTpSi9m2JZVYTVvDttWeNzEO1ZWeY1PXG5vNTEeweAwfEnRmTuYvOoF/2dC/5V8kLxE5RqRQr1JctmZbmjTl/0zn+Or4YlHm2zMK03BnRp6HjkhrcPg3kH96qJAMaSRiWhro5h/y6S5NKyoxW570IMHUbvRufSqEpmjBFvlKuDiich08p/QOCNVxyJ6bm/bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DnAJnMCyIV2ki0beYuoBEpOMHbG9qoF9O84lo1Pg5Nc=;
 b=ld71W+lBF+tNjDxXyM3JpuOcB8h5DMALJ9K6K5+NaeuFrmtRTNdOM8oKAisqg/wvffZm/Mlj5HhgASf7MgVwI2npzi1UPuDuNtxuITO4DPlhuG3/i8iWLHyoTLMwhrxQQjc1NkCJHLCnGpILwE0uX/9GBBfGEJMO5LS6Qr4LWYA4jcilPNAiTrXr3qlulxWY0rblaOe8gQDr/lp868fP5dtVSlF/QgLviQEpPRwErWnszyt6qmWOKOfKkmcFHigR28IRDrUT5b68z1j+klyIzvwuljdjnL/XxeEqypOjhAuVqyLMnwD3bBoNgC9EPvhndeQ4fkp9pvE0WDpZOUxFiQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 MW6PR12MB8735.namprd12.prod.outlook.com (2603:10b6:303:245::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Fri, 28 Nov
 2025 04:42:27 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%3]) with mapi id 15.20.9343.016; Fri, 28 Nov 2025
 04:42:27 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org
Subject: [RFC PATCH 0/6] Remove device private pages from physical address space
Date: Fri, 28 Nov 2025 15:41:40 +1100
Message-Id: <20251128044146.80050-1-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0194.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::19) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|MW6PR12MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: 63bcf147-4a8c-4ab9-1951-08de2e388854
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/+htah7+ZjH+r0Bvv+FfKApOKchz4qos5ifb8yxYjzz7owF0J4443pUX48Ts?=
 =?us-ascii?Q?PswnCADir7G4I3T6SaF9bHsoGue4oWyA7myBBvs9CaIvboameiPxxdbkr7ll?=
 =?us-ascii?Q?DKbqsH0HEy3m+VUOnvGKBLzIcuzMEF7rdyQN2om/qaUrm4cjJ97PCeXyG6wM?=
 =?us-ascii?Q?wrH4BqZUJhF9nvimW7EFYFPaH6MldwZiaJgryKkpqKxnJcp9k3YzWu5Hv8o+?=
 =?us-ascii?Q?9W4wBhU6RbrpU2qy5LgAJU3tRW2olquGgA1ZGM8O6xAz+0qh0XTAYXS6o/Ba?=
 =?us-ascii?Q?Iw2lTXCwRG7mmT56voIsH5WGqhMzkoOe+BH0D5d9tTUXnnvjkBcSWsadcWGu?=
 =?us-ascii?Q?6JOkqWYOt32+vEObTxIrIWfckugrLvymKpoavaJJAAlbpHTBC3Ewo+ZRbcCh?=
 =?us-ascii?Q?Ee5Ju7vGQTSz3iXw80Zn91SS+ED/zerx+9G7k7AY01D6M8/OgMdjfYZSqK5W?=
 =?us-ascii?Q?1OPOzC41KQzElxkJzljQnRp0rCoVzmhznvr8y5sXNlqKgo5jFq3i+kPcTQlG?=
 =?us-ascii?Q?4qc1SsyGyjFExrpbSyAPT7iYlTJFf2dgwaL3iZ3T9O7z6U4NCNUCNjLRc0N5?=
 =?us-ascii?Q?rL11FYxn1w1MUruYAb96op3kSahw2Hq5Eb32gSSp3UBf+Hkbzsu+2rBK1v7f?=
 =?us-ascii?Q?5dsGqnyzVEyXtcNZD3xWJA0Q5BvYZzPYO9Yd2+7SYth97mrcb1v89tsFVvYU?=
 =?us-ascii?Q?HcexILCsl0o/oVy49iwjNjFjRbSa0yHkQ9mfJpUAgdkXbX/U/xNhnRsi+Ii7?=
 =?us-ascii?Q?wn9EExyKnJL4JLR0lXjK8uCHIlczLJaN43KygRn+zblGRHqhoAax20ux8H7R?=
 =?us-ascii?Q?faMdzDdXjEHrXpXh4OIQF4nSglKyVmfXsEmnT6/n19JNO49Xy+CKQ/7Z5S0N?=
 =?us-ascii?Q?/+R1uwH7gt1NtuLv79gOV2EyGCept96/7BVFsvUADh8F/mRsWH89qwgKPX39?=
 =?us-ascii?Q?zctEu2oyZCBtBdkznp6L4GpcJ/Hzr04XRdUA6NLUueywRJAaZdkFQW/f2sQd?=
 =?us-ascii?Q?DcH4FoetcjdF1M0OwYIn418BY0uXM/SkeI2hHWEpXC6KxBhroDUypkQpOYZc?=
 =?us-ascii?Q?CevCDBVU4YGd4KG7f2D3xEGcsZKMaK1h5gYtul9/kypW+gX9Kps/p4G+a2xn?=
 =?us-ascii?Q?KaaZsRKAnpCtmuw2xAhN+e3VbSbzlbmJbnUDxwQWZzQT4TA/6aDRvdLzWVGi?=
 =?us-ascii?Q?j3r9CbOcQXaLvLnesSLmz9wmtj2/Y1m9LP7KTIYTd5S6l+9yHi25ubdmEMOJ?=
 =?us-ascii?Q?wYkSo9H6J8CmQepZB6uSPMCABEoBgCzVKeVylOkXeIEi5lM9pr1KI3lUZYiX?=
 =?us-ascii?Q?hToWBA5Pg+bRX4fqb9RUbv0gkYeP/M9JdKhNGypPy6MSs0GP9NGOkoNA1MWh?=
 =?us-ascii?Q?THtn6uvoe6p4+q0s3vDBGTW4DIwpSkH/9fC4XBmLAB0GceP0UwB9dnKeVO5C?=
 =?us-ascii?Q?45s7/c9f4jmnu2FIBR5gkgAi0tnhqLSd4MZSPJ9A/zxLU4aDH1Gpvw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OD6k8BYzTMIkkonLOcm+MX1P2XyiVEWndBBmIQDO/2kzz6eqEMj2KoO7xJn4?=
 =?us-ascii?Q?f0I2sMjiqTjIbptRyqhdf0h199a6NKwoZufSXpCxoy2+6zKUcjzFSOSKgujI?=
 =?us-ascii?Q?vBj/J6eSBJyxsA+lSVT5m2NU8/XZLGJZrNVYSQsycucOhDjWsA7bDnCJX3VM?=
 =?us-ascii?Q?OpwNaqJFCsm8kNgoKH1sZDeRdtXcivZmDYcRxdB4mWmLe1yXGf1ENnCvn7Ha?=
 =?us-ascii?Q?qPh5NmU8Zuo6bN66iEkFAMBdUNh9qHKgoZYZajVOm+L6jmOjdQyrsBLO8alD?=
 =?us-ascii?Q?lgEtNZwzqAgSc9LgnJD7wEyfeRT3OPAaXFIZaoFr/xWqoaS6jEPLQ3X7wgrF?=
 =?us-ascii?Q?HEO6vQpGoQ7CfizUjUeSsxMLsr1fInOj1CLdAaIcC5Puu1QyghW0hyR7++P3?=
 =?us-ascii?Q?HQeqlt1mFqG9XR0oEA+Go7k1hG61fNqdwLgITTeCfrgBNzF3xOYGEluj1PW9?=
 =?us-ascii?Q?VEVXTmJMkCNQNxDo992u6a4cAUD8I4Or2yktgaokSfoX40PprhLXDG+AyAaY?=
 =?us-ascii?Q?b6KZlYAs9WKIRJpt+XpjiN8Bvy6R+VgEp5nytO2WSgxW6QLkcYMl07E64adD?=
 =?us-ascii?Q?6f31ZcWbIddbcBwSpUURbmOfzrrLzNF0aDKC1882xt1Si8fQ1xYuf0ANLPnm?=
 =?us-ascii?Q?mEEtgHSji4tR4Q1sFZ249mpsSTINYIUSHXokyvRnQuXNv6Tw7FmpIxKaoLCJ?=
 =?us-ascii?Q?Pm8IsDCFR/AGvRkj0DvD/4zOA5QvwoCDYn8MkrC0hCeZzrJSOvmFRZBKNLhh?=
 =?us-ascii?Q?RHfUzq7KDZIvZ0yYuxr5UaFqCQjX1s2ynS4MHjtcIlR78wUu5WtYuDYE3bM8?=
 =?us-ascii?Q?bLwyHSazfZ59aj1LcPFMC92UEUsTfRoQga+WFGhVSmdBLXX/WuvBMvX5FDsr?=
 =?us-ascii?Q?LMzccdaN4KXTxJ5xqdBJkMYraU4Y8GLZXBqZYu+LhwTjLqKSCuPfOwNrPMbK?=
 =?us-ascii?Q?B96/87c4OSemjb8fclUvqO51OkdaC/TevaKwhM2hQnXPffFnxS5ncfcDsOuq?=
 =?us-ascii?Q?WxjZLkmDsq9UbVPMvdg/E10Lx3Qgd2JXTNYFEh/Ro7cn/Lgg1S5s9d4ngRVE?=
 =?us-ascii?Q?5yIDdYVm9CT05b2AccFSGjLQzZDmcnypRf1i39ZMDwsSYqJH+SItDhKwxnas?=
 =?us-ascii?Q?rmAN4p78G5Bbsp45SYxP0HzjMDu4bVx0STpgWZ+7jtSNL4mqcSIPNR51IRQH?=
 =?us-ascii?Q?9Aqaieb4Ir3Bi9Zs3E6IpHNqFN96dtFVXWFujAHwiNKlFCU86InbogHs765O?=
 =?us-ascii?Q?DIxziX0lUUxjkbmx0dmDJU9dF1arM/CYaUrjxWvguWzry2dJPiSLVTYLwJ1z?=
 =?us-ascii?Q?mwMti/1nWHlk/zEvtKClt21BHeQOyFln0yJqjoVLtIpDTcCed3hnSD4DwhrC?=
 =?us-ascii?Q?+c2r2NGvv8zsh8sKu+AFHE9CdLWoHGDuwBqpXbaGpnwaPpx2MP9hKAX8IDRn?=
 =?us-ascii?Q?zOoi6aHWKOrRngNf0d1MSnRGqC3it0HtnS5nVd1N7X2evivZmiGe2zbVm8oz?=
 =?us-ascii?Q?F5gcrxjLBc0jT2wPwMv84wa8MLmyTXTGNjQ+vQ76Y9s8Rq7PdeXhBbG9vJyo?=
 =?us-ascii?Q?ZuLZePrPwjeRjLEVJJofR5stcJV+x/uDtA4P1WZe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bcf147-4a8c-4ab9-1951-08de2e388854
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 04:42:27.6834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1n/5s/FDqwTauzFZqb4LxEep1HGPMoil2zFa6WpZk2H9eZeL+BSHfy6TuoySQD17b0rOXLdJyoFiegLaydXJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8735
X-Rspam-User: 
X-Rspamd-Queue-Id: F1A2320004
X-Rspamd-Server: rspam11
X-Stat-Signature: yc9owrogunwsz936kuhyaehyp4gun1nc
X-HE-Tag: 1764304950-144621
X-HE-Meta: U2FsdGVkX1/kKow0DZ3uKmaYU0meU1tHprkbyww/WTDbwicb3LuRTXujJlhmWZ+owHp1intlrj709n/3QT9Rg5KQHdYZysSfEcF9DGs0ZiOWIFLvlYCD7HXML5zOrioayikgOP1hHUidt0qGGDO2z/67G+K7het5krN9pBGzQLHxq9AYz+DFMr1ENPDVkk2Ruce8SQir8VWfwVD5F4xMsR1drBaQvIWezASLrjgk5IMszp+GhsIIc3ExlpzmVY90UX3QJQRHTGHLtnLtAhN2r1NMRFXm5lR0v/jc+RTzNDMhvPF8JOFSUPKu2uSj8ReHHc3rcsP5uZvYKqYr9+mdZ04vmrvaLrpUoSSK0B+Flox/WWtNyhMzs63cmCD4yMT1r7G8Mr4pH4zWbnreVVf2SlCp8O0U6XZBSWJyqzAel8Pmp6lHyLHD9Lve7f+SWJ0sfMP6i/uVQRKHKZa2uKmzJZYzXkox1il8DDRAETz5/GrK6vDfpR/YGXK5qLdyis38H5OelqeoimaTyNySF5nmEmBlcsaQymJAc3ZQIU2d0DSiCUPLBWEWc2/s5Wr4wIHMjY2mUp2fc5VyHJX5mBuHH6LtOiH6VkE80opU5ON7Ro/ZgZZmJSRGNOb+u8bnGF5UE5xKqvmGIt3+ZrSpIjB47mFrvNSCkd8cpa0QTnPPouAx7dvP0frmkaRtYrURAjWSCnqeQvh5Hn403DEwL+cnRLe6Na6d46k6XGxIg04AIr4NQpWqr2Sv7gLxeiAXaWKFeBsOs/ArAKkTpw6kOn7WnE6EX+zShXypsxcbvsJmupBIRi5s3OfnsAx+RGAa0o8ZbrwEVkzcwNW3MkC7bENwBOH1KFXkl77v2TnRyZvdc5JabuhG8aObaCAhhZaHvkQGigpkGl6fSS9XBYJuTR8SCms/Ww1N5nw8+57GZkgU2CQKX/j+MBoD9TatO6fZOQSc3gVUCdLFmMR58SmvPt0
 qitPPgTh
 nvG1+I4aShJoeylrg0A5xHCLLcB2n3LBmwSOuVHUi3odva9o3k70NV4K9MUK75wY2G2qK+wE2+25TzbMmhxvu4wh3fB5ez/APnp9Ss6/4sY1XBpc43n/3jJaSDkJTdogVVbYDvwdosQwYlzzXG8vKdrgQu4Kqs6P8HrAJwERDyirhsc5/V3UWBhzU9DX1/qUQdIyiu1xUT0htmsbxRIYukHeoxRq39glCHKcMSQqT7lM3Z0CiYH1S2XH+a3f9LavpdJBkStqeeNbqCNkMF6Nb6Y2rsi1+7uL7Ri6xFRApNHAw6vwrw8d8BH32l0IaqToq0qekt98nL+qCoM2xAA6EKM6dRJqu3/uGNMUDTSG91GY+Tt2zQG2JKb6KfioXS/winEGqgEBiwATrOk3fjAAMRb9jX/LYcmnsAARc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today, when creating these device private struct pages, the first step
is to use request_free_mem_region() to get a range of physical address
space large enough to represent the devices memory. This allocated
physical address range is then remapped as device private memory using
memremap_pages.

Needing allocation of physical address space has some problems:

  1) There may be insufficient physical address space to represent the
     device memory. KASLR reducing the physical address space and VM
     configurations with limited physical address space increase the
     likelihood of hitting this especially as device memory increases. This
     has been observed to prevent device private from being initialized.  

  2) Attempting to add the device private pages to the linear map at
     addresses beyond the actual physical memory causes issues on
     architectures like aarch64  - meaning the feature does not work there [0].

This RFC changes device private memory so that it does not require
allocation of physical address space and these problems are avoided.
Instead of using the physical address space, we introduce a "device
private address space" and allocate from there.

A consequence of placing the device private pages outside of the
physical address space is that they no longer have a PFN. However, it is
still necessary to be able to look up a corresponding device private
page from a device private PTE entry, which means that we still require
some way to index into this device private address space. This leads to
the idea of a device private PFN. This is like a PFN but instead of
associating memory in the physical address space with a struct page, it
associates device memory in the device private address space with a
device private struct page.

The problem that then needs to be addressed is how to avoid confusing
these device private PFNs with the regular PFNs. It is the inherent
limited usage of the device private pages themselves which make this
possible. A device private page is only used for userspace mappings, we
do not need to be concerned with them being used within the mm more
broadly. This means that the only way that the core kernel looks up
these pages is via the page table, where their PTE already indicates if
they refer to a device private page via their swap type, e.g.
SWP_DEVICE_WRITE. We can use this information to determine if the PTE
contains a normal PFN which should be looked up in the page map, or a
device private PFN which should be looked up elsewhere.

This applies when we are creating PTE entries for device private pages -
because they have their own type there are already must be handled
separately, so it is a small step to convert them to a device private
PFN now too.

The first part of the series updates callers where device private PFNs
might now be encountered to track this extra state.

The last patch contains the bulk of the work where we change how we
convert between device private pages to device private PFNs and then use
a new interface for allocating device private pages without the need for
reserving physical address space.

For the purposes of the RFC changes have been limited to test_hmm.c
updates to the other drivers will be included in the next revision.

This would include updating existing users of memremap_pages() to use
memremap_device_private_pagemap() instead to allocate device private
pages. This also means they would no longer need to call
request_free_mem_region().  An equivalent of devm_memremap_pages() will
also be necessary.

Users of the migrate_vma() interface will also need to be updated to be
aware these device private PFNs.

By removing the device private pages from the physical address space,
this RFC also opens up the possibility to moving away from tracking
device private memory using struct pages in the future. This is
desirable as on systems with large amounts of memory these device
private struct pages use a signifiant amount of memory and take a
significant amount of time to initialize.

Testing:
- selftests/mm/hmm-tests on an amd64 VM

[0] https://lore.kernel.org/lkml/CAMj1kXFZ=4hLL1w6iCV5O5uVoVLHAJbc0rr40j24ObenAjXe9w@mail.gmail.com/

Jordan Niethe (6):
  mm/hmm: Add flag to track device private PFNs
  mm/migrate_device: Add migrate PFN flag to track device private PFNs
  mm/page_vma_mapped: Add flags to page_vma_mapped_walk::pfn to track
    device private PFNs
  mm: Add a new swap type for migration entries with device private PFNs
  mm/util: Add flag to track device private PFNs in page snapshots
  mm: Remove device private pages from the physical address space

 Documentation/mm/hmm.rst |   9 +-
 fs/proc/page.c           |   6 +-
 include/linux/hmm.h      |   5 ++
 include/linux/memremap.h |  25 +++++-
 include/linux/migrate.h  |   5 ++
 include/linux/mm.h       |   9 +-
 include/linux/rmap.h     |  33 +++++++-
 include/linux/swap.h     |   8 +-
 include/linux/swapops.h  | 102 +++++++++++++++++++++--
 lib/test_hmm.c           |  66 ++++++++-------
 mm/debug.c               |   9 +-
 mm/hmm.c                 |   2 +-
 mm/memory.c              |   9 +-
 mm/memremap.c            | 174 +++++++++++++++++++++++++++++----------
 mm/migrate.c             |   6 +-
 mm/migrate_device.c      |  44 ++++++----
 mm/mm_init.c             |   8 +-
 mm/mprotect.c            |  21 +++--
 mm/page_vma_mapped.c     |  18 +++-
 mm/pagewalk.c            |   2 +-
 mm/rmap.c                |  68 ++++++++++-----
 mm/util.c                |   8 +-
 mm/vmscan.c              |   2 +-
 23 files changed, 485 insertions(+), 154 deletions(-)


base-commit: e1afacb68573c3cd0a3785c6b0508876cd3423bc
-- 
2.34.1


