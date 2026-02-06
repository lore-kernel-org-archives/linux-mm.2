Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B60CDEE20AF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050AE6B0089; Fri,  6 Feb 2026 10:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41A86B0093; Fri,  6 Feb 2026 10:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDC36B0096; Fri,  6 Feb 2026 10:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDBC16B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:09:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 505A51BF8E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:09:49 +0000 (UTC)
X-FDA: 84414366498.08.A55B661
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013025.outbound.protection.outlook.com [40.93.196.25])
	by imf27.hostedemail.com (Postfix) with ESMTP id 32BA54000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:09:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="XE/w5/Ym";
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770390586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/f4b+ABKXeYra1eooNkbOwQNsYA3ClADKb0vK9+ZVY=;
	b=rltiHJWMFpoxqT7rcC3Vl8zEMR4QaUkxJp4m/hlHHUU1NPAHzW2Ogpotb/TOVg8LgRRxOh
	afxK+GhlKAHf8DML1rGP7QwFcLcB+5/th1/ymMc1bE+eHGo4MZPcW9zViNI/7lC3+NEeEr
	xG6oVv3oEyZ/mqyQciMrLvCWtJQmkQY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="XE/w5/Ym";
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770390586; a=rsa-sha256;
	cv=pass;
	b=lrp79/idOZ3UiAr+DlDlokvnIb/YBq1XEuwYDYLiK1+QY8BFc2e0FMBrVE161yFPc07ni5
	KR79Y5H2XSjyqZH2LAc9EUinpWsi2HhAQ7HhrxHyJ2ZusvnsUNnnYNzJEK3+xYsPX3tKJl
	RmjX00aZLRVbTyEXSZmMN+CHmiksgT4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sbCmY1N5mzWHrcHErMwd/TbkvHLFAvdnCG/04aRq4IAWy8zdOO0Yrt3DoBet7nCAoUpa85FoEwI3urKOQnBCHyvg6Q6l/0oOjZtlj0JH+sCI5jecu5782N5Ymau1o4IsCb01AkgPrLbGZ9/Ft1a8+Y/ewcGqeMgfK4A5AKBVMMHzJ2wylti10attwERMEPvBk5MTT8ZYTEp/mctLbO0I/wq/cignB9Y6hHrdc/94bLzwznmYWt18FYLK4rJ64XmPotyvqAFhBQt7I4B5qiQjCR41nPr5MigTPR2hNt/YODTUWMWZ338jsuRfNWluuOOG9btqQMFtzmcVvuHWpVLRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/f4b+ABKXeYra1eooNkbOwQNsYA3ClADKb0vK9+ZVY=;
 b=naO8QiPAyjM+puDlK6bQeNhyp3psgxPgoOa6zhsgNGzRFLoEkawiIvMPlW8URaEIk/uWZF5nPRzcRKNaxWqSXC5ALDPv6ZBZhrZh4bqNG51XczE/ErB/clhtFxRGVL+HBUm0+skI+i+JNty1tuhAFvS4I91bP+M55+rCsEStx0stj6ombSJtFX4cyzQ3TrrsP4ze+MUbBu/uoZ2hk6Z9+BpVoVfHFVGvxiQi35KZqwY8wvX9CtA2CAnUMCqsRtuCI34YHNZZdY5fB+hcVUkEVLZMnuqPHLyRmnzWq4Ad+fTlNzyj3TNrJgGz7BV0Y+WBmTAxmEwNZXTHinV+UYuCfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/f4b+ABKXeYra1eooNkbOwQNsYA3ClADKb0vK9+ZVY=;
 b=XE/w5/YmtRTGNlokZ/s0HEzgvwxLAMYLBxFFUozUUcAnalTQSdry5vL6t16E46r2g8M/beG0k2mbKhdYhA/nzdduF5jKGhSYxbrsiL7VVtauGkW4U8b1tSNG+kVCTzzgz5mg2V2T2MqbYWses7+Re+F7D00cLSa3++dgU5FiZbBzB0cEF5XNT9DtTDAUzHDihA8zC2uOqjqrqmdcvAEtgdCltKA9j4HIU3guj7mpl50rbi6ZseuDpgn5GgchsFts+06hnXlOFG8fJo7LhTit+1S6dDyagYyHknFx6d52OPylt/jKRtksxRg1I1/6NCYBthQJtntpRQfpaFTfcBURQA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB5602.namprd12.prod.outlook.com (2603:10b6:303:169::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 15:09:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 15:09:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>,
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
 rcu@vger.kernel.org, linux-mm@kvack.org,
 Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH RFC 08/12] kcompactd: Add housekeeping notifier for
 dynamic mask update
Date: Fri, 06 Feb 2026 10:09:31 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <96511BC8-1A04-40FA-B49F-59A5FB702C73@nvidia.com>
In-Reply-To: <20260206-feature-dynamic_isolcpus_dhei-v1-8-00a711eb0c74@gmail.com>
References: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
 <20260206-feature-dynamic_isolcpus_dhei-v1-8-00a711eb0c74@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB5602:EE_
X-MS-Office365-Filtering-Correlation-Id: 09cc011c-8587-46a4-c6f7-08de6591bf1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9ycR6f+RT1Sg/iPOCVj5juZPxUkN4fPCCUNPSfWnQa87zGU1bEVKzYzMzXrY?=
 =?us-ascii?Q?fBNeq7DblbhzUJ/M0M7Y/LCGmOMWEgpkYwRHw1brnAUIPLyn/0YOGAxTsDu7?=
 =?us-ascii?Q?C5FCXE0mXcsGseiN4NDntqnmc3U3GpyFl+ddxIh76ZdMGE1aFYz5y3cYjQPN?=
 =?us-ascii?Q?L6Z20Ql9DyJFyyys7D6QBr6UmXOuJaGB7cTgWb08UGTPAfVLKzyUHvxuSnbl?=
 =?us-ascii?Q?oRQXkLuacnnpWvyx21R0aLqAhcT4rgj4fyooSuvIIoPK9FUznxXnfk01hhyX?=
 =?us-ascii?Q?uoMKutziSWtHyY5W4pKvFF+nfEtEPTNmm/cPERVqF67JP7UARk0gcQiDfpQR?=
 =?us-ascii?Q?VAuP4kM6m+/qZt/AERpuGwWqSXsAHDWQGxp9UMkrpTaHKjNFC+5eOUBS7La9?=
 =?us-ascii?Q?NeqJD2pCQGRFBj67sx3Y8w+KQzs6c00HfXrcirrKAG7kRkDQuNE9Kvf5bqsI?=
 =?us-ascii?Q?YNDiAALCeo0u84Pue5Qadc6ZiLaPVqs/zP9Zf977vntY6zu/BrymX3b0nYLG?=
 =?us-ascii?Q?uEZhlOFpx78U15O7UHAY4IuZiAKGDiSy9GYviud4Md54kqCdaDaYHPAo4x1L?=
 =?us-ascii?Q?vy0qVHnJHIxzmL+N16K99GiQgyQQ5NJmXZTfmSNlJydOPioc7/je31/93EBz?=
 =?us-ascii?Q?nu04V3VTFzv+pY4tGVCxn+rUik+hzcAXJ1GosfJTkYPDK1fSjaKlZ+9/Plm+?=
 =?us-ascii?Q?SEW8WQZ5tWqF0psusDH7eouRdbjpE+M2CDR21nsCZkRC0y3POleoaT14bNv/?=
 =?us-ascii?Q?ac8S93uhWKfeRBFvTpz9nNtfd/g+mUVueGUgNlqMd/UINdL+3UiiPXjVm1Lb?=
 =?us-ascii?Q?nOrGbDTm63ArMjdRPzVIbkRWKpEuUM0hC3aXlg1kpfzUldIevujdLR4ogWr6?=
 =?us-ascii?Q?nb60pfA1U0QNBbbEAxaX6uYKkRSJPEN2tDh2PbZRCY4lcgIXegslBr8ZdY/v?=
 =?us-ascii?Q?TbkZSzklNOjKzGd5gfKRpqhIaENYeDZ+iKSr2l6Db6CUct4KcVI6+VSCljTJ?=
 =?us-ascii?Q?rivbc9Hxlmm9xvv8LDVKxid9vzAsW35GFG/BQ87hPpNxPzpZETqjlUzacF5I?=
 =?us-ascii?Q?9xAJSAXaUFJXA3y6xnXioo6bcC09fANTT8tKFs2k/N7hptBUEY6f5TZVoEuW?=
 =?us-ascii?Q?OwwcsxTnDwDMs8L2YpX08KqIWBU4yQ2g2NgSVqW2CPrCdR5iDML3raIhyJMi?=
 =?us-ascii?Q?m5XvLABwV+CqodUqAs62uT7GQZnBj0IZv1JVdtPfaCbAYUTRGeEZX5UOr+2K?=
 =?us-ascii?Q?J56lbC8bL10SZH1DnIyHX19OqCbImGN8C1+AWxh7Fm8QlBk134nRyBsLOD9O?=
 =?us-ascii?Q?EoSKbXltTEvgxNpw9yCQV8PUhYPauS9Ovcca2AcQomkjao19NicNp1pt+3Ir?=
 =?us-ascii?Q?66r9GnQdkQpdhM8cJPFQlqGAosbqQY5ERJe2brBYuH2YpNTGcrKqnvpvyLIC?=
 =?us-ascii?Q?+EST+LitjvDhJxDyxw6yw4q/QtGFopbelLdhmdd3rlaK0Dh/0ShIm+FA8dxs?=
 =?us-ascii?Q?gsEHm0gWGFejhbTV+UMUMPGFboTPPiZOQVtMVqas/RxPEJU1t+sm7uul/3tU?=
 =?us-ascii?Q?LeEUXzWMDdFjdDk+bOQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XDyzVbVgB3x+wN1Kk3sDjKPWsevP4yCJ066K2LQ6UvggdO3gznc0aCHcRIN4?=
 =?us-ascii?Q?AYcYGiN02NET0rl6daZ1frHT9K20Mb+QXjl14wbhyFGpHwOC57bx9H/lOhi6?=
 =?us-ascii?Q?lFkzjpGtk51N7dcb6Ee1hvyKyog9KaVfV42Jap+ZoJ0YKgMiNgljp1t/wZ8G?=
 =?us-ascii?Q?VuHN3k+r94qh0nhE1O3wssEYugXZ9dyupGR/GvKlOVqqWUFDpJybIbDQMX+R?=
 =?us-ascii?Q?tbTVR7I+YlMKN7DCgeiV/2hICoMpOlQOmGFwZ8APcorvT4owmACcIdSpVTHU?=
 =?us-ascii?Q?vRUbu/ctZQo1kfnJkAQ3MD1bRKNJJ11qCPGRKez4tjjIOZNEwSH9lTatk8N6?=
 =?us-ascii?Q?VS5VRx7K2PSCSKWacps5DRjWjJl6AygfC2SXgFEn8shYnR0AEW3VS+O0BOV6?=
 =?us-ascii?Q?/orEUU7mvH70I9KLos4rItndohWOoWGjnzlqCcasPYOApIdgCYyHQoStNLLV?=
 =?us-ascii?Q?4NL9Hj4I99Alzrd7qZKzjJdOyRieYIRImLM0ghsXr6dqUImuhBW+Vlqbswj8?=
 =?us-ascii?Q?UUPPeYg8OX3GayK23F41++L31nYheGKV8DEEnsUf9XHdlqB9IwcF/ts95BBl?=
 =?us-ascii?Q?wz0G6VSPICOEcIUixoBmiG0DqKnJeREkoN098NZKioS2khErXOvRmWlVV+ON?=
 =?us-ascii?Q?58Ftiws4dUN+sQUFSkukNtPQFBUZpApyrk+czTqL4qk6wzkIQmp2xPs6yMHf?=
 =?us-ascii?Q?9vwo7rPvb1CBlKFPb1fmofyZjK4++KnpPedS6b+XGTLQN1jj1JYazOtAsGFD?=
 =?us-ascii?Q?aMQ3+w0cZYbwjZ19HqaykYocYHRiASaYT0u/KEwmXNsVdICZtbPSAAAL/VTn?=
 =?us-ascii?Q?1ITqrPi/5es6SDWJB1xYlO/7YferTYXofXtT0KOrCrQyoMX75hSQhnRF7Huj?=
 =?us-ascii?Q?HHqcWNnxnI3+92OrFJNOeu/NT7oeWGmVMhw7Ab7QGqZqIulj/Xp7Suyjs4rs?=
 =?us-ascii?Q?N1lesNm0g8w3aL3g+hTcflTsGWuGmIqzFh9PZr0w1ezp62Mg/JBFGtLpQpVg?=
 =?us-ascii?Q?3FaI0gcDKf+NEfkoVBCGyLqviCNBalGtbNACsUWieSaKOX3hZ1zD5B6ArWQw?=
 =?us-ascii?Q?Rf7AhI4iGQMNkprGgm+PUZ3kAqGT+huFjZLpKRQor2IbpPoUqe+MJOmFdRdD?=
 =?us-ascii?Q?CSyxlD3j8DSDx1qEqXF/wDnWzmCk8+7Vlv5WXOSxIfWdAqRf8adJenOHzGYr?=
 =?us-ascii?Q?clilsg362qPmVjvhdlR6b/QOavvndABapcpgySw2GRXdUgSllPjNBhkNsj2s?=
 =?us-ascii?Q?5W4iwpmuOLRexkVGxmdigfWS5icNbRJFoOq4NLK/VXtIE8R4O/NNYjFPnJBI?=
 =?us-ascii?Q?bliw0/y6rMSdT4geKQJBcE5ZsrkYyj3tUAfeKQ3BzNhWdcacBJ/EqkGupHpG?=
 =?us-ascii?Q?wj0amobfIaUlxnj7gGnQ+X5fSYlabxao5L5JGOOQiH5PS1B4yDbYRdo3mtVo?=
 =?us-ascii?Q?hHSczAAmKCUMVWkdYjixsbZSH5QK7SWTR+g98ACVpn6S+f1Ju929v1J/rkMh?=
 =?us-ascii?Q?kQZ2R8Sj2NakIvS7LKFXQ4RTA2U0ppMjS1uIgC5HSa2LztrpKTEtVTS4GKRI?=
 =?us-ascii?Q?biwOxTUq0I8+f8GvNMabnr3mVr+cjCYb91wH568W9MvuaInoGuLe1lcytZjS?=
 =?us-ascii?Q?gy54Yh61IZNbpJ3r4oLSrCcqOOF/tXhmYzRrKStusxKj6yNVoBdvpWvH0siw?=
 =?us-ascii?Q?YmMfWBZoC4apzA1CBNzWthOW74hCSGrYXZUmhHlo/8yzo3yN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09cc011c-8587-46a4-c6f7-08de6591bf1b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 15:09:38.6410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jHynTu7G8DbvZdPXjjdvJ5q1suDBt+CzoBqOTBvEgsjJ/o0Ahap/Pn0yp7SXbCU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5602
X-Stat-Signature: tcfsrc798mzxfoz44qkyrhmca55wogfi
X-Rspamd-Queue-Id: 32BA54000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770390585-863944
X-HE-Meta: U2FsdGVkX18mMrQvVuYqK9y2rKdFBbS/4Hb6zDWmM57Wv3Y7NSzAW2QYE5GEoKWzxyPeIHqpK7UzYT7BD5HtjAWkV1Ph+HxUYUm+EzoomIUPqVdrEBqQieWglZ/MrVe4lWgMDRjrQ6P92z4dX+dNJ5oAINoT0k/gAGTiDlBSs4TrebUJv03+tb88MoNgiCxYuGpOywcZN3dlSOGq0FI4P9f4mQWexDsCFD8gFYEM91ptx7hPoMcTPSWTAKlp94/BC6v1eLNVlvq5xyfTAtVcORrAyLkERX3hkS9YY+bJcKyCEOM1nGD3gPWacDCdJIQYSp+83j9s7Ym0n/j16OF2pVLJxZGAqSsFJtmJgphqRU08K1QLlvZZb7/l+DvmZ9yxLL4eU3cVutQmAlfPTbV3Iam+KDSGoWx1Brs4JfmN9NDac43oGhhME/LPDkPi8dlxJztw1vOkJ0XfV4iE7EjKCCfN+IvJiTqAcVsx9dIaq0cD34eOGVr2aBgWBEFHnT+ItggOXJ4k0t7IojU4YlN+CXy0gvIEvnYRrSsBYJ2WyUaof5sCb2RH0EHkxcukw6bunvdI7S+dF9RUOusKHOTZdce1u+QzpWhCYrSQ5M8eOCErotH6Qh6wIv08cWtrVayQX6uwCqpaK8t6o9cf++p7TYc+V8YL9unHYiUfZ+Hn00E9Urf+DflzrwGO248u6Z9isZ0ZTYD9+GMmK+ME/HdqyFaRJHIq/3plc62A1pUiv5JBn4zxgkd0IpCcfmoGWn+L9QTSwkFF0Fnsl8gEbOPzrMksFTJlvZu7RAcLJl4kWYt1eu48LtaxkVLZh5Em+rywnsVzyaWuyOwlUk1Vpg0pTFjwwOrpItPHKbTa9MiPKtfXSjzgx4gxbBeHcyIssxZsXwsLmsVbz/U281EWnEmVT97mkk0KWBoH2MiljSX9zl7GqZHnM5xwKAoGnLdnEkdNJi32N0xG0aj5ZifiScc
 kuXW2dGN
 FEikFxsfapBAWJcDnoqKcOk5vich5PhprZqvrsXmsEYhYYsxAjRyZPpsuOJ00u181KWv/RKCSr1t9riwDXtC8HDLLQObA7uiWLdYu89ddYRcgvew+LMVZUuOdeQYVwu7+MKGoqASRrW0rYi88S3cyvw4Yf4UopdCyIULgTfFjK66yGNG/M52a7Ase5INHSGIbXM1rDgDzegVCZ7TptDUiPoaeBZHEpINGSj4ChYa8JjU2zZMbf4tAYh+4sN96n8pG0Sc///C2tbrrNeS+sWR7vTyYVxk2J44S5v7AgP30y2jo0CengKmeuRO2iGObxaaKJ9SQfKwnB/cgOpt267mOvTcCpKu4sZZHNFRd04FVlRhHGOpF6pEYzsASyYRltdqNu36iNRhcrWR3BdAXMESKvxRfA3WIMWThMQ3kwSozrh0fn7rQ4pI69E/XyXImhlKiYNd4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Feb 2026, at 2:04, Qiliang Yuan wrote:

> The kcompactd threads should respect the housekeeping mask for kthreads
> (HK_TYPE_KTHREAD) to avoid running on isolated CPUs. Currently, they
> are created without explicit affinity constraints beyond the node
> preference.
>
> Add housekeeping_affine() to kcompactd_run() to set initial affinity,
> and register a housekeeping notifier to update kcompactd affinity
> when the HK_TYPE_KTHREAD mask is changed at runtime.
>

How about khugepaged and kswapd?

khugepaged thread is created in start_stop_khugepaged() from mm/khugepaged.c.
kswapd threads are created in kswapd_init() from mm/vmscan.c.

> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> ---
>  mm/compaction.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>


Best Regards,
Yan, Zi

