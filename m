Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B15DEB28CB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91AA6B0099; Fri,  6 Feb 2026 01:26:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F886B009B; Fri,  6 Feb 2026 01:26:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE93D6B009D; Fri,  6 Feb 2026 01:26:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98D936B0099
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:26:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 421238C4C7
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:37 +0000 (UTC)
X-FDA: 84413048034.08.4EA1A0D
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010046.outbound.protection.outlook.com [52.101.193.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4268B180006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=E52GP3tS;
	spf=pass (imf24.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.193.46 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770359194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsZZ4o6mRj0OJ0EHF4vm92cMxvD2fFY+PNgD3TZMx5M=;
	b=yZIKUfmlXndWCDwR2ni5dCQqKO/TIeZ+ktqfSdopnYw8q3mVuZmp5Ku3Z/OpGYq47cktNt
	eSVN3AGTZB/wuPLpVE3Fzzl/q2WnwN3lBCg8tRq/2/vlH9CKxHZNPm+Zd34DzodQDnq8ig
	GkECcv9AP2Bgy5N3oQxukirjYJkkwNo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=E52GP3tS;
	spf=pass (imf24.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.193.46 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770359194; a=rsa-sha256;
	cv=pass;
	b=I+1TC6J7i4rdbiLS5msUacfOf/+DchuqZil/t/7mfDe5oRL/weSCTps0F1GWSpCpz4njOP
	ve/dHwxW51+WheM0ugMRojWJwThbt4c7FxxvmTki5m9Xsf+n3ITzF8aoDI0EjuZRYoxEgE
	dHeelWG7dZ56BMHk4GqdPn4AFQcDF88=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QAjfVgnRwnfM5e6AHKY4ubbxvgYbhE3O2DbRUeMCIntsstZ1l3j//l/VG3A9IM6KM56OVgiRszqPua0Hnv6xhGH7OyxkkwIJxJmWV7GOXGTlfPtTFhS3XzUBZzJpBanezQsUozsN0zEzVMjWjsMD8W+JihxO3FtholGxRnmxgcW38DNr6CZ2Zzs36Bsk4mRv+htvcSzsKasYrP3fpPrAZrSDidY7qQA8ycdn17HU5rPr2BrNo62EoXTGnf6tGLzcrQeWCMS1dGOWWuEJc7NkcYMY+IV+oGDOk7g00hhwZz32qgIO88lYCNoCXjV1u3HFgTKei2pQ+FkbSurZeLcjcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsZZ4o6mRj0OJ0EHF4vm92cMxvD2fFY+PNgD3TZMx5M=;
 b=uAzwhYRnV+/GTMWkwe1ayay2eKch5oDqWyv1/dx4IxhvqxUiawDbLOE9qAGlrG59YhXo3E20IXxuctY0SocPJ/SOwesX23pnHQe7yif/laoGptLFQ7XXb+3oWkk1CrMRAwJkrfKB57U2NQDMSSSgteL5A8L3Lk6xgkm8HXa0PTfYj4cJmjAMI7oSyPNPREdbEY8F6wFy2+NoZEs9P/94ihFHCdS5a9UkjuD6AetMp09dM3WMDUpQGI658vPQSqvu+NwNc3436qflYUIf8kdntjiaMrueo3jf1wxkRfa2h656Kv1Gvjy5wIa8DpwaHokwOcABelxwCRkS3kspZ78pWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsZZ4o6mRj0OJ0EHF4vm92cMxvD2fFY+PNgD3TZMx5M=;
 b=E52GP3tSN+aPhhBV5EacrOZ1LBI9K116Mqe0ZPoMmR1RsPiO0d6okFp42pfeaj9UhYSu+bYD/oGS3tRF5zg1P5gQ/m5s94yWTHkouUyLuskyHhTj/euVb8krmSVmKyPdrb58t1HK3cIlkPpjGzreXxbfGGgvxtwQv5YmKEvgsqQ=
Received: from MN2PR06CA0024.namprd06.prod.outlook.com (2603:10b6:208:23d::29)
 by MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Fri, 6 Feb
 2026 06:26:30 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::86) by MN2PR06CA0024.outlook.office365.com
 (2603:10b6:208:23d::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 06:26:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 06:26:30 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 00:26:26 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v3 3/8] drm/amdkfd: Implement interval tree for userptr ranges
Date: Fri, 6 Feb 2026 14:25:52 +0800
Message-ID: <20260206062557.3718801-4-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260206062557.3718801-1-honglei1.huang@amd.com>
References: <20260206062557.3718801-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|MN2PR12MB4358:EE_
X-MS-Office365-Filtering-Correlation-Id: 304e631d-d894-450c-b010-08de6548aa63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uBYYNF5W2hJOHl3vSPtjJx00DxiKpqxVQ8QqsUmYom5v+/EzEAqg0jkeFBac?=
 =?us-ascii?Q?KjUNqTIKemLPP+rykGj1DZdKaedfA+5sZtbJbSZ2YsJAPXqyYbYUDuxSUe9d?=
 =?us-ascii?Q?p0YJ2SCfsbVaJTaQ7kU1uipWwQ3Hv3nDITiCBDznN3nKs25NpUxwjI0YvUqJ?=
 =?us-ascii?Q?di7YfpXoXp1tz/XLUegh2Mdb+O10YwzgUZnwKMst/QHpJFkEiVX40vUOCPkn?=
 =?us-ascii?Q?vMmLmZW3kFkgZKl+rg6N19n4F6lvULXQs3e2S+gWLy/Ay+cvgE3NbLlFxss3?=
 =?us-ascii?Q?SaKOZD6TC0J8rLK3kGxoBHTIcSrIRjO8chFRyiDDk9GKPJv4vu+4sEBr8cgX?=
 =?us-ascii?Q?JzKoit+HE78BqypoxflE6fgF2xGZDweyJey+dLAmZOePjXca6UvKqSSqmH8D?=
 =?us-ascii?Q?IHSAmU1x2wLGUvquKn1elLLG+PFREJvHFY6eaoC/PIAoWfhAb8VwIUGz6lZo?=
 =?us-ascii?Q?wVBALdJUetSf+7eYuUhNuZb+zkoiS8FZRl0jwEWHaSkEVZXtbHzp6vmArm0K?=
 =?us-ascii?Q?bpa06ryKCplK/7RudSvmoJulwlYx/GKb0A6Myy3LaaRf+52X38a7X7rsuepD?=
 =?us-ascii?Q?+JBPNdNKCm9qHUOwmgWSc0cpucTai0lpDhFshALOR2wrh97y4QbLWiXxEOWh?=
 =?us-ascii?Q?3p467LUl6WjenFsiOdNyS2JutT1WImH5Mxt9YG+thpyFAMCiQMtiRQVtpZMF?=
 =?us-ascii?Q?nu5uUPXeEZ7Yeb6lYJrko8zqiGQwJULNajh1cfim5vDEzOSeLQbM4waszImO?=
 =?us-ascii?Q?H9gMxXKRckcvZmnfjzgpQt5AkDBJNUC2koxWnboxUntShcoKR5CCWIUiOXPE?=
 =?us-ascii?Q?GBe7PzcYDxo7VjzdZjNdij0vv6xnGBjkcTidF/JL22AQ2Kg1DPKfcU7OXtZt?=
 =?us-ascii?Q?mFK8QC8A/TdOivmV3Iqi20e9XPABqPapX2I2uY94regk9uBUub2Mz/3R1KD7?=
 =?us-ascii?Q?FJOOBn5yujG/BJYi5nnlvx7p5BbEaprvbIKDUm3Mb0eguDA0v4s98PVQO6mI?=
 =?us-ascii?Q?Ex01K7ftkMRMsWz5tFGf1QhetA/ZXmO6AIGcg7VMj1YSo1wHv6vHY/eZlHYV?=
 =?us-ascii?Q?R0FmBUXhmB5bUG9tkbERESCmDjLaS6MajE76b3+QbOEqlykq5ScE1BQQTm47?=
 =?us-ascii?Q?nlXwVVGvswO0eZOkkdiobxp2g3rttpEhZi9mnZyZX8fWWNhDQ7Am1/ERjY30?=
 =?us-ascii?Q?sKZRhEUxi/nKG+8gqct55xHJFT9my4x5dFrC8v8hDRdR3+iDCrDarxpaedHI?=
 =?us-ascii?Q?rlJjk1xMT3yWFpX2QLDXkCOsR1jk0r1WHlRJpMceb1YrW9RWjeP7Q4O9Ly74?=
 =?us-ascii?Q?79y2MLW0plv97YFddFouXUPmpQzuQuX+DLbP75TM9xcaT1wGl7VzRGIGjFH8?=
 =?us-ascii?Q?uvqhg3Ql+nMAJsBgd/a5trEZv3w3141csrOZJdAfjGrlJwa6pcrfm0UH+02p?=
 =?us-ascii?Q?1IvZCFDpg7ftbwyhgJM3JqOafb7IcSYUXs+SKHtNrkWa/b67ZRANb5+iBZMm?=
 =?us-ascii?Q?CkYpD9NFMQwuXvN24GEi7EEzI4FM2IVHlHbR//5GjyqVug0Lglo9jAfVCHnG?=
 =?us-ascii?Q?Ey2w2fc4r93EsLwoU9KP6VzhoLdc7c7QCDJaWAIMevn8X+eh2HdNap+A7gOK?=
 =?us-ascii?Q?Il6S1iMomYYovAd63xGou6HaTditMjlBFLQZW1M9w2Kg2oeJaThNwq3IPxeX?=
 =?us-ascii?Q?EFmh+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+EKnwzOSxvealA/2HtYHgUKACMr9U75OFFe9hvrRWqeDtgJYBh2xfAnEUrHYefqrvIAHP7FozOAGjz31l3RJd0KE9jV7Il50fczNV965MFnaD07yIskbPFbnBt4mds2zUw35882aAoRsiP081g6EYul2dgCNUokB/Df9rnbcEOqW1VoaLkBj8whdr+7iKtLsNGutouMAxd0FzXjRRalDO7db4vzdKo+k7p7bbK9of2t/Z7e3v4gLxusfPRrMZWxOrNJyec4hlzloLeTwylzELEeUQhO2mXNpiuYQ6J/Ew6gRVmJo7PQf7g7wyjfb+KPJmUwAhYCHduRDzy9LrKGxJxmgQxNv7iRW8jVrvKZG5m098gHPx0br14lwb8TV1aoNuMXF7YUNrl3ua+rLb41ndJwdNQ8aMgEUCmLM1ZPFZ+96R8H9AD+iNhpa2OF3xY7F
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 06:26:30.3461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 304e631d-d894-450c-b010-08de6548aa63
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4358
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4268B180006
X-Stat-Signature: rmpe34qew9mrbzqmqhc8fdrtdou4mxje
X-Rspam-User: 
X-HE-Tag: 1770359194-302890
X-HE-Meta: U2FsdGVkX1/PTWQ10XDgLFSc4/gCKGxn5pG2OIf1rD2FBsRJXruAFG8ZJlpOTcwtDLDbRe5RbYWPeSxBU4Xutoy5paWpFsTGMZ+szLit6W+5KgHJWwZqUMyyiilCmbjw1bYCMVPEWJElCwHGcStI8E3x4Fx58vfOiGEngI8LnJwDp/UOmpvs96wpSMbvgdFe+Nyse7v6GzD1T4UIJb3qMp+yCErY3VjGctJoMUMcjO7uW5VAm6uGRKMbCpbeHVXVDGbb9+KUif5PaCvTseROLhp3s6KODIgzJPqlOD6ezC+lX3TkXx0JXud0o2Vn1LWkuTp9y2FKS+L0MwJnlGj6bYCyPDfYyS/nTIblKpg42jgzUn5ZKWxgaIltlcxBZL1DYklZyx9F5a6jPqdwq3fr1CmoPQlxa94HU762D9tcgN6Mg6F7bsHVpnnwFCf3ZflnMfZYm1Ky2rzdJ8jWfYbdJs53f4STYXdPrRNZJvou4I1Zw9UEZt3StQX6rfHnv2YLP4XEutU4C/XrMbfK6PQYk/7RyZYY4NiEBc0XpuuR5aFvNRrN3EFO1sJnIrkW0S7XL2pWz+ReW3AbXTTQixJChDlOlU+S86F6sdid5BMZMhcBT+mw4FHUXpt66R4HTIhePfu6fZ8UhL9stvJjhv83LMwCDZPgoUklbfZ21EItB6FH8MbT17Fum9TnG2jLXaFiW3mo+oMrbqWz5wTBPqq9rxg7eg0dxToW9GryZQF6a+ohSUQBGTJxYIVY6uVQm2S5aAfkeRHUGmB3W/NwNo9ZVjNh9zSXBnNVAEMfpbSbw1eS1no/JRjyDuc665JITy/lQpWq9jgAk4RouZb7ndoNVv9lpe25uIcT4kXDhs/L6qix3P2m1EGtz4tSq+itYdZ3BnE1zjfI973W29TCUEBupVLBqRqb33Tkm0xiHn5UVUmpWkTlHiLBv7SqgYGxSanHj9cAshW42X7/zcJWBo6
 5erO7HoD
 xairwSKoj94y8+IqngPtS2KKGNnosgb3W096dZ5PY9Aqzjd9smZYKVsbEjrTpN9URU0hirsVgn9AEpHmOgAcuO146js/jBsf7+Ioo9zoW+ZRO2lpv1hUWxjir/7uiuxMImrAGWJGMcBY9uM70OUqPNuD7zH6edE7TpiDioE5M9rlwiKjwvmmlg58agFovL9tR0U0GsAHB+8hcZWoYSIPO+4Ux8/03N0Gxf8jkHWHswu22YzlQFjr6lcWFjhO5LsWZgMrPziBdqN2W6s7QPZG4OJs1PiTYomjkavmreXQDGCvG0J2NrKkvkvv/KXbBrTPovOd0qr7auEibfxPD/B4Hzlaf+mAkbL9iDZOSgNm6ojPcFvvkcLLyYT8d+AJbH1R2bf7IDVOpz1Id8SVZNCuBA3/D65iI6hCexhhpoekfk3Q7pWKobb8pm2jmycmhhem9AIQw/YonzNhvnJhD9Wts22DC9qcNekr8XL8Wf0lW6LKiAjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Add interval tree support for efficient lookup of affected userptr
ranges during MMU notifier callbacks.

add:
- Include linux/interval_tree.h
- mark_invalid_ranges() function that uses interval tree to
  identify and mark ranges affected by a given invalidation event

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index a32b46355..3b7fc6d15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -25,6 +25,7 @@
 #include <linux/pagemap.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
+#include <linux/interval_tree.h>
 #include <drm/ttm/ttm_tt.h>
 
 #include <drm/drm_exec.h>
@@ -1122,6 +1123,26 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 	return ret;
 }
 
+static bool mark_invalid_ranges(struct kgd_mem *mem,
+				unsigned long inv_start, unsigned long inv_end)
+{
+	struct interval_tree_node *node;
+	struct user_range_info *range_info;
+	bool any_invalid = false;
+
+	for (node = interval_tree_iter_first(&mem->user_ranges_itree, inv_start, inv_end - 1);
+		 node;
+		 node = interval_tree_iter_next(node, inv_start, inv_end - 1)) {
+		range_info = container_of(node, struct user_range_info, it_node);
+		range_info->invalid++;
+		any_invalid = true;
+		pr_debug("Range [0x%llx-0x%llx) marked invalid (count=%u)\n",
+			 range_info->start, range_info->start + range_info->size,
+			 range_info->invalid);
+	}
+	return any_invalid;
+}
+
 /* Reserving a BO and its page table BOs must happen atomically to
  * avoid deadlocks. Some operations update multiple VMs at once. Track
  * all the reservation info in a context structure. Optionally a sync
-- 
2.34.1


