Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD943D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 05:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155F06B0005; Tue, 16 Dec 2025 00:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146456B0089; Tue, 16 Dec 2025 00:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003926B008A; Tue, 16 Dec 2025 00:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2BDA6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:04:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C8AF13B0A9
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:04:37 +0000 (UTC)
X-FDA: 84224143794.01.329F451
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27203140008
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:04:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ERHcGx1U;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lbyASqJu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765861474; a=rsa-sha256;
	cv=pass;
	b=haj5VmYcxse8WLzwDLgTZnl1frKpEEEYY/E8WggTyjnqCOv/5scGGn0JIaKQFrst7c14ku
	GOg1yKjzqREZp6FcqIYVVUwKjjMo5RCHuc5vn9bWwaMLLS/Ej664UH325ow9m2h7tOAAci
	Ze3enwrq7tYR34z2tHKHrpoUoCvoTBc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ERHcGx1U;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lbyASqJu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765861474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gTwEOfQ6UmTo6Ydqir2/JRWBmyy14tThkg74KzmxZU=;
	b=TSJ47halbjZoyjMrwfCvFUwRNVIeog4x3oH7gEHia6C//YGbKq8ZmBbF81hzeYHvRiHCuN
	FjD1r0IsiSMzMS6rULfng9whneB2Vocbq4Afs3jNEWAMDyVtGw/JxRSreWwys+JZxRQucN
	06n/gHPrk/Iu+jfGoEvwCk3D0By3w2M=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BG1gP273705724;
	Tue, 16 Dec 2025 05:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/gTwEOfQ6UmTo6Ydqi
	r2/JRWBmyy14tThkg74KzmxZU=; b=ERHcGx1UDHqJoGNFMtywsILcewmPB2MA4D
	CaHb2+eUWtOlqCSIwlxI0aF/f53E/P9Akc4hWoaYURdTaeKlLQo1ehPTk4HRzgvY
	3BxHlVLSXnQlfkHijT4fSRraZDw+xaK3py70F7JqBtspBE8WuXvGnvOWEM1JzzXL
	W/38qenAAuqttio/t3V3AjB6FBlIXOwUc2MXcPZHeIJBo4YgdiASAilSjVBhrWVu
	cuZ+RxvxSNWzJszvui4BVSEb661g2QPnMJIKiIthDa/WCXl9P0myYMMajYnNbQ+9
	45v+KB9p6kr1UKOGnNGsHeVOpQI0/By+5+6E3kjYDvVefc68URYQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b106cba46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 05:04:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BG3sEh6005866;
	Tue, 16 Dec 2025 05:04:07 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011067.outbound.protection.outlook.com [40.93.194.67])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkcsynw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 05:04:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nLs2wlt1uqc0zmiOVkoNwC9Jq+453dyvBCVXXBAsBoHpHxgk8W2DTDZGcbdSR91cPHNTsRm0nypUNVLMfLM8O4VkjPhvyuLXwAtQWeAnHDhwZAUIJvFfcn8RvQg0jjUgYQtOACCLEuL+bO1qIGLxibZXib2NLaDnrC6tPtN2HD0bJzFH3IzkpLCerDxxMEnedJ8QxorirqyWdU6u4E53VvLoO9KqNknQqZfQh4hOFTZkZZcQw+SVLliWN3TqNPPsi2FpKKij/9AYWtNDRe6unkGNgvd13qtwiVP7bLy3td9aTKMsY+qn3aa8KMPE3Xlb5Uhe4lS950HQ8WmxmYUPTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gTwEOfQ6UmTo6Ydqir2/JRWBmyy14tThkg74KzmxZU=;
 b=B0qtSY4+viS1YgXYoccn1AN4oh2V0XgLQ/8lvrHuDLxf79SNFj02YPSHW8ebCQ7miCsJCcIkf2AwwbZGxoDkicL1NvazB+6uS/cDOvfr2NEHU+sXCfg9sIQUoj6ynIDKzBElTpa9CNYHsPqsQZ4cRmqmsSypn53Kn5bBx3xvGvOpjaiq2Q91CsC3nsgPbX0KoXWLT02KE6LHPO7vQvs/MSvOy724h/vWqZIgdi8kN8b4Lor4cEzOTYSLHGEEH31PJ+LqCPIj/Gu8ICj2Tr7OqLRpV9xZY6yyPY8Sq+zvs0lQd+sFEa/9bclJQtii0/PMiIVE64MUkibsdcsNKBRqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gTwEOfQ6UmTo6Ydqir2/JRWBmyy14tThkg74KzmxZU=;
 b=lbyASqJuWKrCA1R4SxJA3DzK+y4N4ENy8ChxxwZtxzl2W4j4WZNWd+4TOqd/z+D76TNkQmigzpYHbuwyf0D3PC5/6P4YmNj8zqu03F5wXKcNZrQSk+JVXVJBcYDSHW91TDtjNlBch5vImm2OiJ3KHOea2t1Nr82B7acTsY6g+PM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CY5PR10MB5916.namprd10.prod.outlook.com (2603:10b6:930:2c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 05:04:04 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 05:04:04 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215184836.8c003ad094e8bd6bdb96f478@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v10 0/8] mm: folio_zero_user: clear contiguous pages
In-reply-to: <20251215184836.8c003ad094e8bd6bdb96f478@linux-foundation.org>
Date: Mon, 15 Dec 2025 21:04:03 -0800
Message-ID: <87ldj3f264.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:303:8e::27) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CY5PR10MB5916:EE_
X-MS-Office365-Filtering-Correlation-Id: 209ee1ba-234d-41c8-af5f-08de3c6088e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oNZDoC8ocvGBtZqmFOSUbcw8CUUM/XhZGZy8HWfMf9HK6PQJ2DRdfVzixT7d?=
 =?us-ascii?Q?nJ4SgXUsAKpxLhfLVzrLn6F0Sj3nGqymX3LCmobguUndpu+zBqIshOeIEqz5?=
 =?us-ascii?Q?orTPngvrGBSUOhcrewqmzs37jZ6VmGl0K1rAAOuN1PD9Zv4DOJymyq0zxo2k?=
 =?us-ascii?Q?pfxs7IcaYfgmVGKt0PrnJoQRKRInANPYUPhZ3GpplM15xFyOqjVpQ/vWdkP9?=
 =?us-ascii?Q?IESuuq7n9yk1SlCwmE+Dh3jsvidyctzJE0Ku+rUvxdfnM4dVzKgLTzIo76Dk?=
 =?us-ascii?Q?Kny51+NMdFcJnTaV4GfXuZ5eNCOmWykSkV2XsMT+qKgwu0SWjOFreNYMkjw8?=
 =?us-ascii?Q?WjWLXyNY24xVw+8qGTS0t8QWAWAKsATdIyu07R9XapOnSCBTxBVxgTprshqx?=
 =?us-ascii?Q?5jbHtwtFW+3k3q8+8DLePCzgP1lXhqS8wJNJpwaKncEXDdYjfI07/ZOG31LE?=
 =?us-ascii?Q?HG8BaQicnbOPuGTk1qKDsetW7Hpwn2cuUrcP2sTG42VIDvrbJwWlZjNKKNk6?=
 =?us-ascii?Q?jDwBnp9t3BMIVZrcVvmwb3+JPXml6aT0zMEtqFUZgfrkJpWBzrszeRyqYccI?=
 =?us-ascii?Q?nDMcNypQxvbB9KrVGcjbQSLY1jLeEXIfBTKSXMUrtP2EDbZDom4YehKqNt84?=
 =?us-ascii?Q?pQHlLgUPdqrObMSC79Fo8PWnr8rTSE1iaHkXrsDaq8NuoE86rQD6mq8S37H+?=
 =?us-ascii?Q?OFa+FmoRllx5LlF78SCHXZqQXyKF62rW3qzVumqE9A9t1XqekGc81On8YKG1?=
 =?us-ascii?Q?XJD/mnUeWOZu8/PInFMx1uiNqNEwEnwPd3Dlqn3ozEXFgm7lkbq42ip4n93R?=
 =?us-ascii?Q?ZziL8nnAYGoCHPZ8SsyZ1SnJ7FaDXmksBrRejWbp97v0+DBM1d+Lg07OpYNd?=
 =?us-ascii?Q?2kPcGYJH3uOQ3FKa0RCfoxDBTnxw8o79XrKiq35MGtwLx322Kv5dDINNCQkR?=
 =?us-ascii?Q?w9z9J00i5koS1cVFu66wb4EYgBeCFWv1LSJ80yk6DKb6Lp1HVbDTaHtF6Jye?=
 =?us-ascii?Q?aMzl77mZRhRdpzYCnnctEB6VHu63bL0Hy1c3AUmb8NaPm/d/Qc7aJqNGSZ12?=
 =?us-ascii?Q?/DVBTh15QuPmQTotYcHAOUNY3D3tFFrw8YI8+ty3NDoU1ZOaIwiRP+PTpKWW?=
 =?us-ascii?Q?J7Jk5wlW2LjQEgZjsktjybiBxFNBjYNOQMr5dcM1iPAtAyMZ27lIHYUodkrY?=
 =?us-ascii?Q?p6zi3nWmjxeDqMVhrbQ6MkGTMkn4SgYRQrPUopXa+QhmdETlePQ+jrP2oDQ6?=
 =?us-ascii?Q?SX4492Kl1CA1lNvNFeaSNBoLvoCBbqKRTBCQsmcPzYHHEyYcF2pF4erRaO2p?=
 =?us-ascii?Q?c2D/fpuCTqYThvUz/v0hhnNaT1ybncoqjcju/6aLHj3obN8941+Hg6cB4fTz?=
 =?us-ascii?Q?6XbXDP/YYZywwivdWB2x6hW1LUPAekIIEMfjfSin7VzP3SL5KmCY1fhJzUaY?=
 =?us-ascii?Q?v8XtEyvNB2cn08lACjpXheV9VnzEPeXt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wNabavIdPZ/pDTbUlOl49WYxye/Wb75ZHUkV5KdaGH221sAGKuWdtGLuqbZF?=
 =?us-ascii?Q?lANy4631uQ0tn7N0hFJI7g7ILWD0/tNBwW/n4D5jh4fG4IHtxV3ADt0I75Xy?=
 =?us-ascii?Q?3loajcuFgcspJGMTPwDC3z5uFOk1pXw3fB12/a3vENiXBEZh77PfPFqXcCL1?=
 =?us-ascii?Q?u0HRHZemMzEujFcIQb+MVyte7lkRU28ntMJg5j12+MpGUEz4XJ8M2GPqopMr?=
 =?us-ascii?Q?dlDwiaWK3aHXMfNEsk4btCYEuEjIqSODbxjZg5Yz325U990o62EmHNXMzNo9?=
 =?us-ascii?Q?lNcBEDAcoxSkdcUlpPT9OUnCMXNvtXpzjhxiq7oW5Jjq8ckvRkHfnc1OMRBX?=
 =?us-ascii?Q?V3+OhCpYpvpsmwPE+jiCd4t3CpJd0VhzDYA3p8Qfu7JlGGh3CPTUZW5ZQqgJ?=
 =?us-ascii?Q?0UdjOVOWlAky6pTRWOXo8StoH6ChhZCc4IdESo3jrKtATZw8ryuap70Xf8Op?=
 =?us-ascii?Q?Cs1ILmIVfAmJW3upBWXFY2kRcAUNlHoVGDSt6eSB+p8twAx2au7/qOJimn/N?=
 =?us-ascii?Q?nNUIlLicIs3VqHPmzX31FNsYH2DiJJK4X63rSiBOznk80oBGUyACtcLtRO7M?=
 =?us-ascii?Q?hWDKK3cCo+PY6jr8lwauV0ecakyIoU5FVGH3ySGGH/SV0CVNgV8PCTuHFFZV?=
 =?us-ascii?Q?m9SK/VXpAREOHv0hWyCafG9BQVzumD/Rqy3i+mdLjjIHzoyO7px75erFmqG9?=
 =?us-ascii?Q?3KQTagebfCB3b4uiqzu8D2HcG1UfTC/KNYhaOySqf+hzq7g8Wp4y8/1GMxrh?=
 =?us-ascii?Q?d57qRTTtaCjMZjFCiyId/HxWX+//ExZoBlLzF5sBovhx4yx+dZXbtePbJB+K?=
 =?us-ascii?Q?DTUL3p7V7lR/CKxSy6Fk66rN4qdhoXAhGVa6hWmQCqIJKnpRO5rV1ylr9RnX?=
 =?us-ascii?Q?M1lgpv+zc95c4R5IlkxeaNuppaby70l0cOx+xE6ReRgkPvkC3bPc5mRQaZlv?=
 =?us-ascii?Q?m2od9ZZLpaaVE/9AP1uW8kmbpFOaeMvS5ks/KsILdSZoAf7Rvcq6MjtNY9De?=
 =?us-ascii?Q?D46wn2kUKCdKVzVLWEwzLLZIwylVHCyqLJn6hC5qwX8/7D+zCd4/+LkOtLAk?=
 =?us-ascii?Q?IAF7L4kupzSk7al4W9tM8cSwzjKcKZ+q2uhKTr1rf+vr5/AgAi9WMtSjQlIv?=
 =?us-ascii?Q?j7dT8g2DtbL9BHsd+RQ0/Qq0SHuBVn5HtKQbGfVMokscjI9Bx+IO97yJGFJv?=
 =?us-ascii?Q?HgPrD6ufy4bqPE31jq4o5xgAk6mCPFQ/odVrdVKhIgPuanceBMYPz3fsawbi?=
 =?us-ascii?Q?bic9ygM2SoQUoZ5cO9qKhS/UUpq4nDV1alcQ/MhEl6FXUDsQxvYgStdyGTq4?=
 =?us-ascii?Q?we70UuWZPmKMnsHWXGs0+UucASykiCWDNOaje24rFeP+rPXZJTYD4fX0kIRU?=
 =?us-ascii?Q?TrG09Y5gd7GCL1gExmwJVr0vHE2ENkAGmK2uEszibun/irgetiIHqRzXs2xT?=
 =?us-ascii?Q?wFUBAz/0Rjk2NE0OnS5bJZXmpv8kfikqrotvR5ycE3eRviIvz2Smo1sC3ccT?=
 =?us-ascii?Q?+IWJomFysfAs+jh3jtB24vWGpYoSrY0fDQoy6D89jUsEKPzSS+E3Ro7OKNUF?=
 =?us-ascii?Q?VYQcFlZmKv+rbPlhIxHOEnlNsxYXHG1lPYeV2LgGQJp3NYeeBojJ8aZ3jLvs?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rsbh5r3vFKm2oYagakA9TgPlRs3dT4XW//GIITRAMfaJC6zm5eHTb7gGblDFCqUfbYroG6c6ykVNPI/7vw5xF3Ic/z2IlWV0YQhPZJ9wQfuiq9N+jBlrQXOad/q2dHcgj1RFgC8ma4fc02ADiwEkhGWkEodHayFU9T/Qx70ukLZ+8TnY6iVSumt4g4CaxueO6Xx633QOQacXYdFV1oKuIGfnf0Tn/zwZiJ2X4Z6JwmH32gcbRzDL9/bKKNKZH1UEuytA672pubzwczoqNJyLjgN9JbtC/UR3/jjJhjuCv/Pbz5lF5i9KZWBOauaR87YjlF5WjAngupLVSTebHTfX/ZZfsUVr7AhTipvTXo/OKlmmcqosSsrN6V/cGNkVoCKKjdotW3ui1OUHu35nbOpktIShq34eFykeifYOKXH8oQGk4YfIooMYJse6PPqT7qsxPcA5EWJyYRLeRX8JXk3KhBusH3PFdG/vApd95ybY+b8+ugRxAnvo2erdBAgoqRqttA7CrCrPSFidb714BOLD3MpImCju4ZRghSYqfVb9lDI/lRoP6cV/a33n/KelItsNbkzwb7hFKI0z2tN0mXjZPpc2fVC34mNK/9qkF3/VDcA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 209ee1ba-234d-41c8-af5f-08de3c6088e6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 05:04:04.5397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FAxHjd0ygDE56T6Dw56ozIlzOOwLiWtrOKQPUkEX7O2Vjg7yndbo0qdliBLSkNFV+m4yBq7LXurJ3VOurcx4bf9zRNWNzCnCZgWQ34TuSnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5916
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_01,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160039
X-Proofpoint-ORIG-GUID: zuxQzW4KDYjqac7XGZvGF2RVIZJVEOPb
X-Proofpoint-GUID: zuxQzW4KDYjqac7XGZvGF2RVIZJVEOPb
X-Authority-Analysis: v=2.4 cv=et/SD4pX c=1 sm=1 tr=0 ts=6940e848 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8
 a=id2N7YtYu7FlYvKohpUA:9 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDAzOSBTYWx0ZWRfX2+Ee1UNTaOOw
 1N1O0eGtoeDCq5YVxlB0EJLG+/Akhe30LRErj1fOPlrlPUA+4j/QkCXB0QfDc90vwh3TDgg+Moy
 xvVIJ4N9YcuIT5ojKMkaVWZ4pd5o6s21bHJxG4jPxnCI/jpo+x6IuSv5ipzIEmmNygeD/O4hs+4
 Vg+avLzY0Za8RsKjnMeiUTjyvr30x1V4/2m5H0Pl4UA1r2A/SygUuo5gFhcNmh3zhYKhJeoEPni
 pW3odSS3T9TRUE3Iz0+79jrO3Il2lJrSnDfSdLY7u0SbI9DRAIB86m+dSN7PmmUkscN+OFUd6Q1
 hYQN+rcEJpGwL0E+paQhvknKJJAQt2Ia/s9l2h9GVl5uQncTaFjVdGyf0dcpYoXAzoxtMWlz9KH
 v9SKMq+iZpNbtfd8sgUgirR78Cbd2k/09qh+CJNftCEpO0N+42w=
X-Rspam-User: 
X-Rspamd-Queue-Id: 27203140008
X-Rspamd-Server: rspam10
X-Stat-Signature: ci977s6dtoarg81gqhh4kjd5gnnrf33f
X-HE-Tag: 1765861474-557681
X-HE-Meta: U2FsdGVkX1+dUttZFHdZbeWE1I5xQL1+oUk3IVbWcSzeJn1KVIvCAhv7EQfCTW1ytrcoFina4wo6QNK9+tXYUCtExzPeQismCe1CfrojNFGbIaYXJC9rN+i9Q7x0h28DNpD4vVeck/8GlzY/celhXv8TGM9+WvKgcQhWGYqtetefyOP07TPbOq+gK5rr2EiGulZX4lZ6L2zDqGwpHJwv6J6Oh5xIoByagUrZYo1FyywD8OOlKUS7VNl71CNUYNj3FEeLBW7Hk0DWX77UHB1/kgdpzLlGiZ47spfhAhTBf2ZN6P2JS23oxgBhv+LvdjdzMRy8MIFVP/gQRalTOdVFc0TJHSsyVU03OyTRGeOykvyh5WDnv01QPeKWA+YrGoiGaoB4iNE+c5uLzMjJedEiDU0Nw+giZ+bbuJoqWCstXmz7J7Daw9dIC6/7uowPKuxcL24uB0bGPDn542Oqjj6hsKlx3l/IwyRxzCcodJrLj3mVTikAs2O6o2m4zZ38us04rfr9oRJ4ACmIyZ4qIm69mNkBlBKyQ3TUXM03gRXeSXfeZjZwl68uZGNdAO+0n21fZu+FAVxdOeAFDnzIrWhLf834U4yEMpLNGQlQYunSn7HebaBTjk6m+RBOjxJO7tJOBgQu4TNgf+veWGSTlo6NhU/kq+hOJGt+Prdt6fY+r4SUiNU5zOZjlV1jD6uvCsv6IvNk9YSpadQQyPZ9//oJxjBedT1k/zyn9ioxNr30ASzvTBfr5JzxmrLAsRU9lCi125+Jard4KsoFfB/hk3IC4xYNWlidAgtt+3ySq83tQrV+ZF0NI/MmWmvbhkjLOtl+PO2HvIkwonilqLAX9sIjAmq09uzbCL3s6FKZoo8FNNKJSdEZdNVXEqy01KkmN551YVzF1Iqj9RrYLWLSwb80s0szZszd/AazyVawRPAchbyk101bBMB3uDcEJfLbW2tYpenH1VIBbUVZxJqMSO1
 Nliklohj
 0mXfaAx1kznfx7JKY1zcwK5BvomH4dcYUm+gieMnUnYLkfNb57RFGCyzg3GUt6XgskvWRbU/3aShQRcMOnr4kje0SJTCVs4xbVINXfb0PKh9FUimsHquqaLTSarmLr9OoC5QwQcsO6pnfFIUpA966olH/fE2OTtnIGUz5PxknpQhTEqCK5nV7HkJNqPxUZqQI85H/BRQ5DmvbgK8cm3ec6wuQqy2N8zuAf84C+u8ju50HUZa8AaahyQKU/dhh8pMeVf2xgmvy5FOWLfOW8OCSyA+gnUxpCf36PI8qlnmI5eid2kPeBrkdm8VQhtEbzyzkwP72Q7xlPk7c6VRKBB6kFxNIOhBOC84hTevZE8DzvA0pjBbxmZhn/HJjWsgcT+zNRMX2XQv6eQzhZNGnnij3ZvWnEll1PUXtyykkR1xMqV9pynb7j0s2tzIgt+CZr8Tcaf+5gOFQy8D3QcJpxG9HJXh+uX9nOC8RxJcFTTZI9/CM4hkxnvXUL+LSw4lHLVrimEb4+OM2qebduRr0j+N5Firy6uO2QxqSUikSW14Yggrv7BcQsHbdFJT58fEmOLERCG87YraHDbAo2pzZWYemFZ7JrkZK8T3YvUe2b3v3SJEpNZGHwjLPk+rR1+DIE/kWQyMrePOX+blAx4eVjaj4/xsE8zJM2ISyBMcSwlT/j2d0b22u0QvyDehediWIt9xkcgTUneKufLEtilg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 15 Dec 2025 12:49:14 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>> This series adds clearing of contiguous page ranges for hugepages.
>>
>
> Review is a bit thin at this time but it's at v10 and seems a thing we
> want to push ahead with.

I think David Hildebrand has looked at all the HIGHMEM patches quite closely
(though, not this iteration where I reorganized things a bit.)

> So I'll add this to mm.git's mm-new branch for testing.  I expect a few
> days after that I'll quietly move it into the mm-unstable branch where
> it will receive linux-next exposure.  Further progress into mm.git's
> non-rebasing for-next-merge-window mm-stable branch will depend upon
> test and review outcomes.

Sounds great. Thanks!

--
ankur

