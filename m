Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB09FA3755
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 18:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654416B0005; Fri,  2 Jan 2026 13:51:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6024C6B0089; Fri,  2 Jan 2026 13:51:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464D86B008A; Fri,  2 Jan 2026 13:51:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 317966B0005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 13:51:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5201C31F7
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:51:42 +0000 (UTC)
X-FDA: 84287917644.14.2964AAA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46A9E14000E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:51:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mqgRRZNv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uN10SZxW;
	spf=pass (imf26.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767379899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDTdXXRAMcBMdNaa6GLas6b5qkUKiuFp3IL7Ya+PhUw=;
	b=tS7ujJMAK1YpGzN0zEVq/+Qrljqvghmv6R9DXF9+Vt/RQHJa1FSIdh92FXR0OH1v0Jg0TU
	DFHAxPGvjWDtu1pexFLHJhMN07P3nBzaCHbPIzlf50iYv1K6XZ2H7QDD6rAptoJnDGr/Kh
	af5tLAyU86UzoXfjEID5ndg8UIbBnDs=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mqgRRZNv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uN10SZxW;
	spf=pass (imf26.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767379899; a=rsa-sha256;
	cv=pass;
	b=s59pEXeZwH3z/8S2U/xgVvhrbOTB8zjbD+hiIn05tjISPu3LOqQV+Wmxii96tHM3ZDWl4L
	74s6SJgsB9DXeEWbJoS0cVbUSLUpbtfr9XEsvrAO3MTv14yT8AYmFj/tBj3db00jaF7hTf
	Yer5aLi2ogtQAEpoWD0ch+CZj6vOSGM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602BuqPY2742087;
	Fri, 2 Jan 2026 18:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NDTdXXRAMcBMdNaa6GLas6b5qkUKiuFp3IL7Ya+PhUw=; b=
	mqgRRZNv8IE3zmJqbXyDryGB2MtONvV2Of5wGy9bkHnwls4qUjbNRzke/vUMqnX+
	+Fvi6DtwV5nJgLZgM3vNIZ9mQkwmgWOHzw2MhYmy2ptxDiTmGsolHnadWbGzGuEM
	//0kPx2h5Ms//7hFI17LDmO4pcGP/eBEASh7YdAsyqCiH+vkIFw8mPz+dSSjWA77
	7dZH0NfLuA41DQ4DcmYMEJq9XozqBzNAmatnJsI5bM00tZOmie0tr7PIoz6Jzf/3
	P9e/bMblQxFB1NDtvGndFpKyD3CIkuqLAMVOS3MfWlw9MjkHmu67VtlNSmT0h0YC
	lhMtaHFyM8gZa5iaMkmsFw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba80pwbfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 18:51:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602Gp14p029748;
	Fri, 2 Jan 2026 18:51:17 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wmmq4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 18:51:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hW+4Ct5XWSvyFgqxRXJTkCNmvmVa/7TvzeNe6KoTEQJrGTmMLGt1tmhJ5ROEyiE7XE/lRET4e0m52OMJJLMJaCfvmdBHTe9R19DSKbsIaFe06kr3iVl0obT929uN4Vy3ZXq+wGq5dC7g3jVWDYd5qW+ZTBUAbXNItCWAACbUBOsUXO+z8TXjCkkQvpGWysyHRcFnS31HSIi7SfT2SFSZoeA9bfRbOezS5eajZLUSHgjr+pGDw0UDWI2r05jI+O9W45WT2f6HKJOiaOeBE0QVSEaxJ10+1N3RHQDMPBxRiC54jICwwH2gWZq9S6FOBUTs+21n8Nd0VGaDBiyYv+XjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDTdXXRAMcBMdNaa6GLas6b5qkUKiuFp3IL7Ya+PhUw=;
 b=P5eesDq4lX5RGjBZ0GUQ4oz7MGFaUa9bSJ2B/VGJo6fOukAkn4oZk/NTdo8WbSr12xiib1fWu+DKD9hmAF/2dwqTVUf3IzSgiKqTnSPWrWJOR2iBNLcRMlx3AXprae0byGjTQuD2accK6/kgFr55bvoOQuufO/fcv40PDvOMEV9ANtQ2oiKOabtKA5RiOgilMlDRthBV0RHAHsllalq8zTa3ILcXUGEhWaWKojXsxz/CfLP5Tc3DJCnDYSEjI9WvKrpm6mD1xmrPQsxreOqRFq/rvp5eLm1wB4om75Dg367lAPqZmk0e9iBtuUY34VSwWM8BzWMImPB8kdPu1l7FAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDTdXXRAMcBMdNaa6GLas6b5qkUKiuFp3IL7Ya+PhUw=;
 b=uN10SZxW8Prmr/EaLU/8RURHoEFCHI/wT4bu2HNpLHIj9FXoTZUb/lGl5hiNYbEd47AC6U8yc4GDQjNz6MQFbVr3w2bv9ygasjy4KaY5vciwvbnm64qgKe3T4kV0X4+uQ67tEjLPH2V7k3SdZWIs2O9ioK1UvuPN24FFsQc2jwc=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by CH2PR10MB4150.namprd10.prod.outlook.com (2603:10b6:610:ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 18:51:15 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 18:51:14 +0000
Message-ID: <e9f0f249-10cc-4c78-b461-fa7e05a24c2b@oracle.com>
Date: Fri, 2 Jan 2026 12:51:11 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/6] mm: debug_vm_pgtable: add
 debug_vm_pgtable_free_huge_page()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org
Cc: jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Matthew Wilcox <willy@infradead.org>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <20251230072422.265265-2-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sid Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20251230072422.265265-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8P221CA0036.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:346::25) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|CH2PR10MB4150:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ff7b190-838e-41cd-97af-08de4a2fe7db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z25NZmJ5NDJtVVppVjNQek0zcVcrNDFWYzduMTZKaDF3dHpnUmhhYkFuRjVU?=
 =?utf-8?B?czBITHZKY2FPUGU4dkpxbC9aUk9IZ2E3OThhL0N5RXZnUFI1eVdhc0JYU3hI?=
 =?utf-8?B?SGJFRExNclpWT0xJc3VSVE5rUElvelJtSFBsSGs1Q2k3c0tSbHNzdm55bmlB?=
 =?utf-8?B?TGhQWUQxd2l4c3RIR3dpSWZTZXVrNVo5cHpUeVVFRjhCKzZQYkFJS2NHUk1x?=
 =?utf-8?B?RHJZRkk4SWFUdEF3NGU5ZUdKUExqQlVIVmxyeVBhb3dDM3VZbndOV2tNS1Bi?=
 =?utf-8?B?WWlGR1MyNER2UFovUWJlYXJLWlpMWG5FOGVvTHo3dGYwZURvYnVqdGFUNmIx?=
 =?utf-8?B?blN3L0FPUTBNTlM4QlQvZ3R3OUswOEY0ZDVXejBsZmhTMzQxKzVRSUZoVFM4?=
 =?utf-8?B?a2JueDY2MmM4blEyU3ljWkIybENkU2kvRERRbm80VlZYNFJ2YXRMdWhTdE44?=
 =?utf-8?B?ek0wZkdlNkp0TEZOTi9keWJiN1ZkalZCaGRnbk43amlRNVlGY0FmYzJyTklT?=
 =?utf-8?B?RHh2M1JERGtmbzBWMDRla1dGbjQzVDJFckt0MFYrbGpzVlNQMkJ4R1NlbWVD?=
 =?utf-8?B?WE9WSUlIR0R5OUFucEo2L3k0cjJHUHllYnVPQThXZWQzdGRuTjZrSit4OVV1?=
 =?utf-8?B?aWZNY0JKZ1hTaVMrNEJtRzY2bExGZkJxM2wxRnRSYzBnbVdKU0dPNW9iL3Nl?=
 =?utf-8?B?bjE0V2k2ZUtCNjhPeS9Eb09mWk9VQjNXd051RXRCUldraC9GTFA0ZGVZYWdE?=
 =?utf-8?B?Qm5UTi9xOEROeWVoY0YzMVo4K0VnRFJIeklvaE5nSnVRNklvM2hrT2VUZUcw?=
 =?utf-8?B?N1dpbE56OHZsVDIxWnFELzl6U3dxNDZhNllVTzF5dE5Rb0c1Y2dxTjJNRW5l?=
 =?utf-8?B?S251MFpscFV1QnJkaXdrcDZ1WjJNNU1KekZMc211UGZBN3U2QlpaNTVraXV5?=
 =?utf-8?B?aEVMT3ZPMmhZNWNNY29FcEh2dmJUaHhXSllYb0FRaThKNC8wc0Fqb3h4NnFO?=
 =?utf-8?B?NWtBbnFIa0gxWTdObm1vM2NOcDJHNHhUemthdlhOSGlsdXh2K3ZGd2Q2alRV?=
 =?utf-8?B?QldSbG9FU3gxL3JCYTNKV1YzdFZEektLN0N3TFBYYWMzSEZkSm9mbTV6VHJN?=
 =?utf-8?B?NlBXNU51dHdmQkRtVXplSExtSnM2ako5ZXJGcnpleE5aeXBwc2wzdjRZaU5D?=
 =?utf-8?B?MVFISTNRVlVMUytRRSs3bFUwTVFjM1o1aGlTV1NOVWpnNFFVLzRtQU1ERWVS?=
 =?utf-8?B?OURUWHYrdGc4MTIvQS9kaEpqb3V3MDkybFRxZGNyRng1WnBxRVA4OTB2MUhj?=
 =?utf-8?B?VEo4RUR5aUxIRTBHR3FQcWtzRTF6dWgvMUZ3NUtxRmdyM1JrZUgwSDk2RDFB?=
 =?utf-8?B?a1BWQWx0UjZNbWhtQ2ZJN1JoeG43eEpGVTdESVFhUmJLRjQzY3l1bnkzNmdK?=
 =?utf-8?B?eDg4eml5SGFRM2d2b0t4UXFMUCt3TEg5RVo4bVY4ZGt2OXhyd0tQSEpMZTZr?=
 =?utf-8?B?L0tyOWhKdW1ieEo3ckFMdVkrTzZaSUtZUEE4RXhIc2RDUzRqUlZBdnRMT3ow?=
 =?utf-8?B?aXUzRlVjS3JZWWpxL1ZGTXJNRzB0eGxJY1ZZNWM3NTUvUDBZK3hBSDRxMm54?=
 =?utf-8?B?RGxVYy9MLzRLOUJzcUEwVU43THRNc2NzaUpqV0RwT1RRZ1JscnJrOFBld2Ru?=
 =?utf-8?B?UGFZai9sTWFBUUpwWnpBQ1FHRlVEK0VZUmU5aHArUlNNaHZaM0NNaUwvR3VR?=
 =?utf-8?B?eTZ4WllLTDRBQlg5QlU1YnZYMXB0R281YUhRQmtLNWxWUmhRRWdLSTBRTWFT?=
 =?utf-8?B?M1F2UnArY0l4czdYd2pkbzhxVEQxNWNGa3o0YkI1VHl4aFlQNHVxejQ4MGYw?=
 =?utf-8?B?Y1NIQ0luTUFBUHJvQWtIWXJJd2N4ckNuWGNZVmoycHM4NTV2dnZMZHBMRDN6?=
 =?utf-8?Q?qFYaqeJ4ap5XNS8x2T9bdnHH1wnhMp8k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDBiM2hxOWFJZG8vL1QwWThrT2FLNnFZL1k1eWhmWjVaZTFUUXZxZHlHVWZ5?=
 =?utf-8?B?MHdpQ1Y5SkJwRG54RXdLSm5leVhhbkcxSlBZNC9kdTB6REFZNzJPM1lCZXRt?=
 =?utf-8?B?REFQMzFMMytnOHcvNHkrYkxDWExyZnprd3Bpb3dsYm44aVJKemliekVZUENt?=
 =?utf-8?B?Q0pDdHEzSmlUeEtHcmFUa3NRS0ZYN2hidGkxalo0Ni9IWDRQaXFpUXBCRUVZ?=
 =?utf-8?B?UnA4K0w4b0NPQVlBZ202RHZQK3pFcHNTelFScXBrQmROdmRRMVJLaTc3S29p?=
 =?utf-8?B?NmkyMDJ0UG1GeTRGN2IvMVdtM3JuRFFRcmFBdlMyY0hsTFZWK0d6Ky9RRFJU?=
 =?utf-8?B?cDlCRzRiak80LzZIbFI4ODk2RDJCR1IveXZWcDBsS01GM1dFdERWblQybkkr?=
 =?utf-8?B?YjNneUZDNk5TajNMczNlT0dzc1BESjZnc2VDajhoN3dvdGdMN29vOUpBNWpp?=
 =?utf-8?B?Ris2SFBTM3U5bUFnZ3h2dnhCQTRPbHNyTFBrVjc5T3FUbDluWis1cDIvYzdm?=
 =?utf-8?B?N1dYVmY0ZGliWmtpVDhFWXBZQTJmNmRrc1M3dWJFSFlvUW5yVWtNaUVQd1pJ?=
 =?utf-8?B?QURxRjBIK0FsT2gxZ3gyUFl2VGVmM05lYm9kd0djS0Npeks5NFhXYUNrQ09C?=
 =?utf-8?B?emowcnN4a2M1V2NNc3M2OXIzNFowdUdIM21MVFoxTHZzbnNOUTFpR2JpWTI0?=
 =?utf-8?B?ODN4M0NJb25HRUF0eXFqQjlMTm9lZldWVmM0c0dhTnlmcnB3endzeU9rd0No?=
 =?utf-8?B?WDJwZEFTVnFnVWpLZmpYUzB6blcxUE9XcDA5RTZaVkNsQjVJbk1LNDkxaEtm?=
 =?utf-8?B?UlpkUGZBbVBjc3VHODRHdGtnM2ZzWkFBaHRXS2JDWkZ6NUttaTlRQW0za3Qw?=
 =?utf-8?B?cGhKTjZQTGxmUnl5UklOdUE4aThHUUI3MmFqaFJMQVNGZmo4SUFTbkhEQ0ox?=
 =?utf-8?B?aUxzZzlXQTNUOEpwd1NkU2owNkZEK0xEdGFmUXFWc3NNTHFtaEQyQ2piV2FJ?=
 =?utf-8?B?N2taeUhXS3FuV3JWZC82L0pNUW5lT3V3TkwrZ3FlenZINkUzWTNWazRUaWhH?=
 =?utf-8?B?VUx6SElSQXMxcWVPVEVtZlUvSE9LeEVYV0RvcFlNd1BtUHRtNE15QmxnREJ2?=
 =?utf-8?B?MElCZ29mekRXUlJmZTZtS2Zjb2EvdGlld3NTSWQrL052ZzFQWXg2S0UxZUIy?=
 =?utf-8?B?S25uVHZGSldLbkE5eHFGV0RhZHpST0xXNHQ0VUdBVnRMUnBpOGQ1czZPcHRr?=
 =?utf-8?B?dlhPZGoyWWE2aWN5VkxTNG1QZi9UZGVmR1lLQzVZZHBPRktQdDkvMkJaV3Mx?=
 =?utf-8?B?OWpIalFrRVpGcnNKek9UbXhHYS9HcDNqTmJFN3RlMUJ3SkdnQ1JlWEQxMkh3?=
 =?utf-8?B?ZEM0bmpCeTlNSml0ODNJYVNxSm93Ymw4YmNZSzI4aTkzdXJVVXhHNWNaNnFz?=
 =?utf-8?B?WlQ4VXV1UUVxMnBuL3R0c0F4bGV4Rzd5Mys0dnMweGF0WTI3MVdHUlpVV3Qz?=
 =?utf-8?B?cGVkZjQ5Ym93NC9RcXZJZS84VCtYUzVjSk5scFgyRGNsSWc3S0lRNVhReUNC?=
 =?utf-8?B?VVVMUkFrVXBsRmxyREV4MEZsVk5VYjRnYWRDQXVXMSt3YiszaU9hRlQ1RXIr?=
 =?utf-8?B?emlPTmtweGxicVdNMkZpVW5SWmNlVk9tYk9JNmU3bHBmQUlneGNZeHluVGVn?=
 =?utf-8?B?b3cyMm1sc251U3Y1NHdCR2x1cEtVU1RzY0dRdkFXNzY5dERhenNhK2lDZmZn?=
 =?utf-8?B?M29XMjNFSTBuQ09TNnlVZWdZWUY5bjFqQmdpNnVwVzF5MWJkajJYQTd4RTl3?=
 =?utf-8?B?ZStrQ09JMFZTZXgvZktqU3Zzc21tVmlwSmx1elBSUlIyMlkwYlBrVGtzVUxS?=
 =?utf-8?B?WkNrUWZyam1jRG9SSld0a01jN1JaNGNLUjNwbjBVMWM0bVljLzlBZFBJQmxj?=
 =?utf-8?B?TTB3cmQxZzQ1NDc5bW9tODU5RE83cDI2emJpU1BWQ1pabGJobUxYRGhXYUZa?=
 =?utf-8?B?T3J4UmFCVU5IZFQzU2JBYmY0Y3I2cDI2S0t4Yi96ZUxEbHNJdUkwalJEQnk5?=
 =?utf-8?B?ckZjYVIxNC96TWxQZDl5dmRNc0FpUXdXTDlhTW1SeW5pQUhWT3UzeGxtUVhT?=
 =?utf-8?B?VkpKeU5hNDRaWFZsRmlnYjVGbThJQmRDRGVlRUE1OVNua0NPZmE4eVRaMTVt?=
 =?utf-8?B?WENaMVlCNXhPMm40S1Q1ODBFODlubUlZR29QTHNSUmRSRHJiOVZjclFFVFA1?=
 =?utf-8?B?SmVWUWhoWVBrQW5pNW5yZVFETUw2dXVKYmpIcXZJU2FjekowRnR4UDNWRjdU?=
 =?utf-8?B?MEI3QTJRYm9ua0hZNUpmdFhvNVpIVFBXNDV3QW9Walk5YXJTbkJLR2lBNkY5?=
 =?utf-8?Q?pSsd59Y4Do/xzoZY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iPnSoCw9zRTnfW9W1xuL4zATcwD+6QUOdMFtW3YFmYsYZAcRUq4V7M0GDodbVlj+MsQxR92QxyY8OwR58OyOqom8iFEIm9pRjO2T9fK2VyQ6xHU7K5tFHjYcZeh25FvK0tAvKS3A5eRnxpIcCfCnHwSoqswhrkWooiHNgTqX4TyN8tktMizOOoywIunJE/NDhpTR6oVOFweX/Jd5uIhrJYKpNYNypuiU+7chB+mNvuew4npLsvfh8b6/MpwTEYa96iDiQE/IT7z4tyi93oasEFxvWfDTrbq5Y0UIE3R+ZVaUP830fThyOuSdafK9mI0HaSooXgVGrwGLTdJfAdI8tU0Naino9GyjymMG9ctD3Q/2mg1ypxAUMNMaADwboYw0P8wpP025ABph7Om4FhJuBUoR2hTmiK9Bs2clTJiGalvFEp1NrTT4xkKVFb/l3sZeBHPAgVGqn1Cgcu7zjJPhoZIXz1WKcYxxpDcTip6tBphNOk/21xohS95N7buQAC6pEflMzfIt1AvsQQ3LuJBk5RWmGbHJs0JX2HZxNrAO/+oLGfn4Gff3PQ74+IExP/U4e8dDX3bf8UHIlvlWb001xfxfp9GL/5N3uoX38w5aMoI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff7b190-838e-41cd-97af-08de4a2fe7db
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 18:51:14.9151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NtnqwLcuDOYuqrgsry1SriBOi5P1AZm3ZThTeCDkZzBR2Io3Q8qzjL0bj62/AWkujNgn/Nk8NDxivN8+eoy6IQdwYivTmv114cc00C8OkdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601020168
X-Proofpoint-ORIG-GUID: OjrQ3bN9vtm1B1IqO-UikfggftaaBt3e
X-Proofpoint-GUID: OjrQ3bN9vtm1B1IqO-UikfggftaaBt3e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE2OSBTYWx0ZWRfX2EeHo0c4Xe83
 O8TbJt5fLUukr2sSkg2ObbQQCNEGc6dJeVE7l/FirekB4ngfnwS/jut4X1PqNxYHVOeTWy/vtEu
 Llf0PODODL/YX57dvYMsLYx270/V5uhZoIPBoNYv2kzXyY0A89zOoB52kTwGghx03/A1Z9Yua/n
 wVUIg46IaKwwV5aqUidD7a7jGtXJ9dRAmzIy2QBcNdm2emsy2AB9e/4wiBbLTZLo/a96t25OwyM
 nKYVzXJicYAZnR1dGUlmvlDBwfv/dYtVjjCc42cT5lX+WQJi2Qml1615/Nan4TVbo6lDF4hX8or
 8wou9VHr1+LNdidHdTeY3LT+XdI2Jcw36S3FME+cvTRKELOoPoHUpmZ6Kp+3ZiSAjsU7Rycv2zO
 BgK07KBs+fS6y7SwHr5lPzbtml6laOQRrXkaynCmiyfm6gzRGWmJTF81Hwbzb+QW96xBLYenA3c
 +I9D3pZxY90mSDtLGDjnEUajU0o4OY7swEnWs9mE=
X-Authority-Analysis: v=2.4 cv=RY2dyltv c=1 sm=1 tr=0 ts=695813a6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=-4a0Px_x7rCvGpxKnaAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13654
X-Rspamd-Server: rspam02
X-Stat-Signature: afdxjowwnbcupmqrkr3zpgic9wfhcsnc
X-Rspam-User: 
X-Rspamd-Queue-Id: 46A9E14000E
X-HE-Tag: 1767379899-267906
X-HE-Meta: U2FsdGVkX19koFYxg0eQiy2Rl+lri3bRrPHPSsVtJFDpg8aoC48jU6h4UK5GaouN/eMWa5Dm4tX9y/7dlmV94/1EPZcCP4Ooo3Yv9yhooTT3NsrFXj7Q/XhTdDfgYlfm/zHf+eihJbDhvdDm3CsXdwUjxTprn1//eZpbMtss36+Et5ejwxqwoMsQag1ZjyoIqXj+EKhpPJlNvVvib3Y/NF/qxZDKyaBkcl8Ygja1SEMuapNT9VsDBbOejS53OHzKR4XIT2T7gZx8zewpcVbxlL7N4enzBg92h8JM/b6Z0ICcCbsc76Zq6RWhNSD5UsU/n2qDDUrMrchOvKHKjitQuXCfsg93LBMoBLgyX2SYmHdxV/Q11BTGsG/pCtbEfAY6LSuqVrZrCRLrXD8uevZmUS8UYYvXnel1KSQR4/j8ubLMNmKoWX2Un+dgGmVDpVoZ4DfCS6BSG91aDhrasoB9RMro5/0jpxqxB8VfTF2qe09Dm8eEJXPQHnFLZQi3Lmu82nDfFPzlgwzORoCzZdGnzo5r7k8tALavzs8d87Xg7S20BMdJsrFBs7SuQ0D3q8ATiJ98f8hS5yZSuEg3FsVffl9Eb4WzNNgIjtl/f8T/yO0gf7hu02gY7YD8a79/rQROpem7roJlVxsjl4wpE0xtOk1/c6dQaSUoPOFGGpO2l3nbCDygCcDLZjPQX3YdYBnZ02f2Q9jeLcJ9P/Gge/KvW80d1Dk4S+W0Q39D2rmyAyTi0WtnlepVw7kndcPcThuRzI2MdhAUov5w1hv4YyhQHX2m/Jl76DqYkPfsQySqS7HDE04UO38gkzeMxI4Ydd8sKXW1G6O98AYHUiHklV15YxGw3iQRTlI4qiSDfEhK2TF5nZgLjc+nZKItinApivdfYI+edNKJAlC7voJOH+oQTXa5ZlBblZybQqbnV2D7+sSXal32I+BJx293Esis1VUHobMNnt0hopU5vGhnTrl
 4+JHxfz3
 SSMr62JLiZ+o7L3KIU+k6ougUfmtxaXaaRvNu86wkwf2HDNC/uudYlTzf0FITrMDfi6d9a04wLdsjSP/GifQkNLuMwr1X3H9itpNHzlmU33DmCgKwfshdzQH2VwepLgUseBpHMyx2oE1+aRiKtI4eBucpGWpI6yBaoZ5GcsfLBYkwGGfUoIZqV/kDc/8co68EMmQyve27OincpzjeaDWAvcloFpDSKIBBBOLOuze61VIenO4UYuncP5qN/zo5x8LuGfsxEHCUgMbDepvElwok499DDRpg0Nxr1j//V1CgjF94fU+XB0i0X+ykg/8cth4fN8tjbUa42pdIjOdi7CxkJz8KGKtCF6t77FAUrBcxXuCpXgDXOreduDQ3/owtvfnsicqwc/9jUFekJgmCPkQgUgQr8umC1r5jS3S4ZLrdQxzMcOSUNYifAqORFzkpmfBMd/RP0amd+Vi8T2vZN0BEmQIeuYB1EQK8aLai13vvfpsJ2mm4yeZsq5kUoE+8marwwoB0mEU+reLJpyYudFORDLiuxo+4VMyQtlBegGE8zaF2VVq6xrwDm3mcJVL8AG9Y745uxkpNoh4Dy37oiOROF1Hzuox4HwxlTGqvNouIEuYHKKfURV9W81cFd9tDSDe7W/9MsiYzthBJxvutTgG1hQ0JFrp0S4hZxXNi4CG4UlK9Uan8aD1xZyiXeqgDcoED9zmuZ9whWBnQBfUB9R8Ok3je0UcSPYUpqoeuHOx46l+s5hJIgyr3myK5fDyQfVHcKnDAT6YmMUQtOZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/30/25 1:24 AM, Kefeng Wang wrote:
> Add a new helper to free huge page to be consistency to
> debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER
> instead of open-code.
>
> Also move the free_contig_range() under CONFIG_ALLOC_CONTIG
> since all caller are built with CONFIG_ALLOC_CONTIG.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   include/linux/gfp.h   |  2 +-
>   mm/debug_vm_pgtable.c | 38 +++++++++++++++++---------------------
>   mm/page_alloc.c       |  2 +-
>   3 files changed, 19 insertions(+), 23 deletions(-)

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index b155929af5b1..ea053f1cfa16 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -438,8 +438,8 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
>   					      int nid, nodemask_t *nodemask);
>   #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
>   
> -#endif
>   void free_contig_range(unsigned long pfn, unsigned long nr_pages);
> +#endif
>   
>   #ifdef CONFIG_CONTIG_ALLOC
>   static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index ae9b9310d96f..83cf07269f13 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -971,22 +971,26 @@ static unsigned long __init get_random_vaddr(void)
>   	return random_vaddr;
>   }
>   
> -static void __init destroy_args(struct pgtable_debug_args *args)
> +static void __init
> +debug_vm_pgtable_free_huge_page(struct pgtable_debug_args *args,
> +		unsigned long pfn, int order)
>   {
> -	struct page *page = NULL;
> +#ifdef CONFIG_CONTIG_ALLOC
> +	if (args->is_contiguous_page) {
> +		free_contig_range(pfn, 1 << order);
> +		return;
> +	}
> +#endif
> +	__free_pages(pfn_to_page(pfn), order);
> +}
>   
> +static void __init destroy_args(struct pgtable_debug_args *args)
> +{
>   	/* Free (huge) page */
>   	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>   	    has_transparent_pud_hugepage() &&
>   	    args->pud_pfn != ULONG_MAX) {
> -		if (args->is_contiguous_page) {
> -			free_contig_range(args->pud_pfn,
> -					  (1 << (HPAGE_PUD_SHIFT - PAGE_SHIFT)));
> -		} else {
> -			page = pfn_to_page(args->pud_pfn);
> -			__free_pages(page, HPAGE_PUD_SHIFT - PAGE_SHIFT);
> -		}
> -
> +		debug_vm_pgtable_free_huge_page(args, args->pud_pfn, HPAGE_PUD_ORDER);
>   		args->pud_pfn = ULONG_MAX;
>   		args->pmd_pfn = ULONG_MAX;
>   		args->pte_pfn = ULONG_MAX;
> @@ -995,20 +999,13 @@ static void __init destroy_args(struct pgtable_debug_args *args)
>   	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>   	    has_transparent_hugepage() &&
>   	    args->pmd_pfn != ULONG_MAX) {
> -		if (args->is_contiguous_page) {
> -			free_contig_range(args->pmd_pfn, (1 << HPAGE_PMD_ORDER));
> -		} else {
> -			page = pfn_to_page(args->pmd_pfn);
> -			__free_pages(page, HPAGE_PMD_ORDER);
> -		}
> -
> +		debug_vm_pgtable_free_huge_page(args, args->pmd_pfn, HPAGE_PMD_ORDER);
>   		args->pmd_pfn = ULONG_MAX;
>   		args->pte_pfn = ULONG_MAX;
>   	}
>   
>   	if (args->pte_pfn != ULONG_MAX) {
> -		page = pfn_to_page(args->pte_pfn);
> -		__free_page(page);
> +		__free_page(pfn_to_page(args->pte_pfn));
>   
>   		args->pte_pfn = ULONG_MAX;
>   	}
> @@ -1242,8 +1239,7 @@ static int __init init_args(struct pgtable_debug_args *args)
>   	 */
>   	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>   	    has_transparent_pud_hugepage()) {
> -		page = debug_vm_pgtable_alloc_huge_page(args,
> -				HPAGE_PUD_SHIFT - PAGE_SHIFT);
> +		page = debug_vm_pgtable_alloc_huge_page(args, HPAGE_PUD_ORDER);
>   		if (page) {
>   			args->pud_pfn = page_to_pfn(page);
>   			args->pmd_pfn = args->pud_pfn;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a045d728ae0f..206397ed33a7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7248,7 +7248,6 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>   	}
>   	return NULL;
>   }
> -#endif /* CONFIG_CONTIG_ALLOC */
>   
>   void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>   {
> @@ -7275,6 +7274,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>   	WARN(count != 0, "%lu pages are still in use!\n", count);
>   }
>   EXPORT_SYMBOL(free_contig_range);
> +#endif /* CONFIG_CONTIG_ALLOC */
>   
>   /*
>    * Effectively disable pcplists for the zone by setting the high limit to 0

