Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F46C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C6E6B00BD; Wed, 29 Jul 2026 10:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0AD6B00C5; Wed, 29 Jul 2026 10:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86636B00C6; Wed, 29 Jul 2026 10:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0A3F6B00BD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:24:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4ED9380642
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:35:36 +0000 (UTC)
X-FDA: 85041306672.04.CEF6EB0
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	by imf29.hostedemail.com (Postfix) with ESMTP id F3FE4120002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:35:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kJsGcWVF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 40.93.194.36 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785317733;
	b=BCAcQSO5Fi8ZdnL+uLjWarsjlDdHGo1ymlrzOxm7kQHzZ8CKJ0NLN5JN/JqwXmXELhnd5w
	+zFGw+Jhtmj9toyVKBfn4BHuJgq7NZqZ7AkKFZ30cUV6i9E59IE6noVC0YNgYS74ZFAU9r
	1CcR8TyZ57WOuFLhCeGB9owCoZkIc6Q=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kJsGcWVF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 40.93.194.36 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785317733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4hIC9IWLW5CHJdGBGbEJtpFSgG3nJwhpKMWtGiUDUQ=;
	b=ysiGxcYCUofJbIRfCTI5rBinp/u7JkIZB+Ibtd7YP7e2T4KyU26VPf57sOUzy0cxf60WpU
	0HoYE9wiQGz9LgyYRr8nOwgpn94HRZLh2ETZShO7q/Z6mTrEIJK462QbOQvbJ+o7yfBn4o
	I+ZOYyprckVCxQh5lu/qpCCm3G7fk1o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYMFGu0HeQh57romixaCE48Pg6GRkp1dx9E8EK/Ews4dlpVZCXjT9N7yqch5Zt9M47OJG5VfS8jLVms32WkntCzHz/dk6mD7meBA2R96Ic/Fm0qkejPCY5b0Tj1P2DZ5izJn8y8TNin82FFIhsvDPBJmH1YqdSIBwYJsRC/FMkCe/QG3owHY2Mvxz1xryv6jRUJuRxD36xJCkhnhqeI48MLXWmxa1zOVkAUh0Ht0Yp+smqgFLP7cCchcmsXzlYf7va5P5g2JNxUd269lNL8WT2spuP+2UUX4EHXsrqk0QtDRuxoPAU3IMxgSASADIPEdc0V6ALz3aU1Ls1NPA1vGxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4hIC9IWLW5CHJdGBGbEJtpFSgG3nJwhpKMWtGiUDUQ=;
 b=hYmFGVrdlHDwkjDlYmdSPVzPAT4V7VVYr5s6XG1I0l/io9kIGWrg3UVJUgMscw91igVOCydg/7vcXQZwlEuqmuB0/EsD4gUZNqQ8dE2OBB4F5KCjd0Ed1UpoXivgCleoIfrDiGzMKc7Y46TehYaS19ROawndg3rwYdF3j7V91qT24ZWtTNTXNg15xpNfKmP5HI7hgpVM6QxBXjUK/uEMMJ6lIJcXNu6B52wsqr6W2KPZWmu4v6OrGYrS+k7rLoLDpJ/Yx93OFzt1BoaB3SSl767y8/CbZ/Cf3kQCBa21Dx/kMDy9mSSnK1Llm4RtWJB5u5Nc2ZcQepEGHlQAcmcXTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4hIC9IWLW5CHJdGBGbEJtpFSgG3nJwhpKMWtGiUDUQ=;
 b=kJsGcWVFtGJE8l92V74vDDFEyjg60ectQBEmGdZcb8UFQLFOM7CvKK+oYO6TzU8eTRSkpbYa294f/wMN4KOcupnTQFRSFY9fYbCAblEmTb65dM1vDG9Oj1UgRhzH6An+76if+12GvlNsCbbpCOVfpbav6SqVeDIyozWe2VZOk5Q=
Received: from CH5P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::28)
 by CH3PR12MB9079.namprd12.prod.outlook.com (2603:10b6:610:1a1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 09:35:25 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:1ef:cafe::84) by CH5P220CA0022.outlook.office365.com
 (2603:10b6:610:1ef::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Wed,
 29 Jul 2026 09:35:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Wed, 29 Jul 2026 09:35:25 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 29 Jul
 2026 04:35:19 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 29 Jul
 2026 04:35:19 -0500
Received: from [172.31.176.217] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 29 Jul 2026 04:35:11 -0500
Message-ID: <125de6c4-2fc7-4202-9199-347effe63112@amd.com>
Date: Wed, 29 Jul 2026 15:05:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<david@kernel.org>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|CH3PR12MB9079:EE_
X-MS-Office365-Filtering-Correlation-Id: ec4697c9-3f82-4af8-d880-08deed54b813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|23010399003|36860700016|1800799024|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Sn4OAM1azgZWCOdsVrT2VmrL26rimCAx2EckBQUN0102aToyGrnJibeF8425ERRCyWgjg6J4Dvib9Dd544m7tWDCembTIqBlnLc9epJNVk/KO7Kszj6kybjsOzIh95KQSi49v+cw78jm6Xfit4wtaX2XXaUVBC/6G5eisuqCA/vVLFGrbVuQVN/R/+B7ptcDgLrlUMFgJ5HT8kyOlWT9A3rhM23bpRYfMKUj1ei8FuNFJkKBbl+iEmdZlEFV+Cq1WUALFzEZc+IfNIijO/I635RCGXBSuyn1tLr767tKEtGUMniwGaG9xiMQRyFJopyrhT6bLx9T1rcESStZNdSMMnA/EwF9wlSD75dCu/bnsWICOUTJ/5Qq5gfplpKIDVozT2jtb20SGiKkEl+87SgKgj3Z1W2X99hwMnL0qBm9fE0/0ofuu/v+48XZO/u0PcoQ5kejd4Boh+G0H46qdSHywU5jCdw+o5rbv47LwQBH9D3k/1nEgPuBZ7ki+dVXVIXlO7NGJVrUYLbxY49wyBnVYPwtCvzL9EhVtQ/fmK1iBtsawWbkltbrMlezbpe4zlc3V3IuwiZfZjhtGtMFqb5BkUaxqpcA3UmmcclKh1ssX/n27nAefrZd03OgjvFg+nhcV74Bd45QQazMR9+4GZg6rw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(23010399003)(36860700016)(1800799024)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eL5xLFoXvyyS0QC88q7tIfPxSjysyFPj0EpFGVlnz8HaOnVuulWtL4WLxd4Kc6rpu3nhdAabxckfs0pbCDdOtHr28+LexnIIuoqo49djVBISEH5Qb9DkWGHDU8NL24hAx87gMkXuTG1BVj0SUId31BX+XqWmIMKBXXsOzD01KimaUbZnaoRLib+jwBaU9OfN1B3ZYxqX6XdlMNkTtkMm2ICo/KeJH75aMCoPwvYOaqkgroi7J1zQjHn+vRqODoULIT1d/id2iZdHbsl9xZKFOug/wAi8AtK0QflK5JZnURrP6JamoWYFiiz9gNRgT4BRchBsiKnDIqshoNRNxbirZc2eNAizGNgz2K5YDeW7F80xXB+Q9UJKlm5GtaxOKvua1vTA4arKcMJHutHaA1Xr7hAzwggUpLbtBe6/J2ICv+VVYw2UpBzmwBsy9P8aUnvo
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 09:35:25.3747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4697c9-3f82-4af8-d880-08deed54b813
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9079
X-Stat-Signature: 78b53d6ripgaqd3gqwukgbjf7djm7hj6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F3FE4120002
X-Rspam-User: 
X-HE-Tag: 1785317732-499542
X-HE-Meta: U2FsdGVkX1+vpDSP9PnRul8s9fMjniZ5+b8cX+F+q7b+3jyswFevWJBy5zMEh7XObnqNyYq3jLjyJqAv5knj+XVZ+dqCUjfDx+0pIqZyfkQukfD5jbg1eVMaLYD+t6E7FO7E7gfTb+kENobS4YzrDgD/XMvO0y7mXiwCXxq/Ec1FRlDO7Tcodl6bLImSLik1UCwlQ14sLN0AdfwebPezrbKV1RwALyj9aY6AhxbzE/TFeXlQR84Vhv6yj+smNg2U+2JMU+tGNfZnW6i5cYisumtzrGckNkf9NKNnEzZdh5ekf5No/URSS6bb7xbOKy1C54ugqyUGbF0TLZV2/N9lseex7aumJdUn6LBSypaWxFUp1j9I6aI1TcoHOrIHkBjyKzZxsaCpBLHf7/EcrDZHdc4Jq1CgTK4eLkFyQGEitkO15CwMCLkiQb8UV9FFAtu4i4AWzqJGNqHPL0cDiF+00QVePfqIwKQjVOpvAJKc0mBLluRAgMXE/FkBJS+fuyeCtkFLsUhgW2b2X8iTT7yiWnTPY0KGsjfQD7kQKmvKIsJRY+FaLZEoCvKH5SLphH9N/zcw1jvCGFq3QGaegjSzUyGGau2HPayXwjTOYTn7CxSxQ0KTGsfML08enHQ9IBjfG3dzR7OwGLYfPqIMIjmEmGHAHM9nobnMbraaCScjSPjUxp2Ch0A74UNBSpkl/5kGPK5bNAwoB6TLEHWlFCy9he6Hl0JTee7ZVycbAGMfIX6ZePc5cJUqiy0fk8Z9m3LQR2x4YjqGyBu1x5mnQByyA6KCkpF4DcIk+OGdRC/IbNQ9hJdCU3l8EtCdeyLuJMnR7gWL1SdsRodfWEPitOjMFLGdkXyAmK/KaIuTNqpLwHS7nlJg7f1m1txAr5zSGtawPoImNrBMHDPIfpkoUNPyUkA6FJjopyNGAT1u6WJJI9FgtEaEm0FgFuT3QaeoDohDCRjJG2St27MOQUtakOf
 3zFOrAFO
 44hyaHaOz2+cYRsyucfKNiDlr7fVwRbBqkem4LPNKL5YcTFJP0pQJIQYt/6r9SKZE/+waVEKDKOL0gIiW9oSuMesNHieNoJt/2GkJ18pIYgv8HB9aNGZWbSHu4BsiIvf/ytRO3uYeps+TkjRiv2zi5lOb0qCQy/d3+fY5SgA0p9OXauGbR5UZicDTy5fd7+zq/j8AjKPUWysFNZDXDr3RGYgWYDFc7N1Ae3mchKWfEiGZtDQcMjaT/JFInD7gJEg7IWh7CaG+h4yKPQbQ5c67DDQ7HrgOHn90vzti9WE8GGF2UAncYdCJpxV1GasBw6Gr5RRAh55WsUWABCuT3foMLvEa9JjJfi8dyxmkC1JwMo5A3674QAwpcBcdbc+CqusD9V+S9Ojpdg/AEnOASm9bUL8eCJfCd/4Fi8mby+G8//08eB6TkM/gVsrTNvnB194RY6w12i1F30tHAzQkX4QgHzyNGyGYl2dL4gH0BBQpnTgDIJO/OzPnYa2h4FESywQ10+geS/N+BodDvpM/BjfIbt6Ey3PA1SkoTAxT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28-Jul-26 11:44 PM, Andrew Morton wrote:
> On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> 
>> This patchset introduces pghot, a subsystem for hot page tracking and
>> promotion.
> 
> Can DAMON be used to do this sort of thing adequately?

That really depends on the goal I believe, let me expand...

DAMON can indeed migrate hot pages today via DAMOS_MIGRATE_HOT, and
IIUC it can even do promotion and demotion together that auto-tunes
to a target node utilization. So for someone who wants to write a
per-workload, per-process tiering policy from user space, DAMON is a
good fit and I don't think pghot competes with it there.

But the intent behind pghot isn't really to be another migration
policy. It is to build a common in-kernel infrastructure that can act
as a single promotion subsystem, fed by multiple sources, with the
promotion engine and its heuristics (rate limiting, dynamic threshold)
living in one place rather than in the scheduler. Hint faults are just
the first source. The IBS Memory Profiler, which gives access
information directly from the hardware, is the other one. CXL HMU can be
another potential source. Hence the design centers on an exact, per-PFN
record that any of these sources can update, rather than on sampling.

The per-page, source-driven model is where the two differ the most.
DAMON estimates hotness by sampling one page per region per interval,
which is low overhead and self-contained, but it may miss a hot page
inside a region. pghot records every reported access at PFN granularity,
so it does not miss, but in turn it relies on a source to report the access.

The other practical difference is that pghot works with no user-space
agent at all. With numa_balancing=2 the promotion just happens, and in
fact pghot takes over the mode-2 promotion path that currently sits in
the scheduler. DAMON, outside of its built-in modules, expects a
controller in user space to drive it, IIUC.

So I would see DAMON and pghot as complementary rather than one replacing
the other. In fact DAMON could well become one of the sources feeding
pghot, and conversely pghot's batched, rate-limited engine could serve
as a migration backend.

> 
> Thanks, I'll await review input on this.
> 
> AI review had much to say:
> 	https://sashiko.dev/#/patchset/20260728054356.291998-1-bharata@amd.com

Thanks, will address those comments.

Regards,
Bharata.


