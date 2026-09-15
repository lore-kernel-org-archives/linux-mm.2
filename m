Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3803C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF1C6B0095; Mon, 14 Sep 2026 23:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C76F6B00A2; Mon, 14 Sep 2026 23:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867DD6B00A3; Mon, 14 Sep 2026 23:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6594E6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:13:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 061AA402C8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:54 +0000 (UTC)
X-FDA: 85214527188.09.25DC0AC
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010071.outbound.protection.outlook.com [40.93.198.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id 40DAD40003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XECGza3x;
	spf=pass (imf11.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.198.71 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOh45PQ1guvyokDHmGc5oZcIXFe6sbxgT/e5DfNjIls=;
	b=7WH4Cjm7eyk/8W+sPACM8bKSM1qR1zUomXubWg8BDBvuRp79uybQGIeTJNTdfoJzsjKgfs
	dtTvs2vDGt4PipIfQ4MK8YF2Ddj+Vd32YjNa+lCulul6XVkGuzPYx0r6Xq3LJ85h4dJOpm
	CJ2of1TMID7nJUAqO1sW/erLHHrencc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442031;
	b=H+RE9govo2OqHe7iaD2mWJ8NAbg7MaGvHZlm42C/IBgB6zeskB5s+rfBDn0v/IIRN56ogR
	rmCF6zrW7h5VBWhhD4XPzCGHXEKYE8sdXaDgKrHMoTwBDBzSvZ+sd6Er1W1oIOqKKe+UZa
	ge35hEG1s+u5ZTgMOu3ahJu7vcipuxI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XECGza3x;
	spf=pass (imf11.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.198.71 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m8OZzcJp8XVt8zzRRMmZiFv6i/QbLpeWQ9LtsdtcC1TyTOiRa6M4z3ElMMbJFRlmrt52AhrxJzN5zpaMDFllpV6lUQjE7lqA6XSKc3UwcJ2dxNzW0qZyBXbUX8NM4j8aFnx3pPo4PCSbQdckUsyjTkEOZbTOPGqmVOaj4JljS3D+gGNoI00bl4s6wxsK34g0PNOjeTAGxTOdZGnpirqmr8dHmwkmTza4suyXep+h91kUhukQsH5jSU+/w85MAd1Jk72NodGRQhA+EzzyCGC6NIOWwv6iQrN+yzJhPAXSw6abp1YiZ2Hy5GTrPEDR6WpwT2dEim6B49RvBbImlrar9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOh45PQ1guvyokDHmGc5oZcIXFe6sbxgT/e5DfNjIls=;
 b=qcej4PiUA9m7Jd/Pt9znTvMPMfNtplTH4Em8sJKAsZegUMZo9jNexEvz3fWfSk92uLWfkG6FwHmXZSj9yo8F31zLAu65TlhiLdi1p3kyChgn6WH2gJnn4dNXl1NdX7l6GAZZ4jxMdZkicD1x/WPnQI1XqFgQR3I0JhZCSUjAHdTLXXqIOTSvxUDId8R84dCVoZroOQ47N8cI2KoMCz1imTewo40tlVnJPJIJtN5gqdEEo2RzSGX5cHCsA1JTbDD/Ufd0Q7JSm9qtYqr1Jge3wjxzf2Lr3pvXqqlOSrk5KLoFSdONDEZECYZYdD9Rqijx7MT+krcUjUICtzzAlwdtfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOh45PQ1guvyokDHmGc5oZcIXFe6sbxgT/e5DfNjIls=;
 b=XECGza3xFTRds++v2cKaSz4gQa15MfI33qynl1cyJt032ifj2VvlbZBlql8Fv/u11GPx6KmLiY4CXsqDjYOr1y1qR9XozGxygW2G/ZydIAP23pjw2/gvqBFRNO54SZTMAJB//1215+GzfPkMlM4tuX+mtpoYF31DLlnt711dHgyDgSRJaSoB+diZ8qPuPVXuK/tU6V9gPj/u6jAyo5A6B6ubrNvNjJW/6xYiH2l+FM5xC5l+L1nr2p6OjlLzm+Fi/iScKf9S4cXU19XcMtA+no2UOPCMr6/hfcvoYu+wpLa6bh9Bgr8K8WQHmGYga4oKOWP0huPCIcHvwdKG0UnEhw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:13:44 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:13:44 +0000
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
Subject: [PATCH 07/17] xarray: assert static storage for DEFINE_XARRAY_FLAGS()
Date: Mon, 14 Sep 2026 23:13:22 -0400
Message-ID: <20260915031334.1194975-2-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LV3P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::26) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: e1f243ba-da4e-4a2b-dad8-08df12d75956
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	2Y8Yoz8+cArf9amARJOTPKR0hu7m+D+0vjBlQRHsF+X2LR4CimBZ8cbcxGg3Aiv0VMD9nTGn6i/JLrKfrJ2yqIK0c6Zh7EQ+vOtwqgDUfG+9iDs2AR70Hb/RoR92sE/RbiqiF3bnG2uowiA23FZbXD6AB49swidYgVihZ2tmUJdMHt1uNwi17FCvn7X+B7uAYN1dusxfTMBoUMBPyF1hDa4WgwwYVfWLMxDYxsbR+sH5eI/yT/15agpcQXdFy9QkwgE/Cy+e2V8xAqgEBfw1B7dFKvdFmUEs1deIWOdRlJKbNFRd1xF33oqVKaHG/EJhK5Za4Zpmq2O9xFO/STI6IttEFhgxOh02x4uuqwfi6rFnCQnyj/nB91dpypCbDYDRsEsobGNoZcS3trvB6eb4lNFmHWjWAdb+3oiCiJeOlici8XmvaaAa5aZv4trUj0SzoXTq+UbMHg+KHYAQdFCDKok+PoEWF5dZwFeLGYpBy6U52xNQi3FM+E5kRbs5g4Wx1l/U+scKlplSARzIyIVUlv43aYH0Q195g5vO5ZKL/846qAk9xMijqro9g0OrBXn8Vs08w9vfYpbqt7duhXiMWkQcla6hshW2YdwF2yz2Mw1EqHS8Wv4+ACSbTYhQFwF1Yi7CoupYiovczELZPOdRlwXo8TXeb86o5f2NCHpJAwE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?86t0Ols38gxBUZ/uyBErePbeXhxfgGOQPkqyM1jHaWQVfFLTdBE3l3n3J7S5?=
 =?us-ascii?Q?SKg9YSo7DjdW+sAiKkqGnlDXo94VXOzcjJ2LLr2lf/jRde54Iq3dqRyEyBKw?=
 =?us-ascii?Q?gY0AiioHwRjiyR2o7yvZxW0ifJwGv3XF4xPCxHdehptqygq8+1Z7zgj9NxHT?=
 =?us-ascii?Q?cVac2fu76MVb04FehocUFB8WPhjBizlZjrdRNMumoopYNP4Tznf4UCS4Ei/D?=
 =?us-ascii?Q?CcnO18jITTKttlB7K8Uu1bdSTmXs1Zq1jVqCnqZTlsgRRmqBXV88uPjcnor2?=
 =?us-ascii?Q?AjjP8NEbg24Y3oWmAayi0W1Al8K+99gnNIs+E0CR57IcXqLU5I5qzp4lzJFL?=
 =?us-ascii?Q?Jgnq2X6F5Pm4/sGQ33Wm/k19q7wLfHwWKrW0UVVqwgDMzkK5tFeYeMA5QJpv?=
 =?us-ascii?Q?f6PZDB/PaIb+SjUFTHvT4cqmQzJlqT02DfsF+3rAlaiaePszOcQ+bWWZ99BX?=
 =?us-ascii?Q?VlXk9j2ZZHCy8lLzKN4YEElAue5Q09b5uJ44cWuRkd+8J9iVFvmaRYqkVETL?=
 =?us-ascii?Q?FoBGWKXuC29066pFlQJzNEdgzv1NWSLlMCJ6ymQom/iq6Txq9mC9tx3r05TD?=
 =?us-ascii?Q?ThxUEWCnyPFXMZVk1lf9KxgwebJDljotrZaRbB5esI6rkk+m8ojtcDfzC13r?=
 =?us-ascii?Q?pHQooo3dG/zoTEB6OOI35KcHYtnQc7idGMuzTsbas16KJeCggkSAGWXAs2zw?=
 =?us-ascii?Q?p+WgxFGOIJi1zFVFIr83V/IJXG5hmZsP/WNXSZ2AaMEow6Kilv/A9o6jSRJx?=
 =?us-ascii?Q?KhoSM6rUSKo7dVbb/EDSc5boJbe9ENpX8vAsMqhsmNkj287auYmPw6M5jR5X?=
 =?us-ascii?Q?lLosQ6inCZSxNuAhx4crcttQhvjjffYSf6RoUbvVw6ox77ghG2y9hpe3Wjbf?=
 =?us-ascii?Q?EQ3zrOs+yFJvzCQKigB1JzZ6QFje7BK+ae8eAr8QSHuva08ge0PQH68kZUUi?=
 =?us-ascii?Q?QhZAbmRAbA52ZwvyGVwEQPqouxe90k+z7uZVVK2e+isPaa04vO5qvYeqkEQ1?=
 =?us-ascii?Q?NpCn1VD72BZA7d7ezdbMYIfeNOxKqM3adHJ5bROyR5wFQpr9Zv2Ch0e8iyOy?=
 =?us-ascii?Q?bc5qwDIPd6XwRX4Hvl8D0wv4huFckS+AS9V4vncg9TN7/osMZazs/PjT15Lw?=
 =?us-ascii?Q?R121G7MkkGrOQLuqJ3kzyElOsMEAQjyiODrDgIsITXTSeZGhirjNwlzY7ZDs?=
 =?us-ascii?Q?n7ixYniCkV9daJyACxrhA6jsGG/Cs6MhqpBXQd87yHnuFH4u2LK62ERkfr9d?=
 =?us-ascii?Q?AVmHkQUBrTM69AUj/xDubgLvAE1lHO11tpdq1qlvESMktKPUlBP2qyIqG+lB?=
 =?us-ascii?Q?Bv8IpnsZgxZYSR7AEEqPA+8V4prCSCWAxVllvkXrmYrkurtfkS73LUwsKeqW?=
 =?us-ascii?Q?R5iAVWRiaSBaKHFEQszR21tfCTObY7D4lK7HvgYAHSMD2/hvtWhcDZNAUD/G?=
 =?us-ascii?Q?bgNOxxv9+ABwND0G6zIZTrRgROxNFnCEAtwwYT3bXrAjsLlW5WdzzpOKFeIf?=
 =?us-ascii?Q?4Ii0D3vZIXInbQJcog2LIm1Jendn13L2oq4vb3Scm3wfvSEtxxRy35vAqmzF?=
 =?us-ascii?Q?FRRwua6okpwURhr6dIQDZd1KaAjtomwqxn5eKbkwdebtH6oLJqoAnzzktUfH?=
 =?us-ascii?Q?OKaBJDsd7t9gOmzjS7F0OkjsIrn7BGqKxl+du6tR0z0wyBsm/EKtEDyvvXKG?=
 =?us-ascii?Q?en3aKqah6HAMaiqxHSROteSKQKfRPhS1jPVtIWqSjWbJxakaNVvLN5cvg23e?=
 =?us-ascii?Q?0WhIxTMXOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f243ba-da4e-4a2b-dad8-08df12d75956
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:13:43.7464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kFCVL9XPe07WXVi+nq2gI7EAOXogvaWs1P1da8zRpNk9wApAx7MtdDIlqgweCslt8ojshxe/wgviJjWA4nsStA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Stat-Signature: h4iao35n9pxr6uo67g4bhppb36n7ff43
X-Rspam-User: 
X-Rspamd-Queue-Id: 40DAD40003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789442031-127249
X-HE-Meta: U2FsdGVkX19OFbNG2EKjHybHsjn04EuCZFvEAYgsSrmVa/qQMRmnsnCga5//VjzFx8wkFdQsobzzZ6IXe2uWx4LBbGkhoGryh7j3Flraw4YX+eB3hOI5ocqltc04lVE+uKYL3MfpsHcSaFO787zYsHi+MzzhETGdVn7LzO9U5wou7Frhy9z/AaT/YS0kmux9Wro6UN/AMZmfMME6KfY6m8qG3kW7iJ1j12NP1EcmPiYTULGxi92s0gU8whNkHd4xtkwtOjMNRGSf+EaRCwDI6l24m25pUQu4OyTyneKTX37WSvvXJuCB6yO40e0CciMqzSTHLcGW5UeDw31cSVjG3wtElb4vjPd369v/yOVEkY5nap4SoU+Nl+oNIID8fIbytLCmbu0s/Ws05eRTRJnMoPsbnzgQqLyvL8JjAldP22Po2jxgqunkIsO0ZrB6RZsFxrAxcrz3/tpofDoM8bwRG7oZyI/Cw8AxJ65mcit1QY2/UEykhd6oA7LyB7JMWnTFc5zgyQcfZY9FNaHv0jC8oiwRMA314c4dhpMDXByOya51R2fGNIBFICiPZHhvCWQAetigGhhDniu6K/FGoVlEF/8wgR7MaxvC6EQs7KSiNNAiApZ5RE5mQhF4/lMN1O7FYJDHop9oQTl7AjoB68liKzQP8em6t2I8a3zJjHMaJRLhqJCrt6kGNTlfxJ/wXRjsgJjg5M4ydX2P85OqdYTJ+pU1Axmnt+ovEHCHyHrcowMJN3ju4p6YPp6bkWNauexmqeFsJASll12FY4WD44OvOOElZiK1BhTyNJ295gHnduGKLUtCLsvXM8FxZAnO7P4WkhTVNYfl/epo4A/Qm0ZlMLjM/U4txvv+Ek+Ol/0nX+k3O2otzUorAEMFHLoGCRIw954yIRU4tQVd5kNYklN0Xx9sNTHIGWJvB3Y4ALM9TfK6zxr+nESw3cdfQmFy/m9OqQ4I1hgVrZP6PmXGl69
 LU4BM39x
 MjTwVhtoe8QrcDayj1YQ2WHKp2YA7BA2TQ9pPjtOzbmSnRE31NSPiUwZyrhRzQOwAwOAa5vUe6R7E3uSUj+Teku2myWUiWaJA7bGZaF3OuxpKgR2EeZkeDS8hce2gny+7GbHa6Kpc+03iSaZ0GJ1PFjQ5Qb6Mc9T5B8QLP0mO66iFl0/566b56Jdk3bjOfQYhmJdNZ9eHY8gPkjO/Y9wbv14+yi9GIHMDXShumsy1Id7XVKxk+zrPWfwKrcteKnaH0HuusqX6NME0fK8MGPMgbZ5UCYh655sx23aI9+SwNFvdCdmuloJbZO/BlLhBDiE6aowH6Zr1VdKY+5aKw8RCaUvrdH6iGPiX5ahWzXYA1EDRkhSrIbduEOzTi4chFh6o9yhzz7ZtVnkn0Aczo4nz/p6EB1o+ztG/Z39hIYkpBurYHDasOiFDJnykdU9+Mp7ZumjKbUHY9SKPWFhgHFN0ksPkWrzO4RIOM29Tw81onk+bPm4uthCNtxaXbTg0wXjL5QLXtlh/LDWZi2+cFG4We67TX+trV9OkHzE9sUSCLPUjb+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_XARRAY_FLAGS() statically initializes xa_lock. For an automatic
local XArray, lockdep cannot use the lock address as a persistent class
key and disables itself when the lock is acquired.

Add ASSERT_STATIC_STORAGE() to the common declaration macro, covering
DEFINE_XARRAY(), DEFINE_XARRAY_ALLOC() and DEFINE_XARRAY_ALLOC1() as well.
Convert the automatic XArray in the userspace iteration test to xa_init().

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/xarray.h                       | 3 ++-
 tools/testing/radix-tree/iteration_check_2.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..9b9a5eea006d 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -321,7 +321,8 @@ struct xarray {
  * initialisation at compiletime instead of runtime.
  */
 #define DEFINE_XARRAY_FLAGS(name, flags)				\
-	struct xarray name = XARRAY_INIT(name, flags)
+	struct xarray name = XARRAY_INIT(name, flags);			\
+	ASSERT_STATIC_STORAGE(name)
 
 /**
  * DEFINE_XARRAY() - Define an XArray.
diff --git a/tools/testing/radix-tree/iteration_check_2.c b/tools/testing/radix-tree/iteration_check_2.c
index aac5c50a3674..f798603a6f28 100644
--- a/tools/testing/radix-tree/iteration_check_2.c
+++ b/tools/testing/radix-tree/iteration_check_2.c
@@ -54,9 +54,11 @@ static void *throbber(void *arg)
 void iteration_test2(unsigned test_duration)
 {
 	pthread_t threads[2];
-	DEFINE_XARRAY(array);
+	struct xarray array;
 	int i;
 
+	xa_init(&array);
+
 	printv(1, "Running iteration test 2 for %d seconds\n", test_duration);
 
 	test_complete = false;
-- 
2.53.0


