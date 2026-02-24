Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3E6F357C5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D3D6B0089; Tue, 24 Feb 2026 12:14:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164CF6B008A; Tue, 24 Feb 2026 12:14:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FC96B008C; Tue, 24 Feb 2026 12:14:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4D856B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:14:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98DA8B6F6B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:14:43 +0000 (UTC)
X-FDA: 84479999646.05.14C39ED
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010041.outbound.protection.outlook.com [52.101.201.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id E9226160003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:14:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ReVWd5Rf;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771953281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+57v9Rn+lwqivMYwjWLh+tpOKOe7LRj4R3wcxKulock=;
	b=gho9vqgPZLsIAMvvyftqhhHqi1b2v5VS/BKxKyVRxmk8GzFxYtDb0a9cBDnOASuMKNV94j
	bn1TYCRlMq+t09LjyIRfuoIHn3i/4HqPF73ZyDFqpwyx/CBevDeVpTeKMl0FPtu6OygdXb
	ddg7YncJ/a8Qz8g7v957o2OQ3trHQvU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ReVWd5Rf;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771953281; a=rsa-sha256;
	cv=pass;
	b=c9qEECU7hsir5e3IefLbL+nNpQdI9VTD1OhvOxCzQCcTDehqijpxHXj8WM6ADBIn2rxMJl
	ABSGAVHwwS/GJ/0NCvgCp9v9sbuTiE0E6b9TODmx8ONoi63pBqJEqWSfIaHFLXWJ7ilNyu
	4qoo0/1YVjia0c+e64PeT3XTPjCfPjI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nbXf81yhKSIf4+gAL7u/QwA/54S9SusYItETWbeyfLGTVKZuloHf81lns4FOEsDmB+UbX4nYrk2cYsrGEpoPXWtsDWr+RJXixrkBKqL3ApTkCKg57/F7bQ7LTQdn2+eszIqFtgsTjftmJvxQTM26AAl0nBCzbk+wLuSZzbYN3NdvnCgGz9c/emB5J/UFASVuSZ9DMmfQrT0F+MrxEEJi8f5wsxb/nsOozd+d2s690wO3PgRj+OHyVRnfYJUZPrvJv13FIWWyzi4xd7QEqmZZzHKVfaxfOFApkHLVl74dR0Ckoc4zxtoG2NQwaQbygbEn/rcLcvQT6uK/SkMYn3HytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+57v9Rn+lwqivMYwjWLh+tpOKOe7LRj4R3wcxKulock=;
 b=gjtzojsZjZIuF75JmFut7gAfqeppobCMcPnxm5VSlFhDgZlyC3kNnsTA58EGoG4fXSr94jQSOHo1hszhcXGfvwgb1Y103PbE5FGivOJRaCeopR6+QJwvdOQDHBJMvLhSufCAJnGhZl/gPoNiGGTfqKN4UKyAT3lW1jRmL5Cz4OpIE0kot9CoaQQVAdJEyInADVKnIsoiuYGX3DRVL4P4Qg5utvs96t0w2P2CiGcf5IuNQSBlfkDtVGFj+cv7Fi1jboxJ1JTjMR0q9zOgwVrFSejqng3wnZtHJDmGgU5/PaYWaeEfW/X7KgAwKZaqorXtmxVEvrVirEMVr9j5NUOfAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+57v9Rn+lwqivMYwjWLh+tpOKOe7LRj4R3wcxKulock=;
 b=ReVWd5RfsPjIeRzUoUdEK6iSM+rrIjo2DrGendpdBu53+6Cl2qoQFHfxfNVpEcEES8qgtGxTs+M0a2cfBk0pUdLhFPmToI7yeXutAukRAGWmBRVAoS98ndg84IsRL/83U6t9PJKgwVXpLCtnAGImqws/7FTB8DXtzxxNFr0Z2yrvZHJj68LoDIWyJtjsFmKMHz4q9ziZwsiOUzIBHwxB8VvLWfZDT0iZOwvswiMr3uv/aUdwD/otrk0HxjVj/p74nswAKrW7bA3L4k7IBMGYD+RybJXriDdMFF/EQ1D++/bAGp01oLxNl8fR/Q25qjZSc9NcGyDBQ1LU+Wh2gOSBxA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8009.namprd12.prod.outlook.com (2603:10b6:a03:4c7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 17:14:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 17:14:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <davidhildenbrand@mailbox.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Ron Economos <re@w6rz.net>,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, jackmanb@google.com, jane.chu@oracle.com,
 hannes@cmpxchg.org, willy@infradead.org, muchun.song@linux.dev,
 osalvador@suse.de, sidhartha.kumar@oracle.com, vbabka@suse.cz,
 claudiu.beznea.uj@bp.renesas.com, Mark Brown <broonie@kernel.org>,
 akpm@linux-foundation.org, pjw@kernel.org
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
Date: Tue, 24 Feb 2026 12:14:28 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <78D36EC1-2596-448A-A939-0A1AC7B3D1BC@nvidia.com>
In-Reply-To: <1966378802.577797.1771952827516@app.mailbox.org>
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
 <13b8d60d-1209-4650-9fa5-982381c53512@kernel.org>
 <1966378802.577797.1771952827516@app.mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 950b0a8e-68eb-431d-8a96-08de73c82f95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b01jemV2QlZ5RCtZRkFXdEJkZWpIM2k5ckdCSkUzT211MDZsanVwVm05NHFv?=
 =?utf-8?B?MjAyZjRBc3BtclN6ZXRzUkxNUmtoNTFXK25xNjg5MzdZTktlYVN2V3lpeXIz?=
 =?utf-8?B?b1VXRWE4YzcrNnI0UCtEaE9ncjdtUGpyNnRkK1VVLzRoSDUwMjk5blRFbVdD?=
 =?utf-8?B?aTl1aXY1M1hzZGlwRmVzTi96bk1YS2dRbXI2OGdQaEVJb0F0bmQzTE5SeWFS?=
 =?utf-8?B?dzREc1IvY2Y2ZWF4OFdkSWVBdnVQUDk5NEtPWFpzV1lydjZ4U3kvT2N3c1My?=
 =?utf-8?B?NkowYUR6NmV4K29GZzRyQVJLWDVCZWpkNXE5SEJ2RXZIU0NCYWNhcXVtTzdY?=
 =?utf-8?B?TmRCdVA3QjBjYXhXWExQNlFSZkJBelFoWGhSS1I1YVBKcm1FWEVOM2tvQzAv?=
 =?utf-8?B?Q1RBblRGK2xBdFFBQi9zZE5JL21XNDVCdXhVZHE1cm11RXhqSVJjUTZUSFNm?=
 =?utf-8?B?WFVYL0tkdjV3azNDaUtxRXBZK1YwUDBtTkl0Kzk2YU9OdTAxNjVpbmtEZmhS?=
 =?utf-8?B?MjZGeVNtUUNRS2crMCtiM0xZdlQzTUlkRk5uelVEc2VZbFkvZXdHVkZCU09H?=
 =?utf-8?B?THhZNzRHSnhzSHY1UGswR1dvOEpOZ2I5WEZxNnA2ZnRFekhVZWlWVFZGNlpX?=
 =?utf-8?B?cmF4NUMrbkZFejZRTVh3YmorazVlbkxsZWF6ZE5hUHd1d0c1RWxKejZ4bEN2?=
 =?utf-8?B?ZWQxSTJxaGpZQXZRS3o5OGZ4bk15VnFBdzZDYVNZRmhxc24yNWpkN3ZydHJF?=
 =?utf-8?B?cm5weUhGdXVMSk1OVkJlRjFTMHo1Z3huMVZJNUx6WDg1TXdOc2YydU5RWENZ?=
 =?utf-8?B?UmVpY0k5dUFOQWJtNHlhbnRGWWZzUjIvOUx6RDcySDExbmNPYzVqcjBZSytJ?=
 =?utf-8?B?emhFcFAzMHZQWlNRbFhqdG1Ua2FRZ2ZLanB3WFB1cHc1djh3enoxb3hRTk1E?=
 =?utf-8?B?RHhTQThiVmFRN3d5T0hWcThYK3RBQ0d3Y05CTy9iSXR1ZkVwbTlmNTE0K0p3?=
 =?utf-8?B?Z0xGakJ2d2NQUDFpV0YweWY3YU1tUEtBYlhMVGtlMUpkTHFrSHg5SHY5UlpI?=
 =?utf-8?B?NkZnSGtGTStPMm1NTjBtc1VwT1ZCaDk5N0lYVVNWU29VTjlMTjB4Zkk3WFoz?=
 =?utf-8?B?aWlpWHZzOXpKUnJZVytiUGZFOGRzUzM1VXRFK0dKZEhJdTgwNTJOeXM3T29l?=
 =?utf-8?B?OWNqakh5WERLdDFOMnV2bnhvN25tUmhkcDh1elArbGxtV29kdTgvQXVIV3ZR?=
 =?utf-8?B?STExUGJ3YnVpdW5uMWptRHlROFFMQkd1SmdNWS8xdUJLQ1ljMnJTVzI0eENr?=
 =?utf-8?B?NU1wWG5ZYm84anBLc1dhK2l3RUtxOTI0ek9jL0dRZHJ0dlpoeUtaUWRFQkpj?=
 =?utf-8?B?elFrLzgycnRpUmdRVHZTUmRSOWdpZHA2eHlyNTNUTzlMd1lOTFdVUDIrWk5Z?=
 =?utf-8?B?WG1Ha29EMDJCdlF4SkM4YVR6MU1GM1crU05rcFNFb2d4bnpDM0VJSGdjZ2hH?=
 =?utf-8?B?UmJhLzUwbDk2ZkJQZHIxYmFOOWR0RWVFbFpKZ280OUxFRnNuUlRXRHlTLzl5?=
 =?utf-8?B?QlRKVkgvUkkrU3IvWXpMTitscEdlaWg0MFduL01oaXhiUmNjdlhUdGlxWTdM?=
 =?utf-8?B?UmcrS2trV0ppQ2x6NHJocTlUQU4xQ1ZVbHIzckMvZVVlVWNPbTRYTlNXVkwr?=
 =?utf-8?B?aFQrc0Vta1FhWlVxL1Jmd3B3d1R5SkRJMU9wZmx0QWdnb0lueDVXUUp4RGdS?=
 =?utf-8?B?UzhUcDZRZkw0dTZhNkE3WTlXbHIzRGtxWXl2K0Q3SUdMUGY0MlNUU2R4d0Z4?=
 =?utf-8?B?UjRDQ0hXYktmYWYyTXBqMXFTNURFUC9SWWlLZGNpbnBrU3N4U0pnZzl6L29x?=
 =?utf-8?B?QnlHZXoyV2RaajljQWpqZEVIdUljRnZRc2tSVllITjdnU1FnZ20wS2VYVXFR?=
 =?utf-8?B?L2o0YWdGb1dRVzE3d0wwaWJRTUh2MzZxamV6YWxFVy91Mi83YmRoKzlWUklH?=
 =?utf-8?B?QllCdjVmaE94dTRIZFM1TmFrZjlFc1RKNXNJUzBpN2FIRjhJRHhGRnpDMkJV?=
 =?utf-8?B?SzlETWdWaVh5TE5qUEIrVlBFSEJNeG5wUjkyRnBiZWJ5NmtWWUdzalhRVy8x?=
 =?utf-8?Q?nqUc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDEvdUZRYWJuc1F6TkJ5V1VVbzFLb0h4ajNQZ2M3YlFqWk9IQkovcnVZNE13?=
 =?utf-8?B?V0s0U1dkV21BRmNqSHZ6TnhDS2hraEY2QlBLZU9FYlU2dkFWbHpCQXhYbTh6?=
 =?utf-8?B?dW5uTU1YQlRjb0NlTDVQWU10YjFVT1pLWUxjMVYyVkZnNTBlN2hvTTdkeDZt?=
 =?utf-8?B?d0tIRm0yWXNxMzR6eHlVSG1zSjMvK0Uza2VFV0ZFdU84S2JJVm5wc0dQVEFN?=
 =?utf-8?B?eHlHaDJ6eFF4a05TMzdPejE5Q2tzNWFYNCt6ZHpWbjdCeTVreGpJeFUzQWxs?=
 =?utf-8?B?V1ZKSEFMVWN4bWJ2K3dhbkIreDZ6V2wzNEorMUtqWDNScjRzdG80bGhMZ0No?=
 =?utf-8?B?MXhobjNsRmdqbkJFRG1JMEhJRTJTa212dk1LbDhudDhmU2srdG5FaHNtZWQw?=
 =?utf-8?B?TFVwRStNWTZ3TzRZU0hUMFd1eGEzaWRLd0wxZXFOWGZXdHQyOUhuSkZFVjhY?=
 =?utf-8?B?S0V3OGNSU0VMU0h0VS9xYzhhNExucWtSZXVoZ0V1Z2xvcU5pK0FZMjR5MG1z?=
 =?utf-8?B?ZUVkQklydGxzSjJyN3ZubDU3LzFkaWM3QllkZHdPUm1XQWtMWnhDRDA1Uk91?=
 =?utf-8?B?M0JQL1UrWFlkUUMvbUpkQmtOK3p6djJHNVArYitLTkhjUmpnRENaV20xbksr?=
 =?utf-8?B?RU4vRzVlNUNDRlRXNWIzd3B5UFFFMFN0U3JCcFlBNFBTbUFMK0d3WFV5Q0c2?=
 =?utf-8?B?UGtkaHB6ckR6S2xNMFUrU0VtdjArRUVWcTNSMklYdWNySnlXbDg0V2tlSVRG?=
 =?utf-8?B?SjcvQ2FJcUxHYmNpNFZzbVdPbzlvcVY4L2hJYkdqU3VPQ1ZZNXQ4NGZwUW1F?=
 =?utf-8?B?cWNaSEw4TjdOa3RsUzdMd0I4TmpGN2d1WDlhOUhVd0x4Mmd6dVRGaWdTZlBj?=
 =?utf-8?B?a28rN1hLdE5LTXlEUlk2L24ycGZnKzBmbExtTEVpUlVoRG5ublFjOERveUpL?=
 =?utf-8?B?NEdld3NOcWdGZVc2ejlkd054RDRGQWd6TU9EckF3clUwcXFkNkdibHFtS01K?=
 =?utf-8?B?MzFIQmtMUVZHckxUZFFSbmdOeWwweUczcFVWZjU2dGRScmMrMWJjV0FBTVVO?=
 =?utf-8?B?OTNZY0k5b2FJVGRnbExvUW9qUTQ4R0t6Vm5kV0EvMVBpLzREN3JkS2Z1SUNH?=
 =?utf-8?B?M1FFbjEveW9MVjBuUDBpbGRrVnpaLzBqOEtNbCtsUXZpOVB1dFduT1JzVzRv?=
 =?utf-8?B?dkFXQjIxdFluYm1pUmZzUkN1YTRTOXpqaG12TWM4VVV3VTc0emFSYnErbXRw?=
 =?utf-8?B?TkQydEI0YjFOREo2SzhOZXBzUDhiWEJzeVYxd1RhTHU5cWZzMEtUOE90d2tn?=
 =?utf-8?B?UzlZM0toYXhTbHFmR0FUdWR0YVkxQjVKWGY0a0FvTEhqTTI0OEFaWDJ1c2cr?=
 =?utf-8?B?MHVrUGJmWEEydllLeXMyRWFIa09lVnV4MGo0YXcxZTB5bjJKTTdiNzNDWGZl?=
 =?utf-8?B?T2tvVU9Xb2FOQVRZTmErdUwvRCtiaGZQSkhLSUNsRTRzbzBqQW9UUDF6a29N?=
 =?utf-8?B?T1l5ZTlhSjg0Z05CVkNsWXRjRWRRYkkvSmpJeWovR0tsa2gxRk8zVDd2MEFr?=
 =?utf-8?B?TEN3cGpMREtINkdCTExhZksvaGdNUjh2dlZqUlpzZkoxUlBRT1doMU1KZTAr?=
 =?utf-8?B?Q2R0a1BGV2hpdU9mbUJueWloelgxTUticXllaFBWQzlnY3YvVWlJaTd1M2Js?=
 =?utf-8?B?ZlNYTDZTZWE3TkdVcjd6L0V0QlJyUkRjQ3J6SlB6bWlYWFUrNG1uejFlVFJH?=
 =?utf-8?B?VmgzZ0JNYjQrSDBXWG9LSHhoSnpOZlZ3TjA1Vjg3cTRQVTFGL1N4bExza2Vr?=
 =?utf-8?B?VWRBcDQ3ejFrUUJ1VFdTT3g2SmZ4akdiYjFVRmtwaFRjOTZ1Z0pwVlRrNzlS?=
 =?utf-8?B?bWRqemVIYVYzNUswUmxDWXFETTBFWFBrb2RoMXFsKzBrZ1I5eVJtVzZrVWlX?=
 =?utf-8?B?a3d1d0Y0M09FSTBBZlZCQm1mRDRKYWE5c3dYeThXWkNBN0RRNVlzcTRDN3dC?=
 =?utf-8?B?TE42Q1RPMjc5Y0Ira05KN2RCdGgrKzVzZFREWTZDdUlCVmU3Smt5ejRMU20r?=
 =?utf-8?B?dmluZlBQSndyQ29EUmdLU1VqSXlrTjh6aXhwSTFjbU5nTEdGcUVIRnpzdXI5?=
 =?utf-8?B?WEpyYk5MaGRESFRkcnBqdWFQMis2a1hzMmVrQVJ5MXBJK0ZCYTI5L2U1c3R1?=
 =?utf-8?B?aDdlN2ZMbkFlalIyblFIMGErOCszYm5PNUtJM1hoQ1h3TXhZeHNZZzFnUi94?=
 =?utf-8?B?M2ZIdlYzMVhvaEI2RkJXRWdFSmNJNnpCMjFJS3hnVGZCcm96VjBsM3lVeHlm?=
 =?utf-8?Q?grIKtY9whNV8bYzcIY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 950b0a8e-68eb-431d-8a96-08de73c82f95
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 17:14:36.3888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmoEOzW+6wf8FE2nw15sq6Kq0utEyGcrIqTQzmA9nu3HjMi2V2RJgF+STrXiaZu6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8009
X-Stat-Signature: mpoq1cbbg8hyj1j79fym6gizzae1tu1s
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E9226160003
X-HE-Tag: 1771953280-235414
X-HE-Meta: U2FsdGVkX1+FRYfAAqshGyqMX56v5Bo/2wPJKgEAnxNaXtWPeHYlNwD6tqfexGVSzqBpUwxFt/80KWZLryAeLrJgbZ5IAQUIBY6UxzKU/+svbBIh7+a0ueq3YAfsDgvOIUGzuulxRya1b/0WmckGoZPkh0pupnmc5ZqW/Sb7sNRdsqPSXHpyiqZCGgA5AWSgjFOJU5CRMq2rBdFeSpGRt0s5b1PIf7yxceV1Z1nI/p1g9xxr6/jEMeXFpADoyPD79P6+71YLpZKFq6RQXsF4xFS3al5vU9bdWoiKjD9JvLKA/IH/ohBj8R7lDYeOoGJjl9G+5ucWMhcZP+WoEXUyHpB+mrZfCcIlQViZTj/C66TseJOWaDnLxfOzZmYq3L5hWZvUzEOgLB/IitFoj3av2ukR42nS7G9J7EZLS9feeoHLe+dG06/YspIPBvG50wcAirK+XT06Z5DqcJmOuMcp4hikfLKyytyqf6RazjtRRDvXEklv5qimFI3gHCxF2076edFZ/evwA161nAzaF8sl0we3pUTV8LNbHX3ok+pQpDtIKd5++4amOqtKtfJwXAGk6ChSxFag1dnvKESBlYF7hPpAqghnYqox3CWnqAwbyvSSod6BOgvkrUKTwab66FHZsuzvFuh+TUMgWe1B3f6arouAfYQxJek7BDtQDKqDHgXXpFFJsuLderzyircSZBQrAU8ISZig9VQv/4i4iIBUbdZ/SZSX/ikAf6SM1WexyP7mPcT8eDdFbNQ9z8rkEk43vsTZ6tK3LRpT3k1tRCU53SRRxzH2Y37yDXmjVfvHrLLmYuF+1vZ3aO8+HUNbTRRFdgIMzsN00BVwRCVh1y0FHWjAvpaz+GzbUReYqqLmrayHE7z1KkoHkGhHOg+D9C4yM9k9PLfUJtONjh99p1CFgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Feb 2026, at 12:07, David Hildenbrand wrote:

>> David Hildenbrand (Arm) <david@kernel.org> hat am 24.02.2026 12:00 CET g=
eschrieben:
>>
>>
>>
>>
>>
>> On 2/24/26 09:37, Ron Economos wrote:
>>
>>> I'm getting a BUG dump during shutdown with Linux v7.0-rc1 on RISC-V.
>>>
>>>
>>>
>>> [  OK  ] Reached target shutdown.target - System Shutdown.
>>>
>>> [  OK  ] Reached target final.target - Late Shutdown Services.
>>>
>>> [  OK  ] Finished systemd-reboot.service - System Reboot.
>>>
>>> [  OK  ] Reached target reboot.target - System Reboot.
>>>
>>> [  173.985249] BUG: Bad page state in process shutdown  pfn:f8850
>>>
>>> [  173.985311] page: refcount:1 mapcount:0 mapping:0000000000000000
>>>
>>> index:0x0 pfn:0xf8850
>>>
>>> [  173.985336] flags: 0xffff80000000000(node=3D0|zone=3D0|
>>>
>>> lastcpupid=3D0x1ffff) CMA
>>>
>>> [  173.985365] raw: 0ffff80000000000 ffffffc501e21448 ffffffc600f2ae88
>>>
>>> 0000000000000000
>>>
>>> [  173.985386] raw: 0000000000000000 0000000000000000 00000001ffffffff
>>>
>>> 0000000000000000
>>>
>>> [  173.985403] page dumped because: nonzero _refcount
>>
>> So, we're freeing something from CMA in cma_release().
>>
>>
>>
>> In cma_release() we iterate all pages to decrement their refcount
>>
>>
>>
>> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
>>
>>
>>
>> I would expect that this would fire already if there is still a page
>>
>> referenced.
>>
>>
>>
>> Are you running with CONFIG_DEBUG_VM=3Dy ?
>>
>>
>>
>>
>>
>> --
>>
>> Cheers,
>>
>>
>>
>> David
>
> Thinking again without my computer at hand =E2=80=A6 isn=E2=80=98t the ca=
ll completely optimized out without CONFIG_DEBUG_VM?
>
>
>
> At least that=E2=80=99s what I remember.

Right. Without CONFIG_DEBUG_VM=3Dy, VM_WARN_ON(!put_page_testzero(pfn_to_pa=
ge(pfn)))
and is_check_pages_enabled(), which leads to free_page_is_bad()=E2=80=99s
=E2=80=9Cpage dumped because: nonzero _refcount=E2=80=9D, are disabled.

It seems to me that someone else bump the page refcount between
VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn))) and free_page_is_bad().


Best Regards,
Yan, Zi

