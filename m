Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400DEC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78CD6B014A; Thu, 24 Jul 2025 04:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50296B014C; Thu, 24 Jul 2025 04:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18076B014D; Thu, 24 Jul 2025 04:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0F706B014A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:47:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62F50802E6
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:47:27 +0000 (UTC)
X-FDA: 83698529334.11.D033627
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012037.outbound.protection.outlook.com [52.101.126.37])
	by imf20.hostedemail.com (Postfix) with ESMTP id 981401C0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:47:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=YWjEOVCB;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of link@vivo.com designates 52.101.126.37 as permitted sender) smtp.mailfrom=link@vivo.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753346844; a=rsa-sha256;
	cv=pass;
	b=UHlvN/TfT9lEvqosjUtI2jWBpIHwLBj08uOAFVb85BmV4IvuQH7yP6v5tSIvath9jxiTKV
	nIT5PpQWjQqIcZJH5lKU6qG3e0Sr2wfJmNxb6agFO9OLVtLQ1RgUdyfchnw0Nmx6lnQaxh
	dRdtj4o1/sjtY6e3JxnYuoljpUZlH1M=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=YWjEOVCB;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of link@vivo.com designates 52.101.126.37 as permitted sender) smtp.mailfrom=link@vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pThp25aSgZjCV3oK2DYHuqnuEQLQjBp5Rhnz6cgjz+o=;
	b=vUubdCzO7UPxao3E/F8P3AQsfE8BbN5HssvsLPb65mra3nab7oqABlBIK+oJOC5fNwYa6/
	gPSpigTBrSQvtWLZkyUcMif1Qq1PRkkUwhcgD72tQu61Xa9vAMcvQinCU70gBfRZjVKiXY
	hCwmAE/FFxWhnCYx3Qk5mIIqfllAI1A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wLmbXgSy+B7jLOArA8bEBZmtYYL1njACESBTlSl0CvhuOnfoLBZgtEVxGwn6FQHg6GlpdLKmcXGPB9UqBfP0lFZT+uAa1dzgk7FLOCcolgnFKVk4tz7wshNJTTiZReMLzaQwpNAWoVzJBVePIxoXdX6zi6whWwDsIPFuGmVZ4HG44Z94AlIwALFK3+7wndMJzsaM57i4UNt+xc1UhXFr7dENJtMFUhXUxipb4gAI6QuK6nnAEUkCu5RTTYWW/mAG/iMf2cw/siYUgR3oyCcyYaUgOI2o9TJ1PSvshzo85UhXo9ouGlIMKaWtUSzyHzWNiKmQStJdiASwseNDwYlFnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pThp25aSgZjCV3oK2DYHuqnuEQLQjBp5Rhnz6cgjz+o=;
 b=l3VerInWHEFFkGTMiuycZ2/EUGaDwJr3XFqFvq96UhOLrj8uu44gecpbOVSxbOI5rfi1ckv4NnFIBZpFAE+nQ6gxgRuGa9/8P3b+m0fM+hlCnCfx66JPptnW8uioghR1LYeVYnRxreBvgoWS2/aZffEL+W6kIT6hcnvqRnejwX9ZHB4FzvnKRqrjs9wZRYH9eQ0YTyMVsTmu162excq1/5ofS7u0ZB+tsz7enFWJ8EKZ70QcOniiZaHGCZ+ayn0WmJyXodCph0wx8tcgJEeky7qqqJJqXub1U7pukPsH6ojvXjARlyXXyTAayLnzpOwSembuRtv64dlihyfXvn0y4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pThp25aSgZjCV3oK2DYHuqnuEQLQjBp5Rhnz6cgjz+o=;
 b=YWjEOVCBaw27RFyqCzw/ySWx5hrFHD8w963inRH0R6LxOhIPys9XTCuE0qgcKy5p+ZRm/Pjs4hn6mc40ednSJGAuflbW9HC0u+ucNyc5SGlbABJFJboQ7AQalblKhJoO+YdsUyHje3HVuHFFyuPM3gmrxgl47CTzfs4uHAPutY/Ef4Rgi3zD0mQFdKi3PRx+yK78hHCytPnyV9UjvIl1dxkNj0IifQ3jSxCZmxnfHrC8SBR1YnUs52OHTsLdv8kF3BriIzcKbWW1EJRNbBiVhF9o+HGZMOFGGYk9SeATZoB+BnSOOgcaPyeuooniIG4LpYz5L3Ys0cIxZrHwVJtmhQ==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by PS1PPF2A261C07C.apcprd06.prod.outlook.com (2603:1096:308::247) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 08:46:09 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 08:46:09 +0000
From: Huan Yang <link@vivo.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Huan Yang <link@vivo.com>,
	Christian Brauner <brauner@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/9] mm/rmap: introduce exit hook
Date: Thu, 24 Jul 2025 16:44:33 +0800
Message-Id: <20250724084441.380404-6-link@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250724084441.380404-1-link@vivo.com>
References: <20250724084441.380404-1-link@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0006.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::16) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|PS1PPF2A261C07C:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f5b13e3-0af5-4121-28c0-08ddca8e8920
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ojMIDQOTIcJ4rxyEQWNQ+SbbhXz02K0Q56SHkPQDaCi5RprqABcCznUhNZNn?=
 =?us-ascii?Q?SxMGyix4H/YmWWoDcuJhusJ1yoctz/BjrIWdhPK3csgeLNt+2RtuF06AXNTV?=
 =?us-ascii?Q?P0HBhitNRc2++vLm9pcAA6c3YiFLdQm8z3ppDNtwIYINsoOj0dMoFSekCafd?=
 =?us-ascii?Q?1FnycQE5lt/GsX1yFxWYzUK6jfiNDk0gh5Z9zPO5Pfbn22xLOQbKBT4pHgNB?=
 =?us-ascii?Q?F6OOQC9M7h6FuOTNSI9+o09j7PcqOdOtAZ8ho80PRn4KGeXOHlGCYyZicoE2?=
 =?us-ascii?Q?B8a4IxcrBjBHPBEWTuH09dAxy6IUHM/vUSBzTv1taW2jOTv/dUc69FakUtcR?=
 =?us-ascii?Q?vNAywiJcOU/dy9j/cdRmm/IdnKDDJxsa9JBnprRUYku0gsK0bgbuDYgOfotC?=
 =?us-ascii?Q?S9fdFmsXNCHFsLzIguhmMPeJ7z+qdkQ+FfJNmBVDy6Z0ZbWVJcu31ZVKcp/i?=
 =?us-ascii?Q?+EjHTaIVZ2juHn5sHjAw5DDXKhAUSQHgUx4GvNYiT5g9BGR9vGYRuN8pfMMM?=
 =?us-ascii?Q?V46azFA5PPbFWWVKETxfe9t6YR/Qd4LMKUJ/ctl+ZOJ2em9zO9LRSFVks4vR?=
 =?us-ascii?Q?hlFZZ3HG4Fr9zc9qIBZGbwSbioVU2lCTcUjYUL9XbcWKDCdjkDkcsEBUpaeZ?=
 =?us-ascii?Q?+Qq7dgmlVNZcov31E4XZze1mLPLmjq4rgJ71lw/84XErEvnLCzj9HWVC4m/W?=
 =?us-ascii?Q?FaNmHUtUhZC/TudoDHWtz6EQUDRsuzd+Qbt9rGkpy7SEFhd9PtoXwP7OvbRR?=
 =?us-ascii?Q?4xDFAneB0KA6T8b/dNnF38NZ++AXiM4pQY897OzEF960YyRDrEq5rC77+iWd?=
 =?us-ascii?Q?AzO9HUod8fjkynnHyImV0zyGE1aIl5GUvbRut2BP2B1usYEUBDxwlMpBnjk7?=
 =?us-ascii?Q?IUwkLfMy2rG/VkMylEWWGFJgwZaGKnvUuNs3TFEu3Pnu3bBW5UFo44C7Khmg?=
 =?us-ascii?Q?Avsd0ttylyrpVB/bRQCbS9nqvtD7Hi82szvNoiPgvgOv+aUeLt4pqBd4qIrd?=
 =?us-ascii?Q?y9WQbp+JUDJCu65Q8B2GxpDrTuEf9tFtJiDl9AkdHa4GF32df9vsBh3Kobrk?=
 =?us-ascii?Q?YkOM96cDNTyFuzFAxAb2zMZaV7NUB3BDWGFa0LIHdh8vE1v7BbCfYzlAU8DD?=
 =?us-ascii?Q?0ou5heibdrYmLJI7s9QDGfJHVDb4HgaJ41DFpub14zgYa4pNHdjWJZujVRBW?=
 =?us-ascii?Q?SEe4erjyQDSxKuioAei7AUHHd1AKlUh0b0q/YtDdGEz4LG/DwrDJSIUZ8DTa?=
 =?us-ascii?Q?kJNrvUckpx+qDkohdXFKduAuYFNbSn0FM7zIxIouhlgNFdCOiSAgyCCvocEl?=
 =?us-ascii?Q?gg8B9uSVKkIKHQj0VUKlwP2lvpgy0wCf32I9ynEqwgVE6YxNBB3iYtV/69rF?=
 =?us-ascii?Q?5TSpAmMChaUSljZ6kglHpW9MmpB+CCv+ow60wd2lae2areA04H0GXTE18Wkw?=
 =?us-ascii?Q?mUc/Tq6cEhYf2qwNfF6Pml3wE5wXK6Bru/6KXz/COa4Z+LZfoeIkqNAobRHi?=
 =?us-ascii?Q?0jGpfNem/X5U0Kc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qTNIvCapuDn+jfuJRnT6nJG61V6arDB/CEVIagGQNi0S+Lu5ZIRYxjkrsbCo?=
 =?us-ascii?Q?mGIdso7fm3mISoGDlImN508rYF9BAeR4IbHskJ+UFFRgayB9ouLQ82bVRvQn?=
 =?us-ascii?Q?jUZ0u3pcljVldG3F8BdspzJriGwVU4ylWXGniwzB0t4cbB87vXrgl59LnMus?=
 =?us-ascii?Q?hsUvPwAD2vkCc7psw+rNU3S/7YaNeTKMl2k8WNRsQrs9nw32xpI0f5HjKD/C?=
 =?us-ascii?Q?FokrChsbzymmR/NVZmOK0pd+xR1YBp47xIH0xVGZZJRqrbF+GvzIDZXeS29x?=
 =?us-ascii?Q?1rQaDKb25/46K9dTtdZ9Ca/SRf/2Tj2w7V3xhvlK0+FKRMySEZSReqLd+btM?=
 =?us-ascii?Q?+frstpLOpWQxXGHKZYE1f+9iwfipNlchWDaEWxPVISzC1gjjQqzKPM504nIY?=
 =?us-ascii?Q?H8Gf22aHbSBCgAKLHrw0v8nJ0OJ66rOVb90MQZPDyaaFC+Zpr80fgIQtWEOz?=
 =?us-ascii?Q?JjK6fe9FiCBPsoIpf/NuVWT6u/pNM0wtmGsfRylYyCP/Sq4MdkhEZ/BqDZqK?=
 =?us-ascii?Q?tILlcUys4e8xuGvQ9tLxXC0lRo8uS9SE7aTP/CbFSQF/P+U14YAieAyOwlyy?=
 =?us-ascii?Q?wk2bVOY98oX//GltJ7Yt85aVqkmAW0JxGM8nd+QfVuCpF/LHDxY118AW+u7s?=
 =?us-ascii?Q?/gQf9Dyl9Pz9kVCfvOzfy2Ffu3wobbByZlCHTdyr1OJ1P5WpSvY/FvXb45Aq?=
 =?us-ascii?Q?1dZ16hjygUg8fwZtmhuuVRDu2GsT3qiHDH6HBJirIrw2eUDxy9sJs4vUs/FK?=
 =?us-ascii?Q?0rPLtsB7BOPK6hoKapCRsu99MiGF2OPlmkcM6yMF5cUwoMlZz7tJs4vhZwZR?=
 =?us-ascii?Q?wbIxVi8xBkioVcWxgK27LdFT8dDDq4SJhlW76j6UEG2pJsGF7jvVfkktoKj2?=
 =?us-ascii?Q?7evP3s57PtlxGE6kLzE1rUIrzRTVQ7qa0vDR5Nowk2qflNfhV0byeaxq4qLE?=
 =?us-ascii?Q?uB1lz9R0Tdh5vJ2qO+AffRadNH3sQwiSk2TVftayxkdV8a9uBs5HIgcv1s+6?=
 =?us-ascii?Q?mEcOMHtr4URAst5HN2C3BBSWUtZYOJWlOYWmSEWktbqPr9glBleGA/HUnWrN?=
 =?us-ascii?Q?fCWHk54YCRnFRgv5uDHL0rnCa5ZlVFzaUmZlVRC/p40sh1Sevkr3l0IA1/b/?=
 =?us-ascii?Q?J0QAgUnyQqMoNngtTKWZ6CNuF6YpNswTiInHm0I1mn0KyKSLx52vH3saJExW?=
 =?us-ascii?Q?SlDWzC+76yCDZn8bnjR/E1XCbUw+jM4jblke2O6/SMPhsP3gYmRRAxXJZwyZ?=
 =?us-ascii?Q?ZRlrkevvlHwYRZ6LxLpEyVwZFRr/Gbe6rkA1P6HeEQxNTA8tCq/xbw6HIHzs?=
 =?us-ascii?Q?ysq5WbGY14RiEmh8ceLlVPNcmxsyfMLDAsS2mPkETj/mO9r0V5OpVTPRvpom?=
 =?us-ascii?Q?t6BKmYV5p2hVkoovJqSY2cytKDSUoOkvaR7DrWjD5OkYnNlVJ0vB9a45fJGY?=
 =?us-ascii?Q?I1Kmj9RH5RtmAwxsXiusa5sGuVoGWU9OkugAwWwQrlZfF96dgIX2LrwT2tEu?=
 =?us-ascii?Q?PRTJ4bqAXUgCENLqJkSDfWUD2N0LqC+l7MyhmRPys+G9+gevKvMScWkjxOE5?=
 =?us-ascii?Q?Far9Mgr1FJL5UlitgktpPzNECSlNK0dilbmM8ft2?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5b13e3-0af5-4121-28c0-08ddca8e8920
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 08:46:09.3323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XfAtwiuz0hQFaL8FCCKTSMd5S/z3OtckY6ZkfMdGH3H4DY0JN1hjSzdP0d2kTSl4MaejMFfyVATEzrlCx6i4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF2A261C07C
X-Rspamd-Queue-Id: 981401C0003
X-Stat-Signature: 3dm869xejgfn7h89ae5nzmux8xrsz5ac
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753346844-66675
X-HE-Meta: U2FsdGVkX18ELCTfil3mB44a9RKGhaCdATiCon5texaUnBkK7ezRFJ1L9c2IEZenAG363GThjBgzxep9/Ww3y/HD5++NjOXJCkAXzn6Vn+i5U4NkcvoI/a6Zf27DNwgIjqe/Ixa7EZ6tGa7o2nFy/cmAzBsezGlID10elu5U7+gDMEZOWN/X5i2/Eg6NO41triED4lcwbh1C+YluJJYAsneCF02gg3GmFoFThGlTHdRuJasRSdSCaV5/HMBEqgXrMP4d93FTftBJ39uimJEjg7scgOYThxBH0WdvsrOJ2hfuR9OUF2Faopar5P0kyCkgtGqy/8+QY6fxUxO+HXDaj/vRyPmxL2OYpx4cvvsDiCPbriPWOmD7p5tgVJUU76DaRTO7syo2BLZBx12UuEcRrFmU3HAoREMSBHcRxZlY3XYFewgYT6dCGJ9II0sgpujxrmFr6IEYBfBo5meQF7P1mEC2ncs+ENy93Kmv4z3lXYk4uEI+hY8XVSaWEU40lOpH7LSpiYqJwSSymmpGbEzhcMvJkzUVaHQEs88R5t8JPtfqUpfZ5ADvqS7ynKajUhmKx+Mi0qMOAFxBBGGBvOWNjWsMmiXhzgXNLi0quTyz+KtgoZYPXr7iReY+N1mXH2ECY5kBvSzb7PWDKCFQDpuVftu7N/j252ujhNYpZ4iDVCNW1OealYxK+RSxBKAM8pgQvHE1/PCIPD8bXifKOhDE0lQGS+H8lntXtpFx2OZDzU5UrNmIYMQ1wJlpKBOpNdD/bcDfyIuARY6cZtOZdIpOKULlaBJWfV4F+GAk0jM7ngBOzdZ82zZ/S9rS9jfcwN6qHPjYsSqAH5ZcYMuFycN487YygpWwdHwVCPCyW1EdARjnvMBczlI84kkPVdzzNQgiATZj9uhPm0ii+VvvwXk6Viej7CG/4v08wzEJImEd3FYQ1jIuTGLbbuglkhnEoE4h7qwC1R+aHs4cMYyAGAs
 +hWujvhV
 Gw74CCXSIKbuYGQyS33QGq8Cvi1YnfB7Ul8Gd0r0isYcxlWF4SWumSx/DyiQ7S1SY98Z97XaTKKg5yy2nfRyCP6UNlXxThtbtKMIY+wdQ8+tSExMmPgSPhTXkJXlaTwS5aQ/ACtNIQ4O/ZRO9c/r1ZrUSojd1wrHwGHvYiCeGXObgrx3PiB+fdsU21EczcywfutDfFS6WX3TfNb4TMB++Z2/u9JBht9VmgEpNLaTgyyFlGXQKWRpeCkLx7VissZQ2NnFtsw45T8kQX0pmHPr+ZE8rVNdFl7unufPZ7wmmy5yLPt/xuXmMrLIpGMrJ4XzDNhV3Wp9pYm0rSwzM9SqNYjHpN0UpHsYrTXWkrkCFd4H4oyRjvvqSa4IQuYoKUZS5GN27c5/8nY3HzVnHdRCaU4/Nyh88jxvVowlsCjvLabI3ZhfBq/gXNagPhHub3pJxwPIh/NcX5rRv30p8ab6wB4wVS8qFo+nhdUUmy5nFrGNDnqQnnzBDSnMrxUj2zwwz79Y1TX0JI5scDxpUD925OigYQNoB9Z6h3uOvYpqpC1u6ss4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When approaching the end of an rmap_walk traversal, we may need to
perform some resource statistics or cleanup work, and these operations
need to be done under lock.

This patch adds a new exit hook to rmap_walk_control.

Note that currently, the exit hook only be used in the anon and file
rmap_walk implementations, as ksm no need it.

Signed-off-by: Huan Yang <link@vivo.com>
---
 include/linux/rmap.h | 2 ++
 mm/rmap.c            | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index a305811d6310..594dc4df3bfb 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -999,6 +999,7 @@ void remove_migration_ptes(struct folio *src, struct folio *dst, int flags);
  * locked: already locked before invoke rmap_walk
  * rmap_one: executed on each vma where page is mapped
  * done: for checking traversing termination condition
+ * exit: do some clean work below lock before leave rmap_walk
  * anon_lock: for getting anon_lock by optimized way rather than default
  * invalid_vma: for skipping uninterested vma
  */
@@ -1014,6 +1015,7 @@ struct rmap_walk_control {
 	bool (*rmap_one)(struct folio *folio, struct vm_area_struct *vma,
 					unsigned long addr, void *arg);
 	int (*done)(struct folio *folio, struct rmap_walk_control *rwc);
+	void (*exit)(struct folio *folio, struct rmap_walk_control *rwc);
 	struct anon_vma *(*anon_lock)(const struct folio *folio,
 				      struct rmap_walk_control *rwc);
 	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
diff --git a/mm/rmap.c b/mm/rmap.c
index e590f4071eca..66b48ab192f5 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2832,6 +2832,9 @@ static void rmap_walk_anon(struct folio *folio, struct rmap_walk_control *rwc)
 			break;
 	}
 
+	if (rwc->exit)
+		rwc->exit(folio, rwc);
+
 	if (!locked)
 		anon_vma_unlock_read(anon_vma);
 }
@@ -2895,6 +2898,9 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
 			goto done;
 	}
 done:
+	if (rwc->exit)
+		rwc->exit(folio, rwc);
+
 	if (!locked)
 		i_mmap_unlock_read(mapping);
 }
-- 
2.34.1


