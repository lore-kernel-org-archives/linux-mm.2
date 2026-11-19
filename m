Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936E2606A339
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WQSxuSP/
Received: by kanga.kvack.org (Postfix)
	id 72DE16B06B9; Thu, 19 Nov 2026 11:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704F66B06BF; Thu, 19 Nov 2026 11:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6696B06BC; Thu, 19 Nov 2026 11:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFC26B06B9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:59:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C29AE140B57
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:59:06 +0000 (UTC)
X-FDA: 85452478692.11.8A01BDD
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012032.outbound.protection.outlook.com [40.93.195.32])
	by imf31.hostedemail.com (Postfix) with ESMTP id D71552000B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:59:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="WQSxuSP/";
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795107544;
	b=KG88P5G4w8pYyXiLKCZ/tQZcPzmqdzkYLx4SEstnbSjXdii1l7HoEHZiYl8iKouk/CXn5I
	KEzpJLfjz9pWaPGlJUTGCEMVWXMjjb5/Dy7zIDQskIf1S8lhw7THnOh5Pyyr5nWYneIu6V
	BO9zaS+nHp6CIXWiQQbdDUpay2YhzL4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvVU4/1Cj/qARxFBg8GZuuICHIET6gFCCtbp8n6oy90=;
	b=mhoQmoofIfeF2S9LCuOU7HEui4IC4uie1+bq1mP1I8D1cgWcrX5wtJxf0AOqAKnINmsC9N
	QE7zMdVgybkUO0IB8zGC3yWKYLYZV76l3olPzDpwJRYaD739+e7oXD620f7W06FvOnTw9z
	fXeFVMfbwwwru85/+PsuVcRg0eJSEL8=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="WQSxuSP/";
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSkfqGmLeg/c4e/9eGPTneb+/mdWZwMWDS60tbp3aUtv5+/no1jW0yScrJjk1IEc36tKlDCgOwkkM4aEMT3PVbeZ8PelmQ1PDxWllA0I4JyKq6DVmmTNBY4KGQ5By0D5nuujRU1Z3fupFu9ljPpSx6LA54dL3F+miBHKB23+TSIZaWI8PFzY4BBNPffu1V+eBZSzALS5a/raFsySnWMWzfhUlg+LuI8NgzaiXxHXc8jt3uw0Txt4FqLZ1oP/uWIllz5mxxcEpyX+znurRhV2inYCi+aS6A3oR0NeW4GDVyRvO9rOcfoxwQWk/x3G/Io852SLdy7uCdJieBEqX6OalA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvVU4/1Cj/qARxFBg8GZuuICHIET6gFCCtbp8n6oy90=;
 b=Z8YgfFCOfzCok8LGZNN+L4rhEG6yitQ0KLzfKKXOmf1hpvrh5XvV+uXmwDEzpYoZ+t1oBZoZXRfmZpPohZa+vZMPGv2KqoW2Xd6+0RcA3wn7Nlj4adms1wY8QqYun4KTmt5oY6vQYTjYo/o2qWj6x13QS42OhiFmkoSnX2bNXNvohOM2G1qGsBkNyEM6ye+7iwCj4h+13WrcOas2wKEpXWjSYYZHcL6syjNUCrv+izlGpAoXuo/6H1vONpEGbJJnOqK0NsxLcOy0Xpwzcr5HJsLrhaAYCniZn9eQ4zbPPLsGyJ/4h2tpsuwO2yp8LFVNjMoxuTllmCx887t9j3DFFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvVU4/1Cj/qARxFBg8GZuuICHIET6gFCCtbp8n6oy90=;
 b=WQSxuSP/kdOzBb5zRpZDqWwlLG+vmQ626vOdjtTn3WkT/B9DUc1fUZuBxX2N8c2U1z/xGEbslTmKrepX6V5TEOLsVbeRTk2pftlBx2hj+QrBSbt088C48gHed2flDJW8yxAoe1YNapES0w5M3wVxUfPU/9m7gsdCP2mvoIP8fO6kBRkos46rETRdDcTrGcyRcKHKFEji5/h9YyGo7Y2qTWWAyLa6VEP6iE2mRNQPoWB1kP7XRxo+qlemxZPvhQNvZzg/qs/yvzFz90gwXHMUq5RpbiNKH0BIK6wEYc7cNT1YluJRs3bnPp6IsxWdPb7v39ugNeUgyOgLR0F28DvcUg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SAEPR12MB181460.namprd12.prod.outlook.com (2603:10b6:802:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Thu, 19 Nov
 2026 16:59:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Thu, 19 Nov 2026
 16:59:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Wilcox <willy@infradead.org>, Danilo Krummrich <dakr@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?utf-8?b?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>,
 Carlos Llamas <cmllamas@google.com>, Igor B <igor.b@beldev.am>,
 Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v22 0/6] rust: page: add page kinds
Date: Thu, 19 Nov 2026 11:58:02 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <3C3421E5-5B7D-42B8-ABD2-185375693D7A@nvidia.com>
In-Reply-To: <871p8iue5y.fsf@t14s.mail-host-address-is-not-set>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
 <37B6D4A8-288E-40E8-9214-EDABBFE49C39@nvidia.com>
 <871p8iue5y.fsf@t14s.mail-host-address-is-not-set>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SAEPR12MB181460:EE_
X-MS-Office365-Filtering-Correlation-Id: 9207eead-beb0-422a-6c5b-08df465e5cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|4143699003|5023799004|11063799006|56012099006|261021121427099003|261026121527099003|261028144727099003|261026140227099003|261022105027099003|261102123227099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	X8WHYaO/EUmcJQ56h3UKmhidkcEMbQZyme3bY0QZyO8VkubxoGNQ0j4Znrz+6KgPp8Zt/Pc+TBqixbN9N2W+byhDET56ekCdp7ujg1KIjp283GeXpnxOl/ZFlnI8CKcc/qQcrEspzrwtWCPfltsZQUqDd3e40hx4iY1jrq/+wCQFW3fvyT228maBw2Xvmkvq2vvDHunfnMui4sAK56VJvjq8Fu7QitdHlZk1Toen+gIJJ9x+tMzvBj0+ORi+G5c8ts6P+cfCm/TwLC0OPb84eOUan9mVQ95A24Ij+tvCXgfia89h417rQaBVLiMriN2Iq5Ijs8oNEyHQhQm2XZT0nXMfr+zU758GkfFwK8WKUKXXu5dtkU3mtebGVBJUiNqz0N6dvaNlGa11bq0QUY7PSs+hmIiw2Pd/17fAsKPn1ePuqsmxO//ncsyR1HT9Z0s+TjySEBuNsbWufrunwtK3pzJUSL33L5P0ajgPXo+eaJV+cxU1zfTynw/HW5byeaQAg67wuj1liC679PJhmjxfxXvc9h+kmDC9XyMQhNyA17kZSvPV9KYI22sH6Gbk08fsknN5dU2gHhcn6La29FmRNcfLTjRaaxMcV8NALK6zxdIuru3ZwLumaStKkMxD2YBYnGQzPjL58pTML8OymGhqScJgEKPtpHvMLpxcQbQPb/c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(4143699003)(5023799004)(11063799006)(56012099006)(261021121427099003)(261026121527099003)(261028144727099003)(261026140227099003)(261022105027099003)(261102123227099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzhqOGhKbEFGY2ZWdGxEdWdWTmIyTVByS0NvUHE1WmhLN1VURDFSeTZ6cXZK?=
 =?utf-8?B?YTF2NWUzNWJSa2ZuRHJUTlY1aExJeHpWdU1RZElUek1KUzZDUTBoRVNLVUlY?=
 =?utf-8?B?MFhNeUJSWDB3eHErMUM4WjNCRm9SRUh3VVNHNTYvckU2emF6KzF6Mm96WllB?=
 =?utf-8?B?aCttWlpMMEgxTis1Rmw0UkZ6bDBtVXNWenAyVzdOS24xdVhNVjdCQStNQlhs?=
 =?utf-8?B?RXVqZHMwcmRoWVJEYkRiOTlPVlg3TlFpUWx5Z2sxZ1Zjb1BONFc1emliT3NN?=
 =?utf-8?B?dGZUcTRmOXBnNXI4MTQ3WEpuWUwrZ1pKS2ZqQThYRkFIVXB1WjhLVUNiaFlm?=
 =?utf-8?B?d0VSNkl3VVZHNmZtcE9VMjhkaHRzeE9XUGFXTnIxT1Q3UDQvaGNuKzIwaWFX?=
 =?utf-8?B?aENsYTcxSDN2SU0wRUNKWWdvSEtBRjB4QkkzaXFpOGUxSDcxWkpPdXozOTRC?=
 =?utf-8?B?WU1mbXJqMXV2VEw5dzNPc2V1OXlxVmdkdTdqclc1ZmNjaDNaUkZDYndWc3l5?=
 =?utf-8?B?aVFRbVpQbHlHc0FCQ29aRUUwekZuc01jVmxsMEtKUlhVQmk3VWhNWU15ZytD?=
 =?utf-8?B?VzByRmRleFd4eFdadm1CeTRLaUtRdFk0NnJWdUVsNitVNmZwK2wxL3hNMmJH?=
 =?utf-8?B?UEswSWEyUXlBL1NxVHJQM3crd0RmbmVWUGgyUFpzZmFRSjZiR3JjWFB1L3BD?=
 =?utf-8?B?cGN5UnNtdzdibzdTRS9wYm01UnV0NzEyWmN2b1QyTFo3ZWdmSFArdDBFS1ho?=
 =?utf-8?B?YmRXZ3NZSTM5ZzNJZDdIVExwT3c2RGFELzVIdkI4RytHMHJnZzBBMVZRZXEr?=
 =?utf-8?B?UlFUSVBsSWZiWnBVOGl2ZHJMQzg3aUlrUzVIY3Z3ZWZwaEh6RUsyRFZCcWIv?=
 =?utf-8?B?TkVaaGxsNXQwenRSNXdsOEducW5qb1ljekxCcE11NmM5MW9nVElMTmxCWXJz?=
 =?utf-8?B?V29SVkllZ1pVcVIxMGJKVGkyWG84MmswTVBzcTVSU0xFa3RDZ0N4VGtaRXdt?=
 =?utf-8?B?YWVEb3l6RXhBYVYrMk81aWgrNzRHSyt0aUNnTlZza3RCMk9POTBFR3BPZXlx?=
 =?utf-8?B?U3JnV3F2VXk0UGt0dUxEZEtucmVXU2I0RWtVTHNaWENHYkdrSUpmZ3RqTlZm?=
 =?utf-8?B?V1JPbXJUSmFMcTMzTTB1VGNESFJ0VEcxTXh5bWk5SkZiMmlhcTVCelVLTGty?=
 =?utf-8?B?S0MwV1RsblF6dTVEZzUwd29BK2tIVmU2QjFHUlp1cGVDYm5MNHFLRTFsdWxx?=
 =?utf-8?B?aS9RTG9QNW51YS9WZnNQdDl1WXFuSk41T21YM05YZ2tjZmRBWE9FT2dja1RQ?=
 =?utf-8?B?TXovbi8zV2pOdmUxUW9QU1U5NGZ1TU5Qdk5TM0JLajQzeUpYL0dyOStLcUhK?=
 =?utf-8?B?dk8rWGhMNFJwcnJUVzYvTmJTZnpHeGdXdDExbVAxR2lwTTQ2bDZGMTFZOURF?=
 =?utf-8?B?VERnUmxEcEtCeEVMcUtHS1lHZXRhSC9WNEZQMFd5RVF0elRpK3UxbUpPR1hG?=
 =?utf-8?B?NG51QjVTNWJTVUJNVWJvM09Sb3JIeW5mSzZrZHY3RE9IMkhnU1I0U1VkZGFF?=
 =?utf-8?B?MGtteTYwVE9qaCtHZWRLemRXYkRna3V0NDBGdk13WDd2QzhLVFlWemk1VXdG?=
 =?utf-8?B?clZLOXRma3ZxQWhnVzVTZG5GejViUDZlTXV4Rk1RdUZLNWFhekIrQjRSWUJJ?=
 =?utf-8?B?WElnR2ZpdDliN3ZSQTRLYTVmUXlvUUxqdEZhTFArbDRyU1NKamQ2dnNIOUow?=
 =?utf-8?B?Q3pNaXpWMmtUdEJtYklGYkk1aTZaTElsYWtVT0ZGdnNwNEV0bm9NcHZnQzZJ?=
 =?utf-8?B?K3phdHE5bm1DVUQ2Tm5LdUFMU3lmQnVxcGgzSC8vaWF2eGVoN0FJaXpTU1dv?=
 =?utf-8?B?MGJOSTlCL2J4ZFhDTmt0bGVtOWx1Ym53YUcvYlNLc29QVGtNWXM1T1R2OXRN?=
 =?utf-8?B?Mmt2Sll2Vzc4Vk0yZHd3dC9BTU02NFZDSmxNdXNBRmliM1lMK1dNWFlDZTVz?=
 =?utf-8?B?RlMySTNnZ1I4U2dnTk85UkZGZi9mMWpkNThkMUpETVdNa2YxNitXdExRNXFh?=
 =?utf-8?B?QmoyYW1lMkdrbFRHeXk5MjMvR2JYaFhBYmtZb3FzZ0tLdXNoZHNtSXpuY1dO?=
 =?utf-8?B?a1dZbStLdzl2TEdlUE96K0dLbHU0azVvdlhUUG9xTEVRQlIyLzQxVTBTc0s5?=
 =?utf-8?B?WFhXZHVPa29qMlRXb21vbU9vZzhaSW1FQmVPRm5lVTVWdk9Eek90Z3NXOHpt?=
 =?utf-8?B?U1dRYk1nbit2OFZaZG9rckdpTHRXeVFwcTdsYm9pOURjSVN0R0NYWWpubmFW?=
 =?utf-8?Q?kbEH4twJTD6KOUtNWH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9207eead-beb0-422a-6c5b-08df465e5cda
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 16:58:41.2792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tB5OF5widfB7CmdCiFU77YJR6reU0Em1KstGaBOV/nJIajJa8B2L3qn1feHqO978
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAEPR12MB181460
X-Rspamd-Queue-Id: D71552000B
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: yg43yhpn43zrwrodkqgwiwo7addyjtx8
X-Rspamd-Server: rspam10
X-HE-Tag: 1795107543-23717
X-HE-Meta: U2FsdGVkX1/0UHGqkBOPD5CgPrLwv+AQIJ0EaAZViHFtwWMWLJLQw8OlhgHYlIUUxcIojcoctaePWgMMyPu9AGxsCSD99TLV1J6lDvTwKUjSOxlAPx0OsCVB6eyCzUfRa2bYsykyWmIS6GToeFwyUUBrDehaJk78825I93/BlO/eDMUWbA2ZNHMz/qBsZEWKB1vqei97sAIk+Q0H0/fFUmLgLBp0jgk2L0SP9b6SeW4o9cN1+dtAW5pYTX80mX2uzMYKduHYBY8H3aBjGtJ9nyV/bAWDI5W75mai3VHmThB1e6SU+wCo4TAQXLbd3+Wsut6OKYlf34lUzc09RaPsSIJUnvwDzl1a20gjgnoHvQc/xGpeXahJyUDlpr9StmRotonnW2LzsuZP5ZHXZe3wXjiXi+8QA0+D2/RdiLggOyCYPrhYIGA/Q0vu3HxlBJOoCEczvn3ctOZflU/HZpzn227r8g/nImJqgqFnxoTM78Gau3jor0AflCpbtda0XHcyQP8Lz51dB81OaWrG5P93IXOXh5ESz38+dsCE8lcxrAhpm0um+4TjUaeOzoq/HTR2jOwDW/OUAhJ4muis+wqaLZDqIwfKKBsR+O8Hj0Rqc+HV/VZL3w8Vln00q8ymZO6cjTKoMKWdyUXpMyKLU63arM+rIAF8FLQCnloajU1o17L1DgVC0GnyZZLAcOddtEA2Kv3Caj56wYAhcb4gW18o+2eYJiUFxFYLQqVGIW/KNDe8aPmJf4Re1zJWor2Ieo1qQPMy5WlQTnuI7aXMr2pAZxjpMOXkWBWlm94FwJh3RQdF2pWkR14Ce2pgM3dIrbHW7RXAS+2mxBWN3NtRiN3ZJUnxYudunyDZmIzFZHM/LcrbYloqgwLJUK1+XvndmMlbyHpOkkuLuXN1sLZ4TYOFpooXjB0Yn1tvtc2NlSnJt+9LjQJI0nOALYxiFfrTl56kyNdVbaS8bBz6ENVobEV
 ZtwoSeaH
 fRMn5HhFi+0AqZJmTtmubtAqmMpYBNvId5tP9+Vt4t9usF0MmtOmyFZTiiJXKGTLoUdz3DGiS4eYksjSVDLvbKlwMNNSmDcs7rFXiVVjOT2VnGlJuJGqBpguz0jtivD+zvLKV9MVI5ILQBvUjzQ/kKrZdxtU7laj+HxXEkGh62zqDfCrNP4Q0jngULgfUwID+d85Jmx18t875sNvINQdpeyBaTmeLdWsbTjzFSoOpxD/dKM1BkP6cHTnb0WrEUWUB6QVxwwJRpLA6JYpsX6o8QxQ7Z5P5d0cVBiXeCz741EHQTgoelGbHQ1oFIkfpTWCqVHpF1UmypJLX76yl3+mhfOMzDavYOmmehW9p+VPtIKjIRYUwa0qG0XUaQQR72VqojnZ+dEJMqVyKywYhw2cMaWR9Y4oYQSbmbPdItmGBerfYKi49GumiFvI+NVlGTdSCwyzrOIl3QkfM5xELtqC65NtoAe5ju72Mmh/sizrtDIklQKZaYQOyL32rYDZoz+dk0B3vkMg23URIfhn77FHO3KCOU6RpcZIbeUZjaSiJF5Kqx3g+IRR4XV0ptIUtwafUAkJojmLpzM+4T4siFyxDW811W9pBps/WTpcmCoL0PrxrXsNx7ipQPKopB9jNKLYeIPuFm9CGqvC1TciEmXcWp40iTGR+1iPiUATlNszzwWHPXZQmObPLFueYUPq77zZ6FUyWTft3CS4XfmPu6oeUlhLd9IpGjgLhwRUQot7aH0umKZl40rnTfDBKqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 18 Nov 2026, at 14:34, Andreas Hindborg wrote:

> Zi Yan <ziy@nvidia.com> writes:
>
>> On 18 Nov 2026, at 11:18, Andreas Hindborg wrote:
>>
>>> Note: The page patches were part of the `Ownable` series [1] until v21.
>>> This series continues the version numbering of that series, and it depends
>>> on v22 of that series for `Ownable`, `Owned` and the split of `RefCounted`
>>> and `AlwaysRefCounted`.
>>>
>>> Not all pages can be treated the same way. A page allocated with
>>> `alloc_pages()` is managed by the page reference count, and kernel C code
>>> routinely takes its own references to such a page. A page owned by the
>>> slab allocator must not have references taken to it, but it can still
>>> show up in places such as a bio vector. A frozen page has a reference
>>> count of zero and is exclusively owned by the party that allocated it.
>>>
>>> A single `Page` type cannot describe all of these. This series makes
>>> `Page` generic over a sealed `PageKind` that describes what is known about
>>> the page:
>>>
>>>  - `Page<Base>` is the base kind. Nothing is known about the page
>>>    beyond the validity of the `struct page`.
>>>  - `Page<RefCounted>` is the default kind. The page is managed by the
>>>    page reference count, and `Page<RefCounted>` implements
>>>    `AlwaysRefCounted`.
>>>  - `Page<Exclusive>` is a uniquely owned frozen page whose data area
>>>    follows standard Rust aliasing rules, so the data is available as
>>>    `&[u8]` and `&mut [u8]`. It is handled through
>>>    `Owned<Page<Exclusive>>` and is the first in-tree user of `Owned`.
>>>  - `Page<Frozen>` is a frozen page whose allocation is uniquely owned.
>>>    Unlike for `Page<Exclusive>`, nothing is known about who accesses the
>>>    data of the page, so the data is only available through the unsafe
>>>    raw accessors.
>>
>> Why do we need to allocate Page<Frozen> when we can allocate Page<Exclusive>?
>> To me, Page<Frozen> is an observed page state from a non-owner point
>> of view.
>
> I'm not sure we need it, which is why I added this note:
>
>  This currently has no users, but I add it here for completeness. Let's
>  discuss if we should keep it or not.
>
> The difference between the `Page<Frozen>` and `Page<Exclusive>` is that
> `Page<Exclusive>` has stronger invariants. Namely that the (physical)
> memory region of the page does not incur data races, and that the page
> not in highmem. From a Rust point of view, this allows us to obtain a
> reference to the page contents without jumping through any hoops.

But access to memory region of the page is associated with page table
mapping or IOMMU mapping (for device, and I assume devices are accessing
data via virtual addresses instead of physical addresses to avoid further
complication). It seems that you are trying to use page refcount == 0
to infer that no page table mapping exists for the page. But how about
kernel direct map? Anyone with struct page can use kmap_local*()
to get kernel direct map and access the page content. kmap_local*()
does not reject frozen pages.

>
> I do not have a user for a frozen page without these invariants, but I
> would assume there are use cases?

For the above reason, everything is Page<Frozen>?

>
>> In core-mm, a page is frozen, when its refcount == 0. The code looking
>> at the page knows the page is exclusively owned by others. If the code
>> allocates a frozen page, it will not check its refcount, because
>> the code knows it has the exclusive ownership of the page. To reflect
>> this, the code calling alloc_frozen_pages() should just get
>> Page<Exclusive>
>
> Is it always the case that users of frozen pages will use them in such a
> way that they can guarantee no races to the page contents (physical
> memory)? They cannot be mapped for DMA access or anything like that -
> that always requires a refcount?

See kmap_local*() case above.

>
>> and if the code encounters a Page<Base> and finds it has no refcount,
>> it should convert it to Page<Frozen> or there should be a method
>> that accepts PFN and return Page<Frozen> if the page of the PFN has no
>> refcount, for PFN walkers.
>
> We can add conversion functions, that makes sense.
>
>>
>> “the data” mentioned in Page<Exclusive> and Page<Frozen> is struct page
>> data or the data in the physical frame pointed by Page<...>? If it
>> is the former, is it better to use metadata?
>
> I'm referring to the actual physical memory region that the struct page
> describes.
>
>>
>> I am new to Rust, so feel free to correct me. Thanks. :)
>>
>
> I'm new to mm, I really appreciate your eyes on this.

Do you mind describing the high level workflow around Page in Rust?
From my point of view, exclusive page content access is more related
to page table (including IOMMU page table) than struct page itself.
struct page ownership is more about the metadata stored in struct
page for physical memory maintenance.

Best Regards,
Yan, Zi

