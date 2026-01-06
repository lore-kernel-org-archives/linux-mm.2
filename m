Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D539CEFCE1
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 17:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730CA6B008A; Tue,  6 Jan 2026 12:41:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF1E6B0092; Tue,  6 Jan 2026 12:41:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537F16B0093; Tue,  6 Jan 2026 12:41:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 406CC6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:41:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D692D140233
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:41:12 +0000 (UTC)
X-FDA: 84302255184.06.84030C0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6C224100006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:41:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="q4ht2E/W";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qTjOonDh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767721269; a=rsa-sha256;
	cv=pass;
	b=U7MngngIc+X6ZqcK+2cG06SiWSNhvg5SnnHr1cxqWNJfEnO+eJ749M87GkwTHU6TApClA4
	pM88GQ5SNTuS5WOa3wO1hvG69qMYRFyK9sLwiS5IR4k9AJQUhvZDx9k5hID8Z9bCggUSlS
	HKN/wV9bWZJbX6/GEgwf/f7HSVz5FSE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="q4ht2E/W";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qTjOonDh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767721269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJQ3p2X9q7Swr1boL0F3y/bNiX5oQBkxPrdulq7YUHw=;
	b=319lO383+mHhy5TTYRUzp2iXK3MDlN7gnbKM6VTATs79V3tS0gtconB8VA++nwzovKTe1K
	jb84pk6SiuWGq1zgSTpkSv/4niwkobVgjnQ8Ki8TQiB0TdokJVpS8g6mx4qh2ZwKJBdf1o
	xuOsrKwwB7YprnSGpmtuceTo6n3a/Us=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606HK0Qf137198;
	Tue, 6 Jan 2026 17:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dJQ3p2X9q7Swr1boL0
	F3y/bNiX5oQBkxPrdulq7YUHw=; b=q4ht2E/WSlWrHy44Pn2h8EpHm5Fu7lDFUO
	MnwfirBSjXTz2nDYpBsqxKyZzSs+fKh+OrbiItUj1GBLixXZSqmyPO/KbZNxEWr6
	+CFxAu52Tlf4LpegRKW5zjvPsko3wG9nd9lRuaIQvhFhCBxGSX4DcRWRQ4UhQtz/
	dibmvj/3c3chcTDbi4Ox2BUfrCmlTXJm4qzb8tlUr2VwaBrcc9nmhhz8nkNahCU9
	U7o9jWBV1OianuTOrCRXKwuSHoI9HqdWZCDCmCeySYB1aSuiXL3vr9FCM7Ec7yyu
	29NHvzFLqL2VLRpVApZDxtKOqYIiXkoYLUlkyXabyTdq0VGAJA9Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh6pxr1c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 17:41:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606HEEQk015667;
	Tue, 6 Jan 2026 17:41:04 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8mbtn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 17:41:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=khXwZLl5yK0aP6eck9KA/MTRO21H9xHjcXJf8NwuqOW58QreTNmu3TnZFdrPqWkyxxx3oHHUuMCp/iHXVSghnPcrDEsqnqp33CxG+eUD1F1ZJrADqulHqQfJuUSsaP87ykIhKO3W8iE5+kpGVBbVyeBItmNVgSLKzgRFjII+QP/cYnr/I/rvqHZiy3Drp0dlgiqSSYw1fzBU3io9jL3H7jouwkzNSi10H8S6VCVZfw8HwtR6nN0mo1DNq4i6h6Ts1EzE197J3XZnqUojz7p6XSidugcf2tCLE6WQYso80bJIpmuptbeRE8Cg6j+9Zi8OTd+yiqky20Y3pYtDjqcCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJQ3p2X9q7Swr1boL0F3y/bNiX5oQBkxPrdulq7YUHw=;
 b=cMRW7CERAhe5KR30D0fZxj1Sm5M6sG0Pu0hp9YTw33bDMO1KkCivZCfVw9vyNkOp4ifvsalbKoRYNnv6fEUbOB1r+6Bst7sC7gmVhG0T0wxyUIn3xuNaCA3ghfHel4sASGuSID90fuUCcpvRzQYjbmkN62ANVPJ2ddQPPa7HaTulxK749IgG1on+FohrJmt7y3/nCXz/05hlId8kp8kzaDlkx12KXfiUe3I3FIA5KjMDIZSSCOJkLugW7j17Jxz414597taCBtTafzrJQLYhdJu3ZA3w3NtkaxTR9FzJsqwjeh3re2Ox/9pTygA8xN8qFIXg1kdCVWlCdmA48vpz6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJQ3p2X9q7Swr1boL0F3y/bNiX5oQBkxPrdulq7YUHw=;
 b=qTjOonDh59TkuiJtbhz7C1LYpNgDs9NhPPM62ddAVowEhv++Le10soKECB9jucRm1+G3tCh+bQarU9uSdmVLqMJd+QPh36ZlHlgV7X8wx21SOI/FziE7OgW5ruHdBCuLbspcSWiET13DXJY4fdnoYApw1PBf/XYcd2GgyODNvPo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH2PR10MB4245.namprd10.prod.outlook.com (2603:10b6:610:7b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 17:40:58 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 17:40:57 +0000
Date: Tue, 6 Jan 2026 12:40:46 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
Message-ID: <j3dy3g5mchtdzxldtnqu5nwaalbr6ec4ceim3nuu6nwcddmqjc@7dgzr4m7pli2>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
 <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
 <e60858c9-12a6-2b04-35ae-9d676f14db2a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e60858c9-12a6-2b04-35ae-9d676f14db2a@redhat.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT1PR01CA0092.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::31) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH2PR10MB4245:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e20a5e2-f0aa-4fe8-7651-08de4d4abfe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MbuVWwwB6hdxF4PtLQHilaa12taJyuzPhv6ArOuiGJ+yNeLCC8aldCRI31TH?=
 =?us-ascii?Q?eIilOMs1DuP2csHWwza7QpG2dbmFrvu8q8rr6ilXiXPSUXKAPjNLqgaehrmk?=
 =?us-ascii?Q?ikMNoF0qhOXWGkt39Vxv8VdshFGouYbeTFTP3SXnwOqhB30iSuslgR3OnE/P?=
 =?us-ascii?Q?+6aR+mTmdudvhKQV5uO8NKy+dLoM0MWsHcyXAtjyuITJa5QI3rmtj8mn7P/Q?=
 =?us-ascii?Q?H8KB1tRrixRtag1PNlpgVB/01Qm6AbHh0opVVAh5MpF+HQo5ZIfbi4pXXZal?=
 =?us-ascii?Q?D1urx/0pfWsIvT6paaNAN48/ixGb23/VUJRBkBtC9AOklbzORVMKSGegrgxl?=
 =?us-ascii?Q?dVXo3H6Rov6AFfhCln3Jy/0I52AYXR/OJsOOpc7oI5IsanK9RmhojKKD1Q/M?=
 =?us-ascii?Q?Myh2e7n1k2kY18RLlzcp8sXWGGMdHatCE6zBT37UJ2Tp5yxB2IXBEhyNSIWw?=
 =?us-ascii?Q?RJsiHTanoY97m3XvesTZ/uq5WjxccDBnf6IWHSuEotylR64X++ZLa2yFifTD?=
 =?us-ascii?Q?b2dWiltSjHOtbTnTnIA72U+nTqySmafSouXoha6C4HrKl0/epHGEMFBu3J5r?=
 =?us-ascii?Q?FeiYvPNpVkesntM+IBQMfaYeH4Fccjp0LGSjlcFWyHvobvLXC7adbPxur51X?=
 =?us-ascii?Q?TqUUC4iltyByFJuZ186KswJGelYsPIe48pTn5pLbnUZXGOBFhu3BCAJ6TjQW?=
 =?us-ascii?Q?TYAwpu7f+NDCpOP7gk3c/pbhd9jB/nnGCP8zRhDL4jQg1GYa/sAeRA7g0pyf?=
 =?us-ascii?Q?QA5Bs+i1IhTECWy1/5YbZ98FJ6dEEPlPceJiPhvxJabulSV1gz9YGzZ71sea?=
 =?us-ascii?Q?o9gt7xOzArlv7CoG4stSfiMkWI6uSQH9nEvhb2fSZCuCkZkwHuVRaO0i5PFH?=
 =?us-ascii?Q?diMi2d/7xTgNKGU7RlUwALQV7HXtC9eRHORdlJeNb3Mbexks/0O7UJsXV6Zq?=
 =?us-ascii?Q?7OTmQjuypCfPsDRL+vlryTqOX5+KMlxZGACjBjeXY90Oflu5MPGOXNaKX+SZ?=
 =?us-ascii?Q?MV9qQikJMSdI51qH5tSX8oCSimTkBS68DcUdojeYaP7NMxcv9lxXUF4YMZUT?=
 =?us-ascii?Q?a9XiKP0zn8/Vfa2bvwbuGj4ZZZ++dVPbBqTWk3p/ejVvBQSBoaQi2jNUkBsU?=
 =?us-ascii?Q?NkNly/KnqzH+SA1c+RctNe9fBxFiE2eV7tj/lGqJw2CgGScsnHikdFaNsopl?=
 =?us-ascii?Q?vK0rz9BOd+PcoBDIp3ODj1WIZ1NRyEmZaOYmIPvwRPrKogVFACU3OdZ1WJ01?=
 =?us-ascii?Q?qf7i7Y9kaT03ve8Kkvj7NU0rGuEQRqXxXxGD0sSwaSXeNT0RKdXdHq6drJot?=
 =?us-ascii?Q?9vemZHtAMtO/ekEcu+6BDKMcYHv6AbOhBvKEdsVbvfBkdJutdgEtoukct2cb?=
 =?us-ascii?Q?gt4nj7zq3NjMNU1ohzvaLE4HhRG9swotfjrxwHPGHHbhRGksUBTrCLAfCcsd?=
 =?us-ascii?Q?OYQnEV28uICsSLP1Qrq64NyNigd5FlTo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P0aXVZ5n7HXaEiLguopVHuvdKd6DVxZl4ZLGECzTIGZpEEhJmMb6k2kjCxst?=
 =?us-ascii?Q?gz+EdA1GK3TQtIDiOPdfpvs7IwzJVSBqkgVGNV+3RrL1Detc5qj++MYizDA0?=
 =?us-ascii?Q?xy+k/3/GZTmEpEeMenBj6/EMyvnR7FC86jhDxFjkkNOZ2Rg6EdCTfbdIplai?=
 =?us-ascii?Q?9XR0ir5Tk+Rh5zE11vFF18zY06fLItnT6dwbkQaFVbAJ8Ebw+ahae03xCpAt?=
 =?us-ascii?Q?5dlzpcwWDhuaEFZJ/nCO0Ya08SZN0P32kQjAm8HeW8JRXdHA0LMnA/KaYpXv?=
 =?us-ascii?Q?sQh9MDQQdMPtGRPQb7Az6vyvTx6DimvMwWWbHVMaTdBmkFZ9coWx8dK3d3yd?=
 =?us-ascii?Q?nKJ1soUoG/GonLyK9uputYgYjs/pQpLCpj5fFUp+z/eKT+0rJ5fnky/YOobE?=
 =?us-ascii?Q?hmu/kdWRY68szHqk/mjUrGArwKcJa5tdLE9VjBhcEBNnKPb4bRoLveT1Zg5x?=
 =?us-ascii?Q?4c2Ww60PQKELrCKS7BDbp4Rz4obtGm+olp2ZASYNlDR07JGNCBjwTR4D41JA?=
 =?us-ascii?Q?mgTYr3WmKCUA2MoM06+M3tKc7Hnt/CnItYDvNVgyglQJqFaQ5oh4TVHRLIGl?=
 =?us-ascii?Q?HYELsgcg65cFNEHXJ3oh9Nc4YicCDBiTZMpurtiBTdlD9w3bVK9y/mr8HZTv?=
 =?us-ascii?Q?hpdIabtBPtKsBJzwoYdo55yI2acsetsf/ngFi90Ma6nfGiFYYuhdiwUKUyxH?=
 =?us-ascii?Q?DG82MlHtJsmo6uWYJ2dKDfNKEO8JNJ0HxN45sTXUZkYs5nIWDfnyA3oCzlPq?=
 =?us-ascii?Q?QJxfvjFJBNQIhBJfSh3KEufigasebha7t7dI5yujGp0DhJzg7jCcyW+Mc0pG?=
 =?us-ascii?Q?u+vm0sxv4EaxG37MpKxdKTg+wbzywa3aPst40c2I6hkdo97jPiy9IdKXWIxH?=
 =?us-ascii?Q?j2zrdLrn0Z10rFmTDX+IzFGyc3vCbH2fIuTPK16oGd4r8M1fRfpnVABNyBYp?=
 =?us-ascii?Q?Hx/us9HM5fJ2BvmpoGGn2Vqf+kvt/WMA/y5PCIGJzbu1/cqLn+zESTr4KR6X?=
 =?us-ascii?Q?7YlGuWwwi/RBtXzAVsZoCGQWFFGiQWpuxzTuHyHQyOHA4c9Kx0Ct4+mc5YOA?=
 =?us-ascii?Q?imEzW9D1u25TFKvUeDfHsNUlNAuLxl2l2JfONuGwODjIWiCQ/jM9RiDEMFxC?=
 =?us-ascii?Q?O55txhpt4ZI1B8d8BzZEg0dPermfhEymtwqcICvh5HL4sxeP1mlybQFOPCei?=
 =?us-ascii?Q?4ybJx0cXZd46wgY0DqrwRcgzPqg2sHNCb7LqVJ6VkTplyK9QsZDOo+lzdnAS?=
 =?us-ascii?Q?pDC9fYRpdb5y2lxuw5U6pKcFgzEV8R1lW567Xm27hdNuXRtmNlG9fzxCMGGs?=
 =?us-ascii?Q?Sx2DWeQsPrFqgzSN0b9rtEmys7XsSwHmN4ovvo9jOo2Zr1D/+i03R8DoheR+?=
 =?us-ascii?Q?JFPkNlchv0ZsVEd1etldAlrzuf2uzA+f13DtvrEbUPAzamfZ3laXMQhBf7sL?=
 =?us-ascii?Q?dHrVFNp3czV57biwiYhLGoeI+m1ruqIsjCJNgl/DaVJpCAptrMdZP7rJtH3I?=
 =?us-ascii?Q?8lJzB2I4vI4X5ujo2I4FYJm6g8usnIV7o2tLNEqmQ1Rv4a/aFVOdfJCnyD8j?=
 =?us-ascii?Q?RmVuRA0rpkn+79LxGvaZp6IbrtNkHCgajDp0xb1Gx4HpegCgwN3+4fJ/vorF?=
 =?us-ascii?Q?F0z52vZsfrlADdRU0Pscz4va9qIUswR8gtlbvSGDlU0YtBSTpRRebdkDlHTi?=
 =?us-ascii?Q?x/u9MiGt90/sokn3dOjMF7UFpVTOWS9g9U/Nh8VP95yJRWEmOni/A/Q62uPM?=
 =?us-ascii?Q?oUvyLWAfag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yVkbEV0vvoVYGupRXb1DukJM/YQIbRoo0pEoB07BQxba53w8MB+rMrlrnVIgtt1UXgwTNIcZmN56f5FKJv2jVQP+kbt857gi57u3kiwmwrlFWshoZ08jrWPdAR3g9cvehQa3fXZjYl94UONMIDS3ezjS11p4VQh83Md4TEZVnrWTAmnuautQqi0odm9EKWfqkNK6y6QcD0BwhyDPRQRWZFhxqpAXpANX54nQcjjawinJPzapKXSJx0nMG7r7SDOIMd+nVVMCo2XmZWSHiVgWaTsSM3deH+Xxg8twbDGy788xav2kVDmFoXfnoyrVKEpspZU47z/fUNzVD4CNcZ2JrX0FuHiaDr5Y/i4fqNdD2Pbt2ar+bkHqSVaVYX871jG0vrB62wp2orTrvRlfCYMKUQzuV7otyrcownilGYf2WVhKw6w3BYO/F9pW+r1ivcpD8i0zvr09ULjfGPlsR1ppE5/IRVtJW9cPaQ9q5CoeuTShB0e52m35w8rXGMEGBtmkecemGAau5R35vd5dcuOjUvB8Hj0POCZISO5Di6rJp3FzwLIN56wiKTMh0rNlp9sVZGqD/cKHBGbkP4O8rqt2TwWcS+yNdgT8i/+olGVSj9Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e20a5e2-f0aa-4fe8-7651-08de4d4abfe9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 17:40:57.6961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqbpaTz+Gf85bGrrhtvEVg9S5dSlImO0wvhKBJrKGPQqFOqO15GJc4bwvxcrK3hY6295fgK4l3G/MJ+SkgWJcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4245
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060153
X-Proofpoint-GUID: -WeA9x0ft7WeulYhav4rihOohgFpif1d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE1MyBTYWx0ZWRfX7ZhZyl79iWqA
 hcEmz1rNzy+RwkaaqdKigQIOsa85Zfi+gmJZIoYd91b+qKv4a29GmQC7QXMfIkDY0jwQWsABp7P
 PIR87w76BLd/LZVbcsyhRapS0SBZIjFGHmqmg6zcEyiW+v52KVjmtHR0vvUm27WlMllJBYVd84M
 q75r3s0FthRy/9vjb/+Bdlsu3UWaCK+EPbIFiy4TttyVhDJcHJTU5oQYvGH4FMPRiXlEo7pEwuo
 9MbzftO3HeLqBDcJMs6TBwoLK3DAVyY65iAjNPoodrW11ZNqX7M4GQZLfc0gnKEIm5Khyn1cce0
 IpDmayJUTEwzZqMLhzCl1KGVSxPrCCXWHH0PscFba/U0LyZnVJcCMPRb9mTnSXAvrhL3LkUmhtX
 3XOgDDHwrmyF7rwXKxQ3MEvhd6b14ovbLElZYxHHHNY2qcp/0MYbR2B7Bf+kDZyuoYma353w6Ia
 6zGo3nnJaqC+mnO7y8A==
X-Authority-Analysis: v=2.4 cv=bZtmkePB c=1 sm=1 tr=0 ts=695d4931 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=5F_Si_21ch7HfeXunPMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: -WeA9x0ft7WeulYhav4rihOohgFpif1d
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C224100006
X-Stat-Signature: qyor4qfpbps5d5akw19i4bgi1ccihfmp
X-HE-Tag: 1767721269-949981
X-HE-Meta: U2FsdGVkX1/ed7xrBzQ5CkoGyixMlK8xXkZOcCn9jtarmHDBg1gXHcqgGLw+1DCocnFaNi5u00mOdaTVgiGAXb0+RzCDQvRiAV2J3J+8+bDwmX/3lOxWjORz6TN6OZn/lG2tNfYN+JUvG9cSLMqSlWDk6BGjFO4rPExfl79B00bCIOLbyINt8uK0nk1cYfpO7CgXewOhFcZkybQIiJ4iz79tP3lw9XokByL+PtPlnhRKF2Ac2uvO48eDo84eZ1EimYKhRcDADfL0XcMbObgMaqeNtMIUjK8dlLHmRzN2I7YrUEm9/qM9aOnqu8LJ4IxlWRMK1eb+4/feZElB6PYHgyFbiKuErDuukNirYTY5K+idkpuWC7rEAAarfBg9aIKJ0QMtDEReVKNtKug59uT8ApHILcEJtAVM6IgvzesgvdpRg2z5BHDRaUyazX66OcZO7kV6QxX39JJq11e0Bl+2QgNPQJeRU/FcWrEQpbTiE2EonALEk8jkYC8siqCN6foBzQhKbcr8lCUt00XLdI8VbZoM6OGN1/ry87Sd4GvmTE7uoLPePL540dL5RQtwUVQNcIpZx7ZcgbTFXEzuuYqj1OkcpgqOJX4nwjURi1ZYgLySjoeG7zjjkWosKyl7QPAr4sriMUH4Fl9S4pyYS6IcklPmuMWEY0yte1AKpszWKzjGJYkcOHCSRWcwJHNRzw7tOgWDJqAyLHXXlmSZ73HR8tqCkO9J7lxw7Tfpi2hfGOnL3rMvxXa/SSSJFHUvkl2vxzQmgQrL0rj0F0afHq2NJL3UaBf1weJA+AQ2kjEjjT8gZ0fHjBsOyTn/fd73eybi9ttzgi8OA2QWHK0tmBurRobMhz0fcKY2vgZ83i3cB3+e6SJOXJ6P3M54juCcG/evehbpRPrKNG89rjM0++Sqkl93u2RjqRiuu99DQTwduq7gIN2POtIDava7yOWxt1q8LvMGjrFcDN9XM66TAC0
 rkywaWNP
 VmEnRtYzjnbEnCIaX9+lYY+YZmPsgQEBFdWuTLvUgt3W/fbAMbltDq8VIOQUZlnbg7r03MDxmOlFlgw0nk/JHgqqS2kY+DRVENZgjpbJ5H9x7ZBMgymf5pB7rHj3Rs0u5UxeYAWriCQzEkUy//6kWu+1cn3omHRs/bmBpusOImmahazqcdJMKvJKLdDhXuvfKw9WVh4No4uFA8H0qv8Alq9W7kFdPaWChJRmS5dz5sUG/dJrXj1Ho/WDNd9FeUcWvvFGeW14Z4h5h7+Uztw/tNXCl+vzKZzRL29PhrWRx9j6R/119P1pGbr3vZ9H5+VtYkm25evhCVUnfMd15kEu6crj8Lq83Jholkcn8C2OHfs9zSsFbfM7Ux8iUqSceD2mLp869RvU7Iu2ZJT86bic8yiKP9TlZMpHhePEALpApa9dOqSUPhYqfk+UyIXWylQxKybeKJPVWJlRzJfJDLrO5UP0zg2FZ6hMcw8mTedCu8e7iltUMu9Aqt9w4n+8pkdoQr0X51kiN60X3Bds1WKoTBzSczXvrSfJ+9BSp2rJqkc9Y/s73+AmSlevXrdzhPhKGve/lACvggQ9Eey5yWSa3x3md8D20tTs8jgScyZpL8ek83sY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mikulas Patocka <mpatocka@redhat.com> [260105 15:08]:
> 
> 
> On Mon, 5 Jan 2026, Liam R. Howlett wrote:
> 
> > I may be missing context because I didn't get 1/3 of this patch set,
> > nor can I find it in my ML searching.  Nor did I get the cover letter,
> > or find it.  Is this series threaded?
> 
> You can ignore the patch 1/3, it just changes memory management test 
> suite.
> 
> > What you are doing is changing a really horrible loop across all VMAs,
> > that happens 4 times, to a less interruptible method.
> > 
> > I'm not sure I'm okay with this.  Everyone else does seem fine with it,
> > because userspace basically never checks error codes for a retry (or
> > really anything, and sometimes not even for an error at all).
> 
> Everyone else does seem fine because they don't use periodic signals :-)

I meant everyone else on this thread.

> 
> OpenCL is not the first thing that got broken by periodic signals. In the 
> past, I found bugs in Linux/alpha, Linux/hppa, Cygwin, Intel Software 
> Developer's Emulator regarding periodic signals. fork() was also buggy and 
> it was fixed by c3ad2c3b02e953ead2b8d52a0c9e70312930c3d0.
> 
> > But this could potentially have larger consequences for those
> > applications that register signal handlers, couldn't it?  That is, they
> > expect to get a return based on some existing code but now it won't
> > return and the application is forced to wait for all locks to be taken
> > regardless of how long it takes - or to force kill the application?
> 
> Do you have any userspace application that expects open("/dev/kfd") to be 
> interrupted with -EINTR and breaks when it isn't?

Your change doesn't just affect /dev/kfd though, it affects any call
path that leads to looping across all vmas four times in a row.

And since this could take a long time, I'm not sure it's a good idea to
stop responding to all non-fatal signal.

> 
> > We regularly get people requesting the default number of vmas be
> > increased.  This means that processes that approach max_map_count will
> > wait until 4 loops through the vmas before they can be interrupted, or
> > they have to kill the process.
> > 
> > > 
> > > For example, this bug happens when using OpenCL on AMDGPU. Sometimes,
> > > probing the OpenCL device fails (strace shows that open("/dev/kfd")
> > > failed with -EINTR). Sometimes we get the message "amdgpu:
> > > init_user_pages: Failed to register MMU notifier: -4" in the syslog.
> > 
> > If you only get the error message sometimes, does that mean there is
> > another signal check that isn't covered by this change - or another call
> > path?
> 
> This call path is also triggered by -EINTR from mm_take_all_locks: 
> "init_user_pages -> amdgpu_hmm_register -> mmu_interval_notifier_insert -> 
> mmu_notifier_register -> __mmu_notifier_register -> mm_take_all_locks -> 
> return -EINTR". I am not expert in the GPU code, so I don't know how much 
> serious it is.

Okay, so the other call paths also end up getting the -EINTR from this
function?  Can you please add that detail to the commit message?

This means that -EINTR can no longer be returned from open(), right?
Otherwise you are just reducing a race condition between open() and a
signal entering from your timer.

> 
> > > The bug can be reproduced with the following program.
> > > 
> > > To run this program, you need AMD graphics card and the package
> > > "rocm-opencl" installed. You must not have the package "mesa-opencl-icd"
> > > installed, because it redirects the default OpenCL implementation to
> > > itself.
> > 
> > I'm not saying it's wrong to change the signal handling, but this is
> > very much working around a bug in userspace constantly hammering a task
> > with signals and then is surprised there is a response that the kernel
> > was interrupted.
> > 
> > This seems to imply that all signal handling should only happen on fatal
> > signals?
> 
> No - the kernel should do what applications expect. open is (according to 
> the man page) supposed to be interrupted when opening slow devices (for 
> example fifo). I'm wondering whether /dev/kfd should be considered a slow 
> device or not.

I disagree.  The kernel should do what was agreed to in an API,
otherwise our whole deck of cards falls over.  We may not even have the
resources to do what the applications expect.  One could also code an
application that expects to violate the security of the system.

This is documented behaviour from the open() call, so it certainly
sounds like an issue if userspace doesn't expect this return.

Any other -EINTR system call will also cause you problems since you
continuously send signals to your process, so we'll have to change them
all for this to work?


> 
> > ...
> > > 
> > > I'm submitting this patch for the stable kernels, because this bug may
> > > cause random failures in any code that calls mm_take_all_locks.
> > 
> > They aren't random failures, they are a response to a signal sent to the
> > process that may be taking a very long time to do something.
> > 
> > I really don't see how continuously sending signals at a short interval
> > interrupting system calls can be considered random failures, especially
> > when the return is -EINTR which literally means "Interrupted system
> > call".  How else would you interrupt a system call, if not a signal?
> 
> The AMDGPU OpenCL implementation attempts to open /dev/kfd and if it gets 
> -EINTR, it behaves as if OpenCL were unavailable - it won't report itself 
> in clGetPlatformIDs and it will make clGetDeviceIDs fail.

This is the userspace ignoring what the error code means and just
aborting on any error.  This is a change in behaviour on the kernel side
to work around what they are doing.

It also sounds like it can be avoided by userspace not sending signals
during the open process, or even to retry at a higher level if a
recoverable error occurs.

Again, I'm not saying that this change isn't the right thing to do, but
it's not the kernels fault that userspace is aborting on -EINTR.  And
it's not the kernels fault that the userspace application is sending
signals during a system call that will respond to those signals.

This is changing the kernels behaviour to avoid having to deal with two
cascading failures in userspace: 1. The opencl not retrying on
interrupted open calls and 2. sending signals to a process in the middle
of a system call that will respond to signals.

I am saying that calling this a bug fix is wrong.

Even though Vlastimil has pointed out that this locking did not happen
prior to 7906d00cd1f6, the contract to userspace for the open() system
call could still return -EINTR and that change predates amdgpu's kfd in
2015.  So I don't consider the 'kernel broke userspace' argument in this
case.

> 
> So, we are dealing with random failures - any single signal received at 
> wrong time can make OpenCL fail.

I feel like we are working with two different definitions of random.  I
would consider a failure caused by a periodic signal to be an expected
and predictable event.

"random failures in any code that calls mm_take_all_locks" makes it
sound like we're going to hit some uninitialized variable that sometimes
isn't zero and exit, but really we're receiving a signal that may need
to do something within a reasonable amount of time.

> 
> Even if I disabled the periodic timer, the failure could be triggered by 
> other signals, for example SIGWINCH when the user resizes the terminal, or 
> SIGCHLD when a subprocess exits.

Those are also not random, they are expected signals caused by events.

I'm trying to say this git commit message is wrong and misleading.

> 
> > I feel like we are making the code less versatile to work around the
> > fact that userspace didn't realise that system calls could be
> > interrupted without a fatal signal.
> > 
> > And from that view, I consider this a functional change and not a bug
> > fix.
> > 
> > Thanks,
> > Liam
> 
> In practice, I use 10ms timer and I get occasional OpenCL failures. In the 
> test example, I used 50us timer, so that it is reproduced reliably - but 
> decreasing the timer frequency doesn't fix the failure, it just makes it 
> happen less often.

This does not fit my definition of random, bug, or failure.

Thanks,
Liam



