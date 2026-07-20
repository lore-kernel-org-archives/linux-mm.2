Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92495C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8062C6B0092; Mon, 20 Jul 2026 10:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF0F6B0095; Mon, 20 Jul 2026 10:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CD1A6B0096; Mon, 20 Jul 2026 10:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DECA6B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:44:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF75CC01DE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:44:46 +0000 (UTC)
X-FDA: 85009426572.26.EECD1D7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id D010C4000E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:44:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EMzi8MlH;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcZGIt4gNyuAbF5KLw7GyUEKxnAcOOqEJ552WEIsaRM=;
	b=XqiHQ9wdUkIp6McX7A3hyzacGXxmW7XL22sOvsZHk1HL1ILnx0eEBpEYh2ytmOq33OdLFo
	t7uF7Y+dZ2xuKUz2DStL45NQ+ma2LCs857ddGN2+LosT2Awy3/MHRrcuDuakPOegQsdgvL
	kGrI9ygwmkaU/j5Nfy1Yo2ex+Tv0St8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784558684;
	b=beCw1QYfpVvKDA9ge3q/jyVdVXyw9l0Ieg4WczbuZg7totNSYLm1817Z+dm2bmBNLqn9+U
	i4erkrM1ZNTbE4NJgvUF7KRQ1CDvqjSvyWLT55bNiJcK7fH5EYoLUoDHI8WHwC3V3b58TZ
	mW2GEo5Uzk9T4+llaXhT6tz3tiJBIQE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EMzi8MlH;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLscsfPrHgFryp6gqFJvhKrQLpplNGu1fLZFafWcj5uE1/60mqXnBJyydWMfHiQgJi754keqgJF0egNPo5CI+LbrjB/ZaWHrrWDOTaUy/+FQxX1MJo7UItZ3FGSJ3aqij9Z6Rq0ceBF8gg3zfv8Vh3kAqbvFgL2OxCIlvLhVfwogim2zeu2+B0hEp/PPyWFkU99jThG57LsnV9rpfg2ZUCC7VuzuS5oM/ERKcTUTvvEYacEgoJnKPg8WCagbKl/9iJEmBIpJLhkoPLJLSVNEix8siU/6FBaSOlMKuC0ZfhEfNMM68uOCNev8zSqyUOP3bzWVgAemk1HPeTWPCJs0Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcZGIt4gNyuAbF5KLw7GyUEKxnAcOOqEJ552WEIsaRM=;
 b=gkvQH/7AVywZHXrosgihj9YqkiQHtZazTb8G6POEx91oalT1sODctFINxZDufJkdLsJdh+8lhveF4n0DIJTAvJSnIk2TOmRMsgl9hSZrzXYXhVqdeOl9hEEJi6F/TXbwW0P3EnsziSw325Z3jDFoeYhTQuT1gR0V2eFc4BeshYUe/Rdqf7USPtOdfSZtT+u9M46wX9TLHdWIHt1+3qgUmboTimS9i7HAA9hpIOd79fi0PaTUMoQJ+MWL5+IJXQlnQ1WwzeLZSb62JEBWB1mE+7Pl64Ns63dAka7nVR2Hfm1F+beMn6JwFKChSvyBfxp8+0RXGZF1j9ozlIKV75yQYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcZGIt4gNyuAbF5KLw7GyUEKxnAcOOqEJ552WEIsaRM=;
 b=EMzi8MlHDIg/YqdVC/mAXttzE7p1kn11QaXEBgqAwAb4vqptXhcFsqrLObfKcw0RWunHN7IDGuUnLm/dXWshDMhEyzySVZYXN3dRuZBq+SSS7snHP8DrGPHmu+Rb3MKu0kA3SW0UuMb40rEUw7nRMYB09SNgJscKJntzc3/o8fjSGMJZITxDnGmWAr2vg7kctTb0cx4or0X8eI37IH1jjT6S4nEJO+TP/tFX/TlJ94VBEwcm/iRawGw+t3j3GzwAtxDDLH6q3I4BWcuxQ2NmticWPbA4Cjk+8kKCkz9MQpD3VQ/tm5m5fKAdhzKeVItOyUvBZVm9N+N3s4aUEzSZhg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW3PR12MB4379.namprd12.prod.outlook.com (2603:10b6:303:5e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 14:44:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 14:44:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Shivank Garg <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Alistair Popple <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Karim Manaouil <kmanaouil.dev@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Teja Vojjala <tejavojjala@google.com>,
 Pravin Tamkhane <pravintamkhane@google.com>, Kinsey Ho <kinseyho@google.com>,
 Wei Xu <weixugc@google.com>, Matthew Wilcox <willy@infradead.org>,
 Davidlohr Bueso <dave@stgolabs.net>, Vinod Koul <vkoul@kernel.org>,
 Bharata B Rao <bharata@amd.com>, SeongJae Park <sj@kernel.org>,
 David Rientjes <rientjes@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>,
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
 Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Tejun Heo <tj@kernel.org>, Fan Ni <nifan.cxl@gmail.com>,
 Jonathan Cameron <jic23@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nathan Lynch <nathan.lynch@amd.com>, Frank Li <Frank.li@nxp.com>,
 Dan Williams <djbw@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Mike Day <michael.day@amd.com>
Subject: Re: [PATCH RFC v6 3/5] mm/migrate: add copy offload registration
 infrastructure
Date: Mon, 20 Jul 2026 10:44:34 -0400
X-Mailer: MailMate (3.0r7022)
Message-ID: <19F47514-EBC4-4659-8252-EC3765D9B601@nvidia.com>
In-Reply-To: <87wlupx60s.fsf@DESKTOP-5N7EMDA>
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
 <20260630-shivank-batch-migrate-offload-v6-3-da95d7e8b8a2@amd.com>
 <87wlupx60s.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0134.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW3PR12MB4379:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d4da827-2225-4846-31e4-08dee66d6bef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	s/wlNzxSOxWAjXqAywyeskzCCsnwRIHGBo9iFRlHhx+/XNTrBnIzAxY8QNyp95XOqTZb5MxubhhZ3gKgcFB4OlpLgMGKjUgfXSjgMCc0KXjrQ4XsiosNXDbymEya8QvBQpJpmcN6TOtiCDMSsa/04HaeuDpvP89pfL0OxtVrQbxWtmywIUpP5iYi1AjGHOA663MpTqFGXcgz3qYT8oyhtM+t1lQ5exSiUhWtv84UH+SdYhvfqfp7+2nhMxW4//v8uJQo3g7WMelMEtwzZMrNWxXkwdumMuWnNy/ZlU9b8Fa9WxG+ikupnIsE62detmGrYgp5XIW1v+lFUtPH+nNtTvH8HZ7TKazgQDQztDvleN1nljvKuyPKZ9j8lxO05OVGKuvi11YBOEXNmpc/cEgMLIVNwOBoGTRoFfFjPt08xmNN1p/q78MI6G/78AzDE29wYT1LKZxNaWrnZPBDagUnR8eY9OieynkXnij8QpXnBd/su3MgOf8ppsly7GqPpChhTx9YiIS4JDM34d4qchJ2A5F24FRXLO3m7FZ35v0eKpN1Z6f+sZunIsA4kXarDC8H4jX649rtZ7ALU7+UU/gSaBSu+Js/f3c02/f0lFjxY+XaMLnBAt4Yk1YRaityEgei/ZpsRfEF4n7FjQ8mQQ/k1yL2IDF51hMEDYUxTIaAIC0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NGGU51x+p4dyP8LLHvRPz0wHddGTS9CkMpHaRvhU0XbxdAajpvFNQj7EihOL?=
 =?us-ascii?Q?uZWMgkuTQT2vA78qsoazmLPg+EUxYFBy/W05cOe1kLd5MRCyIuPsMJdXL0hl?=
 =?us-ascii?Q?fee+Ttz49IoafHfdKoas0xX2ScL72omwf/6cYq4X0KOwUbZnTuaRl7/AO0b4?=
 =?us-ascii?Q?Kpus0cicRhGxXYYeObQ48Ru/CGyUI9c42dJQs6aU/ePjb2xycO8jVv7pDAme?=
 =?us-ascii?Q?wO6QYIt4nN9SVreOJhwMF8MciY9yT7XdiYIZ/grEXSW6yc4x6talAuCiFX24?=
 =?us-ascii?Q?dNbIBQ/s/dii38TQdiHmp40hXSFAwO0IThW1Zn5GXHqn7q4PUBJATe3aJ0o3?=
 =?us-ascii?Q?OcTBAa0vTWSOvCymjssCKvj1ae2K+rx6S8K74kN1f8Xcf5R97K9f6gBhPcup?=
 =?us-ascii?Q?e4m7S2xKW3c1PGCl4oTig4SKuUX0qpZn5irqatFKxoY7nS9LCE/3UjOegnmz?=
 =?us-ascii?Q?xbULni1VRHcdd5tIfTd1N2Fy7n14+cyj/wg/lInHsbjXllISsDfJpsmzv7uw?=
 =?us-ascii?Q?RwvtuFuzioxjC6i6Kah7nS/MWK2qdOtSbGcP30ZEyJ4sXggytjuDFo9dABxg?=
 =?us-ascii?Q?C5coWGITFvNMiJaZN2jAxRQlvF8eUEyiGejJfVKQ+AE5cH9NwxVPBTm38/Ef?=
 =?us-ascii?Q?9x+WNgQhijxQxPTbMoXY4/qeiBdpP5Rmroa5Xz9JMVEiFn2yynUbCP705OaZ?=
 =?us-ascii?Q?bhVuJwGzJzKMrgq0k+CuToV3O2x7yQXRW1E/5VZvbIoq0Lr7tPIQ5GYtkJ8Q?=
 =?us-ascii?Q?TKf4FFnttDAre3rPApwXie9VG2n+VW+9YrORTl2C+f3VM9aypYsW28NLqS0/?=
 =?us-ascii?Q?424UUvNYqrsw0TcHhZHi498nZ1VB2LZkUhDp+kKB8OeG6PSxszVMWqKpINQV?=
 =?us-ascii?Q?SlOe17jIl0G8FHkQMZfMAoKOO8UvuQgodtpjADH3PPJAbwmLWVa0KNqA9hiL?=
 =?us-ascii?Q?8nfhu7RQZQhzbG2RNpBPvy4yzluY3UvhCAZi494lyuV0S4laO+FpAQJ6B9jO?=
 =?us-ascii?Q?iSb2ADqFbHe/r0K/5uwzQRB7zfCnT8/FdR4f0mEc6Kuyii0WdM9HJtPPAdO2?=
 =?us-ascii?Q?/ZG6apUuaKWySmlliKMQ1EgzQthFxdmwYA5jb+HefJJSlKIvdj5LOdg3ixvP?=
 =?us-ascii?Q?F4MJixBN+2sYR32vLBbDkFEcISF1yYD0aTFOhhJKHnbtahXUCj/QvvyIUq54?=
 =?us-ascii?Q?eqWi4i0Se1ZgpipuR29ST0dcSfT7RMSFrfW+QH6keyNJFpDekkPECEAIj9up?=
 =?us-ascii?Q?ZjMM7meTPEx2xK7S6n6tBR6BqolKF5yFB5/tqe6ErksRGL4wJyoqYOg+8uPj?=
 =?us-ascii?Q?pXUd6w1GStdRRwtzm4VhD/i+T6h3TK05JDUUa75JwH/HivpjAsh+7KlwaNvB?=
 =?us-ascii?Q?oRd+IcZNsEx6pm9FABzQvnzbc90nHxEMlR+DfagoaaFPDT5/803EmXB5IEuI?=
 =?us-ascii?Q?QGiS7tziiu1JOqAhdfPZtWp82Gx/jAUfAknahcQQ0wEdkysxCRQ5M8fcr2Uo?=
 =?us-ascii?Q?qxMeUk3i1gBlWD6yDQkfL4yZ14q1wtMuTSBHXtlqqKhXT48Rzjx0quvTPgLn?=
 =?us-ascii?Q?DsXUE2iPuc+M1YZ4T6oLVp77VS5m80CXCQ/w/2sJWkqwRvipAeMD7sA4b9ae?=
 =?us-ascii?Q?Teb9rrC1ceULMjZXlez1ZIzhPT/TMPaHnvi5VUYM6G9keAggaKTQOr4gh3Hk?=
 =?us-ascii?Q?J/r32/iUAFxt98FuJRgRRrFoliqI/qNasCcqKqhhFCVwZAP0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d4da827-2225-4846-31e4-08dee66d6bef
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 14:44:37.1708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8R2VzyxaFTtqmD8KcmVbsXNJKEeGm8iW35zD8U9VSvXVnqsiUtgLhF2tKi9la2c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4379
X-Rspamd-Queue-Id: D010C4000E
X-Stat-Signature: rhijbu7ujznufurmm8s7df6h8hh5tc3d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784558683-947610
X-HE-Meta: U2FsdGVkX19INSGrxu05H/vml8wVaJ6t9VhRKq2ML0Loc1bbeEYdyK5jd3VtGwAWXvyA1dc+pAA4VqSTanEEZD5/UufRbSQlXxy2hL1nx4wV7/zslMQ+2YYzJf2vQaFBsRjGZKt0pWXwUGYS2tFeM25jtKENDUiJ4Q4KNbF2TR749d8noQlJnimFt+lgoKE4++FyOfhtJwWrU7hAEz/h7sJ4BgHCaeARqNboJ4YEjih5eLKRoFC1p+W9jeIuHuLRZwSG0Fyvnorex4RaXlqwrsGkq+TPhtX3aHChG+cxI3a48BgFq37mIi2181gTi01Z5y/m0Ah23dLexcB6KjEaQ8F5ersRrYJIRYghcyyL6SonVzPNz7sbCRlfMRuamSgFwt8o68rluQuoQtDMotDq+ENMq3zhDtF1LQwvtvn6TnJBAGwpjYbEQtxwxdD49CEZLaHc+TGlUapwKnVP+s5Jh8t860DprzVugTZ3YMj6k3GKeI9JUPN/lZHy3oyPjI/c6TMZQj6PVNHaWV1TH3beBP2bYsFEAcvCQoWg/1wLRTlno+62eISjuGLowpnxWJJmLF57IxeiGLGpPKD0lAm0XQugq/EPRjaQ4B+thFQrqWkvJ3D/mcrXw+pHMgdsa4hiE5uIWvdfxlIzAMoXKtG7sE+QgiSDUG97bTrD1CIGsOH3zRXZRe7t8ygAu86mrdDnDnzzgBjlCdRackwKA3vGdrWgUa64iQihqQ3xSXZt1Ubx1jrvojjcrKBpNN/FG1A8/9QTJW12UE9I9Z7YsWDHEentxrbVmeXonfg+fCruDBYRCn5QEcRDdAelLtwJdgUxcD34dr7+U4da09TxFSFnv6zRGo68F7Zr6YjgW0L2qjAEWEBOgMvkzXgZ3+asJ3+kO3loa686hMYDipMK6ET/G0HlC4tMnLU8UaKqPGTSfI+ueIbY4xQ6RKc+/RdPXbJKeZj/94GuMqpwo7In1np
 ZlTnHvdm
 T/KqhJ/XLNvDHhhjbJP06hhhQ43iQmbGCgTjCPl4OMDX/3V2/ye7IifkOhFJQaeZvKaVYnYYbo8bamO2nEPhiWoqH41mJ9NKEdxRCuVh3H7ZgwlKkhTBu+0gALnBCHq9U3f9bgh+BsL+43zzPgQWBvcAQGJj17kKd2N/8d3kLGxJFak2I14q2whGg0B+MYUC4c+XyKb3kSsRXRn5hhQ7Q2yoV96rjucdZv5aBjSFVERTc3NrTKe5wYo6Jq80e0Y570XaaNujtE0h9E/7B3wztdft5t65VI87CMqXDRqAMIXdECmBE/Zig0NequHOlyK+FtQ5emcFaAjYv6UxE1LOT9+XEal9RNj6CJkSZ1KSqoz+hKxRlJASgytWbAefGIcNlKSIj6HNS/bLpjzwUgYtPPDOuWAHa0JTA5tSo2BDks+DqHC5gk/UcjUDIAkvw0khFbn32CIqFLnV/vokxV6857u8nDOpumf62Td2Ljew28G2fJ5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Jul 2026, at 7:19, Huang, Ying wrote:

> Shivank Garg <shivankg@amd.com> writes:
>
> [snip]
>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 41b732e78a67..4fed3110ca0a 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -43,6 +43,7 @@
>>  #include <linux/sched/sysctl.h>
>>  #include <linux/memory-tiers.h>
>>  #include <linux/pagewalk.h>
>> +#include <linux/migrate_copy_offload.h>
>>
>>  #include <asm/tlbflush.h>
>>
>> @@ -51,12 +52,6 @@
>>  #include "internal.h"
>>  #include "swap.h"
>>
>> -/* For now, never offload. Wired up in later patch. */
>> -static bool migrate_should_offload(int reason)
>> -{
>> -	return false;
>> -}
>> -
>>  static const struct movable_operations *offline_movable_ops;
>>  static const struct movable_operations *zsmalloc_movable_ops;
>>
>> @@ -2050,7 +2045,7 @@ static int migrate_pages_batch(struct list_head *from,
>>
>>  	/* Batch-copy eligible folios before the move phase */
>>  	if (!list_empty(&unmap_batch))
>> -		migrate_folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
>> +		migrate_offload_batch_copy(&dst_batch, &unmap_batch, nr_batch);
>>
>>  	retry = 1;
>>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>
> Found a difference between v5 and v6 here.  In v5, migrate_pages_batch()
> checks the return value of migrate_offload_batch_copy() and acts
> accordingly. While in v6, it does not.  Why was this changed?
>
> IIUC, FOLIO_CONTENT_COPIED is now used to indicate a copy failure.  Is
> this necessary?  Is it possible that some (but not all) folios fail to
> be copied?

Based on the discussion[1], FOLIO_CONTENT_COPIED is used to indicate both
1. folio is copied via offloading, and 2. MC copy failure. So the code
no longer needs to store the return value of migrate_offload_batch_copy()
and can just check dst->migrate_info & FOLIO_CONTENT_COPIED.

For 32bit, FOLIO_CONTENT_COPIED is always 0, so all folios are always
copied in the serialized path. Hmm, that might be causing double copying,
since migrate_folios_mc_copy() copies batched folios and later
migrate_folios_move() copies them again since
dst->migrate_info & FOLIO_CONTENT_COPIED is always false. Maybe we could
make migrate_folios_mc_copy() return immediately in 32bit, otherwise,
we will need to find somewhere else to store FOLIO_CONTENT_COPIED.

[1] https://lore.kernel.org/all/c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com/

>
> [snip]
>
> ---
> Best Regards,
> Huang, Ying


Best Regards,
Yan, Zi

