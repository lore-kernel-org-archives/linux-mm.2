Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BED68CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BE468E0011; Mon, 20 Oct 2025 09:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295948E0005; Mon, 20 Oct 2025 09:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E0E8E0011; Mon, 20 Oct 2025 09:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02CF98E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:10:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A636014015E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:10:44 +0000 (UTC)
X-FDA: 84018527208.10.4E573C3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2640B100014
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:10:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="B2JB/TKH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vNpJvsQ4;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760965841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgsJMjxrp7In24z3QhQPBnFvLmLs50zjUfeKDyrQjxk=;
	b=UWLjiyYXdL9aBEQ+Kt2CFbC9gQwL5k3xzl1Domckljr6mPGX/mG866DzTsVYvUlqQsCck4
	lnMADtoaHu80vJdEseLGnmtPAxuSx9p82hSKbgZ7MJ1rtJC0pFa9PouKiONrHi+wG8rU5y
	bmicY8ufDlWlvezAuGV8wG25zRXh+x0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="B2JB/TKH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vNpJvsQ4;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760965841; a=rsa-sha256;
	cv=pass;
	b=AvuAOqs1H+TnA4ciyY4tA0hQK9SFOVq4MxOTUK6nnsmuxOdJc+3A22J5aWO/2HFSTGqbxU
	w4/WfjCEmaJ46fIYaWXSYdh4HK7gK1RGb+QxmQ3Z5NwAjgzDbUjE+KeYg5jAOWMsOiM44C
	8Lw54JkxVbbZlk4hGS76fEMwxboTAvE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SIKl001384;
	Mon, 20 Oct 2025 13:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QgsJMjxrp7In24z3Qh
	QPBnFvLmLs50zjUfeKDyrQjxk=; b=B2JB/TKHq7aA/kUen/kudwAjtXFURDfIgO
	U0bIw4SZ81puLHe7YLEMgNE+8m2+1X6gY95bDkxYVPseJKZ8bCgjfI8rx3baXV3N
	N/+l+NcRu2FXWNOOTdBlSHLXcn/vbTUdyfUj57rBEf7iN/OGPUA+kYWEvVsbf+0Q
	YlhNV74YWMW/wM4ldJT59A8jiPfGxWijrXhMJRqxBQ5qe2hEN7Kfk4Um2WA6wOdv
	pRmjmnsNyaVuumWjKkaKOO80A5zN6fESpRmCEfE2jm4r2dBGX0jsdw8znXxazvnx
	9nm3Nn5ja3bnxt6me/zKX9um20HADlQJvWEcolKX/3K0WBgxyDYQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v30726xg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:10:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KAtIwa025406;
	Mon, 20 Oct 2025 13:10:30 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012014.outbound.protection.outlook.com [52.101.48.14])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bap7au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:10:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DAg00jBNWqk823kzZwPAEJUPKvktceQKRkUxwNQFaaQhUZotdejERS5bYqaC4AoN3+z2QnkS3p8RoXFJ3OOjh/UjAsYuaZVL6GhhWp/hbWp/wGM4b7I6JeQL1fhYtTGVIZQ9Z0+YzMkV4jk1E9jC9BigevXw6aSFsD1FnTIDsLx6AbuZdXpThKzuno5Axm58s0r+AEWrWMfAdNCDMSXQRRsoZE0l5ZIDY/GECAabp7EvbnvRpvAfwjK58yg5ZmKEgKvr0+b3UtRYR5GWFnZI6kA5xstJlYZmoPgYZHYjpe6N+B49XT0df7v4bXXJ2Zh0Ync0Pl9UciaWI9hGT5qDqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgsJMjxrp7In24z3QhQPBnFvLmLs50zjUfeKDyrQjxk=;
 b=Xawk6C5f34ivQdHcZ+37HxF1UzRaHXKRcyV6skD3JY+4v2W/xppspCHNnw3ZxilOs/MSp5va9LI+lpu/Qff2EwWga5jKr+Alp4vBgPhDOvwDnxc7FgT2Y/Kq78+kIK+jVIVUwd6gi6lGtKu7yTFpr7mafNSngvPbiYrAzAJQvXuozjOpNPx5u1klp/C5nyo0H1Uyiy+u9AsYUl4iXQ0BuRrjYTvXkEjePoKRfK/2iaX4F1LkIxfHawAXm0YsIxJ5DUGmJ+GUtulYhLP8NYIK9kHamlJlLY9ejcWR4T2KZZE1qYbm94QqrJ3Pqv8f7G3Bdo6UYE/Bq3oNGWVyu0yywg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgsJMjxrp7In24z3QhQPBnFvLmLs50zjUfeKDyrQjxk=;
 b=vNpJvsQ4SfpDBFaTGosgM2j/GYp7kTK8vhC+jHBruKENBJ4xLktx9Tq5bJfFCpGH/7HO2GdOHgChFvcbpg+73eNOwgMMBtwyBNakLB/3DpmLH+sjliepqh2Zv+4mkopH7IYXy/Z805n/GoZJ0b5GCcw5MnHwn82wo/uND/1T9FE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ1PR10MB5929.namprd10.prod.outlook.com (2603:10b6:a03:48c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 13:10:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 13:10:21 +0000
Date: Mon, 20 Oct 2025 14:10:17 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
Message-ID: <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: LO4P123CA0089.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ1PR10MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a5b659b-d7ac-4f82-70af-08de0fda0654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eKd6WVrAcmi/71yEDfYnyTmNxM2ztbBdCWslVFVBoBUT0bKWWRykI1GLhRqw?=
 =?us-ascii?Q?n4McFUhwglwQru12gwWVdtBUIfaIcM2O91HoFWm5L0I9hlcUSRvXAgfBhRyW?=
 =?us-ascii?Q?5bPF+04r+kvHZrN+NaKqrRVt3BvTGtOvKQpuK6FYt0SrLU4m6XPLvYvBmctr?=
 =?us-ascii?Q?FS0N9q2UZr7M4y4Ykhm3McsFhb82ZOYiJu3abxp+CFv+JqPu2tR9TPiBgPwR?=
 =?us-ascii?Q?b93TDsdpqMPrEBaJ/flAF72P1uz6nMcGjqdmoGcUYCUhXu1ZrOIMQorsaji4?=
 =?us-ascii?Q?V7cE/PKXsPFbSRHDrVtfY1dgmTNIlUQVUiWdkX4aT8f21Mw/Fs2GsqcGgjdn?=
 =?us-ascii?Q?rZnKxNTCXO8NeBXJ15puV+z3JmIun7pE+6QBM77B4oMKssrHm5rn8xc2A175?=
 =?us-ascii?Q?biGuUdn1KSYZ6yt5BSrFEMEgKbvkXjw7FVQyl7O8ovo89/yWqoS/l+F3LBte?=
 =?us-ascii?Q?9+Ka7I86/WwTj/7vdDafl0o39ngjLDTFILotkkLfsM+s+bmj6JDeFwOFpzO5?=
 =?us-ascii?Q?eLjOr6gNNvBqCiI3gf+25r6N+Leg/HpU7PUDjNxFFDd1PnGMELEKLu8fB7qo?=
 =?us-ascii?Q?RPov6zfHiqsff48TJJIxB7k/5k0w30KphiApAdWPuTUrtXh+ys1zhzXZhvFe?=
 =?us-ascii?Q?380CywUIAfjvI49cC2dUN/yKkwSl1COD6tMjh0yS2EQrPYKXCaVuPtPUJRz3?=
 =?us-ascii?Q?AXcEUnVg83jgaetzdR9+AUp2IOu+0st/uF6bbqtDX7WMtItLu94VIxHNQg3j?=
 =?us-ascii?Q?wkzLBPA7IJOqC1J39Ak395uLpvSDcaeqNcl5YiFkJ/z0nuHBv2laZIx6iacM?=
 =?us-ascii?Q?LGD5YDjVmsrUiowkZxb2pEK7X1F00S/z6VoWi1AQl1wokjmg3WsGxfc6JigH?=
 =?us-ascii?Q?WDxs/ruvhn197WGsKcsYFm5WWFLOtoDeCAETP8zupLJtHi1B+x8zAd93lntU?=
 =?us-ascii?Q?lf0ISuXVX629zg/6VBAjU92rOAYOR8y9Zrhy6kXdPzMjIRfkCMWd+1AmwJxO?=
 =?us-ascii?Q?7ZnYby/A0xze4O0VJtvDPxVQz2rZKjpQdtFPJdhGUbpNBaJ3UWOhHrzU5MRu?=
 =?us-ascii?Q?akAYTpRVIyRTTP1q3RdtlF22JE1ddba/d6IUIhYd2P2GUOhdTr9nZSr53wFJ?=
 =?us-ascii?Q?++jwJfDwbgpiQEDKXkHbXSmc4Vbm6Gz/fUtST53qRDIclLvW/Zp/HTcr6bV1?=
 =?us-ascii?Q?uirrgvvZbPRLCQVRQiu+60WGlunNBeUbShN0ZkPsjJQLj2DL3W4pKeRhjICS?=
 =?us-ascii?Q?QHFV4DyGn/YZfdyKxPXVlraIBlm54tZdS7i+KCHzpD3zLBIo1T7JeU74eIAP?=
 =?us-ascii?Q?FhUu8WB0cp/RwCAiL0h4Kti9QsbieRGPtfi3VSRBcz42Va9lGzr/mKpSz9NK?=
 =?us-ascii?Q?JJcbSRJZtImisj6ncAsUMdADtPX6pQg+2/mYTaV3grspvQ+LgNA/5VWyxRmZ?=
 =?us-ascii?Q?q8Mwf5C2+/sqj3ahuR/HpDBrjcC6FLUG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fhF9rH0o1aMffNa749bMaF9Pko8ffICZpZVqDQTlPr6Gdita0DuyMcmT7gvz?=
 =?us-ascii?Q?tSTnBh9O1yuALGwnl2eN5pH2Lr4IPvl7Yj/usHS5YqgjSDiZZTTPmOGbETvL?=
 =?us-ascii?Q?As5DDDC+zIIQxZGNEFy1XCGEQcwSN0+XBrv/nM8nGXTz409YkCd6NBXLWww/?=
 =?us-ascii?Q?6OGgNfylycOIKBwGqZ7Fsf4dAz2mFO28rddFrholdUmzrU3uMjEKQFcLZXmk?=
 =?us-ascii?Q?oVVNFOj6gDsk1mWYU/EDVHoOPSvz/umHWf6TYoHOT7qx9h1meZ9hVLYCtqiL?=
 =?us-ascii?Q?PN1THZBRFJJu68rlFsydNxMsv68jkO6WXvmdReXEaq5s3z4ldHYO2r3lfvep?=
 =?us-ascii?Q?VTUnzV+D3w7ovPZtLLkShvLuS2V/g94HdV2O+S4aFS8MLXh2n04cS3NfUaSQ?=
 =?us-ascii?Q?rXtSCIte/d7cAfTAwCypLAQGookzq5L2Br0dYz4ca7522nYHAp8CsS67LVMG?=
 =?us-ascii?Q?TayXQcRB7oK3ypgGNQFKJSf3nlq2YziimYw03Ndeqi7UmGqN+JyApX8mHso2?=
 =?us-ascii?Q?8tX5ppLl5dWbvGnv7F/7FLxIc5mHMM7NnulCpTfAMwXpKaZz0e1nx9D4Mdix?=
 =?us-ascii?Q?A1Y9OVT2j5w8S8M1yqfzn+2Bne2SjQHIAfE7Q3ShFZ1pdhvwBIPZzw4eii8E?=
 =?us-ascii?Q?Vl/Qm8v5Xe4+jjRQQ/4/NEsZccSyft7PcISxhBCmdDTRquVc2pE0dDsG+FY+?=
 =?us-ascii?Q?PAPRNokTnXjLVSfeKxVmo5N8xMy59tuPzogmKmC2XSd/qLFtYpdtgblJAAMh?=
 =?us-ascii?Q?ThPL0sdCp0DOY0qIJlHXOCcxYdtr7ydPSaLpgBCGJNd0EwVDCE9KOPB3NBeO?=
 =?us-ascii?Q?L12cKT8+yuqk6sFhvDwueIRabkGrHiithdS7rPvlxqA7mh5BiF9bUFrWvexD?=
 =?us-ascii?Q?tALC4bFM27KiscB+sqz8hYGzZ8452ABeDpi7TtpTNuVmyg3P7GW+g7E3D0BM?=
 =?us-ascii?Q?8IwzkLoFn3KzahvhTCvSXAxBdYXjdlpP92XGMn8FnyUHNCoFcVtg0jwgOILd?=
 =?us-ascii?Q?DTLpObYRTsuJFHS1PXkHKJdq+aM1kOH+1S6KhMSlIWjidTiVrE/jwVUrM8uW?=
 =?us-ascii?Q?EMPs4jkguZtFDi6xoHbnjFNl0KF8qfpxWQGR5H6in1H5WWbxKbzs8bVpOzRR?=
 =?us-ascii?Q?7OYfev+3XoG/jwrYiORIa3mAXcv+N0YzIwCPWg1JBoJdzlVXJDhqaC+KJyoV?=
 =?us-ascii?Q?oMrlQhjpY73USxAn3ZMIircO1q++ZIIsjXHG3c5S3xsXAaKXGcIXfTe7pNt0?=
 =?us-ascii?Q?1phLwhAagq0YJdcolhzBrggH9zA1Tgln9xolOpI/K4EWWP1GkgeKFWyzk5ws?=
 =?us-ascii?Q?E9v2ARi+P3DT+yPMrobn46oqV4GY9foD72GUVupSgHHtFJYG04A+3qlFe1dK?=
 =?us-ascii?Q?cF09tVHYVLsTkxGxSC8d82vSKSUfGwsARsQjHPJlWklnNlKW7aQ9udY9qY4B?=
 =?us-ascii?Q?mc/ORv9FE2OHdnEUour3i2BfXuzbEdLKKtloaJPpImPlUZRfrLU8GdPDN5jf?=
 =?us-ascii?Q?SvlMl1xbwilTM8DKlkiMvIEIYH7TBJpLSagsdNDQ7HhviVvQU64H/rYWVKK2?=
 =?us-ascii?Q?ofvuMCGd6w1uRCoRT4GIMxo6hPh3KK0nSZsT56XlibNEloZhaLn2w69apuQP?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2DKcmH42FJAsmHyQe5NJpdf3BiDivSH5KrYLTLtcDvaojxvFiVRxrlOw59kCTDwqQDRb7iydbkXpi+WTlZ6LgxOawqh+JhVSf195TXQ4UT93cEeF6QutVKzam5tGbSNRjzyvQzvTCS5WAoENBbwGloHzep0fwiNZ17ChknkfDXqCQSjiS+rue4r3g93eOrGNsRO/4dFFae+PTahFnxxvPPvOKCtq3VWvYGK0UT8fB7i37fIKh59hXrJ/ZWQ0GEPByY11N7Urm9G4x0j4/pe+UF/LD5gCiFrj/tLaxyPDmvfM0nWL/ErMlQKWrL+IkEYwhvbMUvBYYciwXztlazcTYU0mDrEOA258X1SU6Ribd8dVnm4U2WPrrVbPCb1SaBo+bOpjIoIysXCS4hxFMCYc48/bUZ6zpNi3ShZIYDuxrIhJYAVjAURSNmz6pjEbUxq2RIyZbMzvVWtPUMCT2LVSGzJK6CitiLywaDUyB+H2AanL2DhJWWZq0+tpre2AtoHbmm5tVVur5RJvMUTo0IQLDitzTtreDQV/zM0Sn08L4/hBRYFGflh76yK8NLqbGlzG7O4raI3CedYocEquWTCfx/lZwuSBbW2iuEOOLSPFM6w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a5b659b-d7ac-4f82-70af-08de0fda0654
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 13:10:21.7292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcrnGp6aKQxOWu8Xs8W6RNlf+f+y7R733T+6YcoTuePZJxZ1081lTmhmW+aetmub63SOFIFVO2vBO04vL9GF6Nx2puBunE9F6ZlM5N6/YBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5929
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200108
X-Proofpoint-ORIG-GUID: _KgnbXvO1_vVhmDxczp1Rexndw0FoL2o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXwdnqOM7ZHcMs
 J5SZfV2JKS2VzoEvSBiU5DrFxR38T5ZIu9TiC+6E6Lq3URS9Xh0BIYw3qLng8at9eK1MfUxQIlV
 9HWhGQXHCRx/8baWslfvvP4JFIkoyutvVnxkLQOGSmt9u6zmdHfD+ogb4X38+4ZQRg5nMWGSiBp
 iOQiYyfhyZnevTcnOg9sih/QR0mveEINpaeiEyuEJbO5dsHLROCQpCy+TAId622vDYsl0wniVV6
 EXblg+4EnCVeMOaiTIZMuBXaQqLNvHtcgTUC2lIjyf3ILzfu9W6kGyTcDEwsqwMc3si9rMjyjZx
 x/fGccr895HhOVFFsQNCQUV9GdPVEi6uUGpr+4TYLP8ifyimHSrbIZtuqXvUyMiGohqPzkZ4oU2
 dX0u7wHmP1DjMR9Jyq8xNQql94iiaA==
X-Proofpoint-GUID: _KgnbXvO1_vVhmDxczp1Rexndw0FoL2o
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f634c6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=fQX76TRYLwC7Cqk9fHIA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Stat-Signature: dpmqcwfjomdeioqw74tsitz94ffty3oj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2640B100014
X-HE-Tag: 1760965840-8549
X-HE-Meta: U2FsdGVkX184SAqvPzhZX0MWa0+5siPDdrXGTRSa89y1semoxhUH/ib5IwIZDkDJISTLrwuVv5V+kmiWfxfNNDtcYygqwVKAANosVdCmQsfnwigrlj/NtCdx+R5isjxe4cF+97sWD879Dd60j7kT8yu8S+s3PQe07m/UJE7ZfJgGc67Q5h9P3whQ4qaPlvXR4mv9lD7CSlprUbrL96VegyIGWTH1glTey7v0JVGrhhQ2185aDeut3NWuG7b7PzyUvT+jquiiMTd+1bZ3WAATs4wtKwy9Z5YskY2phRBKf6OR4Zz1MffQ1xxdyBWnnnlBWObuelCjDNTikpFG/PU9KIH9LTNcid6Czhd5Qxb9vGe6y3Gdu/PLyIoXTl/BPo63J9QHA+vxrNAKd4sFeuSkESXvYAXfEgmU5ekPcs1oH6QyKyYr57ZVBGidJD51he+AHD+/z9xkM6JKNEL2naVy+Xo7uZ8iV/WMoAcVBuymuDX7WDmhIXDJhg2DlM5k6uvdMJF4Ydcmc2JmL01owCrODBqRNmgev58YTa8GDi6ZcGGJS90q6ASLZeccRPe0Mt5y+aIErV+aaB6GKxDC59hK2tJV2GR0tKLcNDnDCvzxkZ5nzVsFveshagfisfY8O2ZWdF71hlBfUqGDTEOwPHMOmLr72Z08vF7xSGSiQ0me5GnRqGZn+AxcdN9Q9pGABdYKlpFp7+k3S7FtKaoHL8sxixBxuqrprIq6PCdS5CLQbDa1hU0OIIhRLCGHSYSfU2+kUObfyE4tmym0z4mpv1ITVExSTDNQadbWL9xKFt/7cv8nOf11j5nKGMgdgESid9YereMl8Eya+l3beE2TeK8JxVusbaqDMhYYoGFlYLGzN6OhrxZB2eXyv3fmQVDn7nlN4AuDES4aK7JG+Jahnl5oV2eHX08ag/iO82HI6f16miEjEZYSmh+D8kwsa8fZC67rFo+z9yhCfMGUDHXkrO8
 kYLG3d8H
 BngeCWkyb604DKX2XyVfRxZIxdiKF9RfNZJd95pmgBI58+X82I3W9xmNVq1Q5nmLDcGaiv7ouGsPGQ5l4btkG6Olkmnv02zfszQbsurKspSCT91749Zx9TfoQFFdjBFPb/ABIHV8zEhO/H3JuCGVJeFtQnpd5n/fmOa/2//e8QdjemYjWx5JnnetBpTZNnxM8bmMIf9zc+58RQZ8dzYHtjLf8GPZbnQyMsrjnt64Vrh0ABHDIRYvkYKJRfZNPbeuqNVMDV9Xix7YN+3PUYVfvmWqU7dnmP8USqUujdi3BWGGNjtaSOzNIRjxIJpp5OK3Jnt6SJdhXcScy0iYY7u9CYikDY+2iSQ+wxL8Lh82Tn7yB6h4wnwfp+GmensNhux2LVQzU/YVwszGZu6LiTrVI8RCFRrGPZYx0cXIloQSWOoprvEel6Wh5RzqgW7Gh+pcuPSu9jizgjP3g0iCWr5JK08+H+I8Z//YaT61oW+j7OdH+9rTCJSuMM+ANSMqvqy9vBtHF/jqtdf+L53ZEaUSWO83KPM0R3R7FGhnEu8Hx7uIyxWOACR9V3pqOPoOh+ggaC/2erRmZB97g9yvfbWjb3a9/0svFhHgYt1ZkO4t5nd2/lxfcPBR0G5Sfw/E8UYredPASzXYEqnLB7hyNcmdHrvd0c5QiG/AgvpX1rQ42iJfNt3ynBjdvXCPTmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 02:18:44PM +0800, Kefeng Wang wrote:
> The prot_numa_skip() naming is not good since it updates the folio
> access time except checking whether to skip prot NUMA, so rename it
> to folio_needs_prot_numa(), and cleanup it a bit, remove ret by

Hmm not sure 'folio_needs_prot_numa()' is any better in terms of indicating
that you're updating the access time to be honest.

Also it seems to suggest that you're determining whether a mapping of the
folio should be made a NUMA hint by the folio alone rather than the reality
that the mapping is being considered for NUMA hinting and you're checking
to see if you actually have to do it.

prot_numa_hint_needed() seems better to me?

folio_xxx() stuff all seems to be derived from the folio alone.

> directly return value instead of goto style, also make it non-static
> function so that it can be reused.

It's worth saying you plan to reuse it in change_huge_pmd() in the next
commit, otherwise 'so it can be reused' seems like like premature not
optimisation but abstract perhaps?

>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

this functionally LGTM so With the naming, comment nits addressed:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/internal.h |  3 +++
>  mm/mprotect.c | 43 ++++++++++++++++++++++---------------------
>  2 files changed, 25 insertions(+), 21 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 6691d3ea55af..b521b5177d3c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1403,6 +1403,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>  		      unsigned long addr, int *flags, bool writable,
>  		      int *last_cpupid);
>
> +bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> +		int target_node);
> +
>  void free_zone_device_folio(struct folio *folio);
>  int migrate_device_coherent_folio(struct folio *folio);
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 6236d120c8e6..1369ba6f6294 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,26 +118,30 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>  }
>
> -static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> -		struct folio *folio)
> +/**
> + * folio_needs_prot_numa() - Whether the folio needs prot numa
> + * @folio: The folio.
> + * @vma: The VMA mapping.
> + * @target_node: The numa node being accessed.
> + *
> + * Return: True if folio needs prot numa and the access time of
> + *	   folio is adjusted. False otherwise.

Yeah this comment isn't really helpful :)

You're basically putting the function name into a longer form.

You should mention NUMA hinting, that we are checking to see if the folio
actually indicates that we need to make the mapping one which causes a NUMA
hinting fault, as there are cases where it's simply unnecessary.

You should also explain that you're checking a folio whose mapping is
already being considered for being made NUMA hintable.

As right now it isn't clear that you're not somehow checking for prot numa
based on the folio alone :)

> + */
> +bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> +		int target_node)
>  {
> -	bool ret = true;
> -	bool toptier;
>  	int nid;
>
> -	if (!folio)
> -		goto skip;
> -
> -	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
> -		goto skip;
> +	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
> +		return false;
>
>  	/* Also skip shared copy-on-write folios */
>  	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
> -		goto skip;
> +		return false;
>
>  	/* Folios are pinned and can't be migrated */
>  	if (folio_maybe_dma_pinned(folio))
> -		goto skip;
> +		return false;
>
>  	/*
>  	 * While migration can move some dirty pages,
> @@ -145,7 +149,7 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>  	 * context.
>  	 */
>  	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
> -		goto skip;
> +		return false;
>
>  	/*
>  	 * Don't mess with PTEs if page is already on the node
> @@ -153,23 +157,20 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>  	 */
>  	nid = folio_nid(folio);
>  	if (target_node == nid)
> -		goto skip;
> -
> -	toptier = node_is_toptier(nid);
> +		return false;
>
>  	/*
>  	 * Skip scanning top tier node if normal numa
>  	 * balancing is disabled
>  	 */
> -	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
> -		goto skip;
> +	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> +	    node_is_toptier(nid))
> +		return false;
>
> -	ret = false;
>  	if (folio_use_access_time(folio))
>  		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
>
> -skip:
> -	return ret;
> +	return true;
>  }
>
>  /* Set nr_ptes number of ptes, starting from idx */
> @@ -315,7 +316,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
>  			if (prot_numa &&
> -			    prot_numa_skip(vma, target_node, folio)) {
> +			    !folio_needs_prot_numa(folio, vma, target_node)) {
>
>  				/* determine batch to skip */
>  				nr_ptes = mprotect_folio_pte_batch(folio,
> --
> 2.27.0
>
>

