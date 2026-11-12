Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F409F60A5BC2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nrO1t5T2
Received: by kanga.kvack.org (Postfix)
	id 1C4266B05B9; Thu, 12 Nov 2026 11:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1749F6B05BF; Thu, 12 Nov 2026 11:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BEE6B05C1; Thu, 12 Nov 2026 11:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBB796B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:47:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6ACE880620
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:47:09 +0000 (UTC)
X-FDA: 85427046978.19.994BF4B
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013035.outbound.protection.outlook.com [40.93.201.35])
	by imf10.hostedemail.com (Postfix) with ESMTP id 59A78C000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:47:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nrO1t5T2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794502026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugRjqWRs7okEjqsQF0pwx3WV2aiCHkmskycccrDr4oA=;
	b=Z58V5D2lmF6bQR4NcE+n5glECVVbUX8sopUP66qICjhCAMUKEsWSffT02CqJqPb74EbWGm
	IHzTi4R6NIKb1xF5jnOW0sJ2pSXxVBg/yUpDCW/wxfTUJyX2RIHgTgbP+wqxOpC6qLW77B
	DmM0gZq5D2C1kBIYE1VtAmKoSla+x7A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794502026;
	b=nPlEp1UqFADSjM+bwGGvLWGb8ZpelcF1Rhvp5zR8lYrbgw+lV20wDZwJGafNUgKusaw6u1
	aQDjk+LOPjlN6OjXfDCg7DCITDPyHnD3PFp3yEC+davTc2UBfkf5ux9zCDn49wnNN94wTd
	YXOXhXsqhvCwTkU1X4/HFExNfMdgnq4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nrO1t5T2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jaUlz3YMFsFKMsramlKF6W+UMo02pvAbD55V2UCgm2LC6S2Z+1VFkmwnfmMAYEcJkHsJ0Bmxa0H/tVYJs+da2h8wvyJcbKKjmhUDVlBypKwYS7q+S159nJBtkHqI9rRQk+r9gmJn8PD7DBGF7Pj3A+cWKFcTFXn9OplOlbR7Fq3DxMZla9ey9D7kE8Uyn50euwqlUQP+CeHaxhiwhznCsQDGVKjifMUl0mn5oBALbaLegeLBioOxr//G4Or7zB012U6dDl/B9fpsozyGPIZbeJW841XWhapd8SFeRrvI5BvvXdcZRUBysUR3atgORtn09biiAe7qUw1zBkaJeRiHlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugRjqWRs7okEjqsQF0pwx3WV2aiCHkmskycccrDr4oA=;
 b=QjtMjU9sGthqRKDm4VBf6IGwSjkksr7ZLu4WJcXYbdZUmkYlfiJMEZGSYouLYTY468nAWBzHBJDSGYf+b/0CSJgaELto/SQ/e9B2CRwkGHKLBqGw36KN8LwobSoWohO8qODQCIahwKgSk5jW/bBMqMZtSVNJFlS+Va+62Zrw88KyuL2NXLiCIj0swhMCmD3e1CFM2nypBmX/l8f9acbWjBZleDKQ/ElXwmfltDmW7GcfG4mZUS91DbGq5oHMow1ItTeKE/QuaT2PSaagpg5JKNqotGlls8eb1JUqmgnDjPzMZ4lQwP9/Q0nfi4eX79ppQTcY5E1hz1YiMul9CwEIDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugRjqWRs7okEjqsQF0pwx3WV2aiCHkmskycccrDr4oA=;
 b=nrO1t5T2dyftoAFSsIztK9B4QVLkeCKCYzm6ntwC6fHZolPqFRidsFn5WkoPqMwP9G8vNoJmkGm9BT7kaceyDX1h53u8QupAHCQJr4Foy9JL8EGWT3JedRGUyYkwVE1+AbtxXM624jmvR0lEoqnSFu890WWRUy+FQsH50fSNG3awGa5DiQwm7ZDLdI6x567oOzZhP2Wlw1Tmmss3WsNBu1YKtoZuGK4N7a9b8hx39PPnId07wzB0+lFpxp4NBhDDs9RM0qHayPr9jtPaPQkbeo4Odqb9t1uqfX9ypfHcLKab6HAap9jAeBJ15WvSrYhRCETqKkoYc6d0/MQoTgOWXw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8356.namprd12.prod.outlook.com (2603:10b6:610:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 12 Nov
 2026 16:46:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Thu, 12 Nov 2026
 16:46:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
Date: Thu, 12 Nov 2026 11:46:07 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <A5F90AB2-917D-4A04-9A81-A55CB4FC8E66@nvidia.com>
In-Reply-To: <61e5e0ac-dfe2-4a5a-afee-873523df18e5@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor> <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
 <avXoJSGh5xjGFgod@raptor> <3A5BEC5A-BAFA-4541-8ACA-43E57C7DBCFD@nvidia.com>
 <61e5e0ac-dfe2-4a5a-afee-873523df18e5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: CH0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:610:e7::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8356:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a55e315-36f9-4489-13b1-08df40dc74b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|261009223027099003|10067099003|11063799006|4143699003|56012099006|261022105027099003|261026140227099003|261028144727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uHiTUoWQiul0KQ/95lM2p0+q9KKdAU/rWmTDGr8DDQbrrWWkTHJv0YjknvDZ4z1dQYxwJMRSnB98hG/41lH9NxWIlS4F1SmaAwnCo3F7c1JatPF3eXJcaIIgm2tO1uGFi44VeVtGD9tvjbLdM0IiCXXgo98qTsDe0XOf8kuyKVRoMxSkcOBh6MuP/dVxVLuRGBddkY3SbEizAZ5aZCpe4bWSV83y285R0EhRmLnAsuzWpHS5IDUmls+TDizBI9qzw0He5sbEFFZQu97kpgYO3uKRa9kAYJU5lU8lEfQspGc/sZqHEA7DyoL3+mUakLPxNR+4F5EWogVRHtdt5bMClqltC4ENLfuS7svBC5Z/muULvWOVrAdnawMmb33616HiPXm58afwoNm0EPhDNS24BjBji/NvylY6fHjdhHpzqz79NjHYTmMYF6f+0aPkdZhWlFvDk9NO46AhuWbCpBN2I0SNZt/cdUETlksgr+WYK4jgIjag2bYIU0JYERmdgzNQ2Fk/ZMtbs0tYoA4eO9nj29bPH7eoXOgImIb++CXGlQyjNhzdEIDcCDsS991ii6FCHrqHSvWkR553zaZoNN7S+/NY6K/sTomoOsbNOu7vvaqbtD2gsyuU12CnJdAJXXSNn23F5+hT/pifQACpQzuaQvEUSKQpSYmdPHYoUxApwq0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(261009223027099003)(10067099003)(11063799006)(4143699003)(56012099006)(261022105027099003)(261026140227099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlE5bzhZRGtzZWJUVU1GMjY3c0cyajZEYkVsdFdmM0NBK0QyTDRQSUN2OC9I?=
 =?utf-8?B?Z1lad25tNXFCZVRFRTFYbFFxcDlqSTRJYVFKWkYwL2hjR2dPYTBvQ2dKdzBG?=
 =?utf-8?B?cHlVZzBTOVBZK1p6WVZCYTJKTXN5WnpMRmdqdjRGVjRVdFdxdzZLSVg3azJS?=
 =?utf-8?B?Y3JkdktXeE9BeXZFZ0hWdldVTmZBV0J1YnZ6alJkWlZ3amR0SkpxNzNpWE55?=
 =?utf-8?B?bUNKZ2luRXh0eitYMlVnYmRKUjllK2pqeTBIbjNFdERrM3VvRmZRQWxIazl2?=
 =?utf-8?B?QWttOHh3U1hHeTV5RHdvL3ZqQnI2cjgzRkdwdEtiQk5kWjFiMWZwNHZEOURs?=
 =?utf-8?B?bkNEQ2d1Tnh0dkUxd1A1SVprOUpRRHIxZGpaWnRWdVQzZzhhWXV0b0lHKy8x?=
 =?utf-8?B?KzFESDByNTNVY0tIRGlBZWd2VzI2cFdnMWZYRUlHNm1vMEVnWHFFZDF3WUR4?=
 =?utf-8?B?anYvaG1DdU52REpxQVNVSDByc3F3QkE3N01tcWNmVHFyeitIeDhqNXRvcUpM?=
 =?utf-8?B?cmdhQm9DYkJ4dUh1QWd2YkF6OEY4bFFhcW4zMFRJcUVOc3JSTmtEenBVeity?=
 =?utf-8?B?VHhTQ2tTNGJLUG1yMFhBME8xdFpmL0FnSmYxSDFlN3h5S0svanJrZGJselJE?=
 =?utf-8?B?eE4wQjhNS3g2R3Yzem9WWmJJWHdYVEZodXpaQ3NvWkdzYmxQU3VXUXBLVGVX?=
 =?utf-8?B?SlpQTlBLYzFiUW5qNXFjcVpxUG5sYjVUTjNUNFVXSk9OKzNLK2hYdnIrZnJu?=
 =?utf-8?B?OUpBSlBRbEFianN5WlR6elc0disxM3BBREFha3FTVm9yYmhOS3Z4cHpiT0pJ?=
 =?utf-8?B?YXVFRlJoT0dqWWRaMTZ1VjBBWVhjTVVtTXhwSUxjVmZZbi9ORFdXeW1VU0VJ?=
 =?utf-8?B?M0V0Zlc3c1kxY051d1UwU21rSzlNSWdFV3M2LzM0b3dQcjFKaGhydklEMnVi?=
 =?utf-8?B?VS9SZlMxc0wvbkJwenpkVk5NcDEyQzV3N0RKV214Tno5VTdzYnJ5d3Y1WG9M?=
 =?utf-8?B?K0UrUDh1TnA0ajhJQ3NZM245UTZLV1NWVkZzOEpVQnN5Q0o4OEMxL0VKMjds?=
 =?utf-8?B?VFZHMy9ONVJ5RGRheVVJR3VYM1NzRzJ6QklxTTR3R3IrY1BhVytJL3BzUGtK?=
 =?utf-8?B?ZndpVTVhSXQ4L3djWHdQM1RrK2RrM29Sb2xvMTEwZmZJamJENWlrNG1hTEhw?=
 =?utf-8?B?ejRIM1FjZzhBd29sbytWVDNVN3ZVM0FrcW1tZWFiU2xwdFliUGp4R3lSVWNm?=
 =?utf-8?B?SlBiN1ZLT25DTVoyd01sMnhmWHNtbWhIemVTaXU5YW9CSmdhZEF5dVNEcW1Z?=
 =?utf-8?B?TWlaTTZnNWVVM2JZdzRtT21jRUpmdU5jT3M4YjBNeTcvcm01Z0dQQXJxN2Vj?=
 =?utf-8?B?UXJ6UEcwRkNjUExwdHNiT2VDZGN6d0g5SGN6Tm15T3ptVHk5cGd6SWM4QWRS?=
 =?utf-8?B?M3JGb01uYkwxYzNiWGtMdi9XeGFiOHNzU24xNmlncUpIZ3lCdG1MWlRqRVZz?=
 =?utf-8?B?VitLZjFwcUUrSlNTMFBnS2VtTlRBRDhxMEQ5ZVE2MXhndi8wS3NqY2doa3VH?=
 =?utf-8?B?TXd0LzN3R0VhSzVoaWRBRW1tRTY1ZFZpbVk2QjJZSEZzdVE2cXQ3end1V1NH?=
 =?utf-8?B?SFJZM2pHck1yZjJQSGxWVHQyem1NSVpqLzJYWmV3MFdLVEVicG5FQmZkaGl5?=
 =?utf-8?B?dzMzaXQwSzRFKzl5ZENlUXVwS2ZZcWUxQ3p0b0R1czJ3ZzRTU2JGZEVicWwr?=
 =?utf-8?B?U0NLU09maHdaWXJkOTVvaDMvVEZvSVFwSC9SdDh6SUxJZzZzc0lpelcyOG1T?=
 =?utf-8?B?QmMwWWtHdzFlN002YnM1eUIyTm92WnpZR1BMdVAzTmNvL0NUZUE0Nk1XVEMy?=
 =?utf-8?B?aFo3Z3FJWTdwQW8rRk1pa2laQ0ZISHEzblhBWURLekpwRjkyTGlNd1RDNHRk?=
 =?utf-8?B?MUlwRXF0Q2FTWlhVV1ZzNFVFV3p5ZnhObURINjF2VXdiTUdXaTV3dE92Y0Uz?=
 =?utf-8?B?dFZKd0xEdVM3RmRodG5FQ2ozM0l3ZXpTUDB4UEgxcjZnSWpCclJ4M0hGbmd4?=
 =?utf-8?B?Um82Nk9LRmlNUDA3cDk2NG9jVTBNWU52YkE2dCtZSzJEOGFwLytmUVlzOGta?=
 =?utf-8?B?RGxYL1hrU0gybTJubllyejJTa2dsSnJyTHkxNjNONmNjUFA3Z0NmdWhkWXUz?=
 =?utf-8?B?TEErSlJkVTd0M2xUdWsyTzk4SnMraG9MNVpFSm5RRldDNUxwc1FUdjJtakRj?=
 =?utf-8?B?SGJtbTJQRWwyT0d3VXlpb3ZjLzFha3BYalZ4Wk93SVg1ZnFOL1RPRGVRMkJQ?=
 =?utf-8?Q?1xw7vZ/AvGkqU6+N2G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a55e315-36f9-4489-13b1-08df40dc74b8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 16:46:10.6852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24JqOTHrDzmJ0qKIrqlq//cjk3J+Eo5AlvfLtf/Et6e7LcAi5rP0NLrh6YCGbNUj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8356
X-Stat-Signature: 9o3ycy1txzc97yxsr4m661ue4r4o8waq
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 59A78C000A
X-HE-Tag: 1794502026-971066
X-HE-Meta: U2FsdGVkX1/AVSLIbgAckTJ2HV/rzJQwk/opEl6/OMI8TDOqexMrw6S9SaADyQSJHVS9sSGgXf6GfIiNraVwt6lA+Q9itedDSZNlGghts2O2Fm3EoOqVuTW7msBRbjueDVlj3nXYLP2VLoQJfKaQr8fofyqVlKThPhfNZnzKJkgMW1raf3ldygVOf7rVsaAreXlIOdP6+CgfKc+jm4SbOcN0DJCNtRH8F9QJ+99o+KB5qUoF2K/LqhI6nK2szRFvruk8OLoDaOU1zao1NAoNPcpafKjMl09QJGWLAonZK4YRnR8uZwlsEJL9PKRmoqp644uwerHlxP2oD3gaZoLdhEDlkZyGcjsuUJo43quhCZCVTCEvchaHNQDdlSboQnEPTPOdjMZpcQ2MSnKIpekTnbfjrBSpddywfidDMRi32dr76TZCD+SawQ8Mtb708mWgbwvQ7WyuBtXFYz/jUA50VSns2TiCRoCpsR665DqbCdPyzMChy0lp5dPtznQ8AET5n5UAyFZetDuz8a/oacZ1U+2QMhwWX8WVp2+0lL8Fbxv17dHu21JZXjMg71BHpXMhfF9NyIJ1joAwUWCCEGGYUemq1NxE73QiYJn07QyZoS6VMHd1/GXxqctqZ4Z0TXm5OZbA5iPUMQY4FBSlkDWpg7DtNS4S4qY1cAYkLUwsYcKZzA7F4E5BMtQtjaNVn/POpjQ1BBxBjjKwXZKBgZLK41VzwKrTqtsGulGLpzKFpAHnMLYyUB0skRbkkLSooriIlEyaYvKTj3Qm4oBJymrONk6iG0szjYTWy0dFg74mVxalJGs7fa2MwGLy6aISafNV0iihM8I1/3CqEBpYv86fMMpYBCYOZgJ/TxIVuiUFehU4Ihnckzbw9oIAOhuONbuH2U5d4yyTYZ8eJrnjRPAjEOKbh2bgX9FqqNlhG4ISyxbn19aFZFaBEr7Lgo3iH3r9vRr+1DnMx6vHe9y5vUh
 WQXBYKVI
 qdTvm8NXonpNhWEMCbEkPGyg+NBtI91XGuSRMiTFik36DjDM62itwN3owrQgBjG+dU7I2rQzYxExc9gisCyR36aj/qzQgXrKwQCK1VZcfTqSAARKtLB9SXBTB7TIfuBvFuD5VCYkUHiUBB+GrmHofd1DSyl33lEUHHrLe+8KvOM3+/ru/Mc+oSyLfLbxwnBOpplh5LnPcwQI0glY/DjujOjTx5/WwFpvWZcPylPBj0seW2+rY3Vuj5xzCR8iwX3s3jVFtNCCje+ims2J2VIui15ayK2/LotEG/W/fe3rZeV82/LFmPwzA2EFt19WqWhifLKzl2LKjpgjOGa7QiA7MyFIt3NYzocNpNdcjdNVrVxLJy0SbW/IgkdBOb5vGRhvMcJ643rhlrR91dBvyPvZs1h8a5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 12 Nov 2026, at 11:44, Mika Penttil=C3=A4 wrote:

> On 11/12/26 18:33, Zi Yan wrote:
>> On 12 Nov 2026, at 11:24, Alexandru Elisei wrote:
>>
>>> Hi Mika,
>>>
>>> On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttil=C3=A4 wrote:
>>>> Hi Alexandru!
>>>>
>>>> On 11/12/26 13:56, Alexandru Elisei wrote:
>>>>> Hi Mika,
>>>>>
>>>>> I want to help getting this series merged, and I've been familiarizin=
g myself
>>>>> with hmm and device migration, please bare with me if the questions I=
'm asking
>>>>> are obvious or downright silly.
>>>> Thanks for the interest and willing to help! I am preparing a v18 of t=
he
>>>> series and plan to post it early next week.
>>> The series is big, and as far as I can tell the MM people are hard at w=
ork
>>> reviewing bug fixes. It might be better to wait a while, to give people=
 a
>>> chance to have a look? I know that if I see a series being reposted oft=
en,
>>> I am less inclined to review the patches since probably a new iteration
>>> will be posted soon. But I can only speak for myself, you know best.
>> Totally agree. It is better to wait until MM people finish the bug fixes=
.
>
> I was going to send fix series to few regressions by earlier posting -
> no new features or anything - with the mindset that it is better then to
> review a fixed series than known buggy.=C2=A0

https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kerne=
l.org/

Best Regards,
Yan, Zi

