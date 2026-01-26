Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5118CF65CC
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 10:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6FF6B0088; Mon, 26 Jan 2026 05:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65046B0089; Mon, 26 Jan 2026 05:04:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1BE6B008A; Mon, 26 Jan 2026 05:04:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC5416B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:04:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 576591A062B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:04:35 +0000 (UTC)
X-FDA: 84373680510.29.7D73573
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8BC9C0010
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:04:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LIV+JyFr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JJQgoAL+;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769421872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRwlH0lms+lzNuQVNRHiQBk94V9RKdOw41li3qi8lKI=;
	b=6axuqdEhqdxslo5wVJUi9TTEQI5dzsdWsQh3VrGnPXYYXxzShahSfsD1qDINtAmb5Xoj4s
	QN8GEz9pUF55RSMScvBDLxr3H8T6Xd4Ppc4ea0UR65UsIDFHk+VIYF8WvokCVPc6EcKzOE
	eCm0XLBCVzSlHxswCSJHWM9/4wiMtDw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LIV+JyFr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JJQgoAL+;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769421872; a=rsa-sha256;
	cv=pass;
	b=K1Q/9mw65tSUG0KhUxA1NlhnqTa2oORl51DrT0m29r+VHTOj7aU0xjxg6Vc3+70R+etOFO
	70UpG9qFjR1tQ7IeIG61Vka/EaUiZp5Kqi08DrvMat3hthOsTFMcQzwa+QshSH0gw5pEfz
	XWaZfpv5kqUfL0IK4ohH2elEhvxhfmo=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q3Kl4l158731;
	Mon, 26 Jan 2026 10:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZRwlH0lms+lzNuQVNR
	HiQBk94V9RKdOw41li3qi8lKI=; b=LIV+JyFrjpOcaSKJsK20nuXqF/nlVA+LZZ
	Tm8tdaRIlKIDZjsmzYgGupwilFYgnBmQN2T9BqkOJ2rYptFXJEIMUKGyp70rXyWL
	1sssgyGuhrxJXpCFQuC24z7ssqoJbWS8533V+7F4dGoTHgYkhKc+QQ6PCxpyxe4B
	F46ohqq2rCn5xRVoQp7C+CwN0vea6yP/firMAMAOn9W8ZDk4RccgzjfquUzkN0eZ
	Yb5hcAslOKDVgGKvHAcGsgVHbJBkiY9ChsGzCUtQVmcTTAr9z8H2wvV1bau9uPHp
	UsG4Yuf1naHRHn9UZ10GwF2flXJDKuXVOpU9aFOQpYmY3gL5fCfw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmny1mwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 10:04:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60Q95NAP010007;
	Mon, 26 Jan 2026 10:04:18 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh7ssgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 10:04:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZ2t6AKBFAMlwL42jtD/aD4CLNH5HfYXU5lvitMt7+cafpEA9sfCWRiYMMgqhIi9ZxHZOQ9f5cLaIZcXl8vhUR7IDzvcHdaWRbkdj1k2QdLHygGtUC5RxdjOX3a5rM9Zo4E3tAIJ3SY3YVrdncIOutCdT73GoLKlYYnmA6nNfcbKryrdl6rSsb9tTmeokcVwvJjr8CBLk/K7qtODL2+QtiE61rWgaY0oVNR9bVbfl0afylTyWqkpZ96h+swIUg864hfGa0FnVBHMlgDm8rw66SwGlX8GMZ0fHWev+/E71bUPbGJarh92+guyx8/MbcXKSPQVrvV+LSXkYsZKX+EiHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRwlH0lms+lzNuQVNRHiQBk94V9RKdOw41li3qi8lKI=;
 b=qBIFj9eyoYKh3S2efIj4oa12GLrPXJSbS42RSKwwKWgJXQBlUaTy+GY9PasJ7ncXAl98jMbH0MpGnQvGUgGpL+7Is5tWbuvOzmyoS50JC3nQQrZvU08rjPMu6V8z8d3tI8KPkaanVpAi+eeF/Cf7j85K9Qzldzn5WadapPlL6OW1lsCMjiBm1nD43SJK4ptpH64m5oKBSBWJsCOJdhinXgBewVYdnWo6LdMyDDChRg2G0OYnVr0yHz4i8pOtDtyeSKbMLFOy1cgRJa+gE+IzYcUq34n2pYkcaFJzNfKYBRd5eUGInFnx/kJSsIJnU0bWFg3cqIYuaDZgelTzUHU2hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRwlH0lms+lzNuQVNRHiQBk94V9RKdOw41li3qi8lKI=;
 b=JJQgoAL+0YOVdZgCWSXUWXlceKKD5sebkAnXLPu8I9ibsF9u7iKH4db1gjVmRDOEIqwhFFEkG3zV/uCf2Nw9erZU4alD0ls1uUXj5UXnTue1QEE6lbzsyOF7ZRUkGDs4cPxMFZ6EX0RjdxwMsTOhiLz7VL/FDRj0x5NtOTXGtRI=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6759.namprd10.prod.outlook.com (2603:10b6:208:42d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 10:04:10 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 26 Jan 2026
 10:04:17 +0000
Date: Mon, 26 Jan 2026 10:04:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
Message-ID: <70a156e8-9c39-489e-9072-16b1ab483d08@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
 <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
 <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
 <108e3f4e-cd4f-452e-9bd2-1a5b892f6d60@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <108e3f4e-cd4f-452e-9bd2-1a5b892f6d60@lucifer.local>
X-ClientProxiedBy: LO4P123CA0143.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::22) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6759:EE_
X-MS-Office365-Filtering-Correlation-Id: ae929acf-f72c-4859-0c3a-08de5cc2442a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0IqqQXLgDox3Py/H3ava0fKa1UbDLCWjlSLyjki4wnJeI+aKRHX9Q1Sg7SQf?=
 =?us-ascii?Q?YzObdpByr5XwwHR1GNgk3b1qoN0+iFSjn8E1e51l+icECiM5+nhoc+3ROnA4?=
 =?us-ascii?Q?I8t16/5By2bb3zxRovf1ShKgKTGC8bqATmXNd+SXTQuN+viPdF0NQYeq22uU?=
 =?us-ascii?Q?/nHzAhTgnqx7BLxTybGfALKi54neOe2AdZHjWqWYFeQ8UurwZwiDSImdTbPH?=
 =?us-ascii?Q?dBEqww7ChldHuD+ibehTz9le1OCgc2ColeRZvJ1AFHf1GRSmP6LyyXer0INt?=
 =?us-ascii?Q?zgk4G+/2pLw4FRYZSVo1BSwiVoIkkDQUVOFbJUPDepADZQskW+jOx2yD5+BC?=
 =?us-ascii?Q?UQQC+NjrUC6YCzZHHhDqQFFi/sQ0yLnnEWOXpTFyeqwBPcAA9dP7oITTXdLR?=
 =?us-ascii?Q?WRSajyoFuIK+qkNF/EqSM1oueIyYlpTOouvp8ePbTxhVqxZnB7UbnGSte1pn?=
 =?us-ascii?Q?zZEnA8aDT1CrecHxKPKxm/aG0g0UlFP+5Y0Y+gJtJQJjO1LNr+TZE4RyOI9w?=
 =?us-ascii?Q?lVNZpUG5uJ0bqcRZAQ0INJtKXTRUxBKRUXLrtsC7MOEAfYpoz3DaODJiPp93?=
 =?us-ascii?Q?8V//kuUZILI7Er0oS5YIYZ9Tou++icJKaybMoIksT2F4aaP4AIr7WKkK9W2e?=
 =?us-ascii?Q?ZClwLZPYZiZsP0Y6sWbPIjyicFsGBEp2zSdqZrwd+8wUs+nB19Smh8DvO2jl?=
 =?us-ascii?Q?7We7wE/1pNgaUsAX9nC2rUbuXP67fHO+sqHqxm16Nm3/YGALdyQCR3bTWAk0?=
 =?us-ascii?Q?i3BlZTHPYP7ncbMHtD0I28q0Q7RXpiE//9+1SLafLwghuffsXvuX0pxPQ4bA?=
 =?us-ascii?Q?lsPNl6dx9ZUOlyqSfoXlnw+fRjSeT4GgpCuNuCV3e/Fh5IYcQXUobD45WAoG?=
 =?us-ascii?Q?cOHuO3o+fSI746+4PrG1ae+rg2tIitzd5u7wyDYsiIA0n2jpVhqf4qufsYcT?=
 =?us-ascii?Q?SEvnJf95WkbbcC8T4Yw2rUs0LZoW70CR/FUdZPzUQXcfRY5M1UnWiVahKF9q?=
 =?us-ascii?Q?BULbd527sV4WRqpWMT5s1tUySOhqcnwq8DF2w7izqkMV1DuJ9rVhhPtNNDSV?=
 =?us-ascii?Q?5J/wG8diJ6Ol2zeLH9ee4tkO1Pzd5MWyM3k7ZXHXD9D4cEZ0AxtTNRkopsHW?=
 =?us-ascii?Q?KmftHRq4971JZmFUIsAAlvcs3qBsSzQXTAyfU+u8uu/pD8gwI67WDUKq1MzM?=
 =?us-ascii?Q?VDccym4l52HMDPRC3twgWRPk359sKQrjW4ctLGSmyuwjl/YwjiJbiOSt7eey?=
 =?us-ascii?Q?6kWtl6ia3AY0y3m52Ixy42GgB2WjGBE7Kxy6Nlio67gNL+fnO3YAZtER0MLu?=
 =?us-ascii?Q?4kwTsPtq3mVurMsjoghGTe/LtGhJZz1pejdez/bW8WtsTTxU4kEX7vH9ev/O?=
 =?us-ascii?Q?ctn1wuS9KxzLlRIqqS6FSqsA7V2bMNcuscRuLbyqILuZVozXDcfs8dz/oD2x?=
 =?us-ascii?Q?tnPm0DxMv38xoNZwDBO1Gp28zoWRsT4eJFfv2MjKmKToSnq8W4Fqfy8MZWfG?=
 =?us-ascii?Q?+vtQVf6l7PTBLi+Ed/jFgBbiNd9Y/40VacMdahjDyuVkCSRmPph3/WaK8EUR?=
 =?us-ascii?Q?0/fuZwWp9Q8m5PQSJMs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TUqVnsak0msH2yEDQJMjj7QX8EdM6IcfBoQ7YJTSJ411XcLgajrTUdquf0Ft?=
 =?us-ascii?Q?aJOCHb/AdxuRhMPdv12K5jFoXSuWns0LUfMrL2T/O9LdSDPVFwVA+Vqc4kJz?=
 =?us-ascii?Q?6aCtITFsbqG/9gy1DjF9+vLzg6RWbjjitT/+m/BFLA+B1eQ/KlrnbTwK/FBs?=
 =?us-ascii?Q?TOOtqAZEJfMyi6Yr1L7xNi5fpuERNv8A09qNLl5481kIaU4x5JOe9j+CsPSL?=
 =?us-ascii?Q?WVFvbpCHKILjbgoZO+bTG8UZ/8eeUcIt0WbJuT6lOhVw+Q3eo9l5yeuSt0cM?=
 =?us-ascii?Q?O0MpJLgWUWnU5PBwq88iRMM/GMVrGqbtnHeeX3Iih7glbkbB9qo4PCD6j464?=
 =?us-ascii?Q?+ekPAW3VEXw7bOUjlvpEVZq+V+9xTOGd7BgWLr5PJGMTby+LGk5iO1tk40ZK?=
 =?us-ascii?Q?Xlt+9F6p0Bzb0Ynd8+FuQwHvML0/4Qxd489XtdY6TJRpS6gPChjQ7B+6dc8z?=
 =?us-ascii?Q?sAI8eGQLIw8H/FGXNLq+0WkbUrTexBacHko+g1lgZ72p0s4oxT2tNTO+DaVk?=
 =?us-ascii?Q?3H+vDMYHuFP9b6fPlRvhRad8Ca3hsLInWs3x5bF+gNKMRKg12hoksO6Pgttr?=
 =?us-ascii?Q?2AGeat8nfnUPrfZ1cK/TkgZ57c65s54vXunVOMiZwaRe6hFjCIs/nsIsB6jj?=
 =?us-ascii?Q?798uWYDFpwBVXojW/ZCrJ+uUW0myH1xSuCYlZY70fVTlhbpPeLdE7Py3YU7+?=
 =?us-ascii?Q?Uf11pMqyl18QBoHFY7MDmdqy3omgnHAruM9GB/65gH2KzFaIJlmGX43nbqDp?=
 =?us-ascii?Q?ToyyBfx+9CLE3sMycdpjRg4lIIHMmrbjPneE+AY+wuH/XutcJoIjjyDK/EuA?=
 =?us-ascii?Q?8YexyTGMBbQ8c99YuoBTUDUTgaoTYgaxnPwsiHWO+eZA9vUmFlnQFw5llEF2?=
 =?us-ascii?Q?k/XGRrRCUdGsLegG6lo2F0BI7V35SBguDMh20X+dm4Rj5ebLgwjir+WherUC?=
 =?us-ascii?Q?0Q3V2C8ghN17CujuFWb3815Lfw+7BxZUk86Tr3kIb5vZeycxPEq6LyQu6ua7?=
 =?us-ascii?Q?0ROvtsiOpAHoGDgct9fiLnMvtqTobQjDGsRCAO0zBS338o5pqR8PdiXaucA7?=
 =?us-ascii?Q?3/0cym4kozdozak/jGujWkRT3ZacVr/gGO140/dwENfXfA0g0t0sjwu4m4ce?=
 =?us-ascii?Q?ufSk0Wp6Ph5+Ch1jWTB+lQFsmrIm+zN6lbc9tP4a3S/XDpyUJAhzR/ULODys?=
 =?us-ascii?Q?cI2nDRWgrpD++uI6EhVVT1WNTq98BwbpVF6nmqb8qvkiE7oWGPgsLyjSNW0L?=
 =?us-ascii?Q?RjhBWWzPWQbQ/jzuLo3Uyz91dm2j3Tc4PaVXyEisHEtddbHGnfc/zUaDmEnJ?=
 =?us-ascii?Q?pcUGzAFQ4JKS6FttPAPbBpqjWI1TBoNmYtVCkax4aftCI2IJlFnUhGzByay4?=
 =?us-ascii?Q?UM2upPWCt6DomruOglC3QmzCdeis4/THCmgpIEiG2xDRpjGlTcq/HSk6dAPn?=
 =?us-ascii?Q?IOv+nNzc2Ad93O6mAwcU++8gebTDQxq7BlxzM2mhlBJsT2HHIrSw5sT8gIOC?=
 =?us-ascii?Q?5aMnILGGwz8QgMYiXvgKmuNu+LzMHZ3x3M51fNv8Z6C5kAG3V/vR4TA/4ckj?=
 =?us-ascii?Q?a+f9T7nidHIgPaigPWM9YMm1FyU5R9u3khz2zkEfUzoREw7kx+dVJzdm8VWU?=
 =?us-ascii?Q?gufeeDIKw5zJE2+aAQfjKDe1nQIXt0GEbaklo1IAyd0gATuRdIikHdmmVIdb?=
 =?us-ascii?Q?fR5fL7Q0OrF92M9DNUuJAa6xPp9cKTsotTxtUvUm3Ae0JOh+FBivNRyrRE0P?=
 =?us-ascii?Q?fNj6Ka5/j6+tRDuy2738q1SP3IrQ8vg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aW5O09o7rIFDeo9iDNE2kiLtyItwvuAIPdzr2tBaM382CAqSgLAvUOKu2WuIxqqKq4rOIq7PKihqX3tQx2NWd2bcst5eMXXjq+xbU73UmDqeuVLXOLfROuvE7EXb9yDzkRzgynKR0Z9nOoK7OStjALbvBZIgwnePGs8W073UPggeW46MGI10aoGQAqB2XQvcimBI/6lb+srmCWl2SqywaXQyfPOiqxs+QZvwXAs/Is6mIPXp4Q3mZ8EMJ6V6dHYWytQIldXF65yAea2VrwWxkzVQriUmY44sjvmJSs9YPUhzKVrW61f3g+Vxol2mbA+OFLWU4X2fmAXiahGlD0EwiibHBWLC8ec1lh2smL0Snq0i+RK+nf5yenQC1oKVHIEkuRERKe3KKXZVpLeHSPvw7NgymG8jU0LkMm5MK+lU7zQQ86IkkxCV4h65dhVnN7+1lqHq0ZnIgPuUbOM1r2AtNfWtr2L+xlyLPcEmxIaefkd0vocAN5I8VFTWdheafivlLIQ8W0rsGaIfrCSUz9c9T3JpV7AvAb+3iz0m+T0Rs7+DzdS5ancnDUZr4Lw6xLVW1JX+E/sOvTfEacDf7a0ZXw7CxdBmwdpIXcSKRX7ke3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae929acf-f72c-4859-0c3a-08de5cc2442a
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 10:04:17.1025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldiZvcCXTaVeKLxVnP9ayrowVQoTUrkqvTCw76AH4hu9Lf6SOUva3OkwhvvcyZttmimAzDk9u2zmyFswgqylUiYweEoC1YEJTUaneo9xmGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=951
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601260086
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDA4NSBTYWx0ZWRfX3Yn1chpkYo+k
 cc81mrfksJXUXu35KFDPeIiM3DVlOZHp7c03SuTvYA4LofsEJrQX8asQHA2dIbPw13NWx1tNr0J
 wOq2CgJRKq1KQN/4PSC3nP5xGqUrH108zjrfa47R4J150M+JbkgbxARcbWvX8DsAryqCO38ZkkG
 IBmAVip968dqpqzywJ7Jr60TGrYDRxoiYfx6zd1JXG2WXFzhc4jKgoQwWdAvWHYyHmOz5j/qrJ/
 Rmo/bqeXXyJhO/gwyn18QHzLkoIkPCw4pa5I83/h9BfKt3fD5Wa8yngYzx3TfJcyt1TZnL9dsAV
 u7FAH0uIrXEpcpBP0YbsXEQEZ+oB1eUYiO/iVHqWwktVNTlCwU5K0c3OAqjlRXUk9h3XAW+7CxP
 mrlPn76m/2ftYpmghwYOLBYlKIHy/5lMDlC1eDtDUSVeCIVRdGbYFcclusUL7FIWdplxbWDvTqr
 pW/K5R5sT1/L2uVzCag==
X-Proofpoint-GUID: gvO6XyrarTXpEUVjjBHjPpYJ6FkV3Baz
X-Authority-Analysis: v=2.4 cv=cZrfb3DM c=1 sm=1 tr=0 ts=69773c23 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gZ9apivgIgi-DPFVj38A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: gvO6XyrarTXpEUVjjBHjPpYJ6FkV3Baz
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8BC9C0010
X-Stat-Signature: zohnismojtgbr1bg1finsua3n7q57b7s
X-Rspam-User: 
X-HE-Tag: 1769421871-95173
X-HE-Meta: U2FsdGVkX18gWeCSNyoa/f3ooM2d+11Pnb+UqILtMrE9mIh3VW0j/Nj5MurCYNeQ6CsdkYrGYYwx0zA7fEvyFVztSrOBiXAS0O7Mp5GwWcTRKkhr/g81zYw46y6SgcgZaiROQe7cp4ZzWGeqZFA+2iy7eSbVJKjfntUyYrOHvFkAPVxs4YBBm/ooPt3sEs5616Jut+ZMKooSiMIxXIj0QutZv/EB6K9q7HhbEpZMOXlXGrjO4f4DxjOt0StbARjB4rGuWgYHBXW0snRvhzXpsS1eohTU+q5lEK9R+KhOK/ZyHltLG1w9+cEaCrkdX7TbG09m9qJ1lHuUeEmxAsm44H9AvrqtWpaerSVDzx5bLghkbfupjFTQTKUqfpOp4TEAk/2SS760VCfUDJJPJV9S2MXERDN2YWNNL1TJKvBEZxtlUsLcGc92RlU8ncGS1cv+ibyLrp5FsWXQimVcZ1eu7sODNftMCs555TYPLOSx7L22FXu8ouDp2L7kDVcaKKwqWZVSej9cvCx8njgvSV98NdRTv87R0M0rgLHMfYJp6NRzbnLHdFs0bUxefhB4ZF3H6I2uW6QaTyg4GBxpSVc56Lrhnjb6Qa3Xnycl4Sw/y/0xf1nhwZQzrcK59pP9guaHXbFDFjfVuzaAlZ2A2HizzWQJ+VrmQD1fcXd27Cf8ON4ebgb5LHBtee0Y3B3pFAGg+RwLUI3ceuHqbA9T9ImJShg3AOhx4sOu+/fiYde/uhq+fbv/NXx7u9hXxxY7J0ftyDui0k6goQvoxxxF1gPsj9SI9qk1ivRAt7BTvEkQibedwk5VX3lI28LAaJUFCPFFjd/PmLVzV2sgozGye8cbU6BfLebeL93lxuWeAdQv+zxPf/j2MEX5xgnvoaNJOyBkuOimIAN5At2IBj5LjcJoQ1W7b0UoZCleWlxVa3kf21/XfhVzQQbNf7/zGLTJ1Zgr9nmMSpDyLy9G60Cry0N
 gk22LkE9
 4MVlhM4ECvYRhogol5RsU+OLzFeet7Ayw+F9Qccp0Q5AfG4tcbPt0OzsKLr6s6Rh1ddLvyQHbbEqdQ4o3vbABvo4AJCaBrMouSkQBwmLh76Ce2SPpCCLrWbv9R4NHHnRvFhZXwQ0HE6OFRNRxpHTAGSMl0KD5IYY44vkhkdyjhwiuPdyYxz2JcAmDba/YU36lNHyLbDEIfh5/rSLDwfdlbPtjgrJUmsDtxHEJ7VggXNlaOecOIUGSj3EGF2ewHHBxAkJzFqjuJ17A4QU4cPjFUZvQinokoLWGhsUJVfXutPF4CkmCzZczGoEL31RJ8d/AuiMNOvDaGyTtT+qfUec4GB9XoxOLLUsCGXCuVQf3Eh19TOlAOP5ehzICsO/WSCeNcR/p0I0kn1ce8O/19IiqQw9CaDJNeDz5Q7bKdH5pECvdC6Z3R3ogGmxKvFw4DoEpQpMo2JMhP78cI2EDqNi/lYU50RgD2oZXhQ5lMo7iKwIjqwrxX/dH31Wt3Ni7+JL8huTSaVY3UMAf7m+9gNhvLxJzDW+KvIQxiBldBD5sohIoJPGpDKcTJUwL/JlMYJVhnZrSTyY6393Xsb99DE+SVdpbvywcx+mxlV+QedPJt/Nz3rFg9Y36a6UNHvY1bdjMXh5FtPfvF5jYpaLHLueQJub6+dmkMGPTcjMkjW9xj19/WNw2uBOdxtHcXkki9eOmlghtrEvPoXqYDiQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 02:41:42PM +0000, Lorenzo Stoakes wrote:
> > > > +{
> > > > +     int oldcnt;
> > > > +     bool detached;
> > > > +
> > > > +     detached = __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
> > > > +     if (refcnt)
> > > > +             *refcnt = oldcnt - 1;
> > > > +     return detached;
> >
> > IIUC there is always a connection between detached and *refcnt
> > resulting value. If detached==true then the resulting *refcnt has to
> > be 0. If so, __vma_refcount_put() can simply return (oldcnt - 1) as
> > new count:
> >
> > static inline int __vma_refcount_put(struct vm_area_struct *vma)
> > {
> >        int oldcnt;
> >
> >        __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
>
> You can't do this as it's __must_check... :)
>
> So have to replace with __refcount_dec(), which is a void function.
>
> >        return oldcnt - 1;

Actually this doesn't work as __refcount_dec() won't let you decrement to zero
and will flag a saturated error if you do.

In the end the code looks like this:

static inline __must_check unsigned int
__vma_refcount_put_return(struct vm_area_struct *vma)
{
	int oldcnt;

	if (__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt))
		return 0;

	return oldcnt - 1;
}

Which combines the __must_check, abstraction of oldcnt - 1 and xxx_return()
naming requested on review.

Cheers, Lorenzo

