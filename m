Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C54EDF41995
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACD16B0005; Wed, 15 Apr 2026 14:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3358C6B0088; Wed, 15 Apr 2026 14:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4996B0089; Wed, 15 Apr 2026 14:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04DA06B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:01:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B14B3E41F4
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:01:46 +0000 (UTC)
X-FDA: 84661558212.29.65F4913
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010043.outbound.protection.outlook.com [52.101.85.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 972DA4001F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:01:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C09ETDyq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776276103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIVoJFKLsd+GmKLJIP56L/AqueFYsBTzI89ga0HARPQ=;
	b=3eET8Iu1KQs+FXGFeOpww1jzbFm2N1f9l2RUhm7Rk6HdEGfgw/7KeRd+9fZfXDx98R3ujo
	s1Ges1pHCDK1H2j/S0lRVrsrakyqDUwZJcAW8o4EzxZZ41Fmxk5p4wLoy6FSaMNVFvOO8w
	N/ZS+6xH+omlwNw2hSjsTlF0jPDJ8ck=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776276103; a=rsa-sha256;
	cv=pass;
	b=ePHwQDDWJnJrpnsaMFLh9e/kZysCh0LxrJJXoFAFxSk6waB2Ha1YKJ/mOWRzw/XK2OEZ8s
	MS4Hv0J7p2Qp1fmac0p7M7O4rg2xpkKjMijiau1W8/Bh0NMIQeHe5+jgfZKDmlFmJwt4MV
	YmQy2iDcWq0BW2LU4yRUAOG+5toWIxU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C09ETDyq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=phlGZtDluSL/JIMJ5MEFB3VMVqbLDHtl95WlyMBb9imzY2LwPDJP65gNU3jNZrTKYr4IysGS4gLszAYeG7Io+pgEHg8RoC9prRiFYYBNumIbj6f2xSM7bjr7Myp22uZvk7F4d3AlgMLmu4otXRIk1mv1iwOEcmsh6UoxSYzu7r1SfYeNgTHyTfvgv+5lv89c/yECPYuV8zkRQeRmcGQ/i9epWLEwcyN+o8NUHc029EaSZAVXijoTLgWezccZCW+xQSdtc9Iyl3n4KpMHYTo+vmSywj098SeioA5XLFEtsmFg4UTw3Rtaiq2a0bLb5fqM5gQn/nnFBREwxqS5zffGRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIVoJFKLsd+GmKLJIP56L/AqueFYsBTzI89ga0HARPQ=;
 b=GC18814QhMb4OS842OmWk7BEBXHvZAp5UpYKbmhjB8rmNgw8CHUcm7btKdIJGaSLPId1ITq/9n6VO0b+TNLELrX41EujdOIvANmFIWgwD2DtVAKhUkmWnhH4uAJ1BThbX9/vueXMLcOMj68BFMDFzXx/Zu0Sb04EnBnCWZ80F9NLZ+Lhq42OfXr/yfZAhIt97PDjaulpiDYBf0zW6R3IL+gdd60oyS0XgMHn1gc3qmL0qw8+vjMSwOTQiB9sk+LKhnNQu422cJjoaqxTuX6iJVZiSTqbxvdyQpmzI0i9twu6U0EzD/EkE0oLh2PIIA/HPUiTMqPfxbCW8RCbdkt2cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIVoJFKLsd+GmKLJIP56L/AqueFYsBTzI89ga0HARPQ=;
 b=C09ETDyqccLuowvEocgnCvMyxXwxOoDVugv9L4tCw2is803IMnaomhLlCSDgL6BZl0X5XukfX5EebprUtLk9u0BeTrLiHacPzIVPTPtjRtMhuploJmPeie28kB0pN74dWMefjviQ2VOPIO/baw5O9JCvMiSim8U5ZBTrmjbryZ5ANztmJKghAxmHa3dRgMiTK4gZdPIptQ/Tam9r3XdlBVCPMVTkE05rYLIxovnC3K7V0+4wY4Pa0d+AgA7Vq7vUtclFsnuv6DYmJ0vnkAYInUiMdNGB8YR+4186tvpJR1qGQMa/B8V2bJg/SFl8N+i3UA7HtdACMvTkhvuyjFdzWg==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by IA0PR12MB8086.namprd12.prod.outlook.com (2603:10b6:208:403::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 18:01:30 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 18:01:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Date: Wed, 15 Apr 2026 14:01:27 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <68F85F77-8EFE-449D-B643-AEEB38CB50B2@nvidia.com>
In-Reply-To: <38697379-cbba-4c64-ae65-6774b01021d9@linux.alibaba.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
 <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
 <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
 <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
 <38697379-cbba-4c64-ae65-6774b01021d9@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:208:23b::15) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|IA0PR12MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: 18723a24-bfe6-4f0e-93ca-08de9b190541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BD1AbVlp8wmr5t+IgWB/fmoVCHKrdjjODuXoJ8wxphgJihZvXHT5ZHw6dfEwqUgUgJtyoSvgI6qWsbM4qZhaREc5yRPSLrDYgGVbwbiYtn9syPnn7VIvUFZygdBNt2nmuIFKyVSsL1W/hdgxjBaqktuh93Vr/RmRynxCo7rjX9lmDzAW+aWe1GfpsjON1dMxuKakTCeNNACB5xMWQhlw9/M4hGW9lztDbpfkUXeWBusDmKl9YzSSdb9jpYPc/sI+sFEzu+RtwcUplg2xAUUUBaVWMcGexZ3gf3510sdDhnVc8YAbGf3MrOUobe1eGn808EQivS+GMdNNFhHqJiAkwoReKPALQSt3F3boBSOMEN3xR42x6SHXozXxKt/y6WSh6tCFt6SGWBGyBTpgitFGu3lkMA1SVadiVBTgmgXnDeO4s9iiKbcfpRqyMlIfYIi4YUb5mNw5CZ4gwjb6IjC40dmGeufPkoA5uq/AfQi6LdcH2InUUWKzL+CORAsriXkGVTRfDRc8NF4a+LuD5kGvWrBJ7UTh2Vq4L3MhHHoRgLtMrvM/ghiqngO90wLmzHOu9wf6edVqhz3M8P0WfSaSChFT632HgFTHPCb8Axk3ZeOjT4mizVrNEKfCBLJ5NSPZey+s18DVU9adjBAWAIFMt4cuq3KbFtWFDg9wKqEqd1aaJ4+OMF4cmYafk4Od3l/0C4XcmYR+skmlqILswABnc5E5SilWqaY/ZajNN8tPCu8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MURVa1IySFg0WWR2ckoybDROVWpPc21ieUVMdVlKVVNjUkMwRmVMTFVvS0hv?=
 =?utf-8?B?c20wbFgwSitqQjZaRnBrY0c3RmJoeWZ3ZmtoeUlsaVBNc1F5b0dXL1dPdGh5?=
 =?utf-8?B?Nk5ReW9rY2UzV2dML2g2ZFJtUnpqU2NJRC83VWdjUGJiOGJRMzdHUFU1RTAx?=
 =?utf-8?B?dGpCYjg3QVlwQzYzMkxjTC9PMGs4dU1yWVVqRW9mUTBLU2FOSDR2d2ZkbEZI?=
 =?utf-8?B?cTBxUXlINUZWMEVIZjh2UURoS29Fbm5NVUdFbzUvNEkrVVhWQWVPR2lsclZ2?=
 =?utf-8?B?UHpaU0FGNFcvbDl1TkIvclpWNGVXTXNMM0JCdXgvME42dncvdFExVmdIUWRO?=
 =?utf-8?B?WWF3UGRvRjBhWVg2YWw3SkZQbFhGV0ZGQVVLY29ja2d6TjU0cldDYnRWWEEz?=
 =?utf-8?B?bGRxTWxoSFNQOG5pNlAwZHFFRSsydThWY2VQTWk2clp4TXU2Y3NXakdkUmRr?=
 =?utf-8?B?cXdLcUlFaWFsd2M4b3g4bjRLSEhhejdRRFhtMWFUQ1FlSVozMktEWmJLcHhZ?=
 =?utf-8?B?YnFwWkNNVi85N09EWHlUdUVyNTdqa0lCVWNWSWMrbHJFV2M3MU1rVmlBK09j?=
 =?utf-8?B?a3NpaHh6STdabWtIYTIzK3M4Z1JMVkdQVmdBMzUrVmU2T0YrMDJTUDdFOWhi?=
 =?utf-8?B?K1psMkxMbUJvODkwdDNEc2krdWRxMlJQZGEzNDFyY0FOdTFIQ2kvU3lKdnkv?=
 =?utf-8?B?SDh0ZElERGE3VVlCL3dSelJkMkJyc3BKR2J0VkpNMnZKa01FOVJnVitYbGdi?=
 =?utf-8?B?ZFZ5M3NPOStQRkNxL1dISHJMbWdDWWpGQnVqc3V0d01keTRISEVnUXJIVDVa?=
 =?utf-8?B?SWUwUlNRUXYzM1FsZDVMMTc0bHVydDg1YmtoQldwY0JaRlc5d3J5NGQ3RWJU?=
 =?utf-8?B?aHAvOFZuNm1NTk8rUlJHdEYrWVdRM2x1SndDbE50Y28ySG5DYy9rQW5PVlNx?=
 =?utf-8?B?U3BFM3JYVEdVNklma3pHMzExNlpxQXRkYXdUTndDVkRwOWhSN2Mvbkk4U1Rh?=
 =?utf-8?B?SjlidDBhc21taFg4YjhjV04zV1d6NFAyM2xwZ04wMm5JYlRXajBzL1JVUkFP?=
 =?utf-8?B?enFLWlJOYUVQNXRyWE1PUUlRVkNROTF4R2UvRjVZbW1GSEhXMjBmSEVyOW9I?=
 =?utf-8?B?bmhJZ0xpWlN5cUtYR094clhhcDFqdXBpZVZodXRkNitkMGZHOUY1UUdVY2pI?=
 =?utf-8?B?ZU9FWm1TaW9lQ0ZJakN4SmdNckJ0L1NEV0owWnZnRFkxWnFTZk1zWFJoL3Jq?=
 =?utf-8?B?VVFpL3M2Yi9SVEZFWTU5SEJxZnJ2Mjd0bXl6RVNzN3h2K1dRWlZnY0FNK0ZJ?=
 =?utf-8?B?cElza09INlY5ZnhSRU0zY3E4Q3QzWDhJM1hFanV1M3EyWXdYa1FYRi9TOG5Q?=
 =?utf-8?B?a012cHBGU0FBdFZUbWpvREdSblFqZk80eDk1Y3BvYUhVK09mdTlPR3pQUTdD?=
 =?utf-8?B?d1RqMGJ6blZSZDAyWW1UREJDa0VXcWlSMVFPZDRWS21VbldhVVFXMnJUd2JR?=
 =?utf-8?B?SkZpNVA5WXpwWlBGSW5HMzZFdUM2c3hGbFlSOUJZb0o0KzZKeUdEWGo3L2VR?=
 =?utf-8?B?R01oTE1EZWxpN3JlR3QvakJqSXNvNkwyYWgxNUg3MXRZb0xLQXoycmJDT2Vh?=
 =?utf-8?B?Q2VTSUpNZHBBc2g0aDNidmY0RDVXblNjb2l1aThtSzhFQmJqamllZVIvSW00?=
 =?utf-8?B?akNEQTdtWnZWSUwzeUJkTlpGTkpNVWVoekpzbWd0MkFhd1BQM0pra1VIbWNY?=
 =?utf-8?B?ekJ0eVZ1bTFCc1R6Q0J2ZGI5V2JiRnVGVFdRNUl6clZxclhLVEZlOEp0WkVX?=
 =?utf-8?B?Qk51Y3hmb2JmQkFMd29GdHNQZDg0T0d2TEY3YjhmWUpFOW8xN2ZzZkl3YUlB?=
 =?utf-8?B?ZTUrc01LQW9yWlNXZEFJQnN1MFZHNWk4aHRzazhjSjFBZFBHU3oweGtia1p4?=
 =?utf-8?B?eTRKNVhJcENCZjRnOXo0d0MvVEwwMWJmU1pFOFlWV0hvZ2N1V1dNbEZxWEhG?=
 =?utf-8?B?RTAzQlBlMUJIRmNERitDa3FTUm1rZGhFT2IvNDl6aExPcjNkLzdCM3JhWGtL?=
 =?utf-8?B?SUlLOFkxbWwxdE1TMFRZK0REeWpEaTBFSVNrbmtHdDFWdnl1RWRKQmtsdU1V?=
 =?utf-8?B?bEp1TVcxUGY0RDJEQ2MzMG9uWmJwMkhPQ1YvbnJoTHVXWlJva2NOVUZFRTdT?=
 =?utf-8?B?a2ZHd1QxQXpNcjZGT3NESzY4dG1WWGEwRmp3bU9qNm5ibEwzbDdNL3VTZ2Ri?=
 =?utf-8?B?Ry9PMm02VVBrRXNvQ1h5V25nUFhFSXlrdEJLRzFrSDJKYmFvanBaNkJSWFBZ?=
 =?utf-8?B?TEZ0cnovY2RVZDQvSFJvQ3ZMSlFvZEl3SWZqdVhjc2o4ZUIzNnk1Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18723a24-bfe6-4f0e-93ca-08de9b190541
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 18:01:29.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P6R7F+uh8MXQc3U73iwxz5LxatoLegmVL/pMj2dO3RRLKN1f4dR0r9OloS9LW9Cq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8086
X-Stat-Signature: 59fxupskk5x7frwfzhk3tdbj9xnwjbu1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 972DA4001F
X-Rspam-User: 
X-HE-Tag: 1776276103-197020
X-HE-Meta: U2FsdGVkX194kxaeRsd7Dam6Rbs8UKfPHL03s7R17irIt5mOnTDSukc9Tvb07lfzXqb4w82Vh2fxyYZy/znXGTRr+PrXdrq+6x5ppc6IMP7VjKxti1BjYXL1dVrrendxQuR6lBQF9vDoYUZCa+pi9tFdPtNrkAP5ELghsjv0MnjucbMynbmegGXnXyxKnznnCJWkISJrKOgKbdrGiziGgCvlkzF6UfYDt+OV6vvHJQGcuuCJQ2sTM83qm1A9957R5Aia7nSkJdMltI7XWvMgSQ237dVFS3PMoiqFeMDZhds6CEHeYalu6uwE9ozSmN/F4kveiY2hIvYPu3kk8621kBnXTvbPR6RGobSkRzldl/iYmKIP32HQ+g+96MKimaB78esqcGm9a2iBFDY1kwtLPQRG7qpDYqcKwzn+Z8YluWIO+NiG5dwZlYOdb+EcCttL3HsoLo3YtiOCUujV+jyCOyF2fwc/QoCai7mWMMQjMLgE7NSvPp8sY/4Py5t2KGxz/afsvBdI2nBkJhEb/0EXMpJwq0e/Wrjrzj0DeBir84Mcek86Rwf673VT0Df0SarUg7jmBXNktVoF1GyydK9AbHRH021Mr9qzdq7wgvh+WH7f0WO8x34CeEUODKe46SmS3zd1XDKTNmaUa4jm+AzkGa+bEtO5blT4FllgOV+PLkwYaOKrYMW4JwM46ayBBq8gxKUlwKTYGeWrmW1jUXHM1jdtCBRdk4KscIAFmCj+4XtcDquara7aQVfvVoQ2iSGovCxPprgo/KP08pZzB/6F3D25pVdYLNsR93cMF6K47odtA+krtdCcFIQPuviV2jmgzKPuZrxhDE/E2nTNTrFerWqb2Q6eS0dQKYDPUqXHtMxQF8S8fFM6xVSXuIbIAAvcao4hHnb2LfF732Q0trc4QequCDm2gbGUPvILwp0MIkmfqYVsjoAvr2rqYCIL5lw5k2/nCm2APjYJkIs49v/
 g5RNhIBG
 Ah6RCnHF0Bshb7vy0eQ339IImPYn3WpxBT6652wu4CB1+hdrUPHH+/uPot1NlOEdEHLMQfHo2r5upqEwwwbUXFcVqE5pwB2N89+9nHgL2aPuOcIrE6oTHZ23S1mjvhyzXSyEZ6ZczGK0c9HuLJOP8wobUwjJI1kFQnqmIaHR88BQoVsWE8A/4eqRiAzAEK7jAgSs2iEPRY5vR06Mk9BMnn4OlZp0Lt6AfAtNZUYWYtUWsYY9Ia8YVyzRJgHV4gj7eDKnoZzVIhG5wGkg/4giHIGLTqGSLNm6cJIq0pVT4HSYE1JH5A+YF9sLUQ7U5TrNvga9l7kFUMrkjIugQ/gSGxl9rBY83DehCc/RfmUYcBexWBbw8KrVO/WL+1uaQsoRXddQCHx6yg2B1h+YagW/ueCIC/A8M80NTkzjpUUpY66+tfQlyhZvWOOaU26l//DlptFi1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Apr 2026, at 5:21, Baolin Wang wrote:

> On 4/15/26 4:00 PM, David Hildenbrand (Arm) wrote:
>> On 4/15/26 08:36, Baolin Wang wrote:
>>>
>>>
>>> On 4/15/26 2:25 AM, Zi Yan wrote:
>>>> On 14 Apr 2026, at 14:14, David Hildenbrand (Arm) wrote:
>>>>
>>>>>
>>>>> Yeah, it would be better if we could avoid it. But the dependency on =
the
>>>>> global toggle as it is today is a bit weird.
>>>>>
>>>>>
>>>>> I don't think there is other interaction with FS and the global toggl=
e
>>>>> besides this and the one you are adjusting, right?
>>>>>
>>>
>>> I'm afraid not. Please also consider the per-size mTHP interfaces. It's
>>> possible that hugepage_global_enabled() returns false, but
>>> hugepages-2048kB/enabled is set to "always", which would still allow
>>> khugepaged to collapse folios.
>
> My comments are in reply to Zi=E2=80=99s comment:
>
> "I think hugepage_global_enabled() should be enough to decide whether khu=
gepaged should run or not. "
>
> I=E2=80=99m concerned that only relying on hugepage_global_enabled() to d=
ecide whether khugepaged should run would cause a regression for anonymous =
and shmem memory collapse, as it ignores per-size mTHP configuration.
>
>> The question is really which semantics we want.
>>
>> Right now, there is no way to disable khugepaged for anon pages, to just
>> get them during page faults.
>
> Right.
>
>> And we are now talking about the same problem for FS: to only get them
>> during page faults (like we did so far without CONFIG_READ_ONLY_THP_FOR_=
FS).
>
> OK. I=E2=80=99m fine with using hugepage_global_enabled() to determine wh=
ether khugepaged scans file folios.
>
> My concern is that for anonymous memory and shmem, the per-size mTHP sett=
ings should be considered.

OK, I misunderstood the meaning of hugepage_global_enabled(), since per-siz=
e
mTHP settings could also enable khugepaged if PMD_SIZE is set.

I will take willy=E2=80=99s original suggestion and make khugepaged on if t=
he global
setting is enabled. The below is the new version of this patch. I moved ano=
n
pmd huge page code to a separate anon_hpage_pmd_enabled() like
shmem_hpage_pmd_enabled() and cleaned up the comment. Let me know your thou=
ghts.

Thanks.

From 92b92f2b2ab41c70b41dd304ce648786ee6a1603 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Wed, 15 Apr 2026 13:52:50 -0400
Subject: [PATCH] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
 hugepage_pmd_enabled()

Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
hugepages are enabled by the global transparent hugepage control.
khugepaged can still be enabled by per-size control for anon and shmem when
the global control is off.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..586d27ce896e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct=
 mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }

-static bool hugepage_pmd_enabled(void)
+static inline bool anon_hpage_pmd_enabled()
 {
-	/*
-	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
-	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
-	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
-	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
 	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
 		return true;
 	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
@@ -425,6 +415,20 @@ static bool hugepage_pmd_enabled(void)
 	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
 	    hugepage_global_enabled())
 		return true;
+	return false;
+}
+
+static bool hugepage_pmd_enabled(void)
+{
+	/*
+	 * Anon, shmem and file-backed pmd-sized hugepages are all determined by
+	 * the global control. If the global control is off, anon and shmem
+	 * pmd-sized hugepages are also determined by its per-size control.
+	 */
+	if (hugepage_global_enabled())
+		return true;
+	if (anon_hpage_pmd_enabled())
+		return true;
 	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
 		return true;
 	return false;
--=20
2.43.0



Best Regards,
Yan, Zi

