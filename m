Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70A03CF58C6
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2F26B00C7; Wed, 19 Nov 2025 13:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83496B00CD; Wed, 19 Nov 2025 13:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCDB6B00CE; Wed, 19 Nov 2025 13:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965C96B00C7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:16:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70FE64E859
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:16:49 +0000 (UTC)
X-FDA: 84128162538.05.902FE7A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE98C4000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:16:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eq4oBf65;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jOaul87F;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763576206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldTTzrcjvofBbRVndCdVj5YzLj+CmuX7q6BH6roZzfI=;
	b=ZblX2esfdgfNmfMZFKdJ5Vi8CvRTiYLLOZZmLk8S5l+kzgPusCt4crP1+JPkS2dwBBL0aa
	n/G+D99ci0r2Aremc1xk2f8CW7odfhfWKLk8cP/bj8RTpm825ZOpwVaNT8SNbeRzp2AkNX
	MjojaqtYFa2Hcu1TAxfClqnWWOHvmds=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763576206; a=rsa-sha256;
	cv=pass;
	b=4Q34wfCaoCBJw84vVuI0W0u11yIX04XHDSRiHqROtKDT1M5ubAluIWW3fpqN/j93PSruap
	7LSkCQsSJUf6pI/7aouauHMUprwJWM+6nkyy0T5Pb2ef3PgwGUhqj2JItnhkCYuhvYArbg
	Atr5ZuxFZu5nhEmfn/1sXedTDay9Zlg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eq4oBf65;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jOaul87F;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJH1Jmf027802;
	Wed, 19 Nov 2025 18:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ldTTzrcjvofBbRVndC
	dVj5YzLj+CmuX7q6BH6roZzfI=; b=eq4oBf656fbtKV/lY8zpZ+5joXyxSWapwi
	EY6DqFUhMp6kom8QjBB1YFuo0ZHEqHcAmNN1W1dXZJZb4BMCU2vHMlrHZ6Ux0VDv
	UdWK3NmrGdDqIbY0nj1IWIYCSJxluR0QXtvZvqiE/JajYaKc+hUfXoFYXr2iKbGK
	L730wUGGHMwcHpP4VY4P3iDvJkXRCREebSJ4NHogYNlyrFZ444ftjlDinbnsPt5d
	1GU+PyizjROKnpWxLw2guLQom0Tah3jhxta7ks1tDB353szIhZtHd5BwD5vmO2ls
	M/hxvk8M5WadTTzOd2N/3SCK9x9A9qfjpaiLyc1+pqnVvuQPm6qg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbuqfvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 18:16:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJGgRtT004268;
	Wed, 19 Nov 2025 18:16:34 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyaqsfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 18:16:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ujtMzDdYJPkoyb9qNCHqTxX38kNC2CxMeXxHRrjEEH5Twpq++jHP5jMSSv+hXU7tQ36w5TbqZfcnN6ZEPC/7msxpe/Tw2LcyQ6c98YCGd3Qt2qtmt6JDH+zmOlk+OBEMGV2nN3T72aweOEuhrA5pH1acLqDqFMnptApx/AhU4MJuQLbrxyW5Nzc8zwsd60tuU8+aRG9x/AC9nVYjw01tCJeyDZpjCR5q36Ds/YtfsYm2/dyNjnWzNjz2nxcVT7FDlFBJff4BjctkQb4V1MngljUboTQJVIGKa5BNTEiDpKacWnltHknWULQhnVD+EFRTeSvIIM8AONvufIn6L6mygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldTTzrcjvofBbRVndCdVj5YzLj+CmuX7q6BH6roZzfI=;
 b=H6P07cpQISbS1E6ZxINvw9YDsMo4l1fgVxIWFNWrXuFs0ULXtpoK+4PhKK7j9W7Fbp2VqOETQxWMP/HgScQGcNLKLG4rnv+CGrcu5ULUpXp/SIJn7nH/evcOOIiSIrwHX1Xy42kuZBRVkV4jjPDrw6a3Oatdh3jnX89JpK/eTzhETZK9TLRhLPXHDwpXCAKGv/vwdWbFQgtaKUkBL1/RkUiuR//5hAU0IrFtODaqNVbMoCX8+N4oHOSvNrOSDNlqV+suMK/jniE+iLSPT0zbT+YEK3FcFaNRTQz9HBLZMs0VHkc6236V9ptNvjq3bteWD8ZcYubMH9daAccALAOX6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldTTzrcjvofBbRVndCdVj5YzLj+CmuX7q6BH6roZzfI=;
 b=jOaul87F5rDtmBsvu66n5EIBNVlfMi2/CbBT3txVkfQ30xwgJy4zoDmiOfrMWcSg0708wU+D5XPuOEplFON9Av7Wl8iwGUT2YgwbentqfysBcxlCF7Uz3Ap+BsF4l80u8kmufDW6NjLQafvg7tqtR+X6MMY53TMXKhihVBZ+7Xk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 18:16:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 18:16:30 +0000
Date: Wed, 19 Nov 2025 18:16:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/khugepaged: return EAGAIN for transient dirty
 pages in MADV_COLLAPSE
Message-ID: <0efa89a3-2080-4daa-a190-2ced8e14ed9d@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <20251110113254.77822-3-shivankg@amd.com>
 <67325651-b7d5-40d0-a9f1-3009b61c8d3a@lucifer.local>
 <a2770a50-5732-4483-b958-4693f0f08c7e@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2770a50-5732-4483-b958-4693f0f08c7e@amd.com>
X-ClientProxiedBy: LO4P123CA0196.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: ec25a576-b274-4e34-5597-08de2797c373
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0ceopjMo34JrvuTF3aGutJRexxjg/R4pemvnTpbEX8zfCTjwVJxgQYxhnB9S?=
 =?us-ascii?Q?lxVbw6XPJcohPmtzD5+D8fsrU/86fxcpA4CT35Yc+xBc4LN9aEZJE0nQNveC?=
 =?us-ascii?Q?svehPPoYsXj7umYVf4WYU5w5OX29lj48IeKN/vJvxZzlGTR6ALnQCLObF6DT?=
 =?us-ascii?Q?AMSIqhp+tIIM/jtNVcnyYs5CaBqgszHj+JJs8n3hIcAXybb+87TFGccg6HNZ?=
 =?us-ascii?Q?V2r4ZvY9YgOZ15bm7pYzH+8gfWYAdNFk45Txq9/qWG2nGdnuZiAKEAL3A8KI?=
 =?us-ascii?Q?SYSAO1RkLQFc8jyTnzpzAOpVicw5zgzpsDP0zLzyOksVtPNlAPbmf6U7cXnE?=
 =?us-ascii?Q?BXJfE5MrCkOeYBcc1bVWmLKtAMD52uh3dieo+feuxajBOVuPn4ILm7PuPofG?=
 =?us-ascii?Q?QjcylGc0QL9nQydD0Y+9tw6q8rVf4R4Qf0VaF5D45eadgc+7FeErRr8W+SGJ?=
 =?us-ascii?Q?BITDiOdNFRSw9Z/+51pw6bX1XudqRd9iNh3sylTKOcPSOfB8tnGfV0spPjfo?=
 =?us-ascii?Q?f0sbAN/jSJm0TL/gXSqgjusFDhdKfvR0wzu5FRkF78PHM6z7aASLuAZisuZb?=
 =?us-ascii?Q?wIJ24mn8o6g/NKQSJRBSTJ4TvCl5l9ZkmLlm3uewQVlgbNNchHsa1R+gH44e?=
 =?us-ascii?Q?d4mWMCRgUgOYHaM5tk422nzNUm9B7iioagHDBVNc7vc7awiF0TKwYOXmRgZ9?=
 =?us-ascii?Q?VHMMI8iAslY9HWvMQ+p3efio5yWd+weU3ns2c2DWXH0Bseaqnn921qxqPpHg?=
 =?us-ascii?Q?54nBCCnhH0lcZ005E8XYAm5/lCvEIHAvE/SaMF+ObnjTzBzOfa7p/P/xbYbg?=
 =?us-ascii?Q?CqA9CiTuQ7Rqg74p4viPloZbBVCF/E0IprUa3Q5bVC6UR0zcwTlO3OchXHp9?=
 =?us-ascii?Q?QhIE1tWOQuMab5xoyfvDfapi8BqJXC+r7P5ZqULPtJ11X6p+jG/+3uZEY0jp?=
 =?us-ascii?Q?UomGJyuXlZP9AaFxfkef2ynei8aQUHnyP8Yj8kJ38Z/oKCArKu03jF0QQlUk?=
 =?us-ascii?Q?DdQm1yxvqglLoGos3pzQKFKUnEDXcpajCjIYFCDltHfRiRz7KQLMiUAPGqQX?=
 =?us-ascii?Q?xqW+G8Iets0YIZUOsl61wyQ0pUJ5MB49YcyZ6ewRNHe4IbX/XGt3hkGFda70?=
 =?us-ascii?Q?FQ9QfwJoUTTNT/V69OeI0Xp7xCSYfDqytLHtN2H9fxOY7jS+edFux2bsN9xP?=
 =?us-ascii?Q?oV7OP/7gVGR4HXld4Ju6SYaTb4dIP4ZXiTpyLr8bPskOFgEwor5h7OK0sUH7?=
 =?us-ascii?Q?LTwqdH8dzEbubx/1JL1xH0swJjgMTA/4IeZAxH/7l/X1fWgq338TgnOsWXqz?=
 =?us-ascii?Q?X/+V65iDTyFoZREn2fBKkKhMkPjLfJ5RG1obAuB6S2nOmg8+oLR6eFddqSd0?=
 =?us-ascii?Q?WE6UbBFw8MKn3yQQOw8qc2Ph0AZwfnVAAFfY3WOHEc9jZlu+gJZtxGjq86xI?=
 =?us-ascii?Q?1KdsG1xbB/HV/2NfojA2wCMR7kMvOirF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Iib4XBc25P1lXDX/JfPT4jVEeDeSQdTu1cjZzCkCpGCbtMmNVtgqkHnB/oM?=
 =?us-ascii?Q?tVcdeLYDb09KLWaJnXS44Zd+FKnPM4JZ+RPpmP7Nz6biQxZfuNWZHFlJpzdL?=
 =?us-ascii?Q?RwyyY9APs/KukUDgky6DWUbzMIBU86ybZXL/H4kqSi1d29Zo5r0jeMrORh7c?=
 =?us-ascii?Q?YIzU3GvEXLDQl/1BJG8STO/u3iOzJ2pBlaPV5RodULivwcAinkm7abo0J4wY?=
 =?us-ascii?Q?qPfz6KkvDtZqxeezd4hImUMf2wS4RHiBexFsR3DJ5m85qHb4N4iP6ZYwFCUx?=
 =?us-ascii?Q?XkhB2NzMe2dcy0bQ9zbL53nXcD46AZ/zRgVP5YveTwc3Sdy2xsV0IUHQ6qGE?=
 =?us-ascii?Q?zZ+eZSBJEago15hmNs8EgXEN7J1NP1MjvrD0PZagED7tlJ1qAwOp5594/VbA?=
 =?us-ascii?Q?T1akeyhnugqidiu5baDdYlpEyADXZcTd5YIzSqnPOpOnmrh/0FX3OMSWT5Uc?=
 =?us-ascii?Q?D5rGCcITOQeizOnElgyQcFxCt/esdOvyyTjQoeBGmPkShZq6Lgsb8dBlvi6Q?=
 =?us-ascii?Q?dG5uc/3AqP8etEnMsyCF8CmHnJ6dOo4756cv5jcxdydb5JyeJz1OO5418zuY?=
 =?us-ascii?Q?2gae8nokVOC23QrFbQipXEXr8YXH4BZ4pHk5PMvOcWvmRy9QMuR6VnTVo3Kj?=
 =?us-ascii?Q?XbO9iIiBJ14/BZ3zOYMK4WlmgL7KrcIYQBYR5Ti9/1fQI/wI1L0EwkQMIr6T?=
 =?us-ascii?Q?CiAbykp9Saqpyz6gBJTT5A/G/KNi1OdaXEAhWS6em9X9jcoR/5hqxAKmmtLN?=
 =?us-ascii?Q?eBbXiflDfnZEshchjtBYxXuzbwh1HAZRv+ucbr26k0OrMx6sbv4aE0AEDyML?=
 =?us-ascii?Q?V3L7esddgf6mMPVaXfPaCJxono+95MRmRk5gLkW77RTfAAPCRMPTwVMNWxMK?=
 =?us-ascii?Q?OI75J3gtgn4EfspH9Hc0Mo71+dFs298jnyIrJkNXBSR+WFHmVXnk5QjysRDx?=
 =?us-ascii?Q?GFJI0kLEwifzJL5Pu0PUPe0mU7dhFx9LOxV4YMOcSzNXhibz8HBsVgZERCWF?=
 =?us-ascii?Q?7h+tKuRu9J/YIM6z5q6pEg/xgFxNiJ7ijUdBh0OLubLzB6tic48OtJBFcmhS?=
 =?us-ascii?Q?180yZtJj0raATGITZLbgSGBdJNFGmjauGZch1OvFtk/fTFxALakv5wKiiHzz?=
 =?us-ascii?Q?4+cVIo3zdBOukzKXWrSHnuwtSx4EN0Qkhgno8o6cg3CBp89rBohEz+xGKveC?=
 =?us-ascii?Q?hH9CgCV2tl6SNQOIOm/0uyus++V0Zk0QM9ZU8NXSlBqKHvolJBLCUVFuP9nS?=
 =?us-ascii?Q?vMtHzk0TQBGdU/Gjt1FlrmiLquWjltLsHXexhYHlPMa22JUTx/GpajTJ+oKy?=
 =?us-ascii?Q?YDySx7kyTLsRf3MPwqNLp5mtwziwgBN7839p9qMd9+6iACcjdR6EiPoS8B3b?=
 =?us-ascii?Q?V61QAUwuFoRK2lXUBJFNFvPRfvMIIw6UrFhLvYfm52RsUeEOgOYsmvlBnjd2?=
 =?us-ascii?Q?8/1FFRieMLq6wcGItvzFJztJmlITOk0ehoBN6Wref7Ij0nfUXtvA6PhSCCN5?=
 =?us-ascii?Q?O3HErG1IUONpjC/V/iavEhuR+bGQ/KCLHgEkCbpg0UhW6aFRCufQQvP8T8LA?=
 =?us-ascii?Q?imvGLv/8u7OKoDxkb4nEElXHEZd6LC+l3fZXlUAqRQjEQbpCToe5MPnUR685?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W4zJi+yu1dsVD5zf3J6oRpID2eo8EhPcIcsNAzCcB9mQ1jY5WYsBuVN0bsbLYG3/6Nx/yOuTXLk9a0SOBBZzhxOlJkZIKSObPSJ6owJP+YY43WiTLvRJy4QgPMecv5stbh4UNnBH/Dpl9zANS2ysR/0fhi/4FSNCk1YasvJ/HeQjBmdXdEv1V3Ndi36Bzwl/dMjG9pmO3V6gp1Mt3QBRpl5ZoYexDomvHW6emjf+bIzssac87YAJpTC/QDddfwKRY6LNBj/3adqOKFlpU3QOvsU5ElR/nsqdHU0Ww/pefzFuACGAxupLa+vkqmbtKQkXAHze7Dk/lIKKA/CsGcsFgMM6c/OhRUW17WsxsLP/k0k0ABeFKgvu0Kn/V41TLuwBArGJ4pe/miE/Pp0yM/fkt6xSWIf0ElUP0EVAPvDqMEjxekeWNe4FUCEKGGoUmzZWEcoFn6fMvEK1HeUmnirtJwsAd9Yb8r/1b9vEU8mw2buXKqR7YzZj6UeLP9tT88i5AqlJyt4ugJJmGn56L/uIyqb86sF2rw8/dpnUhq9uNgX4yrNmg4NJrybNhwDrqPBPRXW9w40pUxs+pqzfZI0TtvlBrXCSkb6zwQtwG48GlVc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec25a576-b274-4e34-5597-08de2797c373
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 18:16:30.7421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKRePHIADmzieEKKp6g7HQDmsXOJB67JjwSC5lkQRHhPKAADFWa1IvBoN4bH/etiQVzm/mJ/gaS5Ry5bMAisCeGUzGCsSRsgIV8Btz0ZA28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_05,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511190144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX1sCnluERnWv1
 XYQq3j0g2nZD7AF7qLVJGT2KU3Fw29jqwVD1sxOPO3OjaOx8hYu7hlLJ32Kqd6pss8kP9UBHoT1
 hElxlY1wWWF9uq1KhRfU5O5g0EgEMf5d/ndu2M3pWZu//0Cq090Z9J4RP5RiX4SJMbzYMel1aYj
 WhUQrLN3vFPLxYJbBi9FDXEN60IfGGtu8QgN+86QRzctojTBMrS0okvqFd4lF5bYS7G06ZV+Xtl
 BqY58521Xy514J+nxm7MWgW1HXdmHaWs0rHIWICM3r097utEF+IoQGDcMJ0v4oKDJQ8rLh2Y2kP
 3PGBPv0w8nPWDcOTFzu7MxDbIwEl343DeMVWzcgFqifW38AepJVTSoP6W/QFCLeq07FBbGekX5m
 CAe9nZQH5EvHIAdR6acquV7fltAEiA==
X-Proofpoint-GUID: 7-vwkfhXPuVFUz-6iUSxky14OzsvHTmc
X-Proofpoint-ORIG-GUID: 7-vwkfhXPuVFUz-6iUSxky14OzsvHTmc
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691e0983 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zd2uoN0lAAAA:8 a=yPCof4ZbAAAA:8 a=HwWspdlWF_RiHFDO1V0A:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: uhjuyqmyq369uotujmpgib75znsqiu4r
X-Rspam-User: 
X-Rspamd-Queue-Id: DE98C4000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763576205-486855
X-HE-Meta: U2FsdGVkX1+coI+NJyY4T977Tz+y1fPxzPoqJcXxBGsmAWPKwGbH0axJ/QQ9R2v/8YUKQgLPbaf7tLdAPtdk9azfQfTV+QePtk4j0DwntftRYNoK547VPmrpRhWKYzAYAxxLe9EbFkNxcYKpWyF9/5xlzAT5EfNmXcROEyLXNpH4YrXF81iA9BAKfR80H5BLOpbI8TTbuCQ8Myajhs3k6onaYfbERZ9NE+Nr+pybg/3vDPL8/EGpOPhTqW0xYiZguL4YFw3dtgecyFL8R71vU4lYA8Whhbfw0ej66QhghpvYAXmbPaXQrz5lCybjGaA2Dr76X8OkEWplVeJgRg2SMspKFTbwTvRssz/epWF9p7eDGhXi54nUj/ax1ix2BbiZFoqXjzCkUYbErdKeCCAYJeMGWBD+mSOUntBUJbFB4Qyhb+eGWYoDynlKREfLOz5K3HYMEgkhQG/kgSy1jK6ADKax8sqBglm/R8x/paLfVF+C+2ka60U+avnDWmhIMKbsCc43jc9x9PKe/vyvJtdwprqBkT93TVo1yjoQfSUKHg0szdgUU/5hBZeogcC8DNZVkk/1qTOQCZnkeUUt6Gf1Iaa5V3GyGRBvMGdpBXFJE4s1HU4e2DSlx7fLTcnfZ38a45/7saMUjdk3RNdsmi8WcGj3h7VGahf+M4Pr0Q2ye/DRXHjSUspQiYaeF0Dqonojx16/jr1GjjjSrokXUTjZv18l9c2Bj8SjaYWVDTwrthT8q58Y8/MNBKkBXd1tj+f1pCmFLHbou6lXfQicqHEVkJgiay1mzYt/G2+Z+EpoAOGTYWU2UqZsE1aNg74pf9EqunW3ALtZfS8pi7WkQ5CR4avJe5qLCkIUqokLEMjvG1Ux7EYxODCZY8mfnP81j/pvew0e/Xn01Iq/xubqmDeuDDvNLV7Z8X6EdqMZJZCL1czI38e8WSMbs3sHO5oES91MsQzwMoxP9CcpIfHO33n
 UN/PeTZr
 GTZWleLIupwF7jbJjPv7p3+ysW0s59bWensy1+Xrx/IN1hKMyRO00Um+6JP/FA3ZRxwARqk+LKvMvCJFgoVxA9On6wwfbJnZKrDwLX3c74HhcPyFQT/W6OiQ8n7kL1rTL6JYfXxFfVfFRQHJ0ObE9UjORAVsgRI1SlbDh/HtYN92jkiqNkDCGyw53UA2UO3mWYCJok7AUg5ffSn+1pvEiJ+L5V37C7YQXBddBriMW+u6T/lce8ACFnRZ//jvjY3RXTHMzJ3bkkRFg9SVDsRC/1tZ8JHVfDjoU/yU9VymGtenkwUVL9Q+Daxwtw4FS7sGt/MTotHe4nowcMa/AQwB7pbV4cHbdKdkN63oOGXMSUc9gpRy99PI30xOiUtI+1BmO8dO1De+yGwkrknwVL6If0hn1GjDYkJMCdfhoHd6o2suRjs5owt38fqJhHVkbbYHthGA/o3XbXZzZlyk7l875RYF4lCq2IEygaA/EzjuB2Hkl9BYptVqdMxXWIxCcfxbE0WTcLRjEwYgA5wopvzBCd9wy4alIyW48g8krS6UCvon3v5pWRcnogp6mtOpvCph1xpzMYvxU2hyhh+b/xjiTqKrXfrHTPXQcgGpNrKe7pI+IBQVtAPNVMmUevuMhO7NvrtgZ+iZAzeS1XwW6OUYHqDs9tnFgJQS47GRmI/VIbS3DSrA9Rj9q/z0Erw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:55:29PM +0530, Garg, Shivank wrote:
>
>
> On 11/10/2025 5:26 PM, Lorenzo Stoakes wrote:
> > Please, please, please send a cover letter when there's > 1 patch :)
> >
> > This 2/2 replying to 1/2 is a pain (not your fault that perhaps you're not aware
> > of typical mm series style but FYI :P)
> >
> Sure, will do this in V2 (posting today).
>
> > Also there is some tiny conflict on khugepaged.c in mm-new, but it's literally 1
> > #include so probably nothing to worry about.
> > > On Mon, Nov 10, 2025 at 11:32:55AM +0000, Shivank Garg wrote:
> >> When MADV_COLLAPSE encounters dirty file-backed pages, it currently
> >> returns -EINVAL, this is misleading as EINVAL suggests invalid arguments,
> >> whereas dirty pages are a transient condition that may resolve on retry.
> >>
> >> Introduce SCAN_PAGE_DIRTY and map it to -EAGAIN. For khugepaged, this
> >> is harmless as it will revisit the range after async writeback completes.
> >>
> >> Signed-off-by: Shivank Garg <shivankg@amd.com>
> >
> > With comments below addressed, LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Thank you for the review.
> >
> >> ---
> >>  include/trace/events/huge_memory.h | 3 ++-
> >>  mm/khugepaged.c                    | 4 +++-
> >>  2 files changed, 5 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> >> index dd94d14a2427..9014a9bbe64c 100644
> >> --- a/include/trace/events/huge_memory.h
> >> +++ b/include/trace/events/huge_memory.h
> >> @@ -38,7 +38,8 @@
> >>  	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
> >>  	EM( SCAN_STORE_FAILED,		"store_failed")			\
> >>  	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
> >> -	EMe(SCAN_PAGE_FILLED,		"page_filled")
> >> +	EM(SCAN_PAGE_FILLED,		"page_filled")			\
> >> +	EMe(SCAN_PAGE_DIRTY,		"page_dirty")
> >>
> >>  #undef EM
> >>  #undef EMe
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index d08ed6eb9ce1..7df329c9c87d 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -60,6 +60,7 @@ enum scan_result {
> >>  	SCAN_STORE_FAILED,
> >>  	SCAN_COPY_MC,
> >>  	SCAN_PAGE_FILLED,
> >> +	SCAN_PAGE_DIRTY,
> >
> > it feels like a lot to add a scan result for this, but I mean... probably
> > actually valid.
> >
> >>  };
> >>
> >>  #define CREATE_TRACE_POINTS
> >> @@ -1967,7 +1968,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
> >>  				 */
> >>  				xas_unlock_irq(&xas);
> >>  				filemap_flush(mapping);
> >> -				result = SCAN_FAIL;
> >> +				result = SCAN_PAGE_DIRTY;
> >>  				goto xa_unlocked;
> >
> > Hmmm shmem dirty is going to be weird but we also have:
> >
> > 		if (!is_shmem && (folio_test_dirty(folio) ||
> > 				  folio_test_writeback(folio))) {
> > 			/*
> > 			 * khugepaged only works on read-only fd, so this
> > 			 * folio is dirty because it hasn't been flushed
> > 			 * since first write.
> > 			 */
> > 			result = SCAN_FAIL;
> > 			goto out_unlock;
> > 		}
> >
> > It's weird though, why would we have writeback, surely handled by swap, and
> > won't it be like anon, i.e. pretty well always dirty? This comment seems
> > copy/pasta wrong.
> >
> > We do need to at least mention in commit message that shmem is explicitly
> > excluded.
> >
>
> Looking at the code, the dirty/writeback checks where I'm making changes
> are all in the !is_shmem branch, so it only affects regular files, not
> shmem.

Yeah sorry I think I was being somehow blind to the fact that each
dirty/writeback test has !is_shmem, esp. given I literally quote it there :)

So err ignore me I think here haha

>
> Should I mention in the commit message that these changes are limited
> to regular files and don't affect shmem?

No that's fine.

>
> I'm not sure I fully understood your concern on shmem. Could you please elaborate?

Yeah I think I just misread the code after a long day :P

>
> Thanks,
> Shivank

Cheers, Lorenzo

>
>
> >
> >>  			} else if (folio_test_writeback(folio)) {
> >>  				xas_unlock_irq(&xas);
> >> @@ -2747,6 +2748,7 @@ static int madvise_collapse_errno(enum scan_result r)
> >>  	case SCAN_PAGE_LRU:
> >>  	case SCAN_DEL_PAGE_LRU:
> >>  	case SCAN_PAGE_FILLED:
> >> +	case SCAN_PAGE_DIRTY:
> >>  		return -EAGAIN;
> >>  	/*
> >>  	 * Other: Trying again likely not to succeed / error intrinsic to
> >> --
> >> 2.43.0
> >>
>

