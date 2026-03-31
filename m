Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 647A9FF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE2D6B009F; Tue, 31 Mar 2026 04:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C960F6B00A0; Tue, 31 Mar 2026 04:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B845B6B00A1; Tue, 31 Mar 2026 04:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A70EA6B009F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:51:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48B4D5C98E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:51:16 +0000 (UTC)
X-FDA: 84605738952.28.9348175
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012049.outbound.protection.outlook.com [40.107.200.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6C01DC0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:51:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U1bDJT63;
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774947073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynem5a0wRYzFxDjYh0aXjXDg69SxX9j+hhlyB7/OIXY=;
	b=biZuilzvljhrJk3/KbrWWfu2fN82bvCXLjNPZq1pa6XzKi4RV+HkQK2XbKVGw6Zb3Zeyqu
	GKDXRSKdq3x7mcGQ+a4xY8xU+2C3LcfHwsEJchWyOrN0rTa1600EGoi+V+Q1KMMh+g0up7
	RAUsboi2uR7j9Bi2lLklshZ6LZsqBLg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U1bDJT63;
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774947073; a=rsa-sha256;
	cv=pass;
	b=ITnhgGfvTWPLYpwyxmeK7g6W02VWERqgMHThjafWF/0wWdxm9tWSbzZ0zNghaGajYGZKhh
	hmT2n9fbBeObBN1w6Na+zKgAsIgSbNxwGFYVrJtW0ynQq5kvRn/WGaeI4sPeTlgR2Kh9x0
	FNpZqNDifI3QNMuuUxVCWoRgI2qAeoM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ArfnFvbxxp+D6llzbgeiSrUXdRxKUolDD2FiJ/mMucB42rF6crZDzsEulD4yvdji8VNsTGetyfH7vCcGKBHO7hDJTx4rCP1u5t6iUNhuaDveYNPPmEL8t4sjtEmTvqzJkmW8nmP2YrbOyAvNT/JrUQ1uD7bVhcL8D26wLgiQN58a5S/u+bpy3A3IcMTEnB1NlG3bPvwMnEned6moKtZmTHiB0jBciw5kear9wJjVfznLwCcO3RGwSW1ca/m3wWGSVW6WLIBybX2VDrvFc+kRx6VeMZsMxrTD7K+s43hiLw/DkFvC5Gtal51azpHZICJLzIsLUqueEuHDt5L/K76SZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynem5a0wRYzFxDjYh0aXjXDg69SxX9j+hhlyB7/OIXY=;
 b=fvNAcYivcg4wOXKcEacqtXs9xwiDRBSRqn4FsT0w2ZNL8PhXNWH0ihDJWI0QmrzUf4FI3Xt99PryfTyXkJRGmtFFykXC+YwQgXZzdd00qYeoup0dSZ42kNuREH15loGyIaVVbb8PJ7n6r/h6ry4EUuxyI/ebpeuPiDNbzkT0BKFtB+4EOoc48OT/9uEU06nLHLBEFLPpnGoVFbE6UOjadICorlojCX5lRMcDAcyACnClgYNY8dZrutLwv8vEOWJ1YLshSl/JO1AfwwP4/tOPCFvnOHJINNpqeYW8dfLHhNmS5DCOnMTpowGBF5RQ/i0DDD38Z6LB8dp+CslWaoiOGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynem5a0wRYzFxDjYh0aXjXDg69SxX9j+hhlyB7/OIXY=;
 b=U1bDJT63uxe3nGlMrQUnyd28cj2vc6lv2H5uSLoylnNPBnp9QiZg0SAMUaDZvQFInMGZk6q0C7AwievDJZ2rmnYP0EDrjVFf9WFr7svazn0lzzJj9FF7Esv8lXlmljiJ2Usfz9N+1cutT5XvFuzrbIdqMo1wK/qFPtyNcyIs0LevtmEEg48j/QvAi+budE1tWSYAUWk1k8EtSFOZZibJlXNVbNCel981b1efjf5dns56Rr7BGg9O5OpmRrrCaAmlApahHw0DBZ0LW83WJRGaIyqnZoBLb8AwW30enkVbkGCuzo+sHtuZX+FZPgCiBjLUIiYwvOqJmstKrY3sqkrbWA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA1PR12MB999228.namprd12.prod.outlook.com (2603:10b6:806:4db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 08:51:11 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 08:51:11 +0000
Message-ID: <9426cc7d-bf27-4be8-afe6-7c123324655d@nvidia.com>
Date: Tue, 31 Mar 2026 19:51:05 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] selftests/mm: hmm-tests: don't hardcode THP size to
 2MB
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: zenghui.yu@linux.dev, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 david@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 dri-devel@lists.freedesktop.org
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331063445.3551404-3-apopple@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260331063445.3551404-3-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::20) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA1PR12MB999228:EE_
X-MS-Office365-Filtering-Correlation-Id: d4c2e789-10a4-44c2-47eb-08de8f02a875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|13003099007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AFrjbt45PydaM+Nmnf9kWTr4wOmwXxbFgmzyLS3IM1yRk/q+c4dc7EksIChUWRlmYoFQgp+fQhBRCiucR4HvIV22m1faIZf8fe0oj9o7cTTDtNBA3+DrcEGmWp6bT4kYUaW3p7r6BV1kpnygTlEwtzvmY+E1V0STdin5JhV+sSK8GNVj0uzVRyJoGArvutsqyYYB6x7IZMmulPv7ZRns++z1yOnmDSAjGqu9MEkC3pxD+M9vH+i+NSMFckhObMgjfqTtutczEVv+5sy3qAUp7zdbbjqgaNSVghQrot2tZVxwCucTdVtCShNfxYc5nKF2Q2j66XZ4IBlsjPOPXQufMYTDmhV2Mvae9WtryZVPxRkJjj2ZeuuS+rPCPKWsurDxeQ2O5uIYXvrJOEY4RTZclPJUpb7uAwwLYTU2+k3obPuRPPj9N1VImUO6tcV/dKiMTQHr7BBeprDYI8uPlYsdxbqGhhrtd8GV76cfDwe/9+ZZ6ZAT06cMCT1bQXWxwCMdbV2DR3qwsnG1V9IJ+sho6d9Pfc0OO3c+jvLV5YU+Yoz/OQHebMUste5sKODVDPhNUIVnhETOKA+ILN3QmniJAfClFbo7vzw4L+UL1aE4j40hbhB9LKpE6Yvvs/Pf7GukCrNEJQhMjxODLPZ24H1kBaTALQChlIMPXL/4zPx/xyXzRxPv/AF2Hon3xWQc+QmHMeUry4B2OY0ZFNmJIq8Go3dluVMfxtiOO598v0WLvG+FTwektBj+eK30gqAdcpd1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(13003099007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXJ4R2lPM2ZuMlJYRko5RVF0YkppeVdnTERsTDVYdzNCZ3B3TDJPWngzUklL?=
 =?utf-8?B?S3kvOHB0QXN5U1B6bkh5SGwwSlNlb0M4WkY5UmoyZlJSVW9CcUltdVhnV2E2?=
 =?utf-8?B?OHJkSEFiSWkvRmJZcGVNSjNPSkZ1SXA3eFdwV3NyWDRlazBTM2ZmaElXQXhB?=
 =?utf-8?B?SmwzekR2ZjRBUmwvVTNtZzRab3VLMDJ1N3lzd2VrdHN5RTZwc0lwQ0RNckRF?=
 =?utf-8?B?V2FXQWhxNC8vV2p2OXBES2sxSG9xdFRsazdHUTRBKzFvZ1ZRY01BNmJLQWxx?=
 =?utf-8?B?ZHhrRWFsMnJ4OWdwbU01b0xFYXNVcDVuZC9oRTVhS3hTazRmSHI4TVJ1Smlv?=
 =?utf-8?B?QTlQUVRvOFhjdndBbFFiZ1oxaGYvWlRMY0Y5VDVydmlWV2NScHNOa2RtMmZU?=
 =?utf-8?B?YkQ3YzB3STdWd1dYRFhXVXpTV2swM2hpdkxaK2JVcHZjQlZmZHRURGlDVzhK?=
 =?utf-8?B?ZHp6cENxRWdKRW4xK25wU3BkbXFrTFBZdW96QWN6NVlYUEIyL2FjUWNOVENv?=
 =?utf-8?B?aG0xOGVXQlZjRHl1Z2d2Y3Bway9nOWIrbW9XY1dXSnVhdUhCOTJnS3ZzcGlu?=
 =?utf-8?B?Rk9DaFdmZUZqZ28yK0tXSUNJRDB4eGJKWnNtWXY4dnYvejl5elcrc2NSemI1?=
 =?utf-8?B?WXlDZ1RyYVVoRGEzRkVlbTZIaHJCeHFMdWVKaFZVUUNUcFE4aEhyQXZCMSs5?=
 =?utf-8?B?cUtQWUplR2orYnRnTC9WRHpsSXZCb3ZKdENNZ0o4aWxoK25aUWxGYisvSTFT?=
 =?utf-8?B?M3BRL0x1bUw0M2oyaEdoNmhyRnNPeFlhS3c2dVZyY2pyc2VTelFKc1FJV3RC?=
 =?utf-8?B?WERUOWZGNWtpZHpiTGw1VjZ4NnVKTTFRVWFiL0Nza1c0cEtVL1Uwa1UvTlZm?=
 =?utf-8?B?ZG5acTJkZnJjQkFzUzFuVHhaWWROR0NsaElOV2JCdGJYcDlNWGZnRW5VbXln?=
 =?utf-8?B?RzlCSFJsaFFSRXlVME8vdUg4NlVGZGxqRVZSaVNTdTlKUVpnQmhxS2JFRHhU?=
 =?utf-8?B?eGd0bGt3RUoyVlozaERJS0tyNTZoZ1YvVDJyUDhnL3F1VnRnNVl5ZVJnU3dO?=
 =?utf-8?B?UStSMWJIMVJWazZPTGtScUxwUmRuLzJzeWkwTnEva1hXNnhYaUozRzNLTkpr?=
 =?utf-8?B?ZlplOWdDVTM5WU0zQ0NCc1laZkZZRTJhMFhjdkEzMHhYODFOcTI4cDBWVWpi?=
 =?utf-8?B?a1JTTzNCbTd1YnJ0emdSYlF2RG5QZ0NyUkFGT0MzSk05MXVsYlNORUxybkdO?=
 =?utf-8?B?dHJNaDIwREJoOUlVbHh5d0l6S3dGUmE1eVczMVpmR1JTcnZCSzIzNStkcmoz?=
 =?utf-8?B?V1JxR3c1REh6cjdKOWo0TTVPLzhvOERlMUtoZnFlQXZuOXpXdTBRaXBEL0Jk?=
 =?utf-8?B?WjJkNFJIeCtYcUMyamdnL1Jla21HcUZaTnJCSE4yMjVGaW9vN1JGb2dwbVpq?=
 =?utf-8?B?OXAzQzIxTTJ1MGkyc09XNmM4QUhTdWdRVGtTaHkvTnFhS1JXZHF2NmdaSWp3?=
 =?utf-8?B?V3JjZ1dwQi9mYXVUK0VaRjBlTmFLOExaMU43RGk5TkZaVGJVMDg0V1RONWpt?=
 =?utf-8?B?WGFKeHVsMnRmb0IvTDZSalk2aUdyaFN6V0lYQklUNkxHODU2ellJb2czVUs3?=
 =?utf-8?B?TDlQQ1RwU1gwdEo4V2RENmZwb1Jub1g4RU14Z1p2VFE1MktrMndnekhicXRR?=
 =?utf-8?B?MWhCTHlENVQ3a0VoN2hUSlJGSStKV3lKNXpPTnRkZFBGeHlZcDdZQ0xyZE4r?=
 =?utf-8?B?ZEhkVWZ1cFB5bzF6bzBUZFovVnpVZGczUDhRTjBIMTd3NGRSWm05YWFBUUhE?=
 =?utf-8?B?cFdKd1A3cXBSalFhY2VqK0liT2kvcTgydERmYVFBOWpRVERsRktNMm5uUm8z?=
 =?utf-8?B?Z3VIMm02RjBselQrTmQ4ZEJsVVN3VEI2M2NPQXNMRGVrdkxrYnVUVmdQc0VV?=
 =?utf-8?B?WGt1WUNqYkZmTVpXajkwM240bTRLcGJsaUhkWm9lQ1p3QjlzZmZ4cUJqVTdS?=
 =?utf-8?B?RlFJWGUwR2FSaXlxTDBZbVlYS0ZsclZtLzJYTHhqOGNRL1BnN1oydFg1L1l4?=
 =?utf-8?B?QWMyK0kxMGU3Y3oreWlVdzdkbVpFaXVDbzVNV0cxK01mTkx5TWJhUW9ZdXAy?=
 =?utf-8?B?QWkyLzN4alB6aUZ3dFhCUHY3eHpQb2NscTNYRUxXOTVMVkNVdW1OYmp4YXZ0?=
 =?utf-8?B?VGxYbkY2YmV3RlUxMVJUa05zbjhYZGQ3dURKS3NueEpmWFIzY3d1emlqSnFD?=
 =?utf-8?B?TmprdDFHc1R1S0hDdHBiUjJ5VzNYd2RpTmZPSHgzMTE2ZGs3L0tKVHh2UStM?=
 =?utf-8?B?U1A4WlpGWVdrc2JERWhGbnltNWt6K1U5cTJwOXBVbTN1YUc2V2xrdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c2e789-10a4-44c2-47eb-08de8f02a875
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 08:51:11.3614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0/lFJcw9StwfOtu8o+sLdv1fF8eJXy4O6HUqJAM6cxyPqyuvZdZr+Seb2aIuCWBXep4T+Q+7garCjuwNhdOLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999228
X-Rspamd-Queue-Id: 6C01DC0002
X-Stat-Signature: 731dhpwi8p1kbt8t5qq9x5z8ip4n5kpn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774947073-852198
X-HE-Meta: U2FsdGVkX18ugFcNaxpsFwRkRUCMk37QBTlqTjtgzDPXnUxB+ZA1l6hkrfcmtemepHAluddaVwy2s5rz2gLBOMP+JYEC9tcVg+XdfisTnfECxYqgQXFiEuTrNuiFU9nLAaixZBlSwZYlh85406uLsfifJ0Ifgeqqx4y6Gqee0vMwVa4ky7RYhdZoMfDJXynquxPpzgFQLASTD17mo9ynGpmeO50BDFGwVzuLmailGPyO1jkSPHIYbvwiPWABZefVriwvcjM6ssGaNnS4VxOzH6gKsmsa5eZC03myWFTJWg3HbJz0MbcERYXetO/zO4ebEWUI46/31YhmgwojvvhCQGh685XMNcRHOYXXaDttjTtKpk+JUOZu5TxCFSz0R5nJftHHQY4x0GIg4Htwl8ezGlF7oGroNB+EoYN612ou/smB5QR8RH16AIvM9ObBLvS5n8Xn0JVq+HZVevbchNzKDc40R9cgCX7mSeuxa18SmeQc6A6VfMK/nknpRHiC+y/lMfNdL4JZj0kRV6n5RViWje+9truM5LtqbLmiAzqZAYVoa7fW+Auj6Rl+90J7G27QtPziSAFdYYrKGJTZ9RWtHTSTrmDZroBK+mLWPeCsFb9jr0HC8XM9YumB+ruSzg0WyXWiLjVsmdf4G9gDucR2uk9ogLbHqE9QISWN6aEcJkSPPwfh1fnf9IG/rn4lkNJMUT6ThSqp7i3tCRx24Wusx/PO+qr80CED2JiTwClJeNME/4mZ6GB9xA26B3MXUfFXjNaxcYLT6TJEpXLP1E3fBRggzjJhEctcc/8rDgPoBlyQJpR3BrvPKnW+mbKX74grGLEm8CGe3oYTWyz+A/VHyV0GLouhUBmMEfz3oHHVbYCZwPXCjggv3OHklJ2Wbe7zvZacE4nAWl1PDLjTspwGypS31l4WOsS8jiVT7meqPCk/jkhfNc5zekOuosTySLRE8eJi4c7CL3pslxBauY9
 3cWJNCAM
 d6cb42KOC8XK/06BDB2yHvG8bLRZb3bBXludduTz613IYeKH/43PsS8PT6/aK4AkqctkYjXAjsEtqzUwNLZQ0VO0XUehHM6sTsUdPqnpbYL/qaDLtu8u2LtHlvZDAbKAmqvsUOOeiq9cRp0oABhRWRQ8RQiPoXmm0MT90jT9/WJ2gBVhvj5UUY5oI94IvMUTLC3b11AEnu7PHEhjkW25XZvBe3yeOgaSWM3fe2hhbY8ZqzsxznBI2bptNnjfxkCfB8dgFtuFR6em1JUcXJdIBxhYMWnvruj7RtA8HnpYqyUptAq8LrGSnti7zhXxXoB0LyLy3OYMzwxSKANy5mZmeFHRVQsNMm4c3EEt6oUn+gox00p+H3Oxphl7usoEi7IyxsapK+lC9P0mzqkMqSh7kHyCN5DJXebtqe2Fonsl6MwjK+7oKMtG+ZXifL4UhEycZBffKUt5APcX47dQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 17:34, Alistair Popple wrote:
> Several HMM tests hardcode TWOMEG as the THP size. This is wrong on
> architectures where the PMD size is not 2MB such as arm64 with 64K base
> pages where THP is 512MB. Fix this by using read_pmd_pagesize() from
> vm_util instead.
> 
> While here also replace the custom file_read_ulong() helper used to
> parse the default hugetlbfs page size from /proc/meminfo with the
> existing default_huge_page_size() from vm_util.
> 
> [1] https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> 
> Fixes: fee9f6d1b8df ("mm/hmm/test: add selftests for HMM")
> Fixes: 519071529d2a ("selftests/mm/hmm-tests: new tests for zone device THP migration")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  tools/testing/selftests/mm/hmm-tests.c | 83 +++++---------------------
>  1 file changed, 16 insertions(+), 67 deletions(-)
> 

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

