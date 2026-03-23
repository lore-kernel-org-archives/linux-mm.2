Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C4BEC01BB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007086B0005; Mon, 23 Mar 2026 06:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21386B00A4; Mon, 23 Mar 2026 06:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E367E6B00A5; Mon, 23 Mar 2026 06:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D10456B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:11:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D554160AFE
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:11:59 +0000 (UTC)
X-FDA: 84576911958.16.CA4E0FC
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F0E2180018
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:11:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=z4MCYwIa;
	spf=pass (imf06.hostedemail.com: domain of bharata@amd.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qf9UuHu5+ZzKAwYDV7ZnHCPgyBotrFroS/SvFhKVo5M=;
	b=us/zgelm0R4Jn++WzCYpqkfuqz8Z32KCjDOjNxyoOWxOAoboAqC7YQPox+gMAQ395B/PcI
	tquwHI+9SEXDUgKRV7GennQZ+fn+jgWz/I6D/uZnaJcLT1T1QUAapeU/JLiI9y1VccruIQ
	tz1aOfRg9Pw1+oFHDzaJ+ClvkuyTTe0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=z4MCYwIa;
	spf=pass (imf06.hostedemail.com: domain of bharata@amd.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774260716; a=rsa-sha256;
	cv=pass;
	b=lFfSBvqgJJEAZmThtxJEiUqfPyTuff0mJXIRkgF0/NXwrO+gCOni+mesqFRgndFB5U0xuY
	tvbIOGY8w5IwV6zWTPs7qpLCYzGA7NlxkZwyqcRxvq+V80PnGwKvtWnGLOlKd2kkLMFTUK
	SCefEgTYjaTAYmeHlWpCs73v4QpU3ZM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8XZYoV+ZJ4Rqs1KMd5hmu5OwpdcbeTODAzY+exmC/YJv6pvfpI6dBpOnJvPa4UFkyKIdvT6qFAZaUdoubpBp+jSf8dqe/FNDBeV9wg+7+RjDabX1FsMeYAXPZ9dP0Umsy/zPHc/VafvEdLcMOiaYXvwPjVhH2ckpHOA9gGTeAsrxu6TiHnwwVHbWJKr0RlVBeqyy+iCezSkEReHZsmjcj/zzz5KNgnSOv6r02expmUB83/hnl0dtC/o6gPswE7a0eyzXZ8KOCskT7g9vFY5Ev1jMAOz3FOW6XRUWVkwXhqo+C1mbyC7Kwckamnc+aSO78xOWOgPHi7Tf7kovyCjog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qf9UuHu5+ZzKAwYDV7ZnHCPgyBotrFroS/SvFhKVo5M=;
 b=VPAUf0J5NQFxU+5GumL2c0PgeCyju6/4YTR3fW8++azdnAQhZvmPiMpB9gWJ1YuThljAdjeLNAZfKPmfeoCJ0PRS0fjoPfLRWaosxHrjDmKstLzy0WNa+8jEXvwfN5PGGdQ63gnJOEP74UaDhrpJFpzhncgARLYdqhSaMAqZL76FkAd8qAcavyIRZMakiQ2wU6PH3hOsqivmjn6u87SM5nKvCInobCRlP+UeUSwkJ2ZuJCBhcAnufCCocdkmwB53NK73jcHvpG5GV9fwXrRwyxNpISIMLYKKbADOjwkLf0mtd7f+Sf0KWcyh9BFheqK55tqgz3dK1aVrHYlHvDYAxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qf9UuHu5+ZzKAwYDV7ZnHCPgyBotrFroS/SvFhKVo5M=;
 b=z4MCYwIa9nkGjWhMeAxNwoksxsEAC4sHi3911de7BXNA1XBZFszbz/1u4W4vocwjsIMMXd5bZFX2xCcWkxI41//wOslp2AjH3g5u+2K2VExonFraJqbmQy59BW5R7T6KPINrJL9gRALvvCLAsEOP+5JBcU4L0JksjiLMH+4JB+8=
Received: from CH0PR03CA0016.namprd03.prod.outlook.com (2603:10b6:610:b0::21)
 by MW4PR12MB7214.namprd12.prod.outlook.com (2603:10b6:303:229::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Mon, 23 Mar
 2026 10:11:50 +0000
Received: from DS2PEPF000061C1.namprd02.prod.outlook.com
 (2603:10b6:610:b0:cafe::4b) by CH0PR03CA0016.outlook.office365.com
 (2603:10b6:610:b0::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 10:11:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DS2PEPF000061C1.mail.protection.outlook.com (10.167.23.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 10:11:50 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 05:11:26 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 03:01:29 -0700
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 23 Mar 2026 05:01:22 -0500
Message-ID: <2f37d86b-82d5-4fbe-8071-2f346ae3e5d9@amd.com>
Date: Mon, 23 Mar 2026 15:31:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 0/5] mm: Hot page tracking and promotion
 infrastructure
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260323095104.238982-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C1:EE_|MW4PR12MB7214:EE_
X-MS-Office365-Filtering-Correlation-Id: afd2783f-814d-4def-44d5-08de88c49976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|7416014|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2Cxu/Ib6kmpLTDeM3IUhO89BPsDsTHeetGyNlxtkpPHYMw2Wtw76om2OZCT8xBcX2xEQkd9heHaV3ieaBPTnWx63apTW2LQ+eL0vo/FdTe9RecRmG+bT4bQ9a4EWY899EZt+mQVMNMgJbkiv4K+FAdsDKB5+CLaj+RG8FQYSNYWWOge1dwbmVvJ3XFFlRVHJWsEqZfDf5IEvYaC4zW30Xovecz9AE03Gua/9qtvERGQaKjqADpKdBWbBkKI7UaXS9gUaJkNfkioxCCPuPWz9LyXoaIiRZT8tkNb2o+iOkIe2fKqiBZ6aa5aEFadXgByfcSQoCmgnZpxIQncDqzKH3dwdPfHrGBhNR4+gPUp/G4nlu2AJCSgjqsS6z3VBcPRHEDGaMa+rldMncFGPrk1a7elni6Q3/LyQaGHwn/LJyOIJnG35qHzab5cevIoVN7b9XNCD+b4IVyYQkE/6CQIr5kMlpIZnFXF207RZQ5mjvUo1seDtl51HLdv/x8tpPEfLRVmMw4aHUyqgk9A7bklgEwOFrs4Lpewf4qRzVfSHR6SCNrW/uUSrTDQUFx6ZEaKCh27K7cgLHwYnR9SaqjoRSK8TLNj9mQDtSL8EHAWRN2Rrutbe2hbxnmOdhRGSI0h5ss0VGQneNJWzAlOKmh03DJfZfP6uKosyWq+1WcE0XvquY3Y390HVMgJ9d8Aj0O3tPpoSg29tJR8ZQ2volgP6GSwYZWV1YnSu/DaqB8gxMcswmQRBX5gKMA5nXNGT34t3Yn2HwoAyykT6ogA54eg+7A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(7416014)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yMz5HmWaa236IxCuGHVjU6V1l+48ahG+wuVf5JJEMFDfu9uQlGAG4oRhSCldZPuuuQdrzmV52lKj2M8dkG9YW7E4tARkkKyIWvjfUVhU4w4O5IbWIKQJhaAFx05D2rszoxxNzxqkSKmlmJtZnImzjwYi6iObL7kQcZN65O7NM6p24AxnUZ6BSJcM2pHvqJrKvksLu6Kb89CpBnjb7ZcrctgKmwmQe+334w60pcoL4xUs+6E7NJ/BGuv0IKMqBkPc2H8nWaUKXf4o4oVV9D1Easy4JgIq47NO2UTGYTdlOJzI6UsAkzmrufLGD5yZgmgPMSBG5TwWi9vUEmXX0bw0JGcUfe4NjjzbYgntBqm/dfd9tcJNWZcitCekoL83BnSmgBpHzKV+3lbI90GXdJPiCOAwU+A5bFtW4rUDOYe609QpXvP7SKfvGN3NwxQ/zRuL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 10:11:50.2012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afd2783f-814d-4def-44d5-08de88c49976
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7214
X-Stat-Signature: as3syssg5dx7t134cq58gdrswejtizco
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F0E2180018
X-HE-Tag: 1774260716-969770
X-HE-Meta: U2FsdGVkX19yYIbIDEUygBlgvJOnKBq/y7SkGM9TR9jX6kDNUQSTomCI5Ws3gRuNaHit3VzAWLcmOMlFEfs4A1QHLUFXYttSojwZS3yMwPed1iJ+dncdtvc1Cu7rp9lCpFbf8XnWCGnb5hK2vN/WKvIxpO3tCF1/amP91MzLcVZlFX9F8UVA6lnbbigo6OdPNHbOQmJoWpxv8oYcMrwxastggeOXiJ6JS9JbzUU5ejmC0d3nlPcWdtkXMkGQkaVCpPvCPbqdBkXvKSXoke2NkZrRPbk75CvHa0Jep8FmvWOWvYko5DxsOIxVsyCnigwtSGbBmUsB5dg6AhYk24vNYsKyPSxHkAfkbntzlB1hQthCX43ESvtqgClxZj+4xXTk6vtVdKIe/VagoUDAVOYlIn7hQI+8eCUK7jzp1ku2aM6Mxrz1M3GvnB+s3p3nXl9butVR9DgkGURvWvwfKMyjrA5Jg14hYiu3G0Mej3/xKH+I/d+/sYQpp05eKuSAN7iInUOxa9PQu8ecRnaMkrc9brQO18iiFXtZJKaEP6xniOrk1fdqlI/0232frIQeeJju5Aa4WTVLZJQsadqzhp5w29JFFNc2YPLXaRx/5AyLuZfcddlcAMuA+UP4xjFJ0Kyt7U1KOunI+ULhUTXshzpDposylf+K1xaVh6/VFTCZ5wbBBh76EgTnw4tZ6954KSDEI3krK7KkL9no4Zue0/Qo6Ug9qroMV3j4JGk2Ap1CVcp4yfK4lgKhR9y2IcO8kfILj2szzaElWzPVrKEjHuZOC350ApKZJSy4BvgvQYG61WRuuT4fXbXBr3Ag0sJUIg8lBF+/skk56oAptNeqkwaUwHjv7DeiUEnG3+dVAVHWBvNPSEVna28aLBJMtZN9StHZkCT2OJAH1jithfm3BJvX7V291MoEVM0qC+JA2CA/Nb/Cf68GlVut+gqAgk+wwQWNgOERsFs2Nw91CAhCh0q
 HLxrk8OM
 Pn8ob9KK/6Ozps93OmX6hEfh85hXw8vNzNn2Uqb1Bl0zgDJ0VtMKrY1NwvltwBj53Poyo5KZ9Y6Er/RUkZYmSm/np1i5RtNZ3GLRW/cddEQgvGPbiYwwEiJkOHGZiMtbOAeWaA1uitwI4GxrGRLgjz1aZMIv2BRG92C+WbE3JIcn0spWaosuvcj0lqrybw1fHRBdeICrZhegmSlXC2MzpUPqqX77o2ZXZIQ4fAYIqiduq+pqX84kuP4vpLI+E/in5sofIh0U+RCi/QizhjOKnxcQ+AjFnSC48RBuYw1N6JCPJmfv1TWUyzaV93cNfyJJLj3Y0g/5A2wTPoVXP9vVxiwurOqcssmB0465oK9aN+HFLIPb6EvKZp5ncdY+k1pjwmuV47Tc/2hu0jd+8STRAAFbgXmTOCl/Mx03OZm4pq3wUIlGrCGMrwY6X1EpBFUnbIQ6e7OC6nxOB8GbDnKc995G8F4d83Bl3GkB009590qTH5lA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAS Parallel Benchmarks - BT results

Test system details
-------------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2
  0:  10  32  50
  1:  32  10  60
  2:  255  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the pghot case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the pghot case.
         Both promotion and demotion are enabled in this case.
NUMAB3 - Enabled both regular and tiering mode of NUMA Balancing
         (kernel.numa_balancing=3)

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

NAS-BT details
--------------
Command: mpirun -np 16 /usr/bin/numactl --cpunodebind=0,1
NPB3.4.4/NPB3.4-MPI/bin/bt.F.x

While class D uses around 24G of memory (which is too less to show the benefit
of promotion), class E results in around 368G of memory which overflows my
toptier. Hence I wanted something in between these classes. So I have  modified
class F to the problem size of 768 which results in around 160GB of memory.

After the memory consumption stabilizes, all the rank PIDs are paused and
their memory is moved to CXL node using migratepages command. This simulates
the situation of memory residing on lower tier node and access by BT processes
leading to promotion.

Time in seconds - Lower is better
Mop/s total - Higher is better
=====================================================================================
                        Base            Base            pghot-default
pghot-precise
                        NUMAB0          NUMAB2          NUMAB2          NUMAB2
=====================================================================================
Time in seconds         7321.79         4333.85         6498.78         4386.27
Mop/s total             53451.77        90303.780       60221.01        89224.51

pgpromote_success       0               41971151        423163051       41957809
pgpromote_candidate     0               0               1870949786      0
pgpromote_candidate_nrl 0               41971151        29360089        41957809
pgdemote_kswapd         0               0               391179763       0
numa_pte_updates        0               42041312        1919944389      2568923206
numa_hint_faults        0               41972330        1911683592      2562729196
=====================================================================================
                                                        pghot-default
                                                        NUMAB3
=====================================================================================
Time in seconds                                         4425.84
Mop/s total                                             88426.77

pgpromote_success                                       41957442
pgpromote_candidate                                     0
pgpromote_candidate_nrl                                 41957442
pgdemote_kswapd                                         0
numa_pte_updates                                        2588634775
numa_hint_faults                                        2581645889
=====================================================================================

- In the base case, the benchmark numbers improve significantly due to hot page
  promotion.
- Though the benchmark runs for hundreds of minutes, the pages get promoted
  within the first few mins.
- pghot-precise is able to match the base case numbers.
- The benchmark suffers in pghot-default case due to promotion being limited
  to the default NID (0) only. This leads to excessive PTE updates, hint faults,
  demotion and promotion churn.
- With NUMAB3, pghot-default case recovers the performce as in this mode
  misplaced hot page migrations get right placed due to NUMA balancing
  mode=1 being active.


