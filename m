Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B991C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FCB16B00A9; Tue, 30 Jun 2026 18:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD3E6B00AB; Tue, 30 Jun 2026 18:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275666B00AC; Tue, 30 Jun 2026 18:48:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0EE86B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:48:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F974120143
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:48:50 +0000 (UTC)
X-FDA: 84938070420.18.304FD7F
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011063.outbound.protection.outlook.com [52.101.62.63])
	by imf11.hostedemail.com (Postfix) with ESMTP id A554E40007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:48:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UKL1fmu9;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782859727;
	b=Y7uUfPWyHFQhXQNnyci7/nGX43Pl4GgtPSdR+lSoggzHsghlPmaQG8I0GANo5JZsaCa9hu
	4UtKZGzCTOpD249dk1KdzIZ+r4BfmcP2c7umdXvDkd+OaSqPwBW3pccD9EMq+nKA2FZNXj
	127nVYunRyYeqCSGh+V4qFXWNUoaG/A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782859727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIAXSlBGPymRjo+9hVDcf5njhn5Bx9XkxeS+VgVDhlA=;
	b=01D4JzH6fuX/5zi2FBON7JUjawdo1Rm/42HKtwKw2wKA1e4PhRHQj7I3u9tVWs3q3F7xaL
	5q7/FsQAq0jByg4zcNv5pcQxExQmMXnY/Vrw+EOG96vtyi/CtvCHEh0zz4HrWAG7HN2zUs
	uAZwKz9hp2zDTQVto1I0l9u/n2ND4T0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UKL1fmu9;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfLi+r3X0kyIcR6YKE8cfyXfqWtw0qrKvvZbhYGpSt1nrxeaLYEIlXYIxDIYcMyWOCYKuGinD9sf/s0Gq3VfBHN4mXkDdmeXUaX8+aV5bh2ozP5p8hTfc73MPn5h6LMHsy2+2zYK+E5kjnIkoH7UUT21GN6hYXpF2Ne62aeOkSiNZ9i0Fpwo9iM/Hbts1qe9uP9f45HrzUnoJjFuSSNR5L3roaqWZI8z8VvYE3lGI5Haqgb5OqN6YYzKUtiYeiTCaSWsLQR2oBiAx6mu4osTMsjaGFr1wRl94jV+ZmZx5tAeVTZShHxbnUEvPpx9DqVQoDOFZ+zW7MwtFij7fq54QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIAXSlBGPymRjo+9hVDcf5njhn5Bx9XkxeS+VgVDhlA=;
 b=c/2E7H/2iY+V3kXVOPrV2moDSOQbK1u5LyY8nJk9fQOd2ykFDqzWuYLcB1EWlLHMR9tPxvHJ9TnoIxffF3rQ546o3zoyA6rexQXDDTMDInExNwgXtQrJMAlOUVRPPe62dkUQvqewSBMP998xeZO3zMtP3rk1fJBQqsX3UFS9qWjoU9k4v42ZszCBUkZtGPMXZsI3p6aDR15WulC5JsDP2Zgampi7NZbn+5NfwKQj+P6i1BuFMlXSx3mFg0joz1xTHOQkajhDKQwt/M67ezuRZvZ4Y2ZUwl8Bu4piacyTWdr9p/4aEMc8gC5gS2/3DGK3pDbM4LoC2eCZfG1aHMb15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIAXSlBGPymRjo+9hVDcf5njhn5Bx9XkxeS+VgVDhlA=;
 b=UKL1fmu9mIfRHLnKaOkLlLT0jrB8NUdhZZyMmQD6+7ldncSkau0XbDO88bv0VEo1STVJTxjToqeHZWGUK0eQhGsRnxfesCOM63UC3llMcSy5YwIPD4eVfA/9xWJZUGx/qzs6PllqdhXoPY+NDpYFe/L5onb1fZW3+9r064soLbVBcpgHIW0U9xYhmlObWeIh1rPDcHZN3Q/Q54ACMI0MHPPf2B1ZJG7MV3ZxemoEIuQI1iDE1wMpKUlGql7FanYkLRSn6mkkF48MqqOKJtdL1V9Q2qmka+M0GtRdaowGZK0INgOKD8lwRQT+W5R4kGN9jZzxy4CrOmp9UlXD4Pk8gQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB6352.namprd12.prod.outlook.com (2603:10b6:8:a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Tue, 30 Jun
 2026 22:48:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 22:48:41 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 18:48:39 -0400
Message-Id: <DJMR0W6NUSAI.3UF6I74VFDFSH@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Matthew Wilcox"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Song
 Liu" <song@kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Eric Hagberg"
 <ehagberg@janestreet.com>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>
To: "Pedro Falcato" <pfalcato@suse.de>, "Gregg Leventhal"
 <gleventhal@janestreet.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com> <akQIIav_zaK6RmIC@pedro-suse.lan> <akQO8JtTxmp89GS8@pedro-suse.lan> <akQekZUyoKadiGCH@pedro-suse.lan>
In-Reply-To: <akQekZUyoKadiGCH@pedro-suse.lan>
X-ClientProxiedBy: CH0PR03CA0417.namprd03.prod.outlook.com
 (2603:10b6:610:11b::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: 54a2a9b4-db0d-479a-09e6-08ded6f9bb2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|5023799004|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	uSb0HyBRHj33jk6BOVUEHQ8wiVrf9XdXGWbaSQ7+4RKXwH86NWQxTi8QXUERzuKXXcvnAvSP86U/Mhp6P2NuwAb6qB3TMT1owU0NMSc+7/yTdLEvRe1V88PalHhqAeziRa9bjA5CdSxA8o3SLlN/lj9/zw47AM/egM71h+/EZ9s6l46AXDSx7GqipqJLwZRMMuqenJLWypnjXnK1r5XzoozyDGTsZ7ZxB3C8EaJd8bBx6W00pVA18VYB1oWjQfwHQJhCgt+JSf3L0jwvo8e5M64ugfx0Ksa7+VfxiasneoML9SyTrHrD8Rg7eCq7qgD00nrWhg8I6XGTw68h0nBhIw/0vh9nkZlS0x3xh6R7OQJvyky2GXWDjY8CUiDKLHUdqC9R1XY1dX35kTdukwH2moTJw2bjzPkl79hBrDYEIa1ZnpXPbMwPgBalCGbK2ZbVXUj9dxZs6RNCQsrztoLLkN8/z+ME73aGtKgatpjYZhEMxYI7UcfuwQffYmTIZIxC/0WgEoR02fY6CrQ3d+OtFEYVr7O0tl+3hJ7jy1mSUUoULX/URbX5ulbKZj87GypIe2IH/D3ikBJazAjw/4/1ocGa+ZURC2wjbOdPfKmmjWuKPHyP0TLoAqoRZRgt8yR6TfP6v3OiPv8z6Htqb0+K4e5W/jsfn0i+/xuN06uSutY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(5023799004)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elplUzNWR2thQTFGMzE0WHB6Z3JEN21SbkFrNE5kRjZEMWZDQU9xalZXUm1C?=
 =?utf-8?B?NlBKdEFvY0cvTmF1bDJFT2JnaEt5ZjFxajc0Nk02Y3A2MTdGbDVIMnZrVHlM?=
 =?utf-8?B?R0RSN2JYK2VaQkROb003bDJ4UktVeDdKQVNXbjVPQUNLcDI5L2N4OHp3aktj?=
 =?utf-8?B?ZWtZY0JCcG5Tdmp0TkxOZXpEaTNpdkhnMk8wMHBHOHN1R0NBNTk5SEZSNzRF?=
 =?utf-8?B?MkVlSkp1NFdVRTB4TVBUbnBtMGNyMGlveFhSWGVZK1J4VkRUVmZqWTNKdktK?=
 =?utf-8?B?aHNONTR0akxsS3h0NHovY1dTajFpWEJFdUNHL0FLem9PUzN3eGRvckhhWUVC?=
 =?utf-8?B?MWZ3RmhzUkNBYm9QSWZ0Rk4wVGsxVDRhUXc0SHltNnVyajZuTnJvUnh5ajRO?=
 =?utf-8?B?M2d0YWFvWUVyTHVoQVdjQU1sS1pmZVBnTnUzSVQrRDd5T1lYV25zK2Q3VWdL?=
 =?utf-8?B?N24xT2pUYTlmUnZlcjhLL3k5dDZZOWxrUTJVOVhDTUdjQmhzMGZMTEdOcmFM?=
 =?utf-8?B?RGUrd0NMaWovZk9OdkhZWUFlZnlyUkVvTXJ6SmQxeExTQnh4UGNidmxSRm5h?=
 =?utf-8?B?ZjMvV2d5N1A3YlVYSFc1cm5HY1dRTUVqdHZtNS81dzhFVmt5TTJmQUFSaHZn?=
 =?utf-8?B?dUNrY1Z4WGZvbGxMUktyK21GZlVqNzRpZmVFUGNoalU2MTBPZXRObGltRm5K?=
 =?utf-8?B?SEhNSzV2QnBTcmlLZWs2Ti96VUlsQkZ2ZDBuMExGaGNBWnJmWU1xLzllMHc1?=
 =?utf-8?B?bXpaYmx0NDlSRWdrek9YamdCclFwNzRTSmRGdDNPaGEwemNzdWU2Q2ZLUnBr?=
 =?utf-8?B?Tm1oek1qVTdobE50QmxPcVBwR0NRaEQ1QkN5Z1FFd1puZmdGdXY3SVRoQ3ds?=
 =?utf-8?B?bDdzNWRSanZYZFNEN0tYdDVkWGtFaDNHaUt2Rmc3SmlySmlBclhIVjVkTld4?=
 =?utf-8?B?SFFIMjJqUnR4MGVaalAyMnczRlp5TXVQVXhBQUxHNEVsVkFGMU9WaE1XRUZV?=
 =?utf-8?B?Z045MXRLUHc3RWJ5bC9mdmhrVnNrLzU3QnladUEvVENnRGhxYUljUnFFMVJN?=
 =?utf-8?B?SFhMSUJVZDRhNWhaUmNCVk9uc2tQSTh2VUtDWWJwV2NMUU4xOUJieW9XUUdN?=
 =?utf-8?B?dFdRNXRCU1FaTDBOUzhRUVlsVDErZkVFUHZsVFM2MXMwWjQ1Qk5vSklCOUQ1?=
 =?utf-8?B?UlI5YUFmeVVKNWdDTkVxOVlpM3M0TnhyK0lDbDI4SHRiRnFMK1dYN25vaFZY?=
 =?utf-8?B?Z2l6YnF4cEZ4QlJlL0Q4dEd3QitwT3VDbHd3bFo0aWxsbHhZVlpwdHd2L2lO?=
 =?utf-8?B?NlZsUjMzM3FQSmtJVUQvQnQ0MWgvandKMkh1NWVFL3NOZ2x2ajBtUWxmUDdl?=
 =?utf-8?B?S3lRSG1WdCs0VmgrT3Rjem1aVFBEWGVkV0dWa0ZFOHJ1QjhJZVk5Nk8raFQv?=
 =?utf-8?B?clMrdVJnT1g3d2F6TVJNZVB0djJkSG9uQzk2bGtTdDA1azl4dTNIMC9YWDFV?=
 =?utf-8?B?c2U3N1FmTGlhK0dycDlpdTl6cDVOcGh1WDJpVGVjdzBpU3N0RVdjTlU4bHpS?=
 =?utf-8?B?WTIxTWFObGJ1cTRleHErMzlVMVpLcy9pL1BCbUwvMDBiRjBOeDJBNlFITTlP?=
 =?utf-8?B?eUxoZEhjL3BMTXNMZXljYVYxLzhXYVN3VGkxWXIrSTBxS2ZIQW5HaHg1dFBs?=
 =?utf-8?B?WjFHUWZnQ1I4VnZ1d3JDNi9peGdwVWhYTW10SU44VjRNQWdGS2xhd1ZPVWFI?=
 =?utf-8?B?cmd0R3FZQlZkakZ4dTVUSnhzTzkvSUUvWm5aY0tGeWhmSEQ4WXQrTFVwNFdB?=
 =?utf-8?B?UE9XOFFLU0szREZ5UWlwczd3RXUxbFdUaUxMbkpjOUhiQjJVWWlZbUVjQW0z?=
 =?utf-8?B?aElTWHQ4SnhUdzZHTi8xM3kzamVKTGVva01iRGNmQlpzUEhDUGs5VFJPOWdP?=
 =?utf-8?B?bnFnZEdPUmdmNlZGYU91YVY0K1VOUkQ2UC9jWlJ3RnRYQmlFUTVZbDJGR0tG?=
 =?utf-8?B?bGJQUWpUaGRsdjRyU25lWE9oVnFUZXZJTDVtb3grZ0gwalpCaVRSM0dUcUk1?=
 =?utf-8?B?MlNFMWh0T0xHZGFyQ2NZYk9aTkl5ejBYZWhOTkQvRlRma1N5VmtFU0tRQi9i?=
 =?utf-8?B?eVA1bituS1ZWbjlyeGlXS2dnMkdUSG1pVTRsZStISTFkbmdRV2F6NTV0R3ZD?=
 =?utf-8?B?VkxiSTAzWFFndEhqMFA5UE82NHJkSDBzaXhpZytFcUdvdENpaitvSi8xaTdT?=
 =?utf-8?B?UmQ4Y204bmgrVEo2YTRQTGI4aFpkbE5OemNxQjFPWTdoR1JwNW9sMWlpNmJw?=
 =?utf-8?Q?WtCtzOADpwW7cTOACU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a2a9b4-db0d-479a-09e6-08ded6f9bb2e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 22:48:41.0217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ee6PzQmrjjqvmU5vqYemQ9Ra4F86LvBrlwQBWxlQz1KihQpkMxh7a+G97NrV8nx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6352
X-Stat-Signature: 6so3ifjdcfma5ysddztmrnbh55yrcin4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A554E40007
X-HE-Tag: 1782859727-872882
X-HE-Meta: U2FsdGVkX1+MUgokTPVPiJmKXNVt+YkJvAgJxKQuM9cbayemSyQEqohxCgSU+FctD5C7wEZSahQfQe0N3K4Xb5NP+7ZKN8PJTIY3coLAywvAmJUlRxi0QkPY3rpzHfDtgiXMI3Gs+znKeLIyF1YmMPecWXElyLRZkZuKYrpRcyiyHuhQ+jBXpIvrDtW5O06AAIhR7uPnGEDkKNaXLbu14cnBS+J8Q5D3RPW0lacUxZYnAgUEFnazi5XWaoQzj8MLZ0eSggjyCUjJDS3E1UIwJaFQCaVwTTWbZC02VTd8E6Kn/i8hS7fOtyjZ8JpwXe3YSxvypAut4Q+pHGZPwNS/AVmnyPX1PMPZMs+gm38SK+vsK4hr1tVj9llTbpgntqb/MWMqSKzNZ0YN1uM/3vd2068tAyzvaigMIISan60xTRit4AwUsCAayt44+PsWhtUXLPm7dIgV4i3a6z2zI6pAVab8DLmohQEXiROCzZCLsSs0+woVBOCAEUSubPufN9bX8Uia4J3VpSCuqqIkjXyoFC7MQqLmG0FCJNmnQMKPSDq73O+2AXcZKe8ybsE8jCDAeokmgFsRNXzfwd2naAcrxgwgqid1W9xC8fd7v7KlKpYoqbCt89wHKQUI2q8hMEbyVNBfWDDgbS6i2h7MoNnJBHSrBdIXDfN4wcUZHBDX0caO/ZBkduPGzUEE6I7vitBMlCuZlSxGt//D0t7bNo3IME4SO21yszqaH/rhPPtI5ImNJl+L9ddLhCRZ40thTxkeD4tZYQAu/0+FeHMaTt6Q/G6fTvyBoHWxvnfV3cV7JYU16HP0M2eBd+Xekvmx7yq3S7uri2dfLHZG0mMr4hSq3PPVYcwQg7qihIsvGY1x59W1Aj3bCfnA5ebyETbKeT9cQ0V44fIy+WIK5NAmvkcDifkKkMHCt6uNO3siJ7cStkza628Z1OxYe6JniCiLWsFwiKV/oAmgkXpxm8IdrQu
 +GK2fb5B
 mCAzLdoPXed58f4Fk6AIjexZUvoeIJnmqOhO2Qccumi1Ux2HMt1QGHLSOfAWTHb3BKiJhvpKOlDIie8CofuxRwa3a/CCHukpPdub2sJkKQCsDgCBaE0WCVmxcIt0ttQG6YQ0QFk74unr+NOg2zrFu9j3bWh3IGoJGGJX6ZDLFPHYvm+nczV8Svbg16uF0CdhFx2vtc/t1kO1rFeNArE71RyiUL0NRhQWhCF/m0qu1aqVPQv6M6GnUkTfR8Bdm/BTBViybsO90f/7FNL+lSinaXWC//rZglYsE+kHX0ndHlO0aQAHHd5hny/KzS7+LGS/R+A4KMqUx+EVlKGHyEqxgoLM0LSlWiNWSsitAJ7DA4h0nqoWeW1fDdJUQOL679Rm4RjxtzfX8CIojtzt2Cs/hnJ6F9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 3:55 PM EDT, Pedro Falcato wrote:
> On Tue, Jun 30, 2026 at 07:49:12PM +0100, Pedro Falcato wrote:
> snip
>>=20
>> Other idea: perhaps doing filemap_write_and_wait() after the nr_thps
>> increment in collapse_file() will Just Work and result in a _much_
>> simpler fix. And it avoids any weird forward-progress issues as no one c=
an
>> write to folios at that point.
>>=20
>
> Gregg, if you could test this patch, it would be much appreciated. This p=
atch
> (hopefully) makes it so no dirty folio will ever coexist with a ro-THP, t=
hus
> hopefully sidestepping the entire issue in a simple way. Only compile-tes=
ted
> and not reviewed.

I tested the patch on v6.12 kernel with the reproducer from Gregg and
confirmed that the issue is fixed.

Feel free to add
Tested-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


