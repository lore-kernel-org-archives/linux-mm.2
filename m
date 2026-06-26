Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8393C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE396B013C; Fri, 26 Jun 2026 14:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EFC6B0140; Fri, 26 Jun 2026 14:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97BC6B013C; Fri, 26 Jun 2026 14:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 988E16B013C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:53:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01692C1DE4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:53:24 +0000 (UTC)
X-FDA: 84922961970.04.1D85BEA
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id 22D2214000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:53:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gfvcd0RT;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782500002;
	b=OLHjzd4O9YU/jeGIHiZZFTadY36bxrRXRtrQghWLfD3RQV5KT8OqbwEf4SLsphwRPk3pPR
	x3sX7UDZkS1PN6nWIh2sjBDtQ06Vd0mfD2lHCvd8yLqKnwY4ftD/9uxtNNOBDzfUIK8hVU
	yU+tB4+gnbeJvq/fMhwJwp5cBRXzEx0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782500002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OR16jAD7AtkuQBw3nNFTbgcqC9jlrgoLeo9tvRW3prg=;
	b=DgW3i9ym4E8VaQSIRxFOT0U3GmwhxzPiC2MouqE0rQaz+zX3LUucgM+lzqVK2yqIXkZtLl
	Jisq6crGWbdEnfGo0Fo4CvAYV3WpNBPXSZCJflFm1wQiChezizf9jVi2oscJlQC16IAZ4T
	8pBhSXZNR/HziUYK6FVnwQYPHrNroos=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gfvcd0RT;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dypA0T5egAAdV05/HuagMMASTYQUcny86d11kflnfYc9AjdQZDdldeTmIGg+3YjypBx68matQEN8YsfR+YYLFHGlygpOupJ3CEX4pT+2LfDVlpQn+ATcG0Gp/NUsH1yplvDMCbGdhWPXz/1GfVZeTQ6YP0mjRHAVq0Iu6592hZV6ioUzhp8R3e+wCVey9ryH62r7rNLYNUji8EXX20tk8LKJgbcvWBBG+JUKQAu9OE9UHbdIsPb0GUT1rISTLwtqovuOjnW0aArXxw9DbOZGrCQdDLTDVP5DbVGRBib57+r1hrrJZ6u7eIi6GAYpecD2M7SprbZKvxSADWn0jHiZGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OR16jAD7AtkuQBw3nNFTbgcqC9jlrgoLeo9tvRW3prg=;
 b=P7+p1pinTc39bTWDuhCl0hLCB0TL3MC1+tZXUP3FSbsP9SE/OVlN2u+oS039Nv95XWj1p4s4WybApvc8rszKDZNOGnCg9UO0pHnxQO76XXFIf3G1OCD58UkC/lBSJ5H6v6NglVaiqLIJMHEM4btLjZEQUzg+AABsPJLSJVSiv+6UL6R3y8azTx9x93skWMNR/Q2XWnEDgsIZUPhD84drNeBzMJS1NPT6e9GpNbMJRZ42xNHYzOH1PK1Yc37kd/tt+PXfEh88ARv6i2jrfHWaABt3knSPjyGvKfLvYbumnD5CewueExqTfei6YuGCI/hWZ7DkBOsu5STOLBgzAobl+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OR16jAD7AtkuQBw3nNFTbgcqC9jlrgoLeo9tvRW3prg=;
 b=gfvcd0RT3e6SYUozNzl7d9ki77oBhJ3vQ5x0raqXkK5OgNGqC2RPWyX69tVY+M9n7uDO9lSFRhO/7XrW8demhT6fvOFFhIaEO/Lcg2ODStb8MgYsliJkvKr4mtr22hxubw9l35h71hM316VfykgwPvbiwCiCByNDyx2tnd8y5GnhP6EbAWQIrAKQiYYQg6qCbjhbPEJJQOgqrPN0vQEGwfDDnndt57yJLdBdjRvM20PFTuFq5XC6BMBl/YYTXda16Vl6c5KhLN2NvS/JOm5ypqaKzgE5LzNPyUp6/YcqrkPyVpOtP1cgvoDpMQDRfkU1l5StTNtGPKz57DPHtuqSfg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9109.namprd12.prod.outlook.com (2603:10b6:408:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Fri, 26 Jun
 2026 18:53:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 18:53:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:53:13 -0400
Message-Id: <DJJ7IGFLUDTX.1HEVOMGZ5BCE0@nvidia.com>
Subject: Re: [PATCH v2 4/6] mm/page_owner: add missing newline to
 count_threshold format string
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-5-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-5-ye.liu@linux.dev>
X-ClientProxiedBy: BN9P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9109:EE_
X-MS-Office365-Filtering-Correlation-Id: 3df57d80-e2b9-4040-5aaa-08ded3b42d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|3023799007|18002099003|56012099006|4143699003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	tgAMukykVnKjuOY4HAq5oV1QlRAGZcCY0QzOqaPl2BKnR6x3A+/a5/tZsPmz78YPFq2EnqGTFNsvCk61S8cumGhzQjvXzvsAC7H7dw9l7sa7qJdPK6nq4DuZAWUYHdl+lHfZjSWBnqP2a+x8pBXPjM6Z7+w9TNpIQgSC9XtrEW0Tyh44WD3rwCDD9IiVZ5zd3AIcQZY/rT8lCcCCO/0bdlnMBRxzgPdJOACvzigf5VqI0nv2ilOdzTrxVzOPDsmtSljTi04q5QNV3jKbwvIUB3eExb6+vKK8n27I6VtoDU8piSdFupHqJMtqSE2HjWNu64sYRpPOX9bAiTV266A1zrc+XyP2zvIRcGOCdSh4cc6pzpFBRhFpGf1OfaT73kwP/IDsclOppDp2FOzN0cgaOUnw/Ut64XIv+mXe+bqvHpie6K0wZfan8DSIowCrO1tLNquqokjnr7bGW0pFSsG7na1vGR29UBlLw56DigatNsR1mUgsqrrSDtWfg+nsEcjHdh8ngSQi2Hlm7rda8rbvjUGDY24koJpO195AzozTXIBzevGrO8qMqnwYi5e8CnF8tsq9Jxc82MAdRqp3mlnSbJDG3vS66BOq4L+w6tv3YXXMgOgYV78Ng5hikH2L+Wyuyqywt/veTeOATXaGBonkrXGmHVfyo+g+JrvmsM534H0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(3023799007)(18002099003)(56012099006)(4143699003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFlFcmg1cEk0QWhzV1RCbUhZMHdveVNCcVpGYVg1ODE2MUVqd2dxa3FuWUdT?=
 =?utf-8?B?NnRZZlFSNzRxaUdHb2wxNzQ2WXVuZnhnQTBSSlg1TGh6bHZYSHRnYkVOdExi?=
 =?utf-8?B?bGZtbXkraFMvWDB1MlZKaUZuOThNb283bkFSZEo2d0x0WnBadEd5Vk9VY3Vr?=
 =?utf-8?B?dVFMWnhoYytsdnhjdk5UV1pxbzVxYUNRT0REaVlCTHRua2JtMFFPQjRLVlJM?=
 =?utf-8?B?MG5FY0E2ZmovZ1hqb3R0NjVLdHBaUHZpQVl1bmZlNTV3dHVmb1V5dEdpczd5?=
 =?utf-8?B?a2h3clhRVVA0a21DVjlvaFdiK0pIZWh2T0Jnb00rQWNGQWNPbVUxSit6U1Rw?=
 =?utf-8?B?R0pmRVFhUkI4NGsrMjRGRkxFbVVMRjBTWHIwbS9FZUVnczUvNUtNL05MclY4?=
 =?utf-8?B?UlRwelRmQm9PNmN2NVpiQnI5bndOaTI2aWhBM2pUYk5tdGx0dUVOY3JLY3ph?=
 =?utf-8?B?cHZZYUlpaXhWQTN5VExnUDVpeVVhN2pycUdUUlVBUERzbWEzbXZKd1k3cThT?=
 =?utf-8?B?L0JLSVZzRVhZYVc5OWhKbURwdnBVc0RQVlk1TEhaeGhHeXBDVVAxczdnOWZY?=
 =?utf-8?B?L1dGMTg3S3hyeVM5dHlObFQrYjFOeW1rcU9yOHZ1R1JKbjlOaEIxeGZucUJi?=
 =?utf-8?B?Q2tFTk52N21Ca2hmNFFrd29RQndkeDVPY3V3ck9Jby82TGVoazZsZHJSNG1P?=
 =?utf-8?B?MVRESHBTSyszaXRoQXVEa0ZHM0tBY1drbSsxWUZSNFBQOXJQUUtCMlBoWVJT?=
 =?utf-8?B?bnZ3SjRZV3I1NmlYaXRDTmt6cGhxSmYrWkp2a3VpL0poUVhqbzNNZEFzaHZl?=
 =?utf-8?B?U0hQTUhQSlM5Y01BeDQ1ejdhaHQ4WEVsMGlsSE1uM2ZsQ2pvbS9JdXdwS1N4?=
 =?utf-8?B?MkNaMzJKQmpieExYUktZT3BvUDFtdmUwakdSUWx1Qnl5V3h5WDJDaDRycXln?=
 =?utf-8?B?OWtTTE42WTJJQ0RpOXJhZmIvNXF0NG13bCtadDNWWXZWelVTRWtnU2dKbThr?=
 =?utf-8?B?Y2dpL0tLN3ZudlRKdjNHQzBvdnJESmlqbGgyZHlaQzlHZEIxclcwVG5iZVph?=
 =?utf-8?B?cDJOUEJWRjQ5N3BhLzFUU2k5UmVQSjV3ODdDeVdhRlNkVlVuLzV0WHdObGRV?=
 =?utf-8?B?MDc5cXFkYXRZK1pLQUpaeTAxdHRoaGZON2NwZU85M0pKV0tPekNmc0pjUytu?=
 =?utf-8?B?Q1JLYTBoWlpvVHJXTUhhenE0RXFmS0xyanRwdzdRVHRnVEtDVXd0RXNsZjl3?=
 =?utf-8?B?OERua0JEai9IOGpsK0lkd0tEblNJSWlqRkNWNjlMeHJpRzJwOGN1VmE4OVpK?=
 =?utf-8?B?RHdCVUhGZERkZWw3Nm03RDg4b2k5QkJHSUJGYlVuUzFlc0tEMThBKzBlZkQv?=
 =?utf-8?B?YVBsS1dQV3Vnd1hhNHM1T1JqUnVQU3MxZVNacm44NUJYaEVsR0c4bFNPbnhY?=
 =?utf-8?B?b1pvWDZ1cUxsdDk0Nk5qMVk0K2h2UUVtaFdzQnBUWGxEandJWmFzZmExTG1H?=
 =?utf-8?B?aHlrd1ZzVlVXRWQyOXp0bEVIclVZUHk2aXZISlFhODMzcWI4cWZFeUt2eFcr?=
 =?utf-8?B?T3piKytCcXVaTDhoc01xMWFmdjVZZzNOdUpOcXE1VDVXTlFxQWYvRUNsVU9U?=
 =?utf-8?B?ZXlwUmJ4dWIzNTB2MlcrM1BIMjNXRXFkTkJwbUQ5SlBQM1E4bHJGRVplUXlM?=
 =?utf-8?B?cGZaSHVVRFZVOWRCYWE0ekpiYWM1d200ZmNDajVDd0RGcjU1UGpoVGVmbytM?=
 =?utf-8?B?ME9LcVk5U3NiWHBUR2pSbk83eG1DWUNNd1h1QTFETjZTdGRKbjZjb2xUcHpL?=
 =?utf-8?B?Zlg2NzI4SmJOOG9iR21nNFc1d2JCaTRWNk5NckJCaEhxRlpzRktoWE5ZNS9E?=
 =?utf-8?B?T29kVUVOZGhualZ5TFZXamcwczhTcnpucTlrQ3NVYmYxRC8wK09LZ3NidStY?=
 =?utf-8?B?ay9QaFZoVGlPeU9LeU9JUjZJM3h4VmFHcVVzVmZTbzUvMHFnQnM1NjdQZTZK?=
 =?utf-8?B?VVE4QUZwUnBvQnppNTM3TjloVnJWRDhpVTRyS0JkalJqcERaODFXaEpnQkRp?=
 =?utf-8?B?M2tMdTVaMCtWcmV3aTN3L3AxMG9uNFBRblJQZzR2L0wwSHN3bnZDNENzLzhP?=
 =?utf-8?B?U1l3eG1oT2J5TUVJTnlyYUp1ZHJuVDdVVFlMZ3VtVXVkVnNPQ1pCNXV0ZjUy?=
 =?utf-8?B?ZXFQdlJTaCtjY1l6amdPekNqTkNhWUFCeDE4Y2U2QjBSVW9MbjFOTnM5Zk51?=
 =?utf-8?B?UzZnMmxCMVhFNDNXOXU5NjNVMHhucXY5YWJ2RDYwRVRTTXZvelltZnNGTlRL?=
 =?utf-8?Q?iKV6IMvnvxxOo7pjNs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df57d80-e2b9-4040-5aaa-08ded3b42d78
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 18:53:14.4798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a4Q07Njokj69gik2+nHk0ogqxzpZ49cjdvGmnZNPxVcnG9AzGlMyChFeCzvju10z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9109
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22D2214000A
X-Rspam-User: 
X-Stat-Signature: ouhkigyyx3cejj7bb3uii5kzdzfbfbw7
X-HE-Tag: 1782500001-33307
X-HE-Meta: U2FsdGVkX19QRxYqOzVrPK/gfvRVJGYFY5lltszrQolEOmUbvq3RPwdbsvPASJf+zynIcZpCaeqLMVMGOXdD0vfutPexaTaPEen5FfUemR2S/6VSo3B1lyZWZ+uUZCq4iUhYR7lkdAWS3Zal7QZNMKOqqFOzobsnO+tRZ2h34MhrLmlUhE0PHI2+VvR/jNNV2xAtvRYwuuuOaT9mTN1uSHkfIJGghW+c3dKXbGFsY6D4ktXjiGUAFCm+/BeAoitRGByiFr/9HovCLPmXQgc6+R/IAKY1fzhgbRfG/q0ytLMxo8VItxhflLdJl+UH52yDGTsOovlCe/CEFQ+SBiOP+wOssUeDlpt7Ug7U40Dmdj5DLmhKQ5ozsSg2IRqb7SpEPZIa8qJ6mCFW9Lev2jS2d2SnHBEu/jqXKGE45V+HmfvZT46GLIRtDwoYqtIXxhWOau/a9p0BlkgkWXzOVaHYAB22Kn6hluhivQJ/ZZD6mm/s+8XKzULsXPVVADid6RCWsOw3eACE2ZpFhrq+qKGUh1s4eXLoCiEbC0K1pWD9QuJL+Woe+8tatdeifSVdeJrvX/HUXkgYiI/ySi89onDJljBPXe9oZVgKopkgpNdIPlN6gGx6Xj9SSrm77QhB9d0nihq3rmFK5FzZLivxzoa/vJ1+FVzNm2S8Gt30RKxmttCCzMbVK6dEMXTMuAWHRKzp6YRgF1tpEVcXVhrcSy60jdyb15q+D42W6q9alFZ8Gq+N5lQO71R31eVgdZPxuJi6yJ42nI2cut1Iu1+tfjde1FuIVyQopVEyTQmll54Ss/xcncsYRmmqtN8Se0SmI0NXDI/ZG+Icl5nTJRBEa5OSbRKcK88RKPQjwoX//O+/SIwEtT6GXQxIf7jHZWC53o/AOZO8L1eTRpJqF4ai5jHpTOMVx8y0SwOy5dLF6yTfmxtHeb76DaUpwCDnWwqPijEjWmNozlRtEiaW1gr3hfC
 LrphVkmJ
 UNS4R1sYAS1BPTwLlMhQwX2ylN5+Fi4ks+WNHHq8DA/efiVRoDfQNacehkfkfG5jtcd2zj5HBmtuEXnXSxrmU+y/ploNGQM52JOcjtoL9VuE9vclmi6XFSs52MAFbvqo2sMfucKxyV/tXvVBteRgfojxfzwVGXgtPyf3uqQmsMBV0QINwUcF4C9XjHiwMyYbY31/pExRp5pv8NarTAZu4Fi4jGT6dafLkEKrmrsMlkfDpEDOiq9UCKK6nOjHYTBqRNlrqAKaaUAdjRnk4SvJKt9ztEQHdvmhiciRDZnqGpF9r64vkLn0SN2A17zeVcrWrlAeIOJQMUECNnlYKhGTihbPm/oZwzrnauFt/VWKXktey0kuxfigzJmfI1plxtdbABHQnhaiMLeJ0ZkcO3AVakv6WPiqK0ljb2AdqDMrpbCx1DEd/P9mRFBwWrAKREFtavAee
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
> The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops
> is missing a trailing \n.  simple_attr_read() uses scnprintf() with the
> format string, which does not append a newline, so reading
> /sys/kernel/debug/page_owner_stacks/count_threshold produces output
> without a terminating newline.  Add the missing \n to match the
> standard debugfs attribute convention.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
>  mm/page_owner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


