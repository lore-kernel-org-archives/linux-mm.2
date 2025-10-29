Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9901CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461B38E00CF; Wed, 29 Oct 2025 14:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438BE8E00B2; Wed, 29 Oct 2025 14:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300908E00CF; Wed, 29 Oct 2025 14:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2628E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:58:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2EA78911E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:58:55 +0000 (UTC)
X-FDA: 84052063830.28.D947554
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 63FBAA000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:58:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nRr6M623;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ePYAO+br;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcNVeP3WZ59v8Fl9eXXvY4iG8/VXkhgs2GPwWBzqIf8=;
	b=OxgxsQoCgMqYcKz4oPud2zsy3r9XeA/YtmUUVMjXkoimiw81L/OjRC3pguexPuGJMNK4Sg
	N9Qv/RiCbVP+vfXZmsYbcWeb4PL/7xnGhX6sNy3aLyz9de7ZJlQCUqS4xQABujo7hci51w
	VCwGNDnSn1Sk5Q6jRoOeze0a642ahNA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nRr6M623;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ePYAO+br;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761764332; a=rsa-sha256;
	cv=pass;
	b=s0MatCdphVpSq95BijVzEIHuzaJfdf50hh+Lb+/uWIzYM+5h0BhPzkz7aM+3jRsVVedXDN
	04mmdv+K0A9Loa/EFa920PZfKoUMY3tcjYEJYnujNfuqxoLZnvwqXn8Hbb1mrI4ZLvZvjY
	gExDk8h0Xl0FwT1T49ibdISdC8w6oKM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TIp4st021838;
	Wed, 29 Oct 2025 18:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IcNVeP3WZ59v8Fl9eXXvY4iG8/VXkhgs2GPwWBzqIf8=; b=
	nRr6M6235QiY/fTla0fEaZBlBw8s23rHyGgOpJUxlBRJOB7zkCTjbdiww1vEbC8a
	FubWSeDTwnAoM9RA0UVplzbcjOi2Oucq++A92RfuDnFU+bAzmksPgUKO/SoLqKm2
	xUyuDz6Mfo+4GtyID6HdDHdrvaZ5qjESAaGjkuJCDna1c0kZufzPUrHRKDiROrfX
	qYaf1ERHAT24k74IiRp7Rd2g8MnlzoZhGjGuCqyaFYOu/jJMrMWioUmtVava2pBg
	XSsLl85uxQ0al7RUh9F7QacONUWd08k/Xll0OCgK2Wieev8mcJsWG45aR/9LGiGs
	MvX+aJOL1m9b0YqxcL9c9Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a33vwas4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 18:58:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59TIrRQL007615;
	Wed, 29 Oct 2025 18:58:33 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012007.outbound.protection.outlook.com [40.107.209.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33wkmhwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 18:58:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=He3u+2JhWdt9WiVU98xjHQgr1VGVsqotBE21eGF+JZ9IViT/bV5JRhFY6mqEBoXSsKkTEkHKUzvh7OP3umHvK4j55jVY1eQiRLmAkcfZsWHV3Xt80+y3w4+fNEufRgiChjgrkCJGRtWoKo6A1zU1189sK4dw0isRkFMJdEvC13H8itRKNytIRPo4IVPEh2bIfCfLShWcqGr9jxipPT0MDQoKRbO4OS+xq9BKQH6AHy2o9WAszo3j2oV421XJbTsZLhjVlck0s+OU2dfl12dAQc6eGqNe/BMQblQoPp30jvEoFBGXZ+y/6Uy/jubXvj47URmgWxyI7Uy8zJDttxWVoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcNVeP3WZ59v8Fl9eXXvY4iG8/VXkhgs2GPwWBzqIf8=;
 b=Ug1gSnlAzmJg9ZheMouheyIjRA+HtSvujiBKStZVS5RX8qeZxnQ4Vz28AhZbYnTl/e1Hcm7Z7Qk1gdyyRhNMmdOX94BtkiGEAeEBJCtGj/RP2s4KX29GGomj3GNpzaTGRCgSObVCisbxr0jsYaGoK3Yb460qaf4h/Sipfp9E+ug+afVegKx0g7Rjctd04ziCA18byQn0P6GZfGAwrr46KXbcUkdFDWNUWF0NUtY7dQABUX7i1ky38pMXEJOvhZChYMnZ7Xpa6VaU8Dy8rN6en+1OTKbSgmTY35YPnIFrPswUQg1jqJJGJC67qbmUGu7LKb9E4tezvlY6kGFLoj1JLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcNVeP3WZ59v8Fl9eXXvY4iG8/VXkhgs2GPwWBzqIf8=;
 b=ePYAO+bryBw151wovQiKPmxM3zR+ec0fvrnXuqfjBP21Uroy+BSsbqua9H3B+Wo5jVddMMb5RQyXeFHtCPtkC1pCXuJaJ8rNS3C+I4KGriQzQLFAZZsM7e0N7PeB4EkGK9Y28ZTdmQfjpxRbzWoiUKB6jMvROdZhKpXwYqThOzI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 18:58:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 18:58:06 +0000
Date: Wed, 29 Oct 2025 18:58:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <02a72419-bc89-481a-ad2a-a3c91713244d@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
 <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
 <CAA1CXcD1YDAbYzdYfchOWbmUasa3tN55AYroOLJb2EqoQfibvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcD1YDAbYzdYfchOWbmUasa3tN55AYroOLJb2EqoQfibvw@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0313.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BY5PR10MB4339:EE_
X-MS-Office365-Filtering-Correlation-Id: c9578717-4c6c-4420-88bd-08de171d1893
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tll1YkdiS3dVT1FaL1BiRXpkZHJRQ0Z0bFF4bVpQVHpEbWNqaUF2TkZheko5?=
 =?utf-8?B?WGdhQUh1QjNJYS9tMkRoYUxLcFN0N1h1Yk1KeUVHOUNzZ0k5ZDV5QkI0MDcy?=
 =?utf-8?B?bTM3aS9rdUxUengrV0h2K3N6ZW4wakxXQWUwZTFzV2FaMVZqTlpTb09ZeVBy?=
 =?utf-8?B?QkRveTdWS0x1bE82bWQ3bEpycy9iR1IyK2JZWFRJb25zTjloRnJKMjd6Zklq?=
 =?utf-8?B?Lzh0eHhqZ0dwMFlyY0dkUkZzeG1DWFlLWnZiRHVwVFhRVFIyZWh3ZmxSQlNN?=
 =?utf-8?B?cWM0WmdNNlNlWEd0UllUTXVaTlliRTBQLy9hTjlyV3RnaHYvVEI5S0pEZ3Z0?=
 =?utf-8?B?eS8rMWtSK1g0bW5pNFBTUVlSVlVTcmoxc21FL0I5bGFTbHY4MUdWRFNvYmx4?=
 =?utf-8?B?aldMUGo4dUs1YzR0OUtocUZ2TWlMUDU0ajVqbk1MeDY4SW5ORnY1V0h4UnJQ?=
 =?utf-8?B?ek5OV0UzaURIUEZpNXBxbU9oT3J0M3d4VFFFVEVjVHFzdVhDdXRHN2NjS0tZ?=
 =?utf-8?B?RHBUQkVPLzBadmw3d3JOUmt0bEFzb09iaFlOL3FBSnRwTW5rcVgzVE5zTytp?=
 =?utf-8?B?Y1h2OVA2aHJaaE9TVTRYWE1mbWtTaXNGY01ZQzZLVEE5RWNENnJOd0ZjQmJN?=
 =?utf-8?B?b2cwV3JnSks0eVcrbGdad0NwUFZRQUNWT204dDNLbVZNQjlNeEs4NzJ2OGtj?=
 =?utf-8?B?MzJiMW4yMEtXcVNLL3gxS2FtTmpRMEpFUXRkTmlGQnVIb3VrL3RSL2w0cm8w?=
 =?utf-8?B?YTVPb1FWeHl4VVF6dmtMN29lL3g1Wm9PQitDbEdJcXp3R2dFdHFIejlCWGJF?=
 =?utf-8?B?dE1uWlFJZlpCZEFRM2ZSN3FlZ1Foemd4c2dHUjBZcjJjQlgwR0lZZWxIc0NL?=
 =?utf-8?B?clBNNmtLWHVRYTJtc0RBM0h5emoxenhBYnliditCUlZRUGRVR1RoVkJ1SGR0?=
 =?utf-8?B?T1hnaEQ4SXVxTDlIRE16SzFlNkpsdWkxMW4vWjdEeE9JMUIwMjNkZlhmd1VN?=
 =?utf-8?B?WHJ5L2ZsTCtoNXlTMlg0ZEJsMDRaMGh1czJYaTdCTFdXRUh1akFudy9iQkVy?=
 =?utf-8?B?cURYN2oza3hzODQ1UjVRZVlYcUNPNUxjRnBEbFBKQlVvK2lBQVFhUEtDZUht?=
 =?utf-8?B?NktUN05qYlVib0lvRExiV0IvVFBPUGlSVi81VlNyakVWSTNvM0tlaVVvN1ZW?=
 =?utf-8?B?OU42b2N2QVNvZ2xNdnFFbzFYaWV3OE1leDJQZHR5Y2NIQ2wyc3JtcnVvek9Z?=
 =?utf-8?B?N0drRUhMZ1F5RG5HR011TCtRY1Q5bHN1VWNwU2RwY3dEODduVmkrMlZYdGJM?=
 =?utf-8?B?UzJ5UDJhUUZ5OXBoUlpKOXkzYlZlUzRoZEFicVcrRnVGUzIyQjRla1hEd1hr?=
 =?utf-8?B?SnJPb1pXT2V2Wnc3ZHVuQU53VG9SUkpnRzdQdjZSaXRvL0Vxcy94TTBKaG90?=
 =?utf-8?B?QXZ5c25GT0w2empLK0UxcVoxVGJxZ3ZNNFlJZ0tCNFZ3ZmNhcjdDV3JiK0Nx?=
 =?utf-8?B?d2xiRE8zaHoxaVpTZTdLSVRxdWpoQU51aEorTFVtNVkwdmZ3QTJ6RjV1WERw?=
 =?utf-8?B?cXJCVThCUEhuOGVPczJpRnBlb1VYSVpPYXprbGZmY3VEa21ZRW1aZlFXQU5k?=
 =?utf-8?B?aHpxRW1jOTRNWHgwZjREcmlod1QzVXFHcVNmcVJJbjBsdWxZY1BWVUY5WXRh?=
 =?utf-8?B?Z3RBa1BvaUsrQmQzbGRlSmpwWkNzc0dnSW5zem1CYzZIMnBLdjZHZXNnbmJ0?=
 =?utf-8?B?Q0tFYkZTNG56b1NYcUVvZVBjWlhORzZRbzZGZEFwbHY1akxocGw5eHVLelhq?=
 =?utf-8?B?VlQzMkxYWWgxN21KS1ZWY0pDQkcrNGIycHdOUkQxY1hzcHBGMnNZRzZ6MkI0?=
 =?utf-8?B?K3FNeVFoVnpJci9QNnhQdWZUWVJ5NlB3UmE2UGNBdVFDeWVoTG4reXZ0RHgr?=
 =?utf-8?Q?tmz4sTGw3hSAifp0o7BMPvXaXV6Cj+om?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anFXUEEvUFl4WCtaY0NZYUdlL1FRNURVSTJyUFhNN0pvYlNRTUV1U1dWSm9S?=
 =?utf-8?B?a01jRXBYRVVTdmNoTVAyV0JUbGZWbGlEV2wzQyt2ZWgxZnorWng3TzBlSmlW?=
 =?utf-8?B?WEtqZ0xndUo5MXRYR05LRU4wQSthSThjM0dqSWZYSmYzaWhJdFlwQmhJMXQ0?=
 =?utf-8?B?dE42Q28wWUJ3em0wWEZvaDIzbytJc2xuV0cvV0V1MFYvc3JCUXRBUDBRNlBj?=
 =?utf-8?B?bjFZL2ZGNE5ETnorYUI4R0p4dlk5T2RqaS9IU241NFI5UkJqMmtWaWkyTG5G?=
 =?utf-8?B?ak9TaE1JVEJld3hZdTNJVEljVVhmWXRuS2hqdGsyekRFdWJVTmZYUUlIa3c2?=
 =?utf-8?B?ekJuTFRnZEZmUGZBZnpDKzZhbzJ4YUVjdDlMK3I2YThtcjh0SW9EMFpSQUtm?=
 =?utf-8?B?WHEzeDR6MUNrdnNsRlhuLzFQbjUyMlozb0dpc3dYcUVjVURIdnkvYUNkUFVr?=
 =?utf-8?B?d1h0cVdPZFBWc1dweVZGbVFVdDJNWnFTNVhBWmtnSXNUUVZ4Tkp0Y3FvbHBN?=
 =?utf-8?B?VzdWc0t0ZHU1RkI2YXR5OWJaU01zMHBnRWdUTlZEbzhXbHdXcTdaM3lQQXZZ?=
 =?utf-8?B?QTVIRG82SUNqK2EwT2NuczZrdDBSMlE2R2hDZ2xBSG1aeEo0YUkxdzQyVUtl?=
 =?utf-8?B?V28rZEtHYkhOM1NBUTVVNFIxY0h0QktWU012dUk1T1hWRkJhb2VGemFtc082?=
 =?utf-8?B?NWZUdkhqR1B4Qkp3ZjRDSnVYWXY0T0k3Tjc5UFNTVUJ2dTlUalhMSTBaSVUv?=
 =?utf-8?B?cEYzdk5aUUp3anpjUXBIcDhOUXNPa1hkdXdnM1U3bThvc0NYRUlBZUJiZ2p3?=
 =?utf-8?B?RE5HRDc0SUF4UXFJUUhKWEoxV1h1RG83ZDM2ZmhKcUR2dlhHVklmVXBHSVpO?=
 =?utf-8?B?NWlMaG5iRjlpdzdiS0pBOHRvMzZUVWNTVEtDazUvYUtPMjFVaGQ3RmZvK0lC?=
 =?utf-8?B?SE1WdkZtc2paT1FXVmJMMTVnZjN5SXpEMnlIZG1Qd0t6S0xRcFFnUU5DaTBj?=
 =?utf-8?B?R1RFVHQrUS8vb3F0M0oyb21pRktSNWZRK2pUdUhlL3pZaEZaZFhwUURwaGty?=
 =?utf-8?B?SWh5c1RSMUk5Z0pSOXRTcDI4R3dNMmRMTEFoQzEvcm02ZzYzbmlKaldPVXFV?=
 =?utf-8?B?eHBYcnc4TUhKZVRsdWZnYU9oNEluZnI0RUJyRmMrWk9xMkN5VFZUcFkvS3Rv?=
 =?utf-8?B?NVBNeGd0YjMwR2NFQWw0NlpxRks0ZkdQbkVHZkJ6R2ZFZ0o0OGlra1R3Yzl2?=
 =?utf-8?B?bFVlSlE0SW91S1dnMXhDeEJ0WmFPc2NFRkpyTmpjamhJZkJaWFFKTU9wYm5i?=
 =?utf-8?B?bklMM0hGWlZNeDdtUXhTU0l6bUZEa1N5WlJYL1JjWmR1NzNWeE9USmR5MzhC?=
 =?utf-8?B?a3BJb2hhN3JST3NIeVdCcmZ3T0E1eDd5a2VzakZ6TVFYbDdwdXg1SjFVUFIz?=
 =?utf-8?B?NkxSRlQxdXlCamJHMlFzNmhmdnN0dDBvVWFWVi9jdGlYeWxVL2JmZmJ2a2dM?=
 =?utf-8?B?bi9wUVRPRHRmNWxLY0lPQUtZaUZYL2E1b2xsRXRVbGpDdGFocUl6a0pxUFpv?=
 =?utf-8?B?MCt4Rk9pMmp4WS9ZNHU3eXVveURZU0FhWTQ3TTNpazVFSm1MS05kY1VIWW9E?=
 =?utf-8?B?dDhVYUZsTk81dTZDYkZMejFzbXNZZjE0Y2dFelQ0b3JXbyt1UFE0M2NTOFZ5?=
 =?utf-8?B?U1Z1SEVGU0pJTTZzMEtlenJMeC9UZTRUU0c0eFRIaERUZjg5WkRVQ3poY1NQ?=
 =?utf-8?B?L0tSWHZIY2pxUFFwS1ZlY3RXa09UdVNXQ0xGZTNQcjNQZ2RPK2xRbWlXb2Rj?=
 =?utf-8?B?N3hkc0pJQlc3dDlwMkROeXBkNEJDTmMzNGF3cW85OVhIekt6U0tDZ3dvclpM?=
 =?utf-8?B?aitMWnZGRUNMeGlQZFk3RTdLTERjUVZ3ZTdQZGlQMUpTU2JyNkp5MWorRDVS?=
 =?utf-8?B?M2pILzh3QmVNaGo2aVpZR0N0RHdEeW83VkNvWnRGRk52ei91VEVVTWZpYThP?=
 =?utf-8?B?V09uYldKaUM3L3hqSHBkc20xdk9OKzVySVFld1huMW94UFpUMktKb2lHR2Zk?=
 =?utf-8?B?VnJpUmRhR0VOT294bzhEMFI2RGROTnZRSytXNUVkZzNFSDdRN0YvQWpyd2pz?=
 =?utf-8?B?UmJ0RVpNbnlZYkUrbUZJVjNKc1NGR3VSa3hSK0M0ZjFhSVo3TDZ2RDFWWDYr?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	esiDMc/oXafQEiepEkIiWS6J4ox+/cOMsWyqI2eGmr6mI3Pe1g7CjYMPdhr4Xmhl2yr0wNCG6MzF3E+UD34lL9qVA9Hzf/IoIYlF9+UnSMorQvaT4lJLG+1G9Z6pq0ger9Esghg1UKoQ/K35HdV8663ZNOHqtTzbEuXGK44HaPKQR1KfR6XRkU6V3nYfoPhWsQPcrLFO6bphgrD+dfFysJ75Iu2kWfScR5IQqOTzG7dkLjX1FiOBIdbFNxuYR9OuNyb1bv0FVoT7hqzCDcqOwRychxgMUTfMxVcFpOYgpUpD3vzqmDXYKRRiySxnO1o7FRH9gq8XuPb6OiBbNDG4t8O0D+kCwLxQjnQNQx1okGMKMUUjJHd8avt+6v7LLMpAHm4VSrfNCrv5B8fl7j5MaLLmPwFXomO8loZsEmJNroc1dVaxrbyv8QXUZBpW5wPObxyofnRJPQB3m3zJc0V5xnL+I4IJwN3O3DfIQFQeDQEYtPG4FBTCk3XaHdPauSeJM8ETFzcXtMkZw7hj/7Bww/gkqowgQK5dTfu+mXPxLcHqPYmA2W1Zm8mgxZZ3rNSLSnxh7CZz8BgLv0hG8KySyryY/Wye4lSPcDAl1txHtjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9578717-4c6c-4420-88bd-08de171d1893
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 18:58:06.7683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +FBx6kM6sQuxQ6PKoLylmkKpmoArbUflDvSksEU9CK/3GSrxxdouT5acQYalnZBVPeHMqPL8xGtCGo1Y1LHau+kW/mmJmbZGbEyiauF3XoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=847 adultscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290152
X-Proofpoint-GUID: s7INSwyKbCWFsE1SHLC-bh-kd41CIfJ3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2MiBTYWx0ZWRfX5zCCkCrloZ+T
 kZVWpR0YDdjMBRszgEDTAO5LyMzt6tKXXaw0Xst8lan8OkupNUbH2H/M7U5OOpo5OHaiZBRqvra
 QhNQKIuL9PPaqwpNPfRcvK7oCZyYTC0Z0LMtoZ51topR8iy2ssr6+SvGDp1r0HvMUl6dqYtdYHO
 XwbBygGwuqjX/jVADOh3uErtsB0ztVxnjVaBrtpmfQo/JpGneuy3vV6Qn6HTAkUotgjZxlMSQA7
 FSMG9ZitVlohmot2rvsv1yY7YYAe0owOyALX8v3CLMlgVP2FDKMSTgms6G3sjdYqML7Cbzwtx6p
 ONRPvQCtWkuk/5VBoUVMMy8f5ze7yGPyqwqf6OP7CCpIOCQ5YQZ/A6ir33qNJLvpkSPPm+uTXp2
 LPkhaRDHRbCvqqk6LLNrW6zR0q624Q==
X-Authority-Analysis: v=2.4 cv=Uslu9uwB c=1 sm=1 tr=0 ts=690263da cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=wkDpwTsrz1Foj6rrQE8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: s7INSwyKbCWFsE1SHLC-bh-kd41CIfJ3
X-Stat-Signature: jybbtnw51idwep3xy89miexe5byoouhi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 63FBAA000F
X-HE-Tag: 1761764332-609948
X-HE-Meta: U2FsdGVkX1/p+thVyJ/UI4XfYunnZ1F8F6UlxK/tuohY9Xd2yp1vLZHu7ThssDwlEncB50PDHlCmgMXBhzMEBls6h2xHsmx07zuYbskb2LGLk6oidxtjxfRoxEnHhExbNKc89kqfMZy/9KQmid0F7ArFKew3YUHp5cNdTMfTmtqea+rFmf6MM1yJfy0gtCtf2bwhyP1YSE/UAFF5/9S0TY9a9YyJ9Apn7X+1kwhZy8wU0L0wdG4ZRRUlC4rbJEi2KyPohH+g9fRdu52OKSOQvvV4uq1nBJfnjpHXsqCxFTAOuEUhJvsuEw27ecdp9KoOjtel5q0nANKHS20Ewj91bu5QSJ8m7W3Gh+Ewe6hNL6jtMWQBdYIwMkPQftzWCna3js01RZYbXo/eAyR9oLXfe/j8XfAjUkLd56Mk3m4JZKPmf+qOrNlcB6XVRQKpyiFt3upHd2q8l/XOidsdLU2+M8bX5xPkH1yDsG1zQthmD8bankN6QAcFSLb77WITxhyREt6FgvoUDVr4ITwuer2O+Hky2WHdPOGgYps0mhBduwIrJbWhlOHJ35O7R/At4CaL2snFSTpsEMshDr11qw5ipWJrNNZuZLfn1c4J16Cmky6okVe3prLFArovR9UYIeCAMbX2nSWDy3PlSORJY3fzoS06/qWpQvJbCh31YXUTfIxazDuq8J4QMrvPVFrRCxjFHCgYYArenUjS6tQhUY/3l099J+qXvUEsEB9ooLmgLPTd3j7D8YwJgcTU2X2MBHGpEwwLO1uls6MpOgELDNpaUsDDcLuUOAyECmLsxOSEX3Lq9FQFIM7vusZWWuxXoyk+EYMOFHr2nOAjZ5tom48Q3UqGxDb1aU1VtGWU8cnMVrKot+H2PDdwrJV5n3dZJroE7hNgUTYCrpCCgT/fJQXjmfqoyb+ktywWWF6R0NztK3NO4rdBg6hmWH9gC8ITKVb2JdVTMNwZK65t0Nq8enM
 ezK7qbG0
 nyFoeCHtT8Imcu/wqJGmAgUOWiASoY0YHYZ6FXY8NAjOrlWT7VYlWc9Z7gMqeeBWdMvO8yATkfDkoj+zGiNToKmuEVqA9BzY7vWBEC1pvAl5TL08VsNEx0xJf4yCRVENAgJ6Be69wUFNuz52JXmVday7AW1teB7z4MSJuGsn7yaoqQqVKKCOy+NXf7LseS5T4mGh3oDsPXYlcjRjVWtbDjBKHG7bm7KIOY6B2pGbl/1s9HFuc1D8FzYE9Wx2Rpf28RKnLP+EQZVwSm6gHcq9GRBjEyUCc7D1Rx3MHU8o3tCp0supXNtWbOhKCwiAhOo1Vw6lyvotVvp1uloNGUx0GfiidJh0+JPNrvm1UnLiqpYw/Rtt4JJmz/SEGcT5MwbmbPfat5Rjot9fE9jADnayc5km12O8zqqwJssH+EJgoIkgHikfX10XDvH9K9AQ40+M1GUdtNK00tCYzd+t4yfl9KlU7dkpMhs1EygteGvl3CHbP2lE6K5ZnXT8Zjgvfq4CT2G+ceqZFlL3pNzOsg5R/j13J7uVd9DUo2snoMv2GvUlmYaQ7hhMBxoZ4JACto9G+z/SgBniKzH0MNyR/+UApfNShXgkAh/IGMBc2vARF7i0goIKmesYegyhV0tMDFgizAfJl5MRfsPBJQuikWsCSiICYorOv+yYxiEZadgK4qD2uOaDppgLGK+oUet+9n2xTzLoT/DobekB0ORdB7nFUcZQKeRd7aDvmkq/C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 08:47:12PM -0600, Nico Pache wrote:
> On Tue, Oct 28, 2025 at 1:00 PM Lorenzo Stoakes
> > Right, well I agree if we can make this 0/511 thing work, let's do that.
>
> Ok, great, some consensus! I will go ahead with that solution.

:) awesome.

>
> Just to make sure we are all on the same page,

I am still stabilising my understanding of the creep issue, see the thread
where David kindly + patiently goes in detail, I think I am at a
(pre-examining algorithm itself) broad understanding of this.

>
> the max_ptes_none value will be treated as 0 for anything other than
> PMD collapse, or in the case of 511. Or will the max_ptes_none only
> work for mTHP collapse when it is 0.

511 implies always collapse zero/none, 0 implies never, as I understand it.

>
> static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> {
> unsigned int max_ptes_none;
>
> /* ignore max_ptes_none limits */
> if (full_scan)
> return HPAGE_PMD_NR - 1;
>
> if (order == HPAGE_PMD_ORDER)
> return khugepaged_max_ptes_none;
>
> if (khugepaged_max_ptes_none != HPAGE_PMD_NR - 1)
> return 0;
>
> return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> }
>
> Here's the implementation for the first approach, looks like Baolin
> was able to catch up and beat me to the other solution while I was
> mulling over the thread lol

Broadly looks similar to Baolin's, I made some suggestions over there
though!

>
> Cheers,
> -- Nico

Thanks, Lorenzo

