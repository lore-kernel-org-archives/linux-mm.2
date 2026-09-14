Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45345C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6CD76B0088; Mon, 14 Sep 2026 07:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44B26B008C; Mon, 14 Sep 2026 07:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35336B0092; Mon, 14 Sep 2026 07:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A41706B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:28:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30FB0A4B02
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:28:27 +0000 (UTC)
X-FDA: 85212144654.29.5BD2ADA
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011068.outbound.protection.outlook.com [52.101.70.68])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3D00C0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:28:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Gyl7Kutg;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Gyl7Kutg;
	spf=pass (imf28.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.68 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789385303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IORzf6hTXzzD5HBSQTWqU5pd92WlzrFcbrhcZHUqaVU=;
	b=EL6I8Lh/JrIC4f/+xPdeDGGttOjhFUcvCFKEgaPG8kgV9mNtUeyezWAMfQB0A+34R+qepJ
	jWwWOOlXwouQiXAb9u3BOz9U0L0GBpUco2EoskQJR3GZ80gbViKo9iryttUBT9c0b3UOO9
	pCwpmkDTztbh1g7o6IvwYZwCGjXneLI=
ARC-Authentication-Results: i=3;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Gyl7Kutg;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Gyl7Kutg;
	spf=pass (imf28.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.68 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789385303;
	b=A8QzK9cUwgaOWL3mwMem921CioNsUtXppjeIb9+F5DakPbdpXXoM8oEjkkY4UMO8t9nF6m
	JvDWOgwG6C+YPGSBRhUKt2k/aQDBXuNpxg6i7xYBctof8qOrQX3k6cvJDf1+3cuYu19WVi
	aF2QZvV9Y2LkComh40ZRQE87H2Im4xU=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=fTGLtEpAyJQqvp7x9Zmmo+Z5FN5jC9D0LT40Bri0CXmnkt/4GZ8K55n9lQWxvTEVKhfm/HutSChCyMshm2cm6q7OpVEb+FhI0ij7WI8y8TPNXRIaxtrs6xCgz7u1suH3rbbrkaSWDPxrLKvo3ZuOlcATiy+F8F8Nw4jZNcft3Ib90HtwWqpVeYnuTTtQr6qoznEjdPt9HhGbhsv4gF2F2ujiTYc3wXyTp+GPKMWokgYt5rrA7z7fwO/PIuW8hrT5xylceOp6pbusd/QvKmruXDmrp9AoVM0NeDG7Etw5oHX6yTgHlLM4qmjLeiTn2RLkUpkJFnRIOcABLPSewx+NcA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IORzf6hTXzzD5HBSQTWqU5pd92WlzrFcbrhcZHUqaVU=;
 b=ZV8xUmKOjugdCCK92glznHMFCPk4G9AynOq+WyqlnUjguTAHROPO2yjT0eI6dffrQKg7wxhAC1Xr/oUfoBOlihCochJvINsfU8j+SI4X52uV8dUMJ7ko2CkxtyjXq4GPpLB9ywuvH4f2o0iX2Kxt4aS5EJCv/g4z+wHqSnf3kskHeuHfcx1xyszrBzK5fqS0sykoewDrgZpia167fANVsimeIadTQl3N7u23B97ntM/ow3/l2aKlnDx9u0rPk+ZYmqeOyT0D18Nn1u7y/NsTha8dGKwvpeHBXU/DtHuv+YZUCVLf9G4wfJwbHJkXryvWrlekags2h5FwCtlVLyyJ9A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IORzf6hTXzzD5HBSQTWqU5pd92WlzrFcbrhcZHUqaVU=;
 b=Gyl7Kutgod9l1o+eJYo2WN6j2KFbaL56d5yZ/vX5lt3MYJ3/BMQDTh/4kSZIqATTTipiA87tRaMPMpgICHhNVF1lyZ/OEBb++GyxEjP0B6kwCmYQNFsdtcngyNKcHKIEN+YVRUDIDWo74trQmkBIqyVkwmg8SS/PZEUC30NvKyQ=
Received: from AS4P250CA0024.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5e3::17)
 by PAXPR08MB6558.eurprd08.prod.outlook.com (2603:10a6:102:151::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Mon, 14 Sep
 2026 11:28:16 +0000
Received: from AMS0EPF0000056B.eurprd02.prod.outlook.com
 (2603:10a6:20b:5e3:cafe::7b) by AS4P250CA0024.outlook.office365.com
 (2603:10a6:20b:5e3::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Mon,
 14 Sep 2026 11:28:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000056B.mail.protection.outlook.com (10.167.242.121) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.7
 via Frontend Transport; Mon, 14 Sep 2026 11:28:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bFCxX2qLKFhJiyhr412gEzlmrBHCUkVUdLubS8246PLSANQv12YWsW2g8jeZZCUEbPc1kDcQ1XfVs1yTGQB68ommqC9il7Mt2HqCm5+KfkZAwveUyqi8e2TQYYrvGnQBZUO3njIUbKo51KatVus+LOStqfZbKmPv0jX+JoY8gfhrHwx+AzGHHn38Quft3qlil+HxLgTlfdytIXTaTCe4gSxtQ8psXGIZeuttUa3mbbOiMRv/xQbbB/Nn2dU7gRNCGHVRpIUubVsglEBX77x9sFkVxbpp6EEbVbIwWPyicKD7mncbyzYI+BI+TY4rYYEF6VVwQM+cnggSwiBDF8WXwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IORzf6hTXzzD5HBSQTWqU5pd92WlzrFcbrhcZHUqaVU=;
 b=TIbLstOaXxP7s3s4N+DfN3xZyHH09NmPqsP8zaAYO9eRq33laico/wB+g3YP63tGk42wU+yxnYYC0VJ7vMIHTHRAmeuzCEKJ73X8bUZd9/N1jpVL3nNsXHPKy3Q4qImnej4vdLtgGFIVs2KXx99zT1xhLtvFcUBf+mh38XmzUOWvc9bNj461h83Yz7C5sbH7HrFi1c5CLX7beeQ82bPd00gWIQ/DTfpciKanqFw9QsWFp6s1NeFth412OsjenkjUmIBoVt8ikKUXY5SuQ/TRLLMy3XgWDZT+bYlADhMFUxsbQDffdigNNwNJI3OBS0F3ETDo/PegXGH1Fmjm/WNuxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IORzf6hTXzzD5HBSQTWqU5pd92WlzrFcbrhcZHUqaVU=;
 b=Gyl7Kutgod9l1o+eJYo2WN6j2KFbaL56d5yZ/vX5lt3MYJ3/BMQDTh/4kSZIqATTTipiA87tRaMPMpgICHhNVF1lyZ/OEBb++GyxEjP0B6kwCmYQNFsdtcngyNKcHKIEN+YVRUDIDWo74trQmkBIqyVkwmg8SS/PZEUC30NvKyQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV2PR08MB11371.eurprd08.prod.outlook.com (2603:10a6:150:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Mon, 14 Sep
 2026 11:27:39 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0428.004; Mon, 14 Sep 2026
 11:27:38 +0000
Message-ID: <146cf43c-c95f-4b36-9525-e51f5821ee86@arm.com>
Date: Mon, 14 Sep 2026 12:27:36 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)"
 <linux-arm-kernel@lists.infradead.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)"
 <bpf@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/7] arm64: Batch PSTATE.TCO handling in kernel nofault
 loops
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0590.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::6) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV2PR08MB11371:EE_|AMS0EPF0000056B:EE_|PAXPR08MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: f0f98e52-f381-4b5d-b336-08df1253450a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 8cCwd2pf/fz2zJCLTN0PAAWVP5goXiOwW1rCza1G2eZPK5ilaf9d97OLyjhlD5F79OrraFrgnZ+5C0ygj3WD/VT4H/vMtGW1lx1eHt7a2+433qEvbH1hJLKE3Tdo9UhcPjAWTKzfl74A/UPeUQCxQYLk3vD30pov9/1xBJ98xREEUOpeC7epYbHWi/EvlUT42lgd37GI/pfIoSafTR+thFFZ9tVbVwfQTJNJaJjR2JqoMCscOYgs33eudI1tLDOlVnodtXFGX66DPW55D6GlWusaoe4SCCWWIxyc3CkLP4pE7oD2iQkhigCXBQoubHSXVT//IEyO0wNd/YE9QbybxNh6zbl9JOIWE7dleKLegw0oW9DqG9PDnPA8KGG1S3vQ425eiXHFNIW30Ebz/b0dC6nD+K9Z9YDWBG9Lor9jZV5skJi8dEPX95j1RSxIt4zI1bg+sjiNncwO5ZPe9n2P/CtV272kcZie3MjoSyPAJJ8NV815apJYY537VuahbksNAVCvjPDYI4TcAreg5i+jkXm/sZ7/TgotdwEqPR1cqBKm0hFJ4BJ7w6KznTN+UjyMbNeR+QKPR0qtsppTLpL1WZ+Jx7C+qLbGxHH4hKoyK9gCynYgbvXByc2uE5LcLufIoY+JbvE4P8W8XwusBOLviqNpILWMsAmj1XQr3mzxMuk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 25dvcssoOowG0WPrm+OPz2fr9CJ+Zl/Jufa2nxpDh6qnBBaC2MbSP1Z0fxbpHrmOJXQu8JyPPGbledl7veIWik3mN8rwdvRnizYAgABZUBCrGEWXXBdolUDcoNx6Z9lzH2rOjhPKl5saXpT5ojTlYsEBLA6XAzg6sa12WN9cW73gdtr5Y0EfbVpJMcPpy/fAWzSCxulMckN6y2aBY/NRNJnxL9G25hRDbVBMyQdULwTi/RUlblUHgkkk7k6rG5AkoyHVnPzDCkwi9REKB3Ut0U8/SxxeS+Ro7rE/wlh3iY7dCiR7GZhkLaLCxpb09Tm/A+mzPmRGQU+5C/gs1ZzsIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11371
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000056B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4bde7311-8466-425f-3cee-08df12532ea7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|1800799024|35042699022|376014|14060799003|82310400026|23010399003|22082099003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	R9z8wpKqBADxOV7j+h7lXkumcKNlAbNQUEM1QJ08k2h1ofM+g02Mpe/hDjqV5nK53TIjzKMzfWUYKgTifuGO8V89QYY6IfRMyvkz8aiKizjOE1gZurFauGihXdBgVf4R26OwRjmQ30TBho25Xq3plK59ch8oJf45aGB53V/XaO5XOfnBQQ5sQUbQ9FljxRLs/4B0bx5LyPQ/VHGEhIvG6bYxAaKa7aM4WjpWHRa1WmvK9FKJzVbrxzgKTqpekX4vr4ex/04pOPIcVOL3OyJs0ZerVgNQlF4/fo+K74e860xjavZb4q6gBnnUTeI0pL5apmzNXSu/ygs6OUTFzlPY35iVLA8uOx6gzsPM61eL2EHeelYKI32PqM4WZz7cmLV1LZLQOEBP4wVF/5YcIXwVGSyVrpEoyxdg01RjkQnA9LA/1zy/CPyd7mvI88bGfGZUWKsxqzIMgQWutIdpjI+8MDsnxbXK95ZHx01LPoKO+msPYYcpeBluM5uzkkEH248xFX6M6PnnxMpxjaItAThq3dvssH4c4EwGKU2q52YR2tNjp760WypWsIcvSapoMDHtZ9f12lXTkyvoLSmCiSJspKuUl95neb+1+ivKNKVZ7d/CT+r4wdt8iPrtPti3jW8Lps73IubE8OxbyjqWIsPg4x9Py4zeOGR4Fjl0FKiJjMGg2sO+Q5oj2h2ZBysAGRA2+UtmB9y2DIKuY47eOhKlAQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(1800799024)(35042699022)(376014)(14060799003)(82310400026)(23010399003)(22082099003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MdS81Emzv7M9jHcJoX2aO+ROOxgFDHfK8lQ2Ljn0hi+69BO+bTCEbcqGwZ7HvagxD5Wp2CU8M+d8H8ZEY+6aWi2w0CRg0GbxL09KsP1JDdXcbTM8w4HIfBoDbVNclzVSM0BXjRiHEeptpHcD/ew0JM5hYDWhevUwJOrCS74D7Aejygf7lgBv45TtvbwswDeELIe7/GCxrNU71Y3ycqbktVVceTO2GK+fQQGYK4qRagTdZ2cxzoNLg11XzSL0M/B+8rmZuDd7TirEFlA+qQxVmwzKE1RTpz0N6FGmkhFVsvKr5gd5yNeyk2mtbiuhLjElDjmdgAYkFYIVc+Nfrpk+CyrUetZRbTem0IgNIhA716oCtVASY5BiWptqs+XCNJliQsYJGxmfkv5XCMqyh5HeUhoSQFfqQBJ1CXivTYpJFhbqpcQH1WSADy4LLsB/iTGq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 11:28:15.8882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f98e52-f381-4b5d-b336-08df1253450a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000056B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6558
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3D00C0007
X-Stat-Signature: cxq3dfndxjntayqtgfuw8npjtf5sfwip
X-Rspam-User: 
X-HE-Tag: 1789385302-102644
X-HE-Meta: U2FsdGVkX19n1iV3HfBJCBWmOs5mlisqroJDt7cPVkAAmc4jbhNpk2SJ3JFjJrn1XIM373z6m4sE6sSIcUlHgDtvPweN2ztc/U0SqcUzHKgrjxLdkY/xYCdLjTbDydtBPa1zBcqFeexjUkKfeOiKoMEEjCYHuSof8Ld8EULELng76cPM/H80JUuPseTrwSwz/VGNEJtw5sz2lB60IJHbVgFKyRpuPoOUHtFTxEgZf/S3kmcpvSmqAc0Jmi/upzN01wOsW6t1DsqMrkf37O+XU2/UCLF87XSrpGM9OgJz+Xb+XRWhDLpaLPOVGmYhNZS1pC4G9P/D+otqGKvJpi5Jk3oci6inHGCkx4Id5j1Y0utiUy7HorZ94OGJH4FwSfr8ctPvYpz5H3zhJYpKz63R0o79KEqNw0CdO8NSFrlBscaqoYgWUIfzUFNdEZrM8eo4wu0ppXIiWKV0saqR31hnYukZRu+jSMGJJRr3/enL+WQ++oI6RFRe1MIesZ1K5uqhDe0PnTFu4RUHVFHx4zeRm4/3KGjRphsJ+Yga++Aa+oZXuPD0Gun2CTPHxdDvMk0zDWeU+FKqQmXL0R5I3aQDkogRYcy7HtFglExCLtJx2HG0RIgeqafGsZwohnYhnNTDrGyX18FlK77m3/R+8pB0lTr5X4Y0m91CTE/MSIcsOa+gcgE2yH2Fwpr8sHVBg0De8NTAacrumgAGT1bPh5gnCxKBWwrDr6TwK+4VPPqvUt6hD0bTSemPrZ46mvGqpguAltk9qh4NID+fwCOYEOoUhjfXlNkR0LVRRRh54DOFBzSFedHkjFj+ZwHVhLQsrQl4S1Cq08IRud1it0Elmuyg16Oe0wjxnc1zWznve5sktIdQkXxjv2+k31pUh3lN+yGo7l5kduxsIqGNrP07iE80c4sJK127OsoTqUEC3iObh/bCNnMaVcxIe+4aYXNC6aKGFbqS8O0hmdr+C5df0ne
 4/8Kkd7i
 mx5bH7uebNgmIIfyBFOpign81oRyYii541lHoL1J7EH7hlvHsKrPC2zQAq//xuodnGjObCYgmyNldz9pO/7u6/c+EToJFWn99tf36G71Fnn7VBlgySu7adYFo5LGCUQbXQsXOT7iVU399BFBcKqPEczLRqRkCPep6R9F3cLKmVxVjsbILVEUvwQElwcAgz5E/k2TJUqtrTDBKZ7iCham0B8Yk7HbGzEBG1/qMHKPn1RA8CONAeYCx0Pyqln3TWz/CYOk8varIaekcxWTF4RfYbIOnaI8cYDazgM+Ky9tQ0dRrg8gBOyWcQiEsMeiQk96RHieEJGPTmdrnQA6cQxl3GI6wcr3FlF81BSZ1NzILFEAOOlV/5tcSg0pvcJ0V9DOxH5PuVU143ZtrX24N340veNHs4VFbeO5kxSb8bdcdNG3b1HlRcJiHzLQl9iHJs0mR6h9Bb91lqCKyfM7I2QZAWAg+iczhv85GggCoycn3/XCds4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reminder

On 24/08/2026 5:04 pm, Muhammad Usama Anjum wrote:
> With Hardware Tag-Based KASAN in asynchronous or asymmetric mode, kernel
> nofault loops currently set and clear PSTATE.TCO around every access.
> 
> Introduce bare nofault accessors, batching hooks, and an internal scope
> guard. Convert maccess page-fault cleanup to scoped form. Skip
> page-fault setup for zero-sized kernel nofault copies and zero-length
> BPF string operations. Then use bare primitives in the maccess and BPF
> loops. For non-empty operations, this reduces the code-derived dynamic
> MSR TCO execution count from 2N to 2. Two-string BPF comparisons fall
> from 4N to 2.
> 
> The BPF changes and an earlier maccess implementation with explicit
> cleanup were tested with QEMU arm64 using Hardware Tag-Based KASAN in
> synchronous, asynchronous, and asymmetric modes. All nine arm64 MTE
> kselftests passed in each mode, as did the 138 focused BPF string_kfuncs
> and varlen subtests. The focused BPF tests also passed with the default
> non-MTE arm64 CPU model. Both final maccess scoped-guard patches were
> arm64 cross-built. Runtime tests have not been rerun after that
> conversion.
> 
> Muhammad Usama Anjum (7):
>   arm64: uaccess: Add batched kernel nofault accessors
>   uaccess: Add scope guard for bare kernel nofault regions
>   maccess: Skip setup for zero-sized kernel nofault copies
>   maccess: Use a scoped guard for page faults
>   maccess: Batch TCO handling in kernel nofault loops
>   bpf: Skip setup for zero-length string kfunc operations
>   bpf: Batch TCO handling in string kfuncs
> 
>  arch/arm64/include/asm/uaccess.h | 71 ++++++++++++++++++++++++--------
>  include/linux/uaccess.h          | 20 +++++++++
>  kernel/bpf/helpers.c             | 41 ++++++++++++------
>  mm/maccess.c                     | 68 ++++++++++++++++--------------
>  4 files changed, 139 insertions(+), 61 deletions(-)
> 


-- 
Thanks,
Usama

