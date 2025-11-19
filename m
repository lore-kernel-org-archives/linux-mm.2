Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE331CF3966
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23BB96B00CA; Wed, 19 Nov 2025 12:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC6D6B00D5; Wed, 19 Nov 2025 12:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03ED06B00D6; Wed, 19 Nov 2025 12:21:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFCA36B00CA
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:21:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89EEAC0146
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:21:45 +0000 (UTC)
X-FDA: 84128023770.19.5E0440A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3A86C80012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:21:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a3HPzvzg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RptmKaPe;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763572902; a=rsa-sha256;
	cv=pass;
	b=Dq5/ThB/CM5aMQbWlL9yJlIr3kKeuRsmOIlcsTEj9M2LJAYdWOWVw9nFAGVH8VYjMY15r1
	PEcX3qaVYbcG/vwSzwzufaFpJtSNlCyxvNucEy2ficPnjwUQPH0yxD9HcTh65hRXO0YMjk
	ZV7hzD+hOKST4fva/NeUFZfH5nB62KE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a3HPzvzg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RptmKaPe;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763572902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNuaSNG3Gq8QkTFCsDhcCaQWomasr1seVb3X6Gb2Ad8=;
	b=UcesoqdZF0+vKPBSYOyb8GDnADZa2JqGgjO44eJodsGuBinxUrWYE6gs2AcPm5RsmWcItl
	4JsWI/Mv0EI7t0kBn2iPuHhqr6aUV4Kay8HMsUtyRm8aiLr7agf0+SKVdXrMf+2kKO/OgI
	AQk/Iu95ylSJRxtiO/QMZjG2DYXbij4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJH1HVY013366;
	Wed, 19 Nov 2025 17:21:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kNuaSNG3Gq8QkTFCsDhcCaQWomasr1seVb3X6Gb2Ad8=; b=
	a3HPzvzgZQXRX77kHciVUH8vWW1rZQOk78LMQPvrkIPPPzlk/CL0IvM3nXenFCy9
	9LCLN5y3OzgB0ROicCDExqrQwWk1yD4B2hL3e2Q3liN6CrelUC8X3DcrHYDYoUW8
	1TPK5crrhnE6Jtg2U3W/o5HoIF84uPojWBIWOYbQTUzFEI5hhJiK6O7GP5zVbgqW
	IX0BQFR27hdw00FfXyDADnk2FtYIm65z9CzBNMs2DknMhX/BSs9sfUlt3b2n3Bg/
	q3zR/3iNqeheOHBAXtUTKoYNb2i8GOobNUJVqoEZI8TKIrzodW7C+fFAp68mKxRI
	ZXj01EUPF+ctQ5fKb7ku9g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej967f3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 17:21:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJHGY9l007160;
	Wed, 19 Nov 2025 17:21:36 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyawdd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 17:21:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsLmaCqK/DS65pV/u+lV94+wn1vcs0tULGC8oc5243HIggshB2sKA3NU+uXL32K/JaQV9w1oEXCBnvZZdBVBCGsy1p6iiiS5jZxE7Cdgmg10LFDbBhBFFVqecaOmJTzKjih9mkhZFTMhsb7lEik1J2Jjq7pedmDae3+tjJ/1QI9f2Wm1ImEfSYj+vmt1lX6wVDDTfrr8T3hL+nIdfkh3UrXti4JyvBTdPf/yM7dUDd2AR4SDHf7PYaW7JQDdjVHtAC0XfqiTBaHZCv1Da+hUzO4u3lte3beyyBXUn3Lmihd9BSTSsz+UVWevdO9nyLX5ijtJjNa2vwGFi7eUF7af7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNuaSNG3Gq8QkTFCsDhcCaQWomasr1seVb3X6Gb2Ad8=;
 b=C+VMvFhBnXBl4BXy7rY9R7LPdMFpcCoIZcvMx/tMCu74MCc795x2D0GAnedHCcaLFPTrmWAiS7Un/93eGseW19EPI6VNFJm+RLBiT46Ah07qw+xLR8baPrvhAHc0f+Av2KKws02duyfMSI/V8MtiuF1cSrOFUkDP65V/PYbFGN+fkV2NuaRe0Vqwkyine7zP/K1MSnk+fu0J0RbKdT5vtggyhsoUzyq87qZ4LrC8jdJLT2N6tSRySx1GNWtQKKq3+oyA+W/ZcqsG5d976n2BBFsLmFQybqWCasM6SbJCCgrPWsl7XPQRDvI5uIXCHkLPHEZ94iwDKPNyCW/XVBhf0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNuaSNG3Gq8QkTFCsDhcCaQWomasr1seVb3X6Gb2Ad8=;
 b=RptmKaPeVA8S0EKsMdr49/RFlcehhvdGrY2CdzemN6BVZXY8ICE7R4UyApOCFzW5TVFmS+l86OTtU91L4Y1KHoAZ8NN9bUiUN5brMByNtvWnr2mMWPx1Ntao+pu1jNqQREEVniO/uRG7q3KiOn5B3lVSy3ArgoHzq/bIAfo/Bmw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN6PR10MB7544.namprd10.prod.outlook.com (2603:10b6:208:46c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 17:21:34 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 17:21:34 +0000
Date: Wed, 19 Nov 2025 17:21:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: propagate VM_SOFTDIRTY on merge
Message-ID: <4df397b3-2b27-488b-b006-d024aef34f3b@lucifer.local>
References: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
 <955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
 <CANaxB-yqnMEP3zkoPcY8cHNh66UfHb8PNs9s7judRyJ8JC20pA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANaxB-yqnMEP3zkoPcY8cHNh66UfHb8PNs9s7judRyJ8JC20pA@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0501.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN6PR10MB7544:EE_
X-MS-Office365-Filtering-Correlation-Id: ad6a8697-c79d-4f73-c2be-08de27901690
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEo2VUtLNFpNRC9UeDkyK2Q5cjBIQzZhbWJjeHRjVmNkREJGRW1NWll1K1JT?=
 =?utf-8?B?ZWRGWk41MUF0WW9ZdFZzMjBXRHpNSFlydnlwSmhUbDhyOWFlNVYvNEdvTjk0?=
 =?utf-8?B?dmpmT1dBcE5IUG9YTnZYOGh2Q0hacTdESnVvbkFZUXNJOXc2L0kzZEYyVldo?=
 =?utf-8?B?cE9mdDhIOVpzWVBtbXNNVy9DT2UvVTduZVVJN1lwd2JraXkwMEhQdjF5MmZl?=
 =?utf-8?B?bkE3YmdKQVlvTE56dHM2RG9ISVkrTnBjOFB1cTFEZjgrNnNKVVAzZ25rMmEr?=
 =?utf-8?B?R3RFOGRtdmVSZWdHTGF2NU5kZ2ZPd1h6SThiNVNLbFhXRFFCUXRHdzltNXV3?=
 =?utf-8?B?aGNIdFZWSGRIRlROd2w5VHE5MVVicEl6M3Z1TVRxRWg1K3dVNFkzNW10L091?=
 =?utf-8?B?b1d2RE84YThNbHBVdHpQNHJkTEdmMHc2OUVlV3ZVMWw2UWhKTlFkSWZ0Y3hL?=
 =?utf-8?B?ZEJHcUNPTUlnckM3T1E2NW1mNFhWdzJWbjNTTlNKM0pSQ2NZTHQyZkZwNm9J?=
 =?utf-8?B?Y2RqMHJTTmRlaUpIRCs3cXZFUEVzbUdJcEp4US9DeFhKTTQvL3U2Wk5OblBq?=
 =?utf-8?B?aDZNUExCRW5xU2FMaUtWbjlzQlF3c3k4ZkxJWlhxUWtudDQreGh4V2hqVmlR?=
 =?utf-8?B?VXhhdVNRNFFiVVp5cG5tSlhVdzc4S2FyUlJGVHIrSlFlVGhnVWE4UG41V1Z3?=
 =?utf-8?B?aG1ZUXhUbTIxM2E3T3RoOERRdE5SQzdRVy8wWEZnbWZkeG1Kd1pOOTFFZWFV?=
 =?utf-8?B?bzdURTZxYUFlb1FJeXhsRHluNVduWmpGTHkyNldxQ1BaakFCWnR6MDNUUUxR?=
 =?utf-8?B?RkJzRFlvNDdmUGwxNXNtUFZIT2VBTlpWSW1XWG5xeHdxa2pWb3Vid21BN053?=
 =?utf-8?B?M0NvWW1MUWxpd3pHSUNRUC9MUFBOR0hsaHh6WVBZSlBRN0pWTnJEUlBvWGVI?=
 =?utf-8?B?TEpvczIvS1ArNUl1aDh2b2VxYWZES2lnbFF3ZlVjSTJxWWE3d25reUMyb0JT?=
 =?utf-8?B?cVo4NzVFbXM4Ny91Y2tHbVZMTCtFMm5LRnRqY01DQ2k5emF5Zy93bnVkNkc1?=
 =?utf-8?B?SGpXNGt1RDdOQzZQTnoyaXpDMGR3bU45SEpWd1JJL0ZJVVJTSFpqS1JPanlE?=
 =?utf-8?B?eUZzOE9LN0JDVlJQb0tHbDhlMGxnOGwwMXNMWGs0VlFRTzkwbkFLbjJsUVBs?=
 =?utf-8?B?eEN5MUxVZkUyc0I5SnJaUEcrV1JXaktmOTVvQVFsNjRPZWpuZWNQUVJYcFQz?=
 =?utf-8?B?eEJhck11QkFyYThGQTAzcnM2QzRCOXo4QTVpVkUweEdvY3BlcHlUbTZxUFZ3?=
 =?utf-8?B?REJIelJTM1dnL2YvWDFBcmp2NnJMZU9BQjhucHAyUEluT3EydytqSzdLK1Fi?=
 =?utf-8?B?bXBacU9mKytyV3ZuOU9JU0hIMjI2azdkTFhpRHNIOWt5cjdkMEVadGpja1ZX?=
 =?utf-8?B?MXA2d0xYQ25lU2lRMjlRU2NmTXVNOSswNWVGU1JDV3JmcmlnT0FYVEV5dHdX?=
 =?utf-8?B?NUd4aVZoRHpRd2lVUlREQ2U3dHZ2aElISGljTHByWDZEUDEyOUdNQmdvL3F1?=
 =?utf-8?B?RjBhd3ZTcEUzVnIyQ3JRQXAySVYwVVR4cGVuSC80c21DRHhaU3N5dkJkV3Jk?=
 =?utf-8?B?ZnpUZFY1Z2tpZDMzVWtDTjNFZHErSWNiaHJNQ1lHaUJNTE5qZEdDNTBoa3dN?=
 =?utf-8?B?NmJwYVhQZGlFSHpCWFd4WmNSM0o1bUZOaG5tck9MVGVHYWJCMVlpZVRwQXVI?=
 =?utf-8?B?K3ppY21IMmFqcHRkNlhwTzAwT09FV3FOSkwveWRlNHRmOHFSbE1yTlBNaS9S?=
 =?utf-8?B?QWNxUkFWKzhBNUo2clJjVSt6NG1zNGVoRjFlbWZyN3Y4SXNFakVvbVV3c2Vx?=
 =?utf-8?B?WHRLK05tYmVSWlUvY3QyanhrSjF1MHBMaVI3VWFmRzMrbitwRVJ6cU4vbm9C?=
 =?utf-8?Q?oPq241eXGvHBFdpAWRMYww052q0PJNcg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVlCSlhOK2ZSTkhIbVIzaW9ySjdvMFBhWVBlY0ovYnNuY1krVEs0Vi9jZW1z?=
 =?utf-8?B?RHRWeHdGTVJDcVhMejBHRU4xNkhiUlBzWmFMVjJ1R3pWeHhTOVJ1cm9pWVJm?=
 =?utf-8?B?cVZsRTZMYlNnU3ZuK0I5R0hTTVM4V0NOcERNSEpKTGgzeWJmK1E1YXhCS09K?=
 =?utf-8?B?L3JES2d6N0JFMitxSk1VbzRXQ3poaEx4Y0ViZ2MxVTRVQ1VibFdKTVJJL1lv?=
 =?utf-8?B?dGxVOWV6cXBtZWpVRVJxS1E0Wm5BN205ZXB5cU91R3RONHdRWGdKdGVsK3hq?=
 =?utf-8?B?NTZUL21reXhLLzl5dWtHUDBsUVpXQUlrRnJZb0s2akVBTXJlKzJFS2V4Qm5V?=
 =?utf-8?B?bDBJSkZaaGNwcS9PNnJzc1poT0JIY01ranZlRnVyc2ZtejFpWmE0VkxrT1Bu?=
 =?utf-8?B?TGx4RjF3c1psZDRqT0hBSElNUmVnckYvek45T1ZOWWlpejJOODNTK29NaDVT?=
 =?utf-8?B?czJwbk5rTHBQLzhuRmJJVjZBWDNvWjJvYTEvaDI0cWdjano0KzhjSHNCbzJx?=
 =?utf-8?B?TUtHb1JHVlp5MGhEa3BTZzJselhsQ2VCcDNoZDMxb0Q1TU84SmZJWW0zQ3dC?=
 =?utf-8?B?WUZvWUo0YndmdGVTakZhcnJGdUZTR2Z4eU9OOVU2NGtMYWZWZ0dCQjJub2FU?=
 =?utf-8?B?NHdOS1ZmWUJoRlA1bkoySFpRN29tK242STVvalBTYklYOXZHMkNrNEIrMk5C?=
 =?utf-8?B?SVFvbE5rMk8yUU1pZ0I2NC93NktaWkN6TmZSakpCZEZLTWhrOHpMdUFEYWZh?=
 =?utf-8?B?ekJJNmh6Y2NHdEVyU3YzelhEc0lNV3dlSmRYT0VOcDM3c0tGVGhHd291Y004?=
 =?utf-8?B?SnZ1c2dOVlFKdWZZOFQ4VTk0TGVHcmlaYXJSSVcvMnBrWUlXMXpyVkZZa0kz?=
 =?utf-8?B?SjVpSUJuMnprTFZzM1pxZm5uaVRPclMzQjUxRjlKcXpVaVNHcC9SbmVITXNT?=
 =?utf-8?B?Nm9JS1d2NHJ3NUxRNkJmRm9zTlJvMmpCQ2ZROVdHMVhkdDBaMDU3aWc3VFZM?=
 =?utf-8?B?Q2N4cTkyNGtXWG85MFBzUG5KQXJBZ0xUS1BxQ0Roa1ZmSk5qSjZCMHREcjJ4?=
 =?utf-8?B?S3JiSDgzamdSNXFVMVhldEVJSEtWbVdYMCtQWktyT29mSTkyd2Qyek1id3Qw?=
 =?utf-8?B?WGFMcXlQTmM3TG9VYlExMUN5cHhLNzZGY0YxQmI5L2kvWVhKbFZCaG9ZdGl4?=
 =?utf-8?B?ckJqaTl6SHZWdE8yNUpPUG9ZUjR5NnVuQ282Q0h1WWtJQ0JOKy9KY0NRT0hm?=
 =?utf-8?B?Y2N3cTVJTGs2c1p0eExoRWxWT3NIR013VTFVMkZ6MGFDamdhak41WUF1aXVz?=
 =?utf-8?B?QUhHaUlTV25NMHBLSzBwZnVlZW5TS2FKTExqL0JLZmhjME4xanRiK1kzOEd1?=
 =?utf-8?B?QXZmbmdsVHM2MVRuVWpjdG9kOWNsSHJlT0loTk85ZU9YRklpVEY4MTRPT2hl?=
 =?utf-8?B?QmNSaGgyWEE3K3ZrR3p0R2E1WHFkRGxZbG1tekcxekM5MGNhZjJMYm5Ccjgy?=
 =?utf-8?B?cHJ6Sk84ejdTaGpyWHpGUzhzNGYyckJmeE91dzZua3BZQlh4TEZxTmZkcUpH?=
 =?utf-8?B?dmFGMnVGMHJoQ25EeUFxdDRiNzZYVWxZYUxGTXJWb3llZnA0c3RoMzAxNHF5?=
 =?utf-8?B?eFZxUDNNK2hoVFJldWl6c0cxWnFYSTFRWlZlUEZ3SlZLUFZxZWIva0dGMzdX?=
 =?utf-8?B?cDljdy9ucVBGUUwvanRWMkF5TmtZbXVDQzQyTUNKcDRlZ3FjM0RTenBpUzFh?=
 =?utf-8?B?QlZjTUhuRnAzK1lma3N3NWk2UFd0aUxrWlFEOTIwWDdZNXVNeHdQcHhXQUwy?=
 =?utf-8?B?SGlDc0JTdHFyOFZVSERGTXhST3FaVExVNmpHcmpEUWdTaU5ZbTNINmMrRUs0?=
 =?utf-8?B?cHRwcE9iY2F1UWlSZ1YvWGQ2V1N4Y1l5N0JYUjUwdHVUMmtqcVlpakRrLzA4?=
 =?utf-8?B?MExkUmwxK0FpMElET09IanZiNndxQis5dGhmQi96OG5ab01KVnlCSXJZZytt?=
 =?utf-8?B?eGIwM2ZTQUs4d0VzZ3F5bHpKcEZmdmUwV3dySUNNY3VROEVDZjBxcTZBNlRH?=
 =?utf-8?B?MWJCakpKM2RyL2wyUmtGSTFuQkpKMGlOalBTbHVVOVFRYTc1Smh6QVRRcW5C?=
 =?utf-8?B?M1RaSVU1VWVtSXA1N1hpSU1pZ0dFTjBDV0xZYWhiMmw1VjQySWJwVER5V1ph?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZB/0fAQx7m0sopTZ5A4QulT/nhrqx8eXn//Zjiz81Iwn9LnJKgujmBmXfL8Wk8dMgI8FaZRnJsmTp6isWx7IdRU0+Lc0YPMy8nx13sHhZZM/l/o8i9DQhuEa276zg300e+aGG6s52cOepX18hZ+xtCk2tIueQlSrkoiA+Q7kGVBFm+wcoDK7vlGusl/fZ4kKsLasPoYSlT7gXNQsV3EKcznyu1wC5XizxhF35oIRjy1Ix7A0LuvaKJfZyfDudD/2kQdL8sHo1v/R1jYXQ3JB2E9qHQ8JVzLzNzVZGt1citPbB65/T+f1oqGlcJDR1TXzcRX8t8oLGsKoeqaBNUUTpEBeR+RJaDyxi7ueg5u5obmOXOhDYFASgHD4dk7B164FjPrSeS4cS1IAUcUzXWjYvjhetGaHRJQQX1azyvEowCRZhaCAysVI/P17VFyOxBPtNyxGpu0vZfeswlKjsz1A+h0h1tfxJ8ufIm7BW70+wwuxfh/B72DuwL0FAYEMjctDzBj56FuWLcy1Q8PdyAaC2Ms1t+GjOt8wAg7QCNi1CrUfLjDTJzxhzJ/WUY9/ujxUWTCys+GlwRnX0NlbY0mRVkJTsxvXp74r3RfeS5ZzKnE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6a8697-c79d-4f73-c2be-08de27901690
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 17:21:34.1147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+BLUzI3hIOR2IBIsKasdMqxIu9u3Op077pA+yYXMLZ/CfToYl34j7qZmSEoIHbMhLp83lMqgQGT86mFi395XUHcFsnG8VKjLIgQ8s8HM7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_05,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190137
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691dfca1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=skDiHgkuuOcfhPFwCzAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: -UCSJKvqW3mLuCo9UNo045qv4bAjKgaq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX9yFSYGUascX2
 +ZXCh03e2Go0bfObguRgSK1CZRzNrOYHBKknbuPndq91FI/zw4ukJjTS3PVzP/pxbvk7+AyQNIL
 m+gRwdVuWRPhGt5itlGeOUkXpd56NJgOZSrFs3FGE9VxuDOGp0GIEOAktAQmgYLTmE7VlmQlIBH
 j9K79IvjWLT0slgA/TQBJsldRh+X/xZ0dSQEnHC9ppIbS/r8eqfM06ifW+OflYEieUJYcmIlLyw
 pYPyT/EtsvwKgh9KelupBZ5I/qhOGXAJF5nIU+oJh5Jx9COJli4BKx5ljY45pOOtJHq0OZelEFi
 YYTSDxttOfhDaHcjnIGnYGGBnpPkztA3Gm2kEVeDO+VeJpc+xlCkaxWzKEU6bozPICCBJUeI91Y
 BOkcPa+/q1+4dviiXFQxdQWjR8D93w==
X-Proofpoint-ORIG-GUID: -UCSJKvqW3mLuCo9UNo045qv4bAjKgaq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A86C80012
X-Stat-Signature: gcuksquqbo6xf1pt4fwo79i7faenjy91
X-HE-Tag: 1763572901-637697
X-HE-Meta: U2FsdGVkX1+5G2/UhNrjQ48sXHK9UpXUl5S/d0ymJTUIc1ZpltJ29XpAYlw6Tt45eWvLd9xxtKpUV9QpuAumoB4lQGk+PzEw7jAM67vNoZB/7XH/0i1nm6QSBdWjelMr84waFVcEb/StdfsXkHzCX9tD8Qea/OhU6aEg3AOyz1SmIXjtbzhCid540klZL+EuOQTtFsIPjn1rUBcq+UYdxLTHaVK70stH/88g6hMfGRNLsWrCd2gzW6x0vDX3C7dxF0+pw6we02uCedm9WGmuUEpsA4p5ZjN1LGEy+2qmUB+aEKinoylRwP5z1kk35xZfpxnQcV/653FBPxf6JUHGo4B9rYxZvVkEyR2GUvSTaygoVOquiz8GAoaVQGaZuMTxwaDBUdubyS6yZgfI5mxmnIO6+H0jx2eKrM/ETzSSBxmNObvlJli8yELOrqYa0l4z0rG8nRYVJf5hvna9V+aNjn8CmKETYBuAN+ns6MuiHZo1OyhuVqsSlzjhhMr/8GIftorbpcY2RGedRDHTD/Uu2uCG+KwWLlcO/J94GDtv9LAd0RZ1B8gMegm37DSDY7USxzxXw7bUu/R3B+MyhRNYvzK8jgLn/yseF0Pz7D+wCJx2Ox3Sz7iEXaqrtEXYKr5o+ZknsRDJeo0eLuw6T9WZdtJIgJfef3Jh0muAJRFEcU/fGHgDPJTdivkVMKr/IW0TXeagLrs95Mynn003F2oXqhPDT9MzW5utwijTarShoU3Axq73yOAdC4XF6/rKfWXLtPuJkWCzVDQgzxNyGE/JT1kBDFbOQy3PQIoZl/VMC4zCrOxswuKUblfUqbrP/YeUrg2KMTJG+y+lprqYl55cwu3eKQkiWGeV9oZs84oOexVKEYco2wVb5hBM9qk252eRoC7ukkGWuLFyX1SSU6ZD3o/7SEsH/i6Pj8XDKt2V9+CSllEjn6bkMGbP5w62wc8/8H0PdFDwGU3vybFLxb8
 LH4UCOhQ
 VibTIpfehkC/o6Vj6xwECNkmr+eLsqHybQ45l7r0Vpf10EE2KUPH+TpUJOVdWh8ZFFMRj9TnJKVfmwyh3fYMPsfQHLX+SPYyNIydy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 09:52:52AM -0800, Andrei Vagin wrote:
> On Mon, Nov 17, 2025 at 9:40 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> > establishing a new VMA, or via merge) as implemented in __mmap_complete()
> > and do_brk_flags().
> >
> > However, when performing a merge of existing mappings such as when
> > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> >
> > This is because currently we simply ignore VM_SOFTDIRTY for the purposes
> > of merge, so one VMA may possess the flag and another not, and whichever
> > happens to be the target VMA will be the one upon which the merge is
> > performed which may or may not have VM_SOFTDIRTY set.
> >
> > Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> > which solves this issue.
> >
> > Additionally update VMA userland tests to propagate changes.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> Acked-by: Andrey Vagin <avagin@gmail.com>

Thanks :)

>
> Thanks,
> Andrei

