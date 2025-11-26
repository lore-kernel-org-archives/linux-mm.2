Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5ADD1119B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F536B0027; Wed, 26 Nov 2025 16:08:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6E56B0028; Wed, 26 Nov 2025 16:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7AE6B0029; Wed, 26 Nov 2025 16:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDD866B0027
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:08:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D5FB1607C3
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:08:11 +0000 (UTC)
X-FDA: 84153995982.01.946DF0E
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013055.outbound.protection.outlook.com [40.93.201.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id E0463180012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:08:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jpjMDvH4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764191289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDQs/kh9JUtHJ022231hR86fq9BhgWuffoit9U+1T/0=;
	b=o2Zqq2r8H6EnKFUnb1ngqolFIlcUlKmOKjrAa8mVzKji8m9lDBbFzYxU/Jespy/PIAPb6i
	NxP3CXM7ctR1ACQeo81g7ZvwK11Gtfyf3O3Bqv2c0YJjAWteUoLZcHZ2AyFycpgozztloo
	57ZUl1YvWeNf18hatQvi0h0MZ+rEL3s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764191289; a=rsa-sha256;
	cv=pass;
	b=T6CyYbndWrpTL96NNQTBsDJMxMW73kXAiIdoU6YCxo6bWsKLRMBFoprIMQExAIr5rYbZy2
	ykyc8VyR7Kj4dNEGSVbUgZWAMgl2rhFljETJU2uA7M61hak9B8A61ATbeOFArdU21FOn0e
	tz/7TtXQFtRLd2QtXUWSJofpPaPPos4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jpjMDvH4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IZqjCfknnkQGRhzSdj7XUBh7grjmxSvojbcpfRiDu3XnQOeUx0C+Lk8QL4oG1gaspWHI8oR5aEiJaIuDnTsdHnQWkdwzLX6zHH2cNpiPXgTSMC07eTtDjXHAcNmJFQPVzibXfJnUQIUMBenZ6seP1UALDIWTUf8OKAE7HXottLXprNo+Bfke9XUboPXH76nBpWaPd0gEKsMf4KfuauoFeBL7wMDXIvGBFablAIS7bC/9yGBt/f8u/kd2JzZLJSZQJNv2QnqpUNoI2h/qjhoQfqH3QIoAkOh4SO8UB3kX0nsN/DaPUEzQL8gQhX7xp+GcHogHeulTIv8TZuFCEmw4Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDQs/kh9JUtHJ022231hR86fq9BhgWuffoit9U+1T/0=;
 b=yXuhVwyE3fqvIFF4T9GfvsKuwGh898zKWyvUYAqur7oKikImvapPlQG/9ltGjN/GRVU13JFUqMoPI+kMwycaXd6wAjoDq6ZvEdkug9YdE8vV9PzAby0d7GXiqUHlTIOPrnxxioywxY6KpgvyBB2kGmg91IJKayL9f1QozDdZ927Z2OZvyAtG2+o6G4zV42WmAopwS0e/XI1yrRkfHaG8wsw7r5ZHcnv3FltEBEbwr0ftEbSi41q6QhY4hgQls6QJypINIv9PlMw92NNyCX/h3G6av52u6guGVq2l9Vx2JtWBWSCcTAiaoHVGp5gPxcHIFaQmPNt2nuWYkoWOID4GtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDQs/kh9JUtHJ022231hR86fq9BhgWuffoit9U+1T/0=;
 b=jpjMDvH4aK5EzXtAd0nVAKWF+Lt0YqR+czdOr77scz3t7SbXGb4BAbvlm3FcJ6/Dquh3Hffsyo0HQJ45tM9oAe2OTUHr4XwmOpJ+GyYGaJqnMa2gkCLnwunDuf9aP18oX9WXW2wxYJkg5SvZSbsc72Qx+Quxi3qOKzTw3TZvXIG0TO9S5FYGzF3o0Fz6v/S95O1gqkakypvIHVz9OJZSGNI0aOp8sS4/2bLBeF1u3pKTa3n84/XhRTE/zmAqe6ZeWC6P71MztM4KeohcShkiqsbEy5oOTjUFi6+7ZHffGyATDn2AuXB8UNY//xiaywgJ1SjB3r755CMsXRe0k3r/eA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Wed, 26 Nov
 2025 21:06:29 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 21:06:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] mm/huge_memory: fix folio split stats counting
Date: Wed, 26 Nov 2025 16:06:18 -0500
Message-ID: <20251126210618.1971206-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126210618.1971206-1-ziy@nvidia.com>
References: <20251126210618.1971206-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:208:32f::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: e1bb37e5-739d-4cbe-7742-08de2d2fab18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DhNqHGZDhuYN7pUIH7fKbCPuPzVEr4cbV/BaRB69qyWMoFrGH9POoJ9DYtte?=
 =?us-ascii?Q?Cp/FKCMz/nAYeXzH3jf2DmruaVRCWuDorWlrYIHttJKUj9IPHhH1DuPpjTCO?=
 =?us-ascii?Q?NYOJ3vCDcqkeGit9PtjexH2B1K/vkVKejjEffMu+t5c0nlOJnJyPgBHBXqOX?=
 =?us-ascii?Q?Drr2YZ4KHp+pDi5AJjjg8oPYrIlBju9ItoRCx4Hpnf8Zv3HTNmSlOvBoUcYf?=
 =?us-ascii?Q?LY8aKXeLYfDEUiDn1Q8KMpaPpiPBe1NIu/AETTX0fNJ6Y1GDEuUFjTLg44yo?=
 =?us-ascii?Q?AMnkVbeC1T1rbUjUdh5nknhS3q6KNo+ncPsvfnjAV8jqE9OYcFR7HjlU5BoG?=
 =?us-ascii?Q?1fyzcv+mxjrcon6dcwAXTisD8S1XAPyHiy4fs44sTQ6vZwhb8Nt/Vtz5f9JF?=
 =?us-ascii?Q?/XjOLc417cFkOrQ7t+eWGygNpVyxTF+8UU+4AFCVLJp142WpIxTAXafGFg0H?=
 =?us-ascii?Q?VMLDM25FWThnX6DzjZJFN4FfYggjxeAG6QZYYN3BHEPpG0XqI49G9nyIud+v?=
 =?us-ascii?Q?5eO+rz6tgtQV8ax2s+wuffHt6yg8F247v2UrIKGs4qU5+KtTDsLkeeX49njT?=
 =?us-ascii?Q?VMqUa9eS/e8nl6dlIzqxS5bPFGqIFXwDYdNBS2XQeOURt4/y0XXy52Qo07KY?=
 =?us-ascii?Q?L2xafRXhKsN5bQoUKQNK5eSimlqoe4elGHrYNGCQnosjjrlR0svB+Ryl9vNz?=
 =?us-ascii?Q?RP7LVdKJ2xLrXZYCGa+RP2BiS0/WK+kwSNor7Kv+KIHufopdzO63VN51SDkx?=
 =?us-ascii?Q?yK8rmm/Lv7f3RndPg4Uq4CbVw4aHa77G5HaGEfTuzROd2zRbUPKXeIpn9lCb?=
 =?us-ascii?Q?SbcURWMiNSglFnl2cynAEOPb8ZXYhAq6ZsLJi2uTp+3HxFvAt9Nhi+6KPf83?=
 =?us-ascii?Q?nkDzafAR+6mi8HKaCdCCNnhKDGb5cDFLSAiqqIjIcF4XHzJx8+Tk47sqoILH?=
 =?us-ascii?Q?BUjQXvSi59skXczz0douGuXg+SL8GdThJTqj2JxndFqnrRI+J2YWXxpdGhG2?=
 =?us-ascii?Q?o06shswP2H2Uj2L3C2dH+afr2uhq4JEeFKZtQFm/H+/HqN0OFf55b5n7TS2r?=
 =?us-ascii?Q?YIDk+W0piF7Q9Ki4cWwIRZMwroGQVAGg5bbu5KLV9TbNiRTVwp/42gc8pR07?=
 =?us-ascii?Q?BfvzDJObFxb7Tcjaahn+cp9/JIsEU6M14XDkVGIzJ9P/os/ewvUo3uXxQrBg?=
 =?us-ascii?Q?EOFOcFPI4jQ2HZF7ip3SrDAwGLYF9AbTgUoFmwnYpKRgu5LN4t/DZYIC6Ruw?=
 =?us-ascii?Q?oc2qbhqsmZcHER5zihv2iA4JewdsetuPDSnIpwljYAZP2rSAWgTNqIW9DVIm?=
 =?us-ascii?Q?kyHkD77Magig3rPLyNHT5fo8IxPChHj0ZvHiF81dNZFBOHPZkPn4h2sfBLW2?=
 =?us-ascii?Q?hOjMqlfGgjKLDRFErG26g0YvyMYesqNhKvtX7v5EkV/wY2xXBQs02Dst+Q7y?=
 =?us-ascii?Q?dltQUqMO5W/yXHXO/PCSESJdhPLEiRat?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W/OzzRfSwOHYnIzlSuA9413D5El9qLEFXUQvjENH44YQ101eXrPDkFRrpPXU?=
 =?us-ascii?Q?U6A5y4ZfjdxOqZjNjbfG0SV8RbLp6uUBEEn/D2ZBLcYxpiREvNsffD4LIbM1?=
 =?us-ascii?Q?fbJAP+fm03H80bnzN+HruNNcj/TEeXweJiikgE0u2gAVpJzNjAAl3bPxI1XW?=
 =?us-ascii?Q?4kImXS86rXX5M3I5lt28O9Yf2lgqbDilTPRLjQ8gU4hstgGhPyvtry1x24ah?=
 =?us-ascii?Q?ifRVfn4er6An6YkffjAkdevQSymKjHanaV2cechJyNNVFn3T1Huai24Cezmw?=
 =?us-ascii?Q?dK9gesQ6SjqBlTQ08wmWKkdknNQ0VI2nu/ZxzIwtG4/y2jNlOLqHnNq649It?=
 =?us-ascii?Q?Lhwtdul0QdRh2NCoa7Tx/a/Xo1JR5WAj4Z+z3RNUR4NiPQVdyaPtwqD49Oh1?=
 =?us-ascii?Q?VUW9z5+PegSGHxEXiYYqlGRgVD5VMaTHKsFDnlYzqwY2z1WgRm80wo2UGSWv?=
 =?us-ascii?Q?bLm4LpL1ITzkaa7FgMQ0lX6X6k3wKqx4jwAMMUK/cY+wnXmE54v+1vxbVALL?=
 =?us-ascii?Q?/YOdzlPL5qJVIEgCMLL9sSnWF1ddy4ka7F2nj9+hJnZnVZ4IrctdaX72gxfT?=
 =?us-ascii?Q?Iy5mEtCaxRCcWXx5jN2r7WZmS5UjcswaaQPM4IQALeZ2s4Nd1XYAdr28YRYS?=
 =?us-ascii?Q?XBiE6Hp3HxCRcv+uyWXlmViZZ7sgbYpSyCTTSaoSEw97p+3halQkyPRr+ul2?=
 =?us-ascii?Q?jys0+793im94uUF0T23vZxmym63Kp1TV2B8LvUy0qIfzYciu4l+huKiNs3+2?=
 =?us-ascii?Q?5rqV7u5leFajv3fSqrx7oVvuk3c92BOqc5AWBCmmmS/j0ZCg6CmLmMAYbeDq?=
 =?us-ascii?Q?Rj4GrZDt6f7Pjbcha9ijfqCEwu7uYBrvSyUwUQtQxA9MsadhuG43ivUzDSHN?=
 =?us-ascii?Q?tZEOLAGKNXr6UMqwGJYD/xAX/MX3btp9CFUGbnnBi1i9CXZlpkM1ubHAdQ8Q?=
 =?us-ascii?Q?fQYUbKL//COqjynQ1re+X5mySkoUA9Lq9fJS4Jno4PXmG0ZuSxjO0JgW52co?=
 =?us-ascii?Q?WiD7MKvv90ig+nChsQKK8ovC5Su/TlqNrc1jETvaIE/Zs7UGwcC5fhCiyzzN?=
 =?us-ascii?Q?fS1aWs9irGv8IU5hnBshEGF16M6mPmzsyBm5wCNetDvQAuzaH+RlOzJWKSmH?=
 =?us-ascii?Q?IdwqlyhiDS5oLp77OBvzejHGodJhp+oKAzexCleUCLNeHVSi5VrR4QDx2tRp?=
 =?us-ascii?Q?wrdHRtfJPrxVmzZcI++LPNzsMD/pixhc9W5AsK9Ne9pgHn8jWeTUnMkzDZ0m?=
 =?us-ascii?Q?QJnPY47SyH1QwZoXk7umEFraxVaj09fTpSc9jDq+gAFESWSbqEKdI/1UeACi?=
 =?us-ascii?Q?/yYLQjAOzjIvIWCkHeFRKV2Ddg4Fw4FFnfXhxOV9r5xci9AX/6Bll2cl7Esj?=
 =?us-ascii?Q?/ZRvlRSwoDbAAi+cu9R0JMQ8C00C47+yypLQsZWZ9wuKUnI46hWyBXVT3uO5?=
 =?us-ascii?Q?1cBU0BVMyMG/dhdcuBh+uHNJwo4x0rIki45UC8/EVjCYVr495UeJP6e/d0cP?=
 =?us-ascii?Q?Of3KOsw1FPvNCsiuV5Sb0zxKLJsRKjuHnD/VomnAhtF35cgN3pnRvghv31g7?=
 =?us-ascii?Q?DdprgWWBljlirsAxB7S1xeqHtk/wjgs8+8ZZO/kK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1bb37e5-739d-4cbe-7742-08de2d2fab18
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 21:06:29.1438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eu2hRszKerf35ipSXbsh4zUUrv1Eth10qTuINt4qZIc91cbg6ZDS52zbSrp8uiHe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E0463180012
X-Stat-Signature: 7q1wrc6biuotmf1r3n98cqd78a71ynuo
X-HE-Tag: 1764191288-59808
X-HE-Meta: U2FsdGVkX198RIlfIopypJ2SI7bjhipB6gRScnmM5dTUzensSEtHZ8oeKksjOPVIUCkQlv81kETWIWm3XvnMVpeWdH8CM7wCjvGBk5oivYKXa12QUqX/K6A7Jb+XlxKbVk7U3VrseedAcJ3+tgEv+2HhDcYvgVAVtxVhYS1fXISTDAQDMhmAyuxSIQ6dqU5t7CDZxlanSAX+6QL7V7y0Qq+DQo2YKMSScjRBQcLOAXQGXf4vFesFWtyThyoW70ryPTCpwRZrS/UiKJ5Lff1drYEz74coi86cI5LLQP/2XkCVdeypggoYsxiFOr1kx0QGOMZfPe2xHHWpcJU1QCgEao3bwCKaDTPMe00grGRCRWMDQgW1bug4JrZ4zs/WZaSKMNWqa+OTE2U/JixerLyv16QOvkzJ1YMPNVxUpcwRJKqn6IhlIygMMViX81/sQdtB9Ie/p4d0PbK06Wjfqlp7gcNiiM2n8Kxqn/e2ge4vII4fWO28EYOAG/SyiS2HdtQft0hBBOn98ttFuQGi6XAEwqo5c69v2poCgJEIyXhKXWXE1G6QPFpuAWH5omD3k/fEUBC7kSqqeqzlqZUO+Iq23FSqF9/bclVZy89IQjAt2G0B06c36rPwoVrSMOWnW8cUkzh+67Cl4EfftWIO/mKsN/dlzCbXae0IO97CKBY5igINvgUQGkzCl6+6d5Q/p9SjYO3gIJyGWkQfX5XaIFfxlUgOIxlkbLyMCKSNT1hRvrlL89Ze20etBbGjUNrBpgW8LApQ8A46tGACfbeRe5cQ20/URPT+aPZ8rkkuRyw8T70vIinizswzLo4jBuK3fRwLjq8HpGDXW1TQ/lK4Ih97miYEuu3XS15qGMcOSbJC1xPqQ0ZxVjsqXEiAAQVJSHCPcHHku4pAjDdPHSf198GgiO9hFlcTHaaVudAvBirRPRaoY1JnYTIWoMe0irpt52bvfosP+KyXDA17YjMJA2y
 XIGYtP0B
 1BgCxgKPnd587p0uLqsc08slKvasByFp3uQ9+hLF4RqY79S/YCKQQXFIhRoDOep7vJ8lcrXCMEQiYad4tGomJ9qwcAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "return <error code>" statements for error checks at the beginning of
__folio_split() skip necessary count_vm_event() and count_mthp_stat() at
the end of the function. Fix these by replacing them with
"ret = <error code>; goto out;".

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/huge_memory.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1a3273491cc5..8db0d81fca40 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3942,16 +3942,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
-	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
-		return -EINVAL;
+	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (new_order >= old_order)
-		return -EINVAL;
+	if (new_order >= old_order) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
-		return ret;
+		goto out;
 	}
 
 	if (is_anon) {
-- 
2.51.0


