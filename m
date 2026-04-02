Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6012ED6AB17
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 23:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7CE6B0088; Thu,  2 Apr 2026 19:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8691A6B0089; Thu,  2 Apr 2026 19:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730996B008A; Thu,  2 Apr 2026 19:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 628DF6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:13:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35C3F1A0169
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:13:33 +0000 (UTC)
X-FDA: 84615169506.19.5FC04A2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E87480012
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:13:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UaKcxnIB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EOeHI0gK;
	spf=pass (imf02.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775171609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIxPwIglMf3Jn5NxSySIV8QHHy0HgXwFtN4JvJuWXmk=;
	b=rjUQzykBnAzmiOat6Opg7yUU29cR8yNHbIlmPAI8gaExjA7evT5V0KGXXQXVqbohu+Hf+C
	acPjZV6+B624UTC5S0CU9VUgWznvE1yg4QHVyI03IXweFZ7zTK+TbxSMRI+Fy0TfrHqbv+
	HuJ8U507HqPzo1MQqa6nIMcilg8o8vQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UaKcxnIB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EOeHI0gK;
	spf=pass (imf02.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775171609; a=rsa-sha256;
	cv=pass;
	b=SjpCgqR6lh5b948sqMgnjaF/bQO5OugI8KPolaRC5VvMPKsqKAeOG8MPmbAHN+OwlUFkc+
	IIpUho453bLkLRztydzg8YMvNycnTAThrItSaQJabl4xHsKE+NkUMD3927PeXuryTN+nTN
	L+yR2I5j+zHl7QLnrazz5Lf1mf3xgbY=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FCaLg2207721;
	Thu, 2 Apr 2026 23:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gIxPwIglMf3Jn5NxSySIV8QHHy0HgXwFtN4JvJuWXmk=; b=
	UaKcxnIB3129oCkMl/iogItnlgBaMsINzfKmMCuM+ELSrTOHxIZ7Bo52MI04FEUv
	8y9Mj+3XtqZPEs7m3AAZ1XT6tEfiC5V9ydmqIWV5kej/2TDLajClrPR4dgkB7oU5
	uhczecGLA5VsK9U0gjLTc+/Oe0GxmFbWnjj9en1jnqZQ1UoID/cjeThyj1SxbaNI
	M7c0pzFDHfAqINYCj/lrKp1YRACekZeaHS+y3c+3ozc0iD7WvzDIEg11CYZBg0k8
	n9fEF2bgyNLH1kXGtf5i8wjshRdsEYhALreTb3qd6LgJrgx+AfvusUEHK8aBVMCw
	BfJ8zWpHmFIYTugOL2ib9Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d66v5sbeh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:13:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632L5EMi021206;
	Thu, 2 Apr 2026 23:13:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012065.outbound.protection.outlook.com [40.107.200.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65edj8um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:13:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaaKCfGpczhRluGD0cwKHqnlmFKAYQdILrYifXmjljDYDNINchO3oJ1XFSMbZswWPtbNcr5YJAJH6UR5aqZfA/S26WR8wPErtideC+N5p24+yVJaPLZkO0O687LUFQT4l6VY7YU+RrZPwIvTuiDinr+I9V49gxOGW2kTHABVHAt1uxIiZGIcdxwKSZbeAXsvoqLRTDcWJOw3GwSYYunn85KLwDEeG/pO8Ytm8j85wfBLFGVpA6IMrIOi2REebg5FJ8a0rBPaNB3+9b/aU/PNiyk57m3x1ZH6MOGXue3GtSz4DMgBwwYWT2CABtquEtbf2bNQexZzRl5BGQOWhRGtdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIxPwIglMf3Jn5NxSySIV8QHHy0HgXwFtN4JvJuWXmk=;
 b=ieG3XWvCHxzcl4jfW2XuokVarhV4oX8IueG+fLURHLxumrIaL/WBEe9J2UgKLj+48adGUvPJNZrcyFv9VVliGmAqxKGVpVE9By06bGsElWVEoc+XfxmtF889cY8HQ4j6UtFjbFl+VKnUcFBXS0JWct9yWxths7NNQeCfRuD29ACrav8MpjIQSg1MqTv+o2CD4K77cai1c99r5nVqHbnf8hBIE8XkpqSITeuFMiD2xT5uZ6iJLqEmBp3ykE3rK/EDB8La16zbmLb/GsOIRw/2Oeht7yB3EX3Q36NFZ7sHTtACQLpkZZWRX5ItJPSOqh+bDso7b2Cqu4zHNGkAG+98ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIxPwIglMf3Jn5NxSySIV8QHHy0HgXwFtN4JvJuWXmk=;
 b=EOeHI0gKBlwem9uXiEG9YSyoZl6mcRiofiCryEsPFsjN2NLGnKxgnq+5TxN1/M1ol+Qfm83rseTlkRN238p1x9TRhS0tGXSTIDxSu3RAyR2AIm/dbLGVj2ZGjmeP08L8d65NSKd/ALR8MkPQuCtjyAYEvhn/q6YHS6bFWVRmPbk=
Received: from SJ2PR10MB7653.namprd10.prod.outlook.com (2603:10b6:a03:542::22)
 by PH7PR10MB6459.namprd10.prod.outlook.com (2603:10b6:510:1ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Thu, 2 Apr
 2026 23:13:17 +0000
Received: from SJ2PR10MB7653.namprd10.prod.outlook.com
 ([fe80::f05:2c3:660e:b36]) by SJ2PR10MB7653.namprd10.prod.outlook.com
 ([fe80::f05:2c3:660e:b36%3]) with mapi id 15.20.9769.018; Thu, 2 Apr 2026
 23:13:16 +0000
Message-ID: <2f59c4e3-303f-4e13-a0a5-e1b5e5c1a37f@oracle.com>
Date: Thu, 2 Apr 2026 16:13:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: fix mmap errno value when MAP_DROPPABLE is not
 supported
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
 <20260402003417.438037-2-anthony.yznaga@oracle.com>
 <20260401174440.0f85ea303f0a027b50d99e5d@linux-foundation.org>
 <ca14b239-26db-479f-ba58-11e15f2379eb@kernel.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <ca14b239-26db-479f-ba58-11e15f2379eb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0071.namprd07.prod.outlook.com
 (2603:10b6:510:f::16) To SJ2PR10MB7653.namprd10.prod.outlook.com
 (2603:10b6:a03:542::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR10MB7653:EE_|PH7PR10MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b8b5a2-607f-4370-340a-08de910d6bed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	urGzMV/3zilHyJiF1TusDU9OrtH7ePTJ3TwZ0Nf969Ka51h11dq8PJOsolw59oAhjkBR1ecgzO118sXnTSHAuDrTWQgYeWbMFBvKdnWjrmhn7TgzApsGEYfkMMImOqCSh4IGCHC7elEC/K5AJGxn96cHOsz55bsssudMBtjZs3ejba+I+SwZK6/j/pWnSnJSAOgsZdYT6neFMN1Yz6wvV61p7tL7/5SEDvyQLU/sp6TvquEIm5lXYUjeyIkspe+GFbZgjVK6QZZQpgzDwWTxQMavhoI3C1FPzV8S1hjfFPSZgmMb5Nl4cPXbPVvQ380rKUtdfdXQYkGWkScpGFhSp7DeFYr2AE8+nmq8jGM1CS3008nLpWs5YqMVuGDE54CTtN72k2oDqP/pXh7Vdlv1QurL2CiVJNZH2gJ+zoCAFTGcESJ0K8WW/TOl//epP7wj8+WBAcvh2wsMUJqfBAe64+0OKERONGnxF0Tz1V93SNqHOIh8VjX2wu2qfo3eZ100REC9BYUCubzUwcGVFka0ZlQBIBdvJp9y3eDSzM5q1sR59UGk/OtVbmKY8jTgyAzevgRYtFR2Ju+9ux+Ku/5kSPtyek7SyBDn+zMRyKYCWRB3bidZysDSny5WAEwJnn78fsoMsizDgbcd3dTD7Y/2C1lMDIgtRA3RFUN3HZ5jhS+vRnvadkICTY3TwIUm/FpdFGlKEDiwOneT94p6Vag/uqSJMtbODiLZTxrLdyhfNXc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR10MB7653.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGJWaFh1eWxJNVd0OHBPVkM5ZC9oYXUyZDBGUm9FYitOWHdKQS9DWVBQQ2F2?=
 =?utf-8?B?d2JsZFB3dW9iaXpHU2dIbVFMd0tJTXJ5allUYlBrV0hlZ3VtWnNWYzMvNmJw?=
 =?utf-8?B?OEVlRHo5d2plWUNZaGx6SDV3V24xL28wa2JHejlkMHZEN29QNHdzWlVqQUFV?=
 =?utf-8?B?ZGpMb3NjenpDNGN1eHlxdStwQ2x4d3dxODlhMHY4QXZac3ovZHh3NzlGUC9s?=
 =?utf-8?B?NGdiaXRqeUxhQktGblZLUHlJeE1EYXNvZXFZUEhMUVhha3NXNzA3dFZjU0M3?=
 =?utf-8?B?L1N0RkVrMzNSeWFHR2pscXZMaDRZbkdVOWU4eUxnUFVVRHhUSHVvTENFbGth?=
 =?utf-8?B?T1I5OTVqSVkxSDVXK3gzK0hJZ3I3SzJzaVVWYUhNTm9vc2xlV3dsdThLQ25I?=
 =?utf-8?B?MlhUd0hOYVRvcVlIQUxvQStwcEpMQmxwNmhVTlBub2Erb242bVZtUGVtQ3M5?=
 =?utf-8?B?TC80cHpMS3J1YUNtWXIvWE1kK2FhbzdoNm4xLzFqT0J3ZUZJQXRsMGNTRHVn?=
 =?utf-8?B?SXNKVnpBcndJWGVMbGN2NXQ5UFVFblVOOFI1YVhhZ0ZQVFU0OHZhdVBpd1Ft?=
 =?utf-8?B?Ly93d3VCdzFPYjU3Vitwajg1UjRQMVR0K0xVMXV2dmNNNnNSWWFwYlkyZFhB?=
 =?utf-8?B?djVySmxOQ2ZYUVZGaldNK25UT1dNajVBV3R2NlZWSDA2b1FRWmJSSWhnWWhC?=
 =?utf-8?B?TlJwRnZ4alhYL1ZxdktZQm5qMCtyM0FGdVhiWjArdnFMaFBFcDJuaTcxeEk1?=
 =?utf-8?B?VExCRjVEcFBHZGhNSUVaZmpUUjRic3hOS3ZuMEdGWkxXUHdVN3J5WWZRTldJ?=
 =?utf-8?B?dXdsT2JYaktjbzFFVkFMQzJmU01XbUlJL3ZqdnpvbkZXaHF3K0x4UUhhV3Mv?=
 =?utf-8?B?S3NvZlV4WVJ6dTRRT2lEdXNFZ00wL0ptNHBHRHN5L3FRcFJaS2NERHR6RjdR?=
 =?utf-8?B?MnZ6RmdFNkpkQ0RrTmlINGc5Z2s3VThVc3RLanB3akZUTDNVVzNHOEdRWjM5?=
 =?utf-8?B?eTNoSnhSb2RhaEg0a2k1bWVJZXZ2Yzg5aEVBblVNbXozNFNlSW0zeGhRMjNF?=
 =?utf-8?B?SnBVZkN2MFFubDZPeUtPK2FTclBVQnhSY0Y1ZDJ0K2t5b24yTjlrelVVOTgv?=
 =?utf-8?B?Wkl3bHZLUlJvZHhQUnRFOHptM1puZDVHVmo3cUEzdm5jN3dVaW56MDdvbHBq?=
 =?utf-8?B?R1F2T0QzR2gyV1l3ckZPclV6cnczUEF2YTllTWNKcytxQlZoUWV3b0tmdXpV?=
 =?utf-8?B?T2IybmpBSDN0a0V6S0NtTGlVSDNCQmxkZ3JxRktRSVp4ZFZsZlEzNTJmaTlS?=
 =?utf-8?B?RDVmWm4zdXN3YnBCUlVLOFE2QkJua0NZaHE3ZnlyWEhtaE1qVlQ1aDhaQjhw?=
 =?utf-8?B?NkhCMzZjRFR4TldWSDVVWlF3TWNURTYxcHMvU2cxcmxLQU5ZdGRGWk8rcWww?=
 =?utf-8?B?VllnQXFNdEo4d0g1NFd6dzdNMkFTR2pZRkdFeXA4N2Vmam9DQjdveVF1ZjJ3?=
 =?utf-8?B?Tm0vc1JPSFUxM1lQcEZDcEFDcFJXRGRhcVoxSUZFNm8xYVYwT01yWXp2bHJu?=
 =?utf-8?B?QVpCcE9HdndyZXFobGhkUXl2blVZRXZnR3h3eTJraEo5MDV5QWVySXVtSjdM?=
 =?utf-8?B?UFJZQVdFS1Jycm5xS3Q1Y1o5RWx2bHRBd2tUcVN2REx0NzdwVFRkeTVCaUJ5?=
 =?utf-8?B?TklTQ3JFcmlNdUFwcUVIU2VOSDdPcUdLQjNTMlQ1OTJ0M0JzNUR4eitqUGtr?=
 =?utf-8?B?a1ZvdTVJeUZyWTNmTjlmYTZ0aWVHMzgrbUViUnBYMElWOFk5d3N0ODA4R3Fk?=
 =?utf-8?B?S2daWEhVaCthZHZLaEdWZWVvdzhKek9VeFBORzFYaDV3UHhrUllXZjI0V0ZY?=
 =?utf-8?B?eFpIUnRTSWRNR1AwOGtCdTVocHJrZEZETlpnRXkzSVVXWjh3Y1ZNMVFiSWhp?=
 =?utf-8?B?VzlLSE1CcC95VHBqMDNPTHpmMytud2RZTVdIT2hyclBsc1RuTnR3MDNWZHZH?=
 =?utf-8?B?cHI4NG9IZmRnRnIvTGs1TG05Q0pSaUJHV3Bjd2RlZDZHazhKZGJzQWlFdjNE?=
 =?utf-8?B?a3RaOHM2Tm9CZW93NDA3b1ZvT3F4Z1BsSHYxdGlpVXlOSE1qdVlWYm1XUTRm?=
 =?utf-8?B?TWtOSmlVcDAxNVhrSVV3MmNnTHZwUUtqelp1WkhyRWhHVmNYVHhoNjNBVHBx?=
 =?utf-8?B?ckdKREFZMSt2eTVWQjNtVDVJTUxnb0x5NnFMb3V2bU0zMFZ0ZXpVVWZHTm95?=
 =?utf-8?B?MkdHQ09NUFlKUXhCM2dCbEI0Z253eWNjQVhieWtZWEZIZHEvc0ZxL1A4V1NP?=
 =?utf-8?B?VThjWHNGT0lHSzlnZXB1QTZlamJLbGV1SzcwSmJ3aXdCYzViN3Q2YW1QeEdm?=
 =?utf-8?Q?lH2bzukW1vlmS5lo=3D?=
X-Exchange-RoutingPolicyChecked:
	E2bOABfEKcG4qPdpn2eWPaYWrZZnyCcaBZevS+3cR0uVbO/8LX0nxbvrDwafGAhkOqTjjDoXJAG81xTG26xXv9MMqpbWGvgGizc1IYIoc03mJ4mZnvDqIcRuzfi4lcUHy4hfEXCg1Gr0a7V3Oj+Ap87UDxo4Ad9WVeg+GaqkqxzIP9M0vX9XegrTS8nLkpXqBei0oHTGTRGt/X36Iq6UGiAUs9GAqGLmaV1RMeaDfxe4IzTJEu95+GgXbXSm8/I1GZmQjmwrPcngkVOUT+/rz+xl+hAN2kdcOkUZv6B2tvtQe+1KRuoJipwzhcqTfOrfxSugU7n9b6rIw2xe7eUtcA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IMvI5H+B5UUV6Tvlc0njAS+JJKBsifuNfnFve88VMQRtmBURzniXIEKuzFpgvzDQthoZMgTkgDFdOGvg+nZzRLqjMXfiP6OoxIF2cNtTpsT63itovwhy616E/pPU9wBJYDBcoMPmAXwfe6+mUQD0+2ruk17n4xXLH8TmG5dnhz8GMZNrHprvNvhOzjbDdfabN1bZU8uZYWQxAbeh4Hg//t2gYknewgY0EU2oYB5Wtg7toVWhk15aeC9hXtmLDa1+WPXMiXGP2WhT744BNBBA76OIbswVn5glFe/cQRYms6mu73scPVb0NkXWxQIUVHpcfEevtUeeNrTC+2sOPeEi9PxbBrXiNr3cn1Nkxp06U1CEtvEc+jNjUy9rkI0+VrDhlDvy45OFXQ5NrmlonVVYJ3fQSsWvUrNbGnWcvrFcraRRMzi9LStiPMCrsGc3JZe6qHoXB3VK1N3YKWUtRNnxnEWNSaYOPYe+EpthIGZiKl6S8WLDLyHl03Q+TcbYf7TpY5tiIuAiz4W868lJyX91wdCayHZWQt/QMs/U1TNdn63cU3lktFQ8IUXO26fzM9G4cDHfK4GV3wHxab0swi8+gwkcoKR+lIF2NwoYJnNqoPM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b8b5a2-607f-4370-340a-08de910d6bed
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR10MB7653.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 23:13:16.7626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8QVUBJCfWz4D3uVVtM9gYLjSYOhz+hlNk2uHKLafx6CmaGHhghuUhgylaDIQYvdY0J4qi0x89UsxqPjVRKlK56JT2Dc69wkHuHlKHu4fR1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604020207
X-Proofpoint-GUID: ZQaUbzErxP8keXkz1xuRAR2H0ULPUd_S
X-Authority-Analysis: v=2.4 cv=G7cR0tk5 c=1 sm=1 tr=0 ts=69cef812 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=VwQbUJbxAAAA:8 a=OiMHfeZHMkmyc8z7bLAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZQaUbzErxP8keXkz1xuRAR2H0ULPUd_S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDIwNyBTYWx0ZWRfXyDJtz6RxhRZ1
 fhBcNikxtzPPOOALXLEWTxzl58JF4D8N9UzTmeNoBz++xmhp1nYjmLcx7XQ+GQXynK8g6dCRI9L
 cg0Ojzl5Dp5Z5K2mewjUQ8Q+vayRGh0Nl5wb9D6o0E50fA10xHEWVaAzXdH04WW9V4c/QEyfbvs
 sqwk1O4npTUX5q5BGLUNmUk6IAqGnbQgqm4E8UM68SUtKrBPJETZa9Qtks5N7575HHAVqZtmtd7
 bvpWwu6ibA0EuBLmoXeI33p60eG00TWc2MMg/izHT7o9R0ZOi+9S1kfz1oD0I5T1S4JHytaYL9a
 QawPK4Q5n7hL8motfaofJoB/HsIxuPWFe0wolLD5dFJF5EuwVE7sJX+B4Iwj+TzvTrLHPaPA4mf
 Ky6P26fCEHP1tCA9XQFGgdOtMPi94jSicFjnuFtUMVI9zoJXAdnVIH3SdDFOptsexHK0rHNP+HK
 qETC4rnhNhJm/f6ONwg==
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E87480012
X-Stat-Signature: h93erjgqdp3xpxiuotrh4meyeqi78so4
X-Rspam-User: 
X-HE-Tag: 1775171609-506272
X-HE-Meta: U2FsdGVkX1/nulCeBlNf+XD12F3vq2DYTnC91KAIawjqmfyhNRoKmKr2UCb5YU2AT6yepHBkvfng2L347qF2rVGEkQK1fyrGiVltYTtECUQlV29K2BEXVweNWN59SeieBgN5q5zkWZv3yWqy4NBrQbFSG0k2qwnvI4rBnxgUd1lKnCIhQ2EaBLX++eW+Z/0HvOb0oXNDLZMXakcV6ZfH59Xws7YVc0PrY/aauNB5M4AR52TGtPNWY7MS8x/duZTWUsmHw5v1Dzo2bi9ziMznLLxh3LP38IONED0R0lrQO/oK60pztWq5mel+vGDNr3MORGSNYr9CSAWeWu/HORsSHWhl/jBldpv4PGvZP/pSWKeG3Q9LOpybHuyRxOvl0ieO4Dl20LEx2Iom9kxrpgRYB3hT6rk4Ep85VjvpmOL7mJytpfoGcB0zZFYLOQwNfbUylr2F2V/UpldRU8LAqG124HVLABHeEe3HrUajO4yroX+aWNuyWMhW0gQsyNqIJiJA/La+wAklqYgvXJ9vE71iXR5zvvnzGCxk04BbIP788hQFa7fPLp2U/Q1/JlHaxd6YQeX1M3XYocHylwVLisFlqnlmY7jhj6rRw40l3QMrh268yPs1n647bgD+fnWDqTyHJkDtqpDcQGspSEEgqkSJGhhHAqedjxRVn2XYmaza3l3Vf9mhwE0ZV4XpT3NlybK8a/Z5EVkReO4vHPfy09T1lw3uOVZoDMjEpmbyaQo7+pe3Vu/nEHUfQ7CtLixiLAxB7P7Fk+81F2UBWvT3o8BsWKX3X0qwXGj+VOajDSLTCNMtBsPeK9ZXO70SPBJkCuojXXkkrOI1S5tYAO66yY6kfqndS8UZkAvyMIWAZO8ITVGHP5tF5++b8vnzmjj3W08qMLD+cM9WTBJCwY/2up8FgkRmGtd8H/tVFbqtddpASGMo7mK/LnP1lkW+Q7U8DWr45bAa1cLGOc2JXBTztkN
 t3+pVvRi
 i36MIF2ASGncBQa/enVdpN4W+Mbcy+nm9JrvChq4+QUWDfTy48pu8Ox7AGDz8w/JHx1Kku8+pqUa3iqQRi3sodS9ay/6aLvSu4urjnm/M22dV9lsNP67Z5xWc6MXjHstFhTUfvtmh8yahna97Sb1lP2hC+nKhEkytrszRLUG3aqTrLaMQmENak6ibaadetEnK9T+Vi9PQGn+MaGbLi5+ts4SjDVIxpa08WAIeOqV6Rz3N8uU+wJEps8lP9Uth4pUz+/ID2+w56lEaZHKVaUoZjjx/LgzXsys78vHf1tPdYreSRwjDWdL+SyY8EJi8yPotA+E3uYl24/LT08uibRVuNINruQlh9kDVs/I9owh9R+OP+0sE1s+8FuWfAstKMAoeKNBLJYd4Uid0owfGF/PYMa+AAHxxSeQ65AlY1DNDGhaFCcV+W6I0D+mvWn4IxrF2uOak1V5rSb/P0UlNfuRTKuDs8vAYEh5sc4N+A3Qe5hNZ4xlgQ2HiIGizHVZfmhUdoAuZBHZWMb1+AuXpmB3zAUfT7BAlqhsfUCtLlcYqjLfr5cl/6R5L4N3fBz5MBoJ0PQR7LN6sDGt0QbPJ+121KDxw/yjLt9JkYstxdL6HUAthf8OODvJXXlUhZsQLFfUzt7JPFafrIVPWbCW8CrggJimlcxOZRxLNSgjWsSJEzURjm9mdFCxM4NTkr+AzmxRMztWqElaqSfij1RlXXiDCCaTGH1KWWE5L4mE3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/2/26 12:17 AM, David Hildenbrand (Arm) wrote:
> On 4/2/26 02:44, Andrew Morton wrote:
>> On Wed,  1 Apr 2026 17:34:16 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
>>
>>> On configs where MAP_DROPPABLE is not supported (currently any 32-bit
>>> config except for PPC32), mmap fails with errno set to ENOTSUPP.
>>> However, ENOTSUPP is not a standard error value that userspace knows
>>> about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
>>> checkpatch.pl has a warning to this affect.
>> Sounds very reasonable.
>>
>> EOPNOTSUPP is clearly a networking thing so what on earth is it doing
>> coming out of mmap code?  Our poor operator is now looking at a networking
>> error code and wondering what this supposedly non-networking
>> application is up to.
>>
>> But just that's a pet peeve - I lost that one decades ago.
>>
>>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
>> Nearly two years ago so I think I'll add this to mm-unstable for
>> 7.1-rc1 and shall let it trickle back a little more slowly than might a
>> 7.0-rcX hotfix.
>>
>>
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
>
> But
>
> ~/git/linux/mm$ git grep ENOTSUPP
> hugetlb_vmemmap.c:                      ret = -ENOTSUPP;
> mmap.c:                         return -ENOTSUPP;
>
>
> Should we fix up the other one as well?
>
I'm looking into this. It's returned for the case where vmemmap mappings 
cannot be split/freed because they are self-hosted due to memory 
hotplug. Many callers end up ignoring the error, but there may be a way 
for it to be propagated to userspace as the errno for a failed write to 
a sysfs file.

