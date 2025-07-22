Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106B0C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 10:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6086B009B; Tue, 22 Jul 2025 06:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD3B6B00A4; Tue, 22 Jul 2025 06:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E6E6B00AE; Tue, 22 Jul 2025 06:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42C146B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:28:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2E3680329
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:28:35 +0000 (UTC)
X-FDA: 83691526590.30.6A56F78
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id A64C620002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:28:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r2JmMV+l;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B+PPvT3i;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753180112; a=rsa-sha256;
	cv=pass;
	b=Ok8EJ2L7RZZSItqOaK2W6KrwLAkKQG8ekvh9KYjWOD+RNsC/Ar4iNjcKf5mMfSf/SnOHrK
	dGI1XSBr6G8V2UXzkHYZJk1m3/6pDraoUopjO8CijhWvVYzT2W38Yxcvi+CReQg9Wq8vqC
	KGnm1B3BEEwt4n1LA/gC6eZS/ZsdYao=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r2JmMV+l;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B+PPvT3i;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753180112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HTVgiXIZUTAY/aayLE1KgJkaaNOoU4iLUHN0NElfwg=;
	b=6dSirQ3RR6y19LmgYii/V+z+cehp5dxkhaX4pj+wO5B4OO0OIZTbTKlrBluqPznMGevpnz
	hJlr+lTU6QiVDpyB1fDupF0altYPsidw1Ewynx9aGIF7Hd6OPK27CJMRyRc6EmccLdp/RI
	7empQ5HOjpShJ4wtkphhLXrEZfIfkzI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M5TBe9002534;
	Tue, 22 Jul 2025 10:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4HTVgiXIZUTAY/aayL
	E1KgJkaaNOoU4iLUHN0NElfwg=; b=r2JmMV+lFu4vzyjgJqcpYZPLO/0YcTYXUF
	gtseyCDW08rKJ5ZMps0mQvvz3QGumI5CGOa/Lbyk5NLrYE6qM5I8RI75w+aLffGm
	t0/W2kgOtRE28/V5zLMJRTgffYd19OStfBHJUn9miavyNM83cYLN4LqJht2ayTRm
	HYqjCuQ/hhPZfmABrvhqQicuXnFj1imHmcOQdZfZClj/BqHpl+JAzBh8JUZEWxK+
	EpSIpLZNqOkkEt5y2E3sq5lkEHZ2zdAjUK3eKSFHBysstT/R1PkKfkfasO5tvypI
	CLEG6mFv18wYWcKVJ7AftDN2elBhVxtnNFsa03b3Ekjps1nmqLNA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805hpcx82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 10:28:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M9ANnn011318;
	Tue, 22 Jul 2025 10:28:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t94ht6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 10:28:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r39p7tHnavZ1SJbWTMRqTtf+LYyTKDz/SBPCl7KRn4M+DZQMMUH5Yi1RtO6/zSo5A2jb3AYWSxB3aOYLdTRZFpH6TrjBcji4j5/ZtBbMKOBuE8VZflESzvPffDw+/CdPT/cBvPbswgc+3yZHPqxwgAuxj5exNmd4ZkPrOIUk/p9DcbC1yzPwR/3/P9WK1uEyHh1AuAB/im3kQFF/+ei+OvFP4JhJ9r+G0c0RXXggKPNbl75XecjlCiDK09zqdQO2r8Psh7wY4d9U2P/2Muo2F5QiVz0fVkAd8dYyNZEyJF43J1FtSvAmrlUiMCbeQOhHrjqP/31kCua3Fza/nOf2nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HTVgiXIZUTAY/aayLE1KgJkaaNOoU4iLUHN0NElfwg=;
 b=HUNeDwG0gGbHafs+PXzk1wfHIo4f7pF0dmEfRPe7vwPg9HggyvXtXxQ1dDcjU5QHBcPa7dFiGSnT6Yg/1liuwjwS6+Q7B0+TlqWDCduscQ2Fsokrrk3CJYNrbAjdr7pxKTAyFtshZsRQUIbQ2X/9YnOAOhmA8jgTsuzX6N3Qr7N9gDmYoBfAQ9EwBzCMi3raMY29FKuRutyXGzRhxLP9avKnC1MxlwxmV8mkv48ymksrUwpXQM1HOwv4lccc5Z8fw3/qKiaXqp3F2bcURREPI0NZYdSTrMX9s3p3xNbrcq7sJfyUAcL0uXRjzzFERKuFow8GXI7vFhT89EUTbj1BGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HTVgiXIZUTAY/aayLE1KgJkaaNOoU4iLUHN0NElfwg=;
 b=B+PPvT3iR+RcMRsI4UtiLJbF0YLzO4VmMz7ja+X+56K00EZg0TjqQssqpK6lgePcyo8GAoQlr3DYx9auC3X9rKSru61+otlzcr4TRtPUXAHCc8bWZThpS+Dt2jMt5JOxsgbKxunzk5ivFe8PqfSE2K5tm0lgyVOl1gT5o7tyHPQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4716.namprd10.prod.outlook.com (2603:10b6:806:11b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 10:27:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 10:27:58 +0000
Date: Tue, 22 Jul 2025 11:27:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        SeongJae Park <sj@kernel.org>, Jann Horn <jannh@google.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH POC] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
Message-ID: <4b11f40b-a339-4ffd-8b94-a62ef0524403@lucifer.local>
References: <20250721090942.274650-1-david@redhat.com>
 <4a8b70b1-7ba0-4d60-a3a0-04ac896a672d@gmail.com>
 <5968efc3-50ac-465a-a51b-df91fc1a930a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5968efc3-50ac-465a-a51b-df91fc1a930a@redhat.com>
X-ClientProxiedBy: LO2P265CA0497.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4716:EE_
X-MS-Office365-Filtering-Correlation-Id: 908f93b6-5514-42ba-0c75-08ddc90a6dba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?96LlkIXbWQqoCRaPQUprWmnETeKSmFZSSYJq/3Lw3XlmzoQJEj+e7dlHj0KF?=
 =?us-ascii?Q?Y9Mz0zt9m1Ibe8N7WC1+3NweKfR8mgEVeRSYyBasDHMX8tsrYBLhP0nTk5e9?=
 =?us-ascii?Q?IwZcCusl7xxME1idA/P7utk4wFlvXGfGHy/eHxpqnMZb/vdnT8nq0ts3kzaQ?=
 =?us-ascii?Q?VVU3olJbkk4Lt5VoK/SuQVrerlh1X1sdhiPHuoIOtFjaEa6jCfsrF8ZH4K7I?=
 =?us-ascii?Q?RNHEKktkuQtdyOaclfc8vcfAH82ddWgmHDj3sGCOeHHHCDiugKLHbcYyXAk2?=
 =?us-ascii?Q?eZH3PSAH9G9iULsywg0vL9sGmad+zTiXgBwxLVj1Oon9bEf8imvTNaJKC6Dz?=
 =?us-ascii?Q?RGGJu7mlOrODFUyrKF1sMmiINLOQwbH4YEz7rXoySbVOz7IvCRbea1hF640i?=
 =?us-ascii?Q?s2sEgt58elY3ZCUqZ4brVIogXEjFn9yevw0ol3nbhvcIcb/28QlghxNmc4Rj?=
 =?us-ascii?Q?HuPHvZbqubysWoqCq+EgQIl4UIdPsKXuDZ6+phdOgqt3cCjIToWU/k6moOqU?=
 =?us-ascii?Q?20NKcfbRN84t4qNBf4TpiBiH7TCt5HlDMlcQKjENjzvW7XYodFxJiKJpUKRt?=
 =?us-ascii?Q?tY4wjBjJCtq6A6kYEEennJ0dWbRPKpRhoHrygCQTDQycpgB3ZgiPHLg+cmXe?=
 =?us-ascii?Q?ReI+XbvqUlVACJz/Y4uYzhhshYJoE1S/Hi9Se5x+koqVi7idhXKonNU0O+oq?=
 =?us-ascii?Q?AT5Z508tq4NhpcgNXoe5HbnEuB2KU8ivV/l5lXAhbg3HT2YMHyXC8uMV1FrW?=
 =?us-ascii?Q?x+/YCLvX9ZFw+gGlJR+MMf1EkTd1JyB6hyMESqFVtTO+GVTOqm9SU3MotPde?=
 =?us-ascii?Q?SrK45fahlwvq2DsFfmrUF1txs/ytU2ExPmCTFv16PUu1LaHHqxI+hUFRAzZU?=
 =?us-ascii?Q?TQJNyZkt3fbKumDMuj2JfmTUQYIA5KeXylfd1Cr7pHiD+BgeFi8QDKLpmN98?=
 =?us-ascii?Q?lLuqzNTTwLmpJi70TCAZHtI4H7BUl643mYLH+xQ1jLap8KGAdbvPBilgoFeH?=
 =?us-ascii?Q?dkmTiDRlIgig8lWczIYTl+5XwKGLc3Kc6vTekrLNK/fXBtmExGzvJVnlkTcX?=
 =?us-ascii?Q?GjnyNfWCSBRlgDR15bkaZzF4DnxG4b0H5s++1OCAu2npt2H63DAmomrKwWy5?=
 =?us-ascii?Q?7Hi6082acPMM+O8vBBULMYL8ltOAkp1A90j/LMKUZqq3JSstzzN3XxdYnIHo?=
 =?us-ascii?Q?VX2+c62HZnuPn9f1+Pkxjh6NJB28DGJB1ORDYjsJ9XlNjfSd4uhqhxlGWKWy?=
 =?us-ascii?Q?RGWWQMN4nyAkecHueQZ9tjxU2uHbN/Cb7lg/NBZcko9COA+2+TlRizsN0603?=
 =?us-ascii?Q?mfllHufPmskZXwi6qJR1znSq4tI0l0lo5oBiqWjaRSP88Gw2CIjEYDqF6zkb?=
 =?us-ascii?Q?j6xOFQ4PW0fhL2Q5e3XLUdJhKHmr96PivnVRmrD+eKq/6tucZfazBp8hcDxm?=
 =?us-ascii?Q?jh329yllWXk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mGoirB3DsTOF8MoanI9xyWTO8QUouQQYlLf4/tgSD1mYczdivXPVfN4zUEOY?=
 =?us-ascii?Q?EoeF4Olz88qrtTi/2Rop7ueJH/+mPVA9aER8VuTLmkrlWvQI9nb4mlYccmSd?=
 =?us-ascii?Q?IDDhTd7jEI+R1WAte3D3Br7+dgsThTxLOjCc5M/DX1dp47H1y7tja6H5eB1F?=
 =?us-ascii?Q?4ntyENw5Lw3jVGFfyeAnXHw0RsE0veCWdRzmDlYKAxaAl6XjMCE5z9da6eNE?=
 =?us-ascii?Q?ccJbTLd6pOGD27+nt9ljsBustIIrkNFert9s9XlU1t9kvKCeUxOcOJb63MFt?=
 =?us-ascii?Q?GkmLKtZAO8kx2D8p4OlKYCfXOOSDRdjU+FFbhoH4wTJgt7sQHGbKz2MmVN6J?=
 =?us-ascii?Q?ROASmTR8T4MOdj+9O+mVSJkk2XtVVdj0jwSCBlAoJq82JfIYuzj+YKB777ip?=
 =?us-ascii?Q?VWRZ8NPQfkvm06TWeDjktt0uPWvmya5xLIspEORR0ztrTCkM0B9At/42Nvg7?=
 =?us-ascii?Q?+l5zhKNvUqxJxKGbWNxnRB/HzZqg0/9NExDKTJAVUsu5Uy1VAb+XGyoAnggB?=
 =?us-ascii?Q?TWP5IxLeqbOQHnvA34O9UvHXV4QoujKW1+1CZCFfYG5Z/T7fyBrJTjMgPy3H?=
 =?us-ascii?Q?qq/k0j7mk/qreziDLxJcLYNd6PgLvPfBCK3Pu8erUb2JmL6WpilkZq3QBYEm?=
 =?us-ascii?Q?65onbzbHz2yDRGVeKvz3HwBnEP/OQ6+5r2RD5fQ/GtrtSaQeulEeoGSM0zNW?=
 =?us-ascii?Q?8VfHeFbUGa5piROyOlMLyZKT9Wnm6VLlW/QJLmNCgKUdpMPo43ElIKNXH6Hg?=
 =?us-ascii?Q?7adjhNcg5Noph4RzW9HIjuDISgtP2sMg8gI2Vc0Ered0QIqoZUe1Y0wg3hkI?=
 =?us-ascii?Q?Z720Wr/h6uYdS1bujuwtHiGe4W0qQrTXVduXnm/sui9oLIu4HKAwLZP0CRpa?=
 =?us-ascii?Q?9qavpippqqAuqL+xobF+wW0JbcI9JqOgW96YW6wIdabiwyY1zaouYW3xquxf?=
 =?us-ascii?Q?BNE0J3Xyk9ZaM9201iYc6/cfGyrY/nRRreaesZZm8vSQ5aQkROH/S8+w/7Bx?=
 =?us-ascii?Q?JId5+uhbtEs2k1F/2H8YWnmaRCXE13Xa4XCurhgtoMHjmL4xcJo3qFrX/FcW?=
 =?us-ascii?Q?Y/iqKnz+cwRvmS68WTWBUUPZPfXvwVbG1uW5FHb0x9B1NoRK6yCZcY8tnBBM?=
 =?us-ascii?Q?aqBGTvf13o6wnHyzT4SP4Lo9IOLgLzKOXL3/20HXbVMKe64hLH7hi5RpyCd2?=
 =?us-ascii?Q?x/TR8lqwvK+i0uf4D8r7+enC+cRTRijUDWRkHA72h4FD5AqdnMOsuFuks0Zd?=
 =?us-ascii?Q?1MR/9zSrTVO2nbsTq9JGmuQFA0dH69wUaoIh+e/ynR5sFpGPqi32OgL+47uI?=
 =?us-ascii?Q?XOwCXJtU+bXMo+if1+lxP9XvM8zo2Pi+S/vYe+ioKJmnyGJe9p0Fsd6E2L0C?=
 =?us-ascii?Q?vHD+m82BODZCnvR38rANTnA+t10i+UBjG9XfOaWcGN9G1mTIPBxywzJdEzNm?=
 =?us-ascii?Q?hlkra71u4OySsfjK40wBYocge6wLwMS0vLct/u0YTB8xBCwITsTH8wZZMZTT?=
 =?us-ascii?Q?yUBeKAUhy10dcSY3gLJW2PuaT1bcero5jaikT+Pss4J3OG/O7vrGT6TTxqSo?=
 =?us-ascii?Q?25mJH/o3nIbIgBdg4AinpsQxqmXS8D0+RAIGP32L6cwCKy46ENrhBfqxgw66?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LNEdx5JfwZ7Hkx4cLmb864rVdfavKUkpjpJUrMmBIwhiNQPPmXvKH0MVDpidrGLVmGWozRpUAu6eB4rdVQGuRVP5FBS0s02nTfOOMbnzSYr79ZwMVhAlyzK1kXV3mrcO795x+wpvIpJbsqKRo+u7UYK5bZXHR3tFt3njccNq0kd3zo+2OdfxMQ17kuWIb/r48hwtmNijnho1zOuXCzI7iBmxLKc4HkLiz1DDJTbjhfZyiXNwUYmGcV/LvO9+6lxKUvSJOIFaID5I/5Sk4qJ7SXp3iXA0GZxYobSrlZjhri23XCBDdG93xAf+nnO4HZl5Veogx8yW+YErVklBgguv8lpkSzJ1YsYIj9UZj3rhREN/b5N+N2K1I4tbM+5beTs4uTZwgbD6ojygSEhRCn1VmfQOCTS2DQLKvKUkBgMf8pLMG52wQX1exdfXiIbrnG+h1xqRorSVD6zPv/lIKe/mUATM00B4PV+n4wG9dRlOQvn+LWIaq4Ggq31P7kZrAo0Kn6GW01Fqa2h2xrnYobZSbyQ4D7JzAHoG9Sz1mB9wYKZFm6wCdvwAGZA3dMyr6cey1omI25yG5rAPx0v0F8WgUN976xlkGKV0ctqFXrZtRrw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 908f93b6-5514-42ba-0c75-08ddc90a6dba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 10:27:58.5069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz69onUSzrTk5mbtzNVg/R+/Nt14klmXoyMucCO2VB0pQt0jyxgoJgTI2XHRtKSeoWyjCE/MolKk/0fASSIj/mD+5WZ+mV6ncIqTuYxT+A8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4716
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220087
X-Proofpoint-ORIG-GUID: wNx754shNs4OGXM8jhySZ4qQD_xfPJkG
X-Authority-Analysis: v=2.4 cv=YY+95xRf c=1 sm=1 tr=0 ts=687f67c7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=W58IfuzhLd0cSXqbJpwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: wNx754shNs4OGXM8jhySZ4qQD_xfPJkG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDA4NyBTYWx0ZWRfX7Ku9I6pd5Q+Y
 fhyTaBGoaj4NGF9UUuvT+5a4dYRizcWI22GnqcQg3UN+1NFO/Phn7tAUmCxdFkg/9oD5lzARWNL
 8qktATdT33Nj+glLIRa6uKKwF3ddfVbPxMfTgsDfMPW+baefWCE+SO055DK41oXDkqYDAY4WJcF
 M82K+HVDrfDXltt4+BXYbLM08KbDyXpQI2fnbPdqrUEX4JW7uz5dxQT0II8x1Ulhix+1RMaul/J
 vrNLwpGkqPaaMf+TJd7NeNKsJJ7TUzmd49b5T7kYcJ1FTCyPYqsKI8i3dvJWwquc7kpdozkiOtz
 t7kkM7qkxpnK4MRddIjoTOOPVZT5Nv8so2Mdoucww03JquxxxUi8nh+kDWDECfxMNPNIGyFljc9
 EFmNyY2aNeIdqImzdLgLLQs70sZDkcZQzBi5X/NbtoPP3dv75Ixt47K32kZaBMZMXvaYMke4
X-Rspamd-Queue-Id: A64C620002
X-Stat-Signature: neb6ktssfgk1nrwmqf8uz8racrsnymzk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753180112-305022
X-HE-Meta: U2FsdGVkX1/UpmJjoadOt2IxXiBf0YuDkKz97aDo8Qo12rIqToYdkYfxHCFHigK5LHuy76elt+4SzUey6yj2rM2jUIytMAaiIQWk40xmogI6jAqr/3t07El43fLHwPfSIx2IuU4IohnEtnDPZodjD0t9DLohsTSocz2Zvruk4pzro4w1UgdCBewQerqzouc1aYI8X1bbi2H4PNE6b2rPRVpxEJJ8APofvJ/l1bO71wuYBPBQWs5Tce6PdLB6mtGbSut81PSlbMedO/gQ+uYnviZmpUq3b2cZWgv0+c32uftgN5LtbjelB2KP1Yyi6QSh7jqPj880A65WhfvkFo8nSmFXSn+RLfss+fUOoj4MRAmOIG9nbIliZt4Dgw4hVCdDKOEdhqyUXR/SDjAQFQDo2gN+y/j/n1kkC48Hen06ofB3KpBHL0c5F0hM3upc/ltzeZGmfC2PWDgszAvAM04bH0ghIpVedJGKYs0u2vD+0aZmZbqxJSAXyqWJK9rr53OU92koXs5HFlNJIDIry7ZDozWE6paCoOOCJ4kbBWTpzKKhWve7dyprMEnCww49Q6M8k9zLqVaPlszMaFBqAbeno6tupV9scOeni5+t8d9Uv5wtkdRwrMBO+lPu2+X05A79GPsXDYVF+8dUOJjPDCpgYqBuIHT9eHgMKpYb7dtf3i07QpHwfpXCrVNUwSGFA1YT+j+Efxr9wuVblAwJIKLjtMSpLpLp4VpwsX9xzR/eV51yN2ss/rTOZvWvuuhNxgfT35cKbAP+CUZtODYcmRgkfNYfKJ5MZVr6OwbvNW4yxnh3lMPT6sYlW8arpX9FkxH9pn+1d3nbcEproXIDxhh469kuO9eUWQbtlZW7DzUNtXiyrcfs+O/DZrRYjG3XBu7t03IbI29SEmREjoZVjSZvwZgo8fTwskQj9qzZMhRl2qquPMtL8eulHp77Nj1lZj6NIKXeimw5TZswr5/pBAt
 vdnc+eRZ
 mepvpisdfK83mgrl9Sf9dA0wbVn3ENMrl/Hf6SmoWxeRaEX4xagRSDbbTNI5/fwACTrusRdbNT+ZnMhbAR/OMjgXqkL1tmplkwN+gYAO3vGzLai+u2ozVaDtIHYnFbJjI31VAEsoMfrf1PdcugHmPqIZUh3ia20/In3WNcytsBtDeHz08ScD54sW6A/PJ3bCvjQekky4gzBc61kXAQ1Vwuuqdr2uAfO5iTE/WXHMCvddI+x1A6HC6Falq2u6FNy+VSIXqID1ELWPLAKmcHtVlhwQk6YWMjdlpJJsBAEaECYn6NxHeEw322iYPzn6cXFAHxgNeLPNEA8PAvn75GOyhNp1zNSXmKnxOh33RzT07iNmCKCKvMRUlla60Cy5vTAk0WvrHYHlHBhpie6yZXHEYiKul2LictZ7sFvWAr+Y75wJzhfB4pW1np6DP4UhctO6cZx8TDQdBUj5f+JGinG68xHbRXDy64zHba+gy78ECMYAO/SMkZTcDEn31cphu9Bf0m4gURXn4g2r27RkhtFweXQocmyIS/C/5kp34/Bv3YOEHMrGOVPTkLqj8PbHcJ4jce9q5GD43O4txWimQjzWPMykWrwhUeRnNDtgSFcaWCHYmH1qMmvve99hN5qIF0hepsy2A9enD6QhMhOW54zg6OgiVjl8cfNkE1+sibxJPOeCPYOaVdTubc40Xr06aWxI6f2v/vQOddASLHeDrSoMSSuaA6Crf1onf0Ig1/u8RMxNHlWHgbGad/kzdY+2fN9S34CUwtV9/GCvIgkSuchVQ79eUBAdd+RoKPTN/60WS9N7/ogs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 12:23:04PM +0200, David Hildenbrand wrote:
> On 21.07.25 19:27, Usama Arif wrote:
> >   tools/testing/selftests/prctl/Makefile      |   2 +-
> >   tools/testing/selftests/prctl/thp_disable.c | 207 ++++++++++++++++++++
>
> Like SJ says, this should better live under mm, then we can also make use of
> check_huge_anon() and vm_utils.c and probably also THP helpers from
> thp_settings.h. Most of the helpers you use should be available in some form
> there already.

*A wild Lorenzo appears*

I mean everyone's saying the same thing, but you'd almost be disappointed
if I didn't say here 'pleeeease keep as much of this in mm as possible'
also :P

Thanks for taking this on and writing the test Usama! :)

Cheers, Lorenzo

