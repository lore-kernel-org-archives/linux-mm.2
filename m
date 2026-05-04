Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11B9FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D341F6B0005; Mon,  4 May 2026 08:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE9D6B008A; Mon,  4 May 2026 08:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37C96B008C; Mon,  4 May 2026 08:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC316B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:21:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51871A017B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:21:32 +0000 (UTC)
X-FDA: 84729648024.06.DA0A2D4
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012043.outbound.protection.outlook.com [52.101.66.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0649580009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:21:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="VX9/rggr";
	dkim=pass header.d=arm.com header.s=selector1 header.b="VX9/rggr";
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.43 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777897288; a=rsa-sha256;
	cv=pass;
	b=TXyUDAm2ZAVjHrKF6mPh14qiwL1SAq0BtuUS515G8ag2IAGErq4lc5WKkMS/K7AfdShjJZ
	mFEBi07yoyONtlNvNrlkCo5TuohHN3nPZn6dpHpCilWMwr7hf/F4cZVoGP4YJ5BoKd5iA2
	ThAqsWA/S/f8T4Bjc2vi7gkhyH/gRvc=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="VX9/rggr";
	dkim=pass header.d=arm.com header.s=selector1 header.b="VX9/rggr";
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.43 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777897288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsfL030AlBVO55RJBCiu6tC8HTDeZlNSzlJ1nTAELB4=;
	b=K8fHDkz+DO2+kPR4Bo+OZxbyHxcJ9Z500MuQfVpY+UoMmqWZGMsVxcrv/LUfvRzzTwZuUz
	aV/1oLymi6w8lG4u3TDreJ44C2jLJAhshP0bpwN/2qQORaB32hJ5z0lLV4eiOcneDNaq5E
	ekPc2yvc/E/s7Q0dV0nCHK7RMZv15Ns=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WBpK19cAXYSVYX8c0vsYQ7APnXg18y/SWpoh3rLo5CQEUfi9YeQPlge8sn8aN2jy3U7oLigGrq6wDiak9gFh76bNrHryUD2rX88r2q1lUYWXhoK+Ro8h6Cpqse6YIjFjweECvG+Kyn0kGqblEmuAE6sbSJTkhAkeU4Hw9CdxMAJ6hue2DV43756480CR3Xmz8BHW0ypcOMWkupikVi9l94n6d9PJiPtrhCPRLr36f4lkMilRfS6YxekFKWcC7xVhiEBPxyDrilY5b3IrUsa0qyM0hcXGSRD/vADdY4/PE3bZ6aX/ubMHgsgiJOuAePCMWARhvxKladBHxLmtBSmOMQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsfL030AlBVO55RJBCiu6tC8HTDeZlNSzlJ1nTAELB4=;
 b=Dz5I7fp7qcMxucKVZROiRqFf7WBIuBjsMCoIVrSPNQMaMjam3ZHyYmiXSy2yG0JbF13iYyS7HaaGg+k8qArghzoQ9SKLUtzuYTpM2rfPX8pGjvAjcYhMEXa00z2MBNToULwtEOQVOlBB7jr8redau7dyxtoR3ZvuXiQCAWWyR1AFKMoI1LjFt/GYz9xnStvYStREINoqQ6EumU3HVC3YY8PfFFMK82thW/2e56aKmBscyTIKpOkGzYUqbIkoNZI/7MAbY30jhKoBYhftbtkBJ52vTx5mPaCLwCz4nmPemuhVgG3qK0z3ea9aOwGS/Vr3Ad4bYH9pIoXQ9G4D3N1QaA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsfL030AlBVO55RJBCiu6tC8HTDeZlNSzlJ1nTAELB4=;
 b=VX9/rggrlS8BQTQFfQQ1OGhOd3wfsHb619Q+0c/KTOdF34DCTcrS9bx5Bm4ux9/6armYeuzN/VKJ5juuAHuj3hJ5JCn3RAgRqlhW1pW/DfUdxS0UvzG+hOf1KjybUj/u/BQOf6p1/1MPodjKHdl+whKo+VviZlE5Ef3RnRZD7Yg=
Received: from AS4P250CA0003.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::19)
 by AS8PR08MB8899.eurprd08.prod.outlook.com (2603:10a6:20b:5b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 12:21:19 +0000
Received: from AMS1EPF00000047.eurprd04.prod.outlook.com
 (2603:10a6:20b:5df:cafe::f0) by AS4P250CA0003.outlook.office365.com
 (2603:10a6:20b:5df::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 12:21:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000047.mail.protection.outlook.com (10.167.16.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Mon, 4 May 2026 12:21:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lif5LgvgV70YReEPgPRaR0xpXi6meERLR/yCYjxRwp67Y5mtI0Ao6Smt1HQJ9bCP9p8KkJE93+V0vIhk871dW2MFK9GJfLMKQc9zLF7zLzmILYCspfvlzc/jYKvZoHmA5o3p6qrRheKFpmbYPo3kEnEFJKlhlMbBjQ9hqZuED6w7z9EQnYADrHjbBH7679SYtiQk/HuodvvMbE61i3MIm/y/KXpZyDUl5HgO+EtJf1d/PUtkE7dQCYoEDdkTj9Qym6i1k7VJ/beWg3B779CkoDgXjNzQJP4xDGKjdKoiGt0SF8VTvEwobOCDXQOIvgoGRFCotYC6jM/lJavm7FZwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsfL030AlBVO55RJBCiu6tC8HTDeZlNSzlJ1nTAELB4=;
 b=Ke3572OB+TStAd8m+Jbo+fnxaR/AIZI3ACqGiR7+oikCneZ1hF12p/ENtKpy1cXrFUHMaE2VM82uAsbhg/bVmkwv7USrDD03FHV9PeOqkdMuuW5sP1eryB/9GD3554JhanZWv6wy3M7Pq3HAKIpvsdMsOCriOHfIUxewswX4eu4KrpoEhB+n1R4BiKv97EdX5YFHcMHQdRnTFRO+6KgI2ecsdd2NWYxvBgc2Aohj8UsRp9ebUvWT4YNyz2inTYs3BxJCjU2hIXxGovWv4Pb0VryQoPSceUl0EvA05CaR7r9OSWRtYLAIRsaZ3Ci7yhk/SIMTCSGsv6jDqB+MRMJ/rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsfL030AlBVO55RJBCiu6tC8HTDeZlNSzlJ1nTAELB4=;
 b=VX9/rggrlS8BQTQFfQQ1OGhOd3wfsHb619Q+0c/KTOdF34DCTcrS9bx5Bm4ux9/6armYeuzN/VKJ5juuAHuj3hJ5JCn3RAgRqlhW1pW/DfUdxS0UvzG+hOf1KjybUj/u/BQOf6p1/1MPodjKHdl+whKo+VviZlE5Ef3RnRZD7Yg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PAWPR08MB11160.eurprd08.prod.outlook.com (2603:10a6:102:46e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 12:20:15 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 12:20:15 +0000
Message-ID: <ae5882a8-7cf9-46cb-a1ac-d04f501e2e62@arm.com>
Date: Mon, 4 May 2026 17:50:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 35/54] selftests/mm: hugepage_dio: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-36-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-36-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0092.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a8::13) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PAWPR08MB11160:EE_|AMS1EPF00000047:EE_|AS8PR08MB8899:EE_
X-MS-Office365-Filtering-Correlation-Id: 67433d0e-ed7e-4ced-c296-08dea9d7a5aa
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 luZoAGJBkKT6k9Gsuo724ZwDginICWOEqHw6RbFjX2Z0Uda9Jy61roxR9ja9lol/bV1TwvCpfhCGZIxMd3uYE9WHXoxlmeUYMfYCid/14+FV9kZRQB5uHq4MmGefdmF54JE+8iDTSfhNnoRKmEI7IoJfgPanYuuCJjR2kceXXPPFG6P9pz9bM2MRUbM4gnN0XyZTxKuJf/rprwUYWY82diSn71yLKFV1pXXZ3PFD6mxVt7wVMlJG7YT9kcdnrl4RhUE+04Rw7621UDqRc/hiqJXF+E5NY5E568tidFPl9YhrhVhMtRXSiwngXk44zj7CRAwwK2YHbitw/F5u8vX+jfaWVGwoIRVXvKmmOHLDc5pszIZoVwiKcKFKXNxE0OELcRTUHtJ7md6jQjsfBy7yH+80Iji4FltbGraYCc31E9+Xc7dV7JHKkyXQUWFxn4UkcdL5h3xDR9tcaCX0/ty3soAl8dcnzyKDHRGhIvxLfvmHJWSrIhuivnwMBWDYUKN5b7NYSG41MnVU9tAvqxZnrAqwwwNJFb6yDaqvoB00iLCggtGL+cFtx95cIAdpEWr6L+k4+cvgmtxqGYn1gFwb3JsRz0Gsu0aCvwLnweLa5jOElq30ogOBUUScAY8fi8K9YOqA8vRcLmBrjT/fVPCYKb0nZWHjRDnjnZkrRPjPNeRUunI0iCnMTBput4poxJLj
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 QrIfQcJoSGrjazhd4KR7T9wnp3aw8FTQ7fzz91qHkTerhrdgrDtIJFSYYVONIaSxl4B+Yx1m0jxgkww1zrhE7t6oQZvqMydRQecGFQgl606QX+fQ/P/de7+2Jnhq08U/+PcbRRBT3Tu3BWlm5jSrHoDAV/I5qwV2PBLoGCVtHyGiey2hmmu3E6geVa8GknOfTtJTbTYbXr/+UBweZZAood724XxZjOlRNIGflKTEdlQIkyWoAgb30QcRjGRaQ/ap2/Wzeeq+VqUcHlRM5PmGKzmDbYv9wazJDmrOpe34zfDG+3i7YIdfw0y6naqNK/kULEStFG/O3wdhZy/bztg1bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11160
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8870618b-a76e-4491-c328-08dea9d77f1f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|1800799024|7416014|82310400026|35042699022|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	DljWaCNlVEZXfajNJ0Ga2bUa68meYOA1g0SroO//pISJvgeO1RsxZ9ol+l3Ze9mpa17CF2zF4ul913mK0pBTpMtRYLTSVDVIqQeaISzzH+i0paabWV0uTk0ZjyMt3Ijw3bVj+mczl0DnFb3a3EPRCKyJYIwE6gmvO41A7ctE4pUlGJ3po/qPcCxhHeqi9DeJKcpEQVJZYtcsHfTKvfEIFiuKozcM8RrS1zUxN6XaWXZHr74XfZ4JHZcley0L4+pwueBzznyUlM5CzDKoztvXGhh4QuOkH5LXpJCV87mwsW7tzf4Sn1/+SUfzqvW/ub/KiumhPsbF/Yxbs05CuRS6dHi753fsboPAogU4bTxz4+Qsj0m6pRuzMcrOvUi89yH3JJVlXrkK3etV2vFO7lHE0KEnlcjYG2zTvQREDDPMS3plCXPt2iAudqS029AnYzZFNGYy64vbxZPNy3enNuO4UE3KadY+I0n0WdvQUlmC7NiCdv0WlPCe1FQV8o0E0fRYe5629ug30yEsxCb7um7AVx6RLj6zMOh9JmiROyo6nX7uUWVgj7nIpwJwidMg27Skr1oG2BasibzFvSGZYCvcnqakvB0/U69XIrUCk/ykVv2CdHNUQGrgNrnCi92aGmDC9lRQ8WVeeHsPbyzYwumHPeP2AX3Q++yWeeTpPE+KJaK6icZGf75XT/0/98d7T1g3AhAhLfdcQjXP9ADJ7sK80eChwk4El3F7L0LXFoj+k9Q=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(1800799024)(7416014)(82310400026)(35042699022)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PP8P4mHj4kYE7ZSFQ8Lp8Nesoli8KazIRtNBDkF4elK27m4VOhK33IyjPibi3eoyHSshY0AZCz8a/WNCkaN6KHkPoEmodLmc3yun5FVtyY6IGClxvAl2DRSbAWhG0UPh4Tc4dyjXTt2WNzWmOM1HhXAScVFtBJy+8+aj3S0Q8wuG3H8UOYWfn+2YiHv/s5bWr/4B0LHMNAraRxBDJXwd+I8jyjwJPTMvluIKyRQxspahFoOiohOEed9wox7CHM/mhbzJr/t9XKcU2L7cDU7Dvtl/BpFBY2s6C7vqXJCgaLyRCvS3z8uxnvgbwifOT7v/wqr0EB7/DQZUd/NDDFPWUwbKQgAaBASE1X7+1MxEXe8G992a2+gULnnrI/QFZ7oTqvdl6u8F98AC8xaTo41uciWzwDLTosZrHQYuFv7SMHBaikqVpo/p2iQMRdHAknv4
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 12:21:19.4702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67433d0e-ed7e-4ced-c296-08dea9d7a5aa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8899
X-Stat-Signature: ro4ry8qrt7abfqf17ns8ze7rud6r4o9x
X-Rspam-User: 
X-Rspamd-Queue-Id: 0649580009
X-Rspamd-Server: rspam07
X-HE-Tag: 1777897286-807606
X-HE-Meta: U2FsdGVkX1+M7XiMCvUo9XhPQszRl+MegpDOmsHubuXi24qG25LB+ZkPvlSzdtbJbxR6TWZo5ccrJcB1+y5wItYi+GeUQxedmmLljF4o+BytTpAu9kRxcDdInFLSzZVkPdY4rjMbcT5zLvRyDO9e62y+B7zcyIA+y3tSTLNc36VYEvJj6R5zajD9nk2PFtphs5kx/Akm66a2evJ9ktdAEVB69endBL8TuaT4Wm664GIGhe34GmiuPnv3yBOO7btRaBoRmrNWFLJxCuv/qsU5oQLvB0mB4R8RH67MFmMUpBm+NZ3OgnXgoYvHqEeLbAfeut/AopvFFHXFpmmHBzgpr7+QZ3aXBvOGA1l0i1LrblljvR97pukU/ZIeEeBHBJ7P+TQe9Z6V7EhOvA4dS4HhifDHw3HfI7sl5+TEuIQKTOvGlAmPKh2cfCDK3nqV6LMpaX7pTahz9It/4qzRGcx0D9UeWXj4ttKPzk8FIb2uMUZwlIqW08AuXvapYRxwnXKYE3WwGPKEgm8JmR7tAW2Os3/p4mmcfDdjH1uimJQ4GRlQsSLC8UG6g5BNXFQFpUViWd4QCJLUool9cdTDwm5Ok2f8tVEFnq2xZpQ2c42mcHt3hmg7uFyoAgqFPDFDv+i7hCt2wFjmtJHPOAAsCTlr1CxF06RO2OJZDnucSULwThgRP1DsjhOXqCW8CY5OLVNkeZjnye7ApUlE1uCyDOqTED6Tc02Jz9nzuC3N4wxc56KaBYC86+7CEngpqg6A59Mn5QGunFggmxeVrNnXPvrrQVB8H6/MM5JFlOKabzHEovPCeBOVHdThVfVpKstHmYcpA0jPq/b7xIGspDe8zZUumwJyLTYJPLAHuUpwVBGCorKg30PjIvJZaARl98J+yCLwy+LwzTpa7TFfHferCWu2bwizYzfF/uJ17yIGX3NcRNIymlJXuu9QQoko3qJ/+9RMnNsfMaYg0zhHyO5pfkd
 nOjy4zBf
 KyslDEhgW03kVrqsqrmhrRFpGRzN20+fMHYdZD/hVxV3GFbGPyCSxa/MB/ePNcMiNBnljTCbgF9UddVTXNSRCPwAR81aU/7mT8LCylERAY8+v8Udv5Tdg5yMrmSr6vxx2zSXCa6shJaYhUN8QWtNZWUvMYIHlwRBYKzPBbFN7bc6fZZu945kmqU9Z//iP57U/cRWHoMn+VKQBUxeBGR0W40Q//RuD/pxMWchajg0onkOQT/Q8nSWV7PUzVU+QSs16/DkfE6ZNTKIStiL/hFuNQZGaYZh5ustNNILxx5a137FkVp3jcJzw83hqSasgnFkPThj8eg2VCgUh868/c6FqFgPDrYYDQJnmcY4HRs22e+Puf4bAPS5wS6r4ibtrDMfMFCIkec2plDM7q1vrlhkK7PJMD6Z92FBhqbwxcCFg48AhYJl+CESoIh21qGeuQsrUYCKFR/DqeFgbpIwO3wxro63wPgT0qFUYwWMm3dbHCkMsEmvhaKqNJ+T59Xx3CXxkePz33XjAjOyzckgsXmEtRILoDxNcxRv7bHEOPTKBzpYvtaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugepage_dio test fails if there are no free huge pages prepared by a
> wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/hugetlb_dio.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
> index 47019433ddaf..fb4600570e13 100644
> --- a/tools/testing/selftests/mm/hugetlb_dio.c
> +++ b/tools/testing/selftests/mm/hugetlb_dio.c
> @@ -85,8 +85,6 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
>  
>  	/* Get the default huge page size */
>  	h_pagesize = default_huge_page_size();
> -	if (!h_pagesize)
> -		ksft_exit_fail_msg("Unable to determine huge page size\n");
>  
>  	/* Reset file position since fd is shared across tests */
>  	if (lseek(fd, 0, SEEK_SET) < 0)
> @@ -94,10 +92,6 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
>  
>  	/* Get the free huge pages before allocation */
>  	free_hpage_b = hugetlb_free_default_pages();
> -	if (free_hpage_b == 0) {
> -		close(fd);
> -		ksft_exit_skip("No free hugepage, exiting!\n");
> -	}
>  
>  	/* Allocate a hugetlb page */
>  	orig_buffer = mmap(NULL, h_pagesize, mmap_prot, mmap_flags, -1, 0);
> @@ -141,8 +135,8 @@ int main(void)
>  
>  	ksft_print_header();
>  
> -	/* Check if huge pages are free */
> -	if (!hugetlb_free_default_pages())
> +	/* request a huge page */
> +	if (!hugetlb_setup_default(1))
>  		ksft_exit_skip("No free hugepage, exiting\n");

Before applying the patch, I get the following output:

TAP version 13
1..4
# No. Free pages before allocation : 112
# No. Free pages after munmap : 112
ok 1 free huge pages from 0-12288
# No. Free pages before allocation : 112
# No. Free pages after munmap : 112
ok 2 free huge pages from 0-10240
# No. Free pages before allocation : 112
# No. Free pages after munmap : 112
ok 3 free huge pages from 2048-12288
# No. Free pages before allocation : 112
# No. Free pages after munmap : 112
ok 4 free huge pages from 2048-14336
# Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0

After applying the patch, I get this:

TAP version 13
# [INFO] detected hugetlb page size: 2048 KiB
# [INFO] detected hugetlb page size: 32768 KiB
# [INFO] detected hugetlb page size: 64 KiB
# [INFO] detected hugetlb page size: 1048576 KiB
1..0 # SKIP No free hugepage, exiting

even when I have 112 free and 128 total hugepages of size 2MB (default
for my system).

Could it be because hugetlb_setup_default(1) here is trying to set the
default hugetlb pool size to exactly 1, and then checking whether there
is exactly 1 free hugepage, instead of simply checking whether at least
1 free hugepage is available?


>  
>  	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);


