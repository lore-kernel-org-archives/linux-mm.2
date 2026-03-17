Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E70CF33834
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24526B0005; Tue, 17 Mar 2026 06:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB996B0088; Tue, 17 Mar 2026 06:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB286B0089; Tue, 17 Mar 2026 06:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB6D76B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:07:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 463B459AAD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:07:02 +0000 (UTC)
X-FDA: 84555126684.18.C57A635
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012010.outbound.protection.outlook.com [40.107.200.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6DB6DC000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:06:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QHkI5h7R;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.10 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773742019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mNPDjCDVYGHV015tKVj+YjwgsGb1gWESp9rrV1BNJk=;
	b=UYuKWWeDrjPwNPDY7vq+8BC9l9yqVG5bDRfj9+moauK8KoObJh/Mau8x+ZZn73n5l6Hbdl
	t3DyQTkikFrNnMTPN0UMx6vg/k9WaImQzJL6ntdtCai9C1oT78fR2BHFl4d/sLfVVb94uP
	K0no2FiZjoMSBJPhgg1Vq9j5iNrjiXE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QHkI5h7R;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.10 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773742019; a=rsa-sha256;
	cv=pass;
	b=7CrRu7KF6P3C9mq1z9QFouY0C1WUGt+3LStDMh4k4QKfVZ/w4iQtoEALFLqkLbXV4YVuJL
	VAYs6WXkmvWWx7jmUnTxcq4pnXHYnsnpg+v4N9RxIj8eQQ3rNq8TZAlnJC4R8OW0/ufBcC
	RBot35jcTIU6+tdVbaMgVIdGOAY3guI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HCH+yvEc3AlEs2Lc13KnE8L2HjyP90494241CqZkZcENYpgSqlNzBIhsn3icinjJ4WUlneSgwpZAhbJozxSA/WIXip9C9YTto5vi7WtGcOspeP8m5iX4MogUucOD2eCe62ezt99+h36SzLae2a15yW/Pxxtf7sp3xnaZqzHEU67s2H46EwxjB7r7WAJQzw48R0mGnfatYd9ykkXAVgAQzSNlEAseBSv1DJS9jI/PqL8toemsR2aabWdw8vHcPn+ikDTc0QZgCPZQHoRLIOLt5OsUR2f3+fADMvMzERoACJatc3vi2dGwauCE+Qxc3zpUZK4BBdjqY8eq7jlgdzbKbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mNPDjCDVYGHV015tKVj+YjwgsGb1gWESp9rrV1BNJk=;
 b=jwH8yghnRBiHiNQWe5tDUGeGbcfDfQkioQZemctTcr2ge0HPP+xJUdRSs/wi7VZ97BFyZR0HVqnG0SM8ge9CUB/zDNoblZNh+8XNXD15qH1kF/h/seDXt3KRvWk7HU5MCmtjf6g1IQ9CkDbjwC9Z7c/oIu3an9CmcO2vzx5KNHrjVWGx4z5dO09GTPw/Utqd2FyAANsvoFg2GL7LozVG8MO0Adb5OIWWy/vJtIsLMLwtQjGllFiEgaCNE67l+Ts2qc/TR3bbIVgWS61iyWwadHksXqcVBK3/5ISXle+eVz24QmYDfBBl4Ru/uAyj8Oo4OlzZFvv8ts/qEyVdqw7ccg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mNPDjCDVYGHV015tKVj+YjwgsGb1gWESp9rrV1BNJk=;
 b=QHkI5h7Rq0HV6SWyJzNgTxs3tKSu+shPASq4XI7WBsO5xyyODYw8P+mAL1Jqh++Dc80+BN7hQvqlQaa3gHzNdl22FYbIVdNUXNDmaNNc5kIaPRsMiISbteA/QJH95HeRiCjd+6FNcVNP3h/1WKlx8hDQoq/JaZU9P2AEwQgIWS/DahZFmQWUter9Gij2zouhP+ysmUa+i08jY++IbESxzbNrZRsvNyTj3rYGKCkXFMN4JBRskAKjUA2L2d66Ku0+yuKMGL1Ux5FErChN1U9dvKx1PQo9Nek0Z9B/Un4f5jBtokYrB1UX2Hs0rmXX9qdFh0Cghvo8EAvq8V/QxVU00g==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Tue, 17 Mar
 2026 10:06:55 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9723.008; Tue, 17 Mar 2026
 10:06:55 +0000
Message-ID: <856095a1-3784-4e70-acfc-888d2a8027ae@nvidia.com>
Date: Tue, 17 Mar 2026 21:06:50 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] Migrate on fault for device pages
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260211081301.2940672-1-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::7) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY8PR12MB8297:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d198ae5-8072-4df2-e9e9-08de840ceadb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	KNLimO+PPOr5LGyVd1oV2/sCqHOgQRt3ZhC1gCjT+hlHaPlu9+/+4vg050w1gb4lb1dBwG4isimI3nb1WfV11qI1C/IbWGroyXqNRSLczKPk5CQpZfSGRXEcu/d3DpToOMuGU00X3MVRWZjr/VXDWHT5S7nJv/bD3IvWxMkKQwngIPMaOQcjtqyCW2F/jlel/DjDR00t0u/DCGUfyzhk40CdocaeZkyz1nkkPcM4rpX4hBGjzoSS1clQxSfNG8lSARSudJBIzbbVADkYiU57sjs++2BHyJBsb/glzUqhxYvpC8b0nkp9StsqzXHR2JPIrPd+4VmV1GMiaOrTqf8Vsfuk/qmYIZzzhDyl6xkiPNWyGsJ2IubKLMjqWg+V/B/TjEndeirp0ElNUOcukhm708h6+Ftm0DtbgnLvJW+yyulXqmIOXshwhgvIPxwdB3CwMjk47UkgbD/+Yni1tgzt36XrKgHFJ6eRngnGg1A3ag8J9GfScRXEIzNeJ4NW1bXdbCToZ8oGM0B1P1K3w1VrvcaCdZ50qn1VgODXq/Z84jOHVXKRGFEFU1ut+S2v6Yz4d2cMU/siDXTJw9dO1aAteU/dauWLZdHRPOFLJcghLJOaPynURW7tMC7lBd5J8NLvVxfCHOc/hWS2UqZhqJjoQHpgYocp5Ws3dtrfHuYtAkTmrJK3zKi7617+gjMkx9lmfGvtri2xjmQ40yU3aV7q93FIN/gVhz3oLqnxEhCwiJc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmNBbEZyNnBBZGVMank0bDFoNmc4Nm1vbTFnRlJjWVI0am8wb0dzRmJaaHdp?=
 =?utf-8?B?YWZVNTBONU1CZC9wUllhQ1JOWFpIMHJJdmxaWUxVTXB3S1I5dHRQcTRlc09i?=
 =?utf-8?B?MVhYWW5na1RFcUQzUG90WVlTTkR0ZldOVklWRU1YTzh4aGVmNy81b2hnMndw?=
 =?utf-8?B?OFlFckhvb2FyK2ZCUy80Z0w5d2NSaHVFQkdLWlEvcC94RmhCVXlJMklLWXcx?=
 =?utf-8?B?UkdWajB2a29NdTljTm5DMEh4UzhZYy81NGhDQXlhZFl6cjBLbzZYWEFHdHBS?=
 =?utf-8?B?U0VmSlQySlN0S2hIWVVvN0JEWGVhWC9sYldycDlUNTBnR0xackZabitxUWQ2?=
 =?utf-8?B?ZDBONC9nOVFxa1lhZzZ3b2Z0bWpHdEZJVEtDaXF2c3pLcnl5UVVJVStsejJD?=
 =?utf-8?B?L3I5RlQ2dGdHT2ZlRC9CdUdyeW8reFArZ1ZkT1dVOTR3dG82RVJxcUF6VFRH?=
 =?utf-8?B?RGo1QnFoZmk5dTRrOVJwOU1EVjRoRTk2d3FoeWtheit6UWtsdHdrZjVZcS9a?=
 =?utf-8?B?dUVFN0Z6YjE0a1BzOER3UFA2TkVsVm0xRFR0dFArdUhHZCt2MUVMZ1g3dWpQ?=
 =?utf-8?B?cTZJUkpMSE9VTWRubnB6VnVYYjVYUGpQcFZBMWxOYzM5a2c4aXRrUHhmU0RC?=
 =?utf-8?B?cVhQT3A0L2piY0JvOHl4TjlVdTZVbGQ2U29nTlgxTk14MmdhY0xjTlE4RmYr?=
 =?utf-8?B?QVl1NW5oOGpUKzJPeFM4YS9OYXNJZVVHcGpGcnp3cFhEeEE2ZXJnUlZ6TkhZ?=
 =?utf-8?B?aHMwRnA5ZzRxbUZaQnZxS2pLdDZhay9hV29QbkFEWTNhdDEwbVd6UmZoWXF5?=
 =?utf-8?B?YXRWNXVaSnZkaUpmaDFpeEIzTHg2YUFBVVFOSzZBb053NnZtVmt5WjlQazFP?=
 =?utf-8?B?UndCeEpCR2kwdFU4L3ZVdlhidVBqYk8zV0VsaGJaTWZVUWIxZmFxK2VvSG9w?=
 =?utf-8?B?c1d0dnpxOUkzd1FQYWJURUlDam5aYzN4eDRDV2VHczJQa1NkcWxZOHV2cTVv?=
 =?utf-8?B?RDBOS3Bia3o4S2ZlTlRiaDdEZ2cybGdXV1JJVWdUaEV4NER6OUhNUGt5R3BN?=
 =?utf-8?B?cERHZnVTSWZIdzhLYXVmb2o2Tlg2NWtsMTlIZXI5bFMxeXRGc2EzbUhqMzgx?=
 =?utf-8?B?RUJNYi9yRzNxTHN6QzcwMzdqYUxOaFFiUXNGcVA4dXIvUE4zS3JnVkFxV21z?=
 =?utf-8?B?REVZUWRGaFQvNWUwblMrT3FQanFWYVhQZ0FHSm9ZMFYvVEFuSGNjQnpidUZo?=
 =?utf-8?B?M2ZheHBTZWhDV0p3SlN1ejVFb05zem5CZVBVWGswMVlra1htUHdOZWRRYWRT?=
 =?utf-8?B?T3p2enFscXFKMHV5SmRnMytyVGd4Q2dtNndGdmNZbysyMjJmOG9nV2NUUFRI?=
 =?utf-8?B?R2pHcjFUWmpUS3JjblZnL0RzYkxXR084ZzU2Rm1lU2tINno1Q2N4d05HcVNX?=
 =?utf-8?B?K3BGQU9yY2p4Tk41ZjB2dVkxTWVqOCthdzY0cGZEQ0RHL2xwaExmQTR0UU5E?=
 =?utf-8?B?VVpuWStCTXNqdFI0RllpZkNZeTBhTnRyQXUyM1Z4dTZQcklZRGRVbTNQL3pF?=
 =?utf-8?B?YzlpWEIzYTZMcnZpTTFvRWdnU1c3S3c2YmhSa1hiQ2UvTmtGT2VrMlZNTUtu?=
 =?utf-8?B?QW1wNi9NR2ZHS2FDNnRWb0pTWUxYWEVIV2tNY29HdkpMMHR4RENhTThIUXNU?=
 =?utf-8?B?YVBaNmZIMXArcHRFa1NWN3poS1FwSldFcThia1Y5SVVKcXU0SlZOK28xMFlD?=
 =?utf-8?B?cml0NVMvb1pOUmUyenBaOWt2VWJLZ2JqWGVQZEdjM1RZOXQrdGgrYXppdXp4?=
 =?utf-8?B?djY0NVg1M1dxRXlRMk5qM0xFNmlEdWVvcW9qaXpXc0ZjVWc4OEZWNktIak5D?=
 =?utf-8?B?aXRmRTgvUmdMd3daSGFEVTRoLzBERllDY0hFWDVjM1lmM0hhWmR0L2ZUeE1T?=
 =?utf-8?B?QjFhL0RndFRoMU9XTUtBYUJpaXhha2dUcUh1Sk8vYUFobnU2dHBuUDZJK1lv?=
 =?utf-8?B?V01jaVB4eGVaMUhYZEZCR1RZbTNlWE85cTJvRGM1aU0yYXJRaEpEZXJsdmhF?=
 =?utf-8?B?VXYyTXpwQTlpcTk2RUd6N2M1RkkvQUJvTGZEOTF4OURrQmJaUlZCVG5Hb1RP?=
 =?utf-8?B?c0xTbFJuRUxiY2ZGSGQzTjMwTXFsTllOVXVvQytTUXNleUVySGFMOWFYdm91?=
 =?utf-8?B?eTNDL01YVHhaU013RFBBa1lZY1BQN1RjbnAzYVpGODhWOVh1dDI5Y0RXY2dO?=
 =?utf-8?B?WXJpS3g4ZUl3Sm9PMyt3RlpUbXJFMldQeTdqUkRyTGp6cHcvUStNYVNuYVNv?=
 =?utf-8?B?WVJBT1hwY2VxVmxoK0FRbkIzc2J5M3NOQzZUMUF1dXcxZVFNaFErZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d198ae5-8072-4df2-e9e9-08de840ceadb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 10:06:55.0083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wv6OvVpIbNIyti8/wQpzZ8qJomEJb24C99DhvDkYzqcPcbEyFSxEzVjFTmiGBOd9yaZHTiwKMrra/DGaemrKaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8297
X-Rspamd-Queue-Id: 6DB6DC000A
X-Rspamd-Server: rspam07
X-Stat-Signature: acrmohwqxgmscqhb9me1bxhud1e37n3s
X-Rspam-User: 
X-HE-Tag: 1773742019-701523
X-HE-Meta: U2FsdGVkX1+Vs2nSivMItSRFfNSkHyaYFmIsHxB+Clk6fSG28dxmytRNHg9OErBT+5GriYGWV1G3bY7ODpPIEBu/uFnnDfIgps5dzkaxjMwJpZJUyeIFecM29NfdQaO6PoaBujKvdDkRe49Lf5ns8jCzhlqI8ZgSTmleLW4gy6dDad4A4aR5toTsuxt7tOvS5t3pOqF9DXwTnljAE9cBa4eesrxlpafYNcQPNM1sesxCB61NrxjMQOdZWaS13xeThX657KUek8itITOCS7/LIficWnObufhoA4V++dLFrsYjY8Dz+otH4e8i1jHi3EPA5HE+PLmNxbiEEe2fPqEwg3s4QQ7UnXxg6iClI199GOmgJH5fzvrinwTnQ3sht5nnLfwljkOgvoCnCPIi3y+JK8R0vP1nO/JMtl6wTsRIsSILySaOAnzXPVwVJXZaiHPKps0CzsL8UMdw3f2v3aRimhCMbnbman/+pONrE82PGC8Au9QcAhEEf/invorWmwsCj84jVrtEUmXHYV+SYVqabjODj1/JE7Baps9tQU65fSINj3ZB+2KaKG0ivNHz+b6Qnfg7oo7bLXd7vYfd4HLFMJz2bK/M98YjKGujykumoHWnuU5TYmN/UxgFCpanTFdF73nYRN5CTQ7YYK6y/rWMRJC2GHYu+tt11Qq0/1qLPBorufk4c47k49sjnk/gGgDb510/I+KqWK+N3QaM3IqEi1w7lKta1SCUbSWloLNYPqg6vSlNcdV0Oort/voxhpifOkYOaKqU3wCCWX0rXeiGZtJyKkaKFsmsLi+BUF6dKi1V/xv3m53GwUxDu5RUBGWEfQhEoKwppQdDrJgqzxSxY2ReXyqBYh0eI3tasCQmHkfxoEB5wP5IyYJ8R02ZvY861/jwwLjLOs9sZnwYqqcK/5rFvOHiV7ad8jCw0M9KXYWkqDRi6Z0d9/pDE7RW0bRVr4vK+VttHxIilNWjRDs
 vIb80DPE
 WSwu9Wclc4DRRfJELobf7X7+wNk8rXYWRieYjI0LsOhp+QrTcZHPG+M2zIxVSv+VMMrv5Kr0Iwzcesfg9oHOGP2smlkp/RyJ19RDZY8HaVQJUOuBsc6VvFgzdA0aiUcYgf+KDBP14MWHQh0ScI0SgsGcCK3HQO4GpcBRLr+FayE4GAqPo/Cvzp3uzhQELX2gW8J9h8Zyk/zaG4ZCgl6A+ls8/z21frbBqiT7bIHGTf1wGAMDqHsUkrVtYocqCzDSemEmoNUmp5xeQsgnLrwv4YwYNh+mBNVyY6DXvSBd8ITDeMtCm3h8nXkcsCMxdwvB+Ssr7K6sSWA/as5Zz35x9ZN43nc/AJaGy6G2tVSMeJD6JX8tUTHHnJUhN/PEa769vk2hReQzGvoIidtCPRZV8MEmpAT2xgVDx9rAR0I8gODnxkblQBlQzwCuOe2sdJU6rRG2e9k+VAZ6nRziyKE7ZBlNHzZjbB4jK14WUfPN1xQIgmmN3/4kR0edAcmdlMNOZRf2lcIvZ4+QKncZFQWSbznsh9vuMvxUA7j01/FUDEwUMpAxtE0HTXrmuJo2/NsmbZ2ktwHVVcUsE+6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 19:12, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly. One page table walk
> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
> 
> One extra benefit of migrating with hmm_range_fault() path
> is the migrate_vma.vma gets populated, so no need to
> retrieve that separataly.
> 
> Tested in X86-64 VM with HMM test device, passing the selftests.
> For performance, the migrate throughput tests from the selftests
> show similar numbers (within error margin) as unmodified kernel.
> Tested also rebased on the
> "Remove device private pages from physical address space" series:
> https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
> plus a small patch to adjust with no problems.
> 
> Changes v4-v5
>   - rebase on 6.19
>   - fixed David's email address
>   - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
>   - refactored into smaller commits
>   - added more comments to code
> 
> Changes v3-v4:
>   - rebase on 6.19-rc8
>   - fixed issues found by kernel test robot with random configs
>   - fixed typos
> 
> Changes v2-v3:
>   - rebase on 6.19-rc7
>   - fixed issues found by kernel test robot
>   - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
>   - fixes to lock handling (pmd/pte) on errors
>   - added assertions for pmd/pte lock states
>   - other issues discovered by Matthew, thanks!
> 
> Changes v1-v2:
>   - rebase on 6.19-rc6
>   - fixed issues found by kernel test robot
>   - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
>     parts if migrating
>   - other issues discovered by Matthew, thanks!
> 
> Changes RFC-v1:
>   - rebase on 6.19-rc5
>   - adjust for the device THP
>   - changes from feedback
> 
> Revisions:
>   - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
>   - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
>   - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
>   - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
>   - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> 
> Mika Penttilä (6):
>   mm:/Kconfig changes for migrate on fault for device pages
>   mm: Add helper to convert HMM pfn to migrate pfn
>   mm/hmm: do the plumbing for HMM to participate in migration
>   mm: implement device page migration for HMM pagewalk
>   mm: add new testcase for the migrate on fault case
>   mm:/migrate_device.c: remove migrate_vma_collect_*()
> 
>  include/linux/hmm.h                    |  18 +-
>  include/linux/migrate.h                |  27 +-
>  lib/test_hmm.c                         | 100 ++-
>  lib/test_hmm_uapi.h                    |  19 +-
>  mm/Kconfig                             |   2 +
>  mm/hmm.c                               | 814 +++++++++++++++++++++++--
>  mm/migrate_device.c                    | 602 +++---------------
>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>  8 files changed, 1053 insertions(+), 583 deletions(-)
> 
> 
> base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b


Thanks for your patience, I am just trying out the patches and reviewing them in parallel

Balbir

