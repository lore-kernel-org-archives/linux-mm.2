Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2990FD5B86B
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3198A6B0095; Mon, 15 Dec 2025 15:50:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA086B0096; Mon, 15 Dec 2025 15:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1261F6B0098; Mon, 15 Dec 2025 15:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED4EE6B0095
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:50:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCAD012AE1
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:50:00 +0000 (UTC)
X-FDA: 84222897360.17.AB49CE2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4BC912000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sIfQnaEj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qUclpkop;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slyyvH+4/5vvjVpAVAhVTLCs8HFHmx7ZSJZPGG8/pMc=;
	b=gHqToeF0EzHLZf0jE2Mj9iQcmthjZ7YSPXue128KwoHv/xP9Xv4Jmd0Nk6EvIycYhTBuaG
	HX2JsgeZ/1qI70wQD1wCF5yQZBpkMoHDJBbcQ6uBYUUJSEYDqWo77QyCIrWhD+0QY+4/tb
	ZU7pyM9b8E0ReKuB/zsP9VinzjQbbo0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831797; a=rsa-sha256;
	cv=pass;
	b=0hfG+1EgDhDH/NXF/izvHZn+PMUgTZgjXWLHu35597QRCR4f7mGDzyG8HIbYDSExhkNCh+
	oARmzWs/25tcfs7PIik70Y6ADVyHRL57VsNfNak2lQVyVnRGUDKaUNZggSKgOxWQYWNKVV
	5xp07hAhckJieCrjziQXMaXvrb7E5YU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sIfQnaEj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qUclpkop;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJC7Ti2885738;
	Mon, 15 Dec 2025 20:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=slyyvH+4/5vvjVpAVAhVTLCs8HFHmx7ZSJZPGG8/pMc=; b=
	sIfQnaEjn7jv8EOFe7NJoXqOy4pPw56GEJ9cRQYOuJMiaJBwY2MpGURkWT9NuazE
	Ja28yHCAIJl9884YvVxdeZE1PV4Js++5WVDyLOS8UyS1GOGCa/eyhHBKEu5Ygllh
	nn1tTi7c0SDMQwFLcjn9xKVix3NtNaQ3yP5lClROcaDagRnG1TPeO3PIZYBAJqfm
	+D+ymSerjzKwJmnKSFWaopqsj1hnlpf6ySUFmH2s6wB4FMGwNEzXQGxVOlXs9l7Z
	HiWWDBw2tJ2cW/Ap2qE6U/F1jdX1Nmbo3yMT9yLfYW/zFTqKaIChxK4mfbBH6KH+
	N7MGM5XIR8yqNGCqC2OCAg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b1015tsue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFJ1N2j025193;
	Mon, 15 Dec 2025 20:49:40 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk9p1ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nX4vP0U6eJ8Yfr8DWlxvbfqILecOPbf11bDbr+bfzTYOVaJnZwanqcCjGyaoFYsGn2T8DsBaRqgXXab3KQ16naJCvs16Mlo8eYBsoevXbS6JTlBEokR9IfAvvJBFuSiaG9tlC85M4l1zV5sIf8ZH3r4SKspKNjXLSPc/B2UjVTYFjhEW44pXOCKyrF1JIKuDunMYuFcqNkPYVKgLR1qrvq+QilhBcBXvOh3kKNE78cTZbhQO1IW6LbxBzLRmmNjt3NaEs/WMoH8zeK49+LlYxgRMv1TjdZzkX3ZsjRR0UFaq7/jEUd/1SbSkbc6ZC7H3cJn1srqyRIimWTHM6S2nUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slyyvH+4/5vvjVpAVAhVTLCs8HFHmx7ZSJZPGG8/pMc=;
 b=t3as7O0Ps6bXvLdnwQRual0gjL3MjBTY9+srTCROQQI93M92R++Rnt7a4FalNBIJwKBahLpl/4eWcW7/xHV31WCqgA/v73/PsT7H/+YBi0oSEtRJsdXP4nWQQq4hxM7JMTSttK+OtlKWNN1wBQ3SETP6ze/8/Qw1Ly+rv9pOemwkOCZoYGl6s+wvuFPnGUjZZt9txoTvekan9X2uAGryieEBzYE793aUjwGBGfRFly2CLs++VJlFdHQp+iGWyipot67MiNJk3QeYd55SL5hryOnYpOVmESOTFedsY9KZ/+6TqKlm3Q4vijBgMGHO6U68Taz+U2HY9lYIXU7PMkdRkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slyyvH+4/5vvjVpAVAhVTLCs8HFHmx7ZSJZPGG8/pMc=;
 b=qUclpkopC1emcAH9J70C0M5HsPYHm5YFIEmK1X/LsKENadLTX/KSp/p4X5+QiiX43NGzO+mKzpHWolFHT30L0BRRPjpEmUBtsGCJdBV22faWjnUtsWYgHxhs62bkegSjnVyYB5l/Vv8YWijDgW0VeHUk/R8pW0F0sDa7etZeDDQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH4PR10MB8049.namprd10.prod.outlook.com (2603:10b6:610:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:37 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:37 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com
Subject: [PATCH v10 6/8] x86/clear_page: Introduce clear_pages()
Date: Mon, 15 Dec 2025 12:49:20 -0800
Message-Id: <20251215204922.475324-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:303:16d::19) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH4PR10MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 56456102-63ce-459f-7f57-08de3c1b75fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M96EZESzD+6o8egNgwmuoE7PMzYuelbz+Z8TrCDre7dFhQzi3qtLd2ktOAyg?=
 =?us-ascii?Q?zAxvjLkJLOUkkNElbu6IhlWrpF8XugTPEnR71LOhQNy16nTdDVSyqWPBf+5O?=
 =?us-ascii?Q?fv0naraWUH70ktgyIrbNK4nc4IuqyRx8fN+m7sEXphDvhFkuiumPpAUy6qa/?=
 =?us-ascii?Q?cWVgixwbmJkg95eslQzsU4ZXZjg4DFK6yJMgzRqBmY7PTgNbCQcJ0uHgQmH9?=
 =?us-ascii?Q?fi0dV+8YJvXShCMsqaln7G79wafHqU3FlpGFj0v7baW/Hg4W3PKcY2MEWBvU?=
 =?us-ascii?Q?5+AYB5/ZxmMZ8+WtqJsmZuL/XK+gKrDfJPcacwa88+pUa/3Tt0ckU+/kJRdN?=
 =?us-ascii?Q?Ao13QPZl91okhbw1NY8OAreynrelNQlyPDqxfB1AP/NHlT8B08dXkg4Zg6yU?=
 =?us-ascii?Q?f89FLIG4XJqcdyLHpsqL0rB48j8YGhEOxEzya1xTADEjbWZLX1fOYrLOxJ0H?=
 =?us-ascii?Q?UR+x021vwi2SZmlEKG3Uy0CQTXS9NnDHgMs2RCs0F6mfvE5r6CHhKuVTuhGc?=
 =?us-ascii?Q?DFIhkpYGmGoUdxIBSp99YDxCU+AOWZhpiN9/guCYdiUd1ocerFeqoTcXVBEY?=
 =?us-ascii?Q?GK/UNrcNPxA6yBgb7CzneAL5bJi4XVBzwkJcIJ+Q994T6B2RIDGMUbtTK/K6?=
 =?us-ascii?Q?UaaLWOlUboj9T+7bNdztwr2DL0c+SyeZWwREkIkoeb7FT+X+9sODb7SeXC70?=
 =?us-ascii?Q?VRKj9moDPS1jUUaLVcN832riNF2FXbygt3bR7Vh2JzBo36rEnGj8YUhulUBC?=
 =?us-ascii?Q?29gHzf+n+Kn8BvdAocp5cwLVaS36eBtE+WrAt+W/okVzYb7jr5j1XLXmOoGU?=
 =?us-ascii?Q?1tijUh3Se2TVeVrBaxt9d5JkaVkBH6AfTesQ1dnsFxHokKvxyv19+GmRmLh3?=
 =?us-ascii?Q?hi2IuagV/Nz0JRZfamdo51MjuQhUHns+Hccxj1K/kTTgPXr4JzTT3iIGACXY?=
 =?us-ascii?Q?VvPKGP/V3H1ZFB/VS37Sh6dCyCMZ/ztO9WfTyungep8lFJE2dGXPbarrxggF?=
 =?us-ascii?Q?/ohb19Vt4bm3XoQU+fHAK0dvH9aLc9ZVZpT1A1HXH43L7XGmZrF2IKZS7CdH?=
 =?us-ascii?Q?edasEUpg9e5l36R+eOaNfD/lTsQ21ZVo2jXQWRHu3PHI/j6rf/M6kUmrh9TY?=
 =?us-ascii?Q?YsGE7Pz/mCTACcwAGsrdeZdCW/ZeKlb4cMEfFo+A5mdetVX8s2/rROKotPEa?=
 =?us-ascii?Q?2idrM5hSSNR4ny8Drp6K7nomg5yxiPmnU92aTMVHk1UMuUqHP19ISfbQ5W0V?=
 =?us-ascii?Q?FMqwKuRDzOJ9MTroZVBta+Hli+90c+5YQTEx5lh68ZvMUhU2N0PU/JCYkl1z?=
 =?us-ascii?Q?tufxFxWNpcu2iJeCRMQKnSefCdXD45Kylu/HCwMUEIni+hleHQOu/6vnvslX?=
 =?us-ascii?Q?tQ3rZXMIK3CRAPr6iQDdGeLVjSEa8v6WIow9Ijh4283lVumjzY++gJ3P7WOp?=
 =?us-ascii?Q?5tcZgfKK5lG+Tgnt+1OOpsmh3QogTCBA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bkTIYVovJ8rYzJLbXiEcVS6axA0Gk6Fw4a4LIfi7o8jzFYfGMrS8e/6nl8VT?=
 =?us-ascii?Q?BUvB9KzFvc90r68M01oM9ZwepL0EkHGFnG5J/uV5zQWXyWjpHR0W9XYRm8Ns?=
 =?us-ascii?Q?J+eLxm2r/Uug6Yp5Gv27Bms2xKer5UvIA6ratPZhi6yfY4qZaVLGgWxtu6Ef?=
 =?us-ascii?Q?vcRKFt4LyobFM/WTwGTO1OjYza9r7tCcIJ3jTg2O2MPIEbTl3vSjCEPhHjlk?=
 =?us-ascii?Q?pQZhnyvSEuFCNS6fe6M7YqEBvOQA5Te7bA047ppyXnn5HcEkDVNpSfjdq/ER?=
 =?us-ascii?Q?NwArkXpfGjVyxCxCiJSp51pxODzRtQalnXO2DrXlQigWj5teHitKWK0Z8c4h?=
 =?us-ascii?Q?zvqcK87lPG0099fi6ypGXPNCXAIbMW2ktuiUaA1sGSVIxTDyFGNzHXh4yDFT?=
 =?us-ascii?Q?/qct0lBqYcYE3V/YV4bVTtsD8rXAllql8lmo9IOgnsFDlgIIy4iMQ7AI0vTQ?=
 =?us-ascii?Q?p5W5z++tgqZN0V9kKkiqFUWAZf5or+44OgEOJ5n/P31wnLoijVxuEpg491qS?=
 =?us-ascii?Q?ywy3vGhfa95SSVUQ2DeARPN9ncnQ8men+79oyvVt5e2VPhxRxSR+4BsOEI52?=
 =?us-ascii?Q?v1dJ+FjPTjUT3AknXsZHzTDLCB9PJ2Q2KzdYmtXxoi5YUoO2tJfvhuUIXdUD?=
 =?us-ascii?Q?TTSvSrPgXCp+zCB6n4HIiwtO9fHZluAKP/R14V+8Xf4yxhSQoK8QUAFMqzd3?=
 =?us-ascii?Q?t2cOQZWz5DSZNwiEoxmBHGYAc4BSiqpr7kFoJPzImFbkGnmYXK+DZTnXvszw?=
 =?us-ascii?Q?SDswuxaIgXxdxTuVwGVF1rL3ZmQwHFw7vZKxIpLfc60oWPg4wC9BniZFyA5f?=
 =?us-ascii?Q?B5YMJa4OVYpROPcth4Vdq9uoZNb1AzC3b0c96/X1dI9POTAB5W4lRfLAr0qD?=
 =?us-ascii?Q?ltO6QnllkFaFMu/OdgkrL/XbNMq2RPpwrhJ7qolz5L/pbz1gdtNxqqmG1DsG?=
 =?us-ascii?Q?FH4eTHtsmG2S7z0mw0rssG/E820oM9GWWzFbgpJgTBqdg61W+VyxXOIxmCWz?=
 =?us-ascii?Q?m7KqBr1Jtmdw2z1aPDGf1oSOZ/aqqHRdC3GEv6vHOWTeP/AuJqq9/Gr/Sfim?=
 =?us-ascii?Q?iT52CjkoErkzTncNs8Q+NJUS64NIdeee/34yzaK85Nbmq7rlaFrfZDd1mpz3?=
 =?us-ascii?Q?oMRZvjpW8Nt379LMb4f1g2NEAHqoGWtCxkCowHLEPrqYbjPGAor+QTU544eI?=
 =?us-ascii?Q?Pfcu06IErMW70n76SFbLqGbxdgInC7IWXjWdT/WOEnTw2mtKVZo0gXHYskgm?=
 =?us-ascii?Q?3+YKTrCSdCMXjIMx8AxZjfTyPD+00wDK3DUaN+3Ek5bv7Hn4h5apoQcDIBGc?=
 =?us-ascii?Q?LU11TsQ4JGLRj7e2ZgO+RvreaONI582JtYxmfdPmR7OA1AI2YfnqOJhAAy8K?=
 =?us-ascii?Q?XjXsv62d+LijPcTC/fNnMhV/bNbFZC+ccRFE93Jec9EessSfZHXpgXpSqjaa?=
 =?us-ascii?Q?Mj6X6g3mcHDQkU6AO8o1gTk8B33ImE57wRuoOVyySNy5XQ0CPPQNUmfa1VTZ?=
 =?us-ascii?Q?7rkMFOQdyv4bsocmxUtdgFu2OmAKBhuNRXxk3A67r0e9BPAKz06wm8uB7B/l?=
 =?us-ascii?Q?EaSLCAdv/9aMrFpMAFObphQi8Z8d7W6RpkajNwHEOIk6gBlzGR+cuJqYe+q5?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ayFSB/MWRKA8yeTfyqr25k0yYZEcG73CEXhnkSyPfy1E10sfDtggMQadg5Pviy73Riwkl2tHInpf129prQ2iSw5/uTPlFy2WkbuZuDBoLDtEUFiO1eLrIg6N8mACfoGh3g1YHqeYFgjOTaQ3VzUIgUVJACy2wmvVNnFpcOBKLoLxRwPrKANSp3Xh+t9XYiRyomEiM+wy7fEViNS5sYeZ/nD6Mg3aTfMEvCqj/MRnsJwXWRDP/sCmF/2zyHk67G8zQLIYkOLboPJsw1Hem6g8Fh61rnrGLbkT7HBfD8dmFOviv44n9BeJWYZuSTXZK6QofcjsX7SGhfThoVuteINV8lnabihuY6L+MKx5rJrSP9R+7fX7XQSl4T/0eQ8cuMZXDoe4BE+LV3J3m3ExaGP63qVOrtom5TtHA2MBDf+/wxRCA1jhZbdAmZud9n/+55dJBDuuPbHMAX9vSYuq0MUW3XRHBW8rjQwDr98fsdVXUV0gY4x6VZB+ED1rRUw0aR9fELVbvIdDNAu/UPPljv6M6JEPCuGs6/90xghhX5XeX1YnP9CrSSlwlpN/IbN48YPgqgKEgGgUvG1CNlMNMAwqOzkVzXzpRyBhXeDmP1oEEGs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56456102-63ce-459f-7f57-08de3c1b75fc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:37.5545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: umW+fNuiLlpq0GIG1OE0hl9E5oCpZrfUzrb5mwsl6ZPgwg2GqD5t8SqS50wsx1qserVrRQCLb4nTvADg4CHpJoOA3VFm1YUXpOXZxGBcunY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8049
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-GUID: Wuu1elDw9vW5M3BHXOHFj9TksxsvSp4q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfXzKN2CFyXniFy
 MCv8RpPRSrG15fMxz6IFI0RAj0tVlYqpxKsbMwLW2/IRQ54w6A90QlEvmoLMVpzimIeICWCcCCg
 Wr2oMmOCwqU3YkIJD6vPo28LHohRQpEJj9Wx43NpStf9P0oBtXKvvmphYc2XuftRfc2xQWrh5AE
 2QTJX+jPPgW+C1rGNWdUe+8xQ3DBQmisU/Euv0yJx3Wz3C3qtu2r4aX7cRn8AYIlrTP2/8LrXyg
 NIK3uHawsmQJVtdIFaPBpRCbMXmtCbLxtKWAJDgeOSWGPF4R/4NsWNuGEATrLgUEzJ1XtrIX0wZ
 tgaJKZdit+S1FaOnTs4bCr3XQ9oCWxuhYveW1BwMVu6jW08M6ny0Uz7rMl57M+xMVMgrMXCswg4
 3we6Yx++rC/vctPWjU9BrQFwwjoA+w==
X-Authority-Analysis: v=2.4 cv=GbUaXAXL c=1 sm=1 tr=0 ts=69407465 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=Sq42x_x8DAdjSyyaoPcA:9
X-Proofpoint-ORIG-GUID: Wuu1elDw9vW5M3BHXOHFj9TksxsvSp4q
X-Stat-Signature: 1n7irszr84hyc6j1agzj81xeatz7jtcw
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4BC912000B
X-Rspam-User: 
X-HE-Tag: 1765831797-440977
X-HE-Meta: U2FsdGVkX1/0JIdyfX2XvhEga7f66dFpPFIidcp9bBSEWDs8L8viREVm3TRGRjh+e2q5SKklK2IjOzyuEk2K+9UJQ50boREjVflozn7WBTUoCnb1DVwmiyTEvD8iDLqCAZv3iIF8jw4oRvXiuYn4anK4uqi7/pg3QR06B7Xm9L6K92uheK+Zlf95biKQ3/6CmN58Cp31ga1d5sDrf8MfAP/I0OipXoL54Jj3I+qlBj1ctt+PAZVXnkG7brWXyd6OWq0AemHX/KUgdruz2Fqv74ftVJJBpVNF1mXUhiE4tMt9gHssNJ13CUhTmRi08ZgnZv1nzeihI+LmUfDNS/ucf/ytxu4YBV0Aol0K9EBubQ0isYVBwK41TSd9P/v9rQj0B2DUd+A7p71OO6VLRF6aSKW8p0M0bDjCdf/BCr9WjwaTjab+EL5uqBRWIVZhlfapgYXP077Aw5Nk7iRMK+KURxCN0Vcf6TRscpOKG/Htyu+Obvc/Byod+nba8BMqFEAMAcWLee5REvYoFpnNFR0LGK5VLLuJzMa/bHSzv9XRbOItcCz3pCNg5yqpysG/LOQ/NLbRKFbftTdbOFd8rnGc5v+jpdlLvmyXivZyFVR42oFwCiS/EjFTcRexZt9NPc5ADGgp2cBdTBPpM/KrdmNzIBi/idZNfnba6PiVBd1vuPN2TBp3pPRwwihP9XddffaOHFrQ1+Vy4zuCOsHHd73q7FTqL0J/LEFPFiEpxH0cAu76nw8ckX9UpLh6Ifh/GEjsqkrwh3xM8nHZvr8+oZPHBqjzllsAHXuTbRyTK7SeJhAWje3dxFSJHQYhb2q7ZL+IrtJ18yC2lRn6G2oI4J5CFqVoYoS7Jhq3b/yKcs55KwpUKqQWgEciCCd9lBsfR3aEgB6Xh5DgWEJiEUFMmjheRFO2hH0KFZRvvmwjFhYg0xop8BI4gAfWUOoE1Gv89jSjSzGYDxQYlVvcVQAiPjz
 Ske6SLEn
 qMJXyYchOaukZZo/49GkXVNJHcsOx42RJYnGzxP5WkUVtUmQVGZgSmvpRSfxvVsb3bZurwTtGbAkCyEExSOcuCp/xJI++8sjGtwRV4mYZyOUUlp25AWIqnOyuBx1WwfmXabNTf4e4AB53y3TqMz4b6foj1+z1PvrbPtsJxdlQStSr3emwRNy0BkNqIGBpO/zakX5nBJLECRowwV0rtP/PZ7CEuc/Cg0UclV8PU1C5qz8X0Q7pjpFfbovjP+JAvQ6RDHQ0qsA1GvJ0MoXiylw16XbeBrpfDJtWwlYWH3E7bFyEk84NFt7zO/tjby/kFsRcDKwDa8g1lxKG5p7APoUd2dY1qbxHrhLDmqprcf5MABL9/FKz7y3pHIyAS3n99Cu2nTTbVX5WMXWaUnrYYL2GKXd6zSFVDaYC3/kbzJb/q0RCsA7Xl2j28Npu9zx3morfYiVRdO2+1tLT/+KGA2XvbD53uFNH+PQ6akgFz/o5M5ea38TXPF2QC07/f/WuhlfXoKSTdMrdk1tY29/EdPDRXYQDD70psgyL8e7fa7BLbrPdxy27OdgzSqizHQQvC0rXQQ6QqcN+L0eYizo/06wH2W4OFtb2Ea3sKhQ+9dZv/30tnjuh97Tzrda2lLmavK7ohw6c/4i2fqH/3ItaOWp6v5CF6qFe9qQlKMU0rPDJDjLgQzM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Performance when clearing with string instructions (x86-64-stosq and
similar) can vary significantly based on the chunk-size used.

  $ perf bench mem memset -k 4KB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      13.748208 GB/sec

  $ perf bench mem memset -k 2MB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in
  # arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      15.067900 GB/sec

  $ perf bench mem memset -k 1GB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      38.104311 GB/sec

(Both on AMD Milan.)

With a change in chunk-size from 4KB to 1GB, we see the performance go
from 13.7 GB/sec to 38.1 GB/sec. For the chunk-size of 2MB the change isn't
quite as drastic but it is worth adding a clear_page() variant that can
handle contiguous page-extents.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 arch/x86/include/asm/page_64.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index ec3307234a17..1895c207f629 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -52,8 +52,9 @@ void __clear_pages_unrolled(void *page);
 KCFI_REFERENCE(__clear_pages_unrolled);
 
 /**
- * clear_page() - clear a page using a kernel virtual address.
- * @addr: address of kernel page
+ * clear_pages() - clear a page range using a kernel virtual address.
+ * @addr: start address of kernel page range
+ * @npages: number of pages
  *
  * Switch between three implementations of page clearing based on CPU
  * capabilities:
@@ -81,11 +82,11 @@ KCFI_REFERENCE(__clear_pages_unrolled);
  *
  * Does absolutely no exception handling.
  */
-static inline void clear_page(void *addr)
+static inline void clear_pages(void *addr, unsigned int npages)
 {
-	u64 len = PAGE_SIZE;
+	u64 len = npages * PAGE_SIZE;
 	/*
-	 * Clean up KMSAN metadata for the page being cleared. The assembly call
+	 * Clean up KMSAN metadata for the pages being cleared. The assembly call
 	 * below clobbers @addr, so perform unpoisoning before it.
 	 */
 	kmsan_unpoison_memory(addr, len);
@@ -106,6 +107,12 @@ static inline void clear_page(void *addr)
 			: "a" (0)
 			: "cc", "memory");
 }
+#define clear_pages clear_pages
+
+static inline void clear_page(void *addr)
+{
+	clear_pages(addr, 1);
+}
 
 void copy_page(void *to, void *from);
 KCFI_REFERENCE(copy_page);
-- 
2.31.1


