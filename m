Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFEC0D116F3
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 01:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E846B0022; Mon,  1 Dec 2025 20:20:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F346B0023; Mon,  1 Dec 2025 20:20:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DAD6B002A; Mon,  1 Dec 2025 20:20:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D21C6B0022
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:20:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B63858E44
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:20:29 +0000 (UTC)
X-FDA: 84172775778.15.CFAEB4F
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4126F80006
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:20:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f0RPY+7Z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.61.64 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764638426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYYHHcRTAxh3lxp7s6DTkWx0h3LRhMBtt7MXYWDAcr0=;
	b=MJxDlMBmKoL2Gv7toJ/u2efT3qb4La796U6PbO9XsVZ53Y1PFu4ELsJNFJMIUUt2Tayaly
	LH4pEso23CikFOoVixkH5t7hLSveCqvLJWUUD6E3BsL8Xza+SRZMZFP52wXmZTPk/8E2Zy
	W6Ow+L2cQu4LEtaQm6q4T7DFBCvst9E=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f0RPY+7Z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.61.64 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764638426; a=rsa-sha256;
	cv=pass;
	b=pHteeXy+bEgmbSwdyEyF1HrpyofNevGZnz+WdNCoyZdxlGIY+CZOdI9X925Rb0POphjqZg
	qSvleUQGpYKnn7HPfIJeG5GBYeri+hG1iJwA6KxUVoWOTI1I3gHWYFFzUFyPoe/EkUEBV2
	sN9sNwAl6w0eUeV3IgYrs+QvFApHx3s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tjwKmaKBA++LMRWWqeTlhJW71P0+PjMYH0gz34zvS4GkeswAAvjyKYPbV/KcMJfeL/Wtf99slLeAlQXIJsCh9tAYuxmpll10LC4qOKLHvdfvtPFIhat30KrEWDJnuL88t1YNLn+nWd6lyf/2QMszWEIpDT7HYLIpaRoMIb1muGnqmePaGOaQQ7gNaM84iPIda4Nd0/XvITWSfBf9/jxQmuWacq8Zdw98ScAyn6cVjPUUsjSwvyNiITNEWeUInjGEfbrzouyevLFacEDhN2nis6eKelOFpkSyHxhLA8DrKuMRxZRmU6zfgZBOPQAHUTOLIx2TLbHy++ImKaiAdaNj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYYHHcRTAxh3lxp7s6DTkWx0h3LRhMBtt7MXYWDAcr0=;
 b=FLr18v2JQzTShY0t3Kq2jBj+35ZwY89BEBd7t7TKc8ED6rHjWl7LP7hufBUdl8joaQRTl0TY4fSGdmp1S2zz6jqZFgK4MV/PHERWEoFUZoYOXJxfMBvZ3UWBhgzbA3avXKY3ZIQ3rYAqmge2vApKDka6+j98r1hDVic2WmvQh857PLEVGw5Qn1tN3Z5Lk7Z0LySSCKtQY4CXAipu60P/UbbakCH9RmsoRnE9/5E5CkNcKC7IxjF7Kx0uqECLNj8iofP9YoTsNItj+EzO3jmxiUP7G8LM7RV0c7VPLirU1RCG04nmISPUgzMg6+ToFvBqF+dTVbEm2hc4qMb9yVTLhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYYHHcRTAxh3lxp7s6DTkWx0h3LRhMBtt7MXYWDAcr0=;
 b=f0RPY+7ZtVVXO81kIEJQB1yICW3haapO5FiuWEHpnJ8xY0pcE1XEQXzdTLEH5JaVJneKXXjqjIjIUuifKUpMwxkhGEOSXlLVbcexjb5znRUymqxyTm/2txqZOU4jvTibY2uU+vmjGcE3Wr3WMuCVAYkp45zw3SnPvOQOH7k+Xge3+AU5GoZh4ida9U383d1B8mxsMczffYzQvZAHGH55Y4yWR+LijlWmpOLX34Xmy56rRJqzP9Asp1NIAuAj3t2pD8e1jOgw9yZEKWR0acYGTCUPuJ0hl+FqPdv3fFQlRRNOP0emj0jTCgm7pY783NQHR/7MNocovPp1U94ogvpnqg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 PH7PR12MB7940.namprd12.prod.outlook.com (2603:10b6:510:275::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 01:20:23 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 01:20:22 +0000
Message-ID: <75de1c7d-58d2-4a0f-b86c-b3dae65fb52f@nvidia.com>
Date: Tue, 2 Dec 2025 12:20:12 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/6] mm/hmm: Add flag to track device private PFNs
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org
References: <20251128044146.80050-1-jniethe@nvidia.com>
 <20251128044146.80050-2-jniethe@nvidia.com>
 <aSnrnyfr9fvst6eO@lstrano-desk.jf.intel.com>
Content-Language: en-US
From: Jordan Niethe <jniethe@nvidia.com>
In-Reply-To: <aSnrnyfr9fvst6eO@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::12) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|PH7PR12MB7940:EE_
X-MS-Office365-Filtering-Correlation-Id: ac0476c7-2e9e-46a7-7856-08de3140f719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ck11aDVmSmtCUVEzdWVxOXJTcVhRb01ISzFwMHNIWU9uOG9zNFBwYm9yUVo2?=
 =?utf-8?B?YndpeGNlNDZzNFdWdkJqbFBtaEg3UHNFV3N6eHpNRmg4WDV1VkQwVWNGM1Fz?=
 =?utf-8?B?Rm8reTMyWFo5WjBQZFkwT3VVK0NPQ29aTzA0azhUSXJMdlk5VjU4ZDllMTBa?=
 =?utf-8?B?WlE4WlY4WDVuUjdBbk12NzU3QTB5R0dWOFIyVTlUbkhuR3N1a3k3bW1EekhO?=
 =?utf-8?B?VDF5NHFwd2J3OW12ZUY0MWR6SVFUTnV4SzlLd0tRZWhwNVF6aGhHeC9QZERS?=
 =?utf-8?B?UklxSWdrYlJDbXJoaE54dkY0UjUwTFpGb2VrVmlZcHRoUzlsTzJHMUJtU1Zp?=
 =?utf-8?B?UGVzVW9NdlFtcGRMdklqTElXdXlJSWVLSnJnR2NMbklMTTA1VWZlRkttZlgz?=
 =?utf-8?B?cTFROXBmc0x5VHkvUHFxY3IvVEVSUmNVSCtnSGNBdFFkOG5YVXpFZy9lVU96?=
 =?utf-8?B?TFNtaktpR0xXMUdRVmZEdGxqOXkydHhNVWNyd0I2aURrUnhsS2NKZ3dHOTVP?=
 =?utf-8?B?RGcrTFR3a0ZGa29VNTFwMUc5Q002MzRKSVVCL2dVWDBzTi96NE1Hdkszbms0?=
 =?utf-8?B?MXQrdFlycm1OQTc2aFo3R3hMKzZVazRvNXdYeXdPbHNKeHB0NjBtNUo2YzNP?=
 =?utf-8?B?SjlydlFFSzZhaVc4djAxdXV4VEZ1QnNnYk1PUTBJRllDNFNYdEFhN0JtZEVy?=
 =?utf-8?B?NWFBZVRHalRoWFVzdm5PVGtYQjRDOVdZYUVrdTNGSnkzaUxYcWI2M0RWOUsr?=
 =?utf-8?B?eFNsdDFUOFdHNHhQOEJxa2NYNTZLZUs1elZPRW9BbjhneHQ4TUNvLzlGL281?=
 =?utf-8?B?RUdnbVlINTJsQ2c0NmxOaHZUT2dzMzlsM0hBaGtNU3BYMzU1Ynp0YzF1NW5t?=
 =?utf-8?B?ZDdRU0NUb2NtTktUUW0yRTBXMWVnSnI4UUxNbXJjblFwR3RCZVl5bWN2N1pH?=
 =?utf-8?B?YXQyUXBVZzlTbHVCaS84V1dZdXNPMnRXVzllekRrZFVzMnRhSDZUbGE4MVBH?=
 =?utf-8?B?QlgySGZzelIzTGc1akc5L0M1TXJMTU1NL0E3SHVFaGlLNGJ3cnVxeExPTVNR?=
 =?utf-8?B?ZGRCY2Q3R1BGelg2R1lSckNjaTAzSWVoOWR5RXplRU5NS0NwVVVDaDJuS0Uv?=
 =?utf-8?B?d3hud0kwNzdNQ1BzYjFBNHo4VFpjNDRCeGR4dStKYXRjTnROTjdrSmRIKzRs?=
 =?utf-8?B?d3I2cTNSRlRSNVBheHNDRnRlMGFlRWlKekh0aVVjc1gwUFBpMmx4bmRXZWJk?=
 =?utf-8?B?eXRRcS9ITkQzWUExNXYvMnRJdXVCd29xd0pRQ2UvUCtHY3ArcVRPSE1PNmZy?=
 =?utf-8?B?U0lUOXk2TGl5VHBqM1liY2VUVXcrWVh5MVdXTm52Zk1Kd3YrNVVnb3lqSjVY?=
 =?utf-8?B?aXVvRy8rcFN6b09oS1k5Sis3aXlhRjB5UmljODdON2h1L01IYXdtOHNVNXNy?=
 =?utf-8?B?WDBtd2V5ZFZCUCtCc21lVlZBNHp4UUtiQ2orcUU1TzVMenBBaWF2S1dvOCtV?=
 =?utf-8?B?dXVvS0E5M3dia3dqVkFrVGZqWUJ5azE4clh1Y2xqUGVXY1VyekltMDB0UGdp?=
 =?utf-8?B?U01rZ2kremNsd2llZVY1S2huS1NRa2Rqb3FtZS9xL04xNHhaSzFFM3pIRjNp?=
 =?utf-8?B?KzlVS01KQmR2L0JET3o1TXdMdEtDcGFhQUhXNGkrSHdYbVEwaWpBdnorNGt0?=
 =?utf-8?B?d1RjdjJRVWhvZjBFL3A5TDZibDc4YWpyUUwyVGpoN2NYaU4rc2FRMFV2a2I1?=
 =?utf-8?B?NGtxcjlqbnd1bTRCcVd4eEVIRzBzTTFwd0lzUkVsUnNjbWVyNk1zbzBPMWxF?=
 =?utf-8?B?dEpQcy9rY01rRjJWZnNnOTFXY2lpSzIzSW8wQVBVMDd2cERlOGlaOHBmMnVm?=
 =?utf-8?B?ZzhFOEJmTlVLZSt5SmZ1Nmw3cmVidVJnN3ZTalJ1Y1RCM2ZvSzFGa0tFZ3hV?=
 =?utf-8?Q?9FhRiJdLtoiv0rBOes9Jb4AVV/OfQf6W?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEV2ZHdDK1VNNEhNVnBCeGJaMmppL1Y2eU9nTnovYUdIdllXTllFdVR3ckhZ?=
 =?utf-8?B?QzJ2TFovS3E1d2haZXlWb3VPWkQxNTAvaTYwemd4a3BsSVlGb3kwMjBxVkVW?=
 =?utf-8?B?RDJiTW9rUFp6bkNML0pSa0VVZjJISTZ1dldpbms5SzMxemwvbm9IUWswS2hN?=
 =?utf-8?B?MjdHSVo2VFdFVkRRMlZDemhCUERVTGl1T1RnSmd3b3NoNWhkSlVRQXp3U0Ns?=
 =?utf-8?B?RHVRZDBWMVArcG1KMGpuWTJXb1lUVU9UcHFVUFN3RkFCRW1PT0c2NVFmaHQr?=
 =?utf-8?B?V2lWU1ByZUlIckFvd3ozWDRMd1pCd1BVUGhmeHBibEJlb3phMnk5R21VN1Ev?=
 =?utf-8?B?K0p3Qk1zY0VWTzBrSXV0d2xTckVxdWwrRmZoS3M4TjNKNVorUDQ5Y0wweGJm?=
 =?utf-8?B?bzRiOHFkVzVUR3lKYjRBTFVFYVJSQk5Lc2F4eWlHVHVkZCtIZUxPWXhJZ0Yr?=
 =?utf-8?B?REQyTSsxcUVDb1ZaeVdGN1gwcTdrYVYrUkxmbUNZdHhYcVVIUUlvd3g3WUpE?=
 =?utf-8?B?VlRlTzkvTFp5bllpR2sxR1l0YWdMWFI3Qk1zcVY1MTVFY0ZLMjBqZURCU2ds?=
 =?utf-8?B?dk5YRHFUWUZsNGIyYnZvMjNvKzc3MldGM050ZXUwTjlNZUZFSEhmeW4vOVda?=
 =?utf-8?B?OUlISUtUSHpyNUoxVkdmUlJtVnZxYU05RkZrVDV3ZCtHR2FPNnNQVkd5OGFI?=
 =?utf-8?B?cG1BMWdjWmJpTG9DenRrVmJ4QnJEcUZGMXF5V0RYRmwzdEtPNW8reHF5a0Iz?=
 =?utf-8?B?WFlLamxHRGV5L056U0Mvc0VyRmplUThFZU9GclI4SEdjc09wWUtDTlJNQWxh?=
 =?utf-8?B?aENDbHQ5VHJZeGlBdHZkQVdzZW1uZEV2cW1ZWjVscHJXaUFQV3JjaXdlK2ph?=
 =?utf-8?B?bjN0QnE3YTh0ZzdrMUpqVCs3NmJvWlgzQ2xCUjFkdHpsd1dKanMwTFE2NVB6?=
 =?utf-8?B?aWJ5cWJjQmZFWXY0Rks5MUpHeXMwY1RaQWcyNEtBRHY0SEdrdnViZUp2ZDhM?=
 =?utf-8?B?Mzd5aWt5SHJyWU9scjd5MmladnVjOThYRlZkNXUzU0U0WVplM3pnMXdIY2Q2?=
 =?utf-8?B?NUdWRWFHVnNNQ0h0WkVQa2tjUUVTbzloTkxGQUxKUmxTTVdrMG5TZ2crL0Nz?=
 =?utf-8?B?T2RTWGFKcy9xMTFEYnlUNHRUM3o3SE9jWkJRZHhpRWM3ZVJrMDRMZElhdXpm?=
 =?utf-8?B?ZVF2a3I5dkEvTExXMm1OSGVlTThDejlScy85NnRleVkwaFpDWHlaS2F4Wi8y?=
 =?utf-8?B?VW1ZSG9CYW5DZ3VhOFBDNE9GSTg0bFV1eTJ1c1Q2N2ZlNWJnbHZwZ25GQ0M3?=
 =?utf-8?B?bWVCbXFZQi83QW9kcERIbEVOcVlJTWxJSUdxTWhxSHc4VUJ6a3dwSDdLUU1N?=
 =?utf-8?B?OHNZZHJUWWgvN0NWL2ZNRllVV0dEQ1pGSUhCd2VYVTQyN2gzQ0dIY0kra1JP?=
 =?utf-8?B?WUlEbEpRUXQ2eFdieHZiVlYvOXRjcERnbWl4ZjRabXM0N0JEZGh2MmM3SU1X?=
 =?utf-8?B?S3hTM2ZSOHZoRmJyRjUwTWEzWDhoUkgzY3BlUVVWS0k0bTdYTWg4bWVhaith?=
 =?utf-8?B?VTNnZi90KzJJVitiQnVTMnpkaGNyd0dYVWFXNzRtVkdxTmduemxpTmZ2ejVj?=
 =?utf-8?B?b0ptTWtjU1IwNlBHdEV6dnZWaG5vVEdlZDNZcWRKOSt0R1dXZHAxbVpVL0hi?=
 =?utf-8?B?bGRhZ1BzcFB1QkRNNjdVUmJ0N1YyWk9YbmtlWngzbTNXWTNIeVpQNFlZbTlo?=
 =?utf-8?B?c0U1MFB3bi9nZEI4VFZvRHo5ZG1wS3ZzOG43V1gwNTRQMnBoRDFVL1AraElD?=
 =?utf-8?B?Z3Bjb2M0cVROSkxnSWdPa1llcnVYMEZzT3hyTTdpOFJqR1hjR0Q4TDFvQlpB?=
 =?utf-8?B?WmMzMjVhTVFuc244Z1BVQVRtY3pzSnc4YnVyOVY4d09qRUg2aXpPMnlRWEtn?=
 =?utf-8?B?MmhtMjY3a1dYczB3QXI3cm1sNmxZbUpWdmIySkVwL1FsaGJLUFhnUzh4OXF4?=
 =?utf-8?B?bms1ZXpUbVZyZHlCV1NNdG4zaGtTZ1RWOHhnU0swMVgwb0J5dGVsbnpGTmNw?=
 =?utf-8?B?VlJjbTA4N3JXUXBEc2hJNFRSanE5TEIzUDI0cWNCcERBYlRRbC9zWXFLd1J2?=
 =?utf-8?Q?kaEZnTbYgJCoh+i7TOzlGJNeS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0476c7-2e9e-46a7-7856-08de3140f719
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 01:20:22.8616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MXbb6UvV9yDAG3YBE16SGHIalUZJhUM7ge0J7Hg1mZwwPalnrMQdcATK2l1J/fJnJZbFq3xzulnbow90n3K/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7940
X-Rspam-User: 
X-Rspamd-Queue-Id: 4126F80006
X-Rspamd-Server: rspam11
X-Stat-Signature: z61c6z57rk43u4udwpyiokpp8fkcj737
X-HE-Tag: 1764638426-498113
X-HE-Meta: U2FsdGVkX19aQF72CZARNcadYeMqFLO3aG5CQibfRbI72i529IjkUSU1sSYw5aQGEOE5/dIWrQkCxZ72qWmfypsbVylvspbOEn1aAlOus+4MRE3gZ1G1ekdd/dzh3o4eoaeDiqRVLGqw+ryg5VzAmNG7+k1t1oDfxdh3VyjfXhNJzdzkjywhn/NZbv8uscPmfcXRO8zf7TthQMVeCGT4+GLulOmNAX1CQHK/7LQ7/+LFfNEEC3KojLhgHRQVpqSpEPktM7ANnosFz2p08RomgkqtSWuCx4QIYiHS5WBataFcdg4VJIqF/wrQJoU5nxXlobBM/mJ3M6NlVMmXe3TwqlP1p2O1eL86ysZS1fFS72rnd54Z0LNwi4j1bcyq00U4eLlasVN3zUZoe9imGCfziA/vgEY40qE9FOJ3Xl71mynNMyomOp0zdCO3Xs+hNPnVRNMpfEhKJBN7kyDTMQfSgZ1RLbLwsd7sKLD6FCTeiJRGhuqYJVbSbxgNSTmj4hQ492a6WocG97DBQGW3Ik+WZVq8zs9/sKrgEkQZkj7uYspyk9jIvAXrPLOIq0GzN6TWu4eMdM2T9fqWCr5XvX4GU4Wkio/KlcRENa4crS3RkgrlZ6a7LVivjo2C1lHi/XWkxJvQmalLngI27vOdfqk2WNvzMlesi4mkCAOpt2MP16SyQ+ezDow56uZTvs0XKwPtNmKnN7FkYSYUmCDjxdmMLhgHdjQiwmTcGFBxbjFZaoTEHtPYhJ8km/NE7Gg5Rf3TWkxRYJEd8umKC2hZDBzqHPG2UkbDyC0PXHhb+Gz/k8tHBAYKvaL/1+RrfXFjUgWxnEq15m8D+mLrTDGNH0jVQQ7a2zUiGdFtISm0P+fwu3RXB7Mi2B28jkPwxwdJIb0+RWfGnQpX9TM/OMOOQsoz9wYlOJ6QXwbZ5yDDxZGDm0pDhiL5hdQ0FM/hNEZ6uXEuCCDpii86G6Tex0iK0kM
 FjVcETp1
 K+/Ez2mwx6gZ00oo5/HusVyh2Y8sW5uZa0MpkGILiGcONISROhH/agXWeGVe+J4rkEgYMVKuhVbd93RDTl9eowE/p8Hq9FxifXwIve4k6PP7irBy21q/8xRfeqv89qqAPlQgL9A3mUkrrn1PwYxwD+uTnDd0UjjxFYhpMG5AzP/i3HhQi9V1nNxlaUFeCYos35oQVJCRVHtk2Wavt+wVTfvLZwop3f8nEjk2FtqYYKHy3CQ5FDhijCPQK3tbLg9QmTy18ZUFDkSw9KSP3jJW6mw34KmWcd0NmPNSW6DHGcWQMgphS8JGgtYtjuORtOcFST3bA/f2HvwaTV54oH1LHlVfBJxbSKZW9T53FnBSSZ/RP011t98pk5UBfe8cC8fPEC+JiI2FsdSiSPvCbHF8FhRed91f6f3sgqEasYGDQxQ76IQhRmIrA7DHcBLsyHrsqIatH0Np4THFXFKDG6pXF3SSScg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 29/11/25 05:36, Matthew Brost wrote:
> On Fri, Nov 28, 2025 at 03:41:41PM +1100, Jordan Niethe wrote:
>> A future change will remove device private pages from the physical
>> address space. This will mean that device private pages no longer have
>> normal PFN and must be handled separately.
>>
>> Prepare for this by adding a HMM_PFN_DEVICE_PRIVATE flag to indicate
>> that a hmm_pfn contains a PFN for a device private page.
>>
>> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> ---
>>   include/linux/hmm.h | 2 ++
>>   mm/hmm.c            | 2 +-
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
>> index db75ffc949a7..df571fa75a44 100644
>> --- a/include/linux/hmm.h
>> +++ b/include/linux/hmm.h
>> @@ -23,6 +23,7 @@ struct mmu_interval_notifier;
>>    * HMM_PFN_WRITE - if the page memory can be written to (requires HMM_PFN_VALID)
>>    * HMM_PFN_ERROR - accessing the pfn is impossible and the device should
>>    *                 fail. ie poisoned memory, special pages, no vma, etc
>> + * HMM_PFN_DEVICE_PRIVATE - the pfn field contains a DEVICE_PRIVATE pfn.
>>    * HMM_PFN_P2PDMA - P2P page
>>    * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
>>    * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
>> @@ -40,6 +41,7 @@ enum hmm_pfn_flags {
>>   	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
>>   	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
>>   	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
>> +	HMM_PFN_DEVICE_PRIVATE = 1UL << (BITS_PER_LONG - 7),
>>   	/*
>>   	 * Sticky flags, carried from input to output,
>>   	 * don't forget to update HMM_PFN_INOUT_FLAGS
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index 87562914670a..1cff68ade1d4 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -262,7 +262,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>   		if (is_device_private_entry(entry) &&
>>   		    page_pgmap(pfn_swap_entry_to_page(entry))->owner ==
>>   		    range->dev_private_owner) {
>> -			cpu_flags = HMM_PFN_VALID;
>> +			cpu_flags = HMM_PFN_VALID | HMM_PFN_DEVICE_PRIVATE;
> 
> I think you’ll need to set this flag in hmm_vma_handle_absent_pmd as
> well. That function handles 2M device pages. Support for 2M device
> pages, I believe, will be included in the 6.19 PR, but
> hmm_vma_handle_absent_pmd is already upstream.

Thanks Matt, I agree. There will be a few more updates to this
series for 2MB device pages - I'll send the next revision on top of that
support.

Jordan.

> 
> Matt
> 
>>   			if (is_writable_device_private_entry(entry))
>>   				cpu_flags |= HMM_PFN_WRITE;
>>   			new_pfn_flags = swp_offset_pfn(entry) | cpu_flags;
>> -- 
>> 2.34.1
>>


