Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21FA2CF6BE7
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 03:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725546B0096; Tue,  6 Jan 2026 22:22:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CEFB6B0098; Tue,  6 Jan 2026 22:22:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548956B0099; Tue,  6 Jan 2026 22:22:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4059B6B0096
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:22:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D998DD1296
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:22:46 +0000 (UTC)
X-FDA: 84303720732.17.45DE36E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5275B14000F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:22:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="csNqFfE/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XvFDZS4X;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767756163; a=rsa-sha256;
	cv=pass;
	b=0hrpHS8XaISr4NgMw+f40SX+bdkR4yGPbhdRWSD6wgpYg6uebbwz1f3lsAM/94xI55w72m
	Bww4e5qB9/qUw3elEwD/p2wZEXH8JkwA13f15bydewqYNaK+KXmyHNBEHXdKC2OAqUFqJd
	HYJiiaoGBfzpFOzzVZqXnPUuupEmut4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="csNqFfE/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XvFDZS4X;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767756163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pn0QFlOT8/EU5UmtLmsLKlU16JpRMG6V3E93dxCjqro=;
	b=jMnYUrqbCZthn8bMXP/j/xI15SQ/eFJ42F9e0CZ/wi0IEoyK/jhHWquiaF6B5K/prLP15S
	Vmz4+6M6fkCe5S2PRHUHyKPLbmrB9uuM3gfY0qNBiAmysq7AxPje3EVCwbwxvbiKhfMhLS
	6m6FE/WuEjbljbeHmtDCjonzSqGqbqA=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6073AdBf1129389;
	Wed, 7 Jan 2026 03:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Pn0QFlOT8/EU5UmtLmsLKlU16JpRMG6V3E93dxCjqro=; b=
	csNqFfE/lSjdu7v//HSk96DA794seSNHm7x4K6pFBGhnZSPK4ACAVje4LF+LpAcu
	pM5RM60/Hl6HBOi4YGzSU3enDU/Ny1S6AcO2N7bMagAu0fZxTrHJDKbr0TDVpg3W
	w4tzgnLerLfma/zhh7BW/jAzEgFUf1kVQ3+uB+5i+Ji6JkbdrbPbrGaZWfL7CG6s
	bUKnLdHtPE2rv+RgB8cX9xuZB1lLJ760FRjn9jn1cqfoAeYH7b7JQr1gkUXC4sDB
	sctEBhFBrQ2PNIsQx/HEhngE8rjkeTPiBH7muSK87INAZNdB7GKBs+DqL2vqNG+N
	bt/Su8CClqgkFrDu8f+w9w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhfbrg0a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 03:21:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606NmoiE020358;
	Wed, 7 Jan 2026 03:21:38 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkc1ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 03:21:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hFWpd9mzcHi5CW+xIyBPoybyZTKplOSPnpVXbNjc2zvUbDUvLON9TJAbzOCAKvbs532XBeJSNdBPsoJcIFHGY9AetmNVcHMCT0pjM+Pi+sSmTQdCDV1RJ+OSaGkUg0JgaYvucZxD4Cuws/kw0KyQkkdBnRWEV+ybWBIMsO/mv8i8q88z+E2O9qYMm9OXtnTB6loydVNKU2y4BxZhKR+TdZq+ZKlOsBvelE8VKKVAM6M9biT7CpZ21OhTpIY7tb9hIPReqvEcY1578cs8OJdI+JyoAh1IEmTmuA2IXpPmuOyPjd1QGLy28UXScK22d7e0zxpSmsBcM+sW5Ute45wIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pn0QFlOT8/EU5UmtLmsLKlU16JpRMG6V3E93dxCjqro=;
 b=spxcpXBRAkxfaT6DxueHRCxaUQyaN+yk//GeRNqlk+m+FRJZzJoRon/ecXSmqi8gMcH0qapRfkh3BhATXOame5+LYcv1YT/iY3utHpFIb+8DXIetdPm4sMdTHj6xOhd8mPL6uejuPdzbxeHM81Ci6WbMmrXnr7nkbj2DqOPD9nWJ90HwPHo21/b37Z0UVaE4gWR1pUAHiXl1RUePfPlTxiBwE8D8tAQpRRzTlSnlWbGgp+I34QMcd1GPzdASTjU6KPvc+tkWcPekZbPERyu7OBeYg1KrI2B11fqS94/Mu1bZ1XjWSE1tAmqAgmMJNsvR7cVMbCQEBRGrOxLNnmVxpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pn0QFlOT8/EU5UmtLmsLKlU16JpRMG6V3E93dxCjqro=;
 b=XvFDZS4Xe4ux3w0tG5jYBJG0lAUTnEcyvPOt5jJiVVfAQBJXMmON1sbAYvdIjjI8dSlzDNcl/2QPA7740bGZknP8nh6wuZEs5q1udBJRMmaKgYIj7bhO+QRhKRnAlRcLN4Wu5zsLHdL/S+ZOjA+W7hNPYvDsXWJAeFcRCviKMNY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BY5PR10MB4116.namprd10.prod.outlook.com (2603:10b6:a03:203::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 03:21:35 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 03:21:35 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com,
        hughd@google.com, jane.chu@oracle.com, jannh@google.com,
        kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de,
        ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com,
        Alistair Popple <apopple@nvidia.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Christoph Hellwig <hch@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Minchan Kim <minchan@kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ralph Campbell <rcampbell@nvidia.com>, SeongJae Park <sj@kernel.org>,
        Song Liu <song@kernel.org>, Steven Price <steven.price@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Yu Zhao <yuzhao@google.com>, Zack Rusin <zackr@vmware.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V2 5.10.y 2/2] mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
Date: Wed,  7 Jan 2026 12:21:21 +0900
Message-ID: <20260107032121.587629-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260107032121.587629-1-harry.yoo@oracle.com>
References: <20260107032121.587629-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SL2P216CA0120.KORP216.PROD.OUTLOOK.COM (2603:1096:101::17)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BY5PR10MB4116:EE_
X-MS-Office365-Filtering-Correlation-Id: 402302b5-ee13-4889-e066-08de4d9bdc69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3htOEdyS3I2T3Z0Y2Npb1lRb256aXJVRXFrNmtlMGdOZFQ4eFRQMFRlUGpC?=
 =?utf-8?B?emxpaURDZE1BYlo0M242TTJ0d2RickRRekNnZDJPTU9XaFJaNE83c0xiUGtu?=
 =?utf-8?B?cnhsWlhVNDlodjVsTG14N1F0THhMSGRMU2w3RW8rK2lTMEllU280c09oWUUy?=
 =?utf-8?B?OFpidEdDcXB1K051NmdMajVadFZtQ01sUGtQcytnRG4yN3Z2L3VVWGcvMFRy?=
 =?utf-8?B?YitLYkEzb1RDb0tQMG5LdTkxR0dkR1l6WDlsMUJXVlc2T1VOTzY0K3lSaGVN?=
 =?utf-8?B?bzhYdW1Md3ExZk1VMjl2QTh0OEpVcy82dTlWZlBkNkc5RGVobVkxQjJVUy9I?=
 =?utf-8?B?UEcyNDlvMGpENDY4TkxMTUVBQkJXM2lMVStqVnpERkk4ZmZBNng0bDFaZmZo?=
 =?utf-8?B?c0RreTdQTGF3clNxc0tMZkpkZ0gvWTJ1aUxCVDVmSkcwTmFnenFJTjhoR0Zt?=
 =?utf-8?B?bnpwdW9yUkxXY3JycHI5d3haSEVtZlF0WGlKdFIyL0t4SU5QYVVFMStoZENC?=
 =?utf-8?B?N24ya3pPTlJCS0FPNTZybFd2SHdlN3BzMmdiT1Z3NFBteWkwanNPL0xySExF?=
 =?utf-8?B?emJmdktLUmNmMTB4V2UvOEMrY2cycEhFTnlzNElJdG15dUQrWmI2WGxHMXVy?=
 =?utf-8?B?b0tkd2pibHBiNTZyTFFqd1p4em1DUFd2WFhjZzRlMGlqNzVQTGVxQjNVSlFM?=
 =?utf-8?B?RDNEL3BxeUFDUFRZYWI3YTZaK2U5TDBjNzhYOFdlRThZdzFWYjlGTXhzdGti?=
 =?utf-8?B?TDl4ZVpqWTI4N2NSRFpKT3JsRy9NeFY4TkxJNzhmOUZGODF4LzF0aDdxVG1B?=
 =?utf-8?B?aXZqZHF5NnQvTVB2UzlOclRVek8waXVUNXIvTjhuN0lyUi9wb1BjaW8rU053?=
 =?utf-8?B?d0NSMkRlL0FFaUp0S2ZTOG1VcnJRZk90M1VxbmZyajRMT0JhRTgzSFZGcmtx?=
 =?utf-8?B?RXRndGUrRi9GanNyUHAvejJQbGZYdWhBd1JrWkdRT3B3LytJSVJMSWk1UXJo?=
 =?utf-8?B?U0JjYVlGbHIxR3ZnS1VHSElsNWpBWmRMaEt6cGZCRXptNno5RTdvY0lGYkpy?=
 =?utf-8?B?R2NRUDMxU1lFdElaajQ5V2NLUTdXYTdnZFIxaytkdzVtQkZMY0pNcmkrMlpC?=
 =?utf-8?B?UHNMclJLd2poeFhBeDZLUWZrUnBqN2pidjVxMlA0ajdmZFdxN0M5SnlGRjFx?=
 =?utf-8?B?bmlaQ0hSZ1R4eXZlTnVVM2xGZFNaTXpmRU9LRzRiYjlRMTFjTThTdVQ3SW5t?=
 =?utf-8?B?QjRucEhKMEhOdzlGT1k5SU9pa2RnSkh0VkluY3cyMnM4SnBqNFJiTmhSVm01?=
 =?utf-8?B?Tis1SnZGQjEyd3ZYVWRUc2xIdFEwWHNOMVZvOTE2MjlmcXl1YjI0dFpZVW56?=
 =?utf-8?B?aURsUktmb0FtMktRNE5Fd0tQUkVYQUpMRndrVGZOa2VJUHNuSE5nNG5ISUpC?=
 =?utf-8?B?MU0zLzU4c1lXOFFjQ0ZBV29DNUl2VzNlWVF4R0VkVFJhOTB0WDFlWVFYdFFM?=
 =?utf-8?B?TytyMkxSbVR1MDVTSWFkVE9EdnNCNTArU0JYTTQyWURaVU1jZFQvWHVQVStN?=
 =?utf-8?B?RGk3Yk9HZkFCT0JWUFl2UDFPVjhESHlPWDJBeW5Ld3UzYitUS21hb2NLQ3A5?=
 =?utf-8?B?TzR1clFJTWMzZExjOTQ5VzRQdnZuMGE2NURnc0dwNndSSExqZEVod0gyR2tS?=
 =?utf-8?B?ODZwU21WQXVZeUN6RS9scHNVOCtSNW5tdjd0VTBpVWdKNjdrcGduK2xaZUw5?=
 =?utf-8?B?b05WNVhDZmRWUUhWeXRPV0RrRDRtTlpYeCtTWk9QZ2oyNC9EUnBSWXduUW1m?=
 =?utf-8?B?dFNLSXB1Z29wR3hyWkFXVTBxMDM4VzhBRXB4REZZdENLUFR6YWlaTnR3MUpO?=
 =?utf-8?B?Sjl3VWJrNFY2cldJcFJQVXdESnNPRWFISlFZMmZ4eW9YVFVGbXVGRkYxdHph?=
 =?utf-8?Q?f/I/K8YdOprx8YRpZqQDlR0oRBfY6LVg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUxNT2ZtN3ZjNjRacDFDWUJzRkozNHI4WlhpUU1ZUXdvWWxISGE5TlJ4Mk5p?=
 =?utf-8?B?a0laYnVOUmdqTEhWVTI1dnIvUHlwanpRKzVrNkRPRWlkS050R1k1UjJrZXJv?=
 =?utf-8?B?SHFPYW9hNk91dnVrNEd4dTh1akpESXlOWnNZWG1BT1FKMy9TWFZEdWI0bFJB?=
 =?utf-8?B?WG1oSksvcUg2UVNibXJMcTRIMWRNN1VoZmtHdmFlYUhXRUFqa3h1ZXgvYmp0?=
 =?utf-8?B?aU9SWHdDK2VnWkZXYlpLS1IxdTdtYWZCZTdwNHJNOWh0clJrVHRLZWZaTFU4?=
 =?utf-8?B?bmY1T2VHazFVMW9vYXliOTJlamFUbkYwZ3Z4SEJiOWFweTZ6MkwyT1FTclY1?=
 =?utf-8?B?Ty80RlZ3OUNUcHF4UDNmUnpDMjJBbEtZOU1qWTYwTDNlK0Z4c0RWUGd3WVo2?=
 =?utf-8?B?REhobnNYLzk3QWVEK1RrWmtXeFZHNHZ1YkIxTmFNaXhVbEFqRGJzY3hkSlZ3?=
 =?utf-8?B?NFJMb21KKzR3NG9iVGhlMU9wN3hZU3BHU245NGFNSElQc2tESDVmRE5KekRD?=
 =?utf-8?B?ZUJQMkMvSjlkSERXRStqajd4VGExMndnQyt6aFJUMkZhM0w5aGh1QU1Idjd5?=
 =?utf-8?B?cUxubkFmUzRSclNoK1RHMjZ6V1BzME1taVJkZnpaazZmVktYTzJIVkhVL2dO?=
 =?utf-8?B?SUNXZEIrUGRNWkJ2d0JmS2N3S1VRN01OS2paaldPSlJ2L3BNZjI5WVVhU2Y0?=
 =?utf-8?B?ZnhLRU9nV3RqbmpEMFFmUVlMWXNHRkpLQkJvcHV5eWpTOUVvQnQrWGJNRXJh?=
 =?utf-8?B?aW1Jd0RBWkI0cXlCeDZKZ3pmTkl6bkJtZy92VHYwSFpOS08zSXV6eERubVB3?=
 =?utf-8?B?SFF0V2E4dzVidTM0U3JoaVNvR3h4TE1vb3dzWGxBbVRFaTVVNXlPb3l4MWxq?=
 =?utf-8?B?eUZqM05pWkorTHlkbGVkamh1UGpzTFpsV0tCY1RPMkZvS3RoS1VzV0FRYUV1?=
 =?utf-8?B?c1RrSG1XTHdhOEt3aEpHRTVpSC9zTU5RbUladGtVNEpoZThNN2FIQVBEeUkw?=
 =?utf-8?B?RFhqSlhNdi96NFowS0hmZ3piTjFoS2xEL3dFbmNVZXNQZ0Z5Y1VES095MTlq?=
 =?utf-8?B?RmgrNGR6eEtxRzZLdEVJVjhDRU9ZMVJSS2tsbk9JRVFEM240TWhha0NIWUo2?=
 =?utf-8?B?d3Q5a0NRVVlFUzZWZ2ZlZzRFQ29xd2FOOXgrVzE2bHc5LzhzaXpLTnVjN1h6?=
 =?utf-8?B?SldOVTVNVi9WWVFDZ0xBWm1jSW1mMkY0bWNzV1cvUXZEbWRLZjJiSzI3ZlNQ?=
 =?utf-8?B?NTVSUGlFcVlDaWNkbHpraXBJdEJkaFo3ZmtraXJ6T3NsMVV3aGI0NTRsNmh3?=
 =?utf-8?B?ek4zRHdOOU5aMXpFSGZjbnBIdnFubnY5RVJpV2YxeGpYVE1XbUxLUHhrRElG?=
 =?utf-8?B?VnZEaklpRmM4U0dFRld5YTBxbzhiZWY0b2JTYWdHNDVPc3ZLWnFUczhNajZ2?=
 =?utf-8?B?WFhKdWl0Tk1aMXZoU216R0lZV0pIeDhCK2cvcmsyUW5CaWVnQjJoZkxBVElz?=
 =?utf-8?B?UFVQWVdoZnpTZjU0WWFydVRGczF5N0RySmg0TEZMdGdlSFlqNDE1NDl4VUIr?=
 =?utf-8?B?elZpbXpxZkJkQ1lobkxWTjlOZzBsODhYeVlWaW9kcWo3SEhubUg2MGx6SFU4?=
 =?utf-8?B?bkF0U2xMU1FyYXU2UUNqeDdVeTFtOGhpQ3lUcnFFc2VuMG1PKzlGZklxNGNP?=
 =?utf-8?B?eVgyb2JzMjNLRTJxZ0g2OHVoWlp3OWh0b2gycWtoY1VYL2hqQWpESHluZlV4?=
 =?utf-8?B?TTRWU0NrY0tiK0N1SSsrbkRZRkFDSW1tOEg4VFlPNW9md3FTblhIVytXSCtB?=
 =?utf-8?B?U3BnM1NPdFJZci9uVVo1WllGWk4yTnp6RmpOME9EeTBDSWFhTEdGQTYxTFBP?=
 =?utf-8?B?T2w0RnlIdDBVN0lweWk3bUZBZWVlL1BOYTBleXF6NW5XbXlNTVpCVGhuRGxL?=
 =?utf-8?B?NUtsNDBxdW9aOUtXUXdaN2ZRUlhzWGVEN3ZFOEk5VWZBOHk2WmpuYWRJbmxx?=
 =?utf-8?B?NG5VbFlYT0NDV2E3VVdJSkRzbUtiSkdUZ1VhNFRuNVNLNW92OXBHTnF0SnUy?=
 =?utf-8?B?K05SaU9xektUVEpLaUJYSFVQdkk1d1luZFJ5dlMwV3lQcVMrSi96anJScW9J?=
 =?utf-8?B?R0RFWWFxaFlXN1JGUlZobXp0SlF0UHBSSEgrMnRjTW9uR3lNWThFQ2p2OCtU?=
 =?utf-8?B?bDdzaEJWRHhqeHpKKzFZM2xUY052TDRJaXhoY2s1UnkvKzZlaWJ5SkFtbjNY?=
 =?utf-8?B?dmRCdnZCTjBZWUxTeENWeFg4c1JScFllU0tLU3dvUThmL2hJVTRxaDg4R3gy?=
 =?utf-8?B?RHlIUXg3Z0dES0RrakVCSS9yMlZzdi9lZzNVNGxuN2RTV0pTa21RQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2V1TkNOnkN0W8PJ6aVyZBE9bkOHtKNIYpZ9SXLHwsGp9UNnZEtCMbBxKl+Kuzo+/Y23S7rrNw2TWutm6F7eXTv6TR62b/Xs2K5aKe0VLQfuSCMvxwB3My/Pz77B0Ri6Z1oTR/rfwG4uxQLDaQsuwxo6uToWEkijAvYsipEPJ8ceuJ+SyJUIuujb+iTtEiPjVVbnvdbRmtIrXacxv7L0ul5yfCCTUAYhs8xatzhCb1NeM5pcg6Q62h1Ua+gGGxFtKtirwBV7LlcBIWiIXrZuLeN0OnTP3gftttEefBcMpFq9TeVnobYJBF3Fm9TysuNsrZEwjCf5o6rxf3JKbg+Iu9PMQS3hgyaDrjKS8m5nI73jqprnhj4AGExBGdGDiHmOEhv7khzcrFQvk4j3w4BUuej+sDvDIoXhbdgjTvaFAH6GU7p5pjBpKEWPLE+3YeSbDSSMa0dFRETtnKmIFeXdbri6W6i+D1eKEB7EmInaJYHd2IabH4jfCFJ41lbbtOfxmF7w0japThupsXB34esxRIgjAL3hE5qT0pNyOCzpBrJ8wlUHm/p7dsKBTCkiwVb+ZwRIZ3O8R2NIEXngNEQj8CXybbnkYBqWMvy/VgRdnNOY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402302b5-ee13-4889-e066-08de4d9bdc69
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 03:21:34.9087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/nFPLOuEABYTMvBXxHiD9CHHihvluYHnpFiajUrPzm5E4zmfbtybxgwABMwhqc3DClM4KOsKgQf3AU21xnv1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070025
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDAyNSBTYWx0ZWRfX7crPcmjVWkP8
 2tCsCkurIWZ/sSZ++8G39LUSs9jx27FvqdvLps/caE3tQh1PMFbzox8GHfuye0aVYP5rqEsX/t4
 0VndJ08YbZn19otUzogeWUfKjnjheX2CgonlTl/WKX4zmBWhyLHjjunpb+21pBQqFItWzVbp/bp
 yrE4Dcq1u4+FDQMnqq0NOWjMBspe2gDjWQCtydll099iXFDc9QYV2aIOUaQL7B5K3ZPnC87oiV6
 6MNyBWYowOgQxBQjux6XYzRJp+H5bNTs22glK6P+V8+Yc2kWFxcJEce0RXApSj814YcD9wNonye
 L/Nx1dH4Q7Fj+TCDyU5297wr/JST1Nw+rnD1g/I4OQyDQb6KS4MYQfkQWVvuBzvI1RLLXW0NmZV
 X8ToPPR3mkSe2ISRqNTBEjKVMO9fgNxbK4j5dj9AoZ7Qi0eXZSE6V2bhqm7RoHF1JCbM6WsPj3R
 Jts1Xp8RUnCklFE7PlSySk+bYz/GoAK4dL460e6M=
X-Proofpoint-ORIG-GUID: DpbserQHzUmN1yyT9xtgVwVZpqleWwFO
X-Authority-Analysis: v=2.4 cv=XNs9iAhE c=1 sm=1 tr=0 ts=695dd144 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=Ikd4Dj_1AAAA:8 a=7CQSdrXTAAAA:8
 a=1UX6Do5GAAAA:8 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8
 a=9jRdOu3wAAAA:8 a=pGLkceISAAAA:8 a=R_Myd5XaAAAA:8 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=nrACCIEEAAAA:8 a=7ipKWUHlAAAA:8 a=968KyxNXAAAA:8
 a=eh1Yez-EAAAA:8 a=Z4Rwk6OoAAAA:8 a=K6bJOSjN_L0kULG0WO4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 a=Et2XPkok5AAZYJIKzHr1:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=ZE6KLimJVUuLrTuGpvhn:22 a=L2g4Dz8VuBQ37YGmWQah:22
 a=gpc5p9EgBqZVLdJeV_V1:22 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12109
X-Proofpoint-GUID: DpbserQHzUmN1yyT9xtgVwVZpqleWwFO
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5275B14000F
X-Stat-Signature: aectjyantbcuhf63yt5ik5zphnsuu4ci
X-Rspam-User: 
X-HE-Tag: 1767756163-475246
X-HE-Meta: U2FsdGVkX18eYITSmXUy4C//ged/Tmpka525H88/xh1A38t51m3GlYHhTsNlNMRNF8UnYeqTQfkLts9QJao4tHgi/kebULNAW7kggN1a+PtNwkEJWoimztiE53kNoXeZo/4WuaNgdKBTxdQbn0rqiU39fNPj0yh49oODXKzGCSiUDY1lFypkJ2+ZAivYEbyMWrfeFhSE58LB5H4Klz+l/1wrIvGNh68LlX+L8XHD5UuBzjk1MibsvMElOqzAzuRj2gUUxxu7k6m1DFej9s12Da5hZk46q6JFJgUqL7Z5IPUZn8RhKVf0Mt0ynqtrZ2GhC9X+OPhUghgwQ+QwY/6lhqfULnX5oVv05NAhUEw+DisfELHPJyZyOkGZCiVTLB5MqKKIxc42W+4JyJakqhsHVh9zYf2PmA4lRwhq00pU0TXyFdrF49AcufK37OUKyNES2tdK3pN15vMjNoc8Gir7WEqTudIWhZ31oc9Cv68ZGXjETG/XBzqTxcHquMQkpY3Ox6YqTcqH2X5OByOWgVvBhkA4CsagK47LUki5IUDWRzCoIUzSUzWcO/pzSMr5Mn7RNcHyFucWKncd0C6jpiTjhlkokuEj0/obAr0qc09U1jt8AzPkxgG0yRxFAzquPAWudrkvXtF6d8YsVCU916d/EF1evo3mcmX2shTwy4vbCNID6dfKCnw4BPLH7tX6X8YGG8BMD/r0MM5rP8f+qylB/LI39/TKy5RQ+TEsHOKgxW5l8LUZ3ngdSdPMmD8QyxHM+ebS8fL8Tg+s/L6fWtvDWs/+FvNt3sj5DH708B5rBg1oG0C5aGQuxuPm7HvdoAEznwVYbqFKJP5ZOtBCOLgnvz/EwSklZGvksOqRtvyhD9k2YotxBgky54Nkvl4Rx01L/+XWVRvF/lEZSTsoC6CaUuddqZe3acAeB8KMk88Plc0BuA423/jcYBKSeLnRTPsLjt50MAEmrkw9e5X/cJE
 7MaJ4yMC
 w3WzTo2fTQyxJ4JY5FNXuSlXgRLnKCvVOvmEuIPm0MBA4kS37EH4qmNglImYhyaVn3CI8Ej/eSvw9jqFW6mLfVZBm6zqKktSVi09ntabHJGvHAqSpavyWBRwasxinpN2RAGhh/aqidSYVuCccvemRT88rnlQlH1213poso7FU+DDhCPLyUB0GvsiNtdJTVrWbc9WSYgE1h8B4U9hmO6BbAVDc0jNlujv13E+fBC4PcOKK3WNZnxpqT8iuOlv5+Sk3M6aF3FF8avkjO2YFZ4VnbLTaq9oRHekBaJbYc6E0wVum9RBSXVH/9Rge7DEI5yVhAdZXYEBSjwVPOk1s+sr97JSo/DZdrfCpe/hp1Rwp+QMuHYUGqmOPaMu5WlYBHSRuuNgrj5Iw9tUHfyfzpilB+rj1rue97JjGa/jFPNRq2gufJ7MiS5WnnbdmtaEVk0lz6x4cKIudhQjGBvp4+fLzOTxAfNVmGjvmG5AUKB+wtlTZvFD6bbvbH/hmXRck8ZGrhAxNhj0mtnweQGqmSsAEPEWyYzbWxPloIMfzuQxGuu9Xl98gPuYsR8R2/rmOQjBkktsCgQjrlgJLoAUY5R/Do5aeCcwLLdel2FCZlBYqRu8Q+3OW+IhiaywsJ6poCNgyGwyYTb2q32WDI5Czhrl4gr4Tm5fTRZiMur0azwUl937jTEFUUexO/UsOtLi0cqsmacMR7G8g69w7utJwIZGNWHVBlgUkWLdEWwrRAfbFomphB7Zom84Qg5cM6gKrGFW1V9jc99cg8qS0w0d1InSnnXxENDDbvWLWgFgZkkTLwKBAczfnuqv/6XYlNemI0XU5bVUJiP3ZbRTDVHIYDJoC7RNhpfGToCVVj8xH0NqNfyF8CO3d1XrPCVBJhx0fmwEZv7MRFfu6b3/xDEw9N0sJhLih13irTNOwc90MaVIt3pfoQCS3IWJ67CGptWiNdGPnGms+EX30CKqvPxkxfRScd4oSdMI5
 RaEENtBR
 YosU0/w+w/lqLUUEfCZ8TQrk4VQc91kYxE6P7fEc26rWkIEQ6NZvghaFNlx4zIAhsGaTM+X+GJftD016Jq/ObveNru7ydb4nITgeCnxEuIGd9noGOmJfeKeuQDrB7rOZODd9CASvru7oqLBvfbdQ1F6FjyAfezK5do1MHKTrbwtd1g3YzlnMBnS39xlfpu2TdrcpNlzvXRZmyH2LFZvFXCZf6CdgsIKjLiyCC4f8eNrDh64Tj0WU0gaK6ITM6O9mqT0K1MW9RIyauhWH1oQr5tFsOrtiVDi1WWr6DGOlBbS+JBUcA7X1zp9+mJnLQQWZjiZSZzlxeI/wPraCRpQ6LOMy6jFqx2I4P/5oXv5YUX/16/+QFMWrYKr4qe5JgYoCxylFAJBzTNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hugh Dickins <hughd@google.com>

commit 670ddd8cdcbd1d07a4571266ae3517f821728c3a upstream.

change_pmd_range() had special pmd_none_or_clear_bad_unless_trans_huge(),
required to avoid "bad" choices when setting automatic NUMA hinting under
mmap_read_lock(); but most of that is already covered in pte_offset_map()
now.  change_pmd_range() just wants a pmd_none() check before wasting time
on MMU notifiers, then checks on the read-once _pmd value to work out
what's needed for huge cases.  If change_pte_range() returns -EAGAIN to
retry if pte_offset_map_lock() fails, nothing more special is needed.

Link: https://lkml.kernel.org/r/725a42a9-91e9-c868-925-e3a5fd40bb4f@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Background: It was reported that a bad pmd is seen when automatic NUMA
  balancing is marking page table entries as prot_numa:

      [2437548.196018] mm/pgtable-generic.c:50: bad pmd 00000000af22fc02(dffffffe71fbfe02)
      [2437548.235022] Call Trace:
      [2437548.238234]  <TASK>
      [2437548.241060]  dump_stack_lvl+0x46/0x61
      [2437548.245689]  panic+0x106/0x2e5
      [2437548.249497]  pmd_clear_bad+0x3c/0x3c
      [2437548.253967]  change_pmd_range.isra.0+0x34d/0x3a7
      [2437548.259537]  change_p4d_range+0x156/0x20e
      [2437548.264392]  change_protection_range+0x116/0x1a9
      [2437548.269976]  change_prot_numa+0x15/0x37
      [2437548.274774]  task_numa_work+0x1b8/0x302
      [2437548.279512]  task_work_run+0x62/0x95
      [2437548.283882]  exit_to_user_mode_loop+0x1a4/0x1a9
      [2437548.289277]  exit_to_user_mode_prepare+0xf4/0xfc
      [2437548.294751]  ? sysvec_apic_timer_interrupt+0x34/0x81
      [2437548.300677]  irqentry_exit_to_user_mode+0x5/0x25
      [2437548.306153]  asm_sysvec_apic_timer_interrupt+0x16/0x1b

    This is due to a race condition between change_prot_numa() and
    THP migration because the kernel doesn't check is_swap_pmd() and
    pmd_trans_huge() atomically:

    change_prot_numa()                      THP migration
    ======================================================================
    - change_pmd_range()
    -> is_swap_pmd() returns false,
    meaning it's not a PMD migration
    entry.
                                      - do_huge_pmd_numa_page()
                                      -> migrate_misplaced_page() sets
                                         migration entries for the THP.
    - change_pmd_range()
    -> pmd_none_or_clear_bad_unless_trans_huge()
    -> pmd_none() and pmd_trans_huge() returns false
    - pmd_none_or_clear_bad_unless_trans_huge()
    -> pmd_bad() returns true for the migration entry!

  The upstream commit 670ddd8cdcbd ("mm/mprotect: delete
  pmd_none_or_clear_bad_unless_trans_huge()") closes this race condition
  by checking is_swap_pmd() and pmd_trans_huge() atomically.

  Backporting note:
    Unlike the mainline, pte_offset_map_lock() does not check if the pmd
    entry is a migration entry or a hugepage; acquires PTL unconditionally
    instead of returning failure. Therefore, it is necessary to keep the
    !is_swap_pmd() && !pmd_trans_huge() && !pmd_devmap() check before
    acquiring the PTL.

    After acquiring the lock, open-code the semantics of
    pte_offset_map_lock() in the mainline kernel; change_pte_range() fails
    if the pmd value has changed. This requires adding one more parameter
    (to pass pmd value that is read before calling the function) to
    change_pte_range(). ]

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/mprotect.c | 75 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 28e1a8fd9319f..e37ad81e17523 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -36,10 +36,11 @@
 #include "internal.h"
 
 static long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		unsigned long cp_flags)
+		pmd_t pmd_old, unsigned long addr, unsigned long end,
+		pgprot_t newprot, unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
+	pmd_t _pmd;
 	spinlock_t *ptl;
 	long pages = 0;
 	int target_node = NUMA_NO_NODE;
@@ -48,21 +49,15 @@ static long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
-	/*
-	 * Can be called with only the mmap_lock for reading by
-	 * prot_numa so we must check the pmd isn't constantly
-	 * changing from under us from pmd_none to pmd_trans_huge
-	 * and/or the other way around.
-	 */
-	if (pmd_trans_unstable(pmd))
-		return 0;
-
-	/*
-	 * The pmd points to a regular pte so the pmd can't change
-	 * from under us even if the mmap_lock is only hold for
-	 * reading.
-	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	/* Make sure pmd didn't change after acquiring ptl */
+	_pmd = pmd_read_atomic(pmd);
+	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+	barrier();
+	if (!pmd_same(pmd_old, _pmd)) {
+		pte_unmap_unlock(pte, ptl);
+		return -EAGAIN;
+	}
 
 	/* Get target node for single threaded private VMAs */
 	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
@@ -223,21 +218,33 @@ static inline long change_pmd_range(struct vm_area_struct *vma,
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		long this_pages;
-
+		long ret;
+		pmd_t _pmd;
+again:
 		next = pmd_addr_end(addr, end);
+		_pmd = pmd_read_atomic(pmd);
+		/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		barrier();
+#endif
 
 		/*
 		 * Automatic NUMA balancing walks the tables with mmap_lock
 		 * held for read. It's possible a parallel update to occur
-		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
-		 * check leading to a false positive and clearing.
-		 * Hence, it's necessary to atomically read the PMD value
-		 * for all the checks.
+		 * between pmd_trans_huge(), is_swap_pmd(), and
+		 * a pmd_none_or_clear_bad() check leading to a false positive
+		 * and clearing. Hence, it's necessary to atomically read
+		 * the PMD value for all the checks.
 		 */
-		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
-		     pmd_none_or_clear_bad_unless_trans_huge(pmd))
-			goto next;
+		if (!is_swap_pmd(_pmd) && !pmd_devmap(_pmd) && !pmd_trans_huge(_pmd)) {
+			if (pmd_none(_pmd))
+				goto next;
+
+			if (pmd_bad(_pmd)) {
+				pmd_clear_bad(pmd);
+				goto next;
+			}
+		}
 
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!range.start) {
@@ -247,15 +254,15 @@ static inline long change_pmd_range(struct vm_area_struct *vma,
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
-		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
+		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else {
-				int nr_ptes = change_huge_pmd(vma, pmd, addr,
-							      newprot, cp_flags);
+				ret = change_huge_pmd(vma, pmd, addr, newprot,
+						      cp_flags);
 
-				if (nr_ptes) {
-					if (nr_ptes == HPAGE_PMD_NR) {
+				if (ret) {
+					if (ret == HPAGE_PMD_NR) {
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
@@ -266,9 +273,11 @@ static inline long change_pmd_range(struct vm_area_struct *vma,
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
-					      cp_flags);
-		pages += this_pages;
+		ret = change_pte_range(vma, pmd, _pmd, addr, next, newprot,
+				       cp_flags);
+		if (ret < 0)
+			goto again;
+		pages += ret;
 next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);
-- 
2.43.0


