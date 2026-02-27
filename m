Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA217FEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0879F6B0095; Fri, 27 Feb 2026 09:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035206B0096; Fri, 27 Feb 2026 09:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BDE6B0098; Fri, 27 Feb 2026 09:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D011E6B0095
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:13:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F2AC1403BA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:13:46 +0000 (UTC)
X-FDA: 84490430052.06.1F3AB56
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012010.outbound.protection.outlook.com [52.101.43.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5DE5414000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:13:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fod64RGn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.10 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772201623; a=rsa-sha256;
	cv=pass;
	b=4AEu9C1DUC9fz6mgw7CMFOB10io6u+6iYGD8fYYLqwIL4vYidHuxhu5wVKdVVrd6JZ0btK
	OAR6Bsgw4eypKlHHHYcQXcnodzBDiqM5FkFpyRTj7xxIlxRU1G8k+x3XMgHfUQOHGqFj0B
	OPC+HuOTCNyk1vbXlYrHnMztZ61oaWU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fod64RGn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.10 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772201623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7RXGp6Zxv6O5Udt4N4jet+rBZrmfaPDgt7vjMa0vZI=;
	b=OWg7mVtBwRkZ8VTFdcjR3Qgqm/RzZ/AsD6dd3I5N1qjHcML3dAq3lxgQqntxeWSJEWF2s1
	TXUpGaYmlwJZbCHNGeGIeHOAAlhM0elTXmWzgEWWRD4Gh7xDD1MogzY6+cj1UgseWdG042
	J7IqLpZpcGYKt/d6NpRKC6Mda9haRXA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VZ7Q4xjNEN+m0pQVs1h935mqxc1QTwyzM7IsIINGOj4qQvZKRdGcW0J0JJe9LEoBDG4CJMbp7q9/epzD54D6rL3gEQQ18n1KkJy/0Fzk9NyVVx/GPA88adelBJO9EjPWGZLO4NfW5qqXIEbDbOR20pJdlCALZB3N+GGFstL/XDq5sw46atHEVuscde8vqvJ0KmwGwwTyAblPfVzPsNtuKRAd7KTL7YKF8a9+KcCxjVXqsV1XPtS8p9ghPvS6n1AvY/I25BKoHr1ZEumRRCxxnINTqHbCjKVoiIcgHj6eIhDenh3RdUIf6MjRQrVpgRPgppnWluNAoKfsjQGfyzWaaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7RXGp6Zxv6O5Udt4N4jet+rBZrmfaPDgt7vjMa0vZI=;
 b=AGZZd5Pq1Ga5v93U4EncHa0wL9u4+LMkil07v35oSyghjhqQ1puqV6RDuQmX4H6nLGigiv/b3gN/S/R5J7DcfTQyvZSOm6YOALKli+O+5f6NShHEjL4cLV2Y/Gh5QkT6PWodxIL1LcF+3qfhVF+OCZBAAuw+D/OOdnTUb43LnB906S9Gs/puBhLOJhfqN9jR+xFBBlrxwRII/+r5Or/0Oxq6s3fpggas0YkmXn4B7KI98YaDsaE4JLKaYupps28mxND0ReQhnzhgvywbXtQvjIqG31/qMmWRxudC9ujROLbYWC8EyukZL70PGrS7VaNXC6hZYoYanBMPT1IwHXe9TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7RXGp6Zxv6O5Udt4N4jet+rBZrmfaPDgt7vjMa0vZI=;
 b=fod64RGncTEC1JplFhBEAfKWO1XFj1mZ80gtCQR03keDcBLcmytzva8QQFPtk8+hAzp0n/rinBNDOzd1vM019YXZ20F2gjuJs4piXcWwNmE8XivNlJnV5hLZ5TH/Ue6ZAD1q3CqLgUwISpOSHoT/Pq+JYFjQUf0mU3x9/s+sft58x4obEVeppfVJDDdMSWYJ771MPdLPINIbYK/OFj3Sm6XbJNn2pMzfy+C2+8va3J6C31C1wqdalEIhuqlbll6tX+gag2x0i0C4VXHxCjZijbkHEH/DsHpLwVm+3VOUPW/AOa/bV4U8nArdOiODQRmbEPkmyUWMWl7k2BJyNt+Ziw==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA0PR12MB7751.namprd12.prod.outlook.com (2603:10b6:208:430::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 14:13:32 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 14:13:32 +0000
Date: Fri, 27 Feb 2026 10:13:30 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Ashish Mhetre <amhetre@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
Message-ID: <20260227141330.GK5933@nvidia.com>
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal>
 <aZ4Q1HA9q1ojsVYY@google.com>
 <9d01b4e3-be5b-4c9c-8088-1d10f67f1fd8@nvidia.com>
 <20260225075609.GB9541@unreal>
 <aZ9Xccnn7JOikudb@google.com>
 <20260226075806.GE12611@unreal>
 <58634d52-5d44-4ec9-b1f6-273b5c32b525@nvidia.com>
 <aaGlapPSmFJcXsDh@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaGlapPSmFJcXsDh@google.com>
X-ClientProxiedBy: BL1PR13CA0082.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA0PR12MB7751:EE_
X-MS-Office365-Filtering-Correlation-Id: 23697258-5c45-4779-acdc-08de760a6328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	KR0I+BC3lubd8+ConvZ+Jfo/AG98108zmYjpR+msYVwZ2d6UUPmHiHpfRc5MKvykhx8cBKpMCLfnZJP/k2J3cAAn8Qn7piD5+PM8JeUWp9q+DoeTAkhslo63eQUAOHTVDl23qFyuSUHRRTrlqJ0z4kpuGXwKM+WmKoqOHpDEUkisK/PSTjyjayvnDmt3yHxeWV3yPD5lAStuzWazQyfVzyIcmS7+7J1zYN9bc3s3Lt3cWcYGzrqsOtrmOehIspf88Wb8Gtt6W9DVSXCCxL2nUREF0Ev4z5kZkKK7St+TR/tswVrZIX1zFajQvfAt2RPXmJdl0reJBuMDp4sdCZ4A6DlJDk/3pjvhtgEaS51NQHDShFDcPTs3yAU/+WEOsD8ix4KRL9yLTs1hiHrSQ0TwtGuCL4hBwSXuncOcTq8G6TOmamHdQvQ0oSe6k6TQlpytdnzgeV6Vg+O2QG/sWpB+tusKYcK9VruwHiW8rmMZYN8ljumI06LBJKRAqh7QqWRxF3RTOVC0MRJJZ2FR803Gttn5ADs4sl7t706l0df2UmeLSMdejKrBpfySd8qZGe4b2CvCrz+ppDVqThG8e9KmpaRPUErH1oT0B3Y689ubbS6INyxEp6Sl25j7ZuSjBpMpnQLJ4jPS/UdLOOhOrGlsXhyKsHdxcEbMmrPtWI28eVyWy5MyThW0Cwly8IGAO01libKTozKy0fdHUhkK7p8FcXF1+iCWU8Cy5ul8SBtIU6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W2kZBpdV0brpMQ4R8XYA2Z6Dk60npAIgoHtc9HGKyUNeWugsiBdAku9vYGBR?=
 =?us-ascii?Q?BV73RlTPKzx+BVUmwk7Ao+nlu+28pheF+tZ9Y5F0NF6LkmH/iRi5Y7ZVHj4w?=
 =?us-ascii?Q?gkbXqMYLBmYsnsCeQ1MEgX3mLiYUvTaAQ8YFUo+U5y2wE9Wvvokq3qrwcyrS?=
 =?us-ascii?Q?FxMm3I6qnjr1SGMo1TPWhtRAPI005y9Dleubt7/slgX+S7OoSsNsmOYVdjm4?=
 =?us-ascii?Q?+1Svbh0eFhwGPZ0sOZqXT+VIY8g6pR+IfSi1jMzAAdV9aTXdV7uG2y2QQbzJ?=
 =?us-ascii?Q?fd2oIlbAMRgnf5dw/6YW6WnluvxLBLqc65szuOt6R27mCZNLlhZbCTwUVdja?=
 =?us-ascii?Q?QDJ3nd/8dTXQUkL2ndDsXpIJLj2j2eyoJjKzqmhejUFaCNF/liYOaOZ5usNu?=
 =?us-ascii?Q?vE0KL+SHqHcaCy4/lgRHkc61EnaTHZpK7JfYOCHmogG2bniP2ghvKEzU8kap?=
 =?us-ascii?Q?BpJmcbTIsX7nCjQwueDrjbjChns7hUg3TiGNSB17zHaUn6biQztdwx2PabR/?=
 =?us-ascii?Q?9ta0Jg6S34rr0E9SrZLJNhDueoFlw1OFeEMhG4v/YylYvJdkU3a3Pzj4gvdr?=
 =?us-ascii?Q?RCTBChe2pGO9JKqehUR6Z802M2YZsgN+1Myurigz5FSv3kJIw/azmlrnIdmH?=
 =?us-ascii?Q?CSY61egbFgzZab0Zwal7tjMyveVa/AFnWIG3R6DxJFJ8wcSqaE/oaYbqxkUP?=
 =?us-ascii?Q?JQ9OFOH6zNX4k4YBXfHJ3YhtCs6y0zpcqbN+8G3lj0guspWw5/Yzjq4AYL0M?=
 =?us-ascii?Q?9VwGmREb24IInvpJUvVfm4Hb4dXw60LUdXtSW5ZsrY61uSZN+Zv3B+LldFf8?=
 =?us-ascii?Q?mar4o1AfQgIWSfszMZkKzy70wJfzXi8Af31h68HC3ZmWEl2RCzXZegA8p78N?=
 =?us-ascii?Q?Qi/WgsThDsWUUIFBpO6ZmpVyrF6IA3UPY1n8cbFDuFErzqKLyH3tEzjQGnZo?=
 =?us-ascii?Q?5Mlteewo+IzjPhPx6rc09X5iPECYejlQR+C8Lid8ey4OT8VzkAI1FfxriYul?=
 =?us-ascii?Q?cTmbEyoUzzv1LFUEp2PwZZ55Qu5ABAB7raNcvpRfs3XbWU45Mp+EE2tdEkLk?=
 =?us-ascii?Q?r6qMEjnv55xzOxG/txGwHM4QJdtfr9TA4IDCwkVYV36rxECp4jhElDSpmzw7?=
 =?us-ascii?Q?PjmrS6Feb/NbD37TrxI0jXXitf1ErfcYwOSgHox/apdjoFPLLglRWRk02ZHl?=
 =?us-ascii?Q?SA2ryuSqxmj9pXmat9b6jmwu0RmkJ8RRbGSvPnAad0X5D0poWRnHXc2vwyqK?=
 =?us-ascii?Q?m0CrlEE73g2e5Nrv5HvvCp9au1bi5FnQzWliyzmsolFtxyAMxLVv7D+KoYuS?=
 =?us-ascii?Q?LPFoqffUe321Zw0gkbIGc4ObkBXl1UxWfrSEYc8Dqm7Ghh/A80HfZ0+917wN?=
 =?us-ascii?Q?uF0/HjStg1mrVfrNoFHKM8O+Ix8vhkyow54+XYs1JgDvsnSzR/oBYL1jclRD?=
 =?us-ascii?Q?3RAJ1Q1idWcc2KCXQSD+r2kKuXysfB7n5OJ/OU/bcNrj4trRtQQ9btg5/Y6o?=
 =?us-ascii?Q?HCPwKuIKH7DEx+Mf+f3XBBM2f2SC/Eqi6JMohtXKtbTpNISS7LE/shH2Oonm?=
 =?us-ascii?Q?axpmlzuogaq/Q3kw4Hk7uvUB5tCqCX7oQVxMfuyBqJ6MPI2pOjocDOtTqRCW?=
 =?us-ascii?Q?jvqOxsCQETJYvAAZKO5NP6oTtw4F/IX6b+VumJbg1VIMntZyxHUZFFPYsiiN?=
 =?us-ascii?Q?uuF/586Fh8tIMZwCXFoA1kHGpd1F9jYsdVi5hL4E2w2ieVOw3MaT9cD6QY7f?=
 =?us-ascii?Q?smTdBabskA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23697258-5c45-4779-acdc-08de760a6328
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 14:13:32.0425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kssHF8KEDVtZmMu9OcJqKnj/qXB+h6T4Az6+MtBMwd5MmKOAuYr/axBcY65ubgNJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7751
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DE5414000C
X-Stat-Signature: rxnoqgk7mp488qcjxc6pskztz7si3ifw
X-HE-Tag: 1772201623-862315
X-HE-Meta: U2FsdGVkX18SBIkayZcN7OT+Q9SNLrYE/G14DtVzE6XR7c5VQgeWsIq2I2OOmc785MKXbncdyv1GveOPYfQde8KACjkKpNnVMcTUL2J/yJZX70crMn6ESa6dc9jB9bOfZ6ASBKjWFUU9vxlqbX1ORdCNwO4Vjla+gAMqFm6fyv/GWRscVYCRWbyOiRZt2aM26lNagzPKoOO5ybWflqKDYqnAyCH1S52iXSWisHnv6094V6DYdfMIFK4o+sMv8NbwSMV44BacjmwHVK0U3QXQykBEO0gNwLWb648jTN12HO/nyDwaEkH2NclKCBOwrZFCEbh+/gH7bv5BX3BoK81HsaK+/ykVGo8jkHgZEJwDMbf+3IznUymLUPih4gXDIpZXIOY3rQM8O3y3cG9yoky4cKPf8RtG5vkOUh/8DflYimmn25PPfRUW90mZXi3pqEhpGDjX11y9/32qHnRu+7tdhxVNqr6zihZsa12K9nzRJm1wYKGPYCBeBSbj0MdLCqAa052IjLn9lnkNNT49aC+2cPIE82fsjH2yrZGAuYBN2GQyq48RdCMCMa8b4Ap/SEWPhfcq0dqc4c4tN1J9PyhTk266XwCFlLmZ3Imq6b+UVl/DhZxunRUD/88F01ndUdcyGvBvaoJyfO8aKvh6/s7QlCKuRpx2zgbjV3lSEkJeoHbHMWNjIiAKzKCiWvBz3SDF85rFdUT5ams38ZcFqc8wEakie1MtsjXB1cR16RTxS/3LRnRvdPHa5xeXT7KjoaNCfWXro89xdprrBV2jpbxUts0ZMqguRigGpZSxx3nx+WnLeCxKHaWYGT1h4hcY7jWTEPPZ/AxLDtuNrG3MLRnv+3meNe9Wm6soba1RtWhT6FGv6XObqZ+yLhzBvcueNao9uio8aW5BBVlsL7Two37v3u+JDRkGzBYKXjRrSjYUOvV5vcBO8lSS/iqMHbUU0sHpPYcBGew7NEr4Z9X6FYk
 SuJsVCIC
 Edo/XTcPVjD8MSPWwZ/lOCpYQnld3mXRPCNDhpb11ULJ8COv0/yFMyUqAOoqLOSZlzx7E2Ayc89Qx+MKtHNizu7Is3Lp/U7mlRJ/ISMNR5xoEya4sYiSDBbw7xqPAj5HBLpR8FAPpNm4DpAhC63e/kvzz6wkkw58rJSo86v0oG1nBkjaahNHnBrXJjVgA4/YqDjz5CsR6D4iEtvD0ED8WMyNYVk7KnvDSPmhxxAEoza4RIaXS5m3X8wQpm47NxR/B/o6S4bw5cI5Z7dSvW4vesIYFHBzPeVgVhn6BxVgsJpJsxSPlanKcJfG55cDvNes6ajJjFWT+TgJGu+U1+A1VVMSpBKuyBwxNDwFkBVU6XrlhMyjsRwSA/u6SxYdrkSdCVI/MsVt+ZygyNs5+9OUc7c6Xpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 02:08:42PM +0000, Pranjal Shrivastava wrote:

> The question is, are we sure to use scatterlists to represent non-paged
> memory? 

This is absolutely illegal and a driver bug to put non-struct page
memory into a scatter list. It was never an acceptable "work
around". What driver is doing this??

If you want to improve robustness add some pfn_valid/etc checks under
the CONFING DMA DEBUG and throw warns for these mistakes.

Jason

