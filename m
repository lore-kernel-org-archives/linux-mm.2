Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8BCFEC0F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 18:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A096B0005; Tue, 24 Mar 2026 14:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E213F6B0088; Tue, 24 Mar 2026 14:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0FB26B008A; Tue, 24 Mar 2026 14:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C08E56B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:59:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AC781B798E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:59:33 +0000 (UTC)
X-FDA: 84581870226.20.FF5E753
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010026.outbound.protection.outlook.com [52.101.85.26])
	by imf18.hostedemail.com (Postfix) with ESMTP id 65FA71C000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:59:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KUOQaLBo;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.26 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774378770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zrnd7A/VMLZwxKx/SJZYM2In4bkAXC76Fm53P/39FjM=;
	b=xEpqqgmpT/y6tMjPGq5q8gFLSIY0ObWi34UYThGhNC95LKaTjDNc5KujvJCCCoqyfIp7xI
	N2ocu8A0mojGRmxQwW9ACS3xCkgl+4NYNN1DuS71382a4jsib1vylr0ETkDOGZ7pHFhLy0
	qYVsf6ec9xWzTuSKy1mdOhv07MZF5iM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774378770; a=rsa-sha256;
	cv=pass;
	b=FFDVuxXc9iofeoZwDuaRuXiNIhJgz419vcSD0CqWveNMC/i9wK73o5k/GyjKxm0PXYmbKg
	9JlTzfVpERzWz+UYQidxDlUSdAuh3Kz6o0hvu4YeqL7ppe378tT4CSLbABtPzxdBW7aWJT
	RIN1nJ+dIjHw70WaTe48RT1O9Gh7Ll8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KUOQaLBo;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.26 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LGtV55zwCufXZk3kdqAfdEdRG2qdggMRa5nDVxpLjRE+LavknMg2mLElWJJ6TmBwR2qZWKjUi2YTeICW5Q8pw12mQ46LYI2bWP/WlKoIljJZCLG6Gw02lhzVU4zYguesNBK/fgGkGwEWbI+hj9Mol55UspiHpfKWMnDex528b4m6LXul6kOEZNPnUkXmuhQtmAMckZNJ4xhXj7mQ2NDdXfp2TOiwVtPJx0yo89YOViQLgNTbP5ab/lNQNzodpYQ2tEIjNoPxF/sas0Py9rmJkPlFWaO34r4nYMoWcW6kdOBIBHa6L8ByLtrpDM7dIDSg7FY937l3Qc60Crf6Vu1eHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrnd7A/VMLZwxKx/SJZYM2In4bkAXC76Fm53P/39FjM=;
 b=CYlgyEUukXDjfnhGenTgm14+j1LX8WckAE22Du+mMCRE9D4W5hdaAsodY0/zUF7EPKNMd9h2mPgXYOvehUjtCFJcRbNZoQd9/W1LunMZAJBy13VUMS/hK8cx2Ppy/dpdZWgBj+aVOzF+XDl2CqNDg9JJuWVTkHn8m6iC5cbD4cbn9HhzPo35VVACuQpjhPk0WEHUeF+Q0h7lcLRI9Pi17M0Xs7dOsGBvd3I7BVFklkgXudy2z50cR1ypR1PsRYbTsCZz1WeztxT7P0ebleoniQpsIfCzYirpNwUho4RdxCuoT3JxkJCXYVvqwX5UkSvRTMUpMHkHTydorpN/DODKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrnd7A/VMLZwxKx/SJZYM2In4bkAXC76Fm53P/39FjM=;
 b=KUOQaLBo5edK44k3m4qCQYoI1eIc6wfvkqzsE7gU6u7CoLqiStBgG9E5U0ideBRrepnKYDTzjj4c8/j2vC2G3+bk+ZoWxpS0POHvKAV23Apb7Ga+i3RsLh0UKZoSun3PKibL9F7uDcZatu+VkBToKaffnWDx98UzFEzu09yfntg=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 18:59:26 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 18:59:26 +0000
Message-ID: <77c3208e-6ee9-477d-b363-0baaea584ef7@amd.com>
Date: Wed, 25 Mar 2026 00:29:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: willy@infradead.org, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324114720.864478-2-shivankg@amd.com>
 <d5a1a533-cb79-428e-9119-a701a07ff4f7@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <d5a1a533-cb79-428e-9119-a701a07ff4f7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::9) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DM6PR12MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: 319cc131-9640-42f4-f12d-08de89d77815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	ljmv+nzwkyMBe3O0onEOAfbYeeZYtzeu5wiBTCYDNYWUl1MnM0tCnCM+HTEjsu5pQUpnNot44PHcuhHaJD0ZeqRSWxVKEk1wUBe3DWJdUiTCwtZoXp38V8ovt1gqN5FBv9URRiSJjUsUjXOsjiTFl4f/l+PvFrGohO5VTFMErSuIzC9gHekrBwBRXoC8+d+Ch5GqrEuaFgagA/UJQxfURMdd0LRr/M3bVl9HwOhOFQhYeaoNKDylvDZk2QIK3tBw0qKFzqQiqKcpbJy/8jJBO8bXXNY+7Yynow6qe9gqBbR2pEsTD7+hm7Za3MY3v9ZaNaCD4+agetjA6V2UZGMWp3NBlGbLIVLnGwkiMbM41RUbmlzUnYRwjArAVkOlil6tf0aUFeAiBsPkd7hF74/u3pImJds+UfOBRUWdOXaO4QBJocTLLAOvwiq0BrxmJFWYXutWvjDvbEIqxIe8wYGQurDaxlr30z7k3l3nkp8veCUn+WPjHzFOm1BnATB1n9Sbfhw+UZjTZXpOIz0tgD99y3qhGMvfpI2GSSztwoHQuHnEu0dVA8mymSeU0IpSJUr++aQahSoW72ftNrR6wCO55HzmF5w8CfMRdsu2F1ehTAHSkgtzLG4urnLChoJHYmjdfuPy0WZVCgZ91qeOizjQT+70Z43f3djtVJFJT/kiIQghYa5Kbp2Yaqqx+FaML9yhw+TIW787QkL5pxJLpWAV9dFQQ51XvfT2fIAh37WEgjUklZZv9YSIrftX5lJf+ua0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djBRZTlDcFpubUkxU2orbGx4anNaRDRsU1VKTXBqNnlhWnY0ajhWTVJ6RFNv?=
 =?utf-8?B?WXlHcXZiVVdwMmtoTUdHd3ZDWWNPZzFINk1WRHBUV1B1bzMxZ1U4WlZOdnYr?=
 =?utf-8?B?V01ab0xYbjRjM0tRUW9CMmVjZFVYeVFpQjBsMEZGVnNsZm9DZ0RLVzl0SlQv?=
 =?utf-8?B?cEdkbVoxaTdmTWlJckFFb2ZiOU9Fam5BTzJiR0JteFZaRXpKVG5NN3RiY2dt?=
 =?utf-8?B?RjVkNmdRSXZQRmZVeGh6T0lnU1hJSnRGSzZOTVJuVm9vTDdSekgvK0EvemtN?=
 =?utf-8?B?c1VTTlg4eWZoN0tjZldhWk9aOFUrSGUrS0k3eElhc2lVM1FHeHhFd2dmY3ZV?=
 =?utf-8?B?QTkvTWwzM0dwUmJ0UEdNbnRhZUtpZ3owTVFTYmtRUlorZ1VkbVZFWWlMd2J5?=
 =?utf-8?B?TG9CV09zTUdrSmsyWXExRysvUU1sV1NqN3BwUEUzdFN4SEVHZ0Nsa0hYRFBs?=
 =?utf-8?B?MjF3Titrc0JWQVdXbXB6SkNPUnJKV2ZrYU1GbjdNNTRJUGgybDJnSkxTbWFS?=
 =?utf-8?B?aVpmQVZBREFkRUcvUm11THRWK25BU0dyUGJnWEJld1dYU1NqQ091SGkrWlpV?=
 =?utf-8?B?VVdBdGxwTEhlUlFBcTIwc0Q4M010amlHNklSL29QT1M4bXRGVTVqTE5pVXlY?=
 =?utf-8?B?NFZxN1VIamx3aDYyWmFPN0dXYnR4NVhweXduLzZFck1reGQvbC94RzluR0ZR?=
 =?utf-8?B?K0d3M21tckQvZ2RnZVN1Z0NtMXkvZVZOSHdpT0lZS2gvUHpzdWE0aDdKbFdP?=
 =?utf-8?B?dXJHb2krMENLWUo5TFlSVWNFZTZzbEhjdWdpVFhGYXRvYm5KTXFlNFdBQ2tK?=
 =?utf-8?B?M2ZKd0pUOVBGU1AzWGhuVlFOekxsSC9UQ25vcXJvdCtOQWx1MWdGU2hLcHNN?=
 =?utf-8?B?N2ZvRnBXN2FvRkZjNHFJVEdqTmdLYnZ3M2RJN0d4cXhJeGQ2aXVsU1ZnZTc1?=
 =?utf-8?B?N1k0OEM5bjNMdjk4QXUxWmQyNEVFdStKSnVmM3FSU0gwYm5lOTlwZm9ZUHRP?=
 =?utf-8?B?NTVqaHRzZTA4a0t1Q2Rya1liUWM4KytpTUpPc2tRUWZ5dWptRjRlMXAzeVZq?=
 =?utf-8?B?dm1TdHFnZkFWQmJ4SlFhb3FOdXBtUSt5YWJUQVJjNGxndDJLT3FtQTdkQW1l?=
 =?utf-8?B?WHh5dk9LM2YxaitzT1ZGL3p6cm1ja2JtcG0zQTRRWHNWUVBhMldiaTRUZFpl?=
 =?utf-8?B?bUVHdCs4Qk1ROFBaTEVuUG1pZEhrbkowdzN2eWdMQTZkbHF0Wnd0WGxVMytU?=
 =?utf-8?B?OGMxcGtOL1VLQnRZeTFNcml5YzFVNXN3by9PTktqbFFiVzJrTHQwSG9zcUFz?=
 =?utf-8?B?MWJZZGQ4eGoxalU2akVKMVdVdTE4VFpiTWF4SG56ZXY4VE82cWo2UU5aLzJr?=
 =?utf-8?B?WGsyVXNzK1JEcmlacXVOOUwxM09PNnl5Tk5EVlh4cThuU3NSL05aOGhDa2NW?=
 =?utf-8?B?MEVZdnh1L1I5YnFxbS9XK09aUUN1MlFRT01Ob2I5MFdyMXg4ZWpMSDh4bS9y?=
 =?utf-8?B?M3FpTVNLZVpMOHVxeGRSZXBrci81bytBUWpYcHcyMzltNzhBTVJEVklMcUZ1?=
 =?utf-8?B?ZlMvQi9PYlI5dk9DMUdqU3VoQUxoWkl5QlNWbEtFL05oVkhoRU82Wlp6eUhP?=
 =?utf-8?B?VHovdFZyT09CQnFzYk9rMTk5SHZBa0NzdjM5cDRCalpPOUloZFhrcTdNbksv?=
 =?utf-8?B?MklpY29kYXVqSEkvUjVUT3FaRjl6QUEzYWNFZStuQkVhY0sxOTBnMFNnUnJ6?=
 =?utf-8?B?NXBNYk1LVG81TWUrMlUwVDg2WGVlMEFqRkZEZlVwelpNVlVlTEN6T0hrTzd6?=
 =?utf-8?B?UVU2MSszT2NkNUk5Q2xCai9TdnJPRmtWNDlHbzhKWng1UUQ4dGF4K0p3cDBP?=
 =?utf-8?B?bnpVYVFKZ2ZGT3haVVBYQ1NmKzRlUGZVMXdtalo1dzVQYzMvcUhDYWtiZ1FT?=
 =?utf-8?B?UU9RenZ0L1E3WmxiTFhCU1poUkNjU3NyTGRUYVlaUHVPWDBEbFpKaG9VdHJJ?=
 =?utf-8?B?NUJrbDRTL0x4R05HL3B6NGwxb1lVM2lQeFVlNmNFSmIzMzFkajRNLzhvSk93?=
 =?utf-8?B?RkRudi9ZTkh1WW04cWxaeUJhdjJFNjdpdW9PMm9manBDY3B0b2RXNndMV3dK?=
 =?utf-8?B?cXJCVWZKWHFMWjhhZ0ZhVnpmMVRRaGRMUEFyeWw3ay9QY2JsRnlhaWV4K2d6?=
 =?utf-8?B?OEFVUGlOaEZoNVlKMW9oZGZnbG1zb3JuVUdEZmd1V0g5Y3BRMlV0djIyQlVx?=
 =?utf-8?B?bnRxQW5BU3RnM0tWbEJSSmRyUmlvak9vQ29lc056ZG44eUhRYVQ1WFA3Y0d1?=
 =?utf-8?B?MzczRkpkSi9BNy9YT3J6U3RSREhQaWFjTVRWQkFTQWcycHJ4cDhkdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319cc131-9640-42f4-f12d-08de89d77815
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 18:59:26.0312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzQKD7vmHPqtj40ksL9y41nqhNamcNqEvZj6Cc3TxK8T3CbiLUCSDZlQb3MiYZiIpu8nsUpibW+CEb/bL7iegw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220
X-Rspamd-Queue-Id: 65FA71C000C
X-Stat-Signature: cdusi4m5xwu7cibncjnajism53ecaru8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774378770-998125
X-HE-Meta: U2FsdGVkX19h/Dk4QUchODTCAyQDe8vSBZSSqPFJvJenpbJ5EyMQHFYvOdr2dgBx+p2+RW97Wb9GKerbT+E1/ojpSPJSsnKMinxxo/ypFc542Zk4ZApzx3K+WUPp11o12CagPkHV3bQ/nU4u4xB82lPyE3DUd7L0WWj3sPrtcpdsTzmZynGYmmBVj8pAxFidN/h8NwLw4QNfaK84BpEGvDM85c5Bw4TWU3WYQXa5Clgz242kAJmpcY5qRyVe6usSdN+FCAXXm/MaX0L1kpGANe6RfYAkJ4gGUOf8B+ZpNbCaxjLHdLn3+ML/H18vJgWC4vQ02lLeeXsBIXkfs0RV1ecvtWKw18qSjSd8+xLDQudu7xkpXM61VjJl+pKrrlH2qLD3CdE5ZQW30+SDrGq7lDss9uRW1xKQdVaXjSCE3BqwJFX4qBAXNc6e7oRO4g5FlJre9m9GJ656vi74n4Ok9kYsOFrWY/kNKnxlVUnhg5Vg2Wn18V2xLn4jzSnOJS/fNXcy3R4XVhaBd5D5bjth77ZzCumP2jdtSk4JaG0a2OjqfNMGNySp8IFC1H9nAk8Xeapd09FymKhq0hE/XMyMq+bCn9/0YaDkVPSYPM4NclyT2xHhghaegT72Q5rFb/sc3sLndU0S2VIYH0rW4Nom5AP08SblQ8gRNFNvy/2WVCYrVtsBsGLIS96uzFZEdcWmQDQ7A7znzM6xiLv0RbEXDFrBqNo5rdRB+AnpEMgaNZHDJN0dHpWJXQh/F1IbSqE1ebAdqOjaIimfiWAPznihlo536n+Nb/lbUvckCp/8g29sn71QfsT9NxHErpZiDiWLVpLXst8FeypPK+Vdrz0T+9VYZqqx0kG1NFnYMhGQrs1/UECN0SXE3ve13fRbWGJun9vyb55rCd1yz/kWukrgkntbneIZ6hfueWesP5ucS8Jdja1DNQQcNWWz8JzlBxk08PI/UKECM02oG4g3z4R
 G7v2JshZ
 N0FVy7f26Z6+uwe0avQgndyNfOdjm4ik6OoPvse5mZVocPyVyLOdlJT86zgSEzQZntWTZLPso+EGB31Q6+0mRFO1GAFPqEIrAaadEv2oE5jhqmWb/RfNkWgoeFKC4hM4xBYJNsAokc8S+b0p7BZuAS0l4lLmnm804FwmUI7MG0/t2NaEhoNwZDMh3T6kst664//HABu4e/4WilUbGm7IRJF0QwDNOX8ItJlsO35duUYGlJXfT1ksvYmeHCc4Yh5k5x/PygkK6gjWELoHZmaOQ2VmSknURzASJ/ZKRRv1nU50qKK1JkcRK+RnXnhRfWA6hGVhPw+28sMZ+w7snlZpwt/QX4nWlwK7sziXMgw9YzNbFtUbaivELLkuJ//Epn/bfHzSmU/R6qtTuzTqE+mhF5NL9+o3sQG4+NIxDUZm7q9nGLrbk3Ld1CqT/2sOSTFEObxj6/s7etfkjqtyJxA2OzX59eV57WmGgig7vgOHpVwMDZmy0Wsb2/HlB14SSqFJorAqAjMKoK0n8JsMRLoBbN/o0wS/L/QKlDA4jC2zMDhizq5i4ocilZUDSerN9BgGVSdBw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 6:01 PM, David Hildenbrand (Arm) wrote:
> On 3/24/26 12:47, Shivank Garg wrote:
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
> 
> While at it, you could just use two tabs to indent the second parameter
> line.
> 

Sure, will fix this.

> 
> 
>> -	dst->private = (void *)anon_vma + old_page_state;
>> +	dst->private = (void *)anon_vma + old_folio_state;
>>  }
>>  
>>  static void __migrate_folio_extract(struct folio *dst,
>> -				   int *old_page_state,
>> +				   int *old_folio_state,
>>  				   struct anon_vma **anon_vmap)
>>  {
> 
> Same here.
> 
> 
> Thanks!
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Thanks,
Shivank


