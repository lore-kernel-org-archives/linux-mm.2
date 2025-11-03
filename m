Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F53CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 00:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B127B8E000F; Sun,  2 Nov 2025 19:48:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2F08E0002; Sun,  2 Nov 2025 19:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9627B8E000F; Sun,  2 Nov 2025 19:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F03E8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 19:48:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20708C0891
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 00:48:04 +0000 (UTC)
X-FDA: 84067458888.11.B278B57
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022113.outbound.protection.outlook.com [40.93.195.113])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE9DD40008
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 00:48:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=N8YJ0k4A;
	spf=pass (imf07.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.195.113 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762130881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJ+H4xQrgNg6//FP12wgi23miYcaxJOoDGoeKQ286a8=;
	b=6nJRAOn9Pl9b3d5EDgQxVCK/qucyxxqQUo/z83v7E9wQ6tZIfvcLZKR0n1XOVJ0J3P9L9k
	rvG0N4HcgwEiU672lXyKmp2cCgFX94xEno/GEQcpk4HrCZkjNMgNY/hshixaUGwoS5bD/0
	fmm9bFBpu2nzolNsPSb7n7XY7MDUfDU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=N8YJ0k4A;
	spf=pass (imf07.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.195.113 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762130881; a=rsa-sha256;
	cv=pass;
	b=2UfvqoJfPa+GCO/s5AuzDZuHoEsZ2bD0zt3RgzaHqCgIcPn6nf7R1bR7mrrb4oS+ClSqoq
	aGZEXbkvQXKj01p4fIrZPFnTapRor9wjmn8ZRsoRmS8ZlgLrhgw++PcGOvZ4hKijWctBkc
	VRS9rQzYAV9OWWRitjZ1cteWY5JzkCs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1XJ7XtzQUAB04ITytWF9i+AqtxNXesOhvmYLnEa9wCPCSAORtzqCQTDr8xivKNzC9+rw1UbmO+dfZQ19cuDd7jhyPFYJm6Irj3iMGJcmKzczuAFdskta1dLDUwZgs+sG5DxdLhwYfFJ04/uU/wtjicfYuWnJe+bS3eu6cGIDep87HHSZgyDL5uBbVoGm6pnowjO1L4w/qS76plY4qVWwQdrxB3JFXB6zebcVCBmmBCl+c3l5AqVgYwDO8lwivqYaFTtzWkqdQyXCYlsGEyLt9rQu4C5+9m6uX6DTv76ReKc5Fo7q9voL0hVZy2O4PmpOyWeF4cwzYtKh24EWs1Tnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJ+H4xQrgNg6//FP12wgi23miYcaxJOoDGoeKQ286a8=;
 b=GgoGlpcBUuaSVrrZmHAInhXJIi+eNGrghzuFKViI6IxrjlOm82exAnSnbKQ7SdZ2GfbMSxiYsLISsvm6wJFdiiyO7gklB7dqqiPbdBFQ2CAbQ/q+woCBxmp+Ea4sqv9dJ6RMmi5DclGjwqAEgpAycK7tEt0vPgEQj9dSO1aViTELQsuN1CjgTxzbb4+4VrV9INjf5blHxUFTBNy19bnOnFytAeu0EVAJD25JZiIGkwZ3eTnjH/4/OK4AGZUSzdrMcCOR5qcbvKmAsUHeFP6fVe0wEPMBxbchzkgbkOC/C5pxFBCLNATlWP3W+nUkXuyC1I0j67UDNssnmsPi1ZUWPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ+H4xQrgNg6//FP12wgi23miYcaxJOoDGoeKQ286a8=;
 b=N8YJ0k4AYBv/tPsGGJBzJq6PNhJAtmC02Fc9g243eFwugIDB3QkAztx5o0WClTbjhL2TUllrJekCzTXkp5gT3TOInAH7WSGc2rP6gVMx77Kaws8ZOuF3aj9Zv6FuYcqyDWPkq/PoJm4NnJZThuWqd+A5Vtx9iL9Rt0/a7wmu4fo=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 MW4PR01MB6177.prod.exchangelabs.com (2603:10b6:303:76::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.13; Mon, 3 Nov 2025 00:47:56 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 00:47:56 +0000
Message-ID: <85e50475-7d2c-49df-924e-90e0b915a4d3@os.amperecomputing.com>
Date: Sun, 2 Nov 2025 16:47:52 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Guenter Roeck <linux@roeck-us.net>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nd@arm.com
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
 <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
 <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
 <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::24) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|MW4PR01MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 93b8c1d8-ba10-4507-05aa-08de1a72a0b1
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHU4eGxDVmJUTjkyU3J5RndCYWwxb3hZZ1crZnhUL1RhMTZhYnJRQWdNd2pX?=
 =?utf-8?B?UU9SWExsdTE1ZnFETXdjM09kUXNjSHIyOGRMZ0VrUFdUTzNYeGpGVlpQM1dQ?=
 =?utf-8?B?TnY0SUZ5SjEzeHVDMmd4b2ZPNmhsd3ZteExvWXdMK2MvdGxPcmlzY0laeTdH?=
 =?utf-8?B?VkpvQ1pjWGNxVEZBVllOWEpnTmJxVVg5NkwvRjF6OUs5djNONENCdmpUOWZH?=
 =?utf-8?B?WHR0UGdFaEsyeW1VTU9qY2hTUGt6a1diTnVtcWhUSExpNUVNT0hqUXVsdytp?=
 =?utf-8?B?ZFU5ZjhZOE5jT2s5a3RvaUxaWU1rMGQ5ZGo4RmZjTEhHNWdNTnBRSTA0REZO?=
 =?utf-8?B?TWZ0Zm85WU9yQmM4Smt3dU9SaWFyN3QrUnExTEMzbGpPdGF1L1lScmFCWmlX?=
 =?utf-8?B?QWNaazJKVjBvb3B2QnAzb0NTdHVRL3BPZVVZRTJUaGtkTUQ1cmp2UU51TW9B?=
 =?utf-8?B?UjQ5ZEI1VWtETjhWVk1iUXczcmc0UEdSUGRRWHhoSldwdHErSnM4aHNtQ0Vn?=
 =?utf-8?B?MTM4NlFoN2JKdm1VRlhzQis3ZDQyNlRHeTlXT3o4MzNVTHA0Sm5YdzlieCty?=
 =?utf-8?B?Y1BlRnRadEg4eTFkTkVxbVpoaUZsM0Z3RTN2UWdjZVEwZzlVbUdRUWxFZWFK?=
 =?utf-8?B?MGllK3VJM0dsUTJacFVFZnVMUmZOb0pqdGVCRngxMmp4YXNZZ05vTGJHUXVN?=
 =?utf-8?B?ZHRtNmZXbGxFVWZmdDJnUEZRdElCSXJtS2lXcklvcVJJZHZCVWxHVDlqSjJW?=
 =?utf-8?B?VkRMVWxBWWlUcm1wNm96cEFEQU1ZR2dTaW1HWWlEYVBWYUlxTTFuSjRNV2Rt?=
 =?utf-8?B?Z1JzK1VXYi9PZmdHcTliSnpRNGlVcVVIbjgxTldiODNxbld5REh5T2tRZHpF?=
 =?utf-8?B?eU1KNGsrRzBEY055VTBKL1RMcGtROHMvbkZQenRYSXd5MWVXa3pHL0NySHU5?=
 =?utf-8?B?UDZHT2tnbXg2Q1Ryc3J6N3ZRNmt3UXJSTlZ0UkxCeWFVc1FBRTlVRXpYQjI3?=
 =?utf-8?B?RDZ3L1RLUHM0eXlsYkJyYWZRNUpKYys3UDB5bEtsZGVUVzJ3Z1FCNjArcEJw?=
 =?utf-8?B?SEl3ME9GRnJBd3BxRjFGaElJc1dHQjVjU0R2NGx6d3VQMCs4VDJnTElqWHpI?=
 =?utf-8?B?VHJlNzZLMlZ5d0pZbGZYOTJVcnUwcU4wdE5VR2gzaVhsYWREUjZKTFNtMlc2?=
 =?utf-8?B?Q25WWUlua0s1aWU3R1p4NmNjRzE5RUM4ei9CMzRJbGJ0QWlsNWU0a0NOb3M5?=
 =?utf-8?B?ZG84L3JuWE5xd3NQWjZuVWkyRzZvSXNVdi8rVllaQVBndTMzVnNtb2NvbFRM?=
 =?utf-8?B?ODhmRjhGbFQ2WTZOaUNRUi9XTWVtMUltdlpVTzJtVlloc3VWMXhjMGNYTmlP?=
 =?utf-8?B?TW02ZFZTYVBFTU55dEFETVVJV2hiS1JucFRlbVNYbmFMU1R6US9UdzFNM2N3?=
 =?utf-8?B?VXMzVWo0clA4bzlHT0d5UTgzQTl4TU1yRlAzUVdNclJ0b2hUMlpYeXNhQ28v?=
 =?utf-8?B?UDBwY1k4UndaaVBqNGtxMHhNbU5kUW51TjVyKzVITEliUm1pU0E4N0hVRWVO?=
 =?utf-8?B?cjhqU0FxWUpvNEsxejZiOWtBTkptQVJPbTVCSUgydWJqTnR3clAzMmVodG5C?=
 =?utf-8?B?ZjhoNHQzQ01nWW8xUDMxeE9LVkZsMmhnSlpVQzE0b3FwNDM4SGg3WGtwWllW?=
 =?utf-8?B?NGtwVjdFUlJjbFhoL2RNU0k1TlhPcllUUFRLMTFBbk5CNWlISnl4aVhZZDlW?=
 =?utf-8?B?bitJOXJ0VXJNRjhoMHZ2MVBZOGFqdmQ2YU1RaDB1RUZRSDlqWXpJRFlIMXNk?=
 =?utf-8?B?SUNPNnMzQVp2Zk92b09kVXg0dHBlWWtlLzNFc2QydE1nRmJzNkM2c0kwZXc4?=
 =?utf-8?B?VzcwbDFJd3hKSEhvRHQ0dnp2b0QralpKdzZzL3dnTGx3dkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUFmS3pFakxjcHM0cWc0Tml0czZkNk5yYm9BWXNtQXl3ZDdkc2FqSWhyd21P?=
 =?utf-8?B?UzZTa0FKUGNPUis5Mi9TeFpMeGhNNmdhNkdvMFcrQ1RvaFBxMWhKWUZWS1BZ?=
 =?utf-8?B?ZDZCMStZVUY2NSt1NXM1Kzc0RXhWY0xyVE9ramcxQm9qa0dNazQwQWpGbk1t?=
 =?utf-8?B?QnlySWxUS1RRNEdCTkFRdGExTStxQTgzK0RoQkdyZFljUS9tZEhtc0VwSmNX?=
 =?utf-8?B?UkN0SHhIUjIvd3RORHk4Q1g3bE9GYWVvLzZrODI4c3k4S2QvUkVHbTlBeFpm?=
 =?utf-8?B?UlJ6MW9ickFGWTBaUHZJcUxGS3V1cTJidlNRUVNSc3RhVG85OCt4SXZoOVcw?=
 =?utf-8?B?N0hvTzBnS25nMHpxcEZoT0lpd2VxcjN1MHp2RjBkK3MraFZjY2hmWGJleGUv?=
 =?utf-8?B?UlJMNStDQkxJYTVjNlc1ZHVVMVQyWkpyRDVqUW5yMTJKMWdwOWlIZjJtZjRB?=
 =?utf-8?B?ZjhwZ0Y0ZzczKy9GN2t1T1dncVBmSmZhdFhlYUpqTmpadEhoYVJoUVRDcWY1?=
 =?utf-8?B?aE1ZQzhidmVWeDhjSlBTaG9hZVhPSWlkem5kTkc1aENZUnp4R24reVVTUElL?=
 =?utf-8?B?c01MRDZIM3RuZExFdWNCYk9ia1dnbTQ0SkExM2s3Mk0wTXI5bkd4WHRqZUpN?=
 =?utf-8?B?RW1wdm9qKzRDNDBwZzN2ckFxZXlqdEVNSVRQWnc4ekVzYkZ4QzRiczJsUXp2?=
 =?utf-8?B?N0l6dW1qNFNSUktiR0pqaStuV0RacTd0K0I0OE1EQ0V0R2FWbDgxaG9YZ01y?=
 =?utf-8?B?SG5DS1lqaUdxMitveVdsRU1NSEprTkR5d2xYOWNuUGxhZ2gzVGNzTGJYeHI2?=
 =?utf-8?B?RGRWT0xiWngxVHdoMlZUNmV3Rkk0dCtmczdQNEFJWmlETUszb25FclRCQ3hq?=
 =?utf-8?B?TW40QVAvSlNUUTJhVzR3aWhBd1M1SVBSZTJNc2VqT2FZS2xMNkpsWG1NQnFj?=
 =?utf-8?B?dDE2YU4zOFVya0tyZzVmNk9mdlJ4R1VlSXFyZUsyaWNDWkoxb3FiYVJabWJW?=
 =?utf-8?B?NVRlMXpZTThpSW1aVDBGUTFkZW14aGRWS2Ztamp2RzROc0lRcTQ5YVMrdWUr?=
 =?utf-8?B?eFRsdExPem5TT1p0cE9pTHJuUVN0elllVEVZNUFyajJUSGlFZUI0bGZwbFVR?=
 =?utf-8?B?c0tjNy8xN3dqdTdJMTFXOGplb3Fib0k2eHVuaEVtUFhMb0pkYit6L1M5Z3gx?=
 =?utf-8?B?VUJseXN0aHN2MWxzZ3FVOU9yUUVlMVFnTjVrRXh2UTdlbmhpWFVncXVwUGNO?=
 =?utf-8?B?WkUrL1d3ZXdMbnhubnVTNm10bzdMS2lRZHBoUS9ZRkoxVGphS0FJR3VQT3V3?=
 =?utf-8?B?K3U2a3E2NVRJMXBaV2MxOVRUbU1WWFpPczNvaVNhSFJ5UDA5VXpESWcrZXo4?=
 =?utf-8?B?QW9NU2FpVWhwdS9GL01jY1NsTmZlbGlZSVgzSmZQOTRadkVIVWZGd2d0NFJ2?=
 =?utf-8?B?V1R0VHZKYVlwcm5yZjJ4c2NGUGJkNUZ6a1picGdaMDhoWFpKb3RXT0NaTjZt?=
 =?utf-8?B?eDlkUzZXK3FQQzdmL25kNHpxOVpNUTBLUWVSVHhQZCsvWUNDSVhvbFdYc1Mz?=
 =?utf-8?B?ZVVqcnNQZ014WnovWDJHR0Vxcm9ha3VTZWJOMFozQ1J3RHJZU1V1ck13YlRt?=
 =?utf-8?B?c0xkZkczbG90OWFmTUhRV2pHeW13d3VtcnhhczhwcTFqR1BwSEc0VmVDRElV?=
 =?utf-8?B?ZHAvbGJiOGhzVmtQNDZTMk5OS2VVTXJBTSs4aXNkajJXVE5NWmtjUXRQS0hI?=
 =?utf-8?B?enAwRWRuQmUrWWFvZTEyeVJ2NEVIYmUzUnI4d2tFSklaRlZwT09nOUlFWnhC?=
 =?utf-8?B?T1VRYkQrYzNxN01ZR0FNSTNUTHJFNWhZMWhsWExCdENRa1YrN2JSRVBRanFB?=
 =?utf-8?B?NUtlUkdVNXZVNnpCQndUSDA4SVlDV1lzREtCOHNMTHJtSjJkSStLMkN6UTZT?=
 =?utf-8?B?dnNwb2JGVmozTkdnZVpVZlh6WDJQTjBsOWFybUl4Y2tkd3htTmlEMXhVNGxh?=
 =?utf-8?B?VFliWnlWRy9tdllwYSt1WTMycFlHQWpxaXB5KzFZWDUrSmJzZ0I4L3dWZVBQ?=
 =?utf-8?B?MThlSXN2eDBPYlJKSGdzV1o4eFRJWDlHNEVLRWVISEZjYzhZVXRhbU5CbmJ4?=
 =?utf-8?B?dkZ2RmNBWFdLZ2lRL1FtY3ZJQ01HQnV5L2dTK3c5a0FjYlRHNjNsRUNFT0RF?=
 =?utf-8?Q?EAfVYWwIKs4jjBOWi8HdFgI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b8c1d8-ba10-4507-05aa-08de1a72a0b1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 00:47:55.9322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0A+/jKDwFTvayP1hFw+JBPO5FI1KYQU2arOJg4OC1u/Jdmy8kICqhR4rYBqoFAmrldsS4mwFUkACk4sGxQihpaqdY7rvtEanY/pNcElSYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6177
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE9DD40008
X-Stat-Signature: y96kccyyibm6djfq5ry7a5gt4dth5tgo
X-Rspam-User: 
X-HE-Tag: 1762130880-71334
X-HE-Meta: U2FsdGVkX18zRrzTilIlviVBFKCrmahDc2/L3/gP6MwqOZCrldZMjwtW3cva/Nu1DYIXOagd01sPRb1sz9BmJIfWoyuPFIKdpyi5Jem45ldlkIt5+nQz6LM/YAIjHSlp81oOwpaWD8ZBcbamtBEgH8nxD2gP+uKLUxfTuLuyd8BjXc/gwKkulu/cq7u7l0Cq8PV628XkAWtp4z7cYb0jrazq+bS5sskuxKn9/RBLIY9i6jGeeiQ8w8yIRUHgWpH8eyAPHA/hOntFKGIWIPx7HYTj7HLnHzo4WNlgEVztPLJGkb9AcagwOyslOJbBm1cZnVUbSZpkfyGf7NRdO6/obeQSzs0h/W+kJWva383nN2R/7NFMFJhJljUZjOGBykUV+k9OanbuNeXcxKKQ6MxDD2cgBw2mpcdy4PMFJ5ZX/VoNFlShIDLjRRkVknOh+1EJv2fNpTFkre6UoQUo4V+2zJEJ6n9168sdzElsv4EFdwkBApGk2G8e+dMyLtgT8BQEf24K8oAFcQPzpPCL5lHMrdOWAcLd8tdyr/5Hz2IOLiPvdLx9R6/cbrxeuL94OTwe3IjtKxrTJTH+FeKutWIzVZeTU2ow7ZX8flQUKgXBY1m5O73IbyedMZQIfQ0peTARe2VnSy27r5C7LkdHEC7iuoQeI3ScGmQKyvwy3Nl09vSgDVGHF3c6E/lGLWABMK13tGpdf40VgfDt3INygKhNP7wm9pIkk3TuH80G8wTWfAJ9A0v7xb4ey3UXJy9lzpfQ5xoOC/dLC90P/UgJJyAJ3uXx3o2Xx39257E15I47xWHqmoJ0nWd27uaSmlcl6UuwPBqVNquLN7PuGHqKcePF+hEiw6Lh79juP9OSYx83kupJaPUfzOt5RO7yV3yUkVBQjqb0nEe2Cu3GU07hEk7ia5kwI2i/p5jPAxSy1x7ufWgIiVCHmKevk/mAN9xoYTMGC+AtFubBAFZKtL9BYRG
 ptwzRBiO
 YfRmjX8ssJoXWXyYCOstrnorCZXL7nMf1NV9LQa0XjcIbfp6jqstxZ0YsefHAcZhoTcVL6c9f31L5Ml4DO/hLa+oLn0ySHcb6/nQMOr7xQ2zTS712zi2pM54IQvTJp17thzBXGLK1GHRE8FqaGlQ9UbWtpElnNfsX0Nr3ta44Hd2QBEDXKvAGraCaQODmX9wgKixZV8FJ/GcFRmT3SLcEuFwp5Gcb9Z89tRwnsj2H4u0FhPzbbiI0xaeuZSujT0AFQIgYHYW6P9+IzPbRimKFF9MLcAuTS7YWrKEHTjVlMn6hpuURBroCW3XZrGJMX6Dqwen3MXq3vDCD3y5kt7ZWU4I9xsI+zHzIEHMcWmrtQll7MKiyw+yNDb9/WVkG0yK9Bud+6ASnmzhFyR8It6AHe6GemeJkC01QHIs/nXg+6ayaid1h8+rgCMOY/hAnLio5KC6IK0CVPNNv0tLyqX5VjXTQGxH85R1zN/Q0cw17PVbTNqpW0PIXBpP2slySKsraGo2AUloRwYgHUc46pvMQr5bsDImx3CF0E/wX+xYLgelpB9DTqGgxEqpilLc9nHz6dsewCYhGiQPQrO0w3fCAmjLl1lgZ6mxQud4mGZ7NsHtBCrpn5X9N+oFt4S6W1JKB4KxKGUtG/p1BW31T+/h2A9h+/TY9NozGSd0bNPYbgH93HbMHHnWG0pzFfcZURBJM0QCyqcuBYDHEnqhJJtQ6tIviL3wwJIirerx+qutVl35BXyCGmNgJqWC0C6PH7n9p3sqO2sVX/scCwZWOTMy4EOSTjTj5tY7AGk9RBxNc2fCMbemfOPb5pXMz6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/2/25 4:11 AM, Ryan Roberts wrote:
> On 02/11/2025 10:31, Ryan Roberts wrote:
>> On 01/11/2025 16:14, Guenter Roeck wrote:
>>> Hi,
>>>
>>> On Wed, Sep 17, 2025 at 12:02:09PM -0700, Yang Shi wrote:
>>>> When rodata=full is specified, kernel linear mapping has to be mapped at
>>>> PTE level since large page table can't be split due to break-before-make
>>>> rule on ARM64.
>>>>
>>>> This resulted in a couple of problems:
>>>>    - performance degradation
>>>>    - more TLB pressure
>>>>    - memory waste for kernel page table
>>>>
>>>> With FEAT_BBM level 2 support, splitting large block page table to
>>>> smaller ones doesn't need to make the page table entry invalid anymore.
>>>> This allows kernel split large block mapping on the fly.
>>>>
>>>> Add kernel page table split support and use large block mapping by
>>>> default when FEAT_BBM level 2 is supported for rodata=full.  When
>>>> changing permissions for kernel linear mapping, the page table will be
>>>> split to smaller size.
>>>>
>>>> The machine without FEAT_BBM level 2 will fallback to have kernel linear
>>>> mapping PTE-mapped when rodata=full.
>>>>
>>>> With this we saw significant performance boost with some benchmarks and
>>>> much less memory consumption on my AmpereOne machine (192 cores, 1P)
>>>> with 256GB memory.
>>>>
>>>> * Memory use after boot
>>>> Before:
>>>> MemTotal:       258988984 kB
>>>> MemFree:        254821700 kB
>>>>
>>>> After:
>>>> MemTotal:       259505132 kB
>>>> MemFree:        255410264 kB
>>>>
>>>> Around 500MB more memory are free to use.  The larger the machine, the
>>>> more memory saved.
>>>>
>>>> * Memcached
>>>> We saw performance degradation when running Memcached benchmark with
>>>> rodata=full vs rodata=on.  Our profiling pointed to kernel TLB pressure.
>>>> With this patchset we saw ops/sec is increased by around 3.5%, P99
>>>> latency is reduced by around 9.6%.
>>>> The gain mainly came from reduced kernel TLB misses.  The kernel TLB
>>>> MPKI is reduced by 28.5%.
>>>>
>>>> The benchmark data is now on par with rodata=on too.
>>>>
>>>> * Disk encryption (dm-crypt) benchmark
>>>> Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
>>>> disk encryption (by dm-crypt).
>>>> fio --directory=/data --random_generator=lfsr --norandommap            \
>>>>      --randrepeat 1 --status-interval=999 --rw=write --bs=4k --loops=1  \
>>>>      --ioengine=sync --iodepth=1 --numjobs=1 --fsync_on_close=1         \
>>>>      --group_reporting --thread --name=iops-test-job --eta-newline=1    \
>>>>      --size 100G
>>>>
>>>> The IOPS is increased by 90% - 150% (the variance is high, but the worst
>>>> number of good case is around 90% more than the best number of bad
>>>> case). The bandwidth is increased and the avg clat is reduced
>>>> proportionally.
>>>>
>>>> * Sequential file read
>>>> Read 100G file sequentially on XFS (xfs_io read with page cache
>>>> populated). The bandwidth is increased by 150%.
>>>>
>>> With lock debugging enabled, we see a large number of "BUG: sleeping
>>> function called from invalid context at kernel/locking/mutex.c:580"
>>> and "BUG: Invalid wait context:" backtraces when running v6.18-rc3.
>>> Please see example below.
>>>
>>> Bisect points to this patch.
>>>
>>> Please let me know if there is anything I can do to help tracking
>>> down the problem.
>> Thanks for the report - ouch!
>>
>> I expect you're running on a system that supports BBML2_NOABORT, based on the
>> stack trace, I expect you have CONFIG_DEBUG_PAGEALLOC enabled? That will cause
>> permission tricks to be played on the linear map at page allocation and free
>> time, which can happen in non-sleepable contexts. And with this patch we are
>> taking pgtable_split_lock (a mutex) in split_kernel_leaf_mapping(), which is
>> called as a result of the permission change request.
>>
>> However, when CONFIG_DEBUG_PAGEALLOC enabled we always force-map the linear map
>> by PTE so split_kernel_leaf_mapping() is actually unneccessary and will return
>> without actually having to split anything. So we could add an early "if
>> (force_pte_mapping()) return 0;" to bypass the function entirely in this case,
>> and I *think* that should solve it.
>>
>> But I'm also concerned about KFENCE. I can't remember it's exact semantics off
>> the top of my head, so I'm concerned we could see similar problems there (where
>> we only force pte mapping for the KFENCE pool).
>>
>> I'll investigate fully tomorrow and hopefully provide a fix.

Hi Ryan,

Thanks a lot for the quick fix. I have some comments about kfence below.

> Here's a proposed fix, although I can't get access to a system with BBML2 until
> tomorrow at the earliest. Guenter, I wonder if you could check that this
> resolves your issue?
>
> ---8<---
> commit 602ec2db74e5abfb058bd03934475ead8558eb72
> Author: Ryan Roberts <ryan.roberts@arm.com>
> Date:   Sun Nov 2 11:45:18 2025 +0000
>
>      arm64: mm: Don't attempt to split known pte-mapped regions
>      
>      It has been reported that split_kernel_leaf_mapping() is trying to sleep
>      in non-sleepable context. It does this when acquiring the
>      pgtable_split_lock mutex, when either CONFIG_DEBUG_ALLOC or
>      CONFIG_KFENCE are enabled, which change linear map permissions within
>      softirq context during memory allocation and/or freeing.
>      
>      But it turns out that the memory for which these features may attempt to
>      modify the permissions is always mapped by pte, so there is no need to
>      attempt to split the mapping. So let's exit early in these cases and
>      avoid attempting to take the mutex.
>      
>      Closes: https://lore.kernel.org/all/f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net/
>      Fixes: a166563e7ec3 ("arm64: mm: support large block mapping when rodata=full")
>      Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index b8d37eb037fc..6e26f070bb49 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -708,6 +708,16 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
>   	return ret;
>   }
>   
> +static inline bool force_pte_mapping(void)
> +{
> +	bool bbml2 = system_capabilities_finalized() ?
> +		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
> +
> +	return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
> +			   is_realm_world())) ||
> +		debug_pagealloc_enabled();
> +}
> +
>   static DEFINE_MUTEX(pgtable_split_lock);
>   
>   int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
> @@ -723,6 +733,16 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
>   	if (!system_supports_bbml2_noabort())
>   		return 0;
>   
> +	/*
> +	 * If the region is within a pte-mapped area, there is no need to try to
> +	 * split. Additionally, CONFIG_DEBUG_ALLOC and CONFIG_KFENCE may change
> +	 * permissions from softirq context so for those cases (which are always
> +	 * pte-mapped), we must not go any further because taking the mutex
> +	 * below may sleep.
> +	 */
> +	if (force_pte_mapping() || is_kfence_address((void *)start))

IIUC this may break kfence late init? The kfence_late_init() allocates 
pages from buddy allocator, then protects them (setting them to 
invalid). But the protection requires split page table, this check will 
prevent kernel from splitting page table because __kfence_pool is 
initialized before doing protection. So there is kind of circular 
dependency.

The below fix may work?

if (force_pte_mapping() || (READ_ONCE(kfence_enabled) && 
is_kfence_address((void *)start)))

The kfence_enabled won't be set until protection is done. So if it is 
set, we know kfence address must be mapped by PTE.

Thanks,
Yang





> +		return 0;
> +
>   	/*
>   	 * Ensure start and end are at least page-aligned since this is the
>   	 * finest granularity we can split to.
> @@ -1009,16 +1029,6 @@ static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) {
>   
>   #endif /* CONFIG_KFENCE */
>   
> -static inline bool force_pte_mapping(void)
> -{
> -	bool bbml2 = system_capabilities_finalized() ?
> -		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
> -
> -	return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
> -			   is_realm_world())) ||
> -		debug_pagealloc_enabled();
> -}
> -
>   static void __init map_mem(pgd_t *pgdp)
>   {
>   	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
> ---8<---
>
> Thanks,
> Ryan
>
>> Yang Shi, Do you have any additional thoughts?
>>
>> Thanks,
>> Ryan
>>
>>> Thanks,
>>> Guenter
>>>
>>> ---
>>> Example log:
>>>
>>> [    0.537499] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
>>> [    0.537501] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
>>> [    0.537502] preempt_count: 1, expected: 0
>>> [    0.537504] 2 locks held by swapper/0/1:
>>> [    0.537505]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x24/0x38
>>> [    0.537510]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x0/0x40
>>> [    0.537516] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-dbg-DEV #1 NONE
>>> [    0.537517] Call trace:
>>> [    0.537518]  show_stack+0x20/0x38 (C)
>>> [    0.537520]  __dump_stack+0x28/0x38
>>> [    0.537522]  dump_stack_lvl+0xac/0xf0
>>> [    0.537525]  dump_stack+0x18/0x3c
>>> [    0.537527]  __might_resched+0x248/0x2a0
>>> [    0.537529]  __might_sleep+0x40/0x90
>>> [    0.537531]  __mutex_lock_common+0x70/0x1818
>>> [    0.537533]  mutex_lock_nested+0x34/0x48
>>> [    0.537534]  split_kernel_leaf_mapping+0x74/0x1a0
>>> [    0.537536]  update_range_prot+0x40/0x150
>>> [    0.537537]  __change_memory_common+0x30/0x148
>>> [    0.537538]  __kernel_map_pages+0x70/0x88
>>> [    0.537540]  __free_frozen_pages+0x6e4/0x7b8
>>> [    0.537542]  free_frozen_pages+0x1c/0x30
>>> [    0.537544]  __free_slab+0xf0/0x168
>>> [    0.537547]  free_slab+0x2c/0xf8
>>> [    0.537549]  free_to_partial_list+0x4e0/0x620
>>> [    0.537551]  __slab_free+0x228/0x250
>>> [    0.537553]  kfree+0x3c4/0x4c0
>>> [    0.537555]  destroy_sched_domain+0xf8/0x140
>>> [    0.537557]  cpu_attach_domain+0x17c/0x610
>>> [    0.537558]  build_sched_domains+0x15a4/0x1718
>>> [    0.537560]  sched_init_domains+0xbc/0xf8
>>> [    0.537561]  sched_init_smp+0x30/0x98
>>> [    0.537562]  kernel_init_freeable+0x148/0x230
>>> [    0.537564]  kernel_init+0x28/0x148
>>> [    0.537566]  ret_from_fork+0x10/0x20
>>> [    0.537569] =============================
>>> [    0.537569] [ BUG: Invalid wait context ]
>>> [    0.537571] 6.18.0-dbg-DEV #1 Tainted: G        W
>>> [    0.537572] -----------------------------
>>> [    0.537572] swapper/0/1 is trying to lock:
>>> [    0.537573] ffffb60b011f3830 (pgtable_split_lock){+.+.}-{4:4}, at: split_kernel_leaf_mapping+0x74/0x1a0
>>> [    0.537576] other info that might help us debug this:
>>> [    0.537577] context-{5:5}
>>> [    0.537578] 2 locks held by swapper/0/1:
>>> [    0.537579]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x24/0x38
>>> [    0.537582]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x0/0x40
>>> [    0.537585] stack backtrace:
>>> [    0.537585] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.18.0-dbg-DEV #1 NONE
>>> [    0.537587] Tainted: [W]=WARN
>>> [    0.537588] Call trace:
>>> [    0.537589]  show_stack+0x20/0x38 (C)
>>> [    0.537591]  __dump_stack+0x28/0x38
>>> [    0.537593]  dump_stack_lvl+0xac/0xf0
>>> [    0.537596]  dump_stack+0x18/0x3c
>>> [    0.537598]  __lock_acquire+0x980/0x2a20
>>> [    0.537600]  lock_acquire+0x124/0x2b8
>>> [    0.537602]  __mutex_lock_common+0xd8/0x1818
>>> [    0.537604]  mutex_lock_nested+0x34/0x48
>>> [    0.537605]  split_kernel_leaf_mapping+0x74/0x1a0
>>> [    0.537607]  update_range_prot+0x40/0x150
>>> [    0.537608]  __change_memory_common+0x30/0x148
>>> [    0.537609]  __kernel_map_pages+0x70/0x88
>>> [    0.537610]  __free_frozen_pages+0x6e4/0x7b8
>>> [    0.537613]  free_frozen_pages+0x1c/0x30
>>> [    0.537615]  __free_slab+0xf0/0x168
>>> [    0.537617]  free_slab+0x2c/0xf8
>>> [    0.537619]  free_to_partial_list+0x4e0/0x620
>>> [    0.537621]  __slab_free+0x228/0x250
>>> [    0.537623]  kfree+0x3c4/0x4c0
>>> [    0.537625]  destroy_sched_domain+0xf8/0x140
>>> [    0.537627]  cpu_attach_domain+0x17c/0x610
>>> [    0.537628]  build_sched_domains+0x15a4/0x1718
>>> [    0.537630]  sched_init_domains+0xbc/0xf8
>>> [    0.537631]  sched_init_smp+0x30/0x98
>>> [    0.537632]  kernel_init_freeable+0x148/0x230
>>> [    0.537633]  kernel_init+0x28/0x148
>>> [    0.537635]  ret_from_fork+0x10/0x20
>>>
>>> ---
>>> bisect:
>>>
>>> # bad: [3a8660878839faadb4f1a6dd72c3179c1df56787] Linux 6.18-rc1
>>> # good: [e5f0a698b34ed76002dc5cff3804a61c80233a7a] Linux 6.17
>>> git bisect start 'v6.18-rc1' 'v6.17'
>>> # bad: [58809f614e0e3f4e12b489bddf680bfeb31c0a20] Merge tag 'drm-next-2025-10-01' of https://gitlab.freedesktop.org/drm/kernel
>>> git bisect bad 58809f614e0e3f4e12b489bddf680bfeb31c0a20
>>> # bad: [a8253f807760e9c80eada9e5354e1240ccf325f9] Merge tag 'soc-newsoc-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
>>> git bisect bad a8253f807760e9c80eada9e5354e1240ccf325f9
>>> # bad: [4b81e2eb9e4db8f6094c077d0c8b27c264901c1b] Merge tag 'timers-vdso-2025-09-29' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>> git bisect bad 4b81e2eb9e4db8f6094c077d0c8b27c264901c1b
>>> # bad: [f1004b2f19d7e9add9d707f64d9fcbc50f67921b] Merge tag 'm68k-for-v6.18-tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
>>> git bisect bad f1004b2f19d7e9add9d707f64d9fcbc50f67921b
>>> # good: [a9401710a5f5681abd2a6f21f9e76bc9f2e81891] Merge tag 'v6.18-rc-part1-smb3-common' of git://git.samba.org/ksmbd
>>> git bisect good a9401710a5f5681abd2a6f21f9e76bc9f2e81891
>>> # good: [fe68bb2861808ed5c48d399bd7e670ab76829d55] Merge tag 'microblaze-v6.18' of git://git.monstr.eu/linux-2.6-microblaze
>>> git bisect good fe68bb2861808ed5c48d399bd7e670ab76829d55
>>> # bad: [f2d64a22faeeecff385b4c91fab5fe036ab00162] Merge branch 'for-next/perf' into for-next/core
>>> git bisect bad f2d64a22faeeecff385b4c91fab5fe036ab00162
>>> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/misc' into for-next/core
>>> git bisect good 30f9386820cddbba59b48ae0670c3a1646dd440e
>>> # good: [43de0ac332b815cf56dbdce63687de9acfd35d49] drivers/perf: hisi: Relax the event ID check in the framework
>>> git bisect good 43de0ac332b815cf56dbdce63687de9acfd35d49
>>> # good: [5973a62efa34c80c9a4e5eac1fca6f6209b902af] arm64: map [_text, _stext) virtual address range non-executable+read-only
>>> git bisect good 5973a62efa34c80c9a4e5eac1fca6f6209b902af
>>> # good: [b3abb08d6f628a76c36bf7da9508e1a67bf186a0] drivers/perf: hisi: Refactor the event configuration of L3C PMU
>>> git bisect good b3abb08d6f628a76c36bf7da9508e1a67bf186a0
>>> # good: [6d2f913fda5683fbd4c3580262e10386c1263dfb] Documentation: hisi-pmu: Add introduction to HiSilicon V3 PMU
>>> git bisect good 6d2f913fda5683fbd4c3580262e10386c1263dfb
>>> # good: [2084660ad288c998b6f0c885e266deb364f65fba] perf/dwc_pcie: Fix use of uninitialized variable
>>> git bisect good 2084660ad288c998b6f0c885e266deb364f65fba
>>> # bad: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm' into for-next/core
>>> git bisect bad 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>> # first bad commit: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm' into for-next/core
>>>
>>> ---
>>> bisect into branch:
>>>
>>> - git checkout -b testing 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>> - git rebase 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>>>    [ fix minor conflict similar to the conflict resolution in 77dfca70baefc]
>>> - git diff 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>>    [ confirmed that there are no differences ]
>>> - confirm that the problem is still seen at the tip of the rebase
>>> - git bisect start HEAD 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>>> - run bisect
>>>
>>> Results:
>>>
>>> # bad: [47fc25df1ae3ae8412f1b812fb586c714d04a5e6] arm64: map [_text, _stext) virtual address range non-executable+read-only
>>> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/misc' into for-next/core
>>> git bisect start 'HEAD' '77dfca70baefcb988318a72fe69eb99f6dabbbb1~1'
>>> # good: [805491d19fc21271b5c27f4602f8f66b625c110f] arm64/Kconfig: Remove CONFIG_RODATA_FULL_DEFAULT_ENABLED
>>> git bisect good 805491d19fc21271b5c27f4602f8f66b625c110f
>>> # bad: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large block mapping when rodata=full
>>> git bisect bad 13c7d7426232cc4489df7cd2e1f646a22d3f6172
>>> # good: [a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8] arm64: Enable permission change on arm64 kernel block mappings
>>> git bisect good a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8
>>> # first bad commit: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large block mapping when rodata=full


