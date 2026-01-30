Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB7DCE6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B456B00B6; Fri, 30 Jan 2026 16:01:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F926B00B8; Fri, 30 Jan 2026 16:01:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80AF6B00B9; Fri, 30 Jan 2026 16:01:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD2AB6B00B6
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82337140617
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:13 +0000 (UTC)
X-FDA: 84389850426.05.4179B4F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id F3E11180015
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KC3Dr5HS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="w6o/7NzR";
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8vg59wYyGp9OYEKC17r9gTc+r9ahrfGb7yHqJ+IgVs=;
	b=M1Z4pbcsr5PIwWaWuH68SpFin55nPq7E28UayD4f803Np7LFXx0WoPaX5LIqZ81RMwHFRy
	GTOSJLVLY2CbAMfrC8u7OADwZZJJMqvNfX5qOTaxzSJWVcGgCsmj8Nz6hGqnGwlYXOB7ZS
	5DN0PqtwffcOnd0PIVzNGPrxpTSUWWc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KC3Dr5HS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="w6o/7NzR";
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806870; a=rsa-sha256;
	cv=pass;
	b=VkdqJJ1TAeUP1rvy8zMkvUih2K4mnUIFvTTNabuMnrvIsSO/rPOXmsvhH+wWTwuxYtXngn
	4nexXmOIT5BwyhO4V7IpT6cLHwc8vVAjVai19XLIqEQmvXe+7b3HpwZMKnI4R0bvtOWCxi
	fFhG+XFGZ1Ew7d7KxEB3HMZS5h6DhEo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKEWS0610873;
	Fri, 30 Jan 2026 21:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=n8vg59wYyGp9OYEKC17r9gTc+r9ahrfGb7yHqJ+IgVs=; b=
	KC3Dr5HSTj0HUPuL9IjvsN5i9KGijjamacO7vpdw7KM8ULbnG21DRhEhgqATU4Z9
	lh2y2EW242FElSwc2L+Rt+4Cj1j/2tbxO101c971oUu/9qVHbDn9+CVrR4kluSF+
	jshJdoRJ0xArbFRNrG3U4JrahM8cSqUho8N1ePLCWRjtYSpT8T85PMmbEk7qKciy
	2Za65vEEN8s/5flsTwrEKyA+UqA9+qYDCsOa0LAG4qgk2HD4BfaY//gihYV8ErrS
	laewRCmCjVREwvAIk2jzfOuj9D5ukThPlkyPJKt3/zUqXSle2VaQw3CPjOQfeV3Y
	3U7SNizSVFK3aGYHoo4Rxg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10d88bn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJhLP7010549;
	Fri, 30 Jan 2026 21:00:16 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011022.outbound.protection.outlook.com [40.107.208.22])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe5g6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K/BF+2+ce68eAytuyI5xoru2J9qdISofbNnvzTA98f8jPR2xm9COCK4N6vBBZJrmzUIk528v9XaPSY0fUJRWfst5dzg5POqrcQJLyIVf5aenXV4hDsyR3caHEMvHDPyjNRRpZr2H7n6nlDIazukRw8FPKDIncMBoOx3vUOsutCRCE1ffRZOzc+1EDJCZbtpCO7sO9lnqrUHS7NFSy9BtPcL+qouK7dlRiiUdwSwanutJ2F77wJmWaTbEXvs0NkzgJNPGiE5tX2xBG61pJuKi8Rl9bQWK2L4+2sMOqSpnk9vRlpO6oqyny3QG9ZqeO4lUOFUWE9fTSNIXshyq23rZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8vg59wYyGp9OYEKC17r9gTc+r9ahrfGb7yHqJ+IgVs=;
 b=lWM3i6vuGG3Pxl+Swa26lTjZd88k47Vzl0b5Q5SyNJ/G/dOFlBwvyRZpMm6N/yZWwHF9yZvbxMuicyxHSltoBMnnywQiyeo7O64Y5LSuTPQby03fe+Mp6GflSy9jmrtBsB+rt1bZHsTPgEx1rCZccQdGMLJL5ZWK1gyGUekuwDQijvUbF/35aFWSPSU4zwpEux7lIlzK6UIX8ZQFouiof00KeEUjon1Rfv3j+yqdJbLgtis5VZRXPlvt45LNzLGKyZ2LiOeQhuIzsLqKu7IbyQ8A1CqtCE67eu8vMSDQ1vHYxc6FF7WcY0gVD/GhxmNufR3txiKyMwsUHxF9ZEAj0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8vg59wYyGp9OYEKC17r9gTc+r9ahrfGb7yHqJ+IgVs=;
 b=w6o/7NzROCbE/9LoKQUeJ0IZZZ61bTWPBGEZf1fTX/KAXqyO8Xo3goiDV1Gh3WLLhxeKAwpMZULcrKTY5TZOZP7BPCyAB3ryrtUn7EvaLvPcMfd4OG1D+DAxZQB6zJTaWb9VPr0LnnbeG6LIdCpBFm0OA7EXpTK7diJGUDBY0E0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:10 +0000
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
Subject: [PATCH v3 07/30] maple_tree: Remove l_wr_mas from mas_wr_spanning_rebalance
Date: Fri, 30 Jan 2026 15:59:12 -0500
Message-ID: <20260130205935.2559335-8-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0395.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: df819817-9b99-4710-c721-08de60428e5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NUt2/Sgrmkt/wgF4huJb+3m9xW2nKdvUqU9n5t6+rBrkGNIC0/DsEBG7PW5e?=
 =?us-ascii?Q?dVKp1KIhB9eqE4IsjY/p08k14a/gnesvVw/9sP1NWCTd31jrUWDefJWxyon4?=
 =?us-ascii?Q?enkkyaXljp5zmropafMXV4rG5XfsRKNQmEX5K/wDz/s/uaeZVnXeN2pA05QP?=
 =?us-ascii?Q?Z7588GUeyiSkCg9a09s6Ru7Uo3fJh966XEqkmT6gxr7LrIxh5turRUUo/BDv?=
 =?us-ascii?Q?a31dwGQ653PgMtc0xHum/kCOfqz6ZiJLn8zdMVQ2vaofzUQfQukPH8ph+227?=
 =?us-ascii?Q?pGLGjKj3D005ds28v9hh0BACyGmLosU5IeRUZ20BkBYEXIKIz0FP4tkCXhNB?=
 =?us-ascii?Q?LW+OLJ6IsduaawlD/aiIXFJ02cgtB7PelJsBUEzqckwqYja7M1Prlt/x03IN?=
 =?us-ascii?Q?Ysw80mbDTn3CSsvrGrQB8o5g62Z44qnXPpfnMnXb++OUo8sWFaI1C28V/HQl?=
 =?us-ascii?Q?216NNuPiiYuDEzR2/wIi9MKJJla0M/pIhvkO4AY0Q+PASfl1IH458v37vP8J?=
 =?us-ascii?Q?s2GDJSzixK/HhYHw2DwpDATz0hIW/bj+urIrViKiX5LCp8WFT2DsaZevudtp?=
 =?us-ascii?Q?T+ZUXTLpXz8xBOGoIMpbX/gi1PXRJieEKBUda7qiiIgB6/oniULLXqG5nsRO?=
 =?us-ascii?Q?cqOFpun1pcbwoRYzr3hG5A3nrZMmzhxndHEnqjTodyUy7zHs30sMA+y165t+?=
 =?us-ascii?Q?9bzSFj69Kt7G2p0k5d4lWadGvNsEQ+PENpFmksDenCv6S8+C4JdtvDsOfDLG?=
 =?us-ascii?Q?J+939gVMZgZxdFgnI1UW1jlGndMbI2BeObjhAsov8m1AZKaKsNwTJvC/NXVA?=
 =?us-ascii?Q?i6rSr0TuvE7xbeN6HAnxSkoIvSzf8poTHcfzv06QkRmn4pfTFRpmGfpEH4Jg?=
 =?us-ascii?Q?ebsw44IsGDgDEeQuv+ubLhTtHcoTuflEgk3Xgz6tBPviZaMzwEptLvqwWxMj?=
 =?us-ascii?Q?FVbmMDpNidvzUINSrGhQsbwrcHKXm6QuF4eJOz9f7LX+zvPlDfUpK5md+ZVk?=
 =?us-ascii?Q?2DSMnc8DblNiNsZW12TyNNjAPfPRFooGoglZGz24QzjVQgfFY/rtkmGIMff5?=
 =?us-ascii?Q?d/CR+FIc1gHNEn+mu5369A4k9jHY8y20yjGM+GT/O0N+oEl0oupBAXTcTwhr?=
 =?us-ascii?Q?7QIBj6Mg+hmIjt4mW4QJtG+kQyDMgkiqG1MIgwlACAIC1zzQd1binFJ1R3zH?=
 =?us-ascii?Q?las08x8SLXoMPWDjEdD+u3cIqi0moj0SHVHsuZXas/w4L0yR+YbZBjNGbeYJ?=
 =?us-ascii?Q?yFF4IdwkeAzRtNnyGm6BOgiqv1hetOk0cgDawXwiVIpEZf1H8f8qI653fwDV?=
 =?us-ascii?Q?AKCUQqHQb1F4Q8CRFYpKh0V42Wx3ssEInjbanVtCCx7Si4zatyfCnJAZ4H69?=
 =?us-ascii?Q?YP0E4pHq5icZqehqUGKIcFF922vJTtIYDxCcDAfKJcipPs3s2SvkLrETuyBS?=
 =?us-ascii?Q?nwc1TEcI+LA9oA7NnxMbsApj3OmFAVOCeUxeLL4noX5lDILtRU4pucnUkCms?=
 =?us-ascii?Q?fOGhpqdgneOnAPrrR5JUc6VduHSxQZoGgWkzfh/tRcdnY9T8vPfn+iETdYfh?=
 =?us-ascii?Q?i5Yf35UX8vj0icO6Bio=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GbK3rnmUGEUL4y4e5vrglZ8zeAnyN6/RL6eJJSUrp8Ed4PXW+6xVqOikGDRL?=
 =?us-ascii?Q?hmobfUqHk4/gQhTzIw7NATB+kVFBKSeuSp8H/aUb7h0euL3HiQp2HicRk3xr?=
 =?us-ascii?Q?qryZ+VRb2byvkHwveCKl0Dq+wjMnU6tflfdCqYFe+vbVt7C/ZRor6hcsFNCM?=
 =?us-ascii?Q?npAAOFoQEAHEXfkr4AGzrQkt978bHkIOk0PD/AcxouvLXLSGXIP8iYFA3bjU?=
 =?us-ascii?Q?61RrZgGnGiffynw+a/qeT1bZNqG7yeMuTmRxhON+gKpsEYFhnHUbXM39/HT7?=
 =?us-ascii?Q?IEPGpctLGZghStK0Ov6bTPnl/POvKR1uStN8BYBBTiFiTw3K6r4/DKRg+O/C?=
 =?us-ascii?Q?afnrjPMUvOhMUGhiCBLkiYk83TBlfrW57ClUubeFwn9RXPzUBA3IVFHG5/ao?=
 =?us-ascii?Q?V3dzBspx8cAGTstHJVLFThxTp18xPsOCXjv2uub7LJ6NK+mIV8+bT69eRQ9B?=
 =?us-ascii?Q?pi4YBnkgmT782511de9H3sUfUwv71Csl5wSyRSRM/ZRrHSlMvpuB51Dbxjda?=
 =?us-ascii?Q?TPZNbyUfRiwz7QMPg1RgnnNciKDnpnbzlfOMkscr4xU8IX3b5f6jASMr4IaI?=
 =?us-ascii?Q?HKHcXBv2pahFY+QmJIlDYyKXzeD55UiXVnI8TN4ytClozPFQtuLP7xaweowv?=
 =?us-ascii?Q?Y3/nl16B+R6kf/893F/31Hu7NIer3+N40QvVxhckmWh392miLCqtWQ2tmAHU?=
 =?us-ascii?Q?QkGAZN/4AE9DlODRcSrU7qaMECTrO7UmjfxKfEZf1sgoW6WVitU7TKNgEkU5?=
 =?us-ascii?Q?AeKeKcUATDL/2e5SQC2cx0evwXLLVP3EHiCEMhkRCHVMRdvTYaQUkBvC9qAU?=
 =?us-ascii?Q?onk41uLo5ypq+M7NsgSudyIGNR15fZvbiRqBpHmnymry0t3XSiCCiRg3v0dP?=
 =?us-ascii?Q?r0uP+y+qTvN/bxo4OjJ0uZR6ZmB6RscRv7pktNgmDuK8vFoSDZ6dY4PZWtJr?=
 =?us-ascii?Q?9jeFd4TPyaL+ybfhA5W+/CWFZUo/Hk7IqqvVI66CtEG41j+Mp59bDCZO/rZd?=
 =?us-ascii?Q?veWBQvrzgBFctMsID3R7uwCG+Do56V1wNdBglNsaWz/Ze/FD+W3V1TFOrefm?=
 =?us-ascii?Q?LfbAhXq0gEic/nKBCgcmFOMZ0m0Q9T7IkiCK+16Eon56/XWjKam8YWQjnaoC?=
 =?us-ascii?Q?8H6xPImVkL/TeHcLOZ/oRrPwKzqwE/xnPf3sXlPl4nVFaxFICaJsm3Ngo88c?=
 =?us-ascii?Q?6U4VHt5USBCfCbcyS2jo6bisYzcKkrJTePfLEEMeztQzoYdCUqfz2ptLorHd?=
 =?us-ascii?Q?kVeOeGBeoFHzo+7y9FrOvgo+/lry4VK0j6XIaeUoCCcoYF/KmbuYRLpU2I05?=
 =?us-ascii?Q?Lvs7rRG3g5I7KEJoBlFLJPvcI7jzrUPxfGSiOlU9u/4XyosYEy/p9PfqQtkO?=
 =?us-ascii?Q?wYZvwsDU9kBh+4+/1tXM6sc//9+odQlIMDc38hNgVZQChX05R7OWVUlU6+2p?=
 =?us-ascii?Q?8ROUq9HWFwVIUSCQkh2wnRGwntFgXGzSdvX5euOATvU4/BNQmFotcRvT6kSl?=
 =?us-ascii?Q?MmCYr2wOYRGKZX+rHo08ERofmgMSbEoFSZ1PBp3MSdUOBPhZe09SmWmEFE7y?=
 =?us-ascii?Q?KVxys3d3mwq1W5A8nboAX9N403ZTGjtXhbpO4zGUafJLqfzQuidk9K/87omJ?=
 =?us-ascii?Q?VyLz0cQxH0knoOZg9lcLb4fhS0RTL4K9Bc8xZ/XWzWzwoh8XZAZywYCJS45Z?=
 =?us-ascii?Q?/7ZQB9IcnIuaPKWBO+uYnjfdgaFKWidXFKniYWldFSLmnOLtQ2Lnf3oniji2?=
 =?us-ascii?Q?KkLVq6+uNQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aieqYXwHFsRqbhhh061wryi5SCU3/R541T3fgkmSkjylUU6Uuw7ESTaasCJpDimJ+DZV5EuHsbl6Dk6+59gBsq5+yQ9ueT8Oo04bT1Ts5rlziu6FkBDLajpZHSV4swl8+TjQ2ZuVICHDfJZ3gQcQhMQNVqLhEY6jsUlj0Y88dO1hF7dJ0C99+LYpdbLRAA7bCSUVz0+FgM/qPw2cCAMCZukGPgRGE8FxZgMIykzRiXlXFjGFQ7ExddS2pOuz+KX+ZIVgx6yfYcztX5pgguZGgTZFAKOok/Ymr3YwemHxsQF+eeCJOo5kvKzj3erNdHbwTk25HWEi5DxXaF2h2GrT+IdmyVWP7ottl3IFxBrVE10dxhCfaqMARKfOFI7DdeP5ctGmjz6lUsB8WXxRdIU+g2EO/EW8NvEyxcb1t4TJ7EAqDES5+nJCLI5o214sLjJVA++p2UCXMpGZU5HL7f2rPvdXLsG5LKLkwp5C+CKixlWCXHdpbRZO373YPFJIOvOw5NsEcRS8ObO/kVRJ5l7YebbXvL5uskoiZ42Pc4QF2YDc4/ILAM4GYA66pLzlxOUhAiXFn0p5BCbAPlJ8LELCsYycHnxy8nFpWf7JyC1SyoQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df819817-9b99-4710-c721-08de60428e5a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:10.6570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lVEfHgaVbBOhtw/uA+kxGsfekRXhNeeI/n/C9QFsCjH4PQiN/IkmWbmssIeOJvZ2oO/6iZ9GXsYDgOm7KxuRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-GUID: oti43Y2Tu6qpfaQ5KbIBtuzKTAJFbPqs
X-Proofpoint-ORIG-GUID: oti43Y2Tu6qpfaQ5KbIBtuzKTAJFbPqs
X-Authority-Analysis: v=2.4 cv=YuoChoYX c=1 sm=1 tr=0 ts=697d1be2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=3hMZsP_xGy9I1FFZ5EkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfX8QYvMPJfc4tq
 zVpfi7N250Jv3M26oelhhFKvgDwNEYclvckAfTF2sx2g74mgTVHDVzGb0xF/z6EdlFJwd+xq+qI
 wo85wMgiawlr1Bpshi1VcpQR/+Rj9+ijH/uVxJuCSCclWuJd8SxmSu6gMRiznJRnBe9I+jhLN+V
 1KGIpKRcCt6ZvPcy3Rfre9MY7Hks88yfma5j+BzW3lql4QcSBbZc6lxOhWTWziYJ7Xb7IaIWAgl
 CQWufQvla2FhmLfiCynLQ/5blspR5pp+wZ0T5BoepD+0SAGToQ7VGvj9Rz+3HSSDUhwTHucGEEO
 CkA9vFoWQ3nUGQRDrq+K6aKk9MeENHu6BSFudAThoBWI7MTEawMwKLZIKrJxPPx+PxSpQkdzxR7
 vAyKsw6iGMki+3QmbCmwTjrsRh6y3JXMfxNlM5aTOgIF4oZKiFj/MrOmSjkQsGaKQmQRDPovNvL
 SJy58U7x6BFkqrhz0Aw==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3E11180015
X-Stat-Signature: josishtjsufaaed7eqncdubf7tp6mza6
X-Rspam-User: 
X-HE-Tag: 1769806869-249790
X-HE-Meta: U2FsdGVkX1+ao+n1HVLv0KfbvDHjDzqMvzeYxR897lF9tEXq4X3ibj9G5ljUcpses7Urzg0D1VvtohaxQ4bqEH5k53YGOohbVMdceVjBtj/O8O6WYglFxKinyLYS7yFzJ+5WciWtAM41Ze9tfASwXDTRMNdOTnF+o+ypv9Fck+Qy+3d1AJMj58ZCp4BwdxyBEpmL0oIbGkK68AtB4bL2OByrY23PYCOuTrlhzbP75Uo4sDhOE//cxLNaEbxJmOcu3dXW5PZmwe5wusihD7oWzVwvitNlur8cgjpO412sL3ClKms7NZu6Egs+gqZM6ipo20b+xshE09V3oK/EB0KGRA5Pn9uSRgq/rdt6wpOHygwa/suLOAJsLhpeUIVXCMqA6LB50AEGzdS2+iWqvSZjkT271tIgxWVDn2PAEJ1qvPKMXFfaqHdYFvnmpOkkEVjL16MQIaakYH009Ej7qR3ko8aYOaFepnvLso5ySIH1E7qdCZmC9TJO4/oWPFy71DyFr/VPzGlRdOvyHOJyYamzMtioUoeGKrMEJvQxVN3PCjtXnchCPnxPuY7MFbUb59N1572DCWW9YXIoJA5+7zkNt0HfbjklKVIlTru89mj4hZncbwnsg8D7wLMyjguMEr4q+SDOrJRVPpMa/RwRwsHBi/VH5LTOMsJyftSFM2DZfBFXyQTHJuG/ZUX69qLUQsE7A9MVjpIaiYgIj8W8Ebz9JOjodLfZUMI+mBPJiVlLpeY/ry9COfer/soH1CysOQWl5vUziHUkjnLPNzVruJpXC8C7BQhwM9IQrk//4mIiS/pg2rQ9avS1KyqSKrfkJHWDmZ2G8yjE3sm1vZ8IvN+w9YtyDOkCGFcXV3BImXl3R2GwE7cQW9B5At3dNuOcRaR8hb6+Bc/ykdNKDKL6UWX8bGfSLRSimQfVQC0FbIIKY1Bp+2Wn87fsa/eNele9OCAPbqCFZwknzlfXdG3T0QI
 YHCgqZHg
 a4GTVQwBdcudp8rRIizRX9Gnh+KqWMlVlD4GKIvAPwEtZqKhBQ8m8WSPSHDSFyz6N5Vj9kPKYkiBHS00kvirQ4eAr3AFxCuvSjUf3344Z870QO2M6Liu2NWq40ovE1uJheEXw3b93j1I/UkIqoWcyBtEc3xwHo/QytqStAoIgdZByxOdSQnbcSFjFHnvW6CFp3g7qFFrkbMT6RoLxsJv2xZaHk3MzuzAqCrVeM7ySg64LcUJOMtxYUAC+3712RkyAmtA2EOKDYR9skWFENvmciGHyDdnWRXjRRjXuXRjqBMfMC8Bc7VmZXH2a4ERRxOo0CqBJJGG5ArGp+Jh1Od8rf1udsbEKouhqz9++O8ASjcfi3j+cx05cSrN69KxmfboxzSyMtoTyjcfI3T04pEtIzYQ+fjE/+7Pht9o59+MZrvJLLEgLW23qUojTalFN8P8R34E2p/3jwk0Yc4wNdr31yOBPftnUt5ev9OYING4JqqeD6V941wA3Lm6fem9GDQ/NYNH4zFItBdENhiAVreeIq7kD1Ix57Axga0iphcitB2GGUwSgNRnNZOdlmQXNlLmtvNdXst8O9NmjowVF2jMz9CsENNa2+5XmKQHTMgcyd3FL7yOUNCJoGpPc2QRQ8K2yZNudp7+AT3lATuVjsE5Bh4hsfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the wr_mas instead of creating another variable on the stack.  Take
the opportunity to remove l_mas from being used anywhere but in the
maple_subtree_state.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index ab14876bebf7c..afa39bbd687c0 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2751,7 +2751,7 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char height,
-		struct ma_wr_state *l_wr_mas)
+		struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
@@ -2760,7 +2760,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(l_wr_mas, &b_node, mast->orig_l->end);
+	mas_store_b_node(wr_mas, &b_node, mast->orig_l->end);
 	/* Copy r_mas into b_node if there is anything to copy. */
 	if (mast->orig_r->max > mast->orig_r->last)
 		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
@@ -3454,7 +3454,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	MA_STATE(l_mas, NULL, 0, 0);
 	MA_STATE(r_mas, NULL, 0, 0);
 	MA_WR_STATE(r_wr_mas, &r_mas, wr_mas->entry);
-	MA_WR_STATE(l_wr_mas, &l_mas, wr_mas->entry);
 
 	/*
 	 * A store operation that spans multiple nodes is called a spanning
@@ -3494,25 +3493,23 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	r_mas.last = r_mas.index = mas->last;
 
 	/* Set up left side. */
-	l_mas = *mas;
-	mas_wr_walk_index(&l_wr_mas);
+	mas_wr_walk_index(wr_mas);
 
 	if (!wr_mas->entry) {
-		mas_extend_spanning_null(&l_wr_mas, &r_wr_mas);
-		mas->offset = l_mas.offset;
-		mas->index = l_mas.index;
-		mas->last = l_mas.last = r_mas.last;
+		mas_extend_spanning_null(wr_mas, &r_wr_mas);
+		mas->last = r_mas.last;
 	}
 
 	/* expanding NULLs may make this cover the entire range */
-	if (!l_mas.index && r_mas.last == ULONG_MAX) {
+	if (!mas->index && r_mas.last == ULONG_MAX) {
 		mas_set_range(mas, 0, ULONG_MAX);
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
+	l_mas = *mas;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, height + 1, &l_wr_mas);
+	mas_wr_spanning_rebalance(mas, &mast, height + 1, wr_mas);
 }
 
 /*
-- 
2.47.3


