Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39667CF6BF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB1C6B0092; Wed,  7 Jan 2026 02:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2836B0093; Wed,  7 Jan 2026 02:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887006B0095; Wed,  7 Jan 2026 02:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 757066B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:36:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E529B6411
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:36:56 +0000 (UTC)
X-FDA: 84304361232.03.3729221
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id A5B1B1C0010
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:36:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IrFm9nhk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Cra8go0g;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767771412; a=rsa-sha256;
	cv=pass;
	b=qzbKW/PqnE0CVBwcg3b1bHYTg8jPba9w4qSZ8RfDcXXCvOzw8PvBHEoE6Yu+JGDRlFQygH
	GmysUzFm/yhPIIo8zLQhcSWkFo2vl6dlI6jv1F0XAise35wZD3ypq16kl035ZZLUTFOURP
	pGKt3CtK/qXsAXxazU/959jER2QqPrY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IrFm9nhk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Cra8go0g;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767771412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wsP87ikguyBPoMm4fQzIUJZkz0KUggf55vc6adHNjY=;
	b=q2OYWthg/wOesbkarKQOykqrGh7jEivhjvBIjMEiuCLBDxC9Di3Barkb5SaantD8TVmD9r
	n9dVq+I6aDh8BQc4Aka5TQ0SWfM2UTSQWLxNL5mPscgz61JevlFOz0gKh3n1/GQ8fYEu+f
	oMFUhtINGT8lEDve2KhJso58zulZlMM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6076Kuo11431714;
	Wed, 7 Jan 2026 07:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3wsP87ikguyBPoMm4fQzIUJZkz0KUggf55vc6adHNjY=; b=
	IrFm9nhknCS/SI0Rqmh0cdhBF/4oLR7IJMDlhWPyTMDLLcad5b35L7pxq7K4IL1l
	UyMr6GkLa+HhkMz1hIAPah3l4B6EM8FNUMrHL6h4w7BSdHMifqdeMEymIEa/g32E
	xuLDIbwIVk4w526DMAWNlA7hkPUKvQA/tYHQ8iyQIJyG92D5ezdzFFRPR/1t+G1K
	vyltng1H1WJG0/PxHnxfrsy81b+AVV6d++/xazPuslbmWmTuCprrFUx/lvYtrNDf
	Tr4BSCPjyeBa88+tx9NZADj5KhjBO28zYRGLVEXVsqsg+m9Cz4J+l5xNgLTNs80O
	IJX/0S/QfJ76iRpRIGaJVA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhj4ug1wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:36:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6076txVJ020387;
	Wed, 7 Jan 2026 07:20:31 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkhwjh-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mRw9sEXgETErz0Q+E5kp2E+4OUwF8iPevvYI9SQG6CTqpyzGIZsX8sNH25gz5USgTgEJmQbqCnJGyeTcvG+rIL+DBGE+ALYA6Q3bgL4s/SZOcHujXg0xE1k9PLuUe8GaC9KRTuSM5uBpEY9V5TPfjf4ba4alfGG/T7y48la2pvmN2y2ij8FIz98ajv0H041yQC0meIV1NAQ/2JeTHIofRno4cVoPwUfuvz5ejb64tSFsSZNIClzndp3Vn2KRA6HiZuPFg8PRwrd6STp4eFvM3jRkrNvCyw8FpOcnD9Vvr8T7dhxlZKsW8Ohb8dXg5Bp6jCf05VyxUWXGrPSzv5MJ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wsP87ikguyBPoMm4fQzIUJZkz0KUggf55vc6adHNjY=;
 b=Zlx40O/8A3PRXBqu9qAD7nYLdwph8dk0afraxsAYZgjWWfQNqK/bxC2LvE3JzCxBIJTCL4Ys8sh+PRPJ9x8MKonMAkCnRyUsfbDPeMmQpXsBQmEoqfLnlUO7K4881L1WDiJPPddehT70jV0mYn8lLoVmxSmIRoY+C5xOntEPu/TQIcWEPsw6iRb/88Ms9MKIlDngSuUDNw8jO5DhiNOF3ceHmmNj9ixveh4csHKHilY7HnMfoUxRCbDSly+HtjDCI0q+6QJnFvCRq4VcJDbl9y447jGVjisWmhkOnmqDFcAVg3+vrzR2tM78iHwqVQNrFEF5oobskRc/+XKB8J3nbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wsP87ikguyBPoMm4fQzIUJZkz0KUggf55vc6adHNjY=;
 b=Cra8go0gyUc49ZnSEzUu6KWE1nWNZkxb5QahNvnMNqdUsDKzP/XGP2ce7K+EhxQF2fHxFL6jwyByWTKG5VZ+qYdQgJjhl4Ebk5/+d5if8puA1CA73mLSU/38lQ1229dfUeDvw0NMc42kOpurYAkCQPmR3QGVbPxyjYzpE9tZmuM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:29 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:29 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v11 7/8] mm: folio_zero_user: clear page ranges
Date: Tue,  6 Jan 2026 23:20:08 -0800
Message-Id: <20260107072009.1615991-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0056.namprd04.prod.outlook.com
 (2603:10b6:303:6a::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: 729667d5-bad1-41eb-7b83-08de4dbd3c4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BFN42qKpS3HpZLbuSiaZ7pQ4i2eJClRdnOGkVoPfv+K1oYpK6DHvNpdymc2r?=
 =?us-ascii?Q?6E6E5C0qi0YOfQTFjIjIiQFksKRs06Zcs+bwTP7WuBRZFngc4qIQiSa0w4/E?=
 =?us-ascii?Q?h4u6tL87NWAbw1YX8/XG+ZbJPZFHbt0as78B1xu4O99oGX87mH1rtW2xKTDj?=
 =?us-ascii?Q?KVWQmxYL8ezWeUQYtDJ6sFHMoEsoSm9QuVCZd4HRwf7fi11EHs/722BwLzgy?=
 =?us-ascii?Q?6sawkS0nc5SpOXoVific7KF4nc0xTcs+DP4HwTpImQ+zr3uRg75HfPdM2A2G?=
 =?us-ascii?Q?4HvHcAah/kL1hFVb/o2aLCckhOXxx44Q14qqXYRSRHcBDk6IXDkcUpRVefwN?=
 =?us-ascii?Q?fmmetO6heuq40ZtnOQhNSvBWtJH29VhUezjmJrPvSThKtDrDoRxYHFM6H4kt?=
 =?us-ascii?Q?vwhprvreMGFlhb1xcdMxUT3Coh1qjPMi4cTSeeUT7cY4qcXk8PzJD+IAThdu?=
 =?us-ascii?Q?qqvRnjRqIG4g7YbUb92XqBtyTZQGbeo1au0Yr0OM3S0gvLViyJcMhhinQHyS?=
 =?us-ascii?Q?t9xXEpPiSX206DI0/jsHpKl0aq4t9s3FPE+o0/YkTDNdMdpHREqlHMahDpna?=
 =?us-ascii?Q?/bBGIrmKduE8vWNRTZGnwvKSpqR6yQ65XijZkMgP8qhSE/RYpQRRdxgHgxRY?=
 =?us-ascii?Q?AameFHspdWYgcuM2YYbjPxf2hrVwr1es20yaaO3hDiYUlYPAMr/bAzeJ5WuR?=
 =?us-ascii?Q?8qJUBS8koIpdg1zodzGChpt4wp3xoaZZRVXBWadHMn0s3dQXPGofIc9oc7Fx?=
 =?us-ascii?Q?bbk/Fxn623rRTlZueimOY+h0XJeDgkzpQoTG2TQzT8q35U2m07I/lgiNG5fe?=
 =?us-ascii?Q?oJhiHhb9yA6Wng41DnIpNniDEfo7wSoP7TkDO5Bk9tefZOwXB8Fg8qFkvPbh?=
 =?us-ascii?Q?Inacw8deM7qo/FGUmZTNvxvfrTHQoX0ciArFFrVDt2ncGgGGd0V/R95GaOiz?=
 =?us-ascii?Q?mY6i4qJ4gqnAd9krTa+9a2wy0szGAMqPHF7JPdiiemrq4ROg+s74UievgIGd?=
 =?us-ascii?Q?HfMpeFgOSarsOzuvLi++fLxyDxN9PPib/8m1Jr/CT/Pwo8PxV3rYEJVHP2tr?=
 =?us-ascii?Q?5UkYR2PFdSfumF5UBN4iJfXI5thr4TQS8SarA3YEVS1VNPE3/8FiqiHJ6Bld?=
 =?us-ascii?Q?EcpJiGZcs132UG0k/DRWyKvMkssd2M3Ai437mHc7SRKjRwc4+DTfE72RKOZk?=
 =?us-ascii?Q?KcgsR2TXbqZ6E1AFf2G9u0vYc72f+st/awWJbcZaNCgi37qQ6lRD83PwAKIS?=
 =?us-ascii?Q?NV7WyLksEWt2H0dRQV35aNEqD9cPEW7oqHN0VFd1Q2FzTAS8l3n5SkR10tuL?=
 =?us-ascii?Q?Zs2tlv9H9HUYUfEGRsnntalVHEUdHTeLlrA6nn+xmDnZpVK2+YPj2UU2U82s?=
 =?us-ascii?Q?SjVsPD/wd0m4XXbxQlhQn291B+ypY8cxRLkzyRkNDhslChQvL3z2uVzgQ8EA?=
 =?us-ascii?Q?Cl6nFe5FkIRWhvECPj1sj/KWJrbn82Y5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a6+dSTFkZV/MuFNhv4B5+GAk115NjeuLtNWyr8iXIfDlcOctxhuELfdKmv2e?=
 =?us-ascii?Q?sn4d7SyxGDM5f7xTYAhchMh+KhUHozPFMQn392758fMIYQMz8g50zDZUWYHS?=
 =?us-ascii?Q?XbE6ZgsKCu5uwFAnWNyjvKva280ZZkWXgCwEdH6jBjUwpK3KMdp+xg+SZgH5?=
 =?us-ascii?Q?n8DqEB2z6y8OJ3wLDbJOo7Ys0wxiOc/07E8zun1VnJ1Q79hzNiLylDUaxIta?=
 =?us-ascii?Q?eR5a3b5sDPSt8wYsb7bjmq2CLAeNn6GzOnz7/MxSzmCHh0SnbkBS/p4ZxF3G?=
 =?us-ascii?Q?BFy/z2oo3KMKSaQbMqDi8+djdc0Ura1KBhlIbkbvLsMngrzUHBnE5F2xQJVq?=
 =?us-ascii?Q?H4b0JQPmNlUFXv4opiLUlYldF/ll43vw7/k5QUlZFpr0AF0YcZuoqQTweNJW?=
 =?us-ascii?Q?NYnB59rXF4gYtyHbldf5QHE+kHVGxMHM/TI+Ykn5KSiBH3sAYi2WnHSVRNJf?=
 =?us-ascii?Q?tuK7GUcGndCrz0Zw81NsohZVB02ak15c6qVbcLmTbGHS9BXJJ60rO1Q04ICY?=
 =?us-ascii?Q?F45URcSQ8vKDMHQCoKDV2uDis8HNTj1kFItoRC6i99tmGELkmHXM74BIthR4?=
 =?us-ascii?Q?KIP46KscG06neEylJTpJaxttZtVnZ52gNwpsLExJAYmqwSGeJlUf/UniQjP7?=
 =?us-ascii?Q?oIsaFNOjjOnbc/f0TgWYrZlBOTMqMFKPEsxFM94T07D6FZN9lP/r9ge//Mp1?=
 =?us-ascii?Q?ddGr4lLmoiYYpRkV5EaG4+TRmsIvD70jSoiLHcxR9xXkfhylW7PKUx3lQ1MS?=
 =?us-ascii?Q?19IkCJ4bUs7k8bj6c5X7gkp/oeJ6K/tdBgZ60MEp4NAA2Ijf1z2/Ay2wo6c8?=
 =?us-ascii?Q?auj/RUFyKAEFke9APErejB44SMRmGzPnaCVkUQ4smd63oURl6uYYjZ0HY4fv?=
 =?us-ascii?Q?x3DaBujMWJDBx5td3QeTHgHk2dFlsFHa2wKu+KX1wiV7dygznkfJkWLWnbAq?=
 =?us-ascii?Q?hWgHwUXioR/hLvty3U38wFnbufnx4RX/jtqfkTBJeMOUadGWSqZ94MHbGvg7?=
 =?us-ascii?Q?mwEQczlpxG4Yh3p/HSkmkPMU/orws6CKHwjhgMRbhfSS0nz0/SoagKvpwFRV?=
 =?us-ascii?Q?ExTwhdZ4mA63kRJQ+bzkqLW6bDFE+k2F4KNKDSt8tZHYjNpT+Gr3393itsm/?=
 =?us-ascii?Q?uXwcXeyiCWIkIdOqK6pN7kocr9iX5AMdi2Ahj/05DTXAxnrPgu2Y4ZbLcKHX?=
 =?us-ascii?Q?BbbGTbIigvDJVmvMlW2zh2dcbTwhQHTkJpnr3bymy6/NHkjHacvK3qjAgpzY?=
 =?us-ascii?Q?WFap80tHxnNYpHkrFOCxIX6MUhxmsiGtVXxnclfJl4BnWxAs9newRhAJLcJq?=
 =?us-ascii?Q?LjAPDT36eCyhCdPoHmj/pOpTgSccoXVddxPoVyVykcEtbEDaIAlfYuT1xRmD?=
 =?us-ascii?Q?IGhgBfqZ6fGB4UBwfqkg/AeFYfmAlj2Kr4rUDtTvpGhpoOjsbRRGHm+5ZZBd?=
 =?us-ascii?Q?3vJKSvxn+JTujiARFD/R9KOzW9QzwBithce2t5L0snXOIbv/BlJAb6q+1Fgv?=
 =?us-ascii?Q?arMhevloyicLpyhXmfDy3MFBlf2YNEHazp4TOw5KNOg+K5ajF0adnZZTRt5p?=
 =?us-ascii?Q?XC5GREw1W1ykZzNfv6il14rJIW5zQaOv2xtAZ3dkVDUosIAdOem6JeHofWZ0?=
 =?us-ascii?Q?z3bpEFWAj5Rm7OYLOY/EgpJWG4G13ac4IA6QVVER/bMgKh3AkuGAAX9dY3fp?=
 =?us-ascii?Q?D7LSwJ/ZBFN95YQK1raEgYlqW1outMfOCx6DNh7bqIStRuzn8FFFGsHivKhs?=
 =?us-ascii?Q?ihjOvCDzC0tBARBKykXKzQLwHyn4inc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bs2rBqmw65VqSA9MYEG699zIZUF+hl0jjI/kWoNtmNv9T55vx4J14Kf4l8bit4rtVFYabpdmy2P373nVZM1kjj8p9CmEnNFuxDDrvJXSHPTD6fvlKLsVGzLjwFLA3R7Skv8QBs8nWyAf9qJhSE7fhPlX45idpwRW1RLglWFpMN/hTif9P+ZTh7ay0aP6I8murgilOHLkJaMIzwCQPmNUxCnSTkbqLxckYBSS50wQmnDIetQyImo1JFMR6ld17C0o3h2JzlrAHJDPAoHGYH9K5A+G8lQp4G6TRip5HqEXo9xDNSxYlY4yq0NLoJ0+xodlvs4e45BOCaVRGf6Tdv4fwhxySCHtu6qQf6xSbYVHfj2DdhhWN4eKi9v+DXRlJritJJAJ403V+6ltTHE9O8wPC1gwupsXJ4aTqKfgmstnuuCSNwcw/9LvvIAjdPJDWT57NicCqe07DCNSxkds6nO2so2oNA0ft+ckIqfatapo/iocM9cnIebP9eMWqyB3fjrNwBhZP7lbGivk+49wLjUScOtj8ifwXcrIhYcBuzVzwCPxQPvYZ0bHRKsp6o/NjtdSZ0q8oDfbYWCwnnhXbkcVtMRkeeUqyFIRRlTuxw+r/qw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 729667d5-bad1-41eb-7b83-08de4dbd3c4e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:29.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/YDNY5xoo29RHJ9aP4g4wpd/4Cy+Cuq0deodZJzMNLl/tAPeI/FWNkuVT0Ti41Buy7bODVfVt6Ic2BeMzEqczxxM++1oB0KocXBB980gqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070058
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2MCBTYWx0ZWRfX4AXfJxZyMj+P
 3kU5mhNx7wGX4XyV2LicybEMXlGbq8caTWfYWsIsEgGbFnb4J0x2GxWlDrDv+NXNVDHclGAkYBq
 yMvW/EYB5UevBWjVFLhihjxtdD0bvcoJ+9KtFYR7BnljqylCIZRmEauajjArkx+Gz3Qp7sEl0U4
 BhfeWRdZK9XhEW/y4+lmpcTaCVEGrdSwV1fjm7BAdGOiugEfWOZ9a/uAny+00rM/9gRk5vRH5eD
 /fAeEnkxZWnpRDxzgX8ROP5bthXebAfltpJaJhNi32CJiPwH1mDl7fmQ6S98/GtXeSjy4A090b1
 3D/gkootQYJh3prgGtj9X2BQ9xsuquC8/CdzT4VHRsoWSpKESFmSUMqY/iS36nsmSrMrw94HkOv
 TfpjsMNtPQo7N+E8JqQi5XlEQKSh9fymbqY5PlCoB47qYPx0LTLPwYYoTnRjwANtZ6lPtG4ZZ4i
 B0L33Zz+OcqxKHOvjYp2wpCLT9rODik7UraU8njE=
X-Proofpoint-GUID: _9U6CJ7QLXJUWB8d6H_5xa5oxVW3TRj9
X-Proofpoint-ORIG-GUID: _9U6CJ7QLXJUWB8d6H_5xa5oxVW3TRj9
X-Authority-Analysis: v=2.4 cv=WP5yn3sR c=1 sm=1 tr=0 ts=695e0cf5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=vf6uuqR7Wl2Q4O64qLYA:9 cc=ntf awl=host:12109
X-Rspamd-Queue-Id: A5B1B1C0010
X-Stat-Signature: gj77a317qfa11pc4aygbtsrh33dpde5s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767771412-848086
X-HE-Meta: U2FsdGVkX1+pihoskXZL/O8om14GPdPSpLrHaLtp4Qo5bK+wa6m5/ogDzi3F5VoeFkW2CaUo3ixxAXso12q9OMErQK7uAp7GySzOJxPyILMUEduZMRp4tB76GBcqjk4e2p73en+3eedw8Pqv/Etzc10XZbuprGTkKQPeNSnv3AoT+SpVT2kej6uW72F0DabCAtQDcZCN8Yyz96mxGEYb5iZN8tZXHtGlV6muHc4Z8sd56KsxfAjh72sX86peHEN1S1hoHDZ+UCtvIgGf53Rfe3Xbx0BnfnnB1acuJSvvi4U2ZZ3iXqDSeTP6RRa0hJkRZ8XSFkBWPgT8EAWjRab+SPH1cjDPIEan3eYolZbpZ9iQfFl7LHNt0FktHAZvhOBnChYs6fN296SbVzQIZ3shAHv/mcdw8yC8v5yTQmgKFLbuRqj6gh1TjlEp+NWvyxPmxeQSbLrJGQZgOydeevXg9Ia2OJo9zMLfzARJ9ErgANkvFplooxBHYfjSNLiSI1osmmCQfz0g96YsUATNOFOgElQS/dLw0B6qL+ptLrUU2ytev10jf2/rusOwB99VaHcJwVpv9S01WMGw/uZMCGp2mTMny5CO5KFMe34LUqO2aXOVQGbLknljcc2xyemyeP9MfP/osTmsR4YstAUGAoklhANq+7jxOa43N5jRDmv5gmBxHsBN7qIyvv/+mP/BNiTJXX+1OF2fiacz0gARFNU1QVPGC4U20mj8U8qOwoMdwr47BqaBUXIuBNC64BM4gvzj16LLqo8ykuL2ACbR+oGKJ9ywYsjG8Wo/puTUZ4PtV35w+S77PogFUsPDzgX0C3QCaUC/HpnR9KUsxSXn/Hr7GUuQY+KhT+wzxXNsAB52XZ/fKFENXaC3/SVgG866I1IJU8A5ojPkKuvoMP+3zRTz2i3cjmtuZd052OhXNohaoQzg9UxRQNpDjxFGqwYTRUaXDGEv3IUFWpoG9osdLgF
 rBeajCRB
 Tox/XmQRZiJghWuh3nRq59NDfoUFkxXHHyuIbGU2xRlHKcStZ9MH2OryRCLTYoCyO+FDvHpEC2FKRzyqsJ+XHdWHnb2EY9zWoglgEsOhYoAJ9f4flr6W4pgAZe9XTrJ3YN2oQyey8MXwtWWvbOSbU7LHLtJt4dA66Odqy16ixZY6BNTaNHzXAA0xMwUwUfq1R6r7jbYGIWDvAMbvh8hTEPFclFnL8S2Vo6GcpV83SS1W26mBYCnDr22DI/RhOSpJsYPfHkem8uQ6Q6FMV1LcTz5jDHCp2asjMYodxMrAwETACvX7GG0sPGdQziaZ6werTQMX4vk6PNb5H9bjlu/s8ylFgiRpsblp9Izh9qEBqA1r012+6RCGrT03jXIVlPAcPwNTvfxrQ70Xwx0Ey+qCwkFHCCFCYGbxn8EU65srL6jmMiS8TlJDUadB79FotG08qghN3fToimAXbAczRL4jZN8YtOmVCWaraVw78xzNwT0slIhCDs3z3f7UqWSrSF1N7rG45g90myXKZa1fsIKI1qwtn60ejLMaTsxgbSpdAyrozpviEwH/8qcUebnB0xKJYBkKTvm0XxSiBMqcEwMh5313u/2u7Ph1v6cjk2fkSts74O8UnDvFRBqgwLusl3DdXzSz32yDin6yrraGi0AYofp/yNBGj/d5WRFDjHbRH90xTyTIkJ97TE0J0uQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use batch clearing in clear_contig_highpages() instead of clearing a
single page at a time. Exposing larger ranges enables the processor to
optimize based on extent.

To do this we just switch to using clear_user_highpages() which would
in turn use clear_user_pages() or clear_pages().

Batched clearing, when running under non-preemptible models, however,
has latency considerations. In particular, we need periodic invocations
of cond_resched() to keep to reasonable preemption latencies.
This is a problem because the clearing primitives do not, or might not
be able to, call cond_resched() to check if preemption is needed.

So, limit the worst case preemption latency by doing the clearing in
units of no more than PROCESS_PAGES_NON_PREEMPT_BATCH pages.
(Preemptible models already define away most of cond_resched(), so the
batch size is ignored when running under those.)

PROCESS_PAGES_NON_PREEMPT_BATCH: for architectures with "fast"
clear-pages (ones that define clear_pages()), we define it as 32MB
worth of pages. This is meant to be large enough to allow the processor
to optimize the operation and yet small enough that we see reasonable
preemption latency for when this optimization is not possible
(ex. slow microarchitectures, memory bandwidth saturation.)

This specific value also allows for a cacheline allocation elision
optimization (which might help unrelated applications by not evicting
potentially useful cache lines) that kicks in recent generations of
AMD Zen processors at around LLC-size (32MB is a typical size).

At the same time 32MB is small enough that even with poor clearing
bandwidth (say ~10GBps), time to clear 32MB should be well below the
scheduler's default warning threshold (sysctl_resched_latency_warn_ms=100).

"Slow" architectures (don't have clear_pages()) will continue to use
the base value (single page).

Performance
==

Testing a demand fault workload shows a decent improvement in bandwidth
with pg-sz=1GB. Bandwidth with pg-sz=2MB stays flat.

 $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                   contiguous-pages       batched-pages
                   (GBps +- %stdev)      (GBps +- %stdev)

   pg-sz=2MB       23.58 +- 1.95%        25.34 +- 1.18%       +  7.50%  preempt=*

   pg-sz=1GB       25.09 +- 0.79%        39.22 +- 2.32%       + 56.31%  preempt=none|voluntary
   pg-sz=1GB       25.71 +- 0.03%        52.73 +- 0.20% [#]   +110.16%  preempt=full|lazy

 [#] We perform much better with preempt=full|lazy because, not
  needing explicit invocations of cond_resched() we can clear the
  full extent (pg-sz=1GB) as a single unit which the processor
  can optimize for.

 (Unless otherwise noted, all numbers are on AMD Genoa (EPYC 9J13);
  region-size=64GB, local node; 2.56 GHz, boost=0.)

Analysis
==

pg-sz=1GB: the improvement we see falls in two buckets depending on
the batch size in use.

For batch-size=32MB the number of cachelines allocated (L1-dcache-loads)
-- which stay relatively flat for smaller batches, start to drop off
because cacheline allocation elision kicks in. And as can be seen below,
at batch-size=1GB, we stop allocating cachelines almost entirely.
(Not visible here but from testing with intermediate sizes, the
allocation change kicks in only at batch-size=32MB and ramps up from
there.)

 contigous-pages       6,949,417,798      L1-dcache-loads                  #  883.599 M/sec                       ( +-  0.01% )  (35.75%)
                       3,226,709,573      L1-dcache-load-misses            #   46.43% of all L1-dcache accesses   ( +-  0.05% )  (35.75%)

    batched,32MB       2,290,365,772      L1-dcache-loads                  #  471.171 M/sec                       ( +-  0.36% )  (35.72%)
                       1,144,426,272      L1-dcache-load-misses            #   49.97% of all L1-dcache accesses   ( +-  0.58% )  (35.70%)

    batched,1GB           63,914,157      L1-dcache-loads                  #   17.464 M/sec                       ( +-  8.08% )  (35.73%)
                          22,074,367      L1-dcache-load-misses            #   34.54% of all L1-dcache accesses   ( +- 16.70% )  (35.70%)

The dropoff is also visible in L2 prefetch hits (miss numbers are
on similar lines):

 contiguous-pages      3,464,861,312      l2_pf_hit_l2.all                 #  437.722 M/sec                       ( +-  0.74% )  (15.69%)

   batched,32MB          883,750,087      l2_pf_hit_l2.all                 #  181.223 M/sec                       ( +-  1.18% )  (15.71%)

    batched,1GB            8,967,943      l2_pf_hit_l2.all                 #    2.450 M/sec                       ( +- 17.92% )  (15.77%)

This largely decouples the frontend from the backend since the clearing
operation does not need to wait on loads from memory (we still need
cacheline ownership but that's a shorter path). This is most visible
if we rerun the test above with (boost=1, 3.66 GHz).

 $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                   contiguous-pages       batched-pages
                   (GBps +- %stdev)      (GBps +- %stdev)

   pg-sz=2MB       26.08 +- 1.72%        26.13 +- 0.92%           -     preempt=*            

   pg-sz=1GB       26.99 +- 0.62%        48.85 +- 2.19%       + 80.99%  preempt=none|voluntary
   pg-sz=1GB       27.69 +- 0.18%        75.18 +- 0.25%       +171.50%  preempt=full|lazy     

Comparing the batched-pages numbers from the boost=0 ones and these: for
a clock-speed gain of 42% we gain 24.5% for batch-size=32MB and 42.5%
for batch-size=1GB.
In comparison the baseline contiguous-pages case and both the
pg-sz=2MB ones are largely backend bound so gain no more than ~10%.

Other platforms tested, Intel Icelakex (Oracle X9) and ARM64 Neoverse-N1
(Ampere Altra) both show an improvement of ~35% for pg-sz=2MB|1GB.
The first goes from around 8GBps to 11GBps and the second from 32GBps
to 44 GBPs.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/mm.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/memory.c        | 18 +++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a4a9a8d1ffec..fb5b86d78093 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4204,6 +4204,15 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
  * mapped to user space.
  *
  * Does absolutely no exception handling.
+ *
+ * Note that even though the clearing operation is preemptible, clear_pages()
+ * does not (and on architectures where it reduces to a few long-running
+ * instructions, might not be able to) call cond_resched() to check if
+ * rescheduling is required.
+ *
+ * When running under preemptible models this is not a problem. Under
+ * cooperatively scheduled models, however, the caller is expected to
+ * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
  */
 static inline void clear_pages(void *addr, unsigned int npages)
 {
@@ -4214,6 +4224,32 @@ static inline void clear_pages(void *addr, unsigned int npages)
 }
 #endif
 
+#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
+#ifdef clear_pages
+/*
+ * The architecture defines clear_pages(), and we assume that it is
+ * generally "fast". So choose a batch size large enough to allow the processor
+ * headroom for optimizing the operation and yet small enough that we see
+ * reasonable preemption latency for when this optimization is not possible
+ * (ex. slow microarchitectures, memory bandwidth saturation.)
+ *
+ * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
+ * result in worst case preemption latency of around 3ms when clearing pages.
+ *
+ * (See comment above clear_pages() for why preemption latency is a concern
+ * here.)
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		(32 << (20 - PAGE_SHIFT))
+#else /* !clear_pages */
+/*
+ * The architecture does not provide a clear_pages() implementation. Assume
+ * that clear_page() -- which clear_pages() will fallback to -- is relatively
+ * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
+#endif
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
diff --git a/mm/memory.c b/mm/memory.c
index c06e43a8861a..49e7154121f5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7240,13 +7240,25 @@ static inline int process_huge_page(
 static void clear_contig_highpages(struct page *page, unsigned long addr,
 				   unsigned int nr_pages)
 {
-	unsigned int i;
+	unsigned int i, unit, count;
 
 	might_sleep();
-	for (i = 0; i < nr_pages; i++) {
+	/*
+	 * When clearing we want to operate on the largest extent possible since
+	 * that allows for extent based architecture specific optimizations.
+	 *
+	 * However, since the clearing interfaces (clear_user_highpages(),
+	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
+	 * limit the batch size when running under non-preemptible scheduling
+	 * models.
+	 */
+	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+
+	for (i = 0; i < nr_pages; i += count) {
 		cond_resched();
 
-		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+		count = min(unit, nr_pages - i);
+		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
 	}
 }
 
-- 
2.31.1


