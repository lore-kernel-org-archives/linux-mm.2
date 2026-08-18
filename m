Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95033C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 11:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996216B017F; Tue, 18 Aug 2026 07:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CF86B0182; Tue, 18 Aug 2026 07:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C4A6B0183; Tue, 18 Aug 2026 07:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0D16B017F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:13:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEC48C0BF9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:13:41 +0000 (UTC)
X-FDA: 85114129842.21.C226747
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by imf31.hostedemail.com (Postfix) with ESMTP id 98C8B20002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:13:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Aj90WoOc;
	spf=pass (imf31.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.9 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787051618;
	b=zNoHbN3ujxx/a4GgHHpjgaQCDgOe4+97K10TjvYctXF/o9i58uvhJZ4jukUa44/UWJ2m82
	cq9cCiC2S/z3uoM73zIzFKEiuaap5XMqDRnzOqog2JM2F/nLH0pS4Zy21sUixW9r7hHNI0
	678ZdlqVSUw6BT+/ORtDECG1Tm1pYwg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Aj90WoOc;
	spf=pass (imf31.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.9 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787051618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLUzXjrh+WWc4l0LXpbfIQ0qVkc588TQYRg808JgDG8=;
	b=iWyWgxpJUC6aQq1iBB9GBTd5kAhJ4rjKPshP7fxkFvw48UJdufbxOiHqso9d1nqFdzS0Mv
	WC0JWE+LnqZGPk+YEbJWp0SLDxnmKJQOZ4wx4w0XCZYUXhTgLCw5QR7M805KOdr0u/gdWw
	FM6xU1/Z1Y7VcsbjjzGrAjcVFlNL+YE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUTzc2wCiC/Syx+1TydhE9AP8QRHMk0sbm7ViUzWDK7fylcMrIZMxQbRt/fP2szxGQ6a9RiUWLoCyEPg/cEkzhrZ3WMwZ+XM/pROqVEFRFs9i0xLtLQhIz9+vafShxL806uecEQxj2HOHzye/rH5hfFFnS0G2w8QlkVb8nDBJ5BFbQPospJXUvWFmZtWmisnx2eZQ4o08dvDW95IjCuJMt4uHug5RsUFT8cYPI+Ju6s7JVT5G8gd9CPp0fmXBXBnB3QlQbsYuIJHuM8gJsL9OBIXeHVOAmrC7tPFWaOIxX0qfFmnm7EB9+EOlSPNm7tGQMoRLzPjr24RNryG7bd+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLUzXjrh+WWc4l0LXpbfIQ0qVkc588TQYRg808JgDG8=;
 b=oIo+CpNylSVf9DpW0KiVv2Id/1mODjpANCDvEQ2KD2mwzODbjOY1eMCdx1keBzryjp1dLva2DoeqvS+pS/Toqr1S/UoeOpPm7Ns3e4g7G1FKA0BRtNuIpqyxGxIXQASoLiUK9SrRsLYNPpH/XXXF7PyUF4/rSpZakRnvoDWxldW4FdN7bf4q+s6Fmu0XTHru42eg5zZaismpeWWN4oNkDvJBkvAaXTlJZBDNOU7goKoF5emLiOmrb3Dj3Qor3iLtQc6u4kS9yWo2v+VTe7NjgITmbyzb/AguydOaa3uLkHFDIUsgj4Yd27ny14IBk/pZBgZndqL66OcoKYFW9cXkog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLUzXjrh+WWc4l0LXpbfIQ0qVkc588TQYRg808JgDG8=;
 b=Aj90WoOcDjH4IzSPHLC6pZHFFD4MvbR5KUmqJDai/3YgoYdS5z8NKpGYRqiIirfN/uz95Gnc5oYYhyojqWT01P0w4MsDy9/zOFzIV6Ja2Up19geYu25Kz/uSfFtTIURBNgqxzRQdoEVjXzYAmNylUoWbmWf2WtnK8S7w34BK2CmRTgXHOp2XY7EogXQeeFLBkpKo1xl5/iyf88BVbbJRF6BVAqgr7481ZP2KwrwwBEg/109LxbUnedxXMnfbb3SjW0w0EXYEVTFUilvyF0+L5CeinT+Pl22Wt/A/1ywIuOmJSitxcLH3Er0wlrz10tuAHYVnhslVN3I1/3Tx+OorEw==
Received: from CH1PR12MB9670.namprd12.prod.outlook.com (2603:10b6:610:2af::6)
 by PH7PR12MB5655.namprd12.prod.outlook.com (2603:10b6:510:138::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 11:13:33 +0000
Received: from CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811]) by CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 11:13:33 +0000
Message-ID: <f039fb9c-465f-479b-a909-2e57943d545a@nvidia.com>
Date: Tue, 18 Aug 2026 21:13:25 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: avoid out-of-bounds writes for
 compound folios
To: Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>
Cc: david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260817120758.669807-3-sh_def@163.com>
 <20260817112150.aa6cc927cf501d687336c0ef@linux-foundation.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260817112150.aa6cc927cf501d687336c0ef@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVPR01CA0027.ausprd01.prod.outlook.com
 (2603:10c6:220:205::15) To CH1PR12MB9670.namprd12.prod.outlook.com
 (2603:10b6:610:2af::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9670:EE_|PH7PR12MB5655:EE_
X-MS-Office365-Filtering-Correlation-Id: ad6f72bd-4979-4e96-f078-08defd19bdc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0h5lgHmOyTMMbnNJ5xTOSAasooRAW92bTqSvOXp0MEkfq8KnaBbi2vZ8Y2Tez3yRbx+6XR6SWWg/qSCaWn926nxRPDp4dmBsAmnJgZZe2JxRSo+PyTSn4SSUioTIrgQIzPrtLiRSa8VhxV8u5ixJE5MFeotXvDQiEroXWvA5HI6448TkNmq3jiSQZIo1pfSF01l2JGjtm7WFNXDDoqNsnwLzXnyYekRSraf40+7audbJAosgS2AjDBdq0rVyHelj8s8efCHMcrM4TFYQM3lKkFYv9xPQ7glaEwzKg4CNmp5jgkXCCmQ+jZUuGjR/hG46222dlupS+Hk1+TlpjyJILKucOZShaQmh73ptjSSvt11LptGnMQ8wfrSJZf2khvUnYs6ztmTfiP39aYkBj1LhHRVzjgqADtxVaCjuj8JdrQ2zPqM2LHJorbp32r4AplwF3uVSQk2raidQX0lZX6pFr0PYoEU4wQSxSGX5HDRJ4nydus3/hFjpXvIwU8bEDxAst5w6nGMZ4EPmq3C3S2LW8iE7jDRgptqn5uRydo6dOYoNHdd7nUPuf4GsGbUqtfTVJWbwEQI0oLzG/e3OBlIosrP2Yl0y9iJEy7XzUbARQk8yiHTz7BVbdMo5sY4JPPUPfCJkkKipYOQvUKS/oFPbBxTYcRDNfdaxPDcIF+LgjWc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9670.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MCs2cWNXaG1jRGFLVmRZYTRPN2lZN0RFem9VV0VnMXNaVlBVU200SWQrTFY0?=
 =?utf-8?B?cUp5M1VQRWNrWnVQVmI3RU55eEppUlRMVkNXWldscWxxNXNHKzVrWU0yWEU2?=
 =?utf-8?B?T2EvQnNaVlAvTlZXOG5rK0MvbDFQYytDODN1UXdTVXZ2UE9VQ2ZhMkpYeUpk?=
 =?utf-8?B?cEZ4TlN6WjFDTUs4YjcyN1JHLzBWaktEb3p1eDk1WXVPazdWMURBWUwwVGFu?=
 =?utf-8?B?MW9xTUdQcm54QzN6dTdDZ0NKZ2tKTUNyakRHL2ZUL0FEb0plME9wMElWU2NP?=
 =?utf-8?B?MUJGeVpNUUVSWUtCVkZsKytDVlBHdHdGdDFtUEdkYVR5YThYaXlveGpkTHBI?=
 =?utf-8?B?UEdqak80YUJ1TW1PUXI5ek1yaU1UZzdmUllXNHpOcVJDOVJGZUpuWHVLcmVa?=
 =?utf-8?B?QzRieHF2YVIwVjJwT2s0ZzdVMG5YU2xzc25YazF2MlBydC9Ma1BqUzdQclQ3?=
 =?utf-8?B?Z24vTmt0eExEYmxNTGRkMWVQYTRhR2FmczdTcXh3Q0JpazZBTzBrN2RBd0xG?=
 =?utf-8?B?OGJQMUxLY21SanZtQlMrZEFDMUFVVlZtbnhIbWRrQ0RhR0tNT1QyMGc5Nzh2?=
 =?utf-8?B?M2xwL2JFS0JWVWxtOFVIdytMTzUwMmZac05iaGJXR2Jpb2lEY0R2eCthVzB2?=
 =?utf-8?B?QkExbkxwWm94bzY5QVg3Y2NTTGFuVnliTHJoSVluRmtpbXhhWGk5aGhCaVJo?=
 =?utf-8?B?L1FmTDN5VnNGeXNDNTk2dFVOOElFTS8yTXJNZ1BkNUc3akQrUjlqUXRTTHhS?=
 =?utf-8?B?MUdMd2daRTF6enFOZENTOXErTDBZVWFUdHg5MFBBeks3K2FrMlpMWm9DeUNI?=
 =?utf-8?B?YkpNY2ZuQXVlMWQxUnE0YS9qWEVTalV2ZDlCOERnUXVwUmNGY3ptOTd0QS9B?=
 =?utf-8?B?Tng4VVZHV0xUZVcxM1hUSHhUSkNidExSWmg3b2ZBR21yVHBnSDlFNUVTMTd6?=
 =?utf-8?B?NDlsL1ZtNlFTYTJhVXEvdzc4Yzh6S3RaWUZxazVhN3BjeTVGUzNOMVQxbWRN?=
 =?utf-8?B?L0kzZlhySWlMRlFtQlAxTVFaUXVZRGRIVHdid1BLT2VyOHlFVnovZUlmQW5L?=
 =?utf-8?B?UUV2dEVlbEFVeEorTGRZTDAwbHMySkt6MWxuQVpLL3RzQ1UwMG13b25YMG84?=
 =?utf-8?B?OEVnQ2diMkc5em9nM3RLajdqanRZN1lrSzVYL0lQTXhmMWNsT3BQT1Zwb01p?=
 =?utf-8?B?YWQxbTlIN2NIRUZoNHF4QzZTM1MrM0FxOURWTXVDY0cxQXN5UWwzbldQNHRF?=
 =?utf-8?B?anhxaFRYcnFGdjF1bmx2TE85S09mZzJKOTI5QjBRMEpSeThrWUJMajRWTkpl?=
 =?utf-8?B?endNUTR4c2dEeTNLL3J0QTcwM1dSZ002ei9RL1BkalZ1alpLdnhXdTVCcnpS?=
 =?utf-8?B?OXhTdlYvWEhtK1ozMHpBMDZFMmVSbCs1L1RjcmZZVnNjWVI1cUJSSFVNTkd1?=
 =?utf-8?B?Vk1kbGFHZUhESTIwRWFGNkpSNVFveGtkSTdLclRweXhVVkVtVFo3MkNzaE1m?=
 =?utf-8?B?YUZ4RVp5K09VRzdEMG1hTHNndWxPdlNHcnVBaGZkcE1xMU9VT2p3alVGc1F6?=
 =?utf-8?B?N1NCTk5IN2NBZ0VaVkFoenFQMmFNSERJeVdOSnE0VjhTb3hvc2Zab3lqWFFy?=
 =?utf-8?B?ZE9ua3YrSVFQbHlrMFhlUTM3T2JDSFB2UTl4TW9wOGE2TFFqM2RPSFZWNFFr?=
 =?utf-8?B?REl4bXNSS0JqUzltSDQxTW4rc3hLdTlXNEdqM1ptSThjbFBVOXhnWXdLZFNq?=
 =?utf-8?B?Zy9kenByN1NyZG1BUkJlUXNNaHVuaXQxMklDd21DSlpWVzd1MjU2MjZMMHM2?=
 =?utf-8?B?K1JCS212dDJpZTFrU2NjQndVQUk5YW1hZFpTUVF4eFhpcnc4ZkIzWVFhMHR0?=
 =?utf-8?B?amFUU2NHNmRlTGRCQnQyZHl2VDhkek5VbVN1ZjU2L1RmR1pQa1hQWi96dDNS?=
 =?utf-8?B?RXBlb2ZSZmtJMDBQMWtsOVZ6V2EzN3ZjY0Rad2xFcUxZbXdBelNyNFZFN3hB?=
 =?utf-8?B?YmNOZko5a3h0TU50bDNDb2hOeTNTU0FQcmJVK25pZnB2emEvSjFnKzZhdFpC?=
 =?utf-8?B?SnpIdVR3bjcyU3cybDZJcVVrdmhadFJxeE5jZ3E3UzQ4ck9YWGNOcHNMYy9s?=
 =?utf-8?B?YWtjand4RFFUSWUyVzFUTnlNSVFwNVMzanVEMENrTU56QkFoTEI0M2hUVGdx?=
 =?utf-8?B?YXZibVY1Tm9mcGlBaVlCUU4ydWdxTktRdmJjYU9jV0UwTFd3c0xrQlpPMU5w?=
 =?utf-8?B?KzZkUDdCZ2VncHIvcll0VjF1NWFXRllqMzRrQ3JGZ1dZOGdUWC83Vk5BU0M2?=
 =?utf-8?B?dG9pYUx0dXJtRXBiVVNrWjZSMlIwOUd3d0drR3BNZDhxNnlaeXViUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6f72bd-4979-4e96-f078-08defd19bdc8
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9670.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 11:13:33.5493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhtUYqtzitdNf3RotO4kXB71xwqFiquvKLjbqG3Z+7uB8UUCeL9eSiTCqnT+iqIL63SkaU4ZnMWq4lLlwWGyMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5655
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98C8B20002
X-Stat-Signature: en5swzwspnzg8igbe87ty3ce13ngtqyc
X-HE-Tag: 1787051618-727080
X-HE-Meta: U2FsdGVkX1/mGZ5Uj1OwTW14hbFyUdbUnRNSX3Kq8XKCYc2UwNQvXfoti+NqQ3Cs1OMdPQj8m8WQO6lQuswWoRfc6CJFtXA9s4DGnA0E0YFsTWzq/wH8JDxj6p/W98DDND/tdWV9VWEvLxCJao+OGzgXF3C0zfv8WUEEJwN5TajC5o86IoJAE++clJ2MAYL6Xbvz0VtgTwp11115QFk0ZF0U0Csyb8JpxzpnZadXyovDD4aEiR/7lcpaeV9BxePbHGMb9e1/j5uQuw2luBzE+cbodp7qaBR5Udtm/Jn1Imcc912X67PPylQCFNbtb/Bn8HFT26ORLQJ/T1Wl9O/rhL4oc86/Qp9jSFUznvZM+A0DyFrWOmJlMf7bx0Pff/xdzsAxHbWWdopxIltr6QpNz2sW1bbVQIa9d73v0yMizD6qsqUWhyf62T8/FE6QLBtYHwDNnbLqcQ82jtXmn1306jVPoILBkTqqHCA5qFQk8vxZCyKLxN6BD9kvV0FYOYebiIRU8z69g+i7jAYIWqtxssQbgPYZ8f/VZaexLy/kh6CI6cj5ANeRuvxF9tn008sHURFTz0OPb//9Ek2TTLkwogs+62JejWD4WD5DetJ6nbxYgOtJFBnfGdN8pKFlJb27aVNsLSggIbxEdOHCPQCyDgZI3mP69iLUAJEQJbszq+dZ9qFRGr6NYHDlj2WEHwKYzkkgE7H6FKt04uIHeKAjf4j6UdXNN+ClPPFeDIGdIHen4UQjCeKK9lFPAZ30L3CbBh1oYE7rk5rsoYL6pDGoEaWPQ7iIYG2va/eUc5xiQC0/ThZvOJknPZR6BLMKcud9eSGVD+q5IZXvVHy/LGWVCFO991zIKANTBH7mh2A5CeJnMpomQNVPkzmJL3foQVcLeqkpgR60w3OrnhWzrLTXSeNPOUKx3munTf49QeVnk/ELtve0q/wtqR0d6Bxbug6sZ93ABw1eBr/mFq5KWyF
 22ShIHX/
 YOV7frqObnapyx6IhLoQKWHsy1nSWXDGL3uxoj5fMBJ4c9Rg6jCTyFEd9M3e8crUTnT3MP8pUZlTjkg/xtwRYYqwZJiTSYsdB66rXJKD8zwauGpSKpxAe4TWSg4mqQ/6ahzaT4EdRasvVnyfkEhhqaG3d4bIGUHa09MwluqZgpTiWilxxThOMOW9UMnnRd+CJMueLNHbuguCDH3VY5sVBxKo3iZPVsWSbqcdJzoqOeQ4gypOC3ofIvJcTPclfFog+U/HLi9rGzbkOOfmzSR17paG5dxFWBg6sIT3eRDreP47X9mRc5yy/DLz47g4O3jKMBEJGJ72W5QreAzHH3VbPYVdzJKxo6amOKtlxRYUEd2ZByzG18SgK5dEfdG14Nb0nzu5R1UcSXlHwId2R3q9lBxZD+7795aeujHtxvhFrMQj0dS13juK7pD8NITaY+QwdKG/wed2LZ097XnRPdhAmqdvXmUbRSedkFMsGnLmqw5VjB1fnadAgOzKlap7oRR73jhmudQ53y7/bnnbtTswOoV+YY7CANHw4w4zmVSRZoVJI5o2RLgtmTTCTPb27TofldxvIqWeowbUkUko+VRHCZ6z4X6Fno2ugWamoGwrxmOlCMVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 4:21 AM, Andrew Morton wrote:
> On Mon, 17 Aug 2026 20:08:00 +0800 Hui Su <sh_def@163.com> wrote:
> 
>> migrate_device_range() and migrate_device_pfns() clear the entries
>> following a compound folio so that the PFN arrays retain their
>> page-granular representation.
>>
>> If a compound folio extends beyond the end of the caller-provided range,
>> the loops clear all following folio entries without limiting them to the
>> number of slots remaining in the npages-sized array, causing an
>> out-of-bounds write.
>>
>> Do not proceed with a compound folio if its page-granular representation
>> does not fit entirely in the remaining PFN array. If this happens, drop
>> any reference and lock acquired for the folio, clear the remaining
>> entries, and stop collecting.
>>
>> Observed with a KASAN x86 QEMU kernel using the HMM
>> migrate_anon_huge_zero selftest. Closing /dev/hmm_dmirror0 after
>> migrating an anonymous huge page to device memory exercises:
>>
>>   dmirror_fops_release()
>>     -> dmirror_device_evict_chunk()
>>       -> migrate_device_range()
> 
> It isn't clear (to me, at least) what "exercises:" means.  Was there a
> WARN?  Did the kernel crash?  Did it erase all my cat videos?
> 
> IOW, in detail, what are the userspace-visible effects of the bug? 
> Please add this info to the changelog and maintain it.
> 
> Sashiko might have found some things.  Some pre-existing, some newly added:
> 	https://sashiko.dev/#/patchset/20260817120758.669807-3-sh_def@163.com
> 
> 

userspace-visible effects are a function of the usage of the API by the device
driver. If the device driver passes in npages that don't account for PMD pages,
it would be an issue. In the case above, closing the device will evict pages
from the device back to the CPU, but I am surprised that the size of npages was
not properly split, we should fix that as well.

FYI: I've tried reading through Sashiko's report, but there is too much
pre-existing content that it points to and it can be quite time consuming. I am
working on adding new test cases to try and catch some of the issues found

Balbir

