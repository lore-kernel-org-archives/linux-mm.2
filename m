Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D24FD65C40
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848EC6B008A; Wed, 17 Dec 2025 07:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6196B008C; Wed, 17 Dec 2025 07:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623036B0092; Wed, 17 Dec 2025 07:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB686B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13573BB82D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:36 +0000 (UTC)
X-FDA: 84228888912.17.1732B21
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A94E14000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W+xNnPzN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=na18t5sZ;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974452; a=rsa-sha256;
	cv=pass;
	b=t6c43sUbsk3m2/7GYzH5rMWgys2+88ukUjD86Fucps5IMRQnwd40cgEmTvPp3ai//pSm4K
	cQDxdWoe+mwGDJPo7sgpqaSI4p28Z3AfxeSV1GntgJdNxRHBRfFifKDOF1Hs8i2VZk9ntg
	S7/ly1MgECM2e37rifcw4mzL70N6Bd8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W+xNnPzN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=na18t5sZ;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzH6MIGQ4PvKLOXai/I5Rk/GxSJMqmynf3soODayto0=;
	b=ojeU1hX9Iy4AZOyio/lHD/3z8zkPagpPi1q1w7HM4MfhP6bx1Q8bhFVQ9KD/EUXr8T2siI
	rfCYw8pJt7IwOPzke+nHhv8RYIYojlBiKTM6qZ1YersursZkBUe+Ecg+m83H2Mm0VHijwP
	7VfdkznPF5lXL0GGjHIUiP9+lVjPMtQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6NOGX2005571;
	Wed, 17 Dec 2025 12:27:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vzH6MIGQ4PvKLOXai/I5Rk/GxSJMqmynf3soODayto0=; b=
	W+xNnPzNu8EfVJsWzwecoGQnwa1AvZEOn6fmoigzzY6GOr/bGGilqZGrBgmCI3Vo
	1RqIeh8kLaqxmijKmVs6lDeOd1ElYxAOKSAL9jn5AOpD7NCmoAf6aU7rXqJFHXHr
	aRM7SeEyhkUNM24sW4/ypkvrVftnVFSCD7zgpncfizOtu3opvqG2sxENvgF6J/ML
	LHAqYcc10t8dQdDZs26340BXYZ4BxkYThsUmrrtCzAtDp/9ZKehoYU1gRDDcQX+r
	B2H4Eh1tnikFiFk58mjslFD8WViiKQfPQ7qaDrZk8Tt18OgJZ3Sm0EPf2QzfEWRu
	uNl4HVUwLqDf1IRCj92ddA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xqxwv8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHBx2Iu006126;
	Wed, 17 Dec 2025 12:27:25 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012030.outbound.protection.outlook.com [52.101.48.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkegbs9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZDJMouKCKiFnO+kZmOHGAiZOEj3UU3lctYlCUE/iawkRiPqx93MPTSaSUuPeqj8Cy0UYmGCW5G4MYNZCaQ9zFvePxemH1Bj7tG4jEIqgrWJDt0BfrQS9BaTij5/i7i7YM4xu5kChaZVaWzzLULIoBtZA6xxDsuOXHldHEapT7scwgch4Lw0hIE0U1D40fUpcQSShZu1uVHJzHXAX/8qLA9dolLt8zxvUriUEXp9RbDRE4LvO5AplWY53Jw0ixa0MRvMS/x/R5vulKAM5AtOhFwG3LQ2PZnjpVfE42/le1k+Kr2Cz7dyWYD4NxFhkhMabwrJ2E2gEDIL5lJ0WTj7HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzH6MIGQ4PvKLOXai/I5Rk/GxSJMqmynf3soODayto0=;
 b=XO8TCv1dC0bqIooXuVznGB8yvE8XIOfNXNczV612GIgXG3+DI+KT43O1mzHToorhFdznUjWZKG1XpKTGCB9iusW6/ak55BVeT08fp8cQl2C6dZTy2oY1pGnxvceU9JLfFO+4gn9Lzxm2zNxQAtD3dYpVqnlnUAcYo6kyjUQNzwXOvOIZD78/P8Xf3kVz74X6OuKIL4qNxc7m2ISrWyLfZMrhk3u06PSDLnIAe7OyqBTI/+EdiVvVmx1D9ldKoTWOCRV6OuQdhTku1/sgwVc+iE1fseFiln7ihltiTSnFQi2PDjDWn5D1+7Wnu/i56tQGHlo2XQwDrqMfJvX46QWyGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzH6MIGQ4PvKLOXai/I5Rk/GxSJMqmynf3soODayto0=;
 b=na18t5sZvhkQoPqQWjs6D+ZcwgcBTs1CEs+TGXbuwD7yNt7iCJR5jmIUqDC4SZxqynzt3izxB/hpYvRT8X5aAmZ3avtn6q7cgPfBXth3jG2fF4DwmUNmEEUi94Kn0ohhRYH8HidxGJTxN83EFUyyAP5M9exAu3xPwvlY3krv0TU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF545856187.namprd10.prod.outlook.com (2603:10b6:f:fc00::c27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 12:27:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
Date: Wed, 17 Dec 2025 12:27:04 +0000
Message-ID: <b2b22973f761a97751487144f7726bb0cf868305.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0027.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::15)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF545856187:EE_
X-MS-Office365-Filtering-Correlation-Id: c660211b-4d01-4b36-244c-08de3d67a013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?clnhKvt59unOzDKdXIQxqMQqhz77CnGuLT/JWbG126OPlH+1xYgKkw/xpC0X?=
 =?us-ascii?Q?M8FPZN49+s9N4vudAoLCK3WaFZtOSSN2uDEhYi4ZjeioStTalrLRDvdeDxgB?=
 =?us-ascii?Q?W/K3tiMmtZegaxofM5UCjYmjdm8ay5jQWNK3Go7EzNf4tBBsSIWv5uQkyZb2?=
 =?us-ascii?Q?SJZcOHVFN7eN2g05qIslTR1X4zemebwjnlkISJJ+FMVRoNNqYUHGfiS+trBq?=
 =?us-ascii?Q?RRKG719aKVg7zdnZMiwR/AA0fhg677iU1uU65PiQQfK+VuHlxDLaKW1zP8UJ?=
 =?us-ascii?Q?HPxK1HyM1mFUVkoqceMH6panFt+DvEupckJvpz1Y88RiQyqj+tC6hPo0V9EF?=
 =?us-ascii?Q?stVNe6JkLaW6qzkd86DOU8my6fW074zC15KWu0ve+IVqMmrbAUfD8bFwSnUv?=
 =?us-ascii?Q?nviypdStrbzzVIPZ2iKCfe6avkl7zFd29fySghfI4EN466VbsNA+1yIKhjmQ?=
 =?us-ascii?Q?1vaTQwJzWbezXChcu9Ax66HZK2GGoPRKUbQD4JWJclsgwc0oul2kW1zLWsWj?=
 =?us-ascii?Q?4U8AE6GsZAtTq10tcnb0lIsFssJql5LFqt2jCxgBbs9CHKjO1xC6kOWtgPcG?=
 =?us-ascii?Q?xjYIYktr/LLiDQuqSBGdAm0h8DQHtEjeLOwYpsP9IAxvGCIJseJuoXvAmJ+/?=
 =?us-ascii?Q?nEu+/ozfbHJCc/jRldbLoVGBUHTFLzkCV+tuvhAQpzTTEl8cLjZu7nJv2f/8?=
 =?us-ascii?Q?kgo9DnVfWA1iu2PGnsItGu5OkX2zqJJOL7zyXjKzjm7EDLwXYqUfjl1H7CUF?=
 =?us-ascii?Q?znZn/f2p/016C8l5UVOifFe1/AuKh0PdKxSz2nmHlt/BNB1up1DEKC4hGIWF?=
 =?us-ascii?Q?hlJZPQrJeUgq1U92RWsVifOV0UvTb7GiiM3HiFoP202FCME8BlxZkEWFIfsT?=
 =?us-ascii?Q?bAqRx5jSPxai1OP2Qsyk8MeP/mF2WfGXp6N6gllUSOauI+1Z+QEu5PnSJ5aP?=
 =?us-ascii?Q?3tF1SDxb1jiMmASquCGSilIlQL66vKulhQQUoVAX4g3Tys+4BlkYQPACMTNN?=
 =?us-ascii?Q?uBCvB4zZM8QU8ycFKj09cTLIaNUwVUYWQWp/gMiojrdxWV47oSt/qyEiuv9I?=
 =?us-ascii?Q?GVcpYhZhoKZpKE7J1nknqeedbFJtufaV5F0QD4Dl3JZrDurSnQKQw6vtTHxk?=
 =?us-ascii?Q?sMR7SOe81NflVX0bzitvYWIlS7qKE8cwjoaAlFaPTHfiZSAo17JMufwnsCXx?=
 =?us-ascii?Q?Z+f09mR7B2R7Shg05ggRPP52TCM+jN8t004MzsyahoE/9XaK6cirTbNOA8jM?=
 =?us-ascii?Q?SESvJ/E+qmPIuyoqqNapkhvjX1Wtr98jMWQdHK01XNC4SpD+0ekeaO3TNnjN?=
 =?us-ascii?Q?8DSXZQJuUdEDn7g06Au1CxucpDGejvml1Tn5R4oN8j5qIiUkmhOqi/lNslAo?=
 =?us-ascii?Q?IlTwiHLh6/R73L4hx8HWM+dLVFm+DSVw41VYJ1DtTYWZB0vLhLdy/KSNH2L5?=
 =?us-ascii?Q?De5UUEI+EjWRmkIJZ4FlztkV+5zejiIS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Uxrps+44eza9H+cBVYPkqoJrJxcx95W2mFHKEXQmzILqHsgRwwNDY1zpTOQ?=
 =?us-ascii?Q?CViMFVYkACsDstrP9drNHG/AqoNEYqysND0MhBuUP/0PMu/QN4x2HWxvNVGB?=
 =?us-ascii?Q?tS4j4sGymvOAODxnOMJmlPrQ8pP9uiZPIG3LWpnu+3hEJ3gRe4CVEqtZZw+r?=
 =?us-ascii?Q?3QBz3ib6hAyq41tEn1WrpjDxENBUHT0de08Ko/wh9I5IbStRO7Czi4w1yPn+?=
 =?us-ascii?Q?C57BviD3vs8bbBOW/GTpRDNW/P5IIPs8Hyu46gsoCbQT8pg6tpb/K4+BqqQc?=
 =?us-ascii?Q?DEYJpy7PsxZ8K9ml0pkOYknf022dJBzTqpDM61HexmIPXBzGv2X+yGUKnjeb?=
 =?us-ascii?Q?3M+oalbXm1mEq8k3sevx9dKeZPqZFkBIrx1bd2l6THkPMbobye7m1r9wa0YS?=
 =?us-ascii?Q?fH2nydbvs55lfD/A7bZ1RgoZU2r4aSL9a4s6wjUCF9faOk2se5fmQE6phMO4?=
 =?us-ascii?Q?p6tknhF2xxzJP8rmbe/HleBfAKpHlqILEDhoiZC4s67m/ysGQM8OabqcDSz0?=
 =?us-ascii?Q?3qYdqQMOtd6ILqu4g5+fPnIncsrkFgdwjb4dUMlOy6Pmzpq5uBzvN5GS5h5V?=
 =?us-ascii?Q?RZWm8GMsannoIKu5UkiqARrHWrfizmeE6MW+DT2bmYwbs1h9IPU+HUUgqj2O?=
 =?us-ascii?Q?Mq2Ped9dVXhrfRvGQu2AiE0sjWWTVClAFWi0vN4OLBVzxNVbHgd71Kvl14mF?=
 =?us-ascii?Q?Tv4rbw3Aua+RDF3kflYxktgsggT2oQQu9QjdVxW37PxHfcn2bqmVyeXOvTpx?=
 =?us-ascii?Q?M1lxKbKthG6jspXMaUd5MY4PBTMFOR0jsUaxGMhIKbp8O5SdXxISR+F1HqSM?=
 =?us-ascii?Q?m7HAe5OKCPdpy3A4tCUWE/h2bndhVDmtF16Kk56nCK58DT9x5sKxN38ALnGs?=
 =?us-ascii?Q?OpjKrdMs3z3kUg81v4BqCvkNmssPHZ1xIC4hDI4b5trIuIa2dUb3Uab95T96?=
 =?us-ascii?Q?WAB+Np9u9sVy25BjsqsaxIW8S7noTqlu98fLHoq4YcFwa+1jpXxL72+QSBRO?=
 =?us-ascii?Q?hAGAio/aprdkaEeGIYXiGGgXOAzboDu/F0yEr9DtWYcD0lCGoEt/PS9FTvaq?=
 =?us-ascii?Q?WN2L/2Kql8WwkBpfr1pYiZ72LmhbchAgoWA48OFztteTRdrd7Y9XZszxObYR?=
 =?us-ascii?Q?jhB00C9WqSy2I5mxy+21GLWKnxHNIArjd9U7z96BHTUqNhNAPHH7H1ueKp+f?=
 =?us-ascii?Q?ObbxWS3qrIbrYr9NsAYZRTGHb7laViKweM+Z18dR9pxvZzHi4+Lld463aYKx?=
 =?us-ascii?Q?0XYWkiWmYBsD8xsVyCh0BW8udJNwteda9Dqh7uKtMe58LHxgXvSx5L/wmwbk?=
 =?us-ascii?Q?eDPvP+Fro3xSjsOQdlBby5MiMa29RVakkn65YltFqcIu9VhWNFNzRW5tA5dw?=
 =?us-ascii?Q?qL3rC/PHYdL92S0mM3zqgvX9WgUhUBTcMPIFdkHCwGlebYc3HxBJTm9A2gn9?=
 =?us-ascii?Q?5coY079ugpaU6oBCKv+hz4cQszpeyZsQhVIbYA6c74SgL+04XyGzqUVn/xbl?=
 =?us-ascii?Q?dr0DH9IZ4gmJes1MdjvVNHnzCx7KbaGRlFnsWgMwW+4QiSVrOKWx4aDXVIbV?=
 =?us-ascii?Q?0ajEi9b+ZhgYlBiwiiegEnCQo2MVGXqpIf502hDyk5hOPPKk1gG8o+lpPDm8?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iPHChL9eVDpuPmWF7YWADCFuEHgGILkDgh+z7nWywP2Hxqe8RKdad8gUasGIVtmghnyCNcf516t3dpeapthWh69TFigFuLAPMk244cZVi+1vXz1SKMWE4lZo8wsjpUxoTT8h7SCk20/dBK7lFH2J3yAgolqLq5CaHp14+rCKRqguC6ivQ5LYzbBb/a+re8SAr6xYv7axN/+HwgucS/BhEdDhlwF9gtMnzg5HzE1aOFqZBQ43/56RscNDmfU5KfUbnzL4xNAR12bXJbBFEyg7h3TaOfxg9mv5NKlLlxzW/45PUSp0Uq5OzLpVY5IEb4wHcBmUqNH+ic8yn/P6VeZqvuILnpKn9K1dcberm3XX55f0L6cxv7g34bWbqwCsS2Dl5qumB+BbcctUApnxzV91/p1nbNIQTYvqi4DKeIOu/QhI9gaPJfL+48+/yR+H9K2QFUsjCwv+n/cqhophXu1m3NSFcekRpQ/vuTWRfMGdhG3R5aVkb2lprKNu5IZpGaETV+XFd9jn/ZTmDg0FQhjWnhefPnpKzLn/lxfnLdxs7+LrOIhm9UsdySh3XG0fIjY3IryLiRFR+BA7XDRPJ41fRyCm14RcxtDIUViUJOt17eI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c660211b-4d01-4b36-244c-08de3d67a013
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:21.1171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcIg+6syCZDPkBO3AOq67oByd+LDEiW5dw3dbGX5JjQ0msjFtz++hxqfrx4X+2yk4Hck+JiFdcmerY72HJDYP53jmWxkehfNHO3Zjn/mmHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF545856187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=932 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfX3CiZwGRAwhjv
 b4NAsXDnDxcEHGV8S+6qQ4Ry7IA24FQqXpAL7StvzHVikD5tOZlFPOzsQeMEFoNCaXo+yq/AfFP
 +d6/bNH6dnx6tMe6j81H4eVXTYlK2MfuWCe7hwx5/3xL6rJRaYMy7JpaVNgsAGfLxexEo5HV9Tx
 KIUxo7nQQyqIlVzQFuULzdzFZuT7v2SrrLeYP5tujM4JtU5OqHjVfbaRsZmKiq0e2mWNUNR3XC6
 Z3whxu+kR9p06zKyqXY7KuefQ/3I+Ds4irI2CaFjZv3Udsy80RWEOiOsIIOsVNgQN7FkoAy8+HF
 ENXLSj3ZS0MhIo1tkdYtmMrvv0+k32sWq04qEKguEeD6vDkXUDCpNpOT97q9XCHAX/su8AAlfYF
 9TJAuBEimP5DAmvafvtQVcRhAWmP/7AoxlL4vCqCjCF89fz7chc=
X-Proofpoint-GUID: E5W82Id740oAD5xKP4vnyrVrkO2MMU3J
X-Proofpoint-ORIG-GUID: E5W82Id740oAD5xKP4vnyrVrkO2MMU3J
X-Authority-Analysis: v=2.4 cv=BYDVE7t2 c=1 sm=1 tr=0 ts=6942a1ae b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=FTnDSsWKxMfbHRKcqXUA:9 cc=ntf awl=host:12109
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A94E14000D
X-Rspamd-Server: rspam04
X-Stat-Signature: uqu7dqzr8kjqu7agmn1iaksm9pz3pnzt
X-HE-Tag: 1765974452-56137
X-HE-Meta: U2FsdGVkX18x6iWgEqhz9Oug2j+y0k2hEuZYLOmulMl60pvJTfXgNBPDhEvu68pnAN4F84iyIVCFoZazq1YGKJ+s84fh9ezzELKiGZIP3n4JbGe4nMrylAC/g/+OSKTXVgT3wRVXljoPlIHXJ2F4WK2nadLZaTv1+BZdvrMv0kG3NnTwoIE+Ki2xggbUdAi/JDSSAlZA+37SBQOBml0MbfsiDX4CcXZxXHndYu9dNXUxWdbZWVSUEI2e+aQBkbhV2N2WoaNw8C0Wfdujbsc/IC4nAsOckpzTrcIhXPF0NE8ZDbJPLsOZ3WbrkfBC8KTl6t7VOMGUDp7G9or4faVWfdHMtSkKkLMjzTU4Z6CXPObeyZXV9H2FGJ7Jacw8v37Qat+AHQOm/DixBOCER/WEVGjV6il5YJ+vA85SUDj6DJaRSSrREmibhXlIseY9VAtQTd8gQRC0U9/K+l2DeTZnUdOPZxE1FMZMbhyIrg2aH8SviRKEkCRX/L6R+cDl2ZJY+A9bQxrSc1T80eBhM68d+gYkSa7Xn5dG8aPvpYWJtbdnnkcudzrhTXfK/b5Lfv84uYhAjVDOZNw0KU93ySU61BD7S12iyWP84D+nG82mXqHaovjYtYnhxjViQZzTUeK9EjbiOT2ALr7fviRWn/21Irq4fQ4MXK8HfdQxrR1VRr5XOYr/xrYzbcmReUqcfq5sztpDEf/ytT9KL1SsoQ2lYWJgc7SPGHEF3NBPoUAJ592td5mnRTS4Z6K831Bi3XYnnwNbMO95kjXGUq4SXrLW6dqzOmbZYOGT2eVtss1tSD8vxFLfngi8gWwLmscw01bGi4reNfMFRztaAyeg8dfjejkMiLExQWovwZIzFqbFG9SPpVK47YgL/k9Witcvt5mG5VpJzGFa3x7wvS9CFXB+b5MKRvyXVrCdNKV0Kyycx4DcS4qtpSTn+fMKaTTdCynlQKbzz1IxaJWlPwqPjAU
 a37JCoYS
 gew72tgO5j9ioMNscvQkF56kZ59zDtIPw2vMMELcKuzo934AcOtGPo/LkVuZg8EczuX424ARoK3nWFc4zbr1vgOkwBb0KObcVDaC21Ic/ozRgsL++TI8th2O41o6/yaDPD/ZFTQLZFqC9c7o0qLlM8Y9IBncALTYehisXQ8dZrRQXF62mLZN7j8olmDcZXnbMFnLjzBclZJU9eLWGwVCWFn4gLhLg0ulM73f5QGRNphjolO7Fu2WZzE9HeL4OPCwLNahwhr85FeW5Yr/yk4YPY2LVG6BJ7qPkYH+nSKEundO2rNLtJIcwB4uJI/ob+BBWfPd2LT8IEjMIXSKMugleBE6Dj4TJTMGSM2kfwazIUrRc7kmz4TugUEiJz3RSQpWaQ0byQ9oWSTNszbldC3uMw8xnFNmdHh6D/YBv55sFWntk+zz+hKmlhEOFgbdsqKD5obFevXWjiWYWZr+lSzynZDZ6KbVkaxsyP9adIK82qn3x6ccnRawUVXqGo1m7VHDHEHZxj9euEJc9GTaMxZIVlzDSzaTk76Un2a33dVhCVhQYQ47PfTy+pn8LdquKDBf3/lMR3OoaUl7vVPxlaE9YpM8qxEm8VZjT7IA7czoTHrSPSYjAy8hmiF6vpg8AP//+hwKaUrCSFHl0b0AwP2skHiF7exUO65KznYksJmHlM1R7SrBT9V7Rgf6IEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the functions do
nothing. Simply exit early in these cases.

In the unlink_anon_vmas() case we can also remove a conditional that checks
whether vma->anon_vma is set.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 0e34c0a69fbc..9332d1cbc643 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -309,6 +309,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	struct anon_vma_chain *avc, *pavc;
 	struct anon_vma *root = NULL;
 
+	if (!src->anon_vma)
+		return 0;
+
 	check_anon_vma_clone(dst, src);
 
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
@@ -441,7 +444,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+	if (!vma->anon_vma)
+		return;
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
@@ -465,15 +469,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma) {
-		vma->anon_vma->num_active_vmas--;
 
-		/*
-		 * vma would still be needed after unlink, and anon_vma will be prepared
-		 * when handle fault.
-		 */
-		vma->anon_vma = NULL;
-	}
+	vma->anon_vma->num_active_vmas--;
+	/*
+	 * vma would still be needed after unlink, and anon_vma will be prepared
+	 * when handle fault.
+	 */
+	vma->anon_vma = NULL;
 	unlock_anon_vma_root(root);
 
 	/*
-- 
2.52.0


