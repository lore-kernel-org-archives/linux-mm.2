Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7810C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF80F6B008C; Mon, 14 Sep 2026 23:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFFD6B0095; Mon, 14 Sep 2026 23:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0C06B00A2; Mon, 14 Sep 2026 23:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B52B26B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:13:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4662140303
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:50 +0000 (UTC)
X-FDA: 85214527020.04.A5C6290
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	by imf07.hostedemail.com (Postfix) with ESMTP id 720D840002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NYjcGaMj;
	spf=pass (imf07.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.61.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqRyWUarxerox1+/UpOmKP1szaDVGaDMR23jroEMFj8=;
	b=hTxzXUksAsAUOnyTUdyAJv65eBrWngbjiGb+azQE2tlSbCFDwYcQHmzJJy8xaGJv+awWto
	fZkHbcqVzhb+XeHVSEOFEMaW/mgFhgX7V3bioh4PxqvPemPs1EpQ/T0fJQMJjr9durzi7u
	JP3slcg2FL29msleMQn8lLMzzRV/oH8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NYjcGaMj;
	spf=pass (imf07.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.61.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442027;
	b=5gsbTfn5O6y4thIYHnWSgfllSZ3qLFv6Vrj7KkZRYyNUG11/1D23126f2Urj0NZLgHTwvb
	2NSJiaYjwM1yfx2wtn7NCgukUox56tYiVW+RcgMi1aW3PUZzcTBx7jKxutPQueSUbLCcJZ
	2bZ1s5CDt2GadUV9OnhlamG04bCaH5k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBqX0MhONTAsWGCZi43m1LDhqSV3TFqEUErruxKKioVOW6/IPiR29/3quIW810J6xsEYyJcknpPE4EbeqQfegPl5l1OwQ58fdP6j1NLOXSndi/Bj7DJxa+CoaDNhW2YqFWGyPmj3vQ9OBqMveTY2dGBumHIgRWokIxKplLT2FC7EPZPdReVDXHo+rK7JesNRlTxepdsTeFYIzkB3HTfLBfu5IMDCu2gjpJrVQzny12YB4rVjGzLeSK44MxDbKrltCaiJd7x6GPfaEpA153D70J9nkkoCok7wtG1Ry/M7gPHl/8w/U1mvQj7zQRYxaiS1qFihxHOO/K2OMY68XYZ3lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqRyWUarxerox1+/UpOmKP1szaDVGaDMR23jroEMFj8=;
 b=VSBnw5qmfQnTnIHrZFYl5Nbb/n2d/DpMZi+rshg6zy1jSoJnwQpweUzcD14O8oAN1PY3+U4VY+pHiN3RYI7qHKy2/EmxaSn0uRbpipxnRKKbYC0KqLHGOtx9Ay/wpmRxsKfCAdb4SHAwuCH9aem51R9fKuYRGo9wOgy+G99rDVc1/51gfItPRiJUsH02aH1rHloPwvCwJQRuraoPTCiHLGfVbsCTgL90v6dWZv8BmOm+wYEJdBQAcH+lrPrEqc6aI/M59/xF6mTNkp5W/ewKkk4qazkw9usf1HN8mrTa4dokwAFZ0w0MatS0ql40dQXB28qkvfvhcFn9O+YJ1sADTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqRyWUarxerox1+/UpOmKP1szaDVGaDMR23jroEMFj8=;
 b=NYjcGaMj3if2jftwR5RBvlcyeThgu20WdTtiiP+qrc0QnzzrukqD5VELP0yOBOKSnBGuXRCff01nzwV3/ZUW0+oVZG7zk9pQ2eGkbBC+im+B+o2uUwrKTHkPbqHNP8hT7OPMA1PPR+uPvms9ep67AhkStFaKgfoRqRBssaAICD/W7AF/TC6hs8nu7vUshaXvrdU/TogUnuQINKCgIBj06orxrzj3axsNu4rBNO2XkZxZenmlUz0ms4ogDwaiOzN3e8ze0Mou7TAauc35frcwlrSMNunXBJjxfjAoT43LbvRhjvjF6wCJ363Lr1koQic2bFvWmYZJ2YxP59co9TaEIA==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:13:39 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:13:39 +0000
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
Subject: [PATCH 06/17] sched: assert static storage for wait queue and completion declarations
Date: Mon, 14 Sep 2026 23:13:21 -0400
Message-ID: <20260915031334.1194975-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:408:ff::10) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ebf14a0-690a-470b-2fe4-08df12d756d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	ujyqsv8Mqu+RzMSRTubhAvIjC+pSD+Y3sdRtDBO/n39giiuPlJMBXGmZdOEeT0I+leInLRB8J/fTyydAG54ZlO9PQ01owGs2Gt+xn9pI53OHJ1O9VC4BnrcMkQnV70aFYp84qp9gKRdVyIYP4h1bj9yv1iCY5nxvUsFy5e1prdlf00IEuzCTNqm9g5SZlynBM9YZ+9520ElXmjNVMC4KeJsPuxvbboDQ1Z59WPDp/wVStKzudDrXrmz92RrpxrhiBliGkUNnuWxXppHPMucEQdmOkJIA37JhkR9gEtVilGX9kXsCb47X4bneFV4ZVkQkR3QDHXMkeQc6pGNJm4m70VmaWtrQGa1V8qBNrpSMYtvVE4bd9gcgFt4RTiY3FxOT+rZ10l4Vrouo0NOh+mLBSmXN2MIQPhbyAWt4ScrB+V6rzlM8qRvU0UZJKE4Gsoed3bDrJDcuaUBOA6/nls0p+ajLNQMbsP34on3ewS+w93gCYarBNwd4y0p0bLE68RPpRZa4lzgfQ3vX3kgVzNOdmZV7U4wDCIsd0d1+zVDpASGjyWAzVj7TdEP0Lh0NS1j04L1y/pA6IalAB3kH/fMtOo9+01djFPtNp0jF2r+Vq2t9kQiVeKx9BmfBPgZGTmWpxm3OyZdYrgehz+kgCmBrhL3KJwYghxgNOcOB7U2pxTM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GwQ0nzLyGOSpnO4x6m1AwRPoycDPenQAJwOp3HCgmO5Rx4gV4cUTIyLuTjcd?=
 =?us-ascii?Q?e9WR7oDZjUm+rFdlII830gr8AF4UkT0qsgDgLBOfNu14emhfqlxd0GAEwwuT?=
 =?us-ascii?Q?ScDvP+lrwLY4/p+kkGmVlWqV/nzIdBHkR1z6IP5UqF8bIl7GJQQVeHSj/oAS?=
 =?us-ascii?Q?J7I8o0vI+BLZSuu50JuEbD53ThufULWIZOMi1rcQLlfg8BcZJJs7N6+kyQmQ?=
 =?us-ascii?Q?F6uyrxJqA1kW4xDrPIr38rL4cHrtJE7nv46rZuszNdk5bdQL4JFKrO4bx+oD?=
 =?us-ascii?Q?AahxHPpwRvTDb5DSAWBOXIrvZmJwyTx6yv2nm+fyCOJN8kOpRWFoJg0xGWqO?=
 =?us-ascii?Q?Ptvx2NhtfdTbIuRnwNNrzi+BwG3Rv3Lfyy8+e+FDRFgW7jmaNENrR1D6Tt7z?=
 =?us-ascii?Q?Vq0VQ1TbjnN/Jp9jnsHWcZh4j8YYAubQppTfJV9zQKiGbg8/vUoaTqMP68h1?=
 =?us-ascii?Q?LkDnWEqu0vwpb3hH3Dh6NfCR1nVQqW00tkS7aCmHc5Q322SYRoCTtHd0b/nd?=
 =?us-ascii?Q?wunSVLuaycrodKAfirqbdjgYihzUxAtIpPR4kdi+5LCEtI9fUId6iTaYwDS1?=
 =?us-ascii?Q?1wGHm/na81xBfd++O1DCOOGfwjtk6+1cIT11pkYVH/e/q6X8pRran74Mqnr5?=
 =?us-ascii?Q?ZdO0xAv0jU+kxG+cdcqJZE2kwnbcbHKoJx2mheXFKemjfi59Be3CkeySOf5l?=
 =?us-ascii?Q?DS/mir8udq3wnPvC6HS3UoOgnW5U0CIld3wCIng6rMyDdjC81GUqKuFpWPVV?=
 =?us-ascii?Q?gucji7rT7s+1MaxdRVPfPKX2MXeDHABrQ0QrkC64HKlyiLgeF0cbDHUO51Ho?=
 =?us-ascii?Q?l08oQKEUrpzNdZGVR5vaA5G9iziDxRtDYQ6qWpBSVoANR9BPTUr1LGrBq/p3?=
 =?us-ascii?Q?U3Pi+BOiy8OjuYInqvEQuawTjl5dFKEQNeSKNLF/ZNtVoAM7SxKOVjbO0CIo?=
 =?us-ascii?Q?k7y1T2IKO3tAYcedz536hm3j6JdmbQCkn0txfmzhmehYURRuFC71BC4dQrK0?=
 =?us-ascii?Q?bgiO+sQhzoztGVHHSWr8/46zAVf2oxXjPncGGnK/eGCi2TCRMIKYDcRj+8aA?=
 =?us-ascii?Q?8D0xGAGI3NGb/KqNcBlqrE7aQMnt7J31ChB31+stDYacjDGaqVU9UK7PbOp3?=
 =?us-ascii?Q?laniq/gvDP5by/IOG27WvDojkAfJGCKOrkZkJBaevZb3KpZoWYqk8WJvZBRZ?=
 =?us-ascii?Q?WYCCA41A2yTX4IWouzsC8d73PwmyT6VLxNcAEvHtB6/Td6h0PS7xy9idrqs4?=
 =?us-ascii?Q?HpFVrNc/5hSFQuZ7hMCjgYWkv47YmABqg9f42nKuKmSwnSGmnxu3CqiqXgRp?=
 =?us-ascii?Q?FJfYpiwC3wGAEyw9ORk1zyYwTsxQEgiUNPwpt7uww8j5XSBVBTV+stlM/8eK?=
 =?us-ascii?Q?kxQLN1V9F0M/VcxOLr+ZxZbPAolOJ/m8cKN0JRTgbe38UxtlnPl/yd74pOr0?=
 =?us-ascii?Q?LdsmVAEMJsiaQKInhwc0MZuoU3TYzRTAhA04/053GvtsEWmHMd5yxeLZ2y7u?=
 =?us-ascii?Q?HHOz8/K/vXVTugKwbvtXr5IZZjRo9U7css+TL48ZXQM51JWr+9W11t8geOYS?=
 =?us-ascii?Q?hVf6MPEPqFPudEnPO3ZJ2blf8qRS7/ImQ095AbnaiCDC7U4YhuSV2iCNV+0Y?=
 =?us-ascii?Q?B1l3NKRnjFNIhNbSax6EznsrNVpx2PjG/sDm2TI6u0HN4Vs4yEwca6KQtej/?=
 =?us-ascii?Q?VeuZ/FgvO8WIXjbzKuVUmVYWaesHFsf2RL7CuHKj5Bw4q7bOxbjsS3XUDxGt?=
 =?us-ascii?Q?DKj8XDP93w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebf14a0-690a-470b-2fe4-08df12d756d2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:13:39.5945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F227rWTftCNds1bLAmXuJ9ypEQHbFJoVXfzgyM1if7ZeV0RA0vWTuPu4huoGwpJJ7VX1izhWmxwACme9kZ54Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 720D840002
X-Stat-Signature: wsshy9na57am7nsg4necmawbkizioenu
X-Rspam-User: 
X-HE-Tag: 1789442027-395299
X-HE-Meta: U2FsdGVkX1/vvaSwQtsdPq1t+AlPk+9FHdu0XOln6EF2QMzRcREYzel6aWAhpWbcuKZqTDsEMJVgPx7Zw5ZpDIo/63Je5SOhntDC5eCdUQj0psgUVbzf2XOdvzoX9C0nDeA7b9AM/2VsNOA/8Ng6kty/xIGl85IKDh9OT5MfUHb35qxA3M+gJOKfCvkYWZRCM4m5tSU21aVszhDBwXyKue+uHszHYIqlYbQq2N3zQJa+mBYClCHIn2GgnbMfZ/pGoe2mRFqlhwFJJ9thlbplyH8OKaBqq7j/4f2lbRilTZ2hAKUSIciGVR733OQsWkWpBbse1fpXN9YJFP1Ey67gotJUuD+Wf3AenCugXX8Nh8xP1iS61QVMWHaymTN/dEt1bXyZUNd33nDnBmtLjZxQBZKQWmzg++/BDUErMCipvBUSgHHrTsVxFpcg0dhbS05XPQsT7ADlNzj1pAViWd9ItLcT1sgQjpaZnvZaYVGePpdp08BY7Hx0lEd/C3HyxmAj4aseEZL7NezlRo4LSM1j4g05Fo9PwTr9U0P9IiCPP0xiyRdRNVnjemApDp+RFabw5Lavw4YV9Ysb/GoDU4RFOlPkyCsSMcfIy+fTf0QwhVD9IWMEDW7wdONK8pFIH2pOuUeV/iZiHwoTeXaFeagEjyObcDJ6W4QtcnCcujm/7jE19+0ELy/Qfy48zjfbxSm1en+eCVfv4r511A7X68osAMnvEMGxWZW26Dc9DxJtmoWh+SvHUOy4W8xFoANUpPqmv7IXhtWJv5qnOAlsSUEso5/eWtUKdtnjKTnQBPObbZ6FEEOWnTdPaQyhJ1uQ+cEnU2Xa+V2fDx77TM6M0SlVNh2OfsC0FW7BcLk++nZnhNhsaYCkzUsuOijFzrumjO7fGXRLDazfNP+BlWiJFjNzNAl5TE7fQMvKpvsOWBxGqADImyZ22VNH1YlQZu5KdhRpe7WuBGYdkaCuwjb8BlK
 XtiBFb0g
 akdc/T9LUeoNV5mS/bVWvuVSu/VUAdfYveReQDPJaOcP49QaqUhcsYKugYq0e1hzAtnUGjJGbFitXukqxkpDpHMzoQytS9qAB50RlJwdGXbf1oxCdSNgxf/dTVNADaGlpBSCyRHbModgnQccbjLEZTe0D20sTr8jzfopDEQpl4kgd2p7K8HGErXlzqTohqLvUxGewsTORmjkpFNZ3voFWsnjDMBLr3hepBfi8TMqYbmyg9km6BzujdkAIqrUef3+NNzDlDx7z8IWqudagpaZ+Y+lqeUL9VO+KMc0YBLo/JqNaHa560gzrc2MQ24bDH+UASOGiBWStccNU2S4q+iol1k63gGOGb7dUcZpbAM49L2GqBenCTbr1sWyf8g92SMMBNc7Czqk9cKVxo+wib/ORC1kBbQ6ZunoMgcVMO6Map/jUFoQaCy+8FyMA5bK76hAiGeIvYRbd+rqlGmiw5y6VGqZGOi/bnbeN/LrlXp9qCj5lk3jaPtJWzo5gBbvsPaAz+2frylL5olhweDE+dhdwH+V0TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ordinary wait queue and completion declarations statically initialize
their embedded locks. Automatic objects need runtime initialization so
lockdep receives persistent class keys.

Add ASSERT_STATIC_STORAGE() to DECLARE_WAIT_QUEUE_HEAD(),
DECLARE_SWAIT_QUEUE_HEAD() and DECLARE_COMPLETION(). Keep the _ONSTACK
variants usable without CONFIG_LOCKDEP by expanding to the underlying
initializer instead of an asserted declaration.

Convert the two automatic completions in the AMS PMU driver to
DECLARE_COMPLETION_ONSTACK().

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 drivers/macintosh/ams/ams-pmu.c |  4 ++--
 include/linux/completion.h      | 10 +++++++---
 include/linux/swait.h           |  6 ++++--
 include/linux/wait.h            |  7 +++++--
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/macintosh/ams/ams-pmu.c b/drivers/macintosh/ams/ams-pmu.c
index 1c3ce39e9a59..046a7d5dc5b2 100644
--- a/drivers/macintosh/ams/ams-pmu.c
+++ b/drivers/macintosh/ams/ams-pmu.c
@@ -48,7 +48,7 @@ static void ams_pmu_req_complete(struct adb_request *req)
 static void ams_pmu_set_register(u8 reg, u8 value)
 {
 	static struct adb_request req;
-	DECLARE_COMPLETION(req_complete);
+	DECLARE_COMPLETION_ONSTACK(req_complete);
 
 	req.arg = &req_complete;
 	if (pmu_request(&req, ams_pmu_req_complete, 4, ams_pmu_cmd, 0x00, reg, value))
@@ -61,7 +61,7 @@ static void ams_pmu_set_register(u8 reg, u8 value)
 static u8 ams_pmu_get_register(u8 reg)
 {
 	static struct adb_request req;
-	DECLARE_COMPLETION(req_complete);
+	DECLARE_COMPLETION_ONSTACK(req_complete);
 
 	req.arg = &req_complete;
 	if (pmu_request(&req, ams_pmu_req_complete, 3, ams_pmu_cmd, 0x01, reg))
diff --git a/include/linux/completion.h b/include/linux/completion.h
index fb2915676574..b514b5555722 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -9,6 +9,7 @@
  * See kernel/sched/completion.c for details.
  */
 
+#include <linux/compiler.h>
 #include <linux/swait.h>
 
 /*
@@ -50,7 +51,8 @@ static inline void complete_release(struct completion *x) {}
  * variables.
  */
 #define DECLARE_COMPLETION(work) \
-	struct completion work = COMPLETION_INITIALIZER(work)
+	struct completion work = COMPLETION_INITIALIZER(work);	\
+	ASSERT_STATIC_STORAGE(work)
 
 /*
  * Lockdep needs to run a non-constant initializer for on-stack
@@ -70,8 +72,10 @@ static inline void complete_release(struct completion *x) {}
 # define DECLARE_COMPLETION_ONSTACK_MAP(work, map) \
 	struct completion work = COMPLETION_INITIALIZER_ONSTACK_MAP(work, map)
 #else
-# define DECLARE_COMPLETION_ONSTACK(work) DECLARE_COMPLETION(work)
-# define DECLARE_COMPLETION_ONSTACK_MAP(work, map) DECLARE_COMPLETION(work)
+# define DECLARE_COMPLETION_ONSTACK(work) \
+	struct completion work = COMPLETION_INITIALIZER(work)
+# define DECLARE_COMPLETION_ONSTACK_MAP(work, map) \
+	DECLARE_COMPLETION_ONSTACK(work)
 #endif
 
 /**
diff --git a/include/linux/swait.h b/include/linux/swait.h
index d324419482a0..caa3028d1dd0 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_SWAIT_H
 #define _LINUX_SWAIT_H
 
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
@@ -64,7 +65,8 @@ struct swait_queue {
 }
 
 #define DECLARE_SWAIT_QUEUE_HEAD(name)					\
-	struct swait_queue_head name = __SWAIT_QUEUE_HEAD_INITIALIZER(name)
+	struct swait_queue_head name = __SWAIT_QUEUE_HEAD_INITIALIZER(name);	\
+	ASSERT_STATIC_STORAGE(name)
 
 extern void __init_swait_queue_head(struct swait_queue_head *q, const char *name,
 				    struct lock_class_key *key);
@@ -82,7 +84,7 @@ extern void __init_swait_queue_head(struct swait_queue_head *q, const char *name
 	struct swait_queue_head name = __SWAIT_QUEUE_HEAD_INIT_ONSTACK(name)
 #else
 # define DECLARE_SWAIT_QUEUE_HEAD_ONSTACK(name)			\
-	DECLARE_SWAIT_QUEUE_HEAD(name)
+	struct swait_queue_head name = __SWAIT_QUEUE_HEAD_INITIALIZER(name)
 #endif
 
 /**
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 7e215330199c..5c7d49187396 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -4,6 +4,7 @@
 /*
  * Linux wait queue related types and methods
  */
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
@@ -57,7 +58,8 @@ struct task_struct;
 	.head		= LIST_HEAD_INIT(name.head) }
 
 #define DECLARE_WAIT_QUEUE_HEAD(name) \
-	struct wait_queue_head name = __WAIT_QUEUE_HEAD_INITIALIZER(name)
+	struct wait_queue_head name = __WAIT_QUEUE_HEAD_INITIALIZER(name);	\
+	ASSERT_STATIC_STORAGE(name)
 
 extern void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *name, struct lock_class_key *);
 
@@ -74,7 +76,8 @@ extern void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *n
 # define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) \
 	struct wait_queue_head name = __WAIT_QUEUE_HEAD_INIT_ONSTACK(name)
 #else
-# define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) DECLARE_WAIT_QUEUE_HEAD(name)
+# define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) \
+	struct wait_queue_head name = __WAIT_QUEUE_HEAD_INITIALIZER(name)
 #endif
 
 static inline void init_waitqueue_entry(struct wait_queue_entry *wq_entry, struct task_struct *p)
-- 
2.53.0


