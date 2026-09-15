Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300E4C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079A76B00A6; Mon, 14 Sep 2026 23:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02AB06B00A7; Mon, 14 Sep 2026 23:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8056B00A9; Mon, 14 Sep 2026 23:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B38456B00A6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:14:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE91416028E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:09 +0000 (UTC)
X-FDA: 85214527818.03.FE0538D
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010045.outbound.protection.outlook.com [52.101.193.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3ACE1120008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oy/NhTKO";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.45 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oy/NhTKO";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.45 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442047;
	b=NY7M7ZmYP6qs9Ml1BEv9ezXAXJW2QvpOt/P4zbcPiGVdb9HrccCfIobNHJvMwgN2HSrMRS
	ZfjxlVOuQFoteECacYBYp7vkBenmZikJ5WX+1Sht+XJbL6DHR52i1ypD0LokJNSQJuA0b0
	xirL1bb2iVxTO6izERiamxZGwBNnD8A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8kFkXd1m+26n4TpAQnKbmfnec1sDIsa/XGlRgK7oAY=;
	b=VQnhlVFuUKWNQHLA6/zEocEaO6UXkG5uZJ0EFXR8kh94gKIFPRVFpey4G71pXtaLlJrPXm
	6qhUD+tK7vPHg0CnScMhYsFQH1qrpOh626MbkPQ6xE9+UpLqatgED/UcKY1/zMqXQ0JROd
	tWNq3JC1Hm9GYCQLyQrlBWC04jjsiDI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WSIB6D7iKUoABmkiN7JnDaNdfmvaOUzEwrUXJbYaa/DYFUu9L95c4gxewY2CXLLx2fUPFuDtWHhuBzKcMmyVDvIUdOPOOUoBtBwlqr1c7R5yu86arIpLYLTRcYhDHnCmQmjFX4547PekCdv3ANBtP1aMTEXnVHcNbwK3cSVuPCQhKoBlPgpska9u4tbRp83va9dHPwlik2UM9Jc/BKok282ih8UAAi3r3rEIk7iV/+teXRqwgnzIBvWGNk3ZvgfmGjyeC0w9qniK0UQE59DWXOznteCbX5tML745mfDgZC+YnhwatD7GLwtfBJlJx/Vkn9l5WsI+VMADrfoYcTlalA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8kFkXd1m+26n4TpAQnKbmfnec1sDIsa/XGlRgK7oAY=;
 b=Q4zSgGFKQ782/Ah/E1Unerq6a3w3kAVIG3TFu5+wLVQpxtrCBT1OhxFVjLUZHkXedergEZzTWLroWJMcr3IPvb71GFKQplO1r56BF3ZbAwwHxUTG0EHHND/5OvuIZ2VphMKbdpIKtRngDBBQvUf/Tj2k6ByjSotHXoJo5899AfM4OrbRAaEDbzeCBfwzawAbLIF3rA4i24nN2yIzPX8q91TsgAyJ5+x3BfrVb0auI4+ZQfGMQqZmYl/iwAmBJD5OnHhx8jbnem09/OaQ4Aj5vmou7HwnfGvNcyKcG/2hiKIYFK4sW7iqCcJxNvVUC31UbgROY0qdIuMr97O4JSKFtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8kFkXd1m+26n4TpAQnKbmfnec1sDIsa/XGlRgK7oAY=;
 b=oy/NhTKODuvHMMvnp/9WRdmhDKbatbLOLJujlgTwulJlvYLC4fWEK9e+6GgGXNDykqc5Almcgmk6trJs3LhgQVvPBt+U65QlVeuJIObUhVgVFhKtFjTIulchFWEr5fDJX5XVcul7F7KxtoXpZCYSe2M0BLZ2v8G7ATsdw8hEMDFXr1OHgFQQuUb1Iof/Q8HqoVq7XZDAAwUqp1QPhXoyP0m1r3ZnqW41L3pahtQ2249gOWdCQZkwQ7lA8wzJfgE8V9JyAgGLAmB36NHdyNpL/CrzeZ89dLd4wTYRF78CE0EzuAjvEgL4e11qvWmtd+pOKjgAuaE87CHpoEs8tqcHpw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:14:01 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:14:01 +0000
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
Subject: [PATCH 11/17] workqueue: assert static storage for work declarations
Date: Mon, 14 Sep 2026 23:13:26 -0400
Message-ID: <20260915031334.1194975-6-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:91::33) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: 59a61efb-6ad1-404c-3ca5-08df12d76396
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	kjJUI8eMVzCG/opWWped5ikzZ0CdSz5DrS32J5ONyrKNZReiHTnDhqe2d+mrzro4Lhf5g/iH4/SHp9bydl426hycueVEwFW6d2Jk5xENzHFb9hhvSJJlMtLpjaCfGsqJV46ay7Bf4q5LH5jlqkdV8BSvq5A6iUP3DW4KJcoqaAWaj6j8LPSMlO1zMuZoXiftCWk/qWefwxkmDnUmew742/m3ITGAR++Qy6Zz/otCOyoaogaile+7+gRUllD3e7loEP0kvT356EnJB17UvwMs0+q6Q57h32V6x6QpWoEvrybezsxRFXj+rWivmvts6tE0iVKC8cELuZOG1cJWVmY8Qx29LTDGfUKnqS2R7tbT4ze3u9B8f7T77yjJvjEGMR9Lgvh4c6f/t2kjhDHID8Ij/t0qmj1GaFSK4A2HEk92nG5pDW8ifCdLyz1Kr6lCwu8mz67sXbOGVjZQt5yHSZYcbB+OyJPZJ1h9I5eSC0n1s9phlQFLkq4OVDfi5an364KkXL08WzzGM/6fXuJDYVSCEcEAxOa/fD23Zz2aM5sbUXNMKgYGvMQM1v9oqyuMRdgYYxSoTj28nXdmCaEoVifFbXq8SImFueIyCcMgDbgzDuqfDLTXEcXdTb+CSMwuw/YMMA7FQvnEVDhl8cyOddIEcwy/qfON1vRv33Yo8G10/Hc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xPMmaPXtZ5ruDtWhltl3nyl9uEnWy5weRKBQtMXq9QF70yUDMl8calIJXAd3?=
 =?us-ascii?Q?xoFuTnd2yePSOB6Zsa9Sse1Tbr1WB3Gx9aeqkUHeDmQT+ly93twVI+HlSgMc?=
 =?us-ascii?Q?IBFFO/JiKGaBZeJMM/teLMUhIfW/ua9kMmVJNc8U2d46n+hYVl/3RMjO64Ix?=
 =?us-ascii?Q?RtRXhyqr5NoAqLj8ZevHF67oBnB4s604V2b9t6kHd+3pCg8gFXQv8kP/FAGS?=
 =?us-ascii?Q?Qcviqks6d+qKHWQl8a0A2EygspLTt8Rz5/Gro8IDBo+knoYuYQl22uu7xV4K?=
 =?us-ascii?Q?EkZzIbgYLPTEaPpVd8nlgUT9m2I9o9M4nOaDHdnBjQ8/qbzspoWDuUPiFbks?=
 =?us-ascii?Q?GS3uUQfreqy+RElDLOBXTc4MerDL0werxEK5boHUdSygwyk43S3udtr7IMBD?=
 =?us-ascii?Q?3xIf413JfLtcfW3IivONG6vxtDd+LQGKMtSyeuNFnbQh9oiYazTwlQuThv9w?=
 =?us-ascii?Q?3WQv/O23OfzGqwG2BeQTaAlumoAGk0H1TqLwghN5pfUnHFFE6IPKu5fbRoAc?=
 =?us-ascii?Q?2FOpVfuXc3lkFGHXgr33+b1+BcgNQiT1ILjJTQpwp65AsVer9zmzxygdqIR/?=
 =?us-ascii?Q?HxdMUBJ4WxUIOfYClVUjlSjXKllcbIeKuPr93PkgqAdNohqBqVS2fEFCziJQ?=
 =?us-ascii?Q?SyD6oCpbL19TKnvMatoYDiw1twM3NB8xuNnvVwNYMEkdxWZBcMAUl8NBYjhq?=
 =?us-ascii?Q?dH8H04gumcasviCi9LJWeIvw6aIqTXgrKZeEJo2jMp/f9pZ+97q7d3W+pK+j?=
 =?us-ascii?Q?ARVys9xl33CGGn7wR34kU2XmGDrClAS4Ytm99ePpU1Maf4SWDCc34+AVeXPn?=
 =?us-ascii?Q?4ND4VH0hhLC9dh2CtuGuGfMYkBNnXNkT8bcNdZpv0DknvTk/wBO3hetzSD5r?=
 =?us-ascii?Q?laTHIPmOcFS/xX/naZsXuOtUMzwlmt3jLZfQ6hpLbEaM8d0oMgapAsQA3O1O?=
 =?us-ascii?Q?EaFJzsgCGiQemVAtKsoVB8tmK2TjVA7TU0nT8fHNHfR5lfGoYqa7kU9VM931?=
 =?us-ascii?Q?wfRmnbliixSeVbTaDVPQBIc5Nehp7eHcxJ7zFXMQnf8XqpRc+3pX55eGm4eo?=
 =?us-ascii?Q?TUCfWtBX6hk6wYnltDUgAZ04w3PbdMWqh3PBao7BXuIB4GO16rtJ9EpUMTXl?=
 =?us-ascii?Q?YjG8CJtaz8aOmnQ+iWFCRP/1OF4y2oV4QnXOn5wwh62Bta2IFspufrhl6xNj?=
 =?us-ascii?Q?5I1gv0ozFM3B2MElnxCkgEPwBmaejc06YEe0Mh19JYjzqyBExSxGtVIBwMft?=
 =?us-ascii?Q?5GKVAE0qN1tVBbjjKnIB2XP/5iTeEACO2HdgRrpwL/s3q5I7X+35X/hoJ0RR?=
 =?us-ascii?Q?X23eftLQkIrMZycFVSA3EwBSTFFJyxIyhIgec/avrIVBsTm2LXfXn/KhgEKr?=
 =?us-ascii?Q?Z72LpVePl0csJ2jIWYVQ8C/P2Uoey/g9gvEzYDlv2dVo/DTBDMET5IHcBEFl?=
 =?us-ascii?Q?XmXZ8cVjCvwxCh3jm+7kMs5I4PYiNKSxtPGGJ9TXwUbDj6Xp4LssqnajjF6X?=
 =?us-ascii?Q?o+0dSoa2XkX3oMdws8oFqy2DWhOqOeqA0C9E47Psif4hZ2lAtbBT6yWAMkz/?=
 =?us-ascii?Q?Puqkab7ICBXuaeg+P5SJbup3UjhOoMlCHfH0ZaBgz1xs0AiULxxZ1OZKrYUZ?=
 =?us-ascii?Q?txQenUCBJVAe3CyETg2nkch9Q1iIUNO+M2Af8B79scHRTQcUCcz1CwbiNYLy?=
 =?us-ascii?Q?V/YFECq1qON6N0lBj7tHRZBengFL1pf1KqSvtoM25765egoKfxpyjwfLcNN3?=
 =?us-ascii?Q?QLkIeLPaRg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a61efb-6ad1-404c-3ca5-08df12d76396
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:14:00.9179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6NJduMIvlT/VoFZpGDIENw/vDuldtT+gvErjb5GD08V+mW+j7ROgQpzlOtxsXT2R2j9k9SYHRStGZSJhpcRSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ACE1120008
X-Stat-Signature: ugb3p1jpsdf3hm48fc4itfm3oypg3xa5
X-Rspamd-Server: rspam01
X-HE-Tag: 1789442047-655169
X-HE-Meta: U2FsdGVkX1+KzMnu69VgBJxp/wWMWz6lx1AM95//7MasXTpbOfwV42rTYO814C0fH1sF3xNpJnez7h5IvSS/9IoMSl0nlOIn+qywV1oi/rBEXnNYCbZdO5TOMggxX/08ewP+X/E1e2uEVj3BVjZK8xw3IfQb0l74cAv2mljGWETHdW4xzVebDUhWq0cgvtFd85eXY6cOhn/AKkXUwPWaN5lK8jBWRNwV4pczc5WPAuc5HyFxdCaXZ8A19Yo3vSSr3ulKa3H3q54u81rAUHaKj0f2vyJlDMzyExGQ03dy++UQiLBXwovnlJiamXXA70+9aXQR+ueiXhwejM6QbnresoCiWTNEpGeq0sKtb0l36B91liK727KAE45nmIsEoIKajaJqPXrMgUvOYXHySSAF2/V+oY+Q1XVEkHPbOcehrbwReFplQpuuIlvsUh3yva2yuTm/IFK81pG2EYsiDdtESaE07/o1OylW7Wm/wwkmGoCYJUSqfdM6gS5Imobyv3PipNrvMKKj9ZzL4bv2oobpJ5mio6QK3s1V1Mcn/etxuMktwyhAFPSyOZ6vprsbZXXdIy22csi71XnXEN7Cp5uX1rpc9COdeu/SXmj4fEV0g9TNoiUnSQDr1dTwPCbXHqiOwG66+Fx7mrv4m8Dqn+AcQYfZtVnvVGPruGcVzE4ukEkM/4PqeRUy8bpT3bdChPeMVRP+kR2E0u0fLONZTbM+99ZQmZ+RsJCjglo0E3LnZ8AZB4cQeaJSp2ufbrztFXApp7Y9/dTjyl7o0gmr0/CmWO3f8NRJgr4muioxgldwXT/ORwWgCCHqLpcxlREoLJj2CWKtpQQVWG7IHdEac/3i0Y6AwntZfxJ53ezPgYyKM707ZzkHeZ/fIAXH/Yfmp39kYGTNjS7ne5MJnNJcfNHjNPMATbrv0PN0L2Q8hrgg8Fw8h4YAk15VFQiNqUa8CCHz/ST5X/GMGLc+FuhYb13
 DxZbFVQF
 oMxvCXZzRM98I9tZUwpKnSeXZaXQALOJS/M6dckIscELpkN9FBlJi/+bWypglDWO5pUcng6IXxNri3iVtDq1xgwcsOCbHyeAmzT8eCk3gpifFNLfDtJqrJhqwkSNTL+bjQDfdd9oddwXcT1g3CFD+ZwiNhDHxUa7L5RRaN/J6WArmd3pTfggOEHsHBrlJhelxBUNebZfN7zTS6ODfZRP8G9U/RsGLa9pnrsk5QXK8dOA93CTrxeZJOYFSg0msBeza76RMwodHY4kDbCEOPgNaKPY8YLmR7utSVeHEy0n1QkOPGSXb/HgMsA1O+1exify0pPIWou+fCkDnCU01j15ZqOTsFo7nV10Ycx/YOAlWeNw484onwYhigVgKuGppdivIIrOULKtWUuzQN3bx3/UgDeu7pBBbc9cY++bMLWsELCufKOqDUxPuD4I/yymtvIm9H++uZJAetQjjHRtXWZxnpSCgO2UeGCpH2Y66pVeEMcOZDzGqBWa6NRP+nt7L5PbJUys299gt9XsmDy4UO+oFDnQ/JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Static work initializers use the work address as a lockdep class key and
mark the work item static for debugobjects. Automatic objects require
on-stack initialization instead.

Apply ASSERT_STATIC_STORAGE() to DECLARE_WORK(), DECLARE_DELAYED_WORK()
and DECLARE_DEFERRABLE_WORK(). Automatic objects must use the matching
INIT_*_ONSTACK() API and destroy the on-stack debugobjects before leaving
scope. Keep the underlying initializers available for embedded objects.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/workqueue.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index c8a36423cb34..433c9801d9c5 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -6,6 +6,7 @@
 #ifndef _LINUX_WORKQUEUE_H
 #define _LINUX_WORKQUEUE_H
 
+#include <linux/compiler.h>
 #include <linux/alloc_tag.h>
 #include <linux/timer.h>
 #include <linux/linkage.h>
@@ -250,13 +251,16 @@ struct execute_work {
 	}
 
 #define DECLARE_WORK(n, f)						\
-	struct work_struct n = __WORK_INITIALIZER(n, f)
+	struct work_struct n = __WORK_INITIALIZER(n, f);		\
+	ASSERT_STATIC_STORAGE(n)
 
 #define DECLARE_DELAYED_WORK(n, f)					\
-	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f, 0)
+	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f, 0);	\
+	ASSERT_STATIC_STORAGE(n)
 
 #define DECLARE_DEFERRABLE_WORK(n, f)					\
-	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f, TIMER_DEFERRABLE)
+	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f, TIMER_DEFERRABLE);	\
+	ASSERT_STATIC_STORAGE(n)
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 extern void __init_work(struct work_struct *work, int onstack);
-- 
2.53.0


