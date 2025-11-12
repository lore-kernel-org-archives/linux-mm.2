Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39AA1CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974A68E0017; Tue, 11 Nov 2025 23:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C878E0015; Tue, 11 Nov 2025 23:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83AF48E0017; Tue, 11 Nov 2025 23:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72CDF8E0015
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:47:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1431E4C2AD
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:47:14 +0000 (UTC)
X-FDA: 84100720788.07.72BD15B
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011051.outbound.protection.outlook.com [40.107.208.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 29FC8C000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:47:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nraC3aqv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.51 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762922831; a=rsa-sha256;
	cv=pass;
	b=0iAfYebdYvLASDDM2BJn9sf2G5aFEJuhaEgb/PRWWGF2umZxui1rM8fYZ3N396bB/wCXOP
	lU+8FKZRjKrYvu8h6R6uDCvp0157Q0fUXApGmdHMGczscz60UV3b5EI9eouqVXCQx0Zw29
	9GZ7o6gYAlbxSZNKliwH4W3Lh2t/e4I=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nraC3aqv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.51 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/kMngb5+B04Sq7AqVV075rWHA+VVKWe4vWLs9GWA10=;
	b=Abawwl4TdPc+XxzgyWV9fdZY1aprNho+50q4kGOBDdGkmmcxR13rc6GRpvrz/HVMpl6//r
	EOgIvGlJyVut6L8eY8EkKpWqqgvNRZFA5b7JeU6+MD2KKGkUtmEoa9NdEd0Ytsw/GlPuS0
	o9ALDEAOKmlbUAAP2IvK/g58sISWO9M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2GD3PJIf4TpUWh46PcfQWPu0pD06DoyH4Q6DKF8sZOv0upY/2KYvxDBVxwNteY+orZICan0XERC6T9yQU/6d1QBp55WmtLZn9PyVcHd9iLe08H87EpWt44D8nVEeuNb6lkEcgaxB8CLkUUuCGNtgrt0PdTfJ8+46zoy2aXv0dXWCjb3ga4uSFsQFYt6IEmjjXbLmsHu1lB7I+IXGgdjOF05DxjmAj6clURRuWOwTO1K1xSiZo+29t/YaoraQL//zBQNEtgf9q1qGSCGradmTDL79UC/dL002QogQcLdh65/wACkeMrD5X6Tvke+LXHbZ3BQFdjHuCo6TEp35DCiPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/kMngb5+B04Sq7AqVV075rWHA+VVKWe4vWLs9GWA10=;
 b=REO/e6N7lcZuVNUzzUQVRcJ2jE1adCqjYICLEfl34Lpnak+6qsfb6IGdpRN2H94KiHJ4X0dAMcyuIvmFAgQqiDJgtN5vejIVeWVs149r1iUCNn3xrQcLwJgNQZ+WaPerLj5y+qvPIKS76hAeH5X8okLkmuuq8TcdsB6fh1SjBer2XkoJrxPt6I6PtmYKZpVJML9EChiZ219/PSJA90tyWrKELHoJXLRJ8NSCCZ88AoSrJIuEFA0ahhEIFOp2q7+FcSGYTd66O9ANpprXRymLIyeecVvxv4G1rpLNPJTZMtdWuGjx73iYE9Kxx4UD3k2hVl09QW1oIFO8Hucd9lrWgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/kMngb5+B04Sq7AqVV075rWHA+VVKWe4vWLs9GWA10=;
 b=nraC3aqvtJ4s5gsK15NF7HVHiESoyHtqWJMvnglgeThnlpllxTo9mxwFihy3aQAb43zFnqVTY96JMEEEll/ZUeC5iSBVf9zYZIFgJ7aHKwLClyPwu3SVVLpyoz9GzdSJHEodsLRHDADaQ4/7JVsslRME0H7Gb/LIViW0UFVkdgsnKbD0xaMCPvqngH+bNXRuo18ry804xSp6Oyzl/0e0e/ST5i/sh7IBelndcfxef2wxICSQ1klh6Z7I+PlksguAUl6xJqdcNdxlrqToCcGmIHdDFxsYSzNZUf3ILmNoczfgab7thoyEXTSJiy15FUIcRfXAJKX24XAEp+4gFtiyBw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MN0PR12MB6175.namprd12.prod.outlook.com (2603:10b6:208:3c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 04:46:55 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 04:46:54 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH] mm/huge_memory: softleaf device private fixes in remove_migration_pmd()
Date: Wed, 12 Nov 2025 15:46:34 +1100
Message-ID: <20251112044634.963360-2-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112044634.963360-1-balbirs@nvidia.com>
References: <20251112044634.963360-1-balbirs@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0115.ausprd01.prod.outlook.com
 (2603:10c6:10:246::7) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MN0PR12MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e531c46-f55b-4fbc-050d-08de21a680cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?svHMGPrkwdfw7IkKr5jaIx5z7Vhf98soayq3Bmd21FCEypsnqfZyL4tSuV2e?=
 =?us-ascii?Q?7bed59T1Ujewa1P/vr0Biw88mfsru969jTTg5cow39wYva6J7IWDivQXRZ8Q?=
 =?us-ascii?Q?ogwq0aepXkmHwes890hW19rGaqlPmfB9AFiwB/d1qnvLKiA/2bUCY5WgMdyH?=
 =?us-ascii?Q?R6c0GWauBSOgNb0ZQBHEFtVM7iV2bLMQpgoJZnQxYspZqgQp6M3m9r+xqMZA?=
 =?us-ascii?Q?gN9A8f4vRfqfNylQnIhco5juX9TKM3E4zZuJ/nXMNQPcYRzFNTIhTm7p8BKT?=
 =?us-ascii?Q?mIZ0uDO7/F7D8rhTfqAnBh4klDz6uU/9apt7r09ktRYQpL9XBgMQxQuYtrir?=
 =?us-ascii?Q?BtxuqzLoSupXElZiqJcgD1x/ef+PmyIwuicDuJrPLA/1jv1F34yfETy6CwlY?=
 =?us-ascii?Q?tkKAdvhVFKnxBzliGAQs7qqqp698/yqiQyoN5uvlxZgP/8sn9V9H1AnVLzS1?=
 =?us-ascii?Q?eI4wYMwWRNVHtBSU1n/ZbGfaYRlch8hKsl9eghxmnNkxSCPZl8YVxzv1XALO?=
 =?us-ascii?Q?escwp8uZcYmtmQWJhqSYAXZbDF8Z1r4dJ8TEXR0MSzqkaN0Qrg5sB9Gsr4fd?=
 =?us-ascii?Q?BZu4Rke5uSDQ8o2I06SJkY6zhiZH0LZihhKHTgf85DEVCbIxSxMIKvVLUnvV?=
 =?us-ascii?Q?mwXwvHOtaRdqAiEBHObOhjdlxaar5+8CiiJQ29xI+X8apr8wsf4qBuvejIIv?=
 =?us-ascii?Q?FuijKzEd9vlABVXsvXTEe7Z6PYQD6ldJeoKh/ElNSpTmlk/GiTKElPCrjPfI?=
 =?us-ascii?Q?TRbhVKEMp3tOFcJgv3di4KJo7ioGb5I8JCqmVsDYEd9k2e/w8FrzYVtuyY1i?=
 =?us-ascii?Q?d5Diag41Tf6tfNC/3sKLazfUQzP9m4UgZ/VvKF89NwQplHadXH4CJwcFwKhG?=
 =?us-ascii?Q?WCaJhAFI7YHxUNmyT24Jv5iQoBbZTPBbPc1PB07O8dsP4NnxLtQDkEX/EyRe?=
 =?us-ascii?Q?MKvsfRQfbk354D9DvPQsQF/YynlTGXlPL6HRhqSDQyZ6c3KYAmS7xJ7izZUD?=
 =?us-ascii?Q?Fm3w8E6PJCg2EWhHd0RMWTqQHNatQUu9dI+ILLM0Pnzglr8WGtAJ2mJ1dKxS?=
 =?us-ascii?Q?t3oldCdqLusnsK1ZfwFVrwZm9zFLWZXGdoATvzNRzvici5MC/b7ANGrUJpm2?=
 =?us-ascii?Q?9wNKDIC++HdYYMT+xh6rM/+B0efiWv66DiGxqHjS+/aN6mV3ZUBOjWyrls9u?=
 =?us-ascii?Q?Bj652rvETTu4RVQqaj9d2PYV1S8lCdyS1MVk9YCxwE/Pik6+WfC2Wpbx3PZJ?=
 =?us-ascii?Q?V4kNYOgSIkKnIZp8s80XtAgFoh9UbM6c+dIXo4UoLAxVLKrh+Qm7P5b8R27y?=
 =?us-ascii?Q?O2gvfeX0PjPfKFdLO2hXCUraholxuSAWUBlehYIsDzWCeHAjI0Bl+Vk1eyQ3?=
 =?us-ascii?Q?i7hBUJ3X258RgMwNhf8GZ8QUbacTxQoPhuUJnkqVMBlpHGCe0k446iK1Z534?=
 =?us-ascii?Q?8KcrBgPaHFcGnJkEaEsy8gP5n1K6p8Yb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o6uiRKQUGskPLyUOgn/UY07OpHcsccGJpBEjZJIv5bW6jjLub0y2Pj60S+Md?=
 =?us-ascii?Q?09qNSlPo9oWfZ45uezk4w77LUN4dGh+dEAuErsrx5jaeT1jjpxtYi6E/ZSmC?=
 =?us-ascii?Q?tX0+umG3x6drCnFm6MPjgFv3ka1dt5Sb/OhRcMvvL2TohYyPYo+s7hiqM+0W?=
 =?us-ascii?Q?Pna0vM45roe07S+9paXMbwtP0jcNtRdD24CR+3hM735qpz3x7EHGzoiDlnU9?=
 =?us-ascii?Q?wNMndPfP5OQWWKH1ylB3HUWJxKOYgN00dgMpBEqQdbIuIvLA0kSUoxCUznb4?=
 =?us-ascii?Q?c9PhUMq7IAVwIBolkXNZYxQBofCcO6VEdsrYLAXtENhwf2Q0GAP6bTpZTo5r?=
 =?us-ascii?Q?f1mgZNT/jMGS6ZsU9DzwOWwuLGVz82kDPeDChG2Tl1ki5Ivo+JehN0tsQ68x?=
 =?us-ascii?Q?41O0ZehL6iw+cAc0QXe47YZlI9VcK7FcYvkHZVxY3sKOa9jJpEYPDVVFrcda?=
 =?us-ascii?Q?2XK85pb5zkcX6ONNwinOOUcnpcQsQZzJqNXZBYbUUslGZUwN3LLO/Wh/PTID?=
 =?us-ascii?Q?BqbQSEDPRRAuiNwaymjh2eyyO22X/ypmBy72yo8W+5CtyAUKQGoNUF6kgPXi?=
 =?us-ascii?Q?HcTLcUbUnrDOQZAo81lqAVi7AOF0jEs0jR/A+W/8GkjQkJwpNek6YaR9xpz/?=
 =?us-ascii?Q?vDGyula/LXRRSv3+Mrd9gpWp/Q3nwJK8X3CTKNA9Wumxe/uyfwP/fkMw3wZ/?=
 =?us-ascii?Q?ab+hsUTLlMHfTZg1bd8OGXLSHSz5mxRZP0ro0WWz6Qxy18dJcr+UsQ2XEST3?=
 =?us-ascii?Q?eoDu/GloeiecVNuD6g3rBvg1GytOS/cvzCwb8+hrA/njrLmEVXpWYPNuiKsq?=
 =?us-ascii?Q?SnFtEW6ijyOOg1LrS9CaSvK+9i9T0oLgxH4Gx1nE5JOn6DjsU/1qBVlpyHxI?=
 =?us-ascii?Q?qw/IAJa+/vvltCRMDTG0WPgBm/dscBn0EVDMvszFwitLtjSZJpoUaKZhMWck?=
 =?us-ascii?Q?VeSfOxLtPzV2UtHzx4vAYU/kRNfFvpDVi5GNv2U3Gs5uD797lFcJjJkrfx1l?=
 =?us-ascii?Q?fMRLVbGoOQkx3L3LTWz4f92HV1WfgUQzmVKRAFJZSx1XOuWhak0Nn3b9hcPc?=
 =?us-ascii?Q?STzzwCiDNHDpcEj8xmq0tE0qMDILr+wnOhgaekNTocobIAtCPVrs2uN4Zl8F?=
 =?us-ascii?Q?RpSLwta4tfZcA5Nza0PDXVLSRSoEXiVWCWRd3BrXs20uQ8DPq8SQdKUe4d4O?=
 =?us-ascii?Q?1O+0E9ndGfgxOy9X2xD8/gmP7IdotvygyyBnYafDSmGUwXbBi2TSHgGhn1VA?=
 =?us-ascii?Q?nJh+tplvmphaqb9erZFn9mdap5ebrchvV7t3FgxpuBX/uVQg5kVOYSLbN7E0?=
 =?us-ascii?Q?hSLhHxjxf4efQ3rq+qAbLD0iklfRvYBm0CelwWulWePfbD5hhDipX9CYJH7o?=
 =?us-ascii?Q?0g2OEEF9wosL6W54kn1MgnYElpKF9bczu83ytv/bfFwX+AkJRd6aQ/VaH93U?=
 =?us-ascii?Q?RYpCZR3oICABI2vOkC9QAKPKN42NEiBl1EZjJpqCKU2MGQdH8CoVWIe4CRLG?=
 =?us-ascii?Q?olxkS5ZSCiHbTQLR5nQ2t1OHlPXR6hIAYr4lQhD8cNErTHCTLQFHBIciX4uW?=
 =?us-ascii?Q?qLXikSxmUuzVhu4En0wTxKnAnJO8welPX6tt4CWlTKLbHIqB+KAj5ARhfU0N?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e531c46-f55b-4fbc-050d-08de21a680cd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 04:46:54.6197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ye7QFyxHfYKxkWas7mKmvORW5FA3jdmdrlo/GO/yH0R/mA/doOzOGhQjYQKqk+9SxlK0lQpy6QCaZMsjlL6z0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6175
X-Rspamd-Queue-Id: 29FC8C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: xieafjo81gcfjo3icjwznxqwicb3iixh
X-Rspam-User: 
X-HE-Tag: 1762922830-526950
X-HE-Meta: U2FsdGVkX18UwO1tfJoelVLtScvUNcRrD6iD5rCWgrXD0oxLkBXT5vOxyPwLIggKP0op9W6WRC8e9OMxdiXQQkpDa7CPLmprfFuWbmkREIh12+zpUUBAIjHN49hQRYdxEL3gfDXLqy1MNLmz2tDv36BhFC/D+b3dqX+WNjIDSIV6oGddb/vXwlwhBmfCiM5IgWGe/i+0f5l5DKZWkRr3t4zOCjOAkE9E3fZMMOV0sSev7ejZ3ujkmw/dqa6EhZaWKso9iL0NNAcHKoDi/2KGxzIzmDprpnl4Z4i9QBvGnB7e1wIqLM0CQPsGei4BtJon817R652NMnW9vT4ZJldzJTjk+T5ICel0QY8/Gx7y1268sC4cr9C91ImyRCRUmKi+jiBEe3nwrEK+TRUJeolxNgcmCorX/u16gX+1fIm7lnXBDeaQiskmRKmsB0HshfY45QVbpIx/NsN6rcBuAGvzN75Dj85GQ1CNCabiHrftW4InjIPiLb+mkolTeqjX4vwR7sbmxWIndo5EztETvZLXfFKPmCjKZDuthLrQ3AqkO9e4upxOOdZt0KiIy89oo7U+bbxnZr67GMH+FZ/bCzDE3l0PLkKB52vkVwh59WAWjj97YodxhmAECy7p1Q9xf/wAJ8kWUPH/c5gYDfW8oEBybu/H7jrnvWX4o0M34OdS/Tz7JWZH/3HoPoY2FuWSoWjt7UelECNBjNRNrG6jksFS/an06b+ZZKs7lmcmC2HMX+tM9nUI986jGz6V8xUOSmzmP56JczoUdIT3G/woNt+JyfqLVPu+h9xof6etphUQLBtJNYqXxbZ/L1COyMktOdxCUAzxQwU3uRLpDvndC/LqfE6ZYv3/aJnhb8qxvMSSx1jZa6btU7TJPvjYDpo71JGgC9KC4hrhcsL06xn//OAuVvxfx+kwkYcS5mGkmvk3p3lk9V0JH46EQEr2pEc+vAf7Nguwu/yERJkIr9k8M7v
 yyyOCK+5
 ppLfHudcNkPcHSYswZqv7Js9pianMLAojy/7OgpYAYIczufCo7Nz23/rv3g43MxfAQn/9QSyoxixpAYWrb33UJ7cmkS6s+iB6yh7Qe/Y7ezOSfopm7Cs/cD1fIJCw0QygQ8Wwi88DME58S9jt391bYu8eWbPTHK4IMEbpSLWeOBZaAhq31mwEaDDADtxSKrTuWZH+qaeJoB4Aq/kAqhVxjM9zp1PVBonzdEPsgyLfjMWvGJZyYZgeYDqovnHCTHFC4SA/m3BhXW4543q/rAkYqQWVAWsylRduj5DfyhdyLQukZ3Efhem27HHoWIZ4W2DUpQiGvHDUHDZuwikis3bJeql+PB/U3RYmwlNM/fiq04u3wpiiZ49c/1rpmB7TLqFCJ1jONV0wbkWEvijOionK8yu4JNPo3NJ8N5j3o6Fx8BZr/d0oPRkmbYbQeJ/H/FXaya08NfFDDG8/VFFYOFcHBS71nsWWYv+8Iscwwe308xYAfmd0kedI1DB87u+LnRJ4NOHsSqEXkxWC2tu76F1jVadCEfju/P12FvRO3Y0dFY+gIPGECpvx+bjON5+B3UAmWPNKIkvGx69WYehWJGV0+f5BqkqFkWiU3cXHBXnpfraNqrzwj6eHfHcyQIUcp52LbHUTX5ZiJcHVWo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit a6ca2ba46390 ("mm: replace pmd_to_swp_entry() with softleaf_from_pmd()")
does not work with device private THP entries. softleaf_is_migration_young()
asserts that the entry be a migration entry, but in the current code, the
entry might already be replaced by a device private entry by the time the
check is made. The issue exists with commit
7385dbdbf841 ("mm/rmap: extend rmap and migration support device-private entries")

Fix this by processing the migration entries prior to conversion to
device private if the folio is device private.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/huge_memory.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 942bd8410c54..82b019205216 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4939,6 +4939,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	pmd_t pmde;
 	softleaf_t entry;
+	bool old = false, dirty = false, migration_read_entry = false;
 
 	if (!(pvmw->pmd && !pvmw->pte))
 		return;
@@ -4947,6 +4948,19 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
 
+	if (!softleaf_is_migration_young(entry))
+		old = true;
+
+	/* NOTE: this may contain setting soft-dirty on some archs */
+	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
+		dirty = true;
+
+	if (softleaf_is_migration_write(entry))
+		pmde = pmd_mkwrite(pmde, vma);
+
+	if (!softleaf_is_migration_read(entry))
+		migration_read_entry = true;
+
 	if (folio_is_device_private(folio)) {
 		if (pmd_write(pmde))
 			entry = make_writable_device_private_entry(
@@ -4959,20 +4973,17 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
-	if (softleaf_is_migration_write(entry))
-		pmde = pmd_mkwrite(pmde, vma);
+	if (old)
+		pmde = pmd_mkold(pmde);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_mkuffd_wp(pmde);
-	if (!softleaf_is_migration_young(entry))
-		pmde = pmd_mkold(pmde);
-	/* NOTE: this may contain setting soft-dirty on some archs */
-	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
+	if (dirty)
 		pmde = pmd_mkdirty(pmde);
 
 	if (folio_test_anon(folio)) {
 		rmap_t rmap_flags = RMAP_NONE;
 
-		if (!softleaf_is_migration_read(entry))
+		if (migration_read_entry)
 			rmap_flags |= RMAP_EXCLUSIVE;
 
 		folio_add_anon_rmap_pmd(folio, new, vma, haddr, rmap_flags);
-- 
2.51.1


