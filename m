Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D783FC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3166B00AF; Tue, 11 Aug 2026 16:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9FB6B00B1; Tue, 11 Aug 2026 16:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671C96B00B2; Tue, 11 Aug 2026 16:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 353436B00AF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:54:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB5CE401C6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:54:39 +0000 (UTC)
X-FDA: 85090192278.26.81DA6D0
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013034.outbound.protection.outlook.com [40.93.201.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id D95E140003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:54:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C4KQpVPR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786481677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HM29jd5iR6+kCGMT7OMzlvjzdVUBtfVSfgrTgtInCLA=;
	b=ndLGcrhOaecIO/bXOFAgfO56Swd5hOsf+h3otErRR0cgztX2GZQGPgfNZDY5596esQVWeE
	HDau9ltRNJZ2Q2gh/munwajY40Dt8UgfmFN91Jrf/60luXQCxERJ5QqJpeOUHrBxy/j7nP
	hP4yR2G0JymCYu7TTnQfugiouyEgEH8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C4KQpVPR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786481677;
	b=reg7QEi7BVJ1pX4ONRfWiMMVncGJIAoXWi8CoZV2gT7W02ssGYE3uDbqfog19kNEAnjd52
	Z1n9EGCyT5R8ASyapm9Q05lZRR0TBB4sEEc+Wp0olmI4PQtSAF0X3Giq+G3tz3Z3g0MHAC
	2JsO3WtpLSRYYxLX6e3RkC9w3b+Zjxc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lMYi/Fu100lnWvyXyGbs1PtGjjakWBcyQrpj+vFngdDjM7eeqja1FyQ/yC6Gdv2h5i6Rlx/MNPQMx7IxZ1zfBeagbFtkRggFX2GiyQTPj1E51fognL694MNL4/B4v6CHofcogoBOqFcB2VgKI1kwufFEWcwaOJqFMRA4H2z3PjfjFzM+NKnrPRZsVZOrcCLd2aoTdi3S5CJPhBr7jF24WiAZde+Oy2iBzNh/Kl6wFMiJAInqWA+WpLpPAiP0k6JqCY984KflK/mKZwndcGmLe+7ZzwGZ4E/ON+E+1wwiuIlGezQ0txTLop8zuLFxTSyAkKs3NIWR/2VwvZZfqAJleA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HM29jd5iR6+kCGMT7OMzlvjzdVUBtfVSfgrTgtInCLA=;
 b=wwDOKk9hbPRc7dVRRz0JLYE67YNwF68+nfiqpbX2IweN0T9ztXL7vr5ZYkJyp5q15yy8/bQ4bgYjkyWkLinKplvAxGmTHRKXgR+3XtiHlFW+mF6KurD778DPxU2BiMSHltaB72f3Z79Bf4bIN2ec0LEPIA6C9kWrD5xYi3S3H+9Vedg8ZgQq5Bn2xGmSEsskf8Edo8HtmzCh4KjyRrWCSDilcNBQvM/jIrvMBtv39i0ggq3ugX+r4TtenAhM4JZtV9G9nyImn24ueAt2dXxZbp3sURuIo2fY5DWGI6/HbNKsDya28qb1l8YNIJ7OscRW9JCspcTRdbRhGjJnfTicYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HM29jd5iR6+kCGMT7OMzlvjzdVUBtfVSfgrTgtInCLA=;
 b=C4KQpVPRninlD7WXksTGZH0dnhrdbY6Eoc8zJDvOB2qrdWxT4bw9siaJRqlbPbvC+T/QLDbmTy8zsaPGj+danScMTFVFG1Tq/gngVQqXFmYWdofAjdDK9iHlrJ4njcqX8O90lXgFvugV4NxIMANncYGDsKe5IX3gHjiLuDFXNpYUEhXRF7xmTJq15TDk5hjDvyxn+4aWK1uct8WRFjIUPInmYDALPX9C9gCFAVrqQDOo3h6CGSS8MbvNeMeISRhBvQPWgFrCSuZkibpb7FhU+zwg1X1DXmU82eyozHw+Y6G3UNgu1uzxWoMDORKjgIGXh7nWUiSOgVo/iVbCz4qgEg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB9585.namprd12.prod.outlook.com (2603:10b6:8:27e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 20:54:30 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 20:54:27 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Aug 2026 16:54:25 -0400
Message-Id: <DKMEWBHCCP4I.6313PZ2WRM7R@nvidia.com>
Subject: Re: [PATCH v4 6/7] mm/khugepaged: unmap pte before releasing vma
 write lock
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
X-ClientProxiedBy: YQZPR01CA0018.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB9585:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a809256-669e-4698-9a62-08def7eabb97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|18002099003|22082099003|11063799006|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	tUz2Oz16RvO7WVxx2fJGGCQmElpN5WOtjp89C2Z69LUqywexVBD9V8pLF3SdyBGJt5Of32f2yA5TeD300LczxTjMsdXt/8NHQoQqZonogYgL1/HfQ2nqoYhZX1fDaUUDFfVhSQqQLStRrR4rHDGejpJHNIbuhvL/fQqpdz/6KPQuhh4vtDtgEu57PbgZnORBImc0ZNMtH4y3ROSCgVD9zgx5IZyu4wU186hhdQ6sOfzmpi1GXflNoSnIx/dNvVOJ4fjAiG2JhG9om1llVzeslabNjbyqHQ1iVnLTjTD9wfdDzE7889alLSHnqrkKIIUQcsOD1c85g416HtBrZGtFXq10mnHqTvGU6ercqK+F4VL9BK1Z61Druh6giqEJEHifJcP2i0QZXR2qGmKI/NWlyMk8Smg50aL/rw+lJSzdu7uEaKFm4imkrfd8e6e/LaPbNoswSRFiCh3lAlaMb7FxCADB2+2E2e7zv/v57jmW0QkUMF6r6EY6qBCaxAY48CI96LGyQZ06B44d1LZHit8JByOQ4IKUzd6qxT+MVnbds152RuhujudrUXOXTKPNYnUR+JZdw5dH4LgU/xLjU3b2ANRpwoHBljS7twrbY46zYaU57u668Z6Zvnrs85DySlST5IvdBviDSAwZCr57o9DPmugCoFmZ24EQX4XbAl0Eypw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnJ0UmJ2T1h6dWp5cmdxZjNFbGtpVm5Fc3NUVWo0bWlDNmpwalVQNHh3UWt1?=
 =?utf-8?B?c2dzNDlxbSs3TWI3NUQvKzRDOURYRmxXWklUQWhuaW5DSnVWaS85OXVrYVRP?=
 =?utf-8?B?aExOR2svUkRYTS9rcDBDWk90YmFXdldjUUh2UHV0bnBJK2hLUDhLdHlXcURM?=
 =?utf-8?B?QjQya1ZiSENBbDMwRFB2ZHR0bnJkK0lqdjhCa1JtVmgxSWc5MUM5VGFPc2pi?=
 =?utf-8?B?YXY3b1NpcDJweityMnlkcVB0NmtBUHVNQ2ZtemlHa2xRd2creEV2OUVtZXVn?=
 =?utf-8?B?RXYzR2NyR3pGTTNRdlpyV2hWMkMwMWdnR0dtN1d2MEpmc2w5bEhhLzdJTmha?=
 =?utf-8?B?cE1MTEFDUHVBNHVWZGN5RXFlNG04dGd2WXVkT3B4NUxyeklxaUZQSHFOV3g0?=
 =?utf-8?B?WTJ1czM5MGNMM0VXR1llSkpXaGpxRUd1MzJXVFZ1QUt3SnNJTVQ3aG5TaXFP?=
 =?utf-8?B?dWcwL3NvdGNDM0oyNWtFaFZzV2RYMVFya1hvLy9VMHlZNWwyQ2UrMUR6WEI4?=
 =?utf-8?B?ZkxQYmd2aHNBMDBlZnhOaWxwN05jKzgxUW9iV2c5U0wvQW56ejc0Sy9raFFK?=
 =?utf-8?B?cXNMQ0hlZk5DQWlQQmtBbGg4dkk4bU92bTlRQitzS3VJRGdXSHN6b3VNQVlP?=
 =?utf-8?B?MnIwaUtQaVRPeUdYOExiVjcveEEzZi9NYTFONlFrQXhPWXdyZTlBbis2LzFD?=
 =?utf-8?B?bmFWMkRRN0FyUi9xV1JCMjhUUVVrUUlSYndMb3ppR1haQzdpc0xXS3EyT2E1?=
 =?utf-8?B?OWM5S2hPOU10UzNaZWd2TmVITy83N2s2VFNFU011aXFnWTh3SHNmUlF1cGg3?=
 =?utf-8?B?RTZTME1jWXJsWGR5ME81WWt2Q2hmRU54QVhpTnFnQXYvYjUvR2xadlJXdmZ3?=
 =?utf-8?B?bTF5R24ybDZ1Y1pwMkdYWU9rQUR5WVZRbmJ4RVZyVW9NOEUvc2k2R1BGaVFy?=
 =?utf-8?B?eUtid1dMNURHRWQzeDFjVVNMN3BqeEl3VXRNemNSWFJzdkV4Q3ZKczdRY21T?=
 =?utf-8?B?aWxQdm4zS3dtVUYyaUd4YzNUTXljVUt3amlnSlRxWXRkdlhuL1BKR01kQmdP?=
 =?utf-8?B?cTFQSzRzam5oQWFNUXRRMi93YytqWTF6d1hEZ01iZnJmUmRwYU1PVXpKeHpE?=
 =?utf-8?B?RHlkaGRMVGlWbTFiOXJjVnBMMG5zbnc4WlFSeC9UNEpjcmFad1JTRmpGcCt0?=
 =?utf-8?B?WHRGZVl1VXBodGhrdTVJcWVOUzB2aC8zdzhrYWVWbVZxQzI2M1pnc1NDbVpP?=
 =?utf-8?B?MkR3cDNPeHlKQ1hqcnJQSWZ3eHY5b0tkYWFtTUs0eGdmUXpBYTFqbUdLRnBx?=
 =?utf-8?B?SzdsajdNYkNmMUc4NEt3S2FDOHMzRk5zb1hDYklVMURXRnlJWkwxV21reWNm?=
 =?utf-8?B?WnV0MisvdFlpZTkyOWRlZ2haQytDME01WW1jZlZOOERPdFdWdzlqdW42VnRX?=
 =?utf-8?B?ZjI5c3QxUnZzZ3BhN1VIWHdJVkM4ckZUMDE2bDVBSmNqYUtPRElyWXBOZHhG?=
 =?utf-8?B?b1BSK1F6T09KVUxKZFlvenNaK2h6cEJPZC9kZFhVcCszUUQ5NHRiZmtXeGxV?=
 =?utf-8?B?QWQvZ1RsdmtKa3plQkZHNU5qRnM1VzVkTXlKZ1hIbjJNaVArUkFmQmFHWGZi?=
 =?utf-8?B?QVB4T1FjVFlhL0FOc3RDQngvYzdVcU5xVW42MXNsc3JtcmVLNVRFZ2crZk16?=
 =?utf-8?B?aXJHbE0xRXRXbWYwSmtKZDZXT3dRbWR0WUtsTGRCVGlkUlJncFdWNUpGUFpY?=
 =?utf-8?B?dkxvNUVOUzBCVHlMTXhjM2M2V00rbnZGTDdOaFFDSlRqaVZBbkZJRXFzSGpL?=
 =?utf-8?B?c0pZanVBaDFHblpZdUsxQy9kUFdtNDZjSXRjYkJMSTVTN1FRN3gzczZoVHBO?=
 =?utf-8?B?Z2x1NlJ5SkxDcTZDT2t6akVlSk5vZkhXV0RhK21vRjlQZTFIQ082d3VXYzUy?=
 =?utf-8?B?UmFYcUg4L0hERmU0d1c0azlCVUtmbnJMV2hKZmZxMU9HejlsZTF4cXo4YmU3?=
 =?utf-8?B?NFJNa2kwUlNqRGZQV0JBSUJNLzlCV1FSVzJSNVZCWG5KdjlWdHY2NzVrRDAw?=
 =?utf-8?B?bXV0T0xxN1VYU0Nublg0RUNpbXlUUXJ6Tkh2eXhuTVVGZzBDS0NMaTJnMUp2?=
 =?utf-8?B?cXZ0bDFhVE5LUFZ6L25VL1ZIU0xsYUFkd1VyS2xUempQMUpwWGRsZHdoVFlO?=
 =?utf-8?B?UHE5WmxYcUxvekZxWlZnVHlRMS8rMWFZcXVyVzJVYU14Z3dRS1JzTmcvWlZt?=
 =?utf-8?B?SXV0SUJ6Vk5GeDU3Y1R3QzFSeFFOY1hVZDdva1k5dGZPTGxEQWpWK0dhRzRK?=
 =?utf-8?Q?v67tDQJCgqmxCBmDOI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a809256-669e-4698-9a62-08def7eabb97
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 20:54:27.6064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/5a+jc6fMybTdU0RmNcT+Mb4lP4SHNGShKOPbhLmEgpLIp43jVe3KvREzMIDUPy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9585
X-Rspam-User: 
X-Rspamd-Queue-Id: D95E140003
X-Rspamd-Server: rspam07
X-Stat-Signature: 55k15xcj8p7ia9jip94ncxbiewauxktu
X-HE-Tag: 1786481676-460705
X-HE-Meta: U2FsdGVkX18F8KAw3BrLY0I+O8aER5nrXEvipLpy+tVJV481sEdLJLA/1F7sd95BBPwPy/7PdzRWs2Gl8cPzSmWYguFnUmVY4/HMPElD3iLoneQ+tMboNoa4ZJRaR2KHPE48f0TrKOVMu4UKBIEnAeek8mAYTxIxfT8+qw23n3bmJ8xhSbEPQJt4FlJrAhpLZPdmzJ3LrPZtnJj4yxN4etc9iX5i842wxGCUWxdnhiUerfwfDW73FczjP9D5yDba4jzWtqvQ9rNTP/3OkXxiky4UBxDKgp7tf7rjwctj/R7Y7j3YJ45+kpb5VJf4eeOfJ/vPZzwOUDqVEF0b3bzxnaxMLXF2EmFjvzPq3/dVlxr1rA7BH+MVH6k9vvPKNvWgSYoqr2r0wPi97Xi5pqRF4maxuXplj7te4owhQZl8Be1RCj9eBo1uD9con8lx/XwrmbKOaeWOChVQ0bdMyS5DHZqj8EVVeLB+YYz8YsSc0D6bT7VzRpIJ460I3zcAGxu0klW4oh8F3b896lNnC2S7iX9enjU/MTaOKcG9mBFrhoWRWuapJs8ozMboom1+cg4yZQMGtDqH66QCDkvKyO9JrgefteqmX9rIPjRzVzVqGb7eGQqzLvqrmMXeV5mCRYIbvCrcWGWcZxT12uTK3fbNzD03ojkQoG5n0OnA/Iat/drdep5vxfcNi5JAeiT7JoBHDSavVNTTxcoVj5z+2iqOwHXsxnW9rJl/zeHiVKusRg2gqCIZoNk6wPqaEcCZkwT6Iqaa+MZNsmqGcOnDlkYTrt92vb5dWLaAh1PwyErb++Mhj7neziIli9saqeBWUySaeFp8ZACoBTDPVeRZ5FiXBCsgh7SiBFrKiWSmi8kNPn7MynIKYTXRb+YpDlHn6Rg/FPT04+DRexll83EBJo1y4GQDjq3qJUF8689ko+XepRITy1cq/F9t3Zyvzw6nSJlfREJwY38sjnDfAG9hR3i
 SFLU5aY3
 5KfV6sHHE+MwsNnca85QWblXtbTKvDPuOY1RW+Fvmxg41rlhzcYf+KpdrMuEVhaOoycxR+0D93TaijRZV/dp6r2mwQyM3d+wn/ZQ7p9V26jMpR3MeQXy77qH9lBzW0TAVGQksFBo5e7p4HuQjnDQPaNjjsd9L4GUHx/FEb7VY83li/6388vtjbIJtSTl6TiwfzD9oQWMw/rfWkIZ9H2mPnDxDTckVsB6vTSWD61KIncg/nVmtDcogehIXtm7/R86q3+ElNDnaqoE9hc4/dsCqZu5cEgNP1bafseE0oQKSvQki0X0EaMex3TO3IznQMw8cd5FEMTQxRPs10FBXw/SpLoeS3AiS7z6CAI5jXf1AXw+NYRARAum9Ze98yA7OGmCwA8dL7Oz1S4rULiRmdNAmlaAfKxE1H0HZbTVSN3HMio+AcDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 11, 2026 at 8:48 AM EDT, Nico Pache (Red Hat) wrote:
> We are currently dropping the anon_vma write lock before unmapping the
> PTE. Although this is safe, due to us still holding the mmap_write_lock,
> its safer and less confusing to switch the order of these two operations.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


