Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DCEFA3753
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 19:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848586B0005; Fri,  2 Jan 2026 14:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4F56B0089; Fri,  2 Jan 2026 14:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F146B008A; Fri,  2 Jan 2026 14:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 564576B0005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:02:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D3D68CA87
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 19:02:52 +0000 (UTC)
X-FDA: 84287945784.22.0B4282A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6DE2A40010
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 19:02:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R01x0mLp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qr+lN1oI;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767380568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhVsvT6aKNtBV1U2xgQC/mJPcIWxjyBaVINMa5oADCk=;
	b=fSUIrKFVk25HFD6ElKAkerBKGvF2jWrxazcGuhPb1G3LVucVFy9i4zbaDRULo69CCeSsrR
	7NR2mx66TYvSHmxY4TDPyfMpX+mpNk0GiOj0JiLfmlXIAzgaV4Dz+S07uDplilVQZHM3W1
	HQCIWEIE/ur/ebuN2ejyLPyE9Ab996c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767380568; a=rsa-sha256;
	cv=pass;
	b=D3IXzPNFsS94Hm32t8rSdcWHWB+VQKhMe50OlPy4c7T4D6V5QtOyo+zNPCYarVrmnssQ5x
	wzhse/smIesVo3QR5JpTYK2gQwVoiE840S1JJQ0IAlLRI+TmuLFhpM9SF5B/2H9RCaVhzu
	8ukdfexnVlnmZTnPoIexNpoK8refOHc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R01x0mLp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qr+lN1oI;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602BuvPd3043650;
	Fri, 2 Jan 2026 19:02:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mhVsvT6aKNtBV1U2xg
	QC/mJPcIWxjyBaVINMa5oADCk=; b=R01x0mLpL6HNPwq4fCfvIWc3uC2KL9THtV
	vTZm3gkMf+rxQ1kTNWqgBZF0JWjRY1yB4wom4pplsvekW2hj2BzA5TpdKfcb74DU
	683ZrJYdlmBWzAnH0N15rjWy54ddTt7/eKmE2wyNyO+lZ+iEzZWy/0avYnWAPgtN
	LGaNYS7UzOpkFc9Ze6QYqL/mU1vyzWcHVJ1pR02iSkZu2jud4jXEAok1vzCcdJym
	fHL4Nx5ShPW+Q+NZ0Kaap2pDFNbMZgy9exNplrzCYfVhQA8X5jPsE1f6pRBnL+TX
	/R2bC2tsEfuVpX4uZDCLrkWz0tM4ASM/VCWsHQhPYmwnY2cvzPZg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba7b5nc6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 19:02:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602HCv00022512;
	Fri, 2 Jan 2026 19:02:41 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012047.outbound.protection.outlook.com [40.107.209.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wa4eq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 19:02:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gNpPdDTrr3/Kf0UMWB0Dl5tTmHu7dM/sMzIcguAB3H7qYAYUtkf7UgRn0pPmyDetmFNFVRDTZwUHHEDPB/l9LqQEls3gD/sP2xpElKZY1F5ddlZz8FmT0wuLY4l4uCizK0QAt55vvBIUd5fAQStUqdBY+kV2SoE2WQaQXcJDleXxB5k/Q5S7wB3fi8Bv8IEeD+ECke/cYu54WlVGkC3p/w60fi+7ze36v2JyhxUUEGGpJHjHFgqR/mesfybt/hmFXFrPHZS0qY2MUBz7J4c/2d6JzbtEk6WEdjuXaxJamtS2OEaT9mwDF3PjHwRF7hkbj+TciWx6jIOTQruZP95z0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhVsvT6aKNtBV1U2xgQC/mJPcIWxjyBaVINMa5oADCk=;
 b=j/gzqOgYTEsqX7copyWlV097yl5cSwyYDVsqEfMQcgVKhBl6dmVQmFVxK3c6u9z/6ZeTvMzMZCp0HcSRdJJlmG5WFyUVIfaCOz42cVtzB/tkkVwreGa8DY5eLZEszDYSOs9gSNWmNhGWuXH/1nFhFpHmDzni9xgf3cInjMM35UuL99fEn8gGyb1trN+EwrVuxhqRlZaT4r0rq3Un7hjqugO16oTcihV5Q5Djfq1SQKJipMkKDmjmwOPBk4u9lNEfxinCqUeS/jTJWlcaH4UdKZkswJPicwzZ7QxhgLM6heaFGUibIJOBsODEvVwvtrmiogknghOt2RETzDEyFSMAYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhVsvT6aKNtBV1U2xgQC/mJPcIWxjyBaVINMa5oADCk=;
 b=qr+lN1oIHsAyRxmyc8oJZsV32bYzvyEmeJpsyucvOh7K1+YNpVzc9h5fhffal7xqxQLEOVv/4uDA9aPpGAjHULndefe0NU/Og2yLfjHN9C18XiAc+V5JRVU61SlVPJelIzXvYiWOGzO/zGi3BNvzuOJ7xn5F0xvfb0ZASOnmaq8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB6915.namprd10.prod.outlook.com (2603:10b6:208:431::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 19:02:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 19:02:38 +0000
Date: Fri, 2 Jan 2026 19:02:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <0826eb09-216c-4d00-b4eb-ed1a2ba204bf@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
X-ClientProxiedBy: LO2P265CA0406.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: a499b373-cdf0-483f-23ca-08de4a317ed3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gLZcAs0n3IN427Ra/SEU8cpLi3lKXenT/rFjXrFLNpXS7Y1t921x7K+hG2FB?=
 =?us-ascii?Q?jDsvQGnq10P7TOTh9VggvjbyU8DJpKysBqPk2y5Z2lmwkw4NIcZ0QM6DumLR?=
 =?us-ascii?Q?Jm316neYTnKXFAYKkYYGIBj2LRsJ3mfqEE64ueC+wrEw970lpkbIAL57vcfy?=
 =?us-ascii?Q?/mfXcSMy23tugHIlmd2VTlGy++VUeFci8vketfDbhxPNpxOiFABSV4sDlmh8?=
 =?us-ascii?Q?eq4NiQBACsBgolHOP0FUCsFY8smypMpf7JjcV5ly7e/zeFSrpIo1tQUELZc3?=
 =?us-ascii?Q?dwmo7f0HU/MrcJWgQxtC8qYB1gBlKBBdGeJjK6SyNpBxfQKFC6bsVBgsFIEP?=
 =?us-ascii?Q?Tgl2xss1CxRTx0tiz0hH0ygytRUg5DRCQxC8kBhoV2qq3tEwMVtlW9NmQnKV?=
 =?us-ascii?Q?LMKgY3d+BYjtPb9DVzIu2SQzUEKN5D3wdJk7XhzyG8R/WUOjlOu+TddSo/yN?=
 =?us-ascii?Q?alwaJHQl2ZbDLQKM3+U+3lhx7mlbU5odEqbsifgEtt1lSRMxws5KAROuAHTR?=
 =?us-ascii?Q?KedbJacRC6YIAaiZMYT3YRh6zKy2NV50OZl7DluP3NN9CkOYC0P/SZSvx/4S?=
 =?us-ascii?Q?G1t+V3IepniNa1M3EB+63ZB0uUHc+Bl6Zc44rHVdDsZ3Fj3olaZgjIFSI5Cg?=
 =?us-ascii?Q?N2v1gbS5rnn+WApc7CgOb6mB4x8yZIMUvHE1eOQuPMnBpPrls1Cngl3twLBO?=
 =?us-ascii?Q?Axp4DqAhsqTB0SMBxl1mgQViYm9n0/mmU0g+C9TQgcRY5hCRoyfJ6i0dRk1l?=
 =?us-ascii?Q?qxHVHx+9IeF1qGTUbKtQKGGesVVij9bVJK4tbmpBvLYwSvZ/pi8VmhPGv1q0?=
 =?us-ascii?Q?UNZXpsxcvSO3JeG1/pCsFw8r2/hP8/S0WLCER+B8aFzc3upgTNxJ4H/tdmvJ?=
 =?us-ascii?Q?3SQC9xTAzjHFrw7k8dDT/z0+WTREJSGOP4v4cMnfKr2NMdb6d0hZuGAkaDrk?=
 =?us-ascii?Q?FTZiiY0NK745Qv/sZhI8oiD0qICbmhp/rLB2KhKK2iDVT4C+cSII/63GOMcO?=
 =?us-ascii?Q?goE1pZca8sraqNNzt0NgwFfT5teCuSNJO7ssUYLjmifOnHle1yBI4pJch07e?=
 =?us-ascii?Q?JpXm411l1+6MV8OtEXSAF+2HupgUgtKI3ZFFZWnrJ/ZigFDkSo2GOTDD3oUc?=
 =?us-ascii?Q?GFEug+yP1IxtFRuTrXmYnYtAUvu5csepKlRyga4Q7y3qq+qEuCHfZuEBQydV?=
 =?us-ascii?Q?9IKP93olDkEyx0dW53KUwteypvkRPL5MrODR+NJfmONAtsOh7237NVAE6awI?=
 =?us-ascii?Q?FmWdR2rH0Bh077pDohD7p6T0djq+586UdhesKjruAk+NXfLAfRYIxzWkwRek?=
 =?us-ascii?Q?kjqD21vpuvdh6BDzuK9caX8QWN5vkTMaBFz8S3z4Qnl5hhWu/W5YCQBonwxn?=
 =?us-ascii?Q?J2CeV7WbmvDfjejOnBOuMk/bq5yGyFFh/3gZA+dhXavC1uwcIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jibKldcwmjV3rSrPPlhyym04cjjz5863xNHOKL/QT+9ur8pMYBwg6xfZnQ88?=
 =?us-ascii?Q?j0oQ2P7QqA1y91dOxFaGKZ0EZnI+uH3QkKHt/af/SMZB05vOEo3PxWIGqKrY?=
 =?us-ascii?Q?keLNfPK6mPJNfv2I40QLUWht6ANqgt+/UJlAIL3fb44Yw3aCy1gnmLIWxVTV?=
 =?us-ascii?Q?V/ln3lVMBCCdzzBg5JADpZFv/LTTSYVygONBEgg7U1dQkyt3+MyLY5YE7MEt?=
 =?us-ascii?Q?xfr1+ei2X6QmD2LHw1VZj2cGe0KanI2mLTAsaDBzYvKcQ/GzQpqkeBS7h6Ly?=
 =?us-ascii?Q?2t3DvsE5wIlAtL0vjHxgd0c/GoTHKOeZFIO9e+vbIufzFDjBvb3o1RZ/yY3f?=
 =?us-ascii?Q?fTeLtDLvZeWPMRR13u2M1cMTHh2o5o3TerCv1Erc0VEyo2hl0fEuN2nnHkWC?=
 =?us-ascii?Q?xJ84dN0I+vA3+RJdNusB3pGg9NoEuMPUrucOtBgj/f+2xZV/E/8K/6VcTh3k?=
 =?us-ascii?Q?GVnrSiwdN3zDIoX84vhgFb43q/5ccYvywmMkq/SNhEDKt9JsYhXxj4rLUKYA?=
 =?us-ascii?Q?tJyRDLh1qW2RcffECrPgZuiEsSBK37B9IcLa0OTh7hORuu0xTy80O6+Ju/hc?=
 =?us-ascii?Q?U2OPSxGrih4+peRh7LUucZl8L+RfYwtB1khIthG6iaQ3D46AlT0New+W33CA?=
 =?us-ascii?Q?Z+XCbKqDNr52aXAquT47Q3kCsVqyDJ9K+YMI56ynsnHID0Hbh19u90EWVGND?=
 =?us-ascii?Q?ByZdoQbi9cJfoOsL3PuI8grlk9N3M84eR2cpzW+tCpxV8oKkVy5ppZGV4Ib+?=
 =?us-ascii?Q?NGPevbU4KeEQFp+w5nGfe14YdJUW/D1cVzkw9jKB2e1qG7StR0/9L/wtmCUY?=
 =?us-ascii?Q?GpTeRFzOa6PxK2T3Q2f8Pme8rBV504zu6VPPu5PwMp0yFBOn745LIZv23+P0?=
 =?us-ascii?Q?0Opb+LxvQ83yTQWn6P5h3ub0z8Sa+L759blTheIbupTVCTg4X8yuZs5U/mum?=
 =?us-ascii?Q?sxjMDQ/BlX6C8cTXkuhe1ciFp1gnXPzCgYIM/JTdvU1bdvYJdfCHF8OfbVkN?=
 =?us-ascii?Q?ppQ6oyyKSC2BtJECzxrJ94PEndsDm6l/dUXyCsxzXnyK+55+UwUrbEAmpAGQ?=
 =?us-ascii?Q?WI0HeFg2hqcsHu6dfYiu8dFzchnZbiofwF+aScJ/BTxGEXi0sjChDzXwZDvM?=
 =?us-ascii?Q?I3BDGbl51iFuJPhdUtnSbiG4B5CevL1K7vMyMm0j+xaect+UGkGiHOkovOpa?=
 =?us-ascii?Q?sqbYlD64SJw1j0j4Ht+qgzsLJT/xYe7sE7aHHsfDAsfkPeiDO6iff3+UWfth?=
 =?us-ascii?Q?EVDjEWT9zLI33GCiK2h4pZljJLOPN0/m66q30pOsC0UBl7tBecgF+/UJC39P?=
 =?us-ascii?Q?C7IDg+y3+y+yF3YyuF/wUsNrsSS54vv7ZgjAIxyTYN9oe3CTBrY4IeBLOZ4s?=
 =?us-ascii?Q?qdUaG+vC1UbIaKpyG6xveVM6J64K1aTvrOrcCBQV2KwtnyidcfZtRYFst51H?=
 =?us-ascii?Q?tTAtNNKCECKHt+73Ltlfjjyurv9FhPGxQjpsoBBzcZiPIfmqNqmLKT0WkNdi?=
 =?us-ascii?Q?QVXN+QVy5UbyXXCp7VtELro9tNT1rZbrEmER6V65Qyz+R3/G2Mi0dZdDL7IS?=
 =?us-ascii?Q?0f/wZdFCcpM40WLyuwqc/LsQ5GfinwO6Mx94oV7mYYo4hWFM+wLF8LAhhFyR?=
 =?us-ascii?Q?3pPfdFat6D8xCJRN+M8KFmRS9PYnHvovkiQKibWlRzp+puZqWjS/U1D1Ifwj?=
 =?us-ascii?Q?c5W/E4Kz0ElUe6LE92u1LBQroOgwK36zVtupPcpD2+aliQx3uzeeMM1FJWT+?=
 =?us-ascii?Q?O5iJY8B7P6aJhE1EbnPtYfP0JsfHK4A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UN2sjJPyHgxZFmsHXtoAD0e3Tw5avYC7i6YwFt6dxKQFB2a9KEHhoIybq09n46f5rO9fCjdEQxVsTUmM5REZBl1wJCicUWR9fg/TOYm7PgKjtYb7RG1RGXmenclvHD8jvsKtIAydkrcn2nQlFsIXT4PVeu+/Yu70YwbZivoo8d7S9UX78hN1UvFYCKYkoSKZlRsofpAbAsyC7JImQI1BD5FXAxVBO4wgcNN8mJjsb/7XFdIJbVT04Vmy8+GgEvLwqMB1+6eXGAsboVHappbBBPRBW3PuhbUGfsMNWS0gw+snZMFShXwwkOU1u3/JFLKy+YcPBdF2wgbauX50yEU25JRK2+gcl5hjPuFOi/NyLn0BJbKt3CIudM2dJCZkjn43iBDO4QPSNDKPJFDk8T2IVVwy9k9rxIUa/OkZu4Snyiv5O9jBGaKm46mWq6+eLwW8KFhqE7uy57LcG3IC3xs8SEFKMKM2dyAd86bTif1rsTWWuGfpYZRRBttwRc3eTjmw7WZyQ7Q1jEWs4utqjd2E+M8qdIHJHA/a54Xg5ZcGuKjOkYuhUdSrD8tZiszyRiKH6dqpaZ8e/96UMZQA9W2Tg3kzFCQpuYRaOuHYxPLjTzw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a499b373-cdf0-483f-23ca-08de4a317ed3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 19:02:38.5820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqKiE5rizevExzltKoyJDZ3t0LgsNVprCh12oyK7yt0I0t8r2lbMVQeq2mAA0VszkatdDFv2eV2HCsfJgHdDEvJuCUYarPPB2XQjqgVA3tA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6915
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020170
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE3MSBTYWx0ZWRfXwZfXA4Fja2Ks
 +HukoiCu/VvXs+uYnxTv9jDy7ZZFk2uAV9fLghbYnwTrLoZXmX2FdCS13EJp85xsN8DMkIteaDS
 XcXViJjZyWeTbGoSFx7T5RODfAnkW2LDcxnxr+B7Yo06AN57x3eVJpye1+g35dBrv2L/BXdmVG/
 b114EWJzwlsY6X02q7xY/XjI6ShE69SaJ/mtxuanGE9Dphc7180nBmjNnH3mBidyD8eW7eddqJP
 sUh9t+nDilf5+mU+E3M5Oc11qIm9tZjhxjDtoXA4B89TRNQ3pWUmcFYjsS08ppykF/df+os9jPj
 EYsM9Z49m1XMGvoC3yPTbxMJ2SlDljakfzkn/lguoGAxPCXTgoN7yWoDS2r/w5A3UG4egU1NeEV
 Vur5uOXPg5rUzxVbcLBx8Y3/LV1y9fdAC4IWor/HgWss5QtNsdctwSTx6i8/4M6YnoRecROvEFO
 daHs3mIuM5ylO1BgWsg==
X-Proofpoint-GUID: wzqvPlMDn9ZeXiv2UCLRy-eTnHKzHREG
X-Authority-Analysis: v=2.4 cv=ccjfb3DM c=1 sm=1 tr=0 ts=69581652 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=cojg3PkHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=u1ATobRcjniv1b9x-kwA:9
 a=CjuIK1q_8ugA:10 a=DJ8J2fOkDkLJcQ4mR7rI:22
X-Proofpoint-ORIG-GUID: wzqvPlMDn9ZeXiv2UCLRy-eTnHKzHREG
X-Stat-Signature: 3n7gb8c7dr47csibrficuktitxcpqgxb
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6DE2A40010
X-Rspam-User: 
X-HE-Tag: 1767380568-765909
X-HE-Meta: U2FsdGVkX1+QOhpU7O1T/lpiMX/juTIllWUIzKyfE4PmNVi34P+FT49URhzKKWO6c/mipe0IBdKDxUdcEZIJRpq2j5i5KbwcxA7s5D5AcUyThKZAhqoPSxLXcoZsiaUd3QY1pUvS6j3fxY9MzG1gn2AK006oAVP67QCZxBLiDc/BoXSUaDfcswwfHdrqv9Ct+VKlsX7yD0Ah7LcdTJo4PZRwmxMfR+lv/sYQPrV6GOVr+4dfWgEraYvCJLiwdpWvVRNR/LEX58WgsaJz/T45YPRnn1/EypZHJAupvZX2ew1UAmvTd38TZ9V6dLJ38cvb2jkDEmxKPN6HBeGPQrs67O0De0MsBKD9JYnv+Gx8I98nUj1S0mVbIzEzLhlJ51I3+bzCUCBMiXBOmCO8srAUwTLw4qOQUGeXqEguZPcuKvmB30WUpvHx2Tt0rOJ5DnAOdfzdLuzJDh8lFtNZoCsj8TkCABM3d/lR16QhDxmlXHk18YOOJNmB7a4cpQeWDAI9FDXzms9KHIP9/S12R0BokgN2cFXF/Mf0KPr45JRyNttZUfnu8LlAa5GVqFuKjHt6TFF51VfMJMpSRdbRrWOagxyum2POPZrCBCBY6An7t1ayVuk7+CK9LRzfr/fg6lPVQwll1TyC4ZPHr0+bgLoAVfNk7JVaMxPeSp9fU2jAV5yZpPrZhKVml5fcsgvn/vSd/DTnf9VmrHmiGhIaonAViIT0OqGsvilLi0+HuVwwSGklbyUNEVm/fnaKR/QHg3/F33Dlr+65k2fHoKSx7C/5e4fwkJHsMWOfFdGFf8c8LW6pHF/XXnLNyTJDPXgUJM30seHmV3//USWIcY4yIpSBNbX813QJUJ2ypuNOl9S/9Ec65eLqHoA/luTjk/Ws2riHgxFMtIKEbDnA5CzW6ox3dVzxJhV722zsl+rziGtCuJTuNkDXqMld/5kbi3CpXWULLkCAtecxqs563+yRVTk
 LQpMYY3H
 CbOSUc+4AXzytQjyzt+zlqTNlq6OEnYO1OgM4xBH7S2gMxbvwfpdFnpXLP/Ot4Ad7l7h67+bupXxwKFvJwEPzaUjT3gQ2TLg2FJtUbswxPC53hVJMbvv2aVYnT7gYZT3BrcHlXwmXrhitGh2Iscxv9Xqde6kW++n/IkD4FfGKzYwNWOHJnbIimQzXGeVohy7ImodmDhl7wqK3rVNybLV4+m30ucVquob6iWdqOsa74JHhw9tn5Pz/j7GAakDG6ZL17aRQOnNMvKf/h1s92z4ezyFw/wwVh2lsTr7T9JhTk+F8EexJ8UVuShdtvUFqOtYeLPTzBugd/RUQNEwXjHsx6prLqeL0OXy/ZsAANRiwUO1FZLX8SLdEtMd0+C4ZwM4EiUDBR0zIrXB0X0uAia2rvILHQ8+zGF2c/lmf+miO5o5AQn9AgqCC215CYmwKWfL9y6+vDnDe9To0XYkfc3SP10WjOPiWnCDMXpvG5CiacC3zdqLcwS3lfa7JKSDuKkV2Ia9nmDG5MS2U16TjMTzMPzzpma6oElSzNWnrKYVBOirL/m/yPcyB8/ijWUt+ubdqKI024kh421mLlD01hZHFQDd97Bx3HXSlcrj3RUXPZevCTOGyw6Ex6uOl6kdH3GpV9y4DsT4K2PUKHPx8tw55rf5hk/d2Imk9nDIVR/Ca70cTpqgTQM/SXtwsbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc literally everyone you should have cc'd in mm :/

Hi Mikulas,

You really need to check MAINTAINERS, you've sent a patch that changes mm/vma.c
without cc'ing a single maintainer or reviewer of that file. I just happened to
notice this by chance, even lei seemed to mess up the file query for some
reason.

I'm confused in general about this patch, you sent it on 7th Nov? And it's been
ignored until now and then taken without review to the hotfixes queue?

Andrew - what's going on here? The patch looks fine but we do need to be made
aware of this stuff!

And it's seemingly against a specific stable version?... I guess this code is
antiquated so safe but still.

Thanks, Lorenzo

On Fri, Nov 07, 2025 at 06:48:01PM +0100, Mikulas Patocka wrote:
> If a process sets up a timer that periodically sends a signal in short
> intervals and if it uses OpenCL on AMDGPU at the same time, we get random
> errors. Sometimes, probing the OpenCL device fails (strace shows that
> open("/dev/kfd") failed with -EINTR). Sometimes we get the message
> "amdgpu: init_user_pages: Failed to register MMU notifier: -4" in the
> syslog.
>
> The bug can be reproduced with this program:
> http://www.jikos.cz/~mikulas/testcases/opencl/opencl-bug-small.c
>
> The root cause for these failures is in the function mm_take_all_locks.
> This function fails with -EINTR if there is pending signal. The -EINTR is
> propagated up the call stack to userspace and userspace fails if it gets
> this error.
>
> There is the following call chain: kfd_open -> kfd_create_process ->
> create_process -> mmu_notifier_get -> mmu_notifier_get_locked ->
> __mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"
>
> If the failure happens in init_user_pages, there is the following call
> chain: init_user_pages -> amdgpu_hmm_register ->
> mmu_interval_notifier_insert -> mmu_notifier_register ->
> __mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"
>
> In order to fix these failures, this commit changes
> signal_pending(current) to fatal_signal_pending(current) in
> mm_take_all_locks, so that it is interrupted only if the signal is
> actually killing the process.
>
> Also, this commit skips pr_err in init_user_pages if the process is being
> killed - in this situation, there was no error and so we don't want to
> report it in the syslog.
>
> I'm submitting this patch for the stable kernels, because this bug may
> cause random failures in any OpenCL code.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
>  mm/vma.c                                         |    8 ++++----
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> Index: linux-6.17.7/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> ===================================================================
> --- linux-6.17.7.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> +++ linux-6.17.7/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> @@ -1069,8 +1069,13 @@ static int init_user_pages(struct kgd_me
>
>  	ret = amdgpu_hmm_register(bo, user_addr);
>  	if (ret) {
> -		pr_err("%s: Failed to register MMU notifier: %d\n",
> -		       __func__, ret);
> +		/*
> +		 * If we got EINTR because the process was killed, don't report
> +		 * it, because no error happened.
> +		 */
> +		if (!(fatal_signal_pending(current) && ret == -EINTR))
> +			pr_err("%s: Failed to register MMU notifier: %d\n",
> +			       __func__, ret);
>  		goto out;
>  	}
>
> Index: linux-6.17.7/mm/vma.c
> ===================================================================
> --- linux-6.17.7.orig/mm/vma.c
> +++ linux-6.17.7/mm/vma.c
> @@ -2175,14 +2175,14 @@ int mm_take_all_locks(struct mm_struct *
>  	 * is reached.
>  	 */
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		vma_start_write(vma);
>  	}
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->vm_file && vma->vm_file->f_mapping &&
>  				is_vm_hugetlb_page(vma))
> @@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->vm_file && vma->vm_file->f_mapping &&
>  				!is_vm_hugetlb_page(vma))
> @@ -2200,7 +2200,7 @@ int mm_take_all_locks(struct mm_struct *
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->anon_vma)
>  			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
>
>

