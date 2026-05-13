Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8C3CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 01:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF556B0005; Tue, 12 May 2026 21:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6876B008A; Tue, 12 May 2026 21:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5436B008C; Tue, 12 May 2026 21:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9A0C6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:47:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 381C4C23AF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:47:39 +0000 (UTC)
X-FDA: 84760709838.11.9E0E593
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20BD0100007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:47:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UJ5Z2WZH;
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778636856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Mo7567fInNAu+dQHUXs541AHm9Ru6X/GmSstymuOZ0=;
	b=jIqoGoF1ku5mTJcENS55YZ+TUyBDzNBvAUc8OxZcVmBHpm7rmbL8XbzmECEbhxR7tFA+gF
	jeJbN9OGINr/mHwG4Ov5BdrqDe7oe7nZnYMXL/6bTfUSg1VHm+86jT3JjoMVJwSrajUi46
	EW8668LNl6+/hQzARlkpyRXn8LQwhvE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UJ5Z2WZH;
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778636856; a=rsa-sha256;
	cv=pass;
	b=F3F9/XzIBJtuqZoSrfP8U80fNrStOYK605rEWDJ2AoqR0oLjw9CmGt4jyg22mi7bmkdh/w
	eiKGixIEAMJcR8BkMid4MVREk9rq0dwq9qtsO8P5WypM/uehkeJ/plWdMEkazDb3ap1SaB
	s5CJ0zzrpB8ZoW0HmNsNmk36rCEkIpM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n6CkFCOuzqfPOwHVWNt25XCbo+n4Fo+hfU8y0jswLT6SSnjJk1Wmcd8qAyO7CBqbehjUTLogj+X7ky12k4jHg1yltU2yaFREfHLSXNYD7/Y7Q8pdbbUwYAMAsHVnMT4YxGBabGG2LemJKT9Q/uRP7Gj5Opq3IZFIhMScx2COBiHbekdE2C0VcZ2D/ASKYeohuXZX9+Hk0VZzWc7xBJgPUNiPutcBY7SfFWARZGPojDQL7KDToqHKPRLOqFYiWPc1Z0Y3Kw7vATrmlxX0dE2Rk+i2Vpi/DqikFf7lHBAnRjRpXTafJPEey1rm/yj/PBPXh+54d6IDHYQh9SHo1P26rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Mo7567fInNAu+dQHUXs541AHm9Ru6X/GmSstymuOZ0=;
 b=Frv50xTXO7XNUqTGAEkyIuW9nfXY28HUEV/xbKC1ACrxBPJ2Zz1QzBqWMpT+MAs3gA9T9333xxEVYvPfkoNNwOWgjyWO8XP7Mr8W60WWMlRavulppIszyHCUWPDeUuFf9stT1wdcLDy/xtP8MzZ5eKcJeHU697nCU2wZ9HsnJiJtmDSxkLMxUeROzzfvMli4h3bqVImfpiJgSb6VVvME8qRjSnHENvDQD28MQVe61GZ1QmokDLPgsUEAwFrSdLGntvdZFrMIIPk5xxlkqJaenWnGvTgjCf6qkw0Ix5FrfaIMCmZRFEZMNV8zBaFLqRFMlidMincTK3q1n2PS9AbZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Mo7567fInNAu+dQHUXs541AHm9Ru6X/GmSstymuOZ0=;
 b=UJ5Z2WZHlIw1BVsNZIebccgFPrnzSFjPviM0e7L4WSnZcWAp8A+fuP9/i+0432KVkIlPyNYE7wVpT41yzP6Og7u/2b9mFpsjH4MBqS3X3qGuO1hoybYoNXN+lXNKMptSKjiuLMyJRBLN+zYAiQ8eOgpyFmgd6LYQW/tARWa/PPu7k4IozzNblrtuSbgrhyMJmc2XvxXGPudxR+9EVDM9KsS+AK9MGDyOoU/eittUuZOB61OORfspyflbCwAxGtf4d4QYc157X0N/5EQm4AV0Fet+GD8xXWaP0DIAYNUIg2hiWChx6z2qXEWtzuWOV6T7pAR0+oMLwV4SOrCfGGP1vQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA3PR12MB7923.namprd12.prod.outlook.com (2603:10b6:806:317::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.21; Wed, 13 May
 2026 01:47:31 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 01:47:30 +0000
Message-ID: <9d4f132c-916c-49bb-beea-2c829f0ce9ad@nvidia.com>
Date: Wed, 13 May 2026 11:47:23 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check before
 return device-private pmd
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, sj@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 stable@vger.kernel.org
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
 <0aab59b8-71c5-4059-8281-5dd876946528@kernel.org>
 <20260512143542.izpp3gu4iqxttw3f@master>
 <113dddc5-27e3-4e9e-a90c-f076a4629f51@kernel.org>
 <9a56d762-ebe5-429e-9fc8-a9c9e5d0d434@nvidia.com>
 <20260512231442.53qwj37fbykp2qus@master>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260512231442.53qwj37fbykp2qus@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0058.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20a::17) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA3PR12MB7923:EE_
X-MS-Office365-Filtering-Correlation-Id: 725e7bed-fe07-4cbe-f2db-08deb0919824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	nSQgbyCIgD8fq/Boz3QetOTEgZBCEssenpgmNhDJoc2jn6whZqB4FKZ1ofOC+fTk7YI9q3T2QW25ygwDrfWiRX/W7hpDTNup2T/7adp97wKzioXZZYuntaaFHVRynneo62YINhAaXqh3aNkFiTkaVsgskzTEM+IFdil8WNh9UCcs7LvWiU1qXsD+PRKlQehozQxXrxkM9kCODpFpF9soUbGTA7jGjC0zO+F2CtYFFXbrzirKF1k8DK4wyNhIezJyjJdFJ3H4pV/L2ZHsRY3Md+hszzyaTTev98+nNJ0lx/zkDcWLPBZbbXFfjI3JJctmswQXPk3kVS+sQgHJHhoFnWT9G97aHbS6o+L/m8zaTxTNQBm7pskzFKF41nGaPw8Ht1/UUYYniBwaPQvgO187Kqv92hJebTQNmbODryNYzKVi7Po+F5KDwYJIXAjw8Ot2x84ifgsIKjyR0g2pXfcQwwFTAe4n/413wY8Wz8KyU3a4E/3qzJuaAX+bO2EJYG19uPRyZqPYdISTRjRsjKWLczK/toVttpxb/vVEUaQXAAg5sLG4W5StZqGV5apf0/tpvZq01P9ntusbL3mtOMkzZtP4kYgiNmsDiOC2mItQfFCbtLFv+LTjFTog3J5tZvQ4mPNTNo5vTsmYJxu2dUZzX9WhDxBykYfiMTiHOoiW5p5y9w4LubuNVuMzDTb5Kx9Y
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTVOaExndW1meUdmcnJrejFEbkNvUzV0WCs5bSs4TkN5czBGY2Z2S3BxMDAv?=
 =?utf-8?B?b2t6TU8wa0w3OUwzMGtjR2VRaHVwekUyQlJOL01YREdCQ3IvYmdnMXdDblN1?=
 =?utf-8?B?Qm14YWhaSFpqTWM1WkdXYzVtNE8wTkVVOTZLeUcrTVdZTlE1dnJ6eEFnN2lP?=
 =?utf-8?B?VTdqTDZPWmVsQnBYSEsrdjE4VE00MzNsSHNsZUZYcVJibXJDTkEyNG9mRnJP?=
 =?utf-8?B?c2ZWcFpZTXZNd1NhVFZKaHdUOFpmTTFDSFI1TlBYM0xGVzJ6NDNjRERZdTlY?=
 =?utf-8?B?dnhiWHpNVFFGNVdQdFBrVjJ3b2pzdHJsZFdhQVZKTmt6Y252a1NQN1VmSlhP?=
 =?utf-8?B?YUdQeUEzWjJEN1ExZ3lPN2FhQlh1c1hldEhIYUFoN2o5MnhEWDdBcnRnRnVF?=
 =?utf-8?B?UHpUSVZMTXFTT0NoRTI5K1U2N0pSaE9JL0xvNWFIOVYza3NHenRBNjdiZ2FX?=
 =?utf-8?B?bWQ3bU1tdTBuL3Njb0JMRWtUV0JwSUxBQnJYVVN3QjdLaGFBZktTbVAvZDJk?=
 =?utf-8?B?Qll4THJ5N2pZTlQ5bm5CbkVGaWJtVVd5TWhYcTJLb1VOcVU0cnI3MGd2aUVM?=
 =?utf-8?B?VEplakR6RFRKdFYyekhJUTRsc3E3N2xsYUlJTGFFNFE5d20zeElmUUpwNCtU?=
 =?utf-8?B?VUZxWnpaQUluSXpRQzhzSVFlYnFxbWVCWEUwTGJoSURxd0tpQ1VzZkVXQlJo?=
 =?utf-8?B?b1ZmT3lhdjZKbGpVdFRSSDdPMGhHUWJxYmIrdkNaQzZnL3oranZtRUtRTUpi?=
 =?utf-8?B?aThuUzF6RUYzQ2hnV3RiTm90VzJpUlFFWm5wOTdoZ3dFalQyWU1mR2hVaUZV?=
 =?utf-8?B?eFpqZUduakEwMWZrNUhmbWdFVzFKQ2N5YzYwNU9DUFVlcVlqZ2hwQ0FUZ0xC?=
 =?utf-8?B?R2RlcjQyN1EwWUhqQVNhdDAxSGdNdkp5cVB3elJxYW9yM3o1VVRKdEN3N2FT?=
 =?utf-8?B?OGZ4ejczYy9oTXFSMUp4eGJRZCtBSDMxUExtZ2loMkFwTGJQUU5lQmh4am15?=
 =?utf-8?B?UHVVNWs2TFJtWjZrVXMxM2pET3h5azhXYXNPUGsycFR2cXVMVGNyc2cvb2dC?=
 =?utf-8?B?b1B3b2dhQXcwOWd0R2JXNkhMN29lTGNkWGYrMVhxeU4wNE5iWFlXYStueG5o?=
 =?utf-8?B?bEc2ajFWaGs2b0ZFSmprQk5NRWJvQXZTcVYxRzlSRnZTM1gyTitIa3dBNDlD?=
 =?utf-8?B?Y3RrUlROWWtFbkxVSzgvLzhhQzFHZm82NEpTT1V6K0tPZXRXTzhzUzlQek5o?=
 =?utf-8?B?ODkvZU1ZeWtlQzFzd1dTVGFObUlGSHNadWpaV3RGZjVwZUVGRjRvdVlmSFRS?=
 =?utf-8?B?cWJvOHVMenQ5N3EvT2pnaHdDYVBqTmRUekxKZ1B1djdRVVcxNWlvdDZpa1Zn?=
 =?utf-8?B?TklkTnJsM3lpMmx5ZWtHS09LaStvS0drZFdrQVNLNjB3ck5QWWwyQWpkeEMx?=
 =?utf-8?B?ZnB4a3hIamtjNkJUVUdXaE5PU0VHZ0hZTmFTMWRzSHgzOTZHMWlJNW92YjFQ?=
 =?utf-8?B?bk9Qd2w4djl2SmhWdWNPc1AvV0pSTDdFYVVQbGhxMTZKRWVoWFR3cS9PWmFZ?=
 =?utf-8?B?OXFzWXYyczY3SmNQeXRKdEEwcUk1ekpUYjBlL2pra2J5emZzb3g0Y0hmb0lD?=
 =?utf-8?B?UFJJY0w3WDNWZ2RTWTNZcTdjc2JGWWhub1Y3dm93Z3BvWDZ4b1Bldk9xQ2hQ?=
 =?utf-8?B?UE10OUtkZUoxWkkyTVZ3V1MrY2xVbmVURytYRWFGMUhlOHA5M3ZUem5CL3d2?=
 =?utf-8?B?U0RYdHA2SFhiZ0NGVk5OLzBFL2dSUldBY0VDMGFxQmc2aTF6ZC9HcUdPVENT?=
 =?utf-8?B?T3JpU2VRZ1l5aWdHSWttYkR5UkdqV3labVlOd2VxenFmSHFjQjYzYUZBNFJv?=
 =?utf-8?B?SkJQVDVZV0E1blRxYTJZOUlVYkR6MGlyYXI0WEMzcStKNUV6cFFaODI0QW5N?=
 =?utf-8?B?S2I1RVNEWE1vY2QvdVFTMGpDM0lrQVdwcmE2NXEwNUpicnJsdVE1SkFyLzR0?=
 =?utf-8?B?SXJINTRmYUx1QVNGMEpPMFNSSTIyOVpFMTlNN0VlSTZoSkZxV05KdUw0V21z?=
 =?utf-8?B?QTVnSUNYS24zQVh6OHZTVjVTL2R2WGpmYlVmVWJBcElUdzN1alFRSndLckJq?=
 =?utf-8?B?UWNwN1dIZXJVbHh5Q3BZYmdPYnpDdHJXbENRUHFTeDlQUjBJMHlkNVdZV2JZ?=
 =?utf-8?B?TXhEODZLeDJ4MnRXWHdsK2c3aXZqalo0NkVPRWIreVJQK2lWcDc1cUlUUjJI?=
 =?utf-8?B?c0diZllLNy9QdStiWFRUWTRtZGxObkFnRlVhZGRiTGNXRGlFdXdDNWZEMDgx?=
 =?utf-8?B?M2gwcFZ2aUxpUXFwY21LdlcwYThFVE05dUVqclBCbGVkcmZwbzAwQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 725e7bed-fe07-4cbe-f2db-08deb0919824
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 01:47:30.6765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3yI0mYRTnJefSVI1LcNxj2ruDEfQc2MHqU3nDisFkX9PdPoxYFW1sshahiqNANY12b0hmeiFAwHyveuuY2G7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7923
X-Stat-Signature: bjja5gims3g4xus76khe6rr6xpdk1yo1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20BD0100007
X-Rspam-User: 
X-HE-Tag: 1778636855-80831
X-HE-Meta: U2FsdGVkX19B+X+TEsJDXkJ/6NJcjxRofA678gvdykjMmZff8koQn+OFPKplEGZRUUgN5njMFsr0TlyyyAHsJYXRT5yCXxiVaSujLetyJMaD/nDDCg4VHjgUz1gRIgG0JW0/ZPRbRG8wPRVMtHcO6w+N+DJv5KHPWbGGIEfA75JVYBcLdXFQXXkWO2mjpLdgOH/pSRO5gAg5XuI1xseEjtT2InIpYpuGtLXqN5JDSt/mRRTnnxdlwHAvYOnoZx0pbanwqF00gOgVVliUgEIe9sqD3aPy95bllhX0YtAvAFJuOCslBJVo8geoub5t3Lir4yT7io96nuqSyBew1tbf4LeJTBk1eWQ6rBLO9D0Mg50jzT8wQ5iVCNaGsCDzcVXHC0QvbdCfcf6vbDjBBS9Vk6AQDv0Y/dtKTvW8X5mp+6gXaNrkcrJInMF4Vqu/DOZIWM4Dj6VPVX6oqzZHIJ92q9udJlY3HMqEynFUOrpXqDyaj9utOgov4nsx4/W8ya9Ddiruq+LTgovrW8Q7S0G91/t3LkT30MrVQEqSSmWIzpXpaBLrtIFI7fqDD0i+jjPazEjx/7Pa1rhdj3WchENjm7nFzxj1pNMItp/ODWEOJhzkfQEMl8whV7yDk1pc6BaKi46iZZTMtgUYh7e627+qvMASGfqLmaDKXHdW21JjElZV1BAJlSkHCLk3LJOSg5ULHbz4RZQ2e/QhQo9qGMYzFnQA/jO88O/MR/O6nrMOWF2wD76y9rNqR2sfV1f/RHkUZY57JwcwkBtNNBdl5uBRJBzZLxQkZktDhrItVM8SU3svKwv0xvlX/5VzB1ex0N7AYRCtLEGHkQUHO8K4b+vDSaIkt2/MydSTNypU2kgbVPQ7sLkBqxeUIAJif/KBo9h53PX7KPvL5ObjxwZg3E/XP4cuDX8yWuCFHML9rw/ij1lPMcBnJ95nCEv0C80T9lGCUp/rHoUlZ0zMvkDCe9s
 rxHUDUkB
 Njz1vAlnT337IBdJYGbGNnsMpFDOn7MZDvavfpFkMGaryoR3Vo5OdhOyJ5qgJTYUh/tUbvjccwxdXI385QXWEl+zNriKhwctUBZGkkGYwOaCK02tXRtqouL+H2Xrs7MuUiVhEwRtMw8bdjjuw2P0YGNjyKu6z1R1pAhIpt4K/YgKyWEbIIYSl6+opfF4qUuRdi4c+cH27q6Ktz7NhqAGjJBrj5NXYHYUvjBpB9VQ28DzlWjjhVo2OKLFuzQ2xXTVp1oZ9af6PMFM4KAA6G6Sguh7B64L5rbRggTMQXdpZn5s3v7pMLvn/cBXyylSgoU7XEtCovb0HhRNhZNj/x94UZAnv/aT0PCrC3fB1gAXJAPwzEdNxTa/kAsUNEzow7anR0j1nseNRUXXj799foetue94v27/wh9TvlyHodA5a39a85Y0XBEiMkn/CvLhQeirtQqmOoDNsTl0DHKOZjakxyGtA3s/NkHCpNp0pbVkgzUk02SgBukzI0lrlgx/vRtQuSQU6dgm2ZitFyUCTuWOMCF35kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 09:14, Wei Yang wrote:
> On Wed, May 13, 2026 at 09:03:47AM +1000, Balbir Singh wrote:
>> On 5/13/26 04:55, David Hildenbrand (Arm) wrote:
>>> On 5/12/26 16:35, Wei Yang wrote:
>>>> On Tue, May 12, 2026 at 02:43:54PM +0200, David Hildenbrand (Arm) wrote:
>>>>> On 5/9/26 00:48, Balbir Singh wrote:
>>>>>>
>>>>>> Could you elaborate a more on the improper situation?
>>>>>>
>>>>>>
>>>>>> Do we need to check softleaf_is_device_private() twice, can't we hold the pmd
>>>>>> lock and check once?
>>>>>
>>>>> I think what we try to do here is, is to only grab the lock if we verified that there is something of interest in there.
>>>>>
>>>>> I wonder if we should rewrite that whole thing to just do a pmd_same() check after grabbing the lock.
>>>>>
>>>>> Something a lot cleaner like:
>>>>>
>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>> index a4d52fdb3056..de6a255cc847 100644
>>>>> --- a/mm/page_vma_mapped.c
>>>>> +++ b/mm/page_vma_mapped.c
>>>>> @@ -242,40 +242,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>                 */
>>>>>                pmde = pmdp_get_lockless(pvmw->pmd);
>>>>>
>>>>> -               if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>>>> -                       pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>> -                       pmde = *pvmw->pmd;
>>>>> -                       if (!pmd_present(pmde)) {
>>>>> -                               softleaf_t entry;
>>>>> -
>>>>> -                               if (!thp_migration_supported() ||
>>>>> -                                   !(pvmw->flags & PVMW_MIGRATION))
>>>>> -                                       return not_found(pvmw);
>>>>> -                               entry = softleaf_from_pmd(pmde);
>>>>> -
>>>>> -                               if (!softleaf_is_migration(entry) ||
>>>>> -                                   !check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>> -                                       return not_found(pvmw);
>>>>> -                               return true;
>>>>> -                       }
>>>>> -                       if (likely(pmd_trans_huge(pmde))) {
>>>>> -                               if (pvmw->flags & PVMW_MIGRATION)
>>>>> -                                       return not_found(pvmw);
>>>>> -                               if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>> -                                       return not_found(pvmw);
>>>>> -                               return true;
>>>>> -                       }
>>>>> -                       /* THP pmd was split under us: handle on pte level */
>>>>> -                       spin_unlock(pvmw->ptl);
>>>>> -                       pvmw->ptl = NULL;
>>>>> -               } else if (!pmd_present(pmde)) {
>>>>> -                       const softleaf_t entry = softleaf_from_pmd(pmde);
>>>>> -
>>>>> -                       if (softleaf_is_device_private(entry)) {
>>>>> -                               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>> -                               return true;
>>>>> -                       }
>>>>> +               if (pmd_present(pmde)) {
>>>>> +                       if (!pmd_leaf(pmde))
>>>>> +                               goto pte_table;
>>>>> +                       if (pvmw->flags & PVMW_MIGRATION)
>>>>> +                               return not_found(pvmw);
>>>>> +                       if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>> +                               return not_found(pvmw);
>>>>> +               } else if (pmd_is_migration_entry(pmde)) {
>>>>> +                       softleaf_t entry = softleaf_from_pmd(pmde);
>>>>> +
>>>>> +                       if (!(pvmw->flags & PVMW_MIGRATION))
>>>>> +                               return not_found(pvmw);
>>>>> +                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>> +                               return not_found(pvmw);
>>>>> +               } else if (pmd_is_device_private_entry(pmde)) {
>>>>> +                       softleaf_t entry = softleaf_from_pmd(pmde);
>>>>>
>>>>> +                       if (pvmw->flags & PVMW_MIGRATION)
>>>>> +                               return not_found(pvmw);
>>>>> +                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>> +                               return not_found(pvmw);
>>>>> +               } else {
>>>>>                        if ((pvmw->flags & PVMW_SYNC) &&
>>>>>                            thp_vma_suitable_order(vma, pvmw->address,
>>>>>                                                   PMD_ORDER) &&
>>>>> @@ -285,6 +273,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>                        step_forward(pvmw, PMD_SIZE);
>>>>>                        continue;
>>>>>                }
>>>>> +
>>>>> +               /* Double-check under PTL that the PMD didn't change. */
>>>>> +               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>> +               if (pmd_same(pmde, pmdp_get(pvmw->pmd)))
>>>>> +                       return true;
>>>>> +               spin_unlock(pvmw->ptl);
>>>>> +               pvmw->ptl = NULL;
>>>>> +               goto restart;
>>>>> +pte_table:
>>>>>                if (!map_pte(pvmw, &pmde, &ptl)) {
>>>>>                        if (!pvmw->pte)
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> There is likely room to clean this up / compress it further.
>>>>
>>>> I tried to compress above logic like this, hope it could look cleaner.
>>>>
>>>> 	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
>>>> 		unsigned long pfn;
>>>> 		bool is_migration = pmd_is_migration_entry(pmde);
>>>> 		bool for_migration = !!(pvmw->flags & PVMW_MIGRATION);
>>>>
>>>> 		if (is_migration != for_migration)
>>>> 			return not_found(pvmw);
>>>>
>>
>> I got some time to look at PVMW_MIGRATION, remove_migration_ptes
>> is invoked for device private pages, would we want them to skip
>> device private pmd pages?
>>
> 
> Not get you clearly.
> 
> You mean skip device-private pmd page in remove_migration_ptes()?

I had a look and Alistair pointed out, your proposed changes are correct.


Thanks,
Balbir



