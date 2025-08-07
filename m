Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A023AC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432146B0088; Thu,  7 Aug 2025 08:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2596B0093; Thu,  7 Aug 2025 08:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA6D6B00A0; Thu,  7 Aug 2025 08:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDF96B0088
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:21:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1A371A022E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:21:46 +0000 (UTC)
X-FDA: 83749872612.30.831BB1D
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 172854000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:21:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ldw2R7Bb;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754569304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzueePh+YPKcdxUnwFSn0EWd6nbr2mgK9GGe/+9jDwg=;
	b=o2w2Lx4c17o0evsWmUVOHiH8aylapVJQlBwFDAz26fWpQNswzOrOcThdCoYCRW4UzX2Xa2
	w7N1QJxQuV91z4p3dkZkBslJTFNC/t/A0znT2gvumhgaEayou4fbQmTWhN+040/plpOzub
	arA1zDHN2M/3gOEYdxDi85pKnxxX2iE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754569304; a=rsa-sha256;
	cv=pass;
	b=J2T4eLIth1kQBM1FBOUvvUvw2Jlj1DrspLvY96XAHMFZlIiBTfM4A26wMideRXXUC0Kakp
	mo6EJUOt2guuxSE5zjNdZNbxXKjB1te40uY8DLymiP03rrM5bWsoo101wVCDJqx9Dufihk
	EQoYs5SI+iG4i5MZ1QiAd6eNeN+SqdY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ldw2R7Bb;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyDs/TdUbrofTb7kV9fj40Wl7iPhfoW4GF6zP2XaRnb+cKXO4aCSdFkZwZfgoDIIRxWVxtb6d7lZJFKJcRDmRvQXcDWQIldTSOC5UIPPXiIBMNO/Iq9AuPQcZWL7nAaz8vi8P0Er5fkbduFL4jh3p9UMQUxQkTnttGowhqSVhrNgd9xiiMp3MTiixGhiwwlHd/L8FC4xGmFtgMwL7ZEEUc5lFeO4wurp0FcF/HqWWQsKYwdom7J827dFYOr9DvLxOkCjPk9VWYcMLHOpsrDVs/KBvL7jElcsWw2NHdxUw8Tw+jQQKj8cMma3TYFQ8rvuSqx52f9O/Oi+nsQfoeR6GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzueePh+YPKcdxUnwFSn0EWd6nbr2mgK9GGe/+9jDwg=;
 b=Pzv9bIv0Q2/R5QyeKOqBfxlZYnqINU0DbNzQW99VblrR2sYJrzP3vjPN88k/aC1hRdENHVhA2VRTW04bbGlzITwVUXE6dxipDkPCySefmxqm/de9mE306lBa21+89dV0utDG8VsVq/4vzAjUiO7mrwFH6nZfHwxZ0F/KKQRvByobtlhHwxRSr1cYvU4iCFM1Jh0e7FK8ENDLZKCY1fs+23uzNuFxPO//iyagDyYSMvdIEbRxQ7ttHap8bA2JjjjgQkbhBM7dENO1EvBsLfngoYx1U+sAMs3wovkE9NNL9l9vKRgUyCYzzC8fMumqRnQ8Hz4hKmeplMh9x5ZR4oFqQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzueePh+YPKcdxUnwFSn0EWd6nbr2mgK9GGe/+9jDwg=;
 b=ldw2R7Bb130JXGO8wW8myu06hmE8kEvTTLNefA8APrIV7OhcEYjicuOJctEXJBKLX8wjr/V0nkT3aY/tmHn7DIR0YgYZXbM9aw0NcOENMPmNX+q4pkXBn1ZQbGyMvkAJXT2ggJOpknq1olivs/YAYr/dpBfwJL624LpIjZS0NdmnMqoz7pO3SbhltfugmhB5tAQU4OIbV3ksWRJ7DrOzOckvZllWrfcwS7QV0cpbMy3QJbhnxlDIbiyVDdWZOlRz4b3kUGx8hkUdjP+Rw4yLuqJlxpS3XbO7Gf23dXn3+KQDuUTeUJxO4muRs9I8MP5MK0jhv8dCe06oEkDYfgkwUg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8416.namprd12.prod.outlook.com (2603:10b6:8:ff::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.18; Thu, 7 Aug 2025 12:21:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 12:21:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: wang lian <lianux.mm@gmail.com>, akpm@linux-foundation.org,
 broonie@kernel.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 sj@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 brauner@kernel.org, gkwang@linx-info.com, jannh@google.com,
 Liam.Howlett@oracle.com, ludovico.zy.wu@gmail.com, p1ucky0923@gmail.com,
 richard.weiyang@gmail.com, ryncsn@gmail.com, shuah@kernel.org,
 vbabka@suse.cz, zijing.zhang@proton.me
Subject: Re: [PATCH 1/2] selftests/mm: reuse FORCE_READ to replace "asm
 volatile("" : "+r" (XXX));"
Date: Thu, 07 Aug 2025 08:21:38 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <4A8C53B9-694C-4313-BB65-A406AABD6B8B@nvidia.com>
In-Reply-To: <20250807131611.430a097a@pumpkin>
References: <20250717131857.59909-1-lianux.mm@gmail.com>
 <20250717131857.59909-2-lianux.mm@gmail.com>
 <22169C82-5701-4ABB-811F-075D22CE6FCD@nvidia.com>
 <20250807131611.430a097a@pumpkin>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0501.namprd03.prod.outlook.com
 (2603:10b6:408:130::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8416:EE_
X-MS-Office365-Filtering-Correlation-Id: 74316815-dc2b-43df-701c-08ddd5acf70e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FAU7qGPJYrcqVRWCSuX1s/C6JapUph9JYSxR2NZ/tKxxEK6kk5nv4E36yFoy?=
 =?us-ascii?Q?CfIHsT+DnGDeukpZ1ko2PCdURq88v8KRDkx6N1N5R+EXz2jf0XnhNBaVgKuU?=
 =?us-ascii?Q?eEHcWjC1hoTjQ5/HZPf+pF+Q8XE6WhFmq5Cb5kWg9VKjJbfWYf5/ek6KNObJ?=
 =?us-ascii?Q?jF8AgFpNQXnCnyaTa22he6ziLuFzkIXWO713em4q3BZ38a6wHEsmdPgHbnc+?=
 =?us-ascii?Q?OXX/qBGY2iR9gmqGzkk+XbM6vmINCAPzPtdHDDN70e44OVZvD0MUYJBlXYz5?=
 =?us-ascii?Q?SHG0ouHFgLumKhQn6DvsdM4Kh4Y8KsbYSKbyaClXvTJp4hXmvKJQoUrFU8J8?=
 =?us-ascii?Q?HrSsKO8G7xsOuy6/iWH9LaVJ/osSjcpFYPfEykPJYA7V37/fWTenBB5TVdbm?=
 =?us-ascii?Q?bEp3AeJDqYiXh5BSRJxSJroWhknFcUkWWtmzeNm+2T66dV6jjdRM0qrQjyoa?=
 =?us-ascii?Q?+LQ5pJDduzcT7xwcIYdhFt7WTR+XPDQi2VV+r080WwQbmSlfBCUQMsDmAok3?=
 =?us-ascii?Q?/yo/9CAdbTWPq2HyV+lUGSo9VmWqAxFUcKVuGdWd/VGzwLiF/dDCavGuastl?=
 =?us-ascii?Q?AUgHMbri8qQpqW/e6tcZlcq2gi8B/Xm409iKCxrP3BcRFUB37wbMHevGmp3r?=
 =?us-ascii?Q?u2ZGX7HmXHvZ68AURWPHgHAsj2ux8bjwhxUhJURmo4Hj94wrZGVtgNhjnORS?=
 =?us-ascii?Q?bOANCQ/UUTcLRD+ldPvHI9T3cN4sF7Cto/YGCUEXw3c/uBpYgQhiNrygiIRM?=
 =?us-ascii?Q?IY4vKaCFqbIO32AO8TsJZdU6t6dBpOJrrtvvSXJPTEC+msuEO/pVObH3S7hg?=
 =?us-ascii?Q?fOTwSioWdRHkyN65RDrVisdKiY7LzTbqVbuyGAVPPfLRAEN8TvuwrUeKw1E4?=
 =?us-ascii?Q?7P0zGkPMbGQ9sso+KqxSM36XmCPawoP30gxNAV6R3k7Sa/Z1u9cJAOdRZDKQ?=
 =?us-ascii?Q?NPz7TP/AKZgtHsQxfWkbbzqdsNZ7MAnvMGI83izXbxKVTTnlB334AvIXqrms?=
 =?us-ascii?Q?FRm371pboOxHm+xvl7A0dMQM5SIiArf4Trr5IzWiIGKAbl/ON7XY9LzTYmbr?=
 =?us-ascii?Q?ctN9QfRipDqqQJWwUL1EmEfJp3PQUv0e3ZKPWBHsoEy5j+N06zF8dqHXwRe+?=
 =?us-ascii?Q?RAh35viBTvaIm+wfZlnvCS2amsAxupmVQ5zEiDMAcy68sIB7a1RdXdK3HsM3?=
 =?us-ascii?Q?HM67l14yZ1G7EilEIlkNlHCgwsjFlkDAxdSJgja/SwHPhfBtbFHDZ1QqZOOw?=
 =?us-ascii?Q?9S148fcZ52e/kAoMWPwNP7P3haxIhIaMOaQcSiCAnkMBvDx/zQsADUQywA/1?=
 =?us-ascii?Q?E/JgH8kbEks/WoCfLSIQN/QWM532FcVt1F6IYc+Tbql5V5EdUJGP4FVjM8F7?=
 =?us-ascii?Q?mtZhHZJoWDWJiTmINKIRVOSjHUelgljKb+SvO5LVMUm/G/CXOA/ol6gcOl92?=
 =?us-ascii?Q?DYGyht90m98=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dbtQ83VJWN9XJEbssQN54ofFAjguAV7BihmGDGYsfHYUbwe/Cx05adatLYrv?=
 =?us-ascii?Q?cM0HmwRM5wbGZSlK2hKGKwARTzCB6iIiKKcIqhPWLCop9ps+tpuFmphDXUAs?=
 =?us-ascii?Q?uPSSvMvs5gR3sdazAyO77jAWZD32eZW9Zsr2AjUhOGussu5EtbEZVSyqQ8HI?=
 =?us-ascii?Q?3yZ5dpnn+gLSwE30uNAfrT/ieZC7QCxMK+JAHZEFCmjDSSZA0bprQlAqLMNq?=
 =?us-ascii?Q?Iu5IhLoCayBChgJlde0880izvVGcA0Jekaa9ajHMpmNia+uLRy1bij/eqVsW?=
 =?us-ascii?Q?0t+IKdSOdWV0ZJanw5w7iNgQ15ea6xo9cU48zenFCxBQ6eFpyEudEWq4XRSi?=
 =?us-ascii?Q?O9Hv81FYg/WTBqzoUV2K6vbt+upSTvd3btziCLsh9idK1jdyaOlv0k6xbtbc?=
 =?us-ascii?Q?lQsjXashCTgBloSN+QFqz5A0kluJ+aSWb5hskk1msgqph+hqRlTo6qwz/3VT?=
 =?us-ascii?Q?upexey+vTFrDlbGzqSIilJ95jzP7tXGRM6FKDsumnSzg07fubzvW0nn1mNTz?=
 =?us-ascii?Q?TtAUZ1SGCGmlR9yK6OI9r3qXSEyemUKVnlUZ8cM7Q6DdRQOI41ysvZ7F5U6d?=
 =?us-ascii?Q?UmRrsFns+6iB1eBHI8D2m2JAa8AaB9V3VKHYRi++h6u9xoitPTacpkMrTPPe?=
 =?us-ascii?Q?CDMyrjjUbgreOI3L/Q6/v997OBF1RZZe3fmPGOxparPXSk3IiWU9Foy4s5yl?=
 =?us-ascii?Q?sQmOA2qAqUJtez/NO2dzEv2FOoUNlENjpnQe2HywhpFgNqDWixmhd3vc3An1?=
 =?us-ascii?Q?eArXKgQonjOTvPCAIc9nhjojUivEZD+g/xSPI+iTGH7dHdm4Gaxw74iTn9lj?=
 =?us-ascii?Q?HVKUCAb5T6uwcLReyBbFAQMxCJ0JeWhFImsfTIc1eob3kD3lxDTfGKQDDkdj?=
 =?us-ascii?Q?MJacqVcFf2074/nQo0xvsSuquXCadH0Wy/SqsX+f+vpcuQ8UaOS3zrRRD/nd?=
 =?us-ascii?Q?AsV0k18sqx/lZOOtBoLxO/E0mYvImQgeRgjoxcV134UHhVTDQrX5PdIbe84J?=
 =?us-ascii?Q?uE+T5nI+g7eLy8XCT9ewVY2AzB1DTsbqx0pNMi4oGiZMN21dxmjKzd6EbSzP?=
 =?us-ascii?Q?bxPhU7l0wjRDf21JWk8LCR9Q1qETV+xu/auTkxbKbLE4RHOEMxXAKMGcYtWV?=
 =?us-ascii?Q?8mTcUkl5+s1FtaFNOB0+QEBoXKS1L6cPkUmYaeOsIc2znebpVj65l/E2LgX3?=
 =?us-ascii?Q?MjMKVNpPrg2uxaVpyqzcuPdiZz1ETJWgKkKzekOqGEhJkKh0MifjTHcEzucc?=
 =?us-ascii?Q?orN+XsBEPxPmci3ffto2zmy7QGZyJPRNcUd7Z6WUMDwCJx9MajHFJwDpMcio?=
 =?us-ascii?Q?HEy4m9X9Md0EjIIEImxzdjmsZ9knC/oOzvLGnYzLZy76Coxrnid//5v1jvtT?=
 =?us-ascii?Q?bA68o1N63493mo7BXu+OL0lvfQNUjww7eihYkG6eN0oWIFHb7aIdYvHzVnc5?=
 =?us-ascii?Q?jJn/K0QncYZ2v+TvzZGmcoEe7KBC8XJ1+dgGcm5mtXDXRaJ2v9rFqt17Rk0g?=
 =?us-ascii?Q?B5xD/FdJjB93ThM93hsFK52/7yBsSEsv0FR7efVRKCSxF2JbJJ1cFGR0g58+?=
 =?us-ascii?Q?tJGfbE5kdnpw2CV5bCF6TraOREmbTQPupMr0KU5X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74316815-dc2b-43df-701c-08ddd5acf70e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 12:21:41.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ApqHJ7WwkzEae6uOksDkw3aM83qVd+BGJuJVq/LU/4VgZ3OUwBl0ZsaAfPZ8Cpv+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8416
X-Rspamd-Queue-Id: 172854000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ni931p7a4ipma84cc98qmbgcp3acs341
X-HE-Tag: 1754569303-128109
X-HE-Meta: U2FsdGVkX19HYWDCYRQH7hUi1TvJC7SJOm/E29hP5C6xPUOsBrKwDswq42TioSXP/brhA7zb9HvHRuwy6uuw/i052EJp3Ly+61CftQ/NTTRf19P3wRr7wU68DgRxyWT3/0QRAGM0uoskBZmBzYyaHLaxuOtT007EFHaCnG1RLYkcprZp86skxd7pXnOAmnWuNY6zt73h5O8KWjuX36yY+juHF/2S8vRaE0gJDSXPJNwF1g3TWE4SiJjRc4j8Krykj4/qqM+i/4hAADJV0c2hHU2BfATxE8BCb73jnAukK77GgcQsCsXgoB6V2lUQqkgF5xDq5fT7B9kUb3Lx8am9zJx/H2CfQUI6n3fjBh6Qv2pu3O9ozhpcf+utCMXu+jxMAqBMq4SQCjdOuXudJjfqo+ok/I4Y1fgLxIgtjXEHJzyk/xLMUXFFZNusEUjumT1WYxaIEfmaI2yxgve+Irr8B2k7etGoSFY9wBO79wIWWYLIchoJLqiDWHJiwc1qzOS30hHO/t7FlNhNbCq9ciR41rJNI1Sgj6GvrDY8o+oRaQ4cmNwKJkKIjRswGlqP2sOfX1ButpPq7jMsNNy1+yPNbXR8Mnx03xq69bdrSPSB45LVy3j0gS8bb3zC966qi3KYo/C63hpa0xsfHB+5IIDk0qVqu4+Zgny0aZZ1BzlLfDTv9iXBXgEx9M0Hy4e+dgzROiy7b+P8BO0Q8p6qhO/SnCizCb2SW8bqsN11ZoCFEbRSWhCn+47hQy+jJ6ogrSxS9ZIClFIAEmfsPmF9IMRPUtjINcvkbWxNwf7RO+Jz3e6aHpaOLnrkmpac4ao4toIpwbQ5sOZ+oUkp/m9ZyGR6/oCASrN0emXmsi1aIbB/Pt+3jRhPFoqETYWeQyPWzYlWvsfoTaG3NXB3URHvr3FJ/ijCZJwMF/BVtPpO/rPjHv46XtQbBj/8mXo+GUqU7Ql+3U4ZfQx5//yAKThZ4u6
 97I4Fjov
 pvvKpfv3YK+IDLuxiDdE3f2PiriXM5MlYFzA6h/sBo9CbVdDkosg/DoKWByi6krw5tsNlXPI4ezgjf5U/0E+wSIcECJ/4UTwJM50XsHoeqQvtLvIalOl2EVBgYxZAcavX4P+tCUzChmldcpO44CpShUTJmgpHzjZa44aAG6yJbrjjyqFRzLo1SVOycJij/Cy63lvcuV60lP1ydn/TMK3ZDDjpbQpi6OxBsAu+dl7dTKXVA0sJsx0hOFdeJNawZkZVsoAj9Iqm8pbvdx9WTlQFk7jzXukY3zKqXzgEnSsqkg6aY/IUnE3I+sq94ysdLqElRWTu9svIsYVUcdg6jMV9v8BRRIoQAEiJtxnZcu7ny/4MeIpTPEp4rF7GGjc/M58tm0kB+f6FsF0fxwzZRt84ja31eqARCUFrlqZE3/JPN0e9MJ/8wQcL0yjvy8R3TyVvESxMaLRAg2bYW+nwyy3RdkjpaAkMJwUI8UAyOYrJGkr4n6MatYF3f40xu6pceGZaxXmZg/iOnbENnyru/+9+suGHEcLyli8i/YE7T/hs5E4iHzrir0g1QFPiAIVrU7bXc4Xf/NrdHkn7e3xVJUFimOfHz7L3eqFr6tYRzqefajO5Vcie8L1t/PHOKV6WOESJVVcDmGe58h5NtIO3oq01Al29KPQQHMU20u7YlYUixTRrHVqFQEY6pXBezYfl73Cb9WdQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Aug 2025, at 8:16, David Laight wrote:

> On Tue, 05 Aug 2025 10:26:17 -0400
> Zi Yan <ziy@nvidia.com> wrote:
>
>> On 17 Jul 2025, at 9:18, wang lian wrote:
>>
>>> Several mm selftests use the `asm volatile("" : "+r" (variable));`
>>> construct to force a read of a variable, preventing the compiler from=

>>> optimizing away the memory access. This idiom is cryptic and duplicat=
ed
>>> across multiple test files.
>>>
>>> Following a suggestion from David[1], this patch refactors this
>>> common pattern into a FORCE_READ() macro
>>>
>>> [1] https://lore.kernel.org/lkml/4a3e0759-caa1-4cfa-bc3f-402593f1eee3=
@redhat.com/
>>>
>>> Signed-off-by: wang lian <lianux.mm@gmail.com>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> ---
>>>  tools/testing/selftests/mm/cow.c              | 30 +++++++++--------=
--
>>>  tools/testing/selftests/mm/guard-regions.c    |  7 -----
>>>  tools/testing/selftests/mm/hugetlb-madvise.c  |  5 +---
>>>  tools/testing/selftests/mm/migration.c        | 13 ++++----
>>>  tools/testing/selftests/mm/pagemap_ioctl.c    |  4 +--
>>>  .../selftests/mm/split_huge_page_test.c       |  4 +--
>>>  tools/testing/selftests/mm/vm_util.h          |  7 +++++
>>>  7 files changed, 31 insertions(+), 39 deletions(-)
>>>
>>
>> <snip>
>>
>>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tool=
s/testing/selftests/mm/split_huge_page_test.c
>>> index f0d9c035641d..05de1fc0005b 100644
>>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>> @@ -399,7 +399,6 @@ int create_pagecache_thp_and_fd(const char *testf=
ile, size_t fd_size, int *fd,
>>>  		char **addr)
>>>  {
>>>  	size_t i;
>>> -	int dummy =3D 0;
>>>  	unsigned char buf[1024];
>>>
>>>  	srand(time(NULL));
>>> @@ -441,8 +440,7 @@ int create_pagecache_thp_and_fd(const char *testf=
ile, size_t fd_size, int *fd,
>>>  	madvise(*addr, fd_size, MADV_HUGEPAGE);
>>>
>>>  	for (size_t i =3D 0; i < fd_size; i++)
>>> -		dummy +=3D *(*addr + i);
>>> -	asm volatile("" : "+r" (dummy));
>>> +		FORCE_READ((*addr + i));
>>
>> I encountered a segfault when running the test on x86_64.
>> i is 4194297 and fd_size is 4194304.
>> It seems that FORCE_READ() is reading (*addr + i) in 8 byte size
>> and i is only 7 bytes away from the end of the memory address.
>> This led to segfault.
>>
>> (*(volatile char*)(*addr + i)); works fine.
>>
>> Both gcc-12 and gcc-14 have the issue.
>
> The definition of FORCE_READ in 6.16 is:
> #define FORCE_READ(x) (*(volatile typeof(x) *)x)
> this is clearly bogus.
> 'x' is a pointer - follow it through.
> Possibly:
> #define FORCE_READ(x) (*(volatile typeof(*(x)) *)(x))
> is better,
> But why not use READ_ONCE(*addr[i]) ?

Yeah, that is my fix to this:
https://lore.kernel.org/linux-mm/20250805175140.241656-1-ziy@nvidia.com/


>
>>
>>>
>>>  	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) =
{
>>>  		ksft_print_msg("No large pagecache folio generated, please provide=
 a filesystem supporting large folio\n");
>>> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/sel=
ftests/mm/vm_util.h
>>> index 2b154c287591..c20298ae98ea  100644
>>> --- a/tools/testing/selftests/mm/vm_util.h
>>> +++ b/tools/testing/selftests/mm/vm_util.h
>>> @@ -18,6 +18,13 @@
>>>  #define PM_SWAP                       BIT_ULL(62)
>>>  #define PM_PRESENT                    BIT_ULL(63)
>>>
>>> +/*
>>> + * Ignore the checkpatch warning, we must read from x but don't want=
 to do
>>> + * anything with it in order to trigger a read page fault. We theref=
ore must use
>>> + * volatile to stop the compiler from optimising this away.
>>> + */
>>> +#define FORCE_READ(x) (*(volatile typeof(x) *)x)
>>> +
>>
>> Also, look at FORCE_READ again, it converts x to a pointer to x and
>> deferences x as a point. It does not seem right to me.
>>
>> Best Regards,
>> Yan, Zi
>>


--
Best Regards,
Yan, Zi

