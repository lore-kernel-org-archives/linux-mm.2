Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8F7D262BF
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E53C6B018B; Thu, 22 Jan 2026 07:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AF36B018E; Thu, 22 Jan 2026 07:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695B96B0190; Thu, 22 Jan 2026 07:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48E1B6B018B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:51:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12774B7D6E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:51:03 +0000 (UTC)
X-FDA: 84359584806.28.240711F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D157140003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iCs7y8eZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IowBbxow;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXqUcP/kbNPK9GH0qkhSuzF9fSNu5zWTlel92eo+7XI=;
	b=zBJ+NdZlXBBe5gmnMlLHMlGAZtG9T0R3nAGKmYlY84EVgxZ2DOu+S0HuoJ7tUq1PtDSKeu
	+ZFW4mI2/+gCbsSlGKI0Lp6HJT2ZlWGrkXPHmkSBPnqzD+dq9XH0sHBpmfUWbh28H1T5Xf
	2tgyI3w6SaCIq0bKeIZPBKh0XeQsKU0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iCs7y8eZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IowBbxow;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086259; a=rsa-sha256;
	cv=pass;
	b=bZhx+KnAsxsmATMSTH7f1SqnuzQ63Nle1jJuDtxPfCyFKhoNbTTCKUhvMBLzjpQQ8/BxsM
	fHrblrSRJ+rg7nwFZ2DPtliWGqaMDEBd30rI7SzTq89wROnof4n/p/n+mERviYoUquWH1L
	7sTGICJNT6sg7u2Eg7yCF8/61/IyQpo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LMa2x93869559;
	Thu, 22 Jan 2026 12:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hXqUcP/kbNPK9GH0qkhSuzF9fSNu5zWTlel92eo+7XI=; b=
	iCs7y8eZYJsQORpWcUfzQytEqvcfUzPKqxlpmH4mQMOG3sOjxve4aTRvVTES6qHc
	7mqFiTVd9ISa8xZi/wP0gcdHrL0/fQIOOoSKPOTN54cuGPaEuDQgXfHJlrWbXVIj
	cKxKF3bkzrvfXFhIenkQBwcLl5ITJKXeaT1b/f6jwUKmPgLzt0xMO27pFsCq1gul
	tq+s5aemN2ZplL5vPpPjOIGUl2e+CzTqLrzsayTeN2GnrxeaX8OKdabUg8oi5Xjd
	gQvW9129xLa3cAuilwHkYfSJXa02CHQ9AB1duV9s242dZauXUZj4m8l0Q668Fycb
	ekLzksH8N6SDOMgZzFt4Aw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd469r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MBt33S032828;
	Thu, 22 Jan 2026 12:50:49 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010065.outbound.protection.outlook.com [52.101.46.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgk1n2-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oIY1Mtl9vopbMstoF3WldW2kVUSC0WrYAFsw2Yvr4RsrPhz0bp01/6My1FJgAoL4h0MpfSl2F82dEVMFGtHJ9wQuAEScqzkkqesSFNZOqZpTGJHa6l0h5HEPWlAdZwpLX9IFBm0ISWHmjoyPdLXy8d3LX9RLR/KonDsXCufMjY6Q20sU7N5Ghv6l9nao3xew/oTLVPz5IXwVWMJ0uHxfJCtco3akhYYglxCnVKqxZ6fsA0NhMapHbFikwLQ6nU47nFqzrEqbIqnxpTU6ksJYNIKhgLNQhZMkPcUAuiROgNMo1xnWpTuwK+2CnPi4J4CJK5+by4yVRhcBypoY+wa4bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXqUcP/kbNPK9GH0qkhSuzF9fSNu5zWTlel92eo+7XI=;
 b=Bkz59BjLFcmC8P/RLvYi0Id3/EOj5A15LBurczD4CCU4hnXySmRXCp3y0eossR5yX0UE/EM9lkUyYUsVeknQcCEPNGwSYkbPctjzIfx+bRmJ7bnDg7VoPi1NL9ZzKU42NbCPLVt3fFyo5XHGgv2mqOhJ0U2fJj3TQ3IVILG4l+V4wJpNf7XyZ8W2Lb2Po3k/ePqwdt957ELlacWC4H/b5dO/yu0X4tlT++x2xfP7fcIyhOOfcs1P1sLx/6xh+FNo83n5wMFagogatWw1pNmSZXzE1gldJyh228ecqPiCcoD+p15zSwM+fSbfKtw46TRjGwOus/qnYXSvM3RSZxs3Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXqUcP/kbNPK9GH0qkhSuzF9fSNu5zWTlel92eo+7XI=;
 b=IowBbxowrkKbBM+6KkmklGaQki286CHfMcfFdzen9n2LyDS6j0lR4G5Kq68kRwYHXD3va5LNsAsjp6sWyk0ZsE0uZ5OxoAiOwG07R1CiEyhS4xYhEkT/yf6DhS1uVH1E0tlZ6Ivw7J7gaOgtyrs7SKrgJJSOcKqJKgtaKJknCp4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB7904.namprd10.prod.outlook.com (2603:10b6:8:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 12:50:44 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 7/8] mm/vma: introduce helper struct + thread through exclusive lock fns
Date: Thu, 22 Jan 2026 12:50:27 +0000
Message-ID: <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769085814.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0419.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::23) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e176be4-5e71-4d8f-c78c-08de59b4db72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wbW1QE2dSxIDRnBIr+UPEAlzeREEFILcfbNhm4IRJTThYH3xcRvcfC913kuD?=
 =?us-ascii?Q?J+5RWogDd9FsT+2RZHERV54kAgC+5pYVmx9WaKvRy5L0B9Wrs3uzXxutgPaP?=
 =?us-ascii?Q?xuDCwNDzkbWxAPJLIqvxOjGIFFxziz0A2NsndtW1n2+Z3qO+Y0v381syIrML?=
 =?us-ascii?Q?67ZNa2ALPYLOdtX2dLQFWqNH5AOf7X/ILbR2Ie4W5GqmWiSfLvwGgqSjPJeT?=
 =?us-ascii?Q?aeVl43l8SwAMfap5AoMdlN8HfCOLnyPcKHhCHFtajxvvp9Ue3OEWkd8IfNYU?=
 =?us-ascii?Q?42VVTfRC53cqmqZUxQ3nc4Xjbx7GOUi6REXYVpRPMD0FpvVguTTu5PEi58Yx?=
 =?us-ascii?Q?oOVSeQLmWdFphi6Dzn/lgcAS8GTilStJ0eVTmxr/mHLmvDiZJFinrOAOt2pZ?=
 =?us-ascii?Q?ore0c6ewOqS7zTA9ArHD+MnkbVq1fZ/1QZJ1QcdYUgGM1ZMv7DbFqYx7bk8O?=
 =?us-ascii?Q?Zb0Kr7X+caKMxUuRF3rW4GW4F6Wv4zaxfFIJV37WvXi0LUWx2B44CpRB7S85?=
 =?us-ascii?Q?PNUzKvA6QkNuBY/7EU2sfJFSI4FWo1Bi9+hBPdsF5Lwe8cwAzGXQS5rxH0io?=
 =?us-ascii?Q?jUUIIg+YO0NAq7rIywkY527NPxUU9LFmLWo/KuSXqOHcHBpIwmy/cV/Dno0o?=
 =?us-ascii?Q?L+H8nrkJ+xchODAxbDQhVaGWkRnTC2aZJh1D7usDlMEwcfYekeJC5tJkLq1A?=
 =?us-ascii?Q?kgNXl/Eoj4sfFWiZjN5VsCSymSBBQXlDp5mnDoty+q+QNSCjWfSuinebZ+3K?=
 =?us-ascii?Q?zBCx32OdbbE7Wn7EMEMl7qnxTPvaGqf9xapiYZv9StvmHjHOGASmUDXSVl9d?=
 =?us-ascii?Q?jhZDWH7AY0peSi9OHBnWqBWDT4mTz5tbluW0FtHUuXr5DTk6aQluhIWXhIen?=
 =?us-ascii?Q?dXfdyS7AxW2C8Y9SewB+sloBesR3vQpxiajFSGciBJhuDEcihbleRFLpPhpE?=
 =?us-ascii?Q?u/8/Vx3c0gw9FruPRYnRPQbf5mo4IqAO1yfuC9qMqp5qG684v4/qGE6yhWDe?=
 =?us-ascii?Q?aQZ8fRQUmD2YFm785WJhpKHpDr/I8HmgvNPkryfqs/6T1A+zmfULy492sa8T?=
 =?us-ascii?Q?CB6RXX6ZA280nhnKzUvjRGw2+8waNnEuAlRsyevT1V6MWVwtLD/8Ub/1P0Sb?=
 =?us-ascii?Q?9pQUgJQvcZadMlRlAe+ExlXibMCxxwSSEd9kuquSn6mTO1U+6Bm+vfQL3en/?=
 =?us-ascii?Q?KATMh9C+A9yg1kG76nnzMzhY9K1lT6D3Hlam5SsniL00vJnRrtk1edQVGA7w?=
 =?us-ascii?Q?DjS/z++O/yZCRjpZZFf82oZQtra1rzJfOitrt/brpS0cGmkEBMWlrrxw1QbP?=
 =?us-ascii?Q?aQH8HABq/wnZki8cqE69EVM8UFUi12X0k442P8loxc45gJLXfD+yVhHD5w5S?=
 =?us-ascii?Q?bGRvJoHTTXTz1Fu0hb+wmJYZduC34AlaGMVlYhy/JgZiV6HvHea82CveGzA5?=
 =?us-ascii?Q?7IMVDltjG/Ue6Rxz5UKwSjW9JV9QTAWTIVOlyZ4w2VTdhxJu7UwxU5wUqEQO?=
 =?us-ascii?Q?5tn+SoaUnAGRvvo05ovfyATGgOIsyT76DbhnlXAXe0LlYVkmNzk+28AZNv2+?=
 =?us-ascii?Q?ybonKmqM/G+ENHRdJfI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A2Q69ciH2JivXGlGZRfKL6YhEiDn+wbQOw+VlxVF/uBVyPT1yUP7yeHzRF/S?=
 =?us-ascii?Q?2iarXejI0XqPw0RhbF3cN+0YOU+TDXsTDMdBTsEbja+hZpmsl958BHkPhNHk?=
 =?us-ascii?Q?C+U/95oRznIR3FvuDI4/SVfTL1ff375apr80XWa+U/ZL+aizGcbCBr4y4Xyd?=
 =?us-ascii?Q?67isGQ+FHkfZxliYyw3tI5/pl3ZyuGTl4DN8uDf2dDcFtLvHoWlYnlweIchN?=
 =?us-ascii?Q?u5musCM1IMIrRTlrQclM7nwLYqVl2h/h53SvJ/lA6ywR/XpxgcpX1UvefV1/?=
 =?us-ascii?Q?SJDsYeAJb4tdisSs4pO5p5qx462dYDQ8PPEi+zDUOpu5aBnmKgTBad161G7a?=
 =?us-ascii?Q?XxP4efpz8GCUX31LR4J7EJA7pY5UAJRpJo5ff9UGiM2fIx9OZIfYx9+8Geja?=
 =?us-ascii?Q?JCWLshiVpRH8l9Z8NMfBaaNf+eVGY0qVnqhnYGybPFC9cVAMpluDLrAkHXDg?=
 =?us-ascii?Q?ZpIvI2jcgDQKNvlVwWDTFCMSD1msodOjX8+akM+tvDtUI8mgzuFHlvkWTVdI?=
 =?us-ascii?Q?oyc0SwWs0WeIlkUTFbwWj0rsMZWUyeC/Srz1UQshVoXMfEIknwSz3l7KrkGM?=
 =?us-ascii?Q?zs9TX2iki41pxTO8oT0xq4arYhZ4vDXmGbvYhgNlauC1aSR6wry/K5Y9qflS?=
 =?us-ascii?Q?Qkg/J+zh7Gay0aGkuYXbPeH/h5wkiiwc3gn7E2LhHfbdQ3dnQ2OpxURN6d+L?=
 =?us-ascii?Q?39maIHQo01aAV+mA8hNyKYJlSUeWT/ma4xDloOAYvCRj2s/MkjiB8bkZJwEa?=
 =?us-ascii?Q?eJNieMO9OOrV8DOv4ai+1bBKzDOnnL9zSvlJXPnovcXMt0J4WlxyAKXkw0J/?=
 =?us-ascii?Q?jO/s6H9jD12ctWNUQGSq8U2+UAq8r6cXJBJjEU2ftNDUaoo8fT7xqaU+cpMJ?=
 =?us-ascii?Q?bbPb02txs5CeYLvx0XdsGU1MKRKnGCPS/MEwbXYv7svBd4z9IWnVDqCoik/q?=
 =?us-ascii?Q?DGtgYHu14SQosw3QV3/nwRFrSR91HEBhD+RFC2esNLkbb1eskvV7zQfV3HX9?=
 =?us-ascii?Q?gpBLQixfyr7a9OmHtfYJkTT5EOhZBFw83ELheqg70cabGXkAh2Ffm9d2yTQW?=
 =?us-ascii?Q?GSCpljk4mIGC/0/kcDw/nJqxlaXRN8tFtU9sipYxBl2KUXAjQvlZ46i8d4vk?=
 =?us-ascii?Q?5XRmw381Ai9a4TvSQq7vYhKntTRGV3je+wSm0vtWOZaC2NQK444YZaO8VIvP?=
 =?us-ascii?Q?nrGoPgt3L2ItCO1dgWopGdnE3FPUvwbxhaVIlgBq2i2LlZnSUElomEgP3at7?=
 =?us-ascii?Q?TQbvl6dWLt8DE2IdCjOl/o7qk/I5ye7ILiXqTiWr02diwZRoygdvcR4c4G97?=
 =?us-ascii?Q?Gc445ViBNdo5ACrHKQMWLfEjc54VefVBQsd5W+AbOOfv6hUcrDJTHm7iTIdc?=
 =?us-ascii?Q?SYsRgfS5B6k13FEjq8y4K16rOwPAHAt7WAHOqox5Kx3d9pFLO8t/8P5HZ5OY?=
 =?us-ascii?Q?gwT1Pm6TGp3+QQItHmZpac1vG34ARWwNx1t/SzSF/UfLXF913t4rSEutP3Gn?=
 =?us-ascii?Q?t3PU1MSp08mFKl3MMxhR0o/4CSLtuTrQ7Rc11MrqGyUrzRiHF/Fv3hagZGii?=
 =?us-ascii?Q?ZuA4c/j9WGwzfmLVIHrGKNmf4opREe2X1gZXberNXRCj17j1B1EjKXt5Ju19?=
 =?us-ascii?Q?N9/hkzQFYDvH6xZ8cgLRe+Yf/bQWyzqVjfh6CwbwGzDHW6PdtG6pl2z6O3KO?=
 =?us-ascii?Q?KW7kk6Btuir0RrkFpnkgc3tvlFmZP72nrRrZKciy55Pj6OmxjKzEgJuU1vf0?=
 =?us-ascii?Q?MvGL1ptjo4+8uceMzfTSYhQG5+mIofc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ia/xrllbMas5tDSHJJiWMFYnQ8dTUXIBzf+h4v99+DbTEBP+5asUhnENdC8AbnLwUraUzMC/FKzs3UpyufyLG+e9M85ZM079VJnJEyabmwgsLJ+cc0nSYOK+rFqAtaLmck9sZ67EhwcuKHCwAcHpc+KzQKmbM1rVJ4IWzO7N35qp0i/U2ZCq4Cm5cv24cBunhlwBiUrT7YTwWoefEaQbbxed46HnRammWRFPZQx61njGKI48buKAPvZSiVodSkKeBZbRjbHOGQ3hs28ccOZVSRnoCG1N47J1pEs/hrE2S/OEvqjdZ7FSV1pUOpetILS53PenLrhIJWAVn9zas7/H0yw579/uBHl7jKgBOQd/mwoq9BSOsKEDwedm0kzyn0hORXj/0QXy3OaLyX81xza84B8UyUXRICKM/aT//DxSiaCnv5bWK0LgpQp5GyA5UVZtCMcM3KtL5Z1Wr85WyIxsm+rZ7Bwp6uR1zRN1M1ME0t7vi8fdicKSp1jloKenWs5GfG5sFcune5mT6M5e/yJjlZFy95KBL6ZyHzNaySJ2/P0o2Pee/fBys3hh2C91kU4BKa+2cDCKfi5g3FnhWOgyh0RfhiasK/jRTgeGUhyNZ6A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e176be4-5e71-4d8f-c78c-08de59b4db72
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:44.5810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q2Cf8yitRinCMoqjQp0UL3ZDjqTEEgGRlDwzQi94WvSxYOzgPv2PtsDqQYU4hDzpXXQAKz+qg9d8FJNubnqXkvaAN8pamO0DlOiEhwoEOmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=69721d2a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=YKwRDwjWlvvmDIdOP-wA:9 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: jrBe2EfNLnccOGNwdBw3Az3atKx8g1Vu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX7ik2NrvIeqMZ
 4sTnEucthZVEQe5o3lR8F1LNThUiENXnxXzK7OEK3cuDRFGv1js5KPq0oCuXuTN7bpGKrOIZzJm
 S/X+sH+Gu97gaJtBUtK5o41hj2MCDDGf4ZlQfyIVeYN4qrN0t2VfgZ2n/tvk4C3yHeXu2KGShd7
 BJA/fY5mOc8hXjEhPVnCKhHGv5Ze8b7oj0fWmC4SQWGVSWlqLcv/humNKGW8vGmz11TBnnxJwou
 LOLUF9oilKvMw+u8qjfVNB8zFJkSgs0BRR2iXGO13N94EPHPOLCVsNPXOMIwa6SHhM5RM8ovg6a
 R3+ywAqD/Pi7ikWZk8W01PxRaAr24e90eOoW4yVBXOrqK/8higrufZgDDf6F3tkhjsoR5tgiBu2
 b/UP/2oKb37ie7b5Mp2B+LO4mQ33K8uwTwm8IkISNPHKhYjGobltFXCT1Wa3pZIIyR91kvcK1rC
 tI3BW70CEJkMu8KMup62YRh2oAITieT2T9XVvqTo=
X-Proofpoint-GUID: jrBe2EfNLnccOGNwdBw3Az3atKx8g1Vu
X-Rspamd-Server: rspam12
X-Stat-Signature: ndn1k97n7tkn3crsxdgsbwz4jtsc1kiu
X-Rspamd-Queue-Id: 9D157140003
X-Rspam-User: 
X-HE-Tag: 1769086259-957308
X-HE-Meta: U2FsdGVkX19JmTPbxRCf48HYxMQjAyJudO+jj9yRGSvgIxfqjCpqIVzK+s7dmOjdEtWrJZ2MYrfS56LJxNSnpzfqgsJddarhPI6ng6vpGSHkyFPafoj5wEKmX/CIOTSNGS9AJZkbsN7R5qSZrYNuXYyXG0RHIn0vT0mi0NOfUvL6Vy8mmp2zu985rwHxBDYlxEHpqnDI+egHMLOR9Gb2ADvgs/OCn8wgVvILefp/vAP9ZmXUanPgUADCJwxfQvjVyCCdsJSpHTjuentZ5VIf+QybtoqfgFBCyMkxNb6qPynJV0RUJGpqa2Jwi9dR6aVP62SPa545lL1C7rpffgUtJqz3SAfPVAxbmmmNRJrP737y+WeZxK6r4QLniwsZgVmTVJKuymxP8IGdtHmmOPRB6+UiK5Xo26B3ASF10jhWa9gbO+SPQE9weqFEiv9QvK26DNysfH5nCLXdPpSAGxIeVqg8grJ0abzGs8gSdvC/fHtsdMGfXfGtp3uuEZypovKEJ31JTaarQGfc3bAeOkiS+/t9nEFLdaSadb5wQVqPUyLMJKxBJIWiUEtuFfXSBK/b6XpKa+k8vRxlj4tsznzxfWgIvmyE57KgTm0iUzWFTTFbA+qVOs+VIgE6HDzbIaT1Xngzk9UDONRd1k0cLCmcSX0unpFeImiCaMqtfk6b+pgdMZ+sWx/rBWLjhZ6hzeCilfHFT1QSSGXqQDfvrBmKtAhJFmnZ+Mh9yt4h3pHeJ3o5OdcxiI4LnffmxIFvY7IUUgkUUClr+75p08eQxWxUtEyLYCVhcP1qkq2iGOmzrfiNotiSpWDgjNqOxcCw0SoktJJ0QEFZfNH09Xm8529cnwhLIZkrszhntsngvJYAkilbPPBD0uKOtVGquyEJyVL5NT19hk7BT1a8SUBLHk4LLZtZBLxm+C9eCXVA90DY62ojty3uo6VkAr53bfYJBFUFsRAunipjw5k6egCJz86
 ecRTymFH
 Z9szZOpfwzFa/O1ZWabiguPCsszlUiWXszviOC/p1OrBMGg4i7MDHZV5qLZSLSrTYj2YOfbvnq1ox2S7ACF2/jBpiLEJ4/JUBgYS7omvikuV9Q3fkxQVM31oj1yAKxCGR4GzfxGL/7wbtF4Ql3j25TqpdKz1N4/SnS19qItdxFUJLkpoi5rcrV8PbSP0N+ByNbLdS6ZFNKMkLLH7vHroNGPG5rUDtVljz5MXTblN65I2Nv0OAjiWj1nMtDJ9TRlMTKTbxezk5qhK7kdZKWa4Q/EHnYAv8/66b2+jXwbZlIlrD3xQcLfNwUwgD6B3BrBV1F4MI60jaiknvrc9idhg8JpWQx5J1/kfTuKOSvPV7tESdHwm7sGm3MihQmKUHnCcotbdG0eM6LuPQ2r+kuHxIEVLZICDVLw/21jEj/fxKY8EXO3eUgcY3kqWtwaiChnSivyTcVfoqnY58ynJH98zWtgffy+2QMJIC6KbxleF5a1SIHmRGX3Q/MvwnMoMtgOHFtHpLL2JKVGCNw4GL322Q3segxjzLbVrApmf8RNNHcPm1jBnGO1PBZRPHxUk/5mv0LYqrAlxU3qbRf0pVY9Hmfcp5IdPgwGHziXvduON7nIvysHEpUsPVkU7mTQupWZtKhiSuMqb6P/1zgSbCS2DV+yycDAIvYTIcMq0Xoux3uG9xKH3W6DkIzXv7e6RxrCYb7GQe+aNPcUdc/aOx9eoypLUWuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an
error (but only when waiting for readers in TASK_KILLABLE state), and
having the return value be stored in a stack variable called 'locked' is
further confusion.

More generally, we are doing a lock of rather finnicky things during the
acquisition of a state in which readers are excluded and moving out of this
state, including tracking whether we are detached or not or whether an
error occurred.

We are implementing logic in __vma_enter_exclusive_locked() that
effectively acts as if 'if one caller calls us do X, if another then do Y',
which is very confusing from a control flow perspective.

Introducing the shared helper object state helps us avoid this, as we can
now handle the 'an error arose but we're detached' condition correctly in
both callers - a warning if not detaching, and treating the situation as if
no error arose in the case of a VMA detaching.

This also acts to help document what's going on and allows us to add some
more logical debug asserts.

Also update vma_mark_detached() to add a guard clause for the likely
'already detached' state (given we hold the mmap write lock), and add a
comment about ephemeral VMA read lock reference count increments to clarify
why we are entering/exiting an exclusive locked state here.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/mmap_lock.c | 144 +++++++++++++++++++++++++++++++------------------
 1 file changed, 91 insertions(+), 53 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index f73221174a8b..75166a43ffa4 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -46,20 +46,40 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 
+/* State shared across __vma_[enter, exit]_exclusive_locked(). */
+struct vma_exclude_readers_state {
+	/* Input parameters. */
+	struct vm_area_struct *vma;
+	int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
+	bool detaching;
+
+	bool detached;
+	bool exclusive; /* Are we exclusively locked? */
+};
+
 /*
  * Now that all readers have been evicted, mark the VMA as being out of the
  * 'exclude readers' state.
  *
  * Returns true if the VMA is now detached, otherwise false.
  */
-static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
+static void __vma_exit_exclusive_locked(struct vma_exclude_readers_state *ves)
 {
-	bool detached;
+	struct vm_area_struct *vma = ves->vma;
+
+	VM_WARN_ON_ONCE(ves->detached);
+	VM_WARN_ON_ONCE(!ves->exclusive);
 
-	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					 &vma->vm_refcnt);
+	ves->detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					      &vma->vm_refcnt);
 	__vma_lockdep_release_exclusive(vma);
-	return detached;
+}
+
+static unsigned int get_target_refcnt(struct vma_exclude_readers_state *ves)
+{
+	const unsigned int tgt = ves->detaching ? 0 : 1;
+
+	return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
 }
 
 /*
@@ -69,30 +89,31 @@ static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
  * Note that this function pairs with vma_refcount_put() which will wake up this
  * thread when it detects that the last reader has released its lock.
  *
- * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
- * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
- * is permitted to kill it.
+ * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases
+ * where we wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal
+ * signal is permitted to kill it.
  *
- * The function will return 0 immediately if the VMA is detached, and 1 once the
- * VMA has evicted all readers, leaving the VMA exclusively locked.
+ * The function sets the ves->locked parameter to true if an exclusive lock was
+ * acquired, or false if the VMA was detached or an error arose on wait.
  *
- * If the function returns 1, the caller is required to invoke
- * __vma_exit_exclusive_locked() once the exclusive state is no longer required.
+ * If the function indicates an exclusive lock was acquired via ves->exclusive
+ * (or equivalently, returning 0 with !ves->detached), the caller is required to
+ * invoke __vma_exit_exclusive_locked() once the exclusive state is no longer
+ * required.
  *
- * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
- * may also return -EINTR to indicate a fatal signal was received while waiting.
+ * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, the
+ * function may also return -EINTR to indicate a fatal signal was received while
+ * waiting.
  */
-static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
-		bool detaching, int state)
+static int __vma_enter_exclusive_locked(struct vma_exclude_readers_state *ves)
 {
-	int err;
-	unsigned int tgt_refcnt = VM_REFCNT_EXCLUDE_READERS_FLAG;
+	struct vm_area_struct *vma = ves->vma;
+	unsigned int tgt_refcnt = get_target_refcnt(ves);
+	int err = 0;
 
 	mmap_assert_write_locked(vma->vm_mm);
-
-	/* Additional refcnt if the vma is attached. */
-	if (!detaching)
-		tgt_refcnt++;
+	VM_WARN_ON_ONCE(ves->detached);
+	VM_WARN_ON_ONCE(ves->exclusive);
 
 	/*
 	 * If vma is detached then only vma_mark_attached() can raise the
@@ -101,37 +122,39 @@ static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
+	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
+		ves->detached = true;
 		return 0;
+	}
 
 	__vma_lockdep_acquire_exclusive(vma);
 	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
-		   state);
+		   ves->state);
 	if (err) {
-		if (__vma_exit_exclusive_locked(vma)) {
-			/*
-			 * The wait failed, but the last reader went away
-			 * as well. Tell the caller the VMA is detached.
-			 */
-			WARN_ON_ONCE(!detaching);
-			err = 0;
-		}
+		__vma_exit_exclusive_locked(ves);
 		return err;
 	}
-	__vma_lockdep_stat_mark_acquired(vma);
 
-	return 1;
+	__vma_lockdep_stat_mark_acquired(vma);
+	ves->exclusive = true;
+	return 0;
 }
 
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 		int state)
 {
-	int locked;
+	int err;
+	struct vma_exclude_readers_state ves = {
+		.vma = vma,
+		.state = state,
+	};
 
-	locked = __vma_enter_exclusive_locked(vma, false, state);
-	if (locked < 0)
-		return locked;
+	err = __vma_enter_exclusive_locked(&ves);
+	if (err) {
+		WARN_ON_ONCE(ves.detached);
+		return err;
+	}
 
 	/*
 	 * We should use WRITE_ONCE() here because we can have concurrent reads
@@ -141,9 +164,11 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 	 */
 	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
 
-	/* vma should remain attached. */
-	if (locked)
-		WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
+	if (!ves.detached) {
+		__vma_exit_exclusive_locked(&ves);
+		/* VMA should remain attached. */
+		WARN_ON_ONCE(ves.detached);
+	}
 
 	return 0;
 }
@@ -151,7 +176,12 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
 
 void vma_mark_detached(struct vm_area_struct *vma)
 {
-	bool detached;
+	struct vma_exclude_readers_state ves = {
+		.vma = vma,
+		.state = TASK_UNINTERRUPTIBLE,
+		.detaching = true,
+	};
+	int err;
 
 	vma_assert_write_locked(vma);
 	vma_assert_attached(vma);
@@ -160,18 +190,26 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	detached = __vma_refcount_put(vma, NULL);
-	if (unlikely(!detached)) {
-		/* Wait until vma is detached with no readers. */
-		if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
-			/*
-			 * Once this is complete, no readers can increment the
-			 * reference count, and the VMA is marked detached.
-			 */
-			detached = __vma_exit_exclusive_locked(vma);
-			WARN_ON_ONCE(!detached);
-		}
+	if (likely(__vma_refcount_put(vma, NULL)))
+		return;
+
+	/*
+	 * Wait until the VMA is detached with no readers. Since we hold the VMA
+	 * write lock, the only read locks that might be present are those from
+	 * threads trying to acquire the read lock and incrementing the
+	 * reference count before realising the write lock is held and
+	 * decrementing it.
+	 */
+	err = __vma_enter_exclusive_locked(&ves);
+	if (!err && !ves.detached) {
+		/*
+		 * Once this is complete, no readers can increment the
+		 * reference count, and the VMA is marked detached.
+		 */
+		__vma_exit_exclusive_locked(&ves);
 	}
+	/* If an error arose but we were detached anyway, we don't care. */
+	WARN_ON_ONCE(!ves.detached);
 }
 
 /*
-- 
2.52.0


