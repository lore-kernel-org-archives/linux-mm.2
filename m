Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B514D5B868
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC50B6B0099; Mon, 15 Dec 2025 15:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97906B009B; Mon, 15 Dec 2025 15:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F48F6B009D; Mon, 15 Dec 2025 15:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 759326B0099
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:50:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D9C78A6A5
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:50:15 +0000 (UTC)
X-FDA: 84222897990.16.93A2DAC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id A09D01C0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:50:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V7gMG3ts;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=H2r0P5yR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831811; a=rsa-sha256;
	cv=pass;
	b=zqaic9njFQilsBxLRh2UzqL2vM21ENcakbJ5dU63lWJ/Fkve8glyufdwKfFqZvGOH2rzuj
	vfOvbgw7tcQwXxRMC4hDy9E3T9zUiYMbijCy3TYprphO/nvD4NAoJ3LeKyYvGio6cxIMTm
	9W+SLazH0Amwly65AWBYxb4lz1q9qOE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V7gMG3ts;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=H2r0P5yR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lO8eVg2iAlm0dYKuAh/vF3NqQMoeZZEphyYKpwFwkNk=;
	b=Bw/ePwey2UZIBccExP8+Sr3HKWlzu/CggsxvzeR0il/Xjf9qOevn10icG1EoiD129Ha3iM
	GyzZ4B3IElSY8k+iHcqSPRK+O5xpzChjP0CLkDoG0g6RM4HcE2ksKZ0IbFJGDqkfb6NGCi
	hv6aFl00BMLCmE1MoLpQVqVOQIX+BtM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJCBxG2854608;
	Mon, 15 Dec 2025 20:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lO8eVg2iAlm0dYKuAh/vF3NqQMoeZZEphyYKpwFwkNk=; b=
	V7gMG3tslejU6jyHhZi073Pyfnc4BekiOaQBljUYf7gpl1434YQvwVvDZsSUjYdq
	mG4WMAx4JEye51FrFRVc4Dg38vyFEcyOWsKtE5Kgc/O7tnSBwRKilmZ0L38ZKH8V
	VinxHKBEKQrxX7jGGlm7N+Zp8HF40HQ5dCMsN7MeA+x/8JKP8Cs+0bFfUIYGA/D9
	ITDT5ki2MbBEwEvTbyWY/3fCke3NreferlvCfWYynaMXQI6E+g0hfyVNw36VcEq7
	024jZ+KvIZfjgzmXwSSWla4dL2JJBXeOF8B157v5+fI6g/ZbKAvgV4GDk8QDULjS
	VGMaHp9Zh4OHy4kDoLf9Xw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28aunr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFIpCxe006243;
	Mon, 15 Dec 2025 20:49:54 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkcehbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qp5giSBSXYkOtlCMDfHsCH+vpUct4Zx1Nx9l2Jygj1TltJX5CibJODEe5iGiqXybI9Q39PtuTFIIWXvJHqkKwu/RrjFHxAJlqPLWHc+b7ZwpK+NYCFBAr7HIujy6LLuGP9R3O5GL43ECSdVswo2XxuHOp4QXBhgxAJS9xs1mxGXZctwc0A5oO01ixiyebQjtqCwrMbJqLqUmnrom2s9MKM4s9CN8djq8BLBw8eTWWN37kV/YbATVQYODI+ctkDSUMSpw448gDx1Ri9Ey8HROt2nyQoXMyMUdabKe730lxc6bpS1sGAl3jGTDBTEOhag9Ew75tN1w/h10hImLOUErTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lO8eVg2iAlm0dYKuAh/vF3NqQMoeZZEphyYKpwFwkNk=;
 b=BGcIX/CK7uE2/3C2aEK/cdvxsrIpDzk8OXcBV+cm+coNpHX6j9I04C6t7GmKOja6xqzyatGYLITCDBDvfT1MPDpKg01gyyrEuF0H8mKRXIWWRmFzqLb8EpICGzV6TgGwveYvRRtx5WblxYjlueGipMmi2IPu5UkcwfZNamvnDPohhCrES2iT7+skR9g07OPrNq+nDFSEvt3KFondecdDKKIItly8eooRyAARQh5WXzxphy5ZRp0etH2NuIpRx9feCm44+Of+JvVHiqr/tKMCd0bPpvGczTV2sO8fXOo/ml4JztLHBh1L9o6Cz6AtY0oSqvoWkTI4z2dzUWg1w51+tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lO8eVg2iAlm0dYKuAh/vF3NqQMoeZZEphyYKpwFwkNk=;
 b=H2r0P5yRu9jlj4NutB+Gaub1eYHZc8zyZsGMczTgEMczxP2tgyjJZrEIgU+ndEZvjHmA1o64AxaWVLYrI1rUxcL6PUgcK9DKvUKGzXgkVQMI+mieTpdEhFnASl4MtdDvUM7sAJ1PYuplWfX6pP1i650QEPtaxr5YvCOoXjTthZc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH4PR10MB8049.namprd10.prod.outlook.com (2603:10b6:610:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:40 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:40 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com
Subject: [PATCH v10 8/8] mm: folio_zero_user: cache neighbouring pages
Date: Mon, 15 Dec 2025 12:49:22 -0800
Message-Id: <20251215204922.475324-9-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:303:2a::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH4PR10MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 35998d07-fe53-41c9-a8b4-08de3c1b7776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+f2ZNJCJOgrK9Nc2U75mru+GoihqNO2ANytQMqipXEG7Sr4mGQoH9ge5Ttis?=
 =?us-ascii?Q?hFGc8KX4xcNLZpUjDGX0INT29p67vZT9PGaslM58qb8yEMdApfpPHO/7pnBs?=
 =?us-ascii?Q?96EydAYZcpeT5j8BqdIzNQm4GrBzldCW5v3wlDQ8Udaq6Y/LvoW4fMx+7gUQ?=
 =?us-ascii?Q?PS9OUIawiBBLEJaBBR94MglkLuG9OqwpblOfaLFufAuu4gGUCs0Y9AhfRkaG?=
 =?us-ascii?Q?mGcDePGwCFhe9wJiUAEPOlUOpTqU/cJzf3ze+rSlqSKT7jM0DhyqXxNb0/Ub?=
 =?us-ascii?Q?aMvqI31F3LWJ/L5WT3k16XC7gYt+mkuUbMhQ6Y067MrBL4TEBAyShhJBZezY?=
 =?us-ascii?Q?HOP9DP19FHIMLrc0MGsBgtTlvnAUD4Wik+u5ZQj0eirGz1DSGlNVbE6cUn2y?=
 =?us-ascii?Q?v1p/AsW5/ky3T9kKv3uVsyBd4EsdL/zPQwC3iRBb6GUEl/55o2BvhFNlFLCD?=
 =?us-ascii?Q?hBqW9KSjNiftHhuES1UHYzBUC8t1JKMuVYRjTDLY7wU5XuCuKxleIR/ABTed?=
 =?us-ascii?Q?gMMVXhD+VAy5RghPAZy6ckq9CY2M1XSbI7n6w+24+3qzP5p4fE66mvfI5n3u?=
 =?us-ascii?Q?Ks2xDjHDGm46jUec1/e5MYyE6fR3DGx6VX3rUp6BByTonTWNNul/GV5dlgDJ?=
 =?us-ascii?Q?1Bqa/CeC9oT/c3Q8fjiNFsxRouR3uHFhO5j5DDDpmBmJfcwi1Mh37BxCsZ7D?=
 =?us-ascii?Q?vpOrZq5Z951zH7diX0s1ja/LTQryNuwltV1NCc2qGyyuhldgle68nnoZhSP8?=
 =?us-ascii?Q?6ypE5tW+i7a6O0BqF28DgxEJMckHGcSsMwbhvshHII7LGVgO+xQ0GpLTNwoQ?=
 =?us-ascii?Q?JBPG2O6/zHHK+Y5AnPQEsEiO468PeTR6j7uS/QREdkqfwJ5s5MSqTqCdHlid?=
 =?us-ascii?Q?YCRcH37Xp4RwzBpxmZjMbJzhun4QJXu7YfdlVz7EwbBNkguU2995mNQKO2cK?=
 =?us-ascii?Q?iE6pLyCo5U8MhCEV+iYg+LtCEIOV2FTlvOL5szSNnCYvnewyflGXYjOtaQec?=
 =?us-ascii?Q?pnYlkd192yCd18xcEa27LjQusH0OT7C8wVIpc4cG8yaOOH8V/WTph036wkIK?=
 =?us-ascii?Q?apOhs6Sr0xCoriu/ydRC3nX4zc56A8gqbyW5t6JrDcSrd/oaexsZ8qEC2jfG?=
 =?us-ascii?Q?E5v7M4sP8HAYpV0wf+7sKhITYIiZVl6c2kNZ7xDc8HyYqh8H4j/g4QQl2Wlx?=
 =?us-ascii?Q?lhPX8R9T4Z/7uWYg3Z66pEZkjCSCQerhIO82MEklTXujVpkgffivvr8vgzDy?=
 =?us-ascii?Q?3BvjSXnpXW7GkY66k3un13peNblqEhGfvspyiW7JoMkaSiU0ExAcmQ5+VrMQ?=
 =?us-ascii?Q?2SEUkSbGJBife5xqm/zbr7k39uAoOFIRSjPrUbhmCL0jik2mWuequxYpBwkP?=
 =?us-ascii?Q?NOrlWjL+ewCDdWQHjVyini36JEdUvOyUJzD/GW+BoaNXJNbqEVrT3W2fKbMH?=
 =?us-ascii?Q?xkNYusJCVnX6QDZJUU7ZPvVvEb/4h8rd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OEUwKlnfHTDMIV3drK9cIgXi0g7nQA1EnoW+H35YpqYMw0T8og54rTT2Y8oE?=
 =?us-ascii?Q?tJ6HN450e46GnqZ31WnyWclP3Wjttcz5waQKq0uDju5L5wGGEGZqod4D82Tb?=
 =?us-ascii?Q?Dr7VFKlzASTBaVBBNMueFqsjoWTUPDYJBjXnVg4UQPJ+7F8PIXRddYUrvmlL?=
 =?us-ascii?Q?MCPP36V009d4iWd0lXBUdoHknxQccFGrKNyvZ1/2keThk44pa6ecKvEXIZrz?=
 =?us-ascii?Q?GObF1E7lYeDo1fw882nhHqohCWVaxhKija9yT6tAP42oITCf3c3MQFLVpyR1?=
 =?us-ascii?Q?xi2KrhamFFdT9FpfDgdgs7cBoIyjlewvKJMfXFnY1jyj2suqBqlHZBwxrggT?=
 =?us-ascii?Q?27xR9h0LVNCWhKQuw/wfI8zd1a6li6+eqkhoJJM3BCSHovDPvUC6Kx6s9FY0?=
 =?us-ascii?Q?feJI3IW8PS6UmTmOY8M7OECsA8+m+rSShdp7d1NXuLMwp7Y4h9o3czGq0395?=
 =?us-ascii?Q?Ih1GRdBQjc1p0fEGE9odMXbr9abZyzfBVNfbUJqV+rnH2EKV+XrAFrXq1I+K?=
 =?us-ascii?Q?DvgEDmIXxoMtvowKhMKt9OEARfA4YMRT2u5WkqpYHvJG5PSfivaYclc8pmO5?=
 =?us-ascii?Q?1qvO3omNBduo8ZISkaNi1MU++efRnc8fvxlFfzh32VBBdrS3ZwPwMfOOJd5C?=
 =?us-ascii?Q?0rCCbz+qSyadVkxDuJ2e919ONIH2FFsHs8lEdGjjqdrekA5jtJgVxoaq6N/0?=
 =?us-ascii?Q?lAhIoOOgx+vILlaDnmcgPg6tzYx/AI9LKPnvrXBPvQx5Y2PNR5eK37SJjA53?=
 =?us-ascii?Q?kiXSl5SWhVWsTKpLD24UZvhC8J/cHYzok4EvnUOOa1aL87DYM7C/rxo+Ix7y?=
 =?us-ascii?Q?aguU0yFLAzVbAMQPG5Fl9G/icsNyOjlZ0FYaq52dCPCI5oaUV81RA2lunkda?=
 =?us-ascii?Q?ROryLko4/Oqlll5xCNbJswZo2dteIjFjD98FYLB710j0/YOJRHH6u80YxepU?=
 =?us-ascii?Q?PtA1ciVVzNz02h4IS1BLBWhNNSQkY8X1k3dAhjvrOVTWGprArQroVgQeN4A3?=
 =?us-ascii?Q?NUCaZz9njo1AB+S6sUc6KmQrIO702NauN7J+f7JYTTPIvvqfjl9Ik+4+Kl/G?=
 =?us-ascii?Q?/kqYoN1UP9y12frvBgxRK38YLngIEMTpxtgrCaKOhny54I4ko1KoPRsrZZ2i?=
 =?us-ascii?Q?9BLELOSUWwjN6D1UKi+BPbx9oWFO3h7IQhC79GSecVEOkjlH+SHgE/rL7Jy2?=
 =?us-ascii?Q?OiLvNqGwErmO/uz9g+szP94aDpTlxRBp3VbM4e8aHDY3y2zPOy4UEwVRBpo5?=
 =?us-ascii?Q?Ug7z1ZRDnJDlNawKPJvjLUXjxApGdD5NVW8bZSLuoB1Ch6dzakvpWjgN3r+R?=
 =?us-ascii?Q?7SYgyGjIb/Dr1LgEdw6E/0IMJS89soq+egl5GB+B4Jtpi+ZUuNgFMSgdL54D?=
 =?us-ascii?Q?uM+yiGHIeIKA/pDZQMj4r9HbxianTcLPcRQX8rxlLkvGoEmGlohTI39rkOLn?=
 =?us-ascii?Q?LPGFRbfPc6LOsC82EDBV0dg4c0GZiwkSFx5x8ZyezZ8+GVq4oPWxaeh9Y3m6?=
 =?us-ascii?Q?bVpdZK5VfosWSE3DVQh/+yKSzq7oGO6u053PelPWZwlNzjKuaShMIeRb121G?=
 =?us-ascii?Q?zZ0nDDWptnNkNcWwqcD/2/t4nVx3QAQ84j23n+DtF/YyvqWD/l09w1xO6Uj/?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0WHvDd7l9aQaZiP/Lo9KVc7NfTkiO0dl4L/FCcx0GepTCVQ88NQ3Ggjr5Xb/X81Fe/GnixfYQ9K/96YCSY5b7aRMfW0FIzbfQj7rKy4r3BF/M3AnES31d5fpf/hDlBb4bnjiJpQKF1nMLbIg+ZjYCYOadQMkUCt1fUvskwOylYhcp59TRpL9ZRBCtkQM/DyupxurStrpNTIxQrs+O0jxqVnFeveyfQGV53GGYImitw9Fzpc/m0RD303iYfHzol3wHQV3MAnbxpTrbgxx0AP3JziWprRfQj9vtSfs2vsWbeSIPxLnhnLCphSfHI0isLN5vpRXQfblRTVENxTgIAEjj5TQ+ax5WtTf/K/EcGEhrmwSTZj/1ehqKdTEM1tJiUPP68yhudM4PsavuGFnPE3xQQ8UAFYP5SsIjjQkk+DlCRlYcHpYTmdlYGg8/nNELmA2JtqUbZRbw9q5ZJugYct/e8cMygID7CmHsmYSO/eOSS+o1g2zEAah9fduZGfo8b7prDM8QhdpuzZqHW733TW+ZnmtWwdWG2R8lO8O/ZOnwekybJy/U3fH5PuZoFigOaqRg1ASmnoSIw61F7GK5a4UCtkGGdMtfJSWQVlTm57VfEg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35998d07-fe53-41c9-a8b4-08de3c1b7776
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:40.0084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQXJbOnHt8LQ6AxUomMrTsbpGKi/87ogYUmbjsqXWUZjSgOuKUAnPOoNunyVuS7oV0R2YleT16vhYpY9OduzL4nSG5bXrozQU0sAWnE7JCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8049
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-GUID: YnzRJrJ1OuzV42fh2k24Zi1XlOtd7Pf6
X-Proofpoint-ORIG-GUID: YnzRJrJ1OuzV42fh2k24Zi1XlOtd7Pf6
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=69407473 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=EaYD0BI2-7KjZKhOlH0A:9 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfX2Y+vnDpfOyz6
 A4nLcuo70MhnZBbUq4cMbdYTh5PgaQ8MTcVSMCsInvhpxusL+C/LCXIlWxcGLaRyDIYEsM4DAWe
 AuhswB5rbz0zlDDj/znxPt4LciTxn114Vy4q9BHzhFfkZL+eK16kExP3EaBYHbLAzJk4/quD14x
 gyQAJEVsWckwfDC37ydLMsSxiGHP+7sszom9F0Z4OITK5bYOPOh2iTjxmP4SMpyyxCliu4pffQZ
 C5ZLaPuHcS0QF/TRxDe12wDvju77h9Lxzlw6MoDHqx/bouWIZPUfHofqsJDFceFfA5eUIrRiaUP
 1PYKEwk+sgXAzFZ+SxX8TCtXSsz4Hli5wpxwDFw22QD8aLtLdyDEsJIltJH0xCRtNfglDCZD7YI
 bHc7M1UeyuG7dAWB0lRHoktbOStif6G+rUqEyX7r4wi0jOzwPk0=
X-Rspam-User: 
X-Rspamd-Queue-Id: A09D01C0006
X-Rspamd-Server: rspam10
X-Stat-Signature: jhaox91m7qr1395jcwoh35wi36t548on
X-HE-Tag: 1765831811-817865
X-HE-Meta: U2FsdGVkX19T49DpvdFFrFALVZVRDk9gDSZCz5NBaOJAuT4uPlQkys2ZjMb/gzFjJ5MtE9SaV9E7fqg4aLGt6KZlj6mEgJ+i2t/YeDTPuK9mslR0XFig7gT87TfgNi5KFlQ8vNnFcn0iqx2mFN+dhFM9f+BbKkvTMTtQbyPBvRVoEAJt250+L02//2p/EI/dvFsILimFdDwxMtJw/NlW8udZeboAuY0pLPoYqrheESrv7VFWKiydRVrCiCJ6JUPxeUe7p0vasBe1WOYTjsOYtzDOjYKRoHViwof82ItBzrHrs+TjgDfvb1ueuLQG4+Wv7/nqGD3T7bS9zPiW0qpm9iqsJQu9ZoQtZb1tBL0jufcFvgVPAVyqGK+9OZBRWjc3aFN8+JnEewbrGImatnrvbUyqoj0O0Y86pdraT63EiSIVmZctLIPwD4t3bntgcDkFZJwoOKhF+Nwx8hoF+FuTr3Ur9KrTO7bBvpVMOtLoV7Zmfu50vkEeMqueiELQSKDqcQZRnIHhLZkngGGb62Gyy48QbpyuNzQiCGe9B8YmKe5tYZ8N7hgncJk49jczYkmmzhJ8gW/UvulvPoe3tuUIKwsxQMnmgGKjeGqRvQ9Yg2To2qSvYXZhc/vKmVPHncZGDMVZj/Qz+H+nQLDNk9190NuVckCT0VsFaOvxXjg7WpabihE21HVR9q55j0zc4HIUpmSJHcQ2X8uyzUiipeja17xabPNmPgOpb4IqQtK2OqYFeIVAWwzs7SVGCBIXQf8KYEuzrdyvudjGt8vaKl88tAWqNmsd09s8NMgXMt/5H5tWLRPFUqVOc7br15upjYyW7sjaROtLtx2l0q7tyOsTGa5jYU4fEodvp5SV6sZcTqmRFY61eqJ6M2OPDaC8OmLA/cFzSgSlgWpbbhWxOKbZa9gCWJ7ESUYi6lfUrEESkr6U6/EmLxg2Wmwc9PNdE6WCVJM0p6jqJzF+GjCQ6VU
 17esUms9
 KJTNIkA8VHKKtyya5uA8hDGBUKrH38kAwn+YTejWWK5ThW2eaQybgyMg7UEe4wurY+L4vXYa5WhboEGikJgOq8qC/YsKuf2+j3RkEWLvWPC5ynOJ3eZfh81ygHrjIjaQUgtz/k7vcWCFd3f317a18WQnAkikc1a/dEB52OnC6AyfTAREP/Ra5gIUUld73x1fE/r94pXkKLDVOn9blodi8x1QtzlvK+oP/+6X59IHk1mp41bbfCzRZbZMVi3K9gm3VMv0dksR8jyeOwaCWZl3dsvl5hcXAOvWDM5GxnaEPho/QVANd7TDlXZ0tPNbfczKROU0DHuV9sSDP+3swymPlPclvjE9wyD9zohwY7RAZcG6PERR4O7tp+4E54Gw9e2UxyArZ/6szibdvEh78TW1QYcKt8nowB8oshaMQgwRFZe9cIPKSduXAXFtKZQ8pebEgJ91riPzneh8Rk25fbzqAZOTDXEMhZtuO0UIhbWRraXG8Vk29vFiIAQW8kFO6BInNw68s8K66s++zMq3EZ+75p3S3AqjMVXSo5wK4MnN8Yn3etmePqeTGy4UPPyoT+Y/ApwNOct/nHBd3WMF9zbAP5/reOtGtnLZfM6VH8UrKEw6Odw8311B0P0lvzTTQELfwQb4r7t5kl5HwLgxF/mKfvAw10cESnGHdJllCjSEAk50FtoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() does straight zeroing without caring about
temporal locality for caches.

This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
algorithm into a separate function") where we cleared a page at a
time converging to the faulting page from the left and the right.

To retain limited temporal locality, split the clearing in three
parts: the faulting page and its immediate neighbourhood, and, the
remaining regions on the left and the right. The local neighbourhood
will be cleared last.
Do this only when zeroing small folios (< MAX_ORDER_NR_PAGES) since
there isn't much expectation of cache locality for large folios.

Performance
===

AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
  memory=2.2 TB, L1d= 16K/thread, L2=512K/thread, L3=2MB/thread)

anon-w-seq (vm-scalability):
                            stime                  utime

  page-at-a-time      1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
  contiguous clearing 1602.86 ( +- 3.00% )     970.75 ( +- 4.68% )
  neighbourhood-last  1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )

Both stime and utime respond in expected ways. stime drops for both
contiguous clearing (-3.14%) and neighbourhood-last (-1.46%)
approaches. However, utime increases for both contiguous clearing
(+19.7%) and neighbourhood-last (+9.28%).

In part this is because anon-w-seq runs with 384 processes zeroing
anonymously mapped memory which they then access sequentially. As
such this is likely an uncommon pattern where the memory bandwidth
is saturated while also being cache limited because we access the
entire region.

Kernel make workload (make -j 12 bzImage):

                            stime                  utime

  page-at-a-time       138.16 ( +- 0.31% )    1015.11 ( +- 0.05% )
  contiguous clearing  133.42 ( +- 0.90% )    1013.49 ( +- 0.05% )
  neighbourhood-last   131.20 ( +- 0.76% )    1011.36 ( +- 0.07% )

For make the utime stays relatively flat with an up to 4.9% improvement
in the stime.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/memory.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 974c48db6089..d22348b95227 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7268,13 +7268,53 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
  * @addr_hint: The address accessed by the user or the base address.
  *
  * Uses architectural support to clear page ranges.
+ *
+ * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
+ * pages in the immediate locality of the faulting page, and its left, right
+ * regions; the local neighbourhood is cleared last in order to keep cache
+ * lines of the faulting region hot.
+ *
+ * For larger folios we assume that there is no expectation of cache locality
+ * and just do a straight zero.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
 	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
+	const int width = 2; /* number of pages cleared last on either side */
+	struct range r[3];
+	int i;
 
-	clear_contig_highpages(folio_page(folio, 0),
-				base_addr, folio_nr_pages(folio));
+	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
+		clear_contig_highpages(folio_page(folio, 0),
+				       base_addr, folio_nr_pages(folio));
+		return;
+	}
+
+	/*
+	 * Faulting page and its immediate neighbourhood. Cleared at the end to
+	 * ensure it sticks around in the cache.
+	 */
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
+
+	/* Region to the left of the fault */
+	r[1] = DEFINE_RANGE(pg.start,
+			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
+
+	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
+			    pg.end);
+
+	for (i = 0; i <= 2; i++) {
+		unsigned int npages = range_len(&r[i]);
+		struct page *page = folio_page(folio, r[i].start);
+		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
+
+		if (npages > 0)
+			clear_contig_highpages(page, addr, npages);
+	}
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.31.1


