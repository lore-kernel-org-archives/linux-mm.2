Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA3FCAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882AD8E0011; Mon, 15 Sep 2025 05:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A718E0001; Mon, 15 Sep 2025 05:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721DB8E0011; Mon, 15 Sep 2025 05:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1248E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:42:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 249DB11A593
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:42:48 +0000 (UTC)
X-FDA: 83890995216.20.ADB4B2F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 83A49180003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:42:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sTZ2UgLg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0I8evyLC;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757929364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRv8ho+Wx7O8/VM32RU8n5PrVrd/UeH5oPpmpWrFp1Y=;
	b=6shm4Wyon60mRqUiOudVLa9UskGuTarydaSnc0QG69PH60ebNibg2jNkP9y/10t5XaQSf7
	I+J25zgEVA9iKIbruXWpC+uGuVg50OmLBlOlMRiXzkYqsDkd5WbrcBnvQ5KCdjzsRvTBcm
	q/t7SLPPfN2mdSLxstQ6pq6NVIM6VxU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sTZ2UgLg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0I8evyLC;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757929364; a=rsa-sha256;
	cv=pass;
	b=RpHQz90Mfqnr6vCvgA13v5rWw+kFUeIIE2I4cG2GvyXTA7jjCcx00smLXFOGAF9SbI5asA
	fpyrDRt09sOFqmlNEclDFdLFj9eKA+7V8XMU32ux24jOzlsjD+U1USxyx8krooCTzPTUWA
	Of6CJGBIZ1JcSV+disHK7w6LpLP8vSw=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6fxU9028408;
	Mon, 15 Sep 2025 09:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LRv8ho+Wx7O8/VM32RU8n5PrVrd/UeH5oPpmpWrFp1Y=; b=
	sTZ2UgLg3paQZIOjU7btsb3sEuyMMM77Det0PDjv5dq6ckVBKsvAVyFqwcZQvYpF
	t1keslH21Atqg03qiXm76e/DXfG5ypW3CmZF0WXiMB7Qbr4XdPZreBTuxurzxHCv
	9ay/FtZUmSr5C4AMXL2nHUjn3/1m96D0t1dl9IELL9LCTpbm0PSpGi0uzR+nS3LI
	HPEYSsOLYD4iUkuy/b812XFgSa8YLAlxpFML+FanJS4z9RmTZalT6iDAgbqF1NCu
	uKj2Zb4k+v7g+rzFevtpubB1pyu87oLCZBVgBh5l1Px36cqG85bFTpPkA31uREiY
	y9UlsQ7+aAVXQVMuG08DBA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950gbhy1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 09:42:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8bCR3037399;
	Mon, 15 Sep 2025 09:42:35 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012027.outbound.protection.outlook.com [52.101.48.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2h24mx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 09:42:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YGGSpavXP7OXOH6kOHurxVa8G8pl8p9PEsfcwWkfprEEFgyq7FmAohE/vPCS5HGOskiA3L8X7zAworWXEhCtukvzIZYvaY0lVAwpOTQguULnSSsne33dYh779l4hGF4nfVmhry4BrTYsZk2mh3TV77KraCicliUOHyOHFiaYuwZ/3EikaYcMXp8uaA4G7/Q2WqiQwbz3MZFIp3p9ztjV73FPie8EAnyw7a9nXuwNJUItkY9hBw/+bRFMvOgMJ+6WSzyUm8WmJHp57DDd6Tr8rltRWBdJWrhm2SyKv3JWmrxk+4vMP0wkeAOPww1FINcJ7D0VH67ykF2fH7XjIgU0Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRv8ho+Wx7O8/VM32RU8n5PrVrd/UeH5oPpmpWrFp1Y=;
 b=a0dpj4pLpC5HxWIu//StHx6YKT8HveSLZDoX1NF2odNuBaOyqivzx1P4lEoAtgRxtBSK1NlxU0Ws5wo7dATmjQJHBz4+inUFKL8YGNlYbEta7L2BDOGoYAGERTxvlFw+yTleBNZF6za94kDBnfWhcreqM3EKgjq3LBb2bapleiwvdtvW1Rzj5MBkA9eQ1YdkrRowll30vFkZtc6f2hzxE5ap1N03ISRkX3aryMjUrxOP5NawFLV4hJR2MpKdZphcHkXZYmdTvo5c8/B1kiFeo5Pol454L9u3268p0aKkzPsGzQ/aLizjSUjcNK6VyYBv25ZL9aj0v9qYkSvjdHcSPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRv8ho+Wx7O8/VM32RU8n5PrVrd/UeH5oPpmpWrFp1Y=;
 b=0I8evyLCT7uw+QQ8t/inCN7aD+2EMs088V9LnqeqY5I+yvgZFpiICoBoDY4FMmJAGteXXYTamUmO4Hh/poZE34AOBhY8iDlYyXOd9AsVH3CJoOh1glrBbgYmappebBqCxHK7Nk1ypk4XHStcjzmcuaF9RRlsoss72Jy5US8BlGA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6776.namprd10.prod.outlook.com (2603:10b6:8:13b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 09:42:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 09:42:32 +0000
Date: Mon, 15 Sep 2025 10:42:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Barry Song <21cnbao@gmail.com>,
        Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
        SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <585b0ca3-cc56-4f74-9950-800d6faf8012@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
 <aMd-2argDQCHww_Q@casper.infradead.org>
 <18361483-5089-4414-b974-4c481189b9fa@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18361483-5089-4414-b974-4c481189b9fa@redhat.com>
X-ClientProxiedBy: LO2P265CA0245.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: c48e40c1-e00b-4e9f-1e1c-08ddf43c319f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TW8xcDZEb0Q4NlE3Ukp4WDhhRmxjSFFqUEgrUE1qNXl3MmE1MHAvcHRJWTI3?=
 =?utf-8?B?L1EvRytrdE9KNFp4NmZBVVZuVDNQdlRZUm81UjlJSldvQUhqMlhMeExBQzJl?=
 =?utf-8?B?RVREdWJIRzVzaGtITHNSRjhnUHJPcEZFZUtTSzIzVlgvMy9iMUxTUUZlRFl1?=
 =?utf-8?B?M1VMMUp1WHFtQVBkRi83YVg5NXU1dzZFd09DU00zQ3E5Rm5MTG9sR3VFZFp2?=
 =?utf-8?B?RnZodE11S0FjcC8wcFpDeTZ0OXdqS2FmbnpvYnJtZ2xacHN1YzIzWVB3SExY?=
 =?utf-8?B?eWVORVRuUkh2TDFFZ251YTl2Y3ZUcHEwVXJkTTlQL3FwME9zUnEzYjREbUJ0?=
 =?utf-8?B?MUFlMVpDcDRtMzMwcHNuMWtlbHNkdkpmeUo0cWhiUkhGekw3UkdJMXhHVVIr?=
 =?utf-8?B?cDczbXlCUDNERWNNMVRPdTVSNHNqNzhqRTZrM0JWUmZQREZJRFlLb2xiRVpo?=
 =?utf-8?B?YU1FRDFoK0JNbjhlNEZLQ0VDc3YrNk5uVVV6MWYvQmJPQzlubnNhVkpyWnlW?=
 =?utf-8?B?VTNUQm1WU25peU5qUU94d24xRHBoK0JVYU1WanB3SlJON05qZk9CQnBDYi8w?=
 =?utf-8?B?NUV6djFzZ1VvL0lxbkZGTFZjSGhLMnVnUGxJM1VkQThRb1BxaTRxS1p0bkJr?=
 =?utf-8?B?MlhtNmR0Vm9QYWVGRVB6V3V3RkgvUkt4VXROdE1JblQvT1RhcnBLWlFEQU11?=
 =?utf-8?B?bzhacFgxeHI0WWVwNjZwTkFEenlsVXRRTGpaUnBsN2M4T1U1L3l5TElPYzNV?=
 =?utf-8?B?RnpqbFBLeUIvdUpzcHpEMFhBV25PM05MQ1VNUTc0eWpZYm00Vm12M3Q3alZQ?=
 =?utf-8?B?enlORzdkL3JrMVhJUmt2K1ZvcXBMMHdPY0t6cDU4ZWt5UWc4eGFkNnJHTlAz?=
 =?utf-8?B?dVlmaXU4TGlETmxHY2I2K0tvQXFuTHB1Ly9tZ2hZR01OYTM0eXFwYUFYc2ly?=
 =?utf-8?B?TlZTQVhSTkNuZE1GYWZ3dFgrUTEvM2t1bGdOb2JnMU5NNFdZVW9VZXBjYlEz?=
 =?utf-8?B?K2RTY084dHV3Z2wzNTVsYmdySklVMUV1MUhVWEtSajA5VTVOa2xWTytEQ1ZB?=
 =?utf-8?B?YmcwSmFYYWEwV0Fwb2FNTGpMVXliVm8valZBeDB5ZEQzMytyM0hUT1ZnVG1i?=
 =?utf-8?B?NmZSdnovTzRmZm5iWkZ4L09YVlNpczR2dEFCYW0rREFOTHpoYmZRNzY1MzRZ?=
 =?utf-8?B?ckVhMmZ0UTJJTS9LY2Q2VzZXV29QdXZMRWdrOWFwNUppZGRZTlZ5ejBBUlVr?=
 =?utf-8?B?OVU4USswMUZLZFZIbkFJeFNMYitqaXgzSFV0cFJ3bkk3cTBpYlNVNzk2VUtU?=
 =?utf-8?B?b2ZRdGJmWDlHdnh3dytlQ1hHOE1YM0hoeThDbTFMUzN1V0R1eGVsd3hMdmZo?=
 =?utf-8?B?aGw2V2FkVFZBanlvREdwUnI1clcxZzl0UU5QTEtNYkxZV2xLNWcxZlBLMFFi?=
 =?utf-8?B?bFZwR0c3S2N6OHYycFhBRUs5N3VWZ3ZWNFo4dVRaSHpkTnJaQjJQSE5iODRp?=
 =?utf-8?B?b0hjaXhDejFkOUFjWjYxQmZRbXdrQStaYVgya3JRT09SR09qV091MUROYW9n?=
 =?utf-8?B?eUZudW5EcjhpSTkwRkxPaU96ZUM5bXZsUWZ4am93Tm0xODJlbFBGcE92dE9S?=
 =?utf-8?B?VnZLb2JGRWc4c3l3TlFWTnU0clFDcnNFTlBpZjNrYzhJMTJJZ25UYzJRaG56?=
 =?utf-8?B?RnNPNUVGcEZkRFFvNVZoZHErYXJyb3lsSGVXN0FOMWs5QXR5ajIxckZCbFlt?=
 =?utf-8?B?TngyNlFoOXlKQS94NkhsRklCV29ZQjdNZUxvVjlaek9sYWJRMFd1d3N3TE16?=
 =?utf-8?B?bkFrQ2RRWVVZTDlobndrcTI5SDRvbGxhYnlmV09aQWFtZ3BIN2tJNGlhaGEz?=
 =?utf-8?B?SlAvQlNkcXQ2SitKN1R5Yy8vMy9MS1dKNFRJejVaQWZ2ejdXTVRoR3daTy9v?=
 =?utf-8?Q?nrPrMkE5Bfk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUFIQU5Rcm5xMjUwY0J3TGpoc3VuVStsTkdhU2gxd0Z5Q1JqN2RHU2I5OHZV?=
 =?utf-8?B?Z2lFTGRIMTRrREUxdVA1ZEZRcktsY2drSi9EZXpzYVRycUVhMEdnak9mT3hG?=
 =?utf-8?B?L2JnR0hXbGQ1R204Q3dGQ0NwSGNWZjdUVG0vZTF1U1dwNmpieEVlRnUvMkNj?=
 =?utf-8?B?KzBzcm1PUytuRjJtOFFtL0wwRGdIZ25LdXNENEhFYlJ3R1FNNE82RkZCSDFQ?=
 =?utf-8?B?dEpyTCtaOVA4Wm9jMGdaK1JZWWt5TzhINVo3NFpsamxiL1N3LzN2RkthQmlu?=
 =?utf-8?B?c3NYSzhaNkU4RGgzenZRWnlmazdDaTRYNzRqeWdTUVBKdWU2NmZVWWZxSTVo?=
 =?utf-8?B?Q3dLVnFKMHZhTUJYWllINzJoN2RMcmNsTnJieUR0WGdWVGxWamNRZlVua04w?=
 =?utf-8?B?dVkrNUJnYmNKMHJnY3BqQWZ1NTJuYUJhMHJHa0MyWmpGWjBZREZBSFp1eENr?=
 =?utf-8?B?K2RlNDlQeUplUXJiRjVoVHV3NjZ4Y2pQdDI5VE9ORW0xcWg0OXU2UVdSWjhk?=
 =?utf-8?B?QzlLaWFBYjhOYUcvTXFHUGEyYTBkUU13QS9teUkzbGYwKzgvRXNKclVHS01n?=
 =?utf-8?B?aGdvdUl4OHFEVWFiWGVUTTRXZm1GZGNPL0l5RUtSVUdqWHErT3J6NDBNOVRl?=
 =?utf-8?B?Yi9CRzZrZHNMcUhIdkVLVjZ0Y1ZpV0tyOHpJSGVZMXdsbkh2T2RpS09ad0ZF?=
 =?utf-8?B?bE5icHBaUGE0V2pmcUpIOXNXNi9yVFg2MzYrNGNMaUVydEU2dVEvTUJuNkkw?=
 =?utf-8?B?UXdzRTREbVl6Q1k3ZW1MSUxBSWNLcDk0c1p6bklkOXJ3enJDaHhmbENNN0pp?=
 =?utf-8?B?cHRod21mVnd6K01ZSkhSUUlkeE1ONTMwSU8yN3lVSDBKVi8wQ0hYa1d4U2h6?=
 =?utf-8?B?WVNLTkoxVG16ekxNZlR1NXpXdXlFaFpheHE0VnhNUVoyT20xcnRQUjErN2Fn?=
 =?utf-8?B?QmZQcnRST0NVRzlHREJ2ZXdGNkx5KzNDTFFTSjhvdlZTTGtpYTR4bWl2aFF3?=
 =?utf-8?B?NXllSGF0WENLZjRYbmVzTnJCNmdhMnp2b01LOGZqbVREZE5yNTVpbzFxNXhZ?=
 =?utf-8?B?cTNTYWh3RWNaWURNaXBNbldYRitYNzRia0FNaHMxM09TV3BydHVwZWxmU1dq?=
 =?utf-8?B?WFY2YzhLUFBUSC9TQU9ab3ZyWHdubVRQdS9YNGlsdEVCWFhsUjEyQjUzdEtR?=
 =?utf-8?B?dXBwY2JnVHUzZ3E1TmxvQmRtRmk0cU40NlNnMFZVcFhjV0JXMFNKNzlzTnNS?=
 =?utf-8?B?bHlPKzN3TC9tUzB1c1FUaWJBckEvUTc3WENaUWlEZnVkVVh5bFhaSWIvVjJv?=
 =?utf-8?B?WWI0citaRGx4OUhGTnBFQ3dWTE9jdXdpWVArUFYwYjF5b3JrRzM3bmNoamta?=
 =?utf-8?B?eE0vWWtZUkdMOWxWNENvc2pDczM2dERCQkh0Zm5HNzFXajJTLzFSRGhuMmpP?=
 =?utf-8?B?elVkM0pySHhWWVd6VHFPK3FpNWFUSW1PNVA5c040OXZ3UTZSazgwSHYyd2Rw?=
 =?utf-8?B?eU5scmlCeGc0UFd2SXY4VlZVRFNqeGtFeWovZGxXZVM3TWZmSkFPUVpGNmJp?=
 =?utf-8?B?T0FUZTdRVVJSZlI0eG5xZ2tnYmZMN0VnNVRmWFd2bTVXNHFZaWZIVExrTVYr?=
 =?utf-8?B?NmRlRWtheWNscURrdFJUcWNVSno4WjNOOFBRMzNZcFJiVW9BcGJCN1V1dU9W?=
 =?utf-8?B?QWJXSWZRUGRkREptREJTSTFjWHo3ZGJMNEluWEEyelpzWDRoNjBiOUJ3NDQx?=
 =?utf-8?B?N0JUVXh6VWVnOXR1bW1QZXcxenZXQzVhQVAveWtKME9KcSs2czJCblRYZ2U2?=
 =?utf-8?B?WWp4clJDbi9CQ0lRUXZEVnBaaW96SzVpOGdXYlVHRktwTk5DaC8yandUQUIy?=
 =?utf-8?B?aDB0QWd5a3pnYlJQZmlLamd5d2FCaHk5S25kWWxrWUoyK3EvcmZKbE5zV1do?=
 =?utf-8?B?N2VWVXBNL2VPeVFCSy84NG5jeW5ZYVNoZGNnQ0hHV0RDS3NIOVN6MzUwWllC?=
 =?utf-8?B?NzBTU1I5L0l5b2IyR2gxRGFXdXE1SnlWVTQzQ0d3RTlEU20rQmNzNmduaEov?=
 =?utf-8?B?cERwUS9QRHpJVDN4alhzUFEyc1B0SDhNTEQ4N2UyWEhEK21KYUdKMEJ0emN2?=
 =?utf-8?B?eVE5UTN5d2Ztb0xyVDVDNm03QlEwQ2k1K2c4WmsrMjdsS1REZWw4NTBYQjZQ?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+MH53u5nsfwMoJKVcCfUJoU5/Efst5xAAMgtafFxoaavUS7v3IOSHrHTHYGEazpZDWii0fxXh1a/qfOl1bc/uIQl/Uw9rc9Dru7FD4ywvsdiORykvWvwT9v3mZSAsV7g4G4dOjHQ8TVKLD8OMPp38+zyZK1G2HZ8f42pwubbKvN26O7lPuewhI4Ad4ojbbiwSO6d/bL3XLtd8GqjTVErVFadRVH/d4KKpn6ye86moUAMBqstXpHCXEMgF5PZ9aY2hKV3GHDM7KTQVitWPzQPQ5vwcjNzii8YLh0iV33kkiVIKGc4vGrmOWWZG+E0ZDg6f4r1sayGGoHa1BFRoiP0AcuVPFaS1YGa8TGWBo01F9GfRYHrEc6CjA3MFokkvqfqiHTXSg6Lqpn1vJXsbAONdzKHq1qr5lFeGjujUc16BpLnQGf7PyZQyFjGYe2m3blNkjGONIAe7l8Mt2g/UIxs+4PeKdbB3OFirj2czeIs4TpSSHv6outdmMr8+0V4u5t+YQwod5dD+o9BUI60trkTJz+pZFWSb7ohCDHdfUzuQq36PQtrXo2kGy9B0+EsSaepMi9LvetbymLCZA7nHHwdzvsFXN9UPkwHkY6OtwE1gT0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c48e40c1-e00b-4e9f-1e1c-08ddf43c319f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:42:32.5852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTMyWC1rReLZunjiinPLWLoPGzYnrX4tjRUMa7y2x15snRpElESBryQYnQ/OjLXeoDZOJEXfvAAH+KLnZRmV/7xvbehkDdrZ3tnlkF+fThg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150090
X-Proofpoint-GUID: PecyQRJI-g4PJRnjRc4-jv4uXKhJagek
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNyBTYWx0ZWRfX/pnPDDVMCr9I
 0jlt+SDgEqFLSCzkqRIllm3E08jxWhJ68asna1Wy4J+kPWnM2g6q0a7AT+J4X6QEJpkGjpIZPPT
 CSEcM4OtawDu8V4pcbNu7dz+188ciNofx3y5PZn1nvNQkXTCpKjiN/Gv7HGHbOg26bXJVMaNTue
 HMgF0HRoRuGKOjAXe5U29XgTFXJr8AQPM2+bHuvIo1sR1KBYG+1GAeA3Q4V7rEQ4vnp97hFz4Fg
 C4t+4iXDaZ8TV/vtpesPSI+CmWZJeE9l5oQLEkE/fTFAUzXeXnhTM18fUaJNMdJUfLSRevHSEHS
 14lc1qRN67boGYY0j9ExKqFqmCKY5w0xvdpJYBYaI/cNnA3ZyA+FiTIFNqZlqkdaNPOUXsutOl3
 VvZX3rUNcLwSvPakCBaPdjEkgQeLfQ==
X-Authority-Analysis: v=2.4 cv=QIloRhLL c=1 sm=1 tr=0 ts=68c7df8c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=czXrLi10STdRlTV71GwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12083
X-Proofpoint-ORIG-GUID: PecyQRJI-g4PJRnjRc4-jv4uXKhJagek
X-Rspamd-Queue-Id: 83A49180003
X-Stat-Signature: 788si3d1c6mtngy8yjoe4rapzr3momuu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757929364-578135
X-HE-Meta: U2FsdGVkX1/esAsJLK8Ec5iICVU7hRYWaFqkbBe/Qtp/kiI9Z7Hx4aod/WOj4N9HY3xNrguGW8cnHa1NxV6JYlxCfMjeC4iV3hWbFIo8NEGTiC1N+aV9SZgjjuVyHggUBgZ+HXOAAz5OxXPnvGnZFo280qgeXBcToaAI4k+o3Hzulo5soOqE1hhqmZwAZKEIelFTnJv6aK0e9jqMXaLPUzixVRp3HOQSO3q7DAl3PBKtNs/EKAAktk++w3SlRCvTeaEmF3oc5rSSgGj+U6H+7mXIWhLeA7mitkuxB3Fmn+dJ+kLvtkfeSGoXbxiqaC8DDAm4y2IoJ0OSya/K2yj4piQBW1/ZKOQYpc2t4KEhqZNaoXGI5jjHE8zT4HiNvuhvESSMqv9Q72mDB6G5rKQiGjNxsr7qhVv4e2rzqZgaTH6p3dvJvC4QGcrDH3BdDwf3e/fi5ICsM78u81V53poBSfe6taZBQfqv3H6qncdW9WM807l4CtWpo4gUW4+D2qMKePvXuZoPOVhLppEiIvXANZyUrF7+zU3GbY+XGMnACRy2myET0HReOiQo3ieeSFGtnQlBFhUHF/Cty03A8Iy/4pQ3zRaDXVWvkWxcHDxJynU1deWLWybBZ8yF+60h7wmUHTZUsYEHVwWbwBPY04I5ooCrvCkeAC8aDIm5CzfnHznLaMLUnraKmM3tpgVpjxEeQuJzsq3bKdEw5ie1adpAb01meT7EgQtJ6Qm4D4a/T5CuRc2nKDIbfCEfoWy1je1R6LgEGyo2Oj5yUYMK8N29LEZ/xUlQXDi53k5+aQCTg/awvNN9ri1WgT5/JoFLgQ1xELfeQAD0Tn2YJVL174PZWtanAakQxhZIWd1AvYkY4WM7Rbugt19NgT6HJvj24Lyf81m+8p9V+GHZG562w8NX41ZIi79QoJJOmX9sPwbe8ZIOBnZLqsDppbK1+TTz1VoMOh87q5hlHja54ofLpJT
 CDuRmaf5
 CcBDbhoCkekZKtlDFniQp9ok9fxYtWQloQ2BFPgo1zziBT3orQ30EEG4yWgMu9Vdx71Aiy25XW2wVUKV5aiv6Brn9l71rADT9FegxOwAfSsVWJo70g4WOieeSNGZ7G7n8EuQtM6txwupJGcutd3HmiS9kn9zApMyJY1X5SOKx/1K8LtR8rGsUTmIIT/zBymFKG5STOT94f5J81mi0C+yiVeTvJ4WzcglOs9o8zDUq15SjX/+8kQOO/r+28CvHlopc6RzzpgNBfyPHgFFv1MNBzYyBrplKB5NrKVoRzxVGaFX3kPH5tGOVr8RrAWSu44ThDm+BoU9Ol9gtUN9b7pBkcUwZLfnGLvyY6Ppu3eDtBGBMqYMnJRIlHs3A4+NOpw7aOj+V+dfnzGcRiUUHm5GCBEpr2yoliAQOzTnVqo4959LBttdo9BIWmQ+F1asg2FfO/PWn57i7eXzQcPi9bMCynL4LklGOt0YNQRI85lhS3FAVPNlLEZBWb6iLFAonJAdGoy7iHPUQQg5kqtQ3fTdNgey9o5lcAPBRNS9HDVtHJFN/JxBa0hDZq+pKZaGV74qWeL3Js4kzb/NYJpjmonR4Vh2LxWe5no9/+mqAw3Riz87j/kqAQUMIIil9FtXBGS7vTTacpJn/XoaL28KWY45PUd+hzrRlpYmFk8Xz6tCteI11ZrC+Dm5yim4PsaSFz13x/O/KrRm7SIBsJpghd8Z3566fmTEhF35/bf6dS757IdCH1xTwpKHbDOkxyJfKUp0DEz6l2/vFbv0hdZFRgdETNYd7LcxGC/ZRuD+A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 07:17:41AM +0200, David Hildenbrand wrote:
> On 15.09.25 04:50, Matthew Wilcox wrote:
> > On Mon, Sep 15, 2025 at 08:23:38AM +0800, Barry Song wrote:
>
> A couple of notes:
>
> > > > I wonder if we could fix this by adding a new syscall:
> > > >
> > > >          mremap(addr, size, size, MREMAP_COW_NOW);
> > > >
> > > > That would create a new VMA that contains the COWed pages from the
> > > > old VMA, but crucially no longer attached to the anon_vma root of
> > > > the zygote.  You wouldn't want to call this for every VMA, of course.
> > > > Just the ones which are likely to be fully COWed.
>
> MADV_POPULATE does that for writable vMAs (excluding the rmap opt, but that
> could likely be implemented).
>
> A student of mine implemented a MADV_UNSHARE that achieves the same by
> triggering unshare-faults even for non-writable VMAs (again, excluding the
> rmap opt).

I think the rmap bit is non-trivial as per my other replies.

>
> We used MADV_UNSHARE to break COW asynchronously to the already-running
> workload to keep fork() still short but avoid the overhead of COW faults
> later.
>
> [ insert usualy comment about no weird mremap flags ]

Yup

>
> > > >
> > > > Maybe this isn't practical, but I thought it worth suggesting.
> > >
> > > Lorenzo suggested possibly unlinking the child anon_vma from the root once all
> > > folios have been CoW-ed:
> > >
> > > "Right now, even if you entirely CoW everything in a VMA, we are still
> > > attached to parents with all the overhead. That's something I can look at.
> > > "
> > >
> > > My concern is that it’s difficult to determine whether a VMA has been completely
> > > CoW-ed, and a single shared folio would prevent the unlink.
> > > So I’m not sure this approach would work.
> >
> > I'm concerned that tracking how many folios remain shared may be
> > inefficient.  Also that information needs to be gathered in both parent
> > and child.
>
> Yeah, not a fan. Tracking per MM might work, tracking per VMA is problematic
> due to the possibility for VMA splits.

Well, I think it's possible (maybe)... with a rework :>)

"Lorenzo's grand rework" etc. etc.

>
> >
> > > You seem to be proposing a forced CoW as a way to safely unlink from the root.
> > >
> > > A side effect is the potential for sudden, heavy memory allocation,
> > > whereas CoW lets asynchronous tasks such as kswap work concurrently.
> >
> > Perhaps you could help us out with some stats on that -- how much
> > anonymous memory starts out shared between the zygote and a newly
> > spawned process?
> >
> > > Another issue is the extra memory use from folios that could have been
> > > shared but aren’t—likely minor on Android, since only a small portion
> > > of memory is actually shared, based on our observations.
> > >
> > > Calling mremap for each VMA might be difficult. Something applied to the
> > > whole process could be more practical—similar to exec, but only
> > > performing CoW and unlinking the anon_vma root.
> >
> > That seems like it would be worse for memory consumption than doing it
> > on the VMAs in question.
>
> MADV_UNSHARE we implemented simply took a range and one could apply it to
> the full process by supplying the full range.
>
> But yeah, the downside in any case is that you lose

You just lose? :P I assume you forgot to finish this thought :>)

I wonder from rmap point of view whether you could actually simply check to
see if you're fully CoW'd.

E.g.:

	madvise(..., MADV_ISOLATE_COWED)

And have it take the anon_vma write lock from root, have it walk the rmap,
go and check to see if every folio in the VMA is now CoW'd, and if so,
detatch the CoW'd anon_vma from its parent/root?

This would be a sort of after-the-fact thing, but maybe could be done
periodically.

Of course then if you had one folio that was not yet CoW'd, that'd prevent
this from completing.

>
> >
> > Another possibility would be for the zygote to set a flag on the VMA,
> > say EAGER_COW which forces a COW of all pages as soon as the first one
> > is COWed.  But then we're paying at fault time rather than in a syscall
> > that we can predict.
>
> Right, or just avoid COW altogether (if fork time is irrelevant) and just
> copy during fork(). Either using a clone flag for the whole MM or using a
> new MADV option copy during fork.

Could have sworn we already had an madvise() flag for that but no we
don't... MADV_COPY_ON_FORK...

Anyway any such solution has the issue of using extra memory when the user
very probably does not want this.

>
> >
> > Another point in favour of COW_NOW or EAGER_COW is that we can choose to
> > allocate folios of the appropriate size at that time.  Unless something's
> > changed, I think we always COW individual pages rather than multiple
> > pages at once.
>
> Yes. khugepaged will soon starting fixing that up later asynchronously I
> hope.

But only at mTHP granularity a. once the relevant series lands and b. if
mTHP is enabled (I mean for sub-PMD sized/aligned ranges) :>)

>
>
> But obviously, whenever we copy/unshare, we consume more memory. While this
> might possibly work for Android, I know that some workloads (was it
> websevers or webbrowsers for example?) spin up many instances through fork()
> to actually keep sharing pages and not break COW.
>
> So I would hope we can find a better optimization that doesn't rely on the
> workload to manually break COW and effectively consume more memory.

Yup, agreed.

>
> --
> Cheers
>
> David / dhildenb
>
>

Cheers, Lorenzo

