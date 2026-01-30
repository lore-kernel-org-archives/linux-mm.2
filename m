Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B997E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E333A6B009E; Fri, 30 Jan 2026 16:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9726B009F; Fri, 30 Jan 2026 16:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16886B00A0; Fri, 30 Jan 2026 16:00:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A869F6B009E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67538C2909
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:54 +0000 (UTC)
X-FDA: 84389849628.02.5F9F47F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id EFC7E4000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ikCa+AT1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X8CJ4YMv;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AShXmuFjnf28GhJL3wIDEdXL+bJ0c/kxT/x9llbPwo=;
	b=oX6TIM4mi1Wou8MxA8MIGBZmqK/GqTwU5p1YHb3iQKI6cOrKO4HAexmjCpMK/5m9zjrboh
	MsC65vc8xSoSsQ1ECNAKUGLqpZIfAOTW5L2dqAcJTmoynNcfRSfV6+uKYzFR8pqd7N28lK
	JNife9Rr+B0wGuJFZPWVqyQ/z5HVQDw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ikCa+AT1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X8CJ4YMv;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806851; a=rsa-sha256;
	cv=pass;
	b=IXJQRNU8rbZIW78zwX6YdwyTvSwXl9R3MvQ5yY64U7vVAiCaEMw0ncSEgAfxg61mCfc065
	tLnPeBm5DFPNZeEDi/VOfAw7fAnV2Vp6NUmOJ3jEJP/HOa7UFpeSk9OU7MUsDu9W7M4gH0
	fqSd6yU5B9xykHylv9imFIQM2WYbV04=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDofD3911263;
	Fri, 30 Jan 2026 21:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8AShXmuFjnf28GhJL3wIDEdXL+bJ0c/kxT/x9llbPwo=; b=
	ikCa+AT1RV1dfLVBqsu3Te2ECchjRJChQMK2xtbRjjtIAKWDz0okyFrkLR4nr0v5
	mbQrIoY4ZF6BPRt69SLMktW0msIQCeyJr6BqdY1k+qU16yeWof+zTAItJKQYe/Lb
	xLC6V07krlrNisrXW+I9cwPaPD4tG6oXwpVxn0j3QcoejqacrCAiVMijSdF1FU3Q
	UBwqPR6EqxUD1hY4YoQy4cEv8TPOTLhurHgRsUBXPJPRVqfRWo6eqv4UXhMzvGCU
	EWljfn07pO/HFz3nIeVJIf2G1qF3Kknmcl5tjT7Q6DbNzijTuioUZVGe/TlTS/Kc
	OGwmzIWnp29o8iWE0LQbeg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bxx09pm65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJLgNY011083;
	Fri, 30 Jan 2026 21:00:41 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe6egd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DKUDGMabv4OezDZxu1M9LwL/rq/0a71VXNc52GvL2WbIecP3Mcd2YgpINUqVGPRM+oPjJousAJ05P/SYXij48+ItiWWQOiZoYsBSYeao7GfgtKV/vZ90IsS2N0738/hNxK/6Nr4H9rCJTMbRj9sALZ5/0RlrVLXUFiWBfjVezf0p6aGAxjLY4rbeMAQPDOjiC4tXuxI5XAPx252YylydXgUNip/ADkFk5ayb35LtDN3AjO8c2sSmxtBB34ZBwMthJw1hSQ+JvN5rYWjrEmtvASHbETe8XutbuQdqFU8QSf3ODE3OmSLntQccYTtbmTI2W6rVUOnh9tODNP0CY9hqFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AShXmuFjnf28GhJL3wIDEdXL+bJ0c/kxT/x9llbPwo=;
 b=qwb+T+19zXxWp1IiFeuKOXWSrxnEkfDz7g2dW//w3Dq74KKpwDv4vn4Dr8D4KO1pgZierwylO2y1sY/lhCV3/mRAYCJdo4YSYQKtQ/ndDzGawfoPbBJyWdjWjSXKjgowpzPzSPXSnEbALgoRb1f6p1XpwsTE+vNdzg/bkmDxUU+RGGH0WdwoNur2DhlZtYlnfHMUaTgGmHTjz76CblOnGlv30bkuN9mom9fUUpBlAq3mJi90GW/O6CY/wqAf+gHvp0ZbqismuWwwpkyNLUlsy5Dy4Ko3nty8f+wbKX80y+0183fAkcZ4WgmnJWBiZUPIfAe8aIr7/HuA0GYQGKxVTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AShXmuFjnf28GhJL3wIDEdXL+bJ0c/kxT/x9llbPwo=;
 b=X8CJ4YMvfrbPG0TGK3KJmhHHUjH1InB8qLrNt2uTNh35kRTjaPvIdbP8l0gg9JxuFk4o31/PNTWEYnz3KVKolc3q5HuDuUUuCgv/h2qS4kNZz4ezPam8GDqgH+iy19IBALQhpL/OuYYtDr9JI4FHJ/TTVZCtVJpRWO8s+0ETPXI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA4PR10MB8541.namprd10.prod.outlook.com (2603:10b6:208:56b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Fri, 30 Jan
 2026 21:00:37 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:36 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 18/30] maple_tree: inline mas_wr_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:23 -0500
Message-ID: <20260130205935.2559335-19-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0404.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA4PR10MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: 63b04c00-74f7-4e5a-1956-08de60429ddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?copihA6OhRRx6FfztvO/J9eObpIaBxXqPiNWF89VWTZlpgNv+Xv+rPiaH15+?=
 =?us-ascii?Q?cd/eLOIQuuAaqcZL8iSz4RZa4/omBm7sB/TSbjf08ALdw7PfSaF7HLcbSM++?=
 =?us-ascii?Q?EMEV7kzD+/DSINZ/v6brf0hqsm9u6vJpCLvSwZ/XsqanK846VoVIr28ywQGD?=
 =?us-ascii?Q?CK2UvV+FqMpXR5MZFrz1o3KkAHiDdJzZnZT1c2ejtgYKF5IxZrO+KJdMvtRn?=
 =?us-ascii?Q?f+EAr17VlIzccEwVgmMXDUGZZezjSDaPm32xin4TkzfCuhh9H+UaJWEzrw9C?=
 =?us-ascii?Q?W4cd8KVgt17CyUosLaaMsdHqXi3Yx6yks+XrNkumpKVrkGVbarX6xFdnNDDF?=
 =?us-ascii?Q?yBaaDQQKcA/aOxgKCxyXcL4v66vLyi/28JaGAWHrkmm4DD8E8gH/p5TIuR8c?=
 =?us-ascii?Q?OT5S2Z+xMwAEMWH81d+pb/18TaEsGS8o40EdQMPNcDp4Il2Tbwkhzhuzd+yM?=
 =?us-ascii?Q?rC4jo6RF6VakUc2pN7kIQQMRoBc7X4CTzmkfQvKG+wgtkxb/kQEopmKYaQEd?=
 =?us-ascii?Q?gETm6g+ic1cswQeBToeo9RPbwf3W2Ly7He7pthM7m79iYqaMGp9Oq6lTEHt1?=
 =?us-ascii?Q?I3R1TiwzOdHqUfq34yd6eWOPyBYSCGBUJA2Qnct9tQsihsKaWLBMA+SyLr/B?=
 =?us-ascii?Q?cAJD5Xp5XwBb1ee2QIYifHdqZx18QLO2tFc1uJiGrcECJlgDotEemETDWSOk?=
 =?us-ascii?Q?kY/pfqsEohEO6SGbIMDJX7Rs94U9AL1OOZ142WB8iGG4SpfQSIO7gWfSPM8i?=
 =?us-ascii?Q?r3GnctB2Q9J2ljUCt7Ai8zN/FCCY4k+s7+WHfHzqqA8pxJK3fvJ5rG0kZBbQ?=
 =?us-ascii?Q?JD0wcNiWiLhAASh/qouI8Ekvg0LPr4VUz1ljNU2aokfdGOXRCsgbCqaQDQWG?=
 =?us-ascii?Q?rJOO3xPjJ4fXYNUCnI+vIpf2lchbCca149o2rsR/t92LUlNw0jNF9uMpjXBx?=
 =?us-ascii?Q?5NcPwXSFP/v4tjuQjtVfBf3oyxIhmt31yRsOuebkHS4oqjWyN6pkkFCih5+p?=
 =?us-ascii?Q?hLEk8u9HjJObjeq1LP1vCTybYE6fGNc/iLMi6dZt0d6b+rNSWuVUWcoeZ/aA?=
 =?us-ascii?Q?lLHY5rOqseVryISY2cNFKO1n+F1gwY2rn714ixne0/GP6mcSmwa27z5E2Mi8?=
 =?us-ascii?Q?eegaix5e911jhB9sVM7Ey3120QpUlknOrCAiP9H5QikF+QrWiIBukXCGYLJS?=
 =?us-ascii?Q?ud69KwBZNxwGxFAs2LXg/U7i83NmHQ9dIWfUecbiWGuT3a5yHWEE3xhlXuC7?=
 =?us-ascii?Q?PnZdj2ifZWil9L9GFiX8Ae/sqF9TuqcOqZEH2PCQGbhkP3/SSRbIsXKFWo0X?=
 =?us-ascii?Q?W7C2rMmxNWTyUT2LBpFuNmnFPirgObsrYs6v4ecDDdRbq+CgCxW0M6cODhYm?=
 =?us-ascii?Q?BdP9KM3qRjhx3dz+cckXks300NLaRfM89qONpIFheuFi0JVVMCANXyNoKXU8?=
 =?us-ascii?Q?tfiEF7sNBUdaB5CStGMnKJkCt3HJKp654aYK7CtoLG1/G1Ri4AjWGL3q4ZIw?=
 =?us-ascii?Q?Oyzn6WLrRjY5Vjz+DZHHNPsVl3J965ovLicVAOI/qQJR5MxuS4MSh3qnQZmw?=
 =?us-ascii?Q?Hx8UoYoVxduzVGbKVgw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tQ3Y8yxgPKwtOvo7CMkdYsCyQEgsVJwlMkrU10NOVJUoC2Dwf90dImYyxfji?=
 =?us-ascii?Q?kz6+fxAlpOb2itKYVIDM3P4VqSPTAD6xB/DOeTzPsiCcMKEaOutkC9qcmT24?=
 =?us-ascii?Q?JXW//8oSrpK8CwwoTAro7N1dR6JzegFSSpVu8AgdSLB0Ho1egE8zbGPnGkm3?=
 =?us-ascii?Q?H3lf9GhUNd5HJ+b27a7qAjgnXR5ClEaQcGe/78Hhf0+Azepd0rTWH4GnR5Yg?=
 =?us-ascii?Q?atG+GY3laWIN4bHtu/K5WL5TfrA88aTnaZXyWv2b6GkTa4+Zn5mgPG9VqkIG?=
 =?us-ascii?Q?8Gg5ex34Een8kZGuCgHrwGwBIHSPco1r3vj7/8H9dl0j3tHJUnajndEqMmbh?=
 =?us-ascii?Q?IhSZgx/Uqmfd8nn/MvsNi7rZoV3VCVsDoJvAVg8q2s9N/mRtsnrtxVB9aprz?=
 =?us-ascii?Q?7b03vvb6RUIpwzx5yXnsFm0LLsNPAS7IPD6uVn4D2S56S0tMhvTF2/xjuWFf?=
 =?us-ascii?Q?EyjiYqB+1s56XWBmGSR1nvg3tVTy4/FjtrEMUNo1X6QXF1XJMyIQbSvCajVF?=
 =?us-ascii?Q?iS/y4sqMOAfJtqO0yCWrDlBB72XXpnFMMKvP4+0ADHDlMrVy6EMnS2JWKFq7?=
 =?us-ascii?Q?gFDf4toABe5cx7adoUe8GUyCWcKRMXAiKb1cRodsz+5Zl1Gh1AzxZMTgmXTD?=
 =?us-ascii?Q?er4JRLbGWWj+gbW/iBRcCPxJWC5gm0fAjOOt/B3YwDv1nwdRqwKu0MPhdEOX?=
 =?us-ascii?Q?bvf7XJlYr4bqPX4x7Fvg80Dht2GbgsTwrCCdIOHOaRs/aUipP4misKmTNDGy?=
 =?us-ascii?Q?QBu82nbENl/iZ3xjbLbladoZANVdyNjNDoW8dfLZ/Z3XV1wKO8LTbukSF4SP?=
 =?us-ascii?Q?N/gD61ONqMBL2eFriXHdJHPHqZxsyZoRermGz6+Qt/L/bhh2TyKob5WmNBkj?=
 =?us-ascii?Q?en2CONAcwwJduc2ceqyWxImwdFYB/OxP5YCPV41eTxvZ+EmnyMyLXjtPIX+x?=
 =?us-ascii?Q?HEKRugNXGRlKFSZ8CAQRp+cdkm4eqp8T806qHLf5VRPxsP4ALKFR8wUo4QN5?=
 =?us-ascii?Q?fkWj5BN3wJm0Y5buNuWZbhAXIg2sHyg/zGR8tn4LJ+MPziUQBds90YOma+6X?=
 =?us-ascii?Q?6/Q7fd8+xMPhu65C3kVsqmWnN2Td8vdpHRHcu8pV0MyaBs7J/AQBAKINlmmY?=
 =?us-ascii?Q?CQpijQgyvf+Ghc2x+qAvUpCBkca+iE1ieLsllv7zwH9PBGZU4dY1/R4qiDHD?=
 =?us-ascii?Q?SVhtraOvHUwFFFY22KTcASMmUm5pVgDyTqJcuchJQGlU3CsSF5yYMJsG0gy0?=
 =?us-ascii?Q?iOK7E2EUlASFv5LEWdMUgY+uljLK6fRa+eM730xxYuzq2Ug0aHZkgGZRtiys?=
 =?us-ascii?Q?EiR7tbhsGrY76jV2UTPZiazbydo+PulNPlfFLdomMEmruC/j+oINojU6j0Oq?=
 =?us-ascii?Q?8ghl1S1WL9YqYDpv5DHLaFyOqan+tj4lrezgTv0u/iD1DWLqvuJzeS944vvN?=
 =?us-ascii?Q?4lFdOhqtd0c74u6oYSjjYwEtr9l18mafS62tgqNmjWCFVdLKOGve+WUgytQa?=
 =?us-ascii?Q?eG3rVGNL6vr5oos8/JYI2pGi9UlzJWm8jMDKrnEuaTp6Dw5g+4G+3gcM8QrO?=
 =?us-ascii?Q?Prix2swUQmBM5nVPnfY4FPHD3GL7Eju7WSj90Y7qO4oPIbTQyycgHwFItQC5?=
 =?us-ascii?Q?LKMJO5njXYLk44OOj+xauowSf4R9uxYq6/6zmSTXPIYQ0J1vzI5USNry7Tpo?=
 =?us-ascii?Q?lJqVbhy4wHMDQm0/GOrYlN2t7SOEY+Wp9gJjdXUOp9OqWND43lS5V4TniAhe?=
 =?us-ascii?Q?24+ngnCDUg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j/Gf8M0uQrmdm3ppP7j+xaMtH+kyy6afdGk3VzayvlsDeNigKM0s7AH1ngjfNOZeVnFWyoyQPKy4zg7VsNbYKRj/22XLwhcm+CgvdNoneMKoQi8ily9DwZPQN76VxKVR/78NhrCVUGFh9XmZqNFIjUnvELMNlN1eJx0CTFgR6Q2MMwsFEcjF/+wdCvtRNSJFXwE6rLxlrBdnTodrVa/jjHL25rzPAoJyzu11Kuwj0ziox9H45WAlWtmHFRP5kzWJ7v+pipugNUt1UMzf+iaj0UkCqTF7FIb4U0Nk/yw8DlCbKpg63j1N6bbH3zo+UUFLMgv447YTUlO1XLs1gTocAi0UxG9u5O4Lfg7Vhqk4ePB1yvtrsagQhFJ/A3IzaAGSXoGI4MxSOkE/yK4EBnKByclL5NMEcMI9Mq2HZv643tdi/X15aIqqYVHRup8Y0qTZ6qvnq9XV8nmfESpiM+Ds0DbhUyt/AdPJsiWNjOApTYB9L1D7uxulN8KDGRPqaUpa7kIgh6ZeB0uaFT9uoeJWFzqWVlUDkFhOFQEb7AkZUG0SWDVixgiz9KnyNUkf68AitGHaIN6mFFUO6zY8Tl385U75SBECgNBLiw+LLsh6WD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b04c00-74f7-4e5a-1956-08de60429ddd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:36.6604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLd11R3A+jN8LBtmlur90hOZzZvSKAYAg3JVLKbdH+o1LLBnFWvosJDBcViD2C5xY5MVQctpYovEPPFKtF89tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8541
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-ORIG-GUID: qdbLrYkchAw8nid748bj43luGGSsOem-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX/zBcltqrAxcM
 F/9pOfKcy2vZay6jMNO/sSQN4LILHNJYmJQ6Jhn2icXeKPmR3R6CePwv/2P1VsIKLS8+PQSvjsF
 Cka/ZcV7OjC6sMFbSkzcR20Z3t/1lz87XQ3Pg8RV5gnVvV+3WSayBuMkabBOSehuTSTsrcfc73n
 XTCPzYmiGPYz007oQ5MUhq3GFG1wnP1gb/1kDCDO81b6Q1Wm+T/RqitOcLe+qIm+ZC8828Y/5h9
 cr7JwGVI2KYtg3ecHkj+JsjsqR9TEmDbyybyRc1wAGsdYMOnZc6Dyma9myyHEFuoV80lt23lHoM
 dPvyHFUKEDW08YUOidQylKobXAmJhDZJO0xGTADEP8WsBPGXMnaMbT9VEGIMn5hzlGV4u7U2W2G
 d9Y2aiF0cqTgPonYmNpNonL17xkSxpKs3L6tAiIAxaHt2ujrUd6dO7zkMeznXZL+ZuWmCO2dcr3
 JVrgwvMBQIZhPBm4vQw==
X-Authority-Analysis: v=2.4 cv=Qe5rf8bv c=1 sm=1 tr=0 ts=697d1bfa cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=rS4Dkz7vSkpNL7l-vQcA:9
X-Proofpoint-GUID: qdbLrYkchAw8nid748bj43luGGSsOem-
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EFC7E4000D
X-Stat-Signature: gsfk87kuz6wrjq1gedxgdootzkra6aih
X-Rspam-User: 
X-HE-Tag: 1769806850-658988
X-HE-Meta: U2FsdGVkX1+rWn07jT1ccMCYa0tQHXio12DBkddeNQS/QI/+c9d527UZMK8s0BKPueM2S5dEyQt5yfO9PvsJkUFmxHvtk6Fquc1hx87193WIWJBpva2GWEEPE6Yj9xgajoC5HYS0JSGLKV9OzqPUc4iJKhJJZhOqKKyVWR9gYLw4wcbSVc1TYYQhnd6JS8qXtphvURN+ZQeZ/ySlGF2meDMRwW63v709kJ7neX8mcMvIoV6Vc1eH4V14Kbd0Odlz4Nen6MDciXGcZV70i1AfEw5VKfshxknh7XPp4aS3QIweZOD7oaUXOPFK/lS85dEujke/yT47neCKea5qcNQ5eC9X8Y1lMlgP41UfXlLJdpf4nxLy/jtLJYLkH5O3owVWDS8btPjCTKQ+9amF3571p1txOpxu4NaX6E0cP1f+ZiCXdpCctmk0yEQQNDoqII6JwSVBzCzqkB+BIAN0Dxsn3q+qlHOJYLeRELUEKw9pP9wcGJqycVSIJ+gEkS4BDbQJtEK1Qd1pkwzzoW+hE47bBwYwBbGCNunhIYSzzmfIPhhCbdA9MOE6NfJKXx9tu8NuYtiRhzUuhVV0CAt14PLLuoB/dZttozXmLB2/o3J1NynahCR8ZhFTqiUikncL9mZJ2STeLiUgCvwtuxEz/0SlGFT9aLWrwqwTUK3l5pTYV7cgNebJSUdp9m7pzt/+8pERqzcC7Ge49+tLdfuWHtFOqX4+d7hpx0lvA0Far8SmKkA9FBFrZl7jNb7LAbnBT1ANS/C1WG62OCMVVVxw3+piRWN9Vt4dhZezrUwRlZhfywogjuQETi2TZp991RH51McixhFz5PkXxpLvZ7wfGyemyrQy4zEDG+539aC3MCWGEztAcrOox3acD4VkBIAjOVLYW92GjWs3MNjl7JSotNoJM8QaCzfoKcT0YKMPU++qAjsU4A2JqRBF9P4hzG13Xm1IRjbj41E3+3uP2hd5o4E
 R0ZBKXOQ
 nGdCC7ru/xGxawr7dIBM51ZckfPVDfAl0Oocq3KPe5wF042qGaeSqq5iRSrCErjiIkzSe/AqWkaKScEQz0YnN3U8Ygfa70qM66dQWbuO73ZzAw7lUXfyKRj8TrLce4aYO3pAuprjolF/f7e7OpwLrBQ2y00rJz+JMVw3qZBWbncxzyy/c89q945+E6mJbfSD6yX8ecksY72vTwJ2Tcdaip1QIczlECcl7vnFmboLBRFhmi1Of0Mrl5dt+0DmDwh5M1laUpZt9B1p6HJkAUcB8OPqQ6uUOJIZcxD8dN3nLfVvp2y7sXKQbezAWIvsIY+sz7UHFkf57fHomG/y2rRLWZWIxyZDdkVFPWLiMfvXrPEAvmVG15MAuQd5hAvem3FiSLAJXcrNn0Cp3fcLg5hHNYXoI23NDzUFQ3SQA0T2XB4Np99SWtHckHXC6q9YW/e3wsFyEXW71g6TgWJq3lfMR+xZL7288E9cpEv/Fqte61p1rACe+HbTMWos8Yrx9afiU0thQyuL5xvAvYe5PDyydDWKXSTtWtGPd37mXTUxGNN6gbPy+4luNi5Jd34xGopJn8xPIC7IULd/6/2YKRmOfgKgz/ZpWqvINbF2BFtoKJms4Uwm3czxIoOFf4wXj81prkbw7fW9fEfHACtBoTcmHf4cuIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the spanning rebalance is small, fully inline it in
mas_wr_spanning_store().

No functional change.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e0929bf0cfa1a..a10f71620e732 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3407,28 +3407,6 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
-static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
-{
-
-	struct maple_enode *old_enode;
-	struct maple_copy cp;
-	struct ma_state sib;
-
-	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	do {
-		spanning_data(&cp, l_wr_mas, r_wr_mas, &sib);
-		multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
-		dst_setup(&cp, mas, l_wr_mas->type);
-		cp_data_write(&cp, mas);
-	} while (spanning_ascend(&cp, mas, l_wr_mas, r_wr_mas, &sib));
-
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
-}
-
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -4085,7 +4063,10 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
+	struct maple_enode *old_enode;
+	struct maple_copy cp;
 	struct ma_state *mas;
+	struct ma_state sib;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(r_mas, NULL, 0, 0);
@@ -4142,7 +4123,18 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	mas_wr_spanning_rebalance(mas, wr_mas, &r_wr_mas);
+	cp_leaf_init(&cp, mas, wr_mas, &r_wr_mas);
+	do {
+		spanning_data(&cp, wr_mas, &r_wr_mas, &sib);
+		multi_src_setup(&cp, wr_mas, &r_wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
-- 
2.47.3


