Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C00F2CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9EE80185; Tue, 28 Oct 2025 13:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D18A8013F; Tue, 28 Oct 2025 13:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0995280185; Tue, 28 Oct 2025 13:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8CBA8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:00:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A9241A0521
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:00:08 +0000 (UTC)
X-FDA: 84048135696.04.EE2C8FA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 52C49A0019
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:00:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V55C0LDo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rHtfIkAS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761670805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikwK8bOzxTD1PndpRZyD3513qxHT9lZxwoJX+tPoylc=;
	b=mTVCLsI7ENs74OlVNyAf7gHN+ZH4w/1p2tpTGLBqqnftbGD+1eS8NOFVlc8iaHkClvN90d
	9aPaQWOPF/QsuMDNHRaV0qe7HYJGwXBA6yYHCjltzGwGqEHOk6FbEHAMKIdwFHkGy3A5iS
	MYILF08gZZ+jWZRzOSti9zFWgFBaOxs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761670805; a=rsa-sha256;
	cv=pass;
	b=4VxRxcCK9Z6eawg5b/rUwExeTiDDvU+eljB3KqZp/k7TrdV+dDrEcuCznkx/qU1ln8N6jS
	4JfKvGQ44ifKFhQec6RTlaVZ2sDjalqrG1WokqhBB/kxxJXIhDFLJ0hkdLJKMComnFEImv
	RVoQTssju4fGF86laGAXJKZ61i5p0AE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V55C0LDo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rHtfIkAS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBEUiZ021132;
	Tue, 28 Oct 2025 16:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ikwK8bOzxTD1PndpRZyD3513qxHT9lZxwoJX+tPoylc=; b=
	V55C0LDoYLVp8Cn256yY1XQ4J5wyzixMqzgN4XScmBYy2rnl4Hxbgha2CUGAOWEM
	ZgBgkjVxtDtwXDezydFg6mT6f0olVXySBLkNYfd3Metuwab2VKhnHJ3E8em453T4
	qj0e4m/lMBFjOOfXb7VpJ7GlzBKZGlKMojJuxRZa0gVu4RDjHiP52ybiMbt6CSVh
	ent6PnXPfhjFM1L6y5u2z9tyE6+iU6dIGiayhllMalgBdPxbCCvLdayCxi8Zc28c
	CXu35HuTHVtbsBPgxv2hI6RIbeZdXHsW3idJ0kgJvZpntbj9URaSOlMD93m8Qq0Z
	oN/FujBBql/CozhTNETmdw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uwm28p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 16:57:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SFejCR016405;
	Tue, 28 Oct 2025 16:57:47 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011043.outbound.protection.outlook.com [40.107.208.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08g3r8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 16:57:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hniVh95/8a9ZP2tQCalgheZrGOqBP0FtQdr2ug1d07IsNsF11bM3kTz4pla8XM8mqlmi/SAILknvnuKgcxklyhZqyes5AbOJZ3PoGPmTJtMPJvXCIQHpv8mjH1eKbUuBs9qmJXInt/9W8Nb1JNH2bW/NWLXA6PN89uwzDnW2serQ6EyLhJsACwim05CgouQw1mVjuGl98QfwhED4vubKhDg9IXzQATu5ThtsdJZWaDf9a0z/KjjizatxzEwRGk2jBRVhmi6vlANOqk3X+9RYgLM9802tbc2ccD/HXyAyeCMORt0cmi4XiGZZypQneTsle5t49y/DoC5uw2foRFZoxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikwK8bOzxTD1PndpRZyD3513qxHT9lZxwoJX+tPoylc=;
 b=XOTDU1EbJdPNezyAi9zBk5MYGamdM2epeL+GCGyclvqx8EnQksJu18IMLlK4cgcZ24ndeqMubzN7n/7ne1GxYSb6Y0ZHPjoDrcnz16Yg+kHvgMO4xB1yX0ueJrTqMm6t+Foc9NvABPeUWra1y5Z8y3pJueeKhJILOSg1hRORBJdfTWG8klV3n5qUZ/MRg9dxAtg789lvVUQbfklSeU+Jx4yqFNtzBoeFQrZVZR2tpBAvBdQgc1G9pRO2mVZkGmBwa9UIHi7ClzDhMzfhx2ErBMRiWTa/BhK/DYChGL4c2+O8kj9s9mg589RL3S+R2fMW+7RUTgzADaFhzltGSLvG8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikwK8bOzxTD1PndpRZyD3513qxHT9lZxwoJX+tPoylc=;
 b=rHtfIkASCtQaNCyc4V18VAXp4+exr91A98n2GNWuP0sGfjRYV2zSnXHmvWThp8IzpjjfIgHQph+NHT2oAtDTIY24Fiw7kkjXmnBvg9x92DoSAywJOG+YICOHRsjbUhr0xQmKYA4eWHJde5NImFFsyPk+7/ZrtvcOlFa4KtwIy/0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6480.namprd10.prod.outlook.com (2603:10b6:510:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Tue, 28 Oct
 2025 16:57:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 16:57:42 +0000
Date: Tue, 28 Oct 2025 16:57:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <2983c165-8c13-4bb9-b2f8-bfe8508cce43@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0216.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fa8c013-1070-4049-96ea-08de16431c67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0tmeUhITWM3WlJKblFQNVB1N0FRbW1UMVlma2NFZnZZbDVwTkVtUlB3Nmh4?=
 =?utf-8?B?UlNrMy8xUXJjWkFpOU52eWYraVZyNzdPQWJBcWxKV1VyR1hRdXR3Y1JrdXR5?=
 =?utf-8?B?dVhPc1czWjR1YzFidVBZTjBHelAzUkZ6VzJPOUJuM25kN3FwT0RlcTdhbUdB?=
 =?utf-8?B?bUtlb2haMDlSMDl1elRYUXBvdUE4Yk54OVVadVhGcU52UURZRHZpOGJCVXJY?=
 =?utf-8?B?aDNtc3JVN1gwRER4NmgxaWFwckVXYng5YXdVZEF1SUxvV0wzRkpSUkc4ZC9m?=
 =?utf-8?B?YlpBbFI1K0dZRWVBU01SRVZPME5NUUJIL3VXZlk2T0krbTdQSC9nRmJvZkVE?=
 =?utf-8?B?bGl5R1drL2pGR1RJY0ZQN2ttQWxpaGtueTJUckQ3QWdZZk1KbWtzcngyZGZ1?=
 =?utf-8?B?cGxDVjJtUUNOQ2cxY3hyV0xicUYrbktlWUR4QThQZUJFSE02YUp2bzhCSWtm?=
 =?utf-8?B?cE03ZXNFaE5EdGxrbEQvNmVuS0xOdkRYVEZON0c3aDZ1cjdhVGJTZ2tVK0s1?=
 =?utf-8?B?MUhRU2JpWms3S3V1Qnp3L1dMVWtXRWV4WmZEMXk0WEpNYTMrSmUrVVJkNFVr?=
 =?utf-8?B?TkI2WldDeEdRVTVsWjlFNi9Id1kzZ1dJM3ZpS1ZtTGlDc29NOEtBajh6dnVB?=
 =?utf-8?B?U3U4ZTBjOTZVb0xsUXphWUFnTndPK3JRUHArRDVQUXVVczlWd0xxbnFGbzdq?=
 =?utf-8?B?Y3JDVUQ1dnExdkMxd01SeFZsQzUvd1VLVExndXNWWlNiWXlxMTFIVjhkTEN6?=
 =?utf-8?B?TDNrZGdNd1V0bnBldHpSNkY1N0x5WTF6LzNia3hrZTR5WHdYYlEzNGZUL3Vt?=
 =?utf-8?B?M1llRUVEc0IzeFgrZlpHbnE4SENOVVVLRUI5U0EvZ1lBTktOOWFJWkVwZS8x?=
 =?utf-8?B?cFYyL1lGcmttR2xnQ09kREtybGEzcVdIUmc4dmk2Vzh0eVREdWdWZEpVUXht?=
 =?utf-8?B?MUZ1bHNIS0l6RmQrYXg4b09SY3NCN3UwSXpON0R0cmZ2cnFjU0VQNHp2QjNz?=
 =?utf-8?B?d2xhcityMWlxaDRkaHhTVzZJNk42TzQyTFhuSXkxaGZ0SEN0Y0JDWS9tR1g5?=
 =?utf-8?B?SWlCMmNBcTBqT2J4OXpwcUlRS2VxbWxSS0JmcWxrMnlGZVZjWWVRL3IvNlhv?=
 =?utf-8?B?M1FEbHkvK2I0aEloSE1ENW5pL24vdHZBYUJ0UW5MNFVlbUwyWklRdnBqVGFa?=
 =?utf-8?B?WVpOKy9WamthZ2REeVRjNDVTRk42b2ttaWJrUm5oNWhTejgxZ1NBdmFLcGp6?=
 =?utf-8?B?UWRoNVJoSld3TzNNYTRTUmpOeThJcWRweEp5QXlBeFphclExTi9ZQzFBR2Jn?=
 =?utf-8?B?UlVrNHViSmdRM2hJL3laVHp3eitDYlg1RDNFVTNRdjhVK2RkM3hzdDdyS3l0?=
 =?utf-8?B?SHBucVc4M0pCd05WM1FiRWJ6TGo0VzBUT2gyMFJyQmxHczR4MCt6Vkkvbysr?=
 =?utf-8?B?N1lJWXZiVHZiU2p2NnJZZXUvdm9mY0F2dDE4OWdEMnBMVHFxTTE5TlFjTGM0?=
 =?utf-8?B?NExLYU0zaHJEUHpFMERJK1h1SXFGSmtvTklIVTN5NTM0V05pK0pJVTZHMFhq?=
 =?utf-8?B?TWNtbUFjU295NWhkVHdyWHpNeXUwc0V5dG9SeE9sZTYxWno5K0RUbTVlNWNF?=
 =?utf-8?B?M0s5MnJlT1NoRUxmMmNhZEVXdzNNSVY3eTdTNGE5dGxmdjIxTU9OaVZwa2J1?=
 =?utf-8?B?dWVzeVZnRHhHK21ZT2cvUHRvUlZCYW41SHFrSVlKNjJBMFdZd1lFSnhSZ2lq?=
 =?utf-8?B?SXUxaHZURngyemJxTG5mNDJZMm91TUxEcXhnOWR0ckJwM2JZY3ora0g5bFhV?=
 =?utf-8?B?RC9wbnpCT2EzZW5nWU5vczFMS2p0dUo3d1JrbFgvL0Q1emdBaWx0THoyaCtu?=
 =?utf-8?B?S0pza2pjKy9lTFpkQnFjdng3cUVzQkdqK2lwWThVSDNMZ1A1WkJQdmtWUzdP?=
 =?utf-8?Q?/zXNQHdTZiZkeMw4jjoQL9gWi1aSRGh3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3pGcmREeXhZQklLbzdKZkp1eUk0a24zNno2RVQ0L2hDVkd2bDJWYmdHcnZ1?=
 =?utf-8?B?QnYyT0srMHAxOXhrMjgvQjJIcnhpcW92SHZtN01RWFhEci85YXcyZVp0QnlU?=
 =?utf-8?B?VnVWbkdkeUJPS2d4ejRKWFBUMDZkMGN2VDA5SlozZDVjaDJ3RjRhZmIrZ0Z0?=
 =?utf-8?B?ZG9RNTZmVGdsK0tETmR5SnVCNFIyKzAyWHl6dDQwN0s1TGRGR1MveHFYREUy?=
 =?utf-8?B?dXFEU0dCa0l0RTFDclhrZVU1eG9RS0NDQTdjSmU3ZDVrT3NBeXd5cndKNVJX?=
 =?utf-8?B?cHZTckpYcTZNV1lYWDk5dmY1K3AzU2lONTRsbHdpMXJ0dlM0NXE3OEt3TW01?=
 =?utf-8?B?RnB3U3hZc3E2WEtyNUgzWlZ5cmdJUk9xTnhQTE5BYkVoRjltWkNCek5PVEV2?=
 =?utf-8?B?eGxvUytxUm5va0Z4dUdlNkowS1I3SVBpRTh4eWJLTUhSY1NQblo3RG1oNFZB?=
 =?utf-8?B?a1l6SzU0cmxULzhMZkNPMWpXMmd1Y3ExRlJNVCtSd1g4dVZxVE80T0NUT1Q0?=
 =?utf-8?B?dGlwTjNQa3p5alpUZzA1ajJrSUJCaG5ITVZpdDlyMk45MTltNXNtUENRcTAr?=
 =?utf-8?B?NFVvUDJjV2s0c3FPZHNWV1pxS0tEZ1ZyYjh3dzl5b25RRzRycWZhOTUwcmhE?=
 =?utf-8?B?NW04eUZaVXp0R25TNGIxbGdSMDBxWEpqSDFWMWxpMHpVNGhYL3djN25iUzRY?=
 =?utf-8?B?Um00R1VaS1V0dnFFWHd4OE5yM0ltTnlmNEQ0Ui9aa2tjM3QwakV4dWY1a1J0?=
 =?utf-8?B?Q2xYNlE5TE5jbHV5N2R2ZmpuT2VrZ3RaVFcxVW42ZVJQZWxlWkk1VzQ3V3Av?=
 =?utf-8?B?K1hVeHg4NGI4SDhDWStZSUdONjJYMEVKTVYzTCtGMzNKZUxsaElZU3Z3SjZS?=
 =?utf-8?B?VnZWNFdTL1N2QXJ6QmlCSjV0UGdFRFllTGdCZ1VuQ0MyUEJQcWQvU0RQKzVm?=
 =?utf-8?B?UzFqVlljQmhXVnpaaXREcTZYNy9FVHdTdGc4UldTbCt3RWRmMVM0SjMxSU41?=
 =?utf-8?B?WjN5dmtremVFdE5TKzVZdVRUbDVwZmRMUDRpT2J2S0dnZVhyVkhjdTk3Mk1n?=
 =?utf-8?B?Z1B1Mk9maitFemx6bW5zT1g0RHVtOWN6Kzl5SFhvZkJ2QW9DZTVwbmZ1L2pr?=
 =?utf-8?B?T0pXWUt2MVFocTBiOEc5OWdoWUJMclU5ODhML1FFWjNXRHhnZTdmSFBZSldD?=
 =?utf-8?B?L1dLUXc4YWdtUndmRzAwaDZGb0pSS0l0QWJmdHFMYjVXTDFad3MzWmtiSGsz?=
 =?utf-8?B?NnNkZ2RHVml5dkcrTmFvYXQwK0xybEVxemVTQjNhekNaYkVlRitIcXdJVGhZ?=
 =?utf-8?B?T3BuUVNjQmsvZGdick92VHI3ZHpjelhzVkNMcHdYZzVMMGtCeDAvVUxwbzhG?=
 =?utf-8?B?enNZRHhkd0NDOVFLWjRxUjlQYjJ5Q0xUZTBNYWh4YkplQXhqOGo4RGU5UHpu?=
 =?utf-8?B?dWpFUGIybUxucmRjWVFMZVdkYk9GQXg3dTJ6cUxzYnpMdzlBUjFDZ0E3QVJB?=
 =?utf-8?B?ZndDQkRJdndzRnhzL0FyZklWM0RWQlZqSWZFd0dCU3BUU2MvYjUyQ1B1K1g0?=
 =?utf-8?B?RS82STdrYThRazByYzE1ZHRsWVdlZnVwbXN1RWNUMlh3RGczZU1hb3NGQkRK?=
 =?utf-8?B?OWtDRmdBZyt3NTVIZDNrR0RnSWRLdkttb0xGV1hIak1KNmtNamhyY0k3Tmts?=
 =?utf-8?B?V2cvVitEOEpYQUxCMGdHVytNelZSOTkvMWErcTZXYVQxdldORXNURVBoSE43?=
 =?utf-8?B?NUtveDZKclJOckxxb3N5UDNGajdVV295ai9KNVBTeVdyYkdaUUY3UWZNMWtt?=
 =?utf-8?B?cDJ4MTJxN1MwbDBqekNaakdscm1ZcitmWmNYRkZodWFycjh0Rk1BUG5wVWZq?=
 =?utf-8?B?UnZFWktqaWdmWXl3QzNUSUtwdmRmN2lJOEtHN05JT0NkZ1JwaDJsWVZWdmdO?=
 =?utf-8?B?K3c5YjBRQ1g1WmZKT3h1WURiRHBiaXhSWkNCc003Y1FIUTVQTURJVnlOYkRI?=
 =?utf-8?B?R052a2NVazFZYmlxc2Z4WDBMVjlUQ1QyNDZEbzRHNWdibWhaQ1VSUnJMSjhl?=
 =?utf-8?B?U2tNWXpFUi83dGhsbUVBRXdKcHMrT3ZydWhOOHVRVjg5Nk9MWjZkVmIvYStV?=
 =?utf-8?B?amx3YVRaVDZ2L2k1bFhVRE5BRGJybksvaTgwSFllSmV4ckF0clNUOXV6eWtr?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DC+ctjWZ6DsHxhEvKYnBKpTMdpOQl7NPwWKwe/JV/mdNZBxqL/ZPkZQMbKgcqKrGQti0sW4BInv8dep2w9sGvDt5OWMqAuzt0g7rxijDXJLQsX4SkArVvC0+ICgyrc0FsrJKS+8uBuKbzDSQj/wz9GN3+3N8RxnfZ25gcblx1mbk1Sws3whDsl0JFRpfiyW+L3FPgfElar/QW7Vy+P/QeMiV2zrSWhICx3Faw4TRG4lkZhOIeLZU2eRWJ5vO+ZPuU+YSN/minKE9ZQdqJZek6QtSyq/4AYCX3z3yAbj5XHkQgirMvxJy7RFKQHagccMSOUEbdkm/hkpP539DALAKPF4nWpqg3CDdhAHgb9cle3ikSsB2jHTpWy9jR6jOsImjZm4HgPtpAEumfaN703zlqkO21vI2cc0+uyaaNKvyC86MI84URu44mfMXkn1lyJdE98ppYk9ROHSoHiqL5pF83YP4acW3gmQl2zX3UYL60BSXYx/WvAyB25q05PCMKjNiSaOKtBpzJ4swkB9EPMeR+MNXBrLe4mSOigbDBD4WNxsOzOX2mUpxN1VFpXw0kmJGj0HR1a+/BItOPWd+xkz3tufQMFzkxW7IWsFCnxvwtd0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa8c013-1070-4049-96ea-08de16431c67
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 16:57:42.9177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SyMOvQRnQDOlHi1acqFc2OtgrAZaIdOrvukk0dYKp618LyWmBWzwpZDMvBEWNhh82jOU+AJTbRa7/0VnJy1/lSRF38AvKBjkntox39hSYQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6480
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280143
X-Proofpoint-GUID: YSCFe4l8vocYqrAmacb5IaL_9hlmlPKR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX43FkoMLwfIV+
 Phyhw3lAntozjd2sOYwsJFE1hoUZj89xfUFba6o2g5D0D37/UycyqGtVTJGpKBBRkiVxDIh2+Sm
 76pOBh80jVsZfg5ni6Rr7rYmyG5ZCNpzkkO4oAKWFupjMXZnqaOtJG1zv2xz2YAiKZ2zqMRe+b0
 cXqcdH6SyopjwK4ErCWq7JPsKI2N5pclvlrwUc53E8sbclgvIzRYxOIqu66LomwePtuKARnbb8O
 B+GY/weGzt/HqwGrgB9djG7gzjRvukbnzrdmSxejK8xs0+d4aOxND72m2VmOmcCb+4Tp5KS13+w
 5Eslevb+gTbAaSbiR2/rkDzwsqgu8eALGfS/IWU/XprT3oLk+uupiQ/HlA6wMOB2+xkFd2D9EoX
 i/JT9nHoage68ZO/3Ur2IqFwLEWRrefJrjZloNcKS8qHStMd7y4=
X-Proofpoint-ORIG-GUID: YSCFe4l8vocYqrAmacb5IaL_9hlmlPKR
X-Authority-Analysis: v=2.4 cv=Ae683nXG c=1 sm=1 tr=0 ts=6900f60d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=u7GQ2BnP5N2ghcVvD8QA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13657
X-Rspam-User: 
X-Rspamd-Queue-Id: 52C49A0019
X-Rspamd-Server: rspam02
X-Stat-Signature: gabs6g1dfxp37cxqohupy6e8st4b769j
X-HE-Tag: 1761670805-147894
X-HE-Meta: U2FsdGVkX1/HLmqLN5+3S2YO9IY+0y1SvTyEq/oa1uM6eCvtNq1vvWGYOu0Tu07KkEqJm12MXdeFWz1+H4IsTghzb+NcCZLyep+4KmxHzhBW/LCsegQwcZR0Uhs/a1zGSJUjpvBnXIkSiYFMi0UvFudAC3WwNqRZLDtYrxFtjp8Rb2bhogroVbcGmHPvdoHZK4Ef96cCBTXmk5Dn5NkP8NXU/B7OVwL3P6Se9/qOe0ANKGd3UW6EkYgnZzohDhQ7bJAoUPY7DXRuU93+bvBoLnjpt4c9yFTU63OVdj7uqBuTTtS0ljDORKbhn7BNHnVv/CK/f37G6tLzZCoya8aQ3j+LKv/7u5Xme+8vPVuUTDj9eFHEpCVHcRndDaYBN74z+bu5151p6AUm8K4oEbIwIkm+N0Wc9KCz2Up19DdNkTWCytmLhTqME05xFi7a1oKExsiCjSnC+XneFpLWda66k21JeQ7JmOAEti1bBh+Y88V9uNe97H0kYZo8eBuVtUEoLmncMe3di6lip6lNPB9gHeg0yIlP3wmZmNY1Wj/XYMOLHDxB8SmggzgM5N1UI6FSE/6gl59P5Xn2N7YPOtSWjbyQW5M/lVNZhprCXdTQp2KOBw4hDvEbvwV3d7gAiVt9PvCEEsbKek2K4Ugz63q0YvlBJEWkmIzcbW3kRFG4/UnXpXwJGi3mropkqNurHvoIocjEg7i112cHFmbE8/3qlSOmMyh7x7YVBSSHrsHYiZdkqmPWYIbRuHL2sy4IxaBM9yePFuxZEJ5ncgvNc9bnGNDK9JHgLbSOkceFExd4clp3ao/2kAHXi6XfRkoU/K06uXeTrgogLf1/9pdN6Il4mCNeNDNhsuPUoQPDwMHrHuqNJKpYdVUR5U6IYjFrD4CEiNHqm+sNXXqqkuQPl7JdL9c81P0wsC5mthtgLm31HrWEYbs3NxKwOvSczn3RuMqMXr33YbnTnKlMlJO1zwv
 Y7InVFY/
 ndDLNxqdYL5+mC6Ek5gEfMoi2OK5r0WlBx01g8ls8cpM2IYBqW/vrVIskphZ23MQ2sm9JY181jKNQq9Ao7WLSIHP5+mokApPoM1g1sTxLdJdT3x9iCpXrWK7amBF7psNpXlkkzEFdRdm0K24cTMkX4BLqmpmpGjfNdJVB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 07:36:55AM -0600, Nico Pache wrote:
> On Mon, Oct 27, 2025 at 11:54 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Oct 22, 2025 at 12:37:08PM -0600, Nico Pache wrote:
> > > The current mechanism for determining mTHP collapse scales the
> > > khugepaged_max_ptes_none value based on the target order. This
> > > introduces an undesirable feedback loop, or "creep", when max_ptes_none
> > > is set to a value greater than HPAGE_PMD_NR / 2.
> > >
> > > With this configuration, a successful collapse to order N will populate
> > > enough pages to satisfy the collapse condition on order N+1 on the next
> > > scan. This leads to unnecessary work and memory churn.
> > >
> > > To fix this issue introduce a helper function that caps the max_ptes_none
> > > to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scales
> > > the max_ptes_none number by the (PMD_ORDER - target collapse order).
> > >
> > > The limits can be ignored by passing full_scan=true, this is useful for
> > > madvise_collapse (which ignores limits), or in the case of
> > > collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> > > collapse is available.
> > >
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > ---
> > >  mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 34 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 4ccebf5dda97..286c3a7afdee 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -459,6 +459,39 @@ void __khugepaged_enter(struct mm_struct *mm)
> > >               wake_up_interruptible(&khugepaged_wait);
> > >  }
> > >
> > > +/**
> > > + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
> > > + * @order: The folio order being collapsed to
> > > + * @full_scan: Whether this is a full scan (ignore limits)
> > > + *
> > > + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
> > > + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> > > + *
> > > + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> > > + * khugepaged_max_ptes_none value.
> > > + *
> > > + * For mTHP collapses, scale down the max_ptes_none proportionally to the folio
> > > + * order, but caps it at HPAGE_PMD_NR/2-1 to prevent a collapse feedback loop.
> > > + *
> > > + * Return: Maximum number of empty PTEs allowed for the collapse operation
> > > + */
> > > +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> > > +{
> > > +     unsigned int max_ptes_none;
> > > +
> > > +     /* ignore max_ptes_none limits */
> > > +     if (full_scan)
> > > +             return HPAGE_PMD_NR - 1;
> > > +
> > > +     if (order == HPAGE_PMD_ORDER)
> > > +             return khugepaged_max_ptes_none;
> > > +
> > > +     max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
> >
>
> Hey Lorenzo,
>
> > I mean not to beat a dead horse re: v11 commentary, but I thought we were going
> > to implement David's idea re: the new 'eagerness' tunable, and again we're now just
> > implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
>
> I spoke to David and he said to continue forward with this series; the
> "eagerness" tunable will take some time, and may require further
> considerations/discussion.

It would be good to communicate this in the patch, I wasn't aware he had said go
ahead with it. Maybe I missed the mail.

Also others might not be aware. When you're explicitly ignoring prior
review from 2 version ago you really do need to spell out why, at least for
civility's sake.

Apologies if there was communication I've forgotten about/missed. But
either way please can we very explicitly communicate these things.

>
> >
> > I'm still really quite uncomfortable with us silently capping this value.
> >
> > If we're putting forward theoretical ideas that are to be later built upon, this
> > series should be an RFC.
> >
> > But if we really intend to silently ignore user input the problem is that then
> > becomes established uAPI.
> >
> > I think it's _sensible_ to avoid this mTHP escalation problem, but the issue is
> > visibility I think.
> >
> > I think people are going to find it odd that you set it to something, but then
> > get something else.
>
> The alternative solution is to not support max_ptes_none for mTHP
> collapse and not allow none/zero pages. This is essentially "capping"
> the value too.

No that alternative equally _silently_ ignores the user-specified tunable,
which is my objection.

The problem you have here is max_ptes_none _defaults_ to a value that
violates the cap for mTHP (511).

So neither solution is workable.

>
> >
> > As an alternative we could have a new sysfs field:
> >
> > /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
> >
> > That shows the cap clearly.
> >
> > In fact, it could be read-only... and just expose it to the user. That reduces
> > complexity.
>
> I agree with Baolin here; adding another tunable will only increase
> the complexity for our future goals, and also provides needless
> insight into the internals when they can not be customized.

We already have needless insight into internals with max_pte_none which we can
never, ever remove due to uAPI so that ship has sailed I'm afraid.

I don't personally think adding a read-only view of this data really makes
that much worse.

Also if we do go ahead with eagerness, I expect we are going to want to
have different max_pte_none values for mTHP/non-mTHP.

We _will_ need to convert between max_pte_none and eagerness in some way
(though when eagerness comes along, we can start having 'detent' values,
that is if a use specifies max_ptes_none of 237 we could change it to 128
for instance) and as a result show eagerness _in terms of_ max_pte_none.

Since we _have_ to do this for uAPI reasons, it doesn't seem really that
harmful or adding to complexity to do the equivalent for a _read-only_
field for mTHP.

AFAIC this patch right now is not upstreamable for the simple reason of
violating user expectation (even if that expectation might be silly) and
_silently_ updating max_ptes_none for mTHP.

So this suggestion was designed to try to get us towards something
upstreamable.

So it's not a case of 'sorry I don't like that we can't do it' + we go
ahead with things as they are, it's a case of - we really need to find a
way to do this not-silently or AFAICT, the series is blocked on this until
this is resolved.

Perhaps we should have discussed 'what to do for v12' more on-list and
could have avoided this ahead of time...

Thanks, Lorenzo

>
> Cheers,
> -- Nico
>
> >
> > We can then bring in eagerness later and have the same situation of
> > max_ptes_none being a parameter that exists (plus this additional read-only
> > parameter).
> >
> > > +
> > > +     return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> > > +
> > > +}
> > > +
> > >  void khugepaged_enter_vma(struct vm_area_struct *vma,
> > >                         vm_flags_t vm_flags)
> > >  {
> > > @@ -546,7 +579,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> > >       pte_t *_pte;
> > >       int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> > >       const unsigned long nr_pages = 1UL << order;
> > > -     int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
> > > +     int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
> > >
> > >       for (_pte = pte; _pte < pte + nr_pages;
> > >            _pte++, addr += PAGE_SIZE) {
> > > --
> > > 2.51.0
> > >
> >
>

