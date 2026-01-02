Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2C48FA3755
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 21:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5416B0088; Fri,  2 Jan 2026 16:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C726B008A; Fri,  2 Jan 2026 16:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31396B008C; Fri,  2 Jan 2026 16:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C05DC6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:05:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 510D1BE059
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:05:48 +0000 (UTC)
X-FDA: 84288255576.06.0E135E7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id CCD0C100008
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:05:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oeHt16M0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qHI6C40E;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767387945; a=rsa-sha256;
	cv=pass;
	b=H3hA/5eCFPf6oyl9spTAVjPmJj4UkPvlXglvtqoP4svbtH8+IeDzP2tdw5t/AIJ36Nl+iS
	Zx4HNsSg0fHCCLIk+C06MxDhO4Ku5f12HIE7eys2qrOLjdKWRCd0HMkYPnwxMHi2NYFl7N
	Gj3UNUN2neheXjzwbLzNNbQaZfYFM1o=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oeHt16M0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qHI6C40E;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767387945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ertqVy/iaZ/QQRJvR/qZ2VVgNXRgXA68tFtfuu041KY=;
	b=FbMPhwI9P8p77Qeln6tsypucv0ZfH/M4gcERQdrzY5K1X6ahHVPkaw3ppTELKHF/UjJYPY
	A+tKzPnOzFfxNKC3NNO5+IsErNsXtt7q0hMXMBeBdZCbpj1GTum9wZjr87yFdvYGnQEtoF
	U68ZAetCPawJaBD5tctc8xdS91Yn90M=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602BuRXY3048792;
	Fri, 2 Jan 2026 21:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ertqVy/iaZ/QQRJvR/qZ2VVgNXRgXA68tFtfuu041KY=; b=
	oeHt16M0ycom6B4Xi6gmfTDDOtg464isuu+HGwqllWQjfZRtlQrucEAdGll1Kw9A
	4DvvmXcImz3Z/RX2xLCk25liQ21/Sw1+mKi3oYy5woTHTEyRL7jxwE2bxzD3bGBR
	xiStRyB35M3kTE23r+LSVJHR4a1jDvcJyr5aL7dn/U/3RhyC434dDe91NBEDNtfx
	AVT+gohGVvrjT+65llRBdojB2vuyIhiyjfiFPfhZmdO+Je3ileeN1XrhAEnlhZVZ
	oooud9VsY/CTGoJFFxbHjud5dROT+NqFV9Co8BwvyymTqaTwO7/HltW9/Pj3V/Ew
	12QKzMKz90d9idSMgs0y+Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba72qne8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 21:05:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602Js27H022990;
	Fri, 2 Jan 2026 21:05:17 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011014.outbound.protection.outlook.com [52.101.62.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wa6kw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 21:05:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GPx7hui/UWGIiesID51NACl5Rb5upBoeodTgtuVL/GnvjG8DLrzlOAJ+AI8dQjW27naq79R0QeFOgUV5KqSgG0aH0l8t2lDIcBW1KM/z0A3bbtae/yXGzr+ga5oMhbTjgEA6KJaZrmhXi+5K6Z+pb9MmxRXeKqr0p9ZJWouOJiu7K7pndXt2GUNrTHElOlYPvcigZei7KD4Zpya3cAAvnu9y+XRN7IGwyClm2AlZInbl2QuZjS+acncTgWkyXqzeUNvjIdubakoScECsJ3F39qpHD8I2blgcR+OZsmjac22wMhZbNCnq8dPrmAUTjLE3+jdF9N7wla+h3d6ITdlZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ertqVy/iaZ/QQRJvR/qZ2VVgNXRgXA68tFtfuu041KY=;
 b=kAkhDC6YIjGNQue347bjRb83mFwzylSztg+BO+mrrmGAknYy4uv5io8yCI6M1tFM27Yz+glzI6KQvAQyNtlfWdBl2hLHPo5ocGqdg6E604zldrIErVyDxJEtBVFF2OhYOIxrhF+F4o+f9QIyanJAGM4Fq07dQw7zCCuOIvm1TvgvKGR9LLP0Wr7RD0o7/5JjBEZDsdy9bDic9M3RvP2bI5zr8eLpAKT/y9kw9L14y8/6hnEoSHIthAvW+KNVnsDlqdgElrxhjCrkTTO+T1wFaobegKgFArCVPAoCOb6KSTh6xTk+j5mnVy6cYESLFKP/hPjcGNxZMN5L5Tz2tYiGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ertqVy/iaZ/QQRJvR/qZ2VVgNXRgXA68tFtfuu041KY=;
 b=qHI6C40Et0IztW/jxl8X0vaYQ15Pe3ZD1wLjHwUHSqIY9P7V/A/5OAwEpKsIETZPeyXKw+5NtNJROyu2JsYBWVvsWdoV+CLOErsAacmAcsWUnOLUlnKaZqqpHOT0ujmGD/mOHYTpUeLMfz8n1ec5vv+aZQ87lD7ACbLxp0nPSkk=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by IA1PR10MB7285.namprd10.prod.outlook.com (2603:10b6:208:3fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 21:05:14 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 21:05:13 +0000
Message-ID: <ce16c846-5bab-4976-adfd-bef950bc0259@oracle.com>
Date: Fri, 2 Jan 2026 15:05:09 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/6] mm: page_alloc: add
 alloc_contig_frozen_{range,pages}()
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
 <20251230072422.265265-5-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sid Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20251230072422.265265-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:510:325::6) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|IA1PR10MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f601081-dc79-40e7-ffe2-08de4a429f78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFVWMzlOSVh5eTl3NHk4ZnBpY1h5V2FtMkJFYUVaVzZlMXZMVXBvZGZGL0xh?=
 =?utf-8?B?dnVqYnl1Uk5iWEZDNExPZTlRTGN6SXpUcEE2WUZaMWxrcUxraXBHdnI2b3Yr?=
 =?utf-8?B?K29hZEY2dEx6SWRhVFNkSkRNdWNId0dzSVNpY3BlZE8ydjFuR214VzM3OVFs?=
 =?utf-8?B?Zkdyamd6dzUrMlFVZHd2OXRYTSsvWUN1elJHZlhuY25PRENWclVPSGYrNG9B?=
 =?utf-8?B?OFNBTnlzNUxEVlBTcngyTUZ6ajlic3M0bE9xd1RxOUZUSGxPVmg4T0hIblVB?=
 =?utf-8?B?emtyME5HUWtyVmw5blAvV3U2SU43am01MHhLclFqQ21acmZ2TmNRckpNYmpE?=
 =?utf-8?B?Q29MUjF2SHJOcDVNWnF1a3ZqbkNrTlE5aFp1dzVCUmJic3FEdXgzakp3L0RD?=
 =?utf-8?B?ME9xdFFsckkwaC8zUWtjUjVBRmQ3T0M2Ti9uS3RsZGJTNmppNFp1UkpmS1dv?=
 =?utf-8?B?MmszUGV6OFZpc1JtQThxbEZPZTBvVjRKd3k4bGlWMEpZeTg2RVlPU3FjRkxR?=
 =?utf-8?B?TWNVSVByT2E2VWI0ZnFRbnplWit6MG92dFdheVE3ZllWMXBwa0tzSk01dFN4?=
 =?utf-8?B?VWNjelpJTy8xVmpUUWl6ZUMxcC9oMW5hd2oyVzJHOWZwbEozV2d0bVYvaGxy?=
 =?utf-8?B?eVNUWUdoODJFN1JCOERqSmtJMzRjOEFzbHZ0T2JteVNiNFJKZm5LRjV4U0xR?=
 =?utf-8?B?d1cyZTVqL3NpVXc3Smx5VTVybjR4aUtKQ2lPMjJ6Vk9mVEtla2xIcG96R0VS?=
 =?utf-8?B?VktnOE1KVUNuU0lsS29nZHJNdlUzbkhsMURWTXNMb1Z6TVZ5NWZhc0kvQzM1?=
 =?utf-8?B?VkR5K2Fxd01jZXlBSElVUUVQbkNteStBQ3VycDJmYlpiU2xScVJ6dVBaSXNI?=
 =?utf-8?B?MEFzZFNXZHZVUThrdjhDTlZkTE84NUJvbjZ5cEJOOGR1Y0M4TSt4cmlZSDlQ?=
 =?utf-8?B?UXlsditrN1c5NWtFR2ZaL0xiTkp0Q25JSHNuTnZpK0MyVGswYWtabE55L2Fy?=
 =?utf-8?B?SHdXZy9xaFFibUFFTXhVRmVVcEtremhNVDV2NXQ2WU9JQTNUMzk4TDB1QzY1?=
 =?utf-8?B?bXNpc1RkNG1nWjNpT0tRenpmU2xubVhXZ3ZlWG9HZHhaVyt5bUxuNW1QMnZW?=
 =?utf-8?B?eXZpV0NGY25mMk5Da3Z0QmdOcWQ4MitOMlppbzlDRGh0dE1QQWVyYU0wQnQv?=
 =?utf-8?B?R0c0ZEhpWWpxdnpVS05SZFhRLzRYOVMweXl3Nmkyd2hCUXhRWEI2R0JjaE5T?=
 =?utf-8?B?empKSEQ4U0MxcWt0Y2RDWmxLeE94RzRNV24ybzVnZGNrWFF4eWMyM01BMU9G?=
 =?utf-8?B?aEtndFBKZjJYTmMyL3pocjFiZEx0c0hDTFZNdHIyanBPWGhrVjZUVXhIV1VV?=
 =?utf-8?B?SENHazVRSi9wYUlISm50VXhNMm1VS2plcWRTVHppbU1DM2ZnblpNek8zRFVS?=
 =?utf-8?B?U3ZRWTdBNWJObXFubEVPRU1EZUtXTFFxS1VGV09RQVkwQnFSK09vSEpMVHBO?=
 =?utf-8?B?Zk8yOXl4Zm90Y3NxRlF0RllmTFc3c29UNkZiOXZHT0VJQ0hRTno5a0ZaaGhu?=
 =?utf-8?B?WUJhaGlBV3hhRzN3T2dRYmJISlVTeTE3ZjRWOWdkZ2xxc0d1ZnJaWlRUTno2?=
 =?utf-8?B?Y3VWakRCbGRHeU92MUhjTlJac25qVDViZitwWkRyYnc3TzVOWnpvS1dITnZq?=
 =?utf-8?B?NUZ5RmRIWVllZ1ZvY1BZakljSFlpUTd3YjYzWVB5SU5za1dmZmxTa1BFeC92?=
 =?utf-8?B?bXZHNlQ0UkpRYWkySFJKVVNkTEYxcmVlT2M1Y1dCNTg1Ymx4SVVtbGJFVmlO?=
 =?utf-8?B?TEhnanZkK05QWVk4aFRUNmNjeHIwTzRlT25lcjY5cHJLK3FHcVlGa2F3N3pY?=
 =?utf-8?B?TVp0QUhVOExzeUprVGIxL3FEcmEvQ3ZhUUJZZ0Q2SUlPWnNqREJsL1VBc3VS?=
 =?utf-8?Q?4yUGX6wPzvtI+lMHf1vV7mODFplYigUE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0JTWWJTVEdiZXN4TlFiTmZRNzlpYnQySnBDczZiTHlkeW1sN1o1UWZrNVNk?=
 =?utf-8?B?MzN2emYwUWpCZFRnYlk1ek1pcHFBZjQvQUdzT1hOWU44b0hSYTAxdVMvamxW?=
 =?utf-8?B?YUkyaGhaK3hFYjk1K09LNHlibXJQUkJqaUdsRVFDemJ3Vm9zbkNUN0xLMDNo?=
 =?utf-8?B?WnlWbS9jdEZLS0hNUFk3Zm9qZTlUdDBGK253L29QMlB5Ylh5NDErYzJwS3RX?=
 =?utf-8?B?Z2pFS0lLc2JWbHVDb0paOXJTMlVGMklnU01jTWFDazJ2M3RKZ2lYVnpINFVV?=
 =?utf-8?B?THVkODZnQktvRWlaYzEwaTYyODc3Vy8ybUY1dFd1bTJFeTYxUjdJSDEzZ3pC?=
 =?utf-8?B?UHRLanFqWXFUdEhoY1R0NHJXMHJhVzFPLzl5eTBmSmZaVjhnMnpTYmxpd09k?=
 =?utf-8?B?NnpDZm1DbHNsRVdQeHp4ZHIrb2pLZDVOQno2b3FTckwzS2dwU2d6eG9OMGNj?=
 =?utf-8?B?amljbUNOUk9QQXIrRFJzZzJVY0ZTSjRlblhJNFlNMFV1R3U5SXhFYjRYK2dI?=
 =?utf-8?B?UUtBK3phVU1PTDVUVVBCS1BKYkVScDdpMWpOM2Y5ZUtXUGJ1MlVmbCtMVUp3?=
 =?utf-8?B?Q0ozb05HTGJEeVJYSExjaGhiaFMxOVBaSlg5c1hBa1p3NVUyUnNidjR4dCtK?=
 =?utf-8?B?RFpnVVR6YlBFanpLZkNIeTFSMzZyM1FMSnJ6VUVjdzQ2U1dSMkI4ejh0YXRy?=
 =?utf-8?B?UEttMnhIN0l4NnBCS1k5eWk1Sko5anFLSFo4QWtjZEQ2cXZYVU1uRHJBbjNo?=
 =?utf-8?B?ZzN6eXQzalFyaytBVGdvUVMrcXFnU09tWE15MjRkQ1I2ekxFc2tZakN3UldY?=
 =?utf-8?B?enp4c3p5cFo0cUp5MlBsMHMwVzhmNWZYa2VhblhPUjlBOHRzdUZsWG5tR01U?=
 =?utf-8?B?K0ZsWXFFRjBlNE0xQ1ltZ1lvVTV4SkR0REw3R0lDWTI4elMrbUVLQzJtU291?=
 =?utf-8?B?Sy9iUVJvVzU0cFJKb1hWZ1BOWVNsNXVFME1Nb0RpbitMOUxYWXgrUG1lUXBQ?=
 =?utf-8?B?aDdnbjlWNHNIbVFCVktBcUp5QzFLMjVMM3NobWhkclpiWTBmNHBLWEE5MVJM?=
 =?utf-8?B?dEFEMmgzbjZVVEJQNVhyd1JUNGRMUVdvYnNCUm9xWHJZT1RRNjU3eDdXVWZ3?=
 =?utf-8?B?cTlSendiUkdGQm1xU2phK1pzSjRWUGsxWm1wblNFWjQ1dExIZGtMbjhEOXVC?=
 =?utf-8?B?UVNIYWxHY1VudmVFNDc2OUYwV2RPYWIvQjJKQ0lBVENXMXAzRVRrMWErT0N6?=
 =?utf-8?B?bHBkL0Fhb2lKZWRFcjZPK1dKWXI5ZWw1YzRCc3RWQmRhL2ZTYmYraWRnRzU3?=
 =?utf-8?B?djljNThOclY4UVJLSCt3UGRKWTVmdEJIZi9NSjJMMWU4M0pOSkordDYrOWJy?=
 =?utf-8?B?VWpMRjdzL3lJcWd1VWRLbUViNVVXN05hQjR1S3VDNENtTC8vejZyOVhLU2hX?=
 =?utf-8?B?bEVVT1VFb1BvRStZUEVnVXl6ZllFMkVxOXhSbE9JelZNd05DWU9vRndycVY0?=
 =?utf-8?B?K1FXdTNDUzNPQlg1Yy9uVXFNNlZweC9MMDNDWkk1RVBjVW1iT3hQaEE3Mllo?=
 =?utf-8?B?S0t2aXBRbVhOcjBaUFpVS2RSSlQ2ZWU2MDBndG93RU9TOE9tNWYwQWxhRDhQ?=
 =?utf-8?B?N1R5TmliRDhuNWkrVy9MVnhPQXVWWG9QVnA2RC9jdEIvUURTcW44ZmtSWU5k?=
 =?utf-8?B?VHJ4c0hsb0phdTU3MTc1ZXhyTjYxM2hzdVdzNW5PbGtudXd5TjBFeUJ6QU05?=
 =?utf-8?B?OWhmZlZBRCtVVCtFMWYxUmt3bzVGT3k3RDJLQ2xwamt4LytuMXRmRDVaTVVX?=
 =?utf-8?B?Zk1YWHNKcktSSGR5aU1NeFpaWFh6eEFyVUg2L0Z1QnFDRjVvRnY2N2pQZWlI?=
 =?utf-8?B?dXZIN1dMTVlNVFk1QUpFT2xVSTNlRkRjVUxmUE8yS2JvWnhhY1hCeGVqVEd5?=
 =?utf-8?B?OE1kTW5qeVkrSXVCUWVycWtCcWRuMWFwSjltN2wxbGFhOENucVBRUlZ3S3Bj?=
 =?utf-8?B?Q3E0aXhOaEpQSFptQjZaUWlQV2p4TWs5ajFsRFphTWZqSmwrZUdnTTNWbTU4?=
 =?utf-8?B?VWswQWVnMlRsbG4zbXphWVpCODdvbWFHbFEycnljRm9nN3dxenVMZWpqQUlo?=
 =?utf-8?B?K0ZZZDRqMnlybUVxL3NEUndXeU5EL1NpdEEvTUtoTWlPcUR6VXFVSzliZ2ww?=
 =?utf-8?B?bnNEa241bnJHUmJYVjJmUnNjT2dpc1k2K0RGem5pS285QVBKTHo2MGtQZjNU?=
 =?utf-8?B?SDV0cmM0NmxtT3UwZUNlMUFHTW1tMEFBbVhsZ3hoUU5rUUovd0d3cEJaNUxN?=
 =?utf-8?B?UDRiK2lyd3BaZGRJemQ2YU5qTVl4OXA5cHdnZDROZTBIVzF0UTgvQmpwSzNO?=
 =?utf-8?Q?if2r8zjLKG4yLvaA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/XkbRAUjyeU2hGSlvanw6T5voDti1inwTgt6kS3QgYf5GIa1G0ZnqU4/SYS1Bdbcr4Wnj4EXMIcsQ1bhkJeA7gtEuAvJY+OL1Rk4eRLpKk6RpuD1u04z1/lH55QU3ZjqA/3gil8xHrX8Z4JeTvuAHr1MQg7sGxPw6O4ZdX2stlR7ZIKrKB6Y8Puw99oFmiA94a3R4cQHn/kK83RoFYylnXMJQHakIvak4u2gpe47+DmtkkaC1kCMAfKWcY7kDi+nUcxdszDn1iQlzGFK67QmIf3tM+d/0BDW0SunkwCU7O/gepbJeC6e1rWMkxsZS+9Nmx3mbiv4T4jZTIU/FmNIc8dKmEc5jzwxhvj7dorlnPyk1mLjT1G7ffuVMM2yjoWA9psBQNsbLYFhWzxUMxtTKxiUYy/NlUXKMm6bYlCWq05PsfFtm5x+Lmr4CuBKGuACTWveZWa5RFhZBrOaeg+kWk9UZfdtTB4LDKXUHGEzcJKcPE/9VZISaOeB/9bMf57RdrgqA5hBaFJeiuife/QpHrD9Zr6+zFednhzDIh2SyqPqkVXcLVrq7GpkAG3Ff9wLFZqK1GKXQXZSToNIr7pfkPsBPd58qqsZDzaxqUrml00=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f601081-dc79-40e7-ffe2-08de4a429f78
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 21:05:13.9191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5T8rdKpR8N6335uZK2QBhjw3slVmTqIDLsNLolQZ5lBZTp0E3WlYcFvJDSsftvUPggvQvGtGZgwyGynlNyc8v96a+1Qq88IFpNFxd3mGCcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_03,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020189
X-Proofpoint-GUID: ySe0KpEoUEyOph4vVhquEX36XEx7KXcy
X-Authority-Analysis: v=2.4 cv=MqBfKmae c=1 sm=1 tr=0 ts=6958330e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=7U4-wwcSMfVntILg030A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ySe0KpEoUEyOph4vVhquEX36XEx7KXcy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE4OSBTYWx0ZWRfX7dnJJBLn/Zt0
 ojsSl7LYeEwVGrrcT43irS8vwQ8jCbaUYHtXmxbaj112uMsSlUzZzCinlzbQnovWJzSDuM36b9d
 BxXgYgJFS0YhHwXGGpSwTJTv3roJFJCQXdXqY5ePZJu3v1wcLJWUpLecsqww+ZaLj7RJKJDf/NV
 lC9D5WyOy00U8FPMB5viIiClUCqGu8m4TUmLWnHZ5WGUnFQcD4mKPQZhQPxZt1BfUqHSeaRD+/H
 SQgMSUQ6ztFyaICVrNDq3XjO+U8krwdC6SD7MoMzM5FpV22LHmzNVUdMcaQQYD++kNwBfZC+YsV
 vQXn1A6bS0vSAbQGhzqu5zI/A6kZ3RoCqxtyMjeuGIL20QkxWXRvkTPikK4HRx3WPVxPjrDMcie
 vjUD3BQrgMCoFXBbhv24+ZnqmGx+xoHtMsJows9L0g5snw5HUoWbOU9LE6Hr9THVAEDur27aqQ1
 37zVZog3WebLyRBD2XQ==
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCD0C100008
X-Stat-Signature: bhfffkcpqm79nuo4fa7aur8rcdwuocm7
X-Rspam-User: 
X-HE-Tag: 1767387944-112019
X-HE-Meta: U2FsdGVkX19RhznFPwwCFyL1fQkZt8nI6Gg19dtpz0nn/O52uTGP+gDEXkZA75L66WDtRp/Qat579jyfChEJSKhBymT+oWfST97qv/NPZbdH+MoP9JKLLA+p4AeXYM5uKvHwD7vKcf1hRDpsHcSzirwedd6PXMGYuI313TDdyLdFagLhAkyVsehqQSwwSXSmLs8JWiKKIom1cFwMSqwS+RnmTVu2qcl6iAhBK/6R5yqS1gU53HgVLB3qDfOvBfb6Bl77N5mdTRhJzSus0OLWFLERJJr6kptmRX+piBioWe4syz+FtxByg5VWUdoJz/4S+v8z4k46OLKKIQGk8zMaRDaP9XPCvSVTsaFofUIVJtBnQxkifibFHp7rC6S9sOsw05a6aaDGnTWthZ+cLmkPa+9+YReIZzLQpWD7p/u4pU7BXEIIN4J9uPVnbbnJ9DSuBcHCYCZvmuvVRmQcNCbjZ3kkDjbNFz50/K3Zq4Uld7kOtPFpvKFZJYC85l8NH/UOShV3mar6IcCcQWypZ+JFxpUyxXGEIbeRlN+W8xPbHWXLvqY0zK3MO+7Y5m4Qhku/kO1+DQkTiCSrcojWSQ/XimVB1W5Wi65nsGy+wTAEXMcF9IwKnTK1dPotSvfl4pRk+ND1Dzjfo7oTlvxEynByeJc0aqwS9L3R1rFHyG04zLIc6HSLbiX/aecAt2yL9IVLllqbq9nwpyU4UqKUnBxD7iyUp+4MEjl07ndmqexEZxvzZg13dfR5iQHfldAoa1Sh7E3iNpOIiI7V+037P3mTEDdg9HgyD6oPucSfrHCimIvHoBzMcE0YxR+JAij3aor9QP2pQra6GQ3PmWZ+nnvkVgpfYblIwwUr9Kyd3RtZ9tlD7LR356uqUXml5I9+PqYaqSxq/VpmxVe1kiY/as9Kkukyz/9BlTrF7O7E/v86s3gkckEa8T5TVQa8k8vmq0THTPu5+hcEzILgwGb/Wk7
 Um2pI6kl
 ApqrAJYFXh0PH8mxqfQAW7RhXx0jMOgJPNL2z9Cm6DUDkfJpxWaa7wZQE3lLndYVcc1TPdYnF7BH9XDwMYLLnptxj/MR5w9ghD9Jyf9yju3/qcO/gFScqPSmKe7ZGeA/o1QbOjSmcpbVHJ8fzKwIADhE1n+90GkNd3zrULL2bjlMr56qCWI61hKMyRL4MDO9euUJx0Iih1OLP68Gmn8EYzAwNl0FL9DO2iLMWeVJOSkBsH88mgldvcfzF18loYXJrzzxPiPnLMhc0CXsr8sDh8HCVLnHVDXWA4eyG4/TjZXTi8XvYwAACbyjWayykGZsZFXse2HZp+OW5cS4SwriiCDWmo++lgMaoYqJxJ8UXLWD3+xszT0PwS9IhM3CkuKEyhXaa2vGs22YazOxps5TrW33e80Cgxy33qtYJaqUjJ/41I/dyLzJAUKsBKGRsRos1spvH7ztgBrh6VbQJieX054vxTwixJIw+zEYc1/lxTxd76k9gsuhjoOxu8qDErlEUu/Bd/YTd3fTsVilwIO+tFuMjRENDfFhJFJ2QGcaK0iziMMouWdvbtLc4bOoFTNCU2V9Iw+pHUBSkSxqTHAokvUfqc+pUpNtnPZex3KUWGTziZMMwR3YoycWiXyRbG4CkBM8gaTORyIVSmqDx/MZo562UE7pncpe7LXCfwvwmeKPx+dHCI4LuqlOj7WT3GrSqJSLHVkHwoX3TK3Vnw6vq4BgiCNFB6R0QWeW2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/30/25 1:24 AM, Kefeng Wang wrote:
> In order to allocate given range of pages or allocate compound
> pages without incrementing their refcount, adding two new helper
> alloc_contig_frozen_{range,pages}() which may be beneficial
> to some users (eg hugetlb).
>
> The new alloc_contig_{range,pages} only take !__GFP_COMP gfp now,
> and the free_contig_range() is refactored to only free non-compound
> pages, the only caller to free compound pages in cma_free_folio() is
> changed accordingly, and the free_contig_frozen_range() is provided
> to match the alloc_contig_frozen_range(), which is used to free
> frozen pages.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   include/linux/gfp.h |  52 +++++--------
>   mm/cma.c            |   9 ++-
>   mm/hugetlb.c        |   9 ++-
>   mm/internal.h       |  13 ++++
>   mm/page_alloc.c     | 186 ++++++++++++++++++++++++++++++++------------
>   5 files changed, 184 insertions(+), 85 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index ea053f1cfa16..aa45989f410d 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -430,40 +430,30 @@ typedef unsigned int __bitwise acr_flags_t;
>   #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
>   
>   /* The below functions must be run on a range from a single zone. */
> -extern int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> -				     acr_flags_t alloc_flags, gfp_t gfp_mask);
> -#define alloc_contig_range(...)			alloc_hooks(alloc_contig_range_noprof(__VA_ARGS__))
> -
> -extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> -					      int nid, nodemask_t *nodemask);
> -#define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
> -
> +int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
> +		acr_flags_t alloc_flags, gfp_t gfp_mask);
> +#define alloc_contig_frozen_range(...)	\
> +	alloc_hooks(alloc_contig_frozen_range_noprof(__VA_ARGS__))
> +
> +int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> +		acr_flags_t alloc_flags, gfp_t gfp_mask);
> +#define alloc_contig_range(...)	\
> +	alloc_hooks(alloc_contig_range_noprof(__VA_ARGS__))
> +
> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask);
> +#define alloc_contig_frozen_pages(...) \
> +	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
> +
> +struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> +		int nid, nodemask_t *nodemask);
> +#define alloc_contig_pages(...)	\
> +	alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
> +
> +void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
>   void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>   #endif
>   
> -#ifdef CONFIG_CONTIG_ALLOC
> -static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
> -							int nid, nodemask_t *node)
> -{
> -	struct page *page;
> -
> -	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
> -		return NULL;
> -
> -	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
> -
> -	return page ? page_folio(page) : NULL;
> -}
> -#else
> -static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
> -							int nid, nodemask_t *node)
> -{
> -	return NULL;
> -}
> -#endif
> -/* This should be paired with folio_put() rather than free_contig_range(). */
> -#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
> -
>   DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
>   
>   #endif /* __LINUX_GFP_H */
> diff --git a/mm/cma.c b/mm/cma.c
> index fe3a9eaac4e5..0e8c146424fb 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -836,7 +836,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>   		spin_unlock_irq(&cma->lock);
>   
>   		mutex_lock(&cma->alloc_mutex);
> -		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
> +		ret = alloc_contig_frozen_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
>   		mutex_unlock(&cma->alloc_mutex);
>   		if (!ret)
>   			break;
> @@ -904,6 +904,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>   	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
>   			       page, count, align, ret);
>   	if (page) {
> +		set_pages_refcounted(page, count);
>   		count_vm_event(CMA_ALLOC_SUCCESS);
>   		cma_sysfs_account_success_pages(cma, count);
>   	} else {
> @@ -983,7 +984,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   		return false;
>   	}
>   
> -	free_contig_range(pfn, count);
> +	if (PageHead(pages))
> +		__free_pages((struct page *)pages, compound_order(pages));
> +	else
> +		free_contig_range(pfn, count);
> +
>   	cma_clear_bitmap(cma, cmr, pfn, count);
>   	cma_sysfs_account_release_pages(cma, count);
>   	trace_cma_release(cma->name, pfn, pages, count);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a1832da0f623..c990e439c32e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1428,12 +1428,17 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>   retry:
>   	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>   	if (!folio) {
> +		struct page *page;
> +
>   		if (hugetlb_cma_exclusive_alloc())
>   			return NULL;
>   
> -		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
> -		if (!folio)
> +		page = alloc_contig_frozen_pages(1 << order, gfp_mask, nid, nodemask);
> +		if (!page)
>   			return NULL;
> +
> +		set_page_refcounted(page);
> +		folio = page_folio(page);
>   	}
>   
>   	if (folio_ref_freeze(folio, 1))
> diff --git a/mm/internal.h b/mm/internal.h
> index db4e97489f66..b8737c474412 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -513,6 +513,19 @@ static inline void set_page_refcounted(struct page *page)
>   	set_page_count(page, 1);
>   }
>   
> +static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
> +{
> +	unsigned long pfn = page_to_pfn(page);
> +
> +	if (PageHead(page)) {
> +		set_page_refcounted(page);
> +		return;
> +	}
> +
> +	for (; nr_pages--; pfn++)
> +		set_page_refcounted(pfn_to_page(pfn));
> +}
> +
>   /*
>    * Return true if a folio needs ->release_folio() calling upon it.
>    */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b9bfbb69537e..149f7b581b62 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6882,7 +6882,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
>   	return (ret < 0) ? ret : 0;
>   }
>   
> -static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
> +static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>   {
>   	int order;
>   
> @@ -6894,11 +6894,10 @@ static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
>   			int i;
>   
>   			post_alloc_hook(page, order, gfp_mask);
> -			set_page_refcounted(page);
>   			if (!order)
>   				continue;
>   
> -			split_page(page, order);
> +			__split_page(page, order);
>   
>   			/* Add all subpages to the order-0 head, in sequence. */
>   			list_del(&page->lru);
> @@ -6942,8 +6941,14 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>   	return 0;
>   }
>   
> +static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	for (; nr_pages--; pfn++)
> +		free_frozen_pages(pfn_to_page(pfn), 0);
> +}
> +
>   /**
> - * alloc_contig_range() -- tries to allocate given range of pages
> + * alloc_contig_frozen_range() -- tries to allocate given range of frozen pages
>    * @start:	start PFN to allocate
>    * @end:	one-past-the-last PFN to allocate
>    * @alloc_flags:	allocation information
> @@ -6958,12 +6963,15 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>    * pageblocks in the range.  Once isolated, the pageblocks should not
>    * be modified by others.
>    *
> - * Return: zero on success or negative error code.  On success all
> - * pages which PFN is in [start, end) are allocated for the caller and
> - * need to be freed with free_contig_range().
> + * All frozen pages which PFN is in [start, end) are allocated for the
> + * caller, and they could be freed with free_contig_frozen_range(),
> + * free_frozen_pages() also could be used to free compound frozen pages
> + * directly.
> + *
> + * Return: zero on success or negative error code.
>    */
> -int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> -			      acr_flags_t alloc_flags, gfp_t gfp_mask)
> +int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
> +		acr_flags_t alloc_flags, gfp_t gfp_mask)
>   {
>   	const unsigned int order = ilog2(end - start);
>   	unsigned long outer_start, outer_end;
> @@ -7079,19 +7087,18 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>   	}
>   
>   	if (!(gfp_mask & __GFP_COMP)) {
> -		split_free_pages(cc.freepages, gfp_mask);
> +		split_free_frozen_pages(cc.freepages, gfp_mask);
>   
>   		/* Free head and tail (if any) */
>   		if (start != outer_start)
> -			free_contig_range(outer_start, start - outer_start);
> +			__free_contig_frozen_range(outer_start, start - outer_start);
>   		if (end != outer_end)
> -			free_contig_range(end, outer_end - end);
> +			__free_contig_frozen_range(end, outer_end - end);
>   	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>   		struct page *head = pfn_to_page(start);
>   
>   		check_new_pages(head, order);
>   		prep_new_page(head, order, gfp_mask, 0);
> -		set_page_refcounted(head);
>   	} else {
>   		ret = -EINVAL;
>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> @@ -7101,16 +7108,40 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>   	undo_isolate_page_range(start, end);
>   	return ret;
>   }
> -EXPORT_SYMBOL(alloc_contig_range_noprof);
> +EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
>   
> -static int __alloc_contig_pages(unsigned long start_pfn,
> -				unsigned long nr_pages, gfp_t gfp_mask)
> +/**
> + * alloc_contig_range() -- tries to allocate given range of pages
> + * @start:	start PFN to allocate
> + * @end:	one-past-the-last PFN to allocate
> + * @alloc_flags:	allocation information
> + * @gfp_mask:	GFP mask.
> + *
> + * This routine is a wrapper around alloc_contig_frozen_range(), it can't
> + * be used to allocate compound pages, the refcount of each allocated page
> + * will be set to one.
> + *
> + * All pages which PFN is in [start, end) are allocated for the caller,
> + * and should be freed with free_contig_range() or by manually calling
> + * __free_page() on each allocated page.
> + *
> + * Return: zero on success or negative error code.
> + */
> +int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> +			      acr_flags_t alloc_flags, gfp_t gfp_mask)
>   {
> -	unsigned long end_pfn = start_pfn + nr_pages;
> +	int ret;
>   
> -	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
> -					 gfp_mask);
> +	if (WARN_ON(gfp_mask & __GFP_COMP))
> +		return -EINVAL;
> +
> +	ret = alloc_contig_frozen_range_noprof(start, end, alloc_flags, gfp_mask);
> +	if (!ret)
> +		set_pages_refcounted(pfn_to_page(start), end - start);
> +
> +	return ret;
>   }
> +EXPORT_SYMBOL(alloc_contig_range_noprof);
>   
>   static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   				   unsigned long nr_pages, bool skip_hugetlb,
> @@ -7179,7 +7210,7 @@ static bool zone_spans_last_pfn(const struct zone *zone,
>   }
>   
>   /**
> - * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
> + * alloc_contig_frozen_pages() -- tries to find and allocate contiguous range of frozen pages
>    * @nr_pages:	Number of contiguous pages to allocate
>    * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
>    *		action and reclaim modifiers are supported. Reclaim modifiers
> @@ -7187,22 +7218,25 @@ static bool zone_spans_last_pfn(const struct zone *zone,
>    * @nid:	Target node
>    * @nodemask:	Mask for other possible nodes
>    *
> - * This routine is a wrapper around alloc_contig_range(). It scans over zones
> - * on an applicable zonelist to find a contiguous pfn range which can then be
> - * tried for allocation with alloc_contig_range(). This routine is intended
> - * for allocation requests which can not be fulfilled with the buddy allocator.
> + * This routine is a wrapper around alloc_contig_frozen_range(). It scans over
> + * zones on an applicable zonelist to find a contiguous pfn range which can then
> + * be tried for allocation with alloc_contig_frozen_range(). This routine is
> + * intended for allocation requests which can not be fulfilled with the buddy
> + * allocator.
>    *
>    * The allocated memory is always aligned to a page boundary. If nr_pages is a
>    * power of two, then allocated range is also guaranteed to be aligned to same
>    * nr_pages (e.g. 1GB request would be aligned to 1GB).
>    *
> - * Allocated pages can be freed with free_contig_range() or by manually calling
> - * __free_page() on each allocated page.
> + * Allocated frozen pages need be freed with free_contig_frozen_range(),
> + * or by manually calling free_frozen_pages() on each allocated frozen
> + * non-compound page, for compound frozen pages could be freed with
> + * free_frozen_pages() directly.
>    *
> - * Return: pointer to contiguous pages on success, or NULL if not successful.
> + * Return: pointer to contiguous frozen pages on success, or NULL if not successful.
>    */
> -struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> -				 int nid, nodemask_t *nodemask)
> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
>   {
>   	unsigned long ret, pfn, flags;
>   	struct zonelist *zonelist;
> @@ -7224,13 +7258,15 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>   						   &skipped_hugetlb)) {
>   				/*
>   				 * We release the zone lock here because
> -				 * alloc_contig_range() will also lock the zone
> -				 * at some point. If there's an allocation
> -				 * spinning on this lock, it may win the race
> -				 * and cause alloc_contig_range() to fail...
> +				 * alloc_contig_frozen_range() will also lock
> +				 * the zone at some point. If there's an
> +				 * allocation spinning on this lock, it may
> +				 * win the race and cause allocation to fail.
>   				 */
>   				spin_unlock_irqrestore(&zone->lock, flags);
> -				ret = __alloc_contig_pages(pfn, nr_pages,
> +				ret = alloc_contig_frozen_range_noprof(pfn,
> +							pfn + nr_pages,
> +							ACR_FLAGS_NONE,
>   							gfp_mask);
>   				if (!ret)
>   					return pfn_to_page(pfn);
> @@ -7253,30 +7289,80 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>   	}
>   	return NULL;
>   }
> +EXPORT_SYMBOL(alloc_contig_frozen_pages_noprof);
>   
> -void free_contig_range(unsigned long pfn, unsigned long nr_pages)
> +/**
> + * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
> + * @nr_pages:	Number of contiguous pages to allocate
> + * @gfp_mask:	GFP mask.
> + * @nid:	Target node
> + * @nodemask:	Mask for other possible nodes
> + *
> + * This routine is a wrapper around alloc_contig_frozen_pages(), it can't
> + * be used to allocate compound pages, the refcount of each allocated page
> + * will be set to one.
> + *
> + * Allocated pages can be freed with free_contig_range() or by manually
> + * calling __free_page() on each allocated page.
> + *
> + * Return: pointer to contiguous pages on success, or NULL if not successful.
> + */
> +struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> +		int nid, nodemask_t *nodemask)
>   {
> -	unsigned long count = 0;
> -	struct folio *folio = pfn_folio(pfn);
> +	struct page *page;
>   
> -	if (folio_test_large(folio)) {
> -		int expected = folio_nr_pages(folio);
> +	if (WARN_ON(gfp_mask & __GFP_COMP))
> +		return NULL;
>   
> -		if (nr_pages == expected)
> -			folio_put(folio);
> -		else
> -			WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
> -			     pfn, nr_pages, expected);
> +	page = alloc_contig_frozen_pages_noprof(nr_pages, gfp_mask, nid,
> +						nodemask);
> +	if (page)
> +		set_pages_refcounted(page, nr_pages);
> +
> +	return page;
> +}
> +EXPORT_SYMBOL(alloc_contig_pages_noprof);
> +
> +/**
> + * free_contig_frozen_range() -- free the contiguous range of frozen pages
> + * @pfn:	start PFN to free
> + * @nr_pages:	Number of contiguous frozen pages to free
> + *
> + * This can be used to free the allocated compound/non-compound frozen pages.
> + */
> +void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	struct page *first_page = pfn_to_page(pfn);
> +	const unsigned int order = ilog2(nr_pages);
> +
> +	if (WARN_ON_ONCE(first_page != compound_head(first_page)))
> +		return;
> +
> +	if (PageHead(first_page)) {
> +		WARN_ON_ONCE(order != compound_order(first_page));
> +		free_frozen_pages(first_page, order);
>   		return;
>   	}
>   
> -	for (; nr_pages--; pfn++) {
> -		struct page *page = pfn_to_page(pfn);
> +	__free_contig_frozen_range(pfn, nr_pages);
> +}
> +EXPORT_SYMBOL(free_contig_frozen_range);
> +
> +/**
> + * free_contig_range() -- free the contiguous range of pages
> + * @pfn:	start PFN to free
> + * @nr_pages:	Number of contiguous pages to free
> + *
> + * This can be only used to free the allocated non-compound pages.
> + */
> +void free_contig_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
> +		return;
>   
> -		count += page_count(page) != 1;
> -		__free_page(page);
> -	}
> -	WARN(count != 0, "%lu pages are still in use!\n", count);
> +	for (; nr_pages--; pfn++)
> +		__free_page(pfn_to_page(pfn));
>   }
>   EXPORT_SYMBOL(free_contig_range);
>   #endif /* CONFIG_CONTIG_ALLOC */

