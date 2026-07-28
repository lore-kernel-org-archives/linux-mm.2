Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E68C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448FA6B007B; Tue, 28 Jul 2026 01:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9F06B0088; Tue, 28 Jul 2026 01:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C22F6B008C; Tue, 28 Jul 2026 01:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFC9B6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:56:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D32DA029D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:56:15 +0000 (UTC)
X-FDA: 85037125110.16.8A0A2BB
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011046.outbound.protection.outlook.com [40.93.194.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3B523C0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:56:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="pL7/Vw1q";
	spf=pass (imf28.hostedemail.com: domain of bharata@amd.com designates 40.93.194.46 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785218172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuaAth2S0MPKPegIkv4fvOt9wo5pM03DFdyYoCnX7CY=;
	b=HtTZp5+v4IK0cFtBh9dmQg1f5iRy8E7JLFvWCTgMWUVwH9epTdi5RagTskL9dDoILWSpMA
	EeT4oTH8giN8+5iNge7jqiunWrDi202OIm/Bu4e0ziYcKT48OqHXgsqTSBOPQ0kVopChSX
	lrPHRk6Jj1ItRbuUXlyLK9+Et7eAHQs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785218172;
	b=pIPdyNzRCvXUxDd8xWP9y7+hqvhWfMcRd7ZL1W0HHuLeQtjGsyc0hObwYxnCUhPFrhrn9Y
	grItYzAZ1U2kYmScEOD64Uxbjmm6fMN9YMTJY6MUyGe///g7IpN2tr8ho3gxbGVYb+4+Yo
	1DPJlwK8SJLezZ5yq8tJQ93h+0NVCV0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="pL7/Vw1q";
	spf=pass (imf28.hostedemail.com: domain of bharata@amd.com designates 40.93.194.46 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tKLnnm+kF4qhwbYkfBjP6ooftGLVvhHjhs4ErOLV51H2pJ9Rfez9u4VzV1HAOE5+93DZ0gJSk4CA1frPdrpR/SfRB4V7F1YXzAy5reY+VGyT2hPPS+vgw/Pay9QTtc7aH+O4+RV7HXnxSYhCEtZhYXr8ZGOOkliRCn8JKNkSxvxesBMwPeBeYxrKLDL+GnR438PtyvxI+rwjx5AD/qaaLm3Z5R/ePJ/iPOqE5FgLVPnmXYZ6cgktXpLOKkYWz1TxSCsQqNaL7ii9tQUDZgQ6d1RwBl6wxzSgfLhr5d5CF2VdYQm+38e+tdSfbSK0iTspm4xtCNqxSvbVnxxjsucTEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuaAth2S0MPKPegIkv4fvOt9wo5pM03DFdyYoCnX7CY=;
 b=f68AFLMMDDCONn3OJdyVKM+rVxr3zCLIX0sjHGb6En8fLhud8j8EiIkFbBdLvy+5rrBqOMZ1+fLYue46m0n1XHs/dIlaBsexIvFQSEzKL/mo4Y/8sTLbys9Vk21qlXRMzu3lFX90UQ/EEXZ9GP7nvsI56XVKrzkQAYUVFd2fznDExxiWBpPqn+0migbYTqAkQQb7Qn7mw49tBMouBcT4K+oxpd3r/iBRx/JdWW6P+YXmGyYZb5cFXXD/GKAWZIwbd7lvkz68O6i9SskONzve1Hj6JcNs2J6d+qvxbPzgfbZlO+ie3yjhq4k8M+mQBPCGjnDoGKZTeycapxbpQKk6cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuaAth2S0MPKPegIkv4fvOt9wo5pM03DFdyYoCnX7CY=;
 b=pL7/Vw1qOADKGtqoflmnm5nD42i8pp9Om9Ruab5eX7qqZZ1VUoJQ64yd2uKm8sKZPw4Wyc2QeU6wPJq1Sy/4fzTePnYFDl0sspWapsu/gueXMkKLHaXynB+SS5PmGRfMX8IqcNo/mhic59S6cIL8B1jdT7ftDULD6NM/DXuz7RM=
Received: from BLAPR05CA0012.namprd05.prod.outlook.com (2603:10b6:208:36e::21)
 by IA0PR12MB8696.namprd12.prod.outlook.com (2603:10b6:208:48f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 05:56:06 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::49) by BLAPR05CA0012.outlook.office365.com
 (2603:10b6:208:36e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 05:56:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:56:06 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:56:06 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:56:06 -0500
Received: from [10.136.47.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 28 Jul 2026 00:55:58 -0500
Message-ID: <c39af956-0ce2-4bec-a1ef-86cc5127005c@amd.com>
Date: Tue, 28 Jul 2026 11:25:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
 - microbenchmark numbers
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|IA0PR12MB8696:EE_
X-MS-Office365-Filtering-Correlation-Id: 219792a5-f16c-4f8d-a2e0-08deec6cea4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|7416014|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fjY5hyMZZwt2BwYIf6VcIYj2+/RS1nHNCeFWpEikakRG6iV4RpaFK75CFhkLxZRWy6UNifiF/kHRaNf0kIgDgXL0HCIOKOTeo/hu6lp0I/VENK5Z1sqzS4MXivn7udbl1mfKzKYyTmDzADQzoRjsNNyZoOUK02/rDYuXx1b2D1J1rlC72UHMpshUZJDnT+poAXiItgUUPR0EW146+ecobDTHXe5PIGBZgsRnwM01WBEtfylcI5HUHIi413bS6t+7FCsBvYKmO2eapYD2C1N4bkJE+CvvSUBu0d7Hi20FU0UJHPVoAV5VoOVZmqnquCUbuV4kSSCbMXRWt7d3GArnqkwqNk7FVRIPa+Iw/dI2z8B6jyzCb70UcASORoXQ9Cq3XCm1PLk0lSz2clXtJUw+kbb/5ajjDWYUaClIADDssWOE4bdmlAb/+6Y5rkgUybY2xIbFavuz9L3f5ObstJ5imNP+/xwr3HXgFBrlTJj2tIWLM9F92gzHimZy6id5JndXo1gQN6XbZxOe7hpj3Xwx5x/vpAgEEF4LhM0yg+GarPhqLDNGBZRVuki8Rzs4ZZ5/C2dfZ+wfCUUWiVyH4W098iorUg+i7FjPTDmkUhsjcyxHwU/TPS0zFLRUZ2diMvJWX0bf3/lwWy9BWP9ZyhuadNcOP9X9oHE94zNm6ygDosTxzaMOEUyt4Py9eKJ5eLhl
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(7416014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DMwQCzYirG9FSgaotEZMGELXKsK6cIwrO8qM0qyLUjsyLPAmSvYpJCICI4tJdKbaVjmr0eAyiJGGPfwtLYebwZNeS6pM18jxf1X2NkFxoCCXEoLWErAjrlJpkzCdYfQzuf1MRZqtOpWjSvumGUVUZPfM+fiDB9RIq76eyEcPogVQz0Wruien6A4K1AQDhvqk/jK+JqUWhvn+xA1GLifve1GaNGI8h1saFbErf95LF6S+9lAruBVyBMAkIQE2RUnOmfYrtOmWkCmx60240UNCv9ptIVRLOodrddYMs1csAmHVxEaMMD5UPUNtiwb4ZORaVAg45zdmNFlBs7NGX9qZualc/8QJIiTe72j3/2rg0OqQdYwKJ6w9i8G3fvzWzV2WSQNVlZ4RfrlApI6Oc3SCEmuKixHqvhh89c6qiNQFzEi1a3DlpG3o3lhnWceKendA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:56:06.4460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 219792a5-f16c-4f8d-a2e0-08deec6cea4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8696
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B523C0006
X-Stat-Signature: nit5zq4j8onocwteaw14mjdetmeouoq9
X-Rspam-User: 
X-HE-Tag: 1785218172-140128
X-HE-Meta: U2FsdGVkX18awAjDShLzlO7fAA+PdKK+w0sNm7gayPpfIPzWyfmUtDT0bA4J7MqnX8ehcdSc89Fhy4sN9YJx9MgAVcZWW5M5JZPMQOFdEwEOh31oCpC/vwrkaR9qHNwOJbo7ofmJEsMCr8URgy4bW0ee8KVt8xrHQVVpnmQYQCn365eboXr4oEUsIOrBT1tFEPkZXKnocYMy4cIsQ2GW/FmhN8hBK+HXne6VLEp8xpLiqF2+v0sGp9wKM6GoqlbyDQQ0QnhslyEHUoa2FAmHC2BQQxfZE2ZJGZRF1/Yst4AfzsXPWhB8UTE+0qfKABV60Wt/SmoHFuynZfo4Y5Eaah1waSmdepM5KwK/2pzECj8702HKzk9iWjVrrV6a4ms93x0QsrrrXda9Ml0vPvLE7ONy5P3Pt2nVe1GbWzdCKvyv69pnJsuhw4m3aH2dQDXL/ODXcZ5inptgrodwhb1OtwuH1bWdM9Sk4Z2vTWpRUksDHbKRAW5P3ohNkK80zbghNFv3cWd9ja4ygSAHk6kHH8Iz/PefvjWvdiRG3XJpm8yqV6I7QNd7Vb9G0Ohn7mgYu5GM+Cg4vuomt2EPAil5zpbp4Mij1eKVExAyS7TfJ391RE8D5UFjPbOV9DdYRpz8be7BGRpSRMHTodML2EFwvJMEGNmAmw3FbJdOLKZvTmY2E+pia7GXZSonvA18wl0ZTUIX1khDOdljXszqHd8krbJ32itNp5dGaOpBfDxvctX5li3ovvSUAL5KZ+s5sAc3t42LhtYeQZmsH7WNZEdEHa03occBfLl8qODGEN28v0eXFIkT7oX8ES34fsBydNkjcdL1TYaY8DpxgaPa9ufFiiyuKJM627GxPn1kur+GAd0C5D7MrzHpihbihhyMB88Kj+3b1roIKjxZq7dRQbab6v5i46XJtmPdbrU8MqfhtddYLRNRiGaj3EejrGjbOzvOZxZOetdt/Xu+0AsXdeQ
 vc+lNmtf
 NKCk0C4cLFjFoYThOZKfzPyNeZLKueR0Q1SY6H0eHvADsn25eYOJ+zF2XmRyQ1Ozn+7ycLzRvSnhRmte4tLaJStOEoV1ifUymwOHEcODi0L8VJ+8+H2T1+eHARyBsXEVn3E0cGcfSN2lSqgjhFQLXPvUvfdjFjId0v2auKyTqoz0phcas4pp7ZXGmpWS6wwkcKKt5FtY6VEldGTd+f13HiZ3Jsddd0ddLH/C23u8LFvpJhv1MmL2O5nJm58q8vfSxs5R+aE3HfgSrA31q9IPms4FHd3BS2OAMh8g87hpAAWxCW/TwBSNRNZElcIvtS2hYLJEHNwcskNrrBuZU09oVEF+pf03qP3jf5e2HnL18WFU2DJphgeS/Fmi+6OsCG73QCoOFS8Ka94wqptPQ3OIZO03NQH41v6ePRjvrpvZY+zmlAOi2MdiYoxnGRTKYkXKUvqIoUJMvJkD/CCAK6I3IwRBHtJ9Osb5XkuG6cfIW0vjRTE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Microbenchmark
==============
Multi-threaded application with 64 threads that access memory(8G) at
4K granularity repetitively and randomly. The number of accesses per
thread and the randomness pattern for each thread are fixed beforehand.
The accesses are divided into stores and loads in the ratio of 50:50.

Benchmark threads run on Node 0, while memory is initially provisioned on
CXL node 2 before the accesses start.

Repetitive accesses results in lowertier pages becoming hot and kmigrated
detecting and migrating them. The benchmark score is the time taken to
finish the accesses in microseconds. The sooner it finishes the better it is.
All the numbers shown below are average of 3 runs.

Table 1: Benchmark completion time (lower is better), avg of 3 runs
64 threads, random 4K access over 8G, mem on CXL node 2, cpu node 0

Config    Time (us)   Time (s)  Speedup
---------------------------------------
C1       97,165,273       97.2    1.00x
C2       40,378,842       40.4    2.41x
C3       95,431,823       95.4    1.02x
C4       40,455,945       40.5    2.40x
C5       41,289,646       41.3    2.35x
C6       64,260,194       64.3    1.51x

Speedup = C1 (base-NUMAB0) time / config time (>1.00x is faster)

Legend:
  C1 = base kernel, NUMAB0 (hot page promotion disabled)
  C2 = base kernel, NUMAB2 (hot page promotion enabled)
  C3 = pghot kernel, NUMAB0 (hint faults source disabled)
  C4 = pghot kernel, NUMAB2 (hint faults source enabled)
  C5 = pghot kernel, IBS Memory profiler, pghot_freq_threshold=1 (NUMAB0)
  C6 = pghot kernel, IBS Memory profiler, pghot_freq_threshold=2 (NUMAB0)


Table 2: Page migration / hotness vmstat counters (avg of 3 runs)
'-' = counter not present for that kernel/config

ctr           C1         C2         C3         C4         C5         C6
-----------------------------------------------------------------------
M1             0  2,097,152          0  2,097,152  1,966,188  1,444,783
M2             0  2,283,787          0  2,097,152  1,966,188  1,444,783
M3             0  2,097,152          0  2,097,152  1,966,188  1,444,783
M4             0  2,097,152          0  2,097,152          0          0
M5             0  2,283,787          0  2,097,152          0          0
M6             -          -          0  2,097,152  1,968,079  3,508,998
M7             -          -          0  2,097,152          0          0
M8             -          -          0          0  5,654,097  5,422,763
M9             -          -          0          0  5,654,097  5,422,763
M10            -          -          0          0  3,439,001  1,701,889
M11            -          -          0          0  1,879,453  3,105,182
M12            -          -          0          0  5,654,097  5,422,763
M13            -          -          0          0          0          0

Counter legend:
  M1 = pgpromote_success
  M2 = pgpromote_candidate_nrl
  M3 = numa_pages_migrated
  M4 = numa_pte_updates
  M5 = numa_hint_faults
  M6 = pghot_recorded_accesses
  M7 = pghot_recorded_hintfaults
  M8 = pghot_recorded_hwhints
  M9 = hwhint_total_events
  M10 = hwhint_dram_accesses
  M11 = hwhint_extmem_accesses
  M12 = hwhint_useful_events
  M13 = hwhint_dropped_events

Key observations
================
- The base NUMAB0 vs NUMAB2 numbers clearly show the benefit of promotion.
- pghot-hintfault matches the base tiering case both in speedup and number
  of promottions.
- pghot-hwhint also matches the base tiering case both in speedup and
  number of promotions.


