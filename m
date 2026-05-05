Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1828DCD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 06:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311406B0005; Tue,  5 May 2026 02:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1CB6B008A; Tue,  5 May 2026 02:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189E76B008C; Tue,  5 May 2026 02:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 081C06B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 02:53:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88B831C0F14
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:53:05 +0000 (UTC)
X-FDA: 84732449130.29.19CC200
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010056.outbound.protection.outlook.com [52.101.69.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 94D592000E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:53:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IgLBCb6n;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IgLBCb6n;
	spf=pass (imf13.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.56 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777963982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Mv881blE/vKyygMPoAWPyhF647UEZmUqgmdMskrdp0=;
	b=xQVhZiW5+6KkuMAYqEqaNaVQ8gYn8+Qx8njZAGkk98l4Sp3Dg/+XD81Mt8fs14lqrqsznb
	xKNAJd5D0gGPrnELaCxR9gYMf9tkaE0MXhXT6M6I8N0v6t9r+Rlb8Ssx/+ys9aThkNbukr
	9TgVLV9ZN78e9e963hzWnILzVuV8tlU=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777963982; a=rsa-sha256;
	cv=pass;
	b=ZUoaMptlxx7mnx1f+dKKg/1or38xUSvgkK2qyYFLvBP8GPk3z4PJ7YkySXhIv8AXM74kBT
	mLc7cQdqo+wzQDZnoBARyLxEdTfbgkIz46lM4LTWtAQQ0fXonhHUX68INLMhgGBE2x3dDK
	3YV8p3cMRn31zT4HaKkt/xEaEg4me9s=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IgLBCb6n;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IgLBCb6n;
	spf=pass (imf13.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.56 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Qe3b8qcTlqetlj2TNOMa9z4UZ8KVUxxc42X+uSmulYyO4pa0NEfQfg/3Tji3e5V2Hh5Ym1TRg71U/QUuCbuCNPUQO/5txHmVdR5x+bGnpkh17Kk1VBu3+ZN6SKZOk3OWjER/Wf4a4KZiNTGxdhjYZfS8ei3SsAOwWwGIAzLUOdlR5aoUAgYLcdvy3F2iHsYI9gSfyJqA057yR0altgY0gC1ldveCsNPmE7FYZCzlpyJz9SCS6VYZutowoHYhtz3aOwUHudHUqhaw9lsHSby7HwL5PMeJ4/gfYtrJejU/dKkl6JZ2pY4T4RPO1L3R1e5yox7dcIZCGYh9hv66ef6uUg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Mv881blE/vKyygMPoAWPyhF647UEZmUqgmdMskrdp0=;
 b=GejkD7Z2UnAlSSYJRqDZ/6eN7GQnA14x+qe7GoJExFkyxFUarOKRbxAtqWmB3r6h3GPTbpl4VvjG4tp9N+T54WAYLMMsQul0TNoVa+Kye8DwMWDZ9ZgltiF+vzUvJySjR214mLGoPnh5xLNDS+vRqhCa4QFy2t94fMBevzbL+23iq2kFI1zaDqPF3WFpbS1GJbcOwz+AFkRMJkoxuVCkNo7fozQgpCHfcNqa0H4rvI8n+2oD8StKvF7gohF9YVOPdxc3dJTmqJdVRIUA5HEWvoamA8V/4H8Yze+CPJcTeJBx8d0zXMzzMfGqUryGdbBUB2dZdX0XawycasQanwG/iA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Mv881blE/vKyygMPoAWPyhF647UEZmUqgmdMskrdp0=;
 b=IgLBCb6nOVxIad8yleRXbtyNA9FCoNBVx4oeDopmvshDK8cQvI2MJme9dVEw4aTVABvHqC8PjHeTvyeMqS/MZROeZnQ9C8ObBfkGjqmCzwev77JiEmW23SDVG9zfsqIiF/kuhrnhWuZ4L8TfTC4/R1may/yBcFrD1k7LXsfpaBw=
Received: from CWLP123CA0057.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:59::21)
 by DU2PR08MB10132.eurprd08.prod.outlook.com (2603:10a6:10:49a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 06:52:55 +0000
Received: from AMS0EPF000001B7.eurprd05.prod.outlook.com
 (2603:10a6:401:59:cafe::68) by CWLP123CA0057.outlook.office365.com
 (2603:10a6:401:59::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Tue,
 5 May 2026 06:52:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B7.mail.protection.outlook.com (10.167.16.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Tue, 5 May 2026 06:52:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B71sl6JO5dam4kHAGrZYLpzuo3Vf7lip9GVPjk1oHSkGN1+AxDNs2/9dek6L1wfJ8y7DgONm6eq7xb8Gef2RvcASjYh8Ub/RgAktcQ1FMw/eJK5kz+iZ+7vdBN7ZFmhRFD/49UXOI9uGQkyBqPtRP3wD5+jNEoKDgXzBsUlK8kBhMHoiEjGGo61XVDYgvHw1plqX0PjvmjEUJR4EZkgGott4ZpejIVaQRkXTuUCY/ehbnKgztjwiayj6XxYwRoeguq5RoXijdytkduX312VlBbufJ6lbEslxaXeb7lVWivWnzuh/qrtQFyrPzQmSEk3B+sdzUbiC75IP5BMRoqlK8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Mv881blE/vKyygMPoAWPyhF647UEZmUqgmdMskrdp0=;
 b=F3fS+XB4Qkgsa+0I/hUvhp2yd1ry9/5fEdwRxujhlzWP09q5sbCGQkRc3if6JG6QOzfMYSPqqZqUwTBx70YO6hzCVW/lIxYwGgL0abQ7ViibRa5QFIFdr7ofdkRXYcihqpVPexBxzVlEMZC9cUkNfNxxGei67+ZB+L/gAPza5iSytM2pnpjX8XlsGr0tVkdzASOnUCeRogkGzd+YNuSN7N9mE1zwMxb/Mspe3c8siwcapvaG/YeB8ucG9OyUkFgQQrEKzID5qiSI++laYtR9efnYSkmKzfCpjysMzGolWdvLublpsC9tmOu0hoWNFuRNMVk22+THTcNCQcJVJ5aGmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Mv881blE/vKyygMPoAWPyhF647UEZmUqgmdMskrdp0=;
 b=IgLBCb6nOVxIad8yleRXbtyNA9FCoNBVx4oeDopmvshDK8cQvI2MJme9dVEw4aTVABvHqC8PjHeTvyeMqS/MZROeZnQ9C8ObBfkGjqmCzwev77JiEmW23SDVG9zfsqIiF/kuhrnhWuZ4L8TfTC4/R1may/yBcFrD1k7LXsfpaBw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AM9PR08MB6273.eurprd08.prod.outlook.com (2603:10a6:20b:2d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.27; Tue, 5 May
 2026 06:51:50 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 06:51:49 +0000
Message-ID: <062c6e5f-2920-4bb3-b853-5d6fd7696c26@arm.com>
Date: Tue, 5 May 2026 12:21:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 40/54] selftests/mm: hugetlb-mremap: add setup of
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
 <20260428204240.1924129-41-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-41-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0149.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b9::14) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AM9PR08MB6273:EE_|AMS0EPF000001B7:EE_|DU2PR08MB10132:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dc52957-755e-4ac4-0e36-08deaa72eef9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 B6sdA1CNvbBkYRDWl0dpwlt1nN31iHVKdAyYZ4tDphpC5NtqVNLoY5rUW1633Pxi3txJDPewRpsor57gRY58P5s9bhFaOBBqY0BtE7EpBeRqri8nLd0a7DM7cYxxuieKUgXRguTRpdB/VBoJUporpomkVMYjjLeEK9XP7tTESaAcOWbWjwxBFUM5OuEzcxjG9q5M95Q6H3xSVp4d6s1WmyaZKkgmS3BDqr8e29InTZQnVjt1ewAbfFz8kcmdnC5p3EBsxP45Ti851G/9T1hnicVPXrfMeeY1dR5tTp77H42fWNhzbx9+c+vtqk27tCwpua04lSC6o5j5I7LAp2QH5atJA7ndBD7tM+Lp2KmlSjnSUmk/2ut5/yeNZGOHDdod6RJLyz1OCxgh0cRUZJfYfoMzOM0EVfufZGoKy7YbU6WlxaaW6P700/Gv5TNau5NL6uNxS73ZVC0vRjAEU3VSXsEVY01FKPe6dPfeM1SBqFZ9NSjd9zmJSaOWKGJ5no+EmLMb5k9x5ZZhGwbfLpDD8QxjRY1AnVXyjb6cxb0orU8OXsqdhknq0PXGeqsJ1JCsdPLlhyxMK2DdZGt+rygh4Qtl09SgLO117LGxTRcSlVlmeR1aski1Xn/KjTgNB61JshsLSFUowwuZnBboZ1DYZ67l0M+gn4B40htRx1zUxOaYVGDXjq9Py65jN2ABlWxF
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Qx38EGFR3cIrHid6btCo8jOQZjGoaC1s8jS2CGC3SjqlWlpg8b7YfmQ+0p73Jaxcj+pGxcFkWYAawM5Nnb9S84U+dZISojeviGHoKns9uI2KyvGJO8RJr3QAxA4/Y54TniNV1MaB9eB0nuZOWUIIllt2kpH/u8h5/WcRUMT11fsmn4g2yAxgvkzzjBeT3StaRwsFtfbNx5IrCLOpPe8LTFw0jowXUGiPkJGoZWVuOXouK/jnD4Ws+FUcfkkXY33n2JLrvuiUa1w/rfqNzKC1QCA6VSsJ3jlrQzujp8ojvmCl/bLYJFs/eXLjBUMSZOV/o2MTisNROt6C8ZDNwYoB3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6273
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ed2f7f91-eb88-4e3b-fa53-08deaa72c7ca
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|1800799024|376014|7416014|35042699022|36860700016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Y+Di3RlMiY87BooClk9VgMMfIlA9fdfhz2czUJjq4cVEL9Y2j9TI0hLY3aiYVNQ4c8O0WODQPeuL77L0Ixa+oHi1ofQQ+8vLG4eHSC+kphKT+N3Ayfu9SPuhkUF59t54BKvCXlOOc43Ae8NcgzdyfJ5/YkR84A5Oy6npIvNfv5GRksuRYesC5rFT2dEBR9HGUbXu/X6j3oh+wBQWeueXZmmSQcLbgvvYrNMoRPgd8p3fN3dF/iMzhuwxLYIk6acXzjirGBecQ1J5sKHB2FziT0wZ2yQzYIKE/aWKw6mGCMAAPDhkdgL/CL4RS3lSo4IAEjTEaLkDycfP2wZc/HwtNwWrMBV3GJSgDEf+U224ni7bC9kCqrC9lqrhYV3ySA0k3mQD1OhkAUf/drFYigLEcl0XqDqwIqtQ39SZsEijZZDMP0GK6oqoRz9b1yRKveC5N8j5lqAMLHx8Ae7dezhDdfyNs07KA4Qq+fgKi4gkO8gA1i1pT7+vYE9NHBdgYJOdlli9XIMdQLt+f0e19Q7hxcIlqL4c4RsN4tp7QMKZOR9KSEU3PV49yuk9zRwOW+shis+nC6m4sY0KvURA4dc+QeJfoiur7I/mAFlOvX2cqFDzatMmRnt8GRlST6flK0tiU3Z9zQl7jvx76t6J+SdRayJrdy2W453VyZzR2OBUEbGxT6aDYy8MsKmjgmsoCVdxuh7OkS5cL0OuV8DwCXqAfuqcHQYYpUC+v/HkjIR90qk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(1800799024)(376014)(7416014)(35042699022)(36860700016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tgL9Y3Pi9TonNvLW91lW1mWgyVLjwHZWmL9sh8kYhzykUUk9u3ck6RgByZQd4ND1R63nnXD5hwq4iOARIf1e9fcuGQYsjUgiSwj4uZr5PwBqc4BYf1uraunlbVy5S4OPcRyKPAUIbQEg9TOhtba83VNPgKsFisW0W9GC3aN8q9RuZf42MSFWKEknyJhLj4vizumt53z62k0e2EsSAsVKY4fBoTNbQBKFW3cI/+agyb4lepXjab8NVQwS126GK/qJJDxS46UYt92wWNBlIU6Cd3+LCcDs6FRQ++p/w/11XSI45/0fgS36kD59r+XKRwVL13dO0LIxb/vQok9dC4KzZ5H9oYrd8vSzbUS5b3310BYd25WFOmmpOhbQvWaY5Q3UaTbd8cZejlfF5ysKoEt8UBu32CH/rzFotNXuBbTeY0yJdilTXyYrDLJD9E/4yf3g
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 06:52:54.4520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc52957-755e-4ac4-0e36-08deaa72eef9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10132
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94D592000E
X-Rspam-User: 
X-Stat-Signature: fjfk1riknajouz34azn6kyygiusg4zps
X-HE-Tag: 1777963981-975364
X-HE-Meta: U2FsdGVkX1/Mn0vjyMgCh4BiSeq5o6szFLokgUgzK/qmMB/UbenRlBCT8eCRxBveYRVd6IImjyr0ZFiUJGpQX/b1feSImzFgYONWitLIUoQycUX1EndfoLkj+qmiPtlWfMQJHbkapN5BBh+/5uhNZPn20k3kVDGjpe1W/+Lg0pXL+A4Ye1IubPENzSLuyHLKb961shuq7/uwJS/999s2RMwyu4dRY8TrQ73NQr2i0Hkgt40MZCdyc2Wcryv0c6U9D42xKMO+ErI9zGxuBiA/2K1MBiDCKbGNNnOvDTPS00EfzdepTvpUdSnIK4SFuD57A6EH2BDeM0JCOinI1JTgLvHHfUKsDXIi5Rx1+tbAUtHgzolxalT/eFa+HSmA4XYiUR0vgCtvfBAiDxXEXAUwrvUNOIxFbSGRfCG5kov+ivEiLm47Hq2i7fyDGeZHbGJmcdg9ds2kQZu8Y0zTWvktJVMK71MKRq5ns4bKentAn+/cBM5CrBlr60xiBrs++JYqC2KAxM857ltN/CVK0CMHUHUiUHirnKO1xRg1jmcmM2T0fLqCkBx8r1ELOcir6sh49BL6G9X3v+H0L9EW/uxHtP0vx4JDKZheiikgUAzL9FXTfJt9ukTLBD+7MzusXrDBd7oiBHbSTivCxXQtzeF+4W8dSUhCcOO6sY7A7lMIi/0CoMO/QPN36q889DhwBKOZhrdGWJqpwD7iEnHBsO1gPqqxAOXBvwbS4jbcjMN1gumH8HaqRIHUZFE31UlHjaK5SIy4IlhTCSnFAgcM9osIOcLSBEbftwj0+ri87ajKn+986DdKl/tN7q4szxX3W0fQQn9E2xuzK1Q/BDdMhiBN7kAvmnPD1WFWmzlU7SwFRW+/vIcWTxUr0GLGWdifS8+L6QQ/hK4blPYjNsOORu0Mk+Dxty0YN1Kdbz2r62QDGf3N1k4Pd1cofHe6HXHOI7g9gpjvrw0/WRIDApnTfqo
 T6qHF6OT
 aduzWEGCKyqdYdjVDphDizxYqEl79TTHZsfxpvolfs3MUWZJmNMCwXHNeXYSvBbPaWgBnTGXsyOuEcULIy5dmto/N1CHz13HL7Dvgujtwlk4GzpY4BGXSGO1NRyFNjJFhMhFlW4YNB6utyTQp40ELQN/i2STmn06LLCrjzKxuFTmhBS5uhQNv5biQF9JM4Mya4Zz7jtsJMU4wizq6KcGy1LI0GNnoEx97lLPGq5qybO9/3qeH/Xvexm1q7Nw1ts3I1SFr0dEjinDZWnkPgKGQUtR4BWhQf76YuFiO0DRdVcYuZkBJ2iwaY+uPZayVzw/u+mu10l74xxPUfXZ5/+aUIEoP6dIx9EbkqSxNYD5oJAb51QK5fEGJif8dSrViTjKQQjxbV1oopZ4oVl3f5qmWYqvz9SXQhsBabjSXJ/n1nzxg1sDsF0TeYohWiKJuON4VwscdnzW5Qp98I+J5ciomJ0WYndeN16Gx4PXRyq8kffKJVfe7CQ7UwcXwJw==
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
> hugetlb-mremap test fails if there are no free huge pages prepared by a
> wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/hugetlb-mremap.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
> index 1c87c39780c5..09241a279ec2 100644
> --- a/tools/testing/selftests/mm/hugetlb-mremap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mremap.c
> @@ -26,6 +26,7 @@
>  #include <stdbool.h>
>  #include "kselftest.h"
>  #include "vm_util.h"
> +#include "hugepage_settings.h"
>  
>  #define DEFAULT_LENGTH_MB 10UL
>  #define MB_TO_BYTES(x) (x * 1024 * 1024)
> @@ -108,8 +109,9 @@ static void register_region_with_uffd(char *addr, size_t len)
>  
>  int main(int argc, char *argv[])
>  {
> +	unsigned long hugepage_size;
> +	int ret = 0, fd, nr;
>  	size_t length = 0;
> -	int ret = 0, fd;
>  
>  	ksft_print_header();
>  	ksft_set_plan(1);
> @@ -125,7 +127,14 @@ int main(int argc, char *argv[])
>  	else
>  		length = DEFAULT_LENGTH_MB;
>  
> +	hugepage_size = default_huge_page_size();
>  	length = MB_TO_BYTES(length);
> +	length = (length + hugepage_size) & ~(hugepage_size - 1);

I might be missing something, but if we're trying to align length to the
hugepage size, should this be:

length = (length + hugepage_size - 1) & ~(hugepage_size - 1);

like in hugetlb-mmap.c? Because the current code will add an extra
hugepage if the length is already aligned.

> +	nr = length / hugepage_size;
> +
> +	if (!hugetlb_setup_default(nr))
> +		ksft_exit_skip("Not enough huge pages\n");
> +
>  	fd = memfd_create(argv[0], MFD_HUGETLB);
>  	if (fd < 0)
>  		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));


