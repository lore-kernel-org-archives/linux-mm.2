Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A01CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564DA8E0003; Mon, 15 Sep 2025 04:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C848E0001; Mon, 15 Sep 2025 04:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4036D8E0003; Mon, 15 Sep 2025 04:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7698E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:57:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0DBA1604ED
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:57:56 +0000 (UTC)
X-FDA: 83890882152.04.50E5B8B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 32B164000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:57:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pU2PinpG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lskQU70m;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757926673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDTsBFULdsL9ll9vhNtOwD+jbBYvcLo4qNhlg10N3Pg=;
	b=jaF1qxtdxFoGhdDDKsH2WdWE/eqDZjAROP9A2BAikkbgT6bu0t0PG6h/AnH5WkwSzn6WUW
	cXKxtMvsQ4H1ksuQDMOz3rvpqS8459QuR8XNEvgl7mv2GUDZYHW5+tAjP4NsO3HKbX0jMC
	Avz1cUAamTm456wl22/0xJW6gyyoFRg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757926673; a=rsa-sha256;
	cv=pass;
	b=2bx/4etED0nv7NeJ7Qu/5SMT74KNsAX3tnXlrc+THmvnEWMf+q6hJuftpkf3WU3cpKi8B8
	Pj8/cH2fDeKOEW9eWQC+dErn8RdQCTnrJxR3XIIe7fgEabPvnxgavru/fUYS/Zp1IagGLZ
	2NNtdTr6+NCVkG+oy6yocBbGI1GfIAo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pU2PinpG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lskQU70m;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6gRa7029894;
	Mon, 15 Sep 2025 08:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WDTsBFULdsL9ll9vhNtOwD+jbBYvcLo4qNhlg10N3Pg=; b=
	pU2PinpGhhj/4H/BLLkSDtmZwDVwsiXAj049wAlr1yXJCawZ+0ru9ktRJQurEzTL
	740xiOa9ORc3jLnOrRYC2Doumchi+FVvUIyquxqZja7YTjAcJLOf3fpylhwPbuox
	grZrMdkYWzAcI1HtQk/YxayHalXuPl1ctTw4jVIdIerCb3yDhn/mRa4N70gy7lJX
	uC/R2QxMY6DU/mo7656hvDaV25iL6JUAN3lZ1n92XSBPZzu0r3iq/fL8gIZ5bR7E
	hXyMYT5y4V1bVv+oMkZtjSpJrO0Oj0DQZ/VGTKeNW5uncwxZzk9Lj+tGeXTGqEoM
	cg8slc9SoD2mUi/emQedrg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950gbhvkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 08:57:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6auUC011392;
	Mon, 15 Sep 2025 08:57:38 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010001.outbound.protection.outlook.com [52.101.85.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ar3xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 08:57:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XPUBQbi1cKGXZl8LSi4JppZVa7OgTkA0xs8bVnZgCYfsk9YKSUARJuQUJjYfp7qdhJo9BgznCc7GF6V7pktDEsiy75lO7AZWEfx0d3QRBHFcD38L0ldq+eBfYtO7F+9TLuA7Pafc3Hndb9IH1THgkX6tqP1ede1ney94uf404RhWgphaTRudZ5eeM2aJ8B1fvP+27YGIRKbii/Z6VN+KW6zCS0wj+XYVXbP35Syz30Ssai08aBD2e6YOZu86O1NSELu6U3wBwyw8klCr/autoS2QM//Nubl+6nGqda/OXRFP7JtIBAMSYiQSuva55jDpdB5wVGvINhUn9pIqbzDgyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDTsBFULdsL9ll9vhNtOwD+jbBYvcLo4qNhlg10N3Pg=;
 b=Yp9BadylrTpBljvYlepmv9/Oo6/bwr+TtKyR+tJpfu/S6ACLv7Aqf2fAE/AStu04oy+9ePEh9+9bA4DtE480J4SuSqWJ0Sv0IsuGg6DW3yqPrScPB9aqECpcOA8QDdysdHneIOBnrUy3Z/yFmcjFAN2OALlmug/Lb8dg72ltIX81dEPYE9QJiTu0dLjKzUvD5dCDpNXZX0qz7xg5wUTeEwWtZq+yhRlSq1m0VzLgzPAEGFq7tAediVjAP4XPdlMrTUV4e/mbr7HeM8q9fd31v4c+EVEuvnyICHukYQJIBIwzW3ckRJrMPelAxt2SqiEJ8kACYWbgSVYTNIAqrOR5xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDTsBFULdsL9ll9vhNtOwD+jbBYvcLo4qNhlg10N3Pg=;
 b=lskQU70ml6ySBQ8NZuuTkyEjyBmJitssuMoYuaxfWqo+Dfns0VwjFCDh4fbN1uxLHn5eVwtaL8CCCbAC4ry+NTw6VfGvsWeVmfo6uzXRBikjF8AfR/L7lPKKgpJiUZv+i4zL6D4x9Xl/snLGNXv1ZkYDOF2ErZF+TCwLPCafHD4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 08:57:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 08:57:36 +0000
Date: Mon, 15 Sep 2025 09:57:34 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
        SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <63627c5d-cf2d-45e8-990d-9727052b681e@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMdVcH7KCXBvLtFP@casper.infradead.org>
X-ClientProxiedBy: LO4P265CA0170.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 046bd171-2568-42cf-1c01-08ddf435eaa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTIrdWpOem16WTRyR1Frc2VDTHdLS2pYbFM3dkdLb0hyY2ljMUhEREkvQm4w?=
 =?utf-8?B?dUdDTGN4WDU3Nkh6eTQwdk9vNG5lTzNNdXYwWTd0eW9mRktQUzhicFYreGl4?=
 =?utf-8?B?VEZyU2VCL21yMmFMN1pVUklFaU1SK1BoSERBeksyODlpREwrRlFMK0JmaWRS?=
 =?utf-8?B?dVFJTktBSURXZSsrWXYzY0VLdGFiWHhyTHprMWx0MGZ2eFFLcXhqTHNwNDMy?=
 =?utf-8?B?Tng2dEtjbDc2Y25hRHVwR28reU1wc21OelY0elhkZ0NTaHplZlIwaDNGWUtH?=
 =?utf-8?B?NVJRVHJvV3kwempJQWc4UVg3SjhyVXIzeUc0YjBOLy9KaTdtckFucHVwZW5l?=
 =?utf-8?B?TGZmS3ZjczRva0lrdjVzNlhyNWZ3VUg1SW13YjNUVFlkMFp6V0paOThlMUNk?=
 =?utf-8?B?eHExQTFiaDFUTWJxb1JXYjYzZVJycldxdW9CbGhJNGRQbGIwdkk3K1ZLNHBI?=
 =?utf-8?B?SHNrMllnOGI4NSswc3IvaWYxd3dqeTM0RzhCZkFTTzBiUG4zRkhDSDliZFYz?=
 =?utf-8?B?Sit0eFZ0MUhid3pCOW9qVGZPSExBa1RLeUdUaDhESjZzSjJtQ2IyNmZRWHRr?=
 =?utf-8?B?eEdhbVNlVkk3WHpzTU5qVnpKeEtESndkSmJPQVFNZFFvWTAvUTcxYTdkZHFp?=
 =?utf-8?B?S3MzL0VQVGpjZnBLSXJNY2FEcmNTNVRwUlB3VktpR0VVWFZraldGZk94QmRX?=
 =?utf-8?B?RmlNUGN1S3dzYjVjeTR0bWZuV2JRSUIrKy9FY0tudExWZlNSb0R2ZktYRHVt?=
 =?utf-8?B?TUJPTDNNUk1IZ2Y1VDQwbHIwUVFUZDFiRFc2VDRwcHNIM203RHBmbTRDTVpi?=
 =?utf-8?B?NnB0WkxZd0tWZ2paTXRxNmIvMGJCZCs3VDgwaHJwOEVPYldIYXRnektZWlVn?=
 =?utf-8?B?d2tXbDJwUy9zV0tmU3grWEgzN3ZxcG5Cblh0dkhvc290ODl0cFVVNjU2SkVF?=
 =?utf-8?B?cXVxeEJzZ2s4Q2JXTTNUT045NHpVclhYRnhHM3lvYkpmUmlIQmVra3pUVTcr?=
 =?utf-8?B?NHhOOEVVbDRUdXNHQXkvU0UzZmtHcEtURnNkM2NzemN0bVp1eCsxMkM1cGhE?=
 =?utf-8?B?UU1UOG81Y3ZXeVVhLzVoV012dmZJdnNEMlZZSW5LSmh3NVZFaUlWb3FiamNX?=
 =?utf-8?B?MFBLSXBWZll6TDZ5aWp5Rzgydm1FSGMwamdQaUpTY2FPMmUyOGZQTEhtcE1Z?=
 =?utf-8?B?cUtWTmFwTXZEUTVuT2c4SXV3UFNUMzAxSnV5Sm5OQ2VwdzRWenVwSUVNQmhj?=
 =?utf-8?B?czNIL3RsbjJkS0o5MUdIa09yV0Q1SzZQbDFOckpoNkVkYVdPNmV3ejZXOVo2?=
 =?utf-8?B?TjZJY2FDM1lTbHZFREhDbFFGWTd2MWlSRnRHY2J1ak5CZElGRWdyeTMzc0NY?=
 =?utf-8?B?a2dTT1ZjYUs3cTJDQ3ZRWFpSbXB1Q0lNbDZoZE51YWx5VEZKYzRnazEwUHBo?=
 =?utf-8?B?SStaWVY1TGZTQWJlZVloUFlsOGxEVUVKVVJURmlpOVh4ZkZQWVVSNElRY3E1?=
 =?utf-8?B?SHVmUy95U3VMcXdrMVVYdm5JTHFDeXJLdTVySko0cjlxdm1FcnFHREtBZFZp?=
 =?utf-8?B?TFBkMDdheXYyZmlIV2NZRWN2UHZWeGRTWWxOM0h4R3VoZDJMRDlXRi9ZRjJa?=
 =?utf-8?B?S25BZFltTzRFemJmcFVuTGgzL3BOY3YvWlowL1FweVVaeEc5Ri9yUEp0UzVK?=
 =?utf-8?B?azhBNVdXaml1cmNHbWJrc1hvOEV2cDc4VGNVa3pvRDhZL2J5NVlkL09jLytJ?=
 =?utf-8?B?SXMxUHlkcVRtdEgwRTVKYzJoemcxSzZNczU3Q0VkL1gxL3kwRmQ4RGJXenRB?=
 =?utf-8?B?N1N0TkJFVVExV1JNUTZZeEhYWXpPKzZwQW9vbVIwR1hVc0FRUTFUdWV6SFRB?=
 =?utf-8?B?L2tYVXZ0MVJYYWFtMmltOVBqNEI2aklqdnpjMGxKZDh5NEJqQ3pvdHhJRjNy?=
 =?utf-8?Q?zRtseOTyASk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZU1BMVF4dEtXWWZwV2c0RjAxdlM2R2dzbEZNTGExSUd2QjBBQXhCQ01KVDEv?=
 =?utf-8?B?dGNhaTEzekpmc0VqZHZtenlRNjhKeUZUMlhkWTZET3ZMV0k5OGdDOWRwNmhY?=
 =?utf-8?B?cGpHOU9Ucm00YlJaMEIvWlU1SzVOeXUwaGtKbHkyZGN4V0paU3gvRHZEcGFH?=
 =?utf-8?B?Njd6VmNLZ09OcnNRYU1YSEsrNk1ZbkxmakFRSDNoN012M1JYU0RtQWpORzJu?=
 =?utf-8?B?UGpOSW1sQ2NJUlduaEpqNGRQeVErd0l0eHUzNzRaUTgwWmxqd0RiN3hjUmwy?=
 =?utf-8?B?b3dZRmRCYWlnUFpSaGw1YmRQNVNtNGR2TzNGcW1KMzNWcWlHRHVDN2p0VTRq?=
 =?utf-8?B?UUN3N0dndDFUYjRvT2RJeW92eGZyZFVjR1JyOUZ6SzlEaUVGYitrZGxDMGtw?=
 =?utf-8?B?czhsemFKRVZvR3JkOGdZUm5yRnNWNzZZWVZBZ3ovbVk3YVI3TWJONm9sRHB5?=
 =?utf-8?B?d0hNcTc0SlpMTGwydzBlazBQcGRCTnBpd0ltNVU4SVRoVEQyTnA5Nk9vSUlB?=
 =?utf-8?B?SVhJRmQzQUJTbDhpRkNFeFhLNDh6UmdhUGtsL3hmQ24wRHFnMVhHWTVkdDdl?=
 =?utf-8?B?ZXkwZnlUb0JuL0cvdWV6cGQ4S21PKzB2NU45QmNWSHlKdjNJUEUxRkZUWTZs?=
 =?utf-8?B?WVlYWkFXL0trTm1RbFZHRExvVWhld0FuU2sxYnRIMVlYQmVVbEtZSXBkNXZ0?=
 =?utf-8?B?SkwyTC8xWDhxdE5WNTVRbWt3QzY5MkhTNUJOekpDdnhwRWcxQVJXenlKeTRl?=
 =?utf-8?B?K2dyRStDTkpCblQycXk2L3l0QUlhbVc4Y3hZeGRzU2U4LzZlWTFQYWlNUXNj?=
 =?utf-8?B?THlZY0x1bmxubi9LZkx6RnBNSWFMSVEwaWdheU52RkxKRUUxUWk4MThsMnV5?=
 =?utf-8?B?ZGxsVzVFTWRkWmE0VURrMmp2WFRsL2ZzZ09FbjR4TksxVmd1NGc3MEovRk02?=
 =?utf-8?B?TVFlQzVrcndFNlFVc29zNkh5dWgzOFU5SGFIeno1ajNiRmdSaUcxWHFEdExR?=
 =?utf-8?B?TmZmTU12R2lnSlRYa1A1Q3c4dlZMaXFDMVpIbXM0RDZUdWVjSy9KbFNuS3Q3?=
 =?utf-8?B?eGY2OVJBQXZLcWFIUm5FNFUreWlIQ0psc2hQclNVYllZMkt3OThvZlVpdWNQ?=
 =?utf-8?B?T3pKMlZaNCtnbWFHYkh4VnBNeUtBT3RXTnYyRXllUWFUeTRZMmNENDNUU2hU?=
 =?utf-8?B?VHUxR1dXaWZTbjdhUkkzV245UDVEN0NoblJ6WTU2STBuUDEzejhsZGNkcHRu?=
 =?utf-8?B?bVdoaG9QWlkxWWdrQ2FZS2h6SmtXZXFGR21nUTV6YjJXcVFHdG92Ryt5emdp?=
 =?utf-8?B?M2VGdmpzQnZFcVNNS0l1WGZmbDVHb25RcnlXaE9NYWNnczJGalVXR01IL0pu?=
 =?utf-8?B?Z29QNVNjVDRadld4Z2IvbjV6U2hqK2FoU3JubFJUT3VmVVZrU1J4Q2RIaWhW?=
 =?utf-8?B?aE5GYmxFcy9ONmNUelJrWm5WUzJWRGN2OUZrM0YyUXVNT1pEbi96QkRvenM5?=
 =?utf-8?B?K2FjWmFKSlEyV0d3YnRUZkE3UVdTckR6dlhiWkFjZTV1SVN0K3ZnTWs4TTM1?=
 =?utf-8?B?NC9pWEtrQnoyTEl0Vlp2UWVubHloemN0SlYydXVZTGd3bDE5TDN4SktuV09H?=
 =?utf-8?B?cGlEczlyNXM1UnA1WFlzSm9CTk9VQjFyNHM1emJMY1gwdnplUUQzdWhjUWtz?=
 =?utf-8?B?VHdyK2MwK3Q2UXllNkE0aG5TSGNHNjRTRHVCbUhVQXhYUmRUWkpaNWFndG94?=
 =?utf-8?B?VWRYakVBSWwzMzFSbmZyWjB2NXJvQ2FTaXFoNndjQkdZNjBiV2daSHQwOW5t?=
 =?utf-8?B?dTlzRjNVYllaQVorK2NuRFp1N1BpYldoZzl0eGMrYytTUXo4c2dkVE5zVVNH?=
 =?utf-8?B?ZkJ4RGFhNWVNaTVBaGR1Q3N1czgreFppRjg5SWs1L0FIWHhOalhIVkFrT2NK?=
 =?utf-8?B?RFB1SFZqWkpKaTVQd0YvVGJFSHFTQ0tkQ1VRZTFsVXcvSnNPV1lHelptbjNk?=
 =?utf-8?B?WG1tVUZYQTh1T0Exb1hqUXhOblhpRXM3cWNDQkhDNmtiTTVNd09RcEtBU1Zi?=
 =?utf-8?B?UENEN0g3V2huOHJlZlJwTjM2bUVRSFVZdStNR1hHSVEyd3FoZDI0T2xCVG5w?=
 =?utf-8?B?L0RjcXFib1JsWll0by9NSzl3dGUwbXNUWDB5eGRDbUhrQms3a3FpKzRjeU5F?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G6YtYK/ys7fsZhPk/rxUgj5uglR8ArRFAUbefbtrKe6Pib4HZOvEotMeLDQPx3cn8wOIaJKTGo+PRwPUrJ2fqJBOw/k0A0TJL3pzJ8cHkk2HwQEgjq1mNLmk2Bq88B9sNbTbI1TO5MEjrQmtN8taiPuNUV6aQ/JMRRmidGb06W+BqPPbmc/98ovro08rw00rIT1vcnP0uc745sFKOeoi5JIsj/3qWaFWvJRs6eP7/aCm4lx18AM4omYTxK7dvz1n5yUYj1W0ylAa009aibOFK7r5Y0K4PaJcUI5lic/YszSjQD7qifAsuP6vAupxYiHs8ANI1eyEa1DV7NAmJ3eYfsneWHZpkfZdzsrGK4QZkkSQ3dP/2VmBrjA28FCIK2rHAjINKMZmX0l/yMd3UAoQSJWqh4wOuqXAYT2R3RBbTQlsJUWjGQCQMcW06HXjx8znDDK125kFrNKrHRQzbQLy371ah6q7q9rrBQ1I35PC7sZPn4XcVNfA/MgABEOJWMZnZAgXP3pkd0hq0TFuHfJQDBGLw5rBUL6NguEN49+Y/og2o3Z8QFs8ig8hPOEUiJPOAczGWwB5gi3n25v6FfXxGL/KSMBO9JnTjx6g6lPzuIQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046bd171-2568-42cf-1c01-08ddf435eaa8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 08:57:36.4799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UprBXVWD1SM6x/UiEdo6E9TOrlU4PCsDRZJWb9VrAjb1GqURDUC4BqqnX0bKNuClsWBKQnAWrnRXBSdzz0/xYzEiVbfAvLurTb+ZyIt6e0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_03,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150082
X-Proofpoint-GUID: 98kwU9auqLV05x41qHpqTB1A6bCYmt8H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNyBTYWx0ZWRfX7evkhgHrPNBf
 Z4fhrC0j3cxjD75nVwl06byH8W/LqRbPlgxWa3c/1h9ZRTt0JjvMq+hpJCprtQFgXmnsIzECeEk
 O/kwQr12pMaGMnqqzamB2SB3KOKLsG5PQm4esiJxJQEs44GJ1BXBCeSZHYGWRiXn5y9tx3ttOEu
 dzsztyN/C2iYWsZzfIF5Hgr+K5xR5ll/Q5boO+QUBQJkDjJLYtU8G9gDoKGP99DfmUL03ZbIlZC
 GdOJwx4aicQ55GtJhmHPPYGZ0Qdk9LyfdS1WnzYe5ZAnkgjUBnEpGkMplECG2v/5nAwqUnDVOXe
 gjvn2ri6INVAEinea1vmrsfmCUGP5DQSs0ZARtJ4ZO4VbbSqVSxwf9kVeItiwCfwKr58751kyBh
 +MG5X64B
X-Authority-Analysis: v=2.4 cv=QIloRhLL c=1 sm=1 tr=0 ts=68c7d503 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=QNKOyIDa-BMlNKKRAmIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 98kwU9auqLV05x41qHpqTB1A6bCYmt8H
X-Stat-Signature: 9fjzhcy8hzrty78zyespwo78coui9qu9
X-Rspam-User: 
X-Rspamd-Queue-Id: 32B164000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757926672-567264
X-HE-Meta: U2FsdGVkX1/zYP0iPmnIUa9zVZ4GBWsSYxEYPAkwewwWZlQb/Gbg/KPaUYiLS4YjkXE1fVtUTgZGO2DvZIedOyaqEB4JuqvMJQTUCoFqU7oABgAvUuf7/NWMy4poNaG3+uawQ3Je8bbyjORcUEyfmArmtTwMpXzUMJfCy0RrTGjOep24rLvB29OCilrybXtgbRXbJ0qqeDRE+yJ2ShLE6aH1fD9OTT1MnpyhCV4EIGbcTuDy1KAWwdyoGN5dMkcEg+oRPRb5AXfIBg8zosE7L8B65rYmGQaQjjGnWx43GVfJIsfSV1vsZqeI97oQ6DzUl/MQ/pJL5/PTkOkY57uEXtOnr5cNKUwO7qjyge/6tc54UuE4zMIm0cQ87BGxXuS6rGTmay+fu4nbKNkpyNCIjsePgXG5XLimMVAznlgV2iC195UIBpitejaD7awhDkO+cEyWoTya8T0134d6Wzk9ZwtaGltRrscPIUefaT97Szg57xepY84UF9wes2N3eXu525sLov8dmGLqcZCj2WvIzsLqG8WSynD0+1D87wWVRvQ5uPOYHrzFc09XhXvk/gevT5weaXnMs795bkunO5/+JK1eM2e2LH1+VxPtXMmPQLJYxw+R55oTTohSjYDg/zp0VnDKYFFUqhrS3U6HNxfBM7nosJ7VqIjOZxqPyTHQaVk96GY4zjsiBoo98LFX65fyQx8Af5jkrfgnIl0o1g5lCjxw42SweYIGr9FM6qe0bmxA7O2SPqIpWy/BrzTJFSGMBZNI2WBfva8j3lJbIsrz7jF0RrL8n4XxWDLfqkuq6hEYuktxJwMxSPGP5VKP2I+jIzNnpAM44+7iVx3r3hcqpDn/lI0oIs34PptzJVOHc4vFZsLxGS1HjNiPqxHe90RyXaAGG131Vfu/gTgNZaV2JwTVtzk9cyFybnboAaPJ/T956S1eNfY919pR7YXVy5eARItPMwfyEGB2Fk0lVvI
 9lCFESQg
 0rdCuFoAfGDMXogCXV+P2ECwBx5dg9m2QcNmWMdj5FxxRN6vruzPfWbS0+exVGzBDeZgz2oasRqD+7e45jFzSFEd6eEPEXYrtzOBMzuy5p4IXQK/JvNNQaAh0Jm8C7GZQihN9ZrYSnzj3PYXDUajsZl2l3O3fuD3iq/XbBCfiOOyiPdMJo4pc/Hf9y32LqgMhU3THZEv7BD8hH5QIkCrBScwsLOIQazEIEjshoL2rx9UOeJAbVd22XrZJLqZ1lIlSkwKJlqd/1GB+3ITGNv7LKcIRFv0OKn8em/2aWwmBXPnUYKHLpoXtfq8PTCuRU4ICLOxxKuh7BheH222x2wn2Usx8xAibLIdJfAppBt/2Z+mcwUSXHMWlT6WNEDi2STRbBbhRl6OqMb69wrnZHATIkEdVc0mNey83KZY72UjzW/8a926bwt9eH0NUd2azWhJMAiLmw19HhZNsWuccsKVEGF9hFcwB/Ow9K33Wy3M9rrBnXHxv3pHHZPN+xGOnXw/XBAhWcwFfMdZDie65ZExlpfo6R/jwXb/dRujHUkGi7+CUohazhpGaqvURRJGJZIogr2dyBwgpJC2Ep9CKGO+PIer4vLVt/r56p4Ye4lVrtnxvvI83YuoSWEJUY1nTzNx5Oy8460sccLPlS8xYIGlO7Mp2R2cC7JWzFYDDRl5ydq9TPbFUV0b2m1SAZDOpYoaRp5pxHDI+q3sO8un2odbaxW+PZnz9Ky5WwNCyyeoU14v3Q0KOaObWCO2ZrhK1lhW1Trn5Nhn8i8HwdktP0DoOaHQreKBIqF9jrSsa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:53:20AM +0100, Matthew Wilcox wrote:
> On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
> > In the process tree, many processes may share anon_vma->root, even if
> > they don’t share the anon_vma itself. This causes serious lock contention
> > between memory reclamation (which calls folio_referenced and try_to_unmap)
> > and other processes calling fork(), exit(), mprotect(), etc.
> >
> > On Android, this issue becomes more severe since many processes are
> > descendants of zygote.
>
> I'm not nearly as familiar with anon_vma as, well, the rest of you
> are.  As I understand this situation, usually after fork(), a process
> calls exec() and the VMAs evaporate.  Android is different in that after
> the zygotecalls fork(), there is no exec() and so the VMAs stay COW.

Oh really, wasn't aware of this...

>
> I wonder if we could fix this by adding a new syscall:
>
> 	mremap(addr, size, size, MREMAP_COW_NOW);
>
> That would create a new VMA that contains the COWed pages from the
> old VMA, but crucially no longer attached to the anon_vma root of
> the zygote.  You wouldn't want to call this for every VMA, of course.
> Just the ones which are likely to be fully COWed.

Hm, I'm not sure how this would work.

So the folio->mapping would point at the zygote's anon_vma, which would
have AVC's to the zygote + the child.

after this call you have a new VMA that surely would need that same
anon_vma referencing it via an AVC unless you intend to actually CoW the
folios to new folios that reference the new VMA"s, which I guess is what
you mean?

This is essentially doing a CoW _and_ saying 'hey we are definitely
actually CoWing the _whole range_ in the VMA so can safely no longer link
to the zygote'.

I mean firstly I think the interface is definitely not right, I don't know
where you'd be mremap()'ing to and from.

I think it'd need to be more like an madvise(), one that you'd have to
restrict to a whole VMA.

But I really don't love this idea, I think we'd be solving a specific issue
for Android while leaving a genuine problem that exists in the anon_vma
logic alone, I'd far rather we attack things at a fundamental level.

Also I think figuring out which bits are likely to get CoW'd or not will be
non-trivial.

Presumably Google are doing this zygote stuff to take advantage of CoW, and
wouldn't want the overhead of copying data all that much.

>
> Maybe this isn't practical, but I thought it worth suggesting.
>

Yeah I'm not sure this is the right approach.

But you have managed to get 'cow now' stuck in my head ;)

Cheers, Lorenzo

