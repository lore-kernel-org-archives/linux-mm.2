Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAF9C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2D16B0088; Wed,  6 Aug 2025 16:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C7E6B009B; Wed,  6 Aug 2025 16:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6476B009D; Wed,  6 Aug 2025 16:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 48B7A6B0088
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:08:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EBFE1DCD82
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:08:25 +0000 (UTC)
X-FDA: 83747419770.03.8386DCF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0584D180013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:08:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Or2iH4qh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CfZ5xoEm;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754510902; a=rsa-sha256;
	cv=pass;
	b=r8roktmtOwHf5Ll19m4XNX3SDlRyQBU3umU18XcrD0T19/EHgeyqHfBHi1bSc/pE+JQqio
	UdhR0/rzgxdRAkYgwhWp8pHJv55mnf0QJ/fLwpc9M0ut1YCOySaOXeNpJwPF+5/3Pv5N/Z
	lZbkpNuFLWPvobmD07xPPeaIG19wdKk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Or2iH4qh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CfZ5xoEm;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754510902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9u1p6caezmmVBTcaBUGXUm6MX0Yleq3CI4BxExTFXk=;
	b=ElO4bD03LubnBKOqJZkPPC0JkS+RHqf0lrYzxYsFaM6Z9bFPuHDqzZZF9eF1qNupYHEu2h
	62bB12djubRGx46o4yzlTU68KwTMPiBDGdD6B/mZpHRY+1kSgutEzFv3t2NfKJNHCrs2Dp
	MSUJw27A3boXPNLf+wZHKaSFCJn2GFY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576GRQT2026062;
	Wed, 6 Aug 2025 20:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=e9u1p6caezmmVBTcaBUGXUm6MX0Yleq3CI4BxExTFXk=; b=
	Or2iH4qhxzU5+CLolkhgTINXhowYLpY8JZxtdGVf78drzLH5JBuXvdY9NrSvHWvR
	Zw5pZbfhcV/Tvn24Qg+xNBmAvJgVeYII9rCtpiqK/q28EG2c2LjCJcRxrfMCj5FF
	Td2ysJvq2/FbX4Tudx6SR0tfDg9sA6w3FiAzHEhVsFYtJDmogdyx8K6ajnp5CzMY
	r+9rVGjhKwwftpjGHEK6TPKH/t8ogQT/8zsY9NU3p44lFuC/LpssqDnodmRvcRqm
	6TEFAuCBEo+RPE94rgzNw9jzzsUUyHNw5dfFzOVjAT2WB3XcX/jQimJEZDLa03bA
	26mSc5LZL9FV4me8YShFrg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg2kjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 20:08:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576JqQ8D027056;
	Wed, 6 Aug 2025 20:08:15 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwng302-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 20:08:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KWQX/gTd7HQpB9n93SEGHVmYYBvz6jUAa++rLeI1Ki4pHpml1crhkYJrnmMBIeXZ0aZ6QCPRx49TZq3GuLbMuxTzlbpTdXweuVd9r19nkWJwSGihkMLcYQut3bA0TzVpyqOSdLxnp2O2+/NL9SBqeU3tPlnEe6VoXnYr/o/REveWBBIBBbIfgmo8w1IhjpmjnwX07VVCd6m7K35EVn/gHO9NK+GejGVykUUpgtpOvnG+52fcFRmQKEwVjCRDqSGXEGduDQ6FmN8bnXCyL/BVk91pEEsZQTl266vxWVAEmhUUPGtSK0kZ4K5SyBpW4SBIicG+KdkmDCXobRpM0i7t8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9u1p6caezmmVBTcaBUGXUm6MX0Yleq3CI4BxExTFXk=;
 b=UOnnm/4qGoyAmsMVmuey3LdSzmDiBnqC3ahfUQV+IKhkoPUB8ZJDxP/S/nndEuVSadFpfS5Nh22DrsasetFie01Qcs0v/wqRyV296pjO3NfHiPcQi4agvnvOKPdV0Mgqhxv5nHnAZG+8Vo+O9zp4RWMgxivdO1SJ50j+zhNx0oxo7ps8HYJxriCFrY7/IVieIvzF90UsUpOh+d1GLhxDrPIulvBXNpc2uiqXQ0JXVSQ1gVivhelTNObf/PTgYVdlxWAnAVzjEFw8eT6eqKnNymjKSX4AVr5oKW7twPsQU9SHrhDyIVNlt/4DGUn0edarT4aTO17G8zpb0EZT2FLM1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9u1p6caezmmVBTcaBUGXUm6MX0Yleq3CI4BxExTFXk=;
 b=CfZ5xoEmqAaSwKeCjkxQlHyZlPGybpvaF5yHMdAK2BGWMIpJ/HvEe32SvN0t32cfAtnAN6Cb7a61hbCH1vok53hblm0wcefJldVNbNaL7nNMy1E/93GKzq7hDcqmUUfmVQqcI00e1UDqMkFKNH+prCuZHuDS2G85KkIR9HWnZrQ=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA1PR10MB5996.namprd10.prod.outlook.com (2603:10b6:208:3ec::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 20:08:10 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Wed, 6 Aug 2025
 20:08:10 +0000
Message-ID: <3a09c30d-9a9f-42b0-b831-925b4533a196@oracle.com>
Date: Wed, 6 Aug 2025 13:08:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] mm: hugetlb: remove struct hstate from
 init_new_hugetlb_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-6-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250802073107.2787975-6-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:a03:40::44) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA1PR10MB5996:EE_
X-MS-Office365-Filtering-Correlation-Id: 04ed5556-62d4-4e55-c88c-08ddd524f798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDBvL0syb2ZkZmJudjQyM2dzMTFxSDQzS3hDMGdXYmhVK0o5V2FFTlZXVndu?=
 =?utf-8?B?VlJDOGZJZXFVSFh3N2J5dm5XV2NtUkFzNzBEWGdXdE1ZL1N3ZSt6SzRhY1Rm?=
 =?utf-8?B?MGduaFhDNmtyaVk0L21TZkJZc20vYU5ScTJKc1JINkg2Yzl5VjE1MGw1Sk5Q?=
 =?utf-8?B?ckdVTkphNjNsV3JYTmY0TitvQ0srVGs4ZTZFVTV5Y1RBeSszNDhKaHRJRS92?=
 =?utf-8?B?NnpSU0RybnlpZ0YzWGJxRk1wbWdrTHR6ak1hQ21tbnd2WTNHWGJwbmNyeGpU?=
 =?utf-8?B?SFFaNlBod25Eb2FKeTVBTmp2Zkw0ZW1OZzJ5NGh4MzRkL1ZKeGtSWVozektE?=
 =?utf-8?B?RnQyVGFEaGRVblR3OUY1d1J1YUcvUE02eU4rTHIxYmthcHZXMkxNM1FPZmhz?=
 =?utf-8?B?KzdBUWdlU1JPNEM3Z2tpb2h6cnBZZVVjTWFlU1FCclM3eDBpVVg5Ynd1VTVi?=
 =?utf-8?B?Y0lCRFVKQVlZWjF2L2sraUZNdExKNGhJOXlXZXg2Rm9tcEhRWURyV3E5aDFL?=
 =?utf-8?B?b0w4SmhYS3FDa21pd1ZlK2tqNE9JeXFrV0R3c2ErWWMrR083SWxkRmlXdnRY?=
 =?utf-8?B?QmpqQlBQUmh2RmNSVS9tSmFsT2grOXpUQXA2S0hxQWljeHdOVy9MclgyekR0?=
 =?utf-8?B?V2NHNjhFZUY5MllVU2ExTHF4OXE2a3VSTXdiZWNZejZYQ0pHY3ppd1FzVWdk?=
 =?utf-8?B?eWx5S0wvb3hGdUVyVUFZZkNaLzRUaFpLTFc2emw2STFJNlcrcGRQTXUwd05r?=
 =?utf-8?B?TWErSytJTHJhN085ZGlVekpqMUwzbk94RlNhUzdaeHY4MlZVZlVFQlN6VThF?=
 =?utf-8?B?SkdPZlNMdit2VGFqblArT3k3blNyUTkyZ2VnMFhqaDBLMVBURlR1ZkgveFM2?=
 =?utf-8?B?RmdOL3JHSEFETTV6K1RxQW9oL2JGRlVPc3VoS1Y4aUlGMmY4VWxlVk02UVRR?=
 =?utf-8?B?TVI2U2w0R1l4L3dML0dvUzdtUk5QQ3BvaHd3VzMvSlF6ZWxESkZycE1HeEFC?=
 =?utf-8?B?Um1QRGFyQ1FiMmh2Y2VpNU9PUm1NeU9SK1VpaGJBUEN5MnM2QW5pWmRjYnZ2?=
 =?utf-8?B?SmwzazJJclpveHpHR09uUUdESG5uRTBiWlE0UFJZYTJZVFExcXg4VzB1U2JM?=
 =?utf-8?B?Z0s4RmR3WFdMMTRNQWJzaGdWMHBLMTVKMzkwczVtK2cwSzJrbmxKbDNlM05x?=
 =?utf-8?B?eXUyMUZ0YWg5a3Rhdi9sVDZpME1yMi9TVEF3VlN4b3pJdlJMM203OG5TVjZx?=
 =?utf-8?B?TGpQTEZ3ZlM5TXNWc2gzaVBIWTFJaWJaK3E3OXlnVUlNbTVjKys5SndpK2lP?=
 =?utf-8?B?bFhmZkZYS2Zsazd1M3Q2UUdvR0J6ZkZQQXdZcVRHdGV4cFkyWTcxQjRCZW9X?=
 =?utf-8?B?RHdYMjFDYitrMnNyVEpGcllkK3dJVWMzU0J1UjB0TC8rQTk5SFdXVzN4K1Rm?=
 =?utf-8?B?YW5HTXU5UU81bG9DU0VnVHdEUEZVZWd6R1A5ZWsrUm03T3JJL0V0V0RPUi9j?=
 =?utf-8?B?RVo2VkxnQ3ZkM3FlNDFneFV3aXcvaVN3d1JYSUl4NjRINkljRmdzMDMyYThC?=
 =?utf-8?B?VEU3bWpaNlU3c2N0M1BhSWd2QnZJU0xjRUtMTjBNdk1NRlVTbFNUdHRVcWhr?=
 =?utf-8?B?VkNqaHpSZVBNNGVjRUprM1dFeitLQ2FIbDJpZ21aN3p4NEN4TjVQOHZIUVhy?=
 =?utf-8?B?TkVGbUdjQnBPWDNVRVFtblVHRFZkcEJvZTdWeUlsbkx3cGpRbU1zMFQvL1dl?=
 =?utf-8?B?TkhjV3NTU0lqcVVEYTZHT1ArWk9PWnZlbW5VOXRZZzdtT2hmMW1rQ3IzaFdq?=
 =?utf-8?B?bk5mVzNKWWNRSHY3eFdPdHBDQWlaZW44akRrSFphbGVDbTA5RTc3Z2ZaZWt0?=
 =?utf-8?B?cHhGR3JnRFAyOVpvVUhsUy9GSFlwV1F3U0J4YXdDbUZxOGdlMzZwemFENzh4?=
 =?utf-8?Q?we3sEeHqL0A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cm5PaGphejNONHhPaHZ2RDlDZ3dzZVNSR1lENTdkSSsydzdOYnA3aWZNRUt3?=
 =?utf-8?B?Nmxac2o2cE4rR0NnS1FmQUdzdUx6bHd1ZmY5b1IvbnpEdUNUdGRVdkJ1S0R5?=
 =?utf-8?B?WldqZ0J6cENoUm91VFNjT0NydUpVM3NxWlhRcjVKRXhVcHhWbSt0b2NuVERq?=
 =?utf-8?B?SU5aUkdmcGc3Rzd6RURKYU9Ccnkzay9ScU1FckIxVndQeWdPMWdHZ3ZjZEpw?=
 =?utf-8?B?RkFRY3cwaHQwVGVTRnl1WUE1bWY3MWtRcHpYa2l6R1R3bDdqM3Q0TzNzWlgw?=
 =?utf-8?B?QmNiUEJlWXExb2oxVEc4dlJjYXZGenlUdDZ1LzhaYSt0OFpCSGpIUlEvYU5m?=
 =?utf-8?B?TGRFZ2diVkE0VFNFZDFQNTBVZlRNTUNiNC9VaGJtSlBEemo0aFpkYXNsSHRI?=
 =?utf-8?B?R2ljeE9sYllGTXk0OHRLYndiTUp3dnlITU9aL3UrcFNDcDNWRm1tNC9pSHNX?=
 =?utf-8?B?TllESlZ5TjFFWEJSVVl3ZjR3VmhLa3RmNDdjNVZMc1hRd0p2M3VVbCtqVStH?=
 =?utf-8?B?REdob1JZS2RXaGJ4M3Evd0wvRHdLbm0wRlRROStBdjVDZnVSUHoyb2dsWFli?=
 =?utf-8?B?UDN0SmdiWlJRNXgvMG5XdmtmTmpPTFF2ZjFzbFUxQXpwL1lrdi9NY1RSdGRC?=
 =?utf-8?B?UTVRdkNUdU9YSHFDYUpPUjdLdElSY0t6OXZmMmpkVG5SMTZiZWszZm9WZGJy?=
 =?utf-8?B?QTB1ZmFneWlvVGV6NUpFREwrbHlpV1NMUVFLYUhubTdlS1Jtd1AzcEtmUjJj?=
 =?utf-8?B?TUpMaVdpR3dCMDJ3RWhKWjRKZXk4RWo4UklHNG9NTXhFeUNTOGJtaXJkWkhX?=
 =?utf-8?B?M2RoeFRjdW5xS2Jra3o5cFVxcEVUelN3dzQrZkVqNlJlKzFad285blFIRGlV?=
 =?utf-8?B?ZDhxY2NBdU0wUmV6bldUbzlmNmltelA2Qk55eENBOXA3UE1ZclZLUk5JN3Jt?=
 =?utf-8?B?eVBFNFJHQWM3a1MwblRmZ0NLTHBBVDJ6WEE3TCtubkpKMEpRbkl1K2lMWGpR?=
 =?utf-8?B?SFBtWi95aFRRTzVYZXBaZC91cDVHMXM4WG1zU0htYmp4enVWVnJGekRURmhY?=
 =?utf-8?B?a3p5VnJpQXdIMkVsdC9BQ2NELzJBZHFER3JkOUR2S1RzMFB5UjZGa3EzMVho?=
 =?utf-8?B?RkJpK2xYZWV6RUdQK0ZlK3dyb2crN2pqeFBIWXJXb0d2bzdRa050R1FqK0xM?=
 =?utf-8?B?WjJzd1VUVS9yU2VaY3A3Z2ZxdkU0TEFhZzB2UkJwK1kvbGNONmlDNEhDbU5I?=
 =?utf-8?B?VFI0Q2ZHMGFsaVFiQ2YrbjVZTHQxSmE4TiswOXVPUlpadzl5RWJOYTF2S05p?=
 =?utf-8?B?cDgzMmdMK0I2U1ZqUzFIWVRjWVpmc0NJWDMzQ2k0K2xzME1pVkVJY29xMXRm?=
 =?utf-8?B?N0t5ZGtjS1RhYm9CRDNWdzlsNEpCOStRZmtMb0NubWY1V3NzMWtVeHNjbCtS?=
 =?utf-8?B?azVwN2xubUNpeldyaFZLbUZpU2tyQjJzeUdHV21GUkVTTHp3bXo4bmc5NHR0?=
 =?utf-8?B?N3ptVU1IMndqelpFUFpzQmZabGZEMU1jUjVocTRCZCs3dFFaVGxEaGp1QUx3?=
 =?utf-8?B?Q0thLytEaHVHK0N5RUFDZzNlOHNZOGdlekdieldvQSs1dFpKVmRaRHhzcHdF?=
 =?utf-8?B?ZSs0VmZMWGdBK1pWQ0pBZ2J3aTRIcllNS1R0V3RLbFpRR1dzMHI4L2RQYlI3?=
 =?utf-8?B?L1RydXFUUmY0MHBZMlpneGVGMHJEdGRMcGl1b3ZGNzNsc1JxY0psZjRFQmEz?=
 =?utf-8?B?RWxmTGNCSElsdTdQTFlHaENsY0ZPK3BoOEhsdmVBTTRtRjlQYXFMbDREV0dI?=
 =?utf-8?B?L3ZNTFdkdk1vT01BUE01SGIzTkc3N0ZtLzg0d0hZYnM0cUxyVXQwWi8xdDFn?=
 =?utf-8?B?L1BldmMrWE04YjgxeGwyVDZSTXg0UG9iSTdSSTlNamJWZmJJL2M1ejZGUXF6?=
 =?utf-8?B?OXdWVCtXZDNpYVB3M2RMMFd1YjJUaGRUZWFnM1o4YTIyUXAzQXdFNmNUTFE3?=
 =?utf-8?B?c0U5YlVJcWQrdTRkWnlDN3N5VmtOaDBQSmpNU3J4UlE5MjArME1ML2kyL2ly?=
 =?utf-8?B?cFJyMS9Obm5PRUxVWUR5dmhjanEzTlpXbnVQMG8xN0MrQnUzeDNEUDRWMzdt?=
 =?utf-8?Q?/GIG0GynmGFPNA13i2QzgcrVF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fSqvmZ70m71YLlJ8SoPu1mfUG11pwyjLWO05KwtoNR9HDSal38+V+vQsQQLkrSllhDq/zti9NDAnQlO/+IWAW6dh9QSky9wqAGhr/2XBp52HCapzH4lgK1VbR4a3g50MCLC2BEKHnklM2HnrJP+LT3PqcmnPrXq91X9g9eBYaAEaHfpoo/Zr19HXt3SoTYWnpRleYOLpauQTRc9pIf0uOuouV0fiNO3Xs5BeRVrMeGD98OAmNtymNdPoEIRJL4I6lxzEBYyXI3z1Egj0MJKfNBHVGbsfGInfjflye7PXwZ211ndXQIMK7ofEeM86j5ltYLuNPhlbUWsFNRz5DsZloVpLpVpTYvS4G/JCCrv9ptQmBLUp9VfPOa1xfRNLNno/PeEvxy1BHmcfNDaWwHz2lFUVund73SCTLBOZqMDJjBAnsigwrl0et2lUtyl8O9V8NW7WVe7YRLEsc0CNT8BwV7fd1Zxr/GtGK8ydLHo6NyMZk4sA0GPdlfSiIl96iLrymqE1RGiY8En0cxnJZErP/NJGA1WZ0AIEPLAwbFRGy/XRDQWdD+LwoSnoXu/NtyrQVGqx5Fhm5Ksei/MBCBLNa6e1UmifUd6Hi1E9xUpcEEA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ed5556-62d4-4e55-c88c-08ddd524f798
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:08:10.8191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnmDF9u3I5J/QJ+7D5wi3qXIop2Qz20Z62edm7IRCeI12thxroMN6UHT2Z4kA2wfCwlfy3v5mbhAK1uso+ETgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5996
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060136
X-Proofpoint-ORIG-GUID: cUJb56CYG-TDRWslLMeUaDZM64yO1p1W
X-Proofpoint-GUID: cUJb56CYG-TDRWslLMeUaDZM64yO1p1W
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=6893b62f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=KM4iBDCcdl3A2YbkZkwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDEzNiBTYWx0ZWRfX6Hp4gfGxfY6v
 4e61Mcx46mdtWji0IOhEublsp9kXOR+nlQuNox8JiUqJ1a3H9apn53emQoix3n/R8HFjhnww9+H
 neb4gyV+xwfAgD8MaQRNbQBmSKm8YEkuyWI7oIhCrjz9a+18PejHMdi6Omn0YV/ix7mYgQwYjrW
 5MsbV2v/9g5ZPQ7ubUKbp+jsnrxkfbu0RK+j+HlPdHHhxC8pW1rk66MWEvjXoTto/rylw7/Tx6y
 e8CSqi6XUm9//148Ypvwdt8WXdKzyRQTIX/1SPCKImNT7uTYrTCqOg1FJa0TNrEIPayDluR6ppZ
 o/5mfaexTMnxqC0LRWyRMffnSvm5FXG1NLdWrfD4c+qBEqeVYxknffG/G9xotl7Jp2jNmyKVtMJ
 c3r3WCRdJiLAavi9aImdwPk/JzlK2lgeb7Q/EvLC5qxqM74LKCd+fIDiu6482KIq3ReoBEyl
X-Rspamd-Queue-Id: 0584D180013
X-Stat-Signature: q6pw4zsk6u3qzikotti4u8oaptboy7hk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754510901-456518
X-HE-Meta: U2FsdGVkX19//2E7ZVKkE8ZOwlS2i0UgaFwlLr8DhDWkyGKIiz478VMJCQuo44K2qZ/iIr1jsbSYtf8w2HRPzwDqsn2p4/+lIyHjg9YN7MPsNnCTib2iruIFqoe/9wl/DM6SFGU5cxcrH3lt8V9f0z1KNBWrcfBshmkE0aI2Qa88hYVzx0YBH2QRVkRu9V39EnHE2z259KZBv4YGi94skfu3S0YMxdhwTE6DCgfhfjc3ozIAuzlURq1DCPlcTeMbu6cu7/ma/H9RgNbDgj7CAFyO4lLphJZ5bdosAk6MjrPtcuvKJuQo4cyfKX7TQS36JTuMP9s45lfoaUaJOS9u06DRlB6zFz3MDsrKfxmYd6AiSjz4+g1v6mZ9AEAazIPX19vdGzfx8TNnRlSYRTqjXpvaYLGJg/lMBYVTj/iOmbl1q0lHa/RovP2L3ELpuedcdsTKOmh5upXn1DyvbhrdSyEcNkaYZ58DgycAMA8D0Epy3eH/ScJyo1Tk80wou1spes6nDQGdRYE8Tv064AiwHlZSBA1Dutdn1ZhrpmToDoCKPaGBbxabmxA8MaUNCERIMUJUZwbL/MzZS2LpfnucWL6W0dUdAF2TCJH0sF6tc0uIw/AyaseSy2jNv9RDjkIJzkUKZ/T4i4uTYjCEPPRoBZu2X7RVB6/wSMpHjfZpSi1wETvFnnjfRGfjE1xJFtap0j9qbLa/fPXj1lm+NdenyIPJUoQRrzJGTUGghHnX5kEU/USvpnJi0VZpJGNKtv5NkIiwDgNBpQhLytJvTVmZXtSmmTPrKQSt9iUaSDP1VeEt9bGrFgPpuz+gClG7/mgvrjfLgH1AoxvCZYomGFHUs0dnZIQLQPA2SDsk4C7CB79uje7UmTVo/MJOf7ZV1E4StGOCfnu08Yfzrzzfs8B8QwReMMFuIHOYfgpJiG/8DwBoKGMp67+i+yE38ro1FGA3lkZiTHiDMuxDK+1vmkS
 rHMf3ELK
 qKgn8++YSHH6rSygocM6kAdV9bEwjmAWTEohIRkdCjLNKFx80OV8SPZzVnhg8kGDBlj/9S77HAW7sAh7b+uAb4bWgsKP73cuL0s7C/9AD0m7/+xLPo26yWbHHWtXMDhtKzhwvqxrY0RW9QjBEzmgRHC2zFOVXnxe8Ka59kFrD0/132wtPf7DThhxNiaFfShIkAY4+TFdBme5eZbwCirieJoH69vRvofB5R0n39jNC9e5L252d3yK9moeUuMdmbXXS1neEOtR3EZtnoPQ2tME8BNNvYx3nNcq4sS0G0mGpIK1eDRsBFA/c0AhWQkOd8Ufe+tfU2VdF+hksXpbGqXKDo7p+iaPmEGukZgwgUEwCJlnUXJJ6pBdHvBnAedLjdzjOsgBZevgiib4zHwBLr/YsgDxo76viPKJK1dKisIZFNThc9LqrlYHETiInEJ1BNFSD7qIQIYb26olXD0jE7AjI4LTX0KcvBb6fqORGLqSeu2F7LoQgru2WCNIlRE449uonBYDpWyGHVixdldknf48k3MIVzpRCWodE+C3ykNxnn97r9AYyi1MhvEXCDWQkDOzy8w7bfoilLaWH4gqmZH3Nv1Q8QfWTHv0jzyjOnhwS3gaJb1UhKODbiYMHYiDAydV32EDCgU/o4syHiX9LEz7BoQhYV1hs/1HnDpVXDlnckFjOHCSW4dXdZwozkrM2z+PuYLTH8K/cYwzlECPX2B8DivTKs24/ukk7uDaT0oZJqHqQOKPI6o1X1hUfMMywL8eWZ3LiFvRW4tHzDvmmjVS4Bbf+ZiQPa46UOpusQ79jIWe14BhjKH8j2yAs0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/2/2025 12:31 AM, Kefeng Wang wrote:
> The struct hstate is never used, remove it.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/hugetlb.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e174a9269f52..b16011c9645d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1896,7 +1896,7 @@ static void prep_account_new_hugetlb_folio(struct hstate *h, struct folio *folio
>   	h->nr_huge_pages_node[folio_nid(folio)]++;
>   }
>   
> -static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
> +static void init_new_hugetlb_folio(struct folio *folio)
>   {
>   	__folio_set_hugetlb(folio);
>   	INIT_LIST_HEAD(&folio->lru);
> @@ -1982,7 +1982,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
>   						  node_alloc_noretry);
>   	if (folio)
> -		init_new_hugetlb_folio(h, folio);
> +		init_new_hugetlb_folio(folio);
>   	return folio;
>   }
>   
> @@ -3401,7 +3401,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
>   
>   		hugetlb_folio_init_vmemmap(folio, h,
>   					   HUGETLB_VMEMMAP_RESERVE_PAGES);
> -		init_new_hugetlb_folio(h, folio);
> +		init_new_hugetlb_folio(folio);
>   
>   		if (hugetlb_bootmem_page_prehvo(m))
>   			/*
> @@ -4013,7 +4013,7 @@ static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
>   			prep_compound_page(page, dst->order);
>   
>   			new_folio->mapping = NULL;
> -			init_new_hugetlb_folio(dst, new_folio);
> +			init_new_hugetlb_folio(new_folio);
>   			/* Copy the CMA flag so that it is freed correctly */
>   			if (cma)
>   				folio_set_hugetlb_cma(new_folio);

Looks okay.
Reviewed-by: Jane Chu <jane.chu@oracle.com>



