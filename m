Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E1BC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 07:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D7F6B008A; Fri, 24 Jul 2026 03:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D646B008C; Fri, 24 Jul 2026 03:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389CA6B0092; Fri, 24 Jul 2026 03:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 091876B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:28:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 935E91202A7
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:28:01 +0000 (UTC)
X-FDA: 85022841162.25.FB3FFF7
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013061.outbound.protection.outlook.com [52.101.83.61])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7160E160006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:27:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bAGBznYi;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bAGBznYi;
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.61 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784878078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6V7yNqjLIr/nDC81oUF4rWd9PpJc7GXqTnBEwNyPgO8=;
	b=rVPx9tX6+Mti2wtF0f1vxFxyGYpvt59vvliAaLYdQHIOEhsYoW3RvkqmPjLHnQbqtLbY1a
	XjXhLs5wRnOVhnXJsQZ7ZMD4JSsadEssjGUmJJWwbeOmlI/0OCLyxJgmCZoVEEj9+IPSvV
	IMmShzpNpH/6UXN6khmH+dLxhdCwQJg=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784878078;
	b=sNaSHcqETLa9gUq+WxJ04sV/8p+X7d9tx+/a9IE9LJqyUjtohXMEIjruofOyQEaeJyASHJ
	/UdohdmMSg6ka3HqGuUKYZXhl9iVxXtd2jG2WOUVAa0Py6cOz5cloVGJqDNf2y0CdE/5Lc
	/ZukAAIsPxc4f5hG8ugkc7mQME63pP8=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bAGBznYi;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bAGBznYi;
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.61 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=toHmTB5Y6twRXX/6k/alUsNLGCjIoRJE5IpDiAy8zzoF8BSh48O1qwZ5nCNbEC8NpgTsJdX+IMpC7wE/lfJcKL5oQLGWfQ7fl90DMoFWiIkFjU8nyJru86PZznvS+5kQTnmy5rUGL1mqXu2TqNG3qTDSdk3P/fnlRJ7KmiqMSmkf55zxksmJL5Kl7BXY+zlq73T9fl5C5s87rotqTEYbPXc6gHfVnx++csBSNe10/pwTucs9ZRI4HI5aHeT9GeNxXAKDwQZbLXammhS5HvulkhzJvAkb0+3wOrpzU+zmX8LtzB6ZL2fDxKB+Odkt296P0KuCYtR/zU1thZZ9S6HSNw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6V7yNqjLIr/nDC81oUF4rWd9PpJc7GXqTnBEwNyPgO8=;
 b=W4CjyZNE4qPht4x6QlrMgTpEEgrqQ/qMcG8Y6LFHYjZXO2iTHepDGtSia6xALn/LuCSddsUpKWOfugUEu8f314cSkr1j8zj+UYorGA0qu0CXhXbaqNiz3Ujel38lFUmODxACMJJIrF/9EWctS0NkIvQC5EljZd6Gd8kewmU/QI0GKa/6z1afjKdPyiF231VOJCYLTEzeFIZLokhHw0O4ec9rQF/4HDx0/ErrJqDhdsageTwP4FVursh0Hfc8Ac1ley8dpd8ZBNdNcSbfTojYc1/dvIEZR5b8EpAjkLZNJIwDsYolOML0gzvpoq2+I4+4JzLS0eO1KBVJzFKSkJfh4Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=uniontech.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6V7yNqjLIr/nDC81oUF4rWd9PpJc7GXqTnBEwNyPgO8=;
 b=bAGBznYi5e9iw3hKJ1sipQptvFZLv/EfRgORWJcdrAewH5rwx7hv1u+G2NGr5qDYb2TxGnGlR80276RMA2CbZK61GY/ULi9EpZ0kuMjnLTcB3xLWOhYlrHYQ7YYDvlxiZDvS33zoRy7ldJDMB84xRj4eJfWDvO54/5QsKbGxmRY=
Received: from DUZPR01CA0047.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::16) by AS8PR08MB9767.eurprd08.prod.outlook.com
 (2603:10a6:20b:614::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 07:27:49 +0000
Received: from DU2PEPF00028D0B.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::14) by DUZPR01CA0047.outlook.office365.com
 (2603:10a6:10:469::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Fri,
 24 Jul 2026 07:27:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0B.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Fri, 24 Jul 2026 07:27:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=br5VIvv5KIXvJZAlAsQv1Quzy81sLNYztWgrgfy0nfAMNp7ZFbnt0Oo/0g44MFSNrRREmxOBG6Qq/Kmi4JmRfTn+y5+EUwr9H52ogrlZopn6vjzLWvJX76l29/Kc0zsRvOKns/hbfILdlei95XZNOeoD1rYTyj0ptQfqXTnRCkqlDY0HqrH06T1S2na5rSAZ5kuYp+jOIMCuip7OZB5k61dmzTX+Kyo3tGc4q0Yi1WDtBRBGJAWfE+/wEE8A6XS3EOKAoGJEXbMKGOsGSH2meC7cZkJQzq8pLPvDhD0Z9OqiE/plTJF6HCqaAaebSiRJSHoOfdmtScokrfjcEDIeKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6V7yNqjLIr/nDC81oUF4rWd9PpJc7GXqTnBEwNyPgO8=;
 b=QD2urU9YAIBlwyCEhiqgyfOIuNVgRGnNMANt0jCXmXrZTlOmQLbmXW5ElcCVdwpZ9ejcOsjnRc9WVismKY0CCIWi2pZiZJzyVbWvGWzBD4Bx/cOKZFcxQjhXNI21/Vw3x09TRn9ohO8FG+ugWAziwCzplI9FCeZGabuQjUb2B6KZqm8x7BPcYxo5Q0oWE6jhrRYWpJrc8Ag77T+8hH6c6pHQm5I24P9TxFLFhOR9aZudO24D6ByaZlnqToO7W4b3aMoMCqlG9IJCQw3acsXy0HDJQdOTn9JTEKIGY5bHF6SduuarazU1+T9ytZH+J3TRsf0kVjOdMlyqEoiI1eWSWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6V7yNqjLIr/nDC81oUF4rWd9PpJc7GXqTnBEwNyPgO8=;
 b=bAGBznYi5e9iw3hKJ1sipQptvFZLv/EfRgORWJcdrAewH5rwx7hv1u+G2NGr5qDYb2TxGnGlR80276RMA2CbZK61GY/ULi9EpZ0kuMjnLTcB3xLWOhYlrHYQ7YYDvlxiZDvS33zoRy7ldJDMB84xRj4eJfWDvO54/5QsKbGxmRY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU0PR08MB8812.eurprd08.prod.outlook.com (2603:10a6:10:47b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 07:26:45 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 07:26:44 +0000
Message-ID: <6b2f4fde-0da2-4c0c-aa97-f23982fb7e18@arm.com>
Date: Fri, 24 Jul 2026 12:56:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix gup_longterm EINVAL error message
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8A3ADC563A32EF67+20260724065929.1474539-1-zhaozhengzhuo@uniontech.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <8A3ADC563A32EF67+20260724065929.1474539-1-zhaozhengzhuo@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0066.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b3::11) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU0PR08MB8812:EE_|DU2PEPF00028D0B:EE_|AS8PR08MB9767:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cb2f76b-8eaf-4a24-c6f3-08dee955106b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 Z48sk7lBz5jV51S98VuWfvbhWRsZo7Yuz3U6d7Ic7/F/Ix/h9w8FeLkL8IxErGoJFWJg/GtZzC8zNwSvXpebNQONFfLZTDPjfpdm7J0ZtrwkbjoN+WUdfvHIdmi0p6lExu/2niXnZhIVyR5QMj48GW8BWfQStHs1VKNTZG13y31LONk0ZxxUgnnD8gXxlHYYftoFnm4ZJ/oWRBE5sk7LJ7RTj4NbiIMwREjCs5z+4+nP8SRfOXfmSU2a+ZuS3iP+i44u5JqBGdH5ZGeqQTakH9OjI3QNjo8NR/+a5247d8cY9m4IFf+3XAEPr0aySxArbKua/xxa2Z5WXus2CVG2yEQi0pzwjta53EyJVnqTiougz+15uBZWNpifdM6Rt5zFZbLTTPglFJr+C5tlQB99PKshS8lm9ne6dMIsADoz8jD6oB+r/s2J+u25la5xYBft5TD+VYSCGUOiRZYf0Dcg+tt8MAoBLi/RJVcyzZuc/mVfyfWwhbBLOQWSd9GugVE6f6IXeqHxaw6WOan4zTWUtp3q3WK3toRX1TwNDibdnrQp0wjJDaOS8gNQg5rlOiNXVIxRuaIDQr4KKvBka5p75xnG2CrbVkAYmbnDQsAl7Zgh5+72KUvjbnAo2TpjRV+J07Iu5NrWN0E3aclsmphu27xBn71xBg66PYvkMFkg3N0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 CcOL+SK2017Rk+mV1lLQOmfQeFf3CzV+rnAUo99SZzb12nR80zsX4fdmUVmLpbBCohcfZjKRQWr4qrKw79F8V95PL3bf4UTjTl66YHmzgZhGyvKXn/qwEnXL4kGPKWYw4nszb74V0xpXs1BGmZ8WSC7x+RPVvBsJ9XLh7YAE+HiogdVe2qQQF2lGodkJX/BOy7kyKefVD3cBu+P4AKZyEZcvLUTGPyfRZcb7qkeaEHOuJuYLkbmhu9NQ44tgaFmBIoPrpaIA0PqgIUaMhcxSz3oAbrXOxRwjxShY+noBvZ3PbWQ5bpIvDYDDMauqE18ht5z1u/gHgLaCie9zkDJY2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8812
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0B.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2ad7df65-4ff2-4285-37a9-08dee954e9cb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|35042699022|7416014|376014|82310400026|23010399003|14060799003|18002099003|22082099003|56012099006|11063799006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	1Acc2sTvcqO30+BGw+gQv1nfLEIITn+TjSH2TUzl/z9+703hEl9avypaE4Q6kpjVa6ILBcFTmWahBGpaimF5eOW2t+KcP3Fe4dNum0kZ0NdvP5vheToQdVwU+99kogrHfL4wBn7GCOSpmm3eYXWa0Gnaqlzl1M3j4JIuVVvavqhIgnvSkAxF+8N+RmiGCN1tCyqEFmGy8pmGEpRyIfeIBOLvJ4zs49qdmno3vM0xoy/i0tWkYZlKFWFDNixJ117+JBMYjbxxAMPR3exoXcTfzGsq/WQ5YSaNwr/Te8h3ErIE2ztbIBFkx+Nof0N7hdRbgK+5SCQCSFi3nnUNHkjuo9QezwRq4paabt2ucHzbpVTXH/Cn8je9p8pO9p+R4GLT2AkEkNoDYIS3KLoFxXFIPtyg7nGyeef77y0TmtwmEFIDngmVCnX4tYGogdCmZ+5/xGXZE0iMPNXlbgx1W1hO3dHv7Ne9DSJUQRlTELebt0/LMLRRmmAKo5w1KLnKBS69SMfpgnNofWaSgRV6TVv6ouDqvzd2Z97rhPydA7tyIXw4YNlkuDD/FF1tVZZuMU2blNfIsBx/lUtO9/MPu9NgP9VqkpxTO4dV0kz1X2VFE/H9FRBJ9CjFUc3pyO5EvIErulZWRn5/Y1EFwI6sBINUIJ1BnYv8jl6oFiNLRutUWQlfakkoe3J2fx82pE8DHDrP7zFYYf/PNZ21oO3zllIcLg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(35042699022)(7416014)(376014)(82310400026)(23010399003)(14060799003)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Dz4NcBf1kX5nnX8Ru7O24uCFpbFgACz366W+63X2GgKfJRtObbZ7Pjo51XiUCYYz1olp+7mWik9wxyVCE2sB0HD3YI1gQclMBnXkP99dgdQus0aE6aYuWqYMrijOcZWXo8ELKND2NSQHDosoTFdem1Jt3OgiPYe+1rmjFnBpe3FBh7vjsZDTlAfOhQh+UPCuSPye0gVSGmAG7+eDCWcp8bmdH5Gjy+HU5ZIT9BpEuZZ1hEj+vvU80tPEK8wVGcYQbFfld9g34Fy/GcewmVOrAGSWQ62yCeldLeHlxYYXrz7eWWWgDJTyDw1RmjgUb/L3vMR7/84OMN+eBJoKlLcpylZOMIQx+tXlgFW4197Kx6flLkYh2uviK6tYUdlyvY69OetppWheFcMf1grgrrjxyEFvYE0xFQzy5IOgb6yiz0AZyG+wsaV2QHL3oh91z6zF
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 07:27:48.9199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb2f76b-8eaf-4a24-c6f3-08dee955106b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0B.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9767
X-Rspamd-Queue-Id: 7160E160006
X-Stat-Signature: axafo3ofn74i6ei6iodamugu6jdy5c7o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784878077-482859
X-HE-Meta: U2FsdGVkX1/Tvr2PiM5PP6r04XfHVc4S/jP+F1n3sEZ+3vtraQe0orgN+GvnZVrViFzMby9s3UdjnRlW82yGqZkR15zwDnsnXoDP0yLo8BLIWYvCO67csjNSeqle257AX1tyKjipo5/OGtdgzAL/7poPPVE320ddISbIffwIRoNZDtUebhiscav3qhoUHhBD1Ntyos17opzIB/wGfIU41596H0bZ6eXxcovfDLSZo/El+dd5HX/34yaRo2pfJY+Nx+b1qNrsWAV1mb5Jb8oTx9ZEflyKPLmfTbEIkAdeASahrXoj4lkO3yaVK1MBQEYzDOeXqBqx+wBhgtvYTFlndKImB5lbLpRYN1BUiWPnIMvP2cPKObyVdTnHs8X5OiwSechySG9RnxYmBvgkIEg/gs/veHeiCoN4wy8d7eLVg+GrlAKi9KkpXo3dw5DTCuNhDZ5FWzEc9zIYSN2aZgOiQA+tKzNSV/JQE5+UOEiSvUu5sp25nP8OMvqaq/FFw33K5+AvtZOT/ED8qb1i0N+HG2izuXWg8CtnGzID7VrMqV7sCdV76cZOoIE8+q1QJvryCZoM4wSsf6yA8PlvYZ4v3Xzs3zcJSCOtBUFZP4CPEmdBXHGypu8U4A9RV+5BFShqn9KN83xUqQ2X9XfdYOgaTQXeS5OOiyT3nB5x/GyUf1VVW2y3ta6zpSVCMY5ZYRfZgeQ6TWNL1pN1qGxsEgnWT185J+jLIpZpBe71yaWAedc80/XFGT2DQXprHG+ikoyM1e010/oSIYGlqjd4AiJlpkRHP7+6NSz5A4hUJIxNF1UT0/aeLIAxEbGafvSJAhAsWNsRYqI7y8vu9SOYzU2bV3vmD2OC6DSBQQGpxjkkLEypb7uxryHVkUBPrB7X8n3mW9Xwvyt42LUTe1HL9IGpZx9hM5WcXtGoKgH97OqJxTJxFX6ZlNgVdl2navsOI8MMsDt6x2LY+0569KrB9p6
 6VrcAYZx
 ScycNu8ZxCFaHpW474Dcl/34wllGHiCR/J1dsBeLhOyVna/OsgBjrsJrD/IqGW4BNn8Zfd35f4W+P2zBamx9G7ckeFgRLgQtQwWcf0ETOFA4fBp+zHjNzGa51MgXnpJ6GU6nb7vUwhOcvd1IjDdMBfJD/t8oHq2GfB68FxQXVJKA+HNX502GCMY0FptfykziU2151rISaC07AueFDJgzsTYcDvzc2nSHWUyEhXXTwP+th7yUyvOPNrVW90zOu/NF292CNf0WZCDo9egWITEJjhu0NfDLZwi6t3Gbj5wa8poTId4KtErvdHll9dZetpI2aVOhLLfItevlBCl6Dt3VZCVGwWWwrZJAIMB0B0sMgiMRDqRObO8CqSDAR1mr22nvybKVdRlGRkuUXhXRBXzMTU0+c+Lbrf6ETi5YgmwuRiupr6x44ApPvdqYTPZA/km6IUFAFQ4AHA4lWyC3JrWRNhuxlEzTn6orCs2eaR9Fm7rr4v8I6k1Hb0EuC6AwPhVa4R7+D84+5pcq+25FOCQH2zJXDlTumm7oDLjSJpluOksmyklnOAAVEW1l0Uz/f8WO8wBJlTKOZK1HzHVFBwbUYdpDheUFq9Xh2kEhGUpSf5/zmcjeGfyZWNXLZbFF8OJ35sX0OularCrjSbZrApO4Mh6aJESEtzqxl2WPoLGvl2M5Y0b50yY1wvSPHgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On 7/24/26 12:29 PM, zhaozhengzhuo wrote:
> The gup_longterm test prints a literal "n" when
> PIN_LONGTERM_TEST_START fails with EINVAL because the string is missing the
> newline escape sequence.
> 
> Print a newline instead.
> 
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>

Can you add a Fixes: tag here? For this patch, it would be

Fixes: 800ddf3cd74b ("selftests/mm: report errno when things fail in
gup_longterm")

Rest looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/gup_longterm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
> index eb8963e9d..c03b4f891 100644
> --- a/tools/testing/selftests/mm/gup_longterm.c
> +++ b/tools/testing/selftests/mm/gup_longterm.c
> @@ -196,7 +196,7 @@ static void do_test(int fd, size_t size, enum test_type type, bool shared)
>  		args.flags |= rw ? PIN_LONGTERM_TEST_FLAG_USE_WRITE : 0;
>  		ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
>  		if (ret && errno == EINVAL) {
> -			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)n");
> +			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)\n");
>  			result = KSFT_SKIP;
>  			break;
>  		} else if (ret && errno == EFAULT) {
> 
> base-commit: c04df384b55dd9dcf72c36b661becb5aaba371a9


