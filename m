Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 777EDC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 05:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460E66B007B; Mon, 10 Aug 2026 01:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438E26B008A; Mon, 10 Aug 2026 01:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F956B008C; Mon, 10 Aug 2026 01:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 094836B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:36:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6687D14069E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:35:59 +0000 (UTC)
X-FDA: 85084248438.04.A725B92
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010016.outbound.protection.outlook.com [52.101.85.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2331018000D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:35:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZuvqV48u;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.85.16 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786340156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPvcOG1mqk2MrFtX+rajhO5VaxdtCZuhnRBMtgauX+I=;
	b=pXL1Z4KRUleS4PkJpP/eui7/2OtYjAyjO00DRLfV9/lCBK8dShOzb9aO5wWyo0zevf1mqA
	ShFF2yhkJtOoIirr+Fm251ipabDrd0m5Mt5jdcb3kcYNffjOSCFO+HkvTWpHIUjeqRIcWt
	mXena7AMznxDMWpoFjc+KozSI3jNXpg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786340156;
	b=sNC1xgXLH8ZIkUf0hfA1zq1Oee+HKjeYTucWqVaqtDRo735pjP7Zv0tjzCzxUMCHUviRen
	9p9EtCCalOqRnj1Q3PbRP4qTmo+NJTI3XWglU/GVsUTsoQvmr82FxdvyNDF2QRSAKUpBFQ
	nTrfFwYaiHXDLHeYZkrH24yxKie5Nsc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZuvqV48u;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.85.16 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q5tGXP3TDhmgzfvsHfkH2sxFUR2SHHdKA1qutAr/P9x/Azi9zR9VW+CPqnQHaj3AS6DEECVtNmmaLVmJ+lq/C8lG0jcUUDjCUw7PlG5nwrW0ALT4fmuAq9awIwDplMpA/wefEsYK0EON+DQl0xma7oMB+NPcWmZyx+AgFGLELb+NWsTBPWTO2sVVljfa9IdB/eLWioBHREakJqlvCcfc9YDJJlt+X5S2iv2ZZEx+aeXneRQlnBqVWj7FJ9bEWJD8EsliW3uLg2bz6ciuSlgW08SaZAwsiXShi9PUY71HcPk5TbEYobaeNB4GXIIHg2Vob6i6ryIBUgdWYfavCW0Mog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPvcOG1mqk2MrFtX+rajhO5VaxdtCZuhnRBMtgauX+I=;
 b=R5j7RtNu/vi59VpSIUxOZXNlELrE4PRFFLHLjY0udonVxKPtJIZzzbXnQyMIYOEUieyXeFz3GAcIPSFYRm8OObxXFNNlFcS9aua7cYAVafpR1Sb1xcgQ4CBlECd6gHjAPpLcUJ1RYEvEkE1FC7QMi/snlqHCtz1vYZMvoib12f8OkJT4uRZqK7s8cf7X+56IKRd+lrTXMawjhktfQXTprKyJOZTZG2aTfQwDOmfHNQaOAnKld0cIbOYf11Jecmxe9ySf2mauvkQtfbsnq+UYnQVQf+bMqVig4yjjYtuLJ83pxNphr+7tFGMfHsWVv3ulbE7YApFBzh92Wo89NjTmmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPvcOG1mqk2MrFtX+rajhO5VaxdtCZuhnRBMtgauX+I=;
 b=ZuvqV48utzeskRui5Q4IfJ+vX4J5d64pA2q741eOfxWJ7fCs9oKIEWTi7LYEAEliBRJvlDRIrd0sOAAksN1hNFvmWKF75TKvGzkY71f1Wxuk1EN+IEFqlkdg9ApKJOsNZHRwoEtneyt8ztlLuaN5/4R7cR2mj+LMNcdHseaRx/Q=
Received: from SJ0PR03CA0211.namprd03.prod.outlook.com (2603:10b6:a03:39f::6)
 by PH7PR12MB7020.namprd12.prod.outlook.com (2603:10b6:510:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 05:35:47 +0000
Received: from SJ1PEPF00001CE4.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::11) by SJ0PR03CA0211.outlook.office365.com
 (2603:10b6:a03:39f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 05:35:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF00001CE4.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 05:35:46 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 00:35:45 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 00:35:45 -0500
Received: from [10.136.47.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Mon, 10 Aug 2026 00:35:38 -0500
Message-ID: <bf4d7be1-5fb3-4d26-b6ed-4a835f77d424@amd.com>
Date: Mon, 10 Aug 2026 11:05:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
To: Matthew Wilcox <willy@infradead.org>, Yongting Lin
	<linyongting@bytedance.com>
CC: <Jonathan.Cameron@huawei.com>, <akpm@linux-foundation.org>,
	<alok.rathore@samsung.com>, <balbirs@nvidia.com>, <byungchul@sk.com>,
	<dave.hansen@intel.com>, <dave@stgolabs.net>, <david@kernel.org>,
	<donettom@linux.ibm.com>, <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
	<kinseyho@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nifan.cxl@gmail.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <shivankg@amd.com>, <sj@kernel.org>,
	<weixugc@google.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<ying.huang@linux.alibaba.com>, <yuanchu@google.com>, <ziy@nvidia.com>
References: <amjz7kIDuZH6gBx9@casper.infradead.org>
 <20260810033814.83951-1-linyongting@bytedance.com>
 <anlQp9LQw471t3YU@casper.infradead.org>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <anlQp9LQw471t3YU@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE4:EE_|PH7PR12MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: 350a15ee-630a-4d8a-8fff-08def6a13a9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|23010399003|36860700016|22082099003|18002099003|11063799006|4143699003|56012099006|3023799007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	tQ8otoUs44xbnyF8Sw6fd9Ul+Zp2Lad1A5x+zkhtUWLOYpid+JLmoz5cNUNO2v0rbkEBzbD7RuODstyV4ZE9Huw1h684qXxL4WNh2xqeiy34NtXfxDbBeKjhz5120b6RD6e2YLCOPlNOt1q/v4oSvoZVVsv7JPZJsLAx9mkQH87ap702l576iMZ8ZEdN3nzVz0OQwK36VGlvv/2HUAbd2tHWpwfska7Yw5IG8UB/tbc3DdnpivFvQbfeGSv6GBVwU6/KSF6wSNZ2tZxnRkHb5EJjuajLkOnZpFQ2tknMxVr61ssHWo+vrYEUi1VcXjxvFLRbCY8Nv4uIiM6ogsjInr2rAhoR1hVeIkal9L5TlVTYvaINtIXQ0+QWgQ6Od5Su32TgoZA6H9dvaR50sSir0uU5CubNLp59xBUvSYJ5hBcqOzTrHMid17CeaMMvXN0sdBbmvGusymnrahDMyU0tIucDxnaLkpP+uqPA4IcIawJhxAiK1MrG+kyohZtYAvyTteNtFccfw5IDBYrxrIH0G3ptZCbku3ks/xmzF31vNClSN9FaLyC3Y6FjhsMgi+Pm5pFJipjd5pHyox/28fqYtrwM/NJ4maXmd1bRScKwWR7znp9cALSklcdulGi5u4L/sGXQngdxjRnPwd2u+uUMbIcG9puIkhh/xrTwSHeDvFHbi11XqEBAULLw9CQ0hnAWs8IXsC2IY+TmUt9y1qfhTw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(23010399003)(36860700016)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(3023799007)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M1i6wRrEtllj2UeV1GovUAtJhQhdijB7xnOAkp1qvuXBvy5zDVy8AGwmXs7jOnZ9koipSTQNh7N9eVNI1+feLeekaO+Slprx1dIb530mLqGQW/jejq1FjYvvDIZBM2Ls/kxevd19CEA0yX8ihou2RnVIuOq8CZisxVAA53HRHJBAcO/1NeXm7MdH8kubHCJcY6RhjTdGrVZKA8zghs8ozDL8bBPCW0HEPGQipGgKJUKAhbZa+m7OjT0MBE0XXfmkvs8qpU+Ti+XgJT4k++oMqoPuqTTmMd7Emcr06zu9wgrZUp38OxtlJFZEDHTRGXSu4SVFpAGrFriCtoI6hBB+aJGbJ5SKphH1zYTPDQ5mTrl0pSgvAB0uosNmqIXm1neF/Msm0r5ZUfYAzIIOZIMpkTSKrSkgG8nnZoNxyh9xwiFIlEpp2eyGYk6TztqQGjG6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 05:35:46.5628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 350a15ee-630a-4d8a-8fff-08def6a13a9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7020
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ioddxc6khn7ksq78ggim416m8f1mmujo
X-Rspamd-Queue-Id: 2331018000D
X-HE-Tag: 1786340156-639603
X-HE-Meta: U2FsdGVkX1+cZM90IgrRVhr1L8OHpwX3S8iwoAwGrqyvMt05WawMDSwPXkdejWxYqUukkb1tRTPtRxqLar0aA1fALT1/NmF/53ITTecwTnCiQfvKTuQegKJEqv1xxy6Wka8g1Pn8kKZE80TIaA0ItED3TrBTy7eOvJSBmq306RT+nSPxPS+w6jHzMFaKbEytMyj+FiYjOwbTwNUWYoOIgRZbqCm1C/rcQhXzjNglxH3pBI1dyGMFlWExNj7KHSPXd/H2cFLIOWCt1m4op4X9Ah/V0YU15qlhJU6a1uKq/OoKYOcmmT7KFhVibVq0BoD/0/1oqOFGV+y7QB6P4EYrs9AIDg+nCElLmA+l9/D9ieJHr/11A+rLwC9R2hERPzIqs0zLinDdNuSGWfV2Zolv8h2jIpIIrBW/AWST2g73WCnVlmp9DEpRq5LiSdXUfBSsWfC4lGynXQhTlvm1c9DxduCNnrULfjS2FxWU8jR6s626Ia2O+3wVIW9SUfmM3DLD/RrMMd3WPJtbYs83y99fLNG8zYoh+tiWrjgLX8W1UOPApvOulptCbS/If/QnpMEGXRG2MJEgVOmJ7oHKmF8n2RCchEu8TeiSFkKrDBPCEdbvBy/dwYhDWGM8fn+eowEuQGGqxJ29B1lfRP9wnFd653EOsIGjT3WCkDmZZ/Nqz688HkS3F1q/YWuxYo01WTqX6/ni29nohxJQzGURVwBIddJxzUyv4fWcoayoe8WSjjcJ3AKl0O7W+mpNMYS8YljTcCVyyvX+bY2ihJIwm8dH3qLns5Ej+u1LvyQ1gV/CCHSYkRsakWzxbaTivorrqQHiMrB/BzAt22xwg9JFWnJemsDZymzQGgtyPEvJO1DeLfzsWwok19NYmQgatz0mdRFhIGQG5z84LIwaHY0NLp0XhSW03wvi6JY4eEDzfaJw9Nu9WbKSu13+OOqV7RYu6869RIwEMWl3TErtOTv+3i2
 fbzksR2q
 WWNNKOSrDsTv+sZQBPWF7QtENyWfHNdvkhrAAHtBtYmjTnuUYEP4aRu3uCHHug8r84r7Ewzx0oxPZuhNvrL7ivYA4ijDR+xmXgIAJsV6O/kz80UNmxtqWuvp5aTO6DW36Cn4OGpVqrrTRzeqFg4WXiZaM0vGwuWZVQQCUCItngY2X5R+pO8If2Pk8gI5GXxH87KLaEN8pYq7jKXtuPBJX08ij5/eDPmAuBgH8O5fWh7w09bCmhDiKgu8/dSATDz93XwkGGt+xt19i5sQqbnEZ3D0mi4y6UtHCZYJ5vb9JnyqZt7Z6rHCwji8HZvvlyCRm3hBqkUoJl+Cr9uLinhhsXoFFxYUPxZLlKl+pM6cNHskXOt9u19wJXAKTIzULUxP/wRj9kzhNy2+2o426NdKq5gEnd5cfEJj2EJD5gswFBVfSOiLvWOLjK2ZQeAIVBqQYPZo/lL01haG6A2B6kWFLafqp6k733YMJfnkZxTg6oM45F/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10-Aug-26 9:46 AM, Matthew Wilcox wrote:
> On Mon, Aug 10, 2026 at 11:38:14AM +0800, Yongting Lin wrote:
>> On Tue, Jul 28, 2026 at 07:24:46PM +0100, Matthew Wilcox wrote:
>>> I don't think we should do this.  I don't think it's a use-case that
>>> customers actually want; I think it's something CPU vendors think their
>>> customers want.  I've said this repeatedly over the months this patchset
>>> has been in development.  I say no.
>>
>> From our perspective, this is not merely a hypothetical use case. We
>> are actively developing and evaluating CXL tiered-memory systems, and
>> expect promoting CXL-resident pages that become hot back to DRAM to be
>> a practical requirement.
> 
> But what *is* your use case?  Truly hot data ends up in L1/L2/L3 no
> matter whether it came across the ridiculously high latency CXL link or
> from regular DRAM.  So we're talking about "warm" data that's presumably
> measured in gigabytes (since current server CPUs have about half a
> gigabyte of LLC)
> 
> I see the basis for saying "this task is low priority, it gets its memory
> allocated on CXL" and "this task is high priority, it gets its memory
> allocated on DRAM".  I don't see the use case where we're trying to figure
> out that region A of this task is sufficiently warmer than region B, and so
> we want to demote region B back to CXL and promote region A back to DRAM.
> 
> I particularly don't see a case for trying to do it on single-page
> granularity.  There's just too much damn information to track.  Maybe at
> a 2MB or 1GB boundary, but not per page.

Replying to the observation about per-page tracking information...

Since pghot has seen several versions and implementations over time, things have
changed multiple times and it is also easy to miss the information about what
gets tracked per-page and how it gets used from my long cover note. Hence
pasting some info here if it helps.

How pghot works
===============
- Tracks frequency and last access time.
- Additionally, the accessing NUMA node ID (NID) for each recorded
  access is tracked in precision mode.
- These hotness parameters are maintained in a per-PFN hotness record
  within a per-section map hanging off the existing mem_section data
  structure. The map is RCU-protected and also carries a section-level
  "hot" flag used to gate scanning by kmigrated.
  - In default mode, one byte (u8) is used for the hotness record. 5 bits
    store time using a bucketing scheme representing up to 4s with
    HZ=1000. The default toptier NID (0) is used as the promotion target
    and can be changed via the vm.pghot_target_nid sysctl.
  - In precision mode, 4 bytes (u32) are used for each hotness record.
    14 bits store time, representing around 16s with HZ=1000, and the
    accessing NID is stored per-PFN as the promotion target.
- Classifies pages as hot based on configurable thresholds.
- Pages classified as hot are marked ready for migration using the ready
  bit (MSB of the hotness record in both modes).
- Per-lower-tier-node kmigrated threads periodically scan the PFNs of
  lower-tier nodes, checking the migration-ready bit to perform batched
  migrations. The scan interval and batch size are configurable via
  debugfs tunables.

Memory overhead
===============
Default mode: 1 byte per lower-tier PFN. For 1TB of lower-tier memory
this amounts to 256MB overhead (assuming 4K pages).

Precision mode: 4 bytes per lower-tier PFN. For 1TB of lower-tier memory
this amounts to 1GB overhead.

Regards,
Bharata.

