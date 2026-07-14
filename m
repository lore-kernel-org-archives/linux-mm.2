Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3B15C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037B36B0092; Tue, 14 Jul 2026 01:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00ED76B0093; Tue, 14 Jul 2026 01:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1B7D6B0095; Tue, 14 Jul 2026 01:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFC426B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:34:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43C7612028A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:34:58 +0000 (UTC)
X-FDA: 84986268276.14.41DF703
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1173A180002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:34:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=m52KV0er;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784007295;
	b=mm2ruLL7BiBQ4WMDL/ehaFW9IPru6lKKp7w1qtMFkfnzhoCW2XF6VqEO0Ur/Q1SqX+XNjO
	5wq3RWRS63uax+fPr03G1xUTzdaTMOIgQ/6+njeFTiHm1OlLwsIrrrqrcKYbYbE4VHpaZY
	aOrYw1F/gWhzo9weJt0CeV7ZEXs9DFQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=m52KV0er;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784007295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xns/PJeiu5/8JHBXMeg4+dKsO6xfQC2u+kuB0GRSZ28=;
	b=DfGzdoAYMALKtqrSwPAKcQ7Gbd1gAXTIglp18AS5KBMoI+lLp3f8qhrZHO7gaEZNOjhdo2
	u77p8CkczMozxPQSYbbiBIVCD9QmnheXKD0gUgDsOUEVYBZv1NOQAP9kZ3KlkBs4OeSwDG
	v35d7qXjfVsSN6Qk3Aiyq9TWl8lGr6E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VemzUhGJDZdD8zhQCzBrnq2/zFprduYx8NykQprT8GwvZ8A5NeEiNwmm0vUkoGN9od0Iah05vm31YTophc0WK/xZ3IvHhNvwpDCFjBUo/K+DCLG4mvRvbh/u1UFvCQqrljAKDYHqaufmgC4sunaPPAYKhwsKmJLEh3SpFuv2ec3WtySq26H8jXn2+2ttk0kRgIFq70uS+1ZwzAJ+g1Gl9OgUe0BdNr8rCMta1b1qtamVvJUJu+dYnFZMXJ5pneFytwgBmapMDBsbP/5U9CXtxfKjkmLTSF3/2SxNnHmpyP6BJD1qF7XP1i2hIzjlmJKpZ85z2/EZb2vtvHS8RjyOQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xns/PJeiu5/8JHBXMeg4+dKsO6xfQC2u+kuB0GRSZ28=;
 b=tYyW++eCjRtBS7y+caA8lFfU1ObptsWyH1+Y9TVgRiuY4sa3RaCG4d4ekNCBpOrIllfvnUTzI1KMkSA4iSoVObESLDclfamSs5CxXHUEq8ufEkBDyXt8mD7PFaJHS3DRnnsQYTXa0zsoFgObd3clAENzS8VeSI+t1FZNI9VIjc4SbyuNHz736Ilo44h+4/w7biIaAQRt6p+otntcoES3zyASS5wNDwwggPTdaDBuMqLwWE0+U1FwuSAeIWnYZvd63X4gDFswN2QejGAsbTM1GvTdNdcQH9Znc1uAuenrbBP8YBJQQqj757tZKzVh9ZIOXAGBlVX9/VbrK4XdUvut8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xns/PJeiu5/8JHBXMeg4+dKsO6xfQC2u+kuB0GRSZ28=;
 b=m52KV0ervrCIQ2iksoQTIqKJ7ZosO9Ez0KO/SBn0MqvSOIB7Vl8jM5pVhHjKi9WdTvCBk+pIZUsNlKAu0Mlqzzv+C38Hm6VJRX6X38ejFCwHJF8Ma5dt0nbP3nsufPyjuIn/G8/V3tVCDuHxNDi9R8OZas83bCGerHNns3uJ5ko=
Received: from SJ0PR13CA0219.namprd13.prod.outlook.com (2603:10b6:a03:2c1::14)
 by IA0PR12MB7776.namprd12.prod.outlook.com (2603:10b6:208:430::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Tue, 14 Jul
 2026 05:34:49 +0000
Received: from SJ5PEPF000001D4.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::ad) by SJ0PR13CA0219.outlook.office365.com
 (2603:10b6:a03:2c1::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9 via Frontend Transport; Tue, 14
 Jul 2026 05:34:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D4.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Tue, 14 Jul 2026 05:34:48 +0000
Received: from [10.128.124.134] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 14 Jul
 2026 00:34:40 -0500
Message-ID: <442897a7-7b17-4025-bfb0-fe2db8d64198@amd.com>
Date: Tue, 14 Jul 2026 11:04:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: batch rmap walks during large folio migration
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Karim Manaouil <kmanaouil.dev@gmail.com>,
	"Frank van der Linden" <fvdl@google.com>, Kinsey Ho <kinseyho@google.com>,
	Wei Xu <weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
 <20260713190516.0c669b5207667c893a9c0938@linux-foundation.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260713190516.0c669b5207667c893a9c0938@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D4:EE_|IA0PR12MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: 9599a419-6e80-4a64-fbf0-08dee1699ee6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|82310400026|1800799024|36860700016|22082099003|18002099003|4143699003|56012099006|11063799006|13003099007;
X-Microsoft-Antispam-Message-Info:
	W1+5PGb9hOVac9HWNdzsFRirGsBi/PW8a4JFRiUFSFFF+EuA3GO7TGo4o8lpCDH0Y6eGkHhX06KJdxqMzXHU6pEMpWFZd165wfBdBO7+kRcNrilEJHL8IQAEMrj0caJKcsqnOPuUufl+2NasFuyCxunqzhJOqY1BDRv4x7kMTQNL7qXnW5RSsxWTIwhndxdOv4UOI+oNjSdhOsf/4xfOIEI/ypoWJA/Dg5ysNwVgcEqHscF396ByqgNIPRvFzJsg4o9fhD5JztAejUg41UYlCdD16XYxyD183BpYBdgnXoI305QXKMrW5fUQK0X8A2UmS66kbASAcedVQx0WNKvXJPkleXcUS88tH1kOnupAeDPm1Ehe571Px7wdgm5Npg7G4T8hdYCH9hmZcSI1Xv+T/gObIdaDg789B3861Zn/7a1EcaT/i2G0flxEls5qfW0P7Rnx1sSrA++19hCSyY++faObqFfWnzHcc/uKN9MbSQ722yQes27DY8ZXKQ6VA75qlR/mIqYqfqB8snHZ1FZwoBhMhi5bQVaU01+79eARGiMR16aH0EuwVmwopYzqq+8sy6cF51X17qagjO1McDKVqf3g4JzLdkBKTyR2ZtZ2MBkjkN4KQS77nCEoRzTgs8+QVRSqTKRii7g7H3tD59tJbA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(82310400026)(1800799024)(36860700016)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t3+H5k2DcQAHS3rLgULPx5Q3s1l5Xy2opJozQ4RoI3XudMDE6waFE/SBnNIrsp0yOdFfbpJHH1EhT6buL7r+v1NENEBv1VUT7iLFMKmlkqak6vScBr1dS1vKxjOe1uX+SapcrzYqO3zSM/FOZOUWQeZKyRb1pWUiCaWCbjZT8jmcUtVAik0uhIvl2ERmtCJ8x30IHUvs5dcFubJ0XLPXp1yqvck52QUacvEDTT5dUVPpMa2AQtfuusz3jSh+dULGX0IjM8KpY0dR96uzJZIL3JBRkaWqtTROqFf7RpMhh1ys21CeDnd8F44Ckjpl5i0ekS2MKpMcJLLDoED/LSo2wfAcmb4Y3cLnGdHO61Rk0aYp2TcvNXO6LjOtEqSxQcTs8hwI9zxDaOASONJIq63j5RA9aaeoVVEuMMDVnvuimWG4/S12ogaO7CEGOjUYyaYO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 05:34:48.5669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9599a419-6e80-4a64-fbf0-08dee1699ee6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7776
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1173A180002
X-Stat-Signature: nquujm4oxtmr4smnxp8uberjhcpxzx9u
X-HE-Tag: 1784007294-98416
X-HE-Meta: U2FsdGVkX18BROJIakhdtcZRtw4Bf4Np1hNcCTicOZNXIujC2MpXxvh55/tSN0Qfpy4aAsJ8TLiH2KFtCSt3aaC475mm1G+TPDGEC2z38AhFt9go+19Ul2KGPqgc2PJSDBpMh1sbMZvgSSsscdNV2kf3gxMALXMu+pufs9zp+MdprSja4RyeLGc3WiE7P3++M7GohmFmlapK1KH4m3ExpV5yXbsSOMeUPlf8TPw7wa4RsvaJcBD0/pDqHfHEHLBbvKHk7nPf9B/0j7QIEbdjG0pK9+bZQQKp51qID0nbHqPPCK50IAiqx8DCgzyvQaaQxW9shDj2GVWacYL6wrbIZR3apCbTYgJJlO5uOGgJDKKBexDwS5+GVR+xW/Dr63F9BD4R5vECS2lictv3xGFxosIF7edqW2pzxCTlt1u/3DuOZi/zg/QLHk8ywE/85sJq0GaZhGzW2Sy0En5tgiSg/wPZ1KdT0pcp+eJRYHRHEdm8vbjp8/hyIEvti+oX7NzPnR/+hyDI0JV9iYiC0uH16cp33mvVI07SsBNQn/urHYidNk21NDiM6oK/bzsPsMU7aK/FbC/hiUvwsFp4lqPvh47ZmVuA/xo0qXOn5rTYjb5wgiB/jqW+qBJhYagQTdxQBMCiftYHp/gxlnDQsTqbkkHfzG4KVf99Z8Mz6VgZ2vxpFiDN/w2uTOFX+laq+w5c/bi725eIXBA5OBJmLzesVOralAYmifHMC2HzlXQv+oQZqS2qnMEn/MQJaE8+PFApgOuhM59kVS/zPdqsA+bGmGBoYzNjiTZb3AYJ2+1u7x2MQCFYrFO26nUaqPi/olqRAZmdHTNSswS2Plo0jG2YvNaY08+uYLB5t2OkMPlK1oxTyxWrj3aZ2mkGdPGPnMHOa2e3zOuFmcWlYNjvJtQaAmRpChu1QUAXY3Ta76DEl3/eJRI1ObSfX800AnDyHztdfhCDNf1N4MRO8zZweFI
 dVn6Izzs
 HnO7qZA/WDAxAnxTWCZr8hWzlE28mhhcymJtouud8kQw+SAOY/ZwWa+zB5C++tVFFp/nfFFOkcxLZK5W5VLqiufkKy4SkHJ0Cyc/hkLJZo7a47Bik+8uJ46OrtvWdVZg0C6FHc52OhqWL7EIs0txEuS4YL7A9VeYmmGREp18zbI3ygwWuXCwiezeC48ugRYQbg7Re0zuae2RBEwnExsUxZcdpeZis2Y6pqUr4LFmnefwhZDy12O7QFnWH6hRB+y+TWL0XFnE7E1NlKGMeWclxKRkU9EsSMvzH976RZV/QSPxLeaNJbx17bosX62fa3VdPUNyArEnozO4PCUJT9Vc8rIIBq5F+lMwKr/mFNNWtsiK4fLxWbIlwFYV8tAyQZAeI796LvuZ5sFtE5rvq5gekwfh4JCoQsnZbSObiIrllU4uIioQLU8rUWVpuujSaBlvz8Q6HIlz3gcYJRvxwaXwZyxVhga8TLExcs/96e/zOSEU03VB09aIjK4YFz5xP38wrJZs1e2868juCoPqoxXLGkdMsxmbKIEY66KtKvPT8yZiZxSQw9eSyxtdjNnkTLmP14kN32nasOLIrFk7VXGIYXt6bohOXEIOXEntYrnnNH/PseX4eGgOvrfsb2k2FFVP2VVqP8kW0rqJArXPvqCTiGGmqpog7am1yo7ho
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/14/2026 7:35 AM, Andrew Morton wrote:
> On Sun, 12 Jul 2026 07:38:46 +0000 Shivank Garg <shivankg@amd.com> wrote:
> 
>> Performance:
>>
>> AMD EPYC ZEN 3, 2-socket system (1 node per socket).
>> move_pages() migrating 1 GB from node 0 -> node 1, throughput
>> in GB/s:
>> 		         batch-	        batch-restore +
>> folio     vanilla        restore        unmap          restore%  restore+unmap%
>> 4K        2.98±0.09      2.95±0.07      3.06±0.05        -1.0%    +2.6%
>> 64K       6.16±0.09      6.24±0.08      7.80±0.08        +1.3%   +26.6%
>> 256K      6.85±0.06      6.85±0.09      9.54±0.19        +0.0%   +39.3%
>> 1M        7.06±0.09      7.17±0.09      9.89±0.06        +1.5%   +40.1%
>> 2M       10.97±0.17     10.67±0.13     10.69±0.15        -2.7%    -2.6%
>>
>> In plain migration, the folio copy itself dominate the cost, so these rmap walk
>> savings are only partly visible end-to-end.
>> When the folio copy is batched-copy and offloaded to DMA engine [1], the copy is
>> no longer the bottlneck and rmap-walk batching translates into much larger gains:
>>
>> This series + [1], DMA Offload on PTDMA (DCBM), 16 channels:
>>
>> 		     batch-copy
>> folio   vanilla      -offload(dcbm)  dcbm+restore   dcbm+restore+unmap
>> 4K      3.36 ± 0.10   4.16 ± 0.18     4.10 ± 0.14    4.12 ± 0.13
>> 64K     6.16 ± 0.47   9.63 ± 0.23    10.00 ± 0.33   14.63 ± 0.14
>> 256K    6.70 ± 0.09  12.98 ± 0.18    13.52 ± 0.15   32.30 ± 0.65    (2.38x)
>> 1M      6.99 ± 0.02  14.32 ± 0.67    14.84 ± 0.17   38.97 ± 1.03    (2.62x)
>> 2M     10.74 ± 0.29  64.25 ± 1.48    65.36 ± 1.00   64.97 ± 1.75
> 
> Well dang.
> 
> Thanks.  I'll await reviewer input on this series.
> 
> Sashiko said things:
> 	https://sashiko.dev/#/patchset/20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com

Thanks Andrew.
I'm working on this and the syzbot reported issue.

Best regards,
Shivank

