Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41EFECDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1E36B013D; Thu, 25 Jun 2026 08:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378C26B013E; Thu, 25 Jun 2026 08:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268306B013F; Thu, 25 Jun 2026 08:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E93C86B013D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:16:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A71F1205ED
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:16:24 +0000 (UTC)
X-FDA: 84918332688.16.D734C1A
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011030.outbound.protection.outlook.com [40.107.130.30])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6791A1A0008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:16:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=e7Z5CI0t;
	dkim=pass header.d=arm.com header.s=selector1 header.b=e7Z5CI0t;
	spf=pass (imf19.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.30 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782389780;
	b=xWT+Z59cdxYOo/Bc28/8EjJIHiJk2pEZ/1/g9Xwnsr86U79X6pMvj3kRpdphAQf3BHPTg5
	ngkCCGPHZtaJrJc41J5AqL18j3wM6ORyAY0DtVwX/xI0ID2doA1dWjLElYUKkNf43uMegK
	3DWdsj98B1tt+i5gE5zP8BKfBmrc2+I=
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782389780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uW0iVIe0mq7zs43GkCPKcKkFs3okkJkXLFk+uvFMSMo=;
	b=2z5BbBBe53apGKbZdzgEuj0Irer+EqHdtU+k71tbZCnasB4Un/BDWCxhxcUbvjU1ckyBSY
	wrhD2rYVkxbgOgIT+FAalMgvuUdxN4Va+A3szsLz5c0e9ETG/L+4eJhPGVamIKd4LB91Y4
	wRSVVcG5p1nZTlqufcX+pA2CBtJV8kY=
ARC-Authentication-Results: i=3;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=e7Z5CI0t;
	dkim=pass header.d=arm.com header.s=selector1 header.b=e7Z5CI0t;
	spf=pass (imf19.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.30 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cpSXXimLVs0ljW5FsWZZkIbdTjAPTMfEAYptEcYLTkirMiLkU1Bv2h/k+qs5oS2n3cDQQ0f+wBecVI+FEVWI7iNZZSj5gxZA6AdixioylPzoelAviyDdkZQP8OFhElvHRhCZbtOah7TTpqakuhjMmUHg4l0C4PqJ270TYBtFajjnYJKGBMbSy3eF0+BzAWwZKqcNarIUvlsdVBtggm8R2qCrFrdDs/m9pGKZTXCqxaKdMWJ9GiSb+6IBaFonFbjaQIOHk4PnZqxVWT3WePUrPPp/hcy1RLB9ddOOnFjJyA4OYaHAOG7Hr9e5c5Q8PtFBVqj3QY28I4Q7uKL1l/jAcw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uW0iVIe0mq7zs43GkCPKcKkFs3okkJkXLFk+uvFMSMo=;
 b=Bp1h5WzmFVGQ3GI4YPDaYTdnlaNmW7FZWzLTQCHCEyMqxKLscieLOThw6xhGj6hGFTUYAEz9TSM45LF5ZgqiEKJMwSketzymXJNZ5qyc19SNVTsKu1hs0vbssONM9NX7KlQ8yPCdj+/yO/pw0n2DA/RSK7VZcvv2PXsYbTF0+d0+X4xm7d/AujfnSyFGLbKbhb4M35cphim5blF/1LUeAc4kZn/iDhuMCL651aYq58w0npw9Ya+2+SJGWAiXMIcNAWIm90kRZjpJmnjUMsiysGh7S+sJfoD2i3mQFRrUBQSsmtRfRyJ+tKktIBo4B2EJc6rvSlQoriO+/WBuc1LtqQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=suse.de smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uW0iVIe0mq7zs43GkCPKcKkFs3okkJkXLFk+uvFMSMo=;
 b=e7Z5CI0tDo7Ne2DMEfMxTsUkcFfZpaRo9DZbfdVy29wWxF953amH4kr4GToTs+X+VlkwWHFvQ+zEkAKP6z4qJtEA4mRMvQ3unvr8qNDOLZwPr1JjzBL2DAtmOU3VtMFCMtL2iP2RxYcB9ft6AHgx7mWi3pRqaM8APOUS3B4U7dU=
Received: from DUZP191CA0010.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f9::27)
 by DB5PR08MB10021.eurprd08.prod.outlook.com (2603:10a6:10:48e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Thu, 25 Jun
 2026 12:16:16 +0000
Received: from DU6PEPF0000B61B.eurprd02.prod.outlook.com (2603:10a6:10:4f9::4)
 by DUZP191CA0010.outlook.office365.com (2603:10a6:10:4f9::27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.16
 via Frontend Transport; Thu, 25 Jun 2026 12:16:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61B.mail.protection.outlook.com (10.167.8.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Thu, 25 Jun 2026 12:16:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RajkZNZvhIVWwoNESDFzu2zbPF/Td86wfcol1sd6vrZ+HHFFA2O+3gHP4/RiPrkyxn06mIcyyAC3aDyHFhWS/+uUDdAGxCT3x5pL6pw2WcU7Ztv25JpNGt7iCvHtekjK/BS7jGLNrNqnDlHMUZBSlDoIR54x5FyiYWtEtqOkS10pzv8Pvuly+ze1q7zvFKBaHyKexGW0//JlZLPZd5mX0LvMdf7PS6XL0XqFLcM2Z8bdIXeBAFgveVQ9xDh3cJF5rno4rrvqBDbI8+6u44kF0Oh9eYZXjad2COqFtqmD3PFl+SFST9bRzOq5mvE51XIcqpc0UTWsv2nWRFSNaLaetg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uW0iVIe0mq7zs43GkCPKcKkFs3okkJkXLFk+uvFMSMo=;
 b=ruSpblZEL4RhqqtbDISMTQ5xqTvZnj5mW4QMFFLRuRpEk5B6v56A8X2XcIMLIdPK9w5h7VI3x/2S0iCx6pZ8yf03ikTzRru0o6E411CjtxeO92YLIzkkwMS1R9Z7i84MMqESOe4Js+UdMAgQvA5Z+qdbFrk66XwI1gcsgeSnOZ0VB5bV172D7o8t3x2w0pJhA/7+RVf/MyXebW6ZQKtjEiabeMlMqFwJZ6R73kR4e6o7l4r6f7m7ZlZZJ4rKhoQkKE91LNRnBJYiUOvCX0DpQFlZm8VyilLDjjg0XA3XArcKW9iow5vnjK7aThYCg9fa710GDUxoZVdC2tDkSmLhYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uW0iVIe0mq7zs43GkCPKcKkFs3okkJkXLFk+uvFMSMo=;
 b=e7Z5CI0tDo7Ne2DMEfMxTsUkcFfZpaRo9DZbfdVy29wWxF953amH4kr4GToTs+X+VlkwWHFvQ+zEkAKP6z4qJtEA4mRMvQ3unvr8qNDOLZwPr1JjzBL2DAtmOU3VtMFCMtL2iP2RxYcB9ft6AHgx7mWi3pRqaM8APOUS3B4U7dU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS8PR08MB6133.eurprd08.prod.outlook.com (2603:10a6:20b:298::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.19; Thu, 25 Jun
 2026 12:15:11 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0159.015; Thu, 25 Jun 2026
 12:15:10 +0000
Message-ID: <0cad550e-e478-41bf-8e9d-2165e547e453@arm.com>
Date: Thu, 25 Jun 2026 13:15:09 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mm: opaque hardware page-table entry handles
To: Pedro Falcato <pfalcato@suse.de>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <ajwuKpSnElvwIyhC@pedro-suse> <66310292-f618-4497-bcaa-2a4b1240566c@arm.com>
 <aj0JU-AzsEQBOiQ1@pedro-suse>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <aj0JU-AzsEQBOiQ1@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::13) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS8PR08MB6133:EE_|DU6PEPF0000B61B:EE_|DB5PR08MB10021:EE_
X-MS-Office365-Filtering-Correlation-Id: 075693cc-c9b6-426d-3d09-08ded2b38e14
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|56012099006|4143699003|5023799004|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 9scLJ6TUwttDFC6IJQwlGzLiXoS07y1Vz1KkRyL3RhX9QW01TEj07n4pjyT0KbyQCfDzORElzpoCz4qqYeifUOpD9GSyElxllPaMJuVMSwzg/BhTKK9TgwtMzyexFiKVIxTyCBKsoIsmqGvddvXFUcvYA7WOIc4IeYKVLD6LWHPULSBNP/DpR4Zh0UhSrGVejEP22alV41v6XIr25+mTjOJDf0et7qHDIBFEpyoT8Mw6Aq3OojzmjgnLw5O/wOFDnQZeq41cCuSXcFxDgN7bBKV0684dNx8nStrJ7GLLvbfY4wzNN1TzLgROeGMizaPfLOntwR+U7cXaeI39MibiinsHOEgipYorqUjhPz2oG1p6F9Zq8nc92kyhVDRt+bkzHwgpt+Ulv43DQsYuer5MuFetT7V98s70aXSMmESjp9MztbJ6Wzq3uce015hSo/tEcmJcR/zcVPiWfST/7x0j6Zc1c3bdpW/7qF8MkD3NyLU+IGtfvyH3V7AK9o2k270PHTXbkUW5x+H2Yi9EUz3aqKybrf68jV/ymak7UcXpI/NOwjTkHPS+S3YoHydU+mc7dCMXg5ZQTSMmASLyUcv2VD1Wx5B0wqx4TC4P3jjZIgqUZzmcIHuAch6Pn+XvZsZ+MgqUUaktEETSVZUr9BzwDMXLksxgx6E62fNOub38m5c=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(56012099006)(4143699003)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 gUQM6wBVZ3C8ADmCNktbTmiH1UcM89Ielj+eWDAvygDy5DiOKm2bi2IFMuvG17vIVp/WydlOJZQRYXeKWVnFqF/r1wowSexsrWUFQBmu1o21ASpsegMK9ytWWuYRo3G7MUlPepT1wGemXxVq9XMQabj4LN0ATdTFMqwig17NUff709+4eM4LSVvg0Mez3oW7wx8J5CmD1oI61T342ZmV6VieVOKNH08BPGQ50qqzXysnbpujeUCshWpHZejwsLihfN8sS1A3v1IlywHWquEx8YKL9qzCmp39JKx9POAGeIr6/6FF/KBM4pW1o6ZE2rtj7UeNTozZJTWcL4oBZPE84A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6133
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4b186f4c-861e-43ce-559d-08ded2b36731
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|35042699022|1800799024|23010399003|14060799003|22082099003|18002099003|5023799004|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	p0whFwYQAuvRCTEnxnZK2F2SFw8EohYsNnB/bO9SIRUK1vBAL3G6qH9puuadq2OF2e8/k/YUrALdmmt2M+K+bmQ2j+0V4D7wWGPYgrRmOeW8BIPo/cn7vjYihnTdUfTKvL0dwY57y95XO+vWSFUGq/Me2cEBtaSWxw0P2xRcWC4WDcHYRvTUgCVXQKarH+FUpv0NZVAObhVkGyDLz34QJA66rnAbWByOjFtVcbctnLizcnZgWSSMO0xCSgO1FQIClb7JZ8cVTqETUKst2bMJosi6x3rwIOH71AFF1jrQdDt8MOQLqqTk1OEBv2ijsHxGOzFlzCNoH1mPI9uILrsANber9h+CWSEppxa19rKMmryD50Fut2vmUhSOLEJrri1IOkoChU2WX68F2zbBEojUYmHBfv/mhBIhtnK+E+7zfQsfkuq30alGtR/vw/HrNmc+NrENpTp8RQdb6P+YqpBLuMWoA3KqEpIqBoT7T3ytSpLH2h/rsCY6V6PlKljeF6btnXsYc8s+OIj8yF1BBn9sVxOYWe0pytfvahmbbfsaw2nVDBLcY1fZjl7neBk5hWxFUW0+aOEfUozXcGgImT/FJ3LIu5Q1OcV699SrOwZSicNN7mQ8X3GOl/b4kujuDfJB31rfz+oESitSfg6b9UHh2uiiNIOYI+krTpHy3I1psZTpEriWsS1snWVmDtP9lyMSjM2ipu4VTdMmTlYFqzyaBw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(35042699022)(1800799024)(23010399003)(14060799003)(22082099003)(18002099003)(5023799004)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XIJkCdMyc7oX91O+uRmxhBBPTsMGQnFQaXTpXiLDB/nolUrNXnoPWcpdWeNBq7uqqI1GtI4da303L0OdrRK7dlkp/muLE2P0Va/n6P1C8pUZNQes8wfOll9ElJpxFI0HLgJzjCMiI5ks2kawTvf7HYErdQ4vIg5garGka2TYvXU41HYl6/Xk8A3clDxXdL/6bG0MYsbwUttGHN16ERBoqKVThybmny+q8EvPxj9cly9ZUL++7fynynWiM2GqBiBO0fgRJsRMJQr7Zripf2hwRCfh4MbQahQkPnMAN+Xh1zWtLI/HAu0zqQrG1s1jTEpnGSChQJfzQvWq8mR6/DRhGJAyz53pzGCi7w8ut1tTnL3RtZLI44oLyTD+eydWQO04Jnt/hit5KA9lUrfAEeumxBf9vYEh+YmRttXNhqAgEl/vJMGPPClFFfsvDzhJvFxB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 12:16:15.6779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 075693cc-c9b6-426d-3d09-08ded2b38e14
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10021
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6791A1A0008
X-Stat-Signature: trmske31ddyiu3h6orgw8cnzxxr4g4cy
X-HE-Tag: 1782389780-989284
X-HE-Meta: U2FsdGVkX19a7G0Qz9UKop/MKfLgDQh1/W2CONH8TijfJY7EW3ahI5I774BhJGAvNif7y+YA3AbY61wFFeqd2Uv0+GMEF8dYrqmZP6BNm9tAGjYx6ARhww/GL0FbLtoLH5Bo2Lgn01WiUfR0kLYQSycPQmlrlypHr1xInvepzPEba0HCbscg793Gx/DyIxti13DaqFWX6sEoOMiW6IkqiSAWtmgXUcyakRnn5dhD6g5m+eeuvbNV3Rn3KH5KglXBjeT0rXGGaP/OL3mT5KaRwrw5Hc6f9zCFjRnIZSv9JnxXkWhtwaOAdQUfbwwL1cn+sR/vsBsunEa13gXV/V/6X9Bz7wsqgE4sNCwbU4gwUIoFXhJY+VkwO7XjVhM82OTkgG9pKFkoWMNc33RIzqWkadouW4stl6FJ2b4hBAGB6l7xW6Kl0MEKCFTJ0dBHJmf7sXADMgaM/hqkfTWT6PuOdLOcEyqJfxL2MFRTqvWFcuUBId0VxmZAbpK0JthUCIY0fOV5oGaCXAn/DUz11PvtfjPBYCEn0HjZHoDgZmbTTVgVJDwy2TmgOWx7Lu4hTdQRw1twVWITfrWmq5qzDuh6wsMuBd60HYQLnAPbP9BU2iHEpoTE4K+XdnbrqfwXJR0vndVAdLP7+ff7DvqHqdtdBZT9e8LN+tIiSrUWN9rSLYQ4nJRskL5jwHaJDkQqaRciHnhq6gHg3sa5NECa9qTBgnM5YQ7Zj8dqBtpqxSJE8PcxFfwlLApfcFCQlfFOkPCALDoI33fwikuhutZsj5bb9zpSDT6I3v7tNykYhb4ehkV+mJt77gzdwyIwIl2yCFl6qPCGZLxfRjRtTpgjCJlpUYLs+8IV/RKTfFJPH5cqJCPOJNIUNGDXojiug91cyczZ08O18AoVhlLoQ0wS5Kp3ZfbjNdw5VS5QN7bK/lI9UrrmuCrg+mmpi1t5mIajpQ7Et183CvlJ9kFIflGI7VH
 t3R1gCON
 +LqPuI97XmHzaUiv3bj0DvjGVWXObicGA/Wn5cg92tGl5cs81nNQXQ0RO8jKKKevRRLKnuNM7Sow+CXbNwWW//leWf9oWO/m/qZvnnQ9H5aK2NceHlXDtKND7LLZNI6+rxVsEHTVMY9AfMz/PicaEQBu3etlts2hPwoMmhqPFj8NOCocJjL74VunhXcpBwYljQ8gOBXkEgHmNKrxSLpDMvUkIjzCeI5PPmC6gyK1Rg/dNR81dMtUuFwqGXbLQMn+pKqt0Cg10jwXDmvAJ0VCyZTY8twZ8o5rMJ3QKITpeavXBQ5b/n/Yvymf5omXtygmm+22Jfw2cK8cbBXTIFoor5foNmkyjWrcQk6TtUgZAFwepD5UQ5yaXMDILWwxilhzgnl82EyjEm9HiV2Q5Y8Pcg0Ucb57uZUCBfEeAmCdtjWQs1Z/UG2sarpy/htA9GfqDJ2ePh+baqHbQjG2uMoGqsB3sPgsqCgxtJ2Yk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/06/2026 12:08 pm, Pedro Falcato wrote:
> On Thu, Jun 25, 2026 at 11:50:28AM +0100, Muhammad Usama Anjum wrote:
>> On 24/06/2026 8:25 pm, Pedro Falcato wrote:
>>> On Wed, Jun 24, 2026 at 03:09:08PM +0100, Usama Anjum wrote:
>>>> Hi all,
>>>>
>>>> This is a direction-check with the wider community before spending time on the
>>>> development. This picks up the idea that was raised and broadly agreed in the
>>>> earlier thread (Ryan Roberts, Lorenzo Stoakes, David Hildenbrand) [1].
>>>>
>>>> The problem
>>>> -----------
>>>> Core MM code reaches page-table entries by raw pointer dereference (pte_t *,
>>>> pmd_t *, *pud, ...) in places, implicitly assuming a single, uniform
>>>> representation. Sprinkling getters wouldn't solve the problem entirely. The
>>>> problem is one level up: the *pointer type* itself is overloaded. At each level
>>>> there are really three distinct things:
>>>>
>>>>   1. a page-table entry value (pte_t, pmd_t, ...)
>>>>   2. a pointer to an entry value, e.g. a pXX_t on the stack
>>>>   3. a pointer to a live entry in the hardware page table
>>>>
>>>> Today (2) and (3) share the same type - pte_t *, pmd_t *, and so on. Nothing
>>>> distinguishes a pointer into a live table from a pointer to a stack copy.
>>>>
>>>> A pointer to an on-stack entry value and a pointer to a live hardware entry have
>>>> the same type, so the compiler cannot distinguish them. Passing the stack
>>>> pointer to an arch helper that expects a hardware-entry pointer compiles fine,
>>>> but is wrong - a bug class the type system makes invisible. It also blocks
>>>> evolution: an arch helper may need to read beyond the addressed entry (e.g.
>>>> adjacent or contiguous entries), which only makes sense for a real page-table
>>>> pointer, not a stack copy.
>>>>
>>>> The idea
>>>> --------
>>>> Give (3) its own opaque type that cannot be dereferenced:
>>>>
>>>>     /* opaque handle to a HW page-table entry; not dereferenceable */
>>>>     typedef struct {
>>>> 	pte_t *ptr;
>>>>     } hw_ptep;
>>>
>>> I don't love typedefs that hide pointers.
>> Nobody likes them. This is the only way so that by mistake stack pointers
>> don't get reintroduced. Its also hard to catch such cases during review.
> 
> That's not true, you could have:
> 
> typedef struct { pteval_t pte; } sw_pte_t;
> 
> and
> 
> /* only usable by arch code and whoever wants to interpret these
>  * types */
> static inline sw_to_ptep(sw_pte_t *swptep)
> {
> 	return (pte_t *) swptep;
> }
> 
> and so on... Also, see Documentation/process/coding-style.rst 5) typedefs, it
> explicitly warns against pointer typedefs.
I hear your concern, but I think the sw_pte_t inversion solves the small problem
and gives up the big one. Let me make the case for keeping the opaque hardware type.

The narrow goal is "no stack pointer reaches a table-writing API". Both schemes catch
that. But the actual reasons for this idea is broader one:
* making core independent of how a real page table entry is represented and accessed.
  It only works if hardware type is the abstract one.
* As you may have noted with pmdp_get(): on some arches the read is not a pure load
  (folding, lockless ordering, kmap of a highmem table page). pte_t * lets callers
  bypass all of that with *ptep. The handle makes the accessor the only door, so the
  barriers/folds can't be skipped by accident.
 
>>
>>>
>>>>
>>>> With this:
>>>>
>>>>   - a stack value can no longer masquerade as a hardware table entry,
>>>>   - a hardware handle can no longer be raw-dereferenced,
>>>>   - cases that genuinely operate on a value can be refactored to pass the value
>>>>     and let the caller, which knows whether it holds a handle or a stack copy,
>>>>     read it once.
>>>
>>> Just a small passing comment: how about doing it differently? like
>>>
>>> typedef struct {
>>> 	pte_t *ptep;
>>> } sw_ptep_t;
>>>
>>> or something like that. Were I to guess, referring to a pte_t on the stack
>>> is much rarer than all the pte_t references to actual page tables. But maybe
>>> reality doesn't match up with my guess :)
>> We want to fix the current usages and future usages as well. sw_ptep_t can work
>> for current usages, but it'll not force the new code to be written using correct
>> notations.
> 
> I don't understand what you mean. pte_t is a perfectly correct notation,
> it's just currently maybe too ambiguously overloaded.
Yes, this overload is what need fixing.

> 
>> Apart from different types, another benefit of hw_pXXp would be that
>> it'll become an opaque object which only architecture can manipulate. Hence
>> architecture can decide howeverever it wants to manage them in certain cases.
> 
> That's already the case. pte_t is fully opaque apart from the little fact
> that you can declare one on your stack. Introducing a different sw_pte_t
> would further reinforce that. And if you want ways to find raw derefs on
> pointers, we can simply slap on __attribute__((noderef)) (available in
> sparse and clang) on those types after sw_pte_t is introduced and pte_t
> is unambiguously a "hardware" PTE.
The pte_t iterator loops in core code prove that it isn't opaque enough.
The pointer arithmetic (ptep++) is done at several places in the core.

The sw_pte_t + deref protection only catches misues under sparse. While the
hw_ptep type is enforced by every compiler for every build. 

> 
> I dunno, I'm not convinced that changing around ~450 files is worth it, and
> _if_ we want to do something like this I would strongly prefer the way that
> is less churny.
Probably you grepped these types to come up with 450 files? But we aren't going
to update all files. Only the generic code would be converted with one or two
architectures. Its architecture opt-in. It'll be transparent to non-converted
architectures. So if arch/ is excluded, the number of files would become a
quarter?

This type change is going to localize the future churn. It is one time cost;
after that, every future representation change lives behind the accessors. 
If pte_t * stays the live type, each such change is another N files audit.
The struct buys us one choke point to evolve.

-- 
Thanks,
Usama


