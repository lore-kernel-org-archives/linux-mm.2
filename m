Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9A6D2F352
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF6D6B0005; Tue, 13 Jan 2026 13:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A828F6B0089; Tue, 13 Jan 2026 13:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A036B008A; Tue, 13 Jan 2026 13:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAD96B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:22:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13C568A979
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:22:48 +0000 (UTC)
X-FDA: 84327761616.11.31C3B10
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0DA3DC000F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:22:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=q7KVqwZl;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.48.47 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768328565; a=rsa-sha256;
	cv=pass;
	b=hZkyjforAx8tbSjOkfCfbVI4qQ5+2Y4p20O/KOvwYb79Q3twSegg5C+pIntZqWqVCQl6Po
	8/bRS4fElRk+mxuvdxCcJlJy3pTf2lxLjKDEp2llYRPWdw5O3jXB7Ikhoq3j7eTS0dTOJF
	qZjOoY4tC0z9T9U83B/OfU3Bx/h6SXA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=q7KVqwZl;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.48.47 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768328565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FtwpmRnfD/QZNyOYtAUhqAbfscFnGgdrHEJNqkAeW0A=;
	b=Z+VD/LZIEwAAwZLc669RDkybk1bqH5XVkrjo8JZXA0MWDxCrnXoSR+oObZkiQQwTumR6l6
	2a7O6YnTfuFRnMvSK7diy/hmJ2w3i8HATqpPmOiagi3ZZw+ws/J/lEPGx90V6tnz1M3UOD
	JpXFkuMt0qKiw/6ocPII2nSJoAk4ZXE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UhDnJMMSyHLwHDOCE9haeG10Ud2kuf9b63+Ax19DYYuZF0Exs6B7xeO9WjFoBn1oiA5NmwXAdzMcgt2yG2LsIA2YC8jim0V/IjArgwH7woOnhQXveUpSn5LVNUffbRL9lDXjVYcAo5epPF0qExa7ND6VFwosCE9IIPrS2yL8ERWky+a3OieTCzT4GGhsZPMhnElpg1mIr9IiGC26FobW+KXs8adw3mrywuCmpHPqVGqfvsxt+KGkWb3faNgZCl06ft4vcxVdpYkbXwAZKkKmxOjEsAUcRlpNsiF9ZEm8yQVQCsQ/BaftmurSxDUKd5NPDs/5LpJJfy9FdZGTN4pzlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FtwpmRnfD/QZNyOYtAUhqAbfscFnGgdrHEJNqkAeW0A=;
 b=vmdj7xaKyyU+DoeX16eIXYG6Zs4cocg9iEsVr4KcQ84btwE3F/pQGdV6cs8FUQF+VD01/6tVZp4UF8TgXjAT1iZEtQyaoIn60kHNJIObgOZreBzcr8ZYGqo/q2BzlMuWobyZ8ROYpVh/wwdPN2rRqZHRgT6b7ISmG7Vjr5WbV99YP9/xZZVtKS5Usin3kcxveSG/FzXfKvj8mrDYYfHEkWHutTG85+8GlWep/ZFfveQQbn7r5nmBFdCNoVuAmCMQDq50pO46rPe43Q+/9Ek+DieDd89yNqZkc/HN6576V3uhcH44EuukCtF/D2uKQRZq4b6eWBO/I4jxMjUzSj9OZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FtwpmRnfD/QZNyOYtAUhqAbfscFnGgdrHEJNqkAeW0A=;
 b=q7KVqwZlxis5XPQTkQWkBI4OmdEBvwbgnQToqh30sKb7RUhlf6d9n7/W3kuGyFlOwm06PblY+h02AwTPNmBd0Yf2JhgyDiHmUfl88Kbq7JYKgxy3G7oYQUGeC5KLe5yqyYd6XEERFh8yVV9Sk6wk4hnjXPJtrfhVe/5hLhwAExU=
Received: from SA1PR12MB8643.namprd12.prod.outlook.com (2603:10b6:806:387::7)
 by MW4PR12MB5604.namprd12.prod.outlook.com (2603:10b6:303:18d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 18:22:41 +0000
Received: from SA1PR12MB8643.namprd12.prod.outlook.com
 ([fe80::f168:a4d1:aef0:3ed6]) by SA1PR12MB8643.namprd12.prod.outlook.com
 ([fe80::f168:a4d1:aef0:3ed6%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 18:22:41 +0000
Message-ID: <7283516a-ee5b-4226-ba32-1d9325eb6748@amd.com>
Date: Tue, 13 Jan 2026 12:22:33 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: Add support to unaccept memory
 after hot-remove
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de,
 thomas.lendacky@amd.com, michael.roth@amd.com
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-3-prsampat@amd.com> <aWYctexPTf-w7QT8@thinkstation>
 <af3bf2ef-0231-4e75-9a80-c2bd3a7e1bf1@amd.com>
 <aWaGBandNCLT93Tm@thinkstation>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <aWaGBandNCLT93Tm@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:806:f2::31) To SA1PR12MB8643.namprd12.prod.outlook.com
 (2603:10b6:806:387::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8643:EE_|MW4PR12MB5604:EE_
X-MS-Office365-Filtering-Correlation-Id: 2695de5a-7897-443a-f8d1-08de52d0bcf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TkhtaSthL3RSSkZxWHdNQTQzN2xqdHl4NHFiOW9RVU9SdEFKMzVjRDl6Qjdz?=
 =?utf-8?B?NjMxMXBLNWZOTk9oSzllSlJXNlMzcEhIZ1A4Y1MzKzFaVVlKRnNpSStDbWJU?=
 =?utf-8?B?eG9uVXc4VTd4L0EzSVV5UHhGUm1nR05qN0ZRNmxkaGJRS1h1ZHN4eFdMRlVw?=
 =?utf-8?B?azBuY084TDUyd3drZStuc1lzUk81VjJpWTY4TlVIdWswL1ZYSm1uVkpyZkwr?=
 =?utf-8?B?RUM4dXpySElhRW5QM0ljWndpcHVkNVcrSmlZVENleFdnLzlaK3dheGFhMmgw?=
 =?utf-8?B?UU1VS0ZsOHVNbFV0WHJCUmVxanA2RDkxcCt6RjcxMEljNFZKaUN6NGZrclNt?=
 =?utf-8?B?VG5IdUZYM2lqVWR1MnJSZGZjcjYvbFBKMk5YdHBkK2JBbVZRQXNGMXJqeVQ1?=
 =?utf-8?B?OHNYRy9VRWZqbmJ4Qi9MeUdSdjl4U05LY25zd25UeDlqZHZnclUyd3kreE1z?=
 =?utf-8?B?YTNoVmJVdldMRk5CRHFpK29tYTlpRHYzc2FubUNlV05XMlB0UEd4WE55cFNX?=
 =?utf-8?B?dG42aTdyV3V2cUxvTXJSUGZlQjFiMnR1a0xjUU0zNUd6MUtPOEVyMC9Gblc5?=
 =?utf-8?B?MVBEMUhEb1hvaE1PTFdMczFySjZpaFZYTllWRWV0UURnSTlzK0hmTEpwNmtr?=
 =?utf-8?B?WUt5SWhYV1NPK0Fka2VqaWtBZC9sVFo1R2x6b01VS0xVSWkxQ002WVZtSzJx?=
 =?utf-8?B?OU9mY1F5a0Zva004MFhWd01tV2ZYckVCYTgyWVpPU0pJRENyTFVwemFkdi8y?=
 =?utf-8?B?NDdwUmlYR1FrdVhudW4xVjJ2Mkw4RS9INTJ2cm1QREhlcVU2TnM5TkhGZFdn?=
 =?utf-8?B?U0FYMmxleWlMcEg2ZGtGQmgyNDdXVlF5NFlzeUwrL21EOExHWDJoSG85NmtD?=
 =?utf-8?B?Q1F3VUJ4allJMG5JTVdEbk1qRVlmaFN4QVovejBTVzQ1d1c5Y2RUQStuM1FN?=
 =?utf-8?B?ZHBaM2MxN3E3Q0RoY2pzT1I1aUhtWDQ4RW9ua1AzdExLRVE2WktVNFBsYWxr?=
 =?utf-8?B?blVuT0JzZkx0eWFtK0RuZlkrY2xLMklmZXdzbGQ3cHNkZWNYVXI5WUkvNGRr?=
 =?utf-8?B?MzhWYjhEV2habWwxNnVEZTdwSkJtWVhWbEdjbVVIdElRUlV0NFV0T1F0Rncr?=
 =?utf-8?B?NjJpa2I5dFBMREFNcmhyeHhHWlRreFBhbVIrTmRSZmRVZ0dXTlFtRmViSCtC?=
 =?utf-8?B?MTJwRDBoRnRMRXFsNmVrRDIxSFA3NXlNaE1BMkxqOTBrY05TS2RPNWZiWWdi?=
 =?utf-8?B?aTd4MC8rYmE3OXEyeUhUQkVMVzAxYWJ6cjFwZFpqbWk5VWlodEJTS1lLSXZZ?=
 =?utf-8?B?VTdNSGp1WU92NnZIWVovODJyOWsrdmNWQ0VVeEVXUnZLNnRZYXRpZWJyTy9U?=
 =?utf-8?B?RmJkejhlQ3FRaE90L3FxZllySGNWaHZtUyt3a2pmcEV6WDlTTXpyTFhLZHA1?=
 =?utf-8?B?NElXNXRUTDNZZXBYTHIyeUd1NlJqL20rWkVkUmloYkFORjZWNEppMDkvQkRS?=
 =?utf-8?B?d2lxZXQyV3lSSk1IdnFOUTlMajl4NEZuMUxDWXYxWWgydnl1QkpkS1ZFZlUy?=
 =?utf-8?B?Sk9tdTM2TThWcU1PV2dZN0E4RXd6U0JRMlhsWkRNY3VCMDVpL0ZmNjNsSWhN?=
 =?utf-8?B?VGsxNTNuZmUyeExOM1FCb0tYejdqZXlmUER5ZSt0ZnZzZWVWd2h5amJQWHht?=
 =?utf-8?B?VmxMeko0YkZuYTZHVjVXckN3QnFlM0huUnRPSG5ONHhwK0dNY1NWZXlhYUZS?=
 =?utf-8?B?MFBhbktOTFZBU2hrOFNaejNSdFB2QlBodTR4aXIvOVc3ai9LYXFLYU9jb3lu?=
 =?utf-8?B?dFJLd2lteVMyV0pWbFZoQWdXRnUxUTk4L3RWZWxaM1F0OXVvaUVCOUdMdnVa?=
 =?utf-8?B?bmU1SXpUbm9sU0NCN2JENVRhNW85TFVIdG5mUzdpbmNoeXBId3d1ZmVNTElD?=
 =?utf-8?Q?Q/fOM0Dssjg3ogsPRJUrSrHMsLRVgYkI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8643.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVNjVnZPZENmRVY4ZWZPL3FWdkF1dk9jemM3OVVkWXpUWnB3c1NpRFhzczQ1?=
 =?utf-8?B?UDE5OXlmVVNnUzFsT0N0bjVjVVpCWDM3blMyekpBdlZ1eTd5RlhBeUJPR2lT?=
 =?utf-8?B?VkpGQlJjdWYxdE9wWC9XM2tzVG0vZlJJNlRNL2s0KzUyakRMdExIeFlUY0Yw?=
 =?utf-8?B?Sk9zbUlEVTN5dTdGWVdVTURjejVyT2tuRG93UVpqM2lVNzlremV1WHpDN1FI?=
 =?utf-8?B?L1hERmE3bm9BeXBQd2tDTVYzejRad1cvTm9qVGVGeXZZYmVLK1NTYjVkVm9L?=
 =?utf-8?B?MVZDSUlPZy94QlZxRG9odVlWVCtRV0tzTFo4dEJKMHB6VG5zWkd3RkFWUDUw?=
 =?utf-8?B?K0gzMHpOYk1lZVF1SnNoTkwzNUYwbWV0SUpSa01vWGdaOVNKTHlBdEJBTG9s?=
 =?utf-8?B?cy9RZldLL2JzVGtWVzlSbk1wWVhkMnBOS2swMDdoMnNsVk1MOGxxWHNZN3pC?=
 =?utf-8?B?S0pOaE5PWHZwUVpHNFRQS1I3N2FONjZyRThvb3grN1U4TThTTU10ZWw2UWF0?=
 =?utf-8?B?dHZsOUxhNlRGQS9IWEZ3bUxBZlcvR1M5MXVzSlY2Q2hjT2FnNDAxOGl0R0NN?=
 =?utf-8?B?eWZ3MXQyYTZpSE5saDRmV1FtbVE0ejlkdlpBVFQ3SEhSRHJEMGx1MjE5bzZW?=
 =?utf-8?B?V3JLMi85VXRpYnE1VDJkcGQ5bHhES284R0kza2tJL0UyQ3VST1VDVHJMMFZB?=
 =?utf-8?B?b2hZSE9yUFVVaVI3RVdCbVJCZkMrME9VRTJ1QWUxRkRSZ2lNbUtpMnJkVzNE?=
 =?utf-8?B?WDQ3dVhHUzYwM3lhWk41N24xbDUzVDR5RjNZUWFuNWVPTm8zbjcwQnd0azFn?=
 =?utf-8?B?VzZCcFZZMURyaCswL09ITWVvUUdHbHRNNEgzcG10YUp2SEdlN1E3YkxtbFhh?=
 =?utf-8?B?YWpKL0tndXJ2RTJJRW92YlpYQTR3dVlwM0JEWEJMK1RwVDJBTjR3Z1VCbDhC?=
 =?utf-8?B?TjZlSFU2dnNrditMbnpsNTFIWVk2a2U1R0g0KzQ2SDJ6Tkpid1hQZ0YrR09F?=
 =?utf-8?B?bnRKWEtUWFNLcVdvQjExOXVLQzIxYk50azBtZDhheTBWM0tDMnJjWjFzb0Jq?=
 =?utf-8?B?YVZibHI4V3VORU5rTHFsQkxSQkN1KzR1Uy9XQTgzOWdZVzY4Szg5Q3NCY2RP?=
 =?utf-8?B?azZ6WGp4dFJ2dmpXSHR1SDlBRnlSb3pCMUUxcWY3NU1GYTd0blhiU21QVmlS?=
 =?utf-8?B?RTNNYXY1M3BwcWsxbFlvbTJpbnE2OFNicHZBVU5IQjVia1B1MDhXNm5DVlNy?=
 =?utf-8?B?UFNaOTg3dlpTMWliYTBIMDJ2NGRkWFBrRzVrOHZVOEExU1ZwR1Z6MmZYdlJT?=
 =?utf-8?B?ck9maTIvdi9NdWtVR2Y2OVFoeEtTd1lRRkZFdGVNSkN5b3NLYW5IZXNlUjZC?=
 =?utf-8?B?NjlBZkNKOXh5L3hEZGo3OVRiN3dzRmZ1RVBPTFVET3g0YlEvamdsZGtXNHFr?=
 =?utf-8?B?U0t4Zjd6ZGU5UzFEQTVNTTkrYXB4aGN5RTRnczZQTUxNbFV4VE1RMTBmQ2I5?=
 =?utf-8?B?TERnQXJYbDVIRzV0OGhHYTJDMHNNWFdQU0RpNnM5bTd6SmhRc0tNNEFLU0ps?=
 =?utf-8?B?Z1VuUk9pSTg1UmNFUUhIUXZ2aStCMUtKOStrd2pFM0tKQjd3L0V5RkxWUHA4?=
 =?utf-8?B?VncvazFneWZFY1N5bW44eG1pcnNrZHZmQUc2YUcvbG1zUDdvOWxiWjlIM0Jk?=
 =?utf-8?B?Qmd5YWY4M0lzakc4OXVhT0NyektjemJab1ZLYWRVakZyc0Z5bnJBT0NuWWRX?=
 =?utf-8?B?Yys4YmJrMmtnQnRpYWZsQ1RjTUlsTlEwQ0Q4OHdWZThRYzlWckJxSTN6Zk1s?=
 =?utf-8?B?bDAweUg2bmNUb3ZlbmFxMTI5SU04UTJIT1dadk55SW9penV1YUxTNmhENGls?=
 =?utf-8?B?ODNlU2hYcndScE0zNVJXRzIyODhpdHdsNDdtU3ZXZHo2QkZLeFFYRmw3UHAx?=
 =?utf-8?B?OWdnKzdyT3FHeVVPVk5LWlRTWGR2cjVsNVh2bXJLVVdwY0EreHhaa3R3a0U0?=
 =?utf-8?B?cUJ3V2NJZ0JvdmNHQzBLWkZ4RndOQ3EyRVcwRFdINjJhdjNSTVhrWjNLby9J?=
 =?utf-8?B?V295VXF1aGpMQzR3UjB2RjJWT1ArMmd2WUw1K1praDJLRWl5dC93THlNL0Z2?=
 =?utf-8?B?a3RFRXdqNFVzQ1l5OHFBVkU4bnBydnZucDRERXh1cmpqYmNaV2oxYUM5Wkkw?=
 =?utf-8?B?b1FmdDZFeDJjUmZpSVQzYXg1UytQdGRVWTY1ekRrS29vRnVZVHhNYXdkVTJ6?=
 =?utf-8?B?c3VaYXMvN3NFRDQ2LzhGRm1uL3EwdElodkRzbDVwejJtMVErT3J5N0xreVly?=
 =?utf-8?Q?w6nDHrgefgf+R+UwyE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2695de5a-7897-443a-f8d1-08de52d0bcf2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8643.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 18:22:41.1719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQmFR9Hf51cPLGtEAznuRX6n2GMgeUToMMZFNTZ4v68eM4AR+lS9Xmu1OOQeK8lnORtEMD1UZdP9H6W4HXFITA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5604
X-Rspam-User: 
X-Stat-Signature: a1et5hxk3st85h8eur13x7e8idirb9pw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DA3DC000F
X-HE-Tag: 1768328564-27904
X-HE-Meta: U2FsdGVkX19iFt4WsULEEO6eQxAMaWPnE0vOc6MkWnqQ9sA2HVk723nGpW4I5Lu0huMByxPLHj5TmV9WgDC3FQwSpfMB6MSxdQDkzbVnrSrymCjZ+qbM6164a6xSv/Wn/hvRiztRsf1m2mEaixo0gnK5G8sjOHXdb4L0KNltFb1+9dep2b98edSfeVofCaIqXyU0Bts060M36UB0F5CwdQCthiKU1rjZjcrs2CNYAurch1R2empUuzTyCIbyLsji6SFfOfK7aDb2RefsQeYAa5AYKMr/eSDgiy8O37wx3lFJ+cz3aO6gLPktE0tR1X/V4QfRdVwOe0CrLbxBhRxJWzfl1gPIiON/fWZv4LNWCBLGkQI5yAdzDnrZeVb6i01AUjXOt0NF7lxlVTlHxNQMXYQzrDUNT5RXNzCmgy0EEXHFaYdBx26YOk/xEFiEHHq6cQnNoxpkWqfYUlfSdX5e2YSnE+hx8pHZlN/Ia58q/VStzqI85wxyJomplAUVebrGAQx0AEu3t9VARAaJIsZ6x+Nt8kdCo+s0ZlWYxjyL1Y2eqZX35oUZjWp0YSBrw/ioB8KA7itGhFcju+6r3KTFlIBQZP/yHd20/9482+AW85XnElaeP81knYB2oN6Spv5wMjd52dmQ8lCnpNvOixW+jmLAFDUKwtXbp/aI4lc+M9uUIGTJu0Xw2AFFEY4y8P8ipQ3o2UEiBT3hwaNiZ3NqNHvUuFT+HiBNJBzXA1DyVlQ0ZcxB8aAi6dAoUpqd1A+oEYrWiJJTdyIKS7Y9nFFszpyvCp2DjXvZUx2pCGoJ76TyqJw5kM01/vfnOGpnr+W+9zlGasg1obaHF0awwE+ulm6plAL8JspSPYqvWLl6YWmHEvlUknHw7yONWWfxoYrRg/MBvsrAb7fOJ+Xj4UorL8wGbzOwZTLVvBOhar7FWkw+SlLYryaMZoeW2Ap6MYRGcjVcToHOZEVtFb3s+Iv
 CUmtFlvY
 bIMffesjmGrbwAEj8ANHYDlhgrmfpyBJpxLKmiw5hyMMeFxUiSMfvF8L/KNfF2CplBIjXC5iFtoT4ANrurZ56Xb88jLYxIJuyQo20tMLrrmXnv5wZMSffXWmqXe9t5Ihgs2gNo9/4173JDe18bwgrzpp1xwmOJaZOCLOamhLCBnGTwqm2ScKpPRZYWU3JGDLKTBiX5EZ1F5w13HF8WLH6bNips9yz+BZ1XWmwG1TVBomaA/9dgRb2AQEDDQhk8uums+Qqq0VB4FV1uaAEkWqvTfPJ4+/TvGTEqEO2t2gVJb73qADxR8rbYGU3UmULl6HlcX3tQsWr8KytOGqW4XhUxIHydPkanwmG4XXuH89oeKgq9K8GHZC8oLZr+3t9oynThjpzCGTIPbs3hadTU6J6jSleZoYCh4NWnHwEOs3UO6cWnyIcVnWPI6DXu4gH6CEtrWrkt9Q18oHBg5RV50zL/CLP1F4qda2ZwOOka5JJSNC5W2FVINmJUTQ2FjDQCiwcQY2TiJRrwKhYYIw6NyJy2MxBAWw4/5+XrNYeytst9Jeokf+psGfiqAEHL62N/Ox1pRXGfiMi63NffjLLBQwWxCPaQq0A0ZTwTEF6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/13/26 11:53 AM, Kiryl Shutsemau wrote:
> On Tue, Jan 13, 2026 at 11:10:21AM -0600, Pratik R. Sampat wrote:
>>
>>
>> On 1/13/2026 4:28 AM, Kiryl Shutsemau wrote:
>>> On Mon, Jan 12, 2026 at 02:23:00PM -0600, Pratik R. Sampat wrote:
>>>> Transition memory to the shared state during a hot-remove operation so
>>>> that it can be re-used by the hypervisor. This also applies when memory
>>>> is intended to be hotplugged back in later, as those pages will need to
>>>> be re-accepted after crossing the trust boundary.
>>>
>>> Hm. What happens when we hot-remove memory that was there at the boot
>>> and there's bitmap space for it?
>>>
>>
>> While hotplug ranges gotten from SRAT don't seem to overlap with the
>> conventional ranges in the unaccepted table, EFI_MEMORY_HOT_PLUGGABLE
>> attribute could indicate boot time memory that could be hot-removed. I
>> could potentially unset the bitmap first, if the bit exists and then
>> unaccept.
>>
>> Similarly, I could also check if the bitmap is large enough to set the
>> bit before I call arch_accept_memory() (This may not really be needed
>> though).
>>
>>> Also, I'm not sure why it is needed. At least in TDX case, VMM can pull
>>> the memory from under guest at any time without a warning. Coverting
>>> memory to shared shouldn't make a difference as along as re-adding the
>>> same GPA range triggers accept.
>>>
>>
>> That makes sense. The only scenario where we could run into trouble on
>> SNP platforms is when we redo a qemu device_add after a device_del
>> without first removing the memory object entirely since same-state
>> transitions result in guest termination.
>>
>> This means we must always follow a device_del with an object_del on
>> removal. Otherwise, the onus would then be on the VMM to transition
>> the memory back to shared before re-adding it to the guest.
> 
> This seems to be one-of-many possible ways of VMM to get guest terminated.
> DoS is not in something confidential computing aims to prevent.
> 
>> However, if this flow is not a concern to begin with then I could
>> probably just drop this patch?
> 
> Yes, please.

Putting more thought into it, memory unacceptance on remove may be required
after all at least for SNP platforms.

Consider a scenario:
* Guest accepts a GPA say G1, mapped to a host physical address H1.
* We attempt to hot-remove the memory. If the guest does not unaccept the memory
  now then G1 to H1 mapping within the RMP will still exist.
* Then if the hypervisor later hot-adds the memory to G1, it will be now mapped
  to H3 and this new mapping will be accepted.

This will essentially mean that we have 2 RMP entries: One for H1 and another
for H3 mapped for G1 which are both validated / accepted which can then be
swapped at will and compromise integrity.

--Pratik
> 


