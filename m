Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A98CD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 07:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668D16B0005; Tue,  5 May 2026 03:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F5A6B008A; Tue,  5 May 2026 03:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0C76B008C; Tue,  5 May 2026 03:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C96C6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:17:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D92A41A0442
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:17:15 +0000 (UTC)
X-FDA: 84732510030.19.A55A95B
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011017.outbound.protection.outlook.com [40.107.130.17])
	by imf05.hostedemail.com (Postfix) with ESMTP id BDFA510000A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:17:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lJUyqjc2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lJUyqjc2;
	spf=pass (imf05.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.17 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777965432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lir6NM1A/i0nTJq9iFVU7EKhzJ3HS19uW6MExcUFjqE=;
	b=6nmx2vs4qXfWiw9mqTdaRnRxMH3vd0rnM+89RoXpNYhCwTUrp+MOJJbko6Tfn8DRrgd4Sb
	U3m9w/974jS6aatYKZqWVyD02alZxxlLMm5E3VDukQNQbR44Dt+ZrEKI8nDtCin2Nqi6dQ
	tNKwS2UUAOhGTIynM9iwpYZ7Kitzlhc=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777965432; a=rsa-sha256;
	cv=pass;
	b=EDXc0xh+TKpIoEwFbu3WB2wEoXHDxNfsBjcIULQr/wYcWiddsdm+iRH5tOwNz9qSfdGR6P
	0x6B9iL3Es16+zupmkXOrphOuWyYspDPkxK9UagPtXWz23vuMo1XQPY1fsuB7O72AgNlXV
	uWVNClfgycghGgkH4IN4gtiozDzTKHc=
ARC-Authentication-Results: i=3;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lJUyqjc2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lJUyqjc2;
	spf=pass (imf05.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.17 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BaYWp0ah8x1KuJ7esRqz3g9XcJuKVKcr1vzgJqkrq0cqK//BFkCoVIuHVCgb14N/LTDN1JOyid1k5UG7d3cpVDrma/3V2N/8sXC9/eHksTM/w9zi+uoL9lhXPWabdWUtxho1pt8dX7EaBWFyZXAnxkZuAvEHLN0oHSFoekeAtg02UB0tvFDwLIYhSzinOUNdcXiL2E+L6Jdq5jRXuBbpbKpKrz7POpnpHME32ZcHSAjKuzxfM3Hpablmy8SFMt16q4OD1Bwx6eG3pgnnfp3N8c+YKiJgLsyZdaW6KRTbwe/ClPRkK8BDADxlKlRIFLq3a4DJaPyzqKiKegzDjx1QWA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lir6NM1A/i0nTJq9iFVU7EKhzJ3HS19uW6MExcUFjqE=;
 b=qqAFmo2nJj2Im8PCytjRXgUsSLZyRIlQFQyHmKfZNdHGy/XRKerGshUz2+7ICiFTd12HtjT570GZTns/2wzP4137V+2Gcz4Wp2gkXhVd6FUTfhV7Dx0Boe66KBsLpXi4vCgHJ6smTWt8B15Hu+4U7qxlChy9+j4i/pPUz3qg+GPRYMiqzFhSd28Ht83VVKuDfnGNibC8jKS6lCojFcnq2fv4apR0fVDYPuGT2/l6/39AaOIWHckiFRtRvYmbC0+HfmOb3XuzLMEf1RhWYWIILnz21UI4s1wfazGesDjYU+qH3uDD7IHd7KlXgxcl12reY2djGg28XuCaieDpUbzYcQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lir6NM1A/i0nTJq9iFVU7EKhzJ3HS19uW6MExcUFjqE=;
 b=lJUyqjc27IMmom/MHZXoCKe8KUNQKqpGt3pmnFoNdD+lI/agN7ZgTLqIGp9LlBD689B4Rb7EOfjxgcvN5OQHnYsjsU0GFnck/aConol2l3ulVOEpfkOACkplDnDoqDXRstrp+frcdO4yvrqCmh4A04nuIkeniXscuooRZFXlj3Y=
Received: from DU7PR01CA0004.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::18) by AM8PR08MB5762.eurprd08.prod.outlook.com
 (2603:10a6:20b:1c6::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 07:17:06 +0000
Received: from DU2PEPF00028D0E.eurprd03.prod.outlook.com
 (2603:10a6:10:50f:cafe::16) by DU7PR01CA0004.outlook.office365.com
 (2603:10a6:10:50f::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Tue,
 5 May 2026 07:17:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0E.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Tue, 5 May 2026 07:17:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lx+Q85Ivs/J612l2YwjBX7T8IZaKsiJOEUeXUil6I8MhExjpuYz/VN52cBRD9KGZYET3ZCJO9ALzjz0YUQphTSh3dt+A+f9DB2CQEd7WWjYuWzXfPihlrZBcRW7wBMe7lVNI1S3QvwYqRWq9LhGh/vEHAmgiRYKoZMsvx1rkTbXPysGhbFQuInaVa8FKSUk/kjHn+kmeDZad3CFkulEKl2Ff3EsS1d3HwJFdseC739HskMrWe9mn1cVPpRv+Yol+ybcyWKbxDbUpWVUZR4EyhYy3VvEGToJ2aDAgqqIMqHfRAXkRVguiZIXPtXMu14ONzzSLHvqUenvbwoHxNMh8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lir6NM1A/i0nTJq9iFVU7EKhzJ3HS19uW6MExcUFjqE=;
 b=Glz2tpukQtLQIegoeor8GLrZqInw6VjO9TvyHho4O76D+0B3JtyMNY8B120SX9LuapLF0bTS+WcDeBGwTEtHbxRRK5AIVsOYXnP1OVn/0Ou9Gct7t1w23s2rf/G6TvEU2g2tuTZpU8UVTSxnm0JjXh9G5pH4idaFqrpfJj/pfghW9IaJoEqeoRfFRvR9ezS1KnnTDhR1BSHvbM84gzf3C/bFHnPuhIGywtG7NQOz2FsYjwZkQ84n3eB01AWai7TyO5+mNXtfdtPRYu+O9B9I0FEctP+dwhJ+rNJS0SWWIbsEuFaK5wbMy/GWrP9h7skrk6dMCluFMcp1LyfxFY+L/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lir6NM1A/i0nTJq9iFVU7EKhzJ3HS19uW6MExcUFjqE=;
 b=lJUyqjc27IMmom/MHZXoCKe8KUNQKqpGt3pmnFoNdD+lI/agN7ZgTLqIGp9LlBD689B4Rb7EOfjxgcvN5OQHnYsjsU0GFnck/aConol2l3ulVOEpfkOACkplDnDoqDXRstrp+frcdO4yvrqCmh4A04nuIkeniXscuooRZFXlj3Y=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DB3PR08MB9033.eurprd08.prod.outlook.com (2603:10a6:10:43b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 07:16:00 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 07:16:00 +0000
Message-ID: <55538154-c46a-4504-a976-ce66e2555534@arm.com>
Date: Tue, 5 May 2026 12:45:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 42/54] selftests/mm: hugetlb-soft-online: add setup of
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
 <20260428204240.1924129-43-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-43-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0048.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1d6::7) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DB3PR08MB9033:EE_|DU2PEPF00028D0E:EE_|AM8PR08MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a46b87-22a1-4c65-bcb5-08deaa765068
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 5o3wHZRCQhU+g50GQaaVIGoEoQv17AKfvZmKi+NvnXlF///NewIIeYJR+lW8BBdr0KS47gfuUObjXLNF9MTR4JEGh/2cr+G4Onkw+H8OjYFkKAuSF86q44VcJluAEMRQS67BqIWnfpPahLzRW/6TNwsqiRGN4Li3kOrebpJypB57j9i3kd+cmGegh41bh+QBf9wUB1zIf6o5GiYfyBtTjcffJTXSGRWjxM8vXdSZLZVXwCLijULY4/oUJFvUHDausOEvYFbuiaSHjH7W4RtM/PzfPork/I2LvibUamjnxKxQhjM4fYDgYSe79tYoRxfKnUdHPyEg7wKEv7P+LN87HzOXbhr2oZ4emPmJPKDDdfqaOr032u7PP7MOFlEJLAXrtjOMw9btEbGe7RQWiCSaLMR9fb7AgQQhMGRU0TSKa9E0nZcmbENyIUs5YSSCoKMoUHJ2RvKsiRJ3gmcZqLmfnZrLyouQS4sl8XOK3MzE2LUffF2DBWqah/Kp94Xw8hj6SxhkoZFtBuBYz5cUkbuEpo6+XUvRXgtqGFDPncgvg3llezTroJfWc8mr+afC3IhGg1XdNaBi67FJoyLVrA4a7iWt+PF09+encbXLlZpEFxAu8NG91mA8SBQhihbcL1faJSonKtxWJQoov4nCowHxXyGDseT8+7qmLEN7i6Por9dSFi76l6y3q2q9OmoBfkgW
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 fpMb/6LnVS9NG5m2Ullo7CrieHMogw2f4H6A1OKI3TJaW1fQwVd3+UM0uUrtz4yu0OCtznuXdrv4pKs7M9ZkSEEEkLR+tPm8f5CbGp/Cq/p7mbzrdoNB7xaJW48p5iDdCT16EvTyOUlT5FzKoR6riBI5C6ufoDtOqkUDdy00Lf8VNYk1zWXCT+N3vN7RGPyJn1bbHLG5gA70TLYRrMoI6o2EIcoVXYrjJRY6UlQh7lXsA1QiiIb+S3AN+4S9YRESFG2DzVna/pvp57gbcidbj49bv0GqzeHr5VtjGm33QuARLluBhTUEKwpDb11tVO9/jta3/tOjMraBUdpfQ0gqXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9033
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0E.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0535b2ad-3aa8-47e5-d644-08deaa762913
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|1800799024|36860700016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	7oVX/Qlo9bUY1nl5tzLGK/7n18/dH77fr/Oa8S2/mpEmL5Vh2bdA9sN/0QbtOJpDMlW5U5pGHej7SRft3w+pyzHoZE1nqFJ2JdGVugKouNbdlAlxxfWO1DADFRSr/tmHbR42VjrRkReKmPQ0brCxLQTogyvxiqtNR5CmgacZcwoL44jS5Tso00MPI1qHzr8febRefAkB9Z1vH7U/SMEz4tQvRky80vBr8HzGUFq0jwn6GIUnFupmmReD0hQamySnaOKHuIf3UI+GPXM2TJ/ry/V2ZRt1Ds8K8EtVrBXd6c0GCz3R4r6PvsvIZnt5+aJ5XONU7hxFAh0jMd6xRVRIsVpWJ8K8z/ygxvg24mbAmMGndBH+ceIwf7+AKgPimWEssNX8EU/ZJc6veG9V51DiaI0NJcNsJZeElRM98ryxqmlnU+30c5WZBIwVo9FLxc3lyfloJWXIQ5oAmw2Ym6dLqm5N83wYIfPtC1ZEII/bICZA3x5eEXRWC1rWhxWzf9RL4rpPeAsu9/BCqFl9RuZCkadUXFTI3qSdBgBR0Sq8tHpM7sHRJHZbTfBn/xNf9WN5yjXYgZ/WBZyR262Y6isfhKZa6QYobrwLN5ti8nErZt3v4MUzMdkebjaGqKyqcE9qjTZ9hPBKXcxph9C8DzVLFiU0Rkn7Nxdt38dAFOFez3/Um4zCQVgVoO/enxUr7a5+b2eDA20HKogZ0s9eWqxOQQbQGmjlJXscOL2d3YVgTEA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(1800799024)(36860700016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XOivF22uAR2VrEVCOsI6mhorWudeGV/Xfqf+j6gSmXpBHM3H7sZAeXE94b1s3+H4KLpsxRVa1A444z6HWPU7yt4yA7oalqhJ02uSSBBROjWCcX9JXcHVohe6VLpslHQLwB0PkINMWjLIB3ahnCgpzd4ojeo1hyEzkONkPpL8XavMOuKvlH5xPOUp7XOx0s4K7JDHXp2F6X4YT6uX8Tv60Y7LWH4kOhMrmbCxu5pk3jsuRHqGYfNPsu6NENn7ls1SHtRyFFTwe7g4HCxjcR/UHAdr08NhwlxQx16Q0cX4oBb01spwb++cFmM6t1P2EI4ATEumBS7fBK2QhSi8lkJ13rxULciFsUHSNrc4LmU8YPqBLmbxBF0rZFp/phSs8++KhekFWVwDAocuheUZDbLKD3/NHMT5Lk3EXQpjjFpmNkUwLkydRCLg6RvPzaxc0lmx
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 07:17:06.4071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a46b87-22a1-4c65-bcb5-08deaa765068
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0E.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5762
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BDFA510000A
X-Rspam-User: 
X-Stat-Signature: diyp8px38u99yuc9rfzr7cqesbs4wqrf
X-HE-Tag: 1777965431-59272
X-HE-Meta: U2FsdGVkX18ajB0XMPidQbk0ShLndIPPKom6rUy5seqpSB6ibxs3oKTvGk4QxDnY1iqzowx8z0e0k2nWEd6bOfqLA0qTigVxNUSyR2ZOT0WfMqlOe3Kmcyh/DxSWFI55gDQdtK5woyf+kkdUFVOkivlWGmkE9gsMVJ7uDqTCVRgxZgjiHKkLLqz/xuRMLvntD70nXO4ywUetFO80CgocdCxqu4XveIy6A869fAY9LS9nbVTPEXH6Yjh9VKBa5/U7htuqKbkTuesesAWtnLXQYOWJgByW42COs0tWcPbzEYYHJmpAodlZO1v9EjyrOM4aNiif1dOF0I5jBkqBrIy+N9L5ko/jlFy8ndSMaCWera2QuSGesaGxf49QsENEg/uozvN1wka8M5jo/TSFTnn+ALyCpRhEu89f/h3UCf12VWmE+IvZFUqYL8kHPm+aY+GVnGv9Ffv8gGlEHy0cGCRARshtwzOIXFKyXwVOQkhR+Gf2PrCsdXwxkoVMgI/U4PxY1rVWn1trv1gGAu0d5MlmMfNRePjJTKovXEznzGHe5TSeFcZTtifyJYDxi41KGEXujP/egZtL59JUv8Daa2LkjOLdl0FC7hako/+fpzzA6fsdkxL9erNYR4GsitweLcUxrciOCTTH5798AQ4O5vAWjMeevpvCqKG+qoEnN4QR4QbXyvROfo3wKnzmZ1ZSeVwc7rgLpJEvX0QFpAUwUxfjGq0sF1B8QfvF+cH/HtdwSCQ3kDXuBbd1ca8OOt0QU6a5TaLq3lcA8z+HwTYS2r+weAjf+X1JgElf7rsk4MT/ENpQfV+0x+0ueyrpLeQuqkLKm2i8DOXH1lB8Vh23ArYaXACKXmKpjw7AuObKhw6q0KIJkWyYQnEEzdsu7LGGp3LbBPWTpvrXtYJoG+oCTN6FtQQrwaXAcyvOV+ZSXgfgaUIpQpxXbSg4vyu2ZOFonoGml75TLICPBHSvUmo5yHi
 WDk9Ul7S
 pPlIQ+EPMij8f/vjnevq8FsbF3rJVSzGgnvcGITFA0n9arLwdq+ks87gtfOrezMRhXqkRK69q0dFHOq0hqiK4OCD7y4HMmVxCQvsshaddz3AqjTBCYVetVjRd2n2pFd4kNfQ0wluvc+fE4LLyvmYl+26EebzRiaL2KdES5OOs7Lz6cUw8UC3P6dSKNbbch6jeSlSexUdJ8u5/g+Ampge5le7F1r2L/7Rn2mjaBX1BQbRWZhW4g2SeoNA2w6+jo49ReUnNH4+DT5iSzwTe/BhLFLx/k5RqM8y/umIt6ywwXxEmN4oqs93Ja1Pu4qZERxAuh2tp0qr2mvBFZOEk2Lcb7e5sY4PXsmku7wVOACvv714CIMxq9q8GBCw28DqJW8mGlknc8zRsu7NSarSPVkNZys6XPKbJCgzcglsCX1oG/lVZQ4OeNhLq4BWKW0SXubHrqZW3hp/3wqr/3j3i7iDerSRusJ1ZdNJP55651zOGi3fyqdAPTl1gO22eicyam69uqEMKoPAO7q1vgc3b99o987rL9X9GV5Yd+2J3MHooXQVY5wVBpRn0flQ/mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb-soft-online test uses open coded access to /proc to determine
> availability of huge pages and fails if there are no enough free huget
> pages..
> 
> Replace open coded access to /proc with hugepage helpers and add setup
> of HugeTLB pages to the test and make sure that the original settings
> are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

The test is hugetlb-soft-offline, so let's change the commit title and
commit message to say "offine" instead of "online".

I have run the test before and after applying the patch. Before the
patch, it failed with an mmap error when hugepages were not
preallocated. After applying the patch, the test correctly allocates the
required hugepages and the test passes.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  .../selftests/mm/hugetlb-soft-offline.c       | 45 ++++---------------
>  1 file changed, 8 insertions(+), 37 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> index a8bc02688085..bc202e4ed2bd 100644
> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> @@ -6,9 +6,7 @@
>   * - if enable_soft_offline = 1, a hugepage should be dissolved and
>   *   nr_hugepages/free_hugepages should be reduced by 1.
>   *
> - * Before running, make sure more than 2 hugepages of default_hugepagesz
> - * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
> - *   echo 8 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> + * The test allocates 8 default hugepages
>   */
>  
>  #define _GNU_SOURCE
> @@ -25,6 +23,7 @@
>  #include <sys/types.h>
>  
>  #include "kselftest.h"
> +#include "hugepage_settings.h"
>  
>  #ifndef MADV_SOFT_OFFLINE
>  #define MADV_SOFT_OFFLINE 101
> @@ -100,32 +99,6 @@ static int set_enable_soft_offline(int value)
>  	return 0;
>  }
>  
> -static int read_nr_hugepages(unsigned long hugepage_size,
> -			     unsigned long *nr_hugepages)
> -{
> -	char buffer[256] = {0};
> -	char cmd[256] = {0};
> -
> -	sprintf(cmd, "cat /sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages",
> -		hugepage_size);
> -	FILE *cmdfile = popen(cmd, "r");
> -
> -	if (cmdfile == NULL) {
> -		ksft_perror(EPREFIX "failed to popen nr_hugepages");
> -		return -1;
> -	}
> -
> -	if (!fgets(buffer, sizeof(buffer), cmdfile)) {
> -		ksft_perror(EPREFIX "failed to read nr_hugepages");
> -		pclose(cmdfile);
> -		return -1;
> -	}
> -
> -	*nr_hugepages = atoll(buffer);
> -	pclose(cmdfile);
> -	return 0;
> -}
> -
>  static int create_hugetlbfs_file(struct statfs *file_stat)
>  {
>  	int fd;
> @@ -177,20 +150,14 @@ static void test_soft_offline_common(int enable_soft_offline)
>  		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
>  	}
>  
> -	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_before) != 0) {
> -		close(fd);
> -		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
> -	}
> +	nr_hugepages_before = hugetlb_nr_default_pages();
>  
>  	ksft_print_msg("Before MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
>  		       nr_hugepages_before);
>  
>  	ret = do_soft_offline(fd, 2 * file_stat.f_bsize, expect_errno);
>  
> -	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_after) != 0) {
> -		close(fd);
> -		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
> -	}
> +	nr_hugepages_after = hugetlb_nr_default_pages();
>  
>  	ksft_print_msg("After MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
>  		nr_hugepages_after);
> @@ -219,6 +186,10 @@ static void test_soft_offline_common(int enable_soft_offline)
>  int main(int argc, char **argv)
>  {
>  	ksft_print_header();
> +
> +	if (!hugetlb_setup_default(8))
> +		ksft_exit_skip("not enough hugetlb pages\n");
> +
>  	ksft_set_plan(2);
>  
>  	test_soft_offline_common(1);


