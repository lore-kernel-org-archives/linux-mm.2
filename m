Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E81ECCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 12:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4948E0003; Sun,  2 Nov 2025 07:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D2C8E0002; Sun,  2 Nov 2025 07:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D7B8E0003; Sun,  2 Nov 2025 07:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC828E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 07:11:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC1A91608AC
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 12:11:57 +0000 (UTC)
X-FDA: 84065553474.14.4259D1E
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012001.outbound.protection.outlook.com [52.101.66.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1789F1C0007
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 12:11:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=n3vM8PAM;
	dkim=pass header.d=arm.com header.s=selector1 header.b=n3vM8PAM;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf20.hostedemail.com: domain of Ryan.Roberts@arm.com designates 52.101.66.1 as permitted sender) smtp.mailfrom=Ryan.Roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1762085514; a=rsa-sha256;
	cv=pass;
	b=Liv7ZaJFfhei7VecTmEGUUbKSQZd0MQC+DDDTDvsKtsart42oP+bnmKL9bvyDbtVGF5LOl
	I59LuOqyxej4wGXEhBlF2+4WWSYqJrOuzObKuO0640tj88I287UFFVEozhmYLDgX+ss9S/
	Z9u2UhLrHioQkT/kRFhuDxaPrI9teXY=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=n3vM8PAM;
	dkim=pass header.d=arm.com header.s=selector1 header.b=n3vM8PAM;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf20.hostedemail.com: domain of Ryan.Roberts@arm.com designates 52.101.66.1 as permitted sender) smtp.mailfrom=Ryan.Roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762085514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0XGy4UunTB49ktvH7fhVGzHM303nRWhtDmxXdrYNcY=;
	b=AHWBGvPjqDYcYlpLLSdolr/2r4Z0iEugbaws+DFjuiJzso77CJOV/f8TLpVF+l3VdyWCza
	pzDMQfCDEvTRXn7kIPAzeJ/cIQ4Sq3iicCt2U2UlmT9vfpOSZn7UeVTygfmp68QHVfWqRb
	sZA3PBChD7T9ER1//zA6AHioXGmeJsM=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dlhfPtPEteaxuGUK0A9dIqJmteTKYrxsf0sLclUBUi+tEOuNmnxdW83CVKtVfzymGJH+BtlT9Ws5xarGcCqo7Pstj1WnjwEro16/AqrK49zhU6/i/wAaE5vSUrY7I7/P4Pk9GZgy0MI4xNHy4QsTv6xsBC0iiy8WHqA2d1xYfczNJGTtGssSp5VnlXgnGyeDmjatdE94pEQRWgtcAMxP+bxhtdHTKt8k1FK72fE6iNi6/i8W2TPeU3a0be/EgoJN6kTvCkKpzb3M1/i3lxRbcFgy3GhiYPd4E/u/05zA6iPETAiCmRdiIA30VsYaJDfzyJxs0uUw14tPMKSrcRwcRw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0XGy4UunTB49ktvH7fhVGzHM303nRWhtDmxXdrYNcY=;
 b=jPj5S/x87ceXQ1abNpVOX5ChoonEz7YzDFVDhpbF/teep5wcr76rkxkuvJspeugjpEnRA7I/dp6OJUmbPo0l8R1zR25Z7Wa83luuGj+gGGUvsanbDL3AHUw7hfqw68SOmHgwl4Q310MDSHQTzfjvRHBqVihflSfF2+xPcDcCbFeqiGS7PKNKTGxri/tKPRTzGWS92Di0BU/ESBBuc1dVtSAfqXmmqxgGnAc21mnJv4jSKqoH/yPlQwAJ8dDTBaBVJdhMBfi4/AWGkBq4jx3Eo04CqqsI7wXx2R8+U3RpBNngEjGu66tZBibvkdg4PHVXeEAggM+X435cLbzAM7rfkg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=roeck-us.net smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0XGy4UunTB49ktvH7fhVGzHM303nRWhtDmxXdrYNcY=;
 b=n3vM8PAMT0ITmfT+m8RybD+BG+3rtwH4pniXvp0VENT+PEfErHlacUSR5aCuHo2FVWAxsjFQ9HzcBUBqaGH7cyaEadB0xHS6eSx+LUq509Ie+bCMyit2T8gw7XhHgjXuFHnwbgWEbFUtnEU+5tIlOidkWwpuk74pIn9qRZiXL2I=
Received: from PR1P264CA0118.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:2cd::7)
 by AS8PR08MB9316.eurprd08.prod.outlook.com (2603:10a6:20b:5a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sun, 2 Nov
 2025 12:11:47 +0000
Received: from AM4PEPF00025F95.EURPRD83.prod.outlook.com
 (2603:10a6:102:2cd:cafe::81) by PR1P264CA0118.outlook.office365.com
 (2603:10a6:102:2cd::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Sun,
 2 Nov 2025 12:11:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F95.mail.protection.outlook.com (10.167.16.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.0 via
 Frontend Transport; Sun, 2 Nov 2025 12:11:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GG8fl/othOZWZhRN0OsijpwSebviw5iOLFS5qXlQ9G2ueGR8MebakApKxTNT4S3FlxdiQwCvEkTosOdoNQ07RCyU/xeBfiF4f3NBZ2bOVlrEqO3iVyHF2LDgOwnskNwG4xdDc4birLeClBrOemCiMH78GfjsKJQs0IaYCDb7AM/Pmbrpq20tRFX6gXWH3Un5/1GwUf6z5iBVCQn2Bb1PjtZE4MbJ0DJr1SJuvcKm5Bb1xl3xnlSRz11CwlSkSd0ybLDespAMpf5xHRh5iuZVF1LA+VW08c9+qd/ziKSsCRWFEbc7jQb14tmI4GDMO3T5ejqLaDS7nFahdZEicWzQZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0XGy4UunTB49ktvH7fhVGzHM303nRWhtDmxXdrYNcY=;
 b=HnL/PmXU85IfHQjMBL+15FH0yRfeC1eV6Lndi/DhebnISfvHpbllviIqRde5CYhZBkHbtFRnwkq00ohtt4B7jA+1CeNC57FPOe9C3+ogOFxnTxbjbxTgkrrZw5E8pC0QkC3+uyKEAEy7sZUSe3qrc/WEkpUulmjkE9nM+beND01HGTZElI2/lNn+xM0EO3qsPskUu59BO0Y6VjBPtsFKjLNPnabQJkqnLNe0oYG09AQ/0IopDa2SGJjdVKLybP8jL/bgd7WNo29uKZatTFQcPua+XL92Co6SJkU40K2Ebntu9SpBeq/2mNIDA0E1DexuplmH8bkwU3jPP+AkPvitTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0XGy4UunTB49ktvH7fhVGzHM303nRWhtDmxXdrYNcY=;
 b=n3vM8PAMT0ITmfT+m8RybD+BG+3rtwH4pniXvp0VENT+PEfErHlacUSR5aCuHo2FVWAxsjFQ9HzcBUBqaGH7cyaEadB0xHS6eSx+LUq509Ie+bCMyit2T8gw7XhHgjXuFHnwbgWEbFUtnEU+5tIlOidkWwpuk74pIn9qRZiXL2I=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB11445.eurprd08.prod.outlook.com
 (2603:10a6:150:2c0::19) by PAVPR08MB9330.eurprd08.prod.outlook.com
 (2603:10a6:102:304::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sun, 2 Nov
 2025 12:11:13 +0000
Received: from GVXPR08MB11445.eurprd08.prod.outlook.com
 ([fe80::fa0f:733c:3b98:b13b]) by GVXPR08MB11445.eurprd08.prod.outlook.com
 ([fe80::fa0f:733c:3b98:b13b%7]) with mapi id 15.20.9275.013; Sun, 2 Nov 2025
 12:11:12 +0000
Message-ID: <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
Date: Sun, 2 Nov 2025 12:11:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
To: Guenter Roeck <linux@roeck-us.net>, Yang Shi <yang@os.amperecomputing.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nd@arm.com
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
 <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
 <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
In-Reply-To: <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0065.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::29) To GVXPR08MB11445.eurprd08.prod.outlook.com
 (2603:10a6:150:2c0::19)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB11445:EE_|PAVPR08MB9330:EE_|AM4PEPF00025F95:EE_|AS8PR08MB9316:EE_
X-MS-Office365-Filtering-Correlation-Id: 013eeff3-e7be-4f45-99fa-08de1a08fea9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?eW9kV3VLSmdFQU1iKzZ1YUE1UEhUYU5mYzJpY3VVWHIzc3NPd1pndmN1RGcv?=
 =?utf-8?B?UjNYcGxSZDBYN2h0Z1VDblQ3bGUwWXQ0aFpwN0hpeVl2NFRXMVVzTzBPWkpr?=
 =?utf-8?B?NFFhMkszSTRub2w5YXRsU0FaQVpOa3JIb3lWNm91WDNXQ09CVkNRY2Vja3Q1?=
 =?utf-8?B?OWhuRS9wKzlxMHBmMEdyQ0czdFdVR3NNQW9zc2NTaEpGczdyWlo3VDVaMENq?=
 =?utf-8?B?eTk2a24xVk11TDBHQUpMQUlwNnZUUjVEZjliNzI4c0R6cDhib3FnK2pxSUJM?=
 =?utf-8?B?VTJNS25kbDFuZ1kvZ0loWUJQT2svOXpYeUNHWHJrRjlYZHVaWXFSdTVBcWJ3?=
 =?utf-8?B?Ulh3L05uQm81aVFRY0FPc0pITjdDTFovdDE2S28zUDR6TDZORjZyS3p5Wlhl?=
 =?utf-8?B?RkphL2xrRm9Wb1J3STYxTzM1Yk91dmFaZG1RcDNFa3J6Rm4vL1V0MDlzZXBw?=
 =?utf-8?B?RFRGeTdKUElmYlk5MXl3dEk1azhlZ1NLb2JYcE1hc3NCLzl4UXRZUE5PS0sw?=
 =?utf-8?B?Rmt6eFpmOUFhbnJUT09yRWEvUU5HZFNSUGRHVFUwZG4yUCtxR2ZYOHpXUHRn?=
 =?utf-8?B?K3c5QlJ5OVhLbWV6d2JMS0dpbUFWTnZXQkMrVVFOb1FRbzJGOGR4UXh2eXhU?=
 =?utf-8?B?b1E2bDlDZmZYc2hCbHVzdXlROW5uRDlTY2R2cnFRRnI2WjFwNThESjBhWnRv?=
 =?utf-8?B?d2VMcUNueHVVNDVRY1N1S25vbHJta003UGxadW53Zi9YdlNsbUdIMGMrWXRr?=
 =?utf-8?B?Wm1jc0h1U1ZyQzVyY3A1aDc3bGkyazdXL0t5amVCbzA0Snpsd3R2aVM5d1NX?=
 =?utf-8?B?YjJ3Y3g1TG1kdUNzc3VBVUpKb3ZzbVJoQ21JWXlEd2JGRkZ5SFYweHZBallS?=
 =?utf-8?B?M0pGb2hRNHJuQ0xzSnJZbjVGZmFRN2RDWEQvdlZ6RThNMCs5TERGK1hDWm1N?=
 =?utf-8?B?SjhiWFNYTXpINkNNWWluamRaNWRqeHA0aStBVUJScmNGQnR3bXFNTWpiSW1w?=
 =?utf-8?B?WE5XT1ZadXY2UkVWTnNEYldQa2RNaWlNc1NsZXNWUERCMkcvYi9UOXJhL0RX?=
 =?utf-8?B?TThrMXc4Q1RxMTFKSEVYTmRlMmZqQUhwOXpBM1dmMVRYd0JYQlFUOHBxVVFE?=
 =?utf-8?B?T09PM0UySEIwWm40Z3gwckNMdXl1VW43Y05DdEhHUHQ5QnhzWG93K2EwWi9p?=
 =?utf-8?B?ZExkRktleGgzb0oyYkxGZ2xlcUlGVitqd3B1WFZQZVlpK3o2eDhmMEFyQWxp?=
 =?utf-8?B?dFFmY0gzNzcvUE5iVzRFQUpmVjBrb0Qva3VtY0pEejZhQWx1MFlvQy91dkZH?=
 =?utf-8?B?dmdZMDhGQXVZeDVNSEthMWtJMjg4UkJGWXBQcDBvcWtHM3d3UmlmQWJhVnN4?=
 =?utf-8?B?cFc3T3BUWkNOaGUveGdSUHIzZHp1Rzlrczd2Y2ZjaTVITk9qUjh1aExRWXhB?=
 =?utf-8?B?SGtkY0dVbVRSK0Y3ODRFdlBic0VEeVoramJmN3Frd3BIWTZFK00vb1dxMk5L?=
 =?utf-8?B?MEVFZSt5ZG9zWkI5VXVoS2Z1eDBuS2swUytvYU0rU0xWRm81RUJZdGN1bHZq?=
 =?utf-8?B?OUhnUlV2bWs2MVZmRDI5YXhPdFRCcFg4RXN6WHE2R3djcnpxNFhWSE0yeEdL?=
 =?utf-8?B?MDVVWEY4N09QTnA2M0VrWGpoSEVjZzI5NW5qemJXRWY2dmM0eU9uRW5mMUVl?=
 =?utf-8?B?cmxnYjlkQlpjQ1JGaUIzWWgycURKZDZqK2NIZXorRzJpYWN6aVhSeFFoVGVy?=
 =?utf-8?B?VU9HNzNUbUxORDZmSDV5Rk9qd1dxOEJybVBXVEVjZGp1M2xucm85ekQvWDhT?=
 =?utf-8?B?YjhEVmovQi9nSmJtRWtKZUxMSUtBUFF0Q2JsU1VrUnNTMjhxUmhjUExXOWE5?=
 =?utf-8?B?NkcxaTIrZ0J6UEFma05PR04yMEVqZEJ0aitFWDdUTjNyVFE9PQ==?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB11445.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9330
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f96698d5-5907-4b4d-0e46-08de1a08ea57
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|35042699022|36860700013|1800799024|14060799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azk4S1dFSlU5K3NjaGNQdHBsSTFqTUt3RXI3SGR1OXdrYXYwMHhkeHBFMmps?=
 =?utf-8?B?Qm9zVGlvTk1xd0pZYWN0UzhpbCs1ZzViZGZWU2J5V0FXbFRsVExVd0NRSWQv?=
 =?utf-8?B?SUF4U2MvNVNUMGVMcjF5MTZaYmJReTYwNVFXbEhyeVg0OFVlUU5FS1JRdGtL?=
 =?utf-8?B?Q2QxSGttLzhqV2lVbldDaktUbjh4bWVMNGZmZmFEZG11RFNxQjZ2WDlhQlJo?=
 =?utf-8?B?cEl5Y0FYMitVRk9jZGRMSm8zbW1aREFLZHlDQXVQYmoyQmYxVnBSSUNLSmRM?=
 =?utf-8?B?dGRkWEZBZndWT0FRRTlwUm1mQmI3TDRqUWV5VzBXT1gyV3I4Z2dXQjlQNzlu?=
 =?utf-8?B?VTY5ODF1UVoxUENmR1RCejdaaVc2d0loZFIwb1RvV1VxZFpPMmp6WTRjMEhs?=
 =?utf-8?B?QmpZTDZ0UE4zOHNxdkRVUXZNQW5VelhtUmZubHVCbGIvZmdtYkxKS0pzZ3pa?=
 =?utf-8?B?TU5JZzZrSmFsOTE1QWg1cEZndmxYb0JjWnhBSUI5SE5uOXBiSmFoUTJWNFVw?=
 =?utf-8?B?d3pKSG56K2pDMmlmZW1pOVBGQ3FhdkVBRWpGai9nbDdVK2NnQTBVSzhUcnkr?=
 =?utf-8?B?Wm1WR0loZGlhRHRGRnR0Tm5xdVg2eDE5eFVpb3V1dmpKWmsxeXZxSXNtbTJ2?=
 =?utf-8?B?R2VVNEZQTzZsclRPSFA0UlJsOHVHU1ZpY2NaTjNMYjI0WUE5OVVIR3diTGRM?=
 =?utf-8?B?a1Zja3Q1QkxuSzN4Zk1Bbk1raFloSElWc1pXNXRFam5NamlXU2dZTTlFdllZ?=
 =?utf-8?B?N0I3SktNaDcyblZGaFdtblZvZy85Q3lRbW5kd0N2UTNMeFF4Q2hXMldPMjky?=
 =?utf-8?B?VTMvb0l4Y3JtSkpjZ2dWancyL2JoZEI0cEtzbFNJOFpTbGJhRHJHTGN0dExr?=
 =?utf-8?B?OFBIYk5mMCtpK3BhS05PNjJmT1VwV0RSV0VPK04zZXpKeTN1SUc0bHNRaUtM?=
 =?utf-8?B?K3U4am5EYVZxdVFyWmdvNmhEVXRsc3hqTDdZb2dENXRzUUsrMm95SUtKNStm?=
 =?utf-8?B?S2ppTG8ybTFNSE5DbmMzNTVodVZUdVhQQmtNbS9NZmVuRXVVRW9GTVpxZG5I?=
 =?utf-8?B?Wjcza1BERGdtUjZvWTJPLzNuRGpFRWVuS0p5K1lFbmhWbkxqOGVkNU1JZC96?=
 =?utf-8?B?UHpPSUlUSWFXS1ZyelUrbUN1SEd2SWkvN1c5dFZicmdtcVl4MUhPaEQydEZ5?=
 =?utf-8?B?RTN0S2F3SS9CWitQUEhVdE9xNUZlWVprajdnZ2F5RDByZEJnd1hldWRTOTEx?=
 =?utf-8?B?VnFTdWNnU1JxRlJDdmsveDRFN2F6UElNQlBqMmpzTjcrKzFjUUY0b0VTQWFl?=
 =?utf-8?B?eVBhUDJwMGptT1AzUXNrdEhDdDBtcC9BaWpOKzNXbHBJUkYxUTkyNlNVTGlx?=
 =?utf-8?B?cnpOWHN1RkUwNHFMVEpmOWlCZ2FDaHZZM1dBazlPVDJlaHhheTFkSDFNbmlr?=
 =?utf-8?B?WnliR3NnSDRIZFBJQnNWUGJaSXd4YVR5TW9zK1hiQjUreFVFbVJtbXIxcVht?=
 =?utf-8?B?cVRHN0F6c2JFdFplaXFqbVEzSVVtbTFIYmt0V3BONFBGbXd6Y1VYdmhRNmNO?=
 =?utf-8?B?bmJUTURPWlRIVTNlSERoMXp1UWJSeUVtZTdTUHpEZGppd2x6cVNWL0VEdnRy?=
 =?utf-8?B?d3ZvRXFSdlN4VUVreVVTU29aZERiMnJNSUlQelBkR0JCL09JaitjS0NoWlhy?=
 =?utf-8?B?N0lzc0JyUEk4K3JrM0xidWJrQ29wVFYwaFdOaHNlbTIxRk5EVkpKa0NmNXRI?=
 =?utf-8?B?VFZuUVR0c2pScVcwaHRoU2lxSWRGTitlMWtuall6Z0dGcmlWeFErTURncm5S?=
 =?utf-8?B?aDh3dUpOU2dmQ2VNaVdXc29nUm1PZnNGM29DUTZVd2lNZ3RRMCszRGtiTTVr?=
 =?utf-8?B?alc3R3F1YTVtUWdtZ0psYnRmTkpZVWVTMHB4MUhDMUVGRzc3R0twUE45U0NX?=
 =?utf-8?B?bnd3d3VaOUxOVDVsbnFGY2pmOU82ckR3Zys3REtJVlFqYVduNkpJREpUd1hp?=
 =?utf-8?B?c09jcUxlL0VXNjEyUldLR2FEQXFHY3p0Y1pZRk1vcGJOa1V2VUI5NVZKZlRy?=
 =?utf-8?Q?qh6toc?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(35042699022)(36860700013)(1800799024)(14060799003)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2025 12:11:46.6863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 013eeff3-e7be-4f45-99fa-08de1a08fea9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9316
X-Rspam-User: 
X-Stat-Signature: 1rmakq3fpncswy4feig4kg3k9sjay5zf
X-Rspamd-Queue-Id: 1789F1C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1762085513-693111
X-HE-Meta: U2FsdGVkX1/gRkbGBfjH/x5VA1sdr3Uyy5ThAsH0euS3d/K/WPE8veT1OqhYSazysRWtv37UKcwJc5ZRt578jDotZnGFdUVR3YmL27YgQplDwo65xLli1U6wvvWUItnixWzgzi5R2vCnRdmdz8JrrGj/kinul5cFmx4MLsF0aKFjfmj9kKjB0yVSx5v3Aoe8NYote+f1L/5G9sDvBbbkkhObjZ5noBmUBUM4l08Mx9+ZeOCd/u7e2sWpXVp2eGuNut5DmduQAzoUXyjsL8A/OKRvSnL4/VQ+/3g9S02OuWCTbp2gKSmRG2yG3hURqv/xWTf2miBFHlL3XLd2bkEmvQZ2dncZ9H8jmgMy3xpvrpl4zGFQqBVlvrHp8RGewbDqm3zvBxT89z/D6z7i3iXAvxvTYggFfvOkd9wkgqBDwCGJb6z5PHgO7TyDhmkHpor0bh8MXz8Nj0rfJrLofn3yCll1eiYuDCAs9HQMU6dmISRj6v8u/WKxn58b9EzerglaW1qDdCeSSH9lGwfgv340sBhEo6rOU7xbrrmWAHk88z+llawQq4BTfqTbZG0ROoJ4D1+/a62X3EBPAWY7XpdqoVOj2tfERFmGovDw4wUlsUJ6kIcV5NY5U77GC1I9EhgDHAtIp6KePIedVfOY4+NSBxyCO61iaEdMxo6c7jnnUrqsfWQZd2EWY7RjuP8qdRhvvGucGC+THW0RA32frvVfgcVPS1IX24CniF/cfQEoCkpm5VjKW+xpjMBhqeALl6csTrsTnkcaYiixB0fa7mVZR89o+0+PiwiYmjVrxN/h8KT376vbH2WGIEqAc7oTj4V6jKFAfjrqyAGhJj83O5VX2vBKttXxnTknYcwh5GqF7RLa4F6sshlaHVZUXoQ9sCgJErE79Lu9VF4AW2LJR4CrisfCPfKSC3fBp1shO9RPxE4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/11/2025 10:31, Ryan Roberts wrote:
> On 01/11/2025 16:14, Guenter Roeck wrote:
>> Hi,
>>
>> On Wed, Sep 17, 2025 at 12:02:09PM -0700, Yang Shi wrote:
>>> When rodata=full is specified, kernel linear mapping has to be mapped at
>>> PTE level since large page table can't be split due to break-before-make
>>> rule on ARM64.
>>>
>>> This resulted in a couple of problems:
>>>   - performance degradation
>>>   - more TLB pressure
>>>   - memory waste for kernel page table
>>>
>>> With FEAT_BBM level 2 support, splitting large block page table to
>>> smaller ones doesn't need to make the page table entry invalid anymore.
>>> This allows kernel split large block mapping on the fly.
>>>
>>> Add kernel page table split support and use large block mapping by
>>> default when FEAT_BBM level 2 is supported for rodata=full.  When
>>> changing permissions for kernel linear mapping, the page table will be
>>> split to smaller size.
>>>
>>> The machine without FEAT_BBM level 2 will fallback to have kernel linear
>>> mapping PTE-mapped when rodata=full.
>>>
>>> With this we saw significant performance boost with some benchmarks and
>>> much less memory consumption on my AmpereOne machine (192 cores, 1P)
>>> with 256GB memory.
>>>
>>> * Memory use after boot
>>> Before:
>>> MemTotal:       258988984 kB
>>> MemFree:        254821700 kB
>>>
>>> After:
>>> MemTotal:       259505132 kB
>>> MemFree:        255410264 kB
>>>
>>> Around 500MB more memory are free to use.  The larger the machine, the
>>> more memory saved.
>>>
>>> * Memcached
>>> We saw performance degradation when running Memcached benchmark with
>>> rodata=full vs rodata=on.  Our profiling pointed to kernel TLB pressure.
>>> With this patchset we saw ops/sec is increased by around 3.5%, P99
>>> latency is reduced by around 9.6%.
>>> The gain mainly came from reduced kernel TLB misses.  The kernel TLB
>>> MPKI is reduced by 28.5%.
>>>
>>> The benchmark data is now on par with rodata=on too.
>>>
>>> * Disk encryption (dm-crypt) benchmark
>>> Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
>>> disk encryption (by dm-crypt).
>>> fio --directory=/data --random_generator=lfsr --norandommap            \
>>>     --randrepeat 1 --status-interval=999 --rw=write --bs=4k --loops=1  \
>>>     --ioengine=sync --iodepth=1 --numjobs=1 --fsync_on_close=1         \
>>>     --group_reporting --thread --name=iops-test-job --eta-newline=1    \
>>>     --size 100G
>>>
>>> The IOPS is increased by 90% - 150% (the variance is high, but the worst
>>> number of good case is around 90% more than the best number of bad
>>> case). The bandwidth is increased and the avg clat is reduced
>>> proportionally.
>>>
>>> * Sequential file read
>>> Read 100G file sequentially on XFS (xfs_io read with page cache
>>> populated). The bandwidth is increased by 150%.
>>>
>>
>> With lock debugging enabled, we see a large number of "BUG: sleeping
>> function called from invalid context at kernel/locking/mutex.c:580"
>> and "BUG: Invalid wait context:" backtraces when running v6.18-rc3.
>> Please see example below.
>>
>> Bisect points to this patch.
>>
>> Please let me know if there is anything I can do to help tracking
>> down the problem.
> 
> Thanks for the report - ouch!
> 
> I expect you're running on a system that supports BBML2_NOABORT, based on the
> stack trace, I expect you have CONFIG_DEBUG_PAGEALLOC enabled? That will cause
> permission tricks to be played on the linear map at page allocation and free
> time, which can happen in non-sleepable contexts. And with this patch we are
> taking pgtable_split_lock (a mutex) in split_kernel_leaf_mapping(), which is
> called as a result of the permission change request.
> 
> However, when CONFIG_DEBUG_PAGEALLOC enabled we always force-map the linear map
> by PTE so split_kernel_leaf_mapping() is actually unneccessary and will return
> without actually having to split anything. So we could add an early "if
> (force_pte_mapping()) return 0;" to bypass the function entirely in this case,
> and I *think* that should solve it.
> 
> But I'm also concerned about KFENCE. I can't remember it's exact semantics off
> the top of my head, so I'm concerned we could see similar problems there (where
> we only force pte mapping for the KFENCE pool).
> 
> I'll investigate fully tomorrow and hopefully provide a fix.

Here's a proposed fix, although I can't get access to a system with BBML2 until 
tomorrow at the earliest. Guenter, I wonder if you could check that this 
resolves your issue?

---8<---
commit 602ec2db74e5abfb058bd03934475ead8558eb72
Author: Ryan Roberts <ryan.roberts@arm.com>
Date:   Sun Nov 2 11:45:18 2025 +0000

    arm64: mm: Don't attempt to split known pte-mapped regions
    
    It has been reported that split_kernel_leaf_mapping() is trying to sleep
    in non-sleepable context. It does this when acquiring the
    pgtable_split_lock mutex, when either CONFIG_DEBUG_ALLOC or
    CONFIG_KFENCE are enabled, which change linear map permissions within
    softirq context during memory allocation and/or freeing.
    
    But it turns out that the memory for which these features may attempt to
    modify the permissions is always mapped by pte, so there is no need to
    attempt to split the mapping. So let's exit early in these cases and
    avoid attempting to take the mutex.
    
    Closes: https://lore.kernel.org/all/f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net/
    Fixes: a166563e7ec3 ("arm64: mm: support large block mapping when rodata=full")
    Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b8d37eb037fc..6e26f070bb49 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -708,6 +708,16 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 	return ret;
 }
 
+static inline bool force_pte_mapping(void)
+{
+	bool bbml2 = system_capabilities_finalized() ?
+		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
+
+	return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
+			   is_realm_world())) ||
+		debug_pagealloc_enabled();
+}
+
 static DEFINE_MUTEX(pgtable_split_lock);
 
 int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
@@ -723,6 +733,16 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
 	if (!system_supports_bbml2_noabort())
 		return 0;
 
+	/*
+	 * If the region is within a pte-mapped area, there is no need to try to
+	 * split. Additionally, CONFIG_DEBUG_ALLOC and CONFIG_KFENCE may change
+	 * permissions from softirq context so for those cases (which are always
+	 * pte-mapped), we must not go any further because taking the mutex
+	 * below may sleep.
+	 */
+	if (force_pte_mapping() || is_kfence_address((void *)start))
+		return 0;
+
 	/*
 	 * Ensure start and end are at least page-aligned since this is the
 	 * finest granularity we can split to.
@@ -1009,16 +1029,6 @@ static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) {
 
 #endif /* CONFIG_KFENCE */
 
-static inline bool force_pte_mapping(void)
-{
-	bool bbml2 = system_capabilities_finalized() ?
-		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
-
-	return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
-			   is_realm_world())) ||
-		debug_pagealloc_enabled();
-}
-
 static void __init map_mem(pgd_t *pgdp)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
---8<---

Thanks,
Ryan

> 
> Yang Shi, Do you have any additional thoughts?
> 
> Thanks,
> Ryan
> 
>>
>> Thanks,
>> Guenter
>>
>> ---
>> Example log:
>>
>> [    0.537499] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
>> [    0.537501] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
>> [    0.537502] preempt_count: 1, expected: 0
>> [    0.537504] 2 locks held by swapper/0/1:
>> [    0.537505]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x24/0x38
>> [    0.537510]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x0/0x40
>> [    0.537516] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-dbg-DEV #1 NONE
>> [    0.537517] Call trace:
>> [    0.537518]  show_stack+0x20/0x38 (C)
>> [    0.537520]  __dump_stack+0x28/0x38
>> [    0.537522]  dump_stack_lvl+0xac/0xf0
>> [    0.537525]  dump_stack+0x18/0x3c
>> [    0.537527]  __might_resched+0x248/0x2a0
>> [    0.537529]  __might_sleep+0x40/0x90
>> [    0.537531]  __mutex_lock_common+0x70/0x1818
>> [    0.537533]  mutex_lock_nested+0x34/0x48
>> [    0.537534]  split_kernel_leaf_mapping+0x74/0x1a0
>> [    0.537536]  update_range_prot+0x40/0x150
>> [    0.537537]  __change_memory_common+0x30/0x148
>> [    0.537538]  __kernel_map_pages+0x70/0x88
>> [    0.537540]  __free_frozen_pages+0x6e4/0x7b8
>> [    0.537542]  free_frozen_pages+0x1c/0x30
>> [    0.537544]  __free_slab+0xf0/0x168
>> [    0.537547]  free_slab+0x2c/0xf8
>> [    0.537549]  free_to_partial_list+0x4e0/0x620
>> [    0.537551]  __slab_free+0x228/0x250
>> [    0.537553]  kfree+0x3c4/0x4c0
>> [    0.537555]  destroy_sched_domain+0xf8/0x140
>> [    0.537557]  cpu_attach_domain+0x17c/0x610
>> [    0.537558]  build_sched_domains+0x15a4/0x1718
>> [    0.537560]  sched_init_domains+0xbc/0xf8
>> [    0.537561]  sched_init_smp+0x30/0x98
>> [    0.537562]  kernel_init_freeable+0x148/0x230
>> [    0.537564]  kernel_init+0x28/0x148
>> [    0.537566]  ret_from_fork+0x10/0x20
>> [    0.537569] =============================
>> [    0.537569] [ BUG: Invalid wait context ]
>> [    0.537571] 6.18.0-dbg-DEV #1 Tainted: G        W
>> [    0.537572] -----------------------------
>> [    0.537572] swapper/0/1 is trying to lock:
>> [    0.537573] ffffb60b011f3830 (pgtable_split_lock){+.+.}-{4:4}, at: split_kernel_leaf_mapping+0x74/0x1a0
>> [    0.537576] other info that might help us debug this:
>> [    0.537577] context-{5:5}
>> [    0.537578] 2 locks held by swapper/0/1:
>> [    0.537579]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x24/0x38
>> [    0.537582]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x0/0x40
>> [    0.537585] stack backtrace:
>> [    0.537585] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.18.0-dbg-DEV #1 NONE
>> [    0.537587] Tainted: [W]=WARN
>> [    0.537588] Call trace:
>> [    0.537589]  show_stack+0x20/0x38 (C)
>> [    0.537591]  __dump_stack+0x28/0x38
>> [    0.537593]  dump_stack_lvl+0xac/0xf0
>> [    0.537596]  dump_stack+0x18/0x3c
>> [    0.537598]  __lock_acquire+0x980/0x2a20
>> [    0.537600]  lock_acquire+0x124/0x2b8
>> [    0.537602]  __mutex_lock_common+0xd8/0x1818
>> [    0.537604]  mutex_lock_nested+0x34/0x48
>> [    0.537605]  split_kernel_leaf_mapping+0x74/0x1a0
>> [    0.537607]  update_range_prot+0x40/0x150
>> [    0.537608]  __change_memory_common+0x30/0x148
>> [    0.537609]  __kernel_map_pages+0x70/0x88
>> [    0.537610]  __free_frozen_pages+0x6e4/0x7b8
>> [    0.537613]  free_frozen_pages+0x1c/0x30
>> [    0.537615]  __free_slab+0xf0/0x168
>> [    0.537617]  free_slab+0x2c/0xf8
>> [    0.537619]  free_to_partial_list+0x4e0/0x620
>> [    0.537621]  __slab_free+0x228/0x250
>> [    0.537623]  kfree+0x3c4/0x4c0
>> [    0.537625]  destroy_sched_domain+0xf8/0x140
>> [    0.537627]  cpu_attach_domain+0x17c/0x610
>> [    0.537628]  build_sched_domains+0x15a4/0x1718
>> [    0.537630]  sched_init_domains+0xbc/0xf8
>> [    0.537631]  sched_init_smp+0x30/0x98
>> [    0.537632]  kernel_init_freeable+0x148/0x230
>> [    0.537633]  kernel_init+0x28/0x148
>> [    0.537635]  ret_from_fork+0x10/0x20
>>
>> ---
>> bisect:
>>
>> # bad: [3a8660878839faadb4f1a6dd72c3179c1df56787] Linux 6.18-rc1
>> # good: [e5f0a698b34ed76002dc5cff3804a61c80233a7a] Linux 6.17
>> git bisect start 'v6.18-rc1' 'v6.17'
>> # bad: [58809f614e0e3f4e12b489bddf680bfeb31c0a20] Merge tag 'drm-next-2025-10-01' of https://gitlab.freedesktop.org/drm/kernel
>> git bisect bad 58809f614e0e3f4e12b489bddf680bfeb31c0a20
>> # bad: [a8253f807760e9c80eada9e5354e1240ccf325f9] Merge tag 'soc-newsoc-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
>> git bisect bad a8253f807760e9c80eada9e5354e1240ccf325f9
>> # bad: [4b81e2eb9e4db8f6094c077d0c8b27c264901c1b] Merge tag 'timers-vdso-2025-09-29' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> git bisect bad 4b81e2eb9e4db8f6094c077d0c8b27c264901c1b
>> # bad: [f1004b2f19d7e9add9d707f64d9fcbc50f67921b] Merge tag 'm68k-for-v6.18-tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
>> git bisect bad f1004b2f19d7e9add9d707f64d9fcbc50f67921b
>> # good: [a9401710a5f5681abd2a6f21f9e76bc9f2e81891] Merge tag 'v6.18-rc-part1-smb3-common' of git://git.samba.org/ksmbd
>> git bisect good a9401710a5f5681abd2a6f21f9e76bc9f2e81891
>> # good: [fe68bb2861808ed5c48d399bd7e670ab76829d55] Merge tag 'microblaze-v6.18' of git://git.monstr.eu/linux-2.6-microblaze
>> git bisect good fe68bb2861808ed5c48d399bd7e670ab76829d55
>> # bad: [f2d64a22faeeecff385b4c91fab5fe036ab00162] Merge branch 'for-next/perf' into for-next/core
>> git bisect bad f2d64a22faeeecff385b4c91fab5fe036ab00162
>> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/misc' into for-next/core
>> git bisect good 30f9386820cddbba59b48ae0670c3a1646dd440e
>> # good: [43de0ac332b815cf56dbdce63687de9acfd35d49] drivers/perf: hisi: Relax the event ID check in the framework
>> git bisect good 43de0ac332b815cf56dbdce63687de9acfd35d49
>> # good: [5973a62efa34c80c9a4e5eac1fca6f6209b902af] arm64: map [_text, _stext) virtual address range non-executable+read-only
>> git bisect good 5973a62efa34c80c9a4e5eac1fca6f6209b902af
>> # good: [b3abb08d6f628a76c36bf7da9508e1a67bf186a0] drivers/perf: hisi: Refactor the event configuration of L3C PMU
>> git bisect good b3abb08d6f628a76c36bf7da9508e1a67bf186a0
>> # good: [6d2f913fda5683fbd4c3580262e10386c1263dfb] Documentation: hisi-pmu: Add introduction to HiSilicon V3 PMU
>> git bisect good 6d2f913fda5683fbd4c3580262e10386c1263dfb
>> # good: [2084660ad288c998b6f0c885e266deb364f65fba] perf/dwc_pcie: Fix use of uninitialized variable
>> git bisect good 2084660ad288c998b6f0c885e266deb364f65fba
>> # bad: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm' into for-next/core
>> git bisect bad 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>> # first bad commit: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm' into for-next/core
>>
>> ---
>> bisect into branch:
>>
>> - git checkout -b testing 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>> - git rebase 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>>   [ fix minor conflict similar to the conflict resolution in 77dfca70baefc]
>> - git diff 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>   [ confirmed that there are no differences ]
>> - confirm that the problem is still seen at the tip of the rebase
>> - git bisect start HEAD 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>> - run bisect
>>
>> Results:
>>
>> # bad: [47fc25df1ae3ae8412f1b812fb586c714d04a5e6] arm64: map [_text, _stext) virtual address range non-executable+read-only
>> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/misc' into for-next/core
>> git bisect start 'HEAD' '77dfca70baefcb988318a72fe69eb99f6dabbbb1~1'
>> # good: [805491d19fc21271b5c27f4602f8f66b625c110f] arm64/Kconfig: Remove CONFIG_RODATA_FULL_DEFAULT_ENABLED
>> git bisect good 805491d19fc21271b5c27f4602f8f66b625c110f
>> # bad: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large block mapping when rodata=full
>> git bisect bad 13c7d7426232cc4489df7cd2e1f646a22d3f6172
>> # good: [a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8] arm64: Enable permission change on arm64 kernel block mappings
>> git bisect good a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8
>> # first bad commit: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large block mapping when rodata=full
> 


