Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CACDC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730F36B00AF; Mon, 14 Sep 2026 23:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB0D6B00B0; Mon, 14 Sep 2026 23:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CC86B00B1; Mon, 14 Sep 2026 23:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE736B00AF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:14:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3194802EF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:30 +0000 (UTC)
X-FDA: 85214528700.10.333E298
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012063.outbound.protection.outlook.com [40.93.195.63])
	by imf14.hostedemail.com (Postfix) with ESMTP id EEB26100002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UoyOnn1k;
	spf=pass (imf14.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.195.63 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d21zpOGUrU2aWSmby/wjZqj3sY8qY/SZrAPyealnRrU=;
	b=bW6gWUwMRr/S2kjNEE2xf2OnMBHuboh37h7zjq8O1dFlHWcP/ehhdHFj1qPQBUtPeKU8kK
	I6AFqLIRXdZMckqAYYGbN/0/WA2KqJbx/Dn5/G2G2seeik+f9kRkhv2dCiOyXaAMSoJIT/
	r8i/KABgcNHSa7ROPmLVu7/+mxumdqQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UoyOnn1k;
	spf=pass (imf14.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.195.63 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442068;
	b=fdqgbjr1aijigJcPRicvXI9IFtnzC5v/Ltwb+M9c4y7418MCORB8brg3RABqOksZRp22je
	iAmuQCA1kb+L3XB1jYZQkUYgIk0j16E5sJJJHqk6WCFt8Qdh9RETmmVTZNrytvqGFBCP02
	a1Zjqj+yBD6GxWsTkNKsRSjv1XiznQA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8GBFJWzqZbh3G8ZmznVOvxhTqI54FYSa3JhoEChoY/8QOy0ifnpM9JsNlyYgX3JG5oZePWJogviPLlgkhtKDj8/xtlRh05/P7D0VSR3/LfeALx4412i30yi+G8Fjv8eizJtlbAKXafN61FqD3l+82UwYC0N0RsjFyo20uYo1df1QC9Kh7w4lIr4qvPTLsjB6ds0dml8V/H8NpMKPAjd7PTf+JQERD40xG3DytjNhxudHmlJtUiaqlUOtxz/dn7LSVfqCPEY/iRv7BfgGx5loK7YttobnjCBtU9BMLk2MQfm0EbB8OfTIUGZhHeghSDFlV6i+ztcz57RXIuHx3qdRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d21zpOGUrU2aWSmby/wjZqj3sY8qY/SZrAPyealnRrU=;
 b=ESg/3LMYRzoGxLo/Sv6+sXipQy17h49L0YUhLeM4f5gqFDc02op6x75FWZDjFHN+o8BRZ/rbcIuRXpes0GLSFjDvuoMYASFClbdFxHdKGabPbADddhxDlhDyQFmeH95CsQKzrIyQxQD4HGne4Co119aRbkDm6VEXvUFe8sv3H9e9a+Miot8fHUhDnRxakK/wUgszUNDKLELkRWD020rS/P5LywvE9quEynfALshvYTX7XbOcyzkdwuFlsJV5kcV/kRD+X6haUnY2SKzSQZxg/NPlYwEUOPSWSrC76c0gkQgvkI4KQEkWgFpAK7Jma+W4TBhuigCw/Q092lBW2hbZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d21zpOGUrU2aWSmby/wjZqj3sY8qY/SZrAPyealnRrU=;
 b=UoyOnn1k9IJbpFKOUA35Y4MEQfKmPE6hU4H05Zp8pN+srJWHbXViVl/PJ85uN3G2eyVIqvJScfzHcTTpAZXELrkzc9xb/pVn3NIySE/GINVoT9IIq4mICCaKY/TWPrr9q1q6Kh7wByoJzukOcn3OqjrL3uFdmc7tIrLu7aqDcuZgNgUJQ8cDhpDkSI2CR/HeP+ABwjVWSviRnmU5MUKSD0xKlBVCXPET4qy2SChxdoA2mISJ+dQdCDO6JnveyxMyYOEPw7i+lIo3TI+l8mNUIY9xya8kbx3X+lsJxQm1jnmOXuzXna87zPNt+pemim7+QlIRHK11N7z2GxgqSyNnFA==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:14:19 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:14:19 +0000
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
Subject: [PATCH 15/17] notifier: assert static storage for locking notifier heads
Date: Mon, 14 Sep 2026 23:13:30 -0400
Message-ID: <20260915031334.1194975-10-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0405.namprd03.prod.outlook.com
 (2603:10b6:408:111::20) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: bbdb0fa0-2b15-4b11-a194-08df12d76e8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	vsklTINGWUx98QjKYQrTuyrIrhWZQnyQ3oacWKlnguqmG8TAEZt1yA5ynEsFSuhg7DEOuewV1UmrODm6a+mDS4xYzOgP+EXTgtzg/Y7ZcQ9Y1fLJ0IYr7DwWD/tbOSWzsnxx++dBs2vx8lL5eRCbafagDVjzTmEJpObd5DhRCnETgg1N/YiIxcMSvpUUiH+qEegggAc0RcIG2McqG5dkw1AWGP8kMsNVMoyKB+XkzrP+SItFLD1mVyLDmRdOWHUlcozBu4xmy9GzWWSwrECM2VtiDVTnhkAe0brWG0phcZfFnKwIGQHH9+kQkf8TMj8HXp0klNpO8ipsq7UN/9lD7yBg4tJUNBSNxrJAr8YeKVjFQyYiAs59ukLDTVCPwZ70QN+Gp3wLE6LJ0+R1mqPvYbSp31ga6orccEAhLmh8DWzeg/+f/KPGrjXqg8ftaehuPcE/BWZ1qdkSnwh6cghfZCMMO97eTg4p2BZ1U6mz5CUNRRTorLGPvJUn/IfxFsG5H5lVjfx38G10LKmyeX0dtk+pleUKLtUgBlkC2cqMHGlPdAvRyzDlVsA3hqsq1eyW8Ur1AtecJPTzxg6umd/JJy0aolAm+S2Zq9R4MfIfpBJDNJ0lsm1mLmWuYmgb8RUNE4yTTKyizWX/0bmFxC0b7xQfvk0n0PwigH/3pp6MKlQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EMWJvL6DT/5TxfzNea1jul5h4FFFPz04JR68vEGXoicXXuOOXUL4j3OLYFIn?=
 =?us-ascii?Q?2HeDeK2wbv2F0yQQw+TJX3DMTYv8QxmAT5wBL6FBLbj/d8wSXddzDBhfIPHx?=
 =?us-ascii?Q?1CO1MPNpWm8hVF3QRyfQovSJnMgsjWQ/OzidVktatEq8WbIHLkG8+qc3Htl1?=
 =?us-ascii?Q?mAqqJ1S4Pp8sP+kvxIrAeQv5V/sDHSKSTCOtT0W3/f6YXwYQYT3gUDMFXie4?=
 =?us-ascii?Q?Cc6gxAivq/F7ZQGjmVfhbc1zLLvV30+Kb8kslqMxlyZqbfjKyMYJB0FWbVr9?=
 =?us-ascii?Q?smcJxsfXf7QA7l0LeujbiVYZYyrFX9gxqHZphPk6Q1gKQXUm+cPgdjymU2Ev?=
 =?us-ascii?Q?0bfdXQRx/pfM8M3umyDfHiBE/KCPA/EjAnplA3WL1G7rrqwE/FAACI3qA0kv?=
 =?us-ascii?Q?x0cPuebYoireGhx8AgqYRfU1Vat909F0/rHSZKE74wYYwwWjqikDQDHWrZAk?=
 =?us-ascii?Q?Xxgp0nRm4TKTbEv6iHSKaivhO4SscDJ22kMmP2jNTzZQrxUyvkbqofl+y2lB?=
 =?us-ascii?Q?U4rttt3Irh3BMJwcj8F7OoEsODLYPrmcv31jZObNhrxPaskZ4+Q61R1LgZ3d?=
 =?us-ascii?Q?c6OXnABviOsdI7fvYPcexIu2mcECJ+89A7OHazkFxA24XmrER+jc2Lq8vVNh?=
 =?us-ascii?Q?DR55UHD2RUGsljeI3n9soSWLIsXqe5kBsxwMZ0mk+nDCMf1ogOaCNU1scRma?=
 =?us-ascii?Q?dGCpDnF0q/btNewCoBLiOb1m+BRrOzb+O/u6IgKmPtIdPQRynH1hP2MQ1UWo?=
 =?us-ascii?Q?CrHP8GpKAxN2MmeNHc9kQGw7Y3zGrAHhrF+aWSJQqNnkzrlTb3Oa28dbp3W3?=
 =?us-ascii?Q?4kvAo+QTLWQ0khy9vgqCq6dPxbB7FP6EjEO7Qhc4BlpIpOvoHBj2WWKnYd4M?=
 =?us-ascii?Q?K8QWBBr+jTy8+F75DGmHivjqC7ceRXsLCVCmwMkSYvZ3qnwhZrHeSSbnVjqa?=
 =?us-ascii?Q?L72Hph7D84ZPRJE/l8TntDIEXWFz8ba8WHYWJ6UtcdnZ7EnetYsRjeY62Dd6?=
 =?us-ascii?Q?yz1KTD03F/Sa1CK6ZJ0NW9dyBIwzXq/oABp2Yh96bGBCgn9QXi8qjQsdGUxa?=
 =?us-ascii?Q?JgzKbuDtMNb/kcxTyntA78bji772Q+4YKzDKq9Et+Vzfq2yS8VP1uqw4t0ok?=
 =?us-ascii?Q?mFzIISQ/C9Bl+hSfOo5WxLm2/6h5igLkv585Wo3BtRt/Tysqtolcr4ZJPgs/?=
 =?us-ascii?Q?r3jkmeGG0xFTvErvozBhXRDCD5b0KbwyoDMhPSvBP50C6C6UR+utkiGbr84w?=
 =?us-ascii?Q?A0LBhudRp1eaPbvptHod5fbKgTerc2ENFoeE3s2g+G5FaEC/aLZlgfcKX5TG?=
 =?us-ascii?Q?Yb0cnZzkdM58GWl6eQQjNzsbIyU2Y8W6J0q+etfDAI4+w2BJTzPUl27kQ0er?=
 =?us-ascii?Q?OrWY36uyGvB2JYrS4BEcUfCoo3qTmKMjPXD4ANMOBJDbjRoUvPIEuInsftfS?=
 =?us-ascii?Q?mAsvz9Sc9KbMOW3/v2zk7DFvidO1/LULxgL45BZsf9nuIyu5n/cosYFUJdUK?=
 =?us-ascii?Q?+ld8oSkj0RB3KHHPwquSzq7Loo1T9yg8eC2DU4ZKI6jQNZ1irxs7OX3wn4gz?=
 =?us-ascii?Q?mBwpr+1DloxsLjE7U3F+Nq+7wFmoilao5G85lmlB1Y4MRUiqI/ok89agWrIp?=
 =?us-ascii?Q?UK0kQbKGDPvMimH7cXwXzwg7H7hE2rN9ekVwD5tPICUSm1Nl2F5FOCLQlyTZ?=
 =?us-ascii?Q?5XZLZ+/rmkJV31wNopF6OpVCz9cFhapd28cvYAzg1F+MjLKY12xEKQmX84fk?=
 =?us-ascii?Q?BVEFXeH1UQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdb0fa0-2b15-4b11-a194-08df12d76e8b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:14:19.2958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDz6ibqVKeDJ1y/byhZ3J2uE0A/3iibvc3cIqAbR00mDDIQcxy2IAFzHJfnh4KXssh3W3kzm7QMnfOzHZ/Os2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EEB26100002
X-Stat-Signature: cng8z58gc199tq9kmjmt3mjry7m3fxwg
X-Rspam-User: 
X-HE-Tag: 1789442067-257359
X-HE-Meta: U2FsdGVkX18xOv+bV/IWrRcsfGERzk1vui8nLgXDD5o27ZF4JR1ByaDjmeZB2irPeuSXujeesX6NdTcPszWCEHRX49xDy3WkInSb4klcWzaLfeQxlLSAcmYGJi6CF26GL6ZSii+lHLX82R52W2tUI+HsSWEMzraGlMRQjZxdyjc3tFhLQ477awq6QwE6gYeVDCQeE6zxYKSxfIKNnpHFzXSaAHotTq4kTxIv2bZgagr4j7JQFi8RigBYBTKUPT+iLvQ5hG2OFV6F39is+naYPEZG0YXYI/5vppSn4qzpKacbz4WOPBVLPLu8dd4h3o9KQ1JGj2YelhgUk/HTU3pYFv82Vj4bdkhwaQAxvfRXJDOr6uy3APZs3sgCJaWgOEOOVcOmo1kCSk3FZG28B8a4wvpY8FupCFdIX9tqqI/qLXGoFoChhEcdQODO1RMba4Tv+411ZMUF0wDeK4QoQTZU3qXRGPPaxslvCHUtgjDAfqHXMbYxVPgQgISocVSG+Ghs1z7KkPjRHh+MC8UQo/zrSbt8L91GrPZQ/NcDLWzgjOilPMZzHm2AFtjGSRy4JkzSv2yETCmxm5f9l55aAUFXZoU+8Rskbk8ThBVwWD5Rg5PyKtvnzl84lBb/a3o/TbcaGSjBuMdxU+Pi5aAC/SDcxX4UWDaG6phtFicn9vpVJn/foAGNWEatpY4pma2gLC9kf4LGcYLdVYLr7EqHaxolBRkBBHK4oTtd5xj8RrE7dgvaiu41QMtIOeE1cs8rwOQQSM35+1im5SIKpMKMZhOT10g/MBKxbnEaGQ99dSowLz8vnh09uRRNS9nkKm4A13nhrrvnAvaWv8yRuMqPs9tlvQcnImUslzIn01AWMiyhZb6YOW7RsGHFi38RQcjjMSXMDMx3rWwHr+t/ovhwhz3L5RfgKizUJ66KNtzpbR0Yd2pF+bM8R3DbaiqKFi3UJUA50szOB6y3U875HQcVfKA
 dZV2nBQy
 xX148nnUKe1w4ECLucNnT51B1lzyupnlGvG1evJHH5Gu5RbWNVkVt3evBL6pHEEu8fFwqdebQ4vIuCWjzbBhYV+ORNjuaGtrdu96zULV3E6w+sXJ/zE4fqqgqO6WWohKKivrZJvmsrB2qRSPHY+LEiOmccvzh27CsDYJcYUeduiJXXD1ZWYRIUVjL9Iufr3VvekzeQzu1bDrGQz//N9HggjUTQM1cfgAYqySqHtKtxZH6VLuZq8iXV5DbNipY0xD1lVJC4R84z2b0abNsvaS5900cnIMwShIbg72mHiOrT7sbkAhztqUXdw/LYCt10IbVCfftRX37WPSSPyo1qsvHrYlnTSfhuLLvCDp5gyO36h4WVy4k72AF4mdGwJ76sUIjUdE0HlMUZGlbcPUqHcRVWXxSKVQPModAuUk0FdhVIKfQeo8cBR3A11CJ+tlKvtKTx6o1C1QWdgQNUQ9MW9wL2eNF4N7gE1q0Wm/q0AYSD79Lxi90bNssSug2QvYiOv2Yj2vV8s/cBlQN1rr7OibX7NVFPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic, blocking and SRCU notifier head declarations statically initialize
locks or SRCU state that require persistent lockdep class keys.

Apply ASSERT_STATIC_STORAGE() to ATOMIC_NOTIFIER_HEAD(),
BLOCKING_NOTIFIER_HEAD() and the common _SRCU_NOTIFIER_HEAD() wrapper,
including both Tree SRCU and Tiny SRCU variants. Leave RAW_NOTIFIER_HEAD()
unchanged because it has no such initialization requirement.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/notifier.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 01b6c9d9956f..4f6330360df2 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -10,6 +10,7 @@
  
 #ifndef _LINUX_NOTIFIER_H
 #define _LINUX_NOTIFIER_H
+#include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
@@ -114,10 +115,12 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 
 #define ATOMIC_NOTIFIER_HEAD(name)				\
 	struct atomic_notifier_head name =			\
-		ATOMIC_NOTIFIER_INIT(name)
+		ATOMIC_NOTIFIER_INIT(name);			\
+	ASSERT_STATIC_STORAGE(name)
 #define BLOCKING_NOTIFIER_HEAD(name)				\
 	struct blocking_notifier_head name =			\
-		BLOCKING_NOTIFIER_INIT(name)
+		BLOCKING_NOTIFIER_INIT(name);			\
+	ASSERT_STATIC_STORAGE(name)
 #define RAW_NOTIFIER_HEAD(name)					\
 	struct raw_notifier_head name =				\
 		RAW_NOTIFIER_INIT(name)
@@ -126,12 +129,14 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 #define _SRCU_NOTIFIER_HEAD(name, mod)				\
 	static DEFINE_PER_CPU(struct srcu_data, name##_head_srcu_data); \
 	mod struct srcu_notifier_head name =			\
-			SRCU_NOTIFIER_INIT(name, name##_head_srcu_data)
+			SRCU_NOTIFIER_INIT(name, name##_head_srcu_data);	\
+	ASSERT_STATIC_STORAGE(name)
 
 #else
 #define _SRCU_NOTIFIER_HEAD(name, mod)				\
 	mod struct srcu_notifier_head name =			\
-			SRCU_NOTIFIER_INIT(name, name)
+			SRCU_NOTIFIER_INIT(name, name);		\
+	ASSERT_STATIC_STORAGE(name)
 
 #endif
 
-- 
2.53.0


