Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761B9C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D6E6B010E; Mon, 21 Sep 2026 07:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB396B010F; Mon, 21 Sep 2026 07:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC7F6B0112; Mon, 21 Sep 2026 07:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 465AA6B010E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:05:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1F2380149
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:05:23 +0000 (UTC)
X-FDA: 85237488126.06.FCD66F9
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011049.outbound.protection.outlook.com [52.101.62.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id D958380007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:05:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Q/77PTfD";
	spf=pass (imf02.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.62.49 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789988721;
	b=4IZ8405TYwkKGjMKPDzC2px9C+WkaF60EniqFgk7yMMg4HW0O1L7sSuGscUumGtHPPuywv
	BsooNaGE17SGpNM6D2JHtlxELrEB2+lqyb5zPc74QKfNLqTpzfwaLcTMgUj3293gHCB7l7
	dcdnESaA5uGuw2KAg9ISY47b07NKzbw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Q/77PTfD";
	spf=pass (imf02.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.62.49 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zu/eVncv/yvLsWTBEpI36HkuAh9Agzp0WaiR5ddGahQ=;
	b=YYYZH2imkWpt2hKY8ZBpMzkAvZycrntzBxZMIhh3+GrtzTybZh51L8UtEvD4JVEU2Hkkmv
	NcXb8Z612RQ8kBXLWBlrWMt9FjjF83R7/jJWjopthn18d1e/gHIKGg5eHKXwS4pRU2dmpl
	ViNoNSIF4FbpUl4dNQNIcfWTq4gKpDY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AIMr0ERwAi+Ca1aNYEZw0UoCk2QxhCGUYYh38AiNXr6Ty7v7O9fWqufTl0u7c9ob5DUex5RXqjEC0zLJ8ul6Po75wtOB+V+JREP8X72OwFUhk1N2B5fWpgTrbJj33cjQBvnjPbr7o9Oi9OWyEqsN4+yeMAB4n2L0sJ+/ydxwjDnD0heM4tzJDFiWhsqH1wKZg8ha1H2XIsOoor9Dot5YccSgu0NeXg4w0kyT5jbyrGPBAe2NZfEi6HVwEzIeo4PsdyQjoGcs9k0YIrl6FS7Kauk4JnRkirQtbqJ6j4hTHR/flEeebLmY4leWeblzc8Q2Q4P/C4mcOyt+lf05aa6tPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zu/eVncv/yvLsWTBEpI36HkuAh9Agzp0WaiR5ddGahQ=;
 b=tXU3jSi6AoQuaaTUk0ErS62FMfL8LtO7c0rsTcwNOykUl40CsHh+DRmgu44TrzWvBzVIDw+3Z5220cXSfXE1tf+Fx7x2misAWwQO8dQqHrRABjK5tzh+uBBQFMDtl2Cb++Z2DKtEOMBJEe4/Au6KEt4uyGPDXS4W+J7AKxamvdQRuI+LiFEq07mTdHEABZzROKwgT88ahF7W48/FDXWYI1SepksGOf8lEKRgYpu1ei75uowAbkNQTMsVk//OzhXKhK9CJogUH/pvRZ5SVsh62A4cM2P8Vrh0wHSSwe2LZs1jp8S8qJnU7xeZ06TTPdz0ejrSBGrmFxSSU5DT4l38jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zu/eVncv/yvLsWTBEpI36HkuAh9Agzp0WaiR5ddGahQ=;
 b=Q/77PTfDbCktygNrpNxaoFyJibL3Y6XiyFt7lt2YJpqW/WE1LKyLPZFup0/1okockGw6KbPOXNIC40rsxVgl5+T4t04GqstpaFlblR7eEiBGiGspSodXGf9BmQr7g05nkXoqz6xt5aGmGzz0UAS18exQ8q+miRU1D2+cpaszyt8=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 SAWPR12MB999165.namprd12.prod.outlook.com (2603:10b6:806:4e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 11:05:16 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 11:05:16 +0000
Message-ID: <d50d001c-f71e-41ac-924b-3de5aac2a89a@amd.com>
Date: Mon, 21 Sep 2026 13:05:04 +0200
User-Agent: Mozilla Thunderbird
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Ira Weiny <iweiny@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <4bc1f4de-40ad-46f0-8d37-4c4e0cad0ad6@amd.com>
 <8EA6782C-7A3D-411F-91CD-031AB97CD024@linux.dev>
Content-Language: en-US
In-Reply-To: <8EA6782C-7A3D-411F-91CD-031AB97CD024@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0033.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:17a::16) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|SAWPR12MB999165:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c3a2f1a-5c82-494e-628e-08df17d03767
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|11063799006|56012099006|4143699003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EmFY5bu9d8bk5NxGVAWsPbjh6ljZuySVUOMoQ96DXGP5ZCdcU7aY+F8uY0NtHKobOKftpEaE8Uu03/iaZSiDNmXwinrpnPToVDqO1afNqxzO/MnpNLtJooxr0yx9VU6EcBCtHNZwM7RGiJUU8sCnxtvqTrdKytAHPc1J0025PFFmztd4PmdeRdi+FArmYLrdg2dVCSMAXPk5ZaSpnfwAR7RtHZfoH5lNVp9qpI1+bDVz6dUqfK2PEsMhNq7rEkE3FSot6ebeuKQiwOP5N7ZMf0A173C1Z4pk7Rtre3ZqQPNLbTa3HEqZO2/oFVlrkKHrDEo2Q9dVBLXuTuWbbtY2/G6pfg2o/r5VX4NtLNtiSknfaSLnha3SgA40kihmq5UhigL41Yg6tSOuuogZBhZRB49pUJHHxG8XSZzqw6++ZvQQuzBbuAV/hHn8uF9H2oviZFUDm+A/tUW9T4HuMoe6Os9VnvktcHRQR2l5F91185js4lh6dc+1ynslw1IjyheO5CQScCuPoitPb5qRnScXZr6Q4pIRner9RSe9T9MU59Gi2YlXenxIg2wJfa7aR80KNFY7aFVmdSVg1M3MXuw8KQUcXpeJL6O8lB4htTdizYbNKrn9zNGSH9Cn/QjKheVQ1UafciJoWdU6h7rEgTKnjXkikpdQfstgbRUpI/zrLdc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGVXa215d2c3bExIQmpuM0JrMXRnUUxVR0RUL2I0NSsvUGtYVys4WUYrYWMy?=
 =?utf-8?B?Y1ZOejhudjRxMHVNd2pVeDEyb01ZaWdkQ3RlWStFSG1LV1lmK0tpbXZZVENl?=
 =?utf-8?B?VExEVFZkZXJTZjA3NzIyZ3BIYUFRbGx5eE1VSVMyQUNwSU5lblJFYTdtZ3Ji?=
 =?utf-8?B?OE1DMFFtVUtRSnhXcjJ6TXB3M1VXck9oYXVjR2RweFcvRElkOUJRMUpHd0FU?=
 =?utf-8?B?YTBWaUFWdDFLUWZRYmhhMVFQL3lVeEZZRHhJUVA4NU55N3VJa1ZnR2lJeGYy?=
 =?utf-8?B?TmdwMDA4SzZYbFd2a0RBYy9HdkJBY0szMzhtUnVCSklyQm1CaDJIWUVRbEk0?=
 =?utf-8?B?NXR0SmpqWGsxRUp1T3RQcFlTV1djbmFCNWgxcXdvRys3azcvQzk3S1VxUHFz?=
 =?utf-8?B?WGpNaHAxVlVYYmdSU29FQlVlYU8ycnE0T0Qxek1yZHdQeGwwM2ZtbFFWd3Mw?=
 =?utf-8?B?b1JPU0tkZlF5Vk5mVC8xajJWandRdkpyTXdINmswYmM5N2EwRkVVRjBLRjNV?=
 =?utf-8?B?RHF1VjhBWkRtSHJHM0VKem1EamlIeFVvNUhZV0ZZbkpaelR2MFM2clQyNmhO?=
 =?utf-8?B?TVVQOG1yWG9Ba2liUERCbFRkVlloMjFYZ1Brc2FtVUlwR3NOU2J3MHp1NEhm?=
 =?utf-8?B?RmtWUDBURjQxQit1bDZJdmlkKzdEV0ZlWnc5aU5EenR1bVVISG1yMkxGVk1H?=
 =?utf-8?B?dnp4cmFYUXZqNkpjUmg0di8rQmRYZUJWQ3hzMG4wRWVBMU1laEF1RDEwZ2Nu?=
 =?utf-8?B?MlRXeUp0blNidmxIUStlUTg5WDJqSHU4dEhMWVFLaVAyUTlBMDFXakk5cmhT?=
 =?utf-8?B?Qkw4S25pRWpYOFRlaVBaaXc1TGFpbGhiRjd2NlRpbnkyK0pnVnc1Z3pNQUtk?=
 =?utf-8?B?anduNUFrS3ZxK29LdEtxY3dYcE8rZ1lDZzI1RUF0S0tONldBcHlXbXkxdVBZ?=
 =?utf-8?B?WGg3cER6a2luRTNkSFA3RllnWlZSTHRxbjdkNnc1NE8rS1hYdUxldG5WRS9k?=
 =?utf-8?B?enBYd0ptOEpNQ3h3bjNMc1BCMjhPaUhsbmduSEJ6TmQ0RFJtd29Ia0ttN09M?=
 =?utf-8?B?RWp1Q1NaejQrRFgwOFlhdDBkUzA5c1hySGVxSjAxYnZ4K21MSGtCZnlTT204?=
 =?utf-8?B?UHRPcUVpTFpNMUo3OElCMXMwRTdBWnZXL2lBSHFhRVpWMWtwbnBxM2JJSDlE?=
 =?utf-8?B?alY0Tko2dVZHbm84dHBtVGdiSVZtTmhiYnU2R2paU1N3RWhiWFh4UjRLOXRI?=
 =?utf-8?B?OHBCaDFuckRhS20wd2IzV3VSRTQwYzY0Y1BSUGl6TEw4TXNFYjZXVjdrUDIv?=
 =?utf-8?B?U3JCWUt3aFFWeFF2TDBweGpGM1E2bW94OUEzL2dvMGZZMTRkMVg1SHN6dVNG?=
 =?utf-8?B?dXMzbzgrSTBmTFIwbUpSZWFscHZScEZpQTBITUk2K3pTZFlZdGRUcVQvTWha?=
 =?utf-8?B?OGJlV1doUTA2QW9rL3dFdHgvT1ZPNEQrRWFRZk9RaUl5bHNJZVNzeGVQVkZR?=
 =?utf-8?B?Vmk0Sit6YW1wVUk2V1RZVERDWDdSaThJZ3NhMVBoc0J3UUdpaVpjckhOU1VV?=
 =?utf-8?B?b2lWTWRLMjZLdVBkS0xpUy9NMkhlcE83TzRBSFUrRjkzNER2YXRyOE1Cb0k1?=
 =?utf-8?B?SG1CVWNvcW93M3RWc3pBVUhoYlM2OUJqUjVnNVRQK0s1YzdSRFdldGJBNTIw?=
 =?utf-8?B?VTR4UmJ0THNwRVp3Sm1hQmFRNDA1SnhjUzNNSzFvWGRybVhCanJScnM1Z2xr?=
 =?utf-8?B?eG4rekZFaHFzQnZrRGszMVYwSFowc0QxbDFPRGRJcTQ0d00xM0o2OEVXZ3du?=
 =?utf-8?B?T002RnFTaWFoVDIvZXlOV2dmSG40aDZUUGFjU2xFVUdOMnlZc1Q4SFNSaS9v?=
 =?utf-8?B?eDhISnMraEhsdllDQWZWeEhiWWEzTGljc21BVEVLQ3RBUW5jWEtWZWZJbk80?=
 =?utf-8?B?QW85R3F1SytVMHFobUNmQTNiWTh0RmdkNCtockt4Mlc3QkNZUE1iL2hDRFFE?=
 =?utf-8?B?VUNLTjAvbE8zV0FIMXFBVndzVGtJcUZRNkhMQTU4emVFZHlSc1ZENWY4VnlO?=
 =?utf-8?B?bU8wTXBjZlc4Z0NCcUpLLy96QUI3NDRBMDhvcEdRRVFjTTQrUmxWbllGUXVR?=
 =?utf-8?B?MWJoN2F1NGRFZHJKRVBsb1N6N2JQa3FwSmhBYTRRWW0rN2x0RDJlR1MyYm1I?=
 =?utf-8?B?V3lkK3JVd3BrRFRMZXhxcGpXWUs4Rjc0VWRjWDFwaDk0ZzhaNVBVaExNTXpz?=
 =?utf-8?B?RUZZVndiVDNGVWQ4dW9iYU1ybEI1aHVqL2ZBQXJPeFo1ZEpRd0ptRzk2bEVt?=
 =?utf-8?B?RzhBYmFLYjZyYkpJWE5jaHhsMTVROUgrY01XSER0L3BiVWtZQ3ZQUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3a2f1a-5c82-494e-628e-08df17d03767
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 11:05:16.1433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7okIOoS8dnd/nCFNjl5SiCH5j7ZqJ81rNIXUww3XGzy4O2zG5+rSms8GKlM20R9t5nHyO3Ajj8cyHwtivujj/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999165
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D958380007
X-Stat-Signature: kir6nedz1nyg3i565z7m4juj6z6xf9qo
X-HE-Tag: 1789988720-650981
X-HE-Meta: U2FsdGVkX1+AnSjKvlENewwIq1niU/CDFWiY7E1YEjrlsL6L8EK1dcv/oC5OBcc+XoIaUM8kbDYkKQmwd+s8Ky7dPwndKaL5x7UKme74WjibTJuGy/ag3/iC0SuuzO4n/MFbCPHqEcWE1NCZgWw/Qj+Yp0EpJN7lvFkmAHrKvrJkVztStA9xeFBnTSvpLShCnRTZmfTCWMEp38RZyWxAbm8YYUKgDLgNMGfUAELIXighOO2MTXqbmMReMnjcLvgWWxN7TzFSYvv3MEA/hp7pW8OHQJvjPkBgE8oAeeNyq/VuaLS5Tyxp0MiMmcij5szxavaCAp+Pa+4vy+GQwuRVpbDBKsHdotwyTUOKC8OpVZaqU1BGYByI7I5vgxOlZsx49cqHkHC0NCLenVwxpRNq01CsOXmqpTC7GFi6bsjZGpMVwInAyxFzFfGHSy0S3bimeQwdN9HnSfYxhk6dLeroZrk0QWRoKIszMJ22mgdCy2MWqOZGtemqQCqF4kRVw+tVmSn8sxIwMnSfWeda4V5Z4VHDTAX50daZZuFS+maNbSEbX/HdKNojkV1trMCb3H4q0BeL6s6+SWqTbkWLoOb1ZaLKdSa+OQROxuHlIa+trvDKIpWnxsrf4TsH0JU5Y7ofSq6wRqnQURtCTBaWjQ3dEhFaZeZB/EPyU/aEfs4l+92IUvER7Ot7xmii1IVXlxxXPnNiu5WzP7mzcirXMLEvDinb5AXaF3Tbvev1tycVpb+V8twqjtJjZPX9fZ6YyKOTdXt56TWJD8lsmR9aeelhad6sFg1l1ixJv1CHIk50VUUt6SHSupf1xi5pNxf94jlnmCxf+tLu5MMAz5L5CHiXV43QojkQUAfQmofayEYmtQsZ2oWfo27KJqVSvlgVQ9/7N7ZGTJv8gPj1NSpbztsr20RVBKgH6F6891HWrEU9QDDWiSc74Uca5121bXg+xtMkJeR/2yYQLhIU6xKsyTp
 me4tszpR
 pspG9vSUH/RvrpTq7iJmSzKNcQcKAFH18RvfCu+l78AKuhvVzxXdvk0P9nklc58FCg0wkhwuMSsGTehzqc61t9q/dOnD3JZ3M1/9YLetfYJn9c5z/uumxElhDNPUgKHKFwTT5CiHxmrYSq1g3+BcDGfSIo8Hg1fWYFOAaPIUx6WC/zVW4X86ykrIWR6/mKcGrGQbGVqI6r253wo6SccuLw+L4HGKcbT1OoRV0bK/G8VptYCD8E5jYjT4VXeIzHpLnLfK1AdFNU+z2SByuGQ/W49/g/GUWuBzPuNu+VyYIPd7iWm/rk2evRqAlBIzVzGop5brhwpXmh2sZS7UaKpt7jDkhDHGFtFGOywYtVZp912YPIvUQx2aalKACmdIb3zB3cqyp8qSAbfcWAk1asF4rVdph1D1OyP42jdKZRhSOaIKSyUwxIBl4JGiRBRLfCb1PMZA3/KVKVHas3Glp4bEFFlC7Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> FS-DAX registers persistent-memory ranges as ZONE_DEVICE memory, and the
>>> kernel normally allocates and initializes vmemmap storage for every
>>> advertised PFN up front. Sparse pmem images and workloads that only use the
>>> DAX direct-access path may never need writable per-PFN state for most of
>>> that range, but still pay the memory and initialization cost.
>>>
>>> Add an opt-in dev_pagemap mode that populates FS-DAX vmemmap PTEs from a
>>> shared read-only metadata page. The shared page is initialized with the
>>> common ZONE_DEVICE and dev_pagemap state, so every PFN still has a valid
>>> struct page representation while private metadata allocation is deferred.
>>>
>>> This relies on sizeof(struct page) being a power of two, so each vmemmap
>>> page contains a naturally aligned and repeatable set of struct page slots.
>>> It also requires architecture support for runtime vmemmap remapping,
>>> because shared mappings must be replaced with private writable pages before
>>> a PFN can enter userspace mappings.
>>>
>>> The initial implementation is deliberately limited to a single
>>> memory-block-aligned range. That is not a fundamental requirement, but keeps
>>> the registration and teardown paths simple; support for multiple ranges or
>>> less strict alignment can be added later.
>>>
>>> Provide vmemmap_materialize_page() to replace shared mappings in the
>>> requested metadata range with private writable copies. A later patch will
>>> call it from the FS-DAX fault path.
>>>
>>> No caller enables the mode yet.
>>>
>>> Signed-off-by: Muchun Song<songmuchun@bytedance.com>
>>> ---
>>>   include/linux/memremap.h | 11 ++++++-
>>>   mm/memremap.c            | 38 ++++++++++++++++++++++--
>>>   mm/mm_init.c             | 11 +++++++
>>>   mm/sparse-vmemmap.c      | 64 +++++++++++++++++++++++++++++++++++++---
>>>   4 files changed, 116 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>> index e3c2ccf872a8..21c9b6aeef67 100644
>>> --- a/include/linux/memremap.h
>>> +++ b/include/linux/memremap.h
>>> @@ -9,6 +9,7 @@
>>>     struct resource;
>>>   struct device;
>>> +struct page;
>>>     /**
>>>    * struct vmem_altmap - pre-allocated storage for vmemmap_populate
>>> @@ -108,7 +109,8 @@ struct dev_pagemap_ops {
>>>    	void (*folio_split)(struct folio *head, struct folio *tail);
>>>   };
>>>   -#define PGMAP_ALTMAP_VALID (1 << 0)
>>> +#define PGMAP_ALTMAP_VALID BIT(0)
>>> +#define PGMAP_VMEMMAP_OPTIMIZATION BIT(1)
>> I liked the overall idea.
>>
>> Minor naming suggestion I have:
>>
>> 'PGMAP_VMEMMAP_OPTIMIZATION' feel too generic to me.
>>
>> Maybe something on the lines to reflect the actual optimization:
>>
>> |PGMAP_SHARED_VMEMMAP or PGMAP_VMEMMAP_ON_DEMAND or some_other_name?|
> Maybe PGMAP_VMEMMAP_SHARED? It describes the shared vmemmap backing
> more precisely. I prefer SHARED over ON_DEMAND.
>
> If you are OK with this, I will keep it for the next version.

Yes, PGMAP_VMEMMAP_SHARED sounds better.

Thanks,

Pankaj


