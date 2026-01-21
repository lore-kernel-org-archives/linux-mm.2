Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 348B0C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28B66B00BE; Wed, 21 Jan 2026 11:57:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E736B00BF; Wed, 21 Jan 2026 11:57:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A220F6B00C0; Wed, 21 Jan 2026 11:57:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 896496B00BE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 610B613BB9C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:07 +0000 (UTC)
X-FDA: 84356576094.12.FB5767C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC0622000E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LYIAIU7z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Ae8ha/ri";
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBVpczB/At/Hp0AJLlZrh/IdMx/NryCDZYyORdy8gXY=;
	b=YmjhSc9RUcf1t/fCpSt+rRX/1b5wRST7bbNSy5sV/CckJpAvsa0WAa73vjkiRfp71AtsrF
	u6J0kJcal6pbnZZrhcTSLzMOJ3ZAOqSwg2oE6S9ONZB0QNq77fQNHSMCOK1NTDuUjkrHI7
	YvBxi3IdLhf8jug9gObRofaLfBt/e+w=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LYIAIU7z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Ae8ha/ri";
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014623; a=rsa-sha256;
	cv=pass;
	b=ee5RA+aPszHxmU9Xhp3J7pM2SzlNI5QAqpvLn8u5vgs/g8Av1UCG5gk4rWUO5W8mkNU0jF
	sVc49hOf5XOtiOiX//t+P3XVQ8s2xi/m535n8++a/sDzPzFc/pjdCHe7IaC8O5oinqpBGa
	P8KwoSsafbOxD1Oc36MmV0TWRlJQnJs=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LEcw5I3867763;
	Wed, 21 Jan 2026 16:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UBVpczB/At/Hp0AJLlZrh/IdMx/NryCDZYyORdy8gXY=; b=
	LYIAIU7z6LZxxfJ9MHSWRDSPEakps0sE81y5x2Vw5HmJzSiyJDzO92xnN+WeIdFP
	uuff8j76qmeHJB3KI602BKQd5ElFoZyVDgPVaGehjHXyyEybe5NseOqJTOJZDWqD
	R6juittWdqYStwqyReuyGGkumon9usVw3McaGSz8gEMLM2rdUG4oitNtjrGCqViC
	a5XAHA7nwccK1savWW13Yz2sdbVltJrlFX6K8s9ZfDCgvxt/45ps1XqNUII/IVGu
	REEGrob0fkQ2SS8uZ2rq/DS+D+DsshZwwv+sPcsrQRJlst8uTLXvUThaWPU6v22K
	c/DgE5mJvWi8+puANLz+5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd2sna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGKKsB008437;
	Wed, 21 Jan 2026 16:56:54 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhsfr-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9wpfNKSOwVJOEyVGZ3OBYyCv8WCVOB8xpEI293KYOLaEzXcBQzKPOEWhEyAD1xoPoLF6/jactcHe7iSIfN+7Y/Z8u9tBsR++InLdV/5PzX+Yi/E7lwlhGyENojWruzEOLci/SO0L8tXH3IaMXOhvCQrjJjxvSapj6y6FDQ2x2Cu+yH1JhoHvT40YFY3IWhsgRn/HcEUJu2XirzqyrQz5mxjGmawafPAigNGeBDdL7QEli/cnep7HjdAlHzaRVoXkg2ox6T2NBCMU4fwRz/OLLJcN30NSmV6msV8VdCYWW78shvpRnVi2r6FzhLchVjT0aUL2Q63udFcqgob0XhhBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBVpczB/At/Hp0AJLlZrh/IdMx/NryCDZYyORdy8gXY=;
 b=YFabJIGXC7ZUIArAq2Rfcqw6vhh+7cQ8D7orJT4uVGhCle2SKr8UKGdyujgHyXKbOW+SYrfkJHIW/4vhAPx6ouERXf0rXOJeJHM9jWatjU2GTojx5ShBQHczrcrBSeK5WMkUABCd78iS1s8znXllqMkRVlacDsVHkMkys/0isf+CvpA1IWiSjsCU/Vd51c/QgWUDYKSZBIkcRVgEEPYmAmk+FrxnfB7UsSRrmtSeifecqEklXOdg64PKcYd2moB/e033ILvRih34dCUfCrfOVwg+Ncys+DYm2rvhhlGRneZTv/0Wy9SOC6IbthzAaQ71OVyqUi34l1pkATWI3RD0tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBVpczB/At/Hp0AJLlZrh/IdMx/NryCDZYyORdy8gXY=;
 b=Ae8ha/rioMuLifwAx6tOKr88rMfbVj2vk4V3hKoxhByff1xkjseBkQuzSKacxIyjY1kfVAs6/Nx3LrC3sFthyi8FCOujdMNw0dSpkRul+yS8m4FC7/fTmQNYSKTy6hJRmdeRWQz8/o3TWH9tANirPgsIshPji8K05JHJRPFFxUU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:50 +0000
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
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 04/29] maple_tree: Remove unnecessary assignment of orig_l index
Date: Wed, 21 Jan 2026 11:45:01 -0500
Message-ID: <20260121164526.2093265-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0051.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b6b928f-d431-42f9-6740-08de590e127f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r2rQx6CNlb9IohUnXjDr80iMri8ItsjQ0WcCSEjSr2wEMGTQW3YXUDhPqLh/?=
 =?us-ascii?Q?+5MIBdcr48KDxjsbbezV25ZvPizBtI8qXzuE1D6KNiAiN1KKUL7/Tzx4/3wS?=
 =?us-ascii?Q?KGs+HA5fAQL+2Eu3DwrfbrPXaIVlTJ+c+jG3rtf8nVv25mC/KM+zgPHzdy4G?=
 =?us-ascii?Q?2xiRRMl9GBud6PNEluhv5F80Oba+/QS/4WoZhRMSRAywbceQe1mUDmJCMeEp?=
 =?us-ascii?Q?nu5AhHsYph35ISud7V15/+DRK+Qu6FQGfAoRFmKWe5fzaVP6mpFN98oap5Wq?=
 =?us-ascii?Q?XrvsQTUbEhNvIBYWfiR/ye2C9CmwW/vUeuO/qVCby1lYg4WGBAonz4jisGjo?=
 =?us-ascii?Q?jJcrBBz8J8lQZ6cNdpRRE6Icu636KjmWauWDo05a8+ZFr/4jZb2NqF/KL9JD?=
 =?us-ascii?Q?UT2EcLhp85Ni6Nl10OQlNxTVq82zBSdCB0B64sZhr4enRs7v/CPNg+4A3hup?=
 =?us-ascii?Q?s2ZVbikt4Ddv/ynZPZv19++F7bsbi1kB2Wg9ss8MQk6kN1KU9U7LrdSrEAyy?=
 =?us-ascii?Q?+ykZ8DjHrPAksvM7C1au3EwTYahugAJn19SXDhJngRQWT2PCX7u+uuPEAslA?=
 =?us-ascii?Q?fEcYjoifTCO+VPFdcSvWraOTtRDp2WMTujWZus0P/Jqw33P9tmFEyc+DzEVT?=
 =?us-ascii?Q?hUwQULzDVN35Ox44LcFpHn9LkdEmxBLuOTX9ICFHMPmgu9kYGDiLWH5fHB6h?=
 =?us-ascii?Q?ap39puyZnRIr1d5ojchlPfmSN31z+1Qpe+3G6fh4Pp/bfn7RKZeUHZc0eBUJ?=
 =?us-ascii?Q?qhS5PW1EkKJJMaA35pQXhzaoUwAkt3W04slbAFIoGEIkec0/gIRGfSTWJ6hd?=
 =?us-ascii?Q?hXrxKRUBNlA6U6Ij/PM+Hqd2ArJcFXfkZTCN2/mW7vdX12a0+q341LY57h2c?=
 =?us-ascii?Q?dhHxIS+h9NC1NZu9ZYO3Kd++kTczE0LtpXBLFf6W5zzNIvLrUaFH4D4YbOrv?=
 =?us-ascii?Q?RRiNIQgZJYBshi82UqszTQP1r7K8z2Ubb1V/MqcAwrRI3tPwbLFXQQdhDO9B?=
 =?us-ascii?Q?vfyNxAi8bSQptj5Q+C+CGCkg+IRBHDiVfwOJCqWG2aoVuLQKAfJz6/yK8qtb?=
 =?us-ascii?Q?6QQdoV9JfOXJMjBUWVhd5o5NyNT0k+v85fWBFPVNIpuoI0leEXTjIUPWTPKE?=
 =?us-ascii?Q?6Fjya0tZ5/GOpkIilSyzuT1zam4gL7VAqEswNF6SJD2M4amf15rDXKhN4tcp?=
 =?us-ascii?Q?9TkN1eyZQLOCwZtGCn+ZZ+TJblfxEwvuD6yDd54a3+psVW91UzHfpOnyTnYg?=
 =?us-ascii?Q?VXy0JjcAnysm7Lw+Jte2DEr2i4ysa9wTMCNFiSkEu4oFD7Fxf0Gy4khrov7R?=
 =?us-ascii?Q?R1y/LndG4xOHkew3tBsxUtn7E3utpIgd9mglBIspbgIPG4TTmFkHWnVEMGlF?=
 =?us-ascii?Q?icHsaErNmaP6eTnLvl85+oJG6sGkZ4YAg1kUabYkwJTq3+hhw1ZHm5yJsAzc?=
 =?us-ascii?Q?sd3hlyUWLMOy0UHs/PuonPxRP0Rmy97qm+lNfWBkoRVk6/nfbTRE/tLdcTXn?=
 =?us-ascii?Q?0kUeo757jdFdQ8fkGekn/0P4FEXQIEOaFsucfAZJFCQ6UIS+8yb/p8lNvCRJ?=
 =?us-ascii?Q?4TFV130qYhB5NjD+X0s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hC5/6jmFLmmHtYTvZ+nXLSDD38VR0wK3+4YnaE0XU2EKqp6IxDX9xXXOWK1A?=
 =?us-ascii?Q?+cVGto2DnyADTE/zCnetrJa/jOgkLlxCMzc3jb8B34GcUn/lJ7s0CSDDI/8C?=
 =?us-ascii?Q?vuJlCNV3bIpSvqUkhxKBeRM8qh8nkjbOesuQUvIzA+fODS+zFhTRhRdoa5Qp?=
 =?us-ascii?Q?agpLKoduxLgB5E1g85bQvZJNYwOuXh6BqAEgURc22si87DP1ozky6NbgdHT7?=
 =?us-ascii?Q?SkbM841nA4U/aGgNTXAlBNg2SqO76N3nOzU9F7PxjViujiEmbrYvda9h90h5?=
 =?us-ascii?Q?9u469AiRPqpDt0YccP3HebCkhDZvAk2hEuMnuCOM3d2iLGV6vdP+PartPNNJ?=
 =?us-ascii?Q?oe+uMn3G1Rs17QZV/MqAKs9PzLhz6J46zF+ByLnaiW7s/KQBQ1ghdb2x36fX?=
 =?us-ascii?Q?SIH+YS2MirrkGqST3VIQVRJdmnk/mInoYTc8RDesb1XUZBguwPBp0DYiW/N8?=
 =?us-ascii?Q?wK4JymcdYlHrSNRkl6DYl4mmTtXamsWygJPDMHhtnImMn3ruUOVQ+XCh1wly?=
 =?us-ascii?Q?98Y4clwbebSBJGOUb4JbkduHXVg/7OZosJfuh7U0XttC0OufkYDie/bosz5p?=
 =?us-ascii?Q?sWhxtMiHO5YRm61EvvdWJyiXOJNyCdX/pqU4x6k8MsMalEo8/uQ1r70y0YG6?=
 =?us-ascii?Q?wmTMMJhFrtNM6fyXr8RgVck/HxgOAUUJ5maA5KAeGFC2RPx1pMUeslgssA8W?=
 =?us-ascii?Q?HSR5bztyFQA3G6IRDf+DfwjtnZFo491tQerPaso5NaoASAWZYC1WVvw5Al6M?=
 =?us-ascii?Q?Ws7Yl8NvqmqqBjmCN+qBjrAczurSoXH+R2uJ15+e8xuvW5yJhhAf5KG8fpBk?=
 =?us-ascii?Q?tVLWvbQudoqsgCIua0JXqasfqdR66hAP8BKP0zgHCY6g6smGb936O/4DtQEh?=
 =?us-ascii?Q?BCyW5FX1eQT7BK5zkU4CNEzgpoYy0EevIVz2jDROOS7rKu0bWoUATZLHDo+N?=
 =?us-ascii?Q?og7VIOcFEKznf40YWp+sfPT6ERdJx6rvavS7qdONQzyMT+bFkGKSzhu1t5nz?=
 =?us-ascii?Q?RKrdQauNTD6Sk0BTW2f305t9SdWuXcIVTmRI/TBxEIcEV5XUnwKujwGAtMGM?=
 =?us-ascii?Q?sne/HTuaTaQ1NCKgMoXPmbTxULXs4ljxjWtlP3y/+OOeKCpFZSjrPbYO5Hgx?=
 =?us-ascii?Q?X9Mefdl9eEx/suDnVEf3m8zHS1+kJmoYOeATUN/YtFWtwkLwbA8O5Bbto5w+?=
 =?us-ascii?Q?QYax4x23Wy9H5EIcagahCn3M5NJPMTcbdqnWnoilv5aF6AQIlT0ff6MNa2HW?=
 =?us-ascii?Q?HI4MtUW6lHs/vcUJ60f33dTggNJV4SBR6r4G1PE2XYHH7I4Wj+VCn4Q4seQk?=
 =?us-ascii?Q?d7s4qWV8CAOVu0GKY04lub0TE0rQ1fj71wxjmrFpeqn8ViNnLcblC6Tn7kW+?=
 =?us-ascii?Q?iKFKW36y417fFXwn6KbR8gKTsB5oCLMWssgQNsW5Lmvl9dabE4boWkHfjq72?=
 =?us-ascii?Q?QTXJ/yJAbeC44RQ3inxsO1JHhTSlKNgwuRJSGf1UfEihAR6YiaICrYG9xXS0?=
 =?us-ascii?Q?+J8VRYTRMMTGbRWoHI2yIGwwGfcrT4URLWEnSUCJ2cVyVcCHOWPEwOMoRqLt?=
 =?us-ascii?Q?4C6EXHwTwqWD1LMcUiW0YhVR7eo5FIXxnTIDtvFw0cV9rT77dixebaVBvvMk?=
 =?us-ascii?Q?C+Vp3pntU/DMudGVV47Iu7eDe8HEv5hxSJzRejlKkl2cV9wYgYzb3EoKS/Kt?=
 =?us-ascii?Q?pH5iAvYHMgyU/F7OZGJoMM2oZDy3ClCH6JDyB9dAMdh0CA13XwXmekgOvxMW?=
 =?us-ascii?Q?d32a1vuaUw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ngg/cUg9uCXeKF4iVhLGZ+JTkFbHe438CrQd6ksWkur2G6gAjZ5n4qNLV8mqLqP4M3GEE5iaIf1mWGH6/aRFs4zQvrm7NOB6xtinUajvU7ApaaRrheqQxEKXIfhqJG72WJCeEb+gOnfoBWkuFZvvZzjXPpTemwELk5aMQU6rTv7OTEmHaOJ9+iPhccTcQ2IlHJSAXSeiRjZQild3pO5C2bo5TWShes1bGKftstQDGxOajuuKyRFjLlHtd4Veh23FoC7Q1t95Tl/ETsvYPfMdyJwcRNElcAAmSSVDRpunzH84PFaDCRKeedPeP+hjhD/iWLuPHFzWRvFvYpa2C5eekwome0UilywxZeYLQdYmSpltE4ubwgrJaHXy8U16yZbHsKRQ2QGuU8GvqtPnapvqQbQwV9QrGq+uoHEScpPStFxW0cZ1Sgi3nSBNkJbqhOi/KSCs+MHKhErbk0+bck5ff6eckugVVmZKnqsPSQ7+3TvSKdKwjaqt07ZG5Jr2j7bd4VRMw+Yw1QZK7qDZcuZ/ZN5EjCgMpwI8nyz63wcv8NSXIz38iz0eZ7PEWxMrXtPB1+DJaGwmKVNsGd7isSKohM/ySAkA1OXnBope0zVf9Ls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6b928f-d431-42f9-6740-08de590e127f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:50.8930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8gBg7HRFQQt4WWDoFdmxSZ4Iv/bwl2YBWVpzgrKn9QbR0/Rc0L3hxdzfbj4WdfkOERCZa3GaJzX9NwkI0iDdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=69710557 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=sHg5AOaFVM-jeF-jK6AA:9
X-Proofpoint-ORIG-GUID: gZIlT4_QzFUAt9f_xJvfcGmrIAaXRozc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXz/Su6cB8SmQ3
 4mtAZ1QNGLfTpE/9Uz2t0mG1z0NzI94jTVQiBxISMLsISkt/PTwAUHS68d17lgZILI8nQcP7nsu
 3tWqO90UDbPiBKN6d38manbHCy2xxxrrAxbr0spL2RsHfrOLMYepNsAm3TO+TISCJm6a6OTY/T8
 04PecWiY9bgwWZqFOMS83ieHX+MjAxVpI6KzgmcRtCj3j1OTNoN9Etva4fjQUqJ3d0BhCKlA0Yu
 LJQHI0uoJBPeKfgu2r3hxVnWP1JcM8UXFYC8Y2Y/ef7qrrq3avVES5XECi5UkWUTSboQAl8neju
 45pOZ98Ig4dNGnMwx3cEpqFKUaLuZIBIjly6Hu1j+q766dERlMRR+kxMU1hpmoMEDoxUmzoTBnn
 ITCQX/ulMd8tEdIHoACYGPgYhu0MJ3+u1DVpSrDme2ONvl4drfIr0Ogf0rkfpzIRyOwGIMfzCRW
 hwOhC9TyNMToPcmtVWA==
X-Proofpoint-GUID: gZIlT4_QzFUAt9f_xJvfcGmrIAaXRozc
X-Rspam-User: 
X-Rspamd-Queue-Id: AC0622000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 39i6ui5xihakkhngoph1g5py8syeu4dr
X-HE-Tag: 1769014623-428441
X-HE-Meta: U2FsdGVkX19a5tJY2iqVluh1p+qocF68WKpODIR6iyPEGyJbY7uF9tQ5Kt0yu0YjT+Qk7LLhWfvRPxcJsK3NxQ8Dj53kM5Cm/uiN77HKj6jJJee0IeSTGC+XzaJ39t4RmQRcGZ+2eJFqcNzjqD49vWTxYeY81z4d7Zc/6ymke2xC3zNTaqgyuUm6aXdPki5NRthwckr6zG22z0kjTnyhrKP/OUR7ywxOceFnBIlV93u68c7j3kC8EjSahzCcpNg44kq5EJcM2ol787rwJFhQ79RKSGk0NVIHP1jmz1Xss2l94B8XGQ1ybhzXM/1SdveJw+C/CRFLz//v3G5mtHU+qxVhevKYGFf3m7NXBMil9TPZuG6ipww/sOHVgIPnGPR/xlh2n2JWKo3NnQp/f4r2FiGY+hADCxx0QKmQhffxPoWVz0J0CzatbgF2UeLKjoO9nRwzMnqfFrQcigzsX3FUwnywMHeraoEvmVRLj3Uz5vMgCA6Mlpvc8lSYuYE4FLJxqmtDNxOp6Wsa79/P0mfFysMPX+r+7fjJau3uNucmiG4+m8knW5Lim+LdRZCjId5Jj/etySjHWY12hbIs9JJjBVZMxhFIex+bd1TPCdAqVxwieR/qW+6Qegp0g+nJxfGQ3MEvr/ER2L9VjT0u7es3/kxggelaHUAQvn0i65ENylegXyBRxvpF07gOuNDA4oUZbBUJ8IkB3SXyDpxUAjDC7u5V6KxyVsD/ez1mMne7/ofBevABYY+s6yFnEE8aA0mNGjO108Dzg2AIEWtYFHyCkDFJrZkAi2P8H2qdcYmnw6Se9+eTU0AZ8jFQSNJJUhK4HbdSHX0WwUJwPwsSJY3PlPEQVKd1akf8AvMzJf6FUFxHD0bfw8KaRWn6hZBUQYOgmHmnlH7EZ8feoJmZyHcKHhpQs/Q4i2AqtzBfNbnXnRiEfR2GGNrBiH2urqBlbNlN4ftoURnZuF7Smbg7yl2
 5gqmQu4K
 nP2gCx9emTGekGnLWd1oYCQ2FiImG4J92wqlSnBpgsUUWc44bov1I0a7CklwQlJPiDTmgauEdnYx2ojDv7vdclMQbGQqBhvRfzaCdpnKgxF1a42Ew94JnHE58XVPCgqaejNeKwlt5wFb8rMQ3iqb7+9W5qPVSSsXIlgTjx0caqdlutEVvrsYUfB956wUMhIIOLFeDj4hyqoi2A7R8isQjdtquGLrbVDMo9EdyibiA+mkAX7mmoG8bMvSoEQ0ACEhAaVhzTifGFLdHi1NTnDkqMovraaO/T0wLIKeJfK+TCPM+OG2MwE+ozguDATHWdRvpquamWg5PTAWuFA6Xw64sutTrfNFgTcj87TdavY4cc5m7+mMA+ekBHBngKS9shrBziYkMPQ0Bk57YgueReGY0v1qD1njsrkFp8QP1McfrKZuAM2eVnKnk6KDopUD6okE+14V/s2rFQGbc0Cf8mrZE4u8KwsM7+f9VaTzPIGgzvBAF0dXowGGbXvnii3yRlP6XtCUZ90kvBRYaGOaXWdmL+bmMLCkxwLakQ0b+Cv9OaDyY12zjmRWRuZykIoCyr/PrtvOFe3olWtguq0xTU4R/tq4P3emV1QYh5hIl2Ux4BnNdt5dFSM+1l7C+qrmHMrPcKziiRXzWHnKqpJnx9KR5AMuG1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The index value is already a copy of the maple state so there is no need
to set it again.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 9ab42821ee2dc..1e780427c04a0 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2766,7 +2766,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		b_node.b_end++;
 
 	/* Stop spanning searches by searching for just index. */
-	mast->orig_l->index = mast->orig_l->last = mas->index;
+	mast->orig_l->last = mas->index;
 
 	mast->bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
-- 
2.47.3


