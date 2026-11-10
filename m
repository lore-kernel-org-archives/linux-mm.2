Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B7B606E81B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gJqTqczp
Received: by kanga.kvack.org (Postfix)
	id DB6416B05B3; Tue, 10 Nov 2026 11:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D689F6B05B4; Tue, 10 Nov 2026 11:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D706B05B5; Tue, 10 Nov 2026 11:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93B5E6B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:37:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87011809B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:37:06 +0000 (UTC)
X-FDA: 85419764052.21.9EB2ADC
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 98F5340006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:37:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gJqTqczp;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794328623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNj6o+e4HK9w4B8joJl2MWtu/scRno9HMR7zwxLXqoM=;
	b=HbayHYOoFCN1+cUbSaEaeAwR3QEqGK0GFt7IF0VBQ4RIsACw0UmibyrHyQdqoaL4M6eGxJ
	/WewM5VAMOnpzoepmz9WB1m2QOoGFt+oSwZRs71o5OeyepzORL7i4L4ElT5rs9H1cezc9v
	9AcaxVKcHsHGaf7DuwRft7v2yyQms2A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794328623;
	b=sFlxEu3sA2r0yfq8s/1ozJ7aWi+oTi5qhrAyt2xrACE1zF+X6dhOl1FGQOwtsoGBNkRaHM
	3DC1CotyRc7O33cf9Y2jsnXrqwCxU6/l2WatCPiAhoXIBZLjmPgOKz1Wy3+n3atu28lxzZ
	sr50b+HkYumhGCWD1ztFVthvoA+Jtdk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gJqTqczp;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oFJIImkH7OW2np6T+UzG8xov2+CduFxPlywNTp2N0deUBIR8ekEa94+EiVI80TrvEEmV62ekkhnsi/orlgOylDQ+GLrOW1yqYyrp4Vz+KDOW1h/4ojhSuX7R1Dvv7Rpj9xE1AFSYcHVjMRodkFgLBfzZiu1WIS6TeGuLG43RH47uzOD2+5/XT4lZynvSn8JtwKqR1XOcRkqBe6cvrLtGu0PwSLShWvhVApgxA5WbjLbW9BVHJrQCcnkdLRr89vZ6cXHuG9h8pnYDzmm9YSqDCnqgxxxi1RZ7WUDj36sX8jgYVR43js/MEMnm8j7A+4+x5WAANF+SMJKNpJAIT3V1xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BNj6o+e4HK9w4B8joJl2MWtu/scRno9HMR7zwxLXqoM=;
 b=ixRo4ZPKr/Zhww9h+Ecj60XbdFFE9AG5AdnGV45nHD4RHJipM1PGYceZnMPTTkIyQMJPNDPVVJsFkiqtT7U+CsVzuumLi3441h14Z20sqxjmGJ9WwHmjhrZttkQ9m60Okp9XdRp0cXZTDmluz8mn+bqH3LhfN72ljdpTdTQvKhL7N8rl420bGnjLftRvehEbMuYeQKDTKYuxfxJdqEosnoIi3D81lzMQ9zPW20ZliSNiZnpCpB+8XO7rAnrEJKJw4BCW26UK74qCYWEnMZNgX1WwJapr98NXJ3+GCVioFOWdeT4kpQ2Dq2I56vd9pxA596jZn0NHciHoKgcYBEtJXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNj6o+e4HK9w4B8joJl2MWtu/scRno9HMR7zwxLXqoM=;
 b=gJqTqczpMwF5rxde87np4I/ycQJTHGSG5LFwS58CaK8gAHnr5v6mcG3/WXoe79STOfk202go5N//vTn5gIiJAvQO9w4tyV+nToAPbZzCjylgsrQK+lmNmEHsrdIcV6uoJzMPHUOW9q3Mj1rEoygwkwWBN2zefIREJ1o95X9uDGQYWfeHPgcmTJflXoEiIprGfcsUgM1rYONauHpo4RvXB35V+01jDR3Bs+e6sD2JoTQFe+Z7EVAbzU6IJj64YGcUlPC7VcAwgi5gFp38k0Et6HZJsdtBeCtnWSMvNcBkLQh5bfVZmVJI4B7tLid0M2bnBqQOKcraJKDwoP2I2QqaYg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB517653.namprd12.prod.outlook.com (2603:10b6:8:70a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 16:36:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 16:36:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Ye Liu <ye.liu@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
Date: Tue, 10 Nov 2026 11:36:53 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <117526B0-43C1-4F60-BA2A-3726AD1A9BDA@nvidia.com>
In-Reply-To: <avMaQIdAj5Zal3rd@thinkstation>
References:
 <20261109-fix-split_folio_to_order-race-v3-1-1cdc509e34be@nvidia.com>
 <5a7bb477-5392-404c-a748-4748cec2c84f@kernel.org>
 <940CBBBB-D564-4D4F-9C8A-A9A272F08064@nvidia.com>
 <a3557629-d86d-42f6-b181-bf8540dc1982@kernel.org>
 <avMaQIdAj5Zal3rd@thinkstation>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH0PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:610:cc::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS2PR12MB517653:EE_
X-MS-Office365-Filtering-Correlation-Id: 15f9cdc0-f893-4f5e-512b-08df3f48d5df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|5023799004|4143699003|11063799006|56012099006|261022105027099003|261021121427099003|261026121527099003|261028144727099003|261009223027099003|261102123227099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Iiv9D5BreY4uuU3GJkqvFfObi1/PtUEQyrIjV+z1h0DU6h8dzv/74NlFhH4c9Bl/O+WpiQc4TfiTuIZUZBfDobRKOHlgPW/7PEj95hlBn70J+rtvT98tBtzHuIM4bdPQQ0gGh94vd3wQaVC3oA0eputYXwz6RQ3kapNIVClQRTczbUMNp2obh+wN8Iq0P+ziqvQmu96ikdR0S1sVeDqPF6Y082+rR3GdaHwy8GaskPb4qY01wHzkQOx+2h5rYCF1/Hqvuz6icFD4NfkS4fjMXv16nzAcB2+A7JtCdqpj5JxE3gtBqAzu2hdwNYgpjYrJFYxcZd4O6lcXcVcWsCnV3RURQrFWhUMQK4Yfx25F9Kqb6DwaEo+2aSIoBDuCO5gvGRWyBPI9ts1dguzoZtXxLJbCBrcXy7nZX4kQAI7DiyORYuu18LKFSZW/CHw2o7eYYQ2jVZMHtdTbg3LBEAv9+owngwKqC2vaKnj0aD4qvMZYQRURUMkCxTqMK79chDP+l6ezsUrnJAXjlMpVJritL/sFFgwCQAWEbfY02/VqaN6QLHG7RIfKCZrjApLznEmoRreX0bawHN5fj6+yvPAN8SDWe1ZBAeZV8hXsWDMMGNND2++YTdyizf9L5sziXTIq60Y2NeWLlggbFV+4UBUOWg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(5023799004)(4143699003)(11063799006)(56012099006)(261022105027099003)(261021121427099003)(261026121527099003)(261028144727099003)(261009223027099003)(261102123227099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8mI99eDSZuu820ezVlKOqMajKsf4njVbWwCCjt5VFsYuOYh+j1ixbMIKIien?=
 =?us-ascii?Q?fAXyKkZK4L70SA6BjzC74m3OpgwY8Hquf7qAk4AH3WmPBX03rwoaVHZoBlru?=
 =?us-ascii?Q?+DIz4AZdQS72yoWgFWhgpCh4yCJ9gfYeQ6gs4U3wwwgFtBk+6sotw0hFlMb0?=
 =?us-ascii?Q?hgh6Xl8vSFw5IQb+gJSv4yeobFdHChFdbenxEVkWl+XuzKGe8MsnOl8/2tnb?=
 =?us-ascii?Q?KxVhNxhvdMecFCdIfWmvSPOgLpvTlrIVEnzBjhX/AAt5qy0Di/TRvvp4sCef?=
 =?us-ascii?Q?TSal1fzreRYvJaskHicCtHNPZIM+h9fEkTVYHPQKjds+pZfpBocxcGAGAbij?=
 =?us-ascii?Q?bcx6tVTot11l9U2cH1BXza78G3S0eTb9RRzd7goCQhbMqZ3QplpKV+rvjLfQ?=
 =?us-ascii?Q?W+IqtS5FKz1A+tq4/d4bbNaqEndyJAE+3Gz1ArJoFwvOwFbFyyWaG6rSOKGc?=
 =?us-ascii?Q?+Xmrgs/W91Q9nwfbqeiaMP5fjkgTb57nQ4Up8RXaV3b2OZB74CgzllOCVuuC?=
 =?us-ascii?Q?h/1NMpaCcGPn0XvaUjgYgT9BfD9zL+ZIrKtcEnn3hQjNltgSypWPM4OcmIec?=
 =?us-ascii?Q?IhwetXJgljqWCsk9PLgAvr9NLAmyNA9/ny7OsM/2Qhd7N9HB9wPHqjqxWYAR?=
 =?us-ascii?Q?im6MXzsyycqNZ3cu1Y7YnMNAxy+5OgCSFyUDwYbXWr0nIVFG2raJ+DMjdjH8?=
 =?us-ascii?Q?NOTLVzQlVGnPUlYAC7R46oi6IeGLhl9yQVCeRkC19W4/gYqR8dXry3kXFRAj?=
 =?us-ascii?Q?JPTtU+Kd9GbrMjJdVumArTlOFL3iI0xrCkIvehrxtvgLZjl9EREaXQPSHnbx?=
 =?us-ascii?Q?dRZ4lbd3VEJ9jXWmj0ww+GY8V/P4ftXPajCPu92cpCnprwxn458Ko7UsR4S6?=
 =?us-ascii?Q?kGKzBxkJdCtFuV/3ZGvM11VfuS5s0YXja6NPTyP0kAFTMBP+ElQvuRt3k2L1?=
 =?us-ascii?Q?BAeCUGK8m+kLa+FcpSBJvKC5qlR8AETD8d4faEqeU8AHllOy5b9s2h+3oudv?=
 =?us-ascii?Q?s12tQ2h9idBT7sdJyLIA4wCP/v/kCJNzHWZ9ELNswB8P2DyKSL4gavT4DERk?=
 =?us-ascii?Q?3slpP8i6WJFhAWipTBixWh1jE8+3eIA1IMSreaCxcXvNuEjpK7hCK2iKJ/Yp?=
 =?us-ascii?Q?vJfmup8QL2KKCrclDdtS1W/lYgOsRhcjgg2lFuA1KzXcEJIbJuoSzmTw3dx8?=
 =?us-ascii?Q?0yQ12tkcuOd1LxIXLz7A3W5XZntMwkbHZO6lB+0l0FfHaIxUiZnzwFE9s201?=
 =?us-ascii?Q?3wbeayLu5kQzDPMsgyPWMj4GSBnqifcaCgXNlM0ZMFi2RqETQPZhb2MYtj6z?=
 =?us-ascii?Q?79hCvJuIKF+J5jbIamr1eM5XCZQJF/sHfxk9S+2DYu46K2H6g4UBQIIUKoYX?=
 =?us-ascii?Q?HitCvoWQGo4nX0etfmmfvOfOoRU79IvdHchri/yBZwmU+qQT9w9Q9shR24Ti?=
 =?us-ascii?Q?M2oU1SMLSqzn6fsD6gCuAwS/4irRlj3YVebjjq8wOHjlo7fG3KdDJYG3Shc1?=
 =?us-ascii?Q?gGp2NfExEQDizuib6Kfo/kzlwDltprrcYJZIorHZwTUxAK6xs8SJ10Ipr3uC?=
 =?us-ascii?Q?hA9Rv/Xjp5ZsyBaWZlnBOZrrMU+dix9cwxBOMpzPWeGdPoW9ucORQh9Cq6wD?=
 =?us-ascii?Q?qVhp80lKoLucd6nJ8z1BAbwVnFIqsTkIbHt9WJp89MXuYaif1buy3uK1vTlR?=
 =?us-ascii?Q?HaWKgebf3YclYgU1Xx8nfj37nt3+WirZ9ZsT/yBN2T1s16R6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f9cdc0-f893-4f5e-512b-08df3f48d5df
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 16:36:56.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tjOG49xjNk+TPEtin7co07rhjZUs6jhqWyoHbvDN1k4zFeusyR45ExBJ2tPwzK4I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB517653
X-Rspamd-Server: rspam06
X-Stat-Signature: 5c1yfuekwy8sweb4oo4xf98owohyioou
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 98F5340006
X-Rspam-User: 
X-HE-Tag: 1794328623-626747
X-HE-Meta: U2FsdGVkX1/oAMeCJpXSJ5NaTsWujKFQ5HYQuf57/tqVzLlywy4thQxcNuljIDio9n2EQXa+Wf/yQeTkQq8AiGtHx55SXBCgsDjJFd+cB+f6WB49eSbppRQNNfRuH91pHt9UoXJ9f69xLa2tGLQJ4N+ygRWNyG12jFouGIqrpDn6ItfEO1on2DCZxD3kA+vkPcvRCuprmBlTJYTBn4MbtWoLmnn8we2ESx2UHBV91D7Dl2rMWBGn0z0TeN+QhfUV2K4kQh+NuW7Zxm+QR+ipeW90bJXkWbZRfOnnoeV3z+GW4vvx8VZNpFC1zo80u0ohjACqAuh84Y6ADJi4GJlZJE7bUC3IUB7a5Mgop+HOAeJgF8444kCtsKoE4TycIDvDmErZzN+bkucxPjkEXVTZevbe+B/PvA6nwD6GlnsSPhGJA2x9/sZagXyWQi9OEYN/w7tcbD8udZ7/cFObaLcXmohRVV3Q8ZGd5tm291cJE6nZzQ+D7JgTHF/dgbwhrDitp8utIakBg2rGcWcdvt/pay8chir6VjLxfuifQkUShmcS6KjkW7NMec5EwtLoEWMGLc1qH4hy0IGqqOehFOStTXpwjDX/YcvmMnsX2Jd9fulyMRnZXx1pSVmkChOOx9qoLaIjcUZnltOQ/6ikdKPxc9rNE0hwv8mZ/p+dwv7ef8Je9Nf6hg1OjnYZNMt94tFOqbFzN0tUUUhFGr/b4Y1VPsHZm/XVnEswvakH0n/YsaahSoQPkMIY74XAosQOg1FF0eSC/JdmaFcGkMOQHfho7rI9uo/X700FIt/bYA/6Dyei8TgKYyTex6fV2AHof6KCGCrmmiAlgh8btHzWw6CH7mc/xeckUlQefBWXZy7W3vF/PB2tcFcw3ZtXYsMMsS6DCeJTY8nOld1/GwlaEpI2HsS8s/VghYUx5WXGMnD3IDm6xk93ohyqZnYkBDSqh/LDfE6oUcz8Q9wT93GW3zZ
 tBAwVH/t
 IL4GpW9TcPgEX90xUh3cIeLhgveikW7jl4jzNvCcvVSTOAA/VsmM3TE8Nx9R7PK4If1LfiGtCdn4FmTDLCk/n+ldnfjZd7j+pVyH88ZHspANhGuiNaIlwDRfOuihJFxedigwJXJ9851KNeUtij5d0+IWvK9lQfojs+cbDEPpwleYLihB0WdNTMd0g5hKwwROM7WpKCcRNIGM3mXYC5yR/7k/3QJzYT1jkalcNo7eYNWLZJjg+Rri/ZDPbLkqdMoiUpEMBorrHo5iehvCt7idGnU+YkqgumjgaVT/4FWjnKr5e8jaMHFEUydBHkqQjCSQzlaaj4ciJtBVBMOPbD/qrApRB7iBHOLeN1PFPSWvGMa+TG2e01Q924MwiGGz2yaa7Wr/QxuUGSwDTnW96+aPVyL5i1Thhmy7ZNvLs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10 Nov 2026, at 8:48, Kiryl Shutsemau wrote:

> On Tue, Nov 10, 2026 at 12:31:21PM +0100, David Hildenbrand (Arm) wrote:
>>> This is V3 of the patch. Instead of using prep_compound_page_atomic(),
>>> PG_head is written before clear_compound_page(), after which new_head
>>> is visible to the reference-less writers.
>>
>> I'm confused, how is it then valid to have PG_waiters set concurrently while we
>> read new_folio->flags.f?
>
> It is not. The comment names the wrong word: PG_waiters can be set
> concurrently on the old head, not on new_folio.

Yes, thank you for the explanation. I confused myself when writing
the comment. At this code place, before clear_compound_head(),
reference-less accessors can only see the old folio.

>
> CPU1 and CPU2 below are two faults on a migration entry that points at
> new_head. Both take this path:
>
>   do_swap_page()
>     migration_entry_wait()
>       softleaf_entry_wait_on_locked()
>         softleaf_to_folio()
>           page_folio()           <-- old head or new_head?
>         folio_set_waiters()
>           set_bit(PG_waiters)    <-- on that folio's flags
>
> Which one page_folio() returns depends on clear_compound_head():
>
> CPU0: __split_folio_to_order()  CPU1: fault           CPU2: fault
>
>                                 1. page_folio()
>                                    -> old head
> 2. flags  = new_folio->flags.f
>    flags |= folio->flags.f
>                                 3. set_bit(PG_waiters)
>                                    -> folio->flags.f
> 4. new_folio->flags.f =
>            flags | PG_head
>    smp_wmb()
> 5. clear_compound_head()
>                                                       6. page_folio()
>                                                          -> new_head
>                                                       7. set_bit(PG_waiters)
>                                                          -> new_folio->flags.f
>
> 2 and 3 race on the old head's flags word.
>
> That is Ye Liu's KCSAN report, and it is benign: PG_waiters is not in
> the cloned mask. new_folio->flags.f gets PG_waiters only at 7, after
> CPU0's last plain write to it at 4.
>
> So only the folio->flags.f read needs data_race().
>
> The new_folio->flags.f read needs nothing; the READ_ONCE() I had there
> in my sketch was not needed.

Yes and I should have checked it more carefully, but my focus was mostly
on whether PG_head could be set before smp_wmb() and clear_compound_head().

I will clean this up and send v4. Sorry for the confusion.

Best Regards,
Yan, Zi

