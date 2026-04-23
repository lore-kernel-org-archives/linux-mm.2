Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB67F99344
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 08:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117B66B0005; Thu, 23 Apr 2026 04:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EED46B008A; Thu, 23 Apr 2026 04:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20106B008C; Thu, 23 Apr 2026 04:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0E186B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:26:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B65F612041D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:26:35 +0000 (UTC)
X-FDA: 84689139150.19.22A86A3
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013061.outbound.protection.outlook.com [40.107.159.61])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9837640006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:26:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=iFKy0svG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=iFKy0svG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.61 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1776932792; a=rsa-sha256;
	cv=pass;
	b=K/RPFyzKZuAfZPWJewNRwG8kL1+J/TTGYp3juz7mSXwUL1ueqe4awqEsYCBd6ithutByCk
	oE8qnko+bQ8LexcaLah5TVo/HZEeqIXX6ZEA5ALWQJ9baAX5deecGFi+rHlFmI0Dur81CR
	7t9MMTqlS9wqEb8q+sTdCDna22oKB1Q=
ARC-Authentication-Results: i=3;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=iFKy0svG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=iFKy0svG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.61 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776932792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W84IEXk7NWp9AyXIpRgNvDpD8EwrurhrpPNQQtaqYTg=;
	b=ApPftJ+iyPErYKRdzIBo3NIX9Za79k4ejAwbtUhNB+xKj4WcNqCB8nKlg1/k3rl+wlpvUZ
	7peK5f6C05OwXIuiy8m3UJwwVDIjQL0SpffAQvfAdqS4fZF0/XvswwzRewbXdAXkWrqeog
	fyMi6SL/1QO+LcslbPUeQgvaIVYKwXI=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=A+VGDrHk3mCefmnIXDpGPjYiy+ggsddU05jnlPABqhEROwWlaEdiEs2phTUqhMduyQg8pePvq76OCh+wRHJvQlXKgXzVWbF6RQRgA2A3K6gFVP589ofLH1BmtxftxhvUdUtOxEyN7MjXJszenMV98ayieNRi1SFFja3mN7vHOH8fdMT5HPcafX4xymMaWZUYl8BkntK+E5IdUNOrJDw5pJ8NJ6KcyMtZDNYFBcEXcELtWjwoHMiVq0b9hOeEadWXJBVgJAc/mlKG+SKlVu6YZS649BILhcY8TBRTG5d1Zr3C6/0rTroMCjLXC0VAK+xRbjaJi7BGhr3QkE1zY4iftA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W84IEXk7NWp9AyXIpRgNvDpD8EwrurhrpPNQQtaqYTg=;
 b=p6dPzPJtfbIZj3MWvLdLy3B2GOUCPbegr2RcWP10YmD+Y6w6O7gHL6AXepnsjB6qdg2wEWT6wLzbNyXREP+CGDZtG1aFbdKVwrrfWB7O5gAvKjJLit5qcrF57wnBExH8M36HvUITLjcTNPkNa8W0xXlteV9LAAEDVlp4QJ9uvzElwoqoCZl7PoVLevkvSZx2+/EU8+AA9K4Gy4rASeBZEqtA9UElDYoDQCmzFKU98OY6jzpy3NerOMKCD6mp1tpllh3XVAbgX/YUo2wGYzAktuj9jFSa/l9avkD+siecRdAe52h6R94A2fw+AF8tG9P5yXMzXlwXRYXb0LMIDSoGCQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W84IEXk7NWp9AyXIpRgNvDpD8EwrurhrpPNQQtaqYTg=;
 b=iFKy0svGktz7UHSKmYBAlCoKtXlb20nV+tOms0HNFEpJ5SaJxduku8ymYcJu2wq7JuKkZ4cc8gIakY2Otv7URDGMqv7pt5232Hw2MKqs5wvixzWXy3s0pcaRhC4AX900uxZtYr+gwY4jQBwYTlOSw31FalaWOU8DPOD8xtD4zis=
Received: from DB8PR06CA0053.eurprd06.prod.outlook.com (2603:10a6:10:120::27)
 by PAXPR08MB6448.eurprd08.prod.outlook.com (2603:10a6:102:152::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Thu, 23 Apr
 2026 08:26:22 +0000
Received: from DB1PEPF000509E7.eurprd03.prod.outlook.com
 (2603:10a6:10:120:cafe::e3) by DB8PR06CA0053.outlook.office365.com
 (2603:10a6:10:120::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Thu,
 23 Apr 2026 08:26:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E7.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Thu, 23 Apr 2026 08:26:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iO1m/3SWD7hOplkds4S495e4ZlmceBiPHfjCV/DuHlD3MjeA2SQPkauIg1NNBTZt3tHulL+T6uftAIrM1DrQTkqX5GhUg5AuUdBZHBiQEgVqcFy448ak7Gnhr1cdrtftyoSnQwq0aT0biF+3ivJuDl+RF0ZyZSY2+X8Zy/lPFo1N/+BV2NlIbvcA+h41oY7MBLKSvTkqCG8OpGWBHzlVGW8S4clITHQVV3gqRF2Eu0ZMITM4Oe6mE+Mf00GbWfVn+tBcIalrr+ti6H+8zav+SwA0ssxs0GFrwM80xxUWZX4e4sgrkvUZaT98hcVSJEY9/0WRkjZJZGYeFaKYAJMBzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W84IEXk7NWp9AyXIpRgNvDpD8EwrurhrpPNQQtaqYTg=;
 b=bmyLUVbSNaGyAUU7ri39gpCKxxj0+yaYLPICZTkFPECZhkYMfEWTa6BK5G3fjHbzVlvcAqdLxHavHPZuG9Qz1TyxpXgaakNb/LJ7oZ7Ft3nw/0SM3qNz46wFdezQQMWh2F9VCmNJrBFUG6mM6IlvJGtXC98WdMxxUbNXIq8/+fqaDRcVNN6q30VZOCM/E7xY/9IsADyk0Vj1OwJkEUrvHCFR43Mln+wFwrbofEgTZfycZzHLX6SDsCGetluTfnHE9VFQn/Uo9X0FQyxSvAIXVn4wAYg11ASFFxZ5ssCX825iLf7tKtgR/vhclhhzHwADnB0TxIx165DyiC0pQNyqjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W84IEXk7NWp9AyXIpRgNvDpD8EwrurhrpPNQQtaqYTg=;
 b=iFKy0svGktz7UHSKmYBAlCoKtXlb20nV+tOms0HNFEpJ5SaJxduku8ymYcJu2wq7JuKkZ4cc8gIakY2Otv7URDGMqv7pt5232Hw2MKqs5wvixzWXy3s0pcaRhC4AX900uxZtYr+gwY4jQBwYTlOSw31FalaWOU8DPOD8xtD4zis=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PA4PR08MB6077.eurprd08.prod.outlook.com (2603:10a6:102:e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Thu, 23 Apr
 2026 08:25:16 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9846.016; Thu, 23 Apr 2026
 08:25:16 +0000
Message-ID: <703f8dd4-9b23-489f-8170-e4c652991b97@arm.com>
Date: Thu, 23 Apr 2026 13:55:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/53] selftests/mm: hugetlb-madvise: use kselftest
 framework
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-10-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260418105539.1261536-10-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0190.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b2::10) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PA4PR08MB6077:EE_|DB1PEPF000509E7:EE_|PAXPR08MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d956b6-ed53-49fa-5d44-08dea1120032
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Es8C4UwQvSSDlxUMwuIRHdrjLXgYgVv6P0/UQe9KWerD36p/tlUIFm48uB1ggvNlqWg7pcOh3gxPbLwDlleSZf75IxRams/Z98oRzFJwMSpIrOd0FrAfl1/U6Gt3SBh5VZ0lg1cNbnXz5ByV0z4eKjUwmcfHWAeDEIUCRl8e9EuyIgS61EI4RyAosE+Gtq/TxnodY0pIR9ktUUlQLYr1GhtRIzGCZtl3Ku7sax/7HVm/ZH2LWgNvETsfGNf5lxCXUq2R0CYtxcIGUcAToKJ/U/3aGLirQRIBjhq4D/DolCbzoZDvpqvnyeQfhWdh7xcUOpO1gnz3pnOGdB3hKFZ4vDqXhjvc/ac6+OBQuY09FoqjpKWIVD0IuhEsgsov9H+GeNYrjw87v9wOIEJTagy/WxCSebTC2saTqID11JgMEXGTHAvQhaxvKrjoaaLdIvZBuiP7Cu1b9ov0ukPP+DM3tuNuoShw7floFd9ONZOLCe2TvZllDkbQdTLlOGzXt9Y7ApGephjnVKLvKlZ32AnWHMo+jVBPGa7WvUrDZxBmH6uawA7Bw9bC7m8XCPcw6cFF+5TjriKAKcx4kGgOGo3LwS8WbSRSncscUYhPtZDIysZ0SwCVk4LMk8Mjb8qzFeWVysTo9SfwnlQCvqhXX0c/TxhbTCLImxtkF428P9+udR7tutQmHFIvYjyo1hPTka5XJb3OBa30dmdTbgZvuyuOIyh4LCilP7HWgjtQBzyPsjU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 W3VQ5WR609GypCBLxn8p3l34lVz9a/W2SiECljwwk6HSlNGINfEKKN5Ct9LsyykofPm11usIS+xe5loYWtULxrL3yMj/xefyvzCUSAoYrJD0yo2CKn5WdWEgOyf1+1094G8NJ37Ykg1Gm5Wa37QS5CftEj1W13VgWZd7A3M4MmlZotpZ1JOKK0G1fkRefbfoceLm4t1+AO/LcAIxyyxHh46tO83kw3J06vSlkFPqc4NV4NGVjSwpQhIF9tMkJoaBsRiKf0ShDpnAqdO7T40NVzt8pLpC7+lt7HE4AFVW9PUqsWNXYcGh8qVWS+u4dYiaznkjmRuzwmSndQ8F6xUxCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6077
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E7.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	64918722-86a1-4c40-43a3-08dea111d911
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|36860700016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JLTENGdJjc3/vblhkOjO5FGl1LsOh2HTPN6u4vh0UG8oD+z6L6xwIMPz93da3SItPi+FFfLaZM4HSIgp5BR//kQhaHpnIeZaSxbqr7HKUmXJOFGbw2bAbIzEcVrtktY/nye+NF/OxBAd5HoIoVACooi8qjfSJOcbh3fNGzgu3rp64pDoxiSViMHzOtmOy7Whhe62U19Z4y7Td7te2BSJUUyMV/je/B+TLwWaJoaEdYs825ot7+yc6CbYKfbw5BXeDv64Ycda0KVs1T1uftME2aWGmE+Chw6lx03czheMWkIGWhgv9a7zTLJ4jyfxq8xNJo/r+1eTw/NANUQY+G/ZY63VGdF0EqdkShRXBptDwpbSbVzm0TK+orhvVpRp0nwqzJwC+Nh5G/t2yQbkgChoQkvLmUzSdN5isVrEnJedJE1ehXhJOLyug0ycBWZ5LnHXs5ievID7UYZC+TZkciGzhbWbSpxUK3JHma8gG6crvRFN7YueN/H5vzMADY9ZxTKlWX8WOJfL4vy1tEP16tS5KvH1J8y+vDIx/pIFzozpnKnkADzT44HfDitcSG4YLRVDzYqC8SRSod86vtxOUxY5X2wrebJ31I1AtqE9zq0eSDuqjtWO5hQCXldnNKKT0JSquo4QM5A+F16pBNKdKAyy00CzWOsV+FufusItP5MaVT5lWsAPTsDMptk24FkdDM+PaB5FTW5tNkDpFUjCmD5uENEy71+I/BqGPcB1jqAyAZoHArdl8/hSaMWSt+jk/CfBy9XZdQ9MaUjIHldpUgbotg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(36860700016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bX4JdhJ7iWEovIdf9m8Mr9QxUjfsfu9K8oQ7WCm0JATepGfF9Gtou9Mknr1RCkxPCntlTVtwCaG2ygJHAcghAq+r58CjB9SZmzinjohapvgOVTR56bXLQ0fDNSOgN5gXF7sTLR6Q3JJzsp0I07JIwCcqwS1BBTvQWrGzKtUHi1v+JjlWsSk7tJ3mlPd9xH12vODYnzPbMj8DEFj1ubKq5qNvoWjPNh0cWal8sb/fHekKugLEZxHbFjezFIg32X5tI97Fjs6BK1VBsMbgTIutfUQk7f7x2c1afz0aiEv8vDyzkD9uKOQ+cThVl4hl2UdYhZ/ZOB5QNdaAVdDE5IsSs/sfkuiWYS2lB+tzq12wOFigaBN6ucculAhutl4u5d2fIWniXk+u4A6mwxFoKSDm9zWDM8SJdyWSpBphia0S1wlG4ESqCTOBx5Xp5C8WhNDO
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 08:26:21.6801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d956b6-ed53-49fa-5d44-08dea1120032
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E7.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6448
X-Rspamd-Server: rspam10
X-Stat-Signature: nxzetschf6wax6axxwizcois8j7f38qa
X-Rspam-User: 
X-Rspamd-Queue-Id: 9837640006
X-HE-Tag: 1776932791-741675
X-HE-Meta: U2FsdGVkX1+/PnZfeQPz8B+a8vxncjDfChGD8fVhOt3pzTJf/NAW1bhCU4EcHoUInxZ7BG+z0lfAF6T3x8FXfr1UlydykID50Z1NRDRGjRKTqgh5DMeAiGwFBBB/QYrWrk4e7k6Q8rZlnT+geIRZLj2B3XCCiPNLQfEMEc+tEBfi7HYfoyz5844E1jEj4xzyBdLPSY7zQ32C+WGOshA7OonAFOEpNnQ3og9+q5YjzT0elr95NzfDxsNbY1aoxzhASXlDzCcxmbG3QMs7/zEmtKzQmiix/FuKnudAlxJyHy5tKwfP+WlnFZad7Dk1AS2j7xJPXSbP/GYkIxLo+Gul+DcY9Hodx6bSD+zdpkt7WVvIFzcrIiiz0Bi5NTjSp2dJu+4SP4U0kiotF4SOcBo5HCcp1CmmAv7u3SmT/obQxlLw4jJ+3mm6O7PrxrL2qmAxtxMT/nsa4hObksfvo9laQIws0Qu09Mxgq5BAf6NvB3wKPhED8xYxEaL5S7dU0WVO0rzrPqNDa+zoGyRbQGNOVTu+biPWi0/nrPNkzJsYXgTgIMu4c7aj7gvO29Tv1+r7MY9ndwulxzrzTPQSZm15k9Lv9eAR0uzPFCDvghZfXPmq+rNAvQGoYAi/EsxpWhBCbs25J7tpfIhkm9g4PJgSno8f8EDo8s6krPjrIZBbXKQJG8slG1fIlI3bvtg8LCpI8UYhbmIIQ02nggVNh+PykX0rWoGBFWAao10VObW7sq14xil1LiK1SGwE/QZXUrHdcARz0R/V8EewOJHFpv59UL5enMaO/DCFQtGgJPDjWCulhpCjQbkf95Yv2NKdJFTCIkoyT2SjamleQd9SxTLaRB2ZqMMfEQSkBLBXdWBDZZh9CwHp7jpheu/flizPIx2GMNsD+K9GcAK2VgX9b7PbsdWxjbbgL0AjTrRrLdCKJ41aZ8hSQFAXtn3un8JjLr2krDtMGkR2QSMTa/JZqyc
 dyuD3KUc
 WI5a6yfioC6Wf1nFx2VlKdCkwpsLR+d56pdB2OPLVMQfNKhokwpIoW7IejoFjDJ0XaTRKC+0Sylqn11fhZNDTR5Pn0nummhsvlWyQxybaSz341wUy0hceZOKcDoz0zHKRRvKwGfwhVmQTHWT9eifq9AtnPA5lAybFKwV2zBCNpgr1oh9eWDITW5Xy5YXQfUEiksvTgjhSVLqsiDsl13nOt+guxc40M0+65/7R4oMjLyA9jkZIRcAT1mZwR+mqXj/ezI/N+tlSfrnNlvlsnvwTjciWiHetKn5I1PkYF8lfh/7i7HC6lf6h2fJEsrUAGb5bWrkPHJ2fA75MOl+x1H+ZQIsr9R3vI43IYQ3U+zkvC5Afh8j+745E8OnYMwYQSSsoSwLMnmvdasH+XdWmV09FPpzRCnSFUm7cfII8hXdCO6+wsC3odHTuUDxfDZ0eiUHQHEcsGHWF4NFyf+N8AS2bSubcTOnypmEGFiz2Z7kWUqHyyeWE4z8luF2Be1bYeNzk560/FzskpDivJlySmxeg0KuJoroA8ZlknTkJeQrZKaJtfdq56J/+7RHMseY1xCkA56oTQRb3i314h6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/18/26 4:24 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert hugetlb-madvise test to use kselftest framework for reporting
> and tracking successful and failing runs.
> 
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I've run the test before and after applying the patch. Before the patch,
the test exited silently when no errors occured. After applying the
patch, it prints correctly formatted KTAP output.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/hugetlb-madvise.c | 204 ++++++++-----------
>  1 file changed, 82 insertions(+), 122 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 898cc90b314f..4c6c346a3af5 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -26,12 +26,11 @@
>  
>  #define validate_free_pages(exp_free)					\
>  	do {								\
> -		int fhp = get_free_hugepages();				\
> -		if (fhp != (exp_free)) {				\
> -			printf("Unexpected number of free huge "	\
> -				"pages line %d\n", __LINE__);		\
> -			exit(1);					\
> -		}							\
> +		unsigned long fhp = get_free_hugepages();		\
> +		if (fhp != (exp_free))					\
> +			ksft_exit_fail_msg("Unexpected number of free "	\
> +				"huge pages %ld, expected %ld line %d\n", \
> +				fhp, (exp_free), __LINE__);		\
>  	} while (0)
>  
>  unsigned long huge_page_size;
> @@ -57,28 +56,24 @@ int main(int argc, char **argv)
>  	int fd;
>  	int ret;
>  
> +	ksft_print_header();
> +	ksft_set_plan(1);
> +
>  	huge_page_size = default_huge_page_size();
> -	if (!huge_page_size) {
> -		printf("Unable to determine huge page size, exiting!\n");
> -		exit(1);
> -	}
> +	if (!huge_page_size)
> +		ksft_exit_skip("Unable to determine huge page size\n");
> +
>  	base_page_size = sysconf(_SC_PAGE_SIZE);
> -	if (!huge_page_size) {
> -		printf("Unable to determine base page size, exiting!\n");
> -		exit(1);
> -	}
> +	if (!base_page_size)
> +		ksft_exit_fail_msg("Unable to determine base page size\n");
>  
>  	free_hugepages = get_free_hugepages();
> -	if (free_hugepages < MIN_FREE_PAGES) {
> -		printf("Not enough free huge pages to test, exiting!\n");
> -		exit(KSFT_SKIP);
> -	}
> +	if (free_hugepages < MIN_FREE_PAGES)
> +		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
>  
>  	fd = memfd_create(argv[0], MFD_HUGETLB);
> -	if (fd < 0) {
> -		perror("memfd_create() failed");
> -		exit(1);
> -	}
> +	if (fd < 0)
> +		ksft_exit_fail_perror("memfd_create");
>  
>  	/*
>  	 * Test validity of MADV_DONTNEED addr and length arguments.  mmap
> @@ -90,16 +85,13 @@ int main(int argc, char **argv)
>  			PROT_READ | PROT_WRITE,
>  			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
>  			-1, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
>  	if (munmap(addr, huge_page_size) ||
>  			munmap(addr + (NR_HUGE_PAGES + 1) * huge_page_size,
> -				huge_page_size)) {
> -		perror("munmap");
> -		exit(1);
> -	}
> +				huge_page_size))
> +		ksft_exit_fail_perror("munmap");
>  	addr = addr + huge_page_size;
>  
>  	write_fault_pages(addr, NR_HUGE_PAGES);
> @@ -108,20 +100,14 @@ int main(int argc, char **argv)
>  	/* addr before mapping should fail */
>  	ret = madvise(addr - base_page_size, NR_HUGE_PAGES * huge_page_size,
>  		MADV_DONTNEED);
> -	if (!ret) {
> -		printf("Unexpected success of madvise call with invalid addr line %d\n",
> -				__LINE__);
> -			exit(1);
> -	}
> +	if (!ret)
> +		ksft_exit_fail_msg("madvise with invalid addr unexpectedly succeeded line %d\n", __LINE__);
>  
>  	/* addr + length after mapping should fail */
>  	ret = madvise(addr, (NR_HUGE_PAGES * huge_page_size) + base_page_size,
>  		MADV_DONTNEED);
> -	if (!ret) {
> -		printf("Unexpected success of madvise call with invalid length line %d\n",
> -				__LINE__);
> -			exit(1);
> -	}
> +	if (!ret)
> +		ksft_exit_fail_msg("madvise with invalid length unexpectedly succeeded line %d\n", __LINE__);
>  
>  	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
>  
> @@ -132,10 +118,9 @@ int main(int argc, char **argv)
>  			PROT_READ | PROT_WRITE,
>  			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
>  			-1, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
>  	write_fault_pages(addr, NR_HUGE_PAGES);
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
> @@ -143,19 +128,14 @@ int main(int argc, char **argv)
>  	ret = madvise(addr + base_page_size,
>  			NR_HUGE_PAGES * huge_page_size - base_page_size,
>  			MADV_DONTNEED);
> -	if (!ret) {
> -		printf("Unexpected success of madvise call with unaligned start address %d\n",
> -				__LINE__);
> -			exit(1);
> -	}
> +	if (!ret)
> +		ksft_exit_fail_msg("madvise with unaligned start unexpectedly succeeded line %d\n", __LINE__);
>  
>  	/* addr + length should be aligned down to huge page size */
>  	if (madvise(addr,
>  			((NR_HUGE_PAGES - 1) * huge_page_size) + base_page_size,
> -			MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +			MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
>  
>  	/* should free all but last page in mapping */
>  	validate_free_pages(free_hugepages - 1);
> @@ -170,17 +150,14 @@ int main(int argc, char **argv)
>  			PROT_READ | PROT_WRITE,
>  			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
>  			-1, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
>  	write_fault_pages(addr, NR_HUGE_PAGES);
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
>  
>  	/* should free all pages in mapping */
>  	validate_free_pages(free_hugepages);
> @@ -190,29 +167,25 @@ int main(int argc, char **argv)
>  	/*
>  	 * Test MADV_DONTNEED on private mapping of hugetlb file
>  	 */
> -	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
> -		perror("fallocate");
> -		exit(1);
> -	}
> +	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
> +		ksft_exit_fail_perror("fallocate");
> +
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
>  			PROT_READ | PROT_WRITE,
>  			MAP_PRIVATE, fd, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>  
>  	/* read should not consume any pages */
>  	read_fault_pages(addr, NR_HUGE_PAGES);
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	/* madvise should not free any pages */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	/* writes should allocate private pages */
> @@ -220,10 +193,9 @@ int main(int argc, char **argv)
>  	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
>  
>  	/* madvise should free private pages */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	/* writes should allocate private pages */
> @@ -238,10 +210,9 @@ int main(int argc, char **argv)
>  	 * implementation.
>  	 */
>  	if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> -					0, NR_HUGE_PAGES * huge_page_size)) {
> -		perror("fallocate");
> -		exit(1);
> -	}
> +					0, NR_HUGE_PAGES * huge_page_size))
> +		ksft_exit_fail_perror("fallocate");
> +
>  	validate_free_pages(free_hugepages);
>  
>  	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
> @@ -249,29 +220,25 @@ int main(int argc, char **argv)
>  	/*
>  	 * Test MADV_DONTNEED on shared mapping of hugetlb file
>  	 */
> -	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
> -		perror("fallocate");
> -		exit(1);
> -	}
> +	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
> +		ksft_exit_fail_perror("fallocate");
> +
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
>  			PROT_READ | PROT_WRITE,
>  			MAP_SHARED, fd, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>  
>  	/* write should not consume any pages */
>  	write_fault_pages(addr, NR_HUGE_PAGES);
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	/* madvise should not free any pages */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	/*
> @@ -279,29 +246,25 @@ int main(int argc, char **argv)
>  	 *
>  	 * madvise is same as hole punch and should free all pages.
>  	 */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE))
> +		ksft_exit_fail_perror("madvise");
> +
>  	validate_free_pages(free_hugepages);
>  	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
>  
>  	/*
>  	 * Test MADV_REMOVE on shared and private mapping of hugetlb file
>  	 */
> -	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
> -		perror("fallocate");
> -		exit(1);
> -	}
> +	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
> +		ksft_exit_fail_perror("fallocate");
> +
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
>  			PROT_READ | PROT_WRITE,
>  			MAP_SHARED, fd, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>  
>  	/* shared write should not consume any additional pages */
>  	write_fault_pages(addr, NR_HUGE_PAGES);
> @@ -310,10 +273,8 @@ int main(int argc, char **argv)
>  	addr2 = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
>  			PROT_READ | PROT_WRITE,
>  			MAP_PRIVATE, fd, 0);
> -	if (addr2 == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr2 == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>  
>  	/* private read should not consume any pages */
>  	read_fault_pages(addr2, NR_HUGE_PAGES);
> @@ -324,17 +285,15 @@ int main(int argc, char **argv)
>  	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
>  
>  	/* madvise of shared mapping should not free any pages */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>  	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
>  
>  	/* madvise of private mapping should free private pages */
> -	if (madvise(addr2, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr2, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>  	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>  
>  	/* private write should consume additional pages again */
> @@ -346,15 +305,16 @@ int main(int argc, char **argv)
>  	 * not correct.  private pages should not be freed, but this is
>  	 * expected.  See comment associated with FALLOC_FL_PUNCH_HOLE call.
>  	 */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE))
> +		ksft_exit_fail_perror("madvise");
> +
>  	validate_free_pages(free_hugepages);
>  
>  	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
>  	(void)munmap(addr2, NR_HUGE_PAGES * huge_page_size);
>  
>  	close(fd);
> -	return 0;
> +
> +	ksft_test_result_pass("MADV_DONTNEED and MADV_REMOVE on hugetlb\n");
> +	ksft_finished();
>  }


