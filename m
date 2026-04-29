Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83FD2FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 11:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49526B008A; Wed, 29 Apr 2026 07:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFBA96B008C; Wed, 29 Apr 2026 07:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A103F6B0092; Wed, 29 Apr 2026 07:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92CE36B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:28:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46C6C120154
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:28:15 +0000 (UTC)
X-FDA: 84711369750.14.E807B32
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011055.outbound.protection.outlook.com [52.101.62.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E7CE140004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:28:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oMinBzYk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777462092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tuSsAwGT+PCO0993HjPk8Wk0X2IY6p5pp85eTMrcCA=;
	b=IOacTtkdGA9NeIfjCwkNxLk154KbTN+3PpbgqfolO/CmXk3cNH+uzMkdCsrH7n2YSSMVAn
	Upuq5mKY+ub1WYVBkYVLwVtaY5yXIY0wg5KVs9pwixwqvqFr7IDiH5HmB0pRFyiduI8n9q
	KeZwPOh8wuMf97pnyoaLQl420fE5y1U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777462092; a=rsa-sha256;
	cv=pass;
	b=DlQlEB3zw0TleUCTJnBDgY8OJjOP6JE6u3FCb8YFv4UNx1n+Pacaox7R+cmS7kE4j6Capl
	21gRI7LknCgrcMXXQHqOTJNp4/d/U8YpN92oTzHD+WNLIKu2epHwWb3Hhbld0CCGFYl6wB
	jtJtjQvDC8iimIN9F2CPbxIgVKJi3ZE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oMinBzYk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G9ZB+55HB/BIbbF8sFPm4FaGm7ci3D0LM3YiAjgt7hEZI2+UI1ajAKFvI6132N0V97AhGEFa54oEx0gGyz5ZS3yMN5veY9kesY4na7VVcWV5CZpUYRqjTdM2uVwl+twwTh0eKvUlmzgPyN/gM6cCCPOkl7j17YPnCYyAdCTUKW6C3Ovpgncue1eZmdcKnnCYPgf7W55MITZGMKfyzhKMFN2mofeMFMhU7d9WrSY4zQBUemaN51p5W1sbZNZ1yvxlrhz56fMQXAYJZUn/xLN/THCcU9oOBSU2V4jRPa+5cQi0+5ngz6ul/EFQSmaelVfkg0c0ezH5CRhyVXyut/GdLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tuSsAwGT+PCO0993HjPk8Wk0X2IY6p5pp85eTMrcCA=;
 b=C++Icxp3Kss9xcnEDPoxHuYqO0tKVPldB2GjLAu+IWG5dITwQh9a5YvS5vWm8pnQ4HNseBV++LK85wICet381zArZDCvyUkyOq/G9+jrIfRlC6C8+UqfKRbgFPE4Ny0TSxk5KzqwWRQaoWJ29kZ6trRtbQ13l6kHN5v+1qnUzjmGQGpRFgLMz+KqI7FDIAdVgaoKjQab72AVaATzqnk2UneH9Al6af3Vo6z4mig05Vlg3xZ7q/oUWPKr3h14Zj/1/1zazR17zUoyNyYdIkt1DMYaLrrlzB512ynREZZHRd5oh8wBViMKS0JbhuGiJu5GYBPdSx5WACCH5L/PoCAZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tuSsAwGT+PCO0993HjPk8Wk0X2IY6p5pp85eTMrcCA=;
 b=oMinBzYkvItKeB1hQ2ibXmNZNg9oRUIALqLjC+Itk9hqDXwqqIr+doOPMgQEB/c29YpzUQvBbL2A284u6uBB+dXjSt6cR5vFpKZAOAor2yWmSvbAzDLzHX8B0yenGzpuSMtP66VYkoyub2pU9Rag/fonNzRq7jMLgStgKFyWKTR9Yl4CdDxaNIdehnPA6a9+LcWWo75rzD/F5jz2ycF6u52cA75a0TXB23RwqB4AWNMdEXZXKo4I12BBdOSZago4/ZePGxI/1BKsSD9ALvSDGkVvb7F7J4JDiUqSzFMSuDMskkdZLpluNv6oG5snSDyBmmZA74LRT9GgckyEd/fRLA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB8266.namprd12.prod.outlook.com (2603:10b6:930:79::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.16; Wed, 29 Apr 2026 11:28:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 11:28:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/page_owner: add filter infrastructure
Date: Wed, 29 Apr 2026 07:28:06 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <34AA040B-65F4-47BD-B98F-1C00A9384AE7@nvidia.com>
In-Reply-To: <25ba8fe9-30c0-4f75-a6d2-e14560613950@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
 <20260419155540.376847-2-zhen.ni@easystack.cn>
 <12259EA6-2095-4F79-A7C4-E89DAFE9E8D6@nvidia.com>
 <7944d24f-f29a-43b3-918b-ce25e7bae520@easystack.cn>
 <F8F8A2DA-CC65-491B-B69A-2716186D0495@nvidia.com>
 <25ba8fe9-30c0-4f75-a6d2-e14560613950@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::49) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB8266:EE_
X-MS-Office365-Filtering-Correlation-Id: d7752c32-2cdf-4251-2e39-08dea5e26378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UfHwVu9ksv3fh2o+/wWUqaxetW0xXLtxeFN9PIcxnQ7MIn11K2iQaGetXDiQ+mPDjWaNc+gtxba7juB6EO/V6uMBEGs/kd/vVZ6hwzOsmUhUD/KDiKXja9DbPcZXV+4m8xCzUwY1/WZDZ68ufJdtsN9z4h1y1snc3zQX03QaUcgtfCAdJghThH60Mbe36kRR/xjgXwbMjlWPHQoP3FTVd5feFUSHciXI66NoeKqoFDJ3lRG+lLJrC3I6GIikyO6Ds+Q7Pp1xKd/rjCtHlw6jqxi4aQSWu9RUiPQ+Ml+6vcvw05IkxejcXI72o+sRA1VmzZJ62tpa7qgpcyEUbk/y96MldpOsp90MNo0ty0XTwA53gdW1vIOfu/oXyYWEMf8r1pC4v8JtfQM+HhWY89Dbi5/EOkXNOMP7QBJ27fJd8kefNCpKDTWgOS7IVak0sdk3MABMo824KmoYsju2prm297pjIiiY4+eUDHB6qkNuGWz2E2bwxpWrqfg+akXwAUcx/WMMESuYts2WhhWVygdmBjfg9DgOsdiz8G4AXXIDjVQkDRABHYgPyLvWQSeeTxSPRnoUcwEsqxNq0o+X/lWKPdtJ6HW3SZ7rYU8xo70LY0DxUdoPjW+3rjCPMSpzyAhLZtUB50g0ts4KegFo8DXYMq7t4Y7mVqoPop0Pzd5k++SM71X10eN2uh7+S1uETRmQeJiCg68QeLVAGiwTryRfPKplph5diBpgK04BZFAaPH7r5Adv++6O4RenHZuwsRUI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEZBTW1tK1ZSRGhjUlJ1UEZDaElzUzM3aitKVFc3R0dHVnVOUHJzYTJYRDd4?=
 =?utf-8?B?UTQvMWpYMWdIdzZFdEhDV0pyT29Ed29MbUZuZEtNK3EvTXF3cVhnTXhMMnBI?=
 =?utf-8?B?YWJxMlh3ZzdZaW1QcVRIcStzSjQ0dEFpd0JNeEptYncyVkh1cW9BYStHMDlQ?=
 =?utf-8?B?Q1pFcEc1bDUxTGpTdThoSkc5NnNsSCswdDVSWFRxWFNNLzdBcGlhVXpjcWIr?=
 =?utf-8?B?eGpKRzc1bmNQUVdhVU8xdisxVXQ1Vld5R1d1STcvaTV6b1d5QnFRNzZlTzhi?=
 =?utf-8?B?di9YdnBjZmtSN1VZOENEUWozcWdtbWwzRXorV0xtcG1LKzRzMW1tSkxKcnU2?=
 =?utf-8?B?bGN2SGM2TXhOK211LzN4VDJTSGhMWUhZRTQ5UGtFcks2RGgyWnkveXd2QVo4?=
 =?utf-8?B?bDA5SktUZ0l0d1hOY2RoU2NSclpLVWluRXcvSHJUR0VHeUIwaHgvTXQrcnJk?=
 =?utf-8?B?SVRVbjJPZ0xLS1g1RjlPRDZVSHI1S1FLdWIyMGJmNTUwWUYyWUUwS2wwYWZu?=
 =?utf-8?B?d3o3TFVZa3Q4a1IvM3UyR3lkbjZIUDFwWTZLQThaVFdqWUxnT25kRkNQOC9Q?=
 =?utf-8?B?WitaMjVWcmZ4VXdPVzhJWC9uSjBDZldveEhSNDdlTWZOdVpvMERYVnNjRjkx?=
 =?utf-8?B?aENMU3lPUXJ3NEF1OTdMMUlJRGZTb3dGR2NpdFlTYWRNZFBXNmVvaVNNQ29L?=
 =?utf-8?B?WFFRTHRDZkhxWUFIaVlUWUoxUTh5VDlqUFRCV0xna09FaTZqV0xVTC80NGlW?=
 =?utf-8?B?end5RVhodDVqSTBMNDNCa2ZvS25sSzAydWpRcmNWZTNsYytrV0pOQlpTL1Fp?=
 =?utf-8?B?SC9OZmtGYkdPd2dlZ2RvSnl1REJJVnd1MDY1NFBiZml4Mkt6di9FWU5oTkRJ?=
 =?utf-8?B?WU1LQkNNQmd6b2V3ejBUb3dQRE5XMU51VTc3bDNjWmQ4ODlDRm9mbm04ZUs4?=
 =?utf-8?B?aUNRb3ZienZ3TWFtSEwxMkVveTZ4RXZzYm93OFBGRlo3Rm1SSmNoRWdTRHNV?=
 =?utf-8?B?Ykdja3F0L2JIWmRtdHRWUzZiTkJuRnRHdFdmTmludytGUC9ncEcvR0Q1OUtN?=
 =?utf-8?B?MzdyUVRZMXdVVWpTbTlMdGtvQzRzZlZuczcvSXZBS2J3cFZYUlVZQUFMZzZr?=
 =?utf-8?B?N1diSVFtYkdTMXFPckJaUkdERnhFaG1TejFNRXJsOFBMaVhGV1ZpaUlBZ3VP?=
 =?utf-8?B?cnlabFhZcWdya1RiVDBqQkJWZ2NFaGtCNkJ3YmpaYnVUSGQvL3NCejBydTVl?=
 =?utf-8?B?MnBFOHVkV2hxU1k4WTNIR1VsWmdxdWkxckowRitNcEwxMVpvVUllNSt2OFNY?=
 =?utf-8?B?bUROems4Uy91VGpLNjdZTFJ2cVdkb2hTQ29sL1NwT1gvd3BhRXlkSFJ2SFly?=
 =?utf-8?B?QUl1Q2tkV1RodXE0amhXdEN1UERTSWNJN1NKdHM2anFsY0NOT29zTERRd1dK?=
 =?utf-8?B?cklaSmNxazFXTjNLU2ZiMWlQNm5wVTA2WGNYUThiNk5RK0l2eDh5U2EvTEVN?=
 =?utf-8?B?SlJab0IyQ1JXN00wZlpTU3VJY0dwYlBDWVJiellJYjhheU4zbzlselFxN0th?=
 =?utf-8?B?a2xlWmdVK3ZWZVVyM2x5NFNJMFlBYk5YcjV2RFFjRlpGUElVajVNc2J1d3p6?=
 =?utf-8?B?aVlpRHU5bW1QOFU3ZmppTzU0OTRWZDM1aklMRlNyYTcxY0prWldaZ0FwalV1?=
 =?utf-8?B?Nldkam94b3RMYW9UYUFwNFlJZUFXWmx1VTVPZDBRRkJwR2ltV2V1YnpmOWJE?=
 =?utf-8?B?dENaMFJobzNOcUhjaUJ4cjNNdVJXdFplWXRtYWo5RjQwYmNPMFBTdHpkelZk?=
 =?utf-8?B?SDdTd3R0ODVGdUlNYm52MmJhV1B2VWo2YVZ2Q2p3b0wyZFNSSGQzcUxxaDJG?=
 =?utf-8?B?aUNIY2tCeUpSVVo1cnUyUG1QdDNycFpCYnVEMmJFQWNXblhSaDdGK0h3NENI?=
 =?utf-8?B?bEpSSzZkQmlmNjVFWFVLL2IxUVgwcUR0cHZKL3FweWsxZHEya2Jnb3VoRy9q?=
 =?utf-8?B?RVYyR0tvSXo1TXVJS01GSHV2dmlaZ1RYS01rZm5LNjZ4WTh3U3lrYzhwYndv?=
 =?utf-8?B?NHRYalZTQ1Zuc2JSVFZwRnk1MFdUMHlTZ2h4SHVMNlF4T3h3MzRYNUFzRWlH?=
 =?utf-8?B?MmZ3Y1FWb2R1cTN1MGZjVzR3QXk0dlFhWUFPY0NkZlovR1J2d1U4RXlBUXN1?=
 =?utf-8?B?cnVJUTk0OWprTVcwN2RXaUNIM1ozU24wMkJ4Q3pkMlR5OUpyYURMN1M3b2Y5?=
 =?utf-8?B?RERiTUJaMmNmd1A0MW1VZ28xaFRKeGRZYXRxWThjL0RldUhwcTd6VVFzYzZt?=
 =?utf-8?Q?jdM4xPvaPq6wuL8vv3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7752c32-2cdf-4251-2e39-08dea5e26378
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 11:28:08.4271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLvm5kXAJQAR39Ra2E+uVQHRUBrzoYGBIX2YmJ/R2R2xmFIQ4BffMtdEZCuZBnJy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8266
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E7CE140004
X-Stat-Signature: ayfke6d195gkxeyd64ksu6474ezxcq7d
X-Rspam-User: 
X-HE-Tag: 1777462092-7560
X-HE-Meta: U2FsdGVkX18ULWRMg26mBWMechS7G421CS7G55iN/+qW/vKbmRy1iDIzbvJd+uGyxzWKyXEb3OP1UiOhxnDxte7U6otMRj5YZzjahiUkZbeeyplzHFr6Pc6xhdnItvM5sjhE2G0Zuv44lFoWOE6ekby4u2EEK2jbWQCHFe1BtEd/qdK4X9LTbKY9ijU9uC6f/IEDqUMjlxp4Fmjyh5lL5n1uRdEbfIj+7Sw2I1OodTXYDWBL/2xIxYn7dUjL7YHH7M+DX2q/j/LPC26dyBFU2ZmlZBQINXPQgyjlYWOrEFqOogvl0aA+E7E5FPip4sZGqR1vlzvpyntsUXekEjkJV6AdbqVisq9/LLfIKg28s0gv3FgyTUI4w4iYQXFR0/MPKev4S9uyq5x3bfYM6cpUvFYv/tTydBX1KIn0bZSXwRNW6BeaWvSiSJEPOpAXOK4CAcPCO8fgYnnBWaBjx5CSPc+Q2kktqpER2ZG74ksMG2/aZYD0V6eUyg5lgzO9T0Sr+pFRoEr+QDd3dh0oLUMxaPy609nca1pSFlBWFA6lzxynWBvHQdMezy1W5XE8ldHeKWlHY2quH1tRptloR9STz4Q0XFm3tqD4UNvV+CF2P8uYI2GRHrMpoq7Dw+/T73ILOaC8+G3KT9VJuo8mzczXsr86ZD2LpVNTrxkE/X7hqoQl2sf/OI9xq/+r3U53YdYfMgCKFYYMiqXiwzDSKhTNvkuudB2Qt92PAkdxCjSuFZfT5g3pMy+FgLOeCvQ4e+gC4UpBVqN2UzEosXWSUxQofvG7Qt6UhtIMd1kaeZJAJlEIE8kUucbQ81g1mvETuqJJSPxazDI8moKzu7IzPAKCpFm0uNMCBUKZdH4sJzOKJXDwAgwmjXQLCq3Lvf1HY8hzpj0ievXcpWkD2yH4qzs7mPbFnJP4R3DGUR/N+BhCn+K9eQ5hr9SeRnoCnKe2RuQGjHYSW1QrRLWe8+nYghE
 c3R1WjSu
 s7FNoWr0qgam2KIVm8ZqMfsiiS1a43imqbQ/wBDXgP0mNaE4B9XpNTbPY1q5JBe4KFrLQ4ShyCv5moEtVlwjFNpnpN494qn3Ki1HAw/kRxVKIHhPaQMNp1aUHLA/X5zUH4zvrYCzGUwDf0fc0N7665KvqMLExCuWNeDshJYK5CtDOZl3zbIHK2ztydec44MfkCxuXak7TolHVeDdUBcxqZbfvmgVKjTjaHOTl1zbTOoroop1RG2kP5hdzufBGvk47sx4zNWA+hMyeANNoNQCVgjQYkPV+Oj0jqZPyV11zwtYzbFN4UUR2nn4QdXmWvjTrUB7dc1X2KOBowxnRxLZIB+1zKWdEp2UVtLD6uHo0CNeVB/31iiHgR8t9pcyiqcWLPW0Y99hHFsaEIZbDODQFBhm3gjccPFleDwUxhEHg49B6rGShL8uAciALeWOndaoTg/xu1Fat/2cnRfoxrYW/8y2SrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Apr 2026, at 7:22, zhen.ni wrote:

> =E5=9C=A8 2026/4/28 21:13, Zi Yan =E5=86=99=E9=81=93:
>> On 27 Apr 2026, at 23:33, zhen.ni wrote:
>>
>>> =E5=9C=A8 2026/4/27 23:35, Zi Yan =E5=86=99=E9=81=93:
>>>> On 19 Apr 2026, at 11:55, Zhen Ni wrote:
>>>>
>>>>> Add data structure for page_owner filtering functionality and create
>>>>> debugfs directory for filter controls.
>>>>>
>>>>> This adds:
>>>>> - enum page_owner_print_mode with values for full_stack and stack_han=
dle
>>>>> - struct page_owner_filter with print_mode and nid_mask fields
>>>>> - Static owner_filter instance initialized with default values
>>>>> - page_owner_filter debugfs directory
>>>>>
>>>>> The filter infrastructure will be used to add print_mode and NUMA nod=
e
>>>>> filtering capabilities in subsequent commits.
>>>>>
>>>>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni=
@easystack.cn/
>>>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>>>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>>>>> ---
>>>>>
>>>>> Changes in v2:
>>>>> - Use enum page_owner_print_mode instead of bool 'compact' for better=
 clarity
>>>>> - Use nodemask_t instead of int 'nid' to support multi-node filtering
>>>>> ---
>>>>>    mm/page_owner.c | 20 +++++++++++++++++++-
>>>>>    1 file changed, 19 insertions(+), 1 deletion(-)
>>>>
>>>> The patch can be folded into Patch 2. Otherwise, these new types are n=
ot
>>>> used and page_owner_filter folder is just empty.
>>>>
>>>
>>>
>>> Thanks for your review and suggestion.
>>>
>>> I kept the 3-patch structure mainly for clear functional separation,
>>> which also makes review easier. Patch 1 adds the infrastructure,
>>
>> What is the point of adding unused code in a separate patch?
>> Patch 1 has no functional addition and should be part of Patch 2.
>>
>>> patch 2 adds print_mode filter, and patch 3 adds NUMA filter.
>>>
>>> I discussed this with Andrew and he has already accepted the
>>> current 3-patch structure into mm-new for testing. Since he's okay
>>> with it and mentioned that bisection holes are acceptable in this
>>
>> The patches are still in mm-new, not mm-stable. It is totally acceptable
>> to reorganize them.
>>
>>> case, I'll keep the current structure in v3.
>>
>> Please refrain from posting a new version when the discussion is still
>> going on.
>>
>>>
>>>>>
>>>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>>>> index 8178e0be557f..5884d883837e 100644
>>>>> --- a/mm/page_owner.c
>>>>> +++ b/mm/page_owner.c
>>>>> @@ -54,6 +54,21 @@ struct stack_print_ctx {
>>>>>    	u8 flags;
>>>>>    };
>>>>>
>>>>> +enum page_owner_print_mode {
>>>>> +	PAGE_OWNER_PRINT_FULL_STACK,
>>>>> +	PAGE_OWNER_PRINT_STACK_HANDLE,
>>>>> +};
>>>>> +
>>>>> +struct page_owner_filter {
>>>>> +	enum page_owner_print_mode print_mode;
>>>>> +	nodemask_t nid_mask;
>>>>> +};
>>>>> +
>>>>> +static struct page_owner_filter owner_filter =3D {
>>>>> +	.print_mode =3D PAGE_OWNER_PRINT_FULL_STACK,
>>>>> +	.nid_mask =3D NODE_MASK_NONE,
>>>>> +};
>>>>> +
>>>>>    static bool page_owner_enabled __initdata;
>>>>>    DEFINE_STATIC_KEY_FALSE(page_owner_inited);
>>>>>
>>>>> @@ -973,7 +988,7 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops=
, &page_owner_threshold_get,
>>>>>
>>>>>    static int __init pageowner_init(void)
>>>>>    {
>>>>> -	struct dentry *dir;
>>>>> +	struct dentry *dir, *filter_dir;
>>>>>
>>>>>    	if (!static_branch_unlikely(&page_owner_inited)) {
>>>>>    		pr_info("page_owner is disabled\n");
>>>>> @@ -981,6 +996,9 @@ static int __init pageowner_init(void)
>>>>>    	}
>>>>>
>>>>>    	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_f=
ops);
>>>>> +
>>>>> +	filter_dir =3D debugfs_create_dir("page_owner_filter", NULL);
>>>>> +
>>>>>    	dir =3D debugfs_create_dir("page_owner_stacks", NULL);
>>>>>    	debugfs_create_file("show_stacks", 0400, dir,
>>>>>    			    (void *)(STACK_PRINT_FLAG_STACK |
>>>>> --=20
>>>>> 2.20.1
>>>>
>>>>
>>>> Best Regards,
>>>> Yan, Zi
>>>>
>>>>
>>> Best regards,
>>> Zhen
>>
>>
>> Best Regards,
>> Yan, Zi
>>
>>
> Regarding your suggestion to fold patch 1 into patch 2:
>
> I understand your point that patch 1 adds unused code and creates
> an empty page_owner_filter folder. While a single patch should not have u=
nused variables, in a patch series it's sometimes acceptable to have prepar=
atory patches that add infrastructure for subsequent patches to use.
>
> I found many examples in the kernel where "prepare" or "preparatory" patc=
hes add code that is only fully utilized in later patches

Those preparatory patches usually add actual functions, not just types.
This patch also adds a user visible folder that has no function.
I do not see any reason this standalone patch is necessary.
>
> If you and other reviewers strongly prefer merging patches 1 and 2 to fol=
low the guidance more strictly, I can do that in v4. I'm open to this chang=
e if the community feels it's the better approach.


Best Regards,
Yan, Zi

