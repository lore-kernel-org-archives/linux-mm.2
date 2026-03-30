Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AC91061B0F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8F56B008C; Mon, 30 Mar 2026 12:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A486B0095; Mon, 30 Mar 2026 12:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951A46B0096; Mon, 30 Mar 2026 12:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8233A6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:16:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2681BC2C0C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:16:51 +0000 (UTC)
X-FDA: 84603233022.07.D28E6AD
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013015.outbound.protection.outlook.com [52.101.83.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id ABA57A000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:16:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=b9t87Rtf;
	dkim=pass header.d=arm.com header.s=selector1 header.b=b9t87Rtf;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf15.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.15 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774887407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITrpXYBxoUpwqYzFcSFDR8GEKumtCaz1G9Qydfz06LM=;
	b=RIF86hqFp4ECvcvkdoDFl92E5vhUMXKH3tZX5gIfLhnLe2JmZlp3tTLNF7O9k5xeWSMLP+
	8r+eDNin1baM39ce5etV9KjUBQ/devF2Ew53C4EIzC/4gcOoZM/6Ip3gIFSXep5ZkbZcpd
	sX6ZtxkfhNEiVJoAxoSao0AwaX0QCqw=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774887407; a=rsa-sha256;
	cv=pass;
	b=he4ar+wvSx86acOzef8Ed385iDOHw+bv22WBSbzImdu8uS3n2uVZYIhp5R9SIkTMk5AS2P
	ASxoAoSrbo5+SUV1il5Uz+jJ9qQQrdBdO3tx5TFswMKc+SekDv4xke/yJPjsvmMVIfNOjG
	o/gOIqcB4euukMitNSR254ElJCvv/8M=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=b9t87Rtf;
	dkim=pass header.d=arm.com header.s=selector1 header.b=b9t87Rtf;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf15.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.15 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=zNU0lPT5f9t6wzB/zBRsUEgYKpIopGZVLMH/CgTts/jAGOSt2shgu9DqTNHa0mRrrRwlkeB3A7aUKwgmwvVHlNMqwHpp/pmGAtBminbOs8rJ2NkM2MFSzgsFgu1EdzcFRzAfqeVftzym9EHzRs34vLbLKfNXC1canbabgt4ZwcDMEu9fK7ml9NvfcmyadlJSqfqg0rg2EWIVpgN54SlIujlw5aOpVTyydAwei4rNVvKUnJrRYbZsDtORA8kBmrXYPOCTp0BP83CeJ+vE/ZQ+4AG5Kw2p3X8NMtaTOE/dAwTlJV7TWq6dcLPHjjTd/l7zRzA2HdxvqjkntqLLw3DUBg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITrpXYBxoUpwqYzFcSFDR8GEKumtCaz1G9Qydfz06LM=;
 b=OVUDA/dgWNkld7YnEP6YwPgq2m7bE0RlPvpliwAUnmAUJPPJmDEMwodTWl2rL5VnE3vGXW8kEZe95Gv+t5yd75Rgrdv6d9i5X2csRXvxqMmbAb6z4Gj1b1R3IoADBKLBzI/HaGwLGVK2ytMN+cwx56wqEMkl+uVQUD7NhchzE6stz5YvC3zAYH8nyy4ba1qspiLipZaecWuTmEgK5axra/3uurAd1JZgeNgaoiyjwq+BEVsy2ZrNL2rB09kKYHnd9RBIZ1JQszG3PvXniE7qVhVtmg8NogCcN7Mod7q1WyvsKxUe4uQvGLh3LMKvo3bke+a2gOwoMb4IpCz7p7Gwiw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITrpXYBxoUpwqYzFcSFDR8GEKumtCaz1G9Qydfz06LM=;
 b=b9t87RtfPy56HRZ5YU023UOJHluPdZwNIhzhJAiLYeZgbO5qXpUfwd4rCds5EA3KGE36/+Z4wPguPSWRVQ6skfiPKSzfboGT3UIk0hb/JC2LUCJKUofUMCCZiBANRvnZHFtx+QaIm9Wz+2z65u9NJO9QKHKhSC1Fs5V2ZbDR2CU=
Received: from DUZPR01CA0102.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::9) by DB4PR08MB8125.eurprd08.prod.outlook.com
 (2603:10a6:10:384::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 16:16:34 +0000
Received: from DU2PEPF00028D05.eurprd03.prod.outlook.com
 (2603:10a6:10:4bb:cafe::22) by DUZPR01CA0102.outlook.office365.com
 (2603:10a6:10:4bb::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 16:16:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D05.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Mon, 30 Mar 2026 16:16:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eNdeQozsrpjGaQV+9egqufKC4dsNIrzlgjR8h/ON0eEzB/X0Knw02rWoPi0B3zNgWROHlN4yC8b5/kErGfcPwa2LuohAxta/l8A56+9i7KgXcWT4HTVlVPL+bSKe9dIW3hn3S7+GagSWMUqKm445qpLlRDzmimCP9gxc3XH/aMkVWNZyIvR3RFQlORlqhu4/0l2F/tpL8ufACAOXMW+pa0RRT9Pf0pC7drzw0mWbtSn34IJF69Vmzupz941C7UtmGZpOhIAznaOFBhSFP6y69YdUjyyB8qhzxeNu/d3Hx/7zt9Ii9wtL1s+Z7RpJr6nA0R53tRbYvIs7uhH/hfyE0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITrpXYBxoUpwqYzFcSFDR8GEKumtCaz1G9Qydfz06LM=;
 b=ZSJ8vTxqCqqJSqtpvqlhS0tOOkD4bQgRNjpLJa4GqDArOvKtz6x2+LqRruylNBoD0N3g5oPW6L2ujCpDc5TuWPyryTG9s9KXj4U5Yj61znfqAbsgeVLf+l2ybQbkuhETYc549XOV5dot1BgjU6BvZQSbdMdmCe5fH/xVfd24iIEMKmokTtPpm/60tzN3EFo6pGpEvqPALLRLdVFgQ+Nax6d/X/F7crLkfpYkXbP0+IpjRLBnOYx8aWwWtBCXJHL//9yd4+LWZKZpxBv0kXQfCzmQxehm+dUjhlxYH7brcc8sgmaKnRqY8KS+mH70Dm3dAWs8iNe3N77014Y7M4ippA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITrpXYBxoUpwqYzFcSFDR8GEKumtCaz1G9Qydfz06LM=;
 b=b9t87RtfPy56HRZ5YU023UOJHluPdZwNIhzhJAiLYeZgbO5qXpUfwd4rCds5EA3KGE36/+Z4wPguPSWRVQ6skfiPKSzfboGT3UIk0hb/JC2LUCJKUofUMCCZiBANRvnZHFtx+QaIm9Wz+2z65u9NJO9QKHKhSC1Fs5V2ZbDR2CU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by VI0PR08MB11041.eurprd08.prod.outlook.com (2603:10a6:800:256::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 16:15:28 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%4]) with mapi id 15.20.9745.019; Mon, 30 Mar 2026
 16:15:28 +0000
Message-ID: <7eb26b81-ec64-470c-9fd2-52f9b9692b48@arm.com>
Date: Mon, 30 Mar 2026 17:15:27 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v4 2/3] vmalloc: Optimize vfree
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-3-usama.anjum@arm.com>
 <82e4055c-2343-49ee-b772-d3f4d134f8d0@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <82e4055c-2343-49ee-b772-d3f4d134f8d0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0143.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:346::6) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|VI0PR08MB11041:EE_|DU2PEPF00028D05:EE_|DB4PR08MB8125:EE_
X-MS-Office365-Filtering-Correlation-Id: 223beb71-63a8-40fc-d43e-08de8e77b66c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 eBoYgVw2m5E+SYwKy5haUoy1g7YuSOX8aO5plCfEcCU1x8UVmPoi6jQKRBi2DVoxU3HKMOZ6MMU227iabuR95r76hvomjIVHUsuInxthIEYc2C7ADfhb4jGaL6ad2XUeSaRs1o+fp7UHrmYqJwPQ8fpu7J/nxW3ICwnc9FTz6JWx4batp8xK9wfOq2Kt6Jgr3nqYVXdzzPrLYzDco8ey4CGKmSsq+uKjDLoxu+nNpmDsOSl716sbFsT603TTGPQMMxecOzYa+K5eDT6sLy4fQKrECxssi49wmhqgjBTvpuElpXT5cQNy7RlzuQ2zUQolpBIzgc1Tey9FzIiUhEWc2dJyTUGRdbqZq3t/l3Q+ztRgeWg9EgPMzzzSpGRUQHj2qcaXEvJKpiYdBcYUz7PQIni8szSkbydup/4OGwxRkOwyfeaIo4vvIqGRxzpmqHneefblUx43BcW80UWlt6J6iZjRBPjJ5g0H1epsTSz/bGjEyg1IEuPMPlBtJO4/qpkd1goTPMHJa1u/KKhIsZk9k0ibKOqk12Z8TrS4vfWzrXb13hOScEOvniopcc/XQu7eUgMMB/R7BGmivySv5LyP1lPe63Jq6zL9Dl8UdzBcSVTRcw7/GrQUKE5OYX9nydOslrB7Rp6NenW42dSUMQ3KCo7R568f/FtRCPv+qPpB4vzP6a9wTS99vHkvvLR6qW6RdDOUizxNXnwWuIqXPiPMevOVX9paN2sQ5cAwrk+1buJgS0tarHur4Z/5BGTjt+/Xzg+Nf5tD6AezWtob7xahwYW1cuiguSLh7OZqX04x1zc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 YK7oibZPuxSt9uDK1xRIYxnKkQPddlwCSAYyXnSS4eH1pPniABFlJHFI4nIaFNtIT56udyYO5iX9UUAYbTk6EeNZ9WdEDV25pO7ukSiRgOyZM74H3suEWfXHw2mwCNJe+mYadXOk5w3s2ek+am3QPKD79zatJHrkRJpJ5T11qaizWFVnMajEgP8VHRqCszEgZauTRc8xO8WX+YxM/1Tmm4ZlXXL9YLI8Rh0ai22g9IBkCjU1u018LtMyv8mxHrAswwiIoPzDElE58PccIt++9ANH35ILkW6SSswT5ne0eB7FQAp0XXmNxT34u2xnMVKM1NY1P0DcX9C1nCoWpBvCvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11041
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D05.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bf440c69-5136-40b8-38ef-08de8e778ee5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|14060799003|35042699022|7416014|376014|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	SENp4mzQuB9hrchBIEvn5uCRbJh/YqiqrXZh7Q35901gM3WU+J6SbTrPxL7KPstc/sVTsA3N3UEEISQdUZJd2p6MJOLwnZvR6f/rWbt5Rpgstnqv3vLj9tjF7VBBezHieaE6MYWmWwJK8+c6sVcwGtcBF/Fc/ok7ZiDF1/FFy99wlmmomKXb9eJOCdWj6j5QR+QyE1He2r3ALfqL2HIoUr4kdbzgkbSvBbSzpgIi+ELWiihgixImMOax8LIWYWhiItKEDaJBFD15A1cg2tumCuRctPtQz3uaHSmMivjOjgkbeKMY/uJ48XdXt4rYkJ82amEvi7HMJLaUMbLFSwAHBu0ETp5GOFT93WI31e3aTaZeUuryldqVhLSwjLp/XllaCi6umyPgUt0SLM2qpBtibcEF+UZa+aWV+Y6yTtKz/ntqXqYDffaL7tBjEsPy+MQP4XI073NftQAaQsvudxBCVo7FcuftaoNGI/EXUn57fX4meK8KyIDJqrQ6SSZflQ1XG/uY4Ox6hFXVEmRcLQzImEI7v/zcDJ6aCcJCN/gt0W0tZSHwwh5XN6Kr7dqK2RV8hiJQpXkTmKaEQ7hrs3alxufPHG5hb98oSWh8TyHsNhK1j5P77cFKYRMKXgceCPnfYs0T5++xX3/krPpZmLLZgIBHzl+OUgoba4TWHTIsXu5VZW0x3CGMvwij7yst20V/BLLn3cURs0OWtypxGWq7yKUzOWw+xqsb3o4dazhcZ3EUXHCtctFaxaNuVR1Tj+zUdIkyUcwOBYrYnHZG2GtuYhAK+BP7xrGXRzrv5L6DFVGEElH4vNWjyy8quOnlZ+vdim+ozFDxIDoJj+pxOUXz7w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(14060799003)(35042699022)(7416014)(376014)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l8tmhn9K/n6NGhJdQb2lNXq/mRlbtNQJLUz/W18G8q1xksg4IgYFD0KqzXYycC7YfQ0Va4b/zfbtP9ZvvOaFZERdcA50IkpmR7WxwlS/o7AraTjpGprmylCfaWO4SUiuqmINSkpTnTxBDsCreiHSl87YwZ6yi7t/HO1UPCkW9zHecP53UnZuhXZ8TY85Aybs0Lt0wgAyqn+Nzf1rOrLB/7IvYP6F//VbglEbrmukPng9niJ+jtzOulefQhsTQLUthRuT6CsBr4pyr+X2W27fs6y+sFiZbrsVBcYLPEE5M4wzTPdpSPOeHuJxNN8R8cr7MpFbWqvkttwm1ChYmjcKdI7IfnZq2vbEAvaooWER5j12Gv+uIAJgkcB7Y8u7b9eswdMTaPnEdbpLS7uaYKWEdhiTIZ2hoq/1kxHSvWPiswP7erDJepjemt0gnTNqpZVO
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 16:16:34.4941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 223beb71-63a8-40fc-d43e-08de8e77b66c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D05.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8125
X-Rspamd-Server: rspam12
X-Stat-Signature: 6kh88tow8bdhg5k6c6oit4awbye3dchx
X-Rspamd-Queue-Id: ABA57A000D
X-Rspam-User: 
X-HE-Tag: 1774887402-511582
X-HE-Meta: U2FsdGVkX183hAIQiiHWLCPSSRI3kjs3wXXL++m3WVpgvsBcxhUXbbElf0JhF8kb9Y5KrOMNPqxEn/7XdMhaMePNn05EESNA/farjt3ufKZ2z9WQ6kBcw+d2IYIlXRC30ORltx4Bcx/iH/M09M3n4ANOY4vxtmaMBl1NO+XqkmLCOW4rzzAKBr1VrXkeowsJ7mmrWrXm4CrjT/OwO/w2mfjoBVB1acoMoeUpoeXnuD9++CMyV7Xnj+wPGSswMy7o2xwYDWt/Ct7zYUQWKUIzt89ishCv8eFtVFHOf9ptmH0nPJA6lWOevgyMoJTeUEgV3oB7YORw2g5+nHWY3DQawSyM6JXgnpvO+LMviQ+D3F6r8UqiGcCWZjn1v8b/PfeDKyiKbggaLkTdf9lBnQ16umjfE3cb4ijUap+InwnBIJ47/Rwg1cudacRCHROxVjqKku79/tD71en65aVdptcRnVI8W3dARnDlGHwHtop9l8aeGnc5SxgLjBOAdrwK1+fEtN350rGDUQpu1aOTfKDF3IByjeriVUHoy9ZyD7JiV0TfCG2+iZ3C7/HIEnqEL+N/37Tph8yMwgbhNfdA/BBT6ychPSrE17wxiFchqD8/IQBeuBxNEwXQPputMv5Rjl3jwrxNqOyWlJPsvVQNBBQ+gRfunHG5dnJW8qTEdlRmTDIIfJAhlbdBBafHZA1Hzm0Y4XDqTB4mWu3WNCLLry/4JSH/BAfzlFpuRYtmQ+FEZw9uH3Sg3jGnXliL1y9ndH3PxAhyjexyKKR8hwOib6epRkVcasEG319Cms7Ty3UQFd9Yr67znFoQkN0ZetXM3BuBQxbN8N7leuJ8rYC90ZJHUZhg2HDCj5NL0NkbrL2cb5vglCdFIZQ7Sa/Q8Dnc75c+WSOMY+Cw3W5Gz++2vEt5GWUv/VC+/zluRRrkyVOKN7ixtBEQzG30WyKIspAwPR2146cHVDNUL/0RyJ0p9Q9
 3q2+Rdbx
 AI84heeEr9FF6ZxrfM8SWuOqwieGcRXmDgjWODBTbCe8h1vzHvbeALNSXvKQglSOMQ9bk50DXIgvL17cKCXM2l8zcomXiCZTyRYHprUfxcoW8SM52E9mbITV4Whd7XyL2BYYYLewKgUs5k23f+zA0MviJoNi4Fmf0hH02QGGVBmexHhU+eoJMM/Pv0kyNuYpaIDrx2fcoZTKGu1LbGhrcvomaooJgrJSJLNasIJ79GmOKkxMYbEY1wdQ9wCl53Wq3uuNhzrSovYfF/AGfp2rxGNVq5TyTbt4lFYXANs9tHykpM/QhrDehKdHMOQnWl4abYC71B5XkbMs8Ux4PnUq7+XD1BBpZUtUssGGu1PUfq/82YC5K6aUrgeusebP590IR01RYr46vrnOjK9t2D1XfylRMxcw5l8Myca5ktqL4dQAz8BfF8OpVxPX/S7Otfh46KTDKzECTGKT9g4MYFkU2uR0uamxES1XEukgdrmo3Qf6EsGRGKPGpVhQl+IFbMyNipPloWQu/4TwE1M5vpxXF12yf09xwowZV0TDBgHToRUIr6nJoshZmSftCqMTPe/seJvLTSVHtegcKHU0eLfl7dTxYP5jq/Z6NpUZ2ypezoG7CsqtSlp/9pEr76Vi+OhO0y9mzLven2fLPQaDQC9TtZ6eUXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/03/2026 3:38 pm, David Hildenbrand (Arm) wrote:
> On 3/27/26 13:57, Muhammad Usama Anjum wrote:
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>> must immediately split_page() to order-0 so that it remains compatible
>> with users that want to access the underlying struct page.
>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>> allocator") recently made it much more likely for vmalloc to allocate
>> high order pages which are subsequently split to order-0.
>>
>> Unfortunately this had the side effect of causing performance
>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>> benchmarks). See Closes: tag. This happens because the high order pages
>> must be gotten from the buddy but then because they are split to
>> order-0, when they are freed they are freed to the order-0 pcp.
>> Previously allocation was for order-0 pages so they were recycled from
>> the pcp.
>>
>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>> that it also frees that order-3 page to the order-3 pcp, then the
>> regression could be removed.
>>
>> So let's do exactly that; update stats separately first as coalescing is
>> hard to do correctly without complexity. Use free_pages_bulk() which uses
>> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
>> This not only removes the regression, but significantly improves
>> performance of vfree beyond the baseline.
>>
>> A selection of test_vmalloc benchmarks running on arm64 server class
>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>> see regressions. Then with this change performance is much better. (>0
>> is faster, <0 is slower, (R)/(I) = statistically significant
>> Regression/Improvement):
>>
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>> +=================+==========================================================+===================+====================+
>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>
>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v3:
>> - Add kerneldoc comment and update description
>> - Add tag
>>
>> Changes since v2:
>> - Remove BUG_ON in favour of simple implementation as this has never
>>   been seen to output any bug in the past as well
>> - Move the free loop to separate function, free_pages_bulk()
>> - Update stats, lruvec_stat in separate loop
>>
>> Changes since v1:
>> - Rebase on mm-new
>> - Rerun benchmarks
>> ---
>>  include/linux/gfp.h |  2 ++
>>  mm/page_alloc.c     | 38 ++++++++++++++++++++++++++++++++++++++
>>  mm/vmalloc.c        | 16 +++++-----------
>>  3 files changed, 45 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 7c1f9da7c8e56..71f9097ab99a0 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>  				struct page **page_array);
>>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>>  
>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
>> +
>>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>>  				unsigned long nr_pages,
>>  				struct page **page_array);
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 18a96b51aa0be..64be8a9019dca 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5175,6 +5175,44 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>  }
>>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>>  
>> +/*
>> + * free_pages_bulk - Free an array of order-0 pages
>> + * @page_array: Array of pages to free
>> + * @nr_pages: The number of pages in the array
>> + *
>> + * Free the order-0 pages. Adjacent entries whose PFNs form a contiguous
>> + * run are released with a single __free_contig_range() call.
>> + *
>> + * This assumes page_array is sorted in ascending PFN order. Without that,
>> + * the function still frees all pages, but contiguous runs may not be
>> + * detected and the freeing pattern can degrade to freeing one page at a
>> + * time.
>> + *
>> + * Context: Sleepable process context only; calls cond_resched()
>> + */
>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>> +{
>> +	unsigned long start_pfn = 0, pfn;
>> +	unsigned long i, nr_contig = 0;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		pfn = page_to_pfn(page_array[i]);
>> +		if (!nr_contig) {
>> +			start_pfn = pfn;
>> +			nr_contig = 1;
>> +		} else if (start_pfn + nr_contig != pfn) {
>> +			__free_contig_range(start_pfn, nr_contig);
>> +			start_pfn = pfn;
>> +			nr_contig = 1;
>> +			cond_resched();
>> +		} else {
>> +			nr_contig++;
>> +		}
>> +	}
> 
> What happened to the idea of using num_pages_contiguous()? I think that
> should generate more efficient code (all we're doing is comparing
> pointers really on SPARSEMEM_VMEMMAP) and the end result looks more
> readable?
Sorry, I misunderstood you in the light of duplicate usage of
num_pages_contiguous(). I'll update the implementation.

Copying from previous thread.

>>> Could we use num_pages_contiguous() here?
>>>
>>> while (nr_pages) {
>>> 	unsigned long nr_contig_pages = num_pages_contiguous(page_array, nr_pages);
>>>
>>> 	__free_contig_range(pfn_to_page(*page_array), nr_contig_pages);
>>> 	
>>> 	nr_pages -= nr_contig;
>>> 	page_array += nr_contig;
>>> 	cond_resched();
>>> }
>>>
>>> Something like that?
>> __free_contig_range() is already checking for the sections. If
>> num_pages_contiguous() is called here, it'll cause the duplication
>> of the section check.
> No problem. For configs we care about it's optimized out entirely either
> way.

Thanks,
Usama


