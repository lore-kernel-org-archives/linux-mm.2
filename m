Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430BCCD484C
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 21:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC158E0008; Wed, 12 Nov 2025 16:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493478E0006; Wed, 12 Nov 2025 16:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381BD8E0008; Wed, 12 Nov 2025 16:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 273798E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:07:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6A0F896F9
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:07:14 +0000 (UTC)
X-FDA: 84103190388.21.613F478
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012065.outbound.protection.outlook.com [40.107.200.65])
	by imf05.hostedemail.com (Postfix) with ESMTP id C596B100006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:07:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YDani8Q4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.65 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762981631; a=rsa-sha256;
	cv=pass;
	b=vSsayCCHORd6fFf6T6eOfGvFwFlqiKlZUQzdMoFIdTFyhQtYiiGCWS6INpuN/pXahY5PMQ
	o7jB26jirsogCFhw7T9Iow7lGsS/x1rI7hOdT4Sgq7y1d8miHeEXARwm+xXg3uMvZaZ5iC
	e3nWO3LOZ3+VTABKNbYRsWbHX9ZNPBg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YDani8Q4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.65 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762981631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sa3N97XtPsFGet16mD6gFTeUek+gC2POKEaf4P/tyQU=;
	b=skfnuW4DASJR6StguCiPdnKsqJRalq4XOx6M98khHXLsDdF34hQyBV6ngtG/gPTN5oO4Q2
	J/GvDVk0LdTZclIrSUmQjHbp20JlLO/q6eD0P1VpKlAaPCtOhN45jxGX9ddLHmHRYxGbL5
	aqC5LK4ovhqt2RMIm9ogDq8W6AaLvq4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aQ2oyhHnZY9xIwetzD/7USdoWzMYc0rGK8vMnY2COpT1ZQ+OJP34atAIsW8AnRrDlbQW6dTjGq09VZkXCJXIkAcYIMRuddfmkkyZx4n08CrpeYJzQ4+q8p8dt61GhpDQoCfF5taarRf2q2u0YLcK2JFBgcXuVdUVyfCJgsUQHhXNwH+KN5u8NaFNw+xn1sMAle8LY1Q5nvqeH125uEkxuyV0OZu4U92bw69sqBh9gHGbDV3qX2ScfjOEGQqLLREfZWQtYxRtCo3xCE0MKR2DADj7BWaYfhap22pClNTj3k/qCyH0TVSpgjSPu0ywN7Rt9PZCevKrIcBRX7ci//Fn2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sa3N97XtPsFGet16mD6gFTeUek+gC2POKEaf4P/tyQU=;
 b=H3nPbwXEDSUPVMXBbbf9MlfkQ3l1x+dKLOAR1uU2DNj/cUA5lIx1D2fMtggh9JHuoqZlLuzF6qwk6Duu6OfmCcXqEOdSl+Y+SBmxrS8R9KYmsgw5Lu1k73ixHvTVLNmGe3EVYJkIruyHbpXp1jl2p4XTy+OvB+BroXV4aqjY0IJa+nu7KeJdLxBmT6eMwbJBk1qAltvExm/iKKcXTEdtZIASYMbU6Ndye9EHXlWBlFFS6ifQsS3pNm2Hbu//FQ9Rn8AaANoawAUVtn9wyaek2XE0x//HIxcKtZOroUZrsy1jHtk6MHOWlKrWKbXhRiVMDjn1N6HLEKqNjfR4q8T8LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sa3N97XtPsFGet16mD6gFTeUek+gC2POKEaf4P/tyQU=;
 b=YDani8Q4GmeRbebzpjPnjD1HzIkTZ/R7MweHVsaeUxKSCO0WsUty3lGh8lSvrwmJsLu7WIrF7rYvWxnOAZ3qZQCSYWZtp7a1b/20RGGbMG913Iq4JyeQEy2UnSiMZMIIGRAr6uPgwXxiY48x6qEsCDZDZBk4beLZ5m7rg3AERe75ROOBfeO8OsY/RRyhfWEJgMzb6zG/I5/LmCuRbj0abUuT7a6HEUb9Eb2pEf/rMaeCYiD1wbTeVKiwC3rl2DPbW+1ZQ0hSWpJw4BS3rltP426RsajsQWBjzSzuKzUphMECsOXT/cHCpFwWxWS7Vy7gj4EINltIYiCsY4+i3dePew==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ2PR12MB8876.namprd12.prod.outlook.com (2603:10b6:a03:539::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 21:07:08 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 21:07:07 +0000
Message-ID: <096d8a22-3ff7-4ced-b58f-458f9826c7da@nvidia.com>
Date: Thu, 13 Nov 2025 08:07:02 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: softleaf device private fixes in
 remove_migration_pmd()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <20251112044634.963360-2-balbirs@nvidia.com>
 <c5ebefad-2b1c-45c1-9a82-17a024d52d1c@lucifer.local>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <c5ebefad-2b1c-45c1-9a82-17a024d52d1c@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::29) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ2PR12MB8876:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e01a908-4d47-41b3-a4a7-08de222f7055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFBsYndXYSs3ejExRnZOS25MSmFucFpMMzFKbGpzRGlpaksvbWdkZFVzdStY?=
 =?utf-8?B?NHlYNWo4VWJEckZkSGIzSXM3c0Y4dk8yT2xINy9pMWJaVXJXSGlKWXhmYVRS?=
 =?utf-8?B?QVRaQkpUWU52NncxblVFN291R0ZPNGFZNFdPVlgzMngrSnB5L2dGY3ZVM3ZI?=
 =?utf-8?B?MUY0QllMWkZZVnBIQ1QxKzRSQ3NiYzVMMTV6Sk4zRm14bm9Ea20zclRyeTI0?=
 =?utf-8?B?Y1FqS3NqbE1CdDh5VUtPQW53cEZRdkJDcCtSeHlrNzF0bHd6RmF4a3llUkRF?=
 =?utf-8?B?bzM0K2wyZzh0Y1diNXFtWFZ0dUlXVEVuQWUzdDMzVW9KU0R5dHA1aG1BRzI4?=
 =?utf-8?B?N2VaSXNPa1Rnajc2YmRvNzkvaWlGUW9QZS9lWXpFZmdBaGNmSnUyVmQ4a0tJ?=
 =?utf-8?B?SFV3R05GQnNDZk9PMlBwQ0xiME50MUtLL0szdkVMUHRab2hCUUx0SnMzS3Mz?=
 =?utf-8?B?U000RlUxMzgzVUlCZFl6cUNUQysrUGNod3dHLytqbkl0OVkvRzliL3pBakNj?=
 =?utf-8?B?aXJ0YTB3bFJtQ1R2TGxyNElPc1hDc2NRR3k0MVE2OEIyYnhlR1RhZGRXNWUr?=
 =?utf-8?B?R2xLQzhzbDlvK29WVDRVMEVUcGVnaHRRdzdSR3hFME1Ua0Z1eFowUTM0VFZN?=
 =?utf-8?B?V093ZytzQ0U5ZDUrZW1FZnFOalg0TTMvYkdOTnpiUXE4eGlCTXpUK3h3aVRF?=
 =?utf-8?B?MFFIVHhJb2hWRFYzMWxBRkhQUGJ0VVY0L2Q2TVlrNDZFMnYyQVpOOTBqcE5N?=
 =?utf-8?B?dzNyR1ZxdFJ1cy96L1FqT3hDT1o4MFFuZ1QzMFhYSU1iS1pmamh2d0lXL3Rq?=
 =?utf-8?B?V3htQXNVSXIwc0tGOTBYS0dJclQvd2d0b0NRZXpTbS93bUs3TGxjYzFnT29p?=
 =?utf-8?B?S0JJMGdLQWpqQ3Q0YXdIb2NNdEZEMUczK29SMXNjRHc5VVBIQ3RrMjY5cVV6?=
 =?utf-8?B?Q2FJNlZ6TTRLeDhtSE95c3VZaG0rSncwN1ppckdWUzNrR2tpWUMwNTRGaElQ?=
 =?utf-8?B?L3ZBVnE3T2taQlkza3cwVEM0WGMwdGJuUitPRmoyeFN5eS91MmpiMytDSkhr?=
 =?utf-8?B?UDMvaFQwS0ZpdFlPSUVPN0tDcGlUZFhIcHA2YWpieU0wMGJ5eC9aOXB6TzJi?=
 =?utf-8?B?YXpLQlBiMXB6VWdjdGIzMm9XVG5pdkJ3S1phS3llOHJSM1dETkJ1WE4vc2xX?=
 =?utf-8?B?Y3UxVVpjNWx3MUR2VEVMaVZ5Z1hPVHJtOTFONk8rZjc5TWRFSmNsYlkzYVhv?=
 =?utf-8?B?bnd5a3VHQU5VN1JES0VxTzVkLzQ4aCtUQVd1TlBVdTdGTjY0SVlWbDZNTTNO?=
 =?utf-8?B?YWdZcnNDNExEYUFUVUFoSmZhaDFjcWlDM3Rpak1aTW5QOW9neEw1dDJLemps?=
 =?utf-8?B?R2l5V0psWkZqcDRNOWl5dEpJL2JUU25kODI2NlhlOUp1R0xtcG5LcWd2UGgv?=
 =?utf-8?B?SE8wVDdYZ1l5RmRWT2NuK0J3ZHU5bkUzRDMrc2FOZTA4VktFVGRCS3RLcE1D?=
 =?utf-8?B?UUhmMVRsSHpUbURjVXl2UkMwWi81OWN2dDRPNWEvWUxmTjhFNWlMNk9pQnE4?=
 =?utf-8?B?bithZnJQWUNVRjYxN2owZ2VjZVE1SjJOR0IvNUd4dVhaeEp0K0p5a3lwcXV4?=
 =?utf-8?B?Vm5UTVEvZDhkY05Ebi85cEdJelV5ZlBRdURLOFVub2xCYzErRjZwUVFLZ25R?=
 =?utf-8?B?MkpKOEoxeVE0OTJZSUhyR2RnWHl5c1RaYnV3ZTNDU1BWRWdUUzdLVkxxZ09J?=
 =?utf-8?B?d1VXN3lDc2p6dzloN2N5VWhaTWJsV3dTaVNGVzZwbWlTVGQvUEVQWU43OUNo?=
 =?utf-8?B?TTY2R1VKZTMzaFBEYXk0eUR5YlpuZjViYXlueHQ0bElRb3FLZFNJdUtxN1FU?=
 =?utf-8?B?dEM2UHVLcWhHYzlYOHBDQytUSlMvSEdZRW9LZWYxbElOT3VScExIcnZQekJX?=
 =?utf-8?Q?rLzA07vRuJJ9Ie0IICOfkGPsgiKsWVad?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzZ1N0JoUi9rRzQyblB1azd3TmhCSWVKcU5KK2cwYnVLd0dEdzBka2VkM1hu?=
 =?utf-8?B?UmZvczZONkdVdU8wQnptd0FsenNhR2VOTFI2STBCTUk2RGFCakFOMW5VSHdz?=
 =?utf-8?B?QWdvSmV4SEpKalV3aE9tZm9ncXltZllScjYzcVd1ekgrQWttNUJHYnlVbEdw?=
 =?utf-8?B?YVp5U3VDbjJWSUJLWlQxcllIZ3pTRWt4OHlFcnFDcTNOSWpmRFF2NzVLdndU?=
 =?utf-8?B?bitwUmw2a09obkd1dEpjSDBDV096U0MyQjlZSDdjWTRWeWd6bG53WlFjWHgy?=
 =?utf-8?B?K3htSURNRExDRlhFUjQxR2dZbkV2V3dMSzhYZkdDeE9QTjFYSDFyNWN0TUN2?=
 =?utf-8?B?clo2aFFoSUkzK2xjcUFNRVVJdzZQM3ZQT2JCSVhuSWQ4NGxWaHVMdE1Yb25n?=
 =?utf-8?B?OHg1WWVEM1JuNEk4NWRjVXdlTW5MS0ZyZE5EOTZUWVE2VVlqZ2JTQnVkczJY?=
 =?utf-8?B?TS92YnlSdDRHOFdoTmViRmxRYzV0QWM3UUtNT0l2ZzBYY2Rlem9rYzYxUlRo?=
 =?utf-8?B?S3F1OHdNWHRndWFXbTllRTA0M2d5TXB3SXZRZStVWjJQcjRlci9rLzllUG1r?=
 =?utf-8?B?RHlZOGZvWUVHNHBnVk1JVURJK2FiaDQ4NkJSQyt6dnFsWW1qWklTdTBrMzNL?=
 =?utf-8?B?dlZQbDR3VWYvYytQV3VqcUZRa3U2T2dhQ2FXMjIyZG52a2hNK2Z0M0l6S09p?=
 =?utf-8?B?ampZOGxtL1c0Q2NqdGEvUmt1QnYyUHhyaHNNUTA0S1Z6VWhlM0p6bTBoRm9j?=
 =?utf-8?B?SDBGYzkrTnRCbTlxcndZK2ljbENXVHlpWWdKTTk1TkVqZVIwSGNpOW40TU1v?=
 =?utf-8?B?M242WFpyY0RUWFJWeU4zb3RIa3VoK1pmd21uT2pYOXMwUWMrdXhkV2FRWmJQ?=
 =?utf-8?B?cjE5Tmdkd09VYll5c3hVSEs5UElBeUhLcFBmc2pQU1B0bTh6QkcyZUpTMHo0?=
 =?utf-8?B?cWcxc0xhMldtMjMzZ1lkUi9MbTkxSTVGQ2JUN0o4bFZnb0pQRUFodkN5UkZX?=
 =?utf-8?B?aW84YXZld2RnUTZTdlRwdlBabkZEb1U4UHlXdTdwamlBNHkxcy9LZk9HM3d1?=
 =?utf-8?B?bWpLVVFmcFJPSER0VENXQk80bW0yWnZvS0FjOXRIU2dqYnhWQWNkSUlHd1V5?=
 =?utf-8?B?dkhwQzNtZ2tsbVArZ09Ed3pDMStzbWEvTzFlT1BUQnUxN1R2b3Fjelg2Y0Nl?=
 =?utf-8?B?TEkzaEZyWmFVVFQ3SHBvM2I3S0dQNEdaRHdDcHlkRC9LSWZtckVVWCtmTVFE?=
 =?utf-8?B?ekZIUno1c0NLVGtaQm0yMDlsN3JuRU5SbVA2OUxvcFJ0TThuamoyRGkwZ3lY?=
 =?utf-8?B?Z2tVMDRGWmZHdkpVQXdzMGZLWlpEeVhVWXZqRFBMcFQzN09UdG1YMmIzQ3g5?=
 =?utf-8?B?OXZ4VFlBbCs1QllCTGxia0RFa3FGcEVCTzZMZjE4cGcvYjl5VWo0NmxiaThH?=
 =?utf-8?B?ZFloTGNjZzdNNXgzdS9RaTYwN1ppYkVzcHcxM0VQTzhPZDQzcW9USXFnMWtj?=
 =?utf-8?B?dE45YldrZDVRY1hHdExaY1VBTVYwNHp1RmN2bm9xV0FtWjRQd1NwSVdrbDh2?=
 =?utf-8?B?SkZjQmFqMVNjWG1zekFIU1VrVVJ2dk5qM1EyQ3NCUVorUWVwYjdWVTFmSHRp?=
 =?utf-8?B?eXEyODQ0bzhmOWtDeGNaeEl1WlJlZFRjQW0wcmp1cWt2UUFiUFgxMW4zelpy?=
 =?utf-8?B?aHV0cUtPU0JUS3ozYVI3aVY4NjBHVU5MdFBkelJSZDRKdDIxSHhaQ082akZZ?=
 =?utf-8?B?UXExaUpPUkpySmlXYVEvbWh4WUxIQ2wvWmFPbzFtY0ZzTmUzYXE4aFE2dzdQ?=
 =?utf-8?B?b0NYWTVWYjduSkExSGNQTG1MeVB4RlJWSjAzN1VSd2s3SHlRdklYSmN2enVJ?=
 =?utf-8?B?L2lIc3BPdUpNWXJoQUpsRWRucXBUSExPTFZRcmVidTVIZGs0YkF6SjVoUW50?=
 =?utf-8?B?c29rZG5pOTFsSkRIMWVCczNacEFyTG5ydGs2N0NVQTZycmpjamFQMFl4MjRq?=
 =?utf-8?B?b1ZvRmExRlY5UFIvOXF3NGl1R1N1ellxc1BtQzRaWkJiY0NoZXZFNzhzc2RL?=
 =?utf-8?B?ckNPbEJpQmpBSFBNVXZpeFRvK0hxS1k4MXZHaFFPZXBKaUZjNFFaQU5LRFBJ?=
 =?utf-8?B?dDh6c1lYMUpSaUxVMTV0M0lIS2ZaeFRRTlBIdDNIOGRTZHd1RXdjdjdFZnNi?=
 =?utf-8?Q?SMwkf90Q/TryGTFwiAarFWj8dzz8dDgeriQ+1nqQM8vH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e01a908-4d47-41b3-a4a7-08de222f7055
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 21:07:07.8296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtVkpQT7KMLswT/fqgJdlOsqYEyJ7i+FTBfndqCBF5SgdD/PtuRX+sFhEPXmom1DpaH8HGrXFEd8RR0rymsKRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8876
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C596B100006
X-Stat-Signature: 3qhfw53rcjdhct1qgg7euwni4ksyf4de
X-HE-Tag: 1762981631-429076
X-HE-Meta: U2FsdGVkX1/9jTT0Eh/ASEEZVkY/XuPGO2Fkef6pcpKIEVx5qWZMrBS6OGVG7Ao4lg5nxw4p8KumPJuwrdGyEPwmuyAPu8bqbfTMGOPMeFP53hZz1Wd3dq14g2B3xhbz8hOlfIumTaY3gF3noAynnYyf1k9EDzz60ueSM6iptvqtM6NgbFxOGehsvtjC37515V2fhAE3WU4rz0lEGNkf/A27o4J3qEFZgLAepTqOnig9RYS1qvV5mIziqvC8UQTRZ4K1j63yfLyCQ9hEB0gSPvCK7EoVqyzv6bLMAYt79PLXN942fQCP3TBLRIi8hZufrYpCHnDuHxXRkD8EB14w9WMNl7BjoKVWMtT9wkd0bvLkcjO9+7aDP/up1XdpmzCUeHmVHS580Li3EOS4nB5igXgSqzFAuqE9w3MGMjtQVuegtYw2g2mZDep4JQUaxrTItnr/892/Q7ERUD/j08TfMePAKNLqgqS2h4vrtuBd2Gu3AleCnH8EwK2uS9OFbXuXULEJwMcAx5EuE2jt/PMcOWmWwkcMluuR05u6MHt2RGeCRhrTPE1So6i5LV2Brss0CuksJuwIkDW/gw0ZLjYcsz1g4MEKsWgUG/mQwEpkOnyiqjpMRK8JV3PZ0fxSIlc3vr5XE9QWFehHJh+mDjcw4mXkIvscdMLv0WW3tZlHg/jCbVqa78MEDSWXnemECq2i+CZko8G8WxB2+4quaqMSLSc+zQpLVjSBXBblowASWxgnOO2ldhNvTQcYzQEbvIX114Wgmkg0ZSH0GBAwEXLcoCELO769vxSLdL7VJYNbid00M6Fs29q/mTzTNay58F8aZXRWOTElZ6tCopMOQyTN/bfhv4qJ1g5xYGCpmYP2mLOu/ClMvoF23n0LXRRBWw14UVRsR/5pwMIIYUaT/62yFbOCh98CkhSygldk1YTlfNwBneoKK8Fp1FP9ZZYBF+47Kd/561AHWTayIo9XDGD
 GavmawGC
 U1V2EWNsNPgohp7BrhmffND+Wig3rqS+hkw4oXE+R3vpwe2MozGJmJ8E7yjRb/xihZg00m2+W9T6B0plNxm5xe8iKGdhDxj+ZRST+eCQCspziJ6z7EkNgtJm/hy60944VMlQ2TEPTWgwGfOYUIHk8VYNLW0+5Hj5nB7XXrL1YyHIA7+5an48ee25oJdA5MnQdGzXaf1oyIFxJgA1CUXVlgyjbkeCmjU5iync/yiycsvqsqJmIoUToL/tQH9az15U4vDvS97+TWCQxIxiDF+swl3aLhW56TzHiAJtOCeyfKLNcuMcoh0ABtbpYF54hqsv4Btprxz0Ouo/1GOBnA+8mOkdSNVam2m4KhlgZdZkJrt4DoQA400yL/zGehMjNbSsMrdNXqB+Cb/IjAELRceparHK6Rof3TVGnJV7nCVxi08Hwe/3SfDzDsI9VtQgimHb6sN+3DmpHn0PCAiY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 00:43, Lorenzo Stoakes wrote:
> On Wed, Nov 12, 2025 at 03:46:34PM +1100, Balbir Singh wrote:
>> commit a6ca2ba46390 ("mm: replace pmd_to_swp_entry() with softleaf_from_pmd()")
>> does not work with device private THP entries. softleaf_is_migration_young()
>> asserts that the entry be a migration entry, but in the current code, the
>> entry might already be replaced by a device private entry by the time the
>> check is made. The issue exists with commit
>> 7385dbdbf841 ("mm/rmap: extend rmap and migration support device-private entries")
> 
> OK this is _hugely_ confusing.
> 
> Is the bug in my patch or in yours?
> 

The bug exists in my series (as pointed out in the the issue exists with), 
but it is exposed by your changes with the VM_WARN_ON in your changes.

> Why are you replying to your own series with this patch?
> 
> You shouldn't reference non-upstream commit messages in general.
> 
> If the bug is in 7385dbdbf841, fix it in your series, then perhaps send a
> suggested fix-patch to the appropriate patch in my series to make life easier
> for Andrew.
> 

OK, let me split it up then

> As mine I think in this case was purely a mechanical replacement of function
> calls I'm guessing it's a bug in yours? So I think this is probably the best
> way.
> 

[...]
Balbir

