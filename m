Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C71EC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B365B6B0092; Tue, 15 Sep 2026 11:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE62D6B0093; Tue, 15 Sep 2026 11:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFEF6B0095; Tue, 15 Sep 2026 11:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73E8E6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:53:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 085BCA5661
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:53:55 +0000 (UTC)
X-FDA: 85216442430.26.8FEC7D3
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010070.outbound.protection.outlook.com [52.101.85.70])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3752FA0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:53:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I6CD6OGg;
	spf=pass (imf15.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.85.70 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789487632;
	b=1kriPjueQrEebCq6UX0V4G7KJD3d9RkI8EnAISCc6A4037xR85FDIsgclqTlmmKc7g5VJV
	iCBg7G3MC1X0v+8wDIquR3UE7UPHsihdStqND2Lu5e273INv5FuxZSYGy2uDuB5ZlWyF8/
	FRXBBtim+r397bv8llJwH/lcOnu/GAM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I6CD6OGg;
	spf=pass (imf15.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.85.70 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789487632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcHuBiVKAZ0fpaCeLr1myHlzqWosgg3CQFg0zLYOEKI=;
	b=cTUJu3umWwzfwtMCBVqVKAjdiNczJEGjVXs8M1BzG8iKjYp0AkBWbv105X0OfFih6JV/x6
	3igWNeeIBOo67/YQCYomg0yrhJ0BLL4HFbUisvP+b9XsIfSIKVfuL2laopmBausffzehSd
	G1NyS39hj+c8Gqq4Ou8mGDZG0fGLyok=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sQ5vM1dxwRqkeCTpiy2hrY0hkFjMDY/q02iCMgbTsGKNhI9zXJWXme045NU7QRaTdi2sWT8BOi71GRWUKWao+zTHc0nEoI8CiolAyLFY4l1p3eoD+J1Sv2zgkwnxCY/2MgqGX1lQfViW77A3JRiJh3dqk/CXDkNFLxeM47CLaJAchWgkzAabBZl9YLNNCA511NFMZayt+R2vjt0FJSxa2cDkTvqjpV8qJ/aV0PbkBdYeXeuRA67x9HK567XkdD4eUiJi/YyVTjZrC01M7B/V9ua8NdFbU6NBm2T/iUG5IhJn7cMKPnNDQD44tM1jMoIQmO+rKbwtTimaO7Icp4gsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LcHuBiVKAZ0fpaCeLr1myHlzqWosgg3CQFg0zLYOEKI=;
 b=hV4XzKGOIM/k0QOxU8TLYB8ZBcKKC2NPBW+RtiAOv2HhKuBaQRHFu92FAPROPAVMthf14Y+0Bp456FIz3TAmVobmQjxKG7h+HO+k35LyT5IlxJNarJCSEnkFrbsTEL5jcp/mQXriLAz/uE/cb7eyfWZe3C5Rvkcht4aZizPXtV2PZAjVDpxxlcFXg31aJzIpbm1kUETr9QBsHVtohkiZnDE5DOfNQPCAOH+PWeAzBPfThG+Lv+fOW+Yw9PWW5LuSroH1ONJr8/264kv8/g4GtV9nVf1FLja+qBl7meMsqk/jNYlOBdF53FlAj36g7K2LbAnpPh3j3qt0SL4LLEem/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcHuBiVKAZ0fpaCeLr1myHlzqWosgg3CQFg0zLYOEKI=;
 b=I6CD6OGgf6kN/spLwN0AIDEYAfYnPjBCFB+QJhr3xzku7Qw0MjTDR2pAh7uDao2M6Lp9EpTxUpFumKBSzreeSm2BxhrSZOjFZAsEhsg1Rc41+bVDPXkKg+j039E9r3lZrsBoiKl3cPTpVGwOyP9q3QkFG/w2OYwyX3kajwN0fZN38gKOdDLvh3c5b3G3YIrUsBpahXcgvQR5YJi9lAK5Z5rjgHG4ycoWTwOioLGD+6zdTuF/ayxldRicmrhbg/wON52wr9isp120P6q8/P1vPGSCb2aXJIY0ob6a0UC0RaxruOLsKe53RS/dvVgyxRJhMuIkLP+O9NIM7+GGeJv8Ww==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by CH3PR12MB8329.namprd12.prod.outlook.com (2603:10b6:610:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 15:53:37 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 15:53:37 +0000
Date: Tue, 15 Sep 2026 11:53:36 -0400
From: Yury Norov <ynorov@nvidia.com>
To: David Laight <david.laight.linux@gmail.com>
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
	Joel Fernandes <joelagnelf@nvidia.com>,
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
Subject: Re: [PATCH 00/17] Treewide: enforce static storage for object
 initializers
Message-ID: <aqlqAG5csUPFcSzQ@yury>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
 <20260914231418.b15ec01f7225cf460f6e515a@linux-foundation.org>
 <20260915102401.3c56aa95@pumpkin>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915102401.3c56aa95@pumpkin>
X-ClientProxiedBy: LV3P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::32) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|CH3PR12MB8329:EE_
X-MS-Office365-Filtering-Correlation-Id: 96645693-18de-43b5-1df4-08df13418132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10067099003|6133799003|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	d93qJc/QuT2rjbcJj2BRBeNsqLTjh3OrN8BCMIbyCQM9bGQhvxhiz/Xdw9H3KX+WEETMXCNV1bvy6cANZz/p0P7mAIkmLVukJA0t0LCIczMpsXWVsBbEXyNbSMOGw6CTrCypw2d3i/Myfw076do+S+ZKQqrs/oKKJyy2xa3Q+BdOEqGJ59bRcZ48ZvQqQdSoJJhnIFx8DW5ZJDWwotHJWjv7FxufwbbPRM88AfVacusbMzRsNJl3V/PdazCv25POMf8CKQbQ0xM/eekGBgyftEDwp12qaoewkZLXBqs2olWorzIVP6LoL1J2X/GawJASTXfLjU3N0F1KZjFk+Zkdw5ULo3CXrz8e1mwhDznE0hLi+G9aaRES277JOSBr69K51vcTckoBa1Itq9gOY66h0u42kpVw5BNRhfz/iYpYrDB1WdNeukAvRyaslIf1zfkPUhFqlXrgy8t5GuJEa6siy0cbG1zXJSLuXUV0NQxvUI1fvNk4PTA5X6O9i1BL6tJG1l0vgSK3adSF693OA2uwWtXGWYjxX42seJhsY2VYYlDab/hBh1sGMGicARwWWotOtCKSNbpA2Xwzmj9RjLIUEECAvjeHEa2GFWEBjgmSpgI/iL+6sqGrx9S2wmUUJJMf5cE4hOnPFwUCWDlaIUSS/5LIYx6OLS49gzItGC377f8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(6133799003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4OFgHVTW8HAL8iD3NNGVIKY6JppEMbxl8qtf4EYb6qhyOWuhn+LWbG1vTehz?=
 =?us-ascii?Q?Y/CK2tjNc0sXtu7Tvpc4C1S1WSmENYCkRzloS53zF4AJd/qNih8r55pafUNn?=
 =?us-ascii?Q?6AHi2/4wbprvnZCk6ireeqVY9v+YFSnTq6XhGdXeR5mtegrRyYfQaes4L/KX?=
 =?us-ascii?Q?IgihDqM0Wg8tCc7lS0MaMorClUeSQE1KDusBJJylC3+wgMhmqN3FdwuwnEMe?=
 =?us-ascii?Q?HJcj8+INyJcwneNu3sbtUmaFwZ4vBEjwDnp24u/h2zcgaA3BmJxNnLawrlyY?=
 =?us-ascii?Q?B4RecEybkxf1jWnooyUo3NEx7oHcdxfZDCSZg6boItTmlZJkgHAPtAo12Iar?=
 =?us-ascii?Q?6CftdUZ8Pt7bXs4rGh5ZuGaPc8AyCIm1NuIPUmZHmLbT/cDqzSH2km9a8KzE?=
 =?us-ascii?Q?p7hJgcq97gdVxh4DORSDz5m+p3sGYVFsvUKLDTrFxoKF5FXkwQzD3RNVe5NS?=
 =?us-ascii?Q?W67J4eSYJi/2oJf2tD3UmFefEq2wRl9+tyknv5R6DclTqeiJ+qTBQxjoGXd5?=
 =?us-ascii?Q?cwotGdP3CCEys1mR/9eKQcQdFHvNnj/ahTrM2zbfUfeu7iIo+9z7dFnCYHzy?=
 =?us-ascii?Q?Pfg+SHCdE3vu1jT23szVOjjsdnxb8yWZM/+Bqf7R7hrAeeGXsgzld7xqa+I0?=
 =?us-ascii?Q?Zl7ymI59DsjI1QbaHqh+MFARWNpgKtkkYdQHzD3BBceE3u2Zbbk5Ao+mVLT+?=
 =?us-ascii?Q?kGtow3S5L2KaI6B4+0zqJ0j3WhF8hHY4YErhej+l6SgrlkLmVOOuvHv0+hEF?=
 =?us-ascii?Q?8pVLxI9bp5bHZDaepRbHq6jcCjTW01yw+3BUndh5OJn+5bylWApJ+OBhNIi4?=
 =?us-ascii?Q?MaCJKmnh1ed9yfurltKdH68p3k0Zu7p5yyNCiAJoFkZ+jy3rwm8sk3ZAxhOJ?=
 =?us-ascii?Q?lT2ngdpu/aAkaJZomsiR+7L+I61Pxnmu+DS9cI0LT8EH7hCmFTz1lLgYm5v8?=
 =?us-ascii?Q?zhC9rgZ4Ieub9wjrXoMVuxX+9LsngHuViFTy5r8Lmtqi8wHCtKolGmbqy0uJ?=
 =?us-ascii?Q?HpmDH0XayFHZCiRZjPjhtl9XG32qgD0YJ/3x/1mG/OLcY0z46OelIBfZvIdI?=
 =?us-ascii?Q?ffZqdsCu3faqBWR9UpSGLHS0SGMA4MHOKgx7D7wGezffPiXjo0+wquUZbvK1?=
 =?us-ascii?Q?lhowiaEe+G2z7989dHevm2uE1yBxlSh8A+Cn3T9zqjj26K1vd8C2Je9JU08x?=
 =?us-ascii?Q?SHjJgxOpZrB1aj4hJC0mVj6Sgo0vXTbn7KEXFT0WQ74Ccw8FoxyDAmon8yz5?=
 =?us-ascii?Q?iIKar//b0xusBbOPu0mdg8Zx5OjQ/pGj2+qLocoSYQ49nxKVwtjbK/RsP9eT?=
 =?us-ascii?Q?RpFg8oYOH188PWJkD1eJq5cTNrld9ObVA25LhuM+cxj+5LpSJMRnv98uzJW6?=
 =?us-ascii?Q?bo8p/Swhf0+pN8I3eTbjJ1fyGvSe6YOY0wiaJrSxl8PYYvEfiYNCGU7pawwo?=
 =?us-ascii?Q?9teQYf/I2PjYUnxXOkc1gs/sa4N5NZMLuGbq8+hkqwZUGwpCFca81uOS6rT0?=
 =?us-ascii?Q?q9gNOEidBZx+DxRg9cHeVAxYWpnWJ2n1fnDXj4Y0AHLP2lGDoEAaDGfz522q?=
 =?us-ascii?Q?Xi6Hmv4amhJoPn4+hqKIwvpLCPddKy1mWdWlzE4tvdCS2xNTnogXm5frJosq?=
 =?us-ascii?Q?5l8V0kBc+opmFBvmEmyAN7zauZpy1HAmu9sUDbBU0ddN/3ug03/ll55hRAP9?=
 =?us-ascii?Q?nWP3ELw2jzBD05LlpPTkkkknAQ9JIq7rBVM2mFgNXkCjppM1215ExISy5MBH?=
 =?us-ascii?Q?0saeDTI2Ow=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96645693-18de-43b5-1df4-08df13418132
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 15:53:37.3269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wOOEBUdiMPdo94hOTsWhrIBDwu1Hv5iXG48S7cL29VtakwzKnY1EzNnlDRkstcRcwqi9nwUlVC04YX1RhggatA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8329
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3752FA0002
X-Stat-Signature: cymxszcypf5u3zm9qdurhkuhcmzxtnp6
X-HE-Tag: 1789487632-282370
X-HE-Meta: U2FsdGVkX1/+p+fargdE9gsCyjVEoA8p2Avc1POEf943SxpQSjQaJvKSJp5WGX28qWaMEjpu9RgtKPww7AKSiEF0W6DwWr6OVAX3c8W981J2Qksp+dmU+jZKYp+efJgkMFc/cyNpf65vZivFtmaebc41wx7gO9U+7r6U3u0k/u1t6hZTgBUcfmgjBxXS/EwJQMXpI5qYZkMfwhhbEWd7aMsnA5yOL8dG3cF5MlrwOInqnd/pf6uIrphOwtpZftDSdf3+XmxJsEdQMaxVA7WRzN9M4DuvQEsJGVLXNHI+hvMnrZnTXMgEtamQgmV04GvnK/iZhkaXnuuQfKydwZ4VkNsz4UZwpHD/31h+s0G1aMbum4y4UMdTzjhjOATJsu4ewGe7bddsHHQD1YbMUQlHQKotdOqaZtsDCEAn/BmvYnlo245uodhXoFtKa4Zz0D+z+JfqMia28VJqJlFtdy4zqJ0KWkS4wpUKC+mnxOxBKICYpY+lXTesTs57rQNFgVF0n2BTuhK4aHgdJWJcCloh6rnKHHVN4tfahj6AwhVFJX+CACbB4UHWJPC2xWErv/zChv10srdpkkAwNLUb5pQlgcfVmA35q0bFnzBj29kJFhzk9JszvN7ZCzomkRncM40VFSZ2YlJ69q/4KmPcF08ix04ehoS5ea8mL0istZ9ziNRw9YS6aZ3SdTxq3ECkSeAURCm2yaoGIPcOaiPPyAuqaJJF64z3h+ZeZTYT47NQhclJdxh9fHgytNa0HrXMVSbzD1rvNBvtiXuqEChE1SCVcGwR8TgqE5BrB4YexaPOjRrCNZ9x9QSR+wQEY46/1Fadxi8TxrCx3U8xDugevT+MUsFUg0WD/RK/tLt11TxRSGiYSCrdBF6EXfFiLvOrT5jPSgpVtHqJKhwXrlntKLvXr1tp299IV+QDuFasOXo+leID/VAhGLCRWc3Z3wHarMuxDT8IDxCRuVawKmery2A
 8ve39nq2
 8+9ZxEByuJTSkdy2kVY4vHukHuKbkZT+imVHEb40ydq4xaLSZXPCfXwpe4OE5e6YrQcssqDlCDCfXdCNJywBt+njwQXopq+w55Su6X2WgAj4rCowEdZLvp2yrrVrKSaR88PbRNsk/efFxmP7NlejZ1LKP+0Vm3e/lqtsH+hLfQBmc1CLzmEcCbLagbyai9j7eImD32JmjuaITf53ySAVW6/iFCDXOmdUmntpMfZv7pThEw30Q///+qJF7zzOp82ghbyRjbEfQvyQ+7oVGXJFxNU4zFmjOJh2wG1tPf/zFBPREUG/eYR6LY4O4zcvpm0hdyTFiUcfjWbdsOJy0nhqdz4ItHWhVowVhh9KwRbMskf57BhILv4+zvDhpATvS+JHW+CPb78GzdJGtttygQYUBO3j6YjBXFwE01Ukwl1/hJ3fim4E4tDBK3xXhSaEMUWjJJE3y3uA9QdUAPd+3uHzT1uei7jMGDN8ci2Mq4mVOSdUruBU26b5MPqwWdyD77V78RGTjf9027M/w6ReVRMsGxPBb82Gb3rGXEWqt0IxL74/sEzAtK3RyCG6BSNJMOXF0S12MTv5c5Xh71NNkmixyNCGm+W5mP9NIjQaA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 10:24:01AM +0100, David Laight wrote:
> On Mon, 14 Sep 2026 23:14:18 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 14 Sep 2026 23:03:18 -0400 Yury Norov <ynorov@nvidia.com> wrote:
> > 
> > > Declaration macros that statically initialize embedded locks require static
> > > storage when lockdep is enabled. Automatic objects must use runtime
> > > initialization so lockdep receives a persistent class key.
> > > 
> > > For automatic local objects, lockdep cannot use the lock address as a persistent
> > > class key and reports "INFO: trying to register non-static key" before disabling
> > > itself.  
> > 
> > So why haven't we been buried in reports about this warning coming out?

I have no answer. Maybe because lockdep isn't enabled by major distros...

The original report came from i386 randconfig. It looks like a combination
of some luck and a new code, probably attracting more robots attention.
 
> Are there any code changes outside of testing?

ams_pmu_set/get_register in patch #6 for example.

