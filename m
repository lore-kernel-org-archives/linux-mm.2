Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE44CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82AE8E0014; Mon, 15 Sep 2025 07:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A2C8E0001; Mon, 15 Sep 2025 07:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A221E8E0014; Mon, 15 Sep 2025 07:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3638E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:36:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22A36BA347
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:36:21 +0000 (UTC)
X-FDA: 83891281362.08.47AFE84
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9263E14000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:36:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ev0/bT8D";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n9EHtVIT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757936177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsBe76bavZeKXRlTRW1ozAy858UlybX/Nmuj0RzzzmA=;
	b=yg+s9IbfO+kucbnAPzJ4V4vB0GJW0FEW6x3er6wta4rSm1y3NGB6gys2NQJ/3p80Nm/e/I
	64JDTWUxa0XBwrHuxEWjE9Me1Cxb0OMk4ySVJCp+UgRxDryJGWfcalJuVw7B5BtWOJYIhJ
	uIB1+QwlpIcZlXTAKukpX+1xYSqh1cg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ev0/bT8D";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n9EHtVIT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757936177; a=rsa-sha256;
	cv=pass;
	b=6D2TPIxL66fNBWGjKuJoeN2IgAtUqyNjlcHwDjuIlbjKIDQjFpW16m36A+leZ83VCSljOu
	tZThQNa6qlGs8zUqyGDT1yxv8TLrMOqMDRHRFxFzn7RbZnhe6V2fs93H7Yvv6kGCm5BuzC
	EpbIxA4DRMoznOOIRsAgwDSZd2EIqWw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAuE3W025254;
	Mon, 15 Sep 2025 11:35:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nsBe76bavZeKXRlTRW
	1ozAy858UlybX/Nmuj0RzzzmA=; b=Ev0/bT8DnkEk5cqoso7WGltOg5hDCVR1/9
	NotXeUUpDxl6cOVVXBN1JM7IuqhS6XaWLUnKu919aC8y/UJAKHNycvhREZB//Kn3
	8t4yJoXDzPYkUc4LiQSdkePUclJRSnybg0c1vXzy2HQLj4C/h/AbeJ4zT3gZ7pnU
	GaPMvxrXJbuBDKEzUFBQwJiizxDKi9TcGM2ygDzfYqt0MVtnKm+xRFqV/KJt2H6D
	WQEv7RXBv/16PM4zMhgtAgJ3wyHC/1Cwv2WVz1kifFLZb1Qz1DSAveaXHK7kHGQ3
	domgPQPm3iVtRAcBpRWwKYd84KQisIVBG43tXlvyqFUPS4GecE7w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v24tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:35:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FASGCG037392;
	Mon, 15 Sep 2025 11:35:53 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011052.outbound.protection.outlook.com [40.107.208.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2h60pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:35:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dNAMOAOtBBX0hPJqFWqnX75iNm6eUPGXENLuBIBK0Ymqdp4C7CprYcLs+dxjC0kotoQHT3gAoF0r9GOJpFtI46U70PFlo+oeZkGcahAOitoxbtY2KA1cinbnZwcdxebz2McGMa+Aww7PznlXY9jGBI/rJEWN9oExq/x4kxZCR7JYTtHbES7nmcBvTyjEpLhSMpi7j9tulf/T3uDPFWlBVPqmQQ4mBOhP5KETyseW7H+9nwS0afxoJyqPYzfXnbboPDIBwy1bdGXUuakNdgOSDqKyYrTPrJp6CPxzxYlqqDJ11ifR8NYhJMmWOqIgUFcRB//rIPAs/0YLfYzo76Vn3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsBe76bavZeKXRlTRW1ozAy858UlybX/Nmuj0RzzzmA=;
 b=mJRA+4uBBBIVtCY8gQU7kHT0vH4OSj0xHH/t41Waqcpegp3w1qNBRwlGkVhHjZxGtCHpK3KUZ7zTLxtUYhKuNZrpZHBTn3HJzvEeZ+ERqikj20lHPvkxliNrhqxyKeSVAyru1n3rKMFtDgOXjPb1EU6bW+Z4lsfAOr0BfyuePWIs+Mn5YCQjgEIbFRZ9sepUZHnkg6n3a8e5jiq9BxpDibRWpAbCXcBiC6st1+M44rJMGeI1/NIVEfEH9nGUFWGOHiYKws044K/jnn1ZzICwLq3mlaoXC6A04uCsO5U2IoL1nugeaUHmqOvWobzRQSszPHve71HRMNsOMU2QYJlT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsBe76bavZeKXRlTRW1ozAy858UlybX/Nmuj0RzzzmA=;
 b=n9EHtVITt+BUoYmkZ80ULzHG0RQhEYr/ztYzIAgcBGViMCFkbkugBQETE73mAgeYWg0Xx/FcKr1dyTqvL8vhUSr1FNxHGqy/m8pd1KdlEzJPHHsnKDZmceWCd5ZjpAk/f+pLMUhBJW23VWB9qVci/dET2sfT29Lc8rd+nSpX32o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5660.namprd10.prod.outlook.com (2603:10b6:510:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 11:35:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 11:35:49 +0000
Date: Mon, 15 Sep 2025 12:35:47 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <e0580a44-2afc-4f3e-8d3e-d4fe9b2eeb21@lucifer.local>
References: <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <155c821d-402c-4627-a723-6f8c88a2f65c@lucifer.local>
 <ae9d88e2-bab9-49fc-a459-d7b9a8fe9351@redhat.com>
 <ff4b6935-fd13-478e-9187-219fb612aac3@lucifer.local>
 <e450009a-56c9-4820-bd0c-da1d782d3962@redhat.com>
 <2757fb07-78bf-4a39-8c60-8ca8be200994@lucifer.local>
 <a48c8d89-da30-4a7d-96f6-e5e17757b818@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a48c8d89-da30-4a7d-96f6-e5e17757b818@redhat.com>
X-ClientProxiedBy: LO4P123CA0440.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5660:EE_
X-MS-Office365-Filtering-Correlation-Id: f29d38cd-8b24-4548-a2f9-08ddf44c04f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qpZ3NWvEBAmF0NliIBawRUd6ZZtqDf3UGuYTIRB8cnrbd1In91BiekqYwucz?=
 =?us-ascii?Q?BJ3JZ1uHLOHzloiOCBAPPZ8JLA+zMpEoO15vQHYLCBV6/eQTazuBk8ylZxj4?=
 =?us-ascii?Q?3m+cs/O/cJ+SMEYKXuVgtOI9Tg/UKmZsUPzsPdHUwVqIXUigqhUM0cVTbC2x?=
 =?us-ascii?Q?wxeCkCRTkkiljM3k8k/0UyovSkN+4sQfm6upJTEcqLDdet8VNrrb3cYpgxtO?=
 =?us-ascii?Q?124iZd+PB0lE3DxeM6PaOL35eM/i5jO47ubgWC90l9J5dNiPIWJtGYTGTNaf?=
 =?us-ascii?Q?XcE1fL4ENp+RVSTugnkugUv9QfchRF/43ga+IzBWHs2lHR1WPvykiA2F0tXI?=
 =?us-ascii?Q?yMG7tURrWpvuV2fW/BIteNpaK4FIMGowNVFKF6U/US2OQKBybbGAyhgQEAc1?=
 =?us-ascii?Q?+EgTTjhHtqusL8UFx9vcoQ5Znw6wWEoY5GcYUZnJym4EBc9jDEpfoMtmJk4L?=
 =?us-ascii?Q?S1bt/3o3HHTNpNz7htfd9F4HQavLosWdjI6+4DSqiWWIG5j+L5lqcGcyCUYQ?=
 =?us-ascii?Q?vk4lyJKialR+EjHrKM8mJ0lP+4jekarCJP2B2x8/Wr7agbzGzcLBiBj9Zk8+?=
 =?us-ascii?Q?/s5n0F0gbgUqkWypjC26xfZ+CsCKiPoUByJ3UZretau0RinHKZ6AXYf0Qa3z?=
 =?us-ascii?Q?XJgRSKnNzBMjYW8scwy0zAQc3MrvCd1xm+1dyh4m67I7JjVHzkQTb5jlUEA8?=
 =?us-ascii?Q?KMkWPGbRB6HQP1G+DAfaW25DApeyzbHPBwIdZCDAJYqfDcLM+EAKzv3a/Zzz?=
 =?us-ascii?Q?LTIyQaoNVxow7FWLD4GRimdcH2+uszK5CHHQQ8I2+6PDfAveUFILb56Ht0nc?=
 =?us-ascii?Q?3wXLQTMDOeQLqRoGGch+uljdtlSZ9lxw+yRyMMOCrlE8lx4QuVCDgzSjdGJg?=
 =?us-ascii?Q?kB5KaUQA56OEDXUFw1pkPCBGABkUmc0InDoguO7uiICuH7BlxHwV6+QalRe3?=
 =?us-ascii?Q?nJ+3RUCPMO9tYMUKIpxHAgFl8S/8FnhKaavlCNimic3iWUJ0BwxBd2e/pt2r?=
 =?us-ascii?Q?7oeE/7ahhpLQ4HEJzC8wj0+EcYvPdjWnKlu/wTWcbSXvsgC1rI4jqhD3S2OL?=
 =?us-ascii?Q?MEsuQd16O37z5dcDhH81Z1tHetCFQb75A0mSExlW2M6QIxyz8Q83SPS/fmX5?=
 =?us-ascii?Q?Ynj42GIm3kSSVf2Ebx/U+yoj5ycpalKz2oNhd5/4fm4v/sI19Lc7JjR3MET7?=
 =?us-ascii?Q?b/5HcHbzGdy0mkR9cRansjZiPqHl2RKHXuDBwgXvSdUJMewydYZo7EG4QJPS?=
 =?us-ascii?Q?5ajozo88v+xnD3yitbql8bXOY0B6kY8d6llElECoqjIDTXGgiOJ4V8ozQqhL?=
 =?us-ascii?Q?D0u8SQSorl8RkAtYTPoraeTJe3vk/MgVzB+zhqd7qGsy0XIyEVvwk3UfTKTx?=
 =?us-ascii?Q?grOldugWG4RqDK/c7r0P5QlJVE5LD4KNlgP57faYYgpy0Wx0WE1Yk3NM/utE?=
 =?us-ascii?Q?84VSI6mh5Y8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iGx6mNo1crn83Bx9JJHb9rhh2gKU8qLCvKJUZZQZ9RGaME1jknqyxFCA9upa?=
 =?us-ascii?Q?x+qgkStVwJioFXT/cM7LPZsksd5NVWWsjhzMoyuDQZBgkk+1v5GfmlP8Coe0?=
 =?us-ascii?Q?9H3ehhr1auIGM2ACJCwim3TCz9EPXBaFYf+N6CMRh1J5nK9/enfYQt+dK2Q7?=
 =?us-ascii?Q?V1PVMUxLcVHnZlg2avZG8bUB24OWywBklt6wyrQ5Wj+l8GdCM/LfQwTRcF+R?=
 =?us-ascii?Q?jc9h1NdrnJnm7Qn7BPfU5ZeZZURTvs9nGklvpF3fvENzJCn0eji43D5f8zBH?=
 =?us-ascii?Q?/6qWUkxy9PqqqRajmneWZvLyaSvQUu//tnQdEAUIMH/hAvgqovYumnIHO7yO?=
 =?us-ascii?Q?jlxWVsYBI/ILsq3UDf0bw8Xd+13G5Mf2xVznxiwaqgewjD8u/Se961vx+af4?=
 =?us-ascii?Q?GZzZYf8pOiIXW96DUV3TQgmv/ravjZ8sIRwJQvC3oHCFN0qn5njWDbcRvhAm?=
 =?us-ascii?Q?F2gVV5rEXyRPsTojcwOvQ50lZGsqIH7FhDL+pq/Q+37oLVcUPZD8gUplBTa9?=
 =?us-ascii?Q?43HY+wRMJDJ8dT/az5JDwoygTxPXRcAgt1y31QczGIFTU6/2QBXI8fI9X1BJ?=
 =?us-ascii?Q?7BJ+WLZFkYsEaAKf53avHyhlG6g7wjgyykWdFaGdFfM20Q5d5M4qErmYjjnZ?=
 =?us-ascii?Q?DvYI1B9gB3IUM67fdVZUyX8j6CDzozG6Aet5jv5cTzP+DbZ2hR3UUh6uI3E7?=
 =?us-ascii?Q?Io4A1gvZSo5AF/B21Aa0x/yHi5S5kWjqtLCdEVh7tzxHV+qGoPNv3oslFDb/?=
 =?us-ascii?Q?4l9pzlQGtSwMmA4yy3lcq7/qq5ayqjoiDwvTpyRz7brCwAhRuK+X84KGTz0h?=
 =?us-ascii?Q?OdigN9V8qTgSieNZ+Zq5+HhXXw9/ARG6zgUMJwXQsGVDk76x4Rm9Ab1erhoF?=
 =?us-ascii?Q?qO9im64V8YobzHg8pfrkaVHjOvbieNeDCwzhy4E9PCxQizPXIoPPpaU1BScq?=
 =?us-ascii?Q?HzIQfF/GAN0rCT3mvk+Eji20HDFc1I1+wOxlKjodAgDTfeoNqNgpCHhC34hq?=
 =?us-ascii?Q?9qNggEd7FzSGhjudMeSzflelcAfL2q8RG9mIsFHUmAyuxUvcR1XFr4iA1CLz?=
 =?us-ascii?Q?elQ/pMDWqf1lrGnGROOqtZsTaSZNctitHjYM9cEB+0bU6RRna1vu+molS1PO?=
 =?us-ascii?Q?p8gX6/eiTm1PobeOCb1XvTmHpX8RILsDknDUVrZAHKc7sdXnL7IskTcxI3Z2?=
 =?us-ascii?Q?jQeLSOh8Tb62WRadlN6XVsoRK+7FVB+oW5gB2LLc5D7gwNqLFMRQ7uM6UZMt?=
 =?us-ascii?Q?v0FVpu1TIYlwS5S1i7NypmxETseOb7haK5Pl9Uw3NZVxbyeJIC9Evd8h4l58?=
 =?us-ascii?Q?62pmfI16vSjZd5kobESUQeRTX/uitZ4Fk7O6d/vKvP6IbLLizA1Q7xX4oV16?=
 =?us-ascii?Q?TNLR5UYUm7aCC9hVekpyaxtmZayC8eS2iRzRVDqN/bitgEuSoBRw+I5FTYbz?=
 =?us-ascii?Q?NCsSUsRI2StgHAsRAHlLDoShNPAYhg6IHbnw9l6gTHn68ftQDM4Y3MwEyK+E?=
 =?us-ascii?Q?c96F4t8LDvqWbHpmZAJ6MD9SYsB2vkWj5yjfijSdAWqzD+2NX7Yy43PkJJuL?=
 =?us-ascii?Q?LK9DBLy3KJbh53bQ3uoGaWnfmLFId2cZ7rcwjNzOZFafsY6Wg17WMihhzexl?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9i2X0+a3v1iItkeKL8wimbUT55kpAEXkQa6QoFK24aSnVlRRaWkkUB4ZKlJ0/6PRCzXkKHiE+hsq0lgKVmduSGVkOiG2sZQd9sBMo9ZOw5uuAHLdYACgBhBuq2d92uilSM6hDSmd7Fhnq0SK1bBhu9Vb4i45wsD0bTBHOp3Xegz8x2EcrLHJl4iFnKCvs7249tvyd4Yd+BIsvcn8EryRqAxNqSQvn+gDwF+AFnRXT8U4uL7Evo4sseJWCIoyHfRrAHSv5TtDtZy9rcJtKYc2TQDGFGrsNf1x67ge/pFsnzqgm4LnBI6JVdNiIguFcIJJgt1a51Y6uPmJIm+Fqp4LoVVj6BD2oYl/YdGhwAmYr+5rC36gRotEK5S7KjdshrDsaxEQMyArYbPuOYoUfc0gLH44SIs5k/YKvcnM+BNPbnH2ntDNPBr+vfokrvTEPdG1TsAAMSeEtKXBpeJ8iMvMnIwZwKAHeFKR9jCARvnoXWKbKGM6SEwRPJeBHvXyvV3cV5/SGEJ7a7a65+JHkKhAfezIk03knaPYJ2duZsrJJsYPNDGtmKH+xEX7E5Q5D6LY/1841Tc2zPD5F/GFVZBfGXv/igwupgFFeh0d2hMrUsU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29d38cd-8b24-4548-a2f9-08ddf44c04f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 11:35:49.4855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYoFC16aYCaASqlb4bKhdbSo6LCOI/Xmcnv5ay9FR45Gsy21+I2LTMIU8u/bJZ6tT7NxSA093AFly5dJcAkCKcVmyXlgwtWkbvkO1ny9l2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5660
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150109
X-Proofpoint-GUID: P4Mx4QjWROZHvbARpvbhc3pHKdNvGoc5
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c7fa1a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=C6Lg5DDrrqiDUkkWyAAA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX7UNdwrFy+9KK
 KAMHtF3+JIM6Fns4bdBU5xANOmwYLkAHjx1mJmj0pG33uZ+Ful4EEIKkRK5Vci3T3ut+rlXLg+t
 2CAesimsQXWcg4XBvVjkFL8YI8sK0N/FWl8/UKCAtVJtTAWFKnPgAlmxXPxrUid/1L09+QX9Oa+
 A9EAIlNzFtnDV6FL6WfGFaIX5/TSsBi1Sb8HSPwvS6RO8MEvNi8GupJX+jEuRdY2ngLFG1b4IaY
 cvkbQhJf1ueKswKbiwOwiaSkWE0FHUCCi0pkHU25D9MjioqqvsL35QP183ZslU52phqlgzpYF4a
 HG9m4nYhW3ofujNFEF4SdOLZI7SE/WBm6lcRH1AkvA/bSUvn1RHe8wU+bKLqGo+ozwT1wxBi4tc
 Nu7+55CnRi5xS/ohAQZg32ScqTRwBw==
X-Proofpoint-ORIG-GUID: P4Mx4QjWROZHvbARpvbhc3pHKdNvGoc5
X-Rspamd-Queue-Id: 9263E14000D
X-Rspamd-Server: rspam05
X-Stat-Signature: pt9p94a74fdb8qsoaoxz1hwfxk3g3r4z
X-Rspam-User: 
X-HE-Tag: 1757936177-570837
X-HE-Meta: U2FsdGVkX18L+KBRVOUSeIfq3zhImss/MI0ZUJ59HlMzjhdW2cVVR+/z+KC2Zj4hDeK1+/TE7harM9Ml1pGsbnB6xHhLfKk41M2MuFvHswNeIFDR2OrjvKX1DLg1r+xqMTJO7mnY5Ys+3t5Pk8LgMoOyn8tY9ytrirWpX6sW3EIfx0mtAXXN3+7iR23Ps8RSMBVsSxtktOUBUgLH9xIRrg6g/R4yYlFK4littN2BlXE0Ev+RmveDcO98qtg5mS7dgeo07qrX4BifnfT+SGBZipNkmM2qJimQGn1s97prOxvjk3UnhFax4Gt6hveScE0wFMmWT+E2jUGpdSiLA9t+7EHWu2o+RjU4jgfU6znTqrHssgGfaE5OwR7AoOU+DkGJ32H5qaVc3X1EJ1TSVV+fNHcWwnMILL74jyc6iecieZVIRGdIvhdIUr8gF6okATHpmgauabL4O6dSjpY7LxH+S1mY7SgY/qwbpSXrxIG+3ybr4va6Sy23MS5fy69u5RrcPFL1DyA4ne7vOHuh7BX3iZrNlQ9+nZJJKXfcWobnydh9H7SvNpdPtEu1b0qb3mOpvXhP9G6JZx5uAtDA54dWxrrHhWev/i13MfahzI19bwKP42h5EpBGXP9EowO0kEtreCBed35C/OsItAQboeh116hJizMuabdRbqYtVO8vuPhdPVT00QYVZqRFBgIxeIFssbQNHlhGxXyHTr97e3669wo/Z+0HgCVDh+ESfx4fUY/CWj7lu4E9jcnffoRKfO/jdhjmU7aPLwL0NSI0n4nDjx8H31X+NXGqJlafgh/LM+RMNHrm/bcH7F5eq5obsKCrbnJOv+liio5F/pOguQHTbS2mENPrd1jz4Bmx3KMYQDPVW4FaZQGqBvMiaRYsI1l+fFMIJ+OUklUXksDL0llwoLr0TE/LUiExsC77KK9Itl1xMasoUoEqXXRddQGZfP8HN3b7EfFW+lhdlFuixc5
 duP6ys+h
 HjZZuKsm7zkVrzkRHvtUNA+eqgJHPogdUWC/Za2J3Onc52UrZ9aBIzeeax9f61HdocEA/D8AXJAQ8VWMVGKdwHK3NNePOkFOE2IzpW8kqf6Dq/D8nG+FR60TdEaUrDeXpqodxHxTbjT3J/19alcPZXYpUZlMvTO/KvdId/+BjbgQaAbJxI0ulOuFOm+XJwk42Dym7JqeZViaWVpWOqgcXoW5UTk4gJIkhjUZF3Blex+tIqNyMBmyrOyV9LcjXO1W3P6B9+F1qYvSdnT35Bvg+gGlgRJxgcheRFi73q3aaYGgs96BSJo1mjj313dFrj2CajAXwvXe9WgLZD0vw9HdCkKAWHXI/uCy+qVDNDd5GJMFy7b+CWQ9eqmT7VILkWoVjLiO8t5onPyyBGwPm4FI5DoY/E/aJYITSRbw6qir4UBhA+TtyIqAGA77SrsFnAIxwFazY6sJU8ISERwv7Gog611MrfPTTiD1NYmO1kj8VE+eKUXbLQZoj031/d6NsIxLpLlPIUdvxAM1XGwES2PHjBsH8TmfRn6esoim09a9CzBI5tDs8+UMaUb6tAwHuI4A/FVP7k6WGgbmf/rjXXCYFyxR1xSoia26iTF04hJSj8yDRAiMiiu76+5oHKvRLl+ko6+2+khmSYmX4oc+e4Q6iaYz/wDmAZYZ461F7iyih05uY2lbc2VWdO7eNc1wsPXT3C44Pf7uFJh20Tl5xb5vhO2+OxyOQao0thZMtAtDL66qmyjKKokL3P0gW6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 01:29:22PM +0200, David Hildenbrand wrote:
> On 15.09.25 13:23, Lorenzo Stoakes wrote:
> > On Mon, Sep 15, 2025 at 01:14:32PM +0200, David Hildenbrand wrote:
> > > On 15.09.25 13:02, Lorenzo Stoakes wrote:
> > > > On Mon, Sep 15, 2025 at 12:52:03PM +0200, David Hildenbrand wrote:
> > > > > On 15.09.25 12:43, Lorenzo Stoakes wrote:
> > > > > > On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
> > > > > > >
> > > > > > > 0 -> ~100% used (~0% none)
> > > > > > > 1 -> ~50% used (~50% none)
> > > > > > > 2 -> ~25% used (~75% none)
> > > > > > > 3 -> ~12.5% used (~87.5% none)
> > > > > > > 4 -> ~11.25% used (~88,75% none)
> > > > > > > ...
> > > > > > > 10 -> ~0% used (~100% none)
> > > > > >
> > > > > > Oh and shouldn't this be inverted?
> > > > > >
> > > > > > 0 eagerness = we eat up all none PTE entries? Isn't that pretty eager? :P
> > > > > > 10 eagerness = we aren't eager to eat up none PTE entries at all?
> > > > > >
> > > > > > Or am I being dumb here?
> > > > >
> > > > > Good question.
> > > > >
> > > > > For swappiness it's: 0 -> no swap (conservative)
> > > > >
> > > > > So intuitively I assumed: 0 -> no pte_none (conservative)
> > > > >
> > > > > You're the native speaker, so you tell me :)
> > > >
> > > > To me this is about 'eagerness to consume empty PTE entries' so 10 is more
> > > > eager, 0 is not eager at all, i.e. inversion of what you suggest :)
> > >
> > > Just so we are on the same page: it is about "eagerness to collapse", right?
> > >
> > > Wouldn't a 0 mean "I am not eager, I will not waste any memory, I am very
> > > careful and bail out on any pte_none" vs. 10 meaning "I am very eager, I
> > > will collapse no matter what I find in the page table, waste as much memory
> > > as I want"?
> >
> > Yeah, this is my understanding of your scale, or is my understanding also
> > inverted? :)
> >
> > Right now it's:
> >
> > eagerness max_ptes_none
> >
> > 0 -> 511
> > ...
> > 10 -> 0
> >
> > Right?
>
> Just so we are on the same page, this is what I had:
>
> 0 -> ~100% used (~0% none)
>
> So "0" -> 0 pte_none or 512 used.
>
> (note the used vs. none)

OK right so we're talking about the same thing, I guess?

I was confused partly becuase of the scale, becuase weren't people setting
this parameter to low values in practice?

And now we make it so we have equivalent of:

0 -> 0
1 -> 256
2 -> 384

With the logarithmic values more tightly bunched at the 'eager' end?

Weren't people setting max_ptes_none to like 20 or 30 or something? So we
should 'bunch' at the other end?

And also aren't we saying that anything over 256 is broken for mTHP? So
weren't we trying to avoid that?

I think it should be something like:

(eagerness -> max_pte_none)

0 -> 0
1 -> ~small %
2 -> ~slightly larger %
etc.
9 -> 50%
10 -> 100%

Right?

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

