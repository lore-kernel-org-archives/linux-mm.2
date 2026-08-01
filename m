Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FEBAC55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 02:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0776B0093; Fri, 31 Jul 2026 22:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250FB6B0095; Fri, 31 Jul 2026 22:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140BC6B0096; Fri, 31 Jul 2026 22:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD63D6B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:17:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C840A0101
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:11 +0000 (UTC)
X-FDA: 85051088262.29.1CB03D0
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9DE0040003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rX32gj7c;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785550628;
	b=RUM94U5nq60+h7Qc0jIxQPn90qZPSCxGnHbfnzEFEzUhshvT2sDrNiJbsnRYkReo3e6sTw
	BFV9X4bYOXdp9Zp5cTNLVoM6NIdJOyS+q6eLfks4astNU4FMYZeIiHFCq0RrhcpJuxCLhc
	OvN65tjCgWLOsAHGZed4fyO+T01Kxsw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rX32gj7c;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785550628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUwOu3xJnWbNR03CHoSF1OT8W2IcPmqHhHDuDf3D5sk=;
	b=JWX+otZiugHK672fAf1OvOhE9hlwZPbGZwEDOngtGE4liGzgNumOYQXgVOvr4EisOqQC2/
	8HCbaiej7JZuJVcVqm0mL2kfr2MBCsVCYSuJug350UB1FGBjk/zgM7BFidTdWbct5nh6WB
	KdPjC5p4el6LwoFePizJexU/1VlyN8Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mpxhgll95SSqHEPzwwS2mp0qmwDxILekkLHU6UcUyo6pKUrM8ek4G/yRs9+92JB/mzW9wa0nXiaxG97EuoMQNGsV4rU2ZOG6B7KTXNWZsGRUNNrK38DQuSkvr4fiPV9AW0GMU+zonzwRtJvOq2t9n6bXeraeXlxYl76+pco9KRbYHN6ea3/KxWPYOspYBlPy4mClbKR5NJY9cQ9CYwUNWmiqn59ih/Ukdp7i2TOV0B2P4PhDDWXqHelpyP07Ad2+XywXWbWQIlQJ7t4i9LiRMU7HrnuziPgWVFGoMPii5Q6DRvIsozX848qx+l7HcH2SNEoND1jk6TCv1I3G8kDdWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUwOu3xJnWbNR03CHoSF1OT8W2IcPmqHhHDuDf3D5sk=;
 b=hXLJAp77nCLjo3s7n9OpLvk1gVTwNAe9v0J+Qr18FXY4GLvgJYk1xY4dFIhAlBHwa8h+OUP0BOvD6T4faBkIj0wUxEfWS2/JlocFT5d9GF0Ru+HBULfRs6uewl5LV83qzq+pEKCldxyvUg0BcMwqocOf5z7i7cr0Ie1TRbKjy9CHgzu+DcnyXGmzMjKqxL0zQIXF45sBwQ6dE80C2TxpNPPLIIC0wfSaR3HdLKy6HV110cEuR4aftntQjBdSGISEshSR2sTsSlmq0HY26kdZw+9J+bbYB3Htdl6I/9PoFA7aDPNjFIsYs6qK2vwia5kwH91/KLP/y7vA2BLb8zeI/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUwOu3xJnWbNR03CHoSF1OT8W2IcPmqHhHDuDf3D5sk=;
 b=rX32gj7cxJ5WmYGWzAcVHh0MdFeVez+yYsiSG9MXDBS04NqPXo7AHsRtuevP4+rrYBj83qzNEE0Uk4GoGrE/p10tMkgvkHhceg1X1eMuBTfaveNRAUD5U9gQb8wQpra/SNQCL8VgaQEx6juOTzDZpjIjh3S1xJbQNBeAkjMmsTZpFohoH2zBOKd+Lsmo88itQSPorrYSrhFbZ1sGLlhLVVpe8UBrTJzj9dmRZoz39h7z193BsuHzNBPnAfEEsT5uUlXAjEeaqexTG76W2xJz54L4UesUUCVnO/MmxUh0yndZsKQbdS5yBudCEMMmT3liPc+D45b+HvvSiSHSa7m2SA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 02:16:58 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.015; Sat, 1 Aug 2026
 02:16:57 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Jul 2026 22:13:27 -0400
Subject: [PATCH RFC 04/14] fs/crypto: stop setting PG_private on bounce
 page
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-remove-pg_private-v1-4-142c97ba3562@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 linux-fscrypt@vger.kernel.org
X-Mailer: b4 0.14.3
X-ClientProxiedBy: BL1PR13CA0204.namprd13.prod.outlook.com
 (2603:10b6:208:2be::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ff37f77-035f-417f-07f6-08deef72f6c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|56012099006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	rc9+3h2Q8KsmoFZEY8CLQMgctboCjfzWO97GmSORF0CT8RtHgmFwr/OmKQtY4jqc7MZHYSbJwH0w23rMJMnNeoSTDvhCZzvlw6W08tCSk7dea+5vCUqHesHmBSgWlcM2pJujjGBdQQCVLVNCkkHTxA8l9YqgMqkRWFrakH0FLac6j1mPDn2hCZThlJNiWLaKwuQgaSeM/niO5kZNB6ne0gET5j9wafak7BXw3/6aj23/FF4zEAe6LvdY8y/JGPeiILNkQi7gzc/TU+aoyBtXs2SyI5bdCtqOJ6sANSiciGarZgJj6+56fLff29ge8qPQTxc2KSrYLEv0eMK1I3ibeiQn52zjMKjsWjXQslFaEDmNJGMfkoNvUVqQKc/kQ4jjQniqigx5Llt0nt9B2UakAFPrcUVRFxQS0E3vpzERUkfBQwM4Wdv6N/LS5JIRnCOVbbiPHU7Z4g6AJ48ocXGKIUIkgpbiCk/ifACFguvxwbb0C4j+Oi5DunxWW8sA7Jgz33QDWby+wa0VQVZBetNOPju6Y+a1asK3pZKAqVevddyx8qQWBYYBq2TkElggSygr5L3+KHNfqZjIRjRbhrm4NMFBAjmD219jSbaptZ1bH4cCr/y5Q2aliplCN7jAkthH2VOUb13eIlsUlSbL8JwjQXVDgOG+6tPsihmctn7BEZ+97NboSaWpDyi9c9R+NC5O/VwVze3ZaNr6NO7sUqYDww==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFpTK1NNcTBVTW9pY3BNTGVKOGxlSGF2RTZKeEMxSHJYTFk0WEFPQ2Uwakdv?=
 =?utf-8?B?VGt5MWpYakRQa2FmanVPSTRqSjZqdndwMys2cVlTVEloM3JVUTZRSXJaYkJ4?=
 =?utf-8?B?VUxyVWFQZFdkelhweGNVdlg4Uk53RExxRXJvVlFPbTNkeHg5cEpPVUtoN1hm?=
 =?utf-8?B?L3FIQWtnelZ3dFVSZmhsTGRZQzFJcFVUUHlPYWpoMUYxdGpCUHFRMEhZVklh?=
 =?utf-8?B?Z1BDNkpuWXF3M0RWOTRDVXBreGtCNWFuTktkRHkwL29aWHBPTU9sbDQyZHhW?=
 =?utf-8?B?dmV5Q1JDRmxLMnlWODczR1MwZlFEVkU1cmo1d05PVSsrYUdEOExJRCthRFEy?=
 =?utf-8?B?bVo2M2xRaXV6RHl4RERFaFlINUFzekFKSEFyWk9QNWY0QTZqS2l5MUxrdThi?=
 =?utf-8?B?RzRTMS8vNDBOWG5zRTQwMGNFY0hVQnJVc0VaOEdSM0l0SkllVm4ycWRUUEVv?=
 =?utf-8?B?K0lmaTU5SVJTUlZ2eEw4aG9ycWhaSGo0RkRmQTM4cURJRjlyOWUwZU5QSGla?=
 =?utf-8?B?bmJkYk5sNkI0K0FUVFdGd3JYMTN1dEdRTzNUTklxUS9Fd2UrSVJJTWNmbU5Y?=
 =?utf-8?B?VUVSTXREL21INmlDM1VVQ29FRUdhU0lPYldCVUN6RVFlaGtLWUVVbzhDZWxv?=
 =?utf-8?B?UmcvOWVvTzByVXYvZmhmWDk3WlZ0dkVTS0g1ODdzYjFHM3JvMjlmL1piZit0?=
 =?utf-8?B?UWVPaXUrT3d2VmFhZ291MmJoSDBVMlF5b0tINDA3clRPL2x5QTllaWI2Uk9Y?=
 =?utf-8?B?dVJzeERFTkE1NzUwMEVCSzBMSU03djhOVjBQU2QyaUVva1pqZTRPWlduSE8r?=
 =?utf-8?B?ODBHVGVqbVh3K3RLbHp1NEluNmZjcFlpUHZuYU5pVlN2cVc0Y0l3Z096WEFF?=
 =?utf-8?B?MnNKU1lhUjFrRlhPNmhVdjhsSlQwb3hkZ3lSWk9xZ041YmdqUFMvLzZ4Nit1?=
 =?utf-8?B?Z2lKSWoyRWVMVmQvVFdjTm1PL2ROclVpMk8zYnRNZlFXWnQrOVVicnl1d0Jx?=
 =?utf-8?B?RFlWQkt3MWd0Z3pTUDBFMDZJZE9xNGNmeGlHRm4xRjQvOXNOcjJCamtaaGFG?=
 =?utf-8?B?TkVzZmpHL1VnSTJwTGQzbEpVTk5aRmV5RWhDVXpua1hjenFJU0Q2VFJCVDZv?=
 =?utf-8?B?MzlBNHRrVCtDT2xUOFpqbVJDcnUyU2dVckFWU3VtZWh2OEx6UXlJNXhLSzJv?=
 =?utf-8?B?djVCeEhyTzkxT0RUTmd3UDNhdllEK0JhRkhFWUZUZzJHaHdJbDZBblQwZzFC?=
 =?utf-8?B?L0xDZ012QmZ2SEhJUlVrZnhmVnBjSFlINStQOXI0MHVpbGFjZ09CQ2lESmEr?=
 =?utf-8?B?eGFIUHY1dTFpTTM0VWhZRVR5WFFtTlpzYnVIMlVINitoc09FTER1by9NMjg0?=
 =?utf-8?B?L1IzYU1xblNqaUpmeGg0VW5zdkZsSGNNLzZuVjdlN29jY3EreU5rRnl3MFNZ?=
 =?utf-8?B?UFBhUzErcWpHbGRvL1lEUUhvTVpMRUo5L3dUNDV2UjRoL2JjNllOOWJMNVA3?=
 =?utf-8?B?b1pjcGo0a05HTjd1WHZNQ3lla1NJdS9jUThwSnVoWEdwdDhDOTJiTGtDSll2?=
 =?utf-8?B?QnJLVVRmUXd0NjVKbTc3T2VRZjNtWFpBTlozWi9CRzQ1MmFnYU9FbDMvSFFk?=
 =?utf-8?B?YXorb0pkSnBZS1RKQ3VwUm5JOTlRRDcrSytjdWZNV2s3b3NPNUR3QitTMzN4?=
 =?utf-8?B?aURWa3Y0QWRUejc3WHIxV0VoVVZlcDk3K0pyTmYyaFhJVG4rMW5KZ1k0WW5Z?=
 =?utf-8?B?TVpKcTRUUkEwa09PWFFUSnBGb2xjcTFJbFZDLzI1emxiMVZkK2JnQXA3M2s5?=
 =?utf-8?B?VnhjQjFZcGhSVWdWRUZ6VlFQanA1anJEY29DMUR1R29DWlZmclAyaURIbWxJ?=
 =?utf-8?B?UG9oOUxMdW54bFlCa3U3a25MSEg1c3ZDTERzQStzNlZPV1ljb1dOSjVhcWNl?=
 =?utf-8?B?bDIyRkhuWDFZeGEwcEdCcVUwdXYrNXJqVi9hTC9iV2FYZDR0QVl2aFpYL0po?=
 =?utf-8?B?blg5UzI4NkFPSmhKMUUrUXI5ODJMaytIZHZkVmRtS29OalFZazZUbVpxSU1K?=
 =?utf-8?B?b3krNDh4M1g5VFJXM280STh0eDlUSVM1MFZvSjk5RnRnQmowZGZ2Wjk3OHUr?=
 =?utf-8?B?RHhNanVITjdkVTZKRmM0OGtSNEJpakpYcXJaYXRwVWwzanlUQWptNjRGWGNJ?=
 =?utf-8?B?MWNwY25KOGZkNXBrMlFpb2JPeU5pYXRiSHNuUVExZ3J3YVI4Y0tjRDFHOVlh?=
 =?utf-8?B?TTViRE5EMGxKUlNjS2oxSG50dmRCYmVyMHcyblVZWWV3Q21WbjNNdjFGYW9h?=
 =?utf-8?Q?MDTPMv+6eFPlj/F+jv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff37f77-035f-417f-07f6-08deef72f6c4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 02:16:57.9220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 220s4YDPoouzdPEjPn7s3urGjciLUVZqIP1zhfRedd1ltP5T3vhaKiHjrj8WWZx0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9DE0040003
X-Stat-Signature: qdkqzq5kzmnmsz6nib7akswsw8uqpipp
X-Rspam-User: 
X-HE-Tag: 1785550628-643527
X-HE-Meta: U2FsdGVkX18/nN1RLgyGFeVoCcCG33fAFgporpUOFkLowVsKcdLnffO//MtVbHaRWPzbzslZEzpD9AgI2UQLDkRQ2rVf8C5R04idP1ImqGJdc24Z4jSSQYdWqS6RC+eVxIJFOo9lbhsCARChaZfudTWYlii5aooeiBSN/zSD43IqgWv3iCfi4KV0U33VIFIl3/AEw2AfcOV06quwlLqkhgTIwFpQUSkUWfoS9Z3i549KN30wFmjhuu2JA/TBo53YhumVPO3mAs8avLoQVfQQYM8XhkkH12xtErTMeTSlTAMo7pDkxoWeMKVyyLdClOYql2TWgvcDNIWXAui+EUHX0fDKwUF90TZWuh0UCosZySlU9M9cXP5BOXpjRrh3bjGmKE46WRwjzdN2LYq+Sx8sTJfzbp7vvLSrsjq9XW5ND6sXvNqHErTuW0bv5+D1m8wGdNlz+kQTFUpEHGOebb3WLCe5KfHvic/zA/FnP/0/LKbOInZ88EVTNx7iEuV4Y/ekhAFI/AV9K6N6Q2eVcemM1Eb5a32UOwPdAqCy4YBdbYHbtWJt9ukCDMlPaZK5IlIs5OokitKOUogGQuOoiXeGxyRJm4Aft2zFWnnBubQqvcu/YZdh7XVq62nZjgCIcoYhxz2REVHVP2m9/Er2AZFd23kXNRVXN5kVUJ+C30Xhs3Esqk4cytLyXcpInUAYvO5kw38jk7g9HmUPAKPd3+zzlcJRJv+Y2Cg2QhNsKBPOOrOKbuiakpPjc6H5b2g8fQf2b27se0hdgv4s8FAIR3mnkSC5a5PtHEG6BD6asLDByMZlcfWXCe645hjuhuJ/zjvKVNcOPekAAtEYcz1SKp/VJRH+HLOzaeZT48zsqlTbJ47m14Fa4E9VFmEKaPimDiy7w/Lbs0xlySQpj4MaZBSORjZ6YkFouR+1dgxFXOPKpzMyUd3Rfx2YZvMvrJ/ygiUUo07Fiwbm1p4IZCJLJGF
 84LuNvvO
 ji8QwD03Af6xS3WeAacplW51a7xBE7+q6+Jkk3+zMrd5/Ndxe6qCdDRVtXz8YfpiNDVHEKzusU2DzqITb+lUeg1+cBCh4ejv1U7OPR+Fb6ogvCdqdmwipmuQpv3b4wYYQ5BHRIZOvb43epFO7Rrxzjf5FbZdkiY6q2FUQsbALyMl66f5XacIWoMVgqLk4I9Fl7D0aWphWKAmgbdGDSbOg7eGv3nAgJ3oTZ2J6F/GCgxn0bRb5VzRPeiLthZBIFjs0EdxwiWDJAbnuhTo+cEnBP1w1U/mbyLpL0DURSUSK/wWWx/Mew4JRY4P9qOtrGAaaCHpCthKi4Nvo0oBZDTA2VplhNV/ogDMoMeu3FyCZU5Q/uY1403Vs2pb6pxqs/MKMEdUAT23AviwfkoQ/hL/hwu3lXAOUGX2PzcisY7RFX+85+GQkjYNHFMKCjHAMPFpVCB2t5qPzIGzmdMTLuph1ZhOQvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The point to a plaintext folio is stored in page->private and cannot be
NULL, making PG_private redundant.

It prepares for a future commit that remove PG_private.

No funtional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Eric Biggers <ebiggers@kernel.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-fscrypt@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/crypto/crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 570a2231c945a..c8a98dd94650f 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -73,7 +73,6 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 	if (!bounce_page)
 		return;
 	set_page_private(bounce_page, (unsigned long)NULL);
-	ClearPagePrivate(bounce_page);
 	mempool_free(bounce_page, fscrypt_bounce_page_pool);
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
@@ -202,7 +201,6 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 			return ERR_PTR(err);
 		}
 	}
-	SetPagePrivate(ciphertext_page);
 	set_page_private(ciphertext_page, (unsigned long)folio);
 	return ciphertext_page;
 }

-- 
2.53.0


