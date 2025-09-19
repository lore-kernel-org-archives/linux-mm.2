Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD94CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 09:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C6B8E0030; Fri, 19 Sep 2025 05:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D7B8E0008; Fri, 19 Sep 2025 05:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1A78E0030; Fri, 19 Sep 2025 05:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE7B88E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:58:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43F5558EB9
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:58:28 +0000 (UTC)
X-FDA: 83905549896.24.5744D9C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2A1C10000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:58:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JsDFSuWF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b+rkQ3Sb;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758275905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PzqHuSk5F0hV8v8UN/3HT3HChjDNfCo5KnpiiDSsC8=;
	b=faOgEChLztqlP4EGnbNAn/HAN07UkTNGSyPqdY1WLFaQTDfn7WycfdoAs4CR8dFDHBJzIB
	kAO34cPoPt8KRnEXNqAeaVLK0z6vZAbDkHCRNv5GfATTx5S5+1L6wNWPAYNviN68DN3zGI
	o49rDjcUknLALiWJRdXxRXXIbRfGr/0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JsDFSuWF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b+rkQ3Sb;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758275905; a=rsa-sha256;
	cv=pass;
	b=eROZb+Ht2mAt48ehiwZ5gYLjiSLDsxueBb3THI0YPK0g3ad3XCy4edNBScBKJgCY8rUc2z
	z7fbHjX5MREBYsHATi1tecegdqJBEIIgUJ+d3bN0AwcqrqiRlun3Oz8rb5zfYzqSFCMjtr
	IQvt6BXjvVQ58II6tCP5Tf6n7mH7S3E=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58J7g69s008771;
	Fri, 19 Sep 2025 09:58:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1PzqHuSk5F0hV8v8UN/3HT3HChjDNfCo5KnpiiDSsC8=; b=
	JsDFSuWF7icv+vpLv3NFWk/ccTVgI9jc491Ku9swD+KKdOMzcGNxtQmmnFJs1yX5
	C6StcEX3Ze+2O2XI4KGNrMFB6v9O3btwwbzgJsHE/dwwnFKspCe42y7paIISSISw
	0fsvftpC5qnRYiPxUr8D5MO6MlKaERiGcMEkZvOH6vgmwKF5P94xRyHaR0O6VK66
	O3RCWK4lrc22NzDNTyaymbVDGHErhH9K2U4TVZ0CK89eN01GgM2vMLYj0VKwQiUT
	I62iRWgI/QDQiUmf8u3nrU5OosI25/+UuJw0ZXVpcCqdtjiBANscoN3hWd4jl0cl
	pbTfCtuPDecZQb+thFMEnQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbw914-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 09:58:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58J9IJd5028785;
	Fri, 19 Sep 2025 09:58:18 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012031.outbound.protection.outlook.com [40.107.209.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2gbdn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 09:58:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w3D6CwhiEl4qaQEZMhXMAE5eFGZOlRyfmfYe44FzMn/96l1h2nZhnSJLXXMvT0gI6pu6BgrKpj6T6uOH3XhTctQ5HSWZ98oBvPAvjMOxYKXpLQwA3zrMi+7qnR9mEbQssr/JCojC6ttey0q4tAIWkVzDCjtZD+47xL//dAL6r6o/brpnJF47YD7VC4y3WO7eB9a/EAAinzaKCqBDbGvgQs3MohcWm2Pc9sZTCLjStpp7OZTU4vg6B5ENxjm28RGNipK/mSDg1Qzb5t2JJjJDl/nVmBH4LsYOkD4Fh4UFeXBWX3YFOqbgaKshuhlaTXvUxO8+XL3ARbqUg5tpAkDJgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PzqHuSk5F0hV8v8UN/3HT3HChjDNfCo5KnpiiDSsC8=;
 b=gVq8S2pmQjUnn1clMcqbnTG7Iauz7V/AQt25WKDwbfylrknheSXXEvY9ApnpQownwEmmAw8wzK2psWTt0axF/ZHhF7j9GPPdXaYp4UB0YiIVld4NaE68L6k7V8kYLixuvX86HX+yBJsrd12hJhx83KXUFXT8Y6G7GIBl3Pcw5jQwZ4gOqVXwc08aFA400VE02x8mPLuzHCkYAfimh/6dPv72vcn+vbZYoE6Dbsx3votdWIgbdwnutznCO+leZDXh5BWCfrUK2ZwAkrrLsXV7PUXpvvJ2Ko34lXNcFeK1gtWve7Vzp/lqH6yRjU/EzFy/fy4c5tRWLqZSDp6zljYdvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PzqHuSk5F0hV8v8UN/3HT3HChjDNfCo5KnpiiDSsC8=;
 b=b+rkQ3SbrcaXlaVDb9QqT1tPnJJ2mwSlWVuAbvduSonGz66sz+icmb0VsN+oYrK0Wk6igiescecX+2ibcMsb0f5fSp+v8T9RHvXNbIxBj165Te7CNCCd1p41HkUoaS5jnrRFxrI10n1UHwhmXJAl1vjC7Ace5+0oOzeElP6KpYc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4493.namprd10.prod.outlook.com (2603:10b6:a03:2dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 09:57:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 09:57:52 +0000
Date: Fri, 19 Sep 2025 10:57:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, jannh@google.com,
        David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 2/2] mm/userfaultfd: don't lock anon_vma when performing
 UFFDIO_MOVE
Message-ID: <e8fcbb82-9029-456f-a5c1-eb5cf4b05ba3@lucifer.local>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-3-lokeshgidra@google.com>
 <4e4bee5c-c2d9-4467-b7b8-d3586a5cd6e4@lucifer.local>
 <CA+EESO6B04FQ9pxmf6n1Up+r-a4yGYO6N_HakiYj0hLVvhs2ig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO6B04FQ9pxmf6n1Up+r-a4yGYO6N_HakiYj0hLVvhs2ig@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0294.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4493:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e46e1d1-0366-431d-7f14-08ddf762ff7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eU1iM2kyMWJ2aFZ4SVhaUHJtbklVU2VxUGpCbXN0UFIyNkloUmJYY0dXQkxI?=
 =?utf-8?B?VzB6U3NRSllEQnN0L0c2K1VkL25xOUlVQmRESGlCSUdpVXhqQSt1SllQRnlv?=
 =?utf-8?B?UzJZR3NKOWQwSCtra1lFSmYxblJpdFBaQlFQMHh1L2RCbGlNbGc5dDhwcVBY?=
 =?utf-8?B?T3duZFNoaXduMitsOXcwWFhoWHk3TmxGTjZlcE12UC83NWU4R2lhNmdFd0d1?=
 =?utf-8?B?QzE2L1pIVVZXLzBJeTR0SHdickpvbWtTZ3NkeHVDTHk1aHJBVCtCRUhNdmlO?=
 =?utf-8?B?SnAydkdML3ltOUZGN3B5K2JNa0hBMElTemVJdmUwNGlPN0N6TFlRUjc2eno4?=
 =?utf-8?B?WWM4MnF2NW4vb0MyZHBmU1cxeE8vQWsvdmVzcS9IdTVxaUN4R3A3enJhWE96?=
 =?utf-8?B?ZkN4ME9MTWJXRGx3SHRkL0lLK2Jvb0lWYVM2QnZvT01xZjNTeG5PRXZnRDBX?=
 =?utf-8?B?Rkc4WW91dDNhQnZQZUNFb20xdDRxbFJMaFJVRDVFQXVWLzdHTCtueU9wc3cw?=
 =?utf-8?B?dnIwRlFxZVo3Z3NwNXpGVDhXMElrUk9yVlozZEtsaERycG82NGdZYzRwam04?=
 =?utf-8?B?V3FvNFpROXdwSVNLVHI1WFpZZlp2Rkt3UUxBUlZzRUV5RnFBVFROM25oYzh0?=
 =?utf-8?B?dE9yazdWZnJIYjc1WEJJOEs2aktySmJacng3QVIvbVM2OHYrYlJwblZHQS85?=
 =?utf-8?B?UzhlekRwSGFsT3IyZGVJR1N3NFJmOEtIS3FNK3V5S0dPWWtieTU1djU1MDhB?=
 =?utf-8?B?ejJUYkxSUmFrQjJQS1c5NjJkdlhIcXloeWgrTlROc0hTUFZVYjJlZnZ1czBK?=
 =?utf-8?B?R3pxbXRQWXczRW1TOVNYcllPeHY4TDViQlF5TzZhNktoZHVHeTR3WWthVy9j?=
 =?utf-8?B?Q21SZGcrOFV5SzQ0RTZrUFMxMm5uMTJBSXBFSTJpVHV5dDhKd1BFRmVDMUtG?=
 =?utf-8?B?akZmYVpnTHNuc1BZcWk2bFExbURuY1VpRUlaZnVkcW9GWFV1ek44V1JodXZ0?=
 =?utf-8?B?eFF0Tm1nY0czL2pNV0tzUXdBejRKUEdONDFFZmVuTUhXbHF0UVlUU05Ic0pT?=
 =?utf-8?B?eU83Q0drUWNkK08zTkpSSVliaWdvbXBVdHdWMHhmLyt6WDk0djNEKzMxYlZk?=
 =?utf-8?B?ZDNUTHd4N2JZakk1V1JHMVRvc1lISTJjdlRzVVQ3WkRJbEFTWnQvcTR1SXVV?=
 =?utf-8?B?c0tKYUhxY095eUc0dXJEc1IreU1CSzl0VVBqbmNxdEk2d3BIVmwwMjBDNzgr?=
 =?utf-8?B?Y3NlSjBBRzlZN3owcjhuenVlWHhmT21qNXVZald4UWhVQlR3U1lrVTVzem5I?=
 =?utf-8?B?cnNSTlZxb0p4aGZEUXRldHJuSVJnajBzTWRBQTlvbzM0eEFUQnBSUUFqZXJM?=
 =?utf-8?B?eVJIQU9IOWExbytMWmliUkNZN0cvUDBFMWJla3RSdktvQXZPeU55R1Bra1Ir?=
 =?utf-8?B?TGV1VnZXWitiRFkraktGWFlKVWkrUTdRTExUYUlhekdaM1g3NEh2OWNzYzA2?=
 =?utf-8?B?dUFWU2pVYnduYlF6K2psM3lKYTBSci9SS2FVVWt1MmF3bndvSVQwM3owMXdS?=
 =?utf-8?B?cVF0eVBReGVQcXA5cGVsbE5VdTV1SVRTV2thNlhqeVROV1NZWjZjZUpPZy9l?=
 =?utf-8?B?ZjBVUTA3NUloTHJpV1RHOE5MTFRla1M0VjlMVmkzamRLM1BCN2wyWlI2c2o4?=
 =?utf-8?B?SitKVUREa1BwWkJJRncvd3I0SVJobVpRd05icVBFa043VEJKaWNPRjY1bG5h?=
 =?utf-8?B?RTBSeHNoc0pxWGtCWm9EMXlsVzQ0cmlGejJsSVViYmltMmw1R0ZRRWZLK3pD?=
 =?utf-8?B?bThaSjVTMG9QQUp5WU8vSjg4T2E5MW13dHFBUExYY2lBaVFVUWtZejR3Tjcv?=
 =?utf-8?B?cUgxbmlyd1hmanZNYnIxVUZhQ3k5UDZFWjdscXVQVWZqWWphY00zYXY2aTZK?=
 =?utf-8?Q?qCrsuuJ1h4k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dERoRlRiUDN5YU5LV0FhYnJObWdMcytWRWJBSWdxaFZ3blVvYkkvM2sxdjJH?=
 =?utf-8?B?OVlPeTAzWlFQR0Fudm1WTkxxWEJ1dU9lL3AzZStDMnhueVZNOWhPVDRBQ2VU?=
 =?utf-8?B?R3d1WUI3b2RONmQwWEpZb3FiMm1jZEpINElSQU14eDFRS1JkQ1d3RTJaWTBi?=
 =?utf-8?B?ODkrckFHaTIzcGRRVFhleXVLb2NlQnh6MDMxNzl4TXBPSU5PL0w3RFJTTm4z?=
 =?utf-8?B?MjNKdDdlK2JLZVV5OXdsSjFFOU83QnV5cFJ6SzU4c2NtcHNIdmZXYWVlcXJl?=
 =?utf-8?B?eVpUb2lWaVNNVU1vUTZNTUxsOVdWMmcza1RHV3NvTjR5Wk0vSnpUcnA1aVhZ?=
 =?utf-8?B?VThoTEg1ZGJjczRHVUs0ektZek5xK1MvdWx0Ui94YjFTdWtuZjVmb01UeG1a?=
 =?utf-8?B?ZXQxYVVQOEpxTnVUL2tkZ1czUTU1cVhiS0YwTW8zNXAwRk1neHE1SmxGYW5o?=
 =?utf-8?B?YnNQeXVheGxsb1I0UFlmSDhOWStHV3lYQ3hqYU5OWWFVT0hkZ3hoK2Rtd0hT?=
 =?utf-8?B?T1BBbjZwbW5PMkxxTzRzLzNMQW15cWxiRWlsdWIzS2NwNmlSOEdyNGk0VnEx?=
 =?utf-8?B?RFpwRTBKZ2xMUmVVVUYxSFQ5YmlkMjgyMm5HanA4RXkvYmFRMVJjcmp2aXNL?=
 =?utf-8?B?dyt2TnNNd0I2TjA0OUYzNDhuRFFQSEZnTkpmQnJ3bk9RbmZrdUJkQVVYdDFx?=
 =?utf-8?B?bjQ2ZTdibWR4SU9zUExYRGtnQ0RFdnlYWUJtcmZRU0ZZSERTTEFjOXRvVHZt?=
 =?utf-8?B?dzFsWnV0ajNFSCt0SGhmY0prUEh5cUdKVHpVa2YwaWgrb3lwb0VwZTJwd3pp?=
 =?utf-8?B?NWYxck5JYi9iN3hHeVFseCtsMm40cy80MEtUcDIrVkUxTUlMT3ErdHIyU1Vy?=
 =?utf-8?B?eTRmRTVLbk5sVFp3N29nMzRZejRXRGNGclVjcEFjblRMM3F0ZmJJdFF4MVdX?=
 =?utf-8?B?UndWZzJDdEsxMVBrbk5jMFdkS2xQZWU2amQ3VTdFUTMxbnBKK0pvLzRacjlt?=
 =?utf-8?B?WDUrc2prZjY3RVc4Q0I3WkhnMVlISVM3NElUaThKREZqcnRlaUQyUEUyelBp?=
 =?utf-8?B?Q1BEYTNVYlVnQitpamRZcDNTVHZrWXZ3clQwYTZSQjBabEZYcitDTlZBODNT?=
 =?utf-8?B?aWtUOVBVRGRta0x3d2k4UVdCQkxqdHpaL0JqVEx5NCszWWVvY3hYOXZZMXJX?=
 =?utf-8?B?bVp5bWNnMGxwV1RRa2RuRGFTMHFQM3FFc0VYN1g4Y1RqMXRpVlJHcG9zeVdI?=
 =?utf-8?B?eFJvb0ZIL3Q1a3ZsOHV0Mjl1SEhEVmZYdkFQMWIvLzl5WXo3NWpudEpRRi9R?=
 =?utf-8?B?TXV1a0E0Zzlkc2JkcG1Tb1BSMzNpUitZYXBLSExPQUpvQk91aDlIUktpMFVP?=
 =?utf-8?B?L1FLdlU0MEZSbEZ4S1RmQnl4Y1J6KzhqakdLUHg5MUdBTkFIR1NJQTRsNFZU?=
 =?utf-8?B?UGxoOUxUSmoxR01sVzNEOStrZmRqWmNUK2ptLzhsY0RmNGlySHFPajFBZ1Zo?=
 =?utf-8?B?ZmZvU28rUTlwM3YyTkhMMEo5SW9Pb2F2d2ROQng5R2dhQjFjY3hVMnZJYStP?=
 =?utf-8?B?bTJ6cVJRZnkxbDZMbmtiQXgwcy85S2NkR0RJZXJpQjFiTzBhanFNR1NObEVN?=
 =?utf-8?B?WWpmODNSYTZ6a0pySkVzWGhjenQvN3M1SUhRL05hRTJGbHU5Y0hxb1FDNjZ3?=
 =?utf-8?B?ZEZBYUFQa0VBaXFOUWJBS2Y5YWx5aXYzVVEyUWlaQWVvNzh6Y0ZQTkNvVGZ4?=
 =?utf-8?B?S1lkYW9rZ09PV21tSXErZXRXNVJ5cFZnQU53NUMxWGhjeStlaUZKMndHb3ZF?=
 =?utf-8?B?WS9EejRtWlp3b3BuV2dsSXBSaFZlYVNBN3JQZ0hnQU5Xa25TbGpKR0RuQnNX?=
 =?utf-8?B?NW5WN1E2L0lQdnR3K3BybGNrYlltaDlyZldFVmNMdGJIWk1rRnJHd3NNMlRY?=
 =?utf-8?B?TWFqeXdiVVpLQTBieTV2RWd4RHl1bG1sQXRWQ0lGT1Z4MjYvTU15YTBGditt?=
 =?utf-8?B?UXBHU0pVQ3ozZnZoR2VyVWVPQ2ZaMHphS3ErQmd6RG56K1R1alVLZVFnMWor?=
 =?utf-8?B?akZuSG1KZDJaOTc2TlIrN0xUaXl2Q3M4Nzd5ODFwZmZCOXJmRGM5cTNySmNY?=
 =?utf-8?B?TWM1clNrV01tSDdTNjRNaVRZemZENGtBT3JWQ085WE54a1lmdGpXM2xTeW1s?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TLmAc7PU4tM05XDAhNTtnrxPTbVHpBpr3DmPvVZIO4rF11TSLJte4DT/iVz+UWir7Ff2Nvp1VhOODqh3HnG+cO/9326QDq3n4TfXym3p8UVBlpEij4NmnqWa/ZCIzGX7s3gHVKe7lRKq2EdiyM7fS6leAizURvjLIVcJ26UiCjnEeD80xk+iJTfV3uXEbK9ULHKJ4W62nOFSQngyYHPgUyYbIs5S8pzHHTYOuwLHfWLQtnyq+CfyOjhzgpRgfQdumlVBkZMYgqANBEjV9aopTNHYaHtU7i3lGeAUoJHsxBmMO+tNpNgPhyYFfirSCO5+6nCdbpL75AY+KRr7Wj1LeQrH47rpYZpexTMxiaUiC6AAkqionmCKfUQlFN+L62+66zk03fa7PO2vPuLUVXZ1RxQitLmeS13Cp2FoOfzyGLgAy/n+mdreL6Zjx6dMj2i5KVMbf/UYQpZZVKL9Fm6JT03Zzbp/sC9G96jpICQBLC0EbyfAct12tkVHkXR+QSluc2AFEXpFAYgC57rDhXNW1noyPUn4gmfy7UmqVTR1KLqloPoWJ5/7rL39ZTNCj2jbqXh/CwoIX9/qxYaxJ0kE/vGfDEKtoP9xxL8SEY2fDv8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e46e1d1-0366-431d-7f14-08ddf762ff7c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 09:57:52.3511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXXgzt6ippwUkIDvWyIfwLI/pQfF+qEJwruAWLFJMTb9DKE0f0LZx4MeVDIQQ1OCPsat6uXr7tYeaaX3Ebw10/CrHJrjIr0ZLx/fdRUY86s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4493
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_03,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509190091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX8aCPUbNh5Qtt
 8znkD60Ig8UAWQrSnLmZ8a7zB+Np2OVF+R1CweOFQF9bULn/rIuUJqab7HFfZ//3UgCaVJc3ALG
 t8z4IQi5YAWGTMFnzZE3e6uc6Vw4FvSCwFuZW9E8awRHlwMFlTQNmTeHMpTxsjgP6qHsQ1GJZ4L
 rgq7xAB9UH4Cq24y/5SBd0WYwL6QRmwIgdufMCD8xSRM8Y09OE7E7e4ED76J6mdyf1HEF1MLrT7
 BeIZ26ZaHrq+b8Vh2p4VWK/wrQ1IEuy/o0DWICt2dni+mZTODV8CEQh8uEgxyEhzuys9mdIBORv
 JY4a4JqCEJsUkfukWdbqpDUG4JuVMZCpkBcQy11OYHAxHrNyCJ4M7xuHegqYaI5vDpUeF4l4R32
 oV87a9cO
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68cd293a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=RywbgLTvnNoXxDrbBs8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: jRxZSmINZ8pLk5QuHvAL9im17ciU1M6R
X-Proofpoint-ORIG-GUID: jRxZSmINZ8pLk5QuHvAL9im17ciU1M6R
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B2A1C10000E
X-Stat-Signature: ps4389opoaoxkx9sed4oq6jz3u1irh4h
X-HE-Tag: 1758275904-42418
X-HE-Meta: U2FsdGVkX18DYkXc9j4ORw5dM+VIA4wxXuonBRpEZnr3xfCjZmKG+sGt01Gt789iIvbEv6Edkroop1N0immM7DsO8SYCOhu0wEWClAdQyXDEulg9Hmoq7ifQLS5WnDT+R/ewbD1Ivi7cl5zqE8NuY3rWOrwWtHZX+dkHuH/zFYKyWrTYJRtLHJQmygLIfWI2XspGSlVt1Qx/mMMHI4Az8ivmqz0exapyDqJd+6OtsCY/Ns1qikEtdVY2ZkxSBFRQRp5Cxa8lODVWgPBubKHTtljJVXh0V4q4Ka2hJ+SaYevyxHLBWB7eejT9jNw+WwHYaQRKlYcuuQ5F3egTT9V9W/ue3tmExyEH5fmZx3WweZ0rol/dgL6298a/jWepvz+ULQ0Qr70s6ZCAC+wkRE4EK6uk7V9KaW3IkTMgUy40mAjREf3s1bpU3h8Gn3eFuLkTdohyfG8ywU5q46H4FlPevFdmm2SvtkuWi1VYAG0hT5AGy4t+XPjAUtSL1l2xIgX271xsfD3TnGvmey2CKsa++ez4g59M+UHGs6Xj6IVdXY9aFHCYamNeR4fAFd02fzh/PhsQV187EQA+kTY+vrdeZhp7d44iexo8QduMs/Fy6sGkKJHAeDfwF+/Iff7w5NYkqFNAAyDoZITsnNYd3DutXZEfH47ThkNBnot+CteK5cn77o5mYY05kqvwHjs8oa1md/SxzZ7LgrBq3U4esijJlTqMrwWWrrJcyT3C11+9T8N1bTXzZJFmC+6rb56ZUtuBikF9XIz0RlyXqv69EeO7cGqf0hUaQJUUMuinAg9SlEwhAeYgkoZrYpNOquplx/p+izKrLRX0kZSVJIajdQtxkF2Lu+dnbqdUo8edJ1ZbCl2d8R7mBLocD96N4h/uionsPHVQLVC0Xqysd3cMdT+07QMiQdQr2GGYzpKXmWnOqL9Z+aQCjY0LiA1XmPaCcE9zLXxTQYOQnG48OkWAO7W
 Tu4W7yot
 4ro71R/Sx/rxlWeXAW3QB3t5vjCMldxUISRhdz3bTvNslvmULq4polXmeXjUsgtn06uiXEyKYxsYmdjCwP4ETAIfM4B2HeeC3U07nu0iLeRP+q1FwGazxiTq/btwYnAk1LxGoKB5g/yp7+O4/EMG5h/7+0Y2xeaT8PlxC2toEdS0Rkm1IZgDPH7JivT4khH1oX8ZiLdbQyRqDaftdSuphzzdJ7eComuAmUV5+614AKQpT/CyIcs8wT63PdH6bYuIY/29kyEz9xwqWNmV3THg7uleUY7KUo7Q46iN3WOIweOk4E1j+RDMMyCLZpdhO0FAGa4rrL56l6ovUI2BrkVVNfa7uqzReSqb7bV7tOlqlpob0tEr60sAXAOY0Gdr7qOSW+mBHlZbDN/hgCSGASzSdT0k1o6UN6te3CY2lPdeC2YVFu21Cb5atkcpwiMq7UciUjPjGdwsVAOS2L/V2W/D2clcLZfcqp8ZSHPVd1U2BCp4aGMwFbrZfgGf3R3R1UogC9TPaOuog4OLYbJwNjkQRJdDzHwO4X+h1QcwDBodXHu5WSU3bSK49Gb7nm0DuWbGI47DU2eL93qXRcmO8xtX5ZsE8/uc8i9ESNAg1OG4B8S+3D/X2SV2wexBLaAOSKFZIO+cvDHlI6MTz8jAx5lL2YDxhXQwrEYl06CwFD3ROdKQbTlFUk6cJOqhG5QEd6MQjY/sECRW0THdzP3sm993v/4aImYKQIXDTsn0u4g8NW2ow8uwUd92hwHs+aKjRlKhqXYAZ/GkplxTvBJS2hYGW/okrTzysvXtdgEMnMt+sRC+nSl2ymVbWpYyru9W6fKs8rIMvAdiecysN946LE3DECRcKBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 11:30:48PM -0700, Lokesh Gidra wrote:
> On Thu, Sep 18, 2025 at 5:38 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Sep 17, 2025 at 10:51:35PM -0700, Lokesh Gidra wrote:
> > > Now that rmap_walk() is guaranteed to be called with the folio lock
> > > held, we can stop serializing on the src VMA anon_vma lock when moving
> > > an exclusive folio from a src VMA to a dst VMA in UFFDIO_MOVE ioctl.
> > >
> > > When moving a folio, we modify folio->mapping through
> > > folio_move_anon_rmap() and adjust folio->index accordingly. Doing that
> > > while we could have concurrent RMAP walks would be dangerous. Therefore,
> > > to avoid that, we had to acquire anon_vma of src VMA in write-mode. That
> > > meant that when multiple threads called UFFDIO_MOVE concurrently on
> > > distinct pages of the same src VMA, they would serialize on it, hurting
> > > scalability.
> > >
> > > In addition to avoiding the scalability bottleneck, this patch also
> > > simplifies the complicated lock dance that UFFDIO_MOVE has to go through
> > > between RCU, folio-lock, ptl, and anon_vma.
> > >
> > > folio_move_anon_rmap() already enforces that the folio is locked. So
> > > when we have the folio locked we can no longer race with concurrent
> > > rmap_walk() as used by folio_referenced() and hence the anon_vma lock
> >
> > And other rmap callers right?
> Right. Will fix it in the next version.

Thanks!

> >
> > > is no longer required.
> > >
> > > Note that this handling is now the same as for other
> > > folio_move_anon_rmap() users that also do not hold the anon_vma lock --
> > > namely COW reuse handling. These users never required the anon_vma lock
> > > as they are only moving the anon VMA closer to the anon_vma leaf of the
> > > VMA, for example, from an anon_vma root to a leaf of that root. rmap
> > > walks were always able to tolerate that scenario.
> >
> > Which users?
>
> The COW reusers, namely:
> do_wp_page()->wp_can_reuse_anon_folio()
> do_huge_pmd_wp_page()
> hugetlb_wp()

Right let's put this in the commit message is what I mean :)

>
> >
> > >
> > > CC: David Hildenbrand <david@redhat.com>
> > > CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > CC: Peter Xu <peterx@redhat.com>
> > > CC: Suren Baghdasaryan <surenb@google.com>
> > > CC: Barry Song <baohua@kernel.org>
> > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > ---
> > >  mm/huge_memory.c | 22 +----------------
> > >  mm/userfaultfd.c | 62 +++++++++---------------------------------------
> > >  2 files changed, 12 insertions(+), 72 deletions(-)
> > >
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 5acca24bbabb..f444c142a8be 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -2533,7 +2533,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
> > >       pmd_t _dst_pmd, src_pmdval;
> > >       struct page *src_page;
> > >       struct folio *src_folio;
> > > -     struct anon_vma *src_anon_vma;
> > >       spinlock_t *src_ptl, *dst_ptl;
> > >       pgtable_t src_pgtable;
> > >       struct mmu_notifier_range range;
> > > @@ -2582,23 +2581,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
> > >                               src_addr + HPAGE_PMD_SIZE);
> > >       mmu_notifier_invalidate_range_start(&range);
> > >
> > > -     if (src_folio) {
> > > +     if (src_folio)
> > >               folio_lock(src_folio);
> > >
> > > -             /*
> > > -              * split_huge_page walks the anon_vma chain without the page
> > > -              * lock. Serialize against it with the anon_vma lock, the page
> > > -              * lock is not enough.
> > > -              */
> > > -             src_anon_vma = folio_get_anon_vma(src_folio);
> > > -             if (!src_anon_vma) {
> > > -                     err = -EAGAIN;
> > > -                     goto unlock_folio;
> > > -             }
> > > -             anon_vma_lock_write(src_anon_vma);
> > > -     } else
> > > -             src_anon_vma = NULL;
> > > -
> >
> > Hmm this seems an odd thing to include in the uffd change. Why not just include
> > it in the last commit or as a separate commit?

You're changing move_pages_huge_pmd() here in a change that's about the uffd
change, seems unrelated no?

>
> I'm not sure I follow. What am I including here?
>
> BTW, IMHO, the comment is wrong here. folio split code already
> acquires folio lock. The anon_vma lock is required here for the same
> reason as non-large page case - to avoid concurrent rmap walks.

This is called via split_huge_page() used by KMS and memory failure, not the
usual folio split logic afaict.

But those callers all take the folio look afaict :)

So yeah the comment is wrong it seems!

