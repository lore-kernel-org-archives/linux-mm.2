Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BC8CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8938E0144; Tue, 12 Aug 2025 09:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987A08E00E5; Tue, 12 Aug 2025 09:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802488E0144; Tue, 12 Aug 2025 09:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 683558E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:52:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0688D569FF
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:52:45 +0000 (UTC)
X-FDA: 83768245890.26.A4A5D5C
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013063.outbound.protection.outlook.com [52.101.127.63])
	by imf18.hostedemail.com (Postfix) with ESMTP id 229471C0004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:52:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b="e/yThS/D";
	spf=pass (imf18.hostedemail.com: domain of rongqianfeng@vivo.com designates 52.101.127.63 as permitted sender) smtp.mailfrom=rongqianfeng@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755006762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HgCQjcT2Yqv39FyKq1iW76KodWhfCvAwxafNxQkjG+4=;
	b=Ujym+PPSgyCOK+0uc5RYy/U1XSjMVTxeTsxblHm+VTUm7zcf6DGp8aCJ1hc0ojOEE/+Lb8
	3OzaPWKPqTLFVwIDNb50SBTgPh6BblxLIGTCLmdWyGjxzBuy5iSzazfuaNPEY3ylHlN0hx
	jZF7h3xW2DXAv4H+k4kk1qzmJGp6DjI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b="e/yThS/D";
	spf=pass (imf18.hostedemail.com: domain of rongqianfeng@vivo.com designates 52.101.127.63 as permitted sender) smtp.mailfrom=rongqianfeng@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755006762; a=rsa-sha256;
	cv=pass;
	b=M9sthlVDl6h9SCej7YMx0w1269wh7AW0UCa+X1uTd+VXiJSg7qiLl1/0W+3rH0xIsEGqtq
	EeP+A2XjW4Ftr2FY/Avuz4RSO9Td89qFM+rUl6F9r7Q5PTygqeT3wZJhDDw23ESOswJdnG
	UuTDJ/cbc4by0GqEJMJ7SD0+KRq6VZY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssSv4yfWzqk6giy5jEK7sDHL8TIv1BpDBuRUf7XEcy88ZJzlekcLYN1P6EfxvcwwspfZE6S6NYb82BXsEqEIoNr7DjMJCxYBJFLmE9W2qYYm0f1CXiXcj2KJuCOZs9HnvOZmO/Uyqm1fBn/+F8fEbaoMGyilPokD6+sN4i70K2SkhSms0OwNRKPBbZ6jKtgj4VhukDV5K8LDFjgDenZXaOkJyBoxJPO4PC79hXkzTl/FROEMpwa0Lhj8fh5VrOO3OaMUFwDr9/RZIqQ1QRwhqwxmVOmWz3cxJ2gWGjZbcmViRG+KXHXgLzwI+eSbLWQVTuvMHivFEJFTVt8nmbSzwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgCQjcT2Yqv39FyKq1iW76KodWhfCvAwxafNxQkjG+4=;
 b=hLKI87OBA1EmiNKtRwys27oBBU2fmrO2GWHFAX4kiboqKZIKzGqWDJEEx2RwvS+PQUWxvLcm8Q1rDwQt4g8Wyt5+dxxoNcguZqQsZdFjG8IfxevTE2sadVFahvYBc63A5ExXKI/f87OFPWsqzk4ppupgr47METbOGKU4wKW9IpRRbGrgRm+PMv4FW8sCrVFOs8/4aIRgQ9vd8AovzHcYFxmoYpJwK1EpNxjK7yn1ybIVxt4lrKKXMjlVDzV/f1CtjN94Ujppj3EbpB34BLMOr9k7ygi/SOf86oWffqmaxwR80dSIDT0Igq7I3Ky9xmWleLjwEUU6swJ3n0uIjbPkoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgCQjcT2Yqv39FyKq1iW76KodWhfCvAwxafNxQkjG+4=;
 b=e/yThS/D/P7lhM92suSJF+cEWYN1f+m3uYAet3JLyIHSl47FkOw31UbpoEYSrE6JGW4UFs5qrS02rGPWOkRk+4VKiKfD2XyRSGN0+lsgTbfZnkr5ReBF9sBeiWOE21rziIvc9kCF+4Oj8s5j8UTAZhG/h1ufuBCEiVNFZNkAdF5Ifqq1XyYHE8/Xbr6m1I1NwQRK0VJe+cfKn7WjLjV9Nuk6I+BFgwN1+BY8YobvwVI8WwIavnT/7Ny3cr57keWCRgFjmEjt90vOa0XaCon8OU5GiC5qTgpHPvmTE1veuRQf0tDA0Q72pHqrjeHPuH3fHZFisq0WRBdtxotF8okJdg==
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 JH0PR06MB6680.apcprd06.prod.outlook.com (2603:1096:990:2f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.22; Tue, 12 Aug 2025 13:52:36 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 13:52:36 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH v2] mm: remove redundant __GFP_NOWARN
Date: Tue, 12 Aug 2025 21:52:25 +0800
Message-Id: <20250812135225.274316-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|JH0PR06MB6680:EE_
X-MS-Office365-Filtering-Correlation-Id: 96ee5162-bd4c-4551-7503-08ddd9a77ea3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Evz80ZuX0iBjmC6GGv+wUrEfijVLp+gUUrRraV5kHy2ufOxqzdI10n3qBKHd?=
 =?us-ascii?Q?hMUQkLDQzld5jO70vl4gFHwB/Vwg/rKxaQUXyDba0Dud5QGz+kY0wr9oQYxk?=
 =?us-ascii?Q?vmf7iFGJUyirtbuVd0P6SwIG2dkRDBgkQhGwhvE+e8JeK9ptJkRL0bitxKkH?=
 =?us-ascii?Q?QgyRItcCm77KdKbdidv/RclzLXy88x0dDqghMsYPHfdNNpSk4Wk8UhfUXXUj?=
 =?us-ascii?Q?N32ZG1rtl7FC6WWt8EbLObO/gDDEYiDIueotTv2XYS8aANpovOZvSMNfuxHC?=
 =?us-ascii?Q?7rxXDIYqNHic0c5S0tLi0gR9t6Y/OZ1x5bxzudWVvxIMweY7joKZ585sOMFq?=
 =?us-ascii?Q?VVFxr2QwzCDlcL7Bs2XyUKUbQKl5EONqCq3kK7+9MUJahyR3wkQLW3E5AJ/I?=
 =?us-ascii?Q?MT1fp1gSnXeTUMKhlISgWWebP8uUpN0oHlxNr+cg8SirT1KmcGs+YwRhEXSR?=
 =?us-ascii?Q?QTDaDhOmRYDbP/LI/DqpDvCpS+izx1YPiU4h42hQr90s40jbX8ddmfGvgBW+?=
 =?us-ascii?Q?N4tbHfpS5peHk3Or/zDnRDQUHSV8FTsxWWW9OA5xUgiYXJFegutYOUWWpf0C?=
 =?us-ascii?Q?Sl4SbgspGj89pTmWh8fH+KC6QBth0CJ57bNyRU0k6R1WBc90yrwRhTe0FIid?=
 =?us-ascii?Q?DsUZE3AFR+AM3VowNTYuDXAHR6hJvF2YN53VAzOl7gvY3xBmvAgeHUdqck5+?=
 =?us-ascii?Q?tQflg9sYfc4f2JaaN2OTDPSBxgWL5i2R+yhvFCe1q+rUz9TDdUzqnxTdbHIw?=
 =?us-ascii?Q?EQOCtIt9ZiTZ++MNquhpo9gL9XG+KurrkK541jM9IDyI35d534AWsk5YRfeJ?=
 =?us-ascii?Q?zkpl657B7fTFmm0s4YC7st3Xff79Bz0nkDZxYfg4q/GxJyk5/MchskekcamJ?=
 =?us-ascii?Q?xGQKNWkxxLcZ29z65S2D5pj9GGxgUuyEG6aGbKRT3TVnGG/NIG42FM6Z52dP?=
 =?us-ascii?Q?q2ViyuaiXWpMqcaE/rHeeepob0J1FNNMt4yFMF3Ue4RPz48XqfiHgzNxkuYX?=
 =?us-ascii?Q?r9KZ+lVvs4xFkWv+9cT/+riTZgmM7hVAcftPHxtUKxK/lFNxeTaVZaEx9e8Y?=
 =?us-ascii?Q?uNdewxyvl0mxEmnTjSyuMUxbKumB9rQAlD7O7YqfvoUHtnlogW7pw/bqOv0V?=
 =?us-ascii?Q?i250T3DxQ1sUFgaIyEZZD/oCX7DguLyPfniMzOdlh/RmM7EGXQwLU5l1JheL?=
 =?us-ascii?Q?o1n3VhtgzudYIzOyFnCfOb3zgEHsGRNn/4atSLHo5Oz61Sk+S+5kn1iCJqpK?=
 =?us-ascii?Q?yD2LgpcoWjtBxK6WkZmvRhgPObZ4Po+dDyaNt4rRO5Sij7NbbRrLzVsU0hck?=
 =?us-ascii?Q?Nwe69y0VvpLVqlALKOLscewx5R4An5+RU/1TbZwPrsIOyRfTztfHnUQ92vO6?=
 =?us-ascii?Q?zQX9tkpgk60uBwEfw9G2RYB4D9xuSXtq8qw0lYZPV8q2qY3tLpvV63wa5UKi?=
 =?us-ascii?Q?nnNVRFClA36zfUe1B7t8PfGotv24ceX8dhWwipF6c5v/vf4jqru8e6nOAYyC?=
 =?us-ascii?Q?SKTQuL5WdkpBJ9g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jVs0Lw0US2vAQmrseEwXMOj3wa64jM9YktL4/80o6jwmg+tZaS4tfVM7rmEs?=
 =?us-ascii?Q?/SAXa8Y5HH4jvMFpju/7z8Cf3+s8wAF/enA5VNJ+SYJw7WILvv2EoVNV1X+X?=
 =?us-ascii?Q?Lv9h5Bsi0w9FiYA/dM1qPNvmDpmGJThDPBpG3e0JUeJUpagBHW+zdUUeedYu?=
 =?us-ascii?Q?J4OTayQT6/Xq8UpDxa5Ak/mUP2hqhPEW27xu2LKIPUWI2eu6xJvJoxrsIJEf?=
 =?us-ascii?Q?oalTBlnK0ZLM4tkde+dMyCWI55tUcbbujGx9PCtdsbyiQjm8iLHqf/6z98h9?=
 =?us-ascii?Q?um9fRBI2B0ct2rlrzlXk0Rizbz3Ca2ldAbmDBq+EnToyHzlGpMm/3VfC8Y3G?=
 =?us-ascii?Q?uEAY2mR9KVnveOi2NnlR0dXOnhu3EVXu9cB14PVXASruKAsXTfvS2TVxErGu?=
 =?us-ascii?Q?yxzdtMIZB9S+xi/glcXfYKQj4hB4dVSXtr6J03jOsVMyJxn2yLcXT3BL7/jN?=
 =?us-ascii?Q?kdMInBPRMKyoigGR1PboyYu0BkHzEtB7vaPL9H4qBfCHZC5OSCpQIsLG7pFY?=
 =?us-ascii?Q?mxiwaHxBPpte2UW+hoRq0nVfM4Vw+8KO0Mx21Y09d2WF9FwJJNqw/LqfzjOY?=
 =?us-ascii?Q?+mCiE+l4KZSfziBp5m4aakatKs3jO8mRRm4923MSc/QqCp/FITsQRcRL5aVP?=
 =?us-ascii?Q?ych934oHt5Zd6FBvsQLn864aB6TW2J4k6DzCUW43SAFsKJZEL12dmh0fn/et?=
 =?us-ascii?Q?WVWB6gK/5kKeFBN46is0hAthrhWVFVMzUkd9WvG/D9vSRgy4rsQdb1PJ4eMd?=
 =?us-ascii?Q?hVlZPemoSthMrlbLH+136oT9ICHo3iNQkzkd/JFTSykPWo6j6WSgNwbD4+aA?=
 =?us-ascii?Q?jNbzsJeSAr7r/FDzW54PdDhqIv/NKIujXQlzE2ne702dTBgnHh4UMxmHfYER?=
 =?us-ascii?Q?NDyYjk3Cpd2jpBiMVClOj7mUYGONvEb6trEGmEjJtwcNAEqh61GepfWTHer1?=
 =?us-ascii?Q?4hRX5HvZ8x5nhquNITsAuHHpCRqgYVY0LfFwM5jvi2IBN3vHP75Fcpskz0gT?=
 =?us-ascii?Q?2eSg7Tg65NgKP0iEOdprRI9IYQTb8ktAvJA6g5inIyLgHhbd02CE6rLXR645?=
 =?us-ascii?Q?ivXs+SDV257tsvk/5FoHDULbdLolRwdA8iU3shkDbe+ysz4WyLLce6tkw861?=
 =?us-ascii?Q?asbeU8NaXGS6eRqqUyDh6phqeaNndV++Jr9A+ur/LuVT6EI856dpVVLYV3lq?=
 =?us-ascii?Q?nMHvP6D0G91glj0jl1pDC4QvTXDMrcp2sTqlzM9zFjjBTSgCd8sr4lnqrctt?=
 =?us-ascii?Q?KWSgioAV/8hOXm6QACPuJeif2uMdrx+q4wQeY3v3Ssz2xCM41fOX05gUoOo+?=
 =?us-ascii?Q?Xvvxys6BuCcroBGm7LbJ0WbD6KLWlz+8iGYCHjj+4EyKKKB8jE9cB9Ys1XOL?=
 =?us-ascii?Q?Wui1Qq8IAsK4vqhsGmijUfgvnR6elcaNpyuVOtQS2klqh50mjveRg0/87CQE?=
 =?us-ascii?Q?aHViUqup5e2VXpIYvQclMkNRCi1OezT8MhlxvCZkpZp04cPhkNfpwD65b7p2?=
 =?us-ascii?Q?VO9A+mQzK99/K2cBuvCTY4OVbRkh7m+UsyasWttNRKOJRB/VhD/hc5RzWTqy?=
 =?us-ascii?Q?NBtIy3jBCW6TbFhrdeEx8c54oLk5OhS49W7Wf4XW?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ee5162-bd4c-4551-7503-08ddd9a77ea3
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 13:52:36.5982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H7hSz26uR6Cc4HEoCgthj1UbK225+N5MOVpRPNgGUpPjL3LwNAbj+ZRQ0RksRfIHzS9PHD4quBLGJRFAwBgx6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6680
X-Rspamd-Queue-Id: 229471C0004
X-Rspam-User: 
X-Stat-Signature: gq7ufd19qg91i7j1rj6pq3aug3z5kt6u
X-Rspamd-Server: rspam09
X-HE-Tag: 1755006761-551116
X-HE-Meta: U2FsdGVkX19OuyVMFISGn13+yiQwFozEsjp5iuBHYpnz6WjabCDnaXntuWhBfY4hj6ZkhsealR8zMNaSzLKsSXfOJh0Uw6A6s4xCgxFj4qEgHL9q5/v8x0f8dkW46nEBEwkpRCA6canT4FgvcHVsnVrPLe1IOkBVJW4SaW1TeeJ2wBSPlNEU/IHEA3Jfquxet5KYPjUK3osoi2o1gg+2L9+TgmEk3tHxXYvmik+LHW3n0mdoYvMqWc7kQqf5mPm4fUY6AY/Vl86S++sji6rgXSU/nE9NbUaR+GKgF0w6fZ/vFQbkAx6VAmqwzvxbJv0dWe/U4b54YRsc/gjMQzbhcvHy3MQjhx6o4S721VC80TzTm0gx5raBuTJFcANT7OqOqj5sgc0oxMoB3cewSEHJIKM+yO+swUSdbjgMqJgkWf75NLPh7++L/5l6TqqtxmSHy29kdMNzq55BoBjhzl4ffbkRxQrjJCUbqwIbq5beeYz1hk3gdBKElTeSiqcm3DRvCl8XV7ht0LDOMiZbqnE3vq12t73wVkRcE/yKDmPYoab61Gu2wLedddwFfI2Ts3oj/VX2VPI4IFQwvNuf291yTpreUfQ+Fa20ybquVkn+fWCG5AMvrxXCw8sqQhJRJCrDNQZLneCdO8STrHCG9RO4UimbsGpRU0BR5DImrv+X9haFhunOoHwQFy7EkwhMcLO3XoQkZFCGx2UooayvGDgZRrzaWb16V9gFl52n91eL+8zSiiWVP3Fcv83ZhQy6vrL/17w+Dq2U6tSNolR3RkDqPF8v5CHTdbw+N+ymPAe19Nxhkjsn0ugKzOw5IJQTM84fXhKfGoyM2C++H6v/OKwF6GnOT5MQ87b8FuhEVbPqGmkKlyLMAQkmqhggNC3C4wVw9PNwDv8M3DhuGWcoBYE2WY5H1Jh2o+0D/w4irSQbNIGHVqUUNlRWeHmOjI3zBTui36S050Dy2MntRPIAWu+
 J6Yv21iF
 c4t4sfXanbvIukLB3UhNeVb/Mkc6kLODq6bPWoBKCr2oIJAAY5/fLPfAs/NiVLT5DmPDcppeb1cGZXGV90wjhrpHSpqSfrcJ8dTCxEN6QYnZb4LTN/doj/17WUO8/U9OJwvNuBwcs8gOQ4ZaUd3u5gVIKfvR9tHBfTthyVq7dYb2VElWpODeMEXOOEIJYvdEuC1jjAkXwk0d3X1RTlX4AqYw+Jqllw6fAP3i+l7OXQWFb0fU+zqMsTPBNvNhkDXVtgt8ViegowOvDsSDyY2LYeJoVtQZ+Dyu/GzKLjwKzpqlkBPlempZy+cUt+b1tBtAVnzGqom73Ch25MeYgXKuGTNr2uBecdfv2bzJo969OakCpYrtV4Er1QuSyBlYgYBYPIxXhJiTtT7Xv1evVZYJEFZcrrZW7MoivQTVfXmvRYcyX+u6ng2+MApdKUu5jMP/lZhLisTY/nnVk5BHFA/J07ICAb0geP3Cq5FLIdJWDPV4LUwGz54J69IxxB/XovKIvfMHTS8QsmE8Ilfiy41vFj3+hBKsKAYrZ/TyUwABtMXy1U8OHACwXWhwR90XUH1hMeVl+0ZfH6yqsD8c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

No functional changes.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
v1->v2:
- Added a modification to remove redundant __GFP_NOWARN in
  mm/damon/ops-common.c
---
 mm/damon/ops-common.c | 2 +-
 mm/filemap.c          | 2 +-
 mm/mmu_gather.c       | 4 ++--
 mm/rmap.c             | 2 +-
 mm/vmalloc.c          | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 99321ff5cb92..b43595730f08 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -303,7 +303,7 @@ static unsigned int __damon_migrate_folio_list(
 		 * instead of migrated.
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
-			__GFP_NOWARN | __GFP_NOMEMALLOC | GFP_NOWAIT,
+			__GFP_NOMEMALLOC | GFP_NOWAIT,
 		.nid = target_nid,
 	};
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e5c9544fee4..c21e98657e0b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1961,7 +1961,7 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 			gfp &= ~__GFP_FS;
 		if (fgp_flags & FGP_NOWAIT) {
 			gfp &= ~GFP_KERNEL;
-			gfp |= GFP_NOWAIT | __GFP_NOWARN;
+			gfp |= GFP_NOWAIT;
 		}
 		if (WARN_ON_ONCE(!(fgp_flags & (FGP_LOCK | FGP_FOR_MMAP))))
 			fgp_flags |= FGP_LOCK;
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index b49cc6385f1f..374aa6f021c6 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -32,7 +32,7 @@ static bool tlb_next_batch(struct mmu_gather *tlb)
 	if (tlb->batch_count == MAX_GATHER_BATCH_COUNT)
 		return false;
 
-	batch = (void *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
+	batch = (void *)__get_free_page(GFP_NOWAIT);
 	if (!batch)
 		return false;
 
@@ -364,7 +364,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
 	struct mmu_table_batch **batch = &tlb->batch;
 
 	if (*batch == NULL) {
-		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
+		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
 		if (*batch == NULL) {
 			tlb_table_invalidate(tlb);
 			tlb_remove_table_one(table);
diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..7baa7385e1ce 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -285,7 +285,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
-		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
+		avc = anon_vma_chain_alloc(GFP_NOWAIT);
 		if (unlikely(!avc)) {
 			unlock_anon_vma_root(root);
 			root = NULL;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6dbcdceecae1..90c3de1a0417 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5177,7 +5177,7 @@ static void vmap_init_nodes(void)
 	int n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
 
 	if (n > 1) {
-		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT | __GFP_NOWARN);
+		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT);
 		if (vn) {
 			/* Node partition is 16 pages. */
 			vmap_zone_size = (1 << 4) * PAGE_SIZE;
-- 
2.34.1


