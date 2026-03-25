Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4912C109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71DC6B0005; Wed, 25 Mar 2026 11:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B492E6B0089; Wed, 25 Mar 2026 11:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12406B0092; Wed, 25 Mar 2026 11:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5F56B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:03:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58EAB8B9B8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:03:34 +0000 (UTC)
X-FDA: 84584904348.09.89AA5C8
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013052.outbound.protection.outlook.com [52.101.83.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19C371C0011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:03:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=pUiNNQyZ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=pUiNNQyZ;
	spf=pass (imf18.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.52 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROh51m0Nam5pQNioV64Gk7Uev2fS2bhw5xJaKOSQVv8=;
	b=1yFPIHc6OG4i8vZhuFwalB7Ptr6K+JnkE8WvOFTJIGZlN+wTUaxupnS/NjgSTjL+F0jgL4
	xSh3UD/UtqwJHpbMwtosyTZYFRMHwjPGY2jXS5G7FUcBNbhmwgS4X9Yc3TZRQyNNgwob+9
	Xsd+ok9KwgO/FwgT2dMpr8aj9Pp5XrI=
ARC-Authentication-Results: i=3;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=pUiNNQyZ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=pUiNNQyZ;
	spf=pass (imf18.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.52 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774451010; a=rsa-sha256;
	cv=pass;
	b=a1NyLiuu5xUAawtHUf7J+1kVwkMpUQzwBINkwuuaw7NCEhkttUIY1dfvcBh/gIoqIeEh/u
	NjYmsgjvagIr7BK8OZ2Pku3XMwmtrvaNB1/lVPzrLq+19T1k1WdajzgObAtR5Km+8LyCQy
	4bkvUIgWY2gSjkEf9iGd8AFxH+H1vcQ=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lK0PTMNBSqY4V1kxdlhZkRrVde8LIHepA14GG2m4GLcDYT8vEOjSGsfq7ZU2l2nAB1P9uXVS2O14tHmpnDvaf4uT8BJDlgssPFlW5nAFj8cUZLZotel2Y5oQLFjvE0gbX94MiSoPDFMjd5FPgLkZRtJzjRd0PT5Kd7CYtD+LsuyUGUBUYlDauQs/vcsOpQU9zd2ZKjjfwC2ZxWVWrCaJUC6fdeR2LeppmsMGzqksPWwafNfDVAQuDWpZ4dzAIeiJAWAJwmS0Ycl5yRTtc0yFHdhNioRTq9rXI09NNxi654B+C+wmHaUVpfNkssxs4L45PxEgdjDfR4hDPxTdf2JI+A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROh51m0Nam5pQNioV64Gk7Uev2fS2bhw5xJaKOSQVv8=;
 b=J+vyVbrscXp+Zl5khibJQeioookN1kJPIm4veQ9kWN5xh7ECb96PqxJ3e9IpUsLTji2CYXBgOtioL+U0hUcRhAUJYtRZh10r3p4rrJsSWUf84Gjbg1D8ob16kIc3Qz9ZQqub+nYKmdXAfzAKPJFVAKvvxlinYiRfVl+dI2tvEYO6QKXcjSe7BPE63vVpW1TnxPnYpIs9GIyl3DJUmnUnk8Umhd2kJkZwbdZU4NDYw5kBo5S67gcFehwdll7oCbkWj+LuUS1uHurA99ACpRbO88eq7k+aBXpNRNoKwmDHS93ksVjQ01WaFipfqMPu0ilJyzEj5KExbt0vBDTnpP4ucg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROh51m0Nam5pQNioV64Gk7Uev2fS2bhw5xJaKOSQVv8=;
 b=pUiNNQyZU5NuToZRXDfhddlF5x71Pt1aPwrnFTO2efXoWuzn3fvi9Ta7xtfohH0W5Eegrwg7c4fu8d4g5QLcGbjtPTsX7ggZcgvj8YjILcpHsrLeWVPhhRVDk8mUJQnkoiusCO1wSVB/exAmNAewmY/+fGhryJjy/QGqY8kcTto=
Received: from DUZPR01CA0294.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::13) by DB4PR08MB7958.eurprd08.prod.outlook.com
 (2603:10a6:10:38f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Wed, 25 Mar
 2026 15:03:19 +0000
Received: from DU6PEPF00009528.eurprd02.prod.outlook.com
 (2603:10a6:10:4b7:cafe::25) by DUZPR01CA0294.outlook.office365.com
 (2603:10a6:10:4b7::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Wed,
 25 Mar 2026 15:03:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009528.mail.protection.outlook.com (10.167.8.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21 via
 Frontend Transport; Wed, 25 Mar 2026 15:03:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=og8BXUYJi3RecRWOw5HNRA8lZnOe1Zlu+aHv0GlZoVVth/4a7TSQgcWsD9VYFEncvqDkAlabBy5BydJeKS2QYePu0HyTkCCcPM8nxwsHe2/g/oJ0V4hdREsRSM7l3jKQqhbxV/rYVgaIpbZqbK0j9eApd6KMSo+0CzLHq7nTr4LPVrdcpjPoOmvmbmQ2eJW8sC2tF/6nHHkMG5xNWXqLHv/Jo7aTndFzzyuulCxOPB6VhPAm1D+7g4Lxyujy01hiq4tE7cY3365jn0cs522thSUp85vgucpUXVX1FrYzi0zGRPBanih1z2CrrdLi3XWbuuRFH6aBKM2dpYos/uItRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROh51m0Nam5pQNioV64Gk7Uev2fS2bhw5xJaKOSQVv8=;
 b=uOGRSh5t7eU1rNKGx6sn68St0e/4A2vC+4dPVaqzIe2QwsbvGbcCntnDd0J9YPT1fWMA4Nj17720FRiWhzJrLLIJEh6fQnquEx0M/Asdb0L/jDpR16xVFEthbZdfZOoayyBuciYiGQxszhNB80eqcP+f4asDLtiZU8EvqNInvVyT+JHVhVZBH1GpUgNtbndKQ4HPb1dPQEipY2b2q1cJRngqjcCF6oSRC9a7/WP/4pIStynGQIKlG56I3YiDC42PSKzCBxEyF1nbkg95ZUYFQ106YGOiOaemQSTgb7Z+ifrI5Ixxne3AzIhCF3TupdOsw78vb9WOxzQ1i7yGjvdjmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROh51m0Nam5pQNioV64Gk7Uev2fS2bhw5xJaKOSQVv8=;
 b=pUiNNQyZU5NuToZRXDfhddlF5x71Pt1aPwrnFTO2efXoWuzn3fvi9Ta7xtfohH0W5Eegrwg7c4fu8d4g5QLcGbjtPTsX7ggZcgvj8YjILcpHsrLeWVPhhRVDk8mUJQnkoiusCO1wSVB/exAmNAewmY/+fGhryJjy/QGqY8kcTto=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by DBBPR08MB5915.eurprd08.prod.outlook.com (2603:10a6:10:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Wed, 25 Mar
 2026 15:02:15 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Wed, 25 Mar 2026
 15:02:15 +0000
Message-ID: <a79ff8ba-ed4a-43d0-9c4b-d2883a5c48e8@arm.com>
Date: Wed, 25 Mar 2026 15:02:14 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
To: Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
 <1D88CFF0-8A74-413F-9A6A-39E27B760AE1@nvidia.com> <acOjIcqyIVY9KNn0@milan>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <acOjIcqyIVY9KNn0@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0224.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::8) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|DBBPR08MB5915:EE_|DU6PEPF00009528:EE_|DB4PR08MB7958:EE_
X-MS-Office365-Filtering-Correlation-Id: 94c01baa-099e-4340-9c99-08de8a7fa61f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 QxQdkYDk8LIhjzhrcc8PKlBJohsFzEBszrA/ETyD9tnD1mPTkCIdmsq1OIap/0pUbKGVincMzXOlN1exj2teAaGVDB7D9XNRTqwSBmSVlROJ2Srl74XsOLYJUNAZ8xIZsoROpGmFlHo8PExZKMvL8pJ2mwWrSD/2XSs/pC3dy9hkVekxktJaxtUUnemrbm56ZJWnNIvmWWG4gZY/B4wq7SihiJx84l9F71kxJRnSU+/IID6wns9R6otZVUYZDpPH5lGieAgCfsdBxRaUpWf9F2f2Syj1CQUQKIkKk+IxlfBH/1goVk2oq2+cCUv0tm7DH2xZNCnOu7DN5uIXMn73TqOTOmZDrIr1gKUuNCbTfelwZAAOZUfZ2XItSlEcis6cvRtWXwpiL+22Z92sZX/i/7aXMtdl1XZh7zqbgZGq4quCIaLddHJL4DSQeXG3qyl7AjA/ygqdWYqAUOXN5u2DDnrjG5qjaDmy2ywjjGPePHp1t8F3W8+uEuCerhJJVmpSU3yjCQjAcAwGn2omqglC8mgTsWFt29yVlZzLPhOwVpWn4E+HiHnEQ7xh4gpUK56JJBryDxhXtYuCwAMR2JeEAI08jJyV08g+9qemk6vSu5aRienu1VsRnGwDi+KjN4gt4fH0xjeSMSBMNood0ZO/YMVssSJNY23AnHWsspGvuUx9RYvUXcPlaYCW0SNyvQwR
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 VejeALirzaMwxTx9coTxxoD/EWIml+o8+251tvyhUafhrFaNp2S8JFey7W8IUTnHInixDJSQ/lm5qgrJ7CNyhQja1dFanWJfEyugWd1pH2LdstyRIjDYRoHczuzuX4YJ/AURexuTCOY04q+GKRNu7FxJqcCFD0WhqbBfjx4IgM9rYYXKXLNxzP5EpAclC9otMubHTr5nCouOPAgzJ8w8JYPdGVf4fCxWkDXxxyVPxjd20Kri9+9dBkWt3bJatBpnsb3FzsI6V/sfgSE2fPZlE3ObeyrpnUGyoEdkPCTihBVpLBvrkGQ+CPNWimhliqa1A1Wwi2HO4/9KM6rjTGwGfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5915
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	df0d268a-a135-4469-3db9-08de8a7f809d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|7416014|376014|82310400026|1800799024|36860700016|13003099007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VepsZiKueTk2HOUxGebEZFK3BTQ3CtpE70NS0zTh3OZz9Thzziuxl3IJRBetEFwvWy+u2lQ58Jb3+8Au69L6w37XHRwTik+LWd/O2LQ02/xpdt9m0JYpYO7VJQApnyxs2h0/jVRf/TFDVkdtvhsa+/u0+lQGd49wdXdVCvulh3Srp1VHsVAvZ0AHUMBMOBcdjDEazP4fS3tkYFt+01feudS8QOg+H494pefWXNukGxfDlArvDq0bX3mA8EY4/6TGaqOWvniiwVdWyDFZM5AtA73E0lTFQey43+0ZQ3K6Lxr/d5zHk2Vldk9IhwD/lMsTGQfeBd5kt96d6FWtP9YzHbY41wug+VNVvjPyI50OhMQy/LDbxEMRUcNy4Hu4OnFmeENHJsUNJ2Ch0e/zk6LGlnbTOuJKd87YR0gQmuUMnfKwiXw32Ijj2SMA8vvYZECP4rMWzQWyJJ01ZM0n21JoWwGIa9XBYIeqx2Yi414kxJsgu5ichUSxHLYE3ulbH41X+kg28jJCfRvjr+FBCvMh+mgVlOXzyrZAqfYFzc6XcvdWSG5I8iznxjLfqrIviSpe/kjzmhAOknb/KRUBOi8AB11NG6O7l0dMrntM4fT77BfhylyYY4KbOGOm6z9ohlrEioZmBQo4bJYngORYJkB+HcqzpGBw0IJvEQPgnwsXpTGt1iobkPLukkXwQD363G7KGEnX2QmUvd435LQLnLha6ZlouM0MWv4hob1OESPALOY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(7416014)(376014)(82310400026)(1800799024)(36860700016)(13003099007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AbyBeT31TupjgQElrktaAV9gM8PuJs17yel3sZwVoLuDwWhiVeSmFCEfX6dV92EQ7vgRBhRGnWFkqk8xaTrN14ChAnoeYDuuH5wsmEgyDouny80a0YM24nhEaM0MwkoXaGtgqfP3Lub1bE+XRCH5J1+zBWvjFYwqBUIjWzG5D5ldG33nT+j2/1HtSmluXwMhz01oucH0kCLpTM/zvEXV9atjEMeYDPBZt91Nf1mUsUyvdYK5TIHqjCmNiYOcD/JSMQZLUreZ4zQ3jIdhUaFQLDeQHZHyaOSUraCIVxCeNpXFJ5tPn0nB9J2tnbW3RIvtpEY2aJEhMtkfsgPAhM32FNuAQZ0SwDOPfaER2wAJQ/r+arUtnuH0WwsYxFJi/AIy96ThPScJ/BoMYoXo5IGZd8KLj3PpWv5itdeNMHPGuND/wFvaCSp8Z/+CDu0OgX05
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 15:03:18.4689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c01baa-099e-4340-9c99-08de8a7fa61f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB7958
X-Rspamd-Queue-Id: 19C371C0011
X-Stat-Signature: 83qyzicogt4p1q533f1n4jhbzam5badb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774451009-502844
X-HE-Meta: U2FsdGVkX1/A0E1jgjBKQG4u1bO4oqeMPACvU7tP4Zn5bNldCvqryh71lHYCH1XjedUfkdpOIffoHCQkZbWzcZI3M7oquvJUowaBTcwp3XIjHTCsx4q7PVw2up85kJ2ZLk2l25KZn17xxbwOe9ZaXOajpD6CP7k5YI8Yo96D2vxkh/gsfuLIzYuBP6vC3QuOZJV9qpeBuLUiEtgAVwg5OxSCeFNWSl9wuCIVaCS5noh2gvlG34vvIb5GwNVAifsv+9T7cuMDf+ftIyXIHd6oHg5GXP284TYc0T0Of1YRoXx2K2lyMPBNp1tFVGbvR+BmeItS11yyPc+Nnb30SaIQKR59iMPTVbZfiLCPUO1h5v5o1oZeqQ6mfbeOHVIva3lrk2mVIBNd8fRONWQ6d9E2Oitr5xsH9MwQaDCVUhnOSYNNwVo8+EIqAn1KJ0lyx4HwZV3TL1NwDyinw6s89H1wgXjJ+JIcT2RsDzUU7f1XrSQPA6MqbVopPkCUShttey9Tc3T90/Fo/IbCrpqBaadp/yNaO+Q79UiULfBcnDlChBbVhDPf0Cwaw3FCqOR6+pRqAGJwyGjiCALjv3wed659RVtUIhlrOauk0Yc4addRBOayULZdpwhVJ4yTSJVh1+mWHbqhCIFwa8SPfcsa/L3ITUSaqM2RAj7Le++9vuUPIemCKJJgEfygjjIkJn2/QNNnHI/eMml6Wc9g6K1P5GpvWs+ClSVYneqOmM2vXxbeBaBZDxpcJgTwViVhodCZNC2pIqz/9FbLxHvO+Xm1MNNGKJVFFS4djOSsaV3Xaotek3wc1dpQDhCZ9BYAY+tRMJmaWoQhuBoM5NZwjKzcS9ym9e5bE6JLiQwD4aZCClzqO0/OFGmGcvBSyOnsYt2EVybqyzgbO0lvn/ujjsbzgabACo6G9qrP6ERLPl/FpkaBr0Vr46Bi+m1Abs1OjcWx9qDPI2e87fow+l3V7ABsLda
 qKlgCusQ
 AP9jMoajhCtLs6IJqIYbZ0MSSvnwezUdJ8SYDG1e5IiplM57wO1xDWHIHK1bm9JrVdLcthIT5d0KTOwHnwH0uG03VFDB5lnOhAy6YI3O8Y0Fgb9Te3AvPBPuSIndukbGy0OE2L8Pcfw0rZfBvuPU2kO21VzlR1vacs+vnTcLkSew9zUaTDXdxxhNY5a4HU1ZRS0ltunRbj3DUpvCzzg0yW082TVw0SGo5WCiYprpLYOw2xsI8z1PYuAwIYC4WvKFVJD4UrgXHhDZHQ9z7MWMSFJC+SitIyb7uzeEAdoxmdVIdjzMdrSkvvvBErngshg0NgHdyMbIVyiPwvGFsFMq3DigVzzpdwu7ZDSNBolkPeNjVsow8RL2j2WSzMe7eJxJBieTrMcaHJmhpJ/vh5hK/quYiNgrRu6A25EuJ332fyUep4jzbBstkNM53NlXhQGxHkrH5Smg1R5GWUjpjivk4DKSaS+XL8uxy9zRepbdaKdEnbrlbGWNAPAhjN/sRirekAAkaPQ/+T3KJSfQCSmKuuKLOU7URwgq4tT62jYSM9RJdi1NyMy/3i6ijO5waD86qXYVkgDreNzwjZiZ+uOfKJINfXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/03/2026 8:56 am, Uladzislau Rezki wrote:
> On Tue, Mar 24, 2026 at 10:55:55AM -0400, Zi Yan wrote:
>> On 24 Mar 2026, at 9:35, Muhammad Usama Anjum wrote:
>>
>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>
>>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>>> must immediately split_page() to order-0 so that it remains compatible
>>> with users that want to access the underlying struct page.
>>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>>> allocator") recently made it much more likely for vmalloc to allocate
>>> high order pages which are subsequently split to order-0.
>>>
>>> Unfortunately this had the side effect of causing performance
>>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>>> benchmarks). See Closes: tag. This happens because the high order pages
>>> must be gotten from the buddy but then because they are split to
>>> order-0, when they are freed they are freed to the order-0 pcp.
>>> Previously allocation was for order-0 pages so they were recycled from
>>> the pcp.
>>>
>>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>>> that it also frees that order-3 page to the order-3 pcp, then the
>>> regression could be removed.
>>>
>>> So let's do exactly that; use the new __free_contig_range() API to
>>> batch-free contiguous ranges of pfns. This not only removes the
>>> regression, but significantly improves performance of vfree beyond the
>>> baseline.
>>>
>>> A selection of test_vmalloc benchmarks running on arm64 server class
>>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>>> see regressions. Then with this change performance is much better. (>0
>>> is faster, <0 is slower, (R)/(I) = statistically significant
>>> Regression/Improvement):
>>>
>>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>>> +=================+==========================================================+===================+====================+
>>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>>
>>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>> Changes since v2:
>>> - Remove BUG_ON in favour of simple implementation as this has never
>>>   been seen to output any bug in the past as well
>>> - Move the free loop to separate function, free_pages_bulk()
>>> - Update stats, lruvec_stat in separate loop
>>>
>>> Changes since v1:
>>> - Rebase on mm-new
>>> - Rerun benchmarks
>>>
>>> Made-with: Cursor
>>> ---
>>>  include/linux/gfp.h |  2 ++
>>>  mm/page_alloc.c     | 23 +++++++++++++++++++++++
>>>  mm/vmalloc.c        | 16 +++++-----------
>>>  3 files changed, 30 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>> index 7c1f9da7c8e56..71f9097ab99a0 100644
>>> --- a/include/linux/gfp.h
>>> +++ b/include/linux/gfp.h
>>> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>  				struct page **page_array);
>>>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>>>
>>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
>>> +
>>>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>>>  				unsigned long nr_pages,
>>>  				struct page **page_array);
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index eedce9a30eb7e..250cc07e547b8 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -5175,6 +5175,29 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>  }
>>>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>>>
>>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>>> +{
>>> +	unsigned long start_pfn = 0, pfn;
>>> +	unsigned long i, nr_contig = 0;
>>> +
>>> +	for (i = 0; i < nr_pages; i++) {
>>> +		pfn = page_to_pfn(page_array[i]);
>>> +		if (!nr_contig) {
>>> +			start_pfn = pfn;
>>> +			nr_contig = 1;
>>> +		} else if (start_pfn + nr_contig != pfn) {
>>> +			__free_contig_range(start_pfn, nr_contig);
>>> +			start_pfn = pfn;
>>> +			nr_contig = 1;
>>> +			cond_resched();
>>
> It will cause schedule while atomic. Have you checked that
> __free_contig_range() also can sleep? Of so then we are aligned, if not
> probably we should remove it.
Sorry, I didn't get it. How does having cond_resched() in this function
affects __free_contig_range()?

The current user of this function is only vfree() which is sleepable.

Thanks,
Usama

> 
> --
> Uladzislau Rezki
> 


