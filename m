Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C50C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD5C6B00A1; Wed, 29 Jul 2026 10:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386566B00A2; Wed, 29 Jul 2026 10:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A366B00A4; Wed, 29 Jul 2026 10:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 000F36B00A2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:14:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5A61C064D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:45:34 +0000 (UTC)
X-FDA: 85041634188.08.F1B8E9C
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010053.outbound.protection.outlook.com [52.101.46.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8CE5A80005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:45:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VUYuMu6n;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 52.101.46.53 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785325531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPTglKBx2b9e3pOaoDqUACxA95GPHJ13OJOfDLZZ4JA=;
	b=Z+n1d+gM9fUZrcLb0AudXeD9ojBx7Gg+iwxZwGhWHsG48qfIhxpS0HOGhG3SebJmCiPmtn
	h8M/cWcgD1r51FB2ar+ZuS8JqSFmm81lEBWKbYc4BQAw76AbAxmPjxHXcycpgC0rj5zPLD
	jEISo0gJLLslaWSBoTCspPxn6Y3xUQU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785325531;
	b=yIDVbrzGn1lE9JFBgJWDEJfAwzop2shKWQOjKQJBBO5Hlxe0Avd+TedcqhV4j5YB8IXo45
	361vNHu9kh9UBehRzEeoQPFwUZd8BGnIb3Eri3jhmmlQ5FtqjfEXUGD1pqmi3KGXMT8h3S
	scCEEvMvHfc+B5nQDUfJG5dQThtsyMQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VUYuMu6n;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 52.101.46.53 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1pnsXKmgrHnWytw1q3tBhoGT1gFj9+sR88EEnnNoItnDYXYwq8WCyEGfCMXzwkZsl+HBXnFOJ/wxyhlW7WA1Hq/YQmXsTBuWz8Te+8ZvqBOjqCqRquSoXUFYI8Tu4nNSiHw+McOSGik9ypk+UAd3GrmcKj1/0ZnMk+apasecCfYEJCjCdDI9XSlCv3Qn1G7zilOD0zi4XOAvxaOuFOyfn4QHsB6DtCPDk9frOqnnPGiee1SshdvPBqZStoBP5EGbTFPNPB6XDhHgWBDl4/7/YO/33k1qnkAXAiv7WFjQEoEKg8JgP/kDmXQMMBqdwGudGtVh1VFk9iQi7fzjTWUNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fPTglKBx2b9e3pOaoDqUACxA95GPHJ13OJOfDLZZ4JA=;
 b=ZQMH4ycy0wUbMD/WiAbEMMr5p3TzjQroKqLc4im2WHrPwA8kKzGv8/GIq8EO4p/aIIgepukte+kY+GJz56et0NRdYaM2UcEL+f+CuA9CKFD7Ofpx/6oqmjSTd+qP3Jl3vVprtE20CLaBYFyJ/6Qqm9mkt+k/tglhpup8oXAlrxpEeu+vUGd7JI7m3hwDzQ0AwiXMbGAU0J9bn0euD7LZYXZAmbgyIWzC8H0oXryfBYWVsAG0nqqucucarX1xtpC+PNIGwSFDNXQf9g9DMgvlQvWwEHrnck7xBaAEdcT4sZvDBadr4Sk6cE6Kb7czn39e8/I47ukbFb280sbzEohnEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPTglKBx2b9e3pOaoDqUACxA95GPHJ13OJOfDLZZ4JA=;
 b=VUYuMu6nrE0wXVCG//BclkRWBJ4Kfxd63lA0OdBpeml9Al6BM+3l66QZfFkAIqszXLth5Xabdkqigv/MLKbp8UtxS430/h0+frXgyWkb2XzLBNMZUDVRb2T4xkodrGclvDqTywjDku8pe0pOYfQG06cDdTx2F2jUy1pDlBwdtYo=
Received: from SJ0PR13CA0074.namprd13.prod.outlook.com (2603:10b6:a03:2c4::19)
 by SA0PR12MB4381.namprd12.prod.outlook.com (2603:10b6:806:70::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 11:45:25 +0000
Received: from SJ1PEPF000023D4.namprd21.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::2c) by SJ0PR13CA0074.outlook.office365.com
 (2603:10b6:a03:2c4::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Wed,
 29 Jul 2026 11:45:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF000023D4.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.1 via Frontend Transport; Wed, 29 Jul 2026 11:45:25 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 29 Jul
 2026 06:45:25 -0500
Received: from [172.31.176.217] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 29 Jul 2026 06:45:17 -0500
Message-ID: <bd99633a-ce7f-493b-9ec0-c584a0ba6723@amd.com>
Date: Wed, 29 Jul 2026 17:15:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
To: "David Hildenbrand (Arm)" <david@kernel.org>, Gregory Price
	<gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>,
	<donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
 <amjz7kIDuZH6gBx9@casper.infradead.org>
 <amj3jbvruEiHIZvi@gourry-fedora-PF4VCD3F>
 <ed9e7308-09c8-4631-a012-940cd6e11bbd@kernel.org>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <ed9e7308-09c8-4631-a012-940cd6e11bbd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D4:EE_|SA0PR12MB4381:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad80057-96bb-41d1-76f2-08deed66e13e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700016|23010399003|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	rCqhYUc00jvDfB515MJpzcoq9OCPS/dI4YpT+L6mquKdskB7M1Y9vyQyfAFdRV5+mZpMpmV8JbasmVlXGlUiYdJpA77odI0z/jU6ZZujuhAnYgbYBQBKXVsQhpxO+qLPBfdHiYMh2gBmXrVwaupydrnYp4l4EEg/I1pbsFrg7IY4RIIfF+gPGSRWaJ2nI+oOediA4UE0uXY9Kvl9+lDXbxwFn5y8NIgtCnxfpTpZgLEZ4gRmyJs29YXwx1eUflnMBmW0TJ8IuUGpXaTEL/TlmjWVKqjBQMSO7c//8kT2Tje9RNRGzCkNuoohxcRsSLsUrnjbwgwS/ZA0z4mUGNXXXPUc3dErmBo7paA1KMlPN+C8ByRZWhmJH1Q0HGBJWjeQv89d8NYgfQO9LxHblD1hz7zCRJBQP2P9D/KfPLxOweO/ifUiWwfxfEID8iDQ7ycurHz+8rCDOnCUBtpK+Jojqta5oQcNDst29lmBC/eBz/OtEEqnbwlIyyVTZ6BX3c2mqLS8C5mhQpS9r3CnXTygpc0Tf3VKCmUbYeZHyLmNabEXImHYtXpYeunDFEQhejOAMF3+gy6V0LzPeKW3XS4FQRB7y/gjWE38WY8Z5DvPG0FdW1zB57mOVN8XdVgkrCc9FkwlmqeiXCYj5QwMMvdp//HmZ4BicqtBQWCXEAgwVCdoGNvIp+N7RxEAa5eRpvrWmdYB0d96wgSttLCSvkerUQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700016)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ksa7zp9I3+01IaSFZqBhuYYLAwr/4jkddxKSD94Ib16hUATIzKLuByqasKy7Rj5YQiMb9euP4zPPfOMRuLZwANXbMgmL+hnf6VJNcFn94yqf97/X6x3fb4q+3EWAPYkuEqQ9jK0HLU6zhN4evOnYFMdovHuqZd7OdpnB2Z8eL4cuDvo8hTF2hYgGLaz5HY8GWK9BX5feIwC3RGMWhh4xDXjiItMClbZuGULMJ7jtoKgkaYfv44Sw4zhhhTaRD1N03A8qNrbOuMBPpGcT/m3/h6C2qrv/EMhi9KvdGJW1ZrozqTm7GARhaFXFlRyiMbtxWNMJe/w8RUDYpJoeJrlXIFFxodpaUtIAOwDCo5DYWiOrTwCIDp8KC1VU9D19pNXCc808PLeRL1ScdsVq3+jGaf0VdVHi2SL203v8suIxKXyRPvQEC8VGuMti0tEVsGo5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 11:45:25.3588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad80057-96bb-41d1-76f2-08deed66e13e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D4.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4381
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8CE5A80005
X-Stat-Signature: r7oj6uqgiam1h5fh499dstck9i5m7fah
X-Rspam-User: 
X-HE-Tag: 1785325531-994197
X-HE-Meta: U2FsdGVkX19HvV7OLYfCGRso2Cz9g5NFJnVTzFeRMWQAavfIqAQQo0+itHaHlCDMGkSNMRUiVi9lDV035M4zVJiP/fcyGbN6SSxUhMP5GD+lHNDcC3nkNlB1iWTm5lHDvjl+dbaq0hfSfCcztmXcZ3STTbsD5yg0v6ZSbHUQ664KQycD9PB6iqJMiEpPYQgyIHoPpjUjGORnBabnKE3POccuVueUOuz/TKSo+BxwCvLzkRl1Ry5yboE4AxiOAHPXBNigpeF+vizVZWGwk6JsLmSC4Z0NpZgTsFj1g0wstiw0aNPxtWtBBcQTe/kcdM8ktIcfUG4UJt0ZxOsN1h8ZLrSrv6t71ND3RM7C9GJ1CYT/dGUjNzhTHv/8ZuFXaw2ErmaZaJu2mkG7iNHcktlsgg2Zd1k1e4ROlEjjWhj6JXKWzMO9iv49/yzGCQOe5ybS/DtWKKnypnkMZeJp0AhQWwq/G6kO/PHnRXXuyzTIJUdvRgZRcrfs2FzHJCyC/O7tisb55T/cIWfpy7768H5ZqSOu3bHxoEeGrHyXnr5jm8so92hYbkMKXhg6Mkz9avTzoDuMiuAonOMM+DugJD/MhQOeMJpdZjMJwib/iWwNZyRv8TUAvds/+udbK3EeMA8tEustcgAaW2Bk6O1Kqa6iE7ZCH8zjmq80a74sJF5mSuW8D7KhXuC2DzhZ65vE0Ucz5LBAcW8ybysDSRrnahNXio7cBmzoqLA/qv/jrMQzcbLkTivMa/ErRRTTPphUDMd8/+f5jmK29ZlxxwIWzY1ktP+CbTIOtQrjw3DO7YTXB5Rrk5XTeTUpmxrnu8uQcCwyFBmbciRqEQyUYyZ6pQDcEA0V/z7p0qXGJqmpK9B8DeJFLo8KhBA5Kp/OB2AWPjtAwihe1tOYh9RZ7pkVx1sumvZK3YDFBcXM1yJ3GgQf3fQ7HolfNLCJmBZ+gpdn6Q22usFFF9+MRRq8zFpbUxI
 H8iJxoym
 9X1M0eCa2GRoLg6AwLSeM8+nk48pthLuF0ERep41pqAk61/S+nMcFqtLsQgGLQTDXw5cQBAWgvgzZEOtmIvznrZ7X9qeTR0Pp/rOOotPltCmO4nArGiirImLHktc43GVzsnpxMKLqap9B70+C35UKiD4O5YzWOhdTBmQnG1+l5sw06m8wVTxGEoZGn3s6FcGkE3WfrQbV2i4q0yJEMczoJdcU6H+hNk2e4cGFaMqxYEDWLIMC0OMN4ZJkCynWMnFKfA5DyASHHjIj5SC2pv6JJFoZupVLZlhpLmMHDGP9z41OsIoojbeVHFPncl51uXkuR32snwjm7UrszOQYhrYroJr8gO/yKpzULrUuldk95lhxcaHSaTELZNOk4YpDuSEjEI12sb0Deu9vCLU22sIGRfzxN4fTyGS3U3mDqOSaF7eVhbcctb7h9GT3mvTTPrtVrTgHeEKx/2Ed2krHbXrcIJKKSa1tpxzF/64/KjdGQssaSMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29-Jul-26 12:50 AM, David Hildenbrand (Arm) wrote:
> 
> The diffstat is scary, to say the least. And the x86 stuff certainly needs x86
> maintainer acks.

The diffstat can be logically grouped into the following 3 sets:

1. IBS Memory Profiler: A bunch of x86 specific files got included in this
version when I switched from NMI to using fixed interrupt for IBS Memory Profiler.

2. Many of the files in mm and all in sched are touched due to moving of NUMA
Balancing tiering mode (kernel.numa_balancing=2) from scheduler to pghot as hint
fault source.

3. Then rest of the changes are due to pghot core.

> 
> So far there is no real review -- we're in v8 without a single tag.
> 
> So this is far away from being mergeable.
> 
> I'm afraid this will need a lot more discussions, and likely RFC would have been
> still appropriate at this point.

Noted.

Regards,
Bharata.

