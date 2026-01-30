Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A51E6BF3C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 22:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ED316B0093; Fri, 30 Jan 2026 17:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A38B6B0095; Fri, 30 Jan 2026 17:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B956B0096; Fri, 30 Jan 2026 17:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34B726B0093
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:27:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A2C88B6BA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:27:35 +0000 (UTC)
X-FDA: 84390068070.12.3A5B205
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3CF3840009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:27:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=npbiXB78;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tyFLKRCh;
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769812052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFinNkW3ma+yKaad7HDSLMzzitXG26pDGb58oS6SV+4=;
	b=2No3/E1sXualr0OC0Vx6djcNc2rNs2dAPGOG9kiyFdhkC4ZD/FZMuV3PmQWXmiTlhzSvsb
	5deSRB2qNJ2aIeGeoa/QSPyxtevB6Yi1p+1iSoTHfV+zhKJC0KXOxIXz/lfUGgG/avFPbQ
	EiyKCaxQwSrJGITajgyapJ2J7M6VU4w=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=npbiXB78;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tyFLKRCh;
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769812052; a=rsa-sha256;
	cv=pass;
	b=QQH7r6qzOCWYFjqEYFVXtXDKbTM6p+SQ8vzwrXdXDl2Vg7Xgpo6+iCfFddTF+VtSnOltaA
	Pw7zH0hRYCd0VHpPWg42tG8HGLJ0SqDn+H+HA7n+Fi5gArsnAO/i84tRn2e2KFRbg09b9S
	eAlmNBrqQdgI4MORqe+0xtqD+Kd5Sv8=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKEVRx610866;
	Fri, 30 Jan 2026 21:01:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LFinNkW3ma+yKaad7HDSLMzzitXG26pDGb58oS6SV+4=; b=
	npbiXB78Xq3umn4R3oEcVFmDc39P+yctLXm/VWHmLXkyrXQ7VnqmdbnNuCQ8YT/H
	hiDLovzs5LsrfJumjUN2npGxKQFNLfLDQB0+WbFpXBTIIrQzkUbKD3wGLbuI9mje
	R3ZvH6oucgUFr0nNVchVSiEOvvlA0xZbYSydKtrl5y0CXzp6BZ6YbOIuzrs79ytj
	+GpkkkbTRJXBd57LbGn77l2Hb7ZKHrol1BXFJZCGs6lyEyCQCMlIoCOXLBhXKoGh
	mQhap6TojFBV9WQYJDrMkgOG9iYnCaW3rwFyFDDKIp8zXutQ+7lSp737Zqs+A9Z5
	YMgr1/g24VWvDdzX+ytrxQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10d88bpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:01:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UKeggL035129;
	Fri, 30 Jan 2026 21:01:04 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013041.outbound.protection.outlook.com [40.93.196.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4gwr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:01:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fcKPvnYXlvDQ3scvLCGUfhpMkyEZ5pu6ElVnHDfzhkLlDWxm2KJlVK65KMk7spXgSGBeEEoUbgOfg2KxlKO+2Xk6LW9X7FEa8u4ko5C0b6lG0XwFi2WbM3V7rFFwYQkjLLQjCCOck6xodq7FD5cH24UnuRES18u6hLGcBsrxS8LoMUdkuBxGdZnHxofN9yHdRY0ij2NqkewE4ntwFtRiSGpBswUkPgnKbnepr1xxDqmZhzv1g434bZlG/aFqGcyTczM7FgdfbtiJ/mywjsEHI0qC0VJQSa+KmHLuAJ1QyRTXpocdjndAdfIBKOAfkhccdwmxbnLvHTBftNrkhYE/WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFinNkW3ma+yKaad7HDSLMzzitXG26pDGb58oS6SV+4=;
 b=lajhHBhL83CEDh3aiGhkgbjIbBwyUotrmSNFV1x9d9Nxgw3kkwho7HgSeQiW8E5i7QmR3qYKjXt9FVd1nuICyZm18JsF89pb0kWJTd7UDmzUSc5W401XADLCvNW6NFP5j6Mmkx7oXUguZ1gKX0n3V9SLFOz/6w1U51sYRVcla6BQLT0xw6N8lXdSrZ4B+EOPmaEFo6Nj00EvtFZ48pY7v0ocBQmntDvuIgeZbOnD9pyoffEoaAP6CSlRLzo8nJRu2YjD7+xQKwyCNImLGashCxVK6L/D0Ojyf+z5LuvHURoOCNvJKK5OfhzWSvDTzSo6c2w9/VTupLHz2QHtRfrbPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFinNkW3ma+yKaad7HDSLMzzitXG26pDGb58oS6SV+4=;
 b=tyFLKRCh+fUVM8fiJPRGbFJr43aAUtxpSCwfRed+OvdxiQrscoeiVnZM5wFlDJEnwaHKL5kxM2HFssa8qJ4Uf0twaCDICKmtY2rbezHjhZQ6e3R7wAuHxQYcQiXdRVmSlca4R5YrdG+E51C2G62oLTaokxrhrrMSWEdQ0INuH9M=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA4PR10MB8541.namprd10.prod.outlook.com (2603:10b6:208:56b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Fri, 30 Jan
 2026 21:01:02 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:01:02 +0000
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
Subject: [PATCH v3 29/30] maple_tree: Don't pass end to mas_wr_append()
Date: Fri, 30 Jan 2026 15:59:34 -0500
Message-ID: <20260130205935.2559335-30-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0004.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA4PR10MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ac2a96d-5f96-4dc8-f610-08de6042ad28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O+iSQyfmZOqzC1VQTxZtBTgz3jcQgHJie50Z8HOg7Sj3dBxmM1S80toNJHpl?=
 =?us-ascii?Q?0ev0NLqtrZk6g7utz83zmsJqiba7L2uWRWugQEGdo8OuzDqrnjWo4k5Flthc?=
 =?us-ascii?Q?tQHODLFLRVh7VhYh+Z5lybzwYpaSUTVjyhovvhnhieu5SJCNLRja+1zVRVVj?=
 =?us-ascii?Q?ZivJhnwdxcL6/Gl1nR/zHhi5+mwcvwpUpaFzdGRASY6yiiVgtfwA/STSu5Vg?=
 =?us-ascii?Q?k7LGlXNYe1fnKmiamsqndZX7NfzRXqDV5wd1DSE0P34RO8Sl4ogaO95EWu54?=
 =?us-ascii?Q?AFIHj4W5fZdphlRshfKLeoqWKyC+oaomundP9z6EOVp9CHjOqWm+MtJGbXSu?=
 =?us-ascii?Q?+05z3h9Yxk2xxf2QBFoKZhhsWaYSBTNBM0xa3ZO9gwuaiiPs7kP5tXDkJwGb?=
 =?us-ascii?Q?lqp1jnz1oXGRtrHhoGmlyLWSwIYitqWmGyhWcCi5Xz7kiS05FTQLT1DUCcE5?=
 =?us-ascii?Q?YkAAWCwiJ0ln4f/8InjcQ74lfTAJWG5PnXSCoR1wLENMb5Qhs3G2H1aUMY0N?=
 =?us-ascii?Q?1cH2BLvC7usBFNDZOsrv6JLRrJYbf1TG7l+7JTfhTBgK7LG6IlUVjlBlGLY/?=
 =?us-ascii?Q?hTcZQdzQJ4vIO4zvbKjMeKfQ4NJgSGj/Lg5I1nxI0U3XP/3i0Cu2pTYg020N?=
 =?us-ascii?Q?nhzhJNwtrKknmJylcv+38ZNXmCpcx2X+q35cc2xZgrbmCcqinyG/ZJ2HMNzE?=
 =?us-ascii?Q?fysR3GBRJSI3IBhITO4qIzcvmaxldFE8jApB50mVrHTlISZiNI3vAV60LMNg?=
 =?us-ascii?Q?xypVBISy+E6MnZy5ZlnF0lthoZXd3vFXP9E42uGKrhzPU7/vnMxCJF3pETLT?=
 =?us-ascii?Q?Qth1UXYFy4WXs1aPhKcloGF4i/OLBvS5UqNDBl7p6RAFimT1jAes/lMG7e7Z?=
 =?us-ascii?Q?g4ikeKZY0X6+ydg3IvuhflI6OpRYI064sBhPa0NM0gHsu8PdJREU0DH1JukH?=
 =?us-ascii?Q?TGdexpgoiVMHyU/WksDMTjNAeK97SsilOsbVwd4CgNrrFkN8UtuXOlCCzR8k?=
 =?us-ascii?Q?WCbEW6rQWPUfmR+zT12wt8ty7ABG9R/NYe7rxy/kqnaowNhGllhv7eUH93t3?=
 =?us-ascii?Q?o9dq2aSSV88HqKldKxQJcjipleYy0HVB5EbYDwEgD7T4UNRwEMkm4OyCJO9N?=
 =?us-ascii?Q?TeK09CvCwFa31Kq9oUE+ORgw1vcXSMmZJaAnPOtfTCNCdVjKrrmh5FOw6RPw?=
 =?us-ascii?Q?7DtAuqD+gcn1x2iFuSHMTaSp6zG3hnl9vu5G++1X6qU+6+qHchbIFCqTTPs5?=
 =?us-ascii?Q?vQp9PKWKiP109Daz+jUCzOhv0TpYfpCI5rg67gD45l7tMMJoqUDLcaLQJgvw?=
 =?us-ascii?Q?+2n0Sa61RepizL4dblQ9EnP9pLtHyzgaUmvHG3cCyTsxyj48sA2gWsddJ/wx?=
 =?us-ascii?Q?d4S1MODV+cdML+Ucx6wLTf+ir/RpkJitF6fsp+XtTN7SO/DY48frtdAKEb1d?=
 =?us-ascii?Q?OYiVqXplet+YlBOxM6WVoNNRV5y2vXOCoewcrfXUPNkSEaQVQECOC/cbgcyI?=
 =?us-ascii?Q?YCWu6ACt/4gj35GyFx/ENbjjeii02N0W55ShBjzGoxmM/HaKJcSwaDXUr5Ts?=
 =?us-ascii?Q?bOzrB9Pb9zR/MDT6Kg4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xyQDiTR6vpRNnSjRVFInFRwDm1LYtN9Gf96d94V1DV21r+Pp+6ELew26ilAU?=
 =?us-ascii?Q?ESk0q8WAatWG3cFbuv8qoqLa4P5allGarsVaM6z3CVTcw32DjtvggVESjtcI?=
 =?us-ascii?Q?DcxwKw6+I+jAcmB2s84bj8cNTWQu7JaSkZYJ5hCqpeYISN2Tb7ors8wjJmSF?=
 =?us-ascii?Q?JPyrXEIjJVIDoGMKbrotTZIdzHm/WdTXfFvgCeu4glLft1wRdN7NCNmrZGz1?=
 =?us-ascii?Q?i1KFC0hEXQ1frxPOF+FjRwse/nBikEd8ucJJe52V+a/1alFv2401EMuYteCE?=
 =?us-ascii?Q?9OmnWWsv/7BDi8dLE9xLaaAbD8NfTDRSWfWbYiKA6XAFVmfmnFDa9ujempif?=
 =?us-ascii?Q?S9mD7IprqXxCotBEcjnCvRLyA/kzXJAj2lp0MEflqWRFUOqlgUO4XYpUzCPU?=
 =?us-ascii?Q?zMcYJA/xOqSXRezBdlTO3ruLzaCCTYiT80Q1TB+ixanG4W4LApdzx1do5sLX?=
 =?us-ascii?Q?YqebuggQObCizMa/94V+8ds/2r4deBzV67CyRnhQxSLaVu69a2wPvgk41f0J?=
 =?us-ascii?Q?XCSxVP7jnQd20gi0hzvZ0TySt4V2gD4UyMj296osZDxi1iJW9yZabB6cNvI0?=
 =?us-ascii?Q?PRtOVfYE4NqM48ZzGihw7t6p6yE+39M+mdVkwqkTtzm/ppC/7PTPO25L/jdT?=
 =?us-ascii?Q?d8xwj8rjvuLckrQIQQbws1WzxkHlAwzCUKKrauKY60v7G+C65KZ36MamsIUF?=
 =?us-ascii?Q?us4jwi8AV9FI8ncXAX/kAp0RDESMyPWlkJB0G+ijYCtBDaS2s13uoCHesb1n?=
 =?us-ascii?Q?C3RS9vyQevMV3JpeaMWN9c2cnjqpt+6l97yfXG10SbkOckaO8xXWngb+79kw?=
 =?us-ascii?Q?b5ueTFWL38rFwKiyOVyQ13RpmXXMk0Qw/Rfg4RIHcSYkbKMLz3SC7FL3+BL6?=
 =?us-ascii?Q?Zhjt4WkHpd9i0q7b+y7p+SElnFDcxeREAymX3nKkC/SuvmhwaB4bcIB+X/A+?=
 =?us-ascii?Q?KSXe5JzWMGDyUdB+9AwfpKaGV/7Z6Ko2NZghabcFu0pE9jM4YwGhXZB0Bawv?=
 =?us-ascii?Q?m66ua80SCI+LbLTtvJKOOojbZovx5ldNpUCRmR+E9XRPyT7Fsgv0zetfgBls?=
 =?us-ascii?Q?9qJNMFLLEyRCNey00ptuU2oppSstJAtJI9hDiZqlPc4Q+n6GWCrHxrHxYdE7?=
 =?us-ascii?Q?gwiWT9RWdcJOANmgZ9zE+YDc+6p8HaHjL4uv4UXRvfCLz6WOf7p6G3zIk3eo?=
 =?us-ascii?Q?h86wjx7Rj/IKhsKqkoLB/g9awo0qOZG8Ab8B4srIdEE9sIWsNVtWD7vnyA/D?=
 =?us-ascii?Q?Oh3WD7JZxyvFDzBb6w6ZpqfhSEaWE5Aoix+k25hb3P2f01hnVfMnMQ+N6hyx?=
 =?us-ascii?Q?LW70p0J1W4Yyz5HhJCAgOISixiah3dOQHGCZKotIoGbXfKoWQMsSZKIarpxw?=
 =?us-ascii?Q?7FkrUZB+IHJbcbhTGEV9OEvSrjTMAawCgaaObjwsNLJvtvmKuM9KITU7GcXU?=
 =?us-ascii?Q?ikaf8MoPwXV7xGImbdPDacCzPT9roCEYiBAANV5yNrMwmitOEONINv6Xx0Ae?=
 =?us-ascii?Q?B1W4llNM9uVNQcdvtDzKKE/3XH/t7RWpiPE69HIRihHIzIrKw2u+rtQmNJjx?=
 =?us-ascii?Q?PK/QzZY44n/YTznVuG9FcroYxTOZ1zrpJF64RNW/AKmW3ZxBnC89Tx5J+Yju?=
 =?us-ascii?Q?DyeDVlpq4cS8clkdaGcJo9/cTCa5nHtZjXXJ69SR904BTQSzZphO544W1Au3?=
 =?us-ascii?Q?H3Z6HxFS2dApfR512aoHCyBOdeeOFHmUN/qzu4wZTkU7hrRcLTkqnEANXCk/?=
 =?us-ascii?Q?JNxs5DKjMQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	znTO6fKOdXznHkfoXfH4hXD+ihkQxfEqC8oRl350bu4tcaxrUG6zpXB+cVzuPpwW5xJUTRxfZeahbekZHDprzTUidHX9ahu4PdQ2eAn+MZG5hWGys02IpHk2mXuAIeWdMDnbr/VvRMe5+ymxqN5kp0JdOD4Mk6rQkJ013N/Y/Wl4JLkVZRfLkrHL6sVJP9ZZHDq5fvgym3f268fL2fo5tKx0Rfo4k0PtLzfI3DqB++XUiSUlJRo2sScdbDR+TkG8yqIbIWT6g/Of2VeYaZsp6eabS7p2stGLqM3NLSysTkyITYMiXKL3DpClCxOqMVeVqjFJbqgC5UtHRT0//LVFDJ0Md3cYaS9M4pvt9KPzYucngT98SLyM1qXCdBf5fZDHHL4nyU3BQ4j07ZQ4xNCrUVynH8wFGjy6uQdsLtuhbNZfDbZBbzVa1/gnHvEoluxxiR/W7uG32fEZRVFP0qki1ydqTIkPiga3Gt1LjhIiGKonGQbs763GCdHcZKzazG0ES4CNj8s3SQAMT5Ads7nKBLhBJqG41ZaI/cZOYiFmfFGkIdjKM7X9AdKO/QBc6l0XX6BJpCFgoM7SEmKFHiXQ/eB8pa7+l4S/R/iJZqPV7Lk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac2a96d-5f96-4dc8-f610-08de6042ad28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:01:02.3818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vl3rdxfaN6aYRi1OZVOyOWXEhiU2iJJkZLQTrCuQ/wg88D58cO9v+iexGjgahAy8LyMIyaArS8ElYrzpKkMH7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8541
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-GUID: 4e7jcucrSyfZLVZNAirdmLt2Wd7qcMeB
X-Proofpoint-ORIG-GUID: 4e7jcucrSyfZLVZNAirdmLt2Wd7qcMeB
X-Authority-Analysis: v=2.4 cv=YuoChoYX c=1 sm=1 tr=0 ts=697d1c12 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=eQoyOrWFz78r1Bu3z2gA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX+q8B5/rgGWFX
 2VMs1jlg4Nc3UNS1SBK6cP2giSkQqezp3Mpety+fsk7Zz/YSUlVwQ3Xt5myXhVqzrGOlZ2+yN01
 DBMUld2MrJUY0aLTaieWnB2r14AgKqJIOguUL55u276vfoF206KaSmIAhGSYQJ7VCZtloG2eipm
 bgry9oJrrVOMLKDqBNKrtRx9SKtNeNJuKr8Lnxk26gejj5nQKYeh/CSlFA/jEdLKhOx0fshRqhO
 gLJPfAoIla8cekllYuBZhlBcpRY57LjTVFDg1sOZNo4FCzjbZHaCJ0dGnSRCArdJo6Y/wxyY9H0
 fmwTw06f0KkD38rdzOR5TN4aZ4FjamI6xih5GiM/uKDuT+Kf8gg7hGKdZ3jGyn6HJlO+dZbHhow
 RQsWyPnWb3izKb49jOwn4vnSdNhVxsELWR5KXlscEg9TI34YeL/yQD+T32Mg8DpLcKNYFloX4pK
 0ni5KGx7BPOr5B75a2Q==
X-Rspamd-Server: rspam11
X-Stat-Signature: fn3t7xkrftzbp7nhkeo9z1rfiquyj5i4
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CF3840009
X-HE-Tag: 1769812052-963437
X-HE-Meta: U2FsdGVkX1/qo6UVACi/b5bFl+RZUej4hnHurWkSWoYOb0BBDXrcbawCuma5oVlalKr2woM1DbkEKnu0hTJlq/TeNxV/NkipSie6Ilge28cShJLouSU3JMIz2K3nIL4wQg9ekfc8c6oOutKcNOZ7qz8nUuRgHLx9OJOkkjaRTqaQUpubATEWRb/qKeKGJfRHEjKs2q3iEnwLsnmfj+uuvdPvKasOdqT/mF8Zb84nNe1TxeHUXGl7YzOafJt85WXyuz43kEUs5Hr+j3guRqaKGC4amoi8hKDWhjGWkt1YMgji35gDyK62UNoSsgec/T3yA+FC+WYEA9MTS87cLdKQ4QI0ul9jd/VfKWh2OhtpVnPeVqAQZo3k6ZxozYLD5U74JxtxxVHn0OrwMwZzq7SVsoD+A/HSn0o498hId2z7L09eiCmPQRxfmEGagA8iK8eapfEtg1QxFL2+w4U4V0wziP9Jy2bz2rV9oxMWJ851wuZv4ErY6jSCKvkpWMeMWQ78kc9wPmhiFsgw6MS11JAj06kJgycbveFdH2w+OWGlYItuicDE+DYEuafHZzLhsNyRWzfOEqEcYymXffhdLpWtBo4JzFVNlDNesJ0ITKOULeSgcUUgYvQBm+4VdlBtyjd9tJbeEJfZ/R2Be/3B+BLHC0+DlIoEalY5/u4/EwyTjShdrU9F90DulJ+adbSCrtBVp4WVQ5ORFsENvC6A4Lzaqdpe40ZEbO+PJx/kBl7XTbP2uMyRDfof4JyQSCNNO37Ct+sXYl3gbZi69SALGW3LskIfa+6iGCwnk5LU7YUrbv2EI4XqBHoNxyHdJoFZr1SWSKw94KKmrYRmvNoNvDOezj0KSXM7Ce62Fl+pkeWjNH7Iab38fOWpW+jhNYXvJWiUMI1g+Fe3nFkKymK6mQwj+jsBD3gklXJUwJqYqBRyIomWhUteYHSO/7lAqeqMvufItx8QaonLWWYqKQujp89
 bhgPoUoS
 +KyUmQ6Jf7VsoV5f5hVkfqWp3vdU/2/nBalDncEFAAncq0n2zCTA9gVI9u4j1uj1gBKA4ykEY4oXLkPC2aDN409Ros9kLYlHQIPaYj+Z575gpzFuaWaqwJqNcQsuzNSYlGosac/QzYRQBSK1UP+A3GQFnmUnPrbxQPPz3To1GHAaxCgL2q8SkkOJeCwz2iPbEWrKhL934H7c4SjThmyyZchErRtKdqrffQvbQ5htjmES+y91dE9CX754rGZz+nSnv4EmHb8b1BtgdYoIXrpYiO8SfdY1QJ8jrxC/hRbBDyuWVzY9i8mQCxcIMofeapDIgX9Zx3+VmOxWzWYU0/BJPgQynTZBwFJKJ66pTBkC5YuCujkIanLV8XJ8BBXg5v3NDNnntLzTgQSdSetIRVCUOjS7cD02O4/KssRtJOIn5Xvirbb682ucYwbGQtfMbXw8pP6/FmB6VUkf5jUmsq2gpjkpINkJJoMbtrEqnD5MP7l7OfTAQbKWlY8FM39HAjZRAbn+QpYNMtdla3+esRTOw06B/sONet9vR/lTDaf5ZE72lMLB4S6+2JoUYswFMyasFq6c1TpHrHj2mqf1+nYyig/Ovx6K1xy4yyjmSl1nQBWBjSku79QRea36YbiVXrpKOZUz+Mqh9gt3qUOGAvowbsQJJVUXTW/bPo4uWlphNKBAHJ3waiZesHPzLHy21enVFyUI+HXOPi5Ew+hwwzmqkX//vgMRO2jmre4m0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Figure out the end internally.  This is necessary for future cleanups.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 064357a44906e..c9c63246f721c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3309,18 +3309,17 @@ static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
 /*
  * mas_wr_append: Attempt to append
  * @wr_mas: the maple write state
- * @new_end: The end of the node after the modification
  *
  * This is currently unsafe in rcu mode since the end of the node may be cached
  * by readers while the node contents may be updated which could result in
  * inaccurate information.
  */
-static inline void mas_wr_append(struct ma_wr_state *wr_mas,
-		unsigned char new_end)
+static inline void mas_wr_append(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	void __rcu **slots;
 	unsigned char end = mas->end;
+	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	if (new_end < mt_pivots[wr_mas->type]) {
 		wr_mas->pivots[new_end] = wr_mas->pivots[end];
@@ -3513,7 +3512,7 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 			mas_update_gap(mas);
 		break;
 	case wr_append:
-		mas_wr_append(wr_mas, new_end);
+		mas_wr_append(wr_mas);
 		break;
 	case wr_slot_store:
 		mas_wr_slot_store(wr_mas);
-- 
2.47.3


