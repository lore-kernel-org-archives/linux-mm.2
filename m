Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9B9C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803E06B00A9; Mon,  4 Aug 2025 09:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB936B00AB; Mon,  4 Aug 2025 09:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BF36B00AE; Mon,  4 Aug 2025 09:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5050E6B00A9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:29:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 038D513536B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:29:27 +0000 (UTC)
X-FDA: 83739156816.09.2D4FD57
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9686D1C0003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:29:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XJzkZWUO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=E5d2gsQJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754314164; a=rsa-sha256;
	cv=pass;
	b=hoXqxZOz2kQRu2hx6oJaLiZGvRPQKsQb1J5Qk0Tsz9nWBbeCP00L/2MruxGguQbNLnXhBT
	0KaGLsKRK+1FVTdPGvgGor61Hs+pNLUgSRH97S9Af5IjlK7YZu798DUegQ+rJOK6f/E3Zd
	MTzVq7P/a3i+ec0YX6VBp/9QYiNklBY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XJzkZWUO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=E5d2gsQJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754314164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ogiH986bVSeVMyM1EtiJsOs7zcXf5sYRZbSoy5grUI=;
	b=vIjpttpUHzri7+W774Fx0v8rmulXRKW+nF9d5hJqKXw9X7z0olKL62w/8/XmsLa1M+BvTF
	sb5LlDJFiaWmaBbQxrWPpS97hV7F3+2rtfuvk8FmqRw9j2CgPIPBkHddbabGgl553tDIT2
	VAlDA5q+aY3qz0PaZM5OXN/PHDKfuH8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6a9r031665;
	Mon, 4 Aug 2025 13:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2ogiH986bVSeVMyM1E
	tiJsOs7zcXf5sYRZbSoy5grUI=; b=XJzkZWUOLTPULJd9bTOife8MauvxmQKNrc
	5J1jsP4MjB5GvvKfcdP9uFrZ9vFutrXFfyue5g6fN+wQ8BoYsQwb0caqJ21Ntit8
	QQ/Aej4LmUYcNIK6wAaZ70ft9tVPCH8e6HWdJQN06cKzMaeUUCHAPS6/SV1erqZt
	clH0KXtKbl6zgBdXc0GC2bN/F4ANMKZ7R6bB67rq26Jg4/E1BkKNP2Y0Xm4LA2E/
	fSHFIZsAf/5z1VjdAGIsPczSvNo7qjRZjrEDfiBtKhCBr0PQsB5ySNQ6+46fz6Ek
	xsjBrnqb1buehDkCJ+T5Kmwwf52m+sunFb24HE9IRVb252AsrUKg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489ajdjkh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 13:29:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574DJH72013479;
	Mon, 4 Aug 2025 13:29:18 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48a7mrcxut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 13:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROG826EZ8tubTnBLoEjpJkfm4xcXFpAhPDeoW9H1Jd8K71+yUVOv3JMl4v1fhRrS+SFfWJfUCxjADgVRTWONXLIBgRETLONKtg/hU8unMOOYzD+nftQSPMEM7jcAQLMx0ERlNEDIs7VCf1g/uzxu4Ssd+V9V1R6MRLq3QndKT/JADIMa4F0KDAW2HL3Ave4/J70NOFMciBci1zRpU/gB8lT7utS2VntXB7bXMA/19qWQuu20bo5dEHYDz981tbKEcgmXEnvkeVwLsycelH3nOzajSkNvSEuuH6OsAGN4TtPGY8MvmGu+zdlDk03aozbThxaRmM8ghVY8auTeCh7Zkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ogiH986bVSeVMyM1EtiJsOs7zcXf5sYRZbSoy5grUI=;
 b=X5XWvFKyaL6FeemUuJFqqFzin95UA4hawD504QkdGnCPmkmfO6ppPFgEYPyA2QNZ6CnXEuouqeeSeDAX2A29qS9EwiJl2E7Tiwk5jAaW4a8dzzTt7z7apUIF2iKQ3bp6vDDN1vQmqDAa8lcpwyblVScGZlQbDyV8MJRLNNFw+9h5RGiIfZcjqmoAf7mSZ5BisPbIUH3YA1H5boNmk7ZRdFsH/XwktwoxNaB3DJ39Rlk74znZhy7SkzxXI+Wd1iCPvJYH1G9yI56f1CxeqiukLfl5gmhnY3XiWGo2qiR/XTNh15bH+V3sjRJtx+K0VUjtmbx6rjxVzQmDw/XmiuL/Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ogiH986bVSeVMyM1EtiJsOs7zcXf5sYRZbSoy5grUI=;
 b=E5d2gsQJ9nMYyU6oDbggkNWpYiok0yiEbZN2TCps2V5ReJrm1XBZW8A8QjVcSipPpU0vn/VtZwRv1Lg3ZZ6dI64Fy/EIo6dCk/kY5g+UCO2qgWLg4MUUh17+vXDfl0rZ33cj61XSJZeBbfcoxd91J2uYhCF+s7rnF5JjgkKGeqQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5881.namprd10.prod.outlook.com (2603:10b6:303:18e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.17; Mon, 4 Aug
 2025 13:29:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 13:29:14 +0000
Date: Mon, 4 Aug 2025 14:29:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Li Qiang <liqiang01@kylinos.cn>
Cc: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
Message-ID: <ab22e314-63d1-46cf-a54c-b2af8db4d97a@lucifer.local>
References: <20250804123923.296230-1-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804123923.296230-1-liqiang01@kylinos.cn>
X-ClientProxiedBy: MM0P280CA0094.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5881:EE_
X-MS-Office365-Filtering-Correlation-Id: 022ea1dc-7ecd-48be-6060-08ddd35ae7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RvmfDO6MxQYPUo+VS7bQeYCNBi6DIM/OkQsHSkwYPOJ7oQXFur4WIptdZP0V?=
 =?us-ascii?Q?/bUM3r7oKD1tnqsLxWTtEH9XzSh7yF8PT+rKyXV9JIZZzT21v+jxMXr2jqls?=
 =?us-ascii?Q?q1hTQUBuRNsM4Y1dlTnJoRsU5IQRn5lHA6yR0LLQUjUu2XPd+/ZO8W76Cnv0?=
 =?us-ascii?Q?HtnP220jNhlHrouv2gUAXidOeeE/hAhqs9z94gomOJUcrRh2zPdQILdqWyff?=
 =?us-ascii?Q?FiaWycw6ee7dAERKoxOMF9WAvO2cHZRcINCe+IDnl8U71PWwOkOlDTqSC+T0?=
 =?us-ascii?Q?84VZDYPfhxuQHiWtUtU+zVSE2WvB6Op9PQXW7NQNJS58sDwhbhdnd7wNN9A9?=
 =?us-ascii?Q?RTXj3qqaguYYAiP3VBjdIXjKnhU5Fpm2eLxPkdbAt8WCO6q+AH9bfxmwImpW?=
 =?us-ascii?Q?321p+NO8xFO2SveSQPu4eJ8d/53FkGygkcUL4X6U5TXyCs4rYswrZknwDfhl?=
 =?us-ascii?Q?8C5nUMPIt8HTWnb0ZOtO8Hg7vSXppWXI0T047yG3Me2TOShETbW403vnYdMR?=
 =?us-ascii?Q?1vzOpuXGCaQzbYW0/scHlyap14h2QOu7EOz39AcJDJQOFEh6pfILk5ugIN7U?=
 =?us-ascii?Q?JOlcARiLhYP8IOWArKTpYGhUgfDVC1uqlw5luec7PYeOfc0iNls/Ls/VZQgh?=
 =?us-ascii?Q?sToPXHx/zudgLLGnVyAHs72RBW0RRuruO7Qox/ipwzzyruF700+cPkMzNTG+?=
 =?us-ascii?Q?E3TVZzyaxyJIsvQRdsrxb3JAZzdetgAg7h8SvEzFB0YHapI5xSgwJX9nfNHl?=
 =?us-ascii?Q?s2reEl+CYmYFZFyBKdwbNwQaujZuwI0uS44sRTGZa5CsA4qY8HHIR2UnLbS9?=
 =?us-ascii?Q?u3nZORynQCJgt1OKUMgBHl76XHa3G+iREtkCs+mp6T00+WFPt9IakTpB0Axc?=
 =?us-ascii?Q?2qoA6aBGygDzDUlkOcdu+P1k1jySDfhmjCPZC0HM/xZHFB3cLR14itWKVe0s?=
 =?us-ascii?Q?ar8A9Rb3Cp+5GRsKw/hQ/HEO9wuZweScEzeplsWjKNCL9ATczljwCekrz3in?=
 =?us-ascii?Q?+PeNoAzKKEK/AIrTrRZB5GOGsaX01Kq/GhQb1ewuvMMZTKPJIYVgbGnQ5sN4?=
 =?us-ascii?Q?4XrTzJOqERaOeh1tFot4cln0YaM+Ial1QymLROMXDFK6HnKSpdZJTvBimDbj?=
 =?us-ascii?Q?tXEhlMEY6LhmoHUqrv00QtPuu4EFrJTYZfn20ZdlTrHd/LbfrQF375+hpmHr?=
 =?us-ascii?Q?Xuq5Lau+lfifB0G/k8D7Q0JRHg2NiBFqg06vmnIf9rY/7z6nCj68zsyAXM0M?=
 =?us-ascii?Q?oL54DONJd2BeH8UfO/Xrv4Bwuy1McgVXO+Wp4pprAcirsuxW8HcIvdYJa9Gt?=
 =?us-ascii?Q?C2MxxPL7roOB4ExHEsDqLf0fqGViVQUOS7ToOJjhKsVTBis5MwJ1kvT4Ko/I?=
 =?us-ascii?Q?YZCJlHfNag61aoi7zqO7ewxWQH0M3OjQ2shyUCRNfvTDkHIx7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OmeuQpAnypH1BBQeIBx14OHLvaq0Q6OprBuUbMGBdyA/7r82LCM1raC83STa?=
 =?us-ascii?Q?IYwKkijfJ+u8OEXrJZyHWZAHj7eBlXKfNpAl7FwKZcaF/IduHuk5fxFZzjK2?=
 =?us-ascii?Q?Uy9dW2+NRCVb+mVjZOeaPJeACLH+trGVR8Gi5lwExxacb10EDAZkgBbBucA2?=
 =?us-ascii?Q?rWqt6x+ORr7ZXKu0PaCXDlShpquePbSjhuhdyWIRgCM9GAWbZc5o4OIbT9VR?=
 =?us-ascii?Q?oOjqvfXlFxnZnTFwukx9KGXgjMqW+R852Imyx64pBGt+6Fp9bQ/jyw+wlPjZ?=
 =?us-ascii?Q?IRiW2xQ/mNlqy+oMqPDySaZyh/nDfJU1P97y1b/iupHDRyaRNj22VRo84IkX?=
 =?us-ascii?Q?oe6EIpY/4WDqblE2k0f49YlpQ6RTWjaAszEDoCDWdzB/IM36EF32MdkQQMcg?=
 =?us-ascii?Q?OiE2se9qLNz0nz81/ap2ODMxR9iRc8ksXqamQemSRV4Mvei6nuuZywvDB5gz?=
 =?us-ascii?Q?No7BFhQZLa9qHdodArjrH3+vxPvDk2kbkvP9RZO27fZsL7O/LD6crgkreTxP?=
 =?us-ascii?Q?Xbs7h/IiEZXXuufdMcnOuSFBNSAriBOvJbUa8EbxH5/nWpE5AfsA51QdjKtY?=
 =?us-ascii?Q?Zl77Mai2NSl7kPPHJFhKKfPiuBMH6/ivMOEcPPTT0EFRJVFyWn1BtPznq4A0?=
 =?us-ascii?Q?zNOgriydyBWe1b2gdejH6ImnG58uAB3bfKGZ4EFEu06inPG+a0HC2Nncy93U?=
 =?us-ascii?Q?cZijC/yvtaJTPkonByTsaGHZ9P/CFLb86rL5e13VKPBmZiy4ee9wsz0eiO+u?=
 =?us-ascii?Q?9dvmKqcxMXxZOWCjlBNc/ynDUuSuPzEmD0z+votMDhF44yOG2tbjGKOLwYFx?=
 =?us-ascii?Q?BxOX+BhkAskS94mQ3WBxN9qgQtNHW0FbhNwK+H/l+aSbNJBF9eKyleGZcs5b?=
 =?us-ascii?Q?TDFQVlzNdU2UXKTd1PVViKhsRxwXZ21fSnKT3LIiJ2YHpaBkz931yYjYLjWk?=
 =?us-ascii?Q?UbfBZVfTj6RA5/8OQ722CRokAJZZ8JbZ7x8qkSR9EWqGVnmdPX7dxTI6wCZZ?=
 =?us-ascii?Q?S3E99bo5FRCfRf3ItmmOfhSWqMlYQq+jqySUnYnB0tzoFg6k3/veZNDs2hdq?=
 =?us-ascii?Q?0TriKg2+d+pCfw1n1x/KDIwoI0EQ097byVL930B+2vKu+gvwBFh1Lbw4JglN?=
 =?us-ascii?Q?yvi6EOhqbLBEkcz9fH9CevX6A1aU8QjI7riaKsCpqVpJbfBbzePKD1nrGsYi?=
 =?us-ascii?Q?RCH52cEkpvsp+zRHlOnYofQxh9qs1h3tE/z/6mutu/ysmj0Px5Ww+ghn+kR0?=
 =?us-ascii?Q?4irGT90esPFFz0tzyhyCISWQkMXhLVclk/LOJFAH2CYT0kpspwRJ3Vuz8sBX?=
 =?us-ascii?Q?eMTM7GSxIVcoHNVTiSNH4keay3tdErBunRKo7TuU5Koa9VLPKAt2+uXYeGfh?=
 =?us-ascii?Q?2qGMBy+iJAnSiccHfkdq5cgaBGFfj27JWYLO9jzW7pulfLMXdN9HTDjp9y+J?=
 =?us-ascii?Q?b19WTtCb6QhlVrYtJUQWu6ACH2qtA7rv/Dy8EWSCyaA5fUwkw5T+6jafj8Dq?=
 =?us-ascii?Q?J6KBNGpjQu27esHmOBZXqEmEArNT+s+ryNkayOLrOHxpgFnA6Glcuub+AS3I?=
 =?us-ascii?Q?DZDcwrhcDut+babnTpMqfNBgxrMxYlHo4Ur2maBlt1gTl8hT28E5wsW+izCZ?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wOfzmUwXMjgAnkD5ef4U8aPiIPg8bH17uHvA7YrMXCqGEARI7GQSGaRsMQbuPDX1Hx6OhOILViS8IcErqILDcbMhz+pYFnbVABY2Erj2tmNARRVjRRTqOzo3qtlTRq+YeQuGns4H5+mWRgUr7jtIZf9VHAbp8XBFsK2ZZWzxNRvq/aHuXmDl37xMimbgzvAZ15OYFf3ll/o973fSf8cN+NY61uBl06EEKmJ576n8nCZI1k6S7f3ChE+T5n3t5C4WpODcjAoXAxb1XsFakzeclRxWYF8K1CTLt47TLo0pERjQOWtvLWhKUBwMqRY5yJVLnPy8wZMbzLptnehxMgKVY+zbm/Zuw1m0svXAR8uSSI3PNjqdu0Jarcul892aV/uT+opq2egwrnphXTTaPjwsQBEEwqvgZ2C3s+2SgJFKlO+vnoE9HVK6AjIgtzm9HEijysmRbujm7zB7oDasK7est2GjOFZgX0ezljlehy+rkQEDwzBrS1wZYJszmtX4cwkpuLuWLfFG3perBfGEMdsCg3eoFPPvbjiY/8sVko7cbEeOmlQMf3o65IIOtK++34r3G/iHSXyh3ERR9Hcya04QORRw76VctN1MWhsWKVzNsDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022ea1dc-7ecd-48be-6060-08ddd35ae7bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 13:29:14.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sstmtF882QuZlMV4MRRoHkRqH8lQeH1uxcJDVN64T+CJhJy7tcqIVn4grym6jf2IH/QOBUDo2rzsgrKc/gRlLVi4D05IZ3p0ulUuO6VkTdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5881
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040074
X-Proofpoint-GUID: dCHVu4saV_x6K_GctVPTjDM0-lEjLWdT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA3NCBTYWx0ZWRfXyBdH6yZj51wj
 NENFa+OqZzY86sVwog3fDfdYwZjyNy9qdDrwUbc+g+0rOmLjiYuCK1RS2yfozNTCH3/tFDnK/VL
 l+TNku47Y/b0WRwIln0LwZlXkIiINp2ZtGtJuiFfSJKy2iEgkFbKmCjVuKC7WZlgAEACcu+ZG3U
 CUn93PaZvQp8DHYdQcq8pNmQHw5rG6/SQGP3Lxb7nAHssF6WllT9RokjYGmoX64h5XHb58RJ88i
 ctUew6M+ZsMvlNdE7sKXLMax7rF9Uer1VWuzzYX+DKUJJnF3+WLh6Rb3NNmboOo9YZ2Q9xgfvJU
 z4YvvYf0fp5dp4bq6xV0Vplf2G8A3AAk4Uo+p3hD82FfKYe74akvWOVS0CLLbIIagZ/P3/aDRwU
 bIsBvKLwYO7thfu7UZglRp37u/0jnUdoTx4pjcGBUQv7iMaA3ZiIMLYuLR9NnFg+iiB8Ij53
X-Proofpoint-ORIG-GUID: dCHVu4saV_x6K_GctVPTjDM0-lEjLWdT
X-Authority-Analysis: v=2.4 cv=FIobx/os c=1 sm=1 tr=0 ts=6890b5af b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=wCdSDNflE2fbg66Dwv4A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13596
X-Stat-Signature: mhkxbzhrype45w5hqwfyn9pxfxssmime
X-Rspam-User: 
X-Rspamd-Queue-Id: 9686D1C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754314164-139013
X-HE-Meta: U2FsdGVkX181RLBv2jfSiCLf3AUZUQvXyFe83hcz6cSsUJji2E2kpO6HfjsPvkEPx3LtZyIENYCWv1v0rB/sfGcYC6c2ARFmIT/88Tv6qyZMFvpqKi0XHAeLkeipDqOZjYPvGT8/K0XRSDG0HfPd/48p28vPRzNK7fXqjpd3sJJq2L1BlfEuWLj4Sic0xAHyXIyeDEy//zd16ao8x9sOI5AL9dswT2En8YTfSH/Fnn10zELer0OJAPEltb2NABPqdK878cCtRLPpaQoLRJapW+tIrWjwV+OKhV4+U7SOIMkYG6/KneKV7EMJ/OPfZPhaAOmFS0C9tQB0Bp+XNRoH+O/Nt1BHrSNvxEXdK1KNJuNAJL26wr2Dj6kcKLB67vQXD6Ct3qxP70fGDeGNdNEUY2rwpKzUMJnvNUR277wtJ6IsmJzRF8/BqcV1ga9EVBvCLw9g5QnGKgzxRtx9SUNbBwF33azC0Q0p7tI05iHHjJetiq1/QUWAdylR5ZZcsH5ewXer8z5P/Lh/x1LSdLI8ANT9eHgviu/GUQb6N8rCcU4lynCUaWyvNcem2iX7vaceqgHls+dssbEGyw2QDdEyp4Xx1Qy/FLOpROlgM2ivN5VoOg1RAy3piINC5kuHNjIE/B1chtDc+eObRSt2kcOGR+hk3mKtjZfWqB70uXfE9QevumxDl7iAPHlJQr7lxNadv/y7A22SFfCcHPPtpdNkRQ0o2kD4987naW1duAwW2tckSHYKAYLDi4yugTwNLqNVwy8hJyze5mX9zrC/7mIRSVlgvZSJvUsbiR3dtslAkv/tMD2TwNqD3D07EIAJj50JLGTOB6h5lH9b0x9JHU+ootnabRGUTeep79hdz2GgXaMEwmTJrOrhi7gSET8WucCP3j4o7+d2vv31Hv+E3SoLSXObitRwmiy3ODPZdTmVbVH5a84bPOSQmHalHqcGHbDXvfkYgiyWr8DSUhw3tsH
 uLEwFIbZ
 m5xkONXDQ76KlyNF3CvjFeQm0ZyIrDeEkZNA7QxCnAzKSEws=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 08:39:23PM +0800, Li Qiang wrote:
> This change converts several critical page table zapping functions from
> `inline` to `__always_inline`, resulting in measurable performance
> improvements in process spawning workloads.
>
> Performance Impact (Intel Xeon Gold 6430 2.1GHz):
> - UnixBench 'context1' test shows ~6% improvement (single-core)
> - UnixBench  shows ~0.6% improvement (single-core)

These aren't exactly earth-shattering. Are we sure these are representative
of anything real-world representative of real workloads?

Spawning a bazillion processes is not really meaningful.

> - mm/memory.o size reduced by 2.49% (70190 -> 68445 bytes)
> - Net code reduction of 1745 bytes (add/remove: 211/166)
>
> The modified functions form a hot path during process teardown:
> 1. zap_present_ptes()
> 2. do_zap_pte_range()
> 3. zap_pte_range()
> 4. zap_pmd_range()
>
> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>

I think others have covered this well, but we've had patches like this before
where, in essence, it's a case of 'improves things on my machine'.

The question really is _why_ your compiler is not making these inline in
the first place.

I'm no compiler expert, but the inline here I believe is redundant anyway
within a compilation unit so the compiler will make an inline decision
regardless.

These are pretty big functions though. You're essentially inlining
everything into a mega function in unmap_page_range(). Which seems iffy.

I wonder if we might see degradation in other workloads? And you're talking
about one architecture, not others...

I feel like you'd really need to justify with information on the compiler
(ideally with insights into why it's not inlining now), how it impacts
other architectures, _real workloads_ you've observed this matter for,
etc. for this to be justifiable.

Also are you sure it has to be _every_ level in the hierarchy? What happens
if you inline only e.g. zap_present_ptes(), as we do with
zap_present_folio_ptes() already?

(Fact that's _also_ inlined makes this a mega giant chonker inlined
function also...).

I guess bloat is less of an issue as it's all going inside a non-inlined
function.

But how this behaves in places other than 'not entirely convincing
benchmark on one architecture/uarch' is key here I think.

I don't think I'll really be convinced until there's quite a bit more data
to back this up with real-world usage.

> ---
>  mm/memory.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index b0cda5aab398..281a353fae7b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1543,7 +1543,7 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>   *
>   * Returns the number of processed (skipped or zapped) PTEs (at least 1).
>   */
> -static inline int zap_present_ptes(struct mmu_gather *tlb,
> +static __always_inline int zap_present_ptes(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
>  		unsigned int max_nr, unsigned long addr,
>  		struct zap_details *details, int *rss, bool *force_flush,
> @@ -1662,7 +1662,7 @@ static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
>  	return nr;
>  }
>
> -static inline int do_zap_pte_range(struct mmu_gather *tlb,
> +static __always_inline int do_zap_pte_range(struct mmu_gather *tlb,
>  				   struct vm_area_struct *vma, pte_t *pte,
>  				   unsigned long addr, unsigned long end,
>  				   struct zap_details *details, int *rss,
> @@ -1698,7 +1698,7 @@ static inline int do_zap_pte_range(struct mmu_gather *tlb,
>  	return nr;
>  }
>
> -static unsigned long zap_pte_range(struct mmu_gather *tlb,
> +static __always_inline unsigned long zap_pte_range(struct mmu_gather *tlb,
>  				struct vm_area_struct *vma, pmd_t *pmd,
>  				unsigned long addr, unsigned long end,
>  				struct zap_details *details)
> @@ -1790,7 +1790,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  	return addr;
>  }
>
> -static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
> +static __always_inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>  				struct vm_area_struct *vma, pud_t *pud,
>  				unsigned long addr, unsigned long end,
>  				struct zap_details *details)
> @@ -1832,7 +1832,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>  	return addr;
>  }
>
> -static inline unsigned long zap_pud_range(struct mmu_gather *tlb,
> +static __always_inline unsigned long zap_pud_range(struct mmu_gather *tlb,
>  				struct vm_area_struct *vma, p4d_t *p4d,
>  				unsigned long addr, unsigned long end,
>  				struct zap_details *details)
> @@ -1861,7 +1861,7 @@ static inline unsigned long zap_pud_range(struct mmu_gather *tlb,
>  	return addr;
>  }
>
> -static inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
> +static __always_inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
>  				struct vm_area_struct *vma, pgd_t *pgd,
>  				unsigned long addr, unsigned long end,
>  				struct zap_details *details)
> --
> 2.25.1
>

