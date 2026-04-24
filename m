Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639FAFED3D6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4C06B00A2; Fri, 24 Apr 2026 10:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C156B00A5; Fri, 24 Apr 2026 10:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2316B00A6; Fri, 24 Apr 2026 10:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A68926B00A2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:49:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A345A0198
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:49:51 +0000 (UTC)
X-FDA: 84693733782.18.16FF74D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	by imf04.hostedemail.com (Postfix) with ESMTP id 301FC4000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:49:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fyBpAA1C;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777042188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1yFXpvOKp5h/UbECIU0Hjo44XD93tn2wcgMLsQ5AwI=;
	b=v6sC1X7U2AuMMLcu26O8HgmlTR7MKUqtViFi4nk0scM2ACciErkba2TT6dPseD/AB7hBam
	zoAVCzvOkawgYo6sfMfZWcZCkCdyjciWB7FK6suZWcT7xJxffRDKXo0R++31nUfOZGwAqn
	bU+TdADjCvjQ2MF5hMKW+NRTRqCfAoE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777042188; a=rsa-sha256;
	cv=pass;
	b=H8bWFysGxWm9iYMlDUNAiurzq0dOrXah1WiOKZK7U8p9vg0OkFQiBpQV233bkx/M6f9pPQ
	zlVSzepamtoZgiBwrMBwcLT/fK7QPOnLrf0uWzSYA2NyW4C3ZoKoFTNOwGN5rlLunmdp5m
	zR3gN9cfbH8hWSHK9pVe3/agCCENFVI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fyBpAA1C;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nuNnN5G7lxPBM/st92E2e1CF0XNvXYbh26rd9gCCXLOsdiuljyAwh//uVwWxcKbClVRe7ggiUn+ZiJrqgZ670oG+W3YV9o2noX3E4atSMskyfH2H9JEQAWv3zybcAEgoLJ2Wp+93bc/n5beh3lB8wMXTjAYwpmccGvQsuAzBGVil634NAKPefYOIqv1EmiRxCC4MJq/gWMzRNcEQSfdkWj+JWQTVpk9qTu8rGElqatKI5culj4/cft+vuMznWCoQzgQLX7RSmPBg2R+PPb+Zh2lviyLDHEcSGNjdPp2N2usBzJGKu0D8IvQXU0rLSknUMMYFCv6QgfPNgA0og+7dRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1yFXpvOKp5h/UbECIU0Hjo44XD93tn2wcgMLsQ5AwI=;
 b=Ss+yX3VqYpfmmqH0r3g1tX0kSQyLBgKKbOuRD/HgHoKKemn0oQINc0r3/IGN9WMyyFhwoiVkM54wDs7EJoCGHjVQFREwd8xE5YSR7sRdp7+S9k1Ubi7HS1XVbjYsHIKFcFWLU5Dbw7zb4pJ6rYkX7H1jMNyv8ag8GjvRBIRvKGaxgg+DN1sSk9aUE4gu8Aybv4HnrEZiLzpCd/8JQ77wiptvyNR8YPJkMTGV9Y1Bvx6jP9pHQmzcmhznG1pIb6c6w/nDqlcrLXfFGLgq5c7I1fJGN/rhopBbSKMX1w/oHQtqIcSKkjSPPW5EeYJoDG8QswrMVXtI9GWY5j5N+KWMJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1yFXpvOKp5h/UbECIU0Hjo44XD93tn2wcgMLsQ5AwI=;
 b=fyBpAA1C/967/r2mIEMhMtf9kqKEgMK6eYDpw/aY/YD4P2We9oNw+3DignkgvoFWQU+bD+rpfWN4kp/zqovXV3pjSzEV4R4rVWTkiWnATSJayceOA3w8ASMvDThy873HlQX0VacK+8iO6bFIKRdKR2/TW5cwM5ZXuAeg3MatGVsikcn6vtSN5GRWuTs9l+le2F5QKm/CrtiYpJql5O/rYUW1JbbCXvYXmaVY/RPhXq1NEXQx5C+qafgaQiYo+kCXdDRuP3Y9IAJQ7JOS0hCGqR2lqPbjHKprl0Hmq4NJ8Qu5cWVETDxUF3Wr3t4lDQ8JMUqU3MNsJm98sqPOMdpYIQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6981.namprd12.prod.outlook.com (2603:10b6:806:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Fri, 24 Apr
 2026 14:49:42 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 14:49:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Date: Fri, 24 Apr 2026 10:49:38 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <A4475926-92F4-4F1F-981D-01946A4BF3DF@nvidia.com>
In-Reply-To: <f416ea70-fb70-434f-8807-6638c9787b57@kernel.org>
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-2-ziy@nvidia.com>
 <f416ea70-fb70-434f-8807-6638c9787b57@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR22CA0014.namprd22.prod.outlook.com
 (2603:10b6:208:238::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9cf331-672a-4189-93dc-08dea210b7ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8OrKo4xbEKDh8Gi/w4zL2e+K9SD/LtW9bils0T+mKDcDexlDDfhLtkZm5g35PjzkDvqXNUHieclp3D13spZjpXNA18o3kmMR7i27wJMyo24iHQ3PyRPZv9hueb1meDmnWPPL5rRilddnBOhfoxeVE/I0c0x7RCVKX7u2X2MkFdIwdW3qwqpdCnHH5NI+K4d1jlwo+3/0WnM6dEyLod7D2QLsoLd+6z1J9PC2Ys3sTBEX8r8BQ0ZsfGmcKjGXuOVCiC62ZJpWc/+t4LVyqfavzffZGX3ZkyiYOcnqmfLTRHR0s2PETo9qmaz013xuTVHmJ+Im1T6XinhR3Y934mkR+xUU4TOS/nOWyMLB2w/McphCJysN1o+R0VdhNwMhvn/14KyLsRzwCoU5OhARaZL01yxbLSTjvbJQAyWtOziVQt3deZyBy2auM4ZtwQcUMsYRmuPWy5n8SfSuOjacX+QGPksu4+Qu8z0bJKI0c993OFSp6fLo+S9JKG7mQ8LbscdNb3ueNoFE6tUUBadWueEyZHzLNoOHsXmp+a1ET9L9C/X+31W6k4Y/TrH2WMWEZWs7tRBshBrnOmYkEhvFPpKBclTuQ3QfIrC4fTGWFGBlj4LB0g+AKAsOkJRQ6DaGyZXIeawuujK9UqlBGDWm4AiOqK3R8eCGKQ3/9tEwHSkwpWh7gFVOIcs7JS8iPeJ3bPbDm3m+2+L8xFH1bvco8L6K7n7CSpJwCjzpV962aRi9nQw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUpGcjhmVkZUdzNNbTlKMXBTVmtBYkRKNW5XMUV0SldYbGIxVTZOTTRnaGxj?=
 =?utf-8?B?aWlFbDJiRHhMWnhFc3ZrREVMcGMvWENaeURvRmhPVnVVcjMwcFBuWHdaZVBv?=
 =?utf-8?B?K1NEeS9WUExkRWNRbzVvbm9jN09SZDZITXQ1NzJBY2VtVGtLRDVlNitpTi92?=
 =?utf-8?B?QlpOMjJneFNmR0ZEaUJlRGRqZzJhVUtrcElIcTJ6SW5pbGRCK0xZNXFRekpO?=
 =?utf-8?B?ZjFZWmFVMWN2RkxjYklJdzk3M3NCUng3OUhLWEljTGtxaWgzVlRPbCtJRklm?=
 =?utf-8?B?MVEyVk8wd3NYMWVXV29KWmF1QUdCa3oxZ3pua0kyQkpoN2xFR3RYcW9CL2dh?=
 =?utf-8?B?c1lVaHpwckorR3NQZFE2NTRtNkJLR0oxQklzTVYxa3lDMjhHY01wUUF0SGRy?=
 =?utf-8?B?cW5aVkZ2QTdzQ2lTVGkwTHpodURvVTFCVXc1bVpwbnFzNHd1eCtka1dFYjNt?=
 =?utf-8?B?MkJDZ3FqQlVPUVFrb1VKRURlU3h4d2c1a3dYdmtwSFV2eDduMG9HS2FQdUtH?=
 =?utf-8?B?UEFSendXS0lpOWU1MEIxNzZ1dFE5aVQ2SmdoeGFoUSthWFhRMWJoUG9MN3B6?=
 =?utf-8?B?TFZiSVJvK3NPaUZGTUp4dkphSzRQTUJGUTBsUERmdjFDRlkxUEltT3laSHNO?=
 =?utf-8?B?azZZM0RtY3NWSHB4bDJWeEtCblo4eUIzVkh0Y0ZERjlqWEVKdnNScVlzdzVE?=
 =?utf-8?B?MlRXbnhyYUxoUXBUb1lBOTJIS29hUnI2UnVITmM3ZndsRmo2RFBPZElraGlY?=
 =?utf-8?B?c01Xdll3MEFsVmVYSXhlOFBhMy9pSUh4a01vWW94anRDL2ZjNkwwSmcwc3Fj?=
 =?utf-8?B?QkJweWdKNkxPaU4wYWpPRk5Ea1M3ZE1KKzRiQVR1bmxudWVRbWpzMHJQK1R0?=
 =?utf-8?B?SmRpdGxkVFdSNExRc1AxZ004WFFhZ21OdUM3YlZxdnZoblB5N2p3N0xCdzNk?=
 =?utf-8?B?K3Vrbkh5NlgrSTU3eU5nOWlTMGNTWDI5cVUrT0dXV0dndEtJL05Zdk9SQzEx?=
 =?utf-8?B?MW9ZQ3lkTDFWNU5la09MYVRCMWN2TnBLN0lXYWdLc0ZmWXBKbVhEaE9zN1lD?=
 =?utf-8?B?aUxUVUJZcmg5bWxkdGwyU1F2YmlaeG1uSHJkU3VNcllCNmJXMkZUZStLMUts?=
 =?utf-8?B?b2JBNHZ1K3pBeXBrVjdVUCtGQmlmcnlZT0prTC9MWVRFM24zK2tVaWZGb0wv?=
 =?utf-8?B?ZTR0ck5yMkE1M1dNM0FpZnViRkdCWnR4ZjdiODJCUTlIcDFLbmZ3Y0RITjdy?=
 =?utf-8?B?ek5jNWI1WlBPR0dEd2MwZUxrak5yZjZIMDUrUnB2Rk01aE5SQUltQURiRnNJ?=
 =?utf-8?B?MnlHbGpDTllPYzc5RVM3MFB1YlJ2N0Z4d2xBcWg5T1pxUmovbGZvdGJNVmJz?=
 =?utf-8?B?VHFWd0IzWWUrYk5ONEYxbWdFWEFJK1RjdUU3NXNyTW9LNjhlazFnM3NrajI5?=
 =?utf-8?B?cmNtY1dKTEpRbG5WTWtVeTRVdjBPSHNWVWNIcVhuRjlyTFNwcjVHeDZvSnp1?=
 =?utf-8?B?TEhiRkxtQ0VYSGQ2SXo3VlRKQ2lNYmdlVGFSM3h2K1B1MDdzT2s4Q1lVQnNH?=
 =?utf-8?B?WUdMTW9NWWNZUkpYTUlOYUhQdDhVZXVkTzdBMWZaZTRnWjllWDkxcFhyc2pr?=
 =?utf-8?B?NE8xMUtqNnZqRE1uN0lLWDBCd1Bsdy9FbEVjaXZIWXhRYU5PZEN6SjRTTmxS?=
 =?utf-8?B?b1I1b09kTE0rWTZ4bW1hLytTcVRDbCtHUXBuWUZQU0NxbzVUd2NTWTNsV0pI?=
 =?utf-8?B?YUFQWVZpMHZNREtZTVBCWXB0MXlPSVVJR0tPcUdpeTNZQTNvODBlZFZyYVE3?=
 =?utf-8?B?RDdRNHRlbEx0bW01ckFCVkNRakgzUWhyZ2hGYytSbDJXTWdSMkhvSm8rcXNX?=
 =?utf-8?B?djJDMzhhR2cwRmppbjdQWUcrWDFjQUdOZGlqZFFmNUdHNnNoeXlaSU1XY0pu?=
 =?utf-8?B?dUZDZnVCQUpKdTA1eFA3clNKUzlVQjBhSGhmMzczYVpwK21PZXBXQ1pXT3hI?=
 =?utf-8?B?ZlM2cE5ETmpvS3J3NmlqZjlBeFU0WFZoSS9sbXFjOFVRY05JbW5pUzd3T1Y3?=
 =?utf-8?B?ZnJsRHFFdE1pazdwdnhEeUcveWNUWHZCK3hjWnRVbkp0eUJWTEdBSXlIUEhG?=
 =?utf-8?B?bktUWGgveUtQR0ZXM1BSN1c3ZHIzUUY5dkVyWnhDZ1p4YTFIY2Rnbm1xRjhU?=
 =?utf-8?B?YUwxT0pURGg4YXN2bHpVNHQ2K0dqSGVkTVlBV2MwSFkxNDVoZTh1Y2hzL1lI?=
 =?utf-8?B?ejFac0ozYXM0bnNkcU5aV3JGZzFxT1llWkpRV1dpM0p5NW0vRkVIbzRMT0FG?=
 =?utf-8?B?d3pOaFNCNEJiK2YrZWg2Yi93RHhDUGg5MlN1ZU4xMmYyV2FqVHM1UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9cf331-672a-4189-93dc-08dea210b7ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 14:49:42.3910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ByRcfxLPsUYMtsgfgBEs10kQHILtf6yBwXZ5D9gujzF75l7PbqizPmJ2uDDsCsr2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6981
X-Rspamd-Queue-Id: 301FC4000C
X-Rspamd-Server: rspam07
X-Stat-Signature: r4hs4g9cmb8azqhz93yi87ep9yuuwjcb
X-Rspam-User: 
X-HE-Tag: 1777042187-415147
X-HE-Meta: U2FsdGVkX1/T8WUxkSgms0O66fSgpb4lXIeR/hUg4q7q2rdN97iKqGSYaYRoBwjdOc8yHWdvzVSunVjKvVM9gOxry+BbMDXAbBEh79ipuGhFacVM7odVCqSW6lSfMKs9p6y6AJsj0eXMC8pmGjO8W/7N7o8aBfEMc6b23MS+wSPdlhM40bSunrbYJHnZJ82aJeaeULlH0Ftm8NIR5FTQNB3NdO+BeQeCIxRRcHVxqxjMGxI2TUI/cehJl7iybMNBkIwsX9CgO2SOJqpOcTFf9PI9BXDEDbDQJBE0Kw6llepJ5+b21A22wF1vzgcFBVzSLB/c5vWMfHcJpDH9qTi5VFJSjHScOCFZwaBLZI+PJ/fVVrg8o2hafF93aJR9KR9NNbLAX/dbt7R9zqzGr3pygLm1/sxxmJIhDkvJ/5+bEVRJA5v/+RpZ+gUdYo11HrmdNFcUXkDGNx28GlRxtR4f+FTWE4LgDfDs+WIUYcxbv36DojI1L71b99ZDk+LACfkiSE5qip+fZFElrmSE3b7c2Ci4YbKCHkYsRgieW0Ycn9O5b88cZ3Wp39QjwHYBBfor0Ct2pt4tuqOrJIkdosFso0CoNdJhyOxskRdEN/XqWsoFVu0TmMSUhEBqq2+8GIadPg3FRFwCGPvcykc3/U+R6k8yXfyGejaWLU9XMFwy2xO+IHZGl3uC7jLk8Nvy1b1dB7JD4Kqrk0nAKguh/uIa0uQ4m5hpIl2quq04pJ2nH2RjGeG4hAVqiwHWaWXbGTHLkYXQNO57fKnYnHUgIHR2lTNmA7k7qfHGSDfL1vkredz37XIeW5Ksufgju2TOESlksIZd13pDvWyzQU4AQZ+ZOQnFiXDqpjiKCf+tVXDxMeIaQ4X/Mv4GSX3EjL01Pqmfh8nUpFZNUBXw8oynOgxtvucyxhxREvRSFW5KK23bJELT9dIa+cz1YCXfsnvud8jKKe9Cimn1E7UptoTlWOP
 nvkTc678
 4GmGzLDKjhveZpovIRKXRgxRfvAD2lkr/49G6AvoQbJJN0lKdp/VgjYH5zlRfwfjUf5+Rfg0fXhKP2yhJYv0xXRvlYYDJnIlyUGQpg0Yi5Gwj8t1NEYThRA0uFXJa8mpVOMnu3eR5ldh9RXuhTE3C7z2Wt0w2lXCvO6zKcN6cZ14ENXH9drC4QYUCDDpHzhcjPYoIhlLDx1hLVG1Dey2i1yOBv8UruhrGygK5GSHNP+HjNEb0xCJRbYhY7wXukfrZeULR+s07uT8SioOwvvsvmesReXfm4Q3ljZvMTfX2jArZDZs59K3ct5EBTxqYMVttSTKA/cciQfpJFQ+rj4iF/kab1GbjT3ii1a7HuQDws9UPh0zNqRWBnCCTU72LRu7PqyiylG2WOfS6weMeUaqsWcAIfelUQUl9l1KZ2BBEi4DloQMey0O5i8EGUC8YLUMwIlMSTpUjw2Al5/+cSVVPCOPB2kY7KozGGKq+Rwe0iWXsdjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Apr 2026, at 8:40, David Hildenbrand (Arm) wrote:

> On 4/24/26 04:49, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>
>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>
>> Add a helper function mapping_pmd_thp_support() for FSes supporting larg=
e
>> folio with at least PMD_ORDER.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>  include/linux/pagemap.h |  9 +++++++++
>>  mm/khugepaged.c         | 10 ++++++++--
>>  2 files changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 31a848485ad9..5b4313d91137 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -513,6 +513,15 @@ static inline bool mapping_large_folio_support(cons=
t struct address_space *mappi
>>  	return mapping_max_folio_order(mapping) > 0;
>>  }
>>
>> +static inline bool mapping_pmd_thp_support(const struct address_space *=
mapping)
>> +{
>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
>> +
>> +	return mapping_max_folio_order(mapping) >=3D PMD_ORDER;
>> +}
>
> Given mapping_large_folio_support(), I wonder whether we should call that
> mapping_pmd_folio_support() ?

OK, will rename it.

>
>> +
>> +
>>  /* Return the maximum folio size for this pagecache mapping, in bytes. =
*/
>>  static inline size_t mapping_max_folio_size(const struct address_space =
*mapping)
>>  {
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 7d48d4fbd5f3..79f051eb6195 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2235,8 +2235,14 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
>>  	int nr_none =3D 0;
>>  	bool is_shmem =3D shmem_file(file);
>>
>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>> +	/*
>> +	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
>> +	 *
>> +	 * TODO: once shmem always calls mapping_set_large_folios() on its
>> +	 * mapping, the shmem check can be removed.
>> +	 */
>> +	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));
>
>
> When we always make shmem to set the mapping to enable large folios, can =
we then
> drop this special casing no?

Yes, I added the TODO above it to remind us. I have not changed the code
here to avoid a dependency on Baolin=E2=80=99s patch[1]. I will do that onc=
e
Baolin=E2=80=99s patch gets into mm-stable.

[1] https://lore.kernel.org/all/b2c7deee259a94b0d00a7c320d8d24d2c421f761.17=
76908112.git.baolin.wang@linux.alibaba.com/

>
>> +	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>>
>>  	result =3D alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>>  	if (result !=3D SCAN_SUCCEED)
>
>
> --=20
> Cheers,
>
> David


Best Regards,
Yan, Zi

