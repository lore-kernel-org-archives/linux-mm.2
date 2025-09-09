Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AE54CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E255E8E0011; Tue,  9 Sep 2025 11:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6158E0003; Tue,  9 Sep 2025 11:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D7A8E0011; Tue,  9 Sep 2025 11:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2FBE8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:50:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B00D1A0660
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:50:54 +0000 (UTC)
X-FDA: 83870150028.25.C9BB12E
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9370C80003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:50:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C9nxcqyh;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 40.107.243.77 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757433051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNpWfkwqjjtRlt61YpQWpZJLcy5IyvoDowLEv3mBNIQ=;
	b=waeHQ6nCEpfDd6sblsBCgx6lg+4Gqrfw1SQiMTBYxmrYW02i0l78U0/42Uwvm2DzwPXzZQ
	EWARoQpkk5lebNwqokss0REtVXuWgTrUegIDTBtkZ00Th0jK/L0p7Zi9u83PrF8PCRP+gp
	qn0JTmrdyV1aCgVGWFM1VRchoOu8hkY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C9nxcqyh;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 40.107.243.77 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757433051; a=rsa-sha256;
	cv=pass;
	b=lZITqOHYfzYt3xw1ZMsiJcTNyDpmtxILw8EcCzxgoUEWGo7V1PGrRPp/TMsmgNUiR2O9Qt
	q47dh3OGpPCCdlp0hE95NpGmsjBbzjKUQazdIOyN4p2SNel2iRFNgSA50y5QO9B40kLKUO
	MwClAWKP6Vg8tCgHOp562FCHUYTQPRg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gqm5QPrXsWpgNwrYH3skTOZtvQpwyg640dSoJHDLD4R18wluC1yaazK7fec06BI/0Lotbop6qP+3WzWhtvqIvPfdIxOzjs/eGa+lhGH9QaOw8DBqOKvcV066nfCaqAwGqoy6fvszFXeGWpXp9OJ/FBCZHgPZZ7eE5oj1ioIomvwIZCcpejpwBX6KS8I5PSJHaeZhpiubqgNv+0EUE3VuVhKFw/ZuVjiR/D2H/GB0tcjs8mPMaTNVmDzUkBkGQlSSax3WvDsuZ05D++ohu4Fa9UeVfSlyTdUOrYqqEO/e79h1hC1hFi15aPAx0+jD9hUZEx/1Awl6XLnuamGP3497wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNpWfkwqjjtRlt61YpQWpZJLcy5IyvoDowLEv3mBNIQ=;
 b=LzcpON8eZyQdL97TqlBBpAYMKVF7anZFsP9KQqKI3lzfdx2R2/c1gDNLUTwAuv2GzM4yhENdlNGf4ftQrGd36mLTv+Wu9MXWiz3V/mX/l3t41MmsGXPJXPquauwyw1QAtTz8DcrWR1NFmRu/qz9OBHQG99EfsnrsTdUCA8SIbrzGz+MWVNZCQsI6yaI8xHtCJLoMuhhdIPdchMC5KHZv8t3cngTMcFMD6RQKOf1RU5oWfMXEiu3HxdZoL04jqeBkROPPRAkZaCg3UxZYJzbhQHeRw9N9+ffHC07AsDZPBn6f98g6/DXqY4UT2zUjRZ70Pv2HmbynEC9EV1GHGyZPuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNpWfkwqjjtRlt61YpQWpZJLcy5IyvoDowLEv3mBNIQ=;
 b=C9nxcqyhZpD7XaHhdnXjWWjyhsPEPo584PNObF0IWgYw8ywHmaJgrj9JT18uR+Je1DGNdKAFxWvWLQnP74EykXpy7p+0EpvIsrhXX54BlD2A6P1ryyLCQgrOSakF3aWASNKLsywSmyJrqcTpF8sSh0P6zd2AUE6iIt1hegAJSa+wSrHYfsEvwQ8Ku2nz54Is6Da3dquBJ1SZxsTWoCpB09aSULsiRicYPGbz/oOPjWKrupQe4mJ7Z3RFSELxNKjVXQg+/jDDTkbGbdpBIat47R+DIeR9hHZsckkoG7tzu1H/ROVqi42EmVh+RAhaG7G3p4t7VQae/sC9/T57Bf/6Uw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB5746.namprd12.prod.outlook.com (2603:10b6:8:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 15:50:46 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 15:50:46 +0000
Date: Tue, 9 Sep 2025 12:50:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Chris Li <chrisl@kernel.org>, Jason Miu <jasonmiu@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/4] kho: introduce the KHO array
Message-ID: <20250909155044.GN789684@nvidia.com>
References: <20250909144426.33274-1-pratyush@kernel.org>
 <20250909144426.33274-2-pratyush@kernel.org>
 <20250909152814.GL789684@nvidia.com>
 <mafs0ldmnk522.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0ldmnk522.fsf@kernel.org>
X-ClientProxiedBy: YT4PR01CA0451.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::17) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB5746:EE_
X-MS-Office365-Filtering-Correlation-Id: ba4e8c0d-3dce-46f9-a4db-08ddefb8a3d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q1ChjAwzF2bMXsFpLjDzomA/dWTpvvi9lLliwvvghsfPPJxjaht/2aO3ZJUz?=
 =?us-ascii?Q?pnLvzuufG7+3td6f6hnDPw9zLz3bBYrn2GgIN+ek6clDDBKeElZL+rSqLqW/?=
 =?us-ascii?Q?Ep99mwYpMFt4cv4cNh8xuMQekVKj2gY8Oo2Sd8VNnU92YRmWBWgGS9wOSbbu?=
 =?us-ascii?Q?Opcn+gxPehW8G3S4i1Xw3Xle5SmeTsSzzlrxwvLo72NkvBVsSDlOy6qlB9l3?=
 =?us-ascii?Q?zWoE3ntuCzFCWEy7yXgWHP87GLAEAxu7cBi+xsLn38GguXdVmJ3VjQq8m5I6?=
 =?us-ascii?Q?nWcMcJyhd6Wf6dQSkrWebA0hVaLhSa8JHlHRL/7jqlRK4jsI/nA83gRd071Z?=
 =?us-ascii?Q?zS0nitMpGD0OLUE/Et5xsEhe6DKZjwEcCnZ3cNgMUfO9yjJ1JIJE8fomUX9v?=
 =?us-ascii?Q?iwT5v9/JmXToOeNlKo2z7OM83gWEJQw5FQ8ZFXs9JWvHCIc+DvlLgwDehxj5?=
 =?us-ascii?Q?R/jaHw6KMe3vSz/KNl+0qzhmjOc+BexBCq3rwq9Omz2KM9EZ8bKKPL01eseH?=
 =?us-ascii?Q?lvplPKOO5G4KuUzCI0xuJ9zGbK7BBPEik+2BgZt27t5FO6A9HR6VGg8fUs0X?=
 =?us-ascii?Q?sDCcAWN4en8rnqkahf7hWt4K2ZkM0ZV//y8yp/ae3z3V1JrypQzoob/Wfu6a?=
 =?us-ascii?Q?sdgT6aj53CMhNPv39XKw6LejQAsdnupqBP5ojSLVIphEexzPmH+9OcxJksfR?=
 =?us-ascii?Q?PMyidsLW7CI3AFnqp4nE9eZfkVO1dHf9EE9zVsTGQYpu7zcXqFDn8rPLaRui?=
 =?us-ascii?Q?Cm+ImgIBW0LUdPLMNnmnMGhEYpKx/1AHRkX0IiqNZyDkOcRZU4T08NT/vqvT?=
 =?us-ascii?Q?SPweT5Z22reVfoyXGLU2beowXvpuV+ubq67b3F195KYU6afTkGocZJbukOEn?=
 =?us-ascii?Q?hqi5AQdolHCsQ/IuCFfM/qfHpLHfbYTx5u657c66s7h30s5UpFX6TTNXZRS8?=
 =?us-ascii?Q?n51ac4Mc+3IjvoFq3IZi2PHd2TIICYjgL+U1VrgFzbGBTcxrtdp0Zy3W7mZW?=
 =?us-ascii?Q?wzl4K7+KtI0QSBeJODQHTlspSWcUgRQHAygWRD1EHx1cvnsaRxvfkAMP9UED?=
 =?us-ascii?Q?z5+XMoX8788x9Dn1+BdPzgt6NlWI73vgkxq7QKnhVoGtHBdjizS3ZTZdaz6O?=
 =?us-ascii?Q?LKeUR2f+k8MF6wYh+4YHYnxb9k1HDgBPiPKb2koX6sMCRkcHFfmlrr4daDbZ?=
 =?us-ascii?Q?dTMiMi1V+VKN5S2ew/CH2s2oZ5/Ka0ci5YOOkWt9j53LeJhOCY8AHwhRYee6?=
 =?us-ascii?Q?ZFeZVX4KKNl1oZxRUiZR230cIheOjmRGSaz7OjB8JB34hUFUaB/ShJHWt4xs?=
 =?us-ascii?Q?7BjIm4mA+sDE6yfByuHPkufcqhrLZrknCnu8MKjKjWpBWmhUENkbzzfhthfv?=
 =?us-ascii?Q?Bnhb2Yc/Tq8qBgsQSftSNI9lxEWMECP1b0r6JLtEgsQgVdjiB3a+RoZZgeg0?=
 =?us-ascii?Q?2mdqgYCK0Ak=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XBmxCuzQ/v0LB0pyJeaGVCLSGJgVGRe2pfvzNif9JBkow9LQIPbsaK07wGvZ?=
 =?us-ascii?Q?pHsFmDn1CjpgxjkHUxCrWLiDQ1YuUms0xqMKXrG4RP+w0M2CnL4aUiVeR5zI?=
 =?us-ascii?Q?5TWRKOj8wYj5FOoObSIvPSaTIUyuwqJ1HdR5a+gYNF4X4ImTg46ZiC1uAj26?=
 =?us-ascii?Q?UlCd4AtI+tcMQI3aaImZVDk1NRdQepcT/FRRwzpNMHIXfKdBkfu/p45c7EtI?=
 =?us-ascii?Q?6aKiwDfXKuj/1RUBLtdnBEAGFTgk6Ux8wjHQ4TaiPv+O4KdNUWX0U8rooLOy?=
 =?us-ascii?Q?oCYsI7d8bBvbVnRvJXM6iSZx+MogZTy0Mdo3szaX3ykSWCSDTl9PQ83IBCU/?=
 =?us-ascii?Q?datXGkFvWpn0oIRO2PNEONcM54u0kXJuo+lj28dkTjLN1WgHqOku8L0PZgSJ?=
 =?us-ascii?Q?SjI5kDF2QNsDaqkBbGckGBYhIUCEi3mDlReFBzi77DKv03SEDjj61RX3A1eS?=
 =?us-ascii?Q?45JPavfqZWoJTpmK2pbi5LduIbsXW5LZG1ajyaENdiXr1u+xRTwsYRncMAu7?=
 =?us-ascii?Q?yJeDs/WVwsQO2GY2cuvfn+84BrNW+6ukwQ7a5yNUnQ8rfgBpwMULYViqhRjS?=
 =?us-ascii?Q?SCwL37XIfpCgMHqE7qWX2BPFOkUN/SRmBVfJjY4psb0u0lJJQ0XRUUjgbkRJ?=
 =?us-ascii?Q?uT86RHwqNt34mHzh7N7DWGPf/0kMyk5BO6ALlB+MNkieuPPd02Cj3MNzzdLE?=
 =?us-ascii?Q?AAajval6HUOigysc8qM/CCyh/gpxUxCpSYCzwfWegn1kCeoWc6jMX0rLVMSO?=
 =?us-ascii?Q?7pZtzwCzwa1P2RUVdrJfCRwkcnI8nAu3QBRA775ILWb13MmzOYEPw8bEcnBb?=
 =?us-ascii?Q?gLbj0DFFeXN//FZOIyEOidfJgDELfO8zj62ciulfhbd70HIvxo0rxXRXuOGj?=
 =?us-ascii?Q?mjYhWCneCja/jtTczufCiPKbHQY+rhDVzA2KSW59QaqSwKPJaFcARZYmuJZ9?=
 =?us-ascii?Q?CaOU9d0qhziCg0i8n6xnwGhRN0B6McY074G4ISbcDp+hBn+yWU9ikmfk/10l?=
 =?us-ascii?Q?XE39dP2I5E3H2QSf2eS5EWnKdwFI7QExvwVPF2hHAoZ2ZhfY3BIJc8tIueVf?=
 =?us-ascii?Q?sHX2SJZ8Dz/uWhgbbOurH8948y532Fu2c1KzMi5bV9muFajhKxAlDF7WZ+Gs?=
 =?us-ascii?Q?qiA1+Lcvivso6xUgKl9LjTpuOAjMAFw2H4tI6o3DBvKBghvB2pMoyFuRmMtz?=
 =?us-ascii?Q?XBNXaagvifTqNCxI9hPvfLSWWJ3mChLZ1Y0Y4VIdOBQ0eod228Caog3gsmdP?=
 =?us-ascii?Q?KvrvnQCp77MJEHfxRHoaReMUK+IjXarsTPf94vhsRPhN7P6m4j5Z5ir0LEdd?=
 =?us-ascii?Q?TZ0Yk2XBnnMr2ut+1YijaaVWtT824a+0weYrj0QBe6mI83X4dngskhtv/mE1?=
 =?us-ascii?Q?UFwjputNqPXzyn/KRvSMQcU4r8W4YDRJv1auIdCqD9e7kNjgZYkRbBDAdxGp?=
 =?us-ascii?Q?YWrusdtZ5Vl4PEv/RlkxBxvIcpj44TQX6EHdovNcgNSQxEYZodq83JKuhHEQ?=
 =?us-ascii?Q?NuwIP/G2Hk0ZWy8C9t7d8voVGDkJj3HVOEpPWmysBZ22LD8W16lXEYxipQgo?=
 =?us-ascii?Q?evuKN15z5JhFNKaj2hE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4e8c0d-3dce-46f9-a4db-08ddefb8a3d4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 15:50:45.9603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AO5uDoByN1Dn2b4OrgtW27caXC9iZz/puSNtGTtVF3cAb9WaevnPHNdrkveYMU2/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5746
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9370C80003
X-Stat-Signature: gowa4jy6zimwo1dzdpqz3pspbmghkbk6
X-HE-Tag: 1757433051-598189
X-HE-Meta: U2FsdGVkX1/o/PVvTFQreBtbjHp9SGsyqq7aUiCkeDGDOxvCNiBOyr9hs0JYMP6IFFDjKrdCbZL2tz+tXWrlbnqRrrdcYt2Fx91w2pHicxIG/E9DsmAaOTQUq1lBphiVytcRiNaRYuGWcbxyhDUDTDy/tzF0An43v5f0b8CdHTQIUISTL3pZqzbWQm8VXLMAbVWdCf7YIeQJmpD4L2cIcSXUZI1nhqGNcHbtYFyCSJEdqtUqC5k5r1ot4SSIXqGRzbUwjskunUCeaOUBGPvMcZ33LNNqnAmnliOsu/Ycso+9HzaFMqmvWQeRvPrJhicsHEHyThBtwLY0Ch4iR9m1pAOi5q8iI01AcmN8aKHfoXbve2+QjQqx0J5YpdJdHmnoX6McC0ZeMUjzMoltNt+1FNIs4/+Mqcs7JpXspRDY57aNMB210YFhKrySdRilwmRIxIEgyFzgKUjSsYKVFgfw7DVZOWGrrD76nbN/behbbJiSQdkZU2N+B6RsGHx7UBflz3xOu3BrHZ1mX7lfriGyB54e+IlRQ/SZKr0fj22oUQs1pCCNpN6oWgVEb5tPf1/qpNynSSIDZjajmB7EMbEIciY2z3Xa5xkDYRELG9+tzpvPxtpn3BbqECVg+tUqJxnwkprJOhFeQz7QT907bR54LeXOn4Ae/ugwFYAyCSrccVVwRu0vp0164cRJf6++BJXXa8S+dTgMRQpZM6hT2fBHba6pfFcTHZw9Zq52Je9L1n8yZ5EW5WCwq4Bbn1Tf4/rR2ybwJy0dF2Mit0wGUVfUTsux7GOlxZxho1wKHOa4egovX6ITEpbH0kXOOsOzUQIt9887LMRzWxD7Qm1npyDLLRyE05ZNW53UDM1LnpWxdDtuTY4gST3dd9ZzXJwDyThyVydmDrzcyUjUQf8UPWHgL5WBpxQVokyEMoebArqv4w/CM4IZGRAxb/ZY84YVqd4BOCvKBT6g1XHAy1udJPZ
 Lr+BNNOy
 vwiUcqyESW0O1sTlchiNMUPJ7StpKcsUggceIEl4lKcfQ4b4bzaVQStd/8cUMX62jj8jVgjz31pRYVDm6kHxf72JlzLcLOOub5EHSyR8tsGC/6N86IBGMAMhZZiUJ9yJo/ZOHc4WpK26Z2tkRTb2t758TYviXnrPCzE5peDgsry3HdRUExUPaJBYIf74BST1kpqifdBN37eYOIcuSQWNBAPXMBgdAvKYAHkL7Ole1TQcEDTitGV7eZer5pviTCcItq31kpQzj+IMI3SXYw1OFPMjKYVip9/zXa7zuWgikyuzrdN+4oDrtnWAnUdlZVSlI4j8MB7Rse+R6BXJ4VooWDdUGdgcjsHI/prwyyoXTDSL70epnYhDjkj3KXP7VWiJTfu4XWuVVw5O6oLw049Vy+9+y063Qi1VQkPJSBNCg0dIzK90nX8pJkAWnpNqYryuej42pLfdGbBQRTeub2e/bjgAvOzqq5sJI7Do8lUNGc3jGshA4jWI/tM6VbbvLHgCc4NvlBCa2ElrZPVneAzucoIl+2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 05:40:21PM +0200, Pratyush Yadav wrote:
> PS: do you know if bitfield layout is reliable for serialization? Can
> different compiler versions move them around? I always thought they can.
> If not, I can also use them in memfd code since they make the code
> neater.

It is specified by the SYSV ABI, compilers are not free to change it.

https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/low-level-sys-info.tex?ref_type=heads#L337

I didn't check ARM64 but would be shocked to find it is not specified.

Jason

