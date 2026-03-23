Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0BCEC01B6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB45E6B0089; Mon, 23 Mar 2026 06:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C0F6B008A; Mon, 23 Mar 2026 06:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1E06B0095; Mon, 23 Mar 2026 06:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 994876B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:00:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 422EE5BF42
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:00:00 +0000 (UTC)
X-FDA: 84576881760.24.5B10CC2
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012060.outbound.protection.outlook.com [40.107.200.60])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33A83180002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:59:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Dn06zf3W;
	spf=pass (imf16.hostedemail.com: domain of bharata@amd.com designates 40.107.200.60 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+t6u7HmXxcXn/fSNHIDeUa3r0UOm6bGHyLQcDTMFvg=;
	b=vcFfkto+0wqAzkGlJfKuYKlKKzUj0P1qLsq3NNy6u/R0P1G1rkereRgGecLee+/HfDISV3
	6G+R1ZHP5bhDIZwn/035dVrYhvZ2Kn93IbmMmigs8gXi54nWSrJFcvXCwDBdfGX3I87wUH
	M8HCdHBYkr3hKWYbGV1qDnR6ixS+sn8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774259997; a=rsa-sha256;
	cv=pass;
	b=Qg2g4C10y/jQN7nsqrPByYcZaOGVvQtd8wdiptF/3CuyLYfK6gtcBepL6enYVJWA1WKfDK
	Vv20ydyROagzz3HI66+9fyFT7/sj+qGpaLuH5Ss0LYZFvRzHw9WV3JgvfH5go2++3FwUl9
	XC9FiKZ2XrDPq8ed/Rqci3VvxhCrQyQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Dn06zf3W;
	spf=pass (imf16.hostedemail.com: domain of bharata@amd.com designates 40.107.200.60 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnO9+r7scsx+syBkl4LY+5aBcvUj5zyATtOg+SrBqh+wh9xBr4LJyCx1hssFbNLJYQRZ5T4YQXa1y+h0WoIzimweaJho32xjohkS7u/9LzzWzE3rZ1ryvd4p4zg2SP2auoPo+Z5Ux4As9bdBP7jkUDpv/6C5A1sbrd0Vi687GDE9/hUQQAzkQxuFxr//OjflG377T8I6i0gQPk0rWFm23Kah/TjsLVemVQHcYM4unGhGd50WhaWrX0wIalLT3V6ZQBL5/n4hN9mhr3z5sXsW4KdlfBYyL4nc59ulHWa4TnUa1nMtEqtsF39TYr6dnhIc/jm5WQmvV5Dp2VL2VjLVsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+t6u7HmXxcXn/fSNHIDeUa3r0UOm6bGHyLQcDTMFvg=;
 b=DbWDl4ZMQ3lAucy3tzjHL9dW9TvUKBpPtvCwKRrkkYGsy6CEAWsqjasUlmSG2Z09K2b1q7yDM7wLZ3Jz0BDbKwPNBbh4aBaL+tng273qs1zgYo2qxqEdNJXpeKjMJuIaGpwOj9I26jpOMR6QzDk62jDeZ4rhbpueRfvatGZYrg6NBI52wmpdfzkvZ10iX7jQMfEKwI2vLGt3qrAbcAd1he+tkV1DsAN2+1INAMxmislOMnSrpBfFPwP14lsRUW1ZpQf0b+gATaXDiypAA6XKNxww1yxLAQtE5HpodsKMyDmAfGZJftLFFLfhYh90gygLwnmX46ngjWaxBUsrVCx0iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+t6u7HmXxcXn/fSNHIDeUa3r0UOm6bGHyLQcDTMFvg=;
 b=Dn06zf3WjwDhIlt7KWicYAeJ/L4X4e57y/j4u62a/FokrXpK2ND+rLvcNBpbqDmKqCAhlATM4us5VCSHQ269r/AOAuKCjywHBF0uZ7IlmDpWJsuFMeMlMS76nnyVreE6GAU37FcSFG+e5/kqw3S6jwdlT/M9+m9xcwyRkKzGjVA=
Received: from SA9PR13CA0134.namprd13.prod.outlook.com (2603:10b6:806:27::19)
 by MW4PR12MB5625.namprd12.prod.outlook.com (2603:10b6:303:168::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 09:59:52 +0000
Received: from SA2PEPF00003F66.namprd04.prod.outlook.com
 (2603:10b6:806:27:cafe::9e) by SA9PR13CA0134.outlook.office365.com
 (2603:10b6:806:27::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.23 via Frontend Transport; Mon,
 23 Mar 2026 09:59:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF00003F66.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 09:59:52 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:59:51 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 23 Mar 2026 04:59:44 -0500
Message-ID: <7deb1c5b-49f6-41a4-b8c5-1cfba14488f0@amd.com>
Date: Mon, 23 Mar 2026 15:29:38 +0530
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F66:EE_|MW4PR12MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a95ff5b-651c-4345-1a16-08de88c2ed86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	zePQY9qgtHUqyPMkHu9fH2nn04rnbS+m+leOUe96bWa1Id4pF7fwYkGpwuG0jD7yhdVcVwnqKe4XJ0dAtX4DN665cVxMp0Bjg9wPJq3Mz/FW7en5cDdRT5w9eMQPj9dkulDQ8D01V2a6QXI2Btxoh4CKUe9zQVT+fkriFLUmkdSCOHdQQU1kuG8BcqEoPP6Y9vSI5K0DMZ3F5eJM3uv+cGHw8KpRlPP6LwB12ld8u4FeKkweDxmfyXrKa/tUyQwS2b/QZ3mfkRpQOrHn8NbAFc8VxohwPyYuz8ERKYFx60L67er9H8BHzK7ZnCWt1+qdtrcsbCd7lPjPKTtVf0u1rrTkqxoAEdl4afC+Pga5o2pwMsIUbzWC08wqh9F5+urLXnuNy/LLHfDivYw1sVzt7Np4W1XyRVCdMlPQ4dvnVuHjDNW/aGDyNzxGZtcZV7nrQmcL8Uc6dQEavO+XHURyjxU8zelzqWzjLjDHNFvTQjdjbR7aN8cwolih/oK22/XEAm/kpunStck+lIbHTBo+s5PlqMwrNjhPdnUrtwLomA42bLg16g5ldnDRhwuqmHQEhTpPp6JqiVGTo79HHJU+haFLSLcW2AaOLgkOdTip2lv4SgZHXn/PXAyzLQzwIn7vzd5RKYparhlipcPevd4bb5DMbYERFzOGGrPLhxi7Jxmqbq/zpUC4KUhZ7t5ugvm1j7CiNyzVTSW+TKmlVCkf7HXNxObembSBuFgjOD057Rp5JQcxZWBuACgHxJ4NgQbo0Fi1MjrKkyF9IfGlMIpTHQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kO+vJhx7jlYSBrjlI7XlMP/shgUvBPyHCjF4iHBkPMb9fg351D0LcFpDYusQb6gyR5uedFXqidYkDW+kifGhxnspmFkop6Oa25Miwym8Vi/m+tpGj4yoOObeYR6964/w1ryGGNRVXVQFz7p2k6/eV51KrcgK6okfJKS17gGVZKTSiYhYBtL3QidvVPE1GJzxj0+nB2eH5Xrdgtf8P16VF2Vp3wYBuOM07dONg4M1pIe55NEQo2j+PAkX6nQFvYxlfs9rcumtcOO82cJEZvkrneMKmIEJ9Al+WhM17AYYmaWibeGzCQq/Dzjihvf936TElfQoZ7XltnT013uDs5B5bfKoyCOx8kCyj8sWmZowDqVdbLQAJ6Ob/Lq+aT3CHg8KqPGjTSeHVbz0POjg1VdmcwIkfOT3W4a4pSE3iB+K4Qy2gN5NKDPUMOfRRTzdEGvu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:59:52.2600
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a95ff5b-651c-4345-1a16-08de88c2ed86
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5625
X-Stat-Signature: gumfi31t1t1adb954fbo7ssf3a5agq8c
X-Rspam-User: 
X-Rspamd-Queue-Id: 33A83180002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774259996-509993
X-HE-Meta: U2FsdGVkX18p5liQhswakzMP6VV/v4QrBvuLQYELr1QzSY4e84AKw94QfOR1nWizIAdVlGtu8vLwhWc5659INA8LLSB0dBiqeuFRFq34k5wM1Klc52VETuzvtSEvu3mwCBbE73rvEZflQ8o4hThbCsK2jzpa9Zu/HB+eGT4lyNnyHGMrtHgTjd2fM/xnu/0TRWCauwkX+sFJ7f1hIwv7CmJMJ4/ELxR/kT7bGUVbqUnKcBgrwe0qXZD+cpF1YobmA9nEvMXFd/kN1QLw+9skmPCM+C+oXoieDqp+FAUunofqJ8/NwlsSuDdhvSnnt41hWHjicAmTo6eUjZA6iM3AAi26Ayhpg7dTvuS/qLOJJSmx2ivV46Vys2MZUndhg20hok8eYzU1oa5VUliNAejp+OZWaQQmRhijCWIWCVeimA2k3O+Jp6ViB+0V+aHcDCrGBt0HHbHgwSt+MjVUiuU4bC1Eb8fq3k7bjx/31+w+gVmbSCZy81SaF4fkyxA2E0pIt9COnPpdhc2gJ2v28Lmw93vhXsvXKKedbPfRnIL1RLxNjg7joiuhxd9Pp6PlJexAv0sPwNjus3ijkOb9c5rE/kz8+02iy2qkOeUWC6Q9qnbkIoQIm8RaSh0Rcrsy8L8UfQb+HfNVKgHPYvvwCpgGYRyvxWIPbdDcq5c9VEOaYq181ewLEq19eiLzX4TRYna33sstRq+s7zcTHEL5Q57Un88+wSXvp8WeovBZ40bBJSJ7O0ivlqn79308EnC2AiQSB9cPlHdVwLBNu7exh6S7Iz6tL/lAXF+axLbRQqzWYH1rRH8ID1/Xc512ugIfHUiqtEF9WccbXuI/dBlBQU/96knHoRbjZo+7zLfMLivBuAKbtvG2YAczwzPpZW15Q58Co47QnWDHBpV55UEUVVnggAIdioSMYPfMkH4tM4sltHx/qIfhr5w7LPCueS+7JPuVOWD31aaIaXg0Ao3YT3u
 WvIN0OT0
 5/zvUBXHF+saTabi/7hozoQ/bhP4gYjdM1ncqGWL+A7jQ8sz5VojcG4V/ATfFH66xLzTUJ803tZ8t8nJO66Xn6JIPbjA4HcYYrmfrIrRYHEnZNfdGwXE9tpWME/l00FbLUzO/KwKtFXPor6A0zLsb/ojOYQY0Bo+M7LUu6uxiPELU911kib5SR5YP2N35Ec8UJJuFQWj9jE3zj92Y0gWTBBR3yH5CiSNld3foWTqK1JfHFaWx93JQ7qTwPHvLl0YT1MAykCwASNns10zZkcEv0O0cJMfMIv0dCf1p+y0tus9BNAu3kvWijPnjm+ZO/PsKwJax6GMSaf0mK24ZPnK9i5/cFiYhQELAqnoad+LP5tzaReZ6RQXmU7i6NDxL6CA8ncWXydrYrqk486fhEmiQuaDj7EABABdkvyerg/of8wqdLshB6OZLLQbWReg7AkOlpquw/Im47XJEU5DqA6WucWtj9MwVgSgEgahPYFbnz6c0SGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Graph500 results

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
NUMAB3 - Enabled both regular and tiering mode of NUMA Balancing
         (kernel.numa_balancing=3)

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

Graph500 details
----------------
Command: mpirun -n 128 --bind-to core --map-by core
graph500/src/graph500_reference_bfs 28 16

After the graph creation, the processes are stopped and data is migrated
to CXL node 2 before continuing so that BFS phase starts accessing lower
tier memory.

Total memory usage is slightly over 100GB and will fit within Node 0 and 1.
Hence there is no memory pressure to induce demotions.

harmonic_mean_TEPS - Higher is better
=====================================================================================
                        Base            Base            pghot-default
pghot-precise
                        NUMAB0          NUMAB2          NUMAB2          NUMAB2
=====================================================================================
harmonic_mean_TEPS      5.07693e+08     7.08679e+08     5.56854e+08     7.39417e+08
mean_time               8.45968         6.06046         7.71283         5.80853
median_TEPS             5.08914e+08     7.23181e+08     5.51614e+08     7.58993e+08
max_TEPS                5.15226e+08     1.01654e+09     7.75233e+08     9.69136e+08

pgpromote_success       0               13797978        13746431        13752523
numa_pte_updates        0               26727341        39998363        48374479
numa_hint_faults        0               13798301        24459996        32728927
=====================================================================================
                                                        pghot-default
                                                        NUMAB3
=====================================================================================
harmonic_mean_TEPS                                      7.18678e+08
mean_time                                               5.97614
median_TEPS                                             7.376e+08
max_TEPS                                                7.47337e+08

pgpromote_success                                       13821625
numa_pte_updates                                        93534398
numa_hint_faults                                        69164048
=====================================================================================
- The base case shows a good improvement with NUMAB2 in harmonic_mean_TEPS.
- The same improvement gets maintained with pghot-precise too.
- pghot-default mode doesn't show benefit even when achieving similar page promotion
  numbers. This mode doesn't track accessing NID and by default promotes to NID=0
  which probably isn't all that beneficial as processes are running on both Node 0
  and Node 1.
- pghot-default recovers the performance when balancing between toptier nodes
  0 and 1 is enabled in addition to hot page promotion.


