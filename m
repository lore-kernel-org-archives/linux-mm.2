Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13F3ACD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 20:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618656B008A; Thu, 21 May 2026 16:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7C16B008C; Thu, 21 May 2026 16:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8046B0092; Thu, 21 May 2026 16:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6D16B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:21:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE1F2C260B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:21:10 +0000 (UTC)
X-FDA: 84792546300.05.C77D876
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020113.outbound.protection.outlook.com [52.101.84.113])
	by imf18.hostedemail.com (Postfix) with ESMTP id A72B61C000E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:21:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=lnueduua.onmicrosoft.com header.s=selector2-lnueduua-onmicrosoft-com header.b=ILZCcrFj;
	spf=pass (imf18.hostedemail.com: domain of Maksym.Shcherba@lnu.edu.ua designates 52.101.84.113 as permitted sender) smtp.mailfrom=Maksym.Shcherba@lnu.edu.ua;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=lnu.edu.ua
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779394868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=roitmayFMFvcelhRomSWSEmbQVSW2KADKYR8+HT74NU=;
	b=SaP+BfiSv1HWwFNob2n37lrVJ92yS9HHnLpeKm+inILEe8VNS26W/yUtLnjNtYbo0+ghzf
	BQrz0ItisAOcW0Jw6l5ZSk5JG+IIgwrLuiO2B/jObcyQVdVrx0rBOB61G5S9WBgHp5uJqj
	x/jzaZ76S70i/l+kw8qi82MxAw5K5Yk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=lnueduua.onmicrosoft.com header.s=selector2-lnueduua-onmicrosoft-com header.b=ILZCcrFj;
	spf=pass (imf18.hostedemail.com: domain of Maksym.Shcherba@lnu.edu.ua designates 52.101.84.113 as permitted sender) smtp.mailfrom=Maksym.Shcherba@lnu.edu.ua;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=lnu.edu.ua
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779394868; a=rsa-sha256;
	cv=fail;
	b=HPGcov1DYsEoWsbFzoPdSXHUycqPSHJLi3EzorLVqYsnIUg+noZLpai/Dw28mxsOv5HvjX
	HO4/aeWM/ReiWhBEhl2Li20UlMPHYYFC8x36WhxB7pBUlcwBZ1ZPCoXTgp86TJbr1uYqqI
	LBnDtcM4V2S34Wefefhp9RxH3hO3yhc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TExmh9L5tm3Yar+OgLUlyvclx9YOvXMyoK64OFEwiSiBufGIy3YyNIHJ7dddSswoo7SFqDFKg/DrJVNzPPgLoG8Te56qXCRhec3x8fJh0eRZLBvefht3o5AuhEhbHHrtWWaiCp9jTA2xhCKwDyfqZvay9OnMaRP+4acMbgQcGdd5LOE5d4f4MahhBJLXQXs6w01Dnzh7EtrxuA2HGiYSfopiuH3qMJLw/BMmovrwq4daYquuybj6oDMBkObUAGluufKxMB2yThID4//naN6Cg6SkieA5VMB4XRW0nqO39eq2tB+cQvyqlWXQUYlPFDcLxl+hDdzDYnv9SZNRRqUICg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roitmayFMFvcelhRomSWSEmbQVSW2KADKYR8+HT74NU=;
 b=AtbcSSuZ30hpme4W4edxopAPX7V738TGaVq1kCKIsnL77L+9kxqYhgOL5aObG1fUsYLAZ+aV4QGlpcrsOk7VZa705tD62qN2pkK17Sx7K5fQtwQ1XrrbSn5szFCyYtNKBDZ1tILrb91mAjg0Lu8vW98MkwzQ4EyHKuaY6N7S1bD9OA1A88UTU+iBRxvQLsua2OmU6tV5En5GxHwCZ5htcfJJj6DYi3yu2co+1pDIL0iPuabd0LYPxdFTRqhNJX28YWrolNMY5YivOn7WD7p2F6d7FA8cl6UYFOok00mNPp5mEpkdDVASJirrpKiCvEQGlenVZ5N7PDF86WDqGdJczw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lnu.edu.ua; dmarc=pass action=none header.from=lnu.edu.ua;
 dkim=pass header.d=lnu.edu.ua; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=lnueduua.onmicrosoft.com; s=selector2-lnueduua-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roitmayFMFvcelhRomSWSEmbQVSW2KADKYR8+HT74NU=;
 b=ILZCcrFj/5M93PBDyNKgCOCzqLii4P7qgMpiou4ekyNEuf3mx7jxbODraE0eDf6uyjCajKEDInAo9yoIOaJIF+uCZXAqGZ4RAogsmJ+ZYrRoJnq1QdKmXs8INEvyn7xnVKehEEnyn+SndKPbbC8ycCbD/W6MHZKDLH4dqC4WJ1M=
Received: from VI0P190MB2524.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:2ca::9)
 by VI1P190MB0655.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 20:21:02 +0000
Received: from VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 ([fe80::b775:39dc:b909:e5d0]) by VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 ([fe80::b775:39dc:b909:e5d0%5]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 20:21:02 +0000
From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: SeongJae Park <sj@kernel.org>
Cc: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] mm/damon: fix macro arguments and clarify quota goals doc
Date: Thu, 21 May 2026 23:20:18 +0300
Message-Id: <20260521202020.126500-1-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: WA2P291CA0021.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::29) To VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:2ca::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI0P190MB2524:EE_|VI1P190MB0655:EE_
X-MS-Office365-Filtering-Correlation-Id: cf3a56d8-40f1-40d2-8792-08deb776799e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|786006|19092799006|7416014|376014|52116014|56012099003|18002099003|38350700014|11063799006;
X-Microsoft-Antispam-Message-Info:
	cx5oOkNu2eeSnY8Gj9g6TGiYFkcT6wuP4ieidllK+PTA76SEd8ILLZNydRqmKTyLL3hjhmgh5dNDjIzdo4YOeimQjGnsskWFGlnlisAhxSzoVjoWw1WW9e+dSsL52uYSuZAtMz9wsDrQ1Pq1KOOvwuiK0ObIpoO6KMRU5ZTeM+sAIPJXfEe53CS4n/XNYT9HLV91apYBfReL9UUj0YLDLPv5dRy3BqBzSM+qdVf/y5DcgP5eJz0R0wDQbT/YwKqqlglGM6BkFbJNJepxgHhsXvmJh/tnYNZe6iyGpFEwu87XEpPJDgTVkQJze2fFPGj5a9ViYELqBWs5x/evtLqAzk8/0EIfPwFzbcq405z7JWd56pliEJhl3vwLTELc4eaVPg9vgmqOk+yMHwYrxU2yyvtgBqiIEckfYJu8a5P2rTkB0W5A1SxiihvHVF5aErvHyor1/NU4/fnUyefLzZvHremeNYAvWz63QT4/drlZCnCoJsLSpuadhWjVTs2a4a6QVtqOQsaxO0X6CeTEfrkmqiiFoywOt8MGdGoR+y+pw30Em1mYs23oCLOnk1AOgnf+fq2Ys9r2Qrsz0gtmUMqvs+X+9WE5qMRwmx+s7z7a8ammAHNZVjhe618EicSgLHIUO4FhXoEEatUSbL/Spwco+gMislspTH33yyuQL0J5woHIGEfjFlLsnimtCh7YSnv+zGsS85ESIILMKr2+JSK9dfCP/k6Q4mIyw3fT+vbFLrraJop5kQAbrXGqpjssJ0Yv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI0P190MB2524.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(786006)(19092799006)(7416014)(376014)(52116014)(56012099003)(18002099003)(38350700014)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uXdRmYYVdkoDEbnTJDEjfTVIsOf5wZ8+gouMoRIbxQElg2Ph4OyqS9g51PTk?=
 =?us-ascii?Q?U8MzlBRmMBLhb4wTq9F9rOoC+uvC6vx/MuIjqjye86DdlwcIDyEIkVz5+7np?=
 =?us-ascii?Q?4cCsukSynPZvW825ii41RhR3KCvl6FXomSid7pZcmXKAfqQNiAgAP7IxFJ9s?=
 =?us-ascii?Q?Il3CrbwJJJ/mHSwceHg2+0C9YqNLCBOduCtAiHqjkgYmYSUkIrgioVS1+wrI?=
 =?us-ascii?Q?rUTAPthyim+yKkKiNfl/MVxX1FHbS8zsDiI3m5+fdpOXiicRjyRqMNn6e7ig?=
 =?us-ascii?Q?S29xJApbnXwEG6iquDyZLF2uHuL9W+S7/G3nZJPPY7Ft3djcldzX6UKi6FHE?=
 =?us-ascii?Q?t2LOfEp/4InYMPMJ3s/BYSOwe2x5SBgoti/FnIwkifL0+HKdIYytm83EU0kN?=
 =?us-ascii?Q?z9E1bf9bXJ6PxsnE5TeOqNuQndJiQ+Wf/b3mZI4XIlJPynpNwUJdp5G0K0/n?=
 =?us-ascii?Q?8akJNOGEBtApT/n/93RVU3V4H/SzpN74I9G5ZgX6nDVYz1CWYKj5rmsy3kb+?=
 =?us-ascii?Q?dn2Rz7n1bA4JR4f1bTHX7U/XoLhSSYg42mzaZE28lVYt+zD5rHXlenY9CGOd?=
 =?us-ascii?Q?3aEQ00afzijXu3iffduCF16GL4IgKaxYTHZgfDrlXD51vdRcU9HqNCHZURfa?=
 =?us-ascii?Q?KJglAMq52jO3Zywpt0SfbjtaiZnH6bYkUlwLJbchL9IYwwNsePTxEYCZr6Gw?=
 =?us-ascii?Q?Pjn3saZCRnpV/+p7ufRK1QMLIMvVGb7LDwQQ7VxQCqMkBlaWi7R8GO5kAHqa?=
 =?us-ascii?Q?arMLMLf0UYUoFE9AsmGtX0BJhpVQ7jKXNSRlb2Oh6xWqzol/F36quDD7PeZs?=
 =?us-ascii?Q?TYb8uS1HOc+5MBQUKdcOETWs/IcJ/Pgj6dTvEnIvBnfjNnuchawUGqU+2uD0?=
 =?us-ascii?Q?b/6v4DlaBTUqr3xxLuofExApPynmjJU2Qf4aJSf4nIXNlxb2jzEo+GOFdIGa?=
 =?us-ascii?Q?ZmeDhEPjUIXLishwTYW/fEuuwvMyIiU70dm35qNvSca1bN2v10Lpb7EwoHyb?=
 =?us-ascii?Q?Vh3bF98mOH5uiFzUZTSVI6II24m1xqNsuzCucxOd+S0A4/Ae7zwI1vylt0E4?=
 =?us-ascii?Q?tQkKdaXi/WiYHBTdTWoKWYHfmiJKuxqt9AdTPhxMZCYgmfO3wjgzWWElFxjM?=
 =?us-ascii?Q?K+C6ndCJ8iDOIvkiIYe5gBwOjo1Uy74z/fdOYDwykSB7+qzGcpYgaqYFU/Ar?=
 =?us-ascii?Q?K7zgIqTGxRarAIFMD5qMNqLNUps0QNvt43E8k9HnE0CCs4bEtibBJARUlMB9?=
 =?us-ascii?Q?ArGe4QLuZf+bfQ8/l+yg5dBzka2D71YVQXuaDN1FkQRLAsERxEXltERw4tF5?=
 =?us-ascii?Q?GJBvmlVESDOF00x+rkPQP4OPElf890cfEFZwN8oGlIDKXPt0qtBwKKcwo8Hv?=
 =?us-ascii?Q?QjVm/qMayIXPW/86mcOO4VBwwh40x9ZLmHqtaxlRWlZME+3rJW92/ote05ZA?=
 =?us-ascii?Q?bSRJw3+RiHCRofoxaPUeppnvsTufeNBm5XR7eBlRI8o6hQQO8psmL4WLUC1k?=
 =?us-ascii?Q?TXPzpbWTHtNym6asLzvbMi17YfQKd/MmlJN1OMBiSiwykAbIjtOSyfwN3Jcs?=
 =?us-ascii?Q?MM3l7tAhi+aLywXGswNkRziKq7xY6YWScNTVu238MB20hD/ULG6b7/jYyDZY?=
 =?us-ascii?Q?QMXyqFVvOziTQLlDVXjB5TwAzS+dbzjX4dybrYShsQf/fqtL0GGJQQBibAKd?=
 =?us-ascii?Q?GsrQISLSdQtsF7KzH7lnhEsHXwfKnjKetszEAhBgYiH7DVwH0/DIz7AXw9K8?=
 =?us-ascii?Q?NRBi2wFjnJTAZThsLuIsIX6TYV5ZPQE=3D?=
X-OriginatorOrg: lnu.edu.ua
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3a56d8-40f1-40d2-8792-08deb776799e
X-MS-Exchange-CrossTenant-AuthSource: VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 20:21:02.2611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70a28522-969b-451f-bdb2-abfea3aaa5bf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppWqNh2swyV4w7wx1R4ifvoGB6sXYf2qJzyyjpkI9ZUCsnNietuy4R7zWvSjav72BKCFf9bZAVJX5d3NX9Nb9Yto/K0iwGzPmWQCrXqW6JI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0655
X-Stat-Signature: 3fr6rppxdb18rgn3au94wxohwknwszqs
X-Rspamd-Queue-Id: A72B61C000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779394867-605214
X-HE-Meta: U2FsdGVkX1+N7MEoZa88+iJvlkP3MGWXC37+9hY13A3cJV7PpaFuP2JfK8/HtK1tO4na5o9mzOC0IjC+dfMMuJzGJ6UeufHFSvGkX7txGObb80OFNBOZT36iMAlBl+PQuAQPPCZ306M5BDk1z9K75ILhVBB0yLuSSZavZwcSzKymGo7gr/rX0xragr7iDiv9M+6pnRdeccTFJMjXw/KGA5yOnUzyAkSTBbyhg1HNmpiVHdp1B1/B4ZiAWKQ34p3mO0zkzlPMBgLfhjWGkQyFqz00eSlCW+8M8M0AZjp6yBY/8rNFlLXSo9gu67YliguPhRbfBjF8V9uVHBVgh79Ma5a24L+0w+lxn1LFQerJwvXi/z4CIZoZZEY2mn4UD9A2rvAzGx+/8sg+9yJITOdJMJ3tbAr7Ao3pJk3WdIN8Ah8UbRzfJllGaUoVEDT0nYfue6S67qQKGMCuvvWF89hAsZSJvYlc/2nmc+x1RG1bEv1u7dO0wYDi5mj8HYoL7mZJ1ZegE+aEUGjXh2679iOfd3EXXawltv3QE7ZksdQO96+ByqwQ94irvO5nlN0Hs6ySXh8OaLQuzzMLUKv8U4ixs+kh8jbs3LodWZQ7gtSZPFH+EAAB4zwz+XFGEb1YSNmLbfDt7ebVva2wjVjdTeFFrdqI+dMMNqkz5U7KOfOBz+fm+uSF4Cy5OeAUzI8Z8Iy1uUescLv8ajVWUG1VzbD50/h9W3q7sp51kV19l5Bm86xYwbys7vKL3lEaubZSYH2xYGesvu1QZh9QqxIJCLoe5pBcMZNuzgBnuZUPBJM9IgNUcRhOGct6Q2ZMIF0ytlunJ9umpR1zdUblFssJx88X91/ds3ZOT96AIib6kiv5n8KOrg1Bmm/KSUcMYr3hXdh0uyHkATCjLAdlVUYwN52XO5FwMkhyuEj1JJ44XQWOeFLynl0eTEZeUL87XMRxlM81op9HOqvDhKWePqCOCKD
 8wf4iKJg
 Rqe1TDVHUTTwQsfoUc8744OMRWI0Y+Is2/d+B/cZRTGGBSmlpcnc+itPlww30vjHrRZewpWALFohc5mpZCTNVL3157+o16fNTemTmt6G3HlsuvtY4trgoEjMr1LzFJFvHZwSySlZEAlcggBEv9U32rdSsAzseXpP/h3WZcmGyuJXDdhVROZi8nuO6aIhngu0tDjcoAy+/aeX7FCt2rkFdGkQycbdPha4y9wg9BWD+tPNbTKaixjovIM+9JWS78mhandzJVU1HMCeyXii9ACSq3kYbRloaxHct4nYWQUosuOdsP4yay52uc0uPFrOu2iDEF8w3ngAIlqoeniNybsdj3c1v0uQW5eLeQtXNbFvrcYHjTUtSH4priCSlFZ0yn0BY7oxUUmKwiIzVRSWcTMeoe3ttDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- Patch 1 fixes missing parentheses in DAMON iterator macro arguments to
  prevent potential build failures.
- Patch 2 clarifies in the sysfs documentation that the `current_value` of
  quota goals is only for user input and is not updated by the kernel.

Changes from v1
- v1: https://lore.kernel.org/r/20260518190932.42270-1-maksym.shcherba@lnu.edu.ua/
- Drop patches 2, 3, 5, and 6 from v1 (which implemented and documented
  update_schemes_quota_goals).
- Clarify `current_value` behavior in the documentation (Patch 2) instead
  of modifying the sysfs API.
- Add SeongJae's Reviewed-by tag to the macro bugfix (Patch 1).
- Fix checkpatch.pl email address mismatch warning.

Maksym Shcherba (2):
  mm/damon: fix missing parens in macro arguments
  Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals

 Documentation/admin-guide/mm/damon/usage.rst | 6 ++++--
 include/linux/damon.h                        | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)


base-commit: 85a7d9e080a3f65869f22c2d50b630462fce332b
-- 
2.34.1

