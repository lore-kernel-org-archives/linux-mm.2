Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F155CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E25A8E000E; Tue, 21 Oct 2025 23:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA348E0002; Tue, 21 Oct 2025 23:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A89F8E000E; Tue, 21 Oct 2025 23:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 493708E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:39:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBCD9140705
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:39:48 +0000 (UTC)
X-FDA: 84024346056.15.995351F
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13C57100006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:39:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="GpUI9tj/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761104386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyUV/BSmJqn9CacHkPWlc3oLle2Rdg8sLAr/pnO+Ilo=;
	b=VpUgDhLJb/D0o9DfmnPAdPMfakJwG0s637AI4TszSCCC5KcvyFIs5N1zHP93bEImdRB+a1
	JgqUgNjbaMzTSpFr0R3+EXux2UD0FuUf6jP0Sqaf4se/4XvHcigrzd1XPEqvXdjMgOSRTb
	Pnax+t6MQgvDuG1ZCyvTAMvxu59ULUo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761104386; a=rsa-sha256;
	cv=pass;
	b=yRKGdgus4OemRJR8qAF903zSSURhj1/Y8EYWHTcFxahmJ4I182xYazMcK/4nNP70dGsu/4
	HBcdT+s6afrhsv6oPS3am9Vu4NdM7ReJhiMc8JcFTPE0cAFIUl4dxL+9AKC8evYj4YwM6M
	Q8H85uhjrzzHucKNczjrL1W0Tocb+uM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="GpUI9tj/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzmqNAsIXxpPIi7TW+Mph1HchbrdqkJRppg2Jv2uTz9zfXdkV2pkjnjeaVVr4w3/WCAPkKTw2yT3GxkFgzdo8FOLZwF0GfqNW7l4v82a4dmLcop5FVQLyNYdC/0Gkr0Lp6G4HvUyktLSqg9eY4pbSo0+iF3uvQ4wDMySwIrA4g1IU40Xmr8zr/qA/aqAvTar+Vr/RJjnHwtIjd3LiQSu8HNxNawMKKhBLzyinLObJc1UvrlALNdzuIt2PCm2p8dWr2/0HH92eeSPL/azb5pYRsCqH6vNuM2vJsvr+qkPi5KKRasbVxL7GitHzbJKenT14YymzJJlRFUkjv0IzU/Klw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oyUV/BSmJqn9CacHkPWlc3oLle2Rdg8sLAr/pnO+Ilo=;
 b=pSDUcL6d1QSXWycBPmz9+HHG8bvSHQUb9nunbI8TVVSqkixnD4+Rh+MR8Qo4sSh1FbA0URTHBfKn/PXu4YdZqUtwQdjaml09Q1Cu3sr1NJlZvnapEbVo8erCyxjmsOG0Q3mNBuO0hLUpaN7cJnBvhe9Hbhsk2Ypl3+HlWYpcqAHnJEXiEQkBMIa9+xKvNnua+YB8Li8tWb5Rz5zQQ8jSL9HPTLZUym2N60PFrvfWvWdhRSRerSnOAdFh/jRrRRYzO6M1g1T5SOUQgAqb/YlGSiBBEAXUsMWf/JWW1s2YPKCYUZEbQU2jd2QjDJpYJSvZxKxMa75D9kQX/i4Y4YQNTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyUV/BSmJqn9CacHkPWlc3oLle2Rdg8sLAr/pnO+Ilo=;
 b=GpUI9tj/XBRUQ5MWUbSwjVhNgrVaiuAhRRLDo1pnCaxRrTfhITegidVdOsCV9buA062uin0FGyaKWYwHMZiHcXBFqHmcwVv+D60L0T2jDoH4YAUOVxUsoBP9YaDEz7M8hOSxUV4ZWmklkxUb+5KGyQRTjavMrcTtEaHWHShZhEnnD6WiRzp30+BZd5SokYCwTATGQRj6GxTw7xSJB3PTke3yANCfb3qOL2N2oR+pBOKnpenmWwjCgaouZNGd+GU6I5ODu+QpKcrhGeBQOlAnFxGi5kIiDeYh6IsbM1SwgJ01a4J259v1AdIO3Hi26Gak0/p9F/YmCyj6nEGMPwj5bw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6268.namprd12.prod.outlook.com (2603:10b6:a03:455::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 03:36:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 03:36:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com
Cc: kernel@pankajraghav.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/4] mm/memory-failure: improve large block size folio handling.
Date: Tue, 21 Oct 2025 23:35:29 -0400
Message-ID: <20251022033531.389351-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251022033531.389351-1-ziy@nvidia.com>
References: <20251022033531.389351-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:208:c0::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6268:EE_
X-MS-Office365-Filtering-Correlation-Id: 806116f9-8dd1-4ab7-85d0-08de111c3c8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P4SyNae6Rhju83hFJI9i+42YcDOOAljpZo70ZMnkx1s734+UinhUo7XPZGKv?=
 =?us-ascii?Q?ZR5ZSJBdxhOJnB7jYTdoqq8xSOAoyd/xAiDavkv99L5A6VK/gIaRtrR7EQqw?=
 =?us-ascii?Q?raGV8DxSf2x5dppw5/NZs2MlNR/0FScR1NKO4fWczuG0zWJf/9HwcD9AEyU2?=
 =?us-ascii?Q?hZHNat1Mzm0DWs00FI+CYIR8IwTSuvyNKmfjNr8HIW1OolyLrQtmpXs+BLJf?=
 =?us-ascii?Q?89Gzeb8y5XOkIzlSYfAN1jmiMonOTvzWFBqA+6+Ln2iZ54TbsP4QmNJ9PLUc?=
 =?us-ascii?Q?r6TaK1hX+sV+3RLvBx1qc28/FPkAj/vGq0I98JUz8IOiZ/1PtkmLpsrfDAVl?=
 =?us-ascii?Q?NSqb8EakZlZ2NCMKD6YMa3XkHudc//4DkV63kxTWfuC+c9wcU3QbeqMsN0Fi?=
 =?us-ascii?Q?tM1FEXAeNyyQKz7cnSazl86Q2JQ43TplbEOrKlGq02gbptb6EXnNP9lRnTJV?=
 =?us-ascii?Q?hNwLG/AKTOEwe2aDM5Y1+1rcAV7ZFxqIIGgiLuEjaa8Iv/zTsUtQ81gbdMgf?=
 =?us-ascii?Q?BxH8eYcaCKpMRkTJoqMrMh1Ht/R44Kd5hbRbv3KYxeKIS1AgrbO6b87ok2vJ?=
 =?us-ascii?Q?Z6q7oTRBKo5xPDi2Bs4OCaBXm0YVs6kMLPm8r+RAo78VonCPDNVkdgMeTenM?=
 =?us-ascii?Q?PGBxew7R5mLZ8zazekpHUrXCGuUy4mhfNIQENwrlq0iB0Mec0ujcr3lcPAtY?=
 =?us-ascii?Q?x03r2H7l3Wg5/IkmNTGSsS+VjPSAvPdYCKT/ato0pdN6ldkNCrU2DCK6o/I2?=
 =?us-ascii?Q?DIJmaxvbmN3IcA3kfLlCsQlylbQGLBT86GIHofRY4ZxkiDnk9zaP8Hot3tBa?=
 =?us-ascii?Q?ZRrtd3AziTzqoOFEAD26ATbYpLBkTijBV8guIY0esTfBhGlmm5lzldkwfwiy?=
 =?us-ascii?Q?mjMtBOi48qPm7n9QF4ZYONZCNy8GdZTygDVVHWmrUbf2omGu82l9jlEaTbpF?=
 =?us-ascii?Q?HgiJ1cySb0Vjxd0Kga7byEK9N6C5of67GOmvYdiuwOLY+mcnab/ETvUG2mTV?=
 =?us-ascii?Q?8wF3yeT7/53lnB8Vd/Of9wDpCToJNyv9QRI0XBlNsEnLH0MboRLgrmULU5q5?=
 =?us-ascii?Q?wo2mOTOdsGm8QFb0Sp5Dt55Br37lPk1Qw7Mck+e4BpIRRG+lxncZh/CZ7VcC?=
 =?us-ascii?Q?7KwS0UVa/Kmur6c0vRoLrX3yCKdZr3Cf4Bu9sIesiA0K6MkuATQd82A/0ElW?=
 =?us-ascii?Q?IOhZ8vOROga5mSYhXR7L9kMZJUE7FY1rJjrnDKe/hh9vquswTYZUK9+TTdoV?=
 =?us-ascii?Q?86CIZKJWFIr5MDgX8GchYIJYvpXwPLrdsGGHF995kwBapZEIGu1gOcdsgaRN?=
 =?us-ascii?Q?QG2OiQuTk+xFmp9mk77WUax/OvDwgZR6chhMKVdtN92mTXK1roaTYgAz8MGi?=
 =?us-ascii?Q?olVxNZhF4sEResHJ+MtzW/P+COSxXtH3JKwPHOP3VyRn/kocytgu9DBVfbvU?=
 =?us-ascii?Q?ceu8JZ4gAyd+irAmv3Q8in7knQMUhN0O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TTtYBU9IyF5H7E3537R6ql+qLKTiKhb3pHwOAAQM0vkza7AVGJo7lwuu2E15?=
 =?us-ascii?Q?aAKzv4UzEIv/hyc/dF6581+472Bj9nHLSAYIDMU/nltT6vKa8GcK/+n+RCCi?=
 =?us-ascii?Q?knMVJNjRdPMEDedB/9dcWZ0vbGtpllOdNnz9GkpUYOfm1bqAvh52nTt0OwKs?=
 =?us-ascii?Q?ajs66eP+WBumKZeFuQ0f/upucaubTVZh1ild7xBQJm5cD5jV4p1DSJEC4Vce?=
 =?us-ascii?Q?7wBA+FVND16aw2CCgfW6QNPaWm14I7+AsksqgKFdBAfHtSJG+iwQqGK2mg3z?=
 =?us-ascii?Q?jz3dIfw3xTqBp5WtM7hthJ9RRZb/z8rybhCzoh4ZpuJuFeDSazLKkRyh7a1S?=
 =?us-ascii?Q?lUhQHzjZF33sfQrYbGkxSBp/uDkyZnHSVH8THeW8ac10x0SmKWq3RI+9aliK?=
 =?us-ascii?Q?izxxNK4CGNI4DAdjHqi516nlY27TcHOEeIjP2xWpTkzIrXpsdFXI4n7hk5fd?=
 =?us-ascii?Q?161RK5MKr4tsjYR5d9hyzbWUQRQxE2OlskurZWSUcAB2XagSErhgPWQ5f/aB?=
 =?us-ascii?Q?rhCP8FUOfOa9/5yb6fv+QZV0EzBglyCKunKuirM6nxYsPkbLMJTt1yJJVfgS?=
 =?us-ascii?Q?1UIe8rYmo+CE23O44JayZ6OtTnwMzZCERuGfedr0JSdPZ2yshcuEQEoIPRLN?=
 =?us-ascii?Q?4oYE25CuHDJEhuOz64aXXDV+sU57ZeP2mI5mnuBJxWyZ/vYva4JdfW5UOB5p?=
 =?us-ascii?Q?nPYKbJnkbuvqyht+5LZUME6+2OU9d4hgA4IPB7AOpJEeO3BGiJLLGBCJEf1G?=
 =?us-ascii?Q?Fq9zB/Jmic7uaV3d8ygnWTf84zZYYDrAbr+nb9/JHNq1jfb+Hp3MsGJUC54d?=
 =?us-ascii?Q?2T0Ed63O1EZawb8VGM304FJFv/reLpoN/wsPL0dVJqy6KAJWJ1aXmG2IMz5p?=
 =?us-ascii?Q?qm6MLE9xzbjhBlEk0Tqdv96n4FesC7TzAIlvozpzvlR6c+vHl2LvL04g8M63?=
 =?us-ascii?Q?RW5Z3BQl/Ut5E69L/W+TXNxJzZD9nTeUDZPEDUV5z/QWvrYBhDkZIktPZKvU?=
 =?us-ascii?Q?gtKhjP9awb/3VpcTeL4JKuD9NxJRD4tk0PHS/WOYe0WvWJaaoAAZGsGhFdZG?=
 =?us-ascii?Q?xBH39oRgTIhzou81VxRsQeWlEDXqfZqggXnpafl/GN0gwU/Y6Qsk53je1ckq?=
 =?us-ascii?Q?HzPARYd3HIKf4A/0hnusfgtBPnzOv7xopmPbrYLH5Ncb1rBVwR5aFhnDY+79?=
 =?us-ascii?Q?HzoA3ZSch8zceJakMocgvxRWUZH+1ed89xwPsLi+GqVVHClUWnVum8qnYBAO?=
 =?us-ascii?Q?/qrtp8QKYxuLRN8GNjwiS0EaLr7D5aazCZt8jLjj9KFrCu2rGtdGF7cYLsG5?=
 =?us-ascii?Q?hqr+qEyRjt8gJRt8FY9q+k72vmdAuEDTZlaMv2zeW/K+OWoMJPWRhR4oC9Hl?=
 =?us-ascii?Q?Vo6vCExmGsL/llxeFI03+I/JNFd2x69gUlIekLpTQfz6IqGdEfiVUZP4+jwj?=
 =?us-ascii?Q?Mice4usOWEpCwzbPnB36K0bt//805VDzfuKmbL0ki55haQjEut0NBUBH0b8Z?=
 =?us-ascii?Q?NkOxvd8eGZbYwG84NfnM/ydGRJtcRAT8zbVoFpyM76tEanopcT/O3hILC9YT?=
 =?us-ascii?Q?1z/BIG3KOFSB/FwCuOMpByR0Cq/5A69d48fHm1WD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806116f9-8dd1-4ab7-85d0-08de111c3c8d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 03:36:50.7044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UKnwpj9MPiUeswXyOFBVEjgIxbaS0RrOysqs11p7V17Hbw9clGIpOecaEdzYXA8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6268
X-Rspamd-Server: rspam05
X-Stat-Signature: dwjr3am8y1dfu5apmuir4kb5eqt4356j
X-Rspam-User: 
X-Rspamd-Queue-Id: 13C57100006
X-HE-Tag: 1761104385-783892
X-HE-Meta: U2FsdGVkX19yFaxEEWvDM/qWf70PM2vWuZ/6ZLSlfRbQec9HurTRhSxhMcjaAp5SaDFeOsOycfXYaLXZBxh3G6X4E/L0MGjMxrZSPuEBuFMjJWlR95p8E+zIcuEPYiMuVTc8z7w38J42tJKDMK9iFbgTfw5YfYB1idM7Et5891DwrVOC4MRuhXc+Y57PptEtJK70mOw3M3L+RAisFP0/pUiwO/qNC7M2g1sKB51rwMGDzpw10/NIwISuPA32O4qxeco8whTc399Ij07YoJz5oB7oeCFCWkRqX+biIR0K6MDWD4W7esOPr6OW3MOUDftOk4KpDiM1Orm7z6Q7flXxi4gt06cY2LN+3zjLjrPcut2a2kTMKMbcKwoai8tX/ovr86V47PpLVbCEJr3snnRLYmsgkVJhwEv4lojgnJn8FwVrjOtpyVQVKGd5gOWL94bo5ZbduM/GY3r68QfGIdWA2VdRbELrjYqcB8yrS5q8fiid2If/tk+JoqeGtgJoJF4osZa8exyvH4wnsvbwUKLSbE3c//hVkgCT0/1+EhFILkhNzHnSzu011yZ2QYbgkEEjt7jdJKASZO5GUbR6zOgfzoRFBMHJYMtEy78vAaRQnset5OnuCWY88/4DC04+g1QsOimX5m3gaHu5U8JZKxn7cquYm6fQiIhHZg/SAQ/bfJbnHpefKxZo6xPoWUlSOzAnzaEpuhLLOmcOxtOv2VVUHeWxTiArwcJRSHXpYh290Rf1Jjm4YEY+we1pUgr1hJ08yiVjt2wvn3/HGs0ewr1NeRp5ViNaLMwRTlaIRYub7Ox4WC6vvaLjfa/XvVyGKDbWgCNrh2iu7BEkhBluUHacGsarilk1xnGIAr0vlEnenhYHwoxmG55b/r7cGNiQrSH0lUTRmpnRiCrkqhoU6wqkArZNrJ96+VZdujb1C1yYuc726w2gOreBy7P1RJoCuQFsn327PJ0KGVTSxpLDsgI
 6WNlrTpA
 fShUECVnbMQInhD2j2CqV3rGXEuc1XfVBLtDfCqRnnp3FQNm/vxuwUVumbLaOBVfkdAh50dFuiVP/zwl+yYTofjnts9yHPz/ZCIDEajf4YHJuv7p7FNBlcr9wieLogw6LEUBBqBuu0sQeV6tb6i05LTqwg5qmghvg0Q3sh0r+pi7xvjOWBrCiFvXyOWIym+JxOLPpVZp2d34SEObtVGXs/GcNoomeYuDycO4Xs1DYT72gbgaScwBAWd0MOVc580HpmLwXc6SkAx51ZgV3eo2Au6qUTeaF/N/Fbpb2mVuYBYqcsFqs8MpYO1sVdwtHCRyudVxOJOnEB9csZSioM38bNCAvO0eHLo96EHwtpPDTYOZC9HvOeumhnKe5BuQN4tXl9cVJ9XLO2FLj72uPC70IWqr5YAVNo+cnSwCMu0XZeh6hKGbSLp++uh4YWUi+O8Ki53ZBwntJ/gTESSJNLfVHvjUob3gDWc5X6wv+NVhBus6FteNq+XqpJVrCxhOeXjV/5J5np2KcrcppskgpVaLu7DxWZSma/w85ZY7zODu3Oc32gu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large block size (LBS) folios cannot be split to order-0 folios but
min_order_for_folio(). Current split fails directly, but that is not
optimal. Split the folio to min_order_for_folio(), so that, after split,
only the folio containing the poisoned page becomes unusable instead.

For soft offline, do not split the large folio if its min_order_for_folio()
is not 0. Since the folio is still accessible from userspace and premature
split might lead to potential performance loss.

Suggested-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/memory-failure.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f698df156bf8..40687b7aa8be 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
  * there is still more to do, hence the page refcount we took earlier
  * is still needed.
  */
-static int try_to_split_thp_page(struct page *page, bool release)
+static int try_to_split_thp_page(struct page *page, unsigned int new_order,
+		bool release)
 {
 	int ret;
 
 	lock_page(page);
-	ret = split_huge_page(page);
+	ret = split_huge_page_to_order(page, new_order);
 	unlock_page(page);
 
 	if (ret && release)
@@ -2280,6 +2281,9 @@ int memory_failure(unsigned long pfn, int flags)
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
+		int new_order = min_order_for_split(folio);
+		int err;
+
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2294,7 +2298,15 @@ int memory_failure(unsigned long pfn, int flags)
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		if (try_to_split_thp_page(p, false) < 0) {
+		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+		/*
+		 * If the folio cannot be split to order-0, kill the process,
+		 * but split the folio anyway to minimize the amount of unusable
+		 * pages.
+		 */
+		if (err || new_order) {
+			/* get folio again in case the original one is split */
+			folio = page_folio(p);
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);
@@ -2621,7 +2633,17 @@ static int soft_offline_in_use_page(struct page *page)
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		if (try_to_split_thp_page(page, true)) {
+		int new_order = min_order_for_split(folio);
+
+		/*
+		 * If new_order (target split order) is not 0, do not split the
+		 * folio at all to retain the still accessible large folio.
+		 * NOTE: if minimizing the number of soft offline pages is
+		 * preferred, split it to non-zero new_order like it is done in
+		 * memory_failure().
+		 */
+		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
+						       /* release= */ true)) {
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
-- 
2.51.0


