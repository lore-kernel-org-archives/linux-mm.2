Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 506CEC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4AEA6B00A9; Mon, 14 Sep 2026 23:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24FD6B00AA; Mon, 14 Sep 2026 23:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB636B00AB; Mon, 14 Sep 2026 23:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2B06B00A9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:14:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED53A140303
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:12 +0000 (UTC)
X-FDA: 85214527944.06.4D6849A
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010045.outbound.protection.outlook.com [52.101.193.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0A9BD120008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Iokhuv8X;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.45 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Iokhuv8X;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.45 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442050;
	b=GkewgVr6zFd8HQ85MvzxmrtO8k/K8lLUMHcoTeTLIBRpxqG7a3R3bxLFIG+BSOKMhsXY1r
	9AKxDWt7mmGDAX224pAjTSsczUPQ/tP7WyH4iQPbICnh5jXvOgVWf+TJMG5gFzQKpOqpBa
	LKXKuCDLhQ/5nQKIpFw7bhQOXcsBHd0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0QoCgXQzA24OmfkDLp8aNFtpGYLCxlnSXowFOOJK3E=;
	b=6Iw9MECI03KZPfKxNT4vjTXe/Uw0MzTTi7Dp+5JplZrvg98ayQRX4FoRxCHCBkJ994k2Xr
	U5XtnRioeAiabKppMsjbojPGCBX3JvXa8k1+PGWRpjTqTpzI0pZV0V5QXeRQfQMIIOeMtD
	sjRtJLyZvZYzrykdOLTw0ph7Bronl5I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U/1ERiTamalyRNRtBRawVFzWVIig0yQPuukX4Ry41IR6ElWx0+xu/yHu+QQtCEqYESJiDuLID+HUKoeIyxbkOW8QhSAoH7mJ67qnJLb2OYUYKmC6jC22lr1eH+TVDDdWFzt1Bpv+3OJ1d62SFXWIb74ZoQfkNYY6InClu1goNMTsaWLRVzp0byZ0DsBatL2pGUEfnSIvj0YVplNl2uy8yyk0LyddDAhUcVna1SRMxKXFl0G9tIVm1ffJv5txfcb6L6Qv8LHzphUsDNykuaA/fqCncRa7o55uyJSxA94wq/vBn9w8HNZXIbR2pvaINRbyKcUNoHqCp0LGY2Rk/kVZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0QoCgXQzA24OmfkDLp8aNFtpGYLCxlnSXowFOOJK3E=;
 b=igYovuW8I7Q12RpU+jt/luTaOceJQxD4q4k42h5S7inVecff/tBg/DlHTFFTC7nwtd61AuTgV+Jh1UbELjntCbs4oxYyLN48+0WfaBH5gBwwVo3B9qlghlOMzRsAFOmEKpFe2lnEGxILLfGoVv7wix/REybxT3eO5PhlKF25X96Ts54FHPSyr8LHFmB6+mr83WFJ9iBpR0ILgwFw2+4tBy7sYWdBeO19LKludgW0oEf0lH5pYJb3n0GALj9EyUmaiuoo029yp+3ifHoOBE6CKW35wIIj5JJZCw98gWFQe4shs8h/dFWJtE2rD6FrY1ijLO33rQcJfD1BaOmV8EGSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0QoCgXQzA24OmfkDLp8aNFtpGYLCxlnSXowFOOJK3E=;
 b=Iokhuv8Xr6v4WTCnN1Zwqo7FmwUuDu/OZud7ki5saDv4MS3ZOxNvJNilFmx/3RRb0GADS1lyFEWZZoFQkFU/nMvSVEQvRripsIlosORVKiZjj2MCx1/2bpjN/5TVaeSjyZ8xfkGHz9BD29U28vbDU/XugaB5LEz5iLePQ4oA67xMcplzHYqYRZJoC2dEVPPY77z8syLRW6tCp49YJ/WV2/noFZoOH948mKCg2uOFfgOkfpfBvAOgP5Yx4ViZbPrIM/In/I8nqOqYqBNUf0S3bpGmdQcjCd7cZKAirchoD7j6D1uSiai0GWOb7B1uHcapjJxeNYMzn29zfF4oNYa0Bw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:14:05 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:14:05 +0000
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
Subject: [PATCH 12/17] timers: assert static storage for DEFINE_TIMER()
Date: Mon, 14 Sep 2026 23:13:27 -0400
Message-ID: <20260915031334.1194975-7-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:408:ea::28) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: d019f979-0599-4483-494b-08df12d76616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	PduY5E7IbZ2GGSPCDFg3OoTmj9xsnV+ZUdMnI4bxyK/HV/vJQvlzf+x553ux9RWeylbcG9dOagd8/E8IYDUHZ4QkEKgPHx2/V5CaFYXx1VXgcO/pG2syhfjHc0Ov8XZl+jeZEPy6gvpYcZxVHvWdLIu8k7I7Lllcofkg3p3IvhVdjgj+CIAlz6MidhMSrp30Bsi+vMo9HS6RjkXUCzc4exg+k/kOU1bXZsWkT8hQCIDqSxfZq+VVe7OUS0zueT03f9UYYf+M2YMg/S0NAoMJy19RNGeGWYwElsXkHiG5+icTjRZqGfbdcpa21ZASUMFrBTMMI3HcBtgopLSVHM1bI63DAm532MajssaqjEYD4V8SNNaGUaZaFUP4AdYEyax+sFPr2qveaRPxSaAUG9TLB4XS1PsAEMHZTCSZzXMtjJWy56FEnUCLmCglcfZygGRU3zrpZWjiM+VnQ+rWrxb8u+/f39od4Ec0c45v3EPupRPRjyaLc9a7U/QMDmq/UWdFc2OHDOKBNY68kgmDPxOwJ0MzGydqJrJEZENqtY10Hyc0CFCN+ZK/Vuit6/5BgGPClMbZ5XA+OYxg24fR78iY9pqSPrdA64KSfFiznYxS9bi2GTb5FNvYPBin7957jFEGgGQqBtjW3FcVfjLhohPB61MAFji4MnVxzD5i6POFHfs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4BbLavi3sxgpW0o0AGOGOzJhkocr9SbTtILGVXFP5glZkG7aq1hseTR/1Fuf?=
 =?us-ascii?Q?74vjJ5XJezmNJ0k0yzhIiA55iCc7VcRzdpygLhcfj+obtIQumc7ArEoROcmh?=
 =?us-ascii?Q?FptacBVPrbAWOSsmMohD9AUxqjtvgfvI2Nxqn5csY4ueLKgIg1B2c6dWnThN?=
 =?us-ascii?Q?6mIF8Wsf34C4rDOw0DHwpR/Sv3iKvGDBjL/Hlet6hfXSBH/7MkUgEvUJoRU+?=
 =?us-ascii?Q?s2s4Hp0RkBkqvxCqnOtDh8nbFHOcdktXOnw7gbJtmghMzMMMzRi68k0A1L9i?=
 =?us-ascii?Q?LYgz9ZUaPcVBsDKkQPvna/YIDQbSCa3z294KlrVPMaYHhOZnzHxgCBZfocs4?=
 =?us-ascii?Q?J17LeM79zItudrrMlQkgk9BqBAtCSuP/9XmYbTFM6+bvIJ/uiFaVJLd6CohK?=
 =?us-ascii?Q?U9NV7AqRAHwudcF/nyL6LFH8/wXDZcuBGtmj2u4/dJ9ig00X40hvRtKZ7LZm?=
 =?us-ascii?Q?GG7rYibgLqfGPtCf78BJ5eeed1XJyVJd5Uoy7ZUJ7aLHLvZBdhq5R6sSl45P?=
 =?us-ascii?Q?xUCCPIlWG8uIZlr/l+bkdC+lwyzxHRJVP+aCWm2R2ZivZBMaY5+k0ntMYWzP?=
 =?us-ascii?Q?B2r3G+7SHFejIUGmYitEzs6kxOcf0eRSH1XKH8fUM1Jcafe/BZCthjFNf3Jh?=
 =?us-ascii?Q?C0pTVAs6YLJqVJjgYnHqHRea0MIg16p5Zt74L4nFesrD837u8MPE+P1g0X9L?=
 =?us-ascii?Q?MlO6kQ3g1ynU+JgNM8qVXOxtgmzbkLir+dI0SAAekeZE/TD+M0/nnA8LdPAD?=
 =?us-ascii?Q?rF4lv2Yht7KWQUM4oWHQ650HzUPR/S95mkXCBCShbPLuwyyc1lTLrnB/0Cr5?=
 =?us-ascii?Q?RzY4z0OQuWaq99m0Tq2rxcnvGS+rsDDXRsAn0aeM+KZCboJcYYh6fA3loTyI?=
 =?us-ascii?Q?YJwOJDyAf45fWsaQWh8vnA1cp2Lr84gohhvlONW6rGRn3Lw5UpyYUf/V6PBw?=
 =?us-ascii?Q?Fe45aa7J9agVTOSaJm7fZv1UZ3PS00nOZby0ztSSy7Jl8+yPBuvPfGOgs+Wx?=
 =?us-ascii?Q?XP3BXBgR1BrxIkC85t2AW6pH2j4BH2tPuomZkGa7RDxoLOiFgHSQFGRVTYsb?=
 =?us-ascii?Q?xw3L/Z8w08CBMyJfNtvjnFixN3gYXljPU00lpnvd759muQLtptcW60Vz03ns?=
 =?us-ascii?Q?/86CZIdG9r7wGFKOa8Dwn1y8F238BbRe/xAq9iCjFKvIIdK9nnjrWcYiXcGl?=
 =?us-ascii?Q?VRu0kFrXKIgcPQ6tgMIi7TqcoHDaJetzEDm03VeYK+2plpRAuAUFDDJYOtaH?=
 =?us-ascii?Q?5NI9/LsOj27okmcusru9qsuxMHmENQQlNQfU4o+oG7xh+xUkzgsuPVdFzS1r?=
 =?us-ascii?Q?p+MavAjyconF8GcquY2FH48Xu7pYxOFLN1Cce+cj1d8Wg12a5FPKKzPaQgI9?=
 =?us-ascii?Q?NeKeN4Z1f/zLWLl207jxO9dEKCyiUkcNRkGac+Jn34dzhVgoXkay9d7zs7Q3?=
 =?us-ascii?Q?VQRCc8pEpKcTcaxvbutKO1Ptk+QoV/Xl/lcytXT+9jJQhS7o4LuNwM450akt?=
 =?us-ascii?Q?XzeM2/9CHcoLBu3HadWmvEWTCrOOzg5tI0OznGrhFLaHP719X8Mq8Cx5AaX4?=
 =?us-ascii?Q?uYpgidZnOok/9hwItbNKn8b+sJeeWJ7ejrzUW4+ViI8F4f3DGoViVpLTFWr6?=
 =?us-ascii?Q?Hoj3cVPeNmNldd8fPJgmKKa/VISvAnPiJttYQBkWQyO0nBEABAfdsr6E4dDP?=
 =?us-ascii?Q?R83wq7ah7wMUnxRLU01T6acZkgdg4VUNpyj0oaWv4uSBGPuRc3fLbO/LuWP6?=
 =?us-ascii?Q?x8Ss7Qo+lA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d019f979-0599-4483-494b-08df12d76616
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:14:05.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwBwzfGrRsuffy76VyyABxDuTkMYkZOTZLoXDD7zMTXbO6RlM8Epp42YJvEtijl9TApXBRUupKDTxc9ka+YXMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A9BD120008
X-Stat-Signature: f8ed9tnbwa6h8o591igakyo5jdspj37t
X-Rspamd-Server: rspam01
X-HE-Tag: 1789442049-654589
X-HE-Meta: U2FsdGVkX199dDU24iplBChQrIApPQ5ItJieIiLnfT3DiqnnPAjtPEkUF46yud6eHAtLzQEK8+9qjAttpfm6sLufesotnlOM/KDvq/F/ZISGVGkgx2nIuiRKHy3VH7MYvoxc9sK6HXaoBOBEtBVqnOBh/eRRfvh1f1s/KmLkcaH4w/CKmiUF8s1f2JlDjhptHKQrR4h1DJhCrGrSpfl5ZtRb1+wUGYSX4nhJqDwHrICEeexm+mwTHXFAz2SXuP7B37U/1LQuaLnc0Y5ZPOG2ccdZZHo9ennLQX3iJ1zw/WgdU28KvwYFKHOD1Oy5VaFiEg4w7/vpmjyLwGbWm0p6DYMJCjY/HDCRx88NJPsxHxk2rSMvLfA7dbpVF32aBZZoz1dU/nLCc9ckgGirbwQIpuh1YfjxU+t4Q5NKC2xdEfJe+Z958Jwmd2O3FuntC/Ku9Vf4rB21+92XE1f/F1sN1kuH4RVAqsvmMZLN4Jk031BfGxBRtyJdec1qQOk3/SY1TCdzXUzNB6dxjd6NI0OTnQy52Jd33ozir13QksTz6r9wO5C3PRF7rEITGCEv2CD/VylxTQA4TNa2s1+o3lIb8muoew+n1Qzyx23w4FJmdCptmIjGz9+9dXUYnDPwRUP6O3bzv2uTMOSzlr7lsEYXlWaqiJJCv1xxHv8+Z+dHOeQG5dAsuRs9l9sTf1rN5TesKsVFrGQZszlwrVcRcxH+veTX+TRUYPqPJ+MjOsadcNR0wXttdMWq9u468E6ZEQviCOW+3RFb+3U/7blHUtjHhu7PFmJneLSkJPSZ56Dly0ss0XQkjvrZH4dwwWKAjdoAFgxF5VjtYJRgI6E7Fxu8OqO6V9ejPpuq7XHh4SisMhLWRPGXkaEzkbrx5c48AmyjpdtxYYXtfHYijOTKkp6VoUMxBaebSdc5LXuxRFvkPxDjNK2nuoErKHvYQwaKUXRwv9tBd8Vs1Hvc80fYah6
 hC6ZLF6r
 4ihrGAHV+zwYOvnYf+Rokra+LjpbaL0NAQwSoK1hyuI2Zq0t1v73lxU58lk1PAt3guXO22fgYPoh6iQFqZjtb7QV7lgCfP0B2K1iBTSEMk+BYb/3kvI+y1qQg9L9KxD1C0etw6khrqGAaGBAmii03sCj2mGfHhmNu6I2LEbCH67bY4lY1XewGxVxf6stLVA+1QZXVOjZl2Ff+7MwEo0Lh0/Xt6tKLzbArU2PMYggOFJRbAxtBQlURuK/M+MuGkP4ewp2/p85rTMhkijjxDgGJJyI/s9+WOqxrZ8lmH/HEbRy4PyGmBFB7buFPEerIxR/mL2XPRgXdD7l9xymdL+TfJaFNbaC2eGCEmMKPGVOzHHRbmrcSQz8FObQ/bNSphglKGOaH2Ilsp1fm7z3Loj+iqp/xHuGzOLiCqBQNSmshndIBaESmh5+choosZBtT1fIg/MRdvy7JLh3+cqHLRB3wenbeifjm46HygnWzp2cgvb4d1qIkDit5GY5X1lNG0YMp+3Bo9F4PzRi9AAIZH3awa9HSsSc7MqalvAIsohbTh13tk/4oAbLuvqMvVItcrOXeHzyrYiX7rEchbvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_TIMER() marks a timer as statically initialized for debugobjects.
An automatic local timer instead needs timer_setup_on_stack() and the
corresponding on-stack destruction before leaving scope.

Add ASSERT_STATIC_STORAGE() to catch automatic declarations at compile
time. The timer lockdep key is already static; this check enforces the
debugobjects storage contract. Leave __TIMER_INITIALIZER() unchanged.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/timer.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 62e1cea71125..420509329883 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_TIMER_H
 #define _LINUX_TIMER_H
 
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/ktime.h>
 #include <linux/stddef.h>
@@ -62,7 +63,8 @@
 
 #define DEFINE_TIMER(_name, _function)				\
 	struct timer_list _name =				\
-		__TIMER_INITIALIZER(_function, 0)
+		__TIMER_INITIALIZER(_function, 0);		\
+	ASSERT_STATIC_STORAGE(_name)
 
 /*
  * LOCKDEP and DEBUG timer interfaces.
-- 
2.53.0


