Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF00C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98756B0098; Mon, 14 Sep 2026 23:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F056B0099; Mon, 14 Sep 2026 23:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEAB46B009B; Mon, 14 Sep 2026 23:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A42766B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:04:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27AC740302
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:14 +0000 (UTC)
X-FDA: 85214502828.08.4638FD5
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5DDBD20002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nxh1eImv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nxh1eImv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789441451;
	b=lzLV2KSuOVYt9g7mcwkQB3pQbumRKQQyNqLFWvJcSApme0XaOJu4q7RFfvb7LlNn540WxJ
	JUA2qk+saVYIUHxd4dI6McMt+gTSVd+Xc/h0Inbbx6J/urIH477MM1bDHrIi+AbBM9iBh9
	SGADfEPiMzZPlXJbfNt+zSIa/zn6+hM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789441451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LoA7qyQsBYaWdR45BieXiHlYTj4JVd8bya3UuSgaog=;
	b=ZRfo9mOdxf5YTNoZ6VQj4gH5jJRDN2+tdJS9QcxyRbJd8mNzbCwtXVqTkNgliTYQryCnQT
	Ydm+4/sfatc8k3+uk/2OsbzhVYLpEfqH/ZIJWMSTFDZIHvqFzdJ+IE4SGVUwLQlwJStDVc
	RqS95krEsI97Tk3Y++XRCxH5erWDpuo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fchjpttpYQw7gHsVsRX1kyUJomwt+eRut2pL5OyYrmh6xvB0tzBHteHORXLpWnvclMazV/4vxZ1cccofeML04jQH7669PAo+GW+M+hOv0LDSWMNFPkUjzfDe4bBkXWKHj/GOjMKV0bZ3McqyrcBdd4r9u/DF7oo3hbMW4hMoCeoAKTvSXgBvCcJxLgS1aVYDUkSJcvIA3EXAWNjUrWurZrAFOh99vrjL6ttkYCDRqYYiteI2D133TflySiiQY6kPcug21wShgZC86N7Efaj5HbAuinj2glYOfYpbRoxFBlwSLy+fIt85uupAf/m7r7urSgy1r8UKYGkdP/p0q2Cg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LoA7qyQsBYaWdR45BieXiHlYTj4JVd8bya3UuSgaog=;
 b=RD2Oz2np7qKy26gigxdnFdL7qDX2KS2kLGg1cGqJq4137pQLXCAzGhMLQsqLzeXnid8+fxZm6C6G5c8c8N+ntOFbSUYJrtgmeQCi7xMj0LLYMaP0rs+HoQSqIhOCaihJDC6BlK1AS1No/j6LcAhnV6PSn9tSvkD4i08oyuRYuigEK7ybpfhfmSwQeBbrydojQv0IM8XIKd+qrwpunLIuFEhXEkl9gBPoIgS3h5lpv8MjsvW6yoOPlJ2DhWugL8bpxaK4CwFfc2u11CzZL3VGjv3RlJLVEB41RyrCDjx6x4fiVZFBPp6uOyJDng3hEVWaHefH6rWJ4TcZAmNVnJtqYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LoA7qyQsBYaWdR45BieXiHlYTj4JVd8bya3UuSgaog=;
 b=nxh1eImvHSDtnGUY9rCHr9be27/HwMl6GeZGBpikOantYMvWrbu8uqUFQkG/H01Nw+e1rDw+Y8lJzyJQSlUJbZ+s+IaQ58BWYOtBEQsTTG0LK4sawTd5kv5Gii0y34blRkrxXKdbNuidgiUjk7cIGj5xYGUj7CcpjayXQu8v6Z+5TdvZU/uQjyALqk0gc9d5kcS85Y8z0XyzRoKcPhJ4cbuVnpd3fyQIfcYosuH2LFE86DACMfMWWQtAhagp4wm4gNTYWdExjEiBt7EDnQw/dxiLckZTH1/zcyA9GoYO+WFrqAjhE6nesiiX/xYEBE+SGBUfI5hyAsX4x8GZL9PAfQ==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ2PR12MB9008.namprd12.prod.outlook.com (2603:10b6:a03:543::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:04:05 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:04:05 +0000
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
Subject: [PATCH 04/17] locking/semaphore: assert static storage for DEFINE_SEMAPHORE()
Date: Mon, 14 Sep 2026 23:03:22 -0400
Message-ID: <20260915030336.1192299-5-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LV3P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::31) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ2PR12MB9008:EE_
X-MS-Office365-Filtering-Correlation-Id: 19dc4a90-30f5-4bb1-852e-08df12d6004b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dIOZvI9mZD8/RJqyRIG5gU8/vsHpEV6ng3gegSD1t2zZjeYkvOKC4raBRJTQMArjKIHJmASrxmcJcTXihdHr54jFqvs/j2PfW0HL5ZndTyj7JwsAvtFPvTJZ1mj4VYA2swhzCjB43OZ0YGt2QkWTMkpQk9MBC+Dm65ptD4OivcPnYVxTe+lI1CWV35++PAK3GNpSwXqcA3ZVG1Vz7GgoBlalTBTmMcwDE/1f6Ho7tDbH6oiAqkdsKuuWY79G9ffUhKOpLi0ucyxo9mt1CPPGPsHCaWWQcU/hHkicokqVX+jXljGS+MV1YFi/F6FAaIsU//0C8CQmd6ywGCzncpr8/gsDD3zN8ZdvyOgTno2TWRjqHUG04MdmYPxHygKEqMQYtQ9EPl2XRCGl+sbzhBl3cpQF+tEyNx/aA2X1asTwUBoXt0fRALRil8I50Q/x2Qj3aiCHV7/c5Qy2VySEf9llYMJG9I99b7NPIQr0jjnIl7+QeB4ciZhNiKcWr99WHz0xn6K+02n/aK1i3bghS4ER7s9VBmsdf+SMYwJXjviSVjzTM/eodyXGwmCqXS6r9ILM5YjP5/4yMJUcJOhCbDBm6dnzUYXEVkvfCGxnB6BeGXwvY0I9jvgp2ot84JrihAvXtPAPGyPeI6/xwtmv8E5j2k/82xKf8XtbPsEXvPmDvHQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?poD4KC6O5dXlqe1LK4cePsrCfA08HcuJ8adunrnPBw6F/bTRAiWBohsZnt9X?=
 =?us-ascii?Q?IoLFuk11aTDhcgh7BxWXN8rUarte9oWj/7r1Ky0cCRTIn9TEyPhBnA51v9QA?=
 =?us-ascii?Q?r74yGiDh6Dn4s3DRxh6bD39a2GkI0Gl1XOOOzHSndPSB/DHfn8pPc2FKLfQT?=
 =?us-ascii?Q?cbTsurQBOx2rB1VMREuO1xYctNRqXFvURmUYQwwtB0BX8NBEDDyaNXiw1xC2?=
 =?us-ascii?Q?+FkRsOCQi+PszT7FbSkA1DGrqsu6n2hebnRzdv92gk709SRSJq6scNaQQUa0?=
 =?us-ascii?Q?fT1LwgxJsePyRI2V9mTBrKoIeEgeovYMKLU99dpR6LZt+mTSSnczPyUWaMuA?=
 =?us-ascii?Q?/tEiHPkOqVW425lAdS3R87HRrQetB2begoJUsnm9Dgd/AeqS3FpyF+SoHRYY?=
 =?us-ascii?Q?gpMTL6gIIBCLtn31av/qrRPoD0kQLpHvo1GtO9uYuFbMeHkpMzMdRDmnufsL?=
 =?us-ascii?Q?vLc+PL9zMVCAyzYNz8MWC7vAKg4+5Ab6Y1fhKeOln2yBY1pxFTLyBM2p17/+?=
 =?us-ascii?Q?Bo5BYaFAWkxW8J0Dz469fheHPfSuEI05CQN/EcbCR5csNCMyzgpSD5ADf8EP?=
 =?us-ascii?Q?/qUsWiUo9H0bf4pCWSl/Jh1Dk76sSerb9FC9ADvngR7S6l2n+66CoE4YrE2c?=
 =?us-ascii?Q?4OLra3wAQAKO5Cm1U0jhg440D6SN+QdhZ/G3tHnws860EXZNPTn1qQqhHCFm?=
 =?us-ascii?Q?hEa4ORcKCRtETplCAhKsY2I0TS74tNbmWq3AcDT9CkjIAFmmUgSuxCByySkw?=
 =?us-ascii?Q?D6vX3oMKCiaDbXFXbsq4AKV8tGSy3HkjRhh7beNbwvxMN5L0NDBzGF7BemTz?=
 =?us-ascii?Q?uXE5447YV8NHQtDMiVUGcD6xhnFplz8qDBXlvN/B+EOdzR9Job+OlpF/v/eI?=
 =?us-ascii?Q?0JwmmLLHjfVKIgde/ZM6bXjqfWeWbDvjaf7LDL05CVRac/S7HxtUpLACJ093?=
 =?us-ascii?Q?7scKDCcMjEDF0avQvkLsjjEBvvHFDD7A9SvJbVoB/rc6oFcwGPcmVjLcVXsn?=
 =?us-ascii?Q?qUnGTgjc8IdZXz/0ZxlqVL0vnFDed+qVtJjzNmbIGngz2aOuiyXU6A89OW85?=
 =?us-ascii?Q?1TIvGUD9AGaorn5/8XPmqr/FbbP+YDH0behdXXValFNb1s9RrmCee9nzTNXr?=
 =?us-ascii?Q?MX9KX2rdKDBNHfhAl3/kcatquuyWxEgJXFbMI+1TyLa0ItgcFSyOKtsuhaPP?=
 =?us-ascii?Q?pq33ySGxD2VVVBnGreEb76q7WvrxVahzaT6oGwE4Yatyl6nUgcVJZwGlfcZu?=
 =?us-ascii?Q?eTuaXEp0SEnfkVkPn8QJeS4CG7yro+tUcGpsEGVaS0bZu0YZC4SNd7aCQzwc?=
 =?us-ascii?Q?xhiXMzjggJqS6jEUh3yWvgi1j6Ir3ecBAZ+EnOLn9Yat7PMm6M3Lk5hPMdQ8?=
 =?us-ascii?Q?Pt34XNxNmWeG/4QnJwlM/x8e2FW8QrZEJJhcjVEN05KQGllC9aqTjyBUrLZW?=
 =?us-ascii?Q?m3ysWFGtQM4/xIT4mN5JNswhmqkERgEAoXtdcVvS1DclP4fn6LVuAG9JzD23?=
 =?us-ascii?Q?BJIxTIBfeuYCEPXtR6fsA4kCZz1ZzeJaALTswwZR6bmEYm7dfbK0Ln83Xl2N?=
 =?us-ascii?Q?rmoicjAYsEOmfVoGyJLnUK8MESiudSEWOZug1rz6ssjl4w2I275ccqPD1upe?=
 =?us-ascii?Q?iCpPjms9XF4/rDnoK83VKNn/fylrzgwljT0qD8099UgAbd+tpt2eS8noezwt?=
 =?us-ascii?Q?gbfdlhUXJZjmcqHFZJ5ZwE1Nps+b4bH96BUCQ9WqG4/fUg9MLqw/Sd7MtohN?=
 =?us-ascii?Q?v4AlVFATgg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19dc4a90-30f5-4bb1-852e-08df12d6004b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:04:05.1198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hE15KiqnpUa5sqGk+ocy88pWsX+mXOX8No2OlLwrrp8o/wDx/UEhKHS5vMBfVpxBpua7pGMduOQ1FqsrAo45uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9008
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DDBD20002
X-Stat-Signature: 4wggtptyzyc9xwxf6itzgdhrmos63dob
X-Rspamd-Server: rspam01
X-HE-Tag: 1789441451-476645
X-HE-Meta: U2FsdGVkX19x18zwIFn6KdKLiHE8FGfdieL6NvQubP4QsUcWbGdXs6pd9+m+EVIxSlTayytBv8lcjjSk/zW8QlW+6RINidKtCISNRr4vnZAqW3LBdehsFM3o9BBw21jQGsYoqEM4AHm3udxh8n/CabcALrNajJZ6B7+FGWGkNzoNF8FyYyslczNYEdVzyT5iJLKXWzL1t5Ac8nb54UGUvcHKmCzjH7Wm1xEDKLi2YUNWNS4VJwDFDmMy+qZp+0BUTOceySfvVdyKxqThoWp+2bgHUfIloHFtBvz3K8NFe7eMeVrkN8xQvaTehW9RghC4W+ryhHLMwRE0Qt33Cl+bW9LeZb0CRQgTQXqQUjYZ+Luii3vwWGLh2Glu1EfFn1fzAlTWYdw6gOWkQCgQ4ocs2ILlcTXprj9+SA6yUmiSh4gS5RTmQJFeNeZarwnFpLod/D9idZnjjxHprXtee90FYzbu2Ry1qG64Y89J6tpVOfAhnntUSkIOvA3J7UZcDF+NQ7We8RtN6xpyCIkgMg2636GNZiebUfpmdfhWdKFq9ciYQJdjnVei+jEOHlBNRf2wQ6YpMD2BY8JBe7aDvzk9ZYIYEtu4/mr9NQb0gU0yzRZ5xmv0Q0Bb6gecP+5+foycZduiI3uz1zGQRp3Pse57Yz3x2+HO4BEdr8Xjx8ktLleJVPw/j6zGlimXZ2Etlym5m8CqJFeXVjYVqJBcwm4zhYp0wealvx8ELP2JcUmHVRhPwSym5EDxyed5cTil0+CD2qgojmaBddfevL/BZJQl4gqd4v+KWh4TFCg0HILIaWGxQqfrDK5lRq1+f3cxmRep+TTtx4sSOn9v0RrN4FZQjSg+gpbdDd2aRXh3zVuoVgkBliAnAbP5JuP0MhfWRQqpS9hPHG/T97vLrDM7HsUWL+wwBhS3ok/pooIICyIpqBbPl2uRfm4JCneqKXZBzsftZWTuiMF4eUwY6Qpquh4
 MZdZox/x
 Nq7ou4TB+STlgdU2N9BRf32iSzMG44jYkHD/uyy5hpEZL/x//wSeD/HKlYjrdypRui+UWlt058wkZJAiS9X7PXcy2Q2J6oWg/A17QkMnmRtgOWb32pGV3xssJY4gCplpAXe4NhEDxGEf+4Wj0Cgzd4/I74ZsLo7n1KC8LLVn/kyjJBv2nkhsUxLtcf8cJ2uauuge9qxuuhGRW4g7gxrGGaDjgD4F+sdT6JHRYf+BL4N6ddRYlLE2mEz7r9h1jo2fvnF3a8lh/2VA0UiauJnqqo6WGfelqqjJ9vQJFOiMmMFAv64bILCIjisGIFQfZ+aLmLXmAOy+3AEU6iXX8OK6oQm5BF2cCtBgZTOvjw4RRIPDC2ZB4HEE03WFhs2g1LC5TvFB+L+MFM1uPYR0l3eHwm5Du/XS+PXRie8BlWXviQbdOmYuL7Mw6EgnCtz9iho0hXw+OklHX2D2knt/6lIHRi1T6ZeEQX8rZU1H6sC4MFcf6dM3S/cBSkyndZI7Arkt98hzYljV2JDmKhx3KlO3et6Dyu6O3Bxs55V6Dx/d9hUyJXMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_SEMAPHORE() statically initializes its embedded raw spinlock.
Using it for an automatic local semaphore leaves lockdep without a
persistent class key.

Reject this use with ASSERT_STATIC_STORAGE(). Automatic semaphores must
use sema_init(), which supplies a static class key. Preserve the underlying
initializer used by sema_init() and by embedded objects.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/semaphore.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index a4c8651ef021..c0657a6aeb12 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -8,6 +8,7 @@
 #ifndef __LINUX_SEMAPHORE_H
 #define __LINUX_SEMAPHORE_H
 
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
@@ -44,7 +45,8 @@ struct semaphore {
  * context.
  */
 #define DEFINE_SEMAPHORE(_name, _n)	\
-	struct semaphore _name = __SEMAPHORE_INITIALIZER(_name, _n)
+	struct semaphore _name = __SEMAPHORE_INITIALIZER(_name, _n);	\
+	ASSERT_STATIC_STORAGE(_name)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
-- 
2.53.0


