Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC31C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C8F6B0093; Tue, 15 Sep 2026 23:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667246B0095; Tue, 15 Sep 2026 23:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B256B0096; Tue, 15 Sep 2026 23:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6346B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:08:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A82B6120522
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:08:35 +0000 (UTC)
X-FDA: 85218142590.03.122BCB1
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012062.outbound.protection.outlook.com [52.101.43.62])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7426D16000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:08:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZUQ0EdQr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 52.101.43.62 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789528112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSHpX/5mMSgmF9zwtmW14QBzOh2lq9neo71E4KXfU0s=;
	b=fhaPlo81UpgiXj+Mwrci0s5WbEr5UZrlrIZHL0nkqFaMj5IlAFKiMcsAg6Y/LrIRbNNyKv
	lv3A8dNXcnXJiflNCLS4Gp2DzBfXo+YoJsP6QujQ0POowqR1MshLfgnTYv5UpeDoUkkbXG
	NiueY49aaCtrYSBbCYzltzXzxbCcK8M=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZUQ0EdQr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 52.101.43.62 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789528112;
	b=SPlXHQHP593DwmdByY6+MUvohXnPXHMIbT7NU/7HW2nh8lPA88yQVUgbtm4MPQiJTkuCeP
	YlWN3zUkV+HgfRiLuTN5bzK9Jmckdko1QnjyFmX/DVAWQgdYTX/eUVT0OUyZlV+oqtHuFu
	x0vGvNO0cvvQ/idJ/BfUvI8D7fdL3Mw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ptrt7kQScvJit/5g12NDcVF9aqOkS6PQpjKl9+FSjTWuxF/WFt0gdCdVBYT9Z+bJKT/FjhPyorl3qqSQb7zQv0FdFd4IxrPjxl3eSK/6WLUPe0OnH+ZgBvOTsa3yXm3dBICUT02EW3gntE021LkQTAuWAnQk14qqNpfVlnpZ11ds7b/0tnw6IoPDGfeMOjKHrXIzWzFZSuf31Jyr23+I8cKWcBqL1NkAWfqE7zkT4bcxkSOYSHoKQhxOVuxX60OaJ/2orzmxf5uix/vxnQ+neUtbRruW0V0TTwJNWDglsQy4sC8S6IPx4q3aLy2oltrfsf7Pyzm70iILYsEHKkAeBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSHpX/5mMSgmF9zwtmW14QBzOh2lq9neo71E4KXfU0s=;
 b=JM/a5Rp56Hg0rgBkPTFe7IY+bZ/XD2RnFu+Tj4/96eatxmS/zxEbOUGw7NYRZvWbfPJfavL2Izfo2K4roizaxitkaow7UTZ8S7U2G/4nbHNjm0yXEo505neB6JEnjxH6G3CRDrqJnewRxul6uv7IXLJN1tl37XWATviU7Jodp38NWgidcnsYv/ealjAaWIlgd4QLPBjgRq0XmyKB7n7rwUv2KuM97YO/LvmNMYRbWpqvNzBpSUobREQ/GOGgisqjTfhx+a3dSFGvh+WZ5NZW9DhDg+kcWR8BL/Ygln/gdgqGkCjcGDbu8KHaHthWuytlUnm2r2JaPeVV9OIVBwy7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSHpX/5mMSgmF9zwtmW14QBzOh2lq9neo71E4KXfU0s=;
 b=ZUQ0EdQr5mdVDgSGhf7SNMM9hlHVom2CIYyHG8v1UD52yZAjrgs3n0p9PHedG+N15/ig0KbXMaVmtD+RXs8mKKZjJdRFCOB90DyfFddR+1HgaK1qaUZwJz4d1jUW1StlARMZTqGITN6Eek3W8F6FmYeTSL3KcT1bDPrkrXzASRw=
Received: from SJ0PR13CA0006.namprd13.prod.outlook.com (2603:10b6:a03:2c0::11)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 03:08:25 +0000
Received: from SJ5PEPF00000206.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::a9) by SJ0PR13CA0006.outlook.office365.com
 (2603:10b6:a03:2c0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 03:08:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF00000206.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 03:08:24 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 22:08:23 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 15 Sep 2026 22:08:16 -0500
Message-ID: <f871efd2-06b4-493f-87cc-919b6e0945c0@amd.com>
Date: Wed, 16 Sep 2026 08:38:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
To: Joshua Hahn <joshua.hahnjy@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <byungchul@sk.com>,
	<kinseyho@google.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260911210859.1359875-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260911210859.1359875-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000206:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: e1a53a73-fb35-42b5-2a15-08df139fc5ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|82310400026|23010399003|1800799024|10067099003|6133799003|18002099003|56012099006|11063799006|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	OPN/6dv4TLuaMh1KCrpFwwWsp/LSxirdKd02Bw8203JjMPpauIcGajstegxM6vaOt73NWWbLb4IgSA8uRjVqDZt652Mwcc1yOMOH4d0fajOPKuMVYg2m69yZEaTql+rPdcAGaQnY8Rg4hs+BndsfT3w0YngiJzTSzj/NVd7C/oBMNYdFOFryrB/CraKuS21ELB53rVwS655Cz+A1BhgiJdwSsral+6ok2y0UIHkXvLTBdtYi9zeJOZ/yoJDQQVPSqIhvAKIgQSZ9kqm24w6hSbrN64+sEa2qjYfbMDtVl4ZDG1wyaUOgymD5yocAvnwweMhg0LtF3jrlDPNeW873/jbYcPx4KIimSVf4rkMO17V4BeownBDYXDJwBQ3PdQtA4X+H9dxB7KnJvA5eThonXhwOhom6fpaEbM04SCxtjsfli6Ns1CaA7tb1EVcms2llSc8NQBAuV7heRSiln50tMcWgxPCsixMnsBVE7tPOPZQ2Lt7SPSS8nOIAi9BU3iSiayt5EL7/Wwd9554h3G/1+6xgG4NVOC+jfmmtxElYA9ha6P7ieyGfS86EpF4ZBE895pKqlzjleKkYOI+VE88OXSdX9KinZ0RTDwILBL4EUeAhhfgHyneYw7foNh1tPuTK019U+w/Ew9YB1JkEMSM6gY5Gm8lKKqiFKFm4tdFPHRoypT1Md5sGyA8PGT0McjIwrsIoUf7nQ9OqwCZ4Wb8qwQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(82310400026)(23010399003)(1800799024)(10067099003)(6133799003)(18002099003)(56012099006)(11063799006)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4yFLT0s8OELjPqFum2EEH2LAUeyCsLsEvICBVM3csRHztXlZ27PVqOTVDgiIEfY2cMTZ+wpvNGHtnXuqCbZNlzNh/ZX8ST8Js7QlnHrlUD4FwtY/+ftXpSyO+pfc58e/DkET86VJJOaZP9pLLxNKV0uSfTSsIVekPGvbyDxU31xKBxhBvY3wOOEe109fOggJNRWwAy9rOUIo4QDHVMz60YRRLOgDparbH8Hl+fCVGV8J/ZCHb/oMmvmhlFas/1tRkwGVgKVI5NyPgepJ/YCVJJuIuoL0eRgnPqZ1iTSlKdlMEUXdU967J6AtasNP3JqLSZN0ORYVwE0qttNrLyr99bIJYLiZgGj3fm6MVs1NdN2aa9OOCr48FFJMBkjWCEWppdck7TNqFHeBUXu4FnjbH6LXIeuenswhMiEj2i2fQivkPy40J3KgnHfqo8LAoV71
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 03:08:24.5758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a53a73-fb35-42b5-2a15-08df139fc5ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571
X-Rspam-User: 
X-Stat-Signature: f4o3edgm8awxxen5w3aqsidabsyukin8
X-Rspamd-Queue-Id: 7426D16000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1789528112-160824
X-HE-Meta: U2FsdGVkX1/Y9Ks1elFvj/WOcPBTuEWu2owLqJwOCgAQWihWVjmqivmCy1pLu3glj+aB5jkrtlBKL+DSxoF/Uyhx7Fvn0zlWRQ4VG1Aid2Ti7XoxlHrJlchRGhrQ39+QnRVPyLFlPJLO4H9k1NLDuWptG698kgLHUJ5eaod6mmbbP7B8uyZj8YHHi7fZopNemylB1rbH9rboO8mjwabfQ4obLnH9HqXQat+eMl6MqbFheVADVop1YGpG8wsRLJNmz9MG83R78ziyza4Dm8qwHwVzpOEifUcvvGucFWEZUtoomeBR5v5LXJtLMTvf818Pr6AimgPRJF+UFiVJ91RLXgDn/FuvSuJwspHSk5ikj45a7/0N13Z4d7RbV9scN9sexkTxRiCATW2ydoKfkjkC2YmLi+IwwozI0LoexBJ/2IeFu0ZMzoN7ossUYdwUmELcSvegHyR64000S6a+wh73pq+7sIXZ+Kdie3UVp+iHQBwhvBi4zfafrSUjxw1O1haKix3+2ksHRuUD5tT0qoWiIH4+h4LERwZ21bBSutskIxXRk1ZdIO7CvwvdM2dJn4o0Rz7HRc6usGNNsNXB141QkpPI2zhmvyVfeHGR8jxpX/qpr0QeFa9J/A9wsXCiImzB16A7rW1W/wMOVyS1BlInGyEi4n5qFAt6t77fMmw5bBJ/+OQ5U5JKj75uFrJS/ec99OKIBTtpE+yHrc5HkYOuU1INs6EdJnai/5TBjjDjvhtnqk/XIlZEYaKRxQrTlRgIWRGH+17nsvtlGmRTc15BlQm1TYm99OGfO7M6b+Tq6YhQeexiNU6BX+YqvpLO9BfkbGXvgQTPPfkP28CoUQEVbftPGRyyWKalNq7O2zANn4H9PM0YB4ZhZ1nVOdmUCRw8U47x2dsQpmJJTiDHJjp6bfrS9Lk0ZQdhV4LfWoZMyuuXPDA7eB6v1MBYUyIB2JzEdXp9We71TDs9+xN39hh
 X30d2MPP
 Hj42wVFGQNWXB6kjJeTF9Zpj/EW71wj89j6t94Pc6ZJG6W1kEVkcyfzpWUB9I9dN48QVaeG6GJhdOpOU0QosBWiS4QGXvp9JKX7P9FOv6U0pk0IROougVoi78eRan0xtMSy/poVJu2/wiNWEa8JYft5AsMFdJFqlu576IcYuVOtP9/F5QRZyuF5sgAL0NHFYz69Q9+FgA1XimCf96wc4pPZdkTwHsZoH3tuIiSM84Dhy0nJlJV21NT3dK5aVHI11vVd0Hoj6z1+OeJlh2T2+OR2sNSOMU5UJpNt+9gDAHef0kMEV6soBnknNRZddD6Ka/bvRabeWN/C6bNXjECmwgLDbb6noWMApezIPA4xgacEGZVNvXTT/cqtTqJkOwVOeeurxfgdtTsvlI1RgWhDklC3zVyIDeQuXxLqzI6glHMeKYUTwJwdB1orcB1P8ofuLP7fRgDUj3fK/jRMIOnMCvJSCUNSGngWgjlFeI8k/hr6l/YH5vrQM3BrZkuQNDTRzAB0zkj4vH9CABbPdfORW6R93a0WMtED/NhXDfeZ8kg1XOkJj4EBX/+hOPbLCcgSfHTkreglb4Yf5TkN+Ez8INLcnRRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12-Sep-26 2:38 AM, Joshua Hahn wrote:
> Hi Bharata,
> 
> We've been testing pghot in a Meta kernel with worklaods to try and see
> what the performance characteristics look like. I wanted to report
> some of the findings that we've found in our testing. Note that these
> results are from a modified kernel that has my tiered memcg series [1]
> backported, as well as Gregory's numa balancing scanning fixes [2]
> as well. 

Hi Joshua,

Thanks for testing pghot with your workload!

> 
> - Without tuning and using the default tunables that pghot comes with,
>   we've found around a slight performance regression against raw NUMAB2.
>   This was being run on a host with 750G DRAM and 250G CXL.

pghot promotes on 2nd access by default since pghot_freq_threshold is 2
by default. This will result in slower promotions compared to NUMAB2
which promotes on 1st access. Could you please try with setting
pghot_freq_threshold to 1? I think I should make the default as 1 going
forward.

In any case, will it be possible to provide more information on what your
workloads are, and the exact performance metrics? Any representative workload
that can be substituted to reproduce this behaviour can also help.

And when you say slight perf regression, how much is it exactly?

> - However, we've found lower pgscan_direct, pgpromote, and pgdemote
>   rates as well.
> - We've seen PSI dramatically drop on the host as well as the promotion
>   happens asynchronously. 

That's good to see.

> - I also found a bug where the kmigrated thread isn't created for nodes
>   that are onlined later after boot, like CXL nodes that get onlined
>   with memory later on. I've been using a small hack commit in
>   pghot_memhp_callback that just checks for the MEM_ONLINE case and
>   spawns a kmigrated thread.

I will take care of this scenario (CXL node online after boot) in my next posting.

> 
> Finally, we've seen some issues with pghot causing userspace crashes,
> which leads us to believe that there might be some bugs that manifest
> in userspace as well (we have not been able to find out where in pghot
> these bugs are introduced).

That's something I have never seen till now with any of the benchmarks that I
have run. Any kernel messages attributing the failure to pghot? Anything
attributable to access reporting or  kmigrated threads?

Any clues from coredump or gdb debug of userspace crash?

Were you running your workloads as part of a non-root memcg?

Do you see these failures without [1] and/or [2] ?

> 
> Thanks for working on pghot!
> Joshua
> 
> [1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
> [2] https://lore.kernel.org/all/20260911001826.2109390-1-gourry@gourry.net/

Regards,
Bharata.


