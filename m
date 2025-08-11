Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4EBCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 18:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F10D8E009A; Mon, 11 Aug 2025 14:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2AB8E0093; Mon, 11 Aug 2025 14:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042AA8E009A; Mon, 11 Aug 2025 14:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E19258E0093
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:53:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 614161146A6
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:53:18 +0000 (UTC)
X-FDA: 83765374476.25.3FDEBDC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id E54A620006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:53:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="cwEpF/19";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IEhgTfKo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754938395; a=rsa-sha256;
	cv=pass;
	b=yAMRT/c2jjQ5HgzyVrTx8+dEhXmjjoJ176SJWRULX3zEJJWATlRDZEsvvJA7xj+/6Lz8gC
	5ROsrU+KdDrMPERN6cHL9QDUq967rCxGWa4qzYFN4b0kBf/Om0TUCRbQ+Kt+OsWR3W+fGb
	q5QTpJolVM7b4n6MrJ5oynK4AONYrpM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="cwEpF/19";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IEhgTfKo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754938395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+tePwj5ri3C43RJ9y3qSn4J7mAeIESwZ94/L9FJDik=;
	b=vtGIgX954/WY7YnELsqBKHGkQrFEuguEb3IaeBBmyZf0Qh/uKRsgB7Qw75/UVqeKKMy5Qv
	BMETYcCtEZ/+PH/uHvU/HxQ7+sdH4rKCZUxsN2Mo0qdLmsoU66fmk57dVpy0J/et2D04po
	+GnQLzNG1nw1/mfIETZQ/3/uQUTFvQo=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BFN4PU007045;
	Mon, 11 Aug 2025 18:53:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w+tePwj5ri3C43RJ9y3qSn4J7mAeIESwZ94/L9FJDik=; b=
	cwEpF/19s+GvUT1Na+NLK1Cd+iFRyRAl1sBuyzX8XHDr7eFCUQ3/alXU6Zn9vwbL
	hBfT/W9p2hnFlZlmFCryww6NJA90QpoOfEzRCHvGUxNvDczQbevRZnUy3mvtdUVx
	K8gTvVAAedULH0bScOfq/iwwZ+3vLIf5EcxpDKiGUTBav9wmU/DHMNbzLBbx97t5
	qlOsv/fFhPc6rXy4RxRjhvwTmxclP8ePh+Zi8H4jLCjjYm7JZcYkxPh68TXEAgvA
	S5uIelAH9PU/oIlw3u+TZLfVCtgaHjI2TINepBQFYfs/jDiWJp1DqfpYvijDt1Ca
	MomS/JYUs9dldsflCNzPcg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvrfu8y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 18:53:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BHdUZA016798;
	Mon, 11 Aug 2025 18:53:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs90sjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 18:53:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G+UglM12x2tg4bKJt5D/6DvlJl8H8J+0KpAihoOR9fbnXpBY+3DT7597lp9fcIy1Pjhb9eXf6EY0c0rry0GsJs2igrjLdrHmXLSrZRA/G8VU8WgvjIAHMX2bFmIHlMX6VAADTE110QGHvicbVY8zlY0A2kNpyUy2S85268+99TJ43Hrg4HjgjbAjdn5dHmqXDYjvPcJAbol0+GBDgpQ8kWpzo/HFHZ35JsvQMltHvv/0hwqvPU8m8JP7QH7tfkZHuMV29EB/WwRsbKmURh992wjGZpkq6ui6Rkjv/V0MiKvCBswg1W/EI9q75/iSnVlJ5qrQP65n2UajD2M0dqjsvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+tePwj5ri3C43RJ9y3qSn4J7mAeIESwZ94/L9FJDik=;
 b=i4K6dQX/S4WaNTkVpnEY7A2zRDZJcfUVFPBPW/gtd/r290Oev+BxUSyJtEMejsDqcA8zc+HQxzpSTmTz1g4f5wIu4PnKdYWDE+hcPUk91lL+Aie6M2rzZ1hu5aOol/PKjR/MZ9yhZHE9yUVnpkWUPxsmNSEWOflk/A34ZCMqQgba3ShQmUwToSNkO2DLOGhQdXmgUMt3/qNZOkPPK8mVjc2PpBRXZu3ktoHawoAKz2E82tfSs+fY7FxoeFvgJvorNwrBo1VrkTeWMhIgiE0iBMHf/zL2DxKiXApmjBvKAXppW8XFrgNjK65IOq3e8dyMUOyMScJ4+amSYbaO5Pb2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+tePwj5ri3C43RJ9y3qSn4J7mAeIESwZ94/L9FJDik=;
 b=IEhgTfKoIR2tH9gqmQBWEcLJBzpzSh8L78+HS2A7yM1dSdmjrWEnTCkaUoAHj3rRZ16Tj+Zwg+vqUIqXLrQ6L9cgxsMg+5J4oJ5XRx755eYBhUvjx2W1zB6q18C6/kmIwWjtPO8lfNEcmvyFFphAFYkP2eLAsKN56tC0RQQM0Es=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW6PR10MB7616.namprd10.prod.outlook.com (2603:10b6:303:249::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 18:52:57 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9009.021; Mon, 11 Aug 2025
 18:52:57 +0000
Date: Tue, 12 Aug 2025 03:52:44 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jialin Wang <wjl.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: remove redundant
 folio_test_swapbacked()
Message-ID: <aJo7_B6cQc1EucA1@hyeyoo>
References: <20250811182500.42670-1-wjl.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250811182500.42670-1-wjl.linux@gmail.com>
X-ClientProxiedBy: SL2PR01CA0016.apcprd01.prod.exchangelabs.com
 (2603:1096:100:41::28) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW6PR10MB7616:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eaebeed-030b-4931-a29a-08ddd908494c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rzh6eHBIRWtHQ2h0RVUrWlFUZXIreFJVU0krQy83S0VXTGtRRS8wcHpXelpn?=
 =?utf-8?B?Zlk1ckx3WXZ2a2VCY0xhaDBUaElvdDg1VjVrY0ErbEV0bjlZWU9xNUlwL3dT?=
 =?utf-8?B?NHNGLzZDU1c2Q3NDalpGaHdRTGtTWVhLV3dRZU9kQjRaUkg5NmRNYkZHdWxw?=
 =?utf-8?B?ZCtCTndrL1VMTjJyOTZqbUR4dER1R21aOTdvQVFmc2EyaE0vZ3pFZG9HTHV6?=
 =?utf-8?B?cWJtTm04anlpUHNDWWM2ZDZibkhOMXJqbWl0RUJsYUNibDRZYmkwUzR0K1hU?=
 =?utf-8?B?VjdNeEhUSDQ0eitKRmsxUFhiN2czWWZIa3JrdVdUVGlqbFg5bUs2dVhqeFhQ?=
 =?utf-8?B?NGlxSlN6WXIrUGV2T2ZwdjVVa1FYTjEvcHozZlpSeTlwaVlkZkk2NUpMMGNp?=
 =?utf-8?B?Y2lDSE9MZ1c3RkIwckhlMFZYUEJ0WVJGVldRbjk4ODFYL0tFanFYWXV1bW5w?=
 =?utf-8?B?V1REQVdFTlg5ejNKN1Z3elAyQzAxWlN2SzJ2cVN0YXZlZytWblZOMU5YOHFG?=
 =?utf-8?B?WndlcXlJUzF0VHVUR2xkUlZSZGluK2dJTlA5SlNPcVZ4cGtxNE5nLzg5STdQ?=
 =?utf-8?B?V3ZMTFJWekx5aTRUNlJLT25zNGlBOFVIb0xaMHJzYVJIVGIyYnFqajA5MmFs?=
 =?utf-8?B?T2JseStVQUZtcHRnNzFZS3VkNksvbjlNeGMxSkV5L0NETTNlT05mNndLcFVC?=
 =?utf-8?B?bmEySkF6alp3OVNLcngxc3pndjJSN01PK1JGcnJYVmdWMHhnSGQwSGFqWUhv?=
 =?utf-8?B?dGU4TTdyR0xFeU42Ry9WTWxJRHZRR0pRa2tKcEFHQk1CcWxWRFRURE56eWNM?=
 =?utf-8?B?WkF0cm9WQStmVXNqRUVBa0FBOU9jZVM1L3o2S2RWODVsTlJQYlJ0MEg1RURz?=
 =?utf-8?B?TDF4QUhac05Hcm1ORHo1Ykc4ZGdrd0pQM3A3WDdzUXdjMnBzOGo2eWdMbXZM?=
 =?utf-8?B?RHduQmNRajlmNTNhU2hLeTd6M0Q1TTJjY2VJemE5b0FjT1Q0L2o4TktvNVgw?=
 =?utf-8?B?SlpueXcreTlkS1pzVGNEMlZBN2tPTERJNldFY1p2UXdHUk9YbDI2SGlGb0Zt?=
 =?utf-8?B?emJIcHpaRHNwZldaOVd0MXR0akhUT1JsT1FaZUJxS3JUNHoxZ3BtYjdyUnpk?=
 =?utf-8?B?SzQ5WGcwTDlMczNzNlhIdlZDR2E3VUdpdjdmWVFmVkpXVTRRUGx6S0dXT0NB?=
 =?utf-8?B?VFdtb2l1UWFlWHExZ3JXV3hrTEowUFVGRTErUzFIdU4yUUFhcWhhOEtBZCt2?=
 =?utf-8?B?d045MXg4NDZFd0s3WVRMSjlzWGpTcVlTbHlYZWZ1TnVpODRWenNYRmk1VmlP?=
 =?utf-8?B?Y3NJR29jUS9qRFloR2dUSW84VktMaWdZVDJVNXkwYnBQb3FEL3EraDgvWTlE?=
 =?utf-8?B?V0dLMW9FUW00L0k3OFB3MzZGbVdPR09FZFFrWmdTT09BVXJUcVdENFQ5a0hH?=
 =?utf-8?B?L2ZWam56Lzl4MUZuMFJsbnNhVXdWR0xHQzNYbG1TNVJuYlhHVlBlUVRsdVhG?=
 =?utf-8?B?bFYzdkphVU5uRktXc0ViZ01zWWdxYkJrYmJXdW9XWHNtT05ud3FJMWJLbTkr?=
 =?utf-8?B?dWlyRDdyREk4bE5VS0FEWWJhWVBocTV5Y0JUT3pNTTZnejlEaXhJVkNLZWtP?=
 =?utf-8?B?QXBzeGxOZHg2TkJOUE9TcFpNRlhMbGd1b2g3R3BWdUx6VFk4K2Y2c25Bb1RY?=
 =?utf-8?B?WGdobCsrWEU4Z095ZWdzdDYwci9WYXZIYXBuVmgwaElrakRjK2hCRnYxeG1T?=
 =?utf-8?B?OFdGTzBtRFVnTDJiSVFMTGpEZFdKaEYyVzhvNGVMdXpiRVJqb0ZkUHpzN1Z4?=
 =?utf-8?B?WkdzenlXWjN4dXRBTVhqQXlzMjZPMzBidW4xRU9yODdGQ2pmdmNYL1lzUzB6?=
 =?utf-8?B?dG1YY2IwL080c29JaXRjd285N2xDOCsvZlJZMXhxMDlLaFJreit5SFJxR2RO?=
 =?utf-8?Q?sWjpLwrjSe0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnducXFMM0hzaFpwRFZFeDlYN3VhT3p3SDBnTkpFZVJRcEczcU9hd2JnWlZX?=
 =?utf-8?B?Q3Z1WWVsTmlOT24vNEtOaWJidlhzSVlRY1E2WHNycWRIN01YeURzdjVLTDFH?=
 =?utf-8?B?Z2JrMG93cThnaU5ueW9rdTl0UHJMVG5VWXRaa0t2bHhQdVE4S01MRkFqSy9p?=
 =?utf-8?B?aW1vb1l3TmdTNkZKTjVGMDlJRVJSRThQSDdtemxHSXZFTDRQM0xEczZhVUYx?=
 =?utf-8?B?MDJud2lOYUlqTjk2d0g1TDhCNWtoRWN1VVphcEVmRUR1d0FJNnloWndzd1Ji?=
 =?utf-8?B?UFRvMWtzNEtMRmdrdS9wRm00RzJLbGlPMVp0S0lZbzdOWVhvbzBrQ3dOMlVW?=
 =?utf-8?B?N1pIb2F0TUNOazNBcndtQk5BdEJaSk1uQzc2cEk3YnhjU3R5ZkNOOFhBRDhs?=
 =?utf-8?B?TVRoOHhQcTNESmJNcWJBZm5qWG83ZmhZcVF1M0c0aThJaThYbm1sRVQ0a2ZC?=
 =?utf-8?B?TjBNTnZYc3JHYlNBT3dLcFZLN3gzMDVvVElTRHhNWEJ4R1Z5MWhjREtTZWth?=
 =?utf-8?B?VnpXKzdOTkdGeHZZWC95RDZnVzhPQlFYSXhXM2hXK0dKanJ3SFFrd1R4RmdM?=
 =?utf-8?B?SWRacWN1VmZFK2x0cm4vMlgybnZkWVRKNjRYWndMclVCZzJEVG56NXNvUm5B?=
 =?utf-8?B?Rm54elJhLzYrcEpoRlo0RXdNV2JFMEswN25YcWJXWEdrOTJ0R2ZNRmRyVG1J?=
 =?utf-8?B?NjRlZlNFUGd4eHQrMi9mdUo0UGwybDNheE5UdXM5Tmp1MytzeW1tZ1FSSXNo?=
 =?utf-8?B?VVE4ZjQyeG1rdml5RkNoay9tSENEQi9ETnNkOFp4cXlPN2J5bWJxbW1sS1R0?=
 =?utf-8?B?ZkZqZUU0eGQ0WEJUTnArRlpBeWZiUGlkek1JQ3EyT2t6UnlIUm12UWw5UEp0?=
 =?utf-8?B?dmZ5NnJ2VXU5cW1DZkp0QnpzemZicStqN0dMUWFWaW9lSDg4aEVXVDFZRVQv?=
 =?utf-8?B?eWJIblJGZHRURlJOc0JRancrL1Noa1djQkZRelhDVVc5empWTTBLOTJQNVFk?=
 =?utf-8?B?d09zdzBwN3o0a3k0WjZKZS82QnlUdzZ6ZDMxYjZtNzNNak8rR2k2VHo0VDNQ?=
 =?utf-8?B?b2xiYnl0eGV5aDR6dERFMDFKc1k0K0ZnME1ORUtKRUgyMGIyZjRacnI3SVpT?=
 =?utf-8?B?aVdrNGxVZEI1Tnh4di9tWkovYzZuQXNuVTFYc2RxT3NDOCt5MzV5ZVBlRGVB?=
 =?utf-8?B?ZmgvUWp1OVlKZU1HNFE4aDdnejZnNVFqSUtTNkFNNXNPNmh1RndZRE53WGJ5?=
 =?utf-8?B?R3dWblBVR3NoeGh2WXVPSzdCMFI2SW94VU9tcEF6Tzh6cU5ubWV2SG1pT0ZC?=
 =?utf-8?B?TXFqdnYxdUFsYmlhY2FUZGp6bU5IdGRWQ0hhWCtoTXZqOUZKK2ZpQUI1dHpp?=
 =?utf-8?B?U0ZOKzlYZWM5U014ZzVleXc3VkpJVWIxN2F1U1R4THNKWjl4TjRUQjRCdmdW?=
 =?utf-8?B?Y2ozeCtGcFBJU24vWUZBVkxHdS9lenNOMTR6WTlYRWtIbzE1R2tjMUNLQU5r?=
 =?utf-8?B?enJtNGhGSFFrSm85clh2MTR6RS8zRWNxS2xmd25uVGEyQ2duWDVLSysxaVQw?=
 =?utf-8?B?ZWh0QytXTlNqS1EvcFpjYm9uMjV5M1BIUTR1VFcyOFZHTzZVcTFBS0g4RHJj?=
 =?utf-8?B?T3JUVFRyRHFVeVgxOHhXNThhYmE2MzROL2ZQMHBzUXdxTG1RQ0xFR3lYZ3FT?=
 =?utf-8?B?N2RNUC9ES2tEK25TY0xwNFprc0lUYUxHOGZ1M2lHVEZFUkRjQmtsTTY3RTBK?=
 =?utf-8?B?c1V3Rk9CRmo1NWUxcmpqN1NLSVMzbEZWYlJ6TGtUbkRUK28xcTV4OWhRZ0Rl?=
 =?utf-8?B?a2IzRGhDOFBWYTRpTUpHTVBhcUFuMEhLclZqZGxsQk8wTmVZemhKMjhnSWFO?=
 =?utf-8?B?SnJCK1RZOE1PVDNobVdkMVlHYnprbGdQbDc4ZlhVbnVDRDdydjJDSEZOQVBs?=
 =?utf-8?B?blRRRFNNQ2hSbzlGVXhqVjcyZnUrN2Naa0RXZXN3a0QyMHNjTFJDcmVzT205?=
 =?utf-8?B?UGY3NGwzL0ZTZU8xTThOZFkyTlBqcVNNMFFpbDdoMTZFbnZYZWlFUTRBOWM2?=
 =?utf-8?B?Y0VjS2dLejgzM1ZwcDRtT3NhZDc2Uk1mMFNiTUNGWkpCTFpHeWQxaGJwZVFx?=
 =?utf-8?Q?bffjgs7E+uHhkmvLNKGLdZPMf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mbbV25TRUfORXX3KmUS9NPGrZSBqQPpOd1NOOksPBBxVqFsXST8cWNwHaE4GqIgFtziFOWCNZU5324xZBXlL5hELxKxtfYTcWbrVQHkqoa4b/T/hNk2iJWWUEdFx1LKsQoQJV+ODbPiom+J1Uk14xugbaCnQB8VOdvXIA5Gb/P16Hl7M2k0KgNZksg3SIx9sCfWXgYhSryRhh9J5j63y2NaA8RZo11Tj+5TaBP76Ej5q9D2nIcwpc3QQnXSIvMp6Qe5f6PlQZv+JcpG2cjLe6KaM4+hyGS4uWLSe2rBlT1RySkx3mxTI/agwbi7KO3zi0Q2R8s7i5+J78Rn6ykPHjxTSrxU3xLQzH0NmpdEzHylhSfVyE/mUuLqHu42wPe1pdU3yris4jfOVp/jcMuWkAa9PZewSnjE+C8a0RCmS78iry/IMo355SHdcSoR0T/E/efQbI7UXqmTiTCCEhT2fUmSJO/QRBgJ0kkdes6nQvRMV3xv5qfhqZm8WzHSwXrN4fcn+Cv4FTRIc2p+5+Vs6UwFHyzdfEW+r0kvxClz5RQBMup1it8fbaNiqOmJCA+EAPAcBCkL3H0wYHqi3kHzEtNZVFX2/9hm6+gUqq/SQueg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eaebeed-030b-4931-a29a-08ddd908494c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 18:52:57.3247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mEyfGan1Xf1e0Nf0dFXV0qQwMasMFAhML2Mm1SSdrVYDIrRuFCc5cqBVjDVq/WSetfmuqlET08DXBBE7fQsnJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508110123
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=689a3c0d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=FOH2dFAWAAAA:8
 a=iox4zFpeAAAA:8 a=ufHFDILaAAAA:8 a=V4zo2IF0AAAA:8 a=1XWaLZrsAAAA:8
 a=20KFwNOVAAAA:8 a=R_Myd5XaAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8
 a=teC4RDkzIaciwiDV5x0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22 a=ZmIg1sZ3JBWsdXgziEIF:22 a=L2g4Dz8VuBQ37YGmWQah:22
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-ORIG-GUID: y0H38FCtjUpGxhtuIDOXkV5Pz0zjUB_o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDEyNCBTYWx0ZWRfX5OpwweD0pJCn
 rLIP9sozsu2Fax/qOT3N4QlsnJxoThKFxLi5Uw2uB65PwFrbA0YruJnAv3KO3XfoTid20d/T9rT
 zYMKm04sDeMRV1efFH2J5OymJvIlif1au3hgi0zuQwgolmrmLPx8DPB/amoexOtXJwUoZdbmYR4
 3CM1QlQHPC4VE/hVSeiyP1UWUealc6eFHtbZotMqxI99rVNIBlPl9uU3RUYn/7sJx/bAY0aClIz
 pjc6Vc8MC8i9Hb/eRmsoLJXD17vhHyVdOB8jlOnue4UDI94SZzBG0orOvOA2LidpEj0nKFSza/e
 EqhlLrlqbbm/lwrY1DUyG8Src2Lb2PV0PNqzv9MnsMigQXg4lih3xrpdP/Na1BPEBBKmQnD5sNq
 aaz9FYnKyLNT8dWF63Qmql9DTZyEkDUvCnLqAXT36EddZVmv9P4XGUG6LeN5bvm5m2wdAlZs
X-Proofpoint-GUID: y0H38FCtjUpGxhtuIDOXkV5Pz0zjUB_o
X-Stat-Signature: t8coy7q1fxo3obbud5ry81e36jim1knu
X-Rspam-User: 
X-Rspamd-Queue-Id: E54A620006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754938394-283497
X-HE-Meta: U2FsdGVkX1+SX8vVgRDvo1boZgTJb9EEvuqeLkpZHzNTbPbiKMs1by2nf3mSAnrVa/zj/uYw0+QM15zDVs2NfsrHgEhAs2MKuBhYAOYZdVQuazPk+3g1Vpjre51GJ2/35jme186AzImx3EVgNfAP0QNs1uvGBvqZ3DRZ1jwL90rDKwBbC3EMu4DLxPWEQkwYw/STt8HhGYRpFdlB/11jmNc/nHUxxX83nfrHSwaamQjVtMA1xCwJ5Drzc2X6X3/uahjPjgP9c5UKjuLeN4mgLEHnM/+0AQmPwR2QpzD5W56uDtWhLn55TXCH82RAq1kfJS0LIE+FMuUyEq+2lLJo4wmI+iW3p7sGSB2ysfy0WwQvH3LV6tuVtNl5Z3C/IiuPeb43QoY4u0Cc/UBrFVvkK3N24dBr1+mQObRGnvpclgI+thAYi7KMiUDUOyvVXCQq8aBZDBNkkRhHSWvK9VjB0YN1ESmBqG0iT56barJTW5aKSaEQvxOFH5WX3+re3X4DJtbDzokfG1HXtsrSViky54xBnbfVyLawLrV9yr4zUy/0i5i60l2YAUbG8d8tO1pGh/hWaGBM6QnoBcLp4CVLtB/qqF/eDyofqwox7Nlipd74r1I6q6lfDPe1uaQWgoh3tqLYWxY6zmzYXdeYjlroT5mpa8gSJgM3kpeyaIEpDxpLnfFSu01mVaCA/BZwwXLRCXtc9AIZlgeNFFguZMofyBsTEH7w9UA9PEfzMILKvA2AUj2cgoHdfaAUckMIVP5Z4PtRs4rVewmY4B0z7cQZ8L6uppGq8EYDonZQ1lXqxxFjlcWre5YtXrkqajmSPKr7pWaqQXj74bC+6bcK+acN6Gv+tufCZ37aDU/g61vThFBPBRPFW6xCKq9eTb14KC2sU7bTrHn9VB3SZINsUf06F32E3jBV7pFtyvpvIEMRGHRyX+XVKw7TUpve2AF3vFqNUvwfyz1QXuY0r2gdO8t
 MVgR1J4U
 HwxvykiC7BokdkGgtitdEqchB/Mbxp05PGu3MoVYUKrdai5tFn65ufmK3Eu+iGziraJcC7Uj4UbyqWsmAdU73luOTJHKjQh9GymDXvZmLPOPG7yRM+iOUOXUL8BxH1oQXvyhjy0JhDuRSzt0Tk1OwD89kTq2J5edPtxsMD2LctE6ssNJCRhUYgubLeA/H/XRe2bTbfCmIqAl4IM+nPdvxjkgRxmK5XUyJLYFLkZrh8gCjF7ROSbrfupMn1M80h2XtUF9ldZZU/VqTSgfpj2YHc58yrydv/RhnHXS/R3r9ZaiT17K47cRV36U8be8dMlm/Xpz22qaF3yhyO5skdux6ZmdvzMuY6hQA0pzf5e5zC2uTJdBXLtrKEpfRlTbuZsSCstlxtErDhBR/DXRWfqY1uc/eyUHo6FS/q5H8KcqBI6o3S56xWfar3Zqb6f+g8ZoQ9Z70nwd6CocWKeIzUte3MUlfSX7GWXNgaVDfjcRFspduaP1EeF1PzBn34lSP7vKzx6ltupSHakiCFksXtfcr2TB6zrj+BUiu2n0LBzOQqxcsKqA5IstshjSQNK80ZmHeloTEHB91tunpt2lfgbtGl+gTgAMtT88vb/1ly0Sokh4/Vi0LKjz2Gh60dZ2OW7/kGSGL5rsQLmHLCenMZSPUYBKIo4UvDp7Y3omTZP7F7EQysCLDHgXjXMDYTyLfw/8iNDGh6Js20Eq/ifuRp5eUAAVGHtHkntwhNfLU0NsCdQ3WwS5iwWGsbTjGH8O244Z13icXTCSXRDWB/nWAbXZBXT6/qxyquYfqjobNCXTzTIdUPRA+RbQt50PiblwljWLq7fZGHX5+ltdbNJOtZt3nuU7Lq7nigzDyWgVWbaCVsnjdX5Y/9fA0BcVwi6+pr7KrxKrM8WA5s8riChIwkUjqPbcKdM/SwzsHYqJ/EhxtPankVqMn6drbPvk4/fx/ufIDbPkkF0PKyV7YDih0lGEwL3RLVUvR
 m76dLlhB
 K3WF/nvMNR5U8zC2MFGZE1DE41ina9GPwd8lSL8lalFRzRU6k7LZF/jUVSf0VSTTaJA/dZIW7AX3lWgoUa9fBsTpX+CFFBuUa2KnwrCI0Pj0iBlqFsh5wkLZDNPkbKgn8m95YrlOES4M95ZuNOtLBEpKJeTjvm/3myxH/Z0fdD7J4ZW5BpkYh/RQuUaujBbsxcnRtpmQcKxwQrXEU+x2MufNbJeG67J0MQdvIt+HqBQd6+sDO3UctPQHrHV4ybvuMh+3vyG+L/v6jTyR2FsQ0m2JSKAIC4ZTVl0bCJH9W0Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is marked as RESEND, but which patch is it a resend of?
I can’t find the original one.

On Tue, Aug 12, 2025 at 02:25:00AM +0800, Jialin Wang wrote:
> When !folio_is_file_lru(folio) is false, it implies that
> !folio_test_swapbacked(folio) must be true.

That is not true.

MADV_FREE pages are anonymous pages that are not swapbacked
(and thus can be reclaimed without pageout if they are clean).

See below commit that added the condition and the patch series
that introduced it:
https://lore.kernel.org/all/cover.1487965799.git.shli@fb.com/

commit 802a3a92ad7ac0b9be9df229dee530a1f0a8039b
Author: Shaohua Li <shli@fb.com>
Date:   Wed May 3 14:52:32 2017 -0700

    mm: reclaim MADV_FREE pages

    When memory pressure is high, we free MADV_FREE pages.  If the pages are
    not dirty in pte, the pages could be freed immediately.  Otherwise we
    can't reclaim them.  We put the pages back to anonumous LRU list (by
    setting SwapBacked flag) and the pages will be reclaimed in normal
    swapout way.

    We use normal page reclaim policy.  Since MADV_FREE pages are put into
    inactive file list, such pages and inactive file pages are reclaimed
    according to their age.  This is expected, because we don't want to
    reclaim too many MADV_FREE pages before used once pages.

    Based on Minchan's original patch

    [minchan@kernel.org: clean up lazyfree page handling]
      Link: http://lkml.kernel.org/r/20170303025237.GB3503@bbox
    Link: http://lkml.kernel.org/r/14b8eb1d3f6bf6cc492833f183ac8c304e560484.1487965799.git.shli@fb.com
    Signed-off-by: Shaohua Li <shli@fb.com>
    Signed-off-by: Minchan Kim <minchan@kernel.org>
    Acked-by: Minchan Kim <minchan@kernel.org>
    Acked-by: Michal Hocko <mhocko@suse.com>
    Acked-by: Johannes Weiner <hannes@cmpxchg.org>
    Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: Mel Gorman <mgorman@techsingularity.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

-- 
Cheers,
Harry / Hyeonggon

> Therefore, the additional
> check for !folio_test_swapbacked(folio) is redundant and can be safely
> removed.
> 
> This cleanup simplifies the code without changing any functionality.
> 
> Signed-off-by: Jialin Wang <wjl.linux@gmail.com>
> ---
>  mm/vmscan.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7de11524a936..9d4745ad5e23 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -985,8 +985,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
>  	 * They could be mistakenly treated as file lru. So further anon
>  	 * test is needed.
>  	 */
> -	if (!folio_is_file_lru(folio) ||
> -	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
> +	if (!folio_is_file_lru(folio) || folio_test_anon(folio)) {
>  		*dirty = false;
>  		*writeback = false;
>  		return;
> -- 
> 2.50.0
> 
> 

