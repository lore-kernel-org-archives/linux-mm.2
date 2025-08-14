Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388FCCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D094F90017D; Thu, 14 Aug 2025 10:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93A1900172; Thu, 14 Aug 2025 10:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B336990017D; Thu, 14 Aug 2025 10:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9DC900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:11:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EFBA5A39C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:11:51 +0000 (UTC)
X-FDA: 83775551622.16.67917E1
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6271EA000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:11:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HzFLJ9ou;
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.50 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755180708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6XvturtgAynzxcssuiq+hkV2EP/MlA9+KGLFLpzrLg=;
	b=ALqdZlkBrGI+12WfvPKttjcXXyhq3OyPEav6a+bl9daOkeDWu5g/JSgu51l3qsFf1knqdJ
	FWs5GkpWnbbAqo2iiIc8lwnQ6//LJOhWH3qrQmQ5ZvDL/g9oMTHf2IVE20WFQOgTQo2WYM
	ux+JZQ0nUFmDsy2w1mVDqfiPEsjYEbc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HzFLJ9ou;
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.50 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755180708; a=rsa-sha256;
	cv=pass;
	b=Ig2+7Jd9HQTWPJu0RSN0YDTmQWCUryd+vmctXyKfaO9pISpJYno8Y+GKYEx1bY48NzVSpX
	Nr5PflnfuTijm2ZNvg/Ybp8zwlGtGuohNt6sk6wndGxQUMJi35uhJ6PW7vZb1pfOu1PO3P
	VuuBrGfi5wCaFzp2GiAO4KOUn4TUh/E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=onEPnD2QN/UpEpWtWwDKkR+1E6BGI1OLblqkvTM7oFKwHGk+w+iIUhHvmDttb6xgYdKawWp3Ztt7XGPz9lSgyxOax5sKQKFZxOcXWdd6AP6ImqoSHPO/KMXrAIRnJ6Y3qiHtjXTGhXAwpExBzrlS6Q5yDt12/SPKQR1yar1oUIyx8l2eU5FDkAX1TGdj/m+0sZsi/e65JetywzmhDVk0jvxPXDhdoiFrKzHHN08PHV6dxpUBEUnrd/bCrGP4ct8Nx0PVL9LqW6OfkS5P2vCQTggpGrPCaf+gNrXfQzDNVhJ9WteBtDApWr7NJXp1J6vyJc976F1jKqhNnqoShC1JMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6XvturtgAynzxcssuiq+hkV2EP/MlA9+KGLFLpzrLg=;
 b=bne83tB2Ek8KK8agHclEGfIItxApQTB8rP+koOLt/lD7HtvGYHpeouSNlhcKusu6oUUl5EmVur8W3ImqnxArMLlwEjrJTyym6qu5kKH87cTr+fCzJPpUBGTRkL369zVsU1gAhuy1alrEkwsNkKLai5+JLGequRK3Hz1u4dgDYvveEb19MCpiW8/YHsWGSGzmysdpliMWSGo8CTxaWbJ6IRQQuuuO4RkGXJzMNxPJtlnEZ8vk4pgmzIbrA452X/tnmV/qr0MteNoga//XdPW61hi/SYB91qpgSYnQSHeiiM4oKERVfRoH3oOec6IuImIZQwMOtltGdoIbQVlSt5A9EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6XvturtgAynzxcssuiq+hkV2EP/MlA9+KGLFLpzrLg=;
 b=HzFLJ9ouletUbwnDr3xCd1A+1wwws2vYhnWI2G/A3AMOqTXFjnjtBeFUIxdDVlYddp2a9oYinEz9gfqiSVVDdwpy3reA5yA0MsZ4WnMMwuWoDTEtNMUBPETJVLXpFkPsLdbv7vMHd2XC/ubIR8KXU/UMY/dP37zlqnL882QMr1Nqo8NiOWgpJ40lTCU4Ocm/xLlDG79ujBu3VDKr+8hk0Q1LeVQo54BDpTJwMK+0d5roRQiJiJk4Yhq/Nwu5y4+rPYzQL0jL8GHtmpFFissFWoHKTHorbnVDPtloTxFz3z0jVPc6DskZUe1qKgXyriWk7mLlBX/hzdqXTdMUIsN1Jg==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9081.namprd12.prod.outlook.com (2603:10b6:408:188::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 14:11:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 14:11:37 +0000
Date: Thu, 14 Aug 2025 11:11:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
Message-ID: <20250814141136.GG802098@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
 <20250814124041.GD699432@nvidia.com>
 <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
 <20250814130403.GF699432@nvidia.com>
 <67b6e041-4bea-485d-a881-cc674d719685@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67b6e041-4bea-485d-a881-cc674d719685@redhat.com>
X-ClientProxiedBy: YT4P288CA0041.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9081:EE_
X-MS-Office365-Filtering-Correlation-Id: 0044b72d-2d1a-4785-acd4-08dddb3c7b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TkIzVXlwdCtNWTVsN2p6QVB3UWt4VnYvaFRrRDZ2a1liQUNXekNuL2txQjZx?=
 =?utf-8?B?YnMza0RyQXRyUHhaVmVrWXFzMTNyM2YzYzVLc01WeG5WMXp6QW5qcXpjV2xR?=
 =?utf-8?B?bjBydTZzMm4rTFc3a2lVOEhBOTJHRWU5dlBoZEZ5QVBZMnNUb2Myd2ZvaDVI?=
 =?utf-8?B?QjJIeUtaSndRUUE4a1ZqdFltK01sMjBJTlRHd2RxMDRwK2RlbGYxRkRuT29i?=
 =?utf-8?B?bStsL09OWTJ6VDdSWWJVa3dWdEMyR0NWYUtUTVU1dVQ2bVhUQkhOQkRZdVZJ?=
 =?utf-8?B?NmZEbkNCMDBFZDFDeDREWkR5Z1JueEJMbFg4bXFxY09zZzZIVUpvK083Rzlx?=
 =?utf-8?B?dFAwNzhkaEFLWmtDSzdpTXR1V1QzQlBrYVN0R3JqUXViZ1lpdDI0Mjh0VjJS?=
 =?utf-8?B?cnk3eUtESjRnaGdDNWNldEFQNUw3UWZxak1QYUtmb1JXY3htMDF6YzNxaE9u?=
 =?utf-8?B?d3lPaWswWktTU0dialA2K1dncXl1SDkzMENzNXdwcFcxVzR6NldSYjdVR1ow?=
 =?utf-8?B?MzFiZHc1Kzl4M3B2cTBndkhqZ0RIS05MelNwM2hWQ0djSDdweWYyTmhFbEo1?=
 =?utf-8?B?OFRmSUNHQVpSakRFVWFGNm82L2VyMUIzOHBiRzNnZUhpbnc5UkxGNWJoMTJW?=
 =?utf-8?B?YldmNWFvWFdOM3dhN3p0L3RWUEVrMTFyQ084NU1MbFVSR0VldjIvZC9LWVVJ?=
 =?utf-8?B?RHpabDNJR0lSaTk0cTU1NWRHTFdFME9rWUIzUmY3a0ZxSGJ2U1NnLzVacllw?=
 =?utf-8?B?Z01Mb1kybjRxeVZyWjUvWTREZVI0NWxhU0FWR2RjNFA3anEwSDhFckVNalpR?=
 =?utf-8?B?dDVlWXR2eThxN0xJNnBMR3drR1BnWnQ0TndJMVlXeFQ0NXFFZFlSOVZuTW1L?=
 =?utf-8?B?b3QwSmJBenY5L1ZVcnZEQ2tEQVJvM1RTVHZQMks3UlpJUTU0ZksrdVI4VnI0?=
 =?utf-8?B?SDN3c0NRZWNqdzFpeHphc0hYVCt2OUMvMDJRQTUxOW82Y0lIMDFyTWdPaDRB?=
 =?utf-8?B?M3FNUkJDTXJldUYxN2txazdnTnMvcC8vMmVYamt5aFJrNGwrZCtGcUtkb0JZ?=
 =?utf-8?B?TWxxV0hrSjhCWkczMDlyaHkzeGRrZTExV1puOUF0K3c4blJGRDY4M3R4Z0pO?=
 =?utf-8?B?UG04YkFBVVg3K3ZQRTJnNDExNlN6a1FNNUdHUGhmaEFnWTIvdk5TWGdDVlYx?=
 =?utf-8?B?L2ZvYjg2azNzZUJEUFpCdG9oU0wxV0VyVmlmdkUxRjhkUERvWnQyd2VPYkpn?=
 =?utf-8?B?SjIybTBwVzZiWXpxc2MvbXdicCs1amhscVJkSkZ4a3BPV2UzTStEcXlHYVh0?=
 =?utf-8?B?QzdsaEprY3JjSFlVV0t3dTBkSi8wdjNvZVBqb3RPWERqNExHdkdDblRlYk5E?=
 =?utf-8?B?eGJLdDZuZExwUFBTZm43bmkyVm5VTWx1Y3NKdTRMd0kvVWo0ZnRvZlY1cU1j?=
 =?utf-8?B?MUx6R0FZZUpCdGdpS2FnN2ovaWkrbGVlczBwTVcrclNFVFJWTnFzenRndVor?=
 =?utf-8?B?TVpQRmdnZHdJeGhUWXFJWkJSUlBsb2huQmVibDNMN2Vza2NPaWpJQ1F2KzZG?=
 =?utf-8?B?MUkzWFE4cm9QdjBqcWdHcFYzS0Q1amc4Smg0TVl0NmJmc0FTSzIxL3NTaTVy?=
 =?utf-8?B?NFdVZWpEbURPN2tDYm9IaUFSZjk0cUJYd2xGRCtsVEZJeHkzcFlOWGZ1ZE9m?=
 =?utf-8?B?OW9IaXZ6bU90Rk56TFU3K0ZDUXpmbTBOOW1zRVNLQzQrTXBlNm5sckxDRlJT?=
 =?utf-8?B?YUJFRUZJakIyVDdEUVhsdFIzc2FPVnlWV2VLQklTcUk1WnFLcjZ6dzNYMnVC?=
 =?utf-8?B?MWh6OG43VXJwWVcwa1VHZ1Zwa2N4TWFuOWZ1UW9XS0lsbkdqTENpbUc2Qm5D?=
 =?utf-8?B?TTJCVVRlUXRaNExuMjI3K0F5alNITzJJNEFGcmVCaXRvK0YxRkE5UHdYdDJ3?=
 =?utf-8?Q?f+cP+BiaGYs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjlGdDJCbktXNU52TVZueXQ5RUFLSVV0VFBCTTlIaUR5UGdYVHUwZmI4bmhO?=
 =?utf-8?B?M3p1d29wa0hoWGhISmExb1phS2dUeFdQdWUvSHRyMG8wdk90QzIvTnNWNDFi?=
 =?utf-8?B?RnJpZWIwcFIxWVo5blM2MGI2VDZZdDlORzFEdEMrMXpFbkp6N1FLZzRkTklz?=
 =?utf-8?B?ZXpCaTArUVFXWjhjSG1POUdhWWxXeW0rVE1sNXRnaS9URll5M3FncjkweVVG?=
 =?utf-8?B?NXVXSjlQNDZVL2haV2tocVR5dmlpV0MzU3cwNFFqbC8xa1d6SkdMWk01U2sy?=
 =?utf-8?B?czJzNFJVZFpDZHJYWW1NeEtDSnE1MkQ0U3BmckJhbWlUaFZpRFRwSjhJNmhl?=
 =?utf-8?B?dElreU9obzlYaFQ5YmhPejN1V2t4UEF4YmJIMCsySkN5ODRGcGRkSCtMRFFC?=
 =?utf-8?B?a09vYittZUdzd0g0N3VpNGZ1YnVzTDEzTmpHUy95a1dEeGhtdCt6cEFLTndD?=
 =?utf-8?B?ZGNza0N2cTFSa3gyOWpXZC8vcXRldDkyOWdxbnZnTngrWXhmOC9DNXIwYS9E?=
 =?utf-8?B?VnZNQnl0MHRHc2ZzR3Q4ak5oWVFhUTZIQTJTSi9yeTM1OC8rVDFuTnBYVW01?=
 =?utf-8?B?S0ZGTktYQ1lMbHRFNlNFdXFsakkvNFZkeEV1YnVuSGRUR1pHSTJydHJIWm4y?=
 =?utf-8?B?bllHcDdneUZSZytNSnZRaSt2dDYzU2VsV1dqbk45YkhHbkhmdEpEUXV2RHF1?=
 =?utf-8?B?RzJ1ajJYekZvYW5wUFk5NEIyL0RVWThqdkFqRE1rZklmaFlGNXBkVWFEaUhK?=
 =?utf-8?B?NDdnbTVyMndzZlVFSUVWNUkvMVVVT3VOUkllWFVCV0tScDVJbmpzbWFxRExp?=
 =?utf-8?B?RkxPNHRqc1hZMVlWZDNYdk1OU3paN2JZanJFN1RYVDQ1ZUE2OWJ2ODlKWnNX?=
 =?utf-8?B?bDJBUnRFNWU2ZTlHWGIxLzE2bkdnUjl1Sk9yYlJpK3gvWDBEbW8zcGw5R0FJ?=
 =?utf-8?B?RWRRUTRCQ0dJNkFSSW5HOHNaZlNkSVFlN2VZMG96UGhBV1hBc0FnZFRFM0RB?=
 =?utf-8?B?Yi9mWS95WDJzRHdJOFdsVkNQdnpaci9BaElCbTg0SU8xWm5OREVzOWJ1Z3JS?=
 =?utf-8?B?ZHlsdjBnaW94cG4yVnJCckx3MHFxcFZreUYyZWp1blZOQzRJQm9JZGltM0Y5?=
 =?utf-8?B?U3lISHE5MFRjSkZ4NjRzYmhPY055clN0Zlp6ZjYycG1MQjJqTUt4MkFhNFpk?=
 =?utf-8?B?U1VWSExsNDA5dmNpeER1M0VsakhRaVpZOFF6enRMWE8rM1UyQURFRXFsU2tW?=
 =?utf-8?B?YkJxalJOc2sybXRha3UwbXZUa2VINk5GQ2V2MEt6OExkbXNrODRmaXdTbDZD?=
 =?utf-8?B?ZS9ER251TzliMDMzbkVxZTNZYkVQQzJUanFmMlYzV2xaSVYzVDk3Tk1OU3Uv?=
 =?utf-8?B?dnJRZXVNeGpNYTdQQkROZ1A3SE0zWENCWEdXVHg5aUVWVi9VZjZjL3ZYVGIw?=
 =?utf-8?B?MU14ZlczNVN5YW1OdDlmWjFnSFV6STYyOTZKWE0yYmE0R0FlVzlIOUJLay9H?=
 =?utf-8?B?NnYveW45UlpIUW9Rd1o0aW03R1daV2FVMFVaWmZSd0FBZ3MwTHFPbitRL2ll?=
 =?utf-8?B?azFwY0pvSkl5dHdHZEVzRmxnMkJKbS9Ga3FUbGV2alFHU2YweXFNWHFwRGMw?=
 =?utf-8?B?cVRuYzdZV0ZhUmRaUU5GdElOc3hHSFV0YXJiRzZYR2lHTkdNVWp2VWQ3Nkkw?=
 =?utf-8?B?V1hDTzNFZFRIbGN1NmpCUzZ6eUdiend0YjVqRUd2c2tyK21Oa3hGQjcvaUpl?=
 =?utf-8?B?aXhZTVhSSGt6SDYvdW9ESFJHcHB0NzRkQzFiUWZGN2RvNkZPaTRMYnhBU2pE?=
 =?utf-8?B?UHJvd2RTSmVDNzlWTDgwMm9vcElMM2NVSmNwaFdKK3BXZWpPVUFjQVhCRWho?=
 =?utf-8?B?S09McW1Bbkx5SHZEdWl6cW5MT0xIK281dm9OeUFtRGRPeU93VG44Q0VaWTFE?=
 =?utf-8?B?YWxyOFBqYkN2dFp3MXhxbjg5V1hzelp2MjNPTk1sZ2tyaFJKR0xXMlFFUWxu?=
 =?utf-8?B?eEpCZEtNUHZwcys3T1pGSEw0S2RrRzYvZEpxR0FVU2NYTVFieDhLYW9FQXoz?=
 =?utf-8?B?NVpXckZxSk9BSkZvenlZeXhQd2RwQzQ2Y2UweEUrdVdWWjRiVDZwek9MMDBh?=
 =?utf-8?Q?XgQY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0044b72d-2d1a-4785-acd4-08dddb3c7b7c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 14:11:37.4959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqFPKWJle/UAzRhGnCcQrgHqKiJDs/+ROkOps9lEes9o7OrgHfeN9e9T31PDJySy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9081
X-Rspamd-Queue-Id: 6271EA000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6zqkyzmcsxmpsp3xi8jgt3d5qh5ie6sg
X-HE-Tag: 1755180708-802023
X-HE-Meta: U2FsdGVkX1+2IdLq4L0UeIdTuvdBNgaVUgRu+Da8IKERo8TOrooaY/MjjzpDEU3kLBvjQzE1BDbnr7oOkb+WFytKBJvECy/3O/g0NBqL8g2bQxB0uYOqpT4u0pUmhjjP7VHcZq2dwBX5tEvBAOa1BmL6f57rrOsCryOpEWlqT0nd5hayoS2OjLdWXeWTgZa3RuzzWFK8xS0E2yTZIR2k/Y/0iKGBapCIulgN+ToIeIHadnIHJ147Wq6gOZiQ8A3573XuJ4xxczY9jqUd8nZetpYXpwCU2e+YnoB42OC78pjkwnutiVAXp08wcuXjUB2cf6dqUc7IFz/CQ5QgScOqKlT/md+zmJQCo5wz3rNNP8wdQXMffb70PDZx5GK8tHtPiUedUonnv7cgjGEpkhHgtDMPZxQoSPWAJXCSjH+9qGKVBQSuAgzstTn+koaDDFZ4bkfF67cN7gKv2OmvVbG0WACJdLWJ0U3vAefNThxezLb2NSkljzH5IesuYHSKxNanHHCx65Us/F0emuYlsvKYk9TkKzOpbI/A9ALaP86j05DeeQwfkFkT814DCL3FZ/DWpIdNEL9zpXHAKYxRmbyfjbx8ZXR+BOsrgr4Xv/pdv010th6QZA7nTjRt2y0MyK+zBQDjCU+KHRG4XJ4gveaZ/qDDaXhGHzfHxlZ5pluVBosjZylJko14bOhJlgTIgkzEBp/DRQ/DsB7WnuqQhoIos/z023C8mhyWJHjkOux3ihas3mFE+b2Cxkp2Cb6FDVcwCUrUVZ4fQ0RkIFiZ2A8RKl7qMv0F9wj40cMntLL+T1yB5mXCOEsTfR3Zza7I7oRq4p/Mm3hl7vRSy6cGhgbDXc+5RLJOTLdxFVf2y5qeYzEhhV/kGrzwvAw65xIOD+/MUdOjkpcx4M9ED2NiGASUt7dQFSguNMlBuieP03oPjUcOj8VcXyvcI4jW3Y4Vp1Y5wwHUjzgPdgGAR8745L1
 ZFfG+tQ7
 lXtSGCezAL/h4KPPcCMaPxQdqXczjDetukHFiUmd2TFP5irM6ysJ954UQKXN5caj+gq9Nv+adlEszXFIHXvVWm8gtYw/i4JVaJWwXbe9/MrHne1m/OJCLGN3RJYKGIivDeGGGL96Won4CkeXpbtHR7UwswcQ1pVUZsou0BxOhb6JGq2PbcTo6zWlwmcHlSWFEzaiQ/AOoJXLoUY+wYH9Xb/clhCK3pTqouO3VWFTbnTCcH0lA/ZMmwY4EzytKywdgqVbyk8x+hj/xihQ9o0v2EwdCLG6vT0bQ7qEVcgZnWXHDQECQS3BabMEW9OmPjCqkFwWWhoRJOnjrAeZcVWjjkJpmjCiSMss5SbdljAfQLA+09JCou/NVbcGyJNDwHzw49vhnGc0xgzaJ/xoiqeWsLMHLVEB4Egh1bgj25bwABchlmdO10yhY1aMOTkjZT7YaP6LcaTvzR62kiE6DH76aRy35BaAVyD4via+YreYGe7LPKVRiTLb4VzHnclTdXfcdo1AUSDuov6XdLvu7GHIHHqiBmQDHd5QKqr967ljpNDtHeJHhy4xavCZEi7r1hxcHqlPE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 04:20:42PM +0300, Mika Penttilä wrote:
> 
> On 8/14/25 16:04, Jason Gunthorpe wrote:
> 
> > On Thu, Aug 14, 2025 at 03:53:00PM +0300, Mika Penttilä wrote:
> >> On 8/14/25 15:40, Jason Gunthorpe wrote:
> >>> On Thu, Aug 14, 2025 at 10:19:26AM +0300, Mika Penttilä wrote:
> >>>> When doing migration in combination with device fault handling,
> >>>> detect the case in the interval notifier.
> >>>>
> >>>> Without that, we would livelock with our own invalidations
> >>>> while migrating and splitting pages during fault handling.
> >>>>
> >>>> Note, pgmap_owner, used in some other code paths as owner for filtering,
> >>>> is not readily available for split path, so use current for this use case.
> >>>> Also, current and pgmap_owner, both being pointers to memory, can not be
> >>>> mis-interpreted to each other.
> >>>>
> >>>> Cc: David Hildenbrand <david@redhat.com>
> >>>> Cc: Jason Gunthorpe <jgg@nvidia.com>
> >>>> Cc: Leon Romanovsky <leonro@nvidia.com>
> >>>> Cc: Alistair Popple <apopple@nvidia.com>
> >>>> Cc: Balbir Singh <balbirs@nvidia.com>
> >>>>
> >>>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> >>>> ---
> >>>>  lib/test_hmm.c   | 5 +++++
> >>>>  mm/huge_memory.c | 6 +++---
> >>>>  mm/rmap.c        | 4 ++--
> >>>>  3 files changed, 10 insertions(+), 5 deletions(-)
> >>>>
> >>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> >>>> index 761725bc713c..cd5c139213be 100644
> >>>> --- a/lib/test_hmm.c
> >>>> +++ b/lib/test_hmm.c
> >>>> @@ -269,6 +269,11 @@ static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
> >>>>  	    range->owner == dmirror->mdevice)
> >>>>  		return true;
> >>>>  
> >>>> +	if (range->event == MMU_NOTIFY_CLEAR &&
> >>>> +	    range->owner == current) {
> >>>> +		return true;
> >>>> +	}
> >>> I don't understand this, there is nothing in hmm that says only
> >>> current can call hmm_range_fault, and indeed most applications won't
> >>> even gurantee that.
> >> No it's the opposite, if we are ourselves the invalidator, don't care.
> > I think you've missed the point, you cannot use range->owner in any
> > way to tell "we are ourselves the invalidator". It is simply not the
> > meaning of range->owner.
> 
> Usually it is the device but used similarly, look for instance nouveau:

Yes, dev is fine, but current or struct task is not reasonable.

> Yes the commit message could be better. 
> But this is essentially the same as nouveau is doing with 
> MMU_NOTIFY_EXCLUSIVE handling, just not using the dev as the
> qualifier,

I wouldn't necesarily assume anything nouveau is correct, but this is
certainly not the same thing. nouveau is trying to eliminate an
unncessary invalidation for it's HW when it knows the memory is
already only private to this local device.

This is not a statement about callchain or recursion.

Jason

