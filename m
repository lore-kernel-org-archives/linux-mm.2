Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BE9D61020
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1686B008A; Thu, 29 Jan 2026 09:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B1D6B0092; Thu, 29 Jan 2026 09:43:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8341B6B0093; Thu, 29 Jan 2026 09:43:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 724896B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:43:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BFBBD2DC0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:43:17 +0000 (UTC)
X-FDA: 84385269234.14.CFA5BAC
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010028.outbound.protection.outlook.com [52.101.56.28])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B2F61C0007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:43:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vGgzP618;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 52.101.56.28 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtGPbM3cYUrnp6QDYMV1xn9+hixoSjQgngEFAtBt310=;
	b=fdSOq3jLaZQ8JpDDrqCdXS7PBlCOfCCuG3cbL6HVOXUE+axm0HypfxD7Hlc+b8gYwPI4RA
	Cl25YxqSopttZTPnAD3tu6dvDTE5KiglgFSD8uv4haP9/zBXqSNdmPJP8Dr+NGCjB3WFFh
	uBH0mW5lDwUUIcnbTTB42KHxNtqQsFY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vGgzP618;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 52.101.56.28 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697794; a=rsa-sha256;
	cv=pass;
	b=daK9wkui/sW0EilWXaIxV+zGIc1WuQD5Gkvkf4TC0FSXJrOUsYSa+escek6NtFLwRH2OmE
	AsY67rZDHQ1Me9wheNZafio6U5z9Law755ZF/hQK84bclxKSmWO8xhIKcCbtLe0E+FU0RR
	ipfko9GACovygZXFvdeFpjjR2sYifkg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oh+Kx9pwZjx/qs1dPF4ADu+m0/yq3HY7RD6FLPgpm8VPziPAsRHB2PNULTYU2uHXQ/N4Z6o+LgcPXHX4MpbOPkq4kk912FUFHR3Tm0I5zW7eBAAM/jnmTTIScgvjEEnyRGoUuByqIP/CYFcwmKfxPdLRsv2ihI4Jp4zcEwGZ/h792gjwSGo1D6rC5AfT2FFUSMZFJhcdnpVhGCWgn/jfaFBeRJlC/jx8Ogvwu4C3WEqywGwYpzNnRnOMCbhbtO/F7YMs+CvK+cYCJDpMy5Wbf3gn5CmtEjn9Ag+xlgSRhw21q+ZtLwhemtJLR/QyLraFqO0tuTHWzCGY2Bka30deMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtGPbM3cYUrnp6QDYMV1xn9+hixoSjQgngEFAtBt310=;
 b=xHcp4JjNflYIPLNUDZK56gn9EM8kIhtqJ+zyB3RIK01eEG7pGNMi3siwnuJzCijaEXWIfSfDC2M/7qwFNBFzs+IpnQsy7sBGUlM8ZMhkQn6M+3TkCH5pymdWhyB//+odmauDkliQPfUInSuMud2ShWc8pEnjUoMpH1lOtRLepOn66GPqwprcHGc/rALuPZmaotINTzfH6NGmpDmPZskWIyxf6/tLYH1RCpwaPuVkOzrrxU3HkPkdOkyIy4tBpFFsIIJzvRnh851b0dZnwv0C/mH/bjKgJQylDkO7M4IjDFSnpf4fh5l5VzkTiwcvpswEvjoVbQZVCWaHv3Qu+q4IkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtGPbM3cYUrnp6QDYMV1xn9+hixoSjQgngEFAtBt310=;
 b=vGgzP618GUmyznTqsRpJG2YaP8hkmFxydhWHGvZBSn1taiWnpxKCSxeJE3iZ53u5uMBOFhcsolnW1k9TD7ZcrXT6ArYISM+Fk4S/akPpCX6DDpjfETjmPUaL/JZTtssngvEqUD98+D+GKaNySkT4bDtO+DgbGhUo39FUlVHmU1g=
Received: from MW4P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::13)
 by MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:43:09 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:303:114:cafe::79) by MW4P222CA0008.outlook.office365.com
 (2603:10b6:303:114::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Thu,
 29 Jan 2026 14:42:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 14:43:08 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:42:58 -0600
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v5 04/10] mm: pghot: Precision mode for pghot
Date: Thu, 29 Jan 2026 20:10:37 +0530
Message-ID: <20260129144043.231636-5-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|MN2PR12MB4192:EE_
X-MS-Office365-Filtering-Correlation-Id: b7c2b319-2463-45c7-57d6-08de5f44b86d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vn2iSVkv56czQ1mRkCE00pX66ytFXVviLpTm+EWDnIGhDu4BTorZH1ZRfpiO?=
 =?us-ascii?Q?ugPz6uDer1BcYMOrFhENpdym9U0z7W5oQOFuSY6WVlGoaUeupmdt5XDcAia5?=
 =?us-ascii?Q?RZIba2Q02exM6lUTs9iKszQKUgWgTZjnjdYHzc+Pklah+KwAIIWMfAtMTgCS?=
 =?us-ascii?Q?499feAGtMJWEAW0wirTAgEnvIyiFPUTSJB5LOB2PxxnjWsbh7CU4QGr81/9R?=
 =?us-ascii?Q?1fw1ucj+1+V5TvgBkS5XgsZ0QauZ7BKdVEXUWOZB8ciFUQs4juFWloQyfuQw?=
 =?us-ascii?Q?ggQUDDyz+qBWTTKMQnKdmXnaKalgdQ+uHkNzhGrOlIUa6ipacl4uXIZp0oYn?=
 =?us-ascii?Q?c0EqdzgoxnHbAEZDRyP6c3zRwU1agIbYmWO5S4ENpN60O4W96UdwoE4VM/aI?=
 =?us-ascii?Q?cLPJFd3FeOYh+/osQqs1DGD2n52bT1kuysnrMj4Jqn3LXB1JsAD6Da2/YMDc?=
 =?us-ascii?Q?VknUJOe8cDUyCjBFvBWr7u/ttesvXyx8qVYQo6VxeCC2NZo+JQu6064wRO4s?=
 =?us-ascii?Q?ctsfAb7ARlm5U/4XD4C8TnmuJdm7MDoSLaicgh/WgpuzWql6ZNWiE0kx8SIz?=
 =?us-ascii?Q?l8Egdslju69NBp/6wjbyfTkFt43XXImp/640Vh0wQczFCjqS7zJ2ujPL656x?=
 =?us-ascii?Q?ar0qZuxViYBUp1FVM0ex01QPxlDUoX7eng7eQ2EilhCojGJKYAqt9qxxCpQN?=
 =?us-ascii?Q?//9myh/hQRbecsCTkVARv3RebMnFUtgKBG1B9FO0c5jkzo/lugzYJ4gbFT50?=
 =?us-ascii?Q?RfKdLVNL2ulNDfKlsOhaeKJJF0nWoTcuvdQMY61O7dicfiW4IXEU6dhZgEst?=
 =?us-ascii?Q?RyVSWFMr3r6vKzzvZJb1o/nDPo3lgliSQEVF4NoUqJpujvDwfwlJHEsMHuf1?=
 =?us-ascii?Q?FAmZgXpzsrKMmMmMb2pvLslaDyhlbxvIqGMR8S6EmZ9yoH2XeYT2J82IJnmP?=
 =?us-ascii?Q?uhkckNu71iNok96GM+45G6OJRCGKjCxrOredH241IdQwpQk28rXIztk55YRx?=
 =?us-ascii?Q?I/DtAkQT2nVO9+nkTLOlTP+SaAlV14pcMFcYpL+IHiu9uz8zFaz6fHdCtifw?=
 =?us-ascii?Q?pINeKENZvwsN4XByd3WxE0OWaK8lCudOHgdUOu7CC0bXIlONokOCEXDysehj?=
 =?us-ascii?Q?+4c1tSDSqqU+UodjQhDFipQt9Ue0M9gY+EarqdjeexgHqAwAMplMyogRgmHf?=
 =?us-ascii?Q?Kd2L2UEzystw3N1MWtFYuAjtKN5dyIOg6zQ06IjxLgIxdIjVxedH+90w3/Z6?=
 =?us-ascii?Q?TrrhLe9ZjWWWBXro9SqFCElyH9zw9t3LO5X6R1v1nbXp2bXjKrAQFbzMNDXr?=
 =?us-ascii?Q?bdKUPvN8E3fbNbioglCu9RzBteyWW3F1deqhzQGxr6/60g8KQ/cd4lcJYxbz?=
 =?us-ascii?Q?Xqn6/2TQyrk/KydwSCH4Xz6hJWdOgyuYPjBx4OT5UkS6XvzKIV/uajFtTOtd?=
 =?us-ascii?Q?9zL/6z6XOCchGYz+RYpu/04rUn3OGfPJgGuciogQo6rxz+DD+kceG2P0AEMz?=
 =?us-ascii?Q?F3YJ+BZ8eDYAptICyELzMXVdfxGtHqahScLdMz8W50y6vDL8TQT7NcjaCEW7?=
 =?us-ascii?Q?xAIcbhxvXzqUYzWiyb1QrGr3ZIsvkslSLcga/5rhJtA66vlEHDXJ1FOw/nJw?=
 =?us-ascii?Q?ZX/7opMjzquuQVGidjO06/7XDdImYeeYc2+tRV/TXzdJuj5NRh1M7OIxaOcW?=
 =?us-ascii?Q?Abngnw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:43:08.8374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c2b319-2463-45c7-57d6-08de5f44b86d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4192
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B2F61C0007
X-Stat-Signature: fcacsg3igyrfjkohk5hirpnbzjh4u33t
X-Rspam-User: 
X-HE-Tag: 1769697793-147683
X-HE-Meta: U2FsdGVkX19lwwIljuYQSRNFXwahUnq6lrp/10xLcw2YU1RvowtTL6T/C65ufKavgI9/z5Sl4txYAl1k1hElwkGhTRJJB9df1Oxa4pvEV08rUOVpYOJnNBsGmyURO3OH8G9AfVGLkLKmZiS3A6zz7w3Q/IQIxMlSoF8eCXgBTGznjH5GUbNw4MBNdxDvFs7U0sNkvMihnR1q8yu6ZOFsBumLPuj5tFJAWDgt5PXhMIrMNlPvsd3P8xS7s5tIScNaMl5TJtYy1GYWTVr4ZDtFJeBsX0YRBFaM9I9kHZxSqAoQAaPYqVB5/9nr97zR1KTcMahgMObq/gb0zsAHygfe9PLwwSQCezoxUG2sslsOlqueKRRs6x6nyVA7iNjQhhEf73xDJwXM1wXF4lt4/dTBku+oqrTknDhtf1SVF0TAmH12+MPDbp6ezUfmsl17qkxIb+lYahrI2YT64aSlBiyxfNrtlkQ2UD09odtklel4vKgqHLEO+1uWxGiOKCfEarS0uayDj2FDadMokygoG7aIOMTonyvgUrz6esGX9kb7rfYAC2E7qHdfT83X/VZ1VhJZ+O/b+L82qcagdvfNtnJhitndNZ9X/7mCWsYiixyytS1IXYHDckrxknOn7sNppgyyrXss00OdET+i9wRsSy5ipxyz3o3LkHqOH2+ZT8y+m/ewaX4AoKvIxnB6/FV6CVvsOe0KwtJ0sIi66tBKEvo77M/FShpFSq5YyraARbD4vvwzhKxWZIQckIA6oiULxje/TEPEmVeERo8RY/jVJnbtIe8k3Y4oI0KbpKfv/gRbSAKIOHpa/muEZEbAcKBaAj+THRLGucDQ9kHuawiiY3ifppzSIKS56mSlg+nEL2fXgsXa2XxT2TCuDk1MynpHZEh1oss0XM9PP7KtTlrX9jEejmfME+h5x7YIUWxOQ7dvUhswrUBvPNcO0DWCgYHCiWvWRANIJPicVEKsPAbEG9U
 bKeICxtM
 z8oQu9Ho/qhotzhq7p4XtUxPQKIiGAcqhif4bJYZyUbxrOQakUmMP/FmUUHHuPX0XJ5MEdJqgEkSXT/lZegvsz1eE5B6C0LZed0is9qenKZXrJcU5Mo3fWVrgKAa+5sablgxd/cG18NYa0ILIc/TN4suZUbIG3GsFpiwkCrtdbGdTp6vslvod1tq6JtoJwe6jUTlphYVMaIvAe8BAx6xY04DTJNbZh5xorWfnQdaMeogNmEyLhKlfhqmkLEeab/1IQslXOnDubjoATCSvbuQmssYhSEThgTxOJIT19LcyC2nxoTkVCNOf4pAWP8zVKzSkVkw9hKNIWRfjZRMRTfQxcJTQEwwgw4tKSSlRzH7uv8qyL1liHhJv9atRU7lHxsCg5kcb6HgqSWnwvkWuSwD/q6nZCBzNWrgB0xR0gSx33+pPKhdQ/W2gAsqaXLMva3Um+LX5IUXT7s9iQ80nLypmpwz1hcO/3qC2NR07fAnpI+546BE3bqi8FEcPevkkN65hUQGneCHEM0C/fe4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By default, one byte per PFN is used to store hotness information.
Limited number of bits are used to store the access time leading
to coarse-grained time tracking. Also there aren't enough bits
to track the toptier NID explicitly and hence the default target_nid
is used for promotion.

This precise mode relaxes the above situation by storing the
hotness information in 4 bytes per PFN. More fine-grained
access time tracking and toptier NID tracking becomes possible
in this mode.

Typically useful when toptier consists of more than one node.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.txt |  4 +-
 include/linux/mmzone.h                 |  2 +-
 include/linux/pghot.h                  | 31 ++++++++++++
 mm/Kconfig                             | 11 ++++
 mm/Makefile                            |  7 ++-
 mm/pghot-precise.c                     | 70 ++++++++++++++++++++++++++
 mm/pghot.c                             | 13 +++--
 7 files changed, 130 insertions(+), 8 deletions(-)
 create mode 100644 mm/pghot-precise.c

diff --git a/Documentation/admin-guide/mm/pghot.txt b/Documentation/admin-guide/mm/pghot.txt
index 01291b72e7ab..b329e692ef89 100644
--- a/Documentation/admin-guide/mm/pghot.txt
+++ b/Documentation/admin-guide/mm/pghot.txt
@@ -38,7 +38,7 @@ Path: /sys/kernel/debug/pghot/
 
 3. **freq_threshold**
    - Minimum access frequency before a page is marked ready for promotion.
-   - Range: 1 to 3
+   - Range: 1 to 3 in default mode, 1 to 7 in precision mode.
    - Default: 2
    - Example:
      # echo 3 > /sys/kernel/debug/pghot/freq_threshold
@@ -60,7 +60,7 @@ Path: /proc/sys/vm/pghot_promote_freq_window_ms
 - Controls the time window (in ms) for counting access frequency. A page is
   considered hot only when **freq_threshold** number of accesses occur with
   this time period.
-- Default: 4000 (4 seconds)
+- Default: 4000 (4 seconds) in default mode and 5000 (5s) in precision mode.
 - Example:
   # sysctl vm.pghot_promote_freq_window_ms=3000
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 22e08befb096..49c374064fc2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1924,7 +1924,7 @@ struct mem_section {
 #ifdef CONFIG_PGHOT
 	/*
 	 * Per-PFN hotness data for this section.
-	 * Array of phi_t (u8 in default mode).
+	 * Array of phi_t (u8 in default mode, u32 in precision mode).
 	 * LSB is used as PGHOT_SECTION_HOT_BIT flag.
 	 */
 	void *hot_map;
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 88e57aab697b..d3d59b0c0cf6 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -48,6 +48,36 @@ enum pghot_src_enabled {
 
 #define PGHOT_DEFAULT_NODE		0
 
+#if defined(CONFIG_PGHOT_PRECISE)
+#define PGHOT_DEFAULT_FREQ_WINDOW	(5 * MSEC_PER_SEC)
+
+/*
+ * Bits 0-26 are used to store nid, frequency and time.
+ * Bits 27-30 are unused now.
+ * Bit 31 is used to indicate the page is ready for migration.
+ */
+#define PGHOT_MIGRATE_READY		31
+
+#define PGHOT_NID_WIDTH			10
+#define PGHOT_FREQ_WIDTH		3
+/* time is stored in 14 bits which can represent up to 16s with HZ=1000 */
+#define PGHOT_TIME_WIDTH		14
+
+#define PGHOT_NID_SHIFT			0
+#define PGHOT_FREQ_SHIFT		(PGHOT_NID_SHIFT + PGHOT_NID_WIDTH)
+#define PGHOT_TIME_SHIFT		(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
+
+#define PGHOT_NID_MASK			GENMASK(PGHOT_NID_WIDTH - 1, 0)
+#define PGHOT_FREQ_MASK			GENMASK(PGHOT_FREQ_WIDTH - 1, 0)
+#define PGHOT_TIME_MASK			GENMASK(PGHOT_TIME_WIDTH - 1, 0)
+
+#define PGHOT_NID_MAX			((1 << PGHOT_NID_WIDTH) - 1)
+#define PGHOT_FREQ_MAX			((1 << PGHOT_FREQ_WIDTH) - 1)
+#define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
+
+typedef u32 phi_t;
+
+#else	/* !CONFIG_PGHOT_PRECISE */
 #define PGHOT_DEFAULT_FREQ_WINDOW	(4 * MSEC_PER_SEC)
 
 /*
@@ -74,6 +104,7 @@ enum pghot_src_enabled {
 #define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
 
 typedef u8 phi_t;
+#endif /* CONFIG_PGHOT_PRECISE */
 
 #define PGHOT_RECORD_SIZE		sizeof(phi_t)
 
diff --git a/mm/Kconfig b/mm/Kconfig
index f4f0147faac5..fde5aee3e16f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1478,6 +1478,17 @@ config PGHOT
 	  This adds 1 byte of metadata overhead per page in lower-tier
 	  memory nodes.
 
+config PGHOT_PRECISE
+	bool "Hot page tracking precision mode"
+	def_bool n
+	depends on PGHOT
+	help
+	  Enables precision mode for tracking hot pages with pghot sub-system.
+	  Adds fine-grained access time tracking and explicit toptier target
+	  NID tracking. Precise hot page tracking comes at the cost of using
+	  4 bytes per page against the default one byte per page. Preferable
+	  to enable this on systems with multiple nodes in toptier.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 655a27f3a215..89f999647752 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,4 +147,9 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
-obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o pghot-default.o
+obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o
+ifdef CONFIG_PGHOT_PRECISE
+obj-$(CONFIG_PGHOT) += pghot-precise.o
+else
+obj-$(CONFIG_PGHOT) += pghot-default.o
+endif
diff --git a/mm/pghot-precise.c b/mm/pghot-precise.c
new file mode 100644
index 000000000000..d8d4f15b3f9f
--- /dev/null
+++ b/mm/pghot-precise.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot: Precision mode
+ *
+ * 4 byte hotness record per PFN (u32)
+ * NID, time and frequency tracked as part of the record.
+ */
+
+#include <linux/pghot.h>
+#include <linux/jiffies.h>
+
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
+{
+	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_MASK);
+}
+
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
+{
+	phi_t freq, old_freq, hotness, old_hotness, old_time, old_nid;
+	phi_t time = now & PGHOT_TIME_MASK;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		bool new_window = false;
+
+		hotness = old_hotness;
+		old_nid = (hotness >> PGHOT_NID_SHIFT) & PGHOT_NID_MASK;
+		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+
+		if (pghot_access_latency(old_time, time) > sysctl_pghot_freq_window)
+			new_window = true;
+
+		if (new_window)
+			freq = 1;
+		else if (old_freq < PGHOT_FREQ_MAX)
+			freq = old_freq + 1;
+		else
+			freq = old_freq;
+		nid = (nid == NUMA_NO_NODE) ? pghot_target_nid : nid;
+
+		hotness &= ~(PGHOT_NID_MASK << PGHOT_NID_SHIFT);
+		hotness &= ~(PGHOT_FREQ_MASK << PGHOT_FREQ_SHIFT);
+		hotness &= ~(PGHOT_TIME_MASK << PGHOT_TIME_SHIFT);
+
+		hotness |= (nid & PGHOT_NID_MASK) << PGHOT_NID_SHIFT;
+		hotness |= (freq & PGHOT_FREQ_MASK) << PGHOT_FREQ_SHIFT;
+		hotness |= (time & PGHOT_TIME_MASK) << PGHOT_TIME_SHIFT;
+
+		if (freq >= pghot_freq_threshold)
+			hotness |= BIT(PGHOT_MIGRATE_READY);
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+	return !!(hotness & BIT(PGHOT_MIGRATE_READY));
+}
+
+int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time)
+{
+	phi_t old_hotness, hotness = 0;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		if (!(old_hotness & BIT(PGHOT_MIGRATE_READY)))
+			return -EINVAL;
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+
+	*nid = (old_hotness >> PGHOT_NID_SHIFT) & PGHOT_NID_MASK;
+	*freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+	*time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+	return 0;
+}
diff --git a/mm/pghot.c b/mm/pghot.c
index 95b5012d5b99..bf1d9029cbaa 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -10,6 +10,9 @@
  * the frequency of access and last access time. Promotions are done
  * to a default toptier NID.
  *
+ * In the precision mode, 4 bytes are used to store the frequency
+ * of access, last access time and the accessing NID.
+ *
  * A kernel thread named kmigrated is provided to migrate or promote
  * the hot pages. kmigrated runs for each lower tier node. It iterates
  * over the node's PFNs and  migrates pages marked for migration into
@@ -52,13 +55,15 @@ static bool kmigrated_started __ro_after_init;
  * for the purpose of tracking page hotness and subsequent promotion.
  *
  * @pfn: PFN of the page
- * @nid: Unused
+ * @nid: Target NID to where the page needs to be migrated in precision
+ *       mode but unused in default mode
  * @src: The identifier of the sub-system that reports the access
  * @now: Access time in jiffies
  *
- * Updates the frequency and time of access and marks the page as
- * ready for migration if the frequency crosses a threshold. The pages
- * marked for migration are migrated by kmigrated kernel thread.
+ * Updates the NID (in precision mode only), frequency and time of access
+ * and marks the page as ready for migration if the frequency crosses a
+ * threshold. The pages marked for migration are migrated by kmigrated
+ * kernel thread.
  *
  * Return: 0 on success and -EINVAL on failure to record the access.
  */
-- 
2.34.1


