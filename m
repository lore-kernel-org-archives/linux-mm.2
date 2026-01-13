Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA324D2F35C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C60E6B0005; Tue, 13 Jan 2026 14:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286E56B0089; Tue, 13 Jan 2026 14:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118426B008A; Tue, 13 Jan 2026 14:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 008126B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:11:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4C64160246
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:11:53 +0000 (UTC)
X-FDA: 84327885306.13.B4FCE33
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 14E7D180005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:11:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C6wV8uVD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jjpzNxyX;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768331510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZH6tKmmE/dl6TgshkxSUrsD/IQqeFuUPlwqj8OaDnQ=;
	b=Gd+CnSYHwZBEEn5ALtRlRaRMa7HoNWrBn5kbj/hvAeYmi0yelAF9r1wB+kSMxyk4FfvJZc
	BSZlBVk3BJvAN6ag4jJqtmPSjW7yCZ+kJ4WQ3Y66nnzO3HOUPV4a/9xZR/7owfIrBLATfI
	hijMjg1vwalhcgcxx6eDGECUy+LrJGY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C6wV8uVD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jjpzNxyX;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768331510; a=rsa-sha256;
	cv=pass;
	b=UjwO7/dPRHOpr+K368o6MhHq72kluxQpxVGzXjt+jBKgYem6/V8rjfa3pfCTxScQPAuhRE
	MxUR9eQ8JCe+1KxiU+fvvcFhu5YMxowQBQIwTb5Z9CuMqn8E1yvznvyyte3Kr8Vu8ncwXI
	UmPkR2Zb9kJOL36vXQS1r+HFF50FT98=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DGAP6L2396098;
	Tue, 13 Jan 2026 19:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IZH6tKmmE/dl6TgshkxSUrsD/IQqeFuUPlwqj8OaDnQ=; b=
	C6wV8uVDEIIkcHGvY2jJMoy2j8nb5cRKVPjcirms3V/DMlCGNHAPWUCt7qIGCHvN
	M8Shu7ZSXdF4mlsXFnTr+smpkZBab4BqFvbHlaBKuFnMfXLBtCbsN30RQoLiTlgD
	uiQofQmKkVMQFQo35S/wF7exdKAl4fdVq4VGB97XDpn1RYqB30L/Q79Dj2F8EUie
	XR9K3G3ZevO3SXLpPcHcB2LpNiAz3PNqATLgTvnlx0jIkRvF7bIY0ZqcsfVugG+h
	z5xWCDrubLWsehpD3Onadb30An60aB+tYQCiCC/zua58n5YAPUoU1FUOq00CpvzL
	iEHaPmbXdmhxhCxh/vppsA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq54117-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:11:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DIrSCm029243;
	Tue, 13 Jan 2026 19:11:17 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7jvkpr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:11:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HLyiEtlb2ocCOBdpkPf85yDFD5Mhrr5FGlDiRg7OiomTz/Q1OaOBT0Pl2X9b39mMzG7+LWRy07axmi2ZBTAaSjEAeUX2/JqKEpJuBw25FQZp5N9QX8cxp+Bmbw66IA8rILcqB6Aiyqh9Ios3WlEf6BRXtWLiE/b1uoVNRv87JOUwTnBCe0BXkoBGfJ3bE7DQ/S/cnvrUEDv8kBNL4rZNmXED0CQjkZEws/VMY52GrtuQkH+iILGGh7XikMIy+bkGy08boO+3hhQz4ZZyCIOb4Pxvx2DahkQHCEzv9BdXqmzS677gaueNdAjauAARGnSYIMFRFXjKj2j4OoIQqJ1lRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZH6tKmmE/dl6TgshkxSUrsD/IQqeFuUPlwqj8OaDnQ=;
 b=fm1tereze2Ff/krtxGRIPKsFXo4C6UbHQIM8nmTZcL0MJK+7XGeJGAKInEaqhHwcDFgBBxpjQw4URzU/ie4146BrQeF31yfFZBRadcbFGJyEi/WR7VOCNwMI7do5cz9owkZzG6hCF+8gLT8yN9RMqG1PtaIAgf/4oXyKJCCVGtU5BAle3508lyO72x0I3XBo+hiiku2MntpqoYiXdQY++tvEvr6QJ1cO6QMtOO3oV8hbVYfwdqj0yKmUryOVJnnqrp/X+x3zB/dPf3AqHQVioNBv9ouMyVl/DktwSkvJXY8vmSYU9NW7phJkKzck16jLXo6qndKgJP1QrvIFfOzcAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZH6tKmmE/dl6TgshkxSUrsD/IQqeFuUPlwqj8OaDnQ=;
 b=jjpzNxyX0u2KRXpSgRTrdXB//DU2ceuc+1knqXjF/DP9aPmgN5okuHmlT9x/G76idRYyC68J6LDxMiJrwd6PnE0i9rsdKd8Ee67rV3xVRNKTaVMzk71DKbh/RT8lOOlDHcXALH30vHWrIxWqJ9ONbfQC63p/0bSMghWRW/K4ZbA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB7214.namprd10.prod.outlook.com (2603:10b6:208:3f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 19:11:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 19:11:11 +0000
Date: Tue, 13 Jan 2026 19:11:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 1/4] mm: declare VMA flags by bit
Message-ID: <070b76bf-0d18-450c-a1a1-29f3a8b4925a@lucifer.local>
References: <3a35e5a0bcfa00e84af24cbafc0653e74deda64a.1764064556.git.lorenzo.stoakes@oracle.com>
 <20260113185142.254821-1-clm@meta.com>
 <CAH5fLgidETM3aSVvLRxnA4oaaYWH_KN+qGMkQQf_GpWsjHkpXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH5fLgidETM3aSVvLRxnA4oaaYWH_KN+qGMkQQf_GpWsjHkpXw@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0431.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB7214:EE_
X-MS-Office365-Filtering-Correlation-Id: 42a7abb5-57b5-4633-2b8a-08de52d7838a
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?blcwaXg2YjFTdHVOU0ovZGN4ZDhaN3phL1hXRzRJenVJd3FyRnhERDg2cU5F?=
 =?utf-8?B?bXBqRFBRdzFvM2dLaE1QRmZYOUdOSnZuZzRMeW5MTllDT2RGSkhQVmxxRHIw?=
 =?utf-8?B?RGdaZHAvNm1pUmZra3N0Q0R1YWRKZnJHSC9nOUIzQXlIb3p4c0E3ODJrRkMx?=
 =?utf-8?B?OHRjSHZlMzFNbU44NkRSRmFJaTFrRy9MQnIrY3JZTDk0bnNrRUFhOTE3S1F2?=
 =?utf-8?B?Y0Q3aW5jc00xamp1dWlYYk85a1BmWWZnSjFsNUkwTFI3ZTVnT1AvekI4V2FN?=
 =?utf-8?B?WmRKRSt6aEw1Tks5ZW1PcnVwaklYNXE2SEJ5RnlpRXlJOUVMc2ZNR3N6bUli?=
 =?utf-8?B?NzU4dUZZTE5vdnVwWWNtSks5blJwQWZrem03Q2xaa1R4ZTRpNHJTNDNOcm1s?=
 =?utf-8?B?NHVBSVFVeGROZ0NoMzdYK01oOG1VcUpKY0xpUG1PL1lkbFZqcCtFREtjcDZX?=
 =?utf-8?B?bFh0Z1RoQytOYTVzQlhIWktMbjZaS0hIeDJRYkN5TmRxY2hiMUxwcjZXczJ1?=
 =?utf-8?B?UzI4c3lQNG5Md3pIRWEvR012TkZVTFVrMGtPTnN3ZjRlVEtwNE84Q1Z1VHNv?=
 =?utf-8?B?MTBTd2Y0d2RyK1U3dk5mVFVacE81Z3lPQ0FkYUh6c0FkRlpjcXpDWDJjamIw?=
 =?utf-8?B?VGFrYmRqV0V5L2tEQzdSQ3FaV0liYVU1OTRWYlA4NHlHRHFTblZrMllzS0Q1?=
 =?utf-8?B?aHJBeTdTMUtqVVRPUzdwT2I5dE51NlkwTlVQRUJsTVRSaGdZQmhMWldsMEpI?=
 =?utf-8?B?OUN2T3IyaG9NVmxGTnV1MmZxalFLdzRhZkNaQitJM1p6SEg3V3NZd2QyWUpJ?=
 =?utf-8?B?SXVFVnRkZHgvNkw0SVVHbk95WWMwcmVPMEI2OWVOYkF6Mi8rQ0xyUlErZkM4?=
 =?utf-8?B?a2FTUFF1a1hEUDMyTEV4UUpqRjJmTWNKanFpMHFhUUNtc1ZrMG9sN0xBODFB?=
 =?utf-8?B?enJrMmJocUNoZUcxM0ppQVZZbUZBdjJhM0xWdzVtd0szdlFGckpwVmtmc2t4?=
 =?utf-8?B?T2pPVHRpSVY3aktVdEY1aDd1dzJWMDQrRDVJVno0VHpXcHpQNnFtcFdUUlQ4?=
 =?utf-8?B?VFBmdWUrbzFKaUNCNDJDNmx0V21SMGRJNmorcDZ4bFFvb1pXUS85TWcwTG5x?=
 =?utf-8?B?VWxWUWRzWnlJY3NoV01aYUFBOGNCREwxTzlCNlhqOFQ0eEd4UExKcVVRYi9j?=
 =?utf-8?B?SlhiaVN3cnpUUmQ0WDgvd2xjQk9mY2J3ZGM5cDBJMWQxUmZYVDlZZmp6VmJa?=
 =?utf-8?B?TGlDY01nUDNlVlVqYlhjdXpNeEtWK0xtSzBZQ2lmcmgrSmw0SXFOQ0VTOXlv?=
 =?utf-8?B?VGY4eVZqUFpLWkxlditKekFnbGIxVnhoeHhQNXoxa2lVamloaTNpWnZlcDZx?=
 =?utf-8?B?UFVRaEJlWnExM0EyaW5SNW42eUdsa3J1Z1gzMEkyMHhMRWlCWmRNVGdVMnpG?=
 =?utf-8?B?cmpQTU0yM3h4UlR4bExQczlDQ0RMYlh1N0pmU2s4eFVRMnlPRTZqYU5Qc3lp?=
 =?utf-8?B?S3FGTlY1cC9BSHVpU0tkL3BoamlxRnJ1VTMwek5hR0gxMllITU1xQS9UaUZz?=
 =?utf-8?B?Qng0VUZ1aGZ5ZzJseVVtQjcrZmc0WkFSMndpUWovbWJEbjdVWnhVcDg4KzNX?=
 =?utf-8?B?TEViUXJoWXlQWFNhd0N0a2JnQWxDbkFXR1lzdy9TUmhib2dHZnZESnllelJm?=
 =?utf-8?B?aFdJdUJLMDk4K0lWdzIzbWZNVTJsSWZaM1J1TW5ZNzluYWZZemFvdFNWVVlo?=
 =?utf-8?B?OWFPL1RNVVFuVUp0bGdIa2hObEZVbGRTZnEyQVQ0dkpHL0ZTNEJRNGZUMjRt?=
 =?utf-8?B?UmI5bko1K3k2TVVEeU5obGRFRmJJTlVtazkyVkpuR1h0d01TcFgrRHAxbTIv?=
 =?utf-8?B?OHdZYnFlZ3NySTVEY0NpdGl6Q3BzcjRzaEpQYTQrMW9ZUHR3TXRtMmZtYS9n?=
 =?utf-8?Q?8XHg0ysMbbXW+2q9Fidl0hrpmu8RbvME?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZXVKZithckJMMlBEM014Q1BkTndoaTVZTXByeG5HajRWY2dtVzU0c0hRN2lL?=
 =?utf-8?B?QUNlamIwNmRlWmdFWmlrQnZLdXZYMGNlSWlBQUwrTnMvSnF3em9mZnN0QnBO?=
 =?utf-8?B?LzVJaFhFWkxKTmFxdWdhcTZJT2pYbDUvbXB1bytwVE8wb0NBM2FFdGVhOUNZ?=
 =?utf-8?B?RGFxRm5QeUdybCs4RUVRdkFpYXExMk5sbTJWZE0wVCswOC9EVmNBRHJ3a0dP?=
 =?utf-8?B?RVVxZHY1MncrcGxIdlE5SkZVT1VOYXlxZ1ZBM2Irb0hiWGE5ZVcwYXFQVVZs?=
 =?utf-8?B?a1hOTzBicmhsVkdZSEFhRDZnbC9KcUpjV25sMGpsMHVINklUK2hhU2ZpYmJT?=
 =?utf-8?B?ZlQydGt2Q0xHNGFOcTY3NmRhdWZMRFZuRDZ1Q25sbjluRVoxRnkxU2RjZGtq?=
 =?utf-8?B?MGhqZ25mYU8vR3RIaTRwY250dk9jWDBLQjFsOWR5RDN0RnRSTlIzVW1OZzVh?=
 =?utf-8?B?WGc5ZXNCZ1JMQ0ZZSHhBQjdteVZxRDA5MUhsNitnU0VueDNvaFU2ZWNNeDEz?=
 =?utf-8?B?UmlwQnRrNGNLWmRGcGhES3RuVndULzRHem1FSlhSZjBJT3Q0RkRpcG1qMXJx?=
 =?utf-8?B?ck0wUkpsdGk1bkU5SFE4LzJ5cWJsSEorWlFDQW9LaFA4aWVaV0RSZFhleUFS?=
 =?utf-8?B?K1JHRzFpdXlvem9HYTc0MTk1cmkwbS9kZXJqSjFBWkJKRndiYVZIR1dVL0hN?=
 =?utf-8?B?SHUyMDhnVXh2dTJIaW9vT2VzbW8vb001MlpvOEF1cUl5Q0dxeDFybFppKzZH?=
 =?utf-8?B?dDExYmtiSE1XUXhMOHBGRTRweklHSE4yWDRkRGNVVUJHT0ZwcjFGT05nbnhN?=
 =?utf-8?B?VGVDU2pSRk90UmpOZ1QyUVpjWFhsUk1mR0ROODhlcHdITHdvNXZXeWdBMG1w?=
 =?utf-8?B?eVMvcUsrZVE0TEw3TFhTenpJazlFd2lZMWcrRkF6MkdvRGNBK3dGYTdEa3JO?=
 =?utf-8?B?YnRGVFA3QURqK3dXQzdCZDNoQmhJdzFNeTJUbGVaWFZsQ3lPZ01zNFNWUGpD?=
 =?utf-8?B?eVpoOWtqK1prTEgwbkMvM0tOVHZMK0ZPcHNJaTRnR2E1cDVGN2hvOEZPM0w3?=
 =?utf-8?B?N2tzS2xJL0NGSXp0TllvK1N5cURneVZGSU1sekwwWVpFUVhCVVgyTW53ZEZp?=
 =?utf-8?B?QTl2VDNIK1JqSUJEOXBad3E2UURBWkUzNUIxZG5FeTRRTXFrbmVLOC9qT2p6?=
 =?utf-8?B?NE9weEQ2OUwwUEFvV2k0eFRGOE9xMmRCaHZiczIwRXNNb3VJQ1hYaEJ1Wkt5?=
 =?utf-8?B?V3BxQ0ZtMldrWm45UmhIaE9KcEp6NGFyVlhJci9xUTNsUjBONGlPRDVCTC9D?=
 =?utf-8?B?TkpMemY4RUZmM1VkRndheWQrVFJnc1Q1TUdJMnk2UUpHWmJUZkRTZlY3bDRp?=
 =?utf-8?B?bnorUkFweVpoTGdldCtNMndkbEJjTlVIeU1MMU1kdDJWbjBZRUxhaFNDTjAv?=
 =?utf-8?B?UnpiTS92RGRHU0ZqeHNBT3Fwb2NvRm0vZzk2WUhIOHo3WGxQdGFvZ2tPY1Fq?=
 =?utf-8?B?aVdVc1JkUXVpODA4VU5UUnZUaEJRV0d5Mm1JMFRvMkFWQUtlczEvZlYrVm9N?=
 =?utf-8?B?TTcwZ0pmcFAwcHU2TnpwYTNzb2IzOU5ITy9vd2xoeVZ1aFJnOVhWeFJMOFpZ?=
 =?utf-8?B?bGQ0Z2s5clc3bDRsVmVETGVZRURpWkxoRjJTN2lVRnhHQm1oVysxQzBISkNI?=
 =?utf-8?B?dWlMeUNXSE1ja2F1MlR3ZUFUZE5kbnV5dEhWMzlZc2hvOE9mdUFVYnhOMVMz?=
 =?utf-8?B?YzAvdStLbHN6emc5alFFdXZNbExwcjdLa3hTT3pETWxKVEs5WEF0dE8wajR6?=
 =?utf-8?B?anBpTnU1aHZOckxtSzZpSGV3NXFBNFpZTXQ1OHFzeFpQMEp2b2w3Vm1nUTR0?=
 =?utf-8?B?THlWVnVLOXZWSG8wNzhUamNGblRoTitTL3MxUGt6SXBwVXJRaDRZaTVyV0Ew?=
 =?utf-8?B?NWFwNHhJd01xOTBnQWJHNTlsbFZOdEw5SjBSZkR6R0VkL29yTURHcm9mc0dB?=
 =?utf-8?B?WUNFR2c4RTZTaXRyckZNTDI5aXJESjFVaVhmdGNJR3k5Ym5wYVFad0ZpQ2xM?=
 =?utf-8?B?WTQyYW5Hd3VGSUxNZ05sanBzK0ZqV0hWUE11UTB0QXpIRGgySzM4TkovbjJE?=
 =?utf-8?B?NE1ya3dBanZGUWNzSVhmb2duYW5pUUdIRVEzRWN6dWl3Y0lUbUg3ek16alRW?=
 =?utf-8?B?KzY1QnhsZVRFZUpiS1Rxb0xTTGwvL0tWbTZEL1NmMEZ6eFdpKzNmU3lraGVt?=
 =?utf-8?B?ZnJoWjlNY3JKamprR2x4ZzQ3OW9IQjU1NWZpQXlVSTE4M1hQOHlidFlpZWVO?=
 =?utf-8?B?OTd2N0NYZ2VZTXNMbTUxTnM3L0VaM1RKVnNrb212L1htR1hyY1J5ZWZxMU9v?=
 =?utf-8?Q?IwLdQ7Y2jqwYvy+U=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xs4OopfZkyjCqtYexDeEEvFo32bhG83CGsEnOxVTdw0FaTXgBpu+VnSSRFf+JZZZ18CzStc1j4nq5Qga1BFw0lJx+Q5DhSvDCWDojS2FAj9QpiPhLj1wPBldUR6lAoczPOOYAph0AK1GUa5Y6d7zVUmJySDXv+XA3xuYC1ovKnadSTT8paXXR1qd1chcujWfxAcQtSNfTR6heF6TIUUyG6iW6fvgij/kCgsWbDXTXSrVA5I2Uu0nUk0hNmu3B87QiUUGldje9hirRZF7w4KmgCe4D/Kd/VnwKvqNU5ccopoTyDVQUXiyjaPvJFVp5ZerhOPCv9YtAxHWgaRoHoAO1kZA2pFSUSIatkR4dJ3+qPh9K4fcDr7O7rSVQNwLxLKA3mOAsqJwpz4FGt5IkhYzy+Psu4DgQ75nwqkXUV2R+ym4mzQcHOCHbXtryMISZTz0340dU++103YtfKd90kMkaES56cSU76EMQTai8YJ7g7FoNL2QitkfOv0i7bhm1MLjq2m2yjkN2TTfcP44Rq3XIpo5iUdHgBNq4bFLechfcEW652GnxodudtzCi/7YQ/lpa13OSojewk9jrAOZqU+l2xfhaRz4FwMf0jpYdRiihh8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a7abb5-57b5-4633-2b8a-08de52d7838a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 19:11:11.2675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdcztIrRlHzfZLEVXnrQBx8HMZOnpVh1nLhd+jMGZ8ZdgoVwbrU7cK+/Mdwg8SI21rMHIEn1rspA/6roAnxiScPCdDx/67agtbM1Zxm+XeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7214
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601130160
X-Proofpoint-ORIG-GUID: vN_5jZ66BJ_KpNxKUama2SVup9wtr2RE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE2MCBTYWx0ZWRfXxT1wb2MKV+x+
 1nkP6Jp8FaWcaeo3Gj7QORdInuXEvIgNbJNVR33X9HwI/k/XsCIUlJSBGHVKMklA263Ds18bZ++
 2SKUUJp2ihiHBR8G+B9Y01ab4NmMZAjPOs6dFGczfvqbCd5bPdloAV/q/DZuZe4MWyUs2B+bSTn
 xiArx1eDni+BhsFP7oJImORiHQp/zOptbMJPbW9BQ07T0knEByFvYJ7BACncr+WmbtSLt/iYX+F
 N6eOQHeuKmP1HTsGNaBw7fzGyRzb42/kVZHhtkXE+gSzrNSss4Pz010z360kTu7NY3x0uNdwtNT
 PaMrPJhKWa2ugfx1GurWeecnI3DPa/RS/e4Eoyw38fwauIlXBgQe2tksqwt+ppItvRyvSsx5ZYT
 6VXiVOk4/0BBQ0CzBwZaLLUo4XcNbqKpVa6NrgMUCmuOqeuYGX8pBGp8aflv0R8MEZbw7IJoFnN
 IHR9ES+IjEkshp5WS3BUHTKrKWZI1A0I/FqJwj3k=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=696698d6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VabnemYjAAAA:8 a=yPCof4ZbAAAA:8 a=_qBtNy9fKRuHIL1JUv8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=gKebqoRLp9LExxC7YDUY:22 cc=ntf awl=host:12109
X-Proofpoint-GUID: vN_5jZ66BJ_KpNxKUama2SVup9wtr2RE
X-Rspamd-Queue-Id: 14E7D180005
X-Stat-Signature: eiiizwb75hmwfdzxsho8fbruex41juws
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768331509-742460
X-HE-Meta: U2FsdGVkX181a5J+0Pci3QkiKPIw9Z6mqahi5MkYLd8oksSfst6HgPCQr5A10eMT2hkwZTZ+Pn9C9Z+a10r/rOAnh8vPGdDzcXUPk+VTdH7vZE6k9ViiKCYOSnJlcjnqygRrDSxhv7CALL6LMMLF4mk3t8gxJD8ZeTiE5ydlumx76+hz7z+VyfMW6AYsg/QS4uDWWz8KE42aRkL3pqG+gPON9f8Z9rLERoHORxqaI3R5VfGIOJFZDD5TthMugTuPKdfiLlusBvNB33klZb6UfBaw3glKbh6UHBFaXCnfiaatWHloU0rAMOtVVipJkSXpl27yd2wOIZQssplEaB7EB71Oe7R7i2uZecZwTvv2CfSJdKAJR6Oj9VfF0tfBFIxEGFq1OeYzvDnFSCzxvpzW6II+9OHvXTlVuc/NzCbzxZ+HIHmqnSTscv+2n/sig14+cEdTt3B9Cih+jm0Gjb1EAsT/tweXpcw6PkTmnGo+HJw6iMPB9FXaZucatl1vQcKJq34ytWzmWgIY5fN9Hp1jG7rmGstgqxQI3R0VMqia/7bEQ4XH+VnibXMY50eQnGoebSvo1gydjniQ8qktuDXIVgUxIIGLlq8W2xSyxtYNBy2LvkuzieGP7PCJPrPFcqLK74QPNKdflLJGrv/D/79AIPJijUaEh6BCxCLqp4iaupYzOnpko8whFoJnO+uS47KuaErpnrOpZ0e1mMyQ0Ysxo6RtjY7zd8K3moh0vP3XlxgTPxSZIJe25Q849CPuuGOWrG2SKDXar1cff+GlQWsYpyFlsvZRPNhM+nOoPqlEc45pK46phRWgrV6buC80NHDa/LKVaMxwxsJ4bXiYkqgg4RzUAGBhaCOtLKlTlCjjziWrdIN8HyruJ4fvwaN3UHQn5VduXWM+W/bPMTHSxetzMCEMe/oCvVZLGTIBuUmqrXzRh1qNM/T0OA7KhXzEAFvCtwOR6RNKAmeEja3saJJ
 EPgKxpem
 fwL+8nfQ7UbYQQU3NnYwW/0/jzzEjtg75i7QUFdYrufTSJYFJ+lbZBHnvkxjcPumrz6iiGMs2hug1e87LnxCKDjbCNc+OyiHNpfo3+EBlChh3sFr79eLTYFIbG9/fa6D+1aRxra3WCR974yIU7J/meyQ6+jOUCIm7z8tr+d+59KtWMWotOU5DU4I7jeypchTZchMRW3FFSNMeNmqKf8lDl3zWb8YaQ72+dNbc2dVKGfaxd8z0O1aa4BLZ7emFsSftEO3h5jQCiuLD9MiQjxjpKjHzrcKMqhwAEB9q1Yo8e93AjRal5XdiUlfN6aVTtlbSg+6+DB+fylPfYmyBGHw1ZwdDI81GIk2KG3+Jx8BNrUniz+mRjpw6tl2aOb08vdL4ohS6GjFDrJ7sdepu3nw/pHTmiOvnbkItkDO7XY83mox86KRXnXI0/MjZGLtqGm4GGuWW54DHCpC8NvWjmfEaZ8dREtlmI4b0u1Eqbhn6W3pB7TLMPMdTYsaG+4xz9BY2wJHhKrmPXHYszIJcq9OW67b8ekbUsRx3mffshT5paYrn0TCpDve4QxhCAao9FoeT6tbrUDeoRuovGtd5b8Ee9iQdeZrXyWu1Ms1On55rpcya3iatJcAWHVCBmbtHANEYNi08a46c+wxxK0IjbYfygLmhP0/0w8pfsPYSRx+jP4HdCYbgFV30EzI01ic4u5fC9YhsF1rEi76UZ7F5pYD48fTNyPzfw7bhgvxeTz220+Pe2+b61dUjV3K3yjtV5IGjB5Sz2sdYoRG9Hwn7yZ58tYa56Vzodhe3tf5wdYDHNhoUeY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 08:02:17PM +0100, Alice Ryhl wrote:
> On Tue, Jan 13, 2026 at 7:52 PM Chris Mason <clm@meta.com> wrote:
> >
> > On Tue, 25 Nov 2025 10:00:59 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >
> > [ ... ]
> > >
> > > Finally, we update the rust binding helper as now it cannot auto-detect the
> > > flags at all.
> > >
> >
> > I did a run of all the MM commits from 6.18 to today's linus, and this one
> > had a copy/paste error.   I'd normally just send a patch for this, but in
> > terms of showing the review output:
> >
> > > diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> > > index 2e43c66635a2c..4c327db01ca03 100644
> > > --- a/rust/bindings/bindings_helper.h
> > > +++ b/rust/bindings/bindings_helper.h
> > > @@ -108,7 +108,32 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
> >
> > [ ... ]
> >
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD = VM_MAYREAD;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC = VM_MAYEXEC;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYEXEC;
> >                                                    ^^^^^^^^^^
> >
> > Should this be VM_MAYSHARE instead of VM_MAYEXEC? This appears to be a
> > copy-paste error that would cause Rust code using VmFlags::MAYSHARE to
> > get bit 6 (VM_MAYEXEC) instead of bit 7 (VM_MAYSHARE).
> >
> > The pattern of the preceding lines shows each constant should reference
> > its matching flag:
> >
> >     RUST_CONST_HELPER_VM_MAYREAD  = VM_MAYREAD
> >     RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE
> >     RUST_CONST_HELPER_VM_MAYEXEC  = VM_MAYEXEC
> >     RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYSHARE  <- expected
> >
> > > +const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP = VM_PFNMAP;
>
> Uh, good catch. Do you want to send a fix patch?

It's in 6.18 so would need to be a Cc: stable patch with a Fixes etc. rather
than a fix-patch, unless that's what you meant?

>
> Alice

