Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD93CCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED86D6B000A; Mon, 24 Nov 2025 00:58:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89576B0027; Mon, 24 Nov 2025 00:58:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51536B0029; Mon, 24 Nov 2025 00:58:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0B4C6B000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:58:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7816D87CDB
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:58:54 +0000 (UTC)
X-FDA: 84144446988.16.DAA7B37
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id E173D140002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:58:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P2ztckWi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K2q1tH9o;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763963931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXNgoacK7jpEjR8tstdlJS0yufXT2usHevc6j1P6OoY=;
	b=GiQsGDtarK4Qvd4+4m3ojrj7WSys52DRtgpWTkYWbufoHC1uJbirQfbLJsnz/uf+e3teZZ
	NbhqKEdAH4a+XPPvgbvutIPuuv0+cjxHAGfGmKPBXIydBtaXUp1Karf3hlRTAkKkA/LcQI
	9HkH/QV/5Z02+Dq3wVq6gp0MOSumWxA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P2ztckWi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K2q1tH9o;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763963931; a=rsa-sha256;
	cv=pass;
	b=G7QlWliDOWyvFNtelPGWI2y03iEDjIyGh3F8XeIHe5LeFwAOKSY3suw0viwytYgOkndV4f
	FTusFJgtkqbkUXjKqzh8LP0TLIB6U1ti43rpEsbjIkq+AK3UNbO/y8fL78/iYRsW5rboYW
	y2Qn/cmdCNCn/p+BQuoeszLvK+wfEik=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO0NiuN4084593;
	Mon, 24 Nov 2025 05:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nXNgoacK7jpEjR8tst
	dlJS0yufXT2usHevc6j1P6OoY=; b=P2ztckWiJO6+rKZEG3bdW/SoUJ13Vx8YjD
	vJQJM0bgO7hwsDWVcfuxoPqP+7S1kzTM04xMeZZ92eTIXWtNUtp/b+0OoVc6VMex
	iUExOOHMEmhVv98UJY04KP18cc1ZgXhipy1vmaeUPEWst/TlHDOD0rykNIVxW7O+
	n1GAzA469dJXyAZU52f6kuHwB0mlSIc2ipAfsvv4Mh6iWSwbUpLacDMRzPg623+F
	aXs/bBMxbyskCRxmCyCfq3kmzj/LgUR1Dy75wg2nl6dEVHiZVB6vyuDusp5Na6GV
	Shasjx2/k4c1LiJdepnxfr9oF/b252nYaeaoLK9KYhdXtnYFpZaQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yhhdj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:58:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO5GhNE022139;
	Mon, 24 Nov 2025 05:58:42 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012017.outbound.protection.outlook.com [52.101.43.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbf9h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:58:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJ+0/VcxJgzgQyGzHXS86d9YzMI/8HMCZ1wG2MPAtAxQKcHo3usF1D6LU6F8zVhZhUJMccGYej+VKPWzQ00vZP7jRMEJcvw87I4LfrjWw/4WJV2ac1ZWxbdFAEwbbHasseDBJHK7iylgs+vSAqEgvsHbTPrfSBzTP7cunCebg27RRTJgrqJlouCvHpxYZ+NQtcNTa1hhrOtskca5KiRQJIv23zLfXXMB4naTFYfIeMHplSvz3MPaxPpjfkf2BlqCgMpyI6VPROe0/ohEhcu07hnOI7tL3Vf9G2yFq4c4UNOQh8WNApKEj1QaKVfdbaaqTgoWZCljCkGN0n9XsCn6sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXNgoacK7jpEjR8tstdlJS0yufXT2usHevc6j1P6OoY=;
 b=G8Tr7B2oKkCbXYboipe/D1ZJJRp+eff5cbMmwAUfRx1A89ZPiJ8e/YYHI53UBUk0o6uzVhypFFes0l/vLnT1kP/ahVWmE0bxSG2h37LX+SWGzAc7Rwsm/RBXzOIADMTv16//ots+/mnwmzG1sS12TRIGty81dTRp5mWD8GNTyy/ClnVpKrKYO30elINuPai0b5qK8PxWJ/l3yqE/DJE0nJ31urwczWXiVm7TvVKsNT3Q7VAFZj7Jgu1PEbOZiOwcESEeOdQdGfKhH6yH8uP5y6Z28EcwrxcQ0cpAwiTPR7SUvhDCYrHo50Yj0JRioQ7feOYtrtRAEYspEUVOUbvy4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXNgoacK7jpEjR8tstdlJS0yufXT2usHevc6j1P6OoY=;
 b=K2q1tH9oowCx5XPJ5TDS+vl5a0406JkclmhOWnTUjCB1+TTVvIoJIF8tHv9Q5peyNNr5u1OvPZt2setHPPNN3oMIwqzbd0Qq4X8ACq3z1sC+sr/srZoxjzudtNlnd5E/mnxew9qOEHq+IxWmu+aLmHxdnl99NyadQy+CEZ+rdCk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB997557.namprd10.prod.outlook.com (2603:10b6:806:4b1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 05:58:39 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 05:58:38 +0000
Date: Mon, 24 Nov 2025 14:58:33 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 11/16] slab: Remove folio references from
 kfree_rcu_sheaf()
Message-ID: <aSP0Cd1RMXYfhS9O@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-12-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-12-willy@infradead.org>
X-ClientProxiedBy: SL2P216CA0089.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB997557:EE_
X-MS-Office365-Filtering-Correlation-Id: 632d0911-3a01-4e69-d3b7-08de2b1e836b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2IrkTLjuQZo/hYCjF0oz72gxM3z7P53RgaUq/C47eQhtBB1VWMv7frS6VFoN?=
 =?us-ascii?Q?uq+YAJ7Ibn4AnLE7Twp2Nvtca6O+fYtw1uaI9G3h2MNMqQKLK3miM3SN7KbM?=
 =?us-ascii?Q?GaTVOJ8eyFv5WO7aCbbixw/7Adn2NnUmQL9cTCQTFVhHySSYzrI1DZkLxCM+?=
 =?us-ascii?Q?VdTKKhjk3VgLLLhbHbn7kvEyEAEnI+Guslc24JY44IQAhfJeKNrpmk5+TTE2?=
 =?us-ascii?Q?sTPmgS25r9i8Py7U4lJE9ZjqHnO/7o2oYDSCj1iObXzddk5efx85YHgWpbLo?=
 =?us-ascii?Q?Vs3PB5gORHN+bVdm8TcNgrCwszOq9bQinmTZPw8D/9Eu50iA8fkiOJtRKPtr?=
 =?us-ascii?Q?pX2bI3Cfz4I9A2MReFHXbY+i6PX9loSZgyD/+kanyJ5yeKbQG/5AJl9Im/rw?=
 =?us-ascii?Q?BssrAmXByqpFZTDQxfQw00eiiks7Qz5fPwgrOkfxyik3IUEbrzHDadiQlsXX?=
 =?us-ascii?Q?4T+1xw08LHQkbCROb79wSHeEFbxdc7mIM5XclS08lWliqkHeYG97HXMOTKOh?=
 =?us-ascii?Q?lTx8R5OcYLz4hcUoovamBPehItzG3gR7nJ7rU0+CcUVSHfVWIRdkGdKYL/le?=
 =?us-ascii?Q?V1sQpTGpXgBOrK1jtZpVmowoZKK2AwSrkLjt8yGFPCgEOmi9iFbRXi0vYGdG?=
 =?us-ascii?Q?/EVF2SA5gH2Jk9cXsN8t0vPPJaJSQ5xr6BjWbB/mVWLCT7+CcOS9EmPQWn8e?=
 =?us-ascii?Q?cWhvcLUE5uB2XwaXy/8Jj4YkLNW9+h0q0cR2VQlo1iA3phsxcN81IU1BytYW?=
 =?us-ascii?Q?DlGfuG0w1ZIfCiLJDL+pEtBvuAg8ByaaeipcH23epv9PPNAlvZBJv2L34ZzN?=
 =?us-ascii?Q?5k5sTivTxg4A8tTP+OQ0Trt/yMoVXaG238VQOXQmq5EbX4PH993z9OKMbzRj?=
 =?us-ascii?Q?lN8vIPwwcM1eLFCYvXPo1QObcj4w5F7m2Lrgmv557aSAjYYJripQycdBgO+Q?=
 =?us-ascii?Q?89ZD2IEB+k0iv0dmlZ9OvXsIPVHNx5p2la0yHEH/aGdo6hGGO8lvvlnVWvWJ?=
 =?us-ascii?Q?0HfHiHb8oJMaYHOyxp9/wOQ70/H21gCq0/MzMAKfRGRZCOiCh18BZkUPsmWR?=
 =?us-ascii?Q?td4tPhmESORmK1eUDoFLpgjDECDmIpE/FZouGEmm6C6QJEZ/UsKiMa/ntiw5?=
 =?us-ascii?Q?0Xw5JyCP3W2p88vtrZMgi5NGSSATc4Xz1M8ZETOtoN0nH6WPw34p/YdiDxqf?=
 =?us-ascii?Q?BhdojWWSHFXZXuuONPFE7mdOXch8S7sOgYeY/4h3f1/S/ZXvEVqUWo9BYeRE?=
 =?us-ascii?Q?gBLdtb7hYqwOtzmXq/YfJTIcahQArv6OoP0+dWtpftXFj6K0M7V55c3/Kyxg?=
 =?us-ascii?Q?1qCzkkleLA/y/L7VJ9D6D4MlJdbUJIjJCy3BezzGJPlz0xeU+Uc8qpgyuKzn?=
 =?us-ascii?Q?KCiECGOpIJC+zkYT1fqzsHMsMkFpwje9EDJ5B1rJVW4ibP8RFkVOzVna/CQc?=
 =?us-ascii?Q?sML0xNyZKzV5HBufZmxpmeZGFHNJyfM3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RQrE/Aqbe61uTJWUYje/95wQzv8mFHVQu888fYWh1GSCxArsCqVHBJUYbtmW?=
 =?us-ascii?Q?Nmf4QihZ/7+yi9jYcqAd72L5Oxp/b2hO9jbRgOL4hq/lIvSYh5TH89deNwUl?=
 =?us-ascii?Q?L5P6J5BLZejqhJ3HUl9sB3BOTZktwup6hwBOhvSGj2WQaEURzNXHjweE879X?=
 =?us-ascii?Q?ZDpDDSHJ8dHSfaxONVq/w93nwXBwgKJwGoeuPdaYJIuetOWZrUgDGmKLMIrZ?=
 =?us-ascii?Q?RTeEWmJftj5GPuZRQrwhmGbEbcT0xoESwZ0yK6epvT73bM37IxUtlldJClz7?=
 =?us-ascii?Q?V06amzfqa+sUzNS4jAMYNA5bCIMIOsUsPgvDDpcEcYYXnBhSPldqG5QADSu7?=
 =?us-ascii?Q?TEMGa7HDfQ0fVYr3rsCGAcvuev0acp3x7HkzyGdzVC4ZPKhfKZYFRdoFRcv1?=
 =?us-ascii?Q?SdNqiAZAIcmvyijvMRyrRwwTRuHcOgW4kIA0OUcskOGWjFeMX1iMw2AdBDtY?=
 =?us-ascii?Q?Rsdp4dlH5M9YfmhzZzdF/IHeQx61U3P5eLsRj+fV89/hJRdJ3bivi+PNPORk?=
 =?us-ascii?Q?m48M1mv4K0svgz3ho6HnahE0YWkRxSluxYXsRr4uXeyaSTLOLwmAF0sQxlNg?=
 =?us-ascii?Q?zk90WVOmsaqlWCr3L46ebYVaYe0y9JJXGU8m+8jOiIsjREiiMOXwtzP1x7SS?=
 =?us-ascii?Q?XXN/4MyBMOcgj38SIsUaN+Zv0W/hwQg3zIJa7Q6NQuX5HR+nDmwOCI8OP0tv?=
 =?us-ascii?Q?Hmw5QtC1WzFxAfDbgby/L/ZASygEEocji6c15qgQKbsi7V+TamQ7cZVtLKvV?=
 =?us-ascii?Q?LAynStPjoEb39ZrXAChEbdVfaz59nvyoUq/IZt680FSgbHSb7bCsOCc7rN4Y?=
 =?us-ascii?Q?kKBgeOPPty5m+0EWenmWTt2gu3vyF9i5rv+aWdOOFOe/TKWB/qX1ToH6T7R9?=
 =?us-ascii?Q?J6c+sME4sCjtAX9hWlMYabxTTkBIeI03WDZh3mpGD6ZntnJ8JrFNdLNzCdxQ?=
 =?us-ascii?Q?C0sF+XOU+hDk+1HRllTRnuhI4cs/AF89SEb5ZdiFH0ma6hlCzESRxVqTeQ4k?=
 =?us-ascii?Q?Y5aRevLPdyY+V2B4rC89fYPiSDaM/vQeaLiH9OWpYlkb8p0vM+HR7ya0q6fN?=
 =?us-ascii?Q?rpK+XcRHxg8JctmoaMuK8XvKEenPrmjH7jDC30/XQjrda3nClvStycz895AG?=
 =?us-ascii?Q?gm9bm74aqV69Jyj5+TKDO5KhfKDF3ok0CygSbgHg8w2K1A9odVu3gJW96KU+?=
 =?us-ascii?Q?BNl7DD+fAALrf192E+e+ijaC/rD+79GQi6IVgDFHj80HhoNXJWmRfQHeaY6n?=
 =?us-ascii?Q?UWy33zsDjmrsZ4lJlxL+xSK2zJ7UyvhCinemBydZmzoxcOOZRTwXwyZTL0ch?=
 =?us-ascii?Q?9w9e1JvdGzaEWZOkjMUXhYJhI/T1ZVx87VtSqsY23+RKF45abCvgqFy3k2gK?=
 =?us-ascii?Q?14ezQktUGQWqV8qSiU+SjgIOME3n5lyy/DsB3UZcHolHisKwN6iOWzoCmXGo?=
 =?us-ascii?Q?en69Zp1KugnG29HS/OE0xJpxmoPx7YIdxQpAKclX6/YnFBBKAzQmnaIr0xNF?=
 =?us-ascii?Q?Cp60niauH0+LlhknyMMLrdZynBycs56AW5bZNaSCkM/65RoAMPYXCcgF4IQb?=
 =?us-ascii?Q?kU4tolvkjKagOPVNuZhE7+C6MThKck21yT5LxyPb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u9Iaax8Evm5FYt39onWKvzq1TnpSDuJcsGm0q0T7M5CXpq0rLFtGDQcfLomWJvhaXSE2ogdFJyRRgN64awp+k/p1q8W3Rq5uaiGZPjEW7ceMtDsI4YRl5mOzlD45MUuNmRCoFI94RVuqeF6Gmhu6Rd1rygzu1VQhbSMcXdT0ndOKlHD07iGzu90UjEBuCl5OMhOf0728vC+8nVupJEI4YmKEBUWB2NWft9YYBBbYfreAVRdCjFWOqiSFAHX0mU2ENHRB7mwk8718lziWGi5CKwxreS5RpTliwR/QTMxu/Ht/YxdKbaP3DM8x/q5fJCcylpg0mllWRAu7IYkCuBcQOvrTOsmN0jX+gfIn2eqK2NObF+JFw84W5w28pzmNNwuPgEQwhMD8yom+CMF2ZC4lALBgNeUWevoTSRc0jR1csZsYFihV/HH2Pk9UQAGEB4iIvMrTOX4DQVUgyusnWzdCygbgmbZpNGw7MgeVxN4klFB8F7kx8xpMbm9dEz6my4Y85mH/mzVkcDGF6RSJ69XEdjQL0eBCaYbELt+Dl2Uc60RmUuL6WLws4r9rbYbpueS99kYNF3J+5vP5LB6FnRT1hFe0FvsLPfZ9Xfdq3YSedwQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632d0911-3a01-4e69-d3b7-08de2b1e836b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 05:58:38.8420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMqW1NztYD/02Bw8woDMWPWTM/71bfQRgyL9JrepFeTeX0Ih06ubdbVMEzuhXFRKex7wJMlhWs3xapv+haEmPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240051
X-Authority-Analysis: v=2.4 cv=L6AQguT8 c=1 sm=1 tr=0 ts=6923f413 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=ucx0ysRx4h0l-kb3NR0A:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA1MSBTYWx0ZWRfX+prmaUe7jeSx
 0kiCRkDATa3CMm4QXNdt9qOsTMiMXzWAHQcaYvMSPPxphCgDvVTAGaLPdJxkL0rmC+YIXLKqzLl
 QYp1aJ+Zter/puOchDExHmsYEt7UZHILxml0fEBPbj//eJd4zWrExEFKjyJqWoIJ+U0AWrNpEVM
 ckD2XsCN43lmavfpmp8YPgDa4EwYOmGD5Fau0nBvh4gDGBK7PmusRc3u+edpWlYnzWAQ7YUw3w9
 Ub8otyA6EWqwN6ZsqTlE3C4pnJydcaiVnrwfvOEMjpG3tUSGt4CVfk7JaJT8NB2o0tXB0e82WmP
 adICR/+kezaUO/N6FePR/sF1waR+jV7e9wTr0tvEK7CuXQbIoU7s3qu3NlW1sKPF6QCtlPQxJd9
 M8CxGZJS8DiObBvK/1VCN2ZKElWSJo4oN5TYh4O0JXjJjEgp60U=
X-Proofpoint-ORIG-GUID: MXvw1sKKielVJCsOa42HN92CJVNb7fDm
X-Proofpoint-GUID: MXvw1sKKielVJCsOa42HN92CJVNb7fDm
X-Rspamd-Queue-Id: E173D140002
X-Stat-Signature: 9whbyi6wiumigycmcqzj4frx1kudxrz5
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763963930-65385
X-HE-Meta: U2FsdGVkX191ekjoDz9KIiqvCIO0Qxb/++2FkGdvhkRUhjkbvWBwRPwrw3zK9vm42vHuTw7PP2iAJJProAfSP2PSqF9gUt7o1ofPKBLGhr3mi6nWTB8KVipILg9O+h1srwupEo3z3yFPCnq1rHPl2rSrXRTTLO6uFG5z9SaEXKBj9ztnVnJQkC5UkWreqZcKRWy06QOnan87D2Oj093bFnL1YcDN/Tb81X4vj2qZQpll6qPCY7SCYPeU+z27ze/WMt/JwucdDiHHvgan5jkSQ+SLZXaSeIUD+tgkvsEXljDZuBbYYntu7ongCFcnE3cr0Co2/qu/PSvgBRIAAj1+bz2NeN9FZCnhWVt6aoD1KFoyYjmxAZZ5Qvh7OFiQFZzJVRHcBaidOHudSEWzZPCzMgoCDcPpR0J2ETkAeo8E9IqcqPKeWYmg5coW8fhHltT+lxTxBnZPC8OzRPwyvOLrCI8JACaPDU8htFW0dCnWMwCb2LkxeC4xAYp0MG3QGPMGMO25r4htLJMKRwVbLFlipUpViclxgGlprM5PnpyzrsnDSInslQhz2f/+Y4Aw/Gx/WFuIJ8XmzVw+mxkmkbByW8102172ZTkzkq5HzKiHZ1rbQsrfSzAv97G2+plVvETc09roL576oSnmBMqPK0DBD6YdluSc9efqKTzHNySBQJ8z2v2HVZfWYTSvLwf7sibazAgIqxoVdBa1NFGbBw7ip7tJERcrMrpg43ULAUIr4R0icrtY0mwAriY4vIfNSYsqiTaRgQv3lSxJSoedsFDfy4UH7sGVOmY6IqYFaf5EBFn+V1UAedYk/QStbatS+/KUGGk0cxw6IRFMeZ60pRl6J6xy/M1izmjKqWsYOckFZzFGyQrP3bT9hVruBy2wY/04kvhI3MPx/4xu77N+VPklm9GhqrDkSKMvpQNfoyHIuDvXm0Jqqme8fXVm3GL4WTcVWMQYpg1YGGe2xxapRVM
 9lK2gy6T
 p833Lit5cE+0k6BnR7GewvzuhZQ0jUFk1ZLwIp9y071JgCIacaMnCpk6hejGHXDj7RXmLchctO202XUkBkKrHNhO2KhWY3GQKn3i498lHJd9TCrtwvQ8e/ag+NGCmbrbJOhklL0hPKbw2jcUFOc3h8CL6O0gNPIxPuolsIaC75rCmTkf3NH59QlgAl5u/2NJgq16pCI019imSVrRVJTa/JUTE5qwAZL9VmdQLymzcnamhQ2KHeBUyH1IKzV0Ur2PwSZJ5WOdDQB0ghylpNOg3TSgc98mh7aj5BvrhlFN895z8SPJvi+t3U2TIfXnAGuD28uCapK0iyRb/S36OMk5jLq+nYFnu6eAmwYxYTI/TbeDVH3gRuPz3UKbjEKij9CEKoZm/5f9lBzEARm8eCkmJGqTV0ymzghAHePebz4p8apoW835+g9mA1lGUk8UTJSIgyyH6rpqielIPFTn3OV2ZBuoqwWHKad9/ISnR1Nd6K0LRz4NTU8r8zMgyOpweQGz4Gi5YwwUgbDiR0bvAt7Kxb/w92HCJ0AoCGA/UUGvV0Zle9ctGF+EcKQ9CLElokhprcZmiKtLoyayQ64hYYyCY4uP0Ov8GURXrkymY2IHGqrDiAcKQl7X41ZFjpSt21XJeDQqmKG0BWVfnUyF18dPrts93/TwAVJrq1TPpTbI2OsfdRkfXK4s0b/DCSe1RYBhUcMBOKCAVPSUYTjC7Tj1NoYeG9DENnQ7moGDZqAJVsSUP4GQ6Bt4AmL5R2B8sJREXPPqe2ESTLp2fAPjqV75hkt1OJSzrMeQeBQvd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:25AM +0000, Matthew Wilcox (Oracle) wrote:
> In preparation for splitting struct slab from struct page and struct
> folio, remove mentions of struct folio from this function.  Since
> we don't need to handle large kmalloc objects specially here, we
> can just use virt_to_slab().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

