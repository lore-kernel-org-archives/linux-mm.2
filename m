Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94984D609B6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 16:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40426B0005; Tue, 16 Dec 2025 11:08:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3EA6B0088; Tue, 16 Dec 2025 11:08:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E536B0092; Tue, 16 Dec 2025 11:08:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C08596B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:08:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78E548B3D9
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:08:46 +0000 (UTC)
X-FDA: 84225817452.20.BB45C39
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id B3B6340005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:08:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jcKxUlIa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765901323; a=rsa-sha256;
	cv=pass;
	b=LpL2DZS08dNIMeqY0AFSiLo/hk6PSOOaHV0MKzGFVsNvHgIoEarhAEiycJ4S7GcdqGx3IY
	9k4fyqH4o4cI1XfGF+WPRW0GO024C3sblMpiKYsWMqyTH0/Et96c7QMwA6U+pSXYh3J/EF
	cU9Q0GlfoQud97UsLEgp63FJJGasNhc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jcKxUlIa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765901323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wNyk+WhKb0TMphpYLs1JxVAqfb/0aNLVuXYbs96Jvg=;
	b=aMZxhhaVxKCmNU/myF3qGeUr8ftnYFTt+uJjW8MQ4dJuqTEzWM247TF1XIs5L/ahjkNJ4n
	71yyHO7CVBux4/rMUOO3OhcQXnEJLsjUU/Ay3dKV58/rQdzw6y5j35zof7jOkGpPDFfWVm
	4IWMv5WYCs76IqNQws7xZvAV2GgLOBk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8oHc4x5DrqFyjPR0KZh+cEwO77zjssK3x2NNTbUHEnBFtoCvdXXyP+4h6jQGcMF9VMKOV1kwq22wqmvWWd97iigBM/C1XHTH9YGfFVYU6E3CxR3ew342XW5OtjiT/8YDrVON4ih9azwazf8cEyIa5hOoga/36i5cBTwtWgDzjup43DcFv4v3ADVxoRQZn1QOPFHkfdl0zsAZ7iZNVO7A+3ppH+wDMWICaeoDq/1ARXCBX6f9sR/ftb31MeM6wpTnRTGQr0U60WqLfM2L3VDAyaas8ky+BggcoUvl9FQp9eR4MqxKq+JtogPw+AdAA2acC+kVrAkFqJz9tSb58bgvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wNyk+WhKb0TMphpYLs1JxVAqfb/0aNLVuXYbs96Jvg=;
 b=C1vRBF+RAafttmGFZbAky1elSqRnDaZgh1HFADz/MEGPiOTFOhkPAcnDoCjqfwRD0txD4yAcjViOP6U0IDJ+6roRDH4vuf6tzilIF4oplatKuH//TeutZqGpB72bjgWeq6cUo57CGLqgxk1+arXEVIEGR+MMpbeDs2iwbdH+x08/t+/8cgNVuiQ+ngYccAfA/5ZPs45WP2+yuPRmFGDAGm2nKKat/MDBcy2cCgi9MFRnb+UD364kVhWfX8AKCZ2bh1eMRbc+gtauR8Cy8hc2kZ+3RCgVRHq32MDDySJNjjP2FpPKChuKl51paEe7qlFXtbVbKz0NxDSZXV8DbVh9sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wNyk+WhKb0TMphpYLs1JxVAqfb/0aNLVuXYbs96Jvg=;
 b=jcKxUlIaUCUMyzkPi9uA+EnmR/ohID6dfrWXj0FMpQ9Gd+Z7R4cKQLOkFIL31iBwxcpLYP8gb/HRZ/qu0t5q6X29fDxvOBlxizD0ZImFA5qLKG5nqkPp1tOxhPwtAHntv1CToXpT/WvU7mO5Z28LZYRYjnhDeOv+5Z1PKUdGncG3xsDpsywqgFw8DoDv35239REkGMU6VdTSEk805mLtzFMXcxe4e6XHATvHxDO0zJ1+QQci+wTtLsk3wjrF7iiFY1TldZLl10FgEDMoR+vJzF+3JYey4UJBzi5OMlboy3QgD4hPfMrlgDLf4zgcvUjkLGXW8dqfUTugRS5LcbDvSg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 16:08:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 16:08:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 1/6] mm: debug_vm_pgtable: add
 debug_vm_pgtable_free_huge_page()
Date: Tue, 16 Dec 2025 11:08:35 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <881AE235-E1C0-4863-9EFD-B023056014CC@nvidia.com>
In-Reply-To: <20251216114844.2126250-2-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0038.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6802:EE_
X-MS-Office365-Filtering-Correlation-Id: 0075e4db-f1ae-492c-5d71-08de3cbd5f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jszDxYV59JQnS6W34Znx6mlrErGgFTHp0VL+o/JaVTO3jjU+U6YFa0Tm9Yqs?=
 =?us-ascii?Q?mf+1KDA5sje31iTTtZg3t3Jua0GRTs/aWKncji730jJR4Kh0+oq5KI+NQyEr?=
 =?us-ascii?Q?Nj3pMSRp3DxDRsaPaROCUHgRsz1VGuLk1s9xgKpCYtdT6m2Y6Jq0BcyNZdvH?=
 =?us-ascii?Q?8O7Y4Ts3cB3Yd3rc0T9wJjlAC0mUeQMAGh3ypp/a34je2Wh4m7XXhbECSB2n?=
 =?us-ascii?Q?mSAqNYho+j9IqXzQJUMZN+dxMvRiWgd7kuFaDUlIwCJN5XeQod3Hpov+xwX9?=
 =?us-ascii?Q?rBHrGTX668u5OewpQ+PnngmdtVqeHN8+Jo5kGutsRlfMCAvtK3Sov6uNNVZv?=
 =?us-ascii?Q?j4TwQbHxWxyvj7ML4HGt/sGJhLIQOwwbnBYywvGOK94dukf8H5jjkSxlAjpS?=
 =?us-ascii?Q?E1YvVKzoBlsi0CH/7ZEHiFvda48x9GVgMPqWA9LKkmJ2KXLUHqh06gsdEzvB?=
 =?us-ascii?Q?MNN6HT/Ecrqkv7Du4p9qf9B5JjTpvT1sNPAml+GH18JzWOojxSrrncyEuwbQ?=
 =?us-ascii?Q?g+Jqb3WO3KTpxYL/1E/HF2GKrTAA7bvoQKK3c8BFzlur+WHa3Qmz1erfWgI7?=
 =?us-ascii?Q?/XNHvoK3wVQC8jkyC9VEcV/Oy/LzKvEsemCyZh1E1ezYM/QSxB04B7e6ZWaQ?=
 =?us-ascii?Q?81tvsoYPUAPETCgtbOjggb5YH8aNWnHvBMPjyY5oUvg6CIdzjOChuJ4vqpNN?=
 =?us-ascii?Q?fuR0ngtsZ2ho3prKUaMnbezzhEC4LrNJDsDqtj7vZ0tGBl+iG9pjgT+Wq/mM?=
 =?us-ascii?Q?Pf5LYxHfRFKR/pexpPLJLw0ImCAqq1J0NaUuXr9ylc+ozy+8FJN9ijrw1HlY?=
 =?us-ascii?Q?MRIAyjNoTN4pbJfrdnFFXMBsCGHBGZosVxwl5GanQLnx23cohYDz4QftVz7l?=
 =?us-ascii?Q?5YS6kzQYxe5T1gZwoi1mHs8i4iLmqsh5CSGcFFnrRrH8Pas4vY+fK/IZev2e?=
 =?us-ascii?Q?AHZjXZPFnovmFiu6G5m7/6Lx6+7udHQJcaUfBR1XZ3Vg/96KT00ZKMKebdHw?=
 =?us-ascii?Q?yTG4bDKNBJUZiBxT0VswkuOB7tnPA22LTYYkSP5M66jdyVgPcsQgoRC0VU1a?=
 =?us-ascii?Q?f906RsBshgvekxwDTChEXBn05GYY5phaB8vSeVf0NfOvSdCxxsbXFZrz+3cZ?=
 =?us-ascii?Q?2P3YF+/3ydflL90j2LEPMMWAwlzrATFE3iKe+H/a2tHhFHTrxVfN5pA4S/5b?=
 =?us-ascii?Q?b1t2KpEp3jAUCN1RpCgu3wuAjqvLHBShe6OBiqCKvzouRi/v6wh26mTFwsOT?=
 =?us-ascii?Q?dFRvR0uy2tZq6rvhgJpokIIROJHYt7+gQk58UKLKsFZM7FQyU2JMkwhb36qm?=
 =?us-ascii?Q?QtSkl/qV5Jo9L2mBoRo4RXAzROrDA+uZH/AvS+XDY7Ehnw3svEQBf4bNTDHu?=
 =?us-ascii?Q?wsm1j8h3peRwZnq9Jb8SSsiLI8atF9bqbgtw+7zQfIUEop6L8unQqUddjmPx?=
 =?us-ascii?Q?JVsZEDJ1qcQO/VRCadudfd0W4OuGgCGE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w4WMVvxLRoYvrvyn8g7lLCc0fOErNM/2iGOWonG4b8hMK1Z6OxZes6Uyi3Ga?=
 =?us-ascii?Q?tHzHLRP+NXWU6hlqLMz+pDb1mcKPc0G4hWri13d1CiQQtMjXikIirqVh3caz?=
 =?us-ascii?Q?igcSUF58PyLAedGQjgw6dRRyFohpaIBg4ALK2Q0KpUT5g8DEErzLDvHgMGHy?=
 =?us-ascii?Q?dFkoXGUTE5K2TZj01g9ynQnfjqVRrlY3DLguV4ujWVHQbBw7aM5ZZyUjFLk6?=
 =?us-ascii?Q?PN5x99+Cs/iwZb5q+iGxdEXxkkdHXy3hTO377qpB9oWu7pTkonKUkUYRkQok?=
 =?us-ascii?Q?kQ43mxDF9GIKhD56RXnQEWcR2v4XwI8xSrjYG+vF/G3jNa/XCG9UJATH4Gjo?=
 =?us-ascii?Q?aiFRNwJ01NtZILiCX8xzbiM/G/qqMkmByA2C7PuENh4Ul3fqZ+tmGht609HI?=
 =?us-ascii?Q?MBAEmpgykH19ASmbg6/n8TzsfvSE2zaI3nKNDXOWRd46KJ/w6lxW+T9sYxYt?=
 =?us-ascii?Q?h7/Malj/bLugZD/TGYEhg+/8K2srQhBj+uBgDkVnPS/8tnqkt+DofbFi859T?=
 =?us-ascii?Q?HoYT+qb337g1fiKm+SjzovpSOV4Vl5jXnW+1HJFswky1zYvGs4+8SSEc6H5q?=
 =?us-ascii?Q?jvFSiq3gJ0yt4HYge1FX+ad/n2gUb1BBmer9irzjupaOURGnpuqBS8NxilBK?=
 =?us-ascii?Q?qs1y5sqZtiPr+tSwlDvbQ4yEUZ7zRcTZ2NG9OtivMaORBQkV0dsc9ub72DW8?=
 =?us-ascii?Q?PWsD9XqxG0ndYCkUeBqMpBGnVHf5qTw8TJvvv+aaXPkDbPLlWTxLEIiSgryM?=
 =?us-ascii?Q?0mWH9YsNcD42UhP5ESYtUmpQLruT4DzhZzUjMUaHVAl4BHXhMav7kSDq36LE?=
 =?us-ascii?Q?6F2nER4sLjQVeCLFOu1nD0e8yL9gOnEgtJLFUX9Jem+6yG7HI1vrBh7zKSWS?=
 =?us-ascii?Q?1Qh/aH/CIY3BnF41cqBQ5Hj9TzIMzOCIoKwx3o0sP3PMZgYWT9i7Q9oupWoq?=
 =?us-ascii?Q?FVsi7MW/2ZhcWMMDnr49OhZWbXCqrjHz7o+zmHFZRO8/w2BvhbEpM+PPqqYi?=
 =?us-ascii?Q?mWHLokX3s/PNoaKT7CBGykCYYk9tX+SgFekf/4Nj7N8/MwZrOfvxYqYdTMQ6?=
 =?us-ascii?Q?29YnRR39t8/Vpk0tIlBnmN2uME6Gi6Gq54hkfJKf4S9YJ2HMTfND0yqKjizi?=
 =?us-ascii?Q?wj3POHj8oEHUlPpqrbeAPra/OZi3EDBuP/f1FaLlqulD6rnm47k5haq0Cy9N?=
 =?us-ascii?Q?/tg21hEKxGWAZmg9s+9UA7eA8CKDHV1TmhmDmKNKbrdaS7WBRDl9iHOruezV?=
 =?us-ascii?Q?uaOvjzgojZ5Muz8bVKx7KzDWKMU7O2wFK6NwuyPZGCDH0+uQIpQ6lIsEz4Nz?=
 =?us-ascii?Q?LkUklOMtecDkpU0p7gkprV12Lrywam51UFcuBJlYhUjSFVtTCtt1YrvPPqWz?=
 =?us-ascii?Q?CBTZDOPWbVlc/SMnsgnoQmh7WWxrjQNSj5DdEvNUQ2Tf7pVQGzuYwUHCbb2k?=
 =?us-ascii?Q?X6LP1HEB/wzP99ss4fQXj1T9UeQRJr5T8J6Dic1wE5VzyI4b6iv4cwFfEV7v?=
 =?us-ascii?Q?fKmvOI9/TEJ6LBumGEwb9g8vy4uazHCKinG3lO3Ghp4FCW6Z4DRjjLYDeDrk?=
 =?us-ascii?Q?8N3inO67/JklygHxMhFNxcx6VEvpijwt6DC2cFor?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0075e4db-f1ae-492c-5d71-08de3cbd5f5e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 16:08:38.1311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzuELsTs8YRsbCkF5Yh4/UAIgmRqNGsGZhy0+hI1Tm47TvhscOfdQWUsBati3AMj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6802
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3B6340005
X-Stat-Signature: eeug164iikfzknxb6gow1ghr7mroxexc
X-HE-Tag: 1765901323-519787
X-HE-Meta: U2FsdGVkX190g1aiWRD07ZLyHpSEw7uTvl3TXiRAqTOXjG6IHHugcPNzhxw3BaZG+/YFuB7L0C2U0ysWrdHf/6wyReHSt4rcVCDXiqD3ghMoUcfGr3JP90gsgpn/kUlvK9WOv33V0lNKXgn9FDxhwY2eAFLF7V8wDHyH7fqmgHYj/Wg3dC3yg/tcDHEmiAFSZWN03n5aQdIRmWXAkUDpDzMFBM5WWT+mh+wYEkcU3AL8ubRT5AFa21y+S6somPfGwJva3BJvvf2fCKfccLiWhZKujkBbjaKt0EFhYpRnmHmb/MaGeDtob4QLxO45NiTSA03spNQvLBhBD2MGl6DaPHpc0DfAAghdiMEINGMepiZpXD5rhC4ctLFxj6RQLwrQOSwbhN5VXgGEw8rgAwTQcWzOH5Lz8z0oFtTnQ8ALdSO/bbhfQ2UcWBav9PrCYmX7yuzHa571beDNE3piJa8Uh1CpA2WR7cKBVA+QO3EwUNHfWusQW007xs8FqQeNfHnAzNeHAuWynWaTAfIsPOjS5AXLsacf0AItBffSO9LrGc07ktZ6IlRXjeqNfg0qGmjtthA4INPYz7/TrdvXLz9IjdsGq4xiNfrXa9gw8OI/OPuVsXQMMMm2bPGHVIW0WfpuZyB1DCbievqMFKyvDrk0sSA9BfRC9pPohVVXKJILQDHs8i4yljFMCtEw+IECde3pnPbSbTYGkFnP6xEiYs+mqyxKKjSAL4bTjpe6qROXbd7kk3+swGT/r1TPUl4LhSkzIXCFGK5emLepUXTvG5+/hajTpEoZr7IDCaS52Be3uz01mmlA7TJBJGpU2QiUqAG5zrVTe0bnLos/bQnASI93O6LRB/ds+AQZdReteEqHbs3B2qKUnM5tXGzXxqNtG3ok7wzrXO2hzDuT5zmxk0al90gW4DvR8w3HEmlAVf0yw8YLeO2Z23OqYBUSpVpQy5eGRxVHj5XgPPSLmmyMqlO
 UktYzq+B
 BryTkyMLp2Jrw3mkUXCtBY4tZDG/SD8Ql/9WUoXFMRKO3F242A0mWU731fXqGrJjbe8kwOMdt6LlbzL0TEoAVs64P7Ljzxa2HSHPQubw2NlV2mvFhS3t0xydLtCYY1WCTt6WsCNpHIypSxvvjyCgwOwz8LHq0GbtkAcSDmVaZLttkJIbAs8EIVXSH4AjheRzRMHIeir9GdesqXltxhcKDtrcgZueWsP3PB3tNyTVBbvx2XZ2ejcQI99xnsMVvT/bGuJJOXNL8tF2kilMMhLQIbJ+eaR8KaWaO3/Y/2Kkd8ssGHK+xFPBpdzXTQfYd9meRH8SQg7iHiHnYo+GS1Q/Fa1GwAFVc5LOQsZJF4V4BCikSnSiODSdF2QLsKXa4JG38aVs+zlbBlpq86nsvt9KuPgAteGyOideCmvg4MfDWZGKov2VDqSgewmkReZSmLGV4hZw8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 6:48, Kefeng Wang wrote:

> Add a new helper to free huge page to be consistency to
> debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER
> instead of open-code.
>
> Also move the free_contig_range() under CONFIG_ALLOC_CONTIG
> since all caller are built with CONFIG_ALLOC_CONTIG.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/gfp.h   |  2 +-
>  mm/debug_vm_pgtable.c | 38 +++++++++++++++++---------------------
>  mm/page_alloc.c       |  2 +-
>  3 files changed, 19 insertions(+), 23 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

