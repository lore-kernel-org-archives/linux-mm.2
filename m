Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB25DD3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8CC6B0005; Mon,  8 Dec 2025 04:30:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2899C6B0007; Mon,  8 Dec 2025 04:30:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AD46B0008; Mon,  8 Dec 2025 04:30:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 017AA6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:30:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B64055C065
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:30:06 +0000 (UTC)
X-FDA: 84195782412.20.AB87E08
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4FAF840002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:30:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GpSx72PY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZHoChVAN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765186203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1i2aLMtrDhiRJ0QMIEhZi8pxwPrxnOpxubwAjxXW0Ws=;
	b=Zo+muNvwJfL+xETm3z1w3b90cE6/h3X7EY0HljIiCBy9O3IsMVDfzM/YmrhXC/RWHxEljZ
	+h+h2Ib/q/bU23fAJx8N3BXurIgvCkvXnHEa6NlaBm2N21O30Jut7/sSYRwNo5T78zaUUo
	wj6dX3t/np4fsaIDuWnqFV3gB0pZtYw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765186203; a=rsa-sha256;
	cv=pass;
	b=RlKrDzZ4Hg9dBwUSdxB6PtAciujZR3S530rF+OHzFRaHPtLVUN9W2Ccmb2mzsTuKS8MGNj
	z8jXCNfcqd3qZzlKGyQoorYD9qXafSVYs4EnhXyfwhDHY+5Jhgc+yWTgae8KEskTeWQ+wI
	x5OeuRdM2xxqd62E09qV74jXWTCwX7I=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GpSx72PY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZHoChVAN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B88uJZk2097349;
	Mon, 8 Dec 2025 09:30:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1i2aLMtrDhiRJ0QMIE
	hZi8pxwPrxnOpxubwAjxXW0Ws=; b=GpSx72PYdI+haNlv7tzd5NBgapspX05p/g
	MQl1Aeptrja3pvFGs27Vgkd2igFFiOBFec7ay1NjF4eVHphD2LkkNMNqTIyD1ev0
	Vyfglbsqi4hLEBL7/g6vQ66Wlu4is0FlQfauJepT+Z7YTM3kKVtUrY/6y3e+1MRJ
	KUJeOsUXUpggEBsf201gN5zGqrfo1zZeYQcgPYVwhdKScbn13iMpj0yqbtlVPAqT
	pUebEpj0A6cwfT3kBjrFsXg2D/5/pFIJHfhR8YXfOf87X1HQW8DB24UGe85XV/g3
	ivVPefk3A2wTdoCh0mvXfqdPIfgE+5kDKUIs6oYOB1ZEq5QxamTw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4awsde86qa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 09:30:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B894Tw7040645;
	Mon, 8 Dec 2025 09:30:00 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013021.outbound.protection.outlook.com [40.107.201.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxb9nde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 09:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0w+BKzICMeRuns+mSVUHe72906wXxorsODr0fkOLSyANliOQBuMcMkxmC8X4WS0ZfUoBzn4WI/27xFAl4a9GQVmF3YlrNUeUfAgNz/k+xUTj704kR9WKrIUkv38bDIRQoV92IQfvCxdDNxkIcuTSjyiE8Hp0qNAi6rTaAKgMfIw3qjoU+Dx1YwtqI/BvTY++rCHlWw2vKBYXQbYSvlw2Ypk8g47mcTJb+Q93TH7bhak6LLEf94Z2jDvoTtMEl5cYz1rmkUZavWqX22wic6bcZ+mn+Kz2JsTFzmaPIsFbpo25xbBWdsaIl7W2svsNHe/6nJ3daQA53XjaHZG4B8V4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i2aLMtrDhiRJ0QMIEhZi8pxwPrxnOpxubwAjxXW0Ws=;
 b=m/nL2FxQSSx3vkI2Tr+YCI/zlwm8VVLI3QugP0zAuRMS1LxD39UmQ/Upp3Lrw1M2XQoeqNCjaNC4UwUL79YlpwINW4nG1+ZqLiPr0DyntwSJKrlKHfnGV1bZBjrjWtU9d+F5YIu+lQR9DhxO4f5OoW0fEaVkfzWsJqDNa2NyBXAhgFDf97UE6G/85PBS9ID71G69SGcGu+lDMrdCmNjMAKM/s/lHrykPfUt5xInFDseenEQf7VjLXkzKnPqPSR3jUQ8WtY2lXPIp5UN4xEdbvxpuNv5kD6y9kksegSbBkA7syAE0kWJtXq2v6S4j8CkTv3bQOumkv2u8aPIa5FZxuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i2aLMtrDhiRJ0QMIEhZi8pxwPrxnOpxubwAjxXW0Ws=;
 b=ZHoChVANV4dHaJCipy1w7WOud6NSO8NLrK6A4rldz6l0/7w8NoeVA4QXY/PUL5dZZFtX9dOg0AzKoejVqaV4InFM+urpNLb9O/3wyagMyBw7tavyZnO0r5W/3eyAAjMC1pejyZu6Q/8C1GkoHPD3fUz4BzKxyR7uCtKyF1+TH7I=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7844.namprd10.prod.outlook.com (2603:10b6:408:1ae::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 09:29:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 09:29:57 +0000
Date: Mon, 8 Dec 2025 18:29:49 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz
Subject: Re: [PATCH] tools/mm/slabinfo: Fix trace disabling logic
Message-ID: <aTaajTO9QY4eSLR1@hyeyoo>
References: <20251208084255.2689901-1-kaushlendra.kumar@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208084255.2689901-1-kaushlendra.kumar@intel.com>
X-ClientProxiedBy: SL2P216CA0148.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: d7dcef10-8831-4ea1-cff6-08de363c5a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?401Bca0+Tgfeml19rXJPv/8NkE8AHX7+AH4iesqCq9gWkiP+CAPvUEvXb6Z1?=
 =?us-ascii?Q?6L/ku0I3+HjT7/84MIhAUt5Zly6hCSH29fcMr88VMS1PJkRppjI+Oz2NMGQp?=
 =?us-ascii?Q?NR5ScV1N8/i+1UXXL3U//UWv7z6Q/zGp3jxGUsy040AW65LnN3YRo6Y98CqP?=
 =?us-ascii?Q?JXa9iC/7gP/tTnNjGnM1GQB4lWOWBf97eWkKt76gef1dpKPT2dVebkOXTCl3?=
 =?us-ascii?Q?zzoq/9oBj16OZIUwqgXxc8idSJhmEPdqjud07deV0VlLo0etJkbjm+lqzdGK?=
 =?us-ascii?Q?0TExc5XF0rzbmLdQ4KTHomFS1LrppvKaxUm6c+cwr9sfHDPDTLAUC/mpHQWe?=
 =?us-ascii?Q?ic/PCm6l2a2TuJx+s8eAXa9uaAfnuw1VB1O1UyoH7SjZNdHPW60bzGaEK5zI?=
 =?us-ascii?Q?EevgF85ZomzBSo6cI/6bKIZSh+fXwF9ybd2sq3sak53N/WK82UHDOYWoDgzs?=
 =?us-ascii?Q?i40QM27S2vW2yqlyTheFIjBw+PSMorBF8PpWwdIRJH50buaQfRjVygNsBsdN?=
 =?us-ascii?Q?ku7pRGlGZrL4shfA1jZlDDXKtLZqIw0xdmYywmM1MdORYx3rzZvrQ1trO6lp?=
 =?us-ascii?Q?stVfIeouwh27C7zdQTEAkkPNhQ07/oaICgN0/sBSYYRloYA7th/h7y3xB93F?=
 =?us-ascii?Q?x3A1YmtT5jf3APzLYYu54YUGMLCR+T50Q2tiuvg2BWW5Q2wYqFMZ+VPnFDto?=
 =?us-ascii?Q?uRI6ev29Uu19eH6opSKpb8nWRDLzPULpeblZu8hEOZyHwsN0VtKCymb6cfeR?=
 =?us-ascii?Q?HmdOJujiGsIDJkYku1tZOg4m5a/Gfn9JAcM13+nzWhplqWAbrHgobxx+mP9o?=
 =?us-ascii?Q?Sggwv6ZDpgu0mCMl0wT8sArsVg7Qcgr7gBjcLGWzoiLs4fHLUx/qI05fMEuW?=
 =?us-ascii?Q?DgB+g1Xoo93bwwIUlCJRcZBsrsg/PbqBVqMj43kiXW/ws5t9samSeDcW9cWD?=
 =?us-ascii?Q?pwnlcpj704RbRSPkJAFv2rYC6vtek9+FEWZErOkEqcSoDJyzKunxxlIYH1aO?=
 =?us-ascii?Q?19iiEvCXzMfeGO+ekTEn7445QBvXMNvaGkU1Hriz/V5MXnUE7gZB86fNIyWs?=
 =?us-ascii?Q?erfcgX1vD5H3kWoHkdVObHHDzXxfens+X0lKWMpVNvh9P5771UpYiEC51oTv?=
 =?us-ascii?Q?Hawr57LRbbAaXf7GPYDWHAakw7Dfp82rO8Od8Fkh2QLTIZs6IsK/G5CejQeP?=
 =?us-ascii?Q?e8huzoLKJyZUaU2LlpS+p1WO8ZQCOt9qVIRev4UlKi2unjhpJQhGOtf9h/+P?=
 =?us-ascii?Q?4b9TP3ze2MWnXVj9cYigDM26Bx0/6kY/kEtSb/ociAg6GBWY7zocqIOzIp3q?=
 =?us-ascii?Q?Wi+g7ANHWto9cD8auUg+d4dFhASyr1RTy1wfJMPVfS9rTKSJv60RLTbg+nO1?=
 =?us-ascii?Q?9+b7qU9eDhQwpfToEXYZxEiE/x68v48W1DFlz2HtSyC6taSekc4WXXT4qIhc?=
 =?us-ascii?Q?/u3lvf/81ZprT77q1gFwnaccdPPojgPr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hx96h3NdIwLxsDjGCqdVpLYoIOcjMjrYZnBm+MyXSLYO4BulihEtyQl5vpP4?=
 =?us-ascii?Q?EXCZmqL9g0VQsNUlMD9TToS3GYTbWoM91dlNgctQh0OwvaIsPyMuTWwnPJp7?=
 =?us-ascii?Q?agQn7R4CWe8ZV0+j6D+wORS+8Z/ynSiZ1GujnxNlEMaGjw/K6AXnQjkOMLdw?=
 =?us-ascii?Q?XCgJHFqpiuTKoL6QxkE+pZMIyvZmjtkkORr3v/TsFzOygWTJW0uKHj4lzRjP?=
 =?us-ascii?Q?tMDuBnZ3iUVVeOhTi65jMElweDUd4jRtTcuzdoD0+uaCTIMbRyTRiPCTnSy3?=
 =?us-ascii?Q?INoESivAw5glUIN0xmGXtSAKss6MY4vGmEyk11P8EPSLZboAyGw952xGms5L?=
 =?us-ascii?Q?c31qCBOr9ZlpGPqv+vQv/6FvFhEUmjRKpr/Z4gfuWPaHBJwKt5QAlSZafjro?=
 =?us-ascii?Q?W5w2fdSUqywSAEB/Yg3hb9bqJQ7V0AIPLkfntmbx2kc6w2ZajEleEzwTRSmk?=
 =?us-ascii?Q?840nUAvUh5GEjtykn6T51JX/optxoEiq2xaHtL3q47FrbRlvYQy/NLLiaBZI?=
 =?us-ascii?Q?6I3H1397HM68U58TA0wrgN3A3C2BCwpF32WV/g6VfcB/sApmrYyQfn95wmlm?=
 =?us-ascii?Q?3i+xjMtzIEvbRX1yQ2e/9JWVBrklyguAz/jcrFD9F2fuCpJzX2z5UNbEnAky?=
 =?us-ascii?Q?6skbGDEdBsI2zm99++tbDm1oy+AIX43k6s3j0ZNc3lvDixH779RG2o5p0pi0?=
 =?us-ascii?Q?4BdFDuQrus4FIOk8RppzjJit5xBOSi7JHvo+fuIksqo0flFxk+4uedRnrZ07?=
 =?us-ascii?Q?GdEx0RAQv5GUjfKAO5pQQbJ3wl+AIkfvSroybXdIqAs+MSlwVZeZWGVyFUW3?=
 =?us-ascii?Q?z/BfTpuK75rHmgSm2uU+Cv7Mt+Pt1tvzunmse5pXBtbRZ5itdrA8/QLsazVA?=
 =?us-ascii?Q?dNqr0V1/cmdOI9m1IO+olUjqFS37Rpdw90ChmZfmbL+MdLCYBhG3iMZ4Ro54?=
 =?us-ascii?Q?N+FDo04PBxShyMzFaymVtlLo/926CpgkQmobCd8K1kGqjU+5wbsqTqkAlqb4?=
 =?us-ascii?Q?PQ+AoKcrUXNUoe4t892AYi1KqGQzldQsVnw9YCVyRPu1sf3pp8daNVz6TWYy?=
 =?us-ascii?Q?QbxVcsfVtzzrYYpqvOzsD77vfrZIlpTQ0gxvBVBG/KhTySKJWYrbPOtHQCxL?=
 =?us-ascii?Q?zkD18bHSVu5QbuAkoYUXS6/S5JrolL3MYcKtq/miT2/A7XC/u6J4K5AzGctJ?=
 =?us-ascii?Q?/ADD+aqmC3Uz11Yp4iGzVgpH1uletc0IOfK9U6QXN4DjFTvjUhZWrggDMa3Y?=
 =?us-ascii?Q?/w/FyGBbl4VyJo/DfAFJfA0G8ixI0Kkr4QTkQCJZvSVBJMNGBPYq/PBYTlXy?=
 =?us-ascii?Q?1o0CO4kb8py3c/Q/+RGhI3Q67v25PiKkVReQ7QsgOvVkDi/Bd9B6Wnlo36dH?=
 =?us-ascii?Q?5Gy9aJDtg9y/gbibTgOuV5kcJkKP1OSOOUBbSO15GkXRLWYdtEN42oRL9aiA?=
 =?us-ascii?Q?EYTIRPnUk9JzgpGF/fEZ8/iS3ug09I3STw5yUrbZelefNVNxOXZmLfgX60EC?=
 =?us-ascii?Q?OyU1JaqmimEbnd9pNRrkGeJgl1skToBU4ZrPeQFOjN/m1FNKTipXz7a9iLas?=
 =?us-ascii?Q?DLMiYDLEzUvPspUCi0bPVH7tqvxa4WKFzOeeT4Jg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t/Dwo3mOSBY54UFn5geZ/myWFZ5D4bucDmuLvSX5iyWvZFe+571VAYAiCrv3DfKYLejn08RVTSlK+O0OM2jgWpWVcKGfWiySjEdHZGOABzb39d1gXjs7KAD1O/4E2RLLSjS4Zewo3boMR2hGlwa8MbdwMM8IMDz/xTldIUO+pkADbVHMRMSbw95201PcA/Ph1JHAZ9FmBBoogMQ3RTKAE0DjwJXVMkGXQiOF4ni5H8/PnnLOVgOFavEa1vIrT5hlEelzNiCBhjuPvRliEUkAGTxOWnbsQvPTLcB/210IIZ/tTVPNpeWpq3IZEGKmiVk/jIJC/mbXCsk43t7UvtF8bbmKNMI3bAgYkUK602LJ+ejCfhqTkL5UAJKqHp4/w2jF6w5duCLtpUW8PTM7maKjlD/Jlz7/9o/qtIKSwRvRVuwnUT+fILG+G3Wks9zp/c/u5PNjwSf+ycNrlgZc6nnHONMYDin1WNxLHFnsaGgdlX/SQo8J+5bsFqDY5QT7akPvUmxp+MS6CSXFUviyNaLDMDX5kElWvc9+HOd3IflpjEwhNa5izDYogt0USuhQ/7I0WAytF5dncWxXs1SZ4cm0H7E+Pw5spv5kmQjBaDRXaoE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7dcef10-8831-4ea1-cff6-08de363c5a28
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 09:29:57.5618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3I0dnO4PbSZHNKeSEY09H4uQ8wlsNfUwxg9oyF04PTeFtDE/4khwy7j97UG/HJfFSskov72KZ8cuslT6HPUqrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7844
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512080079
X-Proofpoint-GUID: xeL29qWn0x8a-ge7aVRV28QfS2VXHjFK
X-Proofpoint-ORIG-GUID: xeL29qWn0x8a-ge7aVRV28QfS2VXHjFK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDA3OSBTYWx0ZWRfXxaYeX2aLQA7i
 f2tvtY61LC6D2JNE6lUOGAEoqomakvbtHFvH6Ve2n/Uf3rncKsf9mXtS2sR2uW5BP9jeonSyCaz
 WycgKe5959f3uxLMSPD2iEK6PFWaE7HXUiqq3HhirRz3ulnNQby1tknPF+qzFhPatiIzRcEgCgv
 AgMduerLh4Zprl6iool0TbYIi4iAu74KL7WkLTMmd+IhY3OOsMd5+FqVS3jMenSHgvVhCrWqcrg
 ziAfcNnsUNnU3czujw64HHf7CCKR8olI+D9fWnO+ydl1noUD5u7Zz4Bxk7bg8x6TBySDgbt9IOl
 vuxd4+XWQxt+2qaFWNRm7P82OeY5Z1QjhJMIcXyW+hFrbHP3oGCTpuDdejrRTQH5rJDkSe1uE/g
 gs4+DXQhz630PlJ0WF6Hzarbuxb299Vv5CzrH17zoHpYTE+XbMM=
X-Authority-Analysis: v=2.4 cv=de+NHHXe c=1 sm=1 tr=0 ts=69369a99 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QyXUC8HyAAAA:8 a=UzCc17FjNfKiz9xoyN0A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12098
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4FAF840002
X-Stat-Signature: uf57fhefxdjd84dkriefrw53nfpxoqfb
X-Rspam-User: 
X-HE-Tag: 1765186203-792022
X-HE-Meta: U2FsdGVkX1+t0dUnusoJXT5vBm9ODw2fP2s7OhDkmCjPqQl80+ps895hYQ2s3ZoCQPvZgISgB/hZqK4o00EN4nRyqiaC+8Z/0HEhpNMwsFXisK32zd/OC5CghZFMEXWhwrQQRp3vYPAr4orzGx9HXos2SMuzJ7qxXtD1dxRJoFoIfIK2W7gwICxIRty+m2GpqYENq/6VWPCaD0YfVsD/XXMvTzCp3Jlg0ezmjbxBs3xeBb8EvSCmrkKw1yr3fhncoqAdVv3xYghvrI1+UiJtQOlYs9MRAw9wOHwRj0VDT3rZeroNK9bGrrvfDUiSLezAAxueUwLmnylLiNDEYIRJvuVGr36s+HQB+Na+bSFWv0trsQVfaiZDRcU4c1y+ytnPEh9dGSiKEVzpNauXpzhusZoGlLPu8jd8+m21kVBYx8vfKO7ZhkLzwQvno0AIw0affZiDZ85Z0NLB1MFp1w0R47XWWX2sw/mdeGwCbVV3kmNyPeAp5Emc64151SKZdpjtgdYWwzysm3kKQlfl+ChCQMIOgnAQFOjnj+X8twuXmKLg7Oy/DikwSjkUyFZ/O1ErlgJUFPtHi3oWNUeFQf2bvzmjWV8+vpw3CcwQhU/csw1wTsfqjOvDWITy78cRstSC5vv17xm1bPzkszJroFvZ725sEzcLYqoOwQarmKh27ChVLU48HBzEZF+9xFp1BaDQvaoNs7QYzoGtiLaCTV+9xPVaYdX4L3oqxY1I6hlz93Ucj4OEKSyvflnPTVqgTCWVNqTWQkhfhdJrsp073OcWDUsYOoJkUgpO42z5t49MC3az2VwpO8bgAtdX7sfylB3VCrJ2rDaz07sKr/fO++VfmEab8x8lYnVloq+xQXMoySv4jbDkYcI4IR+bq/i7b/CmLsCV4zpXDrffiSk31cENZ6Uw8RiyAzBzbJwgH5Z+ZOJGpv+9g5EGAre5VAPLBQlc3ZPP9svTvUjofSBb5iv
 8Y+LucFz
 iHVtLOgwccpZe2PHf+Anqkpiv+56lKXQDrhxol4UOOwn4PZ5LmsWmQxSdeABvadhAu1y/UOFhNj0NocZebr2ahzNXZy9tvxH97NlInhPKlDwBKR/FTtitTPg+esXpvPM9VSatNN3oYVxz63k5ZDYYG93fy0SgQBZQ6j6EQ9H12X0hYaV5z4atT7XkIBMJRacU4N347LJz2ydjXeraJpsNip3pYlEaXtJOiWR3biqVi/XGLeejGvQnzEVdlp3Ogtjrmbe6X2WVA15NRmL3DcHV/g9yz5wgzAugXNil79Dt/WsS0l/aHVFTGSO8sDuCHMjWsVWk4IjLfPT9+769Ql3CD7bv3PmhKB6jQv5jFUCdGrx1nt/UStF81J83iEMsmuPDhEMCvNHRIE7h2q4tmae+bCTWIeBwJKoyxrdfMvrKaizUnK2Sja6oJTdUe3rL0YwnMniXYxOu0R3O07CpSrQnlm9T0PllEq9EYskravyQzH9lTPtPCTuI6TGOryqEpXgrWF5EI+4Qp1nTgSBnqBi+nKp0RuXl8Rq0OdfshgqNdWIzOxiXIJcXya3oPi8ZWiCvJZ+yNYQNSU5hDqJ9FUMNm+jyUeAFRu9v/AHUdDX+bbEqumWdowKrbBcBFq/tSsiLCkeJNQ3/VwYvCFVHWiLcdSoMiXWZeuCa1G6iJHOZP67FzccYXz47pKrFsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 02:12:55PM +0530, Kaushlendra Kumar wrote:
> When tracing is disabled (!tracing) but the slab has tracing enabled
> (s->trace), the code should disable tracing by writing 0, not enable
> it by writing 1. Fix the inverted logic to correctly turn off tracing.
> 
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
> ---

After commit 060807f841ac9 ("mm, slub: make remaining slub_debug related
attributes read-only"), enabling or disabling debug option at runtime is
not supported anymore. slabinfo's -d and -dA flags are not supposed work on
recent kernels.

As it turns out enabling or disabling debug features at runtime is not a
good idea anyway, could you please working on dropping the feature instead?

>  tools/mm/slabinfo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 80cdbd3db82d..7c51d283504d 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *s)
>  			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
>  	}
>  	if (!tracing && s->trace)
> -		set_obj(s, "trace", 1);
> +		set_obj(s, "trace", 0);
>  }
>  
>  static void totals(void)
> -- 
> 2.34.1

-- 
Cheers,
Harry / Hyeonggon

