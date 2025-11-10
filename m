Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE127CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C349D8E0057; Mon, 10 Nov 2025 11:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4908E0037; Mon, 10 Nov 2025 11:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADAF8E0057; Mon, 10 Nov 2025 11:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 921688E0037
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:55:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20FF91DF901
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:55:51 +0000 (UTC)
X-FDA: 84095299302.05.18F608A
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010055.outbound.protection.outlook.com [40.93.198.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 40A702001E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:55:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W0IJX5Ha;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762793748; a=rsa-sha256;
	cv=pass;
	b=7USfK66TrZwazwB+to/piNRYWCtTJlUL5ScL/gAYvgQdsv11LlqVxpIn38mJnO3i1AGPmS
	9pskLmmL9HSoL+Iy4WdW4BLNVFwMcr6cotexluhKPfc14DE2ne9+H77pMTOLVPXdqWf8rW
	omZa2wu3aeP/7BfdBkHw9WNj3J8DoFo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W0IJX5Ha;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762793748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+pws3BJDrQYddNYWVtrMHjNU/wbVfXCAXb7y3TXbhM=;
	b=kz4B9qMTfnQh2yRB2Q0pB0ygb5XaNJZ80b+EQHf4TQrsyOcaKQY9ileUq0porLwBRBfL1+
	5icL7wJOSzan7HO3vUiLfTpKOglHLuWZMAPW7UvksBbVAiCsPnfLnmJu3SIuS3osFvCtld
	qrlZ16k/04hAeV6scOEDTQJ+d3xKFCM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4oDKdEwZPx08NkLYMYq3TmoE56NREhVnfNE0adSCyfKiMyWNHfQKptAZo5jzRnEhVj7Q1nLjG9Q2BsIFKqnRXcnO+ednVqVew63aW2kCWr440fWJh49ESognAdE/K4f+s08zmVcdkbpc7wy2sUXLnHKGlz8YeYVjYeu885Dz9rPBbToinjjOJUCy8oZM6TTaGOW9gpZ8/vsinmg5T9MoNtPS3ADlkkkFKAj78qho7OlMMIL30tbwvunh5QEsO/0jreazMIKvDselbjF8KgNUZqnPIPElx1L0JRPQ7w0/qHpvxkT/ZLRVmcm5CcGIVDWfuB0L+3knDy+ED9oCYi9+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+pws3BJDrQYddNYWVtrMHjNU/wbVfXCAXb7y3TXbhM=;
 b=fNyQpIFDtQTEwoVAO5g1GXYN0MlY4RgNxGck4/67zofLG7IM2l1Pmh90V2cWc/mDQ7T0T7G7m0F9JgwvDyvQRrninCS0eI/E1j9BXyN3orEUb/oMIvsFR/6gYITj4Unduv6oBf/iTRKc37/95Yi/LoFDleAxWJf3ejLBvt7rynFM/wlj10Us61E0NeBZiJx+iuVUT32fjgTrFBozXSdhBMNTFDHEDAG2bBWnkjNxP6KRYqfZ5YZsFwbCZKXWGZKhd++SAtWPMPhfFmS0x4MNjqDyciPqw6VmqblI+IA3lZNSoFRKsy/TDMxENo3I4hor7uX9JIaRA8/YvKcpcV6Dww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+pws3BJDrQYddNYWVtrMHjNU/wbVfXCAXb7y3TXbhM=;
 b=W0IJX5HaYQIldMCT1bk5eQ2lfDCb5gh5himlEJ74/PYPK3r+isDl7vzODUB0IYvdQuS+qFNRuO7I1LQvGCXhH63NgXAy6vUJOdaiGuube3vSpM9FsFCWDr58K97CFq9EQado2MZcuH8KjoH2+c04eY9M+10ib7Em2G+Aual36URpJbBGHIuu9zg6mjPgJx7noiEa8bV9G4D16PlrnP+vW55XqjsuOKgsUSpInR/1ChyeEFap/NDfV9xmpYs0I+eG92Bvbml5J6uhFbs1LmJlqyCeEtznJ0YUJq4yaXYAE97mGrvuWecgb+jK/E3+1XIk6zEIXKC0je/KKWcpvisCQg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.16; Mon, 10 Nov 2025 16:55:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 16:55:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Garg, Shivank" <shivankg@amd.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Zach O'Keefe" <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Date: Mon, 10 Nov 2025 11:55:41 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <69FF5A7F-1414-4DE5-8A2D-09ECE240711C@nvidia.com>
In-Reply-To: <e9a0ec60-6e8c-474f-931e-2f97e5bb60c0@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
 <bc07aa10-d8d1-435f-9393-6c4ab63cc179@lucifer.local>
 <e9a0ec60-6e8c-474f-931e-2f97e5bb60c0@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0053.prod.exchangelabs.com (2603:10b6:208:23f::22)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: c42e9d0e-94c5-4e4f-59e1-08de2079fd5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RXaYwG/oRMWLm48ONIsFvNMS/FpiSZmeAy8k0RjVKENYsyZSWlY264hs2moy?=
 =?us-ascii?Q?CDVnhbAi/LPTAazUvYPWuICoJzRqDQXX6Tp+ooxf221ormwxaLtGrjNUtSQf?=
 =?us-ascii?Q?UgyRAbSpgFO0utahI8hGUq/jUAbJJhtY37RUjhppCgEeLaQ7WsdTHlhIBn0A?=
 =?us-ascii?Q?q4fjF9PFTo3ziGy3YNEIleVZ2EvRSaVl6ItFKrPETt1z3Ot+40IYM+RB1FoD?=
 =?us-ascii?Q?54axCXFTCnd6vQcgriA0ghNYomSe4mihVT1uXEjtynEmyZkCF4KhrfKYI9zi?=
 =?us-ascii?Q?9ts0viQ6UZDMnJWEf7UaRu9tyYXFTTbkq/lE9Y8EHwWEPh+Ql+7JN10SY6eR?=
 =?us-ascii?Q?g/Ij4vnT+B8sBHeCiXJUgy2Lz65SgoPf5F5QAzkSBxIQpcLvKj9PlFguC61B?=
 =?us-ascii?Q?9yjKNrrnxadujfNmLZSimjq2efhRBPrES1HaXGZWtMhrQ1k/iMkrVemHX0z5?=
 =?us-ascii?Q?S9yBwrIyR/wkfhhFZNMIHecKhKtPFAqXW4KRDT81TAjj1twJOjg1rrL2kF+L?=
 =?us-ascii?Q?8PfViqoRYKzozK/KqjHwEnvayiKLCecIFcLl/dMiFHnr48wLLLDhsFRAWcL7?=
 =?us-ascii?Q?hSxbDQ/WuUS0MCIwpZ0VSkU9mWUYhuyoExRtw/GvXXX+7M3r7LWqB4g5GvnK?=
 =?us-ascii?Q?rmFurJEm4kNbWDJmvIW3CMf5lg1pTbHASk4fT4UDo6j1xzqyHTr3FaJJEOp7?=
 =?us-ascii?Q?fqb5Vl4PVmdvRcwRJhbhLm5bGEhBDOUuM2pb6ZuZ+6VxY9zfA5X9CfSzfUOX?=
 =?us-ascii?Q?ttoycZogKpgwg0UXZdLn0plgn4CLdDqA74vW5MXCZzXc5/uRRA2/87Js887Q?=
 =?us-ascii?Q?W0AwT6rsmd1h+6xx4b672X4gHSpP9Si2f2poehFIH3tMGpO9jsDZkeSbLY7P?=
 =?us-ascii?Q?u9geWjouph8dbClDZD2CFDUy51RcNFv0oURLhG1n85zO9upEiWtpGxltETCr?=
 =?us-ascii?Q?sC1d2BsQYc81Gs5uHHKRyvVti9wU0gFOivEjCJEeLCPeI004cLM2tFXdjLrE?=
 =?us-ascii?Q?Cx8Alc5xxV6qZUc2HbMBQRlArQ6hRRpw8AToZitcdrtJhQ6lZrYWmVeda87K?=
 =?us-ascii?Q?028F2dw7o9cvGO1QeRELYCKxuPuoKezWqP/vSYwiw85oBtKcIIKznPxSGGQF?=
 =?us-ascii?Q?a1bGMtqV4hiqWs+zeuzMg8FVSi9AX98S1/4V1N8mt5Z7gN5qBq6GrbawaAMt?=
 =?us-ascii?Q?K989x0tLLhSz2zskVic3Ep/WVtLYiTwQYBbCvDKnY0d4O1BXuoliKy1aWpeD?=
 =?us-ascii?Q?CpOZlbbcMiADUURLPyM4WcBDMotsVfbv0/9vyTORazaGf7JqgjnmsnD1xwfC?=
 =?us-ascii?Q?LPZaQZdLw96pBhKsuLH6dGno3mf+B/Y/KeFX3On9q1rfr/ZN2DtUJskulne4?=
 =?us-ascii?Q?COLrKccTs2ZIDShVLoQVidVOvR4ZqIRk3TVuqsXjAkwONvPKqNI0gIR8g+kt?=
 =?us-ascii?Q?iZDKZQVBy32Hmf68+Hq7BFZpoxf7inVR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7C4I52X2El60O3DoIjy9+NeX56tne6fH1mARTJ6QSzsF1gpQUZaypAwwcca/?=
 =?us-ascii?Q?kn5gTCpSNBq2SDxE2Mst6ZdKLzjneLrK7ouPUB3xDZ/+EZfQiFa9Qz8CNS2B?=
 =?us-ascii?Q?jQE9Vnp4s0KR6w/RnOfV9v749qcnYOf71C9jLUKNjmuQO0ZZB2286JRaLcv7?=
 =?us-ascii?Q?WqFWs0PymV33mSFAEC+g12vcgO5BnlThP4fVv7xzitow1fVaYhfUoqq6zUFB?=
 =?us-ascii?Q?ktNQwbn3zyMOgGyhaNonnjV67NFEJ3Ris4Ii5L85fqUtj3qhdcbVewvvGd+v?=
 =?us-ascii?Q?ROz+AC6yL6Q1I2q/xtuq+4+h1fgEjNjm1jH6+/YwXVydXbcKS8TgZtCENlm/?=
 =?us-ascii?Q?/4bKXRobErFAVucUuBxiV/hjP/HIgs+/o+2kzM0Qs62NBknlk4dbAqOBKtRG?=
 =?us-ascii?Q?Sk+xNptjHH2AJF7KCMg+UIgt3WnZv8wI7bx5MmbIEpHHW03iVmO9Diiv1q91?=
 =?us-ascii?Q?vVq06ZpipW6ofIHYbYj3jaAJXtRgibo/GFwt5m8LRGoHala9/txoHqmpGfpH?=
 =?us-ascii?Q?hN2rxMZp1av/muRLafAtBYG7CfBYeTq53fyjrwNIGsSdBr40f9At6nuxBd+g?=
 =?us-ascii?Q?fTKcqshmd9qvuiccDZFe4t4ja6r1FN6/N8mFy/oy0vt8UOAi1Owjk//Wpnbg?=
 =?us-ascii?Q?bZhxqCuqPd1X/o3SLpnTUgUxET0mQGnkREFZi6Fqqn4tZj3vZq1cS8U6jAfY?=
 =?us-ascii?Q?lt0hUzlWb/vFY2zGT9leF7TT46LyvhHJ4nW6F3KKYu8VcB/JyLitZ/urUoqk?=
 =?us-ascii?Q?GdFkXiT9HW8+VsY1fy3unAdyQP2+reRKJdYpnGush+bYZamJtnXXy19haSk2?=
 =?us-ascii?Q?bYbBXTI3/QNj+64cnf37wCcCZjSvS909iDYUIVTwrv0udMWgJR+Z83/1fJYO?=
 =?us-ascii?Q?i55TPrvWgOcrPbRcFipCiiKClEx72q8puR+lVvZ3fKXUKEy7xanwfjydLfX4?=
 =?us-ascii?Q?R1k5S8ZJbDCv07VncWFhVDBfY9+FhjOFuBXHZ4/Q/OMVjtpALoWcEQOzQR62?=
 =?us-ascii?Q?e0+mi5aTXREUYbRT7ykmwwasbXR5XEl8pZIZmt3U5xinmY+WPoI9ABwigzcw?=
 =?us-ascii?Q?b7EXCHP+j79L8gppP+9TNmbtjZZzWVnvInqNwD1jwpVlcSQjxe+hC4E5THWi?=
 =?us-ascii?Q?tGE3bSxEOzCEUXriTMLBhX3sHhTojuVVVYNf3Wdgj5auZ9er+J6zvaD0vfMg?=
 =?us-ascii?Q?psZqrO7uvL0XZKC5KLHNpiHFA+3xB9Cpxyz5+lvoLlD4O5IAlwr+kjZv+b3B?=
 =?us-ascii?Q?hhMAji/DSXHWMH/Ius18A33HyMVK/lo/4wHI+CDh1UJua7twRZfHWPc2zmKF?=
 =?us-ascii?Q?4rLpmzjAaTuv4zdGubU3XEtzZUqSHMRu/y3gmBlGgb1eVL+0Oj4R+BjopCvD?=
 =?us-ascii?Q?0C0iBEaOojU3Rn2j42aK9GJOKv4RW65brD9YtuYlrh2ggKrlkXWVOmPk8izR?=
 =?us-ascii?Q?uh+jUKV9/U9OR/gosJDbmlMA0kLwksB0HSZ0kg3IQdoD5cp/6bRK6x/lEQ0p?=
 =?us-ascii?Q?FOy9oqIyK5oyTqUk2kip4TFUP4j0lxjbAYuFDZTb2EWpJyYLaY8xW3lquzQD?=
 =?us-ascii?Q?QoME3oNAdGOBTondEqzk5KtYRA1v4qpS98Y1lJm+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c42e9d0e-94c5-4e4f-59e1-08de2079fd5c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 16:55:44.8942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmaqfkWXOicCDFYi8SrHaLaHVnViCCgacncVbYEKgpYRs9Ej1gbSeI2jkJ79FRXf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40A702001E
X-Stat-Signature: 54pwciceoy4pb3hg1ush9cpfmd47me3f
X-HE-Tag: 1762793748-714039
X-HE-Meta: U2FsdGVkX18bmp7eQsqDWTVxEP7cXyvQz657WseU4CEsvnyayh8LhgERal1EGUVhRsNWjC82ifApHuxh1h13Q8eZuZTSuSVSE4niCOe3nUGRupMpy8Iv4iTiohAhXmU9Z7fhHnlnAoDIWff0tWdlYqCBONUQt0Lg9kLoplNZlfYDomdKSk+9kxixpbOQ/+tn6N+UT5tBFf3bN+BiBKuJVRXror+vnv+6UpTyeu0HCfoPQ20aaIj9QBDhf8Ii2re1YBv+RVPYY38RNVUYDNYS4eW6k9nJcnw4LO3dza5amMDs/Tm0w+P8uiKcsGf68r/GjhLqzXmcXK7AIYOgRsiJroj0HCczsAXW6thA8lYc31FrrWITrAPsW6cwzzzRnPt+LFBqhVIBP7O+UsFA8zUxZDy6GDkAFeIzkxX62cYRgOXmW87uKhd0g8xOZnyYp9ZzS+MQSUDoIz3yCQMzsGHNi/h354dRla7dOwM0tmi/h+8m3/TPLAiApY/IAZuBZyavHrygXd60cPdaLaeW+7N22g4WkydXOBbd+hODIdvgJkKsPSDfMVblDujdT1PdoQpmm6btlHZJ4e+YGOKXy3G1Cpd4Ss7/hLwIKB0WceP3L+g+LkbP95spueexfCVg9BPq6PNoPW7nf8B0uXEeEw6Xq0skkYh97c7ieN5BWcy6MzZ+gET/C7lhxpqThniTb+9prFL0/rXzH/EyVof5z49AGup1El3UQPQ+R9DI9Nwnjnh01YiU77BMUEpZJ8M8dEjAwMfV+iagtGJNjOYXn4f+OlTP2/uDZaiPOW7rxkbVZHD80++SPfQ0HGBsgCrsq1+5BO004dOC/aXfJTATuHmHWXlJpWRcnunnqrY4TRkUPAVPNJUkmp5N2btE3jXdYV2B9dmAUUkCI2VRcuCmAJ3ZZoYfD+N2SpyvfaxZRqojh5Mdu4Wq/zbaPKBkdqwwKJivXrc9SgR258QB4t2bJfT
 oF1v5Jm9
 X+CcZejORhXA5/+zWsyGdGFaa3OrNpp0vs5TTFfhhsm0BL5ioG440s8stErVEh/Yo0dI4iLZsHIrkBMNPVtgC0NXlHtHvKaAWWb6di+fzNsDTg1tVCv5CMInG95YJ8UowZCVrCMYkGrQFqHtTgAsJoHuALSWpKIRGqaLwb+JJ1EVHXe0EABxpeF1p47TSxFT+yhxzr5AoKTFnb7kAht57exRS0Fv1ixbal2HiayD09CrEOtCNqaNeHC3jnZH+ERzUS/0cTWYZVFZzm0er7D1DgxISERB4oZ+T36PQhVncVyMICjsmzeXdJjuHd/q87vAbby5CI9zBYvR0OINoedTFF8kAfOdG7Ojw55NR/wTFkYSgfJ546meJOrXWovhPAmo0mUCh7CKs/q32BFjs64XSVG3Ltw4u1f7W5dz8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Nov 2025, at 11:06, Lorenzo Stoakes wrote:

> On Mon, Nov 10, 2025 at 01:22:16PM +0000, Lorenzo Stoakes wrote:
>> On Mon, Nov 10, 2025 at 06:37:58PM +0530, Garg, Shivank wrote:
>>>
>>>
>>> On 11/10/2025 5:31 PM, Lorenzo Stoakes wrote:
>>>> On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
>>>>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executa=
ble
>>>
>>>>> ---
>>>>> Applies cleanly on:
>>>>> 6.18-rc5
>>>>> mm-stable:e9a6fb0bc
>>>>
>>>> Please base on mm-unstable. mm-stable is usually out of date until v=
ery close to
>>>> merge window.
>>>
>>> I'm observing issues when testing with kselftest on mm-unstable and m=
m-new branches that prevent
>>> proper testing for my patches:
>>>
>>> On mm-unstable (without my patches):
>>>
>>> # # running ./transhuge-stress -d 20
>>> # # --------------------------------
>>> # # TAP version 13
>>> # # 1..1
>>> # # transhuge-stress: allocate 220271 transhuge pages, using 440543 M=
iB virtual memory and 1720 MiB of ram
>>>
>>>
>>> [  367.225667] RIP: 0010:swap_cache_get_folio+0x2d/0xc0
>>> [  367.230635] Code: 00 00 48 89 f9 49 89 f9 48 89 fe 48 c1 e1 06 49 =
c1 e9 3a 48 c1 e9 0f 48 c1 e1 05 4a 8b 04 cd c0 2e 5b 99 48 8b 78 60 48 0=
1 cf <48> 8b 47 08 48 85 c0 74 20 48 89 f2 81 e2 ff 01 00 00 48 8d 04 d0
>>> [  367.249378] RSP: 0000:ffffcde32943fba8 EFLAGS: 00010282
>>> [  367.254605] RAX: ffff8bd1668fdc00 RBX: 00007ffc15df5000 RCX: 00003=
fffffffffe0
>>> [  367.261736] RDX: ffffffff995cb530 RSI: 0003ffffffffffff RDI: ffffc=
bd1560dffe0
>>> [  367.268862] RBP: 0003ffffffffffff R08: ffffcde32943fc47 R09: 00000=
00000000000
>>> [  367.275994] R10: 0000000000000000 R11: 0000000000000000 R12: 00000=
00000000000
>>> [  367.283129] R13: 0000000000000000 R14: ffff8bd1668fdc00 R15: 00000=
00000100cca
>>> [  367.290260] FS:  00007ff600af5b80(0000) GS:ffff8c4e9ec7e000(0000) =
knlGS:0000000000000000
>>> [  367.298344] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  367.304083] CR2: ffffcbd1560dffe8 CR3: 00000001280e9001 CR4: 00000=
00000770ef0
>>> [  367.311216] PKRU: 55555554
>>> [  367.313929] Call Trace:
>>> [  367.316375]  <TASK>
>>> [  367.318479]  __read_swap_cache_async+0x8e/0x1b0
>>> [  367.323014]  swap_vma_readahead+0x23d/0x430
>>> [  367.327198]  swapin_readahead+0xb0/0xc0
>>> [  367.331039]  do_swap_page+0x5bc/0x1260
>>> [  367.334789]  ? rseq_ip_fixup+0x6f/0x190
>>> [  367.338631]  ? __pfx_default_wake_function+0x10/0x10
>>> [  367.343596]  __handle_mm_fault+0x49a/0x760
>>> [  367.347696]  handle_mm_fault+0x188/0x300
>>> [  367.351620]  do_user_addr_fault+0x15b/0x6c0
>>> [  367.355807]  exc_page_fault+0x60/0x100
>>> [  367.359562]  asm_exc_page_fault+0x22/0x30
>>> [  367.363574] RIP: 0033:0x7ff60091ba99
>>> [  367.367153] Code: f7 d8 64 89 02 b8 ff ff ff ff eb bd e8 40 c4 01 =
00 f3 0f 1e fa 80 3d b5 f5 0e 00 00 74 13 31 c0 0f 05 48 3d 00 f0 ff ff 7=
7 4f <c3> 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec 20 48 89 55 e8 48 89 75
>>> [  367.385897] RSP: 002b:00007ffc15df1118 EFLAGS: 00010203
>>> [  367.391124] RAX: 0000000000000001 RBX: 000055941fb672a0 RCX: 00007=
ff60091ba91
>>> [  367.398256] RDX: 0000000000000001 RSI: 000055941fb813e0 RDI: 00000=
00000000000
>>> [  367.405387] RBP: 00007ffc15df21e0 R08: 0000000000000000 R09: 00000=
00000000007
>>> [  367.412513] R10: 000055941fb97cb0 R11: 0000000000000246 R12: 00005=
5941fb813e0
>>> [  367.419646] R13: 0000000000000000 R14: 0000000000000000 R15: 00000=
00000000000
>>> [  367.426781]  </TASK>
>>> [  367.428970] Modules linked in: xfrm_user xfrm_algo xt_addrtype xt_=
CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat =
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables=
 overlay bridge stp llc cfg80211 rfkill binfmt_misc ipmi_ssif amd_atl int=
el_rapl_msr intel_rapl_common wmi_bmof amd64_edac edac_mce_amd mgag200 ra=
pl drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper acpi_cpufr=
eq i2c_piix4 ptdma k10temp i2c_smbus wmi acpi_power_meter ipmi_si acpi_ip=
mi ipmi_devintf ipmi_msghandler sg dm_multipath drm fuse dm_mod nfnetlink=
 ext4 crc16 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy as=
ync_pq async_xor xor async_tx raid6_pq raid1 raid0 kvm_amd sd_mod ahci nv=
me libahci kvm libata nvme_core tg3 ccp megaraid_sas irqbypass
>>> [  367.497528] CR2: ffffcbd1560dffe8
>>> [  367.500846] ---[ end trace 0000000000000000 ]---
>>
>> Yikes, oopsies!
>>
>> I'll try running tests locally on threadripper, but ran tests against =
yours
>> previously and seemed fine, strange. Maybe fixed since but let me try,=
 maybe
>> because swap is not enabled locally for me?
>>
>> Likely this actually...
>
> I have tried on swap-enabled setup and no issue with mm-unstable.
>
> So this is odd, I know you have limited time (_totally sympathise_) but=
 is it at
> all possible if you get a moment to bisect against tip mm-unstable/mm-n=
ew?
>
> Obviously we want to make sure buggy swap code doesn't get merged to ma=
inline!

I could not reproduce locally either.

Shivank, can you share your config file and machine config?

>
>>
>>>
>>>
>>>
>>> -----------------
>>> On mm-new (without my patches):
>>>
>>> [  394.144770] get_swap_device: Bad swap offset entry 3ffffffffffff
>>>
>>> dmesg | grep "get_swap_device: Bad swap offset entry" | wc -l
>>> 359
>>>
>>>
>>> Additionally, kexec triggers an oops and crash during swapoff:
>>>
>>>
>>>          Deactivating swap   704.854238] BUG: unable to handle page f=
ault for address: ffffcbe2de8dffe8
>>> [  704.861524] #PF: supervisor read access in kernel mode
>>> ;39mswap.img.swa[  704.866666] #PF: error_code(0x0000) - not-present =
page
>>> [  704.873253] PGD 0 P4D 0
>>> p - /swap.im[  704.875790] Oops: Oops: 0000 [#1] SMP NOPTI
>>> g...
>>> [  704.881354] CPU: 122 UID: 0 PID: 107680 Comm: swapoff Kdump: loade=
d Not tainted 6.18.0-rc5+ #11 NONE
>>> [  704.891283] Hardware name: Dell Inc. PowerEdge R6525/024PW1, BIOS =
2.16.2 07/09/2024
>>> [  704.898930] RIP: 0010:swap_cache_get_folio+0x2d/0xc0
>>> [  704.903907] Code: 00 00 48 89 f9 49 89 f9 48 89 fe 48 c1 e1 06 49 =
c1 e9 3a 48 c1 e9 0f 48 c1 e1 05 4a 8b 04 cd c0 2e 7b 95 48 8b 78 60 48 0=
1 cf <48> 8b 47 08 48 85 c0 74 20 48 89 f2 81 e2 ff 01 00 00 48 8d 04 d0
>>> [  704.922720] RSP: 0018:ffffcf1227b1fc08 EFLAGS: 00010282
>>> [  704.928035] RAX: ffff8be2cefb3c00 RBX: 0000555c65a5c000 RCX: 00003=
fffffffffe0
>>> [  704.928036] RDX: 0003ffffffffffff RSI: 0003ffffffffffff RDI: ffffc=
be2de8dffe0
>>> [  704.928037] RBP: 0000000000000000 R08: ffff8be2de8e0520 R09: 00000=
00000000000
>>>          Unmount[  704.928038] R10: 000000000000ffff R11: ffffcf12236=
f4000 R12: ffff8be2d5b8d968
>>> [  704.928039] R13: 0003ffffffffffff R14: fffff3eec85eb000 R15: 00005=
55c65a51000
>>> [  704.928039] FS:  00007f41fcab3800(0000) GS:ffff8c602b6fe000(0000) =
knlGS:0000000000000000
>>> [  704.928040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  704.928041] CR2: ffffcbe2de8dffe8 CR3: 00000074981af004 CR4: 00000=
00000770ef0
>>> [  704.928041] PKRU: 55555554
>>> [  704.928042] Call Trace:
>>> [  704.928043]  <TASK>
>>> [  704.928044]  unuse_pte_range+0x10b/0x290
>>> [  704.928047]  unuse_pud_range.isra.0+0x149/0x190
>>> [  704.928048]  unuse_vma+0x1a6/0x220
>>> [  704.928050]  unuse_mm+0x9b/0x110
>>> [  704.928052]  try_to_unuse+0xc5/0x260
>>> [  704.928053]  __do_sys_swapoff+0x244/0x670
>>> ing boo[  705.016662]  do_syscall_64+0x67/0xc50
>>> [  705.016667]  ? do_user_addr_fault+0x15b/0x6c0
>>> t.mount - /b[  705.026100]  ? exc_page_fault+0x60/0x100
>>> [  705.031498]  ? irqentry_exit_to_user_mode+0x20/0xe0
>>> oot...
>>> [  705.036377]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>> [  705.042200] RIP: 0033:0x7f41fc9271bb
>>> [  705.045780] Code: 0f 1e fa 48 83 fe 01 48 8b 15 59 bc 0d 00 19 c0 =
83 e0 f0 83 c0 26 64 89 02 b8 ff ff ff ff c3 f3 0f 1e fa b8 a8 00 00 00 0=
f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d bc 0d 00 f7 d8 64 89 01 48
>>> [  705.064807] RSP: 002b:00007ffd14b5b6e8 EFLAGS: 00000202 ORIG_RAX: =
00000000000000a8
>>> [  705.064809] RAX: ffffffffffffffda RBX: 00007ffd14b5cf30 RCX: 00007=
f41fc9271bb
>>> [  705.064810] RDX: 0000000000000001 RSI: 0000000000000c00 RDI: 00005=
5d48f533a40
>>> [  705.064810] RBP: 00007ffd14b5b750 R08: 00007f41fca03b20 R09: 00000=
00000000000
>>> [  705.064811] R10: 0000000000000001 R11: 0000000000000202 R12: 00000=
00000000000
>>> [  705.064811] R13: 0000000000000000 R14: 000055d4584f1479 R15: 00005=
5d4584f2b20
>>> [  705.064813]  </TASK>
>>> [  705.064814] Modules linked in: xfrm_user xfrm_algo xt_addrtype xt_=
CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat =
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables=
 overlay bridge stp llc cfg80211 rfkill binfmt_misc ipmi_ssif amd_atl int=
el_rapl_msr intel_rapl_common wmi_bmof amd64_edac edac_mce_amd rapl mgag2=
00 drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper acpi_cpufr=
eq i2c_piix4 ptdma ipmi_si k10temp i2c_smbus acpi_power_meter wmi acpi_ip=
mi ipmi_msghandler sg dm_multipath fuse drm dm_mod nfnetlink ext4 crc16 m=
bcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_=
xor xor async_tx raid6_pq raid1 raid0 sd_mod kvm_amd ahci libahci kvm nvm=
e tg3 libata ccp irqbypass nvme_core megaraid_sas [last unloaded: ipmi_de=
vintf]
>>> [  705.180420] CR2: ffffcbe2de8dffe8
>>> [  705.183852] ---[ end trace 0000000000000000 ]---
>>>
>>>
>>> I haven't had cycles to dig into this yet and been swamped with other=
 things.
>>
>> Fully understand, I'm _very_ familiar with this situation :)
>>
>> I need more cores... ;)
>
> Oh it's nice to have more :) I am bankrupt now, but it's nice to have m=
ore ;)
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi

