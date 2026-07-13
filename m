Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBED2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 19:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE726B00AB; Mon, 13 Jul 2026 15:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F776B00AD; Mon, 13 Jul 2026 15:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B466E6B00AE; Mon, 13 Jul 2026 15:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC236B00AB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:31:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01B6A1C005F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:31:47 +0000 (UTC)
X-FDA: 84984748296.16.9592BAE
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011021.outbound.protection.outlook.com [40.107.208.21])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3CB4880007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:31:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dCQ24TTU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783971105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LlBZ+hOq2ookQLP7huBPOSB4LfiyEGfyH7KjIIruhI=;
	b=qfA9t6q7ZQAhsfEleQFkcPa2vBEyVKiEJkkshj2/+2bXZMH/7lv7ylme4/i4QIYjDzXKfi
	dRnY4Cs7/lkRujL1266qhK4Y4AWA+rrvFxWZRZ1NT3nBib0YP8NS3GPpgIHOYDWJMDPoSf
	ZGjKxNmvCdLaOFZKA+42bSRUjaby/EY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dCQ24TTU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783971105;
	b=abmuIjACi3ooa1uw1vPVEqYN4JCbDqhre2HtWY1VQyruZtcF9NQaZyFj/sMJB0FY1JhJLx
	Urlzpy0x5VKpvlCDNyXRfvmKseNrlNUywZb3ZL55nA4omsnCOeWlFh5tnBwDL1d6dAWPIL
	R7OG/FYiF4EBpcAAtLwt5te5hJp5tMI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nw5Yh8E3sOmk3h2YxR1oJs/QFgp2DKq6YbBeTYCssJlnxyfeCGqrDlXwm+OBMloL3xRb55ox+QH75Td1cTUyDI2uO4KAMFnvXlFOFPESDoqqHBngKnMyUzjEFDXrbN5VRAoliJO/bCtr6ZezpOx5mRtuVHJBpMv9m9EP1843HMPOrgM8/5mr2cw+Tsbrie6Hd4aIpxSI+Z6enQslPHDCM0FQ6Iwr6u/OBtB/VEWIdsCyzABjCTeOa8PX0ABpZ3m0+2jsyJyYuEeJA0gO7fyJh4XzAVgkiJ1PVy3UYzXC4gVoraqXlEieMr9tjswiUYUCbnUIRSFvLUJcvBIutFbMIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LlBZ+hOq2ookQLP7huBPOSB4LfiyEGfyH7KjIIruhI=;
 b=PZKcpMSyfv0zwl/vf6nTSeUqQxqSKYJn+YuXsfYasImUmYVImmKWa2RJs2W7T6A8lkH9+lP3XwC8gjSX2s764h+AdU7lH/x6YMr8DSJnt6fmW7Gu8IFco8oRpWn/N2YP+9Odq9xNB2XdHhklk29LHgCJ3Mjb+tHQROrYiZKcnNw53C6q9eANbtVzRmelC4NsEFrvQc5RIaGKGRhBM6hU56CXi1Br1Xr1J0uCH2LpyKk9a72D36ZcKx9HvazXGRHdtnF/RVoLr83V+nb0X65/NK4FUwpSXWIAAFfKUstmcMcKkEcH19q0vUgpcYDtBV5LU9vtwJ7ZHk18lSOycb75+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LlBZ+hOq2ookQLP7huBPOSB4LfiyEGfyH7KjIIruhI=;
 b=dCQ24TTULhwwyjSWYfvlk+XSDV8qcqjeKtkyvlkn7hUqYOF0T/PR98SWT+lMW5PCy/V9Sce4KF5UDOJHulSzKF5l8vjH7Yj6E91Hy5tX65riDzGGia6wRiDZ0bqfCR18tH95ansrVW2Cc7UL3zqgWCM/JE/LH/gdufu47lXzDCEym1scZVdZRZr6CKWLzx4oHLy/HtADiIZCLJmynrygc4hqPL8u4sveIs6MMXnYxOGqwXG2XOIZr5OsJn3ITt8r1I4dB15Q+/PejHie+6o7U9Bk7nQTH2lO/2E6APAyztALHU0tzSCo6N8pK3xzIb6n2cLwuDPK/5yJpotBgThZBQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB7425.namprd12.prod.outlook.com (2603:10b6:510:200::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 13 Jul
 2026 19:31:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Mon, 13 Jul 2026
 19:31:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 15:31:32 -0400
Message-Id: <DJXOZ1TZN3XW.21PDLRBVIED2N@nvidia.com>
Subject: Re: [PATCH v3 1/1] mm: let node_reclaim() return the number of
 pages reclaimed
Cc: "Brendan Jackman" <jackmanb@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>
To: "Petr Tesarik" <ptesarik@suse.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260710152320.2024283-1-ptesarik@suse.com>
In-Reply-To: <20260710152320.2024283-1-ptesarik@suse.com>
X-ClientProxiedBy: DS7PR06CA0047.namprd06.prod.outlook.com
 (2603:10b6:8:54::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB7425:EE_
X-MS-Office365-Filtering-Correlation-Id: ea63d0b3-a69a-4847-7fbd-08dee1155944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|18002099003|22082099003|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	WCdR2tpP4tK192arqEr6JxHxO7ookpwrzqaTIh2FdDngvBUyDaw3Sue/vE6k0TXt0gcr0V1FqFgwdAY9vaU7StdIPzIlJKyFjRFiSh0UVAbYT+YRE2hFIQlVlLztEwFwo9gusLew0I32+j0kUiYu9ao8WweI3KMKep2yPe0u4PpK4JKZEUNQKtmYQfBGpSTqZsVHFDd5hjSVlUM9Th29W1wRDtAy3WwvWRz7KXyQEVaa+jq5yxWWBYotU/5b5DDKsOiX7T00euhI7FLQsSccG5F4VR9uj1rCa40J8GSpqY/ANZHgo4X2bTJAz8Y/IxHkGR1MLeCcvLlhjSfMxbF7jNC6r4pwtwUR1r0HxOZffMwbwOfRmIDPaycuxWh8hG/SmrGwqtHhVoZOB6OnSlXDJXtkwq9yjUC5/JW0msstvb2DX6VD0QdNkihCTrxXYlAurReg1o9oXPz4SaGlFUPIE4X40oFAeHOGfN157T6M8ycoGBOAFS4y+O7RAAOWukVFdeGsY2L7cOD+dzjRM2M0j277ouZ3bWSZv2YWWw+YnQ87/Ia7pCKxEyKgrnLKIKlDmvzuOATkACE6iBEj93wj4+7hUzaSAJbNo2z/CfgNA9xQt4XkfbQZdRN3Q0/oXHgC8NW74hjvPFh+cR/YVTHK7KclYkg6G1nB9colxO1YvfoIhiaKD0PMQykifYN2r5+N1my9SbWsQDpVu/es0t2XoQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alo5ZDMzZTZYVmdrZ2xGaWRVSlFhdnNGOEdGekpTeDVxcVFkek8rdnpuaGZI?=
 =?utf-8?B?Y2NtLzlKcGUyQjNmVjljQUVNa2duSjBoZFp1dzhQalVPS0NsRlZYNVgxY1RC?=
 =?utf-8?B?czNnTTZFRUZFKy80eGhTdm1SYVMvM3lVYWJqUStkbHNKRGg1TWhsQXhEQ2Zj?=
 =?utf-8?B?STQwbFp1Z25EWk1YVGIwWmJsOEc0S2tWMUlZWVROU2V4NER1cE9DTzRpV2Fn?=
 =?utf-8?B?K1ZoeDExOWVXcnFBQ2srNCtkd0MrYldQSDJwbnZjNGlYUHhNY1BCeGpQV3Fh?=
 =?utf-8?B?RkF5MW5pY0JlWU9zbWprQXEyampCSTZPUkpQWms4MFJ6a0hraHpTbnM5WDNs?=
 =?utf-8?B?Tys4ckU4OG5wcHVNeVlGeUlaSmZ4dTc0SDgzdnR3ZS9LQWxPK01ETitMUFdW?=
 =?utf-8?B?Y1JpYXQ1dUc5U2NwYUZFdlRnbkZ5NkNkbTBqK2JOa0l1cy9pb09rcmxZb0lW?=
 =?utf-8?B?aExBMThkNlh3d3pKVll2eENaWnp5aFlWRlg3RjdTb0svWWZSa3RUWGxhRVZI?=
 =?utf-8?B?K2ptWm1JMFdWeXdWMmVzV3VYUUh3dGpFYkxoWWUyV2I5RndQR05tMWYwOVV1?=
 =?utf-8?B?REdySjEwWkl6VXB6OHVHUURhTXZScTJlKzJ2S2lGK2tBaC96MEVITGEvdlJ1?=
 =?utf-8?B?TFE3by83SG8wcFlKR0dVcU9RT29Xbmt4Q25Wc28yeWZKWGhUVHBiRDFsdmFo?=
 =?utf-8?B?NjluRFEvVVdzd2M1bmc2V1ozc2RNRTFlZ254TkFQbVd6d1Budi9CMVdlMERn?=
 =?utf-8?B?UnVSdlJyYjI2ZE94Z2NLd2g1d2NsTnIrK1lmTHBhNHdBQ096M1JqNnlSemV4?=
 =?utf-8?B?MlNuZVJHMmQwVzc4UEg3RmFTRlFiUkNsekFEUnR4MzZEMTdCcGR1ek5WbnRG?=
 =?utf-8?B?U2twSVpZVUt0YWVNTEVrRDhZZ1JwRzRJL0cwRG9FMTlEay9LYjQvdCs2SmNS?=
 =?utf-8?B?Ukd0K0NQTzQ0ZHo2SU5pU1JVVllSZGM1ajNBQXEvd0YxNWJsZFBsblhvbDlD?=
 =?utf-8?B?RzZXQlRtcDJjOUxQRFZBR1pLWjltL3NRSHFQYU83clFCM0hiV0NJb0JnTUxK?=
 =?utf-8?B?QzdIQktWTGc5aitZelMramVON091Ykpkb21wVzFDUlFBcTFhVHdzWlZ1bXRo?=
 =?utf-8?B?eElsTUVsb29sSS9uVkJ2UWMxZmxRZUtONU1Vc1NMaWQ3VXd0QkFNc0ZLYWZK?=
 =?utf-8?B?enB4Rys4RVhDR2VTZ3ArbnlnbHNxUURZZWUwL21NM2w4cjZ6K3ovNlN3cC9u?=
 =?utf-8?B?bEpiK1dSb1dRWm9sL3BNTE1GUGs4eEdpSFZzQmo2K2RWTXBKQlBwN2s3cFNB?=
 =?utf-8?B?ZE9xVy9VRG1peFJaaTVMSEVJM08rcjhlU3JONHp5d1YvS3hVVXVWV1JONXNn?=
 =?utf-8?B?RjVoQ1JWenk5RFNSZ1VrWm9DSEpJREQ0RDY0S0UyL0haMHBvUEMvU3liMmpI?=
 =?utf-8?B?V3FQZzlpOU1SS3NVMWtOTVFHdUFoRmxyWDZpak1rQkNOMElKVU5LVWVJbXVv?=
 =?utf-8?B?NitrSGxmdEdQVEVlTnl3L00yZkt5b1huQnFnR1RCYy9uUVZ6ZkUzSk5pbUVw?=
 =?utf-8?B?ci9zWnV0STJhM3dUSHpZejE3NlhiN0JET1ZjbDBJelhGTWxYeWpWbjduYStQ?=
 =?utf-8?B?dTRuMWU4RE1yMFVVVVorRkRJRXhxZlFlYWNtREJ2S0hFSHZYeVl2NHl4NThY?=
 =?utf-8?B?cnMyUFV3OXNWT1ZFRFhLL1BxZS8rc3J1SlFDRkNoaU51VXZQeTV6ZmtHV0FK?=
 =?utf-8?B?Q1NNYTFocENzOWNnTlJEdWVZUW4vQmZJYk0zTWpkNjBlYzBzWi9VTy9WK0Fw?=
 =?utf-8?B?WHVQMzRaSVFRcGM4MmRxQkgxUnl0R1hUVk1qTDRaQmJpQ3dCaW1MWkhwYkVS?=
 =?utf-8?B?a3dKdCtUQWJhYWVYMEU3L0gxRTFkOE5yZ2w4N0dpOXVMVHFGTXZMRFpMbWdm?=
 =?utf-8?B?V0RXYnNpUGxRTHdIeVkvY3pULzI4eStFSjlaR3hVb0VobS90Ym0yMHBMYnNS?=
 =?utf-8?B?cjlRZGs0ekJONFZ0RTBBenZncVlzY0VaNEl6bllTa05odWt4UzExcUJNcEM4?=
 =?utf-8?B?WVZlVmxkWDBweldFRGE3OURDNFp0bUVVUHdhZ2NBS0tnMWZDVTFkM3pYdTla?=
 =?utf-8?B?VjlCN2U5UHBEbmV0OGFZbVBhWUVIay9jMWp1WjlheTBrVmt4UHFJeFlpUzVV?=
 =?utf-8?B?TjE1M3pMbEFYTVpWSDEzY3VjdFBsbnRzdkl5L2IwNWZERDMvb0pRUFQySDJi?=
 =?utf-8?B?cnhVYTFHTVY2TjU5bE9hQ2NzaWhaUDc4blRBRzNDYStaZnJ6eVZVUjU1cGVo?=
 =?utf-8?Q?1pRKNB9VhqDt9a0+pT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea63d0b3-a69a-4847-7fbd-08dee1155944
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 19:31:34.2567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFffRXeW2fAPABSolptwWyo6Vjw19nxtdBCuD7AHWlxLUjtRQ4Q2GSwwC1dOPZqO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7425
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3CB4880007
X-Stat-Signature: 1gn583fxgw4ac6psqggosu4q6xe38c1u
X-HE-Tag: 1783971105-528519
X-HE-Meta: U2FsdGVkX1/AoIxnQCgHrTkJJeokJ7WSIRCQ1g8pyIlDmAw7pCEq9nzAW5zSbfRF8ERnJhfOm+T7+2LEV5T8S3NTERpLUfZv8ImHTjBanZGsIgZBmpC8dhv94tPc4Btv1yfw3Vq9PAQILE5dESnzfEnQPepoY1dt5lz44n/5QiIhfAzYEzMGF3DJiHv2Vh4vyth6KLkKiJHvRoIqInp4gruTHS5Lk/AjYdR62UVPJyCFx+jSSynInUJLUIBGwWocZlTFRBjajjzqrMGRPzNI6Qi6tbjozua5+ZYx1yKjutC9GVx4yWl4napp81FHqkU3wpxZud/7aDH/VOmPoPA60tq8xKY4I2ioqPUdZROjL2SjLdnkJhBDzJu6Wg9KVzLjY8Y5+dC3ep4lCIswE0L2vwKDrLAiK7I69voAjMFi/KNxNhCl6AGVqbbTYOeuAYTji2UR+La/7O+8ZLXVHAthBM2NvKqEql5zb8QsfdW+ujpms6R7ImxuppYZOFSU9I5DS0txEJ1eZIOhw/m3tbvc8+Ks9rdniKAkpcXMVatkRjYLCciVdE5kZEmPmYTsTjq1WNZe2+PVBHqLXZWMuwgDvUUWsuI08ITXW9iNmN9XxKNvw0M0wgTUhK2YQvmzTiowzJsJY32pmx/2hkuiV2gShIQMd4CjbOTNCQsrSrd7d2bLZQc53wZQ5ZPpbTbpevw/uAwBkc1GlAt5Ak0uVzk/fX3CbPIks4gE2sXl4oopbEZCKb4PoLrkRNUHViB7Dr3WAojvCB8S1eWcjfCD7RcKRonQL6Mw6NtaS08f3ngqNx4XHi0q3IUcXtMCyqgi7Ruk5jPUNPW/pb55EUIt/sKb+i5aTh+N8LZ8W+0qr2bvqVbcIp7APvGAHB9X1SpDzEs8O4x/+hSzbm1qacoTQpyye5+v0s7tvxwXH4iUE2DfRr44QWmv4JUMy2ZLf9D79YsW5mFrEGZFzkk26i+ptpF
 CMDLNG3Y
 4TA6k2KRqo9I136zaVp09Z4o3riejbY6QNHFrEyNYstYZAfkkkC3piAw/K7WPSKiDLB8o0+gUeZRxiSmCRGd7AL3KQMxX87bzjczoW4ApomVciecIgR29I1TcHUjLrwodiFf5LnWaXaBywFuR4Xxs0iVt1StV19u9CNQIDSqLuSatolPGPBJDyWKeOT75WTsgvxTRBtO/DbDBDAWNydXZhL0X1/sGSC0ME35oXPcIfpLAfZi7o3N5ErPqupE1OPA/ydq/fflvTKEX1RnCOwC/JYfCCn8qAHaTrRH8OYC44F8mRUGTpT11bRpsNtOfQLEShN0J/d5YaxKQfiKPPZB3jH1YI2z4yFT/xXMC9RaxsabogpD82J6ZKHq2Wy15SWM4q65CS7Pe2q6C7+IqEtnG+RzZ9Asy+X7hgV5YR85Ee1Z2SRMzdhBh2OxwklBlY84SISWaN+Lz871uyirTDGC+jqiQ+mXZwP3HkTkIyyDq14q33SrnrrAv3G5Chdyr1q6kkmn9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 10, 2026 at 11:23 AM EDT, Petr Tesarik wrote:
> There is only one caller, get_page_from_freelist(), and it does not make
> any use of the reason for skipping the reclaim, nor does it make any
> distinction between a full and partially successful reclaim.
>
> Therefore, node_reclaim() can simply return the number of pages that have
> been reclaimed, same as __node_reclaim(), and the NODE_RECLAIM_xxx macros
> can be removed.
>
> There is one small change of behavior when __node_reclaim() was attempted
> but returned zero. The allocation now skips the zone immediately; before
> this patch, the zone watermarks were checked first. I believe it was an
> oversight rather than intention, because the chances that zone watermark =
is
> OK after __node_reclaim() did not reclaim any pages are very close to zer=
o.
>
> Originally, I was looking for occurences of NODE_RECLAIM_SOME and
> NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because they are
> typecast from the result of a relational operator. This seemed a bit
> fragile, so I dug a bit deeper and came up with this proposed cleanup.
>
> Signed-off-by: Petr Tesarik <ptesarik@suse.com>
>
> --
>
> Changes from v2:
> - remove the enum and return the number of pages reclaimed
>
> Changes from v1:
> - use an enum instead of a bool
> ---
>  mm/internal.h   |  9 +++++----
>  mm/page_alloc.c | 19 ++++---------------
>  mm/vmscan.c     | 16 ++++++++--------
>  3 files changed, 17 insertions(+), 27 deletions(-)
>
With the macro removed, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


