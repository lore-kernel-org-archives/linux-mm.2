Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41DDACD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729466B0005; Tue,  2 Jun 2026 11:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D99E6B0088; Tue,  2 Jun 2026 11:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1A56B008C; Tue,  2 Jun 2026 11:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 466B06B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:14:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 968E31C10D7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:14:08 +0000 (UTC)
X-FDA: 84835318176.30.993DF68
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	by imf10.hostedemail.com (Postfix) with ESMTP id 96DFAC0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:14:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hxSnCGWp;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780413245;
	b=bPJKZh4e0AQCACTkN7FpJDAdAGSbL5XjtyNap9Va17AhgwZz1S96EQTw5Xh8QcAom0W+k2
	tCdBPTFd/ahNAofZth6OBAmyGAT3iAkq0B+EEGgsEAIcoc3PuoGottPyV0ENXj1xHBu24M
	rp/yEo3WbF1xZpyeHXG0jew/auojjnA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hxSnCGWp;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780413245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbEH2PfF94u4aO8jKVjeu0AiM9VgRZUJ6PvaAWYd180=;
	b=4MjvlJEIgMXl6A6CLiNkgK26oigr/AFQCcj676LgwrBH52uxSO3AlVaIeIFBJ6QnRoOq5+
	45WcScB5SDPR8jOZs9FR5j03eSvzd3YKO/hMQMXWigjfrIAafHVBzGnEQkcGp1ebaJosBJ
	7/XSFY7xGUmrG59DgELDh+aF7AIpYLc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jqqjnboQZyL0wJLaFzEKYsccu9w+eY3dumPct4CanMq+S7NK2UmPgjfNpEzScULmzVQIpp5/oemfqJxMM1OM7EUHknGZFkNhpOUL1zV2AQ3bu5J3E5v0G8ejQhuhjRCf/o59Ehtm8CA+N6dlEaqOakAFuV/esriCZh8vRrG/1NSWHJ9qjnu50tPQ+ozen9eisVLJMCe0EwCtLPzA/1s1TUXHnCpo8ItjmsQ+72nxl/HHq5Pplzdlmy888smlmd+KsWD6O04slwVC25yD3ZxKhX3pY+gR1/apMPKYMtzLpPPvgrG5UlqvLZG1IQE2V4MbcepvZJflGFVlXJXkG2M8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbEH2PfF94u4aO8jKVjeu0AiM9VgRZUJ6PvaAWYd180=;
 b=fnIdGmVH79WdzM07wg/lwkCclcUhetTP33oXsfkHvvcG2QACHMEvKgmkDQ9nBVrkS4IFoe+W4z6SseYojFZRO+LIwskLnWE/DFXJTWrCGbKID6Il6408YeQOxF2L7O7u0/SfnqwWLCwr/OZ15SJqDWp4TTsrYTGCZm2QA60gM9TMWIJZS+MOhULL6Zd+N4mU8mi0bVOxoqBqZ1aH+ua1GA7WRXazCDZ5m/3CCcX3YW8ZdjhJjAIcL2B2IWZg0yT5+G9QD5TixzCRacfevvFsZb84CSXFsAArwvBGPFmeuaEnsQCL8rCCgfUAtkGKrcvGE2V3Q8i+fjXDJtJFtW6Iug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbEH2PfF94u4aO8jKVjeu0AiM9VgRZUJ6PvaAWYd180=;
 b=hxSnCGWptm33LawAKw7WyHVnirSlUho6TMJ1LhBEHQDH6b1niZ7yXkNtX4N4oMVWqn/SBjTqlj+S3LKPZ9xLT6Im/PEwAO51/NWiqynjvpRfrk4L8JGwsVLbSLQ+M4ekMvJGn22s9A4+pkgiUJn8Xqid32bKG1H2U6TOOjX2wo6vLz3w5FLVSsu3102vZBDkYwySRo+86bwCD0QgHs+r7r6gwqNAay3FchaewHZ3gvv5HMiJDrB82WcoyABj4ni1Xq6rEBRmIHGDJX6nsRTfMH9jDPxnl2haEPzBnp4o70v19WziR+kBHdWS96WaIwkbEcASgB6ZyJpTuFGWcVHzbQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4313.namprd12.prod.outlook.com (2603:10b6:5:21e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.15; Tue, 2 Jun 2026 15:13:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0071.014; Tue, 2 Jun 2026
 15:13:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, lance.yang@linux.dev, corbet@lwn.net,
 tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
Subject: Re: [PATCH v5 02/14] mm: shmem: shmem_getattr(): set blksize to
 highest supported THP order
Date: Tue, 02 Jun 2026 11:13:55 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <CABEF982-7267-494A-A3CE-2CD8AA9F07A3@nvidia.com>
In-Reply-To: <e8e07851283c47a07a52d342afc60c19fe2b0421.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
 <e8e07851283c47a07a52d342afc60c19fe2b0421.1780066530.git.luizcap@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4313:EE_
X-MS-Office365-Filtering-Correlation-Id: ce96b267-d3e3-48ee-d587-08dec0b99224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	xzQlLTFbQwZsI/SqPklHZv/nXuMxx70ossoJ3/b6XgactKFpolstGyFMpSZ1EN2LwOc1Cksf8s5jK4lEdrPlZ5zrh5qVKOMQJYAyhYVDNKVys5tpPmIagV2yrZwbn/M40RXNe+JqZHixCrZFFcW67S8Xialrm28O3v7AixspXVJBeOFax2c5hKiUq98vmQB6FexnWALkiYcuFMgMZhmt/ssD1D2MFiPFIIsAjks9/ZdIYW+H2Q4kqh946+t5DeSjpqmlebE+9OSgd8JEB/lrJdUkvF7d2V1+nvYFMA63jtIIsinstSf1oR3jk5teluTnA5mOOUGKWw8RcUS4NPSxv6gVTXe2jj5JyPJWlNQ6kagaZk7EDuNaw3UvXLpTEOnfQvtf7ZyELlKZeGqYwv2xYYHPi3iJ4pKd63jL7VQdiv7SX+ZTY/YxSiNdUF7RZ/njJtWkuIl/Ren4cRpZSoxExMqit6lrOtYgwPbltXaZgLzqzzaJCw4n6Q6rBlEuijOteXCE/FB1QQYtdcZx7eLapReZp75tngRtdZMrzVgibFILOA+naZQ6CFF3PMUUagWjq7Ril3I31MHzuczaqDFTpuNaLHUFyPOLlOuhyC5Y1FEJeiPgQ1aCyD/cYpisH0TW6hkJ81QxIC3ZLkZsMRHW5dySYfGHfQ19/AIo0LGs+vdKM6XXYHvrpoDF8IGT4lSqb9oIzDtWkz6Lp8wwDmqcRQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?08gTeNUjtb1Rcnq3wzMV/SNqgvOIbIZ/MdGeAf9E/9xJlXaZSpCpwyF2RXeY?=
 =?us-ascii?Q?zd/E32oN/glKCPwISfV0QwNvfKI98JztS1JF9u5d4CGApUV8keOmmjUnn/Hr?=
 =?us-ascii?Q?WVmVKRmPJN6ythAV3jo8Y4XhASniHlmM7ejzsc4r1jhSGrx2j2t66x709FIS?=
 =?us-ascii?Q?FHLWaWBKD+Jsap69hHJuZBqDsNhovVXJSjsqrQn8CpPccjvIBgthl1KiQCxb?=
 =?us-ascii?Q?14Hj80vezyUq8r9XQDeuunXwJfnlYNqqojuh+wc52d+AHWzadqTlHFBn0FUy?=
 =?us-ascii?Q?b8RJgfIuERvFMeTg8yNzJNfC6sRRFVY6woAKAGk2JtsfKxYNdCcnUWpwU5N+?=
 =?us-ascii?Q?M/aXE0RI5a7Tv+qPHb5e6Eo0p8XoBvOlvT/DUpFiIwvYLvZuVW6KzFhdGt7J?=
 =?us-ascii?Q?C5yHDZV9xuw/gYV2Q4JXJpEd0M2//58MdPUovmpIC4GTMAe82yC9P3hFbvGS?=
 =?us-ascii?Q?19i+9kao6FiwYydgUJdlb5NkI/lZ1dh2GLEEpYJEm57Y3JkbW+BhV+eWB2ak?=
 =?us-ascii?Q?Nu5bDwvwpZVi0+U08DPYARKVO3AcWJc1KLEwX9TMzzqWSAVqNvsrtkdG3DGA?=
 =?us-ascii?Q?oHrtzFk5K/ZiB76o3No/cee74NTE++sIwapGyWXImHL/YMREg10JdhCpaTzF?=
 =?us-ascii?Q?gEzvZx4HNaTrO+Bbar4jx+BmTKEtgiOCN+sdkuE9sXeSG6vTFyetd1ZZvYqW?=
 =?us-ascii?Q?Is0c55aVENrTwC3y5sTFFKa0PZQuHjqAVBfMGB+HC4FjfvVTIvmmnsGLte2c?=
 =?us-ascii?Q?38U+DmSGrLv09gdDOK7fvsEQ3r6haRn1iMl6v8HdY9quyeVQcWEm6xbIW3BT?=
 =?us-ascii?Q?c6Izlm9E2JwVh2VmnSy2+KEfzEGmzllkW/PN/hHWY36x+g1Axs7CWt2rJ6bY?=
 =?us-ascii?Q?bLFk/pIbblOv+veHL0KoeyBb14VzmqdgjYYcLokZCYcWcUi/sayAmoSmlc0i?=
 =?us-ascii?Q?V77rkm0XnAHYIyXdt6uveKGQhiRlyxaTr+u9kemWxXuHkOCsHiT8BjqAzxbz?=
 =?us-ascii?Q?EeAICZGcVUI6Qd0wNE1licfAJNQ7Y1Uhfi7YlD7bl4Cb4ZYq9DLiiiq3IBG4?=
 =?us-ascii?Q?cxNhJSbmJ/vWBjvr85tfBW7lg8wUDR9AEjibD7YBp/G3Fxfu9GIOefmam4B0?=
 =?us-ascii?Q?OKHVlayoeqtnDQXAWn98DJZUqdg00Tulg7CL+8Z3nuaAvaW6D9LVsl0S5jg+?=
 =?us-ascii?Q?CZlcdC/FmVUUGTE9gpP3vzwAfL7msZew124MlfEaJ9bJdmBl1pOT68fd613x?=
 =?us-ascii?Q?tNhdbfvaSZrX1s5L89an8TdnWQBef1cc2Sp+j7OhBkKeXubDiT1K+EC8BkQ1?=
 =?us-ascii?Q?mhyaigty4C/yogaTEZsJv7zIbQQt88Bqe2Y2XTjC9XEN+pao10AnNAlwrJ/o?=
 =?us-ascii?Q?TgrX1FLpyemlutLBzj6QAqTkLdLkvPwdaP/PAzMQuAUtW1WEjiY9zkccnJrm?=
 =?us-ascii?Q?a+jf9LCBOmMvKI0aujstjgOQhV/YDciQQSlSQXJyEFp/j87iLzlQ8WSBIwzM?=
 =?us-ascii?Q?G1z8TqjHcug/V3KvuuoqS8Es5gklbWzx+C5GZJ03YfD7k5TJWCjtzwYANxre?=
 =?us-ascii?Q?BfEadRmGKjRDVRL2Mr0kSmGKCWKoOr3gamPrQztzFRoHjXZLZfKZ/gXs8om5?=
 =?us-ascii?Q?bdXak0AZZAZiETA5l92Jv/hthP3auqOswyl60o5X5xl32JPy3aVVHxXSkVJ4?=
 =?us-ascii?Q?iU4OUeFPLaREzJ3HcBIi1Lb0fllSj3KklKe9AwPBdEM2o7S8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce96b267-d3e3-48ee-d587-08dec0b99224
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 15:13:58.9096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USpsavgXPIgfgtiCuy1f9FOAFsDD9jCUgw1npqbRzXgQzTinqHjOkRchzaoCTAQr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4313
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 96DFAC0002
X-Rspam-User: 
X-Stat-Signature: 5rougkc19ck8pz33afo1f9qowfj8445e
X-HE-Tag: 1780413245-981040
X-HE-Meta: U2FsdGVkX19BxvR0NYjmf3D5D6flkyK/e2VUcwmr2zVmpd+Ic+nS1wj0sdOy6e2TFmF8NOG1ZB5UJkWw5keBSAtivpsHpkHMPv/tKioYBUH3wHcBuJvXpUQ0TzqkX1vuEz85e8DZ4iPIzSmA/qBv7AnLv2K6OzfQVHH/e+WFTThAfXQTDwgGkMMhNiSgGZiCHuqDuuRDpLQWybNaXNJNDf1QC5+wRwjVsCWpfw3d2EHYMPemwdy0aSKJNGQiLw5CgePPgLoHKD1ZGQ/SI8/ApcLZ3dDs1MrEKBE+pL7iXvmk74j7WD85TtsWTG4ICrxUw9jnmsSbNRxm5dHn9W/JgJqAaOdNERyFsoIwdhOcMbWLL3EfR5i/8UcDqKbWvlVDYYLU7znyyAy2hoxMtJ5ibFRejq4B4rJC/0dsIccizNLAmghs8O0BzUEYD8Lhuc56HKoMCsn98sH1Q2hB5rY6umUaA3COJUdJwbavoGQlJnQBnR5kLBsZNci1luW5NHSD9BH9Dibn3gUrRmx1XX11PMorIEcFjx4gdobUsWAI++kwGQIA+q5ZgS3NSjKKXXMnpEbqYU5BKITrVFn2KAgJCqeRCNcwF1A8BntJZbFs/39fPJn0VpPmnqeXTf8IBFGZYz7z53M93cNB/J+wF2TPsWSFNi3rJ8xxwWaxtG4fnKVUs5dIyAX7Aza8JMD6Q+LVVpEHeVie10XTyLCV8AkUJa1AR9t18v+/iy5AyYk4Bde9LBnxHg4gN2+hz8js1jH8hEPSkksbJsBzUoVynf9Lsua7APP849Zpz81bn69vbguWzZaaMDFrklkuP9Q4lYP6BH/6U3aVeuRmQeyf5IUyrsC52EJfQK3SOilWqj5iwT+qjMqyoaqEJ8NmW9Wl0RYYTttyMfvqzRYc/fR2oz/qoBTHot0eELreBrbzLcVSdSuuZ2b1efWo00Sv6aMkt6gI6BCDuTIc231iHuruO4P
 Kr4gdpSj
 9jyUKebqxqC0ky2YdE9mjB2V6lhvMu7aNAAkPVHDqQo7vXMkJA6OZNUpc5g/EwBAabfav5maRHorkdt6fFl2Ql1G5dBtykIja5c9favlcglsTCv/AKjVvaJ9wasLnANSbcT6SpbU/jJPWUnlsGSlQGM1DXqsp+sI9KN8LLJbxK4GsMcGcbeRkMG8+dm6LxfTW5TE0dLc1MDknSdg36kuWSmqVhcgX9nNRBaMOGOD0xz4nbMsI6pZEFu+LiG3H76xbZTy6X+y/h8G1kL5kk0WOFLGnlzqc13WxMkz5Teqiu46hkYirPk7PEpkbqzGxPM/wH+mZT3wT9I4pI8P8XzBkeDLhinGqQxXz7nPuV3q+eak7K1Q1VH/lHk3a6gw3rGil/sZyRPGtZb3BVhX5DjoJTmZpuPqR4ocF7cMUmNfB16EOUajXRZStNxQMUHbOx5v1EGwjyad5FjIDqtN0kewQuqEbUWJLDQt3CDW+DIs2Z2vnF7bFr548DOFJBxl/U5G0dIU5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 May 2026, at 10:55, Luiz Capitulino wrote:

> Today, shmem_getattr() sets stat->blksize to PMD size whenever
> shmem_huge_global_enabled() returns non-zero. While this works fine
> for the normal THP-enabled case as explained by Baolin in [1], this
> has two problems:
>
>  1. Theoretically, when shmem is configured for within_size, this
>     could set blksize to PMD size even though the allocation may
>     be a smaller mTHP order
>
>  2. A future commit will allow shmem THP support to be enabled
>     even when the CPU doesn't support PMD-sized pages. We should
>     not allow blksize to be set to PMD size in this case
>
> In order to fix #1 and prepare for #2, this commit sets blksize
> to the size of the highest supported order returned by
> shmem_huge_global_enabled().
>
>   [1] https://lore.kernel.org/linux-mm/6591a74c-7ef9-4614-9ae9-cb2fbed8=
6ebf@linux.alibaba.com/
>
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  mm/shmem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>

Make sense.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

