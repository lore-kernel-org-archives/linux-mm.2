Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65798C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F7D6B00A4; Mon, 14 Sep 2026 23:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D556B00A5; Mon, 14 Sep 2026 23:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D92A6B00A6; Mon, 14 Sep 2026 23:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E34B16B00A4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:14:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C1BDC0300
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:01 +0000 (UTC)
X-FDA: 85214527482.05.EC7C409
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
	by imf14.hostedemail.com (Postfix) with ESMTP id 780B8100002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=paw3fEKC;
	spf=pass (imf14.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.48.7 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bL1XeoRsjprSrghUuJnmyCfeiaPCYOiz9KIhr0c/bxY=;
	b=HYWzuUunHQCwAqC3OejHOuAXe8K3zyXLvr4WsdE2PhQv+hAjyY2mEDgfJiggsfmm2wqXbu
	aVFj2yITSxfT7MFEg7Qa8KpQEPuVp+4Qe5RFPur9WlPfYJXZAgNliURmgCcFKztRn1mCjm
	7CP75TwLXPi6E7lLr3Lmz2agzrBE7jg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=paw3fEKC;
	spf=pass (imf14.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.48.7 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442038;
	b=nlWPyTTIl0eQ+bM7NAywJdaKLFPwiTCV6loLabrAsz5x0gDzIUh6v5OXaG+4NNqY522bI5
	QseOv+i636NsbNl6LO0NPxgK77SpDG2ZWTSHASd7KEzLSjV2qW1bNr0F+wlpuJAk2vIyDV
	8m9a02wH5KcOg14ZLiD2cS03HXCFH98=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=La+aDAkfL0mNVzOdP9PVTB8S63ufYu2mf7b7Kdn33DgsTeb02riYuzYd6PJNNMm/HobE3SMjw3oPUVyLumTh44nbTzc3R1//aOyac+I6B2uphfwtn7qfMZa4pa0nwP9fnXH0AblzzUrXcQAKyMrm0zoE/4iQYlszcDKV8zetncpygy3yQ2NPzami88UfaQsVG9Cim4m+GdLxhrJCRFZVUmF2raaMBV7266whHbQQOloN4qtqVEdDbIkRwOOZBfsKuh8W3JvNdbXqcwbputkxh0X78NGVRNtnVhRMKR4vyo8zmIRPXGCutDM4VpzJ6N8VoB3vmauC5EKGZlXRbZ4gKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bL1XeoRsjprSrghUuJnmyCfeiaPCYOiz9KIhr0c/bxY=;
 b=O3/Z5n4R9I1NDdyKWB7/V3ce7VuR+uvl5g68neb8mCeWmDJh2oSZJDEOajorj01uOtcKHMhW6R/YUXHRDG69UnWzLPnBdHGF9SPnE8AFXlCHCfDEHIgIuZ5eyxV/pP5zwq21lZkhzwD3PR9NGZ+WVCcC/Bao/LSFCr7UCgErupWIYYbrz/vtjiPloqxOeCzzwCyuUi/uiH+BXMdRQ76m8li6w/hCSFtD7DhMsO8PKCmkTbsBfQ2g83AenDyXmiz1K+efVyr522DdoJOzyodSa27WPBwTFQyFVkfoHfbUbvti90xjrXc41t0V1GVbeN2W2ypqxQPhmM94uSYDt6EQkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bL1XeoRsjprSrghUuJnmyCfeiaPCYOiz9KIhr0c/bxY=;
 b=paw3fEKCdhV8dCrmA1q72vY9/6HhSFB0/G1uM4+CsGzvY5zx21F29h4UtOU3OXTVViViVbSlduo56CAuuPS6KBkg/+CwBWSgP8RzftUmEbfZJoOrz1kN5e5p5vn63zmok1aLKNjaCNRHBOVusa9xQNPODLfrZZKB+trHquEjBQNxuFzGxOduqjMhoCRJwHyIHTlZO5+R5kbJ3G4D2XajaJImIwDml5o+GfXJDBgSCWe0x8ThImSI4iByxJaF67pj8BEXxjB1CCYGnQWLLh1/0IoK1XM/KgaLGWCW4VAXYlBNZ/yXuPAB8KWmpJiXsLwqqi1+scbr5df8dyl6pJX7JQ==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:13:53 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:13:52 +0000
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
Subject: [PATCH 09/17] radix-tree: require static storage for RADIX_TREE()
Date: Mon, 14 Sep 2026 23:13:24 -0400
Message-ID: <20260915031334.1194975-4-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0040.namprd16.prod.outlook.com
 (2603:10b6:208:234::9) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: de3c6747-7ec1-4239-77ce-08df12d75eb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	h2cZQPW30lx121tesGqD2YpKH4muWOYNLF96F6ZnyAS8jOnYo5V1dwcvgWYU1m1O9o13QJRh6EfUJXY+y7htWBkpn174K+cT9o+M5IOH50cD6EgBrng6xwma0u/oAql8uSyvo5PJgQwtQFkZ3rKojhKN5+xC/MXL2lC3ZhWQfI4wEc2OBHn6Owg5AAO3HXuZd7IMF/vv+CFKCtXv9wnB0sKc8wU01O9W3vQCPLMPJ9/LE4oH4kdDnLY8QbajzAKLq21oVvQTTuY0xhtC9xv9EP4nYALaL+psYtnw62o23aUzEpO+kc05jyf9pqcVST+fZ53w3hSO5tR0BIqtGeOXYgn3XU3IA4XfBiu0S+zgdKBgHp99y4MlaZKgEBhQf2H7j5ALjDtS8U1s59oOad90iG3+zW5yxi3rWC1x3SvcsIEnMEwkMIkERRgtwnGkHmeCADevAzJwyIvjM/ByvJTEAJhvhJDWYllCq6H19ASMiGhgQuPtfLdDFr+u9OWbIDgtdsThYlmHAzHr8JcFqngQ+21Trdj6rDjotkgh7AP2wJbkjZj4PUYzmM8c91qpzr1kImNlxH5ZPA2OEpelnRmFjmkcpbPG3xS8znF8Yj2owmMrOW6GeOvSLMKlpJ1ydQWPcspc6GX8WvKm1G4BD3TO270NNvSqHEoGbGe+xeLQyKU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uVZoCX1GrOHs1U3JKZ02FlPkbDhNwaeObmm+pfucyyKudaTQhrVyRlbTCYP8?=
 =?us-ascii?Q?AMTrEw/5GijjG0bwbwN/YbqamX9RGI8wC1pV++0e4B0yZBVoiM/4YSGvy8qD?=
 =?us-ascii?Q?VaMrIDaaOcF/Lv9UeaQxVQ+/9Kp292WFg3tFzMG7Bq62a4wyuwMcYF70NSI8?=
 =?us-ascii?Q?q0UCiqaGiyCGe8HruZhRWMJhZyGansdHdiMSdXMx6IeUl+JpHSXC3sjaSpQ/?=
 =?us-ascii?Q?C++U9nY4fgdfoIrpvZt0qG/aTOz8a9s+FHRg3hSHbTc8hg/OnVEHxC/QZRT7?=
 =?us-ascii?Q?8QevgD0T8YUz4AVyzDbBT9I3+TqJDw31jD1WTWQ1G7NTklUxpO8LQIwf0WDm?=
 =?us-ascii?Q?Xkfu5vX0v3jospzJ72Eap33Z3r46qbNs47at2+dP4PxIpq6tkBLxXAKSwtqR?=
 =?us-ascii?Q?PEQTqPv8fx2wpAW2AQSSg7fn4w3ArjJgZs1Exjg9P7y0LJcq4LhlaoMVRnaS?=
 =?us-ascii?Q?+fBGsNC2cZ9p84tq3sCpYPNasHSV9aUPFUZZmxBJnDbN2kmSUI6BP82to0EF?=
 =?us-ascii?Q?INCvi7LZF738QX3DlUiY5Kj3jGO68ROa08YjurgOQY+/4BegQBJk27PcXH04?=
 =?us-ascii?Q?KKjWcOkGvVnIwcsB4i/6lrfJjfUynEDTPgUDu14XeIaPru37SwdH6U4o6cz3?=
 =?us-ascii?Q?j/houeYbj26PW9n272YJ8ChMsIH+jp7kY1j8DEv//sAqgZ85+cQo49PSjRFp?=
 =?us-ascii?Q?0qI0sTtaKeCxDauvSvjdFe5Ksl8OXOvax+ggAHcOA38GD3pANrA+lFkbHj4K?=
 =?us-ascii?Q?Gf+Gc9UGJA7KnxWgC20OJruwI4FdXG52JIOUwQ3/mRLuDzRDpG4Vrn+VRe7B?=
 =?us-ascii?Q?nUX1QcRS6SDBTOD3ThoJugtCWjHyVmFfoBXcTaoU1WpwGReIKPGX++Do+fi3?=
 =?us-ascii?Q?TCBqe6vzVSfBVUpM2owd8qW1z6tVuuYQ50x/ExZwv/dUAW9p2cX+qWxd5e2a?=
 =?us-ascii?Q?1gVYWvEU6KvsuwtYfmgxNGI3wbJzA2XM/ovuEOqWyNmfYnRTrwWkPmmhaE2q?=
 =?us-ascii?Q?6S1Ryta2KNSCkVSijuVn5T4NN/wKCDJc76sqq3YnqpsU4jhTyhjO4vFXzXIZ?=
 =?us-ascii?Q?k5qcwh7WyLWxoYl0iV+ypmfFA5PBOMzGBNTMFP6L5ICsNH5E4YTkM0ODhK6E?=
 =?us-ascii?Q?SBjW1dUgkG+ivc1iAam8S6mHTYe4G7YMPrzG0FXDmJRbORmI8T1+5XYLk8bi?=
 =?us-ascii?Q?qUCxoVbI1rrhLk1rRCdnzQUdsfI18QY/ren9I6qmyunNYYzNyJvmc8emHUjv?=
 =?us-ascii?Q?v6ORP8RkNp3drZDI8NMol7w6sDO6vmYBGXirlxR48+4P5zpkewETPD1T0CWL?=
 =?us-ascii?Q?nyJqsfRIB950t5IZCsaC7EdpbqV2Dw8FZAVkJz3PB5lO+GlQjS5CjBPbrwLn?=
 =?us-ascii?Q?W1KBJ29OKuQ8sUYPoak/p4uRTbgvzRwQzDCwKxCp+myE6dIKAYDRhhYe1XH6?=
 =?us-ascii?Q?ziIJ8T56I8Ue1u7UGenX3GkJ9itnjDTwb6JqNnFwAq9JwY8Jw6wjeEhx/sG4?=
 =?us-ascii?Q?scd0uMUEJygdbTchXCrNq1yQv7sPkS7ZZ59EJfdDx/I2hEOAoiuBH8+xjsUC?=
 =?us-ascii?Q?7hZh973TfB+h4PPqPPS0+cf50pTInkyrfOqb2ae7/8+NJmYaOSFQOUWrwk6/?=
 =?us-ascii?Q?oluYx/9+a/1Trln2snlJtYk8DH3uwgt8Pd61Y487rubG1fX775WW/nUC6xjx?=
 =?us-ascii?Q?oaf4UcsxFtZebmFKXIVLRqQ+EaoBxbwbul4UJyoT8Y+DcqvKw1yLock1kmOV?=
 =?us-ascii?Q?SzTFjirWEA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3c6747-7ec1-4239-77ce-08df12d75eb1
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:13:52.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xYVi9AkwSB9ZyMM4wlV9gJmsLPACF0n1XSTRG0Kxd0Pvac2Coh1VLy16ctnTtcPEzLDvIpdDdngF2eZbyWM8Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 780B8100002
X-Stat-Signature: ry6b19jo4hn3ah6ymf8f1abk7mwa57mb
X-Rspam-User: 
X-HE-Tag: 1789442038-816343
X-HE-Meta: U2FsdGVkX1+h9X/kmlBaPvLbo8rcXT0gUVtd3FmXMx20tBzRVec98p+8lkaKXeNN5VbDbedfeM3J+x3rM5/X8YtrtrtSHYrnsBvbZMPoQcimz/Ev+RF6nWRTtOYUIEtB/yOUP3D+9jfEBBbqUHQTVfIsWYz+G+aAfZsR32YsoqGwntiNlyEnvcVV9cS9Aqfz8G8ucYtIG9tO11ZcENMIak+bHnuOszEqN3hfkDc0iTWnASPxOxG33oiKCBsC6+5XYMyvikAW1+rwWiJ+GNBJ77RZa13SVM+7obEPQb0x2d+4lHv7ucKiDigC5keFAbhd/JWLfqfJwXHpudklSLh+ypV/G9YAeXxAQj2RLxPV36Q3syD5dsYUK082n5upRRoQQ4IzP7AwRXM3xW0wbcM7U//4wF2WhkIvVl7Fa9a5pciGV5M7pzRgd8EEnWtymoZdX+17tk2NePDU9UBdElZF8p6Ri9SZjeLbVois7WhklIPDSEuel9oGEQgwvRcsgeWuSZcvY2KbnlKb/S4Q62S5IHLxCHtD/o0R41vgnEsqDdAhh3WX09zxRSW1VrR9RIMYFIh6IVaIMDE1FMcPZmIhSdIIF5GFdrAswWI/6dTSkbNlMFlAfFvvqtNBCsNcksloqmHrfCSKtpsYKWoDrZBiufE0ywJndWznCPOvfKbvAtSvoD7nJjiNJp6NGfC2K346yhHTvVDlQl233Um/y4uCC8xcQO9XtVlXsopzVKYOfEYnzToWEGG+UpPiVlIEpeVY+lYUfzV5o6KCT30B1nUTyRmv6orv/2GxWBbsGBn9sC3RnUPBQKb2HY0zjbJhJ2lG6Cmz2PprvEWYy58gtLiiM90yn6qliFpX5wsT1dTrpgOkjuPHhoFX6uj4ckexm7Tv1p0TN94V1ZYNx7Q6+Hx3sbnc7bhRrt8oi48uJxnzBSWPjSqu9qqFlzOkW35zKy5+BBbxr5TpAX3pDx+Jk4p
 teIQIQZj
 rgadwOV+xyIm9bgnM/shvWcAQUYdWxODaXnurwUM1BY1nY4JLhPsSqQ19CQwkLKMLaFJG2UenDCL/1/sTVPzLJVaaZrbOytNFJN3SqB0xqdkvxM1a9KJHNqnuM4ue9dssUflq40goftEcPMolnAZQmr6jGQ/uQPlby98AQsFDYNa9Oy1h+1ZLH4KTFGzWrC56sQvquJ6sQiG4CAHWiCXEdPjvoM9L62YEhuCieRgRxJieLdOcs5dvwhN/YZ/tcfW29wyqS+29Gk+Dl2Uu7NM+4JyoDsEupvRTfTP3q2RZnR9SZxkaf+TgsUuaCkmf2Iuo/SdkCmcALbDA81ytKCyk97YxY8Ce8LNiSFCNZhlsnr0AY3TBhovgzjyH5DqTnRZlLHexRh9d7POAzQ6lFlBTpHWwyjMSQoZyQkR1ff4z/PTuLJOCLjnosj2jrUjX1geXg3OHg5rKOToh6XMcgYdW7F8+oEplQoby/QFFS3QK+pr5l8up7psn3R+4LgcYH6BMTxmWzmmkh7UmBLtyk66E9WLxB+ZhlwGkqI38kxC5Eci/+/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RADIX_TREE() uses the static XArray initializer. Enforce static storage
for this declaration wrapper, consistently with DEFINE_XARRAY_FLAGS()
and DEFINE_IDR(). Leave RADIX_TREE_INIT() unchanged for embedded objects.

Normal radix-tree operations use external synchronization rather than the
embedded XArray lock, so this is declaration-contract enforcement rather
than a fix for a lockdep failure in normal radix-tree operations.

Convert the thirteen automatic roots in the userspace tests and benchmark
to plain declarations followed by INIT_RADIX_TREE(), preserving their
allocation flags.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/radix-tree.h             |  4 +++-
 tools/testing/radix-tree/benchmark.c   |  4 +++-
 tools/testing/radix-tree/main.c        | 16 +++++++++++----
 tools/testing/radix-tree/regression3.c |  4 +++-
 tools/testing/radix-tree/tag_check.c   | 28 +++++++++++++++++++-------
 5 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 057edc4cbb6e..dc3795f4cb1f 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_RADIX_TREE_H
 #define _LINUX_RADIX_TREE_H
 
+#include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/gfp_types.h>
 #include <linux/list.h>
@@ -79,7 +80,8 @@ static inline bool radix_tree_is_internal_node(void *ptr)
 #define RADIX_TREE_INIT(name, mask)	XARRAY_INIT(name, mask)
 
 #define RADIX_TREE(name, mask) \
-	struct radix_tree_root name = RADIX_TREE_INIT(name, mask)
+	struct radix_tree_root name = RADIX_TREE_INIT(name, mask);	\
+	ASSERT_STATIC_STORAGE(name)
 
 #define INIT_RADIX_TREE(root, mask) xa_init_flags(root, mask)
 
diff --git a/tools/testing/radix-tree/benchmark.c b/tools/testing/radix-tree/benchmark.c
index 523c79f22ed3..57ab92e6cd77 100644
--- a/tools/testing/radix-tree/benchmark.c
+++ b/tools/testing/radix-tree/benchmark.c
@@ -114,9 +114,11 @@ static void benchmark_delete(struct radix_tree_root *root,
 
 static void benchmark_size(unsigned long size, unsigned long step)
 {
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
 	long long normal, tagged;
 
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
+
 	benchmark_insert(&tree, size, step);
 	benchmark_tagging(&tree, size, step);
 
diff --git a/tools/testing/radix-tree/main.c b/tools/testing/radix-tree/main.c
index f2cbc8e5b97c..6f0f8eaa044d 100644
--- a/tools/testing/radix-tree/main.c
+++ b/tools/testing/radix-tree/main.c
@@ -15,7 +15,9 @@
 void __gang_check(unsigned long middle, long down, long up, int chunk, int hop)
 {
 	long idx;
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
+
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
 
 	middle = 1 << 30;
 
@@ -78,7 +80,9 @@ void big_gang_check(bool long_run)
 
 void add_and_check(void)
 {
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
+
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
 
 	item_insert(&tree, 44);
 	item_check_present(&tree, 44);
@@ -89,7 +93,9 @@ void add_and_check(void)
 void dynamic_height_check(void)
 {
 	int i;
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
+
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
 	tree_verify_min_height(&tree, 0);
 
 	item_insert(&tree, 42);
@@ -155,11 +161,13 @@ void check_copied_tags(struct radix_tree_root *tree, unsigned long start, unsign
 
 void copy_tag_check(void)
 {
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
 	unsigned long idx[ITEMS];
 	unsigned long start, end, count = 0, tagged, cur, tmp;
 	int i;
 
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
+
 //	printf("generating radix tree indices...\n");
 	start = rand();
 	end = rand();
diff --git a/tools/testing/radix-tree/regression3.c b/tools/testing/radix-tree/regression3.c
index 9f9a3b280f56..dc235bff0063 100644
--- a/tools/testing/radix-tree/regression3.c
+++ b/tools/testing/radix-tree/regression3.c
@@ -28,13 +28,15 @@
 
 void regression3_test(void)
 {
-	RADIX_TREE(root, GFP_KERNEL);
+	struct radix_tree_root root;
 	void *ptr0 = (void *)4ul;
 	void *ptr = (void *)8ul;
 	struct radix_tree_iter iter;
 	void **slot;
 	bool first;
 
+	INIT_RADIX_TREE(&root, GFP_KERNEL);
+
 	printv(1, "running regression test 3 (should take milliseconds)\n");
 
 	radix_tree_insert(&root, 0, ptr0);
diff --git a/tools/testing/radix-tree/tag_check.c b/tools/testing/radix-tree/tag_check.c
index f898957b1a19..51c0f0d6152c 100644
--- a/tools/testing/radix-tree/tag_check.c
+++ b/tools/testing/radix-tree/tag_check.c
@@ -42,7 +42,9 @@ __simple_checks(struct radix_tree_root *tree, unsigned long index, int tag)
 void simple_checks(void)
 {
 	unsigned long index;
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
+
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
 
 	for (index = 0; index < 10000; index++) {
 		__simple_checks(&tree, index, 0);
@@ -61,7 +63,9 @@ void simple_checks(void)
  */
 static void extend_checks(void)
 {
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
+
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
 
 	item_insert(&tree, 43);
 	assert(item_tag_get(&tree, 43, 0) == 0);
@@ -90,7 +94,9 @@ static void contract_checks(void)
 {
 	struct item *item;
 	int tmp;
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
+
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
 
 	tmp = 1<<RADIX_TREE_MAP_SHIFT;
 	item_insert(&tree, tmp);
@@ -271,9 +277,11 @@ static void do_thrash(struct radix_tree_root *tree, char *thrash_state, int tag)
 
 static void thrash_tags(void)
 {
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
 	char *thrash_state;
 
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
+
 	thrash_state = malloc(THRASH_SIZE);
 	memset(thrash_state, 0, THRASH_SIZE);
 
@@ -286,7 +294,9 @@ static void thrash_tags(void)
 
 static void leak_check(void)
 {
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
+
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
 
 	item_insert(&tree, 1000000);
 	item_delete(&tree, 1000000);
@@ -295,7 +305,9 @@ static void leak_check(void)
 
 static void __leak_check(void)
 {
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
+
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
 
 	printv(2, "%d: nr_allocated=%d\n", __LINE__, nr_allocated);
 	item_insert(&tree, 1000000);
@@ -309,10 +321,12 @@ static void __leak_check(void)
 static void single_check(void)
 {
 	struct item *items[BATCH];
-	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_root tree;
 	int ret;
 	unsigned long first = 0;
 
+	INIT_RADIX_TREE(&tree, GFP_KERNEL);
+
 	item_insert(&tree, 0);
 	item_tag_set(&tree, 0, 0);
 	ret = radix_tree_gang_lookup_tag(&tree, (void **)items, 0, BATCH, 0);
-- 
2.53.0


