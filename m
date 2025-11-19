Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA19ECF6488
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 22:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57616B00A3; Wed, 19 Nov 2025 17:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C078B6B00A8; Wed, 19 Nov 2025 17:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF1E6B00A9; Wed, 19 Nov 2025 17:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9576B00A3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:35:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A0F8BA782
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:35:34 +0000 (UTC)
X-FDA: 84128814588.24.A419A33
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010068.outbound.protection.outlook.com [52.101.56.68])
	by imf23.hostedemail.com (Postfix) with ESMTP id 808B4140004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:35:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OHtcrOZd;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.68 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763591731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYkgUiyx2OBmwpfniRctS/tjYwvXJ0RUUOZTKenATeY=;
	b=Xbu6zmHWO0jl7I5J/P18RUOZ1vFiVHismL59Z8xRUD9cubu96AWthe8CxGXxlVMW+9YMok
	p9tMrJ6A6dF0VYOQEIDGAOy1TfQWGzasWmT45L+7LaJ3ExePdNiUijQMAGWbxcFRYNZ70r
	ofwPB7Hh8IjWU/qeYSteSPLYkkXB7Ss=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OHtcrOZd;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.68 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763591731; a=rsa-sha256;
	cv=pass;
	b=aeB2NiHtL4Z3GbXRKNb7OsIkMbLqqQWluXZ1x7wFWnSVbgwDLsTOjaLMLBgf1nM0CbOx89
	f8xMgOkkOxyCo3Vz5yERmBjYuNoB/wgeYqwcKAuxPInvuZpEWQwuMzbLkWSQw7xaE9fP90
	QDF7fsSAUQmFzRV6a1IZmqMUDoPAzVs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rtTxvb/mO0M54/SFx9qBxZDC/kniASc+aQjUabUTgmNkaLH5yFZ9CQgvIWMnW6NbcDnYceqceG69s4yuOJLBVNIB2G4j31i1NQxGPqXK7aYF7upT2Irrfh3L8BvWxX7llG6wQ54fkhSI63JVLit0JaQBH3Pt9nnB0dt4itDss8bsSTorIDoBcSQ/YurxTMQNQZ7ThRewPeIsVfTtRwuMjiEtrs1zCLWcSCTeunz1p1LBYn6gK3iXZTjvjNZwzqVMVXJp0IS9LYDwSItPvjM0BwQRRRwtSblRqoVSr7Mh2sGZ7wMRGUtGExseA/OApx6QtqIgBc/mNaGwSwaHnUz+Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYkgUiyx2OBmwpfniRctS/tjYwvXJ0RUUOZTKenATeY=;
 b=ibCyNF2j1/hOR6ptVEgKkHn3xs8Ji7c12l9kD5HlKWrktUWYzfXrpU6UbkWKJEpbwe5l+jnS/99Pp6HBggZs3pRyUuaDjLmsmV5nH4ZTMHNzofAcgWGTisRksmpxnP7Bx0dLGD4ZzlzycSYCqeB/fHlmGNlERSfD2aq0sfgT/u7/3Cq5oF4WLEWawpJ59bOuSzdkKLr2LbB49cNO7rZGWv4kYYtn68GwWAsr7pcGINrjefQvYPT83sB8iY4Q4KCJ0r7GpxFv7oC/fpEu1+pV8HINFyL42si9rO3i/CxdqC62Nr3eeA/InKphs9CNbqXUfc3H8Dul2J/Gx6Lrkb94dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYkgUiyx2OBmwpfniRctS/tjYwvXJ0RUUOZTKenATeY=;
 b=OHtcrOZd877b5aFCCXHuVGENoYYiu8XHGSrEkDO1KOG+9ovBny7heQcSE9eYIHS6KEhcd2DiOQs/59z7SoYf4TkWedRPoiMV4I2gnHrSFLcLyktErkZ/BBHhQykEyAikghUKj8j03aDI03zta6gerVfpesrbYgapLAj1lj6wyQi1b3HWzLiWq6eUr//sprUshRiUEjOYoqPrvypCXaWIqg9JrSGkFVarvI1jboOIHuB0L0l3s2CzWLNrJQjgofQ6b1wTTPW0Yy4vkcfFlcWZlQy91Llv0EToN19qoXddlVydpKrR+4suUYo0ZLYXCWDaoCQxxF2X1GyVT7mw82Encg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by LV2PR12MB5920.namprd12.prod.outlook.com (2603:10b6:408:172::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 22:35:28 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.021; Wed, 19 Nov 2025
 22:35:28 +0000
Message-ID: <aac99648-4db5-411a-95da-f8d5daaae17e@nvidia.com>
Date: Thu, 20 Nov 2025 09:35:24 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-unstable 169/175] ld.lld: error: undefined symbol:
 shmem_uncharge
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202511200534.o4hsMNEt-lkp@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <202511200534.o4hsMNEt-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::9) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|LV2PR12MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 274e497c-d729-4c57-25bb-08de27bbf09a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0VROGpYYjhETFdCOGZNMDhyRWNXRHRNRkVtKy9FOXlFbjdHaG1JQldZaTgw?=
 =?utf-8?B?bWUrZE9rbTZUZURHek96bzlzZ0xwTTlnci9mK2llbVBDZFBXNWxLcE1nRjhk?=
 =?utf-8?B?dEphRUFrWi9iQXhMYkxyd29MSW9ZVy9jbGxrUFVsU3NXZzByQTRBUkhJemFt?=
 =?utf-8?B?REFhOVJqWkp5MWl5Z05ieTIybFo4YVdadDdWVjhOL2ZsSEQxcWFKRW5lYnh5?=
 =?utf-8?B?SkV3ZTJ4VnhId0FlQVNMa05qNGdrZFYwei9GVCtWWHEzQWxrYUV5V05IM09h?=
 =?utf-8?B?UTR0c2RtbkorTkZWSTY0VmNuV2lyaGsyRXhMZHdxVmRMV0Q2VytaYUhzLzF0?=
 =?utf-8?B?SjZVcmhzZWg0NDh3Ni9qMXJNMXlwQnQxamxyRWNUbko5RCtYMVdrQTdZQ25l?=
 =?utf-8?B?c1VBTXFVNmlYdlpRaWlyb29xRHNQMlJ2SlFFMzA4SDVSN1ZUQStTVnlBZFpX?=
 =?utf-8?B?T1R2WkJHQWdTcWdCQUxraVlQUE5OTjZVT3AyMWJGZG1nUjhzclFRMmhFNk1H?=
 =?utf-8?B?UnlHM0I3VFdmengxNzBaM1lPR29QWWh5Z2pWR3N1Tlg3S1NOWUlhS1V4NU5j?=
 =?utf-8?B?TnpFVDJzUmpHZ00xQWZ1eVkzUDJnakFST2NSckJxTFplZXFVZHc4aHlBcy93?=
 =?utf-8?B?bUdsN2kyZXY5NlV1ZkdpSDBuZTdQVDdYYWJwN0UxVTdiQllWQXVGb21EUmls?=
 =?utf-8?B?NXRvTUpnaTRDZVBjdUxKN05mL2gxNHBCc0QrK2dLSzVYZmxjenZibUdjSDA5?=
 =?utf-8?B?TERTMTF6K1Y2b1pwYkVjdGYzaFRvNWtKNWJKUlJXQnBVTXFjWERFRlJMK3Nt?=
 =?utf-8?B?ZlJrbEpUWFpONXdrZllQM2pGRlVDM1RMMWpFUmZkTVYzUnp4eTlDbUw4WTFD?=
 =?utf-8?B?azhsVDNUSy9tQmNUSGxNcWEyczZqUnh0d2U0a2JiSEdjOTZNN1JEbkNjcTAx?=
 =?utf-8?B?K2pOREI1czd6SXpLM1RmcUcwZXdUQUgzL0VZVGV1ZG5oQjhteDgvSVo0dHll?=
 =?utf-8?B?RlJZUEtxSnJVSXhxamE3bTVNZ1JFZ3FxL2VRenZPeGZOcEFvQktGcGNzSU12?=
 =?utf-8?B?QkNTdDIwWDFoSUxHUWRybjZaVWYxV3ZkQSszQ1k0N2dUWUxMYnRMRDdBZmxF?=
 =?utf-8?B?L01qWVlGaDdyOHE3Y0l5c1NWWTdyd1drWHloemFxdUxWcG41ajlHQUhsaEtm?=
 =?utf-8?B?K2p5TEJYOXNKWXFZeG9sbWovdHpIQ0hQZU5UR3F2bXZqOElmTkZpWENER3pv?=
 =?utf-8?B?VitFVHJITHNVMkxIOXdFMTFieHMvTklyQUVFNGNJa0FSUmlVSzZUMXlpb2l5?=
 =?utf-8?B?ZC9BYStZdGJFQkZqbFRUVjV6QTJJNitjcTdNQk50SUt2Z1BYdC9QMkJjUytY?=
 =?utf-8?B?K1lCR1dyS2pxN3VLSWpQS0dQVWhucUlsSDh6UGQreS9ZNUZTZy82WWhVc2ZO?=
 =?utf-8?B?ZEN5UXlOU0pVbkdoY1pXdnNxQTZXM3dqVFFSRlM0dHN5dWtFVkxkVSttYUMr?=
 =?utf-8?B?RU5keUJONmNHeTBwL0xtdkFxSHNQeG82TWZmS0FNc0lYMW8yZ2FtTHpDQjZs?=
 =?utf-8?B?MStQbmlTTktIZlltTi9Id1FGZDVwRWZsWnlYR2lwVnZkWFdIUkNuUDJUMGxr?=
 =?utf-8?B?ZGtKRS91aVFDN2RTYm16RjJhazRVYTNyZEl2ZWFTRFRaalorMXcrTFlxQWVY?=
 =?utf-8?B?c1A3ZmwvVXFiOEVBL1IvdXc3VFgxUGNBNjRSKzU2aTBQQksyYmpmaG1Rd2JK?=
 =?utf-8?B?Mnl0azBSUERlNVNncTg0VFI2eEI5blZwbVA1QVJTTVZuU2x3elMrMmlENHVB?=
 =?utf-8?B?NHBWNU8zMUNKOUtHQUFuRFRDVWJKWUc3eUVUQk9pKytXMVdaMHR1Q0hzOU9l?=
 =?utf-8?B?aFRLNWpQRWFNTHdGNzd2bGlzazFMbzAzNmZrOWhiak95cFVlOGRUSDFBNThl?=
 =?utf-8?B?NktwQjNQS2d1Z0RyRFdVZnI0NU9aQmZHSi9oOWNJMXcyWTVzRW8xSDRVVmJQ?=
 =?utf-8?B?UlBzcStlQjNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bG0yMTErTGlvT3FkY05CY0dzbVV6dyt0ak9DUEpLbDhBazFJNnRHMjVwNlFy?=
 =?utf-8?B?b0dhbHpidmpmZmVGVFBIejJjbGN0ZkRNSUVpTnZ0OFRTNG50Y2FYZ1I5NEVE?=
 =?utf-8?B?bjR4anpScFZRUnVwS01nS1dyQUN0R1hMTjNGTDVjclRMeVJFeDVYOFpscGsw?=
 =?utf-8?B?YkI3eWl4b1o1clZ6UFFVWFkwYkZ5TjZxUEpjMEJLdi9qVDRnZzVyNFh0UkhL?=
 =?utf-8?B?alRtbk12UXNaeDBEcWxzTG11elAzRUpvSEh5bXg3NjhXM2tqWmdFRkR4bTFv?=
 =?utf-8?B?OVhXNE9Gd0lhSVZnZTM5V09xUlZia21zN2xTcUJTVHUzejdid0x6alJiaFRj?=
 =?utf-8?B?ZEtZblYxUWdaNHR0bFJ4NmFncHU5aE9OdXRrR0tQUnIrYkFEM1RWcjAreFdR?=
 =?utf-8?B?b2NGVTFSUUEzWmh5WmJvWXBpSVg4S3o5bFJ4SUs4ekZGQkp6TE5TM0FOVGFq?=
 =?utf-8?B?NzVnTlZDd3h3TVZkajlRR0E2cGNSUWNaT20yNmRscDdOY0pLanNlVFRkaVlt?=
 =?utf-8?B?YXlpd0lCWGw2RHFjWVRWNzhFQjdBZnJJaWx4Z0lxNlJMdHFJbkZDNXplN0Nr?=
 =?utf-8?B?MUJyRnRacVpTR3h0Qzl2VzV4M1hsUlRoVVFiTzVscHp0OCtXQ0lqZ3JuN3Bi?=
 =?utf-8?B?bmtOWTVJZnVVNHBIN251N3o0MWNXQ0wvQU5hMlFuQnVkVFFDazluVEJJUmJC?=
 =?utf-8?B?cUN3UnRwQUk4UC91MERRaU9HbHUxLzFqOGtxRk1xZXNWaWx4OXlSZFF6NUVs?=
 =?utf-8?B?L3N2WGlyeHRvUHV0bkRGOWR4bDllSnh4L3JpWTNZelVvbm56aVZjNFI4OW41?=
 =?utf-8?B?a2JIVG14V1JZTUw2L3BPSXEwT3hFbWtsZm9RQm5pV3FHcjhzR29TRVl5ejRO?=
 =?utf-8?B?SC85UEtCZnZBNk5YNUFXNmN0TnYrQ2sycnhmQ1NkT2xHZWh1Yll3dkFKY0Fa?=
 =?utf-8?B?enVzbnRQNTdRK1NCN0dxZFVodUhNbDI3NUdXSmVyb0xwWjNFRVlyNlgwWGsy?=
 =?utf-8?B?dGdpSFEyN2FURzNUVHJwbUhuMzdPcTZScUl0Zyt0RDFyYVVQZkd4MW5waExl?=
 =?utf-8?B?MXB4Z3BmQnVjdmV2WitCTlR3dUNldXBJVkJTSmpxUUJtL1YwSjdXRXlNZWZo?=
 =?utf-8?B?Q1F6eTh1VURVaWk5NVpNM3pjWHVsQ0d4MlpGU3RRTFlYMEJNWnUzcVlqUFkw?=
 =?utf-8?B?NVhhM3Zqb0QyL1ovSGl3QncvU2xuZmZlZHNjNEZ0eVoxMSt2WHo4WERqbjhO?=
 =?utf-8?B?eThvWEx3Um43U3h5UmNzSUphTzRrZVVZVU5WcW5Ock1qVmhiWUtYQmpRL3RP?=
 =?utf-8?B?MUlWakdtZzZ5OGRjWUxLVXVRY0Yxdk40aGtNOGo3bWVSSTBoRXc2dzEzazU2?=
 =?utf-8?B?Q3F0azJoNlNjbGgzQVVoQjA4K2Eva1NuWXNNOHdJejJzclY1VGJyRjhiaUVv?=
 =?utf-8?B?bmNvYldhb3pFN0pMRzNMYmVyTmU0YzVVZ1RFaGlrYzFSb3cva3RQN0gvTnRy?=
 =?utf-8?B?bndrNkZ4V2ttYVk4ZW84bVNnM0lISTBCN2lYQXlpY0VBRzNZNk4rZ1FQOWhx?=
 =?utf-8?B?ZHlwU1dlanJndUt2UE1qWjdaM1l4RWprcmxRRUJwQ24wSlNvZEpnMFpsYjRI?=
 =?utf-8?B?RHlRcGF0czVQbXVjWU5SVG5BcXM1ejBvY3lGN21NSVdmR3U0T0RJbm45cUZE?=
 =?utf-8?B?b1FMeHUvZWMxdGFsc1puRm5PdmFzWTJXWXAwcHVXTXFudm03eG1OT1hVallU?=
 =?utf-8?B?Sk1vVHNEamxBZU1vVFp4a3B3ZEtWMGRJNGN6WThEaXJJTXJQaGNaeEl2dVI1?=
 =?utf-8?B?MnFpdEFOWTAzcmxaMUpWeUxCQVo5dG9BSTBlcGwwcXB0QnNpTWJBNCtsWWd2?=
 =?utf-8?B?SVo5aTNKUlF0Y0g1YTBxeGFWeXM1eGxRbU5BS1hEbENWWlZIbDJyK1pydGEw?=
 =?utf-8?B?Sm5HOTkwSzBXT25QVWdEdDhWaUZYNXhUeHlQVzNkOHpONnpQc29WdlR6Zzkx?=
 =?utf-8?B?WHpwYldiNDFFVzVrSUVCUlkyRnQrWWkrL1paTzlKZGhsaFNWTUxIeGNpalNt?=
 =?utf-8?B?RnFOQzB0dStKYmIrZkxMUnlXckMybkdwODVOQVJ6V0J1M2FoVjk2ZUhFOWxT?=
 =?utf-8?B?ZXB2RTNHWE44eWdlbHQ3bExuakJGMmUvN3VuNUJZbEwvTndrZnJCM2pxNW9K?=
 =?utf-8?Q?KQHL2FgDGWesXCVqfiAeftGR3BiNODNOnJSkZS+/p8XT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274e497c-d729-4c57-25bb-08de27bbf09a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 22:35:28.4238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5rkXpRdac3x+dBgwSxqu5fyR++fKysfyADW+dWEvnsGV5qDnLOBhVhrKz3gQhvi8ufRBA/7r0c6xNdnsT9CqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5920
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 808B4140004
X-Stat-Signature: jmfymqoh6azs8fxgbe6d6aj3n3dur3h5
X-Rspam-User: 
X-HE-Tag: 1763591731-878136
X-HE-Meta: U2FsdGVkX1/kczxuV0Zo8fADTgkM5dlVzJG7pre3O2KvO3TW3aVQmqM/vf/IkHW/blmj8JrxsYPD7ftPo0f5vvmWBAGMw4FLDyxQfsj1qcWi1IXGDGf7TB1R4RMvbzN544OSEB+evttf6zB9clmqxT4+uYsNZbNGmhZFmnfGqNuLFjsxOjVklBRTO5E0Xv/o3aK2xmDvGBK+kzZvA99kkPHFNth8kmCCfNGm3E71pV1kXudZvCnZrXnF5/az2hdPysuSstFT2lArzqx20jXtLzjY1iKCH0cXEfXzgPn0L4FQ6/Q0qeN0hllHl5zqCFbmYEELDpPbi7NZnpruIpa/5D6dMkRv3K/gOL73z0I4jxPNRYpAjW5voLC6kOFQvJzdPDhKPMwEchLFdjJZ9+lPV+6/KUeUYPRhYBGdDchjpaiDXEoxVjwvxdPdm8uLMhzxbCibrMaL3SSSltnZ6BQ8frO8kZDikKx0CdVuEt95o14ES2zewRHtqo41p26usdmmcgQ5cKKx4IFJrjnhvLE4KhR1m2vEzz4snfCZ/drfnuN+Kxi6TrSnBhk/9/egcJA8yj0c3yktjmvTWKRic/K8IFKiBnUtD8VCnAD1KziLzWB/zXe6cGaAbGsZiMOBbVENytebUAzl9zDhl+yBgLmWUb247d6xgTILDXlxEQjNa9FWKmd94MppmiNwXN1t6vkVMO0QKy/Z+juHOay4wYGuhB61+hCoWRfyIqUcPLgZ6SgW31RUWOzdvH7wUtvzd8tvYOVBaO8MLT3mIC6Qevji9ztilovUB9lNat/bt2BXrb7N8usYnB2pLG2JD6PgYuAi5slglFxxNFcr1VGB9ixcyudu4V3utlfZF1IWOagYvbTSQIhL66dj5P2hoiN888qpURu/GOxDfhNc7fo/WWHHtmOgG9Gy2oz2s6z6QxF17w0njuDN98Z0P0m+Rlwt1PCICMIDl6m2NYjLA1R0xhJ
 zF5yPVJr
 rTWCDvZjc5gEpqdVw/TR5GmMrz6tMZdwefy7IrZhu7g7JdGCJHDdZPlDakPHIim0irIZYEFS4MNUS4AKr/5dp80prgvfcgal7JlyJ++vchbKQzlke3ASf5lmqpTBy+a7cRux2O3KU//Nvn8e7xdhztDdmrXV4CjUdUtqNcFD+VSG2Pc4I11aTlm7liNR029sjN81dBaCY9+QGHTpz7Fl+A92jgzoFwUVve1XhhZFscbn/7oudc1IfbuVeXgpZ1O+IjhTNKn7yAwc2HZycuLkioeJbywBrCwYphJar8iV/Va1eBNKujnkDzLZu7siNSI+vMDAL+H0VQewnfzrNG48LK1UyAHtpzFjlKJzrmEEXOPIetedXiF776TkZzyUrxrweaH20N2VNIyqFXEEaWHLQg2SIR14dk8A3E/+vEidRVYwRVpGy2B7Fs/B92UszeVCGcqocppoJJMbAcffWmQ62SwVh3GygVgqBQo2Z5xuS7cMjsALu98BxEhdAtDI2E+hQVHKfLtXoG9w4VS2hkRcmYKqfP1BixGrtjd1G3antYGC2M2A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 08:26, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   102494e6776f316b6cf2924976681d790f278cf1
> commit: 9a655bd0773b41af6d8515502de102544f3ec4c1 [169/175] mm-huge_memoryc-introduce-folio_split_unmapped-v2
> config: i386-buildonly-randconfig-002-20251119 (https://download.01.org/0day-ci/archive/20251120/202511200534.o4hsMNEt-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251120/202511200534.o4hsMNEt-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511200534.o4hsMNEt-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> ld.lld: error: undefined symbol: shmem_uncharge
>    >>> referenced by huge_memory.c:4053 (mm/huge_memory.c:4053)
>    >>>               mm/huge_memory.o:(__folio_split) in archive vmlinux.a
> 

On first glance it seems a bit strange since I did not change the use of shmem_uncharge, the
computation of nr_shmem_dropped did change. I see the config has CONFIG_SHMEM not set, I wonder
why this triggers with my changes only.

I've tried reproducing with clang-21 and the provided configuration without any success.
My command line was CC=clang-21 and LD=ld.lld-21, but I am going to try with the script mentioned

Thanks for the report!
Balbir




