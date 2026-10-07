Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F80CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 18:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21DB6B0088; Wed,  7 Oct 2026 14:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3436B008C; Wed,  7 Oct 2026 14:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950486B0092; Wed,  7 Oct 2026 14:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B97F6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:41:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C2FA80205
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:41:26 +0000 (UTC)
X-FDA: 85296698172.15.AFCD508
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013063.outbound.protection.outlook.com [40.93.196.63])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3965F40003
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:41:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="SVBa/4n8";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.196.63 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791398483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xe6ID+bZlqtBW1bVP0ExkDex/hp98McNVbJmbTXNkAk=;
	b=1bGEb9Chxz50Bl46je4dhv+rxlnTtHgrOA43YlJ9ah0RujiHG/ibYiFwF63Hotffq3F7/P
	HLwJGsTix6b/j3DV7yWvN3DXAevlp6Z1xiiwpUqbeFJ2Sp8JalAAoTZuSxrMh0K7n51/nc
	kOTpf8PESeNWbBMqEW3Z394Tr7APm8k=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="SVBa/4n8";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.196.63 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791398483;
	b=QgczcgCaPVN7cGAkDxKFy08v71L/jtd7NPIJ+jug6LEd1tlWw0dcC3DPlU2/SEcqNSkJ7T
	EprgBVXrOOFIa/0VyJA3dePCBH7G6PUe7TID4b9EMt8J5RaTTZgT/ZMjJ7lJ+ys7yWk5+M
	wNyNFdJ6pBQVkysKewOgxhWOrrfuLTc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8+hAvJ3RrpxXByjBphDC6MJP0TG1K2MsURoBdpHoIElWfW2VWaOZ1lzHJS60EWNnSEaceUMTk1153kni9G3G9MVV0vCruNYoJ+cGu0PGF9piv4z8b+s5p/zB+15S8QaQuLECE/5Wjx9I4lIHknWwuOKTvrzFtA3R3cTdOraLvQQ6+QoY5qn4sYJZhqAIBEBDRsps8joFeES0e9tZJiTd5jI84SVsER5/wyEZ/JidCYa4o9VPxAaOVeQOA902sx7gFeQPVeaQ6xfkPcNLRBmWHVoQJWrIJYwWaqe4R8H9ePjHPwVFeVNN3YT557cEfLpg95Ua7UufG6SPj2y8XhvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xe6ID+bZlqtBW1bVP0ExkDex/hp98McNVbJmbTXNkAk=;
 b=xUiyHnWQLdapZv8n4CeYnv4Cf8ZUMFSdIZLFsinakZ3VDnXpvnWUPiplqDr6fu7EOvnZqF+RcOhRqEMcWYeSUpnIOPdCyFRIgfuL8z0OZsfcCbBGYGbM7pBGuU3AA5/h9URFRy/rbyAoZLMp2DSdeoSCHbxclsJTE4qomDJ7iEnrlMESxoZhXKcbLSiCQYzpw8GfWtQnKXZoNb177qtvTaMmkVCozQvBGrKLGT+4ZuuJoLS6HdFtNfk/TvpcnaRce1dsLLTeb90DwZj9767L7VnOpF/45+f3w7b48GeGZ/4Udq39WL8vyPq5vqBKYZ06590KTVwi1IVPz0SLPxVIqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xe6ID+bZlqtBW1bVP0ExkDex/hp98McNVbJmbTXNkAk=;
 b=SVBa/4n88zXNZAVvXL+g7p1rACV0EdtLcxv/IEn1U8vEzh6wtfG+U+nbf7vRED+/4hlYn2R6ihYUEaKBlhExFmSbizpCbhqgZfFM3q/6DEIFESV6RK7DBamzkveksI1TEIFbl6a13vwR/5IFmm5+1Ist8g6saO5//TVsSG58x/6zY9iK8rMpOWsMWoIyGH0RUHfR8D/iDvsT2ZMz43k5EyAXqQtJc84Fo/0CvliQUbHh1CbkUFDmnLVmGnA2IVxtYyTdzWoT1iyHYGgBvOMO1M2lc7N/ZwlzUHci/8hNfwJT3LPymJ5ok7/87EMxPa0Fm7kDHyDhk8fbY0nMafkQ8A==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Wed, 7 Oct
 2026 18:41:08 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%6]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 18:41:08 +0000
Date: Wed, 7 Oct 2026 14:41:05 -0400
From: Joel Fernandes <joelagnelf@nvidia.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	rcu@vger.kernel.org, virtualization@lists.linux.dev,
	linux-rt-devel@lists.linux.dev, llvm@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 16/17] rcu: assert static storage for RCU sync and SRCU
 definitions
Message-ID: <20261007184105.GA3837481@joelbox>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
 <20260915031334.1194975-11-ynorov@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915031334.1194975-11-ynorov@nvidia.com>
X-ClientProxiedBy: CH5P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::7) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|LV2PR12MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: 96cebd4b-8beb-4a8b-00e0-08df24a28d52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	km/sLw1aRgIpDArK63X/Bu3rzTmuiUAT9JcYZYorRUMltzs0DP7M2znXLWuGcYZoUfdWihNnexMkpEyRBHLn14+ag2dgD++ciX+l9r5M4m94zuHWYIcGW1lsnvdgQCWou5l2sL8H88IIgrW/S3+qsH6WUn3kwJpZFb2t9IHDFEembXEr7/Ox2oUB7fXtQrN2KM/ComWTUY2aLztxnV4fD6emI9w9T8ohLh1N81p8qFON2z2aaO3QP1o56rHpuqp83/TapvJZsT5oRP8p1hJlojZAzUas5UglWWilqd6A/IBKj8FHlhkpdAqXmTpcEt16RP051rYgotGgDjqwcMppTzuAGJCa2ALFYKGb/H+lCe9FSgLM1zuLpSURiuHRrpgJVZ1/lMfnxJHsxYarFefa7Kx7vr0LbiwfhQAuZ6Or6PIADFDybz6kbddVeJbDe6TUwcj9vBKt2zMfKDBwOnMlhIMUQlR5SFrwJcr3+Z5pEOccF7UTHgzPlLW4LvmEnikXCXW0o5XrsgMWQ/BNXl6J9TbIOkhXRPPhOJEfcxzft/j8Dy/Q2C0XGOVwlb+52OYEZ23nESAxp1JcyqAgNmVSrU9gTEbt9qET62KY0WU57nbDPKU5wNsNbpM7I0sXl87Hu/sZp4CcjZAX04v6wYNpLjT6c1H5LUCxpb4d3/tgfxk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YcCgtGKX3hsMgXPwzuXd50nZtBAtfsn4io+NOrdMttYGOP/YSEzk26zhQxtI?=
 =?us-ascii?Q?UGL7f2/OIAxYtuQmNANdNqItdQy7ll7GMu5JcAuPlMFWNkNh8EaCYMTH6o0s?=
 =?us-ascii?Q?iNBFupJldbhEK7bJLP8fH56qlAgyEGkIe6T6PDgYrP73obejiDWCb81gtVWs?=
 =?us-ascii?Q?0e8WrVLg344KvQZZntYCsf26Xbk8RJdK2SXr92l0R+TwCIPAsmlQ1wQAph8t?=
 =?us-ascii?Q?vux0Bd8tYCkZoxNJggf6ZDUMYXVKlRpLuLaOpXfyIC+uY5k/KJwpw8YVmCJl?=
 =?us-ascii?Q?L0gWlSSc/tYWkvcikEiHCsr0pbuNNRLBYkvCbY9r2udIweMDLAxRDjpPh6B1?=
 =?us-ascii?Q?t20VWXwHt5pmNSlmSmtvQDg53odUXHwHjLv2zD3bSQv44YEcNIxuGlkrTCk8?=
 =?us-ascii?Q?qXrLhejHLKltMgjy2M8BJXQVgIsbMGf0LmmKJNHbC2ZZGVpFG8kFEhqIKTt5?=
 =?us-ascii?Q?oXzEvK/D1xbwuNZ1u5sD8mTayzbD4bDmZCAS0LMh8ExmVylQ+ze8lIoOGPK2?=
 =?us-ascii?Q?BUBSQFrVxL3LeGrgiXq55AZk+dNmGU0/XHRCRo429/igxhYKgOaFWxq7Keke?=
 =?us-ascii?Q?CQF0CXJvjKC2n3PF7yeGWUbXpAB2o+2zN/IhNA55APKvv7Bm2ceXyKLj0sz0?=
 =?us-ascii?Q?IsvLWnbkNUWvWSv8hvGu0dKwshReemcnzqRBsOx7vgwrRq+R+n+8ZsXn7lDr?=
 =?us-ascii?Q?6oHRqUk4NRsRIWsfcvt3RNIqepaOS2nHLUmZs3XqF+C4g8jLDQcdgHwZiTV/?=
 =?us-ascii?Q?gdP1tDSsD2hd63+Tf4n1H5seUFc13CodpKk0G+9SCSIYN4pMyIftizRVeFst?=
 =?us-ascii?Q?A7Ks8+siDYrSpjd5n/G+w7mlCoM0GSEWALIhCOfLMlIUhW260Q7QiBnr/0Wc?=
 =?us-ascii?Q?fMXiJnMR5T2AvHltGUBrs6dO8l+T2Dx5i+Vp/dUQFN/POdbXNkYHFBrw7L8Z?=
 =?us-ascii?Q?yrIRSykXQlILIGaMaWUD0HmX/0r3wci1miPSh86Pw8h/faw1PqzzA5U2tIZ8?=
 =?us-ascii?Q?y0oG+1g4GJWUvnGXdUguGErOESM8d5i5hNatUqoBtdK22FRkI3SpPF49Pq5Y?=
 =?us-ascii?Q?xouKUrWvECB+VJJc31evHWX5nUNi9g7wHBlSyP1EnHFldVq3p+KY9P6jXtd0?=
 =?us-ascii?Q?7hfjBJktgr94lJxLXCgmqoJTX2DJQHEa7Ihp8ZT1/lWGbwFAKe6joW1md3zV?=
 =?us-ascii?Q?75VDDocVNnfBKWFTaBgyMiIhLizloMDSkMftNA1OfQtRsC+ebAWDaWM3Z+rg?=
 =?us-ascii?Q?HS8pZ3gC1OQBF8kJeonQAFLaAZpHBy/L2YwwQ+0Wgdft1ig0w5HH9IFqgGMI?=
 =?us-ascii?Q?9XwRcRYNpkxCnw5kfmuCtoe94q7EX9fGbl423O2cNXlLnfQ0drCG+HYUqpvt?=
 =?us-ascii?Q?fEFAonoyKWBkeOY6+UQobp6TuZrXtTOhz61T4ozwXdDFsZ+Dapms0bCiTgdU?=
 =?us-ascii?Q?IaHXsnLZ9cUH79mZCmx2nSYv5jobUxNZricJ2qm40DtBrR8m+rBc8aEn5n7E?=
 =?us-ascii?Q?a66I2bnN2z/3OeHRK3SF7hYpT2hQ3cCZDxjQW+xdNalSmdzDtNIPFUMQUPK3?=
 =?us-ascii?Q?BankZ5rLjm/GQiOZI/c08TBOMod9dyPc0wohr8Djx+7zfD6juIGQgjmpMh7i?=
 =?us-ascii?Q?QiS4iC6Koc7lS0is78rJqXFqlg/GMyJG2WbPVE4rP4Untyt5clgEHd57G4rt?=
 =?us-ascii?Q?Ez2QOTRTvOggMG+roa7IDKCwmKPea1yhZ4lJLzPc9+hGsf0YVvS4XbaiKrqx?=
 =?us-ascii?Q?1JO/n33mLA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96cebd4b-8beb-4a8b-00e0-08df24a28d52
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 18:41:08.5901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6u3PpNCAMpFmgRSZKmtKhUKhU9qHkNWzQpVL7OQAFGH4FPWaMsshXEwO1OdMFntXpJfvwNF0NxnIXg22bOa1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5869
X-Stat-Signature: uiuxns5jmwynb4hkied3uwrqb8q7zp8d
X-Rspam-User: 
X-Rspamd-Queue-Id: 3965F40003
X-Rspamd-Server: rspam08
X-HE-Tag: 1791398483-806380
X-HE-Meta: U2FsdGVkX1/ozFIhRHw54SK26AIxNdO+6tj0YpI27qrNzPTuKYmSfDfcqPjSCfk+rGV+REL/bQQWjGMfnes96UqsawQ3dRrBmCCpkbh77ANgcHT1SdbpKUKOwZrJlc8kZW9R7nrFefBhVge8KrGm9Y7Ofpsf39V3YdSvsvJR0oYx9cHaML9Y9nBlzlT+8EiZpim2lqrVSDRleght48brSD4BQSzilg+nodvxio4Wlu2/YlbCQMrsLaxYSl2GVc6fyxto3yZtK0ApL8lhEKhdpGonVLcR4UK7SXxMWAlZFZ+7GEPXPWc3Pm6idMp8orvGYSUDXXcQ3aUQnzJHY/eWyO1w1lWi4AIqa+AaWnQNtaxjQlpopiEXI6ymQZ+fMFVI98GcnwOQdiJWft8HxBjJsCw6g3ffS62ohmU8GraoqcxbZC9typZrBKoUcO8cxRNuS+GetCj6HxjcLA84m+iPnZh4OZwl+A0Xk077QIn+PYCY3hzg9+uf4QMNQxqU+RQXrEhs8awkwht9ySwvyeCmbO3jhxB1XBj8dUlNWDkNrbOjp/iRp0sP6R5TeNwa73cOSNNrB5JdKcIPMRgtuFCBu9Ugv33OPVLBot+KrJbHGRqnjKLnnr8dbHEFzcmeha24izN45u6Ci9KOko/yE9X0vlZEHjM9ITFmfUCaLdqNVITU8FS+Ci0KSq7BZhZQJqpLb4gVanFUTt23sVVhDNIW28FiA70pKslGlNcq1DC8tQgHBTV9IsmYnXtwbfa+BwOlCS+MWj4OYan+uXzTbShBCWXi4A0uov3DD9OM9lsL/f6tEJOLOhZw+tMrf/3NzruBcngwR/vivW8JqTKB9JXsVG6lkp22wtq8k0ylpouMBWVGzLvXOyTnefurv3oKNuc1n7X2UEa/kt0vUQBAwbd3qBVQUvv2UAzaxh0KMpBAXfUcwD6dgCr4w2H01WGZkwT1E3bZSMJEYsAF7Lgz0gA
 LKGkR0cy
 ylcOmR2nHsHmRjp57TGH0ex8TrALlSJg4UwfG7+8EW80u5qLfhAP1JiKHCivUx50sjtRZUUPZgvCUe03Fc1vgo+gDQlXtkvzBEcJYwJwE9c9SL7OTLl33Kiq7oySs4feOYPRZKsWPBNs9Hm7UFnqncZmpkbvn8GkdEG6IPNF7abOeUYsGfNOkIlCmduVvlj9vtSkC2hJemiOePbIitPxuHqNYq+fQR2Dc33mL/vVhWe1MsDFT9q1+T9FvPFFu7riyWOnoCckLsdRqWhEwbkL25E5z3bSwxD+geDr2jVloWc2Bp0+qmrzhfGouL2d4tNRAIYB7GLgrf7VLCx7m71Aca/BTpjIRV9jlYenjCx4jcMW2SHGKv/OqTHVD77depIXXqJdIx777lcgOxTZhmXn3zj45TJrbEeiYm/oS5qF7XyZq4RbePTN+a00LaWO8TmKB/uF7PksK0tlO36CHGfTwByOKA4cpmRPivCsdPPz9PY0LJQtaNoZJRUqa0lXOjd4PauCw/Da0vYcRfBaw4CfU66CWpOovl85hVBD9czgGdcaLkHMYBhpOLFmc6biH+AqF6KrD62cYilji5mY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:13:31PM -0400, Yury Norov wrote:
> DEFINE_RCU_SYNC() contains a statically initialized wait queue. SRCU
> static definitions similarly rely on persistent lockdep keys and, in
> Tiny SRCU, a statically initialized work item.
> 
> Add ASSERT_STATIC_STORAGE() to DEFINE_RCU_SYNC(), both Tree SRCU
> __DEFINE_SRCU() variants and Tiny SRCU's common DEFINE_SRCU() declaration.
> This covers the non-static FAST and FAST_UPDOWN wrappers too. Tiny SRCU's
> explicitly static declarations already enforce the required duration.
> The existing per-CPU restrictions on Tree SRCU declarations still apply.
> 
> Assisted-by: OpenAI Codex
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

All the changes make sense to me. I'm ok with carrying this for -rcu 7.5
unless you want to take it.

Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>

thanks,

Joel Fernandes


> ---
>  include/linux/rcu_sync.h | 4 +++-
>  include/linux/srcutiny.h | 4 +++-
>  include/linux/srcutree.h | 7 +++++--
>  3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> index 3860dbb9107a..c10b6d30561a 100644
> --- a/include/linux/rcu_sync.h
> +++ b/include/linux/rcu_sync.h
> @@ -10,6 +10,7 @@
>  #ifndef _LINUX_RCU_SYNC_H_
>  #define _LINUX_RCU_SYNC_H_
>  
> +#include <linux/compiler.h>
>  #include <linux/wait.h>
>  #include <linux/rcupdate.h>
>  
> @@ -48,6 +49,7 @@ extern void rcu_sync_dtor(struct rcu_sync *);
>  	}
>  
>  #define	DEFINE_RCU_SYNC(name)	\
> -	struct rcu_sync name = __RCU_SYNC_INITIALIZER(name)
> +	struct rcu_sync name = __RCU_SYNC_INITIALIZER(name);	\
> +	ASSERT_STATIC_STORAGE(name)
>  
>  #endif /* _LINUX_RCU_SYNC_H_ */
> diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
> index fbcf13bc12d1..40b592b4e2d8 100644
> --- a/include/linux/srcutiny.h
> +++ b/include/linux/srcutiny.h
> @@ -11,6 +11,7 @@
>  #ifndef _LINUX_SRCU_TINY_H
>  #define _LINUX_SRCU_TINY_H
>  
> +#include <linux/compiler.h>
>  #include <linux/irq_work_types.h>
>  #include <linux/swait.h>
>  
> @@ -48,7 +49,8 @@ void srcu_tiny_irq_work(struct irq_work *irq_work);
>   * Tree SRCU, which needs some per-CPU data.
>   */
>  #define DEFINE_SRCU(name) \
> -	struct srcu_struct name = __SRCU_STRUCT_INIT(name, name, name, name)
> +	struct srcu_struct name = __SRCU_STRUCT_INIT(name, name, name, name);	\
> +	ASSERT_STATIC_STORAGE(name)
>  #define DEFINE_STATIC_SRCU(name) \
>  	static struct srcu_struct name = __SRCU_STRUCT_INIT(name, name, name, name)
>  #define DEFINE_SRCU_FAST(name) DEFINE_SRCU(name)
> diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
> index 75e54e4f963f..8bea8044230a 100644
> --- a/include/linux/srcutree.h
> +++ b/include/linux/srcutree.h
> @@ -11,6 +11,7 @@
>  #ifndef _LINUX_SRCU_TREE_H
>  #define _LINUX_SRCU_TREE_H
>  
> +#include <linux/compiler.h>
>  #include <linux/rcu_node_tree.h>
>  #include <linux/completion.h>
>  
> @@ -217,13 +218,15 @@ struct srcu_struct {
>  								      fast);			\
>  	extern struct srcu_struct * const __srcu_struct_##name;					\
>  	struct srcu_struct * const __srcu_struct_##name						\
> -		__section("___srcu_struct_ptrs") = &name
> +		__section("___srcu_struct_ptrs") = &name;					\
> +	ASSERT_STATIC_STORAGE(name)
>  #else
>  # define __DEFINE_SRCU(name, fast, is_static)							\
>  	static DEFINE_PER_CPU(struct srcu_data, name##_srcu_data);				\
>  	static struct srcu_usage name##_srcu_usage = __SRCU_USAGE_INIT(name##_srcu_usage);	\
>  	is_static struct srcu_struct name =							\
> -		__SRCU_STRUCT_INIT(name, name##_srcu_usage, name##_srcu_data, fast)
> +		__SRCU_STRUCT_INIT(name, name##_srcu_usage, name##_srcu_data, fast);		\
> +	ASSERT_STATIC_STORAGE(name)
>  #endif
>  #define DEFINE_SRCU(name)		__DEFINE_SRCU(name, 0, /* not static */)
>  #define DEFINE_STATIC_SRCU(name)	__DEFINE_SRCU(name, 0, static)
> -- 
> 2.53.0
> 

