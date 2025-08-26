Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C362CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A839C6B0159; Tue, 26 Aug 2025 11:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B306B015C; Tue, 26 Aug 2025 11:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9496A6B015D; Tue, 26 Aug 2025 11:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 780356B0159
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:21:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A2FC1DAE44
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:21:34 +0000 (UTC)
X-FDA: 83819272908.07.1F90A06
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92A29180011
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:21:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e7L6AszH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QIadMxW4;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756221690; a=rsa-sha256;
	cv=pass;
	b=4RHl0EPZhUa1LkrlWENwKBx/8PBEr1LGzcdzFQRK2qQ01icOx/6wXFWwQzFunB05JdnQY3
	ZLPvVieih6a6FmtNX2Av8zxE/frjszbH+DOqVBhgxOsssKWmbRIjZ0GBJ9/jDSxg+jlKfA
	jKM+uo/s6ubGsdRv5N7YClywEVI7KnU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e7L6AszH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QIadMxW4;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756221690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noR2N2HTaRNhLuHC0zV1O5crDMRQnMooJAoEo8gRSJo=;
	b=pGZ1buIumYW0FWyaoivRD0jllnNjOohAyRIO9bjgnygJo9d4d6yBnUL9Qn+y+t75zsHg3I
	oYbzcaBeelXEByXiMz5iDTRVqbK58dxU6AQZE+K54z/3DnD1LIDzBt9NFcnDq8uM2E56xE
	33nSiMgg1HMdnKUpmms9YIF0s6gMAAY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QFC9k6012230;
	Tue, 26 Aug 2025 15:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=noR2N2HTaRNhLuHC0z
	V1O5crDMRQnMooJAoEo8gRSJo=; b=e7L6AszHhV2T8307X06r/OSXsnd0TQkU4i
	WSjoPZSJS0PpImtId9YZgTZB1cghuV23XKHN6R5t9vkyjyGXqFajoFHqBOdj25tS
	Tw/F2srSbiD8Dgd71L2ZDSpBWy7apkI+p8ukrCtGSPj2h0tmHXzIq/h+yLLc7HDm
	xUxk+VmV7IKVkkAyz9epjUWYLfo6qk+2U9y0rvsgG8RyXPAFaYueKRrnFY6ipFjC
	njE60BPT2rCYm8raxryTCihMl3yLcy1oAJ6vLZCFzTgw33s6OiegO/UDJ3CIP/Ft
	CEGQBp7fKEFGYI2R+3aFbF1p7xH2PvtJkCADj4avAp1B+lWE24Wg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jamnrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 15:21:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57QFLJEQ018982;
	Tue, 26 Aug 2025 15:21:20 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2051.outbound.protection.outlook.com [40.107.100.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439r0nb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 15:21:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wr/2/iF911v2Dc1jHY7tsTq84dWaraYjGogxJFaSHoiGJ2Mb0raC6DaUSkE2pc6WrWI9ss6XBXdh2QDrItSCvdrDwaxsD0DXaaWo9fxYX8QMH4OkydDVJIAlbUhre+plGF2zq1plRDpkoBu0oGzaP/GxV0h0tBNc2xZO5ifTDR7rchl4VMW2PfU2fqcjnwn+dGi95sKl0PhZ0C6Ef4kCvt2spI2PoYJ9HQHoZlKURbeSo0TvtXIOItiVyc4qpF7ZsdTmOreQyMcBLHSmQja8LApdpJ3kEJLRkIwTIF9a+wqjX87QVnz321c4tq8ACsayBuK8rWq6z3rbhevJJY6m0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noR2N2HTaRNhLuHC0zV1O5crDMRQnMooJAoEo8gRSJo=;
 b=gucss2yuOrjZkDNDZWvRJTYYItqcVFjGYbag6vJH6wgoca9xs/zjfp2wJxbzpeDSsCRcsKpmTkvm1yNO1Mg/r38t7LyZ57KqctZs13p8/r8rVGPASg5eHTRnSqzNXHqzST6q9JHJFs67xRyuAYgcxWEqLD/sIkrIKhRVcpYOumPo9r/6v6DwyGl1/w1N9pUI/Ijxo5pk+E3eQ3WbGpzwDdtmBZdmHUuviHenJtuLh1VaWKn654EfSl/9BONiEWJyMoTGP1PcQPIo3Ayuq4CfVT8+Urtm3kMj7kjb9CI71cEdc617F9+dEtEoDDseGarVhrak+gnmD7gieZHgsTwNkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noR2N2HTaRNhLuHC0zV1O5crDMRQnMooJAoEo8gRSJo=;
 b=QIadMxW415Es6aZLpG46+Rm43DCDuI8j9Hz+A6L2qBI4gzcVvbjRAgMFsVfaJspKk+0JjdJnh1V5GkXrBirbP9h24oHBRG+QCkXWSEqqBeTjIcqbUkOC62Zp4D3eIQER1Ft8lCvty3MlOLrEYb5xfDdjNeiLJndIEzQcEgLomOQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB5548.namprd10.prod.outlook.com (2603:10b6:510:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Tue, 26 Aug
 2025 15:21:17 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 15:21:17 +0000
Date: Tue, 26 Aug 2025 11:21:13 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: zhongjinji <zhongjinji@honor.com>, mhocko@suse.com, rientjes@google.com,
        shakeel.butt@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, liulu.liu@honor.com,
        feng.han@honor.com
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite order
Message-ID: <ip7al6pv3nm54raaptrxq3v4t7cpilqgppkezowzn2sfbjax65@qt72zuotrwnw>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, zhongjinji <zhongjinji@honor.com>, mhocko@suse.com, 
	rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	liulu.liu@honor.com, feng.han@honor.com
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-3-zhongjinji@honor.com>
 <002da86b-4be7-41a1-bb14-0853297c2828@lucifer.local>
 <nwh7gegmvoisbxlsfwslobpbqku376uxdj2z32owkbftvozt3x@4dfet73fh2yy>
 <bcabe7cb-d09c-4789-ae39-407b2e0653da@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcabe7cb-d09c-4789-ae39-407b2e0653da@lucifer.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBP288CA0028.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB5548:EE_
X-MS-Office365-Filtering-Correlation-Id: e7ce8972-a359-4d6b-4275-08dde4b433a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0f1B4+sv5GYN12RoVXekgipqoKyTiSl5n/mxDQ83XdIuUwSKicKGzYRj6w8i?=
 =?us-ascii?Q?TCv9HCtXJxryFm91plY/svpl4nD4qjEOkT9MiKCfN5/5XaBgOzIHiCgV744e?=
 =?us-ascii?Q?bUTjaIuzUPtiaMi6+pktEtR3dbovsTcVKH9++fapO+Ivh/DXd8mgkGyclRaS?=
 =?us-ascii?Q?Z+oc4XobWrpFVOacAL4iM5OwZrKpbnDEB40lDkUm21Mu0vh/yV4CheTto/pI?=
 =?us-ascii?Q?TpXxAYqPjTEj27JwTRFr57VedbcgK14AIEwGaVXZBEW36XsnkUoomidbUvSO?=
 =?us-ascii?Q?XrQQUmBnHntUa0TTnOaf9C+1IHqCHmLFp+qKNwPYx9gvGnt/VvGMhEUXIaoh?=
 =?us-ascii?Q?Pf77KzUdDNIRViGhbnJVKGvJEs1STXOtHTcuWNIh/igw19il2kSas4UGmb2L?=
 =?us-ascii?Q?4IdU6SBHk4FphiQSoHZVBj4PWm51juQSLm6Un3KQfU5A/TXV/n7eGJ9gfMM3?=
 =?us-ascii?Q?3tgKCa1it/xtrsFaFJ8ooOPAY/MsSn1nUOYd0sEqumpvRTL9Q38QJRACSVp1?=
 =?us-ascii?Q?VJVESbqM+GfxVBIxLq7Pdlo7L3xltizZ0hnTCKd96hCcjjttWxEhdbDIXjhW?=
 =?us-ascii?Q?NxNuMtMDUVuj5lahteBxsG5Pwz0o4I2N673eenU0Y9h6ygvJ/pC6BYzzDmWb?=
 =?us-ascii?Q?PRu24h6FZy4yyzN82VwzweL0Pb0YI8JFScZJNrqAzH4GyScUgM4h8Ls8F/ZC?=
 =?us-ascii?Q?bCjSTAMmpkzoUoQQnyzIadu3SAf4w3khFgcqZDrpfbNRyVpVXEE4ucXqh0yz?=
 =?us-ascii?Q?barGE1UWs81Ee2jd/sU5fOkYrJtERvkCSGE7zA12SwG7ZxnblcjtRPUNM8Qm?=
 =?us-ascii?Q?PHiOtoyQeWwRy9iBSBduW1G37ia0TMS7uaJq9l4CxgIU0/d9uICHcBT3cF07?=
 =?us-ascii?Q?k8kanmh9txUzltb1ZVke3uCGKST15BpuisTE44k1KdPRSYtsXKIx1rkCUBcV?=
 =?us-ascii?Q?DVwsKyZObbCgTJTHklp8ZNB9I5p77UttRPMnIteWscekijesLAcALnN5jjBV?=
 =?us-ascii?Q?ctGnO4LmtuJrFDfuINtSfKQBwfi2hiRh5IUr1eUSueTTHvSzmmMKZ27fiS3a?=
 =?us-ascii?Q?Bg9z0CMG2iqQaRsVbV19MQyVjI8sTkieTj8GqYq9BLlKrkUz+q2Z+ufIH/fJ?=
 =?us-ascii?Q?ppy5u9Wmq/Nf2U3sAL5yEVWZ+ZLLteMnatbO0ojP2uKkdMjc7H72w8likdlH?=
 =?us-ascii?Q?onLbf+DAByUVFuHflS/kewteev0sOtaf1Y6juafoUmQV79WnqtIog+LoZauM?=
 =?us-ascii?Q?1/8MBhSrvUYQwpq+BF3/UmFfImHL5PoNlOImk9COnz37+8ZLoSChrwE6BvBw?=
 =?us-ascii?Q?VK8tlbCsjqDDsiyaTvEG4+MWnHyg1+xD8y9neCGhIzTFwvYhUgnu4N8y1DX4?=
 =?us-ascii?Q?8M1gLlZWhPhndDMoSFx+BNgV0s2L3v2g0hIHbEJkCS708ieZQ6KtS9oi11Iq?=
 =?us-ascii?Q?SPrYHz9wESY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7s1ogdvQA8QE6d8/G9obP6RUyUaB9J6NuVXdrumbYoZTbRcIOHyPwNwDTZfq?=
 =?us-ascii?Q?0ixHSsm4RrJME6PGZ+O74JmZOnkN4aMLqvT9o54BhqZLNNP0c4EKhEOlF/K6?=
 =?us-ascii?Q?h4aBFbgAQeZS5yjuepa16Mu2My6cVXx7mOi/gXM6/+S22R9UQ+d2WQKrF5Pw?=
 =?us-ascii?Q?jeo2kRX72U2OHLZwvRIlKsEDSoP5RGlzykXSR/hVhxQTACaLrIHlYlTI+jYy?=
 =?us-ascii?Q?dEpvwb5Dc2ex3NYl0OZp+urZj9XShWtKM7+4YuATklgZnpvsel9VMxYuBg+T?=
 =?us-ascii?Q?jHDCsbs89PN78Q6wCzM6Zbw2CTw6aTggHJjIljFuXW2E0VY6if9DFFVHvPNl?=
 =?us-ascii?Q?gb2k4PUR0QOFcBtfa76b4D8d/25y5r9yz7h+6p9hbG1fSC2gMsUJmDZ9YqRj?=
 =?us-ascii?Q?5wKe09oO/jNIb+CUP9NtuF/eoScdDP07+WBMXcSx1fgGmiXWmVzId3Tq3OcR?=
 =?us-ascii?Q?gqR0thzXbQ5o8OhOz93hAcuapTCVHuwaaQVllDHk594o+L8kRMJYx1vBZFng?=
 =?us-ascii?Q?/lCRDcitcRXm4IMqD+ldP2EJdhIAqFqIS66A4FIE5LI41z6BU44/UX7HJp2I?=
 =?us-ascii?Q?Afvv48RAMqov/NPfT3+rF5wskmxt84nGhrkQRrVGfnBkuTgbaav7USomtrs5?=
 =?us-ascii?Q?U7uaCCpkmMFqpvB8lPy3mhJKoGWjs/RwtfbJtDYcCJ+tEmSwYWa0oEIn2HNR?=
 =?us-ascii?Q?l12oyGzwkt4KTs3MIpWQakFD5XqRjJlVhcGHXzhISgKVpaEqfnQQVm9a6UXv?=
 =?us-ascii?Q?RRNvAhr/iANgQk6Z0p4zkuT5nFrLihXPAfNEDuS7F3R0NIp+oROoNN+p0s++?=
 =?us-ascii?Q?Wv7SrUWPWW4Y5LWYVpnY1azOQqNFKmy7QNwySq1GVIdhSdLUnSbQ5BehH+St?=
 =?us-ascii?Q?SeXyWaNNkLzbtAHwFHlS39esnb32IbXjinxuaFSbq0hgm9CU8MREldLgq5uZ?=
 =?us-ascii?Q?PV+f1PnNdGfmEk/t+YxyDD38P20qvBdpVD8uOqHQlyfhwz/8L9ubeHcpXV0u?=
 =?us-ascii?Q?oMJP8NvBm38UK/nwEietJpRX0fpqhyiOf1itNQaBHvl0cBTMs9CiGW+HvP5g?=
 =?us-ascii?Q?e4NVCuASCTce3ax3y3zwPmjnqSjl4q0euMLtMz3q+GJxXGeWQP6gWrOp0ySX?=
 =?us-ascii?Q?fNzhsnpyfHtWTOzrF/ToyPyek4XhTJsD+snrz00An6qee3l3AQ6GUtS0O8TD?=
 =?us-ascii?Q?K0vGlCLyZKnYrKbwphyDTw+m0d+XM3QWKw+lnXomDPnmGs4ZUG+/GGDy4J1R?=
 =?us-ascii?Q?wHNG1EBy1Bwar6pxxgiLDDycAXpa+ecqIQtrG0r7ZMcJigImZt1yV+IwIeNb?=
 =?us-ascii?Q?UWNnnhdCAxLAr5aR+MXWvkOSEt3vr0PjkOMNor6DrIuQe7ppoBqnLrOrEO23?=
 =?us-ascii?Q?teQ1WELV3HPEO/uvOnzq2RACVVP8vcdeBrSKWSPWSfh9p2A8+a+jg0ajxtgs?=
 =?us-ascii?Q?c30yz2kHwngtwYhMHSnKja1MtWkL4Pjwkt0nY5O7O1AxzghcTc/k+DeLSJ8M?=
 =?us-ascii?Q?uovQH1n2MaS0sbopv5DB5/gWs/0+PjB29wKtCxxjMzzLd2Tjll6Xv+uOubfw?=
 =?us-ascii?Q?ZtSTpxuuOawA5mALNz4Mo+zudZ3HQ4yHVfpYGTtO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b6Zg4XHtXG/b0CHNcdAQl+tIZW5JG26JKaccVDMGrHrhqLDkgir2Ty80fP72sJlsnFohVxvhYkfgMpTHTarYCFOT8rLFjXq+fCglWp9K9SvHCGr0UYzWohNtZQuVQhWT0vYvLXd8yy1PtPvGZY1iwLOp4Nr7cINJkR7opWIcl+WW2N3FtAhlKhkVNwXwvPoLghfJ8bm5jLfEjK3Vju2xNBJBtTsllEkzfU5UyqrXGCvNwh/W/gbYXA7wiS7oMtUTLvkTf1Bc4DmsLM02B8WcRquiTNrCU6aSXtsz8S9cYBDEXR6P79i1Gk4wT2buLEzsBcPpGNBGBwm48wB9NWc9rjelMJxfYQEGfJt4N7Z2wHEf8HkiTOv2v3/7iZbgf19uoUf/naS7Nrn+i/DstefRZoF9z7pP5JP6Sn5td4tL2rdwwnpDa5mDqnWZy/2dnkplNICz7PecTzTEQAbJqW+7qsG7RN5yEl2f4ugfwfJopDQ1ckBYUy1CXVm9YP/2rXtk0VjDYuOHpYa0PpC/+6dSMJNVeHkgrcX6rL5kvwPKemA7T4ERXqaH0yZeGoZ4lAwPKvJnM7lmzBaCsUGvBPuI+eyv0EpBrFk97IPAEoYKMI0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ce8972-a359-4d6b-4275-08dde4b433a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 15:21:16.9805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VsHx3qLTrArhuFpEzizJHjibzMIEngInAU2DghsWagxu3WWcYZd4WyeN7GXYCl20aedpfo/djUIoIK70Y8u9fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260135
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfXwF1uoh1nggjU
 AAFLY+IpScrmXqeK1b5WiUfFSXczt5L2ClWV4KQIdeD+y6muU6LUip4IuH4xobFN5O8P0jw9Xko
 cCH43TFvmc872wqFzLj9A/QdpSg8ILJLZLwHv7Mz6oZVjuUj3nt/k6cqpcQMNcAmLMVVExvlNJc
 JYmkxR3t7oQjNrV7Lp88wG23RUIJdA15Hq/XUMJUFrrlhqb5W/jLAHHqmnUHm5IGYeevw5KRUKA
 A0L6+fP8YP2vuRh0/eJKTrMBPl+jw+cFacES4E07vd4hzQOeI3OtoaNMoR87U0eWtIWwTR4ilQf
 GuRR+oHqyXDf2kbK8X8B4hb4aa51TG3z57Ee3mL5s890na8UhWZ96P2ZFdu9/RP3cae/uzyObXx
 HazvXFFr
X-Proofpoint-GUID: QqVRg2VvewO5tpmaOjby8lf01_Fi1cVK
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68add0f1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=d-yxRX6Nw5tM2VZN2jgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: QqVRg2VvewO5tpmaOjby8lf01_Fi1cVK
X-Rspamd-Queue-Id: 92A29180011
X-Stat-Signature: cdi9nioh555oag35kghpjwipczpsfsz7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756221690-474858
X-HE-Meta: U2FsdGVkX1+jGcA3kVhatJTLZTZb1IakjS/gs3KBAmvd+/aeoG7oFO9aVCDMm6XxVopEnFVcyMviy5CMl6u13u3RGz6vbXiI3iFDiuDXuPjlF5HutC0LTjq3qn2m571uhHtvG6ujkTFWBxn7ZURvSQXrHvm81F8bVRKkUMUOhma88CPOgEFEoteEQ2ux24Hs7vL67ur8AYVDCx5WKya9zPFU42ZFuWy3IrNWqh3lW5DJkDjmhb2jUzCpuW2lqOL/JaOoSA2CQXEaPcaj7FA9ekhIFY6GyagUnuV3a6kjWOcBLhsCSbpwClRipE/aUPciRm5mMDID7BDYclainFLK8qJahB9ELGYXFGv8IcCy5y1XlX3CR2so6xrrNyh9f1180auZfteWAUbqU/Z98dKcQkOpT1OHyT2+wmzgcTIsfJlMcFoErQeWfCiMwTipk0UIPWgo/tKYtaCeRsg1UunNQs3WGbvOEJjK2kaC+ghKpAy15pxEBQuRa/qXUqXMa1IffjfrvDQCBN3Tmx1ky9arN2BNtGUJgB33Z2CQjZHk65OwZWrSCiri2a3qKDzinRqFPSvTvZK6rM8rqOWA2HQLTY1aoG2DXod9tmYp6Z7jURlcihEgVT2SUqQ1l0Zy0h1PHfXY5m+y97gh+/pct+VbysvrP5sfc5TGxAQ4g8RVdzFhKa7A7aoSIrgEXecf/jE9NVNX91k8zrG8enfC0pooAegYAbQGyTfvjzo7G54LCx+a2Fw7PRPPix7mylmnwva2BFQBuy1n9HUBme9Wg9SAPt3wNf2BKOXPEy6LD1UUGVq89FKilIsypihQRv8mJD/D7MJN+tjP4FtGsHR65urwSgZcKxuaShL+QOCzQw0MoXCHbul1KDm6+5FSCxqVw6Q34CTevfVDPWBJ9d1KSAEQpJtW67Ac+0uQJ3Uc/0gIXnyg+iPZMM72ppOWG5R9rQyYuT2q8kMu52Cmj9NJJ1i
 CI1iUzzv
 +0RyZjwCFFTtXj4Lv5XQqR5mtet8NTzY/e2x5UaaWlYX4EqnDexy2qpm5Zds/GDHAsU1vBKlistrRDOzp+qRTtgRa7rZ/EREizRBSHi68x8msbImgRYHKhlq9maEx3Qdch+o8DKXrN4dy0qV+WhjEHfcDBd93I5vpxWrJ4yVv48DaNvOPp0ieZtqdvPIfBWVL7h57EPnQo3sFjodgOkmS9AjtHr8bqgMIiyA6da3jrrDxZsgc6+XuiQfQBN3wyiCLyLp456x8jP5S9zYbhe95TxsUZ03LmuZRc/Z8KqdiWSQ245I/cvulydzDrKiKxnRUq+ZQ8PRvmxKQdX59Pk4jT3A7H1sqb++skq0a2pAA7A1btUFX5r0tNN/ALp1Yo9WRNdIGPvDbiYI75s2ulIn9+LD/Byv8thlGJkGVZKhGw6OMBn492fH/B2WuaXkdAwt6KBIsnWWzzW7mart566r4iuFeIJma9JnVeZ8o498RRrvu4kl59KrTvhVe4DxzTqihbSPZMFe7W8lAL9Ul69H72h/GlNh9phsKuMYQDmlkgQrUDJTc2fGmRhKazefN/pYG3V7GUwLhaw738x57ZS4ycj7hSe0aM3AiUB4QvkRmfacGtjrQfbYPftsEFDJMcCg4RbmmyViUqSabEiRekmwRltYfAj/+fS0Peb88907MqrGlbYUfBEDKjDxVE1TpBjTjeddvA0LC0qM10GNdIonQXO0VbUj9cZaIjbwMDaO9v3NBvpxH/EFw9pJIajK9wU/WIWzA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250826 09:50]:
> On Tue, Aug 26, 2025 at 09:37:22AM -0400, Liam R. Howlett wrote:
> > I really don't think this is worth doing.  We're avoiding a race between
> > oom and a task unmap - the MMF bits should be used to avoid this race -
> > or at least mitigate it.
> 
> Yes for sure, as explored at length in previous discussions this feels like
> we're papering over cracks here.
> 
> _However_, I'm sort of ok with a minimalistic fix that solves the proximate
> issue even if it is that, as long as it doesn't cause issues in doing so.
> 
> So this is my take on the below and why I'm open to it!
> 
> >
> > They are probably both under the read lock, but considering how rare it
> > would be, would a racy flag check be enough - it is hardly critical to
> > get right.  Either would reduce the probability.
> 
> Zongjinji - I'm stil not sure that you've really indicated _why_ you're
> seeing such a tight and unusual race. Presumably some truly massive number
> of tasks being OOM'd and unmapping but... yeah that seems odd anyway.
> 
> But again, if we can safely fix this in a way that doesn't hurt stuff too
> much I'm ok with it (of course, these are famous last words in the kernel
> often...!)
> 
> Liam - are you open to a solution on the basis above, or do you feel we
> ought simply to fix the underlying issue here?

At least this is a benign race.  I'd think using MMF_ to reduce the race
would achieve the same goal with less risk - which is why I bring it up.

Really, both methods should be low risk, so I'm fine with either way.

But I am interested in hearing how this race is happening enough to
necessitate a fix.  Reversing the iterator is a one-spot fix - if this
happens elsewhere then we're out of options.  Using the MMF_ flags is
more of a scalable fix, if it achieves the same results.

> 
> to me we're at a simple enough implementaiton of this (esp. utilising the
> helper you mention) that probably kthis is fine (like the meme,
> or... hopefully not :)
> 
> I will go with your judgment here!
> 
> Cheers, Lorenzo

