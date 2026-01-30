Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4CA4E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5550A6B008A; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5766B008C; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3246E6B0092; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2496B008A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D34BF5ABE2
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:28 +0000 (UTC)
X-FDA: 84389848536.06.1B760CF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 414E280017
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IR78uMu9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nqJ5Ncvz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+paSCMylJ4zGtmQlkiq9rkiWuy2a+5XA3oGRYJ+hhY=;
	b=CGAtzvT7B9H0OWdVrAiZCE1whfFfTOSSxQ2/bJvpmZizXoWXiZjzFD5AAbqdy0dWAAkm2+
	hSvsLFP8A/XU77x9cDOfdupMQNstiIWUjMcq8B1PYqs8h8YRcfiIMEcyB+AIuDGgVcXQQZ
	BnayXe4Y3pKlx2Ie4AjSdHRE4cwugA8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806825; a=rsa-sha256;
	cv=pass;
	b=B7FxEdUU/jMf2SS6r/JFHpnRggZiZFvrDK9euglggp7mkXnsbNoevX8dyt1h5hCWUVmz8r
	3K/O1mv8iJTLCGjexbjHq6myyC0n36+Irfvn6WnGjAcoMk2Jgm+5wfQOPw3Ot27HXKlMeT
	mhS2iL9nzBqzXhpkUKhmNj2QPs31Kiw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IR78uMu9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nqJ5Ncvz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDNIL3407068;
	Fri, 30 Jan 2026 21:00:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5+paSCMylJ4zGtmQlkiq9rkiWuy2a+5XA3oGRYJ+hhY=; b=
	IR78uMu9Ojx2pKmXkHCZqXfcDyq5HMdjMuoUDloDeaQqymiwioJBS30UdsOLwack
	T6XoFVWrxC35KHLey8v32/D52yh5uhOQc+zc6EXDWia/8L2XFZSNd/HUTEgs6HR5
	3peVlVDwX2iS7lMhSecFqUZuwLg+KikxoTBrHYl51ss0oxmRU7DX26p4w6hB7QhT
	C9n2axV0aLkaCpN7GuVfIywR7T9lG7XiX4XLcZuub2DvHsjOojPLgCnY7ccxbPmn
	dZqNdTZS7Qq/GiCbjlNzTqkwfqvAqi9urAvVc/y7wUi0vH8CnKa6oWWrQLxIiWC9
	mafcLCfbkpRBUF6TkOBqSA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c103e8dtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UKpkOE012776;
	Fri, 30 Jan 2026 21:00:03 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe6d1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yl62WRKgshqou+s5tjAfQn+EstrKd0HFQCxOjpZ1nExKiMGGRrDDPE8Q5eLKhpnvzV+CyqTjqC0xoSmywgirQ6DZ0WPPGU4THSmpMpq+iVI3RpOLuLUdXpV7/csREJTMH+z9xh4nGgqoytDQy6bsML9m6sVqedJDZOcFgr8zi1ePoxrYXTmDRuG2rrRY/VwEMsPwSVNBjnpD0PYb0NtB2GPG1t0WMfs1FtGdKiaCG7UHT9DzlPqEotkvHVhl7t3b4Q7XXGtapp/wjykNqTABxlKdLlBpDYTftpwla8WQV55woysr+odUG0kWha3sWsEFUqHvpiUzmDZOnWoZVIxcXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+paSCMylJ4zGtmQlkiq9rkiWuy2a+5XA3oGRYJ+hhY=;
 b=ONinMHvNo7IXBtHJH6mT2E24R+MjLFxtbz+Ms0yIdUsgY2QR4SPLM/TiaFLLRZxQZvnzUuvQGwARQSZ0AVxt9TYDlAZef3O3AlhwRR4Y3pPhiz/wb3quSwfJUQAp5LeTa6QlBFO11tvzj2amDE6jt9/tVTneli10LBe4HV7YzHaIB5qmeWNoNxYG2B1NxLv8pbAWTZdVREAYL+3TJ/UcirxLZUA26fDs2Aajq/kifMy4kRu310Sj4PXAekBFTXcoDEKWYJUSBwZlmu2/4Ts53En7oXB0F4mqMyiE87wj6AYBYOIV9qz/vNjyVDJDECrkXoRBHpJ9tVKDSvBMLwgM7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+paSCMylJ4zGtmQlkiq9rkiWuy2a+5XA3oGRYJ+hhY=;
 b=nqJ5NcvzB6zdGcoSeoSBUO1tFNMmx58LEgSn/IgS0fQ3YnzM2XmJ6HLarfegNojCiOohn9lxG0H976SmeHghSGu/3LOsoUXdsqH/Te1Nvb1cpZByY82hJSWuI1y/E31FWcSDOhw/2eN0Jccxe3T50FdLoMA6+KeNbILta7qMIjM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 20:59:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 20:59:57 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 01/30] maple_tree: Fix mas_dup_alloc() sparse warning
Date: Fri, 30 Jan 2026 15:59:06 -0500
Message-ID: <20260130205935.2559335-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0068.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d203c5a-afd9-41e2-c648-08de6042867d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uwoSMVaGKURa71nrNlzYVnNuhwe6V/OyKO6OXA4nelSXh1+MQFhIGMjYVmea?=
 =?us-ascii?Q?ceCrUY046CiTuPIKOwYN2pGr2coBwDKBUW2btLwuwHosi/yAA6R1IR7C+NCR?=
 =?us-ascii?Q?8aRO0aL2Cr5prPWWU+TF7k+7p4jOK6Q7EY02VSuJxnLcfHCz/9RMfMVmY5Tj?=
 =?us-ascii?Q?8nYM/dm4aqozDUd2NywppQ1H4ROfYbUivqfnCkJc9CsdHMTYY45tTnwy4XFo?=
 =?us-ascii?Q?IzB3MG+kfNL3v5rIcFw6j3ZV0wbRK03U2ajjJCE+EvPrAemd/XRSpofi6Fwa?=
 =?us-ascii?Q?zEwu5Y11Mb+GujkhvKzyGaTloIhylmczqVoVzK9oTqtSTkcdA0AFR3pK0aac?=
 =?us-ascii?Q?u+kkaWJKLHJ8GXwhY2yd4AwT4ulsfiZA8DMyf5p1N9u6Wc+xizKNYDnvBFT9?=
 =?us-ascii?Q?lX6aQEPJpV8edzw/bc36aFTKSAh4epjCnNioymDP2dee4w7sNjt/p8gct4Q+?=
 =?us-ascii?Q?kGI1Yuydrw8JjqJwbsVzut0htZRGsD0SOD4xTqGys77KblxB+1Jn8DFXmxbc?=
 =?us-ascii?Q?8JtzTy8KDnGY+sHdLpCoFb7HNIvUjCx9vSZs0rNedyGIib5gXVSD8jD25/ll?=
 =?us-ascii?Q?QQRZl/XBQ5qoDGC/jd1MhfYmPQfV67idGMmQZ9Xs8Zf93Bh+cu9fEWcIV8G2?=
 =?us-ascii?Q?nw5fRetuIG7H/6yjwJpeNQ4NCqvqrqMO5vqXpmHZ88PHB1kOdli9k3hBJegn?=
 =?us-ascii?Q?bvXmJdG848tdiO7NwhlvF4ONfMevxO1kon4eLPKkrHQdPRXx4dnvanIBPlcY?=
 =?us-ascii?Q?uHkCJ2PCqUm13Iw6qjI9jmUz7dCTPKmSMwSRS0PKLfC7TKu+Dh0dytMaVmex?=
 =?us-ascii?Q?SmGB57WavwOdAGZWHgMB8mrQmUIpeB1tMY+uJNqr+rtZlh2wpa2ewPKLcLtl?=
 =?us-ascii?Q?Hv/HHmbq43d6WpdTZIeR466sKUNr9wpV0IZ+1yMlDq+so3yVJWzikZCw03dp?=
 =?us-ascii?Q?xKGpqZ9bEeZmgyIe6xEApgryNH4wN+8ZccenGoSGo+23KURk1NcBOGONGJLK?=
 =?us-ascii?Q?JYn2nQzp9FGbaTBoZeMVRZL56Qz02IiVVvD9WIFBxLtwj55jQHDIGCt7Q2Hl?=
 =?us-ascii?Q?KaprGp6xfw1LAqt4RcjijNwQ0ZD/lFvR07VFD15qIMRG8ic6pPLzPMh3vkOu?=
 =?us-ascii?Q?8JvF/IzcETQ7bWpFbUZ8525AnTlbrSImW+tMxZFVsmb6X/uLW5YLluOl5j38?=
 =?us-ascii?Q?aBRPHUX+4DdQiu0e8sXKxlY+ryiqK53mOJHTFHOsSdOgEuLk3zasWhdfyy9H?=
 =?us-ascii?Q?rV214/R3DawSOtAgq+vXW0Zhm1wAmvKc7LErfovitSsQ3PQrfcF8AY5GYs0U?=
 =?us-ascii?Q?KNCTBdTLm9btj1L5JaFzcQpURuMH0YmEIiCbJTXQSuGk61esJd+7aOOhjIVf?=
 =?us-ascii?Q?Ro2zHrronQ6wD/QIz6DaV9nkF7GA+rH7luDxNCsF1umBUPZug6lajpRvMAph?=
 =?us-ascii?Q?gaJl7ge8QeAs0UlS17xQjrwPgR3P97zNwp5UbYdxv3RHl82BnFVvEA68Tot8?=
 =?us-ascii?Q?/ihvoHVrnK+cElQ2fpr/anshXwUitK1SZMYYVju1vAbVRha71EzfPopnh7Mz?=
 =?us-ascii?Q?tO2kelnnPLuhfMLW21Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?38+WFLJyFgodf+8Bn9jH1D1wh71FO+6XWclocqObo4fvAYoQ6cKgi4ePScIK?=
 =?us-ascii?Q?GFv11GgU9tbLGb/cCQekN4zPYUsdUCdA4LlE12TGdIDM1h+RPS9I4cNG+trp?=
 =?us-ascii?Q?B0fQ9mn7bW9LxdU4LzFTzFOUjC/evU8gJk7oyUpvuLbvUDEEoWado6py66yC?=
 =?us-ascii?Q?HG25tGa2Ejg/1wY7WXH7P8N0u3Rx9paiZ+nbe7GVQGP/Yf7Vb5/+yp7kE6R+?=
 =?us-ascii?Q?ETiTm35dDZE81VOjJFDUhaQtx/ywYOKyK5c1TmvXcA1TZerHBrYrAK+MT6AQ?=
 =?us-ascii?Q?sQfzhCiHdDzIExNHSPFSSLZscjif/MavJ/17Z7E9bVz1QY7DiyyWmUW376VG?=
 =?us-ascii?Q?Kh2R9I6KoYpG9UiYcnoRrJ06LJqzAQeH5JYxFmsPcPpTCrKXMjWLZ5fS09Io?=
 =?us-ascii?Q?6PUvTOq5jKkrcgjyQk1oLFPsYc5Oa+MJclb4hardgiVmsiMWccG1+Ac/lxQI?=
 =?us-ascii?Q?XLm3hG5Gq799fjMI3FLQ87dD7hXIdfK6bhlFaYpylK4YtS7q3+pxjhfe/H33?=
 =?us-ascii?Q?ZukmgcXZQrIpm46RiFJhH82xBTr6NTaJLgp/GSbL1r+nvZtzK3JAZMJ2ZDGT?=
 =?us-ascii?Q?A89Y+QO60G8SbUC2C4Bpm0kt5XnKf4KIaOqkJtZo4cWp5DFx45MYggZwDrTK?=
 =?us-ascii?Q?6ggIz4lSnYphg+hw3Bc0Jf9hDlK+jwi/t0WHh6tDSH+R62oJst5mesTxgMmr?=
 =?us-ascii?Q?d3soz0su6lsiQFBArB0XffLyaQ1EPXGqSC2MyMRmU76WgBFiCIHCe9wH2x1S?=
 =?us-ascii?Q?P7+PKMkqteUUI/Nt+bTiYCIC5uWOxBiSfwTVm9/Ns3a9PN4wH7xtuYCp8af4?=
 =?us-ascii?Q?jvCkU97wli+JSxrrTL3AVrxVmG6ddx5ubyrtauBJuRZjZX1AkMMcRuVR7Cmp?=
 =?us-ascii?Q?M9hTf9zpYUVzic4lJ7HevvvVCCkjBdmV5Q/mfYHnaa3xxzsNr9yCORFurgsE?=
 =?us-ascii?Q?nkuHVbEd9ZiSWMKHLWb0/4SUZUuUyhIjc9W3h97xLUS1eNh83/WzS6IOpdGh?=
 =?us-ascii?Q?VWkoPPWvz1CdGKi+Sru29t77+kFHFhFWRV6NDPH5BqCyDhg4/PshXE7RZRw1?=
 =?us-ascii?Q?oc67HvzV2DA+PPNIg+/vwUO2IyR8TM47XUGcQtjAWXBAWPG4L8Avl3d6m6Uf?=
 =?us-ascii?Q?wb7e0g7HvFvUIL7cGTte6hRYVMZgAzwRtPSGzTFwuEumcmXQuh1lS0X46o7L?=
 =?us-ascii?Q?96bNqaGbQY+5p7/Pr7+iLnQ8F9UMtuRmflRxgOR0j090Lt955Rso6UUAv5Sk?=
 =?us-ascii?Q?vifb1gmBeH+GcMM5oObx9NY07jJvNpzvagaQeUz5SOaz8W5nV32JnOKCOt9F?=
 =?us-ascii?Q?97kHy4Znwuayjnmu4Od8AdykLg5N/JLbXyKZTcF2/BpYaqb6kvnvXSbkVCsY?=
 =?us-ascii?Q?ybizgGVJqH8G6rolXTKlnxYYPo4ikQm+n5lvjleefC9cYk6Jqa8o7HZbrUJi?=
 =?us-ascii?Q?LMuc8jo70WhV8dnSmmc5Qj1ZtpOFHFGen6w8rCXAt7nDX3ZKEYZ9m0Og/6kU?=
 =?us-ascii?Q?crvccCy1JjTVaFLK965JW2L+nKg0PGGDwVYIs9hI5FK1RvuxhSHzfSeFq2F4?=
 =?us-ascii?Q?FcU87MTSDGot4cpRnKbyfm9xUhi3Os2PaszdJNFG9yNwQW/QsgoJJfSCI3if?=
 =?us-ascii?Q?gMB+lrcbUb4rvm0vVYaBN6bMoKZUC+5TNPH4nhguFGqYftYtVY4KLJ/EDCkr?=
 =?us-ascii?Q?ne2zwST+n1L5/67N6rO/qGhfw8SW/sTaliXrMFWF5S3FXDIZ3Vh/6LjsVoE+?=
 =?us-ascii?Q?mdH3PJsw8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	47LGxIQ0Sw+WQG7FY6HsLJn+bTM/JBQCah+HGMMQmTC0Uy/b+HwVpwH0ERsQ/2tkoBiY1lux+N1EBxWn9gKn/Xybts2/KyhMR/CcbQetdNYE2Jv9XPGJs572EUO/B6TY1PqjdbpHavS6x1qguONuzeRv2cO4mwf1IJ2QyCqgSKC3xLu++ZkZeUe7WyrxJ6PbeLHDJ+LGPqnp974pQFDu78PmPtbMmeCUiUyHvjIICWKFupZzCh+mAH1Jx68PQjhn976ydEW6ovZCG6vVZVvoaSDMqOPcBOTNEBJUMrzyJEx9ww5y0d3cSYerWa5VHPPRfPzTgwlfdkvtamXpnxJB/rnESYg33TGn2bdy242viPUPmykBBYLiyRwcbNl3Bq2Z5XkVG0I6N37vofV303aNLjxluGGIKKarI+Fhdch66S3ioZO0c89Bz2R8ajVvAHYiX7XN3CktXj7XsNinmfQ8Q/ybOaQT+mX5ubq69/lIkExxRYVJHxQlL41TzLtp38pqJ+nduTzO0UdWWzO660YQawhIdaaJY5P6czRQjwAwYVjWuht9fgods8H8bZ3qokUnGhDxo3FvG7PsZvM4i9qjiRX+zV09VDC47RpDT5Cpsrk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d203c5a-afd9-41e2-c648-08de6042867d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 20:59:57.4751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZx6xHy1VsiDzQSy/lukupnp8+grVUS96UR4DKLTMVDuKWx0G1I/4v0ivGRsibVj7BgDnxaHvVVvMtCsdgnkNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfXyUcDt7FKU5A3
 /fD1Y891C5c1JlWKwcTsgvNxBdcAk7M390Li1OvEvjMRYY5qX9G+wiW8ablIm1/mpxzbp7yw1Zc
 c3MhjYaCvb1YZMcTYOvnDjE23RdvAyf495vKjk98ucQCym3oPwaKBsg0DiaE9nxwfsSFlQfYaoZ
 1dLou1AlEoMqHFdwo7LBfFvBX7aXbDODznDXyAiQcRZubiArlFQfwzdTB/6UtldJe4XRflkVP7P
 ImLJP0c2N80b1mYGjMPHnTYFwvzeOq67BYNoC6SFgC/cjxNHMvO6X/MKco6tpXu+VdsRzJRu4nP
 YO0GmCQERYNsHOOekE+mJDajfNQJBvtEojtVQN0eV2bswqBWiTH5o3Jn+BGjGTs2nsrcKfk6PdJ
 3tR5FHppjx6/w+TUhXMNweedqHKhsbYKuy06ktYyC3Uta5v/hc3BPgN1TeZK1+74EgOWcDp6i51
 cEDGTnVmUIJpjpo3GhQ==
X-Proofpoint-GUID: iLUUM9VxBtJts_N--7E3mhPgOtTmxs0K
X-Authority-Analysis: v=2.4 cv=M/FA6iws c=1 sm=1 tr=0 ts=697d1bd4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Y5ejhBfbtcslctzzM8EA:9
X-Proofpoint-ORIG-GUID: iLUUM9VxBtJts_N--7E3mhPgOtTmxs0K
X-Rspamd-Queue-Id: 414E280017
X-Stat-Signature: ift9ka9r1fxcu7r41o8rwu93me43bhxb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769806825-273876
X-HE-Meta: U2FsdGVkX19+wOkJfzcBW1LJc4rNUNiOSds7AELUJNHcSRl3xYjqsf+4fGpx5onCWV8UTagV4unkQ21p5z0Wi6k2wdIFNSm0wEjSRCLyOcj9hIxY/Pr35+bWy0Xm+kRnO8jAEFNFaQEobVgephzz8IEefKwrB7QT7UMjhcNGRP1thdbFipj0NNPwRLsUexdMk2nGmJCl73ov9RHEElat8pisjwTRwBVBRMrQE7iQvgNKj96U17RQ4tGJNE3xry+YPdvZEvOMx1r8RiDDg/+vPutaXqp2Mni17YkNBmnDVwlhVm6uhO8J7cUDJ/OeBM8AzwgGBjoPAF9S6nekEhZi2un7jEZqoqilHscGFfnmnj+rk8PDDtQE5iOytUhBtCpi91JtgRegCxcrbh35itiHYCyguM6zE993OZSJnn4nfwOAzhfsIhUJ7e90fOplocpg4LYXFFOxtnkApx2ZH6N1f+B+jgrbCxFegc11sESK9awagaGkGA/yt1sei2zwOBVL94z8m0/F544n4nVuW7JaF0A3Mq4R4e3Ak2FRSWBIiianoAv+QDTa8zPoH+58ZpCk7aRkOsHZj62pQZ1JnyXaQJ5H8EfdyVrEGRLpUQ74QJh05RlIijYzHl+mpdfhKaJVnQSFSLlIW5tqxcl+2QlTdicMho3TyLw3iM0taR6V8ZFJ+oQY3XdS3vpgyUdH58it0HZZtORQjWv86wjr+L3GteIk1nvvIXaKht+onG0P9YNVtLH0r6ZXPrUEUyf+dtpGvt9u9KQpgJrvhsvDtVYz7AacQRrZjAjTZMSLr2NcFhGsTMmEtURH1EpYbhF1XK+g1JJe7JNLC+TcHn5kDEpOuz98x6U5Eyq4B8mRPXMs7CD2olsysXlgcJ623vwMX1xJfupkydoqX1Ik2Dlk65MRajc9qkPqLX+5RXJKywGN1qXmHEJv4/xi0duDBqNDUirfQMj7Ov8MO/3kg0vqlvK
 3Ir6tFGq
 m8jqfhUQ1gLbmJh/LMqxJeRrPZ7iy9blZlxTVM4W3hSQbOvjrNTCZGZkKQ6m3r9zB8OsmfwoW/Ht5XAN3+tI76qLrFyIh+eRHIF/jC7Bb/2Ve/uh2tzF8DRn2+TcmIYmKDk/SZQ2LtAEkPdP9rQIHnOkyG2dWR9Qq6VF9PkY/7zglRVJiepFg7Fyj27wt4MFYIQ40Q4bhb5rhKtL7YF8EhO0zbP9CKTd8lBULQvArkHt5dztYoaiXlGHS+tNarEU9gvHk092781ZjdLqDuI7xu8aQdaR1Wnq+0P3Wpipz5HxmEPn7gwGLZv+n7pcd9/ST1cF5QEEjdxH85seKiHzbdAgO57aCPqxwSYN4xsLSnXnR+AYkI/RpQRtmQtD6802sNKwCYw+uL5zkM9CMHfmsJLmzKcHAliXbWA0srXASsTaj5zykOaapRfd88IVkx5rOhJd67YrbyPTCC4rYrZ7V3govS825EIzAYJ2CFaNOAFXPTZ2ohnLWbXzu3oLEObSEf7dPclLR8ufRhAO+P5BXW0xm6KpS+J7DGVLT/+qNJy4ElItyTEaFm6RKZf1XvQHzomSFwe8UeaxDoZCLyoMSlxl6ZUP/3/iRNWyBNFF9/IRPxGv0TAyxSHffNGRiC98lp0BZfh7eEQi3gs8LBa/SFhSCiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use RCU_INIT_POINTER to initialize an rcu pointer to an initial value
since there are no readers within the tree being created during
duplication.  There is no risk of readers seeing the initialized or
uninitialized value until after the synchronization call in
mas_dup_buld().

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5aa4c95000188..0e0158ee7ba55 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6260,8 +6260,15 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	for (i = 0; i < count; i++) {
 		val = (unsigned long)mt_slot_locked(mas->tree, slots, i);
 		val &= MAPLE_NODE_MASK;
-		new_slots[i] = ma_mnode_ptr((unsigned long)mas_pop_node(mas) |
-					    val);
+		/*
+		 * Warning, see rcu_assign_pointer() documentation.  Since this
+		 * is a duplication of a tree, there are no readers walking the
+		 * tree until after the rcu_assign_pointer() call in
+		 * mas_dup_build().
+		 */
+		RCU_INIT_POINTER(new_slots[i],
+				 ma_mnode_ptr((unsigned long)mas_pop_node(mas) |
+					      val));
 	}
 }
 
-- 
2.47.3


