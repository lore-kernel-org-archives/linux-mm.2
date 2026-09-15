Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C324DC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E978D6B009B; Mon, 14 Sep 2026 23:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E876B009D; Mon, 14 Sep 2026 23:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA486B009E; Mon, 14 Sep 2026 23:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A26486B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:04:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 067CF120309
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:17 +0000 (UTC)
X-FDA: 85214502954.25.4C32F3B
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by imf03.hostedemail.com (Postfix) with ESMTP id 37BB820002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GwIForsv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GwIForsv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789441454;
	b=Geb6yO/tnhkETYdb/NhIFsrGo56XxYdJhXZdrbYG4faOS678bCzWvdutYdYo/pz3VVUmR8
	PGPZtiRkiCkDFWb4jyN4BZYQbBc9TXDh53MnU54CkKjA1XriBNEvhGKZkTNSUP54tp3pQc
	ssK6A86/TPzuwu9Mm+NvbrBmvwwlOpY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789441454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCA4zzDzjR539e8qB1+O4l2WvBXUBcQjWYhI0kLBBXM=;
	b=kVycJSx54wNTrhTqNvT5E5UXyu2asxZv/JIdMvnhDX3hcZIAVPyXdKCSRlKtpjEWD01LMi
	vJo80k3GKweNr0DiUDvJX7NZ4TICfC3HJPHSO+M9/MgP4dvvW3HiqCFk4lF3fzr926YhOP
	1S4E2pPYtK0Uw6g4bZPU+hUYL3xeX/g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+iycThGFGQ31PlAhgLrWphkamlutbXRChZ0QnIGr6AB82JtcNzrjQX0lhNn0xBxmrTe1sUzU2fRfCBnJ6UtjEsgN/OHJ3H7t7ErhbhZ8PmTGtq14z12yCL9iL0DThL5j3AU4YCJEVc8i07m97ut8PH+UBqUqtQRvpu2dKYOuYXeXxDjgeYBiLaluSILCiFwz92Bsl8bq6kbYmkm/ExYTO2pvqgzZ19Bhg0AiPoQqWlf+h+y5Gq3RgBF21n6+zX9gwn+KUNHM1/5kXx8NDycN1KWYI7JX5GLW+yUCNRFbwNBzoDdt4K6VBzA//A6gMrbkbfXWvsyKN6Er3Ub3uYGgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCA4zzDzjR539e8qB1+O4l2WvBXUBcQjWYhI0kLBBXM=;
 b=EH+TIjvDacpNVhgE+0lWmz6shk1B08nvOJYT4FNTJ6zR5jts9o85obYGT6l8EJrt4wuJbRF8xrzQeOwmbgcbsHSINDD89hY6t6mpYmlHucE+qD0FKMyObNPYTD5qgEbvpWqIUB21CVnXeO9qOlQv5BtISXIJR7g75Xf+4i747Bc5JELfGTKI7AI8tw9ZuI21U4F8WR3I9yX01vVCyGGSeGCXjXg1iMWG7HD+3HYm47DOZkSN8kJ3zOQqYzLavA2VzvRTRyJTr38bApK1j5lNz9XlUhJoo63XCHlbP/fPRjaH5VQ5qYq65V/qcVuepSl7sTTn5i8rTMpkOHVcEMglGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCA4zzDzjR539e8qB1+O4l2WvBXUBcQjWYhI0kLBBXM=;
 b=GwIForsvvAmzthDF2ztbtVWSMOyzF6/ROfaDEkaRJgsnlUACXWIwqXAQW3hXehhf5L82ooMtfFveY7PeUnkuWlKpNyGQDO49q1K7UO2CSKRgogAtNFzvyi5CYMNUY+ke3oxXuaFuNLy3h1SRI+otPpYxNAMeQJUr+dIysKQRmY7pLFEhHfU8IEDcUSuy2F/ladoRbUnZV6+SagVaTGF3Tme54ScYbP7kvfYb2BJYoe+Rl/oamrYU7medz+bdjyYZt+2aNbXNyOp9fIsZRfaaY1ekZQmCADbFgGS+iUzlVv/AOjK2p4IHTLtDOep36YGQhMoetDKMpxjJDp+qMW0+fg==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ2PR12MB9008.namprd12.prod.outlook.com (2603:10b6:a03:543::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:04:09 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:04:09 +0000
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
Subject: [PATCH 05/17] locking/seqlock: assert static storage for DEFINE_SEQLOCK()
Date: Mon, 14 Sep 2026 23:03:23 -0400
Message-ID: <20260915030336.1192299-6-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::10) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ2PR12MB9008:EE_
X-MS-Office365-Filtering-Correlation-Id: 59987c62-6fe2-46bf-f359-08df12d602bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YF9Y6lUKovTQIoQjRjvN1Ul7bNH3Z7xWjOeTZ0X7BTfHyeqMWFgNxGQ7NKNqL52a7b0HYVcjsHeVTn5GGxf2Tsb/QAIboKhRz9zCvhFVNmSKLj87Ek/kPB+IeJAGbRKz7QHwQHTDMHf9yMDnuxtDTk6NSS1t8qkmMHSe3CO83BqFdnwMk3wjv6+/YUUf0NQg6iy0AbnTCIVz8GC70gbDpv5ShM6S7MaM7/orKbKyM+x7Tr2zzlLPlxmy8bvFK0lcIXjXRelwSoh34hK3+yB+zcq98GTOvskba33HeDgcbb/BnLxg0+cT89aoohLwT+hf9dEKUgevo/mCTsH5e64zo9b2AqC9NWlJvd3PF/ch4tFLhuaWN2s1IPGPx81kdUUggvCbq+I17yNyWtOsAgd6RI74SoqnR95PWIWw0WNCWKwWK6IyrFf9+7ZdMt9UFqsaSVuQeC+dQSGHRhuj/e+u/N9AuQmSPqBK3QS2u/1YtZJfipyLhWIU2P/TFT0HO8oCn6YYZvRy9srKJenZFitmmg4fMkh0G4IMN2WxVxW+FSYT4KkyJEOtopeyMQfAeAurHid1XzKS+puQQtVUQGSlZqvp+Pv3uRulaHqC7np7FnpsLZeAalGNWETeJ3+0ed2ameNZ11vIUsRJjW7NVFyZAbKHwvsAP2/sPLCxzGYX2nM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vgZApla8m4K0VyKOltDCiW4rqnb+RCTtbvgKtZHDiI/kS7jHAA0jOI+l9z/2?=
 =?us-ascii?Q?52CIrx1y3y7aCmgqvZ6MOUAf8CBPjQDxJTyeTbc+ook3fHcjjzWUjZxsrETP?=
 =?us-ascii?Q?zRhWIokNwU2W23LgxTLULjjOR7Hz0NwWIJ9KK6vYnkMPAqvCjKmFrC8sEh6E?=
 =?us-ascii?Q?lfDAjOAWzqLFLFNfVXuyBp3Yq2NDr8eckJN1jblRgT+GGmkj1eYmRMeqYRnT?=
 =?us-ascii?Q?pzDl2rko1xDyXpcDSlsrEfsQHjg7hcbOBTLbdfmmGm9NTUou19b9ckGGpIAH?=
 =?us-ascii?Q?B5eN/VfuOI1VnOWnGu8YFb9TMenuyXzA8F1BaDJOGVtanryhwgfQPhvueFdq?=
 =?us-ascii?Q?ohcL3lOgGw8zgkD5z22up/XQircUXCvj8c3Dvu8lHcyo5Pcbsu6t35bQ5nyO?=
 =?us-ascii?Q?7J2SNPGe6degkQNVrm+6GOFC9PQC+q2Z21fd17l+SXprYgjcc/iAYCOnQU8L?=
 =?us-ascii?Q?eIkXq+0uk5BbOldOR+avApPMEt6sVBah9QRsJxhbEoFU1m5P6e//2le6d+Go?=
 =?us-ascii?Q?Rhlxu0aSvbbJVXuu7Rll82FJhcM0AeOdejvBvE3X8pOuvGpCXwPFez2ehwxa?=
 =?us-ascii?Q?OjnjuOiwrsBzI79lqzJ0Lm7dDBFW2mPc5US2M5MqqMEioHWd/seSPZuFLi7e?=
 =?us-ascii?Q?aEVLsmya5JNfs3eofXkcLt8e3FpeIxXc6voMOvyoZIol8ukxsWTc3EYbMIAr?=
 =?us-ascii?Q?tRK9HkCDiAFYfAw9tjHCfP/WrVHELt1DBUh98gdrjIT6FiS4DUncoFDqJ+zi?=
 =?us-ascii?Q?iIds3RCs+1sH6T2DNaARYDYlNfe651cxwPma86C5F8NiBApZXMjZ57bKYlZ9?=
 =?us-ascii?Q?77bkl4Z14R3bkxYrwmqHLsbWClJuaP6GjyZ8Wi0mrL9a0sjRu2eO+CyyRgSO?=
 =?us-ascii?Q?gE7MvaVGoL8Io4Ku7U0lBGYUCi6eHTEb5vZL+ARe3CqQCXzXWI+5c3OmDO1Y?=
 =?us-ascii?Q?g+s8nrXfEHTIMOv0Qq2BxM/SeVtYztgq5CrBLvW3eZrE3Eox0jZZZ0xj075O?=
 =?us-ascii?Q?mvJ/ao7KV3zEO7jZQmJ+PVxenGok1G5txQZ2d3D4EkGVzK67ohnetfBURMOI?=
 =?us-ascii?Q?cdUIGLNUWzVkD3Tf9T7cvnKqRWg8z4ay0y3jiFK4R8xsIl3Kd+gTwknJHhv7?=
 =?us-ascii?Q?iuM/3MMY04lnrrfNeN0Dm2nMUfhDqZdyR5hNqONly3NWEYP+bf/MQU8WXSu9?=
 =?us-ascii?Q?ritMF3BB4gE/yHe0p4mY/VnIthv0T5Do3zlDPdAz3Nuuy/1+IGz3Ztq14Vn+?=
 =?us-ascii?Q?bJOZO0LdCGroKcVlKnKy1SG5nNgEyj9yznNi9tav0Tui8ia2m92YSR1CYaDb?=
 =?us-ascii?Q?kQwmVq+e57/4TUsHJodkiKo74DJEoNmIzhaZuFj7LnZiSQThtCi4uXQzD/DZ?=
 =?us-ascii?Q?zkO9y7EzUITTkYgFCVpdSYmR/lRzPDUTavkabhEoY128qwtv+D4mpBdkBwwj?=
 =?us-ascii?Q?oyMH7xIX7SMX1d10y9F+mlkCUuhY1F5neUkJTtEisCBCeIaTgFObqcUEo5Kn?=
 =?us-ascii?Q?MZgnn7gkHudEfC5qXFbD0XwrDrc2HVZ3WfDiCnvc47LnfQJUW9652TAl64c+?=
 =?us-ascii?Q?RY8wz/UdFz0Rjfn9nFMWi8plyRRWt3zLU+NU0FzYvTGvNyg6z7YHn4YPxlyl?=
 =?us-ascii?Q?6EchAXx89tiMxG470HKpctscAbPhCsuCzV2gInga8ijYjbxoNfY1d0hwEZkT?=
 =?us-ascii?Q?XwJY9ij9DuPblkV/5E9Nqn6leGEV1s1gQ5JlDQVoMtcYemw9JThoWEqHF2gj?=
 =?us-ascii?Q?4OelspuI+Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59987c62-6fe2-46bf-f359-08df12d602bc
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:04:08.9871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DMiNxxLAZvWgMVWVKoDdblLRW8aEV0p/dkTaj2U2VB+LCpFq+rt2f7iGbxMGf+Ky9mALijsaCsH7YQZcHpt52g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9008
X-Rspam-User: 
X-Rspamd-Queue-Id: 37BB820002
X-Stat-Signature: 6edcns7t7xbcy64qkujia3fywc79w656
X-Rspamd-Server: rspam01
X-HE-Tag: 1789441454-794101
X-HE-Meta: U2FsdGVkX185Vc+8l/UguwpGI6ASBPYdFVqCl/n/qB82xJnK9u68qNym0Wu5WxxrDxyFefZzITemvJwl5UWBy85iwB3xrZ4oB0aoUzoQMVCiUTgVKwRi+BU3dJ7l4L2F5ELTyFQeX7DsXhn1y+h9cLotduXHEpCK19HC7aSGe6mxWRgHTDKq8sqc3w+v6HoDEe+4604UvL444SmYpF0YlefHZzfQa074NK9P3EEjl+FxrpC1IUDQWNCLxysZIIlLOm9dC+dEpsRRfdMjVqjNyF3UuCbsOoQumJKEZBe5YFQmM7DHksWYc+NXUXkgq1kfTtAKTSLyKUoYvCdmvbPc8BnGGlUnv77xX2oSJzZKjTOx2Xp2VHkS0HpCDYF6qhRZW79qoQqPQ6GP8yaBRhRQngNHja28qpQoDSjat6MdYVyimyaMYVirsB6sIJ1JJCJUAumpVMWN9bH8ZdIhh/MuZsnt82NoAz6eRpJYGh+yF9Q1VpjRYcmW/f0OYiuifZnLFD+A7qIduTghiIdH6HZQttjwLExG+lJIJllr6vdEpPRKRTPzP+T3XvbogcXmihYW/ae8GN9ytqZKsv+b55kRgX0UdOCgnEfFmHWm4SBeJ0Dh10PJFRJzW807swnPh33JHN5ebjQzIeB0TxozHoNpiQhtmVyVLKmRcBZNPtw7ng6J9SnSXKIiBjeK3kj4oxge+2PMIOTjhWPpDFTdwkC0t+YYsdIeO2XrWuEdMM8cw7qb1xAnLzA1FqLFc6NL5bjA6bggSmf+Z/vJBoht6pAlcOyE+uzUDcfGKTsWPj1bDEUp0XCxtWvrw3y2IW9Egg7Y7iJ+nU990BH3iths6tO+0Js2c5cSsolMRjKTyPSuj2lvEHMJzsz+B6SmzKSsipb3dtfTkiQOJ+lXf8IS4BUToYwxKAr0+AJ2PHjMT5oHAKpSdSdHaBCbu1c6rYsywtaWrsI4y/vZx72q5LfqWzi
 P6Wo7/hc
 a4bGVy+VUZhoWKFImyLIfevLlMr7GtyuXmQpFGhoxsE4ZElgMlgT2ZLTgbIgGoWRLF9Io/rOrqQBUpNL/XArY0cU4Xp2MHN4MASE3TtUT8T05iNK6kxSPegRxdNH6CxooEtOqdHl73OTOBZ3DIawsPwDlvkNSmMHJavunU+6q9fHM1JnS8NAqk3M6+kkBDq0iZRpRss7SlB8hVSurKyjw0LzlQQ3/ABUmJ+UKFT/a27kzLNNyBO6BiffQVIRo32UyPrblkNHhNL7VP31u+ZoaQiidkgo+jrfyhrhVCQKV1zkuTp+/Sn54SHYVUXhJAwSfcGG25IzcSFOGNJaYTd1TYGqvvq/fU3DDjZ6ebeGdPISqNu1I2umCD0U9UDIFS6NMbCwXf1Zs1JbI4axvxHDTzcymDNOLA0XYRXOj8M7QQl57Qg8Hc7G6VySvuK7mNPc6odmWFLYzVA+pT5ofpbLDD9X11rDWm94CM5HMCht8LygN9rz7j/3KCKm1t0tzBctaF0bNJMT3KJjVjQZ0g6bShqZd0P49cCfU0s9+Yzl/T2WwQPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_SEQLOCK() statically initializes its sequence counter and spinlock.
Their lockdep maps require persistent class keys, which an automatic
local object cannot provide through this initializer.

Add ASSERT_STATIC_STORAGE() to the declaration macro. Automatic seqlocks
must use seqlock_init(); the underlying initializer remains available for
embedded objects.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/seqlock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index f865491c4f2c..2aa793a45213 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -824,7 +824,8 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
  * @sl: Name of the seqlock_t instance
  */
 #define DEFINE_SEQLOCK(sl) \
-		seqlock_t sl = __SEQLOCK_UNLOCKED(sl)
+		seqlock_t sl = __SEQLOCK_UNLOCKED(sl);	\
+	ASSERT_STATIC_STORAGE(sl)
 
 /**
  * read_seqbegin() - start a seqlock_t read side critical section
-- 
2.53.0


