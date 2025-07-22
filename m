Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE49DC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 00:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CE46B0096; Mon, 21 Jul 2025 20:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCC86B0098; Mon, 21 Jul 2025 20:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1850C6B009A; Mon, 21 Jul 2025 20:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04CFF6B0096
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:49:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85962B6FFB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:49:25 +0000 (UTC)
X-FDA: 83690067090.13.B5C7621
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	by imf01.hostedemail.com (Postfix) with ESMTP id A96BF40002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:49:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Rnvxcgk8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 40.107.244.87 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753145362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tu18ogzMJNTZ9pdtntO2WV9nNs9m2zsqI51OiBulFWU=;
	b=OBRAdqjRMIFOkUji0euGyeVJjUroGVpirwBFE2Q0m6UY5B8UE/d8lr0qGDQvMVIME/cHOc
	aBlGOQZBsB/ASM+l43P7jchTW/f0X3rUihNvS/mdblR50QnVugFnV7hDAURQnCdSmtYwoH
	ZtOSr8b2+ggXyBaZlj0gQgRv9qtSyVY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753145362; a=rsa-sha256;
	cv=pass;
	b=PjbsWjfJvIG1/7Z+SH8D6l8wWG88zfAy42dLn55wGhDAoBfjcppLNRQc3rqso9Yv0+mDln
	fKTg9OIzndgX83+mCmTqlKpx1fbvonxRaPjipe5troTeejMQ9If9viZh70EdjOj80vpva7
	H1xLd6Ip+vgezufP19cDLXW+gcC7LZ8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Rnvxcgk8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 40.107.244.87 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LueGKxqZ+kRBRyc/+b1xWm30DgfMc+tq8YJvEo4ihRftQGJzOomSJUKN5dUZNNv9abmdYOij991VKMXDLFAtz3Z853Xo1vn8hWyEFOZOflpbyZbO91l6ffb3yShnvmuQp8S2Aj4ocZPoo59SVi91G/gHz0DjVC+7qqGO34zC7SdAPUbyjwtEZ/9YNQLoo+ykbGsQyfK8QHZpDYJxgxFpgsOuuu8aOVEH+vVsNvuR0rf68aR+tyneduEYIIkPY96L8L05/bEBxds5a/7TSjXrol5tFwGNV2C9q7XKmLluMcL2/5Tls0Jcc3RPLbLccCwKneCe88rBzkqNq7l8RO4h2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tu18ogzMJNTZ9pdtntO2WV9nNs9m2zsqI51OiBulFWU=;
 b=rlOrG/C5LUV6IfHQO8ak+ipuFDtWExMEwbTwz8uV4wxspzeNGsj4E2cfP5Lr6Ysq2abJS2C9Ahjaf0WVNyqaaRK5A0zgHDaNMZAnE2yXBVxT1T7n4sm6mGoXAtkJfVFpeKalCgfEI5g2jvx6Pqn/tcFLFlEE3Fotk0aq+UH6Pkex+BU6M7RuD1t4uY2ubm7WcM18H4MJXk6E1Egxo9zVqRmZ/MNPsHwsm4yLQTb31FJEJozUzjK/qR2oP+Vb6RTLFS6m2Xi2iSBf8AFcrV3tvD6ApRJ+c26GE36RtQK2Y7gShjABo1b1Rau1+sVhAwe4SsxUUy5oZUw0rfZpCNmp8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tu18ogzMJNTZ9pdtntO2WV9nNs9m2zsqI51OiBulFWU=;
 b=Rnvxcgk84cz3z7mAeWgy0BHeDbwDKcpb7vz+X6A+bsFPLk9alZ3KlUatSRbTi1oszMldTNd2l/6ko2QnNzcSdBZE+3qqiI8F8MYRjaX1chvmEI1Ug3ynaTLcHlK7DeLpelYBGE9zjol/zb84nt5Umnkbc4jJ35CvJ0y0ljaMygbGCDpEQVEQGjrZaqD0lwXNi2Wf68nBHkPHr7ZwaybtIGtAPusRpbNyXb4XM9xp3PgjjWYuwWqJSHXcpxSCLNAC5G9YwQN4NWR90YHRXzCAtC/2/zJ28GJ2z+E0g+csVirsjr5kV8CPCkbBk6uk8YjUViNAA2ero83m9JXaUTMKRw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 SA3PR12MB7808.namprd12.prod.outlook.com (2603:10b6:806:31b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.24; Tue, 22 Jul
 2025 00:49:18 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%3]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 00:49:18 +0000
Date: Tue, 22 Jul 2025 10:49:10 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yonatan Maman <ymaman@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Leon Romanovsky <leon@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Ben Skeggs <bskeggs@nvidia.com>, 
	Michael Guralnik <michaelgur@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, 
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>, linux-mm@kvack.org, 
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, Gal Shalom <GalShalom@nvidia.com>
Subject: Re: [PATCH v2 1/5] mm/hmm: HMM API to enable P2P DMA for device
 private pages
Message-ID: <7lvduvov3rvfsgixbkyyinnzz3plpp3szxam46ccgjmh6v5d7q@zoz4k723vs3d>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-2-ymaman@nvidia.com>
 <aHpXXKTaqp8FUhmq@casper.infradead.org>
 <20250718144442.GG2206214@ziepe.ca>
 <aH4_QaNtIJMrPqOw@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH4_QaNtIJMrPqOw@casper.infradead.org>
X-ClientProxiedBy: ME3PR01CA0013.ausprd01.prod.outlook.com
 (2603:10c6:220:19e::15) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|SA3PR12MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: 85b08ef6-2a1a-42d9-85d9-08ddc8b996b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PwyJGdfKqksh5WDx6VfQXyUNOyqpKex2GksjJ5GUCMzjcS4o1pkHaBBXGdxr?=
 =?us-ascii?Q?R2XlvicuIeIcW1/HywvY1ucvOwl2+SE5SMDNI1QnXoNWo9KK9JYq6xR7tHyb?=
 =?us-ascii?Q?JqEtRBJiYTxahI23atwdvQCpomCkY8JOaZxBWYfzS9rR7Zr6y8jPhxbswYXe?=
 =?us-ascii?Q?Y84BIDYhlU5HImUaWnRwgBSIQhDQ4x1G8rzPDs0u13+FOVzAMhebEcobcR/2?=
 =?us-ascii?Q?Fx9wYngUk3Hfh7rha8hpWYD1BnLuVdPwPqhNXxkxjd1lbJx1dWDfhLf/eM1u?=
 =?us-ascii?Q?7wEAcP0i6ASNzqEnCq0ze6OtpT1iVp0uYOxVtlbi9m99qw8ACBQMWtcofoIB?=
 =?us-ascii?Q?Yy5Jya3gWYvJutdx2cu6XxV+stk70AqO5Mej9ISP/lyh7ir9x/ADtu1hGvPc?=
 =?us-ascii?Q?Xb58Wkz29rygSA4jfLe7GFHQPUA1ohaXjgAKXBBJ1idBwtVd12fujANbaM1C?=
 =?us-ascii?Q?SXz1Nk3dNsvNSx4s/Y4bLtXLSuqVzZ6on6SqbpdUDyUKsOi2guYufCXRRp6S?=
 =?us-ascii?Q?CdaYOLqda4MoPbr3082UBlYTRpP/zE5B3uxrbvj588H5FV89yo3VdT2PqaqZ?=
 =?us-ascii?Q?i8zsef3xAZ6nMXsDaNkZCYWk1l46Mnd4RDzBBSgp+7F4rcIyw926ePPk5bNu?=
 =?us-ascii?Q?IQG8t6ZJu+5fAqXqg2NcN9StisS4TqE9jCc1QtaPS+CsGyTpqlZ89P4XtX5a?=
 =?us-ascii?Q?L6I2zrVAHxjDEOPDEsf/hsRP7zVZ8xTEj/YyuqlrUUgcLP7y2HIfy5Suh0xj?=
 =?us-ascii?Q?QEZ2+mrgAV+Dlf/DEf6pqM+eSjCIO7bRdCDv95BLT+TQ38z+8cJcEdRzki/N?=
 =?us-ascii?Q?XL2keTXIe+/A8Nhiy+u0Vo/F09FbvIytbS+z3FH53deYXR9rdOrSo/e+SssG?=
 =?us-ascii?Q?AcNSApYlobu2hTIv8Jh6NlRpeBPTHVjvt75rKlMFd3QfojiyopiqNEjMp6xc?=
 =?us-ascii?Q?ILAgJaWZ12JWCs3udDgB12tJ39ZF2offASVeF8uPjBv1m6S9NgFRoac9W4g3?=
 =?us-ascii?Q?x4vTkcij09I7B0NoD8cbPtza1avk6290oIR9TfTGrWJjGKxZEjGt+ERpLflb?=
 =?us-ascii?Q?odSSPporrlv4l1qUx8qm1Px1q03GOKj+N+xECRs5zYtxatY4Qdg8zHc8yQ34?=
 =?us-ascii?Q?9etgcCoFzINMOKMuiZTU9/iIgWD3TzRTLFP2/7EQriYHDoF/FCTwXqnM83HK?=
 =?us-ascii?Q?VnVR8emzCDII3Na0eQTRHwkI8Pv5CIpCuQjGD3USDo/3wigGgVhU7TrAO+vr?=
 =?us-ascii?Q?gwc3QD23GbhIrySgwLzit2U26X4dlVx7amMMZhtsDAbbaxCWL+Q1eBg9HDUC?=
 =?us-ascii?Q?adQxy7nCo/IamLSShH3Co5jgNQ85UGdEa5nPs34o7H32IPP+2NPmFbuITMwB?=
 =?us-ascii?Q?3puKZxxmyND9F/SNkbptBo1eGf4j7Epnm38ntH2wHBe2LhpBhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8D6ftjIixqBnNlS9JGytKM9/NC/Uz18ZiRF42Kvm4QltHDEakl4jENCq2jTd?=
 =?us-ascii?Q?paXoq0eKoVx43ZbEfHdvSY0pqS/7I/hjYSiGcuegQhAVxwFuaSF7HfQwE34n?=
 =?us-ascii?Q?QPNiGwTAjMb8k47FchxaSp+nsBDhcpY3Pge2uLEh4r1RfX/7Qs1l032c6KLo?=
 =?us-ascii?Q?s2wnmJpgFV933hzQFyBPTwJ4bnqpT0nE4UjLzm043h9zlUgGzk8ZNstWldfJ?=
 =?us-ascii?Q?5ABcwJnyyM8APofkzcT+k4cKfVaTY4hjb/yr6DSE2WcaQPd6mYDl4tiTipA1?=
 =?us-ascii?Q?z9Xw6OzA0MeS795u28X4ZN1u2XitAMj5cksBsiBRUjBXvU2HvYaFx+WKNDks?=
 =?us-ascii?Q?4mnPCDyypqhyXGe4kesQUKOg+wafb3b0R0UfyoM3t2TBq0qXmTTROFUL5FKt?=
 =?us-ascii?Q?TlQ6PqctWzRDE/oFvLb3oPqhiTBExpB8XPfYeemgW9Xz8SQClVL1OZRTYg/D?=
 =?us-ascii?Q?uJPDJ9HAqJ2HZwIRANgu3QlhWusw0SeyzrWeux/Wtqi7SvkQNNn52n65IYI5?=
 =?us-ascii?Q?89kuaTbhafcfIDdr2SiSk7or9WHW1YoXEL5aP+hHiBurTCcWjhfrwCXrJ5fd?=
 =?us-ascii?Q?EzzUfYoJyv0jEZ9szxEx3UIo0XrR2V8XcrpRAfEMGc2/Q/mKJYqxA5favp+x?=
 =?us-ascii?Q?fTqyBUVgnj01F7Xx5qTjtTfqOFro04dLrmBjLnzTYCnppi7eDoE8argcZcqA?=
 =?us-ascii?Q?FvyFO7iczIG/mO45gd4UnYMEeab+f4Gbl5awrxtT1t7rivDS3sn7yqEFn2E5?=
 =?us-ascii?Q?7Rk3dpezAQCoyJvJ8BSGv6+BoSKzLFKfDHpdxpcNUZjeRRZ9O/jcLtFL7Y5C?=
 =?us-ascii?Q?8c2tbWm0LFmvm1a/F4ZMzBEXK5EaYqxr/JiUjEPby8xeeJHlXABIR1+J5g28?=
 =?us-ascii?Q?IJGYunkvC8Es4xWKkQfC1vpEaaaOfQvJ/wJqjHmsL9k783/JcUjxq/R0YkM1?=
 =?us-ascii?Q?TtahbHFQ0GegZ7uIXqAxq9YujtoAqwtd3m5XshDEp5/BuFxb4K0d4OBa4iA3?=
 =?us-ascii?Q?oIpj/1dsEbfq8TeuuImVpA9+nwxnTCoWSdYsnlcTfBY2Qep1s3pDXNmSqhkF?=
 =?us-ascii?Q?dteGNtuF8Wctyp16I9WbDWWo6NUsyzUTltuHfy4im0ifXC1gmDdd644L3q2g?=
 =?us-ascii?Q?DApn6OTwzjEyiUXIrkPDMqwAVoyiLoaQaczUNC9GVQA/O6+I4Pv1lS3bxi0R?=
 =?us-ascii?Q?w7UcV4KlNd5bbmh8dS5dRZOv4woGcGTW/wkKnTa8uSvzcRe9uBdV7p+aXTpQ?=
 =?us-ascii?Q?a+Jq0nS1EiqyQTj7lNyETaclA6/2c88ffWtdXwjvFv/Pg2Uj7bAVs1lF1JVx?=
 =?us-ascii?Q?DOURXxwUWqldmFinOPJZoHdmYqRFeklxtyik9iT+qzgFyGtHHpVGYRW3EErw?=
 =?us-ascii?Q?IG2Pr0E3W5SA84IJZJHtBSwVbmFjn9M1lGamEWqiJHXs+DbVAqZaR2KzGUK0?=
 =?us-ascii?Q?AGOpWbT9Pvrs6PebJ7p8DY0FKQrRpsWY1qa8dkxaUTlCSouxjamW17Mu3pHx?=
 =?us-ascii?Q?5iN1mlbKi0u74RtawTUhzfrGimVqaHxHOzYIo0ArZDjYKIdH/pU8n5htUd5b?=
 =?us-ascii?Q?gLE89Qbt3yy2JH7SIMzGKSJVfCTKcph8CyEYFmAr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b08ef6-2a1a-42d9-85d9-08ddc8b996b6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 00:49:18.2980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkCAtAczPFv3Oj7KySf+LT8GdQ9ccMaUSGL+1NVo/IkrXcPl/JCZLxYl51PkHtwHqM0PaecblKgMXsQlBa9/Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7808
X-Stat-Signature: tkop8f54yupiqx5ckssfukktxmt3i631
X-Rspamd-Queue-Id: A96BF40002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753145362-959293
X-HE-Meta: U2FsdGVkX1/Zv5e5iU39TKplq/sH4UCxX3g0TF9WkAwhLzZh5QBeIWYxv741uc923GqnHnS7NIbrgxZEnkUvCfn0h9AaKJoVu8hlo2MEdg1/d8P5hrPuyefwLjoopBi7Or3IAYUkWSiD+eg8iFiz56b/e2A0ryoxo/v36Dps3OJdKz/4paxmIU4u3eam/jGwGmzIbvSzomWwDGEZg9Y81sXB7ni7AxPSAk/OX7rKOaOJJTEuIPSvQ0CjPtIXtJy19T5HNzUvGHKb/gw74/VC7EZx8Z9S4KXmDALPGWwRTgN+AW7E+sGU8zZOVWFGgNdE1cMH2SiOuLntN/qABqxzUVN5XFVrEqBHLYaq7cUZuw5AyX8tUVuuqMisT+E3geL50T8U6IruQJGX/mXr7k15kYIRenCwsJQ8YjN+PVRBsa53SGSSG6TwWBli0ciCiQ9FEH/bNgd1lQDAwCDQ03oxHnq8HNRYIuRWpMLeHx3/vNp9QM0eNbpNdFdk1HW9f3KtjHB1gPGnHC19OAfTYR1PUET2nTtDbY6EwRYO8JPusoYrThSCmCHwxjzJoEvRlkhFVXPF/ZoZ6smPmJ03KDqjOEyZlgp4+XKYbouIi+7nGlRaZrPCI0GtbKOsi3Id6tmVlJW6YHVZIwcr93U8/0C8v98QQtxddokSN46c33CGyasLbbfYD1IMTunPDjihB+jgls35t15ADu1QSTVcQzJ49coud/U49x4zLE2cHphG5HIJSvvzga7Qe1lkUWltrNHG40CeYhzIMKwtIkuEIXF5Y4Z/ITTuW4ctI1LQHPghYweklr+KShqvtY+Y7YJqQT3i4lLorhnYEpWxPdvw5lDc24KjU3cf4UdEFVo/QvmHqgA4lomETWD5dUCNE4+SWPzcFGGvJuvAlIPwwLPaQx6EVgjomGVgAoMuCKHyriDh/7vqHe9CANr8pi4N3QpSEP9L9KQVXDS12NmX0ABqx+7
 IWI+tlBN
 YLMquZNFmPwwDCBDcZnQN9YZdtjVMQOQ23F8HxA4UXaFkz0ooo+bTDxGyTbkrLNUEK7Ft5OaF/8uQgk+uEOOUtZsPB52KoiS56tjTtcxa/1T5v3Uo4NS7EhFX+kduc+zy9s5ru7zFjHcfLw1hb/qrZrf994jcSGHbAr8qUcjh+NDMol1jOieRh+JgiOWNooYR1sGMKzpfO5mPDo0E6D7iJZgPsDAzjfPbYokIaNK1dmFxZmXup83HRYaPD0HZnQuoJGYUwaCPAtngHZ+LFvxfOZCn0QmYtAas1XadP2G0mMiouIQumQRx5h+j5Eve5ZOyFDSUrFsbmwvC17kABc3OIHtNVsiyXIes0y8kEFHFMtDQcqlvUNvUeD/yygBL/Xi0rnXYzF5p2nUDqlRKT6WefUtzE1/yMGnAUEm2sY/7ORRbp38RcVW0WeQbRAIDg9aUZyWRxb+XR1vubJ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 02:23:13PM +0100, Matthew Wilcox wrote:
> On Fri, Jul 18, 2025 at 11:44:42AM -0300, Jason Gunthorpe wrote:
> > On Fri, Jul 18, 2025 at 03:17:00PM +0100, Matthew Wilcox wrote:
> > > On Fri, Jul 18, 2025 at 02:51:08PM +0300, Yonatan Maman wrote:
> > > > +++ b/include/linux/memremap.h
> > > > @@ -89,6 +89,14 @@ struct dev_pagemap_ops {
> > > >  	 */
> > > >  	vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
> > > >  
> > > > +	/*
> > > > +	 * Used for private (un-addressable) device memory only. Return a
> > > > +	 * corresponding PFN for a page that can be mapped to device
> > > > +	 * (e.g using dma_map_page)
> > > > +	 */
> > > > +	int (*get_dma_pfn_for_device)(struct page *private_page,
> > > > +				      unsigned long *dma_pfn);
> > > 
> > > This makes no sense.  If a page is addressable then it has a PFN.
> > > If a page is not addressable then it doesn't have a PFN.
> > 
> > The DEVICE_PRIVATE pages have a PFN, but it is not usable for
> > anything.
> 
> OK, then I don't understand what DEVICE PRIVATE means.
> 
> I thought it was for memory on a PCIe device that isn't even visible
> through a BAR and so the CPU has no way of addressing it directly.

Correct.

> But now you say that it has a PFN, which means it has a physical
> address, which means it's accessible to the CPU.

Having a PFN doesn't mean it's actually accessible to the CPU. It is a real
physical address in the CPU address space, but it is a completely bogus/invalid
address - if the CPU actually tries to access it will cause a machine check
or whatever other exception gets generated when accessing an invalid physical
address.

Obviously we're careful to avoid that. The PFN is used solely to get to/from a
struct page (via pfn_to_page() or page_to_pfn()).

> So what is it?

IMHO a hack, because obviously we shouldn't require real physical addresses for
something the CPU can't actually address anyway and this causes real problems
(eg. it doesn't actually work on anything other than x86_64). There's no reason
the "PFN" we store in device-private entries couldn't instead just be an index
into some data structure holding pointers to the struct pages. So instead of
using pfn_to_page()/page_to_pfn() we would use device_private_index_to_page()
and page_to_device_private_index().

We discussed this briefly at LSFMM, I think your suggestion for a data structure
was to use a maple tree. I'm yet to look at this more deeply but I'd like to
figure out where memdescs fit in this picture too.

 - Alistair

> > This is effectively converting from a DEVICE_PRIVATE page to an actual
> > DMA'able address of some kind. The DEVICE_PRIVATE is just a non-usable
> > proxy, like a swap entry, for where the real data is sitting.
> > 
> > Jason
> > 

