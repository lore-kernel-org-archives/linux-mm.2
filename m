Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82243EE6B69
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 22:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E590A6B0005; Fri,  6 Feb 2026 17:38:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E236E6B0088; Fri,  6 Feb 2026 17:38:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01FF6B0089; Fri,  6 Feb 2026 17:38:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBFE16B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:38:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63142B8147
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:38:59 +0000 (UTC)
X-FDA: 84415498398.18.B6A80CE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id DABCEC000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:38:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=COpuOuwZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xzGuUEli;
	spf=pass (imf22.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770417536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVwWYh7B66jath/vajWks9IXB2d7GtMZUrz6jlL5X0E=;
	b=NShvslGqwxktHA2AwGC0bBTRW5pWfE/+u4wSw6STN9ki8ShNXeGcAH0B95tLvncwiNftrh
	PnBlnraBR6mdqz/nExuuAje801p26udvYj2Sosy8ZLEQxBOZ9yyNLkoHbJhCvV8SG4QV8Q
	TES/nGKfUG/yRP5Ch9mhY4iV+Uvah0c=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=COpuOuwZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xzGuUEli;
	spf=pass (imf22.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770417536; a=rsa-sha256;
	cv=pass;
	b=4sLqmjDJIkapuVXYBrDaK2XhTAt80hrirAwZBMOB5Rp7eBzKPErZwJfDQtdnccYKM5b3kg
	mlNL4MCr+EawCgW68aHu0EZWqgykxrY6O3aYNAn/Nld80AA5EReiTFOSGN3LoQJ9QKhy68
	Nmr4iWB7Stm2UhDZJa2q4iJoC++4hKs=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616JuJv23621519;
	Fri, 6 Feb 2026 22:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iVwWYh7B66jath/vajWks9IXB2d7GtMZUrz6jlL5X0E=; b=
	COpuOuwZO/Rqvagm7zMdDupfbJQ8KrDyRIFe3t8O37RufsusAagiQ/fAUn8bQmCU
	tF56UzCGvuoSLgCS/bNd2AA0Ds+PfevVv0MNOYD4NdlrdkPMBz4SdKHUAFBWszOc
	mZUDy3UPYwYPdyebHp7gDiyebwqCPWms5uQVkjpCWME2YBoE8/S/MfrCGrgWX+7c
	gi3tqa1PzCnuiVs10lELwu2Dj4Tq7zNh947z1R9lGsPgayKFAWedNoplgPQhgkX1
	IlPUY93zOUW6Q3iEdG2JM9FlXurgYw7+alTzznWDuo+q9lJhGz3N8Si/8aVv4Tcc
	q5To/SP2tIN956IgNORW3w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50ddj0dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 22:38:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 616L8abS030613;
	Fri, 6 Feb 2026 22:38:10 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010007.outbound.protection.outlook.com [52.101.85.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186f6ftx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 22:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DBDHmVdF1X9cEBGmj5Ewj/TMF8VUDi/hg0C1ZrefUi/oTRm4PKp4TNSxUpgrR98h43Aggw8l7Jwe4a3FoiQNZ7TDRvuqeCyGe+QEKKkjzUpFwXwzwW54WYfVcFi2XBm4W9LR6km2YEaaMnaye0ASY7cQepcjksdtO/5v+P2j2ZXXY1He7NEy9gzvDQHMQbowJenAna5sGK7Q5I3jtRcpjObvIPo9+yehLm+A/uxgdecFIAk1e8XW2/voshVQhTW+j06EioVMv7UxFHc8fTrdigXhbkZuRkEKo1f7hAH1NR5H92fyH225lpPDiC6Q30t12nSU3pVPXKoX5XpUC/qdPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVwWYh7B66jath/vajWks9IXB2d7GtMZUrz6jlL5X0E=;
 b=PZnv9lnzRUOxuljEPPWEsHQcYDwtl5FdT5qLdFFC9YwWOfBLwIv2LmgPZsJTEbfKSCw77JWyqwHFm4pkZDuJsVjBKNyj+Aesad+eYprojkvAYKlIL8Y+ws5R80pXwE/3qUUSrlP09ZZ6Avbr+f6kg5Pfd9bqzW1KgpO5gVi8GQAyug79KVgs9HOdDjHMZvhgXK/idFgg53WUmVzIdYS5Atr+OU+4rZDwoQzG8dX+nzMfHcpvZZtRpSatoPfK3h2j7jceKdIO4HYyso6Jrebht6Mq54rujgmKvdUiZs4wF7lcKeJWUWoUeZT9k9uUtv+Q3MR2Wweu1IggCvHU7zkxDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVwWYh7B66jath/vajWks9IXB2d7GtMZUrz6jlL5X0E=;
 b=xzGuUEli1zq+LMwdza15aNUTQVBwXXyvN0aciXXupW/Y6zqB7rrbBykGxnGpXZVUu8S6Ohxrf2SuweNklZwduqdv1QyuWc5XcwcbpRK9V9BT5E+4o1Huh9HeTHWvwfW3Hjrau9Af5foijpPycw+aZaHYhWggg3JvFlswUf5QDds=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 22:38:02 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 22:38:02 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com, kernel test robot <lkp@intel.com>
Subject: [PATCH v3] mm: folio_zero_user: open code range computation in folio_zero_user()
Date: Fri,  6 Feb 2026 14:38:01 -0800
Message-Id: <20260206223801.2617497-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:303:2a::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM4PR10MB6886:EE_
X-MS-Office365-Filtering-Correlation-Id: 026e7f44-8d4b-4233-8d78-08de65d06307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1PJGnzUMGzmKkJoHgq4YZnqaVE/uZ0HcUOaCL9UGzo9KxhH4pRUZczl52C6h?=
 =?us-ascii?Q?zBVfr6FsjsMBcQL4142SqrXH0FrJPzJz1DuIa59gqK2KINHl0u/HE92GA00j?=
 =?us-ascii?Q?niKSx+55CuJ9Ul2K1OVNEsUVUT6p1lD/T1Lv7j9Brv7Hk53NFqvIIk5p1PuZ?=
 =?us-ascii?Q?ox5QnGym5gq5iBtI9L2IVgRENCXdMV/e0AgM2aUhfWZdPtBPNjgcibtAuFY2?=
 =?us-ascii?Q?756A71QJqwaPFQuhj7j02G8rhITqucgB8NZTsP67ZfmYayM4kkVDajvQjKnM?=
 =?us-ascii?Q?COlL5O8sIx5eNwVMLATEhU2TDtApym/Ut15HL5iXK1GzvDNVm8ms4mym+2ix?=
 =?us-ascii?Q?AgXxigbdm0MOZxZ61XoWvIjmwROBKYfr2E/8lRnwPM1JbWJUHVu4rnhnuxqr?=
 =?us-ascii?Q?olExTFfsuO8f24Fbxf+qn4Lw8xsZHIRdQNKV/kGsDT+aU6Ku877dg3vm6iaa?=
 =?us-ascii?Q?3b/s6mBR0Jsi2mUUxMhtzFIeawLeN3PN7R1BkEvPSAQBBkP8TRJGvpS8Zknz?=
 =?us-ascii?Q?cyTjgkV4VeupPFd/mmPuE4/Zwx48F8pHSKJDhho95Dz+XGw8lUIeyZ/MvI3Z?=
 =?us-ascii?Q?nuOc20U26aKrDiBCQ7K7CLX3mYucPVU0l0Ibv5daMIJAgitUj0ljq9a9kGNa?=
 =?us-ascii?Q?cxPfL+ESlDIwmY4TisbpFGJHShM+/sX7WNsfFeKCO8UJEEwrJHia8uWlfpfw?=
 =?us-ascii?Q?930fdZ9IaHxBVI8cx6WMn6+B55Co1LuJjN0HqfmBwE4LuZFH9bG3gGNZ2NIT?=
 =?us-ascii?Q?c2jX9iobBmPi4KozIJ+bgP0M/aKUnMDrYnm442BqIqPpjMC3dv/g+/du+8+D?=
 =?us-ascii?Q?E8PhTY3Dew3vCo/QfnjHYDf8owDz8bpu+aU9ozkv5oMRKCGHVxu1fAeeWdQs?=
 =?us-ascii?Q?PYFHLXhT3Lflrl3Zq2LCktDyb4qafcjnZ3YNDYc/I1YzqFcQZQ1H9Et2JRP5?=
 =?us-ascii?Q?MVicAZcnk/yTF4XqbN5/Sh1AJF/0wV/AWUKbzmGuJCb1u5rlX8CqX4yMqYrn?=
 =?us-ascii?Q?Vw1pFXlpIQbvEpItGx23K1YonVDvo03kG+IDzS+xjRQNTx/lnNLbsouWa3Gv?=
 =?us-ascii?Q?PiqPpf8nA5xStXpHk1SUvIoBsjUa6g4V9pMHho9H6DnK/jRkP6ue+U2PcRmn?=
 =?us-ascii?Q?+j8uh8zjmBvkZXjfbga8PSny7BuxbfrxkQnMrTRpZew70yHLr8eFfJfC1FDj?=
 =?us-ascii?Q?RcYmmjQHivhqY3RK044UEi07CXgUeSAznV/YBmyhkqjg2yUcx5fcMi7znSpX?=
 =?us-ascii?Q?RJhnsuOfstS1/bBsewQbXmBHtjFo30wD3TtEhKW6Rge/zMo50zrPoMcfYsHy?=
 =?us-ascii?Q?UmNZYTYSCVcIPYhEBzIVUVgtOTeFLQRRDHQeSmg7t9rkcZ6TYgfxqLKRaeXC?=
 =?us-ascii?Q?QEzMKK9k9wdJdQHuONKUtT/PgGSb2AiOceOrWE4nlk2s2opVKAyobFrS4Dqy?=
 =?us-ascii?Q?RK1MkWWABfc0o2kzIGlXolXhpiH0KHx3oCxwpkxwDicbhcBE5IVMhGEW3zdG?=
 =?us-ascii?Q?a5R3CvI8lRO5qjGYW/cQceyVNIGL2giGUoj0C52U1M+0dj+KXyJWUZVnNCDb?=
 =?us-ascii?Q?RrpUopUSKSGPDaREQ4c3r3telZKVteOqZoH7v6N3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iu8qlSDFslF+grgPNvvrLqLpsUYSQP/rEKkJFmjYp6O0kbV0H5Sot47gbE/u?=
 =?us-ascii?Q?oL+RV3ZacRimESMgK50yLb7F3kyaibk1TyK64rMotc7S04mgVPmpjm1drWcL?=
 =?us-ascii?Q?ulLfHCEocGo9UXnrJpkPI+5yLeMFSblBgHLtQy2fqbbgPJFNQkSU9NXCHxmg?=
 =?us-ascii?Q?FP1yIi6RFVokL2ve9qco/ZR+KnllNyns7emo0rCvyhCb8jPL5B49/iR8SUTg?=
 =?us-ascii?Q?zfb15lIdl+2AQFmcVop7qZXvwRvZC/lYqta23iSorXHct50V803HN75GbO7M?=
 =?us-ascii?Q?m/ZKd+MMXcP8K8pZgDX1XyddWXeAusRgAAdAW74Fmmlw/dlZ+5v8ebt/S7NK?=
 =?us-ascii?Q?iUIeeHeAOhNVYQXWb/93nnNfXYEnNam0xPMq8NX4Q++WBRVzUdPLYxADttbe?=
 =?us-ascii?Q?hkOZsXHk0Pcne/+cT0Ji2mtYXjUalizJq4iltAG281u3CHYnNunp94Scfw8H?=
 =?us-ascii?Q?RCwnsvXVedJd8Y34yxTzM7IirFDq2Rew8OSCrW/7ycHJLpb9UmKJltHzXq5b?=
 =?us-ascii?Q?or9Hoi1GsKtAi+8qI5dBRNooSI0S8JYcCTJPp25B0PjeaQ8jEty2aDKLfaX+?=
 =?us-ascii?Q?Ttlcyyilb933BMayHKj5u5sL9NdY4B+Cx9c2oc/MhKHsj4OUZjS92/M/OEmw?=
 =?us-ascii?Q?OUFhtEmIyvdjU6M8s3eIQISl64lZMCq2qm/6OfCYyKITSqjkU5bfMmgjZ5O3?=
 =?us-ascii?Q?g4qxJkWvJbN++wqcbnYTvJLbtNcn1myPkroisWR+A47cxTzHFRIV+/L+QXZf?=
 =?us-ascii?Q?V34rzFd5XoLt5J9HPciPEFSLsxCaW/h5roLH/hSDnbq1dSpjyT0oAoTo1fht?=
 =?us-ascii?Q?NhsYnueqGeHa4MXpgEsIZCRVLqzntj55f7lKU6iHG8OfhbHiN/Lj4RS8u+xi?=
 =?us-ascii?Q?1WgqRFhwq6lPAh6YKx2Ccf4AcygzYIjWikEfbowi5x8KR9ZcG1ezQDv8V8jK?=
 =?us-ascii?Q?ZWnfyze+xcVHLFEv+F4rlXNupXtidevTGOZo8LSQuK2xHa+xg37i4db38LG2?=
 =?us-ascii?Q?q6uIxlbPXN275f0y3/CRJ8laW5B+Cu1z29R4lHtlnxkx/MDgxTGfu+AlKKbR?=
 =?us-ascii?Q?z+dDcfnTUO2lBhfElFlMjl2dV3pT47c+kGoA+h3FE9tObT1ZkbPodjViaBAL?=
 =?us-ascii?Q?d1kBOyfQNMYH4yDgesB2FvQnvAPxon7hw8lkmLgJZPDFBQaRmt3W4UQeJbAN?=
 =?us-ascii?Q?J8rePQLUDCNMGP0S5znZFLX4Owi4SmzjbQUy5BzM4JaJRWvtuEXesJAP2kVP?=
 =?us-ascii?Q?UOKqdzde9pvPSfDTCKRWRMrnJg1jJmiB1zLffsORoaIzYbQy2z+0ZX229BMZ?=
 =?us-ascii?Q?IwcWBa1vtz4bnxdGrG5joACoCIPwdFKUChjW7aIgqsd+qHZjjFUrPEJHbObj?=
 =?us-ascii?Q?75hZAmAONgVCQ0ynseh0Xm6116tBYTmfstgs10abBFrIlrmvfVCo1mTE2ZfE?=
 =?us-ascii?Q?124nwfVI2T6ayjqIFimuUammhmKOy1bhrb4EjID464ydDUq3I8H5jpTGbVEN?=
 =?us-ascii?Q?h8HJY5FUJQlk5iiGiD7cqh8QKIOJu5Wq9K1EVG5kOVFuA0Aa7TtqOZ7DsJuM?=
 =?us-ascii?Q?wUvoLRsNOqWWz5idKpWSiFZTbKGiLivKbWby25bSyBhKxdk+X9ykU+PK8WDs?=
 =?us-ascii?Q?P++n2vAllIAT3M4ULiuRw1GQpSpsh9tkcgi13o1XsEot2/34w3IxxyUsa/Z6?=
 =?us-ascii?Q?v4AgsSfAZX++mzi2c1uxBjUO8GqMira5N9Hw2DHS+Ct/h2un0UlyB7Z1lXAj?=
 =?us-ascii?Q?R2zSRmEWHq3Uy6k3HMDSU34Q6y/8NKc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	usr5Cswown/Bq3q+Zu1U0UYqOE1rdfX6LzDrg40lPsdFfOATPNoqNweh4SnRekAw/zV0uca9CkesWnr5BqMVdbAhpYMukCEPCMH7QIqTh5FN+YlhjxUIXx4csf2F0AXRoeJq0RZ4NGGz0VBWWBCbO2ngcWI/NMZkJV0hwkxvAV9QBYCmmHOwE54LNiZ//wblb5VBEoHIw2UkWOSrVTZ+ycg0r1bu8VbIpFImgMvKRFqVPs7s6PUpYYvJruN1tMmHg765shTSgt4UYI0gqh5BFP6/w2FWhmtJpLsI8aL9fTVq/HV15WiQBuJHykbt0xthcdUJB2nXh/XW4noce+F14X2WTmiKP89Ujz1EGKrsUF/gC3kzEIqrNlbBbxGuQp71/HQJTZezqIdwTHAygNR/60Cet/d87urKujIEXH4Y2EyDIWSB08h4oZ0roxAAt7Omrd63IMjJTt499RtF93jYegmUhrEuBrdMiqZmGDqWnennUwfm0vOIWOOUeCh9i68LCJK5rWHdpUvHJH6JEczS9eCArEN6gzQ7FwWdKVx55OAjbthsxIXNmq9HjSfAzNdaHreH+Z/BPXTWgH/PgrdbpJHPHZRq16RyGVsq9U935Zo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026e7f44-8d4b-4233-8d78-08de65d06307
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 22:38:02.3952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fp+YsGfbm8cRzhIyz1Yqr5Fo17Mu07sVfdvu55soIME4knDSOWKFpn/SM2xo+771ynyBTEvrQBU+ZxdrzY7qU0CxovVO/pokUFftxOv4ghM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6886
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602060167
X-Authority-Analysis: v=2.4 cv=TvvrRTXh c=1 sm=1 tr=0 ts=69866d53 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8
 a=UPAns4q9ObfJLkRcdUAA:9
X-Proofpoint-GUID: BKYNlrd8W4gmoAEKQ9sC-RrR-TGoD92_
X-Proofpoint-ORIG-GUID: BKYNlrd8W4gmoAEKQ9sC-RrR-TGoD92_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDE2NyBTYWx0ZWRfX6CKsfBg4Pj/W
 KBiqxbVT2qzzi6oI3pNqlFMbtbvxXUeXj0FboaOrtgIr9P02RP3npkON4O30HOx/ZgHdL0Bs/rc
 k550AstLS6gDM68zfajG+Bw7RqSXWOHXLWSey8L3PbABsr/JK5aEoin04VgLkJDRtwvTDPEBjyE
 +OXLM/AoM5ni5QTKqLQWkirdao1LqZLEcSEhhDF1JYCu/Wwo0U2eK6QN/OxA7l/4JzKDbs+vdT4
 HXDbhKsFZ+diLgMmuJ7JW1YF7pep+eXVuGk5vcnRifZnzsvJDjXsSq6adWBLpYoMowbkXt/zwBV
 SoDD3vSil6lfB6ySPO4AmiZtn0DDhri6/uRCo2tAbWUfkKac/32GrRNcPLwUHmr7hswfX3zBDDg
 hTAqcIBnnoLoeWlDIJcFouiHDIg9BbriZPdNJlpYtS3oydb+LKc21imSTj9X+a3Qrw1GGtlcZLM
 nhsFqdDKFn3nJpPdNgg==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DABCEC000C
X-Stat-Signature: uamr56y784z41m7xe9azptopi68u318h
X-Rspam-User: 
X-HE-Tag: 1770417535-780199
X-HE-Meta: U2FsdGVkX19i/6KW34IZJgFq2B/Ze+P+pokwPNckXEScBNVp6csPv1udB8vx7fxD5l6t8U6tz+8bqoBjvXnhMIAGCqT5XIMYt5GLUM/7q+rgiclqlBGmidvApjMXDifzhpA1/5FJ4Umc9+A4F44WcSyH+sIfDTUuZeW168o9iEQK2AZfdlhpVGVPq8AoPOe57onDVH8fjNmNUmruB8MnPFh8CkvupTo3Kua0AJE0LNtxxxVUMmxrmd3O8DDnrY8TlBiktW3Ux/AVchcXzYtnR7RPSTc+LtplGCKAiHYxoDrbJo7h+/V4q/KIz9SHEW3a/qITKlQlGKNhcL87co6vopvk7/DsaEMDJ5PsWTUSil5aLZynKHsGjJeWzSE1VBMW0yG+afmRdMl8A99RzvuCmflRmeIQKA2bK6crZGDnbsdOwGYyl3NUd3ng+qby3imgzzXAGlm5zquYvLfiKktFMqLrnMtNJ8cdbGbihWrTw5JhfvonI2CY2t/ITVwEA2d81ZQbETLAzc6XiAOf6yf0AzvG5XGfUmZKZly5GxqrnIauhFHijycbrMAu2MJq+yuuCU4qnU0xeXE1I5Bj7LckKGt89I1Tqhy0KaKX3Q8KmoyMIeqPj3ju7bzojlOzDvtb8gw4gfU8udx9RHzJuw7q6JaDl4O1wwav9J2W9oOR/9Nqpd+ol/NAukwBb4je3+3XVFoJsNBrfIhrFt9su/pUXz3syGRD0AY+6sujLS8djT3f3FXJuNyP3XDJnepYZRsHqNhbnV4yYPNbKL9cS3gzHfi79XQQNXIi/2x0hQ0O+ye8wPL1CCe3QztYjdaRxw7NZvlQl1KUrLu5wQLyuriPdeBNVTNOOJyhzk/hU0AtFC2E0GeUXWJJnHziB31aHxk+TaOmz4w2f0vXoFpUBNTajaLv8eFP8i4diu5ByvuxthWv4JqFqFLjhUOvFV/3Qq1ZPEOV1XdvbTiIYVS+Iwl
 4kRuhiQz
 lVFITBSj+2dBHTbVoI0f01ZusoowZM/fyoO1Iu4/DVa4KBb0S8eVX8HDb2rNwZ9yuRDP0OhCHWdhSWvHIX0pi9CRw6K/Xg0TwzjNsrtpm8UUvOnbpEduM2JUNboz9qNFnzUrpI0fYiwkbk/iPKfdeZD6rT9GGlK+AeBQsSqyqRNJkyPE//BK9s4nvC7lA0WioOzbeBTDyOUZYHs8ZL/H2ZJQimtUa7f1F4vLLq0LiwP6uDBxkHtyuTUDiWTbI8G0vkYkW36lb7mb+eapmSxx06DktROJiJEv6YHy7R6gzN6CaDQarcg0lvdk4kpYnmXkm1iEgnu2kttonjya/WXabQWqq/47FOvbbBpPe0HYrQIzG3w74SBjyE4sB2coe8bObRPmkU5yK4DP5uJ8cWe/ll39CGsTv3+CNpJ3u2GYlwhhSjgAd7sRGSQVQHXI2pV+HX534hC1a+XODK1MD2emnMvBl0Ii7DLWNlwyX0wpK4V17b3WCOli5/DmJtWNHzAZTS2QRY0y1ZWUmVS00xo+8YIzH/6EWx5iJeS7m8HK3+7SS+m5J1+6XxXx7Bli5EEtBwB64UBeNI+Ya0ZvetLC20Mnw9miUaR3GAo/4+LujKbIVcG+KOlUI2AVoRoLqmtB2XAce17IuGJwx2zQc7oabHG5A4I2cYpnBnqfL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:

   r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
 		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));

where it decides that pg.start > pg.end in:
  clamp_t(s64, fault_idx + radius, pg.start, pg.end));

where pg comes from:
  const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);

That does not seem like it could be true. Even for pg.start == pg.end,
we would need folio_test_large() to evaluate to false at compile time:

  static inline unsigned long folio_nr_pages(const struct folio *folio)
  {
	if (!folio_test_large(folio))
		return 1;
	return folio_large_nr_pages(folio);
  }

Workaround by open coding the range computation. Also, simplify the type
declarations for the relevant variables.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---

Hi Andrew

This version removes an unnecessary cast introduced in v2, which gets
rid of this hunk:

 	if (nr_pages > 0)
-		clear_contig_highpages(page, addr, nr_pages);
+		clear_contig_highpages(page, addr, (unsigned int)nr_pages);

Could you queue this one instead?

Thanks
Ankur

 mm/memory.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ce933ee4a3dd..b15f11a0bfa8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7284,7 +7284,7 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
-	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
+	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
 	struct range r[3];
 	int i;
 
@@ -7292,20 +7292,19 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 	 * Faulting page and its immediate neighbourhood. Will be cleared at the
 	 * end to keep its cachelines hot.
 	 */
-	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
-			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
+	r[2] = DEFINE_RANGE(fault_idx - radius < (long)pg.start ? pg.start : fault_idx - radius,
+			    fault_idx + radius > (long)pg.end   ? pg.end   : fault_idx + radius);
+
 
 	/* Region to the left of the fault */
-	r[1] = DEFINE_RANGE(pg.start,
-			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
+	r[1] = DEFINE_RANGE(pg.start, r[2].start - 1);
 
 	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
-	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
-			    pg.end);
+	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
 
 	for (i = 0; i < ARRAY_SIZE(r); i++) {
 		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
-		const unsigned int nr_pages = range_len(&r[i]);
+		const long nr_pages = (long)range_len(&r[i]);
 		struct page *page = folio_page(folio, r[i].start);
 
 		if (nr_pages > 0)
-- 
2.31.1


