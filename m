Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35E7CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 13:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5046B0005; Fri, 12 Jun 2026 09:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59BB56B0088; Fri, 12 Jun 2026 09:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48AC96B008C; Fri, 12 Jun 2026 09:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37D1C6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:56:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCC9512011D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:56:44 +0000 (UTC)
X-FDA: 84871411128.05.FE42C50
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010015.outbound.protection.outlook.com [52.101.61.15])
	by imf20.hostedemail.com (Postfix) with ESMTP id C45381C000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:56:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TzFl8rRO;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781272602;
	b=hIrJKiBwO91ZWuBEhSybAlGGtskyLYc/lYihKr3yAc5qa7f3DF+RJQBJm/4/cKCI1QRw7X
	ZjfMeBIQdvABbn5pLe4kFsUAf2xn+xpz/9hrihj+bmyarIrfebH9MBNJ2AC6S2QsVaAvNn
	QewjvVppU+ygdw5TkdNMEeB7kXDhwxo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TzFl8rRO;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781272602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4RBRYWbajEOPrZsCgTihUeAPC32L9hyrhlbT/qQYzE=;
	b=kctcQ0AA+/P1H8DGqY2xTrSXh8Wi3aLpSrulYaD7hSCoCnKnbVVjSLERVGZlsr1jEuO9pw
	tL3q50BNvZfC/by7FKwa2EP3q5oaHkwJfXbqw5eygmuRuK4RZx6Ru19pT8JB0ZS2GWVQAX
	Jgv7L4xHSaGHDp1qob6+5gp9zRlK5Wc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDzAatgujO1jfDR4W8KKQC5Bps4/L0rOTVg5OWXZqOg4DrvlMqaUE+aEvLDyRyXQFrOyw8B7wp40IVdTUWFg03Pws5qrhGQhTZe/lieDfni+9LMX6NDxp+Rbl4UKXVO5hK/dUSNjvkioDddRICtm85a4sROoW2RAgBOv3wHV6QuVku4nBYdEE+HAV8lLPD4+s/ISnm6yImQVDsqDFcNQUU98Es8aerDONdZTcb8zY9Wez3iun3xPHBu2ftgtXTqCByycR2nDXXCH3xaP00SU0O8MCAvQ4SqHBg9inEQVPvzdU39CZv5XXUAIKV+a0GY6qziPzrPKuLS4KUxHY8FR3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4RBRYWbajEOPrZsCgTihUeAPC32L9hyrhlbT/qQYzE=;
 b=ophi6v/XuitrCOJJ5/+u9+oEUavsmplBlyPCTXlyJSHPoJL0rK46tYndbUgV7jtCS0NcU8aOQByqXFbebi2OXacUa+VIGTmg+Ik4rr3IVlJyaLrAjaEkdojtDaJNzIk/kkOxlSKY2GVT8muZjLrGnlGUTfCfnG5DTgFf+MU8PQlBIYpl7dF7H2p1+OVeXPvhQw8LpgfbuWaaY5SzhcYq9duDP3cjx+8X9JMjBhhzHBkBfL5/igsko4rY3qdVRv0ynZU8d+OIrDogcfvx32xzOfgjOXJv1z0ODTljIE8gYYiUTg2y1vGAiIoi30vZRm0vgHLJddUWQ1KTZjdDNtfc6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4RBRYWbajEOPrZsCgTihUeAPC32L9hyrhlbT/qQYzE=;
 b=TzFl8rROSJzjbU73cGxY//K3OS6hpxg/RVoyGoDfIu5t2isy3HKtsnmf5BngWoNZic36ZHlZn653rE7U9qdxcPJ/9mlW+gl+k7TazpQv5K3kabFZ5KckeGtGrz3q0R2UWiRJqfsU5G/xfsf/7/+U5El/vT+aCcjKcwXRIETvscxrIVGWzfWQ7IYGbF9r0UUxYebav9i0EnMaZVrF4HN+SHyqDsbFbDoofDxwtoohTlMoq0A0E19HJZB6cAqoqDnCeZ3yY4EGytQ3X4sGuTaFjMUbtXcTbPpEekKJgRkO/NJoPvlbk6acsw1CrI1brm4S/xlXT0y8uuJZMYcTwUfRvg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6068.namprd12.prod.outlook.com (2603:10b6:208:3ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.17; Fri, 12 Jun
 2026 13:56:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 13:56:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 steve.kang@unisoc.com, xiuhong.wang@unisoc.com
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to
 LRU
Date: Fri, 12 Jun 2026 09:56:33 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <CFE7A598-0F5E-4F67-A2C8-2B9FAEC246FA@nvidia.com>
In-Reply-To: <CAGWkznG0gdAhMei4iDf98w=GfA_O0sVgtaWC9BYcnigG6RjiQA@mail.gmail.com>
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
 <953254E6-4518-4CE1-8A41-93EFB9364413@nvidia.com>
 <CAGWkznG0gdAhMei4iDf98w=GfA_O0sVgtaWC9BYcnigG6RjiQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:208:52d::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: d7dddf54-841b-4765-3d01-08dec88a6b55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|6133799003|11063799006|18002099003|4143699003|5023799004|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	1TNv+o8IMzfqSGCDb73y5V5Z95qT13cI9HA1xUaMi3lBpDT7YIYH4KiSO4eB9bG3mGHgs87m4Xsz54/57ixvyLCy4LX4ip53ST9tZ5RYXbTSQqyPKx3vJwHG6rEeo3ogYimztjCh25AYKT1VkNMUX2tkvSnXc6ADFdNEBqIufc4hAJlRQJzQ5Lh//UtdVvwzv+KeYs+vKek5x+k/PptoE90j4zn2FOr6rh1UhBETQZkXz0w9WMgvogOVvBRaTQoIFFuWl+W7XHltCIlH4EI3L1dH2Dkt6TWJGPmTUt/MzUsRhY8za8kOt2RpxAQdrfM1stJTzQxuFZyICmqM5riraVPKmkMYxN7e52rvKJJ0FxewHf1Ts7X108Bq6kocCWeeLVKhiuw0dW7ekfxhhY3BaJ//WzWLNfyhb/EsMkMMyLbJiploLBEPj84fSchkYPcU3baL9dHkWbyNtfALBm9IHRbo3SWSn1k9q7ysGc31CryiEfQS+Ysvb7W2U/YiaiD/Fw+YL1PaUHjOk5zkAhgFUBP5S8q2aUZBK7BWddrRNSd1/f9wnQxatgTXNZOgzQS7BlvFasFuDV/vmbpL2fpNB6EgSGONnTpnH/1L3GpJh2RKSST1xJwgBpXetCxgzCzvLz45cnyCn8ShrHX2QqaO2hWsrcmVybuAtGzZQCM8eQJaPh0+KiGMdvdN0djgxt3R
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(6133799003)(11063799006)(18002099003)(4143699003)(5023799004)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3VjVzdKWG9CcXJLdWNjMG9ieGNUb2VnZTQwYWtoVzFHbm9EU3gzcHk5ZHR6?=
 =?utf-8?B?azZUZE10NTFWSlFxdjBDVWFDSm5SNnR0U2h2QWpXcnVzODNEYWI0VlhUL1c1?=
 =?utf-8?B?NzhLdFBhVi9QQlE5T0FDVVRlNmg3NllLUjNnZDhZWTVLenUzWm9WanYyenA5?=
 =?utf-8?B?UVhiVDBiSTVCb1JIQXZSbUdTV1k0OWhTK0xUbGtRM1J3RENWQmxXM2pWMkJK?=
 =?utf-8?B?dDJ1eFJVUVN1REtidkdKVEhHR09Mcmlld0RPZkdVZ2ZRbDVwcVhpdnY4Snpm?=
 =?utf-8?B?aDFGb0ZxZS8rZ0FmQTRxdnRuYTcyMUdTN3l6S2NLakJLSHJQcHZQRm9KSTJQ?=
 =?utf-8?B?MHBFWFNTM0dXNzJLVlNPd3phcDI5SjNZSGtNSEo5THpWcHFDeFdmK1JVRDV2?=
 =?utf-8?B?bjlNMTEzSUtkLzduRy9qWlpVajVlWW1Ocmc0NkdWYjEyYnJLL1AzQi81c3VX?=
 =?utf-8?B?VE5DSm1NMmNIVXJQSFhZYVUyWkJ3ZFRDY1NwTTF0TWVWc0RHam4xRVlja0dC?=
 =?utf-8?B?dE9sVGl3cHRKSVEyN3V6Ukh6b3JXaTBXbk4vY29LNmFUUE8rL0JhMEV1Y1k0?=
 =?utf-8?B?bTdEQVhkQWRIZWpZWHZTbUNpUkdyNW1Eb0YwNkQyVHlmS0VPRnR6SG5UUDRh?=
 =?utf-8?B?YS9FbUthbS9uditGMkJFaFBIWVVDRG1HNjgyaFdvMThxNmIvd0dCcGx4S3Nq?=
 =?utf-8?B?MkJuYyszM0IyWll5RDg0S3BUSGU1R3ExeEx0RW92SVFkbGdIbm12bDRYeVVz?=
 =?utf-8?B?VnY0YjFWRkp6N3hTZWZ4Y0lMcHNxWmlHQzlJdzA2M0dmYy9DdmFZQkNjb0ZR?=
 =?utf-8?B?cjd5OURqS0lZSWpjalZYcVE5OEp6aXNLV2VTWkFKTEZFN3luR1dMakJzdUM2?=
 =?utf-8?B?Tno2Rkd0VGU3T0o3YXNZcktoeU10cWQyL0N6OEpXdVRiWThhUWlESnI2MDBK?=
 =?utf-8?B?T1A2SnpoUTZXY09BUTM5N3h3UjlVQTFDUlB4Tys2VWduODZyUExBUERkQzJO?=
 =?utf-8?B?TThhYUFDZDhjSmtQNGQwTmNGb0oxZkxoMUF1RG01ZktTK2NvQndkWVhBWTJz?=
 =?utf-8?B?ZjhpK3dPSzc5WVIzdG1vRk1GRDMyeUVoQ1p2R3pCaE0wb1AvMnRHQ3E5bE5X?=
 =?utf-8?B?RVFhbWJqWFRZTmhNclloM3cvZUhVTlRVa0tIR0d0aEttY1hYMEpob21YazJO?=
 =?utf-8?B?d0hMODlBd0YzYnYvcjhGRXhFc1BIa0UzZDIxQlZUUmNNWHV5RnhjUlZTZy8x?=
 =?utf-8?B?ZENNSEdLQTlPMWxoVVhXZWpCMHFBMlFMTVlDdzl3akJ0aFZQY2V3dklkeEFE?=
 =?utf-8?B?blRES3p1WmhZMlpkUjU1aVNoZHVPMXViTnFIQ1ZmSmtRaEUzRS90bEkzeEJo?=
 =?utf-8?B?R0V0MjIzN25pRUdpN0hHWk80MlVFMjAxa3hya3I4dmNWS1N3ZU43UXVoS01M?=
 =?utf-8?B?anBDcWxTU1Azckc0WXJDR25Oakk0UHc5MjZjYjBkMFR4ekxUZmVWS0JucXQy?=
 =?utf-8?B?OXNMc3NFYXM3OFZPUkZBb0hBY2NlZTAyY2ZPWmFZR3lGZEUxeC80cnlBU25t?=
 =?utf-8?B?MmVLdXlzSGxEcTJaQTRqdUZSZnBXdE1ObkF5RWZwazlObjdnSHFhNDQ3djhE?=
 =?utf-8?B?VjB4b1FHL0ZsWXVmcTlPbFJId1h0R1Y0RXZUZUxBZUlkVS9QT0FDU2F0ZmRn?=
 =?utf-8?B?VzVmOElaU1hNUEpUQUFOKy9Sa0JOT0hqd0NlSUF0UXA4VzA5Q1g5V3FvU0kv?=
 =?utf-8?B?bFlpZnFCeXVUZXFUNk04SWJWTDEvQWJRb09ZdXl2VTdESWxDSlhzNTRUcjJq?=
 =?utf-8?B?U1RTOEdSWWtteWl6WHVkeGZsb2RjVUllaHR2RW9BS0VlWXlYaDVVWWc5aVhx?=
 =?utf-8?B?ekJYT1Foek1LajdybkZuL0pRa2JGUzdmVk1MTno0bUJOWlJOSnVud2RyODVY?=
 =?utf-8?B?eWFBdWFrM3ZwWTB1YzE4cVJ4NHI1YzJDSmNRclMyVHlOQ1RaUG9FKzhWeFBj?=
 =?utf-8?B?RTJaMDM3U3dzT1gveGFKN0FSMHkvWVpWOFFOOGEzNFpQekJrZ2lNRHI2SW9G?=
 =?utf-8?B?VkM4OW0wOFVhT0x3R1Y3OXdGT1lSY3hGVkpDSjBvMVU4cTZBT0pZNE9XWmRR?=
 =?utf-8?B?Wm5DaFVvaitDQ1lkSHAvV3I5aFBZQmlJSncwd1dFQVZUYVdtV0NZVXlLdzZy?=
 =?utf-8?B?bU44eFEzVTBLV0FjeFZxTkdaQTBqVmdXQWxYK2EvOEQwSk10M3N1c0hmMkNh?=
 =?utf-8?B?ZEFad2czbFhvSnJXUlFVb2tXRUYyTk9mV0J2NFpCV05DTUJXSEFGekVkWmNK?=
 =?utf-8?Q?Ou3WQFRd737iRFPIKW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7dddf54-841b-4765-3d01-08dec88a6b55
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 13:56:36.6509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVqQTvpBZD7/r7aqVrRr4c4P7rvrMJyYBahahqQzki6DgQ+gm3RYRHx0TwNpWMeg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6068
X-Rspamd-Queue-Id: C45381C000A
X-Stat-Signature: ctajtk8ii9aiqrgcmhrkxhbpdqzazwb7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781272601-721207
X-HE-Meta: U2FsdGVkX19MhtbggZOdECcrnuzTRkkbJnB3j9wFdRfZgfNiSXLMZOtRbfkkQzhqwD4LONJatX7GWCC8TdRxmQd8m6gU0MVqXSUXQNNzr6pNnKX5mdHVdn9mciTvNbMW7raxviK1V4FPhf29rUoR5T98Lmqt3yprEu6Its+7hl+gq+ginFdUXyoOJ5kjkDRxsVozEyyFCUOyaOHluc09QpFdeNIM6WVqp5gWDJscYtCeQZUyRFVfFCjgSc0WD8I6q6I+E9REcYFigPCMVhm661NBgSypTmvMfdw3GVEO3pWzXw6G6CjTeYhDfT19aZyCatowKjqXkasbw1nsssOqHUdTnrSMporRIM+jNF+URta4+aNv0BxFA6f2Bji33BgMI/h43VYRYkInd7MxFtnWRKoJEeSSgKMNwmCv6mkebODcFoxkoeX/FMCpETeALP5O0Z4h3P/iv7CUTWmNUXbmPs1SoG3mXHoHa2EjlqpBJVr9F7+UxHrBS+HG+IKCQNvUZZjGFhWcl3/Wk95+Ho97SgGseKcFTOCa62W59sjkNQrIcDmo00xNPorczxpb4uJ9hlrjy+uugqn3OIsmE6o/2y9QSUjYW4rm1DQIwKT6pQt/MYI2nDti4Omk4DDWN24FWxlLtOgiAdQzCOdZQSH8xx3h566QQfKa1Rpyhv4TQ7X781bZxZLNAoHs7g/IiBNddINuQxHwPMoE02N7+xdTa7upBumGwt5fJMis5pY3E8VZAtSdHpfqLiliRQ+o5SasHHz5BWLRGOzIb1YdPZeDkARiROhPE75jfclMdiXGVKSBx+t/O6VdjzXDJg2wo0BXQQV2TqvhwuNwTCpehluTDjihH5vUd0AWjHZQOrh8PD9J43AsacABY7MYqf7JPmcYdtPBg0bFGoafqePNXSHl7Maq3EbedGz0olNaPPtUPboIr5ABd9yynQT6SQta3EbYSWipoBC/NtMiHeh8ex6
 tUyfWdyO
 xFQIOnwDUG1STrZv5ZZV4/WWqiuPVkPCFh88N6wV8lhLXvboqcK5v8tKvnrKEayqJcych53iiKNri/oJadM/uynM7JqrJbxztZ9vJglPgdY5/dJWjvoBhbsEtTEbvuh+3tSva0BOVtHzH81ZEZn9AO2jBISvpM8Ga9W6roIPht0TlaXpRBOwtbjQZd+sqnYNkuZ2CC3nyOiyh0OjCKiPWxZZ0mYAXjh58uu72lu4Rs3o+wdVmES0DhofVQxZx4kpjC5+JFANf94uefovaM7a3zCUjuhF51YKIs5vkOBT5W0kxTeiPBa7mAzyMF9+a48c21O+wsL9p3553n4djIt9F5pR1GjLJE9ZR2ica2ncH4c6CV7aWFiz19d0lrK9aN1b8sDTRo7NYl2mBXMICFW9//SzaiS1zJ91d9U0PC0nsPLEce6lDewZrLCPtbNaMq/8mrmzBlX91mKSNW4o4P0/9QJGxeJTGy1k79BzHjhlmmzEJheoVo5obFcprQpHBr/8mZFRh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Jun 2026, at 23:14, Zhaoyang Huang wrote:

> On Fri, Jun 12, 2026 at 10:46=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 11 Jun 2026, at 22:34, zhaoyang.huang wrote:
>>
>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>
>>> The kernel panics are keeping to be reported especially when the f2fs
>>> partition get almost full. By investigation, we find that the reason is
>>> one f2fs page got freed to buddy without being deleted from LRU and the
>>> root cause is the race happened in [2] which is enrolled by this commit=
.
>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: rem=
ove
>>> non-uptodate folio from the page cache in move_data_block").
>>>
>>> There are 3 race processes in this scenario, please find below for thei=
r
>>> main activities. However, by further investigation over the code, I
>>> think there is a common race window for the truncated folios between
>>> split_folio_to_order and folio_isolate_lru, where the folios lost the
>>> refcount on page cache and remains the transient one of the split
>>> caller, under which the folio could enter free path and compete with th=
e
>>> isolation process. This commit would like to suggest to have the folios
>>> beyond EOF stay out of LRU.
>>>
>>> Split:
>>> split_folio_to_order() can split the big folio into individual pages an=
d
>>> put the resulting subpages back on the LRU.  For tail pages beyond EOF,
>>> split removes them from the page cache and drops their page-cache
>>> references.  A tail page can then remain on the LRU with PG_lru set whi=
le
>>> holding only the split caller's temporary reference.  When
>>> free_folio_and_swap_cache() drops that final reference, the page enters
>>> the final folio_put() release path.
>>>
>>> Truncate:
>>> The changed code in move_data_block() lets the GC path evict the tail-e=
nd
>>> folio from the page cache through folio_end_dropbehind().  Once
>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
>>> page-cache references for all pages in the folio are dropped.  The foli=
o
>>> is then kept alive only by temporary external references, which allows =
a
>>> later split to operate on a folio whose subpages are no longer protecte=
d
>>> by page-cache references.
>>>
>>> Isolate:
>>> In parallel, folio_isolate_lru() can observe the same tail page with a
>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking its o=
wn
>>> reference.  If this races with the final folio_put() from the split pat=
h,
>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
>>> The page is then freed back to the allocator while its lru links are
>>> still present in the LRU list.  A later LRU operation on a neighboring
>>> page detects the stale link and reports list corruption.
>>>
>>> [1]
>>> [   22.486082] list_del corruption. next->prev should be fffffffec10e0a=
c8, but was dead000000000122. (next=3Dfffffffec10e0a88)
>>> [   22.486130] ------------[ cut here ]------------
>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
>>> [   22.488539] sp : ffffffc08006b830
>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000=
000000000
>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffff=
ec10e0ac0
>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000=
000000122
>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc=
080061060
>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000=
000000058
>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000=
000000003
>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8572=
1f0e25f00
>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645=
f7473696c
>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000=
000000010
>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000=
00000006d
>>> [   22.488647] Call trace:
>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
>>> [   22.488661]  __folio_put+0x2bc/0x434
>>> [   22.488670]  folio_put+0x28/0x58
>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
>>> [   22.488689]  f2fs_gc+0x230/0x9b4
>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
>>> [   22.488725]  invoke_syscall+0x58/0xe4
>>> [   22.488732]  do_el0_svc+0x48/0xdc
>>> [   22.488739]  el0_svc+0x3c/0x98
>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>>>
>>> [2]
>>> *F: big folio before split
>>> *T: tail folio after split
>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (=
folio_isolate_lru)
>>> *F: pagecache refs =3D n
>>> *F: extra refs =3D split
>>> *F: PG_lru set, mapping !=3D NULL
>>>                             split_folio_to_order(F)
>>>                               folio_ref_freeze(F, 1)
>>>                               ...
>>>                               lru_add_split_folio(T)
>>>                                 list_add_tail(&T->lru, &F->lru)
>>>                                 folio_set_lru(T)
>>>                                 folio_unlock(T)
>>>                               /* T PageLRU set */
>>>
>>> *T: pagecache refs =3D 1
>>> *T: extra refs =3D GC + split
>>> *T: PG_lru set, mapping !=3D NULL
>>>
>>> move_data_block()
>>> folio =3D f2fs_grab_cache_folio(T)
>>> ...
>>> __folio_set_dropbehind(T)
>>> folio_unlock(T)
>>> folio_end_dropbehind(T)
>>>   folio_unmap_invalidate(T)
>>>     __filemap_remove_folio(T)
>>>     folio_put_refs(T, 1)
>>> folio_put(T)
>>>
>>> *T: pagecache refs =3D 0
>>> *T: extra refs =3D split
>>> *T: PG_lru set, mapping =3D=3D NULL
>>>                             free_folio_and_swap_cache(T)
>>>                               folio_put_testzero(T)
>>>                                 /* refcount: 1 -> 0 */
>>>
>>> *T: pagecache refs =3D 0
>>> *T: extra refs =3D isolate
>>> *T: PG_lru set, mapping =3D=3D NULL
>>>                                                                   folio=
_isolate_lru(T)
>>>                                                                     fol=
io_test_clear_lru(T)
>>>                                 __folio_put(T)
>>>                                   __page_cache_release(T)
>>>                                     folio_test_lru(T) =3D=3D false
>>>                                     /* skip lruvec_del_folio(T) */
>>>                                   free_frozen_pages(T)
>>>                                                                   folio=
_get(T)
>>>                                                                   lruve=
c_del_folio(T)
>>> later:
>>>   list_del(adjacent->lru)
>>>     next =3D=3D &T->lru
>>>     next->prev =3D=3D LIST_POISON / PCP freelist
>>>     BUG
>>>
>>> Assisted-by: Cursor:claude-opus-4-8
>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>> ---
>>> patchv2: update codes to eliminate bad page status
>>
>> Please do not send a new version until we figure out the actual issue.
>> And this version still has other issues, like unbalancing LRU counters.
> ok, I just think nobody would respond to my latest feedback and want
> to fix the bad page status.

Please be patient. Wait for several days if not a week.

>
> I would like to explain more about the current scenario by taking
> below codes as examples. move_folios_to_lru have the folio be set with

Before you continue to point fingers to different code, please clarify
the context for this issue:

1. In first paragraph, you said the issue is solved by reverting
commit 9609dd704725, why do you think the issue comes from MM code?

2. You mentioned that the issue is from AOSP with v6.18 kernel, is
your patch targeting v6.18? Is it reproducible on upstream kernel?

3. Can you provide your kernel configuration file?

4. Can you share a reproducer program for debugging?

Thanks.

> PG_lru before calling folio_put_testzero to ensure there is no
> free_page without holding lruvec_lock, which is similar to this case.
> free_folio_and_swap_cache within __folio_split has no synchronization
> method with folio_isolate_lru which makes the bug happen, right?
>
> static unsigned int move_folios_to_lru(struct lruvec *lruvec,
> struct list_head *list)
> {
> ...
> /*
> * The folio_set_lru needs to be kept here for list integrity.
> * Otherwise:
> *   #0 move_folios_to_lru             #1 release_pages
> *   if (!folio_put_testzero())
> *      if (folio_put_testzero())
> *        !lru //skip lru_lock
> *     folio_set_lru()
> *     list_add(&folio->lru,)
> *                                        list_add(&folio->lru,)
> */
> folio_set_lru(folio);
>
> if (unlikely(folio_put_testzero(folio))) {
> __folio_clear_lru_flags(folio);
>
>
>>
>>> ---
>>> ---
>>>  mm/huge_memory.c | 22 +++++++++++++++++++++-
>>>  1 file changed, 21 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 970e077019b7..c24c12f71157 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3878,6 +3878,23 @@ static unsigned int folio_cache_ref_count(const =
struct folio *folio)
>>>       return folio_nr_pages(folio);
>>>  }
>>>
>>> +static void clear_dropped_split_folio_lru_flags(struct folio *folio)
>>> +{
>>> +     /*
>>> +      * __split_folio_to_order() clones these LRU state bits from the
>>> +      * original folio.  A folio that is dropped instead of being adde=
d to
>>> +      * the LRU will not pass through lruvec_del_folio() and
>>> +      * __folio_clear_lru_flags(), so clear the cloned state before it=
 is
>>> +      * freed back to the page allocator.
>>> +      */
>>> +     set_mask_bits(&folio->flags.f,
>>> +                   (1UL << PG_referenced) | (1UL << PG_active) |
>>> +                           (1UL << PG_workingset) |
>>> +                           (1UL << PG_unevictable) | __PG_MLOCKED |
>>> +                           LRU_GEN_MASK | LRU_REFS_MASK,
>>> +                   0);
>>> +}
>>> +
>>>  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsi=
gned int new_order,
>>>                                            struct page *split_at, struc=
t xa_state *xas,
>>>                                            struct address_space *mappin=
g, bool do_lru,
>>> @@ -3958,6 +3975,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>>>               for (new_folio =3D folio_next(folio); new_folio !=3D end_=
folio;
>>>                    new_folio =3D next) {
>>>                       unsigned long nr_pages =3D folio_nr_pages(new_fol=
io);
>>> +                     bool drop =3D mapping && new_folio->index >=3D en=
d;
>>>
>>>                       next =3D folio_next(new_folio);
>>>
>>> @@ -3966,7 +3984,9 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>>>                       folio_ref_unfreeze(new_folio,
>>>                                          folio_cache_ref_count(new_foli=
o) + 1);
>>>
>>> -                     if (do_lru)
>>> +                     if (drop)
>>> +                             clear_dropped_split_folio_lru_flags(new_f=
olio);
>>> +                     else if (do_lru)
>>>                               lru_add_split_folio(folio, new_folio, lru=
vec, list);
>>>
>>>                       /*
>>> --
>>> 2.25.1
>>
>>
>> --
>> Best Regards,
>> Yan, Zi


Best Regards,
Yan, Zi

