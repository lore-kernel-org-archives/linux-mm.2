Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB7C1067031
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 14:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA676B0092; Thu, 12 Mar 2026 10:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A9B6B0093; Thu, 12 Mar 2026 10:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A846B0095; Thu, 12 Mar 2026 10:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E71486B0092
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:11:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B6ECC15DB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:11:55 +0000 (UTC)
X-FDA: 84537599790.18.7BB789A
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB01720005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:11:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bRnnDHW0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773324712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1MUW7Hu9ac+2a7jnAjehlB/i74eUD2gu/1p05+12Q4=;
	b=ti2rfOwujp5XXiZTOXXACbjltg25uY9jF1alT9rw29AFfG87u9YvzoSKARYeZZRG8+KTjp
	UVnZLfehsvOJcq3AaXWuFmekL31vMJ9Ok7y/J3VdwqzSDzIBVNt35n0Ym5LuHxb/Q/6Xm8
	MchPNDDIsX28/dMTQKuIOqmSCSIwCeU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773324712; a=rsa-sha256;
	cv=pass;
	b=EZccOcfecuj5EN6RrviZmi0WOb5dPITnXH5AMkYqy0K9J4GiIeNIL+vazxK7390oTv8j6n
	O1MUKLv+JbydB2Vk9D+xK24bLtMka4Z8orKFl8LcL/Z+96TaLlkWGaaFujxCyLF2X1OdtU
	hX+KE1wbgZwUvOkedbT//nNcGmn3VhI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bRnnDHW0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GmWuDNKL9cwfzww1bGEboytwMwGp1OsYi313XRBtai+mMVgWKq0F0u1ad93LyGup2duJM0Ipxz1+BWxXnCnlVP5XRTDRbTFkSAweGRTOJc/HuhabQh05vKMpKncub3BgzRn3hYQJuPWZB9Yqa/dDh8uOflKtQv0UTw+AVQO/gZOys6BhRYkSt1S4X1UdaQ0pgj0VbINe62rEcGUsa12odHqgEqBX2JyBdFWbtHF4zztpue3bqZ9ybLsXT85TrZQgWDM7ECJZ57QMZEmBlvSBDxZ0bDbl3Uo5Y4I3Q4WFKOluSHsjT6GiVZ1TSqrLaiSlg+NbIxLFOrZATnyYXu9Cbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1MUW7Hu9ac+2a7jnAjehlB/i74eUD2gu/1p05+12Q4=;
 b=oIRVtiYCvC4opiQI8ZSXgezZDRMiSruVhFqRJKRH9tztZIHF7hfjIdApUOKKfwXu2aAWDA7SRRBrbXSp4idsAuVg4536pb0obj+mY/nBfAV8EEPkAtmba50JQ1PdkwvOe2h+TcgGUoftdPpGdxvCm+Z6BA3JnfJ8qAQ2+kq89vxVts7uCehaJk1ZqLRx8z/B3s1YbuthW7GrQBB1UT5d2yjSv8a72DmHONIHVkzFAaEoqbYrpqpeaj6T/ZGhfNPPxbchBjDgenS3U02uPyac6Bplr0kMkzAzs0XBAGFMRzkVrOSXBLEnddpBNKBCwI85YO4v3zNhRJt0zPezw2ibyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1MUW7Hu9ac+2a7jnAjehlB/i74eUD2gu/1p05+12Q4=;
 b=bRnnDHW0BTxr6yQ6G3NQoYqi6MqzTYNLAbP/Gu66vSn02Bh+8/7kNkQ66XGRm4WrFo3lA6jBtASsp0y3OJlOB6FEttm+/Ce6SgDog3R1N3znIbK5cPFQEXGd8Mgowwf3gtqTX0btMF0mA8XXH96plf22OvLx5eX+R3IILt2a4Nu8NZ4DVZ64qA8JgGNPAmqPcfMAAhyuxkILusG9NP5wtiERj2QdxUI1M6Zq7yd0Ir0Vz0mPHrh5e2+G5NShmLCP28ABp1LdQk8e1vSkv9ZFvPi8RgnhbAMYjFX+gPnpaKVQIyJPojsmSqO4c/cQSDhqkGeXIJz696+WfmrzqOktKA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV2PR12MB5944.namprd12.prod.outlook.com (2603:10b6:408:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Thu, 12 Mar
 2026 14:11:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.000; Thu, 12 Mar 2026
 14:11:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 4/4] selftests/mm: transhuge_stress: skip the test
 when thp not available
Date: Thu, 12 Mar 2026 10:11:43 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <7580BE12-F593-4A39-ABB1-302A1951663B@nvidia.com>
In-Reply-To: <20260312114027.634559-5-chuhu@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-5-chuhu@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV2PR12MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cbd33cb-d611-4b12-11f7-08de80414c06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	LqfSh1Q4b37dQimgvrlER0G132N1eJ0pFk+MjFDgwsWBKELkdug6ZN9w4EmEpwboDrCYkO4G3HsRUZSsYMnUvrSBrVcIF+BlG/XHHJoxXzwn74C6FXJC6H/X5iwvADzIcY+kgpAmhQK+24AwRRbz+oEjejIQ8n7r4ZmtNGNbFoew6h5EPfIy8pk6wv6/t5zmiWninDcqxrsTGAKtWeI4K8WLmEMcoK4Jsj/Twjo9G1jvCLHGCyWi8KtkLGLEtpSnkyDFj9mC0hmrt/JGwrUHotyVuNVNKFVUWS56r6dCqgs/iovaVJ8tDmm4sMOlKvoyOu9vLNmSAVv3D/GifaHQ1/SZnaj+8j9dOwTfUEsLd6I7Zeh3zZNfxKCh7T7SoImKjQfNmm4GhZ34JTzGwxDass9hGPEofwh/0mguo0KzYNLk5nd/I+pJjVsX+n6BuXPSVbGQXanNktY7xOm0EUo41QsSaToz8FRD6awcvz7l2lVMZQMe+y3Aq7fpaqdUVFMLeUXyyE9S0RJ+URSnwN9UtyVNM48D7A59yI0IcDHmxhm2oLzalwCxWBNVVyTliIzfAxp10eVbgxUusNpSG0VkIUyLYLc6SSJVkafKkfFYw81LNQ1ALSklMqaHfO3P4hJ7qbqhtwpllRMRq6Uy+HiLb3VR/NEZ+V38+VGZIGyItOmpz113Ig/82Q8Z1PbBMrAM8SZSsj6Nc1yFhFvG4iG64zrR9Fp7ukdAdxTIl5ymcmQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dlnYk8cMk6NEZt/lMiddTtPnjdbZQtrpqgYkzzhMqDlC1FNuTDMU2t8FYqne?=
 =?us-ascii?Q?fPDaW5aBq3z8pwMXIZ+XkpHBNMpwR2aH2Omjp8C6RlJbRN3rPZbzZsZAXWQp?=
 =?us-ascii?Q?tDzu44xOTViSDyuyzqjsmqYVo3+FttumQrwmYk3a2QmKqm9BNqFSIvqr5iV4?=
 =?us-ascii?Q?87x4siFd1ugoxDZ7lGWGm/NYyiKrhTa7HgOGu2hpx9wihg2C2sFNKZTSQkIs?=
 =?us-ascii?Q?lpH4GIZk2ZthAMMLXsm+eiZyoOatFjDAWd9iPEytFTN0BkUGwPwH8W6VUt8y?=
 =?us-ascii?Q?g4sIcARrWO9AIiWknMCdPBd/O8bEQbbBPqHw0riu9pgL5WEHifbZXSnINLfN?=
 =?us-ascii?Q?T+XmvFmUkzNRIuvp2hD93hQH1zzccWLMEMnp3c8vmmwn+G/vR7BXCW/TVo4O?=
 =?us-ascii?Q?2RbWHQ3B6cxNJVhR8PLVOFwquwawd2oupxC5KMZsSuVPTE2j3AaNerMpREP7?=
 =?us-ascii?Q?joV9V+Zo43DaoBL/xs+vJhkGHogkC8EHLJ4IWrUUafmtTRixqdvGoDTvuDon?=
 =?us-ascii?Q?qDX5uztmBWmDxafYYnqj1kXCFEiOIHCfdV4+Vlro6u1BNOIJull30iH5jzKl?=
 =?us-ascii?Q?mYmqGRyWvx1ozrzIcuMTk+wTia5/B2R2WHHMGKVQK8UzXEv57EzuArnOlVFO?=
 =?us-ascii?Q?DbdJuReGeVHJSX5Mn87whgQuHqWar86pDXcyhTYYOzDNqcmnvU30oqTjFm6V?=
 =?us-ascii?Q?qE1MiyDxEx65mcYZpQ2gYaemM585iBJMqgeVXu8k94EIAmnBimijQq0q0NRK?=
 =?us-ascii?Q?v/vprrRzyTA69uzuNkwzg8o6w/hT7pCGh0nSuRcQukVSywFdsdp2/xDNmdsM?=
 =?us-ascii?Q?HdD/z5BiujVmOVLq0F5634ulJyz/J4kayMEUkKsiLw5tAe+EPuiyA9Go0zkv?=
 =?us-ascii?Q?38RDtRlVV1BkJj5kmDzG1IWQJsFohjAgdeLMXXGOPTmtiqqgwO2k7naP/jhU?=
 =?us-ascii?Q?5RnjOfE1ms9X8Sjuf/Qo3oSJ++bhERlEpiWhFKPd/lxsyfZk1ALWo1N4kjJR?=
 =?us-ascii?Q?2RH7bMbGhXp/HgI+acu0iLfLlgo20N0wpiUKRB6Rd96KQO//n/6UDvIo7kVk?=
 =?us-ascii?Q?3xkxLLmESk3PbnQ7RFItQXFyMBqndK2fbfXIC7dVB9BE0M7AWmmitxZvruMc?=
 =?us-ascii?Q?uvD39Gme5IIt8e5j+2r/TsrwmgUJNKLfYILjwC05hgCaRO+d4C8bNjG1Zi6N?=
 =?us-ascii?Q?xC05tZSO+KcRE/A+c9Nz88aHu7523DFxTled7lcZzP8AOPyHaXPaWz40sV1Y?=
 =?us-ascii?Q?q6nVocJhuUvw7viruePmTrLOpqEOba0tzB0Srh/pNnnndQhTwd0Kahsx7cS0?=
 =?us-ascii?Q?5QN/CbPHmkY+TdbVZ7yUUXCYs3RFQki4jM6LGB2V4ouf+I3nxfAzuvoYLXrh?=
 =?us-ascii?Q?PDiSjlI6Wj9w1KUoegF6LtIZgaDBHxfIkthPOIZeRut7SI5TARtxtWSiue98?=
 =?us-ascii?Q?l9tmGOTQWXHs3xC6+7G4Z87yfuGKnCCigVC+W1WeXGQSUEGOvIQpzYE/y/jm?=
 =?us-ascii?Q?AEoWV7PhJlidnyFAbfFz2e3F3w42rx4txFDXn2rVOwtBSlm4FTeBM001mD6l?=
 =?us-ascii?Q?kJjeYbtSZwQbEHnpMXggiqNEorXNkseD33trcwzDFqUMUNhzoIX/FzLZW67I?=
 =?us-ascii?Q?VHAjFwL1ZmDXSF0OfmHaa3vMjDOyUXO/2P0HWJYXjdqsj+GN1iXX7c9h0I5Q?=
 =?us-ascii?Q?sgmxXi78c6RG6OHO5epFZhhpBVbDbS/AygqoBd3IX+yAsl6c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cbd33cb-d611-4b12-11f7-08de80414c06
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 14:11:47.1231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usmAFkJChZXG4aZKGxNNyscTMspRJyVvTAa/VA4NXHK+mo106oG90fNr3gB0ouW7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5944
X-Rspam-User: 
X-Stat-Signature: 79akthhgmwy1qzxhbm3r16hzh6exjix4
X-Rspamd-Queue-Id: AB01720005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773324712-400185
X-HE-Meta: U2FsdGVkX1+sozYQsg8EfOsKex0eJK4W8X/3GNC8/RLFEw3kCNxz19c9fE7x+IzGQfbonCGuFSH7Hph/Qrk+TNH4mFHoXBDtYAyqKi3N4R1sMbCJ3pzRYDnyKn1L4MVO8dtcVVrZhV37Ta1L1OZ9/NX5xtoNnX4MjVSgK0wPAr3vq+HFpOprcZqsZUS48XUkOrlDw+LvvBEQ7T0YeUQTwkqqcEpiKIuYVQuzWPXLW50q4e++nuRgml+1ZKEtq6ArM/gMZOqM2xr8J0wD/612IgwRw1bSu2BYv5lUhZ67klY6i+Acuhwbo/BjaSQdNrDBgw04/NaOVnjUdwK0W1LUOU8ctNZ396DAcp/AdrtKOXhlqsIwVKYKhgpwu6rCYrnsbuP4BaJ3LWbVkUHoHS/IHzIJXh6KUvlFnwv86RtlLsPcnOQ/nqk7/FlKPwqr/ARQtNT1YWbJ+Avp4M7JQgiHHKhsPOd+qfmcqJn2yN9X4jKk1KZ4DkLrfL/GCuPsmk4Xgm5DYImwdW37KcfJBaImjZL1qYsJJxRy1V0FfvaCBxXCkDXhn1lolFRGy4/vOLUjrbT4hkelYZSsG1POGU9d7Xuy/qTv2QW6/m+u7LXUHdJ7pLbB4cKf6RuZETYOjMukYOlVNyVplQbfKirzEsdca4+lB+TkCLi4BmGHdoWuuhc79OOfV2m9oP25pjaS1xwgLeKjGeE1p5bnPlt1xJJ7j/D7s1Ar9boEJKmzLFmdeLUpBV7DAFNXVC28ejNcafTV24DuU/e6VI4lp16gTDnuRtIRk+Ln1DolYZ6QYYR4vuOoDpXvvYVCbljlNmXIyDKQUHE5iMPYdEkO77cj1HRE15fUySjaJrH2wewHeeWVy256nBLaJvQHCkvA1YvdOGrT9pwXoQ6MuumAQlsIcHAzTfaqB69vFeoRpDvi1q9e84NpQ3y9DT2U9J6No1oZtl6dn/GDShwAXjBHVMkpm+k
 5bi9Mqzx
 mVo/47Vpl4tmfdCRqQk10Ly/zb5y59PsC+U0b3gVcALU72tkLEZLoqx0kbHExHK3g0v1Y9Y2boF4FQjQRclD1I0VdVaFd0QH6ATn1u2sfJfXKakJ+8f/EdEKrCdkNXcnO+755QVhihX1xGDjwc0rQjmyJadXaXrjO+MhQ8aVAW7C7Stn+EtXwGvDvn1U0mT09L4ex12SewIdNVRU/fIoFNmEmz6W458WGsovUgSVyqA2uHkfDy2qZKkqcoUfyUhWB4bxvJhJQA9QAx2rHd+XS6lBTw2LG1QsJzhR3A9jWiaCIMpJy2c91sbxkzU/tqMlEhAxYKDeksIgBX2QD44nwxQ27he7IdKUEkKdleiQ1qE3yTd6mVIybDVph+kBqimz7k4o10Nff56gwuIaJg7+FsMbGnc0p2KPDJAFkdq3hBFaAdBMA3jS4wLncbycVKvbNhrePXYcTTX7jkcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Mar 2026, at 7:40, Chunyu Hu wrote:

> The test requires thp, skip the test when thp is not available to avoid=

> false positive.
>
> Tested with thp disabled kernel.
> Before the fix:
>   # --------------------------------
>   # running ./transhuge-stress -d 20
>   # --------------------------------
>   # TAP version 13
>   # 1..1
>   # transhuge-stress: allocate 1453 transhuge pages, using 2907 MiB vir=
tual memory and 11 MiB of ram
>   # Bail out! MADV_HUGEPAGE# Planned tests !=3D run tests (1 !=3D 0)
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 60 transhuge-stress -d 20 # exit=3D1
>
> After the fix:
>   # --------------------------------
>   # running ./transhuge-stress -d 20
>   # --------------------------------
>   # 1..0 # SKIP Transparent Hugepages not available
>   # [SKIP]
>   ok 5 transhuge-stress -d 20 # SKIP
>
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
>  tools/testing/selftests/mm/transhuge-stress.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

