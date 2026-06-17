Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89039CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5FA6B008C; Wed, 17 Jun 2026 10:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7136B0092; Wed, 17 Jun 2026 10:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EDB6B0093; Wed, 17 Jun 2026 10:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19D1F6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:28:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 999BEC1DFE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:28:27 +0000 (UTC)
X-FDA: 84889635054.20.9E8C9F6
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB69118000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:28:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EMPkBOzx;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781706504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucXOr93DN3wxmTcPCKsqEj6ZmZ6JyDE2MYmPB20yVUM=;
	b=LGhRbJeirjaxeLCn3qbVpq1ayZoXNTrThTIltDWQBVMHNYjLYjzciIp3OOHbX/VD9CsJVp
	TyHgWR1gDeSL+DH6mWqyiRjsGAeHkxT/xomElB6ohpCsElLaliyDmQxlnNj+QFjFrql7ao
	mmKlHg2IMaB4ufSZx2axmmrDyXyIHd4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781706504;
	b=BhCrs5bSj1A2ABeY8MO7P/mhsNnAFbZPhhQoM9Oq2DOoN7iCIriibv9RFFjjEqd39OsEZa
	o3NvXbZOAteZBnOOLFUC0mQABg6deMjbnFmU9czNnfABsvxfkenRssZtpLTYP+L8pkSq0Z
	9ucc8jaHWwXU3REGJU1O2EypniXKFAE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EMPkBOzx;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/aFUNLt16NkLYSEKFRZsOKYzPoi0UglTvWaiXPstetq6hWMLpuJjTTxj89ygl3RdNZpsHLA0c93c5NTD6RDHtVJ4boV2TTBn/XwynoMPVOIDRvj/RLkax2IKgNjypujf4AZjZQ6976OpA1WcWxuTSCbHhyY4O1Csnhvtm+pxfrjOQXlt+Z3DgRabc2FeokZgbTPC7wHMpzjv05YOizH4uLvQmHlRu7qIIe0LGthB+v5uI+pvSzToeiC3dJQxDafqH4It38lIYvkw1XXww4nqJBQC39lmz0ewBC4ud09e5hBr45hVOWyn+b+UYheda2C2VRkP9IG1WjMJEfCMplI9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucXOr93DN3wxmTcPCKsqEj6ZmZ6JyDE2MYmPB20yVUM=;
 b=ShdJmNrOdDqZQHhJE8eTY7/w4kWYhbAUsMq5RUzykidGcP2sih04S84RwKsugDO9SbmFXO9gjqiHmUR6l5Ug1c3YRbOBZk/9ooqA7EvDXZ29bb+XGhnH1qO247Emsh55QyudjIyBbjSh0bRxAxw1br44iLcm/2AThiNJE1D1wNRwUOjJmGMWi0cn7bwiQRY6p/c2KADGGQ07LEF0r0vwhVlluVTERXRDWnPxMMwgl71r1sKjINZWTyEsTpWFs+COiJ2K2VWajzoKWwkOMXpurap0qyrqaSxhkQEVkP1RYf8OlyUFRyNcg8MgpukP1WCWIfcNK7khcWyuOUuWyTgYQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucXOr93DN3wxmTcPCKsqEj6ZmZ6JyDE2MYmPB20yVUM=;
 b=EMPkBOzxP2UdCIGV7O05ZcQeLo8SwuH988apNl8SxkZuYfPX9nefuG7OkhSiQfKR+CACkpN6eEgtYe40d40ADAfw2MvrxNzETcyG2zAGO7dxJRmt60OfC/DX1wk2ngenUdxkI0sC/FORkvjinH50BqfikeG1Ge5H3NUZxoKHV3r86pKlpHVeB3YVX4Xx6xZdvSJM92uQnw7oib3H+gZaqs04KOFDo9bDKS83QNLMX39owtD8mRWdzAVr4ejOxo1exDYKCROHDibNcOnk88EcETml1LJOagwrVvoPMa/09gXZ3cHpTGWG4Q0VvDnnmbUzYTufd8iQQXOKwBDTkny8hA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ0PR12MB6711.namprd12.prod.outlook.com (2603:10b6:a03:44d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 14:28:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Wed, 17 Jun 2026
 14:28:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 10:28:15 -0400
Message-Id: <DJBE8O7Z6KN9.Y34YAWLQEKWU@nvidia.com>
Subject: Re: [PATCH 2/4] mm: mprotect: use walk_page_range_vma() in
 mprotect_fixup()
Cc: "David Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, <linux-mm@kvack.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
In-Reply-To: <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: YQZPR01CA0145.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ0PR12MB6711:EE_
X-MS-Office365-Filtering-Correlation-Id: 55a755ef-ee8d-49f3-789b-08decc7cabae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	HhzAKyoS1IDbuL8ASIEnDcVj0i4XDxDVG4GtQqs4ZHki3jOfjrAQuF1WMDVZuVb8np6Mfbyjn0GAVD3RJcU5we6echZRRaaOpoO9LxUIH/wzMFSewLTlVmgHvlzbDivsl3JBYLrXrNwS8Nv6ymlV4lPxhfWqTc52KNYO5PaHuhfe/vBgnhNHHCsOmIf50RU0W7STb30eIX2fdRhuarfS7o/jmWP8XZZIOaFzilQ9ESAA3dSiqUxXSjTiM9QlUTWvDfHGwx9+PbOvy8eyyxV3IbsMj+3lPGa7HKeA4QBhiSAHKjhjY96wG/KnAVrnGLa+PvrtqMhs1IJ1RSV0BwVeUW8g6Q6jesrwRGw8vnec4dLYL/SQTa6EjBtZRcrVX/Ca3BEjW3Ou5Zw62ulN/7g5lhtkuk6y47nksUrmFUqW9jmMBwS+SxgF5qVPKSMJhHgZNRad4PmbutQXkGPBO63u0BxHeqr/UlOuWMHEc+TOnyhC5iOhnxLZbRJVqVDmRGWFul8NYp1Ven2KPDwjAGXyjy6qBXxH+wSrYHdkm93ZemN0R942gNE+dJ4PNEpl99NJr3JwvMepRzl5mPAUKDBOrX+joP9skE0mN2cLsvuHOBtC7iGzZqyI6kz9w6ZlvTXLL/9YD4B9wJk6TdwoNIGFjpMemz/ANxFvqYjl6WKxvsz3/4xsncdzFvgZo9vCGe3p
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czNKdFFIUzJHSkdKK1BMOWpNZDBwSUdzVUd6Y1VXaHZYQW5scUFxamFCS2k3?=
 =?utf-8?B?Qm5KUUM5WWJ4VjJsTWNvWWJTOW1XaVROWHFJY2FlRHhHYjMvdTA1QjFNR3RD?=
 =?utf-8?B?VmJhaERFU1FqcTdjZWlxSEREbmM0VTh0ajhlT21zOEFNbWJKR0tsZXBtTXlt?=
 =?utf-8?B?djFwOXdvT1I3RkVBcjBHVm9KdzV2cFc2V0dKMmlzYTFRWDdteDFaZGxRaGFS?=
 =?utf-8?B?aWNLUVRQSTl0dm40Nk5nV1paelNSODQzczArSTREOW1vclo5T1JXQk1XK21q?=
 =?utf-8?B?MmlXKytYdGxxajdXdnhlZHQ4NHU2QmIyaDNCVGZDU0xkNUo5aFA0aXJJcjh4?=
 =?utf-8?B?eVJ6RlNnUGl4L0kxME5ObUc0eG1yV0phTUJKTUZUM2V4MUV1anZxSXRjMnNi?=
 =?utf-8?B?VFNDMkFKWGVwUDdHWUxkVlRZUXlGYUtaNkNjQWVuNlM5dmVCcGRER2ZVeTMr?=
 =?utf-8?B?SnZMK09CN3EwWjlBb3VaUXBEc1VCMHEvK2ZlQjdLQVBQTnJsZXdPTFcvMGVz?=
 =?utf-8?B?ckltYUV2V2pMNmpjMStjVEkvNHdmRWcrVDNsOVR3dFFkYjRNMEx0ZGJEdmdj?=
 =?utf-8?B?MXRSUWxMNEYxSi9lTys5UmJaWXdNYTFvZFptWnRGcGtlVWx6ZXo1aHlieUYv?=
 =?utf-8?B?ODg0WCtuT0VBOGtrQXZkVzlaL0VxNHhWdUVxQ0o0cFdIQ2ptckJtdU5oQ0xi?=
 =?utf-8?B?WURkbThzUUpFRU1uWUNhMjM3eFFjcXBJTUphU1pnQkdBazFPaWVCNEJQOXFC?=
 =?utf-8?B?Y2lPb2RQaU5rc09oQkw2Z09ZY1V6NFVNbUlVNXhGeFUya3BSTHd6cmxFcDBY?=
 =?utf-8?B?U0hKOFR6Z25USEpvQTU1WDRWVm16a3VXVnJhbjVVTW16Z0tRZ3dweVlPZVFK?=
 =?utf-8?B?S2RjRlVBRmQyWnJwNTRwSXZVeTlkaXppbjZRQWV0SlQwWndjM0tGNVVqZXM5?=
 =?utf-8?B?V00yWkpzRUc1S3FYMmVQdU5KT0d6RkpZWmZjUjJuN1pud2xFdUVzLzdvMm9O?=
 =?utf-8?B?RHJHalRhVWNPT29vMHVUNmpDdjkyRzVjbXlHY3EvdWh4TUlhb05Vd2JyZElu?=
 =?utf-8?B?Y3lNRFNpQ01TdDY0Y3R4bW02RWJ3UFlNWW94a0E1OFptdkpCb0FtU1pxNlFi?=
 =?utf-8?B?MjM2R2pEUWV1WS9NT1JrL1pnMVRFYWRDWTV4Y3ErRCtwSnNhWVpHcmN6N1Jn?=
 =?utf-8?B?QWEycGlWOXdvVnl3d0djR2xRNGJrTXRQVU0yaW94aURiL29jS1pYb0pWWkQv?=
 =?utf-8?B?dVZiaWluZktpWnNJbkpNS2Y4OUo4V0JLeGxjUjVWVXN6cmlleUU0bHowMmox?=
 =?utf-8?B?R1ZjK21FTTR6eGNqb0hob1dubk1aUlJxUU5yM09YSUJjbVhkV0ZxK0xVakpC?=
 =?utf-8?B?MWJHY2JKY3BuVVhhSjlwZU1MM2tvTDcrUWZXWkRNMlAzbDFIV0Y1N1N6ZUd6?=
 =?utf-8?B?ditNVG84Y0k2N2N4NElwYzB6U2lQOHlVY29WNGtQMGRLN0RiQnlLY3J3OWxw?=
 =?utf-8?B?YWpHREU3bkVJellWZ1B3RW5VWGlROTRURUJrcHJvaUFzTmhYRmxaZ2hsTEho?=
 =?utf-8?B?eGFwaldPQUhHSElYMy9zL2xWK1U3bVg5VThFeENPUHUxWERETjBWdDNMZFhK?=
 =?utf-8?B?Wk8rZndRbjlMdEtSajliZWVYY0UxYmZXSHAyVE8wcFR2WWkreUFZcE84blhl?=
 =?utf-8?B?VHA1Mm9ZYmRwbGhMdVIxTmtpM1VOLzcvVDZEQnRJbEhPQTJJNWJmRXkvMEpu?=
 =?utf-8?B?ZDRUT2NJd0lDNWpEOGVzOS9lamFoREdkVHhxU29RdDhuYlBDUTVRMFFldWVy?=
 =?utf-8?B?M2NYYS9rbWl4Rlpad2JKbE95cUxLWG5Jc0E0RHpRSllaeGhQWG1ZSjR3OTQ4?=
 =?utf-8?B?cTJwWHB0QUVzVEVGWVJwNXkxTUM4cDN5WUxmL1RSalZjdUVoTnc4OElwbGlk?=
 =?utf-8?B?ZFJUalEwRHJMR3N6M2FrQU4ydUE1SGVhWFBLYU5TMFlpNm1IK01XT1pPWCtI?=
 =?utf-8?B?Y1plVjVheCtVQ0MyYXcvZnowVExTNDFTMWo0b1FPL2ZlbVMvM3BGS1Q0amVx?=
 =?utf-8?B?L0FtaFlnSGxWc3hMdm5EVktpZmIzY2lHQk4zTzlOWjk2OXlnVVBKbHNhbDVa?=
 =?utf-8?B?NWc0dWZacVRISHhwOFdreDg0Tk5ydzlpTHBiUEI5Tk1SSDJ3MnorMmhkdzA3?=
 =?utf-8?B?SFdwckxiTG01VG02bFpSZVlwVUs0QVhiYldpU0JoYWQvNWtNWnF6bWtmZmVa?=
 =?utf-8?B?TzBrRlFwai9yb1lvOU9EVXV6SmRqcTBYYjdHaGdLekp4dWJ4TkJQdS9qYlBU?=
 =?utf-8?Q?EGD3ESqFye4+lAofPD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a755ef-ee8d-49f3-789b-08decc7cabae
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 14:28:16.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEzC4sD7dOd79vs/+OewygpGPUTD1GXR88UQ6YdpVsQoS3M1SASl4Bxn35lkXPDK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6711
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB69118000B
X-Stat-Signature: zoydj5ouyiaqccawbe3afjypsyhz89jh
X-HE-Tag: 1781706504-138407
X-HE-Meta: U2FsdGVkX18hoOJER1/tUMfKwCLoUEqCpko1/AeC6/Qy2Zyp7y0ziFibZKb/RmEu2+AKvqOZ4S15ZMGvUm3E4HC8ZItWx6UpIuuW4gW/u6z88NI96nLq5JLx6VcUJ1GVtKRFdAoy4sDZcFx5uEBhmUXeApVaPb+qPpCxu0Zcn5CVqQADKAxclttdbUCIaf1rDVIOn5X2T8P2WQ20JhHhVh3tftHDTmS/0Q0kiZSvdrAfDO6ouLTA/Z0C0JTqHlSEXabC4z2fDaUa8ujqlvdhM3W8cZNb8dPwdlydEg0OcOrGNSBGRwEgVJzs95hPM8SlBtrU0HGUT/DWPvVXB7hk3EOCoJ2eBiWASJcX7E8sqkJIJEMfwj60NM5ptaWrUlSUkAIOjOViW3aJu0+9rw3u0+cSuRCrQpaUtzu4J2MD7p0H5zDcN7I/7ZHNFWwC9KrkGdNcZiRVubW2d4XivK9F4BzX5aBcWm72nTyh16dk4KqMTrPLzvJQmptQi4MfjQM1pokHpxYKEmPmKjCApuv5ht10OkF1AcSWEDGqxflIEGu6KVRP0Mjz3Mxixh0aOJkKX0zFUeseOvveQiAH0wM2KdfW5jpeKFB1Hfm0H4t+W0SeUQMWjyi79tB/mimxOBTwRL+AKfhF45/hAYSuU+yPVQirWPuIWmn+D0z42RstRIMijc5M7myZEgAosmlnzeLfRlxSLBYBYGsvo1O6uB8jery5Obyww9OU6QvW6WWw/eiLrJbsg1w8zbUughih7S5SLeNRhL2vfYNwOwaQCIV9ABWmblohiNsonzyUAzKukl8FY8D6WJh65oVf0Y4+MUSY/pCPMBUxBW898N5o+SLAz24zk9XpPNNN7STgHB+H9jE6+yxLINIj9j/xDXeJze3NI4cLwODyd9tYMIeclirWBRARfsSyBJ2ctBAof1b5/UyGtbUGehL4PN4KIR8aGsYN4+Wfinl99c0Phj7DDRJ
 PuJGrv+3
 7wBjIj2L+imwMtUShUGaMlu5pQFq/Vj5Es6AFnml/TXOauKSNSropHCLi/sG0C2s/bcF90qDPIAJVCuC0ZUS7TUfDgggzVg7TQFQGmNSuBUEF5L8RHIMpD9/zCQOwNKhaZkpmCHLYhlFQdC4Zp9vCShy6X8QBhJ22gWkbfI78+zQshWltqGC4KKrf2hcp+/1iprWrAyhofYAt1BkChReLKFO7L1nu2k4NHS5Vk1MgKWIZAW0wMSvDcX1mq3IgTxM+iVd2vPQTLLSWfHLkemyKhXA5oKDT4+/S1HpJfYOdawomPJ6TbjhS2L3q4ARmoGNQWytvI3ACIRUqvcBKJFKd0Ox6FoDjpXB9bmDhSjtb1hwvNUI26Efzkj0F/YMub5ankB4zCPKEjeDSWOqLBAHGemlBISdstLoZWq66GLi17AKDN1QjiJvOoa2mohGNix5JBwMBwEbt+bRVJyw98lfuTG+2rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 17, 2026 at 4:26 AM EDT, Kefeng Wang wrote:
> In mprotect_fixup(), the PROT_NONE PFN permission check uses
> walk_page_range() to walk the page table. Fortunately, the caller
> always passes start/end that falls within a single VMA, the
> do_mprotect_pkey() iterates per-VMA via for_each_vma_range(),
> and setup_arg_pages() passes the whole VMA.
>
> Note, walk_page_test() isn't called in walk_page_range_vma(),
> however, prot_none_test() in prot_none_walk_ops always return 0,
> so it's safely replace walk_page_range() with walk_page_range_vma()
> to eliminates an unnecessary find_vma() lookup.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mprotect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028c..d26e09862daa 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -753,7 +753,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_g=
ather *tlb,
>  	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
>  		pgprot_t new_pgprot =3D vm_get_page_prot(newflags);
> =20
> -		error =3D walk_page_range(current->mm, start, end,
> +		error =3D walk_page_range_vma(vma, start, end,
>  				&prot_none_walk_ops, &new_pgprot);
>  		if (error)
>  			return error;

Like David and Sashiko said, a fixup like below is needed. Otherwise,
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028cf..323949638894b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -708,16 +708,9 @@ static int prot_none_hugetlb_entry(pte_t *pte, unsigne=
d long hmask,
 		0 : -EACCES;
 }
=20
-static int prot_none_test(unsigned long addr, unsigned long next,
-			  struct mm_walk *walk)
-{
-	return 0;
-}
-
 static const struct mm_walk_ops prot_none_walk_ops =3D {
 	.pte_entry		=3D prot_none_pte_entry,
 	.hugetlb_entry		=3D prot_none_hugetlb_entry,
-	.test_walk		=3D prot_none_test,
 	.walk_lock		=3D PGWALK_WRLOCK,
 };
=20



--=20
Best Regards,
Yan, Zi


