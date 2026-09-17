Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB8CC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52EC6B0092; Thu, 17 Sep 2026 01:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04376B0093; Thu, 17 Sep 2026 01:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF26D6B0095; Thu, 17 Sep 2026 01:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 800DE6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:23:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0E5D140218
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:23:39 +0000 (UTC)
X-FDA: 85222111758.28.2CCF6CC
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011059.outbound.protection.outlook.com [40.93.194.59])
	by imf13.hostedemail.com (Postfix) with ESMTP id BD14020005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:23:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=G2lDo0QZ;
	spf=pass (imf13.hostedemail.com: domain of bharata@amd.com designates 40.93.194.59 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789622617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjcQpIle4mUkeOOzrC/Nzhu6u0fdTBchXgOrRnT/q2s=;
	b=NP0vTprDZP7QejHGctK0eE+zIyVIW6gAteObmC4V6RUydo5XFFpsZvsB/xrU9FK1iJLm1u
	wpBwSP1Tf3WaupzcAL9Hrx/8bDot4qx23TJbd/L9q5yN14ayrXkvIdQ3I5Hgmv9qosShvR
	6/XeB7CgNgi2SO0H+aZA3bBBKzjTkJE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789622617;
	b=yazzRQR35sSSbflo9fMKW5LRQbcCcJRra9dz10wrZMXicOsqeOyo1qcMr9mjg5di1PQ8mc
	1mvR/kuhU/+uw9KE6iEOGJ9gtHeq8xmLphe+eGqofcg7FYoXWW5HW+7id1kZ+sJJKlVjLq
	Hedj9h+0UGc3UcQTvVN5zLSotCe3Too=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=G2lDo0QZ;
	spf=pass (imf13.hostedemail.com: domain of bharata@amd.com designates 40.93.194.59 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eP4/tIw7IWEKVM0ndQE31Zbn/exiX40wldVCCMgtqWOBRMXM4IbKqGxOg7ooYjO1DWmUwHgM9cDIdQi3ad0m8ioJjjRC4uEDX7271LdXzECzkIgLKwxtCI8vvWh8cwfCit8ySIrouxdkf3BxML5GYlUYJUdrArfcpwHPbspf+nBPdpjCf8tw6mta3LN/77NicNrcOrwCul9nisqN55mw3G1FFIbCrixTh6mU6MTQu1vcgIsjr9N5FzshmT1EM+o+XCjvYvYXmjOiOwAiXjgjsfqzA7D3IzA1Nxb5DD/NuFxBGr17/c4GlHRA1iwDpD/vQ8dNOKtbT+YjN386dvWFtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjcQpIle4mUkeOOzrC/Nzhu6u0fdTBchXgOrRnT/q2s=;
 b=S8b3CY1OhpHvgBqf8GZutd/vimxvoy6w4BsS6ZTXedWQzzgCfd2U9ZgLiyiNKUwJLnT9bcuhFmo0yEMNtrhYBOf1ukd1MSd7TTRuImOaBFBYNd0XHWu5fJ0+ZoL5NCCBpdhLhm7DpQBfZvO4tatrvEVFhFRWrow2gnn2cwB5u+kqYkIwvAaDtyLMAHnsDZM1yzJrpCPb4G1Nk8tyMuWn7bEcY6RrkqMD6a66uiyGHqnx4RkDAfVKcn0ERJF52In+gtlXEOvPjiLFY6jBdm2EH7wU4e20TzLmRCw2DB31A39AU6QAGHtqji4WknnaZvOh2tH4qLyIyY6ogFT371Z3CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjcQpIle4mUkeOOzrC/Nzhu6u0fdTBchXgOrRnT/q2s=;
 b=G2lDo0QZuuu36Hih7LiOqWnYHMjZXRzuzBHhQRL6hTFYW0RadWuGgiq3SVRne2za61O3q9efbHliQfTxp3+++f71yqhZv6MbZUNWvMDC7v1OImyodoeXlezDJp14blJUX7tJD3aDTqu/aQPByN8vKw+rFCV4HTPqAIYbzUHXKoI=
Received: from SCXP298CA0159.CHLP298.PROD.OUTLOOK.COM (2603:10d6:300:14d::20)
 by IA1PR12MB6115.namprd12.prod.outlook.com (2603:10b6:208:3e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 05:23:31 +0000
Received: from MWH0EPF000C618E.namprd02.prod.outlook.com
 (2603:10d6:300:14d:cafe::a9) by SCXP298CA0159.outlook.office365.com
 (2603:10d6:300:14d::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 05:23:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000C618E.mail.protection.outlook.com (10.167.249.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 05:23:30 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 00:23:29 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 00:23:21 -0500
Message-ID: <92c26cce-0608-4c0d-bb13-fe87afc225ba@amd.com>
Date: Thu, 17 Sep 2026 10:53:19 +0530
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
References: <20260916205211.267720-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260916205211.267720-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618E:EE_|IA1PR12MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: 717d4ca0-167a-4875-40bd-08df147bcf68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|1800799024|23010399003|10067099003|11063799006|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QKgCfi+dutYGf47/sjF777b+xW/z9o9iCAKynJXATxJiHISsd/MuWm4QHhVM9LnbdHoT5qNy3WgpZXeh36JU6nloAvLRTPo7neE9ukPtY1oglX15BOgRnoCd83t99TXtCIgA79+GJrceXWjqn9syQhgjQ+ffDJ+aOW2G+AhDaRU6/Ud5uTzhYCqN8GtqbVJlgse8+8L6reVyjW6x3upw1z1L8Q8DEyW9fK4AM1Eze+jIbtCsLLTL7Y2F3C0SEwvkShzL7aDdpPL4iEiqlgfTzgaOBwWFBOCL1ik8HrwiYgtp1h6GNxW0USeYADjHcsmc5sQqN1+kIAcXKTSGEl/iRePKo5wN62La58sRrRuTFIA51Ub+Fhn6ZqAYi+Sjs3Rh/wjK8L7E+3SDLjZFlMOZDoqfA74xBWG4yEPu1TOM3T+WwB+AWys8oRMtn5EvxajbHMDjeqjCq7PQZFlDzZ70rtaq404RtFTWij+hHb2zaR8vGdJI3xI7MMV0bsVf8jOj8E8hfdk50cb0eNUzywo6jYWEHsToBb9zhPy+5Sr2K92zgD1suENfa34PgJlhtRO50RIQOgu8VecnMuEuo9jU4dWHGNKyocDHBHduPZxZ2oa6ES1kQGOewRS8g2QtsHi8qVIr1aV+3APVuy2nIyWnEzbhX/gDaf58SI026aUFvAiuBytlTNnJ+a3DdMYw/C1T6hiaPVYQKYp3VQ6z4TpLfA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EwPEDyIH3OebCaHgfELjTzzyg1h5EF7pYgZVLUxmwMI1tJ46iOv/fSZ5d+PBAue7JuAQD929oBDcwpbnFcwL5/s2+eIb8rtOaRKGlDoqAG7xlA0raGV4SGUOK4TIB525w7a0+Iy/AyaitG+EhdUp8CdnBy1zGPVzahLfyzDNyJFSCIlaKwB3TAtXVr7fEP+udIudVq1FFAVkbKQFsDeysEFH/sN9/Lv5G76qiTrstJcDUKlrQuBevTv/7keQ4jk6AozEJH2tIAvycP00eUTwnYpRKA7Wu0IaN1h7qJN3emd8DJ9PXlaX3WZK4HWOK+A7qpbNvRKSkMyS7NwOkkobghQwCFIGUM+wcYCHLJh8H1+8961PM7F4jKRZic69jIIkt/nxhu9x/9tRGwpjImkdo1tenJW5vn+MjuUWWG9jyZP49VuTrRCx9rvcdGWCfhZ9
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 05:23:30.1830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 717d4ca0-167a-4875-40bd-08df147bcf68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6115
X-Stat-Signature: ge8h4ctqo367nwm31ist6uc5dexooo1e
X-Rspam-User: 
X-Rspamd-Queue-Id: BD14020005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789622616-268065
X-HE-Meta: U2FsdGVkX19isqMT33Qw3LAdxRiU/xwWI5BX1l01IQCnr7VQao8R8HoxPWdS0tjWUyCg0cQttYqvmSFn3TYJN4HSaE3BD2zztxKPmkaT2lq8NM/FTAQEy0puZ298cX7LLvjfiJLXdCMpnhSGjRto2p9k+Vl9WvzgmiNIoLNGCQql9EWtDcbdGTK5kMTxeCbmdvxdhmYh3b6y/D6rwwUatlKOYf4eW/XZbt5fWeLWNfpIe3ihuEo/yygvhy3Ri4dNyLNnCEivgiFDLySHG1NTOWKS7m8HhZtR3AQZL6t/aZzxySjER4GyeMzJJjRvy7vo0ls7swxMb1OxWC8yiBduWGMrTKXkAZbMEkI4rrvhSNB4+K+uLZu6ltKeco5F3df7PWrVL7cRX+FDCQHx9WeED8OWCE/6q3lwjd/yfzulvbYfDqI+BzhQPq3mdAf3aN1zSCYQFZAzC1674cT7nJVfyRy7hgGBcFequUZIRNGp/ntCRGrYfoaCH9/8ZMBOh6bjzVe3DMpHYO0QP+ZMt36Q8eRhFvf125rWmS1auPw1Bzeo8gErcm+88H+JHyAceca51Y7UIBf1+slV4yzOs6wii81Znd+hQz3hOzWwecvVojSf5pIkbxP4GZkxbqpN7BuJ15ti8Z8oNV4w62GqFMZfDEy3cISSaNwCxhCrBvMOOd+UP0y2CnErynkDHswb6DTyGKHRSQadj3/SyIgqYnRectNENXYTAUHg9w3paWAmavpuPEozHBJ1SQ5XbR+vYEHBM6VSyfCigW6WXmj1DXSjY7VKKJ7XlwumcbL6O8ahOLWV/rlbXGvzLouBga5/pAbCmbu4l9w2gNqhkNuydTbhxoJbe16cHda+1omt/MVtmsLY3cPgSSxN0tUVUBQ3Lhtx88qmCKmcTi14mAnjZoT32GUracHGGPsHc2YlqRadDa3FSenGloqkoMhURUvbxHslUjdrITHfZaAzff2dH8k
 V7nS47je
 jqOiOwMTmpFZwuD8y8p3Txae+FtjWb7q6/O46Fxf9R10aAe1E3Ozto1xtU0/2FDgfukEDDwFMU29qmldt6Dt6e6OrI+kEbEFizdT6Z5hzkXccChfFg2EBotukDEOZ/HWWlisLGedmORBpbDJVo1GRICrV2v1OQFzCM1NEofC1gHOT9F2ghgidCNI6Uen0+5hI0/2jEKbULcZnelyPylWzVYMC3dA4s/xWnpFmLRCgdhj34+jcFbvqxd7pvqRmlA4Mx7yx4dDBxWT7lz7V90P4xy5Iz7p5/EHzi8Ds0W/1aR1cUlohsWpgAKgluEgyd/OltpteSx4zGcowThhQmpmelRhQLr6KlWmYL5cowqQJNE5zl0pif81XT80Vvw4x4S3cSw0cx1UFxDmKHvXTGTfpnSePbZhj6vAlQ3IS1medsJazHm6k8ORbO0cvaUqx8Y6F/NmSYUZ+k5FUwpSgVCItGaujuc4MWZ+DBGwi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17-Sep-26 2:22 AM, Joshua Hahn wrote:
> On Wed, 16 Sep 2026 08:38:17 +0530 Bharata B Rao <bharata@amd.com> wrote:
> 
>> On 12-Sep-26 2:38 AM, Joshua Hahn wrote:
>>> Hi Bharata,
>>>
>>> We've been testing pghot in a Meta kernel with worklaods to try and see
>>> what the performance characteristics look like. I wanted to report
>>> some of the findings that we've found in our testing. Note that these
>>> results are from a modified kernel that has my tiered memcg series [1]
>>> backported, as well as Gregory's numa balancing scanning fixes [2]
>>> as well. 
>>
>> Hi Joshua,
>>
>> Thanks for testing pghot with your workload!
>>
>>>
>>> - Without tuning and using the default tunables that pghot comes with,
>>>   we've found around a slight performance regression against raw NUMAB2.
>>>   This was being run on a host with 750G DRAM and 250G CXL.
>>
>> pghot promotes on 2nd access by default since pghot_freq_threshold is 2
>> by default. This will result in slower promotions compared to NUMAB2
>> which promotes on 1st access. Could you please try with setting
>> pghot_freq_threshold to 1? I think I should make the default as 1 going
>> forward.
> 
> Gotcha. Out of curiosity, I'm wondering why you decided to make this a
> tunable. Specifically, I'm wondering if there are any workloads that
> benefit from making it require a second access. To me keeping it at
> first access makes a lot of sense. Obviously you could say that
> scanning workloads would want to use 2 accesses, but there should be
> other ways to prevent that from happening rather than counting the
> number of accesses before promotion. Just my 2c.

The basic idea is to consider two factors for determining the page hotness: the
frequency of access and the recency of access. Hence I have kept both of them as
configurable so that users can tune them for their workloads.

However since the immediate comparision of pghot-hintfaults source is with
existing NUMAB2, it makes sense to have the default freq as 1 to get closer to
apples-to-apples comparision by default.

> 
>> In any case, will it be possible to provide more information on what your
>> workloads are, and the exact performance metrics? Any representative workload
>> that can be substituted to reproduce this behaviour can also help.
>>
>> And when you say slight perf regression, how much is it exactly?
> 
> I'm seeing that average latency is about 20% higher and p99 latency
> is about 5% higher.

I hope this gap should get closed with pghot_freq_threshold=1.

> 
>>> Finally, we've seen some issues with pghot causing userspace crashes,
>>> which leads us to believe that there might be some bugs that manifest
>>> in userspace as well (we have not been able to find out where in pghot
>>> these bugs are introduced).
>>
>> That's something I have never seen till now with any of the benchmarks that I
>> have run. Any kernel messages attributing the failure to pghot? Anything
>> attributable to access reporting or  kmigrated threads?
> 
> We're doing A/B testing with NUMAB2 only and pghot, and we are seeing
> the userspace crashes in the pghot host only. It seems like there
> are some segfaults trying to reference ip 000... and a warning that
> references "Too many tries to read user space".
> 
> I don't have anything in particular that would direct us right to pghot,
> but this crash has repeatedly come up, only on pghot (across reboots)
> and not on our NUMAB2 worklods. 

When you find out more about this failure, please let me know.

Regards,
Bharata.

