Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F044CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8DE08E0008; Fri,  5 Sep 2025 06:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66308E0006; Fri,  5 Sep 2025 06:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF298E0008; Fri,  5 Sep 2025 06:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B25998E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:14:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 426AD11AE2E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:14:39 +0000 (UTC)
X-FDA: 83854787478.13.7D26F79
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8AF04A001A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:14:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mT9Bhbwi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BJDLhld1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757067275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVxe6+XXU7tN/vVq3fkRss2i6F8wmNnq7383g+E6TzQ=;
	b=OXqlBwA3HgOmzBzfMqPw/8EB2FWs1elTeCKGp1qXghkSKxEiO7B105CR9pqyEW67a0ynmI
	uZFXgA229+dGr5SrD0eP65px0f/5WUlmKGXR6Hd4X993eIIZal/QtunMAyfMLrt+zrsLwB
	LmK5OMvC9K8lLgqhaQ261atD7NU819E=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mT9Bhbwi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BJDLhld1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757067275; a=rsa-sha256;
	cv=pass;
	b=8L9YIvdb4pcbX+CRYL+1mXM6QXbcZXG4T6lkjeQ1XHsbbdECGpHx7nXlRb5wqp1y5br0R+
	nm4+KRxJTk4ykr0OnxG6oqE4Cd0evuq59TyjieDaCbVqdlnfCxvkTRyK8Nh+tASq0tVl4C
	pGZB+/s+unhs0MB5Rv2/xkkULo6lNr0=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5859nh9A004048;
	Fri, 5 Sep 2025 10:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GVxe6+XXU7tN/vVq3fkRss2i6F8wmNnq7383g+E6TzQ=; b=
	mT9Bhbwids89QlRbLEEAcR7QrNCqXsnIiM86DHUA2LzZJVE9/K4yV2NaXGMjCR26
	1EdWjwezGXkcwUbn4cqTzK/f5Hd5plyLNbitvsB8JA/oC6d9UPtzHBxMNRboX8AV
	KogJkUVo1pd4SuKnCkUfc0SsoVT87yZxJOGRIZXSwC7Lebk9vImyCI0onUYLHrCr
	jBxZ7T49zn/fR9KPinFf2uKUjPQC+Tnh5clMiDUz1UAHZC5fjQAU1CDGuMUbBzGv
	v1dvmjm4XhreLuPvF+NmdZj006zC71/3bwiBpsWLfu8WkqFH8vWaNvTcSekrCy/8
	Ph7LOAWaUCyClqBikJ4tXg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ywjq816r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 10:14:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5859Jb8N034431;
	Fri, 5 Sep 2025 10:14:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01ryuvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 10:13:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aeuWk05+oAZUbP47pw+RLBcZ8lVpar7tczAKIAt09B0qAzPFDQKJFGaYHKFPfRplHBfudbmdhbG4ZUg1TFZMi+SlJuZqQKJmnbJg7mTFDO6uShEgi0b4pn79/5IKI5s4VUxtpNRxHG38C8DfIqSs1vTA8JcsH/xsiWPtXUgPTu8H3fHB2fmriT5F7u12D4x7fETaeSJKyBvKvPaxTPNvteqEI3mXzJaG5Xw6QPWN9ckVHZupqy6bu8qLTOn+RpCUkfYR8tsnaC3QRQSQ88gOIxLu8m5L1TSDS25081pleAWzXokt+WHJswn7dUIl0huG4e4xq/ys6LF7oswJ9I7mWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVxe6+XXU7tN/vVq3fkRss2i6F8wmNnq7383g+E6TzQ=;
 b=ZPs4cuwE4E4t3SjRWL5/GmjzHLqrkTd+SdY/JSRTS0iWxZNvv5WqsPOPRJVjFi3mQUJ/8Rz1mdkWcNdAS+qLLyBJV5GQKdBeFKQT+lDLbAo0k8rVaSAKOUNPicqnA8JiriIIwWrPO1dkEo6Vfjr3O9CvpX3WlhgzUZTQL3NRL6UL+UJn3Po/i3uxOrpFt0s9Fus+u0CYygC/rPBUAkdvjapKHi4pjcubs8XEQLGxv9/6Mab6ndnVehd9XmxCj6h3LwCvvGfJygNbbnRyRc0e5KeNYOEk4Jkp9nIinGg3DTjy5Kw5+BOnxUlT2rbaQFgsUrn2k1twbM3s4rEtAMS81g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVxe6+XXU7tN/vVq3fkRss2i6F8wmNnq7383g+E6TzQ=;
 b=BJDLhld1G9EWz4eVHn25ShBvl5066X293bQrROOixeJSvC7khK9aKJkrd1xZGhwdvPxddfa2PuYjSVye7SWrZzMch5kWat8AfZLO8h28PbF6Pqn1E7pDABQMf429aqv3VTATkTo/tyFLXGFvg4CwtIVE1q4uhClw6qHc8gR5rHg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8707.namprd10.prod.outlook.com (2603:10b6:208:571::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Fri, 5 Sep
 2025 10:13:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 10:13:41 +0000
Date: Fri, 5 Sep 2025 11:13:38 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 06/13] khugepaged: add mTHP support
Message-ID: <9df57e91-3909-4ec3-a039-3ca29f741775@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-7-npache@redhat.com>
 <06d1b76f-039c-4d6f-a03d-9253b14b5e8f@lucifer.local>
 <CAA1CXcDPF5cHF8HEtc28AToyHpDeGLjgYD17X42U3ksiNAFvSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcDPF5cHF8HEtc28AToyHpDeGLjgYD17X42U3ksiNAFvSQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0665.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: 996615f3-2d1c-4a88-5109-08ddec64e343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTBCZnp2cUZzOTEvK29GdnNXN2w5RU81bU16TVFYcEovWHU2ZnNHWnVZZk1y?=
 =?utf-8?B?SzNRUS9pYkIrUDhtQkI4d0dEU3VWTVNaQ1R4U2NwWll3L2pOdTlKNzV0eXU1?=
 =?utf-8?B?eHAySytYbkV1M01VbUJ6blYwcUpYK3BXazBUZ09oL1N6Y3VUekoxL3A2RTMy?=
 =?utf-8?B?T1pkRUNqYlN6clVOUmQ3OExPQU1USnZCQWR1Tml3NUhiTndHT3dmL29rZDdi?=
 =?utf-8?B?SktTWHVEQ2tJTURNekNjRGdRenJsNHo0TWdqVHA5TU9zOXVLd25zTXY5M21r?=
 =?utf-8?B?LzJVMTFmQU04V1hZczVFcVplVTYxcDdaYVBxMGJFaEgwM08wQ1pnSzh4eHlD?=
 =?utf-8?B?Q2RnM3RkQjJxYU1OcVRjZVlqczR3Sk9rWFBUVmg2dGNCbTJ2UExxTm9JLzlN?=
 =?utf-8?B?N05wRUNjR3BuM3U5UUlnNWtrTDF5U1FucnQrR0JyZkN4V0N3V0VWQWdrZ2No?=
 =?utf-8?B?UGhuSWlYMzkzQkUrWTdGcmczZmRWRWlZNUFRakFNT2ZDa24wM1NZYXBaSjFu?=
 =?utf-8?B?aW0rQ3ZyRGxXdDZwTlNaTUJkRUhCVzh0RkVhQ2t5Q1RrZ1FkeVVuampnQU9o?=
 =?utf-8?B?NmlkVGpxV25mcmlWSzBiZFZSSk1uWkF5OXNCSDJiR2Yya09hZU8va24rVi9I?=
 =?utf-8?B?QzZFSTlWNG83RHo0MVoydVdqL2VCL2NNN1pUWlFCQzY5a2wzRFRXdFUvZjJY?=
 =?utf-8?B?dXUrSGJTQVJ1b0kxS3dLd1QxMWszN3F4WjFnY29UanQ2VzRTd2J1T0V1NGxv?=
 =?utf-8?B?ZXYyRG5OV1VrTmxhTHJpMzhZQndYL0EzQ05XMCtDT250WG1MT25ERkIzb1cy?=
 =?utf-8?B?cDRnRllvNTFSSStzdisyVHJSbXZ1em03UituMFg2VUd5QlU1NHc5ZVNwU2sz?=
 =?utf-8?B?SFZlZTJFaHJrV1N6ejhCL0VaOWMzTHduUVlOVHAweStFMWVzWGk1a1lGTDhj?=
 =?utf-8?B?MGozSWNreVVTcTFvS2JnZEh1V0RQejZ4RFJvV3lDNHlRMHJ0MTBUTklFL09r?=
 =?utf-8?B?eXU5a0R3Ry9Ld010YVdTVDBFcE9abmxIU3ZpZUxLMEh3bVg1QTN5OUdIL1BD?=
 =?utf-8?B?eDB2a3lkd2s0WVBUaGtrem5FenZjV1RWQ2c4cVZPOHp6bHdVdzdvRjV4ZCs2?=
 =?utf-8?B?VTlZSVJXYzhFaElyZy93WDQyc0dxbENLTHdPWGYrMk82cEVBNkVnM3NNSkxU?=
 =?utf-8?B?Z1hWYUYyeThlRlVlbTZxcXkyN3JRVThkL0grVXpRd1hlL3JKSG1YakpoYm1l?=
 =?utf-8?B?czNqUTVzNS9MRWtIRWxTRThJeGEza2pJZUhFTVJFTCsvYnVmR1hVOVlkVkM0?=
 =?utf-8?B?U0gvcndnYVhRZjhSSzc0ZUV0UUFsYlV0TzdEMEZjQkV3cHNlOGw3a2VZemEz?=
 =?utf-8?B?czEvS05VL2JXaW5RaEdXekpMR2lLTlIrTzZOREhBSVhvYnc2bkVsWDk1bDFN?=
 =?utf-8?B?VXVXNDFMdlZqZEVDNGpCMTI2RHR2TDFsMXc5dlhGM0hIWFlnaXlzVlhlVk9u?=
 =?utf-8?B?NVVvL0ZsTVF3NmVqZEdwZnlRUXRBN1lFR0l2NU9wRDlSR3BVZTFuaVJkY0hU?=
 =?utf-8?B?Y1FhZkY2bVhHbXNIYXNQbElISGJBUmxQUGU3VXQ4TXVnTFFMRmluTXBOVmNH?=
 =?utf-8?B?T3o0cTB1a3dwc1B1SS9PZ3JKOTA5TmNNdC9wWHZzZ0JEQXdsWCtVUW5pcDls?=
 =?utf-8?B?ODdXcjh6c0FnZ3lVek5MYzRHOE11WHgyZjcwTjFSQnIyRjNoaWFGc1o0aDJT?=
 =?utf-8?B?bVAya25JRVI3UG1iMkYzTVN2c3JHUlIrNkhvRW1adGgrYlh3MG1RelI1U0xL?=
 =?utf-8?B?ZmZ6U1V2LzMvWkE0bDJBaE1CVmF1cVplZ2czZ3dGbUZ1L1FYSk1Hd2hiZGV0?=
 =?utf-8?B?OElkUkUzMWg1MTRnWFZLQjhnYmdIclozQTgzV2dDMkpaS2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0ZuaGgwNno4N09TZHVZUmdVSWRwWnVEUUE3aS9wdXRHRUpWb09wZG5wMmdq?=
 =?utf-8?B?ckhJT2NhamJJUmg5eWNGa1dOOE1ybUZYc0ZVR0srbGVKa3RySDdrckpEVVAy?=
 =?utf-8?B?ait5cUNBS3kvUHVMVG5QOVExUFhienlJNHF2eVMvT1ZEbmlLV21MYnErd1Qv?=
 =?utf-8?B?SzR3YmRUVGR5QU8ySkY0eEdGZ3grS2JuRnFBVm1WbjNrNmoveFVpajFOTS9O?=
 =?utf-8?B?OUlER1BFc0w2bldKTmh3ejFpVDFBUzhvNENHK293bTZubEhYVE5ockNUMnV5?=
 =?utf-8?B?MWwzMm5zM3k3V1hpYmYvWkp5ZXhhdm1nSko1MkpOc08vbXRJU0UrVnd1MVRk?=
 =?utf-8?B?d0tlbGVIcGlpSkgycmZ3bElodHVkcS9lZ3BkbU9QSFpNem05eVNkZmxUaEpk?=
 =?utf-8?B?b21kT21vOEphSmNrTDlpUXF1NnZNQzZDQnhYYmtUd05ocW4xNjR1MkF2Nkxy?=
 =?utf-8?B?VlRtNWg2NUdOU2JJNURVNFVPOTdTZHUxT0Q0Zk02R3pDaHJjZGFIMjBKM3lT?=
 =?utf-8?B?R3B2VWJiYS9CNGpvVjZibFM2VDQvamE2S0oweFNpUXVrdVcwMTBDN2ZpaGRk?=
 =?utf-8?B?R2lMbllTci84NmFsdlV1cC9GT0RKMXA5OTJXejVJdEpQb29qS1owRTlwbGFk?=
 =?utf-8?B?VzQ3WEM0STEyRVdBUnlubFovcUhtdzVkekwvRnBqcHZ2SVJRYlNEc1dObURG?=
 =?utf-8?B?WmJnRVVJSUFUVWdNSDk4QU9XajZFbHJmRUtrTmZaZ3VTK0VwRm8yV3Bna1Ba?=
 =?utf-8?B?dDEyQmZ5TzlQVWt0aTFJLy94MU02OHkrNmpXY0hnNjlSOGh6NTFHMnhwTStF?=
 =?utf-8?B?bFZGU2I3M0ZWM2FJWFNzekpCd1FGTEtOWDVOMXFBQUlDbHpraDdtRUtqZWZG?=
 =?utf-8?B?YzI4YXJPdWhXSUVxL0ljUlNmQzl3d2xuTzJ2ajdSSnVuem9sNndWdHEwZ3dC?=
 =?utf-8?B?YXZwMUZOdHBHdFVXT1I2c2diQlZVQ1I5aDFVc2ppRGVIWnJsd1krd1B3c3NF?=
 =?utf-8?B?OTNyMG9SeWZEekN0MmwwcW5oSCsxcXZzbVZMd2VtZVNoK2hHaU5pQkMxMTN5?=
 =?utf-8?B?SEFPM0kzWml3NXdpMEtoU21rOUsvajF2ZGdhS1h0a1ZJRTg1d3A5RHl2Y2c1?=
 =?utf-8?B?M2E1RVBndE03YTZqVEpJWXlQbTVMTEJUdE1md2N5NEkwUGMyNVdacUoyWGZo?=
 =?utf-8?B?bTFNcnBQYXMzaTlRd3VMbEVPbmpweEFRZGNpaC9XcGJ4Tm1MQTB6cDhtcU40?=
 =?utf-8?B?eWZQNG5OdVRQSzZHa3EvelNDekVqWFZUU2NBcGwxQkcxTWVWdlJqTGh6S21l?=
 =?utf-8?B?d2xBOTYvb3dTRlhtUkVBV1A4c0Ruc0pjVk9pdmFGdzU0R0tzdlRWaEVWQWlY?=
 =?utf-8?B?aVpIRzBqekhnN0VZWFJGcEFxOG8rQktKTVhGS3QyS0x2YVgxTDlpNHl4bDdy?=
 =?utf-8?B?Uy9PUXd4aUx0RjdkWTBQdG0xbHJRUEl1VnlKcXFnN1k0SHJkaHJlSDd3V1Iv?=
 =?utf-8?B?Q0E2blhYRWlIVkx1cWRrd2lxMGdRMFNBcFAxWW5IQUpEeEV5TDRNSlpBRTB6?=
 =?utf-8?B?eGYrU0Q1UWdMa0hLOVFJL1FlcUJhM0ltckxYV012cGhIT0dGT1ZiR24vNzht?=
 =?utf-8?B?R3hySkNCNjNBNDkwWW5obEpWVTBTaWgxZHRCYWdpdGx1MU1ub3NuZVVxam5C?=
 =?utf-8?B?dW1yazZWNkhXQUdTNVpicDlZV0x3NjVjR1JGVThaMEdwQjkrakQ0aE1iY0Nh?=
 =?utf-8?B?eUFvNk5TVnNTNWtoZzBqbUJnalBsb1hXemgvVzZRVzlsKzBmaTFVMGZpalF6?=
 =?utf-8?B?WmtRWnNzLzdWa2FIbVNYM1NJR05kZC9CVnY3TGJ2OC85azJLWmlQeitNVmV2?=
 =?utf-8?B?OFBqbi9hcjhZanFHQkhWdThMZGdIcE13MEFSZmJrZU5wb1BzN0FPTG9uZ2Zm?=
 =?utf-8?B?ZHZlbHgrekFHd3dnbk9Yak55Mm1pUjk1Zy9VUEo0ZHZoS3E4d3Q2ckZCTlJi?=
 =?utf-8?B?NVdKbGtncUxmSXYvNGJ1WTVjQ0FMZWVpU1lGZVlpQi9HOC9tUlhxNG1YVU95?=
 =?utf-8?B?N2M5NjZxampnTjQwaXpMUUdDNWZ0KzZocHMxMndkTG5Na0dqT3dTREpLN1NL?=
 =?utf-8?B?bk5zZEoxRUFYcVliVmxsS2p3UHIrM0NFQ1NpbVNzVm5KbWhYRkl2S1dBQUxx?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	inHv7jJ59wAGJ3mCD2+2UhFR53TRGzwcWS8sAEyF3dSqd604Dy01wx8GhmbYfqM9nPaGY8oS0k0JVy48y9FL8MgxvKRaJbmZ7X0LTuK2bsvNCdT4VLnhwrePih/D6zdH5rcV5LobegZV0+OtmNa4Zz+gXEJe051qHxelxxYlWJsPCg/2lL/wakDztb2c1SZUNwYBf3o135Crcy3vecidkfRk2GZR8odpxZ0huNuGeP2XDeIFvTLOdCDfcrCWQcB+2c+PgooJwRklgBztFGTjha8rpctPKTOOaP5uLArOKjCxbuqwZnk96RRTjnc69sSznTEiz/HYvGwe6ZjfZ5hSVaQigwH6BfLiP8gmNec7p7sVQMwnWTfKHvDuuU/C14bEEDB2E1+ckDs7/vnJN1XIjO+haJV5VubvMX02zLUy/iPZRQ7r6Vo9cQk8my5KCGT3aw9pZMzeLaIrvzvWJlFdbaU8o5GG5wfRkbJ/mDiOqHMgDOGooWcoDI9FcGtCWUd7sVeoXhBmsojmRaO18yBfCABB1CW7dvw7zVcZlKrDWpVDnEM1D6YcIfBwweJUlJD+jICcewJ/klmOh6lZmeRClmRu1lMp6+pu+9mZ2Qiv5Nk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 996615f3-2d1c-4a88-5109-08ddec64e343
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 10:13:41.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1z0LyvZiiunYtmQhFLbkwJt/bQoRCrhi+QcHSIdG7lw6KyWHcODYLMM72SmpH9099lMNGVxzMww/zd7rhepfTt1vN5w7WAaXAWbRRcL4rFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_02,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509050099
X-Proofpoint-ORIG-GUID: f5xnImMncDUOlHlBx8RF_Smu6iBittFS
X-Authority-Analysis: v=2.4 cv=CsO/cm4D c=1 sm=1 tr=0 ts=68bab7f3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=BKpRfCiNAzjWXTe7lWIA:9 a=TlxykB5h4QRcbACf:21
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=gmshbCpD-_wA:10
X-Proofpoint-GUID: f5xnImMncDUOlHlBx8RF_Smu6iBittFS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDA5NCBTYWx0ZWRfX6GuZ4yIZUtQm
 I7WmWpJSyXlYh0xq7fskou4oRH2TLKh42Hui6HgTMNh7PjAjsNc6lKNzV2fIG+VrMlmxXqGWP3p
 bUP/N4LnvAKbVB5wCKuLDpa23wHGFpTqkAE5tWRJvKxvJDMS6aHHh/TLsKXIQKD2oW4WE5ri92N
 IrbQTdlEwYfK2g0sDjz3fC/irl//6VM0wFPhO7aC4LF341la8RQNNMzKJRWeZca7I8kmKd3PCmX
 oj16Pg3fg0lzV4qEzpK1KtDp3cfSzHFiC1+pTKg5aLBcoGOGJtRuBzzeJP6jqDGMuR3GO6jl/MH
 LwPHcXM3hq49mSiK2gwfXObHYHtm6E8mqosbhNhh2Z3MvSdhzHBo+uoiSbkP1yBbHuMpohh4vZu
 zVaE/x+I
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8AF04A001A
X-Stat-Signature: ybw4sf7ah13kzx5rrddjtmegkigxnsa6
X-Rspam-User: 
X-HE-Tag: 1757067275-305960
X-HE-Meta: U2FsdGVkX1+EtXsbUnfT07M1ysEUEIdyVAropX1eeKPWrP9OfA7f9tb7oOa255R0AfgzOls/a22GDwgAhx4bkzeht/mF1p3e7h1J2bRxDJJpsxyS3RKuGos/rcOiPs+bO36nR7nBMpWObk9cXUNSdpUBw2oSAihD1UprSwLg3jXjGyEnJxvN8Zuufw0nLm/Cd/8TcE6q+neLn0WihrGqMpIJa+bJGT9BHmQ0+z5owWVB4ggfqtgg0mIFxXcWcR7x7PxmIDTwKkIW25uEKa5RG1tXn82yruGLsy175peF71/szr3ha0hycIPGmb7pTKbyaGa5fg2SxA9G6tX8yGUVSUbhhJutehxPAgsSF9r2pkByrg0zpn8i/2RDH6kfWsBJXxKL6RMa1leQNRQ2BX8NejGYLcMF5Sx6OkG8iUgtNNOaOU4BARoGNiHSqXJAbVFgcdjFghI3DMpaza01TYet2HWVeZh1E8ZZyBrwCCbLwWbxJyyb/K0G0ziEvN2wXBe3vq5D7ekS4nSGEEJoaKS/GRJkDi/PjYGE/jFBCNzF1zbNqcrYgrwORNH+mziRERVYsqLigr4nIEsuUWfwaSPwPKOOLFDXgtwT3BgoaBRa1S+qycZ1SbVqbzW5oavZEaLyiPYIg5AaqC134w85s/lqTTHK3tGfVFI0j5uFZRKtTWjoWHwZ0cEQZKU+Bq7Nmsd51FAYGqA04ZzMBpShUv7avzeB7mCf0YW7Qwufk/QxYyUD450Me8oCTBX3AMpmakI50VjcLkWRfGF+zVdRm+wLOYnj7iMFqyY/mNqkdOunM/3C0auamX/xE51tJ3rDerpP+fpouu+pfYUzDEhTSXJUUaXom6+CVzJrWFi1YdN23maXgnc+eCDEbRELoLS3bh/xDyOo69rtF4bNq+Y7q6dfT6SzWj/uLTo6XbT/OvkK8MyKWgcUW1GLCeV/uYgMPgFRHNuowstGkNirC06BcuY
 zfUiMtCn
 xd2q8rI6pbojFgxIrqIBEjjMVysUkciNSi3EqziFYRcQelWC9zy+53vQggyLNXDvclyFjjz7zQBWZ1CsiBNLv3+o2MNodgQ2oggut76K/+xOqmm6m1G1mCORnBUWM2X0s5gMBjJXttwpBbuO/utjKHVkyhnXH4+nw//9GonuYRkjlJC9kuL8gawn9q2XNoEViaQNZJOe/RV/vOExqPpQIaIt5qiTo04mJnjsIwoTKiogXhoRasYst0wUn63i0BlJW+6mBcFjYiPE495pnpcW1wmoAbW77D7Dm8UxpnZhHvWbd2fMgXNjlOdrpRjnHmip5tF9JdxgTnEnmY0WkaZGZA0PBvvHPFhnZLAp1U269oV7xQnzigdKMy7+6BDiGvvhVJ1FO7DCQxUBQubt/j59zL9CPk0j5oQ4rPujDyTwFQRCPELBR6Gmm1L/rJ34wqAZcEjBnqSTk2jo1c2yFRZTsg/wB6mXG1N6Je7dxTD55ZYWRFkpu+l2m3zMB0JYdPU/GmKaFpW1nHdupeu7hepUUkKlvAzs0duz9JQYGacsSU0NCdqQav/RfVUph09Phrolqv91cuhrUSCtmaytA3b0vA7mYhpQeqh+qdz9llfZlWTbOT2ve/1Ru5BCMHyaWkJvENMRfxM0BUPPNWog8WgyFMt8GDC2Fmq0V3XyukCi2XN4M5Vat4kLh4gYJrhrpTt+LBN/ma6q1XZLEWm1OzU3Aou1JyaDEriWiTwOWFhkAXLP26IHT3RQt8kU6ZKLa5UmWJ7g84nVBuxM2uMuylP+7Lj8yyjokMm5gheUYJrKlqPCu1CRgV3tYo84xG1beT3ZAlkSmOzEOUwuwSBMDBamoYmVNAL8qSQqZ75uuZN9cInJ2pcu3+OVH4d3yAcAhwaejoc6UoOjXVk6omtQdZaR3QToR5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

You've not responded to a ton of comments, I'm guesing I should assume in
those cases you're acking the comments implicitly? :) Do let me know.

On Tue, Sep 02, 2025 at 02:12:38PM -0600, Nico Pache wrote:
> On Wed, Aug 20, 2025 at 12:30 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Tue, Aug 19, 2025 at 07:41:58AM -0600, Nico Pache wrote:
> > > Introduce the ability for khugepaged to collapse to different mTHP sizes.
> > > While scanning PMD ranges for potential collapse candidates, keep track
> > > of pages in KHUGEPAGED_MIN_MTHP_ORDER chunks via a bitmap. Each bit
> > > represents a utilized region of order KHUGEPAGED_MIN_MTHP_ORDER ptes. If
> > > mTHPs are enabled we remove the restriction of max_ptes_none during the
> > > scan phase so we don't bailout early and miss potential mTHP candidates.
> > >
> > > A new function collapse_scan_bitmap is used to perform binary recursion on
> > > the bitmap and determine the best eligible order for the collapse.
> > > A stack struct is used instead of traditional recursion. max_ptes_none
> > > will be scaled by the attempted collapse order to determine how "full" an
> > > order must be before being considered for collapse.
> > >
> > > Once we determine what mTHP sizes fits best in that PMD range a collapse
> > > is attempted. A minimum collapse order of 2 is used as this is the lowest
> > > order supported by anon memory.
> > >
> > > For orders configured with "always", we perform greedy collapsing
> > > to that order without considering bit density.
> > >
> > > If a mTHP collapse is attempted, but contains swapped out, or shared
> > > pages, we don't perform the collapse. This is because adding new entries
> > > can lead to new none pages, and these may lead to constant promotion into
> > > a higher order (m)THP. A similar issue can occur with "max_ptes_none >
> > > HPAGE_PMD_NR/2" due to the fact that a collapse will introduce at least 2x
> > > the number of pages, and on a future scan will satisfy the promotion
> > > condition once again.
> > >
> > > For non-PMD collapse we must leave the anon VMA write locked until after
> > > we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> > > the non-PMD case this is not true, and we must keep the lock to prevent
> > > changes to the VMA from occurring.
> > >
> > > Currently madv_collapse is not supported and will only attempt PMD
> > > collapse.
> >
> > Yes I think this has to remain the case unfortunately as we override
> > sysfs-specified orders for MADV_COLLAPSE and there's no sensible way to
> > determine what order we ought to be using.
> >
> > >
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> >
> > You've gone from small incremental changes to a huge one here... for the
> > sake of reviewer sanity at least, any chance of breaking this up?
> I had this as two patches (one for the bitmap and one for implementing
> it), but I was asked to squash them :/

Yeah it makes sense to combine those two, but maybe there's a better way of
splitting things out.

> >
> > > ---
> > >  include/linux/khugepaged.h |   4 +
> > >  mm/khugepaged.c            | 236 +++++++++++++++++++++++++++++--------
> > >  2 files changed, 188 insertions(+), 52 deletions(-)
> > >
> > > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > > index eb1946a70cff..d12cdb9ef3ba 100644
> > > --- a/include/linux/khugepaged.h
> > > +++ b/include/linux/khugepaged.h
> > > @@ -1,6 +1,10 @@
> > >  /* SPDX-License-Identifier: GPL-2.0 */
> > >  #ifndef _LINUX_KHUGEPAGED_H
> > >  #define _LINUX_KHUGEPAGED_H
> > > +#define KHUGEPAGED_MIN_MTHP_ORDER    2
> >
> > I guess this makes sense as by definition 2 pages is least it could
> > possibly be.
> Order, so 4 pages, 16kB mTHP

Right, misread that! :) sorry. I guess then in fact there is no such thing
as an order-1 mTHP? I did wonder how useful that'd be so makes more sense

> >
> > > +#define KHUGEPAGED_MIN_MTHP_NR       (1 << KHUGEPAGED_MIN_MTHP_ORDER)
> >
> > Surely KHUGEPAGED_MIN_NR_MTHP_PTES would be more meaningful?
> Sure!

Thanks!

> >
> > > +#define MAX_MTHP_BITMAP_SIZE  (1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
> >
> > This is confusing - size of what?
> We need it like this due to ppc64 (and maybe others?), it used to be
> based on PMD_ORDER, but some arches fail to compile due to the PMD
> size only being known at boot time.

That really sucks. Do please put this context in a comment though (see
below for more discussion on this).

>
> This compiles to 9 on arches that have 512 ptes.
> so 1 << (9 - 2) == 128

What I'm saying is - what is this expressed in? There's no information on
that here.

So from what you say I can see it's the number of bits required in the
bitmap, because we're being smart and only bothering to mark entries at a
granularity of minimum mTHP size.

OK so the idea is this is the number of PTE entries per entry in the
bitmap.

This is KEY missing context. We really need to spell things out here, the
THP code is... confusing :) to put it politely, so we need to be especially
careful to be mega clear.

So please please PLEASE add a comment explaining all this. And clearly
state that the unit here is bits.


> >
> > If it's number of bits surely this should be ilog2(MAX_PTRS_PER_PTE) -
> > KHUGEPAGED_MIN_MTHP_ORDER?
> This would only be 7? We need a 128 bit bitmap

Again missing context is you're storing bits per minimum mTHP as per above.

> >
> > This seems to be more so 'the maximum value that could contain the bits right?
> >
> > I think this is just wrong though, see below at DECLARE_BITMAP() stuff.
> >
> > > +#define MTHP_BITMAP_SIZE  (1 << (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER))
> >
> > Hard to know how this relates to MAX_MTHP_BITMAP_SIZE?
> >
> > I guess this is the current bitmap size indicating all that is possible,
> > but if these are all #define's what is this accomplishing?
> One for compile time one for runtime. Kind of annoying but it was the
> easiest solution given the architecture limitations.

OK, this context is fantastic + important for understanding, so let's put
it in a comment :)

> >
> > For all - please do not do (1 << xxx)! This can lead to sign-extension bugs at least
> > in theory, use _BITUL(...), it's neater too.
> ack, thanks!

OK sorry, based on David's feedback on this - just use 1UL << xxx here instead.

(An aside that isn't really relevant now but - also I was wrong to suggest
_BITUL() anyway BIT() is The Way (TM), for some reason I had it in my head
that the former was better :P)

> >
> > NIT but the whitespace is all screwed up here.
> >
> > KHUGEPAGED_MIN_MTHP_ORDER and KHUGEPAGED_MIN_MTHP_NR
> >
> > >
> > >  #include <linux/mm.h>
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 074101d03c9d..1ad7e00d3fd6 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -94,6 +94,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
> > >
> > >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> > >
> > > +struct scan_bit_state {
> > > +     u8 order;
> > > +     u16 offset;
> > > +};
> > > +
> > >  struct collapse_control {
> > >       bool is_khugepaged;
> > >
> > > @@ -102,6 +107,18 @@ struct collapse_control {
> > >
> > >       /* nodemask for allocation fallback */
> > >       nodemask_t alloc_nmask;
> > > +
> > > +     /*
> > > +      * bitmap used to collapse mTHP sizes.
> > > +      * 1bit = order KHUGEPAGED_MIN_MTHP_ORDER mTHP
> >
> > I'm not sure what this '1bit = xxx' comment means?
> A single bit represents 1 << MIN_MTHP_ORDER (4) pages. Ill express that better

Yeah again, this is the missing context that would have helped me feel a
lot less confused here :P

> >
> > > +      */
> > > +     DECLARE_BITMAP(mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
> >
> > Hmm this seems wrong.
> Should be a bitmap with 128 bits (for 4k page size). Not sure what's wrong here.
> >
> > DECLARE_BITMAP(..., val) is expessed as:
> >
> > #define DECLARE_BITMAP(name,bits) \
> >         unsigned long name[BITS_TO_LONGS(bits)]
> >
> > So the 2nd param should be number of bits.
> >
> > But MAX_MTHP_BITMAP_SIZE is:
> >
> > (1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
> >
> > So typically:
> >
> > (1 << (9 - 2)) = 128
> >
> > And BITS_TO_LONGS is defined as:
> >
> > __KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
> >
> > So essentially this will be 128 / 8 on a 64-bit system so 16 bytes to
> > store... 7 bits?
> I think you mean 64. 8 would be BYTES_PER_TYPE
> >
> > Unless I'm missing something here?
> Hmm, unless the DECLARE_BITMAP is being used incorrectly in multiple
> places, DECLARE_BITMAP(..., # of bits) is how this is intended to be
> used.
>
> I think it's an array of unsigned longs, so each part of the name[] is
> already 64 bits. hence the divide.

Yup again this is due to the missing context above.

> >
> > > +     DECLARE_BITMAP(mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
> >
> > Same comment as above obviously. But also this is kind of horrible, why are
> > we putting a copy of this entire bitmap on the stack every time we declare
> > a cc?
> The temp one is used as a scratch pad, Baolin also finds this useful
> in his file mTHP collapse useful for another use as well.

Saying 'scratch pad' is really just saying 'temporary' using different
words :) this isn't hugely helpful.

If we _need_ this we should give this a better name, and I also don't know
why we need this on the stack for all collapse_control users. Can't you
just have your 'scratch pad' local to the function that needs it or passed
as a pointer?

I'm sure it'd be useful to somebody to stick various temporary things in
vm_area_struct for instance, but it'd be hugely egregious to do so...

>
> In general khugepaged always uses the same CC, so it doesn't not
> having to constantly allocate this.

You're putting a LOT of data on the stack, and kernel stacks are very
delicate, I'm quite concerned about this.

BEFORE:

struct collapse_control {
	bool                       is_khugepaged;        /*     0     1 */

	/* XXX 3 bytes hole, try to pack */

	u32                        node_load[64];        /*     4   256 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
	nodemask_t                 alloc_nmask;          /*   264     8 */

	/* size: 272, cachelines: 5, members: 3 */
	/* sum members: 265, holes: 2, sum holes: 7 */
	/* last cacheline: 16 bytes */
};

272 bytes.

AFTER:

struct collapse_control {
	bool                       is_khugepaged;        /*     0     1 */

	/* XXX 3 bytes hole, try to pack */

	u32                        node_load[64];        /*     4   256 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
	nodemask_t                 alloc_nmask;          /*   264     8 */
	long unsigned int          mthp_bitmap[2];       /*   272    16 */
	long unsigned int          mthp_bitmap_temp[2];  /*   288    16 */
	struct scan_bit_state      mthp_bitmap_stack[128]; /*   304   512 */

	/* size: 816, cachelines: 13, members: 6 */
	/* sum members: 809, holes: 2, sum holes: 7 */
	/* last cacheline: 48 bytes */
};

816 bytes.

So you're roughly tripling the size of this struct and making this a thing
in all callstacks that reference collapse_control.

Kernel stack is a _super_ finite resource.

I mean I can't really review your stack implementation thing until you've
added a comment to help me understand what you are doing there (sorry but
it's just too fiddly for me to first principles it), but I wonder if we
truly need to be doing this?

I wonder if we can just put this into somewhere allocated...

> >
> > > +     struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_SIZE];
> > > +};
> > > +
> > > +struct collapse_control khugepaged_collapse_control = {
> > > +     .is_khugepaged = true,
> > >  };
> >
> > Why are we moving this here?
> Because if not it doesn't compile.

A reason as to why this is the case would be helpful :)

But fair enough!

> >
> > >
> > >  /**
> > > @@ -854,10 +871,6 @@ static void khugepaged_alloc_sleep(void)
> > >       remove_wait_queue(&khugepaged_wait, &wait);
> > >  }
> > >
> > > -struct collapse_control khugepaged_collapse_control = {
> > > -     .is_khugepaged = true,
> > > -};
> > > -
> > >  static bool collapse_scan_abort(int nid, struct collapse_control *cc)
> > >  {
> > >       int i;
> > > @@ -1136,17 +1149,19 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
> > >
> > >  static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > >                             int referenced, int unmapped,
> > > -                           struct collapse_control *cc)
> > > +                           struct collapse_control *cc, bool *mmap_locked,
> > > +                           unsigned int order, unsigned long offset)
> > >  {
> > >       LIST_HEAD(compound_pagelist);
> > >       pmd_t *pmd, _pmd;
> > > -     pte_t *pte;
> > > +     pte_t *pte = NULL, mthp_pte;
> > >       pgtable_t pgtable;
> > >       struct folio *folio;
> > >       spinlock_t *pmd_ptl, *pte_ptl;
> > >       int result = SCAN_FAIL;
> > >       struct vm_area_struct *vma;
> > >       struct mmu_notifier_range range;
> > > +     unsigned long _address = address + offset * PAGE_SIZE;
> >
> > This name is really horrible. please name it sensibly.
> >
> > It feels like address ought to be consistently the base of the THP or mTHP
> > we wish to collapse, and if we need something PMD aligned for some reason
> > we should rename _that_ to e.g. pmd_address.
> >
> > Orrr it could be mthp_address...
> >
> > Perhaps we could just figure that out here and pass only the
> > address... aligning to PMD boundary shouldn't be hard/costly.
> >
> > But it may indicate we need further refactorisation so we don't need to
> > paper over cracks + pass around a PMD address to do things when that may
> > not be where the (m)THP range begins.
> Ok i'll rename them, but we still need to know the PMD address as we
> rely on it for a few key operations.
> Can we leave _address and rename address to pmd_address?

No, we absolutely cannot leave _address as '_address', that's terrible and
I'm just not going to live with that.

I know it's trivial, but it's just such a horrid naming convention.

> >
> > >
> > >       VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > >
> > > @@ -1155,16 +1170,20 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > >        * The allocation can take potentially a long time if it involves
> > >        * sync compaction, and we do not need to hold the mmap_lock during
> > >        * that. We will recheck the vma after taking it again in write mode.
> > > +      * If collapsing mTHPs we may have already released the read_lock.
> > >        */
> > > -     mmap_read_unlock(mm);
> > > +     if (*mmap_locked) {
> > > +             mmap_read_unlock(mm);
> > > +             *mmap_locked = false;
> > > +     }
> > >
> > > -     result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> > > +     result = alloc_charge_folio(&folio, mm, cc, order);
> > >       if (result != SCAN_SUCCEED)
> > >               goto out_nolock;
> > >
> > >       mmap_read_lock(mm);
> > > -     result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > > -                                      BIT(HPAGE_PMD_ORDER));
> > > +     *mmap_locked = true;
> > > +     result = hugepage_vma_revalidate(mm, address, true, &vma, cc, BIT(order));
> >
> > I mean this is kind of going back to previous commits, but it's really ugly
> > to pass a BIT(xxx) here, is that really necessary? Can't we just pass in
> > the order?
> Yes and no... currently we only ever pass the bit of the current order
> so we could get away with it, but to generalize it we want the ability
> to pass a bitmap of the available orders. Like in the case of future
> madvise_collapse support, we would need to pass a bitmap of possible
> orders.

Can we just change that when we need it?

'Future proofing' for an possible future implementation detail is just not
how we should implement things.

Right now we don't do that, so let's just pass the order. If in future we
want to change it we can.

> >
> > It's also inconsistent with other calls like
> > e.g. __collapse_huge_page_swapin() below which passes the order.
> >
> > Same goes obv. for all such invocations.
> >
> > >       if (result != SCAN_SUCCEED) {
> > >               mmap_read_unlock(mm);
> > >               goto out_nolock;
> > > @@ -1182,13 +1201,14 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > >                * released when it fails. So we jump out_nolock directly in
> > >                * that case.  Continuing to collapse causes inconsistency.
> > >                */
> > > -             result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> > > -                                                  referenced, HPAGE_PMD_ORDER);
> > > +             result = __collapse_huge_page_swapin(mm, vma, _address, pmd,
> > > +                                                  referenced, order);
> > >               if (result != SCAN_SUCCEED)
> > >                       goto out_nolock;
> > >       }
> > >
> > >       mmap_read_unlock(mm);
> > > +     *mmap_locked = false;
> > >       /*
> > >        * Prevent all access to pagetables with the exception of
> > >        * gup_fast later handled by the ptep_clear_flush and the VM
> > > @@ -1198,8 +1218,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > >        * mmap_lock.
> > >        */
> > >       mmap_write_lock(mm);
> > > -     result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > > -                                      BIT(HPAGE_PMD_ORDER));
> > > +     result = hugepage_vma_revalidate(mm, address, true, &vma, cc, BIT(order));
> > >       if (result != SCAN_SUCCEED)
> > >               goto out_up_write;
> > >       /* check if the pmd is still valid */
> > > @@ -1210,11 +1229,12 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > >
> > >       anon_vma_lock_write(vma->anon_vma);
> > >
> > > -     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> > > -                             address + HPAGE_PMD_SIZE);
> > > +     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, _address,
> > > +                             _address + (PAGE_SIZE << order));
> >
> > This _address is horrible. That really does have to change.
> >
> > >       mmu_notifier_invalidate_range_start(&range);
> > >
> > >       pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> > > +
> >
> > Odd whitespace...
> >
> > >       /*
> > >        * This removes any huge TLB entry from the CPU so we won't allow
> > >        * huge and small TLB entries for the same virtual address to
> > > @@ -1228,19 +1248,16 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > >       mmu_notifier_invalidate_range_end(&range);
> > >       tlb_remove_table_sync_one();
> > >
> > > -     pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> > > +     pte = pte_offset_map_lock(mm, &_pmd, _address, &pte_ptl);
> >
> > I see we already have a 'convention' of _ prefix on the pmd param, but two
> > wrongs don't make a right...
> >
> > >       if (pte) {
> > > -             result = __collapse_huge_page_isolate(vma, address, pte, cc,
> > > -                                                   &compound_pagelist,
> > > -                                                   HPAGE_PMD_ORDER);
> > > +             result = __collapse_huge_page_isolate(vma, _address, pte, cc,
> > > +                                                   &compound_pagelist, order);
> > >               spin_unlock(pte_ptl);
> > >       } else {
> > >               result = SCAN_PMD_NULL;
> > >       }
> > >
> > >       if (unlikely(result != SCAN_SUCCEED)) {
> > > -             if (pte)
> > > -                     pte_unmap(pte);
> >
> > Why are we removing this?

You're missing some of the comments, I'm guesing for most of the smaller
stuff you're just implicitly acking them but this one was a question :)

> >
> > >               spin_lock(pmd_ptl);
> > >               BUG_ON(!pmd_none(*pmd));
> > >               /*
> > > @@ -1255,17 +1272,17 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > >       }
> > >
> > >       /*
> > > -      * All pages are isolated and locked so anon_vma rmap
> > > -      * can't run anymore.
> > > +      * For PMD collapse all pages are isolated and locked so anon_vma
> > > +      * rmap can't run anymore
> > >        */
> > > -     anon_vma_unlock_write(vma->anon_vma);
> > > +     if (order == HPAGE_PMD_ORDER)
> > > +             anon_vma_unlock_write(vma->anon_vma);
> >
> > Hmm this is introducing a horrible new way for things to go wrong. And
> > there's now a whole host of terrible error paths that can go wrong very
> > easily around rmap locks and yeah, no way we cannot do it this way.
> >
> > rmap locks are VERY sensitive and the ordering of the locking matters a
> > great deal (see top of mm/rmap.c). So we have to be SO careful here.
> >
> > I suggest you simply have a boolean 'anon_vma_locked' or something like
> > this, and get rid of these horrible additional code paths and the second
> > order == HPAGE_PMD_ORDER check.
> >
> > We'll track whether or not the lock is held and thereby needs releasing
> > that way instead.

You've not responded to this suggestion re: refactoring here.

I'm really not a fan of us arbitrarily messing with rmap locks like this,
and we should very carefully keep track of whether we have/have not
released them.

Again rmap locking is a dangerous area, I've got personal experience of
this (see top of mm/rmap.c for an indication of complexity here as well as
https://kernel.org/doc/html/latest/mm/process_addrs.html).

> >
> > Also, and very importantly - are you 100% sure you can't possibly have a
> > deadlock or issue beyond this point if you don't release the rmap lock?
> I double checked, this was added as a fix to an issue Hugh reported.

> The gap between these callers is rather small, and I see no way that
> it could skip the lock/unlock cycle.

We're going to need more than this to be confident, you need to clearly
justify why we won't encounter issues this way.

> >
> > This is veeeery important, as there can be implicit assumptions around
> > whether or not one can acquire these locks and you basically have to audit
> > ALL code over which this lock is held.
> >
> > I'm speaking from hard experience here having bumped into this in various
> > attempts at work relating to this stuff...
> >
> > >
> > >       result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> > > -                                        vma, address, pte_ptl,
> > > -                                        &compound_pagelist, HPAGE_PMD_ORDER);
> > > -     pte_unmap(pte);
> > > +                                        vma, _address, pte_ptl,
> > > +                                        &compound_pagelist, order);
> > >       if (unlikely(result != SCAN_SUCCEED))
> > > -             goto out_up_write;
> > > +             goto out_unlock_anon_vma;
> >
> > See above...
> >
> > >
> > >       /*
> > >        * The smp_wmb() inside __folio_mark_uptodate() ensures the
> > > @@ -1273,33 +1290,115 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > >        * write.
> > >        */
> > >       __folio_mark_uptodate(folio);
> > > -     pgtable = pmd_pgtable(_pmd);
> > > -
> > > -     _pmd = folio_mk_pmd(folio, vma->vm_page_prot);
> > > -     _pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> > > -
> > > -     spin_lock(pmd_ptl);
> > > -     BUG_ON(!pmd_none(*pmd));
> > > -     folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
> > > -     folio_add_lru_vma(folio, vma);
> > > -     pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > > -     set_pmd_at(mm, address, pmd, _pmd);
> > > -     update_mmu_cache_pmd(vma, address, pmd);
> > > -     deferred_split_folio(folio, false);
> > > -     spin_unlock(pmd_ptl);
> > > +     if (order == HPAGE_PMD_ORDER) {
> > > +             pgtable = pmd_pgtable(_pmd);
> > > +             _pmd = folio_mk_pmd(folio, vma->vm_page_prot);
> > > +             _pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> > > +
> > > +             spin_lock(pmd_ptl);
> > > +             BUG_ON(!pmd_none(*pmd));
> >
> > I know you're refactoring this, but be good to change this to a
> > WARN_ON_ONCE(), BUG_ON() is verboten unless it's absolutely definitely
> > going to be a kernel nuclear event, so worth changing things up as we go.

> Yeah i keep seeing those warning in checkpatch, so Ill go ahead and edit it.

Thanks!

> >
> > > +             folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUSIVE);
> > > +             folio_add_lru_vma(folio, vma);
> > > +             pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > > +             set_pmd_at(mm, address, pmd, _pmd);
> > > +             update_mmu_cache_pmd(vma, address, pmd);
> > > +             deferred_split_folio(folio, false);
> > > +             spin_unlock(pmd_ptl);
> > > +     } else { /* mTHP collapse */
> > > +             mthp_pte = mk_pte(&folio->page, vma->vm_page_prot);
> >
> > I guess it's a rule that each THP or mTHP range spanned must span one and
> > only one folio.
> >
> > Not sure &folio->page has a future though.
> >
> > Maybe better to use folio_page(folio, 0)?
> Ok sounds good I'll use that.

Thanks!

> >
> > > +             mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
> > > +
> > > +             spin_lock(pmd_ptl);
> > > +             BUG_ON(!pmd_none(*pmd));
> >
> > having said the above, this is trictly introducing a new BUG_ON() which is
> > a no-no, please make it a WARN_ON_ONCE().

This one is more important, please do do this.

> >
> > > +             folio_ref_add(folio, (1 << order) - 1);
> >
> > Again no 1 << x please.

(as per David feedback elsewhere, 1UL << instead)

> >
> > Do we do something similar somewhere else for mthp ref counting? Can we
> > share code somehow?

> Yeah but IIRC its only like 2 or 3 places that do something like
> this... most callers to folio_add_* do things in slightly different
> manners. Maybe something to look into for the future, but I think it
> will be difficult to generalize it.

OK.

> >
> > > +             folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUSIVE);
> > > +             folio_add_lru_vma(folio, vma);
> > > +             set_ptes(vma->vm_mm, _address, pte, mthp_pte, (1 << order));
> >
> > Please avoid 1 << order, and I think at this point since you reference it a
> > bunch of times, just store a local var like nr_pages or sth?

> yeah not a bad idea!

Thanks!

> >
> > > +             update_mmu_cache_range(NULL, vma, _address, pte, (1 << order));
> > > +
> > > +             smp_wmb(); /* make pte visible before pmd */
> >
> > Can you give some detail as to why this will work here and why it is
> > necessary?

> Other parts of the kernel do it when setting ptes before updating the
> PMD. I'm not sure if it's necessary, but better safe than sorry.

Unfortunately this is a _totally_ unacceptable justification. We can't put
in barriers based on 'better safe than sorry'. You need to analysis this
and determine whether or not it's necessary.

So the comment in pmd_install() seems to give an indication:

	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
		mm_inc_nr_ptes(mm);
		/*
		 * Ensure all pte setup (eg. pte page lock and page clearing) are
		 * visible before the pte is made visible to other CPUs by being
		 * put into page tables.
		 *
		 * The other side of the story is the pointer chasing in the page
		 * table walking code (when walking the page table without locking;
		 * ie. most of the time). Fortunately, these data accesses consist
		 * of a chain of data-dependent loads, meaning most CPUs (alpha
		 * being the notable exception) will already guarantee loads are
		 * seen in-order. See the alpha page table accessors for the
		 * smp_rmb() barriers in page table walking code.
		 */
		smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */
		pmd_populate(mm, pmd, *pte);
		*pte = NULL;
	}

> >
> > > +             pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> >
> > If we're updating PTE entriess why do we need to assign the PMD entry?

> We removed the PMD entry for GUP_fast reasons, then we reinstall the
> PMD entry after the mTHP is in place. Same as for PMD collapse.

OK a comment to this effect would be useful.

> >
> > > +             spin_unlock(pmd_ptl);
> > > +     }
> >
> > This deeply, badly needs to be refactored into something that both shares
> > code and separates out these two operations.
> >
> > This function is disgustingly long as it is, and that's not your fault, but
> > let's try to make things better as we go.
> >
> > >
> > >       folio = NULL;
> > >
> > >       result = SCAN_SUCCEED;
> > > +out_unlock_anon_vma:
> > > +     if (order != HPAGE_PMD_ORDER)
> > > +             anon_vma_unlock_write(vma->anon_vma);
> >
> > Obviously again as above, we need to simplify this and get rid of this
> > whole bit.
> >
> > >  out_up_write:
> > > +     if (pte)
> > > +             pte_unmap(pte);
> >
> > OK I guess you moved this from above down here? Is this a valid place to do this?
> Yes if not we were potentially unmapping a pte early.
> >
> > >       mmap_write_unlock(mm);
> > >  out_nolock:
> > > +     *mmap_locked = false;
> >
> > This is kind of horrible, we now have pretty mad logic around who sets
> > mmap_locked and where.
> >
> > Can we just do this at the call sites so we avoid that?
> >
> > I mean anything we do with this is hideous, but that'd be less confusing It
> > hink.
> >
> > >       if (folio)
> > >               folio_put(folio);
> > >       trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
> > >       return result;
> > >  }
> > >
> > > +/* Recursive function to consume the bitmap */
> >
> > Err... please don't? Kernel stack is a seriously finite resource, we do not
> > want recursion at all.
> >
> > But I'm not actually seeing any recursion here? Am I missing something?
> >

Yup this was before I realised it was an iterative implementation :)

Though we are putting load on the stack anyway...

> > > +static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
> > > +                     int referenced, int unmapped, struct collapse_control *cc,
> > > +                     bool *mmap_locked, unsigned long enabled_orders)
> >
> > This is a complicated and confusing function, it requires a comment
> > describing how it works.
> Ok will do!

This is _VERY_ key - I need this I think to be able to sanely review this
code.

> >
> > > +{
> > > +     u8 order, next_order;
> > > +     u16 offset, mid_offset;
> > > +     int num_chunks;
> > > +     int bits_set, threshold_bits;
> > > +     int top = -1;
> >
> > Err why do we start at -1 then immediately increment it?
> You are correct, it was probably a leftover bit from my development
> phase. Seems I can just set it to 0 to begin with.

Thanks!

> >
> > > +     int collapsed = 0;
> > > +     int ret;
> > > +     struct scan_bit_state state;
> > > +     bool is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));
> >
> > Extraneous outer parens.
> ack

Thanks!

> >
> > > +
> > > +     cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
> > > +             { HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0 };
> >
> > This is the same as
> >
> >         cc->mthp_bitmap_stack[0] = ...;
> >         top = 1;
> >
> > No?


> no it would be bitmap_stack[0] = ...
> then top goes to -1 (at state =... ), and if we add more items
> (next_order) to the stack it would go top = 1 (adds one for each half
> of the split)

OK, again going to need that comment to really grok all this... :)

> >
> >
> > This is really horrible. Can we just have a helper function for this
> > please?

> Seems kinda excessive for 4 lines and one caller.

It's code that's very horrible to understand using a very unusual way of
initialising a struct within the kernel.

And having code be understandable when the compiler can inline for us does
indeed justify this even in the instance of 4 lines and one caller :)

> >
> > Like:
> >
> >         static int mthp_push_stack(struct collapse_control *cc,
> >                 int index, u8 order, u16 offset)
> >         {
> >                 struct scan_bit_state *state = &cc->mthp_bitmap_stack[index];
> >
> >                 VM_WARN_ON(index >= MAX_MTHP_BITMAP_SIZE);
> >
> >                 state->order = order;
> >                 state->offset = offset;
> >
> >                 return index + 1;
> >         }
>
> This would not work in its current state because its ++index in the
> current implementation. I would need to refactor, but the general idea
> still stands

OK thanks.

Something _like_ this would make things a great deal clearer.

> >
> > And can invoke via:
> >
> >         top = mthp_push_stack(cc, top, order, offset);
> >
> > Or pass index as a pointer possibly also.
> >
> > > +
> > > +     while (top >= 0) {
> > > +             state = cc->mthp_bitmap_stack[top--];
> >
> > OK so this is the recursive bit...
> >
> > Oh man this function so needs a comment describing what it does, seriously.
> >
> > I think honestly for sake of my own sanity I'm going to hold off reviewing
> > the rest of this until there's something describing the algorithm, in
> > detail here, above the function.

> It's basically binary recursion with a stack structure, that checks
> regions of the bitmap in descending order (ie order 9, order 8, ...)
> if we go to the next order we add two items to the stack (left and
> right half). I will add a comment describing it at the top of the
> function.

Right, to reiterate - this needs a _big_ comment.

I'm sorry to split the review of this patch in two on this, because once
you do that I'm going to inevitably do the deferred review on the
algorithm, but I just feel this is the only sensible way I can determine
whether what you intend to do here makes sense and is correctly
implemented.

Kinda need that 'what you intend to do' bit. So it should be an expansive
and detailed comment explicitly explaining the algorithm and why you're
doing it.

Thanks!

> >
> > > +             order = state.order + KHUGEPAGED_MIN_MTHP_ORDER;
> > > +             offset = state.offset;
> > > +             num_chunks = 1 << (state.order);
> > > +             /* Skip mTHP orders that are not enabled */
> > > +             if (!test_bit(order, &enabled_orders))
> > > +                     goto next_order;
> > > +
> > > +             /* copy the relavant section to a new bitmap */
> > > +             bitmap_shift_right(cc->mthp_bitmap_temp, cc->mthp_bitmap, offset,
> > > +                               MTHP_BITMAP_SIZE);
> > > +
> > > +             bits_set = bitmap_weight(cc->mthp_bitmap_temp, num_chunks);
> > > +             threshold_bits = (HPAGE_PMD_NR - khugepaged_max_ptes_none - 1)
> > > +                             >> (HPAGE_PMD_ORDER - state.order);
> > > +
> > > +             /* Check if the region is "almost full" based on the threshold */
> > > +             if (bits_set > threshold_bits || is_pmd_only
> > > +                     || test_bit(order, &huge_anon_orders_always)) {
> > > +                     ret = collapse_huge_page(mm, address, referenced, unmapped,
> > > +                                              cc, mmap_locked, order,
> > > +                                              offset * KHUGEPAGED_MIN_MTHP_NR);
> > > +                     if (ret == SCAN_SUCCEED) {
> > > +                             collapsed += (1 << order);
> > > +                             continue;
> > > +                     }
> > > +             }
> > > +
> > > +next_order:
> > > +             if (state.order > 0) {
> > > +                     next_order = state.order - 1;
> > > +                     mid_offset = offset + (num_chunks / 2);
> > > +                     cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
> > > +                             { next_order, mid_offset };
> > > +                     cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
> > > +                             { next_order, offset };
> > > +             }
> > > +     }
> > > +     return collapsed;
> > > +}
> > > +
> > >  static int collapse_scan_pmd(struct mm_struct *mm,
> > >                            struct vm_area_struct *vma,
> > >                            unsigned long address, bool *mmap_locked,
> > > @@ -1307,31 +1406,60 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> > >  {
> > >       pmd_t *pmd;
> > >       pte_t *pte, *_pte;
> > > +     int i;
> > >       int result = SCAN_FAIL, referenced = 0;
> > >       int none_or_zero = 0, shared = 0;
> > >       struct page *page = NULL;
> > >       struct folio *folio = NULL;
> > >       unsigned long _address;
> > > +     unsigned long enabled_orders;
> > >       spinlock_t *ptl;
> > >       int node = NUMA_NO_NODE, unmapped = 0;
> > > +     bool is_pmd_only;
> > >       bool writable = false;
> > > -
> > > +     int chunk_none_count = 0;
> > > +     int scaled_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER);
> > > +     unsigned long tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> > >       VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > >
> > >       result = find_pmd_or_thp_or_none(mm, address, &pmd);
> > >       if (result != SCAN_SUCCEED)
> > >               goto out;
> > >
> > > +     bitmap_zero(cc->mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
> > > +     bitmap_zero(cc->mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
> >
> > Having this 'temp' thing on the stack for everyone is just horrid.
> As I mention above this serves a very good purpose, and is also
> expanded in another series by Baolin to serve another similar purpose
> too.

Yeah, I'm not hugely convinced :) responded there.

I can probably give more useful feedback on this once the big comment is
added!

> >
> > >       memset(cc->node_load, 0, sizeof(cc->node_load));
> > >       nodes_clear(cc->alloc_nmask);
> > > +
> > > +     if (cc->is_khugepaged)
> > > +             enabled_orders = thp_vma_allowable_orders(vma, vma->vm_flags,
> > > +                     tva_flags, THP_ORDERS_ALL_ANON);
> > > +     else
> > > +             enabled_orders = BIT(HPAGE_PMD_ORDER);
> > > +
> > > +     is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));
> >
> > This is horrid, can we have a function broken out to do this please?
> >
> > In general if you keep open coding stuff, just write a static function for
> > it, the compiler is smart enough to inline.
> ok, we do this is a few places so perhaps its the best approach.
> >
> > > +
> > >       pte = pte_offset_map_lock(mm, pmd, address, &ptl);
> > >       if (!pte) {
> > >               result = SCAN_PMD_NULL;
> > >               goto out;
> > >       }
> > >
> > > -     for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > > -          _pte++, _address += PAGE_SIZE) {
> > > +     for (i = 0; i < HPAGE_PMD_NR; i++) {
> > > +             /*
> > > +              * we are reading in KHUGEPAGED_MIN_MTHP_NR page chunks. if
> > > +              * there are pages in this chunk keep track of it in the bitmap
> > > +              * for mTHP collapsing.
> > > +              */
> > > +             if (i % KHUGEPAGED_MIN_MTHP_NR == 0) {
> > > +                     if (i > 0 && chunk_none_count <= scaled_none)
> > > +                             bitmap_set(cc->mthp_bitmap,
> > > +                                        (i - 1) / KHUGEPAGED_MIN_MTHP_NR, 1);
> > > +                     chunk_none_count = 0;
> > > +             }
> >
> > This whole thing is really confusing and you are not explaining the
> > algoritm here at all.
> >
> > This requires a comment, and really this bit should be separated out please.
> This used to be its own commit, but multiple people wanted it
> squashed... ugh. Which should we go with?
> >
> > > +
> > > +             _pte = pte + i;
> > > +             _address = address + i * PAGE_SIZE;
> > >               pte_t pteval = ptep_get(_pte);
> > >               if (is_swap_pte(pteval)) {
> > >                       ++unmapped;
> > > @@ -1354,10 +1482,11 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> > >                       }
> > >               }
> > >               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> > > +                     ++chunk_none_count;
> > >                       ++none_or_zero;
> > >                       if (!userfaultfd_armed(vma) &&
> > > -                         (!cc->is_khugepaged ||
> > > -                          none_or_zero <= khugepaged_max_ptes_none)) {
> > > +                         (!cc->is_khugepaged || !is_pmd_only ||
> > > +                             none_or_zero <= khugepaged_max_ptes_none)) {
> > >                               continue;
> > >                       } else {
> > >                               result = SCAN_EXCEED_NONE_PTE;
> > > @@ -1453,6 +1582,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> > >                                                                    address)))
> > >                       referenced++;
> > >       }
> > > +
> > >       if (!writable) {
> > >               result = SCAN_PAGE_RO;
> > >       } else if (cc->is_khugepaged &&
> > > @@ -1465,10 +1595,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> > >  out_unmap:
> > >       pte_unmap_unlock(pte, ptl);
> > >       if (result == SCAN_SUCCEED) {
> > > -             result = collapse_huge_page(mm, address, referenced,
> > > -                                         unmapped, cc);
> > > -             /* collapse_huge_page will return with the mmap_lock released */
> > > -             *mmap_locked = false;
> > > +             result = collapse_scan_bitmap(mm, address, referenced, unmapped, cc,
> > > +                                           mmap_locked, enabled_orders);
> > > +             if (result > 0)
> > > +                     result = SCAN_SUCCEED;
> > > +             else
> > > +                     result = SCAN_FAIL;
> >
> > We're reusing result as both an enum value and as a storage for unmber
> > colapsed PTE entries?
> >
> > Can we just use a new local variable? Thanks

Again you've skipped a ton of review comments here. You need to respond to
everything.

> >
> > >       }
> > >  out:
> > >       trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
> > > --
> > > 2.50.1
> > >
> >
> > I will review the bitmap/chunk stuff in more detail once the algorithm is
> > commented.
> ok thanks for the review.

No problem! :)

