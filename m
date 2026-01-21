Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC160D46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3858D6B00A7; Wed, 21 Jan 2026 11:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30EED6B00AA; Wed, 21 Jan 2026 11:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150856B00AB; Wed, 21 Jan 2026 11:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD7766B00A7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6E90D2F85
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:10 +0000 (UTC)
X-FDA: 84356561100.14.C763EF6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5FB1C160008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SMYVE2m8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PhGPdREM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kIx4wvN7gBNHQJWPkjQ46qVbyhoGlUy7YTDthEIWgGQ=;
	b=7sSTtT1HtKSumW0HAgtXVv/ETGU/3dGmQ1eoxZlJ4nSevB2Bv4qivlrnWQIZjZCxOX/SM/
	Qjf8Mpgt4rhgntmW4VbfWNPmijdeNqAglhNm8SFF06WRaR92Jm84kXOHIH3yYh3+BOockW
	oxDwqLeB0ioZG5cpWQt6+R5YSSpGdeE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014267; a=rsa-sha256;
	cv=pass;
	b=4UVrOSGXt23tNHYmRmZBTceIzhHAkCXwKZeMzKZsH9ACWtlkPM/cy6m1vyM24LlGlAkZZF
	fUT5XitcUHsgLiX3EB3L+DDxcj15IrUiTwaSAIsuyQozkCtdZ4XylnogGaovySUQlzM/wj
	dk9UAPML5HVGN+qqaULOF1ShfNlrDQU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SMYVE2m8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PhGPdREM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LBlV6P1167180;
	Wed, 21 Jan 2026 16:50:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=kIx4wvN7gBNHQJWP
	kjQ46qVbyhoGlUy7YTDthEIWgGQ=; b=SMYVE2m8Ub9wU3QNlCBqjcTfRX0H9iCt
	ItG/BoP862C0qql38YBK4iFPToN6e4oJvwspJvUsBy3n7hXbt2aTfohxOTSWpqtp
	U9b45IZDUMmfw937hy4LnE37IFf2LqPpwlGx2XXT4hJTvxOiZwkzIaoLiKmmypzA
	Pta+YQGMQHs6sSTV9j8DgycDZ06EfzboZdN5I/t/J+Y0AeuSDirF2vEkH4WQOIr2
	ZsR10g4dOHA9fKbd6HJlRBqzXsNqgT0ibBnOu1hWTynvfKbyYvboJnVextC6j8Gz
	v8ebJ8AM/VjqyMgVjeB4Dwlls3VP6iu1PPrrFHYqAXgjc03YXv76kA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qednm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFl4Y2032164;
	Wed, 21 Jan 2026 16:50:46 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010003.outbound.protection.outlook.com [40.93.198.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfackc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DM++RnX223c9iiBdqnFKiZwUlq8nnBlMTai8miQPKlsEjBEcgkv3U28ii6t2nfsAUIMl61n8B2+oLoGbZuSLq7XqbcuAUqnI0EjwMmagFKd0GAoIffBKCMtNdb+OXKD/5jcx/ItWXr4FPJn/w/tSUasUKKWi2J3qy5Up+xDXToNMtqYkL+4uRNBv68XuJqlZI6lMPPEIMY4wwi4uODlCxWcbiS0y6T+yjnl3JqadqhNAFDlnujJuWp8s82cWcUUrwfgb4vZKCOYSj84NyHMpwO6N3SgLmVR2jkCBU/guHic0L/dglNN5ptLM4NhR9bYX0K8ZLLnkZ3VdU76GY0jzhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIx4wvN7gBNHQJWPkjQ46qVbyhoGlUy7YTDthEIWgGQ=;
 b=IizRoFg38nuGVWxlXoz6QDh62XU7MHa0c1LjG/nIYlpnKoTtbbl6x8vgFnSGCil/txzgEFcL74aDcYuG+MtOzAY1lqlo3GVItM35J9kpJ2+t9atCBTULFkkdOPM5IqR0UdJ/4S06KyWY32E8fPU9nKFUU8Uq/Oj4xL//8+DkxlwYmZCAqoFu1dFVqbQ7BhdA1gvIH3PB1gIuklqtrKZV+8JnBpThcXxlAkLXhk6kO6Dwd1a4z1RqWkJzZWPXI0svtcIUZgVqznGn+0NBlR+KIT5sTG8OAFv2SNVmZm33QfXo7Zt7DS0H4zd04hSsmLeGLPtN8y22fQsr6mlS/uGifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIx4wvN7gBNHQJWPkjQ46qVbyhoGlUy7YTDthEIWgGQ=;
 b=PhGPdREMyQ2Jqi6e+H/4qsJM2OrV/D8PajT5R5TgAhvN/lyKdeshTFu7+Dz67QI+HcNaJcnBBcpRxfKm9dph0xDKTTHOEw0wj7UgMz0k+may1ISyT8U6VJ6eQOMspE008wfCHkP0GsIxF3rUYoawSJrqPvmExbhVMROkwhScMk8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4255.namprd10.prod.outlook.com (2603:10b6:208:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:50:43 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:50:43 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 00/11]  Remove XA_ZERO from error recovery of dup_mmap()
Date: Wed, 21 Jan 2026 11:49:35 -0500
Message-ID: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0128.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: 937ccf3e-9c2c-4509-59de-08de590d3774
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OyN6budE9SdeOgX8E8J9rD0M5lFTcMvA5afSU55l/uIr6lWZsqdw+5C/ggye?=
 =?us-ascii?Q?gHMl4IHZGsIepCiGqqAk4d3brft1iLk/ayf+lKW9mMfaXhlj9V94IBfUNhsm?=
 =?us-ascii?Q?HoQL3cpTaru+aXSq6LqPuLzwZIOmh8aK92mAe8DW250DnYBHv2sWo/8el2sG?=
 =?us-ascii?Q?f7J3iF2fsbltYMIcBVLEaPQDRfWw1IrMW7/2bJue8bd0qfET4e8nd360kLgc?=
 =?us-ascii?Q?3nAPUi2GzenHUkOlUXHFk4ybXkYEgLDicbhymmzU1A3MJwKyPJLGjP53BzP9?=
 =?us-ascii?Q?eXA+G2qPTxWDyFs0HEDr30DQWXi4HusOMShwTPXYHit4SlO8npVNLftF4c9J?=
 =?us-ascii?Q?zDhp++xgNY64g5KF/J1bv0gEpQrczaLOkA659cQdcVCdOnbPcZcptquSCiAo?=
 =?us-ascii?Q?Ob3RPZrD/gXLOYiXDH/k/omSljXFPR0ORxWtMoDAq2+PstXd5ZCytbFuG47V?=
 =?us-ascii?Q?L/XSHV2sIhCCHPCPpS8Qf+wekC9wKrQZFxbqIyIWANrVLc8fRSw2elEJBMXm?=
 =?us-ascii?Q?4DaD+I9ZRz02KacaryiaQR0UpJ2L6MtA8TkIJXIzTvjrQS5d68N88Pbg8lLt?=
 =?us-ascii?Q?RFJ68/yVyF4MxkRv6NPpf9aoct7mrRqZqwLE8p9ytoNpXX8vK3spxmBjNSP3?=
 =?us-ascii?Q?1O7kSFub3dfGEnJCW6dxrML99jhJ17uXMyoEl1W2LcvjrAIeg0/0ijVuuy5q?=
 =?us-ascii?Q?JqJuGD+YiLj42h+WaOfVRSAy1CK9AxUND+Kc4JkH/cvPAxz3vPbKkm4ffYQh?=
 =?us-ascii?Q?IhMz3yUFLQ+IVQS23oHsnULWVxlEgycHZnQhB5L77jmZhzRo77jLjn8eWgYQ?=
 =?us-ascii?Q?UbyO6p5tP/RaKt5v/2H3/RoI0r4xb3WZj0c8BOUUnZgRjyDDqgqv/l18INfc?=
 =?us-ascii?Q?bLnRS1jhU4GpB9bKH7tO/gsQGbxCv4vgbAYF9MUOjDfu+6y2dpopA7ogaXdB?=
 =?us-ascii?Q?EHg9n5grJ8IpvgOjXWvxiy7ofsVZeaAF6XRhZTf9iLeV2w+bFQgr53SI1Puv?=
 =?us-ascii?Q?7UhLTXznXdCh7VivML25osNgT8jw2NlaMLCdKCN8boiOHdQZ8LQHW6C4n+/g?=
 =?us-ascii?Q?HAMfFZQgTzC0pEEcrDdQFZ2xjQGkHuqvTS9sPR+2SP/zlVFI+nAxS/SHS2zj?=
 =?us-ascii?Q?0rlsFzJgxPf82sv9l3IUNoxZUB7TsspjBJA7khRjArZcVGgOXfODH2XesjMZ?=
 =?us-ascii?Q?EDTGETqA5JhF1hso/dN4soEPKLj1T47dp1y3uwTUet58ZA7+u3+PZgHBoKKP?=
 =?us-ascii?Q?o1/4HWitAWM+6a9tFsF+Bjtqmp1FKCRYF2QKleMXOx19jxKmn5FBCsZ6Zoq2?=
 =?us-ascii?Q?6vVqt/oZHTTynA8c12ssuRS25uXy0cFEfwccAoJbcCPxCDtVcx+3nLKHAB3H?=
 =?us-ascii?Q?tLIl2lOqVZa084GTZd6q0T1cMnuWEEdbtVuffZOtnjqQyWoqDk8AoHNwtP2j?=
 =?us-ascii?Q?kXMgKy9dR9uyCIpLEJRZWcuoXJxHiu2ZdlzEgZvlBx9Z9ALLpAinNxqC2G5m?=
 =?us-ascii?Q?QMVIWn8v2l1rv0zOpiCrQb3rkiWwRufftSfN9L6qE8pLobc3UOj6QPi8psAl?=
 =?us-ascii?Q?rPDT8ZuJjJ4ZQmt9jZoMhr538nSw2+LFZbfdy9RC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F82kcYUxZDFq3eGsE0o+nl0JMVlskkg6iud+vCjlQO1gPjv75wUVL2KhVfEV?=
 =?us-ascii?Q?wdh3AldCiX8fV+ZDHAHCli15MIeMj3128sqobhTy6mUMP5s8lZVesfD8QrDw?=
 =?us-ascii?Q?VWP2T3NagsQg9Q0FRRWDloi/oruAGONgO3VOln6ip9mx96suYaEF7OH+xI0A?=
 =?us-ascii?Q?2Urc8RJzOAZE5Uij9rlSkgteSUwXOzqZRpmKUkP1fWuNUtaA387ljHME/Z/R?=
 =?us-ascii?Q?g05LzHYG2jyab39Fw56P8JFR2pmvrtYuK8dz+JB8OK/ivJKKexIwxFb+oIMp?=
 =?us-ascii?Q?qTVBIADwLOv+u2UAkpI6MTarjgV4uCfVcvj/O0FiZytSaO/HNL0CpVHW4sRg?=
 =?us-ascii?Q?8EKYb5fACR+vUTn1JobeqgP6nHYSEQDIx8LfCeyBVFfGfmDazDc6DqRj8QlR?=
 =?us-ascii?Q?H4CxZ5QQIYCK6c2+bQ7xnU+NDTyQD0//UEmeEuM4FRqs5Jt6UqMDQqHPrHmv?=
 =?us-ascii?Q?Mpn/5/11h2Wzrv9dMKWKNvUYHIxaD0JjnnevRzZtauFoMbjPxqCuirlufnnj?=
 =?us-ascii?Q?As11Qbg7SS+1aGBYlbC2FAJ7rdKk+UF3TvbW+3NvRwwf4wiNN0iwBBknIgXf?=
 =?us-ascii?Q?6z9fpz2OxaldLu04S2JLrNWOtEyuGWYVkdE5obNRHBEUN4cYH3VTsKXfEXof?=
 =?us-ascii?Q?2WwYLSdXIW3lKhzV1MuS1TJe1wBLIdtRE8QnExXHTXMZmCqtCSSnC7X1Jjv8?=
 =?us-ascii?Q?bwGr/ebt2DMxgnste1iBmxOPISbJ/oQljNqfbVoqUGI1mP39IAIBJkoawwCC?=
 =?us-ascii?Q?UHm9q2w8QTSEGP6mwi3SdVg4phVka+HnkwdbsQlFo+kbvoel42jY5Tq+/XSh?=
 =?us-ascii?Q?kcf3kAhDCtf2fRAV/CRoGBsw82FDK89Lh+kjQUTWJWCm0XHMP5FjeLiM9wy3?=
 =?us-ascii?Q?+xfQxC+WvuZ27ka3bMLpU51S8RHhM6JAkUfmiZnPovQeRa3rO9226/ichBw/?=
 =?us-ascii?Q?mdLtkqeuDEtJtUAbq/LzqdvJbOgGNF5b4pWqOvHYPzBk3P4U31xd6cY1CNrS?=
 =?us-ascii?Q?YPHnnTvWQ1pDVr+z8cvhwEBOojy54ziJCPDNTuXIv2Wq8LBaFX3fGxAE8wRm?=
 =?us-ascii?Q?Rlp3rbWbSd/YgPPh4MHWSQ4CuVwzHJhEcO/SvKQXuoEkKhBLpnT6wIgf8D0W?=
 =?us-ascii?Q?E092EZ2l6RqcVOo5Yf76d3Iz4jFi7IQVZOalSgCUsNyYtsd+lmhhp2mk01xt?=
 =?us-ascii?Q?gGxPW0ixB6GeAYyLhFDxmlgIa0Q/htqOcdIL9Cjt85w6uVjvMnPCJBlaU3wF?=
 =?us-ascii?Q?EE+EXkq1jvoIC+737Fh6yoew2bvyoLFOKfLZYWf+/BnnkrzG1pdPxCLz0AOs?=
 =?us-ascii?Q?ouuBqHfEUdAWhhewCCn89fC9A5+0cMvH5wzo3Cxk2dmthkyL12q7b8a7Q3QL?=
 =?us-ascii?Q?qI0UbATDsqfibCNbgU4YPPhNnzUXhzDFVvI6JZOlAxDM0zYxq252WoaEnUeA?=
 =?us-ascii?Q?dk/C4WWf1YUuULvJzB6DYBIuvBfoeNVyfwhcqWlvUn00gz8c/x7wAC802owu?=
 =?us-ascii?Q?prVuKOgYESu3gGX3BFDhTs0XCVmyOj5K4PP0FQyKjxpN/P79xCsclHN6dEJM?=
 =?us-ascii?Q?OibUFi47QA9V3phUS7MG0qVPY7g6lrDdAbUXQtKSbKzr4+qsR7MdArA/Yxby?=
 =?us-ascii?Q?yMVEaovnJrgpmymA/QzbZ7zvUlqaNTuJcZUfoT1A/7KlVr0RI5aKfSrN4j7Y?=
 =?us-ascii?Q?9Dywb/Bi8fieOczzztfmb/XsZ5gM18EfF9Y2xi8dR8vJq+f1JRJgZHD5YMGE?=
 =?us-ascii?Q?U9vGfvIzYg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SJ1k/vMONv1I4Ym+4fSlyc4bW+lEzmEDz4d32hbaN6uLvyqdXOU4RtzeDFlBxYj+0HXC0CcM4U22hpiCv1FaNKIHxeu66djabp8FyBBvg4hVj3CuwUa8LNlxd6rlccRJFhIH0rXqpVAuroYlMPCQQjeA4sniZ2zLbLS6V/t8xtDivWT2Yh64TlGwGRd/Z+VmrAFhW/JTLMc9Mi+6aRVNoESb83IdvZN9Ia5V4bQfyDnS82MGluvspCJJfGV8pA99sNAgPs8KZrsHZ7SgO50MrEwIB9x1d1RGZ/G4/8dkHSafYFj5m3rRPItBgV3FbhuptKbiI/ZqqSNprhezpmLryhql/s9ZrT+uIjMBdTLvDx/3a6VFb1sK5xU/HPDw/kEhC5djyfXQmeAhfvJI63iyJmq1g3/El3QLv6ogAzx+qELpPlIjo2Rw8WvEae6YljWGvTyj08As5bP1VeHxqFFD1e4i94ZMETXpgAJHOezV1Kv2yVWXfUbLUv53WyWx0p7g5u+/cN9gFzEkFCxIwXFaASUGZ3uv5E52oxn5EFXGKhmVmM9ZoI/CrN6OvjcKSIdVNg95KsuGGT1+wzXteLOhDDkiNyxpypfcxwpTuxsoIx0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 937ccf3e-9c2c-4509-59de-08de590d3774
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:50:43.4379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHKj/euUNmqwedInkUDyPNVpqh694QuNXorAunjy9AixZy7FwV1k6Zn5ml4NkHgIjZueCmnevepY+XvH0O7G1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-GUID: anSt8YvN5yQChtNQVVKrXBKHQtHAqydE
X-Proofpoint-ORIG-GUID: anSt8YvN5yQChtNQVVKrXBKHQtHAqydE
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=697103e7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=_CFOr3Fws5rWr7mBkQoA:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfXxx2JH2RPgl5f
 HQgq18zoac1Ij+hjenpXOFrtTeD+aORo7ehC5dp7jRcb0jibgZJRFIsS/MOC2yTVM4RW9w7eo3h
 Y8xaMgE4Ig4jZht0isg7uPWMttI8A6kuBQVmfn/YKK75nwMTeUCafl6nUsYIslUWwX0Jgt9ehgA
 pvUT1k8vf5VIFIHqcZSrMyFRg8jnI1JEiqW9ZbueAbVVhlnxh7HDc23S+crcWtjD2e0mbZLsPQV
 TyPEAaJOVQPauIlDAOiyoHAiqT57fJMNeS0BQfbPG4U3OJD0MwwP9d2EMt8KUZ4Ful3cyP4uXOc
 zsKLr/Gxn8979qmmW2vMOPvpfwKSf2byIMsC3hoUJSpUJ6kmyv50LJ4Wr3wjRsNGF89iSOdPxVZ
 9CvV0KOA8KmPYPRsIeG3cQ1GJt5Hsu1OtXEuVhOBQsbhT3b3LNiFJ9kV6dULe9+rshEQ/MhHIfl
 eXqRTiocxv66VD6fmumiguOFJC60naSQOCB4ooD4=
X-Rspamd-Queue-Id: 5FB1C160008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ejsm5eqocse7tg74811s5ba3pp51pp7t
X-HE-Tag: 1769014267-650550
X-HE-Meta: U2FsdGVkX19A48A0lRalydRzSMWbCEHfX8hCMbKNzDj+M4jyrS7B3b2nu/Raz9VrMI1I950FUE4/gHHuZ13v17KEz2UJVz7U4/Kke1M6MeWSrRpUUT6VQkHRuLjqpKPaM59kINh9LxNO3gacDSXilNV1m4Z1WbX6UCCSLVOzafy7OmeXAacSWHDOJZD7Gyy+w2jXTchej25NIXmn6YorbIDcvZFa9/NIILUyJ7T+2W4G6HBirkWpVHHj9naqKJd4a+5dm8zej48hPo6fttixrPdwiypq/qJ7alIpUTAwviwrCLh3IWAl8nkih6kQd83FESYQvo4APKjGVdN2eOOjHCA9qlD7vkaV5H1n6zcfrGuuGeHHDgvdK9E/K7K5auJ75dw9Wv2PDVKVIgaYqe+x7eU/LO2DIb8fhbbCqf/qvDZqDCsIXqXn9vIz8bLeXoC+GaiWosU57mGU7wQX/8As23k4QIigoHSiAJ6+jHUd2NxN8mDPrH8Iuv72qxjpgGXMmqpDet3G9r3dfv2zk8KlZ3+OxyOd5ivvznnGNCWmEYxUPJNloC4XKSE8GBb+py4n4rYJFwMkVkjQIPcsfPB/9GS+ITUzNNeBBt110CD3mXth6rfgB7VpZvUSlmU2sRYEf2KGfj0JDmnGP/qHjZJTzQPNB5IMZDEkFCHZIlBKGl0WGX+tP9vciO6A3tOXP2xgqum4SmTo91dFsiHD2jGpY38Hg92RPkuHEMcUbgtGQ5RzVcRQZDfx2sWmScQSU8YcoaLK/R3VPVUwNk64MmU0d6y3Xf3l1h0b7iyUwMNTLcYyzXne46SBEftWuQtHC7nC/7JmQQpWcsMwi/2fpZ5uXZxZWZEkLFz9TZ89Q15/MxFXuyAicivvPeaIc3egybqV0zpMze1aZoLjLCZZgMXA4GMb8j84QqFUhXIXYz2YA5GjiSpb0aYHAq8pn3w2AYnf9GIgtINqK5OCsDksQsq
 kVoWBhVP
 e8YHEVi/L+bTudijBkeuBHRCxaP1vN6y5rKhPs50auobsMPg3tG7huCV4o1iqvnuqVlZ6Po7DWtZxhxFlriy6qtl2MQavvxU3sfg5hy0ssAe0vKt567yx49sP4+14gUieTObsaPc6aAlL6wV1KYCkg5YPShyHDO5YViIfzOFrIPL+733TSrhwa2r/kj6vZGczkrU1yq7X3xUgJfK7MEraWqLIA6xGlgczlFpAEQsFqbYULWzvtpnBbrLpLGMjtNj1XBXITa+3O+l3XulnFJRX7+4CyZmrw4Bc7USsMcugYcSlwFcxHyn3tN+8mxCaAskxdGqD8+jfGMPDmKSrMQdjQnQ6+kNBTzP+Vbk7WOmLqNWzN9uue9bhN+VuPGrxOBS+cBF88GKEJWTDg7AXjySn0gnNMAc2fFqHevs5tTDpJun2D5blvs8Ivc1hUokIaL2SYyufUlKsD8iEL6a2d+dKW6HatqWoXuIlGdTQnOEvmEUgd2hbPpMwzy5dD9O4cVeM8NXwxKpIJ65dMN6GgIQbt3wIDdg+hENH4gyodvQ1/OKzqBXeVaQHpyCjq+oDhurJjTIEBHX3Ez7F/dT+vnCGOXjAtR/EO2smJH/o49wT9uCqSaYf8vt2ZjIa63bPsAALlmiC4R6XyPbqpNewFCkxTuNuA3K9s4IoPjjW54OFi+3WwASG6Qou5WKrOgpLHcc9l11+JOcOa05oBQY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible that the dup_mmap() call fails on allocating or setting
up a vma after the maple tree of the oldmm is copied.  Today, that
failure point is marked by inserting an XA_ZERO entry over the failure
point so that the exact location does not need to be communicated
through to exit_mmap().

However, a race exists in the tear down process because the dup_mmap()
drops the mmap lock before exit_mmap() can remove the partially set up
vma tree.  This means that other tasks may get to the mm tree and find
the invalid vma pointer (since it's an XA_ZERO entry), even though the
mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.

To remove the race fully, the tree must be cleaned up before dropping
the lock.  This is accomplished by extracting the vma cleanup in
exit_mmap() and changing the required functions to pass through the vma
search limit.  Any other tree modifications would require extra cycles
which should be spent on freeing memory.

This does run the risk of increasing the possibility of finding no vmas
(which is already possible!) in code that isn't careful.

The final four patches are to address the excessive argument lists being
passed between the functions.  Using the struct unmap_desc also allows
some special-case code to be removed in favour of the struct setup
differences.

v2: https://lore.kernel.org/all/20260115182720.1691130-1-Liam.Howlett@oracle.com/
v1: https://lore.kernel.org/all/20250909190945.1030905-1-Liam.Howlett@oracle.com/
RFC: https://lore.kernel.org/linux-mm/20250815191031.3769540-1-Liam.Howlett@oracle.com/

Changes since v2:
- Fixed header issue - Thanks Lorenzo & SeongJae

Liam R. Howlett (11):
  mm: Relocate the page table ceiling and floor definitions
  mm/mmap: Move exit_mmap() trace point
  mm/mmap: Abstract vma clean up from exit_mmap()
  mm/vma: Add limits to unmap_region() for vmas
  mm/memory: Add tree limit to free_pgtables()
  mm/vma: Add page table limit to unmap_region()
  mm: Change dup_mmap() recovery
  mm: Introduce unmap_desc struct to reduce function arguments
  mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
  mm/vma: Use unmap_region() in vms_clear_ptes()
  mm: Use unmap_desc struct for freeing page tables.

 include/linux/mm.h               |  4 --
 include/linux/pgtable.h          | 39 ++++++-------
 mm/internal.h                    |  8 ++-
 mm/memory.c                      | 71 +++++++++++++----------
 mm/mmap.c                        | 97 ++++++++++++++++++++++----------
 mm/vma.c                         | 54 ++++++++++--------
 mm/vma.h                         | 47 +++++++++++++++-
 mm/vma_internal.h                |  1 +
 tools/testing/vma/vma_internal.h | 12 ++--
 9 files changed, 214 insertions(+), 119 deletions(-)

-- 
2.47.3


