Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C89CA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 01:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433436B0099; Thu,  8 Oct 2026 21:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E42A6B009B; Thu,  8 Oct 2026 21:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0116B009D; Thu,  8 Oct 2026 21:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA7F16B0099
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:29:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73E3E1A01E6
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:29:51 +0000 (UTC)
X-FDA: 85301356182.21.0B44A38
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80494120004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:29:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FmPQogwz;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791509388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yx2FT4WQ3o1sSM6Ag/+XJWKENAbx8MtlLMWktHi7nxc=;
	b=oRJAoG42Ntv4/EDnqAnS6jUQb3mwsQZMN0YyXOYLMvDw0thYcsiiUMssviGA+SidtndWvq
	bcGryu5AEg9Fz+oVSOAqeh0iBsCRzBAm4LEDdh++L9H2w537TOkx4+pYb8ekEy7/TzxlYb
	8AQMuZJPkRQV87yHZhiC7JkibvWQWy8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791509388;
	b=Q2dK/Zuux49XxFKy6OtKfTgAKVCMahlm5kovbyGRj0JscD0EVuSFHow1WspEYEwrPX0v+E
	fhE/kz+TqhmFY3q0ddrvn8Wev7r5qrNS48NDEFSRAahKKHQl9pWj5hBqEr9wTOYbemJPwM
	j+NLBJ3499duZzLez+/P0Hdw3txbsKI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FmPQogwz;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sLR3f555Ftb9MpnkId8lOGA0dUai7NtL9j9W/3mKPbd1xFHx1TDWg+N4jwsPgKbkXQ7fHwWfzPdENJ4yvvtxqGCMyVHz8VR2ou8uo1S0kvcrvPzyhuQsWyIk4K76+8pendyCb8A73PIZuudBmRqYEMYrepyxsfDSz3y+FPNjiqQCYeyiTCojMUaPK7NVf2o8aMx76u5DfYXq8uvNrUd/XujMKOn1ur+FY0RXl1aGw82UqkopYznQdrENjCQzcOQ15SAR7CgOi8AatlhSrq+DRbrdfbxAQCOZwNoHi2+lWi49c1ecmofblIPdNZs2J3W7WfbQ/BFmsEFx49LhdhD9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yx2FT4WQ3o1sSM6Ag/+XJWKENAbx8MtlLMWktHi7nxc=;
 b=RIZUnkQbQTDDMLcuAxaJkZ4RfzzrWE3OnoWh7vHxrAvyu3KJSlgCiIR78WVsmXclCFHPFgVU2BqpNeCh7NSIsD7Gwkxh240juReHr3WU5r5F3GWeE4NT1UkEajxeJJLhMyOcc4xTzPZc3GBGKbwYXv7Vu24LJeGDzgCX8AcRr/g59g7TJbHF1VDMrf0LQLzCNLID+ne2kk+C/eMbMEwhpBfbW6J8jbwjp4VxT80h9Vn9zPlKdwRP34ZmNann3R9D/no3OCjzfd5f4ECgw0J93M77gTGoonYRkVURWeLzZrolgLcBNAeWPQS0gj4vWHcNdaT4OBlQvd7BVAn7EL4c3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yx2FT4WQ3o1sSM6Ag/+XJWKENAbx8MtlLMWktHi7nxc=;
 b=FmPQogwzbfRu/b1czCjchMboSD5Yt+Q9WV3Fg3pKr8SfN68wj4KLcSuX3sR9xZSRMzdSpngMRzUPyyR3ZyMNFqblbdS5R6ihFGf1qvvTuuHMF3T3ZGPiz/TYA9AIIAk5EwLPCOurKFZfZQJ6KzckrKiFj3djy+JaijaAUAh4o/iOGGppvtDyb4XycVBA+24a5/cs7jC59pKvkQDZ4FX4+qq59GN25L7NU0gdcTAjMO9s0QwiHarIqutCaohic9IIf+k1zpJLr2wpBVllbrIS7qqKrASaj/6XDNxCXKq74jMoEuaCvnBfvyAlY0dkCF6otEjJHAqYvqgEV2y4aZNvEQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB5894.namprd12.prod.outlook.com (2603:10b6:408:174::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Fri, 9 Oct
 2026 01:29:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Fri, 9 Oct 2026
 01:29:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce size_to_shift() helper
Date: Thu, 08 Oct 2026 21:29:41 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <EDCF0804-FF9D-4FDA-A2C9-FE869773C61D@nvidia.com>
In-Reply-To: <20261009-fix_hpage_macro-v5-3-54378ae45add@arm.com>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-3-54378ae45add@arm.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:335::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e5ce795-9626-45f1-42d3-08df25a4cbff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ieIOorWuOIL4AvfH4fGlkfMUv/zlKUhYSiOeVQw8K3ZMTSWwn38MwMLgwRoIRsmnetomfXln2J7SXiq0WUouFih4CnggYpvwhOZLMAEtf9kfTA5K51q2e/ZcX4MZyAXdhfBCBXL1cqmDMI4okBo8P1gcns8lUnlTo2+a/hGwIFe/K5Rp5Bh8mgSXZaGeUXD3EWMx38MplB9Y/Px/rKt6/W2mW5ZCwYGvMT5Wa1/Uj4eTRVeJtBaT1REXzikb2q8IpHl3WZ5LH5gBYLTNwqS99DRoZNNh568HqAiFxwn9FdXM0yZoBkL64KUSLvfTcn55XkQSoPtuKFMq8VpVCdN3qDeClgqBhOOYW40SXVcAScIdBcMQSPpnAnWKgdY6bJAoIZCkx8S25oZj8CgRtCHURr6Xo3nNnk1ouGKc15zG10KasVvZUqSKa223R3xiwhdNiw/Mzw77mNaLEXT0oHZjDZiQpJdNp8sWpRKd2GBtYpDaOP1e3zji2cQFC62sCQ+4l7lcx7vxEYk5nHG6tcr2Y6KAzoopEd1FyPSf6gk9meixVvvBDpuv9mdAVgNnWsCO7b3MpOtGr1l1h2NPxHI+rRkuX8BAm67fLbL5ea7SFzMueiNVFyfUnEWF8im1R8SWebOX/reV/iKT+kJjCxhJVZDoiZZecBkmSFzpPz/rHo4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V1sL6BvBefdeL2XWLH9E+lCzYxrlfPfcGOhLBxidVHQpy5uVPaMkWO0nlpQe?=
 =?us-ascii?Q?Q6q3nejLCovMGjCZAKIYRwO8C7tfpvgUxDNyvsXfWbLPc/bljtXncojKORwM?=
 =?us-ascii?Q?EE3nAIEZz5QXbXkQA1AdG8kwCO5kiuF0xldH5GIhYI6lDmXlinFjO+CLmFTa?=
 =?us-ascii?Q?f/jXg2sIMaZCx58F4dM7VTRujtl9ppyawOA1cEbvd1FcRh9SuuCNW18IqoFZ?=
 =?us-ascii?Q?14IVHvpyCJK9I5JYCs+RwdVNjRXZasjlWYLvB49bnEZxMHcyye1kL0dVh6Wb?=
 =?us-ascii?Q?+XH2Cvz5Q7eSdcEjhsHxJEt2taYfQbEH+b96Jmfll9xN5QeIdhvhMYvSrTkY?=
 =?us-ascii?Q?T1I81ECDVmjvM13F87EMsdr3M26C2a0VuoP3vYsu37Cb95fKAfFmJPKnvAhV?=
 =?us-ascii?Q?0fyjUIcl2kNJqRwyzw/C5uq9YGP8IgoJ5YKPNmovznT1EFtspGLgB5ScMigj?=
 =?us-ascii?Q?LYZl7xWdTSzlESDGJrjCisiKHBC1AC9LKKGuF0OwctsZiJw8A2qggcI7GYxg?=
 =?us-ascii?Q?5daqb6DD6QTSNRoaHe/VM/xCn4C4mWhzI2p6MS7o9tjlvWvl3iR/BuvvjsQe?=
 =?us-ascii?Q?wt9rXrP0N/OM4el4uTDxZ8YNl3gkJ9145tpxcSudn3/cqDMiKQZ1wavSaR1o?=
 =?us-ascii?Q?BcF+MxSoadbGBAz/FSUHqiwBFAc0bud5brsZCylCmotHLzqtCtx4Ahxg4ozd?=
 =?us-ascii?Q?jSGsvAb2hh7LPnCdiNBUp+owfbSX4QXNfpNu/d1t+C0SDvq0xHYfxnujPrFP?=
 =?us-ascii?Q?Ax7+8hDB0O/FDtjn5gwl1D2DEJInr65sawVjXZ+NnPV/y2y07kFH24DJf1mM?=
 =?us-ascii?Q?SunR9KH4awlAkCV2RsyZRSI7IrJDZqLAfvYeZnPSxvq1VvjSUHvENobawNKn?=
 =?us-ascii?Q?7u0H8R5H7DCGdX5WUHYQqZSnT6Mzlh8CaXNgnxWvAd6DUp+Qie/RoakOaNvn?=
 =?us-ascii?Q?XkGWDhW/VPxbcizXYpFd889reh/ae9lFBVDQXALOrSzbwjWAGFAdD7FWJ3Rf?=
 =?us-ascii?Q?Y0HLGnd6beSFrDMeF2FLGWFaJeXoNxLHJUcHN1VRed7vKaL9bsiwCZCy1fmr?=
 =?us-ascii?Q?+6YGEDz4pxqWoArcSWn2UaCvUOxuGImnDwZNg+Te4zeFVXMPEUe/ERFB8zce?=
 =?us-ascii?Q?BHCbqFmp0QfYwqNe6CszrF7KTkeFXeE/ei9aMJSi/oBryPs47voOZFpi//dW?=
 =?us-ascii?Q?qRwxQKgUoinq280yGJa1vgpOw8q6oGQBE3v7I0abUlrPOGaDwZM1iydx2+LO?=
 =?us-ascii?Q?qyhKtS2UPWVYVXRyv3ZyorYHJqHCFWplJI7rzbB/yY914LwttG1y0yqHArhk?=
 =?us-ascii?Q?3QxAZ5HBI1OjGRd5ucOqFFdJVGnN6XIWktku4rpbXdO6zloioqrdOWkJIG3N?=
 =?us-ascii?Q?MOTdzzvJhTIKGyIwfo3z4a6ZMslCbXEz3ljvbE1s+keQ2m0EAV1Wi5+fiF9E?=
 =?us-ascii?Q?6bR/ydtr/6gUYQcwfWJJBD9uzOZ7ktt/S/2oi9+O7vBli/+YVBV9YZ/AqCVW?=
 =?us-ascii?Q?sbSCR1sow3MEfGGmpkb+vemuoZ0gK89R87q8czZDV+F1sxJcSf/WY63iSTl4?=
 =?us-ascii?Q?ffYpzneNQTcBZawAK6yH4+OrUSBLVyH6JS3dZq41LV7G8WRQbjFGyJ3O+/ql?=
 =?us-ascii?Q?WLaGLUgWBJMsmW39LWw+87ahbRCqQl6XufjuAsh5h8bocN+LBZ1J7sSoI4gj?=
 =?us-ascii?Q?7F35z6tWX41+xxRIr84ogFd++4oCqy1ugqzz3dZJc+61Gx0S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e5ce795-9626-45f1-42d3-08df25a4cbff
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 01:29:43.8836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SIe6YumoFqXibXl9ZJQn+5D70ntVY8/Wq+qoXyxu+oaHCntiwtAs48GD7tC0tQzj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5894
X-Rspamd-Queue-Id: 80494120004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: cqdbpb5fnz9koh7yczdxed8pjz1tqup3
X-HE-Tag: 1791509388-189818
X-HE-Meta: U2FsdGVkX19t+kFQJoWWoQSzbqvC0kONChrFCriowq+bHxMaSLLvukAKEkHF4SX7rx3zFH8hYkY5Qt1ZQEdbGvS1hg0zkLHMtfb7Rs2ZUb7UC6EV/2wHQ/GwQek/kbGBAy8ANO+H2R999WvcJFEKOb2FA22psD7aW/bj5OzzYKy+zdv22zf6Mh7szI0CSskuiBD59SGZhET+XlX4uYqKqOfcK8YmDFuhxmXorHcxXAUYQne4E1E7YWg05qzsuSh6hFWpi6qZQBG8cMX/wFuw9KpNLJEL6gPassYfoodVXPwMhvZZ3ixqZf5/aCxTo6KAkbEQXXHEjGFPhsOn+m9X7+RLUR0bza2tJ5HZUkwoq1P5PhDNcDKx8V9ALjSXWJV3ozvhVjlPcpPWk3CpI5X8Fidez/9QpuNcMDenm6WGS1pUX4NxlDjurt4BwWIEePl5PJTWfw85yL9gtJm76EKJEm+uNX+EwPczyRablp8qUHxp2tYZUl04j6Y3aAMIREzjMcHIA/t3Uykdu5DDiplPl3dKDzU2iK56BQdrIqt7GUaktp2V1ikrSB3nJnoS+6HHWNE201zkXd7M10xHtyvqVNaYp0OvoarQp3rbOQUrbenugku7pcgIu0YHHwIpS1wq43HTWFcAr53L+k8jO6WAVSlxinfH07+jbELgFeSnfD/QGKJLEJFCxJAAzA4ws3AIzCvaX3QOqspTrv1MujEQ3UMr9ckw0H466/XS7WRZn1wkeNRnKXyD49il0IEy8Po1K1yqxJV6M8rUWssG9S2QmcprNhl6OvqwTn2dUbk2lPSCu5SxHWf4gtD/7RdOl3mcAbGraiJz1WpyTk4XXHMwX4217h56x6KspOrNFpb41/29XA+x0UfGhy6Nd7Q0TtOX5xi7FLSC7HnMlJiV9FO92R8HCTrL7ykabn7CY9oUCs/mfHBXdl5YL7yNfcm8Zk0cRmblYc/y6309He775W8
 IMIvgPkJ
 aR4h9McFw5R2P04hYlCF4dvdAlYUQX6fvFA2rWMJcaFpElUhg2HKe/rId3S/dopNDtBTElzZbrgXS2iN6zpXXPewr13fOhhb53921UOhlQ7MtDURQog2uVIGnq8ObP+kIu4Rkh6/RXHoRiF4RPfU8y99Duw4qMReOf5KGS7by6NexoRzq8GfpMeLK3ro2vLCWaENnsdqUflzQa5uclqLNsNNI3hMOzg8cUD1vvg0P8QEAMTzCTONmuQ1b+dKK5cHYTJg1jWfwA/Z49WPuj29GHkb494vs4mSGpbHbnQMh99Rps6A5FnfuuNL4488ho2AdDgIGjylZwGI1WFvwfAFzOqzjL7zP9KtBWJEd2ZUWUc56Ai0a14gUqGnSha0bH6vNnuKF6oClbdjjVOJLZx2KZBinlrRiDNsqTOjbphYmL65DnzAbaDO6PU1VEotfabm6elo4KGzOBRn2pvPI0ud1wRFMAaYONg6AH31Te4Nrfq8ZjR4TaA7eBLQ5UAUtwSxKQ4VgFUBZeVanMqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Oct 2026, at 21:27, Yeoreum Yun wrote:

> Introduce size_to_shift() for future users that need to
> obtain shift of a huge-page which is other than pmd_psize().
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c |  2 +-
>  tools/testing/selftests/mm/vm_util.h | 12 ++++++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

