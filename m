Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 368D9C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646A06B00B0; Mon, 14 Sep 2026 23:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7F46B00B1; Mon, 14 Sep 2026 23:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472E76B00B2; Mon, 14 Sep 2026 23:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4976B00B0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:14:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8794C802D4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:33 +0000 (UTC)
X-FDA: 85214528826.22.0559194
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012063.outbound.protection.outlook.com [40.93.195.63])
	by imf14.hostedemail.com (Postfix) with ESMTP id BC6D0100005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:14:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YgaFWfxD;
	spf=pass (imf14.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.195.63 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gp8H+ROTSsqQHjRYOtvaP7MV8S034OBFVrZpKm8BdlU=;
	b=e0YIh9unWoNMk8CO058ptnWx41+22zMvwOwXfCK3eUMtkYHDaPSeSoZj1XWyvRueRMgxLW
	Cgdoft/FADu84Mv/UTa7vF5237ldZlmia9Eprqn0fSppCm2duQu0UXlsPV26MVdoD6jfN3
	Lc4FNQsb9/8RvrW9ieuKM3/zLHbmBZY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YgaFWfxD;
	spf=pass (imf14.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.195.63 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789442070;
	b=evNARFHTlEcuRfjvo4KgAbT8TbSUaoeMXBuKEjVZ9YXOOLY4SAQ0TNZPIICNrr5NApgvXf
	QC0AS2evdnVr3kZY6MKK09PoRVWUfOa5wx0Wgrg7eiSxEcD8J0O3wd6zXRv+ocZhw/+UAO
	iSA666tCSsxVnMm7OW/wRW/MlwbwU/Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rn8nGMb3zlD91DY8X9QLK2UUib6M/kasmzA6eXUywlD2T/Izy3OI8XIExcc0KlGVuxVySM4zT22qkylqW8NwciggIe6KUu9Ij5lOd5A8hHbZemHXiHf9OOGw88z2ibNOnsG9+OkzwBEVpNi+8bX0+GnFYwnVq2nnCwiRpLHAUQyj09qC5A8LT7mT/b5AxHqPk9jWx611mBvs2H+oInHDt5QGsnxqs8MCswmjIHRThefvmRGLiSk4sNAyTfsvwgGgJX7Akgabo/hxNUYZbqkEnqbWRuysAn8PaDHqhb+bwZcktDDoNLIl/6UbBC7s+TYJ2fGXzB6/I1Z28c0sgCN3Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gp8H+ROTSsqQHjRYOtvaP7MV8S034OBFVrZpKm8BdlU=;
 b=mpKVxALw1JpGb1de4Issdpv2/yIx+vHDpKoTKyeWNw3ZwSnsBOpBWdT9BOKtpP13Sqw90yPvfrWCZuTo1/A1a/fXPFptP6TkpOmncTlZB4HxZXwAFCG7pmflGG+tSsDdE3sQPlZIFjIXwAcvI3fYrOL5Pj92fMlXIqqk4pFrXjnFdpwq5+IiEWcDCqhykY2B3kItk6fcwSTLSjn8WvZXzmJe3eu0uWvXoAmGwP8hwcUa2y+SuvRSsdJwn+94+xK4JfTIwk69t6HFpslw4//MYXSNQmT4388Yu00EFZ5cb4/NWCRutqbOqV+HdZsE85S+TozTgtiSRlXrSWCS3HYBFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gp8H+ROTSsqQHjRYOtvaP7MV8S034OBFVrZpKm8BdlU=;
 b=YgaFWfxDzKKzWqxjMUCXAkyDkkfUPwz0Gp4pCse3qS1dLNd1g3JTWyBRqn8lIwIV8iRMNiFWF6z78ewYeNr8L1izWVTEOZXp7hJDYSY6d+C2bUcKhyzcZpwKppj8jqnhA3XQSsHUgeFtLeVTPp1iLcBiw9IwGF9YOTfSfaiu8aUJ9sq4CLaHSOWQqtwwcuFRaPrOmk68vj4OHTNGRUR0UA4z37ZKhW3Ic2ODMugaRVLbFP7XL8qfX2eYFSHFaMv64eTnMAlrVluTGlIJX+kISoSIPwS8aoRyZGOAx0TOdMVvaRaGHLz+fw1osubEvvftRrQmyGXN0Vrbo+VvfWPCtQ==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 03:14:23 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:14:23 +0000
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
Subject: [PATCH 16/17] rcu: assert static storage for RCU sync and SRCU definitions
Date: Mon, 14 Sep 2026 23:13:31 -0400
Message-ID: <20260915031334.1194975-11-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0029.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::34) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SN7PR12MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: d8071095-7b87-4ca1-0800-08df12d77109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|3023799007|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	CQ91xyTyZE9ZjrDSmjP1hb+cou2oIoHI8XnIxpcdmjgznHrKv/sxan6tZ3JQGUKIripK6Qh+UN94LnQxZyuJwVvV8ZoHNBzyPQ71lAJtc7uEodiwS15x7G6KbKvmOQeFi260nI6xJXwcVRxi6fI95BBz8N6paZ78nvZ02F4h9+6gxzLCLkl1zJ/TlEJfczblwt1wh+x5qdTIicROLAEaWL6MliLHlqUtRuM/zr0i98CoJo4ZkIBf82qIZgds+d3NNnK8gj/TlVs6F6hf1hrNOMhaCJOvA4+kOPPz2U+wL6TC5rOthFpsZBWK/4bjERJUkVxW1N4hY8E0WrKFfsTppxR229YWC73osX3l3kx41LvdWMcIODExhmdKsC4GUGBhjsDXPtjn1RQM4CPHjU0d11pLyDdO+et2rOk8XEudmWJz5O4ZL+bBxrzw+SMTbd+7hxd+CzMcezB2VsWHYF3yHACj/B5vnf+FjfiuMTyznEkeVI0uLUAKX5JljXJWg254+bZJ2LA5eI6V8y9tBpCSraFMujEM41RsIGI5Gsa0oH830dj6cLV3RTHabnZ1pHWVzyTqSeLVMh/15g4JODIj2qz5ps5Y/naygwdUGhSnf4nl4eVVLFO0Pe7UQt31Hm+gZAK5m5V78PNgB69YdoAt2LtdB6RzIfFyhDaBnp8zTT8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(3023799007)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HTKI5diJAcKunKDMm/PnNSByjnMmfgp+iNkji+p9X77PGWdBvwq//hKADHvp?=
 =?us-ascii?Q?wZJcfH+GaBUXIhryS8UUfleCKmTIhiphwoAuKjDbgZoSwXRA8GxFS7ea4TWR?=
 =?us-ascii?Q?V0HCWQDa6qUf2mmU2hz3sSKcrilKkxWUBpcFkY9uiCEWx1W00zG4qsaw0Pzk?=
 =?us-ascii?Q?xEXaXM/9Qtns64vjPGuVmSSE/FIsLMPxlKOPm/2/ZipCh6RcnbrKxSSqpTiE?=
 =?us-ascii?Q?bs1/6dAxBVM5o+gYW4XVCmlYq8M3/wb76B8dokX2PsinOiZpy/9pMGLDVQQI?=
 =?us-ascii?Q?h/Aq8i9nUrCIfom8bEiONs5B7emxYrtli3ariuHJcb/QtqVlBqAkO4A965Gy?=
 =?us-ascii?Q?O/aRXzNzWED/IX/unMeD1h3KvUQkJ4hC1DHN+6b0tOo+rkhNTBYAyCHpYDMy?=
 =?us-ascii?Q?n3qqSDbtaJSa4G+ousTdvEGp0DMVaWJ1CrC9V1lZrxDdIz+8VeFl5IUGm8Qa?=
 =?us-ascii?Q?c1CjaPbc2h+5ZMunh/xQfHkZCL2TLDzSYPxOheZJ369yZcs9CymGhZNrwlF5?=
 =?us-ascii?Q?+xaa9qlg0u4x0xainrsTF3wg2d2ONLMJ3HLcnq31EoAWhvpBE4MZS8/8TTTs?=
 =?us-ascii?Q?vaHiRhRrUg7gk6ysYqNWdvTtZLda0yE+8hlEhHrP9onMpygZoRQRJAn7KDrv?=
 =?us-ascii?Q?kyxwRfEh6YTzl0EV8lmA3dJ607l/1jfu9bwVF6dF7O6eTK1Q9L0sju54h9QD?=
 =?us-ascii?Q?qtks6Di+WnIv4R774tGUt0KUH7rGhvgxB6VeWATK+mn8sCwbQaqflpYy3+bp?=
 =?us-ascii?Q?AdCWTBC7uhWdepaZXkq6NsXaBNj0CppK0wRiX28fiOhFDy2Yxe0hmWpUV1+B?=
 =?us-ascii?Q?JVLlb1LBt08KoQwxSuVNEwM5ACdEo3i2lHIvN3N7Q9GjiJ4tLBXdOrHcFsIu?=
 =?us-ascii?Q?SgrMJwKOeR/Dv4SpvzljG54Vrb8x2gLiqN9fPi6RmGeLzN4NcGEjkgz2BZ54?=
 =?us-ascii?Q?i036YM7zRQWEnDIf0bDQSouR/d3mdhin1U2ZMlsajqXLQ9snCgcVBq2x60q6?=
 =?us-ascii?Q?QUq8v/rmAEl/CTxCNm/R2v8P7ly8ak98/XV2qa38TCsqFbJyB4CyBnadgWxg?=
 =?us-ascii?Q?13S3ZryplfUlQlkjJ+XMEAcsM95KdQqs3XWqzu4OtAM35qSdwH5zxMmwHLdE?=
 =?us-ascii?Q?Th7PjuysLytuw+RGdih4TZmUt0bz0Q6QzOR2xFzHUAGf1G7n1/tfhkCfu670?=
 =?us-ascii?Q?Z+pcolEHGWB8IgVyC4oIiWpy82YeTugyaKUDfozzqTH58QU60PTr8/m9/mgm?=
 =?us-ascii?Q?jBW59q2ATmX9kjeBAXRMLKgcQde0YaX0joT/qD52Gjc6nssj+R9erJ38l5em?=
 =?us-ascii?Q?PVZ2tiiFFgtdqEqj1CQtibFzU9JxFUjFcvLsJr++BCKScAom8tu32da2ZHHP?=
 =?us-ascii?Q?uUv3ZGVnMfMhFinfdQU72C/kDSjMgnml6WglOeGmoEu/LbrnSanVyf/fZjvh?=
 =?us-ascii?Q?4t8fv0GpUQDkulHszRbZzDeT6YvQR8FiiaiHHiF/MuboPfyg42fF/qIkBLv6?=
 =?us-ascii?Q?3js5QtuPYs1TsyK9nhq4e/TCQu95QUT/zWDaNR6NauDGd2/PXSYsqVUuaqRq?=
 =?us-ascii?Q?p1AA+RVZeYIl7TAmaL1R2KWwu1lyhx/rkX5zpvoNUGcsW7YZllE5If8ni2Qb?=
 =?us-ascii?Q?caMaLPoINWFHBGQ7tYvqE9PjzljW3a5ra+QN6E+sNk5JkhMaDDtaCErId5v8?=
 =?us-ascii?Q?xrnTZ9H12RZ/BoF2DrBL0mJblBYpvjRiZMn0DrbJVsy0666PC8Te+fhuxmXH?=
 =?us-ascii?Q?yIbIaXfBOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8071095-7b87-4ca1-0800-08df12d77109
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:14:23.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVcB/SRV/6VUZmWFpA0lUA++iogbQ64EEPdwcxbJS60mFUwpHYlSV+uOjW4+DLUflMx4kDrYPohKX+YbdpJImw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC6D0100005
X-Stat-Signature: ap6bjgspqc7yof8ww3d93xzpywchegj9
X-Rspam-User: 
X-HE-Tag: 1789442070-894897
X-HE-Meta: U2FsdGVkX1/S7o+4P+XbnQM4/Phc3A7Jjd5vaQHu672OWpyJDfeFOtC6Bl8jqN6hkex37xt57ogOOmyWgo4Qzj8ghXiJHkTphHci5HmF7ZKRx+w54uH0EyLF7l2vsMu7aYDVHQIVlYsKVEZ18guCvjJ9lbmuAMqYay26sK0CFKjo9mA9rEgbROUIsyy8lY6FRGpue2Y0tr5uXa0irqCZwnQlskmEAG27o5gjyJOvDjaTo3Pa8ncmhT6bOoA+lcl71S6c9ISs1PS35Ikz1PlYdMuU3Vz/gpydf5qg1UnoNYhblPpJz9mcRyY6ax2CVdMllS298PkgA1m5O6GL9we1llt37fVlwK3GpIw6BmIF83LYL3eUtRcWQbKOojx+XSFLPwDTB0UDcrA0Cp4okVi3uoca6d1IQ4nCC8hAduxiDhwAPtAPsj6h4tsdAgK1j/wHkerHOmM4wgvtXeGAWaYBOIGXpvi5S14RSOp55BxsV2RSHMNhwtT/2LEtx31qnptZ6ASc66hmKcrgik/gW/2RxVgfzA3ozH2bW6nNLUAQFhhXtKl5fjZ2i0hlYyvYaA6WBS+E21QlFVDoyaFUMphAfpr8G6w7g8mUubs/8i3WlD6vIcp8kx5oi3Gb766B4r0phHaGomx/NppxZtQuw4i64L6fI+0znTp2qMe2R8cdlx1zqCzb19a2mhQaVhPHNEmmmtq+1r6TwcRgPqFfUvi2gBZfvlvgGt/Qk1n0vaKkNSAEY6Mjo9dkhnZnFQzNC18HjAZP/SMFzsQLRYqJMrD0UfN4sfzwU+KBtWcCw4nZlYTJoMZMWqa1GhoUbV4wcNaUaUWWxq1v/1PZg0HmOeGWcRDvkWo3IWlSYRMDzeyCKMvKff9aCnwvqGYqCUZXDvkeN5iAwm0CUJ3r2wT8SeZg1UROrtDkGlhJivXOB5/f886RNeQsDQSz/AqXSJzi7Uo69smCwDJsT2r/J+kx828
 xQFhl+1s
 67YeXfQyY0e2+dCtu+utaJMvEhJ/RrOgvr4qe7ICTKXI4+YMlUu4V6jqbVTcqoPoG598NtmaXgafXvf5rgkNCXrySJck5N/8x5Juqt1xhyT0T5rDkgJ+pVMSUbJnMplMKFtC4tHcG8yP3D9gZ1nupwxbr6H/9QjQx9LReaTj1n9zrO3csh8sb6ccLfGIsQknCd38UCyC29kSPGSr4JmaAzjZ6l9wXFN+bjYlPOgZ2889OC5vYQMcU6y0qQXz2jxn1XO1rInaLPsA8ku5tT2sQgfUrjSN+GouyIIhfo4ExdJtYZgscDwUOwrbucOTTbcIqH4M77raOQrtX68YlUapm3KEJh4aihd3R61ZNGihsEpczEEB8AnDjnRlX2a4JxZbcPzmAoBaZsZ6JTlpxMNP78rP9O63KyII2PkCRCP1w6zJqFJTVOeGJJf7MTn2Ki/wHOA3oHn/66nmEaSelm/3Zbui6ilq1EZcnT42IY7ZrS3Db4EhCfrI42Z5LRy4I6oFUuRrpVA9q/LcHQCUzXGL0oxquZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_RCU_SYNC() contains a statically initialized wait queue. SRCU
static definitions similarly rely on persistent lockdep keys and, in
Tiny SRCU, a statically initialized work item.

Add ASSERT_STATIC_STORAGE() to DEFINE_RCU_SYNC(), both Tree SRCU
__DEFINE_SRCU() variants and Tiny SRCU's common DEFINE_SRCU() declaration.
This covers the non-static FAST and FAST_UPDOWN wrappers too. Tiny SRCU's
explicitly static declarations already enforce the required duration.
The existing per-CPU restrictions on Tree SRCU declarations still apply.

Assisted-by: OpenAI Codex
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/rcu_sync.h | 4 +++-
 include/linux/srcutiny.h | 4 +++-
 include/linux/srcutree.h | 7 +++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
index 3860dbb9107a..c10b6d30561a 100644
--- a/include/linux/rcu_sync.h
+++ b/include/linux/rcu_sync.h
@@ -10,6 +10,7 @@
 #ifndef _LINUX_RCU_SYNC_H_
 #define _LINUX_RCU_SYNC_H_
 
+#include <linux/compiler.h>
 #include <linux/wait.h>
 #include <linux/rcupdate.h>
 
@@ -48,6 +49,7 @@ extern void rcu_sync_dtor(struct rcu_sync *);
 	}
 
 #define	DEFINE_RCU_SYNC(name)	\
-	struct rcu_sync name = __RCU_SYNC_INITIALIZER(name)
+	struct rcu_sync name = __RCU_SYNC_INITIALIZER(name);	\
+	ASSERT_STATIC_STORAGE(name)
 
 #endif /* _LINUX_RCU_SYNC_H_ */
diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index fbcf13bc12d1..40b592b4e2d8 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_SRCU_TINY_H
 #define _LINUX_SRCU_TINY_H
 
+#include <linux/compiler.h>
 #include <linux/irq_work_types.h>
 #include <linux/swait.h>
 
@@ -48,7 +49,8 @@ void srcu_tiny_irq_work(struct irq_work *irq_work);
  * Tree SRCU, which needs some per-CPU data.
  */
 #define DEFINE_SRCU(name) \
-	struct srcu_struct name = __SRCU_STRUCT_INIT(name, name, name, name)
+	struct srcu_struct name = __SRCU_STRUCT_INIT(name, name, name, name);	\
+	ASSERT_STATIC_STORAGE(name)
 #define DEFINE_STATIC_SRCU(name) \
 	static struct srcu_struct name = __SRCU_STRUCT_INIT(name, name, name, name)
 #define DEFINE_SRCU_FAST(name) DEFINE_SRCU(name)
diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
index 75e54e4f963f..8bea8044230a 100644
--- a/include/linux/srcutree.h
+++ b/include/linux/srcutree.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_SRCU_TREE_H
 #define _LINUX_SRCU_TREE_H
 
+#include <linux/compiler.h>
 #include <linux/rcu_node_tree.h>
 #include <linux/completion.h>
 
@@ -217,13 +218,15 @@ struct srcu_struct {
 								      fast);			\
 	extern struct srcu_struct * const __srcu_struct_##name;					\
 	struct srcu_struct * const __srcu_struct_##name						\
-		__section("___srcu_struct_ptrs") = &name
+		__section("___srcu_struct_ptrs") = &name;					\
+	ASSERT_STATIC_STORAGE(name)
 #else
 # define __DEFINE_SRCU(name, fast, is_static)							\
 	static DEFINE_PER_CPU(struct srcu_data, name##_srcu_data);				\
 	static struct srcu_usage name##_srcu_usage = __SRCU_USAGE_INIT(name##_srcu_usage);	\
 	is_static struct srcu_struct name =							\
-		__SRCU_STRUCT_INIT(name, name##_srcu_usage, name##_srcu_data, fast)
+		__SRCU_STRUCT_INIT(name, name##_srcu_usage, name##_srcu_data, fast);		\
+	ASSERT_STATIC_STORAGE(name)
 #endif
 #define DEFINE_SRCU(name)		__DEFINE_SRCU(name, 0, /* not static */)
 #define DEFINE_STATIC_SRCU(name)	__DEFINE_SRCU(name, 0, static)
-- 
2.53.0


