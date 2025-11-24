Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 499ADCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 09:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9C36B0011; Mon, 24 Nov 2025 04:53:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680DE6B0022; Mon, 24 Nov 2025 04:53:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5216C6B0023; Mon, 24 Nov 2025 04:53:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 300C46B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:53:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC8D9B7C56
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:53:32 +0000 (UTC)
X-FDA: 84145038264.22.3D45FB4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A44D40010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:53:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VNu4bxbT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nZq3dqz4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763978009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgtbYCZ7MK0wOk8Dgsv5sBLaURSe19QANtfwiJmT3OQ=;
	b=3ceAmcujRbTankrEq/tzU6IEqr4swr4O8QiWhAoWkamlZZVi1MvsPT02PjB3Ccl/dIQxx2
	JaAE0PdfBxgmp1d9v3i4KT9avKJYUmmoCNh6FbUsImmSRAAw5wCIOMsvAHGwA32A3C5nr1
	MlHGXiWFdJ79hgSlwYsF1bGWCn97IvE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VNu4bxbT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nZq3dqz4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763978009; a=rsa-sha256;
	cv=pass;
	b=Mi/OtI1H++ai7rudD32TbHQAe2/KyLbSfPPGA8abN6XkWkLpwjHm5qndtsei65Z300goKS
	q0hT1atZCrz0gN702Oa14dNkK3DyZV8uKGC+ThYlLJKPcE3LhvhxWL1Ic2XDY0aTsgBTRj
	kBb7KgfjtIfNNEam6lqtk8pU67ebvL4=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO8v3rB692550;
	Mon, 24 Nov 2025 09:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IgtbYCZ7MK0wOk8Dgs
	v5sBLaURSe19QANtfwiJmT3OQ=; b=VNu4bxbTOMPd4bj+7GeqjbgLqUiGr1L8pX
	4vYypfbSGxImXBoQilWUOSkmvgDTlxdbHquunKOa7NUynnppNtzNn1Xi2Fz/PjOw
	9q5R2fmHer6QL0yYseG+L44TL2hJrv3BLZsBk/SF/4FjrWmpwL0JEwsNBB3i4CYL
	0SYj+tJPhXgBnqQirytE0ZauoXHWZl0WZUkOU2QNx7B4Qa87ckAsMEOLoMRGEGcm
	gnLfOQ7cwHp8SJeyxcE2jT4NhCFYGg2RC8fQBfHvYfW+2t2obVkpsks46kqiBqY3
	jFeWxVfH4sB41FgXNszPn75PWexMhm3KQWP1879br9VERx94lyyw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8d2sq9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 09:53:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO8K2PK022298;
	Mon, 24 Nov 2025 09:53:23 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbnr72-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 09:53:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzXOb+dZ4mgUKg3MCY/MT7XzIBp3WHj5336vgWJJTaPVvF6tzkrhpGGdcuSjL8sVH1B4VTSxoZ1LD12KTIVuX44/W0Flt8fbcmIBNt6wzn1r2DR7U2seYJzAK+VpC21scqnzoHl3/R2/mmTyDD+Mspg2zVHsnjhfP9TLaQutQJDsXjQLFzElCfzWj25Z9e7L9VoC/pHPgk7TiYGqv3+r4pkt8RQ8KrX75PH28jCEJE1VD/FECIUPKXqALs3cQMEEqbVEmnPCtxNSOCQfaTOTemXBP8Yk6n06qTZi6Rkn80hKc0JGpKuHztI8zqC+L0izhTtiz3WZNj+QV6Px8SSpjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgtbYCZ7MK0wOk8Dgsv5sBLaURSe19QANtfwiJmT3OQ=;
 b=CAzlg8omajU0WUE06MQJcsj0WAaUc7BmfgPuCKIOaVQrv6bwPf/QkvtS59sFVUOT0aHAasyj9eyhHiynXTXOs9zU/ZeCSOAa48swbAW3MEprwo5v9I8PlBQD7q7FXGqVsJW8QQcTaehpbyChjJ7M0bKg8K69AUGWjoAwoiZJTSs5c/QNA1lsSogiqim7A6X/pQSZLDnJdx89EOlG0BEOi1CNWdJRiD814xBqLDYBDTUwYlbHEU0uZ70HWw3q0u/8e50En818pBSPmqGtRjfOyM2CUNEGqMz5PieCDrrInD/sRMDhQmTxaCk+I+Z3bj1lwsjWElTOelYBkJNB9ALlIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgtbYCZ7MK0wOk8Dgsv5sBLaURSe19QANtfwiJmT3OQ=;
 b=nZq3dqz4qxfmgrLaZ/MBjun0ZNl+omdgDN0hOo1X7NoCk+FlpZSjaGUP6+ROaBUrg8e2Mc0kP0OVXmmi5Wst6cPzPzaMaAZqR60pVkGhkv6MrgtR8zidtn0JdK0kVEk8lZ2Jf3rwSs3gV47JlLM9p0GmyNgvcPAf4hm2eytADAo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF72E3677A1.namprd10.prod.outlook.com (2603:10b6:f:fc00::c2f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 09:53:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 09:53:16 +0000
Date: Mon, 24 Nov 2025 09:53:13 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: syzbot <syzbot+3e03c904429660114599@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in vma_modify (2)
Message-ID: <744134e8-387e-4429-b878-87161a45113f@lucifer.local>
References: <69229bf5.a70a0220.2ea503.006d.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69229bf5.a70a0220.2ea503.006d.GAE@google.com>
X-ClientProxiedBy: LO4P123CA0086.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF72E3677A1:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e239651-730c-429a-4dd5-08de2b3f4a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qtBwu1AHxPwYMIhNGBR50Lx0XxzKgmPTcE19qNgF2XsK7Z9K9ygrwCwXQE2l?=
 =?us-ascii?Q?7Yw2ShIsLXwtmvAmELiFWoB/23OQFHGt/cHnUHykE6RZTJCPAZ5mFMJaBMNx?=
 =?us-ascii?Q?hlvABSNJY5OxWSnsajY7vt4l3ZPam9hoB/uiE6ksD82KIxJi+WbG49HK27XN?=
 =?us-ascii?Q?kniOBSLHJR1cEb6e445THoxd0CoQe5ZB1p4CazA/3r+6Eh1gVwrWcivmNHl1?=
 =?us-ascii?Q?ggcD10HcFKw90jd3ooPz9vR9fgEzbAJ/wqHWbmJd1MsUAB+1PDD9mtItv1X0?=
 =?us-ascii?Q?ix5IYzpZ9hTQrPVWvx/dVIdKBEZ8bqDJ5nxK0rIKDrawheDtLk68BRjLGxXw?=
 =?us-ascii?Q?FDZYJP3OcTvNEPPWEwbVJazd9csIZdttkWj1PQgXL78mOEkTFpT3G4/uYpCR?=
 =?us-ascii?Q?uppsKZvdVh3nOYUN+nI/opEn9o/98ZmFS0wwTJ/QHRWTFX7C9ztTXB4oB2wj?=
 =?us-ascii?Q?iKyOvov5ZJajZFsuuAeUJyTF3Sak4PFjWsp0VeYCpBt7Fj8M/LZfN6bEemFz?=
 =?us-ascii?Q?7Wy5h55AF9TF2J91usu0LRdUq8elhRx291O2o6GRpYz+pkVI4EDMirJWaeXI?=
 =?us-ascii?Q?q16NQ1RlKEX6pEISpA1rUkSBVP0nmxIbCMnrSFflqKOOXzTUfNS2kB6HPOSM?=
 =?us-ascii?Q?pVon8ChUb8U3+0xqECYVe//Clk53flT4X+1VEe2tXuo7zMOl1abveaU1ntx1?=
 =?us-ascii?Q?IqeizXRVIh04q+o+RajGkKWSF+72TyiYnAp4u/lYCx02e9wZ4HbuslPL9vrJ?=
 =?us-ascii?Q?GAH+S09gJM3ZaLKva4k8KBECI5QNtKnTK6kWpg453XrorqBksNf1Bb962Mit?=
 =?us-ascii?Q?R4diLYloKQnn49OeLxz5WZMnUpxX6wkXneu8DdZ7SXfz9ibUXPNuihzc2hSn?=
 =?us-ascii?Q?b184H8TSCxRgrAScQ3pvf6dzC8VxaPO2WbJ/b8+jr7npcT5CEU7hK/OXBXbS?=
 =?us-ascii?Q?nVxbJMiKZ9IG6T5ibbiF1KikXqo6X7YNcmh5bALYbdfL0u+3xrUQqpSP4Q5a?=
 =?us-ascii?Q?3VLnklgbznUKrsMOcAhOQFFa8CQDpJQFc084sLjFiDB/YrA9V+aGm1I0LxEM?=
 =?us-ascii?Q?NJvk2Biq8o7uuAkVnxHkIW0SoV/4sUyo4O4dcffC5JkQY9mkT7fwYoMI/03v?=
 =?us-ascii?Q?mwHGqaEkzN9vNoSqEqVzXUdN43SWa7ezv8Zbx8GOxNIgD0Dnwj6ugIwTEb3X?=
 =?us-ascii?Q?tf1NiEuZEKJJnyvkhHwd1exXwS/p7m+IfOmAlEf1hw/056GvtMSevf0R7yEX?=
 =?us-ascii?Q?JPrH0ack+D/PYUcj5lvfhaSRc4oOaydDNJrPEsrK5V0M3dev093ADFGOfU7V?=
 =?us-ascii?Q?uCb8j2Wl4FLl2qzn8/kjqUUY5LJntUxLlfDBWsGn593HSgiR5D+zKzoe9FMJ?=
 =?us-ascii?Q?tqmhtAFE+3EB5YxGMnr/gDxNZhPGK/M0n56mSUXXLR+uru0mDA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0R85lLj/XoisN03oZpF6UYpU0YImziCNb6EdazAi+n47T9ebrTVmJw0YE7ue?=
 =?us-ascii?Q?2V6ykMd+H7IYRz8bvI3lwvIR+JiC/OCiiTbUenEP8TiCIYQG/GpeR4SleyEF?=
 =?us-ascii?Q?I1xbWEFFQQjiSzBde5z8bu+dPVgW9stIi2gcujPwO4fLcvuwDIWCkGyKWNyh?=
 =?us-ascii?Q?LQGg6Y/LLc1eeg/jEHqhmTzzxcJwuFOVa4MnNvmlGkGFdGxsG+4ZEZLMhQ5j?=
 =?us-ascii?Q?2p0qKmthl9F+ijEf5XXuyN5hgEqitZkM6WJ1BNGfpUMXBHubUiag+G8xKnlD?=
 =?us-ascii?Q?7cOF0gKb07myatGvfuPH1q2hYOxZz3YaO38bUTXhGpmXJK5WFBONgYqw/zWY?=
 =?us-ascii?Q?Sno5wjc2hxYFnd3G8txrb9DpHXcTTwolUzYnfMzNXRyaOGH9AcKmG/TkeFix?=
 =?us-ascii?Q?HTHQOLzEui/+yqF4uYaQgfzm+a6iABdY4NX/+tRjmiPWil6JA8JXzGJjFcOw?=
 =?us-ascii?Q?UoioE041Sx+fv1e/Fc2V0uelNmjpdASxZZAmWd53CajA4TkIWjKrNpQTX3uS?=
 =?us-ascii?Q?KM/+PSpeW09HALSNFVGFTOj4w7mWBhaUVqm521cWSXvbkWyTxpqm09QZTz2G?=
 =?us-ascii?Q?E3a3szxXT8J8gLCCrZUrd+aMCx+/4pVWBsZXCjFx9rluZmQOYCblBj19A7JQ?=
 =?us-ascii?Q?VWspLB9ioJ9BmoHtNsN5sfNHhtAo6hdsgl8UOIzrav+j1Xp3NmEXNa5qSuT5?=
 =?us-ascii?Q?FHsWW9AEtvdmKj3sH8CD/i4+EhXRk8X7N0KnK3fB6slFLR26IE2aPkeNjobD?=
 =?us-ascii?Q?sZQ2ax+cj01KlK+1vsogMsoeO4+g94j6UvesLQihDfqEkQj3DUP4/AAZqydA?=
 =?us-ascii?Q?5ixlTss73AdvM9S1DLFaG8siQbyfc2hukLUq3ppzYvERKO6Tz0PPKPmI1za6?=
 =?us-ascii?Q?WJKwpWnAfMOq2JE8o6Ubs3M9HTlsEQCPXGsCIjffIcL9VDqLpIxUHl/Uz9ZQ?=
 =?us-ascii?Q?IbJqo2jfZS+zysqv1LByILFFmNawthIzfparLFEDD4ooIedT5JpMPVRiL64h?=
 =?us-ascii?Q?17LkdmQ2bCxONl/3YGXSgXHE9T2U6p76j0AVYG9bVEJ7j1B1pYIrGccRHXso?=
 =?us-ascii?Q?fYNDmp9eNYdyHZk5pfCUDTD0DRlmuS8h2F30yT+fBrkeU6AYEFWwqIzoGpg0?=
 =?us-ascii?Q?6ru36oKgJjHUxxv+PObvjZByNejg394QsXNy44AcvcJIwQJpJlWnrFfJ27t2?=
 =?us-ascii?Q?i56b5LcVKtzXuLycsIyJ2UKRdqxvJvk8Ecuucf8T8VbYmVLG9Otxzn1DereS?=
 =?us-ascii?Q?GoOPgmVaRkQwQaoVu8plYcZkRlZv+bL24SRMZw4gSbEzLDyyRixvzCMtIp/F?=
 =?us-ascii?Q?I/SLuPTh5EM2gJitUeDXcqnpiP6pLXKs+SlmOQbGp8EF6NrUMlMRR5+ClKCK?=
 =?us-ascii?Q?WG7pVdUPC1SS4TsC03zh9Z4MtTVGfzufubrT+DmqIy5NxdJQvGCFSJCYs+Wt?=
 =?us-ascii?Q?3AY27dvLRZHkFMplJeH4vqxfWsWGQarVIyNLWUHHYT+oKNqLZbluSoTVxC4F?=
 =?us-ascii?Q?oXh+ojHnYSR+7gSHr9J8gpunSpPFdzlYkTNbV/2gzeBssIJux7dv2rQcRR+P?=
 =?us-ascii?Q?VF7mvHUXkrCCLpw4ehm5gwAmlZ/0aqkUGuoQQoT2mk6kzyG+SQOvdJS20XuX?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SHwVqTN8ky5rLW5jh1j6KyNoecnIuA0+UaFppuOcMc6Oc7P3AhT0Z1OzrP3tZ3MFf3b6RDqNisP+Slbi/2a/QcHqoVN1co6c/8f6le8sse4snkEJ2xfVR18WMTu11jYWdmsBI2L1ATwixB3/yAkO9/2HhrdtI1+ZFcS+PasJARsCueGPD16Uro3gGXVqPJXGRbBZEnbNMYbBPRlxAr3OelgEBwkgPxx4iXLe77I9y3cWQAuuxpLXAPXhkEade9AYYPlew4qPQ9H2gqBELUlXy/jsks5wjrG2xa0L8dzaIJsrNnOtWgk3xuJ7aiLhbrvchpMUE73MT40Ph8FxFyuL0v9NRKpKuItTF/WOvwTtzG9srX+kiqqQ9XFb4HcOjolHZ0kET7lmLv8QKa6fWVdxscT/kK8i9wMrbbLGZiivWcuYmy/XyuUwWXP8zeEg+rZpbz7pqlyDH5PHeGAEYw/ghh9c3SNn4APMp8N3t2979KnJ3NsD66HhoqrO5UBSOuMRVx2WcYKQW08vPk7EJgPw0yZoLSf2JU6ldhBCXkVQodYbKqb6kFy/WO1sWirJED5+9INsP7CkUEdEMhzMovDCG5VIHSZ6fW/gBSurg3DoOGM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e239651-730c-429a-4dd5-08de2b3f4a64
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 09:53:16.6262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocMD2QD6Ov42o+hjTq1fxJwZFcRXbOGyNr1099zCwCzZFjeb3PlQ6LLbF2dhZqrhxm4UtDIZTyoLr1j4peEyf986/Ax42b+cM0OaYvZQmoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF72E3677A1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240087
X-Authority-Analysis: v=2.4 cv=QPJlhwLL c=1 sm=1 tr=0 ts=69242b15 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8
 a=4RBUngkUAAAA:8 a=57IzYBeHg-RZcTWZjaQA:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19
 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22
 cc=ntf awl=host:12098
X-Proofpoint-GUID: CidYJSH2NylOTx9YxaRtKF2qs4DQrnMq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA4NyBTYWx0ZWRfX9+7M4CaXORgI
 ITn/80rmUlBiIKq4xKhcV9qP52FSfFhmhh7EKolJueggtbNce1/lzsN+OWpEHwxg2hyq2C6NzHd
 vJ/AWYmUpnAjtyGOBBHr1f2YCJN+ZsV3hXkrzJ2K/fcyvLoL7M6OjbRYJpAv3OtFfA8ZiTsYm+M
 ZwORrIydCX64UTcvN9P5i0wEb31l7FoVd/JV9Z4yoa9pJybiaAw8FZJTIO0XRl6PzYx5D550OQc
 Pl6R4Y/fqxAjydtPPMmoOymAyvDLjNymeLVAEeEvPWs5H9IXnsf7hBWan4hLdZiT2//c6504axk
 3Uoa/wYnw4FzAwJFuHhdCyzCZffi0RPyC4a6prUK52ZpMTNE0zjcC1O4932TVmCPY5b53SP0v1N
 HJR1yr/8iIyhZb80+QsLbblb7R23QGQfriHVMqK72b5L87ORjp0=
X-Proofpoint-ORIG-GUID: CidYJSH2NylOTx9YxaRtKF2qs4DQrnMq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A44D40010
X-Stat-Signature: mk3o9icn1y5iqc4n1yzwtohw6x1fzzu4
X-Rspam-User: 
X-HE-Tag: 1763978008-747025
X-HE-Meta: U2FsdGVkX1/tgqnH9Go9x/LfJb0UWUyvw4By3A1HO+4t5hakdmHeiSOSGGivTKw7bdhVcDymMoG/vXXTQY58zMpeez98uRp1t+/u5FIdWAry0IOAncKkNJUC0wRwcrk5Upz0+A8KKECAxCHDoXctihF/J0IpkLBGUdGaklSnM3rp7vdML2QrVN8BpbMeda0yf4GS/eEGsF3Xq04WGbCdw92nUVDF227ykBBD9/c4kfrzEDBBkFQEvGk9cnakV9Lb1VBX2cBYKu5EOA53/iVIYvpIP/UefvqFJw3jr3qXtJGTD6nlXxNcsMFIpe/+WfZRBa8KFng04VNqI6cajzNGiPWp/NMz7u+9hcUNc53zVAcNNJsKTepkJE/MJHw5kK2PpIaQD45zxja4YTy6p+wn3zhgEMttYaXDZ3w4Fbl5aC4HRaI7ZdKycU7tVe6qcDqeD9AHQHOgyuTLAG4x3Shh8M7hSKJnTEuPVP/Nm9ORQuGi/v2wlGQTrs04optDWKVb5AORlox7tnvZTYSga7yucL54pe+FcW2Ni1R8Zv8XXW6E9PEowgwyw1LkG/jlCodZ6Yikmi68+VrJKeRXFusyb/uSJbc5E9CFgzJgnMuR6QXNh9FyWHaE9VipLzP5RsRXIe8N8cnBm1cujBl0RJmHDDs+P9/Vf9SF0aoA3WK5kamnM4VIKKGVQai04cZsr/g0CqWST+HpimApGfMfLFtEQ0L5Znkm0l3PfG8OTFoaWkPAHLLiIjS92hGIMVOoSABZ+hxDId9hhpDLbIm8DDSoHOeBki2M/H1SvqEd14Ab8/HaVi4HN6E203ZVLuBzMhkjaoDuPedBXn2hkbPkflLVFZmyybYc4eqob0wxrknuGBRydRJZGE63HaDjHmV8fxVMhE6YiRAb5sEpiXnh7t5hkeWPAOG1dQ8AsgPkZnhfOj6YkxwxnpEQUPIWrYj4bStpqNKSKv7ZwmdlY6Axh0m
 CQMoUGyH
 7s6ocsftiTegElGwEgwd2DBs27cYvckm1sZIJuHs/B2cMzFYUykYMvt/XqOBrJ5PpPHT+SRp5MaR++VINmRvPFCxsB6+disG/Gvy42lSIO43N59IjE17VCoCaJPO5JEI+UtKOIZFYweMowPbryelSw9zotMrgY36HK8gpf1sARJk6Xs+bXfKMpAyObhFmUcmPkFE2lFz/vapcbtYtQhNBdCL/r9XyJ/u5wOism8GbcgqlG3oZ0N9B11XapkdYDKXinJSB63O6sJwr06AhXRBwV+WDEXGEd7B90VjrSdPaPvAt3CxbprFyAb+iHwwCZcyVj1KMjFCEvLKb8dT+XXh/Pu9VzXnH8Wvq/V060eYopuc4qohP7wkL7/tZQuQwT+Wjtfn/tSTQ0xNvR5r0DyCOZ5+PYjh4RjAiQLQxF/GSFA0/P45DSoXs535i2PDZhReFypl8X3RxP1ZVUvAWwoba35XPtW8KMulDDgyX5gTGCdzLVxvmgkfh97y0tLL42rHgOCWFHdiGBZNFqaCe1U/rfDzpNipwRxZYBV35b63PTeKc0fUNS3tfsfSYQLyGiBQIm2kmMHu3aWL6NvpUC53ZWYbfwZdRERwzb2jV2mjykqtHctJRH8clN+h9ug4EEX/255gwyMXGV3L63KMq1SfrED6PTSDv6r6Sd2tkwtkXUBdpNRzMxK2+WVNVDOTMnCu2GZPTlAyU9UyIeSb+zGqMkxOJ4xOq2aHA0ZNW83d/B6djVCR31F4YMQJ7R0+/vl6OIAzc3tRLCq9g7pQeho8hPP6B/mzoYgsBfhtPhVNnn0Ui3nwLWcFpxSIG4Mnb57C9RTdV2YC1vGoSt4Xd4iQHZlb/gXS9S1+tGqfzBGs53ueGO+KbtYBBJUYLnIob4omsmb62GkwbOnO+/dJAWJTHMUFXN+KTKc5dx8iXvjSi1h97a7ejvdb6/rn6ytk0SvqeB2deAiMAubjhD46w9Fj6DG0sOfNK
 rO8+MWgf
 jKGgI7Opz4vpKZu9OHshlYoArh//LA7erEs17pA3y8xiDmCu9XeLGe3o1OF1M7gxEmo2FPkHddAqk+RZVg9wNki3h1mFXA2eUS63S2E/gUlkruA1OuNVc7+bDYowMQDvhcYpVSyAiRLUHjviVcOYsxSRNaAHOr6QxN4dzj4Ktqrw6+3mdru/DdFjF1AupNz5RpzDq4q/wI7nCzTCpkgGHK2OK/sRnvntkYISYoy9DZPJBqzO72B3XIgv8mldP73+I1xUkwQRIX8m37CcPprQrkjYpzpKGUfbm518bte7qR90UyTf2XLfmaM8+f7LIzdHhuWGV5o2IT7xep5vEQnbNJl9J8DbSQm9NUj7Jm/gjBuKEXWNHHNwqiZXBCFoK2AljiFTESIvtII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 09:30:29PM -0800, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:

Hi, thanks for the report!

>
> HEAD commit:    fe4d0dea039f Add linux-next specific files for 20251119

Hm this is quite far behind!

This is a known issue that has already been fixed in linux-next.

It'll all be rebased so no syz command is going to be too useful here I think!

Cheers, Lorenzo

> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1011b212580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=151bfd5098f42253
> dashboard link: https://syzkaller.appspot.com/bug?extid=3e03c904429660114599
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ed9658580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b0f884580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/8ba50fe0f8f3/disk-fe4d0dea.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b6fd6a81a075/vmlinux-fe4d0dea.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/78cb38ef15c3/bzImage-fe4d0dea.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3e03c904429660114599@syzkaller.appspotmail.com
>
>     7f6714fc0000-7f6715b1dfff: ffff8880734eea00
>     7f6715b1e000-7f6715b8dfff: 0000000000000000
>     7f6715b8e000-7f6715b91fff: ffff8880734ee8c0
>     7f6715b92000-7f6715b93fff: ffff8880734ee780
>     7f6715b94000-7f6715b95fff: ffff8880734ee640
>     7f6715b96000-7ffdfe1f0fff: 0000000000000000
>     7ffdfe1f1000-7ffdfe211fff: ffff8880734ee500
>     7ffdfe212000-ffffffffffffffff: 0000000000000000
> ------------[ cut here ]------------
> WARNING: mm/vma.c:818 at vma_merge_existing_range mm/vma.c:818 [inline], CPU#1: syz.0.17/6004
> WARNING: mm/vma.c:818 at vma_modify+0x1614/0x1a70 mm/vma.c:1611, CPU#1: syz.0.17/6004
> Modules linked in:
> CPU: 1 UID: 0 PID: 6004 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> RIP: 0010:vma_merge_existing_range mm/vma.c:818 [inline]
> RIP: 0010:vma_modify+0x1614/0x1a70 mm/vma.c:1611
> Code: 0b 90 e9 c4 ec ff ff e8 ea e5 a8 ff 90 0f 0b 90 e9 04 ec ff ff e8 dc e5 a8 ff 4c 89 f7 48 c7 c6 60 e6 96 8b e8 5d 85 f2 ff 90 <0f> 0b 90 e9 6a ec ff ff e8 bf e5 a8 ff e9 59 ed ff ff e8 b5 e5 a8
> RSP: 0018:ffffc90002ee7ae8 EFLAGS: 00010282
> RAX: ffffffff8b5d946d RBX: 0000200000ffe000 RCX: ffff8880326c3d00
> RDX: 0000000000000000 RSI: ffffffffffffffff RDI: ffffffffffffffff
> RBP: ffffc90002ee7c20 R08: ffffc90002ee7667 R09: 1ffff920005dcecc
> R10: dffffc0000000000 R11: fffff520005dcecd R12: 0000200000ffe000
> R13: dffffc0000000000 R14: ffffc90002ee7c00 R15: 1ffff920005dcf84
> FS:  0000555555b5c500(0000) GS:ffff888125b72000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1609b292d0 CR3: 0000000073528000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  vma_modify_flags+0x1e8/0x230 mm/vma.c:1652
>  mlock_fixup+0x24b/0x3b0 mm/mlock.c:481
>  apply_vma_lock_flags+0x285/0x390 mm/mlock.c:554
>  __do_sys_munlock mm/mlock.c:691 [inline]
>  __se_sys_munlock+0x150/0x270 mm/mlock.c:680
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6714d8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdfe210298 EFLAGS: 00000246 ORIG_RAX: 0000000000000096
> RAX: ffffffffffffffda RBX: 00007f6714fe5fa0 RCX: 00007f6714d8f749
> RDX: 0000000000000000 RSI: 0000000000003000 RDI: 0000200000ffd000
> RBP: 00007f6714e13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6714fe5fa0 R14: 00007f6714fe5fa0 R15: 0000000000000002
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

