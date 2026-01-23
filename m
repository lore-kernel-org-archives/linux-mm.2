Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9113ED7789C
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 17:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFF926B0529; Fri, 23 Jan 2026 12:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD5D6B052A; Fri, 23 Jan 2026 12:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30546B052B; Fri, 23 Jan 2026 12:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD6276B0529
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:59:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 880B3B9C17
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:59:52 +0000 (UTC)
X-FDA: 84363991824.04.AF0A4DD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18EBF1A0009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:59:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AX3HRvp9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uXGA0eXT;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769191189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vadAbmAxyO9RHRbznwU7t082I/ZPDfN6Gm6p2KH2pHo=;
	b=2UUfW+CwNpcuwcoclcoIv0cnubUr4oAUyEYKkyxgNWlj0/XojBDZzVQVKRBXzQYT+1D8d3
	lEqPEjcwPt8fNtsRcVD1HmSpIhnz7/jK8yMdgQgvtU4P5xOYFxbsJ7X0lu07ktU7+nzIiu
	e8dslFP7eVSZ1xXzhSf7qHD95w5DnNk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AX3HRvp9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uXGA0eXT;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769191189; a=rsa-sha256;
	cv=pass;
	b=bd4DU/CSY82yaH+Grsk3TA9wFgp9D+YC96jqNX42ZvrAOj2uR+0Kz1N/cuNSGRJkwIdyBS
	cjGcgiBIsNzF6JQBEePhz+SpJAAU3ADrob0J/Q37ILRb4rMRjWDQSqWN8Mr2G+bBamXrog
	ImSWPnWvcfYBPtYD6mLSjLjPZN2zD2s=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NF7MYT2172801;
	Fri, 23 Jan 2026 17:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vadAbmAxyO9RHRbznwU7t082I/ZPDfN6Gm6p2KH2pHo=; b=
	AX3HRvp9jC4xdiHBvQRQbgl752G7WuiPVtmum+FU90LbvlGbOYvDKc3mWNtXYdVK
	Hdr9sqLq7OdNqswRczCs8Pf3PgugZLyweZRo1Y4G4u2R/2OiTMZ3aNBU4Tl47oEZ
	WTkOi3U+SQRD3Z8aaSg5qTvO+BGsYAdPKhRzHnvD2a5S1N4gxXienvXTXy6RdafQ
	jNh/miTJdcGgNC4y99rrt75fZ16J79NP0J9w2jyCJcyBq3BN4t/zgRArXCvLN6zp
	ms3BMVEkqv+7Dg0E+L5e9JvHbEzfbl1uvmWz5nXvR6dF3Rsuy4E1BIrnf6gmzt7f
	QCRqtxua7Gz6iiuE+L2YQw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd7c58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 17:59:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NGfH4U010697;
	Fri, 23 Jan 2026 17:59:37 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012050.outbound.protection.outlook.com [40.93.195.50])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4butv0qbq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 17:59:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=peaq52kwDTCjcrM5ZSHvbtlVtSsbMyTV6PPJk3No2sgm/jfZDoWHCe8LU31nvpS/JRhLGSaB17pwtEWIoX4gRxC7XSc8874C1T6wwvol6MTrEt0BNSNngwgrvKmsl/AonXKtZHFG3Mhpfww7ZBQOi1mt6qjWmWX73hAMMbev6pVBTYc/CRq9ljKE1j/XhW2sGSl+t/HycS7h/9wfvVvvWmmY6cCWBN1jrQ3wJTUw4KEhfIAiuk4W+QHY//5w44XEpKwsARQYKhz7aE3ClMPxFeGsvqfIfktxf6dDs511+2MP6TXZxZ/wo6Nz7DKqRVdLLR4dhtHWdLdwSnth1SKPIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vadAbmAxyO9RHRbznwU7t082I/ZPDfN6Gm6p2KH2pHo=;
 b=APD2z2ULs7wHUpcV9fXxKjNHZh2C/ZAy0elx1eqLVFFq0Ewth1fY0GwnvLzTgyuaY+7GwFkvEn9TTIMNluK0Ud8woOIzN6QxUlc8KLQzIHhik8QZKO7M3PIZW1Z0V4kK1odm4h7Dtcynl2MWE0xbFUI+ElQovLBExB9QdcJ6iMtAzGf3qawFKwl0GUpW5JoR8sjcO5cd06fvU8UZ4HzrtEogCsjv9az00MGxlKb/EtX192poPrOoP3xFK5CgURovIpK8IWfI7+PeDsZB+olKXvw56R7ugsHnRY5q3dzLtv+uWDQymydUVCxpDT1/V35/lPoFP0rD3ErGfoPM8oW5mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vadAbmAxyO9RHRbznwU7t082I/ZPDfN6Gm6p2KH2pHo=;
 b=uXGA0eXTYb/xPCwGsgHNNQuga1REzaIent6oiLK2D37zY9UXKu+f3VdJWnhzG8+iJLsfJH6nHW46JIyVeVKyP6b9jSx7XftQVSFph7ZdqC0lh9OeUb936Vy/OQcBJiykH5QuEfwoK2ZxFxTmJI95BFpmhgjUuahg3rdiW9IiLPo=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by LV0PR10MB997613.namprd10.prod.outlook.com (2603:10b6:408:345::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 17:59:34 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 17:59:34 +0000
Date: Fri, 23 Jan 2026 17:59:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
Message-ID: <c7c8158d-e360-4a29-9e48-f2b45b9ca147@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEULwMTxAzxUdzfpHe2=+umXL6HFMvydkqW=tP8mB2ewg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEULwMTxAzxUdzfpHe2=+umXL6HFMvydkqW=tP8mB2ewg@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0268.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::20) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|LV0PR10MB997613:EE_
X-MS-Office365-Filtering-Correlation-Id: a13c7e3d-c694-482e-53ef-08de5aa92abf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFduWlV6WnR1UmFvYUVxWVlIQk9Ha2VsTWtVT09YbHo0LzZXWHRvZnVNSHow?=
 =?utf-8?B?YWJjcmpXVjk5TlM2V283ZDFlMjZGL1Q4ekkxeDZtNFgyVGszMmp4L0xzMlBt?=
 =?utf-8?B?QmFhS0JIWDZybS9sUGhIS1I1dEF2R05xVkVEcG1wZ2VlcElBWG1HMkxjKzNm?=
 =?utf-8?B?TVdCQ05UdEVleW1mV3FkSGdzZy9jRzV0VUVoTFpvQU9NeGFHdFV3enVpcVVH?=
 =?utf-8?B?aElLQ1FXcEcwNiswWkdNSzNYS0NKMFA5d20zcFZGdkE3SnJsblprVFdFOFRK?=
 =?utf-8?B?cjBvUmRCUlBMYlRGK0lGUzB4MlhreVM3d1QyZDVzNXJWZFhaSGhBUnBYNEIz?=
 =?utf-8?B?SEJ4QU1qY1N3WjRyVDNrYUE3VVR5QnUyZG9iVWhkb1pKL3c5TFdsTjZKN25p?=
 =?utf-8?B?eDEyVG5Ld3RianNlakg5SktiQ1NkbkY3bmFXdkdEd3UrMUpMK3o5ZlVtNHUv?=
 =?utf-8?B?R3JFbVJmWm9HVDRTY2FRclB4eHgzdzBRTXE1aFRGdDhzOWppR2JKa2ZGRTN5?=
 =?utf-8?B?aEthdkdFRW1tcVlhbnVDTTdGTlFsUXprNTlocVoxN0thc3dWQVRzV3pjR080?=
 =?utf-8?B?TmFpMVgrUHVZUWFtQjUxb2hNR3Q4Y1hWNFZ0VEVQZXl2eVFpQTNvbEE2WHJL?=
 =?utf-8?B?TDdTcm0rdnBHUzU2V1ptVWxHYlBuTGlMdmZWSTBycnpXemNTL1c1ckRFNG4x?=
 =?utf-8?B?b3BxN3JtTzgvdGlxdk9KT1Y4VEFzajBZczFaTDZSRkJyNVQ3SUdxRnVkV0p2?=
 =?utf-8?B?U3VJK0lOSDdIVExBMFlPQUJ4VUFmdEtMMC92WFBHaUFtNWpPOFFTUUM1S2ty?=
 =?utf-8?B?Vm94aitGU2lnemFXaDZNN0VDSTRlelUwVU9iWUVDbERoOUdaVGhSbEw0eGFt?=
 =?utf-8?B?QUowNk13KzBqem9ESEdBSkIxQXRwcGw0QVZsWVlERUlYeUZFT0g0bjJlbldH?=
 =?utf-8?B?Y3FyeWttTEFMTzkyamlBZ1l3ZW5iMndqUW42U1ZrMmhyZnhFNHBuZVV1dk9M?=
 =?utf-8?B?TjBXUmxvUnNhVWZ5QzNyUXlBYjlhTC8xZ1crQlZaKy9SalVJZU5oVzFUeWc3?=
 =?utf-8?B?LzZ5dnM3c3JhNktlMDZVd3Fkbk9xZEZWOWRFb1NiMnlKZmdDQTFwczJZZjlG?=
 =?utf-8?B?SW9kRElweDd5MmhjVno1RWl3NEc2YWlyMzFXQnVlZUlZcTZRM2dKSENmTGRr?=
 =?utf-8?B?K3h3MWpieXVtYmd4UTdiMXl5WlpzV2txOWVKTGZIZExSM09oR1RvUUwyTndZ?=
 =?utf-8?B?MnB0ZGVlTmVuN1ZjbVRTYUVTdDE5d0ZTaWYzWDRHUjh0bVJERXN4Uldqb1Mv?=
 =?utf-8?B?VytEWnlUZ25CWHR5QkRBN0o0OHZUay9JK1NBVlAyRFg4SkVTUXRCNGYwbXpQ?=
 =?utf-8?B?NDZ5Z0JwSitKNmtpd3ZKRlJhWUpnV3V4V3pTVmREV1RoQTNsVzQyd210cEh3?=
 =?utf-8?B?ekZHWTBWT285NDBpeStDTk9reGxabm96Rk5URThrY1JiNkpuZjM3eHNBcGZh?=
 =?utf-8?B?aHVNcDU4bXhaRGxDaisxQmpKZGVwekRiVERhSU0xb25PeE9sQStsanNqYVlo?=
 =?utf-8?B?cHA0cE5VOTh5aFlDanRYa1d2RW1DUUdPWjN2ZTVLamM5UHNPZVlNckx2cS9o?=
 =?utf-8?B?RElydlAvbXh2TnBSYUdvOTJ2ZHQ5LzJ5SzMrcjM2Q0NMaUU4MmFueWk1QXNO?=
 =?utf-8?B?emViRXk5RTJZUFlEdmNrVFRSY3ZYc3JQNGVmaVptTUJWZXdwakRINTJSblFB?=
 =?utf-8?B?ZnlxeVhjNGZ2L294YWxYdnhqUWVVZVZJeUpXbW1JNEJSV0hzdU5JeTh2bFlk?=
 =?utf-8?B?RDJsazBjNHUxOWpFQkc0VEZsM2duUUpIUW5rV3FsNXB3ZEIrUlk2UTVEVExN?=
 =?utf-8?B?QmE5OFN5a0lpRGprTk0xSXBFUWpIRC9iUThFbGtmS0FwdnZFendTTGlDSkRl?=
 =?utf-8?B?N1FYZk4za0g2eHRZc0Qvem5rdFlzOUlNTDM4dHBSSlZWaDZseGVuR2pONk1G?=
 =?utf-8?B?NStyN2lhOWFTWmd1L3BiL3Z6Sk9NWXJBUE5nWUl2VFJ5TkdBV1lVL2JISFFS?=
 =?utf-8?B?Tm55SzhmSHdTRDJmbEIvUFgxN1VJcTMrQmpqQjJjSEF1cFlMUnRmbDV5VWxh?=
 =?utf-8?Q?tsrU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHVHV3RPMExqeExuWTMrVGVaWjBaZWZSY2dFN0EyS0R2YjNHdVlGdVdyT0Rp?=
 =?utf-8?B?Mm51dE5zYStGVlNRbEhiZmZqM0plcnRHVlVqNEdxMVpHNDZmTndaVkIwQ1Iz?=
 =?utf-8?B?MktaUGsrQkh2SjNRWUMrLzBMQlhJN0YyRDIwNENheE4xMnQ4aXdmTTJzYTAz?=
 =?utf-8?B?VlhRd1VmTXNlbXZ6MmNTR1Zic3FNL01pdkhxOXQwMjA5T0pRQ0wzYUlKWlY5?=
 =?utf-8?B?SEM3WmtiaEFIb3V4cGlKMmx3N3pabFBZYmhYUW4yLzFaeTEva2NaTXVLMC9L?=
 =?utf-8?B?UldiWE9FNDNsbFlsSHlWeXZuOFV0bzRkK3AwM1BjaWE4bFBodUNaQXdPYmZk?=
 =?utf-8?B?dDFZUEsyQXJaV2JPS29hdTdoY2RWZ1JOVWVvMjMrbWwydHlJcHpNRWpPc2V0?=
 =?utf-8?B?cW5IalJIa01kalZ1Wk1OcjFyRG1jbXAyM1U5b3VsWVpOdVVxdStpay9NZWdI?=
 =?utf-8?B?bTZBTEVJTjJxUVRJRmJCMjdFbG50KzNwdSthbDlINDZTOHhUSjdaaUtSbHFN?=
 =?utf-8?B?eU11L3M2Tmh5WFJpbUZtb2IraWlEWXRqU2ZSME56Y2IzdTU0WitFbkkxaURj?=
 =?utf-8?B?d0czd3lURnpIcUttcXk0Zi9ZaFIxVnhDUkUrZEMyaUlNV3RXOFdvK0IzSFRk?=
 =?utf-8?B?ZFhuTm1TVDFDV25LK3JhUmpLcHZrNU81Nm4ydkROYm96OE5zdGZQNkE3bE1p?=
 =?utf-8?B?R1BVRG5Xek9JeVBJZEFaelAzaFpOeEFIcUNDZzRrcHBVZVE1WXBQbWd1RkJO?=
 =?utf-8?B?dkNMVXBJdHRJZ0ExRjRTVmtDMG1rdld5M3VuL2krL0xkWVJTVWJiMjJlTEcx?=
 =?utf-8?B?THBxYys1cCtzN3dRT1MwQ214OFI0ZVRxSmRwWlFMd0xCVVVhbnpvVXlzU0ds?=
 =?utf-8?B?NjIvOGdqbmRKNGpXZHFrTk1ERHo5NTcrZ0lVbmJ6RDF6RzNoWng0L3ZXQWly?=
 =?utf-8?B?THZvV2lOd1doM2lBWHh2N0JaYkNYREdWYlVnWlNxTkdYUHlrRUJ0RzJjQzhl?=
 =?utf-8?B?UE1Lc3RwamdJOGdmUFZTUUw2UXREYjhnME9HdFhpK1Y3S2pxSS96QktCOHhi?=
 =?utf-8?B?TVozWlpOVDhKZU81UUI1dkpIa1p5NDR4NmpnU2hSUWdvUjg3STdnSGFMNjl3?=
 =?utf-8?B?VlRKdVU1blNPMEFFM3Rqd09DUVhwRUYzenl4bDhZeGkyb1pLRGk1dVBnbmJt?=
 =?utf-8?B?ZUpYK2M5cEw3dkNRZHZSMVo0YWowTGZMZDRka0NlZWRnWFpXUUFPSmI5T2Ux?=
 =?utf-8?B?aWkwOUFSRVo0QUV2WDgxVjQ2QWpackd3ejBiY0ZSNGxnQWIxV0E2Z083M1RC?=
 =?utf-8?B?U0NFSFZOMVpicFJnMlBqbTk4UU1BU2V0RVV6L2xXNUpRV0NTbWFGbzE5ZjBx?=
 =?utf-8?B?L3RFczQ5TTZTQ1lmWW9PcmwzZzhwczhjemtydUtjajdsdzc5VSt4ZHFOUGgz?=
 =?utf-8?B?akw1YXRPbXFkdW83cW0vcWhkTTZwdUdxa0V1cThmQUxKcFhIVHI3KzV3RkJl?=
 =?utf-8?B?d0hFOFBocTQ4THZGQkl2d1FlTi9Sa0lsNjU0ZU5XQW81bXZlV1cxSnhvSWt5?=
 =?utf-8?B?NXNxMGtsb256emEwc3FJZkZ5bkhIRlJXR0pVbTVFN3lKM2JmaVNkVTN2NGxD?=
 =?utf-8?B?WXpaTHdwK2JNUmQ1MlpvQnlBUGljNnJmSWI2bHh6dEo3L09OMWl3VzR5SHBC?=
 =?utf-8?B?dHEzZE5oZk0vVDRWK3V1SmcvVUY4VTJMNkpsMXVEWGMyQzdqelRrekVCaWIv?=
 =?utf-8?B?REp2dzNDd3VrbEpYaWEwdFllSStvVUwyRUZSb0o2QXZqYXo5ZTZjbU5pY0Np?=
 =?utf-8?B?YlZ4NmpPYkMzYnh2MVV0MHNpa1R5ZTAvTEVMaklOcW14WkUzSmV1UTdjd2Uz?=
 =?utf-8?B?RzFMbzE0bmFBOEJzUVNwb2ZlRUd2OENnU0YvUjZiUXdsWi93ZlkxbnMvVHhV?=
 =?utf-8?B?ZEVFejdzR0I2ZVlVbUhKaDc3WWw0K1hVaTA5ZklNdWdCOVFTRUovZ2N1cFBn?=
 =?utf-8?B?SVJPTDFpUHNmRmtSazJIVjlvcFlxOHFpbGJoMUtTNDI1a1hMOUpxTDQ1LytJ?=
 =?utf-8?B?eFBnRWR2bVhtMjVBRW8rdXRjdWgrU0pRNEI5Mm1TdWxqTnl4VzF0c0ord1Yw?=
 =?utf-8?B?Z25wUUplSkdJTTQ0SDltVzhTKzFDcXM5Q2JFZFl2TnMyTTdxLzY5UllBV1hk?=
 =?utf-8?B?MUExYmdkamRSVXAwWkZUTk45YlhJS1JySFBidEdhVXRMa29TUENkS21zazNP?=
 =?utf-8?B?MWM1aXJGRzFKK1ZyL0s5RXlUam1IUUgraksrRzh3YnZ0UzVGbFBYWC9QUHpG?=
 =?utf-8?B?azNZUGhIeDhEZ3dqN0xOVW1qaW9hUEdDYzVNYmUvaHZuYXZPL2dWQzYrSEpw?=
 =?utf-8?Q?HiMg8upl2vK6dJgo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i5AdaTVh4+Dm10TdtaYMqvSDWl2j8gjJdc8PQ6W0zBQ/S3tMJuA5/nfZ0Olh+DGiF6UXsWn7D/OSl0pOXv3AbiFCAylZ+33HOPGbF4NbvNl4fLXsUfUu8peAv2lD3Lngt66TPOcXuhFwWtMxtzhFHfqWtNzHNLeamaz2EPO7UOJvyH31qZNTkJe3ahHAqaAWap/QNVIgeudgbZuXI5zIbMboY7320He9Kck/21bvdaEBHlCgbMw1OsmUIOM5lsHr0AhL1LUCuzvD9M9dz5n5fdIKHObeHi0l3/fOU6oD6GIQ+0ScF9tdiksQ9gkhXldTpjKwit4PUPCWX4nO73hoPYsCeUJ7UjuUexVnSPnPMal6BlFIpXZbLMliL9CrgWyjJYkY46y4COZLs1qtVGdL7UEabcOuLKVdudvsNadDXRzKHTq9O+4h8TCjxKHBn/ZHAynK0Cg8lDuBiPDIX8IOQi+IRrwjIbgxX7o84dXYcP00H3CSKVrfdknNZFP1c+XQNH5hIfj0gy1nrRVDFoACTsLAnklF6uALWHQg+7aSe6jPmQXFy7nM+7cdAPkkJDhTQn2Y5UJaGuARPlGLApGMvqejlwjJDecq2yiDM9gtnFE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a13c7e3d-c694-482e-53ef-08de5aa92abf
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 17:59:34.8287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TStGlO5dY5gVquNKTheKSDnlsSZY5P3KyxqMq+tdF8bcv8Yei0bcV3uzOGpd9nmKnqhcvDMTBeBF4yhnlv7RWOiqfkCTnLHKHwXvAS8dc4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230135
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=6973b70a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=rLaUndO_mI7gEzahClkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: HiDLefu-QnyXh2SIVd4Kj4kpkEng5u5D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEzNiBTYWx0ZWRfX5w/iWhCl+RhX
 cC2ZtTfjxLSzFi0QUKMpgC7EIB2WggSpAyFr2x14pc4WzUp6wc793h4CHDdrQSMXPxbTxb+wE4J
 UoEy49goX/SlrjI2a1X2QJQU+vAqQ4MWriID/mf57SGH0bALAuWBRfI62mfiNbNipFliazei4xX
 JCAwDpO/Xq/w4mEvBoP0/CDa0PC9LCh0uz0+2x5OP5EDI9qgFSncrqsKc2F9ABfMJ7REMBOxfZZ
 PI20RNkzchhb1deIwpSkm2NtTyb34sN7KElqOB0cNmOUFEIk8txkusVMIsLTqfJ0IHtQGpP4iaf
 Dwx9xciPaBTbq8geaEehkYsHt9ZMB9qVYKC6d/GnbY9RyodbC1vjMyLZdFcjzcRNeVvcFzb2asi
 iuqkCQ+n7ope2oLDP+At1isySkcZ8AAlK1XIRF+BBcaUfJTKUQWRvXn3rCm9IPy6/Tu/3vu5Q7p
 yICawqCFwQxJEoR761A==
X-Proofpoint-GUID: HiDLefu-QnyXh2SIVd4Kj4kpkEng5u5D
X-Stat-Signature: 4ozx6qjarnxywk5j7cujxmu19w4yuq51
X-Rspamd-Queue-Id: 18EBF1A0009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769191188-990996
X-HE-Meta: U2FsdGVkX1+tcjm1HZ3ODfZBSJKhTYVTf1NuViTrNi0RWIj3K3PW+8P5MCCudwoC6scNX5A6LBgVcDTBZICdRnlcIRvOa7wc4vL3sVhZLeg3Mm7u7+X2STLRRzg9RWsy91pdaZHtYS31HvFsI7PG3HdI816h6+krUN+4Fxa/YSfWAY/y8UDpIdOhHC6jtpKXSghXjBUU9w2EJ/S5QpdS96G3AKJZtLpIs+30WiAbGUu2tnhbn9TbZW/+yV4JB/BL7anxqB5w0OdaK9HgRdslsOCg62pX7YyUcgJLPlJGFMbqXfe3zdXEKhR/fKC5Bpm/VGgXM0jIRbFbgHJkAYfARz4rTkjaAOai4KVcZ2pT5PW93GquLpkHX6NgZdMWKj16GBdoT3UsMbB98Tq4RAsiuwCTw7cV6NjNWV9kBwWCQ+/WSgPue9hPRgcC4JAIgyK4RVsax2LZZDkvhba9Wfzh7Hyk4YRgsUJkhoUu4IzN8x68ebM1GVSu50UtjEpDcsoQOHoTG8zyFpqoqYHSz2AsW/63V2Dc5gpeBddjHtamEtBgZm/KYJwIR1lY00oSxJ74gCM4AbnXLaTcVNkjIOuZeMflOUVRYEaP5LuMOTBat6+Cpkt5PWeDg2HBjOHNgj0q0I5vrSLjEyA9SVCeQgrxj1pEQxep9S2wqskb6HtHvIWQFl6Wqp4RaooFxdtNDdPUY8cl5e4hTwhjolF39PFwdGMJAJVgz59cM3Cw8M10oTQVrANvo2e4AhtmJ2voRdB9ALLJKc+rx5/13hDy96IZXKCykeT1mcUSbK8rOgvAP6wL+QXXcTzXmBDGoi8BRA/hG26sLpEFI7XgzNfPCJDG7UagKz2RrugMcV8PFN2f2UspIHRGeexL0+nGX2/cWV5A5+XUOpr6xjdrwvJox+qO/qxqKPvRBAsfq36kmQzJuLyHLaAPWLRcKH3F2oYcH9Fem0WFghlEUGD9rSyh0pH
 HbTo4AA3
 Gtl1eQ3DIpORgj6U9nm/cP7i32CkJZp4xDBVhM9QR9AAo09qntJDXcBQr2I9mUI5c4g46tVUHi1/qNUQBOWpalFve4Tgt+It+fZcOiUVTDTvFvZibUjVcFxmEJE8AZ8VWqVSaiJpWNcHvz48Izb7ErEXfVWdtzTkmYwwHk+3F8jFFtwsu7cuGmXhJHvg3WhUiLJHKzdJqJk5oYMhDH/j3LlZfsGuL3P7UJ9HmofaPqHJBSj1DjQLFWEzrBMQ5UEYJ343zgwqGFyCF7sAymy05mvcSPeaV1TY6HzrvtNaK5ZxM22jxB+WIluUDdSWWoFPCHSb97frH506oE0hYm8/hmLox/N3tD7FpwE2Heg4h0KlCH+BGwLNthYkjh6g7zSYbrij5czKYS5mZdTqnUR2DbEXSf1HLBYN3Z8JPS02xBY1Z1WqbKn49fLffs64go1TU31xCKkIYXfbMq3NiMketBSbEHFnwl2vtwcV9/qgrvZHm7wBUJtTquxh9GMzHdXQydraCCZ55TMZ6XVJv8Tc1aOd/Oa/K5RCXHwVXsUhsUZ7P6ZhqD+/m/HWp72xMSgIg0wxTaBo8tOXnDIlSaf4EMJuJyZnYKXkp89dOU8DU3nWvkaj5eAXFs03s18wmLN78c1QnOCrp1CFj8WOMb1wK6JUplY21T66sWmOQeEwUKP2zfc2g8oDes54ULPJv2leSMuWllhkcCNJ3h9vV/Ur3jV7A1vx56fhpQEhBYaIC0hHiWK0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 01:41:39PM -0800, Suren Baghdasaryan wrote:
> On Thu, Jan 22, 2026 at 5:03 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an
> > error (but only when waiting for readers in TASK_KILLABLE state), and
> > having the return value be stored in a stack variable called 'locked' is
> > further confusion.
> >
> > More generally, we are doing a lock of rather finnicky things during the
> > acquisition of a state in which readers are excluded and moving out of this
> > state, including tracking whether we are detached or not or whether an
> > error occurred.
> >
> > We are implementing logic in __vma_enter_exclusive_locked() that
> > effectively acts as if 'if one caller calls us do X, if another then do Y',
> > which is very confusing from a control flow perspective.
> >
> > Introducing the shared helper object state helps us avoid this, as we can
> > now handle the 'an error arose but we're detached' condition correctly in
> > both callers - a warning if not detaching, and treating the situation as if
> > no error arose in the case of a VMA detaching.
> >
> > This also acts to help document what's going on and allows us to add some
> > more logical debug asserts.
> >
> > Also update vma_mark_detached() to add a guard clause for the likely
> > 'already detached' state (given we hold the mmap write lock), and add a
> > comment about ephemeral VMA read lock reference count increments to clarify
> > why we are entering/exiting an exclusive locked state here.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/mmap_lock.c | 144 +++++++++++++++++++++++++++++++------------------
> >  1 file changed, 91 insertions(+), 53 deletions(-)
> >
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index f73221174a8b..75166a43ffa4 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -46,20 +46,40 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
> >  #ifdef CONFIG_MMU
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > +/* State shared across __vma_[enter, exit]_exclusive_locked(). */
> > +struct vma_exclude_readers_state {
> > +       /* Input parameters. */
> > +       struct vm_area_struct *vma;
> > +       int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
> > +       bool detaching;
> > +
> Are these:
>             /* Output parameters. */
> ?

Yurp.

Oh you added the comment :) well clearly I should have, will do so.

> > +       bool detached;
> > +       bool exclusive; /* Are we exclusively locked? */
> > +};
> > +
> >  /*
> >   * Now that all readers have been evicted, mark the VMA as being out of the
> >   * 'exclude readers' state.
> >   *
> >   * Returns true if the VMA is now detached, otherwise false.
> >   */
> > -static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
> > +static void __vma_exit_exclusive_locked(struct vma_exclude_readers_state *ves)
> >  {
> > -       bool detached;
> > +       struct vm_area_struct *vma = ves->vma;
> > +
> > +       VM_WARN_ON_ONCE(ves->detached);
> > +       VM_WARN_ON_ONCE(!ves->exclusive);
> >
> > -       detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> > -                                        &vma->vm_refcnt);
> > +       ves->detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> > +                                             &vma->vm_refcnt);
> >         __vma_lockdep_release_exclusive(vma);
> > -       return detached;
> > +}
> > +
> > +static unsigned int get_target_refcnt(struct vma_exclude_readers_state *ves)
> > +{
> > +       const unsigned int tgt = ves->detaching ? 0 : 1;
> > +
> > +       return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
> >  }
> >
> >  /*
> > @@ -69,30 +89,31 @@ static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
> >   * Note that this function pairs with vma_refcount_put() which will wake up this
> >   * thread when it detects that the last reader has released its lock.
> >   *
> > - * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
> > - * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
> > - * is permitted to kill it.
> > + * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases
> > + * where we wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal
> > + * signal is permitted to kill it.
> >   *
> > - * The function will return 0 immediately if the VMA is detached, and 1 once the
> > - * VMA has evicted all readers, leaving the VMA exclusively locked.
> > + * The function sets the ves->locked parameter to true if an exclusive lock was
>
> s/ves->locked/ves->exclusive
>
> > + * acquired, or false if the VMA was detached or an error arose on wait.
> >   *
> > - * If the function returns 1, the caller is required to invoke
> > - * __vma_exit_exclusive_locked() once the exclusive state is no longer required.
> > + * If the function indicates an exclusive lock was acquired via ves->exclusive
> > + * (or equivalently, returning 0 with !ves->detached),
>
> I would remove the mention of that equivalence because with this
> change, return 0 simply indicates that the operation was successful
> and should not be used to infer any additional states. To get specific
> state the caller should use proper individual ves fields. Using return
> value for anything else defeats the whole purpose of this cleanup.

OK I'll remove the equivalency comment.

>
> > the caller is required to
> > + * invoke __vma_exit_exclusive_locked() once the exclusive state is no longer
> > + * required.
> >   *
> > - * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
> > - * may also return -EINTR to indicate a fatal signal was received while waiting.
> > + * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, the
> > + * function may also return -EINTR to indicate a fatal signal was received while
> > + * waiting.
> >   */
> > -static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
> > -               bool detaching, int state)
> > +static int __vma_enter_exclusive_locked(struct vma_exclude_readers_state *ves)
> >  {
> > -       int err;
> > -       unsigned int tgt_refcnt = VM_REFCNT_EXCLUDE_READERS_FLAG;
> > +       struct vm_area_struct *vma = ves->vma;
> > +       unsigned int tgt_refcnt = get_target_refcnt(ves);
> > +       int err = 0;
> >
> >         mmap_assert_write_locked(vma->vm_mm);
> > -
> > -       /* Additional refcnt if the vma is attached. */
> > -       if (!detaching)
> > -               tgt_refcnt++;
> > +       VM_WARN_ON_ONCE(ves->detached);
> > +       VM_WARN_ON_ONCE(ves->exclusive);
>
> Aren't these output parameters? If so, why do we stipulate their
> initial values instead of setting them appropriately?

I guess it was just to ensure correctly set up but yes it's a bit weird, will
remove.

>
> >
> >         /*
> >          * If vma is detached then only vma_mark_attached() can raise the
> > @@ -101,37 +122,39 @@ static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
> >          * See the comment describing the vm_area_struct->vm_refcnt field for
> >          * details of possible refcnt values.
> >          */
> > -       if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
> > +       if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
> > +               ves->detached = true;
> >                 return 0;
> > +       }
> >
> >         __vma_lockdep_acquire_exclusive(vma);
> >         err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
> >                    refcount_read(&vma->vm_refcnt) == tgt_refcnt,
> > -                  state);
> > +                  ves->state);
> >         if (err) {
> > -               if (__vma_exit_exclusive_locked(vma)) {
> > -                       /*
> > -                        * The wait failed, but the last reader went away
> > -                        * as well. Tell the caller the VMA is detached.
> > -                        */
> > -                       WARN_ON_ONCE(!detaching);
> > -                       err = 0;
> > -               }
> > +               __vma_exit_exclusive_locked(ves);
> >                 return err;
>
> Nice! We preserve both error and detached state information.

:)

>
> >         }
> > -       __vma_lockdep_stat_mark_acquired(vma);
> >
> > -       return 1;
> > +       __vma_lockdep_stat_mark_acquired(vma);
> > +       ves->exclusive = true;
> > +       return 0;
> >  }
> >
> >  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> >                 int state)
> >  {
> > -       int locked;
> > +       int err;
> > +       struct vma_exclude_readers_state ves = {
> > +               .vma = vma,
> > +               .state = state,
> > +       };
> >
> > -       locked = __vma_enter_exclusive_locked(vma, false, state);
> > -       if (locked < 0)
> > -               return locked;
> > +       err = __vma_enter_exclusive_locked(&ves);
> > +       if (err) {
> > +               WARN_ON_ONCE(ves.detached);
>
> I believe the above WARN_ON_ONCE() should stay inside of
> __vma_enter_exclusive_locked(). Its correctness depends on the
> implementation details of __vma_enter_exclusive_locked(). More

Well this was kind of horrible in the original implementation, as you are
literally telling the function whether you are detaching or not, and only doing
this assert if you were not.

That kind of 'if the caller is X do A, if the caller is Y do B' is really a code
smell, you should have X do the thing.

> specifically, it is only correct because
> __vma_enter_exclusive_locked() returns 0 if the VMA is detached, even
> if there was a pending SIGKILL.

Well it's a documented aspect of the function that we return 0 immediately on
detached state so I'm not sure that is an implementation detail?

I significantly prefer having that here vs. 'if not detaching then assert if
detached' for people to scratch their heads over in the function.

I think this detail is incorrect anyway, because:

	if (err) {
		if (__vma_exit_exclusive_locked(vma)) {
			/*
			 * The wait failed, but the last reader went away
			 * as well. Tell the caller the VMA is detached.
			 */
			 WARN_ON_ONCE(!detaching);
			 err = 0;
		}
		...
	}

Implies - hey we're fine with err not being zero AND detaching right? In which
case reset the error?

Except when detaching we set TASK_UNINTERRUPTIBLE? Which surely means we never
seen an error?

Or do we?

Either way it's something we handle differently based on _caller_. So it doesn't
belong in the function at all.

It's certainly logic that's highly confusing and needs to be handled
differently.

>
> > +               return err;
> > +       }
> >
> >         /*
> >          * We should use WRITE_ONCE() here because we can have concurrent reads
> > @@ -141,9 +164,11 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> >          */
> >         WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
> >
> > -       /* vma should remain attached. */
> > -       if (locked)
> > -               WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
> > +       if (!ves.detached) {
>
> Strictly speaking the above check should be checking ves->exclusive
> instead of !ves.detached. What you have is technically correct but
> it's again related to that comment:
>
> "If the function indicates an exclusive lock was acquired via
> ves->exclusive (or equivalently, returning 0 with !ves->detached), the
> caller is required to invoke __vma_exit_exclusive_locked() once the
> exclusive state is no longer required."
>
> So, here you are using returning 0 with !ves->detached as an
> indication that the VMA was successfully locked. I think it's less
> confusing if we use the field dedicated for that purpose.

OK changed.

>
> > +               __vma_exit_exclusive_locked(&ves);
> > +               /* VMA should remain attached. */
> > +               WARN_ON_ONCE(ves.detached);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -151,7 +176,12 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
> >
> >  void vma_mark_detached(struct vm_area_struct *vma)
> >  {
> > -       bool detached;
> > +       struct vma_exclude_readers_state ves = {
> > +               .vma = vma,
> > +               .state = TASK_UNINTERRUPTIBLE,
> > +               .detaching = true,
> > +       };
> > +       int err;
> >
> >         vma_assert_write_locked(vma);
> >         vma_assert_attached(vma);
> > @@ -160,18 +190,26 @@ void vma_mark_detached(struct vm_area_struct *vma)
> >          * See the comment describing the vm_area_struct->vm_refcnt field for
> >          * details of possible refcnt values.
> >          */
> > -       detached = __vma_refcount_put(vma, NULL);
> > -       if (unlikely(!detached)) {
> > -               /* Wait until vma is detached with no readers. */
> > -               if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
> > -                       /*
> > -                        * Once this is complete, no readers can increment the
> > -                        * reference count, and the VMA is marked detached.
> > -                        */
> > -                       detached = __vma_exit_exclusive_locked(vma);
> > -                       WARN_ON_ONCE(!detached);
> > -               }
> > +       if (likely(__vma_refcount_put(vma, NULL)))
> > +               return;
> > +
> > +       /*
> > +        * Wait until the VMA is detached with no readers. Since we hold the VMA
> > +        * write lock, the only read locks that might be present are those from
> > +        * threads trying to acquire the read lock and incrementing the
> > +        * reference count before realising the write lock is held and
> > +        * decrementing it.
> > +        */
> > +       err = __vma_enter_exclusive_locked(&ves);
> > +       if (!err && !ves.detached) {
>
> Same here, we should be checking ves->exclusive to decide if
> __vma_exit_exclusive_locked() should be called or not.

Ack, changed.

>
> > +               /*
> > +                * Once this is complete, no readers can increment the
> > +                * reference count, and the VMA is marked detached.
> > +                */
> > +               __vma_exit_exclusive_locked(&ves);
> >         }
> > +       /* If an error arose but we were detached anyway, we don't care. */
> > +       WARN_ON_ONCE(!ves.detached);
> >  }
> >
> >  /*
> > --
> > 2.52.0

Cheers, Lorenzo

