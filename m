Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57E3606A325
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=X5QjZb/y
Received: by kanga.kvack.org (Postfix)
	id C3AB76B05B4; Thu, 29 Oct 2026 05:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC49E6B05B5; Thu, 29 Oct 2026 05:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65376B05B6; Thu, 29 Oct 2026 05:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4236B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:35:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFA7040366
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:35:10 +0000 (UTC)
X-FDA: 85375155180.26.2E8CD6B
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012068.outbound.protection.outlook.com [52.101.53.68])
	by imf27.hostedemail.com (Postfix) with ESMTP id DBAED40008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:35:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="X5QjZb/y";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of bharata@amd.com designates 52.101.53.68 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793266508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGKNVB69wurMCLPvdqcLe36qhX1WPx65AE96vDluugY=;
	b=3HKqnlsPpztMzCHey+NpU23SIG6XSjY6SuX0KHtRSlRFt45Jv3S8MP2n7ra4aaN3/Endzg
	KBNS5lHbp5hjhD4E7G6HsO37vVm32PDNDBuq8scgRHlOUbCfJ/jx6wSb5DmYg1qJ0zact5
	gLk0+WpuId0tbdhDOYKHnbeQi6LocLo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="X5QjZb/y";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of bharata@amd.com designates 52.101.53.68 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793266508;
	b=AamOBXIzfpwGcQQToT/GhG+QisG1/ekIns3xv3uDhh/UsdbMWPbol3dtxBWIvs7Hsk07A7
	GOQeyvnhbXXIP9YHm8+j9OA8Lo/Lp4kvvDPMp2gflHT8bNGU4V+Gpi7CoXOp0m5foxdpxV
	b33BedvVKzMYsb8A9jaFhcu9vF65d58=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/zHrNlZC1HiiezaKoghqkc0IXt2WSkGIT2YVGeWU8evH0cVfM0ZkqV7y5Ofb5zVcUL3t9DwItck7ERwK2XrcVg5jGa9l9YkevQ+Xa8gkeY+gPHw+DgoFCoFPGUwm40FQ4Z+OTs+Fhr9M66ihUHchgiy+CMFAOQtoMKNRON0SRinP889JBK2QMMXFuSm2fReK4+Nrg4Dnq1A30io83bFgTjV8o5I987dK1DmGEEJ8whPGfVMzcVh9bXmUSgi1rrb11cwKN6lm6iz36A+mbB4Xz0s5V8w6UygOxpQoUOadPZpsSJ5n9vyEvhUUH5oM9gw9A9ZrCeR1fLK1RXfP+4sNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGKNVB69wurMCLPvdqcLe36qhX1WPx65AE96vDluugY=;
 b=svsqBtItIaCZ09t/oO/XXimjVMF8Q45G4rWN3jx27Aw/t0+Te2YreYX7AIU+7jujnLm+Tbb7d0NkhfIvHN7UBfPLj/8TrMvZz7sfT3NVbJMoT97UeGkMnPDnv/BgT6AIMNBNqDGUxz+PGKMpvzGcwzQpttCtp5vhTUSWQ9YvGM5DvpRlUR2vB8FkJPZGJidneSdQBIpWHHHGNMUAMg97OQ0dXfzUunoy7WFd3a+1qTkAcFZLJDbENgnC8pGs/4ktcZHvo+y+aOJx+PjdV+EHsIXJseibdEl7F96xia00F61I4II47394upWt3lNAKFerZpZNKtw37/ivoEMwmuw3SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=bytedance.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGKNVB69wurMCLPvdqcLe36qhX1WPx65AE96vDluugY=;
 b=X5QjZb/y5KJZE6nq1VCw8uNp+OJVneWn85gHbzdN3wW3QvwzXX038olchi9U3SIBPQ3wJCCis4RyUYTkQ+P9XjHS12c/yE4eikFasnFt0qcbLXR3a5eVcRv8ovm3+puqifqvzUdNXEkUX6mM+NIvKuZnD8dNv/dFkXnHDNmZU9Y=
Received: from BN1PR10CA0011.namprd10.prod.outlook.com (2603:10b6:408:e0::16)
 by SADPR12MB333558.namprd12.prod.outlook.com (2603:10b6:802:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 09:35:03 +0000
Received: from MN1PEPF000793FF.namprd05.prod.outlook.com
 (2603:10b6:408:e0:cafe::84) by BN1PR10CA0011.outlook.office365.com
 (2603:10b6:408:e0::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.7 via Frontend Transport; Thu, 29
 Oct 2026 09:35:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF000793FF.mail.protection.outlook.com (10.167.249.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Thu, 29 Oct 2026 09:35:02 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 29 Oct
 2026 04:35:02 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Thu, 29 Oct 2026 04:34:56 -0500
Message-ID: <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com>
Date: Thu, 29 Oct 2026 15:04:51 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion
 bypass configurable
To: Li Zhe <lizhe.67@bytedance.com>, <akpm@linux-foundation.org>,
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>,
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>,
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>,
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>,
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, <vschneid@redhat.com>,
	<ziy@nvidia.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
 <20261028041253.74839-2-lizhe.67@bytedance.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20261028041253.74839-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF000793FF:EE_|SADPR12MB333558:EE_
X-MS-Office365-Filtering-Correlation-Id: d749afd4-4247-4fbb-ed80-08df359fe89a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|82310400026|36860700016|921020|4143699003|11063799006|56012099006|261022075727099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	NN8VyqDq0GbR/y4YMoOxeTzGHJnH8ayYdmHhmXheor/LXGsWOfq6jyc/NHEAYoQSiCoSoYY8X5NkDq8qn/4ekARST1hmS2AhleJiV06DkHwtfp/7wYB2rNjSZNKMwyI7MCbXouHCXK6R3LClhHFS5B6UrGAYigJzp/V9dJHGX9/4DUf2jqAMpLqiXW4R6j20NGIY6CBxvLODklnb1QJX5U9rJ88g52ZVblnpw4DqhEn1sdOVyo/iya4wI07c2s4QT8xnOvm2UrGaizOZTTcchhk7QNf3MqXP/QGAV6oD9zMdiO/2XjwzPUk6nh8acD2vMN/akAtm1gnyQWPvl+cHcuodmxLCMyNgGp8GYFvmQJ35jPQq3OcR2Y0w8EEncR9s5wo+rdFbNSJTzHaHNMJTF6OO5hqLArSBEAQQpiODG5L8+VBJZZK+QIMo43RUAGymEH+bRTywYgro9q0DY2ij/PlFo7SRJOxx8lrfow7psis1o/eX0INuYdzad8D+v6d4WDSM4pO7FVKRNxBrEaPHj3qXCs06CK1zD7dJxt82JyRMi2nvyhJVSfiTHwCa0lv1Ibm33nKXSiol8w7/RPjazuWZC2P3Gn1moNYjuWCloJvu02rnf5EWab3XCj3KUpao6m7zGXm1l6IMUuFE499w+vkx8bh6a47he6v0+JbJz+rdPFE7onNizmtL/jf+k8arhjBfCDcnRKoPRZGoZRlvQZyw1wf5srwu+pK7ElRRYgQiPZOOYvxd5Kr6rHEzt+dF
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(82310400026)(36860700016)(921020)(4143699003)(11063799006)(56012099006)(261022075727099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Lvkzr5Wt4XfUGmn671Wv0A9HntpMjXwRvT/34/40x6jHaYk/nQ8/X05c9QyFbAWwjbOdT69fDA3OK8JEnpiZdIlsOhJJ+wuoJGNCApDW1s9V+GZAEOOu1BdfXCZUEtb1qI4SIC4XLVXVpc/mIVWjOL0aSlRCcAuyBTWNVo925Y8GwqkkzyQiAe49pkKI4VFpPt7O/s/jSV1SNRuDmw7drJ996Gw2F31GHqx3Nn6+PNB/VbLvPlOL3ONwOLnM6E8vamJLpb1r9QxvpRbsvlxEL1+ziu74sgrjHyqOzuqybUeuv1PPvKrAdJw8Bk1wH84kJL1WF7/TzM9RV21MIfqNlSf/meyg2L6hUt0/VdvmKX1o9bkBab6Qkly84X79t2QwmfOu4y6HmsuF/vdkErIPNOCcIK+AP9qmgCprC4XlgLhOlVMd2P1N06Ot7Y5zkS4n
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 09:35:02.7980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d749afd4-4247-4fbb-ed80-08df359fe89a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF000793FF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SADPR12MB333558
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBAED40008
X-Stat-Signature: n8eczjrbpz678xcajz414pq7t5kqcquw
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793266507-115099
X-HE-Meta: U2FsdGVkX1+ZGjhBuWjPCwNxTPJfqM5RUfyfPOt7qmieBWyliqd3VgFHX3Tqzu8gpaGURVEsUETbtww5+N4Ii49nQz71syPLyTMCD2m23VNQBMD3tzuXQvi4Zl6R0b4Ft0+I+c0MSSNfYCfKnIJ8HStfrBpYKR+GX/lki+xMXciZ/teUs5pXQbGUeBQ8cHN70SITQ4JLO2ew2ZyzgaiVkQJs9IPva3BSZwwRbsT1rrOeATqe6rVlYw1MqRiMV0FojrODDkJ0VnMTDxjTQOKMbI1KzcQGVRwIzc927KTPuRaCzbOnw+rxrX+cA74/HqO6p6GjN8SOTUBMoQqn2wfLWg8P8C5Hx8UzaliZef8HSMIT38zaHP2bOs4QCbI//uGLpwO8y+yDsIEwq8g+sLHNghJaSo7rktxxKUvuYRNGhlCxj5Unrjb3X1hkRZ61ggsxUXm88X3agZC+s/eds6zakkTsrOhCgYXh1fDmk374+beKvbKsNN+W1JgiQXGzzStmPs3O9FSvop0S8lgWxJGpyj8lb/wf9rNUvuH3gzCl7O6Pm2Ubi16xL7Y2UzhXQBfLYkIgtPHwWJBk0SPC1XuwX47Snd19+oT7I2irMC1ESa9hsv/LqMQfaB/+VvJgaRJNlpP/RO9G6IC/gWqc5kxz/0zZj0K3ZozAGN2T+x8nTwXQ2w3pDzKmkM1zF7oEjtdAqRG/GpWdXKIGkVyEd9lOtn36gKm/BybAdjaVuxoEB3txp4qSIAIZ+sA6+IQEbuyh/I9s1ASn0p31ZGD6h19bpEXct9h0vgXyldjc5KPJe0zXpgGd9JGazW5Cwdl/CCFjyCbStgcizl2CTFQdBsQIx9YFvxXLq3/MwJAm39nD4gnltNJYm2VJ7Wy2M6cT1XLVWIiF+gQM6hHgOUbPnXbcs+A/dXSd5Fh+S50DiXycZkAhVsf6+mfykPDS1s/nqEFXAaQEdIojL7Qxz1+7iG7
 RnxTcPqN
 OO/d4/eVjjHjk23hasmEJRl8UhDvcmWU7yeHjOXVdfzyshDChKWdxBW1+HFe1+HLWxJYvPB1QLQTs1+gaTLYWRnG/lCgOl167Lns9QdGuwoptxfwxZbkmYwB/IECBvbiO7NgatnWPQhGAjYi4eU+xpnX97vsaBmIANvnL2fTaREzpdGhLNaONppa+WOiF9q480wqevMfAxcmILCjgunisAA+da+3Hb+VPhXyLkY02jhKZC7CM//9SXsnUKQzMtHMbiPTmkaaLSWonkw2Vh342NOCNYx0DgX6e7fwzWKPi0fqSKOSUXjIRR4f8uHpnPJkjd9vRxj/2ma5NSR8mLkIGjgTJwrw9aYbRZ9DUYUWzU4RbqBQ8Z+kRfeI9+zbGrtzPmn6BYMRNyB3Yaf6FiQYG8fLWc3MRA2DX9tyb0tiFx/K8SiniUKZ5cxFlF0+96yP3so2S2ouc4dMOuGDUaUS3PSss0/Pl8z4FEVg4dfEORahqkKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 28-Oct-26 9:42 AM, Li Zhe wrote:
> Memory tiering normally promotes any recently accessed slow-tier page if
> the target fast-tier node has enough free space. This preserves the
> existing policy of filling available fast memory before relying on
> hotness and rate-limit control.
> 
> That is not always the desired policy. Some deployments may intentionally
> keep part of a workload's memory on CXL-attached memory, for example to
> preserve a desired DRAM/CXL capacity split or bandwidth distribution. With
> the free-space bypass, short cold accesses and bursts of hot accesses can
> refill the fast tier and pull the workload away from that distribution
> whenever DRAM has free space.
> 
> Redis testing exercises this policy issue. On a CXL system with node0 as
> DRAM and node3 as slow-tier memory, a Redis test was run with
> memory-tiering-only mode enabled. The test used a Redis dataset with 12
> million 4KB values. It reclaimed memory until about 85% of Redis
> anonymous memory was on node3, used a Redis benchmark configuration with
> a 10% hot-key working set, and then issued a short 256MB access burst to
> cold keys outside that working set. The cold-key burst mainly touches
> memory outside the hot working set, which is expected to remain mostly on
> the slow tier.

Can you please clarify if 85% of redis memory ended up on lower tier naturally
due to overflow from toptier? I ask this question because, if it is a natural
overflow/demotion, then it will be hard to find head room in the toptier to
allow promotions that bypass hotness or rate limit checks."

Regards,
Bharata.

