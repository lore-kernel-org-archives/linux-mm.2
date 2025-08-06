Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9071EC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E6C8E0005; Wed,  6 Aug 2025 16:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306078E0002; Wed,  6 Aug 2025 16:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CDC68E0005; Wed,  6 Aug 2025 16:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5DE8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D267C1A070D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:18:18 +0000 (UTC)
X-FDA: 83747444676.13.061835E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 567C118000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:18:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IwLNQ12+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zIKbBpap;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754511495; a=rsa-sha256;
	cv=pass;
	b=bHiYJ2yfiiYcsV8E9mfwrLtGoA+2yLr8+bt6ZPFuS8OqVviwpwXFI3rJxW4L8ZPn8J3GJX
	hF9PHwTxGF1vHVtNhcMFE3SJhVgKq3DWyja6UlerevPyKSrtsmWMWjzTHg9fUqwX6sHJS6
	q4aIRrjEY6UFPxzJ/2MCjaH70YXYTj0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IwLNQ12+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zIKbBpap;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754511495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=om7NIffRwAVyKwJzR6a+XMJXCK6dvYQL7Waj+FUZJRg=;
	b=eR6yIwyiSmlYMyNwpPO4m6d/tSnQ/nMMkQ95lMPy7lIGbF2Qhfjg99EvIogi2TKHBaD2Mi
	aGNMF/1TTlgoYqM3DGaCqZ3/QUF4FQbR231U3FLB8cIUnM9MI/B22CXIC6VmmwHXlqACqZ
	E/IkA32ILLPhYWrmnqmZxtDF3a6cQyk=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576GRONF002135;
	Wed, 6 Aug 2025 20:18:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=om7NIffRwAVyKwJzR6a+XMJXCK6dvYQL7Waj+FUZJRg=; b=
	IwLNQ12+IEO5vvSxvuHLhvr8YO7XWDMHSnaJgBdtaX4tptvj2YnSz3lj3g+tHA7H
	0k+NJuXbh5/ugW7lhRU+amLrXASKMyvGXUpY+YVf7z7pqcvQgWiRgf1IA3SisSKc
	IJZirw0HEC/DLJoEJLXBsbakoXSkjvvTih31gOAQ5Tp/BoGB6r/XXuw4jx+rvvOl
	9RtCTBYCTJ0ifBpCbRcXW8CJsmEJE1ohTAGARR4m5jBqsn0/oqRaSKWO+tU3fgz5
	9cPCZAYIBOHd6PNAXbkEhuUNYaNWrLHFe30rqDyhpVxua4ajQV7sqceRI5EtzzFC
	1NRXToRVTY0gqce8ZkLqAA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpxy2q0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 20:18:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576JkRnG032127;
	Wed, 6 Aug 2025 20:18:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwr17fp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 20:18:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u8YLoDLIfLRcu/g9h3oF7ehtS1aysGsxaOTRdLeEle2gqfibSMu7aDpcRNVgUfLQXczoSnPC/ygNMMdb2+LaXkJvWRkno4IE3mM5YwUTQ3Gygju5yNXJRQ8B/i21FimrDIt65ispdJprsH0SzHBuCGX3sji2YBbVA8G3zBy3m2phwAs8uWlA8kdC7P37nefnkTddlHEtt9sAH/+Mi8X3yXlFx+jnKMk2unKSJ/Dfk92AqhmH8YJQsrFQQc6ZbJCu5rJ/XHfscgqUSwyERqUiFLpqX4gi2yQRKkZHXvly1/OZo8guwGReaiggNDjSzUtWoIlH/ryoXxak9pG5KLWSnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=om7NIffRwAVyKwJzR6a+XMJXCK6dvYQL7Waj+FUZJRg=;
 b=XlS85NvHG5S3bpnei5zu4kRRxRYQcYS7kufdiEYKY3WVwbJO/OLKX73a3n7T8w6ZP/p7B3DzTxf6Ba/9H5pihW19cP8Ly4lyJps1/lA1hl6klwDaGG1d6sAZ5fmj6E7BmRmGlbSS9km1vgoPjHK7oo3TyuCI6XE9hkEtSFoFrVsloxxeCFhh9VNQ9cO305LXVvjICbFJoXTNlWQs2/vfjQJG+RRDxzOcyxNK2XW5qqyRoB/+3fsFvu6ToVoAxtXanFuGw2a1vZkd10rJIasqTq2osL80OgbOhVuQjLhI40jwMnUC4OLY1tALwFMOXgAQFa11eC47kv6tYRuZWQm00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=om7NIffRwAVyKwJzR6a+XMJXCK6dvYQL7Waj+FUZJRg=;
 b=zIKbBpapNbAchOD5orISO1Zs+ZQMQ6ChdSOaxQbohW5RWk2mDxr4QQG5SaoWC3S8O40/q/mQmds8WzerKGofyIjzMkc8l4vh5LZJQ2Vj+j1XXZUvIlGWMWAb7j8ArqmmBoWX/G+Ukerpz6x7QIfskR0rn85M8B7x8WgFv92IfmU=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA3PR10MB8735.namprd10.prod.outlook.com (2603:10b6:208:576::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 20:18:02 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Wed, 6 Aug 2025
 20:18:02 +0000
Message-ID: <03249021-1436-4b3b-b6d9-e7a1a7a8da2e@oracle.com>
Date: Wed, 6 Aug 2025 13:17:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm: hugetlb: directly pass order when allocate a
 hugetlb folio
From: jane.chu@oracle.com
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-5-wangkefeng.wang@huawei.com>
 <1daf68a1-71cf-448f-921c-83ebf61e1fae@oracle.com>
Content-Language: en-US
In-Reply-To: <1daf68a1-71cf-448f-921c-83ebf61e1fae@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::32) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA3PR10MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: b4205fde-3750-4c14-11d9-08ddd526581b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFAwNGt1Qk9XNDdFdXV5WnQzMnl0ejdkcDhHeGVnMDkwdi93ckNIMkpzNmQy?=
 =?utf-8?B?dk5HZ3J6b3lKVFpkQjVPMDFHUjhZSG8xM2d2a1BkTzdsa0lBSkY5SUNDek42?=
 =?utf-8?B?OGNJZ1RkTnZkaVNIOGkvVnBmdmJFUlVyL3loK1JFaHlwUDRZeGl0VW41MGdU?=
 =?utf-8?B?YnBTRzEwVU40YVJOMmN1aXNjT1MxUGpiTUtIb1hJQ3M0MkVaejluMUZ5SDlF?=
 =?utf-8?B?MWx4OFJWSjdhTHU5UzQxcEl2UkIrNmNNbUQzOUtJaHJGZUwxZlM3SGdlNTdk?=
 =?utf-8?B?Rk9PbHNzWDl2YUZJQ25vUjdSbVFWVXEzZE00TlFkbFZHZCtoQXlvU0oycUNU?=
 =?utf-8?B?b2ZiWjcvR0o2R1J1YTlreExEbXNxK1FEaXpUMVZ2RGVaU3hkTTZCUm1XOWhi?=
 =?utf-8?B?RG5yTVg3WmF5Z29VMGNMd0NOdWE0WkYzRmZjUlAyanBTS0UwZUZEQUpUL3JC?=
 =?utf-8?B?akl3ZFoydWVSR25tU0ViSHhOQVVRTm9sWHBqWFJNZkFzZnAySVV3R3ZkSlhE?=
 =?utf-8?B?NmZ2SFhjN2ZjZkEvL01FejJtTXhCc2dUWTJRU2hrdjFFT2lsUlk2TE51Nngy?=
 =?utf-8?B?NmtFcGxmUkhCRkZqZVdzVlBJVW5HOWlSb1dHVWVsa2prTkxjQTFSYWVJTE5M?=
 =?utf-8?B?eEJrdlYrTlR5QzhlNkVTUzViZFg3bWhMcjlBVDV3b3BEK2hseDdtU25KckM5?=
 =?utf-8?B?WXZFYjZMa0N3UEhiR21ZUGNBWGhPaWhieGlmM0EvN3ViZVgxTVFxdGU2OWNt?=
 =?utf-8?B?ajV6bTgyRllzaTFZUnlSVWlydWZTRTZOakp1VUVoc3JjbVY2Zi9ITEU1ZDRF?=
 =?utf-8?B?eWptbFBvSjZFZWNtOUNSS3lPbmRlRGlzRjI1bnF4ZEE5Q3EwZDI0em5mT2py?=
 =?utf-8?B?THdDa1R1WVFlWW5aNUxzemJaeUdMMUV2QlpiWE1QaVdiY09NcmJxZkVIWVhG?=
 =?utf-8?B?WVplM0FSTjY3aVZ6TWdXZHdtRUg0aFUvVkdjaDR1OWlyZFFlSWxyaUJFa0I1?=
 =?utf-8?B?aFRDdE5CWWx4bUZuNU4zeUZvVUNuNlNrdkVVMExjQTUxVkszQW84MnJEQUN2?=
 =?utf-8?B?Zzk5bStVQWh0VmVLVGplbjNKbGl3T0FrYjVPV1hYQkY5L3lkOXJldk5FelJV?=
 =?utf-8?B?VnpRNEptQVVVeFhHRlk0ZTRNamp4SE8yTCs3TjNmNW5jZDJBdlRTeXB2ZXpq?=
 =?utf-8?B?VTZtK2lqZ1YzZUticDFzMktHbEs4R25SUlNQeGM4QWtzVlRxRSt2Mk5tdFUx?=
 =?utf-8?B?RDhoV3VCc0Q4NGh3dWFFUWdRN0cyYWJ5bnhuK1B2OE9KNzlsN3RSSXA5Y01B?=
 =?utf-8?B?VkZCdVpYNUNuR0FCWUVQZmpUN1RpWTNxTDhQZ1Zsd213OVZTR3Yrai9JOCt4?=
 =?utf-8?B?cWQva2NsL1EwdjZyclNrM3BZWHNwd3VGWTd3RmRaSWh6UzM1cVRVZm5DYnJF?=
 =?utf-8?B?emt5L0FsNC81S1N3UGhFYXNFYVZLMWFoUGxka2dOYUI1UWdMdVVRNlY1RTJP?=
 =?utf-8?B?L0t3VG5zeXg5R245clpIeU1JN0xHL1VKUXg5N2FaWFpUUTRQSHQ5N1FSeU40?=
 =?utf-8?B?WHE2dWtUWHNLMDR2cG11M2JOTmQxZlJBWjdCcU9WVi80SU04cXZVYy9yRGsv?=
 =?utf-8?B?Nk5ZTGcyNk41RVZpZGN4dHdSWFhTMU1sZk8rK2h6VXhwQTVVUWVNV2cxdEhH?=
 =?utf-8?B?NVdkMDBVbFBzSG5CaXhNUU0vTGR3M3JOSFVMQWJDYTIyYTBzWWJXckNkQ1hF?=
 =?utf-8?B?cG1aaUZ5Z0UvZTVzejRZYmVaWTJIUGZmTkNIMFZtS3hWbnIwd3phRElGTTBP?=
 =?utf-8?B?TytxY2pvbDZyT0kzRmd2VGw2OXJ0ZFJhK3g5SWJwOHMzODZlTEZLVllXSzdo?=
 =?utf-8?B?SGZjcWFCR2Q0aVc5V1NPS3QrdTJqMVp4eWg2Nnl0dTg4ZHRCVWxYUm1mTERa?=
 =?utf-8?Q?7OxFtbX9Ato=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXNyZ01pK0piUWVRelhaa016TEJEM1MveXZVeHg2Q04rRGhBZUtHczFpRDZQ?=
 =?utf-8?B?UFIxRWQ1VVcwblVhVFVDRUNHZHdGTVNSaHJmdS9aSk00SHFoNWYrWlJKWFBP?=
 =?utf-8?B?T1UvcHR0czdHOHhuR2NuenpJQzVycFg0azhFTUxHMnVuUjZvVE50SVhITm1Z?=
 =?utf-8?B?SlZUYk1tdEtraC94YWJDd1hsYjJtdTRjcVp2Y3BYKzExQUZGb0FyTTI3OUtt?=
 =?utf-8?B?TGVtNVVzSDdycmdKSDkwdXFkdEpCc2o2RzJYQ0FBcXVDdXdmak4yenR0OXFU?=
 =?utf-8?B?NUwyaTFvaEllWUh6UXBkNEoxdDFLRXJPNTNOVklpZXRITDQ1NXZjdkNBbDZv?=
 =?utf-8?B?UEtoZDE4S3d0TnRkVUJDMnUzeW1UQnU0TGVFR1d4RE00c3ViWlZJQTc3dERW?=
 =?utf-8?B?Ukh6b2c0WDQvNGFaQUt2V1pCZEkvN0NuSkVuZmgvdU82UHplRFhBa3g4R291?=
 =?utf-8?B?c1Vpb3c5SlRMZG1NamZWWS83YzBnSTNOQ0dVcmFqdXpabDZWbUgwazlpbS80?=
 =?utf-8?B?KzA4OWxGaUp0bGRFbnJGYXpVcEJxNG1zMWd0Y0R6cDRqbEpQNy9UaGlYR3lY?=
 =?utf-8?B?RFFYL1prb3paeFJLYWx3L0dPZ3lHS25XRU1qY3hvN1NsbmxPNUp6MGs2UjNu?=
 =?utf-8?B?djB5SXkrNUpjMlFoVDNCNklSWW90UVhJenRySmhSdkFMczF5ekVPVWRHNVNP?=
 =?utf-8?B?TkJ2NDE0QUJHNWZTVTJrSEdFTlhkYVE2bm9PWGx4WjVYWEVlcDhXazJGOVBj?=
 =?utf-8?B?UGNrL0lmaVRsTHJLaFdJd2c5RC9wNldTeVhCcjhPdXo3LzAvOWJIa2c4WnNa?=
 =?utf-8?B?KzBxNHc4Y0tMUk40akFReTcvSzVuM0hTaVlCa0hYMXVGSUszY21FWEFlb1J2?=
 =?utf-8?B?eTUyYWdxNEdYK29MMWJsM1BzZSt0YS9UajdOeWVGdHFKaDRoWDhpTnZVQm43?=
 =?utf-8?B?bFNORHMvb0dWWGp5cG9vdnZEc3lBQTFjL2lnNVBJWXJCVktEOGJWRG5oS3lp?=
 =?utf-8?B?anJqQTJhZGhrZ3RLakFXM01jajQxdjJiM1d4SVhUb21GZ3FjVk15bkNiOXFj?=
 =?utf-8?B?NUtjaUU5Z3hmbXJ6Vm1DNjBycHFmcXlKV2Z6QzdnVnhSRlF3VkhKTnZ0RjJw?=
 =?utf-8?B?a2ZYVzRqTnkyN1dOSUE3bTZrTmY0ZWUzWFgyeTBkRDBkdkVTM09uOFF6RWxF?=
 =?utf-8?B?WXNRRW4yZ1lIaUpKYkxmMS9QMUFOandjVXc4VmZPZ0cxcFlPZ05RL2wrai93?=
 =?utf-8?B?STdlbnNKeHRJb0kxWTZWeDhrYStEWkV5MHlCZWtvZGtOWmwyNDJHcGgzeCs4?=
 =?utf-8?B?VTJ5dENrYmVPMkdVUzIwYmZGRkFtbUZkZ04rWHVTcnpwenV5czQ2OWk0YlJE?=
 =?utf-8?B?alBDZGJpRHhyb2ZkMEo5SEhteXRzTGRmbWx6Z3h5OE94MXh6eDB1ZmljUEFS?=
 =?utf-8?B?UUQ5TkxTWmNOUzhEakdGLyt6YkpmN3VGMDBxeS8zeERSRU02TElHd0pVVmxV?=
 =?utf-8?B?dFdaN2RLYkdzbjhZWkgxdkV3ZTg0RW56V1NuOVBzcC81LzV5azhhZG1obmxO?=
 =?utf-8?B?M3hjSVY3TGVOSzYzNS80U2MvSkJDVElJc0FFMWZua2d2bkxNRkt5S2g5QmRn?=
 =?utf-8?B?dHBsQ2Z5SGhUZitYSEFUQk0va2xneGJzazdHQ3IwWDlZbXdKdnpsMnJDdGhq?=
 =?utf-8?B?V2pXcjBTTWI2K2lSNXgyMFlldjIybWFsczRHMjVpOG1OWmMzbXJvM3Fxam5E?=
 =?utf-8?B?Nm51RUYzNFpobXRHK2EwcmlxcVJkOHhmMENOUXc5SGxrMU5XdG1XQWxQNjRE?=
 =?utf-8?B?OTd2cUlUNUFJUms4NjNBeE5YN0JmVkZOOVdGR1gvQUVqL2E2OUwzN2lkTHk2?=
 =?utf-8?B?L01ST0gwTkFVMmlzcktRdVRFQjZWU2tBSkVCMnZtdlBpOXY2Q1BVTUdMaTNl?=
 =?utf-8?B?KzQ0a01IM2pBNzFtQ3I3RW1ra2MvTjFkRVJVR25sQXZQcERvRndsQlFNdHJq?=
 =?utf-8?B?ZUZnSEJCTS9JMzFtRmpzazI0VUp0S2FUcUloOEJRVHhHNkpPOHJOWlBrekJS?=
 =?utf-8?B?U3NWdlkwNi85Z3l2cFcrWENmL3pJS1dSMTRoTjdodTNXVEZYRDJobVlUWWcr?=
 =?utf-8?Q?QfhBOOVo9uEX6bNYRK2/+JhIC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MREEuHL4iZUHmODh8e+vEbayoofVDzIc1wg2YLIrLo+ZHA9YIBKPcGWsiEVwIXxtzuhivuR4fNygHtKLtQ1p6vZramSw4D7v3HFVuYznoECeyNjzeQO3CCT0PGoQAK+DRl8AgLmloZanJtYxjCEwv44QwtebAiAKx2Ind3Km8t1OGgFCiIerS1A4bUd5YjV8bSRJIJi8ETLKUhc/yOtFUE8YRfh5XyX/T90S5AF9+P2dpmcFONBOlnmrCGqnyWflZwu8Inw/HJ1nhNIE7nT1B9cFb6E0uLP9MywpEY2yQRCjIv4GqFQNoZrPdvM8wRHnt6koqgj+OfKV680Na5/anypvFjiqrDf1G96FpNz348m9t4YDDu6bDLW660TGcoAr5yDkQrA0AgiuNB6x06VgWIF8cNtam4Ugm6qQSZUpkkcSFrrF3xqh6yw53zUDZoI0e4XgkoN4/IBbTtW0yz1DX215AQpdJfgOyiKvyjcWib6dp+ruJBQFD/E8geb8FOUMozErQUvY+Q9xdfsgHiz2/T05+5mH1jTIR3ArSnerUagcZeL8DnldMoKjG9eDFmoAuOYy6madZWJMF/800PCmpnraUz1GfOoLTMlGz8KX4GU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4205fde-3750-4c14-11d9-08ddd526581b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:18:02.1592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksn0W2F8+emq51nGf2G+lv4wQ3VBMbrP16iUsRMT+l5FLgLFKzqKd1R/RCT0fpAEQYYY1VfWAGiJt6nYdsw8Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8735
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060137
X-Proofpoint-GUID: gzzlvuZBRNBDhDPouGql22SStdKZuyy9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDEzNyBTYWx0ZWRfXyJNoVW6qcuSd
 QMSD2c48Z+k9o+PNbHbhjLBfnFEnqCJlZuBDsyGWz86/zwVHJFevqVxvIKqFXAxiObHvT3aczTA
 0lcPN2rcxM5Ti4D2dtuxiOgCAKkaeQEWYAok+PXdFXLeMjzs0zBKxsIA9Yiq23q7yWeYeJArsLo
 6QHQTmca+NgCayep3qU08uTlIN+3GPND/uQFyeXT4Wbq+sCM4eyQJJ7GhtKWF4tnzqM29tCiiHR
 38atU2gEMkWhoyA37yQzy6jWmavL/0xnKOJmpxiapm37kJqylH/sZpsAQb3ZRf/UWNtAjE+IOL3
 QzkbTEkgU+Dp4nI/LvZyEId8TKrqCvXxWx6DKs0WkCdmn76Dg4NNews0EtOfjNdc0IPwse4oeam
 fTHZT5K3JjdOe7Jg2QCvNNGQVtfKtmk1hT5TDPmCI4bqzHQbEtWVDQbSRV7Vsd+pQQHGZxKQ
X-Authority-Analysis: v=2.4 cv=Y9/4sgeN c=1 sm=1 tr=0 ts=6893b880 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8
 a=fjv019AGN9nMBJcN9bgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13600
X-Proofpoint-ORIG-GUID: gzzlvuZBRNBDhDPouGql22SStdKZuyy9
X-Rspamd-Queue-Id: 567C118000D
X-Stat-Signature: efeiysww1xqg3u1rry4mhfrrr4yfjai1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754511495-626278
X-HE-Meta: U2FsdGVkX19XpTldQR/cqvz5Xv4pFjaISJePec17dLp6RZVxZFQ4CNRvJP3EDVM9MVHrRfr+sqEVMO2Kzm7EGab0gjVUHWlf3rxA4U6rQ9kgQ90R1D9tN9E5UDctqZ7xRnGIYTrUGUI1ryBR9Vy1OAq2Inp/89YR5J3u3KfKQD0XJyJX986GWdG1yk1hlqAB3w0hiz+Q3BcgyKg2HIFX8ElowN67DKijbZM3wb2+X26NbXrp/7znceGhdzXB5a/5lPOSCHVcK7EbSGwNWkiJ073k4PbSn2CkQwFwrYkFFvHs6NupMDOVmTAi3fCf/uUjenrqvQCZLICIrJxd5NsK5FeM2ZQ5q1vuF1iPaTdXIvby+gf8qgfj/2OJYDc6NxjGTcljwweLF26eAcGo2tEisV8IldHf7pim0Ar28ToM1WeYCXOqLhAXkmiw8PvGP4mtUsSMlNDByjVdwwOjlKYdOYlYtZgRxwqz2OiRQjTEMu+oWRiazGGQjmmjT9xjB6Wh5cu7GyqDDhxhlfCIEEipAP1w0BLUrxA1CuADaJHdb020XmZJaKf60QwQvvV5HNIGGWdCtWAsgg17AUS3R1K6fzjrpBhatxQ11BoVRlfXH/UeRKEu67HMBkBspXDbwHNuLs4BEis5+MXko4oE/9KDR6ZhYqWuOu9Cnf1+KhV0IYtmxuqErKgYk0EBhZaBrs0SUfqzYMYIj26PeRhSzej3WahnHtGWkHljPYAiRO4oeLcnc+XQeXeFODu42GETIpF2970Rvs+oP/oWFGQf6z7yhOWUuB5zEGL9M6RGyRBE/j4kGiNvLBCGeLA7XqxZDnPEwAfsbvKnxCvMbWdAPdtiMnuzmpBbTTGhf7AO+tCxRExuUsZS1eD9mJic8fItCHaDgdT7VipkQFgjOCj26sg6mRIn0gBb9dnhk/7usQXZxrmu4rZMORbJ8nHViTzzQ9fgXdH9rU86kl3+eXv82Oe
 lqOpW2/n
 qzPqc+jYOiyKYN8Ig4mR/xCOHxJ5AfreO3cPJ5gjUJ603rwbS3fCpH3SsjjX/OcQIpZyDjxcj/8hBy+bpUGRiVH//R9N5GQ+O3jsJgjrI82Z4dUVTCmxwRqifeO4KkVDwBuJmrK4tkVgxNo4cK3a5gMs/8MKPIoHAjvmiBwl/3PE1+mK8BY2svd4aSMXnm1Ne6s+F9hC1Z6RgdjNgyx2+93wL1vXlUEiD+dY7KhcnobKl94HXkWcWWdupdXWtY0zbvBCs2KOlqkjlGlLQK5kVgAv1QrnoLxZ62Sec1HBxL901nveR/yi9zdsg3qq+pYQBsmy5GkCrj625EgZR13q2gjZpy0948uJaSmaHWwczFZ1reIzQcx18Eq+K8mueOPuTPFz33teO1KSNp0iiGKuSOHl+TBcGK7WqAxZyuSF2WW3JLSsfjE0Gn2oRA4lninDhGYC4+2yKuecJpoVZ/rchqA4G2yCGu0wvUMyOEryQ8+cTkNzAbbE8N1gZ5hNtFwHWpq5ONhIrFzDbLIyTtgzgmyC1p86tDOtKy9MAsoNKAV2aJUgPlFZ0IvboTfa2E6/7mynYyU/Ok8vUi+k/rjVz82ivrfm0BEv3qk/urob4l0FFQq01VPtfOrFzaBQPnBb2Azzyx2/uiBqcwg6vvgTcZvApcLQyumsrwmv1F+UqxzD+LW0+2D0knRBxZEdnINJ0spZ1aSOdHwXrxwg8VYRFwJcJK0mB46+3moihIsGVBrgT65RJgCN7UGWZmNPoUbPsvLLsdIXvU5fMXW3L4anaxYBFqLcnXtf3rvASaedXLVEf1jgW8JHtlF7WhA01cJjOPT6oMltiT6330Iu+VQ8CeyMbtWDUfBYkZcigNq5cgHfmQOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/2025 1:05 PM, jane.chu@oracle.com wrote:
> 
> 
> On 8/2/2025 12:31 AM, Kefeng Wang wrote:
>> Use order instead of struct hstate to remove huge_page_order() call
>> from all hugetlb folio allocation.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/hugetlb.c     | 27 +++++++++++++--------------
>>   mm/hugetlb_cma.c |  3 +--
>>   mm/hugetlb_cma.h |  6 +++---
>>   3 files changed, 17 insertions(+), 19 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 436403fb0bed..e174a9269f52 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(struct 
>> hstate *h, nodemask_t *nodes_allowed)
>>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>   #ifdef CONFIG_CONTIG_ALLOC
>> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t 
>> gfp_mask,
>> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>>           int nid, nodemask_t *nodemask)
>>   {
>>       struct folio *folio;
>> -    int order = huge_page_order(h);
>>       bool retried = false;
>>       if (nid == NUMA_NO_NODE)
>>           nid = numa_mem_id();
>>   retry:
>> -    folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
>> +    folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>>       if (!folio) {
>>           if (hugetlb_cma_exclusive_alloc())
>>               return NULL;
>> @@ -1506,16 +1505,16 @@ static struct folio 
>> *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
>>   }
>>   #else /* !CONFIG_CONTIG_ALLOC */
>> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t 
>> gfp_mask,
>> -                    int nid, nodemask_t *nodemask)
>> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, 
>> int nid,
>> +                      nodemask_t *nodemask)
>>   {
>>       return NULL;
>>   }
>>   #endif /* CONFIG_CONTIG_ALLOC */
>>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
>> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t 
>> gfp_mask,
>> -                    int nid, nodemask_t *nodemask)
>> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, 
>> int nid,
>> +                      nodemask_t *nodemask)
>>   {
>>       return NULL;
>>   }
>> @@ -1926,11 +1925,9 @@ struct address_space 
>> *hugetlb_folio_mapping_lock_write(struct folio *folio)
>>       return NULL;
>>   }
>> -static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
>> -        gfp_t gfp_mask, int nid, nodemask_t *nmask,
>> -        nodemask_t *node_alloc_noretry)
>> +static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t 
>> gfp_mask,
>> +        int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
>>   {
>> -    int order = huge_page_order(h);
>>       struct folio *folio;
>>       bool alloc_try_hard = true;
>> @@ -1977,11 +1974,13 @@ static struct folio 
>> *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>>           nodemask_t *node_alloc_noretry)
>>   {
>>       struct folio *folio;
>> +    int order = huge_page_order(h);
>> -    if (hstate_is_gigantic(h))
>> -        folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
>> +    if (order > MAX_PAGE_ORDER)
>> +        folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
> 
> But hstate_is_gigantic() has two definitions depends on whether 
> CONFIG_HUGETLB_PAGE is selected.

Sorry, cross that, don't know what was I thinking.

Reviewed-by: Jane Chu <jane.chu@oracle.com>

thanks!

> 
>>       else
>> -        folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, 
>> node_alloc_noretry);
>> +        folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
>> +                          node_alloc_noretry);
>>       if (folio)
>>           init_new_hugetlb_folio(h, folio);
>>       return folio;
>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>> index f58ef4969e7a..e8e4dc7182d5 100644
>> --- a/mm/hugetlb_cma.c
>> +++ b/mm/hugetlb_cma.c
>> @@ -26,11 +26,10 @@ void hugetlb_cma_free_folio(struct folio *folio)
>>   }
>> -struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
>> +struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>>                         int nid, nodemask_t *nodemask)
>>   {
>>       int node;
>> -    int order = huge_page_order(h);
>>       struct folio *folio = NULL;
>>       if (hugetlb_cma[nid])
>> diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
>> index f7d7fb9880a2..2c2ec8a7e134 100644
>> --- a/mm/hugetlb_cma.h
>> +++ b/mm/hugetlb_cma.h
>> @@ -4,7 +4,7 @@
>>   #ifdef CONFIG_CMA
>>   void hugetlb_cma_free_folio(struct folio *folio);
>> -struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
>> +struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>>                         int nid, nodemask_t *nodemask);
>>   struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate 
>> *h, int *nid,
>>                               bool node_exact);
>> @@ -18,8 +18,8 @@ static inline void hugetlb_cma_free_folio(struct 
>> folio *folio)
>>   {
>>   }
>> -static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
>> -        gfp_t gfp_mask, int nid, nodemask_t *nodemask)
>> +static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t 
>> gfp_mask,
>> +        int nid, nodemask_t *nodemask)
>>   {
>>       return NULL;
>>   }
> The rest look okay.
> thanks,
> -jane
> 
> 


