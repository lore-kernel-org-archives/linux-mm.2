Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6848CCF2D0
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5A46B0142; Mon, 19 Jan 2026 04:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CC96B0143; Mon, 19 Jan 2026 04:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254516B0144; Mon, 19 Jan 2026 04:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 125866B0142
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:13:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA158C2531
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:13:41 +0000 (UTC)
X-FDA: 84348150642.01.B82E745
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 51D1416000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:13:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KGaKZ3cE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LepVpYa0;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768814018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7SFfiZikzTnWLYzdiahtzGR4+hISLqEOKg19nkfzto=;
	b=7lX+M0WOBTNnI+HLXX8Z85DHTNW9knjICGsxTRav9RoOvqEqnFQTrUvdLSazlDbfEB9Z0S
	fz7fIhifVEq69uNsXTTJG7fd+JIGLnEuPwlffQhWPDpSj0pS6cDPNf/YT9c9U+x1o3+NnG
	q7MrQrWzjg+Q6DOiOQa6H0Xxn7lY2pI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KGaKZ3cE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LepVpYa0;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768814018; a=rsa-sha256;
	cv=pass;
	b=UbTSKe1JhZhCRGivk8bXWWcYtmRm3Xo0KALR81XEY5QaujD8kLMuu7Fbr6UZP7o5O1mlmX
	GsosEvwKV5ZeLNouiMDXlFrpTxb5mJmTT3ePMZljy6TgasMf75Gn0yi5Wb0nqfJ+1hKrKz
	lOykGZjBQV4PMbcw4y/B++nn20/DJ/g=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60INLm3U133456;
	Mon, 19 Jan 2026 09:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/7SFfiZikzTnWLYzdi
	ahtzGR4+hISLqEOKg19nkfzto=; b=KGaKZ3cE0KDpwKCcfhHhx0ViEe75R/U0fo
	KpJVeAiVvLr3D4IRD9OG828yH3c/cySApJy9dcLOzaV6K9TijWL9hyeOZ7u9jbMQ
	nbFd49XGh0/MJr0me96zJ3kq+fvpiTR5CQhrtt3iq8n0O6Nuc3NxqeG7iqqApoAq
	2pkGJYqwqgSHm+Qs/OPxvEN5cfFsLy+su9mmTZOe4FW1IzEet+mKJTrK0AMGqN11
	mYIcShQgR6ls5osJy3BgYxS1MTUpI3rbp7L6imnYsrYr/EYysAyscBX9UGl4udsI
	PvjTtUEOy1Hu7v3FWOAbdOK7NnT5TbYG8E5RzrLAmNe+qf4mo8ug==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b89yk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 09:13:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60J86w2r008491;
	Mon, 19 Jan 2026 09:13:26 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012065.outbound.protection.outlook.com [52.101.53.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v84j6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 09:13:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHvDcCB0nQmy4zCpu2ylR3nI+PmThSZMAV0jQEr6eyp7XNEAR5upofFyxDYut43VoAhSSDp9ulmPyz49M2C1dLxk17O4/4ZSPokCuSQlSyCjnontfR6/wV3begesyw0g2iD66IUXxbhXa/qa9qag/ojdt2j4AuEW/UqjU8WPo8PkJY+7fiSZ7JoxjUZW9Y9a5G9CvS3J2+5lLbmLwAVwB74OYXtj9WFxLF8S5p4eNPFf9PmOlrAYMTw172xAnsugcOMZslHsdbH7rAXb6Mojf4BKpCT6Mg/yCixxtwxMQ8enlAARhtfbRa7b6tWodh50VgzJ4UyrHVvM3yzlwO2HrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7SFfiZikzTnWLYzdiahtzGR4+hISLqEOKg19nkfzto=;
 b=EMYETvYnO1u85Sm8E664Adsqw8B+5LbFT/WfpFMNpgYCMBhXY7ziYles5F4wKHX7Sbl2cRuGGsGV4syysXKiivhiwBseFQyCuksnQia1PWgFdGcXcWkwqMloxvSMkcEkSwTvKSt3WoOuSBI8S4omiTnraBq6AVBoTxGeK7vNP3PxfOvrEbOS1GA/KMeJyimkgcM1GlWQwAXxK5Msu5oGo1TsWJSSdYNGVWXW2E13hSpXJTuvx2vduq7SxfHbtK7tFkNjGfmZR2WCSTxIsl7JR/rT58qHrWr9du2TF7cfP79QktLTKjnyGyXYk8py7/OBD7BPUN5bwQJon6lr+lJK4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7SFfiZikzTnWLYzdiahtzGR4+hISLqEOKg19nkfzto=;
 b=LepVpYa07JhZIiFbKC6cbHbOz6zpcYnSBZLoIT9FWnZ10oUiy8zQwEenSL3nh4P2bdntCoe6Rrdc99tNra+z9ZrGx6SDXv77wL+2wiEFIiqeCf/zDLxMi7IgBGM9bd3zIZG4/fKD6dB2aWxfmy/WgXOqcPDw7LoMxpnq3dN0MKU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB6920.namprd10.prod.outlook.com (2603:10b6:8:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Mon, 19 Jan
 2026 09:13:23 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 19 Jan 2026
 09:13:23 +0000
Date: Mon, 19 Jan 2026 09:13:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        aneesh.kumar@kernel.org, Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] selftests/mm: remove virtual_address_range test
Message-ID: <63801044-8aeb-4054-9ff9-185c60743f17@lucifer.local>
References: <20260116132053.857887-1-lorenzo.stoakes@oracle.com>
 <5957ae48-87b8-4981-a6f7-8113141e7b6b@arm.com>
 <f44fdda0-80da-49a6-a9dd-75b9a46e1f76@lucifer.local>
 <e71ffffc-8623-48d6-88b7-4684af4534aa@arm.com>
 <f7ed83bf-3554-4bfb-8d77-30ed4785a4a8@lucifer.local>
 <c978c50f-16b0-4514-8169-96b69bc7af33@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c978c50f-16b0-4514-8169-96b69bc7af33@arm.com>
X-ClientProxiedBy: LO4P123CA0623.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::18) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB6920:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f92a001-1292-49cf-01e3-08de573aff22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?96OO9sDbNBnHc1iepUWC4syf0NLQSpLoqIkuYdS9YyiRPeS/jt1D5iKuNw7m?=
 =?us-ascii?Q?HCvLadQNg3276E3bmbuPAUsoyNGZjmMZpFo1ndJkM0iuFnhzgS7RLk0/VMoK?=
 =?us-ascii?Q?m42bKakOXto8MtfOyRBHFlmzTohPZAFgB9Fp+Kl4561ldNLO9sqfMEmwvRfO?=
 =?us-ascii?Q?sXmOxXiGy9NKeR2FlBoMBLAzRs6ft17jsyYeeFWmvJLDBMUlGiX/d1LySaSE?=
 =?us-ascii?Q?eP0eaw/G414Zah1P0bNUsFML0XaSuRL+h2vhShIoLdtXLVpwUma0Lfgwohw7?=
 =?us-ascii?Q?27Oq9S0uQS/Wqc7iwr2J81cVqANwpp5aRi7t8pVvJvqHC29ggjNYtoZIj81w?=
 =?us-ascii?Q?FCbkRvpdjJ3yYTzqmn30T1FjfT7DqNR7TZT+9cdobtMJE1G4n0c0FufDcmb1?=
 =?us-ascii?Q?nE7uYDwagNAvT9zw3lyNKdtR0DJgWIKzElzQrEQuDIaNQCFmkwBHEKvXX/CH?=
 =?us-ascii?Q?YMH4FO9sTh4RLDrJAA2UBn9DpiAvl9ztR5CBoP6Xl9UiuNRDSRavf6EsUvmS?=
 =?us-ascii?Q?1CzKEWQMeg6oDNJ7VWVglEIPoHJ4ahGukv9IqQDhPWcpayIPn3unJ9A++3yC?=
 =?us-ascii?Q?KS896csh5hoXpzQUZPCy60OaSEngQvi7jBLZ8GJeAPNdStITcaIEu7mTEko+?=
 =?us-ascii?Q?REowYzBUZWfec37qcgZzevgmbmCpZPwpgbbhOmuXR7LpAUW2lD9pcBzt8qjw?=
 =?us-ascii?Q?j3TFV54KozFy/4EOPxQ2v2hoIu/ZqTCmYABD3Wu0N+Rzxz+lWe4t4obPCkGv?=
 =?us-ascii?Q?Kyb2FkNdrlCdtOzTKro0HzjXfcgp+b/xSX1be9Bj6Dv5QojjYpBe4NwCnEF6?=
 =?us-ascii?Q?PnQgcave6DjU+idAjSd8fUDAR1Im8vNf7EJ+tYQgjZegIEiEUg9O/PrxbpSN?=
 =?us-ascii?Q?+bsqdfCDvUgCpqy4Z44cVdnqYA2NG5uOcWCexhz/0xAelrKgirMuwMZZzLQb?=
 =?us-ascii?Q?mtBp0tMlmLCFVujThwKqQ8t3FGP0ojKuHQSQzMQASyQ3I0VFCjVAIQhIk0Sc?=
 =?us-ascii?Q?yR+lIcz73J8eHj5PZx1Nkg47gmklfCQHgIL2KV0RTIkhTISC61/CQM7An3Ta?=
 =?us-ascii?Q?ikL7WrtHMWD34K2lgY3eUJA3VYj6t2Kloqg2sxh0aAIXZGI0ytaNJxXTiIob?=
 =?us-ascii?Q?xASdZy4iEisRB8fy+CbPtayi7ED3YG+Hx0OTlsuMLBW8iRcckeHf9OJgEiZk?=
 =?us-ascii?Q?uEfQgEfTQ7rc6dVhGPRmJGCc8BsP72yb/Qif2630c5LT7AjbWLaQKh93bkid?=
 =?us-ascii?Q?m3aayLEjOHySPa9uj1jRWLKUxgAcrA5yKquUaJvkzja4XR4+kIc9cr5sp/FU?=
 =?us-ascii?Q?HBY3vByA25z2X3FBJjif/eljAjW6vZi6Hzs2RCer4SHzapRf8mEA6jx7Lc9J?=
 =?us-ascii?Q?j3pxjs0FC4E+WayoPSGTLmLvikRB4XtXJlGhChrV83OiqfmnA+RzGaiq1B8L?=
 =?us-ascii?Q?1iK1si5YIqw/k8sr/FNIZC30aB2JBtqslV6DHc9Jl1GVl00mf8VZnNrBO94x?=
 =?us-ascii?Q?VoF6KacCYKo7/t4aVWwljiS4ac/pvkkaWwZ2Hg6OS8lAPcXM0Gmcj4RbpER9?=
 =?us-ascii?Q?TUCx6lMGFVo3vn1App0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mk5WovNdaS4F/+Qq6YZsD3sltXicL0iCobM34byocNXzaVFEOuji5DT3xA6+?=
 =?us-ascii?Q?45VQmHZPvSwW54pSvcngeaWks1SfGSYEq96I5h+JQ1wh5Y9d30uCYZxIsBj7?=
 =?us-ascii?Q?Fw1UMLhXk56A8lZeHaUe8KbxSV2LP1/jzQFcZA8N+m4MzFU1TAd+QjS7UzY/?=
 =?us-ascii?Q?bgBgNb3DL7CqxpF+gjmYwdFULUAQClPS+weyHVNfMyMDI0xrlnRKC6//XTFJ?=
 =?us-ascii?Q?Lc9qqJgDMWzz5thSge2iofAXyswU023Hha+9vZnV14Gq6rFr8rIHfmYiZvt1?=
 =?us-ascii?Q?k0Y54nvBmFwDEs/vI6sir+0EpgpVZldmD+UwhzCKGrdAnebAupiEqXFjh2mI?=
 =?us-ascii?Q?iG3z2Ey+XZC7V4nA499wjFB+NaUNW/jEUSDose1VeKLaCARMNg3ia2viGUHh?=
 =?us-ascii?Q?fdviAg8J2H+PW3jqy8DYAATRVmXB7YoaHpdwSSllObFnK1b88yWn9XZ9tKq5?=
 =?us-ascii?Q?XJzjEKFvMKxaldKy3Yp/W3q3Rv3+cbF3eMTNIDMACGD88up3c5bgp1SYpOv/?=
 =?us-ascii?Q?VXVydX0SmHDHPioA+HYl0BSwX2faYs6FFH1sjfi+kxszkRQUFprZiOMSe7Ju?=
 =?us-ascii?Q?i7NWsivELejGCYG1wCZzL76ADVeBOztAOplMWbqgTdLhIJYMfIaJQbhAKchJ?=
 =?us-ascii?Q?SZvGkhiW1an7Cr5N4GrT0q+mAjJ3ouqAYHFCsdGJmwkqbQSXrX9c2H5w0ocL?=
 =?us-ascii?Q?1sI+eb1aJ3yg8/3EeG8FRrpmi+Imn4rd0fBYt/7fqzmGy08Xx2MjNzbQrCnf?=
 =?us-ascii?Q?aGn4UX4jpb0PmxDkkmIMyZtFXOVjuzIPpAl3bgx04q8zwZtq6T8dZVMhCnc6?=
 =?us-ascii?Q?rBAvkRAkGQ+ersVMMMzkwBhIHYvc/4SQckFXXzscAol/MCIMVgJxm35RvXnO?=
 =?us-ascii?Q?n6VdP4I5NsqGYFXaXR6Ud0ufD01IcCqbYC9o39ADNlVTL86ZfjowPUXLHhuh?=
 =?us-ascii?Q?mi5ui5ARUk0X58Zgy5B3AljI2qpF8iLvcLh/akQHH8sfe3P2LovOJ3gEb/DG?=
 =?us-ascii?Q?97eDgUarhmbjuGEjljPaLY3KX2lUyGrlnIjtpT4hlKcMvW4gpmEN0RXGbtve?=
 =?us-ascii?Q?MCKLac6923wDq9WortuEtxugUcsxmpDpts2YVCMmlHuc42OMZC5zdyXSFm5F?=
 =?us-ascii?Q?GpT9Fz7agnrubO5vzRRJWqHpvVcZRn9eI4G7S4RxCfroWkCQe9NgXCq1Tace?=
 =?us-ascii?Q?YfaPEVTfUarl8SLY6cvRnQo6UY51/IO6tadTRVZbdgfnyU2KCdU1u12eZ06+?=
 =?us-ascii?Q?yeFrdHBOLvyjfsaFbGyxIMagUV3gwKnsmSMAUpYKjtauVDYaDWTbM69ikwZ+?=
 =?us-ascii?Q?r8XvCFVxMfjOm+ekLC2cwg3VD6B4oacRqifO3i0mNcEBD22zxKqeRFo0RrEk?=
 =?us-ascii?Q?IijAnzh3OzIjn4jkwyM/+1Wkn5mPrxLDbzXVrtHchYtGNzGhMFZc0yhseLp8?=
 =?us-ascii?Q?7pj9e5/s0XERQi+PFkEdjhOnWHnMdvpz2dTkPlXkpuozrVyZKywBkOQ99F6z?=
 =?us-ascii?Q?HTzHZXQNHewjFLB76303X9P4WfzDTB7FOnX4CFuhQtUOJBafS2Z4rUcRNfHz?=
 =?us-ascii?Q?bcw7QPcc95CiEG/yp4/uuaHfaAa9+R6YiQY5DXTVC+ZK6o/EW3YKR3IMYc3+?=
 =?us-ascii?Q?U8hdgG7m6vKpho+MGLbyjLyTtkmejs9B4dMNRO5rlXiL6GXzX3x29+Mb+e8m?=
 =?us-ascii?Q?5DPhuIMvyTcdu6iSDGBgdluKs1wZNJL5B35I6Rbckdm3rGH3YBPFJMHAb3BY?=
 =?us-ascii?Q?sqnUfulHVOuGN56/Y03jkQwZo1uz5VQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	whDV/5HHiLc5jRORQDvJKh4DqCXqTT4ERMXQX1FlL0NxckSlqReS5ebMdwg0DmoqRrYa1VQG7Z2D6cKwFW1gX/wv3SX3kvkttRim4ZApSpeLAofq+EAwIhUHQOl64Vp2OzSBmNoswyhW4AJZd5OZgC2Fjr5zIv4AOZUVhtTux2c8eWdYUiClei7i5+ukoER7AwdFoV5jQYbLtws8/nrPgkRZrf8T5u0hS8M5fNV9nP38bh5GnF5YjCJfzOSZo5mSZtJ267PSVpqNsh4SZ2s0uZlhPc0TPneX7tW8AtU0i0I/RU/759qIz8X8Hjuvob4+oMeX7LcvKlfa4fqwP5oKVpYqfmPR1P9Pb1AXVI7gYc30X1pp7iAdxG17OaeM9YvpiBzEecn4rz6PPQe47SfZ49x7xuDdJR0lKOzY3cOw3m3pkMRM5NdpQG5R3qKwoHXiB1RDqnl2bkeNnJDnFC1x/EGSv42xLzG9viytojkHFSD7aINUmlaQbsd4enmCY/RCnIxJlW3chu9/ZaFJZxD1kzOgghibSg3IHyB1sqFhsU1QpZKMtM1dW3YTWxMyUb6mQKPPR6mOOkzBhjHk0VIeLnLOtPsBXgUV8Z+CpUl9nvE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f92a001-1292-49cf-01e3-08de573aff22
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 09:13:23.5677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dc06l+hSXBEJx1Z5KwHS8N1Y9Q6OQoMvF51MlZQ1Ka5XufMnEu7C4h6sZNpZYAeB4LonxQw8ZZtNUrn1aHB4pXraZtZe6NaiLFuvUiOUQWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_01,2026-01-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=651 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190075
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696df5b7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JNo1OMlE6V1vSS93MAEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDA3NSBTYWx0ZWRfX+55Vq0VJEnD+
 ahV8qe6+Eyx4i6h3ckK/KPnhUx4v5e4LVbjsQ8ttawnc9cr/01LOsev72d5hfXajqxxjAi2fgPD
 4J/Pi9+aWcw6qUsPCTsK5zR6lLKsO34wzRCVIZYLyDsvMTuOCJfKyVJGingxXGP2OwHF/3g2ask
 09sGMnDbzuZNs4alaBsIodgeHoIiqRT3nd4N8DG4FuOH+E3OrKzPC/M0+He9ANyjn+FLtSN2+VE
 HoMZmmT3GQ5G/wxNAfL8nSUiiJ4IU33dIEPJnMX8mkbNkcN+MT4ybsgOtH97UqWLe5zHRg0Fsvn
 dzcuZd1+RroIvm3+i93s7q2O3M+/rWx+y93HGdKtnFmrL+LCPvA0S0criRNXVzJacuDjX3vJVzs
 baYR9lJEYZ9pgZZDDUb/NFP4Hkf9qKZOHUmW8t74NFcwPJDpBVUzM+5+q2A1yYegE8gWoUFZF9a
 PcgKm/YeEVz8wY5oG0w==
X-Proofpoint-ORIG-GUID: Ni0JKAV70HAb63AZUCnh-ew9GiAHor4i
X-Proofpoint-GUID: Ni0JKAV70HAb63AZUCnh-ew9GiAHor4i
X-Rspamd-Queue-Id: 51D1416000A
X-Stat-Signature: upk9wk769qhbrkrm6g8fiixyajjy1rt6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768814018-30660
X-HE-Meta: U2FsdGVkX1832nxVvUz+B2ogHb4REFxV2TZD5135dPqxA/K6HnELtC0rXSGV4RUtstUtZnnKOj5KCQ6g++XhW/CJzkoT3+S+rhzeH2Fi2q5NBBIAir9EbO8Ko8UVys9fJAS3qxrfdabAgf5sCApomONd1uqosVs1RXaeDUt+bRgFu7QgHCeQU7WBGMhrPm07sZiR0iedHppgWu7jRCWJJtfpBO93iSDXViiGSUJCvZfL2ZTbDjmSiuR0Vv67vVlUL2ZoMUjaN9u2R/SvK162qb8hgVHYi/WMyAAYTq+6pTkVuBZ+sij0269FXEVqicNm1fxS0I6Eex5PQU+TmmSCM4WZUo8yY+t8oZG+8obhoEMu3kLmAnRWIAutXCoYxVYQG8obpFJZeD8DhRkMbiv4PTZB6UR5DlkL9FpbB7EaMGtfwjnz9oR5IplQ5jH+/77K4ZfcRp5uOGWJB52FgrIa41PORt6j97ugTkSt2MHTKXIpTRrUy/tODrNbbsEOeAld19yul/t9QdLdWNbW941+dcdfJ+8YfDvDY2njQZanwbYXwMDcSpCNHvMf1SiSQmmXXrShSFRF9LS6DHsl3jZPAjUwcSKtQ21oyb8jEu/xB/CvwMgfOq7TJGKYCm27x+tnwUmjndtUsfnGwfUctjbMU6xER+WAds3KF0P5a5cbl9w+cFh3Lzeu4WrlqDVUeLc8JRUzRWdkvM19oVXyLm1lBFCpTVN8Wmr+HuZPVwkkAs47Lszh8HMhU+T8AhCOxpJIrV2R89y39K8bvwnNTJ7fyu3q5Q80/fagRfP8bfIZq/6s08eLCfp+T+FGHipBRWhLwCS/+BvDBW7192I7GJzhyehOtBGDRO2hdGpSjo7YOlVaxguRNY8t5u1bAz9D9CSdozNgzlMrLMHrRFHPX2kLShj4W0gnMDtN6sHdfaIehsSQSvfOouvLvZ9F+lxq/j0mXg5yA3PvtjvsVsDFUm3
 e59hHN6Y
 gcHdFx9fdyO5fYNuP1C8J73TOLukQ8KQDi3/RzpDgTvFhUqU/Fyh1LrZA66dyJTNubIMNP4+ABImqV1f7pj7RKh6aMNvN8ki1uUXxIsEawH0uSgxNOIlFrq6PkagmQaQRl+msx8td5ZgqDHqD8NSI4StKi/UEM2eioUavMDJqvvQjYmTBLrTxws9aw4UWFrFVRj+9oU1zNf+3zvsvwwoXjvf1Dgk6yPcb57iJ7V+LJwe0rzTfRXqoKD2IvxSJfFPqwG3HfEl2Vj+S3/lPIoAE8PkHhLXePGC8E9lq5pQ/6X8WiSF094CjBYYD/Od/+1LJzLy1axIGBvmhKA+qHqn6r/yV64B05726bcO+9iecv2FphKkuncKZ010aAmFox8oVsuuTuhhr3vfBeUk2pKb89CevHRNv+f9rDsLnRJ7D/ihTCBJDtjRz7eF89flWR/isqoz0X1JNJOx1z9Nmnxoe7J85wETtaaYjBYO0v1DKhST2RXyEr8L28KvjhC4VmEydcsKqfKXZ+KgKMw9aDuN1onOArRxz1rp43OPKnzg3tBfZiV7ADKrlSnlIX7D+lLwm8DUBrVP5xK9XKTklthd0pTnwiU8M1kJhledlMNsNt6tK765ze1DQbllJg0CuYy3BiyNm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 02:36:05PM +0530, Dev Jain wrote:
> >> About internal impl details, how is this test any different from merge.c, cow.c,
> >> etc - which consistently test/depend on whether the VMA splits/merges?
> > This is not a hugely civil/productive way of responding here to be honest, it's
> > what-about-ery and implying something that isn't very kind...
>
> Sorry if I have offended you, I did not mean to imply "two wrongs make a right", I
> meant to understand how the two tests differ...
>

I'm not offended :) just saying it's distracting from the technical conversation
- it's better to remain focused on the problem at hand.

I've made a couple technical suggestions that are hopefully reasonable - I think
introducing a new, clean, test that asserts very specifically what we want to is
a good way forwards here.

Thanks, Lorenzo

