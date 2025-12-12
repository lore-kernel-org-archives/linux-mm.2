Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B0AED4415A
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A926B0005; Fri, 12 Dec 2025 04:21:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B8C6B0006; Fri, 12 Dec 2025 04:21:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2B96B0007; Fri, 12 Dec 2025 04:21:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2776B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:21:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14038135187
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:21:21 +0000 (UTC)
X-FDA: 84210275562.16.DE70CDB
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	by imf22.hostedemail.com (Postfix) with ESMTP id 36C62C000B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:21:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mtRs9LOC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765531278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOn67N08rjNlIXVgRFxHNf89li0CBtc3XH8ZHat0zR4=;
	b=Ga9W+i9uNyGy0Qfs01OKdpmF9WYq2UtoSc4Y+drcFOic+YwS9Sv/3AhJV3m52BNZTHN8b7
	zXO4BKxw5eKCSs7VaMBEhxNsCnxHSrEs0UM/TYkrr2++UY6yD3uZMeReHGlsqCFv0bnyCv
	oRJ/A/0YLIEkz9KulEH3VPEB0s1vNE4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765531278; a=rsa-sha256;
	cv=pass;
	b=VY3XineeUp5WIY45lNSLQSLfMxJnrpsS1m5QtagNa0SyL8fxA9qtYj+UJzcClzYNx5Z7XG
	nBdI1Eq4YEQbcSLKI2RtIZaLd0dRSoHL7FJL6q39MaYRZ2IlQ5zG5YIplTRCi8G7R8u82Q
	W+/3h7Fj6SYmhqsI2GuYLEWuPd4vYno=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mtRs9LOC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OVJRAfSGQx8bqksIzg/ADGMovIxx4YkRjo/dkr26eluYeVGR3PJTS4NSSDwFrFgzBhX22/pYfUReiiQYQsEN4KGhbXSYEucTKHoD6ZPmITJI89HlTZR/FVJS7ubk5HMzAJnrsPsECHRXLlOgSBnSl0CnVSe11laBrZb1MhWIRpT1XLvbrwA2veHU9r9jweJqXxW8MxC0h0UZrr15m0UZM8SRXlMdLYCRo1Le/+k2Nx9lEzqaFt1TDJjcGP1OvZtAHMUL/j9lRWxSwfC+EMiDoxNh2gbVDDYIJlVQGvfd8CK6wq/kCYumtD98K9+g+PeCCijCQwm7cdkQ6m3EcufuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOn67N08rjNlIXVgRFxHNf89li0CBtc3XH8ZHat0zR4=;
 b=CyUF4Gyj28MgfyBeo7HYyMiBlMwTQebEbfPEk6m9srVyXFtTIJVle3z8S3NZ2vCXtlCu8NTc/Ajmh5qY7fjmRGqiOeXHSUtsakC1j6BGqWSriDThvjtV5s9VIe8Cm2S8j6u43izKnzf50PwRSn4ufqKGS8sqM1WZz6nmO2HTnpFj9VlHZzbZGNbMLGE6P0gmlL9gzegFWlwzArMKk1xi0N25WPXN61xS4vWvHE5Gg/bb0eX1KNOA2bpnXAm2WFRg0GmIxumPOxJR2JjqM/MO/c9kxP2cuKNczj17gASobnWIQpIp99PZkbGxV2ReujaZQHKeLA3iD2u1xZV2DADA/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOn67N08rjNlIXVgRFxHNf89li0CBtc3XH8ZHat0zR4=;
 b=mtRs9LOCcmpCQ7sjxcVbhbytq3v72N3GY4WY68S9v6SAt8YtV2T1Q/1sBhHbbVwu+mZ7G7EWQhSBWyP6H3WRkpeg95jMRAWC8unoe/5I7NJ9wiFCKgDa9IJJSbAJyCTlz3Jl07ZfQxCJmE3XejAnWV/iLAasSRmSZAwqwT7rHfpmKrdtktIIFXFeFzMTo0x00FPZVC+A65YKWC3slBh30fzySDzy66V4M89vsJ0FjS2y58wkfE87UNdbp7t4Ns7dSn4mFANGhvStsJAfncgoWi9nAbTBcfQX84zIFbOW7udxtGuXYuhXbd5YapgoyyUVIN74fsqIofgzmp/L9tsXSg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV2PR12MB5966.namprd12.prod.outlook.com (2603:10b6:408:171::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 09:21:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 09:21:14 +0000
Date: Fri, 12 Dec 2025 05:21:11 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Will Deacon <will@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
Message-ID: <aTveh8c3RngvnIMp@nvidia.com>
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
 <20251128180255.GA836877@nvidia.com>
 <20251212094427.2ec0b31e@fedora>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212094427.2ec0b31e@fedora>
X-ClientProxiedBy: TY4PR01CA0008.jpnprd01.prod.outlook.com
 (2603:1096:405:26e::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV2PR12MB5966:EE_
X-MS-Office365-Filtering-Correlation-Id: 0066b92c-3b3a-4c34-1263-08de395fcc30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KlzRKMyIFBs45UlQ4WVLKXxb0HaAQ7/kwMkd68Bpg5pF+jUNrwMo8a1KwwHH?=
 =?us-ascii?Q?xT4UDqs5sk3waoVwZhVTd9noXO4D435S9e5Ffc9oiI0zwm15Q11SYpCjJaB+?=
 =?us-ascii?Q?9FWjHdo7Np6Abfg/9BWr/1gTBQXXDKU1B0XJNPlpYXCh29BMSPm28jVQrsoK?=
 =?us-ascii?Q?Kb7wSUt5+iOl/Q9cO6uhkZhfJImJ1BlUZ2BsPl7QU6QHg0epncGg8IX9Y9Im?=
 =?us-ascii?Q?25wOyezMuGCKqJ7l5n0V4AGrbX51QC9olxCdbZAlzmHM96EUa8dpvGZtapY8?=
 =?us-ascii?Q?RzQPfSM3MAsSqPHYn75IHJH6GE1n7rMF2/wQnRLWRXVoeCWtH1tovCVFXumc?=
 =?us-ascii?Q?rgIXZ7g9ur9aL8tpo+5CRQo4PJCFUIMZBWWHbBXgxncncXKNMe4Xt8kATb0x?=
 =?us-ascii?Q?jf9fwUfCIYF//3Kup4y1vhusjmTfQRDZn3Ru3PSiTvT3sqEEfD9cDyj0aayd?=
 =?us-ascii?Q?MfvYOHqVZpbbsBNM78nlgIJq8xxmRcik/42hTjc2pNinh8AHEdwh/8LaIxFb?=
 =?us-ascii?Q?AftwkLpuB7P5W3cKvq1Y7Y7vA7bsAFbZ7Q2h7+F1ldiUJ9esxDWpsH12Qcen?=
 =?us-ascii?Q?GHAoWw+AkDF4Tr/RO+LeJANg3mLhUCrXqabuSkPd9D5zlRFzvGUhE4RtBE2z?=
 =?us-ascii?Q?1PnoLs9FRBXrOnH91TANCTLyA0qfifl86YLid8LQUhkHSWhXaITuPCLQjDi0?=
 =?us-ascii?Q?cwdZyvTba5J/iwgVtYvLg2zhl1C60XTkByhKpWQFxE9SsPKanhCEmLoJrihN?=
 =?us-ascii?Q?orvlfxs5kPkpJIO/yoqMcDkH1ROIuWNQjVJNXG6WHS4AJtO5OsS+IrkMdI7g?=
 =?us-ascii?Q?cpWtZXsraN12EEyPHGs1WfK4rDPbhcxl1Tj6kRyjNfhQwQHMeJuQQfs3ZFZr?=
 =?us-ascii?Q?uYZcfSDTg1yt7B4HVh0elzpeNRLSrf2kEQq+QPg77Sge/jnSzxQWmhpYtAnk?=
 =?us-ascii?Q?jDNs/X0f5f+NAkQLgenpxQG4SdoKda6HJlE8/2FoZTnvIo9f2Bcs5Hq/OcAx?=
 =?us-ascii?Q?fEruSKIEmKQZP7MWyDTY04uhy2OZQjCZGOOgP6vM3fbDckauGwBBCccH7Q50?=
 =?us-ascii?Q?182X2ev45hZeOcAgY16QjpqeyOmw6SzbLCyKf7Jg3k7SkF8Cp/4l1gMz5SxF?=
 =?us-ascii?Q?FXKMr3gHpYISdUxAKZSqplQrsZ27/gSlF241BZKjrBBRJwlnizmh8ewIu6ct?=
 =?us-ascii?Q?qvf9qHh6LmdfQDaIsRn31/g0ZoVrW3tJGsrl5oVGI7lqaxXNiQZaAEMf0pOb?=
 =?us-ascii?Q?9MbhO7uOH78VBs7AiyKzaLDD/BUs/8A3DzaFNW9A7kCfhpY0xaqbgd/dFC07?=
 =?us-ascii?Q?0iO+RuxJBwtnc9+SaQsb/odS8f3q8mPRwJCVraGOwm98/HFkn31adcJaT1st?=
 =?us-ascii?Q?dInATuawYu0ahNfektL67taVufBZjmAiz+jQDUA3NyBFssBTxxF5qJHOM7D5?=
 =?us-ascii?Q?IKPAgluJi4CXxx5iYAdriNiPNfUPmYn6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RnXm10IOrqLoE8g9sz9IHW8NSt2OWvICP7ArHoVj3AT3aQtA9bOWiiGp85aq?=
 =?us-ascii?Q?E11tDfHOGOoOE4Om2ZP9wsRM2Nh+0D5qNQWOzwKJGHcOb/sruGpCMvjfQC1C?=
 =?us-ascii?Q?OJ0qe4Dn3T0Je6T096kFZj+Di9XGGFrTiX3TDuYNpsT3cp3lOZEuPETZAzph?=
 =?us-ascii?Q?QsxUEXECuAXCHTYE20MlbkFYN371/L6vmsUQFQ/OHFYTYzugBRItp3hmIAaw?=
 =?us-ascii?Q?CY+5gZ5H68cxzVcn4Y2JjrsXF66Boofem6lv+C4TK/emOVGdxburMLEAL1hC?=
 =?us-ascii?Q?lQKSUB+hbcy2LLWjGw+am2ZRLiHO8AwJarGC+X/x4cU6h3x1CcUDbwP93she?=
 =?us-ascii?Q?WRMJk+n14S385V1zAUu2lKUrFioIIp2zqGJ9n6Ee6s/KWvZNEVsZbx54zYEO?=
 =?us-ascii?Q?3pFaccRBpOws37vqEv2SFKE94NI12Tt2wCt9zo5oOU0Wr24J0B5V9ahT1Grm?=
 =?us-ascii?Q?lGJJHlZpNwMta1q/7hiIqHJiMBPrPRcKXcUNsPsJyPjb9TtSxc4xUuTm0OKJ?=
 =?us-ascii?Q?aoW0GYEV42Fr+6Ku+jQYTfFHQPj52Jj5PoTbiNE6nKu7Uz9uyZkPAcJ71hGS?=
 =?us-ascii?Q?VL2QK7pMQuvMDA8yn78XDLvJdeIekSdsIFLDe9z1Hag3wLdHm74CUf1/19se?=
 =?us-ascii?Q?SMs6Vkq2MDP2ZMe4XRkkWuoIsWF2SwUzB1VjjwofOM4bCD9kM02lIexeWEWC?=
 =?us-ascii?Q?0N/p7v6O4FjVW9ewV0UR4MnB6VCNc+C91kp7IJGIxBkG+d7/nWxFNYs+AcpQ?=
 =?us-ascii?Q?2lROdxKugAOdTCf5zUa4UY1Eg+DgOnjQ89XDWHYyLvgd44wV3G43GFiy8NJU?=
 =?us-ascii?Q?tT/Hv0N2MC3cpuGsMoQe+kkNucNTorRwuic97l3S8QhNNwzQKbs45Kax5qvN?=
 =?us-ascii?Q?4YuG/pe0fpMVNmAgWNCdkCpLEyx7Dcwkk8dhPnTEVRQlTVFyHpBKa4YdEgPo?=
 =?us-ascii?Q?u4v6tVqwSiO3/glL9gUJowioft5KEboQQ+dsqd4LzDcoDQyNrRnjRhOcAzdW?=
 =?us-ascii?Q?45XYZsfOL/7sJHbKModoEpv4F7HYL80jXltPbSvdD9pcp1s/d76KCHKy6BLQ?=
 =?us-ascii?Q?pHHlVeQaUf5CK13Ythk6lxfQ2PvUyvrk8syLoI/SoL3DS4XPwf3w9fu6tbZk?=
 =?us-ascii?Q?gLoLZ4GeShzEExWhvHT5oqU5qLmZHSJk68xWv7K/6lhc62XSVZznjAGAicVT?=
 =?us-ascii?Q?LSELX9wzPjHZE64B8kl8rNU1jY3yvvX+9gSjuABPHMHcLBr1+OZNAQ+IuREu?=
 =?us-ascii?Q?QBQdhbh2PLQ0fDGOCG+jYGOr5AxODYEdOWMyBUTYiFBz88eU2fyu0CGnx1T2?=
 =?us-ascii?Q?ziurHhZTH8ecX3iWxhB2NzQZW6AOOGBJjkFwLEu1YzIun9fQ/ps93+0HCvTh?=
 =?us-ascii?Q?QUaZNkC1hXlcS0rq/KvPoEnCoS5dosH5PlkeiJ0/LTE4/RyktqsGZYlcopqW?=
 =?us-ascii?Q?pyMM1hG6+TaQkWRzmWv58AHZTWr06AyGmIPrT9W9wHy3QAznnbjtFY5ARj/w?=
 =?us-ascii?Q?3/qCQzR3IkIAT5q4h+h9LftgXvcbh12kz8CsGroX9Jhr8xd5BXF64iJbU9RA?=
 =?us-ascii?Q?O8ngV52N8wS5CGYgO9Ky0IgMIFWmzJMyOkOJTzH6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0066b92c-3b3a-4c34-1263-08de395fcc30
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 09:21:14.5055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SrRGZWLARDi53neQkH4JFFwXI+zgk0IWD05YXxWTSjEN12vKVHkqUDCyaf0tb9j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5966
X-Stat-Signature: 3tbbjxe9c115jqdrec1sczmnyrcghyur
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36C62C000B
X-Rspam-User: 
X-HE-Tag: 1765531277-667241
X-HE-Meta: U2FsdGVkX18mqSaIVwUKLHT6Azfgzu5Ypc/TdliWfVdp1/tTd02GaydGqunwusYZBOObrnEKcBicwr5Egd3brjMA8t3O8iOVIWloYIuoBsunF1FedDYFqJ+lZqy+yhpFnzv52h57YzTrTHndjkOGHwstUzd73L3Comu6QAMOvzzraQLvtsHZ+nIzqgaGT9INMVosYdFFPPh8gI3ZwHXIXLiX4HdkENDUNpxbMjndSxqSoU6y8sFj19ZLY2DeXxLYGB4A+fQOmTJhVx9PdaW6mXgcgYIkfqwTo1a7DLzeESCr80Vqgo0ZkonljSi0FBqB0DOIXk7x7d3Szw06wYM8NqTfMfy9cifjOMAWxeVM3BnYYsiENrdvlXvmBhMqsE9JBOGa+x52Hua4BfhZCg7m0GAimPYMD2tn4XJnHgQI8OOYy59QniHaQXaVPlwK1lRZUGUq1e6W3rD5Lh+zK+N+bTibdDW+YrtWoTR9fWm9/KhKqTt+Uo42DdbFLfMl1VpVt8y2nKhifrBgfBVx3+ssdWpyttjbUDi/Tk0sIllAu/v9hxbcgmBmpj5UBqisBmR7hfIavk+HcT1X7gNAbVpncp5DTio7YgZX95X/Gn0ThxUG5N2LuN7cy9yXqxiGvmwIjzptyLddox+u5yWa0Zqo25l54wc5Q4DfjEBJbFqcstAoc1rhGGPqdEbt76vNVWVydXA5jkgDuFb87doZfZMJazlhclMmk5TV72qnafWxqGZw/5AibZ81bb43doXxxmhOyeHiJTQ2FwwuOxDqqI6bFljK3jVC9bmLKP2dWjDVp8IPFrPo/lZnnEm6/D2u/KlvzHp+/7seroraI0jaJDNTYUNUD/zy+k0zoenzfOvgu8c0HslcAbxKu9V1kv4JKEsc8+/y2BePpYrIQduRK0LC4anldsuGcklNLHUd6KIPn/74kxxXfZmea9Z08Uv54w2ELd4JsORUlZpFwOCpWIK
 1Jp9rz4y
 VTFntH8Uz+B+Qdp/s6PAXW5c+4w6+wd+qy0KizaJf7hvz9L4zw9OZxXJDxtbOeZkqn2WlGUC+A+Rq6n37CGwt108dwW3m7yt/4RWXxhsHpBPJ0U5uR6MjvSv9AEA08WqnjDbcvNaYLan6N7s1AQZaZuwsxEckrftmOS1ipbRBzN8bWys2fU/AlFuLbzQXSy5PxzYGVoWFxFhSRQFRRLL2VKxnh4YD9DyWnxCrFPCirc/nNo6jtyO4Rjr3LINcg4b7dIroSsD1bTUP+D6hNuis3nrGCxuaJzihsAJ4QY8CX9DTesbm8aAk7Z49tGBz6spRNipMnPJaIVW56e+/gZMAS88ZBAzRbQADCw9ZCxUw4AMvFCIUjRUSWmpJvKPkSEwuBqpWDB1pbJ/y5zQmoL5NH5nvt8Qij2X4XmEchqWQghK2rR5q4cSblNr5XdHxLLhmJhM0b0zdfyCYfFzmrjXeQwC9UgQW7PShUHe1nWFZQs4lyv+f5LIcCMPZ2DyWLAjWEQODy4ISTBFIreRTBXMxk2vZYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 09:44:27AM +0100, Boris Brezillon wrote:

> > > +// These bindings are currently designed for use by GPU drivers, which use this page table together
> > > +// with GPUVM. When using GPUVM, a single mapping operation may be translated into many operations  
> > 
> > Now that we have the generic pt stuff I wonder if GPUVM should be
> > providing its own version of the page table implementation that
> > matches its semantics better.
> 
> Not too sure what you mean here. Are you saying that we should fork
> io-pgtable-arm.c (or rather a subset of it), and have it all
> implemented in panthor?

Not quite, probably next yearish some of iommu is going to stop using
io-pgtable-arm.c, and switch to the new stuff.

The new stuff has alot less duplication if you want to make your own
special stuff like this:

> against it. Now, I see good reasons to do that, like the fact we
> would be able to add features like batched repeat mapping updates
> (mapping the same page over a wide virtual range without having to
> duplicate the intermediate page table levels that are exactly the
> same), 

That's certainly a unique requirement and it could be implemented with
a gpusvm specific set of operations.

> or the ability to extend the mapping arguments with
> shareability/coherency info (that we can do by adding IOMMU_xx flags
> too). But there's also downsides to it, like the fact we wouldn't
> benefit from bugfixes materializing in io-pgtable-arm.c, if any.

The new stuff is significantly modular already so this risk is a lot
lower, and we could further modularize things that are actually
duplicated.

But doing something like repeating page table levels will require some
fairly different unmaping logic already...

You also had the special allocator asks (and presumably optimizations
are possible there too) and probably optimizations like taking page
lists directly out of GPU structures instead of multiple calls and so
on.

When 6.19 comes out go look in drivers/iommo/generic_pt and read the
documentation pages that will generate under the kernel docs site.

Then you can think about what is ideal for GPU and consider what the
work would be like. My uneducated feeling is with gpuvm trying to be
common code it could also have gpuvm provide shared common code that
directly builds page tables in CPU memory using the above framework.

> > IOW it doesn't seem right that common code would be making decisions
> > like this, the nature and requirements of the flushing are entirely up
> > to the driver binding to HW.
> 
> We're not saying this will work for everyone, but rather, this is a
> default implementation that does nothing, and if you need to do
> something, override it with your own. I guess if that's really
> problematic, we can force the user to provide one and keep the NOP
> implementation on Tyr's side.

In my view there is no possible correct way to use this page table
code with HW unless you also provide flushing ops. I can't remark what
is more rusty to do but having a default full of NOPS should at least
come with a comment explaining that the driver still need to provide
something.

Jason

