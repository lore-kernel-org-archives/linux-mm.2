Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DCEDC5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414506B0092; Tue, 11 Aug 2026 07:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB916B0093; Tue, 11 Aug 2026 07:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9F96B0095; Tue, 11 Aug 2026 07:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00E5C6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:41:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B9EFA2246
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:41:38 +0000 (UTC)
X-FDA: 85088798676.17.0B7FF56
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011039.outbound.protection.outlook.com [52.101.70.39])
	by imf04.hostedemail.com (Postfix) with ESMTP id A4A6A40005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:41:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YzaxApfY;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YzaxApfY;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.39 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786448494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUaKL+QReNhmqPgsNF4Dqp9431sbjC2WZS85Tyxj78I=;
	b=hUpgNH0j+p1JFT67GZ2VH8/qTOi6/wwMsnhULp+O67UzgvJhO4WC2KnCQrEFP79sKnfD+C
	ASB/wCuIJ5KRK9M/u0sknBIJ1ST3RwO2BMk8KRyVZyFE8zcVJ9cV1d4K6s2Y6ylhIOE68i
	EXqIryTXo+p1pQOUrnyrQZKuASIYgYA=
ARC-Authentication-Results: i=3;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YzaxApfY;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YzaxApfY;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.39 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786448494;
	b=f9IlkUUuYDtbTe1QgmRozswtMKOktCANMj5zz27nuRdXHJE3yVF2/4Rca9jjIn+cjvtYOh
	PZe1w3P5VVFxkfLWpQEqIeZHi+J7GojhDz5uDAs4Ob5TyGvEIlTDS+DSG6h5iBds2tVFAV
	Fss1iMyJ8fBrgo179gWn/P/XXcYwWPw=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZMEu51GW2TN5qXdIGuA51bSL6DbBhXFhgbq1vJmYYVBqh4IH8uQQMDltCw52QBa5TQriYacBP+aMtq9nl5bVStk1nXvZihUW/OjJAlOxKmFVZUzBCuqkaorDNDLYNzyAyWSyTdVwWrlGIBE2AjG89/HIbEoxDHeUP/3hvWKTnM+szYaFouv4+48lfAfkAi+wTu6hf+QI1Q8xaUd6tD6BnKBkCZA81fHLFYpWBo2poxCgc0KNft3aYba/pv4ameM/6CQXOQljOtGzz33FlOV+V8rnPUHjOS+XDt2yDueCQ3QUtWP4W0zX9EYkvjGdN/PT2sXKvN+1swLdp9US9ux7GA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUaKL+QReNhmqPgsNF4Dqp9431sbjC2WZS85Tyxj78I=;
 b=kn6REFrDs5BBw15Zwt+MlXRkfPjz2pu0gr5M2cF5HJY05Nl9bPnMNh7KXz+vppJYKn9xqakHI8Sj0M6LLcnmagNtt+lasjITIop6Vapkr2lGbM8/ge5xDDW/SV8esY2ImGyhe/mtQA1f0obE5+o++ad74rqT98GWRloCnwdTI4zoYSknv//uncykqb0zs4K3379RIA7ZiMjlAvGWIVggqqt8b32Qgt82926TWHVeWQfn5UVGsr+aC2ho/sAw3SJ9DjxSeHDp9IMIoRWt44R2gQzf4OreyNuVrjC8cj54cDddHh5wA6vLluigicLsXx3+eIsfGaDJhj0mIWp/195zmA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=shutemov.name smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUaKL+QReNhmqPgsNF4Dqp9431sbjC2WZS85Tyxj78I=;
 b=YzaxApfYzsWPyaExSqmQkgBrrxUrOnzeyRm/g4kCE+5zTe4MVfvIn5RUCIYM4HUeh/g1BkUstsfKD8evlgJDuPRvZ4UKzjUqvDYEM64VP9RqelU5DYv+furc+oNzJYqNqogqHzFFvGeP3hg7j7DzM/RP8XwDHcow+SZS1BppMog=
Received: from AS4P190CA0060.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:656::13)
 by AS8PR08MB6280.eurprd08.prod.outlook.com (2603:10a6:20b:29b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 11:41:28 +0000
Received: from AM3PEPF00009BA2.eurprd04.prod.outlook.com
 (2603:10a6:20b:656:cafe::73) by AS4P190CA0060.outlook.office365.com
 (2603:10a6:20b:656::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.12 via Frontend Transport; Tue,
 11 Aug 2026 11:41:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA2.mail.protection.outlook.com (10.167.16.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 11:41:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTNhLDdJ0zxuXHstKq4823vXLhjCxkM8ZHVV6YU3qNRQphx+8JYL22PNAYJuLheE4N822023VRxWT2+j3X+nCwucxOa7Jdz3WQZy4F+BMRRcMk7ono13/wOH+ctM0ZggXWelK7eu8G6xg3sRq1VBxXZjwNTyuCg8l+zSfEfuvPGvGMxM5H86zUE4JQuNq1chEApPviqhsxNRlfCgOo/F/HhvA/B96EWTBs62IADRK8NrVcayletsABQIXDQGzTmfFcWB1LU9wuT6vQEP5gWgvGR2YKlVXwqyXD0cLwmt9Eo/iTec6YiaOe39Mz3PdomvU0gv9Ms5Ko68QXlK1+lx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUaKL+QReNhmqPgsNF4Dqp9431sbjC2WZS85Tyxj78I=;
 b=FF5UtskSbhCSnxV1ICUHMXVqTPkNADTevq60abisc18NZNJ+WWpHtS/kjRyXRxB0yHoE9AVX9We922mfdtZKMrqnK8wMP0LMqCnHwR48eLG0Cy3cbsMFCS32Jxf7p9nFNbuqRlbnA5Mn4MoM0RXLzVyP49Vs2OEX5H/S5kfwFB5UbBQFCNuwM+nM3dZEDC6Ol48yx9mkvOO22E+cSqonHxNs4KcPRDK6VDh+OC6Mj0N/xxYbdgNhQeAUaM2ZU9YaZBlrQ1bLmiLXz0xs3PrgY2hLxBS64iCUfGpWQCAAo9AMjuDdN/GqaVCGJg2J3YVwPhE/R3PPFBa8gImX39gwtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUaKL+QReNhmqPgsNF4Dqp9431sbjC2WZS85Tyxj78I=;
 b=YzaxApfYzsWPyaExSqmQkgBrrxUrOnzeyRm/g4kCE+5zTe4MVfvIn5RUCIYM4HUeh/g1BkUstsfKD8evlgJDuPRvZ4UKzjUqvDYEM64VP9RqelU5DYv+furc+oNzJYqNqogqHzFFvGeP3hg7j7DzM/RP8XwDHcow+SZS1BppMog=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DU0PR08MB7639.eurprd08.prod.outlook.com (2603:10a6:10:320::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 11:40:54 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 11:40:53 +0000
Message-ID: <e1364571-376a-40c1-937c-40f68b06b09d@arm.com>
Date: Tue, 11 Aug 2026 12:40:51 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev,
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com,
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, ziy@nvidia.com, agordeev@linux.ibm.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kas@kernel.org
Subject: Re: [PATCH v2 00/17] selftests/mm: improve khugepaged coverage
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, nico.pache@linux.dev
References: <20260807113647.3744609-1-kirill@shutemov.name>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0199.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::6) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DU0PR08MB7639:EE_|AM3PEPF00009BA2:EE_|AS8PR08MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: 169e4b3e-b64c-446d-eca0-08def79d7b47
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|56012099006|5023799004|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 FVvriFX0pDvCv3KK4WDh+kt7fc5guXQqE9IImJ4Rzy1sDUuQ8MFoDg0nZcSIzwC3dxqAw2a9hbIWGylhCC7lVbiEIhTmuRCUFA1gOs6yR7ot8v6IoOEidTW6X96O7dbW4Yo3chq2uAQNKGaYFp83YOJ7pb9lv7o70NTiqoy9p21HGY104N1tPJEhPgvTSAyF3w22Te2ydA84DR5fSbBIT4B1GPr+eSj6+ilV6MPt2C6XMgMHEgcEAR8S4KzZZnn+2Qggv7aT76P/Svmic7l5w2DfJwJWH8b1xvYsIVoE9z3CkloCTo+yfRBV5fgS5EkrGaQybEQGXrfKtbkPTa62pNX3RHGcrijyI9q9dxFQgiPSAZ6Y9JTj3al6csrP/5IPnMYBJMvmUU3ytr7Gu/sTC17ejlqwVXI6s++suCPUYgSmSAbGtzzN90Q4CI7jaRPrjqxtcSVu+Nd1B8aVAleoBXJmt+k9wclO2RxfLrrn7gKV45W3yN0H8RR0CNOnCIlyfQQte1xTyV+GE9nwVXrpnyBNKOolNc/uL27mF1fYn+YmnR+fP+jIYVB68GYHyXEJX4zlN3O+A4eGeO1SDvMIqCiIWjpVtvRcvkGzlxF9KjRFmdmwEJPytt1enX/o2SAnFLZ5+P83a57jVgzQZLYkYUcP10NmJnEEK3vLzzS4yJg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(56012099006)(5023799004)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 W0KCmwcwIoLydYqrUGZccqWym208SAx9oeEi5PkzDgbE1AnzXgU0Cb6N+2fuLPyzbyb+E6Ak6gERJ5ykk/O6UMqUs8LHJg/de/fEkptz3BU0aS2ooTKRvRbYqrVsn53b8myt5CtsQ4BMwLyzXDmmIZPjUrWfmc5RnYiVFuS51v+KgETEiI7bxcxjhmM42yOhkP5hspVb/O3oKSsBtzOwUZ2yW6GeHc/TuLBHRoLAgr5LJRn4ndtJhZ7lpyBl3HW6ghLATORabcBrwsouEJpaK7GiGsBdQj21VD1SneWVhvBhxDWErMav2QHnCCbctxWz8fmxrR2KfM9F+tUZE+bUTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7639
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	06b7a6ee-e7eb-4c06-5168-08def79d664f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|35042699022|36860700016|14060799003|1800799024|82310400026|13003099007|6133799003|10067099003|56012099006|5023799004|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QtpXuJp9ywRXyULDtlsbFiAE+Jl8P1lMN7EN+4nqINvDcQAKCSfmYTsjiBhIkF30EIqx8VC19OK5xgilC/dbzRH/yOj4Ibj3NOGLMCwaYv7NjIVE9KBESaeixBSiXummza4MYfgGq7kPpgwdEP0afbRkmrF5s8lPNCOVeYIx2ZUspDXUfUlwyCJikZoX06rK8R9Ue0BirS3WqOgVzr2Hd/ItKVzS9zkc3Vp8EIDhF4z14eGF6gEsFKDgJ/yNQk7a5NbkWe/zsJeryA61qvvsjGyoryBQgTJUWEPLm+JyM4BiEFn+QiT7v2BKmTC7M4/uWk7Cvzw1Hr1K6Q2Sh7RmoYpNU2+UpDkSLMVMWOHDMegSjIFbN/C5J0HGHPGFRYcOGyTAu4VBu3gu7A0nrkmK4wsuSNEqlY/73h2/YCkV4CXMtS5gMeCD8OjKZdnr4CgLuwdr+yS3p0nBrqH80RaO2OtPxn0k4XdtzaAEqjCTD1hbk5AaH3+NUChiaOspi9MmjtW+N8Nrxms1PaSo+tets2KeiNEnTtLWNmpqqhS5UsTvKgKlbNsd7czxcfzI7q1m2IEZOTQ/tA9u/z/mLLHhzhHxz1LCFhllChcUzUkYPDYwj75ja6xTSiz/0rw3ZO70ePnbsvsrNx8Id/MvdkpjWBm8mC5vRhFHnLyBWr/wRKsyeouhUTqqgdn9t9acyaXDiHg0lM50QzPNAOCZrxF99g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(35042699022)(36860700016)(14060799003)(1800799024)(82310400026)(13003099007)(6133799003)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kzWOR+/tTLHICH2+DbyRg6NYPW+7EagjdtI0rFYLa14cjyr8JSMYkR2O3KC308tT15L15UUxXGUhq1wHsPvmeO55GKFK2k0pPVGzqg9WYmqmVUrF8WftR7OZVC+0Nve438t1GPE8lQMiP30F53Y1De5+J/kKkPQbxNu+h0ErNxpPaGhk53mYbfUBahePE0DRgscST+MXxtXKCBLYYPzS6YQYSyuImJlAZu0HWhyIKZicMMI4v1fYDZyTCwow8N961QO/elXSRq/B7eY/xYzXdBPeEKPh+OW+tmlgxpEJJRhNn5UOGEB7iRgKseDFEjiviJsqUd93VqFOLT9dQtrG59t693ROh2eNGl0XRjg0VGJoVwmSKkUCPYo3kB+pl1c9Lk4tJX7XGw7K77SlK/QicPmJdIeVTVWLqUFGQVfOm14BuuXb3il9WjrZDZbHfD/+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 11:41:28.2456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 169e4b3e-b64c-446d-eca0-08def79d7b47
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6280
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 5fxursmyr8a7xagbxpqpsk79f4ekex69
X-Rspamd-Queue-Id: A4A6A40005
X-HE-Tag: 1786448494-167798
X-HE-Meta: U2FsdGVkX18APahtThd+bEsAk93v21G5SGSDp+BQBS2h767uWtK1HYwtm02Yzz77E1MRt+RBUCQSiZehg2m1JEku+WOE4KhHPONgD8gvXK55I4uGmtlvBFCRrY6tH2RqYogUwKsrr1NnjcF6GgQgv2e24z2UXSK8777pGPDe+DHHFVa5cu4OtlJkch3nLzogOUFksfW/i4ImqSBOiKlQhyiRzo9FY7/oJq/OzodG1Gbzx1nx3/WNrrgmUBtKeDataoX/+5WNN6PW2DUWryyXDWOgdSKHYehOpJ/r/lGG3x8brdDFIz7xlzPiuJtddjr03Aq1uGq570GQCvtdkzys03WBHz3yNDqXuVeqKhiqQzeA0mlhYt15rYztUDZBjEFgbzamWO5fqx92qTeIC1GfE9tfPUxsBh+gt15Ddx/d1FINU4F7Fa12I05S4o6x3FY1C2PKGh4DarAKtHQpe+Ntcpu4n5M68qhN3z5OogUzayyhuO3q23Mz/rGcMJoPRXLi27fGFgcn3sO/DvhGNwapNi9mSY/GWWyPZ19WZdHj/Y8c+GBiCRpfxfTrre3fHjQeTh/Ic/YAoVXQFUnF3VE7nblEEb4FVvFSPPbRDquD7t0DxOyz9LQpNyHVyFmWwVoYEKfrmbZik/Qciaw+dh0+RGJQQ+lwmLl9VEpeNgceKxN2mJChW34lmttK1RG0ZUcDSz70sVsQwGnP3rPvaSrjaq2+T+0qg05Yjd35ssPhtySQzfZWmmhM/mrKCPZ2RXr0N3EH8qm0JVMSFrykACd21768VIqeg83Pf9l0T+iU7YHGuIXOwyhR5tvSAE93jtASghjs1GL9Ym5+24rah8MAXCN4dNfzRRFh3IrEPkbRHQIxxDNj7W1B6MVkgn/G6UfjnckqAAOx0IweDatzGc646NRFwEHPT5m24D2W4NS/Ngaum90GuGrmCxBX9G9gDPp84z1uNgKitStDpNgZYyT
 YYfVMr3w
 7lEoWupv50sJoKUbNPzg7CDdmytfm94ZpZPZyAg9Ve7iK9Bcg5v/iJXo0991N0LIQUUDCcCbRa99iFTi9rSgw0vEtqKPq6HKD+QKNH/5rPXEQOn/1V0BQk7/pZeZHn9s5HiyhWt1TEcOuKjCN+go1iEyDAQUYbF5SZGkVAaJ23gfGmPCZ3E6PCf6DnAfTwpODxmEwhujWGflW/7SAxixKwXZdoGjixNye5CAiCE66amKmm2V97Cbb5zZX5x24x4637qHvHXqNyM+2A56Lwhi+oXAtzTdAdg02TLwdtzHJIgBZb9jwo3WSjJBq/sLET28MQL226UfBrLPijt055BybLJACHtN8C4rMFdEXELwBCGNBwQpoLj7ZifdIpE1djzHWcyBkNWm2qbxjuljOGLIDDRqUW17q00F8EJA2alTHHZuVqtTO0nNFCmsNHV0rmHBOdBTvo5hgewt76ABXpZvmd10WeoGeklrGOA4Wh/DrsyB/aYEIaQOFHuflF/Ob9fakdPH0eX/UIa7r0H+cGp8OwHwJEjXCFwF2JXJvJIIVWW0qc32svE6cPcWJuEnbainKsC8aHdKlp++9PWg7W6TzaqDGeFVxq2R0Q7rvWi1n5JhNSA7fFxu/QCSZyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/08/2026 12:36 pm, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> mTHP collapse went in for 7.2 with no functional selftest coverage. Every
> khugepaged collapse case is PMD-shaped, down to the detection: it reads
> smaps AnonHugePages, which cannot see anything below the PMD order.
> 
> I am also reworking khugepaged's collapse mechanism, and that wants a suite
> worth trusting before the mechanism changes underneath it. Nothing here
> depends on the rework: everything passes on an unmodified kernel and
> documents what khugepaged already does.
> 
> This version sits on top of Baolin's anon mTHP collapse selftests [1], now
> in mm-new. His mthp_khugepaged context and per-order detection are what the
> new cases need, so they go in there rather than bringing their own.
> 
> Four existing cases fail on the environment rather than on the kernel:
> 
>  - The collapse wait is a fixed three seconds, whatever a huge page costs
>    to build. Scale it with the PMD size.
> 
>  - collapse_compound_extreme wants a 512M folio from the fault path. Skip
>    it where the PMD is that large.
> 
>  - The page cache caps folio order below the PMD order where a PMD is 512M,
>    so nothing can hold a PMD-sized page cache folio. Skip the shmem and
>    file cases there.
> 
>  - The swap cases ask a best-effort MADV_PAGEOUT for an exact swap count.
>    Ask again before calling it a failure.
> 
> This is why the suite now runs on arm64 with 64K pages.
> 
> Then the new coverage:
> 
>  - Folio-order helpers in vm_util, and folio_order_check to validate them
>    against the kernel before any collapse test trusts them.
> 
>  - Four order-parameterized anon collapse cases, plus mixed sources by
>    source order, at every supported order by default.
> 
>  - A shared-source write race: a co-sharer writing throughout a collapse
>    and the collapsing side must not see each other's pages.
> 
>  - khugepaged_full_pass(), which steps the daemon one scan at a time
>    through the sysfs wake path, and khugepaged_sync_check to hold it to
>    exactly one attributed collapse per step.
> 
>  - khugepaged_race, racing faults, MADV_DONTNEED, pins, fork and mremap
>    against collapse, checked by content and by KASAN and lockdep.
> 
> Tested on mm-new (8086604be973), with KASAN, lockdep, DEBUG_VM and
> page_table_check, in 16G guests:
> 
>   x86-64 4K     190 pass, 1 skip, 0 fail
>   arm64 64K     228 pass, 5 skip, 0 fail
> 
> The skips are structural: mixed sources declines at the smallest order, and
> at 64K collapse_compound_extreme and the shmem components skip as above.
I've tested them on arm64 vm and more tests are passing instead of getting
skipped. Hence:

Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>

> 
> Changes since v1:
> 
>  - Rebased onto [1] (Baolin Wang), which this overlapped and which is in
>    mm-new now, so this applies on top of it. This series' own -o mode is
>    gone in favour of his context.
>  - A plain ./khugepaged and ./khugepaged_race now run everything they can:
>    every supported order, and every mode, occupancy and pressure axis.  The
>    options only narrow that down (Mike Rapoport).
>  - The fixes to existing cases come first, then the infrastructure and the
>    new tests, each next to what it validates (Mike Rapoport).
>  - The completion barrier helper comes before the tests that use it, so no
>    case carries a throwaway implementation of it (Mike Rapoport).
>  - Changelogs and comments rewritten to be read rather than parsed
>    (Mike Rapoport).
>  - One new patch: retry the swapout, which is what made
>    collapse_max_ptes_swap flaky at 64K.
>  - Dropped the swap-skip patch, an equivalent has landed
>    (Alexander Gordeev).
>  - Review fixes: masked failures, system state left behind on bail-out
>    paths, arguments taken on trust (Sashiko).
> 
> [1] https://lore.kernel.org/all/cover.1785985999.git.baolin.wang@linux.alibaba.com
> 
> Kiryl Shutsemau (Meta) (17):
>   selftests/mm: skip collapse_compound_extreme where the PMD is too
>     large
>   selftests/mm: scale khugepaged's collapse wait with the PMD size
>   selftests/mm: skip khugepaged page cache cases without a PMD folio
>   selftests/mm: retry the swapout the khugepaged swap cases rely on
>   selftests/mm: move is_backed_by_folio() into vm_util
>   selftests/mm: add folio-order check for address ranges
>   selftests/mm: add folio-order detection self-check
>   selftests/mm: add khugepaged completion barrier helper
>   selftests/mm: add order-parameterized khugepaged collapse cases
>   selftests/mm: parameterize the mixed-source collapse case by source
>     order
>   selftests/mm: cover a shared-source collapse write race
>   selftests/mm: run every supported collapse order by default
>   selftests/mm: verify synchronous khugepaged driving is attributable
>   selftests/mm: add khugepaged race harness
>   selftests/mm: race collapse of windows with holes
>   selftests/mm: add memory-pressure threads to the khugepaged race
>     harness
>   selftests/mm: zap whole PTE tables in the khugepaged race harness
> 
>  tools/testing/selftests/mm/Makefile           |   3 +
>  .../testing/selftests/mm/folio_order_check.c  | 137 +++++
>  tools/testing/selftests/mm/hmm-tests.c        |   1 -
>  .../testing/selftests/mm/hugepage_settings.c  |  72 ++-
>  .../testing/selftests/mm/hugepage_settings.h  |   3 +
>  tools/testing/selftests/mm/khugepaged.c       | 466 +++++++++++++-
>  tools/testing/selftests/mm/khugepaged_race.c  | 571 ++++++++++++++++++
>  .../selftests/mm/khugepaged_sync_check.c      | 217 +++++++
>  tools/testing/selftests/mm/run_vmtests.sh     |   8 +-
>  .../selftests/mm/split_huge_page_test.c       |  62 --
>  tools/testing/selftests/mm/vm_util.c          | 145 +++++
>  tools/testing/selftests/mm/vm_util.h          |  10 +
>  12 files changed, 1599 insertions(+), 96 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/folio_order_check.c
>  create mode 100644 tools/testing/selftests/mm/khugepaged_race.c
>  create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c
> 
> 
> base-commit: 8086604be9733378461a5534c39cb72635226b23

-- 
Thanks,
Usama


