Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8C9C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6CC6B015C; Thu, 24 Jul 2025 05:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBECD6B015E; Thu, 24 Jul 2025 05:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C861A6B015F; Thu, 24 Jul 2025 05:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B40056B015C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:45:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F0CC1A02FE
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:45:51 +0000 (UTC)
X-FDA: 83698676502.04.6E14A40
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id D28FA140006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:45:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kUlnOn3O;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ivyPtgv4;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753350348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wllPSujkKijALqUaNuwhNY0u5uRDbQ5z4hYUWVF6VkQ=;
	b=Knk0yTRWzNR/tSx/Pb/Y20N+Ja0+drOOQet+MetW9/icumffVxn9lDw5UaNaQo1PgKLG8S
	EUHJH2pgeF+T/I1TNa6Bdlrr/LEqFwVMMKDSI2777dTsW4FLfq53LNIFID/Do7LVH3QWUK
	HI6PRHbPI4jy5GcSmxOxU2jtwxC8be4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753350348; a=rsa-sha256;
	cv=pass;
	b=QF21DEnXqCiiXxsrsCwqNN3zpnIdyQJXrYqEs3aZVvGgc+W+vyt39IeYdPscmRdAkh3i8v
	KrJnGjuNTn5zJkCmAxcNXfbLIDPV9v3hqF6dJD7MoDedihO6ogA4hk5M8Pq4jViUuEgBPh
	L3FEL0zCFaAZUAYB+lWslVsgrhqpg1I=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kUlnOn3O;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ivyPtgv4;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56O6v4gB010676;
	Thu, 24 Jul 2025 09:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wllPSujkKijALqUaNuwhNY0u5uRDbQ5z4hYUWVF6VkQ=; b=
	kUlnOn3OOGJF5ta2BorlAPr+r+mxQSqFenJXnAfBidftTvPMlx7tS1tVsnme8L/D
	7+d8/cdetsg7WrpiqGflmhJ4bL+0kxVjVm8rKq7C9KrxOWnFKbj4jOinP8zFjdtj
	ec85O8c9lB4p40OULL7R9qwng92W8fll17NbY1h5jGwHyR0ddP5xHbJO/NDQ8EXZ
	eIErNa1QbepwzLEh6g97qQP9B3qISXW7mpwMn4ulL6/JlHwdzsDTE4Ffn9XsfDc3
	TxFHSRvSS8LA/ARSIPOa4wfc+q/R/faRLlPBUywefGgg5yZugz8M+g6so/XpbXhQ
	VfeVBdwhM9dnI5HrTuvxaw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2h6yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 09:45:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56O7oTsp005990;
	Thu, 24 Jul 2025 09:45:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tbn8e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 09:45:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YBNTOqLfpYtV/0wDCn01A6vIFQPW1m8fyIgvW0H2eJi3a9eiOlFVJkZAMgGabqILzti4y9pdRnSV1itJ7zYAbUA7I+4PZ4BNrcpzXTf9PKgl2Bum9fy460FwrgybBOq90dW62jVSKgZvsx7THnuAwjqekBpCu2mkHKxXfJZJpKYcMBiYaadNdm0HquvN/sl61Obcx7+YIHlDqbLK676kSq4zGL5srK1ZzmddE73elYZFl3bWbDZp3HjYH2oY4zKeGSBLzv68RcJjAqlSgaKxZP3w+kBSihFajYBOCjNBdLb3r2aX87WicFCcMYSneK2DYPqjeGp8gjebntcOXo5jng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wllPSujkKijALqUaNuwhNY0u5uRDbQ5z4hYUWVF6VkQ=;
 b=Jqv3Ny0EaC34FPtVjYPCloP5e1AKCmFzVKCWh3Bj8z8dHU4GOyazZRfRgFkqp5VUsM8XJYdAFTrsxb3oLB/v7PgfYVF8cSUGlHZP5D2eYyHxjGkFG4jnekg9ESkhID4gkn86CASldhf+ZMfYWEom4rTmGA6LJvbyNwhnL6kDl5hK8NQpdkXaRyGkYcJOTtoHHeY2SwiWAIoWkUfqD++2AblcxU8T6UfJjFQk4JXICsx3gavivusQngiN8L86p9vPv2oCVrFtIQ/OkD8V0iKISYveqIVigMLI8KdGTSZYQTwDNV9Q9kQTAPc78egbGweBcuQYOoGihUP94XRey+1jPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wllPSujkKijALqUaNuwhNY0u5uRDbQ5z4hYUWVF6VkQ=;
 b=ivyPtgv47wZ9DB5ZB5MrqtVTVbYRF9P7besQA7H+ImiWcorB7yavaM8wmEJz6Mc+WA4zvcJdnjfoe5sXtGX7VhqBjJBwxKLdrGn1ulHPT1AfFEPHZ3jOlSpcUSuOmhgCRQAPFEjHKjpXG0mAD81s4p7OGrYMoT7hmP/0IPZG7Kg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4314.namprd10.prod.outlook.com (2603:10b6:5:216::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Thu, 24 Jul
 2025 09:45:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 09:45:32 +0000
Date: Thu, 24 Jul 2025 10:45:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Huan Yang <link@vivo.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Usama Arif <usamaarif642@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
Message-ID: <f21b75f9-0650-44c2-bf47-516390364a8b@lucifer.local>
References: <20250724084441.380404-1-link@vivo.com>
 <86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com>
 <cc560d48-884d-4c8f-9fb0-565d74ad769a@vivo.com>
 <e9bb93a6-1e95-40e5-ad10-a60d80735432@redhat.com>
 <6d14e212-418e-4734-b256-b75c6fade25c@redhat.com>
 <23b986e2-80d6-432f-8188-7a11d6915c9f@redhat.com>
 <cd253bcb-3ffa-4871-ae11-59d158fafada@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd253bcb-3ffa-4871-ae11-59d158fafada@vivo.com>
X-ClientProxiedBy: LO4P265CA0176.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4314:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ecb5297-71a6-4f9d-ca89-08ddca96d4e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVlmWllXcnRValZwMkFESjFwcnovaVFyYWpzUFNtUjlrTk55ZVJOTEpVaWFT?=
 =?utf-8?B?MC9MYWtZMEdocUgyOHg5dURSRmJ5ZUVGTE9BU3V3c3ZVTDRZaUo4d04xelB1?=
 =?utf-8?B?UUFyZEhhSUdJYUdWSTM5cEtTeStyTFczVHdEamptRUpPM3E4VUpxUzhVYUE1?=
 =?utf-8?B?a05DSVBWL0V2YzEzZXAyVVFTa2lpdGM4OHFMZHkrNWl5WTVuM2dkYjd6UUFL?=
 =?utf-8?B?STlxTWVLTXNOMUNpS25HUjRTbmIrWG5CaWNENy90am5FclpNZGh0RnBDOU54?=
 =?utf-8?B?T2ZwZ2JpYmFMcmQ5RVhLTDJ5SnllOWZNaFQ5WmNQWGpNbUk5SFF6ZWU1MzhT?=
 =?utf-8?B?Uy9YbWVqSlM4eGtId055cjl6YUlFdWpmSDFSSlpQOU9SdEpCZ3B6a1JOTTJ6?=
 =?utf-8?B?Y3V1K1lXK202SzdXUWphU2s5UWFQRW9jTkRiUktncFpnR2xTZExiSThxbEFx?=
 =?utf-8?B?OEZ4T1dtcGl3d3JFN0QxMTFObGE5N1NWaVVieXBOcUxIaW1TdmlaVC8wQW5L?=
 =?utf-8?B?bW5Nb09hbGVGbUVmeFNDS0cyZFpFdXZTb0dmYXZkd3Q2K2JoNDQzS0EzcWFu?=
 =?utf-8?B?NUZFYllzWGZoQm5NVGhDcndYVWc1V0F4NWdQQmoyQUcxWnd1NFV1bWlIUjI4?=
 =?utf-8?B?Mm55YVI3MkJ2MzlocEhYZE1hV3lwMk1CQlRNMkJLNmhORUhPQWh2SjNvcW5i?=
 =?utf-8?B?dStJKzRvTFpWUVpWaE9iUjVDTDFUaE9nZDRIR0NnSytIcExUMjlzd1p5UnMy?=
 =?utf-8?B?TmNSNCtjRThHNGNySkJvdlY5TnVPTFpZZzFQUVd0TURxQkg1Sm1XSExqRGpi?=
 =?utf-8?B?Mnc0UEJoMXBRdmc1bVJQZFo5SEl5Z2plRjYySldRMGt2UFBLQkhuZTM5ekRB?=
 =?utf-8?B?bllPYkVncUxjc1BpdTUwNHVxZVNEa0Zxd0MxdFN1Rll2UnMwTk1USk9TSCty?=
 =?utf-8?B?Y21FejNRL05zcDVOY0h3R0xFMDhSRVVNQnNpNHBldW51czViTzNoSmV1TjNl?=
 =?utf-8?B?MWRDank3a2ZkcXJjQmgybnN1bmNMN2c5bEJTOVlQZi9NRWZ3NmpRQVlYOFRF?=
 =?utf-8?B?OFl4RHVCMWpZbUlkQmZCR2RaNTV2QmxBc2ZZdnNlWVViUnlGbjNWRTlnOWdX?=
 =?utf-8?B?MDNJMHYwWWhXSDVVcGJFUzVsbUpDemE3MkNHcFRPVHF3T0dJMkhoWEhnMWMv?=
 =?utf-8?B?UWh3cUtCazNZS2RBUmdxOEJRV04xUmdZS1RyYUF1citXYVArVjltTytaTkRv?=
 =?utf-8?B?Q2ZJV3JlNW82MlBVbGxxNzZWdGZ5SDd5Y0RFcmUyeFJhMmNpRXRlVk9BMmw1?=
 =?utf-8?B?UkFseFJCMi9DY01ncm5jVXk1U2FDWmQyTFBuMjVaaWh2OURrbjZRYUFjRjVI?=
 =?utf-8?B?eTIxeGU2bWRJQjJJTk9FNHJlMDcrWHdUa3BrMmFYSitKVVUyL295Ukp3bFNT?=
 =?utf-8?B?TVEvVVB4QTVDak1JRDIwcUlMakQ1dmUwQ1ZJemJkcGZScGtUWEJsRXE1WHBr?=
 =?utf-8?B?dWdMZm1KU09xcTZ5S1RPVUJ2Wk1SQlA5V3pQUHVRd2hEMXMyb0hDbG9kTWNK?=
 =?utf-8?B?a1liK3VLUEhOTU5mYlFEVlU0SjVCdW9zOW54VCt5OGNxbnNCYm5FZ0VOT3lP?=
 =?utf-8?B?ZEdXU2tDM3QwWERuYWU1VG9EaGR0Q1g3TVpuMm5tWGdDMWFFRWRQK3QwVjhS?=
 =?utf-8?B?MkZnWWxKRHI3MlBqeVp5NWswSlphbTh1U0FtZ3FFQTB2OU0zRFFIUGhuRWhm?=
 =?utf-8?B?VGJUdUVtMk11OTdtOXNnR1dRWDlSWGNzcC9XQjZDNjM4dHlubzc1VEhoRVdT?=
 =?utf-8?B?blFHMkRzVWxFV3ltWUQ4R0RGWGNHekZFckprSlFpVldlMnhRd0ZUc0M1Zlkz?=
 =?utf-8?B?Rzk5UDAxdi9zdnpLVy9SSGdwbHpCZ0lIMi92UStPeVZZOHhDcTRoTWlFbDJm?=
 =?utf-8?Q?dcnm4PfLjXc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0hLcGZLZmJWeEVMVzhMdFd0RDJhalZ1OGpNeGN3RVNvK0lBcXB1Nk9vKzRX?=
 =?utf-8?B?M2JaeHo2WlpmZENZOFZrcExmS0MwN2dDUVJ3dTRSL2pvVnpiVHhlSlFDMDR1?=
 =?utf-8?B?SE8ycGtvbmtSbUhudSt2c2JjTFlBb0hOdGxTREQ2U3E1ZXFqWU1tMXFlNUJL?=
 =?utf-8?B?aU9NRTIvRzJQZDk2MXVOY3J0MEwrNTNhdTBsTXBoMy83bUdCN0N0QTlIVCtQ?=
 =?utf-8?B?RGZLeTdEWjNNOVVreG1XNjhQczZxTnpmdU1XZUYxTzF6eExqbzhaenV2S2hx?=
 =?utf-8?B?VVBvM2hLYVp2TkM5eDdhQXF2TWloVS8rdkIxcFM5SFV6dXV5QkYvSzVDcVcw?=
 =?utf-8?B?VmtyMURSb3kvVlRSbTFvNmUrRll0NTdHUkF3QXVqUVF1WTl1MWZka3VLYTM4?=
 =?utf-8?B?K0srd3U3K2hMb3B2WXVlS0hlVnFZQVNTRkN3Q2l0N3Q3VGZ3bVYrVmc2VzFu?=
 =?utf-8?B?NkxVSkw5V0p4K0hyT2s0elNPRGJjOTJsNWFmdjB3bEFvNWVKQzcycWhpWGNq?=
 =?utf-8?B?VlRucGVja2pqVVJub0VRNkVoVUtwUnk3OGFqZVJhaTVUUjJmZElwMFEvQUwy?=
 =?utf-8?B?TTFiWjh0dlVlSDNraW9ISi9mV0lsTldES1JkcmlGWG5mZDIvNjJkcytsL21w?=
 =?utf-8?B?c0ZkVEYxRUIxVXo4ZUM4bjd4RkQwZE5BYkk2MFk3bjBkWXMrWTgxVUhnY210?=
 =?utf-8?B?NzNzWU5oT09GSDlBcC9BdVUrQnlHYm1SaGlRdVlodm5lM0dOVDAyZ0dIMEhp?=
 =?utf-8?B?UkpRendWWHhRcGk1bGw4YmtHSlpEVld0OVNaRGt1YzRvRDl0alJsRFNrc0py?=
 =?utf-8?B?ZWVnZzAreWNGUWdLQkFRWGZ1SjBhVzVScFVPQXlrZXBQcDlkN2M3eTFOamYy?=
 =?utf-8?B?RldVZjN1eUlhTFV3WEh5V0JUanNWQzVpS1FxZUxCbXNzczRKWVRLdVRSd0NX?=
 =?utf-8?B?TFhxT2JjVndwWVV4RU5nS2srbXJOeXhLNGp1R0hjbVpBUUpac2oycUloOVQz?=
 =?utf-8?B?MmE1TEpaRURvTis5c0RXMUI0U205cUFmN01qT1VvWHdYWnA1MlN0ZXo1VExL?=
 =?utf-8?B?RXJGbklyLzNWelBaOXlQWE9TZ0ErQzUvZis2OUFPOXd2ZHg1cERoZmR4RFo4?=
 =?utf-8?B?TUN1ZzVscGpuUUh6bytFd1R0c1J2M0VTYW9Ma3pPdk44Y051Ymh2TU1LSGVR?=
 =?utf-8?B?TUpWVjdTQ3ZOVVlnN1JudTdEaXg2UnFyd1FpVHUxYnVMb2EyQmk5bXlZczNk?=
 =?utf-8?B?ZEpKcnZQTHpaVkVzN1hSaUlwM1pGbm5UQzRQcjBiVmRvZHgrdXhzTHB2QmRG?=
 =?utf-8?B?ZmF6dGtFZ0pnZE0yRDlobG1WN1V6V01CTWphQ2R3cWtWYzJEbDMzZkZYcDlZ?=
 =?utf-8?B?Z0M2UnIyQUcybjhtWllIdEpZMVc2KzNRN2VBV1hyZ212WFE0RnBUcEJBa3hS?=
 =?utf-8?B?RnFNRkpXM0M0Zno1Y3lxZHVrZkJqYlVaa1BOS3lKeWcvVGdhQU96cnVicUpX?=
 =?utf-8?B?Um9RMG5XYnA5eURuMGc4N3FRYTUwR3grUE14b0JzckRHajRQeVN4NFhsOWEr?=
 =?utf-8?B?c1Y4cmFTNWo3ZlgvWlRnQ0ExSVBzYUM4MWZzRG9DekhLWVl4RTBzTTA2ZXpH?=
 =?utf-8?B?VUpyMnVRWjU5ZDBIQ3haTXh6Mm5idjNabnZMamh4OU1lMUprakozQUh5QVVF?=
 =?utf-8?B?aEFEU2lhWjRLQTRRVENBVkFkUGlBVTQ1Z3FVeHh5NDZyekMxVGsrdzAyclJT?=
 =?utf-8?B?eGRKbEkzNjYvbkFQK0xtK1VEVjc1aG9yLzV3WDQyWk5IcHhDUmJaTHZwZVNa?=
 =?utf-8?B?emVDNzB1TFJCTkVXV0VLSVZDWENFK0VJZ3pwYlg4ZlNOVTZKZXg5ZmlFVGRV?=
 =?utf-8?B?UUNxSWdRNUR4TXJ1cnVTQXcxbVpkajVUbUNpQkpoay9SMkplVnIrWmhaRDFW?=
 =?utf-8?B?WnhBVTRReHhDRiswUjdvVmpZY1dLU0t4VklidTdNKzNGWXlHeitJcGVVSkxY?=
 =?utf-8?B?WkxMQk5DdnJGQU9IaldoMUxhSC80ZU42Uk9wZ0dCOWJybjkydi9tV29vLzBR?=
 =?utf-8?B?MlN6TmVqaHVydHlPSDlPQnVSbVBMWFpRWVRZUkVXTllEYmZWdXV6eWprekww?=
 =?utf-8?B?L0ZydDlJNEdlRGpWZEMvd2JMdlBQTjZyanNiS1NsRlRWcFd4MDhnTE1xYS9P?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Kh1hTWK+TuCPMLS0w5oNSKraQqqv6cFCXocbfAu4HW8hTm171JJTBFLrVC+kwm2CLEB0G/jZTnbUqIjQjwASyyZLH15uGPtRjk1skZuuj66mjqIShF0+8MOYCNHdHjmyRo2fngZdJoTxrkskY7MUwJ3YExHgXdthfSnfcgybMY7XmxWoqL4NxYv7cbB5ze00xuFLE7xIh0Jng+MdIlsawIFq0dRkFn3j3Vl8IRXF0bXgdyTa8aQCkZZEpGoq7dlHERVqaE0kWwe1qBjslJBNfQxLKzgplfsikzlzcyS9d7qdAs+3kVkHC0gTCPA2FlD/HfxrkRMFT0zMY14Ow3HIwC27YedYXG/gxnx5Ibvpf4H2rGmU6yeRIMQ+oxgV9+TqFSIfl3wA6mjHI9HWSLIhXCZM5TVkzYVS7MoRSgw5/qUgVNUZQYmA3WJE4V+QywocgcogkzytXgxN1jyPnD/6u3bGMvSThxXBzqsLoIrlmnwfFKo9+HLfNQ0myfjNQeNEJFrPqx2K7rYMzEdxk4bxdgKuv9zY3aJIUsp5Iht71Ly2ZMlz3uu3vXa43mfTtqSbPYAj99Tri/Pe3gXK5zaw/YsKu6eqhX2FVNhvSBMUO0U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecb5297-71a6-4f9d-ca89-08ddca96d4e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 09:45:32.3195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrVNKNHBWvkN2MiQvlvYFb/eGvWct/WMf2aanylALUKzE09JxjYUpOUwk2BBqroeVbpPMxKNoPHuECZwISsepRsedogRj8zd+KBVf1QGQvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4314
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_01,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507240072
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=688200c0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=IHR0lOiCIIzv-D3y570A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 8bo8aAShbXXGCXAD8dZ8YqiehlOXudHC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDA3MiBTYWx0ZWRfX2E8ptuKD61J+
 LkeyKrSRLlE3hlZ5k29k2m5ispjV2Ynz5aFzi1kT5xaCv6tXlGg2kyayCowy/9Oa7yvNTLm6B+F
 O7MqkStbNszGarh6VLiSbC5H0Bqt0jk5DRF2X6Yd6hFDh3iCi1M/4FA6fHcsOCE5492aDaGJkan
 yO71vkjALi8A7bCKAjqq6X0kGWPRsJmcKKWblHh+4fAW/Zj32+fO4fS203Ws8JbbgQcfjNiGwBe
 qKsfx+PesJI8HiYp0EWLfxJNl98iJzyTK4/v6rlixf4lxtqSiaKJAdKWnUYp/6bkV16MblB1qSa
 hh4kSCJzwjtDarMtNN3ZpxikVa+u0IlYIj5SYQrpBfhaQtF10DFC3dU2h46DNIr0efP8fe8623a
 y65ahQ8TlK//5StZJntNkfK+rghVWAVzUR+1qhqxJBfSnBZjK4uq190HVHnmbVxvbQMm/v1E
X-Proofpoint-ORIG-GUID: 8bo8aAShbXXGCXAD8dZ8YqiehlOXudHC
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D28FA140006
X-Stat-Signature: nox5i5ppacaohtmduwn5g74hs1kauex6
X-Rspam-User: 
X-HE-Tag: 1753350347-731339
X-HE-Meta: U2FsdGVkX185RHvrWj5+FMAKigazYXcSePDT+ZamahwOh84xNygblyPhLWcsEsIabEHfxNo8cY76HD/g81XYaRAE7UKr+R5Uyv6n+tBZ48UDCp+db8a1SxPLuf8iqAFR2nwQUhVnL9+ntaj56ntiG5W+eCl/XhJrM6yiJlDJqLJ314L870To/KOkG9fVVH0UyJ1iN9O7LcCQ/+Cszq4Yajok3zt4I9f0x/7EJJE13Ndc36iVWMTbmWXB/TAapYG2CL6mGESdr+GE3xtNpPPLnPr/4vhdm/AYoMcyiysbOzDRcLZJCXMiKxhyyT19tRG6Ah2NKr5gJkeVYfm9Ay3pdd50+Fv1yC4KyhllN+9awUQyMRR8w69hdswP3d/0W/mxIhpuA3HoKzpgn8jstYgvABzLK7c235fqSKrjM9LUOWwJIMyp5rXknMR1bRJ4uuIxqDz0HDt++zMGJ2hmeDiA8bQr56FLrfY7v99iTU/Nn/x9ZiC1PbZhrI5J9ZcNGbidxkBc81fyuAH//yladSOw4hjHOThFOSZkvan7H4HaVp8/jI5ZXGpVSRI+CFEWWnBwoFQUhcBsxNgxof6ZV3cQLOoenuquFTN9VOeGIakrnB5yx/84r3bi4dfJmxPCIuay614pGCKAP2D0CQvfbu0q+YGvUKlJNA37RRbbdm4xwQbRCzXqAF6mYqVhQyWKsAMCDHOnuXmEnjHF5biL06MpjsvPI+3m9Cbq8E98tlTv1kPFFpzs6wOzbCykRp6VQD62ZfSUPIz0nK+rmAeSqxMpw4Cj717Xfdr2vBG/bn3cbmmy2lki0b3jLJv0vUi9H/xqBgZnF4p+H8MqntvVZRPyjnyStCWTLu6twkHgDadGS/MhWTojdNXZBT2Yyn6e+3majlvnuzXbZYZw+xRazoyrFk9Y691nS5b+aR5YLvRLXPpU+2P9NQrGrBGXpD+Zi+CMe9uiJTwoytjQT1jluZl
 6RUos/hj
 9F6W4AIyHNgOd79YR5mTKISXqSbi2mF40rYRv8K+ZnYlY105ZwfAEWUoQEHqQNm7yLA6DpsVbpCP+uqAzXotlRbSwNj3LHtyfFio2Rf48o0Jye53mAsTOBGbrkfIwVlbTwPIEDK9SQoVS94ohFD1EhYHgSkVfp2/eoUN+ZoKf7N2m4mlseA9hfDZwT0AY9kgp3z7dLtxOywN14rWpB+nZlL8t8cyUuD4+DZ80xt4IoDguJvfBIwbWZcYgXIu1VQdBTzO6B6tQ4izc56ksDTDq80AcszE6GYqQ4F88qFd/cayxijuE8Lm+ufjXNaFWslgwnu5CMWLiwv31WYNj9mhZHn7nQWSIMVrFc1FCRDpiSzxx5PvGPs7qzXEOCND71780lmDWheO/dAWtr0kz7yAAXZV4GiyI9KYF0Cu3Xw/aB5B33jR1lUso90fQptRNYH+TdPE+zY0N/WyyKLxMTLzF4D47AZOefl8TY19OifEWTO2BOYmXK/GXNgcm1hq+C5wYgYbE08F8gSZrvg6AeoGIHEXnIMIsUJvfb6VWh0kKvyU+GC4qNCUNTnLE/oXjO7xOM93O25zET7pe5qJf8TVxav4ff799GR3QxVvbYgLEuIgc83W1m02tNlqxgJne/am5sMMRLLORHML7oVhfCvVHxtVk8SsPuiUX2gAyCckqg6B6NXy7YNk9C8s6h9WETkigNu7ZJowyILaBsV5Z7FoVeD1xWhP9n592qiWJhocqIcHyYOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 05:36:27PM +0800, Huan Yang wrote:
>
> 在 2025/7/24 17:32, David Hildenbrand 写道:
> > On 24.07.25 11:20, David Hildenbrand wrote:
> > > On 24.07.25 11:12, David Hildenbrand wrote:
> > > > On 24.07.25 11:09, Huan Yang wrote:
> > > > >
> > > > > 在 2025/7/24 16:59, David Hildenbrand 写道:
> > > > > > On 24.07.25 10:44, Huan Yang wrote:
> > > > > > > Summary
> > > > > > > ==
> > > > > > > This patchset reuses page_type to store migrate
> > > > > > > entry count during the
> > > > > > > period from migrate entry setup to removal, enabling accelerated VMA
> > > > > > > traversal when removing migrate entries, following a similar
> > > > > > > principle to
> > > > > > > early termination when folio is unmapped in try_to_migrate.
> > > > > >
> > > > > > I absolutely detest (ab)using page types for that, so no from my side
> > > > > > unless I am missing something important.
> > > > > >
> > > > > > >
> > > > > > > In my self-constructed test scenario, the migration
> > > > > > > time can be reduced
> > > > > >
> > > > > > How relevant is that in practice?
> > > > >
> > > > > IMO, any folio mapped < nr vma in mapping(anon_vma, addresss_space),
> > > > > will benefit from this.
> > > > >
> > > > > So, all pages that have been COW-ed by child processes can be skipped.
> > > >
> > > > For small anon folios, you could use the anon-exclusive marker
> > > > to derive
> > > > "there can only be a single mapping".
> > > >
> > > > It's stored alongside the migration entry.
> > > >
> > > > So once you restored that single migration entry, you can just stop the
> > > > walk.
> > >
> > > Essentially, something (untested) like this:
> > >
> > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > index 425401b2d4e14..aa5bf96b1daee 100644
> > > --- a/mm/migrate.c
> > > +++ b/mm/migrate.c
> > > @@ -421,6 +421,15 @@ static bool remove_migration_pte(struct folio
> > > *folio,
> > >                      /* No need to invalidate - it was non-present
> > > before */
> > >                   update_mmu_cache(vma, pvmw.address, pvmw.pte);
> > > +
> > > +               /*
> > > +                * If the small anon folio is exclusive, here can be
> > > exactly one
> > > +                * page mapping -- the one we just restored.
> > > +                */
> > > +               if (!folio_test_large(folio) && (rmap_flags &
> > > RMAP_EXCLUSIVE)) {
> > > +                       page_vma_mapped_walk_done(&pvmw);
> > > +                       break;
> > > +               }
> > >           }
> > >              return true;
> >
> > Probably that won't really help I assume, because __folio_set_anon()
> > will move the new anon folio under vma->anon_vma, not
> > vma->anon_vma->root.
> >
> > So I assume you mean that we had a COW-shared folio now mapped only into
> > some VMAs (some mappings in other processes removed due to CoW or
> > similar).
> >
> > In that case aborting early can help.
> >
> > Not in all cases though, just imagine that the very last VMA we're
> > iterating maps the page. You have to iterate through all of them either
> > way ... no way around that, really.
>
> Indeed, whether we can exit the loop early depends on the position of the
> terminating VMA in the tree.
>
> I think a better approach would be to remove the fully COW-ed VMAs and their
> associated AVCs from the anon_vma's tree.
>
> I've been researching this aspect, but haven't made any progress yet.(I have
> some ideas, but the specific implementation is still challenging.)
>

Please leave this alone, I'm in the midst of trying to make fundamental changes
to the anon rmap logic and it's really very subtle and indeed challenging (as
you've seen).

Since I intend to change the whole mechanism around this, efforts to adjust the
existing behaviour are going to strictly conflict with that.

We are 'lazy' in actually properly accounting for fully CoW'd VMAs and so can
only know 'maybe' if it has, I mean as from above you've noticed.

The CoW hierarchy also makes life challenging, see vma_had_uncowed_parents() for
an example of the subtlty.

Having looked at anon rmap in detail, I have come to think the only sensible way
forward is something fairly bold.

Thanks!

