Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF47AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47F76B0142; Fri, 26 Jun 2026 14:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7D66B0144; Fri, 26 Jun 2026 14:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D9D6B0145; Fri, 26 Jun 2026 14:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1646B0142
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:56:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C03B40394
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:56:09 +0000 (UTC)
X-FDA: 84922968858.04.C8C1E77
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5AF4140006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:56:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JSCxoRrf;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782500166;
	b=OUIZ9vhYAa/OSe1CY/IZxKL2LaelWWQao6MoglAQCia7g7ipj4T3WTF8FQ23SWZJV7sr/U
	AH3LzJPynZ3fxa4LJp6NYjmJdcfVTvofaaieC6AJd8nMuytdibx3CXLVyBTueD5OvGaiye
	fzl1jIywl0kRT2l5vclIkPJqAE0oH54=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782500166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ityMIRiX93qF9uZ1jWtQhvK5Vv6O9sIvaAbCWVYTgs8=;
	b=mGa2E1nk6SFysGUBcR6O+JuGe0r4GrW9Cx2utdhWxuAs4gdO+jXi7K5TZUz+ee03DMHQKO
	XDuQOT8T5aqOJhxLZ3fCkzqE4PI/wMDRMRxnAr5uA3DIDi8MnI/99q5Wwa0ghmwLaM7dgk
	AY0FnllAvPm/wVwLC3yIqOH1gZEc8aw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JSCxoRrf;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PooQl5JX6UN4nx3XmWCegZWO/7P0F9rOdP+1nA1LaGkozrvhjLyhtI7r9XwTm4Nr8qnv4xpISK7q8m5wt8mlAabkH5qCbusF99+BNRUuXAzZ9DtcSYCZPHrT2foTCGfzZ5CQ156nuWI0XwheHqHguDku85kmK/tpkY34YqMd9vgiceQOAZ4cvOgcSqMp7i4edb4jISPH4KuwrsqItRnEErjsDETEgKg7gwMx0LX36WQS2pdpNc4hVLOuU3TYVAT3LfJnuvvo6L59YP5QXsilaqGZ2FrDgEoicKR/WTijy0Jf6sdwAg7lta/DciutYfSRed81P6WtZALoiD8M9e7Bpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ityMIRiX93qF9uZ1jWtQhvK5Vv6O9sIvaAbCWVYTgs8=;
 b=G9w2xucuKDbXFqMACnn8NGIHwSMyoOqkCKvl0ngzpVzR3hmDvbnhVR2QIdsQnHb0RWprxs9fmOEVp1IDaE1OmuBiMD4g27CBkjxRV8CuYM+fu/Pd/7rKw7nDmxAy8fhQis6bwcIum7EC8CR3QzAoa3RBDfYVK70PQALOaHPUGbx+TEDAVIzpD7nqa7zYCnCbz/vV43k7dt1FmxArlhs3Q47d3PrKLfUU9T6wDKnpDwU0zMpcsiE0RCA6XSE+k7e6y+d0Jm4WIrt3FbHlkUVL4ovXjguMDtZhUk62yvC4UOZbNES7s4/E+DU1inXYJRlgFR7FI/QR2jdvXGHT+txsIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ityMIRiX93qF9uZ1jWtQhvK5Vv6O9sIvaAbCWVYTgs8=;
 b=JSCxoRrfv/ACG3sn10alRFMgRaTeQ9c8bztHkSfTTgXFtbdtblFkD2WovYp5aiS9KIgH1grrU7+UXdLsDXi577ZcF8cDQ4696jINqZkAw/7DNMG8bQH4p/vjisHWBVccK1yP4w3OdD6NPlwhUbRQYA79D5uj39OmtU3SgjWKGacYLiHkGkZcYp04DW2KJDkYVcoTHmTbODWBymWpjRPn2Bd7vX5aynB2Eg75wwP2qaM5l0AUZXoZolJLMi3TcHvdPE8Izz8n0c5ibsFoy5vZT7sGQirdcfliBP6bVT/EHwe5zxaCsZYxHWGXi2us0iMY0VjJByZ5IBGAFpZhqj8yYA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9109.namprd12.prod.outlook.com (2603:10b6:408:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Fri, 26 Jun
 2026 18:56:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 18:56:02 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:56:00 -0400
Message-Id: <DJJ7KL98T0IT.1972P6MFXSAC9@nvidia.com>
Subject: Re: [PATCH v2 6/6] mm/page_owner: drop redundant page_owner prefix
 from static symbols
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-7-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-7-ye.liu@linux.dev>
X-ClientProxiedBy: DM6PR02CA0110.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9109:EE_
X-MS-Office365-Filtering-Correlation-Id: a9cfd5a5-f703-42e9-d832-08ded3b491d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|18002099003|56012099006|4143699003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Pf+YWZ/riJryGHmSH60ti/Zw7AWwQD/9jxb48UXUni0xPPnrqvEMEpPKnqVvp57IW68H7XRZ81PKuS91gOFGMhuHBMF0OUDbsiAjo8V4AeY82fWlX5JnPn24EDeZD7HI2wVDfKU8wxiyAtvB9dqR7MIiEi5LZI4H5qPPOFC0XM7R5F+v3wq4b2gxGp1mQ/8ZUnWndg/IG6IE7tloMqOkfIcrXc3Vkvqr7AKQdWGV1RGxBarvTpFnQc5pLPH3PczxOOLKfVCnS9g7BtVA+0y5/9KRdQ1BvFCcqu/Jge24dGxP3dnteaQbRugqLwOxFdWar2n+rR0uCE43n9+d1jzu/yvr+g5FYbsD+zkPxpw1BnVcaZ3NMY7VFasvTQ/SJxk5MrxA1Sa+umlfhKdf2zUjkgDUq3QohvDgur2cOn0qVpmNLtV+Cw16KhJemp3tB05/dvuCD/GUW6LMYotRwh0HhRLLfLgOBrne2RR0rzqHflZK3+e0Ghg15d4tGgg1E4HtdyfA4RQyj6LMAmK6SE55eP2W5XErTzkPNzyABbGGxILDC7e2T3ekNCN55LMzW6uFOkzOm8uaSEB2X/KPmOvaPkb2oee13GAEiZbhj+IvOzi3xER5yJiztZTmci1N/i4yKmfhsDUzFZ3C2R6biKnzTQJha07NybMUMy+4HISSmJU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(18002099003)(56012099006)(4143699003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1JSb0pEbzdXZnhSUnNGME00TUZIWU9MaHU3NVhmd0MvdUErK0VrNjBWdWdH?=
 =?utf-8?B?cXRlVEgrNTh2cHFmNXh6dXNRcXIyTzVJKzRKeWFmdkFvcUJsWXZiM21XOE1S?=
 =?utf-8?B?M3N4TzJYM1QzNm5LMHJoOThSQ2U1MkVDTUVLcHBVN2tWRVIwNkxPVGhlaEhN?=
 =?utf-8?B?bzJaNVVKM2F4OHRSQlVnNzlSem5MQVBueVpPWkFpZS9RU0ZSR2R1N2JWQlpG?=
 =?utf-8?B?VnNSbW5HelFqd1ZWUmY5QUNBTTdBU0paQVdnL2xPVHE5Ty9tNkMwUHhMeDhW?=
 =?utf-8?B?aHdIdEpPMnJNUklMTWxmRTI5WTZEc2gyS2hrcWtucWppb05rRGlhKzZCZmpE?=
 =?utf-8?B?akFCMlVYeXhITUhmY1Y5bWhzeUNWeWpIVnYzOURaNUNFeWdrc1RZUERIY3c3?=
 =?utf-8?B?ZHlkakMvNWttazZjZDV2MTV0TnorWkdnZlMvbUtONEVuZ0xWZ1NuS3VqWDBz?=
 =?utf-8?B?OTlMR1lXK0lGTjRxdC90Z3hnb0g1OU8zeHpCd3BrcGo1OG9CdkZ2UHhPS3RU?=
 =?utf-8?B?SXJSOGZDYUFHOTV3RTR2KzV0NDFiVytNa2NCejJxSDFvWmRqaHdKUnYwL0VO?=
 =?utf-8?B?K2Uvdk1aNjZHd1JHeUlUOWZLVk1uem94Y0JIRXpDS0NpblJRYm9pWG13WHdF?=
 =?utf-8?B?UllOSkE2RW52WFd3UEdhQ3NtQWd6Y0pONThSZFk3eEFPUmdKdXBVWGJ6bHYx?=
 =?utf-8?B?YkkwbFQxcTEzTDVBamx0ejR6N3prbTNlemhITTlzdmNPUyswNlFYRWwxNXpK?=
 =?utf-8?B?ZEMxMTZiTmt4Qk5aTk9mWUIxVU5YaWpybCtmK3AxdjFzYVA2OUJVMWRPV2V6?=
 =?utf-8?B?R2FOY1NkRXhTWXBpdkZZK0IvbURQSkZQV1RZNTZ1YUgremIzclN0OEF4Tmxw?=
 =?utf-8?B?L25xb1poYlYrY2hpaVhDMUoxOEFldUZ3Z1VldTJwNzFTUmFsTmpRcE1Dbmwr?=
 =?utf-8?B?c2xFU29kQlY5ZVJaR2lDcmx2SmRBR05kVjlXdWNKeGYwUVdWSXNvUXp4OVc2?=
 =?utf-8?B?V1ZiVmVrN3JwcDJFODBHMTZNZEY3VVErTk56WDFTUkNZMEhCbExkbFFjUGxE?=
 =?utf-8?B?aHhxOFhDNnJOYmU1SWdjSmdtWnUrRkNveDc0Y0NkOWJRaHFzQ3MzU3UyOWNk?=
 =?utf-8?B?bXp4QjBVSjQ0OUk4VkNVWmphQW5MYlgyZ3g2R1VaYjUxOHF4OVJGYy9iUld0?=
 =?utf-8?B?NFhpZEdiNDdqdityYjVtcHJ5NVRVZTBveExRcWFMZitiMkZCWTg2akhDWTl3?=
 =?utf-8?B?VVZXSGpmRjRtZ0VCRUVqOGlUNjdjcTJDQjdzVHEzVkpvb0NLUnM2NWx4Tlpq?=
 =?utf-8?B?ZmxCOXVieHQwb1o1akpBL2prbURZY01RVk4zUDZFQnZST1BKREMrN0g5Zjd4?=
 =?utf-8?B?RHFzdlNKOGFWUllFSDYrUXQwVTZkcG5DQW9YU0hsSi9pRTlrUlljTU9NK0tQ?=
 =?utf-8?B?RzZlaGRMOUxYMUdXYlBkNlB6ck4xYU1oT0ppNlhXUWEvRmFSSmZEa29jRnVu?=
 =?utf-8?B?TlV4ZG5jQ3lVWTh1djZLeWZNQUxHa1hkdWVwRkRsT0UwVlVLUzBCbXNHWGdK?=
 =?utf-8?B?Y2NpWnY4ZE5pRFFNakMxWGJ5ZkRCd2krVDcwV2VVRXZRTEdqMVNmeWFUbFdZ?=
 =?utf-8?B?ZFlDUjFOK1lUMm01TERzY3BTNEJJYjlkQjlzOU1DZXB2ZUpNUCtrOGF5OSsy?=
 =?utf-8?B?bGptYVRpaVhDVWVaSE9zN1FsM0VMNDBNUXlTcFRLcmhKNXd3NVdvVlU1NnZI?=
 =?utf-8?B?bEZnejhlNGN4dWNHN2xVRWJjRi9mWEo2ekNRZDZYVTcwS1pMWGdHS3ZOODlG?=
 =?utf-8?B?ZldNUENHbjRqUGRMUmprQlZhYjFicEg3d1c4R2FUZjQ0MUNNZXVPb3ZndUhX?=
 =?utf-8?B?WlA2UWF4VnZuS3FpZlRURDNYYStoREl5VmoxeGt6cERXSjlubWZkMEREZ2pC?=
 =?utf-8?B?MnVzR0tSYlRJRWFpb21uV3dkeGFyMTJyR0dodXNQQUdnUTltSjU0dlhqd3Mv?=
 =?utf-8?B?MG1md3k0SGZMVmh2QWQ4aC85ek95a21HMWlMZmFzVjZvNHFYK1BiVWFieGR2?=
 =?utf-8?B?TGpqWFNUMWtRRHRpS2FkREI3eFBNZW1UZmhCRjB5SkxxeS9TTklrbEhobnVG?=
 =?utf-8?B?MVBqczYwNmNsa1NYTll5RitRNHJscklTRG5tNUhpbVhlWjgzTmgrQWQ3K3hZ?=
 =?utf-8?B?ZkIwR0FHT1Y1NGlZUnpHa3RLLytaQytyVjh3SUlzL05vaWlTTHZBd2MwOXQy?=
 =?utf-8?B?RHRHUDBYYmllTmRxZjJQMzB2UWRXZVdycTJ5Ujk1d0xjeFBVb3V1b0g5Z1FU?=
 =?utf-8?Q?C3lo1T/arlnndoFTvT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9cfd5a5-f703-42e9-d832-08ded3b491d2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 18:56:02.8459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O4pjVOHxGdumMjuF0MwRkz0INsEFJTL+D70RriZT4TNUjfQH+g1gaSUbmi+pvRjL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9109
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5AF4140006
X-Rspam-User: 
X-Stat-Signature: wywcms4r4ezwerbqdhokchgn8xmdc9pg
X-HE-Tag: 1782500166-667875
X-HE-Meta: U2FsdGVkX18qZ2R0bfIrY9TVQA5Cq0xqPRWGgpcUTy3/mCdhHA0o6dZku5lijC6TUM13SSU/BR0hMWPv9AV19z37bhKoJ6qyqViklEE7hU8LiDBI9Vb4/LEKF+KAJyjQ7BuBq+rO9/NLYpvyCKrUwqOzBI20mX1MaQ5/5kidVVFbM2pMLh1PsPIKk5QwUE5x7bteqvbrWyiD+r9Dgg1O0WpseVrT9UAq+0Xy+c3SmpRI7qCGpcsfFWe8UcJtRLuC3M6n0UD47afiyC4n2k2DswHAAwjN8Kdj098tN7bhPLRGS9rMfGcBHLqIFYm+VxHzMgyADgukybd66JxtL7CtTJbufYPPGNUJgaktfwKJcKj8RO2Mmhcmd2OQdo0pfC9eyJfmGBvA7wvu1ktvv2mAtjdOVzt40gfmJ5AFeqRtkdJY2M1u40e2UShkjzYEWg8jnwsqi7Sq6N8yARC5wzb8/RXUU8kmThK4MDarsPiCU4HdodgwM3uCf29TOi+rr9STNUjoQV+dbJ1tTiZsNWpGlRMCdmmDC/GE567uY/2ker8ac9ijFy3Z0qcNUsC4fx0/DGv9mYewCMpM4nGZxh87A8xqrOpD1e444MYACMVxDDo0hedWy2AcWCXiJB72gp4OlNtVwN+UgonOazT8Y+7He0wlQSUQIhtjKfq2t53hoY6RqZk4LybKG99VNB3Nwl1HlfglR8bsGlb9eFoCCjbzfemWoORjQU31n2w3HCJLyebwXLy8bxW71srbOGqUuQepeLDMOt1P1AmoMb7/MgrfDlsptPNbJm3kMnqLzOubacwwOlttWSch1Ii/IceX60eBubOccdFvP1vPhMuIl5GJupdkK3cKLzCTp0DZAu2GiOHdhQ1xIs4jWHvudcdSH/aFjSZ+oxgjtGsPEKoNHPGfLFIbVillZdm/2iIvuOZ0RI7LNoobMw92KeNGsWleymbVuANTzduc0A1I5iySGM2
 vm59VABG
 chy3AaUpVhdHMU9ZuP57ueETz2wSLIe3/AbMM1orjPVPdCwNdUeSU6/vke8THvJhLe7RKY+sgMKUJyxLGJxtNiFePF8Tqqz36SRe4u2fSMuhMRIzAYA1jEGif5VlyvTIN4o7bEErCUHbFpriyPatXU7xVFWvNNMZPPEyMM2zSgObL24/6jRIn/qlQL943YZ6o3cOn5jFGP2fALOi2e7zPjwWDWViALThLKSTw8HFtJAqVjhPW9A4B+HlaUWtYJKZrMT2cQtyi+9ubd002u/UYxv8eS5NHu+UPzQkaU/cBTBXQ2iRd61p4bAbEwDcchph195sG9Qcwn+Aqp1lkzahSYoHbUYn40aAQLJimdLEzWdJ7E6Td2B+hc2wyM/kBWE8MPKswRYhN9+iK5vmOH5Mk/psHWHaxnE78zHxo8KeqEhK2zwPeC2tSxEmkF5o+X/v9fvPq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
> All of these symbols are file-scoped (static) in page_owner.c, so the
> page_owner_ prefix is pure noise.  Rename them to shorter, still-clear
> names:
>
>   page_owner_stack_op      -> stack_op
>   page_owner_stack_open    -> stack_open
>   page_owner_stack_fops    -> stack_fops
>   page_owner_pages_threshold -> pages_threshold
>   page_owner_threshold_get -> threshold_get
>   page_owner_threshold_set -> threshold_set
>   page_owner_threshold_fops -> threshold_fops
>
> No functional change.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
>  mm/page_owner.c | 35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
>

The rename makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


