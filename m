Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6C0C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6B26B008A; Wed, 26 Aug 2026 04:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597CA6B0092; Wed, 26 Aug 2026 04:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F116B0095; Wed, 26 Aug 2026 04:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 164B76B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:48:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44C0C80260
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:48:05 +0000 (UTC)
X-FDA: 85142793330.21.95EAD61
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010037.outbound.protection.outlook.com [52.101.61.37])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F292C0003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:48:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TSipHWTG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of icheng@nvidia.com designates 52.101.61.37 as permitted sender) smtp.mailfrom=icheng@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787734082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Er0qwZ47ZMfsu10+Zk3MkK4DNMxUDx6hXs0q9AGHotE=;
	b=jusLVG7zQvhpGw9r6yki90fOMlVvNyjxpJRwkShy5F4LRLqrsffjICTTlqDUbGNDbFRF4F
	77xVZxbo01z5qjpTeS4DjA5jFJZOTTl1n+laTSHdXJJ/9c4X8Pp4/CBsvxlM1FFW0/WU6O
	iRyodlHSNJ0exUhCKzC4ne5uxRwGDZk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TSipHWTG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of icheng@nvidia.com designates 52.101.61.37 as permitted sender) smtp.mailfrom=icheng@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787734082;
	b=GuA2ydUyNHtg4gCNLli5oJV6Det1scrF1tXs5y726qFMozc8GcfB0dtE96xnfQ6JXGyDTD
	4LEPfba0DHQnKOmo247K6S3CMb0OE9fRkyLYDxvBVeKtiMFNOYjQWbm2NNllmkveZgZKZ2
	OzHZ9trKPXsAOu6avyKc3TqZ6tdNSX0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uqNYWhx5w1INu5PEZ6FR9Da+yCBcmaCTx7+MBrLGiJ21BNjWadP/qJIDdK5fyCMWYNXyX1thq2s5dakqmRMz9o/K25n/MxxDW/gHH/oYpUHHvpywjDV8d/n6yDweMFYezWHPYapFcID5lGSPRl8j0j5DtCQwUvXDnSAZfx7ZZuLAhSTBd7518d1qiFH97y+hpjfvP5Xs/hgKaFOivxetXLATXQkt6xIsc8KIJSgYrtRd/kOHu+7JPt04+u8Dtb+ZJJdW1UclqB0n5GV4/qsmANT4xUkUojU5Pwc71pZ4sdDWHUD8trLbNynH/KBw5HHsQQzGUVSctMRYINUmhLzJ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Er0qwZ47ZMfsu10+Zk3MkK4DNMxUDx6hXs0q9AGHotE=;
 b=BNE1xJIpUKUzJQvlm187fgXl2eRcAVJ9w1cOnZFsPN9uFGdJMMd5pKTPTEcGoqddL93rIERWFrBY6Mzaz6QIZTWPoopj26/DDZHsiUMNapmuTiN2Ywbkc0wHpUiEuIXERGM5afR/4vqL6LyQ6BW2SYFEdgY/nkO21+e7LbSrg57mArvgNEp+ZCmF1QRzYahQw6HU9h7gzrfKfD/tkGMV8Wrud3ckdl/xeXZkz2SLXkkiTwEfbhKDyo54mW7FkxU+v/eTnKF8sjaT14enFZ1iFdCT6O29yVlXF2Vt6MRgR+H8uBCM8BV9sAUXuIfEVFtT34PAKUW50yKpTFBkvXOUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Er0qwZ47ZMfsu10+Zk3MkK4DNMxUDx6hXs0q9AGHotE=;
 b=TSipHWTGPxNJ9+WEtc64aWBPzQRaJB6bbes696Bc1t9Ds5sqcRQPE3QmQcD+tD0UkULh/P0lTaQW949p4unx4rmCrOG8SAHISv2eb+VFYZDHXlXrvWO3pluA+LOLI7HIlU1l5vBFASvLAKcfsOmuYCdnOETgdENP3KoDnAF55Yr8nn6WOh1Ak2XIfgqFIVWf8cWRH3qNDAi3U5ZkreXFYoMYBPqIP7iQVhyAeEImsM4KIHCPjNG+OzXZL0btMhZpg+IuAAHK6iv2FR+K5daEGtGjTppjuHqWNuva9390bu/QAsFnbZAqo0vc2K94asbCFliHpKf1dubTGi1nh7vnHA==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Wed, 26 Aug
 2026 08:47:55 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%7]) with mapi id 15.21.0360.005; Wed, 26 Aug 2026
 08:47:55 +0000
Date: Wed, 26 Aug 2026 16:47:46 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Cc: linux-cxl@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>, Li Ming <ming.li@zohomail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, 
	Oliver O'Halloran <oohall@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 10/13] PCI/CXL: Clear ACS SV across an SBR of a CXL
 DPort
Message-ID: <ao6mpWvrooxUOvZH@MWDK4CY14F>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
 <20260825022628.3651434-11-fabio.m.de.francesco@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825022628.3651434-11-fabio.m.de.francesco@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0214.apcprd04.prod.outlook.com
 (2603:1096:4:187::17) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|CH2PR12MB4198:EE_
X-MS-Office365-Filtering-Correlation-Id: 9526f251-8f8a-4ae6-283c-08df034eb7e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|10067099003|56012099006|6133799003|18002099003|22082099003|11063799006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	1mkZcimQ/1PAmDzizx7vs6oZYyn4ubFf0n5Tb98Xc4AuKKVD7dTlRrZ1UP7k6+uwXddR2H1p6k4IrSpVA6+AH9aKN5yyDbjXuwFGxGcBHPNe29e7FBzbNWSE7Sb8kQj/zD19baFwETNqGG/kE645Lne7VkWkGn6ibWjbc3AadwYneVM/Fk/tDiV77kzUBbn49jclO19DAU7fZOpvpPT0PTOiosVBVaH1+CwjSl1miBRo4Z7SsnzEdPfF2363KR1rGWGO720uFHN0SmBi8GdFKb9GFQwAs+E0fmbXP0wz4Eso/sf2VnNGbU+LkQ9g1LQM/ENk+ZThk7Lh3guHDhUsdU0LJZkKVOWJ/7r/UvuHfV5g4r/DjrUTZLzKYypzlMej9fcFYdjRTO9ZLkoBa167L/t1nWoNbo16KQ4M/UTtzKRVIP7SaTeD31+k32eUG+r9WYvIr1EEegGQGSX1BHnAWBVQ7V3gwoKRY57AklnA47jdUx2YnDdtCauKq3IWaAr0xQH5X6K8XOXMcZuB3tF5zrT4UHYBXGb+L0r0MzT3HuAWz/4zNUjdej/mb8EafQoIyrKm59o7NNGkuyBM2FtcoNp8Yj1pTr+obME/LZMfK4FqGmft8X3mzcCreBTfo5llfQcD2As2uOw3XC9Z5xYQ5nGy3PXa1s9Nj4dLZ1N0/sM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(11063799006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?owcHqNVbbeV+ZGntqDpNWxzd0lLpiL6k6zsIf4cQlCYwxMQNWUNtD/CVr2to?=
 =?us-ascii?Q?SyEKeOeu6WIXVJxAcatICKPerJbTZ+wnLnM9IKOn7S9HZ/bDfjs8nJKlUg/J?=
 =?us-ascii?Q?ICZ/Ty4V4X+u9dWSVaS02eF0ci/KBvnoWGGdmit4Iim8VEW687ieIc2S7r0X?=
 =?us-ascii?Q?xNHzMoEo3vvtCM0Np7xtbjalOR77KxPJaKre6XPyt0MIvRSJnHH3HAHHF1+l?=
 =?us-ascii?Q?DJsN/XSz2kc7G5hCMrBgbDfiSdrBCsl1gL0cnFkghLladwDW69D8Pq9jRb3H?=
 =?us-ascii?Q?jv7y4GBPsA+lL3TxxwBo4A35QnHd3tSjwu3dGTEn53nIvm24xlCFHfb79rx3?=
 =?us-ascii?Q?z9RVhuLCShfWcfutgHV54T78M34bF6qq0d1GHmrn79vSCHBJdTik5f6Tocrk?=
 =?us-ascii?Q?sbUGKqFetCZaFjhtl/YwNb+fuLnrsCJAqYnFXBj8DOsBw3a/JCpAi7K2DsVU?=
 =?us-ascii?Q?Rz2q/ySsRzP+KXOXcmIGb6BaqPmAaZi0zyTcI+OfcTOTxUrW2khBnNvKnQNI?=
 =?us-ascii?Q?3ITpGf3f4fMVD12tY2wSIZyV8YVN9+0ho1vaYwnn5Id+Q/iVxWneTKIKLK2P?=
 =?us-ascii?Q?AImSExe5/kYMcOAcjZrQaxuc4k7af1YVJWLPttV8GHRAe8pK3YvPb5RLwfz6?=
 =?us-ascii?Q?3Ik1AFHYNNwnsrAWk9cM8mrBTjcLmr0qi8L5/scOlkq1a5v3EiuL6m2amTqe?=
 =?us-ascii?Q?HKmsyCcyboLz5/rG/Aj/awa5oHl2jTDBS+WEh3zo1mXRGeyJjsuUNwTKwkMg?=
 =?us-ascii?Q?mW7Yju3+ay0EVxencHYHIjJr0CUSa1hiPNmx4A/gnCswkScLDZMDKp3wuAUn?=
 =?us-ascii?Q?cT04rxCcxZIoMcjJOh7SV0IUvpaDBimEAOcbdLFv8c0+CsfF0OdlrslgyWjA?=
 =?us-ascii?Q?vHlFs1l58m0FgwYuT9Pf+DvURJ1pgxHIy7n3u4nj+wFULJMSqOqO5w8IyC2o?=
 =?us-ascii?Q?G2B95TNiTqFzKPOpow6gdXOwmMysM+yK0q5zC7d5VmYxoVWLyIgw4zcTsCHC?=
 =?us-ascii?Q?GCNEiMjvRR9wGvwgIbq5A6nBzhqOBi9T838K5OZpDcQkOL8aM/amVipqzLB5?=
 =?us-ascii?Q?US+KqYdrNA7u77bj8jtwtGKD75+6dqtg1IA1Fl+bP8cVb7mim1La6JlJqCzb?=
 =?us-ascii?Q?2hwNnMmgmr1xmURtwpQ5Ko6eFs+aagyZSfdJUWPjeaoJgARt3JtjxPA4JF1F?=
 =?us-ascii?Q?tAMziIgYmecvbozvyPzrFKcYupRfFi9GxIy/mOa5+wUYCWGVSqhqTEj9XIb1?=
 =?us-ascii?Q?NAC9PLA79OXKXq/0kbclgs0sen8efLkosWRPMlxPcPhM5Ns7YVuTv2Sjsaul?=
 =?us-ascii?Q?C/uJUK84Xua000pQmy5nOCFshBSZA8t3Grvgfl+vFGEDEQhmtsY57m66BSrR?=
 =?us-ascii?Q?c95jQgQ/d82UNchWi+saSCu7UnKsp5apPE6prcm10RM1f7gg6FIFPgJw+faa?=
 =?us-ascii?Q?DbNIdWK7JgdhmSgiV1z1m2MKfjiwdCbHjmpnE1CfkG1GVse/m5dNv1wlJ/Ay?=
 =?us-ascii?Q?bqEFsm3LxJTrd29osTtlXJtWG9rwwQ3NkFJdGv/XShyX4on7/ry9Jw//n6kU?=
 =?us-ascii?Q?DDl7bSXslYgenYIzqlO9zWP6ibn5RNH3Az5G/m81YYf5wwKIND2WrAgtmOm9?=
 =?us-ascii?Q?9BmZo7yV8c6yM6/tzyVrCB4Xj8i/K+ZkdqXH8w1CDubE60N5J4gy1zBYWgQm?=
 =?us-ascii?Q?U6j82nQBBqZS3TvkyGDI9fCkYZSaP1eiLx4VtNlZnFt8K0a2jnZ0o2KCMbcp?=
 =?us-ascii?Q?KaqdBS/6GA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9526f251-8f8a-4ae6-283c-08df034eb7e5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 08:47:54.9876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CoT5/S3mCllsPwXu/PR8RLDdN7cE8+5ffB7+HzWs9c/c9wUT4YLVm2lkp1UoaJeDZ/lQ7ii+bcvfmbX78kBKHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F292C0003
X-Stat-Signature: onxpduqapyzhmbw6mbo6zf5ibtsp6cxb
X-Rspam-User: 
X-HE-Tag: 1787734082-570709
X-HE-Meta: U2FsdGVkX1/G2+GkU5Lfq4CQ2KplgMD4AlRg8Ii5kDR/p3vKrJgTvEfIRi+lGCLKlEbXIMQumhn8K+hGYbPOQuN6fGJruVc+PvcU+AYQ5uoqwq8jCLT7DFLaCXBLtckmgYQzssqIzai/h5v3ugEHpEIOnncdj/igjK9xp+3U4R8EJbPz7oUb93I82ej6+YXNuwaQLlZ1HRCv9xkPA1BaVQb4L7Ii/Bmt4tfNVE5H25sGQ3cdiWtrC4X9ZGGBXBm+0gpOwGvX3kyUWnTaDMP+9E/jnyu3QhqWzFEpRpdlkpq6FKlg+oors4UtFmbkJK3dhExFgvaK3P2wMsUXabSDezJ83Hs3wuLqbM/GYQY0jf7QJhUJyeqlKd14tpXtNpoi/Yd92jbXhov0nP1V8icwlBDVHb4YCVFnICd5iFhZ2B0tGTKOSH/mxUNwbiOckDWzIhBL3LlsTWCzi/21zECXJ+/FjFs8rVV473CZJcfsZRUAAul8jtsuSXqUO3hOPcOa7gMX5C5LSie8dcPyIDkvq6mOWqhulhKhHbu26vGNE6LK6sa9ZOeBnfwWoHsLEgORXfbG29noahFaHS9ugnlBkJ7igZciFLfVL+d1KMfZL6bYs9BZ7XKiGslGEe5iSaWTTcFHH0o4PWXJsdc/jXN/9ECrddSDC6+sIj1V515Me08MGIy/XCdatP7TUJTF/koXvzHZV5QSUY8fDY6tTE+HuzGvqgJkdoCt4kkZu1se/wXKQ3Dlgww4fDKf1kduEeAtUHXiovZKYqyjUxSYEXF7wOeZznE2o5QJQW688tq8ga7APGVYSREFqTiHIZUzZgDSlZBHN4ONbBTDzGUjM2ut53ZrYc0xhmfgBuEmheg9fwDgQuLJdgtJ12Zx5eIfjlOzIiGxc+xYaEYOVOEu16f9In1O57nD3njF3pog3zsm0g5xtTCrq54RU1TE+oMUKXAe7WY4y99VSvoaMypGXev
 lk6D56XP
 VhSxEV7mrCvVZS1t/mKRvsHlIV8NwzReUBTqCACXGZsdkSh6oVJd6D9nZbkv5WudbZ39o1ZXOJ8ZA5PHAaNdCBspAomXkyXTp//Ej8/nV/69BvLpZmlXdytdwiNRzev8mN/X9Rf6xH/z0jbNzpY4ekLk054pmrT4enCVuWQJ1Juq98Q1ay1KIVk4SallRfh6zVEM7T4x9Y+SO/iVMJzg834nLSVZlMAVCr3xJYdWYRf6n8xvomRl5MLWjC2/7dR99LHcu+efc5H56H0HWOVtr2IGa/QPMMv5x8w6Po5ccxvR7eRbCvQcgu3j11kJyDjwukRxNy28XdT4S+z0H/0QJXoQjXCS1rV80dnxVjABbwnYLxig1UIYE0CS/pkuJ4oKwYr9NdoTTNaImKgosxdQ99JeWU2fG+vyvHxwY192XiHhaL9CqqDcB5IBW/gyfkYryg09XWzkJF/dZnjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 04:26:25AM +0800, Fabio M. De Francesco wrote:
> A Secondary Bus Reset (SBR) of a CXL Downstream Port clears the
> Downstream Component's (DPort) captured Bus Number. CXL r4.0 sec 8.1.5.1
> notes that if a Downstream Component issues PM Init messages to a DPort
> with Access Control Services (ACS) Source Validation (SV) bit enabled,
> PM Initialization may then fail to complete, and that a further SBR
> alone does not recover it. PCIe r7.0 sec 6.12.1.1 makes that rejection
> an error that is a reported as ACS Violation.
> 
> Reuse the recovery sequence described in sec 8.1.5.1 but make it
> preventive, so that PM Init don't fail and don't need to be recovered.
> 
> Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
> ---
>  drivers/pci/pci.c             | 177 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/pci_regs.h |   2 +
>  2 files changed, 172 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 417b6b44473e..f3781d1e8f6e 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -23,6 +23,7 @@
>  #include <linux/module.h>
>  #include <linux/spinlock.h>
>  #include <linux/string.h>
> +#include <linux/string_choices.h>
>  #include <linux/log2.h>
>  #include <linux/logic_pio.h>
>  #include <linux/device.h>
> @@ -4857,21 +4858,189 @@ void pci_cxl_set_sbr_region_ops(const struct pci_cxl_sbr_region_ops *ops)
>  }
>  EXPORT_SYMBOL_GPL(pci_cxl_set_sbr_region_ops);
>  
> +struct cxl_sbr_ctx {
> +	u16 port_ctl;
> +	u16 acs_ctrl;
> +	u16 command;
> +};
> +
> +static bool is_cxl_dport(struct pci_dev *dev)
> +{
> +	return pcie_is_cxl(dev) && pcie_downstream_port(dev);
> +}
> +
> +static u16 cxl_port_dvsec(struct pci_dev *dev)
> +{
> +	return pci_find_dvsec_capability(dev, PCI_VENDOR_ID_CXL,
> +					 PCI_DVSEC_CXL_PORT);
> +}
> +
> +static int cxl_sbr_prepare(struct pci_dev *bridge, u16 dvsec,
> +			   struct cxl_sbr_ctx *ctx)
> +{
> +	int rc;
> +
> +	/* Abort before touching hardware if the regions cannot be disabled. */
> +	if (cxl_sbr_region_ops) {
> +		rc = cxl_sbr_region_ops->disable_regions(bridge);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	/* CXL r4.0 sec 8.1.5.2, Table 8-32: set Unmask SBR so the Port issues Hot Reset. */
> +	pci_read_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL, &ctx->port_ctl);
> +	pci_write_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL,
> +			      ctx->port_ctl | PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR);
> +
> +	pci_read_config_word(bridge, PCI_COMMAND, &ctx->command);
> +	pci_clear_master(bridge);
> +
> +	/* CXL r4.0 sec 8.1.5.1: Disable ACS SV bit before SBR */
> +	if (bridge->acs_cap) {
> +		pci_read_config_word(bridge, bridge->acs_cap + PCI_ACS_CTRL, &ctx->acs_ctrl);
> +		pci_dbg(bridge, "%s: ACS SV %s\n", __func__,
> +			str_enabled_disabled(ctx->acs_ctrl & PCI_ACS_SV));
> +		pci_write_config_word(bridge, bridge->acs_cap + PCI_ACS_CTRL,
> +				      ctx->acs_ctrl & ~PCI_ACS_SV);
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * CXL r4.0 sec 8.1.5.1, Table 8-31: the Port sets PM Init Complete within
> + * 100 ms of link-up. Restoring ACS Source Validation before then makes the
> + * Port reject the downstream Component's Requester-Bus-0 IP2PM message, so
> + * poll for completion before restoring config.
> + */
> +static bool cxl_port_pm_init_is_complete(struct pci_dev *bridge, u16 dvsec)
> +{
> +	unsigned long start = jiffies;
> +	unsigned long timeout = start + msecs_to_jiffies(100);
> +	u16 status;
> +
> +	do {
> +		pci_read_config_word(bridge,
> +				     dvsec + PCI_DVSEC_CXL_PORT_EXT_STATUS,
> +				     &status);
> +		if (!PCI_POSSIBLE_ERROR(status) &&
> +		    (status & PCI_DVSEC_CXL_PORT_EXT_STATUS_PM_INIT_COMP)) {
> +			pci_dbg(bridge, "%s: PM Init Complete set after %u ms, ext status %#06x\n",
> +				__func__, jiffies_to_msecs(jiffies - start), status);
> +			return true;
> +		}
> +		msleep(10);
> +	} while (time_before(jiffies, timeout));
> +
> +	pci_warn(bridge, "%s: PM Init Complete not set after %u ms, ext status %#06x\n",
> +		 __func__, jiffies_to_msecs(jiffies - start), status);
> +
> +	return false;
> +}
> +
> +static int cxl_sbr_restore_config_space(struct pci_dev *dev, void *userdata)
> +{
> +	pci_restore_config_space(dev);
> +	pci_dbg(dev, "%s: config space restored\n", __func__);
> +
> +	return 0;
> +}
> +
> +/*
> + * The CXL region ops that run next read the HDM Decoders through a Base Address
> + * Register the reset returned to its initialization value, so restore the
> + * header of every device below @bridge first. Restoring also re-captures each
> + * Bus Number before the Port's ACS Source Validation comes back: a device that
> + * has completed no Type 0 Configuration Write since the reset sources Requests
> + * with Bus 0, which the Port rejects as an ACS Violation.
> + *
> + * Only the header is restored. The capability state each caller saved is its own
> + * to replay, and the ->reset_done() callbacks pci_dev_restore() invokes must
> + * fire once, from the caller that owns the reset.
> + */
> +static void cxl_sbr_restore_subordinate(struct pci_dev *bridge)
> +{
> +	if (!bridge->subordinate)
> +		return;
> +
> +	/* Parents before children: a child answers once its parent forwards. */
> +	pci_walk_bus(bridge->subordinate, cxl_sbr_restore_config_space, NULL);
> +}
> +
> +static void cxl_sbr_complete(struct pci_dev *bridge, u16 dvsec,
> +			     const struct cxl_sbr_ctx *ctx)
> +{
> +	u16 val;
> +
> +	/* CXL r4.0 sec 8.1.5.1: wait for PM Init before restoring ACS SV. */
> +	if (!cxl_port_pm_init_is_complete(bridge, dvsec))
> +		pci_warn(bridge,
> +			 "restoring ACS Source Validation before PM Init complete; Port may reject the Component's bus 0 traffic\n");
> +
> +	cxl_sbr_restore_subordinate(bridge);
> +
> +	/* CXL r4.0 sec 8.1.5.1: Re-enable ACS SV bit after SBR if it was enabled before */
> +	if (bridge->acs_cap && (ctx->acs_ctrl & PCI_ACS_SV)) {
> +		pci_read_config_word(bridge, bridge->acs_cap + PCI_ACS_CTRL, &val);
> +		pci_write_config_word(bridge, bridge->acs_cap + PCI_ACS_CTRL,
> +				      val | PCI_ACS_SV);
> +		pci_dbg(bridge, "%s: ACS SV bit set\n", __func__);
> +	} else {
> +		pci_dbg(bridge, "%s: ACS SV bit not set (was not enabled before the SBR)\n",
> +			__func__);
> +	}
> +
> +	if (ctx->command & PCI_COMMAND_MASTER)
> +		pci_set_master(bridge);
> +
> +	if (!(ctx->port_ctl & PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR)) {
> +		pci_read_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL, &val);
> +		pci_write_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL,
> +				      val & ~PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR);
> +	}
> +
> +	if (cxl_sbr_region_ops)
> +		cxl_sbr_region_ops->enable_regions(bridge);
> +}
> +
>  /**
>   * pci_bridge_secondary_bus_reset - Reset the secondary bus on a PCI bridge.
>   * @dev: Bridge device
>   *
>   * Use the bridge control register to assert reset on the secondary bus.
>   * Devices on the secondary bus are left in power-on state.
> + *
> + * When @dev is a CXL Downstream Port, clear ACS Source Validation and Bus
> + * Master Enable across the reset, per the workaround in CXL r4.0 sec 8.1.5.1,
> + * so that Port Power Management Initialization completes at link-up. The
> + * bits stay cleared until the secondary bus is back, then are restored.
>   */
>  int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
>  {
> +	struct cxl_sbr_ctx ctx = {};
> +	u16 dvsec = 0;
> +	int rc;
> +
>  	if (!dev->block_cfg_access)
>  		pci_warn_once(dev, "unlocked secondary bus reset via: %pS\n",
>  			      __builtin_return_address(0));
> +
> +	if (is_cxl_dport(dev))
> +		dvsec = cxl_port_dvsec(dev);
> +	if (dvsec) {
> +		rc = cxl_sbr_prepare(dev, dvsec, &ctx);
> +		if (rc)
> +			return rc;
> +	}
> +
>  	pcibios_reset_secondary_bus(dev);
>  
> -	return pci_bridge_wait_for_secondary_bus(dev, "bus reset");
> +	rc = pci_bridge_wait_for_secondary_bus(dev, "bus reset");
> +
> +	if (dvsec)
> +		cxl_sbr_complete(dev, dvsec, &ctx);

Hi Fabio,

I wonder what happens if pci_bridge_wait_for_secondary_bus() fails here?

Maybe failures before/after SBR should be handled differenly ?

Before SBR, it's safe to undo preparation. After SBR, the HW state may be unknown,
in that case, enable_regions() must not reattach regions unless PCI state and all HDM
decoders were restored successfully.

Best regards,
Richard Cheng

> +
> +	return rc;
>  }
>  EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
>  
> @@ -4917,12 +5086,6 @@ static int pci_dev_reset_slot_function(struct pci_dev *dev, bool probe)
>  	return pci_reset_hotplug_slot(dev->slot->hotplug, probe);
>  }
>  
> -static u16 cxl_port_dvsec(struct pci_dev *dev)
> -{
> -	return pci_find_dvsec_capability(dev, PCI_VENDOR_ID_CXL,
> -					 PCI_DVSEC_CXL_PORT);
> -}
> -
>  static bool cxl_sbr_masked(struct pci_dev *dev)
>  {
>  	u16 dvsec, reg;
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index facaa324bd86..0eaa34db93ce 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -1371,6 +1371,8 @@
>  
>  /* CXL r4.0, 8.1.5: Extensions DVSEC for Ports */
>  #define PCI_DVSEC_CXL_PORT				3
> +#define  PCI_DVSEC_CXL_PORT_EXT_STATUS			0x0a
> +#define   PCI_DVSEC_CXL_PORT_EXT_STATUS_PM_INIT_COMP	0x00000001
>  #define  PCI_DVSEC_CXL_PORT_CTL				0x0c
>  #define   PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR		0x00000001
>  
> -- 
> 2.55.0
> 
> 

