Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73758103E199
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43376B0274; Wed, 18 Mar 2026 11:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD4A6B0276; Wed, 18 Mar 2026 11:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E126B0277; Wed, 18 Mar 2026 11:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF6B6B0274
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:26:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 171E413BB0C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:26:57 +0000 (UTC)
X-FDA: 84559561674.01.5490E33
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0D8A8140016
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:26:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m7cawqUc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773847614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXqZA9zN7T90QFSiyVp1GjLsHZraE5Om2AWUj+QTzAc=;
	b=AswPpFlBjhL9l0FdO8DYeYeehLY7hEVlPXkRN23JDyNhIdhAu1ZPAG3oDFmPqqp7xlI+2c
	PBlvXTLUDKDCV0CZbdIYMpeeHPN7/PEdGEVRZI2UwBSB/gVDJQrHTLJSZJXG3J3kVGQXf4
	/2QeBO5mXBVYBPS7ng7aQTCV+zcNrN8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m7cawqUc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773847614; a=rsa-sha256;
	cv=pass;
	b=XlbmGICcLbIZLYs2DC1OeEfo6+2Irn1L21tu8ebZLvA1TiIo+ynmuGempE8tv9ilmCrrVX
	HIWZlfD62vmDowA9Gb1PF2Z2bikgjLLpmo2j/8R+VO0Mxjkn3JaY6D9jc8wxEm5wtHypj0
	sHSOROvpLZ7xxj+MiyW24rJquesHQkQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYjAGv3GCA3mP6f2RY+jbBj+Z9NgwbVUeEJGvVO4dFUATsbWBkNHSELAx+GfRylelQrvn8YWWXya8eYZFRETKgyNsGu/qEEn0lncj+KArDJ9VX8OoPuXeJ/J4EWzS5cFp6B+cHsUQyMIZzqsROrrtoKVk8XTwxzfDEO+IF9DvkpkOUYGrWci+ScLDum59ippfTvcFfaB8Mad3xE6P6z1y6GbjaA07pd/46Fhzn/4dHWlGbPl+7gyaecGSHZVqXEM7lKRlykTnUqhv8XkcGKUvUry49Cz0scFfzI8CUQqcMNL6EJaZNA2SSCZGwiucCXMTQ459ietLRFoJR2aYZcyog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXqZA9zN7T90QFSiyVp1GjLsHZraE5Om2AWUj+QTzAc=;
 b=SnH9imPlAS8racnz9dnfQS3cft5JYbhsMt91473zM+JsltSGgiXnfNMwIquvQ3+Hg1gLIdnfYouGdORG24D1MViKqFEYq/GawfPg0I4OBuXeSCDkbt78mUC8e+qzNoIzcCWpiRYHjdavMEJK/YQKtttQe4lZF26Bj8w6WHPW+cdXapvDFUlPNx/9lT3LRVB/QGNcNjC1+jDDgnCjkWainUHRuY3rJrMUf5KnIJPyLPcr2dL1PtVoYDWgqB5WEByp5SsgRE6xq/SpvF4NEhFQZusradjLSdIc93CFqFnHCDjmkWGOjSqX9rdWsSuUYCe3tiKB/wkX48MvDVEsAsKcMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXqZA9zN7T90QFSiyVp1GjLsHZraE5Om2AWUj+QTzAc=;
 b=m7cawqUcVkdmDbk0K/wGr5qqTKEJ6yq5UAPxdfzkxPRZ8p5InDfM+MNb7rIhljSQB44lj/zHwNKY5YHdPu22QoMVJMsW2Tft4aVJ0vFfQl/9HNVJKMFUwYqLgwn1f3roydmeNcEP6d1ScO2TKK8GTyrV5Ee81QC4kDgYC4sFquN6ULBuWjFUUBkF5DpPkrn8OaDFJowhzpgLSEj78VleabKq7pgPVrqPBCWHJ60Pvdrxe+t5B/uzVVZPl8AVo7tigDfjHtxm+bwtIs9zJrUULXMsJ0GOf0peh2t3phNhK7Yr+UTyGLd+a1HEpnS6N0/4YhOUHSdAzsX+gmPGfG3EZw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6284.namprd12.prod.outlook.com (2603:10b6:208:3e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 15:26:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Wed, 18 Mar 2026
 15:26:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?b?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Date: Wed, 18 Mar 2026 11:26:45 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
In-Reply-To: <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com>
 <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
 <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: d3b86b41-47a2-4e4a-3c9b-08de8502c605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	9ftB8sqB28Iv7gw4T8Xmlk+PZH/WU3an5/MmQRG7hKVH0aiaOAmMJsZtSuGdvBJdPqpGLHympiFd5GPhMpomdIJl3OVwO6YMGlobAVUWeIYtixniarsw1GzCpxMOcMCyFbruWmGThy2mZ4e3tvHno+afQOjKsx7eCY/9YcMTaM8E/S3IB5U3Mw2Muz1j49ReygQAgGPnoyMIMIU2/bzrGVCMarMYLhNNKWg/wCHBS9l/Fm2GY2EHS94vKV49oCr0aoj3Runh3GEfK34Tk6QDp8LX4PfMS6nOz/Zyx9m8Xf+u4zVdfBvGr8bxtH+FI9uwdzP4+/p9mDCHA4F9hBDAZTF3CjNU3TCDWT4CTJYpIaim36UsNEfJUE3qUlVQIMClFtN1G/rpq3NBP3bjskBm46AHd+TC3B7oMkzurIK2Fm8qzmyBxLi7HaEPPWkx4X9lDb/lZlx57aomVsJheyT1c4j/PiPaIWWvJmug+3mtFT/xlRKGV0AGNSgvFlcyx/uKPEpsmf93GTtXF9ha2fje9xZoJ4oKR+vYMgmc2KcEKZzSL2Wgs48ObCH5Qep/NkCVfgvkD7mp6cz3v2EpC0EkO4/GUpU5PwBdvpNeTCqEHJUlxFsvF1mv07XmQ5LrxfM5MN9eJEN8pHg9Qvq72/Bzcb6NvnPxc/CCcm1fn95Y1wnpJFlEj+HvQLrGmRR4cI0qsqW2A2aTHp+rxuQA/h4Wpt0WOly/0o0z5ec9D2tr4Es=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3VzSWlRZzhrOHdDMjVmSVVWOVE0aENIdTUxQXN6U0RaZ2l3TzZzeFlWOEwy?=
 =?utf-8?B?eHlCL05xZXYzaGpreEdPTlRUbTNqcWpRVEJpdHhJckU5c3Y2YlBCR1VOMm5x?=
 =?utf-8?B?WTJyS05DOFh4WlB1SDF1amJJOHJ6OXRrcFMvQm1HVk9OV3J6c21oL3JNVnNE?=
 =?utf-8?B?T2hDT3R3Qis2Q1o4MloxWXhOTU8yK3VmOTlPUnpZWTd1cjlVV3RPUldwQzdZ?=
 =?utf-8?B?Y25Ib1BLZmZzSTF4VFZTaXNuVzROTUFSeXFxNEc1eUM2RFc0WURQMDk1aEhG?=
 =?utf-8?B?a0RQVXN6by9XVUdLUUorMUpEbVhHRHZTUGNZanJ6NlpKUDVVQklXRWhtdnhn?=
 =?utf-8?B?MXlxbDFsYmZ0bGpJL0IwRW9GVjFNeCtHRkE4VHF5VCtFM01iM2ZsZkkvbllO?=
 =?utf-8?B?R0ZqeWJoWkRmc3NqT3Q2TzRrcXV4eGFJQU81TlBmNjFjMDRTS1N2Z1dNSGZh?=
 =?utf-8?B?MXJWSy8zdUpja0lNMVEvdlRSOVZZVUVpbzR0M1lCVjNtc3dudGh2NnZBREFK?=
 =?utf-8?B?Uy96ME5rKzFqc2hpRlhaT0t3ZDY3cVAyY0VRZFZndGNBUHE1dy9hTTBIQ21l?=
 =?utf-8?B?enR6aUttb3R1cUxMVFF0a3c5eVJCL0hkN1Rzait2L0JaRmxFU2pleXN3V1Uy?=
 =?utf-8?B?NVJDWm56c2lEbFdJOW1JVit3c0xuNGNoeE82UkxkVWhRSnJlVExYOFhFY3Zm?=
 =?utf-8?B?U0QyQWxkTW1YTWF2ZWdmeVEvdEEwOEw3aHZCNzc5UnFUMjdUdXVSOFJ1L3Vn?=
 =?utf-8?B?VXR2ZFBwN2oxSTg5eG84QzBRNHd0TURMMmFsbVNaRGR2U2gyeFg2OHpPMVg5?=
 =?utf-8?B?MUhkY2l4YkxFejFuSkJ3NWpCa01NZ2tITWZPNlAxZjl5T0hxd3I0ZVdDV2sw?=
 =?utf-8?B?b2RaK1JteDZ2N050QkJZaWhJK3o3TUFadXZ5Tk1KSDJLQVltcTVncmI4a3Bm?=
 =?utf-8?B?V1ViRW5Hb1Fqd0dqbFBWeDE2eU9kdTVxMm1qb3hrQ1ZtOERXQkhNdkNmWXBk?=
 =?utf-8?B?MXljWTRKdHh2WlZ2VC84eW5DalRWRno5dncvcDY1RXp1VEptSXdKQWpzZ1Bx?=
 =?utf-8?B?SHJoL2QyaXl5OWhiNEdWVWNxQ1lIaEI5QzArTnFIeXFyNm9TTVlpTGFNMkdM?=
 =?utf-8?B?T2daOWkvNWE2ajkvdHowdnRITEhvZk1lRWltQUlOZXhFVkhTQkNidVFkeWlz?=
 =?utf-8?B?TlNrWVRWam9EMEtmdTY5ZVBQWnc2ZHRmdDg2eStiVWdReFRtN1JIVko0WGpR?=
 =?utf-8?B?MWF0MUc3NDlkWlIzVEVFRHBJc25KallBTGlXN3g0SkxJTmV6bHdDSmVBS2tW?=
 =?utf-8?B?ZkkxR1cwa0ovMWd1dlVaWU5lVGQyMnFTVnV6MFZLZWNSQURVbjF0eGs5TTNP?=
 =?utf-8?B?Ujk5QmYyOXJtandiQUZ3YUwzSXJHOGU2NGY5RXN2TDVaZUNtRTVxbFFXeXM2?=
 =?utf-8?B?N1NaQkRxTnR4bDVpV0pNZWQwdHk2Q0I2RDhnYWhJTFBEeEpJeTRkWXo4NXhy?=
 =?utf-8?B?Ymk1VnZnMjFDN3JqWVZ3ZE1HRW9RNW9BV0JPQklwRXRTd2FIVVUwaDBCY0w0?=
 =?utf-8?B?VFV2M1liMTgzMnU5d0JVLzFwa0V3TndadC9NZzg2RHVEZzFRb1V5Ri9jYnJt?=
 =?utf-8?B?WVNBelV2RGVLWFRPMUl3MWYyYVh1Y1hEVEU5bGxsS2l5WHYxWUdySG5xZU55?=
 =?utf-8?B?Mk4yTVIxUTJVYXA4SDM2aUp3WGVyd1hTUzB6WmF4WDZPbXJ6L2pHKzQxb2Vx?=
 =?utf-8?B?Z0lnNHg0MnhaU1ExOWw3N3hiMSs2M2dLczg0aFUveENCbnp6ZEZsRUtTRE8y?=
 =?utf-8?B?cFg1UmhDNW1kc0JlOExxbEY5VFZFaXg1c2VmUlVNcTFWSXBvWHFEQXVSRFNQ?=
 =?utf-8?B?amt1WmtMN2JYWTFhbzZoWWQybmI3cnpSenlHdkJycS91bkdqK3lwdHN1WktW?=
 =?utf-8?B?Z0pIK2daNDArOFRDeWRYN1dEYzNiRzZUQm1UWEZjckVnNnNvRnBCT3BNbEdW?=
 =?utf-8?B?TzdYSzRGbDdVTWVKWU1LU0VBd0FRdUI2cW1Bc3BadkI0OTBLazZyRy9kM3Ri?=
 =?utf-8?B?M1R1VlFqa29pUU03YVU4VE5iTVlIV1hPUWhGcStwVFN2M3hsYVE3SHArekVj?=
 =?utf-8?B?Nlg0WFcxZWpaRGM1L2ppQ0NhZUN1WVVRamp3K1RmVFdLNXlUaGR0V3FjL3B3?=
 =?utf-8?B?VmwrV3dWaFhpQkptK1krQksvZTlQTENramxvVUE4OERhMCtiYWRmVHlwV2t2?=
 =?utf-8?B?aFJLRStnUHVnZjVVK0cwem9JVjA4Q1ErZEh1SU9Sd2VDYXEvdVFQbWdEZ3cr?=
 =?utf-8?B?RjBmUTQzY0svNUkrMHZJRElRQjlvUTdEbkV6Tm9mVmlOdkg1ZVBOdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b86b41-47a2-4e4a-3c9b-08de8502c605
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 15:26:49.3279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9s/TvXbF4hicVG7Kj5sNgYvYMA07jaUMbxlS/NIFo+kPRfClW25oTkuXvnoqu6MW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6284
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D8A8140016
X-Stat-Signature: cugyoshwuexx9qp5hsiyrgwcf4akhj8i
X-Rspam-User: 
X-HE-Tag: 1773847613-832812
X-HE-Meta: U2FsdGVkX1+gOqjMGlkdIxzkVpmM8/BYSYxb6+ULzQvW0umggz3R0uwwZAF07v8KdUPfMLcBizguSbXqePyNkEPcXcMqDLAEGqUWGEIwrTPmM2OqOCtY7xDS/Aa64ItjspfffXFhNtqeYSi4XNl250N/Tnf9iYrsAvIf9N8yEL0NmjWlPzshIkkpxbO8oYne78B+hnqSn+ZwTG7V6Ntc2ay9YkomE+o5Y0R673RweOPD8ICSZVAlhv3TIWltredK4ytzoCCr7LPHoAk0+LSjCEPdI9GR/ma6cQNZ51g0k1dCJwr/+NgmPyfXeLdAIwue5g1VsDr7rxZX9FhUcu2oXCJUk6FNz5q6iY/E6hNzOv6PGTDRGzyGrO/WOhPEJreknCeaC/nUn7mjDbLLGQ8C0fzbCNRxI0QberrsUT8DmGM4hN0fndBTBjaOoNqZsofbP9atqJjgjucOWvPqJuwKo78qJ1N/+c//7NTeEHP0Sl40odnf46cWJbhQzXTdIBibhJtyKGgi2QkRuALTnWGv6825QdJHBCOaPKHa8eIJfofxapO6nWiszCrHO51UUijB0qVYmYueWMlNjt/j/wdKX09aUXhheS7lutNV0ZvABP35by/RYQ4g8OLDpm2/fFQGpm23WfnIWEHRYrgHMUneuLqLYq0whIEmqmfPZ9Y80x+9K34lE0KgamugLJh+sCcDEas2PRj3C8LaUDy0tjYBDKzgPf8S76HuffJ2YxQ8/iZtcEZYvnIZ/CDr0tnzGvieqAQkfsTltVnMnIeEXFgqX4ZLP8/ZDNyt9nWbWwsfXzNr+KxL5FhDlqGsnNqoXhy6+gnL6/LhCge5P5dqW85Wfe2uZAB5saBj1oabXuaKQQNVUsQithLHvCBq8nTqvUr4ex0lr/eGbt7hORmAtAMaM7TawGWWR+2aCdQ1ifELTcSBWfb/wQjJExUt/qY49PkLue8+PtNC3YUcGJ0n2tf
 GIgcmSP+
 +Ar2KXl6TEQbDo52K6SDPOWa7hJYTSpn6z0UytxCXAk9BmxewfphGMTot//YMqoGSazFeVAqWgoNVfF/eNjBBIS82QdKvXWW44FIILtz7rW/A17j0jrdjJCJR9RWtesJIlA80INGSRQk4vhqyRykFh/osn5OSl+XU2k50nGf37Zu4kQl7i3lf52CbhNAl8Ia+nJeC7xb+xLFecfS4X87jWL17h8LXF9nq4+sarQX1hhIOz5DzpwnOa3Rgc/NxEi/7W5vA1TXZ5VIFZ/gewcpJYOo2Xofd7Y1e9LvRAS0dtON1lJG28DvEe0ICgXzI6I/3TuENbR+TxgiO5rtsWpurUJ5aBzBqW5LAjXSkbCbTLEKmg0J47yiRbDdLfmCj5zxUwcak3xvmVuDMjzu9FR3wOgjqB+ldmdsuO9c6cjT1ljd+4BBva7+LpQ53C1hj2kNeLxCi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Mar 2026, at 11:18, Michał Cłapiński wrote:

> On Wed, Mar 18, 2026 at 4:10 PM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 17 Mar 2026, at 10:15, Michal Clapinski wrote:
>>
>>> Currently, if DEFERRED is enabled, kho_release_scratch will initialize
>>> the struct pages and set migratetype of kho scratch. Unless the whole
>>> scratch fit below first_deferred_pfn, some of that will be overwritten
>>> either by deferred_init_pages or memmap_init_reserved_pages.
>>>
>>> To fix it, I modified kho_release_scratch to only set the migratetype
>>> on already initialized pages. Then, modified init_pageblock_migratetype
>>> to set the migratetype to CMA if the page is located inside scratch.
>>>
>>> Signed-off-by: Michal Clapinski <mclapinski@google.com>
>>> ---
>>>  include/linux/memblock.h           |  2 --
>>>  kernel/liveupdate/kexec_handover.c | 10 ++++++----
>>>  mm/memblock.c                      | 22 ----------------------
>>>  mm/page_alloc.c                    |  7 +++++++
>>>  4 files changed, 13 insertions(+), 28 deletions(-)
>>>
>>
>> <snip>
>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index ee81f5c67c18..5ca078dde61d 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -55,6 +55,7 @@
>>>  #include <linux/cacheinfo.h>
>>>  #include <linux/pgalloc_tag.h>
>>>  #include <linux/mmzone_lock.h>
>>> +#include <linux/kexec_handover.h>
>>>  #include <asm/div64.h>
>>>  #include "internal.h"
>>>  #include "shuffle.h"
>>> @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct page *page,
>>>                    migratetype < MIGRATE_PCPTYPES))
>>>               migratetype = MIGRATE_UNMOVABLE;
>>>
>>> +     /*
>>> +      * Mark KHO scratch as CMA so no unmovable allocations are made there.
>>> +      */
>>> +     if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
>>> +             migratetype = MIGRATE_CMA;
>>> +
>>
>> If this is only for deferred init code, why not put it in deferred_free_pages()?
>> Otherwise, all init_pageblock_migratetype() callers need to pay the penalty
>> of traversing kho_scratch array.
>
> Because reserve_bootmem_region() doesn't call deferred_free_pages().
> So I would also have to modify it.
>
> And the early initialization won't pay the penalty of traversing the
> kho_scratch array, since then kho_scratch is NULL.

How about hugetlb_bootmem_init_migratetype(), init_cma_pageblock(),
init_cma_reserved_pageblock(), __init_page_from_nid(), memmap_init_range(),
__init_zone_device_page()?

1. are they having any PFN range overlapping with kho?
2. is kho_scratch NULL for them?

1 tells us whether putting code in init_pageblock_migratetype() could save
the hassle of changing all above locations.
2 tells us how many callers are affected by traversing kho_scratch.

Thanks.

Best Regards,
Yan, Zi

