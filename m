Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391E1606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=cvbCY3wk
Received: by kanga.kvack.org (Postfix)
	id 8084D6B07FB; Tue, 24 Nov 2026 12:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790B36B07FD; Tue, 24 Nov 2026 12:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6585A6B07FE; Tue, 24 Nov 2026 12:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34CBC6B07FB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:28:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95EC6160566
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:28:16 +0000 (UTC)
X-FDA: 85470696192.11.8071774
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6BA58160005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:28:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=cvbCY3wk;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf08.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.195.46 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795541293;
	b=RwUk1XE76trUb96tOKaMp70LM+sf6hnC0GtXm96LUhsgxWwKIKpFrGrd2YYsaSmPe/Hvdp
	62Sw+4g0UnL9uFiHH+nWqWtRVRa7uqzj9e5HYVzYRWxPZoZ462cn504NJ4AUAxJxVbqm7Y
	ftQ16NBDWkKqtg94xpSUOHr1kkrVaKs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCwp05IcpcNS3RLWAuz6/8Sd0BXA3jsJ8MNUidlQd8g=;
	b=bH7q195LZVpzgvtwBrM6RMLFR8u88m0/bGEYGZT8piAKLSumefchdD1pIfWb5VWZZB08fs
	wwgy5TEdgt8sNVgRTevdKoGAbfNR/APy0jG/aKDChsEKQYEdSGBnfmsl0RRs3y8So4f41Y
	+kvuSBpy5eE98iSqvuakfnA5s79SLv0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=cvbCY3wk;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf08.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.195.46 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQBqZWuegtoEJQQ/nzfe7AHYhviQVncqUhnyncdEv9nZncNNnwHv8Ud4/h8xWdUZ/0l0sOJotjSESL701CSmmczS9nmLzNkYjTupE/Lhy2kdDAqzIr7msNvjzJJLt1RMog4XJgwjIufX8wnzgVW8I/ROVnM4VG2kKVfL/aJzjLobqq3hf5MlkMLIvt8QasQKVsIpLvN33VVEzH+WJ+acYxOfsCZ1wnNQ2X7EIAq9CbJ+1q89MQB4wT369XmY6+fhF8zzj4aX4YDHsJa0+TQS32ycuVwfM/CPzump6H8D0C9FpULEpYgcOisXghHc1qidQK7FznPnJHLjyjwv1He5iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCwp05IcpcNS3RLWAuz6/8Sd0BXA3jsJ8MNUidlQd8g=;
 b=pXdykWLFfte7EkgpEDQee2sJBUk1psB0UX7tGRHhpFX9HiDeaNWx4ZQfpqSlesaXZlGzakxt9lfx98//EaSzn0x0ZLx5Ycvb/5ePmSIJojyLSVf9yO0QZHAe/rx1kMZNnLpDizCJhMWHJze1PTYQ/N/u4SvA1vKe5K6ULqSEzJ7cT3CykT38uDnQeaseZsUj2WWjKXrjx0hW4Ngc6H0hnB+oXpNFqAacHe+tRTyIBdbR4/xqp7MH9vYYnmiFk0m5Y4XxDS5eVMhg0K6R9lk0oAp87/JAhVhkBL2Nfq/Kl+5zsZrJBuyiJ4GLzB8uyuWo9QSBs9pZpasZj+Q/6kLMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCwp05IcpcNS3RLWAuz6/8Sd0BXA3jsJ8MNUidlQd8g=;
 b=cvbCY3wkLE3hai4NK5Oir+8evhdhh3ekVxtQo2BuPXSKBEdAynkwPsw4J7zYNETeykZwCyuLWW4FBibd1CV4CONM/Q/GQJT4emYiX3g3s8C6e28bvE4VlWZb/X+3WGOCjxd06DXogGynHok85snWbcQ62to4hIvNhZUXXsZ6BBo=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 PH0PR12MB8823.namprd12.prod.outlook.com (2603:10b6:510:28e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 17:28:02 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0639.011; Tue, 24 Nov 2026
 17:28:01 +0000
Message-ID: <f059498b-1e65-48cb-bc40-62323e161a14@amd.com>
Date: Tue, 24 Nov 2026 18:27:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential
 guests
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org,
 Pankaj.gupta.linux@gmail.com
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
 <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
 <awW31hUpXuujSAXA@kernel.org>
 <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0223.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::6) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|PH0PR12MB8823:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d74bef-9f31-47d3-f930-08df4a504a44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|5023799004|10067099003|261026140227099003|4143699003|11063799006|56012099006|261026121527099003|261021121427099003|261102123227099003|261022075727099003|261022105027099003|261028144727099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	14pARPdHgRclmWCsXClL9wdGqB8IrYD4nZi/+DLf2X847fpR54jia0BU0pt5IB6TOOJRE1PwG9GfO2hiIYP9cSXw6jg7vPfnA1ttbfY0OmfrrQxc0Fq4lmQJgKzVcSg8IP0+b91d2SG1InQh+vZ6ObD3nGitUAV3UxttKAhNBm3y5DDw3LKU0qtR6xamWZ7Eo2gYWfBPLSlc6BWC9doQMd68etNEv0QFA7OcD/SLn9rpv77GnC9skZC25lhxYtRB7Zoyb6uVgySiY8Jz4jeIscQYeL0Ahb/bmozWMw2e46vneplw0u83DmFxdmx6rK62IgKUzezH24cVPXyRDC9aP0V9Cd4iecrbPy15E/ccUTpxa4217StbUBtyWlmWeidPncIbxxWuVgo4Vw4/JJXhcEZqqMPLbTC6gV79oQCyPSb81oZ/k6VsBpiifzAqbZIEIxKZvWs9NbAxk7xjXci/4t0FkNxrfoxPgs/dNrAmOf/y0rNEn8mU9QsO2yqsrXVVgXP8tQ2WeIXPYYg1XaqS7BrX8YAOyqUfMwNJs0s4DpGmST/PJEr5eshaYhAi0IVwhGUesAM1hhNKTQNrTJimea/lv0A0dJyZdStjZ/3/UsqrdTP8zTDSuOHEII/gs0pp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(5023799004)(10067099003)(261026140227099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261102123227099003)(261022075727099003)(261022105027099003)(261028144727099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3FiU1NvZTd5S0M0MEtneTVrOWl3bW1VMlVGblI5Ylo0NWtQUE90UkoxVnY1?=
 =?utf-8?B?a0hKelowTVlmeVYvc3pqN3lzZWdTN3UxMnE1VkR3Y1lFN1o0TTZyT2FmcTJB?=
 =?utf-8?B?alhHaDFIRzFzV2VBcGdnc3BHcTJTK3RwNHBnMGNtTjYyQk10MjhGMzJ0WEFB?=
 =?utf-8?B?YXU3MXl3cTlMM1hKc0g4NDNJTUlzNWw2ZDJTQU1hTFY2RUdqejNrcWxkTUJK?=
 =?utf-8?B?MVRTL3hQQm9ickgxZ205TWVOUzU5ZXBWdXA4V1UyR1RBd1FHS2RkMnRTQjM1?=
 =?utf-8?B?aFRnZndyWWgzSkdVVmRHZGJ2Zjd4WTEvenlDTnNOSllVVzM5bTRsNUhaeDFv?=
 =?utf-8?B?dGx5SS93T3A3Rk1Mcmh2a2c1V3NINWNtdjNkSUVsaHJRQlNYM3NzSUM3Rk9O?=
 =?utf-8?B?dEllWk5jMXpvZ3owTHE3aVR6TkJxMVVUd1orU2RNcFFQMUVvVGZrei9BdTZr?=
 =?utf-8?B?RkFSM2xmV1ZkZjZCWlBFd2ZkSDJGNW53NllBYnQrWGQ0Z2VxdzJLcEpwT21s?=
 =?utf-8?B?RjJNM3JvVGgxaHVGaEk3SnZxZ1N0SEpGNno1cG5iTFJTYVVFbGMyV2NIY25m?=
 =?utf-8?B?aFMvdHpmZm40Z0tzdTAvSFpteDZ0NWcyeXJmV3huU2Y5akNCeEM3eCtuQlJ3?=
 =?utf-8?B?d01JUG5TTEZEbEZWTC9HWDJOcE9TWVRPOFowdlN2SDhVUUcyQXowYkNqTWRk?=
 =?utf-8?B?MU5qMGQ1QW9TSkV6MG5XR1FqQVBkRW5sR2xvdnZwVkVPZHo1RHpTOTFwdW1X?=
 =?utf-8?B?V0xjREdYRjFpTEtVUyszc2VqMUYwZGd5cWt2SHBseW1SN3JpS2dSVlhlb0RV?=
 =?utf-8?B?T3QrdTRmbU05SkN0SmxEY0lRSHA1NEwxMVh2QTRpbGZIWGVpYkthNG9leHRB?=
 =?utf-8?B?T3BvSmI5NWhCcW1DaDd6Wmo4WTFTVDdvOFBTM1o2dkpZMFhzTWNvMXU4OXVE?=
 =?utf-8?B?VURDL3Q4cXF1Qkt3SDFuK0xrVlMrdVBCWjFDQUFHTlJVaHVjZERWclpaVTZY?=
 =?utf-8?B?WHplK0lCVE81czFDYitabTc4UHRwNmVmVk1GVWVTM3RlQ0pQOWhvd1ozTlhZ?=
 =?utf-8?B?QU1uS2xOcmtVYktJK3MzRHlvb3BnVW9BL0FUOTRYZVJqbUtiS1RlL0pXQ2I3?=
 =?utf-8?B?cEVuWXYvUzV0U2hoS1BJNjdyTGc3NWRVYUdITitVenBHdTltcjRxdTd0TzM1?=
 =?utf-8?B?ZHlGcDFucUM4UGVkZytuVGFOZDZPbnNOcW55aVVIdUpKMVBSOGY2SzFFb2da?=
 =?utf-8?B?UWtXckVpVjZsZVpoR3BXaVVKcGEzOE9ZVkxBYWFUVkJ6RkVIMXNTWnZqM2Ir?=
 =?utf-8?B?Nm5rTzU1aEc5R3B5L0p1Tm1pNVBtYWY3cUZJZnAraW43Z01EcUxQTnllejF4?=
 =?utf-8?B?ZDBSb3g5MUU4SlcrbmNvRnlGcjJ2SUFjSFg1K2ZtSG5OU1NCcXdVSVNEWXdj?=
 =?utf-8?B?QzhZQ2EvQVhXdEZxQ0JxRjdqY3pjcVE5elpnVDZpbFpFTU01ZDc2NHF3ZkpP?=
 =?utf-8?B?a1lxbng4RVdGd1NTSlc3QTdzeDN0cVE5azZDU1dDRm5JR2ttYng2eFdYYXFv?=
 =?utf-8?B?Z1QvZEEvM0E4NE9jYk92NVhSMkxTWkhGdVZoWkMvRThhWjN6T1grRkg2N2JS?=
 =?utf-8?B?eW40aHUrc29RMy9naWZvbUJWV2pMdkV2dXk1eGlGWE5Sdi8rU2Y4YWhmL2Ur?=
 =?utf-8?B?aTlXYzR0M0drNFRDZERGeEVvNUhmdW85MDI3ZU1ickV4Zk9mQ1VwandUNkt6?=
 =?utf-8?B?YjVxNmxwbEd6Zi9wUVdVK3lOUVhVckJoOXdZNzRHcW1qcDRBdjZOUU5pOWxV?=
 =?utf-8?B?TW5wd0p5R0k2VkJGbFcxejFmY2orcDRxdjM3dXBXTEhOU053eVZQSkxCQnZ0?=
 =?utf-8?B?TkZQeFl1ODhYOHFTazJNRmZKR09sSEVYKzBud0p2akpJLzdRZzFtK3Y4QlIw?=
 =?utf-8?B?SWY3SnJaM1FuTW1OMDNFajRDRk91ZEZGQjFMVlkzejRsK2dTRTFWUVVuZXV6?=
 =?utf-8?B?VGlTVENyRlczTkZkbmdaQ2MzcWdzYS9kYjdoc09JNGd1QTRGdnpYeUFUUmV5?=
 =?utf-8?B?eUk3amhGNmZrZWxYdlRDY1YxZDhwSFI0M2d5ZG5ybFhUMERtZVFQZ0hxTE1o?=
 =?utf-8?B?cmo4TG5kdDNlbTFVNnNTUmVWQ05Ka1JaaE4rc25lNTFwODNwbjFra1hGYStG?=
 =?utf-8?B?ckRRQnB0Smg0Mlphd0pRR1ZjTFc4V1dQVlBSQ1VsS3FMWlFKZjFDNThpQXpF?=
 =?utf-8?B?cmk3dG4zMmkzNnFKaU5Qa3lEaDYrRUYrdDBkTnpSTGMvaWl4RzJubFREQTVE?=
 =?utf-8?B?My9hWGd3WHdJbUJDcEFsR0kvTzMyT3cralZqRXN1Z0NxMzRmYnFuQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d74bef-9f31-47d3-f930-08df4a504a44
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 17:28:01.7079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0CymmQFL1KDF/rylAkxan7VWsJSlyILdAPzWbpcUt0mBK0gb9b7mn2gYQDOf55C+XlE4z3tVhHGmLpWFuROJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8823
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BA58160005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 66uya7s9ird45597rq71k79bcwi4z6ei
X-HE-Tag: 1795541293-919844
X-HE-Meta: U2FsdGVkX19p4oUaTZofemFFAZyoKG7w3wEvkeqWc+CHMhRsObg9wvykyxXRBnTnHrJC/xV01Hdv63To+CdfszLycR/U+WXLrGM4tDvqwjycDiHrOWaE1Vwrf3SxLvweq8/KAfH8uzJbiWbBpwPjjuMmhYOYkDATCv77Vd8OtjbdeLeiyCJr1FVeL5V24ca9br5k+OkkGR2vpVZU/FeTTmsEiTup0aoJ1jjVveJnFzLAIZQu5BS2rBWjvbfAy1KqOwfJtp8aIU87RWsyvn0gu+EjgtuHVGBrE4S5zOXlxGPP1+ZiyCaAz0HCUUyRn9ou251QIhaT96kNtphgFMsrbteGPYD84GIS4bfSFHPO2RheoJcjPcaCip4Kr/VSWi6B9E5JYEZ65FVRGq1AqUBwDX3f+Q35AdmzM6+Ija1EFu/9skwVaJ/Dsd1ELd9RLV5aE25OhZqSEJphAPNqtl9AduL+1iSpOtdk+6Wgfgh9Hll/6mOdI6OWrTmPTDPnJtWzDVPjiYp91JBB2N+LXvawygVT4OmDVNo4L7K2ctwfzas1K/+GdJ5ll4BDO8+USHcitxPVpdDDrekZSfz3rL1yBczqWT5IzZmnHf0/ZQ3lACwt2NpETPd5s6lu4glRwtpQ+g7k9Cmob4vikFQGOKC0F4jLNDgLXEvj/nZWzDV53r9LLbSi7nAAG34LP/YvYXNLHBQ70URuB9ZKM9qW/N0MpDuLFTxWkg4URQSmA1LqLb1Og4RxyVGGjnMIwIn7Yi1ldbDoY/pF26I0Uw1R7Ys4udgUn3xuIMAhmRDMDDTPwdaYUFZKZB8+2/7Z1rqntCFsXV+Uny4fPzYg28tLoBHWjU5ZdRfDTWO765/E/4uDGMM+BEYso3V7+8J8+Z1Y8eGBOfo7qM/igi9JzGmJSel1xLah/FDVyFKz3If3+q2Ojt5qbG6+xkx6/2jjTE3JmjDU18hwMk6JR0iJUB2JCEC
 sOepkW7R
 oH8/4PWpaJ1v3DkxUp8xG2M/iId0LnFsZTnGXqHYaM4xltgpoeIf9PGUUgilfIZWGWEMsCrJE38nz7i1ac1QWSVE5Xj2vfbZMx5lTnBnf6w9ad/QVTdVP6wm9Kmw5nXo7acvNu5NtyFjxsrcElaAkCWSGjs1NfLI/40OoP6YrBWi94XaoYJ9AVwCYCGzHDjPqG1xB/GEPgfEOhKnTPVkmC8AmrsYPtPspxhOtcz0JiewHlTOR0UXRfY9eCIhe6QxeG6QmZy9zy+TIShCItgg0NiEEJNTOk9qz+2qzHgPi3mMfmLwYGtnmT9Azh4eRO/eTHByyHYL55818+56OwBT6onBblA/LmihtNhXjG/o2Zl8qFvIdxHRuMS03ma1PlFVYKKeKiIIayGwRreb9035o7XpJjWILsY2uhEYamOouikB11GMxuSIA9w6W99i1O3Dj6TF+/Yr//0ag08X7jnytJb1mBf04wSS3+4ImwNpcbzmsbldjAQo8c8BNVZgWlmQKC2TVQS39Y5cMLXtZ4aFPyjGQcHMU2kviOazA3lVzzw8IJfbpl6zwkD2qDkE/CckKiB/v8kE3zKr6eiZ3zfHunNjEdw5EnpczfxeOC6AVpjjWRott6qCLtVvgGPqG5POhsPr3EEyISxQp5S5VROuWqZjZxx+x2ervV/l9sgQuwhQRVFsarmhtFRJrUIG2WQTDVB6wFOOzlZPaupHO/UYGLKv+QkVVhocL2P+B82jJLpPAylGDBSNui/8Gb4AuJvv6FSs5FS3th9wQyLZiIQhSRllbXDxuD8HgSaS23tZ7uBASTmWrDfK0Py2zk+90O6dTWUyfMO9swYsSxZ/c8M/O1XFJJtkMNRllwUcuEOBtDXHSxYP87sjUWxdQ5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>>>>>> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
>>>>>> memory bitmap before the command line is parsed. memmap= and mem= edit
>>>>>> e820_table only afterwards.
>>>>> memmap= and mem= are debugging tools, right?
>>>> I wish they were 🙂
>>>> But AFAIU they are used to carve out "pmem" or PFN-mapped memory.
>>> I've used them that way for development, but production pmem systems
>>> always had persistent memory in their BIOS-provided memory maps.
>>>
>>> How are folks depending on these in production in confidential guests?
>> They shouldn't but you can't guarantee that.
>>
>> But I don't mind letting them crash if they do :)
>>
> I'm fine with either approach (i.e. disallowing it or doing nothing
> at all), as long as we don't pretend that this is something that is
> expected to work.

Yes, it is confusing for a user who expects it to work.  I hit this
myself and spent time finding the cause: a memmap= hole consistently
crashes a confidential guest (SEV-SNP) early in boot.

I tried to fix it [1], but a bitmap unit cannot be half accepted when the
hole is not 2 MiB aligned.  Also, a TDX guest does accept such holes.

So we are left with the following options:

  - disallow the memmap= options with a clear warning, as this series
    does,
  - add similar handling for TDX, so that holes are not accepted there
    either, as done for SEV-SNP in [1]; memmap= holes that are not
    2 MiB aligned would still be unhandled, or
  - only print a warning and leave the options applied, in which case
    memmap= holes still crash SEV-SNP guests.

Which of these do you prefer, or is there a better way to handle it?

[1] 
https://lore.kernel.org/all/20261113105554.199912-1-pankaj.gupta@amd.com/

Thanks,

Pankaj


