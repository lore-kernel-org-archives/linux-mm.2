Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310E0EE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230686B0088; Thu, 12 Feb 2026 11:15:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DDAC6B008A; Thu, 12 Feb 2026 11:15:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF966B008C; Thu, 12 Feb 2026 11:15:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF52B6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:15:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A34DD1B37E3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:15:58 +0000 (UTC)
X-FDA: 84436305996.17.D54A33B
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 711A140018
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:15:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AuomZlpM;
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.107.209.11 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770912955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1JVibKiaEJGCDNvVf9pEk5tgaAZpSx3r/5eMzq1BBI=;
	b=emUcj7YG8H+lluZuELwVUXtxBOQcb6OAETFE8BnjkxyyZNqmEsOZWfg9+rttAEKvYZ67+G
	Gpw8DaPvIJWvSNt6zUxnWxkeUPEcACDEZdqgnYoiVbFGPV+Fkeic7sUad5FN6SxyW9/Lrw
	Q/6jKw0y1ruKAghe+U7WafdM3xki18c=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AuomZlpM;
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.107.209.11 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770912955; a=rsa-sha256;
	cv=pass;
	b=YNO+erBmbiU4HMYMHj7rq1kUWTFpUfvB/McYJnyMAafqyJdx9hl/w3OOjO6OQ6YeYas5yL
	snd5v7fIu7h/8+XWGaxSfOnFsBiGtY0bDLxd56FORou0e5Z5kUAJn1Ukat4pDeOSN1lPiy
	NUR/DUL0pGZ12Z8h2T20xDOfC/GwcWM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WAqC9TjxsO0OQPvoFK26LxXtcFCNYFeDQBIdrJsJ/qa1xhr6hWZyzf9YFhWypXXkBW41h6LEWtHh52r42r23qdO/Nt+uBnblK1oNAwx42DIfxXNrtSiTDrtEkkYmUHVUMhPPUdz5HYHGajJRvt389DW44Kcj5KldoQsX3y6sii93zaEIFKoWrJkoLCjR6zm0Sk7ig6xxLWGWMgUZXo7G902qF5JzsuvzxcKKh77JrEUCQng7BPEEmkwWZDMvMvVdacV94Am7ZYXBrQpKxttun8D2JDpSN4ullPtNQtrD/+zCG54mIc9JKCDX/7yDfPRCp6LkVQy1TDUUIGxjEe8v7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1JVibKiaEJGCDNvVf9pEk5tgaAZpSx3r/5eMzq1BBI=;
 b=BIVAKS8D2oPmDw6a7QDk3qs8uRnvoKrqbzshayLbElcKF7JsNt6WrWCP9rY3XMmZkLB+S2gQGMc+M44Cww+ue+uJg6xP3igNLQomo2w0oNY80hZpUeqPo3kK77n4lph57Fg3QVJktDYDH9H+kDgOgxRxsHICsSfdLzQVJz0OLfM9Xft7f4NC6/5iT6njzWlqfCd/g5RQdZrX4w2tvtzf7vX0AUipXgAmVSELqUSU5VMKPf10WC+8Xg2NSx6l/Bp/Njl0q8ljgz33g67tYtPSN3tGjdTSznj1kYpJZRmdSWrnwTYSCPeyVNQ4kuyDYwjnjEN1R7lz48kn4WJ2GZBnlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1JVibKiaEJGCDNvVf9pEk5tgaAZpSx3r/5eMzq1BBI=;
 b=AuomZlpMcXNh4MLQKZM4D9hTEqx7DkafGJLtYarD15Mkdm8u5MucUVgVSCWjhO0kAvJQaG3c+wBJvLF6vusj2n9+Q7dxi/MDmc4gdO0vOWp6Zg1OV1aDQGNfSjMCDO2cVk024HXdHWruC4w6wRtLdVERj1/75MQgRWXg9q3/NfQ=
Received: from SA0PR11CA0132.namprd11.prod.outlook.com (2603:10b6:806:131::17)
 by SJ2PR12MB8781.namprd12.prod.outlook.com (2603:10b6:a03:4d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 16:15:50 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:806:131:cafe::18) by SA0PR11CA0132.outlook.office365.com
 (2603:10b6:806:131::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.11 via Frontend Transport; Thu,
 12 Feb 2026 16:15:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Thu, 12 Feb 2026 16:15:49 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 12 Feb
 2026 10:15:48 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 12 Feb 2026 10:15:40 -0600
Message-ID: <aa3736ed-1a07-4d55-b9ef-734fae02daa7@amd.com>
Date: Thu, 12 Feb 2026 21:45:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
 <911f316b-87cf-45eb-8d9e-412473d7176a@amd.com>
Content-Language: en-US
In-Reply-To: <911f316b-87cf-45eb-8d9e-412473d7176a@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|SJ2PR12MB8781:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e1b62c7-93e2-4f3b-50df-08de6a51fc85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVo1ZGJ6TWJxMTNqNjZBa0pwZDZzeGpsbXo1NzkwRFBnei85YWxIVjhYNk90?=
 =?utf-8?B?ZlZqVWJuYmdib2xHbU1xZGovNERtQ1hGTzhCQ2x2dm5SWHhDMTYvRnBMK3Y0?=
 =?utf-8?B?ZUlNelZSWmw0NjIwZTkrMXlpUEdseVRJSk1idCtLZ05lU29ab2tZK2ZsbDVD?=
 =?utf-8?B?QTErWE0vYlErbExkajV6WkhGRDBzN29CMVhTSXNPRGt5UmJIUU8wTFo4NVdH?=
 =?utf-8?B?ODE5cVU2SDNRTE5IOTIvdnAvZEd4SG5NZGJYMFl2NGIvb1Jzem1OWTFTTkdK?=
 =?utf-8?B?OFN1bzIwQTI1dU5rZlBtakdCRlZNYXdaK1dkcjU1UEFpUFkxeCtNTW1jbWxj?=
 =?utf-8?B?ZlphdC9Wa2U4ZTgrYWt1QUhRdjFGRUtJcFowOHNOY0hCNlBtK2s2ZGNYOW9i?=
 =?utf-8?B?SjBRbDFWVjRpbE9DVlFHWWIwM2s1b21BcTJvdTZzQTNkakFXcUkwYTB2dWRt?=
 =?utf-8?B?WjA4WW9QaG1LODhDQ3JiQTBmcWlZdTlPcktRcGpidjcrR3FSeDNJQ1NQVXJT?=
 =?utf-8?B?Q21HNUFTRHZYcGRtaXB6ZnYyTjg2NzNJU3E5S094dnI3dWdpUEFZTUtZcEpC?=
 =?utf-8?B?WnhXSk12a0xxR0JJTVFPT29Cd205Z0R6dC80bWhqVkxxNEY0amU5T0FwN0o3?=
 =?utf-8?B?d3p5Z1BwMjYzZFV3Uy8rbXo1NWZHUXVwdjhPc1dXZTk3TnNZVjNpWnZyYXkz?=
 =?utf-8?B?SWtoRnA2dTA4c1ZpYy9PajhSd2tNaGVTN2lLalMxY1JnT1VMVGY0OHFjTEov?=
 =?utf-8?B?REZzUUNiRlQrWTJnTU9GSFhRYXJ0dmF2dXd4MzZRME0vTnRMRDczYzNBdzFT?=
 =?utf-8?B?K2RjYlNzcGpOZFhvT1JNK21ySjZnWFZQZUxDekhscG5LOGRsMlljSEt0Wm5Q?=
 =?utf-8?B?TEh3UjhjbjEydDAvKzAvSlhDTHNsTnZ3dHdHbEpDNmRVaml1MmlLVXNKS3l0?=
 =?utf-8?B?K1RVRDU3aFNqNnRja3J1K1J1NVJLalJESS84dzhiV3VIWm9KcEU1bkV5aTF3?=
 =?utf-8?B?Yk9iSmVCUnQ2M244MTc5endxZmJpdTAvVm5od21UNlRuaWRkR0s2WGtvQTNy?=
 =?utf-8?B?a0ZUSTF4ekI5VnZ6bEhBMzlrL0kvYU9ETm42VkZTNzFqVG9RMmx4Q053SXRP?=
 =?utf-8?B?RytlclJTajNPay9sUUhUY3VNYWNqejJpR2dPczVzZ0xOR2RJK2NCMXFHUUtt?=
 =?utf-8?B?bitxTTZoYUNWSE5JL2lpVVNRM0xlTGczRDc4Z2Vtc2FTSTMxUkQwQ0l1Ym13?=
 =?utf-8?B?dzU0K3NsSFhaY216ZTkwWnNicjdYZEpHemYvWWNNRGFkUmVxY011bUs4dW1j?=
 =?utf-8?B?enptZFlISVYxTzcrSkhMRW1seHk3UVo0NHdhRUVxeVVqejlVNmlyMm9YOWlm?=
 =?utf-8?B?UlpVdVhxeG96QXhqNmJ5YVA3ZVpOMm1xNGJJU2dVc2N3VVREYUVPR2RsVnpr?=
 =?utf-8?B?cmRSLzREeW5YUDdDWEJacmtPRW0zTmxDMU1JY0xFMUlxL1lmUUhDQTJnL1RQ?=
 =?utf-8?B?d1d2WjBNdGI1S3AzM3d3R2txc2dnNkJweHFhbGg4Y3VaMVZVdnoyMWRFZlhZ?=
 =?utf-8?B?ekVXVlJ1b1dvWG1pVldBWElJb1BZcXBVeTBXV0ZYeHZGVjdOZ0YxTWhkL1p1?=
 =?utf-8?B?YnZPMjFyYzNPalRuT2txeHRESFlaaDdtVDU5RnU0SEdVMDZsZ1ZIOVdTalBi?=
 =?utf-8?B?QWZNR01iblV1VlZweTZwejRnVnVPQkJON1doMCtoVWRYQ3hCaTFYaDNGN1A3?=
 =?utf-8?B?MEdOTVVHYnRDM2hWaEtXV0hxd1FYMkZ3dXlYbXVYbUpHY09FaTJ0dXJaV3ZV?=
 =?utf-8?B?dXpzSzA3UjE5UFNLVlVtcEQycUFtTlVjZ3FKSzI2WnBVMzFrQ0gvM3JYNVJu?=
 =?utf-8?B?RmxzY0pudjlIcjIxc05pckxRMUpDN3JJOW9oZDA4eHNuMGZEYkxsaWJwMWJB?=
 =?utf-8?B?enkwRGdHRXR3dU9JZ0o4alQ3MFA4akFlWVJSdkhkYTFYUVNpM09EdGpOQ2Fl?=
 =?utf-8?B?THFPWG10cDZVdWJJb2kwWHFET0lydXlHTlVQVGhVQ3U2YmtRZWFEamFBYnIz?=
 =?utf-8?B?Tmt6aFB2dEhXTE5WY3RKRVh1Q1phVmNTUmdaZlBXSXlnQXlJcEVDVlp3ZE9o?=
 =?utf-8?B?MWNUelNrTDJGbmhRVlpHblVCeHFPMDNuTERqUHFLSENNQnNIWVJFVTd0Z0tx?=
 =?utf-8?B?SXExWXhQLzdEQmkrZUJKTXpWS0NYODB0dmErSUV4a1J5enNmMXlJd2pHWFRk?=
 =?utf-8?B?Rkp4OCt2YTdHQWx6S0k0eWxGWFRRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hu9UsgPtvwOjcydkntWr7jszBJgCXD0nQqgjq3iOHiX8AwChVwltk5aNNoz26af4Bv7z9m/Iu+laOfwZKpbmpS/MtFVBZJOBob1hUPXvFLsEOyGKPTgWfdsBDFMj/KTlkucEMpbf5scB6U8ghjc/KQhxTOhR4g2z7ZM0gWdkX/l39NYPN1Az+50KvYa6x/OkJf/NgzLe+pUMCHNjoJ8z8RuUf+1C/Ih1uKFoG3LuUF+9t09DXgl5cIA4cPTVMRlYZxgll4rKpZS70VaO74LFYt0ErmjjG5Elb/00aVLE0XUhl9r3xPgk5B0dnYg8NL/HV6/UoVl2WhzKMkR+AO1VT7uh5FpNS/gAH438jc808Bb75jyMNVfbPCpo8sSk2/4y+zGktBg+IngktLkyRlY/G5rX09DP3mlmU7hTl0G8fVQHeKz9yUmTzQpMkGgbqTRl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 16:15:49.4028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e1b62c7-93e2-4f3b-50df-08de6a51fc85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8781
X-Stat-Signature: ntytdqgtshihg9o4bqsutshqw9u84ubz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 711A140018
X-HE-Tag: 1770912955-265945
X-HE-Meta: U2FsdGVkX181jWN3UgE4vyB8u33twJSiLqMfGzviFKUZup1fb3r0e8EAnAjn/enk+4SOl565/Vu8st//zEXXzWm0ubwlth8DRjIywdb3hfyZFVtYur02bvVq7ht16MIfKJ5m1YA0QPZx5TX4YDYe0a8oCV2Ggny+VrkTsO429ZQpyIBYPwFsTCw+w2jEdFidr/+vuZStG4wA86874VDKlN9C7yT3XmZunL6LyRXHB0AAUfk4Rb392K5/RiAf8AAHPJ54Ju3aW2msBgX7cjNxMc3eL1xgdNoQ3b6WzZmKChcGXKnUXUVsOo6/NbejeXguEsWclTLIKJ7YYLrkIHQi9ToYJO3Rf6wMeVCVG9o2FKyuHN37xFZho5r3l8LTa5GebDQXWwfFKt3Z3zDA7tnoHdjN8dCWi7fsYTnl3N+tDmFrZvTDubSTvsnOCzsehd1Fq7N/3CKQv7mIwcwQUOKUO3iAXr0WiWwharoWC1e9BEr/+p1FYOSn/N2xJaAF0NL8jNNX4dPzN1RsyB/sWA6rwQRoGlB3xBBqXGZ3FKgKvVL9OIG0KlYuAA59Rfbbk/38E4eOIgrnoQJw2BAHsqSiioCZyRGV4Ogq08v4OeU5S4/HvZM3FTJOw6zppwALomt4VIwikTgxb6duLfIBalV/sqRwNUBA/RawjZLaDYEy3VLXAaB32ke0gCTRdQSrEFHgxd1DIl/HVJRuWnAqA5gL/ok+QLfPTkhy8EisSNRfcLDKKoxRedzpDDqaTyMZ67uKUS1nMDh/A0MzYjfn0LaqvjuDhFndRBgCmcAmwDVT9gvH7N5Aont8tQoaTvdqFOQ6OFsDTgGipu3SSEwjXN5e8XMwXQWyGgcSO/QhuUi4inbcC0kUeTw1SG17JKmtiJzZ2la+QWJgVCS7FSg9B7mSfGr2W//escp2E0RVr+piHVphyAwkrkaT+kWpp+XHjATllmT3G6WIVTfkS1LwNhv
 Q0vxA1xi
 ZK0TLIibGDuxnvswM4v4m6LUtNCOD3ooUYu9tnAzI6Dh1YS+BCiJK3bCrI9r+iLp6Q7PamVm4gCQleb8KUFyHfDfDIMBYZmsxHP5hQhZv0ZMRiEIolJWFHWZ1xj1yquse61e9wgpDdmHxEXvxqfQdRHWWJQpBsZVCZzQMYwRZp6FAq6y28+/spser0u1dS5DPKA8zP7gKDRShQEWl+sLuxskFcWK9+1ZeVXakvDMkZoBqBMl5J+Rhn6w8GOR3glJU/QJFs8/O3glt+UQ4SSZtU3r4uLXqscX/s9hBBo8u8Tk3oqvuKFyRfv0o50SqU4k8iiOItkYzhMeqjiEk4Aq5K9CyXG4/qkrg2TM5N5ErVGSLYvAKjIhihxS7Ntu9WionXOVnXwFJxj890i6OLbzy4PwqoRpysB4UnannkddKRNA1QXeJWeUC3jIQ1pqIMtcmlvXGp4BQyv3YwF0fZDDrOJS2sioa/mFADjxLnzlWB3yAZAk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11-Feb-26 9:00 PM, Bharata B Rao wrote:
> On 29-Jan-26 8:10 PM, Bharata B Rao wrote:
>>
>> Results
>> =======
>> TODO: Will post benchmark nubmers as reply to this patchset soon.
> 
> Here are Graph500 numbers for the hint fault source:
> 
> Test system details
> -------------------
> 3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)
> 
> $ numactl -H
> available: 3 nodes (0-2)
> node 0 cpus: 0-95,192-287
> node 0 size: 128460 MB
> node 1 cpus: 96-191,288-383
> node 1 size: 128893 MB
> node 2 cpus:
> node 2 size: 257993 MB
> node distances:
> node   0   1   2
>   0:  10  32  50
>   1:  32  10  60
>   2:  255  255  10
> 
> Hotness sources
> ---------------
> NUMAB0 - Without NUMA Balancing in base case and with no source enabled
>          in the pghot case. No migrations occur.
> NUMAB2 - Existing hot page promotion for the base case and
>          use of hint faults as source in the pghot case.
> 
> Pghot by default promotes after two accesses but for NUMAB2 source,
> promotion is done after one access to match the base behaviour.
> (/sys/kernel/debug/pghot/freq_threshold=1)
> 

These numbers are from scenario where demotion is present:

=============================================
Over-committed scenario, promotion + demotion
=============================================
Command: mpirun -n 128 --bind-to core --map-by core
/home/bharata/benchmarks/graph500/src/graph500_reference_bfs 30 16

The scale factor of 30 results in around 400GB of memory being
provisioned resulting in the data spilling over to CXL node.
No explicit migration of data is done in this case unlike the
previous case.

=====================================================================================
                        Base            Base            pghot-default
pghot-precise
                        NUMAB0          NUMAB2          NUMAB2          NUMAB2
=====================================================================================
harmonic_mean_TEPS      9.28713e+08     7.90431e+08     7.32193e+08     7.81051e+08
mean_time               18.4984         21.7346         23.4634         21.9956
median_TEPS             9.25707e+08     7.86684e+08     7.27053e+08     7.82823e+08
max_TEPS                9.57632e+08     8.4758e+08      8.22172e+08     7.9889e+08

pgpromote_success       0               22846743        22807167        25994988
pgpromote_candidate     0               24628924        29436044        27029173
pgpromote_candidate_nrl 0               140921          220             38387
pgdemote_kswapd         0               41523110        45121134        50042594
numa_pte_updates        0               121904763       71503891        68779424
numa_hint_faults        0               81708126        29583391        27176332
=====================================================================================

- In the base case, the benchmark suffers when promotion and demotion are
  enabled (NUMAB2 case).
- Same behaviour is seen with both modes of pghot.
- Though the overall benchmark numbers remain more or less same with base and
  pghot NUMAB2 cases, the number of pte updates and hint faults are seen
  to spike up during some runs. Yet to understand the exact reason for this.

