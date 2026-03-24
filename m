Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEECAF54ACF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6530A6B0092; Tue, 24 Mar 2026 11:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A206B0093; Tue, 24 Mar 2026 11:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2346B0095; Tue, 24 Mar 2026 11:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3DE6B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:24:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E98CD574ED
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:24:09 +0000 (UTC)
X-FDA: 84581327418.12.93D326E
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012070.outbound.protection.outlook.com [52.101.66.70])
	by imf27.hostedemail.com (Postfix) with ESMTP id A089E4000A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:24:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gjrlVk8a;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gjrlVk8a;
	spf=pass (imf27.hostedemail.com: domain of David.Hildenbrand@arm.com designates 52.101.66.70 as permitted sender) smtp.mailfrom=David.Hildenbrand@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Authentication-Results: i=3;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gjrlVk8a;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gjrlVk8a;
	spf=pass (imf27.hostedemail.com: domain of David.Hildenbrand@arm.com designates 52.101.66.70 as permitted sender) smtp.mailfrom=David.Hildenbrand@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774365846; a=rsa-sha256;
	cv=pass;
	b=Qv20TcSL9atZxKsG7VVWyPzDyvcZk/kb78cU0PJQOevWtK6fvqjh6XcZqqk6ThfpMFjbG1
	dNI25tzddA6gxM/zU9SM9G9NiFS1uoMaGTQwPMoCjQcMP+ybtTrdRrnuceZrGILyshqedw
	SYFGp9knGt2PepPpHG6uCVHmSTpQR3I=
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774365846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F2RHjIomhgDB6RmlecN+Po9cqQdiKl1FUpdFx4Z8RU=;
	b=B4NAUqBjMh8F1GffXD8RkxLOEIPnK9sHX3OyswtCUZoL3kuv/jK5LOQtt+SK4Cv/q3JUY8
	y+wTBXWMqnULG7A84V3UJtTzTRsR80yQD9clJmLg7pGtbym3Zn3K4jmrMmKFujZLEWLjPL
	sz+GSW1UspmZI0OgFMlK3isnfL6Q34I=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GlOF9ISL5cuIk/LalxRAWNjnc3T1P2x5aV3XyspSm8MbTrU0XUA0ATh+4LiylVqjp15jLkSQneIKWQS48vRwp3VHTzGrqg088E7Rhmbtq0RiINmZLkZijssmvZO+QCCIxN+zRF0LT2zz0smi6d5YwaFYUVcMOGv81n2kiRw24o7Ww0ciIw9LrJ6VjDtEQeSweYLv2juC7aOm51POj3xlGHoE6Jc+j8X/bfnNNYCCdxeu2bK07YreRrIrZWArUoPwAHPZZ4Wd5bE4hT/vKF+f+qWOjBFBjp0/KsrcYrLCwmJ1tiGixn0A5WlVqzbI0uF5cPBbJdmKug8OKXKayL0rsg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8F2RHjIomhgDB6RmlecN+Po9cqQdiKl1FUpdFx4Z8RU=;
 b=pbpR9ILtJtURwjScGAI6u4HD9LDTh9XuWJUM8qh8ZAvP2BwXLEuafrx2UUs95V/YQ3USRzWXGqGMsR3fvCx19tiuOkm7dDRU9Qwt3y4VLDkN2cZhbQWCLUG+T8lUum8AyhA+kE9FagvTCiXQO2kgoJJe0cqQfIQQYlJZ23n96XGe1/kqhWVftyjUwhJSTwq+fcgJphTW8ASibPX8xVN4wMMHurjaeb7xaP40WMckrPv3Peio7qsS909hjT+bUlNQW4VjHl5HVmvkR+VBzSb6xajVWTbFa45lHgolksjliv14J+tnEBYEw9di2Ogd3FY1bXqnE1I1qOpBZAnogBs+aQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=nvidia.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8F2RHjIomhgDB6RmlecN+Po9cqQdiKl1FUpdFx4Z8RU=;
 b=gjrlVk8afXgL/a/OLh/XRgiIWny4Xa0ijtnLpiJT2JvjXfH86tHM+KtU0203y4ujyFtmZYGmY1djxpP1H/gZ5AvesIAPvYDoZJXeXcS2m8XTxehd50YwAO5TGqorh5byuZCdcjIfTN5Hg3mgrUh+U1W1yhBat9B4dBJg09led2Q=
Received: from DUZPR01CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::6) by AM9PR08MB6258.eurprd08.prod.outlook.com
 (2603:10a6:20b:287::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 15:23:58 +0000
Received: from DB1PEPF000509F2.eurprd02.prod.outlook.com
 (2603:10a6:10:3c2:cafe::b5) by DUZPR01CA0067.outlook.office365.com
 (2603:10a6:10:3c2::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Tue,
 24 Mar 2026 15:23:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F2.mail.protection.outlook.com (10.167.242.148) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Tue, 24 Mar 2026 15:23:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FW3voBiHcjIl2c9pcOIS/RyRU7kwUs2h1/E5eEftParN6X1NWlM3NUD7A2lAqbezGndOtuFuAIMGNfbuhdbTIjqQZpr01LkkqWVx2UIqAGjB+FLACcHBugdS1Z8f8lvfdZUcOdw3j7DHAOh3hgnQ5x7PTBk1NYoUcWSdO4zqVcvnYsenFlx6E7M5ocvOcHtKKJ4nxLLS66TWgeULV/+MArZ3oWc6rAGnjCjtxdKEL/nA5bLybbvsIVX9GThApKJJ5h/YCjRCRpYxJCwfxm6cxZ8QaUoS6cG3UlnO5+qgAkxMVrc/39JE0HRFeeC3TLZran9D2HZKNKgWq1B3xlGS3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8F2RHjIomhgDB6RmlecN+Po9cqQdiKl1FUpdFx4Z8RU=;
 b=JalO280rT1xEHiQqiQHMQeduHYCdyUu2bP3hWbsnLKMa9y3YLteTF5FPqqFtJwXc4WQsfSVA/VRuGcFVXDZFeYScqIwlmhGIxSXIxU9W9XlpmhBCZTctjn7yT2vlbjZB+G4lyBHDjZxQw9kEC7edJlQHHGUHbXLo41NGIS1W/EFv2rL7oIQ0YZCDLLt9Z4bFU+P+4kvBEoehtyRa8pqLzAYoQmkfOzCgWiA5n0WUzKResVYM43wv9ghOz9xcJqy3RPjjg1uJKRfQ9RvFF49VHdnY7FyD82vfxGifNfW73GNWmKrgkeBHhSbRxqmftaZ9GhyuI9VPZgS6gx7oUcVtvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8F2RHjIomhgDB6RmlecN+Po9cqQdiKl1FUpdFx4Z8RU=;
 b=gjrlVk8afXgL/a/OLh/XRgiIWny4Xa0ijtnLpiJT2JvjXfH86tHM+KtU0203y4ujyFtmZYGmY1djxpP1H/gZ5AvesIAPvYDoZJXeXcS2m8XTxehd50YwAO5TGqorh5byuZCdcjIfTN5Hg3mgrUh+U1W1yhBat9B4dBJg09led2Q=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10955.eurprd08.prod.outlook.com
 (2603:10a6:150:1f0::15) by AM7PR08MB5510.eurprd08.prod.outlook.com
 (2603:10a6:20b:109::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 15:22:55 +0000
Received: from GV1PR08MB10955.eurprd08.prod.outlook.com
 ([fe80::96e9:fa4d:1917:7cc3]) by GV1PR08MB10955.eurprd08.prod.outlook.com
 ([fe80::96e9:fa4d:1917:7cc3%5]) with mapi id 15.20.9723.022; Tue, 24 Mar 2026
 15:22:55 +0000
Message-ID: <88ff0f5b-e6d2-400f-9316-4863a5d169ea@arm.com>
Date: Tue, 24 Mar 2026 16:22:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/page_alloc: Optimize free_contig_range()
To: Zi Yan <ziy@nvidia.com>, Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-2-usama.anjum@arm.com>
 <E976076E-68B6-4088-BA67-AF4ACC0D3E7E@nvidia.com>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <E976076E-68B6-4088-BA67-AF4ACC0D3E7E@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0356.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::20) To GV1PR08MB10955.eurprd08.prod.outlook.com
 (2603:10a6:150:1f0::15)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10955:EE_|AM7PR08MB5510:EE_|DB1PEPF000509F2:EE_|AM9PR08MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 59a96fdf-3907-42b8-2f40-08de89b95e8f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|10070799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 +Xlrk4ylxB6LGALhbzp/trXDDll5OoSI+GJlPl1xamotf/z2fynM3eQnlXuzVZZI7RJQHCZBvHNdsTzgjNSiNTNgZ524cUkFnVAmS2PxpPUkQNZZkNjuvAdsEJdMQcZUVjvH5XA8Y39MbFg19ZUeuJhJO9L+L0zHYjKQ2t7RKITEogSj8V4T2nk+Zwe68zTRHy4oraYZfjXd8s9xN3WrttYvLihF76+5SWQmbR7ABpfz+NwIkc6zh38x2XhXYFeLT5E+v0IIAQ7t06K1arlY/m3FwUwdpLhe/BLs0mUabuFr54pAH72x49AzC6VzNEWu1GVr90N2yRIiuxyfXuRWyO/QVL6BtSAvxJ+qkaIn3RNdZuEoNmJXUFaUjdvuMMwNa67iTE1mq78EBxILZOszzqXn/tMHgVSc1LKebbFi2g0bTX6eIZUHaRzbwQKOaUknICfCSvouu1RdPy9QqO8ViAYlJI6YM+XNSKuZV4Wy9x2PZYHE+Ys9vs4g5jsvpxE7XhVQG4G9gWg4mTzgq6dnk9/PQYhVxfRTihgNjSxzU5LQtpd0Oq8zvQWB70YactDkJr+zmpjX1TBNSdftHE0kDCcpfE2RuqiVSk93DsLLIOboT4e3HbS6+/50EsOls44ZKdR41IZJ9Y9K+KUYpXEH0fO8VpFlspUVqGPYWY85GF+rRc+eQgp7uQIx/MOdcJOMpj0GoTKLQoUc0xi9y/FGzD4iutmN1JOXXXECoXR16fg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10955.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(10070799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ZOhcJq3nmcLeZZbyCf6EgLNr8bU9IFcq9shLttZBN2pr01GIaubMO6AJ8mxYOheRUB2YQkxudvLsaeofp3Lfre6AdQCS7P2PRw5Bv9rZSq313tGYV8fp/d6WNVgNiyQDDtsHtEZLUKp8qsvz0+xoIez+WXQH87zsBrVjC6c7VfODTIRkTKVIWk8OBTDDdqTdoAX0eLyTXHfqLXc7uUT5MLPIAxV2NWXAFPy6o6RvBEU9QhG45gLdiO279CATDlom0aTwTgSJ/zOD8cyGcjsmNhWJNN0VnMopm9B9cBz44GiuNew91XDKw7lytZ4zjXowXcFPqVMwqHfgcPmBtPx6Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5510
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	946c08ec-cec0-42f5-bb7d-08de89b9391e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|35042699022|82310400026|36860700016|14060799003|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mj7uBu9oBWqi8K6oOR2RowgRWnq0PWvI3chEgMctftPWgL0Av3LDV0BKPccK2kb6SBmIoyvF8FSxGQsg5NepqDECqbHhJ/ORFkArgSTDi9SGJZL8CxGAKz+PhqdESy1sTgKN7RbJRQiVppHlK5WucjY1yZM3lPQ26JJu5cZw2ica8QiqOM9iLDj4GsBwEj67ydLYL9h73E6Xi7s5K0Gzt6elpdC42pvDd9KnDpdSMjg0Wk1kRmZuGMCUvybTFKvoajECcigNAcHv932IWZswbpx4AAk3ZBhEMgVPHTha+MlMSQ2xxxaXkJDGto3k/G7SuIjM04RCSmOkzzfAWjLZyNKkBbNZ3Z/rbH+1Q2iSpGTf/GWpy817dv4Ya5dt/qdXIK5lQ0ALbTzvZwkgTW257W4a2rkkdwtfRc/us9GxQxPQCAYVDEdYQnQguge9e/NLggIRcD2S3LWtUeKL+bzhcFq1/Ndfwzd4VwSgRHTKwG9ikATylD3UZ7ByzkWu07hl1dwi9i1fy40Ru2BSo1of4mRqoYk9Pi9h5RxYd+9JksJYBkyU4ZSTzJtLHgjutB5ZhR5F2Ia84B/zNcDX5VePYejHvwe4sRxaHvx/2OaQUHi2jrrBJZDDiySlkrb9sTgbR586R5A/coxVqw83pFocwRn3l/8wejU9JjPd0CF0gI1W59UPFV/zZ3AHpT5ECsLSzE/Zq3BH5u9sBEhIm2kVzhYtBa2irXO/OH0on3C0kVKdQ0p9vPxC5KFx41rTP9JQbPXD93yxyQzCJrJkhOLNYQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(35042699022)(82310400026)(36860700016)(14060799003)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	k5eUU4T4Sq3YrxPkS5jelBl2w8RnaVFVDgmJFuLkXqmySsbqQHS9y+jBkopt2G0n8XNuK+3ViFK+d/lLRwFZZw7vxioyRkVAs+tiy6vc57xTO1c1TFZozsaqLfbKGyTQ38c4DDhbzqahENKW+1WUOpJXk2QczlWt4+tVrngD660nLR0p7OKAcBKMFTDwE7u8Xtx+5NbjwVO1SeyHXRlWz1Y7ySgQ7ZW604YC10KFW6Q079f5zRdjAVsqo72pPUVVUDGqTk4q9ZBMWpeHy/MgDGhUzAbDcPnJfa/JllxnY0fOnNudP6eDpriLbDdklp/FVHPlrfR8kDs69GACnMXFt2FAzTwrPiiaEqQlqQBYM9oKPZh8C6lwUMZTwnCn9WYnYJPRgyEDjQ2xmT0eFCXABeK2ymWttEB9UsbMrMCyaBig6c+w81opVSo5qzWFMTZp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 15:23:58.0374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a96fdf-3907-42b8-2f40-08de89b95e8f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6258
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A089E4000A
X-Stat-Signature: px4mxs6gexz9sdfb1k17mskg6y4ajxd9
X-Rspam-User: 
X-HE-Tag: 1774365845-127445
X-HE-Meta: U2FsdGVkX18KZEEZIJH3t2VcNTKLQVuUgsxrYWGqwd11AuyDK47mNhMz3MP/jfSMlRIcryT09b5JtgCwRMw9i0aTqG4e/jPFR29FTwKEcpkapgMyc1GH+vOnfz83AKhmhK0804QZqTxPUYIiIMDMok5Y9f7hLyqcw5bp5xMe2hZ0tCuNaO5bz8w7jmdokbqh7nbxKQ78tBtonpuDXBtuv/SqC/PLi6n+ZFtSRG9gBxa1EKetwv1tAor9n9o+m3Lnmjf2ZDnyfaUY8NiCamd6JS1HYDsFDJA/sSb0bMosUNCj+RMXSZOeyJtXaRAuTyK3o8TQGGZlsYykGBpyJz52pyNzeb2gQN0xFZXEB0cOLpLEncqFFNX99I75RJsf2Kc9WJLbgo/KuTckkd6NChVkywTOz8jaWOtasUKs0+q0g3sStny2VVJhieuT4YVhKufyVL3QDV0KMlNkOSByEkzU1E+ebyBXZdZc5MV+KCxBOdoi6vhKhEY5ywIBxeFOikDYSDybExiAwHCl+QtfvP1bzgevnAauxEJBZhKxGA51lxmjnppSXkJdvwFBwzhoTfM68MvMpqwQxHFD59hRLEXuubWpv7Xzvh8vhRgbfHSJ4RjtcEyvsTozEOLCQVmZvIv7Rsuebl2BMZ96MpC/+/5cYZKrsGTmpw8iRKKWRBTkKJstdY+MA+yAuEKs5dDIrsXbPXWXmuaNSZUjwQNR20xjqF5mcJtAcIGFC89CepNxevXcmIaOisZ8tJtlrCf+4Rbsy3dLL55BiLOGSRf05Q4qt6MvzlK8+Uxzvf6DgXGJFEigV6MA8Vziceul4TqHHh2oxDPmMeKTXc8V6bcASoa/oHGRC5ucNq8cs/CwVJQ3NpwvbM6rs6IZHZ2waY6wbkPWcfyYu3zTdL0ZWdYDH5xeKwmDU1liGf2RlsTziPt3JQuRXmIlmpE3Vmtc2M/M0ik7pdZ9yPDPSn/8jt33VnD
 dAvs36+d
 Oahb+Cp7ZkFjGLYIH7eUS0G8xn1/HY9QOoR/PxhsVdXd/Rmq11j5KPO/Fy2WhsSXGTfBP6QWTrPApOnKjz++6dKJVWw5+HqFCcbRJba6kRKPvCSwtJZckLCMGszPuTSDXKjRcI+gF+88YDrSUFlgz07B/UuJPC17/dMyk5pVb2K3Kiy8/o1FlIfom7Turd/u3bwN8iTheNUBM+vzCw+TeKS409h4UGl7qnPNvfnZoJzAWI9tU783jxmid9uWcjoyqM5QuoVdzhyPLqva5GSmDqE32dowSK/hvlZ4SvOkcue8GbRYuFm+9aHZ4hwTEbZTqGiGA9D2aNVQY9aqEqIInzgJoNfKR6UBMmB+YEQ4lh1Tsv8izG7skvCvkiIiyk8XUDuD5OivsizKh2ohau+x1ibZLhS2mHydYICkpMJeCEIEpa4pS9ak9KDzfDFP36DBaebARzeD0ObeCf8JwWtrz/A8f6+7/9ZLk0JA5Qp47NwToqQhNhEbGpqizMqkT/R6yiikHpADAtMuvYOpuOYDsmYPbifSxBTUN149y/MbNS2eFPpAFiDYb2ew0F9BWSAMDTDtW+4d/2Gqzw9VkQgfNhF6jvYMBNqcq08ktvOsonGVbKxSHgg/VW0I5Vluygk9+Mx5V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 15:46, Zi Yan wrote:
> On 24 Mar 2026, at 9:35, Muhammad Usama Anjum wrote:
> 
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Decompose the range of order-0 pages to be freed into the set of largest
>> possible power-of-2 size and aligned chunks and free them to the pcp or
>> buddy. This improves on the previous approach which freed each order-0
>> page individually in a loop. Testing shows performance to be improved by
>> more than 10x in some cases.
>>
>> Since each page is order-0, we must decrement each page's reference
>> count individually and only consider the page for freeing as part of a
>> high order chunk if the reference count goes to zero. Additionally
>> free_pages_prepare() must be called for each individual order-0 page
>> too, so that the struct page state and global accounting state can be
>> appropriately managed. But once this is done, the resulting high order
>> chunks can be freed as a unit to the pcp or buddy.
>>
>> This significantly speeds up the free operation but also has the side
>> benefit that high order blocks are added to the pcp instead of each page
>> ending up on the pcp order-0 list; memory remains more readily available
>> in high orders.
>>
>> vmalloc will shortly become a user of this new optimized
>> free_contig_range() since it aggressively allocates high order
>> non-compound pages, but then calls split_page() to end up with
>> contiguous order-0 pages. These can now be freed much more efficiently.
>>
>> The execution time of the following function was measured in a server
>> class arm64 machine:
>>
>> static int page_alloc_high_order_test(void)
>> {
>> 	unsigned int order = HPAGE_PMD_ORDER;
>> 	struct page *page;
>> 	int i;
>>
>> 	for (i = 0; i < 100000; i++) {
>> 		page = alloc_pages(GFP_KERNEL, order);
>> 		if (!page)
>> 			return -1;
>> 		split_page(page, order);
>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>> 	}
>>
>> 	return 0;
>> }
>>
>> Execution time before: 4097358 usec
>> Execution time after:   729831 usec
>>
>> Perf trace before:
>>
>>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>>             |
>>             ---kthread
>>                0xffffb33c12a26af8
>>                |
>>                |--98.13%--0xffffb33c12a26060
>>                |          |
>>                |          |--97.37%--free_contig_range
>>                |          |          |
>>                |          |          |--94.93%--___free_pages
>>                |          |          |          |
>>                |          |          |          |--55.42%--__free_frozen_pages
>>                |          |          |          |          |
>>                |          |          |          |           --43.20%--free_frozen_page_commit
>>                |          |          |          |                     |
>>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>>                |          |          |          |
>>                |          |          |          |--11.53%--_raw_spin_trylock
>>                |          |          |          |
>>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>>                |          |          |          |
>>                |          |          |          |--5.64%--_raw_spin_unlock
>>                |          |          |          |
>>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>>                |          |          |          |
>>                |          |          |           --1.07%--free_frozen_page_commit
>>                |          |          |
>>                |          |           --1.54%--__free_frozen_pages
>>                |          |
>>                |           --0.77%--___free_pages
>>                |
>>                 --0.98%--0xffffb33c12a26078
>>                           alloc_pages_noprof
>>
>> Perf trace after:
>>
>>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>>             |
>>             |--5.52%--__free_contig_range
>>             |          |
>>             |          |--5.00%--free_prepared_contig_range
>>             |          |          |
>>             |          |          |--1.43%--__free_frozen_pages
>>             |          |          |          |
>>             |          |          |           --0.51%--free_frozen_page_commit
>>             |          |          |
>>             |          |          |--1.08%--_raw_spin_trylock
>>             |          |          |
>>             |          |           --0.89%--_raw_spin_unlock
>>             |          |
>>             |           --0.52%--free_pages_prepare
>>             |
>>              --2.90%--ret_from_fork
>>                        kthread
>>                        0xffffae1c12abeaf8
>>                        0xffffae1c12abe7a0
>>                        |
>>                         --2.69%--vfree
>>                                   __free_contig_range
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v2:
>> - Handle different possible section boundries in __free_contig_range()
>> - Drop the TODO
>> - Remove return value from __free_contig_range()
>> - Remove non-functional change from __free_pages_ok()
>>
>> Changes since v1:
>> - Rebase on mm-new
>> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>>   fpi_flags are already being passed.
>> - Add todo (Zi Yan)
>> - Rerun benchmarks
>> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
>> - Rework order calculation in free_prepared_contig_range() and use
>>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>>   be up to internal __free_frozen_pages() how it frees them
>>
>> Made-with: Cursor
>> ---
>>  include/linux/gfp.h |  2 +
>>  mm/page_alloc.c     | 97 ++++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 97 insertions(+), 2 deletions(-)
>>
> 
> <snip>
> 
>> +
>> +/**
>> + * __free_contig_range - Free contiguous range of order-0 pages.
>> + * @pfn: Page frame number of the first page in the range.
>> + * @nr_pages: Number of pages to free.
>> + *
>> + * For each order-0 struct page in the physically contiguous range, put a
>> + * reference. Free any page who's reference count falls to zero. The
>> + * implementation is functionally equivalent to, but significantly faster than
>> + * calling __free_page() for each struct page in a loop.
>> + *
>> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
>> + * order-0 with split_page() is an example of appropriate contiguous pages that
>> + * can be freed with this API.
>> + *
>> + * Context: May be called in interrupt context or while holding a normal
>> + * spinlock, but not in NMI context or while holding a raw spinlock.
>> + */
>> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +	struct page *page = pfn_to_page(pfn);
>> +	struct page *start = NULL;
>> +	unsigned long start_sec;
>> +	unsigned long i;
>> +	bool can_free;
>> +
>> +	/*
>> +	 * Chunk the range into contiguous runs of pages for which the refcount
>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>> +	 * free_pages_prepare() fails we consider the page to have been freed;
>> +	 * deliberately leak it.
>> +	 *
>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
>> +	 * vice versa. Break batches at section boundaries since pages from
>> +	 * different sections must not be coalesced into a single high-order
>> +	 * block.
>> +	 */
>> +	for (i = 0; i < nr_pages; i++, page++) {
>> +		VM_WARN_ON_ONCE(PageHead(page));
>> +		VM_WARN_ON_ONCE(PageTail(page));
>> +
>> +		can_free = put_page_testzero(page);
>> +		if (can_free && !free_pages_prepare(page, 0))
>> +			can_free = false;
>> +
>> +		if (can_free && start &&
>> +		    memdesc_section(page->flags) != start_sec) {
>> +			free_prepared_contig_range(start, page - start);
>> +			start = page;
>> +			start_sec = memdesc_section(page->flags);
>> +		} else if (!can_free && start) {
>> +			free_prepared_contig_range(start, page - start);
>> +			start = NULL;
>> +		} else if (can_free && !start) {
>> +			start = page;
>> +			start_sec = memdesc_section(page->flags);
>> +		}
>> +	}
> 
> It can be simplified to:
> 
>         for (i = 0; i < nr_pages; i++, page++) {
>                 VM_WARN_ON_ONCE(PageHead(page));
>                 VM_WARN_ON_ONCE(PageTail(page));
> 
>                 can_free = put_page_testzero(page) && free_pages_prepare(page, 0);
> 
>                 if (!can_free) {
>                         if (start) {
>                                 free_prepared_contig_range(start, page - start);
>                                 start = NULL;
>                         }
>                         continue;
>                 }
> 
>                 if (start && memdesc_section(page->flags) != start_sec) {
>                         free_prepared_contig_range(start, page - start);
>                         start = page;
>                         start_sec = memdesc_section(page->flags);
>                 } else if (!start) {
>                         start = page;
>                         start_sec = memdesc_section(page->flags);
>                 }
>         }
> 
> BTW, memdesc_section() returns 0 for !SECTION_IN_PAGE_FLAGS.
> Is pfn_to_section_nr() more robust?

That's the whole trick: it's optimized out in that case. Linus proposed
that for num_pages_contiguous().

The cover letter should likely refer to num_pages_contiguous() :)

-- 
Cheers,

David

