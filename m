Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F66D66B9A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2496B00B1; Wed, 17 Dec 2025 14:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688D76B00B3; Wed, 17 Dec 2025 14:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53FA56B00B4; Wed, 17 Dec 2025 14:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7E16B00B1
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:52:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5009C0DE2
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:52:15 +0000 (UTC)
X-FDA: 84230009430.04.F71BC63
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5324F40002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:52:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nuk0eY5u;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=od7g6itj;
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766001132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4KCjBBsLuxEF2xxblFyZzwQ9BLUmyWeo3XMSCzqa78=;
	b=vwQWNtOmYa06gV8NzqkdSmmHF74hzijAY53D4FBLVWDmlAl3JqWBhVIUZ+y1E+8Ic0eRgv
	VsNd7AFU+9maT/OEGtW1Y8Aqg+MTU8effyjf5Vox6M9g/q6Q9Vw6W+bCSsjjxnyxepqpEl
	3QqludDrzW7gPWUMdj7s2w8dsWU+URE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nuk0eY5u;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=od7g6itj;
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766001132; a=rsa-sha256;
	cv=pass;
	b=vwrCOzar3I4FWHetT9lQ2Stmgh3hECw+5u0RzB7eDxcjZSfuQN+hz3wz/d17i85Kd8ei2T
	hstcuYAISOgA95UXrc1pViCYtaoxpMFFPw7utWaTbL9fJ0scJT0V6LS9PL7cILa1DfdT68
	VvB22jINMWhwIZaW8u90nRMgDg9YEDk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHJQg3J3420489;
	Wed, 17 Dec 2025 19:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+4KCjBBsLuxEF2xxbl
	FyZzwQ9BLUmyWeo3XMSCzqa78=; b=Nuk0eY5u/+Ly9L2T6snm1v/MwBe366V5tS
	I6KH6RswDCJ0SRDF/kE1cDFqoT/D6T9xz3OCbzMZMEJUZfOVpnK9DiCu/CUN/44L
	5ZVjpjn2K9vZkSP8BXe1UGbCk4CLocv9IX8eHPEjVz/v1NOiHUcwuO14IY93ckwY
	bN4pbDW+SUrY2ApzjmHS7MMw9X9Tuq3mtCJtpt93HitGZFOs/l5jR8v7vqoawDo4
	c+TMDm5vSk8kKtK/JsH9e5FqjOSI2jRTJFlsZ+A0IZDWUi16Sf4dNMZnYHrR7Nv9
	bkS1TsNBvHjOhHniWOANBtYSLdrnMzoybjiQtoTuxwRmFdD1EsZQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2egu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 19:51:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHJJF7S022551;
	Wed, 17 Dec 2025 19:51:47 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkn0spc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 19:51:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4TaZ+du1rlorARXrr+TGbeOY+MJu4TE3BkBuYIpaUrWbMuW0zrt/frcWLSxOOQnUxGbPVzXhfbI3KoxIxnjBEXXE6vndaqpaVVZRP3QyqbmOuTQfRzlDYlJTgyVuYbDZFilVp/7YshQKbA2c2pwAOU4Xxt9uIUCaIzerFs/BD5AjbZu1eRoVAbsL7E414Zolg3IjPkGhCSWuHqdPSD7Wy1TfnpzAnPd4kSpg1WM8t2u/PXl+Bow4QNBYIWp00WKrnlxhAgOX2XfjV6AAgH3Z2F97vIjtRbspsVd5hLdBBAGM04NrUkIZAyrpYmsspmwlx5ogn9THlT4gpzD0X/gPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4KCjBBsLuxEF2xxblFyZzwQ9BLUmyWeo3XMSCzqa78=;
 b=vU6xPoFF6iMc5X4Jq/a8MJ/sXVXqfheHyzs1pLSr6fKOpDsFJRxWLjjaaN7xqYEB4xDEdbaKUenmPFL3U51WdnsP5wTyH60EBXWAYuds1YjFWI9bqLMNfv6JfKNKJ5ZozGdfLAiUNQtYDkWvOhKyDMT6xja0cdNWbWFPnmBm2c6d5Tie3LsT+Cpprh4DRojJ162fn7RWZw4ybUNrnghYoN5SvQG11MP08IFXh3Qfnr8i/wzrxk92yl0Gbul5d8dg49LIVoyenlkakB8kyWM25rnfVwi7/E5byTG0qVFsKw3PHWyPz2O6LxzByE0SCx6aJ72GlbTjlHBCTeVDHpaj2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4KCjBBsLuxEF2xxblFyZzwQ9BLUmyWeo3XMSCzqa78=;
 b=od7g6itj6cQcgmyua6jxcBO+AFMGKhY2IiGLECh9hkz9YAVxB28oJdu7luosRe5KP0AEHoybDldDN01UtZsq94uQv7UD/mUNJ6avJ/hCsJHud600p8cZmo8x/ejyM1AZRBfmf3hXJKxcJx/Vts5Qw4P7sGe/OU76KWKSiC+DA9M=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB4829.namprd10.prod.outlook.com (2603:10b6:5:38c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 19:51:44 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 19:51:44 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-8-ankur.a.arora@oracle.com>
 <20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
 <874ipqexai.fsf@oracle.com>
 <20251216071250.e49ecf7490acf7f377dbfdc0@linux-foundation.org>
 <87fr994hot.fsf@oracle.com>
 <20251217105426.5f03b5e8abd2e50faee9f49f@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page ranges
In-reply-to: <20251217105426.5f03b5e8abd2e50faee9f49f@linux-foundation.org>
Message-ID: <87345851kg.fsf@oracle.com>
Date: Wed, 17 Dec 2025 11:51:43 -0800
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:303:b4::19) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB4829:EE_
X-MS-Office365-Filtering-Correlation-Id: e3a96783-ff09-4308-a907-08de3da5b482
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+HQ3bWHysNIfTaxkz/JT7ywWVXNcYkyGGCEWkJ+jY9/Bz5cu8/q1eZDuOQEL?=
 =?us-ascii?Q?d5zsJbhTkjw+/Vz+0GnSZtaCPWmS/KLVG8vBR+Phk59dkkT/uVO9WBhe02cs?=
 =?us-ascii?Q?uQz319gu5BW84Rbo+sPgcxwEJOR8odS+JY+EBr7xw/86/1ILDggq4omLPvma?=
 =?us-ascii?Q?nRYM9+o8AESWGvlEifdj6lrcu1RVIRveq8hFn22G5y1meAwrJPLCBpUn3PFh?=
 =?us-ascii?Q?UE8VV7jRWK68V2hNC5B4dmYoGgOeaz+gFwswWZMpVTp/hz/zLc32UgTbKANo?=
 =?us-ascii?Q?WUzINNr71348fVHKYR/kpkE2AolyO5SfKkxHpki0IM330XaI59NdOXCBqW4l?=
 =?us-ascii?Q?oU960cXLEvspm9K8V3sWqAAcV7Jlr9gQc/mdkTcpJFJW9JGJ/4yXK2xmeb79?=
 =?us-ascii?Q?EK4S6PYYzl9ezSAAKgisVVLCwKm1FvOeEbPTTj7Qg26iRzvmIaNxCtwj2xxG?=
 =?us-ascii?Q?wqoeV5AxrRP0t25K1x5GvtAemfMXuZfuibqJ5vl18AK+5QgaTEOqauL5eAKu?=
 =?us-ascii?Q?eaIokiGbbwZGNW7chuQpzSeNEuDMiAduy/rpn0BVrAX5qZjrBmg2yToqySKT?=
 =?us-ascii?Q?ZZCa5rlHD70vCpqeDV+O6nbg3JI3HHeGblqOIBAjhQPgl4QowqDebVIHIFUc?=
 =?us-ascii?Q?KP4GPRLs57jrR8wImSBw73Vtm4+8eKKul6GajkIsNEQWtFH2GGSiKgj27Gou?=
 =?us-ascii?Q?gGaFQB0aKa7qx0fx0vQXneyh3kcbEOmBNXTtHXNPCDlEyr347ZS1yyAySSM0?=
 =?us-ascii?Q?WmHI1PBXmppOTqV9TiOwKVtoDw0iSsVgjpLSgb8uSrBBh7vMQhcuV0pW9Tzl?=
 =?us-ascii?Q?AvACqFJ88Sar2aTQ7ggl/VWWT5yRoBER2DDoknwa689J21tVMlrsXQaIOulC?=
 =?us-ascii?Q?TnZUclLCstqKy7uKW3y/mw+KwCz8Ves9kZVvcd6t/19tnQZUHNBzNK8yOTTz?=
 =?us-ascii?Q?GS+w56iNCpmxN+WSjAPouKe1PSsuopGqsUrvDNq4XYxOZulopGNlrUGvWs9l?=
 =?us-ascii?Q?IO3dt0Ihx/JVO77XjPcyDZC1Z7QQFO+p/jD7a1l7j1MgXt5Liv+PTgTPdR4c?=
 =?us-ascii?Q?FMoaHjdgBym3q6UMOcm3BVU4h3Z/q0kxrsn90x2L8sCH0C6BdNajcML8aQlu?=
 =?us-ascii?Q?K+KIjXkY+MnJ0f6p8Y+2KO8KFd32WpIgW2WSFW/IBMACpMuNgZd0g44JaHls?=
 =?us-ascii?Q?TfWSFL2jKQBZvfl8zACACy2sHp6gHk8X0lYJv2Ld7o/KNjvXcpxroBqyP2RK?=
 =?us-ascii?Q?PTp9fYWT5rqPkOYS3Rc3zX4J/7Gr1dQ5/O1zIjUljTkp9UaSeqYvdVbdZRyA?=
 =?us-ascii?Q?Sy9WN+CaoaKkzM6nUeiJq8aIZfUxCU/WnWLUI5KYJyouyKr9JX6Pk0khoIe3?=
 =?us-ascii?Q?VG3a574+GQYypq2LyGHyfhwH/zvNjTYhd68ch3HPTLLlZFZUhJ1Cjzw/dYgR?=
 =?us-ascii?Q?HCGQMjTrGgQKCrNxVCuiu9MK16GQEwdM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pp16gLN0U/q2l1oCt87WwPh0UzQ4kBdyRp++Od+N8RhwSf9IVWGQlB4ABhve?=
 =?us-ascii?Q?OlSPc0WsgfQziNRbXK4ZiLi/9yTl3rcLMJUp5gg1H2f2PCBqYzX6JPahh8gs?=
 =?us-ascii?Q?aQYoUzFa5QQvGDR97QJg0VrwU/o4sV2JOwsytuvgQLAIdAEY7EJVcJwbu20T?=
 =?us-ascii?Q?KZAUkA9xrERBZELPbUD+v0F0Iqp0HASDorPPCDWeKOjLI1Neqx6zNwedKJ+I?=
 =?us-ascii?Q?56MFKCRht1zCefMqBhN03rGHcQVK5joc+0LiOXWxkkaU8OBtmqw06xq50vF3?=
 =?us-ascii?Q?6eqEWSJ7sBcp4u1HMaYnAg+IljB77NV1/RBFr2uYnIPXdeCKsQHJXALt/W/T?=
 =?us-ascii?Q?u1EgLZcChy/4L5dYjedskTHQZ2aGNoJEMAmHcZiGH/zsjvV3dBW/7nfBx5Q2?=
 =?us-ascii?Q?6W0UyirWq7xBpn8He/7a13iOrLizB5X3utGa6lNgNH8SM/pvNn7d08t4GuJM?=
 =?us-ascii?Q?tfhmerxHuKLTOITfnMQq3zurLZd2xe/8VqALUdXRmJku6gZOHP6Hufb1nJ5A?=
 =?us-ascii?Q?Rae4/8lNPngF4otwEmiKmIhIIaqLbElhKcoafCYxspYE//oIWgc2dAdI+cGY?=
 =?us-ascii?Q?67okkAVVDtsHiiAKJTIWJyfR05YPD7+AEZm7SMJTWjD2kdlM6IfF7e+5rM3Y?=
 =?us-ascii?Q?yt40CfkQymgDUjnwtd9ur42cirhIT9PYoWkCXrgUrruUDyLsOJhzJ+558jZP?=
 =?us-ascii?Q?KwsVGGqy5ngSMhmN7v89idwv14Qht7LNezPYXWGw8h5LKs4wUn7IxBChQA9/?=
 =?us-ascii?Q?BJqXYwviSZedikObmvf4l4XNP/2lJLbk/qyyyU6lDrqW8/enri4NMimH5ONc?=
 =?us-ascii?Q?4C+3vf1383HlKUnl/h20alruPsL62afVCbSE4ypcNFev4IVQvY2IRDQNTmkd?=
 =?us-ascii?Q?p7fTyW/NCHPGDmJ9NwsNhjl3w+nXuYgJ2XQH+iNezG2LKQmB/cwrIeZBeVK3?=
 =?us-ascii?Q?SY8kGHjB6hBurnaOr6pDaBk1BQCHttHsiCbz2B3eMLCx7jLXZ5+PLWwZ3RVi?=
 =?us-ascii?Q?35qF1ZdQUdhJKHpGIZN13E9g8IilyGXtuYrXlZjCsDmzldHvUPcd+VhbhFJb?=
 =?us-ascii?Q?VQYGEPjE/+GrriwQU3xLOnsqB3uJv84ePvUtyQEGdCu3GbD3G3hgq3bZmORK?=
 =?us-ascii?Q?JIAEcGy3GAXjysmTIKHL8BIqszA078ewtUSaFAyYzdDhw84haWrFzwBeVgwr?=
 =?us-ascii?Q?cnkJs+5qCSeNrXRc0WZM2WPi8f6BsomhIBO0tIbVadtLbnIMAX3kNbGIaPQ+?=
 =?us-ascii?Q?HWAJJEyd2iahJ8FY1DOpDfJq+LaJSOE1/5EzHfrLSk7gCpC38A1qVcE3ae0k?=
 =?us-ascii?Q?tJ80Us4z3I9NKFXC8YphlLScC1e8XI4vtoiCjj6Zk/jBh1gJDt77sj+WhZ5z?=
 =?us-ascii?Q?r2mXdSfnlTKuCREgQnP8iCTO8ZxPqoQC2uNeomjsylGc2kS0Ov4mxHakNrrU?=
 =?us-ascii?Q?JoHUjYpTDtEpGLdRhrhzrYuAg+HH0o0gV30ARsBJbaUSVacbriwUCTkoNju4?=
 =?us-ascii?Q?MkU9yM8Dld5wsWyo0FkVL0udMAe0lcje/6BYV2Y1dWnaU/6XkV+HH5tNA7SK?=
 =?us-ascii?Q?YqYQt7AYRj6iTW7US129KKHTwFYqs1v6PJcjpBmgwisTWQF7zBgGVPbXXFzj?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EZ+lOeHLZjB69rJELoM/uqyP/Lnt+J2ikgoIISHiELAIA79rFCK0RQfnFOXuTkXKiTbYyrJBFAH6AldN8usnh8IAe900is/JtendIeZgeJ2S8ee627eZHPw+4z/YGAkMOfWnPC6tCOfF7qs+K4B9vZUf9miyhzAdrlF/Nef1h/RcZdVWmbNzyAw8Est9sG1h4mJHpQhGpGnJ9c439jtL/bS7HjmWnHPRxpSIK74gmxdAZGYnnneDfGHKYgtJTNOeA0gP4Xy0cuO32O+oFCYVP2r6LwkkvWPpyRkhB6ZrdJsP1rI3bE2z59dkqUNjS51yHlm5IrzK6SFWNEhjsobc4SNU8OW0cxkZ9dMmWkTFO7bynOvdxZ4HZG1e6W/hL2j41SJgDx3AVV7jxv8RKdneJKQjwaeikxaB129rdX6a1cdHiVDiI/pjI0hPcYyPpXpzs4Vpkn3K1QU4BSJTZGkp3amhgsQnYh8QRjW6pfjiucwUtoHo/jgpRpnS4DKCK4MPfcy0NXPG/r68zqjM0ZAO5G6QQOPxV5y0yBOKnVoU4iFXr+MQUQY2Q44//2pA6BqHzG+XY13D13+kaKSvl8PyFZj5SCWl/+xtiil+fzzdoRM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a96783-ff09-4308-a907-08de3da5b482
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:51:44.1737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDjRXSgv6AgsuxQN9bH0ykLOSVJWUo97/36eE4Rc7Umgdtz6gQdl/iFT9SsJPZjMlEHAHtH5ehi+iT0nNb8euHEdni68kHiXBDAv90OxTZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_03,2025-12-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170157
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=694309d4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8
 a=QWp4f3afz0_u6ju5zfsA:9 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: pyZEd82NaGoahJXA1Q_IrO85dKskevN1
X-Proofpoint-GUID: pyZEd82NaGoahJXA1Q_IrO85dKskevN1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDE1NyBTYWx0ZWRfXwcVttYPCn8y2
 1ribskZG1YzudPDpR3vQ5w+B06WWTq8jFzej6rEk9oYuTNHgAHhIss11Iv9CdjnTW0UAK7UXVPT
 seeyStXMyMyPz+vxqZrg6Rt2ksbcpj/EIj/58Y/TMRd6qpqeyIHn9mMJgp6EbV/fcZidcz/s9GX
 44jsCRR3x6djbNhAHrb3xeZxlwTWsVTHlOxM0/6OJJutqA/eixOXXPKfZGKgPdAR+Q/RSJQ99Ts
 W8QE5XM9RGGS2mT2pbN2mnh4IVwRpC4YcJxebya/o3cd8qJ4N7OLB+OYf5J1pnrll5q7XXpCXgW
 sc/tw8/3EPvaaKzb2EhYgQsSLj/9qIYz/M98eI80VVSEkUIEx+n82+tGPdHp2/98UnVUj/nv6eV
 cD6ZubkTFcTtKy3usWtmLisDkWIV2wAgLuc0viBEiRkOBPXy9Q4=
X-Stat-Signature: umkrkjhtbdrsn3nt8j5tnhj31aqpzne5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5324F40002
X-HE-Tag: 1766001132-170209
X-HE-Meta: U2FsdGVkX1/A/0eSYZkOezTuW4ucJy4aj2TB0e9E8T8Lh/vhkga6GG2+dHwnJvN2mRbNTbJgLlzGzq/80EOkZsu53uPN5QdZvHWm7t1Mgm7UumGdRTHWbBbqJiFKjGnWJCibTym72H6JkNWhWXrSBUUQoVv32mMrXGV8G0JSLc205XQjEkBhj90onme3S7SP1LC3voxJVnE/cRDkVs6o3JXMfKrEsR2yVMTIJe6Q/ZS+iey9pwp5bd2abvwu6p9cDfAHA11p6zhMLZySQDnKSswQVm4RsqmNSK48ptAClCvRkR1u6ybOEYPZbTSqik/FyLs+UXxEt+WTS0s/FE+WyzIhcLFp1oRsYijCu66ZBdbW/DanqQ9eGbnpCBxLw/ZFEpA9sLz4eNFGI0n+Su3fQ0pam6T3BEEDZ3TVNS80pX9y3xiYki57UxcUsjmFjzxps62uDe+cTZI3Jp0hCuL1cZff+6cQNrnv3J/9U4KMqiDFle6DCX7fYzHArit3NZPHxqxa8Xg30zwerczTfD1UMJ/IUXELWErDo4bXhH6WofyGWSfp7z38jZwYtXsdZ8w9iD+vscYf0DLK86TTj+Pio3y7wmfzPuyDr2gl6pYBWWfWgUXUygA2hB3Y/NYeKSRIUCO0jMqp+fTENOCoatwrWbaX9kTY0eKgBEd2jfd8wmEK1iIU3PWIb3DijPpPiW3bL5Hha59+heiKHf9zorqTghM67b02Mdowb4auqhOTA5UVorz6TsLk+v9J+Rz4RBPIBxrmiTtk7w3Fsz7Cailytp21FSxeg/iJvdFX08RDemkaLn1aEeHRpkhrSFzc97jtVS7+iZE+dXQQs+vZFtB9vj7NxiZc6XHyfWD8tQVZzFMYLpQR2JxcpMJ4F/bb0o1E9mRj05BzAtncUf2/YkE66VtH2gDUSthD8ilhDw5RX1Nprhwe4U+K4l4ey703EAG2JXAlfLQyOnvEXex1tob
 RFt1UU1y
 p1VJb4HcE2Y3q3NeY+zjOrpKd+4Ga3q1+586nWNej4YaoBstsxjrIkWySxnpGHMcvi18a38vy1Q9MhNAZueLhjBhFrBDvDnsDzmUsh0Y/eU9xV19m5giO18j7nqTM0iyTkkr4yrKGdrfA7OhnU8+HYZOmmH5q1haWnJ7jQlgWvs+u2PwhnJWr2C9wsRSzCvohEHxm67qemP+9KLQ9Ioay0T46MH5H+Mi0pbEiap2J7oPKaVE+hYLJ/j0c2RfiXQBo8t6/c26s/smBrdOK+l9fjBVolv2WqCaRE1mE584b/BMmVe4j1dqjWzU4PGvAll8GsCnSEVCt5UYZEhVVhbf8uaSY7qZ9VT8QlvzCw4Qg19z7f78KnmZD9MVuWULInEywhP6Mw2AGjwRz7L4AUzRZnLUf9y447aCCQ/UzIq+P5stAK4RdeV245DYdhbocB+j08B0tSFS0HYoegXEje95qnkInR6o/LZIB7UrgTRamH38zxTfWhWWMNccOTCzmq84XkVCKq5RC7yFPD0CgCD6RMIDLc1zLIcSnlth4duw/UkLkhYcu3HXGOS+iHHAdWitxojb6ayABsPKrB0u5lUefDLHVDOFA63JY67WUbxQjH+dKrYVvLHKcf5FTX6JIEFWjtbN3xY+c3hs1KwumTLRZm6eXdibpjMVC1m0slr1YzaVdxG1EzP31Dgo/dZlwNDqbfq3jMQkel5kUMas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 17 Dec 2025 00:48:50 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>> > At 42GB/sec, 32MB will take less than a
>> > millisecond, yes?  I'm not aware of us really having any latency
>> > targets in these preemption modes, but 1 millisecond sounds pretty
>> > good.
>>
>> Agreed. The only complaint threshold I see is 100ms (default value of
>> sysctl_resched_latency_warn_ms) which is pretty far from ~1ms.
>>
>> And having a threshold of 32MB might benefit other applications since
>> we won't be discarding their cachelines in favour of filling up the
>> cache with zeroes.
>>
>> I think the only problem cases might be slow uarchs and workloads where
>> the memory bus is saturated which might dilate the preemption latency.
>>
>> And, even if the operation takes say ~20ms, that should still leave us
>> with a reasonably large margin.
>> (And, any latency senstive users are probably not running with
>> preempt=none/voluntary.)
>
> So I think you're saying that yes, we should increase the chunk size?

Yeah.

> If so, what's the timing on that?  It would be nice to do it in the
> current -rc cycle for testing reasons and so the changelogs can be
> updated to reflect the altered performance numbers.

I can send out an updated version of this patch later today. I think the
only real change is updating the constant and perf stats motivating
the chunk size value of 32MB.

Anything else you also think needs doing for this?

--
ankur

