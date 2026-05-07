Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1546BCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 11:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4322E6B0088; Thu,  7 May 2026 07:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2BC6B008A; Thu,  7 May 2026 07:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA9B6B008C; Thu,  7 May 2026 07:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1842A6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:29:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B1F2404C9
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:29:28 +0000 (UTC)
X-FDA: 84740403216.14.CE75A81
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011009.outbound.protection.outlook.com [40.107.130.9])
	by imf08.hostedemail.com (Postfix) with ESMTP id C559816000C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:29:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o0P1Leg7;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o0P1Leg7;
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.9 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778153365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JvQBfhJNpN0XR39gKRvYHD+Ka2JO1yG87gKCJz4+CM=;
	b=qMPcZ6WpOnNiJ6rMfnbKbVH3FnDSitQCf4UnXcN+iNhfIZsvSOdzEuY+fOQLHYj4Q+yuIC
	54FOQf7uea2atTd3ZLXSvN+LH++W3mD0JipdDZ+XmRxfZCfpiWX+8OMaz/nYHP8nd7ffB4
	J74BG0WxmeG37rxAWgYkWwNfy8dWnag=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o0P1Leg7;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o0P1Leg7;
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.9 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778153365; a=rsa-sha256;
	cv=pass;
	b=wRwoy6jdEqD5oTnq5mPz0yXtBxurS/IObvuWFVtcQZK33hK9ZbIko89izcwgXygDKneFT5
	meRyag1ya65W2U3cZUouwb5muo3Dkd0LQilICujqwUL8KSXTnUhtzS/ClI5p/aYLeib9f+
	7LDkhWLZ+W+4b7pRJqPlI/shBTUfz58=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XkF8jE8ynovcbD4QJXElJuNyyJCBwm0d2nB1ekCbw1n3OHOnyxf/HG3wpRCUo9Z67jV8OwVKzRhaBf/5l/HIrERH2zlYnbyP/NyRSaQ+zHYpJwj/l0i8QvMyT2DP89yU0AvxHmswFuGIOcRyA+brY747QVebbY2oFaCLblY6onDEMfbmaSnp54phDKS8dxsSu3QKjZzZuTZYh9iKIMOAJIz/PzKMLeZdQZOpGTx9FWABTS9rFtv8f2IKPWBTt0X9tKzTdIYb+/sQu9qEmaj6YqVhktc6HlpGXuUKmOXwx3uWdPf1QGS4YRMKEev58G78VtqWfqSYW8uaCkEIw6W6zA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JvQBfhJNpN0XR39gKRvYHD+Ka2JO1yG87gKCJz4+CM=;
 b=ommvsOkIytC7DwNQZPZbLT7aPB9WUUjOtdkpZZ78xnJYR3CQa5JDzC4MN3vO5A53s1SeDnZvkw8u581CTiMa23lq6Mhig75npS8Skq1kjl2ySoXRwZKTQQRrfpfOUEEAmwWmK5HaPm8nSseegi5sDkbvdzRtTpJAQqhncqbcdcB/0eMnoSqIWU7zeVvchlolTCneY1Miq+APlFwijxoTpOdXqAt0TA3ofHirn4tdSMo+b8l3eR0xGyJ+lgBgrIByxHx/nFAZreUL84Amwuvy2tmhghmpbHhRh0fTo0twauWP90k7df4yLLsYnF57vS42y3NI85EukyUevdkaTDn+cQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JvQBfhJNpN0XR39gKRvYHD+Ka2JO1yG87gKCJz4+CM=;
 b=o0P1Leg7KyKgjPtv082v6B0F3wZ7JE9KtL09aPhUWE3iarm5nMVsZIpLQ5D6VYekr64yvPPlcQHv+FKsUQlbijMe9UzfVWtJTFVzkEmOFheSFMnnQxKdxj9G8ct8k85uyrvXgv7pA9StIoG5GbKaTRbAd7RIqAyAEym4y6n9cg0=
Received: from DU7P194CA0002.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::33)
 by GV1PR08MB10534.eurprd08.prod.outlook.com (2603:10a6:150:160::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 11:29:12 +0000
Received: from DU2PEPF0001E9C6.eurprd03.prod.outlook.com
 (2603:10a6:10:553:cafe::1d) by DU7P194CA0002.outlook.office365.com
 (2603:10a6:10:553::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 11:29:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C6.mail.protection.outlook.com (10.167.8.75) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18 via
 Frontend Transport; Thu, 7 May 2026 11:29:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+MpnaA61Y+S2Arht2050vfs47uWcQeCS/NKGvGI3aSnBnwFHGgZDqijetAk2m6cYg62VUmpC61v/EerKPqcn+OnO6PhstB3WNXA6LWTKRkIdDhX4cDcGBdTUhxhtf1qcRotjrT8hmcO0pLRcLSpApsKuqyBgFy0tg1rHvwt9QZYbmK5jFIRpfLuJ20TUTqAuNh1xmhXsZRb0Y4C/iTOGjxHm4giivDzTkKIX8xOwqcD1/0ndqquxmXtj4zxqCHoXDwufO5JKYyTO89mChrSZ7G+hvZbEd7d4bS3IjPoXbmixdc2XpW/SB9uOsj1L2RURpyAUxSRA4W7ujlt2c9Qdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JvQBfhJNpN0XR39gKRvYHD+Ka2JO1yG87gKCJz4+CM=;
 b=xl5PK5swbTQrmTheSlfglVSm5XpY+tZ8oagJYrPJkHfZ7s3CB9dzd03+uMcDmrr5Lt7cl3OsrVAmgyibd6dJkiiNvHja0gVQ8DJI/Cs1nDCUFozvaeyeIg/PgAsv04XOqHH5zvYhL+aqrc+eRUkm7mK0OVPmeluL1lvy5p1ApwPv6ackrO8PTxc0BWS3WDmwdw+ZAgPeGsXfEuC9P769fVnyMW2XSQoh7JLCxeGt73H8J1+EVLARhIFfoUN5UAJOzKcewCRGE9D6kSLUxJZ2/BuaEBl9xa8dZyYJDHUQEHftXVhh6sU8hsghkywjNJWkFjgedmmyCXwOKZbxjxOGVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JvQBfhJNpN0XR39gKRvYHD+Ka2JO1yG87gKCJz4+CM=;
 b=o0P1Leg7KyKgjPtv082v6B0F3wZ7JE9KtL09aPhUWE3iarm5nMVsZIpLQ5D6VYekr64yvPPlcQHv+FKsUQlbijMe9UzfVWtJTFVzkEmOFheSFMnnQxKdxj9G8ct8k85uyrvXgv7pA9StIoG5GbKaTRbAd7RIqAyAEym4y6n9cg0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GV2PR08MB8271.eurprd08.prod.outlook.com (2603:10a6:150:b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 11:28:05 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 11:28:05 +0000
Message-ID: <3f6e4282-d745-437e-83fa-81a84f2c977a@arm.com>
Date: Thu, 7 May 2026 16:57:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 43/54] selftests/mm: hugetlb-vmemmap: add setup of
 HugeTLB pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-44-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-44-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0213.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1ab::11) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GV2PR08MB8271:EE_|DU2PEPF0001E9C6:EE_|GV1PR08MB10534:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ad0a9b7-c0dc-40f8-c33b-08deac2bdc7f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 DI2UXDWlIYcDgZa1cmtH4ZCtpdxX3K7j7hxSMG6HZaQp6dHpJBTZVmfMTCqbku+sQ4EQrkUhqTMxIyhpGZgXiZWXM4OzEU7lOaEAu/GfQaf0zvgm3YZlReK1OloA2ZXoQ22ImkpHAS6iGAmN/8l12D+uh+gkzKe3EEW8KM+YatkTceXArl0K7Io00d5czYn1jNz/f9N7B+ADbBBXqjVoFtF5JfhtF/0x1gW3w0rVX1WMKnp/6+CEaYw8nqX9YFMJWRbIqUWEg8TUmvoFiv/QyPLh/g9lnE3V4i8m+RGogctm6AySATvqiVs/3Ojd5sSso2s/sWkCVPe1u7LcgBWWBWDWsgz3hHdjloAMRK98eEJi4TEkw+8r34i36rPZz+pF9Nv67JNVfIl6tuxJqgYVnBJqFt8dnKH3Zn3f9ZZ8n1Msydm4s0TpJzeaB6ooiV6HDK8aO72ioI1jGm8UQpRQUxiWKoxflPHmO4NIEZA9NvwI70lsl3BQR9+WvG2G4ARB8lzwU3TBIypAgpUEakeTQqiQvAe1rkTn65h5bbJ4j66dqquraKavxXfno9abO6vU55vdUoIYZYKbGsYeOAYq479Xye6UGSCkXLHIHx29MyWwvU3tRRpLDY4Ko2Cvo5FFDiAJT9OB8rdSlc04bi7vFov2AMsdgCQbX2kN18coB3GZ0IpwITzf+hwT14noKU3b
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 rlQL8Iww+G3xVPTdGUQ36gXq6tlxXhhz1hS6y68lFWA+OVG6kpZloOpkxzCHuTtwW05SbfjYPYbAOVucadOoxGweK0dObjtYTQ7lWGOA2GJ/82yPPLQ7PnwF0YCvNUl/ivOsT3OTq4v2ip7Qoq0NjhNksxzPK0PqgY3Q5RAuY2we8Q/9ihvgQrkLAZc17PJ1cbCOEw+K5J0M7u4AhGyZS+IIKpeszkk6190OH2gV5NRgTqCdXnWEOjkYC8ZSER/O41mV6beoEIfZTpXhCrKeYfcv1W3NKgj/t5tsqEc5Ko+uXIZhHTw+8rVy9yPf4iJxfufp7/0b7ilyJd/NwDWpcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8271
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	04d61cb4-e51c-4b1d-bcca-08deac2bb491
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|376014|1800799024|7416014|36860700016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VprgmtcdAauA1XgIXnXOa2kcQKLlq3e3C6BgzsQIMceZigkKqx+ZLKrEAOItHu0mXvnSXXCGQArvgPN/vhr8wPuAzs9qDaxi2/kwIbQiYIm02nnDbDPA1zV6fOw2Aeyk/OlyXLeHog9AzpmCXsKK4XsaAExUzybNYuTlTh5YWzroCCfhjPf83O4ioq3zNN1TE7Fkpp64e5aSEwiYu6EoyDSG/j5vVr8QJ+O90ilRiSQVmWfeXmKS0jG09iT5/7/VCsCeIFpT7quNzA/BoriBins+oqqSPQSV0XZmJZFk7VGOym71jwO6qZq76rsJ5qefgHZtxKWDUum+1u2kwDFifnXnDEjHuqDsiqfRFM/DczkMkOaeqPTjyHzmHbUL5tW5UNSp7bfTXk+DNIln/NZxsiPJ8wzCNyrCfExJ05csRDq+Mt9+IkOIM65uDsF5UvyV1rPICJNVuBlIhCbyGlHbh59uFvkN5pLmQlgSAFgW+FQdWRgMUHJ4ZFjwMwuLlPM0MZnxkH5JlHzw9CwDrtjVgeTj3Dbg2HP625np1i26JUB3x5aVM0mHth6JHEE39BkmLzZVDtZmz11SvIH1b5i4/+VaR4P32jge8t8oarasWjNTyTfZDI9YFPHHKcVQpSkOyuWWY27wCxvihiRpW0pcse9aUYZt++3saZZWJ+YZlIeATJM1E9dFaBAD1XwboBtOThwIGh0m+ybfYDdO2+6Dv/cpYKG0q4EmYvjtvvZnhCc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(376014)(1800799024)(7416014)(36860700016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m99CHo786pP4+YR/cIkmbtdrw7h0kFzZzOcWZwLCGp2rvOcs8s1Qdf8LBoH91UmfFR9ljnCQzs+dzF0R9hUPJ6yFSXUho54Nk2LSpAFdlida7vuV5SQSYxmiOP5qAadjtTAsN6seJuyZfPuDndqtTlby21/ZjyzZFm7LaDbSnLlBBWYs1XS7Xp+hr25RozL07ZMx0ow72REpupJAwUljU0CTvpk9tzBOv2XyUKl81FT5yO4EGHEt9fGuS4WbSZw8BV4Hjc4b31vWDDRnyUltkbC6YEPK2EV5Rz/NO40k4ZIhTePn67/YkiMlurJc/VLPYBr6A/RSrAjkMy9UzKH47jOyvEMfW25uvwEmRKgda0Pfs1BpizBU3fgXFgVGF77VZxB1h5u0JHi+d1P5jGdZXHdV1HPwyrRnEoVFTjapp6165tJJekXQUEekawxuu0nl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 11:29:11.5113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad0a9b7-c0dc-40f8-c33b-08deac2bdc7f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10534
X-Stat-Signature: 5s5gnu6zcj8csiitzkqxe1i3sdmy879f
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C559816000C
X-Rspam-User: 
X-HE-Tag: 1778153364-743298
X-HE-Meta: U2FsdGVkX1/nJzllmZLZR0fTAIrYx3gJv9m/wFR8no3veb2EEtKfqkna+vKAmF0O/iCIi93PGc+65cOUUQN6KS6cGUHZ+yRn+WxrnHHiBeL4JAtWWSLGsvK40GwvV6vVs3vYxCOrO4F5AaSv3R+QjK8I3o8F+Iugkk9Jceb+4chuOwkSj2OuGibZb45nmWrZNbnH4tdwH9m/kLuEGh7r2gLzS7tIZE/ctZYSdNBkYxow5g62M5e3Vq+hXnOMSreOCmVyizCTmJ/L7C0zkL7Sq6peWwYB9nONUKCRnJHyJYIyhvHN3Mi5xutUZllO9F66tJsMqmC++AVuSoZnld6T9umSMaH2LkEPtyf2+xsUtRqzqqN7FJCWpw9QYWXzdhhx2hp2PTaFd/uC5j8Aq4qEnpycF6dxSR3vHS0dBw7+tf+PFI8qz5RZtohAoNVZM22zxVtYKSNH4f4dzcMQLB/M6MxWwS8FzrSU5lrBY+a83zuuRV00XGEVmB37Kr/11uOhMTgsojxL8uBazCRdgEPZj32nz/yonL67rCGbiT7ciEvAv76kLCfXgkEz3JkjYSVIwTlkaSTAl8DGjiDsVKPaPoOOw8W/Zmr9iAIrTyEVn/iyyOu/pt0EL9p3JsVDGfjztit1a+S/8J8Jcg7B4xyYzu00MJWv7cARUgGeMH0OoP9nRyf8iLHEHpK01gM7xg3Y+u2anP97SG+JB1QAVzEZq/XVNQpTxWiYLm2/hwX4uV13YJk0udDjbCSVucBC+y7KdKpxDwdi02pONQnfc+cH8QrcbqiiVuodfRC9KWR5wMglAUW0VXbDw5+skFeWGANbD8cicPrS+Uik7Po6R2yh9J4cf/nuq2EFGy1Dtw3FSaob5Tso6qnlaDiINj2iRCL+7/cHXd+CadgFSy02UEPyh7Llc2XjRUCBGQvROwVE1K4grOhW1iF90bVHuWDWuzztGP2CYWerOVSEM3adx6E
 qpyM99x8
 wN5B5xBuvQC8811Hc4ik+L0//9IhUH8nKBGNqBpa9olUIePyygJfHKIFYFXxK/hOdW626yOYLUsH/k3jzII6COptHkeCGDpbvyBzjST/LF977MNktqyUz8tcSrNxQS3xRgunVtQXh++B2WkkozjH7zjHBUky8mVIH1gB+zGtY+cmF83Mi00/E3EsE1ddrFLONIwzOlghkd5Z4cqhp55PeVa03So84tG9kEck2+yjYfo7+1PvfJ6sfZRpx+a8BYfaM2GwJAmoQExnWE8qQlCfDJa1jwG05UtP564Y5ElUMOtefs3hxN5K93ErbRu5dWjW6nf/5HDojfr7vYbK2aPhjWYIPLFjfNuMrLvNeHWvVA6QbCBknaw88W8DXow/tU4MvqAy3e4g04JjdtgIaLYz0uOZbP6XLT7DY2Xu7Jc4zR3zX7tqJQfI0YhkDl8n5QC1CyF8DqFtc8CzlyaaS5ilHF3KmnbgJGcX+RcfzBv03/Hz0mPePSoOr/5rUr3z41rOkoJq8QLdxqxEUJjQyeQfTl3LSOTCYJAutaY+65mVZDz7dEVqZKgWbvCoeIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb-vmemmap test fails if there are no free huge pages prepared by a
> wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run the test before and after applying the patch. Before the
patch, the test bailed out with mmap error if there was not exactly 1
free hugepage. After the patch, the test correctly allocates the
hugepage and successfully passes, restoring the hugepage settings at exit.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/hugetlb-vmemmap.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> index af5786bebfd1..507df78a158d 100644
> --- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> @@ -97,6 +97,9 @@ int main(int argc, char **argv)
>  	ksft_print_header();
>  	ksft_set_plan(1);
>  
> +	if (!hugetlb_setup_default(1))
> +		ksft_exit_skip("Not enough free huge pages\n");
> +
>  	pagesize  = psize();
>  	maplength = default_huge_page_size();
>  	if (!maplength)


