Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8362CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 19:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D149D6B008A; Sat, 13 Jun 2026 15:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5576B0093; Sat, 13 Jun 2026 15:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4CC6B0095; Sat, 13 Jun 2026 15:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAF856B008A
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:27:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC6E31A04F8
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:27:33 +0000 (UTC)
X-FDA: 84875873586.22.175E972
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011050.outbound.protection.outlook.com [52.101.57.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1274BA0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:27:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lJaGallJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781378851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lib8BRGpo1EEqax4A6ZmrJz3MDV0//dh785lKdFykzA=;
	b=yGtpq5ypJu/yP1aTtDDEc+32gNlG0kQwdCQY4c3TZXFQSZUHXH8jKojpYVkCOYBG5YJUQR
	C2r5euYJT7mrIP4pdWFdanKNuLQx2mnNWC9fEWKP/s7co2k2EJz/EXWZ579grTO4I/fhEt
	4yh02V4BuAdcdk3lEKV8ALfeco8MV40=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lJaGallJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781378851;
	b=zW424U476LR35ZbvOwEcAXw0UEvVwZQufo2khQdfGb5/geA+PzAIZLhOaK91jAdSvvOmS5
	aEXN50Fh2ZK0F+/3PLyHK1DhKV4HBxhYWa/yNUCq1HaqjdBd4KQ/UuelRAfUPUtaUmUqIQ
	8hs9MSJ0epZC4+/wcJqdxl/8jVvPNOE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nb+YkW1vIkdrLa4nJyJsWYgODjWTCRBG93FnpU5q89VEOXLdmpULWMXyqZSMNWjYFHmS5G6U6mkCM+dEVgUab397iV10hUIY4Or+pEPd2Q+R6fbHlsGocwFPqDphWoDj/ROCh3+KgI+x0KfX9bZYsPWrtbfOwyAbTMh+3JERR2xMaunBgTG7zsL1I97hlP1hPK153CpVQT/LmqF4w8rf1rIMztyPbMfOl5YiNwYuTFebPRMUvXphMo022f3pP3ZvVibzWkG8cba9cb+R1DG8c/kOe5E0ZRRiRU+SrnAy04kjMnLnwDhKFxrdb1ofV2mWRIAsfGTtjAqPYvN25+W7Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lib8BRGpo1EEqax4A6ZmrJz3MDV0//dh785lKdFykzA=;
 b=rQVyQCQp8n/yeFsfqQ6HdCJwGm7FN3iH/VWJ1AOjstuttXbSdngYPQKNIs+uuVXlcURQSHd63EzpMRCgFtqgPOn60tWJ/JR8/4C4BeufXOCOx+gXsd2q3WpnLb6LVsPucb5VRlMd+xR7cGKvzS7EPaiw9D5fo1LqVTQCgWXja0H++A7exJJ+9kc7I3oLQtzatLr/gXH3LW+lLJ0Dj//sbssHLv53jYhJbPiye1gtso5yC2CE3GmCzbiEcSnKz8+fhQZIhyGfpcKhRedwch/HBoEOnaEidIVyJW/vqny56wwpx5oSnS1CKwKXvlchDIegAwHneMxdbf7ueRBiCYYFpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lib8BRGpo1EEqax4A6ZmrJz3MDV0//dh785lKdFykzA=;
 b=lJaGallJYilUPQdszQG6KMxZfL8YSv8DuPDHTc4+lDdZVned+1LCE05nUD1KlvQM4PUJBkuyrTQO6IuujKNyPhVi1YoKYWH3JM1/0AuuDst+lJImJWrRd50Zzr6kLFVMpfBvoooG3twjWPvYNDHSBtSqEkI532kitfQqEeJuEqJh2P9ExVxSJIMrVbrzKc6ILMxwVim/fbm48Gw6Fa5RiKfN/KAQeDqCFTpbBBF3zAGRc3VNj5cLxGiwECp2O7Htan7TmbfL5EQIXKN2iMjENa8FCWUKo+F+FBo9dNr3vgQ6GZiRruZjFJonZnMGnAk9qunh6o5NGeeN272Q7p9+5g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB8724.namprd12.prod.outlook.com (2603:10b6:806:38b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.14; Sat, 13 Jun 2026 19:27:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.015; Sat, 13 Jun 2026
 19:27:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
Date: Sat, 13 Jun 2026 15:27:25 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6E99CC4E-A026-4DE3-8A5A-34216771F521@nvidia.com>
In-Reply-To: <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
References: <20260602142537.198755-1-usama.arif@linux.dev>
 <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:208:32b::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: c079f367-0d20-4aff-4f18-08dec981cdef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|7416014|376014|366016|22082099003|18002099003|11063799006|4143699003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	zp5fA0pS4UzNI4+wSXxW0rxe2RNAdzLoSq3jo2QGEzhb1v5RaR70rzQTV3mDatQLyvFVJPv/b71yCe56U5zLlrrU5utuwNtTPMOiGI3aJXXKyyFjooUp8sETmkF4iPq61KlKE3i0WBNY499lsTgmb5qQ4TXSD5BPjPJHlEebx0wk6547WzeIXsF7VMtXHOjvmzMhcnwSiZXB6tczmAPKZzzhzxboFPcu0CznQzWUqahIp1cSKNsmqh3qb5aCcHIM06tRla0P8/CraNDSRp2Gj5OvMpl+smavmKrkhdOPIQsWRADOgqUFE2Ls1lw81xy1fw5rcNdR5H1FCy9yKBTgBAG0jW5t4mt4m/giZKW7yGjEJGxYwjNIjl9zIQrtusMnaR82CA6S2ICbIBq7wrOea4srF9AVI26yMfYbdMYNdcMMvWuUp/+2lLaX83RskNQRkG4sUEj9vBDX/lTUSTLgyCUrgn1/+VuGZ3YPy3V3G94bYclTdos7MA1gDsJw2jHsXymCd8Bjt1Q4tijnEeDvLxfjNySI/oaeCQmBHas3fOoQYXUYlYvj3xGYlWIoKzO1sthy8dHSq/NK9UFDswShKct5IRmCMdo3EANBoRT7eFc2jr6wh2Mvat8FeGpcfAFlo3hWCBNspFH/g4fYgHXHTizZ4o+N5I/8ui9iH39clBmk8TqwhEZUKE/rA/rJBJEL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(11063799006)(4143699003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zFFi/pK+ubV2WRSmL1GudJqy2NEj9IO/wOsRX3up/EFgXAdnz5n1FF68rYTE?=
 =?us-ascii?Q?++1bxmeRvrwsP2QYJnb2YxXnsAg9SOlMwcjwTMRvipQOtfAlPaUTBnbZ3M3k?=
 =?us-ascii?Q?A9a4JEf8PZhqOfJcBdveI+sGRrNR0+VkfLeWI7ZpRc4plZPDQst5rI8VEMIC?=
 =?us-ascii?Q?Nf7dsubtEff679SWGneBx3NWb0qTOSeUiIov+q5L/2NbRVP5h6l0NxGe25V3?=
 =?us-ascii?Q?Z6fXAT5sTIaizpQOr41roY2ypT4Cj4yABlCnco2HPX0OlNhfSOgkwAH2GZwB?=
 =?us-ascii?Q?bzgb1AnphY1M+Epaxyni/5suzwQrftLmcP5mv29I5L1+r60BaTuJj0HMMR72?=
 =?us-ascii?Q?dnpEllGKZL1j/jnZyGdDmgBl80DyfMAIcqo7EVuK/0p8ahYX9Ss4gZ1chImM?=
 =?us-ascii?Q?OukjoKGncZMm/u3JcyzrH3wdl46A2MaODkbobE8vYZn4+R5OCNFOrZEpmMha?=
 =?us-ascii?Q?I5F7f64htANBxVt2wP0pDCe4DTwcwnlmSzLWHqWC3XDbhwr895rw2woVpkdU?=
 =?us-ascii?Q?CCoY/LN93YQ4Iy2fp68yxiXKFQT7Vg9ICICAqpBRTZox8ECmYzcy/xaCMDfo?=
 =?us-ascii?Q?yO2EU7NMm8n7AOpHDW+Chg0pjUg4PM8VNjCUuJKIrSxRqIGvbYLtAVCrgZf8?=
 =?us-ascii?Q?n3yfR9B+Kp1flY8KbFbxWnIxurixtUvCXd17OaOMkldqK/4UPBpifPzGgMuo?=
 =?us-ascii?Q?72d5wNMF3P4cBsqIX24ZolnQoW6BUN5l33KWbKoyhbaRWLfLdJ+3j1RLGFmw?=
 =?us-ascii?Q?tmLa+haGhgxxGooCCubCAKIsrJX95aWru4UkQqM0AMlhnjAWrj1dD9+1s5hP?=
 =?us-ascii?Q?Fo1UzoT+ULnLEvo0fSro7sO+/wERa/hDlOZbIcQbpEgb2vQJrFsrXNHeSdmf?=
 =?us-ascii?Q?CO8hNMo2+FQ4chjV7OHHBFc2kESk0LK0LyomRNm+ALO3nT0effzjz8M9I6NW?=
 =?us-ascii?Q?pXC0aE5sR5Y10mXn4kVssma/dvxTw+6arO86+Xb/3Uwr850yE5SGxjAROuh4?=
 =?us-ascii?Q?fRdE0fyY7PHCjuCbckJAE6oEsbLETBgDhJOx2t/njG3sn3O2PJIBTE9YsA7F?=
 =?us-ascii?Q?dke7Jo95megVEhEv2Ius007CqT7663Hg3AePf7HgRR+lMlkGOi6/TC0syz/I?=
 =?us-ascii?Q?fJISI7KXmjOLTT+Bh3Q+/wbyDcjfagqdvntAN3u8I5E/EEH/sKH6ym6NtbMc?=
 =?us-ascii?Q?6+esY/cmS5XdIxs4C/i36AVApTsH90g8afEtWYFd+3GmK65k8PWzYWBHgf8d?=
 =?us-ascii?Q?rqgQA4qv0WzKhYMFp5KQgMAQIK3qR9ibq/UgomrfVnUaZfi2fyKzCCRqqPH4?=
 =?us-ascii?Q?Z9e7PuhFSJb1oyJ1kzKhxXHNzRvBD/6HrU5ZET0B+yR7KTDwXO45pTMxJ+6K?=
 =?us-ascii?Q?u2rYLZMzhYKQxl9qbuJSo4Ia4dYWo1N/a/l/M4nSJpXNEpmuph2fbZs2ceaz?=
 =?us-ascii?Q?AGiA9qpOrlKaWU+ZDj+JjyBJTL3Ub4kEJ3g1LjqL4E45Wp6gPUqmwwogAPhr?=
 =?us-ascii?Q?mKLun5w5Cf6OpGVqOjljtZQREkI8rwkXY1fZ3N5V5dJ5nedsLRMd/wnyuuhq?=
 =?us-ascii?Q?50yr/ZWmGraj0Iz1FQ9wKT3xWLdrSF9GNFW9Y6PpN1CEHi5Uncl/BFGWBlRc?=
 =?us-ascii?Q?HJB9Vp/i/BQNNMfb9dhczxXz9Od9NqS2dD1qIgHjU2oEGTT5ZQ1q4tg8y7Rd?=
 =?us-ascii?Q?qVbyr1bIfmmtr1+C6QNVF/6RlQekLRbGkgsiyvUxSDv3d6gbXcYhIU2lStMh?=
 =?us-ascii?Q?sHI1Sj/yh5e6TN4z+73AWdY2S8o3yMm+FYHdj8HAJnL2a3QPeEh5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c079f367-0d20-4aff-4f18-08dec981cdef
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2026 19:27:27.6879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13LVoToZh99hp5nJYFF9iZhnYBqz1Wb7kTs9hg2kcLH81DwYBZFtsw+So2mewDCw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8724
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1274BA0005
X-Stat-Signature: 3k1y3w7qyytoxo1yuuumopqdqdrmc1xf
X-HE-Tag: 1781378850-910166
X-HE-Meta: U2FsdGVkX1/1nAB0A48rkTtYUvbQewtAG7t74N036047ZRAcb7u/ZY+zOugqCMI0rPj58jDljP74PscM4HoW3w4vjnvlvGit/i7PDBi7IjRCCz4TOQJaGI4cohpMKoP4YSMh4nBKyYSV6iOyMYgVDE4UxaBBPjEMsNnf+/YleRt0AjyJTcUK3L7PFMpQHZOauzFP3aFoiPNEUvsVZ1E42TbONwIWIMcIn+/wVaFzZ2u0KiUqBm9Ug/35gJ/ll2g4J/eiIcuWz81SWgtjQqGXY98twqQj9FowXAF94+oh80n1YEmsyu1RA98Ul/wWePCBFWsSMXdcK/v+mijEzOf8lih6qZTFB5eNfrhk5Ex7/ffySgkVmhAJPGpUpiKwBq+WDqdgaafWcYmdwN5MeAxzobZKMNk9FGQFPvRMrAqgncV2Hy21X87gpENvdnP7Xnru4yCVTSj7DYV3BX9K/lpmRuqf8Fx/ZIiEsw8NdODYq+sHPuNA1QPLnWaR8cv2Zu8o2e4xRUkSw2V2H5ZKl4HhcOnGfkmy1/EbmS76hHNf7pojM4fW6w/jiXlTFOg4S2oibkUci2+Aa3d23GRuYEz2VwAVgzQB0rVnf0b5Ewck2tqBhFR+IFc3H9Jw/tGtLqMHIVRWQmFnYMi2rvoISHCBMpxpBkXztyGZaX5MwP8eZ1UO5X4r4NeRF1nQ04wK/wN0SZIOD7UWkqShNe19+L7cocm1ePrgmVjHUsgmzwa3UUwA0rKqG3yyiPozRu2SsMfkEZSEpvcAntBPgVDX8FrTIUCqvsWmKq6QAsJ6vtA6jkoddK/hDwdoebwHno0bfLPOYg+prgGp2yTr/o0l7JXIs+tMHxaNEE33tdND7p2YP7cIpOuVKEjxUCmnPfa4U+11WRsyQxMlFzM0qsdSu9wdkU9kRp2Gp/GXTUnqqHrrSPxqdMAAu6q2MpGfTIZPZVp2SKt4pLOaN2XyZZntzVu
 VH25J/IQ
 QWFOde5QOgGD6/zhf0t3CsV91+LdViLoVGWk2zNpYTQpx0EywzDzynd8X12f0ygCS/PwG0SkuJYNTUZ0Z/T7lYaMnraPfrUOOrZbh1jZ1FEP6r8nlhIIAB7VGj0J0BuhygEToIQh7D+O4oK500ZZq/VYbbNEh2GMBdEL4QTZcy+NzO3mpoBdBqyGuJZuv1Uqc4TCbmFYGiEZoz6Ce+0M+e6qyMqry4KZ1hixBRBIt+EMTZ0ntkhqsUccjMiHAKNnQStRlZsklsUYS3Ao5pG2F1MvyZDfm1TAfRmG/2enJELJLSyF0rTN2GJULYUan7HEYvOZmdPTcfCVj5Lf7En0o7eGN8eq/LmBJMaZpoEbPkbmxmnonMiaBv3TJBMxUD4vyzavbgjGafwQMx7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jun 2026, at 10:29, Usama Arif wrote:

> On 02/06/2026 15:24, Usama Arif wrote:
>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
>> unmap.
>>
>> This series introduces a PMD-level swap entry. The huge mapping is
>> preserved across the swap round-trip, and do_huge_pmd_swap_page()
>> resolves the entire 2 MB region in a single fault on swap-in,
>> no khugepaged involvement is needed. swap_map metadata is identical
>> either way (512 single-slot counts), so the PTE split buys nothing
>> on the swap side, it is purely a page-table representation change.
>>
>
> Hello!
>
> Just following up if there were any reviews/comments on this series!
>
> I know its a large series but was just checking if there was any
> feedback?

Maybe send first 6 clean-up patches separately to get them merged first?

--
Best Regards,
Yan, Zi

