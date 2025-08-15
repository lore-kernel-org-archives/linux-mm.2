Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFBDCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B795900203; Thu, 14 Aug 2025 22:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F898E0002; Thu, 14 Aug 2025 22:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A05900203; Thu, 14 Aug 2025 22:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4B88E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:39:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B2B75B80D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:39:55 +0000 (UTC)
X-FDA: 83777436750.03.41506CA
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	by imf02.hostedemail.com (Postfix) with ESMTP id B147D8000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:39:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VWllmqc7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.84 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oLoKALZi5FJ3e7+nSqCSuBGxctELFoiLzRV5Lx5d+s=;
	b=6aNpWVcoBHTpsBnVfrXfjvWMnO4AFdPUyOTG7fjm+GZDAJ7mW1u7ArIUVuDBiKRuKTM0x5
	m6IXcvZCIwEB2/HeqO4AlFaGAMQmzvElOYPPwNnStRs9mZuRufTGsAnLOsq2pgMEMyTBwV
	4deIEPHB+DOdZwVEKJfogZ7eCarMBvw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VWllmqc7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.84 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755225592; a=rsa-sha256;
	cv=pass;
	b=wCmLOQOZKjFZvNF0DCDZGVwQF/uy87Xdq0q9L4lEtTTm4VJquHiFgq2GcCd9p2Pk886ECy
	hRvJ3LGUtQzREqf+FmrWOndvDSxB73by3LFnbfTFkfCKBN2Iflx0dO6s0oJVOz8aUYpTbw
	1rFii6h1mgOh1fvCv5eoFVmSbNFGM3k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWSrmyMExqP78rimjf4P/I5ZNQno7xA0ZcvTQUX5ZDHw3yU/dS0win7uQNu/0jtcJ27T46o9eVF2b1xFu6ASIxikqeCanr3pAP/r9q1MuKrzhB6KcxjLD/6G/uEq87fSTxX6mWSI1dc1TjN8zGPbEIDYuNCzWusZ9nLV6W6jNF9iDolQZTwCQpFmaNLPaybLNbwPQUxO6couU5XWa9otY8hLCdi5929JQtJU44RjI3Oz2b6cBJRY7bp5QH7+qAJTnImdPZbfJl63+/swhnAk2MBs+YeAilyXoKivdh2JSpniLSiTg/GNbgzYxlytcw7g7cdpN4pQgQWiljCV14GDkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oLoKALZi5FJ3e7+nSqCSuBGxctELFoiLzRV5Lx5d+s=;
 b=scVSVUkYx3t98XYZewX/hyh8/+/cFfnv4soHifY4r7vTLqsCMmsyKJMIPtmN2N/v+kI+3caFGVG2WdANh5FV6mW0fDIYXq4J/sq7SO1SkwV+UuZOaPHbDe7C49KUweVxqFerJGzd8YmVC76ka3+AejcdzAlId4gbiQmmRfx9qsqtfvYFw0Izs5ioFtD9z56t2CtzaDpthwb1cVPMJp5PQ1IoXS+poU/MsJmb9rtnbi1A6R1yuATxIyYYcNU1pE3K0dlKfFjJXxR1v4EMnBPiv/O5JUv7lfmuF6Jh8YfVEW4zA13sH2+Y5gBm3ngJuHcVdapshHBmFEt75XIexAhf1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oLoKALZi5FJ3e7+nSqCSuBGxctELFoiLzRV5Lx5d+s=;
 b=VWllmqc7zCvie38Kn/gZ7pkz+dQAIb7r9wEWKQtMMg7Pj1EjJiH9y/zxBOp1NemMCqEJUx+7WUcg3W6FONku8J/sDuUjjB4iGLuuYc/6EtAd6c/qcLy+XGfh06x6grDeSMRRKuhtbzoG33J5OGRyeZwjzWwkMWI1tuEvWtPoi1j/TG/RhXz7RRibzxy06eZ1VdxFnFHLjfpLCPytJDX8lJXQyEKGRPEjiSHVUwvOUv/J23gUoUqYBMm7vD+gBY9xEez7GAxNxqXxjd/kQDPqbdlIkYc5EHcwV71YSpKD35Yraj9BDnTofwf/d/O/3HB9gFM8oNYOoDkB20nKNRLAgg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Fri, 15 Aug
 2025 02:39:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 02:39:38 +0000
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
Subject: [PATCH v4 2/5] selftests/mm: mark all functions static in split_huge_page_test.c
Date: Thu, 14 Aug 2025 22:39:11 -0400
Message-ID: <20250815023915.1394655-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250815023915.1394655-1-ziy@nvidia.com>
References: <20250815023915.1394655-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: c19b5d4d-ca31-4c1d-9292-08dddba4fadb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a5Cmg9eUh4hlXTwQTB9r6Bkn5qSz+N5orKlHRQduXoPffJdcfA1Q+rS+bOoz?=
 =?us-ascii?Q?zGFKNHbcUrwh7CZ1EYHSnHD3bcOH3ZAWxFtSDnaZHH7ZZj3nuTiQseftkwl0?=
 =?us-ascii?Q?rl4snZDCj8v6Vu85B/Jv+z7bkVQLv0afXPWCcx34yaj4UkmKSSFrIOAq3Ptv?=
 =?us-ascii?Q?G+vb+6ImZzS3u9p9rovDycat6wwSAAqF8ih1JO9poiUqV4Y/PdWRnR/IY/d9?=
 =?us-ascii?Q?T3mSllRBccszrtCFEjv/k6sDvdTL5z6DBFkvbQrYg84ZRSrvaBKJ8b3/GhfT?=
 =?us-ascii?Q?L+HzTZSahH2ALCX2NyHq7uMScmT2kIFD/G5yWO7gAo2WLq1oqMBAerFWtUty?=
 =?us-ascii?Q?QlDjZqq5epZEdsnRhfq8GfaaXYvIuMb0qH+/tHVvbbjYsbAQiOHh8grXZqdo?=
 =?us-ascii?Q?D6R/KLv5D6jSYQqkRDpix2kkAkzIx/ZVxTl+U8a3TVObrNo05C8mUL4asRMf?=
 =?us-ascii?Q?lHb7ZCWoiWppEcTNXTPlE1bU5ocdEnL2G+uMqRncf09GKKSxKdVfFQp6BRP8?=
 =?us-ascii?Q?EgcGQS1ZprARuAlBVPNky2pxUf6SNyPE7vOMFz68JHQ7/uodcqbnW8/DfhL/?=
 =?us-ascii?Q?0gS0OjLMCZSsqC8Rgf0YSC3MeCGUIJEBvvxWt11gWYZTIUqFecDgxLDR2XfW?=
 =?us-ascii?Q?i3HuBV19PeppwQj1LG3T95+PSpZaLfivXRF9jKLDVWyF06EjlyzWRUfFbqMj?=
 =?us-ascii?Q?qfRK1Yf5ym/rNcTh1i9K74sWAaCINZ0lQPwpFL/eRLnhvMsesY0lR499wtow?=
 =?us-ascii?Q?7Flov/IS8FZ4+cRAkbb9v7mXeOq13LFMuWm0nMbM0VVkZrRyxK3D6rPIX5a/?=
 =?us-ascii?Q?Gp5o7EAm91509fH84evYSx3tizAginMJ9zsfq+dfCfaKjU3vxHPyrPssiC7H?=
 =?us-ascii?Q?CTIgqMJS6wgLeYuu4b0d542lKBpqIDWVtVtnsE0As2GwPQZbqOATzpYy5Epy?=
 =?us-ascii?Q?wtHrD+xc0fvfwKdUKLf2elXy/H/MbKCsTBMMS0MOm8jKzb470hKu4j4s/gYe?=
 =?us-ascii?Q?LPL8NgWN9ybN9oP90ny6PHERO9QBeuB4nFdqa7Wtx50u+3P1z5GdAFRzh1pv?=
 =?us-ascii?Q?BjIa1vVjbrE1xDVyFWRYKIws2VTb+f09DU2fmjrHF3scIt78Yy4mEMUJjqLK?=
 =?us-ascii?Q?y7yZMTcmHTuoo0c4XaUrJ/bmGWNggujfrahP5RnN7QKtAMile8NhKOoFzjRV?=
 =?us-ascii?Q?kGQ8NQpqdZbHGBcYk0l1qUWD83S5FI7hENRHMxrh1I6z9Hf7WEdsUb6jvnqC?=
 =?us-ascii?Q?0zFgCnJEXlGIPJl81fRwHGDWphEhKga6pqQwvs774NFhDjiE9HLvrAp4U2vk?=
 =?us-ascii?Q?V2Dor1XWxPn1PxcyDmhp+KXtLYrPeo4STJkaj3MC9alpc2uzD4BUSSvPeF+y?=
 =?us-ascii?Q?6Lo+/mui6EUQQGf0DCoYW1eW7wdsLcnRjNrnYTo2zbW5ulJjWUop31Yd5A2Z?=
 =?us-ascii?Q?4ROpno600k0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZDJDaz/Xa5SAJnWryORMSWbFQrbvH5uCQ+MvXe/e3f5KrNgJPe/G/Vxvl713?=
 =?us-ascii?Q?C3OxJ1u8+WbuUoIIgLA5ZXfTCmWHFjCjruXhkSuAZBokdzOz2+Ae9uLENTLt?=
 =?us-ascii?Q?eHO49ahHOmhMO/rZCUKewmM0DycCEBcIwoc9z0OAinrlu1/NG0ipOiqYDNqm?=
 =?us-ascii?Q?R+57vN6YhqCgbyAORDi/YgCiBc20YRSRkkKuuddDgIGZxTKXTLGhPXYE/rt0?=
 =?us-ascii?Q?rZFCvFqGFj3HV18C0gS1PoVX/ch3FudM+VCBvxxjR1rJy3g47vVU+53ReKNf?=
 =?us-ascii?Q?EX0wNqHmRWTUK4zznJe56Ab4x0jBsUWuwqs6ntQJcHLU0/ZyNqsuayPDIMSj?=
 =?us-ascii?Q?NClLA4UTEZhKHqQwPGN27hmlt8aRAurdYPYakMrDlxwLOa37DM1Jpn+I25jU?=
 =?us-ascii?Q?X6r915pggDaztEWgARP3bL1QfSrlgbu6pNIDqES0hBkA7msWSp2eB7jS4UCP?=
 =?us-ascii?Q?waz5WKM3f2EiEBHw9zYKQ69l9ms7n7aAwPlWDMY85bs1XFo568cSw0eXLT8R?=
 =?us-ascii?Q?7u/waACZPr66hrjg+WqqkAXb6l4vHZ9uMImnj3re4c5f73wCY1W3eG+jSffs?=
 =?us-ascii?Q?M3OsSxY5QiGait5LCHt0i1Usd4h2zm6FG+rccj9byAjefpXb45cWs++jeOUk?=
 =?us-ascii?Q?lICPTUqrVXBATygHlCbDYWCHfqwaagbcSfC8U/ytWrqYdjePYyGp1qpMpE9b?=
 =?us-ascii?Q?rZJczFXFk2uDwHZTQDQbmfPyqJr3susQY4XNyYsB5L1+pZvg7OtSj+qqfhV2?=
 =?us-ascii?Q?68Pu9My5wx8f3wD7dld065+EI26LZoqKtaliR+r1vYqd9HQtNxWzZxZqLegU?=
 =?us-ascii?Q?ysnzjqKLR4g/voHNVpB6KDv4sPlIL4+ikCCZZ6Zzbr+QdggKd2hLh/FuIok0?=
 =?us-ascii?Q?VNXxQJxlzKEeQGsKTawNOXJ05muWikBGAygQ44lqwY0SUA0NPQNZqQ5ZyGeV?=
 =?us-ascii?Q?Y/lKdWknZMt/DAsUHnx1uvtTjwBg6TjFzriStNpnrpYcIlSo2DDG9HjmzgMH?=
 =?us-ascii?Q?3As2FwdF24bchA2qRecdcAi1LocWNneHeXzOSsxdRJU5dY779Bd8NY3tU36b?=
 =?us-ascii?Q?1OFtNZ2lzl/YbrEGhnMcCFgw+5uPaAa96zhTfk8uC2+YX8cec00nFr/vrooZ?=
 =?us-ascii?Q?uUsleGwla8WDk4ZrH/DOiocODhYe/0iapqpRlpG/ofwS7jRy9NLT6y/5fA9b?=
 =?us-ascii?Q?iMkdtBi1/uBSk8d9dXhqAzNOI5u38Aaz7oKmf8gwLhXg5f5F8JJLt3uOC2FN?=
 =?us-ascii?Q?lDzmK4mm7hnIdpUZI/wE5G9NHxmNyl+5XI2LQj/Fu+hMXMBN+u+mCXy+sSdy?=
 =?us-ascii?Q?FrAi78OmpqcMQTVB0ydF32UPNRFo+JEkXZWxYqXtUw3ch6Q9jSo/l/v4VQA5?=
 =?us-ascii?Q?VRFNOJk+a5z7rKFxzPhM0uVy+dWdZLsKZ+CHYqgF75EfAPJuCH5W670LPYyL?=
 =?us-ascii?Q?VgCaoLbS5Wm9RVw0xQRo0HtZcOR6Ik65rMyyhSYImdbvk86LZaHC2XbB+shi?=
 =?us-ascii?Q?NHjqV+N2v/l8QsX+TD4gI2sMozeVUJmyEUVi8bkLQJk7UBKiJT8o9bp/f5v3?=
 =?us-ascii?Q?1ZFcvVVIvaVRSRa+cr8hCgzIzTTe2Ay5iy1tMmp8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19b5d4d-ca31-4c1d-9292-08dddba4fadb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 02:39:38.7597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zL1a0IGAN0dGwjuJTlyzxvswAK4keFI2CtbKAmOKdb7OIDEZFb7RmT+skCoD+aja
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7226
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B147D8000B
X-Stat-Signature: 8d8zz9bepdgc8zkstbtydp7bfwxxqp49
X-Rspam-User: 
X-HE-Tag: 1755225592-454969
X-HE-Meta: U2FsdGVkX19hFqG3PCYLGKN4pGDItrk15CnCXkC3tdwMXMqxaY3SR+J8eB6yOPWb/WMc8uN8Tnc23AxPDceTtCtXrjCWW3G+z00uq4f+UNm/y4UsfaMsoa65/9eApYbzgFHfGqEGRIpakAm5gQ8aA4GFUXpviF2lepNrh77R3pOjZG51Jl9/13f65Geh8YeGZJE3sSKgDCt6cd3qgKclWzfMC0bqflvRkZpOiqm5ttWGjDkRj4qvmoPM1h7Y/6vO5WLypqxNB+wQ94uGUdm8uTSer28mG/Nuh1jxpXG73nUDi63vuK9dKkW2xHt6QUpPeJZ3rTWMWBe77G6UQC2YTw9t0BAIcvwkwdVsaUq9FzuX8jfwePMZJcHhb4SVp1EoBLNmCd5ghgjSgi3crLWmWTJUftJtKAWsYxRtPo2hvOncn0A+MqWKibHdzHNL5JflkMA7L+zZJV0/o9HJQH17le9H1N9SM0stS5ZSAOf5wwbPAy5OpBmicg0wGIDXQdE6rm0lCuCv13AAeaeE8F+5cKPHYtnP6/X7GjjSlyM3Ne9zjIRCj3kCSKhzLz7HrqkayRQiranne1rgq8UgBW1feC8d5P80PjUMl35dSUgRfHi4m2WIfvN7P+n5Wp5LmfNjLn9RtUz8dMxCW2GYLCzXlrj/FXLdbC/trUfXdWrkgVQ2PfSsgSldGckWqCpJQvF67YDKcWQTnjU4vgdKIU6MsCMt8n4RxEEZFTYlzT9tUEJlP9+qyYkWfJc++tSA77VnsUVzSBVhwLCg16zPiS7yHRztGi++8QvhtJciqTAoQsmh2SakVjX6N1Jo8dKOJTaUbIQr6WKV8Vb+0zx/av4RwDXQHthMg0ptTy9TIDkslc3bt5fjIotLaj/tF1ESVTJGyl+RMCv0DBgUpktBsUzfVmxcQdVI005OJur5H11LP0k/1c7INjz2t2esfSvtncF4k32RNBDjkXWcfuW0g8/
 Ljoygpez
 Tj3YMHHUO/JmRRTvZjCP0ZW/03Bq2SQ4hzuhB9MqeqC9T2/deo7WDc8SRwKRc4BbCS7COWwb1/9ao298Dawyposi9Bi/p9UKEwVb1IHXvu+cvEat/qYs+H1zgEn2Ji9WYQ43M0XSU5c13gLJAK2Ju8R5zeVxUv0a6xlJYSrYbvxWffqV7mwRYRrgJ7Humlj9MJclc8OMskQvO9KlVfC4pRsvsX+xRc3bRZeL1HsajbOdZ1qUP1pXy6cj6Wr56N+s3smQPgpniXKHcKEMRNqYRfvti/8i2DpaN6CmoGd+PHIhPXcgOl5aqFfBGy183P7K92YcoDkDOdc0J364ycGKCNkFJlmkMoHktw32aypo6dcYOfhN0+Drc5uxGkVNGce3Jwlck3iPmTmr0lB/uDCdJ3H6VRdM8zPQ3ETRYuHffbf2xDjvWpxJhiSf3x87CKY0rNsEFvEZUnUeb0sm6XG3ETeLGzbj7dlF6bP4bHGLvxoMU/MNW8PT4VD+Gv7EGrTCKJ9FYzVjhnY9zHbwECue6jfr5o7/Gnv2qp37pfXEFse2tv1I8BOiaYxCKVx+oNTmNyBdw90nul0RUpRJzFksyW5oY0OpH0o6C0Ig9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All functions are only used within the file.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 .../selftests/mm/split_huge_page_test.c       | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 5d07b0b89226..89d3dc08fe4c 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -38,7 +38,7 @@ uint64_t pmd_pagesize;
 #define KPF_THP      (1UL<<22)
 #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
 
-int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
+static int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
 {
 	uint64_t paddr;
 	uint64_t page_flags;
@@ -136,7 +136,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 		       rss_anon_before, rss_anon_after);
 }
 
-void split_pmd_zero_pages(void)
+static void split_pmd_zero_pages(void)
 {
 	char *one_page;
 	int nr_hpages = 4;
@@ -148,7 +148,7 @@ void split_pmd_zero_pages(void)
 	free(one_page);
 }
 
-void split_pmd_thp_to_order(int order)
+static void split_pmd_thp_to_order(int order)
 {
 	char *one_page;
 	size_t len = 4 * pmd_pagesize;
@@ -182,7 +182,7 @@ void split_pmd_thp_to_order(int order)
 	free(one_page);
 }
 
-void split_pte_mapped_thp(void)
+static void split_pte_mapped_thp(void)
 {
 	char *one_page, *pte_mapped, *pte_mapped2;
 	size_t len = 4 * pmd_pagesize;
@@ -265,7 +265,7 @@ void split_pte_mapped_thp(void)
 	close(kpageflags_fd);
 }
 
-void split_file_backed_thp(int order)
+static void split_file_backed_thp(int order)
 {
 	int status;
 	int fd;
@@ -365,7 +365,7 @@ void split_file_backed_thp(int order)
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
-bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
+static bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
 		const char **thp_fs_loc)
 {
 	if (xfs_path) {
@@ -381,7 +381,7 @@ bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
 	return true;
 }
 
-void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
+static void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
 {
 	int status;
 
@@ -394,8 +394,8 @@ void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
 				   strerror(errno));
 }
 
-int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, int *fd,
-		char **addr)
+static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
+		int *fd, char **addr)
 {
 	size_t i;
 	unsigned char buf[1024];
@@ -461,8 +461,8 @@ int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, int *fd,
 	return -1;
 }
 
-void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
-		int order, int offset)
+static void split_thp_in_pagecache_to_order_at(size_t fd_size,
+		const char *fs_loc, int order, int offset)
 {
 	int fd;
 	char *addr;
-- 
2.50.1


