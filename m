Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244B3CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA506B008A; Tue,  6 Jan 2026 13:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB386B0092; Tue,  6 Jan 2026 13:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462C16B0093; Tue,  6 Jan 2026 13:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35AA06B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:24:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D46171A07E3
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:24:21 +0000 (UTC)
X-FDA: 84302363922.25.B28DD69
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2BAFF180002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:24:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jGBqNPwP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KNdL0hLZ;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767723858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gl+muRiIrUsMvt6wLn5JgLSq7RWZW9Wv8NaTnIsbXH8=;
	b=qBmuAxkJVuw7vnFZo7htRmz7XolE39wQurkC5TevBaZxMXrdXOHqgaQ2DE5u12pAECptXu
	sDUoyq0UnJu+j4zZ3BaBKM2zcpnjgRHfvpSdHLf4vIAjt8i6G/IbL/X+pfTVZXT7lDPKYI
	bDaUJ98QDBWHW+ixGDc2SeJaIvP9sYM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jGBqNPwP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KNdL0hLZ;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767723858; a=rsa-sha256;
	cv=pass;
	b=xERGMenmmCfHaycfQNK3bx89jX1J7bHyD47kOsdGiy16xkMQYphfbEBdBHfkwFqVTt7pbG
	uf2k0ZV04bBxVunlaDmBE9ItreT5TKwjJqa5S1vkjmBqROC5LRuGKDNWakDGkaDjvg3sW0
	Mrf+WWUyB1Vt4yWBPEZdGdZS8PLECW4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606GpH6L3968795;
	Tue, 6 Jan 2026 18:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gl+muRiIrUsMvt6wLn
	5JgLSq7RWZW9Wv8NaTnIsbXH8=; b=jGBqNPwPMLfOfLq4cnNfBQaqYWrMfTlWly
	XzaBKhGXgUvgg+4yVCC5XcqohJ9wm/3Z5j3szTNPjMmupzKlfwPuc5VoLoau2eqU
	ODwpGvoMKnUg3kRfm+xjSOMx5S9VxAQHTDAiQwsDg8R1sAEsWXMqGWKDDPsWhdYv
	r1AH7pB3giaTihTy/V4nnwWaM44AUwkIafHmoaHJQUYWGJ7aOtzMIzs9wHF+oTCh
	Cm4qwndtHjcfscSsvJdjhp78SMmvT+eX08yABnwvOYfA7sgx0IfZD0zCG3auC8b5
	rKltrJx03wyYhPzwghqinNrOj/PWzhg8Y780Z43TTy0blawvG13w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh69b0675-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:24:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606GxuRZ026417;
	Tue, 6 Jan 2026 18:24:12 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012068.outbound.protection.outlook.com [40.93.195.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjk6cfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:24:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lKO8Fl/z5wVCVMv8jZQcG8CgeZDwRO5smuaKvUYQ6nwJa3OHoKXbFBfsikOxvo24zcD1B64Fl+xiADFhXFEVECkLBVNSbujQfAbdM2iVf5NymtkdN1oRetlrABL+3x2beOR/iEsmD0AOGVL6x1We565L7Vos3S/tdVZtqP5dCVwvVk7LeV0qG5VHp4u7yV/qSCMWLVWvFM17MPEthL7OAfLYqYeW1E1IRBUw6dMesPTsj/Pe2Zr6Z+2nY3rqyVul9L0n9k0o8FGEMRxoPRv0jmQTDP/xea5LWNODzrlFon2YieL9QP5eVT+NDbvEtnZg/5bMlrXd6dZoWBhl9vTKPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gl+muRiIrUsMvt6wLn5JgLSq7RWZW9Wv8NaTnIsbXH8=;
 b=VWB7MCnS+pel4cNGu3CJqKoABBOIvt1Jk6u7RTbIazfVTmizN5ESOfQACQnks/7QA7D86n1uy14oNB1050HnqEU0BbQGVBQKDpUghLky2enoG4m1hAQshatgMyy0Movrs+P6CPDFMeCkJ6Vw4b7zqt0+xISYu2CwMH3EvDz/q81E99DFwIVgYAzDLLLhQOxRX0WUlftDVPRXZyQK2QMQnpRDUmdyQDXlUPllPci/djzQwcqo1lSx9OSvWxz48ieL1VVnZ6CE2BLC8kXzdZSMY6P1JBfUKGxic4Orcnq0wxqESXrYyX74J90vwR9Iqru5/wP5E3w7tS629PaPrjIESA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gl+muRiIrUsMvt6wLn5JgLSq7RWZW9Wv8NaTnIsbXH8=;
 b=KNdL0hLZ0xHpHLSbqHkcdXLUnOQi8zXkA6vt30HXWj4slG3yd3tB40jIbHZosuzAAz05kUeSqgpzKsEZhectwCukCWWFTX3B4zA01Q8a6QOvINVx3Eg0u53Wa58H3sJXr2I5X9qcSsFsCWctCYNXYsiwXyLmsdCD0v4grLMdZQo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6017.namprd10.prod.outlook.com (2603:10b6:208:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 18:24:09 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 18:24:07 +0000
Date: Tue, 6 Jan 2026 18:24:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <52bffed4-d9b0-4ec9-85a6-ba70e22106f3@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
 <61c3d41d-602d-4dfc-872a-873acf653b6d@lucifer.local>
 <20260106101249.be7514e75c09a928c6fa71ef@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106101249.be7514e75c09a928c6fa71ef@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0306.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8063f0-4862-4c54-5ff2-08de4d50c7b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OUfmmEkeHFjlZdWnpK9QtiK1zBho7GgE7F45W35Cqmk4PYcd+UtUBjo3c8sC?=
 =?us-ascii?Q?gAHNdGPuhTNBgsY73Z4Yd5HeVpSYXs2Uui8YovDHT2GVWoeOoP/YZGKgjCLD?=
 =?us-ascii?Q?CPTK/TtB1MgVttoRpS5VhAQqqcpYsQCJdlCyNolL45THKaqJtH3rL+6e3rcZ?=
 =?us-ascii?Q?8Tk9ulvqfwc3o3+Dyl3q+yIS2mSF2fw3pR1m53eFUVaEQgOSz+x/K3Cv5ezN?=
 =?us-ascii?Q?vjg8FDnA1SEP3GJ3rLZVxEUtYmH2bjjhO0vjS7rZw/m3i5np9SHEZ4je0Qci?=
 =?us-ascii?Q?p+AjnlaepOsenBAqUb4qzgIg2tLVn+JH+yaZtOlZL7B1Msf9+h80DM23Rqir?=
 =?us-ascii?Q?EBs9Q3jGgLL/8Z/c6UWcovWo/fxBNVS23uE+odawCkCa5Rrp+whXyFW9AlFO?=
 =?us-ascii?Q?DovcErBi3ezKy/PMnS0J9gAFRaElZSENXEI58dJTeEX0iw//fp+W+ftonLYq?=
 =?us-ascii?Q?uB3RADo3YqNOJvXgCR1/DxHIDcUycF0XM94t9rplSg5FJAqe5ueAPJRuPZCV?=
 =?us-ascii?Q?QNkT0N6pezfQxDpjGiuYn43ttMtZqidRNz4L4DboW0tzABvLtv/3FX1LR907?=
 =?us-ascii?Q?ssjHnr4QHcRxyGiIZyVoLhvUlo9QjJpFvJGzqypPr7w3bynACXkVYGTpzuTN?=
 =?us-ascii?Q?xsLFTxhg9x8qEadjfQJOJ6Q3Ce1P/MlNEeuQRyedp6WduOCOkrcUxcVPSU6G?=
 =?us-ascii?Q?DkVMPvLUWEsiEKbWzOSHeDK8MKIYVvJ7V5V3PViXUM3Mxbr8WCcRa+Sh3nFD?=
 =?us-ascii?Q?OAuczxCF/2q9A1v+NpjvduyMkNo3HVhVr93O+CWy17ry6kRMFWUd9Nu/fLVj?=
 =?us-ascii?Q?utxql29aTrtXgBBmXzOC9BgXQF+m05hWpFuzd8CmOMJZJ4dgXqk2NJOtWjhS?=
 =?us-ascii?Q?cV+ra6MdW4xWz1zz7HsIDnh2tzd+jg79I0rfPjviHD59Kqa+1xIWR4t0ekS+?=
 =?us-ascii?Q?tr2madGvcBxUo3z6/et2d+zgq0klwkdVCJevOb3BOhE1770mklfoX6j2eeUr?=
 =?us-ascii?Q?SHK4EJyag0tlJ56FLdIVPlDOM7y2qJ20XrjfJ7tW2t2k7YjfkXQyXxLWl8D7?=
 =?us-ascii?Q?I2ivqgjwsOSuTnjnndmQg69fEuGKFCN9TYUEx+NkPhdtlKCtbDJK0g+5eTpa?=
 =?us-ascii?Q?e52gCckZC/fUEzQ3ohSdYyYNcMMUPD+jvEvYfH7+57O3zi58yiY4kxxkYgjD?=
 =?us-ascii?Q?Ow4ZotkC5ybx9oIDiEy+9mJ5JAm5vS4noWAGrkjn8ZWMyUJijDPifbdD91bb?=
 =?us-ascii?Q?ryUaN0vNc9F8NrkhGpzKhddTj9lf4Kd0Pp3PHsiiHp9Os21QGSeyLMyYh4nE?=
 =?us-ascii?Q?oVKqgKrG3FrPQeBO+zwq4MP3u5Dl3iopvYH7l6z22wf/EQQ6BXyUVkM9x1ld?=
 =?us-ascii?Q?0qdFNcGNZbWENlak3iU6su/CtPEAcK4OUQYZH1vT/hrE25zExJdnelyqlMzJ?=
 =?us-ascii?Q?MS0sridBwvklnO+2sJoiayD15RxihDL7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W1Nqg0N/HvcztfKPYa9WvLCyHMdjo2a/ge4whAWdLaL/9irzqJZdqIxPFhxN?=
 =?us-ascii?Q?tStJUNMiz+UBS9SteqVg1PRCY+RKul0yV4MgYvnMKmIgubg5cZPWkr/1U7Qi?=
 =?us-ascii?Q?qfFfPPdNaAibrNNE3a7naV7VGq40ecAjlZRkvtYOglc1chu8fSICnz5o9L+d?=
 =?us-ascii?Q?hhTCRX5VkNID0I4coZfuRnrERYe30Tw7nRA8wTCORIrX3PYxxEmbEkf8vEHV?=
 =?us-ascii?Q?lFNV7h5kYLcdssSGKyOwLPkYiTUllME2KZo8rgTvEWpIfq2fKFGGLfP2Uj8u?=
 =?us-ascii?Q?tjy0Y0oTzwqErOyocLj9nei83duw3OsVPrKzmMAFou1+cOPVa0qrWeqFmnpd?=
 =?us-ascii?Q?LzcFviIShqgxetRFI/xRBAz8M31nlwj5QUp//0+ebnbhRxLjEpJXw8eS5npm?=
 =?us-ascii?Q?2aneFnFp+EEifao3HSapGCoVrwS9O6D5OG84O0Sncn2elN+hoVA9Ji5oN5X7?=
 =?us-ascii?Q?x/4wxqKpXiCPgEYgfLb3JuxQxr3ZqmN7j5yWaFSVXyrLaygpVbi4OYnaet5E?=
 =?us-ascii?Q?S8tRsqrOswsUyS3Z7fcekihA4UoFlfWx1C2vyOjLKt2KYGRFiCSRN3PdXNtA?=
 =?us-ascii?Q?7x+FA/8gcukPdCzk6LIengmID3+9MxvG4CXM7OjOliPdEFcDoMajfqv4JPB4?=
 =?us-ascii?Q?0ymRoHh86TRCUL3okK7DJ9+LaXKrv3Vn6Vo8YciF+4+2tgtNsVU4+dgxuZEZ?=
 =?us-ascii?Q?PoYR8b8OPa7lnmV4TRgHt/raq0VK9n8lgo3R7RfBxEq4N23f1Gi9kykftfkV?=
 =?us-ascii?Q?GGG13tfznsaLjUj/FofJ+NLtvjUzks4/ud4/CBC1fAnTZAvKutksfacUYT8v?=
 =?us-ascii?Q?fpfaDrqJD/FHUUMN0XN8ShiSid7VUW+dT6vmbgqBBXgK7haBSoSez1PxFxdj?=
 =?us-ascii?Q?gWDtmVosEf+Lrk58wYAgaLdKM+vS8blNFPjCG8rJVLGJ8B0cukrydU25GYFU?=
 =?us-ascii?Q?DAP4OCGgnsODZmlQP1wz9+v0g4gDbjlaOcqwsw0g28D0uGaSfEeOELtEvMoP?=
 =?us-ascii?Q?cuk+fvFJrXJl4qhthQcsD9TTj8xfxoS4d8WStimRdm8u21RZfjlK/9+U4Thn?=
 =?us-ascii?Q?3bnsmtWNma/LpNM2uRFQh/bWFd3Zm8JOO/4BAALDy4kiqu98YJ7AGcQEBkuf?=
 =?us-ascii?Q?oxazEYvBIlcpj5/B3svCwufSsgsKz0OVfnWHOnli7Q5GaLTTqJQyQIpPiHB+?=
 =?us-ascii?Q?jTNn+gRGx7en3IbCtxZnGs6DXpVqXH7vTulFUOw/Pn0FsLh9udvLRvZSfoOM?=
 =?us-ascii?Q?wECtdZi3LScZjMBXaDvHjt/0Yaj+H7i31LGnjMlHNh7oooZ9JoROsrHcE7iA?=
 =?us-ascii?Q?nRE5APv8jKI10ajCvn+2lFcle9T/Ymp4PJp33XrW4pV48y7QFBoRYbqv8GIT?=
 =?us-ascii?Q?Uu7ax9BOl2VWtNtmPGL6j94cqUjTOC9m0owtKlwv9awg2KQXeT2nPbkbNcpI?=
 =?us-ascii?Q?QN0d7abgtwReCQwudFcWLeSTyijoU3It+OZjIThAW8c322S6ysxs0VDS05VZ?=
 =?us-ascii?Q?X8BvvLYHh/GZqjGgDkkzcyyCwlE8onVxg5SsYkoc1+0I1OQtKtLUpSL0897V?=
 =?us-ascii?Q?q6baMsiHp3XwBmllJnB/07YKpKlaTU81njB5hb3EXaMkFWLINEzcuVztXOo1?=
 =?us-ascii?Q?E1WAr0ifkzD2XksMONQd38VOtalhRos3tL9/KT/TEswKLLrKBRa1/EEUmZlU?=
 =?us-ascii?Q?3Hopooqr3KI4rPcPl9qjS/4Q2H4vhfAO3XulcrcL0R/bGHfJpngOZ07F9ZnD?=
 =?us-ascii?Q?mmGmBJwh4W9c3Izj5af7QgqB+lxy1tg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+O/8RoJOaX3VMCqUS7M7fpQTGOCUAccnatYYZscVMUcxPAdZF53vyhUfLHlJAWxbeH5EbNeU0jMYnO8DDdnFGyKT5zI6UbfnKYsZC0L7O7dDi67nT1hp7ILx0wnRkClkQ2pFO6tiEYjsB6BcwqgzCu42SOc+vaH2bNgftuLmxsOh0Ypo8v3+QjX6GdTVEiJviJnH0BavmNUJPUGrXdbxTXl8Ysy9OFcwwfUsiXgAOxhzAMbZfp646VFAd9hOemZAKAVmZTgZLW9xh2cabzDk3ZD2bbGheJ+zHEFJMlaVCIJhOS2NQqdPdLtq31etgKJ7BuNpaw5MdWMj6u0srK/DQM31PCDjrTfp1ZZBMy6xNNhBloCKCntOlDugtCVYDg3F+NlcrklDO80gThrSus2ZW2YiJG6rm8IqAUi3oHN9PYPNs8nY7PfEKky3+//9UbpwtRtQNtUsxlJDjjO4/8WNPwBo9bwOm1ZuurgXBXrksulYiBX6BWaSHGhvcQp9NwTORySZqZAjVQ/N5oCHAa9Rlhd2zndPwak3x5mrJYH4qb/PDdwnz3qI4TmmVxi2tgqlLH6/2nFmfpBfIHtX9jiXso98F+Rrb1UovtZKqIyGnrI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8063f0-4862-4c54-5ff2-08de4d50c7b2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:24:07.7180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olsO4tLBn+61FReeO2SkzpNPyCM78KYCDibW259/dCCH9FveJ04ArN3Agy8J5g/KlcbKJrd7DitaSMa9/3Y3LOteWfljrTVvz4itStd3au4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060159
X-Authority-Analysis: v=2.4 cv=R6gO2NRX c=1 sm=1 tr=0 ts=695d534d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=-4wzta2QHq7mfriCG18A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12110
X-Proofpoint-ORIG-GUID: gvn-tx0XNSjQkQVtXN0S8VK-FlDiuiLT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE1OSBTYWx0ZWRfX+L/fXUBzrOMo
 N+udXhwe+VpSK/7b07xCnPD/Fh0kxrsdS//pTFsNZlfTw7NEJnsPck02xle6h+GsasImR96b86D
 O2styP8LfnwXFmJIqE8m5xAoo8qu36vjlrJTPZjWTm7B09FZqngI4qlcAUsmCgLyg1JVn2aTGgS
 rKiXtlFS1VfGAvJbiT/QgvHSuUIgwBnZD1AF1nPF9gQBtJejL9O5C+Cka5NWfogFRNviJpBhDCm
 m+uZBm1UCZxNxBzepgquO3jiqrhfC3cedK6tUgJY9F0a9EHrmhfRJJQs+srDF0DD1X25DSFiWzX
 w8qd4nDtlsm1BlyAokkhmKrZ7clUWC/PuCfFjxJKV9bUsfdLKiaOvtL4YEdFYd/5SxyxZ8MATQV
 vMUd5a+G0Ty30vTgAVnSbEqpmB7NOv+1BRLk5osI5KVCcOpCZN76C92G8oRhSPCArFKqd/J2Kl7
 AzDllNYycumIJ57cR+4Rw55HRwjd4sVgb33top+0=
X-Proofpoint-GUID: gvn-tx0XNSjQkQVtXN0S8VK-FlDiuiLT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2BAFF180002
X-Stat-Signature: ds8knsszfuyskbosoz31ywrp4zhuaqkc
X-HE-Tag: 1767723857-663247
X-HE-Meta: U2FsdGVkX1/bZ5MH0ONYYm8SGhg9oDuRGeM+6gAwiv0tGG4SqhDS5blFEsSNbrdGs8SrPmH711jW6uSug7DypIJeHS8gSAHFxlgn7D9e1wjbFzrkbJ7e5VlvgxMD0YGzb7VyMKdbq4GVYqE/bBFAVnbzkn3YsSGkPP4uZ0MMMXXszrr2e8Xef6i28NxtEaqd58xo8RKbp0TIEncUFQOGXOWkWo1s0QwuYbL+Xxbe4x+K/iv6s1fNyKdA7o73yQd+veGzuFmLI881uepip+ZcJCtEYXqoUlsEm2bmjXmEHyfEn2wpkxlcNVFRxQDfScnOpT3a+2Dxx92GS24THV4KcTpGwg0gw3szMvTHKhRRLgAE4F3SqvhaEGAmEIEUbryMSsChEn0Dlf4GZGgsSgEHVpn2/UkqbsXW9gBhivskVqGthcrtSgy20YbKlVnerizoqYuFoCg7tyU1rcee9JRVZtxuijCVX95+PDYbfxp6cYSLomYOQZ44ENbFWL1HZSya/jDfs+wb4qHrUYPABX/MqTz4lxTOHJ7mw6AIHM1upVi2Su1BOZhYVql3BR79tP5/E5cRVlqvnnkM15t3X2iGPD78Vc0WCULHq6C/uS11vQwHp4s7+ov4OrSxHxXBmKgzGNFmf3R+NG+4ZouPs6p7e1G7WVXcpAvaT75jgotEWpZZ0DTAY4kp4n/iuKlc1ADg7WcPnKBWKd18Dh8ztcKXBzXy6BpMPIBBk8vxXCMSq22EIk/AlMdLjm3WuQSiD5gJP98eOa0C2QcW43DVDXF/XM2mFG2TbgCMS7Nur+k6o9RPlfJ43G2Xinv/h8RWlR2upX5Ewv1Eey5iGCkBeaBBreAuNsGsOgehAHPUE4n3qZ5LvkZcELbbuHSZwHba0hvor+IbMuZ58uUB0OLEPioYp0A43uzZjdgAvN1XxeimLc9Aq+fRTTNGB+o6/d6SFCV7d8ybMEnvEM56IkoO4Co
 4VlPguGs
 KOm5MGo+ezrfWH09Q9qhh8vC/6fWX2wNc9hq7EApHh4xlI3EfYR1mDSmTE/kYdwGxLagT56JGcbKA4IEiO2zHCcpIvrsGk4bm7/y0JNzWbpofsiSOV7DFBHaaW2aCWa4rfJ81ilmeGQAeOvi7IdqjN2haLffXr2cVXpZXMg/VYHUIvM3oxPCVs8yvndN7zMTrbSO71XJWeKlGEOeHji3zyHkD3SkQTC2Qe7hTczmB6Sb+l0/dsi3hUheUs3922nyIzKP6Pd1I1lD2BAaqbO6HWyh0YSVGIZ0NZGgU+Jvo7yQ0X5QUQYnB0j0ItZvNcanGZUo47y3turXIcdT59eO5SJcBtf6MXxspJaTdHOlm03bZqi5cpwyiW36H+sj6VP6EMtnT0LjKUOmhpfRNzhAYHnR5XnvdbDdr9V1P2Rx6hmUS8WVza7fTL6ED5O3IjHRNJp0+13cQNIlRCHu8K5o0QuYukab2fuXesB/INhzdY0snr9wvGbCfIIslfkUTDlJgjjLgV4x/HHwOjgjFh9fV+YchlpoSo+RmgJiW0uHF1xoDauFTqU/9hCx4jouIPraxuzzNS0pNcKgMmZiySIbwfmpzYN8xi007Pws1HBU7KgBh9hq6VIpWz3HGmM+LSHqpmizlFZ29XNObaTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 10:12:49AM -0800, Andrew Morton wrote:
> On Tue, 6 Jan 2026 11:51:49 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > I'm not sure if the git repos are lagging vs. quilt, but as reported this
> > patch breaks the VMA tests, and the tests are _still_ broken.
> >
> > Yet it's still in mm-new, mm-unstable, and even mm-hotfixes-unstable.
> >
> > This is interfering with my work, can we please drop this.
> >
> > Also the v3 is currently being debated, so surely should have been dropped
> > until we have this resolved?
>
> Well.  I don't drop fixes unless it's decided to be a non-issue or
> unless a better fix is available.

Even if it breaks the build and that's been reported on-list?

>
> I've done this for ever - I've held onto "wrong" fixes for *years*.
> View this as a weird issue-tracking system for a project which has no
> issue-tracking system.  It's to prevent issues from falling through
> cracks and getting lost.

I think a lot of the issue is these processes seem to work to you but those
on the ground are finding them not to work.

The kernel today is not the same as the kernel X years ago, esp. in terms
of sheer volume.

Having a patch that none of the relevant maintainers/reviewers have seen
land in an -rc out of the blue is a really serious problem.

Also it was taken 2 months after it was submitted, so nobody could have
_possibly_ picked this up by reading the list. This is why I am really
underlining this case.

Again, requiring an M signoff fixes this completely.

No patch should be merged without review, most certainly not one expedited
to an -rc.

>
> It's unfortunate that this one causes disruption so I guess I'll loudly
> comment it out and track the issue that way.
>

I think we need a better approach, yes.

We in mm are really very responsive compared to most, I think asking people
to wait and resend if somehow it got missed is considerably saner than
'well I'll take any patch purporting to be a fix from anyone so we keep
track of stuff'.

Cheers, Lorenzo

