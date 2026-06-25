Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C07CDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C08D6B00F3; Thu, 25 Jun 2026 07:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671F86B00F4; Thu, 25 Jun 2026 07:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561416B00F5; Thu, 25 Jun 2026 07:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2747D6B00F3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:12:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EE90A02D1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:12:40 +0000 (UTC)
X-FDA: 84918172080.29.ED1BF5D
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012062.outbound.protection.outlook.com [52.101.48.62])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4ACD040007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:12:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UY4uf/3V";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782385957;
	b=rLuGA3CdQ3q0nafIX2Rs4tBWqK7Z7q0/OxBYGzSVm7DbCNCdjaZg8OMAPb8f6codBpXM2L
	Vmpex/OrwzeYNxi6glZgAOsl5xPh2xJTI+T20kowkLkjOWkndjXq/U6v65PiWdt2uX5yZ3
	nu9xWbktyB7cijVj/hzkyU2WTsPXRJ0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782385957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CYPBIXzR592n+h3Pk2QJtmy6IYcxT6NJi/h+xWT3kA=;
	b=4Tab0LV01DpW8KXIo9Yoq1vNiiy/dg5WBg8aaXtwZ4xxGCx13xBWbufiD3gbV0wwxXDcpO
	CoY6BcisaLXlRSyng997h6Gx15A5BuKwtHfrgR8Ibcr/VoIXjBl3aloIHTPYEfABiXwk19
	RLsgDN7cdMunJuHnPXW7VOvVp74VhDI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UY4uf/3V";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NODjIl51ZYoMrYQEJlD8Jeapju0l0RQHm4vg+uxPWR4gFhNx3FD0qaTeXjtWIGftx8Mdo1VSgKVmCTqva4TtQFNrwEZ2+RAu8Si+Ac/UcoaGKdTNlrWp728+OymqaeXSH2JPXlN7GS1NsGB9kmfjvDbvxAWUycNgHITCK4DnFYgwbcPIg2EPKD3RptTPV8Eta5kRloWEsYYZrrNCBBATwgzgCXOYvvmWiq/NSHC0Qvk7dKuXSLULpOkPTFBIClckdgV4gnh/sUGEvdWjQBZMnSHya2tNexul2y/ePXX3vW2IcJSD3DGxn7FUr9qtb+/vDPFLUuhDFtsWYnIZDPPJTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CYPBIXzR592n+h3Pk2QJtmy6IYcxT6NJi/h+xWT3kA=;
 b=X+6DNLU0SAOaBjUrMwlmJOewAX8LLtaunmPut2TilqISdVqPFMufcH5Gl2vZuou0UeLXQcqz0PTY+z77Kse6hNHxL/+997QNdFXHBj9vC2w5ttEx5LK3FMaWt0m15vZpUZGQQZYJDnDAKOB9RkAtXJArUWzP9ZEFTiiETjtM/uDWMsTBUAZ3/AP7RO/pKXRdqDAmQWO4jnrYzA13unF8XiEk2cPjD9p8It4c+y3/VUK4Az6CMZI7GAARW+XteEXbSbauByDMU/9SMO4VdbBb01dzNRZBF1fPMxP1OO+PUNMu9U1kVOmki5j6qPkMqNQdJJb2lTWT/1aWpdsY+Se7CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CYPBIXzR592n+h3Pk2QJtmy6IYcxT6NJi/h+xWT3kA=;
 b=UY4uf/3VXS7Ch/xX1Hy+qTgITl2KsZxjIdwuuszCuDz/+S5A3Q/j00a3KVSm7ZYKJYUMNq62LPZ0tH5GJ8+/LOkpiHhLifErfg2GqpFiBmKu/wSkEBVDuGORir8qbOetJlSz9DuZ1dX9vFEVpPlyGtN43a4ZLUNHcsIzcyZQ/VIJbVlRRaUundHYTYvsqVMYO3ipkCq2bmVSrvw3UE+SFsINwBI/gVVxZe66U0TrgSJ0VF+NB5a93EEE/J6d5TkdtuJXymseacOzdrkzyghCtGI7o6il176SsxQDzo3ZM2S0UcGaU+pYtd0CB4GkoKQkunLmpoDOxFKkljAD6dYoAA==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by SN7PR12MB7155.namprd12.prod.outlook.com (2603:10b6:806:2a6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Thu, 25 Jun
 2026 11:12:31 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%5]) with mapi id 15.21.0159.016; Thu, 25 Jun 2026
 11:12:31 +0000
Message-ID: <38410976-ddac-4848-a4ff-e6a9f7d9c828@nvidia.com>
Date: Thu, 25 Jun 2026 21:12:23 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD
 handling
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, ziy@nvidia.com,
 sj@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260624065353.1622-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0056.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fe::20) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|SN7PR12MB7155:EE_
X-MS-Office365-Filtering-Correlation-Id: af4f5937-0f84-4a48-cd0b-08ded2aaa635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	Q3Ewusi07GuDY1TtPvncyUPvDi7uBLcv8FS8olFLQXInKlYiv9XCRj4IyM2eN90iL37akFubUGMaLYn/Q06kwirRn9rt8oeASMTIpldPF/hFhJKUdAE6KwORMZn2pHoBJuh1vp4fdvSlN8GQiW1axdbw7Qr/czZC91xwHTgRgaelYW5C4FNNRsHmJAAC/9KkknRCFGw83Du+4JupoEb37SyaLKYDRYmu6SgxMphxBfYaaw0G0jC6JgnfG/BrLqBQUNpbTES5wD6CiKOjj6SoXevBF057N2CS9FxEtJl8TVjqz8qO2sqoS0HpGXsV9sLY8Ul9/5VqGH479AlODp0AJpAd9YIe1Fl1xSc5A7myiieftQsYcBY/hcHQLXUWX0FuugzXQv3pc7T0sWGTXLK/awBM3YAP7KOdHaYED6mwLRCd1NQszXqN18WCIbP0RIvwnDld/OyS27u4M/oAFdX+QE/DG83SP4EBnLKo5eWEtddIT01JNqXhoWVAX0jUb6TZnspdq/WWPPICKbjLyVeOBkiMl5k8AmMrtsB/nzmKu3CCY6zF6slM9UqHNdy/GBXPy+r3+ckDrk5vN5HbGxQOR6pD/rUSkSd3VI1gawzIO4NLD9NSzjANMTw8TIwUkr/PmwESwOToJpzEzDY3owY3ZkhTvlp+5VqCCQJa5zbIFvx6WXCYi9qqHFpbe4kyMP6zsIUNcWR9akOtOu5vJ6vahw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEZsbVNCK3FlTTVTYng1RjQ2dTVhOVRmVjhoWHdIWHF2eWtoZnRsR1JBQmVU?=
 =?utf-8?B?QlpxL0RzZGtJelhkZmNqMEJlK0tCQ0FpTEVYeHdTQkRJSFp6eWR5cXFyZ1Ew?=
 =?utf-8?B?RzZzcXZPakdYZDlYTEhRZmRYMEcrVkFiL25hSWlIRi9WQU4rU0tZZmpZQTR2?=
 =?utf-8?B?TitxUEhuM1RERUpJeEQyb0Z6UVhMSkZpOVpnNlEySmtCaEdGZ3M0cml2N1Vh?=
 =?utf-8?B?d3o4K1JUZmd4QUh0empVRmQxWnFWeDBUalBjMktYeVdidjl3ZHBrWlZYQStC?=
 =?utf-8?B?TVl3dGhZYmZwb04reGdhdFc1RXlIcWFjZ1FKM2JuNTYwbmg1amkxcStNVW4w?=
 =?utf-8?B?VTVoY3M3dzhvdFRIZEFUUmU1bktWTExndnBRNloxN0RRaVNwcXNiWVZJSzd6?=
 =?utf-8?B?Q1A3Q2hrWnh4M1EvcEVSa0VXNEcyY0pQQmFpNW96ZVJ1cnd4Z0t4cVFISFMv?=
 =?utf-8?B?RnRtdklUM3hSaS9XazIveGpCcmd0MnBCU08rcjUyNmpHUXNCNmExOVlRL3Ez?=
 =?utf-8?B?dVlSU0xuZ2xsTlFBdHhyRm0wbVd1VVI2MmNRQWVnUURqS1pGZ1Y5aDh1bWN5?=
 =?utf-8?B?R3hRNm9hSnQ5U01paGltZ2pGTzlnbEYyMm5YVTE1ZnNuZDFxV0xCZWQ3RjYz?=
 =?utf-8?B?NmN4R3lrTTQzRDVuMmdoeFQvYVhZSVQyaWtmUk9TcjhXSkRjakgrMERWTUpp?=
 =?utf-8?B?bFUvVE95OGFUbldPUk9wTkpSdmlreG9IRzBUWXBaSC9QZW85c0dGdnR1dkJa?=
 =?utf-8?B?LzUzM3Y2VElqdFVKOVhwMlBWMGxoR2h1ekZDK1NIamNqV0UrTjNUK1ZHQUpj?=
 =?utf-8?B?UFh4b091TzVKOW5QK204Zkx2OHlScUw2Tjh5QVU2ckUvTjRVVmxSd2JkTTEv?=
 =?utf-8?B?MzhQUnUrbnhwUE5tRmJ1dXFhQVNOYWgvMnNRdEJJR0FiSHp4bUcyTy84OXRs?=
 =?utf-8?B?NmNJd01UOUxzMFIrU1J4ZjhVQ3F6UWFUV3ZoSUtoL1JwRmJRSXlwcDdxeFVY?=
 =?utf-8?B?UGRRbm5PZ2pPWkpmdUMvRGRHcStVT29sRVRzalU1NkpHaVg4SDZJSjJOY2hq?=
 =?utf-8?B?TDRpYVRRdmdPWndMUjYvUmRPbFhBS1N0ZllmSFN6K2g4TmVla3pZZmQwZ2hh?=
 =?utf-8?B?ZHI3SjBHSUkxRk4wNDcyMXF2eFI5R3lEQVpvdTBZNnRRUnp6dElkMVFYVDdj?=
 =?utf-8?B?cGwxMWtvVWVqUWpzeTY1SDVMcGU2SkJUcmxqdXN0UWdqMzJENnFBNC9FSi9D?=
 =?utf-8?B?Z2tPT2kxMGZWVDJOejZHY08vTk55UXJXcWVvR285MCt4Y0E4WGhCSzNVak1V?=
 =?utf-8?B?a1JTNWx1VU9LdDBLS0g3WVVwNjBHbHl4Y0M2d3RPVWN6TkZTbTU5UXNJMWFk?=
 =?utf-8?B?RFdtYUdYNjdINm1TU0lTbDNGbjRITzFPTWM3TlFwek5VUWY1eFBkcW9NMlBK?=
 =?utf-8?B?TzhvLzdUdllNajR2bFRSandzK0x0RFB3TzdOb1NiUFhUd3Bsa2psNWcvOXZy?=
 =?utf-8?B?bWNpUysvZW00U285VStERVRZNDNCSHJnQ1VnakNjeUo0elNYNi9uaXdiV3A2?=
 =?utf-8?B?QjRyZjN2aS94KzRCbTlFTVFoTEUyVVFUaEpjdlRMMVJuZkViejN0WVd2OTZB?=
 =?utf-8?B?ZkxqSUJlRlFtbExLblQ3enJrYUVaT042c0xtQ3dIc0xNREZlQ1hxM2xYV0U5?=
 =?utf-8?B?Qk5GaWN3MDRjaEZRN3ZQanh1N2o3UjJTemkwNEFlRXBEU1ZTcXJvUE83TEdk?=
 =?utf-8?B?YWFUOVFnSyttVFVkWUtvUzB4bTN5cEhGTGRsd1N2cGdwa1NmbVVHcThsSzg4?=
 =?utf-8?B?cS84a3lramJSVEcycmxSQW5GTElpVVB3TW5BdjAvWkRuOHlPK2RaYmZubXMr?=
 =?utf-8?B?YVZuZUxvUTVDMDNiUTVRYlB4V29XVnZTT1dBa0p3eGQ3RmdJVEZCL1VMRkoy?=
 =?utf-8?B?aUhFVEtRMVZ6Tk5NeENWM0txV0ZIaEQ5eHBPLzdBcnc0RFZ6dW1vLzl1L1Az?=
 =?utf-8?B?UTVHRDBscmFuT1BCbDEybzNtU2dhcGgvcTIrZkdHM3AwUGl3alV1QnNjdCtz?=
 =?utf-8?B?bUxLMjFXRE1nUDRlZHBTa0RIcHpxZTZWQUs0SFZqYkZDeUc4R09NcDhJQTFx?=
 =?utf-8?B?Q3Y2NVk2OXlsTi9QT0VTQzRIUFIwdFpVSktqWUxRU2thODJNRVZ4M0tPL3M4?=
 =?utf-8?B?d0dOSWhVYkhDL1JDNG44T2tWSk5IUE1ML1E5R2FDNFR5L0RnanlqcHdhVE9W?=
 =?utf-8?B?YmRxTWJHNHZ4Wnk3NWZQRzdWYlNMbEhHbXBMc0dRa0ZSSXNpK1FOTmFuYmhr?=
 =?utf-8?B?TjBqVS90OXhQRWF3RTh3eWcyR0Y5UCtLVVl6bUpoWndZM0d3L08yQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af4f5937-0f84-4a48-cd0b-08ded2aaa635
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 11:12:31.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrFEyVLrBSwZ+aQdGYktkGQpWLwCN+fuOwGHpPKec/rxGE6GLtrZ1CIcM4lff77C0iW9qDxZMSiYYylenWhm3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7155
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4ACD040007
X-Stat-Signature: 79q4cxs9pc6ybxcfhd1a9t73iton9uz9
X-HE-Tag: 1782385957-554625
X-HE-Meta: U2FsdGVkX18vyI6Mnc690ZIsM8dm+kqiXFmg07SzILelLutI6B322x3m9d63JMd4HzBMNkBn+x6YwqQQ+YVRmiyVEaDAgwDb+bn1DO5qqgjmvFjaT+rZIkI9W2UNmpo0N0nqiNZumux8HTDIQZiuZ33+JgxdyBm2wPzn0pLU9bt6hTU9AOEp65XoZ3TLJi19t7NrMlLoW4Lbu1tADkcl6AVQJy1JvafSEQer7LkwGWqzxxXUT6LxT5aPtdX4QpNgsMIK0mZ76WIimtBeTAIcJ7MwET07EyQr+x+qM5hqPmkkDksONDZk8U6+oaKnMR3nHC6z2FDCrTNTBHYRKVfLc39Bqba8n6sH5KdElbXu61nIwhwdl+GEzCqxUFq1hxfKY5mPP6B04/3Q4rKL5rv6bX9+mn79q0pZLOOX+rJU1yAzIY2OsgtCGIz8LBC2xDGLFE3fW42cNMNvkZNyQjcua6V+UJkhltO/HzdowFqj4em5AnsirIEmIUPOMR+89qHQN42cuA6Tt9thmasoIYioNE6FEqDfnxL54xBYlff5PK/ukk4pKYjo9wB+p2NQD7UeRIKjcYPvp7xe+t5xLZyZq7Fp58aBgqTafOseSUJl1Pw6dUsHznmy/mEwBJsUdw/gemx63XU0b9i/DNXgG5uE0+5m1xUOSvE5pG4BINf6j49kloNc1FsrCRNjSyDQyeFL2wN6wbgW1f9GMutxGrRLM3dFlw/KIMTuzf8GdOpv/KmjbaL3rftOgnD7xyremOObaoxBr9Z2J6yVmI2E5yDwbig1700u8Xr2C3JTHoBXJN/n6IclUYUFHisixMOofC2Ubhe4XetDvyGCba0rQzwV3Y7gnbxJ2P56VGWcTVxG+nXG4i2aPXIRPsccozl6MbqnvtfC4HKhzuYPk8uB+4NDrBqBgHEGlWP1yTOOVjnNMUToy7UvLBODD2WsPb1vP/mAS9nB3IpzU4uEBafUiC6
 mKNPk+0M
 YveXOAzZXawZnLrPGekNWV9WGcGqsvR1tAv1o5glhtPjNcD4W2Y9rjE1tJOwFbNzB6AedCR7sCGvl5a65lIcfE7Y6RJqxMYwkLu4I19q2m4WxPMmPRCJSd4TPanTCbMd5F0iebt3G9WcYqUsI4D01Iq4EDLYMHWh/TdrNYsbmZSeP/eTIQoy1qNXj2dqjzqmWPb5N2Z/8Ve8WIFWPCW8/LE8SEljhz8NimHyWlJ6d6nvaAlBVDJ2y1zoRH6zkPtJ8HI+iVPdFahZoMHkl6ZbQk6LCh4kMGJQ9pu4yR0b4XBGUOjowFIl7og6pwikWYBlQCJJcCeVHpINApc0z8ZMFngecZQms1StFV7S3b5nGs0dxLYGPfOgQ4gsWkwCOkLg9CJQtCixkZpzjnTS1cKS3iT3VgzEVO3P3L+mBqaTg+a/zFUDTAPrjYkQwaxMN7kF9cv7zAvYa9rilWBaJS2JS/H+/CtyENuaMlY4vhcz+/70ICetqDDxQc9eYTNLfQD52xxnmJRCM8D5LwVzg/g61VlwP50FdSBzL2Pzv1LXRPjj6+qngYUmXchak2n3PwDSF+qY9Ym3Jx9wy1uVpag/H+2QBC5+Euglaxu8T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 16:53, Wei Yang wrote:
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") introduced the concept of device-private
> PMD entries, but did not correctly update the rmap walk code to
> account for them.
> 
> As a result, when page_vma_mapped_walk() encounters device-private
> PMD entries, it takes no action other than to acquire the PMD lock
> and exit.
> 
> However this is highly problematic for two reasons - firstly,
> device private entries possess a PFN so check_pmd() needs to be
> called to ensure an overlapping PFN range.
> 
> Secondly, and more importantly, if PVMW_MIGRATION is set the
> caller assumes the returned entry is a migration entry, resulting
> in memory corruption when the caller tries to interpret the device
> private entry as such.
> 
> In addition, commit 146287290023 ("mm/huge_memory: implement
> device-private THP splitting") allowed device private PMDs to be
> split like THP mappings, but again did not update this code path.
> 
> As a result, we might race a PMD split prior to acquiring the PMD
> lock.
> 
> This patch addresses all of these issues by invoking check_pmd(),
> ensuring PMVW_MIGRATION is not set and checks whether a split raced
> us we do for PMD THP and migration entries.

Should be PVMW_MIGRATION and "us we do" -> "as we do"

> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> 
> ---
> v4:
>   * refine subject and commit log based on Lorenzo's suggestion
>   * put pmd device-private entry handling in its own if branch,
>     suggested by Lorenzo
> 
> v3:
>   * remove cleanup part, only fix the issue for device-private entry
>   * refine user effect description based on Lorenzo's suggestion
> 
> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>   * specify the possible error case of current code and user visible effect
>   * besides fix, cleanup the pmd entry handling based on David's suggestion
> 
> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
> ---
>  mm/page_vma_mapped.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 2ccbabfb2cc1..17dff8aab9f9 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			/* THP pmd was split under us: handle on pte level */
>  			spin_unlock(pvmw->ptl);
>  			pvmw->ptl = NULL;
> -		} else if (!pmd_present(pmde)) {
> -			const softleaf_t entry = softleaf_from_pmd(pmde);
> +		} else if (pmd_is_device_private_entry(pmde)) {
> +			softleaf_t entry;
> +
> +			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> +			pmde = *pvmw->pmd;
> +			entry = softleaf_from_pmd(pmde);
>  
> -			if (softleaf_is_device_private(entry)) {
> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> +			if (likely(softleaf_is_device_private(entry))) {
> +				if (pvmw->flags & PVMW_MIGRATION)
> +					return not_found(pvmw);
> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> +					return not_found(pvmw);
>  				return true;
>  			}
> -
> +			/* device-private pmd was split under us: handle on pte level */
> +			spin_unlock(pvmw->ptl);
> +			pvmw->ptl = NULL;
> +		} else if (!pmd_present(pmde)) {
>  			if ((pvmw->flags & PVMW_SYNC) &&
>  			    thp_vma_suitable_order(vma, pvmw->address,
>  						   PMD_ORDER) &&

I looked at comments from Lance on "device-private PMD <-> PMD migration" and had
the same comment as David

Balbir

