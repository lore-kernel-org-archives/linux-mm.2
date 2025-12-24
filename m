Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9192BE7491E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 08:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580C16B0005; Wed, 24 Dec 2025 03:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F3B6B0088; Wed, 24 Dec 2025 03:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5A76B008A; Wed, 24 Dec 2025 03:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A90D6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:44:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D50A160629
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:44:41 +0000 (UTC)
X-FDA: 84253728762.02.0A8418A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AF97180003
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:44:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bcKC6DU7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GkS2/UqI";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766565878; a=rsa-sha256;
	cv=pass;
	b=ZCtOUGXtq+WyjHk/6yB8J2bfJ289jKF3m1Wm4glc7I5BboxAlW6Azsg/yPs89qHJqsEBcs
	0L2EdBsizkeSKk6dXgjShUAT5q0tE8RYqLLGSkPf2d8/SWbZfFwWQyTNdShTh+szK4A6p1
	oZo841qIX1oqp3vfOk4MvzKSLYu8d3Q=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bcKC6DU7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GkS2/UqI";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766565878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2iIvhXsC+R1lC1rr04ZsOKssBWap8bnSfUN/3ZaL38=;
	b=k0mtPHmY2TTCRDEXAo5Ux0LQ+WSmDO7Yix+OwgLNGjGcQSpUuGL21jrhOXn0aE+VgTkPH2
	fS7vHZrQKX70PnkdpgZpnRe33q3gcqUH2AMcR0e/BEQzV6leo3a/V/WBKc8Ay/HTXAx1jo
	WI/Snqd9U/ZZkMesfGahHl6brtL3Nps=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BO81Nsj2147886;
	Wed, 24 Dec 2025 08:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=V2iIvhXsC+R1lC1rr0
	4ZsOKssBWap8bnSfUN/3ZaL38=; b=bcKC6DU7JOXSAK1RwheS2FjPSqAWgwMOC+
	caHz4yxrIpzqsoARSP5UyYIaXTNXtG1PzQMxZHYdK1G36eh0MVZ5W5+HxXEbIgqe
	oW1PG+Z69sQQdpueBN0169WNs84ST5YHOvyElHhIC6E5R1dq9Bdrp/5y9bd9sBDe
	1+TA1AyZLc6zMkK2+1PDWGu48YLfhcGdT60hYNiQCEWlVF4g3knhBMZwEOmW+yzY
	La2MzeQOb/fS8kqM683BOZ6XND9VrG+ltfDJTHz/U4u8XgBLUa7fcmLCRnCOYL+e
	Mvtf1y+v2ldLyyIviCDgEMfFIM+MoQEbDw3b/IQDzPQxIlnEhFdA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b8ca4018a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Dec 2025 08:44:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BO5pDRQ002716;
	Wed, 24 Dec 2025 08:44:05 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j898as0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Dec 2025 08:44:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCPmCu03ntpafD4bu1gT8YuNKRyNf+8gYSMRKtHgxenOg0+tpCBhAilBhwoCNEsWDHB2NOgL2j033diB+mb2Pd4qXeiW1vvpOuJNo1wh8nCH0VZB/ZAwTUxWJs/Wl0lmQGYFBT6lBQzM41M4njxoCv1lA4HQuBso4m3otpXY6stVeSo+muv/oFY79ugdUWpXs9u6peTR2pB4+PTtI7xPSemiCf89d7MfpuUvkwU61OSfHPpNHC1QPjB7+z5isXfF5o1Mr17TVpYt7IIpdlDBHE6t3s8rQ5RxVaF+2Ls6NGL6hXz9eGUl8tsywN6u1qZ3z95RPK0vqT+O0BuW30QNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2iIvhXsC+R1lC1rr04ZsOKssBWap8bnSfUN/3ZaL38=;
 b=q6eu/wSoQTElqC0FFnEdWCNIhCfgGZSDuDVsqu9tpepYxkvWnV6zv3z8J+evEEWpWJfrBSoBW4QcxM7uxboVihsjbFEoSvxseIS+aK1wP7AzVdg9eL/zYqbkHqVURbMirVtbSBM/C9TzeT7OmbPyZdwL44AxFJ304hRhZlmMnqzyryHM272bIoVmSPAxOs20faBjf/0N95TIUJunSK/uMt6nuPoeIFgqhRBSI1EanMgjfqswVddoWyVbhJGPyWdlv5RDHTeABm6UQOnA6/R0upHD86W/VzaRqJKxOqfSswM33vvEmQcvfJDP3CjD3FKEp8SDrSL5Lvrc7uA44bPZkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2iIvhXsC+R1lC1rr04ZsOKssBWap8bnSfUN/3ZaL38=;
 b=GkS2/UqIEjeZuNJiQ7wA8+E2E9vxyD+/LFGymPUnz97A7ipJ02ebu8kFF301Uir/yyDF2Ko2GjnB6ShRGoK3mWKykvBjjBmZY7CEReruIpCJQOSFND85fjlt9Lys+rYh2bKTjqrU4eF0vjd2jqDEup4wf5IsoiorU7VN8AF5As0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB6987.namprd10.prod.outlook.com (2603:10b6:510:27b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 08:44:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9434.009; Wed, 24 Dec 2025
 08:44:01 +0000
Date: Wed, 24 Dec 2025 17:43:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
        mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        chenridong@huaweicloud.com, mkoutny@suse.com,
        akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
        apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <aUunxoFxrx5hiIPy@hyeyoo>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
X-ClientProxiedBy: SE2P216CA0020.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:114::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 33c3bf69-6425-4582-4010-08de42c895d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ja1OuOmwbMXwDxMdqi0l7qRWbTk22z/voDMJ2MFuyK19/VPmPpWMHwX8tzOb?=
 =?us-ascii?Q?cGBDcnNAkrpdtLehY/cwX+FXq5jva9oHIFd/xJxxgKr0qJQ2TtjZIahC3APN?=
 =?us-ascii?Q?ezqyQzdHDxFcI4uptMBBMEQjSLPWmHHEeM4yd2/64gAW/m1d0zXUs7r1OD5D?=
 =?us-ascii?Q?oAppTdxWp1CdNetwtMnzyrnHDUErPePfvNpMF8qHs67hAwlx3x2h7b+90Flb?=
 =?us-ascii?Q?Psx5dQ5Vp9U4uwcvuK8zOuv0av4yL4mK2pHuR8xwtcXZtmB3ltA4NyPOJ/Np?=
 =?us-ascii?Q?WMA1ScdW2DaqqfPzgGgqIsWccTY9k4taNq7bUKp5Esxu+W9tOBivKyGL3yvE?=
 =?us-ascii?Q?yxTrhuT9+7AqgITVVMR0yEwLdyouyxvtkgfly+sWImxNnFx1jXbtZfhvfzDq?=
 =?us-ascii?Q?UIZ/4k1/M0fSa8T3kwowkXvGa/zq4Yllw4wVkLES4sgmF+/SKgHHiwHYjklz?=
 =?us-ascii?Q?pvQnWP8kouE9CDxPoQKGq/LCpk04M2/OBTgPJlejOCVBkwRISPDYhrTyq8cN?=
 =?us-ascii?Q?hpe1/xfqDaeouDzU88mK4bWIOpJf/RLPQhA5bPHTg5N0BKemQ1HiGr7y0vny?=
 =?us-ascii?Q?mXpYZxhMYEFqOw/qa46cuyEK6f8f58yStw3zwrSSoXuuKn0hV4J0Hh8tepod?=
 =?us-ascii?Q?PP+5JwANGccZZf2++U9NhDe/6s38HjAjIusAsoJe+q5jaJwEvUx4oMohkJ5U?=
 =?us-ascii?Q?ggkdxE8cFADZO80Zs7sPteRwQde8NIy8wczJuQHZw7o7jbcrs13q7yo5UUVN?=
 =?us-ascii?Q?2lCYQVy6DQ4MsuNkR/RKGs/O5hZgD9+YB0t4uuafh/Xc+a5V5Zn29dOWUoiQ?=
 =?us-ascii?Q?rKCpEkjISnIUGZIbIlUcBGWEIxjiWjKBaYFd9vx9OmHJPhObr5+evSCQ4BnH?=
 =?us-ascii?Q?ER6gggLcGw0SANmFaje2LINL6C9y0TV0nXoQFsIq44vAwHnJUwba5Bg3BWut?=
 =?us-ascii?Q?ICEN96MLL/bvv58HIrFHaiN0CLdkQJIIEz3wU8JSpG94DPgJHWw7fWS9OuFs?=
 =?us-ascii?Q?EScFh3wrobJ8NoilRCs+eQ7o95KPlBlNbJDGZBWc6XE0znZrTjV8fQcy7URZ?=
 =?us-ascii?Q?Ko3b7Jk4zfFpbJv1OLPg0coPRP7jdtnc4z40dS0GZW0Njna9tXzd3PJkAgQR?=
 =?us-ascii?Q?aOQFPR9a7pN/yszZGK2E1zdCgG+yNHbWIbv1p61clR0eCnJQvPej+NL0PrZl?=
 =?us-ascii?Q?4NeDzgFbePjjkwU+DBGSsLcfC8xsDOpYE9NF+3XeYNW/m0ux93pIhhaloRoq?=
 =?us-ascii?Q?zz9T/bLdw19vWuDZ93D56TuVBH1V0KLLxFyy51+ZzRSnUnwHm3ybNCKiDHiS?=
 =?us-ascii?Q?66D81WQLNwGMpM0mjS4c2WN/wcMMZHy91kEw01LlvTA2Td4Rot9sREFhB09m?=
 =?us-ascii?Q?Sqe7XWHGvtzQ6+DGXW1XCcNiBUj0YhejUcxJhkh4QTRqZpJcqrx/w6pmSLdv?=
 =?us-ascii?Q?GhQb+EZb3nLcd4UCTQbg2cPCVTzUoPKrBtnIq3iD4JKrUzHOf7abDg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5xlIrAgwkdK2G/R7oB8IuGdHdbxV/8TQ8w9YFwRuJstZr0dMgiFngXCMSGCf?=
 =?us-ascii?Q?OhrJO10/3MNcJGkD69UJ89Rq5Utc4TwHe8ppHRXDRsYElbTE8bdr9TzcR6XX?=
 =?us-ascii?Q?8iwEcW7ofQRgLYU39cS+D8IW0rrNxYTQPo5q97YfEXy2ThxXXW5B5/U82VJg?=
 =?us-ascii?Q?xZBbXC5EqpFBvpTrEkJIRNWNpfXC5d0XOO5ej72pbBL0cN/bqHkmY9UtAaoG?=
 =?us-ascii?Q?mTA0depKbrzCK8ugMJEhbQO8E7WwqF7ksOObO1TfSoNQ2p8xGvDDduJ1gjnr?=
 =?us-ascii?Q?bRHrxoF/27ZdjYuzScY3lkzv7UDeG/80kLDeo1uuYPF3Il5Cj16mJFXXrZXa?=
 =?us-ascii?Q?5FSuw1WuxMk0UGpL8TbR3aCqXKRq9bmAjZgNjic/oqFKo6/8fZt5ND+W219X?=
 =?us-ascii?Q?RIJHSNUFlwu1b0DAApK7BqwGxxGEIYDogEOm5ZRaaTEOGTral63dagDTvSgf?=
 =?us-ascii?Q?W0Seq6AqKlAvnAgfHCNz/s1dmqobrz+dd3JGmUcVAA0Y/wZKQQLHdmMpmACc?=
 =?us-ascii?Q?JMjYqqINTcp1I2CZT3EyWKRvzUBhjnxm8l8LQjWtNj8oT1qWdOvqLUuixaVw?=
 =?us-ascii?Q?8KEoGtqFbhsfLta8z2c+GzktLTZtzbqyTplCInEM4Rn3s4F+j5zGhEzW+gVF?=
 =?us-ascii?Q?zLCMH+9Efa8NJqK1A9yLMLIksEPDC4h3nqXvA9eOgMQxpGTjkM3+8X1TQzN8?=
 =?us-ascii?Q?lPW3FlW0oU5aZ9Mh42eke48hVS/on81d0CWag2WcxcFui8yKjt0WnT7Bd2dG?=
 =?us-ascii?Q?bTgb2xHBwWWEJVw0dH5iNlsj5vqL4bVqC2bmTLDXWKMkole64hB0fl72Izx2?=
 =?us-ascii?Q?dIvve9rW2bEKVPtKWxKQqETpopbBulP+G7B+kpOZWG0h6uSiF+dAL2QegTC+?=
 =?us-ascii?Q?ybv5n0rnXXV0o/MwhzKZV2F59EILc8dMHbvmwyfPX+Ij0RZY75CeR5vmGCnS?=
 =?us-ascii?Q?+7w+k6GT/kFZcUCApEzfDWcCweAZkOVNoj+sw8ah8vHPyfTLiq21b9iftq0e?=
 =?us-ascii?Q?V2OqoEtXl9TlAeLwRV77BHh1wBZVbUSIXo/lWAzi7jnU/6dV49DJD1SO653s?=
 =?us-ascii?Q?eIJcuQryuxJKr/bZyGp/iu5rC7xhw8wO2EC5ROcqxkjglB4OVMpuIKxy+sS8?=
 =?us-ascii?Q?FUhUz3dyJ3rP0t3nZEGzQcGTiKLrRV5lm0gnCUBSTLuG7XTzQSoeqopAzctE?=
 =?us-ascii?Q?xY10awNtw/I++pBr/Lt85hwwdCaU3tvUwlPoXx5MPtEW0Oeq++jnQKpEG3U0?=
 =?us-ascii?Q?PfKqeOPXuv/eLCXZaFv3GKRAo9m3VCKinfxERrJpZGFw2NRmEfl7TGGIFZ0Q?=
 =?us-ascii?Q?yVU180HQFFYlQQyp2vDqt51qVmnHXCCQo67fx1UHbfFNAultbijxjDJRUlt+?=
 =?us-ascii?Q?Qtfvi+IAxmJhIRLlQ/9yMkizUvHVVXPqFy14liXXIDbKmOUUVUJARULcod8z?=
 =?us-ascii?Q?RNSpX13yrjuGqOC05YavdhmVq6mdyLI8GnsUN8qwlMMLhKB9OhQoqp3t8dRD?=
 =?us-ascii?Q?sqgiZnjValISawNb0nzIMpmHWLzw3zAt0oOb+6gPBTg+uDvmWD7yqFughNU8?=
 =?us-ascii?Q?JvLRd/v5GZo6e6azuic9mYraVvzHCzp2R50U3BGgYCb8SUU49okpSR6MAjqC?=
 =?us-ascii?Q?3aAPyB7uzemzkQLZZIIfTiQYVIU/+raHqBVKv28fIeAmJxn4/XStAxZT5hI9?=
 =?us-ascii?Q?qRpRm7ZEvP5gSJlC8JLhZdY1BmOjXyCXhad992Z9+eKdVtWznNklWUIK3Mmb?=
 =?us-ascii?Q?7PL6O3r8Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IZdrDs2gr3132XAy0Hmnrp/rJl1zgYGRQTpkarjrFLdXyriK/MEcgpDrn0vxdQISIpKwm639oT0IZiwMJ4tFBhn/m1wji6S1szNGpoVY9QPxGJC80W0cishVEHVc+nEq58qYQIgWX8o7uZOD4YgJBWBqVNDU05Y9xxz7oPXIS+bNRs+koZEMdjFpttFSad21xTQ8dQmQvJRHmrj0BDAio/+lFkB2ukqPj1Zu2yh8H9Ta01WmFL3ZfHUoaPkqKsa0O2dxsXGG+p9e9x/kZiCfnKJ21ONUiT7DF7XIJnm23oUxy6dexiSdlsLRKJ22h/Qa5M1WSYnJDwhu98QVRi7C1aNsup5MUbEtwN6Lo5xlyfDs+5ncPTdhFhSVDzJhzj/0z4hP880n+3zXQv91Xn2gYyPmgBFtMVQZQYMQ1xEgi4AQBTJ0VAJN1PqWWisMWUf4WC9g0w5EMA1sdYgVtsfAIeElNLdi5ZIHKeA2PQ8ZG0/bcMw2WHW2htINF2T4nJ9ziOTlhNsf2tb/9yJ0hTDaOPyfltCVaemuECXuHWVpnqMixbTRhK37sQlhiklYag9UGm5PNRkD5qg0Orn4OYJGWo6IRdpD5CW6GIZXdIXpzRI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c3bf69-6425-4582-4010-08de42c895d0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 08:44:01.1084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3NjFXh4JIEulEeBEAbWXp2jLkDpCatjd1KAZv9Yw09n3LB/bsXhx3jv45LJGBhYK3iU3b/ykyokb4AqElfyzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-24_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=946
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512240075
X-Authority-Analysis: v=2.4 cv=UKHQ3Sfy c=1 sm=1 tr=0 ts=694ba7d6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=C6jE59H9nFRu0-XrRU8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ImbbzA9QHS7M-LppOG9G9qq-d53C5XCn
X-Proofpoint-GUID: ImbbzA9QHS7M-LppOG9G9qq-d53C5XCn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI0MDA3NCBTYWx0ZWRfX6LQyxvTVWYMT
 0KCV8iO6NLWqqb7+0JzAbKc9Y0VpA92/uAuFfqILyGPAIWTLNC0qXHP4EAkh7/lnlP4NlP5H0YI
 utKJ7Gy9ef/7LWU2KycivuJT6uDph1bR/xjMxKmV/2urEVjqtQczchAYHdSu3Q21JRBViTK2umT
 PPtWg0lFmQdFrP7CVyCRuIq7IfuEY4dzqLKkPqiWSW1Yo3e7DXiQmCWeLd0JKY3TyTDhyqljCUb
 3Pbpg+tVuOfkLiCUsMzdB1V5jpHNkurlCmg+wOQ5ny/f45FBqWTO9NDnvuTdVbJz0iO4XVIqJpp
 zYQDdel8dFeBBGUNiCYipqqtKOUlbBHTDWUxwBGKaGQBzcicVSKWPW5O5JHRTxzmRtZ5Gj/np6p
 80gb4HpC0IVMIRbRqEdd6hiYcQ4iMnZoTTXSLO7J8iOo7RLL+3JkwprQigAK4210vhv+hcGicNl
 It1HTRnp/Js9xdnLK5g==
X-Rspamd-Queue-Id: 2AF97180003
X-Stat-Signature: xzxbzgmn7eegt6qwsaiyosuuz5pootim
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766565877-439994
X-HE-Meta: U2FsdGVkX1+uswOWR0WpaviW5/CZ5BivU7V5XLyFIbrowv7RlA51JAGCAr7m9TzqScHUmNCkw0pcEyKZv27peYRMMy899ZPCEI8Ek0NdOnwbcgCUcQLfY8RiO2lBvy9oRkgzQMS1GshtUX+x5nsbPtMGfWhJ9rWafPnAYtkwJyG2P/RSSyu2bW5asf5IdaYJH1YSjYRfKPnsnRDtU8uJwGXSaxlZRojbNh7a/L55+VOKL1dAZEQVcORHcqkGjNGaO8qdEN/Mtgk+GNp/DxOrN59HD4Vi2ojeOXmJ0ACCE18REECxG21wDw53WIuHBj22X6Aj88yAhf0jajQgbmKPJC/FQLvre6O423yLD18ZxvaPisM02SdUnTamRQ6mm0whiUivVdj6ZSwltHsowquFYldGiA1Awv3Qhbik0cBWCqTpHzLoSxErSNHNNnBSIc7JRP5Qn28swCXlo0Sl6d4uuFNMEIGur+aOAWTwwMJkoQe0M6EHdKYG/346QV3juhpGD8whFi55H6o8Ql2gYeIFq9YO6JAWUIm0Q3EOI78mVHuFqBRHnuoQtwkNkDuLIR4GMCvcXIHoAm8yX5ZpjJp4qE9EL5w5NcUfv3uluyFFJohuIee+ll9rWpPk73ATeRVR9EZ7bF8X5teViALWc+cFvHRYmozpnUEhMEFNQCDhYWQLD56c5rIS9D6xqUdbNGUGuTIj8OCdspmcezOXd9nGSsUazkz7MGfnHXzisotlrxZChARQX+AQMvmdKKsvbMrK3rFzczNaV0KtGsN+/HgsC1KhXU4p+E4AEz5CpgyQCFLhOvUt28WstdPcdCsFKSu8161SlFocqsKf9rA9Cr5znEzqW+bZ/RWNHmwKOqiG5N8KmnKKrNqyPwOUV0M9OV8eFFkgHLPAoYXg084Av9ON71JlKJ2OzQQNmMUIqDvr1dwfaN/XU4aIK0/J+0GPBXrjtyyPLS8v+3Y6pK0Akig
 mu2u2eT2
 3Y0AANPPzg00bLNP0p4+bB+r97yxI9fKbnE9DEum0dZuQpHCiIIpuZIMorPGRKgzbRhxkVFYLVB5ZVH0c3PyIEFF01Ga44C0YGeA8Y6j0wQrPrevQfZdL0ZqXjC6PDyq266e0He5Sb/BZXGIKkV2MpHD8fKLn63NZM2YSxafTlSTRSYke/M4FWBCQDmIlBHRTtRL+3dP+Jf2JF9EllMY4VdvRPw+nrYhwn7Sfs0ebA6R0sde6UFAHylbBMBSPDXjPS3hMCKWInWVMYo/BW5mYMIEnXo/Qx3VGqnOXtL0S6bSdxaOfsMAxnZwyYuGwNhM3nNd+yjqa/RGyrwGp585xyOrRoBvPNl2Qf+E4f4Jp7/4Ar9UB4Mf8c3UAaRgVzzpHLSpWmKKZvEPrF1bfJvyjQAEL83F4D8dOZ31OD+yTXXQicqlAClANrOwr0FUR/DznMe2zhGzcuOlYDJYuTlftpGLRZPNm/G2ZNUWvGSZYRnS6iwcgxNQqLZUz0pWTu8k0h+XKZ6FNfH99IcOAe8lDny26gPoVrgEJQzoykBA8wDsU+Ih2PHnFOK4/BzfCtMuoG6MIVyQpubW1b53m3tWlhgC1i6K2yBSwChSpgu6vkdIIvHq0A2xqjPIZRDUxSSHTDGQcgZXQQobKhKy/YHhpx6fslxFasjeDZW1sy/d9L4zgd24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
> I think there might be a problem with non-hierarchical stats on cgroup
> v1, I brought it up previously [*]. I am not sure if this was addressed
> but I couldn't immediately find anything.

Hi, Yosry. Thanks for bringing this up!

> In short, if memory is charged to a dying cgroup at the time of
> reparenting, when the memory gets uncharged the stats updates will occur
> at the parent. This will update both hierarchical and non-hierarchical
> stats of the parent, which would corrupt the parent's non-hierarchical
> stats (because those counters were never incremented when the memory was
> charged).

Hmm, I wonder if this only applies to LRU pages.

In theory we should have this problem for NR_SLAB{UN,}RECLAIMABLE_B
because we already reparent objcgs, or am I missing something?

> [*]https://lore.kernel.org/all/CAJD7tkazvC*kZgGaV3idapQp-zPFaWBxoHwnrqTFoodHZGQcPA@mail.gmail.com/

