Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CC0CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3068B8E001C; Tue,  2 Sep 2025 04:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE2D8E0015; Tue,  2 Sep 2025 04:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD0E8E001C; Tue,  2 Sep 2025 04:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07ED68E0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:17:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5B391DF37B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:09:18 +0000 (UTC)
X-FDA: 83843585196.10.A1B62E4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2B8D6C000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:09:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Dzljo0MV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jEDaEJOI;
	spf=pass (imf28.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SDUnN10pLDKpi1WX+Zwu75zuYNE7Izw92sYYpgVfcg=;
	b=KQgushm6COFQmKJP+Lrw7+sR2FPrsulZkFdvb3KBVAL+eTwOsbklVqsVIajUOw+BBpAa4D
	AOCe3fRRuCQooNjrIlcXuw0UOMu7V5s0z5+kiebm73O6grGC1gVscnBUqY+HLHAKxJ2XLA
	YqAafaZ/0SYo5zTpXnjkBy34gAlgCCE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800555; a=rsa-sha256;
	cv=pass;
	b=uaznRY2pLTTaBcqQdv24vNjvCWZ5INo4ck/p7GcgcBw3jwOa82zGxW9437XvRXsIpJRhAl
	652QcTOJ7V21fV4QyXv3V5uZB/hMePoHAD6Qymi4hXAHENpusM8RkqoxMwsfVUKKZUzGtC
	YbGPSyH+EepHUfBmojTITrU2Vw9z5zw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Dzljo0MV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jEDaEJOI;
	spf=pass (imf28.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826gPUb019768;
	Tue, 2 Sep 2025 08:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/SDUnN10pLDKpi1WX+Zwu75zuYNE7Izw92sYYpgVfcg=; b=
	Dzljo0MVewMLJB65yRZwv19j5JIHgjh0wSHRx6lcHxf/U+RtLFzBTXYeTcx5eqY5
	+c7IO513FOHbG6zQxK9gwFCLODaAfHYwoJY4MGNqtNATn43R+ZF8VVrpj58Qn2Q5
	Hk2oJCPkF5dTPX1AmUWQectARXH/cDczkm7nMgce6OhQSEE2oo8eX8jqu7qtyJL8
	j1RhOQMyteApuE+BJLK0f9ed8RkIAEFWHvGl8ruvgfsCy6Z6OYJmEay9I8A2mY1H
	2p2SLe7W9aF1ozJq0yq6NEHhFbXFIIzyG/NP0oKHyO+Fau2vT3LJrzwgKNIs0cXt
	jiH5YopQfld5Goz/oxmmWQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4jxgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:09:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 582810a8028674;
	Tue, 2 Sep 2025 08:08:59 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8uw86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbyIoBQoY2oDQYTwHJI7WaZk2rsNc/Yg16QfAijxHRLhGTD6w0bYvYbRSkTSNnaDwdGTt0T/S6zwBvVFmKqSZOd/6wIh2IztzbFwU9atJyAh7c+EJHq4MyZw6mEiH1W0Hz3bouTaLSWJjcbq4zkDJ35oxLb8bSfdGg1WCyjdkDWbHbAgOmKiDb0MrytJTziky0Gyi4TCxlpJs9QqEkZoLJdM16selR19c8P9LKmF0Kkd49F0AQfmpBQkHsnqYH8XWv0e6pmf4Akd0zS4La2rrY5QyaE/I0XAqpEr8a0w5asrS741TPjp2C/rEwtziO/zhLaeumpDvrosmVE0qTOcrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SDUnN10pLDKpi1WX+Zwu75zuYNE7Izw92sYYpgVfcg=;
 b=tdaRMnGQ5k64KmNKutnr+aU1x3SA//wks+5xHSiqxeHGN3cY+7KtOwIWHQjrZi89ol6C43i6zrmYwRSj2IJH+ByFVxW4JCtfiRW06DAuaI0nJmauUmiK54qCIOkcOuHf12mu2OkzKW/D7OXwZFERcwPa29N8YDjemXwOFLRIjTYTucxSELbJ8gpRnRAknB1Y05XJxRl5vJZi68e+JZCFxQu2UHdu7bZzZpaMhm29jdiXEF4tWZ27QM0W7ITK0iPA9E/Mt9rpTX5Ze/73v2GsdYw4lWybIxkgascpEpdh9pGS4EuxVzVcD3VsUl7Epx+xaa8WOVtOewPBj3uLQ9r1bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SDUnN10pLDKpi1WX+Zwu75zuYNE7Izw92sYYpgVfcg=;
 b=jEDaEJOItDZSk9QNvgw99gprlWhLDeR6UEtYRcdSRs/AjVFwbvIyj28VUYVHCeq8N7fsmHFNRA9XMD2dc8X1WfNIuEWbYH0mjKLJ4Pom1ze3CmHSw2nQTT4sRqjxcsXRDAI997PRVWFFXgLsRpZqWngLJdJ+jrjr/rGQYjIzypU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS4PPF6ABE13187.namprd10.prod.outlook.com (2603:10b6:f:fc00::d24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Tue, 2 Sep
 2025 08:08:54 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:54 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 15/15] x86/clear_pages: Support clearing of page-extents
Date: Tue,  2 Sep 2025 01:08:16 -0700
Message-Id: <20250902080816.3715913-16-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:303:b7::26) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS4PPF6ABE13187:EE_
X-MS-Office365-Filtering-Correlation-Id: 00da0ffa-2f60-40fb-8ad7-08dde9f7f5cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C0woRDkzW7tuEdr1lbvcFe09zaXePH9pZMvwtZKwdib69k1vHz/6Cuw5wGIf?=
 =?us-ascii?Q?elrNhJZDohq1jcfq8yKKadT0iuHg7s1YaHHLuXXsolYWY7vsSqmqtrROY2vz?=
 =?us-ascii?Q?MyF/TZQKYAHGcLF+uCktJc2wnTo+z5/9d2oY4T2x+wSt1BPFD6IiP9/LybzE?=
 =?us-ascii?Q?kIgp3hNCZqLoiFgqd+VnGDsdgsz4lSFBF8So6hy0WiuM7IcoucZTCqD63fj4?=
 =?us-ascii?Q?m41DxYwPFXQWrtnWvPVsgey1sSwbK+y928a/FqEeHryYVQzuW/Jbbbo90K60?=
 =?us-ascii?Q?VusrllDYrsLoQ4RhWLOmz2JKjQldpgn56AJe4UN+ai2O7aeizmGntcE9aGLl?=
 =?us-ascii?Q?LlrG/bhwtMbEf3aeUeSuEX0pr+KYxfqzR/nnE2DmpACr6uibbozjtW5k8dar?=
 =?us-ascii?Q?I4NZRscKVBCGU8ejJh5NSPhkSQ+DHAIngtF9IWBWO00SVFpu0DZO4m78PVWJ?=
 =?us-ascii?Q?sHdo2FHZ2YJU+KUGlS5e/Tc0Z+Vq7doCcWvEWs3RgV2MRF9IOPV+L0TDSjdy?=
 =?us-ascii?Q?tiRcHzHqJyaibG/lQXeplvLytfS/P9wBZR0GP+IiH1Hv0a/z+pkNVyIq4EAw?=
 =?us-ascii?Q?5vEcNoNHkQaRJ1ZVGdLJaeRo0S9w4+Q69YDYmn52dmMGJNaK/nFpYijerfVc?=
 =?us-ascii?Q?ZtXELRzrvw/HLiV5xzkevSIBe4A3Ymydi2F5Rtx4Qkl8awHkz9XwkrKJdAos?=
 =?us-ascii?Q?OEphTQ5uNWDBurHXbg9T9D+0sii8ed1UJlZvnNtaq2S9p7qbbb39raEC7dSx?=
 =?us-ascii?Q?Cn+DSZ2Cq/WV0FMYN0t2VfGYS7i0jIcBb4lsQXyHSwgRXwPW8nKHsaAFFwmL?=
 =?us-ascii?Q?sfsi39b6VicHBi1tH9Ts0yF2b6wzMmmmtQcyGktocb5aZAluTUagC4IChE8M?=
 =?us-ascii?Q?uMmms04NUd5FbMueS8N1rIfAPt1s3GfWHhY1SnWo1UxcborFW+dBW1cpF8DD?=
 =?us-ascii?Q?xE9osa3sk9ud0WfszF7fIRJa59syYGAlwwYpltUnNNURMGqlqpXKqvyMsZOE?=
 =?us-ascii?Q?V3rSzNaJ5goskrVhNh59S1NYcXlkI6u+JaT0CUvFU2mEUYsTgXCEVTTulhmp?=
 =?us-ascii?Q?yfA4hWaqfz39ALtG6GueEBjTv3OyjhVmPWupdPziSQQmGi+OXcwdNfkke/JO?=
 =?us-ascii?Q?WHdgxCG9GShBAE+pvm8Ufameyylhs90dyufhR2jvmuOXjdSOuHrWZv8eJ8rC?=
 =?us-ascii?Q?L+A7Ym0A9ak2RAWW3SBeA++u/cb0ANpefjTnUM6R25zFS/JXjwyb9sTtejXq?=
 =?us-ascii?Q?8IZ/RdpCHQphRiuBiKRlCmlkJGZAJ+BpmgqV14Vji8oixi4jnMYTvrOytROY?=
 =?us-ascii?Q?Qsq4Yjm/TmQ2SRhfTK6jSOayyR89aobvg8FjaSXQv5I8snFBgMK93a55Ij37?=
 =?us-ascii?Q?zrnjw0dntpytxaO26HvMFlCYE6NAHA33GIuyvQPgHEni9aQ45Z0yFbykixIi?=
 =?us-ascii?Q?oi6474B8GlI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nw1bzoxFiPc+lRAZSC/BrgSh51B6QTI/UAd4VEW94AGgayMMa5uBlvyXxQyZ?=
 =?us-ascii?Q?YydRz0Kssws9z0nFvEoAP3PVdWtmLjxlYVLJ/+pxLYQrn55vW2eSf4Nx3hWU?=
 =?us-ascii?Q?W+Avwqhr6/W7O6MhawKul45a6GRz8HZMBX5VYVYanj17Vxq8bsJWryylqh0Q?=
 =?us-ascii?Q?kIgfCR+MCdg2r15/yCdTGiEL3SOD8/v2IlSLE5+WZxG3YLaTrSLGPGU5W9Pm?=
 =?us-ascii?Q?IdPjKyTg1umAi0ZZGoBVCUWtYjFbTKhkdfqcYiNSOXhcwCthOWofbzxerNrC?=
 =?us-ascii?Q?mTEPDTva2XirYmqmnw3EUliIqzg2+ankoRQPzeQK2VJXAqR6iO6uIYe/Ajwg?=
 =?us-ascii?Q?RsMKhP4ZG6vpqtTV91U8B5c8kZ70b8doA/fXHmwSgy1pWK/vne2QpANCGFf1?=
 =?us-ascii?Q?Mu70zNN+84AEOS8uXD4K5QNoW7CsdmCE/HC9pC+KG1VPpR6Yn9cebx9dzxqy?=
 =?us-ascii?Q?G29taIMo14TwmnWmJBCJoaBwKvtlYbheDW2yl2FkIEX8FM70493JLVQc1y7E?=
 =?us-ascii?Q?eod6HnDzIpPZsvOP3syZAuR68OckESrhbLpcP8yAZTec17UTfRGAQ4rO/3kn?=
 =?us-ascii?Q?cVgq+bDl+uhe82/I2CNinmXfFb5ZWC8XGdWI6Llloo/Poa5vLFt9koVNrRo7?=
 =?us-ascii?Q?j+hl6akxu5/1U7xtfj0QxMizkeMuPSVcf6e+uSHchVbxPKFgnEQ7dUudUB7w?=
 =?us-ascii?Q?jkYB5ED3vYh0gsXzISi0PzC7KwmEG6dFc1uxut1FZV/JVLco6icmnnAwYfVw?=
 =?us-ascii?Q?bdl9evkCljTF8fA5aYfIonJooldEbIB1fQM4/dUkkhl3ioyCGCqbwGAc5ygq?=
 =?us-ascii?Q?DgDtNl13mFsNmGDqgqFuTMaTsP6FMgZ/WxbeJLbKdISQRmHz7EjYNQ5hr4vK?=
 =?us-ascii?Q?0i5/WrjgwpvojzPfQlxBSJWcUdB0MRr3ofMB6SaD2ezGx4IJcvjMLt0FBLeP?=
 =?us-ascii?Q?wOqDdDQLP+cJJ7qumKidalCJp8YDaKqGiwoW/+8n4LqswGUHZ8ywanPc/rkV?=
 =?us-ascii?Q?Zid12RrkYl7Qwbz0ubxh4veQAqpZgXV+4Ti4Ak1o7WCnBHy1Sl4GG6/hIEV0?=
 =?us-ascii?Q?7RGoW2ggxfse3o8e2Pw8GEEoUy1vas0HvWi/M2z+PBaXLgWtnmnWIOgIB14I?=
 =?us-ascii?Q?ykMRH7WD5htkdrNuCy7EpSlpEq/hT/pB0j3NT1fxzHXwNWd5mZTTurBrG+2r?=
 =?us-ascii?Q?snnmrXRgJTc4hs2JfRGL+D3U2MJavwpdQZG/FEpHbzHFIUl1S0LhHgaksawi?=
 =?us-ascii?Q?Z4a2vsZ99Ts0W5IOSq1X73Ngvb2zJsRDUQ5nOQru94403m9F7Qnblgy7Pfbx?=
 =?us-ascii?Q?ArekrK2R0U9QcWB8TfJ85krIzHdP7JzNjqt9Qo3zJyvkvWp9ba4fSA3S5cRy?=
 =?us-ascii?Q?EEmDWpLRwbEZEu7WbIIBAkieFq3RQYPRGwkVapqhR/YMXi57RC6orfCK57S9?=
 =?us-ascii?Q?3JYPgCq43/LtIitUl6hEYM5nJ/ofDVE7T1s9GT1kTql/2JLK7asm8nGK4IHF?=
 =?us-ascii?Q?jQqo8x0NP5FV7YDdiGM1PS2PqGz76+bPsZHlVA1PMWmLfgSGe1rbYj8zy5NM?=
 =?us-ascii?Q?zSgccvAw7AMTVk0mM5NwHMxY0HePVZyAY17je28yeYfslR5TSLiHIaLWTT4F?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n64XDj7hxCXzcmyNJKxBG8NggtDgFIvrNU49LGIrUM3P7NmnYN11CBOarsaLqdAgIEXmEtROPWjOg5/qbwoeizE2aQTwahI91bZSg/vLgeRAAme+ax+RpuRzieznQna2r5OeVzpfvV4fBv0D0apgauf/X9EDEAePdhWgfxbnX95twyBRCZOa6Ezeq3VeVHKCJluzF0V6tIsaYx+wYA4+ojEV6JyVpPuYLmPUfxWpqdXE0pJ1D0flMTj1p6PhsQENjAUwgKRhIQi/5IIaOxRvcd8bZicDZbqF3b1MLt3wo7cOxZEvSp5I69zxcBgsKdU06f4opcaJPT+smcRosEa/WepqhqSX7JxVdcYZRNe9raX8TReij2/CQ1ia7bJmN8xtDBlCBbyY8kyxi8nXkgBM6NrRwf0lqSMNpWw/sEa5pFY7wvQRA37seEohDq+fnMNKRCkDgaokBM0ppmaYTzDrqPcit5bduyDEkW+bv4kA//dUCBkaZXArjbBFltVwfwCLetUW1eVm3fC4IOgDNc3Yk4mwf8nQ0EDaOCDjTNggqjVUC5A0Ef+NUXxIRhWU9Ws3TbiG4+Zixzj8oGIVwsCy0S6iFdmB1HJFqHBiBi3oEsw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00da0ffa-2f60-40fb-8ad7-08dde9f7f5cd
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:54.8112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vM4o88URVqkA94XV+PW+3WxPxntRTA1b57lBJELYvcnPSqn7rtwxWMhHhkSpdB0lFuBW0rWFjQl5SqFJPYbgkgGT9XnUOtl3D3HsDcAityI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF6ABE13187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509020081
X-Proofpoint-ORIG-GUID: cY0tpaR6tQPSuRoItYy39pVprl-d9CZG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfXxIRwJvmQLps3
 7WQ69+0HNFqXmDl5nqFZypcYE2LXf4q3zUhwKWEhV+5Pqc2fXtBqbzJKW4vcp26SqbY4rJcX9+6
 oXiE1trls64S5k8YxCghpaMyneLpkf2x4wzv3FaiCe5jM0iSpYFg9WypV9OZ6xhakne/MRkgl4v
 JO4DplozgLdu7CRJKwfkvXayS4/j9y5ydRhPB0Mf2J5xR3tGRyEiJDfxeQ2T9ecu//cMnM2OWHT
 cuGKzP0bRMZQXhdW6UU0L4NcUkD0Q9UuAz/LcbDR2TclQsoSPzbqkeJfbXhd0tl5T6knnPqrL4g
 i0QGVYu2UlKeD0O+h25Rm5jy3xQwuM2rLCueUMg20htdxOHya8gOJQmwBlAFcZ8ZeN7ej8Lsov+
 1T+nGlxqDYYlP8l5sQOH/c4w3ymmVA==
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b6a61c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=RmA6VkjFzPJuhqsbX-0A:9 cc=ntf
 awl=host:13602
X-Proofpoint-GUID: cY0tpaR6tQPSuRoItYy39pVprl-d9CZG
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B8D6C000D
X-Stat-Signature: ncr36ep98ue5jacftcsthw1ayjbaqgxg
X-HE-Tag: 1756800554-937450
X-HE-Meta: U2FsdGVkX1/0EuEHsF10POKFKU4CAKvT4MXXzQQZu9mEWLqedfXiV2jAwzXW1/ANl0VpGz6n/14/pBVm55DtqAmPinnKoLDyZbhHYQ8/djqH/C0FQqaqfubiLYSUuO/4j4Mf5rHfdj7jg2DxrCWCTxN5d2WCdwUUSq9v2YiJ2wzXWjbQFzN7SUyWFJerkRreFcUtFhgLCjc71ir3/N01h7O8M7eRINBdAg0nfccUOoRJecr7IfcmfF3LREvWZjN914E9RG7onwUWrnlF6037xSKAWHM6e9B97NS2F+OVmICCTem8AfwtrrtNhGl7i8jJsbulX/SjdFs/QaqCN/jFW5ki2PKBUyJlnPrdLagewDO2XwPf73LtEr4TNVjKKsWtIdJvhIsxoBM6DYljWpNImYZLjDA81K0YXzMj7aUqXOsiAD3rtHN1YbnwEH0y+uBjH50zzWK2lfdwfPox17hz9zXAY9htOLZPEkVjWvehv+5Wl2vyBvu4BW2oQeYW7tu4FyNW9f9TxI8nsP0ERV2ntCj8vid+Ds6bWMe9/kIudVbNlgjv+YLcTbn3XnVD4Z8grlL78AGkutjPDBVF+g62gA8TSaM5yCG1N8gHYU/kzXmxLXfUZfYj7jSgCMhv1nJNrUit1CHmeqGfNHGdM1gqO4WlLVuKCVIopNXYDImz2FCbMqvRUSqEoNhUxGSQRnLO47VgyZNQuY8YQN+PIiMxWUbTk9UxEHFKhNu6aDCZIXwuVSfkG4tT0iYoj6Iw6iHnNIb8/eMfha717Px57uF2JmYmhbue2bSLKrzdSmhpt1uKCrw/hMnDAkCMpiZPTRg1jOWa7zbsukg7LQqbjLAs8kh1lgDGTxsHNQ19/3Azh60EpALbVM/u9E9hR2k6TAInnAxLLJKGk/fVbfn6TPpR1+GdGJeG9JI5RwM8dLPdMkSyuU+OR8q4P38Dhkfh+vLjimae2ESSqvx+h0Ii0+/
 8oMAInWP
 KN21qUVcJT3OV5N5c54CLj8/M4hJ+yA75c5sH74T3cHtJ4+RtxjEUw8J4ly0BO9AvMteqOJTVVGG77q8HgnCZKQSUs/vhIvo6IVU2zkzJMhK5dAG9NIm8LPOxTpdNwQSxlzbNnDGtDMMC0JRVaGSlvMnj1vrCHvjHsc0mfanZv1jCdJyhAf6FPJ0+rFP5/7IUJd28ageEjcrD58tlddCIsMEIHpZWljgAfJ9tWqTJO2AIDCqgdtq7frHa7pFHmq7a/HOuwQBqh8cYCOzWphisRv/cP0PDBaxFEKTottCVWUctgx2SVo6WGHjzU06iWvS7r//ywcHLEGOwqg4++auyq/1xKoPNrJ4VoG82hrHNPWUgMkH6SkxwDhWbwGjHwcsWbjZmW+FsD420wPGz/Qof4jrrHm439ehO3qSr5R+FuqT2o4UwaVjaZAznFHXQLh+o4fJYQhjnrDmijXL8AWQGDfHh8jbnL9lnhMknni5Z+m/lCRFcBDyrBZJHd3BrvmTg3FtGO/So4YK8zii2h0jGEI26wDdoQFr4mEuqBjy34OvZyuY56C4Jj7zlLG3R+YtXM/psu75Yu7K/BCLIz0Z9e3P3pMHOFcMAfejkU2aMX/WNAQVI8yE4V0xxO/LQRb3ymylf+IC35qfsYv/TCQo/iQu7b9JW2kreTNyX9NZ88Qt6GQq8ey03fkdFCJPImmgA4OVF/0E+5qSgiJTYxLzk7m4M5fLRX5jfVo+s6OcQVe+6rVEZcYTive2n4m4CiQ/jiCaXS/e4mnqu04sYPsocFE1Uz6be19YFIRpe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define ARCH_PAGE_CONTIG_NR which is used by folio_zero_user() to
decide the maximum contiguous page range to be zeroed when running
under cooperative preemption models. This allows the processor --
when using string instructions (REP; STOS) -- to optimize based on
the size of the region.

The resultant performance depends on the kinds of optimizations
available to the microarch for the region being cleared. Two classes
of optimizations:

  - clearing iteration costs can be amortized over a range larger
    than a single page.
  - cacheline allocation elision (seen on AMD Zen models).

Testing a demand fault workload shows an improved baseline from the
first optimization and a larger improvement when the region being
cleared is large enough for the second optimization.

AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):

 $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5

                 mm/folio_zero_user    x86/folio_zero_user       change
                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       11.82  +- 0.67%        16.48  +-  0.30%       + 39.4%	preempt=*

   pg-sz=1GB       17.14  +- 1.39%        17.42  +-  0.98% [#]   +  1.6%	preempt=none|voluntary
   pg-sz=1GB       17.51  +- 1.19%        43.23  +-  5.22%       +146.8%	preempt=full|lazy

[#] Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
allocation, which is larger than ARCH_PAGE_CONTIG_NR, so
preempt=none|voluntary see no improvement on the pg-sz=1GB.

The improvement due to the CPU eliding cacheline allocation for
pg-sz=1GB can be seen in the reduced L1-dcache-loads:

   - 44,513,459,667      cycles                           #    2.420 GHz                         ( +-  0.44% )  (35.71%)
   -  1,378,032,592      instructions                     #    0.03  insn per cycle
   - 11,224,288,082      L1-dcache-loads                  #  610.187 M/sec                       ( +-  0.08% )  (35.72%)
   -  5,373,473,118      L1-dcache-load-misses            #   47.87% of all L1-dcache accesses   ( +-  0.00% )  (35.71%)

   + 20,093,219,076      cycles                           #    2.421 GHz                         ( +-  3.64% )  (35.69%)
   +  1,378,032,592      instructions                     #    0.03  insn per cycle
   +    186,525,095      L1-dcache-loads                  #   22.479 M/sec                       ( +-  2.11% )  (35.74%)
   +     73,479,687      L1-dcache-load-misses            #   39.39% of all L1-dcache accesses   ( +-  3.03% )  (35.74%)

Also as mentioned earlier, the baseline improvement is not specific to
AMD Zen*. Intel Icelakex (pg-sz=2MB|1GB) sees a similar improvement as
the Milan pg-sz=2MB workload above (~35%).

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/page_64.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 289b31a4c910..2361066d175e 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -40,6 +40,13 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 
 #define __phys_reloc_hide(x)	(x)
 
+/*
+ * When running under voluntary preemption models, limit the max extent
+ * being cleared to pages worth 8MB. With a clearing BW of ~10GBps, this
+ * should result in worst case scheduling latency of ~1ms.
+ */
+#define ARCH_PAGE_CONTIG_NR (8 << (20 - PAGE_SHIFT))
+
 void memzero_page_aligned_unrolled(void *addr, u64 len);
 
 /**
-- 
2.31.1


