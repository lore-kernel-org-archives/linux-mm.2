Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393D9D2F352
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10506B0089; Tue, 13 Jan 2026 14:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8176B008A; Tue, 13 Jan 2026 14:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAFD6B008C; Tue, 13 Jan 2026 14:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A948E6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:15:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52029C1419
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:15:22 +0000 (UTC)
X-FDA: 84327894084.09.C30B702
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE45A100003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:15:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=NgKvNsqj;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com"
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768331719; a=rsa-sha256;
	cv=pass;
	b=7DztMzAlGpLkUynGOAxpkle9yHB8zI1RymP3fBYAN9N75Amoq/DvtL5XOjofvh7MhvGCY1
	sZLHUwdQ6YNZgLR8ktSP+RxV6nnYKlddPZVRT/ToIf4yoMcb3ZvN79OfllDuoiXlOO1N5F
	+zIIuGevE3pZznyQP62s7ezgrVXLtBw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=NgKvNsqj;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768331719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsVf30z1M4aOwgOIj+ddieqMQF6eWkPgSQLD7JZEVGs=;
	b=g6FaqgVzsid3/0IAE4rcytfN0TDhMdPdkJ9stTp/93uxBFOrjaN0XXBsLhpIJBNFUCZdw1
	a99/E/78UNWbadBQMnRQGBYc5gbbe/MXLamXGnqVCEAoyk9y8G+Uei3uhg+NFOEeZHgySL
	ttYBGpzRLaHixhVMxV/FGm/MNdmVFXE=
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DHCKgF3978514;
	Tue, 13 Jan 2026 11:14:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=AsVf30z1M4aOwgOIj+ddieqMQF6eWkPgSQLD7JZEVGs=; b=NgKvNsqjxoU7
	dC6Q3Eny1sowVr1dbnKg70q/kfFc3G+MJgWBq1mNUAPZgg307CPgYun+jRdI2sNr
	UYRgn5+qlwB4UVZXz7Po7I+c3UE/1CSMX+U+0VzkBDRSZKsaa79xCJEZoj3RNjGB
	bGYVlMp0T7zTbVRZ04T89XplF23JUKNUVRBMBV4jVO39ShaWWaTHaaPMPmoj2Rry
	NTc9CwaxFwGHjwfh+pwAR8OidEeozsrOY65uz3qLMaYcm417Nm9Lls8TTLbiALZe
	smAQoCBaHIV3+GEElJ+sLN83ubcAU9VGO9CPlDa/DthAg7mZOJRik8ZlkDiZZSE6
	U+AdoygOSQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bnmkg4cwk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Jan 2026 11:14:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V3YNsUUVj0Wsv+I4yaXZwO2LnAu3WdH5NLeuEhDGXyBn1/Tt1gwIVdpKc8vMTjW8PMwpzzPSlVTKs3LDrJ/VRYklbrD4r6iEscJe+HzWBr27V3nX8JOcqnWtuJk7/8eOaknT+6GUFrEqM+KZJqwfxDve5UwM4p0x88ASLFlkCI/OxOTmg05ZVgj21qxB6vcfwmNyLkjK/zrE+gcye+7Ha0+xN+xX4NoaPbVVVWlc1nOMyIq7GUfkHb4SCIz+7wIploCLXYOdTxWunbKPDlBdkqHvNXnQ9wG6LRqz1LcQH7H7GUD4olpJB3K4+D8KYTPLWzYKotA1GyegWSYOApYbiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsVf30z1M4aOwgOIj+ddieqMQF6eWkPgSQLD7JZEVGs=;
 b=SNn7pyIUd42xMjj1ZdvBXP0EKHJEhomrqXPTMquLj1eB6+O9geZ5CmZaj5Tl3hRcm1BQwmHnOKrP1YHk3Od/X9o4xTT+LLj5KLOotkaDmyeorjZJcSEo8f+CY2GRoK63qasKGzdgex3wJavm/N8emuMHjrNrJXZiUE1Tsdw0aedzAqNZqRiTBp1leQe8UvBaASiQWkeRKdYza5F7ZE9lwnemO4ObEk5ONUuq1oJFXRWv8CaUnAhbie98wQHw7LgiNbh+e859cWgUBFQegh8hxofeffyXl/BE2Ztb2RRWcpm8rYEfhY9ttueTro5F8Q/3vbPXlJ5elITUQkn0rL6PXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from LV3PR15MB6455.namprd15.prod.outlook.com (2603:10b6:408:1ad::10)
 by MW3PR15MB3755.namprd15.prod.outlook.com (2603:10b6:303:4c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Tue, 13 Jan
 2026 19:14:37 +0000
Received: from LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::444a:f42c:1d70:40b5]) by LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::444a:f42c:1d70:40b5%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 19:14:37 +0000
Message-ID: <cb09ffd3-0db8-4db4-923a-f707b4537441@meta.com>
Date: Tue, 13 Jan 2026 14:14:26 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: declare VMA flags by bit
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
        Benno Lossin
 <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
References: <3a35e5a0bcfa00e84af24cbafc0653e74deda64a.1764064556.git.lorenzo.stoakes@oracle.com>
 <20260113185142.254821-1-clm@meta.com>
 <0cda6c54-2ab0-4349-8633-e3eea1306e7f@lucifer.local>
Content-Language: en-US
From: Chris Mason <clm@meta.com>
In-Reply-To: <0cda6c54-2ab0-4349-8633-e3eea1306e7f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:52c::22) To LV3PR15MB6455.namprd15.prod.outlook.com
 (2603:10b6:408:1ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR15MB6455:EE_|MW3PR15MB3755:EE_
X-MS-Office365-Filtering-Correlation-Id: ae7106a0-3074-48ca-192a-08de52d7fe76
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUFuTWhleTkxZTJzOU14ZERXeitxSWg1Q2VNdmErb3FxOVFVTzVWYW5HK1N2?=
 =?utf-8?B?aVRGQ0MvSVVqT1JOdlhkcFo1dWUxOE11eVBtS3VxMTJpTWRwd3F1aUU5TlR3?=
 =?utf-8?B?NndRbDF3c1UwTUdrTXBuUEh3d2lablI4M3VKK3lvbTJWM1N5VHY1Mzl0YnF5?=
 =?utf-8?B?YXNsMkI3Vlk4Nk14c0NRVHpHVFQvQy9KcU10TDZPTitFZUN6WkpGSGFkSzJr?=
 =?utf-8?B?T1JhMzJaYjE4UUUwd3FwK25ubUJsMDhmRzB4RU14bTJuM0ozQXBjSnRSdVdN?=
 =?utf-8?B?Yk14dXFwWDRVd0J5WGVzcXBDRUZCSFMxTk9zT3NOcE8zR1JMZlhCbkVqMVA3?=
 =?utf-8?B?bmtsSUc1R3hjeEtsYkh3M3YwS0VlUWVVbEpSVzlkOTJUODdsOGlvTm9mNjIy?=
 =?utf-8?B?UUk0NEJ6c1Bkd0l1bEpDRW1qNHphd2tQOFpIbnBkK3V4dGV4a2YxS2ZzWDdK?=
 =?utf-8?B?dldiOHNYbUU0dDk5ZU1iTk10SGwwb2N6bGk3bUdGVWQvekRYdmZ2QnNCU09l?=
 =?utf-8?B?aElVY3d1RTQyak16TnJCUVlSWVpiS1FkVGVzTXJXcGRSczc5clY0MnRMRXdo?=
 =?utf-8?B?ckl6RUdwenpFM3ZzUGlITTZTcmhOZkorTGhVUzF5TXhqYm16Smo1TzdlNkEx?=
 =?utf-8?B?ejBpS2Z6bHVTemhjUXNLeWIyaDZGSDNiMWdWdERiTkdOTi82V0YrbkszSEIx?=
 =?utf-8?B?Q1dvdjR3c3NyZndvTkF3L29rYlhReWlMVEFLc0V3c0Vma0FuZWl2dzI0MXhq?=
 =?utf-8?B?eW9SYjM5VDI4bDZHV1JELzljS3dpNXRVZ1Y0VWNXTVlNWXhCZDVRM3R4Ulky?=
 =?utf-8?B?VWFBKzJWcDREZnZxeXZpVXZiMzJCQkJVSE92REMrWWcwRDZaeEZ4T051QXF2?=
 =?utf-8?B?WUJJT2xJb25lbXVDVi8yajJNMFVxQWhCZlNmek5rWkNFL1llcittT1MrTTNs?=
 =?utf-8?B?Rk5TMEJMWEhKbVkxNFZMNm45MC9UTHRoQlFQSHo4K2ZzSnR5VXZwQlBDdi82?=
 =?utf-8?B?alZhQ0J6d0Nia3BOcnhVM3FrdmRodzJEc05nMVV1TzBHVTZoR0kyd1hzaEtt?=
 =?utf-8?B?RTRJMVdVZGduNXN5RUxHdGJtS3p5OUR3T051dnc2aVNFMGN1RmNDbWpoVzhH?=
 =?utf-8?B?bzNad0g1dmMwYVVIMXZGQ1N6Z2FKRGNKZzcwSjdRMUxxMUZaNlgrZU9lSzl3?=
 =?utf-8?B?RWJmQ1V6VGxGUUxZamdvaTdFcGpxWldJMDJCVW1SOFhIdHFDRlAvZDRtNHdR?=
 =?utf-8?B?a3ZHYnVFdndCUmFEYVZrWXNNOHdheitYSDdqRStyRm1UVzZ4UjFXK0JsNnNE?=
 =?utf-8?B?VmxHcXZsZm1pTlRRNVBvOVlISkVEUHdqcW9yL2kycWxTNmpVY0F0RHgrT1Mr?=
 =?utf-8?B?T01kUUlvTncvcW11NTJaeTIzZlRmNHh1K1R5VnpLWmlGanhMRTQyY2IyNkJP?=
 =?utf-8?B?cVdOelJGZ0hiZWtyNFhYMkxNWFgyOHY2Snc5NTdSR0pFU2lXcHZvakVDUzdL?=
 =?utf-8?B?eDhXdHNVa1UwSm1oN05OZm9RNDk5d3FwWVE4N2ZtL0ZtYlkyb1lqMUhRSFdy?=
 =?utf-8?B?MExVL3RwTW5CMDhnMVgrM3BsVThjWmJhdXUyMFhvYmhmZVFDbzM2MmwvSWNY?=
 =?utf-8?B?dFNNU1BqcFE1QjNrTHNSRFZHeisyM0hDRW5jYXROV0h0Z29oY3M2WUplU0hw?=
 =?utf-8?B?dWFRc2k2eXZGVHRjdWdKNGJuWmNsS3FzZEVSVm00Wkp5YlU3LzA3NTA2KzFY?=
 =?utf-8?B?bURMcWhNQm5QSENuUmo3V3hPdkN4V2MzRERVOGZobVg1MVM3RzdJSGZad0l0?=
 =?utf-8?B?SDl2RVI0a0FCWGs3QUIwMnFEY09hSDUzaitpWDg5VXl3MEVhRTVWQ1RCYlNN?=
 =?utf-8?B?aUN1YUpUUW53bUY2bU5va2JWRGswTUo1RHVHZ0tLMWlkU1ExWnNXL2JlY1N2?=
 =?utf-8?Q?hF3jM00QKBVSYhUQAEk/MiAAGhyvcqBV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR15MB6455.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUh4a05RdzZmTFBDVE5hYXkrZU5UT084dUU2RlRaOVN0bS9DZm04eStwL3JF?=
 =?utf-8?B?NXkrZ2VieS9jUXZrSE5OSXRBa2lDOHdYSDZpQ1NsOG1GeHdkUEJWcmYvZmhK?=
 =?utf-8?B?NTZtOHFGeS9wL1dmQzIvSGxZMisvSFRLTFVDUzlWNzhLaDZTMGorZXdQa2JK?=
 =?utf-8?B?WUhaUzFhYWpReGs3Y29Ici8rVmVmNUdRWjRDOThwMnJoYXZOYnBJUFBRWkcr?=
 =?utf-8?B?UDkrcVY5eCswZ0VCcHZaUUNVdEI1UjlFMVdRYVBVeTV1a0c4TkdscXYvSTVa?=
 =?utf-8?B?cEVQcnJ2eFBJVXZJOHlrbmhVQWljdG90enlaZ0V3QThIWkhyVjJ5a1FYUXQ1?=
 =?utf-8?B?OWI4cXR4MURHSkNqTnlWSk55TERvNmVOMVhsdm5VVFZxRVVUZE14KzZTdWVi?=
 =?utf-8?B?djUyUE5zZG1VTkpQcE9ZelhRTytZTWNTMXFEbm1HbDFQaGlnZStJVDdGTmln?=
 =?utf-8?B?WWl1ZExaMkVLZlcvRGVPVnRWbWFVT280NGNybzRUVWE1bkZIeUdReEFsZllZ?=
 =?utf-8?B?bDQ3elJnQ1RwZzR2dHhPcjJwMWI4UE1JeUk0VWlEQnkwU015bWVhSnY3RWhV?=
 =?utf-8?B?NTZyNnVBN0R4VzNuREZrYlhBUElQRmhhTWw4MThXN1ZTMjA5VmpjMzV1R0JO?=
 =?utf-8?B?UUc4blVzY2V2Nk1GWUh6UXA3UzJLQzFJU2gzZ0wrUjlqSWtCV1l1Z0p2YlF6?=
 =?utf-8?B?VXk3VzMxZjFkNnlRSmI2WFVvYUpNUExqZkxFY2Ixa0xYWCtjTTQxU2xOM0w0?=
 =?utf-8?B?dW8vSjVzMFF4UitmZkVYWHFBdUFyL1JURFhZdHVjRUlhN2JVQTJHbTBGcDl6?=
 =?utf-8?B?ZlcreWg2N09wZS9yWlZYWGdjOWJ4YlNCbitaWjlQSnQyeW9vMUhHdzRndUpO?=
 =?utf-8?B?bkRtRjBBTWU4ZjJQQWZIQ0FPY3F5cHRQVzFmVy95YzVhakRySzVoVS9qL0Y2?=
 =?utf-8?B?SHV5Mk5vTVpsOVdXU29rUXY2MDFoNWFibEJTY3F2NGtwM1hNMTZQemJqc1JL?=
 =?utf-8?B?THNSelg3emVOMWZKOEpsZ1lCQitQMDB5bS9TKyt4MXlOT2lXVUNrWHEvT3A2?=
 =?utf-8?B?cVZWTldlK1FGSEZ6Rmo1NU9DTFFKUmJxWkdkMEZZTlpPVVVWRFQzMVdGTkw4?=
 =?utf-8?B?ZElmVjlVekhhL3pjVWJxSG9GM08zbktMR0luNnRJTmswSFNRMWx2QmdYQW9G?=
 =?utf-8?B?OEVTNlpuVXZ6RTljUW9WZTBHWk01TGszaCtUejU2ZTlZWHhzK1ZrQTV5ZUpu?=
 =?utf-8?B?L3hrd1QwcTl0V1BTSkJCcmZCRmw1VTRpaXJRa3g1V3dzTTBkcmxBYlpkU3Bp?=
 =?utf-8?B?OXJOTUpmWUR6QlBaNHhqNXdlTnlldFlWRlA2NHd2aU9zeHFlNmdZZDBPMnlo?=
 =?utf-8?B?YnpkOE1VenBIYkdManloSWo1VmVib1kzSTlKM0VXUHpwekJ4L1VPdkNtYlhz?=
 =?utf-8?B?Si9YUWlWTjFlWTB2dktoa1VFSlNseE5YeWFDeEs1WU9xQlo3a3lDbGk3ZzVj?=
 =?utf-8?B?RkFSdTJmdzdIM2xCSWRPSldoeDJLeHpzN3ZHTDZvWHZxVHhkVEQxQXVwRk9w?=
 =?utf-8?B?RXpEZ0ZFc01zRlV1ZHUxK3Naekk4WWlyNENrT2F1WDZESGxWanVnMlkyNVhn?=
 =?utf-8?B?a3ZNbTE0cmQ3QUJnRUR3aWhwNzAyVlpIcjhYRU5GRm1jM20zUE9DU3g3Smh5?=
 =?utf-8?B?R0NIeXhhcWFFSEx2VUMyQlYreWhZU0NIM3pieFVDdXZtVUt5KytWKzMra1JK?=
 =?utf-8?B?Z0hya21NcHA0amttdTU5ZEJVeWZxWkZoUlBpQlNPcnhXa1owb2hpZDY1clhI?=
 =?utf-8?B?SlQ4Y3NGVURUNk1nTHdESVZsQkFNSW1leGc2ejVBcEUwZnAxOEIvYXBXUCsw?=
 =?utf-8?B?K29lNk5DTC9Ka3ZjVGMvV052ckszSE5jU2QxMnBFeXFCQlRFQ2g3SmNQM1hZ?=
 =?utf-8?B?ajBldS82OVc5Y3FCcVE3SzR1bE1zUHFmb0txbGluaFNkV0UyaHRlSnp3STZ0?=
 =?utf-8?B?VHQ3QVpFL2pHbEw4bjBLTTh0U1ZXZWs5TEpEZ1NWRW1jVmkyYUtZMXQ0djFX?=
 =?utf-8?B?dmhCYWZFY29DekdIT0ZRUkFsTDdCaHJocUE0VTU1Nnc2L2Z0eDFkY1kwOEZB?=
 =?utf-8?B?THd1MWp3by9xREw3b2RJZG1QNFk5ckdZWmM1Zm9KWkViYnQ1Y3I5bCthYm5S?=
 =?utf-8?B?ak5GaU5mdXhKZ3FQZnoycEk4WXZ6WEk4S3R3R2d0Q2ZCZHd4RTRRZzVOc1pi?=
 =?utf-8?B?SkltWHFhYjZVWHFOMmh1aVNKOHM0bm50Rk9VbEZIcEwyOWQ5Kzg3QnVvY0Yy?=
 =?utf-8?Q?/lbnyhvfGdbOpWOqal?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae7106a0-3074-48ca-192a-08de52d7fe76
X-MS-Exchange-CrossTenant-AuthSource: LV3PR15MB6455.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 19:14:37.5579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDJqxfNFXrgrV+RKJYWwWuPiAgvjMwirctHEdbUjizUNGV5t8yAN7zyL8Rog822M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3755
X-Proofpoint-ORIG-GUID: W9ah8FTjwuDFHTGTRhjzFl5iUrJ_tQhV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE2MCBTYWx0ZWRfX+AYaa23FUSGS
 6+HD776qYuLJ1qqElYRnmGa/dUsxsAcB+R8kCpLLxm7e6SgAVhGJQj33vRewhyr7W86HPaFMTu6
 Is68iLaqjP713vW61sbFyykHTUdUIDjGT3/pwS3kSuHNaJyERgdLD4mtcj5ExeyiuhmGhEUCyAg
 nOWoEzoImkAMuJFX22RyOAeFVJoSdNpQ62kMt0KNp0KbIbiPCzjircpxKzBACJi89BX9CLyLR07
 4BCt8NwnUaWv71RtCFzvmj4VhbbVQdC7CtOPKS9qzgFC5CYHFhWVJPvOXFCbhmWR0KYdwySYzBo
 RDD9wZXoplPQxvhuUP8zu0IcPSYURkSCXWi+kEuXXwuEMZA85f63BZAQIGSe9lJujPTTtOxbvGT
 MjipdGjZg0JbfJMHW2h1iFxlG+c21/yDWWmWCmUCbhyuj3wTJg5fOA4+PlvkqroIxES/Wc4Sz/F
 eU8IU46zXwQbEFBl5Tg==
X-Proofpoint-GUID: W9ah8FTjwuDFHTGTRhjzFl5iUrJ_tQhV
X-Authority-Analysis: v=2.4 cv=Fa86BZ+6 c=1 sm=1 tr=0 ts=696699a0 cx=c_pps
 a=n9MmWVbgKLYxIbvHr99TLw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=3gh-2k4yC8mHpjCmYiQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Rspamd-Queue-Id: EE45A100003
X-Rspamd-Server: rspam06
X-Stat-Signature: on5p3uukh4kr48dcxnx6eic37tpcmrw8
X-Rspam-User: 
X-HE-Tag: 1768331718-790850
X-HE-Meta: U2FsdGVkX18l/XAuip1y+hLflnNEERP/Gm2qrENEgDFi/mp8K5saeAaLUkJ8hJMdShBVcl+3FfhqzSn42VqGfAGxKQBzDpHyLyznqbb9M2Z+rcFK5Y0yEgAbDKfg8Fx9W/OtThwZgefOQCauCosf1wUiXPiYmbb5xrAWQwEmIjujkxTspPem1B0blKYuvE6gKSMGWGZ2auL3TEfprOtL3vvVwavWhv9ycz5ydxhjR/3qQI6CmeZ8i+vplvAPjugJDycwRAg5s5vUVuRtVxzhXyOD28qAC0ZV0qww6UUDu86Q/7tkROGey4p6JyZs3zYLmnw6MMdmPcwcEFDS95htv3viSFbBRycDNg9n5DAabvmG/GpwIQRRVGbvDQ9MzLORrjyWc/zBmKC+0LprUadGpgrfSrN3ZTiCbSCMIJUZB9HbmzGmIpculG9KYRz41p9HZtHZ8MLHkLXaraVyTzWIm6n4gRCUFkVTXN8EkQvDKFC/smBmx0luLgcQI5W6eROHxpzDIJ+TvJjErbI0BRqag5NTqj18FiWnzVlqxa4KTmoaqZ4D0yn327begoDEkdNuDdZ51eciNjFYxeKgR0H4JSpLyzAQGdnNVRxGkVQ5HgvXsVyftjrIdeet7Z3kzKBX6Gpw25+FtVWWIIsBnlMVXsL/1SiLyFJtJF9CzUHAO6RQn6qu11745g2+seNZZdRcTccfDLxP95dWVunKDjiHLzZ6FBHBG7EUQfmvUpxUY6oAPbWxtcfbUsVog6XZ9XUb5CZ3yXHlRn2ed5g5UP69Jm4VHoIW22bV/HDJt6WmTOtNdpiVKTt9aXIo4IqkD5w40dqUqXDvFMA9IRRNRDqAzdWSmMATcuv+F8+rhB/nhDF+0lyRVDuClVdhiJnDXHfiF3skaQ0iyQqk1bnvgCNOTkf8pCg0Twf4BmVgngjqqkBdk3XbgusChm2Y++1sFDqX1hNUfuZkRON470MHATK
 MLVP+XnV
 kvX4IaE4Nq3rqeZBOieAqfkRVt0vPWR4kRnfZ+16CGt4tfDKUge3jdyTyG0fCEdmtCFEVs2rB1tJU+7BDjFSOYpxI1++Sil35J9hKWU5a3hwBTafKZDOdIaLbSKNVMR8DWB+O6Nte60TzRwNfGd4YpnuBEvinTNXXLvUO0WKkPjzs3hwHkp970pgXqhv1vOLrNbuO/h2aSSK32Kn0YmiW3Lf8uAXmIHzDn461S7VKsFFbktCEYJ+vMdtirRRWwnRBtgsFaSlEllLxeG1Ib3JAKIMNmw1WRX8xIAFyjv0lshVViGbA0JvBGBN4IPeBFD8v9Br8FMgE3YyKEL7XIyk6ejOaRNRV7WMdotsXzJiqYOWi+C8s460psyW/xaXGJ8xNlh7TjC635UDK/GZFs3pIqQhmGtb8gGlQLK68EsGOgH+OhHJADSQfEoBrAOnCg6rCPdFUF4Xtha6inXq5aiTPtAgGGcK9CInDCIm6mfmWPVuoqtXkTkk0TzOblpSGuc6RKbPiLNUmTWlmCcjW+ngQupKgP9/pA1az0jB3c5ad+ZPYI9xVFT2DgqqM24C5Umoae4rGhXN6AsYD51+P2uhI9vVf87QzI1etOzt71nv1k4jlKbKcftU/8G4yxFPU5Ng8o20X5oP5htaA6/s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 2:09 PM, Lorenzo Stoakes wrote:
> On Tue, Jan 13, 2026 at 10:51:37AM -0800, Chris Mason wrote:
>> On Tue, 25 Nov 2025 10:00:59 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>>
>> [ ... ]
>>>
>>> Finally, we update the rust binding helper as now it cannot auto-detect the
>>> flags at all.
>>>
>>
>> I did a run of all the MM commits from 6.18 to today's linus, and this one
>> had a copy/paste error.   I'd normally just send a patch for this, but in
>> terms of showing the review output:
>>
>>> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
>>> index 2e43c66635a2c..4c327db01ca03 100644
>>> --- a/rust/bindings/bindings_helper.h
>>> +++ b/rust/bindings/bindings_helper.h
>>> @@ -108,7 +108,32 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
>>
>> [ ... ]
>>
>>> +const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD = VM_MAYREAD;
>>> +const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE;
>>> +const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC = VM_MAYEXEC;
>>> +const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYEXEC;
>>                                                    ^^^^^^^^^^
>>
>> Should this be VM_MAYSHARE instead of VM_MAYEXEC? This appears to be a
>> copy-paste error that would cause Rust code using VmFlags::MAYSHARE to
>> get bit 6 (VM_MAYEXEC) instead of bit 7 (VM_MAYSHARE).
>>
>> The pattern of the preceding lines shows each constant should reference
>> its matching flag:
>>
>>     RUST_CONST_HELPER_VM_MAYREAD  = VM_MAYREAD
>>     RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE
>>     RUST_CONST_HELPER_VM_MAYEXEC  = VM_MAYEXEC
>>     RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYSHARE  <- expected
>>
>>> +const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP = VM_PFNMAP;
>>
>> [ ... ]
>>
>>
> 
> Oopsies!
> 
> I can send a patch unless you were planning to!

Please do, I'm still going through the rest of the commits.

-chris


