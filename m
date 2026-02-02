Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33468E7315B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98A246B00B8; Mon,  2 Feb 2026 06:39:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960D86B00BA; Mon,  2 Feb 2026 06:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82CA76B00BB; Mon,  2 Feb 2026 06:39:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1566B00B8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:39:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4389E1B2359
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:39:34 +0000 (UTC)
X-FDA: 84399321468.06.818BC51
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 68C90140007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:39:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UvMOvGx5;
	spf=pass (imf23.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.41 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770032371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
	b=z9w7dq0yumyoLoaPhPxRKrswAz0qAN7NwTXbGSfiAtC/5MkQb/jh5Uv/zUQbMU0R1hqZFq
	v90Dw1uriCBqp8nm6teIud3xnHhO4YFYHYbPIKqhS0+dVfn20HFGVeMBSpJCcn95I62A2C
	95cccTPqHSBHmL2iZ19ywodh0JEWmR0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UvMOvGx5;
	spf=pass (imf23.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.41 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770032371; a=rsa-sha256;
	cv=pass;
	b=xLKpoGbQ/OdbMqK0Z4HeZT7dg/DlFuvqe27gFFtbXa+dKBgPYh2eOmsVQpa0bIF6wnoJ8r
	VU94Ozmjlu1ilWu2z3LkDFkrjc/Lr+4E8zSqx0e4d8Z/b3mcgPKWrSufofRRvBoP5lz5EL
	d4KcgIxMbyo6iUXGbqoH0n2THDXTpHY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B3uNZhzg1sjxzdG9Ht3OziDKfQqFRADRy+hNLst3GHeqsNu29JzU8PCqXml/d0IUFSXeXP8vSQpBwKoWObuDletd4WDIngk6wwRHhht4VKW9bWMVl2eCJ7ANJbMR/Im7EFpP52CFKW+5WpAuUEpdmxf/Ela1HwQuW22H/liPYgDrMloLOpig4wgIrE7ePnEELVggK2AWihpLGOl3T4rBGe7KkgcwtVA6rPuGTliL0eMNY8bCuTPwOHzo0W11K/O0Al4GQ6HTvAvJYC5wjcoCgCJIzq9Ndla1o6H2w8KqnsOVfk92fi1MZrX2dgGxJDpRhwEtNwBPQBZwqKMoQlOB5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
 b=xl6YJTvsUUxHQh95I9bRxqTFt8lv5P9ajAiccXB7f1JNJc0RK9KNROv72rIvh44JC2xKGX6sOKvfL1jSakvzpja0j23nG2ttUxYSazVYA4daUg9E5L4XemqiIqtNpnlkBf21cOc3CQ1ob4ECNO+wIC5XrG0RIBCsZpwNqPmhgi+lavv4usbyJNTfOogKHkuxB2TBKNMIpuVHIhtNfgPnxnzhErVeWOgCill4mVwGvLR37XfSgpjRQlYINxlKoUE7E3r6cFYcVfRreDcsYKasGHsBNlkvH4pub4Sp3Pka6HwzCwgRGglsRJxtYiPEeMhoyDVtiip+0O85ffvqvx5Anw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
 b=UvMOvGx5J0+BAvDrWXWJ5RCMkVzZ0TODeDUoGVo9dNDRe7LqYgw60CSxBLdauqwBYpjkJ9OQmMTTWfA3WIDN8Jf2CMTK/TtevaCRGYPCO4QvO3mTqPi0hq2FEjvdEZ9WM+XB0pJrHu05HDRL9YdAXoDlVDg3+BHAamnV2v52N3tVBUjkPyEcchwKETJ1Yol16w0OFZnfVoReH3v/fPWU2h3empzATfYeX7gn+FpxA2QYpvvr3TpGbBX7FyStB6BuUPeHj47i2iXpDZ5JrouH88gj9GEhckQBZJBO0HRQyY4Z0xBff4lYNlAW+QOLeRBgmmRc/E66ck0K76F42gj2Tg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9758.namprd12.prod.outlook.com (2603:10b6:408:2bd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 11:37:21 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 11:37:21 +0000
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
	mpe@ellerman.id.au,
	ying.huang@linux.alibaba.com
Subject: [PATCH v6 10/13] mm: Add helpers to create device private entries from struct pages
Date: Mon,  2 Feb 2026 22:36:39 +1100
Message-Id: <20260202113642.59295-11-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260202113642.59295-1-jniethe@nvidia.com>
References: <20260202113642.59295-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:a03:334::16) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9758:EE_
X-MS-Office365-Filtering-Correlation-Id: df7cc873-8730-4988-073d-08de624f6d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fhCIDwCY2nQuVlaqSMYadgJ2zOP3zAtTc7dIkh/NYspRW6MjJnL2Datjb4gY?=
 =?us-ascii?Q?uLBeVDHH3mTy4P86DdvqlNQlHlGJ0WWWF0B28PTcH8YjArduKKBzKHfSUL0A?=
 =?us-ascii?Q?24eNB/dx0TzprmFPAXgbooG/0aYV6MC5i8FL9/LvynkOTE2Lva3UvMV+zmsn?=
 =?us-ascii?Q?TlE032EVtqXUHd+R4cavZvF7in+jcDXu7IWItc6Npvzb/JPunR7X/Hm01Pq9?=
 =?us-ascii?Q?1jesxrmtHfJYOSC5vu37cDTCOX+Zyg7aNPwvKLRL3Qi03R9HCc7z5DKR4sXd?=
 =?us-ascii?Q?wV+3bNh1URw9aVSZ2r7mte9vCGFC9d3dnaH1a4pgSSVNepprjCnsoEL45vly?=
 =?us-ascii?Q?asexHmwrEOrhFbQNlNiHovJwquYR2HQOpH9URtaspmkSzxn7zmQatVFcWDNY?=
 =?us-ascii?Q?BAEkalCcCcQg2tsT2jzLla+qpNjIDEb9GWUr712PoYgOrVUPtcUUzDgJfo8N?=
 =?us-ascii?Q?1bu8317ZFE5B0RTD6lHs+uThjux6JiqpB5nrUa1hhWHC/ZXk8aeffIpu18X9?=
 =?us-ascii?Q?DzlqmkNZrH8TREMnGb9tqxpNynAowcspWrQvIvvRlyU7+XfYdSDbkUDceDUi?=
 =?us-ascii?Q?TMrdTbKhvjyxnWqDE6XPNObxy9Q999rZEuLD85nPaOhFdYED/Gx5E2YoijiZ?=
 =?us-ascii?Q?F+WcE8q7ZYBevMi3oSLqnfQYjPYLmrFeW9501K2FchnTffTzyOY+P/M+tQap?=
 =?us-ascii?Q?G/rBoHEpKVASZf1Pid5SItxSdlYm+tUZJ8K331uZH34gFFuIQjKy1RhfRcJf?=
 =?us-ascii?Q?1njr09EJiaVtG7JwKTH468EHFW616yLPI6stymBBvBup8qVyOXnMgO14Qx5j?=
 =?us-ascii?Q?7R9WsnJiesoLs2MWW8o4FTOlRosBABd11z77MbTGi+5+DSY4SGwo65nXH3w0?=
 =?us-ascii?Q?zmkjAlnISjtRnoSar0eE4Az8uWtxqGUayBeU0Puc0TI8lJGPgT5XB35w10ak?=
 =?us-ascii?Q?PoxKdR5LwudBRRqIGtvHQYPn2ZOuTQCM8mqa8K5bLmuKOmXbySaopk9Q9don?=
 =?us-ascii?Q?BvvjorYlszD7Ngb7yS1rwLxr9y9K3TkF3u+sye/rkKum0rcs0kjyWYeQVCjN?=
 =?us-ascii?Q?ZmH9JuKRTRZhxDQEJ0+gSkMR48xSHnk3vM5yYoIIZ7csA9sf0lxUuh5+5o2i?=
 =?us-ascii?Q?kSJjdpZzQtjo8c2gplYALMxg6z4uN3dgKRwUN901vWfPSZFrKjGHYCOwzLi2?=
 =?us-ascii?Q?H90mFGYgHuCC+mlv7Vk60AGlS/DAP08zV/5b1skuHXM3I3T2YWDyzlHI+deS?=
 =?us-ascii?Q?QSpLdVjJ6PKdgUy2RyNfxSVZCokaGjgGumcWII2LEEbT6SjFL4gmrflrQNrG?=
 =?us-ascii?Q?vti2/2/jQnQ3xYTksH1MVb2LSDd2LlcGqplMLYKXCafphcm14lSAmyh9hO1y?=
 =?us-ascii?Q?lBzynbvjbJ3jpBhKnD0L1OVuhCXo1TL/1tDadQh26TZ6fMbjZYOHZG0K3Nyc?=
 =?us-ascii?Q?oHU2ehkx2BmlQaWxpCdTYYCvMPM1jLeIohwsu2wd5pI/IfMRe4uH15udRgFe?=
 =?us-ascii?Q?uvUK6zC9U1iuX+zcgLWwDnMzpOtjTa6GzhZfnHLxCBuGT9iuhR3GjxooUiB/?=
 =?us-ascii?Q?JKlwc5vXrUtCk4lC/I8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QXY6ZX7AeXi5RbeTb/Me3IxNo3qzJxijSjOl7TiR6B3po4vLm2voNIrI2EuK?=
 =?us-ascii?Q?+uAq0CX8hhrzFqI0u5F7wJyNqqbp595JVKWzSQSjBeea7JnuPQr2c6Fg+E9X?=
 =?us-ascii?Q?EF7vv6gLju8kgVSNBKeVyQIYY4otW9chgwzSvmEMW3KGQaspkMs3+x3zedEi?=
 =?us-ascii?Q?J425j2jP/bw/++uXYcWyIiWiRIFiSkT//NLd2nV5t6S6U2e6EFdHfkeMRflz?=
 =?us-ascii?Q?E4R+cdyrn7doRoZxakcqkWcc2GCGl2PleHdc4kINyYc9FVHMNWe0JEyH36oO?=
 =?us-ascii?Q?USJPJTjHXtqVxIAbtdGPcO5//dM61QxTOKtPO6LoqZLH/uobviwwl0fHYVot?=
 =?us-ascii?Q?N6A5tcg6/vTkJj2CpEzNSYG93rK5YlXSuJUIOzbGek3MFeMxBVioOqmPsBpk?=
 =?us-ascii?Q?GmHL3uhAQAZhUGT3KQfLewUecErtTKIVrCjgQegMDv/c3B7gEa67EB2DAHyW?=
 =?us-ascii?Q?kfDrNQC0SgjDsZFZzt9+YRkB/h9aNEplBBI8pBbPMgjNPjwHd46y3TPS+jiY?=
 =?us-ascii?Q?CDgoaCyYhtjY/S13KFEiUaSkLCKrg8PcnXaS8bqvlX2+fMDsN8ybJiIcH+Hq?=
 =?us-ascii?Q?tNx40KTwYZJaFHuDHMu5t6eMKT4xb9UB3t8nVE7PqdVfxbcOtQJ3UOu8bL6+?=
 =?us-ascii?Q?6vCbZslaa9YSOP6eGPBCSfXlk7ah3ULn4+FsGuxRxOTBHZtqa3+D/7GKd5tc?=
 =?us-ascii?Q?DcBxkodyxhEVXe3N65L+K43FuwRCc9hBd6ofS93rwjGQ5x5uHQSBhfmyR7ZJ?=
 =?us-ascii?Q?DErHgbBEvbJbwqm55kzmIsXpa09Qmxnw23PSh+mf4tllfiZ6oP3DDvsYsgp2?=
 =?us-ascii?Q?/T6M4TOMnL2aI4dYE+zpILchfemnU8nDDASLVASc0GGtb9DMHK1s4vHqKD3S?=
 =?us-ascii?Q?ySmnFWchy05+CajIrXFF9CeaW4d2eirwEHXIBogDhHukQ+CIZYP0SlJW4lsz?=
 =?us-ascii?Q?tNCN/LpxMOCi5RjobUt4wzvB8jnSdE1fyfYEVVh/klYQnFSoGUIuaFXudTLT?=
 =?us-ascii?Q?sZCbVvc3bAb2O4gvV+PlldUf4T+O9Sx8b+Cw4/cssYY5cgCP/kN9zafKiFEy?=
 =?us-ascii?Q?LRcqmkGaKDOykLlxArfSwKl/DGmh0D+rN7WhFE00MaHV3AfniTp7ME4FdpRk?=
 =?us-ascii?Q?K9euIyQcEwCQkysw/Cs9XW7OJ9vFZaFolFhP/BSHk/75RqdzfeOFVgNLD/VG?=
 =?us-ascii?Q?vsamIpOo8SLVO2ZmK1tqlQd0vp9TDChkqnshYZCccNlu+yTOvP2387b2tdHI?=
 =?us-ascii?Q?gsPQE1L1F+crDTtfW7mHiy5NnfOqfLN9NZVT6X+CxlFD5m6Nxhm/nLnaTLab?=
 =?us-ascii?Q?BfPS04srYqvzHre0e+Valxer2J/KajYVKIQlUckQ8hLMxsXeOF2ygmiF9dfb?=
 =?us-ascii?Q?MP0iFXT/1dBIt0UXB+zzDP7fzWloPaEstxgIAEyx0a844jNpT95CkQAEaWLG?=
 =?us-ascii?Q?Br23JQQ7+7YPq27VcxPT45hw2V49CWhyD/XPQrsKG6oVxZjvNndR1J0ZVkL8?=
 =?us-ascii?Q?VZj6DnSlnsY5g0kPOpHCiAAS90QCsAs9OY+xbK3PvBTjN2RxlEMUDT4rmHyc?=
 =?us-ascii?Q?MDSP/aO3gy4fV/cGVSbjEDCQE2+vPQQg940QMKQrstiKPLf2putcMo0QW5Cz?=
 =?us-ascii?Q?w9nY+hvupp8kitOGJZrB3Ol9fh0Skj3hzF1AuwefeIUVnFva/N1DvVGuaWwg?=
 =?us-ascii?Q?4MQGRhnzmsFzd1ToXGDZ4yaRfIaL9s5IQPY8i8rkzy2Y01Ko//F1B963Ya3I?=
 =?us-ascii?Q?2X46uHYzCQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df7cc873-8730-4988-073d-08de624f6d4c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:37:20.9917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nky1ps7rImkiK+pVFAqRsOsauW+fhefJ0W9DI/X2YjR0waa2MpGFenZb7w2mSlWZFbsbNzNQBKKXabCDxqMNAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9758
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68C90140007
X-Stat-Signature: b9rebegdcnpf9ihfxzwd4t1n7yhxxp77
X-Rspam-User: 
X-HE-Tag: 1770032371-296283
X-HE-Meta: U2FsdGVkX1/oZV5VLtJylSXEZUGl2q2jCusmT9Y84w9QBnFyNV5rteckENExqQTC1CzwEy1gU5sH79JUo/1MfVwVN8AkAsfoldeworbtevfyTrhFaaUI93IGzxHA0Cl06vMCEE41PNLPxFmW6oHq5lN/m4rj92S+qQNh960QtZf5kjBGB/VltzRWEP9z/6XUV54qB08fgB0u11wdVhk3420bniSDijnnksBaE4XvyzFbwhE5j4XhVMtKtEN6lyNIEoy4FL+BW3BxzKWAKOcRJs0Uvqh32k/VuhrAmCnoAx3rERF3HpuSpDH90aNw4M+Z5ii+qF4icenQ5Idr/6imKnUNg/NVkTzPk+GWqdEdDbndB0aOaE4IQLgc9ulnGzZU5GuewaUxhPKyah8nKHl0CCsl8viQr0cs9bajkqWmX7b2qNzxg4G/TXnPOBRjFsssuMLHzVwCFy6y6yOV1GvU3fHd35y6p1E1/k8rZVEtqmrLjnF8/YNwkaoZw6s1durONIa8rxJP1rpsHtKbB9tOksjasHkZnmFYQ54OVKsFkE3F1/P+BtQ+GbfPW03GI8OMOBkeP+8hDU/KDoncMMRam9VN5ZVryE2xcjkN8TCAn5HRntnO71lIbVS8YlldH3qEF0u+2HSw/Us0zHQTP6AfSKyeS+TSUK35EoF1uHcZuUugiLWEtIa7pjrpRwmaDPEwWqMMYnW+/FrPpihblip8HqJnvut7ReXSNpXe4SOlexFT72c0i5FVChS01k2usV/bwQO7frCdelBjOR+fzwpDANreaemUdbOakQ6rf+iBblhyCY9uTFq7QGwbdHAuyv12t9k9dXwLj+u0sPG6zsh0ojDSBmys9qmfius+Jo3+zYOabAKjpeepUwDtBG2oZIWZ4nA436IBfNNfg2TEZt9030372V+oTxcSO+H40v17hA6IpaIUkxijHobaGtBCOeySIpx2pShIO+rmPsWq681
 DlhKhbtr
 l1sVII8mGp6CRbqwdAS2cDdp6ty/zUnFAdD7uJYfEqZnKr9Y8wU5dq3dKXemXcr2okST6ft/y4DXksxgWUMHrnyzypEMpFOmVIzvl2mYu3FkIZ166Pvu6h/u3bfu3icMcZMbttMRbqzyXSHuW1uzH4shVoZbNo7hUM0YdEnItrVNHeHt8vPomiiSJbbRG1wlaR7E4Vp8Wl8A1Vm8zf9ZLqRDjrfsi6O71s6hXVshOAmQ9I3H3iZ6XycE7AJk7FrXT08pKPIsu3qznOj2grJRC1/PjUJbQDQjOg7aH166UVRmjqlyF0WcVnlbEVfPOTf9ZrrvRI1nvTb3uRv5Uqn5sybrHckVGG1SGg6mytM2DAKmKfIOykYv5VjC4Z1dVfNsheXxYPOHlTTTYEp2L8S350n02V74f2js2o70q+SKYEDZ02hKDy9LkG9KJKtRDGAL8H/7d57JPjmS+iDpxXPbSSrelz/1t563SAO0kXhu/WEFRbsYSef1+tYB8QcX7JGU/764t4njSfAImTcvdlLM8rpcLKb+95bXnHLld
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To create a new device private entry for a given struct page, that page
is first converted to its pfn, before passing the pfn to
make_writable_device_private_entry() (and friends).

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn and must be handled separately.

Prepare for this with a new set of helpers:

- make_readable_device_private_entry_from_page()
- make_writable_device_private_entry_from_page()

These helpers take a struct page as parameter instead of a pfn. This
will allow more flexibility for handling the swap offset field
differently for device private pages.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v1:
  - New to series
v2:
  - Add flag param
v3:
  - No change
---
 include/linux/swapops.h | 24 ++++++++++++++++++++++++
 mm/huge_memory.c        | 14 ++++++--------
 mm/migrate.c            |  6 ++----
 mm/migrate_device.c     | 12 ++++--------
 4 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8b39983792ea..080e27da6b47 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -138,11 +138,23 @@ static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 	return swp_entry(SWP_DEVICE_READ, offset);
 }
 
+static inline swp_entry_t make_readable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(SWP_DEVICE_READ, page_to_pfn(page) | flags);
+}
+
 static inline swp_entry_t make_writable_device_private_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_DEVICE_WRITE, offset);
 }
 
+static inline swp_entry_t make_writable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(SWP_DEVICE_WRITE, page_to_pfn(page) | flags);
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_DEVICE_EXCLUSIVE, offset);
@@ -169,11 +181,23 @@ static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_writable_device_private_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_writable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e3a448cdb34d..03f1f13bb24c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3219,11 +3219,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			 * is false.
 			 */
 			if (write)
-				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_writable_device_private_entry_from_page(
+							page + i, 0);
 			else
-				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_readable_device_private_entry_from_page(
+							page + i, 0);
 			/*
 			 * Young and dirty bits are not progated via swp_entry
 			 */
@@ -4950,11 +4950,9 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		swp_entry_t entry;
 
 		if (pmd_write(pmde))
-			entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_writable_device_private_entry_from_page(new, 0);
 		else
-			entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_readable_device_private_entry_from_page(new, 0);
 		pmde = swp_entry_to_pmd(entry);
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
diff --git a/mm/migrate.c b/mm/migrate.c
index 4688b9e38cd2..24e3ebbab1e1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -399,11 +399,9 @@ static bool remove_migration_pte(struct folio *folio,
 
 		if (unlikely(is_device_private_page(new))) {
 			if (pte_write(pte))
-				entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+				entry = make_writable_device_private_entry_from_page(new, 0);
 			else
-				entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+				entry = make_readable_device_private_entry_from_page(new, 0);
 			pte = softleaf_to_pte(entry);
 			if (pte_swp_soft_dirty(old_pte))
 				pte = pte_swp_mksoft_dirty(pte);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c876526ac6a3..0ca6f78df0e2 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -836,11 +836,9 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
-			swp_entry = make_writable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_writable_device_private_entry_from_page(page, 0);
 		else
-			swp_entry = make_readable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_readable_device_private_entry_from_page(page, 0);
 		entry = swp_entry_to_pmd(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
@@ -1033,11 +1031,9 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
-			swp_entry = make_writable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_writable_device_private_entry_from_page(page, 0);
 		else
-			swp_entry = make_readable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_readable_device_private_entry_from_page(page, 0);
 		entry = swp_entry_to_pte(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
-- 
2.34.1


