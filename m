Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186FFCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 18:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F848E0089; Thu, 30 Oct 2025 14:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F418E0153; Thu, 30 Oct 2025 14:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5984A8E0089; Thu, 30 Oct 2025 14:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BCAA8E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:04:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2AB957995
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:04:26 +0000 (UTC)
X-FDA: 84055555332.09.36CA126
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 60408C0008
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:04:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OI3agrfF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q4AgMjr0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761847463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bx5jETt2cNe8qJfaNnd5JBE2Yl+wOnbhqdRVzO1iu78=;
	b=fmeGx3YT6FZ9ndbFgNSar47ST2sDbXjx4mCN8Cqb4ceOm/3VeWS9Y/KqL8VrIa7c66cF+K
	Tq1m0zx/M03CkX32miRPgs6WuvBg0leDlanugyLoNjLYouG9GJO7uDyYtmpKvHZ5gRmW2J
	vY8uLtbbBGcCMpSJyt0zDzIWkb+FL5Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761847463; a=rsa-sha256;
	cv=pass;
	b=Vb/5IoXBmfIO1bqVd1qHsb5+5Sp+ilTJSRN9v3FsKckpVvCTUthEk6yESRqroQC6U0HwWw
	u+libk6b45kNqR4LShDiRKzSXs2+GqAvDyl/K3JzV86y0tEu11dGvK0m7yOc8NnPLEGrdP
	rrfRU3Dlapkd67jDmwZn2D6vI9/Ri24=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OI3agrfF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q4AgMjr0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UGuHPI007360;
	Thu, 30 Oct 2025 18:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bx5jETt2cNe8qJfaNnd5JBE2Yl+wOnbhqdRVzO1iu78=; b=
	OI3agrfF2f/RhnKc3VDFx/xd2I6p7uUIIifz+zCDqIe3/XUINSqVkP7evaZr1UXh
	jo+qRVpS9R1KdOvJcDzGKf1SN1sjhi7UpFkyx+Ye5KucuEQzEn9O7b9HrAcRs++2
	DJplwbIlGnawU2sjI9gyMA16xJ+SO9MwG101H9hG0TJpZpbVWZtIFkrLmSlgMXv4
	7eB+WUMq+x74QJ2baCzWDsPn7q8l6BTqJR6RGNSmPkgsV1GGl9P31FIC/cBpW1ZS
	QiK9kamzOGke0y0iTAPvsyc1dh+TjOBKKcxNzaH91HA6YBSWpO3G6MzYTQ363SbM
	PQxw2u7JVi/T7NfTlQ4VXA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4b2qgbqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 18:03:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59UGPWdg007872;
	Thu, 30 Oct 2025 18:03:50 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010061.outbound.protection.outlook.com [40.93.198.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a359vn399-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 18:03:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwtDRh6hU+HNBuxGpSHzOS0pal11cJVjngBb3TgfTRPyCtgW43+sXIufRP9uawm4yfi1ah0x/TU9eV9Me4Uee0nRK+au7K/+RsdStPZfT6eYDZWJsbwQ7u9651XwuelvMVSJul1boQOdNsgVj374Qk084wndgonhulvjQTkfo/ILdKEvmnZNJMLwljFZzWalpW/iWkx6e9PRrFJszdGFeod9c5Ox+LjsFFEuJSu7OnkCxyOavLwW/MYtAetCL2T2GMQEICwj3g1N3ylwqW4nBqZJfZ3MlqFtdIQd1No9ADQgTxWVergGJWl5Iz/ypj+4klFO4ung39h7L50QPdUkIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bx5jETt2cNe8qJfaNnd5JBE2Yl+wOnbhqdRVzO1iu78=;
 b=I+MhdrqLlE8nDVQzAwmkET1ENFPw6eauqbc87RNpPiQiehVB+rDkhVAOy5QngbmvWnxdHlDOTBu1VSWmK0LcJvh7s83EG2V0etfP+uI4lcTBpTGbVjpYYbD85nmE+pXGSmccPqRmo4ODo5H+gQi/pd1Z+DVfCrON2ZsWwKKFtyW7aGnwzJB+c5+qOvq7zeHW9n2r2skH9ZO+Wp/T0Mx6BeYkfsu8Wrt18RTrgGDuF2uuNyqS0s1BtMQmHQtIgJ6KqArZK+o0K/YMYW2CBFZHYRY3adiM/6BSkJyyEVE6qQRpFg87QVO1V1Ry1SthTwJaoLunxsHcOaDnu664NKzLhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx5jETt2cNe8qJfaNnd5JBE2Yl+wOnbhqdRVzO1iu78=;
 b=q4AgMjr0RxI7Xd5y2H9lawEX+jJywjkwli6HDEJ1+B6KAVuUhlnhmjfMZhvcL4BgLjgxUgEfDTO85WM2AFz2oWa/v4KLDgwySyktBg+l6i7XBTNojkGNlKLJAjK2+MCbZnmNhmqT3liztBlHm7S6iLl8xjWC+AziGP3HNu/mM+8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7941.namprd10.prod.outlook.com (2603:10b6:408:1fc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Thu, 30 Oct
 2025 18:03:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 18:03:44 +0000
Date: Thu, 30 Oct 2025 18:03:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
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
Message-ID: <b1115232-01a8-4799-9ea0-2d6f8fd95a62@lucifer.local>
References: <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
 <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local>
 <e2a89e74-1533-4a83-8d0f-3f4821750e25@redhat.com>
 <64b9a6cd-d2e4-4142-bf41-abe80bf1f61a@lucifer.local>
 <dc002ef9-53ee-4466-b963-baadfd5162b7@redhat.com>
 <a97780ab-6256-43b7-8c0a-80ecbdc3d52d@lucifer.local>
 <2d8ed924-6d06-42e4-a876-381fb331f926@redhat.com>
 <3d6c013c-5592-4bb8-b438-e29787b1ab48@lucifer.local>
 <CAA1CXcCtrgCqYg+WzJv9ZJs1FKcpRWLy3QL3T2E4_5m-CRT9zQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcCtrgCqYg+WzJv9ZJs1FKcpRWLy3QL3T2E4_5m-CRT9zQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0459.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7941:EE_
X-MS-Office365-Filtering-Correlation-Id: bc7ff69c-6d6b-4f1d-9c40-08de17deaa2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekltbEYydWJQVXRmdVNPbUxKcW9hMldTcHR2L01xaEkrR0FpT1FGcVFhbURX?=
 =?utf-8?B?bU5aSkVScE1lQUg1SnUxR3JYVEhaQnhIYWg3Snc4bzAwaDFxTmxyRCt3emNw?=
 =?utf-8?B?L3BpQXJGZ3RLTk9RWjlzZVdHRndsUlJBd3ZyQWF3K0ZheGc2YjNXMlBxZXYr?=
 =?utf-8?B?QlNCdm5pTFlMWEs5NXhodC9CTmJFZ2ZDQWpqMXI5U25Rc3VWZ2QybGJWNzYy?=
 =?utf-8?B?SVRkLzg2NlU5TDBuekxNYnNPV0lOSlB0SmFNbFAyVXFuYlZLZHA1SXFjcG92?=
 =?utf-8?B?MjR5UDdQT3FBZ0oyZzdTTHAzYytzSjVZd21DendOTUttM1AxSkJBNld3Ui9Q?=
 =?utf-8?B?M2dnWHNXck5SQWpreEtydThhL1lFMDZhS05wSHBZNGI2cE83ZnVxU1NsWjhC?=
 =?utf-8?B?TUpvekRRWlU3bngwTTdQOGMrUWZFdFJPZGMyYUhEUk1ZSnUvTmhsbHlnd2pa?=
 =?utf-8?B?VEd5MmY4R0I1a09GUGxlaHplVXpkZGpkbEdPVTIrVWUrYXBGV01acTFJalpI?=
 =?utf-8?B?MWFsSHQvMndjOFFoNUdkMGRBOU9xWCsvTW1za1VSRTNSQ3hsUWFxWjM3aEF6?=
 =?utf-8?B?czRhbC8zNzVRL2s5VnZ6SVBNbHdvK0dYeTJKcVg3ZnNEclNrb3RMK3ZjQ1ow?=
 =?utf-8?B?OUE1S1JENWJ4ZW9sbW9CWUt2d3ZRTzM5Q1NBQ0RDM1dvRW5DR05aQXg3QTZr?=
 =?utf-8?B?ODFLSkZveEJCd0RJNENvZHU3K2FkbDhYYjhYTngyc3lKWVVzZ2oxbXNjdjZu?=
 =?utf-8?B?S1N0ZXVHVTcrWTgvaG1LV0pUdDZIeWdnS3hjNDA3QzFyOFovcTZRRnhua1ZK?=
 =?utf-8?B?K3QzcHU2ZVN4YWhmY1JDWmNyYytUdlR3QXVLQ3dUczNkQmtaazdWNGNBL0h6?=
 =?utf-8?B?S0dWWUJvMjVrUmY2WmVEa01FR3p3bE4ra3NJNG9YdDhDWFhscFhHRTNzbVcv?=
 =?utf-8?B?amE0RHBlbFA0VXJ3RHhndUJaUzNEanF1OHJoeVpKa1JYdEY5TEZ2RFQxWkhX?=
 =?utf-8?B?NGMyNTNWL0pqRDZyWXdObHNySkhKMVU1N0NnTWp6aUs1ME5sTDh6SmptYWQv?=
 =?utf-8?B?cEpERmw0eVk2aS9XQ2NSQXZjNzI0OVR6eXRsUUN0dE54Qzc5S0JRRkVwb1cr?=
 =?utf-8?B?UDNSTVd1YkkzdUFXelgyMXZhMkdHakRhTTVVUlBzZ1JaVWl4ZWVUTVpsVEdn?=
 =?utf-8?B?cmIzZGRvaEY5aWNtaXhKdkFpNC9LVEpiSWg5NVVzR3ZscWszNTF0d3hRZi96?=
 =?utf-8?B?dmdrbGtzSVNoS1cvVlIxWUl3QUtXS3Q1MW1OZGd1V1Z6RW1QRkwxUWRLcGJE?=
 =?utf-8?B?NjZ2d1NlOGdqUmdNRzB0Ui8reThmR05kZ1RqM3BFRVlwT3JYL2dFMXk3S05T?=
 =?utf-8?B?UnNKWXpnd2JGVDBFRVhZZzdLTStYUTluYlo3R2FON21HZTh2cW9ubmk1WGtw?=
 =?utf-8?B?VjJ4WW9iR0s1NVFyNUZIUk93cmovNnpVWldtWSszSkkyczg5ZTR2bXlBampO?=
 =?utf-8?B?QU5ScDJXOTBxUFNHenV2YkRFTXhkNWFTNGpLb1NZZmVlMFBZN2p5bVc2ZFZi?=
 =?utf-8?B?NXQ0OWFQV0ZyVERhdnE1QkRFTWZoOEFyV25mSTZldlBFMzlmd3RReEFvQjNq?=
 =?utf-8?B?OWFMNVpDeUFlT3BJck1QVVZrQ1VMYXN3ZVlZZFBBUDU4R0gvSElxMlNJajBj?=
 =?utf-8?B?S0Z4cEtPdFRuV0s5WUFaZHh3NzRYZWJ4ZU1BUkV3YU9mTzBGRmhqb244Rk1z?=
 =?utf-8?B?R1c2UThzUUp1c2p6YW00dnNpRHhiZHp1RzViaDhWQUZ3UnROQi9LWXp2bmZZ?=
 =?utf-8?B?T2ppQTJxbnRsd3ZYS0xpcVJnL3JqdzlZNkdEMktJU0hXRUo1dXJSMm03ZW44?=
 =?utf-8?B?YmU4S3M4UHVrUDRMVXNSRC94djFvaWJnQWg0aEZhWkZGNzl5eVJ5NWVTaVdC?=
 =?utf-8?Q?fdRBCfiLVezMYEHTe+Z4sb/f0aJrtmkQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHYzNFQrM3drM2FLaWpIN2lNaG1tb2lORFdBSFQxeURnVjQvQWl2OU1QOFc5?=
 =?utf-8?B?ZXI0dVFqS0pMT21pUU8zTE43K0VvVzMwTmxpSDdIbGJ4WkU1aDYwVTJHczBz?=
 =?utf-8?B?Z3dlcVpmd0l1QW9YVm9tSWc3TUQwM0pnMkV1NlJLRGEycWJmSkh2QkNhRm5K?=
 =?utf-8?B?cVMrNERNUzMweVpOeGg5UHdQQjJNYU9NZHE1YnZ4RUF2QlhhS29GbnFIRnRy?=
 =?utf-8?B?dVV4MktlWVVzelg1QnpLaCtiVEtmWEVrOVhPanlrMTJ4VlpJVWlXRWtzdVZw?=
 =?utf-8?B?bGNmUjRSd1J6eWpBSmtxdGlPU3hjV3NxRUhUdEhCS3ZFQStwTElINlFoVzli?=
 =?utf-8?B?K283bm1Xem1hS1RZSDlvWm5GRUpXbmZsWFlFNmgxVjlQVEVHeXQ4T1BVTnk1?=
 =?utf-8?B?K2dDVFkzd1UxVUl0L2huSkh5T0xzTkVuSkpIVTBOc3h4UVYrYUtvTXBFd0Nh?=
 =?utf-8?B?ZEJDblRjZHl5K0VwMDhyMjFKbVF0K0VLSVduUWJyc0pSNnpYMUR3K0NSL3dS?=
 =?utf-8?B?R1FvclJOYU53VjN4V0x6dW9Nck9CbE5VVXZ5ZzhhQ3dxcWFFdDF4V0ZEaHRS?=
 =?utf-8?B?a0VUOFN0Z2JPZ3dkKzJPejloK1gvOEZqYmluOUh5R0JtNUpwNllsQVZSR3Vu?=
 =?utf-8?B?WkxKTXgzdzRLQnZmcjJjUDdYcXZ2bkl1cmxGd3ZTWWpwZ1kxbUpoRkFYVFFZ?=
 =?utf-8?B?SzhpbEFIRDJ4M28rUUJJNlU1cnlXNjlOdzNWTmR3NnVuNXJQelFZUTJtdTVm?=
 =?utf-8?B?T0JVL1phcTR0ZjFXVERxVUZzK05DRXlhUXB5OHlwaFR0ZlMyM0h1RVZMS1g1?=
 =?utf-8?B?YnE0TnJNMVlWRVlYS1Z3SDlZNU5IblQ2eHNlNERicDRqZTMzOTFFLzVodE85?=
 =?utf-8?B?OWRkQ0NVOWZqcjl3Q3prSzM0THh0Q0E3RWVKdmxxMGk5ek9JSnhDeGgwK1Vp?=
 =?utf-8?B?MjN6MHY5dDc2NGd2ZU82SkdMMGt5Z3lPLzBoYkRTa1BwWDNKT1lhUXlZN05E?=
 =?utf-8?B?SGZJaG9TeGRpMjBEUlBMZURYMTFoRENFUmQrdDFDRnFKamVEM0NWZmNiejZK?=
 =?utf-8?B?Mkc2NVNZWmt6bnMvVTFlazlsUGJ1R3YvZVZiUEdhZHBlb1A1Q1ZmZkNabjBa?=
 =?utf-8?B?MWQ0UmRMcXV4UndxR1IrUlZmMGdlczhyTzhGc0JHRXUrUFBuLzZsRzZSdmJQ?=
 =?utf-8?B?bndmcm44YWRXSjRzRnUyMTdhbTk0QnVOYjNzbHpXSlhxcHk4TFl1bmx1Yk1Q?=
 =?utf-8?B?dE9NRTM0OW9QOUlwT25TeXFZR3N3RmZTbUwybExmaEE5UGt3bUExeE9qTU5j?=
 =?utf-8?B?L1JVSi92UTRRb2lEZlFCTlNPcC9zaGRPVFpYVWdYYTdmV3V4MFd5TXZScnZv?=
 =?utf-8?B?empJVWZ2M2hDM1JCVUI5ZkNMWHZwR2dwV2NJSTZEOW5pcFRQM3ErNWtSb3Zn?=
 =?utf-8?B?c1d4Z2VIbGducVcvVUNiVU5jNDJDd0Jzbk44aWc3WjdrMUczSGtVbXBRYm9W?=
 =?utf-8?B?cm1TdUNZaTBKeklxOUxEVVErUjZRdUdEU2pxOTNHNGJ6emtBTnZFWDNMSXNt?=
 =?utf-8?B?dnNLYiszS3A1YnVmSjhsTkcwMEk5aU5DdlV3RjBXNlhmM05PZFFpTWpkR1FC?=
 =?utf-8?B?SHdsSWxUN2VNYldHQ2xLL3JBN0FqaU84d3liTC9sdE5MdWJGU1o0aHYyQUJh?=
 =?utf-8?B?RWZQclNVVitzZDJsOHFLV3FZcFN1SkdBYlhaYnhvbVZ6SUJsbTB6SlV4RGNX?=
 =?utf-8?B?VldpK3dwRTQ2MFN3TE94b0U5S2ZvdWt6WkhnMVVOai9YVktiK3dOSUhLYTdH?=
 =?utf-8?B?MnZ2bGNkWEVuRDlDUHIrSTQ3YlZ2SUIzUDlaQlNYcTlENHhpS2NxNU1vWDE4?=
 =?utf-8?B?QVo4aHAzS1NJS0pPVnduVTc3V3dSenVEN0xCUC9YbjhDTSt5M29LcDFxbUJN?=
 =?utf-8?B?T2RsVjFXNFo4VTZoMkdKSTVFNDVobE1rbFBHUFRWYzVQdjZiWVl4QWo2cGxH?=
 =?utf-8?B?bEp0N0w4bE45VS9jS0RIVEpldU1XeERqWllnRTBJV2w4RTFpZHoyOThOU1Rx?=
 =?utf-8?B?NVlxYXN3cXpRVDJPTVlDVnBKd0NndjFvQTNGTlF0T1pGNFBGZGdZQy9SbDVH?=
 =?utf-8?B?cDZPbTNyeHZ4ZzdPdkxZL3BMV3dtRWxET2x2emxCY3NCR0ZFVFpyNDFxbGFH?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EIAEL0u9ocKa6LD9Dr/uDM7zeAsMY4hLsvgJQWkyJEd0Q+FauR7F1qjy17iqV9++GYJsF48pSybr6iDiiljA/4DcZ134SZeZ2XMKkEKqswlHbs6/3WKMzk0aqnHn6wxO0eN1L4gSubhOhk/cXelGEWkE5Cs6FpDlXe3HqpmSZhcbEvBfowJ/J/8BKxFaZNzeFhrtJCIOM7AFtdF3iaVfIDn+8xQByRyQQpT2i+lzxCuc966j2IDnEqor5pQYGd2Jx9oo1a7FTp8e8xvC21KKr1j2dMJZf7IMXJ5FL8nYMGJ6QkT398Tfu99uqhunw47hrKP/vF4s/LqENxP8D6/rh3Zzmvgwg78kplfhTzxeryKKizAGuQ+GQFvRtYFM4iOyHv+kPFTuHMnhuX7lNdatVdDgh7zL203UZWYXkbhmuZV7GFeZZa49rzr0ldnC+XSqs0g5rQyjXqoT6TudWPKa79jXTWllSyMNc1N89CwBmc8rSUyDHAhhCI9AgKGGr87unBdLQZLU3LQ5Qrm79dJIUcACKMnDn2QFApscWKKPrzgdikBjw5ffKnyOxgx/CC4PPVB7ARh3yhGWSQUFIWe8ewr7aabMymnpHw3siZtCMOU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7ff69c-6d6b-4f1d-9c40-08de17deaa2d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 18:03:44.0288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQTypVoGUsG2eL3YEl8fAxbKafn4OV2PoS7KW4YkQZNcZHm8J31pXvYSyE9L2QXXGxpadr9lOdBu2nlz6LZIl2KfZdq7Wf4jhl5gX0eUhks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7941
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2510300150
X-Authority-Analysis: v=2.4 cv=MYVhep/f c=1 sm=1 tr=0 ts=6903a88b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=pEr0iLtFLARa-EweITUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDEzMCBTYWx0ZWRfX5z3+9nuT2LGy
 sZuTsmyxoZM+Rd2yBfD3zIhgOiNPcxcvYS52oVymDxTHWT5paE6vVQm7MRESBsKbtlAe0Ki8dDM
 fkoXWmQ9dQIhaxlPKq4A5RHxwjvco3r0iNY2uhQCBqawTIR9YIblpl1GLAeY6SKZsVhKRKMC6fj
 dKvnhU6NhbF6AWsYkYyxu3OG6/xm/sQe6vzQuiwghvh2y7WcB/gRA1onNpVsYsvv7PhlWSF48ZR
 fbZpT5iymDy6V3VnD+HYwQykfDQRMfQtYXtSHZ67eIlvGbx6sM2zIqir9Qfu86ILrVMU05X2bz3
 OdNEKB6fjOY0YCrhW8RxtFNaotrouAEcymTq8UPgtvSpy/+4B0dufmQCUZmY3MaLWt128L/Rt1G
 ujDP8XuJL2aBQ5JnjEgxDCELyEu9JEnH0yxjmCUm3gouD6Xu+Ds=
X-Proofpoint-ORIG-GUID: xM5qWyG5fC5jEVDnvfVA6aFeK_hnAZp2
X-Proofpoint-GUID: xM5qWyG5fC5jEVDnvfVA6aFeK_hnAZp2
X-Rspamd-Server: rspam05
X-Stat-Signature: opw1pnqz5pfmyp1thonqcqux5swa6h1g
X-Rspam-User: 
X-Rspamd-Queue-Id: 60408C0008
X-HE-Tag: 1761847463-815228
X-HE-Meta: U2FsdGVkX18I+igbeD/adhM2Yq5hTpuq/rK+su+AtW8O9cs6G2agfdnyvn81+gkUxLW4SIi7g4W9YM7nCaB4aOM/1BzdQn1oluCIIx7jdFcZuWVwC2otIifqrMGvHEovEpoWMByG0WG/i2rVDE4r5Xl322vjviJdjw+HNpxDcPpEIjiKiTdtKedrUMzlHxMnV9LGLzfXYGDoHlnCIACtJCks2eDPk3iyN7gVCEC5WwyEqMNB5HKnuugaSI3P7jbZ4VBJdMUjQiQrUMJG14YwSuFoDFwXlN53/xQdJNe9RuN3+ujDmVRKUuFnnkN9JPRDfrF26acy6uJ25tP+xaKBHLeet73695j49tuQ9eaxlldMKxd2fboplz3OhG0MylRJCzjlu5k4oGbwRzlesLeu6TkKaEkRKGM/0lTIUGfGzDKwTOY7bDtjSXKWJQPYKN34ES9Yy7XrtSnJcDvYybKrdPwLZpXz48yk2L478tjhwVOvvb07L2ur8IXKo3Ma3G7rqJZN7PzP1Yl9XafQ/VvHLc5nDARK9oVge00AKdfQYEBFG7q39xhd5CtQhFvtss34+tY5Q+tr1Bg5NHVp1L3IAvEhm1u0TijjyrH8jZgavWLQTovtox8lMs+SKIqa4rtJ+8h32z2Jf7EU1XCn5Hx3/gsXYiajFua2xRpGvAjCiQNR24iqG2DPHNseyNpa4rs9SFC5t24H8I9Rl2T9m4Nmr4raT72+53bjlGi6QcF7iSfHrQA9rK9/Ci0MZR+vAIiH1h66oB7urxwyRbmxzqMCwSFkztaKvvyxHnoH27NXgaqZ0pYeOvACiml7jHApDtc2j4/7FoQz5Pzl3NMoOY+pJw7t8PNSdWQhY9M04RxkrYTPIVdHbpro03NzzHU2z4M9Sxtr8p5hcEi5sNm+W/W5xcCDFj34dtz+/oW74SOUe/9Tst/jDqFFIMeP9URyaAlkhhB//CoFvp8pRw64Wix
 bIC5HB5w
 XklfDuycurzUS6nYtCMfz5eOqnAMafCjGhJEC5xZdVu8tblU5JYEGSCL4t+QzFkyvm5EVXhYI2dFGjhKZNodC4EmF5eE1Y6dzq7vaa1opDirjLFfl39IDu1FsqmfIK/J2eOZxPFC1EbLXBvy/hWH5SITC12YnCP1z5l1wrtzGifyB7WlpwgjWWc5KDfsC/RkgOFahstcgEGLNC1hwKbk+HZEyCW1dw00en+gpIGpcQODRJ2SA7k2259mts5xixovtYlKXob7hyQPa+Mo0BGXSZgw/CazUKMob8XN0JDJKeFA5Krbtw+V7xhzS+qRcPpYQiE08q3zwgZez2YTxGAqjrB/Lb4h4rhvV7IBhzdrBJPDlnnpGRIXvofO9vorvyEH5cn3jt4jsB076cLmQmzujF7deObVP9n3Vs4YvaasBf5HPr2CWQOHfl5Sqj+8sHYlHjagK/G88UllI5QX/XRisBbCroMfbF9m3u/3qiGgTm9A9mswPDkxYsDuq3EO6cOwkzh3glsXxKsOU8J+v3aKGJBd6ySiegA5Sv9FkejlaxuEJe/pADcQbGe/CoxW4wv5Ah8SAYwMyk8XAXklNuIFn9hbrfEnEWybvDgIanf7P4KLR8Ht3OJKFlKVUTI4a60+rGjr2qgauhEaLHAPyNTD2yZCpMVUM9xaWS7WqeaQE5decXQMsOk2VFO9fXtAR3M/2KnKMKcg0EGpOX43pyBQ2HBIz9ndhMK34ow5AMsKAmm1RqiQWOdlIVEKcEfCzpa8QfZtSxprHP1iX7jZlqaVlgrd4tu6MImgwrBts
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 03:10:19PM -0600, Nico Pache wrote:
> On Wed, Oct 29, 2025 at 12:42 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Oct 29, 2025 at 04:04:06PM +0100, David Hildenbrand wrote:
> > > > >
> > > > > No creep, because you'll always collapse.
> > > >
> > > > OK so in the 511 scenario, do we simply immediately collapse to the largest
> > > > possible _mTHP_ page size if based on adjacent none/zero page entries in the
> > > > PTE, and _never_ collapse to PMD on this basis even if we do have sufficient
> > > > none/zero PTE entries to do so?
> > >
> > > Right. And if we fail to allocate a PMD, we would collapse to smaller sizes,
> > > and later, once a PMD is possible, collapse to a PMD.
> > >
> > > But there is no creep, as we would have collapsed a PMD right from the start
> > > either way.
> >
> > Hmm, would this mean at 511 mTHP collapse _across zero entries_ would only
> > ever collapse to PMD, except in cases where, for instance, PTE entries
> > belong to distinct VMAs and so you have to collapse to mTHP as a result?
>
> There are a few failure cases, like exceeding thresholds, or
> allocations failures, but yes your assessment is correct.

Yeah of course being mm there are thorny edge cases :) we do love those...

>
> At 511, the PMD collapse will be satisfied by a single PTE. If the
> collapse fails we will try both sides of the PMD (1024kb , 1024kb).
> the one that contains the non-none PTE will collapse

Right yes.

>
> This is where the (HPAGE_PMD_ORDER - order) comes from.
> imagine the 511 case above
> 511 >> HPAGE_PMD_ORDER - 9 == 511 >> 0 = 511 max ptes none
> 511 >> PMD_ORDER - 8 (1024kb) == 511 >> 1 = 255 max_ptes_none
>
> both of these align to the orders size minus 1.

Right.

>
> >
> > Or IOW 'always collapse to the largest size you can I don't care if it
> > takes up more memory'
> >
> > And at 0, we'd never collapse anything across zero entries, and only when
> > adjacent present entries can be collapse to mTHP/PMD do we do so?
>
> Yep!
>
> max_pte_none =0 + all mTHP sizes enabled, gives you a really good
> distribution of mTHP sizes in the systems, as zero memory will be
> wasted and the most optimal size (space wise) will eb found. At least
> for the memory allocated through khugepaged. The Defer patchset I had
> on top of this series was exactly for that purpose-- Allow khugepaged
> to determine all the THP usage in the system (other than madvise), and
> allow granular control of memory waste.

Yeah, well it's a trade off really isn't it on 'eagerness' to collapse
non-present entries :)

But we'll come back to that when David has time :)

>
> >
> > >
> > > >
> > > > And only collapse to PMD size if we have sufficient adjacent PTE entries that
> > > > are populated?
> > > >
> > > > Let's really nail this down actually so we can be super clear what the issue is
> > > > here.
> > > >
> > >
> > > I hope what I wrote above made sense.
> >
> > Asking some q's still, probably more a me thing :)
> >
> > >
> > > >
> > > > >
> > > > > Creep only happens if you wouldn't collapse a PMD without prior mTHP
> > > > > collapse, but suddenly would in the same scenario simply because you had
> > > > > prior mTHP collapse.
> > > > >
> > > > > At least that's my understanding.
> > > >
> > > > OK, that makes sense, is the logic (this may be part of the bit I haven't
> > > > reviewed yet tbh) then that for khugepaged mTHP we have the system where we
> > > > always require prior mTHP collapse _first_?
> > >
> > > So I would describe creep as
> > >
> > > "we would not collapse a PMD THP because max_ptes_none is violated, but
> > > because we collapsed smaller mTHP THPs before, we essentially suddenly have
> > > more PTEs that are not none-or-zero, making us suddenly collapse a PMD THP
> > > at the same place".
> >
> > Yeah that makes sense.
> >
> > >
> > > Assume the following: max_ptes_none = 256
> > >
> > > This means we would only collapse if at most half (256/512) of the PTEs are
> > > none-or-zero.
> > >
> > > But imagine the (simplified) PTE layout with PMD = 8 entries to simplify:
> > >
> > > [ P Z P Z P Z Z Z ]
> > >
> > > 3 Present vs. 5 Zero -> do not collapse a PMD (8)
> >
> > OK I'm thinking this is more about /ratio/ than anything else.
> >
> > PMD - <=50% - ok 5/8 = 62.5% no collapse.
>
>                 < 50%*.
>
> At 50% it's 256 which is actually the worst case scenario. But I read
> further, and it seems like you grasped the issue.

Yeah this is < 50% vs. <= 50% which are fundamentally different obviously :)

>
> >
> > >
> > > But sssume we collapse smaller mTHP (2 entries) first
> > >
> > > [ P P P P P P Z Z ]
> >
> > ...512 KB mTHP (2 entries) - <= 50% means we can do...
> >
> > >
> > > We collapsed 3x "P Z" into "P P" because the ratio allowed for it.
> >
> > Yes so that's:
> >
> > [ P Z P Z P Z Z Z ]
> >
> > ->
> >
> > [ P P P P P P Z Z ]
> >
> > Right?
> >
> > >
> > > Suddenly we have
> > >
> > > 6 Present vs 2 Zero and we collapse a PMD (8)
> > >
> > > [ P P P P P P P P ]
> > >
> > > That's the "creep" problem.
> >
> > I guess we try PMD collapse first then mTHP, but the worry is another pass
> > will collapse to PMD right?
> >
> >
> > Whereas < 50% ratio means we never end up 'propagating' or 'creeping' like
> > this because each collapse never provides enough reduction in zero entries
> > to allow for higher order collapse.
> >
> > Hence the idea of capping at 255
>
> Yep! We've discussed other solutions, like tracking collapsed pages,
> or the solutions brought up by David. But this seemed like the most
> logical to me, as it keeps some of the tunability. I now understand
> the concern wasnt so much the capping, but rather the silent nature of
> it, and the uAPI expectations surrounding enforcing such a limit (for
> both past and future behavioral expectations).

Yes, that's the primary concern on my side.

>
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > > max_ptes_none == 0 -> collapse mTHP only if all non-none/zero
> > > > > > >
> > > > > > > And for the intermediate values
> > > > > > >
> > > > > > > (1) pr_warn() when mTHPs are enabled, stating that mTHP collapse is not
> > > > > > > supported yet with other values
> > > > > >
> > > > > > It feels a bit much to issue a kernel warning every time somebody twiddles that
> > > > > > value, and it's kind of against user expectation a bit.
> > > > >
> > > > > pr_warn_once() is what I meant.
> > > >
> > > > Right, but even then it feels a bit extreme, warnings are pretty serious
> > > > things. Then again there's precedent for this, and it may be the least worse
> > > > solution.
> > > >
> > > > I just picture a cloud provider turning this on with mTHP then getting their
> > > > monitoring team reporting some urgent communication about warnings in dmesg :)
> > >
> > > I mean, one could make the states mutually, maybe?
> > >
> > > Disallow enabling mTHP with max_ptes_none set to unsupported values and the
> > > other way around.
> > >
> > > That would probably be cleanest, although the implementation might get a bit
> > > more involved (but it's solvable).
> > >
> > > But the concern could be that there are configs that could suddenly break:
> > > someone that set max_ptes_none and enabled mTHP.
> >
> > Yeah we could always return an error on setting to an unsupported value.
> >
> > I mean pr_warn() is nasty but maybe necessary.
> >
> > >
> > >
> > > I'll note that we could also consider only supporting "max_ptes_none = 511"
> > > (default) to start with.
> > >
> > > The nice thing about that value is that it us fully supported with the
> > > underused shrinker, because max_ptes_none=511 -> never shrink.
> >
> > It feels like = 0 would be useful though?
>
> I personally think the default of 511 is wrong and should be on the
> lower end of the scale. The exception being thp=always, where I
> believe the kernel should treat it as 511.

I think that'd be confusing to have different behaviour for thp=always, and I'd
rather we didn't do that.

But ultimately it's all moot I think as these are all uAPI things now.

It was a mistake to even export this IMO, but that can't be helped now :)

>
> But the second part of that would also violate the users max_ptes_none
> setting, so it's probably much harder in practice, and also not really
> part of this series, just my opinion.

I'm confused what you mean here?

In any case I think the 511/0 solution is the way forwards.

>
> Cheers.
> -- Nico
>
> >
> > >
> > > --
> > > Cheers
> > >
> > > David / dhildenb
> > >
> >
> > Thanks, Lorenzo
> >
>

Cheers, Lorenzo

