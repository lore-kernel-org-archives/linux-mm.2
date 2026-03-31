Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A502B10F92E0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081F06B0095; Tue, 31 Mar 2026 12:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0590C6B0096; Tue, 31 Mar 2026 12:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A996B0098; Tue, 31 Mar 2026 12:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D632C6B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:10:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92BA45628B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:06 +0000 (UTC)
X-FDA: 84606844812.05.CDEE5DF
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010024.outbound.protection.outlook.com [52.101.85.24])
	by imf06.hostedemail.com (Postfix) with ESMTP id 16A3118000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dmlog0KA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774973403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNCAErXeMTh/0cRS5giuyfZ5PEwH8ltJJ+T+T3YgIwA=;
	b=km/5hd88Fz9buWWACedX2otpZXp9weQIx+fr8Rwj/jkFaXtT83C6X1P+FelbQ1lNrmYAkc
	ANARIaRqQ/TJG3Kj5TVDWnSNC4PfoC8KPBhQEAAW7nPW9++mztGU61qribapzsMIIqp6TI
	H4iWW9fNgLhLoWFS6k0U+02LoKujFno=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774973403; a=rsa-sha256;
	cv=pass;
	b=8m6NcGypEFvWbPAIFpnsG22iABwBOiXPO0x6ppx+Fv2+nmA4tqMcQunMyCQdg+zuMK/dRD
	s4AJv4r/cmI6bBUcHr+VUnNBgecEZh9moQQERnRJKPgDv4QrW0+MM9TNa/lYghrx0RGrSd
	vykId1Z95F3xlOv1zAJiWBs6cP2vYsc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dmlog0KA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UeMWIm8I/vVxMPfNOH61cO3KmWeu/ph67F2R8vg+9zOhYgte4qn8h7qEef76iC4p022MNddmZtIm35La1Jn5daka88Q/nC9C/XpCt8Yu4vfDhhci6GugMQ9t0ZqFQ78S58QdLUfczOpfqmbUzBDkt8pPQGOY948qa9TurdYgqpmK5vQO18ktq9cKS1CXi4gTxrFI1CNvVNAmndUY+bwlpEni3dSrHIqeXXP2v1JgpJ/0xA16AjnLixhKGZav86caEub7EhLFdLkuGdGfRdNDi5Oct54OlhcqYZJbd/4rbzGP2bpfncooEognlFzve+pmqx10Ah+0HNA9ePhFB12X2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNCAErXeMTh/0cRS5giuyfZ5PEwH8ltJJ+T+T3YgIwA=;
 b=adRGuGcVoUUzYyimntl6qCNAVyasg0qvA6F0W+LRAECDnBWrsdKW60rGnBqnw7649Ybflh7vNGMyuqCRFmFS2GqK27qx/YI8xj5+ITftIV+Y1S3LSigF/T20m8kr+jWfF4hiYlpyj4lG0CtDiEYiJoFLwtPZ5E2EGtP7ZyVAsv2w2qym1+ifTSpLpWZn4nLz3aSTVTsIPVdbY3fJXvmTxsL4S31bvVuvRWRRt1d5j1wOHjOXF4c11R3d6sqPc/mMei6+XXdyNdcXVQ/EMc+UfkHmTtMlwepvEZzcgossQZqiz6t1e7pMnHzG2amhsgaWfb9F90PcsnMQr9YIf/kfaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNCAErXeMTh/0cRS5giuyfZ5PEwH8ltJJ+T+T3YgIwA=;
 b=Dmlog0KAhQ8VRRhfuYZYJCIMFOcbegXqlDWlFX9z1yecmIzpw17nRM3NzJERRc+k+KMguBJ7RunaKVDi3nDRc0CnaKaSE7At8hmVf2eFocmRXrBJzEzYkCC+7h25QUK46x0Q/GGwpdGC3LVt9bAK/vC07Mvjwqv4m1wcAZdrK2PAQZE1AV8HhnefejTkgtRUNt1Qx7CIK0oJIgKCldNa9xhiYb0iwH7MwFqEydVGZ3Nim3rCkgjHXiblxqAHW0C/3i0wpg6a3wI8MMmI2SGBj419KYSjIwzFulaopu/MNu5G7QU6b2SSrUt/g4c7axmaNMHtMgCnMuMX5H5EYFXpEg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9666.namprd12.prod.outlook.com (2603:10b6:408:296::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 16:09:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 16:09:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v5 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Tue, 31 Mar 2026 12:09:50 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <808663DC-2C66-460A-81D0-2943B9B7CF69@nvidia.com>
In-Reply-To: <20260331152208.975266-2-usama.anjum@arm.com>
References: <20260331152208.975266-1-usama.anjum@arm.com>
 <20260331152208.975266-2-usama.anjum@arm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9666:EE_
X-MS-Office365-Filtering-Correlation-Id: 248844e0-3caa-498b-3cae-08de8f3ff207
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	b8fGdONG01bELWrJ/P2LwaPQcjleTPqvSrWnyqRslQlf8vyqCy5lNFljuwhE7E2oj3GuXJ9VSlC0Ol7RQBBL40OsS/1QWU9qCLS3c/hZp8tTRNtjSxdffSMnE73DUTnCWu8wMIdrNlrhAlF1hH8jMFi9T3REqerrzMnBRIv/S9DePX3lfC1dLo6X2cC4H0xJeJjPrJFveP4Sd/r48m2fV8l8i5A+6x59kVzWhEkga2vOW8xp3bjkhdO44k1exHq0Sq/ExRjVFTqtahlU2NPQTC1O7eHXABNTcyYjasmbe6orvhkgnf0fZj+r9ShJHcjWFpaTYQgoRhUi/kExhh/cnBWgAUnE/sD1ABYD6wQInRg/wMmHCQH9i26zaRCe7tCkHqJ/JV4/8Cdt0mMtEpMcL3RuTODlM0RIs0v2mRdiJLpTu2y6mPZMrbElFTiGtQsR3ZEi1XsPba0w4cXZhu6Ds9vByTOvmyyn2vDnImEfY/GUg2qR0UZTxkxaxEGPTMBApJ2hinaGId19cDjPfZx6sYPuzpy9mVrVOPqgsaqtiPhkzxXUv4C5c61aGu5xua7COhP7dfRyi9uuE5EiO9jaIl0yp/r7XUQZo6anJ1r+EBsZsznMRmqCYEcvo/sGJve3rJVMRpGYlpc/oSHhXOIJMAri5llaae7mJHGRwJCf56Pga5ollsIgnXAxzYeORucm+B81z35FwYjGrvjhEUCAwRLzRxF2A/R5kSLTK80caag=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BoN2AAYl0vibfBjOAEw54VPvb2K+3N2kmj9KzzXqf+Pc2QBmzzkCQi3FAY4b?=
 =?us-ascii?Q?X7wiE4Y3xkUDBrqBjWLM0FY9V2RHNArxY1v7MhVHtri2zWCAA8FTWcla2/ov?=
 =?us-ascii?Q?mG/J2x4hSpObUQyqIips20XzeN++n8MhzEJLUXLfWz9lmksybaHcGGRtjdfe?=
 =?us-ascii?Q?+iki5qHck8Vq1FelMcs46BohAHnlUjXfgfR7fhygn7Rq49JboncxwT1o3HbE?=
 =?us-ascii?Q?Yn/MKWXb7otFQJnxSY02vzrcib/LnoY/wy+hi7wH/S0fMikVcrL0FY5IIAcb?=
 =?us-ascii?Q?HdApcneX/eAboM/6N3KlpOAp3q5N2DyRb45Og65PXpZrtYGbciNDPU/qWPeU?=
 =?us-ascii?Q?cbh0P3hdy8QbytbaSpwtxZ4VsEH+lObymmnFIldRTlW+UZEGU+WtdMMUi+Av?=
 =?us-ascii?Q?a94eb1VYYkzreihFiM5eN8capMQLgs9OuyipwvlnAihKMw0mMPitq/VBK2es?=
 =?us-ascii?Q?8AsjUDns3nLJpQYvD++dIDzU/g3NWhVwdk+1XI91TzY6LrH6j5S3vmli4LSE?=
 =?us-ascii?Q?yjhAWh4I5i9FAweri+trCmZ15MXNvKQg4EROKRSgxaHfkUSQgs07jI/5R9Cv?=
 =?us-ascii?Q?rQL/Jp3zkswvX1j8LiwrEqu/OK9JaV4Hvhc9VUJJU5q5kfyMnW94fT+Fh0Fb?=
 =?us-ascii?Q?gdw7sA1IDUErXzOqNZWBueIKmeXfE7kVjnUMXQiq6UZBLxBD1IcOX9MHnePW?=
 =?us-ascii?Q?LyFGrjezesXCxuxiUdNnYxiPEDxiFnFO3BG0ZfIxSXB49Hr6fFNgjE4EvdkS?=
 =?us-ascii?Q?GcFI1NLKbn0gbmL5SVZSeIweVgxHgB1wm4mPINoJM2eTp5QZ39vLln4kEEf8?=
 =?us-ascii?Q?FdUlSHxNoScaj6gg71pSwV9mtyHsztO2zA01hpt3NLPawHXFjOKSLTdwXlmH?=
 =?us-ascii?Q?vlAjfEGCgT3iwN5798+3NP28/dj05VU+Qj+s2bkKrLGQr0SL/lwWtAWloAuF?=
 =?us-ascii?Q?xjMtNm4rtxgFLqZTL5MJEg9w0eAHXZNawNzfwk8aQnuU7pvhW0y0K/V8Hnt5?=
 =?us-ascii?Q?8LKOSCUHW7jQuo8/eRZBhREWOX+RKDXyKF1L+TiIKwLMIlE1iQ2YSHVVCjG6?=
 =?us-ascii?Q?exe/S7Pv2NoOm8IxXJHpzNWKVnXSy4IKiMbbFbJWcANU6SknkJ8lQUxy6dP4?=
 =?us-ascii?Q?o+JmXVLrcnbpSQ2bsmDZoJJI8i2UMNWXJZ6yhqjvLfOX37h3L1FEeQiZM6FE?=
 =?us-ascii?Q?pkTgXRogTPRazoJrjzPYVQieh6pAqcQ1JhAeja/jMIP9Wu3rI3KzfMzcvhw6?=
 =?us-ascii?Q?p3CZWlZZJTo0HRViHxPGtmyH8tlVt3xQ/1ipUTx7wq0PVuXD0qKnhvJDl/Zy?=
 =?us-ascii?Q?20boC7zrDjYhXYIr/Sj9F162BCx0OLX9+/GXKZgnYpboNxse1fwwfvcOlGj1?=
 =?us-ascii?Q?+/EhVKR5L20+w/5UhSYmggKTATpQbE/EKUCpun9yBw6jzNYU0nV9wZA2E8Ly?=
 =?us-ascii?Q?VsOEbdcQbZcxktUfjsFVDBFGCHaMdlzTYnE+FOMT5vZEdxmC+gnxGKrHp2Fr?=
 =?us-ascii?Q?uRY/0TKYMzUPTES6tnJGVFdI+DQn/wAbgJlLjvTheKZGS3bEd7ujUc5P1oEt?=
 =?us-ascii?Q?ylBc41ufH9/VBk8e3fsW8Z7w6sPKYiT7t/Ao/69S8W+30YTtTjMHe+QB3Y2p?=
 =?us-ascii?Q?nA/b+2he69vZacMiEN+t5wSRDzJoFKVzjkxh7vNzKkFkUwzoBOaxIL5PbarL?=
 =?us-ascii?Q?UM1iMagQMouAfqxbgULmkT5Zy5ekIFddi+i6rsbf85h62+o/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248844e0-3caa-498b-3cae-08de8f3ff207
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 16:09:54.0932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIiAptD6W/k4gVclw4lkdPK6grP1wVyHl4QRjSOaYo620DGdZ8cNNzYTfNLd6IM1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9666
X-Rspamd-Queue-Id: 16A3118000D
X-Stat-Signature: topw6derrakup6ahq1aachg7753j514g
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774973402-117668
X-HE-Meta: U2FsdGVkX1/CfqfLAuOV4rDy9VKdVeuiPT9o3DmfEVLIymMzaZrHKHu/SK52hrJkB+PPajCwqZHCGv2nZhaX0qvCuN4ivg730r2WWDENWAofTiCee7pQKNpgIGnUS/gHoUAbP/s3N9njWruZYdOWwz6uLN2fN1tiHi3LOH9oWztr1kWDbJkpwoPYGmStfI/oexQ0tZTmakkIGnMYwu+EEwLmVfUezdz6+L4OgnUnLykSGb2uXP7yDb1IOGzU7ScuAIflCEm5rA7d2IdtD6dTSmLYyUaRIUgjGaTwXF/RS1G3ALc+dfTOHDmyNfXkruP8OPB8VwmiJ0OaCYDkf4vs9jWLN1I6VidPXa+ibO/elUDzhlXHU973OyyROVztj4MYJtU+Bj7o5F3rOj9IIagwY9CKrc7qrmljsNaq8/5g2cgGDyz4NzSdxZHmei76bkVtHtAXum2h7I4+UDn2egQDfjWS8Uc1oad6GXHKy3PnsG7D5IeHe1W8ZexTeEmM7X7j6FpDZh+pgDERPzBSAnqFpb2l5aVL6e3mPSgPLzkO9WT+eUElU9kOxyfpEizhJkyphEsxJGldiO3ZVD4859E4EwWcFTu3+tGSdhBgz1lEPDqw/PRG+C/1GlOKZSlA2akdpq+bDuF86w3De5Ko5Lw5/qBcBTaDZ7iUr+6hSif2JkwDVGkRrEGgrXyxjh+BjAfBWJL2RbvCCa91esGqvyw+Y5PFQX3FTzuL6xsBI456E5u48i6y8zmZTY1qc6o8VpTyTRQPdPeAJFH3oyVEWizgUY4XjYc12i5IuR+tt3N+QhEkYM62YgETztzKUvOfhAn7+qjUUq84cBwi8DqOSgmmpfLT1iEVP27d5/2G6K8P8cyEMK4TPBdgpOb9j30/8crjs6Aw442W9ZaNctpstHrbdveWtJ2TaTkutudOdnkLRt0YO3BOPsY79OI33DIzbYxVxn3mvFqdhMvB5rBhmJU
 2WfPIHmi
 brJ6C88ejntV3sm4dRvPP6c6+vpxDJS4RkpsTnrfc4ZxrRgG2WIKZN5Eu/dc+InfRHWSBpmfbQZzr/jrqkboQjWhduuRlRnsZ2uzsYXv/XZrZ++ic31xQnHZX18DV9M1FXbS9Rt58eUfqu44w7UvXdNpcUbSUCfC3X1fCGgt4Pvn6YgH0Uxl1yqfa0WrdPxVbq2Yvbdr+tI8jtBJE2CrsN0jh6ICcOYoUJIR2ZBi9qgfYHJiDaEktf3UQVSjitSR9E4H/lLKcNjto9/0WQ0r5/e9A5so4j1Oru3yvNjwuchUBzfcAqqh+5h1BUmWhoOu9WTirVi45nlIz0tnOskmEg/SRGnPm4MLA3mXZo2uo9i2FdSI2xAipY4BiiyntMhCq3AcvwOHcY3MBbXFd7owr1ZfsUoRzpcafPmJu9f1KQXxVqrAnADrZvYq9qNvP3v+0tDYiRfy46eaqz3uFeOekK8ygzLWgfOxwuh/7Y6qBJz4/lq78MHkdySQZUkJoKRKexVXT816Hs+VsAiQF1fok7MdROfvVKqG5mUaXFFHLBbT88ATZQ6XdVvVM35tWipOjucy7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Mar 2026, at 11:21, Muhammad Usama Anjum wrote:

> From: Ryan Roberts <ryan.roberts@arm.com>
>
> Decompose the range of order-0 pages to be freed into the set of larges=
t
> possible power-of-2 size and aligned chunks and free them to the pcp or=

> buddy. This improves on the previous approach which freed each order-0
> page individually in a loop. Testing shows performance to be improved b=
y
> more than 10x in some cases.
>
> Since each page is order-0, we must decrement each page's reference
> count individually and only consider the page for freeing as part of a
> high order chunk if the reference count goes to zero. Additionally
> free_pages_prepare() must be called for each individual order-0 page
> too, so that the struct page state and global accounting state can be
> appropriately managed. But once this is done, the resulting high order
> chunks can be freed as a unit to the pcp or buddy.
>
> This significantly speeds up the free operation but also has the side
> benefit that high order blocks are added to the pcp instead of each pag=
e
> ending up on the pcp order-0 list; memory remains more readily availabl=
e
> in high orders.
>
> vmalloc will shortly become a user of this new optimized
> free_contig_range() since it aggressively allocates high order
> non-compound pages, but then calls split_page() to end up with
> contiguous order-0 pages. These can now be freed much more efficiently.=

>
> The execution time of the following function was measured in a server
> class arm64 machine:
>
> static int page_alloc_high_order_test(void)
> {
> 	unsigned int order =3D HPAGE_PMD_ORDER;
> 	struct page *page;
> 	int i;
>
> 	for (i =3D 0; i < 100000; i++) {
> 		page =3D alloc_pages(GFP_KERNEL, order);
> 		if (!page)
> 			return -1;
> 		split_page(page, order);
> 		free_contig_range(page_to_pfn(page), 1UL << order);
> 	}
>
> 	return 0;
> }
>
> Execution time before: 4097358 usec
> Execution time after:   729831 usec
>
> Perf trace before:
>
>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthre=
ad
>             |
>             ---kthread
>                0xffffb33c12a26af8
>                |
>                |--98.13%--0xffffb33c12a26060
>                |          |
>                |          |--97.37%--free_contig_range
>                |          |          |
>                |          |          |--94.93%--___free_pages
>                |          |          |          |
>                |          |          |          |--55.42%--__free_froze=
n_pages
>                |          |          |          |          |
>                |          |          |          |           --43.20%--f=
ree_frozen_page_commit
>                |          |          |          |                     |=

>                |          |          |          |                      =
--35.37%--_raw_spin_unlock_irqrestore
>                |          |          |          |
>                |          |          |          |--11.53%--_raw_spin_tr=
ylock
>                |          |          |          |
>                |          |          |          |--8.19%--__preempt_cou=
nt_dec_and_test
>                |          |          |          |
>                |          |          |          |--5.64%--_raw_spin_unl=
ock
>                |          |          |          |
>                |          |          |          |--2.37%--__get_pfnbloc=
k_flags_mask.isra.0
>                |          |          |          |
>                |          |          |           --1.07%--free_frozen_p=
age_commit
>                |          |          |
>                |          |           --1.54%--__free_frozen_pages
>                |          |
>                |           --0.77%--___free_pages
>                |
>                 --0.98%--0xffffb33c12a26078
>                           alloc_pages_noprof
>
> Perf trace after:
>
>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __=
free_contig_range
>             |
>             |--5.52%--__free_contig_range
>             |          |
>             |          |--5.00%--free_prepared_contig_range
>             |          |          |
>             |          |          |--1.43%--__free_frozen_pages
>             |          |          |          |
>             |          |          |           --0.51%--free_frozen_page=
_commit
>             |          |          |
>             |          |          |--1.08%--_raw_spin_trylock
>             |          |          |
>             |          |           --0.89%--_raw_spin_unlock
>             |          |
>             |           --0.52%--free_pages_prepare
>             |
>              --2.90%--ret_from_fork
>                        kthread
>                        0xffffae1c12abeaf8
>                        0xffffae1c12abe7a0
>                        |
>                         --2.69%--vfree
>                                   __free_contig_range
>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v4:
> - Move can_free initialization inside the loop
> - Make __free_pages_prepare() static on reviewer's request
> - Remove export of __free_contig_range
> - Use pfn_to_page() for each pfn instead of page++
>
> Changes since v3:
> - Move __free_contig_range() to more generic __free_contig_range_common=
()
>   which will used to free frozen pages as well
> - Simplify the loop in __free_contig_range_common()
> - Rewrite the comment
>
> Changes since v2:
> - Handle different possible section boundries in __free_contig_range()
> - Drop the TODO
> - Remove return value from __free_contig_range()
> - Remove non-functional change from __free_pages_ok()
>
> Changes since v1:
> - Rebase on mm-new
> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>   fpi_flags are already being passed.
> - Add todo (Zi Yan)
> - Rerun benchmarks
> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
> - Rework order calculation in free_prepared_contig_range() and use
>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>   be up to internal __free_frozen_pages() how it frees them
> ---
>  include/linux/gfp.h |   2 +
>  mm/page_alloc.c     | 110 ++++++++++++++++++++++++++++++++++++++++++--=

>  2 files changed, 108 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index f82d74a77cad8..7c1f9da7c8e56 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, un=
signed long nr_pages);
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>  #endif
>
> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages);
> +
>  DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
>
>  #endif /* __LINUX_GFP_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 75ee81445640b..6e8c79ea62f1c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>  /* Free the page without taking locks. Rely on trylock only. */
>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>
> +/* free_pages_prepare() has already been called for page(s) being free=
d. */
> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
> +
>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fiel=
ds */
>  static DEFINE_MUTEX(pcp_batch_high_lock);
>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
> @@ -1301,8 +1304,8 @@ static inline void pgalloc_tag_sub_pages(struct a=
lloc_tag *tag, unsigned int nr)
>
>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>
> -__always_inline bool __free_pages_prepare(struct page *page,
> -					  unsigned int order, fpi_t fpi_flags)
> +static __always_inline bool __free_pages_prepare(struct page *page,
> +		unsigned int order, fpi_t fpi_flags)
>  {
>  	int bad =3D 0;
>  	bool skip_kasan_poison =3D should_skip_kasan_poison(page);
> @@ -1310,6 +1313,9 @@ __always_inline bool __free_pages_prepare(struct =
page *page,
>  	bool compound =3D PageCompound(page);
>  	struct folio *folio =3D page_folio(page);
>
> +	if (fpi_flags & FPI_PREPARED)
> +		return true;
> +
>  	VM_BUG_ON_PAGE(PageTail(page), page);
>
>  	trace_mm_page_free(page, order);
> @@ -6784,6 +6790,103 @@ void __init page_alloc_sysctl_init(void)
>  	register_sysctl_init("vm", page_alloc_sysctl_table);
>  }
>
> +static void free_prepared_contig_range(struct page *page,
> +		unsigned long nr_pages)
> +{
> +	while (nr_pages) {
> +		unsigned long pfn =3D page_to_pfn(page);

pfn does not change after this assignment. That is why David suggested
prefixing a const. You can send a fixup to this patch to change this
if there is no substantial change needed for this series.

> +		unsigned int order;
> +
> +		/* We are limited by the largest buddy order. */
> +		order =3D pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
> +		/* Don't exceed the number of pages to free. */
> +		order =3D min_t(unsigned int, order, ilog2(nr_pages));
> +		order =3D min_t(unsigned int, order, MAX_PAGE_ORDER);
> +
> +		/*
> +		 * Free the chunk as a single block. Our caller has already
> +		 * called free_pages_prepare() for each order-0 page.
> +		 */
> +		__free_frozen_pages(page, order, FPI_PREPARED);
> +
> +		page +=3D 1UL << order;
> +		nr_pages -=3D 1UL << order;
> +	}
> +}
> +
> +static void __free_contig_range_common(unsigned long pfn, unsigned lon=
g nr_pages,
> +		bool is_frozen)
> +{
> +	struct page *page, *start =3D NULL;
> +	unsigned long nr_start =3D 0;
> +	unsigned long start_sec;
> +	unsigned long i;
> +
> +	for (i =3D 0; i < nr_pages; i++) {
> +		bool can_free =3D true;
> +
> +		/*
> +		 * Contiguous PFNs might not have contiguous "struct pages"
> +		 * in some kernel configs: page++ across a section boundary
> +		 * is undefined. Use pfn_to_page() for each PFN.
> +		 */
> +		page =3D pfn_to_page(pfn + i);

page is local to this loop. You probably can move its declaration here.
But feel free to ignore this suggestion.

I was about to suggest make it const, but put_page_test_zero()
and free_pages_prepare() do not accept const struct page yet.

> +
> +		VM_WARN_ON_ONCE(PageHead(page));
> +		VM_WARN_ON_ONCE(PageTail(page));
> +
> +		if (!is_frozen)
> +			can_free =3D put_page_testzero(page);
> +
> +		if (can_free)
> +			can_free =3D free_pages_prepare(page, 0);
> +
> +		if (!can_free) {
> +			if (start) {
> +				free_prepared_contig_range(start, i - nr_start);
> +				start =3D NULL;
> +			}
> +			continue;
> +		}
> +
> +		if (start && memdesc_section(page->flags) !=3D start_sec) {
> +			free_prepared_contig_range(start, i - nr_start);
> +			start =3D page;
> +			nr_start =3D i;
> +			start_sec =3D memdesc_section(page->flags);
> +		} else if (!start) {
> +			start =3D page;
> +			nr_start =3D i;
> +			start_sec =3D memdesc_section(page->flags);
> +		}
> +	}
> +
> +	if (start)
> +		free_prepared_contig_range(start, nr_pages - nr_start);
> +}
> +

Otherwise, LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

