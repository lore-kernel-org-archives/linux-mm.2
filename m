Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8043EC1EA9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6576B0099; Thu,  5 Feb 2026 07:07:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367186B009B; Thu,  5 Feb 2026 07:07:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B9A6B009D; Thu,  5 Feb 2026 07:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D5A576B0099
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:07:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 747221B24D7
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:07:49 +0000 (UTC)
X-FDA: 84410279058.15.C1E964B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 245D020002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:07:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jknTC8Nd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DyDIOAHN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4B52t05kmoxh/B4caIHuq1ys5GF02q81ZMIVYCy7sM=;
	b=peGrQdF8cLha0RKdV/easVLnDIoiUYT+7eGWl1hAa2UFnX0KFfdfs5e3xaoAwtW1o9KeKN
	6hlTgQbaZVBfaPcyXNZhOvLNWbXhQUz8ljMqd/vb+xRaGCD/3KdqECOZKgahzaap8x5dYs
	rmhNcEB67oJVNcZ2EDEiH8bwMJ/F4VU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770293266; a=rsa-sha256;
	cv=pass;
	b=VFl5q1+IggWTVjo2XiK7vjZhvxL8Ywc1AKEkdIXWsh9Juy1BZ6V3sUdq6S9/s1RWgKe+YM
	TqRutoXxPUzyjjjh9/qCyodGeubXmZ9RDEqiKS4Ad4Uz6tGLyFvxC+qPAaJ2O5eKGCyxwt
	fqx8nt5UItb8NwvABaBBP7qTSXunHrM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jknTC8Nd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DyDIOAHN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614NUJmC2399904;
	Thu, 5 Feb 2026 12:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=r4B52t05kmoxh/B4ca
	IHuq1ys5GF02q81ZMIVYCy7sM=; b=jknTC8NdDreYUeQWok4BLOewSvPj+4jU57
	q4h0FuexYD7zPXojqARNAsWdpttWtQ9cm44tiFUa8oMocdeHeUm8xlKvzcm6HPGR
	YxodD/UqmY7i4XhZqDMDi2cfFO7BGoYEHmUWJLtJhgOo/jk9TmON7SSoE9dSVLaw
	IWbIlyRKj2kuk7/xmLPKJFrHOm58t8+GsWtT7P290HliMnkTpuXNgqtAnIdRTwv5
	CvRuwTRrB7at7OuYIyX4MdZL9OBwy9ACz83YomzUHAbbj8tqxYE6urbA6p2VuDBi
	T1ar7+wWMK6RF7cYQtW1FuHttpPVLg0IkgOJ3X8bPPcFMJpBX1Tw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3k5g3drv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:07:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 615Bklrt018820;
	Thu, 5 Feb 2026 12:07:27 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011066.outbound.protection.outlook.com [52.101.52.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186qm6hu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 12:07:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJ6z5bPcRhEM+tclkwaAt6iDG1+78ZmSxOYbyS7OUhbDbnRzsJwKAgGkFbQjhGrcAVA8PzJQf32L8JgeA9DybMg4oLUqYzv5wbqMLGOTDOhE9jTKqMoTaUMc1TOxQLP50Ge6U5At9of5hgI1BlwHtdJIBbLjOgwWoxjWIoYrvQzaUt08iiHutvmNj645ldGQQtU34kbjMwimcBkGhm6plxI1EtDAJYmL9/yVgUdM501MZXz2en58U64o5Y6adKcjq0i40H2BLKR7R/3ktPC8zjuWiIgXO6QUYp3HxsoFUl0/OWt3iSHpbZZtMlyRkzNmwWEFvHZLLjgZbitbjMycSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4B52t05kmoxh/B4caIHuq1ys5GF02q81ZMIVYCy7sM=;
 b=DhoWL6cdtsp1awHLCG9cg9Y03O+nf9jmth0phjjMd4cUpra9t+ByTskk+GIcs/fW//YGn29KoNhwU0wC/jRtSXEVRA7+6zHSxaNBbIYfsa3MTDr31ishmI4pmnOSTCJVSjFGDtPUnvF8HXmCn2Pjt5RXcsxhVUusg1APToD0S7BvDdaRH0GJOFlE3y/nDXrYOaY2+xRhhsB0SXzddoA6+cqx6LsuqUBmI5bS1KSB5eNbsKmdSc/Dna2MqnPFa3tR8J04VidbIFPbF3n9KQVsVn1lf8n4GE2w49lcy8uD74CU9GwEPvL4PK9EeHDrGX5MMSSr0jMQeGFNGQdorAwG8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4B52t05kmoxh/B4caIHuq1ys5GF02q81ZMIVYCy7sM=;
 b=DyDIOAHNN0NzYE4ypJSW5nkpqRzOi5FsSQP2rNI5MzU9zgwf/93dfWlVebjBOjHVyN5+fJT5U3pHiIhHucwD9hJKt0fo/EwbvDPKQ/md+bdfwzK58pRdWcZlNMolTwuwYJV7fly5L3mKU6LOf55Ez6odDQv2Mu5voR+qfAx5tKs=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by IA1PR10MB6219.namprd10.prod.outlook.com (2603:10b6:208:3a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Thu, 5 Feb
 2026 12:07:23 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Thu, 5 Feb 2026
 12:07:23 +0000
Date: Thu, 5 Feb 2026 12:07:22 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        kernel-team@android.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
Message-ID: <26027467-76ee-40a0-b5e4-99c5f77bc836@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <d122f9be-48d6-40b1-9da8-cec445bd8daf@kernel.org>
 <4a36c1e7-e51a-4c06-8f7c-728b278af972@lucifer.local>
 <d309b3f6-8959-4767-b262-7fdb957669aa@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d309b3f6-8959-4767-b262-7fdb957669aa@kernel.org>
X-ClientProxiedBy: LO4P123CA0131.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::10) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|IA1PR10MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: c5cc2c50-06fe-45d9-0b87-08de64af1ed5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/9xKyHyXWf0AXtDXKEWM5H2HB/gaVPdanwJR3S26DNktfOE3HYRVqUrxQzAf?=
 =?us-ascii?Q?T7bHFcNF4mx14rvs3NTZjVIoa9GRsB9UUCX799gOf5fK8wQsP7nEYTCJEPH3?=
 =?us-ascii?Q?Iis+RDjIxUFfeAmBY32qMTTnCm0T2PcZBiIdDNIVoOldi04c/kJ1FHF8plwX?=
 =?us-ascii?Q?Ji/CPwHyAwUFcB5TPIxaEgjRIfNZBxQnGtMDHVIqwg3yWF98Dn06WZ5dxKAa?=
 =?us-ascii?Q?tDI2T6ro9E1bb0XI/iMKL4KUlBspO6OVKdgZZNOBSeyTImPga9opcNIR6sDu?=
 =?us-ascii?Q?nQkGKw3VfuB4UQFrr3ktWPUIT/8G8xKQjB/SDYbozGLJ7Gc1Mjpm4fjMgiid?=
 =?us-ascii?Q?zTsoJZYrYm8rqa2jOcLXcr4zJih5klDGE6AVIqMuD3dZlVwTudY6KF+yMq6L?=
 =?us-ascii?Q?oeU/+QkZHHY4MjM8217+7xVVTUIgJ+lKhcHHx3kKGoVTKLv0A4fzNRkPrOrG?=
 =?us-ascii?Q?4693GvcYT78FRaK6IHhxkU4ZNVGUaqVQCFybcM0s49TruSr9Tf4338RVJUvw?=
 =?us-ascii?Q?CEe13cDmrZxEGYBEhJeNnkRHpIahsTGmzC2nWWv3Jl1mLaUaPQwXnC9GcYcD?=
 =?us-ascii?Q?TZPsCeqvt4bficBjRG5EgEf/UuX/6vfsrirCVzsH/7vHEn6mzp7YSiYf9Mxp?=
 =?us-ascii?Q?d19fa8ee4JIkQIrI8cAUt7t7WxOW3ns2XWD3wb0RK2iuvj11kBi+vHjirgLb?=
 =?us-ascii?Q?chHTAaTIbX4PswZwF33HWLbgi7RzTTbXttmk25Ehukfkl62/MiDHqMozHW2/?=
 =?us-ascii?Q?VZffhWD4B5/AOd3noD093O5ufg6gIuzIpSm2an9Eai7U0axdrCu6TRdzgZhi?=
 =?us-ascii?Q?UBvXoIxMC+G+jo2CviDqZjZw7wyc4BfO1upUJEUn7bWlJ2fiEJMRBUkr5+NP?=
 =?us-ascii?Q?DU9Gojw5y+6bY10kuFqav5gNFIs2voXWwt3SfQS3zQIA8sm0RgY7PiqcwC5i?=
 =?us-ascii?Q?YwNPGF820yphyBdDHTVdf+eiTcPKTq91mlmMY/fQSKy2hWImFLqqZFTR4SIp?=
 =?us-ascii?Q?jpxnx4+zBGFWqWyXDFj84wUFgN7KP5kMVyaG4PzrdPib7XSS02AKxIac1gnr?=
 =?us-ascii?Q?u/a9Wq64vuUEul1JbJcHHXk1W5PMwZfREj2EXtXQc2TGeQefutML1xroNa+I?=
 =?us-ascii?Q?bH4nGr/hQZC8jaZFRXeEeVzcO6c94uXd9ajXKz9dKCPh5PkX/BSZbmHrUf1i?=
 =?us-ascii?Q?uCdEu7upNp9+rKZMNl3EnP3j5K0L0BbENtltIjr590ED2OJLP7osZPuXEYQ3?=
 =?us-ascii?Q?lSNST+veMpWRZ25Wv3cahXM93pjv09oKkTVj3DvG5ilkaBBGylmtyN/AJfc1?=
 =?us-ascii?Q?pIiXsg1IlwYtFAih6DM3MARChwDbkwF4OvtTo+VZEGXCbnDKJtQIKmr6NPgS?=
 =?us-ascii?Q?IeDmymVDoKDx3aTGMqsGauVW8Jey7MhVEGeE1BQbwzFeV1//L92wR7AQTJfq?=
 =?us-ascii?Q?bl+Z3/zOT2cr5DG9NKbLnce8c0IT4G9irrO6RGuVHU8dJKy/mdni14ZxGOwd?=
 =?us-ascii?Q?yEmkd6OwCeLqia/nL/9HQ+W+bE2bR8vOMn5kpo+asFYzDPKHdi1CnkgnoZeY?=
 =?us-ascii?Q?WDIhnBebom62vKuoA4s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?25Ka2HGGTJvQ0TCStVvoUuknFTCrAG7zOcqDrckzuEE0O73tyzmLy7lSoTVv?=
 =?us-ascii?Q?y2YvACepHIPq5frtdEj3Ul8oGRAoNN/A6pXLxwwTM/NXVQG9JMek+iP3+T9B?=
 =?us-ascii?Q?SHP1bvi+EqCJWF4XE9el8H15r9VNtynC7xt5hE/Ah2yqe3fHCtUILBmFCXUf?=
 =?us-ascii?Q?LZp/G/oy9A0X0HQnO5hhKVUHJiYcifjOzcUuqx0f5sdMWSCOXQFnGbzHMZzl?=
 =?us-ascii?Q?ia7pNofowyudWwYsPSkl9fVw1NhmuyUGDGroP/DNQHXa1jNbFPI/7X0EY9gN?=
 =?us-ascii?Q?lRYHDXX+r4PMzOKirunsE1yQTzIzh2hHV183VTP3WrvfnyQ69WBo0BOYOV0I?=
 =?us-ascii?Q?TKgAsfCRU5UPvAD+2g+fFAjGOWrjbR7jXIHlklqjX0YVLMIQNS5IAOpHYH+F?=
 =?us-ascii?Q?mRZgBNu/HtqQWguzCYCNHgDLvxJNDb80OiJVdH0wyuyoJ3RXh887nKPl1fNB?=
 =?us-ascii?Q?rVkq3QfEu1iad9AvEZAPgTS967Ku5XSnF7Gax9t9KuD1Ggy9HO2sH7E+K6Zn?=
 =?us-ascii?Q?hPiiVzdI3D0MdqMbHYudJeyCNclFn/0DNodxfQO648CwNTXrYM5FCBxe8miN?=
 =?us-ascii?Q?QlsvL2QQjORdW+0GJSmkrITW0CzNtSYAE46HGYt47ju1m4czmIA8XgDgHJ4M?=
 =?us-ascii?Q?BGcSDTjMC/Ryo0OePCspyr1il7R3st/y2fxX637sVrpMpLieAXF0WgP39apF?=
 =?us-ascii?Q?T7LVxxCrptYPiUNHSrboiyy2B7XbsuwAO0LWxV6uoGw+ZGiFva+vIBEOIoKr?=
 =?us-ascii?Q?1NRrHjSgEDSsUOhpiGwmi8fxsLRvjW1eswAJ850mj8MEvU8RdlZc7WTavuMp?=
 =?us-ascii?Q?poIoz87PIE+o7L3cP/IixIt+u0qmdQ5Ebk2pErEZi1HOmHwRuaaOZ6VRpGfu?=
 =?us-ascii?Q?6pzkWzRlGrHD21ua4GjMnFfdINu16FIPstilQT5rtlHuQiCWTrP6bDs8J0Nu?=
 =?us-ascii?Q?rGT/6RYtAFQwAD5nO/RAqO0nJM/ZF/SotbyHfeRd/ZbVCZpcl7Pd9LkvI/YX?=
 =?us-ascii?Q?6IpWi86oDThIA5WUByTFVioTiVVQQ1jB/yGeKUOs0dS3uJlYp9UMHzWUZapf?=
 =?us-ascii?Q?XmgTXNYUd67xb4JsN0kHQK7FD9W+ljopXlnqSN/sarNLnm1LaRfQ6vagpL6R?=
 =?us-ascii?Q?Ga/GXMkGuehVTmkM9eWUNTDY2Nfw83VPyog5tM0FJpDhYNM6dp1/GHJMWnLA?=
 =?us-ascii?Q?PeCG9+RdCGm0pW1PebtyZSNvqlQCUR8k9Dsn5fKuYTJW6NyvLzv2XblD4TsR?=
 =?us-ascii?Q?Ii7ByUK/vLlo8YXyh2weVJNGaaZfeUu9+dkoXU1V8QYMGo1J6AneHxqtE4Tr?=
 =?us-ascii?Q?Ez1RObijjrk8pg2/1+TO9l7UuRqqYkQNs/ZE4QLlatYruBmZDtph/G/y8k7g?=
 =?us-ascii?Q?+/ZBQS1OWIvLDrEuYAE4XALB5zHJLpBicqplBWt/VOk+2JTNZ+GbE8aqK7PO?=
 =?us-ascii?Q?u5mctQYhAGBJ1kDYkgmixPJnU8ChiOSJV/hFc7AbX1W2YL0kwLJU9wLUvfRc?=
 =?us-ascii?Q?ChtyEuDPxQTraJnbVUjKV6qccjbJUgQwVwvKMtcFrC0EzzuPKVta06HOkpVv?=
 =?us-ascii?Q?lHHgHBREhhJHiw5BuHPRzMQ0VBn2Yf45ahFoff2PMDxRInEqj579WrsXXKyR?=
 =?us-ascii?Q?IT812lM2q/dAVDVLesGzbgxt4hPnf7kq5qGmRZO91NKVrmEv3yRt2yY9DL2v?=
 =?us-ascii?Q?s70fI0UbXCLnBMTVFNNz6a+1p8G+H/gsEGClJAeJYpRrKqVnPNfM395frkEE?=
 =?us-ascii?Q?KrR6ywjxF7oylCjcA3m17CuJ5kVGEDA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	btpqUMiVtO+5sITCXF//juXIhE4hzu98J3tro4fXdrUAuDzI4rljN5YY+6UqqCjaHr2WJmHNDBBLZRyiwTMnovx3DW6odzWZ77tuslW4cHE6JrkfbPDaVxdKGtBoXfDTmUzLQJ96Wce8YhV1gJnFv3dN4SDGmMsSyzVcWCTtIJciY7XjglWBO5mQvX7wL00oldqK8DGdN3AN9NvSLd6De4gWsmRCHKXvvaJ9rNXN/0y/VWWPnZYKUtreBmf3AVerjmw1uWxYGRBDXf9pHNFKUC2ponwx8Q3A5SY2gA03ePwEMHbhP15Wi+V9vQ5F0kF/pXjaQ6KyxAqpIBrbvi6meSW/0rM7zSil3QNGHZKFIFf+XjifnoRdxM9CsMZqVE0XVqw+YZ2vG4G2ccvEKNzB2VUJXL1bK0eK1k9u9/Ts9RMSQcnfY/E16WjNLJMRzIVaXcCGiTWaPSQsNZ4pbQUbRY+f13e5cVyJROTYo7nlZIAEUcHznooSUd/fQiToRLBEyFvdw+uHkY/RnvcCU5kalMBuZBRJI5JOMP/2Ak4UgDUgL9+TyHHXybf+fOC9AcHU/0abPEbfHJUPGczgArNxvRgfqV7GLecKNj1rM/WUdwI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5cc2c50-06fe-45d9-0b87-08de64af1ed5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 12:07:23.3400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ED8t4k9rerONxDXK7a6yQPEWNvdG3jOYXXqZNQ6NSTDzy4CDpcOvqc/ctvQKnveCrcFK4MP3ZeDjBjuarv1OWPtAgURv5Y/wAG/06x10eQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_02,2026-02-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602050089
X-Authority-Analysis: v=2.4 cv=Jor8bc4C c=1 sm=1 tr=0 ts=69848800 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=dt6k-L5FSP6_vD0C1rIA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: XmN8G6whPENdECdgudcDeji_S-oBRGJZ
X-Proofpoint-GUID: XmN8G6whPENdECdgudcDeji_S-oBRGJZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA5MCBTYWx0ZWRfX9ePFBn+2Lfv9
 6C11xx/d9RdT7+YM2aEt1Lj8la/imzLzlFHciN3Kd3zEEWYHsw5Bl4KNnka3pTRRxk7vJZ1Wowz
 7Ttkazty1J5jfcskSTpW6xfuzz0hPUaLNFjW53CzJQA9s+o8KK7vS+JqgwL6pyhtIJ5M7MXw9RU
 izHVP0cUe8ktrsFK4jVWjhkJMO4kSyfJFo8rxzdjSd799mOvZ04Z6zNomioIetXH7MjBiXwNiPF
 Kr7JQvN2sqohpzg6XsnBZt5XP/s6AvaMKuvmqCI2VbunfG1ZFpxPkjXln8FglHHfyd91SDdTrdO
 sHashrcyb0Enlw/0rPyiw47anv+AAskYRgZR9igiy6IvL96PgX1d5KZL4TUgRCdZxro7aixsqrP
 RsWIH9Q2g0HOj1Q4JBzCSyvtnopeA/8u4OKIPY0WQFec0wtMp2QAZchoTHTbWj1sB0lklYWnjs3
 wXACrZtLPndHv5pAbKassQZNbXozVcTmGSr+8QqU=
X-Rspamd-Queue-Id: 245D020002
X-Stat-Signature: u9nsaya1toenksfz7tszxd38pjgethmi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770293265-453462
X-HE-Meta: U2FsdGVkX19+AiD0kGGUtpeaHm2E4AJwOWhmZBO+JxdTn1qWEIYdtNBuFylYW7OCivGlF/KtP4k3A6X/QeK9ocYlF5yViTcOZXEIUn+VUx6Ij9d+hXiHtjx1jhKcdrUqRvfcWxXJqBuMiwZfDf8nC5wPr5a8iIqxEuooa1Yk3WJGkRMswMkxGKAHQmCIE04uIVLrMkqVPPrAjcm6S8G1tiXATxNc5y72ro+eerEa/YeASZOQuT5DNb8Mn5/+C66efAQQWkFhzS0bQ9XHiQBKGU8diHKGaZMjNO7d9i6cONT7V0dmF2x8anv8f7U5oK1wG2dr21Mvffcz+P8MP9/ULybCTrvnjr+q2DaeD+kf7HdjOsbCW3lLvxChVgO6+wl0aq26u59JsOZb/HOic4db4wHVoOjRSKiK+rjwtP3eQkwl13Yc9bLX36IFbvvxA9+3EPtAvL/EoGgn1OGUEb+xSEoIoPfCc7dsCV3T8vvvSLEOBYmAWaXxHLLaLhyLKX/xGrZCFkl5csNcYZgKoLt3q3a1Hm8ik4+bM3baV9Nnfpzly8EyC2TuKBoDGh0Pa3v3DMGCUqmJzpRAsufXf+Q2HvrJd30FLGQxnz8TGag6VO8YKWmALA7SqBT9LIBayfrUDkjPBh24Y+8b3G0ucnpP2eWAnbJk09qVLeESjzB6ECIY1D5v6t0J3L6owk/NqBUMQGqqh9rKRzqUPJKNbawfFzeCksD8rdEs943WPsZJkwNyZQPh+Wemv1gx1YTHFNSwkoRLqqR0XicZoF57cqn9n3QQzTKQZn7c0qQN+BvyhMV1ZMNhjDsw8uo04acycZ6/QK2gj5E4Wtwlhr6A7zmPm4vV4xkCZcFQ7nXpgx84BZDdQppfmS7njXUm8Tx4wSEFfOstzhXJ9ORCxcKuc/ECXU4EzCQLeTYualmqvT3DDMXJQId/ye5Ml6NZ58/IW/CITmhLj2itYPIbQ0iT1uX
 sUPjnsra
 YGweAUARJpq4JgUqTWUHVFC0hqgMXJCHL5ZpDFJBgGZlgchnxCtYAIJUZ9OPqw8kZ1rtQJi9fgALNsZAeKHB9SCZCnV7iiym3Vkm5+osGi4FBJFKooySvX5Qd5LsA47Omlt+QQk9VJk5KFfc/xv5BHyR7dpea7Y49DY0V3XMrbioKzK+3k5wPwp9A4+uRQW8MTEvwSlU9LXNzjs58zTCl0N1Z5UmYAjOho0xzC3XFU8XmfIqDYduCc1p33ZnXvGmxCY5H4omUKkhSE3JRcPLM0AFb9z5b8B11Zb9lwwizzznudHdlEzofWKb0h/iat0J+WbE2i/Fv5UNmmPVSHtzRWLyWmCU2drIZfjUDpCNkF8FSIfWAXMfRrFY0I9fRO2Vtz2PI3r5/ij4pUAByo5IARwAgb2k3vhwkgsNo2EXGufhIHExIStadmLzXTDkrTy+DUIw0Vlw80kuaYCXWG5JeR1mqeqs3hFI71y8uQe26OXcrBubg4CHBZ6AVRWcF8PNonJSW8uff2+A5ALSZ1GePaOkFUupQkzENhDTBq0E7L1j/GHp9B8uzP993SIAbGgO8ii7juo+++k0yGle0Vs5uItKX3UmsrjXZr9P7lX/YuG5BvMReWvv8P55PPRaDGZnY1eUt+dhtPJjKKHGOPUc3xD+JEvlJ5BHxuC8+ec14C2FRbDJUfvc3OlOrQxbbKude9RH4aKjGdV/KmHrJbNApVRmNQxm4Uy71yRnBBqDdp/8Y/cM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 01:06:10PM +0100, David Hildenbrand (arm) wrote:
> On 2/5/26 13:01, Lorenzo Stoakes wrote:
> > On Thu, Feb 05, 2026 at 12:57:04PM +0100, David Hildenbrand (arm) wrote:
> >
> > Dude you have to capitalise that 'a' in Arm it's driving me crazy ;)
> >
> > Then again should it be ARM? OK this is tricky
>
> Yeah, I should likely adjust that at some point. For the time being, I enjoy
> driving you crazy :P

:D

>
> >
> > [snip]
> >
> > >
> > > The following should compile :)
> >
> > Err... yeah. OK my R-b obviously depends on the code being compiling + working
> > :P But still feel free to add when you break it out + _test_ it ;)
>
> Better to add your R-b when I send it out officially :)

Haha yeah maybe...

>
> --
> Cheers,
>
> David

