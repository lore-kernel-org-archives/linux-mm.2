Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70C2FCA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886E66B0030; Fri, 29 Aug 2025 05:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F826B0031; Fri, 29 Aug 2025 05:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7262B6B0088; Fri, 29 Aug 2025 05:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60A646B0030
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:57:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D694811967F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:57:54 +0000 (UTC)
X-FDA: 83829343668.09.915C63D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 624844000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:57:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="k/UKy5nd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NMzsDObR;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756461471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlpgPktm0NPCJFHN8TbZh1Xfa6Vg++X5BrSL4X2eJOQ=;
	b=CwGdmCOooyjNkYA5qdvJFrZHjR4pLJUSsvIDagJsfWrhqjiKTDD6f7ZuBQPtMYpPS8v571
	mB0xZhC/PlcFcof6eRnseqAyUD35vfP5CjNXD3eoMAmh7LeYpinW47yf3YPFxNRYIuyEgV
	+HDBvGFmqbFNlPS25o2TxPp5cGEa5s8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="k/UKy5nd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NMzsDObR;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756461471; a=rsa-sha256;
	cv=pass;
	b=fmctHXbMBelZS9MzhgIUCkx5i7dGtm08BTu95bx20CTSLrFxWgS2CqOe8R7Xhx14bUD4Aa
	z0zw1bydkqroUD8iCBd2+8pUO14Nu17oVV8er7r+q5fyB90KSD20Xwo/pyjM+QKdQ5kCFB
	K1U0G7S6NqOPpRZhzFNLwDpB/nzw05E=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57T846xL010871;
	Fri, 29 Aug 2025 09:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JlpgPktm0NPCJFHN8T
	bZh1Xfa6Vg++X5BrSL4X2eJOQ=; b=k/UKy5ndvPP5iDr1TZw8rWjGD2vOMXLRxo
	VGhsaZf1eywOr5TWFB+yTdVw0vwGmmrcauEkfVzZxEWZvNpYDKRq4R3eP9j1bEWj
	6pPJqX2nzsVlWh6i2+NQn67XEfekiCn5n0cCeSdDNSbeT0keFoT2g4dfPI7gs2G0
	Juv4co2zOupmQa9l/1Ok8ES0FRNyoi5cQwBpn03nBYHiq7fp5TI0QUlCSpBaw/Up
	uH1xhpr8tApWOfTWwqP+1C5qBYomhkK/CT38vmMetBIiS9OhaerPU6VMWiTyFPXQ
	t/7+j2pePwVsW2jreA1ShlEk30gQIjKVEn3ME/3N1OjYiIsHpW3A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jat7ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 09:57:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57T9A8o7005011;
	Fri, 29 Aug 2025 09:57:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060.outbound.protection.outlook.com [40.107.212.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d2n5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 09:57:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKnyJdBfmFrLDoYYwnPjyv80iga6ownS4tH8ogWehqpxadLNucrD9+Lakf61KpGvbEYsX67t6h7SpHNq90xIyKump8qqxkhaBhgYrkTn95eFih0YoBZGX0HId1kHuFti7IAToIWprVaHImDsLNcRuR8Jnb831KcaOdOCHFyPxLCOdZ7c5pLliqgRW6pT2R5CDsZcDhUqwctMwGL+X5vXesqCMmWVxN1Ra+gq1JLXYz1mnEtY30SRvxvX0YEGoNuCaXGDJZrJ/L+ZCSeR3mhwaQtccE2hqVdWWnJlKO9zX8pFG+oChHzQfBiOpMWGSbxDpSfntSv3MSNPJJdPqnNYwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlpgPktm0NPCJFHN8TbZh1Xfa6Vg++X5BrSL4X2eJOQ=;
 b=R5cfhg9SLciBy0iuwCpdUknij/BwUwVYsNkAVm/LQt674k+/HvMBz2VwSAJTU9uJJ0M/0uE7tyxCLbQ8zoLob8HUVj5rYMmnQSIedAx8QzbwirzouPWToOhp0KZNAc7loItKmFmUFMTo44WOOBJLjQUbu8rdBQbT/Z49VrvTSIkMjbuxt30NrnG0y/X/3Cw93+pZepo+qibAqQUN8hEMuOg6qZDeWxX7nYcyM5kM2ooPgpgttzeknJ/QjZHk7iJNHT98PmfqsuXLZIWA9wtNmRRko2J+lsEKodw5vKSlhbAuFzXOGpIl+vuJ9Ftzo6A8nZAtGAfr62/IyDjmCZzQkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlpgPktm0NPCJFHN8TbZh1Xfa6Vg++X5BrSL4X2eJOQ=;
 b=NMzsDObRPPnkt1QbFZFPRQiu6m5feBHNVnT+2HYUSF71syvzZWVrom2kEeR5wZ33cPNFxvmkrQithaP84PsJ/v93NeF2Dcmyf1QL/VVZNM4aNkTWG47xqbxOl97HjFXvTXV6wD3oT3QOVJNXmmRxYJLHT7aklB42s6etcyOPghQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5754.namprd10.prod.outlook.com (2603:10b6:510:148::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 29 Aug
 2025 09:57:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 09:57:36 +0000
Date: Fri, 29 Aug 2025 10:57:33 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        liam.howlett@oracle.com, surenb@google.com, liulu.liu@honor.com,
        feng.han@honor.com, tianxiaobin@honor.com, fengbaopeng@honor.com
Subject: Re: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the
 victim is frozen
Message-ID: <dd7939ea-74de-472b-8b00-b4d982eedcc7@lucifer.local>
References: <20250829065550.29571-1-zhongjinji@honor.com>
 <20250829065550.29571-2-zhongjinji@honor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829065550.29571-2-zhongjinji@honor.com>
X-ClientProxiedBy: LO4P123CA0318.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5754:EE_
X-MS-Office365-Filtering-Correlation-Id: ad44b5b4-0731-46e4-9156-08dde6e27b2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h+gT5UKiz90slYFC3MFNTR2Got7MGuSx2qoEzqpy2xyyZWZz7Maja5J6pSDQ?=
 =?us-ascii?Q?/g+XMUpuL09VUADcKwOTRtEiVxQr47e7B0r/T1xQgwXXYksG8SnMabYeXXfu?=
 =?us-ascii?Q?fZOt/qG1yXn55ht1TlI5bqPkIx3EZMDCH27ph51u+3fb4xzYFKswnbJBqx4w?=
 =?us-ascii?Q?hpTPwru88PlxDfWJZ4x/5GeyB0Z2Ooy+qp4zm3NvbcQ8i/pfBHuXeclxrpWY?=
 =?us-ascii?Q?UfqLNGclffyZA6QWrD1V5sK5KJklsLQo3D5Q84RBcioLuOwqtcBen9McAwER?=
 =?us-ascii?Q?QEQwwArG/NqcGKkZnzoW8GM9ebObhcHmynZePCmC54+uuLoRPVXJ9hid5F9j?=
 =?us-ascii?Q?pV+fV5qpKcqMlUp0lGJKtF124mzLJkdQXGIcLxVj54j9w7oui2qtlxobw5ML?=
 =?us-ascii?Q?Z1kH3jx5SQfxYDHss+PjTPXZbm5eI+QhLwRB/wme38IoXhj0nCd2h4R6paHP?=
 =?us-ascii?Q?AGcxDJRj3KztTayqS4tZ49n5lWwD3v1tsHQzlGWMk6GH2EEGAjO9EkJ0LSwo?=
 =?us-ascii?Q?l0HMepCVoxS89o30HEb+fia/8QdKWO6AyvW3ZERIYYEQ1H9E8oaHFg3ybtbL?=
 =?us-ascii?Q?c+3/bfEUK2BpUThoVd8drPaLXz+TmUujsZ9+aVzye/MezZDu6YfxS8GgXrxu?=
 =?us-ascii?Q?AKBiFdPqjc/SkM6AFTQJB2HKbCFdT2b2oUq1e+3V7ig9BMYMCIeak1hrjwh3?=
 =?us-ascii?Q?/fyZoLV9k5b92KzhryVEcYqXPOS265UpQFWes90LDF5NLoYuOglWiEwCIOMo?=
 =?us-ascii?Q?CNiL37i+RwZEZhNgF5AgMbY6cOqMQNJmzLjmKOYrqAr+y5zUB+KdLympy/7x?=
 =?us-ascii?Q?hdgpEMyiO1UsbyyxW6ipQbcAsCI5Lbnj1XH35csbGA40uNOWEq/n+UWNjbM7?=
 =?us-ascii?Q?+A1J8Ar+axS+BJN9yw9RUL3MFhj0rtpY5yM7hRhDejYvrULT0Vbq1wTNOSXI?=
 =?us-ascii?Q?BBOMqZW17Yp10VyO7mJ1zOSiB2iQ/xGgoKXWkjhF4uueaXrGqOd+dvvKcisR?=
 =?us-ascii?Q?fhIGqHa9TltDFM76k+0+y4MPpUpK39wxS1JJAIiLQCTSwqH+EQQtjW8QIQKg?=
 =?us-ascii?Q?LZQ72iAwELYspiwCASA4WnvOryvd1KJ8RIWDVjIcT88cCbuBaSFH64eZPxM8?=
 =?us-ascii?Q?ZpXtvSZnI+bKuOfQC/W4AlwhhHYCaIMDlVVcr1qIZOC43vJWB3hasRL55UeG?=
 =?us-ascii?Q?pDPSggTF193wn2zqt4lS3Qpp/AnBlLbHHLOFtbzISPqB5H0NG/ft/hFOcWmD?=
 =?us-ascii?Q?OAOEq2dUfKuGO/ZbIQZiUUtU+XF9BmndFAeVEt4Sp5G/JZ6OZpDSEWoav+Pm?=
 =?us-ascii?Q?uCBxy5I6/OtCSKN1bIYWZ1OEXrDizhMTEDoF3QVQ8wN7ocTvLSItInxJfu3P?=
 =?us-ascii?Q?X1A1joV9yZj4Y1A5IdmWtqi0/AWS3ClLcif2uafqfsawf30Fy5d6m8PtqMvK?=
 =?us-ascii?Q?koSZ6HxK/Tc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jn10hf1RLd5f7HmUgk+g0OMNngliq2yPtntriAXdneaLv/M9QwnrtL5861yj?=
 =?us-ascii?Q?InLqJKxip/ARcL2y6VyWMUok3omNYZj/XEaBy2sOAmjQRhc9cH1613PiAL6M?=
 =?us-ascii?Q?/S8eISQiCGQva8WTTEDUCenj+6WTpEiFOpWF2lPzHf4CF4lyh6CiZg+pVdFD?=
 =?us-ascii?Q?OixYg5btu8q814EoU3Kx9MaX5s2aBlmt+cJBdzk5L1RcJ5cCOe6+kKrpiCSd?=
 =?us-ascii?Q?CF3Dq6lZBuxBShKH+05OO8nc5IMmh66ZQA7/6ghYp/DtLPSOh6gaCbm9FM7H?=
 =?us-ascii?Q?gxr9crTPkVzlxQ66elaFuqMYvZ+51UKTNV7CvKcjMqI+emGd88fIEKBQdH1I?=
 =?us-ascii?Q?ajHgf5mXleoWxHT1D9sSOXncy5UbnIzpqG0ClGWz3uvHe4sfP3TnTx3LShcY?=
 =?us-ascii?Q?8mCvr+n66dQWOmnH6j3XiHQELVrnW4R+VaPwHVMFL5NNmpkwxQMfF83YZNgx?=
 =?us-ascii?Q?i3JvtMfyIcaxhnTynanBI1xe8Yogvc39y424BNuT5t4H/YEJsZnaKKb3ds4f?=
 =?us-ascii?Q?OLelmRf2mReR1BS4v4M5qh/k53Wr/JXcLs/oU6vdwAs0szI/sRWIS91nTan5?=
 =?us-ascii?Q?yxnlN7NX5DksuAPJyxSyEafgXWVi28Ci9epfAwqF8TpcVw02Y+W2HOyppxNg?=
 =?us-ascii?Q?/VekpIyDTMG/pMdMAycbPf87TJZRorOcpRufE0qusXEEUuQl/e8/cfpCwaob?=
 =?us-ascii?Q?lOeNF+bphxEYJf6Mp6jC5ZZgR+dID2r7oiIYweFhFrKq+Yn6OP21ZRpbNP0N?=
 =?us-ascii?Q?xaBFMsEe9grrbQ6E64gl1dujzQ/2rE947pyS6QIy2HZ/atJT9nTlPxVc0G39?=
 =?us-ascii?Q?JnZ5hbgTVUhKYTqQgsBE+dl1t1AGin9E3Ez9bFbByBczZNe3eYMJCQaV1AoX?=
 =?us-ascii?Q?ZI4n4dQYqFrllbAItvcFnjdMSC982897GQirx0DZkEfrOJGQ3/n+ZYPL+7t6?=
 =?us-ascii?Q?uwXdPWpUGKkQcHifc7W1t4ruykncE3IU/ebPs+KagAOHQ0oWvUgkhmxX+49D?=
 =?us-ascii?Q?TDZgOYQIy99oHVP6I8w/fgAkZDacgY1jdb/7SCQ4uiIDXfOK5fPOYsfUONMK?=
 =?us-ascii?Q?5WQ/+C5ah2YHCbwqRnIKC3ySOEabZikhJcBue7TU+fk7gFvPqWZ+gjdP6wyL?=
 =?us-ascii?Q?uhixdM2RRGIf4tQkod/p7+OmtPa6p413+Gv7fa2eQUwcCEn/0xrwtaW1XpQp?=
 =?us-ascii?Q?GCSlA8lIO2EE8LOQTR/SWUVBirvFxxlLOTtA48Biqw9SMpLV+Kv/vIZqE0JF?=
 =?us-ascii?Q?uQYwK2CfVpi5ouDX2AQXzC4WD56s8n09mtrU5Sg3VQJqohaDS4x5MENrAL3i?=
 =?us-ascii?Q?7CUfzkfyeV6Ip1h7xD+SZYBF0PogfZ5Rrn0ygdI1QzOcfN3yr558pBAJvRt1?=
 =?us-ascii?Q?78uDhnXqq7nLlNFuzs3yNfqZK5ReEYNpwo/qq7cysAkmTZfurq6svKeT/JMP?=
 =?us-ascii?Q?9nFvvpfi21X8N++fd2T9QtBN4BVeD9u8gBedIEOC7zABuMzNm0djt9l55o1l?=
 =?us-ascii?Q?DwOU4R43dW0YvX1HO3dg2QTET9crhkZM8ZRdijLxKX8gBRdi7PdQHMLhJ+A9?=
 =?us-ascii?Q?fhvru/X4V+46sJhJ2+6GiHz6nKSGq9xGilMWuP9XD7kGGiVuCp131V4O8h2A?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	smHY8UeE3b7jTbjI9E47fCLxpulPbEDzTyL8RgNXjC93tTqTNN4mS1UmOd0yQhGfzFkREUN9RYxqs/POA0k4aum60MC2KKedIDZEpDcNKKdCupWuXtnM3rAYNIOqHosz+r8ylqxIzIAwLPdso5EtQlrHYFfSl7FhNKXJQTUGC1PGJvFcs9IHsIbdiKcMhZpJVcxIZUMG8rhfaLQ6ElkOfFmSkyllS4R+Bs/jCH1GHqXJYY39V3wCvseSb5ZTqYXk+oetF1EbEwgjs00udyyPOOnwZ1e/TdbGh5g2bBq0DShmF3FfLKHMiNuo0NHOQ8hadv5ev54/DUsM8kHo/5CVZ0/jTM7xBr/MblQsyLdA4MdLiTEUnC+jEhUeewARNu82hGljXDse3JtxrMAjqBQ5cmC1WbZE/NrXdbKanakvaK1i3Lb4uklP+Aj+MLr0gAFDWsOtatK6Pa8Zs54+f9lcn0F8I15VAGMTZaC3cKF0Vhnm0iLIxoxOaeWLYlDyuFk2ccCqXtw74KJ4BTP2pU15LSVUTNWGbmDTdNeut3bOJmhFd/bX4E6rTtfXzWA5AUpOykepCWtZQOxVQ4+8AVlCwiwi4+HlIJBHneGyGoRaPzE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad44b5b4-0731-46e4-9156-08dde6e27b2b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 09:57:36.0647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uoSVyrpXP63h5oFXV7EhX5BTB/e9tYQMPlBHcWPqgN5sX8BgzX78TGanI1s35wxhFx+UGbtgbyYU/bCl8eAao7b6eiNcvzXZDaMNtkYUNzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5754
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfXyIXtT3aO2JYp
 bJe7clqyVZs182+eP7r3n1u+MzpLBW/uLXsCEhyh2Wr/sYru8cqPFZaI/T3RvIWO+sREfAOo9XV
 N1KYnMO03BaK52gznDITnyiou7oI7gspXVp0ddFmWoyKJTFQJ1xt/1D7OcHllq7rMaa/6sGy/0F
 p9nt3d3wu2k8bgA1/cRQfSnuvNpxWWpSgv9KymOo9vAu3w6jdos835txihCgF+l0O0k3Q41Tema
 i31qVG/g6p4LBPvW8qVNAKhAB1jhivenRaVwlBd4aPPX7ApJB9d0xWKiHQQyF78vaVGEcdTpUAV
 6uocxm00L6WowSpSg1TrmyLOafHj7DYMd6Rdy0Er35/ZYH7yIYPgHQK0TOk4rBJ7eRtjHx4ezaP
 O5Frjf/J
X-Proofpoint-GUID: HZ7veNxnvJifIdlrYOEz69Jk1ghTefWN
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b17997 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=lgicOfLSj8L8v3xg:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=CvlTB2HrAAAA:8 a=yPCof4ZbAAAA:8 a=2Rs-FFxIi-3bGJUbILcA:9
 a=CjuIK1q_8ugA:10 a=67QrwF-mucXG56UA-v15:22
X-Proofpoint-ORIG-GUID: HZ7veNxnvJifIdlrYOEz69Jk1ghTefWN
X-Stat-Signature: zi5eadk7sq76uom7wdfxx8fprmer9jo9
X-Rspam-User: 
X-Rspamd-Queue-Id: 624844000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1756461471-97344
X-HE-Meta: U2FsdGVkX1/Wg3C9Ps818HXKqgyW6w37jUZ6O0Id5gy+SCQZvobaIxMSPsJysogzxWUYObWDB3eLSS8m7erq1AxjnkWso5S8eUvodDwypgwYiLMT2ScW5LdhEEE1xhjr4A4hwtycgFdGsnPjaOu0n5jEFgT8A2Cpe2NGB7RVDdBFaQWbzmUjIyEykF6pE1L8C+bJTbClGv4Sl8UH1IWe2skO5b2NTZaOsr02Glz3/ihg4ghJ7S1Czx86S6bYh/HkuVbl/ltg3RUgup5S+BD/sqz1ZbioVbLltImqnK9w2GVBErp5kym42D1EjDzou9my6jsZOJj7MqhIIIEvLOoWzCkQzXUIkMSwWcbwGmu4JViuK7AkpuCNyD4X7I826u0A+rStfS2j+fHgBsrsNSH5FHeqKNhLBxQf4ZO7qdaOdoLirOm5NrJPQ5flC33pW+deKpwUOua3WhSahTTfMBM/poVdubZl4u2YS/l9PlxIPR8C9kqbvDU0vbWgGJtxNSkwJPecB2iwuOGcDfDdCE+9bZFGV6TdQXdD3RDLN2RlSX/yLJPrs7Jk7Rwz2/5gmvGfEXNb6dMpqkiwX/eQoxubnn0l8SlJiilf/+HHX9wQefMYRyI1tnwOni4VoJG4Ku7tojkdsExrMyI091HAYjTr0Irpa7+17FnJTwG8N5Gs3OhGDpBPQ0GMz7riKnI19ZbzywfuBMUZIIV9bTA41wF/H65r6cfPJRySerIjoa9Qssu05CHgKfLeJYrn0tsE6IrtpGE50f8eVhWMto2/c7nDRC5vtFIT4KKaLir+ZdmBmILDBnyk/4BWPqPjvIl4X1SehUHvvvAEnUHiBQhbplogiGTy6U2MfMmqxLT2OFxz2Zn+frUZycbEQ/becxX7sPsiIz7E/TfjxIAkwYLq2MoLy1LOW+WnDtAfbGb9Ienp2NW3gQg8nppqAJxowkCbhYPT35HJ0MebabIV4caIGRm
 127pWjil
 uFJCR4CDDY+wuSBgpEQxG2LSHJoxHBiVbvW5Cja8UlqhTxCzLG7KjRZR/s+34iHackdFXdP/RSvm6Xy6AYDEqpnGezxvTnD7IYlwtVFcPxiN1E6bliGqYW4y1NTDUeT5/hXNf7zIGEPTqJyN9bPUr0m53XS0fuujKL9KmBGVOkeNorcgBPs6FXK2sjgZcXvI7OKoAvUvajpO+8CA61mmxdrpcm/kCEu2EG4qZu0bHUVqVxuZ8AtFRmmgZl/dH6WgjFXJ6OJI8d7C1JWaURnb0/mt5Uy4sU9OL+RUDK4o62bGMCUeZE2sNn0iM3d93Yh9+hVqrIs1eQKl6MIb9Dq9pA+e5O1GcdKr7yDdqZXp5MusmOaZqINkaDe0cbA+4VcfyL3NNM/Oo5Jof9zPNi1/rqVJ5MdxhEP4NnyIsvnE4XPpWj6mK2s5M6Smg+imUWnTiYO5HmRid2i26feggt5f1BrmRapRIkM9NeC34vSdOb/6ix3KRimtvuJ/SFQXcK/4f3Xko6z8v5XT6MA/xhngwGU5HIvuel9KddwYrQQLmuScmUv3AY80g4okuHJCM0ijmd/daIPE00kpWi+GMe+wQzJ74XI+mOMfLvu7HjeCYEclmLFpKlwmoq8DYPw8da34GZP3XzhD4jS2rI/0dseC0ZIKh1+iAolQWCXxW7l2hHv3Xfn9WwehrAp0kgX4UubDzLqw4Zw6JCjiM3DtsFHum4RbnRwuGnXcKood34Wa2AG5uad7m90HbSxr+CaipQ5PhlRdmytN33DVNdblCnuy9Na8Nq7b9vcr7hCg4x5nWIbPL7gXD8+Qb/NiQaTVBsOuwspy+5QfTQ06CoD4fmTEhnWH77RIFjlwQWa/DXYis39Hcu979MyNyXW4mBklloaOOfXhoqQwCKZnC+GRKhZOr3bXITlI0nAAaErRY1jnTSKcZrlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 02:55:49PM +0800, zhongjinji wrote:
> The oom reaper is a mechanism to guarantee a forward process during OOM
> situation when the oom victim cannot terminate on its own (e.g. being
> blocked in uninterruptible state or frozen by cgroup freezer). In order
> to give the victim some time to terminate properly the oom reaper is
> delayed in its invocation. This is particularly beneficial when the oom
> victim is holding robust futex resources as the anonymous memory tear
> down can break those. [1]
>
> On the other hand deliberately frozen tasks by the freezer cgroup will
> not wake up until they are thawed in the userspace and delay is
> effectively pointless. Therefore opt out from the delay for cgroup
> frozen oom victims.
>
> Reference:
> [1] https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u
>
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Nice :) now this is very simple.

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/oom_kill.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..a5e9074896a1 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -700,7 +700,14 @@ static void queue_oom_reaper(struct task_struct *tsk)
>
>  	get_task_struct(tsk);
>  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> +	tsk->oom_reaper_timer.expires = jiffies;
> +
> +	/*
> +	 * If the task is frozen by the cgroup freezer, the delay is unnecessary
> +	 * because it cannot exit until thawed. Skip the delay for frozen victims.
> +	 */
> +	if (!frozen(tsk))
> +		tsk->oom_reaper_timer.expires += OOM_REAPER_DELAY;
>  	add_timer(&tsk->oom_reaper_timer);
>  }
>
> --
> 2.17.1
>

