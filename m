Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08C1C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 18:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4A76B007B; Wed, 30 Jul 2025 14:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CAE6B0088; Wed, 30 Jul 2025 14:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092AD6B0089; Wed, 30 Jul 2025 14:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0EB16B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:47:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C00CB80659
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:47:31 +0000 (UTC)
X-FDA: 83721814302.19.456CE83
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	by imf26.hostedemail.com (Postfix) with ESMTP id E5FAD140009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:47:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="iumC/WrB";
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.70 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753901249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfWs0WdG/CkJEjU7dY+8R1SG8EBhMQ2+RMEQs9kXTDc=;
	b=AWc67E2q2KUTZSqMSpAAux3lR+a/C1yQ5dDKTZD6NMFtHwI3/Vh/Y/DUCVS0U2B/EkRBCD
	P+xaDx3vEg6NbSXPrxouz29rmD6l8Qd3Jv+TyPore49AG6+5ee526owezx9kxMPx/8R+tG
	pZN28OyZdUtVr63MBC5bbYx421Y4Zvw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="iumC/WrB";
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.70 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753901249; a=rsa-sha256;
	cv=pass;
	b=MaC+yzVAuV4EoIl+AdPo7Hlw0i3Ej0T/E5xHKsFUVqTTZh+lYGD7BYOsmbXzwmgKTfn1/l
	rjHflx+R8u6/OVP/QC9NR9SdfbC61hsXupwO9W/2+A97PZSMvnWQ1Su9YvfHTwD6iEaC6x
	MkzXbT8H98DypNbizaPRN1TAzooPZxQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J4AIaPb88Mt/7xfQMbHh+kn+j4nGgEZq1D8mX60u0PKBs/7FmmjBgO4ca+2q1IuM7kx8ik/PHrSfN187R0Oa7aQVp5rkvs9voZgjagMzzl6eCTZzwTtPCv8HG4gHPD3PvJt566N+ntVicwlOR5MXzQwSG5LXo2AobDo6AIAn2CEPjxabt0uPaIoNFkQMhO9txHl1gEIIoQm71zyJcqRUlLfAIlJW6okkV35uQUTvEGtpufn4vSA9q9WWwdVYntC1tv12TBmf2SgTrvO4XRZeqofR4doP/7sjaXFfo3lw4RPLlOhEN2U3Qou6ZIzA2UvUQ0n9tLxxH0Culz2YlNlkKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfWs0WdG/CkJEjU7dY+8R1SG8EBhMQ2+RMEQs9kXTDc=;
 b=K7Y79QgTyw3PpbwgFW0JQXOIMXqvOdTlv2O+G2fNnW9lICCfv5ZcO+beNICilXDN0+lvCPw3TqUEVQpAEhHSFuj2tZGXPrDiJmZMiNrov7IDWwUt+M8b8uKHhmx7/LGNLlh/xkzCYlAQufC90wOcoNdN/+qQGHvOpetzPBOmotA1On5w7bI2ugBHzorvZl07zV20kJ0YnzEvfVIdyiF5HffIcaXzy4ZMwrfD9ZCsHYJyzmktQAw2nmjVkD42V/ElbvvB9IExXGcy3/CEAtpG5mOXKRL93PSPgx2W/djpuxn0lrltjZmSh94hDgVGHEqMnS87MAOO1trnBiLFyXQ/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfWs0WdG/CkJEjU7dY+8R1SG8EBhMQ2+RMEQs9kXTDc=;
 b=iumC/WrBOkW6c3uxabzOG3lrUeB7GOx0OXZjr3o7hDA+XaPgaUgoiAzjNLiSKL7dHuTmmAgqInJ29LfJQx2crlvU5sS/zStXTd1CKYk/8aGzbMf2OUWVAs1iJB4vk97AbXg+Tl02SHsqOjmlcTDfGpz9Y0ZJG/wtbuvuMeUYLkJzKj1oj3S43HIhQ5DX2uR4yIGPOxjmsd5CYG6RJoilGtK7hRd25h6ooPj93KRjd404eGkC7w27WS6OS6sgyt3iGhHkBvp3h++H5pz+NXFaLV10T3kUI/nzALmVsriZqUXHmJXo9sKVZs0bGLlYNSmrSdF00eE1xaPfNRNouRFpgw==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9482.namprd12.prod.outlook.com (2603:10b6:208:58d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 18:47:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8989.011; Wed, 30 Jul 2025
 18:47:25 +0000
Date: Wed, 30 Jul 2025 15:47:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] slab updates for 6.17
Message-ID: <20250730184724.GC89283@nvidia.com>
References: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz>
 <CAHk-=wg70=mihHE3_Te=t1Fmvrh22bcEs8bvH3tDEXZd6q+4_g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg70=mihHE3_Te=t1Fmvrh22bcEs8bvH3tDEXZd6q+4_g@mail.gmail.com>
X-ClientProxiedBy: YT4PR01CA0449.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL4PR12MB9482:EE_
X-MS-Office365-Filtering-Correlation-Id: d33aa70a-db81-4149-ae95-08ddcf9986c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lly4ZD2KJmCcrvvWpAh7VDwC5AukrZ3TREbwYRyUdgINnBdR1xrPUftWnMon?=
 =?us-ascii?Q?cXG+5P9hnRyB+eJy8ahyMXegfLMeZyZt0q4lqKEOtwjgJqVMw+L/m5WIS3ne?=
 =?us-ascii?Q?QhHbC7QBQ4MKaeN3Y9CG7EZOe9VhF9+HT405bT4GjZ0vR9uUUZI+I9RzMTB/?=
 =?us-ascii?Q?hDbVBHet7p2ZsAWtNUfeQODmBvE/kgeVo6H2HYxIv46s1n45NfEVwnFncpR+?=
 =?us-ascii?Q?Irrpgtlty8QmreRiJZ6GzGcZF1UXcYViwtAmbHkgowcPhS3ZIYdXsADrvaZB?=
 =?us-ascii?Q?9gO+0rRnQkxDl98GJwEVrxGBR++xWGMhAU9P/4z7Gjz1OE2qpsAZQxMu8ddv?=
 =?us-ascii?Q?nX0ZDMASzL0Jl8BIbyC6bZ9txZFX+MgXprd0bX4Jyp3nMrOG2YuXeuXxoTHC?=
 =?us-ascii?Q?Cm8uqXsn/dPgkqedMqpC0EsfoIqv7wcmzz+vcHqmswxoO8Wo7pOyIOQo9o3t?=
 =?us-ascii?Q?iiJajFvMV+QjjFx128EcZuGfGiKhsaC/lt/HQgW+8o4i2RhlyNPg0LDHHoZI?=
 =?us-ascii?Q?sju3H/gRiZ3l2QYV8N1WK9ahFspPi9Lc2aWJ16chZdELDIAlp9GaDaZG9+B5?=
 =?us-ascii?Q?HLYMJRGNEjMiNb3rThNtJDhZoglqpZBDM+vt5/vtDp5LXcknqkqYJxmdfR+q?=
 =?us-ascii?Q?7vvedwMVgwPzulx8mB+xHYrIOl1W1YH7ZWybMC8fJCwi/dcd0/2Cf0Gutr1n?=
 =?us-ascii?Q?NfWm3ZvdhoGIyYdMBPtZrzeEfMKNCiOZ01oZvEcutrHxru+gOjBCRyVqNOjh?=
 =?us-ascii?Q?aGF680pjtU7e0ZSbFoYhGckuczw90Oe6dM+5vVWAS2VJGHPZyDq2EyuyjtoO?=
 =?us-ascii?Q?96hL7DyHYhxx0vvh5f36pbKUTPhFraZq1Yd59g0RReVtiXowSlLrnjeXe6Hh?=
 =?us-ascii?Q?xHEcpaZEi7RPz78RG9jyf8m3q88zSBKpgN/HgWCducJHjqHl6EVhZ8fDZC20?=
 =?us-ascii?Q?3eVYSLPdkhZ1vWkXJqW8d/OzzpDHEdpdXM09NFtUHiVwRn3k+TDl3NIQsgKU?=
 =?us-ascii?Q?wLLfsK/CBg3hLlfY3sTUk+cOsz3fj1G0Td+vhYJEgYUUcosae0ZCWmLduuur?=
 =?us-ascii?Q?IUwFSHpFKzBlK7Rgc8TBa7EzVEZon3R6rzCwqfi4sC8Cu6pB5fTWkIj6QK0W?=
 =?us-ascii?Q?GVcc/BE0XrdNQ2yoi6eXGRqBoaRru4I1QtnGxJ5lmr/6cn7cR8+mI8WG7vhi?=
 =?us-ascii?Q?MtKp6d3CXSf7965Ykw0MVmQ4ObffsQgSra4+lRNtc57rVdclcYU0RgZyem64?=
 =?us-ascii?Q?eorr8Gfpz+vOBDjN8suM7BSobc31EWN7FllWIiMeiewPplUO8WoTyoN8RGs0?=
 =?us-ascii?Q?6NEtNwEYaEaOlb39x77dmkeWthx4upyvNaQ+19h9u51NwpP0kug+EFkYqLD6?=
 =?us-ascii?Q?TxKX1KXJylKQcoM0x1/zPl4q/iPv8WrSHfyTe2w/uMb71cBd131oNtlhH0iY?=
 =?us-ascii?Q?rx3svqbG/0c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?39cDwLI2UFH3OlmC9C90bSbu4rgu3H6C+4v4outqYph6WLZHmmSKIUdyd2nZ?=
 =?us-ascii?Q?b7jK19Wnodnzj8PmH0K+l1IleCKNiQ2ZMD1ZkRHgca7b70ijVymtqvyUfj9Z?=
 =?us-ascii?Q?Yi9Wj7/NGEqAwT68tf4IYwcHozYCMDvwBz1ECb7FDnw2R4P7A2NDq9BDvrP3?=
 =?us-ascii?Q?Hfhq8WUrEYRJLvRoPcOutjww0J4jg6hXsNMHEtclj+5M1d7oZmXy/9daA/js?=
 =?us-ascii?Q?QJlr7Yxf3oN5SVblCc4sPoRkVan5OHD2MZ4jc7qf742vsbv+PR7lMVBpri/2?=
 =?us-ascii?Q?F2zlt9C6QmV8hGN0fw2GA6UoJUtMpbQb+PSniFmuo0zsI37zxsRWRBaqp6Gp?=
 =?us-ascii?Q?7OfODb0xijHH7oRC26XXEvc/HpIXdW6clPieSNOZLjv1kPQcL5EXkBzcbFNj?=
 =?us-ascii?Q?CQ3+ktMk8XPjCv29ezvacxd1okjty2eBA1JTCltU60GG+kYcFL6KGu1saiPq?=
 =?us-ascii?Q?xZeaZJX4mPvJx0qtgK2hoV3qFdL4iMnWOUMAqTuNYnObrRr6PIAXy/iW4sC8?=
 =?us-ascii?Q?yF+hwbrXjhDTXOI7+7tsB/uo2+/nDok5/IokKSmwQhUKRR33Z3oKFxHEl4wB?=
 =?us-ascii?Q?D6qewZtEYuGoTZI1W+iMuRNARMQEbWwW/ILd1jdaL1q1tiGwNihnFfhuuJ5s?=
 =?us-ascii?Q?0gIpIGQiky40uDSfw6RFFMh/ioAbyI48WLbOtWpomilALxZrpNlZJ+9LDqUL?=
 =?us-ascii?Q?0Xrl6jjEzq1TrHked/bUpQWK/fjZ0ilLIATR+PeS9cVrkKKnaWPNIzpcWOk8?=
 =?us-ascii?Q?BJOM/5Ak0VzQfTmDG1OQazgpdri/sBPk0TyPbZPTZ3J4Z4s1MReozYRMHK2K?=
 =?us-ascii?Q?GBgGjyuhWjcvREauei5cUes150pO9JbOZjnkbdCMntaMMmwDbRk8F9yV8iwL?=
 =?us-ascii?Q?VDvNxty3LFUAUiW2dA5aJ4Kt3lZycsS335X+kPICLNkoggyEba/g1Q38+2a+?=
 =?us-ascii?Q?SiYdVQb+uCh7s2IEoPDFzUAyEMzDwFd9VeYpOqxTMBPdt58kVScZA1TcHo9H?=
 =?us-ascii?Q?6bFfiG6UGyx6z7820KFqFsOCziRxvqrxz9uAwe/OXh20tjV1zv2Lxcb8jHDc?=
 =?us-ascii?Q?AtBO8vh7aNhOL7IsHyrHt8tFXM+wIw8xXPjYVNEITc2arWl8xRjzRfZ7Kokh?=
 =?us-ascii?Q?YnpE8P8kLyhgclLo4lAXdu2uMYgY0Aolo6uHLwqpnRc2sbgbmHnv8vYu/rnK?=
 =?us-ascii?Q?zGjzw4oVFY5jGE0u1OGVV23meYBiiEVIPMJnczUPz0BmR+IeNhfziV4ubPhP?=
 =?us-ascii?Q?oQ7XDE1BC7mHvWPrPpj9EBFBrAUW65O/4p3JuFDQ5X9VTDyoH+omesGShEah?=
 =?us-ascii?Q?lG53VMxAoBUt/ivy7AWAqhyLXRLHEAgBAFIR2UA4NDnk3CWzZ8N24cnNAkrp?=
 =?us-ascii?Q?1M4evfTDWGz4x+f4H439PXFh5LtRJpoeVaCdOHK43ICRlX1YOatJ89YZdD5E?=
 =?us-ascii?Q?1invLGWXB8NnLMaMfBJg+CTQhbV9OZAVXtmzbfebKTfBvCXQJRGiIWnSzVzL?=
 =?us-ascii?Q?rGC05dq+oYAHwJgry56BQ3SYV7mjX58mYSwnB0lsYP4EuHKtnRjaGrNgEAvS?=
 =?us-ascii?Q?nQ6bAJ4M7+4taCeXNJI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d33aa70a-db81-4149-ae95-08ddcf9986c5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 18:47:25.6208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rT4Zq1EpxErPnEeVf89U5CHK3WBlBG9EnfHWDxDkxd3OqnZ+77F1q2YBM/MOXtSW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9482
X-Stat-Signature: zcnmu8bjh1ifrtc9zft11b5z1yck1t7r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E5FAD140009
X-Rspam-User: 
X-HE-Tag: 1753901248-517648
X-HE-Meta: U2FsdGVkX1+zb8WSt+CkSLtQvBCvcY8ep1JJ5QLAA1jb7gSAkyVuo8evvetqRjfMrcXCh5EGmc0qLk+GGK9U0/UuqpUyspfsO/F3uYi9lentou+8HezFGsXo2Lxqd2WpzK9ISw2BZbJkI42Hb9B1y+XZlaCvr0/UJrInh8+UZ+bScEeHx7lLj9/DGlEMxOwaZIbJAY5+jiZbpeWGhfCQXpDhvtiY6HLIfoyiC8IW+yd5ezx10IcAsGyI0oTGv00GF2A8axSIafNd/mETiy3ehZjoOlTDOfCv8igfwLxdhZcjzeBFoie5/Q/QFBtjYLKpoeFjXJfmAvBGmP17pZkr7DvDi0rr8OiJV43UymTuboSxVZKpgF/8JMCurxT8/LVRVF/L7gEwNJhdIjM71T9sGncHVf4pEORee8qOzqjUxTKJB4SL8KxrOMaArO6qhcEWfrZSz6oKPNciDgoyYJfnGY02Y6LMkbnEfh0QgzGVbyR72Goy3FoxaS72zOpkiBbUzpWqHSKzx3ot1CZDMDe/8QjkCp9l0HAyYLtoz4w8pvf+fA+2i6vhdR7SM++TdC1yZgzBMX8tYPIydJXPWGAxl5GMVLehqBIPr3ReudASW7AJSafpSkmEaU67MLKSLholabqNCC+4jCLxbPymy7dYAZ10sd31wmmvl9xDpzotVu2G+Dp9Keqik9xyn2MXsNHu2nHPo8A20kkappHi1ztbJOM+hMKHXZjoQa0NPqRiG2OjcF5j1erSqkwESWkssZWSQsMTwf/JBpmg+JcapIdpZ4LG8UMW98Toq5QtAY3hbS9D8kaITFH9YNnmYWFm1ArAeAC1VVuNjOXQZ0QQVR4PmfmxNwKBgSft4REaCMycDVtrHLSNkCzfsvBVhiwejbcmjQgdZTFyjKxRtQrpHEo5tm4CGVweW12sqoKNy4lblryB/SLZ7/UhiJGF3vti8tplJj6RYWJD9zF98dlqoLD
 8DZ1k5Jt
 nzDPlSWzzYBogzclvunsgFf0AkcWzlwFDz+77WoNoAYAH16uM8FLbz/F8wMGqJJLqYPCNJuVmG+5UzvGacg8VyXK9l9t2yC0rlKO4dRbbnfwXQ5q1ll+uDO5WVaASdoFEiA2/dqypxzDSJ9La7jTlBQVgX/Bj+qSduoDj4FH9K0RH3Vt8boazWbqqVQlvFpnVq7sGgCep14FxxbV78aC51j8UzCzfdcG7Gv8fMpSjdMrPZv6N1wbs/AGB+r4CU5ubSKKbKn8DJ1xsIdFB5f9l4z9Uw5DwDGd4l1RVvms3QV5T3G19uqki2w7SWTcM2o5GxNKUkiuDtPmYVdBQk+s6m/VjJTCJhPDDsx//9P3rPFq3l22Hd9lfOevjgW8V9SlS4yUOYROIv2VuLaWld7p/xRQdal/yObJ/ijZnnmA6hPjrIDPpuWZnsI0iIpFK09W4qvUuQuXfF1hHzs5TVHrMQoBk5uP7NpKPOVZZ+9UYZ42Gq2FQ+8Bq6l70+DuMPdurht3GkBkJ6FJjV+WSxYIuS5vHoS0PpC+w4wbjgjbJVNHOFnm23b1RL0wFT8PntwPftyLHrQDO6IFftX9Qo1PqCf/keQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 11:42:21AM -0700, Linus Torvalds wrote:
> On Mon, 28 Jul 2025 at 09:56, Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > We've hit a last-minute snag last week when lkp reported [1] the commit
> > "mm, slab: use frozen pages for large kmalloc" exposed a pre-existing bug
> > in siw_tcp_sendpages(). Pedro has been fixing it [2] so hopefully that will
> > result in a PR soon, which you can pull before this one - or perhaps take
> > the fix directly. If that gets stuck for some reason and taking the fix
> > later would be unacceptable, I can do another PR with my commit taken out.
> >
> > [1] https://lore.kernel.org/all/202507220801.50a7210-lkp@intel.com/
> > [2] https://lore.kernel.org/all/20250723104123.190518-1-pfalcato@suse.de/
> 
> Thanks for the heads up.
> 
> I've pulled this, although I don't see the rdma fix in the rdma tree
> (the pull for which is still pending in my inbox - I've merged a big
> chunk already, people have been very good about sending their pulls
> early - thanks)

It is not there, it was unclear in the emails what should happen and I
did not want to delay things due to your travel note.

> I'll take the fix directly in the worst case, but prefer for things to
> go through the normal subsystem maintainer if at all possible, and
> this one seems fairly straightforward.

I think it will be easiest for all if I send a one patch PR after you pick up
the main RDMA PR in the next few days. siw is not so critical that we
need to rush.

Thanks,
Jason

