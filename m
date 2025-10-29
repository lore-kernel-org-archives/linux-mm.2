Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06792CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126928E00CC; Wed, 29 Oct 2025 14:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FED08E00B2; Wed, 29 Oct 2025 14:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F084F8E00CC; Wed, 29 Oct 2025 14:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA2728E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:56:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 803135BB03
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:56:05 +0000 (UTC)
X-FDA: 84052056690.22.F8E5B27
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 28572100006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:56:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N1+meijo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Be880pHq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761764162; a=rsa-sha256;
	cv=pass;
	b=zK3kiDuxaLNglv17SFtzieZg2+3sV0W6A0qiGOKGQklsc2+YUP2wFCZwNWCaqkzJNkP7Ap
	HSH2JyHXTkUXn3Err70ZE6iPc/ucS8A1xyvIm+X5REMT72Ahdn+4r5dpguj691seCuf3/B
	oGKKB3n2NvUQ1R6Wih869Oul65pZUYk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N1+meijo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Be880pHq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GxFQw9JiE23Ye1kBdCkXGuvxUHLWiHK/Yaqp/X5Gg8=;
	b=XYgX4UrrRn8JDC/ZrfaecTa6TIPXJdE5GHwVH+wqbwgqxcT2fmzSrJxAGL5NmzjAtI1onr
	pHObp902FSEMxq5Sgd0kd18witiQHK3nJOeAC29pZxcfGOhAs2dycTB7UYSSijfDBKtXUQ
	0ExH/Ggd/TGQ6BmotoLl+urgzeNAjZE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TIp6CA020019;
	Wed, 29 Oct 2025 18:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3GxFQw9JiE23Ye1kBd
	CkXGuvxUHLWiHK/Yaqp/X5Gg8=; b=N1+meijoZC1RqJcc45OdL7sJUl40mFNV/s
	vce6PRFkvtp5AwtORmppkPkAuiYb4HfxORRWv1/ZYUqYVxyMh06zumCt89xE0ULd
	3mZeUKJXdQJ3a86qM1kD8ap4uO58HF5QchHnTZmAsN86abZ+pZRftKNNqShQJfMV
	lPigiiu32yvEDZBrk10v5TAlQrcLo7psMIXWHgrdIWeCnz/gWUb9bMpKx9stz+jw
	EzziEZROSaWNnxOH+K24kkBB00gU9HZZQjLOmS8+dtHLI5BRbRL2Blf+fqErvU13
	PU84BcIjax/KrCb//2u9o196f9tj3wIQ/RpiJPxvp+tnClyknkUQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a33vvjt6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 18:55:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59THiwxe021324;
	Wed, 29 Oct 2025 18:55:41 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012017.outbound.protection.outlook.com [40.93.195.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a359u9eeh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 18:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbQB/rSWJyok0RpVTJlT/W/SCZQtOmrrqLeovhbVZcT+Xxbtl6Wd9rgqLwmwMQgIiKaDnSlzyqyBUOHtxScykdORv95fXkZ6lbPU1RXvQZNgrPii/N03MKVrgDUYy+BM14CijX/mFU70VDU8QiDdI37yjQZ23CxhySGmBe25yPqh7RGkAUDqemncbdzdPKau03vs0YN3BK8Ns2d8LgT4vCraz6KU4q5Yi+hpXq2BtpAJEhDCcUR9ov7QyF4lpzkEq3UsKmedZvBwoZaN0QIoq9bVSwV4JoGEBRUW6OBjzJ7Pt2GP7nhDqRiC659cK0RXT9CCzgaUfedUd1FMrwDTJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GxFQw9JiE23Ye1kBdCkXGuvxUHLWiHK/Yaqp/X5Gg8=;
 b=pZsAoz5ghbITQhlOmHPVZo1VKvqtrPCXPWyB4EG4oS4203uqpmpUIDSI+eCK7JH849T0UKlbj3H6NVfxgOsBjm+ocYXZoSkVvUzbGbPbPVs+JfMKprF/YXwzmIoCGnYhwaWAvMDkF+T0qAud/Qr8yXCZGJa5E2aIdaECkBpDS8ERiiaakJhOPkc9iebeY06FoXfiBDH8MS+oGVGsJ/vnQZdKNVBh+KOmRs23Wmdvm0Ndmd4KwkIhM6FablD5OwUtPUYzxaR9t3dYXT2ifwGbj4BWJTJzpstav8ybhXuiID5y8w1PxNH4be7UuqoiHPDTka9On7ojipzjFnRbERXgMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GxFQw9JiE23Ye1kBdCkXGuvxUHLWiHK/Yaqp/X5Gg8=;
 b=Be880pHqQGN8kdvO/4bfx9B9O+8X04t7Ctg4O7WmJwsL5Ck5idfkt6SGiXJvMeE6xFh1+6c79znV4h+DkK8nhQS/RQXKlSsVFDczrVEZvACnBNCnvtSFwnUiO0Yn63TFvhrufHdXE49joOcNg3+b9IIYSqahoLiNi/8gaftd7G0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7737.namprd10.prod.outlook.com (2603:10b6:806:3a7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 18:55:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 18:55:37 +0000
Date: Wed, 29 Oct 2025 18:55:35 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <2ab547d2-584b-48fe-9f43-7c14caa7ab05@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
 <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
 <b1f8c5e3-0849-4c04-9ee3-5a0183d3af9b@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1f8c5e3-0849-4c04-9ee3-5a0183d3af9b@linux.alibaba.com>
X-ClientProxiedBy: LO4P123CA0090.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7737:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a356cf5-9c1a-4a27-6f3d-08de171cbf8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PNm11+BsPUQMhZw5WnteyKqa+RZw3Vqnuh5qXdlXHlIiw9gHK6tItWgDQFNB?=
 =?us-ascii?Q?TT47SkGCtrapo2sddfnUYYF4pV/qkxAwdYBUVQZ+ZvZJT8FkKQzdoheQBRVM?=
 =?us-ascii?Q?pTYv1e1sBd3YqZ7G6odJ7+EzfBUbdLt/sHFIIgL7v3n3qTnvJWJJt09tfyM3?=
 =?us-ascii?Q?/EH0yaxi2mwZulWbIcp+MaGQuXrn5ybmpdMkGVBaMzDAEyGBpA7izWwr3Vve?=
 =?us-ascii?Q?Q2hqcaov2dlAcX2QgowZ02DDOKqw9fvNNiiOAeK7tPwCXijAxOLv6kiCC2yl?=
 =?us-ascii?Q?llJZxqlkHJyTRsYvqXC+0zweIOcJp6tYE25e6ZF0ooe8huI+2KXs7hynnX94?=
 =?us-ascii?Q?zUVWgbniVUS5+Pyogdyr9J8VhU/Dh0+SV/cmnrtmT929557DXiZQYj/Bggil?=
 =?us-ascii?Q?/vd9v5gGI0BncrsPzZ2DH3yu/N8smLYVLbVUIQo8y9ktQd1vRB7BVO6CCbqU?=
 =?us-ascii?Q?3HD+7Nic0yawJ40Ovb5VUDrOfGSBB+FHdNr7FuRpT/RTpkLVuAmBVBJis1kA?=
 =?us-ascii?Q?0QmhMjzwhyq/BuH9I8hxuax9+eaXXeueX65yZ1LO7NdTwqBZIj+RDP4qXICP?=
 =?us-ascii?Q?Z1hc5iZlBuejul6m31IDK6XKy+2F8JW1ymD81VNvYzNQHRZb8E8VKPdfBjtS?=
 =?us-ascii?Q?Xda8keOg37u7Q5VnpBdkbPfyWKY/DkZKthefzDymckJdobNuXbuwvy0VldgD?=
 =?us-ascii?Q?0geSKu9QCZeOoHeKybnh2lKWA7iQidllI6F8s37dyulCU6pyEnU8dRjOUZ9y?=
 =?us-ascii?Q?6sPKEF23uiMg/cZi4L54RhW+gnEs2wxCHyZqx0GKdaO/7IxQ4KtLkr3JHA+K?=
 =?us-ascii?Q?s5NZ0Vj4xZJ69iLituyyHnYBayLWzrUsM2C2TNCXfRzBKY/yM6M8WIxIeg6m?=
 =?us-ascii?Q?ug313HyPcF3I3XUHI37DwrbYXrqnKT/JnoKbWP3JbFKd97EoKqHoky71z23O?=
 =?us-ascii?Q?LoHfEiDO6/zcljYoB6wzku/rfSOgIN/8iuaYKTSOtXbW1xfbbtri22S4FaBx?=
 =?us-ascii?Q?qoJCxE9y269OXScr4nHx90Ac81W5WztYpJxDR0NBqXQanr5m5bj87kzOJoR8?=
 =?us-ascii?Q?BfUlGu9DD5oVRBcFZBqDfoeUwgZzVT/e2C/tO/FkdWOSldd7++2dK81SYt/e?=
 =?us-ascii?Q?KvJpuwHq+FSrzG4Lrr7SmtL9SnbDE4A58/o+kTQG9n/nx+Upg4EJX19CNozm?=
 =?us-ascii?Q?loLogikj5JVI0tS7zD3jUb20ehacwsAE1aXIVdIWl5FroTZYj+t5RnLLdtFj?=
 =?us-ascii?Q?ww7SplAN+HoELeQEmtpzC1Unm0/7C2Mpy7BSUC2NHGcUlumtLopRTrG8sY5q?=
 =?us-ascii?Q?9jMmlZlqyRR+4HRw893gYOir4BaRcBghiqDn9Cp7FLvHVAb4HfzaIyuXDNEV?=
 =?us-ascii?Q?DqW1hX8hsLc2IHZKpOa4cWpCMMITDwSNKezpPp3Rys3PHXNor09dSDkge70x?=
 =?us-ascii?Q?KcNUWaS3Zqm8EKCNDnQdnvDV4nPWRLwZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5eN2sXcxMXI1kewlVB3G5esbvpdRbuCkQuYWGDDDWaAUwB1hBKnRXfQiBC3z?=
 =?us-ascii?Q?1mRIXTad69eDBOuqvAnWo88tApgiEVFZcnaW5o0U1gNnF3F93L4dVxNAFGVz?=
 =?us-ascii?Q?1NBXUZMfXMfYLK1A4LcEWhncZfaOhyDKfFxz8m02EmArfrpzzJatjfib+b2v?=
 =?us-ascii?Q?x6wpja/SisvQMNiIAehzn5Jql/oP2/MALdY+VKfD6ajxByInuQ0YIvGhbHhI?=
 =?us-ascii?Q?L9WLWGtZigGUCGKk7pTWdYd0EreEuAtF/nL/h8xQT3v4+31pQXInjKJ3wZrz?=
 =?us-ascii?Q?xJb83FoAJ4AgaEI333vjyKnst8iSkyZ1ILI/NmrMD1hj0obVSQ7FbA1R0uJr?=
 =?us-ascii?Q?8qUAZn8+DiVi6GU2Nx/vYIfnA2AftGajWmbljAWqUBRB4jVpbfMANhY0FLXK?=
 =?us-ascii?Q?G02nVoPwIsCFvPFnhN4P1S1cETDT6PGjPg6GZ/2plIIRZBnZMTN5y9TElj6D?=
 =?us-ascii?Q?kAW6VZpBr9Y8LxReBDjpMBenq8msyGmBwxlaAjzXezVhg5R0rrhgdE4/aeOc?=
 =?us-ascii?Q?qsVki+SXiRoBceoaS15P1TQh6faDWzIspbDP/c347Nw8XtTdlmfkE3rYb4nO?=
 =?us-ascii?Q?ouDUYl+lWoySorceUiCsY+/QJNAqDstyLWjPd1T1BUbmhxEG5HHONO4aryVH?=
 =?us-ascii?Q?JI/VwEnQlDKKSPAaQ2QIR5UuY1nc3n2CWnCexS7jTv9gY0mSxnwQfmhM/ZRi?=
 =?us-ascii?Q?AgnH0YRPbDLPYTVKjZmLO9f5obZUUcAWxa0bi25HrUXgcnAd1WvW0hkmFmLz?=
 =?us-ascii?Q?3gD2r063os/eVTzsa+UeOnGVky8cSZxgE+ZE4ZcuM8qmNduyf4feaEdimlqw?=
 =?us-ascii?Q?QpKNMuJbGseT0sLctAlHwbrr7IusxJQG6dAYX3G7VX7sWD7quYtvJB3waY5N?=
 =?us-ascii?Q?yy/9ZIelLkOdzMWmhUx4zcwiMVTv5kenN4C5XeRk4ZtQ+00/WHtRJV2ECMXA?=
 =?us-ascii?Q?/N2M3q5CakO2qPrywlEbKOAt6+C3rFZXO9VaJTk6RzGSu85MGCTJxGjz53O4?=
 =?us-ascii?Q?hAF5Ny6nffjFucBStzWde85tVX6TDhgSTyormrzJnELGsyBCUEicB78AyT7O?=
 =?us-ascii?Q?UQ2ICCP1y2wqRF289X7Tb8HeVGRNEZAeZj9KpIMrb0St5Anutmh4xgwkw6Sb?=
 =?us-ascii?Q?w/5RF3wJHpqW09vKt2XyHDR2MjOPnS3BTtQiUKEwI0wx2Rjekb9OrJfH57S/?=
 =?us-ascii?Q?eXMPd5vh/C8CXXIairEXredIJYj36fgQIua4LXjybuw44whwxmSPWYin8y3e?=
 =?us-ascii?Q?WXQOyw2U36kUcuOnSpbipj6o1nSkzUIovRlElVLrpefNHS+JOhzA0Sly/Av+?=
 =?us-ascii?Q?hPtuEmq1afrcljCyVs2dJytVY9uEMKvv7/Q5kuOFWHEpuboGWEeiCEwujVHQ?=
 =?us-ascii?Q?E+dVD9wfwzL/LgW9mnUaXwh8No7Ed1bccySKhm71HOjBOAiR72XKY7H0fRCe?=
 =?us-ascii?Q?q/FACzXABGq3KJ9/KmjUy8/vc0z/ZP+e0mdJXqFpVj2RRXV/oFnwFOl945wY?=
 =?us-ascii?Q?FL2oOPpTS99Aa1B/bSLCUpVIvhmkVB+qHUDZHOW5cSbYk9hPthwFSi9zPCni?=
 =?us-ascii?Q?KLCkoF5dtUBLDpvVRiSjilgWCJQuKB3rG3A81DwrjCFeiWYnVsUsPW3E4lQ7?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8PiLJBp4agfj4AZN23eKDYoWF8g4YcFrHw7+KUY6qGcV0hW1BwQGmoapjcH5a0+eJQ+EtmP86fhnEGyed+RaOeeIqjQnj92BsjUeJ+6IraNeoDvtfvufZqKDj0JHmmMqgvWvECiq+KsJkJpjlmBXncbsmqDmWR6sYqMCDwo993rDoo3UAXoWSReaNc/sVZaGUtx2c0S3FmaJMsG5OeDZcyHVgQYleRdexVBnr31LUpU8kHV/1W5iTUqNd9qLNkEg6mh2dZuWK5cKhUNOwSseiA256KzxacQzSXqiGJXw1tcaUmSpdMauyyVKAkSoRkBtX0tcJOCkNd+75qv2OgMrf2cAcJ8Q2GYhp4vd7lpeGb/GcNrwfcY2suPNsXXnzQsNKhVbCpGIYwfl4se3nCE6aRMctYXNWCZkr0UhOLlznFjSSSd6R92dTqzxlgVg+XwQzG6VjM/asFMuQTLRwWao2RYhKf5+qX80cFrhMlrXEYrpMEHXjD1eSvNE6SnobC/PZ9PxEfqHlzkolrnyDL8Cg0oENrOVmBbiLLLeXFQV8ApQA4tl4abdFGxlpdXIUQ0LK2VT2hZgqwTTg1zGBJaX5jidmREhkdHaqXY09JHoRqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a356cf5-9c1a-4a27-6f3d-08de171cbf8a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 18:55:37.3891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ATclH/uiSrFT51DBIV8itTBPaY8NMA2DNtXgKNOERA8ibgWatEyNlkLoc6/O2nrg2+44dQajVTfxaNp20L9Q29p7PeVNEv1BfKfWVvysQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7737
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2510290150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2MiBTYWx0ZWRfX3S+eIOekAeJL
 /hMQ+g6sljYi84Yi0CV7PDbbueIj82HPqyf3v6g8BlZoqHV1EW7K3XJaRjx/plgA/Wc0Lr/NAfm
 SxNOIqf8zswIcvjUU687zJCUkJ4YllTmTVF5SQd/CF0j9XET5LoaVLzwzfHsgXKCYfxuReKuSIT
 j/GVkem55XWfPlQTxvW4Z2ZUO33jwhR5Z1PF34n5Z2c29DC/qrtUS4Y5/U53iu2se+HHgkl29uO
 4jDNOTmS6Lany04+FxiQDmaqcmqbPaYFVDJNymWzUXvwAhWWZ5Iiwt0HjBg68TxXuZEPALOd7Jl
 UkZsheLcvhfq8qbO0oO0U0GF91UQ0Z4KEFe/CKzKN19kRXkb992Ma98CVHuyQjqqlY2afuFjuOb
 gA13zAzFpd/RUSsRvakOYs7SzYISsrZfj5RIUkrLr5TmV4Tjd3k=
X-Proofpoint-ORIG-GUID: bOB0cAKHZYDfWAJkddW2W3V7x3h-3o1q
X-Proofpoint-GUID: bOB0cAKHZYDfWAJkddW2W3V7x3h-3o1q
X-Authority-Analysis: v=2.4 cv=SJ1PlevH c=1 sm=1 tr=0 ts=6902632e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vijlhOQFImAY72Jz0LMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12123
X-Rspam-User: 
X-Stat-Signature: gdiqc4bc9mre5e99xipqxi7qwt7bjg46
X-Rspamd-Queue-Id: 28572100006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761764161-125675
X-HE-Meta: U2FsdGVkX19UImK9jdmlPyB98U02G1AIkAQOuj0JuPBcLFIl3TbE3mWiS0i2/9bbpLUa1kpMeWYILtzrnPrvfIj7R0s02kqKRZykRuIZs7ko5t8IpyQVXrnI/K14v5/ZT6qF9VCoqyVNbhwJ4TgGX2l7jaD8Ra4Gw5cGJAwugp2/edFsVfqLEuyQWAm18ypRLhbsFLmEGucbONdwObC5O7BWNhOwSOEWoMQl+KwXO52XecNqUXboW+x5jtqwu6LEAOk0Hh7sfkS6MmemtldQ4AerT5fPWNJfqcDJ7PzkFitycZDIIjM+tLKioTE0dymGvOo2C48u9TNXdZsKTikHGTfUaJeHaQa0/sx5ureJ4h/XjoZ7tlU2TtIR50uZpmEIyKuiXYwwM7JoB2MRjLhiNvkII5cWZFOS2EnRoq13cwO6ZkVyYu0pTPJ0B/1BAYqnvJutpGSHThlo3jxQ+v2AftdyXFNXS/XAY6UlXF3mRdHWC6YeAPUZuXkcwOr5guniTGw5/UeNRbCqDyn5jPJVX1eNNl9v+gqbU+rqOJiPIB2ldOl6Z9UgyJZeBMhW4UWaXW+OpjwXEKgIRmJfepYIl0gZwP+JppWpbpTlYqXPjueN+JHsXvyKug4fr3hDNdGA1IWxjRiMNxE6usWLVF0Pm2bmqj0YavbygpuDM7/GPQHQWntRpNxrYOwWbF6wDQ73IKl/7w8B9ku9dNX1//GIM8qcfHYP/WPi/VtC6UKFLEdE5JONzWcYFmm2LQJjbIwN3BXtsgNNp278R4/NvqVg91b5fUPK5xqDuB3uMefjrgNhw+atmHBqf7Ta2stah5yFHzEnOFuvIKQ6on2LyQGcEO9/EzkO4PNMc2pLPCvYHplP6TEdbcW+JGSoydcc/x/lz2r3QVOrj75bqmSeGhQqxVa5ARCA4EGPOd1uuGmS9TDpGsq28SzeJYgZAx4HCeVbBYasbklqHDl6riRAQS6
 6omrcV28
 d0H1bYxuIcXUcQFdysprI0yQxwSKrT8vANmFfDbQL0oakz3uFOdJWQ6SoVCCXElpHw2mZJRZSSMqiOafDGOtLpgoL0Te8506m/B6FgsTv+QvKB1W4Jb9icwVRocojFXnPesNnDoyVUB7CGWV90gy5tQMYudn1aWouuR2NNjjYQFz+JiEti+8nlAeQkpiOl/PgOp9ZZcx6FuVBqNTPjo8jKV5MYOIxwI1J1VWfKE8ZwuJS2XRtanNNII0RuQw/nl0d+FiGQW3eIhMLfljy7xFbYfZi+X5gMWl1gB77h8oLnxrDCxFgpv/8mOU9wuFEsXLIGzlMbdS0eJc06CftrP4UEkF4sGrMiWhGbD4YDNg0LaG788QUq3+HruUv2WW9eW0oupqz+x8M17GnHittbF3NAmEtJUOI8Q6Y7qOfD5LIJdCi1MrVwKmBDtfNQKODyNH1V98IpQ+pBikwBv5I3XyPr5KQN6DKFXTY2Yzh17XDBTTdCiWSopFiq53DWgpagdTCkzFgnkBQmpBxv06DRIMU0hNKe/gX93V7Pqc7S1rt2AfgTUB9R1CF+xKw430UqvakiUHDXyzOQkxRaCjH0d0DmBlIzGpgGDpjGMWRN3uinC71MmZOaI/Y1ic1gqimK/cxx/tYwHY9XsdJgARHQeDxAxj06vVZcolqu5FCZvNY9/UQ+BFRiKNqrP3ChSBrFkMvMSH2BcyMyNoA2AFsTt6f/EYDfGYb9sq3QYdGgyyWhpf/pLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 10:09:43AM +0800, Baolin Wang wrote:
> I finally finished reading through the discussions across multiple
> threads:), and it looks like we've reached a preliminary consensus (make
> 0/511 work). Great and thanks!

Yes we're getting there :) it's a sincere effort to try to find a way to move
forwards.

>
> IIUC, the strategy is, configuring it to 511 means always enabling mTHP
> collapse, configuring it to 0 means collapsing mTHP only if all PTEs are
> non-none/zero, and for other values, we issue a warning and prohibit mTHP
> collapse (avoid Lorenzo's concern about silently changing max_ptes_none).
> Then the implementation for collapse_max_ptes_none() should be as follows:
>
> static int collapse_max_ptes_none(unsigned int order, bool full_scan)
> {
>         /* ignore max_ptes_none limits */
>         if (full_scan)
>                 return HPAGE_PMD_NR - 1;
>
>         if (order == HPAGE_PMD_ORDER)
>                 return khugepaged_max_ptes_none;
>
>         /*
>          * To prevent creeping towards larger order collapses for mTHP
> collapse,
>          * we restrict khugepaged_max_ptes_none to only 511 or 0,
> simplifying the
>          * logic. This means:
>          * max_ptes_none == 511 -> collapse mTHP always
>          * max_ptes_none == 0 -> collapse mTHP only if we all PTEs are
> non-none/zero
>          */
>         if (!khugepaged_max_ptes_none || khugepaged_max_ptes_none ==
> HPAGE_PMD_NR - 1)
>                 return khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER -
> order);
>
>         pr_warn_once("mTHP collapse only supports khugepaged_max_ptes_none
> configured as 0 or %d\n", HPAGE_PMD_NR - 1);
>         return -EINVAL;
> }
>
> So what do you think?

Yeah I think something like this.

Though I'd implement it more explicitly like:

	/* Zero/non-present collapse disabled. */
	if (!khugepaged_max_ptes_none)
	   return 0;

	/* Collapse the maximum number of zero/non-present PTEs. */
	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
		return (1 << order) - 1;

Then we can do away with this confusing (HPAGE_PMD_ORDER - order) stuff.

A quick check in google sheets suggests my maths is ok here but do correct me if
I'm wrong :)

Cheers, Lorenzo

