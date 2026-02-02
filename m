Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 028BDE7DEF9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1316B00AE; Mon,  2 Feb 2026 10:40:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF1C6B00B9; Mon,  2 Feb 2026 10:40:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266236B00BD; Mon,  2 Feb 2026 10:40:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 127FA6B00AE
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:40:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1C9D160182
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:40:31 +0000 (UTC)
X-FDA: 84399928662.09.EABB114
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1A020160005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:40:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HkmSgWEQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QVi+HcKN;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770046828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73vzOLJsleu6JMaqC+MaDo26siJtscWhWEoOaJvbkCY=;
	b=0+0Yl1kdtsz3GnJeGG82FjezoOnLsLsdhUIRA+VlEvHNqM3cJbYLRGnKeYH8PWfn9+5rv5
	pzr5F3+nlKmL8jZj3q+snUXl2Bt70sizcbNCy6Z7z3+0pfb6ImwMXpnOJUv53T6y4EjlB1
	o3/IlH5+ed539MUjPqLf+BqYOxL4+6A=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HkmSgWEQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QVi+HcKN;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770046828; a=rsa-sha256;
	cv=pass;
	b=7PCwOs5+euH2fNY2eWxatx+2wnBd9Xfxpy4MYyK7r+V86T0Vs6JmW22402nhCCqbyi1SPO
	FUYvWYJIQOYkVX3vP6VJxPKsRmCvLBO3FJWcmeC3dlZ3d1WFocvCjYmkImdWlpIIlibjKr
	XumFW+1knJZY7YEzukFZ4jKU4rK4ojk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128uMis1113518;
	Mon, 2 Feb 2026 15:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=73vzOLJsleu6JMaqC+
	MaDo26siJtscWhWEoOaJvbkCY=; b=HkmSgWEQVGFeJPugn7rb1+K9JyUdGKUyyO
	Quan94l4ff0BZ1saei1bjHuf+yKw7BNv2tpzzt6MG3pXRdC2NxiWDObdlD6gKzO1
	J4eF34Zbc0yK0Z7dRmgSpbygP+6IaXQ7S35ZPaGfLiEeen0MCdQe8FOUky8dlqph
	R7kiCxG2B7g4jizZRtibpO8ASKjkoSfEnoEXhcGZ3CMaEJfiq6P2B1ktntXSwTkB
	CTeaBrOnf48au7smh75zB1rNbfF1waToSWAulhYaJ1WYqygqLGkH2I9LNqAziz6A
	mX/8U1BawiEAPF3hGeOg4nF03U+9hc/Am9yeKjoTslZCzJXJSVeg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1avj2ert-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 15:40:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612F53fq025884;
	Mon, 2 Feb 2026 15:40:13 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010021.outbound.protection.outlook.com [52.101.56.21])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c25775hv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 15:40:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0LWnDXQb3HkJ/JqYG2Q+gkRNPRPPOi8ULMu4haFTZY9dO7dLpLxMfZji38YLtCpX0JQfU6wiBgInKRpBlNLMck9YaaiH00Q0Lpz07nhRyKrZXFzUr9L3cR0w32bQHfZJNVJ/DadJU3H9i+YOJ3uhev55vwjV9Gi0NlQJ51qi8TwtCn46RiqT81oIFGjaW0svaruct1hCps6dAaZ4s+nfeu/EAHZfCHqYmuT5Ba0KRgI7XRPkDW1IZs6EGlJmmY3YKaAU6mXJS6C795z0NadS0Wt5Nqn0C40SmXz4aQcFJvVK1F6j1yGmpQFZSIKv3EIO86gKAUfLNpGozU0Znvubg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73vzOLJsleu6JMaqC+MaDo26siJtscWhWEoOaJvbkCY=;
 b=nvQXGYMfElqV/bG6c2O+qgv8ykqXxeQ6CLBLDtPgUEYLKktVD64UZU5EMVlf8UhVr5dTThpxlvLVF/QJfyotfHh4NlZL9qRRcTNX95yeyiMibwEEoXMzqtkobbO7MALvoHUHQ3/5mJ7gzj8wr2+u/EGIyfHfMF5JHwxSnif0lZTs/7stdowVk/dVDumLZ3Ppavmz3BNdPPxwwJ/VKZK9UgHz0ds35rMQvqy715uEizb4C/7QcKjEp5q7EQSaUDiorO2hAhDATKqEiVo/xDROtEfmlUA8op5v8T97tiL/Pe8m6Eu9BCy324+caPD1C0cUlahWct4ZDb3lcE3MiLGOEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73vzOLJsleu6JMaqC+MaDo26siJtscWhWEoOaJvbkCY=;
 b=QVi+HcKNl2bSFCJNRr/gRcNRrZQz+d+HRbGg3H6E18n59J4ktBp09cQH300iKx/xRWKq1TBTbuTg+nUxh2FciEGF1oIwsHl6cDUtkaGKPJNbr9UHgTIDXvZXRZpd9tqnD9dwCo/sxfVkEHHQ9bnVeiHyx+AZvufcnHWGbnLdes8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7588.namprd10.prod.outlook.com (2603:10b6:806:376::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 15:40:09 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 15:40:09 +0000
Date: Mon, 2 Feb 2026 10:40:06 -0500
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
        SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 00/30] maple_tree: Replace big node with maple copy
Message-ID: <2erbnreqpkyzezjn6ake744bw2avcnb6wjalvwh25desdw2lde@bahzqodw4xsy>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>, 
	SeongJae Park <sj@kernel.org>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
 <20260131122724.ce19aa2f8260530bd3dee102@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131122724.ce19aa2f8260530bd3dee102@linux-foundation.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::23) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7588:EE_
X-MS-Office365-Filtering-Correlation-Id: 59f8cbdd-c6ab-4302-a613-08de627158d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hEQRzcPgPGf4aMR3uKMekq20ZXUiEM75oRvR3lNvb+KzqB67K2yhXqxSh/S8?=
 =?us-ascii?Q?zEBQh1/N1yGR0jKovJ5f0drg8JACrW/k67ZK/t94kTWG/Y9BRXIL4soaOh+j?=
 =?us-ascii?Q?Kp2kzjAqXko76Du08jC2+KhD4wm1POHMs/jCpi2BScoroZzLXX2m9QSnCL0g?=
 =?us-ascii?Q?4zlHZsBnUTgSSAIOr0Dvr8GOB1imEAiYkFzt2t0sW1/MiuciyjiV4zqzoHJO?=
 =?us-ascii?Q?5AvG9aLrQEbSUsfqa4E7zMk2Hc7t1ZXMD+K0eLONb0ou2o6inqZJP19tbdPL?=
 =?us-ascii?Q?2UGEZXc1fTG2j5IDLTS9K7Y7HdsWAq6ARo3dV7nkz9i/BxCfnLXF2Og7+IdG?=
 =?us-ascii?Q?PIvie6sL9Y18KUQYi3YfYA+GOH7tLatoYKROuPcMG63rtEC3quiCvc6JTFRm?=
 =?us-ascii?Q?HFTs3nf+n8n25XDTlptnVN4gOC86d4D9k6GxzAsCrioaP032XLxJ6pBi4Gre?=
 =?us-ascii?Q?V07oCLdE5LesYr5X9oApZMSQrDysG5yTdvisYLtaxAa8xbVm7Pm440Wzmmdo?=
 =?us-ascii?Q?+z3ZlhaKfjIZozhnX2QV+Ry0TsMKi0OTddynzU4WrBDi0M6N2dMnI+sYfTPy?=
 =?us-ascii?Q?4kPBXTSVxjA3xgSYZJ3VSlcinYPsLwyBWruu2iXb2HLWqrD5O3XDjQXAKbYP?=
 =?us-ascii?Q?K1IHXBY2vFuorHkdL/0r/LHqeDGx2LjmzT5ENlnwOrSs1zYWhHHqUffNyrP7?=
 =?us-ascii?Q?6rzKO8DYWSm75K7N2WlzP/SmVIVY3mBeCi3l6ayYYDSuFRz9zepWpT7HBArw?=
 =?us-ascii?Q?HHoiwrA1n9TY0N/TdGO9wDjowxyJt0On68EYLWOog5HTlPXDJ8F6Y806Rnzl?=
 =?us-ascii?Q?2nxA7/FtwCrj34oz+52H51zapibCSmgUmu67oJqeorxi3vKhNajPCGl4pxzH?=
 =?us-ascii?Q?Qjl2FIAadH4UkGGbfvtBwhpVxujgEUV8EYZQ1gypKkX8GCmKaZz3OOgo13Yw?=
 =?us-ascii?Q?DaHmWz+W3vlROitS7Z1yvyOvB8Oq4TYRp3Apf6o6/uqFSa398g0cQBwZl3C9?=
 =?us-ascii?Q?gkZuXIWhmhbtm62iC3q0UC+hTpQACD7ywJze1/+xYJluaYY6U59sIXJ/tV3q?=
 =?us-ascii?Q?4ZQE1HLFDHzJretPJ+8ii39RJ9yWjn3Cpz7gr1PjB1ZkMTNrJnTprDnTHdiQ?=
 =?us-ascii?Q?4U2VU+lqp3aMrefL9Sv5sFOCCe6EffI7Xa7uIlKy6kCUGQK7/yzJ+SXIeHsh?=
 =?us-ascii?Q?8/6MToHHnB69PClTJ/E6OXIa0H9wASDaDFFwuyqclFBGoUCAG/scdqqzT3H2?=
 =?us-ascii?Q?cp/uhAiMj+s/sZ87V3FuTnpIvIg64jNVITLegWSdPanPU4aUGTwl4SR47NsC?=
 =?us-ascii?Q?50eHS5fFjtamFFV1iMnxwGJQOpUV096dN7ofV9ZSVE1auNYiVyLdfI9rnK9w?=
 =?us-ascii?Q?i5qoBdClUfCEypBONVazmp9dirh+5WXxyF9PJEzlVAX/0Kd4YYoJsFACfJd6?=
 =?us-ascii?Q?G2AkL2B/E2Tm5tFVm1Q61cFjU1bym4bAcBtIAu1AKzYMvOHcdJvY1SL3DTkp?=
 =?us-ascii?Q?nno0UzoFxJXSktWR59mSarN1GrdbKQjKzefLIDkSvL0e0wruS2YNJPrL1utJ?=
 =?us-ascii?Q?TuGLMj+UFI3XjZcwkoQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?viVa4WD7vqxJQCiQoeerEfkfkmX+6hO+InpgVgXEIMeFD1qenQXziyyUTQPo?=
 =?us-ascii?Q?0O767LvzWJf9ohbwRdTKcHo0FB3M3lLgtsGva7/L7bRlrBblBUB4l1JNNaA0?=
 =?us-ascii?Q?4ftd1KVQ6ybJZkawv9iT6BbqLv93QFkbdLsqEcoXEQGdLeZLoVfXq5dq6kMa?=
 =?us-ascii?Q?Meu2C2O0LlYV0QIIzs7C3Jlls2yjZXCHHsX+53gTooNfLjtKjx9xJdhRqrYx?=
 =?us-ascii?Q?K25FoHlJWod3Vs6Ht9TTgZZ5p8y/uUy5pq7Oqlxi9Ysu5n1djKToBdWsyyXQ?=
 =?us-ascii?Q?waNqvXKu5AoSjxwZvgZrfE916tbhUbRH2Vp9EST2XzVJWCt2Wgx8MpuluUvD?=
 =?us-ascii?Q?o7z0kCAPQKnyQQoAm6QlNdxbitFYuUJQQxf7hyhrLzbtOQLrsBbpVW4kB2Pv?=
 =?us-ascii?Q?CsDLZ1HlWmmB/G+PhDUx1QQJXcbZ88b+1KFnSgSOoOjxAVWVAiPjhIQgmVMw?=
 =?us-ascii?Q?jdYBx/is96TYv2w326Nu0smYAHq5hCbEn3YOUeZEYUYs6Q98uomU0GP/uQVJ?=
 =?us-ascii?Q?IByOqTraf0tIDDS1uI26XNB0UFwati99yBaFdsXMcM38maz7lHU/st7ppoLz?=
 =?us-ascii?Q?+1dbONgHMSJixW8oTFaPQP0J3ZI97k2/RV9iL1zR5n2YHPJYLO33K5qI8wv7?=
 =?us-ascii?Q?DFUV3QGGWwTaVdlDWy7u7XfhfGpyV+KgH/8auYHNkSBaxJc/wJUKCiddFNCh?=
 =?us-ascii?Q?8a1xrBOH5Ae3pAWhvBzi9O39m43lBdC5eTVwpS1a5Pg8Ag/MzCkEyFIWwfKD?=
 =?us-ascii?Q?AB409L7Aj9bknYwbvr/IObzbFOA/34sSycg7gnhh6ARDq3w83gwSPohEcGmp?=
 =?us-ascii?Q?D7C7yIRJy6mqlO2ER50/wgQJBwltmO2nGrztXTSBrZ8QbzE/5xjSq+c+YMAs?=
 =?us-ascii?Q?f375K4U/QWdM4FIpwdDAIZvk6pujAukWoTrjz2efSE1WiJBAPuawHaqbe3eh?=
 =?us-ascii?Q?b8TmdOy0LoXjcbZshFZwT30y9//NmikvKnznL2pZwweqi8nbVM4yYPDABBbi?=
 =?us-ascii?Q?sMXjug9upc6FJPL/HPl9avvkIfteuQt3IwY/O9rOoCQQxCLHTUTCz3HNSn2U?=
 =?us-ascii?Q?xZG8FdHIOqHAP0P9aV/bmKVieEAOH+NAsPr0PiUrZF/p35rOWF/7fzX8HG0V?=
 =?us-ascii?Q?cWDTmh9KU/Xxa/5k/ykaD8M/J95jKM+BgkeRA9OZ+nBYQs9i4oC9K3EaNeLi?=
 =?us-ascii?Q?Wa9o+wkOe++MmmOUDwxoLY9685vgrZQypHW7jqo2gPB7+PA4+v/S3xUIxJfa?=
 =?us-ascii?Q?zE9EKdgaUqky4hhtInBJ7ohcCufIYDBvq+js8eZMQGIqDXLRhNY7SA/+YNq4?=
 =?us-ascii?Q?ujhwiku9tCkHn+qbr92D8b1XMuGijrCj4uqqb0c5N38dXqTvBZmqNkkeA/T9?=
 =?us-ascii?Q?aYaeWciSj+9OU7eygliJ07nSOOYJiUE6u/BannURnsn/VMkws8m1YPTkcsgJ?=
 =?us-ascii?Q?JuYCNWTxjaGDrwUVBOW5CZ4gJQ4j4crKpIsFvEQmDMxiF3shmSqx7F6UvtJe?=
 =?us-ascii?Q?xfD80RNFNrMzHMhLc2lS25wGNuQKW1TSF24ffjZHAGfLBL0pkMnp/DLidG2r?=
 =?us-ascii?Q?yaBMwklyUrlV+w5pw7uKjTUZaBnJEP0IE6vduAkzDARo8BEs2VnYU5ROn6Ji?=
 =?us-ascii?Q?Y2IPg7jXGopuLbgNyAmopJaUlD6qgDkpADtUWl87jt1EYCybXcNAg11uTvSE?=
 =?us-ascii?Q?OKtBTtKLjr21h5GbZ3G7EryPHc6a1a+joQe3tN/2Qlh/heP54yFES+ruXkTR?=
 =?us-ascii?Q?rTCMZhRFug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T3rg2awaeg7ytdTBmkN5vRO+SDJgbYE4LvkAH8i3OqKlIpzHKoOqzPExIwE7XBz2MZPJLoTlAfEkMmApdw4FXBf2uon+Sw2vO51nSHKSw99jicu5uSQilQ7cbnby0uJn52AHIes4erzoDjdAjDhDrumB8RxJOWf9XN4LULPW1cw1KG47VhV9duN3s37+LtZ17vkaDuZALOSTxEcupH0N8lwLz/xsJg7MsfuHeRVdC/DOCBWpmWJgwhVpO/cm73MXNwV0ATGAo2qS81saxJGZjhkDjTcJUn4P09xX+d3fn7xrRSSfAmurovbP09yyQQdeYMy8859JCoPIOhCxnjiqHFmPndkhwJEFwdFnaAENvLhQIs2pVT9OwPy9Uq0ahU51+48xJn5QLhb+Za4ksclUps2I/12KZR/c6tYXzf/9Oe2ENInitGe+2h4UCClPUAsiThAZiqlBDLLMdxDGMfMJCdH3Sc5OSyKxaZrX1/9o47fqM7wPTkIvvYSdmcj39LmW4MWGazMaMwIrYaKxtxb/L0/eG8R0fwLfLMRsLptXl+DdxCMXE1vG+BHlwcytShA3yYQFUV0wL+fBV29QX68akCnjY3+TmboIbXJDlE5PSOc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f8cbdd-c6ab-4302-a613-08de627158d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 15:40:09.6101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mwXlROyiZ3IObzOQ7a0PIJ7ayGvz+UMDUzIfly6n657sS0vdJJYDgHx+X2xrRCKAJh6CLMF99dSrf0Cmjb9rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602020123
X-Authority-Analysis: v=2.4 cv=C5DkCAP+ c=1 sm=1 tr=0 ts=6980c55e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=hD44sUJq-gIKFM9VrwsA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDEyMyBTYWx0ZWRfXxDgvU70DDcHo
 5V4fyizOZX/HnRBHPyCJmxMPbQT8Q0A7+98h2JK9qhwkHs4Bd7TvPE3Kf4QKJBXRFNtGwMVR4um
 cYhrBFPasIk6jQlWIi6erMEZumVe4zfZvKViJJBJdHBcsKPAecyQ4U2OYkoV9z++Hv6j5e1Qk46
 zNOxVX8vaXWo5P2TW9SDdkC/JITGKqCWVUqXaqsGYlSipHh5DFNTAjadW5u8AYHBLXmRKwZRfNS
 S+Mng0FWMElwwwjUxfZvV8RawL4zJbx84DGLeq8FXVGbt7sy04/6m7w2eJOE5Zhl+jXtOkNm9Sj
 vnTNvrcitGPjmCMuvVatfXDnQW3h4yA9Bk9nftRP+R+jmUie4pvurAkzH9IwHVhvZS9Epsw7MAd
 93vW71ZEIXabXgtxWT3ZGBopvqeFRyKOnycNMjMI3m2NfRHPBErJZMei5r4q/WoSdyNdotRkJqK
 m+kxBdJlZcpPWXsFGOIY3+UhEjZ8tRuUPK+FqwKw=
X-Proofpoint-GUID: otYaUUSOaJoFDygJHxls8N1KgBaG-vx8
X-Proofpoint-ORIG-GUID: otYaUUSOaJoFDygJHxls8N1KgBaG-vx8
X-Stat-Signature: jnffmpry6df7o3nurd1tihh9iboahkao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A020160005
X-HE-Tag: 1770046827-788892
X-HE-Meta: U2FsdGVkX1+a7aifNiLims3yb9T/j3Dzu3PoVUs4J62yew/kh4oVPKpvKVLwi6LZMJmX+iUdpgEEt3exiNBy/NylHMC6oS3DvQWBHg4TvDiUmjX9M5CRwd/MKPlqFVXfEGNe6AYOqMrg4MU6DNSTxnFApW+Lc6/Cis4hF9IkkzojBsFLdhUESkwoLgtqRAIXqp0lBQul/i23pVuMV8PHDveEyd+DBiwlcvw+YdEZ5KdojL+kzomcDb+XaVMAG8cs6NMBdcAmMksDyaMGiHs4KyTYgEdDboFBzDgIJwK0EatHl314j4LjTYGprJVthLFt4GfC92vb0mIxhKTXTLVWaei55AoVaQ8IZJZjICwiNCTWpaEAlphhD4w9cPDnFfaetx/BHnCAkqIA7Q0esyeMSfqqVv0FDYkPSmOOPl7J+NAQXNW7BbEFs1JckpZwwv65bzlCcfTWeLVkmM0pIKLCThO9oOrje/aXdjUWOIdH8q8j+bRmhCNahrYay/81sfswy0gmKpZ/dadmBhj4RL0diaAywQ4UczDx1jQvdXUn9MjWZzHl7Vl3oCGtAKI17zJ/nZ7u8ODxIk6r7y2LlKh7sFnbSWnXs2YtZ1aFC9/cUjUlAAak6VYARROoh/EVbNJ5fAOllu7UbbQxHUa8VCOPVh5K0nV3ZyMBGxRofwwGuko39GOy1WQlISQrJGSJso2lpRAhxb6irUzZ0nQUJOoSCballTLUzsAMWX1piNoI43BSfPQX86qj4GNv0vyTbr69O6MkEpcLpARbVmkUwnOdCLOHC74qSA+C6QX7s4B4k9LlpGN4WyTVlH7hNwLBqckh6/XzYYxUlX/lAhOG9LJiOl9Hgs0fqDnvFApjTUsFUObqwhdBQU574/EwEDfu1T29K0dgkw7pvgpnOn5I1lD6RPVfnd0Ki4sBW73gQLamEZxpu0w+MU5sxb8LYQNR5z/X/FRoTOizuei5ciPMsg8
 5TjED36L
 0TfiVevlunZan/f4XgdtAkiT0GvmB1L+HZTv6PkXMAj8ldUBLO2EmbE8MTRb/nc0lsmGgLUDV2qhMWwGDITajog7QaTqRnWsa5CmcLTgXAgt7obXgiKgUdy/8p/AhEcmaFuBY5Dm5GtBdxEjX7JLFYfalPbN7BS+Gx7DmNXhVXMwJQmth4lic2qe2mLqtGtUpGEBHqOeBCkMSX1cAIUcma2Qxy1d9+hXOP3GWCqBVb9OtDJOQyvWZf6WBcdAQW+tNlJ9ks3txvOSuDxYcaSvv9EtvrlcBOQbiaGfbrCam4l+oF28ffxKb5+FVj4UqvMSnMMlM7Xk5o016xpoIpzrt5s2rsp8tq3zAV3vpm5EDm56eMsiqEaeYNQI1Ezn9cS7rqAa1nrVS1aq0az/AA4sL4pjfg+WP/F4wmoOgfMBUrRxYbGuBwcbwi/s5dveD4bsx292jsVWk8zgU8MOGWv2dZgUZL+Mv3zZhTdcQdKduwtAkDk+eDZjuuq45z1Fl76Jhbn30aHGHAO653Brx0JcjC5ghv4ovst9NLQg80XLmRTV4OiRq4nyX2fDESTra810YyLSWFjmVDO1dIUP3Txh7ZUZABOEPuUudQ9ss4CyMKdnUxA2qRR4UYrxM+vB+fXAbIRJdnf7r3V51n+BAKGAmrULpEZZng+O/Lq4xhG5jdOT46kD6XC15ROGJOTfoO4kuNAqHR92fijwCr312cd1oC5sOVpLNs4hh/ZGfr3pNfc41GkazedQGJMBRyNZay2eUQvKA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andrew Morton <akpm@linux-foundation.org> [260131 15:27]:
> On Fri, 30 Jan 2026 15:59:05 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > The big node struct was created for simplicity of splitting,
> > rebalancing, and spanning store operations by using a copy buffer to
> > create the data necessary prior to breaking it up into 256B nodes.
> > Certain operations were rather tricky due to the restriction of keeping
> > NULL entries together and never at the end of a node (except the
> > right-most node).
> > 
> 
> Updated, thanks.
> 
> What are your thoughts on adding this to 6.19?  I'd expect to move it
> into mm-stable Feb 17ish.

I think the chance of making 6.19 has passed.

Can we please target getting this into testing in linux-next as soon as
6.19 ships?

The priority for me is to ensure this is rock-solid prior to release.
My concerns are corner cases and arch specific issues, which I can only
do so much to mitigate on my own.  My hope is that linux-next exposure
will help with those concerns.

So, at this point, I think the right call is delaying until after next
Sunday.

> 
> > Changes since v2:
> >  - Whitespace fix in rebalance_data()
> >  - Added ma_init_slot() for cleaner casting during RCU_INIT_POINTER().
> >    Thanks test robot & SK [1]
> >  - Fixed off-by-one in rebalance_data() which caused node overuse,
> >    reported by linux-next. Thanks Mark [2]
> >  - Added new patch to reproducer to test cases in userspace testing for
> >    the rebalance_data() off-by-one
> 
> Below is how v3 altered mm.git:

This looks correct.  I did check my git diff here between my two
branches and it is identical to what you sent out.

...

> +	 *
> +	 * The bugs tree:
> +	 * root    4      Label     R
> +	 *        /\               /\
> +	 *       9   X            F
> +	 *      /\   /\          /
> +	 *     9   X            E
> +	 *    /\   /\          /\
> +	 *   4  8             C  D
> +	 *  /\               /\
> +	 * 6  9             A  B
> +	 * ^ becomes 5 with the write.
> +	 *

I especially like the ASCII art in the test, totally worth the wait.

Thanks,
Liam

