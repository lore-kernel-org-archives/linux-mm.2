Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A63C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B336B00A1; Wed, 15 Jul 2026 14:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213E76B00A2; Wed, 15 Jul 2026 14:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03FA16B00A3; Wed, 15 Jul 2026 14:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B60D66B009F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:06:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D6B480238
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:05 +0000 (UTC)
X-FDA: 84991789890.12.8FBFDD9
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020078.outbound.protection.outlook.com [52.101.193.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id 52E31180018
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=YSKkkzSf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSx8H0FV10BFt7xj9//KnorYKlq18iN0Y6e4bLh9hRI=;
	b=eZ6pOiO3uGIxDmd8Ej20ijZ0ZAyqstQ+BW2a35MfrDqvpBZ8+Xqmocplaeixs2XxTOBJDE
	n9Jqi9/LOdklUtF1bGtTfJosr3uPdrrF4BbGAH1UWGhIFAGTeQg4JXCbYNTcAv09squ7Ew
	Pn29ytBAqcL+YCoyAzTp2SZwFcG9ooA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=YSKkkzSf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138762;
	b=V+cHfouAYMJq8baFL3om5YCsjQ96WzF5258dxAMQ3bs9xVZgP77Z2EhXX9/8/HEMqAGgSg
	ALaPc/XExoHNRb/Ix2XNy2RfHB/pP+J9vNepBh8maOQOZxUF/kJXpPpPQSNhJzoBAmAZdX
	xmW5zHQFnoX7SQrA9vezqJyG31HGpvk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=imqjSA2O/7J8zCHW9HlNEKE1iKO56hq4DKZsJLJFHfeWtbI0tkz2kWhxQ6p6qce4ws5RKINVsqomPypT+GGrD5JDcBLGhppHuUxlLxVEb+5bixLQK35NN4gfMluPtRujg1xp4iEy631bUamGJzyQFosqAso4u+JmVXajXbpjtrgPnEtZD/pO5g749oWDQWEMQZEBYqPRT2YZCQxocbWBMq519I1G+qxd4uFz695k5+ylmg1bUKOrBNvmIJYQkd5tRk4RNVh0+ESynnfj4i4LD13QFgINi4A42W10wW4Mx/G6pkEVG0DbR97ka110N+QCgDdY80vThGVGJI00JOiZyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSx8H0FV10BFt7xj9//KnorYKlq18iN0Y6e4bLh9hRI=;
 b=iIZpMNw/urwrvqF54LKqAjtEPmT38aOZF5zW4+cyftn1HdGgyQK7qh6bNP1SeCluYBl/p/hTHJ5mB9UPtcVAayU4FH5n084NhxIDO6bSig4V4zd/uaxS2wWcHXn7kgW6OFnERXlcHZYuGaNaty+iiPRGYvDskWWi8045iZNctfMH9Vr6Vy6mFmAiqnp1qwyn0Pm2+WSoRhVnQBLeGYa7NpHGqLHIGF7+LpCcOyv7H35n9htPI9a+1noXYQlc+qyjqadom86gaUH9mDSkVJ5TJD9JE0wOpIpLGGvYcanaRktM4NFOXarAmpQnZcMIE30d/LUH7NA8jRBpChR8ylzyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSx8H0FV10BFt7xj9//KnorYKlq18iN0Y6e4bLh9hRI=;
 b=YSKkkzSf3hVvz/kZlV7mDj83y6TX00EIzAQwTncxH6XIPMTCs/w3AZiMbvhLVCiexOrIhqB0A+gFJxlqUyyr1wnls4Zpb+bjzoKL7pForu98ApJ5+WyJUvP30E/Hp3ZiW1kn2wRlRZfdNkeMJbD2YS921GRpirG8UiJr9vVO/KI=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:47 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:47 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] mm: percpu: set up first chunk and reserve chunk
Date: Wed, 15 Jul 2026 11:04:14 -0700
Message-ID: <20260715180455.515692-13-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: 73c4d2b4-ed2b-4738-7700-08dee29bb270
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	k2soA6jyWHcdkU4PAHPi1NePaYptG0SfUM3+iOUeRQxTukQo5I3FlrYr27o2pJfChwid8fHkcpek4VTjZDvMkdYRG9mLFeFQugDOYwGGaE4WX54TneXdvACCUx4IBfQhjxhJYynuPUabsQ/uwQg47TevjuGKNcT0TXxtl6tv4qXJxXKSE8bEEq3lRzQiKWRAQcX6m3aKVNwODKk2KUg+I1TeexvmWh//Gr1jLy9z753SHkoWYtxwXJ3bcrWYdo60VLAg2c4jkVIsmGnC1GwcOeTAS9IMUbOw2bSbRQWOIUQIMHSuZccUyjFn9Q2qeE5IEl9RFdlA/LFqkRQrxNdCnZuyHK2Pq7ddUoas7dw+PHIfcL5x4/V9Ppqm8AepPCJQq1S/lfMqBTNDRWhcT/ZzxU94gQnnwkd+TyrxS1NM4pq7/P0P1hzHJkz1izR0PTiKuFnCWDe6Uqa72NMd50vbbu97Wr+bunaJtrqLeoy8mTV1IAeq9eR/lQuUESrDtQhcqpIUucGe/xuPrTeklbOTpII1s/qn/VYTHBymHzZWi4l2KKvWfgRoIl98GxgMuYojeVL6zk2C3z9cASzELNCd7tvAe0xtUP2RqjQb+FgwOFd0tOwiifXM8Pwk/ZBLSg84yGtXTAqS8QIBScKUWUQ0O7WfWKdadVwXA+99PF6ZeP1ORlu295WZjCX1BheM4wUgHHTyR4tTNkdcruQsnIpoCg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(6133799003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kSARMe0KKhBVY++DJJOaSzBXkIL0NRshRLRVSVLKuYlTX7qoV1Lm7FuIjErn?=
 =?us-ascii?Q?i/8PUM664yZ6+rBOhIHW/mi3hTT3j6P99eExZTJiRsU7+C4BPmRJOfqYrgH1?=
 =?us-ascii?Q?MAW2QSqqn9dIgT3QrViH0vzMphdjmMr/fNXRgBLCagwvPvHYTDhtThzORwKs?=
 =?us-ascii?Q?Dikh39TY0MAwZFWV4bRawWGgZ90tle4hXD/nwRe4RGkEffTf3plzFi5l0Upe?=
 =?us-ascii?Q?A0u0I6KqywwCI5z2be3aJh5LTW4uIrscjvu7MqYU9qppfg9fxTgjPWXYgb6U?=
 =?us-ascii?Q?ryjS4PIykdXIM2+T+HSIoFP/uzYUgBqFWj6M05oVgK4pGRoiC2NpcjZN2+IR?=
 =?us-ascii?Q?GMC23DIPzMCuRDVNmONsQvlJ/Rce6MYz7M/FdOAomIagcAOa8nzw41GouaQ6?=
 =?us-ascii?Q?R95zVbsJ/M3GGCd5953qZvO24PsC6Y3hNDx4zReMW6fqJigHyKumApKj9UhA?=
 =?us-ascii?Q?VRaonC1hs01WwMk9JUI9090CHprvB0fDI+RKU6GEp33ZOPaQDq8/YluYcYmm?=
 =?us-ascii?Q?U3y8KMbXCACvtHfy0YDBomlmDzt60S3QiYALHLZ1GjduU2S2wrOYxVhaLS5/?=
 =?us-ascii?Q?+QnE56uC50yG4Kkxga0ZWprcKjqf4ql+ofotujIfkzHBDZw+V75GSh4O1Oen?=
 =?us-ascii?Q?h2K3fea8FFWP6W60sjWOQapSkjN5m1CZMnx7aOasMOW6pZQ3DKdpDVbx400m?=
 =?us-ascii?Q?Vm3uJOg6FVx+ykov4cGEGCFRYQkkDFsPqg++JEP4ef6dadt1Psg3shOXW2TY?=
 =?us-ascii?Q?ynfEkl1iQGIxIIgD6MRTjHwl1n6b6aDAfmsBEDMyGzjDrwt3baKcSi8oTMTl?=
 =?us-ascii?Q?detWVzxtI+onKJI1FaY6Jnu8wwmWaeYtKwqYMY1DLfh5IaLcYuZNDkv03wnF?=
 =?us-ascii?Q?FlWuxBQoIcjvfFHQvh+p6zR4w9n95ePq0melQFrL6//0UvcpQrsgTgViaZoi?=
 =?us-ascii?Q?je4lEFhpv7eBdPEaZlMi/sViijKRphb4Ib5vEv8XmRiAa8sS07bHWRmgwbpV?=
 =?us-ascii?Q?cZqVDA1VB+tGylyLcOo6hMABkWXqlf0lWzjf/mriq5Z2j2OtOJvyT5IbUQNB?=
 =?us-ascii?Q?+yUZm24wPh1cogh24rbk+EQjabMeoJNi5eISivJ/RJk3QayRXMM1rl/+Nwp0?=
 =?us-ascii?Q?cR/Y7gLGTYWjpCSLK0mWtQKr/eVNKBwGgZsL9fUgcoPLEy2yz+dk9s2Ia5Nm?=
 =?us-ascii?Q?Xbff4LEtivnZZ+JOgJkSQS4rsPT+1yVZJWYFUUVs+hwKv5S6kDjvHcHuuH5A?=
 =?us-ascii?Q?JQOULVi081TXvQMixDLdQ3+Jx68PxC6MTZz1bDnyWu+YgHZFR4bJVrEx5le6?=
 =?us-ascii?Q?rfwIPusVIq5aPBj/EEvn+kp/oY4CHf+7IoC1vdp+Fx/5qpJvUB3RnmsrPpzA?=
 =?us-ascii?Q?UNXvMEmpWf7n45+qC+y28v6ZZ2ReWdqfzOs8iVJQURPWjr0fiux0dEMbiJxI?=
 =?us-ascii?Q?lTE0BmD43iwnvQ89tglrQaQjv4KdYAqUXGcVYWrLFjQtgVfuINvC6jO4bdpF?=
 =?us-ascii?Q?G2eNYOeANmsgN4sLJdQseJ83Dxx/rpBuK6htksPqbgKBvASuhLProyWkvOtf?=
 =?us-ascii?Q?atxIuZLogIFmJWIvrOEK85T7zpIs930PFEfWXeK9Y8fx5XFnau4dD7nYLiwD?=
 =?us-ascii?Q?y1MUFCErha2mpl+bv1O50NbYn7Rv1fwuCjqhpVnHY5nfE/yNV7KTM6YdtT42?=
 =?us-ascii?Q?Ni3GOsxq6YmHXZN+N888w03J1JEH8WvN43ONR4YsfgGGS2vCEWxB0Hhbq+8R?=
 =?us-ascii?Q?YVbuz/XasdFEX1rbvRdCaLOpYRi1OIY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c4d2b4-ed2b-4738-7700-08dee29bb270
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:47.5930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J4utBpbZ1+OW5y3XxjqCoQL1NTX7pSYRn7jbSxiNy7UpROBMhFH4yaeOvFWue2JvisjzgbMNdi57qg56vupwd7dtlvf7FjXBqA1c5QNFG0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52E31180018
X-Stat-Signature: eyjfke8bbohj8x3ea8xt78etqkkf7ex5
X-HE-Tag: 1784138762-512667
X-HE-Meta: U2FsdGVkX1948tKmf/l61jE/drlUwoFBPY5sTyHdLvNNCyS2aOdO9XFUZvtVxstX4h7IGS9k7ATgUGL6AvWrP4mOaequunmWCJ0NQh+6YeYnleu3niBLZn7v2WZqE99XrvTROjMoy8ym4ndAB4tmD+/4012CGkqOxe57rFIz6wxl/H+7BBe6waDSFDvRVGSAyEOpNvo6SD44RyeP42YljKSYK0HoH/msMy9jVXZKxT+mpOHk6mIy6tOT4hTC2Bk8Q8KBNfJ3oYPvG3B2qsIOjnCXEtRTw4Kkc7S/kWQmxgsgxsK1Hr+rOqztgD7MSsCknISaI/bIQZqZpyLdxf1CWnH3Un0zvuchg4DvEv8eQjgD21eFf/pHad5Mh47XyC8zuCWSQaLxPpccC+kp2hP4Ew01avml9VvqMY+fJ3BqprDzK73D6DJD6Prgl7dEW0FuDXoc0/LFbdK+6kfiX2F2Bip1dj9eQ2A3I89OeaS+ZKjz7afoi7yzfb06rP149ZVLoyKMtqJdYPUOlFTWT7xxi1NMLXeZqmXz4L8rkKRz1tl8+tl5yyG3UhX8lMyIe0WyG/FpCvSxgc5dxoAlsmmlLmBbJ7kjA8O5mk4ZUnScsdRhChPefbxMuys+K4vMlo0ZYQTrM24Bz9amugADrs04oDMUKHPD9oLPCCQ/ZU8zUc03HXiJhtGHNAYEcxucvlveoT4t6TDY2iODxnC5MuemryButuD2kTonQ8oocrZFA0RxblkOhH/dMnOUzNBRP4KxoTl8xDLChGWlao0Ax1TRGEHdRzaA6UZ1zNegPjp+YlpD1avdE0FKac8ipUdafyhEeQWBYrhKLvjzw3rF6mCFwnmmx4Ehkvjw7vjFtZTnwXidnB0H9lTBhGE/fC7CdY4zccB0Fqj+21je6lEwVrSXVZ5EAQkGN8hJ8A2kGVMChPVrngw6+E+2PZG1FeMqvX2fAtp2qtsx/6tTMgXgGpg
 BAYCSE9Q
 Ye600XlwcJLuEn8Djb271S/SiR37uyJgWJd1l+nLX6p9Q8uE/Jd/koo7L/yQ8Cb6Azyp6cmd1lTfCTjKFARRikF3u9NdVJoS94WraRMFlE3D9jKmr3pTL/PTFyN2CB4EDnHcq/fKTEb39NcQ2GcJUj4tjPCi0ts4k6A9HXs5zKy0v+0w1A06xJSNdh5NeVDe0eR5OW6s9n3NdSmOGxG+45B2ckRWN3Mb7CxhJyQTrV+QCXImO6EvVo+I3mwcwYC7aPLLwfCpB6g3mQhtGkBjGpmetA1DISBGqOGDZH0Q9zVej3HRscYDFU1kZA6bb73ry0T+icWOxSxK5FH33nk5F0qdvxPM0YipR9RjLeqIrpRzDnXO2gPAhEEHumR3PFRU+9w6G8BwJ0p9XsqPs8I/JmEkIDwe/BCz3xsZWB5d0Wmzlt/5eNhkrvPsmw7igw9asc6A0JF95/JNohNdZ9Jrw6vMXeR+KfQapiy6BPXeJfyKgx8sRKpFrUt364eHu4FvbnwPv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set up the first chunk and reserve chunk with local percpu map.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 include/linux/percpu.h |  2 +-
 mm/percpu-internal.h   |  2 ++
 mm/percpu.c            | 27 ++++++++++++++++++---------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 4f36b8585995..2f0e190aca29 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -114,7 +114,7 @@ extern struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
 extern void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai);
 
 extern void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
-					 void *base_addr);
+					 void *base_addr, void *local_base);
 
 extern int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				size_t atom_size,
diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 6d0542fb9e49..ec2e55a2f836 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -63,6 +63,8 @@ struct pcpu_chunk {
 	 * chunk_md.
 	 */
 	void			*base_addr ____cacheline_aligned_in_smp;
+	/* percpu local base address of the chunk */
+	void                    *local_base;
 
 	unsigned long		*alloc_map;	/* allocation map */
 	struct pcpu_block_md	*md_blocks;	/* metadata blocks */
diff --git a/mm/percpu.c b/mm/percpu.c
index df2daa57309b..15303611ecaf 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1338,6 +1338,7 @@ static void pcpu_init_md_blocks(struct pcpu_chunk *chunk)
 /**
  * pcpu_alloc_first_chunk - creates chunks that serve the first chunk
  * @tmp_addr: the start of the region served
+ * @local_tmp: the start of the local percpu region served
  * @map_size: size of the region served
  *
  * This is responsible for creating the chunks that serve the first chunk.  The
@@ -1349,15 +1350,16 @@ static void pcpu_init_md_blocks(struct pcpu_chunk *chunk)
  * Chunk serving the region at @tmp_addr of @map_size.
  */
 static struct pcpu_chunk * __init pcpu_alloc_first_chunk(unsigned long tmp_addr,
-							 int map_size)
+							 unsigned long local_tmp, int map_size)
 {
 	struct pcpu_chunk *chunk;
-	unsigned long aligned_addr;
+	unsigned long aligned_addr, aligned_local;
 	int start_offset, offset_bits, region_size, region_bits;
 	size_t alloc_size;
 
 	/* region calculations */
 	aligned_addr = tmp_addr & PAGE_MASK;
+	aligned_local = local_tmp & PAGE_MASK;
 
 	start_offset = tmp_addr - aligned_addr;
 	region_size = ALIGN(start_offset + map_size, PAGE_SIZE);
@@ -1370,6 +1372,7 @@ static struct pcpu_chunk * __init pcpu_alloc_first_chunk(unsigned long tmp_addr,
 	INIT_LIST_HEAD(&chunk->list);
 
 	chunk->base_addr = (void *)aligned_addr;
+	chunk->local_base = (void *)aligned_local;
 	chunk->start_offset = start_offset;
 	chunk->end_offset = region_size - chunk->start_offset - map_size;
 
@@ -2562,7 +2565,7 @@ static void pcpu_dump_alloc_info(const char *lvl,
  * and available for dynamic allocation like any other chunk.
  */
 void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
-				   void *base_addr)
+				   void *base_addr, void *local_base)
 {
 	size_t size_sum = ai->static_size + ai->reserved_size + ai->dyn_size;
 	size_t static_size, dyn_size;
@@ -2572,7 +2575,7 @@ void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	unsigned int cpu;
 	int *unit_map;
 	int group, unit, i;
-	unsigned long tmp_addr;
+	unsigned long tmp_addr, local_tmp = 0;
 	size_t alloc_size;
 
 #define PCPU_SETUP_BUG_ON(cond)	do {					\
@@ -2713,11 +2716,15 @@ void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	 *   chunk.
 	 */
 	tmp_addr = (unsigned long)base_addr + static_size;
+	if (local_base)
+		local_tmp = (unsigned long)local_base + static_size;
 	if (ai->reserved_size)
-		pcpu_reserved_chunk = pcpu_alloc_first_chunk(tmp_addr,
+		pcpu_reserved_chunk = pcpu_alloc_first_chunk(tmp_addr, local_tmp,
 						ai->reserved_size);
 	tmp_addr = (unsigned long)base_addr + static_size + ai->reserved_size;
-	pcpu_first_chunk = pcpu_alloc_first_chunk(tmp_addr, dyn_size);
+	if (local_base)
+		local_tmp = (unsigned long)local_base + static_size + ai->reserved_size;
+	pcpu_first_chunk = pcpu_alloc_first_chunk(tmp_addr, local_tmp, dyn_size);
 
 	pcpu_nr_empty_pop_pages = pcpu_first_chunk->nr_empty_pop_pages;
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);
@@ -3108,7 +3115,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 		PFN_DOWN(size_sum), ai->static_size, ai->reserved_size,
 		ai->dyn_size, ai->unit_size);
 
-	pcpu_setup_first_chunk(ai, base);
+	pcpu_setup_first_chunk(ai, base, NULL);
 	goto out_free;
 
 out_free_areas:
@@ -3260,6 +3267,8 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 	vm.flags = VM_ALLOC;
 	vm.size = num_possible_cpus() * ai->unit_size;
 	vm_area_register_early(&vm, PAGE_SIZE);
+
+	pcpu_vm.addr = NULL;
 #endif
 
 	for (unit = 0; unit < num_possible_cpus(); unit++) {
@@ -3295,7 +3304,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 		unit_pages, psize_str, ai->static_size,
 		ai->reserved_size, ai->dyn_size);
 
-	pcpu_setup_first_chunk(ai, vm.addr);
+	pcpu_setup_first_chunk(ai, vm.addr, pcpu_vm.addr);
 	goto out_free_ar;
 
 enomem:
@@ -3377,7 +3386,7 @@ void __init setup_per_cpu_areas(void)
 	ai->groups[0].nr_units = 1;
 	ai->groups[0].cpu_map[0] = 0;
 
-	pcpu_setup_first_chunk(ai, fc);
+	pcpu_setup_first_chunk(ai, fc, NULL);
 	pcpu_free_alloc_info(ai);
 }
 
-- 
2.47.0


