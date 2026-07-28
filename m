Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC25C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 06:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55E0D6B007B; Tue, 28 Jul 2026 02:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510D96B0095; Tue, 28 Jul 2026 02:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE056B0096; Tue, 28 Jul 2026 02:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 042216B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:18:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6FF2C402D9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:18:15 +0000 (UTC)
X-FDA: 85037180550.23.36477DD
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011066.outbound.protection.outlook.com [40.107.208.66])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3E06A1C0004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:18:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sbckCMQS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 40.107.208.66 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785219492;
	b=i+CH3dN4Hfx7x8NN41OuRJNBHZT63dfWFpsnQ0bPqUl/UDNwJizFqMlV/yUdE0aXbViiQR
	Yc3+UIZbtKtTnxJgMRWYCJZulFcc1UR2CtCCXKBIlULOQes/lBLDmABnA27vqFtdDDrjRx
	xstTOx6iXfFSNnCije752Tzvn+Xvqjg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sbckCMQS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 40.107.208.66 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785219492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dOAev5n88S1WhaRTFhj4TpkWLL6vSuVFHQ3peCrY8k=;
	b=Tz9pgn8XYAzCRHqO1XDEoGXtdX4vbdLyjaGKMU0iWHn+J/CqdJ/n2U2QiXR9hD+KNKyDAe
	P1EdmRuB8MmQLL7RD0EpUcvyFFJaF2PYEog5ltp78wZkHUS8RLCLq3yczzHHB8GEDLrjlY
	gavro0uTb3ijtLyhDuAgK4kPRiMAX+Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYHLIK5FbfQrZsT4xGS6cCUXHQKuy9LOH+Yae+/iJnno1NwMEZEuyQXd4Q9pJL+2sD+u8uSQm+1AEHr/TjWATKdG9HWqPPqvwD+nIMZ2zIP3S62a2VFY0JdP6IcJzcBt5vwA1GSbFgOSNY6Dw9te9Dq+CSlr2sjzVggymnAHRI4yyjECjHT2qHvesaR5hkCyKoyTRUuI7grQiqJvNp2J3aSROJiR/0RaPvX0tRkplA65UbugRHxHLZPg8C03Mfc/yMfXt42Nj5HTuZNuOrWVBBjfLZO7VBUg7ExrbdqT6IGcuXMajdYZjN3jwNeCXxkoUJcApGhoi6QRnayLhA7jdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dOAev5n88S1WhaRTFhj4TpkWLL6vSuVFHQ3peCrY8k=;
 b=xtXaajNqDuB3wXeXglKAPKmpTAZqdk2NinmAZ6qqlJOd5v8EnAPKcgw9zFzH1lKjWHgi/1on4Vk4FjFIsGVMEd4c9G9Hd3rYNfoBVN38nQbYn0qEZgobKiehg2oUwDtIidV8TGw03tIk+QEyz4P1h+aGTkV9XRTjBVwOj50qlQA1JwGiaYGMwnc9Hrye9RkHCujiIjMYJFWWywxJ/kVXORH+NWa8itspQxqy74dQ9iIsKpGuTHWOjdVgmjTupWr/ZiLhhP7DYV3fYQyjYq1VMtjZ8i4w7LrBoNatninbws8sUlXv0OM4EktI1Wgg1yJ81jWdZPVKUYenirWOWbyoQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dOAev5n88S1WhaRTFhj4TpkWLL6vSuVFHQ3peCrY8k=;
 b=sbckCMQSHibWXBiz2LNdbbB5w5crA2D3NFgGhDdPDCq0qNcrfwOWJAs5y787MbOGC4Kkd8OR6EygQT76+aHxuXSgdZycqlk7WSFvivumg9C2GR6Mn0Frxg8Ey5sd02vqjYx5deRkqF9ueQ1ZyWCg+niO/aiXz13S6nopzf8wNCE=
Received: from BLAPR05CA0045.namprd05.prod.outlook.com (2603:10b6:208:335::25)
 by IA1PR12MB6162.namprd12.prod.outlook.com (2603:10b6:208:3ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 06:18:01 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:335:cafe::81) by BLAPR05CA0045.outlook.office365.com
 (2603:10b6:208:335::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 06:18:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 06:18:01 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 01:18:01 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 01:18:01 -0500
Received: from [10.136.47.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 28 Jul 2026 01:17:54 -0500
Message-ID: <b36480aa-a852-4f7c-9493-c2ea859ae247@amd.com>
Date: Tue, 28 Jul 2026 11:47:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
 - llama-bench
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|IA1PR12MB6162:EE_
X-MS-Office365-Filtering-Correlation-Id: 478e9ce8-e996-41b8-05c3-08deec6ffa44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|376014|7416014|82310400026|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	X7zBqdxLoNOeMsPRX4RO3YTzYi8ckfzx5bau69K0m533WRmlcwzYbAplK2KJlpVuSr1QCuk0OUqo4UK5GtSJt6m2zdAFD48dxdT5jlJqBLiSfAQGLBI6xjiehWS9xcuGrC4ih/1mdZ5nULevxf6c9N1WFXdj7pXY7Bxdu94i+7d/5h0naOn31w9Er5LNpZ+ZNw9fVmWJqXAe1e57V+5ojYTqLON2PhtT5BljhUo7El0ErZfaD8NZpDg6/jCQGq7/g/CeO25CogGeidPn3o+IcDvN+hOeSX0zg4DvXOFEVokEr/8kB/EYImZFKiBiwVsZ8FixMqZ+HVA72GcLN4OXwYJfwNKGr+PutP4ZlR6BzqlfxESc2nirbT+soAzGsii9whYeVFQYX76PhnyxYTU1/rV1hpj/CprFZKqcJZdbeYLEHkuyeUvWaQBWX2S7/YENYymCfDgdwbcGAU15jv+IRFUSh9HMA2azUlIt8fXxIc/VlGE3srJVhymY5c+eG8xv/LW+j2Dnh9A/v0baHIusJnq9bAjZ5E1FubFy157bN6auttVsItNes8VF01qPfgNeRkKuy6EoU/ibIKQMsalwVi2JB4fezFpq5U4WZGBxU15KWM2RN4Sgug28x3Ja5rY0HFJvVi3mZgJ6EMLu5xbAfPU8sL26ymslRlqIDvMcgrKvC1TcOztGvJz8M6wTkNISx06fd2Ww31xBDE9iz6qqww==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(376014)(7416014)(82310400026)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FS+Fi1iAan4u1B+wYNKtjHyML0OVIg6YfaXpBrJ1ztbc54O/vcWzySeUF2sg1vYu/pfLi74rKy0wcaTwYjyGTe0W53a3nqXdX+E0t+IsnxIsFEXCXfvEZLMzipdUHOaS6jEphtpHDmM4hW80A9u4bz3o0srrl2R6W14cJZp7R7m+lcAhV+VrGhwoX8Ka29IkIGINZDc2NnmY7qXPlOFzm06daePnqS4K8LZwwujscneTJvLQDxS+vo0ypgLkpnT8e2AGW54iH4vEPmD9mWnUpuCYtOvttEZgDdW1lRa0PWIBeqVtJhYauSuyW8AgtwwxCC5MA1T9JLUz1HUv6NCzdClFBTrWpk8KFymqmhX26hUcX2jXzVLdXXnG8A4s2g3MULGnBV4ggLBtckg0q6YlQTqIAcju8A+tlDVx0KmH5ZYuWZAfLeW8JYsNAHGWM0X8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 06:18:01.7038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 478e9ce8-e996-41b8-05c3-08deec6ffa44
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6162
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E06A1C0004
X-Stat-Signature: iucsr3eaa1jzsrs9srbda1pcpe3an58r
X-Rspam-User: 
X-HE-Tag: 1785219492-980163
X-HE-Meta: U2FsdGVkX1/xddBkPu34uc67Wm10DHEItGmK8UF83zgxyD3uP6N7L+ktKeXXxhJwlYgH/TJ1N9M6Be9WYzSlurabXFb5Uqpmea4MzmhPsfdhq0LbAAxx57Y9O1kgGh0DhzwAEVPMFz4FCAxxr68xQxxzLdSeXi+urNsURG213ln/sQ5FZj0XEwhN3Twfc4t+K9O3ngN78NsJFnX+gHH3z1Iq7UTGhbSkzPd3UHAzrT0pKyMj8plp7zQAcgej5LI6sQ3oiSQJN9e5jzH5o2+jfTavovx9Zk85LbdO0NrAdUJtIw2gF/CwNa2vLxsIIsfqKW+3+SSz6o4p/9cdzZMsaRQdH27P0f8TW0Xbv5iFptE8W+Ce1laX9at7tqUmsHimTriLk1FqGwMWJdcejNjO/QjAEyHBVA9PL3idYGymtvfcKepDziE0Jc+n0HrcPL0G4U9RZsya64LpphTu/T82O4ew9Cy5whXQoB3Hfar6QbGq8GIjAL7jVqoUaxKH3cEd+QanJH4u3qFsRzmncnxz8wz14PgfIZaCNxZM3jNLi59E0W/x7pw1BgQlQ8uyTHDPPRI/6MERGkBLYHdYzuByuTa21BELR1FdiVEYW49Nz1Nuc8CUc7H5p/RpX1Zc5NULF1A3vJs8vB9ohCQ0p1i2ZJ1F6VM+14242DRkXpjEJLvSfOjcsaoZOR6eelHvQHseGORR8ruBNB9CUXlQAz1FWb3A426cZ/+Y7RzrTvM1zJiAlmTz9Zz/+pO/mQvAW3qlUY2Jv3KeCyqy4AGt1L3rh6olDPnQ6ZC1kN1996sVU/Lmo42rpWGBWDoetrie/YQELPH4ee8Y7+GEKrhn3OqB+pPILkwcQNscQE8U5DzJeGXT7Rzo7zAZ5AbMpE75vzyM70ekFnP2Qvo4Zjr1JpuYVMb1zp+7kSlIakaHWaOqUVj2P/GdJcuNX0Lb5ti3aXvre8XaONjEleF4Assdqei
 nWYtXEoe
 B4aYMiSdcSqjL5KucWdIpX0ymIKNa+l/4UoBN+PGYAYtwtWvYKmymaX6kf4EDSzAJp/cpiOkxTd/BejPHFiUGahuZuPR/t2Tp60k3XiT9ihhc0Bg4pv2XQ4k3yaXSDX1U6DNKc/nXa+poxyQsmrPeFhqOcio0ktSoihd1W5jDKHZmxblGVx8eue0mkoRZ/pDdq2uKYpujLlDiZVJGyfj+E/O0jNqF4VFsWt5359/xTGvrtr099iw1FPmkiVRLJUI8yevzZ0emLO46aeEs1x851zesLkTUwhu8Xe8+F66z4Rty3//uF8dEtYnQNRjHgfbb0A2fFQoIFrwO3cZoDdABQRyMC486LoRSiaN8NncBscatfeYwiPwKCsrvfGcB6fNjibBy8XMzbPkYTy/hbBMeqnVp0ZaY3/oG5NZtxrGIcyKg48vgPvpLVI1xbbWiThTk4pCXr4hs6+HbLb1NBuIQSjqDh+l1abSZs5DBirlyPP+x8AE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

llama-bench is the micro-benchmark shipped with llama.cpp. It loads a GGUF
model through the production inference path and reports two throughput numbers
per run: pp512 (one batched 512-token prefill, compute-bound) and tg128 (128
sequential autoregressive decode steps, bandwidth-bound).

Workload: llama-bench (llama.cpp), Mixtral-8x22B-Instruct Q4_K_M (140.6B
params, 79.7 GiB), -t 64 -p 512 -n 128 -r 5 --mmap 0.  pp512 = prefill
(compute-bound); tg128 = decode (memory-bandwidth-bound).

Setup: 3-node box, N0/N1 DRAM (256 GiB each), N2 CXL (distances 10/12/50).
Bench pinned to N1 CPUs with MPOL_PREFERRED_MANY({1}); a 200 GiB hot hog on
N1 forces kswapd to naturally demote ~1/3 of the model to CXL; each mode is
then measured while the hog keeps N1 under pressure.  pghot target_nid=1,
freq_threshold=1, freq_window=3000ms, rate_limit=65536 MBps, kmigrated
100ms/512.  hwhints runs arm AMD IBS (l3miss-only=1, period=10000).

Legend (columns)
----------------
  r1 = base / notier        7.2.0-rc2-base   nb=0 src=-
  r2 = base / tier (NUMAB2) 7.2.0-rc2-base   nb=2 src=-
  r3 = pghot / hintfaults   7.2.0-rc2-pghot  nb=2 src=0x1
  r4 = pghot / hwhints(IBS) 7.2.0-rc2-pghot  nb=0 src=0x2
  r5 = pghot / both         7.2.0-rc2-pghot  nb=2 src=0x3
  (nb = kernel.numa_balancing; src = pghot_enabled_sources)

Table 1 - Throughput (llama-bench, tokens/s over 5 reps)
-------------------------------------------------------
metric                       r1       r2       r3       r4       r5
-------------------------------------------------------------------
pp512 t/s                 69.31    62.46    54.53    53.95    51.49
  stddev                   2.70     6.65    10.41     8.12     4.79
tg128 t/s                 4.262    4.625    5.993    5.161    6.851
  stddev                  0.004    0.313    1.255    0.535    1.807
tg128 vs r1               1.00x    1.09x    1.41x    1.21x    1.61x
pp512 vs r1               1.00x    0.90x    0.79x    0.78x    0.74x

Table 1b - tg128 per-iteration (t/s), shows convergence
-------------------------------------------------------
iter                         r1       r2       r3       r4       r5
-------------------------------------------------------------------
iter1                     4.268    4.183    4.393    4.462    4.415
iter2                     4.261    4.457    5.336    4.820    5.602
iter3                     4.260    4.678    5.995    5.218    7.322
iter4                     4.261    4.841    6.501    5.494    8.152
iter5                     4.259    4.969    7.740    5.813    8.763

Table 2 - Key vmstat counters, run-phase deltas (millions of pages/events)
--------------------------------------------------------------------------
metric                          r1      r2      r3      r4      r5
------------------------------------------------------------------
pgpromote_success             0.00    3.05    6.95    2.17    6.53
pgpromote_candidate           0.00   14.34   24.12   13.83   21.09
pgdemote_kswapd               0.69    5.02   10.84    3.89    8.05
pgmigrate_success             0.69    8.07   17.80    6.06   14.59
numa_pte_updates              0.00   28.77   24.56    0.00   12.04
numa_hint_faults              0.00   27.77   24.12    0.00   11.39
pghot_recorded_accesses       0.00    0.00   24.12   13.83   21.28
pghot_recorded_hintfaults     0.00    0.00   24.12    0.00   11.39
pghot_recorded_hwhints        0.00    0.00    0.00   34.03   32.42
hwhint_total_events           0.00    0.00    0.00   34.03   32.42
hwhint_dram_accesses          0.00    0.00    0.00   20.03   22.34
hwhint_extmem_accesses        0.00    0.00    0.00   13.83    9.89

Key observations
----------------
1. pghot-both (both hintfaults and hwhints enabled) improves decode over both
   base baselines.
2. Prefill (pp512) suffers from tiering promotion (0.79x hintfaults, 0.78x hwhints,
   0.74x both vs notier); pghot/hf and /hw pp512 are noisy (stddev ~8-10).

