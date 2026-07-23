Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB4FC4453E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 06:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1A76B00D0; Thu, 23 Jul 2026 02:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188B26B00D2; Thu, 23 Jul 2026 02:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B9D6B00D3; Thu, 23 Jul 2026 02:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF50B6B00D0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:28:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67E5B1A03B4
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:28:39 +0000 (UTC)
X-FDA: 85019062758.25.C6F4F8A
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010061.outbound.protection.outlook.com [52.101.84.61])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5EA4B180002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:28:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=At60qj2U;
	dkim=pass header.d=arm.com header.s=selector1 header.b=At60qj2U;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf06.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.61 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784788115;
	b=pVc64bUuocmn8l/y6zS3fRedyCU7iSieEuloKcP9D66YC9PXuSLyV05MkmaQ+VyxcBciLh
	PB8IhK2jMgGtGhrp7mzYfV+fNJyTsmZK7xrOn3MXEjfsgNnUWH464wLGyyzuU4UcTgYX9m
	hlU9sCIh25WSqkIgh2Nuk3UGf1rU3qM=
ARC-Authentication-Results: i=3;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=At60qj2U;
	dkim=pass header.d=arm.com header.s=selector1 header.b=At60qj2U;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf06.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.61 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784788115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUEry8XzwOFbY6krDO/7d3LbVyl/ZtnNBqtx+/tFO3A=;
	b=GY9Mp0vWiHpLafrylQItW0bKzSi9aRGiuK/4T340OzYqJy2PH39cftVqQJzmZH9jFdDNk1
	58d88BigrAYOs+g9QumTaWpWdq5pgfGzLKzvyjKMrKuWrJroUkoGmxbVUXW8U3z5xQ2naa
	VjKSIpeVhpqx0v7QX9DaGksXMLljIFA=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HG3BPJO6kdKfrsb19lL3uCGVTb8gNkzmoVv15hof6H/tTVojeFuxNOL+hhhwoj6kvOBIsWfRSvMX/belWzZKxcWT/nwizY9TgXC27k45+4vG3Q42l6zIyd7y3w9zr04PxocyfjtmPfTDr3kPMo0h56C70WGzHYfwkCSz5tpMYJrynLXH9knibjBstPpHs2v+aDwVslDwr2OzkZ2YRbBZH2hLN51roiJQuKhk/1r3ABXBsq0ToDMc1u7QzbNRFQ5Gg2kBUylaGsWZBKbzIttQy8Hjtlrlm21kBoe6RMERH0BERL1TLz0WkzndcNuVDSGJuvyxSK29SCHsWzr9Omb21g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUEry8XzwOFbY6krDO/7d3LbVyl/ZtnNBqtx+/tFO3A=;
 b=bXxjrorFedaktq2/vQbOTMlKim9+d9doH4IbCV58D4UsJXgiSIvsN/5ikXH/2zCqmU+YV0J9xZ5Uy5e8KslbJUdUyryhUYZvxNSWT0C40oGKYBcgD80vU8m3UBxADRLiD+0RcxWqd3+jyGqgno3k2AalqkuRmHdqYQnrf94pbtnenStBR7hmRgIL4MIUMvktgcpqt5dM58s7aFuYw4GiH6nvgwIgMjSvrsWo+gRmILS+nBBbrr/vkNwtjNg7M3BFd3iN8VytDGZ25JYb6VDbeYaz+rfpIBsawc3Fq+FACWsOm7mxbqxFelUsPxrXq44PDo6jCa5iMxvkJpojzbbMzw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUEry8XzwOFbY6krDO/7d3LbVyl/ZtnNBqtx+/tFO3A=;
 b=At60qj2URuurdFFJOAe9J+6pleBH+qI0tS/8eRtcK/SeNVJCJ+V0JlegxGe6nvhuH8sjgvCO1UwcBnAvy8abjZJgDmLDijXLEIkmDVsBNHn/irfJQjBJQRwZv3LE4dGMcksPw9KOwBFPXndGxWYjw9RPeuMYPKwxuimjF6WdVl8=
Received: from DB9PR02CA0012.eurprd02.prod.outlook.com (2603:10a6:10:1d9::17)
 by DU4PR08MB11214.eurprd08.prod.outlook.com (2603:10a6:10:576::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Thu, 23 Jul
 2026 06:28:29 +0000
Received: from DB1PEPF000509FE.eurprd03.prod.outlook.com
 (2603:10a6:10:1d9:cafe::9b) by DB9PR02CA0012.outlook.office365.com
 (2603:10a6:10:1d9::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 06:28:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FE.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Thu, 23 Jul 2026 06:28:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vIPD+iKJrBVGueUXGPHAsFI4TB8jNrn3Ic6sRPre6OVpJP0E6yRfHQpgV4d1Hf8UWM9Ybs6kun5eWpG503khSs9bLTram39HHd4Cl06Obs84VAS7cqLtvUiv/3Fo3pNb1Ed4FMsEIMiNw7yF1Qkd+gg2pyd3cfG0lAszNv40bZ6sCimyLh0TH3nVDq0SPO+Y5Do0IGqWTgFczozXMuMCEJgk+8ckTL3p0FgtLKEmD3lAJf1WMRvMruxYi75g1iaRefQibJ221OPqnZtcBgjtJJ34JcCb6tkMAuZtR+V/dkARxCyPDUQYFNuX9jDAsdf7sk0/aCN2OsMSLWpApF5sAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUEry8XzwOFbY6krDO/7d3LbVyl/ZtnNBqtx+/tFO3A=;
 b=VEV2C80DSmlZbnJjit9jN6D/CUdd/+eRyYg32Y/nAE4Y1f7hRBW1N+nma8B0UDyyZplqlkVL9NQnukl6741c3jon33gzAcGD4Loeg1e/f8Il4XVWki0EpkF2t0240Y8ORXaVJy8Hs9D3BKWBaGinRl1gPFcWkBaN+oJiZHz2IwXW2tp4tB2gEBj5nwqmSfQHz6HOr5jG55JjWh+Bt7x7uoacVCvvEOZBK+sNucbjdIQcFAMmASjmYDRzBtsS8ZyMgl0kcJoNpNfR2zMtc885RB1H0ysj+tUJtMJt8BXtGYMBAHykddAV/tLvWyK846fLt2noPn4ytX+g3J0LW9x0Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUEry8XzwOFbY6krDO/7d3LbVyl/ZtnNBqtx+/tFO3A=;
 b=At60qj2URuurdFFJOAe9J+6pleBH+qI0tS/8eRtcK/SeNVJCJ+V0JlegxGe6nvhuH8sjgvCO1UwcBnAvy8abjZJgDmLDijXLEIkmDVsBNHn/irfJQjBJQRwZv3LE4dGMcksPw9KOwBFPXndGxWYjw9RPeuMYPKwxuimjF6WdVl8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU4PR08MB11077.eurprd08.prod.outlook.com (2603:10a6:10:576::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 06:27:24 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 06:27:24 +0000
Message-ID: <76099e04-7494-4c3f-b8c0-16f189508ed4@arm.com>
Date: Thu, 23 Jul 2026 11:57:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v1 1/5] selftests/mm: skip COW tmpfile cases when
 fallocate() is unsupported
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260722091219.61504-1-usama.anjum@arm.com>
 <20260722091219.61504-2-usama.anjum@arm.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260722091219.61504-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0354.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:219::8) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU4PR08MB11077:EE_|DB1PEPF000509FE:EE_|DU4PR08MB11214:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ca1495e-cdb9-48b3-769b-08dee8839c32
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|921020|6133799003|56012099006|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 3sE/ufzCz9FcnPzm41HFC1WYmFaFhyYSy6wVr+gyPTOcB7/EEUCjjpD6xp1YxWtnS4+WPbl8TNWxln+GgniA/SIo72QiFNdLCWsuQZthqpkLQSKWNywVltvCxOTmdJYO2c6CnoSpJT++6+JX0LzZD9nM1h3fx64FRyPeDTHrWaidKCvbAJ7KfNoN7x4kkm7ujp0wYPrXp0mrNSt8073x3gNq3beSiyhuyPu7Q63EDM9taDUnSOJ8oqydSWBqmPQBNLZeKZbdCA6oWV13E8qaS6q3k4nMxUPR3OYJLIxTJKtQGXv0JAIhr3U2eDNOjC49EYJhAjTd4iNTZTOAa7nkRxloJdx/x/WDB+ZH0plu4Qqq1NxHDiOv4EIUhk5CaA6kGBkJBnCijOZPwsbztnoWtItCoYBVssOUHPHoPqeLI+96sjxdKlIiLAlHSHiIlghhDQ9zmpNIY2lhr+5MzP6k5SZgLJHM+bz7JEyHt99zOpVYjA4+8sONBbqnSlPqXVwtZ4V2D+1LW1JLo52JtCJ/YX/sL0X9FcxlMgicHooYKbR0B+9DnzFKZeFgL8XPEcu2gNGM/YoU8PeII6bGmDXnIQVUnClFt718c7P30eehCBiN8n1DLTrMFLwirqecYYMt5vy4BFjiXfuthx5AbhAuconHii+nVuJaUOkr5sruQKb26U3PClZZypHug5NRbBZTpky9/IKipCNub24xvFr7+g==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(921020)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 AI0Ans+xYWrvf3Z8cFwst9ezGTkQcmmrEpDlJhd9mr27+TiST/UgBxeUWkjcUboSXWcfczGzLt3q13gJBUvUa5aGjAJRtNdRoE6PglPGGC4TTIUbW6imxD9x3wgml4TdcSojHczZ3yWQujuLthz6PAMtM9phmI5HgWbXBAorCI2QZmyooEJYdVM/aoedQ0y4wL6mwV2DhSqp4VrK9UgsmoMiN3U+du0GoDQFfCVyFrHIhlFyrLtbPtjY91+c3esm+X0mgJDY7iEjoHcqWuLwBN3xiQhR/muEsLUuUnyU6hkQ9NRzWih7JgamLCreYSJ+6+73GCGdKCKOmRgmQbzB5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11077
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fc999dc7-1508-4264-f69e-08dee883757c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|36860700016|376014|1800799024|14060799003|35042699022|6133799003|10067099003|4143699003|11063799006|56012099006|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SEUL0V24AQDTXXsCbu7ZUGGiQq+36fZbYXaNf4fQFkpyqjfIxVbUhrYsJW+ENEvDTG0LX7l4IsJKW5i+kh8n0OpPn/QbdaAt4C67pf2JtHc0mN66n1HsbrFKs+4AcwciENt1GhUq67b/SlMm09+B10t/9x6pkYCHGBq1Lhgdemwb1kZ/PXTW+C/BF6+7pEFxpbPVDaAVOtz6TDyjCQNI73GUaQeVfYIsJssNuNDxaa/A6CFwiQ7H+sLiOZswU1ruFMxcwXooevHtkZ/VrmWoRia8dpuwgRoHPEUwFKEeSIvq/SLF24XNMtDPscxC/LfAeGx1YjuvKOTkPnUtrkq6wD8XmYE2ZV8xnC/YfhbD+ma1ggkk8IyJxSHzHOzpXuTZGZYvLYdOZki9dmEp+1l6yPorv0YtakOg1VIq9e9k+lx3/BtNbKeax0tLzrAv6SrSB3QO2s9s1WmljzWo5zlu//c+uMKbGorU2DxdKyEQMUTys7d+/OhHjBw7/ib/XroQAUJH3Lo7g9qJzT8VWj3ZIxgWHOTHahy55fKdeU9UmB7MzhtKKLU5SnKlSMKXNwC4AMxuEUzO1+yNlf8O+NUj+o84sxJxK9CncpP/EK2/pGa91S3bp2gswrJpOnLqaeC+rzFhzI16d7ginMp/RpQ4X2KjWbrqq9/pB9asJvjJJf3/C+zO+fnCKOCtENz0fOuMJb3TQbUZzigJamh52BFf5xIVmmMP3ryF5Rzl7Gk10ynCeSJ6dB2Q/0X/kkZ1BqmS
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(36860700016)(376014)(1800799024)(14060799003)(35042699022)(6133799003)(10067099003)(4143699003)(11063799006)(56012099006)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Vnto0B3/wvuHW0jJgajYrtdnGb7dmDFxHw2CQZ/MTJLctJkodvqWFEmrWhJt+xMbrKAYGOJKIE9mQ9xe6a2Pv65amx9LXzu4AvETNlpHicUetJRHEK+TZHgc7cZ5bpDpcrVF+tm4NdJcJvYxe7c4WcsLzSYvTRgUJSR3xGHrsXYClkNS4YuAOGbC+Nm9F10719T1XysErUnlb2L1QW+/ZwoegbXcLsm152LeL9X66CzvbICcwT5xBCyJKaHoW/JWhgxUaRjrs7GpjvaMkrQyToJxll5AlEtzC+vxIYVDQjEJ4quOHKPWpnbDtU9aYY5mbGfnxB8qSnRrj9XdKVWBFvkMSF308Zq6DVNPih9xEjekzESUvJp6tzhZyVePd6T0MA1GmyLRDupVloRKIVrst7HxZVKWObISV7TNtKSwIT/G2J6zZQE3gzlnQrYNVLvl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 06:28:29.1106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca1495e-cdb9-48b3-769b-08dee8839c32
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11214
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EA4B180002
X-Stat-Signature: ta3j87688x4m9abk7f9jgfj4pr5b4rg7
X-Rspam-User: 
X-HE-Tag: 1784788115-802731
X-HE-Meta: U2FsdGVkX185r2pmFnPJ4MAKEHe4P0eKVLRbn3fqQOWx+/2qMIqesFndAli3WAvrc8yoZXEJxolxDqUsLYzQrcLetuJzza9HGXz0s90xEzcPM/CYfiQ1x9M6EKM8mowvb/odTtImyEPVQsBMJR/TzH6Z0j9yi9F7CZQ+kH8pOUuwZd3Ga63zIwIGSTWPUk1D6qMU3lvHKkWott8mmvZcRCE6J91bXp620TgQRu86MYwaHdW0Oa28u+VvQZwLWjxhgkQcnLe+dJ0lgXxob973bv2tS7W0kDvVXDoi6ayIlWFn6RF0ZY9BuboCENsEPZbOYm+36LXOAEO++U4T1SuFFoozhlrYrqwrdlIGl3E7RB39vcWZrZPIZvGCLk/3p5d7FCpEEGc+32qS5HlSTtQ9CTm/VUh8IoC2Y6s9KvHbdhqfsEEUyOgAfu8X/5gu+SHotxYD9TNoocy1Vii/ZwB708mkU8UgIKGIlOwnceyePlevbN1gqkYp6BBFnT39IcaJY2CnhwB1HGWA1brtKKucxV6oPbBbyb7cBgVwA7XiIyWz42+8WvFpfaK6ENViAWj0rsX2WngfKMHkr3kTEbXfqPR0LZeSgRiWFklkjjrltrTroLvffGLOCcZJPe1UhneFlkAmQJGiCTZXiHL3HLFRU6o7s1BlaRMV6HlKNNpSdK3Zs4fwdhSSieqWMn4z/4nueJTnB8nH6mGRZGft2MHi9k7vqSSDDkf8d+Bj/FFEmEVGbNtzbzK+Ihc17FLWZv/rsRjcQIZIPsGBHG+YB2QAER+4IiIBAeto6fSdg94fEEv7D3apObN184806DzjrsmuXImMWao0IssBd4Kvmy/grVXZE5oHkY4IJ7EtfztDm6W5lsG/nUl8acgDbBxpEsNarQ/OnH9x2vhl1DfThp2vk8s9oXErrITPFt0z4zz1oOwsxgjxhXrqT0Z0BNrmzcWj6nchJ+cfc5o4sKCRxUi
 OixEFOCY
 VQPeJn9hpd0VpXNSttNF7Cuwrrp+4EHTZ9WPnpfZOjFX2BKOImXeY2ugY55GB60+vMsQRFU54RR7/OSH64jqgkWL0CXFv2WJ2QmH5gI1y1S2fIX95tVRyV8Yypn0zfu3bcASFTMUl+P7/ToHxyl7C1Qzo0JiUfOyT/5hsmdF+jXYqMGP+im+yA1equwqUMxOVfn2vTLuci+vYvcK79XQCb9wkiCqyjtTf5pLS6tm+F0ZeK/xmz0Ga49/1JPHx0b1ZRGV45nEM4W2vYktvHqcxP6i/YOpkPi15Nt8KGVufkxHNZDk05OY21WyV6As5u+zMLXezeA068SgSdQPQV957U8/Mzi2BKlwpuXAx9PGkGvvpDB86SpWvithFb33dFbtuhVUSgFTBbcALhUYPb0fY7DYu9Sle1iwiGz7sFL+i82AnjDwinWDSebP6YPKaVIFht7DE4VlSrmFQw+LIgBHEpIDrjwowDFcy8EJ6/fwUEawz5x5QEmhFiXL35DgBEzyrPZDRLgb1jLIfkGpTKjud8/Oyu3sKwaB3x9XDo6yTcUqIghr72Piq5t4R3RoqzSFyYZwRv7UKQ5dhTlyvv03qGq1M9CfJLntqLSwxSEthWqFk0WU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/22/26 2:41 PM, Muhammad Usama Anjum wrote:
> The tmpfile-backed COW cases allocate a one-page file with fallocate()
> before exercising private and shared mappings.  When the filesystem
> backing tmpfile() does not implement fallocate(), setup fails with
> EOPNOTSUPP and no COW behavior is exercised.
> 
> This occurs when the temporary directory resides on a filesystem with
> limited allocation support, such as NFSv3.  Reporting a failure adds
> noise because the test prerequisite is absent rather than the COW
> implementation being broken.
> 
> Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
> error as a failure so unexpected setup regressions remain visible.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

I've tested this patch on a QEMU with ramfs mounted over /tmp, which
does not support fallocate().

Before applying the patch, 3 tests (Basic COW with tmpfile, R/O longterm
GUP pin with tmpfile and R/O longterm GUP-fast pin with tmpfile) failed
with
# fallocate() failed: Operation not supported (95)

After applying the patch, these tests are skipped.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/cow.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
> index 0c627ea89ff7b..c1b8920e29342 100644
> --- a/tools/testing/selftests/mm/cow.c
> +++ b/tools/testing/selftests/mm/cow.c
> @@ -1718,8 +1718,13 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
>  
>  	/* File consists of a single page filled with zeroes. */
>  	if (fallocate(fd, 0, 0, pagesize)) {
> -		ksft_perror("fallocate() failed");
> -		log_test_result(KSFT_FAIL);
> +		if (errno == EOPNOTSUPP) {
> +			ksft_print_msg("fallocate() not supported by filesystem\n");
> +			log_test_result(KSFT_SKIP);
> +		} else {
> +			ksft_perror("fallocate() failed");
> +			log_test_result(KSFT_FAIL);
> +		}
>  		goto close;
>  	}
>  


