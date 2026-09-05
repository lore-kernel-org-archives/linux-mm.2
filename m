Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C1C5C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 05:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE0C6B0088; Sat,  5 Sep 2026 01:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75FF46B008A; Sat,  5 Sep 2026 01:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626F66B008C; Sat,  5 Sep 2026 01:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32DC96B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:31:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1208F1A0291
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 05:31:08 +0000 (UTC)
X-FDA: 85178585016.10.785B66F
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012059.outbound.protection.outlook.com [52.101.66.59])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE6274000A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 05:31:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=V3qRL55e;
	dkim=pass header.d=arm.com header.s=selector1 header.b=V3qRL55e;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf17.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.59 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788586264;
	b=z3LIh1AirbETI2ws/cP8b/OG5B5u+4jMWIC66aGrCdrbqDaw8DA9iL+l2xMDnXuUbDBAt9
	adUTlUIXa8KKlzD4aWOjjHOIXgYop7g89Lk3cjs15hS5zRxvl2iNaDn9SNUE6TOn00j9JN
	IgeJk6BcQ0X4HfmGcL9FqFado66SuNE=
ARC-Authentication-Results: i=3;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=V3qRL55e;
	dkim=pass header.d=arm.com header.s=selector1 header.b=V3qRL55e;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf17.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.59 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788586264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEzw9NpKj2v4Y0rr7vpIazbg7IYkwJn7QitUro15kZA=;
	b=tSYWPp61ElzbJqCGP7uh850SNweQOVRG7kyIGSNS9my4V/kcrpBDFVaZSs8l+LP67OgXgL
	njrVzkwUpzLqIRdAeJV+Twi7aM6UDLtCrO7cQ+UmKa1vHPL9joCn16RiUum6L+4xTkyWAT
	xs5PJ+ZVoapXgRGsPFxEuR/5JgRpmyQ=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HCv/fYRKCvZ39aYmhO2V8kDFx6mOybCGe95/cBCjA9uffLFJiHdnxh54R8Mv1RtV+67RpOm6AOF5+0B5yWGTO94tftG/qG/0UqU/12SG58n1z6PoLxNx8k3BdVO0wkmtcGXT6JS0+Rj1uFdi8K4oOVCsgk2URAAeyVl4je95YRGRbGn4rw3/CXRBarYaghVsltu8bsT6YWzJ7Wb6XSTpUax1gXnoDafqQ4Olsxbw7AxCxabDqJlb2Z+mGXqueoz+jkdHbHFDoooLp2pkj3jm5e0Yg/ihPLbhyyVkOckVdPvaJKFdLxT3y8GPdAyegz+Owr0z2b5gjggqrt0zauQWpQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEzw9NpKj2v4Y0rr7vpIazbg7IYkwJn7QitUro15kZA=;
 b=h7vIJF6hssPwJVoZRcDi2jDUFuUQht3sBWK8pyy/KulUKbMGm5NI+VrUmh7x0F9a1IjINtbTMSOyqLmmiQu79+7o7sGt7p4R00J9ho/cdYpVTRHy333+R4VpRVbRiuPwoJGnzNKdK2qSsIJVNQB/oux4vnSmdxfkeB4QtreH9FBHRPxngGCCsg/H5J0hq7K15/WeqywCmwKuMt+5d3GofzsTGcl6BF6N6//7xuItUql7fi6Rxo4wBiZoS3Zu3Yp+834Ach9daH1yoB7ocGRJxPkjbWeVqBI+txaN1u+4KgT5Tewe3/HDTX56R/uyym/rR8r+6gqaqljRrfUsYLW2Ug==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEzw9NpKj2v4Y0rr7vpIazbg7IYkwJn7QitUro15kZA=;
 b=V3qRL55e6WKI9rtw9Ch/lSTeiGuQTjR90Cl4BluD00RX2HKm6GqSq89ShdOQG4Zfnx6KBhRQxM9NPnvnqjrYCeIQ35nwGIqkt23CiTk6cioNnub6YW4odahDacZQmLxPqhOKW8ieeLgOle+FRVaEtnWszEV8oSvByfz9azSOGsk=
Received: from PR3P189CA0035.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::10)
 by AS8PR08MB5912.eurprd08.prod.outlook.com (2603:10a6:20b:29f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Sat, 5 Sep
 2026 05:30:59 +0000
Received: from AM7PEPF00000056.EURPRD83.prod.outlook.com
 (2603:10a6:102:53:cafe::2b) by PR3P189CA0035.outlook.office365.com
 (2603:10a6:102:53::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Sat, 5
 Sep 2026 05:30:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM7PEPF00000056.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.1
 via Frontend Transport; Sat, 5 Sep 2026 05:30:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=acCP+4TGqxQAu2P/FND7F1eILVrFs4zolk5Ef3IIzOVxvvJYRLqdzolfcvS3IUvY7cOWPwWm7XwYlOTM8PZTsj/umT3X5ca9dPrjOZt+swJarPSltKH7g8IRnrHDPjOab/NFSIIg9c9XRKiNmkVsJEM5qw19N/mUOzwsjylM4hRq4ALgVvh3+SybA/3ZXEr+tcApiGImD7x9aUPcrFriXv6/c0t10xfdBQUFKGsAOFZJR5NpXj/OBCaoh7jeMMHhfKp7WO8LSh1t2O1J5LhHSPf31YVPTGP8uCK1tTnQHltSPv5n6SSesQHoFFMaMo/8QDNPS7BDsGMAtm58+GaX0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEzw9NpKj2v4Y0rr7vpIazbg7IYkwJn7QitUro15kZA=;
 b=sJUNILhPaNyv8cJfXh/wzTlt7f0jki0aaHWCKnxFqHPFBXulEjddLE+FQIousmsqO+MEwe3ORPgMLi9oKa4cySGVyHLKIMIPZE+EyNoq11yFybAIP0ko6uOXfa33G+HgIDo5S9fUA+7eBc+hdJF6a3qQ3RbdreWyv9q0MyqoO/y/to3lbd6O0HOyAkPAkFTduvfYURHKqv8zAStmQmYLtvHa4pl0H8UujMKjjPV2ljaVWI0rXRXFJfOBUZxbaJ0yYo9i3YxOnhM2qln1DpQkPEiNr0HJRzOxqPquNy/pfr4qQXoE46Lf8BqCgfAvrk7u34jTIB0HznSRunMEZGmgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEzw9NpKj2v4Y0rr7vpIazbg7IYkwJn7QitUro15kZA=;
 b=V3qRL55e6WKI9rtw9Ch/lSTeiGuQTjR90Cl4BluD00RX2HKm6GqSq89ShdOQG4Zfnx6KBhRQxM9NPnvnqjrYCeIQ35nwGIqkt23CiTk6cioNnub6YW4odahDacZQmLxPqhOKW8ieeLgOle+FRVaEtnWszEV8oSvByfz9azSOGsk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AM8PR08MB5633.eurprd08.prod.outlook.com (2603:10a6:20b:1d3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 5 Sep 2026
 05:30:24 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 05:30:24 +0000
Message-ID: <d199cb21-f90c-4e40-bc7f-5537793518af@arm.com>
Date: Sat, 5 Sep 2026 11:00:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/6] selftests/mm: separate GUP microbenchmarking from
 functional testing
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260904123631.198697-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0027.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::20) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AM8PR08MB5633:EE_|AM7PEPF00000056:EE_|AS8PR08MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 208e5a89-a87d-4bb3-a6f6-08df0b0eddc8
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|10070799003|22082099003|18002099003|56012099006|6133799003|10067099003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 g043FfBbbXYT/5s8n4R2OfmkTUoAaqBNPUoD9VMRQLAdLIdPH3N5utCTNi92kS7JtpSdx4TUcNSZJlSKAOYH03hYSlABsvrg2mZcZkcYmQVLp/IuAH5pAI7xXPr7HsmjpwXJ9xARTV9DRiKAUNDWBMb+Ajwg0cY+jTLnRP20rhHBlzIEWzUmeyydjRC4be89qN0bcAJAJNBVOxbh3FHC/kOJ9CRxl5QOQQEGDBUXsMfS2ys2T1lYPwL2IQwFmpP2SevIyjFmWdevfzsLq7Ysu5yawujgTMuzGc/j4uf2tS656dqiaKwZDx0Z3nKir5J5LBMaFQqc1runRTjDp3vGEy2/H5VdDaQvs+XWVFcmUIkeJY9h69Zn0Zgb5OE75DytTvlE9G7o5HoGVxpCU09XFLJ3Fj+S+S8xJwH0/JSR8PmUEegwTD3izQejI1CQF8oUfM6b61ednBV7lB66+8/lgDe6qTXuK5wyEFifGToIeCfZqbmjwgfPe9Bvadg5YbcN3qfc+QaFvsmraYgeT+e1OMIbbiJWdwSAOUsTaz8UhOXR2TRnuy47Ymvf3IAwt2y53OQtc0aj9l1TIuUBhmkDYtP/nwpZMDqTKPf79EXOp+s=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(10070799003)(22082099003)(18002099003)(56012099006)(6133799003)(10067099003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 y7qkliCrBJdRcHSSMRK4BdaXnbUcVP1bCz0B8StBls2zPq18J22nYM8WajKKk5uDcQ4t7Igo74lC/DAmAqOxL1McwetdiWNqMiGCjKdGHOKchy0sLXJdLV55YK9/gcfix2bW6C8wIFdKMoGLFHzF0HEL4149JLRPzpl4YlgwWo6IX9c71Kx/1D475+D1VThzvcFQzZu4i/K5uH7O7eleb0Nh10JzwXKyraOJtBmEjoheqo14XyWfAiWZXzJ+nl6BXR5Ke+tRQSmlZk5qxtdaUd7HYDPACChQaBMumw7nu7HgRbYkwCBf5jiwDbOASIHmNHmakDSrcrI5l0CoWJDpsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5633
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7PEPF00000056.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6a3c3975-d9ab-4202-4e1b-08df0b0ec925
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|14060799003|376014|7416014|23010399003|36860700016|13003099007|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	FteF1LjEDJXzHx6PUAE43muYvk4++03tnIynJjKAHlnapyV51098s9rX2bctdtRVzfzn1zUxGcT1iMhpMZpr+4HoSbk2sKo3HA2J7zm1DQE8ec8wFvRDSgx4y1MjmGg7cqqIzZRicvaV5SEybm+ZjluUhDSBE1nghySsAbdoqvS1uRq6wxin+HyswDnb+BHKJ44rpG+reqntE4uZVR5Svg+JD6hyxAiwM2Py6joxnp8VKcsoEz+3aVtW0+g1/iI0GyFf7mbOJFs6Unek2QtHDB168RMZepPlHH3g+mXqArN98b5ODQY9xNw2qkQ4462WV/HOMBEhC+zbPy6VnFFBIXBnSzm/08u2CMgBwOC8pBjEzEBPG1RJZzY2GyNFKqcniClzXITAaH6+kq6mOn9RCn0tgV9XziuIdoc+gRbTw5MMti47Aq4dM5uIgwxsvQHXXifWKNSoMqUX+hzNTUTS55meyx8oB++3khkGgnqWQTxEMpwVGZRK7oMJ2JVbjzDc/dmTVMt6PfnV/qvS3J398Q9HQUBiHH7uG1iDC73ZPUySMUvbiX7hAUKmD3DexUSzq4PAlzWRV7j53Rtepez5xh4k5cZGEF5+ZSekzW4sXhk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(14060799003)(376014)(7416014)(23010399003)(36860700016)(13003099007)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bBG6djEu01P/ac0tb+IVZNQ4Pvam7sAArsqQkrig7ebFs4O8U3ODBvjkpBxHZL7O48oViHtyr7Y331fa9dnjRqDiZLEXVPcHgPJGuvznXb/GlXmGVKYGWXRDWk7OsKmie8/IWVByUQkWIRZ4pTBYgSoMzkI1QGE/qn2hkq3mcHGZsgeL2X3um1eUJYRflDQwuLxpNC1rCy5eJrVdT4My+LHwFGxo3zKQBFXURbAZPLDymEGOU7F/q+cDw01EGujl0SJIXDUAveah6b2Q/TUTPHX4FQsBK2VeeEVx37LqJhl4NxowyK6ZuxcUrl8HD7LG8UZMSKuziTOU4+KKeU/JUi2TtGv110JO9XIfzjA9F8EOXc4qIEUPvX54JKWtiLPPYEKBP139pI/gCz0RQ5VdBh2WGeCJ3uLFEDqqHYcA4XlKAPmegfy9RgZEvM0gdE7R
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 05:30:58.7330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 208e5a89-a87d-4bb3-a6f6-08df0b0eddc8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7PEPF00000056.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5912
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE6274000A
X-Stat-Signature: ukuthpm18y9b563y7u6og1j6jdsqt99u
X-Rspam-User: 
X-HE-Tag: 1788586263-193279
X-HE-Meta: U2FsdGVkX19cfct81SEuOhyNj6TWGhWwhAuwNrezxt9/eyuW6wqv9BwRh+7jmweklCRROHnFZuRpAtfsHV3GpNA0KZBGi2NqH92FN59aTAvkFqn8ykn0QPtywwuoE7cfG2/T750OwQNeIObB9KLJkapZjFrJOgcnq4BsTqiQrense8g234KjcVdb0zoirn4jgNl6u3rCYgmIP1ag9S4pKJx8EZp83GXJtlfQyxoDywsXA9rOfLWocMvvvFEePJz0kbLtvDgSMs7bqi8n+SPXOyP0j2bF2DKuKe2JEkhhU9HpzcAeDl9xfSrNCS2cMFu9iBXm4sZqtZkvXtnCskxwIh3WtZlZuYBOnst6hQ0BYMNfKTO0TCxDuXu7s2hsySsY/KP+JF/uxZmBI92zLf0j/B0R5ruQYIg3cRDMcmn5Bp4iq1j9UyoYuK0XtGWUSxeGM12qtQeJg3sUEf4n5NGEGYUOQFnIGD1PKMqvXDKgVq2jngauAe0Dly/7p4MErAeEhQp28eAWSM79TSYKYUIgkrC5Nantt5aSGk357FHu6auOCLZGZxgFqOhxLtUmQ9QZV06sIjfXpUppIexEw/fid2xfi55mHWzqJNWK/ESJ34vsSXFSO02rW62bg1NPoqmcsDmowvem6m6InfIzSdp35oCchDeITsu8DBqu3K7CWIv6VYCnw++EKX2zLhLeouF7RKC5Aias+3GgTo+W4EeKtU8EIl45D2ishbfXxSMXE6rUOVOLjyUTmB9fg0mkDEB5+OhC5m+oZ2wRJTX6a7DlhO6ZxF/Pt7+vqbfDoMXzgPBVcz3AMPHTtnx4hX9bUM63j6RvRIafnYHUtDDV88mppsXZERwY+9H4rtDwEPtmfqjLe0zwc873fKmwwyf8BIHo/xjtFsGeS01Nk8y4g7WnfRLxUriC0gYR99cE+s/nkmiU/dPNpzHhq7DVierrxrMBaV5CovS2ogKS22sHRZY
 8NEpS21d
 QB1834xUeADqWNCXqk2UhwEkESR1ojz9LTz3MbunDCeT4siKl/gTQ/SrGE97SYTHTMjZwf8TlEFzaDXfPLd5MBjl+QrbLTj/rCrUz3tTma4VLxhHHL0pqcoGhEy6OVL3GW9dll0B0mjM20fbI8eHw/Q7xlR+tK5hOBQfBwgIpQKI6EK572r9AuZAGxCe22eYxlVAv7+clwwEOru/i0KO24dSHYGq1P2Ql4/OwQAwwjzYKsTcdxA2UlTfoBSp0uejojoIdKu2F3NZSJuUE5ZmQ1dO44GZzUWmy6NQTpUimsHJjlVmA8GMtqoTbYgFQ6SfOPjtRV5E0fawzGk+LoGq/hqmFFcmmb7KXnr3hGUBvY+sf17RefYe1fnuagkhwbCmHWv5qoYyXh2Pqj1VRyian52m6+ANjJcM1Zdgw61i817QhM8WYUicIVNeN5dU0sG7QfdLsdHOKjkcw4VsGmZPDqP/S34YLN0bPdoIcju+VViONVmCWFal4WMU4j+K/7OxWpLOYv7wJO22TLvbX2ijbGH1qq73k8sfxSkCyHkOEzzhIVx9M9Hlmd7m6m3rf6X29w7STOg9HLg5UAXIjNl2+//Hq3oPa83L+0Vx0czRPJnrO3owYSPmLnCOuas/bxPy1rlzn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 6:06 PM, Sarthak Sharma wrote:
> gup_test.c currently serves two separate purposes: benchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK and PIN_LONGTERM_BENCHMARK) and
> functional testing (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST). Keeping both in one program makes the functional
> tests harder to run and report individually, while run_vmtests.sh has to
> invoke the program repeatedly with different options.
> 
> Separate these roles into tools/mm/gup_bench for benchmarking and
> tools/testing/selftests/mm/gup for functional testing. Move the shared
> file and hugepage helpers to tools/lib/mm/ so both programs can use them
> without duplicating the implementation.
> 

I went through Sashiko's review on this patchset [1] and wanted to
address the concerns it raises.

Both the concerns here are false positives, as it assumes that
FIXTURE_TEARDOWN() will run if FIXTURE_SETUP() fails. But in the
kselftest harness, we initialize the variable no_teardown to true before
calling FIXTURE_SETUP() and make it false only when FIXTURE_SETUP()
completes successfully. So, if ASSERT_*() fails in FIXTURE_SETUP(),
FIXTURE_TEARDOWN() won't run. Therefore neither stdin will be closed nor
self->gup_fd will be closed twice.

[1]
https://sashiko.dev/#/patchset/20260904123631.198697-1-sarthak.sharma%40arm.com

