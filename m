Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB859CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2F86B0092; Tue,  2 Dec 2025 05:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E186B0098; Tue,  2 Dec 2025 05:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80F96B009B; Tue,  2 Dec 2025 05:21:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D75AF6B0095
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:21:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95B4D140572
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:21:21 +0000 (UTC)
X-FDA: 84174138762.17.704F514
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 526D3160003
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:21:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dq9N6kgP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=le3fWcv3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdhL1SseLuZ1/wvXeRztEGJvPKp83pXQlV5vspRR3EQ=;
	b=EleVkokEcyS8cz9YA4wg6N/yUKzp665JDnaNSk5yjxUY1rXn3r9R7Q5ZL3TJFIe3mH8WFd
	CZv1uy01uLWmgW/sNoR4c2izrIORsKkiMpfc94ywOdXVBinU+btdxs8vkyRJo6CZUi4vD4
	nM+J+4WZAlzmbtgOyeHKO4kAc+T5aS4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764670878; a=rsa-sha256;
	cv=pass;
	b=gbl0/aPq4gAMYQnodcu0l/MgUSRFsCIJtXSXBW0dNI9/yoKGzOlCvVHaERXffyq/Kw7se3
	I42J07IM63Ltm3JPAtnwmskTrSnkvAG24ChUo8n2ODVCZir5Rqo7bw9qWReKYOKKCyIYBD
	dQZNXY7wEa1QXIRkjx7KjBqtJcqrq+M=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dq9N6kgP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=le3fWcv3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B21OHr43320890;
	Tue, 2 Dec 2025 10:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LdhL1SseLuZ1/wvXeR
	ztEGJvPKp83pXQlV5vspRR3EQ=; b=dq9N6kgPU8ivnBPP/7+5VQC1ot9nW12q7D
	9d3ukthH4zO3Hwj3KzIb/y/LmOSNVYXq64WiK7M1YKl50+5HSdoCoyGeeM59RaFH
	eT4z6a6rowQijM9LHvTmcoWGRhhds4ENoR6QtjYhmnptMzUwllQJPwooWPCC10lv
	H8QD4GG3a/4Kwu1mnlFT6tSEaxw1cggz0p5TjCF/Wf+ZLK4g70sV+bTuTRWuZyvA
	CcRAJRXaL8kYn82EbE3X6N3spoaW0aPMH5vG+KKF99TMpC1InPygLWt63oxAk35E
	R8VqJouCDsHd0dVwThEQMNHW0z2Cly7CASSpVluHAR1Ws+aZfpzQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as845tkjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 10:21:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B2910Gs015061;
	Tue, 2 Dec 2025 10:21:07 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq996aqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 10:21:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJ3Z7XhYw2YxYdCW2PCbpm5wDIu+jqUmk5FUOVLsQluYXXqzdlLwq5nwxNwx0aydrDIF87RCtchWHmmnH43BJvzVchU0ZR5MEEd8U1G5NTkIRfxNKTa6wRC7+o/1Ei80DVfwa8dzDBMx5MqCZLrfhwnTTqXkNwrtAizFilVkxTLbMS1MnY0rCU8OSJ6PdM/PNhTwEh8sgj6HHg4nybYrL5vOimhQla5h3JLGO5A43QVlCSjOMygUPt7J+tLoLXUp6I1jRClmD8rjhbkcWtKb2Zjk571jO3O8Ev61XuRSPF2tW1THyUuKs9fV5W7bS5CBBJCIkjHgHymWJACkUW6EKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LdhL1SseLuZ1/wvXeRztEGJvPKp83pXQlV5vspRR3EQ=;
 b=Tv7ii7mGz7c2FQEtJyEnF/SXwqoEpD54+Jr24PVGvflAITINpx/qJSsC2IFTpHrk4C3CouJ0+ZoycnydNleCl6mF7jFoYtMyfV8qrOvYLHhheBzi+LSiR1SQ+dQ+vGVJoU/ONgQrWpLR6UGl07UtoUTwtbPyFtu9P1IRk8qXRGPAoGrkR68dcCh56VrAQ5BbCLycitHlWbPdhMch1jSzuXONoHeHxKhbtxdxLcep9ckWIklklI6w/0p0Gtr1PlNBRPU9mTT4x+dRI/TR58T5zQxIkpmF/QF6EhBBPAUID9y4bn4r8uWJdulWkj+w5fZu8nC1ADtFbkRgG2QlTf6fBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdhL1SseLuZ1/wvXeRztEGJvPKp83pXQlV5vspRR3EQ=;
 b=le3fWcv36hvmHZKbmfjjyDe78xNm+G01Xnt2rJES9A7P3tW1+Cu14K5Hzwmz4i06RTC1bHm1ydgcNfeJ7S6stEeNZ5wHENyRMGw1oYIlBk9rO9a1w5Tq/iM1Eersj85z/Q8G/sl9E1m7OUNxmlgzIyDthiZgAfFThH26y/Hkz4o=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH4PR10MB8004.namprd10.prod.outlook.com (2603:10b6:610:242::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 10:21:04 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 10:21:04 +0000
Date: Tue, 2 Dec 2025 19:20:56 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: vbabka@suse.cz
Cc: surenb@google.com, Liam.Howlett@oracle.com, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, urezki@gmail.com,
        sidhartha.kumar@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
        mcgrof@kernel.org, petr.pavlu@suse.com, samitolvanen@google.com,
        atomlin@atomlin.com, lucas.demarchi@intel.com,
        akpm@linux-foundation.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [PATCH V2] mm/slab: introduce kvfree_rcu_barrier_on_cache() for
 cache destruction
Message-ID: <aS69iOLdnW0sXzF3@hyeyoo>
References: <20251202101626.783736-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202101626.783736-1-harry.yoo@oracle.com>
X-ClientProxiedBy: SL2PR03CA0005.apcprd03.prod.outlook.com
 (2603:1096:100:55::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH4PR10MB8004:EE_
X-MS-Office365-Filtering-Correlation-Id: ba257797-e91a-43c7-ca7c-08de318c7ffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rxt/3uijETJdsvAsiydBRh1P2huL0vwM3sQBjDW7GYmfRHaJiLb+4Z+YN55X?=
 =?us-ascii?Q?BBKW3t6Ug3MI5dsWXDoEoaAinMp3z6Wy0zLzNo2YkHqjhb7ZuRRMB8pSKWho?=
 =?us-ascii?Q?DDcb19hBMCbF5LVRH70t7vFrXMOW5XkGHLqiag7zDGocsRn04sN39342YSGS?=
 =?us-ascii?Q?VaWXiW5aQCYGyHloJUSrOXuAAut6yk+nLZlL2uOWieIPTeCCZpRv5nAjPfbu?=
 =?us-ascii?Q?wmcDfN6cMSYWKNWVrkkX4GB0GmIfOF72BRtPq6O98wVr+ue4MQdXskMJOuhE?=
 =?us-ascii?Q?TqVcqd01NGOmQ16Dznxdecp3kxPDHGknBIG0JbXlhuQ1Ij4JZzv+BPhMBGpU?=
 =?us-ascii?Q?Pv4rdbtrzXXSlu6DZ9BEFaUAhTDdTyuhd5cbO4UYqIjQiZH2/D94KZ3y3vnw?=
 =?us-ascii?Q?ipp7ib+AQNIwx7KDSp8L2sQfpQaCqJ9nnDjh9vwYefZL28mJIZcdeADi5vfe?=
 =?us-ascii?Q?uJT62qpyTgF0HrR0AhABy5/Alrb8nhVisSNOC33HdiXZx0e324I/i3/hDuHk?=
 =?us-ascii?Q?WvsZPefZSlPa1wTaIcYiQfmgFbjIL2z95ZxNVLY+e9Vli4igjxdYXC9xvgrC?=
 =?us-ascii?Q?GYG3ercwVD9f+PXjC7wp9N4nJGqp+KRN0CrMi+usQ4TOrC3qoS91jX3Cmhp5?=
 =?us-ascii?Q?qZc3uol8T+O9WVfYPKk2CzktNr5PEtwh7p9Abwu36tPoP41PvT8HjUsS2ZUi?=
 =?us-ascii?Q?MkWl8EhNg0kjtg83uvdBPAnvStwSRiOzpdQhxcBKTr0wwkmOc6JmYYBrkJhg?=
 =?us-ascii?Q?UbC7qh6cFtxLlKYGtX6T14CPhsqBTRd2ScqlVAguqT1now3NnfM7Cf/puZv3?=
 =?us-ascii?Q?vIq1Td6B8IqHAVsj8Xu3ckm2EWiBP8pdvAwTqZsUnMEt657Y9GTPgBn8GJvX?=
 =?us-ascii?Q?IUAt75DsVSJVuMhY8KNGVyzeEMPNFAmFeeB/8evhRV8vG1/M5595coGVLY3/?=
 =?us-ascii?Q?UowNbxvAtr8bIRVZKJ4ragNIXwZUMxewf+2uZvCypKvgo48WY0OM+BP8zufg?=
 =?us-ascii?Q?PMzYZ2fuUdSPyx38/KwPukAnVgu0lCzXfcfVe/7wpz1nKPNida4aUVh/YILI?=
 =?us-ascii?Q?h7gU7e4ZBtv0B+tUp8r1K/G9oFra1XuvTKoRbYyr/HB7Krpf79KbA1XNgSYo?=
 =?us-ascii?Q?uryGo3b8HJEcu4/Eru0n4yDOhdXH5H7bu1MRAUmIXKxLnf2ycWt4EzjXBqt6?=
 =?us-ascii?Q?RMMvUYqALmR1Vk1pk3MzBIZksAxoj28AIjJTLIdOs7n3vS+H+Gqi09W9qmsN?=
 =?us-ascii?Q?fMbBTP+a5Cax6+BKXbR7JdYVh50kQFwfULl8dM8cbEx+YXrSC707VZxDCqJk?=
 =?us-ascii?Q?yk2f6/au5GgcddMEUVcMPTXeC5orkzweLHoJDB5ALozCzhqIwxuvKvb2jv6t?=
 =?us-ascii?Q?Dd2+pWwwhJKdjL9DzoVb2lUeebyHtSL+FODAKa/ouoazd0/Hakpt93F9wQyL?=
 =?us-ascii?Q?bl+Y6FXBxzyC9xbEHQIkWy6tGczfQ82blFkoVepC/ID9OxCIepf/hw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rO3sfHNQIILjAw26zOJDyxC5sSbjr5LooJAk/8hrWvWRnKKIchInO9RYZZh/?=
 =?us-ascii?Q?8XqcWrOKlHPluVlgOWfqycl8sV/HG3LWPiCLAQWHseCXKRIfBzKEt1kvtgYn?=
 =?us-ascii?Q?kRdyn+ab3tLEwNio/+IoZHC4fWYoWWxiIpmeGQONHtOjvqBW7MSqRqN8emtj?=
 =?us-ascii?Q?vHybev2eT8561c7T+xvTvtd87f+tLddSQwWPZWAl2NuQbvIUOzmB1nrUrrMy?=
 =?us-ascii?Q?tGri+WmAi+eYDvGPIQZYnuuGSyC1IndWZj+Nj343oJ+j3lUfCCYi0Z5jsU5D?=
 =?us-ascii?Q?smGbdOkAXBjAnYuXqBfJ0Yrtlq2lpDUpWh1ADpJ+ofzHEUG/4ogKJAfXClrL?=
 =?us-ascii?Q?HY8Wxqlj8SuQb6+48jlDrmHYh2AyT/hfSHksDKVHslbwLnsjgfHrYzUUvjhE?=
 =?us-ascii?Q?LwoPa+vTj8ggRL/kyX18hcednP+fPs7q4q6c47p10+2SuTM89c5gk/5ePV0b?=
 =?us-ascii?Q?3ZULoP5eaWVG/am1AZ+19VTXUpeoqOyCUHuc2DkakE77cesWjp9P/uinpNsi?=
 =?us-ascii?Q?EJ9EKmtCy+Dy/gBtjRX2luO+40rbsVB3O6bsD8XPRWhoB+pfPd2sHosAkpTW?=
 =?us-ascii?Q?LwvUqKLdhBgdjjjbwS4uWS7nciIJOqjXh+bhiElNj5jBUR4MwZrimo9LiZpD?=
 =?us-ascii?Q?X+k4s7D4zNhQU8HNPuu19kwnndmtlBd77dHkBTIpB7CdlslLuhoY0wPoTKam?=
 =?us-ascii?Q?Ml00SMucXO7f+IGkkaquLxg3e+yxwNm/BnAiL357YkL3EMzdgDvJZ2bvzre/?=
 =?us-ascii?Q?gHI+90oRKR1px6NPgENq8aM+TcjbxW1n/M69fA5LZHe2spwdLhsG/zeVHb0w?=
 =?us-ascii?Q?YSbXjpoiAEJoGyxjM83X8f/rJHbXB8vJIjasmc+edoyz6L+lQWh4jPWUQLVT?=
 =?us-ascii?Q?ItulxoIrVlcMzMiFDgrAEjXMtNIvNMdUtSqeVgmyikpe5Mt/6MHGr8FVndUW?=
 =?us-ascii?Q?WcIpaxCFJkXy7F/VZewoV0Zf1onIm6k4JjDCeKgJ4SbZjJrdzp/kgm1YMZoe?=
 =?us-ascii?Q?PM5Q/d9SSUQJnXdwFM6DEQCwcIKkSyDwFic/zoTkYUi51bApNjUij1T+ibZ2?=
 =?us-ascii?Q?GIcnll7A2Z/x1K7sZ7tamXrnT3avudkF7QuGz0iQSthdj+R/gKk4kFkxCrQQ?=
 =?us-ascii?Q?bsgiKaj7XSybwPLLI3kjPsyyyZTkKFIaBTpFF5hDYQN0HJp0ECFNyhlnMft2?=
 =?us-ascii?Q?9cL0oTxZ0y9+6V3hqoGbaTceJGHckiYni0wgFBQuIYOtSl6F+MLa7TnFnABU?=
 =?us-ascii?Q?kflHfcn+/dBpF6cIepJGTnpla1ZgKzZTptaAo/6JFXu75g+G9orpibOaCVVA?=
 =?us-ascii?Q?9X+3vSdLjKNun+luYg/xRqyxGBIOdkwWMmDtyc1FRDoraTqK8vJxPSM/gRIw?=
 =?us-ascii?Q?w1y5U4xgB/xFYMk/VYle0ngm5yOl2WAq6o37vZzOGDwAjHJPtULNFNc90But?=
 =?us-ascii?Q?OeM7wNx9yfPA7ijNY/Z66Pfe8DtzpFt6Bs31bRCR27nVbaJIb++88t+0icMQ?=
 =?us-ascii?Q?K8BHwOF6iOlxSxCjNpTg27tx3Ng1cpUtigl/noOCpgQtwFsOJUbXiBAHCVzq?=
 =?us-ascii?Q?29NqGjK9+Mg6fPebrPmWzSJiYgdyMqY2LsXG46Es?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rPrXE6GIKpnh4a407I7r5E1ehWFzMbXcROc/1IrTC2jxwEaH0YfPg0Hgi0xpIJf1GIUAbR1pTLTPyR7Nh3ZE9D7oJpTX9zfTT9H5r80MbZpeajCAODdn7bNADII9rPuJVWcO1EbAqmVThBULjYUPF3HwvgIDlTJwrkA4XBKiRruWAxdh2mYiIJnjdlDBZ7fq5nRNtdxgwx52naoKRvBb0DRVh6ebGhYGHFn6Y0U6WRNDGmo1NDj/JhLZHwLjEv7lXm1J9CTEv466LASZcfy9d9yjOZKcCfDOdyO0uto6JOU/7HGhbGYY66V4tTWDHuqK149nWpP/f4Q7Luep4+CLHyk/kKjf6OyBRsJwGiCb2kbOZVGX9slvWFgpeyOwiTkAzVI8LShwHJOCtWh2d+NRaqidZMJAm0rztG29MwiZ3b6V6iNqsNmKP3VIKXFj+xZ2UjWuUiNskPd6/2gTu+3ln3oW0fkwLfoMr9rAoAJCEcHkK/9LwvzVRFxU8YORScarY1jNkxOGitL8bRAJw8i2OEA8nPw/EMZWx2r3B8JqOCltw8AuRUQHi/go7Kfa9tKLik7Kcj67gWSnHfQ7bvnqwYA5qApD0anxkUox+vQggh0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba257797-e91a-43c7-ca7c-08de318c7ffa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 10:21:04.6864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzC5uB2VomNDZ357y9bBxlxrqLkOGunylKPIu9ZfAq+Jm2c0fsPNADrgLbj9mlg+vAoJ2MLpha5kKPzb6OuXlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8004
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512020082
X-Proofpoint-ORIG-GUID: ddfcmQQoGpr5T3r55T9XOVRvS3afonGs
X-Proofpoint-GUID: ddfcmQQoGpr5T3r55T9XOVRvS3afonGs
X-Authority-Analysis: v=2.4 cv=W8w1lBWk c=1 sm=1 tr=0 ts=692ebd94 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=hD80L64hAAAA:8 a=yPCof4ZbAAAA:8
 a=l8_hpTQy-8jfxms2l5EA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA4MyBTYWx0ZWRfXxSQMq91f5PdG
 XjAva96SbS9ikikCtYnMv3mKHfHOzMyKHtJj00/CVmaIDozmeEnsBa6+TBTzf4CjWUlFHjnPhqO
 KdSLLTfzTIQtlbmJi0JmogETkaQLLFvjQKr0K5yFv4Nw3EX4ryzRIBDYIlRhjJapi8IHJN13ex5
 NNWHYiu3/GiPxZzWI8/dHOm/dKfu30yft7Bpmdg1BOgPe+gCRQQCcxLH5shWaJFNGVWqJLsu4bn
 +dZcwAJ+152qMej9g3qifR1W8s3mhYSs6vKHreABeNnVIXzbeAEyRIWl8qMS3s0m2NgK9bTQhC4
 KcTYaAnjQIhO9S71/8hYekOgdgO34iCxEt268ROlEOXrcDrHz8kqFo3XOIZFsSU//J4Qe04deSh
 JghIawBgV4FCR1NL7jP4tD7V9TaKag==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 526D3160003
X-Stat-Signature: f6gkq4at4ma1wtbr6z399a9o778mpeie
X-HE-Tag: 1764670878-812683
X-HE-Meta: U2FsdGVkX1+TMHWNaBTjqDFjeTNAjd0/uquxFqxAPHK/59XuFBbOcTtDtS3fZCs1Dn/0etwt4gGi4cxGMZkpdL6KVlFdhHFx33mcF6HFAEjCwwRky/X1MHo8NaQmGph60sGooqNV42ggR+2T4riS5YFM4vEdFMTa6hcCM6/9jV7Oe94t1eO7XSleEP9ONS8EUKOlFzjeDYI0LmN7Ua9Gekr2xLyOJfu5nXrMh/zXcE7aYzj4nzc2OqxlDItNm8Ds9KuPC1NBW5pPapB25fBXVfb7LQjkwfz+lMQ7wcfVCChbZ4E9HTYATQnBFUQKVEKEjxow+dQ7pbuU2srNhDB01rotG0r0BNb5as0a0FNPaxJSnE4tC6HRHY5I0kIWKJJgj3SYifB9L6Rm7ool42uuWxtUjk0zqFH81ovtLDuFPVJ4mUDDk9zZaDDUVr8zjU1IPG0GJBe0dZ1U/6YIG7m66bveCHVqvdx5duWVMuqHCsPjO4JTCtQYLqxoDxdjRDR+bFLWqkH/vRsr80x/11Vm6ghOlbKW4G9OX0p4xrNTHnYzP39xSxsKQwYPRLSmo8B04g9TphfxKp77KsT/AHb3vq+gS/SbyGysQarhNZ7Vzg+4r4UKEcicXuR6JvI3j0tC/mcNDyP61Q8rD2u8GSwoi3/vv1xidw7meQqgtPE/83w5da+mA+rTIK+y6DTwMhNv9P7MxtGMWUmVat0MkBjps/NVJ61hxIv0bGNadN61TGOkhy6XSfVxPy/twmfEQuBwJn59XuHKVb0oQ8VhjJL9/z4FXSitzwStwxcen6xy57zR0BnFinXgh58BN8RGK2ex87VCgZb2V4Lg+tsF3JrBfJLsOEsL6vIsGJqre7ErhvxvQrdvafwA/z70wEZbDaIVVjDLV543tQ0rayGCkJwoTYkqRLe+M0wOqzI+x/G544NTK9aTlkCaR1TCVuwtaxE4huF7vFXfl7a0a5qE25c
 WJT8G40N
 C+oUpJrUnqVwG7w6cFQZb7/7biLEfXECq/XqZx/tKj9q4i3XBHS5vkzX401DgJqHn8ul3WSzjCg7V1bmnWt0lmuizlG30eMpM5RAcjlheRmXRkV1yLNt4m0DxnvbNThV4Lbgp3kRdY25S0G8aulXQGcSgwo+TxbenmydFgOtf8oFITPqnusSGr4rTleEfJ0I8B+WVmpJBdYgfhLvMdw/Cq3MtNm1xG8Y/4Bp6XnIclvaevsSopIlokVIMRnIvn55JYtxjAvK1s+0SCTYH8nlUlu2aKocaqH19HcgUeSjlZxu5BhB33/PLR+3DnkBdVk3uf8qAb/TuyOLyb+yEUL1CmulZt2qYGs4oPabApJMc+Qdd0ifuYA/qvSFNaLjG2ZezfBgZIWl86TdNct3sX5uSI69JMtXn0HNEr/5v6yJ0Bi9drtAtGz81sLw+gBWocY5o4/0PdV+QotGlLNwKup8BAGBsNT6dsugxzhbD6VclaezDdCysX5udfqZSqzqiYe+u4nZPFcpOAbPXXDXaFF63sW+eosuYwZ6F+9F8vopyErbIrKqJ0JOPy6yewzHXS+vKd1Z0EfatcY3FVY2E2NwFgPsmgkzQ/jyEJA/augqKmSWTF5AT1PZxgQAAZ4HBo01ssB4ZJHfc3LboVEzSWVbzC4ny/57a+IlOkOpUh3lQPj57G8cF/9Fb/aZ2xv45tG8chqFAQboS2hGcB8t9zHyAbXZk0m3SNp8+ef54Vx5avODZAju6O88cASGg0gr4EMs2GJdYXOqpztggx8FKFZdAb/hc2/QyzfkzUrGoeI0MqQfE2Aw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 07:16:26PM +0900, Harry Yoo wrote:
> Currently, kvfree_rcu_barrier() flushes RCU sheaves across all slab
> caches when a cache is destroyed. This is unnecessary; only the RCU
> sheaves belonging to the cache being destroyed need to be flushed.
> 
> As suggested by Vlastimil Babka, introduce a weaker form of
> kvfree_rcu_barrier() that operates on a specific slab cache.
> 
> Factor out flush_rcu_sheaves_on_cache() from flush_all_rcu_sheaves() and
> call it from flush_all_rcu_sheaves() and kvfree_rcu_barrier_on_cache().
> 
> Call kvfree_rcu_barrier_on_cache() instead of kvfree_rcu_barrier() on
> cache destruction.
> 
> The performance benefit is evaluated on a 12 core 24 threads AMD Ryzen
> 5900X machine (1 socket), by loading slub_kunit module.
> 
> Before:
>   Total calls: 19
>   Average latency (us): 18127
>   Total time (us): 344414
> 
> After:
>   Total calls: 19
>   Average latency (us): 10066
>   Total time (us): 191264
> 
> Two performance regression have been reported:
>   - stress module loader test's runtime increases by 50-60% (Daniel)
>   - internal graphics test's runtime on Tegra23 increases by 35% (Jon)
                                         ^Tegra234

					 just a minor typo :)

> 
> They are fixed by this change.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/linux-mm/1bda09da-93be-4737-aef0-d47f8c5c9301@suse.cz
> Reported-and-tested-by: Daniel Gomez <da.gomez@samsung.com>
> Closes: https://lore.kernel.org/linux-mm/0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org
> Reported-and-tested-by: Jon Hunter <jonathanh@nvidia.com>
> Closes: https://lore.kernel.org/linux-mm/e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---

-- 
Cheers,
Harry / Hyeonggon

