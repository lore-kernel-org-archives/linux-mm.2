Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA53BFEC0F6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 19:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4226B0005; Tue, 24 Mar 2026 15:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AA16B0088; Tue, 24 Mar 2026 15:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A06A6B008A; Tue, 24 Mar 2026 15:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2A56B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:04:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6DFAC13AA64
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:04:04 +0000 (UTC)
X-FDA: 84581881608.05.9A9EC01
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010006.outbound.protection.outlook.com [52.101.56.6])
	by imf30.hostedemail.com (Postfix) with ESMTP id 775768000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:04:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LG4LvzNK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.6 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774379041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTyLOnfrt49L+IA75pE4Bkaeek1sqLVyKWE5utHqxGE=;
	b=ZoRLcmcCSEVvpgFYw0hH1+IWXqopK7FIV41dFvW5PoKxIsHttebVDIcG3H/r2Y13zdSi/e
	3CNwdOXmnbfhbhUY7lgmadVsoIbl2pONN4Xo2PmBj3pSQJjjeOHq0xseiDK3G3+duKNS5w
	p7zun6p6yoOi3aO0B0PNWdagEvrqASA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774379041; a=rsa-sha256;
	cv=pass;
	b=KofD8WDLZFS+hsgGQTtndbjvUq9LCam/uNGzamw0yTUxUZNeDOuwFnF/fhrV9BhNYKvO4z
	Wjie7JjWa9dGll8pEeJH+I3z9YzOKHXk3ULPh/JDDzgUReHG6uJBAA94BIXtbJdF32TtAC
	tgHfR9anzwcQVQEZx8+z5QEsxTTk3vI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LG4LvzNK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.6 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tzbRM4eC0jqDsQP/wQ4NPzCv8IBTbo8e0/zWfmGioRO7XsJvFh22VmTcP9/uFwrMeQ5Qj/Q4pOZlBZVOKLZUkuP+sKbRwfCgSfEDZaQhkZvhzPsFVGNhYDBdc6qE2WucGb9l3/I5KX8dmw/aXrjUkeoebEwg7TdNy6dISqUvN0PupylHtaAUPs6X541L2IOxZB5/gnr9XZKPbL1VN9XPIsBjWYhh8ELWVzuei96GkwB4pfreAw1IWA4wT4F6mjs1sk9XSxudim5l6/hgKiaCPfi1XHPKrXAAKOI9Vyl/5lJezdcxKdT8oY0yC3FSTLpc1PuNHFbHayHkt6Qu9H5suw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTyLOnfrt49L+IA75pE4Bkaeek1sqLVyKWE5utHqxGE=;
 b=me27bM0zY3Ko1ccHX2/ReARGdhOUm5WwBfsiCfTPAauFooYmCuRB3eyj0i+HyMDUSszCxgX4fwTOyBVCYx15VXrvN+EHuWpV5S3M2ETaDZS/IMF7HBtWfU9x/MYAqomR8PBpVeIguW34hHH4m9q8dpnQSDJ798zWhEG21bwyA4BohCX87SKEZbFAB9lfO1cmF20MuJakeUW+b9tVSlT+DR0A80fJwK7KZVttjnVXXaTS1RKdi6jUjn5xlvV8CJNozhKCucXyA9Iw5ExVgT1Rw27au6usu/8pj2lnnfmzKu2giM7vBQ657v8jlkCE+76wg8PtYB4OC+JqGe5uSS1cVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTyLOnfrt49L+IA75pE4Bkaeek1sqLVyKWE5utHqxGE=;
 b=LG4LvzNKVuwXG+f23V6mqZXfiKm+7SpVqNYOVdjlg9VLsiFy/TZC7A1fJa3ZRDfN4mLh1RoX/+Kpv5rNTJXvi1kB82vW7XhECB5eGZgIlykkEi2pz53Cm4zfqjL6oGghal83uYJYUSRoT2PoMv0hb4Woyb0/AlrdyEewG8oxPQU=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SA5PPF5EA4322E1.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8cc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 19:03:52 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 19:03:51 +0000
Message-ID: <c18bb671-ad0d-43d8-91b0-afc246c924a4@amd.com>
Date: Wed, 25 Mar 2026 00:33:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26c::7) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|SA5PPF5EA4322E1:EE_
X-MS-Office365-Filtering-Correlation-Id: 40153953-3b51-4151-485e-08de89d81656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	l2oMlJuegOePAfowQnUW4Z1zINyZq9+Ju+HmgiSiPVUcOiwRJsPCIiw6EBYfdAq5ujJDZHKOMipPfrAXwarJdjW2/PhvHEBfzlp4MKzoWjgplbS9MKnekAfg/zXCL3izye+DBhjdYIhlIFkOjOlCxSaKtlKCrq4yNpHaEHFs6SiUI9Nryd9505MhhoH/KRBMyseha/gAb5O7jEFZHWpd1Vvl51CRSYWZhndw6LrCsQBRCdoFyFiQqVC2fElmb1ZxqfNAOFSWBVmM9S2JSJqXi715yu181ORf7BzrLqWW+46EFlxU7d+XzwqW1nmjLnEvlDzcpLX5KsUfpKZi7oH091SyrLHcmODDaB1+CBWsRJT7yAdSMuNsFG5Zowe0Q/mZqtRBBCXptuEhfCRfn6Cm3aUluj6QXJKHEeSnfgjAA0tsCAL87IXQOrPsnZMaOEjhlGwGQtyDyxp2WRES5xHgRzYXybhUJUJ5NsGy5JZAu6NHk1t5iMUePj3GKhgS3eIXrGJwvjwyLZg6RK/CzOfAcSeNcqmOx0GSscFrou2gtUJbT4SwBQa/r+7Hbl9LmgmMKxfWGNAN7lkUCa+ajGaFK7knQU134BmQyyfQ2GaB+yec81xUPbqMCCZua0JZa6xCw2j2ecMJXSXnGXlJ+SyUnzZk2NQoPlwZ8IYr0SOAMxb1FODjgKFEpnWk/SKoa/ZsDNjo3y9onsCerbKBD4IBFxVdiS0yNYeDeATCc/SWQjX5LCUhxeODUPJ7Ti+YQBQK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUpzOUJSdEtDNm5UaHVnUzJFSHZmSlZTeUl2R3RXTTY5dGxqOTNqZVN4NTRt?=
 =?utf-8?B?dm05K2pYNUQ2T1RmZ2crYTI1SXhPcDZPcTZDWURBdjIxN3N1dzAvV3NXN25B?=
 =?utf-8?B?Y3NvT3VNTHRZNlllc1pYUWVUR3BKWHlHdUFISmZTdFVSdll0RDhYRStIS0tt?=
 =?utf-8?B?elZGbEM3bW5DMWV4VmtKOGVvaVdLWENxZzgzaW81a1ZNSzNZS0JWQVo3c25Q?=
 =?utf-8?B?ck82NllKdlNoWGNJUVBaRGFRYUxJM25LSklhUzBvYUMzbW1CZVNsQURpNHNu?=
 =?utf-8?B?ckxzMjNmZVBWNWpKejNpcERnZUhzWmEyN1BUMjdIZ0QwMUQ0NXIzR3g0U2Qw?=
 =?utf-8?B?U2Nqdm1taFV4NllSSjloWVM5ejM2SkVWd1ZVaW4vNXUrQjZvUjNCQnBpUlBL?=
 =?utf-8?B?Vk5nRVRONjh0RTM1cGp2WWs3c2Q0U0JwTDdTK0IzaXhwVkZNWG5uZ2NKSEdC?=
 =?utf-8?B?UGIyNmluRXN2bGxjeHBGdmZnNXQvemVoM3lpZnMwVXIxWnRydUhGZ3Y2ei9Q?=
 =?utf-8?B?MWVpVUJOTjZrNzdFTDBweWhkdGJZSE5Vc3c1Q2xiOTBnTmQ4Uk91K2pZd1Qv?=
 =?utf-8?B?WkF4Y3h5amJiczRvbzBjemFlNWE4ZUVBNHpnUmdremdJMGR0OFcyY3Z4b0Vq?=
 =?utf-8?B?TThqRjlpTW45UlpYRDA5Si9mYUFCVnFiSzVkZ0QwbnZwdEFIdXM2d0x5RGtn?=
 =?utf-8?B?aFJ5V21UeG1HZHNmTTZybkhESFpicFV4ZGxDbTRSbnAzNTdxaDBsdit5QUJ5?=
 =?utf-8?B?VTRzc2w0WmhGSVVOekpEVDVSa2FSK1dPazB0dFlvMGFzeUFlajFBOVdxRzFV?=
 =?utf-8?B?dVVHeGRTdTNRVHAwbnNsa2tLak1RbU9hSW5OMDRhcEhBd3p6Y1ZKdlFHS0FI?=
 =?utf-8?B?TG44Zy84bFo2UEorNTRjNHl6VW02a240b0Ewd0NNK0ZKMWRsZ3RITHNsZ2c1?=
 =?utf-8?B?VU1hVXZLeW5wRzFVd3dOWWpTOWZmaUhiTDV4aWhoRGVUd3BuaUx3U1k2VEJp?=
 =?utf-8?B?UFZ0SjVBVE5OMjJ2T010YmNyTjVnWEY4MHBTdkp5cnRGLzllQlA2aTNsL2N1?=
 =?utf-8?B?M3NOQld6MEFHcXFpZENlSzh4WlBHYXBUTTdJTk53Ulp3ME5IdDdqaVE0RzJr?=
 =?utf-8?B?TEJMWGJtR25KeEE4bkl0dnZtNXowY284U1dRUnJvL3Y0eU9NT0tnVkZEdWE3?=
 =?utf-8?B?MFNwMml5cmxyZWVKRjNZR2RkRjYxZGVBemF0NFE4RlRubUpOUUdmdVFreUpn?=
 =?utf-8?B?Qnl5bnF0YjhCQUVTdng4SG55NVBxZXpCSE5iSVNQVXMySTd2WUVKYWJtc0M0?=
 =?utf-8?B?UzNvZ2s0NmhVSm9FNTRsUUFJc3NlVmwydnRpU3JQZkpoUFIzcWFDcU1vK2tW?=
 =?utf-8?B?ZDJ5aVdZSzREdngrSEVYSUpYUEJkcktna2Y0QklJMkFNR2VCSXM2bjlDaXZJ?=
 =?utf-8?B?VkZOdUZabjcwSENBVHdWajQraVB2YmYzUEY0N3NtMmVNUGRJUkVKRXRieWZV?=
 =?utf-8?B?NUttN0NFTjVnUWt6bXIrdWJad2szd0xSYXhoRUtWRVNoeVRCV3R2K1FPLzZy?=
 =?utf-8?B?YUZEZ251L2VrVHh3a3FmYmdLWFYyV0pCaHhDcXVTeVF6Qm5KQVdTV3RoMnNu?=
 =?utf-8?B?TWVGTnlWUUJ2cUNVTVVSSFZWS3JVR1lMSkFDUUpWQ0R4TUxvODQ1aGEzYjF3?=
 =?utf-8?B?NE9DNXdwdEN4WEJjNlUxVUI0VnFjZi9LaVJqRVREUlNuRE1uQzRYNnkxcWVk?=
 =?utf-8?B?clFKOENmZWlaVVpFNkFlMVZ3RTBUWUpyR3RDMFVWb3BUa3hIcTFGN3kyNU5M?=
 =?utf-8?B?TUJHMUVwMlh5MzJHWm1VMC9naGM1dXYyRWVsTW5iV004VHMyMHp2UGdrKzFN?=
 =?utf-8?B?QkpqbS9TRjYwU09EaE1vNndyOFdNV2FCYmVHaWZTYnluV085dXYyVnRCbmVS?=
 =?utf-8?B?eU9xMmZCNVgwSXJ0OHhubDhORHhmMkhiSzJhS2g2K09UTGhEYWtyQXVpTjRV?=
 =?utf-8?B?dGgyTDd6d0FuNEZ4eGM2Y21vMzFrTWZnd1N4aTRuQnRTSWVYTFlsUDZQNTM1?=
 =?utf-8?B?djV0V0g2MDZFc2trWC9zNzJmWTdDMlFkdmFUK2RidFh1Wk16S1Vyc2xrUWRW?=
 =?utf-8?B?T3h5YXozQ0NrRTlyWk8vQmJNclMvbkRLc0tFRmtqVjFkdWR2b2d5aTZvdmx3?=
 =?utf-8?B?MUlZSnlqR2pxVDdSdkFaalRZQ1J4RnN6UDlaUUd2L29lTHNYZ2daU0d2ZjJR?=
 =?utf-8?B?Uy94MW9URjRGQVRKNDZnbDZZaHpaV2MwRkRiZ01iajRLa2wrZ1I5bEdOa2tp?=
 =?utf-8?B?S0JEaUo0eFEzcHdJaVlNdVZKcTAwaTRORU16cFZCeVRSdmY1Y200dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40153953-3b51-4151-485e-08de89d81656
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 19:03:51.8164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwOYlHhnGSKaxyw9iMWYxZ6D6m1uUwMVfMLqeAnP2JiUnJRkkcWkHn/DEykRB7NXY2cCHsyA27aWi7qlgTv0rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF5EA4322E1
X-Rspamd-Queue-Id: 775768000E
X-Stat-Signature: kzrqzfyc847psxw6cythquzqn41cqckk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774379041-774100
X-HE-Meta: U2FsdGVkX19RQhA8dKBmAkWbDxTHXQaSuRAcfRqKmTxMayx5aESXH3+10VGEgVuxzbt9vhIs1ifcx3vF9k9IKPMzTqiaFGtDsVw204MjLwHIuziMqpApDx2HMel1WBRINezGAeCBLoJfUY8TkV+cj6DQ+o4rDYTDXzn15umbyEIQxKhYGXFLNrF6ZIdeCGMvpYultc67srI93L5gIkEgiwWu2xFa3xCmm2/LBHEFJyeB4akH+bCUf4h+sqT1yf4EkgXkpvJs1qpQdq3b4ZFOQH4jf7N7pTUcCngtIr0EAyNfUeTzlbye+/4XuRpSRRBuMAvzALts1XXj2CRavUOG7DZjX6MIFKBmB9lpWwYFeUlo8mRNjn6mEwaaj4qf6Q8YsoQYTP/TOMExL1AjLo44DQN3n3B8bPZ+yn+2l/kVJ2Zqz8ZNl6JANZnITUcf1xgB0He18qxyAtLuuE3nmgszRtWp8Hhf2YtP8Pz4IRP/rcn5b6pZQqm6wYgaKqwOVBHWpJFKiJ2smpMnCXvUAPOX2eC5Pxhf9i11t/X8niwdy7yZyZY/uBmnMehek5wWJ/RroeOCWRDX9ALDZYA5ObkzxwymLsGIPVgKwsxnPvjzy2rlv6mLwUmqYEiQQ/USKhqgM/ZJy+J0pgBONheeJsoeqLFjZhxCndOCRJ2JBnx3y7aRMl6i/5azMWe20AYK1PCVPYnEaR8KUW1k8gZq77uhB+o8MNFTrGPWlf7dDHxJri8xoI/mQJsA2RxwRJ1mrBmcwMFZlzpCoRhWb3bP3wh1LeoJEcFkMHI3F76qHdKKTlK5rRimEmNlC/u38ntGp7JgEjzzyyWmjwFn/EvoCbDUYIrPl/cXUW3ptpfpBD+mSLW7w+N+Qg0Ivjd9ajpycIulO/F2qg5zLiY9oYAYtvHxcJsRHJdfEMG50VgarbWzRp6VYLHcMj0cuAhburC/lqm2AS9BskCR6ZVRXzXeGvc
 J0X5QRmq
 vjdPgNwdtx01DmwMOyzmLtG6KhxqmNMx9KqiaSq68EPz16QKTxfZeCwG7zNN2pealRpYg1WSND/b5PlfzOTblegGzvSaG7b8cu98FQpPY5YT7p7CTQ04e4fIV814GkYO5fq7q75WT23Xtx/QptAsnVBfRe9gHTt7OwNPV+C8Z42rAq72irZSHQaVUMZ3FMklAxJro98V5J543HTbzjv/O7bzh/qHT3+hEgtpzRO3vWpQXQdG+TMSwnQvKpF7n7zS8UmD2bQejdr3VnHZLAzJZmCJYRR0dnHTaRXOUr29OJ2UhpE6NGwjRcVO8z7nPbX4X58LHI/UEU/RurvZWelzHSgpp/YvGSs6nx2CANsWWX820OjJpnVj44b8nRlXyMkf9Fm+tvhDKX/4IChl3BR0d0T0V2rOtM8d+TfUfTKrX8MpM1I9CtthsZzFreDnSSgH9vpJcBasX7ifiIpzB8c9oX8m8XMVUp6lOh9pS4rCR1//ln/2HLXIE+dMGOsi/ELimTOJ/knXYdk/jL7b4/ixCAa5C3w4R+D59V0WnR91mc686JvcYcfd/yho70upbjqNChk04Mc3/eE//qn4F/STJKKIVpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 7:08 PM, Zi Yan wrote:
> On 24 Mar 2026, at 7:47, Shivank Garg wrote:
> 
>> These flags only track folio-specific state during migration and are
>> not used for movable_ops pages. Rename the enum values and the
>> old_page_state variable to match.
>>
>> No functional change.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>
>> Applies cleanly on mm-new (02b045682c74).
>>
>> v1: https://lore.kernel.org/all/20260323141935.389232-3-shivankg@amd.com
>>
>> v2:
>> - Rename FOLIO_MF_* to FOLIO_*, per feedback from Willy.
>>
>>  mm/migrate.c | 46 +++++++++++++++++++++++-----------------------
>>  1 file changed, 23 insertions(+), 23 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 05cb408846f2..7dd6c2f2e1ef 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1135,26 +1135,26 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>   * This is safe because nobody is using it except us.
>>   */
>>  enum {
>> -	PAGE_WAS_MAPPED = BIT(0),
>> -	PAGE_WAS_MLOCKED = BIT(1),
>> -	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
>> +	FOLIO_WAS_MAPPED = BIT(0),
>> +	FOLIO_WAS_MLOCKED = BIT(1),
>> +	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
>>  };
>>
>>  static void __migrate_folio_record(struct folio *dst,
>> -				   int old_page_state,
>> +				   int old_folio_state,
>>  				   struct anon_vma *anon_vma)
>>  {
>> -	dst->private = (void *)anon_vma + old_page_state;
>> +	dst->private = (void *)anon_vma + old_folio_state;
>>  }
>>
>>  static void __migrate_folio_extract(struct folio *dst,
>> -				   int *old_page_state,
>> +				   int *old_folio_state,
>>  				   struct anon_vma **anon_vmap)
>>  {
>>  	unsigned long private = (unsigned long)dst->private;
>>
>> -	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
>> -	*old_page_state = private & PAGE_OLD_STATES;
>> +	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
>> +	*old_folio_state = private & FOLIO_OLD_STATES;
>>  	dst->private = NULL;
>>  }
> 
> Just an observation on folio->private, it is void*, but page->private
> is unsigned long. It confused me a bit. There are folio_get_private()
> and folio_change_private(), I wonder if we want to use them here
> instead of direct ->private accesses. Feel free to ignore this,
> since it is irrelevant to this patch.
> 

Yeah, using folio_get_private() and folio_change_private() would be cleaner.
I'll keep it in mind as a follow-up cleanup but leaving this patch as a pure rename for now.

Thanks for suggestion.

> LGTM.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thank you :)

Best regards,
Shivank

