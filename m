Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDFBC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C286B009E; Fri, 31 Jul 2026 13:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C356B009F; Fri, 31 Jul 2026 13:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D62A6B00A5; Fri, 31 Jul 2026 13:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06CC86B009E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:44:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B51A880475
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:26 +0000 (UTC)
X-FDA: 85049602092.28.BDCF7FB
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	by imf04.hostedemail.com (Postfix) with ESMTP id 785DE40003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="YZOGvkh/";
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.93.198.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785515243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZfDrsIMLBpL/+ki7SmqWEz6eSacbKM86/67sV1VqAo=;
	b=EPheHe5NqpS1axW2xWlXqVYUJ8KRHjUZPBUGrrpzipO0ZqMVHaARwDuU8rZX/G5Oyxy029
	NIoV/UhxmyV56835VQyc/Z5x/dD1OfDzGMNYOJDxqGxq/omfHGIwZDOYpnanqNmLNNWVWt
	11Jc6eTn2OU1APGhmCS+CCoW0cjU9hY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785515243;
	b=o/Cw3y9zUqzL2gDswZCfz+cU8zxIXP5S5mEB4jSkEq7JmUqiaAAah2CLX0wl/XkX39Io6X
	bSmryft8Pl5ZdQktL2MlL6B8a1MxmmM7vTHwQgJJ0kscW+QuYFxODheX3sCvnyMPtQ4ZZs
	Cun4dxGXyaaxwIhda88h4J0ay8quDsM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="YZOGvkh/";
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.93.198.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQ8RFWNBdgCeVaK6JaIisrpLEQtWKWmYZLnOpDjtE7wM9gfyHR26HLT0HMvMinCD6MTQZ4jHeCKPQJG1tuvh2fFiBlhKIW3NSnw9r15bzAgYrmwO2Lok8wvJgRHmXp/JIJNui0SR07d8HWiSAdVo4kLbHvCIQATilUQbhm8rvLswZuDoV7WuLb5px+FDDMw7qhF3tE8kshuLRLW76YxWw2jXHOoxGKPAAu8f5v1S7CjWpwV6LWN+xmRcfmPtc+xFll5obQ08ZuHTAUXbZW3hC6ItlopPJqyWB4QAtDo32dPIiAk83BuQT4Wlpyj2vvql1Rqnu0z/Edcmc2QB2Bfq6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZfDrsIMLBpL/+ki7SmqWEz6eSacbKM86/67sV1VqAo=;
 b=gNOJCl37EBH08GA9LHTL4Qpt0o4eBTwrpwf8Y5JniDQayblF2Vn0mkh1YD7K/lVBUOScPMplgpwmlFyA6aqMLxQM+pfkDxvqXLfsbvXv2n2tUJtPshT+snN/sA9QIetCI24gHj6xljjctzBV5DMP1eKc7OxeFOPWRH13pfqSrxoG5rj98uL5M6UlNv+Gacw0tnrccNo4C8bifIad+T9ydKZ2lloDqtGal/9AnIty8uNcFdTLeVlndLfow4h2ly4ouNTDlcocVvqMidpG/C9IjHvv2uVbgFDsZE997GPNmaBXy4twSKHxwsyLE/1QUG0XQvLUE5TbvDcY+XfJOAi65A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZfDrsIMLBpL/+ki7SmqWEz6eSacbKM86/67sV1VqAo=;
 b=YZOGvkh/0I6/tmBdgd1H91fb4tpygubMrZyovPNzgI6BdeK9AS2gUpEfTPoHYZl7te+1SD/Djt4QdmVl5l3ZCoducwNqV3alUf5TZyU9jrU3Ef7MFzqO3XSmlJXBy8YUR0i6Y0He0WyQs4SNH4xf6zoISULI9Hs5aOVGAnTd+Ks=
Received: from CH0P223CA0023.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::22)
 by SJ0PR12MB6901.namprd12.prod.outlook.com (2603:10b6:a03:47e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 16:27:12 +0000
Received: from CH2PEPF00000143.namprd02.prod.outlook.com
 (2603:10b6:610:116:cafe::3f) by CH0P223CA0023.outlook.office365.com
 (2603:10b6:610:116::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 16:27:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF00000143.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Fri, 31 Jul 2026 16:27:12 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 31 Jul
 2026 11:27:11 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 31 Jul
 2026 11:27:11 -0500
Received: from [172.31.176.217] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Fri, 31 Jul 2026 11:27:04 -0500
Message-ID: <e664f8ca-05e7-47f4-a5f5-107f64883924@amd.com>
Date: Fri, 31 Jul 2026 21:57:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/8] mm: pghot: Precision mode for pghot
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
 <20260728054356.291998-5-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728054356.291998-5-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000143:EE_|SJ0PR12MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: 55e39e6d-980f-4031-aebf-08deef209347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|36860700016|376014|1800799024|82310400026|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5F5WcbJsPcou7hJGz8qflbRttD9TmE392eNVwk239q8mYik8WhbYIXDtpzzCnUKvrjMvUSB2I/SRc5rdz/fewtPTh/lRLdHTXHnXxdd7DoNAic9TlSTZy6eXZKrWUxbEYN+zsqGYolaDM/Yng77djqSVjqbg3crzbsy2rMmtIDcsHZ2ZkpK4BwF0vDnjL0cD+iSEeIqh00G7QVT1nI2/fhecZNnvKTFvebIOys332LkDlWRuVgulyQ2PBEhXrMlkuEZRMYrWZoMo13yCxDK7LTVKFjWWPSfNwC+IOZF6iIxa9sVHIDlSmP5HF7Gsb8R5vZrgzWFLHSvHUEx1etSOQYJiWVKQ+jnWIsYDApKlpf0lnhDzvRdsYWnvvUJ/I7bZpjmu1rbRN7puL3IY+lOcfjx+s+dlSw/QVD0U+MNvzHbW/WDN6Rboki2d+QPpi5x1fIPLyaC3simZHlz7R8cKVbr91Tm19g6pRxeFPaUWL5lAVL4PU7pNdzs+MTjGbHr8cjT1J4xGk4JhWJ7CZVVK4p6tW+LfLzHw3p2z8+AygE20WMCEXuog35W54HLz9HsdQoBgQZKfQsbYDuviFEAiLvMm4mJZUrs5IpBfhRsISmUVxopB1WSUob5Aye98yc0R+zFkyP9/JJAlgw+UL7i/TzlOUBwPKtS70Uw97Qz1KO7a2l/742Y5h8m1hTRLP+3/XgiNPCZ3ilR4eFWh04p5EQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(36860700016)(376014)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qdNY4/qhnnGAB3KCVjBelob4QnuihU0Vo7yr61lY/pixeamYjg8bE29kjqrdeLkbbSC5fCCu0s3H1aQowkxKHBnwnUDisf1Xm5i581ES64XWg1M24zUgqgK32SHJNvMCeWKmi0iWzDELO3EyKVfk5qmJJTzioCF2O4g4ppsaAzy55+RFOoR/UJx5zMMEsifzEejccsRhZUDbEXtG/s2Dc4xJVqG49OK9g+1VNCrexHjiwJ103YJVuYHabe8fVQ+tynVsvA6E11rrrDAw0dROSuz62oqjdZB4JNuHKHpBRf2kQdViprXtPsOlF2qz2uirb1InsFeROir6hV/qkuLgEtZbuQKq9n+c84LzaDe1bbwPposXJ0dw16tsNIx0NrBTSAvqdVclRBiwXFI7iNNiaM66CrdVwRU4/ZytJBo0lk3RJbQVO2f24nWQYd0CIqxs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 16:27:12.1573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e39e6d-980f-4031-aebf-08deef209347
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000143.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6901
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 785DE40003
X-Stat-Signature: xq8ekrkox5pt8deyqj46okswafrbg76a
X-HE-Tag: 1785515243-472456
X-HE-Meta: U2FsdGVkX1+iNulUNaR65LaJ8UCCCYq2O5o2K1zu5zDFrvjmFocZxfbD1y9xn87RqJeVL1wvogFB7bihYEWkUf7xrKECXc/G9sQRXiSt7WPU8F4/0Ul7uO0I3pjJX/8alsOS1yHa7+RzSKcllfIjROv4jXVXyUhQS1A+lYHvG94V7rf9CKxLcyyRf+oVMAi+gztv4f5VqNZDxDfPO5qSbDRY0xw0AIG3fqXOzQYgnanVdaf5b/gSJU5Y6ic5Z2HpF8orIays2Ia0hFPsTVXC97IfR8mthqV5YbzzZLG75S/hHHiVQ4BZUPbGmUN20u/nRGLuhg4eoZkhfA+WbN5070bvlIxvgT6QGWcSHO0Oyt+D0MJQrYTMmzG8v0U0n/Gu4vQ17aApgYRw+svkAZCDK2Po+QvB+RDedtM+SfcmWbGSzLyGCx/fOikfsH851k6sJYS75nGdYLvOYJE93xLmQAv447gbW5qlX8vb626aIB2zdw9HzGJ/huhjuazIG+lKcSpyTortoxAWK6Y889sw+9QquZTJR78cDFRU5pYt9UxekN0ehfDzn4zpDCtXaTB1/aGezzMcUVuuMh56gKtkBWS0M9zQuZEfY6vvtBUDGDWDEfjrBITFaoMZnc0Y/ibD/BzeyO0hXTaVFwENHPL3pT7bY5V8WtMqVGyo470b/WRSipz/ezldZL5+VSSwKWdrDYOOiH5Kl/Q1CBkBDZ66uKXQPsT2Z0890tHr+IFmDPnlp4MqEfIqjyAMsxwjutRymnqWMr4amsLPZSO9TuSrcs0sifVCMi4RgQQD5L9oDTppkhJFYVwS1DbDODS8Nl9pVyc+hQnYwN3WZidaoaL7lUQ9qSy8mkR8aupsrtlikjWMxrPciWxStSx/3p8C8XYQkZKKhmPMEM2PtAABXrzkPQqloDGMcYcqonVNw+Bln2TWZX3pwPe4ZV4yoidck8QvkEBnC63Hbg6wPTdvuR2
 upFOPOIu
 yWI6F1tBlzL4t+ULrTeJQvbBugVG0P+M0aOw0YQb9NO0EFNx2FaIuuwCUKryNqnRA09eA3YFttmCbvVtLYuNr6nBBL9ACdCto5mExtyVLMqQxdfqxmeoQPT5XZoXdCilQWwokVLB6CNriRmxGWBdilTgp3SpC40TjaMkqgLXM7CyDJWEh+BWnKzxMTcQ2sjjt+Nyap3rVDuYeXpT/jYNmt8Nm+H4+oAnJsjSgOa2qeGoeicAIJPnW09ZTg/7Gb7vyAJAHa86biXHyBEHUyVqDUuQh8kdhXDPCv+aAt/ZXe2MFNbyPEZrcZ8zEeqXYQahR8HRy4wPyhv96RrJTJaMy2sOhMmiN5iLd51OyTmshsI+/3oisMEKiZjO9qCer9mIlQvaJQFWTlfnVW5kZfX01EwOvKgGlJIB9wspiB2Ib2Htm3P8FLrrzXSTKqpexLkD/6KVZ1ba2YLHvr3ihSQD13En3x3IVOJ7bjCwdykc5oqoFeaPQ2bPfuX0UPNR5vKd5BmsT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Reply to Shashiko review]

On 28-Jul-26 11:13 AM, Bharata B Rao wrote:
> Default pghot stores hotness in a 1‑byte record per PFN, limiting
> frequency to 2 bits, time to a 5‑bit bucket, and preventing storage
> of per‑PFN toptier NID. This restricts time granularity and forces
> all promotions to use the global pghot_target_nid.
> 
> This patch adds an optional precision mode (CONFIG_PGHOT_PRECISE)
> that expands the hotness record to 4 bytes (u32) and provides:
> 
> - 10‑bit NID field for per‑PFN promotion target,
> - 3‑bit frequency field (freq_threshold range 1–7),
> - 14‑bit time field offering finer recency tracking,
> - MSB migrate‑ready bit.
> 
> Precision mode improves placement accuracy on systems with multiple
> toptier nodes and provides higher‑resolution hotness tracking, at
> the cost of increasing metadata to 4 bytes per PFN.
> 
> Documentation, tunables, and the record layout are updated accordingly.
> 
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> ---
>  Documentation/admin-guide/mm/pghot.rst |  4 +-
>  include/linux/pghot.h                  | 39 ++++++++++++-
>  mm/Kconfig                             | 11 ++++
>  mm/Makefile                            |  7 ++-
>  mm/pghot-precise.c                     | 77 ++++++++++++++++++++++++++
>  mm/pghot.c                             | 13 +++--
>  6 files changed, 143 insertions(+), 8 deletions(-)
>  create mode 100644 mm/pghot-precise.c
> 
> diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
> index 0edbe0082816..6d9b3d9522d1 100644
> --- a/Documentation/admin-guide/mm/pghot.rst
> +++ b/Documentation/admin-guide/mm/pghot.rst
> @@ -56,7 +56,7 @@ Path: /proc/sys/vm/pghot_target_nid
>  Path: /proc/sys/vm/pghot_freq_threshold
>  
>  - Minimum access frequency before a page is marked ready for promotion.
> -  Range is 1 to 3 in default mode.
> +  Range is 1 to 3 in default mode and 1 to 7 in precision mode.
>  - Default: 2
>  - Example:
>    # sysctl vm.pghot_freq_threshold=1
> @@ -68,7 +68,7 @@ Path: /proc/sys/vm/pghot_promote_freq_window_ms
>  - Controls the time window (in ms) for counting access frequency. A page is
>    considered hot only when **pghot_freq_threshold** number of accesses occur
>    with this time period.
> -- Default: 3000 (3 seconds)
> +- Default: 3000 (3 seconds) in default mode and 5000 (5s) in precision mode.
>  - Example:
>    # sysctl vm.pghot_promote_freq_window_ms=3000
>  
> diff --git a/include/linux/pghot.h b/include/linux/pghot.h
> index 7b85d717f410..313e5a6973e4 100644
> --- a/include/linux/pghot.h
> +++ b/include/linux/pghot.h
> @@ -37,8 +37,40 @@ DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
>  
>  #define PGHOT_DEFAULT_NODE		0
>  
> +#if defined(CONFIG_PGHOT_PRECISE)
>  #define PGHOT_FREQ_WINDOW_MIN		(1 * MSEC_PER_SEC)
> -#define PGHOT_FREQ_WINDOW_DEFAULT	(3 * MSEC_PER_SEC)
> +#define PGHOT_FREQ_WINDOW_DEFAULT	(5 * MSEC_PER_SEC)
> +
> +/*
> + * Bits 0-26 are used to store nid, frequency and time.
> + * Bits 27-30 are unused now.
> + * Bit 31 is used to indicate the page is ready for migration.
> + */
> +#define PGHOT_MIGRATE_READY		31
> +
> +#define PGHOT_NID_WIDTH			10
> +#define PGHOT_FREQ_WIDTH		3
> +/* time is stored in 14 bits which can represent up to 16s with HZ=1000 */
> +#define PGHOT_TIME_WIDTH		14
> +
> +#define PGHOT_NID_SHIFT			0
> +#define PGHOT_FREQ_SHIFT		(PGHOT_NID_SHIFT + PGHOT_NID_WIDTH)
> +#define PGHOT_TIME_SHIFT		(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
> +
> +#define PGHOT_NID_MASK			GENMASK(PGHOT_NID_WIDTH - 1, 0)
> +#define PGHOT_FREQ_MASK			GENMASK(PGHOT_FREQ_WIDTH - 1, 0)
> +#define PGHOT_TIME_MASK			GENMASK(PGHOT_TIME_WIDTH - 1, 0)
> +
> +#define PGHOT_NID_MAX			((1 << PGHOT_NID_WIDTH) - 1)
> +#define PGHOT_FREQ_MAX			((1 << PGHOT_FREQ_WIDTH) - 1)
> +#define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
> +#define PGHOT_FREQ_WINDOW_MAX		PGHOT_TIME_MAX
> +
> +typedef u32 phi_t;

> This is a pre-existing issue, but expanding the size of phi_t to 4 bytes
> significantly worsens the reliability of hot_map allocations.
> In mm/pghot.c, pghot_alloc_hot_map() allocates the tracking structure:
>    hot_map = kzalloc_node(struct_size(hot_map, phi, PAGES_PER_SECTION),
>                           GFP_KERNEL, nid);
>With 4 bytes per PFN, the allocation size for a standard section grows to
>over 131KB, requiring an order-6 contiguous physical allocation. Since
>high-order GFP_KERNEL allocations frequently fail under memory fragmentation,
>could this cause memory hotplug operations to silently fail to track hot
>pages for newly onlined memory sections?
>Would it be better to convert this to use kvzalloc_node() and kvfree_rcu()
>to avoid the contiguous physical memory requirement?

Agreed. Will switch to kvzalloc_node() and kvfree_rcu().

> +
> +#else	/* !CONFIG_PGHOT_PRECISE */
> +#define PGHOT_FREQ_WINDOW_MIN		(1 * MSEC_PER_SEC)
> +#define PGHOT_FREQ_WINDOW_DEFAULT       (3 * MSEC_PER_SEC)
>  
>  /*
>   * Bits 0-6 are used to store frequency and time.
> @@ -66,6 +98,11 @@ DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
>  
>  typedef u8 phi_t;
>  
> +static_assert(MAX_NUMNODES <= (1 << PGHOT_NID_WIDTH),
> +	      "pghot precise nid field too narrow for MAX_NUMNODES");

> Is this static_assert placed in the correct block?
> It appears to be inside the #else block for CONFIG_PGHOT_PRECISE, which means
> it will be disabled precisely when precision mode is enabled.
> If a kernel is compiled with CONFIG_PGHOT_PRECISE=y and MAX_NUMNODES > 1024,
> the compiler won't catch the narrow NID field. Could this lead to NIDs being
> silently truncated during runtime, causing pages to be migrated to incorrect
> NUMA nodes?

Yes, I got the placement wrong, it should have been within CONFIG_PGHOT_PRECISE.

> +
> +#endif /* CONFIG_PGHOT_PRECISE */
> +
>  #define PGHOT_RECORD_SIZE		sizeof(phi_t)
>  
>  #define PGHOT_SECTION_HOT_BIT		0
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0a5bcd5d45ed..955a826ecfe9 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1523,6 +1523,17 @@ config PGHOT
>  	  This adds 1 byte of metadata overhead per page in lower-tier
>  	  memory nodes.
>  
> +config PGHOT_PRECISE
> +	bool "Hot page tracking precision mode"
> +	default n
> +	depends on PGHOT
> +	help
> +	  Enables precision mode for tracking hot pages with pghot sub-system.
> +	  Adds fine-grained access time tracking and explicit toptier target
> +	  NID tracking. Precise hot page tracking comes at the cost of using
> +	  4 bytes per page against the default one byte per page. Preferable
> +	  to enable this on systems with multiple nodes in toptier.
> +
>  source "mm/damon/Kconfig"
>  
>  endmenu
> diff --git a/mm/Makefile b/mm/Makefile
> index 4939a1a74c1d..83bac64cab26 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -147,4 +147,9 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
>  obj-$(CONFIG_EXECMEM) += execmem.o
>  obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> -obj-$(CONFIG_PGHOT) += pghot.o pghot-default.o
> +obj-$(CONFIG_PGHOT) += pghot.o
> +ifdef CONFIG_PGHOT_PRECISE
> +obj-$(CONFIG_PGHOT) += pghot-precise.o
> +else
> +obj-$(CONFIG_PGHOT) += pghot-default.o
> +endif
> diff --git a/mm/pghot-precise.c b/mm/pghot-precise.c
> new file mode 100644
> index 000000000000..df82f2068a99
> --- /dev/null
> +++ b/mm/pghot-precise.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * pghot: Precision mode
> + *
> + * 4 byte hotness record per PFN (u32)
> + * NID, time and frequency tracked as part of the record.
> + */
> +
> +#include <linux/pghot.h>
> +#include <linux/jiffies.h>
> +#include <linux/memory-tiers.h>
> +
> +bool pghot_nid_valid(int nid)
> +{
> +	if (nid != NUMA_NO_NODE &&
> +	    (!numa_valid_node(nid) || nid > PGHOT_NID_MAX ||
> +	     !node_online(nid) || !node_is_toptier(nid)))
> +		return false;
> +
> +	return true;
> +}
> +
> +unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
> +{
> +	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_MASK);
> +}
> +
> +bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
> +{
> +	phi_t freq, old_freq, hotness, old_hotness, old_time;
> +	phi_t time = now & PGHOT_TIME_MASK;
> +
> +	nid = (nid == NUMA_NO_NODE) ? sysctl_pghot_target_nid : nid;
> +	old_hotness = READ_ONCE(*phi);
> +
> +	do {
> +		bool new_window = false;
> +
> +		old_freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
> +		old_time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
> +
> +		if (pghot_access_latency(old_time, time) > sysctl_pghot_freq_window)
> +			new_window = true;

> Can the 14-bit time mask cause cold pages to be incorrectly evaluated as hot?
> Since PGHOT_TIME_MASK is 14 bits, the tracked time value wraps around roughly
> every 16.38 seconds (assuming HZ=1000). 
> If a cold page is accessed once, left completely idle for a long period, and
> then accessed again, is it possible that the elapsed time calculated using the
> wrapped mask randomly falls within the default 5-second sysctl window?
> Could this lead to spurious hotness promotions and unnecessary memory
> migrations for pages that aren't actually accessed frequently?

For the reasons explained in the similar path in pghot-default, this is okay.
This is in fact better than pghot-default as 14bits give a better range of
~16s.

Regards,
Bharata.

