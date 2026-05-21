Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E8FCD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 10:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43926B0088; Thu, 21 May 2026 06:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE1C6B008A; Thu, 21 May 2026 06:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95546B008C; Thu, 21 May 2026 06:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9ACE6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:46:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E8034058C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:46:16 +0000 (UTC)
X-FDA: 84791097552.26.E08FF48
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012040.outbound.protection.outlook.com [52.101.48.40])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7EE4A1C0015
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:46:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bVTmzZ7w;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779360373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D75tCjitQ1odxw9JZsctvqpHrXyBP10/ZfCuiJk1724=;
	b=w+1T/VtYviyWfhc0uMmN5x2a4ih2fz+aBQjKHkkSTTzratJ2jykYr+UDFQu93QXGinRjzW
	S7fVzxyGl7eaenAb4zV0kxxUBci6028NsofXm1+MnsDW6Z4Ghr2sp8irGp3EmO1BrAklSN
	uHrt7CCJztKJgwA532/r02bWFg18hHw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779360373; a=rsa-sha256;
	cv=pass;
	b=EZ+OHJ9AbvqBxZFJtu45A+PLDS6O78sxBz9ki88ECN9tGSKXly8K8KN+HJLkjn3N3aYw9c
	tYifBdiaZRP4Tw04tKU9JMxwNBTR2WCen/YR8VhLwaz9O54AnWIe/AorTmA8kkP1r4pQ61
	z2a3W4BjdWLIV4fulHQ2yh2PYtgY8x8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bVTmzZ7w;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rfhqCzR4JZoSzO38agpYl79s7BTpafYUCYJoQ5JRxhixJc3L7fWP8ZCrQe4kwWknGS1RG65NoRT2kAFKrfz5zciC+Or3AekJK73Cd6iMmT4AeqWTsvf/LdbbNwNnDpDEzRXyOG350IxUgt3v0RTiKFFZ1/y+ovUFMm03BjnKyM77QCAdE+MPCNeD1NKvac5cZEj7athbshEfxFP9NF015Fzfi8oylUpGrzn1iwBN4P7Fjj9vZ0cLPMZYZ1oXZPkhO+fVTtHNn5IY9itV91sCUvsA6qGx/rWtnoiX97qCl+Es8rTshoxX9aa9rnCH6mQqmcJB5IDCee9FmTBnMhde2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D75tCjitQ1odxw9JZsctvqpHrXyBP10/ZfCuiJk1724=;
 b=rwPh3Ja87HfF8ZzTcnns8cXdLNdbN73FYmdZofTzPrEvq7Yo4XfALXb1z5Bv3mE8jlzZbYvtlN66IeFgif3RGMb0zdr0XwJs03RhySOThg0xp6RtakN+PpJlZD6EYTC+V1qffM8gDlhirh5UUZ+zgRUmPhmdN+h0/6cpn8V4prtAyRNKiXK3pKM/gBFwA6KzmiIedv16/fXOa3TC0UBaJeK+zGIGAnJtB573eXFqyaLaBi24ZmOUm984kn4esK1Z1QdzlxsDg9WUsvdP4ZQyN4QB1qYZtCA8sLSTkHHDn7xLQ9jfDs9z+zrZinwg6QMAFLsl/0ggCKdfUSp9/ilreg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D75tCjitQ1odxw9JZsctvqpHrXyBP10/ZfCuiJk1724=;
 b=bVTmzZ7w8Fyr+Kr97fUGSTj237Gd/uI50Z1dobemGWQO8dsPdBenMKn8wIIVYzLqRVW0sLYyBaNCMXtiqpNXWtZ+Rp8yf1nSyb5U/U65Gsfe/KzRDt/aXl9rcZeQATQMYjzq4WmR0kFhOz8+aveMvJeoc3rJLciLq1NqGUqjJvuXiHhYWPySCxUPA+W8UleGNcR9A+7SWe8KNxZzCueJWhT6KfBc86x8IqN2ixu12Y3suPYLklZRaLpDNMk1yQJsjXIZpHyO1J10+QdO8X9Plwsm+tv/er/ubJoJazSMkgfZmOiXnFVULfYZ6hmXxzWG/EkJUrjqGKVveg1sDOoH/A==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH1PPF5A8F51299.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Thu, 21 May
 2026 10:46:08 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 10:46:07 +0000
Date: Thu, 21 May 2026 20:46:02 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	catalin.marinas@arm.com, will@kernel.org, david@kernel.org, anshuman.khandual@arm.com, 
	dev.jain@arm.com, jhubbard@nvidia.com
Subject: Re: [PATCH] [RFC] arm64: mmu: use range based TLB flushing when hot
 unplugging memory
Message-ID: <ag7fy4Q9foBBlUcd@parvat>
References: <20260521042426.2128731-1-apopple@nvidia.com>
 <bc96d822-bb68-4945-9f74-68f77e389ac6@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc96d822-bb68-4945-9f74-68f77e389ac6@arm.com>
X-ClientProxiedBy: ME3P282CA0127.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1c4::17) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH1PPF5A8F51299:EE_
X-MS-Office365-Filtering-Correlation-Id: ba960f1a-098b-4f4c-a183-08deb72629c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	uAhM/KdAyRmD1/CujTewR4uRbygKbGbtT7qThZ0DxI6V6KRKKbbMKYv5ruo3qcZ1OkGmCqR32S25v+5xTgr9Z5LQuXwbIibbffUQvoDVBGp+C6OKN58E7m1K1JH8OTpd2/eJ6zAfwreoStdhB2Z2jf3pmck0ViSSTwVP45dpRo2KBnO0ZCVj5d6SB6ZqacIieKKeIEw2tDrfMvt1d12atuWPtqJKJqFKW5FUnfw3zvUGgsISbXl6dhMcVkp4ke9DpqITeuf0PslQeCSTltZKOYhr5zgNRm5oWm8wRuDDt4GPeyD5b7BugolNhLVQ+KWkzPluN3QQnDLlzlA4irF2MW8DWEj/i1i3yW59es3sXNhFVxNmh3f6JlnV/An5CX3VDKKJa7SMDfKF2iVq3rA+3LCZ4bNHzXZiaZU16K1X2wt0sLXOfrQI6xOEPU8KNvUPohs1uIQvO1kdvHnFOmWyjPQZIVGIMXgx8k2Jp6iAshbj96ie+f2DO6KIi60KLsOIPycnGvFAkkjdlsGV5njhHjfbaoMxMeaXSOlwQsPxLjkFCqUiJ8mGh8SzUI2f+NQmBWusQ/ZXU438qwJvJ9STgqLBBIbEIoFGLSe1/8hVdy6x5q38TynAKdJb0JWi6wvZQEH/PEp135T4mpCIG171MGuTgbR7NuwEXxiAYtV00VKbXFchE1osO2k6fmdLzY3d
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zM/cLqMq6OG4awWze8LCmLJMmPIsIPX5D3X4jz1scDzLOJnCByoFrbdZLAMX?=
 =?us-ascii?Q?iiPUF2Fo9HqLO/DGiUKYs4xTzY8bOcLodAFE7487GaUfrw//aWVAxVl7EqFL?=
 =?us-ascii?Q?IwZvsQtJm+cUkNAIp3DOuL9ZiVS4/PnP6d82j7v5glEjWb2IXuRLjYUIQPpv?=
 =?us-ascii?Q?4bzHslij7ILViPpiiSGJiju2RAPUCAH2tgfk6Tx2aSB1fDZqcnwqrzQMNQfq?=
 =?us-ascii?Q?uVRU8FmFxBWHikC/v5VLOkSatF8pPHdgN/q4Mq/TLtzeeYZsXnjeZ584dCbu?=
 =?us-ascii?Q?/xjAbhOJYLyNwnt3fVc9GHQg/NtYhK7MRFkRRpja8IB27WQcPtIpVO/ge2lg?=
 =?us-ascii?Q?qsl9fv+buSiAV40/FZiUh4ad31O00Fwb3Ougf3/FGHeclyWVpUzIvPWZFsso?=
 =?us-ascii?Q?7eAQKEj9+IWKfNFPBLHxGccYt5aOLSJsI9nlkM1QFTqHPYn1Yec8xwxo711l?=
 =?us-ascii?Q?yFRR2ZJ4+bHo4EgRX/BbHdVhnTzK8HmD8AU/y2DKNF22XEpb3ZytrEQt8agp?=
 =?us-ascii?Q?y++x31jb5BT4T3+kaO5mzKm5/XHFtgdM646hj7LzjEUqKNR8+BJopvqNsUIt?=
 =?us-ascii?Q?bc3zLQknabUFqhH4lKubVSo8eLHkz5QzyUZqt4hCdnXSJ/jqkQuzWzGTvQV4?=
 =?us-ascii?Q?JUVpPp1pOg/82Nu4G+F7qf2wLALtXvUpeH+pDMaMJpn7/k+fn/qtIg6+YlV3?=
 =?us-ascii?Q?5pnl9ejUWbxW1+iuIPldau1vYBvldXTKjronrX6g1duAfO9kwzucMJIru+4C?=
 =?us-ascii?Q?IAmMaAoBUKGU+rsOtWY+IDoJtUBfzQS4T2xafZoENLJU/QzIbqiYyeQdflum?=
 =?us-ascii?Q?PeaSYC+HFxkywlqzXveTQ+euajSotgeYWo6Vd4Fa4j4j9JtdA0aSrMOEH+GK?=
 =?us-ascii?Q?a+0eIFG/eMeDR0Gpjrr3KwfSV1xxFAGpNBmcV6b4StQbUvQotsa2MIZ1IheY?=
 =?us-ascii?Q?8fKbZF+KO3KHErimy6cQ/ZbHkqQM8fRLcIrWvZwfxhF0n9c/EOWQl3LaIpIT?=
 =?us-ascii?Q?MNZ/JoQhWqXUQVktY6ZxZxLEFzCzK/D41PvyW6iPZm3SFbzLOckW3Y0QkcBr?=
 =?us-ascii?Q?ZLsB6DpLsf2WX/oWJ1TC/OtXBUlYHK6DW/CJ0DDTgSDUA+/3h4aGd0Kx/dMw?=
 =?us-ascii?Q?F6+QGRajVl20zSzaur0DCsfsb7mgHyBjqZw6hJPRSx6TKENlG5Py8XO3ESxj?=
 =?us-ascii?Q?9BzwuIcdQtuML5XZ8T39LhIUd0PrHI/oFfV5JAcqP8LDeKaiRvTJjDYGzrUw?=
 =?us-ascii?Q?wRBfDAIWOO6YXNgXGfBbZ1YjGdKyyTSy4DX78HUvfaIc0KCRyem9e8xCskea?=
 =?us-ascii?Q?ifkfJo32zpf8BteJY761p5DKq5Cv5LlmQAS6NMhMxxwDeqLbnla9g/oQbjwA?=
 =?us-ascii?Q?U2QfkoR8rEJRJkOqHSzg1eaBVggan6heKKKQitTORjdtg9mHKNdldSzWNOuB?=
 =?us-ascii?Q?9l50TN0eVzY2ImPCfH3OaMPbyj1aX6DSIFbfyIdVSD+KTKnwFxoYlgNGv5Ak?=
 =?us-ascii?Q?GzUczouPHYLEEeHLy+w6YRPZQSzVDgWtHqjX5uwEA0QujhJVBkv2w5zTkV52?=
 =?us-ascii?Q?3YiweqiUeisLyiRCEIpoXuKCnEEOTXl9dZHr3NhMm6yRfQsDvREhGcpGrXn+?=
 =?us-ascii?Q?lNOUxp5kGthCnsT6TZ/2TrzH+6f/Rg8523Z+Zz8S6m9aRvCOT1vAGIRFd4U5?=
 =?us-ascii?Q?1tnJDb0oOYrpde3UX6tpntnMAUDpMuNygJW8nGnXVIKZexDh63kGuPJXzsDa?=
 =?us-ascii?Q?c7LU3yRLRQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba960f1a-098b-4f4c-a183-08deb72629c0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 10:46:07.4589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRvGG5nDBRogWz+ZyXhql2/h1yJV4hdasYF5pqVl52wD/iamZbINpuaNPJh1aF1W0CfCqk430gnjxjj8FNWe2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF5A8F51299
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7EE4A1C0015
X-Stat-Signature: zwugg1tqht6fh3gz179ck1q66e46cp6g
X-Rspam-User: 
X-HE-Tag: 1779360373-765336
X-HE-Meta: U2FsdGVkX18atBR9411GMLo2QHFGUTD+CTGMf7/gI29Wl1kn9EGFSqUy5b2tVteXKWHOclKDKfKzGdkHDqBEsQ36KWGXBcBV5ymiN3DFhRJY8yo0aJ5DBLsrRLoMpjEYfFfvFbLoBNafc0u4bCUM8rhhy5+3tg8Xj5nkjH8pc0HN1eDkHa9hjxOwqMDKNxQf2xwFRQjMprtYLyjzunq6oIx0Pzi31vVPpZSxJ8dxbqqf27vjqPEaUKwLjr3v4Z8lV+ESf35Li8zTKnQRFqW/yFkHUoLS8861Us6It6vBrIPDfq5UsgM8I2JRyO2KXYTECc9hD1jO3lQ8SNONLxM+9ghE/OfUKV27WLNLnNN4uRAhoZzHftl7Tw8+sxhsEVL9mZbvfC+57A/5TNVJbmWFCYXddVydKqQhnDzYaTEueo4S/OB7TCnbC/KwVe5QPM87r+4Qd6+WS+My/S7bZ9NIFGYBFXLYoobtoeMT7hHnOs8pNEgNJR3bam5w6mXTnNklRAQRbCEDp7aEWineZCgOs4A6T0/CJjmsmfhQEuNyYyjNzDl5hxJYHLlf+MHDSQVpHRduxZ2YpzoIHYIZH2thgsway1+qj8OdVVoPB2t8CQfHns61t0JjKx0wwRNAqdpOWO8Dwd+1Ge/GAdQS090O7ogtMhv6ybUvibsp3XKXEu/G1HlJcYSnDc0Gb+aiU3bRXCO3GvftvBUFWvZSC/Vd3m0GFn6XNPU2rGrTGhVD5AQQ5JQuK6dOLzXtpWwJSDTUQNHvCyOlDD8FaoH4gz4rE3lQfXQxmIct3DYaoD+ErUSELglTuScx5m3tUj9FknN8+c3BMsXYP2YrJ/CEgqJMlJfqVwrKk0nA5sBgVK4cGlXFRhkGgHktlLFmQeOl881whvQqA9eUlcPXwi/RWJ0b/mubhwur89fWooMNPSMhhE4wgSGoyPeJt03DOl62MZsY58jbabZio+/FDOftFCB
 SOyjkObo
 xUX0zY9SNYkIuuGIulQ8BToPYdSI7srraHRDOlUOhHVxPz9PXVKf48jmAv2Az/M3r6D5TIinHI/pGSfesNP3a1j8cFGEL4BMUuVW/Zre64MkBhpNE8Ycex+qv+PeerYh62JxIxtkiJ/tIwz8Hs/mswmUvYR/hA5+jOqNmqkNpQfmm1OI6Qov3TdCVEAvxpY2iONt/Co8WKs4vkdJJz7e4sFbMKmxU5+iFQMsdVIxvU3Ev1rXtcVhoyVqOrxkhZqOK7jorH92HIyMLd/PWuCA2UaD2O17cnVtRNC4PnCtm/U8017UoKjJLSRA71+gM0csYOSpgTpXFO+TSlJggR4d/Pc0NocC5qOdPbMV00r3iMtyBf30jgr8rLTEUMaTDwiJAnyk//H26XX2s67+wXs1M//rXWh3Ko+WyI+sgeOb93osJB10gPKtXAE302Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 09:50:04AM +0100, Ryan Roberts wrote:
> On 21/05/2026 05:24, Alistair Popple wrote:
> > Hot unplugging memory on ARM64 requires a TLB invalidate after unmapping
> > the page to be hot unplugged from the direct map. Currently that happens
> > one page at a time, meaning range based invalidates cannot be used. The
> > result of this is that removing large amounts of memory takes a long
> > time and in some cases can trigger an RCU stall warning.
> > 
> > For example on one system hot unplugging 480GB of memory takes ~1
> > minute. With this change the same operation took ~1 second, a 60x
> > improvement.
> > 
> > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> > 
> > ---
> > 
> > This is an RFC, because I'm not sure the change is correct as it frees
> > the PTE page before flushing the TLB. I'm not familiar enough with ARM64
> > architecture to be sure this is safe, for example I don't know if HW
> > can update PTE bits such as access/dirty in the page through a stale
> > TLB entry.
> > 
> > If so this would open a window during which the page is free but could
> > still be written to. Likely the safe option would be to collect all the
> > pages to be free on a list and free them after doing the range based TLB
> > flush, but wanted to get feedback on the approach before implementing it
> > which is the goal of this RFC.
> 
> Hi Alistair,
> 
> This patch doesn't apply on v7.1-rc4 because it conflicts with this patch:
> 
> Commit 48478b9f79137 ("arm64/mm: Enable batched TLB flush in unmap_hotplug_range()")
> 
> which has a very similar performance improvement, so hopefully it solves your
> problem?
> 
> There are two paths which use this logic; unmapping the linear map and unmapping
> the corresponding vmemmap. In the latter case, the memory is also freed, so we
> can't safely do the range optimizaiton there since the TLB needs to be flushed
> before freeing the memory. But the linear map is the big, slow bit so hopefully
> it's sufficent for you?
>

I assume vmemmap path is for tearing down the struct pages corresponding
to the physical memory and vmemmap teardowns taking a flush should be
OK. It is worth checking if the issue is already fixed.

Balbir
<snip>

