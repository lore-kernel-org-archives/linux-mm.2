Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE36CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF468E014C; Thu, 18 Sep 2025 11:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468798E00F6; Thu, 18 Sep 2025 11:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E228E014C; Thu, 18 Sep 2025 11:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25E028E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:49:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA75F11936A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:49:54 +0000 (UTC)
X-FDA: 83902806708.18.7794A6F
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010020.outbound.protection.outlook.com [52.101.85.20])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0F8D140004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:49:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lcPaVxUG;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnheb7k2gqM+cHnj0uRkEgXHIyFH8tTrHQ7wgEhiF9s=;
	b=LmL21Z5Ti9XJh7HJcF5v4vBQV3aGRM0g9l8+9+pAnpSdvu8FrmQaxnUMrRchwUCHXnUA5f
	fP08rfrliW0lyFqWTxsbxltCsAXAMgFM4jDYcNz9WtOyfLsx9dNbvkGwjx21AymVdasGnq
	ebil/27wT48Hii3ozXso8HEWNZTJRz0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758210592; a=rsa-sha256;
	cv=pass;
	b=mWPdsQdT5SlmFZITr2IozoZNie+8tbXftjHUmIaZayILrkHybhTc4jIXesRqDphr+QRerJ
	vd5UETBmo7f2ABrpWaU/zAf5Ed/2zhVg2XXYQjnRpM02sqd/UT+JmWz+9g3ksNr+mj6CVL
	JTJOGIoK+ml0YPmPc2FUFCl7AmXUPsU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lcPaVxUG;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aZdLQvvg6e4SDyX52UqV/Yxn2oFU08/idRoT3kCw4vqlQIvHGEWiC3fadPbrgddF76j3YbeFeDym7ogo3lBVmtblX45Kx+h0KzMf1Jqh9GmshDAeMO8gsLa+ppzvdmVMHOY2rRL5jIzLWRqK4608cw5Y/rkwfhZE1DbxGgZwKBxRz+QAzx1I3aAzLNOfnf1GkrjpGx1iWeDeQLMbzrS9xxGkdcoaTiRijhvP5+OhWqRj0M4I7QCJD0w7GSaU0AtOXECY3mFqeX3fp8aIZrba6oh/P9gRtM7DmmbZe5IXccyftajkrm4wO/niIDJPL3PApZh/3mDDgaKJo98AOW5ftw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnheb7k2gqM+cHnj0uRkEgXHIyFH8tTrHQ7wgEhiF9s=;
 b=xu+3dxEgYk4YtVeacJyCAvtm9+mUSmYvNILiIoqLEoMl1423Hkid62+oxeC8M7fbNAa48n+yHH29Wdy9xZJjyfshuzNk5D2udhwxmwSW73OmKDNFqlYiIQr3d4JqAzW0W22Z1uTrVHLAPJ6Y7rN08ICMBatcOR+x9HUXd4Hphe251r6ZilbLatYEEaWZcICRV4VEYuPpNkLUSruT5z14V6KiJXD96xPRs3LUg/T1LnqMg5Lvat7d5fSgzmQ3zefz/Mi8KkuD+5RilbP4eW/Tugktws9OSoVhUohrrtvm7Ho6wXfefynz4KVoepxun5awAM9ym6bYW3pAiJnAnXxBzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnheb7k2gqM+cHnj0uRkEgXHIyFH8tTrHQ7wgEhiF9s=;
 b=lcPaVxUGktSNbbSa38MXywIZlUUP3boTjhTEhKaNXIkFIkFqFQWCrdUR44cBh1AydQfl8p+o0fDyomFEb5q52dSL+KaKsdMR6TSsk6MUtCdETN+1+Q9diehDX8sS9GbIhImYEG1c8QiUob453lwGvGOdWCIVgHMjeKMy03wptesVpunicut6WTfLwd+wQaqK/bjGu/gSIyAes6zBjuMiMbokTetKWW6ObirXpAw899m7IR8iSW5xXLdjEx0Ba1do2rnvItVJAdwrIUcg4izXaMAlm5nUVjVaEmrDDta0UeFmELC5/xFbqXxv8LzgiZbzBvpb5DWiLCCqr+xMwdJ4PA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6135.namprd12.prod.outlook.com (2603:10b6:8:ac::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.23; Thu, 18 Sep 2025 15:49:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 15:49:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
Date: Thu, 18 Sep 2025 11:49:45 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E25CD56A-2F37-45A3-8A38-190323ADB4DE@nvidia.com>
In-Reply-To: <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR16CA0045.namprd16.prod.outlook.com
 (2603:10b6:208:234::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6135:EE_
X-MS-Office365-Filtering-Correlation-Id: 891a07dd-d417-4866-6b7c-08ddf6cafeba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?czRoQ1VVVHRaUHVMbXNDRERWa2ZjdlJRMzhmR3luUTRZLy9WR1IvUFh0RmNZ?=
 =?utf-8?B?c0I4clJhMXhKaFZ6Y0xXc2pLU0FVOXBNV1EzWmFRWm5jZHlwUTd5eHI2SDJK?=
 =?utf-8?B?emNNekp4VEg5NXJuTHZNeStTSTZ6MmFNUDFZRjF0c2lZbklURzEzaXF6UktS?=
 =?utf-8?B?ekNZZDFHRkU0Qkk0VGwvSnZQQlY0aVJJOFlTOVFTQ0E4emFpU2NyWGwyN2NK?=
 =?utf-8?B?aElwSWhqcjExNmttRk5yeEloZmFXK2U2M0tGT2dQelpURmhaVDV1QXRkZXNO?=
 =?utf-8?B?MXZJZWJueVRTSzVKZEt1M3hnUHlrSWQwOUhEcHU2WWV1T2ZmRUkzam0vM2J1?=
 =?utf-8?B?VmtJV3pkdmVFdnJJWTZQNkQzV2lDYjRvL3NibHdBZmltcUR3Y2p3bVpGaUJF?=
 =?utf-8?B?dE82eTRJbkJ0THpkajVoWFhtOTZoQjI4MTBJalJsMldtOFZuRlVGc0xvcFRG?=
 =?utf-8?B?UU5oMW9OeFdjbXorSHMrNDJOcDBNUHIxdTV6WFhycnVZZ1hrVjZ2Q1Uwd2Ns?=
 =?utf-8?B?ZFM1RzRockVMYjAwc2RpQUpPUTdIeTFWdHFMbjJZclJaOFg0eVRwZWxRcFVx?=
 =?utf-8?B?cS9IZnRpZUxpTDh6d0NjNEN1OElZaUIxMFFnS1JFRjNjc0MvemQ2NTRiZ3VN?=
 =?utf-8?B?N3pRczNreWU5U1d0TEE3aXVFK0E2d0w2VGRlL1ZRNUdVaHJNd0JjL2VxcGJT?=
 =?utf-8?B?VThmYS9tRjNUUjZJdysrTzlrS3dWUmw2Tk5ZaTVjNmJvZjl6WmZIaEhwL2o1?=
 =?utf-8?B?dDF2SC9nK212Yk0vZ1UzTmRCOUJwK3cySG1EczhJVTRyenE3K0kxdTdSYVJ6?=
 =?utf-8?B?akJLRXliSFNZdmgxY0pHMjhSRFBPVjhMVk1JdE9VUS9GdnlJUDBjK1lrTjk1?=
 =?utf-8?B?VHNEcHhaeXREbkEreFltaW1HS3ZENEFQbmEwNmhFcGtzTlJBU0ZMTmVjZWhu?=
 =?utf-8?B?YnVPNUZzRVliUk00eHNRQmozOFcxYzJOY2g5aFF3dUthOVJZVTZ3OG1tUmxt?=
 =?utf-8?B?YW04UjNEUk1yWVROb25EU2lCUVE2ZmFNRUpaMlEycVVyUVo4L0kxa2p0WHls?=
 =?utf-8?B?YjRHQmVmM1lRVDZRS0QyeW8yVFBOSDI3SXRUZUtOWi9zL0JLUTJ6NGtLdDRo?=
 =?utf-8?B?YUxtUFNCbndFbTVZTHhvMkxEU1RwSlFQTXU2UHhWZ21wZmx5R1VHVXBINFY1?=
 =?utf-8?B?K1dhbGVuTHpPZG43RmxSOEJFMnBRQ1JRanFUOWdhcmttV0JJaFJjSWt1N3lG?=
 =?utf-8?B?UEppVTJQdUJnamRDSGQ2M0d4RHUxWU1wT2FyaUxJTWl5TmRaRVZHdVRlZXJn?=
 =?utf-8?B?cVpzYmo0NFI4SGVPZnU0djR4V0pCR3B6Z3JHVUp6dTJrcEpWSVZBQWNic2FE?=
 =?utf-8?B?OS9ROElZM1dGNHkzVWc0bUVOQW4vL1RzTEYyS2o0YjVqNUpxZzFwUVhkSTMy?=
 =?utf-8?B?eFE5SHBmVkVUeEs3QUdaTmVUcVh2YkJxdnR1Y0VCbWNWQWN6N2JvMS9nKzBq?=
 =?utf-8?B?dHgyQTI2bzd3OS9yOHNyVXJueHMrVlhaYVpQdlNDL1E5YllrTWcwYWhaZDJv?=
 =?utf-8?B?MFFuejBPa1UvSlpjaG5jN3ZJQjdXbkwra3ROdlV5akNFWEI1Yk5OVjZSYU01?=
 =?utf-8?B?TmFDWTdrdUlmMDRuck9sTjUvRzlodjcwb1BhdFR3OXNQajFkM0hRNlNXN2Yx?=
 =?utf-8?B?RmVQMFJLeTlzQTZrdFNCeUpWOENPMXNGaEZyTEJUb0JUazI0UXRsLzRYcEVO?=
 =?utf-8?B?cUxOZHRFSEVNbnB6aW1FcmsyZDBsRlZYZzdsZHJnSCtaaTRJVWtMc2FvQ1Vy?=
 =?utf-8?B?djJKTytoVjhUUEtBTUVkSzlrL1g5YWdRSlU0VjhVOGZJVE1BcThEdGlidTd6?=
 =?utf-8?B?V2UrWmNReUNuQWwzMVNLZjQwNkJFend4TUVzL0tJZkF2V3Q4a0VYTUM4OEU4?=
 =?utf-8?Q?PAK1zimdy10=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1hIbG1hM1VRVkYyZUJ0QitoWU9GWDVra0ZDLzdIUTVBZnVkTVkwTHVka2Yz?=
 =?utf-8?B?YWQ3M2ZoMzFvVHkrRFRKOTNMMXFwNzd2eFdNVE41TnIxZEt1aEkvRE5ibHNM?=
 =?utf-8?B?a0ZFMWZjUkRJbWtIWXluT0xXWWZqS3IzL3JvbVB1VTVRU0tGc24vWHA3d0o4?=
 =?utf-8?B?RXRSZldzcmF3T21xaU9tNmphNlZIaXF2bXI1TktIVEVEQ2pKK3Z2d1FHNzlF?=
 =?utf-8?B?QmxSblhsNVJKOCt0Y0tyYmN6elpuNDFLVDEzUzFNNG9sK2pjbTEzczhLM29o?=
 =?utf-8?B?WTJaUGhGcGdGTDZmMnpaMWt2N2h6Y2dmZ2JCdWpXV3FNdXFMMUpoRnlBbzJJ?=
 =?utf-8?B?RklrMjkxMlZtQThDcmZhTHg0T2dBc0plMGhIS1hzY0RWRmhYcjRHMEcveVRX?=
 =?utf-8?B?d0N4VDZlL2F4S2ZIN0FJZ3VYbDJLQ0hCV0V1R05lenBwbXlGMlN2TVZPMnhz?=
 =?utf-8?B?WjE3Ti85elJaMDl6LytmUkVNYUxiQVlIYnplZHhnSFB4cm9BeUtKMEd1enNn?=
 =?utf-8?B?ZXBvSWdGSjU3V1pmZzhHR2pYK2Q5bGo1U2g2aEdkNklMOFlReDZMSWtJVUp5?=
 =?utf-8?B?dFFmbjBVLzMvN0RKL2hUMU1HMTU2TFc5QzZoeVg1NjBVMkZuWEQ2WU1aZTVK?=
 =?utf-8?B?R0pRZlhScEtUSlBGY3FCUS8rbHBUR0ljeWw5MDFWVUFLUGhYdklxOWdDbDJs?=
 =?utf-8?B?NU1ZTnhlNE5iQVNuQWUxL3BXKzVzeGNHeG9hMERmazBCR05aK1FYVGJ5cWZS?=
 =?utf-8?B?Y1dJeUtoT1lXOXBmWUhwRW9qWWErVE1VeUJpUTBoZjIrdEtzWGpMY1Jwbjc5?=
 =?utf-8?B?ZDhCV3NZOEtidlh4b1h5YXZ5NHVPSllJYUs3N3R1RldjY3JxY0VtQ0NCU0lT?=
 =?utf-8?B?Tms5U3MxR1dvakRXM0R1c1ZiNmlMZGVFaFZZTUdjckFoam9LRWtkMjhadnpH?=
 =?utf-8?B?ZndxSWNJd0kwcXNSdmcxU3VOOCt6K1Y3dTFqckh6UWEwRVE3U2tyVTdlTWRI?=
 =?utf-8?B?TnRnT0l4MDM3T3E4WUw2M25hOFVwRUZsZk5acThWbGVSTmJMc0JFcjU2NkNJ?=
 =?utf-8?B?Rml6a1g4ZXpTWTdCRHh0aXd2cjQyc0xnWGVMYzNWbTBiMTZ1cWE5UHZJL1ZP?=
 =?utf-8?B?d1RIR24yYXBFdlp1WkR0cVRaUGRrSkRnczNFNUhIUFhTazNhL2tYT1dlY3dq?=
 =?utf-8?B?Z3RhVUthWW41RUJCR1QrcVNLK0tRYVFBOXBrSUo4ZlZjdHZTV25Wc0Nqb1Rh?=
 =?utf-8?B?UFBGNTBhTU9qcDBmT05xOWZjWk5nRXlnYUdESFZhQjRRdUVuNVdOclc5Z0w4?=
 =?utf-8?B?SnJ0L2x4YzQ3NFdVazlrNXpMZ2VZWjVJa2dGRkpVRmtGWmxKbmZZOXgzWTZm?=
 =?utf-8?B?V1hDd0FIVEdadW5DVC8rbG1NRTk1SnhYaGJuMUhHOUg4VUkxSUZOR0RHR2k5?=
 =?utf-8?B?dUNOaHNQelB5ZVpBVUYwYWtmZXdNNFdtcnhBWFFKeVc5akFCcUw2NEZYUExT?=
 =?utf-8?B?SkpLNWgwU3ZpRjVZVHg0OCtoeTBnOXhydzlYTDVET2E3a0NqOWNUaWkvaTk4?=
 =?utf-8?B?emJReHk0TDN3NHdmV2Z6WVM0VDlYRzZSY0xDT2FLQmVoNVJQRS8wUW9ha3hv?=
 =?utf-8?B?ZlArREZWNjdvaFdEWDR2WWtWaitWaGp1M1dteDVTemNjeXBNb3EwQkduTW0y?=
 =?utf-8?B?cGdWZXdZVzlrSWR0OTNEdW1keks4Nzc0OFJUdFUyK3BGQUhMdnZDMXRCU2FN?=
 =?utf-8?B?ODRvNW9tYmVwOU9SS0YvUnNKRk8rMzhNNTd2bEtiTm84a2RhSEdRQXJmRjdN?=
 =?utf-8?B?Vm5qN3QxL3VNZVZUbmk1TWVtV1lWL1VOamR1VHhMOHJLVUxyYU9zWHJKZno0?=
 =?utf-8?B?Zk13OUdBekU4b0E3ZFIyVTFQWXhvQzZpekd0L2gzTytiZVl1M1BxaDZzUjdV?=
 =?utf-8?B?RWdHMEwrYm10MHpMMXVKWHlKbFdlZzVaN1huY1diVUVzNFEydU5pUXFZTFJp?=
 =?utf-8?B?RDQwYllnTDdkV3hPbjhPTVVVLzJ5NmxUUmo2VmgweWtUNlU4U1cxZWprK2RZ?=
 =?utf-8?B?dEhYNDZhbnJLU2M1TEcxdnM1UEZmenVvT2I3TklUakpJcSs4NmRhYy9xT1hP?=
 =?utf-8?Q?nSCk3XWzdN0c6SC+L8kyMb3+F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 891a07dd-d417-4866-6b7c-08ddf6cafeba
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 15:49:47.5146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9cu5Ur7dxJdb+yeDV+6eR7GMFfZ2gRiI3+8CnUSG9Ws3ES10z0MoCNUxDnmUOjv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6135
X-Stat-Signature: piufdmi4sesr1tfai1n9x83a6t73co17
X-Rspam-User: 
X-Rspamd-Queue-Id: F0F8D140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758210591-974008
X-HE-Meta: U2FsdGVkX1+/NsXxp7DYmO3Av6NYpc3ieZRh2AI34A+WtW/ou15oW2FcEzb8UK49JihkrfxJemGW3FQcB3PFN8Z0dxtzbVKGtytCwTuB+O/uPpnbZuyYjIVT9jo9cPvN9Drv+XmQ6YaZm6dI4sB7XkEG+/ATAU3nWWPwF4l9CYSZVH2K0+Pg/WYLwb3nmny0A4cayQ2IL4R/XOIc/XmeYoX6k9KvBf9zZOs3fUrj149LKf0i3KXLDpVVHut7xBvsOhXWngUymwSgnsDsYzkZCc2kwTYi+Vk5EZUTr2C4czwHbIZgL9Z4EGWgPfmlve+D9FlPXivMytkaUhECSP2iuQAFIEYV/JSWrq7SUP5heRL0fXE8hxY52TotrxGowlGkyaQX3CGLWhddQNEQJLO8oMIYRaueqZ1WeH90It7T7L1zAmwCWZa0CXCtIE++2zDVezXx1Bdt2RRSXui7n8HPyKcZUnzfJjivxfkyA/oOzulb1NhWZFfAsHrLQCNSyrrwgGgwGdCfAeI7k02deKaKUaHwfuyb1CRD3YazUxP6vUUqfcZSHEIqjzjxJdDVtpLAR7pr5qOeYpcjjihZvVyQQ7JIIyGoQD5NKipnDR1syIhHhIQ3vsFTw/Em9n/of2/5pLxz00eCSHy7RW/LMJ/VLFLqM4zYLxMdUnAjoHuTWEUBstdnjQvZ/K+3cH3A1tKaUq1pSVIWTzvZIB+VpwsTWQte416Wwf3wxX3GoWvhIJ+U3fRyKJzOt7XzNgjOpkBxA+LR5VE5bv0oqsgrP87vRlKnVugSYiL/lqAi7v8iF71Ny1Rozan7dPnak3DBTafU9Js6Ha5XYlMyi9vGYQfMMeBSFaPvfmx12ydYRs4E1R14RpMQPYjlj8R0gy8iITtR0S1DSlz6r1/PJOvrXTxbgLz35R+nTxKgTcMBNpWLW5fKcLdlXtwNLzQ67VR2pjk5s/ecdo0zx/7WBfbkIvW
 kQo0kXoI
 QdrYDcKxyUa9A/M6FS+q48M5K78hEHuFCH5ZtbZpuXZwk6tlwBq44nx9zLUSGiycXzUXz3sRp5dMGuyGlSE5hGimAqUEcI6VOtClPNY5o2A1jK0JVN+TVfbaZlNqJxDrrIqiwQdQeRK2BpjuxFn3L6CXK6X0enZD/pJUtNRbXw9z4GQ77n//GKVaauwdkib3v2WbtFoZ7uTtf1lsWazch90jmNM9+aLH04QwDwCmXWp2/yrECt9BTUYOMI5qb5Y7z6AUvpJGbG84VWqKlCmJuFoeCeBWUWXnebWNrr/gK1q+qeCc0P3VTwxraX+JGqPD36rJwr5m15D6eee78VAbYDaMG8Wdwn1owg6wkEy25iVfHAxEniZxAJ0Qh9OR51DvErCaVWyeRtiIXiogUsncq+BUjCUYcfuLLIytv9iQziehKPGgjB0aMsqJIBhm6FjZOiTH1u5m+Eq80rOR3QGUpu/Vo5XiKMLo0BNgIuYMi9pHeTojoXkEhEhWuvdwDWBW4C+XiThAd2hM/1Z75EcKRLQwL34NHkMlF8FxrUcQT6dEIEZMamcQHPP7jHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Sep 2025, at 9:19, Kefeng Wang wrote:

> The alloc_contig_pages() spends a lot of time in pfn_range_valid_contig()=
,
> we could check whether the page in this pfn range could be allocated
> before alloc_contig_range(), if the page can't be migrated, no further
> action is required, and also skip some unnecessary iterations for
> compound pages such as THP and non-compound high order buddy, which
> save times a lot too. The check is racy, but the only danger is skipping
> too much.
>
> A simple test on machine with 116G free memory, allocate 120 * 1G
> HugeTLB folios(107 successfully returned),
>
>   time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepag=
es
>
> Before: 0m2.124s
> After:  0m0.602s
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/page_alloc.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 478beaf95f84..5b7d705e9710 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7012,6 +7012,7 @@ static bool pfn_range_valid_contig(struct zone *z, =
unsigned long start_pfn,
>  {
>  	unsigned long i, end_pfn =3D start_pfn + nr_pages;
>  	struct page *page;
> +	struct folio *folio;
>
>  	for (i =3D start_pfn; i < end_pfn; i++) {
>  		page =3D pfn_to_online_page(i);
> @@ -7021,11 +7022,26 @@ static bool pfn_range_valid_contig(struct zone *z=
, unsigned long start_pfn,
>  		if (page_zone(page) !=3D z)
>  			return false;
>
> -		if (PageReserved(page))
> +		folio =3D page_folio(page);
> +		if (folio_test_reserved(folio))
>  			return false;
>
> -		if (PageHuge(page))
> +		if (folio_test_hugetlb(folio))
>  			return false;
> +
> +		/* The following type of folios aren't migrated */

s/aren=E2=80=99t/cannot be/

> +		if (folio_test_pgtable(folio) | folio_test_stack(folio))
> +			return false;

Maybe worth explicitly stating these two types of pages in the commit log.

> +
> +		/*
> +		 * For compound pages such as THP and non-compound high
> +		 * order buddy pages, save potentially a lot of iterations
> +		 * if we can skip them at once.
> +		 */
> +		if (PageCompound(page))
> +			i +=3D (1UL << compound_order(page)) - 1;

Just a note here, if page is tail, this just move i to the next page
instead of next folio.

> +		else if (PageBuddy(page))
> +			i +=3D (1UL << buddy_order(page)) - 1;
>  	}
>  	return true;
>  }
> --=20
> 2.27.0

Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

