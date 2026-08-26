Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD4AC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEDF66B0088; Tue, 25 Aug 2026 21:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E956B008A; Tue, 25 Aug 2026 21:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EEC6B008C; Tue, 25 Aug 2026 21:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2EA86B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:55:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 197F5A0153
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:55:54 +0000 (UTC)
X-FDA: 85141754628.22.52314C7
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010008.outbound.protection.outlook.com [52.101.85.8])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36514120006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:55:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NPF+iUU8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787709351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrunJKDe3bzwoam35Xh0CHE/MNk5hYKvYRtDvR6ZjAw=;
	b=LkyKXSP/KBoOSJHUcCoGwkD+B6+fqg4MDxEHgF8e0Ob1pWbt4CclHywp3XjuzX6ixoALuH
	PKKFBa91NYIy8F3OdONYHeOqzA+jfGLKqJuGOmqCumSbvwcAEC0bE+DKt5Mz118yYZXyMe
	XizmpEoS3MMpQOLKLHx0wwIPMYx5GDw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NPF+iUU8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787709351;
	b=w6mPI37MvtSYdS4Mh9kPDAHVwGiLl8w0Nh/kUYmiHLk36wB3WSARmVwigFbN1VZfRRsHK9
	hkUAKs16GUa9mUzyzMjmkyR/YgVx09x7fk1dOGRUP/lno79fJPaZTOi3As24IeSM3u9cTz
	kM2Do6ohvhRuKzfdQil2PtzKmJL0EE8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ydxwP0Vy4vT4vowaBUl010u63p93Rk04ddZ5l/GzHfw2c3LtPq5O9gbhrpWc/veBxRjJJDPf0i968AW2t8WX5lUpmgz/K03275M3FPNcWHjThf5WkSEdFel+un5hXIHLLzlupqX1dEkql7iNbWPIr2s1ln+MOKV8CVXHdo61vIJne8tQqyhaB3sEoAzEu5kXaziRHWgBVKraGlYvYI2wlLgTyaeDNP+3E9kT5/T79+YGeIXqjbYhUiQPKeRpG+w6Uoz0KsI6xgYAtdAD3sBI4IMMC5uK1wkZ3f89WEuXVceiIo2A2Pxmq8YoNlqJpBScqZ9B+UWBBt+9NlUfsu7R2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrunJKDe3bzwoam35Xh0CHE/MNk5hYKvYRtDvR6ZjAw=;
 b=LOLNK+s7rMnuY2SYoZNydyx35YJFqwVqhXwB/brsQ0uS0Bb3O5OjPX4y6BzZY0VmFDf8E8WayXbEtaLUUDWKlrXT4Q6WEMqCIfyIirT+PSXav6zAC6MW5kh7xdD7B6IRvQcA4c1gC6VO4hG0E7ABjEgG0tiZFiSwVJB1O/N3A30qj7j8POwipU+/UmiwZZEw71Dg177gig6fcyxjLO12kgnp/2WZ+x1KHJ7DfI48NeRkAKC+BzTrAhCKnzymemXOhX3S8VDG7xPAY167MtmstL1mSnWxFG89hyxiSKR4W/UCb4L8aw6YpmgRO76QiDTyNvUrrqeINHo6Jegyw8lcGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrunJKDe3bzwoam35Xh0CHE/MNk5hYKvYRtDvR6ZjAw=;
 b=NPF+iUU86VqZWUvl6yFFzXIPFZ842Aoo0FpLAy+k82W4sMzbUq0/C5sao4i4qzeZnZHTkDb3kmJDAV5SKyYXdohuxcVwcCVKQa5Op3/dELLMzxMvV9HXPKlyr8ysnJhp4EQ/WxFHrqwv5ohiOqsRlUhmISGgf7gJ2RAL36GBc0n28OwaaWz/0G90IqBimS0YSbS0+ZLZMx0iWuRb8/Fe7uBG98VYsLX/Zrm6QMEUTsziNGPsj7I4jLQ9rxNJB/a7bM8D1d9veMz5lQqFX/DC+0TsR+PcXIC24rBFe9quXtJCvz9uqYkw2UFlRQCs4CLnMQ5eQXXY4aEmk6484NZ12A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4421.namprd12.prod.outlook.com (2603:10b6:208:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 01:55:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 01:55:45 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 21:55:44 -0400
Message-Id: <DKYI2N1B7XO4.27EYPH96ZLMK9@nvidia.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 11/18] mm/huge_memory: allow splitting mappingless
 swap cache folios
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>,
 "Kairui Song" <ryncsn@gmail.com>
X-Mailer: aerc 0.22.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-11-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-11-9b43f5163238@tencent.com>
X-ClientProxiedBy: MN0PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:208:530::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: 3604049a-c7dd-411b-4506-08df0315246c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fB5WsxjpOez6RL9v+oF06NIbkar8wBR8/K7ZYxTBRlJ4h0v0978E1N8ibSDW2ShrG0vwrsLaGdM86XsS6MVT9asq3mZczHLW1WQ9bXBHW9OSS+AG6fpjVPeoUvXGu9F/gbAKqnhHi1VHRBFZo07uQLNww4D9/IeQB3y6Ng4hkWYvP6vqTq0aYlDqTprKLssxUNwlW88QvHipRNkRVZzPbbSdcPDltlU3FmIRmyObf9FRwBrZNUFI0KIiZOs02Z4RFA092uJW0I0lyhye74QLXmma7Fkvkps/4LlGlk6cGMFpAgCKj3XTs3PnZhonjrWDGsU1Oy7QpVh5AI60exBUu+qJDFCNaAyq4/7ghYu5Adk6WP9J09v94f7Ql6R5w1oGDk8LKz0Lijb9TGUACSyrrSTvnyEkw97W0rLn0b1KgeNumsT3q/E50oZK4UWa7ZhMp0pjdOMSUyIsv1iqDEKfFvce2WtEMC7pbjO2rwR40slcAR6JpM/8OlDZQB4MF9lLGoM3ClCCmpju/o9f7v1naPPaU2uYJBSJMVFlt48AWiP4Dtm1/I/rkZsgDlEZFZJN18YxkfbXEFb6KGe33LMsMVgVfS5PiGDcZjzfi8t/zVNQFw37jbwMiZKBWQ6CwEMG4H8wyOsFfglVkSuuSCRIrjiHNeImZirrtftKv9LZmPs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDFwRTBmdXhRVm5iRFIyb1FDbTNwMkZzMnQ1UlMwcFdWODhwRkZHRVJYT3JG?=
 =?utf-8?B?UW5XUlMyUHo2ZFhCNm1QVVAwWGlSNzk2MjErMmQ1MWwzRzFhRUlSUzRKV2hL?=
 =?utf-8?B?bWlTaUVhRVJBYi9Sckk2YmVGc2VCMzZMaFFRVmorYkhmTkZRNjNZYzdJdFZZ?=
 =?utf-8?B?eExJellXYy9aSjR4dXNJWlpJTndYQnZ6Rk8rcnFxNTZPejgybmJWOWJkY0k4?=
 =?utf-8?B?MS9lYmhlbklpVk5OdjE1dmpkcmFhYjlKMjFGdlJwNzZMWlQ2WW4ySXNnVUNy?=
 =?utf-8?B?ZnZpOVdVWFJvWkRhK0swNVgyNlNXc0xYYU5mN25Ed096a1dRYkNzYmEvWkJv?=
 =?utf-8?B?L1NQRmhzOGR6Rlk2aWpSWjF4eC9tblBlZzR1dXpXV1ViUXZuaEtPLzB6Y1o4?=
 =?utf-8?B?Z1B2VFVoRDdzM3owVEk1a2RPTE1YOVFaWEw3Q1pQWkJlS0dkSG1BK1B1TS93?=
 =?utf-8?B?d1grQUE3YmpsdzFMNWo0bC9BZ3RUYURPbDNpL0g3eDdDMXdSR3JLakFDbDg3?=
 =?utf-8?B?eE1waVozdVVjWWhwNUQraGM4VmZRcngwbk5yMUl2R2ljMkFvRlpqNHVqcXB1?=
 =?utf-8?B?elVISW91RnFlenBMaG9GZ0tMcm8xWmsreXZGbi82d1RwbVk1MllPVys2MWdX?=
 =?utf-8?B?YnM5aU44S1RjZUxnbTdXdmRHbEkyMWFNQ1Y0VDJ5TWFzUDBQcWlBNnVvRXBS?=
 =?utf-8?B?YVBGdU05Tlo5akJGNFJVSG1nN1lHaFRrWVNGMHc4QmZCTGhkeU5rbERVRTNR?=
 =?utf-8?B?cGJjS0J0TmpRWmluN2gyUlJjTXZCYXlBTzY1cG5OTGVQUEd5Vjl4bXNBUG02?=
 =?utf-8?B?ZktBaDVCTnJnMGo2K1M2bzQyOEFKMWYxWUZoUGIxRkJzelJINlo1VWdvcFBO?=
 =?utf-8?B?eGtNV1ZudGFybGFza3lQRG5yNlB1S3M0V21FOFYrdng0OS9zU2h4TWJnbFFK?=
 =?utf-8?B?NVJ6VFhDM2s5S1B4b0h1dE9vbFEwVGxIY0h1bmQ0ZXNjQ2xpTUdjRVdQb01v?=
 =?utf-8?B?RXpoZGVXcG9MRk4wOU91L2JMZDJxUE9UaTErS0ZYWGdaVXB1MTM5dVZKQndi?=
 =?utf-8?B?SUV0NFhnZW52Rjd1VGN6aU5kR2JGZ09XdWp0Q3RIVXJuSFRoZEVkV1AyMmJm?=
 =?utf-8?B?d2w3Y2VWQlRsZnMyNkRQL0NocXZaYWxLNWg5cmxONndOcDFuWE9WUjJmcHI5?=
 =?utf-8?B?QmF4ZmhkTnJ3eHhGdk9jNk9OZ3RoRVhyWE1DcTR0R29BNmpYOFFFc3B6VGFO?=
 =?utf-8?B?WjgydXc4QkJuOFMyaVEzTm1DSlN2YU15dFRuSW9zTytTREdQcTlVdnlDN2pH?=
 =?utf-8?B?NGttN3RoanFRSUttdWRtYWFncmkyWkp1Zno5T0plOVUzSnpZVXlPUmNDb0h4?=
 =?utf-8?B?RjVMQjNmQXh5VGZKNCtmZTJWb2t5cDh6blpUSlZrcHZvdHdZZEpUOHJSc3FX?=
 =?utf-8?B?d0lNQk42YXJjZUt5bGIrcncrRHRBYncveVM3K09pTW9YOVZnOTV4UXBXUWs0?=
 =?utf-8?B?TDh3L0RncG9CWDJ4VlRIMHFRSFdLQ1g0UkNHNlZIMUxXczBlYlhyVWowejFS?=
 =?utf-8?B?N2xGNlBxMytEMHdPVDMzZDVmNlFsQWxFSW8vTy9tVlZRcE5rajl5VDh3a3RC?=
 =?utf-8?B?T0tYTHVXN3B1TWtIem1yeUxaL0RVdFVDdldTOGc3N3h6WGRBQTgrWVRESlJw?=
 =?utf-8?B?eFUzSW9wSmxIZlI1TzFONU1SVEN3T3ZZMGdoVnFZV0tqeVRjL2JDdXhGWnVt?=
 =?utf-8?B?VWt4bW5aalMrNVRDaTE4V0JDSDJCSGg5VEdpSUlBZ0R4U1N4QklwRXlERjQ3?=
 =?utf-8?B?OE1ZbmRUbHIzUXI2ZE1QN3BSMHc5SjNTcDYyVm91OTBEYXZZRk8zUWVMYXc0?=
 =?utf-8?B?L29pcGZsSWJvV0tlenh2V2Z5Vkc3K21RNXVxSjVMQU1oT04xZW9HQzlHa2Vl?=
 =?utf-8?B?cTZnRzM3c0JnSkV0OW5rbHp1bnVOTk9oRCsxL1E0eEhQOEkyYmFPM3d1UWgv?=
 =?utf-8?B?QjRQM1hMYXpQcEdnWGNoSWdMV3dLVE4zc2g1MERibXNKVnN1VjlsNDYyVGxz?=
 =?utf-8?B?c1dpYWxSTEVYSmtnb1FDNnJ2QlA3c1daNkNlSUVzenJQOE8xemhHNnAxeVRp?=
 =?utf-8?B?U3JpQ3AydUlncUlKb3lRSXlablFPZEVzaDZUZjl6Q0NPc3hCRTRrdGpBWW8z?=
 =?utf-8?B?V0cxWm5tY0hLNUExbWZGSm1nb0h0WmdPM1llMlRRaWUyYTdaaitiZ2s2WkRo?=
 =?utf-8?B?WTAvcXpxWUJtV1l0VjRNNVRXYWUySEgyMEpzdTh1U3d2TmYrQTI2cTlVQ1NF?=
 =?utf-8?Q?95ILrYxU6tzjE/b3G4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3604049a-c7dd-411b-4506-08df0315246c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 01:55:45.1364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6CJL1blbp1wipjRDa5KtDLIA3THc9xG0ExKztZ2lMGrf32j7E9/tmJAXxqNvupZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4421
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hgy4dzj5azd5iswhxts9uz4uj8gksu3g
X-Rspamd-Queue-Id: 36514120006
X-HE-Tag: 1787709351-178417
X-HE-Meta: U2FsdGVkX19DfvT/XjH6C1CNnWG1z18fUkxxlY56jbcjlfxCotaYnFvKBaXXBaqQ0gF9AmbAR1oxT4hFfO+twAJojzZobzgPA08wp4i8tB/fLiACCzFckyCnN976mx3XhSrzLpsWAyv+MyzpPcMFHrmruWCsz545XwpEAG7g3trDv2Ku5rb9ZV2cJmCmTp3geqDLpr4mdATomxC1tHxP1i4CSRY7S5Z+6is+SF4qiEiSKZaKHQbuxmZC6Qbe3J5MK/ELrCA9TKi/8TI/n5J0M7aE5O/GKlFJA38FrlrQ7tPADYAOtHfzUhgKQNisfhkApc/9AcLW/B5t7o6v+5E8Kj3cM9+bo/3q0laO86rSDtiT2grNhlO1kaNfTInMtFmXNwtdAAqYSkcZV3bKT5UVyp+vFqzBh+35Au4YRcsfPZOzlN3oKhhCukLasxqUxENHOMNPx/SI9/Dy0fc+118jrh/VGMZOtQ4Fy79fxOy4O5uZASi8wCg98OwVkNrTu3Ie2O3IxMTL5CxhzzSclPuVXixdZbZGCGFaUiX0nLubh+ic1Jzs/M18ZCDSTFqF+4inLeWjNJb99wWmupVmKkfGBtAz3rKPBQzASTP4zYyh3I+jJbdrnyK0HPiHjQC72/txmlqF7hbboh1iqRwvAGsqpuWj52yiLOWER1IwKayeL658fpg4cOmlHy5tRQJEAzhr3bsjp6f6EKIgeSafMYnNWalAjYR6zmvE3h34x0aWg9Agn79+qLmVShQC/1xhkskaQKvuOzR6Hcwgr8sup2jE/73kH1d+d3IozPlkISs8s3nWcHQMtbshBQ+IaguoDmX4u0JKIiudAIYc4o6jhlguhPvj1jHk72jxkH8aXQip/2Y10EHjQc2zcOKAouX0kerY3xwmjJd7RuFjY3d/Rn00aw7kIgLoRZBYSU4Pid4ZqrlFxCLZTImB/nhbxbOpD2HesFogTDSflueeXtnHS/M
 lQLEQL4N
 dUKzx7kpPKVC/xR3WIph07GSe/Re8TfWLssNtqTG47JGUMNuw+2YbrFbS+sRq3jSIh1PSSdrlbk27PTyeGN7CjQCUyJ7IvcE66pUSYkdsiVxki4Tf7W95w7YsucALdFwexO0LkNWyuIuv3Rkoh0Da5gcpPm7dHqjQoUpbPgbs2AAZ2N4jf2DYLW4qMgp2VwBvgIbv4UpaZMaIdzrtZ9Wtt48ThHIeoiMPL5zhZMYtgTB553M227541CJwghO8BGLPGRJCFNZLRlFl0NLWf3d5w6prPzM39y2AxI0qNgzwRhy7o24a6m3G8O7uDRrZ0TKh77Od/apbC8NeyU7QjK5d5UQJ9lWnoUD/mDeC5hyZDa6MgnwCp897/ivZe9I06FB9XFAuViOOLX6l7/J1/+78NGOTZ3x3PbW1sm0ijHJygHWPNleb6poyj21GDB3oc3Ku1t+3MW1FWQxqvN6Ja+eWaEwY7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 2:55 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Lift the restriction that kept swap cache folios without a mapping
> from being split.  All the underlying infrastructure is sound against
> that with a few more tweaks, no reason to block it anymore.
>
> Also rename the split helper, which now handles mappingless swap
> cache folios that are yet to be anon, or may actually belong to
> shmem.  In either case there is not much difference in how they would
> be split.
>
> A non-anon swap cache folio that still has a mapping (e.g. a shmem
> swap cache folio) remains rejected up front: it would need both its
> page cache and swap cache entries updated on split, which the split
> helpers do not do, and there would be little benefit in doing so.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


