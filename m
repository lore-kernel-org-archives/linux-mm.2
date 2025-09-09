Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6394BCAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9786B0010; Mon,  8 Sep 2025 21:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9616B0012; Mon,  8 Sep 2025 21:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A656B0022; Mon,  8 Sep 2025 21:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0C66B0010
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:44:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E989FB81A4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:44:44 +0000 (UTC)
X-FDA: 83868017688.06.72860A2
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D74A40008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:44:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HhW+3jFh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.74 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757382282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6Fe/yYoImzFDzeVRbr99Z6ZjcMpN1/u9Ej54Njh+dg=;
	b=ogrMde6BNlwwf5Mia4+QWz/3NcnzxvpQWHC0aXtnP44gu4WXpR8ojhQdGb4U4PxuVmrPUq
	jPOyG2n3ctMN01kY9CqQqasbj8SKWfyfBAz2ufkEWv+MncaxmlxDFzrpkWp4N9py0bifob
	S58YjQ/Rusm+H16vvaF8FwTulSwotXY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757382282; a=rsa-sha256;
	cv=pass;
	b=FGYUXJfX7oTDgGzKWLRzHNRKsZ/IYhoYVWwFEH16+FJIjguYwjMs+ZR2lR9kJejmvxazac
	Q/fqvHL60nxKnOCcRJLjN6xawewX/tLGNxBmVwVxvUa5dFSVqUFBaVhl/3ub07zoN7RHgH
	Vrb30XjiYlDZsOHrjNZv/HbrWCzRtzM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HhW+3jFh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.74 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwAi9oh0e1ufdq4S1sXCrkylzr0oR5X/Ns3EgNusEpEjMDaZwcqkvjgfwhW+zHP2yEk9e0URqnTxs8eaYABrLTrVcpi1DpBUOz2+gtGzFv2wvzFtuMOdqHUhSp7WmLEu7rtaN2ecGs5tM6NeAsF1SBRPWnmE2SBikkHHaIjLvmMeAXxRCGxXOJ6gS4KbtCmzXUtxlcG3efSUg7pL3SMrojJqlWJXNwnjqek2gVfxr87airLRDB+ab6ZkeEvHeTjobqPRaxrFiXFucnyVsOWSclchxk0yzjzf7zL3DZX//cRURdrXz3KgE+u8atiP61hTLUfR3HDjDtHM6MQEkGWsZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6Fe/yYoImzFDzeVRbr99Z6ZjcMpN1/u9Ej54Njh+dg=;
 b=LCYL+hXJ1mYMe0wtr5jAmvkQVfbvkIEnXW1gCi+2pLwMzWzAGwlXXWhhDy6RqAyLSsjINlK26mIhmljSbGAJz4bOsRKZLJMMajqj30gay55yca1v3mTcKg4LQ7cxveIp3K5G5h380br1KmTEl+h2aAcL4BbiexvVK8XQcshx/uve2lxuZfyb+Pdu9XLuVM8Zo7SbIGocnG7PNcRqpinBVKe8eHvlYnZMxrU+MfqIqA26g5ZyweHMCPq2t0XfQUdRSJUnX1JxEmn351wkFlz/QSSftAXsklQoHMgEIVZpL+8jsLiPmwuyCHscAj3bJDDkwd7gqORYJ6xvkQC03JOR5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6Fe/yYoImzFDzeVRbr99Z6ZjcMpN1/u9Ej54Njh+dg=;
 b=HhW+3jFh+bC9pkt6YxsHosMMeSOkyb5mnZKe3QeGzYWEHb0ycNBwRPSZhSd80jVmmilv/25cHYZRRaMvtx+MDB9YFUP6QfeFmJXatVt3C/HW3yNRFk8q+X2EUF8EZX33BCLepql+AXnW3xQKZ3mNvfCdK/hhKyvzUgoTMjx8sVkXQAdJ90q1EpU7l2yq/D2Fr/oiC8sntV6Wleorq8jQlMmDbEQfkW2Y+Y7wE3BcbUoM3U4GdSuh+0AleqIZllLVNyXTBvTH8k18Y3sMt9BmRHw8Ed7ILeZArfeWBjyLpPBNlqwPlruUfPP94RYlwqhBCW2ETBcPkD+gWhgfdclhgg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6830.namprd12.prod.outlook.com (2603:10b6:a03:47c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 01:44:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 01:44:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 6/9] mm: page_alloc: add alloc_contig_frozen_pages()
Date: Mon, 08 Sep 2025 21:44:31 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <298B40E0-8EA5-4667-86EF-22F88B832839@nvidia.com>
In-Reply-To: <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:408:143::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bde585c-fc37-47f1-aa04-08ddef426db8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjFYNWZ1aHc1M2FrVDAzakJ1ZFV3T1pjOHhDQkEwVnY1bHhjZnNXRnpWWGRK?=
 =?utf-8?B?QnF3L1lTdnYzbTNtS3EvWDJQd1Z2KzR6akxXNCsyQmxyYkNyRzIyallOdXZI?=
 =?utf-8?B?b1NyT1JJbW1LVFNCZlVQaGRLU3ZLM2x4RG03WFNwUW8veXNBN0NnUDRmUU9W?=
 =?utf-8?B?Sk5PdiszYUlRWFhoYVlPbXBzUXR1d25rMGVWZk9wWnZ5QVRINHMyZ3YvcFNu?=
 =?utf-8?B?UStOa24zQnhYZHI0WVROVU9tdGNvVWx1Ky9mbmNjTDRYWDZBcko5cXhvbUc4?=
 =?utf-8?B?dzU0U3lrL3R4TjEzdWZUcTVPWkp5WVdseDhkdDVaSDFHNy9mUVdpblNJRG80?=
 =?utf-8?B?M1NGbXBGVWNnMDgvbHNIM0FsSUcxdXMrVkpPbEtrdzdWQzlQbTcyUzVManJ0?=
 =?utf-8?B?U3lYRnZmaE9XRnFzM01LaXU0Y0E1SjVSODQ5ZCtScUFVTEZVUG9RWEIwQTJK?=
 =?utf-8?B?SXRPZWVlVDZWazVqbk1SRE1pcjBXSm1WZmFDckRYTmpOeno3ZnliU0w5S21r?=
 =?utf-8?B?SW5OMmpETzhrMXA1WFRaMTBLRUJXV1dQc1dsSFVUVDhVUzErNGVmb1l4K2Zs?=
 =?utf-8?B?UjJqSXFmejJDSWphSVUvK043TWY4aTlrOVV0cXZKa25GdlpXc2g0eEdzY1Vn?=
 =?utf-8?B?ZHUrbUJGYkErdENtWk03WmdqWVE4M0E0UUVqNmV5c3JVclp6bThEUjFKdGd6?=
 =?utf-8?B?RGZQQ1Qxd2xGTXFmdlVHMnJmL3UyZjU5alhkbzh2Yzg3dGltM1FvTktMSFB0?=
 =?utf-8?B?cDVjMU9IditIQ0RDMXBQRDNRR2ZHVzFBQkoyZFk4bGpIOUhrWWNGejI4MEZZ?=
 =?utf-8?B?TUcrVnRBUmc3bTRadTNwemlYQ0p4OGFPYTUybkhyakNneVRONHkzV1NNa1Fo?=
 =?utf-8?B?cXkrb0NaWCtYUkN4S3dWSTZtZkpDSmtEVDJYT2x0WHZvL2lFM2tFVUlLR2Y2?=
 =?utf-8?B?WFhmUmNvd1VaWDFkVmVETnBRU3JTQzFReTAxdURGc3hReXpzdHMwZGpLVDlW?=
 =?utf-8?B?UVhMTmljY0VySmF5WG93VVh5OVB6ejVVV1UyUFpvdUJGQ01lRzdoUjZSUDlU?=
 =?utf-8?B?aVNVdTR4MHpsa0hDVTZxZk4vNlhZSzZkT0JsWXBtVDdqUkhLYjRDdnNFanNu?=
 =?utf-8?B?QXpGS3p3c0VJaDd0QkJ1SnN5bnkxeDZEZkptZURNVlRGTUZ0eEp0Y0lWUGlL?=
 =?utf-8?B?eVlTbVNtcnc2TERoSC9qeU9tbE1McndieklNdVJUcS9jVEZsL0pwTTNvTFQ5?=
 =?utf-8?B?dU01RjJZcjNpQzFabVd2K24zempva25HMXNnNEk0SitXSGxCcHpDcFhuUm5p?=
 =?utf-8?B?alZtL2pmR1o4UEZIVERmLzZqYUhYbWh0Y0lENWk3TmRHSWpGUVpVdTRsTGlB?=
 =?utf-8?B?WVhrZGdXVnJjeGNRRjFtNmgzNnpBSHlGUVdIUCtnbTFyamJhbnhWS1pVd3Av?=
 =?utf-8?B?VW9UYUhHYlFoRk4veTdZK09TNk9RTDZoTmlOSktvVXQ0UXVNVnU4blJ5Y290?=
 =?utf-8?B?MkJnbFk3SkZSaVM5M1pxNXNTYnErcC9FVUxRRkJwNFlVUnVJS2s5ZFFwT2gy?=
 =?utf-8?B?bHQyY0RQVjRnQzdkUEhWMlI5SEo4a2dpSDhIV1dUWm13ZzBrZlNXdHZ5MDMv?=
 =?utf-8?B?TGtXUUhZdmR1NVVaeGRYMmMxOVN4MWdkWXpkNUJmWnhRVDNNMVBTWWEzMmo2?=
 =?utf-8?B?M1EzaUVRV1gwK3ZVTzVjZUgzbnVoazg5MDhNbVYxYSswWTlhNExUbkFvVXli?=
 =?utf-8?B?Um5MVyt5dEdVMGlUeWd6VUlOTzJPUWdHck41MVJQaGsyZ0hTakFNdFVSZjBJ?=
 =?utf-8?B?MVFBSmM3c0ZsNHY5UE5ONGFPeGtoNFBSc3dGcEVjWTRoUzl4Sk10VnZHRXJP?=
 =?utf-8?B?OHZVeU5DWkgxYVBjUEpzeWZBN1VRK2tVekZWWFNVVVA1a3F6ZHpQRi81WW8w?=
 =?utf-8?Q?U3YLb86jaL8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDFKbTJSQ09HKzhpa0FucFF6MVFxRllxYys4WUJwdnQwQmhmdDJ2SDhaU2ll?=
 =?utf-8?B?THBTTysrcitYTm5tR29ORWQ0WGRTRTZTVkUvQjR0b1B4b0VEamZnMmR2NmxP?=
 =?utf-8?B?c0U0MERNL0xCNnRjNllyaXQ5NkRuUkdRdFRPbmVFeHR6YTlhLzN2TnJaMXJQ?=
 =?utf-8?B?cjdSd2ljT1hoOW9jcmhBeVJaSmVZcU8yWE9vU3dyUjhHbU9LeXRvVHRITGRw?=
 =?utf-8?B?MlZxT3FHRmhHVVpoNVdtSWxhZTFLODl0MitnMVd4R0ttQms4UUV6Q0IreXNi?=
 =?utf-8?B?KzFpT2RtQW9KdDZDMWRtTVZQZ00zT0VKV0NQZ3ZPNlF6OWkxMXFScERPR0Rk?=
 =?utf-8?B?dktRWUlDQ1hDRzQxVm1kaG9lY0QrWllrUUtXZ05CZGVtZzRPTXVTWjdhZXBS?=
 =?utf-8?B?cnI2b3lnR1ZoR3I2Q1p0RGxCUnN2OUdjNmlNRnZWeUg2V3p5b0ZSWXpQWWMv?=
 =?utf-8?B?elBWZCtXUnBJR3YySUhkQnJvZjRsQTJiMklCNDZteFNnMWQrdHVsQnZnMUdD?=
 =?utf-8?B?VEduRXAwd2s1Ulh1YWlVMkpKc1VtWENFMjZTeHFTYzlRZlhTYWZrOWxGeXdk?=
 =?utf-8?B?cUs4VzJ0VEMxYVBHeDNWRUVQalE1bC9hNm1RNEJyYzRjWXBIcjZ0VmxZb05h?=
 =?utf-8?B?UUYrMituRk95RkxXczdCU0dtNnVRQUIxTXZHdlNHSERmQ0xUMHQwdXlobUx1?=
 =?utf-8?B?dHFTZEdDRzE1MWFJUld2T2dmb3JqMm9yeTRiUDVGUWttUHhXQ2tjNmErYjV6?=
 =?utf-8?B?RHE3R2Z4alU2SVhXSUhOK3JxUjRFbThUalEvL0ZLUmlTZzB1bGN2RHBSZGRr?=
 =?utf-8?B?Q1MrQTJQVUJ1OWVHVWNzL1lPK3EvSzdvY3lqb21ocnMranJlQ0tSYmV6ZDRr?=
 =?utf-8?B?RzZ4UWFrL0NrYzE4Ukp6YVZOZVhXY1B4RW9ueXByQlBwZ0ZJNmN5cFczSzQ1?=
 =?utf-8?B?YlFkYm14NjhhUTBZb0o1b3VlUlkyY1BhREtBQm9ZSlQ2NlNBd2pjNGFJTnRj?=
 =?utf-8?B?QlRHaE1aNEtxNncwWExvYUlDZ1dEcXBCejNZZUZsby9xck54UGpscEFLdVNu?=
 =?utf-8?B?Zi94KytuZy8xMjJOU29mYVVtRkQ3UDZ0MmxxSWNtN2VLdCtDb01CRmVwYm9h?=
 =?utf-8?B?djRsNWJZZjhub2FsbVpOT3Z6cU1QcHphU2w4WFNHUm42V1VGaXhTeVpmVXZo?=
 =?utf-8?B?T0tGVGVwQkgyVktFMHEwVjZTcTkyWW5UMG1uejlMQjU4UXB3NHpLaHU5b2tS?=
 =?utf-8?B?OENISFF0YVowRXd6M0xjcG9xZkJjSVpNbWkvbDZtY2dwUVRza21hVkdDaVE5?=
 =?utf-8?B?UjJaS2dwdnArd3NjZlpOYTJqTzlqWUZsZFg1KzJDVk1uVnVWeTIzdFdueTdS?=
 =?utf-8?B?YjhxSldrV01DcVpYanlQQnpUajN1M3VoVkU0dVpWWVF0UHhkOVFpMlZNa1I3?=
 =?utf-8?B?c2tuNitwVzM0NEt2dE5ZNHBqRXJmQnV5TTBUbFNZMUk0WnVjWFlBWDAyZWJu?=
 =?utf-8?B?NndZZEtOQ1R2Wi9jaCtFQmpMbVlzUTExVmU4TVdweDJCbkJsdkozQjRiMFdp?=
 =?utf-8?B?azBpOVpDU3d6dlVMTmlXVlA1c0VybTAxYkozemVuaEgrS0JYMklsU1NGK2VR?=
 =?utf-8?B?LytYaTZUUEw2cFk0THNrQ1Y0R29RcDcwUEoxMVNXVHQ2Y3Z4VzF2TThIdi9J?=
 =?utf-8?B?WFF3OTFKdlVVekJzb0RZT3lIeEVIb2tCWm41eGszUjVOMDhEdHcrSGp3WTc4?=
 =?utf-8?B?UnlCNEc2QkkzcXM3b1ZQY1BZc1VKdy9KOXRLR1F5ak9MUDgyYklGYWZhVDNH?=
 =?utf-8?B?UVNuVWV4dWFqYnpmZHJ2eEFDblN4UVVxOGlJM2FEZWNic24yWXZUZzZGMXVI?=
 =?utf-8?B?MXZ5ZEdDMnVUdDREREp6TjBocDRnc2VXWUtwWnA4YzZpenRKbEZ1U0I0MHNI?=
 =?utf-8?B?RVlPOTVCUTV4OVIrV2ZSWTdCQlJLQmhxMUd0QkNuYnlaMlNXQlIrNjI4K05E?=
 =?utf-8?B?aElwaVI5WFc0cHlWTHRyeHpJS3FBdCtSRkE1SnhvZXdFa0tYRkVOempneDNX?=
 =?utf-8?B?L0Z5a2IybFR0M0RZbWt6WGJUNGNSYTFZS0RPMXFSVkVINzhSKzJPMDI0ZUNH?=
 =?utf-8?Q?9cDw03LMUspO9p6v0sreNnev2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bde585c-fc37-47f1-aa04-08ddef426db8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 01:44:34.8235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKt3EKCX/PdwMOIbSE+3HEfg1liPe52+ujn7pjqj1+ENkWkFDH29MC6N0VxVmcyt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6830
X-Stat-Signature: pe5x7uiprbwj4t67hoxz18wyc8r8hubh
X-Rspamd-Queue-Id: 0D74A40008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757382281-546487
X-HE-Meta: U2FsdGVkX1/Y4SNyh1mhvbKvDa/e91UoEAnWonacMHgXEY9mb/QWR1E6JRGogVdAkU9EGvNnoye0Rbf6RjhiimK2NBJXXOc8I+oBZ/axw0J/Ijg6nauSZ/HsgTp7d4BI73h36bjYgbIu919j51oN9f7w/namHc98r3DyNx2e7KQphF5WNtAwwkTtJb8HOh/kuAFxB1vKWo0c3JkEAzcbeTL9+QZ/iRHehvGWnr4IJjZ7iKYDWlIqCN0vuf6zmkLkm+aRpXBoWIdSqSz8wqI7V5h+y3E5hnOprDhC2PQ4KZhLEhig2/d6pnqpfj7zwX7Pkmt/sxLNzbpvSRtkxn2YDupM40kmqzvu9Qi/dopklp/XeVcUeHjUQ8UWm4L0gx7SRWth5uTSTVcY7RaebkNAkdQQMPw8O81aBwoxzQiyT6IS7bA47kqMA51rZz+y9xcu1L+7qLdIZYmaqVfXepn5j7QPsfoHZgLvWskn4r66VyokdFle8XYd+DaJc9mhvcDowBjJEgMv1iN3S4UWGtgkiCQ9a2busmRNeHgmeVuWKnDb0wP1xhVq8BF+zEeXNzYtygB0a4NJgnvPWOqdKFzSO7jjxVLnQBBEzhfGoT78SlYjf+5mX3j2N2aP6PNYhoxW8m09elUFrAFIjpbUrJbhQ4DV3Kmk+t1WeJCLhS5v9gJjKtgIVYjgRVRP464XvpYw1TtTTRYN8sh3AuN3Nm1gVzuSTXBWRtAvxsFfe0ZNM/KVWXjz6G6Ze/UpkfXvLGfDjo3rb4pF8cgyh/vHqNv82dU+ZYq9wWqTdxXBlwBc2M13xRGc1HRgvi9gqarYrFX0+5uEPmAdZLwt9vYaEFuu0YSIvZGMBJMKUY1GCcAz7wrBOgu0X/UscW0SX8QEzubVxD93vzWVOVNhCljWIJemT2c23+unnK/EvevLQb2wR5SatZgFR9RPLjXlrH9LICxrYDIWXvHKOWdMPU565zz
 Q+xe21tJ
 fA4+BLiYQyaSbbrepVnTNW/sRmUmKHipyDJhnXOn+l6tQtffVHf5Whz3UPm2uMu81GJHgmiE1tJADv82bNvdUAaknMXmIirjXEh0vrRil3h9gwo1IQ4aruddpCf1PeZSMrjwEVqks5M62l1Q9wXWBtPOic+napkcWUNiPktZ52o7Lyhmb4bDzfNLs89KP0UGV0p9Gx6Edz/mqMaFAol03GNBJrd2IhxYxXKjMCj8vNkek7MLQ46chn9EW/waigYilIqIhftalMJYwaju6Qq51fEpcS4SB+k3vqFEG+DbWgPzyow/Nd5EwBHUT5aCvcCyTew4bGpKajf7wJQleFAHl2LCZ64rYYmp2eAHhxCdNBF2ho0HLaJDwI8o/W8G9/HPKJXgpso1XD2qiSZT96caIP+fb6tFcqMPy+/tQzynAPe8NHGPjoHp/fc54GujDy0sjEBwgb+45PemHfQO9CdtH/1pR/u2/O6ji+PrEpWOqJIAG167v/of7vMh3KKnpJchjAxcay72b2h7KBjpixeIsFklIuO5atFpNciLDWSY2O5CsOlalQlRvcGrTrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 8:48, Kefeng Wang wrote:

> Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to
> allocate a frozen compound pages by alloc_contig_range(), also
> provide alloc_contig_frozen_pages() to allocate pages without
> incrementing their refcount, which may be beneficial to some
> users (eg hugetlb).
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/gfp.h |  6 ++++
>  mm/page_alloc.c     | 85 +++++++++++++++++++++++++--------------------
>  2 files changed, 54 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 5ebf26fcdcfa..d0047b85fe34 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -427,6 +427,7 @@ extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *=
vma);
>  typedef unsigned int __bitwise acr_flags_t;
>  #define ACR_FLAGS_NONE ((__force acr_flags_t)0) // ordinary allocation r=
equest
>  #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
> +#define ACR_FLAGS_FROZEN ((__force acr_flags_t)BIT(1)) // allocate for f=
rozen compound pages

ACR_FLAGS_FROZEN_COMP might be better based on your comment.
But maybe in the future, we might want to convert non compound part
to use frozen page too. In that case, it might be better to
remove =E2=80=9Ccompound=E2=80=9D in the comment and then

>
>  /* The below functions must be run on a range from a single zone. */
>  extern int alloc_contig_range_noprof(unsigned long start, unsigned long =
end,
> @@ -437,6 +438,11 @@ extern struct page *alloc_contig_pages_noprof(unsign=
ed long nr_pages, gfp_t gfp_
>  					      int nid, nodemask_t *nodemask);
>  #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(=
__VA_ARGS__))
>
> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask);
> +#define alloc_contig_frozen_pages(...) \
> +	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
> +
>  #endif
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index baead29b3e67..0677c49fdff1 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6854,6 +6854,9 @@ int alloc_contig_range_noprof(unsigned long start, =
unsigned long end,
>  	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>  		return -EINVAL;
>
> +	if ((alloc_flags & ACR_FLAGS_FROZEN) && !(gfp_mask & __GFP_COMP))
> +		return -EINVAL;
> +

... add a comment above this to say only frozen compound pages are supporte=
d.

>  	/*
>  	 * What we do here is we mark all pageblocks in range as
>  	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
> @@ -6951,7 +6954,8 @@ int alloc_contig_range_noprof(unsigned long start, =
unsigned long end,
>
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, 0);
> -		set_page_refcounted(head);
> +		if (!(alloc_flags & ACR_FLAGS_FROZEN))
> +			set_page_refcounted(head);
>  	} else {
>  		ret =3D -EINVAL;
>  		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> @@ -6963,15 +6967,6 @@ int alloc_contig_range_noprof(unsigned long start,=
 unsigned long end,
>  }
>  EXPORT_SYMBOL(alloc_contig_range_noprof);
>
> -static int __alloc_contig_pages(unsigned long start_pfn,
> -				unsigned long nr_pages, gfp_t gfp_mask)
> -{
> -	unsigned long end_pfn =3D start_pfn + nr_pages;
> -
> -	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
> -					 gfp_mask);
> -}
> -
>  static bool pfn_range_valid_contig(struct zone *z, unsigned long start_p=
fn,
>  				   unsigned long nr_pages)
>  {
> @@ -7003,31 +6998,8 @@ static bool zone_spans_last_pfn(const struct zone =
*zone,
>  	return zone_spans_pfn(zone, last_pfn);
>  }
>
> -/**
> - * alloc_contig_pages() -- tries to find and allocate contiguous range o=
f pages
> - * @nr_pages:	Number of contiguous pages to allocate
> - * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only=
 some
> - *		action and reclaim modifiers are supported. Reclaim modifiers
> - *		control allocation behavior during compaction/migration/reclaim.
> - * @nid:	Target node
> - * @nodemask:	Mask for other possible nodes
> - *
> - * This routine is a wrapper around alloc_contig_range(). It scans over =
zones
> - * on an applicable zonelist to find a contiguous pfn range which can th=
en be
> - * tried for allocation with alloc_contig_range(). This routine is inten=
ded
> - * for allocation requests which can not be fulfilled with the buddy all=
ocator.
> - *
> - * The allocated memory is always aligned to a page boundary. If nr_page=
s is a
> - * power of two, then allocated range is also guaranteed to be aligned t=
o same
> - * nr_pages (e.g. 1GB request would be aligned to 1GB).
> - *
> - * Allocated pages can be freed with free_contig_range() or by manually =
calling
> - * __free_page() on each allocated page.
> - *
> - * Return: pointer to contiguous pages on success, or NULL if not succes=
sful.
> - */
> -struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp=
_mask,
> -				 int nid, nodemask_t *nodemask)
> +static struct page *__alloc_contig_pages(unsigned long nr_pages, gfp_t g=
fp_mask,
> +		acr_flags_t alloc_flags, int nid, nodemask_t *nodemask)
>  {
>  	unsigned long ret, pfn, flags;
>  	struct zonelist *zonelist;
> @@ -7050,8 +7022,8 @@ struct page *alloc_contig_pages_noprof(unsigned lon=
g nr_pages, gfp_t gfp_mask,
>  				 * and cause alloc_contig_range() to fail...
>  				 */
>  				spin_unlock_irqrestore(&zone->lock, flags);
> -				ret =3D __alloc_contig_pages(pfn, nr_pages,
> -							gfp_mask);
> +				ret =3D alloc_contig_range_noprof(pfn, pfn + nr_pages,
> +							alloc_flags, gfp_mask);
>  				if (!ret)
>  					return pfn_to_page(pfn);
>  				spin_lock_irqsave(&zone->lock, flags);
> @@ -7062,6 +7034,45 @@ struct page *alloc_contig_pages_noprof(unsigned lo=
ng nr_pages, gfp_t gfp_mask,
>  	}
>  	return NULL;
>  }
> +
> +/**
> + * alloc_contig_pages() -- tries to find and allocate contiguous range o=
f pages
> + * @nr_pages:	Number of contiguous pages to allocate
> + * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only=
 some
> + *		action and reclaim modifiers are supported. Reclaim modifiers
> + *		control allocation behavior during compaction/migration/reclaim.
> + * @nid:	Target node
> + * @nodemask:	Mask for other possible nodes
> + *
> + * This routine is a wrapper around alloc_contig_range(). It scans over =
zones
> + * on an applicable zonelist to find a contiguous pfn range which can th=
en be
> + * tried for allocation with alloc_contig_range(). This routine is inten=
ded
> + * for allocation requests which can not be fulfilled with the buddy all=
ocator.
> + *
> + * The allocated memory is always aligned to a page boundary. If nr_page=
s is a
> + * power of two, then allocated range is also guaranteed to be aligned t=
o same
> + * nr_pages (e.g. 1GB request would be aligned to 1GB).
> + *
> + * Allocated pages can be freed with free_contig_range() or by manually =
calling
> + * __free_page() on each allocated page.
> + *
> + * Return: pointer to contiguous pages on success, or NULL if not succes=
sful.
> + */
> +struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp=
_mask,
> +		int nid, nodemask_t *nodemask)
> +{
> +	return __alloc_contig_pages(nr_pages, gfp_mask, ACR_FLAGS_NONE,
> +				    nid, nodemask);
> +}
> +
> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
> +{
> +	/* always allocate compound pages without refcount increased */
> +	return __alloc_contig_pages(nr_pages, gfp_mask | __GFP_COMP,
> +				    ACR_FLAGS_FROZEN, nid, nodemask);
> +}
> +

When all contig page allocations are converted to use frozen page,
alloc_contig_pages_noprof() can do similar things as __alloc_pages_noprof()=
:

struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_ma=
sk,
		int nid, nodemask_t *nodemask)
{
	struct page *page =3D __alloc_frozen_contig_pages_noprof(...);
	if (gfp_mask & __GFP_COMP)
		set_page_refcounted(page);
	else {
		unsigned long i;

		for (i =3D 0; i < nr_pages; i++)
			set_page_refcounted(page + i);
	}
	return page;
}

And ACR_FLAGS_FROZEN will be no longer needed.

I looked at the code briefly, it seems that we need:

1. remove set_page_refcounted() in split_free_pages();
2. a new split_frozen_page() to do split_page() work without
   set_page_refcounted() and split_page() can just call it;
3. a new free_frozen_contig_range() and free_contig_range()
   calls it.

Anyway, with the comment change mentioned above,
Reviewed-by: Zi Yan <ziy@nvidia.com>

>  #endif /* CONFIG_CONTIG_ALLOC */
>
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages)
> --=20
> 2.27.0


Best Regards,
Yan, Zi

