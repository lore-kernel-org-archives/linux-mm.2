Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8902C5B55D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260E36B0088; Fri, 20 Feb 2026 14:23:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244B36B0089; Fri, 20 Feb 2026 14:23:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBB66B008A; Fri, 20 Feb 2026 14:23:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4C026B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:23:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A6D213A52A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:23:15 +0000 (UTC)
X-FDA: 84465808350.20.469C060
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id C4EBE40012
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:23:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZpCHsd9j;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UcjLbQES;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771615392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwZR/1CrefA2hSaWx3ugUsjyxNX2TfldQoRsBk7THyE=;
	b=t7pwXnZVfg055Lw3JZe+DaxwDJHIZmmewsfnu/Nbzlp0QXm1VcURXxt7sPPxfKYW+sqgFE
	8bLD+rnfYRzOfi6XoShfE+9LuV8wpGIgC0l6WDkEm/AFMVmysJcmNdmZYk4JGHRIz6m4MX
	0XEFtRwhhZa1vhr4dtjB4xXo6dkKnXk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771615392; a=rsa-sha256;
	cv=pass;
	b=EmvWwf/KyTqcEe84H9D82atNoJYbpHumU+hF41zd+2ysSef6SOUn/Fy4sEloYwiHMNNjNN
	3/P5eVne7TCOcGMYGvulWfWbTlKssEsNeWpQ/ixNpzZTh/OPYxY1ZRiHpJ0F2a8Mak0/LK
	3+9eLjDXenrSyburAl/l4KtPuvBGqgE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZpCHsd9j;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UcjLbQES;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61KDsrID967977;
	Fri, 20 Feb 2026 19:23:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wwZR/1CrefA2hSaWx3
	ugUsjyxNX2TfldQoRsBk7THyE=; b=ZpCHsd9j7oDjy4VMZS2tpuDRI+PPFMzz1d
	JE9oz+o/4UQ8a1ZmfMb3ZXBEnGxfbP7xw+KZ4XWk19HTrnMfjAwDJLdYEvyLtGhH
	qk5Yhsdviky0rs76H9DjbZ1wgcDN3ZNpilMw4oU4idxqgNBAtROw4lBpqDKSYqU6
	nH0ZNxhEH4JXPkSJZig91VZlqoK74cXvnrgLrnVGo6ilklcjtJMDxzww91LmgOgb
	ciTIjKIoK6MK133q0EsKUAaRwW5/z3ODIMPjBDjqD3rIVECrW+CbXtLgacshMrSw
	V1hzbzZB9rbpZyx64WYutZQhe7ZKaBpBOmTufKqdHr4xHOvytieA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0b1v0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 19:23:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61KJKeEM014959;
	Fri, 20 Feb 2026 19:23:02 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011000.outbound.protection.outlook.com [40.107.208.0])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb26dxya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 19:23:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jdtH8JPl7pYQYq4tJx1suongG6F76lDXSHqbYPdYjUejwVNhzHW7+mad4I/nHDhvPwdc4kNtu/m5khpWBvVf4N7RVvQe/Y0NefMAHw/a3AxITwi2PE8cGW4A9jjZFjrondezSekV3Bn+4EYY6wOTz94Bc0xwcvyTJ5CeWfKYnZY+klDyRZKspqJzKHxDCZu/oYY+a3qtaycR0GYi1JuOIRbIDvGVNxDFEELe8LJMYtZHD7vdZSFF10Is2pf74S7gy3/mLBQLPcuj3U5RVGNQbMiVbS9txm0WWjHvk4BD6CmyjOfCo7NHBFHBIKd+wIcIAayNga+dzEdjhNfMXh5u4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwZR/1CrefA2hSaWx3ugUsjyxNX2TfldQoRsBk7THyE=;
 b=RXH+QMLqRh3EtwTnLHjCnOBPfMMeaWRKYwhQh/aaDoY+nhQmCzjfXzQUQHg8tJMshWszZJx8Jc2w+hzvkWZx1/7Qe8toELP9Do1QqMAjAS2WnzCeuDQN/a0ddyzXYdOnJrAEwdzgSPUzb2GKPzrRsYbm5ztQFkoh6wfqzeF2G8xAnzTyc+Q/mU7gEhu7b+60ZtlqfZjgxN+4C9sRq8d/PsjBwFo7MYiseiKtCMmhS3jwiBv6Lfd3fr278KLkqJKvKcLb9wPrhIBxmF4CcxMBBBQNLMhBaf5YN6/mScL/wAE44cpMMuo5WU/qsIUjufXY4pyzyeVAL19PgaWljpThOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwZR/1CrefA2hSaWx3ugUsjyxNX2TfldQoRsBk7THyE=;
 b=UcjLbQES/RhQrvLvxuGXpk9oqkH5cJqyUsvmNURNToJHipp4JrNDuznE8OpF5H/04p+S2GGZoIauaJV7VVmeRoT18ygVhkFNaTzDXALft8rbKljuh4olXC7JTBEIN9Yi+maIcUyaoFJ4jMbqdPqKVRN1RD0fB/Pzpkwbyob2lvc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW5PR10MB5849.namprd10.prod.outlook.com (2603:10b6:303:191::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Fri, 20 Feb
 2026 19:22:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 19:22:28 +0000
Date: Fri, 20 Feb 2026 14:22:25 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>,
        Harry Yoo <harry.yoo@oracle.com>, Rik van Riel <riel@surriel.com>,
        Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [LSM/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
Message-ID: <iwmfmiswzs7wlubom4unvhed6kxjybdscf5onmgvlfpbf2uxlf@oetdllsyxviw>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Ryan Roberts <ryan.roberts@arm.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>, 
	Barry Song <baohua@kernel.org>
References: <8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local>
 <4qkgoulknoxxkefxyrpnugwmpwbwh324pnnpy6hg2tkdh7lbkc@2i3ep6aoh2g5>
 <76b8c24f-22a5-4af4-baea-087e0a2b0e70@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76b8c24f-22a5-4af4-baea-087e0a2b0e70@lucifer.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT3PR01CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW5PR10MB5849:EE_
X-MS-Office365-Filtering-Correlation-Id: 2098adcf-516b-4b52-862a-08de70b562be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aDNMa7Lc71GUMZ2fwcmrteXLL9HN+CUK8H+8hHmep3IxHHYBiubaBx6j6D3W?=
 =?us-ascii?Q?+R/6hwHcyZiOIlje5s9EMDuEYv2dnGL39t7+QCVj2yHfoMK1tQj7UFfx4a2F?=
 =?us-ascii?Q?GVhCxK5oq+EtfuNRCnl4ul2Z3U3kuFRQ+etg791SeMpkVkBCf7Xlr1ZgU0/y?=
 =?us-ascii?Q?erHZDgab7tkvHwHvMI+VZ6hqtt7W5YoYI9d0IVVtLOzlcz3MwdYsYS4426Q6?=
 =?us-ascii?Q?3Fo+VSyKyLVDUFJKx21E0WSUn9g7I0D8ta/dXE/7DW+I/+KOQvH8K/0ueIz5?=
 =?us-ascii?Q?/F2u8bmoLNB9rqI9n1KObsXIkHUS/AaRYe3eRr3JkuM0FGCxOFcplmDN9aPP?=
 =?us-ascii?Q?EG1LxG7g7aijPxHGBRW9qecTwBWq/8arkoQmqc2GNTARNoPqNg2/90XhJC64?=
 =?us-ascii?Q?Fj8PAzx5SIh0bLfaBcwemBhZdPqBxqaIorY8xMYbsU1p41dqAGuVu2cImb+s?=
 =?us-ascii?Q?hrxAiY4y+assEfdHNJWvyWHn/tfL8N5eWvrbmVGRunnv+8gLe/Q578KurtoY?=
 =?us-ascii?Q?yJH+nA4ckA0jBFMB7+7MHs3hsGytXos0yy9bEEKgqykHZEYRmsdaxwDAxs2j?=
 =?us-ascii?Q?lSTjzMyCAhbybWuD1CUCTJ08yvNCEYvAMNWu95DQ3uOSU++0oEJsDjenAuKd?=
 =?us-ascii?Q?pNiosEGAAUVD1S0aqHiqYB00GX8v3CSAD6fKz9DH0hRwLgwkJ07AvLZMVOLz?=
 =?us-ascii?Q?oqIqkIRirS5GXNOHSlBbbB7M0RxotI2Z25kLemXT4ggcsb4jLDpLXdM3z2Np?=
 =?us-ascii?Q?zWL+skpIQ3UNey2CaGcfRWgEz2iQuqjV3U4xlQW8PGx+fjT63bgg6BtrSbJF?=
 =?us-ascii?Q?idQ9pIFXyS8nV5wr7dODOR4pK3gHBk8MtMbF+KBKJxIigdPT1qaWMHXDoK/c?=
 =?us-ascii?Q?G2Z9CMD0kZv+1I0XuVGLbPfeMhTGCC0CWn4vgldixIwV3AFfO1hwfx6etHSJ?=
 =?us-ascii?Q?hx8Xk7GRmF15OxIgbQ5jAJkydyzT00+XQRHxroy0ixSDF18YSwDCSgevTpj2?=
 =?us-ascii?Q?hinakPAno96MwHqVX6MOo4A2XB5K3m1mhWCS0Nyiws1QzU9QB5IBvc08UTWQ?=
 =?us-ascii?Q?D+x3TUf265qNYCuf+8eLTU1dJt+KeX6v1qAaJ9K/tRQ1Qu+mzSRh7hih+grU?=
 =?us-ascii?Q?fFCxFIBLFHw6TxE3N7haMTFNSFJJRa13spoIc4uKKqjjEbubGXGikx3z32DL?=
 =?us-ascii?Q?+ATWDjhkT6UzaqQMbTd77Xjfo6d9jO+VBo15V7AcETOTY5YFO1043jbK1waW?=
 =?us-ascii?Q?3E9Kx0IqPg64VngM8URsC832AFxQH5a5L8MvAFrVGRrzAfPhGspdKaxpqj7I?=
 =?us-ascii?Q?oybZJGpsP/X8JXVh0Y6w7H478X8dKV30xOGuPwrgLmulZeJHXfKn+l9+QvGb?=
 =?us-ascii?Q?KwFO4FJGJSmy/loDryly1ZigxECj35tMflUivngOtmWlB5RH4zH+ceKBWGKY?=
 =?us-ascii?Q?CXeR0rbZgHQfyxOPIe5LoOIkOxoKj6EYRExN4usCz5nTFwnabfLSk+jpiD/8?=
 =?us-ascii?Q?N1UZKG/pAQv4ZqfagBYro+ZdL2ahLTaO8Kh9cplUWa/jjTbczf3CQVjQ4vH9?=
 =?us-ascii?Q?i+5lEn/vedXrr/j5b6UoVxKPyWxZGSt7I4WgD8BkxJ7JeM31qUcAXm/2nVem?=
 =?us-ascii?Q?tq3PHzH3AwDPCJH8ezJtyKw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FfRp2ljqSJ7jJC1Sb9E4XfcOWrvts4nE/Y5jzdHJ9g/GUrFhxUAbuJx0fABR?=
 =?us-ascii?Q?ruNf1jWAcAtJ3Wrj0KiRNHJ1uqllaMnaUyLFxgLwebCIzl86/b2/Z/Bg73Jj?=
 =?us-ascii?Q?5TokDbzSHn25TrcUi4AvjH0Ggeye/T8h3i/wmbpivbIwCNaiAlXCBw4Nqk+3?=
 =?us-ascii?Q?y6zkt60nPwNleU3pnyb4hkhu25KZigg4PpWeoSjOD9VwBCPXGvIc7r6l8CcK?=
 =?us-ascii?Q?2k1uJ1YnK3r1YKqtHHfcZGdrxJSZAUQSMeYW3v+YJ1z0zAcqD1pqzCXIxWvw?=
 =?us-ascii?Q?gcs+lFL9dCb3o76Ci+n2VzBYDQZHK5KsSFva6NRRbWwIsdhPoQAwIl/+vGXj?=
 =?us-ascii?Q?VTv/pDBu9zYV09eOiQw0yX+Ap9A/2DmDtv0WzW/GeAkCvrd9WCP5R4uSW/KU?=
 =?us-ascii?Q?njmkKaJuiUuGlPbG+qtH+j3ebKgEIHHvuuodp3kOzVJkc7owyqxmAsNaTT1G?=
 =?us-ascii?Q?iXrHbqH41dFtiiU6rdLuj3RT7mddU5b/xvtejJ+zuEKbAFgyd0vTW1W11x4J?=
 =?us-ascii?Q?qlz54najviRsBYuZScaBTxUVL50qrV869OtHu4bwv6ucFXzmPd/jSfs81TOT?=
 =?us-ascii?Q?T3GYzZGzVW1rOXecvxsh6fkCkIi1HHJUEsiIiqWDfgfpTNWAL9kiZQu+j7Bh?=
 =?us-ascii?Q?vFGbqsfW4Yzm6UuBOp4lghI4NJ2iN/tasefh/9tmTOr4ql6vapP/6VwlKqTY?=
 =?us-ascii?Q?Fy6CHqcGvfLdaOhZ19SAoEXIWWKHsPaYmP8mQ1Wt+BhXMpNTL+w+IQcADAFT?=
 =?us-ascii?Q?emM+WHO8pXJ4+33+GqItNVHAbTgrwfk/m5sosufxw/LT0JuypzbOfl6nD6W3?=
 =?us-ascii?Q?GobNZzChxQfOymfOOuTqup2QmlmpiNGrtFHFPZ9L2gygFHyB7PWL6ATmSSQj?=
 =?us-ascii?Q?b39bwldOSkmDt708+ydT+cFyYZYCRWgg8Oq/XKHHR1v5fsT8Tq9cqzS1eFlo?=
 =?us-ascii?Q?bkuYMDLISeatXz8gO5+eVLzjltxYUCXEhcKk607omC5qfRm7qfacshjRxXEo?=
 =?us-ascii?Q?GNkhQSUtLjdBFJ3mypwVCGvXh5t1lcSxZf2SUs5qMNd0Qx8SMDFxf9evNhMo?=
 =?us-ascii?Q?FeYFbgmAK44PtNhjbLCEe+w18KmyUQXmKf8YB1hOLgKlH17CnCTYTcfMbNzb?=
 =?us-ascii?Q?nltzTL0DNt/xZh4jEOoX7PaHhZZoK0JQmTiGKbtu+xo50jKzkK8JesNPvkbz?=
 =?us-ascii?Q?thw1L2dR33OT1IS5TsmUEfYRibpxm8CgGbO8ThnDeWD8cKhTMZnEUIrrYNMF?=
 =?us-ascii?Q?3KscP7TgnXO2ludlQ7/aijv1cueqKjO0n2uKF7yq8PhspHsUlNdZTytWB1ov?=
 =?us-ascii?Q?vHmxQR9BNAb1LShJEexLXUnfj1hLga9atRgxtotfMAvk4LdY620l0K4iZ7nd?=
 =?us-ascii?Q?t36jFOWzXoQxeuJu5cwin1F1Wk+gAoZJNnWsIR4XXiT7TgBOzwXunDGfvkUs?=
 =?us-ascii?Q?ki4dSuJP4i9tGbW0DSEtTgvcDG1ZPCILv3U1BkpFRkXUa0YAAwZjgYHgm4PO?=
 =?us-ascii?Q?vUjzkTB+H6QmTqkZm2klPkpvAZFsWfuK+Dot3hPsw0DUSf3thtkbUgVJ3K0X?=
 =?us-ascii?Q?TWpVtYDNIULSNKaYyKHG4EitswC1mGsNPl57di04l6IxsL0mqvMhQm8HeCDm?=
 =?us-ascii?Q?jjRFSrvg7jecpbOAdCAcZfK1ulNQQP/X5QWIU54GzG8gs7vgUKKsQUySveMW?=
 =?us-ascii?Q?3cKytfKoIoE/R5Qn+tDk79ywyH5qDfOgrkouNninkV1hvraTkvGuvQTyU53g?=
 =?us-ascii?Q?Bd6XaTqhRg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	31TOjVGL5kSY6ZAwc4QqssY8RAV/fSzIpqgTBYLpwrdPV10LyCsHkH2GyVTeCFmSS+JGea0Oz7HyKGwsp2dnFYqJYaFvcp64zcHaYjYfYESQ2ZCGwQf63ccHkGhS4bNmgoZqdzuqPm+IiorgovL9idWkgzAD2tzS4QE6QpO/08/u+5oEkee9p1ICYfFlFZolQBTWBCXy4cCy/1jddauBWy8LxA/Xuy0cAnjP8NeSyTKPqcl7i3f22AKRevcTgaXzT+Y7FgGNTbRkeQwpT3kVrXNkbc50+i7ut2Fcm0y9sUmbiC0aMBax6QBPgBmqVaP23vCtNrOMtXwzWkpU1hkNFxcL3fK3rg4KZzvH+PncQyNF0Wc5MX/nMh5hJO7bQml0imKR08cAoAPS63NTnx44A1IC60d3rGht7YmgjngvL4s3b7uasJA5JbyiWJtfd0++k+u1b6GlXJ0AOdxVQX5vtcY+QN9zZ/vgZMzXBStY2OXpBXtSJzHBuh2KPz40j5iYemojJE4gnAhPGiTpKs+G5UCgzv9b+zmlleX9dDmeU62Ef8iLL2Ybn2EwXRH4xWNVB8WnXKiX/N2Kr90QV2kP0RHg3BVf4VloNhdMhBfmiUI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2098adcf-516b-4b52-862a-08de70b562be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 19:22:28.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTHMyXX9a/T7nMbdibTqkOYMnikBeTX+xSBqwLhRGUvuDXVR0d5ki+AyUFdkCOqIvOUttmE2i7n4cxxSsG44xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_02,2026-02-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602200165
X-Proofpoint-GUID: _mJViY91obRWyryq4dC_aWShAqBpkgHd
X-Proofpoint-ORIG-GUID: _mJViY91obRWyryq4dC_aWShAqBpkgHd
X-Authority-Analysis: v=2.4 cv=UsVu9uwB c=1 sm=1 tr=0 ts=6998b496 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=aTf8P6NYFPnUNRBo_gwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDE2NSBTYWx0ZWRfX6XKKsTr2IbOt
 Xj4j7MGvvJunoX6QDb0xdzpkH785M4BlIAadEZNa6+T6lObMDXQpqyTy9A44FP+r9uqQ78eJpCu
 lJncL4w2ph7SQ8cIPERZQH58kARSbAAPUxQGYRvK/00oIY8tFeyeZTkT9Vaep+61nvue8vSBg2I
 /egJdUQEH/ILRH/uqtPUc10db6YMPML6Kf7mHZoTvh0z5jJy5rTOIhIcX8M7/XkjJK1pKrRF8S2
 xpWzND0q8jtzPTN/4XqdkHw1X+POPXS9M/HDtPpsDd31sD9YurKKkBl2zXObbKY54KgDwcWCx4F
 dEwygbbB5kAYLXdVeyVE1Gzo8mEJiZGp2B9FrtYZLY5vMWepO7cgvsKyKBgxfKDi3ZceXOp6tfI
 ZI9VJaN3VKE6FmVOPKGMvLfIaQM8wp7V93qqYfH+P8r84kqIYHb7vXnG5mezzbWtqbRnDfynnRF
 RSUBlQX12BjEhS2cO2g==
X-Rspamd-Server: rspam09
X-Stat-Signature: h5xoorjyksbryiuhj4mrnuzh7jqnfuz3
X-Rspamd-Queue-Id: C4EBE40012
X-Rspam-User: 
X-HE-Tag: 1771615391-737809
X-HE-Meta: U2FsdGVkX19NAslXQm5pcacmcR5gFSF0h3cYWiR9J7v37Ix8hJm4C5hW/J46tdMXAfxFoSWpz8Ud2yHgKwzItDmNCrDiuuj0PFpXON18EPDk36UE4FxJkJLMJK+1OwqhLl3/w/ZFa4heJR7EhjVvUqJINyneNARBytoZ6dTUt0EEYEv+s5IqPn/JKX6P7kPmk4IqkULVCIzyR1d/glP+kJNn+gmmkEenFfhCXCh4klJRYMGy9rQyIhGRcM5Z71lnQf/P2++kvDedAVKCLyEJYDfwWM2oU8UqQNq5neO9C11YsOmDxV6wHA7aBgKCqpb4BzLbxtW4N5thHQeMVjN1vImAMpswnvFpd8ijKmNvIXQVI+OaOAEMErWVfBFxELokKd/h38whTQxA7HBbfe+H20egviRHBCuMPFis38hxJpOJ3cRdgw/jPsIA31Gac/hgOvCzdjsYMWTTOpYgT0MYasTVsHWS72mb8QpgritLR3/5gycFvk7PQi4apGenjV1OoD6Pv9OEnTPVTdER5bqyYkct1kDp5Jms+2VdS7wWS2sIGuLLfRnMFGezf0h/taHpjXZxv9oyRpqxLekkK+0pBiwE66pxzV4o2tZW42SYojW9Pbh4q7aQGOCPGmHKcOAW5TT93QcwwOSMK8bJxhk+RkrC2qikrj2EB2itMYWPEpLHLOdHwofZUJ0Wa3yaY/oQNJ8021XSlvtFAh5m/LtYfkYM3yWtl9C5p6e7PBfPXlOClcb9723CB7tIlrLmKmRraDgO452gHDCgv3PfPpVCWY13pdU4hKnIU1pzLgzt/9OHSmL3Juvh/kehltKDIYvqEivA1QnmsYytYfjK1IReyM6lqgyFuQ0Vo/LdW1uOm5X7TT1ZFqV0YaX19XIJdA2UFO6jeytb0RyqvQkCuYUBfl5fCEES985L4Njn+26u8SmcANXnoEQBJCTkGIM6jBSvkzpfFTP5SqETpISplIV
 JOnLvl6D
 4LDp5kN/y0VIku4Ky3RYjXqejiLi9i87Yo3M+qM1IulRJkJtUvlOz/M41tVoqROXDW3/Fq9HrrStq2JyQjnpHS9GcmlrGXnR2BhPnjG3SOvY+PKt034DikprxMFWsrzWwKGuTYTEwo/C5vuGFTSPCZ/Ki+5zTQ3352z6DHTnf3k3eVuWfWkkyCE9PbJAIFkq9pFHr4813xmLOKFQrRnLuI1GJNGLTVsL582p3eYyHx8ZuqyeTqn90u1w4lB8xuaxSgXHY/SvsY65LEQtT/cm2mSImOEowNlyGNYrOj+cEGmLM2tgZmy/+KT/3wxJnlvl7tBTT84cpvJQ+KnsqPfZkZQvfAG0KJ8iHrGuaS0D6Z3xbUVFeXdZtfmU6J+8FdnkDRCPXmIbM89NjsYCXd3sMJoiEL6I65WQGxi3tRByjA4vSBndOoBLdawaeR29xQvKvKTblx8LLvy/AjhlY3xx674oFGQUwxjulPoNCHqnoJ8Mkv8wic+uhpeaYD57Vz4MyXRmHfzrHqhXlEatvhmR1FoAzE3vOvNAOlssms/10YEFyQzGqTRsLvnIuXeZI8Es3tQlCxkoNGacjzuSeMUtFMx78Rc8ssWd8flp+UzEAMf+8LwY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260220 10:39]:
> On Fri, Feb 20, 2026 at 10:03:29AM -0500, Liam R. Howlett wrote:
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260219 14:28]:
> > > Currently we track the reverse mapping between folios and VMAs at a VMA level,
> > > utilising a complicated and confusing combination of anon_vma objects and
> > > anon_vma_chain's linking them, which must be updated when VMAs are split,
> > > merged, remapped or forked.
> > >
> > > It's further complicated by various optimisations intended to avoid scalability
> > > issues in locking and memory allocation.
> > >
> > > I have done recent work to improve the situation [0] which has also lead to a
> > > reported improvement in lock scalability [1], but fundamentally the situation
> > > remains the same.
> > >
> > > The logic is actually, when you think hard enough about it, is a fairly
> > > reasonable means of implementing the reverse mapping at a VMA level.
> > >
> > > It is, however, a very broken abstraction as it stands. In order to work with
> > > the logic, you have to essentially keep a broad understanding of the entire
> > > implementation in your head at one time - that is, not much is really
> > > abstracted.
> > >
> > > This results in confusion, mistakes, and bit rot. It's also very time-consuming
> > > to work with - personally I've gone to the lengths of writing a private set of
> > > slides for myself on the topic as a reminder each time I come back to it.
> > >
> > > There are also issues with lock scalability - the use of interval trees to
> > > maintain a connection between an anon_vma and AVCs connected to VMAs requires
> > > that a lock must be held across the entire 'CoW hierarchy' of parent and child
> > > VMAs whenever performing an rmap walk or performing a merge, split, remap or
> > > fork.
> > >
> > > This is because we tear down all interval tree mappings and reestablish them
> > > each time we might see changes in VMA geometry. This is an issue Barry Song
> > > identified as problematic in a real world use case [2].
> > >
> > > So what do we do to improve the situation?
> > >
> > > Recently I have been working on an experimental new approach to the anonymous
> > > reverse mapping, in which we instead track anonymous remaps, and then use the
> > > VMA's virtual page offset to locate VMAs from the folio.
> > >
> > > I have got the implementation working to the point where it tracks the exact
> > > same VMAs as the anon_vma implementation, and it seems a lot of it can be done
> > > under RCU.
> > >
> > > It avoids the need to maintain expensive mappings at a VMA level, though it
> > > incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a TODO
> > > (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracking is
> > > pretty sub-optimal).
> > >
> > > I am investigating whether I can change how MAP_PRIVATE file-backed mappings
> > > work to avoid this issue, and will be developing tests to see how lock
> > > scalability, throughput and memory usage compare to the anon_vma approach under
> > > different workloads.
> > >
> > > This experiment may or may not work out, either way it will be interesting to
> > > discuss it.
> >
> > Discussing alternatives to the anon_vma and anon_vma_chain would be
> > interesting.
> >
> > Just to clarify, this is to look at the complexity of the data
> > structures and not the locking, or both?
> 
> It's emphatically not about a rework for rework's sake or a de-complexifying of
> the algorithms, it's really focused on:
> 
> - Memory usage
> - Lock scalability
> - Performance
> 
> And these are the metrics that will determine the way forward.
> 
> Talking specifically about my current experiments, I have totally reworked the
> entire thing, it's a fundamentally different approach (as briefly described
> above), which also completely changes how the locking works.
> 
> This maintains a per-mm data structure (which also outlives the mm) called the
> cow_context, that tracks anon remaps and the CoW hierarchy
> (i.e. parent/child/etc relationship between mm's which have forked).
> 
> Since we don't fork that much, RCU makes sense for the connections between
> parents/children and means that we can quickly read through the VMA maple trees
> for each mm without having to contend any locks.
> 
> I currently have the code working (as far as I can tell) with RCU alone, I'm
> still testing this but obviously that'd be quite a nice property to maintain and
> could lead to quite different characteristics compared to the current
> implementation.
> 
> But I'm still figuring things out and MAP_PRIVATE file-backed mappings remain a
> complete pain (they are effectively 'remapped' from the start).
> 
> Whether this approach works or not, it should give some interesting data and
> insights that can feed in an alternative approach if necessary.
> 

The locking changes are very interesting to me as it pertains to the
tangle we get into with the mmap lock, which requires preallocation (and
external locks on the maple tree) in most cases.

Although this can't fix (all of) the tangled locking, it could reduce it
significantly.

Thanks,
Liam

