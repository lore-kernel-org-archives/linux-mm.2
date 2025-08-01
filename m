Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9CAC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 11:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7756B007B; Fri,  1 Aug 2025 07:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3785B6B0088; Fri,  1 Aug 2025 07:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2191C6B008A; Fri,  1 Aug 2025 07:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB4D6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:11:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA10D114CF1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:11:04 +0000 (UTC)
X-FDA: 83727921648.01.E481A5A
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	by imf30.hostedemail.com (Postfix) with ESMTP id D6C578000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:11:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EwnaETLj;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.86 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754046662; a=rsa-sha256;
	cv=pass;
	b=TKvi6IjuI9cXSC5+nloFH79avu2x+Qdf5Q66vrNjBZ9SePKYSczcV/FulhxTJ0iAzz8t+S
	p3nhdxQ152JBqlTQ02Bgb6KK3XOvDX1z8YuIBRDSSigTtuPdcWWKFVyJt6ct+W4Fe42Tvv
	cMbGnHFXXml8EYUEHFBtTk0IZ4gkWH8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EwnaETLj;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.86 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754046662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iE4DKnftTb9bV9YQmVcMh35SwAW8f8Gx1oiZ+8ADuVQ=;
	b=vOSpAcZrXI8nbfejM8mHuQ03T66tfN+VboAA38XJgiXOwKL9rYV1Xcft5C5qEYvyepwfCW
	KD3Hzb3ORr8H5HEtQ3z/XrHLA+D1PsJ4wCLiNWw4jr7nfKgI+URYiLfcxijF1Kffzrb3Ut
	KElX+IqA9owMB5QcHElKDGjnqi0b9H8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwRYOtiiB6lytzC1p2NKPzfCsMejkjBwhUxeJnFisAHCo4R2bg8rPhdrz9VcRe047wEEwxX8LN7VgCy7xO8sE16zOQo0tgUmAkVSmlokC650m3QW2TAJCxoo43s1n0cjjxEf+PR4RZx8di9qq3cCWxrLy6zgH/GB22SphJk22Am/8uftT1Ikc2Hwkv6B75K9GnJ89s2lAO/7ipSG5NYuRHHz//C5EKaRfk/QOPH00hpXZJnYDhgKonTvae//9SZHC/3dZ9uPz1MyxF8vhJpLjUgHng6sra6KXkd/tS25ecRwMHeyihbyORTMTR9oyUEj31qO9h6UipNHlziJkOvQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iE4DKnftTb9bV9YQmVcMh35SwAW8f8Gx1oiZ+8ADuVQ=;
 b=wdcgEhAPkX7ODdiP5vGxEEAjX8QXeO9BiQny3rSAY0g8cVVe8dkv7LOEBpUe/MALJErY2/ednHN8tycCTpd25xUdDgRcvKjIYiVQmT4I3ecD0ByDewsl860TZ23UmAh7StL7b7o9vygF7oAzglvgmYCsm8KkespursO3Mr67aRe9ZekbTDer5/bMmXeXo4zVknvSQFQFoAi7eBf9L3JC1X7v0APN82vygF+4sOqmZceQN2GBPfMKdm7COeEk0ECWE9f0T0Uh+XIhUP3QDdoI6wpBag+ojRSscKeWIopvWZdXd64KF80nZ6sAUyobSw1oGZaHzD6pM1IQUk/TAN2AgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iE4DKnftTb9bV9YQmVcMh35SwAW8f8Gx1oiZ+8ADuVQ=;
 b=EwnaETLjH5khAnFo+L/76nCi3aB0xV3N1p7rCakZBV7b9Nwsz2isgx9m7SeIncoWf4i2YAx89v0wEMgQ5a/BgbpWLZaUY+d99AY4c53X4viQSSQ/Z7jE+qtAlweGwqRfpo4ttI61VaG7+o9uqlhZrJ3Ay/p9O9tLZNXuUr3IcW7h1efjTkf5dv3CBnyWKunaOfhVYsVATa4nWM7KziUm4+KgfJ9LoHVzhgtUkDIMgrLIxWHMkFI2eni07t5Dg4x5WF9DC/Q2sryZGlXwsTwTM5WMtD6p4Yy0UDl8l5xH9TJ4STZMpFlcXPxbkVWnZ1jTd79z2QKBPeLt8u3Yrk2stg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7972.namprd12.prod.outlook.com (2603:10b6:8:14f::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.16; Fri, 1 Aug 2025 11:10:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.015; Fri, 1 Aug 2025
 11:10:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
Date: Fri, 01 Aug 2025 07:10:51 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
In-Reply-To: <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR07CA0059.namprd07.prod.outlook.com
 (2603:10b6:a03:60::36) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7972:EE_
X-MS-Office365-Filtering-Correlation-Id: e745d4c9-c9ca-4ea7-6bfa-08ddd0ec1719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VFh5bFcybmVEUG5BU2JWaHI0NDFiaDFDVXNBQWhOeDBPZXQ5WGpoaEhWUGI5?=
 =?utf-8?B?NjJ0UzdkQ3k3cmZsa3NaclczQnRRUFU2Z2VqbEVxUFp1Z0FPcm5NMUZpUjhF?=
 =?utf-8?B?UUVQVWJ6bmFHUUFNUE1qbzlMaU9tZ0JtS01PVksreUJSYlk0dWI2K3c5ODNK?=
 =?utf-8?B?TlFOLzZ5QVpjL2RGSGZXWVZZa0U1L2xyOVNNVjI4OUg5bEJQV3dNR3kxTGQ3?=
 =?utf-8?B?ZjJjaXFEWml5WTdJNWd0RFcvbUtsbWRhOVpKRW1leTNNRTkwVUs2WEZqTE5L?=
 =?utf-8?B?cS9OZGZLc2I5Mzc2VFdkckx5MTViaFZPM2IwNkNKRk02QWVCN0kwWUt2eEtm?=
 =?utf-8?B?dVp0dkRGbGJ1OWRiSmVwWDZacFBlUmhySXNiYS9LTHdLWFpvK3R0Q3FLME8w?=
 =?utf-8?B?SFhlYUtld1hJeHVqdUFPWHRwQ0RMdmpwNG5tMXhSSGRLcUVza200em1yVTJU?=
 =?utf-8?B?aVg3Qmp4UnZwSlNzUkgwMFoxNFpDRDRkMi83YW85Q1pMQ2ZBN2FyM3graEhl?=
 =?utf-8?B?dFkwR3JmS3lvbkNWTktxUE9XeDdlWlVtdUt2YVhHTGpyQXA5OTl0ZXNGSmFx?=
 =?utf-8?B?cGZMUkR2UmNkV1FMbEIwR3lVSnNiWEhYY0xjbWlwRDQxS05pbnVCMzUvZisx?=
 =?utf-8?B?YUNxbStxQnhORE9mbkwwb0xmNE5sT1dINDRTdDFDRERtbE14dERDTzJEUUVs?=
 =?utf-8?B?cjFBdkpWNS80YVVsS0ZLWlJlQjhub21VMnFkeTdBem0zblpSRjFiWjlCQ09m?=
 =?utf-8?B?WEpFNHFWK3QwS0grQ0RGYkN1eXBPWkYrbEZaR2Mzbi9JUGgvVlU1RW9nZlFk?=
 =?utf-8?B?MzQ4RWhuNnpWUG1SQ0hXM1UvRVJmUFRBc09haFk1N2Iya3JvOE51RmVZaDNy?=
 =?utf-8?B?S1NVNDE3QVNUMEdyajdGM3Eyb1NsbTg0cTdLU01rR0VwR2xQKzRFOHNLY0px?=
 =?utf-8?B?SXp5c1RDV21IZ2J5dlA5WXhvRkRzZUNxWVQ0VHp1RzM2K3pQZlppTExJeUhD?=
 =?utf-8?B?Y0F1NWU1UHFMZzhtemZpMGUrRmV6ZDFuRXNnSUM0L0lJY0d1TVNLeGhHOTQz?=
 =?utf-8?B?ZXJVTWpiYldLU3RpbVExMkpHdHIzazlSZXU0Sk1FTC8xdFNHZjd0QW1XMk8z?=
 =?utf-8?B?VEkvVFNBdjJrSVFWbkxEeEpibFcvY3RvV0dMM3V4UFNqb2RsYVYxK0ZJOW5J?=
 =?utf-8?B?Znc5TjNFbzQwRUkzT0IwM09PWW9GUlZFbDQwczIxdlkwWWlkMnNXUjdTTkhO?=
 =?utf-8?B?Y0ErR3NhRnlrczNFNEVTcS9pQ0czV2VneWtWUmNkN2R0NkpqR1JIeG1ZbHpa?=
 =?utf-8?B?b1haU1pQcFE1allTckU1WGNyYU1KRmVoUmJXSGplRmJXaTBIRVZtcHdIdjNa?=
 =?utf-8?B?MVBkUGx2Qko5cmM4c0IrRXJhcExtR0l2dWt5NFVFaWFReW1KNTJYalBGNVZM?=
 =?utf-8?B?akNzZzBkNGwxcjVGYzVlamM2OGNjN29FRWpXc0J5MnZWcSttbVk3NmZ5U1dC?=
 =?utf-8?B?U1A5L2FiWU9DdFQ0aXRqTXU3Z2ZQdnNadjl1VjVrdEltRE1WTlRwN2Q0bmJN?=
 =?utf-8?B?b3hUT3FraVBHZldoNFZGOWI4TkJ4aGlmVDR2a0ZaaWFUNTA3ZklHR3pjc3E2?=
 =?utf-8?B?V2dKa0VwVmwwZkNlZG5pUENSdllBRTFGL3I4OTVESTRQTUtaY3U0czNHSmdi?=
 =?utf-8?B?dllRaENEQkNETmZwVVQ3OC9BcFZ5K0FaNFdYQ1ZlMkUvTDYvOUlMSlpycU1I?=
 =?utf-8?B?MWpwY3MwNitha1BmVTN6WGhGaCtTS2MyZ1Z2dlQ4UnBoQnhpbEtITDlUdk5D?=
 =?utf-8?B?WUJNcVFlMjI2R0NMQ3Q2TFFMRXdveDB2TlljTjN5RVVZQnExR0xFRUUyQjVE?=
 =?utf-8?B?TEJmcklFZUMzT3dZaGRkamVwZTFSOGhvOXhlbytNenhrRjhNZjd4UjBDeDhu?=
 =?utf-8?Q?sCywtStY5Do=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTc5TFZFcENxQnkyRWl0RlRoZjU1eEZ4TFhzUzNhNnl0cjdlMlNsbW5NdU5X?=
 =?utf-8?B?MTRLZTA5ZTJWVnhJVllHeElYM3R4OG9QOTBXUTBXemNJcjJPcmQ4NzN0cmhE?=
 =?utf-8?B?RVBnaG1XTHJ5Q3plY2xmaXBqNmQzcHVSTkVPL2FEa3BBdDRiU2tpaDZvZE1W?=
 =?utf-8?B?a2hJeXhSaWlPdW5LN0VPMnh1SVBBMEM5NVpwV05HNEF4T3JxTTJRNXBKWnh5?=
 =?utf-8?B?YldEbFZZWHNBenRnNisyZm5ucWNwcHUxK013TVFIZmhITUxKdXowWGQ3bFRJ?=
 =?utf-8?B?aVdodDdERS9qN3V0ZitDTTNkU2pqeFlDK1htSFFQcEZ6OXozQjY1S2pqNzNm?=
 =?utf-8?B?c1VGMDdHTHlvWGo1Ny9Ldk5zSmwvbmlKZG5DbjByWVVPOVBVd2dsSWVpc1h3?=
 =?utf-8?B?VGszRldkM1lEOUhBckRaRkxsMWlESWl1bnlRR3NIbURISFR2NVY5MGFyZjRK?=
 =?utf-8?B?ZXB0YkZub2Yzelk0dXRjRWlpbm44SU9kQkxDYzVUdXBzdThDd3cxdGlSWFFj?=
 =?utf-8?B?a0ZOQXUvVHpvSmtMREdKcWRDbXFYTW5nMmRBSTBNbWFDd0RiQjBmWnVpUWNz?=
 =?utf-8?B?bzkwdlVHaDVzLzNQYlpFTjNnNlJvaFdoYnJTa0lEUEZRS1BiOG5PQVl2S0ZQ?=
 =?utf-8?B?YXJ3MG1jZlRFcE9OdWx2aHZpRnhQc3ZENGtTQm9vK2c5RnRLekxnSHdLaTUz?=
 =?utf-8?B?cWZpZStNaTJRb3lxQk8ySVBpakpnOTUzc3lDemNXSnBzbCtxTVh0bDdSZ0RI?=
 =?utf-8?B?ZllWUGlWQ2k5bThlOFBrRVFzWndITG5CQmpBVmF6YUw4TWxCbStnSDEydGFH?=
 =?utf-8?B?TXNxWUR5WWhsOEpGUDk2ZjRSZ1pGbkxKZUd3aGUyTTJVRGIyMk04NzlJSC9r?=
 =?utf-8?B?blJMWDAzTHhxYm9zTHdrVHJRUWw5NEFhRmp6NW1tMVhZNFgyeTVPQ2R6VG4v?=
 =?utf-8?B?SllIQmN6YXgxOEpuWm5ONWVqbVVIQ2tva0pvRXFMKzFBWU5uMFloUFg1L1ZN?=
 =?utf-8?B?UmdwZ1h5dlVmRUFvd1JGUDkwdHdvT0JSaHcrU2dEU2JJWW0wNmg0TnYxTkZn?=
 =?utf-8?B?TDlaSFJ1N3kvV2Rickp6Y3o3QStpdzlKbUhOYnk4Ymw1enJlVXZZalJMRlhh?=
 =?utf-8?B?QUh3U1hRZ0JiOW4zUXFYdmNsOU9CWmFheTJ0T3lBVURPZEI3T01uRDBBZkZu?=
 =?utf-8?B?Tnk1amtwNi9KSHUzeG9Ma05lZkhFQ3NCZXJOM2FOODRnYWtVKzdpOFIzNU5t?=
 =?utf-8?B?R0VNQjE1RXJnbXdEYnVxNVZXOXpXK1o0cDlOSFV5M2x4OXMvRXVIVUcrYjlx?=
 =?utf-8?B?VUY3YnpVMkMydUcvb2tvSzFxTHdBTW9iVi9CbEl6eWIzQ0ZlY0g5dGV2dXpI?=
 =?utf-8?B?b3hUWm10YVM1bEM0QXU5Qm1pK2t2dmRsLzl0Z0lhekdLWmtjYTJ6N3pUcUE0?=
 =?utf-8?B?RktxTC8rSkFBbERwUHNMZ1dheHNDWWJXL1FUMzN4UXVINXZ3UmVqS0NzSGwv?=
 =?utf-8?B?aCs0QjRyNGNRbzYzWUJROE14QmlGb2RDSXhnTHlKSCtKWCtibEtJVEt0SG1F?=
 =?utf-8?B?eG9pek14b1ZTN09Dd1c4amw0OGhxS2RZT0F1ai9HaVdabXozOVE1VHRrRURJ?=
 =?utf-8?B?akZOKzZKM0lQMmEvdUxxL3BVR2FyM2ZYNHBsUFhFREpwQzJ4TGZxZDRNNjJ6?=
 =?utf-8?B?amNUR08yRVd1dDhyMmxtWTRMVUFMVXR2Q1hhM09TMGxEY3YrSXoyOG43RFZi?=
 =?utf-8?B?L214RE85RDdObi9sL0xMU1NxNGJYT0hYbWFSYTYzNTFmK3RDSnFZWnJLYWV6?=
 =?utf-8?B?OUw3WlVKRHBnWktibml0NXJYU3ZBWlU2NENpVnlyUllxaTZkaEFsaGwwamNV?=
 =?utf-8?B?WnFlOTJhMzlHQU9IRTJrOW5YeUpGcmdRK09RTHlYUUF2eiszcVp3d2RxbTBG?=
 =?utf-8?B?RjNnNERMQ2M0ZXhPdG12N092OVNMWnVJeDIwcFpHK2ViRGl5N2ZybE05bmVS?=
 =?utf-8?B?cGh6RjBEcElIUW5pa0M1TkZlb0toamlsTUpENDBkYWRVamRkejJJOC9vNngw?=
 =?utf-8?B?V3poeG5BeXRaSkNsK1Y1TVUxeGxkVGd0OXMzdWVVQWZ6bVIyZ0ZVczhWU244?=
 =?utf-8?Q?9FKk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e745d4c9-c9ca-4ea7-6bfa-08ddd0ec1719
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 11:10:57.7230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMUAI3A9w2OWs/9hEMBPn1Y2FwZ+ibXWY1bnenva/Koo9NW32duc1teFaWFBnSQH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7972
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6C578000A
X-Stat-Signature: ys3erh4eggpssoywxnp9m8fw713g59mk
X-HE-Tag: 1754046661-622782
X-HE-Meta: U2FsdGVkX1/9rH+WO3GAJO4hxGsUrHapqMcp3VrKBxjPyDKeLDVjYZXr0EVXANmXcYqMrPhGhD7PKQmxgosim1Ldd0OOaBWefwXsa1flYgY/SwttG4XpsbcfcZhNYV6NKHLKTURpMXRr+oxDdpr9yTP/rib+Bqsy0wwkyooJbAj9Wr2GGcQP0W+W6PxbWLw+8TmofEHvUJDu8jxHgViefxQ9m7MTHLy76jS8CpRT9OapVFFlZvIBLnQJ1boYUrflbAW6v3tuMGYhCQ+VZYov6JYqzZ/cJRbiYw9sfgQFIFdMz/0WDmi4Ytsm44S8ePNBqAe71p5YaGPsR5qdjEiyC6K/e9sLrLoyasuzlj7miljJYO3I5WwFs78e093OMt5EyiNWcRd4Dk9kIjqLA1MexF+q3natDX42bHNZcqRxAqzaW14fTIW8BIH6H17hifTe/IHUWYGrK5wMXykCD0pdF0PN5WQL5MyBP1f1iBgW7lWGiT9+titPG0i/a8EH9h769YmFYriG05G61AxBA5I1hg1pXRrEZyYb/YWvZOgXFWx/JPXkvnG6iS5Jk9tP4wroWUWsANLaqV7qMfrqMgPd9vCnhL49ObFyOwl233IArvpVQo8TAhy+WZ1EECK04ChZLheIAoXrsh4AWv0x4ZRIV/o76orTCbrPUW6SXLTVLr7ultPOwf5VnEoJYxD0/UdSbLMBhR2iqxlma/sQp59Yq/Kq3mMnp6tbjRhnP5wByg6GAjjEbVCCweQcB9R5e4JXDV5EYBhXTuLSHyevDb5JZh0YjfC8BDzZ8uMMGG8qlY7KOE4q7iuqFCsklfg75Fy6/fqcB7VO/HcAJqOu0q0e2ChooOErZdTCHMXIkc744zx4+wzIAL5DtToqflRsmN5JPPTOHwbQFrXFAMUeysxwbvu3mkG5BYOqdLLY5YbhTaVxlxf2ipcuLg+HJOlXYGclHeuu8mcY23ZA0xG4wDj
 KsyBpNN9
 gNQAUEKhmg7hAfEjJ2ba83PKtNy3zIqNLhdJBtLunuKp8o2wwZ5v9Pvmw770ZBIMO0w0sC3AnW/NdiYGQyhNv/vS6dDWVzx1nqvHrjLHRe/qXuSiMq0C9JIyeUBdvSzNUn2V0m5TZI+vVPVeqMuLbh+svgrZkulyJbHsrUrwAEF5rBdR19DbP8BRXWMNOUJxN8N7PO/UYO8MrLvpq9vXe3weVf6UA5AhL0wqSoky97dwxNu2gpr61gCuoF43QaLasHRwLoZ/OOsGneQSvqXwHIPb+4jAjXrA1/0K6NGgj46n4wNijJSRn2jIf+Zt1zq43JsNguhiTsKavL9sRJZl9XpMfx7AVE6xFnGBHxzu/2DFp1GXeXnZW+ukD8wREu/0E2jtfVmCL2C1sAyujGie72SmFE9iJMlV1Oox1UJJggLmg9NppoIzklpFvDGLvBTrbDvgtpHzu5i0X9APBi5K8l3dwRO+43vYKnz7t6HIsSsSMBeWJ9r3XufuoohmO+h5VAsN9Hu1160mPgDsP+7yNxZ9uwQi13LJGL5EGjCWQCXRq8angBBZp5oVDrsTY5nwye1629fsCsF+dkY7q8VfF2lzOGcBdDT4vCXk6tHaKeVMOGl1eXkTJ/WTHjQijYkXVtMgomkaXtrALXNioyURs0C4sc0foWQ95lwJ1oPdwripuitSINNT/VpubyX7Xw+JGWaslo9sqQ3G/4lu2rJSTlLqIEQ9+8yLHUvBrYY5zOw+cTOgonDuR///wSpp6DGspU1FFlXmaOacDCjuD3i2cJUiISmhI1pbZK+wPHPNqMxF/f+zDWtAojd+emHxNjEohkPEXrb+rcYJsaJrFnzTNnrmnSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Aug 2025, at 4:46, David Hildenbrand wrote:

> On 01.08.25 10:01, Balbir Singh wrote:
>> On 8/1/25 17:04, David Hildenbrand wrote:
>>> On 01.08.25 06:44, Balbir Singh wrote:
>>>> On 8/1/25 11:16, Mika Penttil=C3=A4 wrote:
>>>>> Hi,
>>>>>
>>>>> On 8/1/25 03:49, Balbir Singh wrote:
>>>>>
>>>>>> On 7/31/25 21:26, Zi Yan wrote:
>>>>>>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>>>>>>
>>>>>>>> On 30.07.25 18:29, Mika Penttil=C3=A4 wrote:
>>>>>>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>>>>>>> On 30 Jul 2025, at 11:40, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>
>>>>>>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 7/30/25 14:42, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pag=
es aware of zone
>>>>>>>>>>>>>>>>>>>> device pages. Although the code is designed to be gene=
ric when it comes
>>>>>>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed t=
o work for THP
>>>>>>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zo=
ne device huge
>>>>>>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other =
code migration
>>>>>>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_map=
ped_walk() will
>>>>>>>>>>>>>>>>>>>> return true for zone device private large folios only =
when
>>>>>>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent =
locations that are
>>>>>>>>>>>>>>>>>>>> not zone device private pages from having to add aware=
ness. The key
>>>>>>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one().=
 The other
>>>>>>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/di=
rty bits, which is
>>>>>>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvest=
ing.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries,=
 use
>>>>>>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as=
 for zone device
>>>>>>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> Zone device private entries when split via munmap go t=
hrough pmd split,
>>>>>>>>>>>>>>>>>>>> but need to go through a folio split, deferred split d=
oes not work if a
>>>>>>>>>>>>>>>>>>>> fault is encountered because fault handling involves m=
igration entries
>>>>>>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are ex=
pected to be the
>>>>>>>>>>>>>>>>>>>> same there. This introduces the need to split the foli=
o while handling
>>>>>>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but =
calling
>>>>>>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_u=
nmapped_folio()
>>>>>>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks a=
round
>>>>>>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through u=
nmap and remap
>>>>>>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>>>>>>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 include/linux/huge_mm.h |=C2=A0=C2=A0 1 =
+
>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 include/linux/rmap.h=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 2 +
>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 include/linux/swapops.h |=C2=A0 17 +++
>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 mm/huge_memory.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 mm/page_vma_mapped.c=C2=A0=C2=A0=C2=A0 |=
=C2=A0 13 +-
>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 mm/pgtable-generic.c=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 6 +
>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 mm/rmap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 22 +++-
>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 7 files changed, 278 insertions(+), 51 d=
eletions(-)
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge dev=
ice private folio into
>>>>>>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migr=
ate_device logic to
>>>>>>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a refere=
nce via folio_get
>>>>>>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct folio *end_folio =3D folio_=
next(folio);
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct folio *new_folio;
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Split the folio now. In th=
e case of device
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * private pages, this path i=
s executed when
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * the pmd is split and since=
 freeze is not true
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * it is likely the folio wil=
l be deferred_split.
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 *
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * With device private pages,=
 deferred splits of
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * folios should be handled h=
ere to prevent partial
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * unmaps from causing issues=
 later on in migration
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * and fault handling flows.
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 folio_ref_freeze(folio, 1 + folio_=
expected_ref_count(folio));
>>>>>>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped a=
faics, why can't there be other references in addition to the caller?
>>>>>>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio=
 is unmapped in
>>>>>>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() i=
s not aware of
>>>>>>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>>>>>>> Maybe we should make it aware of device private mapping? =
So that the
>>>>>>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device pri=
vate mapping,
>>>>>>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, =
4) unfreeze,
>>>>>>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>>>>>>> Ah ok this was about device private page obviously here, n=
evermind..
>>>>>>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and=
 folio is mapped to CPU page tables as a huge device page by one or more ta=
sk?
>>>>>>>>>>>>>> The folio only has migration entries pointing to it. From CP=
U perspective,
>>>>>>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() =
unmaps a to-be-split
>>>>>>>>>>>>>> folio by replacing existing page table entries with migratio=
n entries
>>>>>>>>>>>>>> and after that the folio is regarded as =E2=80=9Cunmapped=E2=
=80=9D.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The migration entry is an invalid CPU page table entry, so i=
t is not a CPU
>>>>>>>>>>>>> split_device_private_folio() is called for device private ent=
ry, not migrate entry afaics.
>>>>>>>>>>>> Yes, but from CPU perspective, both device private entry and m=
igration entry
>>>>>>>>>>>> are invalid CPU page table entries, so the device private foli=
o is =E2=80=9Cunmapped=E2=80=9D
>>>>>>>>>>>> at CPU side.
>>>>>>>>>>> Yes both are "swap entries" but there's difference, the device =
private ones contribute to mapcount and refcount.
>>>>>>>>>> Right. That confused me when I was talking to Balbir and looking=
 at v1.
>>>>>>>>>> When a device private folio is processed in __folio_split(), Bal=
bir needed to
>>>>>>>>>> add code to skip CPU mapping handling code. Basically device pri=
vate folios are
>>>>>>>>>> CPU unmapped and device mapped.
>>>>>>>>>>
>>>>>>>>>> Here are my questions on device private folios:
>>>>>>>>>> 1. How is mapcount used for device private folios? Why is it nee=
ded from CPU
>>>>>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 perspective? Can it be stored in a dev=
ice private specific data structure?
>>>>>>>>> Mostly like for normal folios, for instance rmap when doing migra=
te. I think it would make
>>>>>>>>> common code more messy if not done that way but sure possible.
>>>>>>>>> And not consuming pfns (address space) at all would have benefits=
.
>>>>>>>>>
>>>>>>>>>> 2. When a device private folio is mapped on device, can someone =
other than
>>>>>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 the device driver manipulate it assumi=
ng core-mm just skips device private
>>>>>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 folios (barring the CPU access fault h=
andling)?
>>>>>>>>>>
>>>>>>>>>> Where I am going is that can device private folios be treated as=
 unmapped folios
>>>>>>>>>> by CPU and only device driver manipulates their mappings?
>>>>>>>>>>
>>>>>>>>> Yes not present by CPU but mm has bookkeeping on them. The privat=
e page has no content
>>>>>>>>> someone could change while in device, it's just pfn.
>>>>>>>> Just to clarify: a device-private entry, like a device-exclusive e=
ntry, is a *page table mapping* tracked through the rmap -- even though the=
y are not present page table entries.
>>>>>>>>
>>>>>>>> It would be better if they would be present page table entries tha=
t are PROT_NONE, but it's tricky to mark them as being "special" device-pri=
vate, device-exclusive etc. Maybe there are ways to do that in the future.
>>>>>>>>
>>>>>>>> Maybe device-private could just be PROT_NONE, because we can ident=
ify the entry type based on the folio. device-exclusive is harder ...
>>>>>>>>
>>>>>>>>
>>>>>>>> So consider device-private entries just like PROT_NONE present pag=
e table entries. Refcount and mapcount is adjusted accordingly by rmap func=
tions.
>>>>>>> Thanks for the clarification.
>>>>>>>
>>>>>>> So folio_mapcount() for device private folios should be treated the=
 same
>>>>>>> as normal folios, even if the corresponding PTEs are not accessible=
 from CPUs.
>>>>>>> Then I wonder if the device private large folio split should go thr=
ough
>>>>>>> __folio_split(), the same as normal folios: unmap, freeze, split, u=
nfreeze,
>>>>>>> remap. Otherwise, how can we prevent rmap changes during the split?
>>>>>>>
>>>>>> That is true in general, the special cases I mentioned are:
>>>>>>
>>>>>> 1. split during migration (where we the sizes on source/destination =
do not
>>>>>>  =C2=A0=C2=A0=C2=A0 match) and so we need to split in the middle of =
migration. The entries
>>>>>>  =C2=A0=C2=A0=C2=A0 there are already unmapped and hence the special=
 handling
>>>>>> 2. Partial unmap case, where we need to split in the context of the =
unmap
>>>>>>  =C2=A0=C2=A0=C2=A0 due to the isses mentioned in the patch. I expan=
ded the folio split code
>>>>>>  =C2=A0=C2=A0=C2=A0 for device private can be expanded into its own =
helper, which does not
>>>>>>  =C2=A0=C2=A0=C2=A0 need to do the xas/mapped/lru folio handling. Du=
ring partial unmap the
>>>>>>  =C2=A0=C2=A0=C2=A0 original folio does get replaced by new anon rma=
p ptes (split_huge_pmd_locked)
>>>>>>
>>>>>> For (2), I spent some time examining the implications of not unmappi=
ng the
>>>>>> folios prior to split and in the partial unmap path, once we split t=
he PMD
>>>>>> the folios diverge. I did not run into any particular race either wi=
th the
>>>>>> tests.
>>>>>
>>>>> 1) is totally fine. This was in v1 and lead to Zi's split_unmapped_fo=
lio()
>>>>>
>>>>> 2) is a problem because folio is mapped. split_huge_pmd() can be reac=
hed also from other than unmap path.
>>>>> It is vulnerable to races by rmap. And for instance this does not loo=
k right without checking:
>>>>>
>>>>>  =C2=A0=C2=A0=C2=A0 folio_ref_freeze(folio, 1 + folio_expected_ref_co=
unt(folio));
>>>>>
>>>>
>>>> I can add checks to make sure that the call does succeed.
>>>>
>>>>> You mention 2) is needed because of some later problems in fault path=
 after pmd split. Would it be
>>>>> possible to split the folio at fault time then?
>>>>
>>>> So after the partial unmap, the folio ends up in a little strange situ=
ation, the folio is large,
>>>> but not mapped (since large_mapcount can be 0, after all the folio_rma=
p_remove_ptes). Calling folio_split()
>>>> on partially unmapped fails because folio_get_anon_vma() fails due to =
the folio_mapped() failures
>>>> related to folio_large_mapcount. There is also additional complexity w=
ith ref counts and mapping.
>>>
>>> I think you mean "Calling folio_split() on a *fully* unmapped folio fai=
ls ..."
>>>
>>> A partially mapped folio still has folio_mapcount() > 0 -> folio_mapped=
() =3D=3D true.
>>>
>>
>> Looking into this again at my end
>>
>>>>
>>>>
>>>>> Also, didn't quite follow what kind of lock recursion did you encount=
er doing proper split_folio()
>>>>> instead?
>>>>>
>>>>>
>>>>
>>>> Splitting during partial unmap causes recursive locking issues with an=
on_vma when invoked from
>>>> split_huge_pmd_locked() path.
>>>
>>> Yes, that's very complicated.
>>>
>>
>> Yes and I want to avoid going down that path.
>>
>>>> Deferred splits do not work for device private pages, due to the
>>>> migration requirements for fault handling.
>>>
>>> Can you elaborate on that?
>>>
>>
>> If a folio is under deferred_split() and is still pending a split. When =
a fault is handled on a partially
>> mapped folio, the expectation is that as a part of fault handling during=
 migration, the code in migrate_folio_mapping()
>> assumes that the folio sizes are the same (via check for reference and m=
apcount)
>
> If you hit a partially-mapped folio, instead of migrating, you would actu=
ally want to split and then migrate I assume.

Yes, that is exactly what migrate_pages() does. And if split fails, the mig=
ration
fails too. Device private folio probably should do the same thing, assuming
splitting device private folio would always succeed.

Best Regards,
Yan, Zi

