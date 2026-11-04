Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABB1606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=VZpptrcm
Received: by kanga.kvack.org (Postfix)
	id A84BF6B05B2; Wed,  4 Nov 2026 06:40:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EBF6B05B3; Wed,  4 Nov 2026 06:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6CD6B05B4; Wed,  4 Nov 2026 06:40:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 650EB6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:40:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED3401406BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:40:30 +0000 (UTC)
X-FDA: 85397243820.26.3B0E8B3
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021088.outbound.protection.outlook.com [52.101.70.88])
	by imf30.hostedemail.com (Postfix) with ESMTP id F39BA80007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:40:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=VZpptrcm;
	spf=pass (imf30.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.70.88 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793792428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEpyqlnZnD5VvYTqFQOq2w5jDINj/Ab94LVMAq5qpNk=;
	b=CnpYFkT8kibnWWiIB2G8tTovRLl27Km7OZUD0QM2MevJnqOjolQGKD92tXOIFw5WFLiELA
	rcViGF9ze/fCnTjuf9YgmH3NVvObYfo4Q6yG11dzqaqE4lNUYOzMuXCAiU8+SE3OPNQ+MS
	L/RYOh6v3r9pf8FvNZmqHcCtVvbVyXM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=VZpptrcm;
	spf=pass (imf30.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.70.88 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793792428;
	b=Ud1kBLLnR7FFQGIerUHhkQ2PXm6Bg6trIxmrdY0Onh9/Y8/TwIB8yGmVclZpNJbl5z7n1C
	QYQyPFfVO7SJp1qD1FyvgU+yPKWEaLelzUgXe7Tz6IBHDAKgNqMx3GPpZYzjwyFxudePgt
	OOOfuwl/fxXa0oe0cjgB0JQxPi0ICws=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AhoMmdRUJj5P+qSS5cR9UvmWtU5iYiwbeXLlEYOX55c9hiZCNh8cOSflqf1Ywj5+0PzRFKAoQLEthJQwYVPXm7YYu8uxwYzTQpFLhGzUpigjwc6Vi7xE+VJdbtHTGWngGt3nv4u9VoXkw3qCJAQUDqTGfLNA6Omo8ax/2fhM0t++CJgz2LL1dh8oO3vV59+HoqOZ/My61xSWZqyLTIv4EDChg2E2J+rqC+vhZLwxkyprY1LmNKGguTr2xZw1cnBZQoBg7uK4FoSwQAVbNIYRTWcUbuSRILQKCWzuG5PDnRpGTOLVcpPRuL3hamtzHDGbR3qwhIRF3LPcSxfIK7LEug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEpyqlnZnD5VvYTqFQOq2w5jDINj/Ab94LVMAq5qpNk=;
 b=IC9x1mzEFdcqMo0KwWvxRHxj5kOIiOIFrMI+Wg3o3Fu2r31wakKFHckSrB3JOLkqrtUBJokogxT6sZCcRhhPeBkvdppJyWFlmVDTnM1DkZa49CvrQoMwjKdeRZ39uYBm93EQ9VfkNRgwN3WHNxsn05HJ+WZyombsK9Fz2LKw25fir1II4XCGoJbEmug2ec7X95YZf3VQs9iML/wGlIl1LE0nEY7m7GjzL2rwtYsknbU1EaZNjvMJBLezmvN67/EqpwXjIDbdgAkgxMnW6DZ4Zw17Ik9Z+VsSeoLfCM8omB9WGZuUGUiN75L6sn7or4vv5s0Ijfx8UDxdXd3kSgeKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEpyqlnZnD5VvYTqFQOq2w5jDINj/Ab94LVMAq5qpNk=;
 b=VZpptrcmUdbrmRO2IagexqilVSYUFvzNYNK0TFUwk3+8HOtV5sdPwr9TANwpxj3j3nl+KQVxO9OGRZh5ZSp/Eo/n8FXhZXxMfMZ0WZF/1U7WFRI7ajbj6Ut/ISg0zd6xbg5vzL8Rw0rxUtc6r8ov04vHBuF6360nwPegpBT7p4Ibq58ZZaUgwoHQ+hFKMnAOm3L10PsW2nFgmzqvHCkCFrxrJogQuO75V6bB30eP9MO55VLO2XHaow47y3VHx+sPx1yjvvRK7pV3ZCCa17l0h+bEw6wPyjVzYPJmqjDMvPlv+npAPaEthMb6P/1fOCViDQfGaXBpBI8KAXatQ6jBFA==
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9)
 by AM8PR08MB5698.eurprd08.prod.outlook.com (2603:10a6:20b:1c6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Wed, 4 Nov 2026
 11:40:23 +0000
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8]) by AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8%4]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 11:40:23 +0000
Message-ID: <dd966816-a83d-47ea-8faf-bf80d3b2642e@virtuozzo.com>
Date: Wed, 4 Nov 2026 12:40:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm/huge_memory: copy file THPs at fork like
 copy_present_ptes() does
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-2-66f00b7a564c@virtuozzo.com>
 <8c164738-8025-482f-828a-3f919150a930@kernel.org>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <8c164738-8025-482f-828a-3f919150a930@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0020.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::9) To AS2PR08MB9075.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ff::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR08MB9075:EE_|AM8PR08MB5698:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c75a77a-1e0c-41b7-7d78-08df3a6869b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|921020|261028144727099003|261022075727099003|261026121527099003|261009223027099003|4143699003|56012099006|261022105027099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	du0WDII6tD1QtRG4Es493qUpdO0KTSKmDc83kboGkEgcTaXsuDczK5pjicAldwOk8vOIxDHCyeHcHbrQCl0LS8urebhLUuO8L5qu8+GCPmy0TMPJ4jOZZfR6ywf/7aQLofJ2OZSxqe8rg10UIeCAIoyvHhsFRZhT103KHHtYfDKK/yRl11xLpMNQIvwfdxeYBTaEfjCIpO+ksVoXUNteIuLXSIsAQ0gcA3VAx33HX7Rl4IR6mNOwbKZJ2h1LE7owuAQOR0LPMCZUUqs10of8RvQWTdOc/wsMEMCbpfZFcTaafeJzZLr7vzF4N7+pVOgPjBJwgig+9FguzuaHPX72/M+exZbswMIu2Rh4S72TXnwaGnMB8l/jLBgoL/44hxBzx3dRYjW3AZ9UdoyUYihutvwpyU6rYVMUYXpAA3x6F1OoCiwXXLnfaoL2kTV5tEnhZyjIF+WDx5WUE2eAiBwXwONzcieXOR8UquqGll0cOqB52op09OqO46JNmzSKYb6rB5RO+se4KzRkeI0nZEWXgFFA68ngaIZB7sZfjZUeBXc1C56UOl2cPHyDJmEmt+yMvxnK4jW79nQyFYlav9sZDuvPPsexKoq2KYNqRksrlbOPliDXatu3WDaCysvdiphDD+hpsjMeu6qG91s3+bk5zlJ2fXiVbkyobnjiLwMjYlSqVd0pR+khBi8dxik9TiT8t+dSAKIsyERwMlRap3RuYQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9075.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(921020)(261028144727099003)(261022075727099003)(261026121527099003)(261009223027099003)(4143699003)(56012099006)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Smw5V1RNTnVUa0sxTkQ1VytJQkdtaFBpemZVOGNaemZhMEl6RjZZdTlnV1Yv?=
 =?utf-8?B?aUZyWFpYcEFqOUxtb3ZjcTc3Vkt1dHF1UENTM3JJSTNoaEg4akU0VDVpZGhY?=
 =?utf-8?B?QmxQVm5yY1ByNzkyOFNFaCtBV3Y5RytTaER1Q3VhMUhMcFV2R0ZKTjI5ZEh3?=
 =?utf-8?B?S1FLdjBxR000Z2p3NU5xd3h2cEpPUXgvc2ZWMlhRUjdEZndpU0w2Z2pRa3hn?=
 =?utf-8?B?NFYzOXF0YzRRU2VoaEZrNkFRSzVMN3JRZ1V3Z0gxdGx6dU1KKzJSYitwWmI2?=
 =?utf-8?B?eUU5SzFTcm9UbE1iOTFzODhEZThOVTBGb0hybUE4cWh4UEYzTVZlNTRiNzYr?=
 =?utf-8?B?ZGVsbGdyS2t0a1M5TjVZSHVobGRmcXFMUFBkaGJSaU1JZ3pEK3FMQnRTVnEv?=
 =?utf-8?B?RjQ4djEvRUtNZVJ2blFuUlZxVDZ6WGoxdXM4LzhVakp5RVU0MlZvaUVPbUN3?=
 =?utf-8?B?b1VYZE9BQ3RRVEZvMWlyNDYrSXIzTTA4WWxGN3hSb2p3RmZhQWZ2WkxMSlJW?=
 =?utf-8?B?SUp5NklYOXJhY0lNMVRTcUM3MXFLcVZyOGdaZzdsbFNDOVRxdkt3c0dydmlP?=
 =?utf-8?B?S3l1QVRTZW1BQnIxUENBYXA4SGsycHZpY2RBcS9WclRhcDhlbkIwS0tKVjAy?=
 =?utf-8?B?dEk5SEtxWkpScVdKanJ0V3FvWU1MNkNFenVCdzM3MUhUQThpQmZra21xQjNQ?=
 =?utf-8?B?NkRHS20wZHhuODJWZTQvaFIySDhCaWs4enQwL1U4dUdtbVpqcjNSdDdZKzVz?=
 =?utf-8?B?NmFSeEZhbHAvTTV2bER4eWgxYTVBckpyQ2xRRjBFRDh2aEREVTFQTEZkd2VT?=
 =?utf-8?B?UkhKWDRNQlFLbDU5cDRXVjg3TS9Lc2lHR0MwcVJHR3puQmlvVGQ2Q1ZKOEUv?=
 =?utf-8?B?S0l3NGZpcEh0Z1J4UlN4L0NaWGpFeGdjOUhqSUxIdlBtR1BQS1FYU1AyekdW?=
 =?utf-8?B?UWprcDRLbmYxYjhjNXlnUUEyTXMrMHlPMHgrcHkrT2lKbDhaaHc2RmNvUlFY?=
 =?utf-8?B?bVk4OG81ZTdqcFBRNytpYVUvc25ReUdOY3htMm9pTSs5SUE4RHVTMTFsNndV?=
 =?utf-8?B?TFZUdXlWTUdlWjFJQnNsSWVOZ1NPOTArOHluMndYODQrdTdZNFFzcmZtdmdR?=
 =?utf-8?B?SjlRekpCRnZOT2tucUdMMDlCYlYwV1Z3SDlYRTZHYkZtZkZyNUhZZ1RMSjEx?=
 =?utf-8?B?eXBUOEluU25YNlpVS2I5WTYxcDdORzBrWFpmZ3ZxSStpOERIOEozb29WclhN?=
 =?utf-8?B?MGg5U1VjV0lzbTk0Y3p1THNGSHMwd1hMQk9YeC91YXltd2JGaEJocXBCTFRn?=
 =?utf-8?B?RnhPaCtpMEN1WDZSUzFKSmJVdUxTOVhaNUtuWXZXUWdpYTVZVk1aYitMdW1m?=
 =?utf-8?B?c0lXQ0FuNzlzYXBpNUhuSEtJWFBObUJzNFVCU3VtRitLOXpDUTFCMzJ5Zllh?=
 =?utf-8?B?bmxNWDZxQ3pNRlo2SExKTTRkWTZJRXhlaXd3NW5WZVBsRXljMHpYVVJENlo2?=
 =?utf-8?B?OEp6M0lRak1Va2Q0dkFuTTFhMU5paUZSM2pPd09hNlFwdDFjOElpNTl0RmFq?=
 =?utf-8?B?Wm1iWjhFbkxERENTSmVRTFVxVFNFdjdwVXBSNy9TMHBkQ2szNFkyZytDNnlU?=
 =?utf-8?B?Z2xBTVhBYlIrRzZqYlIyZmhOZXRicnl6VXpXbkU5V1I1L1lFWnNaeURCQ3pv?=
 =?utf-8?B?eXhwdmk0T2gydk1PaUU4OEsydzJuY210eDBIOTdURHRCd00xaFJsMnczaFcv?=
 =?utf-8?B?eGhlcnFyQXlRWUMzVURubW94V2xDVkFNWXIwT1I5eVhRQXJJbnl0azRrNVFE?=
 =?utf-8?B?eFBNc2JkaHFaUXVPa3N1T3oyMUVKSmMxNlV4bnZwUG9WZUNDMHRvK3BMQ0ZR?=
 =?utf-8?B?Wjl1dFNzVXRiL2M1dGlVWmxJUnNxR2ZFcVdQYmM2RElJdndhZGlnTWpjLzNr?=
 =?utf-8?B?SU5zZEVOYnFmOWQ5bm1vVXMzOENSNEdYVlA0WWVBZVRzazh6SzFUWnY5Ylo3?=
 =?utf-8?B?S0Z0UW51cEs2bEx5alZuQnpDUGR0U1RiTzgxMUJtQ2JSTG1aVmtQMk9EeVF2?=
 =?utf-8?B?ZlFacXY2cDFvM2U5eTdPRkNmeHRBa09jaGpoK1lWK0taUVJyeVR2WVhvRVp0?=
 =?utf-8?B?RzJQSXpGU1RDeEsyRng1YUhRR0kvTm5rdldxbU55S3NndEp2NzlFYzA2a0ZN?=
 =?utf-8?B?RndLOHlTZUlYL3BURWhLYVJQMnBKMGNtR1p4V2I2ZlZqcWNoZ3ZoUVdSQmRJ?=
 =?utf-8?B?cXl6SzRJbmh4dTdXei8xRENnYjlmeEc0aGxTQjJNQkhyRnFOSlhoK2lhbWx0?=
 =?utf-8?B?VkFjQkh5bVpNRTVwMVpxZUhHOGdMbEtOZWVFenhMOGhhRGZHUzhxZz09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c75a77a-1e0c-41b7-7d78-08df3a6869b2
X-MS-Exchange-CrossTenant-AuthSource: AS2PR08MB9075.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 11:40:23.5671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3eSZaW3NPD/Cs6l241/n5QE/ciGrsPY7UyL0q7Y7hd+U4YcOmwUhdzmRxXvq+3EqPEfjCb6Wcstp1mYUw5ziQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5698
X-Stat-Signature: baxjybkod9f1ye8ud5faywa4m17ayg76
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F39BA80007
X-HE-Tag: 1793792427-926081
X-HE-Meta: U2FsdGVkX18dhjuXkitucfqFThPj5qz+dQKLxN9fNX2EHHh86neofiwYGJk6BLFuo8aI/VmlneUefWiVZRrkCLUVwokywVi5AXuahedM46zm+i6Sbk3fVHLxJO64TAdq8gZiZsDguLixrAgEX35+Kj29mifksydRVuFpG89fG16NBHW16TGWvGr7aNI0UbJbb34vCE+aagKpv/uxWnrfxGha0ax3eNbSDUrS3Vjf4UKbgKlj8rLNAh2kbwv2ZNX3vxvdGxClEc+5eUbxMUY+Bz/Rxg3TNLjJZQSS0BtkUmsSI0jf5eO/DWsQCm5CtkJzLSSHSXG8xS8ocIRv7eZ7gA9s/B9Fczpcx/t0BMOeKJfiL2eIy3rcdUxpoGFkNpKRnxlNM3NgCa61BDnPEdlSxZ/RASqP9Z3vlDkHC5/1aWmO1/AYz7WKLivdLT+Rcai8whIrbNPVfZVKfcrwLOhl9KLSG+HRxY/UXGVjpPSC03wfVNzQF9uAQuUt4fkr141bjtuqdn9onLTZ8UljABjsLnJqTogvk5ReYovPmm+nrKpCHXJLyjSznOA3T4ZaMAIsbxz5VL14vLh2DEIZv1u2tzGYgyeQtBoknB26Eq6nxww0tHGSqCs916ep5GmHkX5ayBNU7Crqg1CLtvDXSaUI9yn2hPoBhkmCa/6KjqtQs2O94sUmZPSb8hgpbq8nazfRs56AwxMZp/R1g/ayTOliTl9hNkLcF5riJ3oKJhe3v1uLOKSgTfh/z+XgC07CtRqFfyV+UrLhsS8MTdZ2xwcS9ZbiLOhw9g6tip1AHnctJdn0vwd3Yck1cbjOes8QjDzpCXXQSfOQWadALiTCnbyJ7Lt8nw+WQ0RfofRME5v1m790EoH9jqa23zYnSMn5DpS0e12xwdohGRRN8W60zDoh950pE8PztC9hMabLfIQ+E9kT8rHiOTlOfcYHl7smge4cjN1mCQj7EIOZGlvsLTW
 GlpPpjVw
 xK8kfdtegWdfsc0thIZZc+Q1iWVVl8AkY79b8fCv46SNTsr6gANcJ7nWyyjNHrqi/QH6ENeGNYjy12ZKWcixDm2a3t6DTimJJHzvYXXMMu2dznAYu1Fg8NAXGKKSXCniHibCiEe92kFZFen8v2/1Gz1p70aBueYqT8XFomo9lAn3Irlq8S88pU37yBoy8bRnxVHNvCJEytiDgzvGGnYwLX8NEB44/J2FLKZUlkHW98GH2AQuVoI8blt5QLld9V5dknKCIRMBQDfdaNdYwiZv3FnbJwGnCGmy8epqLN9SRPI22j3g7+VtOTcaipXBRuXDlWqGsKdpWRqiZk9yksjBDRSQ6ebTelbmx0DHHLxxCOMawkQF7YNGvPfXp/awtuEQf/iHD8ZDW2hfPzdrmhMrlu/2Ddqad2Q+kmwlmskoycrsnJIBM3MxxFCUdx2qLSEl9dJ8LMWeVeFF0Yqak/ZgODoZaOuTxvP5qjC/wb6fTFhkyyaGdSWIzMwz1f2VU2kQQQvVSYZlpxdTC2fik86zQzD5xdEd9P491rXUZSCxLKlYsPY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 15:39, David Hildenbrand (Arm) wrote:
> Any reason we're not adding the vma_is_cow_mapping() check on the
> softleaf_is_device_private_write() path as well?
>
> (I think they are all anonymous ... just for consistency)

No reason, copy_nonpresent_pte() has it there too. Will add in v5.

> Is the fallthrough:
>
>       add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR)
>
> really expected?

Yes: copy_nonpresent_pte() counts migration and device private entries
in the child's RSS as well. File folios reach it now, so the hunk below
switches it to mm_counter(src_folio), as the PTE path does.
zap_huge_pmd_folio() subtracts a file folio from mm_counter_file(), so
MM_ANONPAGES there would leave the child's counters unbalanced.

>> +    bool writable;
>
> Why do we need this variable?

It copies __copy_present_ptes(), which snapshots pte_write() before
the uffd-rwp branch. Looking at it again, that branch only rewrites an
RWP marker, which is PAGE_NONE and never writable, and vm_page_prot of
a CoW mapping has no write bit either. So the snapshot looks redundant
both here and in __copy_present_ptes().

I'd keep it in this series so the PMD path matches the PTE one, and
drop it from both in the cleanup together with the gotos.

Kiryl, does that match your understanding of the PTE path?

>> +            goto copy_pmd;
>>      }
>
> Likely we should clean this up later to avoid the gotos.

No problem, but let's do it later, on top of this series.

And on your stable question in 3/4: v5 will carry Cc: stable on patches
1-3.
The backport to 6.12 won't apply as is, so I'll do the backports once we
get a failure mail on stable re-apply attempt.
(or I need to do backports in advance? Need an advice here.)

Thanks for the review!

--
Konstantin Khorenko

