Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A048DC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A126F6B009B; Wed,  9 Sep 2026 06:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3B46B009D; Wed,  9 Sep 2026 06:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2636B009E; Wed,  9 Sep 2026 06:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8E66B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:30:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A07BD40179
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:30:53 +0000 (UTC)
X-FDA: 85193855586.30.CF86AC5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4187A14000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:30:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="R/2mLaeP";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QNKX8T4i;
	spf=pass (imf23.hostedemail.com: domain of kamalesh.babulal@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=kamalesh.babulal@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5Q8Hak7K2UxpsMDnY2p5xTOofVgX2uQwF8u4sQCHBJc=;
	b=clkJ8Hx0IlWSKrRyNfGAFPwHrKKrrFz3W9itoRmjq9CrrXYb+jVegTZcknv+DfS0sdkQWt
	NToYx0/ekVsTPTRtPOCul7Vt4/c9zFdwPWduSqWUa2d8aqDiIrkmxaTquC8AZJKdnjvxwg
	MUou+9FsXQz8iVvwkbQaiFT3pYTSAhE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788949850;
	b=gVpdVhkJlWj1HH/2pczZ74F/TyWr3LB0YEfJVjbkP2R+CwrFbNE9VOGjOJNxo4CKTYhBeL
	YbcG09HCELuJ1gH6pQiCngQTWDb+ohT4vJkp0+6NZoclZfTcaYivEU7kWrXif563TIn1z/
	MIRDRDwwkkewfEJ77qU5BDrhwi5R6G0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="R/2mLaeP";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QNKX8T4i;
	spf=pass (imf23.hostedemail.com: domain of kamalesh.babulal@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=kamalesh.babulal@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68920ZJU1067529;
	Wed, 9 Sep 2026 10:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=5Q8Hak7K2UxpsMDn
	Y2p5xTOofVgX2uQwF8u4sQCHBJc=; b=R/2mLaePQorG+cDvYhxPBHnNdeaj1Ry3
	/SRCiWVUFeW6QgzgAcMvUUu66Nyfhl/+PBjW4CeblHX7+6vAuWoYrSTObz9AqW7P
	Mqpd/DISCykaViCuVtDrsmk3W0C+qZFdWjuLyaRHFXvD+Zz90+pJdvTetTRb0yli
	1Y25biAaIOoItzcNsenjoJ+iGknQb6m83tHiAVx+BI0ZxudLMzKTUnH7/F4eOBhR
	ivSvkcpClacWI7jxpKipNe1UTS2ykeEwsfeIEwD97eelCqGQfP6ccD4/rBzlfCD5
	OKFPoDHZVo96CzAndwA1bl461Jm6/3qVafCqb5icM0uJASk1EFRNUQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbg1vwy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Sep 2026 10:30:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 689AUQPt029355;
	Wed, 9 Sep 2026 10:30:45 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010022.outbound.protection.outlook.com [52.101.61.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh755g1nd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 09 Sep 2026 10:30:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWHJs4m3nc4l2zXg7Uepn69cC3JL0V0f9JTIBJj91+pTebvJaXwxbpmPVTzHyl1LKfL2ZDCfDXdEhDydZhRc0QVvxBbPGHXPDRCel9yZpPjNGEdz6g0ANE9nKFo1N8gO0+GGEI4D3HTTp3X5UZKqmIT4ZkEOJhxKfksXdsErdqtOMxpJ7QtQDe7yAGUKZqGkZJ/GvjIrvLxBqNNoHgZrapMbe7Ye0ZUKscwk3CI13WBZspInhTOzFWx5LmcHk4lCQVL2F5RSD0jMoy6AWSntGxMGWx6pqbtUWrEQxt3GX3E+NTNzsigShpPN4Ol10+IfX7uf+INkkRJ0gTSX3lEBHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Q8Hak7K2UxpsMDnY2p5xTOofVgX2uQwF8u4sQCHBJc=;
 b=fRQQeg9XaM8ggufGr1/9H8zWeHFUdivTx5UWGpv49I/t9BMSJdBAe+ElxXMT+TCSOouyPWx8+AJ7eYf0Ec6nd03O4fa28OU6Rv+L9y1BuwVJmpmdANg4Ucya9ZioUmRfVlWhKpwuUmqthu1+KxEsiags3QxJD4kovXEa9GL6RaakTSC/C7Qi4nxsQUIgm4XCJ0wZNcEwe7gMOEQ8V5eAm72HEoeSSWG9yr3Rfwbs/SEs2kZ9vvS83K8LysUnAxWarHQzOkniwP9+rt98N9BxHLRUdgaODUZIWpTsgdUrDskjzcc2DT2GQs9M/i3a4udmAULE763B8FVN2uESe5ahtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Q8Hak7K2UxpsMDnY2p5xTOofVgX2uQwF8u4sQCHBJc=;
 b=QNKX8T4iRPQcG+ILvHfVyp+is7B+uEulRLJemC0TAYa+ewGwRHY1mawBKPC2WqxNHOHzQDm9+E8AMvTdh0+UKuKYI++jsQxXV8lvKDJJPwo57WgGTxJf2718hTgbe/xqEIFtQbm0pvOeI3g2FHA5EBObjT1zR2Mh9f+H2UQO0EY=
Received: from PH3PPF8223ED5C3.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b2) by IA4PR10MB8423.namprd10.prod.outlook.com
 (2603:10b6:208:55c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 10:30:28 +0000
Received: from PH3PPF8223ED5C3.namprd10.prod.outlook.com
 ([fe80::b1bc:e535:4663:c977]) by PH3PPF8223ED5C3.namprd10.prod.outlook.com
 ([fe80::b1bc:e535:4663:c977%7]) with mapi id 15.21.0406.005; Wed, 9 Sep 2026
 10:30:28 +0000
From: Kamalesh Babulal <kamalesh.babulal@oracle.com>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        linux-mm@kvack.org, Kamalesh Babulal <kamalesh.babulal@oracle.com>
Subject: [PATCH] kho: docs: fix scratch_phys debugfs cross-reference
Date: Wed,  9 Sep 2026 16:00:01 +0530
Message-ID: <20260909103001.2423403-1-kamalesh.babulal@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::8) To IA4PR10MB8495.namprd10.prod.outlook.com
 (2603:10b6:208:55d::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF8223ED5C3:EE_|IA4PR10MB8423:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b473008-96f4-4d17-2076-08df0e5d5d59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|56012099006|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	gIdx7eXYsEdUV7XFklC13/h9oDyNuW3GwUnZWw4m+dIA313L4N0IqcLfEq6j0+h2iyaMkVZLPEOHJ4032uRgNgZLL4x+kTtOM/RxHLSUPZHhKxW0oTQKEodtb1y0YTqD706bwxAoGnfLdbpe0I80m7uLFElj/kv4OsJ6BLSN8qcTHXHKDeyuNwiKglw2y/2hVvMn4BeLZt1ub8BbzvPSpwLD8ajpoxKCCD8Bf4AjpJ+0/zzvVOmvhzJ/UJ3b1LgfF8MAe9qHEXDhOgwpnJXoK0TgIdYzDuDn7plSpxAZieJCDzLYFPojAvx8+04HCyWDDTqn7Shyx6+b7RogNJYxZpGM9oDW50PY+InmSTqZujDVUPzR7mkp7mYjoLv61NDh5L62wYhDV21gBtCcKVNSNtJVgBBMOVz8WL+glb1N9r+sAQpxq9foeDRXuzC4LGjm+bbLaaLiRDhGa3PzLQQXaPWBXJ1Ao9L+bxTt1iUhYlGXZ5p2COX98fRIo+GdqIrEF4D1cvycWdeFs7z095lfJc3Pa7Z6xJcKSIE7oabN3W46hEWhdU2spP+0rr+0aM17zDrqlN7LEcL8YOVNO8RiU5B0OxOoNZvk0hVeIAxuH/lBu4wTlYNJHlcBqd8SDlbPVdMJB692VppB7iY/ZBXbfKpem3Q2IOux5qQFPogn8KQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF8223ED5C3.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(56012099006)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cbe9i+a4takQwpLshH6WuY/K00JjYkvlJftuBCQii4H9Gmgs7RZGXVMmuncO?=
 =?us-ascii?Q?g+SJZzpsulglhDf68RVe9r8KMLPYEulGPwKdPEuuPsrtw46Muen3fOPC1E06?=
 =?us-ascii?Q?QHaq+lsGaETCa7cuynXij1yqmHioe6CFLPtL6gY8iXFs5GDQHW2z5/smTD8y?=
 =?us-ascii?Q?DeZ1ezFl8G3SJOwunf/BuI5USuAuVzu9xRuXwW4y4550BVVJvyLgJABSjfy+?=
 =?us-ascii?Q?JyZsTPJNF2+jXVPvqwHziRXvmskaJSoxh1842DI/O7SrqxRwf8dn9FwGzfYr?=
 =?us-ascii?Q?67CCqGFXMm80sdhIZmSA8iNslcX94N8FNBSWYogBNSX/RNZ5iyHD2C0RCHMl?=
 =?us-ascii?Q?RLNO5NsZQoeNPINUnC/+bV6Qyr7A36JUxsFwyWvFI/zgPC3B2Swx8Oq7tVrz?=
 =?us-ascii?Q?4IoMZ19An0W5+9EjwwIzGiqVn0V11sZgJ/TVVRQwAEUYQUEctAzslBuLuhYa?=
 =?us-ascii?Q?h7BN7LHnq16lhdcDCszzmSyR5+aCoVKbzwgbkAGIypNYXpXeaiB9lN39v5M4?=
 =?us-ascii?Q?4Fn+A4qNGogmE8pdwmTyzItSdqJfT/6yb8aKDMFlh5WpCoAN+vLjBz6Z1P9d?=
 =?us-ascii?Q?7D+ptnuNrFZVkISDqmfIU7fQSIcjsyhAWkzkhcuwEagsfjBBeGMgM7kJ4bDx?=
 =?us-ascii?Q?ouj/6WcnhSjpqVRtyuXYq5cAX0EGOVFIiDeCajJYkeIsqgMvixUuPmVKHPGs?=
 =?us-ascii?Q?fGDHF4hb197OrOviIutRmC9M1I3WpTLqZPJvUKKUy+roEr3XWlNNrf8Q9dwy?=
 =?us-ascii?Q?JhmrTH0LWoTcBSRyH7vmtuup6Xx1jQUpzEpRbcxvDi+yoLnLJZfbYAvOxy4b?=
 =?us-ascii?Q?0wJ9yfSrSk53YmW2pKywDxhuScIBVYGszssAsN4HlPYphQnlG1uIrj/GF3eE?=
 =?us-ascii?Q?mAuR33+9GqjFw8C69JUWWFvZ6adN8FqIBteb2LQAMDPxailkLdrYSklGOWxw?=
 =?us-ascii?Q?XLbAOCCcbHggXzM4vGoDwJWIHcHchnuZF0B1PsIEmEYCxTAwQ7w2NbbzwrTE?=
 =?us-ascii?Q?7qlYYozKA5jfh4fMPmBA1zzJu1aCvu4KCP/bwDFNuPTi3cFdPBvlzDaA8Tnt?=
 =?us-ascii?Q?lQLfX3Vh/DYnOi/P2WIFI0b9hBhozWmgi6mqCK7cvAQolEeebAZBe/LCrkC2?=
 =?us-ascii?Q?JSRHBhRsB+LnS3UQshQveIIhL2e96seRwkwjR4x4M4AA9aictRaqgG80cvxG?=
 =?us-ascii?Q?banZUgFWHKXj2vWMBj09xmOYAq3yvV8AVGlRtDsUj8YyxPrTTXb6G0MDa7HU?=
 =?us-ascii?Q?ZvYg6BVKZOmKVU7iGcQwWBOFPiZEDlbNYnbGBPOT7SRFQJqp4Go/UJXRauR2?=
 =?us-ascii?Q?NNVleLYKGlML4aVv31jHeK2SVE1BFH2nODknngli5NeL1zs45FHsPupQSxFb?=
 =?us-ascii?Q?3AFqmfYQsjIVRSTteON2sAKcKScyvMqyWOW8HujNk9qbheYnfmTrHYJZZgOG?=
 =?us-ascii?Q?ExHpqJYkU4HHklUmFeMi6xNiu/yayXvl9jvDWOwX+WP5SY1L5W44p2X2Vw3O?=
 =?us-ascii?Q?NYINaF36HxT9Eo+5qsO3HZLoBfpePrkBVf5Q9n/RjyMOKiVbEAF7szBK/nXt?=
 =?us-ascii?Q?Tate+w66ds/gdBmkjzbPPl4rfO5Pv6Vi1J7X2X6K14k11GZb8sPHzsh8soQ7?=
 =?us-ascii?Q?twbtTopSkyMCZFxOAx5pxxwwji0l4uwVKPlNcYqkouHtjIbv26O1fm9nGt4W?=
 =?us-ascii?Q?UViWSBsp9S1wpTH9XQy+DBO1tNxh18cene6OA/mOB/FuY8jwF25lRqj2izFb?=
 =?us-ascii?Q?je3amH12LjteiVwzq1SJ864agHqL504=3D?=
X-Exchange-RoutingPolicyChecked:
	q6fN9bLrYDbldBQ7eatdesfaXlk9zEl4piOr80izXwokPZdqPvYEPzirWrhHlvJfHDmVMZaikdEDbncgFTM55Abzauz0/9ky8E8nhJTajfIAe09nkInSOYNkRO/jgAll7VTvUC1CwQy0XsylJ6V3o9OSkVzmvV32WoNJpjEZYEIbBzGbjpwvSEtUv7lyl0OKAG1POKeYarc2tJFZBYz+BImxrvlP5a1qwA3ZSZTKsDsn8D+Mgzy8Dv7bs7L1mxxOJxESWeWeQUbLjVlN2muL7cQ79wAL/wiBT/9ta6af7CaPMvSWpUopMlU6SFm/nS7ksuozuj2K+kvIAiENivX5DA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZYc916QfFyuY7Zqd0XJJc3sj+zt/Vq3vxygKwic+sm0f5Oj2eUAohEsEZoUv8VbhAVrnfQNK8QR0kxtkZamK5bl6qOTXmI/b9XdZ0pSEAxhoObfGy4qq3hF0/Vr8RGkuR2Nn9906QobUF0BdvKlk/J8BYSMbZRH29/03rpO/TW4/6gYaNZdKFy0J3OKCUFvhnjYcH7xkW13dhx6lMYfuijwHs4f8Q7Qp/xnrfPSLTSz4QebyASntJWHHKs3Ipo0J7u7N0HeVJyoUjoajPjpJTxXn+vV7lnRH1WIjDPJreKuYILJIZCFqVUzGoc+2635lIAzQC3mM8xfG/m+wamU8qHO4KYPM58/CzsdjHWoSya9JWdzH2j3uFP7AwaC5f0TjEAgmDCBufP8aoddS02jeSd4zYkXwAHTAvR+SJ1VOYbnJtCu0Qh0u2jdzPJyJJg+ihe7PD2KqTnpohRfxB/j1kI2Vi+bfLA7OWV6sNCjkQgMHrBFBBpg0opuv5jb0ElPZ5UDQpL6sC9MU9Ira5Vz3oD4OB2JC7UrwKnDp5/GzHDGf9/pyOFI6ihPh/T7+ro8Yh3xq4up5vUe5IDpSBG49MS9o+tuJUselOBYJk3fmJVA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b473008-96f4-4d17-2076-08df0e5d5d59
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8495.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 10:30:28.5876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPY0Xh+U/TzaVxWf/STSti/ckL9doTStzbeEQqIs9dVoJZo02Fabspw21OoHoj0TWLXZhkUzBNDPd638Rz+LWXy+Ypch6xer5Dhk8AXIw08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8423
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609090117
X-Authority-Analysis: v=2.4 cv=VpYTxe2n c=1 sm=1 tr=0 ts=6aa13556 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=xs6HkFRCBj7ZSBH2Z8QA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12108
X-Proofpoint-ORIG-GUID: ohPC_C1aFHPHJ2x2i44fvpAh7CaJGorQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDExNiBTYWx0ZWRfX55s9stJOC3Eg
 M4OqCMFjWX3j1jJb0xOemtTW4DZ8lVNkRAgns3t5xBqhapYEhHXlPQTIm/xeMn8+CTxrXU9536U
 rZ2/nnOm9tbWMy9QSd9lj6vp+ZsOuLFb++96qpv1XRxqIXqSd4C0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDExNiBTYWx0ZWRfX6Ub2ChozxQap
 6fv9lIddemyjm3FEOrwJApBYV87G2S4uLzqMAHDoFcGnq9a3Xf5hI11sKYUUz1AdvuAUmLZ6nOh
 rBNLxcSMk2MOE4bFwFLwMQy6JEY8um6n23qOamG5CS2ChlzjvdwFGNn2h+q4KPgxeiGNY48F9mK
 wFjPvyKALDelyEYaUPGl9xR4y2w11zsOqYFZCTnffM2fITSoF6Pf8VXNj+CZf/k+bUWwT/ZVITx
 OLuVKRC57XmRzIFWlFYT/hrgvhQcPbPhEao2bQUhT8d5nuOKWBY4VNSwU74GVdO4iEv8TccJZFa
 yItqh7uiZ8qgk1CLMn/QBVdKZ5uHLJg5q++HEyKjXYIJC7V+5t44Bkv0vOqtEcBUsNO7M/+RFxG
 kQ8AO7FoXvQIRtMYtnYeBWbLJuRmZHbnrdRyoOLQgQ2uswNpvJN0q/Qt8ATaUXGRIFaViJLYxND
 BDgwlZQZB3OcKDkNeKBOAyUvmM6vW81outrebugA=
X-Proofpoint-GUID: ohPC_C1aFHPHJ2x2i44fvpAh7CaJGorQ
X-Stat-Signature: rqg6pbfktszhskej979siprq8dozaxrt
X-Rspam-User: 
X-Rspamd-Queue-Id: 4187A14000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1788949850-968643
X-HE-Meta: U2FsdGVkX18qHKUgmlzS0Ua8Tdrq+sna7nLS5tP69rtruk6vCtvoaTmFeO/c4sGl3IhIrZfO4CxmZj9hO0FuwPllYGCYDAVsSIstNlOzXily+XIby/JYV5gcqYa5Cgro1vO96GvQ4JaCRz73B77lRsDGc7UHBuljq0H1yr2niVCNLK3jLj4D6ABGyTli0bDE7YHWYWdhelOJdwwuL/i54M4eGi6sm/s6lKT3T7TK5RZDo0zUfDEJGzgEX4IHXHWixRgeHONxxfXBGq55XJnL2pZMBRhscYrTazmZY4O2Z7vcXPLVY9a1F5cYDNTAoKvmg3g02RSrQYM7ad9mnVH5ouXgVomCfE5gE+5CdiUD0ciTX8Yb3IIkDrc4HGITPBg1myJ4GPMsi3RmXDrHqxdYbpZ10CEhAbco/S7uYkfUXv2M4nJHxX7yZiNK1goR5XHZhK9eIykWE+fa6RzRYkGJ+ddwghKj8GSqiuLHb2w3t7i+u0J5Pr7CAq0ddD+lEaG8Lcgu+EuZuvc7g3Rt9Tx7rMoFXAkjbI/jKuTr3bIsBMQQoj1NGRZi5YXWC7vj1j2OtQzlLS5xaDY2sX/odLXq8L4Pa8imOpmHPHZ9VoJyyauioNbcd/Bvco6SBpsLbl5w/RSw+ut4TrKSkMM3F8Ox06j3KsC7hLLMtXor9gty4Za6tcegWEWtBq2Z3h+H/W+EtMkYthnbcuULOf3+xh2F9h7qp8eLxFXDnnrbk7zjQ1gIkfC4Qa7pnpcG+s/wTdqOY6xqGB3CK6pMB2mE5ZXbpnoolLMek15f/zmo0U8aTw8K6XyTU1Rm/zbBjXdd6fDKw6+msS96aeWhzAm8rZpjp7L8JOMPFPReWKzgVyY/rzlGk5bJ8gJy04SA0spiCWu+IxeAal2NEmaa2vHi29dtuWx+d2CCscH44Ufa72SxPAKzfRbhLW/oD7Ic8np+5834Lw0kjZ0f2aNtlusexoW
 6iZMxIoB
 ClUoNZEp+MhpThZmaW34G9JjlunTq+V+Xja/tEQfMz4AsH7ejZj3mw+9KPFNRV1j7AzMQX9hiQTuG8PGcZIOLRU4W8croSdPx6AwyZUf2VL9SKn+Q2w9J1Qg1Rbral7PmC/VU4pKAbeg+oy3WkU4dWY+i3cFmdJsg9Ap/CJMvF4e37FBrj7JaPC9EDsxsZKuqIHJDvKIoFLSCC0kdVN7FliRO0uU4ubef+SAmS/DqHyVOgq2mHoRTIhlhihCvDw/w9uX40QsNOuxHDjbQZ8RmdmhPngLGq4SDivcEokk9s+/qPJ3JAynQlXO0S1V2WDJ5qadLskuxJAE1yi0DsuqWtblpLUrJStlBFo79nTzvPt+dIitsvO8jNbZ3ZHMPcEjrnCAsTjmoNDaZbwPDPbSFqQGApWqRuBvQ/mKPHo76qKLM6WvExvT0hlhE/vyu36d8XLhtTsSbd6/IFzL3a9CUCOElyLxKu/ZE+ubugaSOvRD0eo5cS1A6wL7PbQfZA+1odKgZeWumASk00Ldx8GmH5luztLXPlY8hEF6u3k+Mgswwy6XGrNMSwZ0eD6WdJBz60zKcrCTQiYj6HcL3Qmi0ZDo5n9pnvG3wQzJJoWcvnWP1DWr6hVKagT1iDQj0H97U1464x10zCQuSCrdyhJFkSHfuEAElOiX+1nMWN70J9MOElxdy6YVn6wN53RHcnmUsAAkl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The scratch_phys documentation incorrectly tells users to use it
together with scratch_phys. It should refer to scratch_len, which
provides the length of each scratch region.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
---
 Documentation/admin-guide/mm/kho.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 2c26e560bd78..3e3912eeb2e6 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -104,7 +104,7 @@ stabilized.
 
 ``/sys/kernel/debug/kho/out/scratch_phys``
     Physical locations of KHO scratch regions. Kexec user space tools
-    can use this file in conjunction to scratch_phys to determine where
+    can use this file in conjunction to scratch_len to determine where
     it should place its payload images.
 
 ``/sys/kernel/debug/kho/out/sub_fdts/``
-- 
2.52.0


