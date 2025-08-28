Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0172FCA0FED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 00:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE666B0031; Wed, 27 Aug 2025 20:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F746B0062; Wed, 27 Aug 2025 20:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1458D6B0031; Wed, 27 Aug 2025 20:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F259A6B0031
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:48:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A9691A08EC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:48:07 +0000 (UTC)
X-FDA: 83824329414.04.01C3352
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id C0F48C000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:48:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SlwHw0Xj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Aii3c+Ze;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756342084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJwNI8W+n1vlBHUhI0Zri7j7YF8BZ1OUaL2AMLLUUOM=;
	b=AsXbnA6nxDha3uS83KIs0gnN8cBC9HGeSU1v/RmFnDj02V2fGZz/bXTpqbP4jhBRhukjGU
	fhg6uJO/OLt7bKn4Hf+Yjdmo9wQtdoLgGwYYsn4whtolecG9qHrMmZnqcnbCR6bIYP/QOl
	OkkFJlr2f0leoG/6UObgE88wdzSXqQ8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SlwHw0Xj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Aii3c+Ze;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756342084; a=rsa-sha256;
	cv=pass;
	b=XkcqwLlMLZcHiN5+d6w9Qs2CA37pB+bDKWg0d46Tl4FEiMlo2F/oRhXlAtECqCv3sZbzZe
	6XBLbR0qoaUXMJhHXdkYynCjnd9tWD5YdoqupYZzNpAZd/iLVRflYnzJ8hp0+Ap3wCxdb3
	egG71bcr+AJhFs/tfSJLWBLqg792h8I=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLH9WU007649;
	Thu, 28 Aug 2025 00:47:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LJwNI8W+n1vlBHUhI0
	Zri7j7YF8BZ1OUaL2AMLLUUOM=; b=SlwHw0XjoHE/t/8iYpY5+j5k+D+J8Q2WBJ
	Ud485IAiBtYT9mRZmITQVUl/NyVZUlXEkqrao9PMmsDU3pe2lqI0ke+N9+7C7q8m
	PxeuCbSspClEqcl4AoJqUD0W3d5FjG5rK/BrZkoDEONCApafBEGmYrwJhqvfplkq
	EV2EC+ixmilSrevwA/tfV6mNNgLS98GkltkUPxUIEV+DV1bfSdrEhUG5Yrjgd0K1
	SVzuDt6dwPLtdE3SMKtdLy9Brd4Vyqs8PN2jZemMS7SG+oz8chZ+M8hPO8BdkUhg
	gfnCjESeEtq4vnAiKRSFmmbhyHY38uNxyjulnPYzHibtjDoBn1pg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q678yjde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 00:47:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57S0OcGG018987;
	Thu, 28 Aug 2025 00:47:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bbjx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 00:47:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=haTioxQdxRHhrDrgmjGW7pk+MOYSUQP+jB1+yT43f93LN3UetZe/P5tm9U8oLYjc8AfHUSdTEWdgjYT8CgHGKb8mSNZR2E+LwHUsCxk+K8r8mkVWs6PkCSR8Il5ilvV0RHsEPhGH0m5RtRLTeh9ik6znA2d53J3MAI2u7hy2cEcR9fMxOOKFwv+4Ojm38iFxg8hdcEsx2/mNq+9XzwtmzvL/lZi18dnAzq4pF4z3ZseHSIWArrz19R6PcvGe7jUxR3Wt/xuX0bmv9ylWI8QUnKcptgL+P9f62BUPrbRc4iFr+KG72ptUCQBX+y1pVy3JTIvqoMIF81gCJi2cCFy0TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJwNI8W+n1vlBHUhI0Zri7j7YF8BZ1OUaL2AMLLUUOM=;
 b=NUY3fIjDU4Q+f4XgEMoSi84UDyRYGQUYpYVV41lWzCBqjZjFdlCTFPnf0BbKMhaMaenHFjU27begFvPvodlxFW/vif8/OY83Wo0X62UBmRXTrZpWwih2CJsGXI3bSwKDV+ZoEwMUes8GnbM7eEILoI83inCerhb4nUakhjT1xXeP7gs4Hn5VeAFbSU/Q+T/6s09FgdL1SpWL5SrfFBX6I36UEI1YNwiufyaAriWg0fJoYUorIEK5bohibJPhKJQpf3GDMgygrJzvesFjaaDr9v0hmqGDanG2EBf9Nx7YsKHSsOf+/1tro59r1IJD1NNW4Z2YGa+iknE50aNjycFsWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJwNI8W+n1vlBHUhI0Zri7j7YF8BZ1OUaL2AMLLUUOM=;
 b=Aii3c+Ze84wJKYV8gzIfbPWqStF96wiH6mUAqaHYOAy7nn6OxZ1pLlLEVM+D8cZkS3XsF2nzzLNKuTw1av4Nm6KyV9GpUzGs57b63uyRdgzZ3k76MJZwGRDpGM1HCLbk7UqZXemkBWpJIY8Y2mBPhhIff+mD469C8ypUbkRivIU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB5871.namprd10.prod.outlook.com (2603:10b6:510:149::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 28 Aug
 2025 00:47:38 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 00:47:38 +0000
Date: Wed, 27 Aug 2025 20:47:34 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] init/main.c: fix boot time tracing crash
Message-ID: <bkhys5kzugk3sxiidevrwsnscaqv56sqk5b3gifaarbmmonf6u@t5wnounv653r>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
References: <20250824130759.1732736-1-rppt@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250824130759.1732736-1-rppt@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW2PR2101CA0036.namprd21.prod.outlook.com
 (2603:10b6:302:1::49) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 0950b11a-9572-4d8c-7f05-08dde5cc7cab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jWvF5rwelokjLhjvi16VDqnBVmsCkHuZQezFNedGVjqY0zA0BHK3JVCw9mu8?=
 =?us-ascii?Q?4/B0JhH6jnOLLMxPv8wJK7c555JD0gpzndKdalEosh5nDDwWJpuURWt5Mzif?=
 =?us-ascii?Q?ZvZOi6aXSs7ffrS9UOEwBoAv9aP8G5jYiyWeyYGCcFgmyZg9Sll6q79etYSN?=
 =?us-ascii?Q?iQ/BF/H05wHZYpiqKogLjNY8Igmr05W/Jny29Teb532beUB6ogR5PUZPDjU7?=
 =?us-ascii?Q?uk758T9c/zDshxOTUnv7RXs4fWQ57avfikChs2Eei4Mpaj7YMh2QljaS/Jvf?=
 =?us-ascii?Q?sFicWT7O+26GQLO6oOrbYvnWEJqZLSnpRHVZ1/l5l//YzON6KG5KRmJs7uC3?=
 =?us-ascii?Q?pQYKLLLE0wMHvHv0B9hjLy6wIl9e1W45lNnSHH5aOXuu+R1J7QLQatHFcyQV?=
 =?us-ascii?Q?0jMf3hB9tYIo/Wx0l9M8LTGYJXbrpBDjqpWzXSe/3ApVQzIs81dQLuIGoyIO?=
 =?us-ascii?Q?9iNSimuuwEfgZ70xXJ04At5hU07sdRxX9jSohoxydTUV7YUMG5XCQ9CdJW87?=
 =?us-ascii?Q?9l/TYKCS3M498Wg9czEGxl/gJqPmdg5W7tBCnFF/IS38Mfm1fZaDcCS+J5zX?=
 =?us-ascii?Q?fDmV8xvgXb+NisSooZo9jp4/kHME5KT8HOoz/jKhSXp+FsYDRsunx5uVkktl?=
 =?us-ascii?Q?f1Ng+X5KQgcp6QzOzuDHiiyAJ9mi9iM1c6k0GK5EID0yTzapTkux3g40pJ0L?=
 =?us-ascii?Q?5CLrkRrBOV8kRGm6Hr1hQS/xZ/TbmJOAQ0M1U6w3g5pwzw4ZQjh8w6jDWin5?=
 =?us-ascii?Q?+eewZiNibOc7bG4Zydq562qHdpm5yrUrLYqsnlOVt7g05NyQJgstznaqD0uY?=
 =?us-ascii?Q?9knxB9jv+GdY38oeD2oxvb4uyxkWFXazpNYXyZXy9siQUcsVwFC9M753VKQd?=
 =?us-ascii?Q?dPS30lYKK+y85fAvntI40cuG7kKhOAPKEUTRZsVZ5X1VPqtcph3wwL3GydoQ?=
 =?us-ascii?Q?RSm5PWfv4qvlHXLROiHHzsaUp6QL/cuKbZbKQOIjS3FgNNtyPGZHOAV1XCjI?=
 =?us-ascii?Q?yWsRlTJpfmnLVblu3iK/3ccONZEiNH/biuGRP3HLejSnX+dVHAr6fUj+aG/T?=
 =?us-ascii?Q?kqo6+IVtOjv6cB/xpkAReSOpSt6XQtJpsnBu/N61EeSDqUvuN7PwpQlRtLCE?=
 =?us-ascii?Q?ePZrevIbaUc0NY/OVFM43CxgqkDTiw9X+yVFhUfQyVOVwezsSq6EolW7yuzl?=
 =?us-ascii?Q?QWrz4v7Qqqv9SIM3TVwvfZHCOEyE2UWHiEpcSBgfZMgD/mYBHMkka66vFCPe?=
 =?us-ascii?Q?yRs7EFrNG10veyHORIsVWG3PyRrgrue2OqZ25R78cihnh8tClMZM3oicsQ/B?=
 =?us-ascii?Q?MtOeTp1t3XXruJHFx52ZkoMMgI8B9LoB9agM2HD6iOYExcV41x7Svbm7D3kc?=
 =?us-ascii?Q?Ddmf/a0JFaD/jcd6BXXdfsEHm2tIJontBCBpAlVI+on3+Pd9FkOTQl6L8/8T?=
 =?us-ascii?Q?aYoZHoVPixM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GnvsJk8hrNw3dUX2EiOA4VzAB+0I7klYd33lrIXZBKn3+XOVGpdnOUFe4CmU?=
 =?us-ascii?Q?O8/lkZSBqtrGHT5BgCGW//8k2hkZuzT+4adbQefwQBpvypXRdh3c2aDn2fR8?=
 =?us-ascii?Q?jW4jAx5mPKTL8r01qfZZUBmIn0Gl8t3+LTCvv3bP9lTUzMcsuHlZJbVEkri0?=
 =?us-ascii?Q?ZmwySUI8XHTFXex4VC27PqR/7YY8JXvdoDYGt7E+OnVlF2wSM1eQCSuOESXK?=
 =?us-ascii?Q?N8orKIUCCvVZu82dYeuqYbzYU7C+fpZDdexUEUpNfshMgN+oMEVrfytAXgnv?=
 =?us-ascii?Q?FbKyLtppN5QtrYCAptvzGc9mXprkz+y8bKFTrRakYKILExNV9ARIY+EYCXBa?=
 =?us-ascii?Q?S9W3ydQho3y/mLeTM3PRPzK1W5yZO0c1TDWHvjUKckiraaZcgeR3gPpbuotE?=
 =?us-ascii?Q?2E6w1C5d5rC8/a1i7wvQcJCeXvm0rodF1eQyCrUUbH09kukS9TapEf2Sa4KL?=
 =?us-ascii?Q?did6qHkt+LeJTBBtPzJycbxbpuefzcvRQlUz+j/7Nn2NoXtFBbuDfDru9zlm?=
 =?us-ascii?Q?toERn35otCqk9ut8pImq9m67H/cxX7KWWrKM+OpWgppFWnss0LmrFZVNne47?=
 =?us-ascii?Q?rslbPzrbXalwwzQ9iuE7XNbZy+wc8JTNFd3jrzP02zp5ZpgGyHc5wxQbiyka?=
 =?us-ascii?Q?tWaTS673Vv2iVN2IG/UWbNGfVUsKd8I1MhmXP7kNcHa8Kk2VGOEFMI3LYvDM?=
 =?us-ascii?Q?NOE8t2muYyX33jNJTpwicgmxm1Gwf0rLPNn+WQQLUEmS9OOOgBkdyrguAt0j?=
 =?us-ascii?Q?jBya6Q5ij7fYzMXI7H3Pgo6Wfwoq9BikQU0LGeDuVc2dFmnj90oDXAZsdA15?=
 =?us-ascii?Q?KeLseZWgrCPMwIin3ZX5lED2chCksG20HELPNo9WKoYMoHnhfucdNn8ShdMO?=
 =?us-ascii?Q?VaIA2zyokV0OREakEYEA2we0gyba2jy793zfBMmLwR+lww2JGavQ/9uaNFt7?=
 =?us-ascii?Q?uPgqD6Yb3VDP130H5cLHV7156TbCR836iPWoMGVziumrqh2FLJwBlhqkWu1V?=
 =?us-ascii?Q?TppzNjLDceUg2lQx3gwHZLF8s3UASpXED64a+5yJ167qvk6nvi8Yt9XNNvrs?=
 =?us-ascii?Q?c900AQwV7mX+VIcYJ1n/Pp1hgLiX+PU0zwsTCwzDwdo1LLifu+5tyLiTnu2e?=
 =?us-ascii?Q?w/4Br+tO61/RAsS5E0g3cdMgLBxDrNLKgDkny9GIcRpV4a9TQsz+Be48r/Mx?=
 =?us-ascii?Q?rQ+XIxya6zmsc6DSkCmFKuG3MgXYZfpDWKNeNICIMvkAl8XN/PNaH2O9gt5S?=
 =?us-ascii?Q?g6hIhUtqH5qYR2hzMp+1CLNCjcoh0jy2vnqj9MNJcAzK2feOk+jZsG/RAPNa?=
 =?us-ascii?Q?rhgcCE3mjmLHCfk8NNBHCb4F2JypumYsBWahcdTt/4Rl80OuAd2CcOE+Wwhf?=
 =?us-ascii?Q?JFVc/pNdU9HV6ItCLoaduTfoHQosqfnBa/cX+EH6uuGpNIV+vtGSAP3nuXMF?=
 =?us-ascii?Q?mIHra+KWkjQt6gHjEyDSFtsmDt28B1n/QRxMuxOZDJP4WhwEJXK3/7lT//OD?=
 =?us-ascii?Q?G7+2A6TSIJLfvRvRQ62sl2epZ9qcTD7HDOT0oqC51IQrSUVY3Ehts8vhcazU?=
 =?us-ascii?Q?upPllt6CnqjcqEnBNv6ynRVY26CEHWuAcrb9ROU0YwYzP1/+f39+54X3QM5x?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rNfnuBGtl1kXVoj1pmb5gmTAOdC7yQB5g0ThhRyNtHNIkUMv3GRyAv+qoaDcLzvzEpwk3L5JDCUznAnMumyd/YYwN1YTOWj5nOV8lsITHSFABeUgqdOgtcrwZOwSgN2pOrMa9s9AvFCMrpF/LkFwMjgR+YjfXrBFMDft7TXS12DE92sqLe68ibI+dSw991UkOoXIOetXffnYulebcfj3D24UAY2q67d1diNgJhIEXcZg51fHrmYkqx8N7CdNlard0Gukd+WyYCjZwWL5xFMfWKNYsZeBkYRld9dohsGsO18L0nlDpmSAMlqxfdv5XwYZunCuuGjfj4EQKRbDd7PWy6/8+bbt7HUo3FdnG3VFkU3Tr+/SCbA8ZoRn4dKA5BuJVtvj+kQo72TlS1j1yQO0/Ey0QnhV7KtS5Kt2GjyM+DXAOjnT6nOdyctdufPt5yB0On2ElpsrQAyIHAJp+j0N360XbFXCg3YkhCIUmAtwP7mpkeam3W0dSDSm9xcKTOmV+ZXR716nGCbNNJwVShS1i1/Z8CN13kTYXxWzJbivB/YC2TkQVCJZ0Gx4h3/so08tU93KJBnvqjDiYcL5FqPjuiD4z6f48HkM6o/H8WovhIY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0950b11a-9572-4d8c-7f05-08dde5cc7cab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 00:47:38.6315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /erjBhB6g+63cwfMfrjSR9ilUuKliIoJ0okydgc0f8a+yPm7wQznl/mtnXM0MqJrHy1/vrhMEcT5jtmPsDD3Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280004
X-Proofpoint-GUID: DYavpTSQTo5J12AwIdMURQKEKoJvbmE4
X-Proofpoint-ORIG-GUID: DYavpTSQTo5J12AwIdMURQKEKoJvbmE4
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68afa72e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=CN1skhrW1adg5TW2ImsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX9+8UrEC6aUqQ
 nTymq7uWgPRcx+j2fNOEi7DOHGSRbzhHVQ1+FSIE3y9j6YlhkA2tCsrmK6XoO6Ox5mRtTYcGJQS
 ttORP7opPquoMilkgVFucYfmfwoDXYcyC+1/P+2zolnL26OIj1LMaBGbC9lYPvSbiYLXE69V98o
 1B7hnZ64Vfmbh59prjuuOzdfsOhDJtZcD3yaiWv6LVV4FW4ShK3QSVkZZ4Utw9YkXrTzb3xRR6l
 CZ0CbkVlgOFtjZ9iOEdhgJGiq63tXxwtalXhBy7J6KOY4e6IWkXI8uHjnu0RQNq3zMEsD/tMTVO
 lsyTwav/Dku5LeoQ/kiosVZQieLxyPo2UcDrL2atALvfQMTwJ8S20466QDUMOvZpItSQD8s9c/R
 U+XJwE6l
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0F48C000F
X-Stat-Signature: k837jpt6tt8fzzp1jdcnhf3fqrzboxme
X-Rspam-User: 
X-HE-Tag: 1756342083-986906
X-HE-Meta: U2FsdGVkX18Gxs0WYoLP/HfNTzV1HKtJoZVRw+9S+7Uf836Ug0il9ej4MEqTupGT8qtSAGE3U/kkcZ9YuvCl4Jv8oqNZoh2ZGEW3/J6jZIn+9I991dpPCwTepYy/m2ESpKVOm+stWiBEpba9kG183IYPNHa+/7tSn/hou4TCxmWbEF5Owuqz7nGStPANINK+NL59vNNn+LFrTM+i00/E84WPGJv3P0ygTy+JGJ2JUiawuh8AVXDe2sJsS4v321hci4/+dkKxwGodcUeXqFTJVixJ9eRDG3JfS6HgMKnaDbaD2jtKe5LcoUSRhKZwNAePRz4qM87DI8t3zB8Ju55P0LmIrR720XuXJkz2EQxpBk6oDxizSQ+O/afQCn7zQEtAyLn57247MyKDetfEIUrGynrjrp5qrcxjzIWCpAPDW6y+L8yNWk9tKSUPlzTogK4TAjcNGqTbV/CGsZKA2CbzAja079UdXZbPr/8dVVfkNzG+SdbpIAG0RfZfGm78rhWk6XwiC63QGnRliRGBI/L7Imxh7leZNrQ0U1hScGV8fMg4oB6Zcaq0TDdIPzF7AFAFocQZ9dmR82A9UlFf0FbU1Pu8GbF90H4PqhlB7CMOtmObTh/GSQFrkCcP+G2K7FO+LxqDlM/aEFULdnohIUrCQRpqzZjPiYCy4KVGrHakkKS1eAgMz4DtxhdTvtTmnBERPPFIa/kgIVWl6QhDW7L4RvmKLqtUHS2S7Z3OoFFFZSNFabMakPipsIl8JSYadIrRoQuo6rPAZ1Z8FucMPHcrGi8M6MNzoAFTqX9j8I7w9f6dSYVPBpawpPtKJkL1+53VLDW6tT29V/nPiHRvmhpyrAvYliZ8OJAxBG/3ats2H8f6V9FHH9iT+pGTKHzSF/b6368MlwKlJg/qVuzkZQSwPIGj0gKNH+RNYDqJMURliMPBDwZWY5MPRkHZ/fSjaE0Oee77DCENesKSUauomm7
 P+JrRSvQ
 4dRsOQg5GzvsKv/t37HNG73Q1cIFWTiygQ1Na7ry77ENc1sS6dmMNIGOnLZ5AkWGHxBFbUqP+rQYyCYLVutP3PuTIuxr/44Tk5NJwkNculpAiPk8aRXn/ygVBVpAwSJd5B9dQEnu2Bwl7YJrMTMbgo4ia6cgYnZv/CNMxXK16ey2GgI+M1lXgbbGM9GoVbyknj+2FQeBaRFEVO6WufFd2TkuQbFDHSFRUqf3sQBKF6Yc0N+Y40IZHMFleIm4OHQNfJPEz6Um6MxJaxTmPYz4HEnuBAQWvkNRElDOT6Y7XJ24mcA21cCTEJeXXE+Rni4iJC1ujJ/xuqeL18J1PaLTHWo6XMAx0GCa+oGz1nEaNJsr1MWiYK7rxiLEpGe1HgdmgRBhDlqGyg0fuyM/qJbRptk3911N1Kehf39fNA0Rsf2mw1jSnQzMJZyk/QKdQEPqLJLdHK1dtONuf+OUN8PeHOpFWxJqYmbxWiTyxzi2bo6VbmZRI/rZwqZff8f2iVAlb99GxiCuDwUGBPIoNdNjMWP67v5cNjrYertCQQUb/96GATbywVi87Pei2N4PXxEIfs6u2uy/eGrAxeWxXXOM0dsfObzn/b2+rtnemos5ZkQZGKAAEO5BRbwiDIWmkzqbcmABrmDnT/quNamhvEWmGrFehHB+DZ1cDS/yrwOF220xQs9pTc5C/us42JEQnU2hjcoeZSyfXq13r5Nr0prvnTA07FcO7UUdDu6ii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mike Rapoport <rppt@kernel.org> [250824 09:08]:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Steven Rostedt reported a crash with "ftrace=function" kernel command
> line:
> 
> [    0.159269] BUG: kernel NULL pointer dereference, address: 000000000000001c
> [    0.160254] #PF: supervisor read access in kernel mode
> [    0.160975] #PF: error_code(0x0000) - not-present page
> [    0.161697] PGD 0 P4D 0
> [    0.162055] Oops: Oops: 0000 [#1] SMP PTI
> [    0.162619] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc2-test-00006-g48d06e78b7cb-dirty #9 PREEMPT(undef)
> [    0.164141] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    0.165439] RIP: 0010:kmem_cache_alloc_noprof (mm/slub.c:4237)
> [ 0.166186] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 83 e4 f0 48 83 ec 20 8b 05 c9 b6 7e 01 <44> 8b 77 1c 65 4c 8b 2d b5 ea 20 02 4c 89 6c 24 18 41 89 f5 21 f0
> [    0.168811] RSP: 0000:ffffffffb2e03b30 EFLAGS: 00010086
> [    0.169545] RAX: 0000000001fff33f RBX: 0000000000000000 RCX: 0000000000000000
> [    0.170544] RDX: 0000000000002800 RSI: 0000000000002800 RDI: 0000000000000000
> [    0.171554] RBP: ffffffffb2e03b80 R08: 0000000000000004 R09: ffffffffb2e03c90
> [    0.172549] R10: ffffffffb2e03c90 R11: 0000000000000000 R12: 0000000000000000
> [    0.173544] R13: ffffffffb2e03c90 R14: ffffffffb2e03c90 R15: 0000000000000001
> [    0.174542] FS:  0000000000000000(0000) GS:ffff9d2808114000(0000) knlGS:0000000000000000
> [    0.175684] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.176486] CR2: 000000000000001c CR3: 000000007264c001 CR4: 00000000000200b0
> [    0.177483] Call Trace:
> [    0.177828]  <TASK>
> [    0.178123] mas_alloc_nodes (lib/maple_tree.c:176 (discriminator 2) lib/maple_tree.c:1255 (discriminator 2))
> [    0.178692] mas_store_gfp (lib/maple_tree.c:5468)
> [    0.179223] execmem_cache_add_locked (mm/execmem.c:207)
> [    0.179870] execmem_alloc (mm/execmem.c:213 mm/execmem.c:313 mm/execmem.c:335 mm/execmem.c:475)
> [    0.180397] ? ftrace_caller (arch/x86/kernel/ftrace_64.S:169)
> [    0.180922] ? __pfx_ftrace_caller (arch/x86/kernel/ftrace_64.S:158)
> [    0.181517] execmem_alloc_rw (mm/execmem.c:487)
> [    0.182052] arch_ftrace_update_trampoline (arch/x86/kernel/ftrace.c:266 arch/x86/kernel/ftrace.c:344 arch/x86/kernel/ftrace.c:474)
> [    0.182778] ? ftrace_caller_op_ptr (arch/x86/kernel/ftrace_64.S:182)
> [    0.183388] ftrace_update_trampoline (kernel/trace/ftrace.c:7947)
> [    0.184024] __register_ftrace_function (kernel/trace/ftrace.c:368)
> [    0.184682] ftrace_startup (kernel/trace/ftrace.c:3048)
> [    0.185205] ? __pfx_function_trace_call (kernel/trace/trace_functions.c:210)
> [    0.185877] register_ftrace_function_nolock (kernel/trace/ftrace.c:8717)
> [    0.186595] register_ftrace_function (kernel/trace/ftrace.c:8745)
> [    0.187254] ? __pfx_function_trace_call (kernel/trace/trace_functions.c:210)
> [    0.187924] function_trace_init (kernel/trace/trace_functions.c:170)
> [    0.188499] tracing_set_tracer (kernel/trace/trace.c:5916 kernel/trace/trace.c:6349)
> [    0.189088] register_tracer (kernel/trace/trace.c:2391)
> [    0.189642] early_trace_init (kernel/trace/trace.c:11075 kernel/trace/trace.c:11149)
> [    0.190204] start_kernel (init/main.c:970)
> [    0.190732] x86_64_start_reservations (arch/x86/kernel/head64.c:307)
> [    0.191381] x86_64_start_kernel (??:?)
> [    0.191955] common_startup_64 (arch/x86/kernel/head_64.S:419)
> [    0.192534]  </TASK>
> [    0.192839] Modules linked in:
> [    0.193267] CR2: 000000000000001c
> [    0.193730] ---[ end trace 0000000000000000 ]---
> 
> The crash happens because on x86 ftrace allocations from execmem require
> maple tree to be initialized.
> 
> Move maple tree initialization that depends only on slab availability
> earlier in boot so that it will happen right after mm_core_init().
> 
> Fixes: 5d79c2be5081 ("x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  init/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 0ee0ee7b7c2c..5753e9539ae6 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -956,6 +956,7 @@ void start_kernel(void)
>  	sort_main_extable();
>  	trap_init();
>  	mm_core_init();
> +	maple_tree_init();
>  	poking_init();
>  	ftrace_init();
>  
> @@ -973,7 +974,6 @@ void start_kernel(void)
>  		 "Interrupts were enabled *very* early, fixing it\n"))
>  		local_irq_disable();
>  	radix_tree_init();
> -	maple_tree_init();
>  
>  	/*
>  	 * Set up housekeeping before setting up workqueues to allow the unbound
> 
> base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
> -- 
> 2.50.1
> 

