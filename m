Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E85EE81A25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6B66B008C; Mon, 16 Feb 2026 10:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E9B6B0092; Mon, 16 Feb 2026 10:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94CF06B0093; Mon, 16 Feb 2026 10:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EED16B008C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:02:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27DDF140CAF
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:02:17 +0000 (UTC)
X-FDA: 84450635514.13.877C5D1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9EA5F1C001A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:02:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GUMZzVdN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TLq1oaQS;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771254133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUdl/9l2JeGGQB1NudPTxqtdZWwLyNqP/RkcWCD/9Zs=;
	b=NzI4Xb1eTxDL6XBLQtMUz2RxJFjvb2OIXs28R/T4FJpatUrve5IaJC7LLpP6xSqZ+C4Mfh
	LTBSuOWcGY0RCAT9h9XQUTMfUOTCE3Y17qqkn67iUUj8s2Eb7gvRTyT8PCwQ5cHD/wGc/z
	+fOw7Bk7/ChLqo8691fYIusYjEq3HhE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GUMZzVdN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TLq1oaQS;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771254133; a=rsa-sha256;
	cv=pass;
	b=iIzFhe5sa6RyMB5HUFnzJ37pNkWeafDknyD/X08+wO7OtzJoTI5FHEls/SLFLzNb13EO38
	19yytRCZztUot4ECtcyvvM1u3vcEE+CHrtANWpRkkmjBegbbdfo02wr4uPloJ/KF+oCppc
	iOMZEWrlKTiFvwJa4jOJfCZhY7XB/Lw=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GEjQNC4005004;
	Mon, 16 Feb 2026 15:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wUdl/9l2JeGGQB1Nud
	PTxqtdZWwLyNqP/RkcWCD/9Zs=; b=GUMZzVdN6b9v1W1eUzkIgVlXAksayDMCJ+
	Uc14FWL8oqAS6JgNVALxNeGeITZ/h+05++P+f06PViaY3A1eDG1WwuWkfQQ+pcEr
	fiNm12xXcK+pZ3okfU2erg8fHQxI6ZINXKZT4MBlSb5E/QL83L/v54KGcCLg8c5n
	/vnHulMsQ6p3tucNGztxTLjpHOMAwav1iSkV30+wUKFmPLrlujCummlyaua6rwv0
	zucOKl7gXRpUpUMLrKtB8TnFoZCapnbgVWgQEIS5TDg9jASqaz59nt8skWi2eVk5
	DTcM9lPE5aGuhAL+4m60YabvflVAqwgPt9djqmQ3JF+yx1aDQxug==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj5r2764-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 15:02:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61GDJumP033576;
	Mon, 16 Feb 2026 15:02:03 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010031.outbound.protection.outlook.com [52.101.85.31])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cafgcfm54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 15:02:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HKXG3aUbbyIWXM46ZN2tntnReV17FbhGj6brqIMoka05akYdqV+JYvqzfr73iPYyETnmK5oK75e2gXhxxMmisL5AVBOWA9NGtUP08Q/st2F1bn5XaIM7tjLf4RKWDg8emH4z10LdrhFjoFgVsOBjm5wCWEVCJvMbBZhTMRvV6ruVpSq6VQdoG1UGVqpwlf96ZptvzkAdhAdAeZxFubxkvTbXFF9ujMYZevrhZ4Ap3npREMgj0FTQoa65Y72ual8k1zWUrbTQAKMWHp+V+koqwQjDORahHtkAarzL68B1uq7ZEmqBbcX5fmKxY2vYeQy8z3KCN6a0+YIl2j4zoluLzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUdl/9l2JeGGQB1NudPTxqtdZWwLyNqP/RkcWCD/9Zs=;
 b=l76XWk+DHw0TDB+msbnvB/n0TAb/AXZEy8jTPRLME2H8st5WoAh4Bcqr0y7u+GFFCanLAidDTqynmgng4R0zjKrm1j4bXLMym10qEBgWWba5D8G0QADmCWGxXamlDt1RuKdxY+anl5/AImkOf6kzwV/8DvOODawdDl1s8rl7xzKZF3oM6BFuXoYc/bSjVXeWIENBjGlK1UxMTFQB2skwKlUtKGE4YnR8lF6is40Lw2lSfbjZVaGUbxQG/n78dA+IhzY1hHQ2cf3uv76Pd2MNdVlxnBVgmmhiKWkeTIAztRECHMo9GG2o22vy4BED5P+pbReU2DwrFYkoMNpzxShPqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUdl/9l2JeGGQB1NudPTxqtdZWwLyNqP/RkcWCD/9Zs=;
 b=TLq1oaQS3ypwyLFh8lYu04Y1HrB/j4OWiG71Z8GBAguPqYkktA6C0XjU8175zVOCjMNb0sWKO2h7arnLYhvZbQTiLnMLyWq1AXpP1VGjqzHvPyqcvSfqO7EO8rMsCzxUmxE7GDGXallUsO7n8dz5WhgYzE4XrVDzkeHQ/FyVwFU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6019.namprd10.prod.outlook.com (2603:10b6:208:3b2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 15:01:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Mon, 16 Feb 2026
 15:01:57 +0000
Date: Mon, 16 Feb 2026 15:01:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, i@maskray.me,
        shy828301@gmail.com, ackerleytng@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
Message-ID: <cab889ad-5663-4fae-a361-0794b57f9f79@lucifer.local>
References: <20260214001535.435626-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260214001535.435626-1-kartikey406@gmail.com>
X-ClientProxiedBy: CPCP307CA0005.DNKP307.PROD.OUTLOOK.COM (2603:10a6:380::14)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f86032-2500-4732-7cce-08de6d6c5429
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lf4sy2gHdI+g2c63h+/syW2fjr8dFwahejaZvBfCVOEqIG+aVlSc8sYDRh+x?=
 =?us-ascii?Q?eRp0iQeawTPahJCAZvF2JV2fQGh3wTLnHg0UOGJLoCVFehHEBtpnvnJzR9e5?=
 =?us-ascii?Q?qJyXzKvDnU8pEtszcPxvaqUzUYlHbF4KmHbND0ugFet/ROw1hYbSKwOebpxM?=
 =?us-ascii?Q?tDVjtKJROc96VR7UDsNGfxOAHDyBbJwX1tzKfiZI7ioOscmNBnYeIiVZgKlN?=
 =?us-ascii?Q?/JSifq/0tSkSgjrYwCnF83+z2dNdJ8k24qjh/5T4toejFDIs4K/pX9KYGP64?=
 =?us-ascii?Q?FwzussGtSypgECoqN20Z5VFhr7JHhqUy1Amu3QFBSuYrcYMl0M4Lz89JDIE2?=
 =?us-ascii?Q?D2IXdGC4NcX1kRIMncvu5/wcMvg1ZRZvhV7+JPPaVWtl6W2W3+bFf3u2A5tD?=
 =?us-ascii?Q?09Db2JNPzlORPeRaLSyCyA9pZ9TTTkR9sCZgwczQ4zHbn3Yn/h5jTcTt3+Dl?=
 =?us-ascii?Q?YT32pX2xitMT5iFHpA7qpkidu4GL0djR/ib9fHk+9DuE+0sdAlYpv/1cHoGL?=
 =?us-ascii?Q?qMM4Q02n0ijRb4ThGBTHDTRS828ZmhdjXbn5oVKePq1196oe7R0O0lUyxoK3?=
 =?us-ascii?Q?YEFkgu84ONdqEqOCmkUiGcOntVijrLhKmYtD1HKRZKLJmxcTa+Xkrw6cqmU7?=
 =?us-ascii?Q?kAkp1NPSKo2omojdd0kilPVS+BUgxTOpZ+O0xjJ6NklRZK9CgDq05iYSiS63?=
 =?us-ascii?Q?h66DFoEIrrwEz/3u5tBwwA5Giq3jHVDr4TRePPLprjw/v5y1HVGbYKtj6z73?=
 =?us-ascii?Q?AZXrfL0NxSSqFB+crgUaBD0wept4c8d/lcKXPU9HpDZiu9XcP1Xiqxr9yjMu?=
 =?us-ascii?Q?fsbfK9lBL+p+BbLmOAUZnLUS3LoXCvoZjsfw2kbuqaqrMHqUgiDMfHeW7CGa?=
 =?us-ascii?Q?djQ3e+BFX2AgkDtXafxt/omsH8V/bkaRomuQU5rs6M64EWU7AC0Hc0JUeTAF?=
 =?us-ascii?Q?FjaaVfFYrThVkhNouEs2uCfs9iAz9Rw33zVeUtaaZalCyaVfK9I7looyfN+n?=
 =?us-ascii?Q?I88gufVnHalI6GZG2sQIWjDkTVvIsceT7cM2/fDEoOz8mwoO2e0fOSiFAvSN?=
 =?us-ascii?Q?sVbupHbyvhD67/Ds0fg7t3tibIDsN73bENk5G5QBnZEbP0MNm9z2/t4r3bOx?=
 =?us-ascii?Q?ym77Al4BWrDSK29zTpU0kq1NGTjGfOEwxwPPpOq10DinSjRfo0LkoikwQWmX?=
 =?us-ascii?Q?NrLOjjN3fTlxWXfKMXTdEoQ5oL1lyPzOQHUtb0idQ0NkozJCTxNiCks6Q1rh?=
 =?us-ascii?Q?r7UGvc/GSzjqRoA4d+zyJBD0MPyiMSi+ec1Wson+Mjd6SD1BoPAZrYZ0L7Vi?=
 =?us-ascii?Q?9jLWA/gis1HYhc7nvxwMjT2bmluWcH2API+YRSLJWTAGHWeUv4MDgqR2cANB?=
 =?us-ascii?Q?5rc6WLamKYcz6Iws6BaJsrHma7YAxOd2jeWtcZLFeuvhBmCd31baMcm1VjcD?=
 =?us-ascii?Q?M33ulSq5uoyxP0IvEw4EKOeI3g0hG0XcgPGTbw1W4pK24mIEWgZkWcwpXgfQ?=
 =?us-ascii?Q?v4NLlI+cvgNLiqv0QJTglGb+9Qw3NRnPO0nt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4AV75zFE1xaUC42IeSr9G+/0M/ULvXYsH9RXZE2l3z7AqUSdlwpdUSvDfahD?=
 =?us-ascii?Q?wW6bSjZWqdM+4h1x+8iLlcmcn5BkPvVO143vIlAYfjnthsc3cgCLN6NKFsgo?=
 =?us-ascii?Q?RfsOmQbVEHfA/v9osuRUGrjMv1gYZ92kQmKpM1T+wkGTicgOHdsDmAPbDE6C?=
 =?us-ascii?Q?T1G35hDvRXGMHCLFx1ALVwKQewonneUp8GtPH6qxFI0E52WnI+sqlqT7hgUb?=
 =?us-ascii?Q?545a3bALNs9kt+KRSFMq+ny+Jfhm/XkXUA0xwmTMa+jBViShCS29cxSSb2ZM?=
 =?us-ascii?Q?C7P8annmeCB9bW2hVxIJtYDiKMewDANXJgmRbHBhiy4S4rfzJYVemh/ol9JV?=
 =?us-ascii?Q?6cONvJgbW2ykm0kOkvurZYpygF9uA66Aagh0Yw6t7USf23z0V8PSFpRtVN+L?=
 =?us-ascii?Q?W2XzHKGFmopXfNCEAALxa9jGRW/Js4FwdeNY804KI7v6qJaXjQHnyyWMl7Py?=
 =?us-ascii?Q?k3wsD5bG05jaOqB8n5Wc8TsGM56SakSl+EDcl/lbJKewVL68li3/i9m3LO9r?=
 =?us-ascii?Q?/QrZtVBd233gK+sef+Xr47aRpfeveadY6Zdk/R/t3P3ewElOH45QV5OAurHa?=
 =?us-ascii?Q?TsTUPMltLkr+pDFIjnGRuI6bLKXwOkb/+VFbCpkYz8pjtf+gOKzO9FqO6qkV?=
 =?us-ascii?Q?NIHIDFRnH5lOKyjPsLMJf8tzrzqAMO5e+Ltyufep+36HeuosKKippqsiyTt9?=
 =?us-ascii?Q?hqG7T388wUQhvvnCe/ga60nb2758Ga+jKtVou5PnMKkLeGY5+FzB+UDKjSri?=
 =?us-ascii?Q?6KaBJIoSrMHApbtRyopPeZjJ4vmt6JsMibmRJLFG+vrrEKl0d/OsiCpa1PoZ?=
 =?us-ascii?Q?duqOzRkgZx3WRIHLSZxeyvpB26DERiRZhjRxeVObQXgjp5jxb2410po4mm+0?=
 =?us-ascii?Q?1ciHQ8wd1jgzYFeNOoR/a8Qp5bdYtp0g4hSEtMr6zxTyyA1o5eFvrePnSMBL?=
 =?us-ascii?Q?zj0dQ3++2mIUfPbdhId4MxJBjDg0q9fNBP2gXOZqaJqcQLWYsymMkTTGdxo1?=
 =?us-ascii?Q?SRLdoi+XOLHg2s5lSRQp4aITykGdia2CFcpbsDITcTMCHDgEJqQElHHOMyiy?=
 =?us-ascii?Q?9p0sv6peSy5MeTAkYvgYSveRLTqqMEfWIY8jsSq4lmRTWYfr1AS3RNWNyK1q?=
 =?us-ascii?Q?DF3lB1vxidEnOl3+XBVceelKVQg+TX/6KDztSJ30jJZS26mfNkJhgwRkM94y?=
 =?us-ascii?Q?8yyamdIKFVTxF0+ZLsCA7TrHqg72Q5LBCvdSRtOkpNvyb34DnhS15rE7iGtI?=
 =?us-ascii?Q?kGnXjp4M27zLEzAezGxeKxPbw73bEaxjtRxmKbz7KU2o3uD0uM//G/deY35c?=
 =?us-ascii?Q?WLf632/RNnCFEJlL9HXVGymusPOv+cCq4ZWX0BdfI62TKBxk0eUKbG2eiGKc?=
 =?us-ascii?Q?7cdGHLiybesqKlMjh72B77pg5nGCdQ3xtoRmfgYZO3yrOnvZP9WPXAjvn0+0?=
 =?us-ascii?Q?5fCURGkJ9FuW7XUIihJ84ixGk2OJYU5V1NQBHmE+8ZeJGUn9Go2wU17XQMK8?=
 =?us-ascii?Q?kQgLl66Lm7xkN06PM0MzMl7mG5AX/1uoY46jT8flyqqMuueUcXDbOuYrvBqg?=
 =?us-ascii?Q?kQWpunJQ/nW8zNEAqjWodZ9Jn6PQGqaRrnOM//aKcvr8II9f2lvRimkWxP3Y?=
 =?us-ascii?Q?wi2GoxVce81hJ8khAqQ16sO5BLGSTL6wT+2V9E3NEjlHCK7NpLa+nH9jLLea?=
 =?us-ascii?Q?GKhcOt1in4U9QT988eBR6kiFccxBtP5GYu71MFf8Cch7MJcDSILDtwpIlJoy?=
 =?us-ascii?Q?DZHivyiGXAfHQ9gwp7cGKOF8W4uIgdg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vu4xi/y7iTPCTf/XyRwCo0UIq2J/tgXhQRLxmWOkwt4rcnziCp3rZrGAdDZJUl1xULopJzLernvTySY2Lfxe+MOh5DeYtG4HN5KqLBfRDC3mKyg+cUqCAeVXMiQ0tlUsvJQUEchGO4InxEkRfp/2vUmU8rSCVS+6XvD3SGmBL1+5EUcGNKa6uxfDxuY/8/CrjuQ40jucjj5SsUnhQ/U9qpLeWh9xmmKX5rCRBxFDZ4wXpx+UxS/uQW/Dd1QDJ40pvqX2Nc/LlPuQ7Mg7D9k2WSWXq5VPp707NUJKKP6tE2XJkAkT5OcznxGiYoW1kBpHl2CioVdVpVuriUKbOCcdJxifdYuqR9u4m344U4oeC7uYs4V2Fa5gMJOFQU+tPxqynYeMYrp62iOfu4V5RwkpwzSD9Rq97jaz1L7iy9wa+JYYgpv3aqsaYeC4r3eaFwIP1k8hQivP/aWrzG0kaiubSQjxMHsW0faDCXUJ0ZkduPHBfYKLhIwO9e7Z+kz1xJHesFvzN1Vaf4PfGdfLCZG5+aMkvSnr6xL4Y7k9AZ//Zqb8pOlhb++f5vBR2xDXigp4tZtf/F68QZ1dVK+/hR/G7jzQN1d42gXJVqP2UrLok58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f86032-2500-4732-7cce-08de6d6c5429
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 15:01:57.1352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v7oLbMkzuo124Dshy71EGeLrGhsu0EPURx2gLCcBWXyilZxJ53x8MrepSgYLyTCf3Fzz3E8OVHd0uHE9HUsi9LwXIbNOlKDVbcAU6UiDtr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602160128
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDEyOCBTYWx0ZWRfXyqMtBEjy+GSC
 gLRYrhRv6XLiE+72cOZZ/E9iDZSeDXQot15JUAI1mJgE2OW0ddTdg7rNwDjrjvOpVKaxcGACdc9
 bbbyu//LNEz6khZwsLvobpPobhb7XCx15bpMPIFzNerhcgPuSutf80R5wbWgEIVQ5pR+/WqDZk0
 EuNOV4Dokm/qX+gNGRPIdrNgRboFAgUlMCb1r+xm/yHZQm8tsmF9uSMN/uilDcBZhwyr7/gqGdB
 KClfZz3R2aU8hNNh2A+B2XFwvBD0wFXmFLrBP6jra7iLpB+OFeAF1VHLI6l58rW+XljJM22JRy4
 qhqNEzHRD754q3hxZyl0d4QOZ7/Ubkzw9Gtu6MF1/wrq9t3PmfScXUDhi0rgP7jHQIEeNy/X1GU
 jOjd8I7NrwENFTCTvCkDDU4+/gi/1jQojKCaJaqF6hCkfFRs8RMl2pbnQY+9AQXxPAmpY2F+Sc+
 G4FgzM1u+kepyRDEFx4HlnYpwtFKcjkxKjtGcrH8=
X-Authority-Analysis: v=2.4 cv=Saz6t/Ru c=1 sm=1 tr=0 ts=6993316c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=edf1wS77AAAA:8
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=hSkVLCK3AAAA:8 a=yPCof4ZbAAAA:8
 a=pXt4Vis0h1HzrPu7K3AA:9 a=CjuIK1q_8ugA:10 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:13801
X-Proofpoint-GUID: o31ENlisyuaiMyVUjDHBTmCFeRC9Cs5g
X-Proofpoint-ORIG-GUID: o31ENlisyuaiMyVUjDHBTmCFeRC9Cs5g
X-Stat-Signature: 9ach4cb4ja81ecwx4ysonrjkz8z4roaw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9EA5F1C001A
X-HE-Tag: 1771254133-395794
X-HE-Meta: U2FsdGVkX1/LIbqZVxphj8qsALtWpNAPMfwxIvUOHTkHOMxl14bqdkx6CqyyOADWrV3EQljmQ8RgMuD1N45kQKArFupamY0DZhlRZAbxkJFt1Pvc4q2sy4f8/YCA6TF32yBPB8NBixdYgK5FuO1/ZxrCLoFskUEUYsJbaxP7Bb+QJ5sUaQcsLhpyFS1dW6d1f7by9L2O4qfaw9LJUBk+PczUzAoB5/X81mLiaZZ6EEWMSe8poe6BuUtEYhRFrF5lQgCmKVxzGyaYKGKW8rcUyui1vJ3z97QpTCWB5Uxc4IN8U3VgIv0pyZKStqOsCiMtA2iIQ0ya9U+7RQGhJrDOAOixB7H6JCWnLAFksYOcuIC+Y/B+IcOelC5qpgUsL9cTSkU3ZqbMuuduHw9ab351QY3QKbWFlA+3SNX4anUUXs6fQCv5dUZka3nXE1aCay9JmePlG61wp97tgmH03J3QPOgdnHhNQ4rNkPWlVZNAEa5whuk2vz5XsMm505cDXQDqk05XtySbMNLyJTKv5wMg/QD5Fd8CvXUtRbcnFXFRFIOx0oqXid93XOdCgEYu2GV8aJZt3MQ4RWzAtI8xKaybpeLG1jFimMSCFIwsK7lgcVs+W9ZbINRkTw9dwNHdZETid7NJIQn8WrLRd3Tbe/2p70RuQEK3CusBzGUun7w+4iZ6MQVm+YTHJsf6RGSs7Er9kyZZiDa5pi1xsTpVWizNgc3Ic1yVbeP4xmUm2atlMq/5/VT9LnfvD+n8i1kConZdkK0kDhI5nhNOYtC2mYQEUPUMPqGORtOhP1v9wWh1Jrec+BW0dtWZUK6GVVruM+IlktzLN3pLWWklj/5PiT0RUc+Qx5hnTNasYKpDNeJfPyN6yWQ026CqakAbK++e498MeKbeLxKb9Nk452DgifwmQubkFGTslaHIMwIzTZVPf5rES2uGzn8lOvzvznYj9HtuZApFBYb6WMt9XTNPvdV
 srmPAVru
 QNP/MIeLE98BGEUqKLOvQkV5/0MD7JPKbwPyCfWUel0dncPHk72SkrisAFqMztPuDa+TQoQKEhnA9A4UQJFr9pwcfG9KIXydnE+Vvd21Y3U77bMxFYYQWogYxk4TbsTOTpXVTivztgRBUD1HErl516UiiAbpremENn11zcwaR/9o3rzvaXzlqiotK3921n/YsSUartBrUDKPJk/9yci1i9sx6puZFAzHBXvX55q5cDu8LsoMEUrOqW0b0eiUvtixwpEShCv25BJFTgxo7gI+K5z+zakDYLZVs9pNN6FgTvpWo012Ti19quWqI1WIv3EEBghWt606hl5+LWexBnXwwW/fZXjirU5Z1AAbA7q1FKbXb94SIQ7OoOXo1SWtX1My4u9Slou6rEtKwV/l5EW1z4Cf5cMlHCvYHBabAuDW2TlyRlfJTb4pk003DYFcuWgK20J139r2HJeMUsU0Er4yrkK+VlO7XxmVglZCf5CQx9bDh3UpB+IqFuA9VTeino8VFU9hUieCQOH/tjcvLsZKYAjaeuclhlzkPy3N3eMg3w+oqDvVkfCkSlmUiwSILT2E8nJ1nv6pJF6xpBMSWUKSL5PuGPz/MRYm0MLtmNZz7WLwYO1uMiHuIcdiVKDHJwYljneLcf8fmm11Ft8/dkiRRbfH0Gqm5jtsX3MD5T5yZBD2ql/skijWWgbCuiOOOn2mTDR+bqQA890qt3TcznkX93bhVeZ4YclJzOJ7Fbu3xXhypXzkmzSaDgvBUZA5kIL0+9xopry4G3XdN7IhUCbOaX5OaF/BZ0yWHe16i8o/cQGd4B/Dc354azLBcTanKZcWJRxuihP4uPteE+8KA3HpIkBf59O+X3h4n9zzLADEqBWfyDf6lOg0JLUuw7QHeYE3d+8exIs0GgcE/LrTQ56dYpf4ajQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 14, 2026 at 05:45:35AM +0530, Deepanshu Kartikey wrote:
> file_thp_enabled() incorrectly allows THP for files on anonymous inodes
> (e.g. guest_memfd and secretmem). These files are created via
> alloc_file_pseudo(), which does not call get_write_access() and leaves
> inode->i_writecount at 0. Combined with S_ISREG(inode->i_mode) being
> true, they appear as read-only regular files when
> CONFIG_READ_ONLY_THP_FOR_FS is enabled, making them eligible for THP
> collapse.
>
> Anonymous inodes can never pass the inode_is_open_for_write() check
> since their i_writecount is never incremented through the normal VFS
> open path. The right thing to do is to exclude them from THP eligibility
> altogether, since CONFIG_READ_ONLY_THP_FOR_FS was designed for real
> filesystem files (e.g. shared libraries), not for pseudo-filesystem
> inodes.
>
> For guest_memfd, this allows khugepaged and MADV_COLLAPSE to create
> large folios in the page cache via the collapse path, but the
> guest_memfd fault handler does not support large folios. This triggers
> WARN_ON_ONCE(folio_test_large(folio)) in kvm_gmem_fault_user_mapping().
>
> For secretmem, collapse_file() tries to copy page contents through the
> direct map, but secretmem pages are removed from the direct map. This
> can result in a kernel crash:
>
>     BUG: unable to handle page fault for address: ffff88810284d000
>     RIP: 0010:memcpy_orig+0x16/0x130
>     Call Trace:
>      collapse_file
>      hpage_collapse_scan_file
>      madvise_collapse
>
> Secretmem is not affected by the crash on upstream as the memory failure
> recovery handles the failed copy gracefully, but it still triggers
> confusing false memory failure reports:
>
>     Memory failure: 0x106d96f: recovery action for clean unevictable
>     LRU page: Recovered
>
> Check IS_ANON_FILE(inode) in file_thp_enabled() to deny THP for all
> anonymous inode files.

Great commit msg!

>
> Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
> Link: https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com
> Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
> Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
> Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> v2:
>   - Use IS_ANON_FILE(inode) to deny THP for all anonymous inode files
>     instead of checking for specific subsystems (David Hildenbrand)
>   - Updated Fixes tag to 7fbb5e188248 which removed the VM_EXEC
>     requirement that accidentally protected secretmem
>   - Expanded commit message with implications for both guest_memfd
>     and secretmem
> ---
>  mm/huge_memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..d3beddd8cc30 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -94,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>
>  	inode = file_inode(vma->vm_file);
>
> +	if (IS_ANON_FILE(inode))
> +		return false;
> +
>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>  }
>
> --
> 2.43.0
>

