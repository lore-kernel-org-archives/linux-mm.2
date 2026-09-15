Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCFF8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76BB76B0093; Mon, 14 Sep 2026 23:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CCE6B0095; Mon, 14 Sep 2026 23:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596CC6B0096; Mon, 14 Sep 2026 23:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 272156B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:04:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 771DC1C0F49
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:08 +0000 (UTC)
X-FDA: 85214502576.18.85B7BA2
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9A09320002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TgiGIa+3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TgiGIa+3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789441445;
	b=vhz1nes/FrHOaKIzUbiVLAJUShhAIwPuIhwrqyNNK9zumbgULWrqxlP18rA9e0/S7tInG4
	xSfQ0QBD5tzTWwkJyvbtTESlRboVNDrNHE0qehPSDzIr/unRBYuo9/6W48VA7BdQ1zWIcN
	ZI6DGJ0UvjYJV5lGNkGT+pSbbxbzDSQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789441445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulyHw4oZ448FQqvFWSJJVv66MGmnHaoH74pheuM0m08=;
	b=j+w4ilbjKPTBTojhryiAsmICiWvoZzYAY7ER9thJkSdMx0EAMRlgSh/s6IUduthkN7jsoP
	EYark9LwgbFZMKKSxp6xNqJYNqPIoIeR6hdTLi4u8ClylfKxCQoQB4CTRMACQnOwcpl2KX
	czm0BTGYuNAkQ7sjn4GFOQhg2DhcKkc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jBTnQ1xbyDIc+6vAbpbihp73UuGFRurlhgAKoEkvNiPYEBoEju56gctsaBAzdMTOuCWYInanXg0uNQKB515p38mhXEkAfni/sZXvP32ICXxGML15BBoDUBqtb95Q4ViRy7+wV6Tz9IS8c15B0NwBDGHS+jMvvAfF0NsbCOqH1YvKtDGJ67QHRa3o2AbpbaYPqm9jp0zgRRZ/4xAB+kMPQOKdXgBNaww71KzCbmMYz7QHyIYwqxxFBRGIkoO5o/MOH4f+5pRQyZHgdqLhj6z3Sdmfgdn+T9TwmeubJ0Ww1N7HeWr8mTtHfPRqt7d0BJq220epqUWdNDPMAGz13QLPtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulyHw4oZ448FQqvFWSJJVv66MGmnHaoH74pheuM0m08=;
 b=d18g3dkGqZyfRzaddaV0ofgoUEVXwfpPOZCGAzmYz5NyxZrk5sXv2JtFQ4OHVIT1sAqzsIlkYU8qp0xpCWVSAxKxvrx6+xaBKq2F5PU8fTGSELnJYE6pOxkmY4gad32YscOyAzhKQplPjuY1ssziRTMholJPXDrBjBWnMkX6NeDW94rzafZLnyziW96KfvPd0tNi9hfhtoMzVfuvRezbW5YSgUn13hibu+/18T11u/hNI7Z3BoChaUiTTsTyhG5wiy4KpkBIuJUjRwlwOhqwDX/UuWgLAXtdxftqfuhnGffrY5EGatrGw221QE+hEYkzp8OyPw55+ataY/E124nZMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulyHw4oZ448FQqvFWSJJVv66MGmnHaoH74pheuM0m08=;
 b=TgiGIa+319Laf+IK9XIyHgKEJVCNbtK+trBRRwIky1kSh1f331ZG31FpM10cItp+M4o9YR7QfFBHh7Isi3u9GUbQEMZKD32l1/aS4MuXka4DK6A/Klin7w1iqJSKMy4RtGvNQOmlNGevK/hITxMX+6hE2aIUinAjY9lEZ8tdu1dKI11oS9jYURTpnMsn45uuZ4JLFb/AbSa9GhqzUOPmah12JvX5sYRiEXhVJ576wFpKB7NmuRmEhbWjWmU8e+ebHkOLnZnbf8Fy/0TEEl6t04amx5XviF+SBI/cIf9IvZm2WZ1TeE44Th6QDmtm4zBGoJc0QnqKsWkS1ETbApoGbg==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ2PR12MB9008.namprd12.prod.outlook.com (2603:10b6:a03:543::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:03:57 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:03:57 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rt-devel@lists.linux.dev,
	llvm@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 02/17] locking/rtmutex: assert static storage for DEFINE_RT_MUTEX()
Date: Mon, 14 Sep 2026 23:03:20 -0400
Message-ID: <20260915030336.1192299-3-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::25) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ2PR12MB9008:EE_
X-MS-Office365-Filtering-Correlation-Id: 80949a91-fc2f-4378-e804-08df12d5fb78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7Leu/6VmRQQdvEDiIVL82HCGEcu3KozIVfzZNIgvm79/ecjR2vs3b2M4vnDr6aeh114kOaqXelEtdXWY9kkO0D2dlT3a8EYFquc2LRIcjNBZgJQjS4q9fq/7E3BFpZeEfEyqh8MvYfDVPWykrh7+f6Z6gcjCZtCRqhiqqV85rdCCS5t//mTDUikboka6dWLI3K8rPEpmYlP6g/rwXi1WBNjHVDTh1BzdZiuMWPT75ST5jqByh07TRpoNsTgERq8ojEueLG5cmHKsGnpyVp8K8VjeUP7zijKmHF6h9Hn5kJEZEH31YbWd+ViJtdw17DuOI3Q9suUVC4loUAF4/yW+hg8k1wMUrB0DwRAgMgJN+MIcHayHPWDZBjtRzzhXhEe99qBjyjbClK+PYWArIVJqAcZG8MP4glpnyxs3+ya7aihm82QZFB9kBd1cVkym3HPphQSO4zupsIei6nuDBoOz2sz4DdyyolsR2PmS055p3PeE07NU1rMWu2UP+x608tcXSBQu8ouSQ/s90TYR1PcFGJu/itX4Ode9u/ykzPm3z2Qz2g1GM1VWR2X3RHfZYC7qey4hNzPTWUcj/BDGsywF2UPgVEZA8LGCcmEeOylsXie3g9jjEPpzDt2KQLl4qGAMHLV6nWWc1Ux+NJufLWm1sWzwRW6IcEj7fSYpJshqitI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B2ZV3TocVue9OorsdcxudfoqBqiqFk4oqpLBus/9j5BQLzn/nlSM8r6ETqPs?=
 =?us-ascii?Q?ywuPSkqAcrXu01o5m+szxs2ktAZADc5e1LlJXDxgJdVBmFjtihXlDMb9SN7P?=
 =?us-ascii?Q?K47P6fnPYUNvyzILmMV2z+3hmBV9zjQ0HUdlGb+POB9dE4v95R21x7ALfZjG?=
 =?us-ascii?Q?KpYYTQviiHXWOS/2igjG4t5UHjGc/FH6BeQeuQ4y9fon1AtspCBoKGm36KDj?=
 =?us-ascii?Q?Na6VS7swhOpqqXIH1NHb5S07l3kgjyXcgMtN8m10CEGwj5Yvl2h73XGZnUil?=
 =?us-ascii?Q?cWN8w1Ya4FHnEWXs5Dlk173o885lvrn7vKkEHohu43gnHwgwyANtSnmnZe41?=
 =?us-ascii?Q?f39sdylrvxnMtTQS8GHk2k+KL2hIhCh7c8EGYTbHX4cs00KGHD8GoQ4QWG4L?=
 =?us-ascii?Q?ueHr4GE27dUyqY2cjW5Sx6/WQ1Yay+GO/qOhRFbbtFk7cU7sSPbgyJxLRZO6?=
 =?us-ascii?Q?W9AC6kjio/9jPlZWischMaD7f4h8pEQxKx8l72L1zkuydysNhFtRK6dcBzCH?=
 =?us-ascii?Q?+vSXwmjg5f1Dc94Hhw5Efe014vMlVxGLG6MlWfdmm6Yr97xE2ZZZL/VGidlX?=
 =?us-ascii?Q?NK2KMQL1ckpQsXXcoBMmbFiGG/zhbbmOWWrktCabSAJiwRriIhlCQ5vA/m+I?=
 =?us-ascii?Q?sLcgKi3MJT7wWKhulP0q0Se38icZh+uS6U5qfc2K2SNmsfdy7ZLoC5EkwMNB?=
 =?us-ascii?Q?GOXgaaCL0Di1zciiJkZmiB4PTknsq/1QMkD1G7C/LPlnZvunA9Cgvc4DdiOB?=
 =?us-ascii?Q?qdNk9dRQJqZmQ9Orlf2iIDcaPlMUgFZpBe58NVorDJjAwftfR28MMENkjvJL?=
 =?us-ascii?Q?UScFdBzW/wLgYBF9V+p2VXGDOzKmm67wodhcLmCRzrs1wuunbBIjQFwvaNl+?=
 =?us-ascii?Q?edK+m8D9rOuLcPbktAvYY0d9QOuX1GV2lv5O1exaeVz7IOiiU8uSKGrvSXxa?=
 =?us-ascii?Q?OGoEq4xCXw88/q268wPYKg8/uGpR01166VSKXj6YIuKFSLGYxMJ9RAgj8uzG?=
 =?us-ascii?Q?XqeEDF/4VcX05M4fa7jrj4Z05+RtRdgOQ2De8kMLAv+3WNXXgd5+nQWW5Iud?=
 =?us-ascii?Q?GQzvJEcePRypYY35ZeNkmbkP0EAlu1ZlMXWR8JlSTXtYvkOrJpb3DoRJX+RP?=
 =?us-ascii?Q?LGbSS+wkfTRT0sxRZ7u+RiTbts9HHZdIwsIaEeNY/RoWqaI3HPKfBBgF4QDz?=
 =?us-ascii?Q?HitAcUiy+qKlbtcTGR/8oMy5kfIXblGPg1ZP3ArU/Ep9LpIPW4/mREn3HnXI?=
 =?us-ascii?Q?TXmVn2X7mr1pwtI+W/LiLBROgUM331vuvc/MEVPXE4QpKZHf6aZvWw1YOnyP?=
 =?us-ascii?Q?zw+WaVbLSjvyYxSGaBoXi2uJM2RmLeq1aqlK6DL2OqkRdecfwLfjRBBYflv4?=
 =?us-ascii?Q?6mGo7sUafAT3UELgY9bNwr/UUYRl8NlD9bvgYiUtK7fgKY+hdrrjBXMbp1Ot?=
 =?us-ascii?Q?Pqak0D99d6Zry9zBLbwwqy2mlRqQJBDYmCK/lJeAJKF6Vz57yNd+lS0beYfA?=
 =?us-ascii?Q?wn84/aIItWkaQ27CONTXOH4mNfmYn/CmUJfzR0dc+PhroYHaJoXPoPagmMMV?=
 =?us-ascii?Q?eQSIMBx4MkCOKdBpTAISnxaZOVnKAv6Bo5kTNmPMe66EzdkZc6wbUGY9Ly8D?=
 =?us-ascii?Q?/RSI1lh1dvqUtaJR1tLmsZxgzy3rz0wTSipWi0qLIxbz3URwh6vXNEh956X5?=
 =?us-ascii?Q?wWywRDSkpTgOfGP62DU/iUiilkAAkPu4SAliXfZNgfjETcE6sO8VRfqBMoqL?=
 =?us-ascii?Q?WaST7bel6g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80949a91-fc2f-4378-e804-08df12d5fb78
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:03:57.1510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDqINFCfJ2/kITqwbEtV1DWRrt1rVU0qBGU3moyOst41efDtk0VDYAA/DI2BiTaibbjT1fmvSmTDnGEI5ZIUhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9008
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A09320002
X-Stat-Signature: kfsgk8kfohwb54h6jn4ajgpix4pxyzdx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789441445-13082
X-HE-Meta: U2FsdGVkX19hYEK6o74+H4Q3Sdmpouo7iTpgJMY0J4n1jqpKkOaR+Kt+JrdClKoguNv3YpXT0291JxtH+23enRhJsJQdWzkjTjc7picBbUlameKupDKRQgv4eg81qw9BAI9YDXSmeIX8W0GYjQOVq9qmtzIxPG9BxCVNcl0TCYEBb6yN3YukUnijaWdNNgcunoMvKKme00Ys8jQR9E1iH4DMXYn7vAD+eogX4GRHW9j9xfUjYoyg7dwgV9irTFZZDfRdUyD84BDYc4PHx6qSvELBh4s/0OP/ZEqyeG0kWgn/9SJP1NNMbHK6Br+wFgzI3qE1rlnXuCvFlVEiKiWNXmLcyybaYjLQpYvFq0kjtKxiic8CNfVuiARG7+FOFm2Ffp3Bp3NSEo9NoXmcGQSVSA2dePoN3KHNLwtDpQamCPpvKZthGZeMjz+PasFGR0+psmYiFvtiavMjuVzRtlswPo+Az6oCbIpD7nU4Dc5VAAkeFLH+EoMniEMd0oTBISnZ4+lMNJuiwceFR5ZQci53QmVfEh3WlBRIO0WbwfIzq9FquYF7pgOYycHFr6TK6hDGveFRgFRxUZQiM/yp/Jtym5x2sTb217xT4ldQcejTELOOf20ukmfDGVTsWoo5Mu/N1HAQABL8RV2c64UU8iJQMfeHFDR99kWl+1zu9E1Y4ILRXWEvP1PP6tvhQVW+s3aCzoOrC3z9Ft9Q8MvSRYcHwQ96Ghgooulsp5/LCyS4qOmGxKLOcMwW99k7lziE3Jxt64jiDfC2gOaWxWp99n8gXUqYPXiFc97VNvUqbjxDA93xbZksCOu4TRVRMoOmU+hLxI3nCYfVviEm6lLpzyH9gSYStg/Qn2nT/dWZuoGNd3GtSV3GTv+4KBAPUiFdy0kVSUgGFOumlPvD/UuEu4Ek+R1fE8uZBbJqvs6KGM76aeKaSM9P2PPVXzQq1cv7EE8PYUkGKLUdqyjDOFgsWil
 qfx6Hene
 f0SAFg+4pQ6gxNNJYXB+WX1t/f6aJndrqAs+c5HdydyOUZ5uVL9L7xzdRh5NTPtUCh3LFhJR/CpAwfsLgxhiup9BzTXmxeZpQCa9B7H5kLwtnvLCoUmgb1gi1KUoh7DP26a27CHH4K7fNxpYUUauyq+2XseUj0lw4kuuso1ymIsMW4fNX6MaHkow0TQs9mdAgNHkYea2IGCnuj2jJyIM+unHuoDh57LZOfr8ynDy8x1RkwS/+aX5BWPRLPL90IpwZWxQyHLOWV+3/QqiPm3BSIJ5ILT2hqsvNWhnP63nipOwLZdi9ukWMBUQIfMIHkA2UilqLNoAmd1X+tbmYQGuySaL7q83gghXws/JnJq1/kBuUbUCLgk+c1CmvleRW4oXVX4JBJPgsmGQF9k205UBRQtGxkNmQAkT9gDxD5CYpiv1WnRUZMFvdMks27H+d1JNefE6/MjchcIztw4iohUJ1d7Oz2SikCPxfN4P4qXaM6W04QlZnrmnmcqnJLtMZuJ81/yLk3GNt9S0Xv1CgkQMp34yzbFHO+1QUG7y3wqgTXBr4KJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_RT_MUTEX() statically initializes both the mutex lockdep map and
its internal wait lock. An automatic local object cannot supply the
persistent class key expected by this initialization.

Add ASSERT_STATIC_STORAGE() to reject automatic declarations. Such mutexes
must use rt_mutex_init(); file-scope and static local definitions remain
valid. Leave __RT_MUTEX_INITIALIZER() available for embedded objects.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/rtmutex.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 9e1f012f89db..495509d82c88 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -105,7 +105,8 @@ do { \
 }
 
 #define DEFINE_RT_MUTEX(mutexname) \
-	struct rt_mutex mutexname = __RT_MUTEX_INITIALIZER(mutexname)
+	struct rt_mutex mutexname = __RT_MUTEX_INITIALIZER(mutexname);	\
+	ASSERT_STATIC_STORAGE(mutexname)
 
 extern void __rt_mutex_init(struct rt_mutex *lock, const char *name, struct lock_class_key *key);
 
-- 
2.53.0


