Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50BBAD0D163
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0CCB6B0092; Wed,  7 Jan 2026 13:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4026B0093; Wed,  7 Jan 2026 13:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B776B0095; Wed,  7 Jan 2026 13:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 798806B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:54:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3448E1AA02
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:54:29 +0000 (UTC)
X-FDA: 84306068658.17.1F621AD
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010054.outbound.protection.outlook.com [52.101.56.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1D12C8000E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:54:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gwa971Wn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.54 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767812066; a=rsa-sha256;
	cv=pass;
	b=411V/rArdGw7WAydlazz6DlcP1umtJfxp1ST9Tn35Wn+UUipJvTwsXAz5ngyObfapCVa8+
	ocdiJK+AirmBz0y99ANf4VoTbvoXq1uZuOCoExWTg4Os8BSMEF2SZs3DK6DD46MqGwU43/
	+a7tymKmRKABpTywV9ru9Ox8ue6E3cA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gwa971Wn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.54 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767812066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MA0W0uY1QAwMjhhxU+rcD69xM+ngKVCJy3mvsXaUGw=;
	b=boJhCx8VZ5LxJmHvSD9yqn8476o2ztwa1A9qGSv5aOKrfCvrMBS4OuDrcRa+BU7LUqoOGZ
	Ad5wfUeIrrb2v9dBx0Dv77CW/6R6gWLqfJ72F3qPNwA9JfG5jBRXFgY1kKTRM+ruduOFJ9
	U6MsGqMAb38/m4ON0YI0vYyOg3z2008=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=foRajzVdAY+Avrsg+S9aFCjLTl2d9Ma+Q66BK2Whf5roY0kyvtHD643xNcwD7PAcIm5Q/877A9n7OOfDj1tUXCkHhu6Gqr8vChtpLJf/FS8GSV13H1WHKpfxkk1b6AOYMSXS4XJVr2KVE+2RPearpB7nZHBTkl6VbwMqfFns2pR1aK2J5s+sMDt5BedBxdwI5CR6Lj2oz0KxxJR778KN23JAJX7hHmGvlRQtQMssTnLBrR6M2C123IFHJmwrR/JJ+umXFOnBArajc8y7q6zOnBtQq4ZF5T98qtuaEpSz8gR7PNc4kSWLLcWTSW1/L3ni8y1k3xB8a0HY6YYDfd46gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MA0W0uY1QAwMjhhxU+rcD69xM+ngKVCJy3mvsXaUGw=;
 b=KFo+bsIQ77DIv5TJTT7sjBnYqcWI2pYuVQ7dnz1U3PxHWXzCg+oM6hfl2feZRszklPA87ZTJ+HVZJcMcDxyVg59TNS35naSNXsbKl8+cQENgMbhHgp8Jm6dyUiSOubNY7ThxYcaGgYmzClQ7N5tqjAHPS//2AJMRTjWJo2ARzyXMksPSKUC17ULQXcUqmZiSYryi6a+UeuStD6P6BnU5AMfBm7LH3ggpl3SkEIvn7+ei5NJrZ2yIoJZYs9PoS7S8P3ar/PsStUBlYOrAJOu7bgPlZ1IW9L7ipvB67Ygu/skWLl2Ku7raoh8jy3JkOeQbbgCgvosO5pfiIdCphtlpRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MA0W0uY1QAwMjhhxU+rcD69xM+ngKVCJy3mvsXaUGw=;
 b=gwa971WnAwHIvB9Cc/GK6CzCoLPbG++irBIOQd16+zbeNKC+LBWr2el8TdPBFhhTt7ekDef5POT7EO62Cv03HpgG7S14GL14DwvtL5WTIs8XbC3SmUjlDJnqxLuO/nJXijM//aeGGkQhDu48Uq5qbIwWnvShUruGmw+2DFt6agDPeX01PjWVdJi/3i1mjIvq2lH7j8Vhae8W3wy9eEOwaVEK+gb6v3DGlevw46avjSapSeMmnlPqqXi/WJCk4UTG0IAaQ8q5Og6axbDMou7apsu3JE9IiTXl+B83fZnvmjBnpAtmsv25oc+elot3NWiiczjdoAnPTJhgsil0yeGajA==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS2PR12MB9591.namprd12.prod.outlook.com (2603:10b6:8:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 18:54:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 18:54:15 +0000
Date: Wed, 7 Jan 2026 14:54:14 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com, hughd@google.com, skhawaja@google.com,
	chrisl@kernel.org
Subject: Re: [PATCH v8 14/18] mm: memfd_luo: allow preserving memfd
Message-ID: <20260107185414.GG293394@nvidia.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
 <20251125165850.3389713-15-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125165850.3389713-15-pasha.tatashin@soleen.com>
X-ClientProxiedBy: BL1PR13CA0344.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS2PR12MB9591:EE_
X-MS-Office365-Filtering-Correlation-Id: a0be14f9-b8cf-449d-fba4-08de4e1e27a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0qAqjrEq2YuJaKN4HcB0xuQnysd46suVITVM//B0K39qhrjCizlEgnPYIWrV?=
 =?us-ascii?Q?21ivh4OQXFFqkT0vrZS+vmLJ0rruVVMO29QbUrJ5AeX0knXz0vjFXOBRMtQ7?=
 =?us-ascii?Q?bFR2DblMouUMuUUz1B0VrxM+LdzkCi9cF4JNKuzInpDwNgYxGmheuOrhpiuJ?=
 =?us-ascii?Q?9Rv2dXkbCxZGFZSwm2XfWBVUXkhrG1J27kX8V1D44WAgnAhmgSf9FoC97k2Q?=
 =?us-ascii?Q?XLITwxGjvrJeRGAanN0saLnCFRZjea+Fg6vvtLpc77dhPHWUDQ3cQhuPf94k?=
 =?us-ascii?Q?wAV5fGOjkPkQBYN4c5/GJLLAJ5X9aQAuO6LVEhffjzMxZstCyIC/rk7qAfge?=
 =?us-ascii?Q?7jmb0U46fDkKmSDVu2upyX/qdv6IUWKYwmlUM0zvBIl8K/7/22CSyYpHMFhk?=
 =?us-ascii?Q?Z3RoLut6YRyKo3gnOfIBP5MnHkZxfFJfpSlnIrslnvE1gX+44fE8pyiP1ixX?=
 =?us-ascii?Q?lhSwzMJH3utWV1gqZ//9Tpmn0wFiEkB9iNJYnptIrGdpJ+f4lRGkgA1JvYkg?=
 =?us-ascii?Q?kI/itxu3IqBrk8C5XWugInAiEjoXTRdcW7F2qPdGk7NYaMhrhdmZawr8q8KR?=
 =?us-ascii?Q?Cd9wzxoB2qv2xjmRbgjU2+hcnzVFXqkHc4fV2SJcwn1WUvpF/0splv+pDd3z?=
 =?us-ascii?Q?ISHQCrRQAyxriEBWtPzy5/c686A6dhcHa2eWzCx33iubNJDey4dZrWDxaB6d?=
 =?us-ascii?Q?fMsIy6VaNgLy5X9QrOftKd/+U8UUyhx52AFcX7dBuLd415OvrU5vdsOoM6Z4?=
 =?us-ascii?Q?QA9w0boSd/qsoejWsBjbek2lTn10fZ2WqOmInARL3WvlFyRONdJcS4p/jWg0?=
 =?us-ascii?Q?vyykx+Ej05OYapLVUjV0MoLcTcIYsduE5r9pOmjpaOMqWrsVNghs/gMtpWjJ?=
 =?us-ascii?Q?WHHnKgBD8mfvXP0YQsWTEX4sEeFio6v71gu6PcdKyPI5PlTSGktwlpalNtKg?=
 =?us-ascii?Q?3BzWe4mWq/CLTGJPOhDk9W6g/knFIyypvz88+A0pqxXHYzNTvrUC7jhjShDu?=
 =?us-ascii?Q?z2JRyTz4XcAZuUrvOltLrztzd9eEJkmPxLLoFQyDMSQWmtK08OOu/DyH20v8?=
 =?us-ascii?Q?P5db+AtQ7os6XiUNoab+iX25TjXvjGua+5C5878MMs5y6GKCWGiFwKgXOX2u?=
 =?us-ascii?Q?f0ThXu4mXPjiqFnmBqLzN09oCUJoPtnHOOnP/Fd4xpQXKrHneJ0Bp3tBAy8n?=
 =?us-ascii?Q?R8znENYuL10Jc85oOuIKty/xL11AEq+jaipwqfOuLtpYjwr5Y54K0ieTVKFA?=
 =?us-ascii?Q?WHHM/qS3TwvuIzhAUdPmJYx23TW7BXa0fUTh/JR7IRus/56rcgPCYKFDQYcH?=
 =?us-ascii?Q?8vz7xfFkorjX/6/veMhY7ld+S86+WX+7FLiavtU7d6zTTcx3viv9Zi33jWp1?=
 =?us-ascii?Q?Br2WTmdkGh/p/xMx8ZPNPQFmLb7StKS2HyF1Voq/0RDO2BpFQ0c8A7kcvYg9?=
 =?us-ascii?Q?91WCRGiSHTol6ZREqk/VYlDR+8nTG6ts?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?chQPQAtOXF6kxE9ZI1r+3az383CDuD20912scnpFk3fbb46WA2FlJxlnZk0H?=
 =?us-ascii?Q?UXpjj/IsICk6DrNJC4+3VeE3p+MsIjzOkh6W8K8VNmPI+RnYn5mAnKWyvcdl?=
 =?us-ascii?Q?HmcK3h90ETOUW5R9DjxWesrGP+t38j4ekt/ky1QhY+JzE0GlKFO2VF3rXiUD?=
 =?us-ascii?Q?Rzt//FS8J5Aco1l1uuKUm7lOtI/A4ROwe4dF1Yvmb8Cqg1zJdRHY3ng1NUja?=
 =?us-ascii?Q?EaNaeVX+EkcANFWerMfb2+G5HHDuAt3ISfKRR/vs6HhmGmiy5/G8nOi33BkL?=
 =?us-ascii?Q?vElwr1/wF4CQ917K8lWwjhk9x+kTYiQmN0Z8vf5iMrKTA+T1/ku8VuVfVMdo?=
 =?us-ascii?Q?kprhZBfjlhKN0GKZSDjNZ1N9mbAZqV5VADYgyfcOSCuDNGu1MIJmAXzVfbUi?=
 =?us-ascii?Q?KqMRtVi0AgoO7AmXEGF/2oakX8ACZgxOIA6VNE85SECALQgvGENK9G7MjS6i?=
 =?us-ascii?Q?eZ3yQSP9z4Hsl8mz9dLwErdFFqSOD960Sf8GDdPELVSOtf24jvTwnxcsn3mz?=
 =?us-ascii?Q?Z7uY2amnpW10SWJflrlL4bFSZINaDbFSgWYsisVr9T+4Lfto35sKyASiDclO?=
 =?us-ascii?Q?Hn8CvU1u2ap8rv0019sdW41a0ixHfAKDQsxH91ChtmLyHUlsJOrrThqmQG14?=
 =?us-ascii?Q?OTIHCjYNjyQ/SkjCLAt/xzcjTMqIDQro8yZPy8jyGFI1qGfBb5gxtj/NZtEP?=
 =?us-ascii?Q?kc/+4az5KdQaY3SGnmhqzVZSSgvZfm4/e6y+8s38RvPdg3I0R+17JZBDrgOb?=
 =?us-ascii?Q?pIr7pKPtIypJd+TWb3Yit1YJwS8nRJQK8zeVLB8fbsPKZ8EbOkObK585pK/t?=
 =?us-ascii?Q?lF7daEbKWC5hIJ3hvvFtmuuS4CuANs04MzHNAPFURWiaGj5g+gzu+cbJSwhp?=
 =?us-ascii?Q?AFo4biTCM1oDTlx56QsKSt7H57DxHmFXiddX8W6OEwiS0p4/avg6kkHu3trr?=
 =?us-ascii?Q?QE5z3gFvb0s2VRJp96wWUHfGgKtZsycLLTAIBCtc1wHDMKz5pAbyrWVKWDTt?=
 =?us-ascii?Q?u2brxcbsuE3x2GZC6TM5LH/+NcEvHrGFCUIrrep9icIDqoBfnjvRrCIloXiS?=
 =?us-ascii?Q?SkhGLa18zRg1+gdDDdoc8JZaT2KrhVj1OAl3UzyF4R5ByVtVu9xfjWORaIGQ?=
 =?us-ascii?Q?m8qP9zJjO/ofIDSawrXKIqWVRufFiFRWrwkbvwop3S8rDFBdXFOfTFpaMqr5?=
 =?us-ascii?Q?zaILCzrrINJe9rpJxqN7vYOUcewhQbckYHDzzxx8jMXzjkKsE5EnIqCzHWu8?=
 =?us-ascii?Q?I1qIq6F8Cy2dAh8wniI7HPYC04bfxYRLnO5EQu3CudksIGcsgOZ4fv2cn2dA?=
 =?us-ascii?Q?9SeIYjvMiKBlIGDuSvSjx/JQi7juuLlNkj+T5twXKes8ksFnuxUqkqPeCJ6E?=
 =?us-ascii?Q?SvE/4H2WQUoFpkN7sUOq86ObtoN+XEc/YROOK5vVtnk1nYYBuCmx4UpR4YeY?=
 =?us-ascii?Q?CtguVzhTgJftXcOB9wLsgpDRsnYFpUBg+m3bGEKZEsLTV8oc29mJEDJsCcF5?=
 =?us-ascii?Q?8LTiowlVRpM3uRj7nUIBZCBCBja1JtMEIluYuBVLFphuiKcTxkNMfOaYJAKt?=
 =?us-ascii?Q?CFbzbqj3SVd0scDWY1/rfVFETkWtzVv+cCb+Uec/yGk4uieJEniuXwubhULl?=
 =?us-ascii?Q?15Nx4FHV5KxBkORWVV5WlC6T55Dg8VFTAs3gWOfRKPumfZzYjz6hRnxoTpQE?=
 =?us-ascii?Q?vVdgzRIbmSjHTu5G8o46Gv9WOjaIOv95dnQqvGhjIczc1nx4MX8nYGVVM7J8?=
 =?us-ascii?Q?q/lMKMrQ3g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0be14f9-b8cf-449d-fba4-08de4e1e27a0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 18:54:15.6317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzQZIBZ75FJVCpk5+uu6XopuxmPdi1NBGEr4MDv4QWAT+q526gG7qaBqjI1rdQed
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9591
X-Rspamd-Queue-Id: 1D12C8000E
X-Rspam-User: 
X-Stat-Signature: mot6mznjp7bjeheewrzo5atcyub4obak
X-Rspamd-Server: rspam07
X-HE-Tag: 1767812063-817489
X-HE-Meta: U2FsdGVkX18TkV8p0lkj5P1dfs0aCEYvDRlQT3dVOrD1/YTnrwc363NJS9Q19fy8fcFUFlsZDFMZRHp1C+/H15BizCYn/kHGHmmoD3ALM1zTD2gmfEzZhSpWGYwoE+o7c3XqQK+iwi8ZB7VWv1+cMnnZ6+sM0XvBFB6tcAFRK27+DoB5kF64RgXat78oJMbIIAU+ns4SKyAdSCdol6HyXI6wLQ4y/XDP/+25UagjjBobDa8sQgygDMuH5DsWPzFws4+QSarxVGLGQ2rsZzk7BeYQuYU+EhgDEL922yotDkeBZo3zWjJgWVEDsy09tm8+1Qcu+TjLxzUdy5wPTk4aVl/GJmfjaBtU6hv90+zjnIQ6sd8A1xpExct9+luOeyoPtt1uZRyM8GTqqIkfGek2vbbdA706ZhJ6MfgAus9hwruZjdZZKtVyRhVj/vK0OAXUQ5VTIS+VpKssiz61byUJFm85qlSlCYKC4C7QhxI0YGyTWUlhW7FvkfV3dm6srE4CXcF6oU0CnxnPFUywNBxFcDqYX7hNe4+YmuT7Acsj2WxxEtxlfVdpbS0ZDi4jL4uKVJ4UbSzY6u1ROYVkxS1Wkw948O+G/5c+npKyk7c55dXapOp7kWemqbRzZuRx8PtJOxX+osAISUzXWShC/V5vP+f7zUsBsh+4iW1XwlyfgL91ALN6vTAvHXpjfRuS6c/W7aO+vUy82+rE00jCKx+QMMNvBgb9uWzijzz1ViJ/s1Ykr3lhTlbYpDUMfM7PwnPz2W1npmUxPeE3n9WUNUPPG/SjSU8LaHfTUCLnXgcDJZ1BHKUsz7LERiFUPHn/9xHsbkcCiV+pZbLGijR6v8QpHUHuagx79jMD0XhwUwdNkS+HtgcQi7v9YoeA8+xmjSBoJanIqY19q4lrL23iuG7KDbCB6AMud52QRlUQ9McugZFCVtX6NVUSyAiihqcQD1Cxyx3+KLJBhPi5YesFsub
 5Cyq2OQj
 4CG8V36+ULRdQAZuKhHMhsj36M8cI5ogXI2GJk5aXH+/uIi21EHT1PL1enikQlcZBGdtneCRQYGhJFcyc5pGHXRAKbarYhrR0nq/SRT5rfQPebVo9MVw8HmndPztk8v7cvIAD6gRM9Uw81Yysz3iHz5Z6kHlF5FW+WwbtWxU8ewJLPJYdPUFexZtHWsSTRdN2Yx/NBuEkmcQzObWr/dmXYtQUxVDf+n69YNVs1Adw3rlHAbMd7MgM6xqQMO64mhqYfcMQYf8GWfPdGF6laTXphdP0G2sX3JEuoX3+bddSGw4PQw1XE49GRHPyNirkvDisqM8pP7ahppkDFuGxW0WWOA7IJ1VAxrtscifM53Vo1/kI3J/fCOIYOCgMEqVOtiU0JCqiFrAyXh9e3f/05DinZ+DjqL23kNQTQo7ikMkZ/gOFmvbWsNajcsNLrc0Szw+STh6Jnb1JSvHA4lqTj2xNluX0+46f80pxYaqGsb0TRSo2JTUvvFxGAsn8MADRpFQ7YHBZabu1ih6vveikRdN/f3pnVurfoFZ8Gq43B4lYSmTVJIk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 11:58:44AM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> The ability to preserve a memfd allows userspace to use KHO and LUO to
> transfer its memory contents to the next kernel. This is useful in many
> ways. For one, it can be used with IOMMUFD as the backing store for
> IOMMU page tables. Preserving IOMMUFD is essential for performing a
> hypervisor live update with passthrough devices. memfd support provides
> the first building block for making that possible.

I would lead with the use of memfd to back the guest memory pages for
use with KVM :)

Jason

