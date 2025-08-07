Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51444C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64F28E0005; Thu,  7 Aug 2025 13:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14E48E0001; Thu,  7 Aug 2025 13:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EC38E0005; Thu,  7 Aug 2025 13:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B240C8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:51:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFF0E80F05
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:51:44 +0000 (UTC)
X-FDA: 83750704128.10.F4F52FC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 831888000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:51:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="a1/4pXwC";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rSEHcpZd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754589101; a=rsa-sha256;
	cv=pass;
	b=JK+2ehJboRunJnx19vGOh0Cu06ovrDm3MEvB3tVkwL/JGKPKmOOJv0768Q7FVENKFcv9I4
	OoFbwOT7ye/T8Q2KhC+3rRFyQOtbZQedo8kOjfMOypu9f3QEGtZyXTCzclJaMmrejVsaDn
	S4X0WLog87nL7LuQiflAjQBT/tr8nFw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="a1/4pXwC";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rSEHcpZd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754589101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/l4RkUajL+YRlHtK5c5krT4QDDWXqIXmN0ra3lyx4I=;
	b=r8Wh+aMQME6cP4Hp2zphpPFBi+4eFde9ZQPeGyCXSpCQfkCy94933u3G8R//j8nmBWuH0L
	3mBPs8y60XB1Z/v6zXYElGCcqEF1ICHyGj/0ZeochZqpPnw/Xn0g7ObGivt5NLVLomBud3
	zjuvOMFr6+8L/1qnVFRf0AHy9iSIpZs=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577HC81k005037;
	Thu, 7 Aug 2025 17:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=I/l4RkUajL+YRlHtK5c5krT4QDDWXqIXmN0ra3lyx4I=; b=
	a1/4pXwC+hDck5IjMxwPXdRK4OQIHW1bHK3V9yyoxTccEkDwPxON41RtfxLnHozS
	9pmR81Rvo1DXU7oQWGhOm2q8I6OgyeOXUPWPsoBPB2235Rth/JuVmAQsFaz/WwWy
	WywUFJ9HaKoy91g6avCE4rfu99+iiA0hfd4CUAIvjXo6TH2ZGTjNGjCO/5hQk/37
	VdImMWtPITuiZyCBbX2GWeI3zXJYryr8bLgWLee0Gm0KGuYzvPNW0pA25nHEWu+7
	eEP8KB0+JK+4aVOtbFub/1sEjLTGK9Y/Y/xheV9ahzUgb//dZZUs1Xia/GxoIDLi
	42JO+kOuCgLRmg9TrepfUA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvh4nn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 17:51:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577HFwrp028296;
	Thu, 7 Aug 2025 17:51:14 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwnyq9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 17:51:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CYk7CBcmjnq0zsZ5/A7W/7PbTBqyGYTELzUpntsHt5YLxjSRQCQmd1IBx8CnKPKeNl7mvlKN/w7Y3T25AwHZA6dST0KYLR/ldV7zqIzcgeMl+iGiTq91nWL2+T0oXnRZGoshh0OgHSYbvrMj9G+MQlwnTPZuVQWTBrtVcBfEKZ429bmeprwdcaYpVm7VYYv8woXI3bA4xYgvLNUWxYyWmJCsBVzCgBKjvtKggi6bun/MgOF6FsQT454roSjPWIvC5Jp2W4KGR8GxJpkcfiQYKVp9FWpVuyVVNWszUNWlaLFfia5CeTCD1y78OcJ0qtnX5kShqwxm2hB4s9M8mjQEVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/l4RkUajL+YRlHtK5c5krT4QDDWXqIXmN0ra3lyx4I=;
 b=fbY+Leb+wgzttK2xxClRNvZz5Yhnj0aQsnQ9y4bg/R3AupHwldW8oGCEPrBAGvZcKA4z5HBEwKlFmDrzGMX70YqEZHpWlce0LPP+TdhGUwVpPHXGr74sP3F6ZbHoeZWgN01j4L1FjLQP5z6jDoEX/Ul++FFA4l4nxit95lpWz0u+FX/7RlevyJzMSHXnTmxsK7AgJ29YneTcG9EHl+UPOoX+KS6lLEh7iHId3rPhqmAAfN8nZQAk2m+Bso5O2polerLDGPnbjvSR1tPxl+LK2CKgS4b5tIXcStyhoIqcGctkgoYbjjdvqHe3ICX2/g5cQ6NIvBeEjK+3wrUVCtwEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/l4RkUajL+YRlHtK5c5krT4QDDWXqIXmN0ra3lyx4I=;
 b=rSEHcpZd9SV7l57gfMg1KfR881ajEeumX64XFjOB/WdlFaFeedts2yVIe3lemI8JvG6QrM3FBPsyd2ilINzU2DoJ7X0w521z9Gb51ha+Lz6tYL6AO3gOIyxuqkoBzLJnbr9sLrDyXbCC5DdXcI2HN/gCmuhemerJCkQwHAbmBMs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA6PR10MB8015.namprd10.prod.outlook.com (2603:10b6:806:438::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Thu, 7 Aug
 2025 17:51:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 17:51:11 +0000
Date: Thu, 7 Aug 2025 18:51:09 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: kernel test robot <oliver.sang@intel.com>, Dev Jain <dev.jain@arm.com>,
        oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Bang Li <libang.li@antgroup.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        bibo mao <maobibo@loongson.cn>, David Hildenbrand <david@redhat.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Lance Yang <ioworker0@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <e4f5faea-ccec-4cc7-83de-1a3c7013b81b@lucifer.local>
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
 <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
X-ClientProxiedBy: LO6P265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA6PR10MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf6e2ff-7e01-4c7d-c05a-08ddd5dafedb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T2JNVDVLVU5Xb2ZuV1ZGeXhNbnNaZFp2UjlNV25xbXZJdUNSVEdBZnZkNVI5?=
 =?utf-8?B?Q09pUkU3Uy91dVk1V0s0cS9PMkNQNnJBVktQRFZoTUt2WThUVEVOcGovSUl6?=
 =?utf-8?B?QTBPUFlVNktmVVVROGxlQlpmK3FHRTM1RFc5ZEprUE0yV0pVY1IyVVN5bmNF?=
 =?utf-8?B?alFMMDhGcGZhcWJ1Y1RmbXpZaXZBc000Vll4R2VzRWhYN2IzYlBvYlVqUXZZ?=
 =?utf-8?B?NkwwbkJtdHNVT3hHWnhCNFNjMjZTU0pqVGFMelVGQ014dlFsNXNWKzBFbXdm?=
 =?utf-8?B?UVZ1Ylh1ZEFNcGkyem1GQklsUzNUN1BHWGFBaGJtcHBBbHVVSUREMExodUNy?=
 =?utf-8?B?b3RnakJCaUFjT1dHZzVzdm0yNU5HSFQyR2wySk8va2gxVnBBdVpJOENQblJm?=
 =?utf-8?B?NVF5bXBhVnFld3lKRXNvODZVQ0d5OXkwY1FxY29ZRFhMY1ZkTzYxSXVxQzJB?=
 =?utf-8?B?bi85R25STzRuam9BWlYxcHNYMTBHb3VCMHJtNGdPZ0FxNWhia3R6MkRuR1hP?=
 =?utf-8?B?VCtKS3pnbHI2UG1BdUx2M1hvK0dOR3piWllOOW5BeS9nL1kydENxZk1uUmw3?=
 =?utf-8?B?dVU2bjRmU2Izd2ZGSkpQU1NXZnA0NzJyTW1BTGFKZGRMMmt4ZWJ4L3duTTZk?=
 =?utf-8?B?dW1SMkJuRFljS0wrTVVHakkzSnZRU2Vob3ZQaHRJZE1SSStRUlFSUjdCeFlC?=
 =?utf-8?B?NnRtMDQyWTNMRmowdVpsVVBKS2F4MFBYa2tma2lGTEZUQTVYbHhkZjJDVnRU?=
 =?utf-8?B?MmZJTm9tV2JZRkMzWDZ5bzd5MlQ3emlWa3ZHLzFpTmNLMkZIUTUyWURsbGF1?=
 =?utf-8?B?RXZsT0hhVk5MS29EZzN3VHM3cTF4ZTVRTFdoSzBBM1A4OXJjd0JDZm5ISGZw?=
 =?utf-8?B?bnF6MmxYQXVNSEQ5ZGc1enJWNU5uMGNFc2FacEdvMEVCZmttbU9penJiRDdo?=
 =?utf-8?B?c2QyYm1KSzBwZHlrUU01TkVGd0RaV0o5SnVWMVBGVm1xZC8vbzBxdU9sbHJw?=
 =?utf-8?B?ZTVGdHc2N1Avc2sreG5aSWlYMTJmOVZ1UTBia1Q0K1JKT0ZVSi9hY2FHOWN5?=
 =?utf-8?B?Nm9OMm1OSjYzVUhYdHEvL2RIcTRiZGtsQ29MdENVdFZMM2xxaEZNaXNUN0Uy?=
 =?utf-8?B?ZXZtaDNNODNNZ1NNQStlbHRwQW84Y3kzWmRSN291d1N0c05DbnUzdkxmbnJv?=
 =?utf-8?B?M0tNYWs5TzVtSXQwekpMbm80TEsrblphdVdRdnVSWEhQdUlwMmI0UzdZcGlJ?=
 =?utf-8?B?VUw2K2t4NmZpQkVsWHdEazhHYnZ2Nko5M0Fwdjk5T0Vibi9nK2MvVWJnZVNX?=
 =?utf-8?B?MzRpVlVlUm45WTJtVlVTZkNDWWxqMzZmVFBYRjhwT0pIdE1VYW1MZWNNMVNX?=
 =?utf-8?B?R2dMVWp3UDNNTXN2SkYvc05ZaWl2TDVQZjhSQ3JGaUNLT3p6OCtVLzJ6ODVy?=
 =?utf-8?B?dWg0WnRLWGIwTE40UjZmamFZU2N1OEVOaUR4REdnZTYzeEV3Rkx2SEhXZjlZ?=
 =?utf-8?B?N0U4R2M2aTNoNHNsWlJOdGZEU2R6K2tXd1FOMEJEMVFZWDJJV0t3MW5GVDF6?=
 =?utf-8?B?Qmh1ZHh1VVZPbkhNTVhGUitVSU0rTUZYeTg4TlY2Q0J6SXZ0Uy9VcUJOdU0x?=
 =?utf-8?B?VHdJMzUyNE4vc3JxRCs5K2VVUVJYa2pvU1ltbVJjS0JDN2FmenY0OXREZmZi?=
 =?utf-8?B?UXNLM29vM2NvSVI5L2lxOXlLb0szM1Vkc2JCQUxiWnhyaGpPelZ6SjMrb29u?=
 =?utf-8?B?N0pEczB3NUl2Nkc1NjE1ZE1BcUtmVytDL0NqUC8rbEVOMkFFNTE3c28vSmdo?=
 =?utf-8?B?Y0tzdDdoLzJ1TU1hWDZTeGtGc3ZnWE9PY2hVRHl1VnVlNm45aGVHd1BYSTMz?=
 =?utf-8?B?ZTNpVStoYVZOZXVjdzloYlBZa0RoaFE3VW54d0FtM0ZVMlpIL29yTWN5K3dk?=
 =?utf-8?Q?joXnCRTRBI0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlIvZFIvMzlCVHRRNjcvU1pVUkRPTTN5bDBnVmFMNk1nL0xPd1RvTnFNSCtN?=
 =?utf-8?B?MnVhZFNyaU01MWQ1Z2hsYWwzOWFObnFJWElFa2o3NXU3eW5YYyt2aXIrUkRR?=
 =?utf-8?B?Y1BQalVTV0hpWFpkNFhQL0F4ZEo0dkNTWGdocFluUVM5anc0M0ljdCsrQmdX?=
 =?utf-8?B?VlNnRkppTmVRK1hScXlmUmswM0hCb1dxMzFyMTk5Q2hqU3NhaWp5U1ZETTUr?=
 =?utf-8?B?ZmlxUGZoTWtXd0RsMm5rcFU5amNrVG03NlN0MjFOS0pycmJBbE0ydXg4My8r?=
 =?utf-8?B?c0tNMEN2Y2cvaDRiY3NsYjRzenZoeXNWUDdLUHJlTFZ5VzBWc05sVFNwdmNl?=
 =?utf-8?B?UVJISGNLOUZNd0pvUnlNWC9RNlZ1aFd2blVJU0JrOWs4c21iUkxwYkkyZFR3?=
 =?utf-8?B?Ri9mcm8zM3JJc2pGbG1CNngrZlpHZDdvdE52VVlmbHUyNTNIV2F0OGxDLy84?=
 =?utf-8?B?SmxRRytpOUFieDNiZGFGMjc2RFFrU2EzSi9OTGpETHYvWk4xa2lBOEkzOGsv?=
 =?utf-8?B?NEhWckUvTUl0dUovSmt0QWpmL2YzcXRBMzJTaTV4bHVZUHRLNlZ3UmRESktF?=
 =?utf-8?B?RVRRS3FsTlhWWmJ4Y20xSGM1cHgwUy9hbjFaQVZpWmdyVDVtcU41ZHQ4b0tB?=
 =?utf-8?B?Wkw1aE4xOFR3NVRWN2l1NDZvMkRTRWdpdjJJZWR0QzNPRDBnOFlLaXJZb2M5?=
 =?utf-8?B?TW1iOHk0aE9YelpzYXc5N1cwTXZ3eHovS3RXc2w1aE4yZlZRbWhPZjhZSUFs?=
 =?utf-8?B?OXdrQmdkaVNMTjF1OTRidjh5Ykg5R2Zjc2NNTW9XK1NNTXcwOVN1aW5iYXlW?=
 =?utf-8?B?SjFmcmhJN3MrU0J4N0taY2lUcGFNbHBNamJLaEhmMGtua1lpVFMwOWwzN1ZZ?=
 =?utf-8?B?WDFnL2hjK0w1SVY2UW1wQTV5REJKOWZMdC9CdDdYMVN4L2UvUnF5alBzbmZ4?=
 =?utf-8?B?bHpWRU9jeGQ1cEdFajM0VkFpcERFRDhqNVhLWXAvK0xtRVFVTWUxZW9OTDVB?=
 =?utf-8?B?Y1pjNHgrbjJ0TkRFWWVVdklGcThaYWVaVGdSdHhhRncyZGtSclhvVUs0OFUx?=
 =?utf-8?B?TlVsUldtbjl3eHc5Q0F3Rmd2S0xqclpWaDBYaGZDWW5nK2tjQ0JnOTNKY1Zz?=
 =?utf-8?B?eDhWK2FjWUVjL1k3clk1NkxBOCtYTit5VFB4blNmK1hFTldkMmJXbWxqdk81?=
 =?utf-8?B?dVFmc29lUUMzUDEweTgzeTIzTkhHTzk1aitXaG05dUdxb3NNd2x2V1ViczI0?=
 =?utf-8?B?TnZOUUw1ejRqNmdNUUswSnhuYW5JRUdjK3RFaDZvK3lYQzdDWStpcGwyK1ZK?=
 =?utf-8?B?YmdKa1RYT1EvZnA3QTVPeEJuR2RhQnRId0ZDOFlMdXFENEVFcEcxMDYxZldq?=
 =?utf-8?B?MXR1UWt1K3R2aDZWSnN2M1Q2ek0yN1FiVDh2K3EvZkJqVlhadXA2WWhhRWxT?=
 =?utf-8?B?T3dLaTJVRElqY203ZjE2ODdlNEdBbTM1Vmp1dEJmMEFxaFFVYy9vUGJEdnhv?=
 =?utf-8?B?NFVjNUdJL01SbWhKaStlbTNGc28yLzJZM1NzbS9KQlNWUTFOa2tSMDhGYXZv?=
 =?utf-8?B?UzVoSzQ3VktESmRLSS9KTkdieFg3MjRPSFBRdys1M0s2TE4vU28yS2FTZEFL?=
 =?utf-8?B?ZStNeXNORVJ6amlNSC9jVnppcXFiVFJsLzVtb3ZtQTJtaE42b1Q5cWJ1NDRl?=
 =?utf-8?B?QTNoaXBUSlYzL2FBZVNQbThDaWFuSGdLaWVLY25JQ0hsRkk2dkY1VXpmKys1?=
 =?utf-8?B?MFFxbXo3clpHRk11SG1NYy9aWnQyS0dqbjhvak1Ja1ZuSDhZbnk3aXlJcTA1?=
 =?utf-8?B?ekxIQ2JzOVAwN1FwNzNVb1JEQVdXOXZRNWN5eWNIeUpsakNIcVNzM1UwcCt3?=
 =?utf-8?B?OTh1VjlERkpBcjUwMFN2M1BSUHNnVi96enhnUXRMZDk5ZzJ3OXNPUlFXaEFt?=
 =?utf-8?B?OCtxMUVQUkJDTk9QY0lNVlRNVDRXRVVKWFlOYlNnWlEvM1U1cUdoZ1pqVmta?=
 =?utf-8?B?a1hRMVVEQzFXTHlsWEhIa0lhZ1U5VWZQRzNhS2RZTTZuL0NpTkM4dmNOUHdO?=
 =?utf-8?B?M0dyd0JLcFRxQy81M0xBL0hSdGtqMzZuYXJuRkJMNEo4em9JMFowaTdNU0NN?=
 =?utf-8?B?OXdoK2Z4VkZjbzdubTl3Y3ZKYTZYNG5YWjhmZ3NPSnpMZzBCYXhEUXZjY1JT?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QMpy9PnkFelP9isV9NzW8z/EXGm3yOwD8l5R8mKYbhm24TbVK45c1FtIwuyvVdxkHz5iTV2IpE5JVIVtGmmd06sXjO+YjGcYyixqUtKHf+ARZgJLZd/4Sfb2DrhcQkRvSEr7drryvRQwiMcObvWzl2wJ8D53wsiVHFA8D0LRJ/hLdSG9ZyZ6y4oZerwn7ZnFLjPE9U+mszuOb9R6e/q5LN7t9tiypwgzDJPN6H1ScTYtfCXZPNAHu50BsjtPGoy4MlDRU+fqyd/2voX9Nsc2Ds356TB6VSHlGSWWiPjxXKeKjzw3rDQV0b3SyKIVCWxIgAVprqUFqetFcY4Cu2J3PRgnAWlUl91+OVOP87xW5Kje/D68U9AxqHP0uUZJUNtaDyK2drK7T+M7qsYgabrQMRIeGSckCr+Z5H/u7MyCkvedfNeZlJ+T+tz3GoIZ5G6z3fAVnPAbVEDixP7E0mpMW+yBSi5D/qiGA/UWA/PIonAB3Kic5W/S1oHoJUPKMmafvdSCeIfBeQ1U89Bs92+53e07PayHMloMGG4xYAMmizVZOrvBDqLVl7I+dvJcXis9z5grU5sb/VT+lzIlkh45Bi0JJh3gIuI8K14p85wsWho=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf6e2ff-7e01-4c7d-c05a-08ddd5dafedb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:51:11.2462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zsAKsN4XTMxtaXidv2CqwCqwCmvFocEgf6KNjmO3mgnwcRtNnbNbURdqWrih/1djSsp8sdSo/OPmCJzVHVq7SV4Wd6YuSl7vMtM/rf3Myrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8015
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070145
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE0NiBTYWx0ZWRfX586LtVISer2P
 yveXv+CO4l42PMjaxvOw86ZS3EjfWNNcIPPbfR7AUG8QHmRNtAsWftsjmMr3GE5ZCk3V/v1jXPx
 sr08Pey0uvn3Ui01PUiBrj3mwiPdcmkIxnsGHztP0uoq5gJKRYp20Rb699bvrPvbiVDK1wzXsAw
 FY4403znSDqNxO5ECsFXErnQbbBZfQdUI1Zzv49CGtQQ2LmOlYFBJ0PWofsPLqf0RhXIy2fvUJ1
 qgo5yklTJ9NGn7F7e3j45A1woiEq+LfuBw8KEPQqvaVaL0PYSGyvzzPbGIr2+Ha/56I+9a1T8ZW
 4X+e0gMn/a94Gbxq9agALOw1zzzOBq0ymBXWiBU2i1s9Od5dxQlQbcPkC93MpgQ/vKZ0NBN50ST
 xOZaYocteOOxbqS9NhEKe8ZO3S2H6E/nMGPoALpdez/27Lay8C7duCqI2P+c9Z78lxxZBZ1R
X-Proofpoint-ORIG-GUID: ggiTjkgfUx78QqjW99AqwANm3YIRn1U2
X-Proofpoint-GUID: ggiTjkgfUx78QqjW99AqwANm3YIRn1U2
X-Authority-Analysis: v=2.4 cv=Hpl2G1TS c=1 sm=1 tr=0 ts=6894e793 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=Bge3NiY2uUHJcAqHsokA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 831888000C
X-Stat-Signature: yewxnqfr8dwf3gf3towinsccfjdkmy9b
X-Rspam-User: 
X-HE-Tag: 1754589101-394232
X-HE-Meta: U2FsdGVkX18HOlxhpQBPp1Y8EZx6/E6oAyiAEmvh2owYwrx/x/XZ38cmxy4IexNEQzrKjnIs/BqyVTIwVYtvtfYkQ+uz8VV13pbcWj3Xg+UCOu9oYRofK/XK5EI1V8j63xCBnqk+b+AJ0kszYt+5yXLvcZkZDrgCZ+1hQn+p3a1Zf1LGOSaghCaA+yNDrVXZQaUuF2UTYzAcYxxwB5/VxkfZ9sGdVNAxs3c13wioPlyFaVZW/e1GBJCLS8RXfa/XzThASp2/eo2HYpDr65dVqefAHi4m3/cuRhx4c3yH6RkQak7MIPunfN8PxoCzrBxTtIRDamzYgroZeoEz+LwkfhqITxLJup7zwHASxFKb6HMq/ulRm35S85UcNIlJrD3BZNBRADsyzBlG9mhXT2tl0muBB6msgcaDlg7iGDwIbahzKlKuYWJM4jiQpg8zGGFeOwcofgwhnG+hRVCcgwwmRWGawDPBU6Ya7aXOrPq37qG1OrCnuIhdVtaDsr81KdHFNVwKMGB5g8IWPJhMhnCNL2YNJAmjPRsOQntcaj4pPKii9zZE4JwuIYzD7BvrVsXiBqARPa6wIekhdVWpXVjAnigkrQWfLHgxmqeD1SoZYAw5p6bpMflZMSIsDCplcBrlPJvCRobyC0VHBhQtAk9fcW+TRwszrn9wdLvjAOo+PgMmSVqmzypXgZNgrIhnrA6DF/fP4W3jxOt0/qOWz5jpU4ZaDCt5buE9TqZ5XucJV1i2LmwsRnRwhE4uqNb8dWZRM543O5JNfg9J8U/kMhM9Ee2C/tRPVHHISjs1v6BwC+oELg+Ha7SY0uMwid8zDmowU3tmOHbjyTmw9U83cWvFOe97Xmi90anoDP0JddhNJgQxbKpHHLhmettsZPabQBHFP8NuwfM3rPUoQdxJSUTvj0TMshmx/skBOHg8zYujE61FK7J+sYpvfQ3LYL2i4EFa3hhZFA68WkCSWEnSigi
 AgwDGRI7
 0n6r1PPt1bLlESFl4uA607YgcN61+WourFWtpGTYo+3gRDG/8jjfylQQhlXyKGAGWIlpiE03Ngpch/97tv/acTcmNZCfKSqgjRES2VXRbs3UEWeSpj4j8dO+V9iQPAPEx8dAuYRhxNnPBK3OVozvg8e5g+Bo9t2lTBN+NvTDyAKtsYXulalnG1cUqprWkyBaOzCEjmwO5q3aqz67laoC7u8u4S0341gK7VZ370BXBrSQuswf9vldVYdpwgAdnDpoYxOhOrFZylWUbQ8vxQzUgMu5QSjr6U5Wm4p7pVYIiwKn224bE5fS/H6TYICVEi9vsf/8DQu5CX12kKHs1EOgzXUlCrv2+ycmyVgV2isCC8OEx6UonYd2oUXEUnAv5cVHOuWwqEblsSvNT48HnXNEExBAKjbz3Ax9pS3ORr3MfIKyGtAhcSUfiJNWB4Xxpp0GyG8jul7os4lU83q1KXjk26WuPYFumUQr1lo0GjbRECtSCW57AfKRgFMtCBOKZieaWUruy8pk+WX1w88KLq44VaWAqju2jNbKDv/u/EpmAnHjns9/yyZRvLyshLVHWqidX9E/772ezitC660DSYS2YAgi3j2CIPebMhhaiNSX2PgM5WqP6MYgKwDC8gs8iDJsHHP95FS8JMuTFBcEOYAXuNtcF+q0t+oIevjABH/qUTwdR8POROuFjHxjkdTyEapKoydNbQAluslIDfDyI7r4SIhzwUYE7BKRu0TEJYQ/wgrnDja9UmbSqab556j1sdbKfv0xE5N8ncqRzcT3elbU0QVBbJ2c93DxP/HEVfynQh9P14UQ7xBwiflXeg3E198Ob1wW/3KozLm+LiwOJbfgXjBt2UiqB+YrCky1Oly7bxP0x2CM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 07:46:39PM +0200, Jann Horn wrote:
> On Thu, Aug 7, 2025 at 7:41 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
> > > On Thu, Aug 7, 2025 at 10:28 AM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > > On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
> > > > > 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> > > > > ---------------- ---------------------------
> > > > >          %stddev     %change         %stddev
> > > > >              \          |                \
> > > > >      13777 ą 37%     +45.0%      19979 ą 27%  numa-vmstat.node1.nr_slab_reclaimable
> > > > >     367205            +2.3%     375703        vmstat.system.in
> > > > >      55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.KReclaimable
> > > > >      55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.SReclaimable
> > > > >     559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
> > > > >      11468            +1.2%      11603        stress-ng.time.system_time
> > > > >     296.25            +4.5%     309.70        stress-ng.time.user_time
> > > > >       0.81 ą187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > >       9.36 ą165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > >       0.81 ą187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > >       9.36 ą165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > >       5.50 ą 17%    +390.9%      27.00 ą 56%  perf-c2c.DRAM.local
> > > > >     388.50 ą 10%    +114.7%     834.17 ą 33%  perf-c2c.DRAM.remote
> > > > >       1214 ą 13%    +107.3%       2517 ą 31%  perf-c2c.HITM.local
> > > > >     135.00 ą 19%    +130.9%     311.67 ą 32%  perf-c2c.HITM.remote
> > > > >       1349 ą 13%    +109.6%       2829 ą 31%  perf-c2c.HITM.total
> > > >
> > > > Yeah this also looks pretty consistent too...
> > >
> > > FWIW, HITM hat different meanings depending on exactly which
> > > microarchitecture that test happened on; the message says it is from
> > > Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
> > > meaningful than if it came from a pre-IceLake system (see
> > > https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7Xr-w@mail.gmail.com/).
> > >
> > > To me those numbers mainly look like you're accessing a lot more
> > > cache-cold data. (On pre-IceLake they would indicate cacheline
> > > bouncing, but I guess here they probably don't.) And that makes sense,
> > > since before the patch, this path was just moving PTEs around without
> > > looking at the associated pages/folios; basically more or less like a
> > > memcpy() on x86-64. But after the patch, for every 8 bytes that you
> > > copy, you have to load a cacheline from the vmemmap to get the page.
> >
> > Yup this is representative of what my investigation is showing.
> >
> > I've narrowed it down but want to wait to report until I'm sure...
> >
> > But yeah we're doing a _lot_ more work.
> >
> > I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
> > especially sensitive to this (I found issues with this with my abortive mremap
> > anon merging stuff too, but really expected it there...)
>
> Another approach would be to always read and write PTEs in
> contpte-sized chunks here, without caring whether they're actually
> contiguous or whatever, or something along those lines.

Not sure I love that, you'd have to figure out offset without cont pte batch and
can it vary? And we're doing this on non-arm64 arches for what reason?

And would it solve anything really? We'd still be looking at folio, yes less
than now, but uselessly for arches that don't benefit?

The basis of this series was (and I did explicitly ask) that it wouldn't harm
other arches.

