Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B746BD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7127B6B00F2; Thu, 15 Jan 2026 14:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF806B00F7; Thu, 15 Jan 2026 14:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE6F6B00F8; Thu, 15 Jan 2026 14:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB1F6B00F2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:38:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D915F140444
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:42 +0000 (UTC)
X-FDA: 84335210484.17.856F49B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 520D580005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GErnUgK8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zjID561W;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505919; a=rsa-sha256;
	cv=pass;
	b=jeVCfbqgQE2Lwr/Dpwh9ln1W2BOn+oONHrcKBomC8+Pl7J+jAfVuUhAARIPg1pHtK00iR5
	NHYNSE1dRVAZEop0yuWxuqUBhaW7uEEfLGlfY5sAj7V7M40v7FBLiRrATLgmhC+rjrrmqM
	oy4DHIdoKYVCsNkjaATPxgcDpGiIklM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GErnUgK8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zjID561W;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kG4vGuoibJIhN5XooJz4sDqOH1eo86hcPaYxfA7b/y4=;
	b=bGckfH/EPgokm3F7hPUdTEsMq6e0decR1gGyR1z+PQBbn/9Oa+igYzNW6iZuOrsekfIjhf
	gDk2TyEM8gHLB3r28UjDvpxdPCorTm5nT8ZcOuQB/EM0Y0S2tV4g1vPHv1DQ3P8M4QZm1K
	C5+hUhJpHS6F3y1X1CuIgDF/rKMMMWM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FFq84X2395990;
	Thu, 15 Jan 2026 19:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kG4vGuoibJIhN5XooJz4sDqOH1eo86hcPaYxfA7b/y4=; b=
	GErnUgK8k5/yvA2ZydKL64FKGpMeOrFdv4HR5LOl8ksu9KLFeGRj1XlRGQu3H0Hd
	lKA/ZtBqYYF4MAE2uFqqszda4dOoOaqEmhu4yiacWyD9qNMa9JTkopusY/2kSlcx
	qtTmtSCS9S4agCkjesD9/nzqgwVI0v+0PerXuKOQi4kIVU7wNTMYB8HE3X9QIZQQ
	1mYp2TCd9rMbHiYw7qYdS56ZYDA6eQRwQklX1iWMf4OZfp+K00yFDtw4QuT5k7xp
	Tz2os7bDegC+F43zHEfdjzBLdnJdncMw5lG4Y4P4HhmUbaN3/S85fTTTLgYkoFVd
	cv5Vav3SIkd0oqEGM5lXiw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq58h4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJbCBQ040448;
	Thu, 15 Jan 2026 19:38:28 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fgmdy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMV952Dqn88EkWfA6tdHMoOkCKxjDfZxdpsX49x0E6CEX4P9X6NbiOl607NtazTU7OzVXDo97F02yvJKdPLotUTd8cjhVpNMu1X2ItjI7gt3cB82LrpVj1WEtWCr5hhcq5g12SLW5NcWXM+8B4gJRxdgoCzJr0WHHMVzYRrq1I8TrmgLrTCS0y39J3WApRpRQLMXGmH7v2qFeoMi7Ow+4Pmsb14VnVxZnFWRaLTLKU4IHPET9NzeRY11UjgGcPtRDP3fOcjyonTTgUrL1J4sn4n92nk4SbtWfHGvZLTj84oCxvBnflHhOJfnW4bkQ2hL/gV9hPLVfek0O65YBPztUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kG4vGuoibJIhN5XooJz4sDqOH1eo86hcPaYxfA7b/y4=;
 b=jhr3246LHkEYJAnZB2IpSMuXdGWrUDSejMfR4Z6V0sn+iqvZbh63q7vsBfF8gfSgNF606E3IemQtWhNVQ8P4/eb/f6Rs4syB/Tua28ibRGbmBmZBwNhwJd1sfFBNZsw9gOgDm5umjrOk5czAU6J3D+HD0of9zhS4tawfw1/a9Sq2aCFJV4wqTz9Ph8tc/03lZlJhDklzJT7tu+H3iUYSoZI/JYKgixIVQqvz/9AKSP7BAOCTrY5UkVND/8YNtxAcTT5jjV/KIsydW4h3J+36rFf6HqSKr7hGEnKZTU4O8/rIVKXa0/+wMAvlou9Fobpl5bPxCWqfto/hqOkMX/Gf+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kG4vGuoibJIhN5XooJz4sDqOH1eo86hcPaYxfA7b/y4=;
 b=zjID561WcqcjSC+OXUuKDFB7R2Rzy0Jin/eYxn5KATwLcc3pX7eg0t4MB0mdeallOkmE5DOzsNWZmXrPX1qaL2JGQv4jRx8CTrt4vSmILiT91B0DxxSEOtsgl2p5pejecmch2r18Y0rpi+fdcBzbwM5pn8JbCxtNsbIvTdMrxPA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 19:37:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:57 +0000
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
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 26/28] maple_tree: Pass maple copy node to mas_wmb_replace()
Date: Thu, 15 Jan 2026 14:36:45 -0500
Message-ID: <20260115193647.1695937-27-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0115.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 1065f2f5-e60c-4c46-d8a0-08de546d9584
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uMCY3cPvO2FZ4qyqS84kPyBsK1UcvtUrIqhyeULiE/JM7AfbuuBSorAHwzzH?=
 =?us-ascii?Q?/X++ANrLnVGc+Zb8FAe/ctKUJ3phDVHapwwD85ylA2yNcScOxBdfhlP7q7aG?=
 =?us-ascii?Q?XQrR29rskFqaPe9ACUlqbTZd6X+1AOzn5d+stFAqwCCTDzoENUHH8KLwSaVD?=
 =?us-ascii?Q?SmF+m1MZyrXmL1qjZT2S3ZIGF8nrMpQrcsjuaS/BfousX2JGau0iH65azjGU?=
 =?us-ascii?Q?ttYilFN6zEzjmCrKPIIgfVaodi63ztOFrccG1+Ik/a2M8fsCENOedvRfUDKZ?=
 =?us-ascii?Q?FMtUTf/i3WNkwI82EtI59KEBDma20kE8gfLnIQRFQ5+bjEIdPJIZmb9ev2pF?=
 =?us-ascii?Q?IiJmZylnoGNIz/c83BGtsvm9HOuPi9byQif/9cXq39JbYpGlTlI6n2ZFrNG9?=
 =?us-ascii?Q?u27oRJemHxc6dIq68jVRsXdtaVC64YO3+GGWsQ4r7QEkW+8vfDw/nEtT5qil?=
 =?us-ascii?Q?YLvibsXCjcK/AahAbnDCO93H+WdtIGIo3ug7vvjDAUTg9pD0xSBDRBoo7gDX?=
 =?us-ascii?Q?vQe7g14tWQf0q/4+icqNlQu+ixgHdPlirbKdgIjwK6sDblsIrBaq68Mh+OJE?=
 =?us-ascii?Q?sWkW1N+clExtwBkIx3fnztMqfYNHQVpBzt7L7xx4NsTPDANaQSX4lN35735R?=
 =?us-ascii?Q?o5EdjFgJfkxbxWgI9932nzkxkmq3vDQy1EpqX3AXDp22mHU3dGerGOukeUch?=
 =?us-ascii?Q?DZfQDTjd4Dv9Bpk6JQxrE519tdhy+sgGYUAy+ZEClBAMuiHM/MzvvTG5P17v?=
 =?us-ascii?Q?ogvd1EWQ/qZzAt9hpmNhC48xNogXr9dJy2Lzhurbqlcz0NuS5tnQoMk7lmj/?=
 =?us-ascii?Q?DwGVn1KJtgr//O86eE9r+cDXk3aZx/Utg85cFdkXLAxOJtWLaiFlCNAu3UHb?=
 =?us-ascii?Q?oJ8ixaLhjJhV+3IBYJ0RDVua7ENQsG8lGCU7ACSFTnMaBrSsCt0VaABmm7FB?=
 =?us-ascii?Q?5AOGqs/c2fUL1CGtQ6wx1QcBoBl5EXsc5iVJ4DB9I1ZifJ9LAIKrPTP1rzM3?=
 =?us-ascii?Q?bl3g874B9U16cJ5hNho/ih3VKHLU6CzSDJAhr/bko+iWq8vK9iCuYuoF88qP?=
 =?us-ascii?Q?rZkC5TsSlrw947uHtBfUJK+pNHgscHHpCmJGZ+blVBmvxOMRe/CX4U/sgWIY?=
 =?us-ascii?Q?oTcyJx0YvL+IKJZGAyU9OaHa6NmiI5cOMvMDOcV2N1BHjGPLEz35BU2wI0G3?=
 =?us-ascii?Q?O3W7iIcDzCqt+6/q2sDy1q9rNrBgMrOdkgv7cqMOGGMLmVPWrBmjKewprYWi?=
 =?us-ascii?Q?EdkuZPWsMFP9PEwDnUXxKU6tXVte+16tBgnaNUVaQfg+tTKlMA8P84Pf20h4?=
 =?us-ascii?Q?IoeCO5XB+U6prL6l0nvw7bUjOkMf6ZchPAacudvOlXCRpiQ0LgI1YAGNLwdt?=
 =?us-ascii?Q?aSLcvg8z5MzOXeot8Q4oADghbLSh0XQODeqGVXNO85MQkSX0KhFTq6j759qb?=
 =?us-ascii?Q?Ts5pUKe+Gs25enVv3OF1Czqt9zzXbEmN1cd2pLYuFfS7UomKNZk7jEVUpEes?=
 =?us-ascii?Q?3TNZ1dcuRn8EZLPCyEIeMEQJmPhvsxO0kr3T5/cRdj/EHPL13f2C/Mty9Nyo?=
 =?us-ascii?Q?vuO7Mjg3esbrtqc+eew=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JIDE9ezMjjHtIn3uC4GXqVZUuTrAyRAZe0rych9eywXPY8rYWij0zKLbt6JR?=
 =?us-ascii?Q?VESI4D1KcBT47PXHtjpyW4tjJtf98qVj1O36zaQP/67Aevw6xVGaZaSTZMMO?=
 =?us-ascii?Q?wVbKy37vBSBHoGh8RcVo6uXaP4DuUpraP2mC08JNb1qjjg+LoE55dPdm7lwT?=
 =?us-ascii?Q?q5L56dZnHwQDLzdrgYfhlYaHHQUDsKYN1MuG647aX/Dt8y1ntAUZoxjyBgAC?=
 =?us-ascii?Q?QwGopxphfJVn0NonWwUwtbI5IKTAsqJAqteeYQ32wLex6hgBCHKNj8dbR0zZ?=
 =?us-ascii?Q?7a9USyxzSQHJUbj9c2lRkLRshD1GpTFPCv9ug2KxWgd/KQzVabNFNUk1/PlB?=
 =?us-ascii?Q?HHGgk1s+6PiFx2rcjiIIkVGoFG3xiOh+S8TL+PI6n2g9b6oodo9Z/HkMUOtT?=
 =?us-ascii?Q?MwQYNy5YSMk7AVL3PiPLDRO5tDmZOoXdR8xoySi9w8X6wflvVvFLREUuSrnS?=
 =?us-ascii?Q?/12OU9Z2YIjuDgAtCXFlEXT+pL3sF899wpOTHpsai3uSDMmnaNrzgqqyofq2?=
 =?us-ascii?Q?Qz1Hh2vP3kP075NCDrEDH7cJ0bSi9HQiHiwde2gjtY0stjdhvPyJV0XMvRwo?=
 =?us-ascii?Q?0fAf2D6fKeM4/w7DHHh4XlN7R0vM5kNyhF2pJCxtyuwOshAN7MPGwhbyGFIc?=
 =?us-ascii?Q?C1/mYd+JBDGFGNEzcgSXJPK2jhJxhl1frPHROndDMro96jAlcUiDv92G3Mt0?=
 =?us-ascii?Q?jb0H+LtQC/LCD2zhvpgHkDaSCN22X6WGsKrGWSanodJZLQTSOrypj3OjBzIN?=
 =?us-ascii?Q?siFgab8BV1waRyVkD94+LJEH1eytpsT7QOiqkDBG06ozhJW44XClvDCkAil5?=
 =?us-ascii?Q?YaF84xePRXH6r6zBAUCLaamQDY8q1cmN1VAt4xMjon4FbIRLwhcUwun4FwNP?=
 =?us-ascii?Q?PZKsnz4+qKJD2qM8AVPmzxOYcYkiHS/PSTPOrNbIZeHHrV+9tY3B+WKOIO/Y?=
 =?us-ascii?Q?NBPPx9kisovcIf27a1evpKbx4FfDsCat0bfRa3wWCMdxB4FnGZg0BgSW/diH?=
 =?us-ascii?Q?5ckTQhntOiA4U+iODHuXDsgThK84YSDOza+lNbQneDFC/MF1UVQ1mUcrcWa9?=
 =?us-ascii?Q?X1gzDNgCef0foymbsOs/d9FNNsn+Kr7la4vHODvt7gMgUyvlyOB6E37D4tEx?=
 =?us-ascii?Q?qPsd2Fa2doeclz1m09jVpW2TS/dmzseX3AAWi9c9mJ+JXV9f3PSZKmOUwB9n?=
 =?us-ascii?Q?YZ/QNbjqI4rBBAo754Cv0WIhfcal2M5PK3aQZKdhNprN/pkx7jHcmAF8y6sn?=
 =?us-ascii?Q?ti4h/wDF6Tof45JjZD+tPT4XreFMSMhd+dEE5kDJ7kLXjuc8CVpBnySoq86f?=
 =?us-ascii?Q?aj4Y+GCpuyYDVcnabTC5+5t3ShizoOA2RzyuJPc1fe4SeEzUB7LrzxsjdGTv?=
 =?us-ascii?Q?o5NY2MGYaw5XlZPor0fyE+b9szCJV/gCkQsSbyTN7cDgDF8nwRRtMBEK0QaC?=
 =?us-ascii?Q?zH10P+LwjaL7lqvxrPV0lfw1t1ShSYz9ayndPvOW8T1FcNRTIQYRbFnzPKEu?=
 =?us-ascii?Q?YUvszf3zUL4e6iyZiEKumFkNISqzxy9ucRPd/z1w17FJDVFIRwbXjynvduT9?=
 =?us-ascii?Q?9mv8UCkxkJx2EV/e78N7iSiShKfo9bSr3dnk8pDf73dSYmdcYyWlh//AV65C?=
 =?us-ascii?Q?j4qfBdmpHHZEF3SIBR+Kui//7imutPGk11fQP23jWYByUnueUKB5ZJTaGuKU?=
 =?us-ascii?Q?dPMZEHsqYWHUTldKwDi/KYZDF7XVZBznYWKedmkiMwiDASrOlr4g7TuSLFuP?=
 =?us-ascii?Q?KPsUY4rgHw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NYBUs607vLGyJmPqWrH7miGwnlarflb+Cf++EvbRxRXiZuwUHZpE157R2tHf+D9ANHXlEN1k0EyoSoQuvdCxG8HwwgcucNHQ0Rxhr9nLvejQ1LF7qpuFxkJs6OOLFnLO87cHPjxPI0R/taGd8QyvI3fUTxt4NGnZU9PWFNGhJsU1HJQQPIOnpZC49t548uoS6Z6/pEaogrfG4AFks2pHf45wexlTREE0ZqaFRKPMhDnV5dEDWR3eBbPN0zZf6JE0AYxUz1DTTdIGkpKnSjsP/9NT3ojh8LHwQua2WMcRAsqkGdti/2G6QVmBF68By5kwaZuyKioHMMTU30bKwtdk1IQvETNuK1YKh5Qql0Gd79/x892NYo0Uwxcwn1RtselLMagbOzmQs5B0LXuAKHeRAbvnnJd7vZqhhT8iXlOIT2kW45mA7v+6j8EesUuqrO/ett/SXUQOma+ZQlinkYXzPCPmaBh9sw/hx2bBcqK9tGEp7j122C7yDsfc6RoP9MqF+FBrwrN2Q/iS6DNQt/rQeOExXr9B8sZzB82MA0GacJjLu+iS5Sx4BObJruf/jtQdR4WCVk3jGGGb9R4txPX73rkmV2WkChmDsPSA/bYFxjE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1065f2f5-e60c-4c46-d8a0-08de546d9584
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:57.0950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZO1OfD26HvHELlqV94OhNJOU6dKdMGXh+6oTMbfdsdjUfDVCS0qZLy13DmaGX6YblXIiR28zqmfmbgngocMKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150153
X-Proofpoint-ORIG-GUID: ZT7MtsTp_x5ZeE_2nZOfYVMnDMI3Q_Kn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX7glfnVNnkfxC
 kbUrefOjTJyUo0PBRbHbnXIs1fOab/UxC5c44aTjoh+CdiZ0044niwdAFNukEDxJJy1w4SrZcy8
 5h1tv9UEd9FZxY4fhA8zuPq6Ac9XHMGQWyzEDh7DKMqs6DlNiCpiQdDdpW0K4QWi0fpYnY0Bk9U
 r1Kkxu3f8QGj579q+3ayAF1tdDgrL4nxyMqyXSjTGlmHY45yDaWJoaqqQ50bUbnPVbAsX+/t7f8
 sJsk/qgDGSiWNcYzCniK1/q3QYEKqBzqZIuqs4qJ6sdQNCGTxc55JV+q/qHdfITspGI9Pi7qg+c
 0JH9dDauhM9iAPzFgntxjuXgS8RrKouA9mpE70zgzOcx1U+QvW/pOPHDq9nAPNWUH9vQpL7Zhw+
 6eWip9I6jFUJlC5MmDqkV4HUaiphif0JlG9iode+wb/fvqrn2GPaTD55/ncIAOtVIN8xZEIN3eY
 gTSlL/toZZZeXjYD8TdXD8Nh2i6z+RQK0GRdegzk=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=69694235 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=BeRG0LNnq5H4T7Nsn9oA:9 cc=ntf awl=host:13654
X-Proofpoint-GUID: ZT7MtsTp_x5ZeE_2nZOfYVMnDMI3Q_Kn
X-Rspam-User: 
X-Stat-Signature: 6z857n7p5g7xd7oboezipjtphjfunx8y
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 520D580005
X-HE-Tag: 1768505919-193383
X-HE-Meta: U2FsdGVkX1/IztWiJXF3tln1L2kFLowS5GxLkRY77edQVTtIAdJeivHOR2W6OQq7NCBcDTuG41qIV06zdoyBzFhkX8b1ufoL7R+SvtvdjLZ5c3d/UK85BauR9L2KO6Xb+D8Im9y2noHNgSxy2Yg4H2ITTvULaFJUi/P4CdIl8W3h1C2xdE5+AShAJrokYJcIZb9awi7SXa3uBCDY7P4nLqIEcQKXW8mYUzhF4lyU+tnIiGXS+S+mFvadZam+2ucm1z7yue6ybwbL8mue55TnTwcSDU9LPFj2uWDhhgDSc313XC5xZHEcJE8Ymc8EtvEdyAZ1HO7tjPvsl+L7cdOf0Y8WNeu/N6zY35Vv91uTKGS5nfJZIICKMUJS7H9ys31bQcinlcMa+QolxobZaoF4xrbPJLKAsrObYqnNQf6y9G/NB5CMljQaZnSlpXJW6EI25me1w2rObq/6dIEmBEjdgkZHL+1pUNT9OcWQUtfzsojz9hCKl4IgWrB0WnXZ1g2l87v5+s2qCVoEiGgWZC+NQeTMxBI5+W0SapgUki8P70VKNJJe7cwLuKz4am7VpOzhr/66ilissspWx1inlZKz1xrAglZvP+djGy82WluE/Oua4+JSt7Iw7WJKvrVeV9JD+6PCqr7p5rYYrYY6uyE/dxEo/Jym+4NQS2ImsGKctkgaVcXA436/HKdAoYcqLLKRxJ4VMSkBbJHkjwaCWekp/nu1iu6fSoUldzbu99SEMDPC3Ny54k5lVXte4JokCerUiBkGDLGq7eSmPuDgAdByiMpIgHxSpj0YC/8h+gQTx71h6eQ7APsYy8+Wp3qxkToldbvMAVfKZfgwmGgIrfd8LjHd16bPupmAEXIuuPzrDsfSTA3wb5SRs5pBblXOxv2ZVk1hQl7y+AeP5LTnzRmCO5ddn3Dle51UgX8lTxs8kzUyWoB4s/tpHIEUPoA3zhEVJv9mb3ysEUujjiIyi+g
 XLJ8RwJc
 LuWEpvaGIeG8PDThesaGNq1TTAPBtFVam4LYUquzDaZEM102Petf1C7c7Pr0FWABGV6utuf/Qd/2Xhc2FEzq9jiRA2thUGi7HIM8ZjNg9IVo/0/E7gVep5V+9uSmN0Y3oT3Wk28Er5nffnvjrt+P3Ix7eSTUyb9Hqplf3nLoKhbX+K3kvcben2bEi6sEwNaVjXFbAbFuDDHmUcmFdAR2ldG3gsJLcqfUmEKVD6b6gt9oIIEGBppe/ozg67TmErlDhJ9orJcKUzbYCWIbbZzpYmDCKHimuVB+ufc/bmRUr2v/UpByJbSKVOQKBnnRZcHb8HZyuZUia180XLFAk8gLC0JuEy9Mb7/MxxdoERv1wOG0kRZ4kYUVnIzKYrZ1zS6eLLjjftKe5S0n5dTNVa6G2XGrLkli5RJOEDpWCqVILqmJ7r+Pw5aZVap714BY9b1xjPkwPP2Qg6f7od08AeMc4Bu4H8Q6qz4sHyAEoYShLL7Y6vAxaaIFjJQmZdeT3qKGfucrd0T/lEU9yRr66ugGskqlw7ey/QeA2cO10mz9V5u9Bt+kpTsIvzYbdXUqQkRitgqo0sowZaesOIqoopc+DDms5IEueOuZ2S2mxeK9KDU2qBhnWSb0TiPTqyrz5MZoEig+GpVTbOW4YEeKFQsai5fM7wURk5MdT9qoNTEOAQepN4ED4MNk8wUcaOiCPNVLUkeybGmaboihF7AtgrDPJ67uiWW/TBDJUJgaX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_wmb_replace() is called in three places with the same setup, move
the setup into the function itself.  The function needs to be relocated
as it calls mtree_range_walk().

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 60 ++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0748eb093c697..a66889658fdd4 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1893,26 +1893,6 @@ static inline void mas_topiary_replace(struct ma_state *mas,
 	mas_mat_destroy(mas, &subtrees);
 }
 
-/*
- * mas_wmb_replace() - Write memory barrier and replace
- * @mas: The maple state
- * @old_enode: The old maple encoded node that is being replaced.
- * @new_height: The new height of the tree as a result of the operation
- *
- * Updates gap as necessary.
- */
-static inline void mas_wmb_replace(struct ma_state *mas,
-		struct maple_enode *old_enode, unsigned char new_height)
-{
-	/* Insert the new data in the tree */
-	mas_topiary_replace(mas, old_enode, new_height);
-
-	if (mte_is_leaf(mas->node))
-		return;
-
-	mas_update_gap(mas);
-}
-
 /*
  * node_copy() - Copy from one node to another.
  *
@@ -2076,6 +2056,28 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 	return NULL;
 }
 
+/*
+ * mas_wmb_replace() - Write memory barrier and replace
+ * @mas: The maple state
+ * @cp: The maple copy node
+ *
+ * Updates gap as necessary.
+ */
+static inline void mas_wmb_replace(struct ma_state *mas, struct maple_copy *cp)
+{
+	struct maple_enode *old_enode;
+
+	old_enode = mas->node;
+	mas->node = cp->slot[0];
+	/* Insert the new data in the tree */
+	mas_topiary_replace(mas, old_enode, cp->height);
+	if (!mte_is_leaf(mas->node))
+		mas_update_gap(mas);
+
+	mtree_range_walk(mas);
+}
+
+
 /*
  * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
  * spanning store
@@ -3013,7 +3015,6 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct maple_copy cp;
 	struct ma_state *mas;
 	struct ma_state sib;
@@ -3081,10 +3082,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
 
-	old_enode = mas->node;
-	mas->node = cp.slot[0];
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
@@ -3402,7 +3400,6 @@ static inline void split_data(struct maple_copy *cp,
  */
 static void mas_wr_split(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct ma_state parent;
 	struct ma_state *mas;
 	struct maple_copy cp;
@@ -3423,10 +3420,7 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (split_ascend(&cp, wr_mas, &sib, &parent));
 
-	old_enode = mas->node;
-	mas->node = cp.slot[0];
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
@@ -3439,7 +3433,6 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
  */
 static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct ma_state parent;
 	struct ma_state *mas;
 	struct maple_copy cp;
@@ -3470,10 +3463,7 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
 
-	old_enode = mas->node;
-	mas->node = cp.slot[0];
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
-- 
2.47.3


