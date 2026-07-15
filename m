Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDE8C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F81B6B0005; Tue, 14 Jul 2026 20:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9E86B0088; Tue, 14 Jul 2026 20:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2ED6B008C; Tue, 14 Jul 2026 20:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA1836B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:59:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 278AB16056A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:59:10 +0000 (UTC)
X-FDA: 84989202060.02.26E4915
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3DBDC20003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:59:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PhNzckfc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784077147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAghJ2OszyZvYN3G0RSryBLUt+h4Sy23XdMDr72/oGY=;
	b=ZnIsDcqV41VmwgONzpr4rjDLbMRbUHWzFq4xcNJ3GhCySU6QtHXr2MaZqVlyCu1M+E86tO
	0YioeH8NRo3uAdJzeJvNRBq0jnXnP+2DHxlGcLjjQ5bAbIL3wdo89KcpxY299gNhhzmQib
	1dkZl9tGEItFETLRM+lUufCDudXaCNg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PhNzckfc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784077147;
	b=wloWCsPxagII+jAtivIvD6sNKlexBIDcePXB1jXU5bgzv64XqWIcJYZERZ6O5vRB646AoD
	BhsU7jkodr7ottC4Rb9pidbw/sbNMEGG3irFB+U1J3nT4HZIxlId9QhRihVjQX5uqqtI64
	PYzooNQKIpvGSoUw1E+N/plg5Y0Iz5U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fw4SGN0+ZCUq8gCBphNyh+BmY1RQrk5jHfeYxpCOkDGNatO9MNUWzlx7ow5m8qf9xZ4NlsCEpK9udy032+DQ3rZI//7u8nt1ObQ89mnLKzBUyTNTimIDduuDe/G1gEWmLntjR2DZHUyhsUknzsuDiUGdrI8No6tdJAADMRKYe2aNQ4pmc4h8FvqBO+igMQPG5riBZJ9DMAT+E2YUuBegwhYY3X5doXceBaGBty5NYPDj0qZCp2+3Ky7lhQezvR+9fP9HXXch6zRAG/GoyZLMiIP1LLCP0dvWqi+7R2kAI0k1INr+/SAnbxWSIATlaTsjlOW3QbLpeD+gKXOHtMBM3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAghJ2OszyZvYN3G0RSryBLUt+h4Sy23XdMDr72/oGY=;
 b=hw8yy4zg9UR5FutSqbNVRtX1nqyTDSh/oPPOmpGMBKGcjFzF+FbqEvP0deQg+AbuGBuSTDXyc2XbeAQZD4bvoDl4HnJRId6TzazQRDQXpY/Oh5+Zjz3C37UB14KiN9czy6t3pwCR7BZb4vRjVv/aVFGPrGbe/Bb4HIgcipy2UB3gTLMbcUZarwXosd3sj4Rg3CwfK3nqFxCdSWsshUsqGLwPQojsLxR89Wgyj81lIH3DOeOHdgHvXl+N9G85eMz7v3/LV1OJ9wOr9iTimgqmQVZ/BxIk/lxwkps/KPSQUZ0MmOcWgilShzId+7DQ4t8WtWXh3/Oy0l/CTs85twUmkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAghJ2OszyZvYN3G0RSryBLUt+h4Sy23XdMDr72/oGY=;
 b=PhNzckfcvRUZSTkCSJ/cYzniZdLYbsaVv4u5lFyNhR2kDgovrC/rKOeZPt8avKfOQlDQOKoPqfoXu4idFQgemTFnfqIDuhNgn8B7MG+pSoeqxvml7xbeJ5yak0oPaOyvPquGQTBhzaGftzg0vI9ewGUGwuyAia+CjndFFGgcFiX0ZlGaX4iW/fXzemB2A3oixw3Ykugl0AW7boNqJfnjnTUM0iRQWCjWFn9DUdBzsJ+rG584ViaTxMhFwHDMHcqGl4G5f0q4f3ciD15rw/pj50Mzmydc2bExfJTDy9WvbKu/N9zgTNIijJ8HRWdTRmoszYwn/U/6rS/qHvOmUa7UQA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8689.namprd12.prod.outlook.com (2603:10b6:a03:53d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Wed, 15 Jul
 2026 00:59:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 00:59:01 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 20:59:00 -0400
Message-Id: <DJYQKBV5C3WQ.2A702GAYGPW71@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Matthew Brost"
 <matthew.brost@intel.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>, "Kefeng Wang"
 <wangkefeng.wang@huawei.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Sashiko" <sashiko-bot@kernel.org>
To: "Alistair Popple" <apopple@nvidia.com>, "Balbir Singh"
 <balbirs@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
 <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
 <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
 <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
 <A1606A10-AB38-4101-A058-8355E5E81C47@nvidia.com>
 <57cc487b-6ec3-4ca6-8735-f37644e2b0ab@kernel.org>
 <F14401B1-7388-4C5A-A19F-E031002A76CF@nvidia.com>
 <alVjyqWiAggf1mTG@nvdebian.thelocal>
 <aaab69a7-d1f8-4fba-be13-6de109f37348@nvidia.com>
 <alXFS7BJWLwH6Wpt@nvdebian.thelocal>
In-Reply-To: <alXFS7BJWLwH6Wpt@nvdebian.thelocal>
X-ClientProxiedBy: BL1PR13CA0426.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8689:EE_
X-MS-Office365-Filtering-Correlation-Id: d4435ae6-601e-4119-46de-08dee20c425d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|18002099003|22082099003|6133799003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	AJvzcAP/ItL0jYYH9WZCGMmNfcyIfnPhwPb5mnvdw/F0XtvB9Uc/bfXpL8t5O5ukjOVuUcELrg2n/xhahAv2yfkViuD3w2Aap1sB3T/W/U1TtoQovZAXXmW4bs6aRACXqOVG2CSPIQtzHyDZLj7M5zIFljpmH37pNQectjh7WK/mwDTs1sniRP3ub3KDzR7fdXX+zkBNmk6t05Drys+Tw2Jf+RQDcJJVu1CdvhKjJ/d7tGVX5zt9d3JxZRdnQUcCXAIhAjIwS6KPe0Yt+3gPLd29407i4yCzCytZVRIOVuIiWio/g/KnOy6U1GUngaScsKT2ZQi3gHOd7PPu8UdcjvR2c8dSqx+QaOsPC5I/8wGamnegLI1gy5ZKXZSjZsU97hD/oTbvFQrXc5NX93HapSGGsZJVm/QJEsKHoEqGHIJBofk3SHdBgtIX4cKzw0/G0se3R1wh5Xvt8sAeQTwoU2qxwsvrLz6qt7kwnlALG5hXRntaX4hKQ6Ua90aGcokGmttTzFKH6thZjQd/82rUEACNZEHtHyOgaK24nBk0otUCwcIr7JpqaFDQD2t+gvlRRHK340BIx9lfYs2CBUq640ni0Rdrk2HPZnoQM9dnteYBN8GPWeUGfshZqNhmXG7Zdkb/Z8scQOlYdAY/3psGs2OZsrljYnGLNIYh4PG8zGI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmhpYm51ZFFReDVZUHRYc3paM25xNXFncGF2cFVtRjdaL2lpaDR5eUV2RDdY?=
 =?utf-8?B?Z1l0amMvK2pVYW45MHc2UzdEZE9xSlJvY2tkUUNKZXF1SFdZZnZmdVBTS1F4?=
 =?utf-8?B?eTd6V214MUZaNHFnaWIxVS82M1RtS3NIS1VJaUtmdE5Nd3RhNGZSUFhqMStV?=
 =?utf-8?B?TVY5R0ZWSkJDWVcyTm16RUFOZnRJZTg4UHhrNHlDL3VhTzc3NGZ4MkpxVThT?=
 =?utf-8?B?RmlveFNHWk9DbXl6S09keGtNNUdmdWwyUjlSb3VzSlVYa2YrclRsT2ZxeWFI?=
 =?utf-8?B?d1RHaUEzRVJva0lXNkYxVElud28wT1ZSZTE0QjYxSnN3cVVUSTNnTzRlL2di?=
 =?utf-8?B?OXhJRmUzZ1FnWWFicldaaHROZUQ1cEtMTjhWY3djdm55c3VJZHVvNE44M3Aw?=
 =?utf-8?B?ZFYvbnZMeWllL0luMDRENU5GL2VJWjhGUGRoRS95cmhyRkZhYWQrNy95cFlR?=
 =?utf-8?B?cVFad01kYU1uZnlEbUVzNzhJL0xoS2JLeUJuMlhZR3RXVXpHdUJNSDh3dkx6?=
 =?utf-8?B?a0w2WmFwd3JHNlRsT0ZuRWNNM3dIcWtSTEMwOGJWTWJZazZ2RDhkanBoOUhK?=
 =?utf-8?B?QVpST09OYTNZY3FRY1pHWDM4cEkwUEc0LzhPS2VIdUlqM0ljL3hqMFdDbVVk?=
 =?utf-8?B?a1lvMGhzUXFVMGM0aW9aRUYzRkpkMWFoWW9UaGhxWEpYN01aS2JzQXJLV0FV?=
 =?utf-8?B?RjUzYVU5UmtiSlpaWVk0cWU3YldnNytwL0lzTTYva0d6Zll5L3g5VFhYZ1pG?=
 =?utf-8?B?K2JRY1Qxc3E2d3VWUWhHdS9YWmkxaUxGMWZvajhGNyt4WExmZldwdTdKSTZv?=
 =?utf-8?B?eVhXL1hIRU83QmJKbS9HNnlHbUxDdWFwOTQ5MUNjRVo5UndmbUhzODVjcnVq?=
 =?utf-8?B?cmpwa2JwbUdoQXZFdURjRThwTU1RWDBRVmJDaVNpMWxuYXBQejNHMk9HNTRw?=
 =?utf-8?B?eTBMMDR4NGFia2k5ak4zb0U3cG5TMStsbTZnbEZYTUxHWllEeXFWY0N2b1Bl?=
 =?utf-8?B?WHZZNE1RbWdPSURIMjVVUm5JZi8vaU9PRDVuUzA4OEcvWG50ZVpPdVZsSTFT?=
 =?utf-8?B?TFN3K2lZdG5BOWNHaHB1N0VldHd6UDF6cUFlcEc0Wjg1eEZvNzNSQVZxSEtv?=
 =?utf-8?B?TDVXZGprRWYxdm40aFF6ZnNlOVRINWhnTEp6V1JNSlQwUUZhZWovNVluRXd1?=
 =?utf-8?B?QlFiUkExT1B2Q2hlWkt2WDZjNGgxNFk3Q0JjeW9mdTNwY25TNjhjcmgrT0ht?=
 =?utf-8?B?c1BrbGpoSndXRlVHTnVxUlg4NkNzcis4anlSNHk3ak9tNWcwbjArT1d6M2Iv?=
 =?utf-8?B?ZVNITVZ2WFRBaWZXc0RhMlp5UHduNkx6OW1vNjVBblAyQzR0MjJIdlBYNm5y?=
 =?utf-8?B?Rm1Ib2NzRjNGYjlmZVB1TnFiSnlHeFdmekM4V2JyUlpUMXZqYU1OMkNocktz?=
 =?utf-8?B?NVV2NHBFZCtTQWR6QzFPUXdER1lnR3Z5OVJxSU5LSDRPMkZwWTdVeUJxUElR?=
 =?utf-8?B?QkNEM1Q5K3h0U3hVeTQ0MkZlYXhXcEh1Q2RjTkltaVBETmNYNm1nODhSSmpx?=
 =?utf-8?B?MEVjSGd2NmU1aGlTL1VKV1dMY2hleWhLbWFUU1V1a2NkZ3hacTVzR1d2NjhT?=
 =?utf-8?B?WFVhMDlCZEdib0hiREhkRytWSk55ZWllL3lEUTNXbFZwVW1UeHR6aW9Nejhy?=
 =?utf-8?B?QnFoTjBldkNiakdvUVhRRWduRENaa08rMnlZQ1Y4d0xNbmc3RU5mcTRqTzVM?=
 =?utf-8?B?cGV6NDdTb1U4dWIvQU82a3BHcUx6YnhVRDF0MWk4OHN4MjltK0FSanhRU2pS?=
 =?utf-8?B?Z0FrVy9CNm40RnFFK2NVaG5ETkYxZ001SUJob2h4dnV3aGlHcDVvVVhLcC9Y?=
 =?utf-8?B?M0VSQ2ozeTBTR0J1MTl3U3FzUWwrSTB2NzhncFpFNlYxMk11c0FIWmppYVpo?=
 =?utf-8?B?NGxRY1gyRTV5d3hqT25nSnc4alhsV21Qdk9TR3ZncEFmTlVaL2tGazU1VXlq?=
 =?utf-8?B?S3hjRElGSFNSZkJvTFNuN0JEeUVXUmVZS2RwMytBYTZlNXJkQzN1T0h2R01v?=
 =?utf-8?B?V0pNQUg0bjF3VVpIQTgwekh2TDUvSk5DT0dHTUFrMXZhazVrVHlXRytGaFNV?=
 =?utf-8?B?QnA2cWQxSUl1c3ltSUhFUUt5WlJLU3BTanJDTERSNUsxRlE3MytTbGJwajE3?=
 =?utf-8?B?WjMxbDRrNHpxVTEveDh5a0ZDcUZUaVp1SjNwZHdSREdZV1JGOU1XWXNLeTA4?=
 =?utf-8?B?bTJMNVhEMUt3bndWVmViQ1lIa2p1S1BDUTZwUzI2S256djVlWGcxZkl2TFRy?=
 =?utf-8?Q?5kiv9+QR36NYs4Zsl0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4435ae6-601e-4119-46de-08dee20c425d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 00:59:01.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBy11lPgAXuLYOtu+EUmJznNDREqTrOmAcRkprURJsoJx5+KLuV5i3oreP1+pz34
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8689
X-Stat-Signature: pi6ihzhkzmre3qi4pnm9y4jstsz4m8yk
X-Rspamd-Queue-Id: 3DBDC20003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784077147-815581
X-HE-Meta: U2FsdGVkX189AH0K8852QUN4F0dfYwzYHlpV0OSxKFqAKDh1mLgVLMNY8b8NlZEoGv5ZThMMQKaU9TaCvOnvop2tfptmPRUPpOqptFkDK+RYVL5RBGGSMkqFdo1gniJfp8ZpJK/8ie1c62Dr6HBdksol01Vs7YyTVntTdLMwKcsWbFTn7lY17+ZWH9oFe0skYl2qAEARZauXSIWWe6C+wCyeYYYr8+mfsbEsRW/ukv5LTPSGW2uZqe9Vza6gV4mpQyXx3eroXwWabizXbgmFptFGs/+5a5vuRuBbONi9uJ9djCFTUibVKIxjWczHjwSdgBi0GAjQlFTmEYIVjvvVhmurHFaBkgIt00jIxfSvddwI84Ov3Ss5XtotILHgZF3XD0ZwwBKAn57ZiSYrEGZF9Vq+IRgHR4iDUx2J81O7sUEMgVsrTSDSggJS+r4l1oGol0vQ+q3RdqcWSga6HP+6kln4UXWqcgRQvfyrbkxWmrvb/DpD75ytOZR3LAzLVIYE4Kp3gTl/9GMX20b0b8vUCz2P/NTUfOj38XiCItzHGNpgJqdE/FeySFPyCV5PFPiEdB5adfbOiyS4ByU0VxnxmAPyE0J9JorWYHIT9N5xKdvVqv3cdtbs78tXMLrTy7nHsQ1hs8N3vtr5CXfASr8tZLhYYtZGZmAN7cL93ZwPtKlzcCAwPa74i/hDwE1xll5Lu7ltBLJqglTP/4pJRu+Bm52D4jrxxBoUC4I6HRUgQJzg3GMCSJFsiChaxF+HNCYbkCZggA5hZ1WwI9xOZESONnNEkJ3DDHUZhdVgupOlqNiWpmykhWpmGaHCfekiYSuH8T1boLaHzdHdRtZXSnTAXJwAu5lJOnhIhPOg4berBEjswHPloIAIph5rtXOlbkSr4zz19beQTJ6PcusGdOLkxYj0ZzxENAQtowhDOhVoIVQXoyU8FsevlRxv4fHb61QkBEwOKqMhJ0kUUL8NGpB
 vQOkPkQ/
 NiGKHiP64JRJorD75dZBqF7lEkmb/E+/2cZUMlpXQ18hqY3arcR73hlu6aTaZMNGw0nNnIJ0kf4axu/Zmsh/CqOW66VX2gp1vCzrh+WxeeyeGEiaAuRRg7uA6evax6poU2Asmf3fqXxQDxuVgcuMK8S0KjeA8EJUFtiOwpL098A8QZFPsR/aK54koEoxEVobedjk4rfvpgdKMVldorODwBC0BOBwY7Zm+7MMqGuy/pMSyr+Ivi5d8I6K1n0iGYkbtjLHZyCskscBoAffddqU5w9qsfSwuzP6ximBs7QE0tu0po+r81WG3kO8vjbTCFbGMv1BwRZqHsvELp0Hccwyoy+KkjR5fDmPAdDSnobcrITwMIvrf8KO4MVSvifxZSyYSsqQ5jRLdNBrHJoBfmM8dbtuwTblqQ+qt7q3YPjbAcnCNmtxk6TB3Ml6Klox9NrMAvTOLwiK0x3I+TUfKGnccwbLZsb3gop45JgM+skwvtvGA/FUyimmk3WW4wkUGwGAkvDk+6VIZUtWpDMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 14, 2026 at 1:30 AM EDT, Alistair Popple wrote:
> On 2026-07-14 at 10:10 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
>> On 7/14/26 8:24 AM, Alistair Popple wrote:
>> > On 2026-07-14 at 01:39 +1000, Zi Yan <ziy@nvidia.com> wrote...
>> >> On 13 Jul 2026, at 11:25, David Hildenbrand (Arm) wrote:
>> >>
>> >>> On 7/13/26 17:20, Zi Yan wrote:
>> >>>> On 13 Jul 2026, at 8:57, David Hildenbrand (Arm) wrote:
>> >>>>
>> >>>>> On 7/10/26 17:35, Zi Yan wrote:
>> >>>>>>
>> >>>>>> Not all the time. After a folio split and PTE lock is dropped, th=
ere are
>> >>>>>> different cases:
>> >>>>>>
>> >>>>>> 1. no page table change, the collection grabs the PTE lock and co=
ntinues;
>> >>>>>
>> >>>>> Yes.
>> >>>>>
>> >>>>>>
>> >>>>>> 2. some PTE(s) is changed, the same as 1 and the collection conti=
nues;
>> >>>>>
>> >>>>> Yes.
>> >>>>>
>> >>>>>>
>> >>>>>> 3. the PMD pointing to the PTE page table is changed to either a =
leaf
>> >>>>>>    PMD or an invalid PMD, the collection cannot grab the PTE lock=
 to
>> >>>>>>    work on the remaming PTEs, since they are gone. For the collec=
ted
>> >>>>>>    PFNs (they are mapped more than once) and folios with elevated
>> >>>>>>    refcount (they are mapped once and unmapped here as an optimiz=
ation),
>> >>>>>>    they will be processed later in migrate_vma_unmap(). Since
>> >>>>>>    migrate_vma_collect() is best effort, there is no need to reve=
rt and
>> >>>>>>    try to recollect from the beginning (to get that possible larg=
e
>> >>>>>>    folio or skip).
>> >>>>>
>> >>>>> Yes.
>> >>>>>
>> >>>>>>
>> >>>>>> BTW, recollection will be more feasible if migrate_vma_collect() =
does
>> >>>>>> not do unmap singly-mapped optimization, since in the case, no PT=
E is
>> >>>>>> changed, we just need to reset migrate->->cpages and migrate->npa=
ges and
>> >>>>>> restart from the beginning.
>> >>>>>>
>> >>>>>>
>> >>>>>> Right. The PTE page table should be gone and the original PMD, po=
inting
>> >>>>>> to the PTE page table, becomes a leaf PMD or an invalid PMD, sinc=
e
>> >>>>>> someone changed it when the PTE lock is dropped.
>> >>>>>
>> >>>>> Right, so I guess we'd have to remember how far to rollback, and r=
ollback would
>> >>>>> mean resetting migrate->->cpages and migrate->npages.
>> >>>>
>> >>>> For case 1 and 2, we do not roll back. For case 3, since the PMD is=
 changed,
>> >>>> we just roll back to the start address and set migrate->cpages and =
migrate->npages
>> >>>> both to 0.
>> >>>
>> >>> Can't we walk multiple PMDs and have data already in there?
>> >>
>> >> migrate_vma_collect() is the pmd_entry of struct mm_walk_ops, so it o=
nly
>> >> walks a single PMD at a time.
>> >>
>> >>>
>> >>>>>
>> >>>>> And for the entries we rollback, we have to decide whether to foli=
o_put() and
>> >>>>> whether to folio_unlock() [fault_folio !=3D folio]. That's the con=
fusing bit given
>> >>>>> that the code is rather "interesting".
>> >>>>
>> >>>> IMHO, it might be much cleaner to remove the =E2=80=9Cunmap the map=
ping if the folio is
>> >>>> only mapped once=E2=80=9D optimization, so there is no need to roll=
 back at all.
>> >>>
>> >>> I guess most folios are only mapped once. Do we have any numbers on =
that?
>> >>
>> >> I will defer the question to Balbir, Alistair, and Matthew.
>> >=20
>> > Unfortunately previous tests that I've done showed the optimisation is=
 critical
>> > to performance in the common case (ie. singly mapped folios).
>> >=20
>> > I say unfortunately because I have similar feelings to others here abo=
ut this
>> > code :) I tested this a while ago because I was trying to clean up the=
 collect
>> > step by mostly removing it and replacing it with a hmm_range_fault() t=
ype thing,
>> > but the optimisation proved too important due to unmap having to do an=
other
>> > rmap/page table walk.
>> >=20
>> > I don't have the numbers on hand atm, but will recreate them just in c=
ase my
>> > recollection is faulty.
>> >=20
>>=20
>> I had a patch to add tracepoints to the code and some of that instrument=
ation
>> included this data. A combination of the trace points + hmm_tests will h=
elp us
>> get some data to start with.
>
> But hmm-test already has a nice bandwidth benchmark :) We just need to fo=
rce
> the slow path. That used to be easier before I simplified the trylock han=
dling
> but with the below patch applied I get quite a lot better perf from the
> optimisation. Note the patch isn't entirely correct as it assumes any loc=
ked
> page was locked by migrate_vma_collect_pmd but it's good enough for the p=
urposes
> here.

Thanks for the numbers. If I read them correctly, the optimization
has about 3x throughput of unoptimzied version. The optimization has to
stay.

I will try to come up with a fix that resets collected PFNs, reverts
established migration entry along with putting folio ref, and restarts
from the beginning.

>
> Optimised results:
>
> HMM THP Migration Benchmark
> ---------------------------
> System page size: 4096 bytes
>
> =3D=3D=3D Small Buffer (0.5 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.097 ms        | 0.120 ms        | 19.5%
> Dev->Sys Migration   | 0.061 ms        | 0.062 ms        | 0.4%
> S->D Throughput      | 5.05 GB/s      | 4.07 GB/s      | 24.2%
> D->S Throughput      | 7.96 GB/s      | 7.92 GB/s      | 0.4%
>
> =3D=3D=3D Half THP Size (1.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.217 ms        | 0.212 ms        | -2.1%
> Dev->Sys Migration   | 0.136 ms        | 0.138 ms        | 1.2%
> S->D Throughput      | 4.51 GB/s      | 4.60 GB/s      | -2.1%
> D->S Throughput      | 7.17 GB/s      | 7.09 GB/s      | 1.2%
>
> =3D=3D=3D Single THP Size (2.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.290 ms        | 0.506 ms        | 42.6%
> Dev->Sys Migration   | 0.095 ms        | 0.283 ms        | 66.3%
> S->D Throughput      | 6.72 GB/s      | 3.86 GB/s      | 74.3%
> D->S Throughput      | 20.52 GB/s      | 6.91 GB/s      | 197.0%
>
> =3D=3D=3D Two THP Size (4.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.634 ms        | 1.026 ms        | 38.2%
> Dev->Sys Migration   | 0.195 ms        | 0.567 ms        | 65.6%
> S->D Throughput      | 6.16 GB/s      | 3.81 GB/s      | 61.8%
> D->S Throughput      | 20.05 GB/s      | 6.89 GB/s      | 191.1%
>
> =3D=3D=3D Four THP Size (8.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 1.301 ms        | 2.593 ms        | 49.8%
> Dev->Sys Migration   | 0.541 ms        | 1.444 ms        | 62.5%
> S->D Throughput      | 6.01 GB/s      | 3.01 GB/s      | 99.3%
> D->S Throughput      | 14.45 GB/s      | 5.41 GB/s      | 167.0%
>
> =3D=3D=3D Eight THP Size (16.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 3.853 ms        | 6.119 ms        | 37.0%
> Dev->Sys Migration   | 1.731 ms        | 3.354 ms        | 48.4%
> S->D Throughput      | 4.06 GB/s      | 2.55 GB/s      | 58.8%
> D->S Throughput      | 9.03 GB/s      | 4.66 GB/s      | 93.8%
>
> =3D=3D=3D One twenty eight THP Size (256.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 70.022 ms        | 105.921 ms        | 33.9%
> Dev->Sys Migration   | 31.175 ms        | 55.393 ms        | 43.7%
> S->D Throughput      | 3.57 GB/s      | 2.36 GB/s      | 51.3%
> D->S Throughput      | 8.02 GB/s      | 4.51 GB/s      | 77.7%
>
>
> Non-optmisied results (ignore the THP column, I wasn't able to test the s=
low
> path so easily there so just skipped that bit of the test):
>
> =3D=3D=3D Small Buffer (0.5 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.000 ms        | 0.321 ms        | 100.0%
> Dev->Sys Migration   | 0.000 ms        | 0.276 ms        | 100.0%
> S->D Throughput      | 0.00 GB/s      | 1.52 GB/s      | -100.0%
> D->S Throughput      | 0.00 GB/s      | 1.77 GB/s      | -100.0%
>
> =3D=3D=3D Half THP Size (1.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.000 ms        | 0.660 ms        | 100.0%
> Dev->Sys Migration   | 0.000 ms        | 0.571 ms        | 100.0%
> S->D Throughput      | 0.00 GB/s      | 1.48 GB/s      | -100.0%
> D->S Throughput      | 0.00 GB/s      | 1.71 GB/s      | -100.0%
>
> =3D=3D=3D Single THP Size (2.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.000 ms        | 1.385 ms        | 100.0%
> Dev->Sys Migration   | 0.000 ms        | 1.152 ms        | 100.0%
> S->D Throughput      | 0.00 GB/s      | 1.41 GB/s      | -100.0%
> D->S Throughput      | 0.00 GB/s      | 1.69 GB/s      | -100.0%
>
> =3D=3D=3D Two THP Size (4.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.000 ms        | 2.863 ms        | 100.0%
> Dev->Sys Migration   | 0.000 ms        | 2.323 ms        | 100.0%
> S->D Throughput      | 0.00 GB/s      | 1.36 GB/s      | -100.0%
> D->S Throughput      | 0.00 GB/s      | 1.68 GB/s      | -100.0%
>
> =3D=3D=3D Four THP Size (8.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.000 ms        | 6.199 ms        | 100.0%
> Dev->Sys Migration   | 0.000 ms        | 4.904 ms        | 100.0%
> S->D Throughput      | 0.00 GB/s      | 1.26 GB/s      | -100.0%
> D->S Throughput      | 0.00 GB/s      | 1.59 GB/s      | -100.0%
>
> =3D=3D=3D Eight THP Size (16.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.000 ms        | 14.260 ms        | 100.0%
> Dev->Sys Migration   | 0.000 ms        | 10.457 ms        | 100.0%
> S->D Throughput      | 0.00 GB/s      | 1.10 GB/s      | -100.0%
> D->S Throughput      | 0.00 GB/s      | 1.49 GB/s      | -100.0%
>
> =3D=3D=3D One twenty eight THP Size (256.0 MB) =3D=3D=3D
>                      | With THP        | Without THP     | Improvement
> ---------------------------------------------------------------------
> Sys->Dev Migration   | 0.000 ms        | 234.215 ms        | 100.0%
> Dev->Sys Migration   | 0.000 ms        | 167.061 ms        | 100.0%
> S->D Throughput      | 0.00 GB/s      | 1.07 GB/s      | -100.0%
> D->S Throughput      | 0.00 GB/s      | 1.50 GB/s      | -100.0%
>
> ---
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 554754eb26ff..9f5563af8cd9 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -397,7 +397,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>                  * optimisation to avoid walking the rmap later with
>                  * try_to_migrate().
>                  */
> -               if (fault_folio =3D=3D folio || folio_trylock(folio)) {
> +               if (fault_folio =3D=3D folio) {
>                         bool anon_exclusive;
>                         pte_t swp_pte;
> =20
> @@ -466,8 +466,16 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>                         if (pte_present(pte))
>                                 unmapped++;
>                 } else {
> -                       folio_put(folio);
> -                       mpfn =3D 0;
> +                       /*
> +                        * Slow path: couldn't lock the folio. Leave the =
PTE
> +                        * intact and collect it anyway; migrate_device_u=
nmap()
> +                        * will lock it and use try_to_migrate() to insta=
ll the
> +                        * migration entry via rmap walk.
> +                        *
> +                        * Keep the reference taken above for
> +                        * migrate_device_unmap() to drop.
> +                        */
> +                       migrate->cpages++;
>                 }
> =20
>  next:
> @@ -605,6 +613,16 @@ static unsigned long migrate_device_unmap(unsigned l=
ong *src_pfns,
>                         folio_put(folio);
>                 }
> =20
> +               /*
> +                * Fast-path pages (folio_trylock succeeded in collect) a=
re
> +                * already locked. Slow-path pages were not locked during
> +                * collect; lock them now so try_to_migrate() and the fin=
alize
> +                * path can rely on the folio being locked. This applies =
to
> +                * both regular and zone-device folios.
> +                */
> +               if (!folio_test_locked(folio))
> +                       folio_lock(folio);
> +
>                 if (folio_mapped(folio))
>                         try_to_migrate(folio, 0);
> =20
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selft=
ests/mm/hmm-tests.c
> index e4c49699f3f7..3a673181b9ad 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2936,8 +2936,8 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
>                         break;
> =20
>                 /* Test with THP */
> -               ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_sizes=
[i],
> -                                       iterations, &thp_results), 0);
> +               // ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_si=
zes[i],
> +               //                      iterations, &thp_results), 0);
> =20
>                 /* Test without THP */
>                 ASSERT_EQ(run_migration_benchmark(self->fd, 0, test_sizes=
[i],




--=20
Best Regards,
Yan, Zi


