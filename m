Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8042C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 01:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6429B6B009D; Mon,  6 Jul 2026 21:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3686B009E; Mon,  6 Jul 2026 21:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE6C6B009F; Mon,  6 Jul 2026 21:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5B86B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:45:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EF3F8CF0D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:45:58 +0000 (UTC)
X-FDA: 84960289596.01.73FD509
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013067.outbound.protection.outlook.com [40.93.196.67])
	by imf13.hostedemail.com (Postfix) with ESMTP id CBCA820002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:45:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="E3Fk/Why";
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783388755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhYm6gv043BQhi2IBFzGMm+DUDpyW7aqwh6RC/dp9DA=;
	b=2knjIchJF6JkJbDjSFk43P6rUBhbnR+J6LviZnBSmJ/zLof4EX135MaGAbDyimL8OeN+UF
	TXGkuoZWwX7ds/dIA4o1pxyNmzJRYwOiX6TMaWmWr3Qr/z1/OE8gFp1GaHviuop9KEavBD
	K9hkrHh+TLWhNx5Yo8uD58rXZ3M2OTU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783388755;
	b=ydQIbwAoBRurg3Xs+gx01miJmbuu6M5E5vAoGlsRZedVfYoBBK4xgDbJB7yHO+6WTGgzqR
	0SUvR/H4tgT0fitLBYF93s/fWKxL27kUXBcK5fdMyQYnjpxiwZLXfaQtAl/6pnPkWJqDwM
	qHIhXDDvI/YwOSpNIG8mQIBOIXBlkFU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="E3Fk/Why";
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQG8Vp05C4fgSmv2ZH3zdXixAW5Xp3pCcYYS6sGkJxZ+RYHo2X3oDyvUfraFVtKHoZwnsVV8882foago7EEjWkDpQuSG+pk+gQ3qU4A8E8OUWw1YcNnu0TrGHfoNPmUDRa81Cy5ieAyKbo2J7r459Dr35UbhxVe+xFYpDiQzyZRmNQWxtmE9nNEbYNYE596ooktVBWreh+UPwvGiL6GIqyJPuxLeLHt3L7tV6PRG8CeIufSZA7G7L1khWu+PF+rprfiAsJnEf3EObp+muQIFXIGumy95Hyo8gVLLx//iMwbl5Rbn+6CeFZkXNA3hhi6roJOJfI6C4mXua0+Rwnxw7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhYm6gv043BQhi2IBFzGMm+DUDpyW7aqwh6RC/dp9DA=;
 b=j9N8IszR28bIusMt3pdckA7wDwAoJ+6qknoKJ+ZBcjZCATVoUdHFxKrUQc8eWch+Vme9X8HxN7E26ZLmWEazRns9SbDKutveKOoF47domgNk2ECY6VhxpPfeGkkQnkOPs9/dc/vaRTNS8gpC/U4Pu3RLe0ZZkHZkwzOiYvgVUiwb5XNAKWT2F00jjYW+UzkQVmBRUbxhaUfowIkcsNvioM61bZyNBsF7UOcR3gg3x8drCrgfVf+MNGcfqc4kxTK2cv03XiS991jtyhy9wMw4RYds2K9v7TcZV/HTgjdcYmbLHRChIf/3ZL1oxlyW2Lb48GM0NyZp4lmNA1FcmdogGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhYm6gv043BQhi2IBFzGMm+DUDpyW7aqwh6RC/dp9DA=;
 b=E3Fk/WhyM0Mor/lzeowE9dokSTMGr5zjX/rmHeR8psuw87AS+pv9Pi+IuHkWoQCqiFKMgEb8/cjH9gtwCLcXYPuA/1bUMnuZp1heaSMxibDnDWrIkLEpBoF8/MDJ1/hypx01O3XUPBGIIbnrMC8T8C3M734bgWo/s2fDj5PgNqUm/znm5njPAsb2m0wR6Ny3RJdgtXQ0HLWWwb6qr3yEc/WUiQEeUN8mK8ScCGX3YjxBdLgnFaCGl2eIHiL65edna+kQCaHtVp1e7aiDRRVboEZHg422VbGzKdPgnmdRhGm/b76Fr/HHU6m9gXEjYveeX68/9w43ZAB7qhwo3Uy/xQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7274.namprd12.prod.outlook.com (2603:10b6:806:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 01:45:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 01:45:50 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 06 Jul 2026 21:45:12 -0400
Message-Id: <DJRYJCAKQVT8.1U855ME5LF6EF@nvidia.com>
Subject: Re: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Brost"
 <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, <linux-mm@kvack.org>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Kefeng Wang"
 <wangkefeng.wang@huawei.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
 <20260706110113.920498961e5b29b212c7a199@linux-foundation.org>
In-Reply-To: <20260706110113.920498961e5b29b212c7a199@linux-foundation.org>
X-ClientProxiedBy: MN2PR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:208:23d::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: f7ae19dd-db64-4a24-0cde-08dedbc97933
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|13003099007|22082099003|18002099003|56012099006|4143699003|11063799006|5023799004|6133799003;
X-Microsoft-Antispam-Message-Info:
	hpGn3aMuFPwQKAIRiaFlGuFpuBDDkuDesKvfxPTnvvHiXNEo1SmgDU4BRpeGht+TjQC8S522P3M7Q3+z7dYX9DpnWmRA8DwagvpwbGMOhGOvyJTPQ9P75nfTenfPxiyZVZUCV9Mi2pplYUgz40uzzBLdAa5NNfBYcg1BYHZWElUVShFDfTaoxE/NGlrMJH/sP7OeY18mtYZDg0ZIjY6sQJDgLeNxjemTvWg+IXswsUFIjoXbPaTYyoIh5afC0qA8I6nqAcYBZrt4FWPJBpPlHiPtAMrWLoMJ1WAiYY2fdts2H5bqsppP0Rmbc6ROV5CrnhJ1gykC4TN5fr0u45fD/EvASb4mau9enRXJA8E7VlXScTxif9Uf+56BdbyGQ5pMSA7zRrg9EKtq6ZO/1bJEG1233xXFToovfbb+YfbniMbWpZP5KbEZG028PXaMITDXiweDYXCiJZ6kkS6yXMpqfkdNRBohVAMwd17Ak3cxb/+TJ2FA3pdyF8gicoxmhBbGSsWw6g+cBLpiJy4fBbAVM+PRSlmH95W/FsQN8l71yOOgDhPmvZaBhQQuVR8gI5KxW04kilIDrCmWuW7nN4N+IWyvDCeBm+wnbNH3IhgdGfz+yaRq0PP88CwlLvrNOWjeTTmlKdhusKbeptaawpNfye04z+9gChG3lTfZymNmpvM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(13003099007)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(5023799004)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEwwMkFwbGRXQUh3aFpTMWpyV0ZOOTZQaWhUeUpGTk5KdXIwZ2FoYWZxR0xP?=
 =?utf-8?B?WFFDaWZBL3N0SkVtUUZrNk5EYzg2RndVbFhIOS9TTTl0S01KU0tCeUF3dk5j?=
 =?utf-8?B?TlRDRDV3Q3Npalp5RHN3YVloa3FtRnhIZXBwaHB3UUl4TmlFMk9FRHZYU1Zn?=
 =?utf-8?B?ZU5pLzJJWW14OFJtMkdqK0ZsV203QmVKaGYwaUxLQTdqL3FHWjE3bHNaZHc1?=
 =?utf-8?B?a293VVVwNU1RYzk1dEVUTXRMN212WHJuYlNESWJqS1lQUStqUGdCeHJRY0pk?=
 =?utf-8?B?Q3NBMDJENDBOWGI0eVhWNEora2NpR20zUGV3Y2RkbzhlczdqUE10bjRwQytX?=
 =?utf-8?B?M2drMmlkSTkvYTZxUi91ODRSWEVkbHhTMGlza1FRM3BOR2lYTXlUMnVYYStJ?=
 =?utf-8?B?dkZUL2ZnUTE1Rk1IcForRVp5T2RNaEtiZE54Ky9yUU1BRldZSkhESUIyY0Zx?=
 =?utf-8?B?ZWJ0c2xnTmRoZFEvWlQ4WWFpaTJ5VWFaeFpuTGpIdmpGTjBZV1dvZ05VaDBE?=
 =?utf-8?B?Q3FNZU44NSsrRUlOMFVhS1BLQ2l3blhRYXhzdUdmMVFDUFMzV01KV3pmdlVa?=
 =?utf-8?B?dkJNZEhDQWlHQk1YOFFuL0tUWW92ajZnNWpjU3hyWE1tNG5tTGFLRDNmb1Iw?=
 =?utf-8?B?bmZtbStJWlFCQ0dVMTdiTi8zdkJuVWdGVk1BSzlDcHJpVXVUWVVTTnVxNmto?=
 =?utf-8?B?OGsxNUtrWkZPaWI1V1FaQmtEcEZaY3JaUHgzUENTaTVneElsOXlMSFBqakdo?=
 =?utf-8?B?Q3Q0bGMwWUtIUXJnRmMvaHJadXhZYVRBYXlZb3UxVnUwY002OVhvQ3d1cVFt?=
 =?utf-8?B?SHFiUnMwTHNvMkNKUXhXcysrakVKQ2N2dy92dFBaOTBUd2ZrK0hlQmVmWVlu?=
 =?utf-8?B?dmYrNlFEZHhZUGFyT2FiK0dLZERSWHFwcEFhVWVFY29RT0FWNGFCTUVoNWg3?=
 =?utf-8?B?MEM2dVBwSnRsV09zRm5lNURaVmhmQUcyOENxUWQ4amdLOTRXazdPbDRKN09z?=
 =?utf-8?B?eHpyYUJ3NVVaVkhpUmErZkZDNzBNaFh0MG9ITXpUZVNaR3B2MUV3TkpLZG8x?=
 =?utf-8?B?VlFVcTlZc3VDNTFzQmtETnl4cW5wcDltelVCWFVUazlGcU1XT2Rpc1hBUjlC?=
 =?utf-8?B?T2FwUmpBa0VPSnlDUjYvR3FmZDBFL1pGSmo0TTFkK2daUkZYN2xvdUhYd3g0?=
 =?utf-8?B?UXBaRjdTM2NaV28xN3h1emI1Qno0Z2FpRW1hUzdwVnpHVy85Z0lPWTVVandu?=
 =?utf-8?B?Q1U1NnNrQnRlbHJoZFB1QU4wRWcweFdjUU4rZHJWOG1PYU1VNnBybGxBTTVE?=
 =?utf-8?B?am9ORDI2a1FmeWZQTVYzSXVWRUEzWWdoS21WT2FWWUhmSlJwa2hMSGt4SktY?=
 =?utf-8?B?bE1wRDlCZnMrT01IZXB0Y3FqVC8yc2hDM0h1NXlUWWphM2tnWEJKSU56cEhU?=
 =?utf-8?B?ZDJKOHMvVUNEQTFTZ1REYzU1NThCSzg4RHliNExndUdiSUdVem05UkFEdjVT?=
 =?utf-8?B?KzZTMnFDb0tCajZBQXhkdkxLZGF3dFVmeVZhRVR6ck1nRytEVmpsMUJrWnZH?=
 =?utf-8?B?a0o0Q0loYkQyVVA3YVRQaGg3emFEUEh2U0JTUFlLR0tETTZGa1J1RnU1ZUlI?=
 =?utf-8?B?ZUI4U2FyYzZFMVBNRFB5cGNzU01FNTJxcU1TZDIzSEZkVUFUZFQ3RU9sdUZC?=
 =?utf-8?B?ZDlsNlNnZHhqNWRsYVdpVHFKaURVTzNtMUl2bG12Q2F6d1Vpc2xYY3U5VEpL?=
 =?utf-8?B?TzVVMWozMStNMUdCWUVjNXZ2RlZ4eGtxdkNzcytZMmRCWm9GL0hGdzRKTzd4?=
 =?utf-8?B?ZHpBSUZVcThRYWJvdzFDM0tlenJMTWxZbHdnMDhQT3Z6SjdWbHFOK3JhSlJO?=
 =?utf-8?B?UGtiVnRlRm00RlVGOGRKaStnN2c0TytxcWh6cHhhWVdJWGZQSjNmUHcyK1NI?=
 =?utf-8?B?ZnJZR0ZwRzA0TWJyVmhCd3Yyd0xlaFFPcnVuc1d1dTE0YVVpTmd1RExkL0xy?=
 =?utf-8?B?Sk04OHQ4cEpFY2xNSmwwQm80WWJlaXE1YzJscVRQdUQyeDl3RHNtazN5MTMw?=
 =?utf-8?B?eUMwOE9xSTc4ckZ4S24wZ1ZGNCtPZEZFbGZGbm5DTTQ2QzN1USs5NytFdGYx?=
 =?utf-8?B?MEVYN1JvNjFhS0F3OVMwc2ZWcnNTWDJEbndIZlVBczdSaGRwUFMwWUxUUHNK?=
 =?utf-8?B?NmNvVlhEb3FTbks2TVIrRFRUazRpRFpzZDliK1AreU84VlVQNkFmMzY4NERX?=
 =?utf-8?B?eWN5clUxU0h6b2JCemxmdythczY4THFlamJWZE1CVDlCb3pnOWlkWHJYOU15?=
 =?utf-8?Q?If7izVNo4RY+CkiF8E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ae19dd-db64-4a24-0cde-08dedbc97933
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 01:45:50.3017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lt6pTjZXPbRJ1wBCZlH1Og/6ImH1HOzcxEQgssLJrVuZAbyjMEQAg3xC2ObNcaJs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7274
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CBCA820002
X-Stat-Signature: nat5u4fru3puuj43qz6r1p1k3m8y86rb
X-HE-Tag: 1783388755-655959
X-HE-Meta: U2FsdGVkX1+eUK3gi8NC0c2LO/w9oPQnliyiI2VRumTJ9QwpCNWbz8ezEC8XKm/uh90hI1k1cWusYy4q+RTrVar40UL12b/Iy9nl96ecQoba8KPiP9uDg1lwNOPCblCetP0Qx/rhXg9y8rwWtLNQ+JsKQDBa9ElCTf/2mAHhZrwpdcJJYljN3akO4iO9iPNleBmE9rPTy/FdRY/rU6V6Gp4uu/syASkd0ZqOehN8TMwvObm6p/+AiYNnP86dxGTsNF7LfK3QkPNEv6T1fK9la+5E5xrtC7KHPcRUq9ePT6CjF9iRpwRKi11QFjcxcDt1bv9eicU0zRsRDj1PCP7FUxVg368mw0V8MVJjCmRagYxsNNAgNq0oNn78BObBElnUof8yQpitt+Blk0P22pDi+XxmS5tJHptCMyfx2b0ojWmG0iuO3o1nELG0Xb2SPClCPNuWnSKKTQxrGvd6v3xF1cmkhSbKhAiVCwKcfarESKzLlIddL/O0x6CfCz8ivWmxmC1rplpO1HKMO6xRjjlwe2LCDDAdDxyGWP+EazYaTaiEXHdTJ3EGReJpec/mIo4dUepAl1ODZgFkj6P3oNN9kGjZJ87DtSIH/rUR4JIpnt/Wyf78Kx5gXVn9KtNnO0lNDvhYbokNncKHqN7FXZjgoULcO6BeULuJqKVXxByfgu7Ys/FMR20cojUq7i6U0oFYtUuhoyrUfW3Hf9g1SO3nEZxZ/eVGlj2FbDvZ6YpT9dOz8bVeLbxvWIg+Cc0hIOMd4lsUlPsHXv397mV3KvE4kxhvdyTcGClCON55dUa8FAe2eUOXnX2BY2f4/0rDeU1B34Cav16bAHZHXqIH4fkogSzlchdc7yCWLXPiVX3zDbAk5pphUkw72RmSDblJC1A/zzC7GvNt1rxIgPls63mV5CzFuLqoCGOesY1adS2v9mka/HDq7Lh/hFVCkXnq9bgLfkiC5aT0xeVFz4Kx53D
 Ah6s6UPu
 GpuolxF2jn6pFDB/B9rDJc+mvCeT5BlEdm4jucGhCUW4eRBGRyWDQGgnpTtD8ghx4pz854C2T/Hcn+1mlIqiSvj4GRo4hrp3MIjzIO2bGYnHciTqqtNKaJ83uOd4146uC+A+UHAnLwISHRadc2dZ7Bb9cbTdZO5QoBt0CD4SpVrNfWlWNGd9EHPDPAOyMJYfGlRrIxasFWuTxsV8mp7tNlcdzANufGSkofA1OXEwy4bjUqGUUQH2cGQCXEiD1ZSn31bfAq53qKXayZ+jDrDLqBErGXAudtr3Idudu692HXpukcEp9/+86H6lr+iJT/ZTtBu60qS8sy0+KaZa2vHaTGHun/J1+7U/GlC7dwDSsfahM3Jz1lzdwGN+18pkcJksLZ2ZYRy5i98O80I1F6XlZd8fcF4Tz7cahj7GEafhnecn/PDe4ToT59XpVkRtLh+SpKAKLga/2vAFq3RHRbkFo7UOIzXYAgTXOK3Vwga9XD8uGIsCdplpRefYfE7r9NHh76yzsq+wj8HadEDRpmu0zZRLC0XodQNIM6ULMHfPVHmaPhXWfNugxqU5DkXRqp17WCI9Fpm+GzoXv0DuX4fRW/Ug9AMcIyi0zUIvSu+0+Q5271g/e0wgKwQqJ8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 6, 2026 at 2:01 PM EDT, Andrew Morton wrote:
> On Mon, 6 Jul 2026 19:19:58 +0800 Kefeng Wang <wangkefeng.wang@huawei.com=
> wrote:
>
>> pte_pfn() and pte_dirty() have undefined behaviour when called on a
>> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
>> invoked on non-present entries (e.g., swap PTEs), leading to potential
>> crashes from pte_pfn() or incorrect dirty folio accounting from
>> pte_dirty(). Fix both by guarding with pte_present() checks.
>>
>> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
>> Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page(=
)")
>
> Should we cc:stable?
>
> Sashiko might have found a pre-existing issue:
> 	https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.wang@=
huawei.com

I looked into the issue and came up with a fix below. It looks ugly, so
feel free to make a better one out of it.

From 7fa06512638a0febb79a00dba63f12818a85788b Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 6 Jul 2026 21:25:29 -0400
Subject: [PATCH] mm/migrate_device: avoid scanning/collecting PFNs within a
 PMD

migrate_vma_collect_pmd() can drop pte lock to split a large folio and
restart. But the code does not handle restart properly and can cause
collecting inconsistent PFNs and overflowing migrate->dst and migrate->src
arrays. Fix it by:
1. avoiding migrate_vma_collect_huge_pmd() if collection is in progress,
2. skipping the rest of the range if pmd no longer points to a pte page.

Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone d=
evice pages")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.=
wang@huawei.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/migrate_device.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 052167f9ad547..d86b3989d0c59 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -257,7 +257,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	pte_t *ptep;
=20
 again:
-	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
+	/*
+	 * Only check pmd when addr is at start, namely no pte is scanned or
+	 * collected, to avoid collecting inconsistent PFNs.
+	 */
+	if (addr =3D=3D start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp))) =
{
 		int ret =3D migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_f=
olio);
=20
 		if (ret =3D=3D -EAGAIN)
@@ -267,8 +271,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	}
=20
 	ptep =3D pte_offset_map_lock(mm, pmdp, start, &ptl);
-	if (!ptep)
+	if (!ptep) {
+		/*
+		 * Skip the rest if pmd becomes huge or cleared. Flush if any
+		 * pte is modified
+		 */
+		if (addr !=3D start) {
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, end);
+			return migrate_vma_collect_skip(addr, end, walk);
+		}
 		goto again;
+	}
 	lazy_mmu_mode_enable();
 	ptep +=3D (addr - start) / PAGE_SIZE;
=20
--=20
2.53.0



--=20
Best Regards,
Yan, Zi


