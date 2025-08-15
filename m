Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3921ACA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3B1900207; Thu, 14 Aug 2025 22:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A8C8E0002; Thu, 14 Aug 2025 22:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D35900207; Thu, 14 Aug 2025 22:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86CED8E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:42:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FDD25A556
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:42:37 +0000 (UTC)
X-FDA: 83777443554.23.9132010
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8EFAA16000C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:42:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=teH40Boi;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.88 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755225754; a=rsa-sha256;
	cv=pass;
	b=FyJ0+fYqBqGutGopJ/zyxd82JTCsGOx4l/60hy99AEsw979Zk0wrb4v13z1+eYz5fIOZ11
	D3vhJHZJX3xkxDc2+WSKvqVVYxepWV7ssasZxEs2fUE4OIvII3TejwrTAo2x02aeODI7Zj
	HngdW2y2IHdIN5P/E5XiklKz8Ivs8pY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=teH40Boi;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.88 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOrMBoqBO0sEo1cRgG3waLlra/epJIeXy4v/9JmSdpI=;
	b=vwELZvHPs/KR/3uiIECuCL71lctNHUUREAdg7wgECKb9aOjIOxRb9Be72xiKtU65QQ6QFB
	MFLKKVXKytHYarmVnxUtd3Bn+dUiiO40zelzyqMeboFSlAOHo7v4IB9avAN4G4hx98OMfe
	Y9829kSNN7uSTqzXlvYFn0nchScn1bY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YcysQ7M9WH+n05Pd2uq4F1bKBPW0jcCb6QLksltW5+hOyCY+x82A954eN0sc+W6AgDSgp5jJqrYtULqYvOIePAL5kXEEMmwkEolASNfZbbF04KK7dkxz9OtGshcsjjtm9nTZn6sRVjV48uQjVhugmmogwSXPjHT+MUr6XhPLl6kQjkIIvs2w6eA1mwiDjZiifQfUL7kQgNVI4fpM6G/n86dRZrOW2xFNEPnJTFvl/Hdit7QeCJUbsK6t6XhQ2OtheuoX1anrtoHQboPesLH9Ft+MLYYXkV+cYXJjeDCXeNfSiNPwfWMw0/CCBwAhPfXdHAxeyAu4hmhy0OuUWSgkNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOrMBoqBO0sEo1cRgG3waLlra/epJIeXy4v/9JmSdpI=;
 b=t+4jWoe+jDwqIFM1f6EV6JK6FqatGi2tvS/+zHjw8tZL5h5gMXRxvu4k+PSMsSLmMJeVd9qEOnlVJFTTX35xMIw3JeflZq1Cu+OONxDRyg2QEJrllezSjxzBvyeXM3/Lj/8EelRkU0FibDLDB+xNOIAHQI3Qo9K3fAdJLQunZJPl3vZUU8UXBTPP74NJIPD1ZoKVjjBKMy8u7E5mlttGs3fdTb+jE/kkHTkFEOObWwcCh4Wj0DCeAEmcZglww8H/7/yTgChZdQMmX9if+ETPRgCJ0b20apgT9mvg75VOJw5+ef9LRw1GStAtrkPfVrnuTZ9qPPIjblHlxrIp1u6x4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOrMBoqBO0sEo1cRgG3waLlra/epJIeXy4v/9JmSdpI=;
 b=teH40BoiVYV/5dMGdfdiZEGMX5dOHRXXjNitQhYL42jlTKSDp8t6OMvJu/eVBPepHpv2urtOr0kbqKgDMWP4meK2krpBcw/0jM5GnxIi61Lll30X668o8cqpNFU75KnX0lqUupsvkgAoHIr1Pv05krDhurmK5eoCCCO0BCfR+ccontvhyUQEPcMI29stbStQ3e+n5dFKV4qcUBiVgHLxCUjQWWcGhz5g2GNmfMF6ltf8OEqCli7mXm6ngx4X0RS1CzaLLnH6PXoDF2q9z8MjGrA8/uh9Sn8UxPfybGD1NC61J5lMzW27oWrGfJSORZ6AZFs0ucKbTQ6ycKyvRMxZXQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Fri, 15 Aug
 2025 02:39:42 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 02:39:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 4/5] selftests/mm: add check_after_split_folio_orders() helper.
Date: Thu, 14 Aug 2025 22:39:13 -0400
Message-ID: <20250815023915.1394655-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250815023915.1394655-1-ziy@nvidia.com>
References: <20250815023915.1394655-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0010.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: 1412d48e-07ce-453c-bae9-08dddba4fd1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yAd8M+/SeSlgHUQrKQmPjsV8delMnx9sTOgCQhlLZCZ8sY2gScciM/tOuBe3?=
 =?us-ascii?Q?6QhmCYA+9fxS42eTA9WPxr8MEb5OXla7PMBaVkyqpRvU9Ds7WLQ+qLY9rnJL?=
 =?us-ascii?Q?06uZ++HBKxWymdpnvxEg4krSkt40iQ7XdPUuYrCdZcro/1nGam74+l86UttR?=
 =?us-ascii?Q?9p3PD4vaURLSiq+T47ief00KzbMSxdoMApH1IZtMCGtuD/SzqDa5Ge3nmyG3?=
 =?us-ascii?Q?4fx8QeBr5GIl3DB9rW/16yvxkZxVCFYh9Ae0waALR/rM5Uh6w15gvAvf86pD?=
 =?us-ascii?Q?Zym2Y9YAWAQgxnZIv29q7A4FxxApi/l9YtyIWCFcZs6GAUKr+h3MqAZWHTGv?=
 =?us-ascii?Q?IRKUqLG/EwR84Fk8U+ZY/SdJ680CT6ldy2rdNEOH3YVBdw7M5StUJeVaY2KV?=
 =?us-ascii?Q?oKxxn9RhrsirmnGNJTzIlEY/+anramk4AG/xFY0fXClHEw84O7veK29BS05H?=
 =?us-ascii?Q?+x5Jf5nvc1NH/S50c74Ny7gDxkYW2kRUzQkfytFNigzXR98HH2AUaiUni6dt?=
 =?us-ascii?Q?3o5YmSr6Yp+C3bZNp1EyYVcxmXNlUZrjo7pYWJhcuFUaX6PmH6I60Ohc7CrH?=
 =?us-ascii?Q?7sO9IbiqwaifOMUy9WfbWn8icDo+B+9bFl4XQcbzvtogARUSgnwpFQpaUImR?=
 =?us-ascii?Q?pXpQawzGl+MIljCnGxofqTDuoAHi2GF8NJt4c3PfCXKinDFjYp5vw749dEgF?=
 =?us-ascii?Q?n0q8kPLHQWtAwplSPOy0OWz1Vsa0t70Ze3KjvLr2NzYqDGX6xPNAhWP6hW0w?=
 =?us-ascii?Q?1pepbF6QWT8SUWvaq6jXnRu+rZLIXqeVoOaopHsKPQl9ddoEOguZvehaVAe1?=
 =?us-ascii?Q?WrHbAtUD7jB/vQIGo406VzaFD26Z0h/egNpffxU+z3NvN31Lv/EphmujM3z1?=
 =?us-ascii?Q?3dlokAswAhFS+3tFRFLQRA73WWDbHDddI7q6uIzztZ/Gj6tCsSQCbk3TH6fK?=
 =?us-ascii?Q?cRRVZksdCCDu34jFExgSmF+IWPciDgX0hTApBK7LhqA/nXMtAF3A1royPyDH?=
 =?us-ascii?Q?YDlbceC3NRUDJaAoVicusuvopj5F6upZt+ELssGmEnpHIfc1ojNGj9YQBTaP?=
 =?us-ascii?Q?+HNmeoh94SAw4lUsdheWLpnPPazBM7IPqvyBde5RqC7AkkLwteVxbfakuJpM?=
 =?us-ascii?Q?x2pcqpW+fCEV6QdyxwwEbENSk2iKm6UJYZ9n4eMaB+m6sQhJ9uXP1M3lgIDX?=
 =?us-ascii?Q?6r1zHDUo8DWFlSSuP1uSXp+S56E5Kd8cPwE74ExoaDLpo0n2YCVbzAo92qFg?=
 =?us-ascii?Q?RGMzo7hbDccbW+TLzWWM1DdXtXA3aJYHr7ltVkz5+AQMLkddK2UqOQxgUCEY?=
 =?us-ascii?Q?ka2KnhHBM+fIuUk3nsBrMXO8e298F1UOOgBxE4nXV2ScbAF6WtnKHsPV9h+n?=
 =?us-ascii?Q?dfCznNj7O70Bc/nkLsw/2gI6dFkPzAnHarpDGq/aMq/SIEtHPr/Q+Aj7e/Qs?=
 =?us-ascii?Q?NTOBvkeR2yM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?81g0uL8RyB8Kwrh/un8d4WEmFusuHnLjUUbk317hgbY6OSbwK/jKZKsU9RdZ?=
 =?us-ascii?Q?uBOSmSEO5XKYk28Rn0XTWMSXO+S1JS4H+/W3LlSs9sGODkvCGU5AeFg3+zwu?=
 =?us-ascii?Q?CXnMlalIjyIfZvEJx1pgkJ/6TvYB0u5ZCI+vTRnnjRB5TvF3XImC0vr02+cG?=
 =?us-ascii?Q?8WxPMWg/PLPkmX5lR6vjoW3yPQrXNVFB3GYZYjsvRi3mlJdZYnCFq54bLltW?=
 =?us-ascii?Q?JBvt7DFFtMknn4Ea/eTTy0/XXNjiNVE0xMyQ+Hd/A/vBatQWEm0xd/YvR3e9?=
 =?us-ascii?Q?Uc1V/5dVK3oJ4ZLQvitnDBBvrODyXHM3cyzNGbbJxcK0eA1AzW8Lw4FBq195?=
 =?us-ascii?Q?aZsxFOOMF6Ck9Qik5Yl1dsJtt8MDgeiChJc486dSkxxM+zfJAutKnBmlUkm+?=
 =?us-ascii?Q?40c359k41tqFRXtxDcBIgmz5X3xpezm8jlTsvXv02YTLtY8gmb2w/SkbVy5v?=
 =?us-ascii?Q?f2hQRC3PZAbg8gtjx/1YFwLKfuEo0aE4RFCzcI5osfcBrHb8CyN5763HDMUM?=
 =?us-ascii?Q?LHVN6NdD/+pCo83zGF4Cd74WF1C1H6ncdTTs9OZtIioScJTURvlF+X0XhiVL?=
 =?us-ascii?Q?mE+OP8OuFJN73Shq3vzUSQdC8yFQ/4bqBu8rJ6ORpX25YKRJha72GH9Q/hHh?=
 =?us-ascii?Q?kVxgfg+3qbK8qhbv33krSlvQ98ZUaaCu1+qHLyLpr6FLJMXOcXOHqHtM2ugw?=
 =?us-ascii?Q?0rt6i+aJJe6p7pCyRkriZHWz832zPqrJPsH1L56w4WifXH63Ew4LpkDsvBlg?=
 =?us-ascii?Q?NEBami1lfE2ESgXBFutAeQLB02JpEGp0k7FKG1W/K2QLSdbQP2iUITVolPKv?=
 =?us-ascii?Q?kmQoAH5u+O90gg6oViC1H+oYOm8iori6T2Ev6yl3jMzq/NQR+La/IRCXnFuX?=
 =?us-ascii?Q?CNGwXtow4db5A0cTSOi2a69xO8aPwSMDie+qqs+p/m5zQrdxcfz0EZnr0ee3?=
 =?us-ascii?Q?yQIddUibyYkhF/5pR+4QOuKUn268LRXLf/tV2KkLDfr1/AJEtdqpGVgXjbsc?=
 =?us-ascii?Q?VPFdjyaRdOfMkyLxZdXSbFlB65xRLscBiYjVU+fPTxNddWXoPd09+/RIMKVE?=
 =?us-ascii?Q?zvDoKGedecyWguKUjAAE3+pMY1Uh9mtOAFRq6uhvApuq9WvP39a+H6wRqlOW?=
 =?us-ascii?Q?OA80NWE1dYIyU0I52u3olC4Qztl/r3wHAV6Ii4vsv/4DPMmqI64DPEUs1Och?=
 =?us-ascii?Q?fVidh1lvWJPnz82eP9HaEGt/0oY2oSNKj8zaNfxjSq9nQVNK0aoYm7jnqraI?=
 =?us-ascii?Q?3pF5W+rjxMhLqSO0Gy7DN//6Cfx9fQMdeBdX0yWoGfHtIdbuE7oP1Uo6HkwA?=
 =?us-ascii?Q?sE21wzaaStsKiYvz3TjDPj+ujMCd9410P2DuHtfpmWrv+ZtgRVuZZ8+PLJX9?=
 =?us-ascii?Q?0iT2MzN6xc1cHbpnSsugUV+NL7qXsr4jttnHlKtaDMFAF9uZj+IiXm7hxeZd?=
 =?us-ascii?Q?VKPnJUgeJF3GyPcwc523XZFvqrZIws3MODT1TSHV69Dx3kIKwW7OxwIY98qH?=
 =?us-ascii?Q?CbVvWLzcZXHT6Rcx4j5IZCk2WNbUJNjk1jJ+UiRfKsaHR8x9Z8TDwx/HsXET?=
 =?us-ascii?Q?CuseTzUhaKvLxCtSEPQDDRVdedaOKiVFsFqramHL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1412d48e-07ce-453c-bae9-08dddba4fd1b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 02:39:42.4971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCL6uWo7sFvC+b6XGKdNwOfhrsuJoWFbwHeElb/zV2Jv6QzMMJcDwQ3icZwYncoj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7226
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8EFAA16000C
X-Stat-Signature: zgca7ytnri97k9tcw3cnt4ddnh8in7wj
X-Rspam-User: 
X-HE-Tag: 1755225754-74267
X-HE-Meta: U2FsdGVkX18f1jKZWa0FtHsuZzbiLlMVbTLp5kAoe+Fcla482hihqU6Yb8s1qA6+uswqlc3Y/CRdXRyvxcAOt976sHWG54nnlhBhCOy9ZsEmgSEwdaS6pxdbFYmY6IudMTNpk6TuN/+MJVeypLBlLyTH7IFjQxRpdWeO2CDZoqIVZP69MMuIzgJIaV82krh6QCekxJ+OEPIP8/+OZn7pEVwkcwW7JPvRrrlOEZ33ICy7sJeukeQVMNkkLGzsOlA/hQyPydgt1CFpg+RFZfU3dJcpX632azVbHAFmhrJ2hnnNS5AMph39Ewpt88sKjtOWsBwldNm5nwe/KXgUkZpmvIs0hH0Yhs7gBi9q8/rjHURz2wftJqkReGzWhr5+eM8k8Q4UI3nmedGr5PxlRgy8MaNlrz4yW4IAL43tJjaSG4JIkeU5ar70KYy5tMsuzzADDF68VtNBmFhPcm1lL6kM4J+cKE/KtRJxFkyF777mBcLK2xzqiw0R9jYXrc5vseSF7OIzu/pRyvuiUo6M73ioaJUDbnXBVG7wNqQZL9/3ohaKifXYUEOG/O0Ug/FawZNycdM4rokZvzhpsmiSWAhf8qTJ2MTUSgNnh7FOyBWPPH2HfM7DZjH7pEe4ixLso6luvWbKLrlq67UvSVtJOQo/p5d7ba6eBmdmzbbezGSYIWaR9YgQ3ZgHy/XaKJR9WBA+pu7elcx7pnDvnc88PG9GdhdkBBywJpiyO8j5If2n7km5mnu0M1mADi1lpyF4Ol9dshfBTgjPNxdKXY1q+Ev34cYouLbG8LOkW2NC4FhOab50opPa642OaSQCCn9/oIUQvon5A2A1hRhJmhYqvix/JtDz7T8iVGge3t06SE9VRpLNPMGNYk7bDu6Nsl9MvJvmmFC11QlAhwlwvpqdlfeyne9nT58ypIC75KnSSRyPFNIpH9x+I4bkdaTA6P0PFjtjLYHj2xPp3CfEoduj1I5
 y0eZCHZT
 o54wtp4ExDWeV9fr+fKXE8nb2IlPAS/7EhrsQn31xoVOUfFr8hThJ0f5VpRYImUlN5u10vwVAxmozEBXEky3qWOPjYAOiEoT3LT2BBvW+yAiBVKTt9Q2OyQDvMb3+itKr4ATvVyQcX+6Irn/Y7+dROv5biuZzBf2nB7S0Yj9y0sQz0WrN7rYGajPBbuxI09092x8kNMWzKokbTVFpvLpXRIk9LVWiGtcpy3zr8zjvF7neivLIvkfYVn0eJoyY2MAlZasI2XQSxqAGa5OgDNzUujMVHj5EAq3jeo5t6zltn0ihPe0Y3ixZwxxN4TrBezykwm5eQJlRS3VG8k+75sVJW0wSNiVpXcUV1kwwo6kXzX/rvsqqltIt4nEqcsAnevgUyZrfKlMDKmLtVsUrb8X2nEJKWkQQhOgMfyNGiDgJTb1p8R12QfBI+p0NZv+KebPSSHM+sJg3TqZOJtbk5mX0++hMzYFKBb9pkKIXQr5VD3VCHTvsF+o9iYV3oRnE0v3fZgmdmzjziw6jwj4rdUuVrTZMlgPIe4MhQWWwgzbFEPExUgzj4poVM/0W/9ROwJXAqeSf7AmI+FUy3eH4DvSCpn7XsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The helper gathers a folio order statistics of folios within a virtual
address range and checks it against a given order list. It aims to provide
a more precise folio order check instead of just checking the existence of
PMD folios.

The helper will be used the upcoming commit.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 .../selftests/mm/split_huge_page_test.c       | 150 ++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 80f718ca21c7..d2467072e752 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -102,6 +102,156 @@ static int is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	return -1;
 }
 
+static int get_page_flags(char *vaddr, int pagemap_fd, int kpageflags_fd,
+		uint64_t *flags)
+{
+	unsigned long pfn;
+
+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+
+	/* non-present PFN */
+	if (pfn == -1UL)
+		return 1;
+
+	if (get_pfn_flags(pfn, kpageflags_fd, flags))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * gather_after_split_folio_orders - scan through [vaddr_start, len) and record
+ * folio orders
+ *
+ * @vaddr_start: start vaddr
+ * @len: range length
+ * @pagemap_fd: file descriptor to /proc/<pid>/pagemap
+ * @kpageflags_fd: file descriptor to /proc/kpageflags
+ * @orders: output folio order array
+ * @nr_orders: folio order array size
+ *
+ * gather_after_split_folio_orders() scan through [vaddr_start, len) and check
+ * all folios within the range and record their orders. All order-0 pages will
+ * be recorded. Non-present vaddr is skipped.
+ *
+ * NOTE: the function is used to check folio orders after a split is performed,
+ * so it assumes [vaddr_start, len) fully maps to folios within that range.
+ *
+ * Return: 0 - no error, -1 - unhandled cases
+ */
+static int gather_after_split_folio_orders(char *vaddr_start, size_t len,
+		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
+{
+	uint64_t page_flags = 0;
+	int cur_order = -1;
+	char *vaddr;
+
+	if (pagemap_fd == -1 || kpageflags_fd == -1)
+		return -1;
+	if (!orders)
+		return -1;
+	if (nr_orders <= 0)
+		return -1;
+
+	for (vaddr = vaddr_start; vaddr < vaddr_start + len;) {
+		char *next_folio_vaddr;
+		int status;
+
+		status = get_page_flags(vaddr, pagemap_fd, kpageflags_fd,
+					&page_flags);
+		if (status < 0)
+			return -1;
+
+		/* skip non present vaddr */
+		if (status == 1) {
+			vaddr += psize();
+			continue;
+		}
+
+		/* all order-0 pages with possible false postive (non folio) */
+		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
+			orders[0]++;
+			vaddr += psize();
+			continue;
+		}
+
+		/* skip non thp compound pages */
+		if (!(page_flags & KPF_THP)) {
+			vaddr += psize();
+			continue;
+		}
+
+		/* vpn points to part of a THP at this point */
+		if (page_flags & KPF_COMPOUND_HEAD)
+			cur_order = 1;
+		else {
+			vaddr += psize();
+			continue;
+		}
+
+		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+
+		if (next_folio_vaddr >= vaddr_start + len)
+			break;
+
+		while ((status = get_page_flags(next_folio_vaddr, pagemap_fd,
+						kpageflags_fd, &page_flags)) >= 0) {
+			/*
+			 * non present vaddr, next compound head page, or
+			 * order-0 page
+			 */
+			if (status == 1 ||
+			    (page_flags & KPF_COMPOUND_HEAD) ||
+			    !(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
+				if (cur_order < nr_orders) {
+					orders[cur_order]++;
+					cur_order = -1;
+					vaddr = next_folio_vaddr;
+				}
+				break;
+			}
+
+			cur_order++;
+			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+		}
+
+		if (status < 0)
+			return status;
+	}
+	if (cur_order > 0 && cur_order < nr_orders)
+		orders[cur_order]++;
+	return 0;
+}
+
+static int check_after_split_folio_orders(char *vaddr_start, size_t len,
+		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
+{
+	int *vaddr_orders;
+	int status;
+	int i;
+
+	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
+
+	if (!vaddr_orders)
+		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
+
+	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
+	status = gather_after_split_folio_orders(vaddr_start, len, pagemap_fd,
+				     kpageflags_fd, vaddr_orders, nr_orders);
+	if (status)
+		ksft_exit_fail_msg("gather folio info failed\n");
+
+	for (i = 0; i < nr_orders; i++)
+		if (vaddr_orders[i] != orders[i]) {
+			ksft_print_msg("order %d: expected: %d got %d\n", i,
+				       orders[i], vaddr_orders[i]);
+			status = -1;
+		}
+
+	free(vaddr_orders);
+	return status;
+}
+
 static void write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd;
-- 
2.50.1


