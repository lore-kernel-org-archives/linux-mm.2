Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0BBCD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5F66B0005; Wed, 10 Jun 2026 23:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6AC6B0088; Wed, 10 Jun 2026 23:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E8C6B008C; Wed, 10 Jun 2026 23:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 232516B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:06:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3BF7120452
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:06:29 +0000 (UTC)
X-FDA: 84866143698.09.C627779
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010025.outbound.protection.outlook.com [52.101.85.25])
	by imf12.hostedemail.com (Postfix) with ESMTP id AAE1A40002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:06:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DZ8cuqRP;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781147187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Hf+ens7oFkp9tS114TaYtVv6KlDgzCY0mDg/+ZNAqI=;
	b=LR8r3+2Mf3guo7U8kL+UfHAj2ahm/sg4wTMnKVcttV3urQ+5ULOBAKOd7TpBeHn5i4d58t
	uLq32iUWzo1UnktsGc2Qcme/rn1PGAdRR5lYV1vHr+Hh+z7Jc6/Lbc+8iw5LX3pX5A9Pn2
	JVW5Wtjov/J++Uvxw09UOYxvkGGMsNw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DZ8cuqRP;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781147187;
	b=Ij8RVTPbGEwNO57fvK6m4e940Jdh2SvIwOYxZtHVp280rw2JfSzAfNP4/KyPjdn0tgkY16
	xYrYDcbs+x77VMu7frIR2YnbK4eSRCZrcwVYV4bIG6V8mlUQQJoeRvu0EwzrMgUZAK4vd0
	mcednsKUUrqBwf2vjwJDv9qlJrCFRnE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XegmiHzjLjib589RFPvzGfJcJgaXGJggFnsA+KF8wzogh/RSOZNxAvDBdU7cuRt5VNn42DII68F24lPtYYlgQtuvLCjaaKVkyYBUPW3UIqNYc6rlEuRtRVWM6LvnLsEXQ0QA9yordyy5lVxr9XwOvPctdy+sUUedxd1s7ZAnYL4g31bdtGUWJ2NwcgZlE6Dt7AJCtxlgidxmsdt/kPtu0EkGzJBuXTiNZH6o/frGleZQv5+wsgIVw1fqwo6kpzzvfrF7WIHRyAyXTTQ27JDrl6WsuRoMbhXcazAZL2DQwfwZclX2+bI1Sl42fbt7Ym4V/aYCkA+iqGcsQT3XO1V46w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Hf+ens7oFkp9tS114TaYtVv6KlDgzCY0mDg/+ZNAqI=;
 b=Gs3Q9c3TDcv3+CLLSJIS3XdthFwRSv2+TnwsdZMa+nzpVb28CsF5RWirAhTT2Ir17AjbID/VvXhDultkpkvkJqxkGff/Bdvm7f2G+uoMWdI4e/az44Wwt/IcXCrQYv7YbdFke2X8MmFoxGLPYo3hrjEmk1esQpaBY/Z9+4OVYuGMFbbqWebm/ldsIs/QsjhGHPZOwKmNlDfqWgifY7yw61nNFOungFlwOJag39pDp8tO/Rnv7DQJyqvPzJ1Ts4J1nOsweBb6YQsOMCPAcawbZTK9qYxMw7FuFkKziEd7wYQD8aMtYvJzPBHKObUyL088ipnfO3pihdZffK23PmLssQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Hf+ens7oFkp9tS114TaYtVv6KlDgzCY0mDg/+ZNAqI=;
 b=DZ8cuqRPG8qjQzJxxh8J/teMva91yJqZ0WTOGqLRO1GxSp//73HRpCaS1mKRrqhxl1BqaU2NZZdfraIn4uQjdb7T0PZDyB8LkuBphMQMHH+D5d7p2ym5r7zxEyzqsXOu5OOBe0e04ZcLAuwKe6VrjRuWauoWuq8cyKIOoC6Ra7Or6L5djhvAEvEXe5QveCOPygxttJkdQUp/uQDomUsO7kOcGNYZwG/hmJ9tsvPDqZaT9Y9Z5/W422bULKlMHkWcTQTyv5CpHhnWF6oKNOZFsKQvKNGm0PYjvqLVUEZHLd9QZra4B8DhvY5z08Et8PHR0MPqCKPg9wDqrApZ/WMhLQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYYPR12MB8921.namprd12.prod.outlook.com (2603:10b6:930:c7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.11; Thu, 11 Jun 2026 03:06:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Thu, 11 Jun 2026
 03:06:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com,
 xiuhong.wang@unisoc.com, hao_hao.wang@unisoc.com, jyescas@google.com
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Date: Wed, 10 Jun 2026 23:06:18 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <A7D51FCA-7D88-449B-9113-7741BA2D659B@nvidia.com>
In-Reply-To: <CAGWkznEGt1eRmiTLsU6DAJBmmbUG4ZY4HE5Cx=Oy0yznqGb0UA@mail.gmail.com>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
 <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com>
 <2F9A72CC-772C-4691-9F18-77306EADC6CB@nvidia.com>
 <CAGWkznEGt1eRmiTLsU6DAJBmmbUG4ZY4HE5Cx=Oy0yznqGb0UA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR01CA0065.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::37) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYYPR12MB8921:EE_
X-MS-Office365-Filtering-Correlation-Id: d4264c1d-17d7-4d18-103f-08dec7666a02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|366016|7416014|1800799024|5023799004|56012099006|11063799006|4143699003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	L1RU+sizqi030ipvb/EAgXpegAJYnDTaBsGDO4IdeDtukMRpNfh6sAgZD9XPQplBkMqIG20v/u9JfCQM6GIMPFbN95r7FYI3V79Bjsg+ya7fmkqQ7ngmY5yDo3epSMmXKEPwObt/kdWFJMHiNnigAqvk0M591vk/Jw3wYrBaph2Ne+ERpT2EAe6MOTKvJwcWbxtx3SiBhu0vE7AHPVpD14XJcTxyNvx8uGCoDNbfyzbj4uCQYVo5XCmEFeVMB+JR1E8kxM2EcuGTEEPlME/7qP5gLWnqV9da1i/MRzuF+w9Qr8nARRRuymKDeyUr+q5XUbpWrP4HTh0oUSP7RXGFXa+sbMu64sSAGBvyCZho4AxGvaCQjE17A5V2TFCIRssHzu+nFBzSPPbn1gFEBqKHf29cLNiY6zpyYq1fNReo2U+0UJfDJozFEhmj37azcQm28iM+g/N3XQdnY2Ene0zYRRno6slM+LhvA7Bzv4kNDQKoEg/Npoax1kfNl1g4DdYxaEgyyHNEzQrEqaHZ3ancOo3DRmQfiiIeRUMC657/U3e37f450pTp3KU5M5sWfXOoASZqWTABuTNRqi/S63RZF6qlPqBgT8bV6PK/d0VjxINBNFMH5y/xTYR8xnoQYs/aTDfpRvjL8RAIklIdyB0pR3DOIqhcncMo6b5+IDNsYHGSQMEndP1MIWM5rDc9YKBl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(366016)(7416014)(1800799024)(5023799004)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzNWRk8wSU01ZnQ2YTNFTTdqL1FQV25xSDNGdS94bzdJUTRnTkpob01Xejky?=
 =?utf-8?B?TEZBTWMxdjFIVEI3eW5VVk1OS1VXZ25vR3RvNjNITTU3ZTFYK0F0cTJIWWRF?=
 =?utf-8?B?M1d5MndjZ2JVSE9WODgyK2l6Y3BKVkJCZG82YTRyRmtnNTViNC9adGRyMklJ?=
 =?utf-8?B?dDY4U2pDS3NiUE03R3ZPK25wVG5XQXd0d2lWMDFTaUo3YUllWG5mNHgxMnFT?=
 =?utf-8?B?NWxCdEFQa2NWM0ZsTjFsL3FjSklFVld6L3VKUXk5cTA5REp1OTBOcTRDUjU1?=
 =?utf-8?B?RjNmeHJvc3ZCVnhlc21VVlVKODd3ZEw3T3cvL2NSYWhPNnpCa2c2angwZ3J5?=
 =?utf-8?B?WXpaNGJ6c0NuWUlCVkZ6V1FJRFRWdHNlUTVFanB1a3Q1VUZkdXozVlJoTnlG?=
 =?utf-8?B?VC90cDl6YkRUNlBnU3hqQldETERLY1E2UzRyN0NKd1g2N01GU0o3VXhhMHhn?=
 =?utf-8?B?dFFUNFRYbWF5Ri9pUWRaTFM3M3BRMWxMQUo4ZDROWDlTSG9kak5FS2xaaEd2?=
 =?utf-8?B?cElXUXBsaDJsckxjRmZLdGt6M1Z4aG1tTHFuaXJTVUpCTGRGYWZsZmNvYTFP?=
 =?utf-8?B?UUpOMW41YnJkSHZZNUY3UmEzTm84TlgwcFZ4dUY2cTJ3TGw1cVJVWWRUZmgz?=
 =?utf-8?B?emEwaUhhMUN0c0t2Y2FUMlJhOW9ZcjdmNVdVcllBL2p1d3FvbGlIVHZwNzM5?=
 =?utf-8?B?REFHRktoM2M4VnI1VVREaHIyUmF3QzREUDVERHlVK2NQWVowT1piaDArUGdL?=
 =?utf-8?B?WE1ERitsVnBXUEx1R2E2MWN3QklmaktqWG9pNDdSM1BJQ3FvekZ2REkrWFFn?=
 =?utf-8?B?UWRrdXRJMkJpVW9yK0tQazY3Yzd0cnpObjJmZitXck5iSTlQNkdKQkc4VDdO?=
 =?utf-8?B?VUdhT09RZ3lYY1M2bUM4UGpabUtPQTVBeGJaeXBEV2lLNW5UWjJkamhQcVR4?=
 =?utf-8?B?anJjc1hSdWtaVlpaZEI1U1BkZ1U5bGxGQ2NlNUEzanJYRWl4c2VNYVM0b2I2?=
 =?utf-8?B?bTlBNkEybjFWMmlzUmNxRzlpOG1iMHhWeC9qSHRXb01YUHlLK0NMSTBWQ2Zq?=
 =?utf-8?B?SHBDbHhpNURRUlJrK3lLd2E1Y1ZsU25MdlV5cTl3U2JrV1RtMTQ3ZU9WQmZu?=
 =?utf-8?B?Tno4TGpWVGpOQ2NFRW5CdDR3U0hBYVk3R080TG1Sc1QySkNwdjVocjUrRjBK?=
 =?utf-8?B?bTgvekZ0V2xvdVBCTjIxaFQzb0cxL25oRnkrWUV6SFNZdlVtL1ZxNlJHZ1FM?=
 =?utf-8?B?Z0hUZFkyWFROWXVWbjRsaExndVpadm5nbkkrTklPYXVOaDlRSUVlemxvRWo0?=
 =?utf-8?B?Y2g0UmRoSXlLbmZjTzlzbzZMVzdFODVQWFFKQmwrNElxcllPYVNrcEprV3Vj?=
 =?utf-8?B?RUF2RVZJK0lGN05TM0N6MVQ2RXFGVkQrQWRiVlBrdXA3Ujl2cE9RVGlhMk9H?=
 =?utf-8?B?aTJXdlVBVCtoMStjSFNkMVo1U0U1UXVEaXNvVG0zbFlGZ2poUjcvM3d4dUdR?=
 =?utf-8?B?bEkvMjdmSVVFWGxPOGpyT2E3QWdnWUY5amZTUTBXMytvbTB1SHo1R1BIVzVj?=
 =?utf-8?B?bHMwWUZSUEZjdTVpbldRV3VaZCtIVVZlSXFrRGo4Tk9yY2duekZMOWlHdmt1?=
 =?utf-8?B?UEZPT0Q1dVFLQzZoN3c2TXg1Tit2RndpT0d2VW5ITlVSaHRheWlEcXV0bkJW?=
 =?utf-8?B?eDdkU296eFVtVlJYMCtXckY0ME11UDRJSzlzL3A3NndiOEFEbjdKdUtacnNx?=
 =?utf-8?B?aEZyRndITG5BbGdpaG5PQkptbEUvVU5LeXcvVlZzMmwzRklsRVVuVVRCeFBQ?=
 =?utf-8?B?QVBvWTl5cFdSbTdoZnE3UWV0YmFnTG5JZlJKL0JmdUFpWm41V0dkVVAyd05p?=
 =?utf-8?B?SE03UldreDRZZEJvQnp5ZVEzZUc3NFBvS3pKTEY2eFRGR084Ukc5Y2RTbC81?=
 =?utf-8?B?azVpMG1ubTV5SnRHUlJ6cDhncncwcHkwUlBocE5kSmMzZnFsbDBwL09aaTZJ?=
 =?utf-8?B?Y0t4WUhGckQwRjFZTFJzaStITGZWUEs0aDNDZHdCNTdwVjVjdElubmpXVndv?=
 =?utf-8?B?YjNUWkhhM0cxZVh5K3Z2MjBpZEdDQ0U0cnN5Vlg1RWtNQjFrZVgwMGRyYmRH?=
 =?utf-8?B?MWZXL3g0R3Y4ODFVd2swWkdmVkNwaTIzUzMyVmcwRnFaZktRM09Dd0diMXBi?=
 =?utf-8?B?UTNuODVjV2pWaGtvc1gwMHlnYkdZUS9RbXFvQVJXNXZZaHJmbktWQTJYa1pz?=
 =?utf-8?B?R2tLTHV3QjA5ZktHNENvZmxaM05sR3BJa0lDdWxNa2I4VXVhekRQd0EvYi9u?=
 =?utf-8?B?WEJkQ05uVDlvLzRZenBGS1puNXgxK3hYVWpjbVd0bm5MYmNSZWUyb2hWQlIx?=
 =?utf-8?Q?RjzSROZalCQx+RZc0NPsY+RDqRiodbn0rhzW+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4264c1d-17d7-4d18-103f-08dec7666a02
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 03:06:21.3489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ri16vNaZLhjlPPYAL7tkjQVuztf910+CSj075gShUKpiEc45uLFs0NwCwyucefX/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8921
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AAE1A40002
X-Stat-Signature: 9foewqjbxfaq6ue1qba4oaru6gmr1iok
X-Rspam-User: 
X-HE-Tag: 1781147186-78579
X-HE-Meta: U2FsdGVkX182gya/EYdFBgN7kuNxfJ+lIOQIntwFF8vAM+0zDN71ez+1ml1PPs91oPy1UYLhaL8MC7Q0svbHIcU/BNn5mraZcOBycWci4PRL8fJJkcQLyiCv7aDt/2KkEfCICWyYgrNMLxZd8nam2ZZGIJ2ftlAYt9p55lH50tn7uZVXTZklK4YJhPuC5csyVRyoZ2fAMCFcUBtwdVUIgEJ2dcY9fUHftBOxgyJbWxAvFKGkkffNCv0ki93JNOtEajcDnKAas47/EbR+wkXV64caLHatcw+AWoz7Ug7SeRw7bsCAcvCNOCYTrHjvPSAFp4Ksm20o2Cqq5ZzJOLrmrUOcOrJvPoeeQFLHFFH2yyFGfwb4/LNLo3iDVVtO9MjAJiJ3TnWjHx9cBlhmYJ+dDR7y04PS/+beqvIbBKO1xOmMsHrbw8kfk/UGwqO+q0iqeql5W2pFyUchoen+AjbMu5HSeeMKFGOqNgJfA3xkzit9xXAwVsqTU8Wg4Qccn8t26UpR1LuSVqpZ384DZkNBAF+TTaunJLL8D5ft+hsS1GbHL/rVBVRublOuTitvX3jtEpXA+F76FdTAU61YOIOV9UuZOR9oKUqnuA0Nw3c2oXDaPBT6DIm6St9Kd82sxG8U/qNtEr56b5T1wiwVs7bl93wfDDId8rOqrtVeoo+aOEAlWloTbwXoDHiVW3R+m1bOqb3uH4D0YntHtXHHZjPPdEjVvR713FDBcyoZljXelQS27AQztR68o4G4knw23h4e23UI7x4qw//xSOosp5p61oCY/jQXpz++pIQmKdIPAm6DdeKUHf/ZdvjLz5Kugiff/cyXMRP6CAnNgocquFeh3TrmWz122OXnBgm3ADAxBJhvdfK9NVMHRY/Lm+boLhPUShHE0KnzFNmPQRJwfjr+8bqj14jX2Sv98eRUyzLkKO3BMkBwwlFWTI3tmLiH5f8QELb51ZDATUWRoKgIyzx
 z9NeG7yN
 F5I0nfn17keiMS4pw9Ow/x2oqktvVv3e4qJEhkFo69yCxr9wg6muMz4J3/pqeERA3T8XRRiJxaOL7PhoAGUmoFBLFxYOyViXM5qrbJfXINtooPazLF1hwqYbnY6LZnm9MvgBF4Vm8QS6GY0trFW9MBSOB0FUsXhxVtRzAbszm2lbRHAQlNfkexWiBLPJ60M/5JlsZQuWuY1sCw+3snmycJnH24GjQPeKXJ8kUODTGLJ1KYhmKoz5l7m8VOOlMp3N7d8Rn1UNQHsTN4/Tqrm989OLHkwcdIhEM8euiXBvcRqaCAbwlhVTVoIU0jrypl/h3BkZ/efEDyR2joVKigpnhUfOYgavycqb5ob1Uf63RIhAuQnZAcAPMiB5CJMX2MHOrGCbTV3ehFX4RzO4lAGfoBw4FqL/hj+U7fWYkP9qB0YlTrNEiTY/yKF6aeDDJNejHDEjnwbt4BxnAOZ/iNHc3VlKBGFEkAuhYH5hybHMR0dY7H/Vy2lKS689gq9szBrxKke74
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Jun 2026, at 22:39, Zhaoyang Huang wrote:

> On Thu, Jun 11, 2026 at 9:56=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 10 Jun 2026, at 21:39, Zhaoyang Huang wrote:
>>
>>> On Wed, Jun 10, 2026 at 10:38=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>>>
>>>> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
>>>>
>>>>> On 6/10/26 14:05, zhaoyang.huang wrote:
>>>>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>>>>
>>>>>> The kernel panics are keeping to be reported especially when the f2f=
s
>>>>>> partition get almost full. By investigation, we find that the reason=
 is
>>>>>> one f2fs page got freed to buddy without being deleted from LRU and =
the
>>>>>> root cause is the race happened in [2] which is enrolled by this com=
mit.
>>>>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: =
remove
>>>>>> non-uptodate folio from the page cache in move_data_block").
>>>>>
>>>>> But I assume, that other FSes can trigger this as well? Any insights?
>>>
>>> Yes, I think all FSes support big folio could suffer from this defect.
>>>
>>>>>
>>>>>>
>>>>>> There are 3 race processes in this scenario, please find below for t=
heir
>>>>>> main activities. However, by further investigation over the code, I
>>>>>> think there is a common race window for the truncated folios between
>>>>>> split_folio_to_order and folio_isolate_lru, where the folios lost th=
e
>>>>>> refcount on page cache and remains the transient one of the split
>>>>>> caller, under which the folio could enter free path and compete with=
 the
>>>>>> isolation process. This commit would like to suggest to have the fol=
ios
>>>>>> beyond EOF stay out of LRU.
>>>>>>
>>>>>> Truncate:
>>>>>> The changed code in move_data_block() lets the GC path evict the tai=
l-end
>>>>>> folio from the page cache through folio_end_dropbehind().  Once
>>>>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, th=
e
>>>>>> page-cache references for all pages in the folio are dropped.  The f=
olio
>>>>>> is then kept alive only by temporary external references, which allo=
ws a
>>>>>> later split to operate on a folio whose subpages are no longer prote=
cted
>>>>>> by page-cache references.
>>>>>>
>>>>>> Split:
>>>>>> After the page-cache references are gone, split_folio_to_order() can
>>>>>> split the big folio into individual pages and put the resulting subp=
ages
>>>>>> back on the LRU.  For tail pages beyond EOF, split removes them from=
 the
>>>>>> page cache and drops their page-cache references.  A tail page can t=
hen
>>>>>> remain on the LRU with PG_lru set while holding only the split calle=
r's
>>>>>> temporary reference.  When free_folio_and_swap_cache() drops that fi=
nal
>>>>>> reference, the page enters the final folio_put() release path.
>>>>>>
>>>>>> Isolate:
>>>>>> In parallel, folio_isolate_lru() can observe the same tail page with=
 a
>>>>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking it=
s own
>>>>>> reference.  If this races with the final folio_put() from the split =
path,
>>>>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio=
().
>>>>>> The page is then freed back to the allocator while its lru links are
>>>>>> still present in the LRU list.  A later LRU operation on a neighbori=
ng
>>>>>> page detects the stale link and reports list corruption.
>>>>>
>>>>> Complicated mess :(
>>>>>
>>>>> So, folio_isolate_lru() really only requires the caller to hold a fol=
io
>>>>> reference, which can happen given that we did the folio_ref_unfreeze(=
). It can,
>>>>> for example, be triggered by memory offlining or page migration.
>>>>>
>>>>> So we really want to not allow folio_isolate_lru() while we are still=
 processing
>>>>> the folio.
>>>>
>>>> Or we should defer adding split folios to LRU after unfreeze.
>>>>
>>>>>
>>>>> What your patch does is, simply not add folios that we will drop from=
 the page
>>>>> cache to the LRU?
>>>>>
>>>>>
>>>>> You should describe here how you are fixing it: "Let's fix it by..."
>>> Yes. This commit would like to suggest to fix it by having the folio
>>> skip the lru_add_split_folio
>>
>> Skipping it causes more issues like LRU counter mismatch, firing up bad_=
page()
>> since PG_active, PG_unevictable, or MGLRU fields in ->flags.f could stay
>> uncleared at page free time.
>
> OK, we should solve this issue.
>>
>>>>>
>>>>>>
>>>>>> [1]
>>>>>> [   22.486082] list_del corruption. next->prev should be fffffffec10=
e0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
>>>>>> [   22.486130] ------------[ cut here ]------------
>>>>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
>>>>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SM=
P
>>>>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
>>>>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
>>>>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS=
 BTYPE=3D--)
>>>>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
>>>>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
>>>>>> [   22.488539] sp : ffffffc08006b830
>>>>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000=
000000000000
>>>>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ffff=
fffec10e0ac0
>>>>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead=
000000000122
>>>>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffff=
ffc080061060
>>>>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000=
000000000058
>>>>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000=
000000000003
>>>>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8=
5721f0e25f00
>>>>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65=
645f7473696c
>>>>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000=
000000000010
>>>>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000=
00000000006d
>>>>>> [   22.488647] Call trace:
>>>>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
>>>>>> [   22.488661]  __folio_put+0x2bc/0x434
>>>>>> [   22.488670]  folio_put+0x28/0x58
>>>>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
>>>>>> [   22.488689]  f2fs_gc+0x230/0x9b4
>>>>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
>>>>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
>>>>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
>>>>>> [   22.488725]  invoke_syscall+0x58/0xe4
>>>>>> [   22.488732]  do_el0_svc+0x48/0xdc
>>>>>> [   22.488739]  el0_svc+0x3c/0x98
>>>>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
>>>>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>>>>>>
>>>>>> [2]
>>>>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU=
2 (folio_isolate_lru)
>>>>>>
>>>>>> F: pagecache refs =3D n
>>>>>> F: extra refs =3D GC + split
>>>>>> F: PG_lru set
>>>>>> move_data_block()
>>>>>> folio =3D f2fs_grab_cache_folio(F)
>>>>>> ...
>>>>>> __folio_set_dropbehind(F)
>>>>>> folio_unlock(F)
>>>>>> folio_end_dropbehind(F)
>>>>>>   folio_unmap_invalidate(F)
>>>>>>     __filemap_remove_folio(F)
>>>>>>     folio_put_refs(F, n)
>>>>>> folio_put(F)
>>>>>>                             split_folio_to_order(F)
>>>>>>                               folio_ref_freeze(F, 1)
>>>>>>                               ...
>>>>>>                               lru_add_split_folio(T)
>>>>>>                                 list_add_tail(&T->lru, &F->lru)
>>>>>>                                 folio_set_lru(T)
>>>>>>                               __filemap_remove_folio(T)
>>>>>>                               folio_put_refs(T, 1)
>>>>>>                               /* T refcount =3D=3D 1, PageLRU set */
>>>>>>                             free_folio_and_swap_cache(T)
>>>>>>                               folio_put(T)
>>>>>>                                 /* refcount: 1 -> 0 */
>>>>>>                                                                   fo=
lio_isolate_lru(T)
>>>>
>>>> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio=
), folio) in
>>>> folio_isolate_lru() would be triggered. Maybe we could just return fal=
se in that case.
>>> No, isolate caller will grab one refcount.
>>
>> As I said in another email, isolate caller cannot grab a refcount when f=
olio refcount
>> is 0.
>
> pin_user_pages*(..., FOLL_LONGTERM)
> =E2=94=94=E2=94=80 __gup_longterm_locked() [gup.c:2465]
> =E2=94=82 =E2=94=9C=E2=94=80 follow_page_pte() [gup.c:802]
> =E2=94=82 =E2=94=82 =E2=94=94=E2=94=80 try_grab_folio() [gup.c:858]
>              if (WARN_ON_ONCE(folio_ref_count(folio) <=3D 0))
>                  return -ENOMEM;
>
>                                // Could __folio_split->folio_put could
> race here ?
>              if (flags & FOLL_GET)
>                  folio_ref_add(folio, refs);
> =E2=94=94=E2=94=80 check_and_migrate_movable_pages() [gup.c:2490]
> =E2=94=94=E2=94=80 collect_longterm_unpinnable_folios() [gup.c:2391]
> =E2=94=94=E2=94=80 =E2=94=94=E2=94=80if (!folio_isolate_lru(folio))
>
> Could the __folio_split race in the above scenario? It looks like
> try_grab_folio set the refcount without using atomic operation.

folio_ref_add() used by try_grab_folio() is an atomic op.
Which refcount change is not atomic here?

In addition, who is GUPing f2fs folio?

I think you need to find the actual f2fs code path instead of
chasing theoretical code combinations.

>
>> (from previous mail)
>> Wait, if folio->mapping is NULL and folio is not anonymous,
>> folio_check_splittable() returns false at the beginning of
>> __folio_split(). So the split cannot happen.
>
> According to my understanding, the folio checked here is still big
> folio which is locked and with folio->mapping set, right?

But the provided trace says the folio is split after folio_end_dropbehind(F=
)
and folio->mapping is NULL.

>>
>>>>
>>>>>>                                                                     =
folio_test_clear_lru(T)
>>>>>>                                 __folio_put(T)
>>>>>>                                   __page_cache_release(T)
>>>>>>                                     folio_test_lru(T) =3D=3D false
>>>>>>                                     /* skip lruvec_del_folio(T) */
>>>>>>                                   free_frozen_pages(T)
>>>>>>                                                                   fo=
lio_get(T)
>>>>>>                                                                   lr=
uvec_del_folio(T)
>>>>
>>>> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T f=
rom LRU list.
>>>>
>>>>>> later:
>>>>>>   list_del(adjacent->lru)
>>>>>>     next =3D=3D &T->lru
>>>>>>     next->prev =3D=3D LIST_POISON / PCP freelist
>>>>>>     BUG
>>>>>>
>>>>
>>>> Why does CPU0 still see the stale link from adjacent?
>>> The staled link should be from LRU since the folio never be deleted fro=
m lru.
>>>>
>>>>>> Assisted-by: Cursor:claude-opus-4-8
>>>>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>>>
>>>>> I'm wondering if this has been broken the whole time, or if some rewo=
rk allowed
>>>>> this to trigger.
>>> This issue is from AOSP with v6.18 which just supports big folio in
>>> f2fs. Besides, it is triggered by the timing of f2fs's partition get
>>> almost full during the test case of filling f2fs's partition(should be
>>> the trigger factor of f2fs's gc which enroll truncate thing)
>>
>> Are you able to reproduce it with other FSes supporting large folio?
>
> Sorry, I can't so far since only f2fs has gc in the Android system.

Have you checked f2fs gc code to make sure it is working correctly?
BTW, what makes you think the issue is related to folio_split()?
Can you elaborate more on your investigation?

Thanks.


--
Best Regards,
Yan, Zi

