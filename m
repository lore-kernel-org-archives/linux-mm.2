Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B6CBEA3F3D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 22:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406B26B0088; Tue, 10 Feb 2026 17:40:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B42C6B0089; Tue, 10 Feb 2026 17:40:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295F46B008A; Tue, 10 Feb 2026 17:40:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12C2F6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:40:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 916DA160115
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:40:33 +0000 (UTC)
X-FDA: 84430017546.09.EAF1F6B
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012027.outbound.protection.outlook.com [40.107.209.27])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45831180011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:40:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=Ppk6Jpl0;
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.27 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770763230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N19KYutFVgIWS0lNAlsm0wEfEOD0+9t6Z3pvclXZYAg=;
	b=nDeHTfzNwD+Dnr6FKfkJf6JY3V7v7g4kgJjdRPKgxOdqUjzg6SQT1EJnpN4gxjNyXw510Q
	HiyXviSytyo35ZF2jiFhtm2fXYwihROidpUzz2WELl2ikJ2BzalRMAkHDciqDe83gKeLnV
	eqXECPLdEArX26LGdT1FGFqPivxvSpU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=Ppk6Jpl0;
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.27 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770763230; a=rsa-sha256;
	cv=fail;
	b=XpGxaLXqUzkhbMztveXZ4GLsPlnuUK9MkfKlIPMd6QmMJ+N4ixBZhJed/j7nWL+kTQhRPl
	InymfA6OHbPfhlAWg0Ef14p+MYA0NivsP9GgBtS3R0yT7jYvdWeI0PyKZXGJ4KkYkNN/kc
	3OinShUaYDtKZngqyolqbfGtm3IPhiU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wGmYd657mZlfn3jtMZetkTSA3axwJLZlmwbnifsMzrBWc4THyZKlbFpdT+82VLol6LWqnTYja4V6Imb3gZ7jz8uKC4ful7ZXsQ0Vn24mB1GJmA8HTBlDhcbiW17qffT+n/DuyDAeezeeo0IfaftFrzBIL0zCzJrld5Zt1Uxrvn0eB4k1o51r2wyYArLZc9jfeLJa30UiswOR4l5T12LWnyPNiKKtsq/HW2lE2Q9lcWXSnfbkMqtUrr3bJL1dKda/Gwlg9impAX7nI/o9ElWDCNaEoG2y0XmtmfwweHfev8SqzKZJoTh0hN5Ko+JODmmbvum8Thw+3GZUmzIDMonkFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59YptWQs9gnklrT62/Tkv/m2fXkge9FLxOx+ruc207U=;
 b=TcDcd94ukQz/JFkIyNlW8u762bv94Rl/guXEnGVCZwRJlmKZfMvOUaOPSFLLQzHkN3tPbkw5hZsJ8o6eZCtFPQ36JC+vrgRqJxliDEoXP8gsi5CC6tJeYr3S72clSCJg46hJe6blkarartOrEiTTrtD/HknNsY6jITyvgGTFk6YSLBtmKWBezZgjFSHo/X5gfRQqoiwzg6A6mNzi/Ok3LXOiIrA7+3TlfuGOH+BlKd82xqjCNuiEvJsLzoMEsGfA3cDW+kL42DCOJs0dtW/F+tjfaE0m2CBLjt82ouM6zHHuml9COfwKOMyreD/u4S0+ILlvgvG24MeGVV4cY5H+lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59YptWQs9gnklrT62/Tkv/m2fXkge9FLxOx+ruc207U=;
 b=Ppk6Jpl0CBPZgFVac/wuB3FlCtOEs2CMNWkAWj+F/DsnZhxTh6LXM6iYEgjbNgsGx5ql5h+zonkc7JucJ76cEoky5z+mzBBs7shejT/3Z4aaEKlVQuWN9eyRSjCeKeZlvxQUYk3ufxPfiJUJskrF0mi6e30SZfAnBstvTIlsBmSx8FEuT/r8m4W3BcfBavFYj4MxmF6pl1qsQJUYl9XfpNC7ta0J/kD/fDmfTzOkMQjqmICg8RRJoO2oTL+eydsqQl2J5q5sgnMgtoXFnus+z/xBsGvSAT6KbR3elWXNKvqpJYLnjkWeYm3nX9RHFpTaYzLN2xJ5FSV9DctMWoxRUQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MN6PR12MB8568.namprd12.prod.outlook.com (2603:10b6:208:471::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Tue, 10 Feb
 2026 22:40:21 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9611.006; Tue, 10 Feb 2026
 22:40:21 +0000
Date: Wed, 11 Feb 2026 09:40:16 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v5] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <7juf5mznp2fzy6tt2rs7dsjqdyfglzjiwkavoaezq7766csdnd@irbgevj6jesk>
References: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
X-ClientProxiedBy: SY5PR01CA0081.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::15) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MN6PR12MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: 0773d1ef-8a27-440b-cf3d-08de68f55f57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?3GSzCy7J7Z3Ogo6RxiYFVfEriZcVl6Sh5dj1Z1hXrYowHriwMms+sLH8/c?=
 =?iso-8859-1?Q?9a8nQHJ3DcrfvrJ12dli+mFzLHgwegxoioyyj7orcsExuNNlsPietLW8mw?=
 =?iso-8859-1?Q?6BqXmTHX59cCYeLPUqvT5z2Ssr6KglExm9MUNIbfjjr/yIHHsY9/MKZKA+?=
 =?iso-8859-1?Q?qQIsVn5UBoGkfDqk79/YOsogWDfT7ermH63i33nPNOxfH2baMTw7Z1uxQz?=
 =?iso-8859-1?Q?QhX/D+2FuAeLVRT7F6iwsSzbzz9+D8np7oshgq0R2qmk97TKvun5XW00vt?=
 =?iso-8859-1?Q?SAVAiI5BmzDg7lXqZhsKkVzFTjb7YC31jJHOeAJlgJVOxwL2gKcEoeSRa7?=
 =?iso-8859-1?Q?wFdD3Yf1mXDedsUnVKCUf5hSvnU4jWbfGbl4WRT9b9okGUe5euxFVoVXZw?=
 =?iso-8859-1?Q?Ab7bCimCgp+0catXsZRhZSmWKT0cXtubnuT0gD6LHeeRF8L5qSeY8ogt0T?=
 =?iso-8859-1?Q?J+A3F97blyMREswyAO9KkDnxPZ2l0H1N1tc0w3A0WMviBF5AIDINSZyZCa?=
 =?iso-8859-1?Q?ysWTDB6t9wXjapt2kV5K/THN2gqoffhagLY+29T+/9vmKj1WNg7AOlS5mZ?=
 =?iso-8859-1?Q?CBdlnrBtwE7UqBOORAYE4wOjFfxOeV5CVQwW47fUH1DMtm19ptNvXPo9H9?=
 =?iso-8859-1?Q?zwx6/2fwd9TeKR3Vqcszebh/+qVQh+IQTRrkCAXPC7rERNWPEtOgcQhgOv?=
 =?iso-8859-1?Q?Fz9wDM+xt3feITY8y1I1B3UnZrPVdsR9jE/k0sNO5+tkKp6KK4gDzNNKD+?=
 =?iso-8859-1?Q?RcpxzcXbtuXh9Bo975FHRQfCoIx/LnlMlVWH1yxMBFLoqDdRSGeMKaOK9V?=
 =?iso-8859-1?Q?/OsgATMxa9V28FT0nyFUikxsA+ee4yX/Xgc8fbSacHLGpzOewg1Ax4ZYbR?=
 =?iso-8859-1?Q?koYHkcVMksUDzF6z9gkEGzYUFpapmn1sogoVItlPqiaxHY/DKfe4yzRNPk?=
 =?iso-8859-1?Q?GF2NlUesON50rTwyYcoKFQGrWw3bYI3UTNyvLxMQiYqJqRa12qgooZDR2C?=
 =?iso-8859-1?Q?43wr2W5jWNOnz0+b+LudXhXGzl0Uo6DLMtrIDkDYwe4wur7Mb857mgomfY?=
 =?iso-8859-1?Q?DTF7IsAwvXkNlD/CEQzc9uCKeQ//lC+21RW+7s8j+WOrOG4Di0bZnHhqZq?=
 =?iso-8859-1?Q?56yy+QoR/od0dvqhTqWMaMwuJZaYY2xk/uA3PxvfWDol6wJQ2V8XDTl9uF?=
 =?iso-8859-1?Q?S0iJ2L7FwwGWvEmAXQ8uO5haitNU21tOeCvie8jTFjrOa0iExHko7XcfHn?=
 =?iso-8859-1?Q?FSdWm+IYfflpEafxAgqzPyCVwybnnvBnUv4nbz3Elvy+GubxNpWEeNAnoc?=
 =?iso-8859-1?Q?GQb3GpKpiyP3luSwVEeP+O3vdKZxgC3loL1F32dLn1SW/QYl9DlGf+c/gp?=
 =?iso-8859-1?Q?0uJdLLN3HA3rrUCEoDCC5WuaogNjiqGi7mA9YYPCYntBMm38FtqYe/Fwtq?=
 =?iso-8859-1?Q?FdL9Y1Puq1zsx+SXT0A75lBuCAC/3Qq9PaffNX8CWJpop83T+WiV1WH9Ss?=
 =?iso-8859-1?Q?qUCG0QCsiCYO7SSvMlA6//rt/Nn+6OV5LdyFMfJO1TESFOIu0r6xjBxAYm?=
 =?iso-8859-1?Q?kTy3nNUZzywcH6wTJI0EapoNcVlD70KPbzV1WkoxJ4U4GFAuwGdB1oqvEH?=
 =?iso-8859-1?Q?cyDdEedUYW1L4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?AzNKFXDKl2hb7EGdA5kkkn9MYdTX6PlIiaW3Yy4sDL6dxiW/2GE7YaTthC?=
 =?iso-8859-1?Q?RvxzN8b8swSieWobT9p7AVh/gbATHds838j8BWd+iBI/u+Ox6o5WFh3S5r?=
 =?iso-8859-1?Q?zLdhKwSkLUkWUl18CMNecvXhlkCzLlVKxUEpwAbiGkC774PAQpGPbJ96Nb?=
 =?iso-8859-1?Q?jOWw4QiYINxsAHdbDJCz8yL9a/y8tXLz+d9f2qqmcA0mzLsK+1/rHEL+rL?=
 =?iso-8859-1?Q?THi6n0hddaj7+jgBSYDGOSQ7qYK1v4KBP0KNHbY1LiXS4n+qQZpJ8H4vv8?=
 =?iso-8859-1?Q?/l+4L+TEHKlJaJiNnOF/hhReRL7xh/r38h6takMYSgaSaqoG8OgGGhSXJc?=
 =?iso-8859-1?Q?y2kGhCloidoyRgdmiyFAIbsCixg91CJCRTqEEvBSmv5RbpLD130lopKSos?=
 =?iso-8859-1?Q?CrxtJlIFQv0q203AdCZkmUdRqD5S+ja4h4XXj2EFvw8hZz1xOeGRX0fd6g?=
 =?iso-8859-1?Q?Yb4t2QDhQVCjOtPCKgm6MiXNpskYl4D/fRYCx1eVI2TIDVdwbY8dVqqEJH?=
 =?iso-8859-1?Q?bq5+sHXQLiUzmSPxv84fxnKEYylB/77VcWO/H2cXLvnh0g3HyXJmSVKCNX?=
 =?iso-8859-1?Q?AD0C6Qu/xGAIbjls5mpBg5sz3iCQTmYvWQmZWGkPYN6Mc6wIgHmk7AznMG?=
 =?iso-8859-1?Q?EWryGN0xA3MUcG2doGQUQiQ5cscp6SrN84Q0CEo65PyQkyjMyNC0oaExxN?=
 =?iso-8859-1?Q?Uxa6gksufxUw2sBdFBgeQwwQJ7WVS2RzBZ+jvPHeghWbeS6v9RfhBHyWlV?=
 =?iso-8859-1?Q?WO0P+hF1dtTXhPjnc9tuW9p9/qWobH0FxnfJH9o+RfkbCXYW/4gXu4NQxE?=
 =?iso-8859-1?Q?Gsf5iFXxeoshnve+iBfJMjb1pjTAgotM+9CbbhEibcW6OzrpRTngULDHLH?=
 =?iso-8859-1?Q?IYpTVo/xBNvVaT6EEZdSxxYHz5w1eHKYqO39FeS3ZXH1APPC0MzTSnENBv?=
 =?iso-8859-1?Q?48yr/0UOHTxhRv++iBn1bzsQV1OVLExF/zivOWG6QEZ+ZkS7DEY4nPkMcK?=
 =?iso-8859-1?Q?1GA+3o2tgTAw0IBn0CYOxNY7wljk93K9u3t5k5Ko5DqUQPCorR4a/8xG+Z?=
 =?iso-8859-1?Q?BpDMFOTMvA+jGsY4iP7H8Kkr8mqYdiSVZA58R+2habth4/Iv0Jr+r7YFfT?=
 =?iso-8859-1?Q?IFyt5XTt7nPz3ot6dyD9IacekC3jx7ZUtoctLvyYQgu8x/clZpdAc9GgFj?=
 =?iso-8859-1?Q?NFkSuRwyextFK8P/picF38SBDK3MmqsZwBrSTiCGvHyrTm/gBMXjogm666?=
 =?iso-8859-1?Q?zK/uoMWfi2uDTccCHdtu7NOwnH7MAVEL2NNCfz1+vaNOGhCZq60+P//F7/?=
 =?iso-8859-1?Q?URWRW6UVKAd83bnDYSqR6YGJ9aqFLius7eT4M+QqKGlIvKBRy2jBhayqjl?=
 =?iso-8859-1?Q?9PEmZKN5srHTGJn+7ByZ+Rryby7ouU5jU52VbHIahJHlbLsn9MHg9VVuFi?=
 =?iso-8859-1?Q?M99/itwHaIoOvr4tJysh3FFun+aOiAqJ2tc/QToDQrGA31XHzMmMTBbyJg?=
 =?iso-8859-1?Q?Gt81KuD7nMu/cndt2uXjc56XXNJwK3QHxquVLwthvm0pHwbVtiGe0/lmFO?=
 =?iso-8859-1?Q?WSUepLhTz/OyIz+1ktUNTdwyalQ2jm9j7LZe6iMgFryFg2mUJCxptDzfzP?=
 =?iso-8859-1?Q?82CVGnIzPU3iQsCjpeIAKvMq3zabP8y0Q5OivFZoqACKTREFeNn5SQkslV?=
 =?iso-8859-1?Q?NXrIf8Yifga68lESq6M3Ak4Y1ruiySIXtXCOW8d0KPjh8yOX3wgMSxZYYw?=
 =?iso-8859-1?Q?suI/phv04cusQuTStOxYTf1iWm7QDIuEqtXQqQGZEEIO0KgS7iXohrBqYf?=
 =?iso-8859-1?Q?oFKBxO3XyQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0773d1ef-8a27-440b-cf3d-08de68f55f57
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 22:40:21.0938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HEOfAOdKD5mtvJZ+P2x1yFjmZhkXpOOsxU/KKqFjNuOLzPOS4G20/vcVka7CT+UiPpKcG6OxafGODxBiFpMnCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8568
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 45831180011
X-Stat-Signature: g1uxdpps4mzwqksh6h1hbjdnmbx65jmq
X-Rspam-User: 
X-HE-Tag: 1770763230-132535
X-HE-Meta: U2FsdGVkX19VEIy7ivjbLGMX7xGCNXcbobYrp+Q2/Zw/lqD/86WlaLXKd951JGJj5riC8Ya94h9NamjQSNFgpFGgBsEShK3DsI5bys00RbK2LwNAM/mUT3Bg6ZsjGb2r5Bd4Nxej+J22z0DcA3jj20/QviI4pXg7dM8hiE/mdaT1CkU4JmTvWe+NwIPvJSC8gJLhaumkudFzcSBWvuJ1DlPzOqHZw83UfD3viwVaZQe7J26elpSSoLndhxnSynLphFEtbK36+W2ND+AfAGUpMffcZav76ayUZTtlHBeMP1HMi+RPHc4NxX4auVUHyXi09n2lO5iw0VLE8PQxZrBxCxKnrlj5wDvW7jqXVqlSTw5H9mFGSQ7bNMPP1C5FJ3BJ2ETxRx4j5cXt3Bh3qCQdE0+W+/lKykOUKEFrUmBp8/bWlM/PzSjbrCXQ5n1szXxflpDtfWcpBy7sA0ff61tYtNQiZno1auvhOwut2jyMVAH6GqKlhp4V++n5HfjFPSRhNtcC92sTiwqm+8PnZWMhvDjCrQMYHtk4MaZUh74K88htsuTy1zpbbGzqBERW2Vl8Y7QivL5Revnda36G5KlQ22YV59DGA8ab9/Ki8JIecAA6Tyq1UVo9ku+g5+Mjtwfwr0EccIpybWsjwJO8fnHo1iTNaHovJvqGC19C6AXB42tPFYIh3iQ2nrdKQVgDvfw/oHz389POrnn+eZ8H7QBHU/yC61N8ckyy52YjU6l+4wgLhOjWgZAbYm9z6keb/8tnyrexVj7KsQJdTfIgZ2riY8jPhJ4uvtdw8lS1sTKgqcT94ZxBLHxfT4bhIOJ5u5VK5WaM2YmJNRiRTKk0rqWFY4U/AJTzOUspJJBsPP7znNEf2iwI89P4RpgjoEPQrJ/m3y98q0zOEPmbrJxGXS1Zqs/9CN3FKnKDkljUQdeW3dBAXnzLiu4x9QWQS1bSsBoVkijF2yz0kB1R6lEdr2g
 mU/szlrP
 tW0wbzZwWa6b2HYZmv6LQsBJSrp+kf1gwDlgJz137gQ4Fj8XeiAvq+fejqULHiUWJCaNp93/DmCkwwgrEidsNfiFmDllPaZjJiLzYxXG0WfhyShOzHbjWos5DMFCo1QulEOZzDatBxpLfrcN48SmIa1lU5+YeyXfV7yVnsV7Cj+g0cOSblh/y8G8sSIU5obRZYhWAGwRsTbc/ztBsWqX0V82rEZdmNJlQsAQDrhqV0qvcPkQxqvhlPyhcn8m72ZwkPFHE8I0wBidpIIEzki+OVg6qOsexsFV5IkOqC4HIpYZschaZg9OoKxy6xoWV7PrYFdF4CvxzKnDNGMLAABPK/MR5Jpj8WUIEQFQkbduAA1cLzHIax5LUgox0MnItv5N+Unz7Up9rPsP3l0xVxUqibqUH8Me4hQ6yQ4cPCdxbQvU0Aw3J3MHKGNGNh8rlY9ypwivg5wqYIY6a5jhG4WX71fyl/a8u0phhNb9hI6vMMmvZCLMPLpoLFW9QUuzrM6OhA9RzNAoH50Pf+ec7uAstQ0nDkiEsJBjrPa14hqUTKJ6eSOYWNnK7XMNOyb0S1NidrxtQIXjZ/GYUtUYYJbxd4r3e1/Wt5Q2yaurQh9+iZ6cEJ3IDM2yUypWrsDzloPqLFORVPtVwier2x5f1s6gFagTE4vl5TGRmtlMrJ5ugjb1ku6s36Y09kPeKcpWYwXYGCnTEStJGOVpf98XrQBLcHbl+hf3TZEe7IogGREVlwgJ5dwjHIx/l+Y8iTJ5q60mKLHKsnmCqyMrfeHW9GWjRh5+6NkjgfOOIvXTWmmpHy0mBeI8Tusxr51J891uaJWgdzv5F43BWoASsyEKClkTQzuE/Q/b9CAhMfsQo9jaLQvO0fWoF/m9FGkNUv2Jk4ddTjCKwadGkDHyrmWE5kgp+UpyCS/SG0XEFYKEX3qr5Fe1kPZqWczp3M1Gk0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-10 at 22:56 +1100, Thomas Hellström <thomas.hellstrom@linux.intel.com> wrote...
> If hmm_range_fault() fails a folio_trylock() in do_swap_page,
> trying to acquire the lock of a device-private folio for migration,
> to ram, the function will spin until it succeeds grabbing the lock.
> 
> However, if the process holding the lock is depending on a work
> item to be completed, which is scheduled on the same CPU as the
> spinning hmm_range_fault(), that work item might be starved and
> we end up in a livelock / starvation situation which is never
> resolved.
> 
> This can happen, for example if the process holding the
> device-private folio lock is stuck in
>    migrate_device_unmap()->lru_add_drain_all()
> sinc lru_add_drain_all() requires a short work-item
> to be run on all online cpus to complete.
> 
> A prerequisite for this to happen is:
> a) Both zone device and system memory folios are considered in
>    migrate_device_unmap(), so that there is a reason to call
>    lru_add_drain_all() for a system memory folio while a
>    folio lock is held on a zone device folio.
> b) The zone device folio has an initial mapcount > 1 which causes
>    at least one migration PTE entry insertion to be deferred to
>    try_to_migrate(), which can happen after the call to
>    lru_add_drain_all().
> c) No or voluntary only preemption.
> 
> This all seems pretty unlikely to happen, but indeed is hit by
> the "xe_exec_system_allocator" igt test.
> 
> Resolve this by waiting for the folio to be unlocked if the
> folio_trylock() fails in do_swap_page().
> 
> Rename migration_entry_wait_on_locked() to
> softleaf_entry_wait_unlock() and update its documentation to
> indicate the new use-case.
> 
> Future code improvements might consider moving
> the lru_add_drain_all() call in migrate_device_unmap() to be
> called *after* all pages have migration entries inserted.
> That would eliminate also b) above.
> 
> v2:
> - Instead of a cond_resched() in hmm_range_fault(),
>   eliminate the problem by waiting for the folio to be unlocked
>   in do_swap_page() (Alistair Popple, Andrew Morton)
> v3:
> - Add a stub migration_entry_wait_on_locked() for the
>   !CONFIG_MIGRATION case. (Kernel Test Robot)
> v4:
> - Rename migrate_entry_wait_on_locked() to
>   softleaf_entry_wait_on_locked() and update docs (Alistair Popple)
> v5:
> - Add a WARN_ON_ONCE() for the !CONFIG_MIGRATION
>   version of softleaf_entry_wait_on_locked().

Thanks!

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> - Modify wording around function names in the commit message
>   (Andrew Morton)
> 
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in do_swap_page")
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: <dri-devel@lists.freedesktop.org>
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v6.15+
> Reviewed-by: John Hubbard <jhubbard@nvidia.com> #v3
> ---
>  include/linux/migrate.h | 10 +++++++++-
>  mm/filemap.c            | 15 ++++++++++-----
>  mm/memory.c             |  3 ++-
>  mm/migrate.c            |  8 ++++----
>  mm/migrate_device.c     |  2 +-
>  5 files changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 26ca00c325d9..d5af2b7f577b 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -65,7 +65,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list);
>  
>  int migrate_huge_page_move_mapping(struct address_space *mapping,
>  		struct folio *dst, struct folio *src);
> -void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
> +void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
>  		__releases(ptl);
>  void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
>  int folio_migrate_mapping(struct address_space *mapping,
> @@ -97,6 +97,14 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
>  	return -ENOSYS;
>  }
>  
> +static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
> +	__releases(ptl)
> +{
> +	WARN_ON_ONCE(1);
> +
> +	spin_unlock(ptl);
> +}
> +
>  #endif /* CONFIG_MIGRATION */
>  
>  #ifdef CONFIG_NUMA_BALANCING
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ebd75684cb0a..d98e4883f13d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1379,14 +1379,16 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
>  
>  #ifdef CONFIG_MIGRATION
>  /**
> - * migration_entry_wait_on_locked - Wait for a migration entry to be removed
> - * @entry: migration swap entry.
> + * softleaf_entry_wait_on_locked - Wait for a migration entry or
> + * device_private entry to be removed.
> + * @entry: migration or device_private swap entry.
>   * @ptl: already locked ptl. This function will drop the lock.
>   *
> - * Wait for a migration entry referencing the given page to be removed. This is
> + * Wait for a migration entry referencing the given page, or device_private
> + * entry referencing a dvice_private page to be unlocked. This is
>   * equivalent to folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE) except
>   * this can be called without taking a reference on the page. Instead this
> - * should be called while holding the ptl for the migration entry referencing
> + * should be called while holding the ptl for @entry referencing
>   * the page.
>   *
>   * Returns after unlocking the ptl.
> @@ -1394,7 +1396,7 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
>   * This follows the same logic as folio_wait_bit_common() so see the comments
>   * there.
>   */
> -void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
> +void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
>  	__releases(ptl)
>  {
>  	struct wait_page_queue wait_page;
> @@ -1428,6 +1430,9 @@ void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
>  	 * If a migration entry exists for the page the migration path must hold
>  	 * a valid reference to the page, and it must take the ptl to remove the
>  	 * migration entry. So the page is valid until the ptl is dropped.
> +	 * Similarly any path attempting to drop the last reference to a
> +	 * device-private page needs to grab the ptl to remove the device-private
> +	 * entry.
>  	 */
>  	spin_unlock(ptl);
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a4..20172476a57f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  				unlock_page(vmf->page);
>  				put_page(vmf->page);
>  			} else {
> -				pte_unmap_unlock(vmf->pte, vmf->ptl);
> +				pte_unmap(vmf->pte);
> +				softleaf_entry_wait_on_locked(entry, vmf->ptl);
>  			}
>  		} else if (softleaf_is_hwpoison(entry)) {
>  			ret = VM_FAULT_HWPOISON;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 4688b9e38cd2..cf6449b4202e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -499,7 +499,7 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
>  	if (!softleaf_is_migration(entry))
>  		goto out;
>  
> -	migration_entry_wait_on_locked(entry, ptl);
> +	softleaf_entry_wait_on_locked(entry, ptl);
>  	return;
>  out:
>  	spin_unlock(ptl);
> @@ -531,10 +531,10 @@ void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr, p
>  		 * If migration entry existed, safe to release vma lock
>  		 * here because the pgtable page won't be freed without the
>  		 * pgtable lock released.  See comment right above pgtable
> -		 * lock release in migration_entry_wait_on_locked().
> +		 * lock release in softleaf_entry_wait_on_locked().
>  		 */
>  		hugetlb_vma_unlock_read(vma);
> -		migration_entry_wait_on_locked(entry, ptl);
> +		softleaf_entry_wait_on_locked(entry, ptl);
>  		return;
>  	}
>  
> @@ -552,7 +552,7 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
>  	ptl = pmd_lock(mm, pmd);
>  	if (!pmd_is_migration_entry(*pmd))
>  		goto unlock;
> -	migration_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
> +	softleaf_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
>  	return;
>  unlock:
>  	spin_unlock(ptl);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..deab89fd4541 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  		}
>  
>  		if (softleaf_is_migration(entry)) {
> -			migration_entry_wait_on_locked(entry, ptl);
> +			softleaf_entry_wait_on_locked(entry, ptl);
>  			spin_unlock(ptl);
>  			return -EAGAIN;
>  		}
> -- 
> 2.52.0
> 
> 

