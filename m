Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E7BC79F89
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 02:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7F96B0088; Fri,  4 Sep 2026 22:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8B26B008A; Fri,  4 Sep 2026 22:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474196B0095; Fri,  4 Sep 2026 22:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 171AA6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:37:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E6351A01E5
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:37:09 +0000 (UTC)
X-FDA: 85178146578.24.9A9DA91
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010059.outbound.protection.outlook.com [52.101.85.59])
	by imf27.hostedemail.com (Postfix) with ESMTP id C16EC4000D
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:37:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JnwORHPk;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788575826;
	b=utrW/rRqsqVNmtwia8w7MzhaZZW5iXq/HPa6KigvVSZN22fjFbg9DJYxOsflJ3JfdLOnLK
	nmCbNAb7uBZ8AaHAQO55zJUccwNC2PZI86hXqaqoAF6IXx7fBpM1kB9v0o5bcIkLmAWqJ/
	1KZpI0MCmW17xzUxwpaJqtVUKGm3n0I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788575826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00VTiHvXBXR1im67l0teKDeBdBJ3nbPFrA+9lfii96Y=;
	b=8ASdfjgPVof1DFx1JhQe1lF+q/qhhsaapqH313B+EvGmcKN8XQgnXlGkTP8BbC5sOL8fRH
	ZDqK0wfNpCY5ZjfLjRc9getnMlCdooQ/r77jd77EJyZHVnF/XRy/aqLOkWOVoa+qZmRrWT
	aNn05JBuW5v7RlOhRNnW8HYJ4j5A+Dc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JnwORHPk;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQKKB5cpplmm9eij4LkcHHKiUoEAsVqJ58nRfhr3jcLlBS3ve9fRvu1h5xtis6QYaznmXMOMsFLKUxQ8wSSc+pipXDu0t8MtPKOwyIRj9zY6a9Ow1DcPICEjvqfmFzvB0C406QXLVw89KWzZanxT2yp4u32h0TqaI/OKoXj7ipP9me+FporSMsFuBUt2m/ltoVlJPXvQbyD4eCEERY1c15kD7K8ZZD7FFQZ+pc2bXDvO1GIohQPeeEQPPmiqXG6vZkQuU0sXf/uCLwhMNn6mW0nNdZAIFzSRMnOnWYtUKhqVx4sWJNMrh3O7jRDx5Et2NPBfCQ9hlN3uH3HA9OlK9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00VTiHvXBXR1im67l0teKDeBdBJ3nbPFrA+9lfii96Y=;
 b=i0m/xX1HZ81LyJQpWDEeneCkPgEL12vQDNfcIw3JKHuakeGlXZ0jEBSTVVZUGKsY+reQP0cZN8n5HVLmQteNEn/cb4HsUDDJ5ebz7ubFbJu1ZfSlrdN8Xz4cwJcXKtoLsA2f4MJBa11NmXT/EvTmPIXIcwbvkFvgMwiGgelf2TjcGzN5pPnPsIjc705rGxMZizYNTyxgOM93Y77SZHY21wIzS51MiuS5+KAs+1Wd8x8OT91hQjWtXTDs69MtnM0u4xo/gQsFuSYhfsnwDfyZMI6FkzO4YE1O8ysfDB7/GUx0rpUmfGBXg2mKKGAB7hxrcyW7CwtxtPI33y1Mu3qFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00VTiHvXBXR1im67l0teKDeBdBJ3nbPFrA+9lfii96Y=;
 b=JnwORHPkZRPZBsivgiGKgoSQgP++ETUjEErbu0hvy6tMGNuJ5PXenCQcLqY3T7CFk50GabTETjtJ3/JLrraSfGcUoZYv0napJQj8pPYvZWn0TRfzXemc9N8OI2y7YaAqGgvn+V8FHvAkly/OhalMPszf1l4rsBbTZZv/QEIA7vpSHN3x/h1JHaXvJgv353/MnIlbnmESQWx2BgUzn48eRZsD/x7/EfsnzxBvbNXjjyMJ1r5oRCU/5w+pdNQES3PXQFldspEsliNklAum4AMHxEjgtNmZkBr3rnMa+nB0JzKvaG7wkteoO6Zi8gUorGzjGK30kNOC8lWwNNy3WWhTRg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8185.namprd12.prod.outlook.com (2603:10b6:610:123::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Sat, 5 Sep
 2026 02:36:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Sat, 5 Sep 2026
 02:36:59 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 22:36:58 -0400
Message-Id: <DL717O23OZOA.2UYSFURHZH0H2@nvidia.com>
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
Subject: Re: [PATCH 04/12] mm/collapse: add collapse.h for the collapse
 interface
X-Mailer: aerc 0.22.0
References: <cover.1788533997.git.kas@kernel.org>
 <ec5230f43af7153e18aed02c6ee38f010106d8e8.1788533997.git.kas@kernel.org>
In-Reply-To: <ec5230f43af7153e18aed02c6ee38f010106d8e8.1788533997.git.kas@kernel.org>
X-ClientProxiedBy: BLAPR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:208:32f::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8185:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c21f18a-251c-4767-cddb-08df0af68f81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|11063799006|10067099003|4143699003|5023799004|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	B09o7i/IBPws5SHBHBxRfOpTPakTZtaDjZ6awT6QPEY4ehWtzxt0jb55vvVQNoUAr4vaEA5ZpAv3v5xkzyK7taxd1L5k/yovsPxaomz2c+jB9Jiv5kk2obCHbjszt/U8X5umdfRULTQhXH+nPUNK9LCxXP7Y61ESl+bcMHfa1fMJwKfTjSjRGH/feLyN4QxbwXY+TGoEuJj1Dphe1es7MygaQSs5uhGxjrBpIRZX9vKfEeI5nmdaA22kHGEF9V+QiPSXwhN3OLV1vG51MefizmHuROngM+kwqMqXvj5Tp7r9i/gfOxJmtOWwiOB1+6mrgtxTj4FvegktVMrIgFp3cpphPaVPUZ8tkxKCTpZq5hZVCta320q8UeDgkHkGHiNoH5qmRB0eZ7C5wzHhTT7+RoYiirKlg8aEGu/y9JD9tFtdgrX7i/JSK/SVVhXDpZuHhbt/8uBYWHUCHLV6gFJpFfIhckPc7UbI4yqu3WzL6/53SvpLYUyyPirWPKxVIfeAt37567f1HzFlxLBKpzfvB5PPJYUT/XDTvm1FouQhIdsNNR4ZhTn612Em6TzOSy9heaUhl2sUns0s+uLdzEIMsosOPn3zq3IGibO6quf5tGpYjxTKbJSuQjx5mQJbhGniO3vtbD9ooH2P9GjgpOHwZLfOyIvGzrX/JyDmUrTjO8I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(11063799006)(10067099003)(4143699003)(5023799004)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnhiUk9hODhyQVdEYWVXRTJkZ0NhSk40OWhvUVFJQ0djN0J3UmRIZVVVNENG?=
 =?utf-8?B?MHZvR0w5Q0J1elRzSmxCb1FWRkM5TWlDcWs1WXpJc25xV0pMU2laKy9seTVp?=
 =?utf-8?B?Lzkwa0VuYnRpZWdycWNYblFzQjFQQi9KRkV3bXFVMnc1bSt5SG12UVV4ck5q?=
 =?utf-8?B?UVBhT3BnOUNLYnhDYzJTU1I3dlVyeVZtbnRGQWJJUXlzU3BEQnltUUxlb1U5?=
 =?utf-8?B?SnBkcGtGMlQxelBLODZGQkpUNy9XOHBVK0VKTkp4YThNOVg5T2ZGS2l3UFFF?=
 =?utf-8?B?NTVTbExXanExdU1RQjQxR3lTSDRRTGRDdTc4OFExY0JhRVZjMlBESVdTTG03?=
 =?utf-8?B?RFFzNkk3U1prR1hWQVY3clJpc3g4ZW9XTWxRMGY1NXk1REc3WGdIREl3dGdP?=
 =?utf-8?B?VWNlNXloSlFxbXRDR21kV3JNSGFwWm84QWN1eFdvd1ZEQUN0Q2V2VHJxNmxD?=
 =?utf-8?B?OXdMZkFRdi8vbXRxSVVjcmx0bEpBN2J4S3RraWFsTWJVb2liaDZnbUJLT2g2?=
 =?utf-8?B?cEJvbnhHWU90UkdGOXJuYWt1TUZGcFphamt1YjhjTFdHd1dleXRFUDVXemV5?=
 =?utf-8?B?TzBRMm5qZVBqdm1wWTViZUQ5MkRRMmZGZlFFdHkxZmpyQ2JMd3hGWG5tYXZB?=
 =?utf-8?B?SWhpeGhHSWdVLzdqRDJwdmNQenk3SGhyaFBBQUhRNzVOR2RkbklPRTk3b3ZN?=
 =?utf-8?B?dUMwaG5uUE5SUzFYV2NHakpMZXFOaEk5M1ZzdXZGdzltbUJHdytSa0dRYnhD?=
 =?utf-8?B?OUdtTGpQU3R6UHpTcU9pSGdocUlpRjZvVW5Nby9aMGFWSE9GaVM1WUhSQ2c4?=
 =?utf-8?B?NTlhd0Z1MGUwMk4yKzJjK2dvbktDbVR6dy9aUlkyK3hmOUZuc3RrL2dhVzhi?=
 =?utf-8?B?QjVucGNURTZ0VGpDZ3QxQVNBdDk0MGkrR2lKL0VVWVpyS3c5eUcvMmNkcFcv?=
 =?utf-8?B?OWpPN1hJOEtOU0RTUXlJMjNmZXFXWEt5bkc4OCtzT2JKVnZ1ZWFUMXZ4N3RB?=
 =?utf-8?B?blpEQ2FudkVBd1NTN0JOa0x6QWloQStuSC9ObUsxNHR6eG1VTnlXUzdDM3hu?=
 =?utf-8?B?bGR6Tnc0WTdrSm9mRDF1WmJweFFFclE3YnpEeVcwN1JNcjRTbFp6Y3NFaEdY?=
 =?utf-8?B?dVF4QXluZzFkRm8zbUFzYmZ6SGsvNzhWZWZNMnBjOHZSMmExT2JVajY2T0pD?=
 =?utf-8?B?OFJVMzNvNTR0RVM1Nmk3NHZnUEdlUXdCKy9lM3hKTHFGVzNVSzlJWFRJRW54?=
 =?utf-8?B?MTZDTXAyT1FSYXlid0MzNnErbjMzM1ZwZjN4R2pFcElia00rMVBlK3I3WnZ4?=
 =?utf-8?B?ajJPYnJrVWdoT0l4L0FHYlZPNmNCQXhPKzR2SjI5RGc1bmRlZWFoeVdiOU40?=
 =?utf-8?B?d0doTUJQWHNoZ0dLaGljQUI5Y0c5SFJKY0xwdW5Kd01xWVlOakNNTHZMeG9y?=
 =?utf-8?B?MkdZRDBISU9MZlU2SlNMS1o3Qk4zZWhlYnVCanQ4NTBkQ1pLU2RzeFBHZDNq?=
 =?utf-8?B?OEFaQnJTWHVlVlhDblJjUVdROG1xMEVaRi9jUmtQRU1BNDAyVHhIZitZMkgy?=
 =?utf-8?B?dnBKcTNJY1ZLTFErNkFQYk5VclhwaGwwWWZUdkNKaWdBTUtDVGllQlJDeE5V?=
 =?utf-8?B?RzlEY2wyUi81NzlOVjZoWk4yMzg2Y0hiY3Z4Sm9FYXVxeStrazFFWG5yMyt2?=
 =?utf-8?B?SU1BTHN0Q1B0TkpwdFFlcGwraUdMVURNM3RzcXREeVF3UTFPcG15L1lwUDhs?=
 =?utf-8?B?RkFFNzJoeFRHdVRoVk1sNWl3dWZiMVJUUG85NjNUTlhKZ1ZtU3lkVkY1TzZp?=
 =?utf-8?B?M0U1Z05WSXpmSEpvRVE5RGYvczNuU3JHV3o4M0srMGFtdHNBYk5iWHVnbUUx?=
 =?utf-8?B?aU85MmhuSjVDRGtiT1k0NldVbEVHWVBaRVY4SXhGWW0yMzh4K2pyY3NSWjhx?=
 =?utf-8?B?TVBwVC80cmkxVDFXRWpGUGtleXFWa3NZNFNsUUZvZC9hT1ZwbUlsMVlEdEda?=
 =?utf-8?B?K1NzMWJOazB3cm5sK3J3SWg3UmRDSHNiTFoyYTFxYzEwUVdzS0VDdFo1M0t1?=
 =?utf-8?B?Zk1mdVdYR1VIeGJ5YzdEd1k3aGNnLzRuQTFGcjdzR25jK0NnUStBdlF2bGNm?=
 =?utf-8?B?T3laYisvZlhiZDVXR1k4NkpBb2NwYXZJc01Sa1pwYXZBdFE1b29NZWNVNDUw?=
 =?utf-8?B?VFlaZXUxWHJWOTBqUnd3d1hmYTRVYnlBS0xuVTBWbVRQWFhNajBsYnZRa2U2?=
 =?utf-8?B?ZFd3SExnQzhDYUJDNThyOCtHTHcyeVlCeGpQTzYzdlBhTVRwd2pSejVvbzNp?=
 =?utf-8?Q?bVFP75qdH2iJY/0Lpk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c21f18a-251c-4767-cddb-08df0af68f81
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 02:36:59.6752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mbieu9s7oJtYHnaJuHYBeXbbWW+HG9hsf88ZmUCVWGCrw6rd50NFmKcJeDmHh5uq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8185
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C16EC4000D
X-Stat-Signature: 7hd98to7uap456bf5yii55nxcukmqaxy
X-HE-Tag: 1788575826-679893
X-HE-Meta: U2FsdGVkX18zi1cKxgzusuDtQwE/X+bKf2J/dNkFKfw8yqQC9EJddgzI6cqM8y5uaB5IUBrwyL4ZfAdE0hChuOxc1mznps6I/S0JKE0O/L0UkzK94SE3a28wPbhLByAlyx2sao75Nu7Ot1PTnLqrzeEAFeMyD7yPryf0/amdZW3iNS0a4hxmj86uqvyDYDiFmKJVSuV9ccgkM2jylpQ/s2MqPhYnwsuej4P2pxglwkJKp9zDf+ADsXIeY5FkQJIDKmbwS1Dik010etG79QbAz/tIDP2I/5oqiBm/GMq4sHg7a9VnW4AWuLC0s+j4/ViOF5qzWvBeqIjrQczgTicd9yKNZu32OYx4OtT1457cEmBPObaC8ODIG+DyHQ+l3lcmEbEnhRMSLx/jxXPVPQPyvqIKMlbIoAHlnPPDIWPT2LvKiIhJ/w4OisH/BvBEQl8gFyrtxtlvLRvnma3Wd+mmida0g9m6HFjGUzeDeTq5bpGbU7HKSGJExtkj/FFIaUtH2qNHijoYiFeBHHy7IRvJSikQ4gseL61es/0WCLLObz3CP9vJXpcqvtIHT67rTnQtTnfgxV6SYVPW1FIcW/euISAZhl+wzFyfqsKYQCN8oOu8UUiBBXiefWrw+ng/+NhLFfcM9PYfTboUqQeYg7H+xz66cEpcFpV/fOSZzlAHTwPXNZPprUD4sAC46zi/xVt9zi05FXOOljJYAISm0LJOM/Y/rt+zuZ4LI92U4KSQos1EidzdseL/3YGJ6HoovbhxCmuY0eHuoYhE/f/1wvJHiikQD7OB2kkbOczRjjD2ZJFPL0N+CFp2PKskN3yPwNjg/VQT3lRJLSjv1INn2X5J90Wb/vABzlhXu9lHu6iVsfMvf/GcWZwj21KbIJqAAjB51gpwjViVMaC2QFNgTW3nzBPODZ934801vneZNkUkgEShcOAVjdSykN5U4Wyknz35+cgU/PwzR1OIR0fyzAm
 AmmJKQ/D
 bTFqQs5VzelljtJgo2d+8GsFGkbR89RL53mqibh2Y6jsLMaYMhwxWKVYjFDchRd1uH0oi9s7C0V7607tXlpdfgnISaDRax33UrmVX1PBCHzAavxxQD/OFEY321QKnSCraPEvXewfH81e6V5Z9m/jRivKjz+kJ8T6hiesP/SrLSe5CKKxKS2fNwQ6vpCpHS9drPlIhUke+vewzSAQgkhk6MrMBuBpmZysmIrIygJMpVmqTi2zA4NrcxLGP+Yr+hHH7gxrkR9L1IyDF3w6CyBtKdaQ862Pxj7olt4OIxWPG0J80Z4V7WqIbl63r7fPxu02xDFlf7TBz6arOLHxR+kK+s4xqod1LLYveFnBj3WYDHdDL5UZ+PV3AzTOiB3PkK25UOGODn8BzmiA9jj3YQxaxjpuJrpEpzii1xMCKXE3eoV4ieeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 4, 2026 at 11:10 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> khugepaged.c holds both the users of collapse and the machinery that
> performs it.  The daemon's scan loop, the sysfs tunables, MADV_COLLAPSE's
> entry point and the collapse itself all sit in one file and reach into
> each other freely.  Nothing marks where a user ends and the engine
> begins.
>
> Start drawing that line.
>
> Add mm/collapse.h for what the two sides have to agree on:
>
>   - enum scan_result - what the engine hands back;
>   - struct collapse_control - the state a request carries.
>
> And two constants move with them:
>
>   - KHUGEPAGED_MAX_PTES_LIMIT -> COLLAPSE_MAX_PTES_LIMIT;
>   - KHUGEPAGED_MIN_MTHP_ORDER -> COLLAPSE_MIN_MTHP_ORDER.
>
> Neither is a fact about the daemon, so both lose the KHUGEPAGED_ prefix.
>
> No functional change.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  MAINTAINERS     |  1 +
>  mm/collapse.h   | 67 +++++++++++++++++++++++++++++++++++++++++
>  mm/khugepaged.c | 79 ++++++++-----------------------------------------
>  3 files changed, 81 insertions(+), 66 deletions(-)
>  create mode 100644 mm/collapse.h
>

<snip>
> +
> +enum scan_result {
> +	SCAN_FAIL,
> +	SCAN_SUCCEED,
> +	SCAN_NO_PTE_TABLE,
> +	SCAN_PMD_MAPPED,
> +	SCAN_EXCEED_NONE_PTE,
> +	SCAN_EXCEED_SWAP_PTE,
> +	SCAN_EXCEED_SHARED_PTE,
> +	SCAN_PTE_NON_PRESENT,
> +	SCAN_PTE_UFFD,
> +	SCAN_PTE_MAPPED_HUGEPAGE,
> +	SCAN_LACK_REFERENCED_PAGE,
> +	SCAN_PAGE_NULL,
> +	SCAN_SCAN_ABORT,
> +	SCAN_PAGE_COUNT,
> +	SCAN_PAGE_LRU,
> +	SCAN_PAGE_LOCK,
> +	SCAN_PAGE_ANON,
> +	SCAN_PAGE_LAZYFREE,
> +	SCAN_PAGE_COMPOUND,
> +	SCAN_ANY_PROCESS,
> +	SCAN_VMA_NULL,
> +	SCAN_VMA_CHECK,
> +	SCAN_ADDRESS_RANGE,
> +	SCAN_DEL_PAGE_LRU,
> +	SCAN_ALLOC_HUGE_PAGE_FAIL,
> +	SCAN_CGROUP_CHARGE_FAIL,
> +	SCAN_TRUNCATED,
> +	SCAN_PAGE_HAS_PRIVATE,
> +	SCAN_STORE_FAILED,
> +	SCAN_COPY_MC,
> +	SCAN_PAGE_FILLED,
> +	SCAN_PAGE_DIRTY_OR_WRITEBACK,
> +};

Are you planning to clean up scan_result? SCAN_SCAN_ABORT sounds funny,
SCAN_ANY_PROCESS means nothing, SCAN_COPY_MC might better be
COLLAPSE_COPY_MC.

Anyway, for this patch,

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


