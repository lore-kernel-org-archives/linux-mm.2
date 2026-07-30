Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA830C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9613B6B00A7; Thu, 30 Jul 2026 09:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9FC6B00A9; Thu, 30 Jul 2026 09:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D456B00AA; Thu, 30 Jul 2026 09:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 349606B00A7
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:40:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A047E1C0108
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:40:28 +0000 (UTC)
X-FDA: 85045552536.18.C1C03EB
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012051.outbound.protection.outlook.com [52.101.126.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3FD6220009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:40:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=ldDTJd6H;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen@vivo.com designates 52.101.126.51 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjKBmC5bi6DtcVbhzDHO2yH4oE/Tk1C37Td6ilVAKxE=;
	b=PnJCYLtnholUoLsh3kkum1/HUQgeTe5OrRZI4iuvfsmBNVJ7nIv0LwIthQpfBCm4fIKd6t
	zpIht7S46OC6SKzV7KBbhn8fpqu994/kAw+8KxdFa4pNEx+IJ0QRzbaiUQQHHhkyFvVYjs
	1spZP/38et9sRruHXlqC85XzOAq3hz8=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=ldDTJd6H;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen@vivo.com designates 52.101.126.51 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785418825;
	b=YJkeKCY6IOkFsO3HcoV+VUFs+MtseWs5aiXACzrPP+LwJmIfs1WdSDWhyeQ5uBwZQNu0l3
	rVFpifL9MhOwGSoXQbwTOBtyhgSKO1pleZQFs2dSbEHyj8RwgFZPPtrjQ5f2WE/FqJ88sN
	cZY8OIFmPhfH5hdfQnsQgPBbJe2Ylq8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lz/5hzVVfSvnkzkYtiEBuJ7pikHZJdQNeNYKSjnkerRIvIbnjFqgBaeRFWUIs4z1lZXQDssMWZ7ZZHrGh5XC56x6hVjmOGn5BZJu8bMknW0AwC+kXAnB8aFOGFKOER/fPQO5eKaRGnF/OM7LvMEpeSp3g44328PPQyrg8blTT+G+LyuXD+mXE2oS2dejLwMqo2MB3cozifQdCaT9nERLdsVBmiz0PwHspQisprMt94Lr1CB02W9LPW/Lv2LeDOQCtdjxTZ9QixQImKWCAixT5c773wAoBjAXbu1P7cAPwbgrQbSy7/m8w0WRCcW1LH5AgSZz38GxaCmwY65rqlQqtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjKBmC5bi6DtcVbhzDHO2yH4oE/Tk1C37Td6ilVAKxE=;
 b=V3bsjdKE+9WiT4SMD6fPMuylxoQxHcz5+v25SR85YwsrhwdmXR44PsE8YmJjvcH3W5lIuA6hfM9Q19WDDWV43fV6PqNVeHMMtCA7fKXA3bWRfSPcw0e4c4ZGkW/abS3Ti6v+dOqh2DPECE6EZsnInlYdsUeuxr4FV3BswPNm5cGuf8pcnzmxmBQf1Js5aNyMg9Yn5LMTTqK1HfSGwXIMZDytL7fDRO/wcyTqMZAxSTdco7sarYrxbYAQ1AJk6PL/cq+o0ucuIQVeDwB/zyQ1cbwRoLRq1mV/EAr+qwQGb13wrj2Oimh0pKbIRCKChl6nsTMr0k/lg+2EWm0A/VW51g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjKBmC5bi6DtcVbhzDHO2yH4oE/Tk1C37Td6ilVAKxE=;
 b=ldDTJd6HmnZnaPFXUvB4USu70oir5AbEWgIeAkrOL2/eMLN8s4/z5GDcbppATIFi/N/bquvK/eHP9oK6gXrotofQLhDD9rG4sNrfl5AcRYVbJQb9cjnyHiP2fj2M6GYuSEw2YzwZd92Jt6cThlDYfGBe3tcPaqxpt+6LPlPLu/dACnGIaHWVia0NhLwmZkmIgYKpOsPHNvOnoAIuuoxpqtARpw25AzRTlKIXc4kEcXWFQRdTeQlSwMcB4Kt/TUrqJrjGYas7KoL3j529+KOKWNvTE3X8RKH7gwjXElRO7tAE9h3RqrLAc+ArxFhSdZYv/t0SR5MIkyYCsRzBesnL3w==
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com (2603:1096:405:383::20)
 by JH0PR06MB6480.apcprd06.prod.outlook.com (2603:1096:990:2c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 13:40:18 +0000
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96]) by TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96%5]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 13:40:18 +0000
Message-ID: <97d8fa18-cf63-49ee-8ed1-d7e55159566c@vivo.com>
Date: Thu, 30 Jul 2026 21:40:13 +0800
User-Agent: Mozilla Thunderbird
From: Xueyuan Chen <xueyuan.chen@vivo.com>
Subject: Re: [PATCH] mm/huge_memory: fix huge zero folio publication race
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
 Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <4ee89c27873fb4d9e598f8a5cfe71d700ecf894e.1785300563.git.xueyuan.chen@vivo.com>
 <37c40d62-51e2-45b4-9837-a4b96d1640b3@kernel.org>
 <20260729180241.2b8bcb2379b975b22c48d251@linux-foundation.org>
 <amr1tqBj9ec57xwa@lucifer>
In-Reply-To: <amr1tqBj9ec57xwa@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To TYPPR06MB8235.apcprd06.prod.outlook.com
 (2603:1096:405:383::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYPPR06MB8235:EE_|JH0PR06MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: 5100e7ef-baa1-4021-ff8d-08deee401809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|18002099003|22082099003|10067099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	9IMeyUUnKVlEUBKQjHSreNhL5rCGwaaLUEwgwWuHbuRvSTOCotGkLL7sqUagDZMr6N/hw5ziD0ETC1mHQ25F6leSheiSEsPewP3eg21jXPyyxO/o1mVkW0L3ix/zYoa87vMtACAQDD3VGiBmAz4X9ZYokxeq5OYVLikvA+ThI8YEjdRxiibEA8vbH+ougUkXBxsho4TowxFt6JbkyfEziNRB+aUnZee2/Ghi4fYZ6hp3Z00K4y42x9iPYT1OCYly40OGEh9fogwazklj/JYK6c6n8hs69gc9YWqKXPkno/MKeDhPxlfqtou/Ej05sub4x29+xkmrXXA9P59p6p9kiQscgKAY9PYFqe7jHy5lrsE+D5lvwXl0nhXX0PDNVKxCigHvddpxKPClPwyUKG6JmPmxpExQxMJVKAeaDMAgx+ebgp1wYu50q3VBapzU5uCUhCNJ7QEbgnGO9zZROwpZpEYYm/VgTi7tP47n2pvTjgqT1MLtSaYM/NH1ZK8+Kk1OQVaNDGC4msgkmDrAoeA/Y7OQYPidIvsG+8GN3nIE7Z2YUy9AWMiHKXJvOnH59H6+YqNCqtNUXFyJ9XUq4ew4mQBfMSS9tCT0ihY/pIXkOrY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYPPR06MB8235.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkZtRkF0d2hGYU9kNlFOWXZHcnh0dGtTUkFIcnB0K1phSlhneXhvamRrWmFz?=
 =?utf-8?B?RFNlMnFOYWU1MDJUUWk2V1lSOTBSOXdPOHpEeWgwTHlpRS9qMDI3OGE5M292?=
 =?utf-8?B?TENpNUVla3NaVFBqaUh5bWVOM2Iyd2NQNzNxQjdGUmlLV3JHM0tZZjE5UUMw?=
 =?utf-8?B?WFY3L05LZEZEdEZWVDlHWGJ5RkN4dk1NZkVDL3E0Mm5NL2ZSZ1Z6QU5mRUE5?=
 =?utf-8?B?bUdnbldzS21tcWxhd1VNMkphOHdkMzJEWW9HTkhBeURPdUc2QjdkeWV0M1BV?=
 =?utf-8?B?dFhBcDEzcjFLamJtUkV4YnJhNkMxL2E5YWFrRW9lczFTQ1B2RDk4NG9ZWjJK?=
 =?utf-8?B?SERkbjFIZy9pdVRSaHpCOXBSejlUY0JBdFNIWVFEK09pQVoxOU9WUHdoK2d5?=
 =?utf-8?B?YkVQM3FyOFFmcXMvMEF1dXczaG5mdTNqams5MXVyUUJHWDRoRXl6aTVLMVBN?=
 =?utf-8?B?T244cU9TYURxK0haRHN3eHdTUHlkZnBaK0QxODBCZkxVZVdTVGpYdTcxTFZ4?=
 =?utf-8?B?SjdaejFqa3poY2tCbUlyTllLVFZPK3dnb244RGdPSEU4SnpmUkxEQjlpOExY?=
 =?utf-8?B?eC9RdnhWalJzQVIxaW5Zb2RzVC84K2VNQzkxeW0wWDlBMUtGN2VnNWQ4M0Qx?=
 =?utf-8?B?U3U0ZERSU2xGaUI5d1ZnZlVtTERoejN2VEVhclBVSC84eVFOTTFXYlRxZVVU?=
 =?utf-8?B?ekpMVXYzYWdjbGhlUDgzaVRYQVRHMk5wNURlQlBqV1BkWGZDWDFkY2J4ZjMw?=
 =?utf-8?B?WTlDY1psdWZqU0FSamRaUTZFdHNkNC9BQm1OQmRETUNTMG1kYmtwYllEQlFB?=
 =?utf-8?B?eW9WdGQ3QXpoeHhiY1FSKytOUFhVUGJjT1FuZmowa2EyMUJ2Nk1vazB0QXNM?=
 =?utf-8?B?ZEtFNDRHZmZOOWhrVXl3Zy9KQzZhUDdrdnZOZGxSWUxtLzhpenFlSm5IVHVl?=
 =?utf-8?B?aGMxZnUzak4vS0lOYXJsUk5aditGUENScHNnT2dRWGtEcnRDVFNaQWYyVE5z?=
 =?utf-8?B?YmV2VG56UldBeUFnM1YwWkt0UU00LzF6ZFJKK2puQlhueCtheCsyNnYwaXEx?=
 =?utf-8?B?TDFyVHVMODlOMVZaYm9LOUY5VGl4WXpCc01OVzA1QUs5TWM2N3A1UEpDT2Vy?=
 =?utf-8?B?SWcvRnU2cnpEMUxzSTdVWEs4RXpQSFhNdkR6NlhqR0NaczBKYVNWTlQzbjQ2?=
 =?utf-8?B?RWJGaUNTMTFCYU9ZMDJ1OGdYZFVWZFdKbEhRY0VyZXVWMUZzdVpyOEtLQ2tx?=
 =?utf-8?B?RVZvcllTL3pjSk9tM2xNbkpPOGQxWldLcXh4dTNsUVBGK0NXTFhzRFg0OHFt?=
 =?utf-8?B?Vi9rUWExdjRuSjRPV0lNb0RXbUJRTWN3MXo0aUJuZG5HOVdaZjZ0b2UvaGFE?=
 =?utf-8?B?WkU1TjVjS1I4ZGt4OS9Ob2RuU1VwckowdXBLTlhkblp4aWxNVW1ITnZKTHR0?=
 =?utf-8?B?WDI2Um1BZXVLOGVJVG40V1F2ZWRTOFdDb2lYZFAxWXpKZnpaWFNlMW55VmZs?=
 =?utf-8?B?NExNbEhydyswMEo3RDlNL1Vud3JZVGFyK3o5UXJ6bHhPc3hqR3FHbTQrMHBq?=
 =?utf-8?B?L2VwQjkwT29mdkNXeVpXTzllMUtlQWZFbE0vaGpqRXFJTExZYW84SHZodk9H?=
 =?utf-8?B?Zk5hclNDa05PTE5JZlVMeG54SkJGa1FFSWVJSlFhdnJVckpScW1FQmZIMmVZ?=
 =?utf-8?B?WDJiSGtJdzNqY0QxWXNVQ0lXL250LyszT25tVVRXdGxrV1AwNmxCZTJaYWho?=
 =?utf-8?B?UjBkWG5CekdTaEFpdDRGMDFrMTlFTW9GUjNxWG1lSW9NRE5WRGxhTm9nZlBL?=
 =?utf-8?B?ZW5sbTJUWWNscXFrNStaVmVSZHNtZ0ZGY2k0a1QrMXEwOVB2Wm9GUTdDcWpw?=
 =?utf-8?B?eEc4RXZoUkljSlRUM1dGKytRYm1WUkF4aDJkb0lDMk50WnVNcHhlQ2krTHlo?=
 =?utf-8?B?b2NiSEN3NWI2VS9RVHFpUjBzVTI1d0lsNjhqNWV2ZFpBMTlDL2o3RHRqSDlv?=
 =?utf-8?B?Uis3VStqdm9JMUtGSmRwcm1BZCtvMDlVaXdTemJtUSt5b2p6SGwrMFUweTN1?=
 =?utf-8?B?T3pSbURqQytpcE9SSWhhbjFiR2pTOU1XUy9jN2JuSjFGaUxKZXk3QUlaTXV4?=
 =?utf-8?B?NGFXVGtlV0RmWHJsdEFVTzhmYVplQktNUU9jMUVDSVpOYUlpS0J1VXVKZE9i?=
 =?utf-8?B?aXNkS1NiOVFRT2dhbC9mUFREQURZbTBTL2cra3JNOEprOUNEaUtLUEdPcjdQ?=
 =?utf-8?B?STJDTFV3eFdudnN2elBCOXVIbzdoaVR6aHdUK2lFQ01YMjdWcnE4S3NkYllh?=
 =?utf-8?B?em1jdnl1bXBRRWdVa3o3TEpkRFp5MFljbGRJNDZuUVlWeUx5YWc2dz09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5100e7ef-baa1-4021-ff8d-08deee401809
X-MS-Exchange-CrossTenant-AuthSource: TYPPR06MB8235.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 13:40:18.4578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UXQx4AtsgBVy/dMRmvG8wjj7fwgii+kv6rhFMz9ReDOFwhKnIPchaACg3L96nx6F9xZyxYSeiKq/Uf1UhZ8Zaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6480
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3FD6220009
X-Rspam-User: 
X-Stat-Signature: a8w91j49648br8fa5spw4xtxzr4i9px9
X-HE-Tag: 1785418825-714121
X-HE-Meta: U2FsdGVkX19xBt+mgTbpODxl7hsSQ9Hky6Ds2LFrDp2o+ouL3mpJkWg1fVYmtYp6kJ3eMGrxL4tA34JkHh1xNb2j87mPCTQn2zlzqz4m/6a8i87ZITrpAYA96jbMfpHC5oKO2U5cKeAtm7d30GXRmjbkeekt4wA8yqfjr1N6mv3f3ElWxftUOmVRlx/2yZdP6jzuAh4vSjv2Sqcrj2ag5DqJPW1rhlKjtuZIUQHfpxui/WBw75dG9pypvaN6lnXXor8AcCbrPsPMEueNdEa2QGQ1PLMEwkbGVbZGcpmctcnBiw6/Qb6YGe1EQPsA/FCIph98mYCJBsxjqwH7/4ZABNmIZIl1Go2VDMeb1IPhf5y4rDL/xp5omfEh3cH4cZ5u9tPgHsby32GAH+m7Ty2nH5aWfDvV/DiUkMOXK20io0kYGigXWHQAM1lUbtfFD2eBtzKKXPHRxszt2i4XiZRauRA9532aVwrHCbj4JYopNitc8lpAN6eOfJpis/Godpz0q9gc2iMZX48AxDCJ8AqJ0chGqJRl54RK0+NBYO5G8z7RyPmzxqLlvrGQ6rQH3aUtNGCokzI3RYwIsGKHQoRtlztTvCTDYeaTSjfy4uegPGLx759kA60cEblYwxf1OYiP7M7sci9k3bxvE40YSFraVTFdo1kF9ngTiTQ5xb7DNbpDVopz4xCTJ+R4lOPATo+Miva/wURZtw0kMLI1EYXv0wBwD0i+6piaQUsipOLUHYXk8d77aaKPG3zgLIceS4bs3qI2FgndXNGJztZW91JAmetoGBXHffDmb+YCPrGwZ0UyF/gEsRcFgN4SsKEBh6asmtcQ66JUdOZ67+EfwSlNqmH4MXTl6aDPm7rJBExMnnhliEowfm6XPiK6l17qRK53wDGg9ErZ/FWxwUFL2rlyJGdoeNQhbyU3Vi2NCevtxJJe+Zm5Qyi1ul6N4FP/RhSukhfXGbzXazNayu6KwgO
 NMfmTc3e
 t6HiVDNfIEioHjZ2RJfgxtVW6854yumFfsyu5ONvBoZ0AtQtm3hFWjzOc0Aq6fDIS4OfpVPmFzQoymRkIMcEnIOayJF9zGq/xsdsw8ghi2op0Z2/W30CctGhX5sxevtILcEcvItlS+h3EQi9DCve6ekkbY4itDONs/FlyZiEtby09+79x5cT4rwUu11WLr5mZIXNhpDnama5DfCzzpK2DztECvQ44e28G4Pk8inOk3t/rrFvLvLjlEC4M/VpsgzODDMyiiPMyVQsM5O7+282Mtlv4rYqhlcE/E6Mhhi1ISalz/vS9fPSgGP3zBHiCdCofG+XVC/K7J99r4JZoopNE5Ts3/0Qq03RJNayurK3K1bR7w5I0GYEdw6N+YzaTFx9PNF96R7T/i64OZ34MQadYA/WOtwi9l3UD9JG2OxSPuBkstPRCXNfdPwts+1zNTbv1LIuX6mOgGLzIrakyj9d3JkNRRFJcMwUWksfbHFwvaHZgitK5nW1zWpDCHimUaz/wnvtoioJaCh9aVUOS+PmpzW5YSt/ZmD9w+N7aniyqXJjQAlQetSQuBZTs4QHtvk2j9TTUJPuuRYCooGhUz8KxAvXJnjOIyRljUb5QUxtYJl2Yc5lqqcRjXaxSIa/SxGNAusSOpSppxEXJWSU9/xiZsfk5gw+MTBS+h3TF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks all,

I sent this after seeing the Sashiko report for my series and missed
Lorenzo's earlier fix.

Lorenzo's series supersedes this patch, and 3b77e8c8cde5 is the correct
Fixes tag.

Please disregard this patch. Sorry for the noise.

https://sashiko.dev/#/patchset/20260727143426.1077133-1-xueyuan.chen21@gmail.com

Thanks,
Xueyuan

