Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47626606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mzrshj5O
Received: by kanga.kvack.org (Postfix)
	id 65D0C6B0658; Thu, 12 Nov 2026 22:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E896B0659; Thu, 12 Nov 2026 22:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523BD6B065A; Thu, 12 Nov 2026 22:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22B726B0658
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:13:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC76DC01AA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:13:34 +0000 (UTC)
X-FDA: 85428625548.15.4C23A6A
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012071.outbound.protection.outlook.com [40.93.195.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7192140005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:13:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mzrshj5O;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794539612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7/SN4QvThEVdblR4JGz5hKTqBsg5GPf1btsPRu4znM=;
	b=IUK+qmqC5YcZVw24n5Q3EJDRv91cP3ZzK6SkfCw56p+s5+JPFaQiTw5wvn7FVbBnoKT0y7
	9dZreI+aJt7toZiWf6kaxzt0KPs9C85xcNmTnJzG6OagGZNUWqSvo5q1RIrkvQk8HVT4tC
	aSNPv00yh1q6HQ02jzEyPjH4U9pzlM0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794539612;
	b=e9iV+l3fMEOnSrjXJH5KoDI5ZUd9v5dljWLYyHZqBTc7YXzrUJLEVe2b36Gte5zsu0KEmV
	JIZ5YAKbohkKmCF30k3T1QD38/MoDbyt922odJs1qTyuz4gmhL+bL1vtS9INF2OhkzVWbX
	VOsX+EveGGRp0aEPfzPzkGk2WxJMiPk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mzrshj5O;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ke0Iccbr9LgY/TfCmCIV9uXQXTgTV19hOp2SzfN7XWTT4l5WjV6UhToXwl/2lz8lcr1OFG0P7Wwd+/J5lJWqldfbHAFIp+4f8aThB+83ftZfl2el8o/s4PbuNKeFXd5akibQB5etuFXPgPwd70C2F8TSHGIx7eblG1lzrP4WVCbWxK6kqcUuWjYEahGAt6TMaIaZektwa6XY2INgeyO/F5ZTmzCXJdMTDqSTHFa6efp3K4ogLAzqUTVyGsWUdywwTzu2MvcyTnQxDiw/+RPwSbC1jtNEBB4rwTk48bAYrUyPT9zugn7ujD01OQ3STHpmFJIfcthhiFAB7ptul8kzrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7/SN4QvThEVdblR4JGz5hKTqBsg5GPf1btsPRu4znM=;
 b=Ns3F026RkJDSnp68/eB51yDbEdDhTrjFjYtU4N513C7EzIn/IbX/y+o4D4Qa7BnKkhs8SoEVAY0fQvao5CloC7o0NPi/jQicQYhfVQaq3iW33ywTl2BcNj1LRwKKDvseAaSbyIQ9VgBgcVFYGYMpTGqeerZwdwbJydgfEzIk6ZvgJq3AEaejdVa1mX9vEbFg32MyoDOz21YdFDMOoBMOXrfGV8snKCZ0h9m94PD4aW6a9yF5eUFwNUKnSdXJGeV5oSEmiCc8Ge8bndBxmFZbtf/R8MoMjXDlodcMw/uE3lMwByFy54bl8i/ug/8vB9Uk7aNJTC+Odqfg7JYXXhAK3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7/SN4QvThEVdblR4JGz5hKTqBsg5GPf1btsPRu4znM=;
 b=mzrshj5OG3bIzQ2reYGZdnrVhS4gW/VkBWm9Tik+qG8q8OTI4t61BIoS8a4Dt32CCS3S4HjXk5IXLVu8PVanu/ZytKZwSYfLAgsuM2zUloh9eulzTVM64upYz61kv2qrFRoqlxF41rEiEa+o3Gv+pHXgZKDtPNvZwaOHc/UDt4UnQ7yU6ii67ZTrNXad+4z7ZlBf+GSSNQv2LE1c5MkDSOke4qUwOeJTgwSmIscc7mDnl0w4wn/39lObqJvGJgNjGOMpxazYqIiisWqwjwUB33XUN2tx1GtDiXR82ttkZZXHyzDNi/nRChoOc0f9DjXqhkD5kwrBDCez5z+KGfmxrQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA4PR12MB928846.namprd12.prod.outlook.com (2603:10b6:207:12d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 13 Nov
 2026 03:13:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 03:13:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Add IRC channel to MAINTAINERS
Date: Thu, 12 Nov 2026 22:13:22 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <6181A729-21D5-4109-825E-DB2E881A1783@nvidia.com>
In-Reply-To: <20261112212230.2805832-1-willy@infradead.org>
References: <20261112212230.2805832-1-willy@infradead.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA4PR12MB928846:EE_
X-MS-Office365-Filtering-Correlation-Id: ae4cbe5c-35da-4b54-9ee7-08df41341639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|10067099003|56012099006|261026140227099003|261102123227099003|11063799006|261021121427099003|261028144727099003|261022105027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	Y6ilOmOrihKAt0wdnivfU+mD33TGJezXnzQw3uQUsSJl/jPh80uq4TubRVTqlqyHejLHjfrSdHpHdF6YArbXsFObzH22JeBxCzUPSzUelG6zBJOuumqzDcr4gYzMX6RIIrx8DXar/gQvMIcACb4n1Dfefo/dfB2P7iGv6HI7ozNn0ab+Bt/XxKpPkvgy+GDoX3HVXLlK8xsMLU6Ef/3McokAH4q7a/T1KPjvolc7HKIMYpmQpBYiYBnt3nPL2jB8ETbrv+V2U+6zAYktvnvkxK7JVoLX3DERCZCL+zlQv2s97WSVxcobmBXwggfMrKS75F3V3Bo4dectOhWuooQGQElQu+x8I/1BYAkZqjNIyQRfTKp71C6iXAxtoeCd6w4ghwzq+P43zt++PrGG87WS4W4Err4Bsq0xRzKXXLagpyQgzPU2xp8iVv71+qamEx2k3YeGvXVbIinYQrV5i3YcNTeVUmvs/t5hZvfOYqh6km9IeAz9SFnimGwF24dD6qtlyC0beqIAy14JJqw58p8AFBNL2nwz0pTmCgZ3K2QWRZj+IvB2ZgHDEOxASoJTFU9T2RVENZTwkeTxMbe+AW2Vnur5aMz9Qbo6jZpV8Q0HW9C7MBOsp1/+izVuNLZ8lwxRuoNeK53a3TFFkVqoTM7X4A79KzA93TBDv6rh+Ps7BkY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(10067099003)(56012099006)(261026140227099003)(261102123227099003)(11063799006)(261021121427099003)(261028144727099003)(261022105027099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oXcPyQnDEMv3hx/VbdtciHxvq0meplW0qmu9D8oHBctxg5cJREsPVeS3/jUY?=
 =?us-ascii?Q?KTCZT+K9t6GQqfzc9iK2av5hYumWZo8/exNkuC40blMghOD96ewgqtYOPZpH?=
 =?us-ascii?Q?BK0nzMrQnfolK7L52ctXOCIeaz5I8Zq+UdDivLG5QamOBJ3X1iUMZ8/LjHbL?=
 =?us-ascii?Q?FYCX+dldLm/WpnbsZVcCciJJ9jQrp0qSxuCvusru0MK3zLhODFiFvc1uMg11?=
 =?us-ascii?Q?Dl1YBGhAXSyBpHCqmpAMcKxkCRFuM8eOcnKgBWxBU4ERXkr7oCNGa4c+0wIX?=
 =?us-ascii?Q?vVJIrge05QMsyKuUK1kFERkJ8q4uMFPJsImII3KHOOohQPWjZEBx+CTVUPqR?=
 =?us-ascii?Q?nGSeaDzKxbhviS90PUtE/RMGCbZQHBT3jAZa0E897tnan8c0w8CVGvC3wjPR?=
 =?us-ascii?Q?IHVVFDaM19NIoOiMCx8fuXhgE02d6rVkDxohYQbLDdpHVRmdjotvZ8MRkTkf?=
 =?us-ascii?Q?qZr/pKQpFEw0yDE81+T1ioWwuU8NN77dIEBgQnxr7lwJ0c0zvFJLmLjrV3JB?=
 =?us-ascii?Q?SZqsVx/yL8dCCCFgRv+tNNHtLwE+D2GjdphFNJvQQdGL97dM/8Q4lOoTnDrM?=
 =?us-ascii?Q?UBObuk0KFOrlURBufA4K9NfO0Z+Z92Wgk5Z+rcST7iId997ZVoPaeMfST8y/?=
 =?us-ascii?Q?rW3Ev7H9w5ZBqtYhJFmVfMFS96ytDs0b6fFrxbeuepRSOEq7YFIJ2kcGFr+V?=
 =?us-ascii?Q?xp7mF7NODGSyikJsYeGLRvwY3huds+fGOfinR2rUEEMvP4umjJmMDroO1noR?=
 =?us-ascii?Q?cIwCmGtMw+sds6Dadztgn+kTRb3WwY9uBR+bhI1wT2llAeDTVwcWO8POZ0n9?=
 =?us-ascii?Q?7s82WnQnqRZb7Pg6Bn/5uVLupXfqUj5Qo7eHLDp6JxKpclb/WU3O0717AfDn?=
 =?us-ascii?Q?NthcQBi4y+LJhzOzpuUBHavJ9rcTn3bChSzU8pfSL5EbJwbY3MdyJL+o5OR7?=
 =?us-ascii?Q?jBpAbKwPtH8DVsrcfqMoKEgI1OTJURcOuK5uhOcIoiFvq0J0rXwLkCH5yDaf?=
 =?us-ascii?Q?KofHQceviGfqkFXFpbTvjz/USkTGIk/pBeKa360nnniNL+2nZ0xd68DAJKRr?=
 =?us-ascii?Q?ZYhfOANhliTdiCZzcLhBHC33JcDmE+eCu9c9xmB8DBAewThRf5patVu9O6Q5?=
 =?us-ascii?Q?wE+oxCRLHRseTigXWtP4eKzMiS1GmefyWjX12OrV1LO91Dvx9rm6/8kT9AL9?=
 =?us-ascii?Q?g/WxQonU3OXSe6SA+3CXGXFnZXp0oLtwD7K8F+Cm7RKKxmc/4mjcqpOiIcPB?=
 =?us-ascii?Q?SHcsn4rbVreydbF7g66dBwCalQtKAqR1Cb5H8EAD8GDOnTuUz7hBwU3BCGym?=
 =?us-ascii?Q?ofi24UPWnbioY3FlbKNilR7+VWLtbdW8V40o+XiGNxmCUIMI8toKRgqXcWYF?=
 =?us-ascii?Q?Ou8EGVYD661UDhHUkFYsexf1ZskT1RxsWaLt3x1N5pdDOiHLZfOeFVy1Zjgb?=
 =?us-ascii?Q?7osyIO9Ktx32rzI5/AbRSANp2eRQ8ttyCS/KUwBT0frq4Qo2FNRxcP5Wp0zo?=
 =?us-ascii?Q?hBG2uCVUD9i6JtiA3PP44hpAy+bnMiiZbOlo/gJ1/c1Uk0JO+LYOSaFRN6RF?=
 =?us-ascii?Q?gMOeYEOJnKps0dUdFpXFuzzcjwowf2XeQbDMnCkCn/dV0KtRU7Vt9wSnJOL2?=
 =?us-ascii?Q?fU0zVejKaUSXFN5phO9mowFVp+sa5YiGox+gwDrDZKubunSHRCtbtO6v8L5o?=
 =?us-ascii?Q?bAgsFtqMXunTiTFWOyK5uNysbVKX2y2Pt+HH1xRVk0TEqe95?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4cbe5c-35da-4b54-9ee7-08df41341639
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 03:13:27.7780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Si2z2ey0i7OxaB3HOQzntmw3JOh70Amrci4FVXS0tCJHvEU1xpG/5AtUbUn+tXEt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB928846
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C7192140005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4rb4uh4qrxi3qw8rg8p1pnyupgynuh97
X-Rspam-User: 
X-HE-Tag: 1794539611-411204
X-HE-Meta: U2FsdGVkX1+UcGS9B6vcSFBiYFd7ZazUQwZyVAEM150EOxljM8O2xjI5G0S1J4C0ZgwxS6MLFC6Pq14t7vGtEDurRgBsfOq7j/8Ax86RUCkX7tEiADj8izffbP3cN/CySnSDW8mJS+2uU8zxXGoA75f4jQ3TtTSP4XMdnfc7t145/CzhLS+6Qv6YFCo1ZRtrY4rJ1DhSTaA3RjVKVMjbeeWxPtNoop+SmhVPO+XPZyolrGikz/+Q/dGgU+q5OUw5hpZUOz8PXWbYMk30Ddin/K7QPpNjzioQFbZQ1Mu6KC5FWkvFs5L+A+MI1meoepT9WaiDbtWwr9cDuf5SzQxBBwKK3pmHL8QfGYRgQNxjMUU6KjiDI2HgWe4pvi2MoaNKG6V9lC5krJz5M3aHYtxtEy2M0PYVtlblAE2ODcJ7wrX8SynNVmFqdWTWg/qm9P69am/nBa/6T0XQABgKcvUO1OnhHdwkcPXNASIrTkGNTNtBFNWWT+gAvbJrc7+o2BznJLH1GnvcA/jWc4kdJzr8hXBSTzKPebvA7hl8JxZiA6TE2XS7SpYgI/yDhuNhk+kJ19WKH/CW220bBhPMZhImM586egrqHqFLL+zx1MZcF/3q92sTFqSta+ykxwSPMbhULukdYrxma7f569AK05UGAJ2hjXGQ+1D/IplLdV64uSlpejNAUeR4g0zCmVmzPXvjoA9moaBrRpX5l2JTov94QkMJxnqMUWx6GgCzZeXKUamd3NdAI/uhB4SPh4PvLjMoeG5LugoXO0TcDnrmNhasli7e9KWxXgFUJkneWBQizb9DSNGdX0sco064XP9ERs4793e1C0woughKtrHDev2zS1mhu2CPQQc1mHh2oi5Pu7B5uXS+vn2zPfSEPs77ZPwaZgV1jc3kK2RmA1VhQIBzazCqpSnxA8Pv3y6oUFisQm43Rv9lcDC/N28HC7vF0Pd6Ssb4zulJ5rbOvyzahaY
 AxgxRpqQ
 YUIkDFQkhrHHdOdbu17N+Out688KE8ThZP9qQA1rF3NrJMPM1aukGr4OcC4N6hSujvudJuMKwSbgesmSeRxElfkzfmM5Aa2MIOUEK1Mkr5cDgfPT88MSyu3Xrs5XE7wsjzKI4d1xaYkqSXek3cFq7OQDl13qn2Qs45mC6VgqM77WaYXz5SfFiTe/lMpkHS9ckzjYBGuoZ7be8+xerQ8D7bGec4fFDhS9XCFut/9MmGRaKEp8Z8jDtQKRngSTJ5bSgdCyFvAQxhoB1XcgHnQFxIArxH45OvJJxsvuFqZiPl7qyaB4meRzEGH+94AEBqYGBNESSlpbRTtD3NprhwTjTqjlhGK3H9knX2vhGCGJLAvfybcbyQEuEFhYkaE02OCImtyhShruc2ZECE4ggptDjYfhtarOBgQoHq+XlBA0zs6sPNiOECPlqCxuTOBYy6FF8X1RI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 12 Nov 2026, at 16:22, Matthew Wilcox (Oracle) wrote:

> The IRC channel has been under-publicised for some time now.  Add it
> to most of the entries which use the linux-mm@ mailing list.  The only
> exceptions are those where I think that none of the listed maintainers
> (or other knowledgable people) are regularly available on the channel.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  MAINTAINERS | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

