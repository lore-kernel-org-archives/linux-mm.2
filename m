Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B3E606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TlPADIM/
Received: by kanga.kvack.org (Postfix)
	id D5B966B05B6; Mon, 23 Nov 2026 04:23:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33356B05B7; Mon, 23 Nov 2026 04:23:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21DF6B05B8; Mon, 23 Nov 2026 04:23:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 991D36B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:23:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 360E1A80C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:23:33 +0000 (UTC)
X-FDA: 85465845906.15.409C25D
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012068.outbound.protection.outlook.com [40.93.195.68])
	by imf10.hostedemail.com (Postfix) with ESMTP id 33A36C0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:23:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="TlPADIM/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf10.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.195.68 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795425810;
	b=oRDv7EF3/dXNPLaC8dGVPUdmRWPDv526hdL/zsQKwXwO0Hn9ND4OttAsmzM2DLelo5V2Hv
	9Rml82vTkMD6HE8e7j0XefqcJFbDjEyCoU7lJbfWR1k7xEa2YHMv20MnFidVyL8fLpu5Ai
	T6ZowOGGBbyKTfYZgTKRsf4DIQz/d80=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795425810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGWEtXj6gymSVNH2LkYikzT7wCclcEb6TtqzT3rIYgc=;
	b=sqZKQH7ws6GVDZoj9+L1qZekViAcyZOqvLu3wVi4p6s6ohuqA1tMX9Mrnyq12tlsz5ybTW
	H4eaCE92pyHHe63orZHnKHyi7QOqWBrq2MSDRcrNk8ExBxOOZxRpI3P3S20rIGcUSc7kri
	F5nyrROHKdSblYZ/rtmrgI4TkHZXEzE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="TlPADIM/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf10.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.195.68 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kokZ9Y0miZjif5eS2OEhnkPRio+1a5xdwZE3Q1Z1b+aXzu8BNbFgUtaMh3YKTJTsapVxCBrmp7CiuZjipJMecdHREAYaueoJo80loX+uf8ncCNWLrWmM7845S9jyKAB9m4BjrpT6QMoGyfPrp8VvcA+82s+0jJW3rtLWG6uiCMgebl3qpQdq64C3PfZyQur/IValFiHedqdFryJ459TPMgIwPLEQXW7Jy/CWZ1mVp55HXVcQzm52TEdYKvx5US43odvKsCqgL94FOZh9piWgLN80de+mHZ0fcpXq6V5NfiTkA0fYgnj4lekvE6E7l21kQVcr3QXAgD9fxNZouQOK6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGWEtXj6gymSVNH2LkYikzT7wCclcEb6TtqzT3rIYgc=;
 b=SS+hKdYlaSyDda/3mK9ju78Go61fuVRfoOqla7HaN8pcLjYegXTvcgw/h7SqMQP2PltKLQ41MkQWs5kVNAiH9QssXhB0hAk95q3cB01HlNDQSZH2hwH9m4ko1v8BVCNXUWS6ineN3NQ1La6vkKSJgm7MCwlFjc0uby/kG0M8YgZYH9ZNE0ZS/JtqI6ibNfFLdu2VWp/poOLK3wpP/8neqbfyXi5SU216Rhy5mFNtkkge7sAy5a5gDluPLBFKzkF6OXBJD9TZrwvfpNmhjdQSqaay+KExrrVmkGWRRxhBlCR8zn9UWlrf6+rt9m1ZHbomRW+KQawyVlpp0sgnTcJ1MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGWEtXj6gymSVNH2LkYikzT7wCclcEb6TtqzT3rIYgc=;
 b=TlPADIM/fqgaiD7C8r6oke+qjOcnr1UP+3rWebfD7HGff3gyi8hHdzjZ1gpr0/3KrqNQ/nY0N5MlZqYIVczyx0PbleXMLftPyMfOo7uXao/8HL3TbB8os22PP6vby4DCX9nVV0Ya581zwJPO9d2cJQUKlsUVisM/mp2gvwhQDTs=
Received: from CY8PR12MB7170.namprd12.prod.outlook.com (2603:10b6:930:5a::18)
 by DS0PR12MB6629.namprd12.prod.outlook.com (2603:10b6:8:d3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Mon, 23 Nov
 2026 09:23:22 +0000
Received: from CY8PR12MB7170.namprd12.prod.outlook.com
 ([fe80::7565:bdd3:383a:de5f]) by CY8PR12MB7170.namprd12.prod.outlook.com
 ([fe80::7565:bdd3:383a:de5f%3]) with mapi id 15.21.0639.011; Mon, 23 Nov 2026
 09:23:21 +0000
Message-ID: <a574e06f-01e4-4b51-929b-49dee297a316@amd.com>
Date: Mon, 23 Nov 2026 17:23:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
To: Matthew Auld <matthew.auld@intel.com>
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Brost <matthew.brost@intel.com>, David Hildenbrand
 <david@kernel.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org, Huang Rui <Ray.Huang@amd.com>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
Content-Language: en-US
From: "Huang, Honglei" <honghuan@amd.com>
In-Reply-To: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI3PR03CA0007.apcprd03.prod.outlook.com
 (2603:1096:4:297::18) To CY8PR12MB7170.namprd12.prod.outlook.com
 (2603:10b6:930:5a::18)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7170:EE_|DS0PR12MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: 712d95a5-5971-47c3-a5b7-08df49436ab0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|11063799006|5023799004|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261022075727099003|261026140227099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	y8JKqD/3Sbu2cuTGrcu2036mGyiiK1euTPa3wpVOlmcis+SWfgG0pXiHgp5zhWL6qV6wv2Xs8shIdH+utwy8nqTsY9icnSd+uPIQOnN1OWQ84z57kYbQcQ2n6mPwY1jy0hhA1dT7mzAKkA7nK9IMLwugwh9/FaBLHK+LcizQL+RDGJAXGgqnLdMes3eBIexXWEjM3psxbcetRD6kETKqbIA5JaYUX3drovF0OJxqTWtlErC3Eq0hTUUInQID4E8H3Z6xNT7+HkFbRxnXSMM0qB7EuqaKYMLQTIH9VwVkhZ65vSXrEiRaZxx8OOQbhIDmJ5dyQz5UhmJ2C7SOe0FQ6jDC+k814i2hswT9V/TKQP/NV2ls1uOGIjjgrSWcFpgibvmv2pic6NaTE3rHelX8p23urMmLutTG9h9iMgkB7PQET4qKuYkktcyuH4R6xfpDv/e4VImN5XCWp2kffILoVI6uZrVX1usIuOlLguuZfP6O+MXmeWIHaNawPbik7ej5wN9KnuF7IAASX8a9jpRP45bDm++5oS18oEDeeeXEFIWVCP3pWPfJDnMI11lBibjCiwR2Wk/J9kxsJjkG78iC/RjUkLDbjF0aNvAeFky+uiia7COnQQkJJdkStPk7UNmVdXE9CbqJqfOIA7QwL8oVItsNTCabScaXpcAGvv8I834=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(11063799006)(5023799004)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261022075727099003)(261026140227099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vnc0RnhtVkhyRjBMTlorOE0xYnVlSFdJQzFyZm11WkVKWU5PYUJWS2JTcEgv?=
 =?utf-8?B?QTJCVzZSQm8waGxKL0lNWUxZQkt3dG9YOTFIOGVsQjZNa1lidGlXZis3aEtU?=
 =?utf-8?B?ZjNtSUVLa3BPWW9NMy9TM255eTA1SVlPakZ4bXNTV0hEK2VFSWRQSG5uZ0t1?=
 =?utf-8?B?NEpwZ1FSVWpsUnM5QTY2UjV3Zm8zV0xKUmIxV3VQbFNJcUZvSWFZRlYzWG5C?=
 =?utf-8?B?eHJDVjd4S3Nsb0cxWHlsd1ducXI4SjE5SW9TNnJRUEdLZnlVNjNXZlk0S0VV?=
 =?utf-8?B?UENmd1JodC9kSnF3U05tN0VQLzl6UVpCTC9SY1lRU2tyMmZOQi83V1FmYXFk?=
 =?utf-8?B?eFBBM1JUajRneHBxUDVQNG5uejhOOVVHYU9uYU43ZUVPWTBPMjNBM2YySkh6?=
 =?utf-8?B?ajlMdWJUNmptQ0dKYTNuYU5tSS9ocjNYaHJsKy9pOUNrMFNjVkI1ZEpnTndM?=
 =?utf-8?B?T0dodnk5VUQwdUoyV1QzMDNhdHlZRWppOUJDM3YwRm5laXhza0VhVnhYcW96?=
 =?utf-8?B?Ny9ybFhVejBPWkxvb2xaR0N1c0NucCtMOHlweUNQeDQrdUljVkluYnhZYWEz?=
 =?utf-8?B?S2xvbTcyV3FDckloaFBjYWc2T2pNYWU4eng4ZUl2aE91c3JwRGkvK1VIN3pK?=
 =?utf-8?B?UG1rM0d2L3pmblZtTzBKU3Nva083Z0xJQndLWjJjbGRYS1lWOCttU0dFRE81?=
 =?utf-8?B?OWs4SjhtYThNMWxKMUwxWFQyQmhLRVBlQXFsYTNreXBEZVlwUHRMMk95UUNk?=
 =?utf-8?B?NmpaZ1VqdERGWkRvZi9CZldUQ0F3akczWXFHU3dWSzJpMGxpNmhmeFhxM28r?=
 =?utf-8?B?TDl3RTJQRmpWOC9LSkkzNnFlRFlYOVl0ZGg2TE9mNTNiWjJWNkFUbHR3Y0Vh?=
 =?utf-8?B?SGlKYzVyOEJneHJUd0E1cHl0ZUZkZWtLSzU1bUFYYk5mQ0pxK0FPUjdKQWhT?=
 =?utf-8?B?aDZucnZ1dmo3Zk9IUzhTVjE0a1ROMkZvRDVtSjdqa1dIM1JVR0VydmJsWjRZ?=
 =?utf-8?B?ekxkaGhvNWpjUWRiOVl2ckZmdjN6aFVjWVNyVklxNThNSG9YSTQzNjVMbDJY?=
 =?utf-8?B?OUJQeGNhYWxMR0ZSMnd4Z0Y3eW91Wit6bzBKSW14emxTak9mdDA2YWxXd2Z6?=
 =?utf-8?B?WTI1bnVvbWYrcEVCam5qVmMzd1FadWlTM0NlQlJKbzlMN0pHamlNaHhHYWNT?=
 =?utf-8?B?QS9uOXR4Q2NDWVVxblpMbXRSM0U1ZysyRjhTU2l2MWVQQkxaWThvOGVOc2Vk?=
 =?utf-8?B?Y2twOEN1SWc2S0NHV2toRkhRZUJHQjZ1R2o3dmhwMG1uOUlBaVJMc1hqTTNy?=
 =?utf-8?B?Skh3YlFpNmVMaVlMdWJ4ZnYvWHNrZTYxbHU2cHFzbE82U1RmZURUZlV3ZjE5?=
 =?utf-8?B?Y1kyVUN4WkxKaTVxbEJEM1NWZTRPRW5MZHNiaFhLVFJlS2s5eURZWUhDazdm?=
 =?utf-8?B?U0dIUFVwaUtKcmtHL2J0bzdRSHlUc0ZyakRVNEl1dVF6WndJUjdiRmRFRlJJ?=
 =?utf-8?B?VHE0ZVhmRkZxQXF0RGZlY3E2eGtoSHdjK096Y05CUzJIRUphSC9LNVN3c3dm?=
 =?utf-8?B?QXNzendsdFBzckR1L2oxcDVoREJVRTB6MWxWMElGU1RabGNxT3phaXhpSVcv?=
 =?utf-8?B?ZjBVb3JVV3NSM2pUM1ZjM0haY29WanpWV0hqTU91NjlXbkVpS0g5dUorMkVS?=
 =?utf-8?B?bExNYmJLODd6clVXSkhuZVlOaDFWRHA2cUdsQVdSeFc1TUNSRjN6elZzUUpB?=
 =?utf-8?B?TnlRYysvV3RpTnlveUNaWDVTOXF4Y1RzVkVLc25vcDc5blNtV2V6MHZUbktq?=
 =?utf-8?B?WkhQSy8xYTY5L01BbnZIdngvMkUrTExuclZMN2dYQW1Cd21OemJUY09ZdndO?=
 =?utf-8?B?YTFydHNDVkhjaEdVaUhBL205Y3FXM1MxQkQ3akRYZ3llbkdaSHJ3U2lveFpU?=
 =?utf-8?B?cWtYS1d3UGdQZ1dXdThRZDhiSXlxTk8rbzRvYlNXK2Z6bWFkRk92V3YvWmpK?=
 =?utf-8?B?Yk5vNmVLY0lnTEY1VVUyTGRaTjVVN1ZwYVFNMm4yZmU4MStoYmpCcDlXdjBj?=
 =?utf-8?B?elhYaDY4ZVVLTUJxTWgzVlhQOWluNnNxYi9ibFBJZ2ZzV0owRHBMQ29vam5h?=
 =?utf-8?B?TFJlamlaZC9hWDhaZkZ1M0F4bGV3L3ZlUXFHVWxQa3dvOExrbE5CVVRUL1Fk?=
 =?utf-8?B?OTNXOXFJUzJGS3V4OFRKYVdBOTNXblVCdEllamRMQXlKSUVVUGdwZUVWV09U?=
 =?utf-8?B?VG5OSmNUc3U1V0E1aDUwcVMvbGhRay93TForS0JvRC9aNkZYUzk3Yms3SG1D?=
 =?utf-8?Q?EbD2bRNTTUYWh4o306?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 712d95a5-5971-47c3-a5b7-08df49436ab0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 09:23:21.6139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLrcWDvIlOwc0/tbA18az5pu7MbbjfCLNlFWsUvx/lfIDFJ+kkhNy/jyz2e1XwTCRp76BQmYsNaUzWhVM1USzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6629
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33A36C0008
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: qkfr7sxq5jhk4jg8umsqpm5zctf5tg7z
X-Rspam-User:
X-HE-Tag: 1795425810-465283
X-HE-Meta: U2FsdGVkX18ajbGg8tzw4IHgCOtjbIr691HOMXKOIt7KNorl1sLoHoXR+Qye2/a0MyS+vyigXC6AbibOtDXxX2SQfIgeApe7VF/w/bvSKf/05HI7eM4k8jf7KwmcdEY2LrrtFic8CBLcAM62Pd8GTSSrZ/xXirM1oHZDKOR4vc5pDqH6ssHoVl+ceIXgtdeUYtCuv/sCUumFdND1AtR/g3dQzxM3tsd7RfDmsClxUtLMsrPezCptSy2UzeSYt0DybArtFJSFbrtntAW8Ki1zoYYy/bq0O2LjR/DPJ/HchXBApBRjh0gDd0nbh9s2ftYOMeR1TtoiQxiwIH0JUdrw6hii/QlQpTAUPpGVmY+d8OxWC2qadJ1rVH0Ny3M+NdLu3czwWDKNnuWLglv8sFS89DhHVPbwggvyQwQIVAe1nV4TtnnANaSWe+DAR6Bx+29PWGRmHd0ti3eSOHMIKeQFBkm9Jkcv0BvZt+vaieZxxhZjOXhulRdZ78pgbLy7bMDEQcaFIdBNV6AGkdcj2kl0hV7e9Br6ZQLGMtHTZ2nFf6rtoWNuv5Rgpzo2PARFIBnzHd+4J1wQcl5uP/ops/41XUKBqvyKZSrZvT9ZfIReDYpOsbqPpHtQrgd9r/p47eA3Ci//yz/TFiOFJur3Le03YU9fuusMQKZTY+EpdHIlMsYFuRN5PrYi+eEcUl9HFeuRtZFTAIVrQPSgBfFdbOHq6n13741b0OiMF/Ry+Mc3/jn9AQrZebTH7TYL7spMGvBnsaNmzIpqbrS4EzyOqyYsQ2V+WHkdSr/aD9f5fgDECdD70G1x3hvKXdLHll0sybsbyKMbiIDrDP1/YS4X4yoBgVG8my8rr7zhzU6GB/2TaC8ESQeFRBwmZ4fR6AV3izwZKfjAaAutjefjxZcQJoEs6t8AmW4Ebme30LCXiDCvPpce5aZUQ3JhgeFbLvdO3YKTlqvRs0XkjXYTZDqc4fX
 L4DuK2ZX
 +yAcc3QHAgz6MBlaJHPScA5ZP/dm4Bze1KBd6OcOKgp7UQUxKHFp7loPRNKlYTTWM2PIuWd8RPiVZ6J5MAGelR6XhcOE3YS5jP9NM9ZlEEmWTv8JyKWMM2Kt1gyhzY+kAHzxsdH27Ys8lEUQjy2c0e4996nH58b9WuDP1yrFzbd7e6YlKwkAKmRkqABqSgNG6BTR42zfyB1M5L5Kbdt+nkGUzbfaedd+QZkxLQMwkVfjCvfIN0KSbYYJ3umX0A6M88ZKIHftwEgFRZjkcZeubSKjDNAeTBNwNBBOgHm2GuJBVjbGgSUUWOsUTPzCbVjMXrzKWduvAahtmLZJeyiiHIPNihYn+J5I76mpzKqzgFq0ozJL0Guml/pzBa0GjUhcx7it1iUUCUNb3f7SOnhg1sRApMmvWlomoTLmRxGIySdcxEtmm2xVutAXUsiU0uLOX2dOf2YXyUnfzALML50LHZH9pTRQ7G8QjphFrzvRrOiPH3uVg8oynvzgQuc6tk7f14mrWjBcL3sdBxeMMU9ldG1HeAoXo0epgnaFZjNN07Rb9awYnF6HR7DNvwc6P/MsDvQY689eml4prNj6t0bUMPQRyCxYkZ/qArpY1wTgnWOPGELr4mBHG+xFv3SPwW+4ur7mionFrMrtPqZ5TfWt0fS0K8mwihtZ+MYlTsUQJmGp36S40w4tTC9tNaLbHTO2oQl256693bkCH33pfAKp8hLQgKHHY0eAxJ4O3AN+UAsCcMDUf+61jF61yfHjBNEknmfAPZ6REv6RHDG8fTfUSDt3/YELEKMIOa+OnG+9d6XMBYV2JBpr4/D9RjC3uDvVXdP9/shLrvRugPYchAgh1ThjjQc7erO/D9BsZs9+0S9hBhzVaAaKNZziXwfQqbhPA5V9iSBeBYvfeHRS8yK5+liN96s8gsY4X890ZqRWDXHgdbbAaxNTnOS8HRATyB1E1WtiR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/14/2026 12:25 AM, Matthew Auld wrote:
> When automatic NUMA balancing marks a PTE or PMD as protnone
> (PAGE_NONE), hmm_pte_need_fault() requests a fault to restore access
> permissions, including _PAGE_RW when write access is needed.
> 
> Calling handle_mm_fault() from hmm_do_fault() currently triggers NUMA
> balancing in do_numa_page() and do_huge_pmd_numa_page(). When
> hmm_range_fault() runs from a device driver or kworker context (such as
> a GPU SVM or userptr rebind worker), folios get migrated toward the CPU
> node executing the remote fault.
> 
> Also, each folio migration invokes try_to_migrate_one() ->
> mmu_notifier_invalidate_range_start(), which invalidates the
> caller's mmu_interval_notifier while holding mmap_lock. That causes
> hmm_range_fault() to abort with -EBUSY after every 2 MiB PMD and exhaust
> its retry timeout on large buffers, which has been observed with large
> imported Xe userptr buffers.
> 
> Add FAULT_FLAG_NO_NUMA and set it in hmm_do_fault() so protnone entries
> restore PTE/PMD permissions in-place without performing NUMA balancing,
> matching GUP's default !FOLL_HONOR_NUMA_FAULT behaviour.
> 

Hi Matt,

We did some multi CPUs test several months ago in 4 x MI300A(4 CPUs)
keernel 7.1 platform with same HIP workload, kernel.numa_balancing
disabled and enabled.

Allocated 1GB memory in the system, warm up then launch GPU kernel 
continuously access the data, calculate the number of launched GPU 
kernel. Result is:

balance off: 4752 launches/s
balance on: 3188 launches/s

The launches number per sec drops about 30%+. And the notifier 
invalidate call back calls increased extremely high.

And there is one more thing:
The current amdgpu drmsvm can specify system memory as a destination, 
but not a specific CPU NUMA node.

This has impact on some platforms like MI300A that feature unified 
memory for CPU and GPU.  We did a test for 2GB memory accessing in node 
0 and node 3. GPU read/write bandwidth averaged about 2.78 TB/s with 
local pages and 103 GB/s with remote pages, it differs a lot.

There is a requirement from AMD HIP to specify certain SVM memory to 
specific NUMA nodes. But KFD also can not support NUMA fully. So the
HIP runtime have to use linux NUMA facilities to move memory to the
correct NUMA node, this could lead to unnecessary ram to ram migration.
And it also can not solve VRAM to RAM evict to error NUMA node issue.

Would it make sense for drm_gpusvm helpers to let a caller pass a 
preferred NUMA node by interface? An explicit destination node for 
migration to system memory.

Regards,
Honglei



> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> ---
>   include/linux/mm.h       | 3 ++-
>   include/linux/mm_types.h | 3 +++
>   mm/hmm.c                 | 2 +-
>   mm/huge_memory.c         | 3 +++
>   mm/memory.c              | 3 +++
>   5 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 77b5d450fe45..4b6ad3c0b591 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -717,7 +717,8 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
>   	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
>   	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
>   	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
> -	{ FAULT_FLAG_VMA_LOCK,		"VMA_LOCK" }
> +	{ FAULT_FLAG_VMA_LOCK,		"VMA_LOCK" }, \
> +	{ FAULT_FLAG_NO_NUMA,		"NO_NUMA" }
>   
>   /*
>    * vm_fault is filled by the pagefault handler and passed to the vma's
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 1ed35d258d2e..2ea71c1bb170 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1819,6 +1819,8 @@ enum tlb_flush_reason {
>    * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
>    *                        We should only access orig_pte if this flag set.
>    * @FAULT_FLAG_VMA_LOCK: The fault is handled under VMA lock.
> + * @FAULT_FLAG_NO_NUMA: Do not perform NUMA balancing migration or NUMA
> + *                      task access accounting on protnone faults.
>    *
>    * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
>    * whether we would allow page faults to retry by specifying these two
> @@ -1857,6 +1859,7 @@ enum fault_flag {
>   	FAULT_FLAG_UNSHARE =		1 << 10,
>   	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
>   	FAULT_FLAG_VMA_LOCK =		1 << 12,
> +	FAULT_FLAG_NO_NUMA =		1 << 13,
>   };
>   
>   typedef unsigned int __bitwise zap_flags_t;
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b644..62cdeb071781 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -648,7 +648,7 @@ static int hmm_do_fault(struct mm_struct *mm,
>   	unsigned long addr = hmm_vma_walk->last;
>   	unsigned long end = hmm_vma_walk->end;
>   	unsigned int required_fault = hmm_vma_walk->required_fault;
> -	unsigned int fault_flags = FAULT_FLAG_REMOTE;
> +	unsigned int fault_flags = FAULT_FLAG_REMOTE | FAULT_FLAG_NO_NUMA;
>   	struct vm_area_struct *vma;
>   
>   	if (hmm_vma_walk->locked)
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0d589be136d2..ea380bf45df0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2361,6 +2361,9 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>   	if (!folio)
>   		goto out_map;
>   
> +	if (vmf->flags & FAULT_FLAG_NO_NUMA)
> +		goto out_map;
> +
>   	nid = folio_nid(folio);
>   
>   	target_nid = numa_migrate_check(folio, vmf, haddr, &flags, writable,
> diff --git a/mm/memory.c b/mm/memory.c
> index fe72e66c9c2e..53c819a6e49a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6404,6 +6404,9 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
>   	if (!folio || folio_is_zone_device(folio))
>   		goto out_map;
>   
> +	if (vmf->flags & FAULT_FLAG_NO_NUMA)
> +		goto out_map;
> +
>   	nid = folio_nid(folio);
>   	nr_pages = folio_nr_pages(folio);
>   
> 
> ---
> base-commit: 4318887a3efa4c53d6f083ccfd7105b809a3ac65
> change-id: 20261112-numa-3649f4bf57c9


