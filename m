Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FCAC88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB926B0096; Mon, 14 Sep 2026 23:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066516B0098; Mon, 14 Sep 2026 23:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4136B0099; Mon, 14 Sep 2026 23:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8176B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:04:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57183A1C10
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:11 +0000 (UTC)
X-FDA: 85214502702.15.2A75EC0
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by imf03.hostedemail.com (Postfix) with ESMTP id 772E420009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e1R6BrHx;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e1R6BrHx;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789441448;
	b=N4TlmuR/aNzxcrZrBKWM0MWUzf9jyVQhq4irnq74YoEdasmrnBNeKAytdkZ/4Pa+B8hecQ
	OGZ7ISJBBmJ1RAuZyI8gpLqQGijYCYkEOCGFewBud0cTuEkqv2BxEZlPFeEIhVt2yCNaSy
	bGsisak2blLmd7fENnZi7vn0yeIGd/0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789441448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNPbKRyhs71id1HJsi9Z4YSUAMCDkiufWj4RbyWelZA=;
	b=wUFwP/gw8C6PfDtooFIVONs8AaldDEvXvPap76R+lqoLVoEC3YEpoATDR+LlAHdNUPvj9V
	dxG+rfdZH8kRbemrs7X7Up+2oENTAoPkeFpG/qM+nSWCmH4GWVoo0A9Uno3nsh3IebXXdj
	P4r7MgkarS99cKAZvWGdhxVHfFPZFoM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gqmIpA7gn21hu/egX9ZaxXCp4fKmJ5wxBNM5TKZmeqjhhNIshTvuGiz8HJ+U5yCtQPYsHulYy7pp3pnz94VikvTT3lwfkeI+okq8yg3mWImpgd3PtH0icxd4mU30N7iOunjhaBO1KB5b4GNb3YDv27bHj31ZsgSQMWcwtxwF+L6hXvELngqBe4FJngC14OfAdbzDYNfnYp+70JRVcShRLA0H0BN5zMPWUNZnfNlQ6IVRKQfL1jXUIFufnhjfd4lbskltOBUwWzh8XryQScu4e54YuElob6KzuZyNZam/BspEVZt1g/FInmMgrDncOzYR+u6f6vM2Rc4UUA/GmdsUCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNPbKRyhs71id1HJsi9Z4YSUAMCDkiufWj4RbyWelZA=;
 b=ksAlXXwf6zDFL2PqMGSuMtgP2fY27hE2muNFtH90apSLLJZxLcb0Kt036iU1E4Da8YuH9uXswIvpQPdd9U11kqK280GfqSEf1eKsdsixwtlpT8lZJajKO0qHhKJkEV8b28h/PKTdD9D2p+7tPd+9XDNwZOVHcSVhI/OYCqDIWl5jAg+Q4aHaSbG/ltdMgggBrqalezFJBpF2Pz9+62kZ2ZKM0+IELuUNJ1pRqCNGRhY5+RShWPWP44OEApE11XQNad3n7yLJ/nydzVdyF1Bfj2HDdukvo8QSuk0eqpsR5uRCAOAcpjW/xDKvmIpE31l0xLP/7ei1kZ9pR1fazKxcQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNPbKRyhs71id1HJsi9Z4YSUAMCDkiufWj4RbyWelZA=;
 b=e1R6BrHxwVJvdrUJlD5eoSUJxyYRKNoO1MDN1AWpgbjM4EBOlU1JpAnqqJ5f5bFXqMB3UgBZt15syYjQpGez7nO/aAAfw2zSAfcCofY/4cB+fj9hFejX4Wyt1g5sjRTIalAApCr6WML+F0iY3g7vBqzL/Kv/pzJuAfadV8Wd1FShZOteNvq4iZzkhznRkOic4rk4k0GKHRdO7HyIHshHrTfKd8Gy5+QJUG08d1k8kPlYZ5orOG7PUglqmhhQquTow0XPZbv3W6adS2ThPtAoRGeBo94B3pTadqk9NS3jSw67GRzINGhxkBvKmOp7D4J7ajnmCGcOv/xhXYVlotINlA==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ2PR12MB9008.namprd12.prod.outlook.com (2603:10b6:a03:543::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:04:01 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:04:01 +0000
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
Subject: [PATCH 03/17] locking/rwsem: assert static storage for semaphore definitions
Date: Mon, 14 Sep 2026 23:03:21 -0400
Message-ID: <20260915030336.1192299-4-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LV3P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::27) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ2PR12MB9008:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e2c159e-50b8-41ba-d826-08df12d5fde7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	D8cm5BBi40lOb9KPyoeX2BUv0p7DeHN6tN6fivd2g6sEgnDbRTUrKrAKSkGPuBv+uk9IJTAxPF42SVx52pq+XwqJKilp+Apd51PW5ZLYlMEvgcVewCn4dugwAoFnKzSMqYStuAnKFA2n6zp5Rq9Li+OhrytyszXRKduQtubMlCrxuBX7YvCHJK0E/7gNYmoMLQgqV7zgzmBVizMRQwMDw4e0bAGPL/5itMGrnZVQNnnjs7H60gdApOso7+FBRvX+Sz3TVhgPEXbUqgNoA8SO2mSAX+hF/vo5nQGKBBvrx7d3uH72jLfsF62j/DukSdG+JwC2vqU9lcubxudHZ4D9xr3VD26TJurOAjKSWw/i3HkVSNpBO8mwTMmWx5kk31W6iQgP3S2eLVojqSN3Ck2OA6vJnWJtx/dUeNkzHc0itBU197LT7628n3E6mc7iTb0dEvWtniSTLO39bReFVRpA67PwnTgc1TjM8eq3u+0OMCpKhZenyGUr8JPK6bUN3bNGLh2O5Rw1Jh3YWrkcwOqTs8RVhY097Yf51MKuHZb/v2kjgnIob/DNWY4NUk5gGpLofx5xoEJ4k0WbBkgmMyk6hOO3UBMIp+Gb6MVYeKwb9T/fYTRBauLGN75W08SSg/lRzDv6Xhbbu642rG/TEoMq8DXQdVfZ9/Q+9+wWns7FOq8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jBHyy77KwjNY7+nmThMXTKFeRZkEqpz35COCV/XXxVBoQCUeQnWM1N4p2LiH?=
 =?us-ascii?Q?VC3mpNKVL9Kh+5eVG8LiLkpSqqH7r69cDfisO9+AlcfdH9isblAmZgvsndG1?=
 =?us-ascii?Q?vBbuBuGvDeu4CcZ5EMNOsGtgIoa6kc6sfMopgT9fefSVPx0k5aOSRaC8swVp?=
 =?us-ascii?Q?pdhuyu9Z33ZmqB/5NQmMkKQcKK9eCRtzg3zriqbyoJuY0Cx3QD0JSExmtN5z?=
 =?us-ascii?Q?VNFnM98Zx7f/mDRUZAPderNzDIx6/EmGJ4WLmYvDn1tlB+fHKSdemJ/jaLys?=
 =?us-ascii?Q?87khFpZM7291qPLC61PVwT2HztmRL6S5deH0AFxaU28esNwxAwXl5ZU6fLqe?=
 =?us-ascii?Q?rNE3YJk5XLYga/tA3w9Vhjgr1h/gXGgN/mrjWYc3j17G6S5QWsssxlYVu1ng?=
 =?us-ascii?Q?o9sKR5OQ579jmFUpay3gAkB4HQDIbR0Ue6MxHkVe17xUiTb18FN3omquq1In?=
 =?us-ascii?Q?XPYiFZTQiO3D03F+34GLAMebCFlFLOVAt+ySaE10ZjqbyP88GcFWopj7El9D?=
 =?us-ascii?Q?Ga3J17V9qshHQ9+2us66bse7h1zjQnn/Ggg8Nqy21FkNyNddpYg5ydnuESmm?=
 =?us-ascii?Q?IfabziO6zJ6ASGz8T8tPuIDtOBqsJu6iZtWwguLA0ZRsnWosMIzTl06dWLGF?=
 =?us-ascii?Q?hfQiQSVviUS8avrU96tIVwbLJ82OcbowvVTkgCHD75Zy5C1oG62Teyzzf/wJ?=
 =?us-ascii?Q?GbtDtfrwe5wvh7oA69mkAiWUuqQBiFxOvrbWguUqSkkfWBjLabxB+IK0dAzs?=
 =?us-ascii?Q?TpfGU6VoFMxjVJPMGZMa3PVuKSJjehUuINraC7d8pf5V+of9jSKdmnR1xMT7?=
 =?us-ascii?Q?Cidx0n9pGq08HhvPwPHWLNjEbck1H20RRW/UiesBEmHEYcdZrpbHwU/us6Ua?=
 =?us-ascii?Q?mgWah//FhoUY+RtmfwMlYVTHKSFR9SfnI77IHnHTo/vpy7GjciGhEZRvCVTR?=
 =?us-ascii?Q?5qRCkPHjMMQLdolVdBg9W1asYlyhNqDd+asIpJ86DSVMuH80iJX00BgW6FOG?=
 =?us-ascii?Q?KbH8hmb0JGNlVtYrkn+Wm5aGSnTDp+OtGEazH41Zk7vw7c+nB2Pe3xrYKr1l?=
 =?us-ascii?Q?JGy4777a9+6z/ThmO55yFD4oiRtnLK6eQvnUzy9WoiwmrBH9BGY6cVelG66u?=
 =?us-ascii?Q?1gVuG0ngetWz0Wjhglghwu9HJNvb2FOvjniuyG7FO7/wN8I4K4DWMta47TWg?=
 =?us-ascii?Q?UCn8KjdWXF1ytwpDMIuG5a6wS+Ixjm/sbSJN6wAg/amNiM7yrhORFGj76sM4?=
 =?us-ascii?Q?wHyPVGnvMZT23HR3ZbfNNmYF2WrSEGomHswSWUy6lf3hOMK+LA8m3N7W4naN?=
 =?us-ascii?Q?YN2aq3s6iNr5E7HK3mWX1By43unUMv3tx+eNnBpbOSTQHNJ0tz5C1JqVcPap?=
 =?us-ascii?Q?hdy3vQZ/ioL/zJPdoq+ypKz1JDVEAz91LzxMPWFtW0gqh6Hso3VpjSSTJwjZ?=
 =?us-ascii?Q?WtA7U9LFUeYhe9+SPfWrc1fDWbEjRcmIVWgJaYwjlakv2JfaqzcCApNN40mL?=
 =?us-ascii?Q?B++QfFp+AwpOfeNcITYFJa2YdZMYGNWDSsJDaW95oq7JGRELrBE1cHJnj0Ga?=
 =?us-ascii?Q?iry2bxCkzbxn2ZiSTHY8I6CaOheumqPs4jKQQs3+V03QdzllfxQtE0W6/zcQ?=
 =?us-ascii?Q?MCXUWUxH2ZpshTK+GBMNw1zRQ1UzqykEDgTdgjvjqehpTzaOI7kagysyLbkV?=
 =?us-ascii?Q?r4aQ2w6JU+D5eNAzx/uvezXRhK+DIBMwpFGCICDirSchuTyX+lhPdtKj+rIi?=
 =?us-ascii?Q?8jMwf8cfWw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2c159e-50b8-41ba-d826-08df12d5fde7
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:04:00.8813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTD2hrwD2UuN40PgS1fN/oNq4wxEkyp4XpEfV2xNhvqvv8njY5hR/aYCuJ6qQ+P4s+mxHoS9iq6QsfO5HZnPJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9008
X-Rspam-User: 
X-Rspamd-Queue-Id: 772E420009
X-Stat-Signature: 1ax9gmpyzko7x5xpnedpkcd7osz38r3u
X-Rspamd-Server: rspam01
X-HE-Tag: 1789441448-54306
X-HE-Meta: U2FsdGVkX1+++jPwmb8JtdvE0hzsbXpj/18vsdzCctvzX4amdTyfNCFoJlOKgEIN21tomXtP2uCxUgv4ftrKqKdwJp+OgTgRK+uF7HBHU46ymedDdcPSYjLYeJYnpD8fpu6ZTCLedkZVeIY+0couBKFoQQTeblmK67QjPDL/cbnD1c6DaYbWMbDXVJnPFHWhxN34t54nKpfBAPBgBh3DLujcwD4uQk4mwZNH/jmVEtFE8PSHZFbBHDbgoiA+IbmZiextpjZeJ6kEob790W2c3M52UF7y+Tgs758tT9YYT7DTVRfRw8P0wXr2BikohWXiAVHDcaoLfDq0IsW51SkqdS7DmBvYJe8s4vOIcwAunaHrvqkLAeV4POEbN33NXDQN9tKFEplzZdI3sGDI5vx+B25aa2Frp/ulouMUyRKQ2aXKxYMAXyFw+jrc8es8aJ6tC5bBGbQhIbAlGAhVS/Fbne5uhSK9nw8WAk8XUfl58LHf357yeTjAJJh3ors202l9rG/DNjIn00N6Ko3JRlA00ZNE8gPKcXMiZeJsfUXWQpuZ7OqWCQPxg9ywc5gn/mzVicgai2AKlCWvv7HAeiufEmLfYUdqrpmGOHMQiwvQnsp/0z287e2L7i0RNPvIX7ceUprfG0j8JaCKkdhxT3HlEeJGeTtJw9NrB4ZUcLgWwaZBovtgBeykiCroLdvu3RAXD4mt6o/VaLiIXr7IIVoPlNqK+X3IUFj5ch458advkPtmfAo4m+DM6SyJM4KrfFrmbqDUS9E1rRs6Us/JY+ZB5vHJ/nuOd4HdJWpYM3/3ZMf+Ss4KZI2DU42bw/pzWPNxbAHxQ+Mx07NNqZ7d1tJaKtr56NxSfCkPydeD37NR+LH40gUc3QiEAUvxITZTd6eCY4WEmvVyvBkRWcsw/GVR+5tgW8ePwAB2VfsNW7535/BYUQUzGIPFPE61/8HYsSRbTp42O73e+lMVVsnOoZR
 Em7WINI0
 fiaLvMQcxaG8zCMBSBTIaU7GaxcS2tCSyqU9So8aE/8Readx2/S96spJXFAgNtZeIu2XSJGm3jJAePcZ2BzKup/KxJk3ybPeAMPRxDobKIn7gvpGLT4NzzonsKCTjFm3vSefGbHskEG/yqAP4GRy0oGB3sjmcBRG0C3oMrNiDYw2JoiRSr4i/4GF/npYTsEYe8QejXva8Gm+GkfG3kA9EhZWdVcWfQOUCNnV3jSidZ6bkmcSsm3YoBKt+QR2F5V/GQLBrPxZj1EyluAWBs7KAaIAmaT4j3VDXUM7Ov+aGavRVBekVQmh6FuhaVm5Oe7itNphsZ6aVPLknPmJHKoco+R0mjNcjc8ht/H/8qpisOSRRkh/yBxHkhhNiZc9CdJaL8fAIB0l5FzxkBf/21rKDVVxks8yT2/Mb3o3zr6j8da9BFraDSt31QvbgYcxIZRMGP4X24z5Yi1q5B1MA7u3r6gQ3Z5YJ6DbkkZhTZWhcPDC0LArAE13DWS2EHH37p3ldpv4DxYA47FlBMN1AeUYF+NVixg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static rwsem initializers rely on persistent lockdep class keys,
both for their own maps and for embedded locks or wait queues.

Enforce static storage in DECLARE_RWSEM(), including PREEMPT_RT, and in
__DEFINE_PERCPU_RWSEM(), covering both public per-CPU rwsem declarations.
Automatic objects must use init_rwsem() or percpu_init_rwsem().

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/percpu-rwsem.h | 4 +++-
 include/linux/rwsem.h        | 7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index 39d5bf8e6562..680c3efc14c8 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_PERCPU_RWSEM_H
 #define _LINUX_PERCPU_RWSEM_H
 
+#include <linux/compiler.h>
 #include <linux/atomic.h>
 #include <linux/percpu.h>
 #include <linux/rcuwait.h>
@@ -36,7 +37,8 @@ is_static struct percpu_rw_semaphore name = {				\
 	.waiters = __WAIT_QUEUE_HEAD_INITIALIZER(name.waiters),		\
 	.block = ATOMIC_INIT(0),					\
 	__PERCPU_RWSEM_DEP_MAP_INIT(name)				\
-}
+};									\
+	ASSERT_STATIC_STORAGE(name)
 
 #define DEFINE_PERCPU_RWSEM(name)		\
 	__DEFINE_PERCPU_RWSEM(name, /* not static */)
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 6a1a7bae5f81..faf52c0c8dd3 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_RWSEM_H
 #define _LINUX_RWSEM_H
 
+#include <linux/compiler.h>
 #include <linux/linkage.h>
 
 #include <linux/types.h>
@@ -111,7 +112,8 @@ static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *
 	  __RWSEM_DEP_MAP_INIT(name) }
 
 #define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
+	struct rw_semaphore name = __RWSEM_INITIALIZER(name);	\
+	ASSERT_STATIC_STORAGE(name)
 
 extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
 			 struct lock_class_key *key);
@@ -164,7 +166,8 @@ context_lock_struct(rw_semaphore) {
 	}
 
 #define DECLARE_RWSEM(lockname) \
-	struct rw_semaphore lockname = __RWSEM_INITIALIZER(lockname)
+	struct rw_semaphore lockname = __RWSEM_INITIALIZER(lockname);	\
+	ASSERT_STATIC_STORAGE(lockname)
 
 extern void  __init_rwsem(struct rw_semaphore *rwsem, const char *name,
 			  struct lock_class_key *key);
-- 
2.53.0


