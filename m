Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54B5C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 01:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8BBB6B0005; Tue, 14 Jul 2026 21:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14E26B0088; Tue, 14 Jul 2026 21:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90C26B008C; Tue, 14 Jul 2026 21:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91E146B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:15:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 175EC120583
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:15:24 +0000 (UTC)
X-FDA: 84989242968.03.EBB3070
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010021.outbound.protection.outlook.com [52.101.56.21])
	by imf06.hostedemail.com (Postfix) with ESMTP id A1C30180002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:15:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=M3mxe0RY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784078120;
	b=k0yhcgy4Z1DoR/lIR2WZKTCwPEBAaydd5MQ5YyMB8KBK26u7z5IFVni7bR7xLVvoUgSBb8
	b+0lpz5yraqCL7XIGpA7f9kD8xVSIX4sCPKGa1d5FSNNkKHInKizHmxAQ9W0iHHZD7WRkp
	T2ZNMNr4a01831UrIl0en9ycSbNS7Vg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=M3mxe0RY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784078120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d58cLEwT5S8YdO6oKhlDJOhN0OeN/q52WGaF4PDwQ5Y=;
	b=1HZpj5zqCH702+6J4fFEi4lzz7LZYYNogUPK26baA1Poo0nHAPHLNMbVoNq3GStnHIE23R
	TdzJmpzoiNIWcQW6yp1reWUEXHC1f6yCziIGuUMVtE0npoDf0UgYKgMda7gRxsTMJ38uhH
	fHJICrvosWL9ejvgpurWqOE4BdXAino=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WvWJFBW4urquaW7jPErIEhQRTjv/+Ct13pvzU70lB3wavm7wX/md673C0Vzh0y0/HRP/hks+XOaRf9qevaIwGL6hIlA2NQle0sb6eqeSRuoe4Y3G5X2IB5lcPZ2WkmJemtc+dK/HpPdcTE3eeVyYkeEqdGmGiiVaQTtzmbdSGIviJjWov0c9J2V19oD5r+5rv8huX9cBZIjT8O4uQsyJA2g/RXTUv1ghRiFEi7WgJR/UAze/dmxHfqyfrvdAkQN0UAzq4uBWEcRkyLJ5qrM1coA4afBUorRnvdgWxzfH9+ph6MSRDdBtsF5SGvW8JZ7FEMTgH6bWLpfUzB6gH/aNqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d58cLEwT5S8YdO6oKhlDJOhN0OeN/q52WGaF4PDwQ5Y=;
 b=iGx6pherJeTZCk6okgrgWtHITSSTDWREiwWqHge+thS6O6+lCPdNOpmB+DZp72Zx8Otp6QaCFFQf0AmgnUcyU4mpduszpQhHmJxnEUlmxeUatEzN/hYSkaf3L+TkpWMwKnDKYI0ZLMXW6Poe4MqKG5e7/jTo9qSR+jab/YS07wRC1RYHPs+C59i1VJ1h5swIjWho8juQVB6EYlLSl6nPCv/V4AjfzMIAPpLd2ncoVHuDsIOHi1+/vdN2Tb076qvyB0Aw3Rbt5ECRNW0PZ8kqF3VGYC1/n4PmwkDsJoZ2jBPpjAovqM/xY6gPdjbrI0a7CZtgw1WVNYksDpgXfxOVFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d58cLEwT5S8YdO6oKhlDJOhN0OeN/q52WGaF4PDwQ5Y=;
 b=M3mxe0RY7pO9T/MCZaV91HgG9FBkKQtJ0usB/M+FP3VpbQLN2XjmQZB20R+SVSPT0Mz6lWgJ5IJh1Xm/2ZbLj7GZodSP6Vse6hROkNGUKHanL+rI37ctXe/QquQWPmcjo3eHkPae+zAok9h4qH4W55872jiBNIXYlGPT8sYB5WOocYsxdLBkAor31LELPND2XKhac88il0U1KeO2/ZE/uNF0ozRZS3beA1AG+1F/rfZIsDB8fiqHeTOQu6zaa0igbghJliO8j8+emvMQqiQQc2ISDtINgrUw81ttATGNY8P1xsfacJZSZXTRGjCirpycghhBXPLKyiDqxUQdVS5mUw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB5751.namprd12.prod.outlook.com (2603:10b6:408:17d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 01:15:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 01:15:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 21:15:16 -0400
Message-Id: <DJYQWS1Q489H.2PE0HYPEX9OQ4@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/4] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <cgroups@vger.kernel.org>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Waiman Long" <longman@redhat.com>, "Ridong
 Chen" <ridong.chen@linux.dev>, "Tejun Heo" <tj@kernel.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
X-Mailer: aerc 0.21.0
References: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
 <20260714-spin-trylock-followup-v2-1-3c20ed032b14@google.com>
In-Reply-To: <20260714-spin-trylock-followup-v2-1-3c20ed032b14@google.com>
X-ClientProxiedBy: MN2PR22CA0016.namprd22.prod.outlook.com
 (2603:10b6:208:238::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: f85260d5-8291-42ab-fd2c-08dee20e87fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|18002099003|22082099003|56012099006|11063799006|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	CF0DFdNGRBaWn82p4M9ixWygYtSIZL6sVWD9dLjsy4ZXwJD9016GF30i4U4av0HYxLphsaCSEl/hlqQ6sHnZWGZklriGD6qYUgKlp2ttxjvjyIc/OerA5H7znZlP9XsGK/Rqi7mLvEyv35+1v51sbvTyZ7Cjrvh6Vp2K2bNjptRq1aiVr2YjVcqiA4EULvPeq5ZsxrGerZb4CSB656toVEzbEcEiSydzFiFeh2E1wpuI2qAee222fOf/nO8xUZCfuwwvnDg84NrQMLa+XWANjJDCv9JYMQypNRUhC4QMOKjSRQ33XRtnfRActXINAEm9hFtEg8+wjxg3YrEZJFl8QNzvDbeJRhQCj92Q3tQU95rDHjBHBZHDydqdVVCOxyolBT9RuYGb++RqnorEKUth7ZIBj8/lZOE9ICFEZoswmOUIecu36SD3+9NMTQyrYc7Ezv3p7vrDhdLYhfYwEXcKswFSHwQwNWqIyA9auxoMVY6v4LFvFCXASUwQdWH0DizqrKY99CYjIF53Yce8MwSor6meDf6aVm38Htjd0V8KnL2Y+hMYG4sWKdOrsSBacWbZg8I6KISzQ3ZO67zG0W81oznJEZyy64BCPZjERUUeqnLg6YzHeZgwVHKwQFrM6U4/XuxUcVbtxwc5bw8jOgGA3RnWwq1MO2m/kCCvP9ofVvBpooI1MXgo2iBAGaTjithKHOmkSQcImF+QReMc1rupnQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU0xUm91ZFFxQis5MkxQR1ZaQ1oxWE9kQjJla01iR0hNQ2VEa0RnVEtOVS9s?=
 =?utf-8?B?TkZjaFQyZTBLclg3c0ZMQmFkcTUwZExvbXY2TlhHOXJJQlhWVHBrT21VRUlW?=
 =?utf-8?B?Q3htTjMxcjdBemIrQ3hkMDFRVlJibUwyUUpJV0c1d2dHVmRNTklpWHhMSHRk?=
 =?utf-8?B?bUJSdi9vQ3pHOFdoUHY3L3ZSeW82YVlkQ21mMGxlMVRGdnByclRqSDl0YVha?=
 =?utf-8?B?OFZ3U1p6cW1CemRmSE4zcXdiNm1ORnYrK2lscVRLVi9yR2NXVlJKd0puaUhO?=
 =?utf-8?B?RGhMNkxqZXMwK1U5bWtzZndwREFxUkl5VXBtdW1JaTNUN25JSUlzZ0FVelN4?=
 =?utf-8?B?di9YVjFocVRRdGtyRWRrajl0Snh4VUtUamY0VG5Gd0dQalgwRHVUdFJWeGlT?=
 =?utf-8?B?T1Y5Mmd2blp5T2toZUN4a3NKcTUzR0YzM1E4U3JmQ0dlMmp2VlpwdVRqcUUy?=
 =?utf-8?B?dExCT2V0SjUrbXlMRTZLZ0hVWWNaQWJ4eG45SFRPTWRURWdOY25XbWZPSWhO?=
 =?utf-8?B?cG9MRnlleU1EQ2FOemlvTXlDdFNRYTNaeFB4SkNxS1prbGlnMHpkTmlKNnJz?=
 =?utf-8?B?L2Y0WWlpWWh2ejZEZFZ4cGNXZVJLZXNUS1B5TlBQMTkrcDJhb1MwQ2liVm4v?=
 =?utf-8?B?NGIzZmg3SEpMazRnSjAwTnk3U1pCRFFoTU5wRFJKeDA5bG9kS1VBSHFCaUFu?=
 =?utf-8?B?MnR2YjN3ZUpFNGNjeWRFNGowQkZaYm1OdmZzcTdsOGsvcXE5UEsyc21mVkp1?=
 =?utf-8?B?WVFHdXhpQ0FkZ05HZVUxY1l0WDV1bGorM0c3cGlUNzZzcmltN0sycU1FaGhI?=
 =?utf-8?B?K0dkS0lOZkNQU1JzbWtCT3lZZEtHdW9xUTJkc1NVYWdYcDJxN3BBMG9wYVZT?=
 =?utf-8?B?NTBUSUVmajdIemMrQ1BZRDk2cVMvNXlpd3o5WkFJdGdJYkh5Tk5VcjZFakR0?=
 =?utf-8?B?QzNVclpSbUNYbkJaWTJUVlZ4U1NGWElSM2xNeng5dnRGenYxSHJjc2xIcjBX?=
 =?utf-8?B?OW1palNpVHhGbE1YVU9IS0EwTVNudDNYVmZEM2xvbWw0ekUzVXJ5NjNYbXhn?=
 =?utf-8?B?dlJIN29weXl1MVRObGx2R2t3OTBoU2E3Rm5ZVG1PazJPNGdYMThVZmNnMzFz?=
 =?utf-8?B?ZkF3TU9oeHZGS0c0cHBvcXlUcjdiTDNGWXcyVFVTbGswRFNLbjgrMWlsTTM3?=
 =?utf-8?B?YkNVRmExSkorWStNUkVTWFBSdGNMZWN0ek1HNG9aWGpKYy80NDBIUThhd21o?=
 =?utf-8?B?dW4wQVZVcVVQdVR6WE0vMjdqWWc3Wk5jdHJGRDJTRU9vb3FxWm1MdW5xcnpV?=
 =?utf-8?B?KzdzT1dqNnVmWWxCV3FWanh5TlFzazJQNWxzS3VVeEYxTVlYakpDTnZFU0Vl?=
 =?utf-8?B?VHQ4Tk9DcXY2Y3doMDFSc1NvSDZ1R3ZUbTIyRnBuT0ZQNmNRRHlxei9Yd1VL?=
 =?utf-8?B?TjZUblJpWVZGakZpQWlWNGprUVVxK3V5QTNmQWV4UUZpQXhGM2FqNlIwVXNZ?=
 =?utf-8?B?MTNVZGQ2YXdLVE1BYWthU2tkT2xDRGVxYjYzbWFuQndPZ2NLOEg1VllYT1BN?=
 =?utf-8?B?djRRbW90WVhjNTI5MmRkOUVQVVhDd0FMRG9EekF1cjZiZVRMNjRGTmJWcGN6?=
 =?utf-8?B?RGZRSkNOeGgwUG5tUUNUZWVLKzJ2SXFxZENIeForSmVUYm5uV1FiTW5Jbmtq?=
 =?utf-8?B?SGpkL2NLOGZodi94YUpqVmdyNFlKeXRoeTlFaGpESXNzeFhhdTY3bWlTemJQ?=
 =?utf-8?B?S1JOVzdmZU9ZRC9rL2VGcms4S2RtdGM4YTJpdlZPdEYzUEtWRFNTTTJLSWlD?=
 =?utf-8?B?Wit5ZXpSRERtSUliSjBwbkxqMTdzdmV5NTh1bFdzVUs1YnpuRWxYc0ZNRFZz?=
 =?utf-8?B?ejNHbTkrQzd2Wkw0NndSTXNTRUQreGFnZU9VQjV0cEdEcS9kaVRKY3FFbzBL?=
 =?utf-8?B?VUVLR2lUanV6bUdvNGRKQ0JvMXlMa09CYWYzL2JSWXdJaVV5UHViQzlmOUp5?=
 =?utf-8?B?UE9QN3p3MFR3WFVCZk1BOWdZUXR4WjlidHE2aXBORjJmdDR3OVQ5L01mZllM?=
 =?utf-8?B?K2RKL1lxVFlyQkdnRm82M2IrS20wTmZWY1VLN3NFcFFOaGxDbFduSGUvanFU?=
 =?utf-8?B?ZWhTZ1dYZGRtL0ZDNUtBbXp6YXBaUEkvVEprUEc1dVBhZFdRbUIyT3NoMmZi?=
 =?utf-8?B?aHBhM3RQSzc0cUVPeDdNV0J6R0JhSDRiZ2FhY3FxZ3VocU5HSDVtQWl5elNU?=
 =?utf-8?B?KzhmT0c2M0o2cno5Vi80K2xKdzQ0a1R6bGNDcWZOYm1BWFk3OWlFSWsvcVhn?=
 =?utf-8?Q?5xvH5zb/5Tiz8Mn69Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85260d5-8291-42ab-fd2c-08dee20e87fe
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 01:15:17.3239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bI9VnfmH5CJXfpmOdALNhD19aIBhRiJL6rBknOliMVbl8Fz/Xa5avJOIasf8UXuJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5751
X-Rspamd-Queue-Id: A1C30180002
X-Rspam-User: 
X-Stat-Signature: 1jeqf69ysm6ustgqmhrfwaupgot94ke9
X-Rspamd-Server: rspam03
X-HE-Tag: 1784078120-410429
X-HE-Meta: U2FsdGVkX198tKbgEQLT3SrPvlXThck/pN3/8ClwZfIbIgIkUiTbUsgxBQCuxGf5FLIG7gWeeAvKgHOjyaBBB+dI0yrzJTBvxl/cJrbepHNC63knpQvfBNaQN3I8f8U4Lt/QObZ4OIwtzWz1nP0tB6GG21dvwHcr8MPSxJqWQd1PWdPWzUKfh4NKPy3ansxwpl8w1fa02yp+4eahGuV+OWWeDKKrtJCJwI4hBiHRbncGrN7IKNVr3+xtsE2voW1mNgIviQADBP4X4z27zaEor3g3gqgjXv9P1pAK6FliUUkEa3kD4FGm9YhPfpMa1hVVhvvk5S9zZjsl0ub5uATHym66sA2ChNpecMiz1o3nV/loBOZ+ki4Q8HIsddqxpkxIKWmed6qJrqlT85AwFNTGdpsAcVh2cICrAYtVXgTUT/wYBxFpWJdO8TzzAkYeIj6wEdDSORhTWR70luoE4cdh7jhWJKmAYylDP35jZC+zXA+1wmqLmi3O/vK+OQuFfKkbeNPs1IS0pnhWfu1fa6RcB3P1LYSltL5KYxOFs0mOcOXsR8a2ccpeVZKkqnHIN4nqjvQ1/ThRM2AcwAARiXz3oY/ND2pcuH2hUCSpgolYtsSxcvXQflRRkCS2l9mala5swOLq0VZUN1Ih5Huom5Ro8WAzpm/1bdSiB/jPUepauaPPY4lf7z9REOzc9yRd9MN7FFFKaZNWpPy8MO7ucv3y92Z2aYKnJLsCCcohNrigpiqEhyUZUj//+4yHsfImfdx/rd6rHcUcUCp2Pa+lJ968QCqjzmQle4KMyRSiYfMbxHqnAr7QoKZr4xDDbjVm0eehfqJVd9BkHzGvnN7aGKrxd0xpwjtv9h44DB7ovsmAyUYu435Ux6nIVQy+dyWqdnN4+h76ktLtgIkYyu3DNMysYDyT/uT+MT3daWpOnBhh0vJ7LRO8289BZ/gogQEMpgSswOCqjEQfdk0zm+2Kp4f
 rqpHP0pl
 ju9goz0rcZJB2lzZzdFNPFiohh1VvLlKGCvk5SQol1enQB6Q8CDvEc2KPLVObPUKudb3bCvWJQjUAG95VCR5hJUG/CmwlrG+92lbWYsyo1bByL7tzQOxWoHt4bOnPwBk8DUGZd46V8kwN8e9MTCenBJmoqY8phuptTudfZD672nnh9Ll1AY5Yw9REpXqqpUR4BB8nJzSNFdTnNQJ4Bq9h+cS57mDOeJemrEtsYV5H81xJCoWCF8VDiZv78xYm9eHta9/54HcjqAxsvLrwThTSP0YP5swX9Zb8/ZYcRiulklBk43LJI6CFRXtjHtrbnKNF2uXWnE8kFVtX3zrB705ogFYuQ90hsKKz+QOdGjQ+U8JRTGC8YBCojWAlpNyDtcBQxChnqkl1Z9ZNZsmaYQNHuLfRyRrba1Y0AfkoBO3P+Qu1A56fYHpSPfAlcWhPhS+UUakqoPLoKoMw8CdekIe/fYJOQInagEB6VLWBTBeLi0n+w+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 14, 2026 at 5:31 AM EDT, Brendan Jackman wrote:
> As discussed in the linked patch, the there is some inconsistency between
> "trylock" and "nolock" nomenclature, let's align it. Since "nolock" is
> used in the public API it seems to have more mindshare so do that.
>
> The linked patch did this for the ALLOC_ flag but forgot about FPI_.
>
> Link: https://lore.kernel.org/all/20260703-alloc-trylock-v5-1-c87b714e19d=
3@google.com/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


