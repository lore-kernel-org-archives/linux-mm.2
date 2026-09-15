Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 116EDC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8BD6B00A2; Mon, 14 Sep 2026 23:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0FA6B00A3; Mon, 14 Sep 2026 23:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1906B00A4; Mon, 14 Sep 2026 23:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFBCA6B00A2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:13:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00059802E5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:56 +0000 (UTC)
X-FDA: 85214527314.23.3E6C767
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010071.outbound.protection.outlook.com [40.93.198.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E6D940003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XoAyOmrO;
	spf=pass (imf11.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.198.71 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgJTrkbSXsk/Ysc/nC1MLyJzpZtjgLsqhRT74bOiJJQ=;
	b=Cc/OcxcJL6HVitsUW0smfCKdna4n15n7VSYg3SIv0FA6xdgxHSaObMUwbX6qhMklBknQ0F
	rgesuEAsyM/ymtusNW2dY6h6ts+zY5OZCKrM2IZKkG7qupsff3SePGtq6KqwlTNjmiLLOn
	73KyCxXLYdHisVQeT3W5W4zMiLm4Gwg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442034;
	b=E9zWNK002AXhPbb4u7AB8prOPIKlodOH326qlNrKWo4fLMOaUTCRyrhqLwxtpqRsPXU4RD
	Qp11uDd2Z2TNvTkrEKqFpjrlY3RS2fNrjESzGo4l9em5LPTDheRifvvzkWkdjxTgBcq7P9
	uWq3o5tOtXCcYorlUc0/ep1QXFwhACc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XoAyOmrO;
	spf=pass (imf11.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.198.71 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEW3A1+fKhN4tcmqOSfwZ4KzsoCTZYgDifv10deRuQZfkPs0NKiF+Au+OsSDOT4QVsZkMZ9eKu+1vi+hnFHSHqdgqd1H6eAxXcYagu5Yc0F0SInYHmnj1CO1iCuYGuShDHiaNTEZ3AZhyYFu+ORPuYcdlBzXLto+cjHqIdb/HXjxPISC22SBuM2A3IgfO2SDP8kIxn099fCWJajie6lK/VLffEh/gpe1u9NPnf2Zkfly3Uso9R41bXinTdp+YaKjwmClMtkjYx8roTtE94jpeeuaWn+QKUHhtRDkcPyrSnCIJKgAR5/Jju7a/LJMS1a4gpY00aMFQI1wC/V/gsFARw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgJTrkbSXsk/Ysc/nC1MLyJzpZtjgLsqhRT74bOiJJQ=;
 b=Rxa+goYAVRSM7LebLFbRBjJuQsXuX0ynW3BbvCblJYGiwBmyDr59SBIubqXiG4IFSZ1fXjSb1Iqr/217hVpy2cY0w5op3k7iqg8SeBfYjtsRtOSrNX2Adpy7RWfjPgHL04xZ6V8TMIu7SGHdQcyyIpalrAlEwadgpZ0R9Kklv71QkkJoNftyG0uXPDxvqFrgo5JGFwx7Apc8x73GZsQWmhUF3ByGge/8GfUu9b2TWDsayOIAlriZimcg0fl2DPykLoVw1ptFz9RujRw+2dxFjbNdaIqMoZOiUl+gJaG+UO7gj78HF6Cj5ZrdTxK941nqcXpUifDqd9+dwMdZY88ZsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgJTrkbSXsk/Ysc/nC1MLyJzpZtjgLsqhRT74bOiJJQ=;
 b=XoAyOmrO3mVrQ0rgMNm95Pq/X/dH16s7YxtU2hjaGDwzmgmAMvNQS2eciuv3UYiJMUPwiqGKJxTcldZO7uxlSmpd1DNSIExtyhtrEd02uIbw6uE3PgqI9bviT+z22KLpPrKpXXLHfymOkVTQnV8zOXq+07tJsGGsHknFu0M4UWcHY4JRwRD+/UnCBx3qNwuWEx2nnYfSyt7pxwDiXiQ/nGLbWyO8CaSz8PFgfA0d/wwKyo8CYKigVpYEKgCZKxk4faTThjzWpkpXznfFxQKiXUcCaLxNzy9ParHBmhJQbPzqBAZXscURA+vK2EaXb0JNNuhamBnJanzRhuULQS/bGg==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:13:48 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:13:48 +0000
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
Subject: [PATCH 08/17] idr: enforce the static-storage contract of DEFINE_IDR()
Date: Mon, 14 Sep 2026 23:13:23 -0400
Message-ID: <20260915031334.1194975-3-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0175.namprd03.prod.outlook.com
 (2603:10b6:208:32f::14) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c8f39ad-cdcc-4f11-b510-08df12d75c12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	7rOpFyrVmvAO8tlkEBOUtjgzSr48cw0TpHiAxq/C8dG8P5VDP4qDAMp/NCWgbX+8SF9dz677r8+M04HeSJFSxn4pKwPF+uVGbhMKvRJU0XqN1UhQpbBkRsuQXiPcxBhfbeY5Q5N5u0pJHuOgW5wXzkugSZRq6rYo4XTc0A4K/qPWn/93Rfx/X7aTX0oJcsoFJqt3GsxY2dQ3ZhqW9IKlm/r6gWjld5EgWkZ83Py/b0LHc3DRjOn7yrC9KC5FMjg/myYmOacon3MoF8X3rw/i/MiqrQf4xvqK29V95uZF+xg2CGeoTJMrRcrRyJhWVfekvRkFOqiB7K3FKNevwIhGlhi/HWEImYJJWhbOtjShlyeP6K8uPgQyGixvSUA7n4Xeq75qciANx4eioSpwbZyuf3yAh1oQN/R6XQ/IQeFoc+witxmz3b5ZdFo56PHwUf9r57HDUQAnAmgHjHdbxucQ4PYAru2s92jvbrAouNeG3g2CDU2dxUEhGCCKBdMi09hUs9uDEEB2tXq2iViPCQLT1gIvQ0C6LE24HkHiStTdg1oQS9Q5XrMXvc2Tok6flzbFRhttY/DjQI0ljMov3DEEJllFmxbWcVWiT8YQpvfXJYG0M5XE9zve7dS3fEDpBoVrbFMzNbMH/t186fEM5Ug4gYj0dxxEImtu5I+9hrbbo+o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VGte8XEzn4NOoE150MDHIX052sAUVAyb+riQMS2GFH2T8EFEXlLEAmSpCiE3?=
 =?us-ascii?Q?6tYBJrF3VQt6VNU1hdq71x4DIHKSnFpiXkM27C/wFywgXiT8cNPvhZGQ2AS8?=
 =?us-ascii?Q?HzNbSw4sf0idlc2FADXj8yJp4wT0ONisWwJy/XDTyNEJSGZVT4XwSWcM/kjd?=
 =?us-ascii?Q?PgvEQlmg3dTU1hiuK2T237DHQSrof/ywO+EWg+oxGpbXbcki6OEXFgSg/TRm?=
 =?us-ascii?Q?vESIn4DN5zNsYTfJ7s+tyI2oTMg88qjAC00MY+KQwA1Prj0Udjm8gB1ydrxl?=
 =?us-ascii?Q?xBNrAIWngtEOAqxUJKtcmoGy4cHJoUOA/9U8S0SKnrSaLLinDKne5mW9Cdu4?=
 =?us-ascii?Q?SfFY/iAORvrMOMubZ44mfgM1aCMakl6J83pS/1ZHVE7FSPODMOosNlWWahXj?=
 =?us-ascii?Q?PSl+TMMETgVzYnxX8Ez4511UXm+TQdLoTcF4yr8Gp90k9+P9XVKC6nocZpxl?=
 =?us-ascii?Q?kfi4DoTd206fi50Cn7lM8BhEygs6BMdRaXhPgE3QF6L6kKeHN5+RY2w7g/X4?=
 =?us-ascii?Q?bvyZynlfxPdSnt6oywXCtNrnxdZqk4duuCGKrCHQLNPyjhA9yg5x3xjvC9qn?=
 =?us-ascii?Q?8BgvYvQ12HFcijTWvdEFjlnAK7ybZS84W0/0RmRtqzxQqPH/dDi+29BV82oI?=
 =?us-ascii?Q?YMhqiBSZWwPE+eUQ7NscxP1yI3bhmDlzIhRFoTCCARbgUCUdRyIIsMLvVcqJ?=
 =?us-ascii?Q?uI5dnEyKKhszTWuXvCM7LJqr9L6DK+iKPMVGN/iZbgDS1ofuiAsq7iobCEsn?=
 =?us-ascii?Q?1jx/JKIyuUWV5vCB+4duUktpeXYTjiLqpYK/iq7Kcq/WpNW+YpOv0Oxfln2X?=
 =?us-ascii?Q?bkozuomjRaoG6RHfiCyhaLJJIUZrbhiWY6FVttfBRuWa4f0YUuK3XFwdGQM7?=
 =?us-ascii?Q?1EWDGCWgGHg3+aHyNtZaZMrJkVZZO9YoD09dXxUq7P0Zom2tOc+ICURi6BWg?=
 =?us-ascii?Q?TQqqYCHzQD3e6sskjD3fPeNh/K430nzbdkEH8H9uGUZUdvHV6Cf5AxNNgFA/?=
 =?us-ascii?Q?JgLSB1d2ZS5T/BzAmqVmuIAoJUTIJJw0FCYA4CmG1IKejtD6W7DzclD18KEX?=
 =?us-ascii?Q?HtYUn/9VHwS7MD5rxXcKtSs6qwADZXVdp2RsUkJzuC26oVpHwn9wNGmqR/WG?=
 =?us-ascii?Q?ySHg8JXcbVCpn4tEb5AKwErec85ETUumE6cqoHkKRq9kG6PYMC7wGcVdWW/H?=
 =?us-ascii?Q?j4Wda+B8lLydW4VLp2dl/LXmTI13G2kXrENgJZBZC9uWDW3We+4y0AtjHrb2?=
 =?us-ascii?Q?BseDTfJBOtSvWpFZ2SzikHuTOBUvXqYCytVAGeldKBXK9f171ubBgZ5p4NPJ?=
 =?us-ascii?Q?LRMOS9/uogT10ADZDIJpcEtCFSjnfI1eliJOwITPnJJ7wb4MOTOO+1JdiKb6?=
 =?us-ascii?Q?6beNgF+OebF6RNrNQtS865+F5Pdi3WAqD2v48y2zpiNkFWr9eTGb0kiKGxc1?=
 =?us-ascii?Q?NcWz8onKQxHzJgnL2dyzA34lkMWGBCkHknwFMsN3IHXy6vvK78pUtiHnSxIb?=
 =?us-ascii?Q?WHsPo3BuN5wGTnjop9G7NJf8OhZ48DaXT5xfRFrODVdsBm2tNjaeQA11Gn7g?=
 =?us-ascii?Q?uoKXDueE2LsUWJMudqLbZa1yO2D984k6p4UuQeMXO/eDSKNeMNk1EDNNmx6c?=
 =?us-ascii?Q?yU71Y6HCXx4u+sEw6nwWg7/wBsYM3KpNA/hUW2YllkwKtL7nAy7q0/WXqN9K?=
 =?us-ascii?Q?UtjiVNM7d8g9Hjq9KmYogxcMvtmLrfkSv/T7SGBl6sY6EL4a+xGrFkOEBMlM?=
 =?us-ascii?Q?sSRJbeXSZQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8f39ad-cdcc-4f11-b510-08df12d75c12
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:13:48.3868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qI+SXR0SIYTnNt66L5Sa7slN1ng38WBgzEVPjtjIO8rSNARWToGTuBGNY8RGfeB3zWXW/0jGxfOdoWs8MZODgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Stat-Signature: ryxsgyj5pcd6a8o5ud9ysibwtibfnpqs
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E6D940003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789442034-233152
X-HE-Meta: U2FsdGVkX1//XNULGI2E0KwO7Gtbon8jOE4qW3msGFSqna6wsNBwpsjy+/HoxcTuTZvNF8zasnRGfHjQ65Lqnm3Va2qAPBubBtq9rCpkltAL2FZMEnetsRUHA04PnADEff54/bDfhdYRyJW7WMHIWhpxexkuekpLpcupEiaYfikO+N0p4xxFKQNusclGz5uX0iG2JFoPu39iF8HdsnEO9qtRkpjQK69H979rlVkakc59xA2U51ui9R9iyhYX8e0e2GuyWd4U1rYHgrqi6kb89Wh+ZMoweFUADwPtqiw6BnwdGRh6OpDB/0QXxqt67isl278GXw4sqmrg3DqnJIttLLN2o6Arm4O9gl5X3MjAwW0Joq+Au+M6uKp9XjD6ftkH+UPtNT9Q8k3g3w2AEbs3Tfts5ZD3R65ZctgHRVcdgBZ6Zg6BZzQcVB/7toFNo89dfEbFni9a/chTSjNAq+XKwdHKLrLUC4hZ5zevItMAobza1TPKubC5Ct4KekBn2Dt3dwn/+wGBneWqRkSJPETlaXe9Jp3FndBcKVkdxs49pi9yyUXE+vV8I7VMe4ZkZgLZo4mgdylFa6S2fwAVxHbeqgQCnm8XiGVGVkDHJ9+zwUqJiXj6cq0LRBFA0L/xClQ6wLMoaY0cW5GlzMKemA3AQkqgXGaFQSsXK7CECCVlDVcrGXrq0odC9FRfbgHTtcicGw+SN5FW3fUw+1Z2GM/4o2s0ug/ClLXwTc5uUDAAFZvhr2810h4YwI+9dlFbuXQJeq1q/N80IPk3aY4N+1x5/MerdbkAIR+2UQqDBmGjbSMVWdJ9H0XCe5Jl0znKgg0Z7BBVu5ATPmb8671mSOr/++F6g5sYiHsO99p0nAcfwAo/9Bd7xlRUMBYKUm8bCGq1IcD8cQUXp/b+fXAGIZ2C4xhcSHJ89HE4fZ2PNR9yCzey1lhZCLUBOHy+WyuKmGbDNcmYLpm6TIy0MRGDnvP
 Sktch3dY
 Zrlh+vdkEF0T/GB3G196LOgnh0JEDcHSKyu+Ict9tTF9z7TfPBkbMtqty0+OP0woN4KARM1zKhV/M/3tZDqwMXbDzD1S8UarO7+P7Js5mP/LdNCYTq/iHUQpWLUtdk8k2tpfM3SqayV2tG2o19H1WXumBfA7tPvhowFJK77iTeMQM5IOzdX+F9Xna3gpkiiYsGeMu0TKKooG+9vd6gY8Y+OhGolwV58Kbwwpw0ilX8pA6g9AXmGCVfIZMsrlCnE+QC8NBqsW0EefWqIKStajHpE79dSSGM0F29IFOexs5IpYZM0x/HPhJGA1wmKg5yCNPIS8VD+q9Mr0GT2GaUwhfsvLix3M3GAaaEebvhDGfw+4m87OqOfTdPIBWkwPt5h+czvBcg0d70FWv0DVf3nKSPRvbgR8Kc/Xo36j9Mcg3HG1bYzsYRNiuVqVXsY+Qav3iw9fRQxxHK+l9LtXGwiyngzEWizrL4h/E0xjG2ipYfXK0DAlLyaOY1hBa0PL6CknDMYU11yzedX1ZVd4mLRgYdyrb/zjozrQDUHzgNcy6YQjLeC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_IDR() is documented as defining a statically allocated IDR. Enforce
that contract with ASSERT_STATIC_STORAGE(), matching DEFINE_IDA().

Normal IDR operations use external synchronization and do not acquire the
embedded XArray lock. This change enforces the declaration API contract;
it does not fix a lockdep failure in ordinary IDR operations.

Convert the seven automatic IDRs in the userspace tests to plain
declarations and runtime initialization. Two already use idr_init_base().
Keep direct IDR_INIT() and IDR_INIT_BASE() initializers unchanged.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/idr.h                 |  4 +++-
 tools/testing/radix-tree/idr-test.c | 29 ++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index e2a4b6298511..d0393b7fe985 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -55,7 +55,9 @@ struct idr {
  * An IDR defined using this macro is ready for use with no additional
  * initialisation required.  It contains no IDs.
  */
-#define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
+#define DEFINE_IDR(name) \
+	struct idr name = IDR_INIT(name);	\
+	ASSERT_STATIC_STORAGE(name)
 
 /**
  * idr_get_cursor - Return the current position of the cyclic allocator
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 6fcba5b5870b..4668c6a4f6ea 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -33,7 +33,9 @@ void item_idr_remove(struct idr *idr, int id)
 void idr_alloc_test(void)
 {
 	unsigned long i;
-	DEFINE_IDR(idr);
+	struct idr idr;
+
+	idr_init(&idr);
 
 	assert(idr_alloc_cyclic(&idr, DUMMY_PTR, 0, 0x4000, GFP_KERNEL) == 0);
 	assert(idr_alloc_cyclic(&idr, DUMMY_PTR, 0x3ffd, 0x4000, GFP_KERNEL) == 0x3ffd);
@@ -79,7 +81,9 @@ void idr_alloc2_test(void)
 
 void idr_replace_test(void)
 {
-	DEFINE_IDR(idr);
+	struct idr idr;
+
+	idr_init(&idr);
 
 	idr_alloc(&idr, (void *)-1, 10, 11, GFP_KERNEL);
 	idr_replace(&idr, &idr, 10);
@@ -96,7 +100,9 @@ void idr_replace_test(void)
 void idr_null_test(void)
 {
 	int i;
-	DEFINE_IDR(idr);
+	struct idr idr;
+
+	idr_init(&idr);
 
 	assert(idr_is_empty(&idr));
 
@@ -150,7 +156,9 @@ void idr_null_test(void)
 void idr_nowait_test(void)
 {
 	unsigned int i;
-	DEFINE_IDR(idr);
+	struct idr idr;
+
+	idr_init(&idr);
 
 	idr_preload(GFP_KERNEL);
 
@@ -169,11 +177,11 @@ void idr_get_next_test(int base)
 {
 	unsigned long i;
 	int nextid;
-	DEFINE_IDR(idr);
-	idr_init_base(&idr, base);
-
+	struct idr idr;
 	int indices[] = {4, 7, 9, 15, 65, 128, 1000, 99999, 0};
 
+	idr_init_base(&idr, base);
+
 	for(i = 0; indices[i]; i++) {
 		struct item *item = item_create(indices[i], 0);
 		assert(idr_alloc(&idr, item, indices[i], indices[i+1],
@@ -229,7 +237,8 @@ void idr_u32_test1(struct idr *idr, u32 handle)
 
 void idr_u32_test(int base)
 {
-	DEFINE_IDR(idr);
+	struct idr idr;
+
 	idr_init_base(&idr, base);
 	idr_u32_test1(&idr, 10);
 	idr_u32_test1(&idr, 0x7fffffff);
@@ -360,7 +369,9 @@ void idr_find_test(void)
 void idr_checks(void)
 {
 	unsigned long i;
-	DEFINE_IDR(idr);
+	struct idr idr;
+
+	idr_init(&idr);
 
 	for (i = 0; i < 10000; i++) {
 		struct item *item = item_create(i, 0);
-- 
2.53.0


