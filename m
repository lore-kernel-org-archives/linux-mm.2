Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F0CCD3427
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 00:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09F86B0005; Fri,  1 May 2026 20:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB99C6B008A; Fri,  1 May 2026 20:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981166B008C; Fri,  1 May 2026 20:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8767A6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:48:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4F5014036B
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:48:09 +0000 (UTC)
X-FDA: 84720643098.02.200C548
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	by imf21.hostedemail.com (Postfix) with ESMTP id C66321C0008
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:48:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GPXfRAJ4;
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.64 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777682886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NO698QM8uwDWjaDSyRbR+QXbXnw2wgFZ+NiFNdxRcQw=;
	b=x1vw4/Cla2fdaVsVr22BJYI3SeXHhZsoxbhTohWj7xQPJDHh367lP1rO07jn1uYhkiTXPz
	77WlucTd/o+JbE/aY9MJZ4an/8RUYbU2+jAgIEJ+QqeCcaNenWWdfh0BF3TDdIXCswY3th
	McgTgfk4Z4Lq5cm4Y9RsAmrJIISX67Y=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GPXfRAJ4;
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.64 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777682886; a=rsa-sha256;
	cv=pass;
	b=j+an6NMDP+DltpPASbJf7o2yJWw2DPg+JSVDSYudrrgtlJ2SGmaE2XCk50nAuqx6UHBxqL
	xepwoNoyD8kr8gADMU5HVof4qzydMt5XwFkFJlleoU0SLeLmUC6+zjBBMDnTWzfNH5F7IC
	fFysO2pI8k9RESOD24poPufc3IQ5TXk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMxD9mXJJqAeEkE/HD/oPkBNu9ynNuuRK9fvDDFiwP+1Gak+7Yx0C2DT2JwQtL8MQNk/nfXPmQPjNo6Z2CA/CJkW82NYloyWr6XZZieuN5XXK0264WpGem22UbGZSaVc62LL6U0DE+6iAFB7YrJuptheY8Ama5I8LLKWupmC2R79kEWc/eKU8uBTrzdwHyh1TG7jqV9T+pIi1pizTqC7eR6lSNqEVVGgforyOmfop9oBbSD6ajYKdSotZfuiY9C10vHyZ4BpEcXssyuaJP47HkMcHNQceCRAseocJGLGA8cFZdhnUMNtmdr8fOFVdOucwIsFSoHG32bTm2yK51W7DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NO698QM8uwDWjaDSyRbR+QXbXnw2wgFZ+NiFNdxRcQw=;
 b=VYomCUkKUe3lZke06SXxyStXOCewVRryMfQ1ZeR5mvkaqVMJ/v5wW5+OBEvt4acwGXxTSIuq/JqCdAKyICAY39+kjrXnrG/UH9THxljeSYOyGTpgiKBNM3r1dHdXJUahcbVevm2Kz+ne19FY7f90xuKE6gWBxU1fcXtEBo9ymsDBVmz8PCf3rFqXiAgjrGs0rwJCptDaLSCjDVve6gEbZL1eWgFffTAU8mtjfmbpUcPnhl+K2jjCclTv3ZViItp3Sik0YCxCPr5DQpbH8+pH6dwKaLW53xGoo38SuArpnEz9HI2WPqkrp7xWmaf2BwhMART9lTeC8JaabO2pkGovbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO698QM8uwDWjaDSyRbR+QXbXnw2wgFZ+NiFNdxRcQw=;
 b=GPXfRAJ4JK/7jXuQe2G2og/juIZUnauN/y5TvVrrFcPf5/DyIHOFEnqxPNiRu5fOku4KTpoL+dfLu10UwvnR7b4+gzAANXbIRP9DtNDG9gLHNUnQWw3FazTWt5IKn69n2lB3oZ5qSWImgkiSM3SMnAvCqvs9lX5zADnLo1HDfmLtrghpFR2BG/MJRF2r29+BryvCLE6NPBXVHKIKAkZaSeAwo7x7KlfHDrlyWXlz/ph9MuxIrwhkDFB4EsYFulVPSCvz3WmxWy+/kNTHyBvtNxNKlhJl/gccMsNEwR50v1P+96jQtogjWiKdbYN55Y01zk5hJAI2NqFb4hv+vcnBRA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY8PR12MB7564.namprd12.prod.outlook.com (2603:10b6:930:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Sat, 2 May
 2026 00:48:02 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9870.022; Sat, 2 May 2026
 00:48:02 +0000
Message-ID: <5b25ef69-ffd1-49f3-a340-db70dcc96b29@nvidia.com>
Date: Sat, 2 May 2026 10:47:55 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
To: Andrew Morton <akpm@linux-foundation.org>,
 Sunny Patel <nueralspacetech@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
 <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVP282CA0057.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:203::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY8PR12MB7564:EE_
X-MS-Office365-Filtering-Correlation-Id: 456cca9b-0769-4211-5a4c-08dea7e476fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LW3Gxi7N7kRPjHJc4Hf9qdg/fYrJusuKbXDzf6y44d1fixAeSoRy5Zpn1lmHQvyf9wQ6Nzc3dnWCTDv+203xRdHWLef5PfqJX3OMYzgrY65tcqhukDbuRFpzFEttI2aYnieudbmXiRkmytfo7wQZ5IsB3oilU/D6RUUm5n31VEDoyCaEeKfYHrYh+bqIz3HCASrpJq7ykCzNyrgxCO6InZV8drXz3VmowHWMT3lp5vTGkez73k0jch0MWcNls789RUKUAF8GyOpmWHSc8rMD6L+UTU6e5BX02ZqlQYwrR0nGxi13XBJxmO/jrPxtaC1spuwD1WWuvKWuK25Br8EUz5UYvoTvlNVFQx7xOktT3S/BoujazSJ8Pg2VGkCgyziOiGruFkvjljs/r4279wS2/f6LQnJDCSKef0fde0lGZouk1iFB0m0z0vgKKJpJxvW7OV/IlxlGeDOV9BXygqB8hKyhDh0Omo6tuMURE4TQzVLVkIDgFrZcx0U/nGbI/aUQJAbGJTv2i2DctgQWjHeaJ10con+/YQ5RkDq9xfy17QNtreSc7Nt/j8k8f5wJLup0gOK2DDvG36FDQiZlFjetUHGs8JE0kn6j94pqClIdkLE8xwVTiYgnGc6cYWtk8TJu1PAPs5o6frhtguUGWf0222YaQ5JajRKNo6n5p//PiXHQ05gyuGVvqPHST6Sw2g93
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFNiclpRQlVKTFhWWldYckpqeEhUeW9lUjVWWFV6Z1FkU0JHZEJZSDFvcGxH?=
 =?utf-8?B?RGZERHZFelQ1eDZlSHVvSWJOcjdZMUNIWTBYczJRbjBtVTB3NE9yYzJnV09h?=
 =?utf-8?B?WGdzeHM3YzdYQlEvbEs0V2NUbUwyWlhTZlJNTjQrcnhldUZjZkdTMEh4cGg3?=
 =?utf-8?B?T1dpRURrOFJzSVJBNXcyUGR5TFFvSzFvaXJjZEZDQkZBa1Z5VW1rUENRVXdT?=
 =?utf-8?B?eXBaaUlHTFgwVzc1dzF4b2xrKzNKczU3VlpzZmlRbklEbWR2blZGaTJOSktI?=
 =?utf-8?B?a2RWQ2JaajZ3UVZ4ZDN3TUpJYThDWkpJbEdYUGxnSUd0RGp4OHFjb2RRem9q?=
 =?utf-8?B?eVNRaXVSYm9PWjY1dXJROXUwbXp1ZXhENFZMUVRjWU5Gc1NuTTRFZUVWUnNN?=
 =?utf-8?B?ZGYxdmsxQmtleHViM3JpVTJoUXE2blB4WEtIN0NTS1ljY2Z6UGo0ZE9oYmZr?=
 =?utf-8?B?TW9iTkd5QlI0dHYwRUs1Z1hSaGtKWnJEWkhaNTMxY3B1Q3lXWXZMTjhVZW1p?=
 =?utf-8?B?amc5dGtaWUVFR2pIT1JXNXIzOTlWVTQzVW1keG1XaTZIRE9vYjZkVytpQ2lT?=
 =?utf-8?B?TGFxZVdacTR3aXgyOHlxMFpsQS9zaE85U0ZyZk0wcmtiQ0VOSTcwM1RjNGdI?=
 =?utf-8?B?L3ErOFJMbGd4RzdPOU4wd3ZXWkhJdng2aXoxWkZ2bUtLbHFDRkJwRHRqTXJF?=
 =?utf-8?B?M0dWOEw2cjBwdGRZUXAxaldaRWpRUWs2RGVMc3JRQUY2N1dGUU1ha2NoUjlt?=
 =?utf-8?B?c0xxd0pCd3R0dkJ3NUFET29LV1J0cWpXLzZ2YU1WRmwwY3FHL3lCSnh6Wkp6?=
 =?utf-8?B?czNaUEFldE0zVVkyUG44cDJ1Znh5b0NWUVF3dThvMGQxWlVFbFlwb0duaVBi?=
 =?utf-8?B?RGV2ZThGdmhlT0JobTdIV0Z2cWNheDR5ZVhBZHB6d2lmdGxYWG0wcFYxN0VU?=
 =?utf-8?B?LzV0bWRJWndNelQyRi9LT1Uwb3NVWmpJLzlwM0xkTUN3cVdaU0dtbXRKTmQv?=
 =?utf-8?B?YjRKNGpadkxET1E3Rld3Qnlxc3IxUDVUbWlMUnVQMmxVZWZxb0VvRWZqYis5?=
 =?utf-8?B?RDNaSDVWdVcyaFZUVEo4R004V2FBbFZDTXd3cVFtdnI4elJLQWE2S3F5Mndz?=
 =?utf-8?B?aDZqenlLVWt6dXdxK0ZiVWcybjJzdGJIdmFzbjZvYXFxdW41M1EyWFBlZmhD?=
 =?utf-8?B?TGs1QVJtWkgvZER2RlB0SUZXNUZFQWlUQms5TjYvQTF4WkZCcmhYMnF2YlJk?=
 =?utf-8?B?SnRWTjdDK25GTG5RekVNaXVLaHRaWTRoaU1GNnUyRUhwY2NRMHBzUmVrZWMz?=
 =?utf-8?B?NkN0NkhKTFZFbDMzeWcxWnUzeTFpRUtIM2F1eU9uSVNudklrY204NTlYNnMw?=
 =?utf-8?B?VVdwZThYdHBLdnliT0poUithQStMRUNXenM2MHFVaVU3NDVsc1N3Qm9yWS9y?=
 =?utf-8?B?MFJGMWZ1NGllWElaUjc2WkZVRkJSbnZDeHdrTERVYnFLOHdkLzZwY2xwbDZS?=
 =?utf-8?B?N3JNM0Q3M1RQamJJZ1BSRHJlclhuUEtGREJpVGVXeWpORjhGUm9aQkxUR1U3?=
 =?utf-8?B?RDRXNWZVQlJzUFBQMzFDVmFTNTVDMUZKRzE1R1p6UUg2T0ZhVmRXRmdmTXdI?=
 =?utf-8?B?Kzl3NUs1L21RMFpKZU1YMXBBMitLNWIwdWJLS21ITklQRVVtZjA3d0NnUk95?=
 =?utf-8?B?LzhuQ1ZSQTNiRHZQZzFERTRxeXdQS1hCMFU3aEdrSHFibmhyem12VHR6T1Fw?=
 =?utf-8?B?K0NYUjdDTTFUR2VEOXBaRUZFQ2FiUEtXdm5FZkVrbGMrWFJ2RnA3ZTFIeCs0?=
 =?utf-8?B?TEIvZ2xuNzlrZzEwNlhuTzF4OUg1ajhxbE9MRmdUQjdPaHByZ1pBajlOcW8r?=
 =?utf-8?B?M0U3cXJBZ3l5cy9ZMVZQbjh0d0MzUjRGZkJCNHBiRlJNbEZMTGV5NVhHNER3?=
 =?utf-8?B?VG9BUFUwLzlobnBDVlpFMHd0UG1sSTFQdHpKMVlmVTFwTGJJRmpudEpDdXpi?=
 =?utf-8?B?Ni9aTG5qSnQzVUMzbTdWRjRjYnF1eFdWVlRJYmxETWdYVUNTZGpjbUppWXdy?=
 =?utf-8?B?VE8yU3hzUlZsQ3NlcmI3c2czRUhxVEE3anVOWm5vRWRWM2w4SnV3OFZWNjAw?=
 =?utf-8?B?RDMzbWwvMUxUdmJXTlE1U3BCQXBKcG9Ta1o2UDRzQlRFU1FENG44TlJWUFpt?=
 =?utf-8?B?L3Jld3cvbVQxUGRQTTA0STNWR0Y3Y1dZZUJlQXA0T1NPZU4yZlFMUklXQmpW?=
 =?utf-8?B?TU5JbzV3MEYrMTVsTFN2TEc5V3c1djRTSnYwV3JsOUZ6a0FjbCszbUUwaGlu?=
 =?utf-8?B?cXN4WlNUMTJkYVdRTnZvcDR1MFZsb2s4RnVNbkM0ZjAybUwyOGkzOTJON1ZM?=
 =?utf-8?Q?dMN+hdU8k3p75oMlxoDFHOkECNvrjEcV7P5AsxaQuqCIH?=
X-MS-Exchange-AntiSpam-MessageData-1: reeNqnq5d/vsnQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 456cca9b-0769-4211-5a4c-08dea7e476fc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2026 00:48:02.6746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aRc1lyZKhpLv8n0XI9tCroX6p67PIjyUveH0vf3SxNf29T5714suEprQn3bFwS5Uf62K52CgMPR017LtOYorYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7564
X-Stat-Signature: dtz5pdwzbtxaz3jxrdw5e3dh9ii1djzt
X-Rspamd-Queue-Id: C66321C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777682886-935926
X-HE-Meta: U2FsdGVkX1+x+aGGyzBvtSicHCd8LMKsertKULVYukNvKD1dXXNE0PyHwG0XrLM6nvM7bL7NpjD+STDatHS+k/bQU7jm+QyqsfOjbGBRcFDQq+tKdXlSO33RHNmsIl142d7ZTmyjU3hcBcUoKSzhNI3dv4NZscdrBdeNIUr3kO8ZKkRfQcDYuoLHR2UEmcZr0O590e5UGaUzy+eLsW974iP8xmAIF6lz+zBnrsJ3a+SpHme4J/+2r9etZ9rzIoAJpwrwReXjs+66peJ0rcY61+yZf0xb89iFZ+gjWWSaTwMzNbO741T4yRGira8RFk03TRPW5sZhETuSxz+rqPPC44123iQZAbq6D2dr/o84aRCbadWxtAtJAX8Uok0Y8564PtK5NKo4HQio4BsWa3WCeHNCEbkx6pXO4S1hteEzTsP1+7a8nNJJ8m+WiwA1KSiP8iSb7QRB2UGq5/7mYauxiZ4ZvFLMDAeu9JA5Q+Eoo81mc2SJrgO5xa3D+3I5nZ/LmxoKebFkl34VPiM3TSWJacnTLJ62dOjV1Kyj8hYb9elRxSaxhSe+8PmLP2uZQ3TeTVGWBtFkTSgoLMS/5xYlvN2XsMsJiQwa3zrT5usk+4BOxgd0sXfPN4OgeD+BeZ1QHPYHMRUnsJIh4J/RZdkSZ1CT7ufNdjcQv4YIw5bcrK22JzuhLK+N/LokDnNhSuuJxBxvj5Cb0d997aP0h/THN8Kx0w1oB92x/nWawINAO1+z1MsU5TpS+XRC4ZcYwH2978R4P03LvL8qLgx6w7ntCbHlMbUESSvOxkvYpqi1tkFaRs4jpB0Soc+YgyICybuaf3DULqgG5JWHntPXu+yoQrVpH/XMpw0cyillKbW7jA1zQixLtHuUzmAS7NmUD1h15SerFtvxxGtoYcJhZrqPvnkcAJ0qNr97aPovyujMYV1cWWsWy00QL4vTooiOHinbHjD7/mOxxJIGb4blxHc
 Nds1OJPV
 ou4l1EEq50mW/ZYXQCjUpZYb/GK9cyiaUao7KzQlHbaMyM3sBu0kOTn0rnbHUU3UWwJOAFgR2eM1i7oPoOZit2bFizFIau+qhZsX5sDlOlrdhnTwAAGRtscXagcZC32+qiiI7enMGVVSMxnEbc9aJd/RlgXSGtYzBt20bNNf+KsnzItZvwAEDTnFf1oNwQ6IMxFBubtErKLWBNSRA1ZIcZSAU/9QXAcPYB7/oZ+G8eVoNJTv21O1qPzdHTISCUrO/69FsoVNqqsTx9GSEaftrzhNAvpM8Z+XGCEgLM/kl/5v2RnVpvWcE9wpV8akVU405TITRZLn9yakmH7nZGTdVBX8GBVGswfzjvTCRvd2YhpzS6jqCZPUElC39S5gZhhflOr2snVrABcPj7N8uZYD73TzMNNGtgO2mSd7FhX9tRIsr91SpA9koW74tljyeZticeK/sj+dBPe4eSqNZXNOWcLjq87PqQPmc6D42+wD2E0LmmIVQ5oShpHvU/bMfs9AR4TDGN1018QG6LKJr7TlF/F+vWgGzMMKEW6pY6jCE96Ot0Eo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 22:44, Andrew Morton wrote:
> On Fri,  1 May 2026 17:21:16 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:
> 
>> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
>> to a PMD check failure, the pgtable allocated earlier via
>> pte_alloc_one() is never freed, causing a memory leak.
>>
>> Added free_abort label to release the pgtable in error path.
>>
>> ...
>>
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>  	} else {
>>  		if (folio_is_zone_device(folio) &&
>>  		    !folio_is_device_coherent(folio)) {
>> -			goto abort;
>> +			goto free_abort;
>>  		}
>>  		entry = folio_mk_pmd(folio, vma->vm_page_prot);
>>  		if (vma->vm_flags & VM_WRITE)
>> @@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>  
>>  unlock_abort:
>>  	spin_unlock(ptl);
>> +free_abort:
>> +	pte_free(vma->vm_mm, pgtable);
>>  abort:
>>  	for (i = 0; i < HPAGE_PMD_NR; i++)
>>  		src[i] &= ~MIGRATE_PFN_MIGRATE;
> 
> Yikes, we leak that page on several error paths.
> 
> Thanks, I'll retain David's ack from the v2 patch.
> 
> Balbir, please review?


The issue can be reached if we try to migrate a non private/coherent folio (I assume DAX/P2PDMA)
pages. Even migrate_vma_insert_page() has a similar pattern. Creating the pud/pmd/pte structure
there is unnecessary (but not allocations occur, depends on pmd_none() for example), do we want
to clean up all of it (need to think through)?

I'll re-review and send fixes as needed. Looks like David sent some fixes out, will review
those as well.

Balbir

