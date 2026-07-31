Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3ACC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F359B6B00A9; Fri, 31 Jul 2026 03:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6026B00AB; Fri, 31 Jul 2026 03:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DADD86B00AC; Fri, 31 Jul 2026 03:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD7D66B00A9
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:02:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C892A0376
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:02:40 +0000 (UTC)
X-FDA: 85048178880.29.C23EDFA
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013041.outbound.protection.outlook.com [52.101.72.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 04A661C000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:02:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CJQm13eU;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CJQm13eU;
	spf=pass (imf18.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.41 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785481356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kl8lP64T02ejsYZmBCzypzL70O9dAto9bjr2oaji574=;
	b=UxY1QHEbBGZDyjkQ3BzYCUI6mv4sIivOgH/gcwIlA6ifxHWi3/8Pq1cb1zYnqHNHEx4CSq
	eJM9xh9vef0HpS+5gEM5nMiKl6ZvWu+hTSd/7aQBhU7t5b5sEpPUNfgJhTQPFpM54v/HVc
	43qTwHG6lmsN7AGf980VYbX+iy3ayig=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785481356;
	b=K5CJ6W5k3URv6RcaDb7NACzdx75oQkn9n5eAPTcwLIGFnhRzCyfMvRr/QIZwsBV8ea9xIT
	bm+iWEb2jHEmy2jSR+Ac1yyEX199yl3fXrQFS3SYTmevJ6iQ9GqTkDo72EZI4MzjImc2p4
	D0h+lR3VfnRc16AtMJNN1Gx8m4g8ZFM=
ARC-Authentication-Results: i=3;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CJQm13eU;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CJQm13eU;
	spf=pass (imf18.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.41 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XidNGTIYEQZ8emm9t1KhKgc7suAxptPeGvjl4lYZPuZNfpUoKL0lW3q67NeCH7c9L83pbh8GJvC2r1G+Wng3Y6pUBYp/HDmn8rg/nPJNA1viGEZV+WgVrdrZWZA5xYR7OazTlo45vvGDfw9J1mXjay9cMfgzwEMlTrzQ8mhk0cOntqf2RqB0Oc6DCrL0vWTmMWeukbZtItM+SleMpGWMFL/OxWpAfjdjciNWCiN5VPiumW1ipOEZh3GDd05uXIOgsa+TBNC/HzOr7as72cZxlLQdswa8le6yd8YiLfeKQZ+NY32KQFxINTX49WymjQZ9Ot9OSZJMlcIB4sZTfc5ZOQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kl8lP64T02ejsYZmBCzypzL70O9dAto9bjr2oaji574=;
 b=KNNUSDx+RcMvL9c40C4R/iNiJx09Xp693lUFJQofIWK60W/CVQpPbON1/oM8Om8f6+LbxG//5sj3jNIW4+QXVORaho/aVauYo9AkOkm5rm/yG9PCUA3pUgpAsaXae6ta+YP4Ei9tXYBzs1GJWSB1UZEySIyK3ObLv0KdKzrn4oQqZWPK8LdVxXUALZq6e7utHe3uvnwNJd/O/WQm7bEPxW3FLaKwbxejNMIqJE5zJN0ll1HltsmDUK/vNQ14OgmRTd6fwALTJjB0f4JOidwIfUs+nuH/qH2ay2Km6/RZufieEg97sFEEhyNP2eiX3UFd8NLy97jkDlRen8uMWG/Msw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kl8lP64T02ejsYZmBCzypzL70O9dAto9bjr2oaji574=;
 b=CJQm13eUCNInS/ikLgUNtmaWz0IWRapa95/78QtJCeDKaBN72F9hHWrSyHdzg5JiLDtghQd5lshA9a0OEVhs7TKWveGZfr8ko46v8O3C/qaLCAy5Kyd+Aen5OqRtH2xLcYFeHRTD8RLCrRcy8hE3YYR6fYs2HMF+CqQziahCVj0=
Received: from AM8P189CA0024.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::29)
 by AS8PR08MB7917.eurprd08.prod.outlook.com (2603:10a6:20b:538::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 07:02:30 +0000
Received: from AMS0EPF000001A1.eurprd05.prod.outlook.com
 (2603:10a6:20b:218:cafe::a9) by AM8P189CA0024.outlook.office365.com
 (2603:10a6:20b:218::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 07:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A1.mail.protection.outlook.com (10.167.16.231) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 07:02:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ib56NsqO4F6G5fpF1yhNxttTxzwjifKfztkk/zEEWdVOvPXgrSuKKh/Knm1gOq9toz3E8U21t8zwTlwM0iyAS6oEtVY+I9ANto2fgeQoiSAxQY7V7SNQXwN7RlINxBCJu+N1nSmNddxJGjLRedWcp6Nn7RCMcVUslLYLBOUJBRU3eWTcbXdk/DKEo0JoY9i/bitq9HzNtVVwc5/iGcc2LT0SvYZyekLVSVECcrzM12uX09YtQX0KZm9u9ofj1YNax7URIzlUhBpzaQ4Vf/qsm25kqPqArNguSj10qxNhUsC7Df8VQMc1/6hET/Q7oovN1Qe9EFErTXb2+rZ4GZ320w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kl8lP64T02ejsYZmBCzypzL70O9dAto9bjr2oaji574=;
 b=o7nvVtCywOYZ0hkxczJbP/tAQdLVSyCyt6eHd/n5/1P3ymfcDQWA7rCwGXpsjNvStX5suI1+opKQki1KKrPD7RuscmnJCIXIW41m3xrBdlmrx6rIb7CTUsYMK87cgoGlgSGw7ur2EZZmLdBGO0VEAR4pzE0yEKrkgHBKNBX3ay4xyFdzo9hUL1Tt646CfDeozIKvicBWYLr0IQWCNsb6ZUxn+JkArsMqAE2QVMl28qOJryR44bEfUFhyVJXlPeBctBENiH69Shv8i7CHQdmQQsiAVpfxz7RHdrqmcGUJS+CXkEiSeTuQHvnvVZRah6eJdGd83PRe798VfB7ZXSfOzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kl8lP64T02ejsYZmBCzypzL70O9dAto9bjr2oaji574=;
 b=CJQm13eUCNInS/ikLgUNtmaWz0IWRapa95/78QtJCeDKaBN72F9hHWrSyHdzg5JiLDtghQd5lshA9a0OEVhs7TKWveGZfr8ko46v8O3C/qaLCAy5Kyd+Aen5OqRtH2xLcYFeHRTD8RLCrRcy8hE3YYR6fYs2HMF+CqQziahCVj0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU4PR08MB11270.eurprd08.prod.outlook.com (2603:10a6:10:61a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 07:01:26 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 07:01:26 +0000
Message-ID: <13b12b22-4c2e-4856-a44a-61d69d0753cd@arm.com>
Date: Fri, 31 Jul 2026 12:31:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: add thp_swap_allocator to .gitignore
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260731063754.73125-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260731063754.73125-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0223.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b4::10) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU4PR08MB11270:EE_|AMS0EPF000001A1:EE_|AS8PR08MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e0d3185-474d-4cc1-9303-08deeed1af5f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|6133799003|18002099003|22082099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 atQAg+XMtS37svq/qOT4PnS/IfAeaY2R1KRPa/4p3swjs9RqtxGM9yGr5akCW/IudjEVn9jaRdLmbevj3rAnc/8I/044zn8k0Kny1KvZd9EkwvgxCx1YY/AYpINNRXijYXlamN7qWsNgtEToyTiVHg5JI5qM+utmZWOxwwISI8mF4ku6yRmvGmmesnej2Gp0pJwK9PUrC+0mYpD3hXILMQnnodFq+63HMingWlSH2NN31bbxrfwpRFClK1o4rEYoOl0lgf3HGCi2ldoch3XJNM/GM/hMzk/P6Z5Qo1cLZwULqZQnfdYKLjYEosmjCAKgtOZ78ZHChZLeQ4XmJgZ2f4HzzpTctflZnSZ0zuC8NnfW756VtVH5BQ0lLlbouqMX3Rp4GJ8kRqlVfhT9+5HGdcwzZUVlPcfMaWAOFDTy4Eh7dG4gYgb6somNZ3VZbEqo3XgqjQJHbQncmjcjiHwVzDlLt/OM4TeNtiRD1pIADOr7dgmHfc7PMJoqeWcUpC7cn6IpJkGRO2eQM80mylio6uSBXoo+hXEVIuzJ79oCzJ8A1IRQVwYAgg25NLRWkvyFNDomdlK1lpjVtCjb0K7LEXOSoNzBHhNod3UPwDHTOGAh2Ha3/gmZGMYQJbs6Z5wfAVzH2RcJe1kcVZ47SAvU/8gczJlPxzADwlH+3nZpuKc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 agycIMiWfYlGdUE/NcG+PYDgEW4YrGPIAzhgVUGZhnekrJZt++VRFM6P17ZK6KXGjtsrn029kHqqVReNWENlfIgJYD4konF8VvemSwSWcvQLw+x562Y+V0q+c1ln/JWfeJYuRhfJYW6xTUJPb8QbUsrbKAjQDIW4OXaMKnJIJQzV/uuKOZd43Jf0zlHaeVp4zH2LSBrUPTU06N/WVWLY+prF2ehvWkhGvePZl34a2bLBAJgvn7vbYTrju2u91HfgQeZ7YJWdXIhHxPm0OpCijBQcs5/a0v9NwpiOaLqWzsdqqMX1jCq/d7zXn1KanmliGeE7Mv2fBkyeOdlCXspaxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11270
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A1.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a7651882-ab1f-424b-0bee-08deeed189d8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|376014|82310400026|14060799003|35042699022|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nY0S0wL0M8oM8a4jtG7sbkmPkN3v5lZ4q7s3hQVAO7owhWE5wyh2k6GhYuyHtXun8908QJyTIihC/6pgTEogEGe8cg5NpXu0kgVJdtrEHUQ4+U0XDqBmZh3Z+VxM1+bWhW6emyF26/gXnU3x2VW7Z1LvHC3R2Ke0o6pAEti3aikFtU0p6cST2KrYmOy55nyBVElE733FyV3veTPPZ0eP1kR7qqfIczF9lnUHQcR8N+psmofFMwwP28J4b3tb7N7PxMpS6/7SH3Pvn+RK6l/6JaPYHMDdau8S7GG2H7j8ttbF4tG8iTgGpPcoHKIRKP6aW7RKBuYzfDErzJqmLk8ApZgt4TPWOOH/DQg4p5WLXb0muAVcedsDzw0bCf/x99ZIBndumTEVBy0suObRNGPOj8AMrMzVndoGd2kNHvHTc+TOqvAy1HWzCG5yahNT5tUIuRS0A8YCa+evR648prK3tWKZ7mICRb5nRIWu1ItvkQrMbMRPMwVGK9cqGj8NNQ9y88ajJsAYhQYdGzV6c8Dl3bkDoWP9/m9bPjVBBug8vJxcw55Lh398h+84lcDhsPry68tYlcjLQl83peQEJjjCGq8KsDr/tmWRfTb2htVg+xlP3BknXW7ZsW8t5x065OIqLaD9yhEruZwjiKu0UnqTFV1JJLaDQUqpbMYFV5lpCcuRgNuHOSAnCqFIH1eYxX/UPdss79vdFfWQc7j+KydB2Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(376014)(82310400026)(14060799003)(35042699022)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WUMwqrUia4W5LMIg1ua8Jtj9lZQodPhnBYkv5d6XwhHWIkoGqzBbhgTqJu8dYXXY3NWnK3RFBtPWuFhxJCrGV1s1pszC6H5HaNcB6IN/z/xapeV+QMJei15s9DkITgr6OszcvtQqOCDJNexkORr7CnepirEShDzd/aUnd8UcnyPTbo8Tyr+av2V1d+JbCxikfi8FR1VcrQsDLcfdIsncpT/NOocH3Pqg4PAJe8iJMGx4nP3UpolEUMpbnVC5aD6NRaLqcOD01MRA2H05x4GWy1Br4isOmJ2oDL75NX+Ahyqhy2M33Sg+mR9AH/gFLBQ0Z+VojK6jevBkeZCznXibgCVi61oArLZoy7LBDG7WNFgNfZI3EO8QouGRb+lnznIlaVb6BFhHJ20vFL1d0gt1S1mJH1GiuVCG+isOFqIF690zCy7mdqK4AuBsnpI68c4c
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 07:02:29.0160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0d3185-474d-4cc1-9303-08deeed1af5f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A1.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7917
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 04A661C000B
X-Stat-Signature: 1ch5ayxeu4srbz6rbpcjk3ehfsifgcra
X-HE-Tag: 1785481355-996032
X-HE-Meta: U2FsdGVkX1+OTOYquRSAImmNtsOa5CJhH3kNNOns97boVAwmh7fMc5UhXz+WtcVEMzcqrKGOC27oq7t8yXX31D9Rn2mgVIMo8Jo6/WHBMDp/Z8UhyfgV0VIu9ClpUO+O96MUd64WZPtcHzl79uc4rt/huNUp98cxFb7sTKtskhiG0EXziM9ivMPAvktQfDCJT6J8P+1XnOINzFzF33yezV31fPir8gqqq+M4LNMfUbNFv1g8RRvkc9C4+pY2F0o1nImafYcFfeRNaGsFZOktiP5lvk9jSUBX3cAQEFZfnlsKF6mOgllfUas4lIyEVtMoQW4mCflo7Zv4FuT2AhXdvvRc6Obdue90UNgPKpDqCrQ5Hl3omZcGmdQRwbOP1wL5lMI6DEJ2Zl8N26RXiD6ugudehfwDUxciicVFKtnKnYqhpomUCJd5tc26PtjX9ai3Nu65uK2jrEtZ4HOVuzQf5r/v7g9VePVQrLix5lJzR6lOGqfdj46t6OcvLvmQD8IJkkgeOore/PaMODNVqLS4tacAanEeQCsACAnxfysDM9QZobZVKOZ0OIOW+hulssGDvdriqWbsLyLH8d/8P7EY490XM+yfwDqN6aPrHWSOBHVUAQQ9aZdvrOALy1XliMjQ7p2y7xW2w2rsOrRGsjKijCWraCYJK8gymEHZQluQcBp/Kr2kL4na1TGk90ANpIMNqJx0jZwYBruREMs26LsuRBd7lm3egMYcxPBxT42vFX98LepyhZf6miSvZ0C+v1qV1C+HuSdxul+V3f2yYC+tTfJTdql8rjx/DF2CSafvDIAQePonJC87LGRi0R9Er1gTcl1Gvh0MwD2VKSbg6cRpgW4ozz6DJ4kptmXA0GD2ouaqr1o5GUMknSlwUK/pXoagu+0pKGpLztlhhPVbET62gEQ3gTiUV8SOko7zU8ehE5H+HQEmD2VK8j8x3Z/xTQt3kqHAMQSyfuZ/UNNaejt
 4NnSp7kl
 GV9GLLLKwws7tPYEP/t5uW5JzQxli/dnEKNeJA01MyErbNK4Eg/TsJhJMwseqRr0hSWI5PajmCDZ5w+4Al4nehyedrPdDveIICX5qgFlvykSEvJFv9Ugl2f98Oqc5KGuumGDGz0h3ruUmL/9J/Z9OEkXJXlf68MYM9QYKKeoVKVZh+F1kl8skRv+gTnG+I+aqvZQplf1FGqaRyO05EKMY9fxPVKZbgUcOlhQ0izNIotoHq4AOgVAc8m4LUbEn8+PFx3dNYStzf3V9Au+YSufn1agrIRdRcXyNgVCLLtn2sG1d5rJkI+EXQxgwwtBmTlTw15AIetyxtrr7vCTxduPKe46QMt9Hr6AjPbPnrLmThaBIRpCFdGBwQd7VIgPrG+TwuFRVYAqcDlH+J63vliVTJnzVS/xuBVucBxEuBpLaTzIFxF89wazFVqMGnmoRWJCnQPKlq9N7S+Sal4dzCFZMCbsOQ1h6y4+zhEGAE1GffA3igXjRmpz6LkteDMffdaihBfS9y00PSDSQ71/b003XpVyV2rY6lPzFeo7aD1My9bi6mRhqRd/zDwKuHUPP7yaWFVFi1z/R81BqSS2ZAsbMzuf6/EmHh55UP33OIoKCySpeNrdILQUZ33Yibg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/31/26 12:07 PM, Sarthak Sharma wrote:
> .gitignore currently does not include the binary
> thp_swap_allocator. Add it to .gitignore.

Sorry, it should've been thp_swap_allocator_test. Respinning with the
correct name.

> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  tools/mm/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> index 922879f93fc8..1446a659e540 100644
> --- a/tools/mm/.gitignore
> +++ b/tools/mm/.gitignore
> @@ -2,3 +2,4 @@
>  slabinfo
>  page-types
>  page_owner_sort
> +thp_swap_allocator_test


