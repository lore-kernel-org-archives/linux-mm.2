Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAF77CFA464
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 00:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302E16B000A; Thu, 20 Nov 2025 19:55:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3276B0023; Thu, 20 Nov 2025 19:55:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154BC6B0026; Thu, 20 Nov 2025 19:55:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02E0E6B000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:55:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7F6B16028A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:55:56 +0000 (UTC)
X-FDA: 84132797112.21.6C30E61
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012005.outbound.protection.outlook.com [52.101.48.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id C93D240008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:55:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XgHtiXsJ;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763686554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByQusrWaKbHOUrScCYweVrexkDf+ina73NCjhjRJMX4=;
	b=JxieVJ8NFgAG6qf8BhokeYNHwNXPHUFa04tUKDXvicjXlDxuRIWhZat4IG51zxbuCe4Czr
	+fKLUOgdvNjXqWCDY/3GEhzseDYNEX7DJENbLBAqDOHG9U3BoAWOjj6oMkdRODhyJ26UhH
	5yyc1LyXHXRIHUPKc1Ilo7iwvouXL6I=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XgHtiXsJ;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763686554; a=rsa-sha256;
	cv=pass;
	b=LCt4joa9gTtDVm3xdUtR6O/LyCvdjINRxEHGvq07+uNlbgWpyjHaXv6g5DAbxkohr2rGJj
	/qQMFNn7OwwfTh0wHscSz6FVXE0fxRN91siNo0Z/phuuYHr7m26rnaf9bTqySrcVgBQeOl
	9ghCl5albinNqCe7nt7WU+RBY7zY8AQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o1d2B3w4dGiIRog9rdsUx0rMXirtT0ddYA8Kin1ms6odEM7YTTQU/htENgBto+K256Z8KUhkCbzodVurSBNNhTeiJdT91sFK1KrEnU8l+ZAq8EtLt15DOBYVbTh5e8dsxq/pmOggSpm0oMOm9daCARcFXZeGfd2eAR2CzKSPPYRU9NlM4gd72HfigWk72jxHV+E2pkWtOOvyygsWwtXYLMQAbwfmFHo4v8XvFiMt6HLm1D5cShg7zihNK4pax0YDw8o9BVqPMWwU7iia1cUpec1RhofB/tInz28F0/2zKKqEu07Fn0zHQn9mssPI1eWfJQOU2TDltTrWTFgNA3o7rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByQusrWaKbHOUrScCYweVrexkDf+ina73NCjhjRJMX4=;
 b=lMgM/JKCpGRBwdq+Dn9dBKiglLvHocPCpsNHnb/mfwMNuM9u2qssxwNjnzxCCB3QKPfasreYuhIdrBfmIx6ZuIcNfIDxA6p8rYCUMzc4UogVF/065hxHvlPvxVUoRmdEiir0j7GEJH4PKezVcy72qpf7hSYQNlHK86oR5LDFL+BcpKFBbwDDOfZewvIkhPZtziZ4Go0M7DTtkP3yOPFgcglybgtrBFhelWgu4nx3wZfCoNnMb/klOCjgikQaQKYVoFY61LHzZYcyMa+cjYm2A0UyK/bUcdlrgXPqvkH4OWnmxQg7fXxSU2hDWH5ERIIvVR1hflbbo7jfnB2EuIoW8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByQusrWaKbHOUrScCYweVrexkDf+ina73NCjhjRJMX4=;
 b=XgHtiXsJAC5Y4wnCm7IZkDfWLQtnuaKWRqUB+vFqRKAG2UsnY1mrOXJZENCBLQSH10jDW3lMPjj5P75ZSYbY19IUKgz2NnRSjg2YSUwx+mDovvHNHCiRXMYYsOPjM3S3Dmn/HMcSNPjhh28xujTxCa5U2bDDZVOLlAfaS59F91qkO52jWX51E561F7WFMIE98KmltL9a5j8nJ8o35azeucJQxmUvd65j1P0PWaS1f0wJDcKSY1IBHq18IviFfPjKiJ/NcAJQz3OzgTEd4U/74XlWxWQBdAFQWbeygebWnXTnAxxsEABzmk7R4U/p3rnacNKGae8fqfVpk6TqzoqHLw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH1PPF12253E83C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::606) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 00:55:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 00:55:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Thu, 20 Nov 2025 19:55:47 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D4AB3E83-6602-46A7-BFE9-B5D8E2CA574F@nvidia.com>
In-Reply-To: <20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
 <20251118033339.7rukw7vvjvlbj5jb@master>
 <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
 <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
 <2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
 <20251118140658.9078de6aab719b2308996387@linux-foundation.org>
 <20251119005248.ddlbhokgjdmlkhkr@master>
 <20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:208:530::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH1PPF12253E83C:EE_
X-MS-Office365-Filtering-Correlation-Id: f37ef3ca-7127-4ddd-afd3-08de2898b6af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lzQQFPkTqXC/j65QkutIbV8nQwHGqmpIinkQYvUK+hAQAOUEQpSIPpeqe7YA?=
 =?us-ascii?Q?H53o3HgNwMFIxBefg+sJNYCFI+XX0u+KLLxtvhcbclVuGJ4PGzkiABQciCkH?=
 =?us-ascii?Q?2PNpqo+i9PcWojvva98QFj26KnpNVZ4ZALyoY16MqrIzx6aWmYXrbPmm76gE?=
 =?us-ascii?Q?WjYCGsPHLGv7dydW44+yMufoq8Qhp1M18qJi/X3kKY5hdt1uw1+N04zjRAzF?=
 =?us-ascii?Q?h1QAkToEbg0ft+S6bFobFTx/YjYmVg1+iAlruQnrDfkD9O+sUgLq2M3nLZLT?=
 =?us-ascii?Q?d/f1k4rHTeSaAD/S79wpHOCjmFLlypnBgPYL8rUv5O/j7Qkm+1wbC7VC9IUH?=
 =?us-ascii?Q?lKqJoj+Gj88fW8MESfaMk4qS5icuaJRIfBfCaSAdiF462q/YPdJV9o9E0a4u?=
 =?us-ascii?Q?CjQ2Qx11xZIiGaEOiurd8Wy66MjIVLVqHxkg6MLsUQcgheX4T9V7Aig4QGnP?=
 =?us-ascii?Q?T8Z/SrT5Bhe5fo1igvoyLVqu3WbgGXmIqp9aUEJ4jSewNrXMtqMM5hKPH7vr?=
 =?us-ascii?Q?U/1K3ylX6UvzeSpMtbsm8/ltRGpbwVboPjD6Pcw0hdasTj+xfGG7ZXsWcsvl?=
 =?us-ascii?Q?wM3IXTUiRhZRRt5SE4fUyEI5iY+8hlso5SefgnXknBBwEfYVjlCFtYvbXkSM?=
 =?us-ascii?Q?qSuBDcsmCLmV4m3RLOtwznbgL6u8d/Jqlzzfq18gQ66iNXCd77IrVDmGNnvf?=
 =?us-ascii?Q?EN1tCoVPY+2zBrlv+RHmh+NpTpgLEp8buXVgdp4sHb4YCYzZxCPkTyJvaIc3?=
 =?us-ascii?Q?Y13EvFg/TDVo2fTIH+URAwYxWldehI2sGeZLw71E7YFci51TVv6gDz2rLZ8w?=
 =?us-ascii?Q?jLmqs0nUqrPcYMNXBcjf0Ml/YRbBVwnupiyId8yAfAKbLfOVuO2prOtMkJk0?=
 =?us-ascii?Q?V8kHW49RO4kRdR7Yi+O8TQqgzFJ+pp1bA28FQAwmLB6Bgku+/wd+bGbZlIDH?=
 =?us-ascii?Q?4BL1j3M9U+hYI2q4jvFSdJw5OyJOOy0+ATsB9U2xY/17c78ZNr2tPuDkfkeT?=
 =?us-ascii?Q?Qlk+Y2LB+PWNj4NbgRMV3AjggnDjDLFac+oQmK0quAlRTFU7jPlhwjegwSR4?=
 =?us-ascii?Q?w1VTSwA9jUZyiOpUeXbsbJFx50n++vyC1k5lMxG5ENsS9CWysUq7AbTWwWGS?=
 =?us-ascii?Q?ShOsHnn4cgY3Bendr7LBvFfbIgowljM2rzfafCpNNxTd0hc+NoWLM289/+mj?=
 =?us-ascii?Q?rTEEgB1y6hOUQBdbq+NIK15oin/Hg0LR9N4EoqleqjjXUFT/L+xVipzDS0az?=
 =?us-ascii?Q?ZxlpepK3N+dAT4NTbZ0PEEnGur5KfNYcaa4YMOLOGFCcYaORCNd2dMznV8ix?=
 =?us-ascii?Q?YmwfoqCrz8xLLmw1PAjLk73SyffE0PJFfNlG79BenqBnRpGLZ2Z+3hP4b+SX?=
 =?us-ascii?Q?aUJhuIu5Q9mbNxLlZ6rRsuMnTplsc+ZX1VQxmKztcwJSwB7rg4fkkzLdgkIQ?=
 =?us-ascii?Q?psuZXVBF5BdaNu1uRrd2+RhZkX40r6seO5woV/+oaOZQKLZ6qa0ymA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0BdPZS/4rBRcWxcaW36QIILRYOm3RSUdsF3w7bqP+3HnkxT/4qq5n783VBRF?=
 =?us-ascii?Q?kxC7UUU+aar0d3EWATYGGDS0xnee1FOqW7RgenIUAcgJS0tI+qWMifT5J1ab?=
 =?us-ascii?Q?Y4qzrSQnLvUPRYsQQZ/kwEcNwmxphdjd8gnBzJM5BsEMYqgGTkOAQEJ+OqtL?=
 =?us-ascii?Q?IvajfBw/7sUdIxGVKUtWgkUtU/HjFVWRTySmNrVVRrehwuOMZbva2NTMUXmk?=
 =?us-ascii?Q?KWpqAvyND5ZSNT4uiawTIU80Dboz91cuw4Etrn8+uSAo4aoXX4XjsVYrXwSZ?=
 =?us-ascii?Q?hnxNNgWSIaa5Mw+lL5E/78BgDftACxbrCKlIytKBk+HryzW79WA1Lt78i+Ve?=
 =?us-ascii?Q?wPjZIyGLvaon8JlmCK3d1lD7okEVf1p5BWhZ1lLPVrGC3Wnic6+11GNPdk0D?=
 =?us-ascii?Q?ArcgiMwDnDkYkncDaYkM5nqziFfZ5xOMTH+g97wpkjEjCERrcb7frS8PGKli?=
 =?us-ascii?Q?PIzoD8zUZip4aqLxEvjNowvaa7gIZoU/HlT4m2AN7Xs1ETUyW1XlLORIZtKy?=
 =?us-ascii?Q?C6pwFqRW/0Nrg/oppYbBSSAQ9yGr/O48fuP0JZZYuH1mrHIwE8R5fmxfosA4?=
 =?us-ascii?Q?KTNzA5JjZrmOVgMDfT6ct1Olcc/Qf6iJ76qenegnBK5pdQIs7Y0DVbHDj9Pq?=
 =?us-ascii?Q?ZNLgxgzthadqgBTrDIaJrXLy8eCxxoLu3B2fy5KDN+J8e8huaNbYvC8mPk4P?=
 =?us-ascii?Q?3XUhCp+COf5CWojJh8SrXSHo5QhNYVUZpPQ22yEyuPHi7SfrMIHRZrXeGpjj?=
 =?us-ascii?Q?aTNqYGY20P6OhJTK+KO55UDHmbnMSCSG16Hz2qr6Jg4r5SbgXxMirA/lUJDW?=
 =?us-ascii?Q?A8TZ9Ew1ih1UhbC9c4G0DcVXFO/IQh7L93jcp8NJW2x6KgrY3TFDC9/tvv2d?=
 =?us-ascii?Q?e1HY+gWAc8G79h2K3nUTKhTSEH+eNGD3RRLGNKds5kF/Mc709Wd/UqlIzk58?=
 =?us-ascii?Q?tj9WqtWgNCKksCnRvJOcQg1exRwW/+WPlw9rap/Jr+jrGjKZA+RjB9PweZAQ?=
 =?us-ascii?Q?/RvVt7oALhP6nw677ZWSf9+5ip4XOJzrdTzc/xkrXBGvy//wl7oewvXx6QGs?=
 =?us-ascii?Q?xbDCjSFvVavUrlYw69w5VI80WTcEI5Q+zgRbnpnQUPiIeaMusnO9eG4AEHoF?=
 =?us-ascii?Q?A8NOLFhYd8mGgTPQFvldxqiQBzTxPaRi/QLjbOBCM0AIvI85bPH3i1jNv/S3?=
 =?us-ascii?Q?J08pDVOFmMkSe5jVSR4JuXTtCfUtr6IjFzBEZbs940m2LiVl3M34p5wrTc0h?=
 =?us-ascii?Q?M0RJQlytTbSGNjQLikAZbVgRMOMc5rAvfJVCLsWqwqVzlsef5W5BhsYCsLiw?=
 =?us-ascii?Q?46Or6dx/MctKA4HCOgAwnaC4c5JZqJ/bop6ym0Zz3DKpGiwjFEX2Ip2+5glO?=
 =?us-ascii?Q?QVopq1E0MSpYPDf273Ed4XUAAjj9/v6nb5AX0PUW9D6c98jL8nudLP5wVAki?=
 =?us-ascii?Q?7t2Eb1APWZ9pf8BtF85EMqu/5Tz87eFV7+InXoORbCEXdXco3ioQ0kqYbFxM?=
 =?us-ascii?Q?pYERER+47TXNFC+v+bI6bxnpWrKS95rZhSI/BoN9Mo5AH6oCK65jjvKgheIE?=
 =?us-ascii?Q?3zs4Dw+rkFNYMjt/7Z5z7HDgNgseI3hMED8rxF05?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37ef3ca-7127-4ddd-afd3-08de2898b6af
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 00:55:49.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mScjLpRrKUexECZG6CQvJU2QdDZi8mo9fTM3oMzeRi7Khr/Sc4K1/U+lw5gkc5MK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF12253E83C
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C93D240008
X-Stat-Signature: s8kerizaerdswih8ukpdxfura16z3q51
X-Rspam-User: 
X-HE-Tag: 1763686553-368234
X-HE-Meta: U2FsdGVkX1/C3xndJbLMZxCGlxCCdCabWqGJoU2ZWZNYrYtFnY32zaEyZLbBafdgSPaBMcWpUPcT0Q06suylQ36H6lWE2tkPtnQr4jVcnIralzoymrAy7gkGpmsS7TLvrEdAsnOnKbI5IhS5p+d1Kr1tTLSaIHD5KasZrjFZg7YYPFP+QIgh7vMWy4Y1JF6BMNTidOpwgfWGHkA8XwiXv62zRPr/zDVH5sV9yljwFu1h7+FXIQpoBDogPYR6XtQxpzXlHGpXvdAXTiRZMYB4HI9jCm7UG/3W67z3y/xf1Wno0Hh4TZk47V3MJIOI9s27PmPpd6pTPRTMvot7QEUzjfvegh6buj6088u6IXlsDuM+M70mzTSfQlAq+TvW0Ho+8uuqHFtAwDg0niep+oJZ5Z5D3pPvuoiUTj8S61mcASHYN8nkpBgUeGT15MfYkeDNZnI9GYbMsLYLnJs0uo20v7tVSIHaMljAsKxEeAVeeN4e+Jh9G1KgJv5bI/2pHNVUQVd1jZzN/kY+Ir3V3Dxm1WSUqaGx+dMBBPLY3nPZERyc9KImB16q3azjC7Uy23vQe+YjcSQ4lCW6/OvGBNDWIb+9gpskOqvZO9Nbk68l+KMfLaO7NqaLW6TgAEAs+u1ptZA0TyFAkOD1a+NyuVwAWRA3fQ6R3RnpQyc+gWp6FngDCPWM9/ZHFkiuI3i8sGDMY0zo8djQ198iATgJfyBzr0dqsk/zj0qG1IOsMB2KsmibLIDMCVAMNQxnmuORVq0T0FT0E5bXWGs4rSNsDib347sFB1allF1i0UwRXnfVGGF9jEEre2Wsp/5+DRswRtRquFum+JVE55MGfyTbcFSW/lXHG91wF4Ozd5DhTDWUvZRX/UcJPfkZk+d+J3eR5ov1iQxjYbqFgfJmZioiFSLfb/oh4I1l73rWTOvZSApxGrfckZuMKRV08AWn8qnO5oPFiDRu9GN1n1D6LxmPGU+
 abhJL+fU
 Tsu71I3sXPRPb5N5TmpLoyaUrP0vhZT2J8WHIO0ntoxlIJ16XtA0ighbxELBBZZJQfrIolydqundEAuLYcisOweW9ONunFKqlUxKaz0793dxrScRSw66SAfcSjlZtkwqvaFXcKy/d9MW3arnHowZdPENOvCXZuTvDUD3pnscfmC8qts8lBryxyFZbOuAbA+jX2SRG9eS/eMCNN5oZ+xLbYmRk4PyYQGl5cvziwBjTEMDszVOEHNJF/bEjfvyvSJoEM6zA8qIdNZK7FpyrYdH5Lg2i4XMkZx5tnyrs+8fWbURjTs4s+yINQUOqgMEV/sORFjV6hg7IPgOzqTEa+jdE4eo/sEosIdhanKOZ1xTJn+3Anq5QgNAa3BwCMGFAaAxArxMdMRnNCLe8COP5TE9Oj6WUWb9Ng4kyOJiU7xxO2ib2oNCnnZSsDk83dh8S85l1tYrmoauo3r/ToqHuf5AfNXVxUNQ8t/LMTJfh48PaTtv6ZPj387halbik4x/ETqByIAdJV1rbKA3fLYSdDJOStqN4HIXpp664T6g0j9EIUZiiLeE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Nov 2025, at 16:16, Andrew Morton wrote:

> On Wed, 19 Nov 2025 00:52:48 +0000 Wei Yang <richard.weiyang@gmail.com>=
 wrote:
>
>>>> Hi Andrew,
>>>>
>>>> This patch does not fix the NULL dereferencing issue yet. Wei is goi=
ng to
>>>> 1. send a patch to fix the bug on top of mm-stable,
>>>> 2. resend this patchset on top of the fix in 1.
>>>>
>>>> This might be easier for back porting the fix. Maybe you can drop th=
is series
>>>> for now.
>>>>
>>>> Wei, do you agree?
>>>
>>> Dropping this series messes up later patches.  I could of course redo=

>>> things but would prefer a fixed up version of this patchset asap, ple=
ase.
>>
>> Ok, i will prepare a fixed on top of this.
>
> Did this happen?
>
> I remain unclear on the status of this small series.  Issues which I
> have flagged are:
>
> https://lkml.kernel.org/r/20251118021047.uyldr7aay6fb5evt@master
> https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.c=
om
> https://lkml.kernel.org/r/20251117012239.lqm33uu4vl4y5zqc@master
> https://lkml.kernel.org/r/337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.c=
om
>
> and a couple of comments from yourself indicating that updates are
> required.
>
> Have all these things now been addressed?

The fix is: https://lore.kernel.org/all/20251119235302.24773-1-richard.we=
iyang@gmail.com/.

It seems that you already picked it up.

Best Regards,
Yan, Zi

