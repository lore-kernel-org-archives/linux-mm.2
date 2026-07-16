Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE29EC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F876B0125; Thu, 16 Jul 2026 11:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7BA6B0128; Thu, 16 Jul 2026 11:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0586B0129; Thu, 16 Jul 2026 11:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 758AB6B0125
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:27:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EF181C00A9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:58:47 +0000 (UTC)
X-FDA: 84994644294.03.BBAF225
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010017.outbound.protection.outlook.com [52.101.69.17])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9194D140008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:58:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=psHehe13;
	dkim=pass header.d=arm.com header.s=selector1 header.b=psHehe13;
	spf=pass (imf26.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.69.17 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784206723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZV/TlEPUcCZjtQEfzTsrUOXphHuDJRHG0HWd09xWIg=;
	b=xe1LMbL4Iw5MeJ2uQnU9WmJIsVKToCadrHFkTQiVmR7z8DLvAfYV+GKgPUNE49TgUyVqdd
	SnM5Ob7qSRU8nQRA4A57P0d9eyidCwrgcDfzAhmFCYMobSu4O9HLYHyV0ok6g23AE/jyWP
	QsVLCunonmQwcLPbU/th+H9dhWreO9g=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784206723;
	b=EmXhYJDKvlYzWdW1y4qk9RX28NAG3ESh0PjHYLCV4u2keP/3KK2wxWelbeqxZHhM76LsXf
	0w4AhlkhtHcSbBJfxUkSEX4atZjnr+QtQ/J9OQKmITKMYFAu1cC6O0VMZyUhPigJTXW5CE
	bgiXHUwBZ5akfgoRVpT1aZMQx+SdwIA=
ARC-Authentication-Results: i=3;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=psHehe13;
	dkim=pass header.d=arm.com header.s=selector1 header.b=psHehe13;
	spf=pass (imf26.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.69.17 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UFEyIma2yavEggHLvpwcaPg0draNF1IYJU84qV60fL792/fIfv8vNRbvH5XYxzyOMmO+/jJcZOCbZMddbSWmfOnDVM7NG3Vu80ApRPt7NynuXDTArJxBsNIBn3hR9Ej/9CYuSQVAO8zTsqdAak849HAm0vcqenGVaAlm+tTyRYxi9wOCcJqqrXtquH76k7ab2dzXDdieA6mKfYK5nEKe+iv0TLoTpkMo03NFCP8Mm3LBAOr+ci35W4h91KjvVVpYu1wkaFBEjeTzAjwxOeswQpnjWVk8WktVcWtdBYXUy4+S68Boplnn89YTlmpuF8IG04YeF11nBskYJGIWHuxiWQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZV/TlEPUcCZjtQEfzTsrUOXphHuDJRHG0HWd09xWIg=;
 b=QJsIBPMOfV8imIo/AaaAKDl+Zs5abps7PJWN0FpbLj6M42raeuV+yHRnxxgJ6hqYG8/MdFVdU5lc38PF10l1vjfUMaixxSUFu47nFUAK3TQ5SuSKoFhSf8b+40rA5OOwcpjujT2FyGRr5DnKSeRR34GvcB63K4edbBWIavLlcCto9fd+3Tm2l2BbpLy1z3B2oARHRtNM4onxXCWdvJaOMY0swYtkv8a/42j5ZjJBxpC0Hwr42DM5wiRPFwee7V/vMOx3YBjHpwgOunI9gqKcu+zJMUnBnqgz8GhvwjEH4agKNeSD5geL6P1kZqkQSWHGXt6wFRmE9+qKUSw8hMmfGA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=shutemov.name smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZV/TlEPUcCZjtQEfzTsrUOXphHuDJRHG0HWd09xWIg=;
 b=psHehe13yoGtPtGL7NQaKYv70nS9eUQ4DhJQwJtjae3tWwaiD3N1SV15+b7Xrg34BglrKyfX0jE63dSpo1EeQedCklHNSI3HiJkqj4eOWKRbVtzWY54uYkMZHUTLccQ0+O++NEXt2d+blRp3HOvAJm0+jJ72F0r2Av1cQ6T00g0=
Received: from AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28)
 by GV1PR08MB8237.eurprd08.prod.outlook.com (2603:10a6:150:5d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Thu, 16 Jul
 2026 12:58:35 +0000
Received: from AMS0EPF0000019D.eurprd05.prod.outlook.com
 (2603:10a6:20b:28d:cafe::90) by AM0PR02CA0161.outlook.office365.com
 (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Thu,
 16 Jul 2026 12:58:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019D.mail.protection.outlook.com (10.167.16.249) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Thu, 16 Jul 2026 12:58:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cELjA9+GME57Gl9pttI1xyArZHB51/denr/a8e5ZIE06lTO5711vgNC5PeRBRxBxB6lH3N1vJzIjNZJLPPiAFgJO1vHBaD23OhN72590WmDTf/VjQ2c7xf/2oM2jhzrv3TpXr0NIsvYKQHraNc4OlvUsAQp/3yBkDN9ZB1NHwkgzq0tCILraROe3407+DlBC1qA84YGd32LNXHAXWIDiRuHaZhXc1WIqyM7+urWW8G2icm10A1WqrawjZrp9sb+pd6zAjbMZhABEgwPi8PQPuOVhh8pMxmdTwT1IU/k7XifPrTcJT2dKs4XRy8cvNS02AIc+kVJVRMshCbixlzbWIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZV/TlEPUcCZjtQEfzTsrUOXphHuDJRHG0HWd09xWIg=;
 b=V4/wm0Pa2Mj9E/bVm+t55KGi3rt93dE8ecOH0TKm47Hod1GoJyECx0lKXDtYDr4eXbckX9XPRR/w5+1WMdYzPdaFQ2qPqDgL6yMxddYBLT8oK4QgculX1Rg1QGUPdxzIeTodXFtxzkHuVkwKnSVHvKDaYLyyveDFppCEHZKne3ivm+8qNGZ73i/G6enj4YsUJKdnhE719K1eqNIMRJv3DRM3Y1zFVdCIBTaXIxcoL1XTqosQIn/Do9i6TruQRYzO5WsfSOQz1d1ZSGkdm5W5bHEUPCEB9pRsltfIrZufMMMEXkQa6nXDk6gQDIUUpi6JubdV0+xXxFjSClSsAmrX6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZV/TlEPUcCZjtQEfzTsrUOXphHuDJRHG0HWd09xWIg=;
 b=psHehe13yoGtPtGL7NQaKYv70nS9eUQ4DhJQwJtjae3tWwaiD3N1SV15+b7Xrg34BglrKyfX0jE63dSpo1EeQedCklHNSI3HiJkqj4eOWKRbVtzWY54uYkMZHUTLccQ0+O++NEXt2d+blRp3HOvAJm0+jJ72F0r2Av1cQ6T00g0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DB4PR08MB8176.eurprd08.prod.outlook.com (2603:10a6:10:380::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Thu, 16 Jul
 2026 12:57:29 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0202.018; Thu, 16 Jul 2026
 12:57:29 +0000
Message-ID: <17fa8583-07c9-4a0d-b428-102bd169ee8f@arm.com>
Date: Thu, 16 Jul 2026 13:57:27 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, peterx@redhat.com, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 david@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 zenghui.yu@linux.dev, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 1/2] fs/proc/task_mmu: fix PAGEMAP_SCAN written state
 for PMD holes
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org
References: <20260715144234.442721-1-kirill@shutemov.name>
 <20260715144234.442721-2-kirill@shutemov.name>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260715144234.442721-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::20) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DB4PR08MB8176:EE_|AMS0EPF0000019D:EE_|GV1PR08MB8237:EE_
X-MS-Office365-Filtering-Correlation-Id: 49bea733-2a66-4a6f-08ff-08dee339f239
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|7416014|18002099003|22082099003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 uT5PBPnP1Pji13SRRMO4aP9kyel87bnxLLXIlhEgb2xgpZZBF5R+DhgRZ00B2ytb4J9b860tDxRjWKL4pFUJnRS+Uqr6FDuNr5AF8qB14UvpSsyM3zHW7ma8Th8J96P7m47pJX295NFTZigVNr7hXrYjImrN/wv5JvUfKTnFhdQIWSPoMU4hO5BSlZwC8vu4OreNRX/lfkHrXV/ZYaT06jWyYw8XGXD2vgmur5u25sOLec16cjLgNyRGha/gd5jl8qr/1c3Onz9kU7DF5dDDTuRO5ZcMANB1J+0Ss0r/ANIQ/0w2U7tvtYICZXQFTt2k3nd7pU1vIqxEa05saqtyQ4HTa7kUqtarcFPpZ7tjWnvJD/zwKgRG8BOpErOMJrZk3cXh9/blFtGLCfmgeFmeKg6aGdMz6x/4BWPBWyoBgHXif5T0H6N2SIu4LghdARjpanvWXWd9y5PLTgbUvpaF8Pa+MPO14XYTd8N0BhX1Gy5y63h3dtrMmhLMcaqjTVZ4Ji3gMn9S7U5ZKMfEhZ35Yeo6RBXRw1X4yn/98c59uhk3rTl8OL7rRKCOWIi9J25VtbK0L1qq7nITNY3fA/moDVuZpbiYeJrgCbehsSN+77E=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(7416014)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Knk9YwCwW8xruUieRHegi2axBAFhSaSkiWjp613zwOhx+aMkw1nYth0cq8Ov02nwQLVlkLDehB2kywulxAa2Ir14n9G+DqmHMkueWrkvMLkuZvwRm60jrmQbGFfWCJ2U/Z36+Jbs2D8Hd6v+9C2s20Thg+lPpCIv3QrWcr3Jz+tpMTcWUh6RvX9g3WnvdL4F4v/FUUuBiuM/h8nMfATJLYjWLDTLITvYTlaOY0x/kneQp73bAQ7XAZR8NAOF9234kiJ/r8VJ+UCmGCctBzkmruYzAmA9wz+JJMkjq1lncSHEvaMkIQUnw8tiJxbQswkwA30MguHn5f3ibM6/fbM2Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8176
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	df632075-ef11-43af-590e-08dee339cac3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|14060799003|35042699022|7416014|1800799024|18002099003|22082099003|4143699003|56012099006|11063799006|10067099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	M59ctEyB9psLEhk5QCq2nX4FoSNQffABx8TGHuMobG+C71b32lkFSY0b/XxBXQ7sVTLPmManjDeGzgZf+T2BBh3FEGJOiECEupJ1lM8pskC0DGL3BbSsWFgP/efG2K0/InnnwCsRJ6VopYeyh8MqbZ96kmVmBuLhygfrncnFS+d4b+RXOD+ueg5hjr6T2UMyZMdJNFzMvyXm3O689fOTicFf+w1+M5QCLTfIsFGVDZ6HFqFv+aS20UGZ/kCdIC9gXH3yrqxKcSDCzYXTFvqlD+3F/9TAxzHtKuv5QwJVXIB9zfSQwI+x5M5PCceF/EuIbbgVWPLrW7zKvPE6sC2tvkCdlgH31eU1Mx+ck7Z16FyXwCv4Ie/ReEpQOGuOejuC7ip+s5ogVFnAbyC3o4/sivI+ZMYVPtu+iKz6+aPYATUdiXa7Ln6LqfRh0TOJQwT64EcGGgqJeGOIo2JsUzYjgCjNrQaDm6FST2gKk1A/lkU9rGGDJB4PZ2rdfBbqphxdIs/oagK/ps5ZjehKvKGWUgXj7MmgLAI9xiXtDSVOfJr2blWxNmM/z5OLew9kn/1EmKKDC9xSS4rTsVoFzBvrjs9YzN+/cNG6TBWnEzTU4GPNA+Xv/cFwfEDZ1nKD4DCyfVnDKb148ESloHM2i2PGsA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(14060799003)(35042699022)(7416014)(1800799024)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(10067099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bJtlGd/KqpzMlCP3bc0I1I4gKLas+iJjLdLFzzTHBj0XN0eDFXUau00W8vBitU+VoPeYhiKMJXuufSMdyTm6WUL/dzX5OywF3VbVEW88a3x2X/FIF8XuvpPgMNtGSfH3GO56R0mG1I1nE5an7o2QI4Fe+htEEn8YTfV0UMdsZdqJ3Zzc+3iXs4ESI1rb/uurydWY/kSvkrFgM8A/yoMgX9Kbak+BnkujUlScgpE+fuR0s++e0rXth5DBUYxOPF8FUJB4Z2OWezTUZxjYqHUU17vG7eFpu02YgHHV5bYAtMYBFuNQAUIuqqUuME1xbCZBhAI/+uuepJ/Eu5rGJg1YZCOksTCx5WHXIXqqwHUQOyxJjfRxWpTeZAP0c3GA55iMLWSlJFDx+fXxm/1+Rj1piCmvC2Rd6SBiHxLRCe8e98XhH0AuZHeIdyh0CKoleWVU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 12:58:34.8648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49bea733-2a66-4a6f-08ff-08dee339f239
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8237
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9194D140008
X-Stat-Signature: dg89ks6j1yic4iqpix8otssa5dxhyym5
X-HE-Tag: 1784206723-265025
X-HE-Meta: U2FsdGVkX19e7vqPAq72QYkV/ish7ZjjLVvuLp7IRT1IQn3JCDJQtDyuOaqrnId1wjc+PRWkuUyXmV2B1DRUgnSRADdAdoQlCSUpLhmVMUBunhiboG3RqDYjbiIITUIi3Y2Ynsnjf3DjtoqWwNwk98kAUby6xQaZnDhSJtrz8WWonc8KMy0a2hxthXTZy2BGfIHYt/KDBfri2Jr9UMe0I9uyto/ASdel3SXSFzhJFXsAGi5SeXwAS42IGOK8ENGxgWQfaLiGTCWrSeWzm8XjK74lmBe+0FRCPbmiZaqzzvNlBs7bvPps7HmGVlStffNaNy+nusDYR+EXHWCQwaLAskgRzwuks7pAiECt9M9foS9vIfrkGnEDEiDG6I7f6wyHYKj8dhhAPlrrrW4CVlJaZG6YNV9E+cCaDpqxN4Cuv9ytg+0n8G0FAJJ/BoDlZwNCGbWH/NB0pgSqK5GHpF+vKgsupp0qBNd8SzZLonQ5uf2lEXkzvsIWECVYhwSge8OZyZfWZ0TdsrJbuiZVeGwDrmy9JbzOQmEX/pdlZSXh9mGJ6eXBGmtGl3XvxdpDirhjoPNPpGbUL1DU6DI5r/4iq0geoTo+qA/x/dSOM68pCNN3Em8+T5WpAyIm049h/rJIIcrDpXu8+cmySM7C3rtsvTlqPBkLbTm3SRZ9cz0/FSCtb/vpx02NABf8Pn6NsKGDxVwbl8yd2RPhqx+PrAQ9eMJeuQ0U6pymguV6/Tet+SpgjcT9upV+BruxF1gELsQkLl62sG0JWzzXMUSHhZvXnUquYxG8ZNecVBUqLYI0KVf7jQW30kenhh//kRlOJuRm6DsUE2gly8XKNtz6jiOnM4CFwaQURd+Qai/ehmwo6rBN3cMLgpzw868dxdAWFDFfCWIt5+p5AcradZpJD2wnjPYQpNC9O7FqVuvberF3ZVQ6q5Ht3zZ7ZNR4CMdeph4rNgZtWIm1uJfnjjhQRk/
 Ty83XY4T
 oSepfBWZGb2IMQr35fvr27JcEoNTSMPhF3PGGgcm+gHvZ40uaLCbBGVYSAFmBTZoInc/yEtsT5AKyluBdqgtHPK8n7x48C28cwIVvoCvtn+hIifVppCxCVPaweqV1ASyiGbg+x/X3e8uPD78T2ye2Ok048YDcS+0DTl5CIUma0RKr74cyiyxMeXSBIiaaAb2XS0GG9LoqIytkfDXuesvpclGchxYLqx0ApujLgOoTWWBuOajVlY8sAA5mtZPxuJPVknijYdY3Z6zuic+bepZ9JjTvg2YhnRECWV38wpdKIhIm9YDetycmXtoL/n5ZfblXMvJBfqy0Q+RBc2HT084cs0n5irtVbsJJyFJxop+sKYWBtuWUmWjl5RgnN/1u9q9Obj79cZZmhKtzwHGiGZqLNkeaMANMWlN3iTDu3QXAy5thMb/5MKNDkJdQBn9DOhqaC7Ni2Fx8+eP25UtAJ8EJ5a5jZ/rF/UeVsB4y2GAFepSkoR8boPnjKwHAt2r12rmCdC0HLs9VoTfne9c8YquJFceNAFebmD6dit1J8ekKuZKZOCJx4BV6Ik9xUl/sOJkoGoi/nxT4CfK/8CO5FoTGXqi7rfkQpku4MK7XFhr98t+eaLCRjLrhySJRz9hxthZJYyqYBTlEoT5J1erl6sDY1vfOwovfr+LKWBMIzzQr33UW2BRw8V2uI/XpAHCD/7c7MRMHwjxZRaVgct1ENLrGYJxHeHto030F7oSD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/07/2026 3:42 pm, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written, but
> a range with no page table at all -- a PMD hole -- is skipped:
> pagemap_scan_pte_hole() tests p->cur_vma_category, which never carries
> PAGE_IS_WRITTEN, so the hole is neither reported nor (under
> PM_SCAN_WP_MATCHING) armed.
> 
> In a uffd-wp VMA, WP_UNPOPULATED installs uffd-wp markers when protecting
> a range, allocating page tables as needed, so an unpopulated slot is
> treated as written -- see the pte_none() handling in
> pagemap_page_category(). A missing marker therefore means the range was
> zapped, e.g. via MADV_DONTNEED. This applies to anon and shmem VMAs.
> 
> An anonymous THP is write-protected in place as a huge PMD, so a
> full-PMD MADV_DONTNEED clears it to pmd_none -- a hole with no page table
> -- and pagemap_scan_pte_hole() misses it. For a MAP_PRIVATE|MAP_ANON
> mapping MADV_DONTNEED has fill-with-zeros semantics, so a write-tracking
> checkpoint/migration tool (e.g. CRIU) treats the range as unchanged and
> keeps its previous contents; after restore or live migration the process
> reads stale data instead of zeroes -- data corruption.
> 
> Report a hole in a non-hugetlb uffd-wp VMA as written, matching the
> pte_none handling in pagemap_page_category(); the existing
> PM_SCAN_WP_MATCHING path then arms it via uffd_wp_range().
> 
> hugetlb is excluded: pagemap_hugetlb_category() reports an empty hugetlb
> entry (huge_pte_none) as not-written, unlike pagemap_page_category(),
> which reports pte_none as written. pagemap_scan_pte_hole() fires for a
> hugetlb slot only when it has no page table; keeping that not-written
> matches how an allocated-but-empty hugetlb entry reads, so the hole and
> the empty-entry cases agree within the VMA.
> 
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name
> Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
> Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-fable-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>


