Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53D4CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 10:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5168E000A; Wed, 10 Sep 2025 06:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC938E0003; Wed, 10 Sep 2025 06:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085138E000A; Wed, 10 Sep 2025 06:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6C3A8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:56:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D2135B813
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:56:19 +0000 (UTC)
X-FDA: 83873036478.25.4448808
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1317A40005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:56:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PDB738sK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kpluVzGh;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757501776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6l9HHZgZSDq18uuqDRUvf0Of1AX4DmxJjsWHUEHHwM=;
	b=TqsXiAanQlfqNlmQ7PWV1NPazVVJnU8CovXujOTjnKwkLPYmZMBFnSGdcWDF9ovWDUXE3m
	yq+mQS6lsEUU1Oa89XKSilHc01C2GZsT8tYltTGYkrKv0bvI0L2uuWbDUXuq8eCAaMu8HV
	yjfTk8Z9dgnChOiqZvkTD1aqZpjEnwE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PDB738sK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kpluVzGh;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757501776; a=rsa-sha256;
	cv=pass;
	b=r/99fpos0bl5DuxTHD+SfeEhCnVe2fP9mhciAtBHYwlmNIsKS2VgRplDoChNiO/hWyw6cj
	XaRCnvcW64Yj8+2nneAWAXhdnDcmZU5j4tFVNxPu6u6HM/uKrLA0JweG6Up78A/BiCmR9K
	+tuWR+ZQfx7CMc1gflZADvA3q3tl05Q=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A9N68R010335;
	Wed, 10 Sep 2025 10:56:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=x6l9HHZgZSDq18uuqD
	RUvf0Of1AX4DmxJjsWHUEHHwM=; b=PDB738sKSE4eBo59iXKWoYEEpiYG8XK/qd
	FM4MhqzAUvg7OgtciIWEx1tFUcYD4/3pEZ8x3LlAmTevlq26XiDgH7GJj1dgb/Ho
	cZw5ZJNbe7FTkZ1ZzNB4ZASZF5RU73k6YVXK6rw9sqSQhqg74Fa/lHa6Po9ClcnY
	z79sL62OvsASQnc/qJHSUmaGY5MwBFIKpr+/+s+qbrCFQfDUUv8A6egPgNA2WhJM
	yFRchbSmLDg9sYdnMIr95RLRVe9H+2NomxK1VvfXBlR7omWa4OaS+tzZJY0NnUhf
	nBdD16E6KD9vGyLm6gRJXHTiiISyWA0NapodLqsDnx2hgSml7H9g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jguua2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 10:56:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A9tBkE038753;
	Wed, 10 Sep 2025 10:56:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdav202-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 10:56:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oj/6rrXBbPD2MqdcNZBFMTs6qlqC5iTsNsTs7BD8ntnfy90PtsyhjFJk8TDPmNRlH/ThnFa6kS1MFIAomxJJsK4h3iqJs+smX7DQ8HUqyxQrCu76aYbrv95atFiRuUYfpOTyhyWopqTKgcQrbEV1r/2BTBtfxOF3W4T2fF/ftqk0pJ17b7qzSuMftTtbUbUYe65sf2on6jWFquiogtCWQ7zgIs/i7A5w8zG3Xiw3G4mNfqkf6ao7R7Q9PhjabhJPGJUBOe7o7D0tmH+sXu9uB04VdbPFEHzCuZ2SZs2k1zJlaNWNU5pml8EtYhqVMHLl72hhLf54UDaVL+GwB+GDxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6l9HHZgZSDq18uuqDRUvf0Of1AX4DmxJjsWHUEHHwM=;
 b=TLdGhbjg6+w0NSVgpyhxrCucxsG0/9T9bVXc5Eny9WNZ1V+mhMp/iDwlTvunfI0j2D3mBzvHAZgeXJ5f3P750KfI6O2E6BqcnRTLve8WpqKgcIPWpBuC1MPfeUvWiEZuTFYKQX/o5SlvfaKDr9e41seqD2RB1/QmLpkOzAOzoK0F28DUFvaTNjbwnyXpqNHEJlqyh25Vvps7xgcz/fwNlEXjgOfPaRW1j7eJxTEcyRBvYgf9hCop0MRFMUKySfSrP4ULm+7vsUbbeBguQnsZm7/DK4Wp46zo3kG8BCbhanV3OYzbfJ1kU99INLnRCQHesfltDtHsGgamojYhI3HXWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6l9HHZgZSDq18uuqDRUvf0Of1AX4DmxJjsWHUEHHwM=;
 b=kpluVzGhULiEDLPg7MdpodRpab/psh48Eydl5QraEpdtC+kjAx0iUYujQy0EMubbWrvGB7ZcZy11BCfOXp6A/Zlf+bRvfvtAQa/6ZtnzVu6c0EiPqQL4HUl6xtv5JregZ4H8TnuN3QnMQvMET3oZUmMG6zzfL7m5X/raXemkMos=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 10:56:07 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 10:56:07 +0000
Date: Wed, 10 Sep 2025 19:56:01 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH 02/22] slab: Remove unnecessary test from
 alloc_single_from_partial()
Message-ID: <aMFZQYDjXYW4BKMv@hyeyoo>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-3-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829154728.3397606-3-willy@infradead.org>
X-ClientProxiedBy: SEWP216CA0120.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: d43e865d-6bd1-420e-283e-08ddf058a4db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y1cpvGj7SVKUUYdUVgjwhulxT8F+iMe0OhpNLBzoF23gG+z7Fgoj1yT2zCYj?=
 =?us-ascii?Q?q1xHITrZHgvQcxfobRdCeeCBMKTfKCtb+L2nMifaz0oba6xp+g0/CnlDrObO?=
 =?us-ascii?Q?pd218bnL7IolggrGLhGPo6c8WV29d1UIoKHNEA+tQGq+sXLlDO5RfJYecwuD?=
 =?us-ascii?Q?LJ7XO/Yudm43HhdAwCL3c9QcfU1QiD1yOBr59Y9JORMQiSKJeHWW4sKYaEp3?=
 =?us-ascii?Q?K05/r1urvzi54WYgW2C/6mn0ymS4PLT1DNaljzjYPE2DRT5JT2BcHyY1tmFj?=
 =?us-ascii?Q?izxC3tg0ByBrYMDjrvDQoIrFX4jAlGgvlLI1PatlbutFDyWneIpQbUJXtCfC?=
 =?us-ascii?Q?BO0H8+YCp/2syvMTgQzsKAXXBytkWqANpJfXG3J6+YB8krgFWhi6FIwSd3FX?=
 =?us-ascii?Q?D0Bx6Ky/PYg2jSfxdrz+u2Ivj75T2HfmIFzGxj/LUWoOrUETBgOHrgQ7a3Pk?=
 =?us-ascii?Q?AXzjJKVCd/7U8rq3tc6W2eCaoBSLbv0HwrSVHYfLRXVEZ01ZtP/7OjOt6wHH?=
 =?us-ascii?Q?LQQftZuPb6rMUbNVHtWNjB/D9TTqzJDSONPQdVqH//aiOBXum8SelautXHEp?=
 =?us-ascii?Q?J2Bp7hmzTDfghN3d6kiGvlD2h9kIIP58jRJfFPH3aycGU0OYxt/4uh2kbS4j?=
 =?us-ascii?Q?WFgoxW1e2D1MZitFEFvArbTc6lsy9f99nCAdp8dDLUaNB95i0DCrLGAb886n?=
 =?us-ascii?Q?yu3V/Y6+l7HYB+hvKofo/mmjr/Ty5S/ZEFggN7rsptb2HGz+Bbkbdwe6JgFb?=
 =?us-ascii?Q?8wcmOYtLrSeCSZ4IddcaRHCbIQCooo+v0UHPxYHI+TTwPXWP28M33rdesk4V?=
 =?us-ascii?Q?I0JLBt1cqBUbl8sWbWeVRY1l7O17mAhh7bo8dLNpY6QjGxZpvo8ZdVfix1oD?=
 =?us-ascii?Q?EwNb40gA6fArFgKw6r+FbguJvjV751EdN4OngIpdsFoxxnGH7s0PpqUwfo/r?=
 =?us-ascii?Q?M86nyEDXLSCvmWtAlpdWOTafKO4W0XoDO1pXYs1c9Vi3Qp2seJAM9ntTRf/X?=
 =?us-ascii?Q?zW5MZPB07owNFC4eJ4cztotDcmQptpdeub0Sjp0PBQuBLOZwCkVeM/URCeIe?=
 =?us-ascii?Q?F+OKrrZKw2I6KcyZfoBnTXptT+H8sPHcMQWakgMXqaNryf1XSMIaQqVoH0gh?=
 =?us-ascii?Q?amYU8YQTiLAG1HYXZ4TSnImMDSRhGPfDtNHaPAXH33p+Hcz+nK7pn6JoyPEk?=
 =?us-ascii?Q?66K2rBA0547M1Z0xHSE+pthw96GqPNcLzMZi+qMAeTdII0Em1dKy40Mekxt4?=
 =?us-ascii?Q?3+NH7fjQeo01c46Vs6i2IY6YxTw/ezaZsPXrp6HpzHMW77jTUc0kQsQDPlpY?=
 =?us-ascii?Q?Ox4cCWGX9VITi55s8hsAwmnwM9b1aPB1q0IZ6EcD7VG3g6RMqtYyjR+79/Co?=
 =?us-ascii?Q?IJa/2Uwn04nqUIeJUgEZ3fIC5c7Y4SmZEN395NvCPHkQPIyPJDs+qdUhcYed?=
 =?us-ascii?Q?YByzG5GSRsY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sZJrPjnWvntlBr/pPncKxNcz1AZfeZwT4hN20hAa3w/2IrsnJzYemNSpuH1w?=
 =?us-ascii?Q?nXYVCA5ne+tOqwd74/Q6fjbyxECNyjqhK9gw8/N/0/Vq5c4De+qnlKLMLDxP?=
 =?us-ascii?Q?BsDJxPGNY2meoLz1YQgICm/hrOvg5QNSV8YKmsj2fORMjicgFT4G4h8tx82f?=
 =?us-ascii?Q?X3WRfczomtLbzwrZXZEAwArZACMmom0zC+vDZ66RsZbEUxONEKRau0UFRLn4?=
 =?us-ascii?Q?pNX3KproPVM0/0VWP+2AWa3uUUMR3nNu90vHyFZCdrqRRnT/dj37iVr9fo16?=
 =?us-ascii?Q?JYXV7vPJV4tiH9OFTuJeUL2x76cpdgIheT+P1UkSrGiYWVXOpDHG/JO23z43?=
 =?us-ascii?Q?/ewYd4ODuxjrdiVC0gZABtc5K41uUF6radMFh9n8stkoX0R00LuQUrKYW+yq?=
 =?us-ascii?Q?KKi/wsbDwQbHIcle1EZMp+yyN/rcH7zGrR20HjDRT1MgGfC/LY9VAMnl2XaS?=
 =?us-ascii?Q?qTJfCJlbp7qifrI1XTfJOi9foBTlnSKNpNTtZAmx5JOoZFc+fcQoxodzuApH?=
 =?us-ascii?Q?MGLCc7LTn2NgYsNPP2etswNkVOTliCzg2V0LbbWg5Hr81RXvnxMld7zPJvJx?=
 =?us-ascii?Q?vTXrtWSREECgE3tog4zaGJfZQJ4omtJivzk15eYkVEBbhFn68/br+Z8qmAj9?=
 =?us-ascii?Q?sJnZYEMtkTSrf30xO7c63Ryl2PwRkE4mX6vRCdghObHMHS+4hSyfz0Q6GBI7?=
 =?us-ascii?Q?6Z5cg9cl1FWMnmXd1DhTFksMY0JWIN2c+lpofGo7elWJaNbp9VvG33fKug9p?=
 =?us-ascii?Q?K4HfplGhLplRoJn52wlZBfCnjJi6QCm7hjygtPk3sx7jRJzxMBmGfuykVSHa?=
 =?us-ascii?Q?w82Sb7dGsragB828odeeMd3HBkeUXljElx15nIBx44CvsjunA9U+lBeEgkZW?=
 =?us-ascii?Q?O0Nb17Sa9pHwz5kAc7bgq4PpkvDHTphzxPdAyRV+mbio6by53ZbVHJZzyDDf?=
 =?us-ascii?Q?1I2utCIYK8/ZeJ0VCO/yXJKtl7cXXdKGT9HPMb+Vci+5/cAfe2Ri0HYeHiNd?=
 =?us-ascii?Q?oUa8sbacYXFs+Kt11HA/y9dJvaDVV6CcTb3O6Bu1WKfAd19uUuAAmQYseN6/?=
 =?us-ascii?Q?XXgiIfV+EpweJhxwwwyR7pANA1ntef1W+QMp+IMG9uiQC1PzLBMWw8Pn5PQg?=
 =?us-ascii?Q?mPxoiSglRqoRLyLwPvfcxUSCsuEi4iiaBh1ko3aCcpGO+oE7zAI6vdvEQH+L?=
 =?us-ascii?Q?j5rYqT6rJoYeSTm70sEfe+52vztF/MuVsaBZE/ilbNCGrVNNTGlfRLIXKcqz?=
 =?us-ascii?Q?38u79DB6X20FAFva8orLFpNLWGRq30BNB5YFYsa+XAPzOrFsNhtMD/dyW8Gi?=
 =?us-ascii?Q?Ux3vgMOMWN/y6x1NrPEcCE+TeY29hXILE5YIPbDVI8Bjx6JyWJXoBf1qTnlr?=
 =?us-ascii?Q?T42MpgolSYZcLzriEJbYz4Wt7JiOh6eB4XiEueY72tdxU3P7faz6S27UgCPe?=
 =?us-ascii?Q?SkEsBshOxPODK8N9tAd9NK6QfW71q/qjMGcALKHhZ6px/xhrMKRBqtFPeyTd?=
 =?us-ascii?Q?1aVgeiFGicdT9DftY6wXfENFxsdojmg7R3a/Gth/VnF7OLBeA/OXfhFYUdTU?=
 =?us-ascii?Q?sIg+AOnApycw+LUfxv8ennxPSPdaEd9n5glW1roD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3zup5ZeyZKllx/9bRoHNfp75ugAQB5EuZFSLM0NO1wjI7MoKIwD5qiJCd3BjpNtNbwix6oyh2/+CM2N6+edwAqKN+vDFf4CNFj2WY2/cinUafFQm9QDZPFBbuibo91egvRZ53egyeRhtxUd1+PFdLan//+geDTMwAXSQvqmxcVPCj440EzO7f+z/cewhSjZ7K1D178h9N4+njuJziW2qLHLf2Ty4ShGef6QqTWUTjHuAFTsakRwe9v8St20oLaOw51YBjmXw/QxoWN3usZfL8nJrpS7LTcW+dcVhndr4fHp5sJG4STx0RQvpaeNfhM5iSHbejTr7q/N5B4y7Ib4ddkB+jLjtSrodKaVFOpFf0PSaICWlgAjjtg3BRZZSDP1FHXHF9BUR1cK2dhEe4f3iUXLzubYCjsUevY6/qYrQWVLv9P2r+PmuzELJv5feKYxTCQgSXrEJnV3/Sdeg2ndiarmncYKxSD2A5T5yl1L6faeeDu22SqgFjOFFESy+P22GwFwiF2brES/pUPhBMRvNjs9nbJMT+Gh634jepveuKFCMFa1jzpxkc+jYp8e3ZPfq1ya0RpDo0hxQghWhDRAqDFDfI4U35Q6nAXRvcANKNVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43e865d-6bd1-420e-283e-08ddf058a4db
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 10:56:07.3411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pt7dVAjRZc5TZScU3EROo/K67L5Zr4vOyE2r3X3GzcCZrISmo+KP94CESTjPmb3YslZZ4B0Yy6fd6DSawAX93g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100099
X-Proofpoint-ORIG-GUID: 1QqA9THOuTjPVVSZ5CBuIv_MLWg5Bv3y
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68c1594b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8
 a=nneWswUGftmbirKR8VUA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf
 awl=host:12083
X-Proofpoint-GUID: 1QqA9THOuTjPVVSZ5CBuIv_MLWg5Bv3y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfXxQ0RBPWyVwIB
 Ih2sMOlAdwTI1RXGHuEpX4Z0JsA3tHMXRd1zz303PlZ+8wSmmE8inpjJaq21FOjtckfogFQyuhu
 HnPt2LwjaGYEUvo4xiVjpM2QhrJP4IPOpP2V4Rrvt7uWwW5o3tjVHygCi1DMfTk7oulYurrQ2hx
 SJRfc7Qw02staLHFreGe2ou1gJmWVRyCDlk8pV8ZoMeUNty6Vp06a3f36j/Va20aX9IGFNQYvt/
 Pga56onSYfXleHLvCoBa1rgffj8wjwg/WhajBbrCyd0VEE/9aXXI/+cHEQiAqs2FtzmdgXuytBF
 Tg07u8WUz8+zWEaFiICxUA1FVl0MDimAE19fhM+6/ADTJ02kEFag6B86c0pbNHZwhKWfC+g/MoC
 ZAQpc5R9y6jFsczQ80ACgz8NTUYP3Q==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1317A40005
X-Stat-Signature: oqgtpcedejriz95if1rimwigd6zx931c
X-HE-Tag: 1757501775-818981
X-HE-Meta: U2FsdGVkX18m1+kxWJkcAqIuS7oiyjxhFOzohSZN+kRNkdKRzfJ5sHaJhT6OXA6VvJ53GQXjIGS9e1xi5bE7yj81ROaVTEQCwLmEYZU9hNvYYb4DcC/aWbarV6yp0JIt0Xu2o2tx2orhk7AU8t9quzZlU56yriqUTEF+2qLOROHt172qN+qYrKpeW8Hi2ZgEHuCQbTYgWlyOLSIWNXYV4lbxgCbzg+fl7ox8VJoimmuOZuHtW3u5sQlgLAzvFrDhT6QJYcO2h6O/Hrf8W3EpQzAIU0aFTZgoA+u45nvibT8iGKcvR40YkhRayEFrLR/mdqnTStgkwgY8vK38ytrobE33DuhlgLEmz2oo/0n/eGMzLOE7HOseX2OMtiZA9WUiY1axR9m7S4E25+QkQ/vPh+mD7dzl/KzmmCzil8VNQumz9XTHHUYVDTDWY6hHMCGWqv71qZYpviSHQaNBPb2jx86wjrJ2vFXzXWj+nQNE+AyBQ5aLmEyg+OS0EDRMheioOgyfrbWopyksHga00AyK5fqG4uCuocP6+ZxhC/ddet48JPHVCsbMVmS5nO4xVM8rp0KOryETuwzJubBu3rX7pR040k+RN/uWWSbFXncqQAiCsJ+jFqFCvwQpqNKOKK2XcykVwdS1mkfSLSnPKg+QJunKEQwMQpcTE2+7HBz6I2doFx7MAQC//KPxih9VZT6EZP4wkazBj+F5ybyX05BO5QWlPmDEiK1x1yMi9u78CqosCOAAeUtt5p4mCa5LJ02Pe+CbvjkRXEHdsWntnzHhFRmsncVh3+aoT0Fb6yCxsfdOjLMyXq/iecBb010yU3mzK9Sq6F4Rc1JBzqOna6mYrpkQYxiMLgWnBCgCcYuNakrVlYZDaDamvZbC61fb+B5KtUEFibeVT1HZpEWYM1kvOBaYxdkWw/hGfVWsbQ3L0x5w+xk3ETw5/1w2lJNT/SFjwefFiPDwVpLKDFmYy9T
 eR6wwDPX
 ISe3gthfKOXZROuOasgKE/DRciPIVk3Su7QhZLhTDb020vC4bdhoDwZ1z897/L9vHWo+chJrEbTt5v9rdJwfg971L9ApLurNMmHeWZGnQlA6IEu03f0LbfFCTjTNvt+t28LNd3CZCs9iGrYBcCLKdXW0d5uZjmwq72hLpV3WEItIwMidb+Yfj3fn6cFZ/f/pASZKbsz4wzdTU9EmkGCCtHWiVxxI0f538QKdvG63ZA52JAUb9QCTSdC+PJO9OP9IIgvAj/Q8VSZ9EbX0h58VK0TTbkcPGT70vuUzYghEsH3N+D5Q+EjIyaZOPMoJns9LHd5YQZyhQchRK+eO340sYXOyQelde15E9SzYzcjyv+7yrW4+bbNzXHSBjlNehXTpVtuI2TpJojXE0jFHUJ+zuoSMPFgPIKzd0DycQocyNg/XAGzxYnPuhIdj36C1VGx19Dek4qztW5lZ+P7ObpYPui2mm+z9szM6EzkWj/G3W23ICvaKR0jxm95MRgpBrsxkayK9IsPTQ0ZfE9FXZFqmww5rwgA81bG8/IpPZt0e1iOh3XxF8RQl6nkmLLUrpjVcNyL4OAZHJ6zLoTXUnIkmXrygZkI8XZXE0wxvwh4Z6LPev5Bxb+6pcHTwwkejyiQ2eLbAxD+X2pRysapy93Kvj9CP/s/noKGBU4zXhiaeBs5BCqXYA44f26xBHXWh1Py0PHJXYROU1hE1RXoymdIwL8tY/PRZ+rGtUUUom2lW1HtvNLpZXWn0s+IPGNT54zIiceXQtKdwAT/NQC1btuSD2u8Ycd77enM2qoKQw9vCDJEH6t6fyB3l+pA8P7uzB3g41pHNgXYlFnLWvqssE3AtPQB6fQTjMJ+nfFDkpTt+jkvJGBzo09F7LU8NTWpzrFvNXxO3n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:47:06PM +0100, Matthew Wilcox (Oracle) wrote:
> We know this is a slab because we already modified slab->inuse
> just two lines earlier.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f737b85a326f..8fde324cd308 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3318,8 +3318,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
>  	slab->inuse++;
>  
>  	if (!alloc_debug_processing(s, slab, object, orig_size)) {
> -		if (folio_test_slab(slab_folio(slab)))
> -			remove_partial(n, slab);
> +		remove_partial(n, slab);
>  		return NULL;
>  	}
>  
> -- 
> 2.47.2

-- 
Cheers,
Harry / Hyeonggon

