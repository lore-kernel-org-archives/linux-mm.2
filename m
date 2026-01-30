Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D3DCD49C9E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 10:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88DD6B0096; Fri, 30 Jan 2026 05:53:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A672F6B0098; Fri, 30 Jan 2026 05:53:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918176B0099; Fri, 30 Jan 2026 05:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8013F6B0096
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:53:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 280191B13BD
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:53:01 +0000 (UTC)
X-FDA: 84388317762.15.AB1752D
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id 461E7C0006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:52:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="B1sDK/Z2";
	spf=pass (imf10.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769770378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DxFpVJv/av0DPVhGRwmcwo+RxumKgoR9M34Q2wLSfA=;
	b=ZcegC6T++huTnE+Eprf/ZKWT0cVnpQx14ts220nk+pqx/Hpdp8O9YM5smYADjp3rdYPpwF
	AUgQU9VhEJOiwWMkMU7xCqMBZGxAqwZXirCOiZyTW6R0mdVjrwPZgr5ONVWTcDo2JvrfAs
	XGAnYN71Y3PHvcHpLem9xtEygWJbRVI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="B1sDK/Z2";
	spf=pass (imf10.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769770378; a=rsa-sha256;
	cv=pass;
	b=nc/5QwDIj4/pKQdzgBRKGKej1GYW5edCxcDgllKM4qh1VMU7UZ4tTvmHAn+EeJ9TBg9mB6
	V4KlFUCMOrwQM+FFm3y7SZkkIce4m6jLSBIYiPlnRayq1KDwEaAvVFrtNNgZLIAkXD6PuM
	1A+MN1Diwhc6Ye0zeLC4paOulb5ssDs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IU0izkLuKElPRlyoYSH6ooJW8qOUy2xyRJDKotYrbFJc0CdxXZwoWMRhgRcbBLotgJsDp+R7CP9QtCXJFn3hJXskFKqVh9jH9ZoGqHh/JWnE9ag2GsFIyAVy3as+BC0wOLTZc5/mwkNtS5ltjs9IHMPpQDmUnQNsbtJj9u/kkWr5YlIVFbdrbef8fJsVtvsCQzJx0elphhjtwMA2AXYdzQlVzQNb9l2AGZqtBLnJfbCjvsnabez61dLP+F6bTydvHOmRukWE5RxWEBN3g6CxlOtd9Fw6BYy+9x/U4mPbD1sNd1OUqm4QshMFagLqQdaW/HgJyGNXqvfvZic8VLTFvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DxFpVJv/av0DPVhGRwmcwo+RxumKgoR9M34Q2wLSfA=;
 b=Rthw02TGua6OCe1lU7hebED1W5oBh8rkiO/b/7Sk07aMLGONexKPwH+3Hmlavc832XwqnECEr0mMfLeusKg2abz6LSgAseDDAw7Cxm+w0lq41Y3U+7sdAee9v5Hh45zn/CiAq8LucUBYolVdQz3LltfXsMyBbp3DDd8+jK50sBY8t9MoMy3mF7vDt9jbDFVNP7Ps5YrAGrw3FNsHhlSVTO2AZRfDhmRKX692HryTQ04d/cwfdTRCE52tZqWIr1jlGB/nNd9aRyZDSJ+qHxR38EA1tp4070IrlFM/v8OJKw/0jNyX6SXNZO7hLUVPIFlSLonlW7lf61dXQxTDe6EQNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DxFpVJv/av0DPVhGRwmcwo+RxumKgoR9M34Q2wLSfA=;
 b=B1sDK/Z22KuWiMncGS2WdM7KdmH5kGgdoxRHYFBvMIijF2JlVTzd/T80uEri7JT5yXxznoaSq+QbWOQ4xlUiYm7/ZaAjbDtkkYeIi1ZubOmCJ3X5NKOPs4g0lMuPDYtNYHtKGRKR4aZSgcT+xiDdiSaDkxYbRier91UaryqkJDQFQl42LX7NoSunFryqLN9d5RgJcGuakM05kd024EcXOZQyUl3c51y80u2IIfA10nu/HKGQtTHWRBiLDeGkQNcegzwjUK5/OvV5LsDVjz6jcN4HvI/h/dJm+U8yaGcElkeoLBwSHKqFFqZv7i+nmoXzYp6ObM6El5nEy4VvpLLVmQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9760.namprd12.prod.outlook.com (2603:10b6:408:2f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 10:51:30 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 10:51:30 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v4 08/13] mm: Add softleaf support for device private migration entries
Date: Fri, 30 Jan 2026 21:50:54 +1100
Message-Id: <20260130105059.51841-9-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130105059.51841-1-jniethe@nvidia.com>
References: <20260130105059.51841-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::9) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9760:EE_
X-MS-Office365-Filtering-Correlation-Id: 002456f2-291c-4a1f-90e6-08de5fed8670
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5CAYNNSdYJGzJfueegY9pc9Xen/WlVDQ2dMjBiBuv855vDm/fnEs5y0wUFzt?=
 =?us-ascii?Q?RJn+1EJgKUPMfsSlp+RDUcEV5PUdAyRX8FLnYeKHjj52l8qrJEeDzk+nUIxS?=
 =?us-ascii?Q?3JBGMzdBCn1tkfo6lD/JBY5GAAJPLFt0ILW8pc5LKt8JggZUbiBmFvgTuKxj?=
 =?us-ascii?Q?qlzHc3FAwAwBN6vxMt7D9EtHRz3iTs705YD1GhvproD+aLeuX9CINoQVMs3e?=
 =?us-ascii?Q?6jLEXCQTO4CSeX4D7YWVg6fAeRn/GoRaY9AkeuucH9k91fk0CvSVxdUZ/PMv?=
 =?us-ascii?Q?5tCMw1QC3kwSji+4+QS75T3Cj9VfHZUpGE2OrfAnHl4y1meUIKlFvtHSurmL?=
 =?us-ascii?Q?YPh5GdDYRjB1/2GkZn6LOfmLoPvoVCTmfTpiYzbZXyRlO2lTJQve3j+R0HRn?=
 =?us-ascii?Q?O41NHVhlkmpdI1Oq8TFsI9c92F7ojoIumKe3EHzPsqIEa1QCc+3Vydst7Drn?=
 =?us-ascii?Q?LJCItF1qvi01FCZqCm6Jk2KPKQJdgAlta4bGRk2Hxum1YbkuDyIsOY9COVIw?=
 =?us-ascii?Q?5MNr09qC4Z+K25VOKQLmSxD1Et3CEA5t7oy0/2jK/LqN0/QkdxXoz2WOH5Fo?=
 =?us-ascii?Q?PoMJO1CZD7SgTWGWZ9wh9Z44pho65bE9UTXeQlGMy/btX0j8twbxHUz/4krc?=
 =?us-ascii?Q?Sl7vuvTT10ElzVlaRHnXoYxScjGfDZfkFflMd57v4guiRIgjo/TR6v3BxVuu?=
 =?us-ascii?Q?kIwjJemkN2+SA8g1skbw3gkKBhfNcdJv6jghiYaxb3yr5I4hSCtfh7ki5auB?=
 =?us-ascii?Q?vjCvfsELqj4gx2AV7zK7J/j8MFED3B1UTuiB+k2DIDCT+6FaN2thHHBmZibD?=
 =?us-ascii?Q?mdCkXvi3mW8sK+rXI5hg4LJrrVGo1+y37/7EO0kYauc0KFtWpZGVpw8bTLVP?=
 =?us-ascii?Q?EtS8oNaeGtZchrfC7qgkYcTSU/M05TE3Qt+il14pSOiQr7nlKS+zuSZNy0sD?=
 =?us-ascii?Q?M7lM7Ot7vXlkezRqxB4PGGb4rRpCckx12KnThz4hQ2cPpT/8zUl8uXCK7Zht?=
 =?us-ascii?Q?U1T9f0ofxWEGE6KgQ7aZzLNAKWp38uRuIiGu3Mq8Eo75l4XMDC1uHUlDsKI/?=
 =?us-ascii?Q?bu/CcGZpoBlxvY3eFM8AHB5jEtEtpKXHWnsXk2ZEXVMTyPHEOm7MskJYJpEa?=
 =?us-ascii?Q?qyDOaqX6cLJi1tDrlIj9rNApe6snKE39N4ygJNDSPPlQFYK5zjKjyR/Vrvb9?=
 =?us-ascii?Q?XiALJVjiyYyXsFAe9ggUZ2USbi1aHFPM0hWk3pYScp+Tc2cq8aOvlM1wWnA7?=
 =?us-ascii?Q?O2VwPdpjXtL7sL4Li8PoKsXp2VHcH0MKei7Gkd5pMag6vH5YpNcEMCv1riXk?=
 =?us-ascii?Q?3Kx3EI1Oqs88/V5snLKYfYpjfL3Ayxl6j6HcFm44Nl+seVfgmsVFQeCLDo4i?=
 =?us-ascii?Q?9n7PiFNKjTw/fPUsFhH6mcLsOsdVVQawlugZmowiIzeyV91fPlKEJPDT4Pba?=
 =?us-ascii?Q?zvhWzXCAnUR07N45yJ/800Dc+e36KnPHbW/xFgZJaGtVH2VJAp9djfnHye2/?=
 =?us-ascii?Q?E2GwNU5A8EEqJm6OiSJM96UhqK7hSKYIR3q8WaAJDtVWfwlcCK3gIneRnyYo?=
 =?us-ascii?Q?UjGIuVCgVgBstpRUykA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lQ1ASFimfnTBspeDntd8tWk9x0nrvEO5FUPCzxKtbdXmtz56P4aaEdI0Se3g?=
 =?us-ascii?Q?mUP8W+PIfIZkU71gI3v6CCi8ma4DDHkkpul7Plf7oUKCk7OhNy6/L4Txgm4q?=
 =?us-ascii?Q?z55baKiDslxCQKYg9sXU1qgY9JU49qRcyaRLH6KJO8SR/TkgWANVFAezI1rm?=
 =?us-ascii?Q?IfWypRjgDveoC/UYyxY6PM/1gM6CWnau+OJ/9kwjSzvBtSmMYhwYPCViyjUA?=
 =?us-ascii?Q?ynmdfCJm+wKQObwZB1yHSb053/dS/uNpi0RKby+za+TbbUM9np2PqdtngejE?=
 =?us-ascii?Q?ZT5f4MPfwSKz1JVoK4PFRcj1mN2J7vGrbCc7kdGkjx3ZYrmvRbL9Zwf1bRo+?=
 =?us-ascii?Q?/bUxtB9XQK2P/ICnsWIz/lFGeceKvbuI9pnYlWtQceJ10eRcIdbS+bhoPdI+?=
 =?us-ascii?Q?V9tyQpn3cqBUwfHd5+mHAdH21vfvTX/SkwFjuD3dIub34W9M40x8Bz2TW0To?=
 =?us-ascii?Q?NnZmrLy5qO5B6VMPvpa/B7ntLfVuZ7jQd+5w1R4MM5Lo9h7cZQc5k6H8He1s?=
 =?us-ascii?Q?qDdgYph3Q2jH/NffFzJK7qxCl7xjQYTec9lF2WAbyvD49jB70hdF+MUsUjLS?=
 =?us-ascii?Q?0zgDPQUki7VgAhBgeRC6t9FeS1vt2USihMrnxYqmnHsWtZSo/QDO9qFZRl5g?=
 =?us-ascii?Q?OXRXZjsPFlXpf81XyxiwNZSJhlEdktCl6oep0f9pvQEQSg8VbsKMllQg0MPA?=
 =?us-ascii?Q?pTi5H28NBIEzeINiJFiFs0ffL7RyGuqK1H0R84mYb07h1lcUD5HZ/dFZlDb8?=
 =?us-ascii?Q?XoWM4sLFXPEbhrZc9bKH1FMXAbdBgj7YtXKrsj/Je9EJyupJ1AQQkuTqY+/Z?=
 =?us-ascii?Q?RSv4PkZstfeqy7HMfbXA7OJav0l2Tw+eVUmLGXYMF4n0k9XFxvaziZNAtGRa?=
 =?us-ascii?Q?N0VUggyERCeAnS7fzoqBhihujMk+JRXyy01wIIPpgNzzU62w6NeDTMzS3xxG?=
 =?us-ascii?Q?QzXLoj0zhOvanYm5qGJuWykCdW9AXDB8yvqBdvDT3ww8bo5kEm/3WOlm7l7H?=
 =?us-ascii?Q?bYBy2F7FHRL9X1mCRmERYRLkBnKEmlN7i1N+JCkqOW0QogbTyGh430Qlr1aE?=
 =?us-ascii?Q?cwzOAzIuD6LpHKNrX2IqVvc34u+e1n11a3IdTeC8fQ6+iLAoDNs6EpDpZCMy?=
 =?us-ascii?Q?ehSvROB/RilhDfUETOheQlLknLqp4GBzmjXHg5sCd+ubYCXGmusK2gQXX+T+?=
 =?us-ascii?Q?c777KboSWiePGctFXr+X4SFhKfiDqCUXeNK3rHdIvDkV75TzjnkiqqB33nFg?=
 =?us-ascii?Q?gX5sFWbABLM9hhyJN3odttyiXGZftpMuonR/JQbPHaEyW1eQ3lES/vbwZKKL?=
 =?us-ascii?Q?2Fi7WGWF437vK6h6Z+/k+AVCSXM4WRXgkzOY+kbHeb35bno4SM8ZrFaGY0ZH?=
 =?us-ascii?Q?fh3MD0A1lxV0oaPLD3/0eEsUSEjUHd245aTmJYJTabKv/kSTcoshp6DGpRNh?=
 =?us-ascii?Q?LWBY1I4i6kLcEBZ1790TdZSk8MBhPZT0o4ejAanBDjff4ILF4ihElFISUZax?=
 =?us-ascii?Q?ewHuODreTmw/+nsy6oFn8JpWXFe0lHVIFRqXqBkqnYI3IqOAsinBW5BAcJpz?=
 =?us-ascii?Q?jzTQkEy7WlEj1tSGQLwj3xtFW6YEFoxN47Gje2vcfpL8VtRUZAc8R98z+Zik?=
 =?us-ascii?Q?DlKLT0c9+NtuNwslZfCtspdy2cq9M6UYntJYD+MGnEtPhJuG3132ZN6LwqU0?=
 =?us-ascii?Q?sm2rahRWUTThf2NkApD2M2xXRx1jiF69uje17UTo1WvlJSYe0JbnwYN3LUxm?=
 =?us-ascii?Q?rmdKU3ATqQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002456f2-291c-4a1f-90e6-08de5fed8670
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 10:51:30.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewKPQdlzQckXrCAtLJIdYLmiNBZb6z5Cr9hiJry3SVRuKm3fy/KeIZqNb17RWWrh3Q10alTSlwEpaAQB75Dn/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9760
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 461E7C0006
X-Stat-Signature: nkdtu9h3osfmc4hsb9ydzywhhy66wphm
X-Rspam-User: 
X-HE-Tag: 1769770378-581872
X-HE-Meta: U2FsdGVkX1+t9ZmxmhKXl6N7slg2jkqlpi+0AeDSxeBbJaPGN259gw67jW79cZ7d5hcFnjJooINjT0GuIUdDezzDL6xDvFDbaVN0bxMiXg726+x40oTtxt4WQjQRWIstiuOsiijv7U8NjWfNbez9KRkfo87rZxB8Xis9EDWIqEowQZ3yaQfNWOVsGmO/AdsTi9Si08B0t71zycAhuqEH1wCHtxyjMvcvlIOH7Es0p/1HEWrox8B0dWUt7FENL20buKyNHKSMIjJ3hL/+wd0Aho9i3keAZafEKnDHG70bhlq0aQg0tH6iTiLUIFANcu9pOfnLPpEOxYtfNMrFwiz0+8ENrJx+jKlUC+cf8P2/9EwQS/CA2eGX75pGwNeAsBaWL9O3P4ie0WMcuDSU4QWrtzjB4tIv5n6LgoLLLv/I6RP0aizUHJHoyxGaoxvfexeGBCFOZmXeob3Ll1EAwqza0wsbErMM6oZcLhzWpuMHFHWeibxEy5D7bsHZqM+PRHX3xq6XQKTclHZkS7GEyMe4ozBqmc4iqraoO6jEcjpQSqLYFxyEgAocIa2cNUz+gKTqZTibHf+U0e7PO6fdwgPxC5ODmeciqKvEi+iymAAcju6Axgu+BwqwtVIfIchPpT2f1mkwyAPu5LrU6E0XK4cb8ehU5AzSAkXtv6oatz7lh0L6f2zNgmTGmRle6Bn5+Ho8X4HhxZzUsnC5NX09ZA3XrTBUB39KfhmAt2Add16KAYNQnylxXx3BXr0c7Tl4AK/QEwVkbiP6igBjoIcIBlm3KLTXQqSLOyY6ZuCtYmxaQQZmMPxqKupo9YiMwNlzDl225JrQe0QlPf1j5ChhfJFqqFzqDIkNC6Z7/CVJL73PgITMyh9XU3Uz/DcHbXh30dbE0EmA+Q8VrXjR8oWwk/24V9rmTZStQIgjrutmPYszZ92HYRCB29UvqmKTtETTd5UxDbGyNRRqpt2ZZcjZaPI
 2KWpbt89
 BB7/tyynSRmhZ2MqiTKNaxr11qIVy13XnKPcbFCgu+PZprF3qBC1XZA9HCvWPyTBVddIlBWkiXmu1pQyZ8Rapbn0jPP9wjOL+dDvBHO7/bTaWXYeWHqN8zao0ywYkdYhw5ir7LGC8ytVgpPr+6BF+xGUcVLLdVLI2OzQfx8ljCYgr/Z9CtRISrdJS0TemKxMl5UWvckA5PEWolSRMBmFosrNAngei9s+ZSfXivdNSi6wk96pMOr0wbiNwz/FQ1zV+jaG7CFvHMhCtzlXwsUmXLJRgjCtypV7cR6YRdTgozHs57odcJ0n0Pxhu77lBHteGNsY6DYK37zLw0V3U1r9yBuT7CCTWXNCwK+3p2oKyK77rXox4HfYENn/nZTyKI1ZUv48y66b7SurLTTF2NA9pel1+qFOemWAdjNIqWs42+ai1vAS238StBIbuLTPBcv+L3m33Hzx/4vZD0CVBgztzZPOp/ABDZrgA+NhFB06Bavf0gaY5yWebqlF06SU014ffpTDu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add equivalent softleaf entries for the device private migration
swap entries:

  - SWP_MIGRATION_DEVICE_READ -> SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ
  - SWP_MIGRATION_DEVICE_WRITE -> SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE
  - SWP_MIGRATION_DEVICE_READ_EXCLUSIVE -> SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE

As with their SWP_MIGRATION_DEVICE_xxx kin, the
SOFTLEAF_MIGRATION_DEVICE_PRIVATE_xxx types are used as specializations
of the SWP_MIGRATION_DEVICE_xxx types.

The new entry types have the following relationships:

  - SOFTLEAF_MIGRATION_DEVICE_READ is-a SOFTLEAF_MIGRATION_READ
  - SOFTLEAF_MIGRATION_READ !is-a SOFTLEAF_MIGRATION_DEVICE_READ

Update the existing softleaf_is_migration_xxx() predicates to reflect
this relationship.

It is possible to distinguish the between a
SOFTLEAF_MIGRATION_DEVICE__xxx and a SOFTLEAF_MIGRATION_xxx type using
the softleaf_is_migration_device_private_xxx() predicates.

In practice, the only reason for introducing this new type is so we know
when to not call pfn_to_page() on the swap entry offset once the device
private pages are removed from the physical address space. That is the
only time that the difference matters.

Creating these new entries will occur in a subsequent patch.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v3:
- Separated from previous patch
- s/SOFTLEAF_MIGRATION_DEVICE_/SOFTLEAF_MIGRATION_DEVICE_PRIVATE_/
- Update comment for softleaf_is_migration_read()
---
 include/linux/leafops.h | 90 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 10 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 52a1af3eb954..60681ada7b8e 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -28,6 +28,9 @@ enum softleaf_type {
 	SOFTLEAF_DEVICE_PRIVATE_READ,
 	SOFTLEAF_DEVICE_PRIVATE_WRITE,
 	SOFTLEAF_DEVICE_EXCLUSIVE,
+	SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ,
+	SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE,
+	SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE,
 	/* H/W posion types. */
 	SOFTLEAF_HWPOISON,
 	/* Marker types. */
@@ -165,6 +168,12 @@ static inline enum softleaf_type softleaf_type(softleaf_t entry)
 		return SOFTLEAF_DEVICE_PRIVATE_READ;
 	case SWP_DEVICE_EXCLUSIVE:
 		return SOFTLEAF_DEVICE_EXCLUSIVE;
+	case SWP_MIGRATION_DEVICE_READ:
+		return SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ;
+	case SWP_MIGRATION_DEVICE_WRITE:
+		return SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE;
+	case SWP_MIGRATION_DEVICE_READ_EXCLUSIVE:
+		return SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE;
 #endif
 #ifdef CONFIG_MEMORY_FAILURE
 	case SWP_HWPOISON:
@@ -190,28 +199,88 @@ static inline bool softleaf_is_swap(softleaf_t entry)
 	return softleaf_type(entry) == SOFTLEAF_SWAP;
 }
 
+/**
+ * softleaf_is_migration_device_private() - Is this leaf entry a migration
+ * device private entry?
+ * @entry: Leaf entry.
+ *
+ * Returns: true if the leaf entry is a device private entry, otherwise false.
+ */
+static inline bool softleaf_is_migration_device_private(softleaf_t entry)
+{
+	switch (softleaf_type(entry)) {
+	case SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ:
+	case SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE:
+	case SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/**
+ * softleaf_is_migration_device_private_write() - Is this leaf entry a writable
+ * device private migration entry?
+ * @entry: Leaf entry.
+ *
+ * Returns: true if the leaf entry is a writable device private migration entry,
+ * otherwise false.
+ */
+static inline bool softleaf_is_migration_device_private_write(softleaf_t entry)
+{
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE;
+}
+
+/**
+ * softleaf_is_migration_device_private_read() - Is this leaf entry a readable
+ * device private migration entry?
+ * @entry: Leaf entry.
+ *
+ * Returns: true if the leaf entry is an readable device private migration
+ * entry, otherwise false.
+ */
+static inline bool softleaf_is_migration_device_private_read(softleaf_t entry)
+{
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ;
+}
+
+/**
+ * softleaf_is_migration_read_exclusive() - Is this leaf entry an exclusive
+ * readable device private migration entry?
+ * @entry: Leaf entry.
+ *
+ * Returns: true if the leaf entry is an exclusive readable device private
+ * migration entry, otherwise false.
+ */
+static inline bool softleaf_is_migration_device_private_read_exclusive(softleaf_t entry)
+{
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE;
+}
+
 /**
  * softleaf_is_migration_write() - Is this leaf entry a writable migration entry?
  * @entry: Leaf entry.
  *
- * Returns: true if the leaf entry is a writable migration entry, otherwise
- * false.
+ * Returns: true if the leaf entry is a writable migration entry or a writable
+ * device private migration entry, otherwise false.
  */
 static inline bool softleaf_is_migration_write(softleaf_t entry)
 {
-	return softleaf_type(entry) == SOFTLEAF_MIGRATION_WRITE;
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_WRITE ||
+	       softleaf_is_migration_device_private_write(entry);
 }
 
 /**
  * softleaf_is_migration_read() - Is this leaf entry a readable migration entry?
  * @entry: Leaf entry.
  *
- * Returns: true if the leaf entry is a readable migration entry, otherwise
- * false.
+ * Returns: true if the leaf entry is a readable migration entry or a readable
+ * device private migration entry, otherwise false.
  */
 static inline bool softleaf_is_migration_read(softleaf_t entry)
 {
-	return softleaf_type(entry) == SOFTLEAF_MIGRATION_READ;
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_READ ||
+	       softleaf_is_migration_device_private_read(entry);
 }
 
 /**
@@ -219,12 +288,13 @@ static inline bool softleaf_is_migration_read(softleaf_t entry)
  * readable migration entry?
  * @entry: Leaf entry.
  *
- * Returns: true if the leaf entry is an exclusive readable migration entry,
- * otherwise false.
+ * Returns: true if the leaf entry is an exclusive readable migration entry or
+ * exclusive readable device private migration entry, otherwise false.
  */
 static inline bool softleaf_is_migration_read_exclusive(softleaf_t entry)
 {
-	return softleaf_type(entry) == SOFTLEAF_MIGRATION_READ_EXCLUSIVE;
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_READ_EXCLUSIVE ||
+	       softleaf_is_migration_device_private_read_exclusive(entry);
 }
 
 /**
@@ -241,7 +311,7 @@ static inline bool softleaf_is_migration(softleaf_t entry)
 	case SOFTLEAF_MIGRATION_WRITE:
 		return true;
 	default:
-		return false;
+		return softleaf_is_migration_device_private(entry);
 	}
 }
 
-- 
2.34.1


