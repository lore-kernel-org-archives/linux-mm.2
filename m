Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01436CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDDA8E006C; Fri, 24 Oct 2025 05:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5668E0042; Fri, 24 Oct 2025 05:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256038E006C; Fri, 24 Oct 2025 05:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8C08E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:37:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6DF4497CF
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:37:06 +0000 (UTC)
X-FDA: 84032504052.19.65E5044
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2057E10000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:37:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O0Pmctl7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A3sMstQq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761298623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9s9ZlemVWXLuMkaqUkBuaZvMIuKTRZdld4siaSdgvA=;
	b=WWOPnuNXv3vUPQkFseIYXTJnoAjery8I0TRFx1lOkbzQXr6w+T+3t6e+p0neNodOL/kBxh
	oMElqIbFxC9QZv0lBZ1urSuR8C8bhVgSMbcJnCU9WzRPvXSrKK5RSkBW8YdOz4W47+2nTN
	V9DraNujS06VIYeOymAb9SLYJ+CrmvI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761298623; a=rsa-sha256;
	cv=pass;
	b=NnquJUgv3pS0GX6VQ6mJtzLZ0pg+DT1yM5TyZgCsv6nfILY/CL09zc8332S9PwIHtf7Akl
	d6uqGKKMaVlOf+pdNBHRwxA6p/+OoE7O85qR4b+jBsOycG85z5G0MOePVhyNcBvHezozEr
	HuJrgVutQaLs5YaQ+d/M64Vfz5UUmBs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O0Pmctl7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A3sMstQq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3NOEI029133;
	Fri, 24 Oct 2025 09:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=e9s9ZlemVWXLuMkaqUkBuaZvMIuKTRZdld4siaSdgvA=; b=
	O0Pmctl7aDIBqycjnUHxFYJ9D9gKMNWYtJcwvVcXZXuCdtQIqufVVq1rg184qaJs
	bcLmv8aHULjUV0x/WM/orIR7HPTvy4NkOJSHse97/dm8/3gLU2coF8ub91FO7QxM
	OLw2lgqpCfiugmZdX/u/GYStSgwy35w0w8XnlQgYf/i5a1yB3xXzRti68kVZCDjF
	gAju51JnASyppOeuKQrH846PWPgxkH6JU1caWC48qmrbFsqlkrv04EUWO8RrWNDW
	rXLEwjX/8yBpfFbzhu1IkSqaxdxXJlI9Io6h3TqAbHQq8GKOmyoMINPE+5041EJe
	MeVl+TCBdwEv1HSkyyoWUQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvd0varg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 09:36:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O9U0Ad030481;
	Fri, 24 Oct 2025 09:36:55 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013029.outbound.protection.outlook.com [40.93.196.29])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgqtaw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 09:36:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=txF0lq8Okx18diHe022tlHEaQ1lMA/LDo4jntQFK3EK1tMznY94HiP1BPTsV3oGIePpDF8cuIzbKdCEwLfoy8uH3RZaOzNOTZsa6vofV8ERcEcIQmESt4CkrC2JGijYwvtl/bnddRaMKBF9kvIWJnIdP+CBdYd7wEaJQ8LEW1HLdqtsk3MP3LO9tBbGeIQCiwaLxtZQjG/5dfiC/tLZWrqWIEhu575EZ+LpkED+nGBcSca/nXR9wiRDuZJFbhDvzOJigxROF+Fd2TimhEmzuM13VRJMdsUg9b5/HgTB5vaurIgGk/k4FAVk8RY3LJLTcSxau45VchqFq+VpiPzxs1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9s9ZlemVWXLuMkaqUkBuaZvMIuKTRZdld4siaSdgvA=;
 b=N3/Rylvfo26yrTFKGa6LV9rshCtwUnYdpjlR68rCnZifah/9nyxgSmwCQcoWjrsc1N/RZX6G2XeQUKnHu/YIzYPhHMjF0WALKkpYjsHrejk2rGbI1Uyr5U8fwOe3tdMs8uOx9zYz9woL1y6otWsGy/eiO3BQnJREwyuVIDRpoYrGz2mSA+4YDR08uVcrhhFkxK3EB/T6wuDbWVLBBfevzQVWgYX8sXM20cSCYiMNFhazptp/sPoKp/8o1RK7vhGh7kPjSSwyrT03QJt+JEdTCnKhMo0sh29/gZUpbeG0GeO3SwPdpRUWCyf+OxF29gE8zInQuV7gV3ty5EFg5maz1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9s9ZlemVWXLuMkaqUkBuaZvMIuKTRZdld4siaSdgvA=;
 b=A3sMstQqdLyArywMDJbCZZohhqEr19/4ShnFtEXrz9h350MRCWAUzrZ8HtWSiMqUp0fu90fSv9cxh3OBCdSVI+IBHz6TB7rSSfX/U3Axojccqe5xAjqQEffsmPDt6+OJFvaxihzgkAqXpJmN50QWDjgHnAUtig3fjGs5S45R8HM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6588.namprd10.prod.outlook.com (2603:10b6:930:57::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 09:36:52 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 09:36:52 +0000
Date: Fri, 24 Oct 2025 18:36:42 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] slab: fix slab accounting imbalance due to
 defer_deactivate_slab()
Message-ID: <aPtIqm3LaRfCVQ8L@hyeyoo>
References: <20251023-fix-slab-accounting-v2-1-0e62d50986ea@suse.cz>
 <CAADnVQJS_RUTnpCX5etS_qGD=jgHjtY_Mtc5GQqPwvyyTfghdg@mail.gmail.com>
 <aPrBp_vG_D-8qG_E@hyeyoo>
 <CAADnVQK+3GLbq4GjOYO0Q6vhURPyNyy70bZKUUwRpLuK-R8NAA@mail.gmail.com>
 <aPrecUasNUbEkLlS@hyeyoo>
 <cee707e7-b7f7-4c21-8887-2cb69d73df93@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cee707e7-b7f7-4c21-8887-2cb69d73df93@suse.cz>
X-ClientProxiedBy: SE2P216CA0099.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: ead9b7e1-d599-4e8b-0764-08de12e0dd03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZitPN2VlUzZVTER0c052WTZCbFF4RUI1Rnd6RjhzbXN1OGtWMDdvcUkzYURG?=
 =?utf-8?B?ZWZMdFBBdlc0VDVpUi9wMHhRRnNITSt2azdXdVQ1NnNWNkZNOWwrK243TjhK?=
 =?utf-8?B?dS9pdnF4LzM4MnZhL2h0NVRyaHNEZHdtQW9vcTRtOHFJQTRvZjRxVnJrMTF3?=
 =?utf-8?B?UEZnS1pDUGhmU292UWcvZ0JIZnVqSG04cU5nRTl6VE96bjVXY3dsSFJtVExB?=
 =?utf-8?B?T1NxWW9FdHlKWkRhVzlLYXBLL09VUVRNVitKMnpzNmp6TlBmL0pPSWwvZmox?=
 =?utf-8?B?YU0wS2l4d2ZBSVlQZjBZNjlqOHBMZ2dRMXpFc1VIRGRpOU1odXBFVHJVZVJK?=
 =?utf-8?B?VTNzRTJKSXV2cmh0cXRmQTBUTHZoK1VVWk9MYUpXb3l1VXpydVgvdTUvdG5l?=
 =?utf-8?B?TGtKc1UzV2FpYy82QmRsSlRCcHk3TDNXQnNqVE5GSnlSTHRKRUt0Ukxva2g2?=
 =?utf-8?B?ckNVL2djK1Iyc2RObzd6ODdrVytNK0llcFkxVjFTM3JmRlJVZ2lGSjFhUmls?=
 =?utf-8?B?U0JhaklWYmFYUm9KZ0x3YWZ3dUVBa05UVzhNdloxYWRiM29NMnNCTGN3cE4r?=
 =?utf-8?B?VHZKOTZQanpQbXFtR1BvSytVZFhoZ3Y3T09xSjhyelJ5UnA3M2ZLVFdQVzhy?=
 =?utf-8?B?WmNtY2QzWnVOUUI3dDdGSmxncWtVUnVpQ2ZQdXRiUmhSZTJxWnFOTC94bjQ4?=
 =?utf-8?B?NjlTczV2MVMxTTdZaUpDZEQxRmJnMy85b3BCNEUwUXptRzVHRWdvaExCY2Jt?=
 =?utf-8?B?RWlFb1JQWnJsdmZxYUUvSlhBckFkZ1lHWWlxWmpBNlo0Ylg4bnVDNURRMFZW?=
 =?utf-8?B?TW9EdnduaS9BVlo1UUZaWVVha3U3VzdFdGlPWnU4ZFdlV1pBR1dDMG8vakNV?=
 =?utf-8?B?S0VZWE4yMjEvbjdDRTNoRC9xSGRSais5SEF4Rk9wdmxpNWl4LzJkWFNOaGlz?=
 =?utf-8?B?WkY5S1o3Zm1Wb3lYcmdRRXRBVkpoOGlZTWVzMGtXVnVJNnNvQmdCOTZOWG1E?=
 =?utf-8?B?R0d6TTFuK3pJc3JudFNpUzF0aCt5UEd5V0tINURiMm5GRyt3aVlSVWh0YkRR?=
 =?utf-8?B?YjRQZnlhdG01K05XK2plQlI4UDA0WVk5RW1sdndwRFhzYW93TFNWUTEyK3dG?=
 =?utf-8?B?UWxCMmc2TGlVT1NoakdxellSQk8wTTNSOVZYZU5Qc25pQUJMWFlLbEQ3OHNE?=
 =?utf-8?B?N1FsalV2VXhERlI2YitzRmtqVER2NmtTMVNKZGJtM1pRaHBCT3pnc3FZS0ZD?=
 =?utf-8?B?M01CMXYrV1JCMVlXcFdDN25mVEJmWG54YzhSaHFIV1hrQWt6bktZKzJWNkVi?=
 =?utf-8?B?bnJnaCtacFQ1cGJ1SkQvRk1SMlNFRXdxOHI1T3c0SkF5Ynl1bE91amNNS0ZQ?=
 =?utf-8?B?Tk5SWVF0RUFUTU5XUWl4aStqZXJKUmNrS0IzTGRUQUlBOVNBMCtoOWFWdHZN?=
 =?utf-8?B?aEdxSG9lQzUwZ04vT2RGeWVPZ2ZBS1RINlZWY3FVVzk3Nkd1S0RJWlhjUWV2?=
 =?utf-8?B?MVIwcFErWm1BeHZnNDJjQnc1S0NBR29UK0hwVFMySXFYN1hUL0ZuU2xubnpT?=
 =?utf-8?B?WGJkTVBHZnhaNUhGRGY4RWpoRlp2UkpyT1hlZUY4VFE5WnhGRjBCMUFQTWsz?=
 =?utf-8?B?Y1B3bzJOVURXeUNmaVZrRHpsSlZrZmJOMWNraEpDbnNxMUhuY200U1hMS2Fa?=
 =?utf-8?B?Nm1weDFkNjQ2amZPc1lYbkl1c1AxVUxUdjNPa0RpWkFNTFFyaHVLSjVuQ3J5?=
 =?utf-8?B?SFluK3owTUVjeHlrWVd2eGNMLzQ3ckhBV3IyWDJCeDVqUEdVdG11ZFJkY29o?=
 =?utf-8?B?eEVVRUdOdnRBbWx4dkIzOUlrN09UTWJvNVBBUG4wWUxudUxQU1lpVWRCNU1N?=
 =?utf-8?B?K0M3WjdsMXBWVUhEdzB3UzRSTVJyTFBreTVVTnlKQVN6SFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkllRG9xU0ltUGpWTjhmbzU0cFdKWndTZU1YL0J5Wkp2MG0wT1B0aFdiZ29P?=
 =?utf-8?B?WWQ1aUp1bjR3ZnpvUDlMZjVHUzFxcnFQL0dBMkE3V0JyVmJlMllMaERySGNC?=
 =?utf-8?B?NE50UlRNSGxBbXVFM1BBKzJCcElYL2xsZ2NDeDR4MGJTTGV2dVBUQVNNeW9N?=
 =?utf-8?B?OTlXd3I5Zk9aWGVySnZhSFQ3bGZuRXhtMXl2aVNnQk9qcEJ6YVVWTWZWZklR?=
 =?utf-8?B?dkYwM3pvR1pjQUN0bFc4Ti8xWU5FWkU4Z2ZVZjdqcUw1UFh5eGtpRGRVdXJ1?=
 =?utf-8?B?cmhzdU9YM3NnUWVJRHI5YXhxQnhTM1pmeXNqMnBQT1FiSmoyYzlNaWtURnRw?=
 =?utf-8?B?eHl1ay9mZUFjdXVGaUYvZnZJem1rRWM1UjVxcDd5NTBhdkt3a00vNEp0TnRJ?=
 =?utf-8?B?SFdHTksycWdEZ1BWTUV5cXpRMFNQMGlVSUxkWHc1ekNVRUlZN0g2VklFN0Ra?=
 =?utf-8?B?SThLZ0ZRWWtuL3FwRUtXRHc1cTF0enhrcWYrVEpXcHhVYUVQYjNlOTdmUmIy?=
 =?utf-8?B?cUdkZ2NYTitldGx1U1hhUGZSRkRFb2JUTGNiYlowNVBPaHpmODd0UEZBT3Er?=
 =?utf-8?B?Tzl6MWVYOGw0VXh1QmgvUXN1VTN1bEtyQ2d4aEFOYm9GZmFLS1FDMjdpczdk?=
 =?utf-8?B?MzB6cHI4bU4xSytlaXhlSVY1cnlNdVkzQ1RDSXUwR0lBdHhNSHpOODlMcTBC?=
 =?utf-8?B?TVk2WEMyRE5jcjFFL3Zsa1YwQUZvMHlLVldnei9HdEpEWXpnMlcwZFBOMCtz?=
 =?utf-8?B?dDJ2T2hmTGkyNGZ2RzFuWnlIYjBMTVEzQWk3T2FXTjZ1bHM4Szk5bzN3YzlR?=
 =?utf-8?B?NWVBakNaWC9WWUY3dXBuVXhXZlc0S0FGWDMvOFRaVTNNcld3ekRSdkEvYjNh?=
 =?utf-8?B?cUl6dFc4dmZFWGxoNENZKytGRzd4RHhxY3ZHWDd4NGthNHpGY0o4MlhRZkxP?=
 =?utf-8?B?Z0Z3VVVjMk9tZjRsMHo2MHFhaWVhZWZaem5SV0p1V0krcGZNb0Era1JVUlBZ?=
 =?utf-8?B?RkI5SmZvdTlwUmRpeWprRENNSUJGeHhJN1NGYktSMzVGazlldjFQcUJZTHoz?=
 =?utf-8?B?THI3emYrK3VTeTZVNXJHWDA5SUl1aTBSdVlpTC9Cd3hySjZVdkwyZGtCNVM3?=
 =?utf-8?B?QnlPTzEyRXBPSDFOZ3lQcHBsazhWWlhHdmRxMkcvT0YwcFZ1ZTBtdFBGYW94?=
 =?utf-8?B?djhVMnVLNHRualVyMFE1d0tVZVVoU0x2dEp0YnE4ZExmQXp3WnJjczUzYWZq?=
 =?utf-8?B?Uy80WVRpOU4zcHdiVzBYc0hRMU9BT0xBaWVNZm01OGVPQU1UNnRWRXVRVW5r?=
 =?utf-8?B?bVljRmZ4TUttTVZ1dkpqRTN0VGNzNXVBS0dHQUw5SmhwUHp1d3ZVT05vVWgy?=
 =?utf-8?B?dnFYYTVJMU1xZVI2SEdKamM1alA5MjZCNXpDdmlOUHdLRnBITlVtZUtVcVBn?=
 =?utf-8?B?YWZaL2tReEdtb0VzY2wvRGVjaWhObVpiYlZMTnV6ZzBIYXFYYzFZQU42NlpP?=
 =?utf-8?B?RDd6UVRFYmVpdTlMbFNCSXFvek9ndkF4NUxtQmp1TytTeWd0T250c0ZsaitG?=
 =?utf-8?B?VUg1a3ZwWHNIdFppYjB4MHFOYnhLdjFtMjhMSjR4TExyV1p3bWMvWFdvZFhV?=
 =?utf-8?B?L1A2QXk3NE9mdUxKTERFRTVTWElaS054Zk9kVHhiYzR0ZjlTa1BLY2k1dzV4?=
 =?utf-8?B?d2NBd1ZrWE1qcEF4dFV6SXlzbHVBcXZmSGw4SlhsM0NjTmRBUFFsM3ZVN0kx?=
 =?utf-8?B?aWloTWkxZy9uYmRCUElBaVNpMmtnb093OVpYUHZyb2QxSFJTTTV5bHUyeWpo?=
 =?utf-8?B?VS9CRzc4dW8rNDZ3TS9jYitPQ3k5ZmdwbVJPS0lkVlRJQ1pWSTBrSlNVYWRq?=
 =?utf-8?B?cGQxN0NkTHcwcnhkekdUelJJanJnQmFBS1Fab2tUaUpmbldHNkZDelk0cldz?=
 =?utf-8?B?UjZDRURxQllQMG9HUlIvYnI0OHZ2NkRIRVRFb3NmWUwwQm5RcE9NSGFGU1ZV?=
 =?utf-8?B?bnZ0VDRlQlgrS21sQWhhMVRiRzdzaWtpNUREY0sra2JhR2g1bGk1OEVGVCt4?=
 =?utf-8?B?b0puQ2I1SlZ5ZStPdXRmaktZdXpFTmQrMDFsc25Vby9WamZ5WlZZUzM4eG4w?=
 =?utf-8?Q?TtoaF1V9ZbuznWDGkZOtIcLmP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hRyHdIXk9kugeBxgFN6NdUCFueJn+QVKdBdMMLpNY5jcMJ4UHict3nTm8b/XBd6HyO32KfrUWxJ4RYD5iH7CUzOgJDnUJdSgjxhCVweiMzH1MjPsdH1eYNGI6VuwUxoQjNuXP1FwnHBeRmpyJ46EWUDKBTq+i2wCncPXJl4ykpolfkQ+2RHJ4tcoGMpe1C36Kn1wSE6inE+CfyvowxPpSBsuqqFsPTwhs+j8JVOKofDWR/dfE8iXC8CKfM6y7UQuWxW9sow5ivslCXZqSnwKUDSGk5o9cXQLRU4wo8yuvpvWakEqtmZmatCVNC9Zf2nqqAWUc/Xi5kBwWWowxkF2o6WN4+fm7Bl/VvtOokg3ey2cQKqaFPm9nnqPw1r/uqhdkr+sjqBTaJBuge0yY+pPngdvWa0/TdxXhJTyLw2rFRXXvUoh8hBU2deA/MY/p7aGmMHdKJ3cQXarVnejfcoGErS/vPJYyJmor8oUV6IbXrdyvxwCHVIG1ivsmJoQBC3JpB6er4mn2v2BZtIduEsaFxsGB3wG8voxLlFeDz3oMjK+72cWqzpsluf9yd/QZIIiGSGELrN0SqjW2QhwnIfjB2mp38SCytSeb8/DVehlx9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ead9b7e1-d599-4e8b-0764-08de12e0dd03
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 09:36:52.5396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWZ7IzvYjIaKH1TVdYI5PFvN8DOonQ4SDmMY403E2ybOCFl5AstckLyXGMN2hOCPgbQ+29DrjqH3yIn98y1C0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240084
X-Proofpoint-ORIG-GUID: LmPZsHlmyRBrK84rK-OtW0ufpIGKoX8t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX/0/QHN+uiScm
 JZKCQTHIjdOJJoPmobgJJKNuTRODLQn5kiH8Obv7WLt6Yy/sheAh51adP662R1CP9tn3BYLB+F4
 uiQSQ9aJosrKWsNgUmp3hN/rvmx0t1g9uuDHs7yqbBxs3IIe4aXZ0RbSWmtK464brYPUUI0bRdg
 lwRMSC+4X6Jw722zvCl7zqpldoZ0LXvdPUHEz0X6800I4N0wL8I3dChU8ou4aAsSlgJ3earQvo5
 6ZAZbC+bvFbx2+tPBDTs8dTg7Z/TxOYjTciYMIfXiWhjaYn6QR5/gIf6SXJNhUnsc+iX2Xsor/3
 tPWyMt/c2r1RA/9LW0IxNqIWJimbmVCfybchluxRWbCWcTtv6b0renJ1Qguz9uYTVSbsDX/0j4Z
 Ecimtnkd7BFPyrlbH23+nFAg+/mYJfGoLHrT0+wTI6aQaY6HIsM=
X-Proofpoint-GUID: LmPZsHlmyRBrK84rK-OtW0ufpIGKoX8t
X-Authority-Analysis: v=2.4 cv=D9RK6/Rj c=1 sm=1 tr=0 ts=68fb48b8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bC-a23v3AAAA:8 a=yPCof4ZbAAAA:8 a=R5Ygti2cTUQD18wig70A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 cc=ntf awl=host:13624
X-Rspamd-Server: rspam01
X-Stat-Signature: pb9co113yc5p1ixw9atwy6gtqhnzrr7j
X-Rspam-User: 
X-Rspamd-Queue-Id: 2057E10000C
X-HE-Tag: 1761298622-106569
X-HE-Meta: U2FsdGVkX19J/X8ddHJDOvQ+cg8XTRSGO5cHKc48Rp2qzsxj+KpBlzkoe1HYwas+mqkg83w+U+i0y7E4GkjgVjkAc+s7thVTUvvr4GKHfdKWnf1CbjFaWYeWXXTNi7jdO9DQbu/a4abOiopHqy/oVwUhLXW4b3/B+aYPk47j304pxgIPJwFkX9cTdM2Fbj1/yGGKR/8++XcyY8k0WIo6fUQnjrhE5g2i57LxIV+oAkuQ74nM/72Fb26cZfC1O9udGEFsFel6omfbmuZqChkqqBAFDmYgQloTShELviUciOx8BZTwcCq2ccj2cpbA+PTQZOmh2AS2cLSDlFwLDFL/UBWUsxaqDpstUopXid4kmV0+kqPmD2A6q65stR6hrkj23j6fDWcn/yXVdmISM+VzCHwmlOf4PR9NneS+qVQeEjC3VdBb/m5768tEr7LuscXwQz4eSS28LIdk+O2ixH3Jvh3mxBrA4jVvYRD3kPpKCAeSbg9Xma75mkKs/lKZkrZ7L/Qm/ab+pQZ067KX1npe7EQxic5xZYKSmErAXmFdXNXU4QqzpkE9ZDiaoeRug1rJsHWxkfd2uWpn+YOrET7kKqrPpo0HiS+xuVDxA6ol/uQkJQYNEhTpGgI4GjgzHbXXQhqt6wTxElX27getE8MyJLMdpHOp/Pt2cH1sJk44D5Qx8kHdvyqTDk6E+xr8rcsub8EdYVcKtVPARaCXO8T+u2/NI5xQr2oIYtvRSdkDKHnODQkwxpk42LTsg2R218ZikYAJRqYmWlkBVczOZi8dVpm+0GmCHlCSfmtBeRJEgEmQdKorrlRC0xhfKQ9KLqR5bd0k24yhkhY0eOlQuiTYp6KI165HuBHqB+dRcK8BPPgDleunKUgabM2L+LZlVOBjzHFkb57zyNUUfE6Z8s9mqM/Burg8aIKp3MG8TbP0jF5IhGzsuwVxf1Zpv4jMJOpcZ2YRFhS+lvXyEZsSL5Y
 negPvH7Z
 22oP1A0nOybMBqKUCaKg7powZS2wUGRsgyRWnqUihSYn51jY7R/58/JnJncBBbELC1sUsy2avfFC/F16UGMJWPExkweOGkcc+TxJM7OM+V6flJo6xz8qaXma1O4ehwMolMGvms7WZIB71EQmZe0afj0wxG3QHn5fc7jn1SH++HuILGciVerozV/zkxGU5q0/r3TOy4EWmc3uPJgMlnx3e/8serlA8jZB1/VJRkHqQ8OUmnhgdwKJxTxGB3Dvj0j4Ot30R0BjWVr0CCWZkplLi776Ae/D7M61l9wtzNy8SAKIqg53biUMWzG7NTBAPXsS7vDtOwogVH2YSAV8nR8wx3U2ioDv0UvFqdpaV73OLxPxjzD0/VkKp4G7y8GBEN24ZyqysqNexvq5CjIOfcrD1l0kwwYnyK3ERweUIQ59GyVd/69JHPI9HfY9njbkYvITmEYMbTuYmyu16nwyXFUX7Fy52c5EjVPYcq6Jsv8y2ZgktdqjWnGTjO78aseBBk7UVwJ17Z2oXAPQ1yAjN1Hq8E6T9jsJYQOQ474qhSeWTx9uEy+LIAE7H0jjQsvjlzf/H+vG/VjoydmD0aOADSVykxuU3m36k2M+Bi9yC8BtBtNscn0Z9gaDYCfR+G/kFOYEj+2iXn2msi/bxKunhgyCZFU8JRr0uRQivmDYjSqihPKdx/5Y7a9/WsuKbl9QYmZfLI5baZlF1aJB7AybMQpnzWsn608KMmmQzfOydGfvBQsGb3HaTa0DrquF9246VEKMC7fzI0y7aZLaNa0DcwBBALyKpRN26c2b+q+zdItcORbpSLVZ4ntE7pvWBBAX3hV7LcbYveH7uhYt1/zIB5tv7x5k4W3X2FACn4q+Qh65n++cHDKZFTYIIZcJHDbBYxxzCGOblw0j31y/mqn90mQbZvfe1Ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:55:20AM +0200, Vlastimil Babka wrote:
> On 10/24/25 04:03, Harry Yoo wrote:
> > On Thu, Oct 23, 2025 at 06:17:19PM -0700, Alexei Starovoitov wrote:
> >> On Thu, Oct 23, 2025 at 5:00 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> >> >
> >> > On Thu, Oct 23, 2025 at 04:13:37PM -0700, Alexei Starovoitov wrote:
> >> > > On Thu, Oct 23, 2025 at 5:01 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >> > > >
> >> > > > Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
> >> > > > kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
> >> > > > that we discard the newly allocated slab if we can't spin and we fail to
> >> > > > trylock. As a result we don't perform inc_slabs_node() later in the
> >> > > > function. Instead we perform a deferred deactivate_slab() which can
> >> > > > either put the unacounted slab on partial list, or discard it
> >> > > > immediately while performing dec_slabs_node(). Either way will cause an
> >> > > > accounting imbalance.
> >> > > >
> >> > > > Fix this by not marking the slab as frozen, and using free_slab()
> >> > > > instead of deactivate_slab() for non-frozen slabs in
> >> > > > free_deferred_objects(). For CONFIG_SLUB_TINY, that's the only possible
> >> > > > case. By not using discard_slab() we avoid dec_slabs_node().
> >> > > >
> >> > > > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> >> > > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> > > > ---
> >> > > > Changes in v2:
> >> > > > - Fix the problem differently. Harry pointed out that we can't move
> >> > > >   inc_slabs_node() outside of list_lock protected regions as that would
> >> > > >   reintroduce issues fixed by commit c7323a5ad078
> >> > > > - Link to v1: https://patch.msgid.link/20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz
> >> > > > ---
> >> > > >  mm/slub.c | 8 +++++---
> >> > > >  1 file changed, 5 insertions(+), 3 deletions(-)
> >> > > >
> >> > > > diff --git a/mm/slub.c b/mm/slub.c
> >> > > > index 23d8f54e9486..87a1d2f9de0d 100644
> >> > > > --- a/mm/slub.c
> >> > > > +++ b/mm/slub.c
> >> > > > @@ -3422,7 +3422,6 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >> > > >
> >> > > >         if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
> >> > > >                 /* Unlucky, discard newly allocated slab */
> >> > > > -               slab->frozen = 1;
> >> > > >                 defer_deactivate_slab(slab, NULL);
> >> > > >                 return NULL;
> >> > > >         }
> >> > > > @@ -6471,9 +6470,12 @@ static void free_deferred_objects(struct irq_work *work)
> >> > > >                 struct slab *slab = container_of(pos, struct slab, llnode);
> >> > > >
> >> > > >  #ifdef CONFIG_SLUB_TINY
> >> > > > -               discard_slab(slab->slab_cache, slab);
> >> > > > +               free_slab(slab->slab_cache, slab);
> >> > > >  #else
> >> > > > -               deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
> >> > > > +               if (slab->frozen)
> >> > > > +                       deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
> >> > > > +               else
> >> > > > +                       free_slab(slab->slab_cache, slab);
> >> > >
> >> > > A bit odd to use 'frozen' flag as such a signal.
> >> > > I guess I'm worried that truly !frozen slab can come here
> >> > > via ___slab_alloc() -> retry_load_slab: -> defer_deactivate_slab().
> >> > > And things will be much worse than just accounting.
> >> >
> >> > But the cpu slab must have been frozen before it's attached to
> >> > c->slab?
> 
> Note that deactivate_slab() contains VM_BUG_ON(!old.frozen);
> we would have seen this triggered if we were passing unfrozen slabs to
> (defer_)deactivate_slab(). I assume it's also why the "unlucky, discard"
> code marks it frozen before calling defer_deactivate_slab() (and this patch
> removes that).
> 
> >> Is it?
> >> the path is
> >> c = slub_get_cpu_ptr(s->cpu_slab);
> >> if (unlikely(c->slab)) {
> >>    struct slab *flush_slab = c->slab;
> >>    defer_deactivate_slab(flush_slab, ...);
> >> 
> >> I don't see why it would be frozen.
> 
> c->slab is always frozen, that's an invariant
> 
> > 
> > Oh god. I was going to say the cpu slab is always frozen. It has been
> > true for very long time, but it seems it's not true after commit 90b1e56641
> > ("mm/slub: directly load freelist from cpu partial slab in the likely case").
> 
> It's still true. That commit only removes VM_BUG_ON(!new.frozen); where
> "new" is in fact the old state - when slab is on cpu partial list it's not
> yet frozen. get_freelist() then sets new.frozen = freelist != NULL;

(scratching cheek in embarrassment) You're right.

I was thinking that changing from calling freeze_slab() & get_freelist()
to calling just get_freelist() would make it non-frozen, but actually
get_freelist() freezes it! My mistake.

> and we know that freelist cant't be NULL for a slab on the cpu partial list.
> The commit even added VM_BUG_ON(!freelist); on the get_freelist() result for
> this case.

Yes, as long as it's in percpu partial slab list, it cannot be NULL.

> So I think we're fine?

Yes.

> > So I think you're right that a non-frozen slab can go through
> > free_slab() in free_deferred_objects()...
> > 
> > But fixing this should be simple. Add something like
> > freeze_and_get_freelist() and call it when SLUB take a slab from
> > per-cpu partial slab list?
> > 
> >> > > Maybe add
> >> > >   inc_slabs_node(s, nid, slab->objects);
> >> > > right before
> >> > >   defer_deactivate_slab(slab, NULL);
> >> > >   return NULL;
> >> > >
> >> > > I don't quite get why c7323a5ad078 is doing everything under n->list_lock.
> >> > > It's been 3 years since.
> >> >
> >> > When n->nr_slabs is inconsistent, validate_slab_node() might report an
> >> > error (false positive) when someone wrote '1' to
> >> > /sys/kernel/slab/<cache name>/validate
> >> 
> >> Ok. I see it now. It's the actual number of elements in n->full
> >> list needs to match n->nr_slabs.
> >> 
> >> But then how it's not broken already?
> >> I see that
> >> alloc_single_from_new_slab()
> >> unconditionally does inc_slabs_node(), but
> > 
> > It increments n->nr_slabs. It doesn't matter which list it's going to be
> > added to, because it's total number of slabs in that node.
> > 
> >> slab itself is added either to n->full or n->partial lists.
> > 
> > and then n->nr_partial is also incremented if it's added to n->partial.
> > 
> >> And validate_slab_node() should be complaining already.
> > 
> > The debug routine checks if:
> > - the number of slabs in n->partial == n->nr_partial
> > - the number of slabs in n->full + n->partial == n->nr_slabs
> > 
> > under n->list_lock. So it's not broken?
> > 
> >> Anyway, I'm not arguing. Just trying to understand.
> >> If you think the fix is fine, then go ahead.
> > 
> 

-- 
Cheers,
Harry / Hyeonggon

