Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED80C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65496B0095; Tue, 14 Jul 2026 07:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEFD36B0096; Tue, 14 Jul 2026 07:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B986B0098; Tue, 14 Jul 2026 07:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95D5F6B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:36:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19727C0371
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:36:03 +0000 (UTC)
X-FDA: 84987178206.16.A1865E4
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id 412FB1C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:36:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Xu1EBMXz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.5 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784028960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50c/2a4cgZyUQrqlxOZ0b7WMOIbsLSy6QmLfqAj6kcw=;
	b=0o9AgZSJM3wZNYSdJpvKx/EKqRNBA9oT+9y7GYRQPxTBhg4oJ3d670Zi0GBjgD3QtzmIc5
	9efkIWfXNUOSeikkEq1LsoIc1b1HUut8eDHz26TSppEVGldFiC+tnUzIUbx7zVJxLloMpY
	NmS1MimT3arXCvdm+j178V26SrdMybg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Xu1EBMXz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.5 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784028960;
	b=b6OS5hNjEtk6izkq5wyIQTy9MJ9vaV/6G2bbCsF4x5JgWLPXzGrUSOK5vt8hKDPOtPcLWg
	myUGtd+7Vnh008Jux7XnAukW13Yp1LczhnfHJDT0RQ832TuTn60rHa2QEqj2ab2ezWLv9a
	SylRGWWn79CXbZ8O1S8tQwh/FemKIQo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQbn4Hihz1RqBLgDPtTxXw04gKtpWl7SUyuPUJgux7h2XlWXNSLasvjYiO55U5fjozZogB1Af2oc9Am/ZuzDxpyh592LahAZHghfsGif+mJi/DQfMNJHktOR5FfumYHgOyLL0qen6XUtN4TkVn+X6ustfVBFf1CC3tuwOs410UAwu0HCvvxqN2fEZZJ9ufiE9VAUWn9fNpae74dHlJq0buFYjJvOVj7VKtMpY4tNNLJgoOzTcKMoTSmh8cFPdwDi3SyeK33YK0QRAYc9Vp1qaPZqKSCS/BdU7SDjiJCk6Q/3HzELMrTgExf71Og7j2QXy7cgbzSHeYgxoYVkJAwcuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50c/2a4cgZyUQrqlxOZ0b7WMOIbsLSy6QmLfqAj6kcw=;
 b=TpNwdLQXFezB1dKVqcQPexC85wgr3UxYb8jRErTyzw7YKy4pXgOdIklw7ciI9HkCVy3ONwdSlIUeEVpdKG//odK8p6NZu37D5OuORUo6UTnceEe/yHhFexKLVlGmvUPT1QWELZ2ZyVZMU8xWgER3u1WtfnMS/GiWN5/OAjKoWR2vgxqLYxoJ4RCd/wDKMCFAqtWwra1sf7OLJrYlIebceDzpXuNEJIukP9u+ULTRT8tDaEaqaD02rd0UAGRbER8EUbUDc/iXTIab0MF07TQHwCJCjkpb3PFsr/jD80Ok7OSiD9Yc0/cQYBJGYHDKFFAYsspRea8eQHCSyX130Ji2RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50c/2a4cgZyUQrqlxOZ0b7WMOIbsLSy6QmLfqAj6kcw=;
 b=Xu1EBMXzdGOfW8TzQaxm5uU5LeHAPrqZ2AC4RJBPwg4LzsEZGT3f/r5fHicgq8vaUTzgekeT4kTtlbDBuk2CQESPU27z22Z31/7s3A/LNMbcosyMsYi6/rts5MC2s99QPQBmCqM46Wcarw4a1IvCvY5eEdAXPU3eEWcHQLqaLANJLVYOPoI+o/AErpOnAPb0e3rD/yH0jHtbG17Yp/NaOrhkD9x0hP3DJWupSELDMEo2ZY8lQzFNjuUPRaGMyyBADaXgxWK5zS4kePp+mP/KXRrcuoMFIcCMycojME1jlLyDmG9H1TmoEBjFlzDbfFtAiBGWSaVBQq2SIvrfrjroag==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by IA0PR12MB8746.namprd12.prod.outlook.com (2603:10b6:208:490::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 11:35:53 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 11:35:53 +0000
Message-ID: <ff75fd32-6aef-4712-8a4c-4deaeb5c3269@nvidia.com>
Date: Tue, 14 Jul 2026 21:35:44 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/8] mm: factor zone-device page init helpers out of
 __init_zone_device_page
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 apopple@nvidia.com, arnd@arndb.de, bp@alien8.de,
 dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org,
 mingo@redhat.com, rppt@kernel.org, tglx@kernel.org
Cc: linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
 <20260709112520.24857-3-lizhe.67@bytedance.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260709112520.24857-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME3PR01CA0053.ausprd01.prod.outlook.com
 (2603:10c6:220:f7::10) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|IA0PR12MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b608fbf-fb5a-428f-91c5-08dee19c0fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|6133799003|4143699003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	bux7qwnPEaSVJc8ISOIMthqPu0LhA/rEZudXnF9fYH6KEsuaNA486+npTgsA3exjzdKGDNjuIb5opUqufiKGWXJZ/LNn3ZQGyokHFLpro6D5BxiWqKVjOgmyFObEytS0cNrVCbfZVT6D5apDItygKZlLnmztY31/F6YAIq5vrLZFrpHjnWz6yUs/8tAZlzBfqG2Wq4LvsvNGTAYhI9iYtOktVM1qUylO/SV11Ow+HTXkXOoXzOKbm4qtk1NzjK6CgA2e0+IAIrgZ2JIkMIozCKw0jG0MxoZzuOAlqIGBINELat8vuBnciwZ31MZoXVygDCRmXMDOSVPxZfI2323Nb0ghCeYk9giG2pGXD7W1kC0AA8CkBuqjVljwUPIHO/LIRoXgumw5TcNsKepmN+PYnxEtI4oZv3lr9rqwbDDug1py3T66I00mapXJhmpQ+xniUczH81HR88PLcKUsSnYhEwnWOcisjpiRnKsBEX3CqOC5UXgxyyMG9ZxsZhRvDEpzexdaUgxq6VjO3Yq8m8m1w8Rhgqs7AqETWgdTiZXVzFYXjQFHmdC2l4MMe7/UeDJeKoM38JbByvwDU10k1PDnGqJB+/2s0hELnQSIbsM3jRoQ/iT8bgwXiKkkeutGgKM5BWVwcAJk4xqeKUxSt8PNf31pOvmr2MmoHqiCEqwRmCnpjNQfkjBBzGriZpCjTXPsK11/2HcPSzMgru2hTf6ziA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(6133799003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SU16UEVlUkdxWXFNcDR2K21xWTZOa3BmcURqMUl1U0NtU09yN1dQblp4SW4w?=
 =?utf-8?B?Rm50SHFyM3VYN3EwS0xuT2JWRXM5WGJmS3FIdXF6UEc4RFZIMks5d0xLeGlU?=
 =?utf-8?B?MnlDaHNydElkRjhpNkt2TElDbkZIMTR6QktZVFhCVEZhTEpSM2Q3akI1VkY5?=
 =?utf-8?B?YXpOTy9mVWxRTERrN1RVTnJWbHp2OWc5MURPMlRJUXk5Nm5yWGJveElsdFMw?=
 =?utf-8?B?SCt1S1RNd1NVVUVrMVNhUHJHdm5lSnJCTXphK255dXpydjdScUZHdFFpbFZR?=
 =?utf-8?B?RUZQWHVzdWVmdHZtZmM4RDZQVFNnY0x0bTRtOGZtOVVKNVV6amdFZnkxQ2N2?=
 =?utf-8?B?WGloYUYzWk8xdGtSbkxFN3YzT0FDdWRVa29GL3IwdFhOTnV6UjRFYmEyc2pa?=
 =?utf-8?B?eHFQQlRWU2t2Z0FUSHZNTTRxbGdlb3MreVpaMmVJdTkrb2U4N1JwdmJLNnJG?=
 =?utf-8?B?b1ZUT1V4MDhNMFZkemkvSnFsbE50OUFFdXVucCtacTlNSHdLbFBycGpwVFpM?=
 =?utf-8?B?dW1FWWExN016c3p5dHpXd0NxRXRCM0FpbDN3dE5Jbi9OVFpSMTMxTVJhR25y?=
 =?utf-8?B?Sjl6NVBnbEc3UzIyU3dpZng0WWtUVk1qay9MOEZnY1RwM2I1ODJDQkh4RUdv?=
 =?utf-8?B?YnROMEFVK1pVeWRRdGFNZklDYnBtdHhlRDkvYWZpUU51RUk3YzdiditqQVRo?=
 =?utf-8?B?U2RxMDhSOGErYXRGeGNpbkJwdTlLangySGdxTkpqMXMxdjZWY3U5aHVXejhE?=
 =?utf-8?B?YnJ3aXBNMk4rSER6Z2MyM2hxY3gwU1RzdXdWZ3lRdEI5MmY5Qk1ZMnJmVmRu?=
 =?utf-8?B?d3NjTzVWQ1NIeUdJelBrZmpGSk5kR1F2b0VKWklDSWhLUUtoejFweFAvQnlY?=
 =?utf-8?B?RFZIcXNLV3llQWFkVWNTVVU3UXN0cm5Xc2FLRGNZdjJ4VHVVejNkRmJzbSs5?=
 =?utf-8?B?bm92QWFzc2krR2hEUExFcE9NMmhKWi9wc1FnNjVIdFExcU1seEdaRjZXWUpn?=
 =?utf-8?B?QkZmUndabnBsa1hkdnVQRld4Qm1IZXUyL2tabC9XOFd4L3hyWHUreXJCdGdk?=
 =?utf-8?B?VEZIY2ZRdTkwN2lyemxZNGtDRjNYUm0rb1lJVjB5WGR2OE8vTHhSMUJGalZp?=
 =?utf-8?B?K1lnZTJwbXFOakxaZThrVThNNUYyTCs2WmZ0WFRxQlRJRkNLa08yR25oaXhw?=
 =?utf-8?B?YmZmTnY1MHEvb2lxcXB5Ukptbkg3Vm1OWWtrQmkwQlh4WWRmTkp3czRsK1c4?=
 =?utf-8?B?eXJEZHZaRTRRRHF3UVQzL0I1MEU3cXNMM25mWUhxTllUZzdMTEVMVjQ1M2Uz?=
 =?utf-8?B?SnVEc0hDTlhKQnRvK0JwMFdhVnI0V3dUVUE1Y055T2Y5LzNTZG8wT3RNaWNO?=
 =?utf-8?B?Y0hIQzhSN3V5MVc5eE1CaVpWUVhFcVZsMlhkOFpsSUtMNVI3cHhRZU04Um5S?=
 =?utf-8?B?QytEVWZGNnlDMk9YMGFBOVZPWk5ZS2RvUlN6SWlqSklOUWRVNFFkdmZtb3dk?=
 =?utf-8?B?bG1XSldraUhNREJ1TGc3LzV1TDNyNHIxdEMvL1Myc0c2dVFMeE5pTzIvSVRQ?=
 =?utf-8?B?M3B5UG03Zi9ra3p0cU1LZTBrNWU4TU9nQUkwbkZiR0l5eHgyVEQzYnhRZGpU?=
 =?utf-8?B?WG1Wc2o5TitTUGtDdmREQ3RIUTlQQ1RHUXpsd2o2Uy9uSlU0R2FETlEzbndo?=
 =?utf-8?B?enA1V1g2azNNZndNZCtSUGJNUDR3UWhqcW9JcHdudmFFejNHczZyT1VQL1A1?=
 =?utf-8?B?alo1MWl0QXlOcFFnbHBsZ1plTGRwTlRTRk5hZWVkN0JEWGplVmJFa3A0RTZV?=
 =?utf-8?B?aysyRTdEaTJQK3V2Ung1ZHpCbW5ZblJ1WU5HUEZhZXBjVEhCaDlnYXJFTEE0?=
 =?utf-8?B?VGlBczJ6TFE0ek1wREg3ZlEwaUJZRWw0N1gxZWIvR1FLbG5XN1J3UXJTTFhU?=
 =?utf-8?B?TG0yYkV0ajJEc0VOMWNKSGlxdzlFYnJuMDRhWjFtWVhQeUFKd1Z0dXk0dGdq?=
 =?utf-8?B?V0R1UURuWjFvajhnQVplY1RLckVOV2lhRTRPNE9oMHFUUThtT05TeVA1QXJD?=
 =?utf-8?B?Nk5CQitlVTh4dkh5bWtScnp5V25GTTF1U21Rdm9Zc3F2aklxUGFmMjVvUDJL?=
 =?utf-8?B?SXQ3Y2VHMWdaSmI4U0RXeEZ0akNMajRXUmtkVklSSnlmL05kZHQ5WUY5bU5E?=
 =?utf-8?B?bHJJNDJadGtmdlIwUTNlNm1XMVFnb1ZBeDl6QXpWTTh1NnlYQmpScExzSmhv?=
 =?utf-8?B?cmdSMGFBUzVsWndFZ2kvQTNCSk1BTDBlVlhPbGJGSmd3S3VaWnQzUzFxMkFH?=
 =?utf-8?B?WS9UdFJHaGM1eDJyQVdlb0owcHc4UGQ0aVVhMERyS3R2RlQyZjNjQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b608fbf-fb5a-428f-91c5-08dee19c0fc9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 11:35:53.3096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dMKCSbwsVc8DMIiesXdcadp9a0aLX9XDL5oKSgxdhR/j8X21FGir3vulJo+pG/VjWWAYZyrCybq1R2Au/ej0pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8746
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 412FB1C0004
X-Stat-Signature: oywjttnui59kmiuwm1cff6sp6ootewtg
X-HE-Tag: 1784028960-685440
X-HE-Meta: U2FsdGVkX1+p8yEIkWljzkDcfv3xnyzOU/IKYEnQ8F3Lf79bbDWEhFVUOT5or4iODit875fhZJwSfH9VW8QpbhfVSefwXPKum3j4V0kKSlqNMi1GiE6kbvaRjH03YbcIviTiceg0p/nLvoqvO2FFt8Z9Tq6bOwjwQ4cxp7/fIR+Vo+mIMh8bnbtBLMplABrkivsvc4pRYkmXD38iR0Sub6dRocIhLZGfgucyD/QQyLTIhE2/bksTuBzd9dQ4JV/XiMYAH0G7+QJGyBVsHIAjiyThwD9c/sBVY9TovFSN22dmN0Yqa3n+H9eKyQKQkynuyvq5izaKC2cHDnjFVckjzAFzJIgiOgGqDDaFRyTieMqPvswOaA8w3hhn9gHdLopWtskcyfNJVTVff+zHdSkTv6dU16julQ2SO/Gp7Khe1HdPv/tqvo3WCMcgOws8P7ZBmGOv5pqqOIyA0BTw+yBtIplFB8VjHkQunVqBbFJ/LBefgHqs62QVdToD4Ckm8z4hAI1rPh0OSrX7BxImB1TfWQX2BEs8NUxDE8zD1l8LkMxVYUuyrvDymJohHyDudokM7tvWMkIQ3lppE/iJFh/xYudtXddl/th69JHfFNETC9EKKx8bydHMox0sZ75m8IwZMw7Yp6UVtYfh9TL/UAmdhHyaoHTEB87dfE/okOMlCcJLtVe1sohhVLGlvlUjoJZJdoEvGq7y9hEe7cCeKb9WrvwVFjFOSAgE1hHE7bcqk2fNIb82t0/x/Ic4Qqo1yy1OFBlrb8rjMhwmtnw3fYGIqUaKAbLo3eyGdd5dfSs7QTB9eVsvjEJL7uT8Qa5EnPdwHDQCffsYooQhnvlRAxQ2uKDMNouaWdW/lr7TBx21fNAc9Ki4diA3RKSTQ+zWS2d/3xBP6k99Pj3yLxq5jdkb9gg4JSwruUObuDnDIc4sdaT/wyXtVvFCzQD4eud8uE6LzAvxGq4J2D8c6fjqLcC
 +GOQmxJX
 gSl6xBqkTFenipGDhq4ARDqsy7wue1xSa0lZrak9HJw7EBg2LO3iIZkLzhpyM04OJhjS0+8LKeeYVb9SAfKz3CzZgRM9ECoIOna/v43Ni7qt+NeZNH+T1iVR53p636Lflr85y6/IceUiTE7qv1+cCqOx06B5kI8MxSUjOJmg84HbcTpgGVq4TspZPDto3KY7T38nXfJ/Mla32iLQCohEl39H3ZishBCpf8R6WYXi7Vvr5yCxhTkkc4LZqdjyynLZe5R26jJv/zQGiOmc+8byPihusIaWb33S2MZB3w3OKXHKf20hJUOeNcnmejPqHfoTJZd0C3i4QS8fsQL7Zok23mhl/s+qiFxlG6wyCq/w3Wd2D5cXAyUaTXZGulaIaQRNKbR1qzEPm055huSTToahBSnrNTk8key4HYjqs+0mWmEXH/jULpSTnR9S0B3CdrwDw35DK6sHgdt1bHle4flQBBAmBYPSv+Yd1wv68jkZsRNmcPf+U4pJ14YzmngzZIr2tQ+PA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 9:25 PM, Li Zhe wrote:
> memmap_init_zone_device() currently mixes refcount policy and core
> ZONE_DEVICE page setup in a single helper.
> 
> Factor the refcount-reset predicate into pagemap_resets_refcount(), move
> the common page initialization into __zone_device_page_init(), and wrap
> the existing slow path in zone_device_page_init_slow().
> 
> This keeps the slow-path behaviour unchanged and gives later patches
> reusable helper boundaries.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 95808ab5cfdb..5fccfbacf855 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> +/*
> + * Return true when the free path for this pagemap type restores the page
> + * refcount to 1, so memmap_init_zone_device() can keep the count set by
> + * __init_single_page(). Otherwise initialize the refcount to 0 and leave
> + * it to the allocator or pgmap callbacks to raise it when the page is
> + * handed out again.
> + */
> +static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
> +{

resets_refcount reads like it resets it to 0, but it could be just me. How does
pagemap_requires_refcount_reset() sound, with the value returned being toggled

> +	/*
> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> +	 * the count again when the allocator or driver hands the page out.
> +	 */
> +	switch (pgmap->type) {
> +	case MEMORY_DEVICE_FS_DAX:
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_COHERENT:
> +	case MEMORY_DEVICE_PCI_P2PDMA:
> +		return false;
> +	case MEMORY_DEVICE_GENERIC:
> +		return true;
> +	}
> +
> +	return true;

Shouldn't the default be a VM_WARN_ON()?

> +}
> +
> +static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
>  					  unsigned long zone_idx, int nid,
>  					  struct dev_pagemap *pgmap)
>  {
> -
>  	__init_single_page(page, pfn, zone_idx, nid);
>  
>  	/*
> @@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	 */
>  	page_folio(page)->pgmap = pgmap;
>  	page->zone_device_data = NULL;
> +}
>  
> -	/*
> -	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> -	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> -	 * the count again when the allocator or driver hands the page out.
> -	 */
> -	switch (pgmap->type) {
> -	case MEMORY_DEVICE_FS_DAX:
> -	case MEMORY_DEVICE_PRIVATE:
> -	case MEMORY_DEVICE_COHERENT:
> -	case MEMORY_DEVICE_PCI_P2PDMA:
> +static void __ref zone_device_page_init_slow(struct page *page,
> +		unsigned long pfn, unsigned long zone_idx, int nid,
> +		struct dev_pagemap *pgmap)
> +{
> +	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
> +	if (!pagemap_resets_refcount(pgmap))
>  		set_page_count(page, 0);
> -		break;
> -
> -	case MEMORY_DEVICE_GENERIC:
> -		break;
> -	}
>  }
>  
>  /*
> @@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
>  	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>  		prep_compound_tail(page, head, order);
>  		set_page_count(page, 0);
>  	}
> @@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>  
>  		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>  			cond_resched();

Balbir

