Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96731CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 17:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EC88E0023; Fri, 10 Oct 2025 13:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F283C8E000C; Fri, 10 Oct 2025 13:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E174B8E0023; Fri, 10 Oct 2025 13:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD6FC8E000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:39:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 777C51DFF21
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:39:46 +0000 (UTC)
X-FDA: 83982917172.06.4D8FC01
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010017.outbound.protection.outlook.com [52.101.56.17])
	by imf03.hostedemail.com (Postfix) with ESMTP id D031920008
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:39:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="B9E5wSZ/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760117983; a=rsa-sha256;
	cv=pass;
	b=5eRqMM5Nhp4S/6112LlZ15ORLoGwsG5a8Rhp5q8DZpJcJO9ub3qztQ//trGUtn5vfUlprG
	84lRxq7EuMnKCl4d9W0oJwlF8oSQvStykHbkBQ9UcswiYPyjCGgdynW1P5k7l8K6X2HJGG
	JyU2qh3u9CV4bf+z0F1jJhl6ihYvOH4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="B9E5wSZ/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760117983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bp+DY9o0PWWAazvUuBDyI+wCnAmOSV0KKIy1nGpsGrA=;
	b=7b15bPvt/HDkFchddZiKZyuJuMGJF5wWTgZaHCy5h3ggfrX6YVtX49uIdxH2KPqeqUboYu
	qdQnamFTCEmGOMLY9FFwyhn5BHV2uBqKhzeFN744WEDA9mwRxnDawpmuDPzVowADme5k/p
	AWjYMY/lfL5jl4N58Y+vUkzARGqTElA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pM12aG5lYxZE0Unn6dFQlCGxN65vZh0jr4VHc/ClttiFzXid6zsQnxYEstYLx5pNG2phIv5GjgfLJtS2V8w+y1HiDYUMhGt3HcCJlDzfDoY//pJp4G8uSxJey3Ho/AokRFNI65Jr9/hw58a+aSB2vbAz0BfqgvqUXgUreuxU4PlkMN7CGz/G8C7RsnT2nLFIHuwl8KDqv/0/8AWg9JsT51F0GWy95fqwCV2HlJ7OmIuEBdwkIA64kCEGTvLpoyH/Lg0rN7NSEGKctVVBdCmsmYksSwQx7YGIBRIV3lqPTRBJkgelKS6Y46hPBtetX0NskwXbyDKn4VwqsxPo9aGqbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bp+DY9o0PWWAazvUuBDyI+wCnAmOSV0KKIy1nGpsGrA=;
 b=OyYDbqT0zbB/pMUbv6apu2g+lm8jjBR5BxlLd5iGtFhxO/hmyg16tpSsff77Rqg9uTWJ2H5OszSOCwqI8AxOXanXbnPT4TGxUqevhUdQA0EPp2lt6wLBPTB2MKM5jIE2OvmPxD49iqiHC67Rm4/J4sLfQkRTx1CI9Yp9Hy9UkjiJMo1joXBtaZj0ACsXUjokvcMQ0QIHzd20aD3U6cWscLY0k5khWHnT5q6x74wGtWv2ccQpnILT0tSyN8EJYuLzz3fi2c9i1gslOAHJyYDi+BtmQ6nO0lfoRi8RiI+GQLwHD/L7SIZs4+W78n1Z0CyigrtHb+HWzEM/Ag53nfp5ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bp+DY9o0PWWAazvUuBDyI+wCnAmOSV0KKIy1nGpsGrA=;
 b=B9E5wSZ/s1ojMJP6DRGWXeq3XhAX2FMtUE0qqEZ55C8AXcdRtL9mvy4npA8anh9CMDqMq7RDs9hQFUSH4aB1HauzeaAykvCG50bxdGPN88igUaD9FMomkCAM477FeyKxggVENnce0OPk9tZ4C+XPMo32dD5PP3BKJePxg3l2hODIlxRnp7KDjsJF/pYxd63iueZcfbsgXlq8aaOaEjha5Y1uLUAxDxJqpERtVVBYe9CXaQ7iCfXcAcnIKwiL12d8rt2kQn8SyWbzAJZBHB1dm6Iij8PJL1s73t03wUHNDDuT7Ul04uyTt2WrBJCWUwKWBZXSXHgvF0x582sL0UFDFQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8222.namprd12.prod.outlook.com (2603:10b6:208:3f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 17:39:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 17:39:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com,
	kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Cc: ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/memory-failure: improve large block size folio handling.
Date: Fri, 10 Oct 2025 13:39:06 -0400
Message-ID: <20251010173906.3128789-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010173906.3128789-1-ziy@nvidia.com>
References: <20251010173906.3128789-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:408:143::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: c36c46fc-1f02-4bd5-0b43-08de0823f794
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W3WCFFsqd8Td4+TGag6+99pA+5img/t/B32eMf4hPIoKdNQMbQx4w66l/KD3?=
 =?us-ascii?Q?cnBaGxtltTN2WP/GMQ5afiWJx2xzhAGariRv6476F7WYyY471Nwe6k+DFx30?=
 =?us-ascii?Q?JyLEYpgcZgRs8v7mcLgFEUy0bSloK1eMmcU44E5i/X0K98nUENWBuKKPM2F5?=
 =?us-ascii?Q?m5YMAUjUDHL5oVvWUUcjdP8Ds6LG6iFecKj0CuR6eiaRIxB6S51P0awWq2uV?=
 =?us-ascii?Q?RWGzwzuxh6W57gkhEh0PqBYuFtwdQXFFdzA6BabacHruwn4UC2yw+gusGafp?=
 =?us-ascii?Q?8BaejyaSHSynL7bnNokpjQiWbtAQFNUpsGFlrXCPpOTUyYdENt7sJ+Lsl/lJ?=
 =?us-ascii?Q?4ZojINjN4L5n7ceCDqVH4orEAPtATRDk+3Fy6FgTQnVFMuvY0auqdk5znD0G?=
 =?us-ascii?Q?utr8WlRJVI/fTzuqi/BzpzP4q9Sk9kGOHODd9R8PlSG+Pha42EE/0uNhiAV1?=
 =?us-ascii?Q?o8bOVFo13Fo/sFtMAaBeCKU5kdsGR1LothaJ/erOhVNYc1dlulfXvXfHt2y7?=
 =?us-ascii?Q?uoQh1D79OIdLIpAoCYI1KAgWJmirOSrw3n/FeG4HNJalMn0CNCciHSDPBaIJ?=
 =?us-ascii?Q?z2Im88qWM/v2Km6TPupQz8NS6P/JQuvhQUWDdtL405mjO6W17GDyjUWyTzkd?=
 =?us-ascii?Q?d0J2C3DDWnFP4HtEgE15tzIOJlnbhQPj8b0VXw+dzLiSIHI/nLtp/2sh8ck1?=
 =?us-ascii?Q?cenBTcRglyZCZvZPTETR7ntxP1tI63Yu0L8VhrL99Y/IFGh/291RWP3SvsCu?=
 =?us-ascii?Q?/XBRqdDMENvIOD8nniMRDo432XSiN+eoN3dnzojMsKJ6y2BTXOOdYEQfM2ti?=
 =?us-ascii?Q?Kk6E2WqSoTwP04orOdq1pfgoqmB5NrSdl7SOyQFv2WowJoo2I6LkiFN+ym7K?=
 =?us-ascii?Q?8lHQQEnxDnt6na0e7EExRohYs1xxoPJeE9SAiP6/LvkipxlWNo0Xp32LJPNI?=
 =?us-ascii?Q?BDhqNVE9FKHVb9ZXHalM0iTNa8k1urGH64kN9eQuQKVSXQHhvKKt2rp5KisE?=
 =?us-ascii?Q?RFrrLO4jS36aNcGXWVp9K4dGnDnYth2e/h0m+F79XD0+NcfyudA7N6zEWiUq?=
 =?us-ascii?Q?uY+1mZ1Nax/+7+MrK7y7oGs2TzoyqfbSruWTQc20MKsPRVbItLK6W1lMhV6i?=
 =?us-ascii?Q?zy3VkVbtoIksC5EfahhvJOY+87AC7XQjLq9lM0ohMT3jhnI4aOzU/E5B7U53?=
 =?us-ascii?Q?iIpkj+5A9n/k1TxCyvpyGMgLtDJhKGziluvpNVnzVHDQzAvKiQPZ9Uqrf13I?=
 =?us-ascii?Q?I4vuaYdEjiWSwyKQSrkNs0A1O241pg+NZ6NNA+B3We88oSFGiUHhtPNKp5qc?=
 =?us-ascii?Q?N/HQjDcqxDGrc/Q/MY1Tgi46ahHELhS2qe61oGa4/fuIdvqb/e9+ComtRxIl?=
 =?us-ascii?Q?WHfQNPFg9K5q//HyxGrhWFcgRhDpyptMQEyFq62jB7u/0i7T1vgoBgohgjSo?=
 =?us-ascii?Q?CkL1gh0rkl3Qxj20+HfalJQMTJnsLAyz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A1Js5sfAaovoJed7sbAkrixzztegpybZK/QOSOrClRIk+CO6IMwhM8g+59Vk?=
 =?us-ascii?Q?ZYE2M0UQGykIKM+aFD4qs7VV2XYTNyiZRMI/lEmbV6/zJn5mAKkGwUyj8DP7?=
 =?us-ascii?Q?ugUFxtUHGgALYVunrRlvec2rX7dZWYVKfBtZ+ZQckcI7RTw2EgavNs/n0k1+?=
 =?us-ascii?Q?OrghhzfgQV9Ee3H4tt163yCwbQHLTyC8RREm3v4DQpxvs7W9/00i6iLhsRja?=
 =?us-ascii?Q?dgI9HRdwnwzEYcGBc2SPnlQ6EK+5EnOG7mY5Ou1oiJQA6ztudJSdfoL8M0pV?=
 =?us-ascii?Q?PbciZ52wKKL6UZUN2dzuav4MPD/c9E1yxvDE4lr1E8QSkUej9YVsXGg4DQbG?=
 =?us-ascii?Q?1nEVH7N/uPBf2uXe2jPQfvQpBKCjlE0ZUZYybiNofy/2MdDVVFtI//PKnmvo?=
 =?us-ascii?Q?avYOI9QMfCpRWtO8CC1YDizblzhnHkiW63aESNHcDVCrodzHzqk2MnrqzGGQ?=
 =?us-ascii?Q?bdIHW1mj8flol/v1vE1M143iJRBiTXcSAiCl18BTvdulDn4v47kCbytJDFD1?=
 =?us-ascii?Q?ME/WQHxKt7EksYsW1xwPKGc4ToL2K2vSpWMGp3YBroU47uCCzjNYn4u52twP?=
 =?us-ascii?Q?rCdpeCDB0s7NUx5Sq2v4GTBFPRCtx+tGCrSYz1aOKfyshW/J5h6QS3LblgZx?=
 =?us-ascii?Q?VYJAO6cyvdoWqqTo9nZ4D6umxGQosnmPdQvA1FAAv/iXjCCvHaA3Ex/SvRly?=
 =?us-ascii?Q?YNShxLMtEiG7UTBOOR+v7eZrlPNab1uyN13QelJLzCWe/S8ZzPIrZU99ysKS?=
 =?us-ascii?Q?saWGHBQsKQxV9TFqSZJIjZb5JfY+ECmprA0uASBb8yozezALUhgnjL+L+UxC?=
 =?us-ascii?Q?MOcbXwLhyZRSyUvysQkGj1iIBuxjKBQdxmjEzzy+nC5TrWSghY1oaVmmcLrO?=
 =?us-ascii?Q?iwX9AUxvULzalPNUdINUL4WEwBKQIeSS3oUwH78SnboV1jFC3yQXkm2rRwcN?=
 =?us-ascii?Q?EShaTa2TdTqTBjW+wZ1JZ8/1IOjDr3om9HxsDHzAjOPdeSTK6GceeuLsjFer?=
 =?us-ascii?Q?ZVrZvAPd/QASoxj+enbwxdv0uJ5eM20zd62GcpEi9pdu6izFG+vGog0784uq?=
 =?us-ascii?Q?9fwkvnL7CjRXYjdvhPycL40o1m9DGY+25e5OLdEHY7vyNu00sMWsRD/n2Qra?=
 =?us-ascii?Q?yqjjBKpYdttjLimxRkqhUxm8jPK668GuMvwDfofHFYbgxOC5DKue9iIMBdH3?=
 =?us-ascii?Q?YHaEH/cGkepxz29v1cV80tL8EvwYGREjro0b4P45dZoF/FSp6s5MVvgApOCr?=
 =?us-ascii?Q?MmDSiIeneKFdVnoIGpi7FbDxE/r5o5sNgS/EolZgCtcb5pMFe21pqZvQT5sI?=
 =?us-ascii?Q?ufxiUQV+2myYh2EFE4kyXGsjX89HM5hpMS6RopiJt4GrCCqdXfcxwcsKSHE7?=
 =?us-ascii?Q?wd7SiAuzGkxN9IytPVoqe4YzTDnKXB8LKtu7MJVHuTZ7FGP+4TPb5dLNUAhn?=
 =?us-ascii?Q?XmhwGhHgAhjFewFCJuw0jMPApM/Q465MwxWhY6ljyXtbGzbnINdPPRIV7Ips?=
 =?us-ascii?Q?JgXLxbJPSvSgXAi38XfhuN78F/gjMEU1UMmjgvfjBTpeyRIf6WoWdP+ni/bV?=
 =?us-ascii?Q?GX0P+5Abt8UqrPpyCelo9WUr5T6sBqOHxdZCQ9yT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c36c46fc-1f02-4bd5-0b43-08de0823f794
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 17:39:30.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEXuGxnL5fFhkpfPtPowuG51gNZNT5qPewucPCG7npO9FI2djddS5ZAdAYq5nimE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8222
X-Stat-Signature: i7gg839zq791y4zir83py5guauqfjma3
X-Rspamd-Queue-Id: D031920008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760117983-373557
X-HE-Meta: U2FsdGVkX1+6dAmyySXZHA1aZ4YjQlszOhjPVgB3zF31OzuTT4SXY2wr3W1DNe1vy62ohOkgv2SNZwcJA04qpzCQ8yX3F/b6MOnEviBk/JNcZQKeIgPhFexgwWngnCChv+3gkb6oTe9FwNTHIkmXdV1hrALuZCYI9oesSMol4+3nBTpSfhXH+3LDycFn2aO3RNJmbflgDhWpGDlyQWTCtnvxQX9A3LMCnIAcb3ol1EcRrG5N1qEPORgHkog8whDoVFwx8An7G0Wxr1laOk+FsoEL7TvAr1/FSoiQ/RrtRdnfwyOF/xuX7l5VU8nTFmkl2R7Eumv9UBYOqW3lW/8bgXR4JCjr25oFARqn8jtlnlLahmikaLw4i2G3fe/dbeMfKHkce22Bxsjpgtm//4XNq3dEn4ln5L21ggwkDB2iBhqITaY/UAly5kONxmdyPe61rYAv6g27wy5vKgrcO3X2FbgBCfobASpedCjP+4pwXcjUdnoaHJ6oKOS4oSqerVCNrzzCv325kbKyU9NA+kHYFBJViUilxl0kitbbS1pC5FuHsmnM+nnLOpI9IheUnxUGA4sAkcjQ4FWEt64sya5qWHVo/tVs6F1HFnYcMGjV1OUz4LK8rmT33JKBTu6djmr5Y4ZXNKJ4DJ5FDvaV5Z6KH5OtwfblSCujR/qd1XtwXWj7lOYmNzTK+MwvOannc/9M19k06+J/CPvDCY3X58h8JXVwlK+mFq/S3wu2ZwyQP+tptmrXnM/tU7kzsSGhVWKgChfj2c6e8y+Qd71TKXHCfojpZ7SW8wZrL8LtjJsr5R/rCovvCFVLeIrUcJEcf3/SmshvGH5fY7pBg76k1OHk89/9WrsHWBV/DfWZVRfKC+hcHz2dM8IfAFVeeXrUhnbo5Z2bNgWl0cmXPk/RkTzrNpUoDsVSOUMCE8xFUYqrTqiFpqH2Hg3bmlWq9HuK7kV8r2/pCXC/6PWww3Erx0n
 eNZhtcuz
 bth8utRg62rlG/QQnS5CEd3/B6HIOtNeMxs/wiPce/m7DulKbrbvFgg4yCwu3/gzUI9fb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large block size (LBS) folios cannot be split to order-0 folios but
min_order_for_folio(). Current split fails directly, but that is not
optimal. Split the folio to min_order_for_folio(), so that, after split,
only the folio containing the poisoned page becomes unusable instead.

For soft offline, do not split the large folio if it cannot be split to
order-0. Since the folio is still accessible from userspace and premature
split might lead to potential performance loss.

Suggested-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/memory-failure.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f698df156bf8..443df9581c24 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
  * there is still more to do, hence the page refcount we took earlier
  * is still needed.
  */
-static int try_to_split_thp_page(struct page *page, bool release)
+static int try_to_split_thp_page(struct page *page, unsigned int new_order,
+		bool release)
 {
 	int ret;
 
 	lock_page(page);
-	ret = split_huge_page(page);
+	ret = split_huge_page_to_list_to_order(page, NULL, new_order);
 	unlock_page(page);
 
 	if (ret && release)
@@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int flags)
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
+		int new_order = min_order_for_split(folio);
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int flags)
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		if (try_to_split_thp_page(p, false) < 0) {
+		/*
+		 * If the folio cannot be split to order-0, kill the process,
+		 * but split the folio anyway to minimize the amount of unusable
+		 * pages.
+		 */
+		if (try_to_split_thp_page(p, new_order, false) || new_order) {
+			/* get folio again in case the original one is split */
+			folio = page_folio(p);
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);
@@ -2621,7 +2630,15 @@ static int soft_offline_in_use_page(struct page *page)
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		if (try_to_split_thp_page(page, true)) {
+		int new_order = min_order_for_split(folio);
+
+		/*
+		 * If the folio cannot be split to order-0, do not split it at
+		 * all to retain the still accessible large folio.
+		 * NOTE: if getting free memory is perferred, split it like it
+		 * is done in memory_failure().
+		 */
+		if (new_order || try_to_split_thp_page(page, new_order, true)) {
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
-- 
2.51.0


