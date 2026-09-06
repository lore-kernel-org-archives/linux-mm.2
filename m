Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7424C624DB
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 02:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80EA26B00B3; Sat,  5 Sep 2026 22:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6186B00BE; Sat,  5 Sep 2026 22:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8946B00BF; Sat,  5 Sep 2026 22:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4261F6B00B3
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 22:30:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E05A3A477A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 02:30:27 +0000 (UTC)
X-FDA: 85181758494.25.8CD6D3F
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012068.outbound.protection.outlook.com [40.107.200.68])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1DD9380004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 02:30:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=G7JJE+SL;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788661825;
	b=Eb8VAGnE7auYRl+JpeC6WvQ+kb68Ie7xQxJPrpZAFOg2zmiGCQbMKtJEh7aiDst/hAJ1Ff
	kCh9YtgqZNouCopnoLiHrjOd0PTYHa75kKsgOH4zLslkIgRQZt0t6rcE72UPlq2ijhCGBN
	+MP63vY3JZeV4AAnaBauezt6gkkZWfk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788661825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2j2rWZUHpwqZ3nOIZOLTN8lkTfKf83rvOt8GfOE9g1w=;
	b=A2gFTVTEYmgZg2onAlU3zo2JKD8NdXEcWJ1LrhV1zrEyyKE3iZ4Ke9rxN7rNtXmgdLToYg
	/a59C4Wgq8AW9gMBnd+xFwPYXybeTD1itrlaaRcVDPKfpSLjJXZJk5XEwUwyYbq9YirqTa
	empsr5ik+2o047d8Wa3Qi9nZBQ3JuYM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=G7JJE+SL;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXkWqbIJoXV/qgnHRLFG1p6vVwS+yD5eEc8wPlHk92UOtKpvYcs2dtYzPuTpEFziI4DQhrIWW9AwZyRXKOlSjntNr90e8Kxx1ZibtwMi37aAPk1kc8JNitEE8pXIaID8u7tpnfldy11IDB1LWbhnK6ZBe+WsvbFisPPj073MsJ5bGmuRsVrnC/B/VLz6etSUoYtSt0n9kRy00Wws6K/rawiTUyb0lnXI28K4USaD8ibWFP8n8d9+1ofvqP1NCxXdiyG/S3C+lJpYBaO9YwylHxcVs3AlukJQOHC5RsT/qchPUzcYoCkuJ7XCnfnUoLAUr/RWaeSoOW1w1QS9jHCOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2j2rWZUHpwqZ3nOIZOLTN8lkTfKf83rvOt8GfOE9g1w=;
 b=blmJvqfYiYAi34RajiF9M/1QRm0e30WCrmlS0hBKanYbpFZyU3+Csg/aqXK/u6ZJYp+ZDgnfW6MScY6EnTkdROVRGvl+A3WmpSMv2WzYjP2JMa6ERZeSkBETkwFDXOec90Y9Ruzd39Zw8JLYIAZ9pTG6j/hSgFnEwTrrN0gDwi1TOm1fs67H8IL2whceqQxYXLcGHQ0OCv4/TWN7orfQKOrzsSwftADSiyufKzoPUNWRqxXTZHWsdRTxh2QnURmiCMvqTPzZdd2pRX650A0xfAOVNvmzZK4wjVwjwBpSoKyJsD6z0tz2iTUDmYh/IvAYwWoOMsCYpScabf2QcxiBIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2j2rWZUHpwqZ3nOIZOLTN8lkTfKf83rvOt8GfOE9g1w=;
 b=G7JJE+SLohJCFCqdrxm5RWsNX/e1C1RB1qv/Jym4Pgxf7ewXat1yOwKh9qa2aGfQzsB52+4tCL81a6Dqc7pe5e/B0KyDi0ey1w7qOE5F7ujWbh77wH3tbzPrr1A/WD5+Ec/7jrUAbSOCUMdWxI/aCWb6I1AFJ6Vdz9TrVHgy8KJeAWBstZRRi4qgr+4PupduWuvC580K0FqpIz39rFC4WC4B7VHgAqKFwaHn4zt0dIoSHXdixLpCkU++Lu0OhzlwTQQvW5Z6Dtshey0QkYa37tphaZRZ9+mgD8xegkhsaBzOyanN6BV+QMoOkj9ZwNPQXP71ktg45KqrUlgf+YY1BQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB7536.namprd12.prod.outlook.com (2603:10b6:8:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Sun, 6 Sep
 2026 02:30:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.012; Sun, 6 Sep 2026
 02:30:18 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 05 Sep 2026 22:30:16 -0400
Message-Id: <DL7VP2ZBCB4J.9NUOEM7GWXR6@nvidia.com>
Subject: Re: [PATCH 08/12] mm/collapse: separate scanning a PTE table from
 collapsing it
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, "Nico Pache"
 <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain"
 <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <cover.1788533997.git.kas@kernel.org>
 <1a1bc537850bd7ef73bed5ac4985634bb8dd95e1.1788533997.git.kas@kernel.org>
In-Reply-To: <1a1bc537850bd7ef73bed5ac4985634bb8dd95e1.1788533997.git.kas@kernel.org>
X-ClientProxiedBy: MN2PR20CA0037.namprd20.prod.outlook.com
 (2603:10b6:208:235::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB7536:EE_
X-MS-Office365-Filtering-Correlation-Id: 91f6d1e9-68c0-4e60-9754-08df0bbeca68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|6133799003|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9lZarknxa50zgLfK9m/GgFpp8LDnHvB4JDubKLb20FcHeTo72nq0DrXB8E64w9lz2Du/m3ZllDd68W6FgMsiNbLnqRtQiIeJuC9W+AFdsZyNwYqs6By0ggH87yiOfoc1kSRlQIFwHqc4qx6tBe05wNyKQ6qsY+qxrXvwrQMKWslZQNsjqM7ydOuYOxQGGsBmmgUhg0x4+geb77MgctCXrm/ZoYVqt/ZEK24o86l8AM9QNwapFqGE8XQ+klsQ9tO0cNmLpewwbY9N97/tR/WO9jLyu/XOwWrKV6Cm3uoD6bsjZbBIoktGYiJcMkCeIVAEo+aUW77y8g7oAqV2QczofzHzh0mnfAe8FZLdQt0lghRsqH/rbyZDy0juOzbsbVhcYlEBIyQwGAsXWCt1+Bx6XwWhalGTcfR1pujybybfl4W9FFeY8YVVVOmH0WvAhdhyrLqVoX7vD42CKxw6zggrjq30MOVKFsgswjqmhCTaenc8S8G9HlbGxgyW7lhWm5nMe3h39VOLwq+8EnPg/ZiAP+MVSLAkYT36XDlRM3Hra91ROEHkWROhQ1y9RqGJ1fih8zwk4DTEY760MyMEZLTAhU/ga4ynEXZPXjdeCj81znb3PS136vW4YWR/T6J8gKgJCOhU3boYsvTBYkANpNxMhp1eIuTuNnVlCYtHiCpSuO8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0w1empEb0x3M3BUcmNsak4ydkFMWU1VQ3JHd2tBZVp1UW5EZTcwWjkvS1M0?=
 =?utf-8?B?NldXSXk5VnRWUXUyNlhWajFDcUFTWHJKNDNoWXhxNjVzYVpLald2TXVXV0JJ?=
 =?utf-8?B?WFdScGpJaGZscFpHV0JGZXhaRXNTQUJPWWtCRUxTbHRwU0MwRnp3NG9oYnRL?=
 =?utf-8?B?Y3FyeUZremhTQVUzM2JPaFhxcTNYUjhLdkxoUEVwZDUrcWk0SFdrQlZGZUZI?=
 =?utf-8?B?QW50YmdOcWd5NXJvT0JkWHUwLy96Z2NhVzB0RFR1L0tjTGtTWjdvNm0xMDhl?=
 =?utf-8?B?MnMrYW8zMHNvbVhyRG9NS3ZmMTIyV2Z1RXNKVFhyWGFHYWNPcmtFb0hIQUhw?=
 =?utf-8?B?cEtnVUNSeEV3TjErK3RRY3VENXhLNWsrS3B5VVRoVC9xd1crd1QwaVo0NnVC?=
 =?utf-8?B?WktkUTc2THgvanRRNEZneERmMjUrVVFzZVJzUnFKd3VuVVgyUkkzZURuTStk?=
 =?utf-8?B?ZDBWa2VlZ1hUc2tMbnJsWDVvaiszSkdVVnI4Q1BnVEdMbzZCekxSMC9lTzB4?=
 =?utf-8?B?ZG9jcS9qL2thb3V5QzE4S0NvaEhqNklDWXphL1pYWUJRZXF5WWI3ZFpMUWF3?=
 =?utf-8?B?d0xlVmtYdHZXWjdVNUlaSGcvZzdJY0JIaUt5MjU1RFVNOEY5WEk1dDZXcC9i?=
 =?utf-8?B?UXhhWnRMT0RjQ3dDc0ZhTUN1ekp6b0hHUHZldG83cUpIcW91N1IrTW5oOTRl?=
 =?utf-8?B?eFNyNENITEJKcHdqcDVIRi9sZzZXVTVTT3d0R1NOU1V1SzdJemlBYjdRemFM?=
 =?utf-8?B?R2YwZWljMEt2VmpRSWNOQTZBck02Y0ppRmN3VHBOZ3Voa3hBZUdXSG8vVmdh?=
 =?utf-8?B?dHFUVEFwNFhkQlJldS9xZ2dNUjBBZFptS2N5OG1EcW96NWtZSnE3R0FJdUNZ?=
 =?utf-8?B?Vk81WS9qK3FrTnBqU1diWmtGV0dvQWJOMUJ5VERkQXI5clZPSmthYUc4aUF2?=
 =?utf-8?B?NUtZVW5xUmF2ZE9zMXlrTjZwaHFCKzR1bmF5bTA0VDZieDNPY3NpTnZHTU9p?=
 =?utf-8?B?NVU1WHV2QWZMcmxsSFNrL3VaanUvQ0ZVc0VEcXIvbzhmSHVJdVNJcU1saFk4?=
 =?utf-8?B?UlBDakNZVHdqME8zVjNvRThjUjBwbkxHelhhcXZyWDF1YmtFOFh4NHU3cWdm?=
 =?utf-8?B?Y1ZuTmJpSXRmVnVxQWc1RDNqcXdsOVNSc2UwbmFFd254SXFxeXpzY0VGMDdW?=
 =?utf-8?B?ZG12SU1TS1JoUjRSOTcyYmxlQURxd09rL2Y5K2Z1U0NiUGZVUXUveEE2dDN5?=
 =?utf-8?B?TmpQRXBPbFczMVJldXc0Y3loNys0bDFHRE9wUXk3cGtGcmNTSnE0YWY5VXRu?=
 =?utf-8?B?U3pOejNXelVWcVNTZS94VEVjVDZHeldXWWdFRUt3aXRiY2kxRmRmeHhza1Nk?=
 =?utf-8?B?S0dxb25jSnQyN0ZRUHh0Yko5TCtLYVhWQ2dnMXQ3SStrNmF6OGZoTDN3Yk1s?=
 =?utf-8?B?YWdiSXBXVi9kSGtxbXZaQnpQTG9iVjlvbklyRXNMNTJXQm80a2w1Y3Brb1kw?=
 =?utf-8?B?amJqK1V0azhyRXE0aHMrSGFBcThPS2liTnBXYU83NXhPREZFa1JWdzkxYW9V?=
 =?utf-8?B?MlkxK0Mydk5TaTIrNiswUEhsVmxzQ0NEN0s5dWZ2ZisyQW9OcmRRTVFNUFZK?=
 =?utf-8?B?Ukt4Q2hvS1pGbFo5NWFUcVJUK2pHS1lQbVNtWWR5U1JGdUtHOUFYYlljQjhP?=
 =?utf-8?B?ZTdRV0VpYXRRNUljcWUrcEorWllsK0ZWZmRIdVR1ckx6bXVoS2Z2Q05sV3Q5?=
 =?utf-8?B?akhhRmFOZ2pJbmNIckF6YzB4UEc1UUFVOVErdlUwd2hLK2MwWlpUc2dyWitz?=
 =?utf-8?B?RFZHY1NpMis1MGt4NlA4QUdQeTBNeGZqM0dVdFIyTCtHU291OTNDdy9QNzNn?=
 =?utf-8?B?ZlkwSFRNZmVLeSsvZEd4bURuQ2Rua1JBSjVJTktaUDQ0OUFGdHdlVUF5enlo?=
 =?utf-8?B?U2VWdWViUTI1bDN5Z0Y3azJMMXJ0ZS91YVlaUkJZVXZXWFJMM0Z3QWNxaUZo?=
 =?utf-8?B?cndBWmxKa0IrL2ZoVTV5WERLR3pmZ3ZzeDJMK2t3cHplM0pTaUNFOVRCTUJa?=
 =?utf-8?B?RjhXS0lhd1J6TjdwOW9KaHAzTXNFdDdrWFloT1RmUHB5ckd6R2x3ODNLTWhw?=
 =?utf-8?B?NkpIcUNkcE9GZmt2VmJmdXBXZzVQaDRiZm5HbTY1SS91elcrYm9rTmh4bU1M?=
 =?utf-8?B?TjdUNjZTZ1dxNWpBVjRTZkgzWUppUlJhYi9Nc0lXZXZNaXgrQ1R4ekI2SmVu?=
 =?utf-8?B?VExNNGFEcFRuUzM0dFZpb2JhbFQvZHlwWTVaaDVybGJEVUN5SXVXUkN0WmJC?=
 =?utf-8?Q?xExpTrI+XkbbrDlV9E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f6d1e9-68c0-4e60-9754-08df0bbeca68
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 02:30:17.8828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEWO5DBGKHFtvCwBBDZHKFjRG8/go29G0fziToX0eNXH6ISVLj4LO+NbUy2f/dCi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7536
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1DD9380004
X-Stat-Signature: h5857bow3dxkxkfp61osai83tosd3her
X-HE-Tag: 1788661824-899289
X-HE-Meta: U2FsdGVkX1+AgVUIGDRNUhWQmlqZIY9yqWNe6yYrlhcurAT/TjyIJJHPrbKVvMMra46FgPh4UwAnxyOlXGBPGNJ42yI6G8GR52WfWlTTs2rvSuSY9l5oaY+dryElKxWdAlaTSsEkqanCFwtfVc4dINIqkUHvkNJB1Oh2VzuDm6DvlDTJA2SQi5CiPrXSy48x8vw4eaCxOvdFbNlibcmR9fLFpk2liu3FZwZaSv6ogK0KZTabD0ljKEtYT09LK/hX38eZrFXRekOg7XDAhYuS4FKM8iW8VHUpKUJ2F7fEvh7uMfIlNeA82/QtDGZ8GSUN4F6Yy0wgIQYO5B/cykwWuVq7DloryWddh7YAFFHNl7nyc9K0IaqS/KKgpfasQmD5j2Ui/APStPJt4A+kGDmuUVRgQ0RiAVVCL35KStSXIyh1aJ0OUZ+JdKX9Iec5u08SVhDWo8EnswngF4a5HbLyDZokLPq88FRF0i3rlmZIZPPrE1Q8kOfvTGn3WvNHsgUt8KgGY47BzU9eCV5F7m8+IafWvJSvuiQkTFGiXqnVFF/CFLqX3k8wn8n0st9fDzQJCxbHH5PJWamsCF7i6STS42Qz6bamNOGM6YDx8K/aMBMNYDhf4zyfuZkMHDP2RSLmPx+2MQiUvE6FIPxNQWVxqsOXSd4VNnvqKMzeLLZu8fgeb/TYioHYWNm8Q1SNJqKGRfH8lD96YL1UjuSFnFmnzBF3Fwc0BjJyZvccdllsOK2zn5qaxUgJeyyURmmwSQ6R/YJnN1iqJbBCgo4i65W+hb08MkAR/0PvbKn7mfK1L4lJopvgoKukWI8S/gVnt4OBfJK6bADinIc9Pstl+eruIxOjQZZWT+ioOGXoJkyHRBvUAuLVJh+qPMmprV/CQJt1X83NJvykYSfRKilykfQbi2bpSRW1FbGsG6Uy1lJdRSLe5JDi+et+YZQQms8bm/Cej7oTbJ28if2vhoOB9Yd
 AxpigFZv
 gqHgwBcQZbAM+1ysvA/O2jp4iQmi4kvigmzKYRGaSCwz4qRqHy5CLjEFyMHO7x9t+LbLNOvCoVZURK6aEPHL9e6ZPeHQr7pjke+SsENKpahDCvCnB86c/trRhKnsjWNigHINGNcAS3mCIKcXue9ghcIvpRdsFCqbIx33e4vEoTni/plhiWzdB5LehyATn/g1+oHXyt82+pGnBZkcu9lMX+/bguAY6DBYkpVRBaWyXkH7Uc7APPOL0x5zsJPgWyPLFdYDyD3xJCX0NRdA0Zo5IZ3JotgWEt6hBe7DvciBa5igwGWwEDmcgq3daFG/SzQVqb49VpXM5P59vEa7Y7SpjS8C1mLGCZIcz5AE5WKiQeEtMOy8ZiJvK4GytcRCmkR4NYPUsqLeZl3fP5CrIQ0yvX3Ly2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 4, 2026 at 11:10 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> A collapse is two jobs.  One reads a PTE table under mmap_lock and decide=
s
> whether the range is worth collapsing.  The other allocates, isolates,
> copies and flushes, and wants the lock given up first.
>
> collapse_single_pmd() did both, so the boundary between them was somewher=
e
> in the middle of a function.
>
> Give each half its own function:
>
>   - collapse_scan_pmd() scans one table and only reads.  The anonymous
>     scan that used to carry that name keeps its body as
>     collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
>     that picks the anonymous or the file side.
>
>   - collapse_run_pmd() does the collapse the scan asked for.
>     SCAN_SUCCEED from the scan means there is something to run; anything
>     else is why there is not.
>
> collapse_single_pmd() is now the two of them with the mmap_lock drop in
> between, so its callers see what they saw before.
>
> Scan results (beyond SCAN_SUCCEED) communicated via collapse_control
> structure: the orders, the referenced and swapped-out counts, and for a
> file the file itself and the offset in it.
>
> A file collapse works on the page cache and never sees a VMA.  The scan
> takes the file reference while it still has VMA and the run unpins it
> when it is done.
>
> Tracing changes with it.  mm_khugepaged_scan_pmd now fires before
> mm_collapse_huge_page instead of after it.  Its status field already read=
s
> SCAN_SUCCEED for an accepted table, so what the collapse then made of tha=
t
> table is mm_collapse_huge_page's to report, per order.
>
> The two calls to that tracepoint become one.  They differed in what the
> collapse between them changed; with the collapse no longer here, both
> carry the same arguments.  failed_pfn is set only where a PTE was refused=
,
> so it is -1 exactly when the result is SCAN_SUCCEED.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  14 ++++++
>  mm/khugepaged.c | 121 ++++++++++++++++++++++++++++++++++--------------
>  2 files changed, 100 insertions(+), 35 deletions(-)
>

<snip>

> =20
> -	mmap_read_unlock(mm);
> -	*lock_dropped =3D true;
> +static enum scan_result collapse_run_pmd(struct mm_struct *mm,
> +		unsigned long addr, struct collapse_control *cc)
> +{
> +	struct file *file =3D cc->scan_file;
> +	bool triggered_wb =3D false;
> +	enum scan_result result;
> +	pgoff_t pgoff;
> +
> +	if (!file)
> +		return mthp_collapse(mm, addr, cc->scan_referenced,
> +				     cc->scan_unmapped, cc, cc->scan_orders);
> +
> +	cc->scan_file =3D NULL;
> +	pgoff =3D cc->scan_pgoff;
>  retry:
>  	result =3D collapse_scan_file(mm, addr, file, pgoff, cc);

In the commit message, collapse_run_pmd() is said to do the collapse
work, but collapse_scan_file() is scanning, right?

It seems that the code only separate anonymous scan and collapse.
Why cannot pagecache code be separated in a similar way?


--=20
Best Regards,
Yan, Zi


