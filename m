Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3BAAD47CDE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6B06B0088; Fri, 16 Jan 2026 06:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343A56B0089; Fri, 16 Jan 2026 06:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2085D6B008A; Fri, 16 Jan 2026 06:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 152266B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:12:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7494BA3B0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:12:22 +0000 (UTC)
X-FDA: 84337563324.23.FE66D2A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 41DED4000C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:12:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fon7wQ4f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UEF9XL1B;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768561939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwWRpKAtgYY2Tv6XhDu0zNssBj7d9u7rH3VeqBQ6Eu8=;
	b=cNLaHmOek7/7KJFajUYc64OFEyCFcGapC9HlXv2E3wVJ3XiD5PD8qmNwcavqV6sgK9ZV3s
	f28IuKUC8x3P1d2g/J2BJ1QlL+TKn2vezKHwxrp7zbovN7ZLR5namS90x64NkNpfjUzD+b
	/auTXMavZBESjKJqo6iM6Jc5MxIhuY4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fon7wQ4f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UEF9XL1B;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768561939; a=rsa-sha256;
	cv=pass;
	b=1495PjfXQHEgJ27fYU0rGlYvqC8FAppommeA6PLsGuPCdjE9XrH+2eS91EF+nXZmuRgvjs
	x1Bt5lHrp/ZfcUKJDwrtfrUWWmobOoRgcZLaDUNc7B7Pmj84Z14AeMlZwjpTbtbmwOfpxK
	hZnsSINlMWeFLF699TVZtC7Ra/m5x+Y=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNFbL1429743;
	Fri, 16 Jan 2026 11:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NwWRpKAtgYY2Tv6XhD
	u0zNssBj7d9u7rH3VeqBQ6Eu8=; b=Fon7wQ4fCP4mxnxk3cDECd8UGRq5qKPeN/
	jn1+3VYTrxiFCffdK6axXFS2khpQevmNP5WNjTpQom8HmbP/URTISqsjXnhPLQpP
	BJUHinzU1j9jwaJpPDIxYJx4q0vyMQc+uHrm4jU3WeI9eeBDJJ4cfe0q3fAVjMjy
	Hkf6Mf95hHkLqjvVMWEZ15QSnDDLtpKivxm3I32gChsCHNDjwaJJJpm5H/m5tfzz
	hF+pps+N9Cc43dg4/aFeBHV2fwz40F958o3kr2zQlpgxpgl5xICjQS1m1mR9tiMW
	6oc/qhH0eulH3lt1RMLz+P8rfDSWQvdvq2ipvqPqTNuymYYnKKTA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre41tvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 11:12:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G9NaGB005654;
	Fri, 16 Jan 2026 11:12:07 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7chf83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 11:12:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C0NkJQEAbJ/No2Cf7wg1xZQfUi8WjT+y5eGA0wQ8sI7CDybJlBp/S1tntXVxgE/OlKKn9xxsXp0tTtwlgzJuRhqcN1ImUfOr15Jm2HOaSKDYZdCDIdTXsDwSlsluAPB8a4P1tUGZySUdqWHVHH1aUt+dJ2l+mtU4/M8VOVlUKSEynpcGVO90TyuxREYleyh8sgSTZ0cpJ1+IT6zfnYxxi/qsI68ZfEXQpmgs9VRgvGel8o6MOO/5MB8fOm5DjHXz99jpAD0l4V5OikcDPHCPfQxpAHzU2IDDiQD54G9i2R4PKTtU8+xNGOBhd57WSZXBHRL20KM0+A2I2iJGKP5l7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwWRpKAtgYY2Tv6XhDu0zNssBj7d9u7rH3VeqBQ6Eu8=;
 b=pflImqy2SG7M6G2RnBMutnZ0g4B7mA85St+UUHNCXf4UIr2Fn8ELd+/zq4rny7LxjY2H0JBQL9wWmkXVExicaER3jNZtZJ7oWMtUqLMFciAnvRhi72VQOTYbV2uMZ5ssNJkOr0L1/xVybgawXvQYBod2RXwMBNkRhjrXs0bUQ4LLUGE+WDw28WVO7WKa0hA+hzZCQ4zs0V1eGC4bVUtznv2tktcXjV5FYIsx7YraixhRTSnIFmtcKCuPupat5zayE3yPzrGRn+5Wrnj2qBgBVQkfVOFlwA0v7aLDjgHp1o3KyR9cSsArz82/l5jt1SjFB8tpx5wD2wIfBwHRjbJxIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwWRpKAtgYY2Tv6XhDu0zNssBj7d9u7rH3VeqBQ6Eu8=;
 b=UEF9XL1BhXAWfY4eD81EPx/wK2p5LtTsZ2NsBF5Ld2kvmg0ISQTmcQ58u65wfSYaumVHYeElO0yet1Hje6yQf41E85or6Je73C+BUEKfoefAGBviCsyekVUvEcVhcngTQSNGh9ZTED89OKc4WW6ziMzPPqnd5uGsjL6RU6T7bUU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6355.namprd10.prod.outlook.com (2603:10b6:510:1b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 11:12:02 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 11:12:02 +0000
Date: Fri, 16 Jan 2026 11:12:05 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, riel@surriel.com,
        harry.yoo@oracle.com, jannh@google.com, ryan.roberts@arm.com,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file
 folio unmapping
Message-ID: <2f35393c-488c-4d3e-9f85-3e548fa32f69@lucifer.local>
References: <20260116082721.275178-1-dev.jain@arm.com>
 <9edeeef1-5553-406b-8e56-30b11809eec5@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9edeeef1-5553-406b-8e56-30b11809eec5@kernel.org>
X-ClientProxiedBy: LO4P265CA0121.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::9) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6355:EE_
X-MS-Office365-Filtering-Correlation-Id: d3152a26-5099-42b4-7f6f-08de54f0134a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bJpPz87nvoXXf+gbA/Ewe+G847lGhK0zyUlnKR0aPP3dByZbZpiwKlfmH+ju?=
 =?us-ascii?Q?eO2sJWxMa2RoJrt4fEILSb4jP4GMe6YegABC0Ttede1Et08eh2aNI8pPTgmA?=
 =?us-ascii?Q?ccQACjuEf/hYaTfI9T7O4A3xI5NgO/NAw0Cl6Nt5aro8nFEKruo1xe8dz87R?=
 =?us-ascii?Q?oyfDSocFV4d5y37Ufd/WLPedYnFxstumnHex3gL5UJw8t4NtR1GnsG+mUpFA?=
 =?us-ascii?Q?RuDz7WW3JTCmcPCXghrDDcevqw5PE31gjuW5Z86GtjRx5NRV7YUlwPa1hxHb?=
 =?us-ascii?Q?VejYp8BPOitD6G55jhif+qQEPl+m8WKKRo6NX0SxcvBUSY4Z70WbT0Y6m6xD?=
 =?us-ascii?Q?ca6WiZ8WFucWikFd6hvl8B+rIEijScNTI8BVcWov/D1x+oYIAhS4oTL20PJw?=
 =?us-ascii?Q?A81blKcz03VTg+eKGZUAW+HyPYMMaotFX7cP1ceEcLo32GhoAT1tjDwKXjN1?=
 =?us-ascii?Q?UmkW1E1FXyVtoSbgGgGIikD5DrQwwfF9/2xPwV44ZnNugQnJ0NG7iX8JXmUz?=
 =?us-ascii?Q?NpBd1/EDDyyDusdpeSX5zkzN9goEq43Aes/krLtDC6XjzSz8jgkmA5IxxJFn?=
 =?us-ascii?Q?8mxYwo1Ekx84N6wqROmU7FQpZ3UQHYnyKx5c57BZw+klnGE5eV+mezYzVTo3?=
 =?us-ascii?Q?j+UgiFwzOaUrJxL7lLom8/kkKWrGDin0twCEDQbAQ8/ITbRlDENq/lSQ8b5L?=
 =?us-ascii?Q?WruaDNixkrg9GYQEsHxU8ZmtskyQ6gP0gV5kJzzn9TBFPu4K1jby7ZxwRrqB?=
 =?us-ascii?Q?jeNpKHJkFwxbm4XlsfvAv1ul47+bB/oaRV2j2k4KZDTkjnAvn0OIh1Nl2Rkz?=
 =?us-ascii?Q?RrZ04JnGCf/AlkrnOrewTxsqwWYsiOWhRvaO8Ab2ETl8+M17RsBrtvqLaRMq?=
 =?us-ascii?Q?+uFsdblc8bFlTrfrOXW1396aQ4fCSSh+GJiCbLPhajTXykOc2bEA31bIyDd4?=
 =?us-ascii?Q?USuN7H+s/Enn1ZiRMCtWL8nPRqjvVlFnjC2G1JVhg96F8QSu5kNdHiPaTcu2?=
 =?us-ascii?Q?sq3ITi/U1xrU0MoPAFMyR6uw0qNxoF2YJpzAdgEjyAKLVEw4IbZxilxX9lD/?=
 =?us-ascii?Q?vwSxAPsm9OHEZZBeH65NnwdEaWSkVOkPBmW98x8rBV5wNkIu4rJr8Z3JqgGn?=
 =?us-ascii?Q?QE+2fQOzVjo4A7ZXOYBvGaIZAJ6waijnqI+LOa+yVnHDvggYIZaLQEuQocao?=
 =?us-ascii?Q?W8oGzeE4zCMZ2GtCXFkCMlD3d56tQJu+y1W1SDPG460tvusg+O48KSD9rNGS?=
 =?us-ascii?Q?xthd6BIL9UMvPCQDmF6WAdWQoR+Zbh7ffhKUz9iPwHMjfcFrojvNa2zFc1QJ?=
 =?us-ascii?Q?iS6ySDTjKLWbPbhpds+Ljj0vsm+wd1iw2SDrE8wmOel1vdiBLmDvbPbUVlM4?=
 =?us-ascii?Q?Hp+yKdmPLo2/UXf/ZPZ3FknM2RgosyrhJqpS/bI2hy12eIGMV9zADV1SiHSW?=
 =?us-ascii?Q?5lSFZkzFVrvZI0lna8W6y4cj+dDGMwx+gBMjpTZlTJ0OxWQ8RjDRFsLtju+q?=
 =?us-ascii?Q?O1c/e5Jk+nmb5U/mHiDn/0JBDz6kfO3gb1oHHEw6nW5OyBldRWmAL6iJP8f1?=
 =?us-ascii?Q?zO4XD1HBqw3i63jaLiI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mnOvaDfXMBhqWrrmAFOhJlBRn3thIPLKrBYc7BdOPBEPxVyJoxfLWmEXlBb2?=
 =?us-ascii?Q?LuWiHnK6f5i7NSkGLwwOB3RABGJh06frkvB1OOE7dyoHaBMDtOJN4O+3ivGf?=
 =?us-ascii?Q?uR5ZLwTtCx+O1P/Go2Rca42hzdLET4n8WKuvcigG6itlmI1wVO7t4I/IwA1l?=
 =?us-ascii?Q?gmC04ptBCjM/MA3fleOwawXmaMQJhbQmbQJ4bgt39C4Lhiyds7Bkrr6mOFrV?=
 =?us-ascii?Q?AnyDJKEvEMErfdyLDKiUeh6pbiJWc+JXa6BOEtHESwYFD4ZmcbIqMlzrruwV?=
 =?us-ascii?Q?x/Lb4s8gCkD1sis36iRB2CxcOkRs6vhbnzkgrRPqyBEeS1lGSR/E/q1zRcnu?=
 =?us-ascii?Q?V1oQrBMOWNvIpt4Nv8N+PlmZ6deAIO7WplKDU+FggrXzlaRWGgsLRENug5id?=
 =?us-ascii?Q?OZFkGLGJCZTO1wZLnW+wIeap9nTuzK1u5CfeZaFLc4B2UvrHhlEyKQOihqkz?=
 =?us-ascii?Q?ES//DLav51cBLxR0b3iDoMVJr6p5JLiPvpibDzgy3le1Jw7qf7hbMqj/aiVI?=
 =?us-ascii?Q?lnDmm9hqAUkCUM30RKHCpNwFKowGKk3+iFoa0R3tkgg55pErieCvgabWEu9y?=
 =?us-ascii?Q?KS7DiIR0wETSedukRY0JE/ZNjN/OEU2F2p6RllYxLqj+uaVJ2nnHnOadsbFc?=
 =?us-ascii?Q?BD6fKm2F1C+CO1xa06m+DF+nF3FhE28GcutcSdk6BejfcSs+8syeYGcWejw/?=
 =?us-ascii?Q?zL5Jtm3OgVw1Jh+6SQIg6yFtx3r6euDE0Aw8/hMwN/lgrHBZMptp8OhhZ5/U?=
 =?us-ascii?Q?2rcsku+auItPp8X6KUDZpVc162NVSjj0jYKpCJpxNGi4xpDR8vpYzR6Ahtgd?=
 =?us-ascii?Q?FJXcGbFRCJsCEfuAm1uwaZVdNt01rTIB6K/wCukvq9P6JPMIaG0v1R1aJA0Q?=
 =?us-ascii?Q?m0TEFpI0TNHo2jXMDpFDeMllMOfEPTHpBeqa4cNZNFYDiMrzJ6R0Al71ssb3?=
 =?us-ascii?Q?ucizPTTVT5de4W+r4IvB0ESU5reZy0pZZbxKhwyuJrf1WueW0V9SsQJbRydC?=
 =?us-ascii?Q?dMBBeohIu3h8Pwk/39I9hBU+fVOaoDpvOQ9CKqCLQZRCNCw99fyhMZqvj6eM?=
 =?us-ascii?Q?wF+dyAr42atYYEyuBfP8CGWJPIs2RaaEf5SWhqq76fZrDSLLbVpti83oZJR5?=
 =?us-ascii?Q?xN5XuvYBNwvbBsugqVSsA8+rHFvIkszPGb7SykfW3mF3y1mC+hOWMt1gpJiJ?=
 =?us-ascii?Q?UT70lRrwMK+bG0s1VFeuL8rZamtDBAJ7a06T0H+exAEjILTixUgXBx5U4vI0?=
 =?us-ascii?Q?y6jq0/utEIlnQqi/zmbwinxBIEKrC5d5ttTp2V/Wqr80FhLWFMY61wNrFng7?=
 =?us-ascii?Q?8s/cwt7rSHHHyDyEAe6o/bf8pTrTBzdZTcHM2yQjuUKv2HMNsxZ9Ia03TPXr?=
 =?us-ascii?Q?BRSbbi5ueYwiwd0ZJun+40V/4+kOw/g5adFGa6BSr83BFExdVl9LP5fJVXBI?=
 =?us-ascii?Q?PFCsHQXMHdoAE/rj+9BiR8IgvQ4uWz6FbaWEPfjG3zSIX1ZXJ/LoDSXthw6T?=
 =?us-ascii?Q?P3xYfLzY2okvsfZNlWMPkNPEhF+yDz/ahMK4JCQS6EswksU/H126G8aBtJFF?=
 =?us-ascii?Q?lBx1nH1s/VYtLjYctg1VluvA4q1VnWP83+QxQh0aEfDGZyukKu1MqRiCLqJJ?=
 =?us-ascii?Q?xfICabBs97GOfBB+Jmc1LXF2xffKpvZdqZmqOS29FSN4naldxJPLwh3fQe1f?=
 =?us-ascii?Q?iMRPapzjuZEZUtWjg+rgJviR3RQGdJMmoKnadCykwmiCmPcG9PrqzfK+qf29?=
 =?us-ascii?Q?Nktlk/x02ALJV8z2uFdAN8u5n3SQm/g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WKk4o7FVM9Tm0+Y98R6sbEBcY98zIYdDPidP571PU6Q9NITG8chmuLqKpo3rjdgCvt+iU5m0F/yYavpzUGKwJ5qA/gJXvN1U9Oc2RnXgWXu8eJc8cm5O1kKQmTwjkRVM5z8uUAZCYdA7Jrn4SUpLfb8Rx9nOr2zm0kM8eYZyISx3hBQ0eO/5x99uZHDULwhNPn19xtoOPYk+WoVxH+u8DeQ5uhIHkOqWxEIhgMDngQGHnnq/JwUYGH6xE3wAF8ZgjYLRmpa7aRRMG7xABmZJk4+wYwkTJX7fJwUUijChTQ3F/MdHmE62X4CwYjFikpAlbTdTWcoai4U7HBpG/AAiTPXmhruKVZtLYyXymdHMKdPo7rppoRrwr9iU5LoDE25HSpaOmWQnL7cx31z5fYYmspeak/yW9wAzsVoYnJM6pitKwollfOodAlwKw2yoey6TUHltdUQB3xQ8vhJd9fxsxObH6QxgyZ35NkcWTYzktw08Uxd/wF/roI+do2yKaDbhZ0a+F1K67I45zop8wqLsLoRxZTDaJPqsXi/vqd1cu7EYq2E1QZ2lQC0YV7CjHOHD8+s/DbXikKxgt7R8P4dcj9Fpeq6n+rT4vFlAdjRkN94=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3152a26-5099-42b4-7f6f-08de54f0134a
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 11:12:02.6747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZT0tsbdfc07LYNYg6KxSmOrCuX/gxqpuMIARFiUwIj6SXaKnH8WUBTcZUSQ31MP+8lrjcvmiO8LxmL419LZ461btMiOuwVW/VsEmu+964Ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6355
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160081
X-Proofpoint-ORIG-GUID: L2cht7vq021gFBf5NIMI9jvcWnjM1w3O
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696a1d08 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=L0Gr8iG1zqaHWCYvvDwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA4MSBTYWx0ZWRfXys6hSgWi/EgK
 TnznvruVNv1Rv9nwLUutj2SBttepzuRv62KSi9fdPT4y+QN469uuf6hitihkBW6xjeGSe3uDrZ9
 pxCTRBPMQk9J3m/4bkgRxZkqE+be5XK0Os7yyfnb/X178jJTYyBYmVRglirwgwKZnJ/ItK9xzzz
 JwcTC6LzbBhnIPZd9f/o+Z0vhAIw2JKmHHgEn/3G9A84/kjoMhwhgPZWNsKHgiRo1DlRzO+e/Lv
 +vNGo8wE7LFunpMBZuBPbbUVzLxdGW8Jx0RdPycj6RHE/KhDvGdl5BxSyZiSQICagzG0BWDJ8ND
 jqSwxeXq3o17Z6P4vuxnUFx7b2i2sf0X/aEivAiMypthcmoFl2kR0mRKDb8Eo3OVUtq7Ix267Xe
 LGv5w0fx3WqCJZjecgE/aVqj1htnXsLSAuKir7lWwRjQInaAc15/TkLzjkaQ27FWcq4mVh9aPc3
 Xc66o8vISWaExeKdjVw==
X-Proofpoint-GUID: L2cht7vq021gFBf5NIMI9jvcWnjM1w3O
X-Stat-Signature: hkkdma7zjawoo58nynmudu9npcgkyt7j
X-Rspam-User: 
X-Rspamd-Queue-Id: 41DED4000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1768561939-467201
X-HE-Meta: U2FsdGVkX19WUQSW4+G/3GIlxmkemeEBcgF5pNv+JkIfZjEiCVXon2KbDfGrvErV17yzikv1W+QnLIuYqcew3ar0RuT/WXcqENUaUpg0jMSsRnCqaWLJaWqZDMjd0pSbHvre5u2jkylRJ619OwU/TjK6ZGetIEw7ExzbA4n3ole9fdPRTOwytLBlw2ZQs/IP3+1qTejQzEl+R0y54Kq/woSw5PB1o/ATy/iNsgRC2bRodzt3lIIk57BfySLr/gzBfCpGZNlN052ShM6sv8ZXcrOTiQCXbPap0LCQwQI8OuduotE5gfqJw8FdwMWkhML7Dk/1OioXfxmFdBiC08Ub5aBRHCL/qDoyjMIfgsfxVRdmGRTs0RsxHVJ6MMNQHEDNmCu0Xd17363gTFBNoaFZb0RB1q/4k4MoqEL1agsB9t5k5GQtFoboXATwP/NiCdrvVbfzLDpI6oMZhe5snRbjV6TTkfxV206BaDvePfBpenl1x2tKy5zjAwxxRrRK3i1sNmf6eGMBaePl7QNq8kcAAhh3VZCwI4GMcg7TGSJA6h0TJPuoGNP6RQKUD6XkKzL9CSNKOpE5UaFKlHsC8aiGf9CxJsBVc6nA2RBVpEyKuZpSlO1DIbtbAyxu3TFf+CAVYp4lsYAqUfzhw5lJn+fNKAOvzS2OuJayfFkNZNli3KmZ4TnBOWzeY7RlbjidkyS9D8ORwBzhpRIiD7r9Xh5tWnRu+7LI+L6yEtZ30zkFjyI7URVR5XGojDeJuL0fvoCozME+oc8dl8QrQE7DZux/kiHDhMkN6+NmF4BmkvFBetc2V60f0ksOhnw9k3cvTf9BUenPpcvcKkVDOtLE0p/fzefBNBG0a4DUq4PKZFia3lOYVG28tRxMQ2cWeBZav3D6iSAv9ohDP1kQGmviTfy8X9IEAeXkkFmpK7qzOjMdzkad6lcROZdT+vUeUcXwicmY4RnooI8HDyHh7s4QVaT
 gtkpQV/y
 fXM7o1Sw59LiGS3lrEtLZ6GhU/OC3sQLRfmBsfqJpm/2JA5nZFtO8wqKnh1AHgTubeJbYhddtT804sV7qXJDzzf2MCXpAB85AbkGd6sHJmWI1pkoRePgYY2BDIaswf1sj1vVJP1YXJCQSv/UcoEfc1j7tO5BaDG+yk7nmt0lkFeaX6jBdPOfy4HBRbcrFQ9uqI8AOQa1cYG4Ni7vqcoHhqlgnoS4ehWgiMZ6/TlmIHXDAnp85vVZsWUk7sO0uhFoOgU3Nhn6hqrhG3Sr9nRi/CYRfYKt/1ip2utgzTC7dQfwTBHQrRCmKCKaZbIG4MrrSLsUTjFIqFq0N0tOVQJnPxSiFgRzePm2FLkJB8W3nlG8MQ7zWjpCUCns9Na/WN1REFKeHA5oHSpqCbcg3hbpDQiKYSU7uiX71BYInXVqedPwjX5GadNP7Bv+0jZKxqu1nBOWLbxee8ZZ1yjsa0/NYGpubwqj9LXu750wi4v5Tb/CEM1DnJy07HDztJFa9OEUbxWkZwk5vfLguXX4oKaqqIlYOLigXkbvsL0AOHgIm6Hjn8G/UHXB95H7iEhvCk8XubDT1oqoSqlJXmkGMKcFZmPA3ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 11:57:46AM +0100, David Hildenbrand (Red Hat) wrote:
>
> That should likely be factored out in an independent patch.
>
> And while we do that, we should likely rename the function to indicate that
> we consume ptes.
>
> That patch should also describe why the change is ok; it's not just simple
> code movement. :)

Right, but this patch is to correct something in a series that's not yet
landed, it's not a hotfix, rather this should be a report on Baolin's
series rather than splitting the converastion into the actual thread where
Dev found an issue and an invalid patch submission here.

Can we try to get the conversation over there? Feel like maybe it's already
messed up... sigh.

>
> --
> Cheers
>
> David

Thanks, Lorenzo

