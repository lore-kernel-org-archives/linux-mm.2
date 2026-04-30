Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832FBCD1297
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 06:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC89E6B008A; Thu, 30 Apr 2026 02:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71646B008C; Thu, 30 Apr 2026 02:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87886B0092; Thu, 30 Apr 2026 02:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9D676B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:08:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A2871204DB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:08:50 +0000 (UTC)
X-FDA: 84714193620.21.45FD3EB
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 253B140007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:08:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hWshtDf9;
	spf=pass (imf07.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.85.55 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777529327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0HDQtRs6hoGLMgtOJuxZJ2z6dkChkzYwugEdU+Fm9Q=;
	b=Q6tQeNiG/xtTC3S0N8Y/IZr0i2cai3bMr3C4TS6ziWLBX3mKTRMy09QNmU4Fk3R4gi+KgL
	vnwJjQsbU931bMDDYXnD8/hBmsWQ37sMmj513CPl05YVU46OOkkfdSFQoLV9Sd2Rmq86a9
	Y/hgJ0+iNgNKGP8qClP+kI0niRVsK7c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777529327; a=rsa-sha256;
	cv=pass;
	b=5V+Vwm6DayZyXXO8lyQPfgutvn5wnkhXdfU7weewsS1E/fItKtc5ZfQqfgDQycKWAu/ce5
	yTG0A76Pm1008n9QOoUGm+OOYFz0WgTmIeCfLjrdKFEA5/UqdcDMG/hpb/tG1rIllkfwMT
	85jYX8JgJwkESniVe1wp+U5Q8bzt02k=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hWshtDf9;
	spf=pass (imf07.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.85.55 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBWaLk91NIwKQ4C9RJCWdel7vHZ0X7XWcm/HPvVaCNGuGjy3kAcGceTR9NszWFbOlFGk+E0GBFJ67MIX1Z0wrz3n6ZtlO4IAN+/UKvFxdOEMsN5lwDaXHiOugd4e/z6d/izh2TaMwqnUdoMY9HRfjrjTS+EDLa31a6oPSHFhMsfLHYJ2apFrhj9PEIEMIFeIgFjKJj36Bjg8Lv3mjqAr+eAIoq0YEqJsHW201iwN3X/wFT0xZAq6EprzgwyZ6nnKMqFxYyKY5ZnvurKXJE5wmFqylkdyweKmOeODhj2IXJso0w/8uAzOgnj7iTTYetqnWPSEV545tj+EVEHcSPLX0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0HDQtRs6hoGLMgtOJuxZJ2z6dkChkzYwugEdU+Fm9Q=;
 b=bbFMVwEk3NqQCMuUOd8EfRU4Dp29cj8mxSsdta8W/hJ286jOBL/9wbe9PDvKdnEYeqT/3ga2tE5O4lEyDeoGZy1Bg0xB7zvP5Tgr4+OkwfwwQBGPhFDayDYtt6evosZM+4v0ozvqYoyIJAGL536iaggwU15iXncTaevy0uwWQvuhpRWnZW3oksiNKSnf9m0bEHQrAPmPzhdLOyS+Et3LmUhnqOHq5W1pTVAG5P4XXCeSyqfJ2bQYgg3VgL9/LYroeR/SoyOb7lK7v3IBme68EFwfSSr7NptwPh2dWnA1dmnvdme0TTWqQF1Zd3HzbvbgBZnwfgbQ35PH6U3nd3EnFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0HDQtRs6hoGLMgtOJuxZJ2z6dkChkzYwugEdU+Fm9Q=;
 b=hWshtDf9xNmDQUorPqIAwHkuDijyC4JCILEhIi7toXq6WZe44QSoORJDBdOOfjyAiEeEAdCoEF57gUqdT/ILmMFK9I8pGiD7XVz8p/7DyKZstk9V5FvvyOv0yEYYq5ed2U6BpwX23ru6NnO8AKD0xSYmf24g1ia+GamY8r0KwYA=
Received: from SA1P222CA0055.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::7)
 by LVUPR12MB999135.namprd12.prod.outlook.com (2603:10b6:408:3a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 06:08:39 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:806:2c1:cafe::bd) by SA1P222CA0055.outlook.office365.com
 (2603:10b6:806:2c1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.30 via Frontend Transport; Thu,
 30 Apr 2026 06:08:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Thu, 30 Apr 2026 06:08:39 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Thu, 30 Apr
 2026 01:08:36 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 30 Apr
 2026 01:08:35 -0500
Received: from [172.31.183.207] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Apr 2026 01:08:31 -0500
Message-ID: <0179f4b1-a22e-4686-be10-8fedf2ce7fad@amd.com>
Date: Thu, 30 Apr 2026 11:38:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: Ankur Arora <ankur.a.arora@oracle.com>, "David Hildenbrand (Arm)"
	<david@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <rkodsara@amd.com>, <bharata@amd.com>,
	<shivankg@amd.com>, <hsalunke@amd.com>
References: <20260422102729.166599-1-hsalunke@amd.com>
 <20260423041249.156eb95889696ccfaf23dca1@linux-foundation.org>
 <ef5ad58f-0641-4017-a199-defd25430bed@amd.com>
 <1253ca14-69de-418f-8f94-b08e8105e924@kernel.org>
 <f75e03ce-68d1-474a-9b85-157f73af48dc@amd.com>
 <b0243130-dd6c-4c9f-bbc2-7458aa0615c9@kernel.org> <87pl3jmqog.fsf@oracle.com>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <87pl3jmqog.fsf@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: hsalunke@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|LVUPR12MB999135:EE_
X-MS-Office365-Filtering-Correlation-Id: df06ce0a-1893-4d6b-0b0b-08dea67eec62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	2jpn9tmjH1TKYuGkkJNJFSSlVmj2kzzhwhhs0olUQt54ianzkLIuHvZhKkQ6uXGwXtIqvr9vl0JkUDmSuM1AJJFg/cTgn7x6dLxTJ4Ui3vv0EGPsQqhL8ITaJBvT/kbirRfwM/P7kzW4MkwFzb6tphy/ZGJc3nStJLztr12EVZoCyyy6lOxGLcEPWGtR18KjSc++T6BxDjnt/K4BrJHv4LXpwXsDJM/YxtkOr9nFuBT4mRkW33PW92UaFXUMlfRJBJH3hE7r/7NDvA9sHZsK5kQVxeL0LzBJZL3QfLlBKvs5wS0sOkyaXY9uMQqg+sRUFDxtwM7/4aCr/oxzPyDoretBksrNEzbw8GBlmCRcUJmlWSt7MxStA/wJaKR5vcLlTjvDXFDacu3raGnH5xA/n5NmHNkW1E1ULOylyC2r0ESjmKUGudUqzRleWTnTeNdzOdSJp/y5pXxyzP/aoWVNCkVEmbytmTLwrGmI3eOLIGmYAPJBGwXi+P+IjR5yr9w8LpFecV3a5a8PZ/4k5joTntxusAVHwf5Vf6ITKDWcY7S9E676qJNfmp4/RlWCAedsiKiFh+6Q2zzlUChgvZcC22QWskDPzw57hhhKxDz5QOM+SR9pT8PaOYktsoZ/vNtveUuHYWoYCAsGGJmwemcwqrttb+O0n04r9rhR5fhH7u5ws5aTHD4XJy4Vb3+00f4x81ycnuDIcEf0QEJTu5deowNjk6Ch2eeCdEYcBr90rNyJCxMYO3PT9N3zy6Rqud+sHH5zqGJ52VEg+PS1rgNbog==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SeSdWjBFJ27dlumVMoV0v7+rw6zYOUPhsun9SwFRJzgPmoGUfMC10rm8+6ZVrLNKOKXTl+LD/F5hw8V6mYJZ80bzJfVq/29lZ5GIrcdNArGKEJvlA3EoCVv9PhtdJhonIY6L07Tiq7p6UMFD+ZQPtXgPibJCCIbAbjesvi74+l2QP5ywMCeQKeMwfzCSVdsxu3oXRrZZB1MU75Tk3ZHTL2DRsOxKmMzI4htplviu7nm/3uTf9+TnqvSmjin/BluH/33ZxW1USj2SshYiDVWj+qfjIgIKtheug4bUeaCJUGlZ1Uqv6Bp/Sk4L2IiJnGEfNqcJFnAiUoVR06LABVsu7HdWZeR/TkbbSl5MyLZtZaGHyC3FLo7+jmdJjrzbrK17+sueJv80y/TAov0b96mowsaPUxv97TeIhJhjY6cQmedTqTK8Q+qBp3U+ekW0nIU5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 06:08:39.4474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df06ce0a-1893-4d6b-0b0b-08dea67eec62
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR12MB999135
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 253B140007
X-Rspam-User: 
X-Stat-Signature: cboot5yqhqxigwie4emyy84qnipqn3tk
X-HE-Tag: 1777529326-974662
X-HE-Meta: U2FsdGVkX1/ES/PZ1+ADTdQ9eJLYtJJb/Ezie+j4FEKwMl9Kdag2r507RXNiXZbYSdICHI4johh+KAN3muA/jvIFPdfostbZdwQIULVNpk1zAZr4WUJGMAfGvuGjo/Kc5e0ljLAjHFlT06keb1q0djyZD0iuT3zs0/c2jx79fpL+D14ApiZuL24rvRQnPRf8N29hpM13uoZ8sJL6HQe2tMdcGizP2ALVFcLn+z2YX1EHH4u8AsLBZxjCLmoI7wWo/Ag8h0qvwvhKqJrj48iwwcJyT0plxrW4IbGGZ5JnyxduV5hfRjX2USuxwSJRaviMcmeLc012IpJxTpK02JKNhcCsvCGRDcRoMqoyZJ/abBrmqSQO6vjFFdwJeOS1mugpSB3TcBZBed9vUCbCR+yOB/1eRBAl/JCJWivUl8JFtEo+4yPVL1RqMvHjhIEZWVAsJ04SI7xOTrIrXktiNj8cV1IL/P53KUqPCIyIfiHxqa1GMvusWxy8ZsUAP53DsKHpC2SpK8Q86zBQ3KITzxFDBf+iVLKIEUMuLGzKX2Ek9Y6yhRYGSeo5Dau7cQhcyo7w4VWLYUkQfd5d52E8bRbKKEJ8EM5KfpalSz28yGnLOeobeSATKxT5o+3aYS/HYRi39CnQboqMpY6lmrZZGqDlyQ8zzPU1B2IgkbpMhmR9AlSv9RdD22Dr3Uaj/8vW/qHbceNW8tOClCRh13kA67DouR93BAhwvD8oStzQ8XhKIWY7zn06Y+UPr1PYvzDDSIvZ7gjHQb4EX6N9Bo+0DIldUmdO6ooUpkLTTDI0hzovxoH3tdrXKBTeLSVuEoxBGKo6gcVbdUhMkMGu8lqS+8hjYf/+Ie2A8iweFIY3c7pYzDCBCpTfSOpERhYSpINnt5VNwCq9vsLihLGo8X0IK9Sk1t2nh64UEyKsgY0if2W0xeX+gSXwuVsLSFwQsLcsI+sDypNB1vtQxsCJk43/vpi
 lO0hqrZ+
 YVTCyePauzwxEeQwT11hDre540TsSJI/EqzadJSFpd5qBQQK3StLPpt+bvvVyFzYgOcdhUUTiQpcihqfg4qMGhoXSD55wc6Zbv62tX1PS2xNzjXRYqkPdyRkNCf8A2JHdCWBVv/aL3Nfw7xftRyG6OFjsJ+FmTGjLFjg4oIHGYAbtF7/rglmEsCEhRz+OWT74F1sMU8WwKXeaKFk/qinJvtjb9NOqe7rTFC3fNOAC7IZXvbj6XBWYIcqYQtyZSKu7KtTExGcAqgJfsUzzl+eqoW1JlVG1a4o4qnXdN+BqlCAewCYMt40I7QUa8g8b3ZNOQJcTWPtcpKvjPizoPgLmAkSkccmCdwsG2ZygqPicPCw8T8a11UzfbULI9mDhClERh0Pk+WkBVaDSafukjvJRI1PyVACK+R3vFUz0WYgYBZ85l5cvfv9JB41CF0SL0wkDBLOEIjPzV+5CjKtQQxog1OoS2MSj58dI2vfu6QSedAIuJj+BNOqCCgK8PC8T7lvPJwlcukm7qAhxzuzM6cKr+ZW2X1n/oGeYGVLytQPTbh2CWKcDQFHI901hfBFljhGrm7fAKbwebe4K1+LsEHn0Io60EodLRBMuf6MmCUEXpmFpqjeD7wBaa6EO5qlhmnvDLFff
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 28-04-2026 14:01, Ankur Arora wrote:
> David Hildenbrand (Arm) <david@kernel.org> writes:
>
>> On 4/28/26 05:55, Salunke, Hrushikesh wrote:
>>> On 24-04-2026 14:22, David Hildenbrand (Arm) wrote:
>>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>>
>>>>
>>>> On 4/24/26 10:42, Salunke, Hrushikesh wrote:
>>>>> Hi Andrew,
>>>>>
>>>>> The idea was to keep it alongside clear_highpage_kasan_tagged() as its
>>>>> batch counterpart, but currently it is only used by page_alloc.c.
>>>> Right.
>>>>
>>>> Looking at init_vmalloc_pages(), I wonder if it could also benefit from batching
>>>> if we find that pages are actually contiguous.
>>>>
>>>> That would require looking up multiple pages at once. vmalloc_to_pages() or sth
>>>> like that. Surely, doing such an optimized page table walk could be beneficial
>>>> by itself.
>>> Interesting idea. For the general case where we only have struct page
>>> pointers, we'd need physical contiguity detection and a batched page
>>> table walk as you described. But looking at init_vmalloc_pages()
>>> specifically, it already has the vmalloc virtual address which is
>>> contiguous, so can we just do following and potentially skip the
>>> vmalloc_to_page() walk entirely:
>>>
>>> clear_pages(kasan_reset_tag((void *)start), size >> PAGE_SHIFT);
>>>
>>> What do you think? would this simpler approach work
>>> , or am I missing something?
>> Good question. :)
>>
>> That way you'd be operating on the vmalloc address range, not on the direct map.
> From my testing (including when using userspace VA) most of the speedup
> was from CPU prefetch. Which we should get when working with the
> vmalloc address range. Assuming it is writable and stable.
>
>> Is the vmalloc address range guaranteed to be writable at that point?

Hi David, Ankur

Yes. init_vmalloc_pages() is only reachable from
__kasan_unpoison_vmalloc() in hw_tags.c, and the only caller that
passes KASAN_VMALLOC_INIT is __vmalloc_node_range_noprof() in 
vmalloc.c. The pages are mapped by the time init_vmalloc_pages()
runs, so the vmalloc range is writable at that point.

> What happens if we get preempted and migrated while clearing? Seems like
> the vmalloc lazy syncing should be able to handle that?

Good point. I haven't looked into the vmalloc lazy syncing behavior
in this context yet. I'll need to look into that to make sure there are
no surprises with pre-emption and migration during clearing. Will
follow up on this.

Regards,
Hrushikesh.

>

