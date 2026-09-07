Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF89C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 19:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728896B0093; Mon,  7 Sep 2026 15:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1DE6B0095; Mon,  7 Sep 2026 15:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552F66B0096; Mon,  7 Sep 2026 15:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6EE6B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:52:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93A021601A9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:52:09 +0000 (UTC)
X-FDA: 85188012378.30.9882BC7
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010045.outbound.protection.outlook.com [52.101.56.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB6FFC0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:52:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o3B1UQ4z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788810726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DczhkphqlcuFVn+Ki1YPj1SipDz/mNWBnLBBPwdcTow=;
	b=DnGE88KLWX0JT6MpmlczESfSrYR4nfrXhHVAlqyT4g+zvGss3crWIjO2gb6VPi+k633VUm
	2xLZMExQ4tR5jTB3SlEYHb1rIE5bGNhk7nu14qcursMtPuxFf85eqNDRyAj77TLekbTHTY
	R9liEJfJ8vlIlSsEN9TNFP2eMfNxErI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o3B1UQ4z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788810726;
	b=Qwrk4ZOOHsCFoz2IJAqdPkCTnF0Qnc/ACPCcjQPgjviydwju2Ufh94bmNk6IbqcMSGGgNo
	Yv4svKrT+I781YqRPafcJyS27rrOmrskIzZX3FMvy9GZboI1lnd/ojcTAGfLKScO2xBeag
	No0i2zArSpLFoFq0Zmqk4eOgiXWrENc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X0qhKB/cJhR/ygxWyYmkmBywncvP0gtNWjjUDT1p90HWXfB6rkUMzZBRx4jnNz79RvtwiM/Bm15tVycufUGDe84I6TA9DqS7F4VAuXkgZHFXi1Ax6TOto7t8lshA8XT0irAWFSZAGyVwqle5ciOr7PvNLu3kBjdCdvm5xWkpxwX2TD63F0cagKI/atKcaxqWlTEt/8/EZGJ99OE/y4NJ9PABhhHVrwZTe9KcoQ9IP/gqZGgsb8BzGuaRZVgiQtz2Gb4jYQoYCOAFkCx1Jua6F6fphF/vQF7zOPIk6E4fE2MON3Bl527Fi/86IbjZ7TiLLJSq3wjSOoPuOahQICZ5PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DczhkphqlcuFVn+Ki1YPj1SipDz/mNWBnLBBPwdcTow=;
 b=qdbxo69fAHBOnMa8aJAco0pSFOaVUUagY2xFXwszos7dp+sNphoOvBlk3AmARl9z9rDEnn+jLbjctvoSmQ5GYPAg6Vj6MzrsFWDDWQy5IdU6vM42uROfNZXOY8n9WaQmFj3rC+sitmCnAPnbTBxv5WQJ1aXU5WJiTSqYWTAioykz2fmnsoqOcMKGT28Sl517I9BpqpjLxkLoSwg/zEFz6nG5+KjLVB19xnl20orNFbo0RlDBwy6ICrMvCIyjhmp7XCXF9Q9SpGSCidOYmza3JJJw31CSQrcBFcWFTw0x/84uDucqdlNmiu1FTWH3mWhlVHYUrnLzIEQCYeuKv2//5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DczhkphqlcuFVn+Ki1YPj1SipDz/mNWBnLBBPwdcTow=;
 b=o3B1UQ4zXN4i/m//BnLr/YFhfE1ak0VDbRovz6Fhxi/sB0xKR83KwELwDTyL+dyCJHY5zyg3hyY69ovT655t90yh4+KvOIqpBKkezrdFII+9/E6SqUyeR+ATtVUzT8qFUJOoWA/7gNayVHRhbu99nIpLxP8Sgw3B6ng7rgmoD3ZUw8WTsxSODbUnugZIK5H3nIAz+cXkkcgvYa1byTv7vUva8CKO65z/DKwvO2ULZWaC77nUYzN1UEFwNeOlGh37Mp6g5foSNdmF7wSMfGcl1fE4vpJ7AnQ3UBR6bGtpbcMjBbG0nVWY5Zj4odsMwQh8w6ULdVSpHEwFaP3esMPTMA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB9056.namprd12.prod.outlook.com (2603:10b6:930:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Mon, 7 Sep
 2026 19:52:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 19:52:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Sep 2026 15:52:00 -0400
Message-Id: <DL9CH8KUQ72A.XW4PWZQI4GT6@nvidia.com>
Subject: Re: [PATCH v4 10/17] mm/huge_memory: move the racy refcount check
 into unmap_folio()
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Yeoreum Yun" <yeoreum.yun@arm.com>, "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>, "Shivam Kalra"
 <shivamkalra98@zohomail.in>, "Kairui Song" <ryncsn@gmail.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-10-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-10-b532a3f20e71@tencent.com>
X-ClientProxiedBy: YQBPR0101CA0335.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB9056:EE_
X-MS-Office365-Filtering-Correlation-Id: 034d8f24-1c33-4b59-020e-08df0d197ce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|4143699003|10067099003|6133799003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	tOAO45bQD4KPE+KwVHEXL31pmnvtRWx1GgIWZi1fER5hvi+db6PK11zvWkI9CPRTNFBooXFX2kUzkLupdEx5T4s2e9OrUNdikFukhf3q/cLt31CV0hYcF6ECrvQchf81MjIUpGHo4+m1ajf2JVwyTXs5qQBpE8F76ZAnl5djvMXC+xbbjLp0u3EyZ1zTUwBAbdaFJWMozj+o+ihP8YbQSMOcqwi1pWcopOX9IweNA1Qq+pgpBjPAbjhU609BKq4RaEW6OPU9RezT79cCVCdfiVGJbI39FHSY0SaikDRHK8TUTE9xboB/pZIbRexMNTxgP8Oyqer7FfF/rsF/cRe3u3j2TlxbyCdzBnbLPtF+tf3W48O68YT9YXko6LI+lHasMFINxcxk4ADg9Benb7M1noVHCPm6lO7ZRqSQRS8IhFS3ImNphIGTvvFQC2rHibmkfRyLXsPzSQ0nZYQZLjD6K/Iddgh0r77Rd5HaavnnnXuH2+29alJDwbrzcXX3ZqToQS8w8hKvvmq/dinc161VB+b9lLzqlGHrUS224dYcprjlEmVbnZZ0gXvTV4n9blscorJenqxvUdfmNNOAXBNKuvqjqyPDMfFLHlxv8aW7uUH2ke8WHT0kk5JWUEbBxLUURZ+unnpTJECZa8Fx/9TIB/L6m/BIw5OYJGXSiCugTbQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEdSMllGczhwZWxaOGtLZDlnM05Ob2FBOUlUVnp2WFVBVzk4ak11Z2pEYkRI?=
 =?utf-8?B?SjF4M05OMVVORFNVTURCVkcwSW9JRk9JT2k2MUwyV3dYWnovRkdiaTF1VXBC?=
 =?utf-8?B?TVlZdVpOenNLSE81UGF0R2pnait4dmx2NmRyMXVoVTJHb2IrZ2VOREZHTW5B?=
 =?utf-8?B?U0tZZE15S3hWNmZ1b3VVeGJIVUhaMDlzR0NOdndsV3NWdjAySVJ2QjZnWU1z?=
 =?utf-8?B?Ry8rZ3Ywd285c2lnZlZpMFpNaExqYU4zVjYzUXIvV3o0YlBBWktSV1htWXNB?=
 =?utf-8?B?bmNIRXFvckVBcGVwWXhrVjB2SVBza3hmNUF2RGhPZUlSdmJFZlZoR0dXUHJm?=
 =?utf-8?B?RUVKYmNqeXczMEo3a0VKQmRHSlR6T2pCMEpUK1NEWW03REQxTGdIaXZBRlkv?=
 =?utf-8?B?QitVSGtJRG13MkRpOFlMOS85aXlJMWcxZDRNRHhBNUlEbnNPTlNsazVBM0V3?=
 =?utf-8?B?a282MTRFSFRENFE1eit5djdIVStKeFRXRi95VDdhdWg1VWxrZVhtcFp4ajV3?=
 =?utf-8?B?b0FzaUlVNUFWS29mbUxjTm9Vc0laNGFCcGZyam1LQWhGOFVwa0lNVlNaUTgz?=
 =?utf-8?B?dkR0VjY5ckJUbW5HdzJxQ1FCYWszQTYyOXI1bmsyL3Q3amNmcHRoZkRaTk82?=
 =?utf-8?B?dWtoKzJSc20vNlJSZU1nd1JaQ3dzdFN0SDZKeCtlVkw1ZmloVFFma2JyTHJX?=
 =?utf-8?B?WGNnamtSa1IxYTJmSXl3dlJVcGRpMHo0NmFWQjBrWlEzUnBHU2FNSkdseE1U?=
 =?utf-8?B?RlA0R2J2RW9NQ3llN1dpNFB2dUUvV05qa1N5U0lQSG16eUluODRpcHhxZlZh?=
 =?utf-8?B?dlFFdnFoYnBOZWNvOGRPSW1LUkYyUFF0eVBFSGRzRnBZK0RIekZBZWc2elVK?=
 =?utf-8?B?VXJQVDlVU0ZRL28vcnZoUlIwdmtEYTNScngwTTBxTmpyY1c0SU9UUDRmK1NS?=
 =?utf-8?B?aStTTFBIKzlHMExGOEY5UkZnZUpqVlhRVmxtODVkZWhqWlUzMDBSQVN6Q1Fs?=
 =?utf-8?B?RUI2RzYyeURBNlhLVExkc0FQc2tCRFlRYWIwQ0p2NFVQTXhrRnJFTjhNY3RO?=
 =?utf-8?B?VHZLUlRtRmZXS1htd3orOUNyR3p0TnppWGwwT2IrQ1VxMGlHRVhVMEZXc1RE?=
 =?utf-8?B?MW5QbXV0YUxMRUhFcnYwZXR3L1Q0V3ZSUzk5cEZlSmFURkJkRDQ2aWNTWDhV?=
 =?utf-8?B?aHVEalBDNUFGN1BaaXFBVXFrMzNPUy93czNCSDhMNjVTVDE0eGZZTGNxdytL?=
 =?utf-8?B?MnE2Y2lzVFhXbExBY1EzcWpqdU1aRXhkVXh3VkZQSU9OM1BCTnZueTh0ZzIx?=
 =?utf-8?B?Kys1T1lITFUvYUtIZVBWcGQ3UUo5S0RkMUtKK0VLRDdTY3ljM0l6NTZaOXlW?=
 =?utf-8?B?NFQ2UktWQ3AzSExrRmlNQUFqQW1qbXptTlJqM2gveDZWVE9nSjZIekZGTGh5?=
 =?utf-8?B?NVRnb29GejI3T0w1MXJxK3hMY0E4dGI0RWc0cy9Ed2hGRDVSdXRNWGExakdY?=
 =?utf-8?B?Tm56TUw2SmllckhaZHBIZ3F0V0VwODJ6cjQrSDNWMnRuRjFWd1lVa1BYZGFF?=
 =?utf-8?B?cXp2SzBpcFJWenk1OXFzc2hybkJ4WTUzNFpkZnl5QjQ0UHptMWoraUIxK3dN?=
 =?utf-8?B?OXFsZHY4ZlZ1L3VnQkx5R3duWmZBYTh0Tk0zL2NrcGViQlZvYUVOK29ZeEFw?=
 =?utf-8?B?dUpHK1FyS3VIWHIwNURnSDlBMUUxMmwwajk0djB3Qzk0MGY4NmdCZlQzZDg3?=
 =?utf-8?B?MUdmNE0zK041RWg3MEw1SkdOVmVhc1hmVG5HNmZKbGQxWXZPWHBuZnBwUzNI?=
 =?utf-8?B?ay9XcHgwankzUkNxNG1pckJHRE5iaU9LUDRCQ2tWMkkzZ002TDRIL0I2YVEy?=
 =?utf-8?B?czBYVGZpalUyODNMcC9WTkNuZzhXelJ4cy9iT2M2TlZuNWMxQXMwZVlVY1ZE?=
 =?utf-8?B?akhXOVlYcExhc3E0STBHR1MxTWhaRkxaQUYzY0lwdFJ2YVh4TmFJc1VDRFlF?=
 =?utf-8?B?V2JhU2U3ZStqZzBESnhuczRCcEJXd2Vjak00ZDZpZ3JQcEkxb0xPeVUzYWNW?=
 =?utf-8?B?dVg2Y1BGTk1ndnFJeTJFeFp5SEw3dWwyQ2FaYVV4WlpLaitGMDFYbFMrRFk5?=
 =?utf-8?B?Zlh2cXh4STZ5NEd0MHRudVdQTTFwUmlQU01oQ1MydjE2MStNMlBzSk55Njh0?=
 =?utf-8?B?SjgzaHRrK0prVm91Vmx4akNlT3VpOWF5VzFOdVUzNTVyL2xMTEttY0doVHVW?=
 =?utf-8?B?L1dUcTh3dzYyTUFaelMzd2RMeDdBU3p1bzFCSU12T1hwVDA1UVlJVGd3L0FZ?=
 =?utf-8?Q?XZ1bf89UjGY6w5l0FE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034d8f24-1c33-4b59-020e-08df0d197ce6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 19:52:03.1707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QwEdOQuPxtRBTYSY8CyuXcjbsaiROcvIl8Q+J4fvB2eM0D4Cs4kTMzGwIBTUscp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9056
X-Stat-Signature: 4emdhow7eu5rt8ucxmer5m7d8skjkjqs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB6FFC0003
X-Rspam-User: 
X-HE-Tag: 1788810726-684881
X-HE-Meta: U2FsdGVkX1/D55UYYDE1AW7XMlwLvOd7ArrWSBeeQNMATAV9tNVSkqzSHc8GOr8eweqdN15cuNYcIjhLUjnRpwfhzWeFgP5rih+w9MQ9P25bHp11eHhCCkh2+xHW9QvIuDldkSqOIw/6q8Td+Zj+1QMSZiKXkQGTk/5sLmn0laJHGDz/v10wabf1Q+2x1PMjYMoFP19WmYQbP/jAbk6UOtd2fXAkujSPPv6VA9oIms0nTebC8uJJUtsa3zPShv2t51xmKmrPiRc5c0oYmPnsMwrVPmmHgKGCWRupBVkDrPqW7wN9ZLq85UzozA0+S2c2ayN/BiDXwRMuXaq+OAJcuEFL37zN7U+RnqeiVt42tmrq+wYtY47+biHMC135G+iY35dCMnZ/rICLGmzHu/SNQaMLwrIyLumfsA7xnn+9SWED+YaqVj8yUJtkSj+Vlwv5pVTO+3WpxBSSz02uMYrfqxBY5KXVg2dC0SsNF9TFCANHZBG7/hwoUcaDxG3UEQ7m8l/+FrHd1KlA+ow2jr5Cg4rmtXHKsORzhC/ktMOD7IPhhKn8z6wLbC9NYjdVl7d9rGV3UU9uUGqr82lE9gMa7yWBSDE7GJ1pVgucFO6MoZD8Gi5Bj9xZL3lCF5G5gHdW6iTSs2TjKxyC4Ia445kELshqkBWnI+a0zfTwzdaXjwD4tLwZStnwY+BPINTvWB3mICSDq2ytDYNQknI31pQClau+yNZasYEQ+sGsutZU2rrF136ioLYCHGrZaMTQMsU/en3m8pyOmrAqbQncbin3lBc/AFBZJT3JJRpbnwB3nh4GlHQMedsqsZxNDZWU/F/Nt7pt2f6GW7kKYw/HtfQHAAmxtwQCmPHyitXAbbN1fGMf5loSEfb2Fzmn5iN38ZG89/xbnWXhCA2NsyMS7hvZjfpIWMxQi4Vh2gO8jnCDfvn4dVWV5koSyIF4DbvrRoPvbgsK/7ql9YMJK5bNpjJ
 Y7rpttZy
 yxmfwSz7n2cdKcf/d3TgpTes5rX8NipdE5XBhntGISxzKTDhOd74ReZ1BuO+yHTh8p0o1yyyS4mC2h6sB646aV1qmoEXNqFcU7CmqwFDKy2EhK+qM5c6Q3x57UuBLgBb+6hjQXI0+MFfQzxEFJUtBQFanC0IN+Y35+cOm1niMpoIWbOIW4aTambnprq7HwzMVqOYhr/wbcncWeQwn+JMMJFcSruHDy3b/MjUKz0R72u4F6icAwO+o4gBlL30ckxODo1OmdvjTNZANKbxQaRq/Xs7TWC6MPRkyJQTFG3TrVEVlnyzMKKWWu4YZSFv19k04/129js/9GFu3c3uD/H2g/pJPJA02ezWE7BW1lSbzNzDysezUMTkLdtfnSfotkovtQrf8mXRS8llX7LWpN5S+fBFd8LZbP4oNV+Uza+SnCEFJHI3gW9lwcxohxJGk2j8juUVTw5zIMwc5Ccu5JLWunmMndsHkjleQhMhojh5jFqiXvgwBBYr6hGOZWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 7, 2026 at 2:12 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The check only exists to avoid the expensive PMD-splitting unmap of a
> folio that cannot be split anyway.  Move it from __folio_split() into
> unmap_folio(), right before the PMD split, so both the anon and file
> split helpers get the early check without repeating it.
>
> unmap_folio() now returns -EAGAIN if the check fails and the split
> helpers propagate the error.  folio_split_unmapped() drops its own
> copy of the check: it works on already unmapped folios and the
> definitive folio_ref_freeze() in __folio_freeze_split_anon() still
> catches unexpected references.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


