Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1459C79F82
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 02:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2BB6B0088; Fri,  4 Sep 2026 22:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483F16B008A; Fri,  4 Sep 2026 22:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324E26B008C; Fri,  4 Sep 2026 22:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 074F46B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:26:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6468CA025B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:26:04 +0000 (UTC)
X-FDA: 85178118648.21.295FDDA
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9966E1C0003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:26:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Th+n8yxf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788575161;
	b=PK3rqDJ/HOhZYwm417ltFy+HS3pb5oo4lvz3eKqMlAJHjp7VrrOu+oosssMvj0LKj4jeT4
	SkLPCiNjuy/fcIRGwq1vbEcflRpEhUCUkE/2HgNJIgCZlMYwvin/ev1BufMCzfJwofBLEB
	m0nCqt2P6gk2dtGgv6MQyW17+vGtGeA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Th+n8yxf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788575161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltSX/1VZ/j/SmVJ9oeCVKGZIRlIM7j0Jzz+gGewcNts=;
	b=EI+zQydjuza/elM5oi96DYPFKxgT0/k6/dOAqcIt1P4/qBRLYct1dUtLryOTzsLO7ttK4G
	oOiE2scZ/L60Q09eK9Pv3kBUb6JKX3VQWeRGnlwl3keXEgNX99q7pRZ0IxDhE5elZS+xIq
	QyHE0OAvg2ZQwqq3NuK6zF5DTntwlsg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZYEi7aBH6bHWst9Ax2wtTWXxyZLyd814lBKiIDd5bm6kDq/VNHvM1NycZsleAWW0O4JKvM6KhNf8XZgPndi5nkZCeo7+7F0kt75OEd50s0TWhiEXCb356ZkW4FU6KQQ6iY/qJ1shVVyMkpKQTMMerSRMmX7wAflxzDyK8fn3kpjqC250ezM0cRrI25Gx1hg15+ko/EqsRhe/tPyCLNfKkJXAwRH5Ng/XF9yD1AiZgV0x+rZHDaxxiNmDbp1Q7MbI4JBctp3YDblJNsK6Oe2Iyg8eRUtKbjFtfc+LOgYPkqgv5LuTBKT3Cv5WApzkl5ij8zh+/F9hkrFLY6PAdTdNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltSX/1VZ/j/SmVJ9oeCVKGZIRlIM7j0Jzz+gGewcNts=;
 b=mdnHZdGlSWsxR7jv5ElNk0V4t2ttJd2eTP/NVX612AvJtdwq1Bn30pzoGETJW7x8WO77tRVxR7G6MIIT09qWFsI41ENaDqD3GzNRzLpBqka9nftb13qsVYyaadzacDQbte/YBQh1FIyP8phtOBJzrHcK1262ILlzPeBjI7wYnljUxsT2/5YSSxo2/AtQgsuhdhPQKxL5wdnpTq94XsaOe9XtILhHjFeCALP++SqIWKHeVwA7yOG94BSGclhckV46FuDV2XXBJ/i62W5kXPgMx8omqnHNCFZsQmOwhGfNg5tmBHuLCO61wOwL+3CEazV3pq313jIqWo0gAQdh33noTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ltSX/1VZ/j/SmVJ9oeCVKGZIRlIM7j0Jzz+gGewcNts=;
 b=Th+n8yxfZZ42d3ixQCbwEDOnxECkvDj6Aj1BXDQwOWFBEPyuI5u5S26syFF4H1UQcDVsCq2y2BO4uYLjMoTZIEhPdRlvxh0ahJtuZ1NEUhmZ3Hua+4Bnyl8fQV21O78DgrtUr/3aDi4ATqghBPzveEh/cfx5gjUV+8/9bSfemwJEDu3f88e9T6GU3ja3nOmQK5onwMiMCk/9mXzy0J26nd9tpp7uBwJZJnaJiQ9TYoVLdLM1m82RENeLBvul22OumTQPZuquyLdDJXMselznAeoFM+48fMv8xRlt6Aurz+z68KQn4PA8lgh1ZHwESa60yLt8vACm9cd2HOlhqdZ1rg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB9021.namprd12.prod.outlook.com (2603:10b6:610:173::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Sat, 5 Sep
 2026 02:25:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Sat, 5 Sep 2026
 02:25:55 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 22:25:54 -0400
Message-Id: <DL70Z6ZM3ORM.104CN64UDYXPL@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, "Nico Pache"
 <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain"
 <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 02/12] mm/khugepaged: count collapses where khugepaged
 makes them
X-Mailer: aerc 0.22.0
References: <cover.1788533997.git.kas@kernel.org>
 <ef229484e454d804ffbdbf8ae87798919594fd1b.1788533997.git.kas@kernel.org>
In-Reply-To: <ef229484e454d804ffbdbf8ae87798919594fd1b.1788533997.git.kas@kernel.org>
X-ClientProxiedBy: IA4P221CA0001.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f4ef662-3918-4e35-449c-08df0af503a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|18002099003|10067099003|56012099006|4143699003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	sifjDydtBLI/TqTTxAfUu1DWEhMhE6kKgKj//+oKdQnxiPHTty1hY6f/sImOEXLo+hFd/vp/cbEmqU45Xh5ilANmH1N8Am6hffpMKgZ05VOx0u/PhJBTyueAtOL0Obyg/gn7lTcduaT803XOjJOBdNJDdIIX87FyZzoIAHA7XNB0GOWeks1ahddpkEZjTB7tfSJ5AwkrgKdmJJpdglMVVogmYe3YHxGh7JfYWV2gj4a8fgbo7plYGoK9yNEpjvM5uhO+FnVkzERgLtnuu42YTkX1skVcoT40AY1mPtHDJN7/Tn5LVh65Jm3Hceg1qh2NdHiupAa+yX3cFNI40lHnI23eWRlXU+BZ0YBTcV4bS27dh/BbvZ1nC62DM/+Sj45eGZC32j80Qw7Zo159d61lXVrCTDZP9iGgSFOUoR2YvIIMyDgqbhwDE6j4tjSV9f8Qk1iWnLUPu8i9LFP1jn/+eu1WZuQS3P3Ck9Kbkime1ky8Hn6fM7e1tgG+6dIOeeaw+/9jzGokwSogHOfuF7Q8ZGpifC9PB5te9f9U08/oX73zgbxmloU2kt7B0vBF6XF9hyQkgS2sOG0aYlSwtuYnL1T6CiJJay+tSGToHWJZM9JzbCmsNpTj53zSce3Vq0ZlULNO4kEFzxRmCnRjM2u1wp8YmPCah4umWvcubIzuhuw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(18002099003)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXloWWdEbm9vWFRKUitEcEw5N0wzQzAycklZb2RYY2ZjZGE0VmkwcDM1eHVI?=
 =?utf-8?B?dUhUMEQ1Q2ZXUFdDT214VUk3STBCQ3hIY1FBdm9ZVmJUVmxvK2h3VDZjSi8v?=
 =?utf-8?B?azZ4ZzMxQ0RrRjVPeTk5NHF5ZjBPUWJBdWFLUWhNM2ZBRFBiazNXaW1nMUxr?=
 =?utf-8?B?TWluSC92b0pKZGg4QlhDbzlLdVB0OHYxUHloNzE3Nlpid0IvcURSYjBRa3Uz?=
 =?utf-8?B?Y2xiQ3U4WGdGdVhQVjNPcTM5eVdjdkZMVFg4SzlMdXFBZEJJdUFBWmhkSTRL?=
 =?utf-8?B?T1IwS1lxejlHMkJMcHZOVGxvWjFMcmNYTXN6REZ6SWNKTXdaN3Q4bjVSby9W?=
 =?utf-8?B?N29ybnhadDlFMkZTNWZENkE5UUpJbDBZZGl5eVFWSy9PT3lwQWVZaUtIbklt?=
 =?utf-8?B?cVBjMGRwWXRRemUrbEQzOHREQURtVVBhT3QxSVFIeEJRSXN3WGo4Z0FZd1lt?=
 =?utf-8?B?eVJ4V1A1ZEg1VE9DOFNLSnpSaEJldlR2Y0JsenQ0VmZCa2JxYSsxcTYxalR3?=
 =?utf-8?B?UkdOSXdLa1VJTnRZeDRFSEN5ZkNaZkIwUUJNSERtei95T3lsZEk0TnAwV3Zj?=
 =?utf-8?B?NWQxa0lmV3NnbGRmbFRBY2dWeUh0ZnJ6YkwzWDl0Z3V5TTJmblIrRzJPQnJo?=
 =?utf-8?B?QWZTdVdYU2dtazc2REg3U09jUFJTdStoZDBPR2dSaEVqQU9qVmpGWE5pTGp5?=
 =?utf-8?B?T1pCZFhWdEtPRDNHeStBTUdPMzZkMWRuYkc4NzE2WW1xVEdFdTBSRHB0Tk9I?=
 =?utf-8?B?SnBuZHZER2RTbTIrQWhZM1J6amgrRU1nakMzM0YwR1ZhT3FmRzhuMDFCUFN6?=
 =?utf-8?B?QTZUSjNkT2U5V1Bxd3Y1UTQzWmhrTjBEMFFETHNlN0p2SmR3clhnMFJ5d3FP?=
 =?utf-8?B?NWVpem9KSDA5eHplWTlIckhCRDR5dnNoZHB3SjhCU2d6bEVFSW9CZzJMemZB?=
 =?utf-8?B?OUo4cEFONmtsTDZaUEMzRU4ycHlaREFmdjdMMGdla2JpQVlYWUtWclM4SzNl?=
 =?utf-8?B?K2QzWWV3RFBuZTBpNTliYTdzTnlWZ3k3cDRtakI5dUVoSlBROGRwZmNYV3hV?=
 =?utf-8?B?MkhRdW9WbG9qL1l0T0hrNlVWYXpuekoyWWd0YnhpQUdHakQ1anJkMjQyVEw0?=
 =?utf-8?B?eWFUc0VKMmlzSlJkTkNwVy81SlR2bWVxZzU3MG1tRWI1Z1BCM2xIM01zOWtY?=
 =?utf-8?B?Y0s1VTcxU3JYMTZQZ2taRDg4M1JCZzJCamdNdGRHRlJEQlMwNk1OdUZHUHBV?=
 =?utf-8?B?SXpQUktLd08zdGFmVWJQRGFYaW9JR0Z0ZFI2SjREYWR5NDBtS09PN3F3V3E4?=
 =?utf-8?B?T0lRek01U1kyYjQrZFhnM1BENk9EWXRPa2hhR2NDdmp3ZzdrSDN4bDNYZWZl?=
 =?utf-8?B?ektyUTdEdzh6WTh0VnRPNWFtZmFQVE1YOFRDVXEzclNobGVpdHF2RkE4QlYy?=
 =?utf-8?B?Q0p0L1FJNVVYZU9SSDRjemtzQWorSHRFV2NtYWtma1hDY2FCbW5sc1lVc0NS?=
 =?utf-8?B?aDBTdTJjZ0tibGNVa0UwUmFuYVh2R2Z0TndpeW1BRFArdlZVZE8rTmw3MWs0?=
 =?utf-8?B?ZjBjMzEzODV4TkYwdkNNaEhpcTdJandYR3kxOXJWTlpzMjdma2FaYlpySXB3?=
 =?utf-8?B?UkwwTWhKeE5PUWFZR2Jzc2tFc3g3NmdwaW9XS0gwMEFmcnlsQjljMXFCd3dn?=
 =?utf-8?B?YlhmWXFzNHVoUUVsZGV5a2dGOFowTWtVdzJnZXEvdUsvWVNrZFErNjgwK0xG?=
 =?utf-8?B?azEzSXVNbTdhblF6TmZVdVozc3ZId0JyRDJxcHVQOU1QWjRLeHY3ZFYzMzJH?=
 =?utf-8?B?dGhYQnJkVlNpNWZKUHNiUTBhcGFkckZZNjVyRFlTYUNsU21adlduWEdrZXhn?=
 =?utf-8?B?MnlMZU40eWVwc1ZGNDB3WmZyeTMzM1dwU2Z3RytYZXA1RDZQRkNmVEhsSE43?=
 =?utf-8?B?ZENXVjRNSlU1NEwrcHVnVEhVRjJ0YzZOb0U0dHdaR05XMFJ1OFRNNVk3QWtk?=
 =?utf-8?B?aWsyTnJOQjU5OVp0Z1QxZnJiSXFiVEJkelJEMjFweGI1V0trZGdnUC9sKys3?=
 =?utf-8?B?OW5RQjJHTmFtMHpZRmZVaVJsSDVMZ3ZMTHhXdTJnb1BFY2tUOC9wWTZ5Myth?=
 =?utf-8?B?R0NjMDBXQjBKWVhsKzR4bldscll6V29uRi9kbi9YMk9GSU1BSFIvem4yc2Jw?=
 =?utf-8?B?dVQrZkx0V2F5VTVseFpha1dHR21KeTVBM2l0RG5Rbnh0dGdOMUZyQXlEN1hX?=
 =?utf-8?B?MUtWM2h3aFFMVXJUUTA0WnNvcmlJQlAvdGY0QmpMdCs0eVM1aHVWbW9IREhS?=
 =?utf-8?Q?eRWReDuGAGxwpBiOV0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4ef662-3918-4e35-449c-08df0af503a5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 02:25:55.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ec81rCxBmjC0iIr7WqlE0F9fQ3Ta+STWzCI8n2/6fl9BYPPqOBjy2GeyuXJE4bG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9021
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9966E1C0003
X-Stat-Signature: yoyikw4por33ms4pqrgg1u5kos4a3uw4
X-Rspam-User: 
X-HE-Tag: 1788575161-140256
X-HE-Meta: U2FsdGVkX18r5FI8qEcoKqDjit9mrQacWAt/LlBKAsDAf064LQAFTbxSPCfpDsBPAN2FyDkmIa8csKGpJjg4DX66aO32KRR1kKOBcJqjOHUV1KGYDi9JY6QSuocQit3sdkg7QzBOaVea8Lsan5OiSMesQ5wZw4O+VW48eXuWR+Ix2FNLt3Lbh0VZcwZEChmtxVEdEY8zqezY56VRzjQEbkJEai2tu/Kmpfm15qlQAbop7cJw1vYPb2VQKsHro1G93Rr+wzCfAhSXTb+7HpOCplVNo7JfFWzCHNTp61n2y93XXdpGV4J91XGySiVI8USC977DryGV1PwcAfC3UUZ9K1mxzm2i/NTD9hPrFEELGsqlXLT0vhuFIPIQh3Ec7BDrFl4MfsePrLRgHDW0GNRqfhfaTG6zFzcNOvaxRcLaxBI7XgWaFubjn5q2zsN4GqHr6cLDO5YR+6YRKPigjEaGukxD3+5kIUgOKLCiLK7D2YqBsxiRSGtwdbNuE+jipMm/4WC5CjdMgphtdJDa1Bo50m8XKTYgI442eadnZ3tvmoyui+d0MQ7jIH8qkroje+6w7Y3oTHzbFbxy5YF+O6xPUu6UDZ7DYOdTgIzzJ45ehvXqVq80mglcmENiwjfSRwa9RYKmIVMfzBUDQrK2m9LoS8R/ROO0ODaknudg8R19TCNjVaWi1trMBzhzAd+2RbP/WWP5EHy2p956/6JYmCdq9haiJBMZmRNigEoJCgKtA/73iwczYTxOMhcxu/T48WSR8QBNXPq1ESAOnc1Arap7V431GtyCbRDO8tUF4AMjPVUC3QCnVejwkyl9jD/vcUPKJ1dgpelP8uwItC4cUSeyOlK8GaRaWOO87FiYniZ8Fa+vwRNC9PiQhIMRhk0/5UjA33WDJA3TmkjV13gS1fBYHEUoinFM2cvzQJ/sNBj5FjAkvhiJtqXmcDNgvrFKqF2MNXokCO0imUxmfN7VxhI
 vGgJ2Uzt
 Ci/oKe0yufurX9Amy09GXrYnx9GcWc1ZDwFr0c1IELeNhh/vaaWzgq0eZIyzp06vz6PgSOGrTNEONFzNC52fnLDs0QYl5O0yCMSbrsmuyvmQ1ustS8yYAZNMKCEGqXYAkeSc1UsW5tj4lfXB8daKZIMHhufQZuqTrk6ffaokOpGcIo1oTI7SqhVGrFrlkFWc8dVRjwujKXWj+JS6mFw0vIGUMn274va5S/uYDaFUIdXKGeaz2j4MmJ9CFDrtb5xYGqVsk17xKtItu7Iev79M8/AjtEMQSoSZ9Y34+SCWGLLAEuDf/X8AiGsGdDg+wZhecPUo411eG41nGdDreAewoxCAC+NdbtQUhhf/pChaNbl+VgCxKklmOlst5epQEicG3Qx7QI3uL7SgI5OV0xqvADYRNjUWpEWl7hGcExcGhULoJ+Tc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 4, 2026 at 11:10 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, an=
d
> tests cc->is_khugepaged to know whether it should: the counter belongs to
> the daemon, and MADV_COLLAPSE must not touch it.
>
> The daemon sees every result of every collapse it asks for, so it can kee=
p
> its own counter without the shared path testing who called.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/khugepaged.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


