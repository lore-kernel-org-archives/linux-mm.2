Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AC8C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 19:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325396B018D; Tue, 18 Aug 2026 15:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D61B6B018E; Tue, 18 Aug 2026 15:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D0A6B018F; Tue, 18 Aug 2026 15:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E17006B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:15:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FAF480274
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:15:05 +0000 (UTC)
X-FDA: 85115342970.04.3195DDE
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	by imf31.hostedemail.com (Postfix) with ESMTP id 93A3120002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:15:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rXCjs7P5;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787080502;
	b=5fB0m8cao8NN6wLcjnJLmTQJQ7ur1Oox3SI22n3RRxnq9zT8ZkS7a0LNog8JBLCKzeo3Xf
	LIjY2Joghc0mi0TEn5bQWhLkCeKZXqrX+v2QdWuVtI/yO8a0nsiBEuwyJE1E2npk1M7Ywo
	xFs3LMh5jzfx/+N7kF0USEEwQh9NvrI=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rXCjs7P5;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787080502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh5tiVvjskivvoKu3e6b/d6yClk66PabZ27tmU3MahY=;
	b=XMmtCA/aGZzKpU2a3kDEU1wHZ6O2PzonA25vKEpmVDpqablRKR3fT9NxhdSq0v/l+0rQV/
	8ij8LV/ELb/GKrxg7UMEt4lyhAVOw6VRSD5a/AHjTfoHjlV6H+N496wo9pSay+ZHMoDjzN
	69yQGYeAM+LnvEsS4oo0iCt1fEzU3js=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DK9ITtp3NOXqa9Q9tNZ8hZKTKImrOzdzFxxYYhD/C5a+RE+nZ4frhZQORVoYEqCHowSkmni+BnFsoG+QR1hBbwPFGdIKzXVNKgmk1Knk0Fnp52/zjMSzqyvtuuz+TjEPQRm5uEELeA4VRmOo35vYHPeLP8/QBWbQBNzj8zXH3W6HkLlKNtMV8BESkUzsNJ94x28A0pmy2qIwomwK5RtRjH8iIpLWc0NiMkcV7XKnbGf12Hm+PytShZTCelWsObIuCW79eDZA1DgmKhhLcT7r+xWTe10BKn+UeyducjR1ARQYei/Mj+IFRt8Ot+1oftVJw5fEJ00S0hOf7Tbix/r84w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dh5tiVvjskivvoKu3e6b/d6yClk66PabZ27tmU3MahY=;
 b=pKRjGvIKFMlP24z5yI8djB42gs71qnjAIbkOWFnvuVb+kFo7fLefrWAdqLngN42ecjQABWxQTFuLIGaUOwN+RB0aFhoM46Uej5pryWU0PJipNkk9n4IGwQZR7LiYgdH7pVdqFhFKeJM9fB7EGrjU6VK2k2S3NbA2qog7A5w7w+svu73dGfoTE7QdIMwP+3sPRioR89F2VCXJhQvIk77n8KvkMNEPPFcHG/vK+qwn1l8paf/TWpkcdFYgNlcjlnii+DcWLtMR+S1f0vNxKE4/5kJUAxNAHnijM+VbHugSJqzoTibkdO1ZXe4FfOvOkFDllvIOLHD3YxGxCl4K1oUNbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dh5tiVvjskivvoKu3e6b/d6yClk66PabZ27tmU3MahY=;
 b=rXCjs7P5teXv0mTpvdGtTtPrG1dkt8E7EHU3dWuYs9G0qixJqZfQqH8KOeWwI10qUfgzTeZSv7HFfmeIoHlbhhnkZK/JRNgWmfNROgRB+6qMlfpYxVLdSaFAC0iImFpLsp+Ll8HNyv7pQztRik0wEMMFZl/KZwECcXVaHbhjBm93AIPx2ZKq8C82hzuJEuvXFZ+dUd6G9BWt11Sb/gUO8Mam9jV5v6S1iv7YcdR7NfFpRTeRFiJJB+C2iWLJOnTKtYJ7bEDLWkwLUUQNcCJNda2Mhf406p147cEl0AyiUzSQJKCaVbcya6YLssuRIuuNRDQOG02sPGZGL4rq4UnpDw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7812.namprd12.prod.outlook.com (2603:10b6:806:329::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 19:14:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 19:14:56 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 15:14:55 -0400
Message-Id: <DKSB5XV53PQN.2G3U9Z7HJFLNO@nvidia.com>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
 <wangkefeng.wang@huawei.com>
To: "Qi Xi" <xiqi2@huawei.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/page_isolation: fix UBSAN shift-out-of-bounds
 warning
X-Mailer: aerc 0.21.0
References: <20260818112855.3831692-1-xiqi2@huawei.com>
In-Reply-To: <20260818112855.3831692-1-xiqi2@huawei.com>
X-ClientProxiedBy: CH0PR03CA0200.namprd03.prod.outlook.com
 (2603:10b6:610:e4::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: 303fa49d-6e4a-4038-a9d1-08defd5cfd85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	t4PNdVNwWLG2RP6mKyLBmgN8W5BeiLNpZJVekGBvO7tD0XmTHjtmB1kUfuUr6nuW7n7jbDS1roSq7g82uZk43GOUmoShNP8VX/vVte7ws9KttEjCekUCJivaEMKjmN2UUN5utVAnIdxXUSC+SkNUaM0EwfV1Y1m8LU66nNkhd8Xt4lo9pG1OiaA9AW5O5ambGSgAfvoanSSVaT+gR63Tu75GwjX8qvvsWB2HWmOibxGgC9W/mOBKZUociyIpRqogSYePok5geveLvpZKVAmM+CuGifPTDeQo3x12/IZgS7YdQTPnn6fAxpkN6VHGrshRSdvpmDdvsHWvDmoQE/a67x6sipNFWLv+vO+4i28mDHJxaAbbicrCbPuguP9wj+ks7QV4h/9s4rnBHoQqSPnmENqTuafU7lvxJqhwmqfYrkaovvTTcvX5WptrKaIEfPLGyuLl6CFL5jvkk40wJ75lG5X/g1gEWLexFMmfw2Y8wTBeHG80lD8NyQEfCiYcvBZoc1BmsKVu/+U0QM/iJlPhwcUYL4AaafbA/0wNfpbef9ikiQLsQvAI7DWMmK7lPwjLy7i6ZlnorI+q9DO11txO4yCJHb2R5dfAow8uFYzOMEpX4PDjmLQa7s4TDik7LzUUAaEOG1XNafdhxXi45cD8z5weBbEDFE25NLphsndU96M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDlLTWJDTXBrOURKSmZjSGpLcEF2RlM2TWdWOWZzOW1GcUJ5TTVOT0ZjQlRh?=
 =?utf-8?B?U1pmZ09tdFBBQURZT2w1T3NRUGxtaTJqZXRIM3p1QURvaGdSaVdzaExUVnJm?=
 =?utf-8?B?RzZtUTU2OWl3UFcwQWlIOG81SktMbTNURllsS3lHdmV4czFVVjB1ZHE2cjc3?=
 =?utf-8?B?K0hFd0F5eDZvUGxuK0lpbDRlNlJmUjVORjZZaEd5WW56N3dON0owYk15aGF5?=
 =?utf-8?B?Y2V2VGxIdlpUVGRUbEcwdmZraFh4OXNlZGhTTnhDcW9aa0pRMkp5aFdvOXQy?=
 =?utf-8?B?Y2xvRnhHVURFck5xQWtINUZqRlkxb2dQN2NjWjVTVXR2V1JHQkVQUXR3Ymlz?=
 =?utf-8?B?QzQ4RENoTGc5TGxxa2FKYUp1b2FUZ2FFU1BCcE5jRnBaQXRZVGdaTjhlamRK?=
 =?utf-8?B?T0EvRm9ZRkVQWVAvTVdQVjFZZWxQbFdpdFp5MHRNMkVrWUQ5aUtiNVlEY0Zp?=
 =?utf-8?B?YVdsb0hjenhFdnNIVnl5bHpmOHJYbXJKcW0rRkNkKys5Rm1JbEIzd3ZUbDBn?=
 =?utf-8?B?TGg4OVJCdlQ5UXBjT21pR3YvNGZJUHJmVWU5MWZlc1FUTEJYZEg4QnNTOWpQ?=
 =?utf-8?B?THVPZU5ETlJWMzFTUE4xcEZzb2dsZXAwSmJaeDJXcnVUcFQxLyt6RUVnS1ky?=
 =?utf-8?B?djd4Z0NzcFl1T095MkxwRkhSM1ZiTTBLZU9kT0VYWE1EaHNBTjF1OWtJK1dn?=
 =?utf-8?B?Tks3VzkzRlZhZU1qM3NWUFVjQmNSQ3UzUStlNHlqTkdQd0J0UmYwb09CMDZE?=
 =?utf-8?B?SXIrNSsyT1dwWHdNM2ZoUEl6eFFQMjQvZ1FnWG5UNW1TZXE4MDkzY2FRSVd3?=
 =?utf-8?B?dVY0QktLMUtzWXBTVXBQU21SdkxqbGNTYytPQWIwOTVaNGh1d2ZwY1QwOEFx?=
 =?utf-8?B?b2FsekJWL09pUldMM1d2RnJOTDN6V1YxUEJ0enVsWWdWTnRKV00xbGpmaldW?=
 =?utf-8?B?aXJWZW1lNnNTbXJOcXFRYlhoVFlWbFpVZVNWRDJSOHdsVVk0RGU4NFlBWnZ5?=
 =?utf-8?B?TjdqTU9lNG1Fc0pLUitHb2p3Mm03TFVWNVJ6eWNTZlZoRFJKTlZDNkV3ZVhi?=
 =?utf-8?B?VHdjc0poajBxNEx1UHBsalhmV1RyTVgvSm5GVVZad3MzbHBHN2pBc0psMUdZ?=
 =?utf-8?B?NVlEZ0xoSzVBcjRlMlNWM1B4OElPd3lMaU9vOWVnRWVVK3B0VytiNlhKaTRY?=
 =?utf-8?B?dDlTQldXdTNrVUE0eEpTbzMvU1NuWEVDZ2diQjViWGZsbEJ3a3lqM2JCUTFX?=
 =?utf-8?B?bmRXNFNvSzR1dUpIeVovUzlqS0tmdkZXcFhmcEZoMnF0MUhDRm95aEo3NU9z?=
 =?utf-8?B?WjJZVlIvNFR5THpQRE9XbUtoVkRDVzBha3Nva2NTbDU3RFBKM25lRHNia3hr?=
 =?utf-8?B?K0Z0WU5TOXdmSXN2SDJKaEtOeno1MWdKSG5CVmxmZHd6ZHhvN3paY09HdG9k?=
 =?utf-8?B?Rm5iMFowRFJGZmpzbERGbzJrcW4wL2hqbW9VeW9iU0lGVVB3Z3VKRG56b3NU?=
 =?utf-8?B?YVV5ME1jVGtaQ0VONm5KQm8vQUpRTUNvYkh0YlZTRk1qaURPVHYzQkoraEZD?=
 =?utf-8?B?S3kvYjBRUit4WmZDcGxhcEdZMks0Nmh1NzA2cmJGdmVka2p3UktHb2FDTTRV?=
 =?utf-8?B?S0JmYjQ2VmNqc2F0d09rMFFjMUJ3S1d0RmpTREJvVzIvNGFtcG12Uy8zcElK?=
 =?utf-8?B?emdYT2ZLVGJWTE5wUWc2bVM1aFNvR3lBd3Z0K0NDeS9NMXp3UGJYNWNRU0hn?=
 =?utf-8?B?ZGx5UEc4djYwSEVtQjB3VVhyMHpKbkRaNVJsN1duMmh2WE5Pa3lUYlhKRjVk?=
 =?utf-8?B?WXFtVEN6V09nK0VjUzBRQ3BibnlXYW95bmNiWUMxWnp6bnlUeU4wSWpPOElx?=
 =?utf-8?B?TFpDcWp5VnpZdEhta0lobk91VmtObVlqa1dzNEdySDkweWxBbFRjcGgzbFZT?=
 =?utf-8?B?cHdydEduYTVaMGNiOVhVM1gwNEFKdGh0dFFONmI5REVFM3FPY2pBRVhmNFBo?=
 =?utf-8?B?UHZzcUQxampiL1NhMWFOVTE1WDBVdEx2ZVFoWjBQaTBDQ3B1ZDg1YWZPTTNY?=
 =?utf-8?B?aFBiVmxBVlBsZy94UE5GaWJxNzV0MDVsOVNKSXF6ZXF5ZFVXaWwvcTdyTlJ6?=
 =?utf-8?B?Ry8wT1J0QmhpemRFVUgvLzNVNElwSC85ZE1HTTBzdUJqbXc4WlpwTXN4dXVN?=
 =?utf-8?B?ZEZpTm4rYkY5YmNFZTFQYXRabTBzU21FdS9FbC9EK3BNTGMzdzRCalpnL3hQ?=
 =?utf-8?B?Q2NxczBrNTVGNzRrMGpzVFFtbURUNXpvTkllOWRpUEVIczZLQjZLTGdoVUM2?=
 =?utf-8?Q?7IZGGZF8m/uqBJuk4V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 303fa49d-6e4a-4038-a9d1-08defd5cfd85
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 19:14:56.6453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vRIhHn2dXW7CTaE7395ZVUZqGHC+s5rIDs2TepewY31kSFD2VX9Sf08aX0vtkSfR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7812
X-Rspamd-Queue-Id: 93A3120002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: di43smc1e9m7sjq1fqwktmkii9kbkr5m
X-HE-Tag: 1787080502-438311
X-HE-Meta: U2FsdGVkX19UyW5cR545e3kZ7EUxWOdH0QdFcclFcwdxb4ZNQ9vl2ZjL/+fS2IbMF0PnKbvXp2HPzXhj6jFnhXFx/MOWRzKgLrdPiUWjUFv2BJKBs/MGIavLO0Cbric8XoQCf3C4Np3x4FGfoFCI39EN8rnAtQr71oSnK1LJL3U8X1/vHmmUjqP3+36W5IppWb4wPc/YrtvwoTgpQg388zSVYhmURPPuFSfCQUo9BSI5KWduy+BArFsnZMdt8MXfE3L8LMHL5rt2edxllbXhc78pYWuRKq0HMqPgSsvSBoVX4lUSye6FkS7npna1poiK0j/48mx4UwKwlNs2VGYHUt1RYlUmZAiVB7RZXG7I2MhotB3oQzCbmnrv43pyuiyuh2siw/SbMB6qk8NQiThhM6EkW16RNGRuBMYPnXnSxpwEjZjc946DKLtyOX+89uJq1s2D62mcFFd1/9PyvYKEGAhXFrbdcpBS+SVqslJqGHfd+puRjUNlUu/JIcW2gVenVZNEPtWbU5ej66H84Vzh26P6BsB64C9xjoZ2gBdOwcgalS8wpgSQGbHHkM+7g9HJFclTAK1+Gh8CEGCOd+5v2qpCveVSv1+koTVBtD+TFH+4r/rrdQcrGtlox/a6NIfqRB9foMX9Z2bzzfTe7CgBuaGC8ivRIK8rdsDUNgd5B3NfKudlKI0SKwxzXzkTFhjqwbt5x0mjEc0dQbPxoKY3OoKJfnanTFP6wGT+kKbFIiIYe6CgmUgrLzaXkHKsJc+fxTbsjRkfpU/4zupB/OdZ9BMpuUMPSwBCoLkLs3e3X+R10mriWIz3758dk1H2aMvZslNFJmbak+jkHNHOa4N+aShpDDiZEekjZi6qzBwuhFuXIeKPxBM1/3mKa4znlySZup0bnRqcIuh9Uh2O3sKvaSUSwMOsuBAN9Ei57nGDi8tdUA68jzrhrL0vCkv4faAGvHceGKf1y/WSBm5/MXq
 7sdt1NDl
 hQ6WKl8PLe07t1msZ0K+AmkYQFzpiYSe0S4YY8/I6IMN0uYYRsXR/vQwHrsmUPfe0rH+bl7IUnINVdOFazkloMsA4kN6ic/LyJpHkG3fVQOPdVn++FejJZXTng7eCGbJCn1bp8yeGW8Iu7eRK7kwwy/H0VO5CnPr5OVMaXDTl4Q5JgRCXTQsvsNTCnuBM+2VxLHaHA///v83bbx8fgo2Vtj3NIlj30WQGYK9phWPYKukWMWqNLq0vdr+mjhufi6VSHJA0Y0pZI0ahn7wpshvYNPHYtWfwFygv14IjcWvHxODJ4B92ZQBUIJitX1aV6cXiFNDUNAL37aWSvZCjFQIl0ddounHua3aGLYWfxtOZNE3vF6zfKB5s5xmcRjYQ68aE1jLokP56Qjx6ncEs3XbA2ojeKzvwZcccrVY4AnKJG23ggrc4c1LKRDADfZQcOmrxCvef0stORZ9W2NbYsOg+YDWMC96oNpLP1qWIpOZ7Ch1OMeU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 18, 2026 at 7:28 AM EDT, Qi Xi wrote:
> A contig-range allocation racing with buddy allocation on the adjacent
> pageblock can trigger:
>
>  UBSAN: shift-out-of-bounds in mm/page_isolation.c:393:15
>  shift exponent -749042176 is negative
>  Call trace:
>   isolate_single_pageblock
>   start_isolate_page_range
>   alloc_contig_frozen_range_noprof
>   alloc_contig_range_noprof
>
> isolate_single_pageblock() first calls set_migratetype_isolate() with
> zone->lock held, which marks the pageblock MIGRATE_ISOLATE and moves any
> free page straddling the boundary out of the way.  Once the lock is
> dropped, it scans the MAX_ORDER_NR_PAGES-aligned window [start_pfn,
> boundary_pfn) locklessly, only to skip the free pages already handled
> above and to detect in-use pages straddling the boundary.  Since this
> scan only reads page state to decide how far to skip and returns -EBUSY
> on a straddling in-use page, it does not take the lock.
>
> The window also covers the adjacent pageblock, whose free pages stay on
> the normal movable/CMA freelist and can be allocated concurrently.  So
> after the scan observes PageBuddy(page), another CPU can allocate the
> page, leaving a stale value in page->private that makes "1 << order" shif=
t
> out of range.
>
> Use buddy_order_unsafe() to read the order exactly once (READ_ONCE), and
> guard the shift with an order <=3D MAX_PAGE_ORDER check so it is never
> performed with a bogus value.
>
> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granu=
larity")
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> ---
>  mm/page_isolation.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>

The fix makes sense to me.
Please Cc stable for this. Thanks.

Sashiko has two more concerns:

1. order can still be bogus even if it is within MAX_PAGE_ORDER.
    a. it can trigger VM_WARN_ON_ONCE();
    b. it can skip arbitrary pages and miss an in-use compound page.

For 1a, we can remove VM_WARN_ON_ONCE() and just fail
isolate_single_pageblock() if PageBuddy crosses the boundary, since
pageblock_isolate_and_move_free_pages() handles it.

For 1b, after we makes the change in 1a, PageBuddy skip cannot land us
beyond the boundary, so the concern is gone.


2. In PageCompound() branch, a bogus nr_pages can also cause the
shift-out-of-bounds.

It will need a different fix.


Hi Qi,

Do you mind fixing 1a along with this patch?

For this patch alone,

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


