Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B74CA1012
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 02:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5D18E0009; Thu,  4 Sep 2025 22:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6C28E0001; Thu,  4 Sep 2025 22:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC9F8E0009; Thu,  4 Sep 2025 22:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC478E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 22:01:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA244593E2
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:01:08 +0000 (UTC)
X-FDA: 83853543816.22.28D4595
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 22CFAA0010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:01:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Atiq5GpX;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757037666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ch/ynD+m0gCQXFRHIybFzpiVhlEQeEpH0zgoeCB84/A=;
	b=AU9Bor6xbepc4DdhC1PG2UjZn5mjXGC/MfNedHHkJD4cbjFU2uxdOY8Klcp/ltgaQFhD+W
	dlSoaBddjG1conWKHncbLKPgNPT/WEHmRbY/bYY4acYeQFZuFpIW8bVspsFThe+8TonpcG
	VObLqQxC3YdKFuvVAny7jbjkXbtjkBE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Atiq5GpX;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757037666; a=rsa-sha256;
	cv=pass;
	b=31o05n+DmQRHCw+7v32j1YB9mM5jpinkBkanoqN2jcp1lup15v16sKmmicy54pSIU6ss/4
	ChKiUsgerMhDg8wK10x4v2uw7Dm7DYJIsVxoQswu8vu5n1RdI1UwRQdaTKOixLnWHCEGFi
	nP/qzBzjmFS+gtbs6kbK912p3osWYUo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KKgTU6aOc9BR10Okb3biO9WPuiCOjTPLwjlDJQJk2p0ySnNsG0FZdJCkKCxnlF6HRh/aJCyGp06sfpkTLT10MvyQZVE+AkzHMcElm31BxzsxJBrPIkntf1orDtI+SsEv4EGq2x9cbfCdSbuUTvgIvF30VKLpskg6v7g3ZE73H8lG5DyKNkRN9NbZMnDlUuHXLGFVNYwaeKxrw0t4pH7yrDkTUziqCffX/35iL4itIt0T0aWBFJrmSruWbJPi6ilCTMZhly2teY+cYK0o0HHKR74ocQF+3xlvtLmeJjEhomkb8qal27q7vUOCkBuYkEGGvv+qr5vnjfBWy9Ohk7Q7UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ch/ynD+m0gCQXFRHIybFzpiVhlEQeEpH0zgoeCB84/A=;
 b=a58mb4vj+IDPBw4JmeB3p1AlRImldj47pKb6De7LCiewlyfY40nGrnfQ/IWjlcHQA/6xYKTXaOeZGQNmVamZD7K4UXkOq/4EsuhwJv1r0ckI7Q+RSgpbMR2WvvaHb1DVfbQHIxvwww1RxMgZtZ8P7dJzgrXK4zl62zwO+6tQ9x27feCXEuTt4echWlQkESg4beJbjtwXeiA0/klDg+Va127CHYfU1ByDL2/s1ipI0vrF8yLUTua4NC1WzdLLxlTrE76IOqjxup/T63alIxTUgzrjUxN5wQC+iCsBv24N9pH93TVHPAbuwXtb9jwv0/oGX9MQ3D3wfxt366IfVvqA9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ch/ynD+m0gCQXFRHIybFzpiVhlEQeEpH0zgoeCB84/A=;
 b=Atiq5GpXR04/50V+WE8xj/2AnHFD7yqN86QRz/Jnt7e6gK2Y5YqA2DO57t8wS7ustj0OukzUhe31wsB336a/rc5PAk66K7cOPao6qOQdu2OLozM2Qc/DT7AUgPsLZfoC6GDYeINA6EORbhTu+Qe6QUYpHNFU57vCZGYoLao5o5ZNgq1pbzK8NpGiYniJc3s5+M95nScRpmbMV6f/eEPzx3KFjbleClSuIrynDIDQTxBtyBG8SZl20cMEC8J4XKJbDSVcffuc1cjdRuYT7ew9Jwh8jjlFUfaMcYNOCHNW0pdnrEuDRNCG7ACB5B9fF1eywgseRWDgq3jJPMMVNYLxUA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYYPR12MB8653.namprd12.prod.outlook.com (2603:10b6:930:c5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.19; Fri, 5 Sep 2025 02:01:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 02:01:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/page_alloc: check the correct buddy if it is a
 starting block
Date: Thu, 04 Sep 2025 22:01:01 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <D9D94987-8A36-41F0-B0A8-3BB47910223E@nvidia.com>
In-Reply-To: <20250904020654.28689-1-richard.weiyang@gmail.com>
References: <20250904020654.28689-1-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BN1PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:408:e2::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYYPR12MB8653:EE_
X-MS-Office365-Filtering-Correlation-Id: dfbd0ee2-25c2-4f6d-64df-08ddec20114c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BSBXaKUux+MzVc6lF925hBbL1iP00ZB4RTmPr7sg2kqVevchIFk3LKjjQw2Q?=
 =?us-ascii?Q?Xxp3LnzTUA0gAtKADNp4xbHc9x0vVEtdyUkhnj+TNBrdal470HckYv5bW7Wr?=
 =?us-ascii?Q?I+BV/qN22q2Gc/J2tOXtug4N7hQpFXUhgBPpUb6EfBnPJTe9RqAOACULSUPm?=
 =?us-ascii?Q?J1UpdBKhcZyOU94eom9KSOD2nwOmxjfFczRlDHpxLLl1ZpqGCXdiBqYOK0Lr?=
 =?us-ascii?Q?7m5gfA4FoeTXOBdL+3/PrljxRIlK+NuhT5mBCEzD8IrywPpNYo4qJ8+UuYqp?=
 =?us-ascii?Q?ULyYCiWaYudFi5HZ/rnc/b9J65GueVDacZ1v9UIrRi5moOGzS2JTscuUaouI?=
 =?us-ascii?Q?5w77DAoIpl20aYaYZbiRw9pbDKfP4P//KuRIRAA4afK1rsMfMbg9VYeJI2AT?=
 =?us-ascii?Q?oZPwISPDING8sCl7fWelplOcPllxoyILpmV/LA5VLZorcf8sKBt2Rm20ZqLa?=
 =?us-ascii?Q?q0bZOfQmfjJfx82DPySkK4XbjwsHumqjZZ2eUVYXJJJZO09Z7lqmEGzlAnOZ?=
 =?us-ascii?Q?hA4RCCvSuCfHWzVrs+Uaf2vS6VTuePCUxjaIW8CSo3jgvTorM2wMiAYvcGdf?=
 =?us-ascii?Q?t6bQKzzdQhF7YW+QD4rignYt/PpE7ZqJGW09xHMxoIgCxj14WRH1QtMnuP8f?=
 =?us-ascii?Q?Jd+rgJbuUArIqWYpDyfhYApyFWMKHewuxv+jLzIxgrBKwhluUjbhaT6HD/m9?=
 =?us-ascii?Q?62KoJyEkoCW2DiEWDtT1p1PSLM7x/pRoU6X+llWBSJApRHUby3wN1ajx9CsE?=
 =?us-ascii?Q?Xe2cNicg4nbxtY/gJBT/aKLJZE9vro7rv/fQ2s8QKYcFzSS5PsKHQBLimkl2?=
 =?us-ascii?Q?xUyX6FjM3pNAGCBU2IAZCe8O66TtKfDyo0C6K3OcXL0ylXXrE+V4aeKFnSet?=
 =?us-ascii?Q?iwBDap+0/fxKPruDWcqKCUxSFpxyn7c45l/X1a1TP7ik+/yHH/vtI3nwdEcF?=
 =?us-ascii?Q?eEIDgYTDiqLXYtV5Kjt5hPKkNEZNDjbpk+QRG+m97dANSLGP6AxA4dCgHlOO?=
 =?us-ascii?Q?X5wFEuhS9ll3YU45jUzz2QRyrbSGbqJzK0AnbFdaFF5H9MpB56BY0shJH937?=
 =?us-ascii?Q?LKE+rW5JT+2+3pwRiMLCuUxMkYxu7MI+3KEyPyTspgmtJt3k8V//VA/3SFmt?=
 =?us-ascii?Q?Wi0UV6zRO2yAHVXpgHuH4wYvW2HAM+3RL4+I3rVYNpgaf5xObusibY3r7ycB?=
 =?us-ascii?Q?DZQ62a5yLf1MLnPwaX7DPs5tuRXsP3SQ/6WaNZNyA4ecfSIzr8sRVke4Ak8l?=
 =?us-ascii?Q?KpTjoaGu9iwvH12D9vrLtwgyLVx+EHOlVu8Wv27K5yo/t9rjRPwMSSAZXVib?=
 =?us-ascii?Q?v52JHT042GQogAm4idCuDuY860RQfmp4wsmdMsdLYk0AXkAKl6USwzC5bBPX?=
 =?us-ascii?Q?kzTHoyRt0zpy7wlYcuVejsj2XG6gHQ4/Fnn7dz0UylLPk7bqjtIHqLtT7pz3?=
 =?us-ascii?Q?/qEI5lCmXBc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VX/zQMuw8BlAV8XoWpXadgBJgmJT1GwIdbSeLux2C9LI9o+Eew41YRWBhEJp?=
 =?us-ascii?Q?uW2LjVItgf2V2mnt6yL+tA2rNKTXT8q5Vr32jm+PTdm5+LMrP8OhA2q0+0zR?=
 =?us-ascii?Q?xrrZtoID2THgKnOySSVDNHJW/POmAnBfhxH6S9TAkLDpCdVZEa6gS0whO4G7?=
 =?us-ascii?Q?V/4oCtHlPf+KTii30G60NG20ugkAIFg4bGvzSdfb2gg4l5Z7LzptF+vHM4dJ?=
 =?us-ascii?Q?rWDfZKUscESlQMhBpAufTB9gXTV5/vOebCHh+ejjtLmC1VDz7dxqFFZjMPlj?=
 =?us-ascii?Q?vCteOf0xjNswTCYWQ5xEdn/P4U0GY4QnSc4dMyw4cFXLtms/slcagOVAIiia?=
 =?us-ascii?Q?iqyzdlQ+2YewNdMnVbp7fJaZpiX5uSJ0bB6zNczYx/SbNLHUr/A2iLwFMusD?=
 =?us-ascii?Q?5eN9LePxQsZVR2MsbzWXe077xKd/xZeXLONInql9me4S6EKGmWO+wLUw9FKo?=
 =?us-ascii?Q?psopb4Gs3oEag/sp89B2Nskxtx4aBQbnJAHV4MtS0hq1mYqOigX5BKMpcVmE?=
 =?us-ascii?Q?FU0306TL1KD6C4dwrh1WzAxPakiO0BB09HWO1u1w6b3+6hw2BC6GBzjZuYv8?=
 =?us-ascii?Q?902oUX0gfdNHijYR3ZLzxeb9dlmVtfm0LL1X0Z7Fw65gOuBcowaGsau9Wo0p?=
 =?us-ascii?Q?oulxkqcHAA5ZohWvbER7ZeW5YqXuuuxAEwXGVuw2nL2KzLDDPClWNAa0YZnh?=
 =?us-ascii?Q?MJuLd2dpkzyqNT07tKt9z5hOUuzUh1Pqcz1WGyoRSNtVYLadN5YJjqzW/4aW?=
 =?us-ascii?Q?egMuUeyQnC/rKiktXwhaNsUONe1gkeNwvfr6dCGwvSsPZwpGDZg8d9T4m498?=
 =?us-ascii?Q?x5KK5XWr2tyFLyOKUx3KBxOnwmL/FDiFJ0VYJd8xfhct6ZTgsSsB2t0ZQ3NM?=
 =?us-ascii?Q?TWTK4F9fbYNqhMnHPDu+QmOBl0CtIqCpQDy/shvTwp37BZqYRQKPm+K7ihmI?=
 =?us-ascii?Q?+kMfrTFpgOEH51yFGn5Iw89G5di+2QY8kNivgIudDnaEZzm+KEvyuscoMrdI?=
 =?us-ascii?Q?KtCZT+l8yV/pLd92xbeaTthLd9zCMGaVLt/5ln/OWS5dxV6jadRWhK85ag+a?=
 =?us-ascii?Q?gQNg7kOMCCTj999e1cofGJJq7AdHhRVul4Ljp8HKV7riA3+Tc7/UiAZVnAtB?=
 =?us-ascii?Q?NcxKew/ZLnpnVtXJVgLInNxpTO0Nn49KlW0k1ci/A+0UbssADCZVEofoW4bZ?=
 =?us-ascii?Q?PMxXt2wEeloKSpRmxMU3niZVuinlRfJ5X1tNlYDWeF3a4lsv0Sfl07owxisR?=
 =?us-ascii?Q?yNhMUhll+olQYgqpmDiTFalHhAlZQfr8FxCWUfVxJJ840iuet5ctWSRlRtt7?=
 =?us-ascii?Q?GZjl9XgoWg6dmfX7Hq/WYz6zRgxJlFKwjzZb+EbStuwhp8rNAFeqL30ozUNm?=
 =?us-ascii?Q?u5uKIKBoxOs9Pu2IJptxC20+GirI4Riq8yloG9ZlbBGdzVIOUlZYCbsEgRXJ?=
 =?us-ascii?Q?/p4cmL3R5TsqHLsa3vuwjdY0fdurSaHixkhITP/lAlb/XB1n83lWoIv9wF9y?=
 =?us-ascii?Q?3qPdYy43lYiV0TxNpGn35WZL23+911A0WfuO2Dyi4wr9YjBgUO5yw3PmnZnf?=
 =?us-ascii?Q?tJAX4odUpV5DxYiQSgCPotKjtaFoJINtaQd0rbHm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbd0ee2-25c2-4f6d-64df-08ddec20114c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 02:01:03.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvxXzJNhM0orOYO4s0CfjFWE7+hgP6KFz9Hfe5RXfLnqGjkbHOUp4ZU2BedVRpU5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8653
X-Stat-Signature: ioykizdirqtmpimgz73ursxoenghucsn
X-Rspam-User: 
X-Rspamd-Queue-Id: 22CFAA0010
X-Rspamd-Server: rspam01
X-HE-Tag: 1757037665-110782
X-HE-Meta: U2FsdGVkX18Y8+3x89Uion9O4L4PF8iqbdXQE3u+CpwH+MT9KsAVtNj3fctAT1EaLo4tSYNP/ZcaWkxKQkEqp3AxPoYIe9sY3pXLdhhtRIPz0OBuDJ1XVPt/7NR5S9+387yhOWaaoohc7exOUgk2H1Zq9eiqmUEI3Z44i8R81oyN0G2jGjzmLNULsXO4nHTAq8y8WqthP4L1LBJiZl3selqKkjPbS7HsowhIY9hASkhOuxBeFxJwWkRwzYyH0zid1vNDI2E/4dkn/22ziCeNxReDu3gEBcKYYbw/sHhGJWFZY6czjoOLyLlmJFkj5oQgnkO+vvdy5jTmRa5i0+So5Q2NJ7whKHQcdvw535Zy47oXyYd+wt7Z393EyfUPBpq9k5hrbdUxVWxI3og+nxIha68Dm1msdS2ZjzzZAcep2JmEwV94VtiZWXGE8tW85pukJ4WaJ82efP2NzgviJi7//v5zjscGMDeMx+n+rLb1PPu00dyZGEglKC8Lue35FSd1LPX98hS2wLlpBLkAb74NHuppzkva1TboAoYSh6xGoz4fPtLc8DW0OymkWPfkD1I7aIXzdpPVtCxAIg/jaU/XtUl4nQxv5/Jy91hr/TqWpqRC6xacrQRoVXeBAkzObLYNDZaIvbpvZJS1MwpG2UYSzJInLhooLaLnkvRvPLaALakJzQEcjR6OUbpoq5V7HxO+8cDuDxUbAYbkcHVR2aOLUSuMV1psyuAAUoVIvT0R1x+ykjqm3I5RZCBZPQsKHFnS7hAZt5AX1nvpG8kkAnLNPn7HzizYMJ+/StpNGl+MEbe4yymnqVGnhfbf1dJXXo2Ag1Z+tF2pSfayBtZp+TyaxzCa7wkdGlXCtVJIox7Tv1PLzxl4HTaTy5r+GAYqZMdNc8D3Yx0oix3CT68yetSkQ8bj21I3ZShRlFvgU6eA1wWX67lmM6cfsmmOjE3rwTdRdPeCpdGU0MWGlsdS3aS
 7XYnoJ3c
 wsF6B8k+1Z7wVfcx3hmMquU1O+SKEvCl/jNKWIdmqgUrwa88=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Sep 2025, at 22:06, Wei Yang wrote:

> find_large_buddy() search buddy based on start_pfn, which maybe
> different from page's pfn, e.g. when page is not pageblock aligned,
> because prep_move_freepages_block() always align start_pfn to pageblock.
>
> This means when we found a starting block at start_pfn, it may check
> on the wrong page theoretically.

and not split the free page as it is supposed to, causing a freelist migratetype
mismatch.

>
> The good news is the page passed to __move_freepages_block_isolate() has
> only two possible cases:
>
>   * page is pageblock aligned
>   * page is __first_valid_page() of this block
>
> So it is safe for the first case, and it won't get a buddy larger than
> pageblock for the second case.
>
> To eliminate the ambiguity, unify the handling for starting/tail block.

To fix the issue, check the returned pfn of find_large_buddy() to decide
whether to split the free page:
1. if it is not a PageBuddy pfn, no split;
2. if it is a PageBuddy pfn but order <= pageblock_order, no split;
3. if it is a PageBuddy pfn with order > pageblock_order,
   start_pfn is either in the starting block or tail block, split the PageBuddy
   at pageblock_order level.


Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
>
> ---
> Tried memory online/offine, which looks good.
> ---
>  mm/page_alloc.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5183a646fa09..453cd361386c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2093,6 +2093,7 @@ static bool __move_freepages_block_isolate(struct zone *zone,
>  	unsigned long start_pfn, pfn;
>  	int from_mt;
>  	int to_mt;
> +	struct page *buddy;
>
>  	if (isolate == get_pageblock_isolate(page)) {
>  		VM_WARN_ONCE(1, "%s a pageblock that is already in that state",
> @@ -2107,10 +2108,10 @@ static bool __move_freepages_block_isolate(struct zone *zone,
>  	if (pageblock_order == MAX_PAGE_ORDER)
>  		goto move;
>
> -	/* We're a tail block in a larger buddy */
>  	pfn = find_large_buddy(start_pfn);
> -	if (pfn != start_pfn) {
> -		struct page *buddy = pfn_to_page(pfn);
> +	buddy = pfn_to_page(pfn);
> +	/* We're a part of a larger buddy */
> +	if (PageBuddy(buddy) && buddy_order(buddy) > pageblock_order) {
>  		int order = buddy_order(buddy);
>
>  		del_page_from_free_list(buddy, zone, order,
> @@ -2120,16 +2121,6 @@ static bool __move_freepages_block_isolate(struct zone *zone,
>  		return true;
>  	}
>
> -	/* We're the starting block of a larger buddy */
> -	if (PageBuddy(page) && buddy_order(page) > pageblock_order) {
> -		int order = buddy_order(page);
> -
> -		del_page_from_free_list(page, zone, order,
> -					get_pfnblock_migratetype(page, pfn));
> -		toggle_pageblock_isolate(page, isolate);
> -		split_large_buddy(zone, page, pfn, order, FPI_NONE);
> -		return true;
> -	}
>  move:
>  	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
>  	if (isolate) {
> -- 
> 2.34.1


--
Best Regards,
Yan, Zi

