Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2002FC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E436B009E; Thu,  6 Aug 2026 13:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136376B00A0; Thu,  6 Aug 2026 13:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BC06B00A1; Thu,  6 Aug 2026 13:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C814E6B009E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:08:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E1FBA1041
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:08:28 +0000 (UTC)
X-FDA: 85071478296.19.F564AFF
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010050.outbound.protection.outlook.com [52.101.201.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F3C240008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:08:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L3aPWnFY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3rIII/P518E5Q/u4ZMcHNEmmOygi29c+UksBZaEsaI=;
	b=nQkGsjNGLANecFJJgsULCgtZvzX6bRjASWhxQ0xuriURIWWxZ6CwOlOsYDU8tSj/Npi84I
	X2dk+5dXQBAwKgDurcQLwRhyT0VU4TyJuGdUR7iCPibh2jCNkVTFAp9ozhL2vKvhKxMaTz
	x8Tjzdmc+j8gBLnbk8uocXkGhQxBSHw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L3aPWnFY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786036105;
	b=1w7d1UE8QxAGjl0qzJLp/GTu5c7Av4tNwT047er4x+p/pPnPYBbtr7fPn96jbaqgx2jjex
	2THgYEgXrH1jhlOUYUvIBM097bMsoxQoBlKpWaX2G3vbJTqhdD/rREbsYfZKp1yu5a5GKX
	dxu0YxXjRLueMJ8XCczq1OBHSM+pP94=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+ewUdatBM/SPNp56LFWkhSjhZIOHPxVkxrfy5Z1lZmvvVhU0037dYzgkxpBM8mIiIrCH01pPFMxq6YuTqiPDve0rWiz+dYWzr0pufw8nmyTFPSZPCZrM/+2SFw1paUGACjp8X4Hdy7ZhGdDsT7adLCH40cpYD4S+2gTaBFWN9WN6zanak2qXoFfUyFIXQIME+g0FTkO4gx+nOH9Sx/Ymqu/mWkfkIygxfEhkFRTzIE+0bDDFEQy9gRaqOtv2p3PNfSq6L246WcxwihJhH+wH26NRjaj8xz7t2DSbUu7JprcWdK2ruf6NWULJo7rvsBz/T+cDE6ZK4vyfoYAwlle0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3rIII/P518E5Q/u4ZMcHNEmmOygi29c+UksBZaEsaI=;
 b=eWx9MHYGVwAJbr1rcVOH4sbULyMkW0RKfbX3NuOomZLfnubzQPNSdPBhzL+5pa/+WTBquCTy1q9GNHlG6Njp8DUFLOx128coenOl4wx6Yw3dHyawbBXQXMMvRuXAjBDHOFzohlS1W4fBRJH3HwGGk6XglPMUdkEExyzQfZHY4pUKAYMqgnkujf294JMvaXm1q08tq4OJ9h6YcZNXczNLqGH2dMw2KuPKJHYjSSfQaMxCFWBuJbiJ9YSPfIBstgggycabEhRgj7G1kESRE+SDcc2B8s2PtaZTfRm4SAnJUJZiBFFSGiiqCcOlfXGKzy4b2FYuzo0tMKobS92Kyt3qEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3rIII/P518E5Q/u4ZMcHNEmmOygi29c+UksBZaEsaI=;
 b=L3aPWnFYOF1MT0L7swvKVVTNoSmUV0IuJ3oDGZPjgcmWX9/UY0l6JYd5At8h+8KYQiiqzDurG4Dj/To+CqDDMLGLbFRGCnszQcnWy9IxaxfniOA3ML4To3w8tztgUV1cOwBI+8o3NpiOSer6mvQ3qsYDjBzzXYOtJIbjfxb18RtmKNIy+wz2YvuTcpVFcEMeSUiKadgaWFcd0SuKzlO/7bdAim3TDjkfyanLNZ5FAppzvPMtvReYR5qMupBEDBtUwjUkJ8dnIkSLHNyE1Tv1Wpa7ozD/nl4jtqvr5msWSu+3o6QuqE/0H1UsGjQXz37P/lDbDvw0yX/ptvmQc6IPag==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB7117.namprd12.prod.outlook.com (2603:10b6:303:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 17:08:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 17:08:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: John Hubbard <jhubbard@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: AI slop (was Re: [PATCH] mm/huge_memory: let special huge VMAs
 bypass the THP) policy check
Date: Thu, 06 Aug 2026 13:08:15 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <A403B054-108E-49E8-BFF6-BE5EF8E61C02@nvidia.com>
In-Reply-To: <10b07d00-57e5-499b-a136-f2148e870d9b@nvidia.com>
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org> <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com> <anS6hcgMkEJocbDJ@lucifer>
 <10b07d00-57e5-499b-a136-f2148e870d9b@nvidia.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:408:fc::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: 2db99a05-5b72-4ce5-53e2-08def3dd4ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rzifxyiXtx9XWQGnnrsdHEENoCknPNo/dCgh/aHzTHczUa50IIeUSYmih6ayZyehVnDJ4curvbf1xgKCjFFosYLVyruh0Wwu6JHxStoqWq9nUn/14Bz3it0/Dz92E1TmA4U4RbRXkb3+rq/b1YMKJJ78zFrTq1PEgZE5dg4G5vtVdjMtJj51HrtiG+Hp5DSl86B0eOBSRsCtWcDVz3Q/i6RmQ9KEzVrqdZeNOl81z6YglJwc4X/EBNx94AXTbjvCVT6FKqBvlRZKiMDDLgcA9cKTLwLeZUHmoEm9fDCxzl5jJ0nJ26h8ovyL31PIm2gVhMFg9JaZZpagehfgAukoeujMbICrhCi1w205eQysjzWr8cRdBduytjxIVl/8ZyKT8bdIhVDrlMKB0oZGB2rpMIztXCugGT221iJfvf9ZR4qH8ES5A83CQqXcKFLYyIhob0GPOlWOIKObmqym/CsQiuyFBn+aTK82Qfi7zQCGzyzlMFuSWyDHXqK/ZPausV8AM8qkp0cvq8Ig1umRZ0o1kJ2Idc5s/48Cx5aoq0Xjg+MI6bmAQhGwzNWywG0ji8plgz0A8OSAef3ogOgP8C+YnTfMrlsCMWyYixBDoUqL2DYyv47Cr2+6S/WEXOXeQw/bBPEUt8Ebh6OtYiUOz/ejWMRxISYjf36CsgM7ny1mIQ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0xYh087ZyWA0CDDtjPxBbF8Qu9OxsEuiLKwRYt3oKWZvHxq1rk0/wj4nOWLo?=
 =?us-ascii?Q?IhdrM8W0u7SgGnnetCg2yJ84vZE2bZWtd8H49RrngojyttbdBI6M9aLKCHmX?=
 =?us-ascii?Q?JDLQRJgFdoU4QVR71D2iUpx20M80NIZKzBRrUScpG/DeFqHXra20lc+BoyX+?=
 =?us-ascii?Q?KrGzc603QvxcrzObKr6QzCgwrwjrSuYDWmMIzM1cm3QpoFE3HTkh1qlPGmHy?=
 =?us-ascii?Q?d9aGqxTfHoHcIJ2qD0sSx98cDpK1BOXOF8ufohQMOmHuPFRnL4fAOyV5btB2?=
 =?us-ascii?Q?2WMQRFT5cA0xk8t8QPaCcVfuBvXBIxqUBBNtSC65X3VAAL53yPEWIoNfffeU?=
 =?us-ascii?Q?nqTRzRm1EMHrPwe+FkTLbpVQE0fPxy58K6upWmrr9O2keT+CnyWl2RG9R8gs?=
 =?us-ascii?Q?Kddxwu9FxzpYPrQy1PyxORyc4jcQRDBmyKlUweTC6i068aWMqt1+vS8bTXfC?=
 =?us-ascii?Q?IvkX0azH6Eh/t2emkC7ZW8DUXjbHMUHBFosTgS3eNxCw1Kj/FfB9oHiQ1s59?=
 =?us-ascii?Q?zkUW9HZDCvQXHqK+5JWrVsZnTdtGMcqNabTRUADR0IDikJen0tZjRqS91FWN?=
 =?us-ascii?Q?P6db/g0/4xJCCV+9vGNawkDa+ZKrmFquRZ2/ZWjLdjIA2igMJPMDym0FZ8UK?=
 =?us-ascii?Q?AhbxX3A0fo2eAlOpn2KfXebvhkeF3XuC1X95kSd5jEpTyhMjepeEmEX3yFTy?=
 =?us-ascii?Q?whOljLfEHZYhX/EIsnDLFv4R2idN3cVvFHcvUJUgHQoUU1TFamXP1eLtTyf+?=
 =?us-ascii?Q?T4Gw0q0aTEeckZHE5ZrGeuknDB+doIlVNIydpQNTdkM0e0C7kJRPFXU8Joew?=
 =?us-ascii?Q?5xLlSTe1MKpHLG5QRBHuv8OuFFo+WVN+mo9EEi/xXsITYau7J/ogsc9DuPs0?=
 =?us-ascii?Q?GLeFYIn90nfHuOiB1T2ErFALVxfRIg+fpIHkRR/8wNnItzoIDh63V1csttYA?=
 =?us-ascii?Q?UyiBAnXO94QvZUBT+kQRoIQYXZ2ie7b6ipjQAAaXKapU7p887Rjnr/XPQCmD?=
 =?us-ascii?Q?KU3R695sQ676g/UaQGUZyWc9QUXrnwPwSay7yv3ryGLdf0wK0bWINmvkz676?=
 =?us-ascii?Q?vGu1uVB/vQczcGgMtq9qyiUNiZ061Vi6zFggcPXvAYLgKeWbmAdmipawlv9z?=
 =?us-ascii?Q?hI/LB52CETzXiSZxdbS5dTy5BNeBL79BdcyMJ9jnyP9aMmeGx9cMFUGYzyDT?=
 =?us-ascii?Q?vszo3NWgQFduqzhPPnxVY/mBXctXBuAf5o5wJX4VYHvBD4SQgtTQ38GKcFwy?=
 =?us-ascii?Q?rhOwqFN/g1wd4WaNc8Kqbk77/fJU+k6yZhFCfQhQdGbQUFMz2Cq1bhYIFJhC?=
 =?us-ascii?Q?n2ekeWdtv+RY+YxFwtR1IlHnUS4XD1IZTi81sDh5kZ5DTtSsv7NYYN19buWO?=
 =?us-ascii?Q?raBKmrnq1+OzA/oPxTKTO9+Zp10j7k37wG4E8Q7bN5iB/KPPlEy46IBoJ2Gf?=
 =?us-ascii?Q?ZqMNI7JxPtp3LF4bft2MHQlHjDENaDZyZi8bQ0Xayd5fh2WhgI3p60ojs3zK?=
 =?us-ascii?Q?uG1y6chn2Xj6tllfeFBuLr8P334NhHHbc2V6qXknolkFazLk85qYAiWG6454?=
 =?us-ascii?Q?Jz2Gs6ARvbmzJGdlz3OBrPSDxGw3e2ARDOYrUsN/1h/PwB9VDYh+0ZFMAyDn?=
 =?us-ascii?Q?mX95mCdJ1QkOL2ivJuhU55k7R2ewzyQ6DvHH4Gt5M2AZfrNMT4D8a1vNmS8c?=
 =?us-ascii?Q?05UGu//3gjLJGkSOWLol9H6J4zCPuDpbLQmhL37JM2/jJ3n4TISQhgM+TypQ?=
 =?us-ascii?Q?zeYxfh0WOw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db99a05-5b72-4ce5-53e2-08def3dd4ee9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 17:08:17.1526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OKbAJvI519yFXKDfbG8TUTXFXt7hpWg97fKI2YXDsjYy+BBvZ0KStTeWppmxwJC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7117
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F3C240008
X-Stat-Signature: rw8hh8ra76oewswcppx1yubign5z8ooq
X-Rspam-User: 
X-HE-Tag: 1786036105-91841
X-HE-Meta: U2FsdGVkX1+3kjn+5StjkstZ8L3KF7JeUV3b27YKB2kls1nPvzb9y2WyM3D350b+9oylH7KHgiKw5dmcA8JgZf+oRoBqrOLsX6JpUBlbBgq4BpZJ7M86+f2vp7rzo3FQiNoE1xH4pnvTXeg/jux7N50e8MFkFRras2If4NqGlJMMCB8Dh8zPUFgor2k5lq6crQO8w755LR6sMdBNpOdFBJor4N+VVT7T5dObOAnl6hhJzHIszgcPhPOCLbf3r7WeccJT/QL8W+xIRBcUY78MvBZI6DXCFtuLh109lyYGNQlh7W7Qk6i25TtAgXelwnhQ/1o1Kz5QaLLA4jwG6DM29spf3TYQHciFgA6nKyzU0bHXiOkopub5/yt4HhO0RyoN3E4qaHl6fBjMuJvmBoS+JDRkZAfaBBXUMn3a1SnR8efTY18eCQi5zoCcflxvBsuovhFM2K3TBUFmELP2ryudZO37er7fx/NHR/52P1ASNNPjK+FrvyYWVGTMGO2fsUZbNVBjRtExrBB4kEoMGpAcra30grhThAMdVwvNHtkXQTNTyjUX+HoTQlifI7eFMHuzviL+cl4KogGVVd02h7GsHD8e52PmxI21zyDrpoLBbvd+MT/SMUGukGqL9Er2gxH+R3uxdKgopHrd8J+d6UveJBTqxFbgnQgDGWY3DYwBHpd396paSLnIpdDawt1zQTtbfHds2Cbvnw26PA6IZJpwl677x/pK/2VMmI2HyKYNd6MybCUi3WhlO65f09SKzbni+Au3gHdueOaAAkGnQPepHA2pS4BZv3BWAjNH0+l5PR/wlLuwNzSpWoZPEjJjumOWdOTT5ZJKyWjN440ViYuRsbJDHJtUb/UFYjgOBT1RwHbC2At0eayt5OvqpcmzKt3EcsvbWtdME6yf5AuJn3367fUY5DZlL4lGvRK21YKD5v3Q5Y+KWTwQRsBHSFVEtKH9uVWyCY1NrLjZwT5M/AX
 RpNScz9s
 /NvwgyksZ6uq+ypOkJkpT+CjOvQb5/wAFMKGR8PYo4lkX+fIOIzUv/1lJVuChRtLQ/81KA8VaSoHdk9kPxPNHulOvtnBrPeyfxhaXHfk5+JTmAVTEGVup4lUAgKZSHTjWPCHMoOrLF6zB3XZnmam635XsG5stNZ9iIk9gOq/VqcCvwNpJw9rHmu6EBjOnobVaTc9UeXEBOXbQ4+ajwbECqDGIk8i/u6NrpoB/Pc+VbsbaHc4mOXcS9AGGgKMUfczXo9wqY78nMq/8fjSOiKpbqAgn9gQW/ooaA1TgXjbYhRxC3eVoo2zJZaUeyih04AynlMnbFKngIq92iO5u9LH12rPONv+DBYRNqbA7dxWLcc0l6C8MxHyhHsfiGGTayNha4l6YBUkaZITCgxjyk6EsI1d1ZDFkBlk9NvuZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Aug 2026, at 13:05, John Hubbard wrote:

> On 8/6/26 9:50 AM, Lorenzo Stoakes (ARM) wrote:
>> On Thu, Aug 06, 2026 at 01:45:17PM -0300, Jason Gunthorpe wrote:
>>> On Thu, Aug 06, 2026 at 04:47:07PM +0200, David Hildenbrand (Arm) wrote:
>>>> Just to be clear: Unchecked AI slop in any form is making my life
>>>> worse every day.
>>>
>>> I think eveyone's life who contributes reguarly to the kernel.. The
>>> only ones who seem to benifit are people doing drive by patches!
>>
>> And they shouldn't - we should make sure that nobody doing this can
>> benefit.
> ...
>>> Yet responsible use of AI seems genuinely helpful and quality improving :\
>>
>> Yes and I use it daily. It's really helpful when kept on a short leash...
>
> haha so true. A *very* short leash! :)
>
>>
>> We're going to have to move to a trust model eventually IMO where random
>> new people just don't get to apply anything until they build trust with
>> smaller changes (and with measures for established people who start
>> sloppping).
>
> That sounds like a good move! It really is all about who sends these patches,
> and what their stance is toward creating patches.
>
> And furthermore, that's not even a change in policy! Because traditionally,
> that's how people started anyway: with small patches and patience. It's

Patience is the key. Seeing patches refreshed within a day is killing me.

> only with AI that they've been able to skip that step, to everyone's
> detriment.
>
> There are some patchsets in my inbox that I instinctively just skipped,
> because they were huge new patchsets from new AIs (not people, really),
> only to watch in dismay as they burned up other people's time in
> review attempts.
>
> thanks,
> -- 
> John Hubbard


Best Regards,
Yan, Zi

