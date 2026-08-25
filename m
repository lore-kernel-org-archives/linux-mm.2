Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 607D0C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710656B0099; Tue, 25 Aug 2026 04:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFD36B009B; Tue, 25 Aug 2026 04:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5647B6B009D; Tue, 25 Aug 2026 04:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 251776B0099
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:41:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E2851A036B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:41:54 +0000 (UTC)
X-FDA: 85139148948.27.87C60F6
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011067.outbound.protection.outlook.com [52.101.65.67])
	by imf08.hostedemail.com (Postfix) with ESMTP id 08329160002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:41:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o8V6Uf0R;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o8V6Uf0R;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.67 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znrlvvrWApFTIWKpPBp5sik/nnTkVSIVWyfhYLMHGmU=;
	b=fcdfut95lfhmCSgqIH4XU5CGl38hPnhpz573Nr1+DYGN6KN3yw8VEQOTrQovYoIDU5/k9S
	SQ5a3T2OyWXLwBrD2xoimWMwxyLoINBGxlCiB8UBRGz72KhPJiPzuGxvVrTYUFoGk0FqPc
	NNwmCx+2CR7O6iTlp/bVMdQIdhFRpks=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o8V6Uf0R;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o8V6Uf0R;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.67 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787647310;
	b=wkn5UChyl4GZI7R8l6BMTFOrjRX44Ne5txms67vv2Osc1FRyecyqlSVKR3X2Ta22LQr9d0
	alUJzGfvtdgkooxncBE8T5G65eIgmxCAhu9GUtsOFi7yQVCMnk3Yduq82S+Wsh+KvMuOSI
	vllw7aaCBCOALw/nO1XmTNbg+N30fZ4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hAG0z16mVbC60IFHoOnYs4zXiQSxybmpKLc53bVvkSKGvKgP416EN+NBOK++aSalspO1AJFvZ77VoDo2ECypPRvYcrh+TqPhuWXICW60zr+t2Exe3/roskyGkqbwn7YQb9v/LUiZV68nFnKAsuxalCAWRU57Gq3lVx1y4Vo+W0IOyygDNE5gpBwlni3xiQdqURDn0Qkf6eHyf7wet5eGGXBRISwagx4PP9nPaf7W7hBeLX0cr4R90TLsx0e2z/K55anpHQUu3R+UlRy8a6lSFSNU1fLa8R4d1IL6A0o2NxebaaQDGhhsVa3FjXZGIeFLyLRP2Clpk03gc+YjNWfZCQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znrlvvrWApFTIWKpPBp5sik/nnTkVSIVWyfhYLMHGmU=;
 b=S4z8jJH11tb2QMIp+MZ2L0ejeGLt4ck0FqmBpLwNbuazBxHRomqXP7Ifu83i41/mo9lkaUddNEiWLmAj9ok/4Vz6kG1GdkGh+CbgdCqZtzN5HN2Syz/x9zit4TGXZqKCGqpVPNh4XHVqmgsswaXfO8r8Xv7ZAVR98TDmk3R107sCyzVTnU+49QtRjd2J4hNrObREbjFP16Rtzi/EayZPAFHG4OJ4de23EbUQKFD8Pg1BHh/id4NAFXGjyhVtzcDiR5MoPGCFvfdzRajBVF/iRVAZWLyGtsFyjjYFgXPMZEH/Jc5kDyO+8j++9S8o3uk7U+Q7lCZooqP/trf+mcGcmA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znrlvvrWApFTIWKpPBp5sik/nnTkVSIVWyfhYLMHGmU=;
 b=o8V6Uf0RUZ3ZAkV2UyJeCwj3TSRwX1xsCzA9m1pNyDgqE7qO3e2oBRO0wR7+1aNAIaMHI9Wqcc/GvrmQLYOdefeJllJos6FEAp3bqd4tVQJCnehT6VJMulVZEMYZQl7v3RCSnP0PHCT7W50JUllnLGpz1w4CsRXoHzbO8p/SPyc=
Received: from DU7P195CA0029.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::12)
 by PAVPR08MB9307.eurprd08.prod.outlook.com (2603:10a6:102:304::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 08:41:39 +0000
Received: from DU2PEPF0001E9C0.eurprd03.prod.outlook.com
 (2603:10a6:10:54d:cafe::6a) by DU7P195CA0029.outlook.office365.com
 (2603:10a6:10:54d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.6 via Frontend Transport; Tue, 25
 Aug 2026 08:41:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C0.mail.protection.outlook.com (10.167.8.69) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3 via
 Frontend Transport; Tue, 25 Aug 2026 08:41:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KNh7X2oIHaAwbxPwzXs9VXJi78+RiBBSD8MRGNI4D+jpMaLLLih0DokP9DYq38qlJJbskFIeYxtBg7g9kwz/wVsYfPT+0qRejGpul29yScInyHO1RMxXuJ+9e+MzhPqa99LSsoO9GMXCWQDn3W2+bHWXj5bz/Xh3CEgfGlREXHuQztTqOeu/h32uoGLCBGYX4GxnH0JJVGPJaqrG4MMesyin/9f/id20nix4GKocmnrJz018G4fOkYATsLVeSB/dhds42Mc/6DPW3zjOzXB9Lhy5opT2L0fhaGEocpSoIJnErT20B8Nomwta1NQHWvp6CBvglx6Aq0cgZ0VFMPTuCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znrlvvrWApFTIWKpPBp5sik/nnTkVSIVWyfhYLMHGmU=;
 b=HE5hArzF065ckOWR0g4Uw9rzdMzmY5ksKt35mhA6Aerfp001cY/7s4nr9CLbIJB32CnZYViZFVn7gz0JySkreJw7nQqAnD8VlZkvXcVDv8/MFCP6ugrhmrvtYJ45aFQe/HtxG4yR3rjTb+cOLvohH7YzX+vEdepZvd43R0iz9y8FmP/1K6s3zkoxfRCtUkDmhs4oKDc9n1IbNWiO/UDkbGakmfPBqnKCDCN/Jwyx8WdtwOdLjiJugk0DmpI4WXfV0Lc1kxRDTWCGEw9++8b5GfDO6/4Jj0xhhcQgPXbkkTfuuMJo0QuEHgz64aXSoGdWdIxo/KEdzSMtEu1Em4FEbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znrlvvrWApFTIWKpPBp5sik/nnTkVSIVWyfhYLMHGmU=;
 b=o8V6Uf0RUZ3ZAkV2UyJeCwj3TSRwX1xsCzA9m1pNyDgqE7qO3e2oBRO0wR7+1aNAIaMHI9Wqcc/GvrmQLYOdefeJllJos6FEAp3bqd4tVQJCnehT6VJMulVZEMYZQl7v3RCSnP0PHCT7W50JUllnLGpz1w4CsRXoHzbO8p/SPyc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GVXPR08MB11786.eurprd08.prod.outlook.com (2603:10a6:150:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 08:41:02 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0360.005; Tue, 25 Aug 2026
 08:41:01 +0000
Message-ID: <4ce8b956-db74-453c-bdbb-9eeeec1be9af@arm.com>
Date: Tue, 25 Aug 2026 14:10:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] selftests/mm: make file helpers return errors
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-2-sarthak.sharma@arm.com>
 <75738049-24f9-4056-98c8-b4075552ab78@kernel.org>
 <e4f8031e-20ea-46d1-914d-005595243f31@sirena.org.uk>
 <e87ac26a-9712-4f6f-b144-b604b2aa643b@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <e87ac26a-9712-4f6f-b144-b604b2aa643b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0342.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:21f::9) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GVXPR08MB11786:EE_|DU2PEPF0001E9C0:EE_|PAVPR08MB9307:EE_
X-MS-Office365-Filtering-Correlation-Id: acd44658-2d1b-4597-befd-08df0284adfe
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 owQQ+y3Bc23gDrLRSlHoizJo7W1ZpHuAdRda8OHkFZr+wZyVs+I5EE0lgs9+mOYB8lLOtMNeRqZTPG2coYaFhbQAYRebkAaONhiWb5tNtSsuus2R9IZmTBL4inR+Z8qIYPWpf4wpTtZbvoKqpGgExTAlJua1NHCqs8pmuXsLKh6uaBx006cr0dJNejYyYaaEqWoGXB+Aq5HXKlMo2+42vPPoHEOEeRZevatqjCTVcH7gecI8rCHaztd4SbLMqN3dw4KRG9PPtO5P0RM5DpCEpd/usm8AuS8ARHZWo97DepUSSTQXEqJ/S2GEA7ZGpoTDy2OzTAWiidoevsr9ayq4vlhrXCPClfCXwmWMmVsPNKoIm90sGgdFdhH/1EPM9WLHbKCl5Ty720Msaj77A9sgegF/jR3sHEzoGQnSRqdVtNy3ytSltW6b2/dbjA0evi92lTOImKTWsAeJL/i4l7ke1CBFXBH4/Aaj1F93RHVqcShFZf7sQd+xLT0ynEHF4MspW0B6UWN0BfvIJ9cJyV+I5X7yWyrwAiby7b3Z0nHfZxJB7BurxdfjtT7gf3OQSLdO86/Ulh0n2gdN9ZORgshzesa9/1VIb8svrvn5rK+skswDNBd7ollxCBTL7Ct9i0Yn9Ax54XfznJSMDPRW1Ozk7mkS3A0hQIKa94OxAlolFLI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 1HMUyQ7vtoez6mwJFPe8+L1oVXwHRtSAxW4bxe6hYt1ycTomfAyf4DSgMKGo6riyP3KVL/rXs3PpTdA/RlXQJDcIKzn7OoUlIxCLG1FIznXeVSCfKKdK8Bp0uFLINo9gbpTI9L0Aa0yFAq3rEi2loeFNWTLJpnms8t1qmCAy4D8jtngzoBEwicgAc6ik9cWoInsUy32qWArYWCGwIEXCepvE5uzQ2KUDIbwkEI/uG1GQvZQ12CeSslQmjwvNBUTFkGvpq1nubL0d5AR1N2OBMUT7eCTUfsjfmrynnGa4Xd8MCQGJHnjrxjMx0Xg0Z8AOYynU4yvEdYM0I4TMSJ3bfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11786
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7d8c05b6-0b64-431e-5d83-08df02849766
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|82310400026|7416014|1800799024|376014|23010399003|10067099003|56012099006|22082099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	q0JNiZI8M3v1v33xfBbC1KBGSUkkGbVBjYlodFkI1QN2tdfH39f6cfxG4hxebjtoFeq/iVYlk/hcjTj/9z2oqhDFPB0c3Jfu5qUPEjZ/YKknPIMpcgO0TGtwXx+VkaoAGG6cO2MASgN5NRSmq5a8C93VbWNsquXH1cmaAmskDezAn7jYcInwjG0//NwyVv1wryxa00JAxKIkXb2JR2vLUwRQfpRVQPskgsvOvQADulMeS+smNuZI4IUtZPWX/ABYgUrdDa787KJWpjpb69j4FBBAfw4O+towgK+LD9F+Se6nRNxUZJruUrgMv6uiNThcxrvrk9Q2OzIw0s1Q3cxpXngO02dB3UB/2AR5CG9KPevK1fiqWgOCFooqzC0++bsYNNtkg5f/2Z5MhD3Ql1gRb8JFutFTQH9xHNNnAqexEpxYnWrIw1vQ6egW3WNBHr5cr/NGmDVGF7I4GqHfGRTzeazHPuquKlKJIegNANLF8h3mtCY/aI5tUbEaWAfoRWNMxqU6RfVI53TMXbNN/tIRlJxWIuMJGKe1TiXuItGcExaPwlHdiLmokSvAQhzFnBTvV5A9lXiw2+cAPOPa2v5e5kRiK/G97JOBCHjvOsZynMjtQF0EU2TDAQWHI8+hHSGda7yF/MWpgOF62wbA4PUSaA8SOEwojZsrAXFNhPmXOx5zs+3o993QCD6XuQRjYjHCcxNRk3hYNFxvx8CUO4oYMw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(82310400026)(7416014)(1800799024)(376014)(23010399003)(10067099003)(56012099006)(22082099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QlCezXYrOKdvQ44wz7TgUrIxHC9lerWrfRKT8qHCGMj/hBBAymz+nsCIu4FAQ9RdJdekAmMvKp5CQaIyCBF/cNmruyPZwI3scubmTf8L0VmPArqHskCt1QKtSOvBvVmHvXoUdB8jVDyyCRx23SGFFlCRSjYoyxSSqULA4VHCwmmInh/tL3YggHP5pdZX31HKygMrssFSokabhhGJ4A1nZ1o6mSxRabaelLx//yBFzAK7lSlpl2cx3rMjznmlb0ht6zCUSRBTNMYPQjp+y96KWHbhnE3LkUszzK29O1ZwmNXKHJREb9aVqw6NhGzGcBr75WQ8q/mlfm8cDi8z69uOklDGofMGhB1At6pJuvWi74zGs+xJTgG8yZlJbtnKpeRz/0ZQ58meVflc+kkIcHi1AAHTVwkjDoPxC1Xn/wBINuVIR7TWA5Re9dyC6zXS4uXt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 08:41:38.6982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acd44658-2d1b-4597-befd-08df0284adfe
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9307
X-Stat-Signature: e6kzxez1h9s69ps1kjqht3t15wsutszg
X-Rspamd-Queue-Id: 08329160002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787647309-605112
X-HE-Meta: U2FsdGVkX1+3y5CguJl0c5gWRWnH/iH6yfp5t1x0LHc0t6+7RpKzq4thpXagk2W8osnkU7ueJbpZNAOEX7PpI6DEkO96uLCiisrPgeb6PHCX7rrRfzR8zi9NRLQcnDtSauNu1gs5RlP3BbKGAMKc+hAW5goAC/sDU3XOCOkEdZRIQUusKFFxF9b8WqFDP8ZHX+X7EekDzh143Smh2hk9lWO4uFizj8iqwjq0iPWPorHoWsOEuJPlhfe2mMMfdti9vgX739/SZICq2h0Dhk3PC2e8TMaqlaNnE2yhUhsQB6RDiFel7JafRED0WZ7Z5L7LvrvJhVr4YBtSzj6IMKzxplcBAUBgkXc5lH8XUypfrwyEhq9X3jMbYw8N//ezcYZQFBa4xQx5wzGaaxqLOlbjtN8SlMt/nT9gkHiGDkB2yVe2CRn55d51tCzX056o3XUhdsNVzVVCUen9dB/3AGyiPkJ6hAuNC2mkl1NAZDsbPLSCmYIxpv4CIbHjGwmeIgYbMy0TVME+1MZsB5u51nfPZv+9ekodm5ewA/sbDeORkIu/TsMf/2dX+iOG9P5m4EC326QTm5S/Q8CuzAKijZ4Va4RhD0mlOiz2QRb8ZTaukrhhWpBGAwSAO6ZPrCkixbE72msy4+Brd/6DHLZfrEqvgFxd30jqWXwvOWmD0Ro9RqIudsYKczDVWicapYdTFNo16kUa9x0Sny0NHU/pBen3reHZqj/y/2MoMCLF2c0JzM9t9vv/K36v/4I8AV7DgMq6isOJiDW4pRLKYuYA05bjJPF1nh3NX15b/YsahsKFGvy7DV61JczJoGlVSkr5PU0sfgWu+QT9Xi+/lMYgUixTOgGVSN9VjOO+vyw1lRDQ7f42/GLdEiPqibRAIggLe9qRpYI9+f9WsrPz2g4S1WtpbkC/BYQlmtaz+173jQ+fUU64K2u1kqt5Hwk7AcCf6VxtjyeQIvEFF42NZeED3tr
 zToO5Y+x
 cOqp/JFfaXHxJgb0UDvw1IzJum804QXcTCFYI/Y0ovWzZx2i0Y+5i9OtLoYl2/x011z3QrbVOQrTtEepSRLcFi1+fpHeFq006M/Cw7e8JEzsr1Ddj+Vkfs0FqUL6DR4ALL2+dwwkIWnSU04ZuEbzwBViyqwOQ+MiZ2MU4uZKTOrWLk9p5wM0wOCqo/UlfdlwY4Vqz0KygdQsQna6RbAVWX37IjWeAiePcT4xO9I/zDwFlwTiTgGoQj6NnDzw3icJ6If36GDqNsh5SI/cwZ3pl/aTCIjrkKROfQYCEcadDeRn4M0f6d/eTi8rMS5sMKx6X+XL7A33nc5QUAsd4vza1aJX0muOT3T4XI8EyeeqDE2vJk3aeGiMmb7E57wihezTRc5Hfm6EC3zNsEYapBS4Qu6HXwv5HAGQM2xRH0RxP0Spz4aK9veNEGfNQMBDm//HknyvrXaOuP1NaNy6gRX/P/ChHKHUspW++rsv0/tpblUmBoUJxTeEaOJ9Pc98lwqn7KIGykt0pLuB5TD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David and Mark!

On 8/24/26 5:59 PM, David Hildenbrand (Arm) wrote:
> On 8/24/26 14:27, Mark Brown wrote:
>> On Mon, Aug 24, 2026 at 02:17:03PM +0200, David Hildenbrand (Arm) wrote:
>>> On 8/13/26 20:12, Sarthak Sharma wrote:
>>
>>>> +	if (buf[0] < '0' || buf[0] > '9')
>>>> +		return -EINVAL;
>>
>>> This is to reject any negative or hexadecimal numbers I assume?
>>
>> That won't reject hexidecimal - 0xNNNN matches the above.
> 
> Ugh, yes (and stuff starting without 0x would not be detected consistently).
> 

Yup, this is to reject anything that is not a digit. This check does not
reject hexadecimal values, but the strtoul(..., 10) stops at the x in
0xNNNN. Then the check

if (*end != '\0')
		return -EINVAL;

makes read_num() return -EINVAL.

