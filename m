Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67750103A9A8
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A636B008A; Wed, 25 Mar 2026 07:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B7F6B008C; Wed, 25 Mar 2026 07:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA1D6B0092; Wed, 25 Mar 2026 07:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA206B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:04:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 143038C473
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:04:48 +0000 (UTC)
X-FDA: 84584302656.28.26DE226
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012069.outbound.protection.outlook.com [40.107.209.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id 16E8240006
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:04:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=W24Fp5iH;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.69 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774436685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpqUoGzbLOkw4IijfuUb90GaRcQ+pY/ejacTwl5kf48=;
	b=mZsO9fyVSM9vNCCGgdyQ/afL2VODNpJCePH/spMu+pMTK7aiVQh1Wb4vtnACaXOydf+Ihy
	O50n0Ivc30oVFkbrblTIdPddRSogRlIzF1hrpR3dbLnQlh5UYIX8EPxar8q1IxgLjFL8aE
	CS5CNMiotAdhQiMNpzzApzCi5u9+J/Q=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=W24Fp5iH;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.69 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774436685; a=rsa-sha256;
	cv=pass;
	b=H3aHetgy5rSi2i57cWNABdYdltHZvawkTU3OmYsgqfakHocFynpNEwZ0oDiylET7j3JJJH
	ku0dJp2JkrCB7dz1HxIQDJopLOpPT/qgeln+J8ApeFzThaPfez6RWFrKENMg9A9HftesJ/
	RiuSguMIOYikzcqdhURphiEww4+6b3w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEi/qnI0S4l5sou0h4g1iv5WLsZgmESkcx2PMhUlIADFQOW/4gYfVgQ/nbrOpq2bw/YUcrLfpNqszfj/xJnroxpW63iSV5ROKa2jxUMD/WCXGgZH95dQjPm3x0KfPIvh32VVengMUtvZcyqRzWoYwgwPawa3p4wfXRE8e8Smbp1gv7oiw0oLQ/3FzSq/Q4usIc+lxIB7Onj8s6LJTLg0B3kVGrDLSqux8+lQdvwkSsHU/oUs69wMGmKi/yWLX36Vks117mFYR6+YYfEWdJjUc5kgn6PkJiaS2PLulTlzAqyF9UFscjqhQMjkO8DbVMvebAuUjVsoc8MIv2FKnJDH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpqUoGzbLOkw4IijfuUb90GaRcQ+pY/ejacTwl5kf48=;
 b=HMDJNsty+hKzXa3/4iiUEpjL5kioRvxAab4ZEVycQl4txaXSlaMTux+0UlM3wTi02ckO3kmUBqnTe2dUUZJT+Stj8O4WhPCggeL333KSzX5ces7O/6xc6lok1ycg/aW1cc0Q+FO8yADr9lAPljXP8bkXyz3NCqdb9fZ4z5sjFKzNpZPLkLnaWR6dwVzrUQmK7ZwTq/rkxA7CzYgSbzE0fpLDxsUV7oniPLUdqXyYkHjLJaJwekNMPcjuhOio3WN+YNFKOyjab9SADHAIK09isP/H31ZK0/kFIAeaM4AzhFIZEMhE7MZhhcs252QN1NjKOc1O+BYrB8CBDqO//BmHvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpqUoGzbLOkw4IijfuUb90GaRcQ+pY/ejacTwl5kf48=;
 b=W24Fp5iH9fzE6QivlYDgI8oNWwztc6pmVRgHPQ9IJBk4BDJus4Vf2h9KajxuJqqQHkhQPG0xF3WrvIMx1TnJH+9NV9tdkKkULskXyFKx19bOzLpqX7hvAO2PbmhyJMmvui6majVvlkfCLR7c5DEBzvumgHWsbDrjzeNy2TSw/MA=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by PH8PR12MB6700.namprd12.prod.outlook.com (2603:10b6:510:1cf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.6; Wed, 25 Mar
 2026 11:04:41 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 11:04:41 +0000
Message-ID: <f844a2ce-105e-4002-a106-b936ddd98a99@amd.com>
Date: Wed, 25 Mar 2026 16:34:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
 <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
 <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::20) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|PH8PR12MB6700:EE_
X-MS-Office365-Filtering-Correlation-Id: 247fccef-77cd-41a5-35c3-08de8a5e5009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	x/ojIGz/y8TaBdC4IMy4olZs4HltJdU10YlSh2bhsrrx6ikzzY+wKYrHIu1b0M1aIHz7sfRDJpud3voPe8gLMKDGfVPctciWI1bjOXikTK04jZjgDTjkwGPE/4/1wwtO2mGmRBfkXzmehCmnTt0Uh2tRfohNnjpBpq/ZTOs1l6uv8mKO/Xz4OYNg6XQ5pXyxnq/H/P9kHo4URAg7zgrWX4QELM4r60p6WOhW1oBwCtmIGGpiM9PPKkE69rbDRD16fOCv/0YCl7bwX/O4FQzArZ2+xLMl2WOP2Qas6WuHlvzdQSu+AExT59WDhQvAMk+fvSrCPeglcgOJTB6Y8gI9uMDlLWifJxXx1uYyuKiZJB8uOOZe3XRuhW08EDHmqvPdbxgxF+DJ85njXSDcaD0LCdnrgKO0I+5Rrp8w4Te24A5gHJQQT/OdBs9ZwoS7fxnj7+kJEqMWMrSMEUi6p9f6ru4PVvZBKaeISTO9++ICFV3ZlX0DtYq4PgG1CNQn8i3lZfNSr5vQB+X9pweqmKv1XGI+MDTO30AFx1SEHnCMzclZYr2zafoCEI61IuMf1eT208qJ+90Dl4kaCSYUPYjs0QnjxQIukoCR3e035+XcnUjpka13X/BIriBwsxfh1BJD2YbalXUJ0xzBwiWGd9SOFHypj+rD+L89FWOQWn+t/LJ3LQ5INUNY3GFFRjf5DH6QTECbJxK65ZOeAZ3Jnsd6CxojNfnNXz/icHNkftnpRq4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUkxSFdmVDFocGVOVzlLaGZzSWd0amVEL2xPdStUdnA1ekZmdVFMemFXbm9J?=
 =?utf-8?B?QUlZU2w3TzlZa09kdS93UnR4YWVaVTNlS0RmUkFlbW5tYm5sblVyNURTMGM5?=
 =?utf-8?B?UWMxOTN2ZmdCTk13ZWNvc29RSDRCVFB4ZmkzWk5vMzZGWjB5ejF5SWRRVmtm?=
 =?utf-8?B?QzB0TkdaTGpmaU1DRmVFWDBENk1BcGRkQ1kxT3BSc1c5NnZwUnVQM01LaUcv?=
 =?utf-8?B?d1NFSkN4cUJiUGJkZU9WelV3cW1kcUF4RTVYM0RJaEFtSDAxeFdYOElTU2sx?=
 =?utf-8?B?T1d6WERtb28xd1VVOWVwRThxNkJTc283WHNZbjV0cWpnMENjb2hkZC9XOW5M?=
 =?utf-8?B?eEJJVHhyLzVnRHhua3BhNzc3Z0NIZFYyYjZvRGlSSjZHcVBKaDZsYmVXQVRJ?=
 =?utf-8?B?UkdxVGdpWjZ2TjZFT3ZlNm9FNXBtcGYvekt5NHJBY2dFWkw5T1Q1ekk3Ynk3?=
 =?utf-8?B?bDM5RFFveUJXVTF5eFFIcWU1OXRuVG52QktGbk5iV2QvMXQxODBRdFBFTFBj?=
 =?utf-8?B?TEtnSTB5YTRHY0xWQnRybUs5TFZNMWZ4dHFBcG1yYVZjUlVBeFBjODR3UWJ0?=
 =?utf-8?B?L1dCUEQrSGJBbk9FUHM1M0ZaVTlnUnNaVHI2MUhvNGxNNjQxbXVGYmY4c0ZR?=
 =?utf-8?B?VjkvK0tieWNSeE5TWktRL0JaVjRkMXBmSXU4R1hsOU9UZzlJNEE2QVNyd3gx?=
 =?utf-8?B?dG5LaGdOdjFEMi9kdExuSWdzdHZHYjRCSDNqS3Q0bHY4azdvalVENitNYVY1?=
 =?utf-8?B?T0JxVHhNVkx3WVZBNlR3SS94c1pJS0J2R0xydWhNcGxGMjRuTGVYaGFZdHhh?=
 =?utf-8?B?VzA4OVg4RDlBRDJHUGhKQzhDOGJzZ1pTTEpwcWxKZmJmbll3RE8xTG5mVEVD?=
 =?utf-8?B?SmhGMVo5aCtPM21WRW8wYndLbVJOaWVFejF4L1BIYU9mRGFjeGhLeWNJTVdW?=
 =?utf-8?B?UDMrMUIyRFUrWE0zbzdhbCtya3hWOGNBcGhUam14bFk1akFJaEF3WWk3QTlL?=
 =?utf-8?B?N0dpMXlPL21mMmoyS3FITnhzVmFEWE1uSGFyK2ppMHRnVXdrYzhqazM4MVhO?=
 =?utf-8?B?alRUR1p4RWRQR2FaQ0VSYmx2YjZ0MktKK2F3OHh4M2Q0cXM2YWRVOVhpRkpv?=
 =?utf-8?B?akxXQXJDQkFpT2JrSCtGY2J3dWlqU3ZVZi9XblV2aXN5KzZiQXk0elFRQmRP?=
 =?utf-8?B?VU5SSXJaUU5rMHhVWkE0Y003WjJSYnJvOWhBcFo1L0xRLyt6Z21GUGIzb2R6?=
 =?utf-8?B?akdrQWQ4akwwN1pVcldYSXlXbTVwUUFSOFVwRElheEhLc0FKUkhPUldOSlBT?=
 =?utf-8?B?WUZtcWZVdVU3TzVNOGxBYzdoWkV5YnZlMUFmVnBncjMxRU9FOVBwZmMzcTdJ?=
 =?utf-8?B?ZCt5VzI0cERoR1dsVnVXOVpvVXBZSjIwWGk1VWhwNFBGeWFxNGtyYngzdkVi?=
 =?utf-8?B?Wm1CbkhzMlNtK3hXTGh0ZHkyRXN2bWJaNHc1WVIxWEFsSXdHMVZIV0xrZm5C?=
 =?utf-8?B?NDlGTlMraDdUUXlqU2pKaXg0T0lqTGYyK3BNdGFyb2IwdWNGbmM2V1E0bi9a?=
 =?utf-8?B?TXd2eUJ3ZXkwYmUyREZCSnlHZ216TjAwRnJ0VUN4L3ZTTXJ6ZE1GRjhINTBm?=
 =?utf-8?B?WVhLY3N2QTQyQSt0eTBYeFJoS05ibUJGQ0IrS0NDbzVOWVp3cEtpOHAxbGtY?=
 =?utf-8?B?VHFPZmxKQzI0YjJIdXZueS9RQVFmV3ZnTEFvMEpVT0FZdnZQTWh0bUh4d3lj?=
 =?utf-8?B?MmU0Ty9kNkhVVU92ZlM3VW9yRXRWd0VHL3FEMVpUb3ZwOW1ML0RJZ2tSY0dS?=
 =?utf-8?B?YVNsTzRVN0phZjNQbjdKMGxCRU5HZnRXK2x1Y2RiNUphczdaU0FxTVBmWGFw?=
 =?utf-8?B?WHk2Y1k2b2ZmYVhYbUpKejBnb3RJbzZRMldRMHRTMkI3RUwrdFo4RVg1OTNY?=
 =?utf-8?B?MTh5QUp6elYzamJETDI0UEZhR3ByaVNkWWtvRCtkVWQ5VDNLdTRXNE9zNUtN?=
 =?utf-8?B?VHNhbWdVN01CTUw4VzVYNTYzcE5qUWYzYzRHMk0yOTcxeHUvWHdQQWJlck1p?=
 =?utf-8?B?blFxaG45aytLS1Mrb2c2T3V6TjlHLytpUUlTM1hQYndpdmpmUTFNY0NVZ3RV?=
 =?utf-8?B?MmttejhzTmVtQmdpdU9JSnZ4RjcxVTl4aFl5RGh3M1VjOFBWK1U3TnpCRkJw?=
 =?utf-8?B?MkpEZGllVzdLVGlMaTFJTE1LdXd2OUhRc0s2c3NMcmcwS2MzY3lvcFQyYnVy?=
 =?utf-8?B?S0tMczRuRzhDWDVmNnFHTlY4VzlxT3AwKzlIWU5QY1FhdFZMQWFwd1YwUHY3?=
 =?utf-8?B?ZEF0eXFNeHg4MnUxMXBmQy9FQVNSekJ2T0ZyYlB2Q2xGbGQxeDlmQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247fccef-77cd-41a5-35c3-08de8a5e5009
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 11:04:40.9533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RrOAPi2hG3sW0blQWGOAs3ES/ERnxc2DUrL1K31xRyW7WENETDHEZLRmqKKMtE803vimeer4Xc/7J2cTpHhGhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6700
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 16E8240006
X-Stat-Signature: nbm8x14qztnucr46ebyeuazjfq8o1osc
X-Rspam-User: 
X-HE-Tag: 1774436684-990416
X-HE-Meta: U2FsdGVkX1+uE05NX1PjvwkrLA0QVx296kJz6skxDFDkCz5JPi9c6AuvEYQD0cgSGREiAw0EETsG6Xi0XfFQlllGkaHa5T7UNWY0Fjnxazm9Roa48GfP92rvLR+rRwjtbfd/Fms5dLPfbDw908LHbEHqZ2mayiQbxYFD77emynkDEGGRdB98rfGnvJeHMWdem99z1kuWveGQ7GWJTQGegDQ3/yO+ky9mTqDuOtYW/Mr5pNQ2SmYXDPH1+6mZ7JLs7PcQgaCY1MHYYbUx2Iz/uIctRDD53AnxnnJ+ZiHvtCHE6yQQdmnmUVpGRavtkVQFviXV3uMqTlyCwbXr54CdCCftJMLLi7yqzJmh7+UUZPQmG2soCpknMB16hqrS+dl+kKcRrSU7kWl7VQ0TG63aud/xiyvuDt1WSG7ym0JhZJei+DeQ54IozqPBo7ihFvcAbragV2BxhrNuedvMc3fVdV6g/BaRMdowyT2/6Z4tB5NKQKvVKh9lO7UXeWDSd4cOnm6tQJPgQTiOqa0GxMDbrhXmZanrbQ70S543UIqXyJ/jodBuV+pYkEqvMYFnvYwAEkTDs+Qc6gb+HHm1SmAxQvt/HrZxX3aZ/vKlt0+WAL+7WtTe8b/sr9lAQDB9nhT/XErOFn1nO75kHqYi4VPaj3wKGzm1K3ssLn4lV3qh6VRZjS6C2a5bbszZxFNglLaJbsYwInH/lfjU/+p0NB2LAC+hcQnjXlzgh3GJYHe1RVqnm9X/ePronnmZFactsfFFFkNjeuBiDA6k5fVyVTGgno4EgtjVoLfheZjOnpXmxSLzP2bBMpWk8PHbdUSFq/AfULJHZAwUTcmv6dhKik3GHUulREKi3VN5jIv8scAcQExDBQfFpDuUdQHC+1mjoxDmu344lGs5017HllVsEImQ5IpI23JXApu4Y2o/URKMeECuZEKi8QU/jgS7gMpZyIjkrs95rxagtNfrtWdAAfv
 IGYVxgrX
 RkVhS7piuCDQn8x47Wohqcj0iTw3A0DtEDtw8D//4mXIjQ2HhzXfv6choHXDEyqLm667gG2jW+uGWKX2uESX2GgIKu5rMlevPcJuzOoXutbKDJiPGAgLyJBS0SjjhVAeKObNdBzUaSLL0h1QdOu/znShBUdLCXHaAvVuCiJqT4nUJxa6qYB42fDnY2rClG8Jgqyu8LTeyqkUD7o9UDWB+Mp2USi0nXNtf4Ihtc6dsFyzgW8t/LkR8taxiMLZIFbRhDNsODAmYcoPJtBt0szXNxXeVQOpoe6vuzaSq7BRaSm/hm2K+x5cz+bLTLYYL5SxVxygdGQ52GvCad8nwL9LHQ+MU8BRm8vnhw3uUCIIDvzavwpAMJR4iwXlFMKlhpuODq2dluL8NLDvcX26bABj0OD4fTQtcMFZIQPEiWSu+f32RNDJMw0+6rhtl67wZZ3mLlaE6Wx6l7LNcBMU9eH7OTbBAj6Srn2X06oCtTGI+pfj0d9b933YQDfHrjTDq/a20CuP7OW4zVoPUP9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/2026 2:55 PM, David Hildenbrand (Arm) wrote:
> On 3/25/26 10:21, Garg, Shivank wrote:
>>
>>>>
>>>>  static void __migrate_folio_record(struct folio *dst,
>>>> -				   int old_page_state,
>>>> +				   int old_folio_state,
>>>>  				   struct anon_vma *anon_vma)
>>>>  {
>>>> -	dst->private = (void *)anon_vma + old_page_state;
>>>> +	dst->private = (void *)anon_vma + old_folio_state;
>>>>  }
>>>>
>>>>  static void __migrate_folio_extract(struct folio *dst,
>>>> -				   int *old_page_state,
>>>> +				   int *old_folio_state,
>>>>  				   struct anon_vma **anon_vmap)
>>>>  {
>>>>  	unsigned long private = (unsigned long)dst->private;
>>>>
>>>> -	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
>>>> -	*old_page_state = private & PAGE_OLD_STATES;
>>>> +	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
>>>> +	*old_folio_state = private & FOLIO_OLD_STATES;
>>>>  	dst->private = NULL;
>>>>  }
>>>
>>> Just an observation on folio->private, it is void*, but page->private
>>> is unsigned long. It confused me a bit. There are folio_get_private()
>>> and folio_change_private(), I wonder if we want to use them here
>>> instead of direct ->private accesses. Feel free to ignore this,
>>> since it is irrelevant to this patch.
>>
>> Would something like this as a follow-up patch work?
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 6d4a85f903d8..55d1af6c9759 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1143,17 +1143,17 @@ enum {
>>  static void __migrate_folio_record(struct folio *dst,
>>  		int old_folio_state, struct anon_vma *anon_vma)
>>  {
>> -	dst->private = (void *)anon_vma + old_folio_state;
>> +	folio_change_private(dst, (void *)anon_vma + old_folio_state);
>>  }
>>  
>>  static void __migrate_folio_extract(struct folio *dst,
>>  		int *old_folio_state, struct anon_vma **anon_vmap)
>>  {
>> -	unsigned long private = (unsigned long)dst->private;
>> +	unsigned long private = (unsigned long)folio_get_private(dst);
>>  
>>  	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
>>  	*old_folio_state = private & FOLIO_OLD_STATES;
>> -	dst->private = NULL;
>> +	folio_change_private(dst, NULL);
>>  }
> 
> 
> Isn't folio_change_private() part of the
> folio_attach_private()/folio_detach_private() interface that has
> completely different semantics?
> 
> "The page must previously have had data attached and the data must be
> detached before the folio will be freed."
> 
> (btw, that comment should refer to pages)
> 
> So I would not use folio_change_private(). An accidental
> folio_attach_private() / folio_detach_private() would be rather undesired.
>

Makes sense. I'll drop this.

I think using folio_get_private() is fine.

Thanks,
Shivank




