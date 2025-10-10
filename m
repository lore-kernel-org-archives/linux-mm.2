Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4656CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 17:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0BF8E0038; Fri, 10 Oct 2025 13:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7CD8E000C; Fri, 10 Oct 2025 13:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197538E0038; Fri, 10 Oct 2025 13:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04B5D8E000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:41:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0F9011A0BB
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:41:00 +0000 (UTC)
X-FDA: 83982920280.27.1A2157A
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013066.outbound.protection.outlook.com [40.93.196.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id CAE71140005
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:40:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tHUOkHj0;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760118057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuMOnKJfatV8miB8iAdomc1r1JNtjAMVcGoydYbpwOI=;
	b=iIup0gaBGZe3YmrY9HWVkk+RGpmMV/sRcewbzWe4IiTt9junV7tuyjA+69ZvTvn8a0Cgya
	UQlnvp2yvCNqS5z1NccBQrAf//yaxF7aZsBn0tUFhcqy3iRj/M8fq9H9VHP0RavkUdk46j
	BQJ5TIIua/iDdKhSaiM6N8JUxk1Cfqg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tHUOkHj0;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760118057; a=rsa-sha256;
	cv=pass;
	b=LBufI3Bnl52xOP49PIi12uEyAVRRoGt8tteCIgciJ8xBm8GPSA/2mUOaRDuo7f7mw52g4/
	NpjkD1JebUxmVI8daxym4j1ZjT0AXPEJzQ0n//PQo5Ziq8knIubCVPD6PcscDPxYLhmBs3
	L8sxWDvveKttzHpZ2pKrvkQtRbLOU+Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1tVzqqv0fmKfDk/7QDFPH+XejL5IUSivAnHpeh1tK1d0V69m1xNHRC1d4oEBz+1UE/89qhgnwuZLsBGo7aCoQkuWGEN1gkuYJC5qe4704ru9yvOj2soK3761L7qYwhZpEswIa0xHrRxU5hGineZMxreFdett19ig9UzDq5v729U/GPxgK/oU6Z/auQTN2jSfaLvBd6qa4ne4BPeLUXQNgXeUV42LjVQQ8dFUY709LYekn7jS/Ji6h9+WXHGSWNRO2gtP0YmVLVEnS29GFYbfsxL+B74oON/ku8jdcNJ5g4YEVNZYy36dR6+1s9cSwgkh9mfCqxVBsEj0JsmwZA+Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuMOnKJfatV8miB8iAdomc1r1JNtjAMVcGoydYbpwOI=;
 b=LoL6vSAhPoAQZlX2+DkyeSGK3P/PDL/9Y1abYpHMYeqf8GmNM2k+njcsK7bxcqQmEnfWO0U43IVlYbuCrxxPcxBoTe0pN6wT9jUjoeeYtp08icQLmvDFXVzDNvyljGmC5N9j7r2u9C+WYN2jDNWkuLA/z7gPekdNiuiYmhW3tJjgU96qiLLdsaho00KMsAYAsvQkh6XlCoGcwve3sBPo3hf4j5diFMejIoV2OMO/A0yT+Zsquwq0z9QpqwuaMXJqzanJR3vmwoev6Wpqc0VgWYhS8v8hQ0AejI1haZxGzB4B+lVbe+y0LCc7J9R85BIENoK2k/jJ54PQSeu36ynzdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuMOnKJfatV8miB8iAdomc1r1JNtjAMVcGoydYbpwOI=;
 b=tHUOkHj0aXPd4a6XtHF+V+BGc9ASfTKSTMktpuCUg00fsXGb+UTh7m0Y0TdL1zABYTuLy0Lu1RhmnBicT56zk8Em89dXFopJFBqv4pqmP2+8F2UzBnC5ILVgE4WI94zIxtk9Ap2CtD5jdZJy7cJkHknhogL+UZeeBICbIwdHN1M26LIalhtpnOxxyvN4F0NLxvWKPO/bK20zIUYXrqq1yXSulp/HV/oDM9U9/WsaJnabHdbQjqgP/dx4hMpRGztml1a++AEWknNDSjeLvCsonRU3Uiv1w366r0nR5fjSFeJc1lA+ZzO/eOQvEfjbQMxMhd8WeUb28myoYAyvL6swRQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8222.namprd12.prod.outlook.com (2603:10b6:208:3f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 17:39:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 17:39:28 +0000
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
Subject: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*() target order silently.
Date: Fri, 10 Oct 2025 13:39:05 -0400
Message-ID: <20251010173906.3128789-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010173906.3128789-1-ziy@nvidia.com>
References: <20251010173906.3128789-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:408:143::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e403e99-b5ef-40ca-5e37-08de0823f683
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K30ZexJzoPPfqz+LClBnBnfYuPMlfW9uifwq5a9xo1Rlq+ZqICcZrChQkou7?=
 =?us-ascii?Q?e6OzXK0AuZgoKt3FfDPP/AgO3s3x9vv4baN7ZqmvQHSthmlC3iN1T2Rsnb8K?=
 =?us-ascii?Q?BIZDKxFCudklvJY4W2EV4BZHYR1l+JejxiZc3dA5zsnpCKGFJZ3HiNdQiAo+?=
 =?us-ascii?Q?SJ6mnmI8VPL7z2hEeZ3/Dko3gpJxSMXvA1Yy/MX0k9XN53HcxfQGx5xQqH4g?=
 =?us-ascii?Q?jBYUwTmdBhqjes4IwL54QJRV6up5U9699bwzbBfKJR2sju05StwNK+Fz/+gK?=
 =?us-ascii?Q?b1ww6PCreDAnF6Q/VC7DSU2qKrTUSqY593D1O+cPUSmdibAbHR3txz+tTH69?=
 =?us-ascii?Q?wfnnxEIWvxDv2Qtfzx2EBba+kUfLWscD3dMW01S/2BBpoNc7pnNyJ57JGGT3?=
 =?us-ascii?Q?xhWoY72AwUcZiw63bB8jgrwB06JDLiFeGpr51JEX+q3wl2pVVyIsOaLbfWWF?=
 =?us-ascii?Q?bpw8BsChyHdOO2wQ8qa5aSS3+sonPzPRUSiX7xbkfPYbr/+irC6jrnv6yk+a?=
 =?us-ascii?Q?yo0FYcdyMzStQs6SRl9KFLW+sXZsl/8FOXhtw5bJuY/QHHVGmSvXztZH5RAp?=
 =?us-ascii?Q?WXhySUpw+fIInM+/+xqmDDO16vzXjatNOqiVAWtBJEBJLa9yvKPHc5aAOFCl?=
 =?us-ascii?Q?6rr6wjPdjpC48tYLvMziCHAWncs2CYke2zvfralBmJzuq3gaHMqJ7Aj+ugyQ?=
 =?us-ascii?Q?efQxyE9/0FPjW60wB/SDYVOw8NvAevDBscpSXe1zjO86T2arZ9hKLW30jF5q?=
 =?us-ascii?Q?5D1H4y3HsvrcMKEs1tlqhpl/ZfVJWMNggyp4OFVx8Q18ZNY3wWKsdztJBw9U?=
 =?us-ascii?Q?m3e7Gcl6IpAW5QoS/Wczefy4bvdC3wCLZJ3KDoOp/eY7g2NPH4RIz+rYojIg?=
 =?us-ascii?Q?oZyn/Ibn1la/WlOPRS7BggVPszgjOYLiUU20grYpRMjgbsMSHj/vO7AYSG3q?=
 =?us-ascii?Q?SpoEWxisaZundwlmcE4avZZ+gE+KQ0/AgSgmK6LLwsM6I6Ai+FtG5Bap8y2B?=
 =?us-ascii?Q?/RLLDj7lhf86sUDoONu65kPchHL+ixuJxaMu6x9bq1tNtRyiaP122j7EMGY2?=
 =?us-ascii?Q?MA0JodeSQgfBEmgXy+ev+5HIXVn6t9ev3F0YuHhqn8KwY/OEnH1mmtwZ+UPi?=
 =?us-ascii?Q?7mTneiAvqQrwETpFRSrAghF/U/D9X+HcbC8UfoINBg0HgnbednsF26Fad2tE?=
 =?us-ascii?Q?C2VGHpm2slz7y5yHq3a6kPJ+O0nlCgJ3DkSTX1uhNnSqlFrfIRjk3jox3oX1?=
 =?us-ascii?Q?1/eHW+f7cVRmadVMk4V5rXIkBqQS77TYNLYorCXpwJqOMEIyNEGXxdroM6o8?=
 =?us-ascii?Q?pK5C+iwZjbw30zlUklwujEnf/VR06rzl4hCQHekiBZWQxNyijUzZ5xDqd+bD?=
 =?us-ascii?Q?mEsIPF4Cfr/7slAGD4/MuoB+Qy9Gvqsb8nHFq4n1OXAl+dsiozsYHTVeW30y?=
 =?us-ascii?Q?JEQWs/BJeDfCPL35Q1/gsKVx9Rtp34Q1xTQptjI/gRACR19Njn+Psg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6rD2FM5tca5yrtqqCxx5BjPbEPKKOEcUKxCersvvZPNxW7EXdzkVrlujfuXq?=
 =?us-ascii?Q?ZCx5IIBmUBtjhKyHl229RHqo9i3soPUGUw/0ywUdE5p7AH1XS0z5XjnIXB+7?=
 =?us-ascii?Q?MoaealBMm3PtR4f85CxgW1nvYdDd7Oj11fLC44KD+u2jp37KvyDXm7EHIN3h?=
 =?us-ascii?Q?BNjGkR2bPFG4QOj+n/mBvY3GtlIUTVP5wBjiigBQ/g/TTHD2EnY5UIznCdS9?=
 =?us-ascii?Q?6ukgz5QYvCmM4kJ8HuPu6MJ2xvBMeJVyHWoQB2d4vrzMyMPCCA+wqpNYhyEF?=
 =?us-ascii?Q?PoZtpmqw7XmqVoysoioYcsc92doKoouCNBBRLUmcg3TNcRbOi2lx6s10dlhL?=
 =?us-ascii?Q?5DtUjeEGKjTDdfCzcOqc+DXY3gjAirnYEYCJCM9THCMxV4h2AHhZOMeRBxTK?=
 =?us-ascii?Q?ajswocNPTo8xqD+BvPyslLPVrOBn6M5CizJaQshsQaItoJrHlIC4ccsN++fL?=
 =?us-ascii?Q?btzLqCC39qntp0HRkpalI/T+7McIqj3CBG/5e6e+1amL50nudDVNM4toZ8bc?=
 =?us-ascii?Q?3aj+D10RWwN728iD7kS8qBl1eYuMG927jyVmuyKXRE2cCFJobodgRwNCsPAT?=
 =?us-ascii?Q?dhxRUPYARFfOQmdtseEZ2VOV16XXYBmSZawm71p//aPkgvYe5MMf6d2fE65l?=
 =?us-ascii?Q?05oOorTGarRxh0Uf5F5G6EgmrXeITPYSPOkymv6w2ZbkmFuvVvXWvVn8zdzx?=
 =?us-ascii?Q?VzyhDbDhO/65NsODUQR2mPW6tj4WrmlnfvsYsEkbdVO349SMVmTkK+dfu1k1?=
 =?us-ascii?Q?xujH5eBMwgBJmwAcXKEKLckWEXZ1IfSW23lkMWdoEkrKqQvccdLxCSu8yKwL?=
 =?us-ascii?Q?g8cJmN2O//McFI0tYN8y0g3F/guVBgjkC5uaTWrsHMpNh2E0IvSHN1P8fAl2?=
 =?us-ascii?Q?XS0NuV+fRkBFUPwD/bK7VCRLA22bUJVSXzXk6I23HLL+PbeMVoY2V4dj8T2W?=
 =?us-ascii?Q?/64es1COKe6/dc2/xQ6bFQCP7jFdghs7U7EfehS2tEgiooL14XDYM3Kujgcb?=
 =?us-ascii?Q?9K5qMttZp4kn8dp6nvczPXQOMomAw5G/IAMmPM5WGxuOJRBC0UJybKfGFXbn?=
 =?us-ascii?Q?pNJTTkTopb6pWtfPPk9EmrC1+KClN/nrAQ+nrL2xYzp1sca7uyM45PXq1fOm?=
 =?us-ascii?Q?d2tAb0mRWfcEMVq30/pc0BZd2zJbC1vPPbHQ6lgy2Df9QfXAH92VCMfhoq8R?=
 =?us-ascii?Q?G1cgw18lspALmnzmApcZMh63IXSO7tlbYILiAteUVzJuhMuoXKsFNpEK9m0C?=
 =?us-ascii?Q?I8qCzaa+nt5L+vVHGJ0jabQsN/yOnD2NtuXwiOsiWs2Mad9ZsPUaOll+t6rp?=
 =?us-ascii?Q?7wrTeThhHTGMmJhzWVRC8elHYZkbjna56DjC+5scRutpYIPeXloUcgSuvxR/?=
 =?us-ascii?Q?sGZdenD6ZrXnRxWF+Gje5u5SSNcT5y9EmUXH4FDxzUGgixDpn7TIM1kskV1D?=
 =?us-ascii?Q?bfKTEDUAF/saROqACn5hEoIb1zMa0303/Bk/MVcx7IWeyuphScBaZXFrjic0?=
 =?us-ascii?Q?ZGIqZBy/hD9Su++GbhUk2XzRBUGVOcpzJSv8WFsFI/rN9ObgvpZYigaDSDFE?=
 =?us-ascii?Q?vysy+3WTBkBZwq9/TsHopXnWQCNIo+a1BT0cs6P0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e403e99-b5ef-40ca-5e37-08de0823f683
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 17:39:28.7152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VhU8GyK23yeQxZ5Pn5ieisQykbvirmbxQSeV4auxAseiwRkry5zoGz8w9h3goMiF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8222
X-Stat-Signature: wufk5h9a4tksrchkdz96okogwaam5mih
X-Rspamd-Queue-Id: CAE71140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760118057-510048
X-HE-Meta: U2FsdGVkX1+BRd6dybfv6O04WjXYNFEozDoOoXBqatZ9NPZ7MI0g4xRjn/vdg/B9NQ0Xz9u8xSEHMw9jaCvUogiQF7/LpnvpRJNCTK+BRT35PRIE6Xys5u5MaaV3FBUtlNVYrvnQua6X0zYyWgvOjR4y6CpBNwyXra73e3DnLFek5Rwzx2RXtmd/aOZY0Zb4wo7u8yO2MQBKZWBiotlz0h8Im8CqLpb3L093fIpfUDFb0Ma1FuW5krCyDXYfpMyErIfz8ILKqvkYDuigG3R0rQu9V9nE9tNO4r6nc4g5G7V5jVc+TcM2dIUdjhurYyGoxBFpOPW1Atp7kt0x9weUPs/POabn/Tr2NdkwTTCkGFNVupPT7VfWVqqS2C+1A4TjAXlS2v0bzdrdP0CnD7LQqPxmYN9y42CWPh/cMwepvAtO6ppnb9YhHsx27tYnlOjNTyBm2p0h6DY7u/x+vOoCdk43u2oZlJv2ICyCLv8ZKQFxIarrcWcZ+p51IdZwA1a+rJtVI9iE7bM8sjQfzah+kyxl+fMFl2TRBLiMDbKxMI675RB/2gGhucj1cdlCm3p4zs+QXkVq/BV3+yNaF63PNeR6RSFeXWT1s/YeqbB5F1sP/PCgCLIYVzVI5z8GWYI1Q7tAXDS3/9t0UXqdjOhxp5xNnIRsRAdQOHqLrcVgvuWSu2MLLgGH5Un87/dujaJQowt3m9N5gzfWCCkaGviWkAV8rbOuJGKLDH/PGWzUauXeWe9BGAbW5YoJ0LQfTso/JTcAy8fj2gOznFS9mycAdlZvUPEv225Xl5VnqAwRztC+0hG2dKunJAk8X09QK1HZUpCyepbbPLbqvGUsPY8be1WmACsRU4LB6HMzvyi/mkJDN5tWJdkDSyBSOFpcf47Bg6K55qjWPHNEhHcNfVyWZOU/3GQevfNnC6L9dXCaC1kq7wFaqLbK0ZOeLSoOFDhInj/tKhmqj32quaLA1sr
 /WWHeV4v
 vNSknprZf+2g730bqtyt9/puc77zqT3C2/PENumsx257lUfVDxZOAI8hHeznGmmcHbSpcCVxAHZbHYo4bcmP1gTPHY6zfLsZZ4/gDPSFRwL60zkaeZYKB406YxseOABv4lKmfCIVKfjWqx93zINq6YZaO/L40XogZgD1u+5fm9KsQKeSSReqj9xpumoG5hYU6BGznGb10eHElfGIgcck2JJnLJBfAP7GfLFcE63mhFVSrClMUKJw5WxVmld7ymga6Bp+Ue5GYyEjAoKwYAdaZAAXolkQbKlJmUiUrKQ42ytpI0mvszasXoVFh3m/sW1WA3fEsV+JVQwNhp9VPaxybT2fube4ViB/JX4GtfnpUdOBzNb2amptueW0PrGnUZGH+oP1Dvem1SjmSZRYp/XUNEuL2nuIBshINUwSy8ch3c3tGVEeXHENYepUANaMScGRriF1XgNeU8VVBAGCmnrABMou17O8AwD5IaKTWOisstImfGCjcKVS0L+IU9YPm0GpM/z/hIgEAoqEU0h7MzAw9LnpvE6oVi5+DQgtkdiZwj8siAGagTlZzQSTxjYdUQZ7Mzd7gWp9Mx1k5W1n1SXnwvCkD1wcLbUEOISDEPgCasNlBfdSSYuurLb5omAvvH6W4Hq/s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page cache folios from a file system that support large block size (LBS)
can have minimal folio order greater than 0, thus a high order folio might
not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
folio in minimum folio order chunks") bumps the target order of
split_huge_page*() to the minimum allowed order when splitting a LBS folio.
This causes confusion for some split_huge_page*() callers like memory
failure handling code, since they expect after-split folios all have
order-0 when split succeeds but in really get min_order_for_split() order
folios.

Fix it by failing a split if the folio cannot be split to the target order.

Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
[The test poisons LBS folios, which cannot be split to order-0 folios, and
also tries to poison all memory. The non split LBS folios take more memory
than the test anticipated, leading to OOM. The patch fixed the kernel
warning and the test needs some change to avoid OOM.]
Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 28 +++++-----------------------
 mm/huge_memory.c        |  9 +--------
 mm/truncate.c           |  6 ++++--
 3 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8eec7a2a977b..9950cda1526a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -394,34 +394,16 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
  * Return: 0: split is successful, otherwise split failed.
  */
 static inline int try_folio_split(struct folio *folio, struct page *page,
-		struct list_head *list)
+		struct list_head *list, unsigned int order)
 {
-	int ret = min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	if (!non_uniform_split_supported(folio, 0, false))
+	if (!non_uniform_split_supported(folio, order, false))
 		return split_huge_page_to_list_to_order(&folio->page, list,
-				ret);
-	return folio_split(folio, ret, page, list);
+				order);
+	return folio_split(folio, order, page, list);
 }
 static inline int split_huge_page(struct page *page)
 {
-	struct folio *folio = page_folio(page);
-	int ret = min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	/*
-	 * split_huge_page() locks the page before splitting and
-	 * expects the same page that has been split to be locked when
-	 * returned. split_folio(page_folio(page)) cannot be used here
-	 * because it converts the page to folio and passes the head
-	 * page to be split.
-	 */
-	return split_huge_page_to_list_to_order(page, NULL, ret);
+	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0fb4af604657..af06ee6d2206 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3829,8 +3829,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		min_order = mapping_min_folio_order(folio->mapping);
 		if (new_order < min_order) {
-			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
-				     min_order);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -4173,12 +4171,7 @@ int min_order_for_split(struct folio *folio)
 
 int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	int ret = min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	return split_huge_page_to_list_to_order(&folio->page, list, ret);
+	return split_huge_page_to_list_to_order(&folio->page, list, 0);
 }
 
 /*
diff --git a/mm/truncate.c b/mm/truncate.c
index 91eb92a5ce4f..1c15149ae8e9 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -194,6 +194,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	size_t size = folio_size(folio);
 	unsigned int offset, length;
 	struct page *split_at, *split_at2;
+	unsigned int min_order;
 
 	if (pos < start)
 		offset = start - pos;
@@ -223,8 +224,9 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	if (!folio_test_large(folio))
 		return true;
 
+	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split(folio, split_at, NULL)) {
+	if (!try_folio_split(folio, split_at, NULL, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -254,7 +256,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		 */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split(folio2, split_at2, NULL);
+			try_folio_split(folio2, split_at2, NULL, min_order);
 
 		folio_unlock(folio2);
 out:
-- 
2.51.0


