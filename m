Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 648A9F54AC7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1FD6B008A; Tue, 24 Mar 2026 11:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991F66B0092; Tue, 24 Mar 2026 11:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880FA6B0093; Tue, 24 Mar 2026 11:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75EB46B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:06:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02A1B8838B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:06:58 +0000 (UTC)
X-FDA: 84581284158.04.CAFEC5D
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011052.outbound.protection.outlook.com [40.93.194.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 14398100014
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:06:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BXLEFkGJ;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774364816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKlppWYwKZbS1K1WHMT+SJd3reC3E0800S5Qh6kjCdc=;
	b=fyL7w+Y13ZtIaY5j59NLgRmUqiR4wd98UB5SQ/urwWc++ynpQnf6EUvCJzI/JiqdO81zJK
	4GxLi8EWj3Ewt4d2jF7SutDybIX2HX/M9FDlz7rqTJGenKtFBCkuEwB98YoO25RJgJZNEW
	ifxl6+oGTCPPmFVn71HzsIP1OjGz25s=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BXLEFkGJ;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774364816; a=rsa-sha256;
	cv=pass;
	b=Vjlkp1xqKGA0oGboJ5SGeboxT9Xp44gh7lK6nnPEh5CvZciBTByAIGXbl9L2pjbIgMFQqr
	QcSq8oRM2zKy+1tA1biaexmimTz/vyZFwKIr0tFrUz14+UIRvJAuZO113nyivs388+iSw4
	1v/UtcUxV50BmFK0HmqEahyB6/B21cg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zRA4CJ/vK7ZTmwRGWn8Nv/aps9hAODd9urBIRsjUV7MVDVUoizyqaVbN5Bx6fM0VjY8YyhJiGysXQtEAy1XOwPDrFw+gIhRtbbWlsxFYFruNGt3TgbAy4eTS/8oI/MMeQ+7LdLjP1SfRVjsfopFJInpNrNGHssXY3tMw5+rwtmjnSEEe2JZH0JimisRQFHFSzkQ6mI7afRoUfQTxRC8fFxlG7R7+gQo4aY9x3hJoq3Yd8c46IB6eATy5P+T6jZ2ARQNziyt+V09AXg24676Z3tiJKIsYcDKDVaaWutxpQVIu+sg6ujhKRJx71jcNxCk4HdaQH4Wmh/nECFWfnGpTyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKlppWYwKZbS1K1WHMT+SJd3reC3E0800S5Qh6kjCdc=;
 b=pmwUV12iTNr4FXkZFEex/x+/w8UnYzlgdjr+Lh+JASkgSLE97pfsfLcgrB4x5c34r0uaAUjVUQi9daAuX5h3bZSyK8V9hEioCr4egn9Qk/gAHuOVYefJOExuAjoq9sgRAgPUnPLBqQzE3q/gfeq1T3foRMc3SW8mIbUMK5ix6BEsBUpyk42H6hSENb8dg8gi/P6h+JuDeAtqx7UXQ8dZeP+OJT0Em1He+yaC6T9uUcDpoApKg+3kw6v3GqkSJ8OpOuZIaVPt2uV15/XRupFOMmCQRn+zNRA6X3cbmBzu67hxZbgIl8OSjwCjGJnjN08KuypKqwBNt4DnrgGHRnV3ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKlppWYwKZbS1K1WHMT+SJd3reC3E0800S5Qh6kjCdc=;
 b=BXLEFkGJyPIWa8aMLPu/yJ3xlSoQFA/eYB5IcV/vOk6Mt5A6PeaindvrQKfQWUSIu0c7CmCdJZFa4ZtfdNYreB1TBoj+QfV0XXmOqsUIZ96sHIhKn3SglCxVqk06x/0Tg873t5YFdi+V3RkxrAyhO9LWM489lsqdcuCkdJwd07s5ORDh8Rr64gq6Xvdbx/W6qkcd5YG8ulPi5qqpRo4ERmsyhY6ckaB1h5dwzVwaWw9IgYixz3LumvyrQNEC2Si067d/0YDjxlzCLNmMo8MPsDR97aW7O8NulF3pt7WCkapMb5Dg96ITO4u7u9krmP5H30K+itldAo6yTDSB1wje/g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ5PPFD5E8DE351.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Tue, 24 Mar
 2026 15:06:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Tue, 24 Mar 2026
 15:06:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v3 3/3] mm/page_alloc: Optimize
 __free_contig_frozen_range()
Date: Tue, 24 Mar 2026 11:06:46 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <309C0716-A53B-422D-ABDE-E865DE0473BB@nvidia.com>
In-Reply-To: <20260324133538.497616-4-usama.anjum@arm.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ5PPFD5E8DE351:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ff77bf-5c99-49a5-442d-08de89b6fb01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|22082099003|18002099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	rCKhN0oPJd4Fg+gwjw1fQMW6+HlPvEspQUqjU6iCjONEcOkmUvbERY5tZqrMGAbkNl5XnMHrwGma1EfovDtVE6H17iV0pEtDoWLIyrnjnByJ3JGH0VWp8JugRHC7NJL2QsDmMDo5f2uPoY/2w6/4p8YPSfShT0M+/AxpgCdljwwnaiVrx11xSNtQYSjiEWfYwTnvJ3RIyaMfQvIVJY/uhtzGn4iJlI/YnJgeokk2Jf7n8/nwo1l2dY/L+KAK/7hJNPwl9z9LnLJkU9HxKacO4i8mMvbjuhaujNM4e/MdZH8XVzs1JZzv4pLVpxyjHeMoJdNlz4sCUJAivkntrGyUB9TsbJSHbiOxlPwXqKHOjPqi14GTd/zzc8ppVKLmlbOutXyP+7ek2d/hFFns06AZoDywnqAnt/nvKk/SuIEclki98zFikVRgMHqDLDH9TDq0Eu30Yr0h6ZsyhgLjS64nQSK2bVPDqldyPTYHZnbSsQIG2775xJ8ihLZGJ0LnAHNrBfTSktkhV5NGkfIscF+I8vBa8exIT91FaRUPZT3wqTxmIZOflHEcqNC76UNs8mw3dwr9PFOWNJ1NX8U5cDbKtxW7jTW3kwq62rUxfwuA5hEtBq3wGodX5vX5SaZlGy01lnlw+xmVgI/TGuKoIsivNLs33PeWd9Y9CsrRFy0cGVI9pc1LExHNLgsG/fRthWMe5cejr8FX2KpfErHo99Hu5qw1YgzTYLLuJvazR9fib5Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(22082099003)(18002099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmRtZkplb0x1RXEvRjZKemgwQWV4SDZJWmxkNXlNUWZjL1pyY2IxbXlyaHln?=
 =?utf-8?B?WldTdmlvSEJKWjl0Z2dxSjR1cW5XL1hGMmFsRlQ5blYzbCtqRzNQRkcwMFVv?=
 =?utf-8?B?aXFSa0IxNFI2cFBpYTV1MmMzZFR0VFNOSTJlbzJmbFhnUWFyMlBYR3Z2bGI2?=
 =?utf-8?B?bU9VbFlxbzc0MXlwc0NNdE1YdGJOVjgwc2g0bzRGbEdpUjBIVHdNcGRDeC9K?=
 =?utf-8?B?dm9HUitFSk1QTy9VdXlXYlNxaldGMU0xTFNlZ3Vua3VINlVNV0NXSk83Y1hE?=
 =?utf-8?B?UGZ1T1BRVVp5NTRYVVNYZlExTERIdnR3VzBlVkFHUCtOT1F0aTdUREpEWjJM?=
 =?utf-8?B?c3R6ZmI1c0phdWlpbVBrSzIySlQrdm1PUGxQYmNzeGx5d2VSeDlEMk1uNmEx?=
 =?utf-8?B?ZEMvK2RBemp3SHdHajMrL1RaL2ZUUXlvalFudlhQY3RvMFZENEVnTWhWY3Br?=
 =?utf-8?B?blU4TGFPSkY3VEU1Qk1CdHo5YmZHUzdlcVB2b3daWk40cFNYYy9iWm16SW1a?=
 =?utf-8?B?YU5tQ0djZjRIN0x1OWRqbTJ3eE5tL09IZWFwNmprREVUL1JDMEcwRDlIb0dj?=
 =?utf-8?B?ZDM3U3BPV2pxK04ra1RFL2cyQm5EVm52WmhkaFRiTzZBL2l0MGhaMTA4Y2FS?=
 =?utf-8?B?eENVS0F0Rm1MNEZFRjUwdnRDbWZPSGp6NC9PVk56bmRLd1JtOWo1TWo2ajF1?=
 =?utf-8?B?UnRpNlJpaVlDQW9rTDNlbnJJWEZzUHFjVTJjY0Vhd2drL1BMcjhZQkNPSlB4?=
 =?utf-8?B?V3FnbTVlL0hMN0IvU2h0ejJUTE5veVNVYmFsSXpTNXNaajl1RmdzMFk2Ti9U?=
 =?utf-8?B?c0VsbEQ0bjZqa0VZOXd2cVQ5MTl4SFJMTTRkbXZNUUd6dWxVbkx5YmxqUWor?=
 =?utf-8?B?R2hQWGtHL2ZNK29hdW1USVl5VVRtdExoQlZQbkVPQlBMRTgzNG83ditTaC85?=
 =?utf-8?B?ckZjRjgyM21VSXcrbEkxeGE4bkQ1UUNublJSWG50ZHBFcERmL0lBQVlSTmJX?=
 =?utf-8?B?dFYyTmM4blp1aHFXc1d3bzhTVjdLUHZwOXgvaG1OOWNkZ2JSTXpROXVWTGls?=
 =?utf-8?B?R0locnVtWkJybzdTK3pRMGdOME95cFZZVms0TDZpL085UFloTmY0TW1kUFI5?=
 =?utf-8?B?Z3ZTSW5ZVzNBNUJYUmtOT2ZmdW9qVDd6N1lRbHpEVkxNWTg2SFF3RytnQmox?=
 =?utf-8?B?QkNiTTlrNFowY2JXNFJiY0cyRDQ3d1pTODlIejY5N09lNFNpVC9iQ0lvZ3Nv?=
 =?utf-8?B?cGdlNzZZK1BJbUE3eWJCa3FMVDVRdGRFMmswWU5HUHE3Slg2WVIvL2hiUEZs?=
 =?utf-8?B?YjNmdnVZL0tUS2FJWW9iUXNwSGtEQzJIOUZIckVlQUlYNEx1SjlYZlJZZGhL?=
 =?utf-8?B?UHB5d1VhSm5lT2xFd1pMeEduNFE2K0g0UDlFRXh4b2M0WDQ3ZUQ0ZVduT2Fv?=
 =?utf-8?B?anFwSDRMZjJMb09jODBwSGoxRkEvY1puRWlEVjBad0lDM21pWjhrOWg5V0ND?=
 =?utf-8?B?Mlc2dnpkdVJ4bEpDNDlDSW5oTGZKTVoreDUzUFBIWjNORkt1NFRKaERsUFVk?=
 =?utf-8?B?d1VrTEdPSlpHeFdVUGwwSDZLRXBPWS9HaFlPcXJua2I4b1E1UkVzeTZ5TW9T?=
 =?utf-8?B?RGZ0OG1OMXhQK3VtMXNqQVVhTmluU0xPVUYrdlpDTzdXb2dGOVZBbFRkTTJT?=
 =?utf-8?B?UmtZNkRDU1F4dVFPdnp0MHQzeERvWGJTQk5sbkJLeFRvY0FtQkU4aXhBemxB?=
 =?utf-8?B?UXMwaXJUd3h4ckF4ZnZZWkhDMzBQNHNmZlA2aTFHa3A0YVFtVG9jU0JZVVdh?=
 =?utf-8?B?ZlV1WWlYdU9mZ2x0Z0FLb1N4S0dpc1NjZ2N6TzZIemk4aWc2MmxFQXdzVDE2?=
 =?utf-8?B?WVFZN21tRStHY1I3c05iemdFUkMzUmFJbjJSa0o2c0I0U3RncmFDTFl4WWIx?=
 =?utf-8?B?ZFFwWm9kRnJaOGFSZDk0RFFjM0ZyNTdJbjB0MHFWdXRFZGxHM0h0a0tVMm9o?=
 =?utf-8?B?M056cHozaWF5N1BDVzlXN1d3WllsWW9qMGcwLzhaNEo3OVFKUWQzVWhoN25x?=
 =?utf-8?B?bTlQTUNTRUt1dkNKZWt6RWsyOSttekJmeGk3R053NWhiS0RvS0p5Z1lRVmtk?=
 =?utf-8?B?cDJTamk2WFRYVi9tNjR6YjByVWVzVG4yTkE4ajdkclVtejBocmdTYmhBdDM5?=
 =?utf-8?B?Y3BhNFdJeXYrREQrMm85ZEx3Zk1PK1NacGk4U0x2M0xYVVYyc3p3cDlERThl?=
 =?utf-8?B?M1JIT3I1STBBelJzQ1FlVDYxOCtBdWQweTQ4a0tQa2RYUW55Y0MwVGEzc2o0?=
 =?utf-8?B?a1Y3UlZCYnVKVzlDZ0c5a2hvQXB4UnlKWHQ1VmxBcTYxQUlsMFlDUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ff77bf-5c99-49a5-442d-08de89b6fb01
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 15:06:52.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9P6jp0IRZJvMDxVN72Sq2t9d8VwIipeWgrHPvexTZD+Yd6HsXEXa0/u9/6GEoba
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD5E8DE351
X-Rspam-User: 
X-Stat-Signature: bpkh1eadu1f5greoztjtx37r61pfizia
X-Rspamd-Queue-Id: 14398100014
X-Rspamd-Server: rspam09
X-HE-Tag: 1774364815-737555
X-HE-Meta: U2FsdGVkX1+5OBTc2pKTbZX4zy8mU65jjI7QkvjGSt4zMM5J8dsF8Ljdcw4HKpe1uVpl5t1dLmhrfDwUBzGs9oQvZFZlvJ+z/G1/0u9kRtIaFOzTs1RXgfMflG9zXzBN7F/7aCBKsW+fRQD++zvONtDXXUdA0bV/8ca7l/YqByXgGr+KGo2FfGy31iTpLsT4y7kAz1uNzbq4N4TERjNT4LOY/MCrTrL3aQ2hAXJ+F5l93hCTrj+srPYGFIk4kAAcjYvnDgNA6q7bzVyatQBqQiKRwWF64ufxXiqsReu2AB0cVSTSkSvBC2DTk3bWMEBC3zJxIzj1BsOGE0O8EEA6yn8IGIlQqZqsK7B4TkvgBCOR0z/V+lz1QQCnKrQuleDwlQjpQupyGZTcoJGiV2s9QQafYwZfxFQeYyVbWXbH4mUhFmWAI2xTUQRlVvxxT3OPJ8GOCRRxN3NqRamjRlXKvMlNHTYE7S0xTflYTKkg7j+6+iWF1U8wFysRbKdfnlc7WkCPsgmGRZGzqA/mZWjxBetlTLQS4KP4Cauv7go+xBaEiEBSVzxXqGejB2v9C/QiqT1/Inj/kSoQimMwKwAhSprvb+tHdKnRJX0CiaSb4aYlV32M9nLG0Hs7yrmJK9AKvBLvgj/n6IVB9eLEetMHDEL6pYf6EGPM4Ekf98wrc14i5TBdfIF7SkfEV6umlRC9RdboQmpC4iNRu2awTLQNe7xVWQ/MYrw5xEgkdUC+3rzX4d9I9es0fu06Dxji/KfYHpWL49YGaxVdqX3HJ6HEpnHg221uU49aEgtn1wu9WO3lhhohyg27j/yWYkfplE1j8rYf+IntyUvji9eapplR7SGPpA3Wr+if8m9+L/tO2WS7cb51NCcdptn6LPlj22pES/rWPAAODUUJrtUMJgtHk6R4763JHC3vacnokpjFDJhxuVHAbBq9d9KdEWs3i+7E4LQpauLCPUc2F5cH51Z
 dqZKYcZE
 CPP5wslqcOfssUzJNrIrQoZl1+JMjnjgMg50VA8Hv4/KbsrN3mSkj5VNy6KFE5G38N9PL0zK/QyKm8D/L3s3nUSs6EHYky1sMr4Kh4baizZfc+iMYK688KVTM4ojhdOqwfTJ9/Lj/B6VI1cXANOff0+5J4eJPOjJhnxBTzAA3yPlhG8wLqOwf2T9vwciI3SH3e0iNGl7DaDoDHZ4shvPuPMiLWEIyupgB0uJq16YOwa3aeeM5dcNX0aO8i/j1+veLPG/nF/xy2ts/rvW/G9e3CcgZd2Lf73OS8pL5uGs0KIBQnD/dUEfs4VBFP4VT1O5Sx1DH0HrqhBre9/LkSouo3+LyigNbyL5rtos5nONyHPKC8Qan2ZWDKTTnZQluiPZ76ZJN8Df0Hcjwlox9sx3Kmsn6SknVSmX+6CxgvSvcRRhJacPD3T0KlsLkuKMEHHgsOyjs0cSv9MGB60tnSMDleruvgWTs7tyKRoVseuUh4SjdyxHYcjDZRBwQj/+vIzOc9yp90plr56KrYkPCsHuzXgyDcB/H0s7muQwayilaBmCxG52XtXBCA1fCHBf0QHY344wF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Mar 2026, at 9:35, Muhammad Usama Anjum wrote:

> Apply the same batch-freeing optimization from free_contig_range() to the
> frozen page path. The previous __free_contig_frozen_range() freed each
> order-0 page individually via free_frozen_pages(), which is slow for the
> same reason the old free_contig_range() was: each page goes to the
> order-0 pcp list rather than being coalesced into higher-order blocks.
>
> Rewrite __free_contig_frozen_range() to call free_pages_prepare() for
> each order-0 page, then batch the prepared pages into the largest
> possible power-of-2 aligned chunks via free_prepared_contig_range().
> If free_pages_prepare() fails (e.g. HWPoison, bad page) the page is
> deliberately not freed; it should not be returned to the allocator.
>
> I've tested CMA through debugfs. The test allocates 16384 pages per
> allocation for several iterations. There is 3.5x improvement.
>
> Before: 1406 usec per iteration
> After:   402 usec per iteration
>
> Before:
>
>     70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_co=
ntig_frozen_range
>             |
>             |--70.20%--free_contig_frozen_range
>             |          |
>             |          |--46.41%--__free_frozen_pages
>             |          |          |
>             |          |           --36.18%--free_frozen_page_commit
>             |          |                     |
>             |          |                      --29.63%--_raw_spin_unlock_=
irqrestore
>             |          |
>             |          |--8.76%--_raw_spin_trylock
>             |          |
>             |          |--7.03%--__preempt_count_dec_and_test
>             |          |
>             |          |--4.57%--_raw_spin_unlock
>             |          |
>             |          |--1.96%--__get_pfnblock_flags_mask.isra.0
>             |          |
>             |           --1.15%--free_frozen_page_commit
>             |
>              --0.69%--el0t_64_sync
>
> After:
>
>     23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_co=
ntig_frozen_range
>             |
>             ---free_contig_frozen_range
>                |
>                |--20.45%--__free_contig_frozen_range
>                |          |
>                |          |--17.77%--free_pages_prepare
>                |          |
>                |           --0.72%--free_prepared_contig_range
>                |                     |
>                |                      --0.55%--__free_frozen_pages
>                |
>                 --3.12%--free_pages_prepare
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v2:
> - Rework the loop to check for memory sections just like __free_contig_ra=
nge()
> - Didn't add reviewed-by tags because of rework
> ---
>  mm/page_alloc.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 250cc07e547b8..26eac35ef73bd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7038,8 +7038,30 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gf=
p_mask, gfp_t *gfp_cc_mask)
>
>  static void __free_contig_frozen_range(unsigned long pfn, unsigned long =
nr_pages)
>  {
> -	for (; nr_pages--; pfn++)
> -		free_frozen_pages(pfn_to_page(pfn), 0);
> +	struct page *page =3D pfn_to_page(pfn);
> +	struct page *start =3D NULL;
> +	unsigned long start_sec;
> +	unsigned long i;
> +
> +	for (i =3D 0; i < nr_pages; i++, page++) {
> +		if (!free_pages_prepare(page, 0)) {
> +			if (start) {
> +				free_prepared_contig_range(start, page - start);
> +				start =3D NULL;
> +			}
> +		} else if (start &&
> +			   memdesc_section(page->flags) !=3D start_sec) {
> +			free_prepared_contig_range(start, page - start);
> +			start =3D page;
> +			start_sec =3D memdesc_section(page->flags);
> +		} else if (!start) {
> +			start =3D page;
> +			start_sec =3D memdesc_section(page->flags);
> +		}
> +	}
> +
> +	if (start)
> +		free_prepared_contig_range(start, page - start);
>  }

This looks almost the same as __free_contig_range().

Two approaches to deduplicate the code:

1. __free_contig_range() first does put_page_testzero()
on all pages and call __free_contig_frozen_range()
on the range, __free_contig_frozen_range() will need
to skip not frozen pages. It is not ideal.

2. add a helper function
__free_contig_range_common(unsigned long pfn,
unsigned long nr_pages, bool is_page_frozen),
and
a. call __free_contig_range_common(..., /*is_page_frozen=3D*/ false)
in __free_contig_range(),
b. __free_contig_range_common(..., /*is_page_frozen=3D*/ true)
in __free_contig_frozen_range().

But I would like to hear others=E2=80=99 opinions.



Best Regards,
Yan, Zi

