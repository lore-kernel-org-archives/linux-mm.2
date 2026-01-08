Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA61BD1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3AD6B0088; Thu,  8 Jan 2026 12:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAB16B0089; Thu,  8 Jan 2026 12:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036F96B0092; Thu,  8 Jan 2026 12:02:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0F326B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:02:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C086B7044
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:02:54 +0000 (UTC)
X-FDA: 84309416268.14.4EC1859
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3486BA0007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:02:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cjnCnF9w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yWOYu9My;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767891771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5huMWBTvyYt5gwEGA2wmhynAcPsAnabAnsfkI/mqF4=;
	b=J2vqydiaLuHaGv7fuAb53srmIurxylwfXXC0Vi8uhpA3Ut3nVGnrC8w6fFYcq/SefM1Gk1
	8wrTQyMwM03gi2a1OfTtf7Shq7nWr32DR2gAoO2a8PXiJCML0OJzbhceACDOerWy72a5gA
	/ZraApTXIc+Hg5jpjLiYa8Ldt4bkzJI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cjnCnF9w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yWOYu9My;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767891771; a=rsa-sha256;
	cv=pass;
	b=4EK6FSZzXdQR5DvSggJA5t4gLPJDTLCRUVXVDYHNlDiEnhNxi/rs7ld3Nx93xQlFPm3VL+
	eZovqfVGo3fPsUEvwUG2O2UzsFkOs/ATdFmdhF5vue9ee55LfPOcYFPFxQNFRU6NMD0vF5
	Vl9tdgqY0RRl3nl9sUhEFSrls1Z7A6s=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608Fss8O1008991;
	Thu, 8 Jan 2026 17:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=g5huMWBTvyYt5gwEGA
	2wmhynAcPsAnabAnsfkI/mqF4=; b=cjnCnF9wKYjnbKyzoDBpxH2No+AcmhqiHL
	vdUXz95WMZGKC2TAx6LtCRbksB5iSfFJ6PCFQlH5ejb4IJ0os99QahGXtKgArKqk
	0KjOkKUfKOBZMyizOH6bHpQ5NU21PJSvyeNiO+ZZ5rS3OrLnGXgtCMSHxEB/jEzN
	1vK4sTmtkRbEUksaFsP5nGOSYhA6uF2NRmUyWYgLHSMwZflK8KJARXWpj7X38ftC
	sJhqdEwkrYvXuDazQLdCXRZow6aEyKZ3/NDOvGgBRlWoT+5SW4do9GTwDNAm/6d3
	Cj8PQ5xUISU+DMEJH4dvgCMdeYGUo28vpgsaXR/FRR1CdaXusnuQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjfn3841y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:02:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608G2cDB026266;
	Thu, 8 Jan 2026 17:02:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012061.outbound.protection.outlook.com [40.107.200.61])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjnk42q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:02:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hrnitLsuKri4Tj8v3CmRxGEFR/dkJCYwY8sUN5i1WLJLP0T+T9Bh6prlygCMICMSI+DTDIOngGBh63ssuPQLK58ZHJGPl4RczHI143span7O1IKYM0x7oeFzN90DgYoJ4TQfvq8zbL3NMZMLUQu6/NlOoBX06KRs6dsDAZI9zOKRWYaW0lzE5sL/r8nXhEU9q78T9yrlgv/gTpqpmuohnq0JBwtMSj03I3O+IStecALMlw/jk98KSYeCddGQ6vAY1S6wsnVhfG/c+ibNu4xOzv/QPBDCayMsTx8ZFpoFstftkw8pgY37HKNJaS1FZ5kUzw8O6zOFmfZ7LUG+q8HSUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5huMWBTvyYt5gwEGA2wmhynAcPsAnabAnsfkI/mqF4=;
 b=zT8wFtwqICjGa7cGKIoaEP+cZEHH9hDmWuC2T6j0+qmwJhtr9iTn68T5Bxh2vDL909EPHBLK4uhyuTravbPZl7l5tkQxLaDnATEaSFlNUP04JXTGYfdFPajfF8TWWmy8gxZGuQJsHunT8irt5TqXccah8a44hUe+7luy4MxmwX5NF0rP4Xyw0j+aoxQYCpLD0ojMPVZW6aBFzAtUkTYsSVd+d+4PwaBBAVws+N2Zk8u0A2ldYpckLQlvWUWdBx2Vn6aw+jckMzAAYyS3g3MiFHQ1l2ShEOGwHj1JDgg61nGsKj3lcm93fAJjqtXvJdYeh7dNVXJfX+wEVt4wyLcsqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5huMWBTvyYt5gwEGA2wmhynAcPsAnabAnsfkI/mqF4=;
 b=yWOYu9MyzVaCcX1+ZmstQSfvi9x2vIT7ID2kJWo5VsxagsZudFn3MgNGvH81iB+2kXdZ7vgV+xcM7pGUZfzLAwqtVk7cxb0Cp77RKcgkr5KKlKOJDHDc6AtDGvkneDbsMXwNS8VaQoTDGXAgXtJM33IKKm6nS3tSY3CdeYpAlTk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA6PR10MB8205.namprd10.prod.outlook.com (2603:10b6:806:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 17:02:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 17:02:16 +0000
Date: Thu, 8 Jan 2026 17:02:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
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
Subject: Re: [PATCH v13 mm-new 02/16] introduce collapse_single_pmd to unify
 khugepaged and madvise_collapse
Message-ID: <4e814686-4ec0-43b8-89c9-3f564e093d92@lucifer.local>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-3-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201174627.23295-3-npache@redhat.com>
X-ClientProxiedBy: LO4P123CA0541.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA6PR10MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b6ba24-1922-4e8d-9300-08de4ed7ad38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4USRwK9tzR9i4DUtkfOZUTzmi30kgs8dH0QmoJtdd4c9OMd34+KCgOubySBM?=
 =?us-ascii?Q?CcLoZT3/30ymF/PfL3ok1BvUCTEtiPPx0B9IYig3BgE+MzE3V6sGNFjo41vA?=
 =?us-ascii?Q?pB4ZOfXlW28Se4DeIL3JKGrqlDATktjiRCh4af8ifN027WTeDiSVm+wZQjWF?=
 =?us-ascii?Q?bNTzeHSVLGfSI1PzuT5ApA6EvbMv9bZ4OChsd1gUftZnaH09vsqOM7Fmyx2a?=
 =?us-ascii?Q?35tyBGStNDDM0noohfRelAGx3Nl4nXq3T0Uk5dzkixdkJ2JuUwbW6NPoXv/c?=
 =?us-ascii?Q?4E4vnMCAGe4EMRwsWzRmjJTqpaP9jpjMfzOet+Q1rzjZDdBR/w2TRIMowj9Q?=
 =?us-ascii?Q?5WVpeyYCOyWK8D1QxgnMhm3vDj+uYetlsMvcDlJJinRnbWg7+S1zqrd9szTg?=
 =?us-ascii?Q?aZpVvjmL9bgEL5n78HLpu/c0hdofXYMl2tDUY9CYovJhmgzsswvk/xQi4AAG?=
 =?us-ascii?Q?bt8bAbAxVrmQWKKQDAqDaIhHgGQkMW3E0bdk1RTDrbtRSUmb7cSaBQ7aEsWH?=
 =?us-ascii?Q?cIQbK8IOdqfkyRK5IO6pbhlbKcLLFNEaqrMGyjlPeLgo7rP2g245w2irONQb?=
 =?us-ascii?Q?mKC1Tpu47P6MO/1n90h4pCoMAbIJ+RJ9oR8XfTu+oAu8YeQ/XLjHbtC3F5hv?=
 =?us-ascii?Q?8jHy+Ko89n/G2sAckcTO8FQaOZyB1iyvvzqEaFUccfsVMAvcl4Kw7ENYC89P?=
 =?us-ascii?Q?nDbwP50ZtusmGSJnpL6gmdiJopPGwmcxl/ww4B4wf0ANXO0Z12alGSiaavzh?=
 =?us-ascii?Q?ZtWnN1EkAaegaid9txKiVJFPAGqLJtNv5FMWIBjCKSCXkEOS2gRVkECKWH74?=
 =?us-ascii?Q?20owwyDRstX7q8Tk3GBrsIWkqw17iIy6yUNeEcDThMUZ1DClp40Lkt5M2mkS?=
 =?us-ascii?Q?GU3kbhwKnPp1cYkfFAvseOcvbYGq/oJYHyRrx+KfNqDYxKuY8c7UbOO6xkTC?=
 =?us-ascii?Q?nf95r95Vj4VpIOlPjKoGFUOOAoI6lp0aXdxaocQ1/0dKs61i8YXUH4T7M7yA?=
 =?us-ascii?Q?xSFZDJ3Y+6uqk10TYr4jbtWKdKLE0GpZPI2QmLckCzLCUdn/hLkZjgt+DssA?=
 =?us-ascii?Q?OHPR3JmtWtj/K4EiQJ/DmPBM39ks7WGTzmbfAh4Zz2Gb67zKebdQk5QWdJFt?=
 =?us-ascii?Q?fFm7/U+20v4Aduw8Gm60GxUHFlYHjMAvJdJJx/saEVzyHmYz21gCbGaC/XYW?=
 =?us-ascii?Q?Xhi5EDNh+rFbGx1VkmyoPMOhGKQQXWczXhAFK8VT98pm5eJolhvJP120iGJC?=
 =?us-ascii?Q?QNuTTZGQlPph9UnXUDDbrPSqSSmKUBv0a8AsP1bXDcXFHxFaClMRUYQ/90HE?=
 =?us-ascii?Q?vJ+rJMvFG9jDFUey35UnX51qbmjktgqNK18baNXWIx5pOvf0pXDxOX4VHKco?=
 =?us-ascii?Q?6KYQumxmvIgxZJkm+G45KDRwgS3DQrHrKBjNi6zXTc3/MRw0e3vkoOJ/uhXq?=
 =?us-ascii?Q?bKcMDSwY4mZLoOIQT4LSMlfto03+VWCN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b6YFVo5YzqEf42kebKstvkYm628Wms4j6cd+e/0xnNFbOCBig/3OXznVgSYl?=
 =?us-ascii?Q?7nNGcntuylo+KCm47x1IlPZ9vlAJiXLKmjgDGcVYzhH6CMZTvYL0Znjp4QxX?=
 =?us-ascii?Q?LXbwTuIWQCTg2CcYGrfYhj37qCkvS556K9EWTTyZYQlHmR7OkfUdPDPGfiCl?=
 =?us-ascii?Q?i+A3Mc7tWX3HxTqt2hxs44Ernwmh6QgQ/OOX0C8HQuQaH9aJjyQ4sGBZ7Ygp?=
 =?us-ascii?Q?ajN7vzzBDz20XKg1esqA2G8wMrToPoghluPuPvT+X6F1QQPsah3oUt07jFCl?=
 =?us-ascii?Q?wdPtmJGgwGNzT/P/LXaDn2xb5JdLdZ5nMUyFLQGfOefMjBbmkDW0rZA8S6Hi?=
 =?us-ascii?Q?PnjYHs/KtN0GhkR6+MiM6eKWm/fI1N5YvskxnOf7KSGE3UwKhVSjldo37Zle?=
 =?us-ascii?Q?HmPa8swrU8m2giuIhmQAnuAgOcDKcissTuxPnePLQPkl/yG9Nh4OmFP17wXQ?=
 =?us-ascii?Q?R1GyWIH4PeoUMj6WMdI0JbBT6Z3CmjJtXGE4CyQi3MbwuPuTdzHBXdet2vNj?=
 =?us-ascii?Q?rEEgu3NqtOFwXGFkQz83CvZ/LSvITeC6L4qFif1TWjT6XHXnAWSSVNYpQleg?=
 =?us-ascii?Q?n1CvWM5yHX8D61UFZSt/XCUsimYKoFh2MMWcbF/mSZwzKiFTQPuRg3Oy1Yo6?=
 =?us-ascii?Q?oHB1xFKY8jRwCvGOi5dJ35FIWoRvq4Bn/XxjD5YLWLyQE2iKDPCCBTcAufrk?=
 =?us-ascii?Q?eETN4zsXi80AFRWBjf+KaA2q+uOnb/eiepdPVMq7kz1xRRChTqsq57PV3ycJ?=
 =?us-ascii?Q?ZXeGG+0iqH8On5L94yA6Yc5zoTaBiMUSaNwa24qyXNGaZ8wfbE2rcclm5r7D?=
 =?us-ascii?Q?dZICANgmWUJ34CXR7KWnaQ6pzfFYwflX5Ru681k7Jv2DMLH6/s8go2QLRtfR?=
 =?us-ascii?Q?Txv44idMNeLnzfvRs/fTyHxYx9am/J61GhgWxHGtYNSpnMnAFgiV68RAO2pF?=
 =?us-ascii?Q?w6UP9TDUYQhhBcBNDrd1WXAoRfuAfgdT7GtRlrdS9RZZtENpoyAiEpaAFh1B?=
 =?us-ascii?Q?XcWEpMHSvYrc3AgkKlYA04acBJRtaAVXhAD75vtXNI+Uxa8C47zmXMyfXXUy?=
 =?us-ascii?Q?jEtmqIjp2nLMeO/Ln10KrXUpdnZkQznPGhQTIE0JyJBKyWjt7uo38FUvrDQr?=
 =?us-ascii?Q?GRLMayRI0IDl+udd7t7aW4655iSCS1PdZwogbvdwEXlU7u8PDoxWxnZSJAUm?=
 =?us-ascii?Q?+sXkpEKrFYdajUldxMe5qg7/S7WsG5ztbJVtdMqHuK+KZTlHYwll9yXfY9pi?=
 =?us-ascii?Q?Se5mkfUrxxRl+tCVnddJC4gfVPdEaxL+NtNYb48svcQQPwzgllfwrVQG1TEh?=
 =?us-ascii?Q?gAVZOQTHRAjtmBgcc5nacp6hxQ+iU5d2Ox4yrfH7sAMKLwWk0OoD6NwIBbMp?=
 =?us-ascii?Q?fZGUT1sRheAV0fztS1k/J5sxAL+CREaSUToccC0zx9ApmZLcRpfQN7K08qiI?=
 =?us-ascii?Q?cJKx3uOJftvsP/T9iTBvfbrzt+fw5FWfHTrnwLMVztfkzRc4H5GENMSJSCAV?=
 =?us-ascii?Q?fDwq8Ghg7lSUUFME2hbX0w2ZYiuD4NgIwCqmCO1sVt1JUy08/g047WyCY1GQ?=
 =?us-ascii?Q?0s8CKEFwEniKIOKVYS+5qqJ954Rp86+9PPJQ1HXI84qbu5rxnwH/2OiY5pf0?=
 =?us-ascii?Q?e+rwL/k7jhY7usph92SbDrogXDziSXZErCpr4bRbsjaL0/FHymG3kbQwWjeh?=
 =?us-ascii?Q?rNQFblfgHpvjDeLZlRobHB/2k0ucxBo+lVgXGHq3y5r6X0kIsKFi2bFyhOR6?=
 =?us-ascii?Q?Dka35QORDSHtpF0E2PFAofDahH1FDIc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kljLb675O3yGJJi+B5CvweqTDea46aYPR4oj3civ0xiWyvuFJrtr2iXCpgMoKaWXWG6lGM5RBFlJ/yS4Fqj46iliD4byNLHXomWEQ+Ph6jZdWBCHTwnzszB38NngiZDKlDuHulWmxuQP3jS8AJrIl7H6qJlqVDyb2Toy40oacIi3nwqrU4pgLfQvFODiiFUP3mCzaL8Hxz2lLrZaAHQejD7IK75dQVsE2J7dSKWsULMGkvV/CoXEstWHd9kbRzYLqhKqRW2TXw7FDaeRW1d1mZrXwbOQAOZ9S/8zwHssuo1tsgNQ0EKF6LfSPcGQmRVUllQqxEE98YZAZfJkU3eskz/Iwt9pWnFsc0xM1+x7MaYf2I3xRDjRACfuZoWclMdcU+mlwMkg1zc9IeHBjualXigxo8icA3XZDKOLpUqXYueLctP5KIb59x6dGErGm36VddduHz8VSHTlssa3sYXkHyN5VTyovZlbjlhRFkYxOZuTch/iSubIX8Llt7BoM7XtIIV9FSrWU7Z3XoWtGEpxvLvwEJRHppFfJxTR6vVbS8qefZW7hLXzztjmJokFYPSs2kP4dlkJH7RuEsfyANvCXah/JoowEr9kzj9pw7/rEoc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b6ba24-1922-4e8d-9300-08de4ed7ad38
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 17:02:16.6661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyzg37shFsPz43M0h1f72+0zyj+++vtXPvSd+dGaooD26b8wqfnkJ/500TetjlEGZ+M1RJuLBaXmG8KtpQOfMxFwonIiTC7rzxMUt9ddKtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080125
X-Proofpoint-GUID: c6XvlAmPIAuaqS-N0gSLQzIQjM1WeEXf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEyNSBTYWx0ZWRfX0hcMBL/hp+Ae
 esMbyEJp4HYEP7rKz9uOw3rshyNSHxEqnhfQaXeagsN2YM2mOcT1aKWobpyU0RLfTFqDBXbV3gs
 QVaYj10VIcyXzUnfsnukz5Xrzh3cyz4ibCsYdQth3XwQyQ5SbjnK1tXaTk7fe+2E3CbGJ4+xyZc
 Z1+qaEQgXRqZTBFk+n/0cGqxBW9HsfmzSUb97pTEIbUqTuJHNcH0Ex0m7AQFvZcLvMcMufa9wX4
 TeDDXY5UuJ96wApQAxnZMtJWhrmpn1BZ1TRs1EgY3iwFlRW/gXlMz+7wwxuhRnG+CUJlZC4xQdJ
 vY8JBH55dpeSbFTVMm51p+UPO4IicAGMWTFM2UbjzgXEOWFeOVJWURBk2jkBsmLeGPG1/UQCzK7
 pYEB99f9aYiqdACdDbjDviASGy5XRfbpJuj7QnOrAdeH3jjuu9Jguv1F4FYuhh5oCmPkjBOb/o9
 Gn54+aYMZxk7l1ERneowJCw5xTIHIUIsZ8sX35KQ=
X-Authority-Analysis: v=2.4 cv=LsyfC3dc c=1 sm=1 tr=0 ts=695fe31d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8
 a=2vAQrQ5ZaQAkiLoCx6cA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: c6XvlAmPIAuaqS-N0gSLQzIQjM1WeEXf
X-Stat-Signature: hyq74kb1txfrmmxcyieo91gcoupim1pi
X-Rspamd-Queue-Id: 3486BA0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767891771-810362
X-HE-Meta: U2FsdGVkX1/tAkw24ANuIIgVEhgJexBRvs54HGkxNBaMI+qjhWYiR7w4lAQ70oL+bsXJCo3rb4Gw9MMad6dpJBDn/v50DUMK28fVr9wjm4Re4TZDbbMhQ6h8JvONRlfqcgKnEl6a/dViqAbgjAqQn5BbD9g2EORGsu+6SW4NCIyG5PceMzmD/Nz5gT6sWexD6n2nBcKrSmtPUSOpLUwHFBhqXfmadShuHPrkqHXZ50kIafYuMTlXfkinklKssUVsaTw8jcB2YxzsXHNDShxvMmEJo3x0Mm8LNxsR7W0dGfW2E8gNd/FLTN8MYSsl0j8NNBPi5Z6kFdAAjI5qyyVKGGn+5A3MJulAm7IQODG8rfwyiH7sh799Ey7qI2I0ZDxvtBwAKUqEKuASyKHs8C88dPs1QetAYBz+TRfaF15KPn/tL8heUCL5mcOMxPtG7HBhQ4ZZGxzC47IQ5t7KD5zj6Vanoed6TMY5W39QgHpcCO8HLygJ/JB8COcrvdkdsI1EDcadtELJGHCfFf1fwgQcIptPaQ75mlGEmpeihwllHE1BQtAHlkkTZ4nb0r6GxpGDEDlPXQWdin3dxNWCdwf4QTsZtn5MBrfm6t4T0qnDPvBB0qTXzsP7ElkAhzEGVuWfQkdr15/6HlADHSAB96ripwsIvBZ+Sx14atSTzMSlkyl+n7kYKI3dAZtA9HiDk5jNCnVJeKEH0g7InBhKIKt9IBD1VgBUYrPUko0RASCnGFPRxqvVhh3wgEf+HCqkBJrrqID4GBzZ4DJi0KoL10MOvRR2lM3FU64VQ79yXWVXpR/wESbHT77F7ov6SAm+8HwFWdDcm1LfCWHunZgQfts7jt1xaFURpxLmluvhw2rdn4eOEZSnPkfUnkTFNFzoub/tJQfTZqu95bwdD4CUe+7cwFOkA65zmd+8Hdnke3i5bPYgEpw7S+FLtURUipOh0slDKO07AV9oqawaqSUQO72
 5cpKOtDB
 tt4F38y9Hb82r6Q2BNAndcYRy+yGd3/AmmsNlt26FjOUTPJ2Q9NUHqpQK9b+jVa2n2TxFt2wulEGlmsNpmwJnHi1CMG65xL6pJV1c1FzWlY21NbXMmNNpQSo5TRtsoAxDehEp6RXMU6H+5lvKs0DugPOWFB8vKJJtOLqb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry I realise it's due to delay in review but, unsurprisingly got a knock-on
merge conflict here:

Looks like it's commit 823953d831d8 ("mm/khugepaged: use enum scan_result for
result variables and return types").


<<<<<<< HEAD

static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
		struct collapse_control *cc)
=======
/*
 * Try to collapse a single PMD starting at a PMD aligned addr, and return
 * the results.
 */
static int collapse_single_pmd(unsigned long addr,
		struct vm_area_struct *vma, bool *mmap_locked,
		struct collapse_control *cc)
{
	struct mm_struct *mm = vma->vm_mm;
	int result;
	struct file *file;
	pgoff_t pgoff;

	if (vma_is_anonymous(vma)) {
		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
		goto end;
	}

	file = get_file(vma->vm_file);
	pgoff = linear_page_index(vma, addr);

	mmap_read_unlock(mm);
	*mmap_locked = false;
	result = collapse_scan_file(mm, addr, file, pgoff, cc);
	fput(file);
	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
		goto end;

	mmap_read_lock(mm);
	*mmap_locked = true;
	if (collapse_test_exit_or_disable(mm)) {
		mmap_read_unlock(mm);
		*mmap_locked = false;
		return SCAN_ANY_PROCESS;
	}
	result = collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
	if (result == SCAN_PMD_MAPPED)
		result = SCAN_SUCCEED;
	mmap_read_unlock(mm);
	*mmap_locked = false;

end:
	if (cc->is_khugepaged && result == SCAN_SUCCEED)
		++khugepaged_pages_collapsed;
	return result;
}

static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
					    struct collapse_control *cc)
>>>>>>> introduce collapse_single_pmd to unify khugepaged and madvise_collapse


On Mon, Dec 01, 2025 at 10:46:13AM -0700, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing.
>
> Create collapse_single_pmd to increase code reuse and create an entry
> point to these two users.
>
> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> collapse_single_pmd function. This introduces a minor behavioral change
> that is most likely an undiscovered bug. The current implementation of
> khugepaged tests collapse_test_exit_or_disable before calling
> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> case. By unifying these two callers madvise_collapse now also performs
> this check. We also modify the return value to be SCAN_ANY_PROCESS which
> properly indicates that this process is no longer valid to operate on.
>
> We also guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 97 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 52 insertions(+), 45 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 959be77f2e65..433ea7283488 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2392,6 +2392,53 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> + * the results.
> + */
> +static int collapse_single_pmd(unsigned long addr,
> +		struct vm_area_struct *vma, bool *mmap_locked,
> +		struct collapse_control *cc)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	int result;
> +	struct file *file;
> +	pgoff_t pgoff;
> +
> +	if (vma_is_anonymous(vma)) {
> +		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
> +		goto end;
> +	}
> +
> +	file = get_file(vma->vm_file);
> +	pgoff = linear_page_index(vma, addr);
> +
> +	mmap_read_unlock(mm);
> +	*mmap_locked = false;
> +	result = collapse_scan_file(mm, addr, file, pgoff, cc);
> +	fput(file);
> +	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> +		goto end;
> +
> +	mmap_read_lock(mm);
> +	*mmap_locked = true;
> +	if (collapse_test_exit_or_disable(mm)) {
> +		mmap_read_unlock(mm);
> +		*mmap_locked = false;
> +		return SCAN_ANY_PROCESS;
> +	}
> +	result = collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
> +	if (result == SCAN_PMD_MAPPED)
> +		result = SCAN_SUCCEED;
> +	mmap_read_unlock(mm);
> +	*mmap_locked = false;
> +
> +end:
> +	if (cc->is_khugepaged && result == SCAN_SUCCEED)
> +		++khugepaged_pages_collapsed;
> +	return result;
> +}
> +
>  static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
> @@ -2462,34 +2509,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
>  				  khugepaged_scan.address + HPAGE_PMD_SIZE >
>  				  hend);
> -			if (!vma_is_anonymous(vma)) {
> -				struct file *file = get_file(vma->vm_file);
> -				pgoff_t pgoff = linear_page_index(vma,
> -						khugepaged_scan.address);
> -
> -				mmap_read_unlock(mm);
> -				mmap_locked = false;
> -				*result = collapse_scan_file(mm,
> -					khugepaged_scan.address, file, pgoff, cc);
> -				fput(file);
> -				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> -					mmap_read_lock(mm);
> -					if (collapse_test_exit_or_disable(mm))
> -						goto breakouterloop;
> -					*result = collapse_pte_mapped_thp(mm,
> -						khugepaged_scan.address, false);
> -					if (*result == SCAN_PMD_MAPPED)
> -						*result = SCAN_SUCCEED;
> -					mmap_read_unlock(mm);
> -				}
> -			} else {
> -				*result = collapse_scan_pmd(mm, vma,
> -					khugepaged_scan.address, &mmap_locked, cc);
> -			}
> -
> -			if (*result == SCAN_SUCCEED)
> -				++khugepaged_pages_collapsed;
>
> +			*result = collapse_single_pmd(khugepaged_scan.address,
> +						      vma, &mmap_locked, cc);
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
>  			progress += HPAGE_PMD_NR;
> @@ -2801,35 +2823,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>  		}
>  		mmap_assert_locked(mm);
> -		if (!vma_is_anonymous(vma)) {
> -			struct file *file = get_file(vma->vm_file);
> -			pgoff_t pgoff = linear_page_index(vma, addr);
>
> -			mmap_read_unlock(mm);
> -			mmap_locked = false;
> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
> -			fput(file);
> -		} else {
> -			result = collapse_scan_pmd(mm, vma, addr,
> -						   &mmap_locked, cc);
> -		}
> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> +
>  		if (!mmap_locked)
>  			*lock_dropped = true;
>
> -handle_result:
>  		switch (result) {
>  		case SCAN_SUCCEED:
>  		case SCAN_PMD_MAPPED:
>  			++thps;
>  			break;
> -		case SCAN_PTE_MAPPED_HUGEPAGE:
> -			BUG_ON(mmap_locked);
> -			mmap_read_lock(mm);
> -			result = collapse_pte_mapped_thp(mm, addr, true);
> -			mmap_read_unlock(mm);
> -			goto handle_result;
>  		/* Whitelisted set of results where continuing OK */
>  		case SCAN_NO_PTE_TABLE:
> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>  		case SCAN_PTE_NON_PRESENT:
>  		case SCAN_PTE_UFFD_WP:
>  		case SCAN_LACK_REFERENCED_PAGE:
> --
> 2.51.1
>

