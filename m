Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A87F5F433D4
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84D66B0089; Wed, 15 Apr 2026 21:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35A36B008C; Wed, 15 Apr 2026 21:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24D96B0092; Wed, 15 Apr 2026 21:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A305B6B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:52:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0162D1B87DB
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:52:48 +0000 (UTC)
X-FDA: 84662745258.23.D7520E5
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 17C0F140004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:52:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eypuGEjk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776304366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVodotFWQhOeR7Iz77FHIev/mfZcU4iG0XRI2/5ILn0=;
	b=FesDRHijPVjTT9+kuFFEHQ1UAxtDiY9hV447AK7rkvu9734/wZ07tOPbcmaXpYCYtGKRZw
	mBIb5Ees4uuv62FEs0CBGrvblFZmyav220RKQAYE4H6PWXH0CNbHGHS+DTAdqIaV97xXo6
	+Nt+XwbUEvbKspf2Ggm6np/xLmD77PQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776304366; a=rsa-sha256;
	cv=pass;
	b=1cNr9L1KHlbSxhCgMjtmqqUmlCNjfnRtoJDxodZb3Y9FgdtSpHMoKfEtjsFi2+H8DjQ7Aa
	sJQUsdTz7F3r8fkA87MbSt07XojHqmQXdZ7UkAwgajgzdzpx9LdRtoScEm8zTe6X8kz3oP
	p8OC63eUYw3rqbB8bdDt4/rrgWTOLHs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eypuGEjk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EujmMRMt7qIuTGvt0WsnzHLPpjfen0+omi2fywXlsnczf5DoE/kMGho90GkKq+c6ZXbJXdNMFengW2T1PbrlNf6fdrCwEgzK3VtlaxAvscWTjNXi17f3WcVd6mBnNWCRWn5nx0QyVn6awk6nuvFbJJ6RWiol0gDRQXHqWD7RpCfbGrvwO7zPCw52DQgJE3fCjPTUZBkwlrS4/N9lfPfPjhfAX3/Jp1NFqJ5jRSfwEbRN72VjxoRCwgmkFhGY14f1mYAjU0yBrZaYZQqO01lpIPz31I3nqR5P9NGYYwOEblEHgCpc2pdN1jbG6qD7gMSBTnBPpQ53PJgwG9ccr87I8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVodotFWQhOeR7Iz77FHIev/mfZcU4iG0XRI2/5ILn0=;
 b=FnI2MtgdWnZr6XBoYRcA1TfqVFin7z/9U3jmqZmtLInLIpveXD7o6spT5u0nGel5lhuLNg7MQpGBDhvPn3zT6z+0OLI2zL1bYymyyr3p7IoCng3jBnVFiI3VvkFx944kTsOLpcct4R5oIwyp3JfYuEYTrkXEWA6psluSWHdsDvZt4IopHwzvrW2Sl3jDUjHNHFyUXZPYnhXTOJy8twQEvQKH8vrNVFSIocn4eme5sc7SrbKJOOgyurHMukjcv44v9/2Wy1Kcyk/UthQeUTBYtqkJJGjhI0yh5z7/vHZJXt/ClSGrpuCuB7oP2IB2g1W41IS6ZGq+UGYwtx6Uk6RDJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVodotFWQhOeR7Iz77FHIev/mfZcU4iG0XRI2/5ILn0=;
 b=eypuGEjkbD5H1VQ5qMoh6af2/4j9te+gr1s+UKmcYg/NAZqdCmGsz6fUiUS+W2tVEdw4rjIY41/tROMJxp0wvmu2HlJxyNEsQ79o7P2fUp+h9iH2RiZYmg56wQxDrH/V5OvWF7CyOKTl8bNj5e5xt1P6Lbhnz5RdhZMlvBppQFl8g/PBN/w2FQD3WQtcS5TqJQSaKlmbcyjPT+Uj3ciQN6AZDS5QtPTWtZxAIPMVzO0azddmtj66CIy/YzmjmEZ294338IKJa/soWhHEL1h0PD5o4UacCvOqonYtnQZnSuN+UFuv2NUvhrjIT3athFHbWHX1uKUbgnWrdhAQ/ojTRg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA6PR12MB999202.namprd12.prod.outlook.com (2603:10b6:806:450::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Thu, 16 Apr
 2026 01:52:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 01:52:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, willy@infradead.org,
 akpm@linux-foundation.org, hughd@google.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
Date: Wed, 15 Apr 2026 21:52:38 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D29FD39A-50FE-4EE5-8D14-A7B40E565074@nvidia.com>
In-Reply-To: <907b3a20-52b3-4969-8456-bd3a8d2571f2@linux.alibaba.com>
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
 <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
 <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
 <16745f2b-b008-4df1-ac76-f18b4a826dbd@linux.alibaba.com>
 <4AD72E13-C4AE-4ADA-8AB2-DDB3CEE6A527@nvidia.com>
 <907b3a20-52b3-4969-8456-bd3a8d2571f2@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0043.prod.exchangelabs.com (2603:10b6:208:23f::12)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA6PR12MB999202:EE_
X-MS-Office365-Filtering-Correlation-Id: aeebb3c5-66a3-43c7-196b-08de9b5ad885
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TFQ/etHo6bIdi9SVNHZxhHbh+cCSkj1t+xzgwQk5Y25YrorMEhaycjJ23ExokYOYjP401K9pDDHckKsM5zF6UovMY5zsT1Cy2f3Brzc1HsT3vHkCncpUIvsSTibVrw7hf5jWuQCE3JHzvAHWkdra9jVHB22QDWqzgC75QrUDz1dNOnoOiowTTyJFEMpMmYxERNCViZzMCgAThtOn3DPROx83KojPzZxGvvG0oVN5Io/46Y04wZrhUEckH6Basvzgbe3piDGGc6ku/MJTJid5QshpVmsLvZC/CVGGQky1HPZPi7WNncFH3vr/QT4Mu+GyBfMl623Hmwa5//UinB/2qJ6F/W9843K4I4oJbm5xR2FDtZqARA2Sxm+Avi6wjxJXoIRHOOBUqXuxt5X0e1O0cRfGnJA2Mbs5Hg59DB7+t1v8g4Wdj7ME7eUyI7uZ8qoobzPEfBvMrwyfallfLq11A/QuUkl9FONOXs9tPVEova4yDXBd5jhV1+eqVNmd6cnKR8eLssbsxRYI9z5WAEb3vK1+hsqv1rR/moRGScgyzsNFNAkI2wFfSU5WYPxoCrkbWoKcBtbkrrmGzurdDX+DFcs9b61eASMB7A2JdaNkrXF99Sbw8sUj9CqXflyeLFtgLkYb8mgkPFCfRnDM5qs4TVeZfVtgWP+p3ARvV50YZ30K4mH0eBI+GzEih1syToD/wpYUQNRUEwKK+cdJQoJA0uzLbvxzrjVievX/taOwM9w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUhYczhuTE5wdnlwUlJJK0lCYi9vcGhUSnNBYzJlVlcrSm5ZRUF3NzRpMWw4?=
 =?utf-8?B?czFVZUwwUmVuNk5LTlJUaG5DOTFZSWtJZjRkWHJucWRaS0NiYmROUVZGL2th?=
 =?utf-8?B?ZDM4VzNzMzM2aUswUWlGSmdqUVBIMWI1MHlkU2FhV1RCWkdsejFnVVh4REJp?=
 =?utf-8?B?UVZWRDNyaXZsdG54d212UHdaUlJYOUZaeUQvWEVsVENodWU2T20zQ0wyZ1dN?=
 =?utf-8?B?RllSajRZSStKVVg5WmdWNGp2K0Jyb0gwd0R6NE05MVFtdnpqamJkZXc3Y0li?=
 =?utf-8?B?WGs0endtcHl4L0tTeVRzd3UweGhQWFFkMDREWXc4RnVIaDNpSVJ2alFLODE1?=
 =?utf-8?B?ZmcxVnhZbHM4bERLblVSdGNuN0FRanFWV1NUdUtKb0pTcGlpejBLQVdqRkp1?=
 =?utf-8?B?R3VwM2dvMDljVk1MRXNOaVhlM2JoWjJTM2dWeDRKK2xlenhBRWE1VEZxZEZz?=
 =?utf-8?B?eEN5TWQ5clZ0SlNEL1ZIaU9lNVplRTVvd3ZwVVBBVm1TM1hVc05xSGFlSit5?=
 =?utf-8?B?NEFEZjl5MjF2QWpGQ0dqVURXSEF0d1RnV2YvczJhT1ZZOU93bjhtcDdqZ2VN?=
 =?utf-8?B?K1dRVlMrMzVLeWE5N3J1clg3NFFOOUQyR0ludFJjODR3enRkR24zY1BFdzhP?=
 =?utf-8?B?bkpHRUhscmwxQ2hqQTFJOFBYSk5CYXIwWElHdFpHa3R2L0g3VkV5SWJNL2lQ?=
 =?utf-8?B?WU5kQ0E4UDI5Rk02bHQrbW83VmlxVWhpdDZuUE9nWHhzbDZVNldkK2NSTzUx?=
 =?utf-8?B?SG41WWErSW5NdUJDSWVvekxHbi9rWFIrZzhuYzhkSll2RGpyM0FiaUptTU9a?=
 =?utf-8?B?UCtHb1dXai9YTEl3azBYM3FXNXkyTHk1QjJDRHFrZCtsaEVwcGFPemVGMGRi?=
 =?utf-8?B?c2RXQWRTQm1MY1dGMG5xeDlYOTkyeWhhbHFRY0pTU1BXdzU3b3hFYkU3M2U4?=
 =?utf-8?B?dkFXUUVBZ0N6SldPUXo3VVhoMWZ5blhnZXViL1VsM2F2eFR1TzRUMkhQQ0ZD?=
 =?utf-8?B?ZWlvdXdWeHZERlpiMnlxcVBZVEp5Q1FsaHViYVR6bFdiM2FJRXloRmNCZW9r?=
 =?utf-8?B?MmU2UTNKdU15eVVOaHFKekZiMDUrdkJGNHdsbkFuVnM4dWtqY08rU0lCT1VY?=
 =?utf-8?B?bWhIOHRzS2t6aEUxSCtERWY3R2NScXptd1lHSGVDMXpMTWg1bFhQcjBwS0NM?=
 =?utf-8?B?anlSKzAwS3BYYThhbWtpaTZlSkRzNnBycCtZK05hc3ordjNnR2JpVFA0bmE0?=
 =?utf-8?B?cHU1SlFEVXc5eFV5RG1lcnA1dlpEcnVrMFZhZ2VuUUJRRDZMM2plWXN2N0tF?=
 =?utf-8?B?bUd1RkVUQ3AxS1VPR283MUVQaGpGejR2bDE4VVovaWRCaHFnL3YvTVladEEx?=
 =?utf-8?B?U1Z6QjJHaFpoa0wzcmdVUHhOUzNWczZPYUJnZ2NaVkpOb0wyRjVoaURHUG9R?=
 =?utf-8?B?OFFncTRkV0lhYlRNOVZ2TG56UVpYS2tlZUJwTzRjM1Y1UHpUU2tXa2xRMVNm?=
 =?utf-8?B?V0wrajhZNEdra3FpMk9WMzdJZnJPY2k5My9GRkFkQTF2UTU0Sk1BYWkwOTBi?=
 =?utf-8?B?UmttUkp5NDQxNVBDMnFXOFE1cEQycFlpQjk1NEVEdGVxMUNqOWNKTXhHMHRY?=
 =?utf-8?B?Wm1sNVkyYXhtSitoMGtNQnlGZUxsNHBWVTZJM081S1ZZMnRWVHJreGhOUmJ5?=
 =?utf-8?B?RjhXR0xYbURDcEZZOC95UVNSWnByUWNZODg3KzU3dkZ2dUt3VVBXQmVSblpn?=
 =?utf-8?B?MEFsZXRndlNuNTNRUVB4dFRsTGU1THJLTXZkMFFzeXBSYWpmdTdQRVpZZURh?=
 =?utf-8?B?c2xKaUM0N2tXL3JYZURPaEtoQXlHaWlkV3FieGRmdkxEUytMRmYySTE2OE1y?=
 =?utf-8?B?ZzdLeWgzWFMyS3cxbXpSd0FNTzl1LzlIOSt0YXZkS2VIT0xwYzZWdUFKZldM?=
 =?utf-8?B?QS9hQUVWakpJNnZCNStSZEEvbHBXcEV2cm9oRkpYcTE2MldIVE5PK3NDYlM4?=
 =?utf-8?B?d2djWE1XYTkwbGw5VXExRWxJVGxGMmNGMnJwRmhhaytwOXNHQmFqczF2TVlI?=
 =?utf-8?B?NDMwZHdNZHRUTmlnTVhYSjJ5ZDBBckF4V1RaVjZMS1BMT21yQjRjUGNURlFl?=
 =?utf-8?B?MUowZUZ3a1d5RnM0TU1TVGxJU3JtWWJwWDNBWXdBcW8vbjlWcE1zendkUU9M?=
 =?utf-8?B?Uk04bjVwVis5a3BORTFNKzNoelBlcUViSjVUY3RmdEVkT0pneVNJRmg3aWRm?=
 =?utf-8?B?RDZqWkhjKy85M3IrUEhnWGhyb0hRUGxyblEybTUyYVE4enhmNmowTWI2ZjJt?=
 =?utf-8?B?OVZhVW5LYnlnVW1UNDh5V2hrRGgwNjNBOTV3bHEzNVo1dTBKdVA1UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeebb3c5-66a3-43c7-196b-08de9b5ad885
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 01:52:41.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Vhv/Bkq2ZGG+4s/i6hshLpmjVRg+146nTGEzl89cxNHYsVj+C7hXEbszEh81Ivh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR12MB999202
X-Stat-Signature: xmyruf5zzsgksit4jo1io6cfzkhyxuse
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17C0F140004
X-Rspam-User: 
X-HE-Tag: 1776304365-268038
X-HE-Meta: U2FsdGVkX1/ASEifn1Ath0jMqAxnS/DkhOgjoaRSMSaPv39no9j9NNIkNtak1P80DseBge8mR+eYO9venJ5v72lpMjThoE8zftC5B8AIvz+HKFfnBkrK6LD4iNQNw6yHPw8LLTmKRNXg5nnLx9BlwucErDHPXjE0BSkKv+++PCowKQKfKz4UM6Qr+LAgbamijeS6EnB35oIxZ5sl460E8TXSlbIc06yJ6+SLqK4WPSZSwgRuwCAJM+9zFnmImJ8cuYMCr9DQIbekq5wYkt+XaYccnKM+giFtl0hsF0KXScdk7+zyZ5qh65HLuyINUUS9r6+vr/+B+UxHRsVvLWUAu6yf76xFAo86K+Fr+6nZlns8CswcCOPFZBetwo04jqRImykrQz8hheLXPPPq8NEdewUEN4JlzGnSEI1xZKHmMtMN1fBfnyNAvGh3LBuBYPAzH2CIOfqDtAQP+GZkta0BmmHhAwrq8TU4q1XNGa1WflH0fdMm02s/ClLOx/ot3vfY1bs8QbHyryvzrVLKF2LHuT5wRc09UpbIOAVASYAQo9HXyUVw6/xWm9ueUoHE0CqnXoJD8urJ7vEoKSdn1+Qox1eAbq3HTkmrAcr7jsI4DKWaOsMttwMdSMuok5ujBS30uR93lIStuIDcYKZ0H6Et4TwoPKYaE1kRB2axBpFeaW8+dFtwtJJ5O+ygTFAZfKZpZOAq93rgucvUbaAaDdcdNzERGERByEpjNrcq4OPV4yESoD4hGXPNCGCRS2QlMVAO5z4ni9sOzyCW9mUKwmZbiVvWH4WFU1K/VwPGSlugRMjY0Jcp9qZ+z1effLtNpl+YSrzH3i4uSdv7d9cRXQgJxkV6ShPCkkAeNu8nFv7XTOATR2jPG4ycRBfviECVN5/V8WNRGu/cELPTr6P97zgjpfw63Zr3dLLL4vyAU/LU1ikM8xqneq+OErMT5YyvtR1raDd+PwxYxgjCRVSyjKu
 l5zUjwPl
 tFSOcsMWKL3TcL3bsom+lWorA4n0tiAiEGgiBeGsVduwF/EOXwL1RRB50tZgrtNVpdpBfFuJIqp2m+jwsGCuirKqM3Gk3M3YVluJZoOEl2y66kUa4X9YK2+Px6Kv7+5BFTbrGVPg1Y5Lqv/Auf9Hb0UpBDZamAupgFthEfcWuzkmAJe/LV40DKe+fUwoh39GcJAta1fciw3Zqc+SJDHWN5M8R4GNOpInzCpRimXKzNhJR70qLWYWVKpTByEXE6dZNHMUFXCnsqfM34Clc5UdRyeBJn1Ld765+HFhi5ikHF4JXHIcCEEv8sZjwBBOOZf+Y8EP6rqIAV9VSm6WLGgSD7nys4sGXqE5U9/5m9AQxNhN4dlV/8XmgYLpNbiQAMd6KIjzTNFpW1SWfoyrDqyPAJI+kpdzQb1OIEpC+PngkVYNbLYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Apr 2026, at 21:45, Baolin Wang wrote:

> On 4/16/26 9:36 AM, Zi Yan wrote:
>> On 15 Apr 2026, at 21:22, Baolin Wang wrote:
>>
>>> On 4/16/26 9:11 AM, Zi Yan wrote:
>>>> On 15 Apr 2026, at 21:05, Baolin Wang wrote:
>>>>
>>>>> On 4/15/26 10:36 PM, David Hildenbrand (Arm) wrote:
>>>>>> On 4/15/26 12:05, Baolin Wang wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>>>>>>>
>>>>>>>>> Yes, that makes sense.
>>>>>>>>>
>>>>>>>>> However, it=E2=80=99s also possible that the mapping does not sup=
port large
>>>>>>>>> folios, yet anonymous shmem can still allocate large folios via t=
he
>>>>>>>>> sysfs interfaces. That doesn't make sense, right?
>>>>>>>>
>>>>>>>> That's what I am saying: if there could be large folios in there, =
then
>>>>>>>> let's tell the world.
>>>>>>>>
>>>>>>>> Getting in a scenario where the mapping claims to not support larg=
e
>>>>>>>> folios, but then we have large folios in there is inconsistent, no=
t?
>>>>>>>>
>>>>>>>> [...]
>>>>>>>>
>>>>>>>>>
>>>>>>>>> For the current anonymous shmem (tmpfs is already clear, no quest=
ions),
>>>>>>>>> I don=E2=80=99t think there will be any "will never have/does nev=
er allow"
>>>>>>>>> cases, because it can be changed dynamically via the sysfs interf=
aces.
>>>>>>>>
>>>>>>>> Right. It's about non-anon shmem with huge=3Doff.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> If we still want that logic, then for anonymous shmem we can trea=
t it as
>>>>>>>>> always "might have large folios".
>>>>>>>
>>>>>>> OK. To resolve the confusion about 1, the logic should be changed a=
s
>>>>>>> follows. Does that make sense to you?
>>>>>>>
>>>>>>> if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>>>>>>    =C2=A0=C2=A0=C2=A0=C2=A0mapping_set_large_folios(inode->i_mappin=
g);
>>>>>>
>>>>>> I think that's better.
>>>>>
>>>>> Thanks for your valuable input.
>>>>>
>>>>> But has Willy says, maybe we can just
>>>>>> unconditionally set it and have it even simpler.
>>>>>
>>>>> However, for tmpfs mounts, we should still respect the 'huge=3D' moun=
t option. See commit 5a90c155defa ("tmpfs: don't enable large folios if not=
 supported").
>>>>
>>>> Is it possible to get sbinfo->huge during tmpfs=E2=80=99s folio alloca=
tion time, so that
>>>> even if all tmpfs has mapping_set_large_folios() but sbinfo->huge can =
still
>>>> decide whether huge page will be allocated for a tmpfs?
>>>
>>> Yes, of course. However, the issue isn=E2=80=99t whether tmpfs allows a=
llocating large folios.
>>>
>>> The problem commit 5a90c155defa tries to fix is that when tmpfs is moun=
ted with the 'huge=3Dnever' option, we will not allocate large folios for i=
t. Then when writing tmpfs files, generic_perform_write() will call mapping=
_max_folio_size() to get the chunk size and ends up with an order-9 size fo=
r writing tmpfs files. However, this tmpfs file is populated only with smal=
l folios, resulting in a performance regression.
>>
>> IIUC, generic_perform_write() needs to use a small chunk if tmpfs denies=
 huge.
>> It seems that Kefeng did that in the first try[1]. But willy suggested
>> the current fix.
>>
>> I wonder if we should revisit Kefeng=E2=80=99s first version.
>>
>> [1] https://lore.kernel.org/all/20240914140613.2334139-1-wangkefeng.wang=
@huawei.com/
>
> Personally, I still prefer the current fix (commit 5a90c155defa). We shou=
ld honor the tmpfs mount option. If it explicitly says no large folios, we =
shouldn=E2=80=99t call mapping_set_large_folios(). Isn=E2=80=99t that more =
consistent with its semantics?

Filesystems wishing to turn on large folios in the pagecache should call
``mapping_set_large_folios`` when initializing the incore inode.

You mean tmpfs with huge option set is a FS wishing to turn on large
folios in the pagecache, otherwise it is a FS wishing not to have large fol=
io
in the pagecache. tmpfs with different options is seen as different FSes.

Best Regards,
Yan, Zi

