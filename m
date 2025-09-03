Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F73CA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15DF8E000B; Wed,  3 Sep 2025 05:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8768E0001; Wed,  3 Sep 2025 05:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E3E8E000B; Wed,  3 Sep 2025 05:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94C4A8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:16:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D4DE13B1B8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:16:17 +0000 (UTC)
X-FDA: 83847382794.05.B15D999
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf13.hostedemail.com (Postfix) with ESMTP id DAA1020008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:16:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=m7aXUpqa;
	dkim=pass header.d=arm.com header.s=selector1 header.b=m7aXUpqa;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.68 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756890973; a=rsa-sha256;
	cv=pass;
	b=sEXpDWKrXVJNZ56tTLmsXfvw0Y48v4v9J65mkSxNnJipYEQqCCG27ofW+nJ3PYk06CrPlD
	YfKAuBywsZ7aUtqW4PBWbnv2r+vRJqUZKWLnCsTVcOch8GCOQyoeirRZuMJGJc6p4SUkli
	wEsMHlHhF67gFkTRiX9zFRIjzK+McSc=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=m7aXUpqa;
	dkim=pass header.d=arm.com header.s=selector1 header.b=m7aXUpqa;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.68 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756890973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clS+LTjdyyx52VUXGVHjIBDveYv31DXYt+7TbVZW0qw=;
	b=YUZkot/Qag4G5zYX79lzn+sSQmjgI0ETdumY+9vS86boKfy4V16UjT7XPljpYAXAUG++WQ
	xCA/Wq3po0kHxPAIuxGgZSd5lTRaMO72DKcw8VuSEaf+iGYCKlsrRbq/MV3CFpxv78Q0s3
	jOq+ufm9jj0o2sHdNpdKAuk8ylF/1iM=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vH2fgZBc3xeRjik1O+WuUundI4i23vzdflO1Wv/kC4+m6n5GT9a3XwPwJ0ArRIiIxmflp2Gu0ddb9Mmdjww4n9bbnCXhugUy/kFRkPtPX7LjYyXcrph1xa2nJ6yWy43juMN9Lxp1UETtz8yz0OqxoxAJYFavtfJf4vkBaf8scJqpgevTZJWvE4RhCjmye5b/RxrS5cGVSBfQCo7LFFCRwKXnq4vsexicthAL7zjsl5v6sOJogcxBOdUz7XcY/HGCmmeAINw8M2hYdVI+HPq8hYhmRXLHEDjVlhiX3ycYgIfxcwcjbx/n0Tgge7naoMohtOW+Ejzs1jayKD6D2/TQyg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clS+LTjdyyx52VUXGVHjIBDveYv31DXYt+7TbVZW0qw=;
 b=fmr6K6X7aUif6OAw/xoUuG+X8RWR9g7ICWPQjiOZl8q6bf2D2afhBNDthaJ4o3o0mV0x6b71g5LfYoqXdBAqx6u/7lVkKUXetsgA1HUyMOJFjjRl/ey2+dA+uq+hZUXSp/ZnRWSW0uYmYrmaS0UYtmNgWeLzHvJMHji63G/5US0V0AxJSe7PR+WbpL08puyUJ0C5Y/F6zscNZ2b/NF3AmXVfw+TgSCWahbHfPO7FvOhfnBvuG7zZx9dI4btA9YiRaDopEYA0HEfSGnsGw1gVJldV9bfqjw1FHZl38JgysuN8WWX7VHtGAJGIv08CcCYneb5mcmA+ESx7a8dYwPYmWw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clS+LTjdyyx52VUXGVHjIBDveYv31DXYt+7TbVZW0qw=;
 b=m7aXUpqargOSBZqjlwYk2+UGzKd1wc2Jf6ZnDbFimvMezWKCf35kKPn36E+4kpcophZw8wivj+76G3xvYKRb8oexqyeXXQcxkeJP+Bt+tPmuYU+dI6xrn53BjaBlEHDylZg9txK7a1AUJ4CjTqPo6bsN0+OaS43Kvqi1xi1ZTKw=
Received: from DB9PR06CA0005.eurprd06.prod.outlook.com (2603:10a6:10:1db::10)
 by AM7PR08MB5494.eurprd08.prod.outlook.com (2603:10a6:20b:dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 09:16:09 +0000
Received: from DB1PEPF000509EE.eurprd03.prod.outlook.com
 (2603:10a6:10:1db:cafe::5e) by DB9PR06CA0005.outlook.office365.com
 (2603:10a6:10:1db::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Wed,
 3 Sep 2025 09:16:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EE.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11
 via Frontend Transport; Wed, 3 Sep 2025 09:16:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tRXbseX/TjwIhIItX43qYIw36d3ocgwisCpNF88HGnNOUWPE6fhd4uVuzejC4nOOxhopeot+E8GCDo2htqMTJ9awp2z1htULZRdzpiR0/DObX5Q2AUAnanuh9ZFjuhtc/a4SGLLT6Y3myhypmHyGDG+LZyecKcWyBYa2cU0d/BTahBaZIZdsZA/yN+8fJSn2FX0CGG28l7n0GULI0yPTtjCzJQSco8p8P6e1vw4uQF0fKy8K3FuQB14jztEjEQXD+ibzZKAZ4nuxpc5Da/3xcgfq6QAtYdQaVy4GLDSQ14emfhhsYx/bP+GqcqbY8d3kBxWi6iCoF0nwhm9IHMtLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clS+LTjdyyx52VUXGVHjIBDveYv31DXYt+7TbVZW0qw=;
 b=Ytza8vl4S7skYQHhK2VXMt9lsK/ID6agfvGD3whqbkJ3GlA27mViYo32fh/gwh8IPyC1ldOdbG+85JLdmNZMgcMRWRq/dDGg9PCMeRg9rHrX9avxQZNFz221/iwsYmMA6sj+Y4HSvL0HE4f0JUnCI81ySRWsNw0JuQX91Lg5AUNXn/EcSRotRjHAQRquOdqr8NzqHWoV9i5Fdfm3HiSfYIcZo/SZmVVqiSHQoRY5pKI1t7Uw+SijX2LJEtMjUP7bGS6RcLteFlQDCW8Qfl1l6R4v+w/k6gjyuuh2inYrMaW68GrqPt5zTPpNLhXbWbdsnvqQSHaqLNyVWkm7KcJzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clS+LTjdyyx52VUXGVHjIBDveYv31DXYt+7TbVZW0qw=;
 b=m7aXUpqargOSBZqjlwYk2+UGzKd1wc2Jf6ZnDbFimvMezWKCf35kKPn36E+4kpcophZw8wivj+76G3xvYKRb8oexqyeXXQcxkeJP+Bt+tPmuYU+dI6xrn53BjaBlEHDylZg9txK7a1AUJ4CjTqPo6bsN0+OaS43Kvqi1xi1ZTKw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DB8PR08MB5404.eurprd08.prod.outlook.com (2603:10a6:10:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 09:15:35 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 09:15:35 +0000
Message-ID: <0a52cb54-5633-4374-baa5-199194dfc2e1@arm.com>
Date: Wed, 3 Sep 2025 14:45:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org,
 willy@infradead.org, hughd@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903080839.wuivg2u7smyuxo5e@master>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250903080839.wuivg2u7smyuxo5e@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0081.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::8) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DB8PR08MB5404:EE_|DB1PEPF000509EE:EE_|AM7PR08MB5494:EE_
X-MS-Office365-Filtering-Correlation-Id: c05b48f0-592c-47f0-6ae4-08ddeaca84ad
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?RVN6UUg3K1FTUXVVRzBTbFhpV0xQT1BZS2NNUVFnRGNZUWp0R3o3NmdyWHQx?=
 =?utf-8?B?K2g3QWtWMTliWHVyNUZLU1k4WnhDUS9ZUS9OR3pValFIbGNtTFdGc1ZnYnpx?=
 =?utf-8?B?R3BGZEo5LzZkSHNWa1FoR2dNVHlkaGQxY3NLK0EvTWxENVBiTmk4V3F4Ymw5?=
 =?utf-8?B?WnBxQ1RFckxRSVVTYTl5Z3FuQ2RMN1BHVk9Fb3c0WUYwd3JkMEFPK2FrZ240?=
 =?utf-8?B?S1ZiMll6Nng2SzFLRWxvcjE2eHE4SWRiRGlMbi8rLzBwYW10RGhvend6WXJv?=
 =?utf-8?B?NGJSREQ0SXUxa1ZSNnhQVXh1elNSb1BGZy9mYTRUZ1VVL1gyUjlaL1JhMWtN?=
 =?utf-8?B?d0JUeEw2N3RENXA3Wkx1dnN6KzA1TFZ4V1dwTXpMcGUrT1dSYWRlaXEyUzJj?=
 =?utf-8?B?Q3pwY0lVamh2NE1iWC9IRFl0K1N3RUFuUjlyZEtUc3N6VlFoelNMUDVoK3ht?=
 =?utf-8?B?a09HSUJhZCtXRm5wWjBDOXUvZXhTQlpRVWxSZFYwK2s4bDVTbnk0dUJ2SG1Y?=
 =?utf-8?B?bWhzOHVZQjdTVWNJSTlPMGJ0SDdMeHBqaHFXb3hvWHRnQXdZcmprSmFIeEtJ?=
 =?utf-8?B?M1hOc2lrc1FTdnNvMXRVK2prdm5jbUtncEl5TzRobWZncHd3OWFjSDZqSUlK?=
 =?utf-8?B?bFN6d3YwKzRMd08zdUo5bDUzSDFlbzhFaUh2Y1Rrd1hTRENyOXIyVGN6UDVI?=
 =?utf-8?B?cHlXZllqZ3EwQ2tkQzZEVlk4bnlQZGtxdENMMUp3ak91MHZUMEpFNncxM3NT?=
 =?utf-8?B?NEN4ZVJhZjZXazc2bUhtdElWajZoUE1qZzRSaGYzcHlSSDBmQ2pqbU5MV1Yy?=
 =?utf-8?B?c21IeTh1YU1Fb0dDZ0tKV0JhSjhZVnQwUUh0NXJQVXVwZC9BS3NheWtCYjlL?=
 =?utf-8?B?VW5POHMxVHhMamt4UEhXeUsvNUZGUHJ0b3NMUm92OHNvalFxUlhOSDRxVTJu?=
 =?utf-8?B?bTNEOFQyTDd6TVdVTktUeXNLVVRySnVaNjFpa1I3dzhNcUc0M0NQUDFBSkFK?=
 =?utf-8?B?ZDZ5ZFJVbHdJTlJzY2xTakViODFNTzZxaWFXaGFWdHlSUzlwN3g0TFFoOWJq?=
 =?utf-8?B?RVVSR0ZRVDgySUdkc0cwUi9tcnE2dC9YaVpHeGhtSjRpdVhjeFp4RUc2UkdC?=
 =?utf-8?B?YjNmd2dmdmc4MDBjUnByMmp0VHRxTnJwZk1hSWJjYmIrVFNVK3NxL3RTVTlH?=
 =?utf-8?B?UktiZWNKRlhtWnFadWYrQVNrL0dJM2lUNFMyLzRHc0J1YzVjVmhSczRBUURO?=
 =?utf-8?B?ZStFeUdJTnhRRlRSa2lJNFp4SzNNS1VMNURTeTA1UzJ4VkJmTURuaXR0SFBM?=
 =?utf-8?B?RTErQkRuUGpGU1BlT0lZY0gwYUtPdnJUckZyZVUrM0w3RWUycXIxYmt2WmVJ?=
 =?utf-8?B?S2RLd0FNYUI4QTFKajZ6UWQ2Ym9IR0pYN0NOb0VtdElzakRxRWlYMDRwZXJP?=
 =?utf-8?B?TTcvK3BLM29XUW1BNEJJdW1rRjNKNzQzZTZpRktodGp5TUhjNDBlQ2M5cDFr?=
 =?utf-8?B?NXNCejVpZElyY0NEOXNvdjRUU08rTllNcjhPeE5HbmVZYVdHNmNmL1RhRkRD?=
 =?utf-8?B?ZVBPK05hSXZ3T283K0YxNEYrakdBM3phc0k4WG92dDBRVTBvdzR6WkY1MjUv?=
 =?utf-8?B?YjExeUoxc1laMlJVNHBxeGV4d2UvT1pCSWdKYXlNNEcxeXZIZUh1RVQxVDhD?=
 =?utf-8?B?WWFuQ3UyM2tCc3RFZ3dIemZLc0RyTWhPenJUeWp2WE5uNGllYmhJVEo1amRk?=
 =?utf-8?B?T2duaU5QNGxZN0pZS05JT2pFeG1CL1JOdHdtRTJXTi80QjJ1b3RXUmo3S3lU?=
 =?utf-8?B?My95RFljc0VybmdRK2xHNVR6bDcveTFrN1A2NTc4ZHZRcXJTNUd4S2hwdmNG?=
 =?utf-8?B?bUVUWGpDNDVrOXQ5MDI0VEVSZVo1Smd0bzBEZkRIZVVBLzZZU0lOc1JSWVJI?=
 =?utf-8?Q?ZIvF44AOGIM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5404
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2c1f36e5-0a03-4485-0cc0-08ddeaca7086
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|14060799003|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVJqUXUvN3JZd09XQ3dreWtTaVhtZDhER1Jkd2d5ZE9RR3VoU3Y4SE5Ick40?=
 =?utf-8?B?elFzUGc1WklHclZIT2UweHQrSGxWM0V0cytWVlF1ai9UbUp1WTJzUDdMUlVj?=
 =?utf-8?B?ZXJFZnFNdFJ5Ly9OS2pySlVZM1VPdVhBVjcxWGZRMzk0cUNCQ3h5citUbG5T?=
 =?utf-8?B?aHRVdlVqODZZaENuanQ5Tm8wcVBUNGQ1a3hoN1AwbXl3K3d4L1NvTlRZWkMv?=
 =?utf-8?B?VjNObUZnWDZMVEtOWDNsOVhSRTYxSXh1WWJaMVJ0WGlVOFJJVkd6eDNnTjIz?=
 =?utf-8?B?Z2tZdGFibWVESXJHT1BoYTl6Z3d5S2FUeHFvRmhHNy9ZbXAxRUU1UmltcjFS?=
 =?utf-8?B?cDA2ZGxEQi9CWGYvWWJMTzhZR2Y0TytHNEJIcXJyeFBvMWRDUkJqKzlwc0po?=
 =?utf-8?B?WnFVN25Ha3F5RGRIRHFTcVFJNm16QXBwdmNhU3diekpsUXhHbVFvRWlYclQ1?=
 =?utf-8?B?MG5VdkJPcjZSMytKekZtYWNybnhNdExyem9HQUVib3RENm5pUnVpVUo1UE4z?=
 =?utf-8?B?eVNSL2RSRzl3ckpCZGo2MFFOYjBTMjlXbnhkYUJsVU1YWGNESnJKWHV6MG1G?=
 =?utf-8?B?alFOZi9pRHphQytJUG1rYmlaMmhxTEtRbUNoUG5uMC9BZDlBRUZuVXZLVXM1?=
 =?utf-8?B?M0xsOXpHWVZDdG1jOThIeC9JMGhXbE1jMkliK3lxVGw5a25qdk1OMkxmWWc5?=
 =?utf-8?B?ZzFOTUVidzJ4SUwxeWljY0xhTXc3S0VodDVYRUY5S2lNR3dodGRRNWIrNFRE?=
 =?utf-8?B?OTVTWDdUbVJZTnJjazBwUFVDVnhLdGhXQjlVQmR1dXU1SFBBalpFNHlXWDNO?=
 =?utf-8?B?V0FpQW5RTFcyMlZvai9Ycy9ERnVhdEgrMFFJRWIrZG1oSnM0TUNLd1hkdmxL?=
 =?utf-8?B?SmM5WkFFRUJaWnBJSlJXckhXakZ4ZVlDTENnSlp0MTA1RGp6YWNQTzFzNHNh?=
 =?utf-8?B?RFI2WW96eHA0RTkvZjhOUUd3VjJxbGlKbDZMcElJRkM0VGs1RWFTWXY0T2s1?=
 =?utf-8?B?ZmdlS3UrbHhEQTRaVTJaYncxcHNDbldvMVU0aU1CVWFvT1FQMTZTenhRTFk4?=
 =?utf-8?B?L3Y4RnczNjlLelYvOWJhdmNkUHRDNGtMUjZZMjZmbGdYS0tkRGx2RGZ1dEFx?=
 =?utf-8?B?bUYvQ1R2SkNiaXhwYmcwL3duSXFURVRvdG5kWi9nUFZnQmlhUzl3Y2xZdDBi?=
 =?utf-8?B?N1ZubXhXaVErV2dRN1VuZlA2RFNoZlZCakVqYVg3bDBuYzUwbVRkYlFaVGtk?=
 =?utf-8?B?L2RERWYzYjd6dHZQSVdIbDIvbXY0a0kyVTljVHRPWUl6L3ErZUphV3lZUVFE?=
 =?utf-8?B?N0l5ejYvT3VlYTlKbWFrbndsNGlwcWFlZ2dTUXc0TTNId2FTcDhEYzY2V3g5?=
 =?utf-8?B?WDd4dmRHbUtZUXUyVC80Nm1KOUt1aE45dk1SM1NiOENNYXU5TkU3NkJLOGhC?=
 =?utf-8?B?YnA0a3dUVXJ5Ylh3eUlMWnFCZUlPY2xRcWliLzdBK1hPR1QvcnhiU3dxVnFC?=
 =?utf-8?B?UitVQUdvTUlXSzd2dUFEUHdIUHZkTkFXc0FJdzdoL1B2a3AwbzlYYThpTTh3?=
 =?utf-8?B?SmdGaWd5c2tHS0NiWWV2SXFHVWF5cEU0SXRVdnVYdjMvR1FZOXRQMjFEKysz?=
 =?utf-8?B?RnBzN1pMVlNVaHlDcGdQQThyMzU4RTZiN0hOa3c3QzFZdE1iYjFnNkpLeWZn?=
 =?utf-8?B?Y25vd1lqbEl1Qjd3WkR6Q1NmZTA3eWhnTVhZUXo3V09lcTl6bW94TDkxWjR5?=
 =?utf-8?B?ek12c0tLRDBSRUxuMmFYbnF3L1Axdit2R2tIRDc1bDlVSXBlREVXSXFMSTN6?=
 =?utf-8?B?WjNkNFFUd0tLOUtQdmF6RkpuZkdyeTNzSzlQdnZROW11SWtNUTNEYXJGd2pr?=
 =?utf-8?B?YzVyRUlzNUMzN1dkMG41ejZNVjEzTEV3bWt0ZFNnVFlXQ2J4RlI3c2hLRElO?=
 =?utf-8?B?REZzRTNsSXpFMzd2VU5SNHBsYkF4WVhjN0RFbXVYUWM1QWxxMDA4ZUhxUXJ0?=
 =?utf-8?B?TDBOQy81VGJJbWNYb0ZnWnJOWFU1MTRwRmlHL3NTRm5KYy9Pamh6alVyaGJx?=
 =?utf-8?Q?D81Wtk?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(14060799003)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 09:16:08.5739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c05b48f0-592c-47f0-6ae4-08ddeaca84ad
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5494
X-Rspamd-Queue-Id: DAA1020008
X-Stat-Signature: fgo3q78764ftp1yn6rsndmywwt34t7h8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756890972-375720
X-HE-Meta: U2FsdGVkX18glEBp0zZNT+f9TM5ybP881BNfLbgdX4G3l8RFYWRSHe/xk+ImmzQJXQvq4hhYtHemdXR6YKrV/KovFYgcswO8ejxQ/mn1OK9ilR3rCNfDOKyY0/PMetWgrGPPkA75DEhR4cuxYNumE5FXlrhkuELmtouv0ZcxcqjI0NCFSkbF0bpfkwrE/nQlX5eMxpWbdKFHTnd5/M+3Nn4Jz0lnmCg0d6XcyLBxRXjLXwjOxULJ6+e+YQ+oyNYyWhg4NNQ+YFqDMYxdFeqMkpUDKiQ35vM8nbECrLQ2fYANc1z22Tt4cCKQRcGrddpQyQjmeL6G5v+HaOEZbjkZ7Jnfcx8E3+r7EOVKtJx0LlgTnyT8QloILhf9chANYc37X/ycZeX9gigwsYSfUVfsm/zlVlEw7jpFHUAx+OX8F2zO4jIYowp91QWuTpFVP5qFPSlsWSnKZ9G6bFI0uJmTIX+B4Z59eMojFRJSc7idQvMXSkkwsj+d11ps2kuDmz6zavdYn12+iKcCmcK6sfG3uRRyekjCYFk3VQZYDC72VVrTJG4sBNbSA/KIaIWGPi5zsmliv5CHOZ3+3Lw/o02bYsrdQlMMqh/UUyiovOKT9sdEXwrHvbggUvNRKoG6oukTW3w3HsfxyTa25Enl7W+vN+OQ4jtGAK2U2tBOPs29KHTZmWaMgXYdktAg/gZOaS+AKv0DYcS7Bq2Nz4ebBdjn7O9U4UjgVAVYLqh3K+NAaQLfXoIcUnnf0RH6vsEi0iAVyxKeqX68beFkn6CfE5+7lG7DBFXu6jus8BXMV8yLMf4IB584N2YmtUmUh8hN3pwmSaAyCsKi5NZ5EAhwwrwKSFhA4kZWIWJZMBfJWZYgTAp7FpD8wOgWcjQT7ZapurSaE2MzqT18Fbl2DFd8rmPiTsi0VlCmvSSKcGjbdnPeIS9bbhniy0XaBlMRSxO5fGmwKTBLbk83532/NdZL8X1
 DRiZFJ2P
 Rj/tk+pB/b+lY6P0vV+LtseCbGDu8zfbigWdNCMVFVoCPNAGvqciDA5XDm01C0BdPDPAn/hGARa6lYxw+NpmL0K3LZC2MI77hiCyzNmKX2Zo3pspOENkddFKlhAxRfq/e4OLA4W4RM35Ej9S0gWBbtlaYdDVltHv7uI4eVKBl/BOK7ODUtSjuQDSF+9TghcttGJqTklv+KYSZaKsDwjOtaKpxVGfjCYZoSlgsFF0xCY+eav2V069MhxGoOo9qrfciBlZwMrz0h7ikUoLbaHTrVcXQv0vtlw7Ux3TXMjRx86sqBBEiWgRklpmDFFPR74AAtFqs6RLOvvziXsJvGsz0UZ7LjYjyOeh1xGW5tHIxou5xLXcd9h3FEf9HGgtd9Zt+WcMfAg0HMC17hFx86eNQaE1T8II67skPY5WDUaMaklIoVA0cNB2apb2bD2hO/F6+1cbcSnsqWlgHkhYbNLKYPFcwzidgMG3pnWgpXpPbsdt/oLqFsuxFzOxjTytAhDnvNQ5S418bcNWMvLiXuY+NOUWPuYSQ7rNWIyrk/t2+V+/eU6x9wQrXhfLgq6pD2nTEVOmrgb3+uJc50bo2t1TNnRx4cxqW98yVaP4Sk+e/172ZWfWs5YQwRAJmusDixQvLWO7rwNwHsqPAX5mLY9CZ1gctQLnmx3usK0nsNfPb98T211Ov4BKzzKKiaEBrzBS6n9/JO3mHmL9LGTVliFeLkssxKOGKVPcnrLO2zDiLBvz+Qbg3z+/Aqbxc3KY4PPArRE9c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/09/25 1:38 pm, Wei Yang wrote:
> On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
>> Currently khugepaged does not collapse a region which does not have a
>> single writable page. This is wasteful since non-writable VMAs mapped by
>> the application won't benefit from THP collapse. Therefore, remove this
>> restriction and allow khugepaged to collapse a VMA with arbitrary
>> protections.
>>
>> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
>> non-writable VMA, and this restriction is nowhere to be found on the
>> manpage - the restriction itself sounds wrong to me since the user knows
>> the protection of the memory it has mapped, so collapsing read-only
>> memory via madvise() should be a choice of the user which shouldn't
>> be overriden by the kernel.
>>
>> On an arm64 machine, an average of 5% improvement is seen on some mmtests
>> benchmarks, particularly hackbench, with a maximum improvement of 12%.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> [...]
>> mm/khugepaged.c | 9 ++-------
>> 1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4ec324a4c1fe..a0f1df2a7ae6 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> 			writable = true;
>> 	}
>>
>> -	if (unlikely(!writable)) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
> Would this cause more memory usage in system?
>
> For example, one application would fork itself many times. It executable area
> is read only, so all of them share one copy in memory.
>
> Now we may collapse the range and create one copy for each process.
>
> Ok, we have max_ptes_shared, while if some ptes are none, could it still do
> collapse?
>
> Maybe this is not realistic, just curious.

Misunderstood your concern - you mean to say that a parent forks and the children
VMAs are read-only pointing to the pages which were mapped by parent. Hmm.

>
>> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>> 		result = SCAN_LACK_REFERENCED_PAGE;
>> 	} else {
>> 		result = SCAN_SUCCEED;
>> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> 		     mmu_notifier_test_young(vma->vm_mm, _address)))
>> 			referenced++;
>> 	}
>> -	if (!writable) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (cc->is_khugepaged &&
>> +	if (cc->is_khugepaged &&
>> 		   (!referenced ||
>> 		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
>> 		result = SCAN_LACK_REFERENCED_PAGE;
>> @@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>> 		case SCAN_PMD_NULL:
>> 		case SCAN_PTE_NON_PRESENT:
>> 		case SCAN_PTE_UFFD_WP:
>> -		case SCAN_PAGE_RO:
>> 		case SCAN_LACK_REFERENCED_PAGE:
>> 		case SCAN_PAGE_NULL:
>> 		case SCAN_PAGE_COUNT:
>> -- 
>> 2.30.2
>>

