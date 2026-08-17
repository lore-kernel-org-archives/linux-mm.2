Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 115E7C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4016B00AF; Mon, 17 Aug 2026 06:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055AF6B0897; Mon, 17 Aug 2026 06:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E860C6B08F7; Mon, 17 Aug 2026 06:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B56A96B00AF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:23:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C90B120730
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:23:55 +0000 (UTC)
X-FDA: 85110375630.07.7430AFA
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011053.outbound.protection.outlook.com [52.101.70.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id DD6E140006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:23:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q2cVEooI;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q2cVEooI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.53 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786962231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCFOBc4NX+viqjIHoV+TH6iiLqch28DMnirjinxqNuQ=;
	b=FD6H3pzqgsPZRbKNxnN4jKiJ4Zopcc6yOzDiPWPU5QC1HfXgInw6GK91TDw2nojsMQYlRW
	O5EtLKc+hOdhFNYVqjsgztaT9Cbb7/lILx3Leure2NbhRpaSKzSA6wQwV8CmQ3YEpmuofo
	YLVLk1FL5NEDaNHFuEEo9NrLA4FTpWs=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q2cVEooI;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q2cVEooI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.53 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786962231;
	b=egY4zNe3OhDwzx9g13rsz3hvf7UfTkc1P9nIQGccbym3Mq/izXopnPVMEIoMRdjOgJjHOl
	fYCnZdvM3cLJCFwv9h0dI4Ok5e+qmRfo/WX/7cbgNdi3Ksf0D0LBm7PAnFOKzo0lRSxRGf
	+buTIEgjlEHF5BDMTbshNisOfx12oLY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cvKJYixWl/NZZ3R7CYoqPD4hvRI6UdKcRn7vR1JGh0+HqKiLEu+BLoCqE/S6KcIHlyhDxigtstK3DhwtRKqNUI7UG1yCz5EM037V2GNHaTuY5CAy4+6dwee9YTFStXTFDW9Ix5OGLZ57oCzN5BYbiaOe2Ug9xcsEct+3soTrUTynvRcAGLyl0O8T46FbspOVZRY0ZZohh5SN9rnAlcMTt7bIw2vsPjBva+BI6PJ5CJPV50pd2/tkGdRu5wQRag42uj8FmbtBSJSo+Kk4QVE+kzpmlT3wLSD7x0pyIVk66UVFK25+wh8FPzKBDE2feg/fFDaxuGUzYn9TMF19fcGOwQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCFOBc4NX+viqjIHoV+TH6iiLqch28DMnirjinxqNuQ=;
 b=aW8pFazg6hBjuwwgYg6pdiNlAIKKLRE/r7CIHBXYompEzeVHdcz0hI9Kg1D2NZKXGkU2hLQKmbWaPTpXuiKNsTzxfGbOnu1e4zIwGG09+sac2ejCgvVidznBO/yER+9KFAy2Jzcinb4hlcMgiIqsEdEqATFk8sRbousCldCnKBPKR+G7blmQ/tFElO4P7dgkk5qbLVexU5mV3mR5oN83XkINSVghtPDhE0Swc245XyK6ovX5AucdQTtHisMm381Qt0qh9AMxd5bA9uu1byiQ3rkLj9U6KTn/JhIkgLSq8nY/JxYNBhvfTj4JHCft7iFGy+tgDGFZt6ssQ4NHcCSPyQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kylinos.cn smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCFOBc4NX+viqjIHoV+TH6iiLqch28DMnirjinxqNuQ=;
 b=Q2cVEooI8R6juKV9OqQQwYJudm1dVhI0QB/Pokrry7uZtrsPQ3TqM2hyioD5FZP6y/xyJd+eh14gDwAvxbx0fA5UXfjTcKe4k+v36pTWGFGWMJq8JMFdHmvfWe3FxoMNfb/Nd3aeUvYBBdS9SmKCDTc3TbxEGIv2taJtWQBOsME=
Received: from AS4P251CA0021.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d3::11)
 by GVXPR08MB11182.eurprd08.prod.outlook.com (2603:10a6:150:1f7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Mon, 17 Aug
 2026 10:23:38 +0000
Received: from AM3PEPF0000A794.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d3:cafe::2a) by AS4P251CA0021.outlook.office365.com
 (2603:10a6:20b:5d3::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.17 via Frontend Transport; Mon,
 17 Aug 2026 10:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A794.mail.protection.outlook.com (10.167.16.123) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Mon, 17 Aug 2026 10:23:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/MDCERGY6ikSxOQeXNAYOQqvK2Nf5k1WRyKqzYqjDi9Wb884SsSKsxIhWT87+qlAWQa+f+/Cs1YSRwlzv4Fec5W8Bpn2OmtlTjbwXzlxSiUg8nwRAyZ9bVf0u/vazLAJlNMw66kAxp37s+xY1NXrQdhMfx7AqWkKkZU09aiiO+K7DRKb+kF5jKOxrtFXgfRSKTRzmqMxDzmVTsKhZ4xJqaWel6dqydwn2aabHJBtNIhAL+nNjAxcEQuNxl4IOq0ZQF6o23RsRAFAEeqLujraR/NfOiWCatFQP2CBuVxnm5KZfaM4jX9tQdEa6LWF82PGkflT3Etnc79dmVvoyd1eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCFOBc4NX+viqjIHoV+TH6iiLqch28DMnirjinxqNuQ=;
 b=vQ/6iljzYiFOS9NTshfMhvgjwxlau1HingJGMPL/hA8215frzAJssYQlyA3IcTsNLc/RAPiOfUAoBVVxYrB0JXCAmY9I3xzmbdGX0xoCUC8JACZ3C3ixqg7m3aTrUcM2OBMXugrXqN0JY/9kaK+/IW/EiK3q4p01p9RgS2PasK1XN2labZ70nBO6v4SOI2/k7hzSt9yWLQrqYwDpbjbQ8bd7U/Cgz0uL1CKX/kaRJ1iCu2i9ifXRQ3I79MbOr4t9kUllDYHTiCuQP3k1pl1LcF+I5K3rqT8rfYotVJEt1AJPePlifyxcvdZyTN5eKgthSYZESysN9q6V8hlMsIYjiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCFOBc4NX+viqjIHoV+TH6iiLqch28DMnirjinxqNuQ=;
 b=Q2cVEooI8R6juKV9OqQQwYJudm1dVhI0QB/Pokrry7uZtrsPQ3TqM2hyioD5FZP6y/xyJd+eh14gDwAvxbx0fA5UXfjTcKe4k+v36pTWGFGWMJq8JMFdHmvfWe3FxoMNfb/Nd3aeUvYBBdS9SmKCDTc3TbxEGIv2taJtWQBOsME=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by MRWPR08MB11782.eurprd08.prod.outlook.com (2603:10a6:501:97::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 10:23:03 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 10:23:02 +0000
Message-ID: <2adba3ff-e548-470a-a41e-05954733f62c@arm.com>
Date: Mon, 17 Aug 2026 11:23:01 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, shuah@kernel.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: emit KTAP output from
 ksft_kmemleak_dedup
To: Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, rppt@kernel.org,
 leitao@debian.org
References: <20260815084231.3630742-1-husong@kylinos.cn>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260815084231.3630742-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0667.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::20) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|MRWPR08MB11782:EE_|AM3PEPF0000A794:EE_|GVXPR08MB11182:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ea824e-9bda-481f-7ece-08defc499963
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|56012099006|3023799007|6133799003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 RzPCtURsoVbXO7hLZN6OvmJMgCjldSBsmq+k8FO5fp2TKLnkeu/ncain7ggGp2trbVSf2t5sxFB6etFsVtj0T/dzTAzviXCkxQLfiGKU3G1Yt0FfsxZamfbh3lrRJ2sArYxhl5eo4RcYgbVPTUoPrwOz4z81pwOn3Ls1r2E5OxosDyIf6GfAbObMT0QRU0lzZ1kY1UGWbAj/p47eQ3bMVEOWRQcMnyh1/wggUxwOm6KHdYkNvfTIMt37uElkVGzyJu7LdbjnZQNu56cRN6cF8BwOeb+7etRL8x7uOn4+ISYBqBTPX0Ntt1Q7zkbGUqDZrmDA6483JTKpuMTjeOToXu5/bQdveEE75C3+WsIwxFn0sgjfYQoI2CVpDx2YirEdzA022yQfJFCJWDfo5bIMJtB0iRKzWmkeBW7eygxMG3aUtkhcxTlmzp9iuFbHT22k8wMam25XhGQbIXaD6KHWVj1vFnS+tdlEJzMd8OeZeF24ZxwgONIVBMV6FyOm/QZh5wnZ9l+9EbsdsluxpOzUHziZyqsN7AM7rYeOE9MxBb3fbJ07CjE7d+OMLzM3nIJzEtM/Xu0oxI9dOk9A573TyikloOizYdu9gfmo6D332l9vOyFyza51xqx33Nvz2yfjQlHa9SDbBEdHRUYy57l8s2Rw30VmTd8ZKxrxYc/BDDE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 a6FXTZW1cOeKS6mgqDNmrHlxnEbpdps2h6g7YybW7+uuScy4ymUT+76gjMBHKEjLYZvOYCYtMhQRVoySnuBGrZLvQzHyLxGhWvHTTxlFYJ7s4g72XoKvnunCnUW5TU0HhIwz4D/kXU5usg2tEEE/02hcB23NshW+ND8taVpwnNI4TjL5bQ44HuZrpCZIMu631goTqI40AFxHdu5+E87vLQBw3FFdbv4mLKzunKeTJY0UwuMFsPBJJqrGQ7TVKEn/dexaJzhvKa0zznqbUkKXqHx4XdtkPOxeQ+mnVmvL5d6GMA4rwXUB8lP1T8DZI85UQQFU9hpYzHvW2wq8+l5SHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11782
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	624c08a7-535f-404b-4afc-08defc4984e4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|35042699022|36860700016|14060799003|23010399003|6133799003|3023799007|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UaCUcHSlQghKxMdxat80BhsAfN5AEfrfuZLDjt57+xTbsXyqLZMNgW/rmcx64nyserqDegelS2PGc7XyRYoBgllF+9a9WBFgXyEIpYVazmn0sesoV0VgTMP1/ur+R4Ed/2WsywNVSlN+N1+99tnRN8X5ySVTTu2XWtGFtvE2DESN8zhb9zBr0D/fCa0XBNmVPOhCR25/hBdRmuICN0sIcGbQDdX9zAm32OW1GJoM2GDJ3qMflIUtLcs0Gp8EacCInkGzHwSIhFEGLoRDZXgM+jo2wExiv6RltzXFkP+yE0VOhRIsscbjznUvi4UQgxp5haF/TqrjVh8Y/DnU5bIVUPWWMgh6qqgZOdOO5pgtnthAXtWYFKSfoIxKhG3VpTTuSYyYWH5pqgCIomjB5z/4SCb9cNmwJNfS5TZu5avLGyu+u8OLuLxC7cBBVJ95jBla8kxxHh3aqcyHXdy/5NVqrwaQ5QwPtrNApLE1szvOzDQAPJE4426KNI5Rpvhy2oTJJOquvdbmqKk4lxuq8K9KqnfYr3QBIucQnSvS0JObt5M2kewfeSi4/6lf5A7PEDwGQIDVdkRIEQqj3s08RtiBunq4TzSozAPQoN3CL76EYojtzVNhxZGweW0a3D13dx+7sHdkfOTMBLLtuQ8joweuJKWVTYiANs7iwmWIVMQEhyxbyhBZkNyAR87K/1HCVvB9x6tIK6i7bhvzLi54Zdlu0Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(35042699022)(36860700016)(14060799003)(23010399003)(6133799003)(3023799007)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gTB6CeTZZp1Our77aHn9wol8b5SS9ElxOh16A8n9KdWpf/dVMEiiqv43KPK2cdHYmEc2WBxSA1skbTHx+vO9S2Wqay4TCVejS5ZnWqpIRgTd2Wt98wYUXFXIEotwogwz0tHKi7FR0DgMTK1gKa6dUUSo2cTke2mwvRqiK3Gi9dsTa00v2muWxEk7fMozfNrkzXMEjg6DgCAo66xnU+u1qjzTqsYXSf4ntMPmEkeLCPioGInfOnLZyXvFsjUvYltFBajFKWjBYAcMWxpsd/AEQTSbg4iW80GZu3//lHlciDNK9hiNI4u+Pfq7tL0P2l88mrhqA+kOp6590H2cs3PLlnRRawkVHdayi/yUP2hFaUADZbeC+QvmINcG842oQjbsoNh4LATBnajvwak+u+zHJ4lxWevY7OTmXWUAVTMcs0HBj1OaxJ1cUjKmgLdfCfyP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 10:23:36.8494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ea824e-9bda-481f-7ece-08defc499963
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11182
X-Rspam-User: 
X-Stat-Signature: 4zaiat6uw7usxyuirir1cu4jzczibgc6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD6E140006
X-HE-Tag: 1786962230-667904
X-HE-Meta: U2FsdGVkX1/gvv5Up0OuPwle0FaGch0ex4/c6OKN67d/nwAsYcFXg4C3IacC+NYmstlADoh1mChayNmqLNMe21VWwmuDhr0vP+ACAziz+0EZh0t+b4k4UhjNOxIcPcirCYseU1Mz3cBOIyedW4XalomCtHRfpy8drsZWXng/OuSXrkqGC7lfeFF9PVbX5i+Nik44lqM8MdCFGEWeUmk8xRV1YFEGU/ZQKaCGJ3fnwHGzB15U59VcdgY6CZz9CLB6F2DeUIanoe/6irmBUyXP6qinTrz3C9paIcAElIHjAZ4vLufUs3nzn7bWkoVqvCFDMF3wmSSzexkQjDIyGB9jy7obiIf4lyXeiwIs8mN0A/nHs+MByyxYJSE+kIFy4EMYNj3jhCnPa6+bejDoSVwa8BIRwRmPZfh6DXczxVNPrvkGvD5rBNUVFKxntIU3Ekuhqm+3hZNi6Kp4axfqBOly5FGPPF6zzyDGDxo87o0cW4T9ZRGkKRFpPyDnZ4rLUDMlK7RbWTQoud6GQ6oGgcYRh0ll8yZNVG+9e1x7W2NUP8YMOZ8FG+zOHknfd7r9aLP8r6Xpcvf3z6Yiea2qVGDDhevr62YXRg0xn6WvOtPeL2Nicd+Gx9veiOuSjNTkiJuaTa4E7d8l3dj7cVhLlCC/njv6QwZSa/EEPtr83I6JMpas0uF72BRrF3yXs6mxBSXuSxaPfzoe6HcAKUS8OJsNz0co7qwLHa+/SZqmMOurQh1fCNTw+4xS8umv0CVcSX4PeSkSTtCAmj4iCVaqhbJ6BwSfq/Uo/9v1CQKuFAzzi+r0U+ywZ58H7Q3kryxRQBMFK4y1MQYRw3hIAnUg6xxQJgJtxOR1l/0js8pgebZWCPkrO0FwEYGHXgEtJb33s2/LHgEDTOmHfpqKAOS2p4H6CR6PR5KKNQqPtoQgtgt+BwH2BRMsVnW1r997jLEvJBasznrd5L/Rh6Wzay6i5z9
 X0yRiQWX
 e27hBXvPoP61WaoD22oYXTWo/B9u/OIXlaSBlPgop+dzjnnayHCj8h55LtxecHbmAKwxmvw9JjsKTyU74fTJ7KmOBliDUIrlrSmbgcandR6f5eQIH/2lc6ojHLZjb2Vg6PzWgWVIKbK4VXi4I8vmvmfdQpOJEUXtvwT2ys2/lPmr5wumVJmDKNUSFA6Wntw0gHjNnP92ZSUYD+dpweGBVgGjc7mH8/g79TZ5GXwC4E2zjZHYVxODBcJkezMYdIE2Yr8lwvxUH9ZKTyQHgykmAAZbUpiqXimrfNWTqkV7zeTIgRc643sVPPgT3dOj+W4DQlmiF3t4NuctB2U6/ysq0LpIQx/Jmg9TWFdCt7EyAxc4cIxNM6w8uPEYsHiKVREDVE3DWIdtdbcCGTvyn5xoLRIVayp1Dw6oSK44WYviKHMpPmiS4OtUfvUA+6i3EnoFr83zbO8SdB7ZWDurQ/h23aeqGps0IKODt9xiezfNtGVChyaNuOA8OgeCg0QE9ad8lenC4h3U6JLg+EDBOCJFQgXK2ck5lsx5Ggi4+MsFMWDmXMlxYA//lK5aSUBIJSQXHO3UAVNPOFaW1M/Jn0gp7A4REmxJBN8kHGVITbhnARxiRaOZ5EpNyIVk8NkWQ8m4MQx7UWOU+y6kwPUQdWTJGdmp30hxWkgYmiBfs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/08/2026 9:42 am, Song Hu wrote:
> ksft_kmemleak_dedup.sh reports its result with raw "SKIP:"/"FAIL:"/"PASS:"
> echoes and bare exit codes instead of KTAP, so parse_kselftest.py cannot
> read it.  Convert it to the ktap_helpers.sh API, like its sibling
> ksft_kmemleak_confirm.sh.
> 
> skip() and fail() emit ktap_test_skip()/ktap_test_fail() instead of
> ktap_skip_all()/ktap_exit_fail_msg(), and a single ktap_set_plan() at the
> top covers every path; ktap_finished() then prints the totals line and
> provides the exit code for skip/fail/pass alike.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
> 
> Changes in v2, per review feedback from Usama Anjum:
> - use ktap_test_skip() instead of ktap_skip_all(), and ktap_test_fail()
>   instead of ktap_exit_fail_msg()
> - move ktap_set_plan() to the very start so it covers all paths
> - call ktap_finished() on the skip and fail paths as well
Thank you for updating the patch.

Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Muhammad Usma Anjum <usama.anjum@arm.com>

> 
> v1: https://lore.kernel.org/all/20260812132142.582390-1-husong@kylinos.cn/
>  .../selftests/mm/ksft_kmemleak_dedup.sh       | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> index d01950244490..fda6a9340e0e 100755
> --- a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> +++ b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> @@ -19,24 +19,31 @@
>  #
>  # Author: Breno Leitao <leitao@debian.org>
>  
> -ksft_skip=4
> +# KTAP output helpers (ktap_test_pass, ktap_test_skip, ktap_test_fail, ...).
> +DIR="$(dirname "$(readlink -f "$0")")"
> +# shellcheck source=../kselftest/ktap_helpers.sh
> +source "${DIR}"/../kselftest/ktap_helpers.sh
> +
>  KMEMLEAK=/sys/kernel/debug/kmemleak
>  VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
>  MODULE=kmemleak-test
>  
> +ktap_print_header
> +ktap_set_plan 1
> +
>  skip() {
> -	echo "SKIP: $*"
> -	exit $ksft_skip
> +	ktap_test_skip "$*"
> +	ktap_finished
>  }
>  
>  fail() {
> -	echo "FAIL: $*"
> -	exit 1
> +	ktap_test_fail "$*"
> +	ktap_finished
>  }
>  
>  pass() {
> -	echo "PASS: $*"
> -	exit 0
> +	ktap_test_pass "$*"
> +	ktap_finished
>  }
>  
>  [ "$(id -u)" -eq 0 ] || skip "must run as root"

-- 
Thanks,
Usama


