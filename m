Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21911090222
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 12:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5FC6B04A6; Thu, 19 Mar 2026 08:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57636B04A8; Thu, 19 Mar 2026 08:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1EB36B04A9; Thu, 19 Mar 2026 08:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF8E06B04A6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:59:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57C221B81F4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:59:07 +0000 (UTC)
X-FDA: 84562817934.23.7C1FC17
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013006.outbound.protection.outlook.com [40.107.162.6])
	by imf21.hostedemail.com (Postfix) with ESMTP id 473A21C000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:59:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KjcySZ3z;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KjcySZ3z;
	spf=pass (imf21.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.6 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/hmd4o/njnqAsldvbgE5F7I/b0yNyzGK1vSU5V3kc8=;
	b=F96wekNMbbvPD6XA1mUTsnpb6ZwdI4tObjVwI/M7aJdYV+1fz225YJn71pspJsjmP3KKK4
	dWjiVej4zSY4iX9NFYrbnm5Tz3Xy84ghnzHVNmGRwW28z32eWkdCf8D1/p5U6v+NXRTI9M
	wUEk47XEAlxtAXjP8FR5sNBEyHtP+9M=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1773925143; a=rsa-sha256;
	cv=pass;
	b=45I9ql8bY4eBL/a6RjQifkmYC2bSSS7ivwkGVZsUT7JYAqypyRLw7TIr0iMgo874RDQdW8
	afZ0P4N4u1NC0fd6WRUpZcbwZW0xCfk0+h17623EWNHueOiiF2S86leUWFIvocvR+uLZ1n
	ls0RHsBbcvLpghLKydIIwgJVbuylnSo=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KjcySZ3z;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KjcySZ3z;
	spf=pass (imf21.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.6 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lY6uNxByfukaZja9T9dUkHs9qRkoH8qT+TzyiCuUxsZH+Q3L3JQYHxJbAV8Q752GxYBWj6FJU5K8iAY+DWV8YspoTj6H2ePEt+nJshx+m5UI6MwLNBw4jTa2Kd3gi27yxAxioXjzU+dEU20danDjnTEqDorcLYawdBJBm5WSn7ZlJo+Jo3cZGfWR1VAspXllEnpahJufpv3rFt0lppJMgnheuOXXNE9fg0j23VhaT4cYlzOhCP8Mo82W4tauUPMP1ZVe7RuCZIBbGKCm43+FHPO3GEElshs+yZQDa7lKd+Q39133QBDh2xIjJsfBBvXgxI37iA8YZYAHfwlWmF7r6g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/hmd4o/njnqAsldvbgE5F7I/b0yNyzGK1vSU5V3kc8=;
 b=UII4xwLGY7Q5qHvw022aJ80t1wAJPLt6gUBSJ2VagsUuCC6cP8KOqRLive6dnzN/NRDRYgeWVd2MqlO2ibxPZl3Zrzubv8pFhZXmadVc487rM6xyted5lYZbbxWIYl5IhQVEJDaY8NePU6W9CAo3XuwgULncpq/ts8RDu5Ici2J7e93FgRn539JSuHUDrePdVxCpMR7pyqHmJkPPBj5sssMhHOulnP/rWhVVESPcnxJ4m3Huj+VOJqQrmMcgVFRSZH9cznCut+9nkmw4CRRzVXgn2+AF0eMzxOVFLpVZgj25l5WmDdc/1mlUmtdETM4zkz++56xu8kWXbtTMK+uKGw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=arndb.de smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/hmd4o/njnqAsldvbgE5F7I/b0yNyzGK1vSU5V3kc8=;
 b=KjcySZ3zZTDNRy2/z51+LMyKkFWTnd2e8FzeGjXLv4IF7Bo5AVS7upyRVSHV+dxa5tkDNQIhlCP8m33Q5cYEujsTWzcf6Lys7w/jaI9hz4c7OEQUAAOiWU+hyA9sqyAquXT2WtnGCA0PF6wqgBw4xefaxXbMhWqr92oB1W+vMVs=
Received: from AM9P250CA0019.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::24)
 by PAVPR08MB9354.eurprd08.prod.outlook.com (2603:10a6:102:301::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Thu, 19 Mar
 2026 12:58:53 +0000
Received: from AMS0EPF00000198.eurprd05.prod.outlook.com
 (2603:10a6:20b:21c:cafe::7a) by AM9P250CA0019.outlook.office365.com
 (2603:10a6:20b:21c::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 12:58:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000198.mail.protection.outlook.com (10.167.16.244) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 12:58:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FI5xg1DNlX724yJ4Gk1CLPyTy2I/mnYVL5HfCeHVOtYL7k1Rj57o1jGmf8HpthVXQ7Nv5zatqgT6jK9KTS8h0riVFqHIVjXvutNo6mXN7Y8KjYgFqyp3/iPJdUXfegBUoBLQrMVEIvubl/ukB9P4aDxkH4bpjmqmfKKbrW2zJGkOGcHyMhbTLtI7qf0w8PdXgnMJEhMFvsIaLIKBue4IqaLmaYs2j1p7w0Icb371+FE/BMZ1EmEzYAQLzmiW8c4HapH60Nh/kVuMPOqkVCtRyTuwvPev0gUu5isoFiVulMzCvP+um1VR8M6IxkjHugUSfa6kBeyjh2+fSp671wXg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/hmd4o/njnqAsldvbgE5F7I/b0yNyzGK1vSU5V3kc8=;
 b=xvu6Fs6Bel0uBUDCHhu+1KYVa1y0SBiGmYKmCKqo9DdOM1tHi6jZZRHw8Qo4X67dNiUNbuS5cdgCF/kPt22ekLFDc8I2FIlQZ4hHycTs5lXaK9JgLMlf5b5FVqfs0idkEUwxmiuTjS5cGKpUgU7RkSIe4SlQnB52OqKh+NWZ3EaYYjXMySPNW8/7obuIOZOy9emopHb26n6qBfIostIuezYrEbLQNVqrQ8ygLkWg5G4epw4dVv5MLDFr/IUzuW2RgP/5eC8HxidLZTZMfIq7vvJ5AKL84mxewie1GXKm/KgfzPqC6hbsBl7JWWVTFLBy5Kt/vpROAKUQSoSXEjL5aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/hmd4o/njnqAsldvbgE5F7I/b0yNyzGK1vSU5V3kc8=;
 b=KjcySZ3zZTDNRy2/z51+LMyKkFWTnd2e8FzeGjXLv4IF7Bo5AVS7upyRVSHV+dxa5tkDNQIhlCP8m33Q5cYEujsTWzcf6Lys7w/jaI9hz4c7OEQUAAOiWU+hyA9sqyAquXT2WtnGCA0PF6wqgBw4xefaxXbMhWqr92oB1W+vMVs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by PAWPR08MB10996.eurprd08.prod.outlook.com (2603:10a6:102:471::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 12:57:47 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Thu, 19 Mar 2026
 12:57:43 +0000
Message-ID: <2c71db02-6fe4-4c07-a88b-eaad0a0961de@arm.com>
Date: Thu, 19 Mar 2026 12:57:41 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH 1/3] vmalloc: add __GFP_SKIP_KASAN support
To: Ryan Roberts <ryan.roberts@arm.com>, Arnd Bergmann <arnd@arndb.de>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
References: <20260319114952.3241359-1-usama.anjum@arm.com>
 <20260319114952.3241359-2-usama.anjum@arm.com>
 <0d963ff9-9222-4e0f-8e57-ff22088ce978@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <0d963ff9-9222-4e0f-8e57-ff22088ce978@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0081.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:349::6) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|PAWPR08MB10996:EE_|AMS0EPF00000198:EE_|PAVPR08MB9354:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b3b45c5-2b74-40f7-3729-08de85b74600
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 H5FcwP+At673YHJV8Oh6d/hEZWBu4XoV8H7WpmTYZh0ITwDv9HX+rAqh7bFodpn/AHynnKXSLsVF110e3G4/d177cwUEZVezcig83XrfNA6mII/mXZ9j3LKCVi3/eg5ZsjuScpPqjpy/HKO1bc6m1TTMFPpihD1T3DDoF59D5nQkuQxTZKL3bPNhzAK25sWO+96OBZlxHw9s8zoTBpiaJQgVxKcnQnEHr3Fqu0ChN4JwekLizs4TOQ+9DqhCeFPWw4LehF1HkQrJUhxb4EE01579D7+6AHeS/RkK/+065k9PccB6VsFL/u49UFBi7PUvp2GeAokfwMi9fP8yE4gm3rD+J7oczLyQhtFFCc5bp46bG66GcfqpBHlGXt37rIsPTVVv5BN+bPxha6W1HwPcEkMwwlMAiSDrqZc2zMdea6upUglsp/RyDYL+iqSIA793UuvBPWotdfg09OgOmNEfHd1SWkbFVwJpAKoGCwNQXVoVtkuURUvQtG6OaBTEXPP2PP+Ep3n2KwGcsyRqsFgYVh7T24WXjWbLTm53nif3dwMsZDaL81b/8Z1NEnwQSO8Y1yxhYWDXt3NWRumc/S2hHnQLXvCGkhceQqUoUMWx6vrahgHnw8AeCCRQm9d/rOG4vkM1WKVkLYbSopuVChKIA/r2OQR+/zhJsj17Vzs4vFIT7RWLW4vldK9qKt2AE6zt/PdqoZehGlRV/BTKO/dDYJlYxsURW/7Sh9V/5uxKP2GhCrnt5sD0JUnUF1bgFQW3su70nBMx3YJ95CxcygsX1A==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 KxNrVKhAHJ/kOEXAcANweGHOF3+ru0NyIOAUvWDOKzWrDH5gaiYehkQEt7dSLoT8orr8L3CW0zOojGWR62TFFIhB+VvwF2Bx8zsXedw+OqSD0ORy8XJwEqvLHSnIPPjGCKqkvyTyErmO6MqSKXpQ1mxYFDlJPMmhusVsj8NdJIuZVj2JqSsL46o+tbteKj5wLFvNo14+02ZavWvUBL2TMT8h1rTH68ouWiIEQdzJlmtI+qNswZpPBxmCRDL4v/B6nBeK3Vjt6sSbQdJi5ncVhs8LaH8qHCAYT5EzyKi/aAg8nTDuFTifaEk+1iadRARJSEgUHtfoPczhv7Wf0P5wMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10996
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000198.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bd1e1ab7-7e21-498c-4e99-08de85b71bcf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|376014|82310400026|35042699022|7416014|36860700016|22082099003|56012099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	A3+e7kfA6wuVKjIEjBNXlOX3gyYxxNMae0coc9Qx4+DmsUJh1IDjk2pNYaOktZy+gqnn6sHmvMO2YXEPVgScvvCIEJawDjTsKfdO/rdQJRPPKQczUGBFfEU7U/CoDBEUB5qCB1TGlKdVLtEKbpOa9Z48WcFRj4ajzDrDhGniAnYUQow1SAwAII8MOY3oqRw5jGBR6V9BOLwdXLG1aFhC4GYB2QY+9/YHEhMVdm95iUZbnEiEvJPVf70B+vGAgfi2qDWW6AbjhMiz4Y8ZuW40t9l6uI9Ka/1jIYbTVhRtHQ0+20Wb8a7Ux8UvqCDG78At79mhgn7pnTDzcb3mAKcmjXN1SbMziscnQN2sKqJ88d6jpsXBAKeLumbtpXdLnSYFv/jllTI731kRJL+Jj1rl5LTC0ZffN6hmm+Sl1Y1LgKlkoeepfAlvb3K9d5woZzhUFBhMH8DuPm047jjyK1GyBSdBmT8w+1k1qetMdGf6KNROsgmCieSAimjcqfLfGjhi3GBNZSJOsVAELQBLP/y6sXj47PLqA+N1thSufqW1qHA9b/tA8Ax7y6lKpYR9zGo48Vwex7D+oyy9W8/Sg9CIDv9M0ULxxDpNjCYLoKXhzLpENrG9p6M/erJlphGIWtMJusjaqevOiZXNxBErdy84FmySKAfEVMSdEPFh4IGq0E6IT3mn1XEHstiVDQx6gYQoP8tt7+dwXNumKn+2plilSu0Q4nBzD9+QzG8NpYsnWSULfib9AuSOlLeUUx9mYD6yw299hgjDD/fo3xz6lZZxkNKNGCQSw1wQeWb3UuAwg30tzlG0FN3kZQ4YI8HCZ9tN
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(376014)(82310400026)(35042699022)(7416014)(36860700016)(22082099003)(56012099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pfe9CKH1QC3TBdTsWsOOrIEp8K60F5lqYaEBotIzD6T5X0yK5JbzuQkchjfPsBgDqU7RLyugbmrELsO7hiwJPPxSVAdIWh4y77jbnsd+x2fEWtIimZqywFuSaK5zcZr3pVg4Fw40Q9Pk7CBtZT/2KrSs/LsPQEXzQN1xYNTtTHBqa9OW1wrswVSIQaM700ktatt+XrKobfUa4SqnxQsQl2CEy5oZeAE2XwJOfSfpkVWtxO20P1Ry6miiV3W2Qu+EzFoaLrEWKIflY8BwFQ+ee28R3o95THmcI6IpBUoJBmTzmWxqfeCmuxytquf6dEhi2FvBKFeJq31UvVYsxmSo8EJ2QRI5ge7QEbfjdLI4pJ63sDkxse+xDnRuP3nWuuMDTNYqFg+sOuarwbEzmdt9QkqAPEeztPv2KcjzV88MCll4gcGhuv3l2zV/v69BQXrP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 12:58:53.2050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3b45c5-2b74-40f7-3729-08de85b74600
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000198.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9354
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 473A21C000A
X-Stat-Signature: npsifzcz4m6k3mz6sk7bhay5bbi54axm
X-Rspam-User: 
X-HE-Tag: 1773925143-831886
X-HE-Meta: U2FsdGVkX19bPtIygTFo2KIztWJbyNPBfe+6uQwGwyR66KTWBY3CPoeQTotqov7+qE2x0QC3ObkWjbaLRS3jx5gHmnfp52J7z2VFLt2dwWNhapP6WMGPkQaQ+whgm8r3AugW0LzrtgDfODRw0lhNY+ETh+cNgyaGGoNMLWP9ekJMci15llWkqb09du3GFywMP1ePjD24hq++LDXY+hRthRhxlBFIU4Ovdkxd9Gm43UjAyvqmALkOw3vhPncW6vKVlNshzMk0F3brkK3TvFPRzDl+YAtZS6bWZ4E6Ep/5sCL8IZ9znRyOjhV9AhFfEnQe1fxRZESUPUjBr3blG7DjZOjapTRICXVFrSz59w/rwm/7ytCzNdvADk2H1JAtHAZMMvOdVDSskQRN3JW5EIpIxB/ZNqjsRs0E2tXLBrBvKGUQJn9hNJ4n3JTIbafhfAhZ6Z6/CfYMCGasIntv7njxNS5rt37AhYqxcgtVLOHCITFcZU6qyZpGS3YGZEyhyLZRU2RSC5Bu4BPyIO/Xb7CewLzLdop5T0PUB26CevO8sSo3MgKlO3LQMWR7fv9DBzx2XeKSivRka77OywaCyBbbqxTLwwpViJEgU7t9VBTO+hEw9310y5zguQImZbyeF3k7pBEJV379EV7DyFH0vGswgplQU9DwZXZNd7YvxdVqXICOLKoIIQ1t8CLgQbVJ4Np+KyrRd9Ckj/g47qI5dywMX2zcIo0cA3E4auouFS2Ygdsk4Iq3o+nRaag6wwhohVaiS8BB/koNahkEOBJmpw/DtKwZVMlkYfBZbcqGR5oZluFZVR7sLMCPzrnS3kE8w0ta5UISK5ANVRjGLtMd/03owkb6Wc1Dzr8R+PvSBsDRNuG77Zi/lqdrR2WEkwcabJOuPz9fPVy4NpC1p9LOaqdvKuu4B99pFzj6EHi2ttfnz4caDeaBPZp7Cwcz44K06Vevg7+bhCQHbCfY01wgo8f
 pvC+Zzao
 tXR9qZ26YO37ucE6nMSxygZPyB/IqW2ej8K27ebs+Dh/nEWJ6IgYDE0jkd3nCWaAfI2Sx23JwLV6BDAM2xXF9thN+0E+0GH5BwiHnruRBov3JUTqxrS2eEUFdJ0fxvB3yP6316wlguLCY1tnYGH5essAxPnG5w8qffVv2Gy4PpYANamLM+ezBAG99APtTHaamy13SCMAl9n8yShntT/1k5h8fjS9e75WrzsM164NMzWMlmBdKOKBPvd1I/Tfmf0MfG3oH3AskV5WCYDVLmjXfgyEROHWf+px1Ub0DHqvh2T13dTv5+MZGxrFTjs2EaEPGSjtOBQIMQt8ShIxxxyEAFoKF2yiAqq5L1htVxNbUG6BESobof2gG3bCbkeRPYgDphbEitZNNyjV0PHqlQcef3as+D5dBINVRRZwQSl8JtvFNllrn5o5F0tnL8OR4/8luybkpWTp0FaLLlV2uh+PzgVK4pViDHFE4ZsTraXN6dGP0CrOVivfRW1SbJSBaBzQKuXZzrVpphCBoqHxYpxd/qQFWF3yVZTS2p+ia3NA0B6fiRXIVDFkFY8XyWPE/qJNVC5MmBqafdoXC9y8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/03/2026 12:22 pm, Ryan Roberts wrote:
> On 19/03/2026 11:49, Muhammad Usama Anjum wrote:
>> For allocations that will be accessed only with match-all pointers
>> (e.g., kernel stacks), setting tags is wasted work. If the caller
>> already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
>> don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
>> returns early without tagging.
>>
>> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
>> APIs. So it wasn't being checked. Now its being checked and acted
>> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
>> defined there.
>>
>> This is a preparatory patch for optimizing kernel stack allocations.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  mm/vmalloc.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a6..1baa602a0b9bb 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -4041,7 +4041,10 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>  	 * kasan_unpoison_vmalloc().
>>  	 */
>>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
>> -		if (kasan_hw_tags_enabled()) {
>> +		bool skip_kasan = kasan_hw_tags_enabled() &&
>> +				  (gfp_mask & __GFP_SKIP_KASAN);
>> +
>> +		if (kasan_hw_tags_enabled() && !skip_kasan) {
> 
> It's unfortunate that kasan_hw_tags_enabled() is involved twice in this expression.
I've looked at this again and simplified based on the fact tha
__GFP_SKIP_KASAN is zero in other than hw-tag modes.

> 
>>  			/*
>>  			 * Modify protection bits to allow tagging.
>>  			 * This must be done before mapping.
>> @@ -4057,7 +4060,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>  		}
>>  
>>  		/* Take note that the mapping is PAGE_KERNEL. */
>> -		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
>> +		if (!skip_kasan)
>> +			kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
> 
> I wonder if it would be clearer to just not call kasan_unpoison_vmalloc() below
> if the user passed in __GFP_SKIP_KASAN? It's really just an implementation
> detail that kasan_unpoison_vmalloc() skips unpoisoning if
> KASAN_VMALLOC_PROT_NORMAL is not provided.
Then it would be confusing to set kasan_flags to KASAN_VMALLOC_PROT_NORMAL and
not use it later. I've found a good of doing it this way.

Thanks,
Usama

> 
> Thanks,
> Ryan
> 
> 
>>  	}
>>  
>>  	/* Allocate physical pages and map them into vmalloc space. */
> 


